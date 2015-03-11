unit U_Update;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,U_Hex, ExtCtrls,U_Protocol, ComCtrls, U_Operation,
  ImgList, jpeg, U_UpdateDev, U_Disp;


type
  TF_Update = class(TForm)
    dlgOpenHex: TOpenDialog;
    tmr_update: TTimer;
    scrlbx1: TScrollBox;
    scrlbx_img: TScrollBox;
    grp1: TGroupBox;
    lbl1: TLabel;
    edt_seg_size: TEdit;
    lbl2: TLabel;
    edt_send_interval: TEdit;
    lbl3: TLabel;
    edt_file_name: TEdit;
    chk_auto_reboot: TCheckBox;
    btn_begin: TBitBtn;
    btn_reboot: TBitBtn;
    btn_pause: TBitBtn;
    btn_load_hex: TBitBtn;
    il_progress: TImageList;
    lbl4: TLabel;
    edt_query_map: TEdit;
    lbl5: TLabel;
    edt_failed_exit: TEdit;
    btn_continue: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_load_hexClick(Sender: TObject);
    procedure btn_beginClick(Sender: TObject);
    procedure tmr_updateTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_rebootClick(Sender: TObject);
    procedure chk_auto_rebootClick(Sender: TObject);
    procedure edt_send_intervalKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btn_pauseClick(Sender: TObject);
    procedure btn_continueClick(Sender: TObject);
  private
    { Private declarations }
    m_img_point:array of TImage;
    m_bReadMapFlag:Boolean;
    m_nSendCounterForMap:Integer;
    m_updateDev:T_UpdateDev;
    function  IsSendAll(fromIndex:Integer=0):Boolean;
    function  SetImg(SegID:Integer;img:Byte=0):Boolean;
  public
    { Public declarations }
    fileSegCount:integer;//总段数   2byte   硬件空间段数，实际传输段数有可能比它小
    fileSegLen:integer;//段长度   2byte
    fileCurPos:integer;//当前发送或接收的包下标
    SendPackage:array of TPackageInfo;    //发送包组  [1..80] ，计算总包数，动态分配大小
    
    m_dataUnit:array[0..2047] of Byte;
    function  GetFileSum():Byte;//校验和
    function  GetFileXor():Byte;//校验异或
    procedure MakeBeginFrame();virtual;
    procedure MakeMapFrame();virtual;
    procedure MakeTranFrame();virtual;
    procedure MakeUseFrame();virtual;
    procedure MakeEndFrame();virtual;
    function GetDataUnit():PByte;virtual;
    function GetDataUnitLen():Integer;virtual;
    procedure ParseData(pCommEntity:Pointer=nil);virtual;
    function MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;virtual;
    procedure ParseUpdate(pDataUnit:PByte; dataUnitLen:Integer);
  end;

var
  F_Update: TF_Update;

implementation

uses U_Main;

{$R *.dfm}

const
    img_unload  = 0;
    img_loading = 1;
    img_loaded  = 2;

function TF_Update.GetFileSum():Byte;//校验和
var i,j:integer;
    fileSum:Byte;
begin
    fileSum:=0;
    for i:=low(SendPackage) to high(SendPackage)do
    begin
        for j:=low(SendPackage[i].Dataf) to high(SendPackage[i].Dataf) do
        begin
            fileSum:=ord(fileSum)+SendPackage[i].Dataf[j];
        end;
    end;
    result:=fileSum;
end;

function TF_Update.GetFileXor():Byte;//校验异或
var i,j:integer;
    fileXor:Byte;
begin
  fileXor:=0;
  for i:=low(SendPackage) to high(SendPackage)do
  begin
    for j:=low(SendPackage[i].Dataf) to high(SendPackage[i].Dataf) do
    begin
      fileXor:=ord(fileXor) Xor SendPackage[i].Dataf[j];
    end;
  end;//for i:=low(SendPackage) to high(SendPackage)do
  result:=fileXor;
end;

procedure TF_Update.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Release;
    F_Update := nil;
    F_Update.Free;
end;

function  TF_Update.SetImg(SegID:Integer;img:Byte=0):Boolean;
const CountPerRow = 50;
var
      nRow,nCol:Integer;
      nWidth,nHeight:Integer;
      nTop,nLeft:Integer;
begin
    Result := True;

    il_progress.GetBitmap(img,m_img_point[SegID].Picture.Bitmap);

    nRow := SegID div CountPerRow;
    nCol := SegID mod CountPerRow;

    m_img_point[SegID].Picture.Bitmap.Width := 12;
    m_img_point[SegID].Picture.Bitmap.Height := 12;

    nWidth  := m_img_point[SegID].Picture.Bitmap.Width;
    nHeight := m_img_point[SegID].Picture.Bitmap.Height;

    nLeft := nCol*nWidth;
    nTop  := nRow*nHeight;

    m_img_point[SegID].Left := nLeft;
    m_img_point[SegID].Top  := nTop;
