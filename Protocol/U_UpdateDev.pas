unit U_UpdateDev;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,IdTCPServer, 
  Dialogs, StdCtrls, ExtCtrls,DateUtils,U_MyFunction, U_Hex, U_Main, U_Protocol;

const
    file_cmd_begin    = $10;//��ʼ
    file_cmd_tran     = $11;//����
    file_cmd_read_map = $12;//����
    //file_cmd_sum      = $13;//У��
    file_cmd_use      = $14;//��ʼʹ���³���
    file_cmd_end      = $15;//����

    file_flag_update          = $08;//��������
    file_flag_read_fram       = $09;//����FRAM
    file_flag_read_dataflash  = $0a;//����DataFlash

    file_atrr_update      = $01;//�ļ�����

    file_reboot_flag_enable  = $01;//����
    file_reboot_flag_disable = $00;//������
    
Type
  PFileHeader = ^TFileHeader;
  TFileHeader = packed record
    fileFlag:Byte;
    fileAttr:Byte;
    fileCmd:Byte;
    fileSegCount:Word;    //����
  end;

//�����Ϣ
type
  TPackageInfo = record
    bSend:boolean;//�Ƿ��Ѿ����ͣ��ѷ��͸�true�������Ƿ���գ�����Ϊtrue
    SegID:integer;//��i�α�ʶ��ƫ�� 2byte
    Lf:integer;//��i��ʵ�ʴ������ݳ���Lf  2byte
    Dataf:array of byte;//�ļ����� [0..99]
    nSendCounter:Byte;//��¼�öεķ��ʹ���
  end;

type TFileType = (ftBin, ftHex);
type
  //�߳�����
  T_UpdateDev=Class(TThread)
  private

    fileSegCount: Integer;//�ܶ���   2byte   Ӳ���ռ������ʵ�ʴ�������п��ܱ���С
    fileSegLen:   Integer;//�γ���   2byte
    fileCurPos:   Integer;//��ǰ���ͻ���յİ��±�
    m_sendPackage:array of TPackageInfo;    //���Ͱ���  [1..80] �������ܰ�������̬�����С

    m_bStop:Boolean;
    m_bReadMapFlag:Boolean;
    m_nSendCounterForMap:Integer;
    m_nSendForMapCount:Integer;
    m_nFailedCount:Integer;   //ȷ������ʧ�ܴ���
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
    function GetFileSum():Byte;//У���
    function GetFileXor():Byte;//У�����
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

function T_UpdateDev.GetFileSum():Byte;//У���
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

function T_UpdateDev.GetFileXor():Byte;//У�����
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
    buf[p] := fileSegLen;         Inc(p);//�γ���   2byte
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
        if respOK=0 then//��ʼ����
        begin
            //F_Operation.DisplayOperation(Format('����ȷ��',[]));
            MyPostMessage(WM_UPDATE_START_OK);
        end
        else//����ʧ��
        begin
            //F_Operation.DisplayOperation(Format('��������',[]));
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
            if IsSendAll(fileCurPos+1) then //�ȵ���ǰ�ִη����꣬�ٷ�����һ�ִ�
            begin
                fileCurPos := -1; // ��λ���ط�
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

    buf[p] := fileSegLen;         Inc(p);//�γ���   2byte
    buf[p] := fileSegLen shr 8;   Inc(p);
    //����ɾ���ˡ���������ť������Ӷ��У��
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

    buf[p] := m_sendPackage[fileCurPos].SegID;         Inc(p);//��i�α�ʶ��ƫ�� 2byte
    buf[p] := m_sendPackage[fileCurPos].SegID shr 8;   Inc(p);

    buf[p] := fileSegLen;         Inc(p);//�γ���   2byte
    buf[p] := fileSegLen shr 8;   Inc(p);
    
    buf[p] := m_sendPackage[fileCurPos].Lf;         Inc(p);//��i��ʵ�ʴ������ݳ���Lf  2byte
    buf[p] := m_sendPackage[fileCurPos].Lf shr 8;   Inc(p);

    MoveMemory(@buf[p],@m_sendPackage[fileCurPos].Dataf[0],m_sendPackage[fileCurPos].Lf); //�ļ�����
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
            //����
            fileCurPos := i;
            Inc(m_sendPackage[i].nSendCounter);
            if m_sendPackage[i].nSendCounter>m_nFailedCount then //���ʹ���������Ϊ��·���豸�����⣬�˳�������
            begin
                m_bStop := True;
                Result := False;
                Exit;
            end;
            if MakeTranFrame() then
            begin
                //F_Operation.DisplayOperation(Format('���Ͷ�%.3d',[fileCurPos]));
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

    buf[p] := fileSegLen;         Inc(p);//�γ���   2byte
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

        //���
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