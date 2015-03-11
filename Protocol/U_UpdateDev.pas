unit U_UpdateDev;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,IdTCPServer, 
  Dialogs, StdCtrls, ExtCtrls,DateUtils,U_MyFunction, U_Hex, U_Main, U_Protocol;

const
    file_cmd_begin    = $10;//开始
    file_cmd_tran     = $11;//传输
    file_cmd_read_map = $12;//读表
    //file_cmd_sum      = $13;//校验
    file_cmd_use      = $14;//开始使用新程序
    file_cmd_end      = $15;//结束

    file_flag_update          = $08;//升级程序
    file_flag_read_fram       = $09;//下载FRAM
    file_flag_read_dataflash  = $0a;//下载DataFlash

    file_atrr_update      = $01;//文件属性

    file_reboot_flag_enable  = $01;//重启
    file_reboot_flag_disable = $00;//不重启
    
Type
  PFileHeader = ^TFileHeader;
  TFileHeader = packed record
    fileFlag:Byte;
    fileAttr:Byte;
    fileCmd:Byte;
    fileSegCount:Word;    //段数
  end;

//组包信息
type
  TPackageInfo = record
    bSend:boolean;//是否已经发送，已发送给true。或者是否接收，接收为true
    SegID:integer;//第i段标识或偏移 2byte
    Lf:integer;//第i段实际传输数据长度Lf  2byte
    Dataf:array of byte;//文件数据 [0..99]
    nSendCounter:Byte;//记录该段的发送次数
  end;

type TFileType = (ftBin, ftHex);
type
  //线程声明
  T_UpdateDev=Class(TThread)
  private

    fileSegCount: Integer;//总段数   2byte   硬件空间段数，实际传输段数有可能比它小
    fileSegLen:   Integer;//段长度   2byte
    fileCurPos:   Integer;//当前发送或接收的包下标
    m_sendPackage:array of TPackageInfo;    //发送包组  [1..80] ，计算总包数，动态分配大小

    m_bStop:Boolean;
    m_bReadMapFlag:Boolean;
    m_nSendCounterForMap:Integer;
    m_nSendForMapCount:Integer;
    m_nFailedCount:Integer;   //确定升级失败次数
    m_chk_auto_reboot:Boolean;
    m_nInterval:Integer;

    m_ProTx: T_Protocol;
    
    m_ip:string;
    m_port:Integer;

    function IsSendAll(fromIndex:Integer=0):Boolean;
    function MakeBeginFrame():Boolean;
    function MakeTranFrame():Boolean;
    function MakeMapFrame():Boolean;
    function MakeEndFrame():Boolean;
    function MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
    function SendData(pBuf:PByte; len:Integer):Boolean;
    function ParseUpdate(pDataUnit:PByte; dataUnitLen:Integer):Boolean;
    function SendUpdateData():Boolean;
    function GetFileSum():Byte;//校验和
    function GetFileXor():Byte;//校验异或
    function MyPostMessage(Msg:Cardinal; wParam:Integer=0; lParam:Integer=0):Boolean;
  Published
  protected
    procedure Execute;override;
  public
    constructor Create();
    destructor Destroy; override;
    function LoadUpdateFile(strFileName:string; fileType:TFileType=ftBin):Boolean;
    function SetIpPort(ip:string=''; port:Integer=0):Boolean;
    function StartUpdate():Boolean;
    function StopUpdate():Boolean;
    function PauseUpdate():Boolean;
    function ResumeUpdate():Boolean;
    function ParseData(proto:T_Protocol):Boolean;
  end;

implementation

constructor T_UpdateDev.Create();
begin
    FreeOnTerminate := False;
    inherited Create(False);
    m_ip := '';
    m_port := 0;
    m_chk_auto_reboot := True;
    m_nInterval := 2000;
end;

function T_UpdateDev.GetFileSum():Byte;//校验和
var i,j:integer;
    fileSum:Byte;
begin
    fileSum:=0;
    for i:=low(m_sendPackage) to high(m_sendPackage)do
    begin
        for j:=low(m_sendPackage[i].Dataf) to high(m_sendPackage[i].Dataf) do
        begin
            fileSum:=ord(fileSum)+m_sendPackage[i].Dataf[j];
        end;
    end;
    result := fileSum;
end;

destructor T_UpdateDev.Destroy;
begin
    Terminate();
    inherited;
end;