end;

procedure TF_Update.btn_load_hexClick(Sender: TObject);
var hexBuf:array of Byte;
    hexLen:Integer;
    i,j,p,nlen:integer;
    fileSum:Word;
begin
    SetLength(hexBuf,1024*1024);
    if (dlgOpenHex.Execute)
      and
        (((dlgOpenHex.FilterIndex=3)and(LoadBinFile(dlgOpenHex.FileName,hexBuf,hexLen)))
        or ((dlgOpenHex.FilterIndex<>3) and (LoadHexFile(dlgOpenHex.FileName,hexBuf,hexLen))) )
    then
    begin
        for i:=Low(m_img_point) to High(m_img_point) do
        begin
            m_img_point[i].Free;
        end;
        SetLength(m_img_point,0);

        hexLen := CutFFFromEnd(@hexBuf[0],hexLen);
        
        fileSegLen:=strtoint(trim(edt_seg_size.Text));
        if hexLen mod fileSegLen = 0 then fileSegCount:=hexLen div fileSegLen
        else fileSegCount := hexLen div fileSegLen+1;
        SetLength(SendPackage,fileSegCount);
        SetLength(m_img_point,fileSegCount);

        //组包
        p := 0;
        for i:=low(SendPackage) to high(SendPackage) do
        begin
            SendPackage[i].bSend := False;
            SendPackage[i].SegID := i;
            if i=high(SendPackage) then SendPackage[i].Lf := hexLen-fileSegLen*i
            else                        SendPackage[i].Lf := fileSegLen;
            SetLength(SendPackage[i].Dataf,SendPackage[i].Lf);
            for j:=low(SendPackage[i].Dataf) to high(SendPackage[i].Dataf) do
            begin
                SendPackage[i].Dataf[j] := hexBuf[p];
                Inc(p);
            end;
            
            m_img_point[i] := TImage.Create(scrlbx_img);
            m_img_point[i].Parent := scrlbx_img;
            m_img_point[i].ShowHint := True;
            m_img_point[i].Hint := Format('%d',[i]);
            SetImg(i,img_unload);
        end;
        F_Operation.DisplayOperation(Format('加载文件（共%d段）：%s',[fileSegCount,dlgOpenHex.FileName]));
        btn_begin.Enabled := True;
        btn_pause.Enabled := True;
        btn_continue.Enabled := True;
        edt_file_name.Text := Format('%s',[dlgOpenHex.FileName]);

    end;
    fileSum := 0;
    for i:=0 to hexLen-1 do
    begin
        fileSum := fileSum + hexBuf[i];
    end;

    //ShowMessage(Format('%x', [fileSum]));

    SetLength(hexBuf,0);
end;

function TF_Update.MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
begin
    O_ProTx.MakeFrame(AFN, Fn, pDataUnit, len, Pn, IS_COMM_MODULE_ID_PLC);
end;

procedure TF_Update.MakeBeginFrame();
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
end;

procedure TF_Update.MakeTranFrame();
var buf:array[0..2047]of Byte;
    p:Integer;
begin
    p := 0;
    buf[p] := file_flag_update;     Inc(p);
    buf[p] := file_atrr_update;     Inc(p);
    buf[p] := file_cmd_tran;        Inc(p);
    buf[p] := fileSegCount;         Inc(p);
    buf[p] := fileSegCount shr 8;   Inc(p);

    buf[p] := SendPackage[fileCurPos].SegID;         Inc(p);//第i段标识或偏移 2byte
    buf[p] := SendPackage[fileCurPos].SegID shr 8;   Inc(p);

    buf[p] := fileSegLen;         Inc(p);//段长度   2byte
    buf[p] := fileSegLen shr 8;   Inc(p);
    
    buf[p] := SendPackage[fileCurPos].Lf;         Inc(p);//第i段实际传输数据长度Lf  2byte
    buf[p] := SendPackage[fileCurPos].Lf shr 8;   Inc(p);

    MoveMemory(@buf[p],@SendPackage[fileCurPos].Dataf[0],SendPackage[fileCurPos].Lf); //文件数据
    Inc(p,SendPackage[fileCurPos].Lf);

    MakeFrame(AFN_UPDATE_SELF,F1,@buf[0],p);
end;

procedure TF_Update.MakeUseFrame();
var buf:array[0..2047]of Byte;
    p:Integer;
begin
    p := 0;
    buf[p] := file_flag_update;     Inc(p);
    buf[p] := file_atrr_update;     Inc(p);
    buf[p] := file_cmd_use;         Inc(p);
    buf[p] := fileSegCount;         Inc(p);
    buf[p] := fileSegCount shr 8;   Inc(p);

    buf[p] := fileSegLen;         Inc(p);//段长度   2byte
    buf[p] := fileSegLen shr 8;   Inc(p);

    buf[p] := GetFileSum();         Inc(p);
    buf[p] := GetFileXor();         Inc(p);

    MakeFrame(AFN_UPDATE_SELF,F1,@buf[0],p);
end;

procedure TF_Update.MakeMapFrame();
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
end;

procedure TF_Update.MakeEndFrame();
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

    if chk_auto_reboot.Checked then
    begin
        buf[p] := file_reboot_flag_enable;         Inc(p);
    end
    else
    begin
        buf[p] := file_reboot_flag_disable;        Inc(p);
    end;

    MakeFrame(AFN_UPDATE_SELF,F1,@buf[0],p);
end;

function TF_Update.GetDataUnit():PByte;
begin
    Result := O_ProRx.GetDataUnit();
end;

function TF_Update.GetDataUnitLen():Integer;
begin
    Result := O_ProRx.GetDataUnitLen();
end;
    
procedure TF_Update.btn_beginClick(Sender: TObject);
var i:integer;
begin
    //定时发包
    //bSend:=false;
    g_bStop := False;
    m_nSendCounterForMap := 0;
    m_bReadMapFlag := False;
    F_Operation.DisplayOperation('开始升级...');
    fileCurPos := -1;
    for i:=low(SendPackage) to high(SendPackage)do
    begin
        SendPackage[i].bSend := False;
        SendPackage[i].nSendCounter := 0;
        SetImg(i,img_unload);
    end;
    MakeBeginFrame();
    F_Main.SendDataAuto();
    tmr_update.Enabled := False;
end;

procedure TF_Update.btn_pauseClick(Sender: TObject);
begin
    tmr_update.Enabled := False;
end;

procedure TF_Update.btn_continueClick(Sender: TObject);
begin
    tmr_update.Interval := StrToInt(trim(edt_send_interval.Text));
    tmr_update.Enabled := True;
end;

procedure TF_Update.btn_rebootClick(Sender: TObject);
begin
    MakeFrame(01,F1);
    F_Main.SendDataAuto();
    g_disp.DispLog('重启。');
end;

procedure TF_Update.tmr_updateTimer(Sender: TObject);
var i:Integer;
    nFailedCounter:Integer;
begin
    if g_bStop then
    begin
        tmr_update.Enabled := False;
        Exit;
    end;
    TTimer(Sender).Enabled := False;
    
    //查询
    if m_bReadMapFlag or IsSendAll(fileCurPos+1) then // 后面的都发送了，则查询
    begin
        MakeMapFrame();
        if not F_Main.SendDataAuto() then tmr_update.Enabled := False
        else
        begin
            m_nSendCounterForMap := 0;
            F_Operation.DisplayOperation(Format('查询发送情况...',[]));
        end;
        m_bReadMapFlag := False;
        TTimer(Sender).Enabled := True;
        Exit;
    end;

    //发送
    for i:=fileCurPos + 1 to High(SendPackage) do
    begin
        if not SendPackage[i].bSend then
        begin
            //发送
            if not (TryStrToInt(edt_failed_exit.Text, nFailedCounter)) then
            begin
                nFailedCounter := 10;
            end;
            fileCurPos := i;
            Inc(SendPackage[i].nSendCounter);
            if SendPackage[i].nSendCounter>nFailedCounter then //发送次数超，认为链路或设备出问题，退出升级。
            begin
                tmr_update.Enabled := False;
                Exit;
            end;
            MakeTranFrame();
            if not F_Main.SendDataAuto() then
            begin
              tmr_update.Enabled := False;
            end
            else
            begin
                SetImg(i,img_loading);
                F_Operation.DisplayOperation(Format('发送段%.3d',[fileCurPos]));
                Inc(m_nSendCounterForMap);
                if (m_nSendCounterForMap>0) and (m_nSendCounterForMap mod StrToInt(edt_query_map.Text)=0) then
                begin
                    m_bReadMapFlag := True;
                end;
                TTimer(Sender).Enabled := True;
            end;
            Exit;
        end;
    end;
    TTimer(Sender).Enabled := True;
{
    //结束
    if IsSendAll() then
    begin
        MakeEndFrame();
        if F_Main.SendDataAuto() then
            F_Operation.DisplayOperation('传输结束。');
        tmr_update.Enabled := False;
        Exit;
    end;
    }
end;

function  TF_Update.IsSendAll(fromIndex:Integer=0):Boolean;
var i:Integer;
begin
    Result := False;
    for i:=fromIndex to High(SendPackage) do
    begin
        if not SendPackage[i].bSend then
        begin
            Exit;
        end;
    end;
    Result := True;
end;