function T_UpdateDev.GetFileXor():Byte;//校验异或
var i,j:integer;
    fileXor:Byte;
begin
    fileXor:=0;
    for i:=low(m_sendPackage) to high(m_sendPackage)do
    begin
        for j:=low(m_sendPackage[i].Dataf) to high(m_sendPackage[i].Dataf) do
        begin
            fileXor:=ord(fileXor) Xor m_sendPackage[i].Dataf[j];
        end;
    end;
    result:=fileXor;
end;

function T_UpdateDev.SendData(pBuf:PByte; len:Integer):Boolean;
begin
    Result := False;
    if (m_ip<>'') and (m_port<>0) then
    begin
        F_Main.SendData(pBuf, len, m_ip, m_port);
        Result := True;
    end
    else
    begin
        F_Main.SendDataAuto();
        Result := True;
    end;
end;
    
function T_UpdateDev.MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
begin
    Result := m_ProTx.MakeFrame(AFN, Fn, pDataUnit, len, Pn, IS_COMM_MODULE_ID_PLC);
end;

function T_UpdateDev.MakeBeginFrame():Boolean;
var buf:array[0..2047]of Byte;
    p:Integer;
begin
    p := 0;
    buf[p] := file_flag_update;     Inc(p);
    buf[p] := file_atrr_update;     Inc(p);
    buf[p] := file_cmd_begin;       Inc(p);
    buf[p] := fileSegCount;         Inc(p);
    buf[p] := fileSegCount shr 8;   Inc(p);
    buf[p] := fileSegLen;         Inc(p);//段长度   2byte
    buf[p] := fileSegLen shr 8;   Inc(p);
    MakeFrame(AFN_UPDATE_SELF,F1,@buf[0],p);
    SendData(m_ProTx.GetFrameBuf(), m_ProTx.GetFrameLen());
end;

function T_UpdateDev.ParseData(proto:T_Protocol):Boolean;
begin
    if (proto.GetAFN() = AFN_UPDATE_SELF) and (proto.GetFn() = F1) then
    begin
        ParseUpdate(proto.GetDataUnit(), proto.GetDataUnitLen());
    end;
end;

function T_UpdateDev.ParseUpdate(pDataUnit:PByte; dataUnitLen:Integer):Boolean;
var pData:PByte;
    i,p:Integer;
    fileCmdResp,respOK:Byte;
    strConten:string;
begin
    Result := True;

    pData := pDataUnit;
    if dataUnitLen<3 then Exit;

    Inc(pData,2);
    fileCmdResp := pData^;
    if fileCmdResp = file_cmd_begin then
    begin
        if dataUnitLen<8 then Exit;
        Inc(pData,5);
        respOK := pData^;
        if respOK=0 then//开始升级
        begin
            //F_Operation.DisplayOperation(Format('升级确认',[]));
            MyPostMessage(WM_UPDATE_START_OK);
        end
        else//升级失败
        begin
            //F_Operation.DisplayOperation(Format('升级否认',[]));
            MyPostMessage(WM_UPDATE_START_ERROR);
        end;
    end
    else if fileCmdResp = file_cmd_read_map then
    begin
        if dataUnitLen<8 then Exit;
        Inc(pData,5);
        for i:=Low(m_sendPackage) to High(m_sendPackage) do
        begin
            if (pData^ shr (i mod 8) and $01)>0 then
            begin
                m_sendPackage[i].bSend := True;
            end
            else
            begin
                m_sendPackage[i].bSend := False;
            end;
            if ((i+1) mod 8 = 0) then
            begin
                Inc(pData,1);
            end;
        end;
      
        if not IsSendAll() then
        begin
            if IsSendAll(fileCurPos+1) then //等到当前轮次发送完，再发送下一轮次
            begin
                fileCurPos := -1; // 复位，重发
            end;
        end;
    end;
end;

function T_UpdateDev.MakeEndFrame():Boolean;
var buf:array[0..2047]of Byte;
    p:Integer;