procedure TF_Update.ParseUpdate(pDataUnit:PByte; dataUnitLen:Integer);
var pData:PByte;
    i,p:Integer;
    fileCmdResp,respOK:Byte;
    strConten:string;
begin
    with F_Main do
    begin
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
                tmr_update.Interval := StrToInt(trim(edt_send_interval.Text));
                tmr_update.Enabled := True;
                F_Operation.DisplayOperation(Format('升级确认',[]));
            end
            else//升级失败
            begin
                tmr_update.Enabled := False;
                F_Operation.DisplayOperation(Format('升级否认',[]));
            end;
        end
        else if fileCmdResp = file_cmd_read_map then
        begin
            if dataUnitLen<8 then Exit;
            Inc(pData,5);
            for i:=Low(SendPackage) to High(SendPackage) do
            begin
                if (pData^ shr (i mod 8) and $01)>0 then
                begin
                    SendPackage[i].bSend := True;
                end
                else
                begin
                    SendPackage[i].bSend := False;
                end;
                if ((i+1) mod 8 = 0) then
                begin
                    Inc(pData,1);
                end;
            end;
            //显示成功与否
            for i:=Low(SendPackage) to High(SendPackage) do
            begin
                if strConten = '' then
                begin
                    if SendPackage[i].bSend then
                    begin
                        SetImg(i,img_loaded);
                        strConten := Format('段%.3d：成功',[i]);
                    end
                    else
                    begin
                        //SetImg(i,img_unload);
                        if (i > fileCurPos)or(fileCurPos >= High(SendPackage)) then
                        begin
                            SetImg(i,img_unload);
                        end
                        else
                        begin
                            SetImg(i,img_loading);
                        end;
                        strConten := Format('段%.3d：失败',[i]);
                    end;
                end
                else
                begin
                    if SendPackage[i].bSend then
                    begin
                        SetImg(i,img_loaded);
                        strConten := Format('%s，段%.3d：成功',[strConten,i]);
                    end
                    else
                    begin
                        //SetImg(i,img_unload);
                        if (i > fileCurPos)or(fileCurPos >= High(SendPackage)) then
                        begin
                            SetImg(i,img_unload);
                        end
                        else
                        begin
                            SetImg(i,img_loading);
                        end;
                        strConten := Format('%s，段%.3d：失败',[strConten,i]);
                    end;
                end;
                if (((i+1) mod 8 = 0)or(i = High(SendPackage))) then
                begin
                    if strConten<>'' then
                    begin
                        F_Operation.DisplayOperation(Format(strConten,[]));
                        strConten := '';
                    end;
                end;                
            end;
            if not IsSendAll() then
            begin
                //if fileCurPos >= High(SendPackage) then //等到当前轮次发送完，再发送下一轮次
                if IsSendAll(fileCurPos+1) then //等到当前轮次发送完，再发送下一轮次
                begin
                    fileCurPos := -1; // 复位，重发
                end;
                //fileCurPos := -1; // 复位，重发
            end
            else
            begin
                //结束
                if IsSendAll() then
                begin
                    MakeEndFrame();
                    if F_Main.SendDataAuto() then
                        F_Operation.DisplayOperation('传输结束。');
                    tmr_update.Enabled := False;
                    Exit;
                end;            
            end;
        end;
    end;
end;
    
procedure TF_Update.ParseData(pCommEntity:Pointer=nil);
begin
    if (O_ProRx.GetAFN() = AFN_UPDATE_SELF) and (O_ProRx.GetFn() = F1) then
    begin
        ParseUpdate(GetDataUnit(), GetDataUnitLen());
    end;
end;

procedure TF_Update.FormDestroy(Sender: TObject);
var i:Integer;
begin
    for i:=Low(SendPackage) to High(SendPackage) do
    begin
        SetLength(SendPackage[i].Dataf,0);
    end;
    SetLength(SendPackage,0);
end;

procedure TF_Update.chk_auto_rebootClick(Sender: TObject);
begin
    if TCheckBox(Sender).Checked then
        btn_reboot.Enabled := False
    else
        btn_reboot.Enabled := True;
end;

procedure TF_Update.edt_send_intervalKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var nValue:Integer;
begin
  {
    if(TryStrToInt(trim(edt_send_interval.Text),nValue)) then
    begin
        tmr_update.Enabled := False;
        tmr_update.Interval := nValue;
        tmr_update.Enabled := True;
    end;
    }
end;

procedure TF_Update.FormCreate(Sender: TObject);
begin
    fileSegCount:=10;//总段数   2byte   硬件空间段数，实际传输段数有可能比它小
    fileSegLen:=200;//段长度   2byte
    fileCurPos:=-1;//当前发送或接收的包下标
    m_updateDev := T_UpdateDev.Create;
end;

end.