begin
    p := 0;
    buf[p] := file_flag_update;     Inc(p);
    buf[p] := file_atrr_update;     Inc(p);
    buf[p] := file_cmd_end;         Inc(p);
    buf[p] := fileSegCount;         Inc(p);
    buf[p] := fileSegCount shr 8;   Inc(p);

    buf[p] := fileSegLen;         Inc(p);//段长度   2byte
    buf[p] := fileSegLen shr 8;   Inc(p);
    //由于删除了“升级”按钮，这里加多个校验
    buf[p] := GetFileSum();         Inc(p);
    buf[p] := GetFileXor();         Inc(p);

    if m_chk_auto_reboot then
    begin
        buf[p] := file_reboot_flag_enable;         Inc(p);
    end
    else
    begin
        buf[p] := file_reboot_flag_disable;        Inc(p);
    end;

    MakeFrame(AFN_UPDATE_SELF,F1,@buf[0],p);
    
    Result := SendData(m_ProTx.GetFrameBuf(), m_ProTx.GetFrameLen());
end;

function T_UpdateDev.MakeTranFrame():Boolean;
var buf:array[0..2047]of Byte;
    p:Integer;
begin
    p := 0;
    buf[p] := file_flag_update;     Inc(p);
    buf[p] := file_atrr_update;     Inc(p);
    buf[p] := file_cmd_tran;        Inc(p);
    buf[p] := fileSegCount;         Inc(p);
    buf[p] := fileSegCount shr 8;   Inc(p);

    buf[p] := m_sendPackage[fileCurPos].SegID;         Inc(p);//第i段标识或偏移 2byte
    buf[p] := m_sendPackage[fileCurPos].SegID shr 8;   Inc(p);

    buf[p] := fileSegLen;         Inc(p);//段长度   2byte
    buf[p] := fileSegLen shr 8;   Inc(p);
    
    buf[p] := m_sendPackage[fileCurPos].Lf;         Inc(p);//第i段实际传输数据长度Lf  2byte
    buf[p] := m_sendPackage[fileCurPos].Lf shr 8;   Inc(p);

    MoveMemory(@buf[p],@m_sendPackage[fileCurPos].Dataf[0],m_sendPackage[fileCurPos].Lf); //文件数据
    Inc(p,m_sendPackage[fileCurPos].Lf);

    MakeFrame(AFN_UPDATE_SELF,F1,@buf[0],p);

    Result := SendData(m_ProTx.GetFrameBuf(), m_ProTx.GetFrameLen());
end;

function T_UpdateDev.SendUpdateData():Boolean;
var i:Integer;
begin
    Result := True;
    
    for i:=fileCurPos + 1 to High(m_sendPackage) do
    begin
        if not m_sendPackage[i].bSend then
        begin
            //发送
            fileCurPos := i;
            Inc(m_sendPackage[i].nSendCounter);
            if m_sendPackage[i].nSendCounter>m_nFailedCount then //发送次数超，认为链路或设备出问题，退出升级。
            begin
                m_bStop := True;
                Result := False;
                Exit;
            end;
            if MakeTranFrame() then
            begin
                //F_Operation.DisplayOperation(Format('发送段%.3d',[fileCurPos]));
                Inc(m_nSendCounterForMap);
                if ((m_nSendCounterForMap>0) and (m_nSendCounterForMap mod m_nSendForMapCount=0)) then
                begin
                    m_bReadMapFlag := True;
                    MyPostMessage(WM_UPDATE_READ_MAP);
                end
                else
                begin
                    MyPostMessage(WM_UPDATE_SEND_DATA);
                end;
            end;
        end;
    end;
end;

function T_UpdateDev.MakeMapFrame():Boolean;
var buf:array[0..2047]of Byte;
    p:Integer;
begin
    p := 0;
    buf[p] := file_flag_update;     Inc(p);
    buf[p] := file_atrr_update;     Inc(p);
    buf[p] := file_cmd_read_map;    Inc(p);
    buf[p] := fileSegCount;         Inc(p);
    buf[p] := fileSegCount shr 8;   Inc(p);

    buf[p] := fileSegLen;         Inc(p);//段长度   2byte
    buf[p] := fileSegLen shr 8;   Inc(p);

    MakeFrame(AFN_UPDATE_SELF,F1,@buf[0],p);

    Result := SendData(m_ProTx.GetFrameBuf(), m_ProTx.GetFrameLen());
end;

function T_UpdateDev.MyPostMessage(Msg:Cardinal; wParam:Integer=0; lParam:Integer=0):Boolean;
begin
    PostThreadMessage(ThreadID, Msg, wParam, lParam);
    Result := True;
end;

procedure T_UpdateDev.Execute();
var i:Integer;
    nFailedCounter:Integer;
    msg:TMsg;
begin
    while not Terminated do
    begin
        Sleep(50);

        PeekMessage(msg, INVALID_HANDLE_VALUE, WM_UPDATE_START, WM_UPDATE_END, PM_REMOVE);
        
        if m_bStop then
        begin
            Continue;
        end;
        
        case msg.message of
          WM_UPDATE_START:
            begin
                MakeBeginFrame();
            end;
          WM_UPDATE_START_OK:
            begin
                MyPostMessage(WM_UPDATE_SEND_DATA);
            end;
          WM_UPDATE_START_ERROR:
            begin
                m_bStop := True;
            end;
          WM_UPDATE_SEND_DATA:
            begin
                if IsSendAll(fileCurPos+1) then
                begin
                    MyPostMessage(WM_UPDATE_READ_MAP);
                end
                else
                begin
                    SendUpdateData();
                    Sleep(m_nInterval);
                end;
            end;
          WM_UPDATE_READ_MAP:
            begin
                MakeMapFrame();
                Sleep(m_nInterval);
                if not IsSendAll() then
                begin
                    MyPostMessage(WM_UPDATE_SEND_DATA);
                end
                else
                begin
                    MyPostMessage(WM_UPDATE_END);
                end;
            end;
          WM_UPDATE_END:
            begin
                MakeEndFrame();
                Sleep(m_nInterval);
            end;
        end;
    end;
end;

function  T_UpdateDev.IsSendAll(fromIndex:Integer=0):Boolean;
var i:Integer;
begin
    Result := False;
    for i:=fromIndex to High(m_sendPackage) do
    begin
        if not m_sendPackage[i].bSend then
        begin
            Exit;
        end;
    end;
    Result := True;
end;

function T_UpdateDev.StartUpdate():Boolean;
var i:integer;
begin
    m_bStop := False;
    m_nSendCounterForMap := 0;
    m_bReadMapFlag := False;
    fileCurPos := -1;
    for i:=low(m_sendPackage) to high(m_sendPackage) do
    begin
        m_sendPackage[i].bSend := False;
        m_sendPackage[i].nSendCounter := 0;
    end;
    Resume();
    MyPostMessage(WM_UPDATE_START);
end;

function T_UpdateDev.StopUpdate():Boolean;
begin
    m_bStop := True;
    Result := True;
end;

function T_UpdateDev.PauseUpdate():Boolean;
begin
    Suspend();
    Result := True;
end;

function T_UpdateDev.ResumeUpdate():Boolean;
begin
    Resume();
    Result := True;
end;

function T_UpdateDev.LoadUpdateFile(strFileName:string; fileType:TFileType=ftBin):Boolean;
var hexBuf:array of Byte;
    hexLen:Integer;
    i,j,p,nlen:integer;
    fileSum:Word;
begin
    Result := False;
    SetLength(hexBuf, 1024*1024);

    case fileType of
      ftBin:
        begin
            Result := LoadBinFile(strFileName, hexBuf, hexLen);
        end;
      ftHex:
        begin
            LoadHexFile(strFileName, hexBuf, hexLen)
        end;
      else;
    end;

    if Result then
    begin
        hexLen := CutFFFromEnd(@hexBuf[0],hexLen);

        if hexLen mod fileSegLen = 0 then fileSegCount:=hexLen div fileSegLen
        else fileSegCount := hexLen div fileSegLen+1;
        SetLength(m_sendPackage,fileSegCount);

        //组包
        p := 0;
        for i:=low(m_sendPackage) to high(m_sendPackage) do
        begin
            m_sendPackage[i].bSend := False;
            m_sendPackage[i].SegID := i;
            if i=high(m_sendPackage) then m_sendPackage[i].Lf := hexLen-fileSegLen*i
            else                        m_sendPackage[i].Lf := fileSegLen;
            SetLength(m_sendPackage[i].Dataf,m_sendPackage[i].Lf);
            for j:=low(m_sendPackage[i].Dataf) to high(m_sendPackage[i].Dataf) do
            begin
                m_sendPackage[i].Dataf[j] := hexBuf[p];
                Inc(p);
            end;
        end;
    end;
    
    fileSum := 0;
    for i:=0 to hexLen-1 do
    begin
        fileSum := fileSum + hexBuf[i];
    end;
    
    SetLength(hexBuf, 0);
end;

function T_UpdateDev.SetIpPort(ip:string=''; port:Integer=0):Boolean;
begin
    m_ip := ip;
    m_port := port;
end;

end.