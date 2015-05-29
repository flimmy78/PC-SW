unit U_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, IdBaseComponent, IdComponent,
  IdTCPServer, U_Protocol, U_ComComm, Grids, ComCtrls, U_MyFunction, U_ParamReadWrite,
  U_Protocol_mod, U_Protocol_con, U_Protocol_645, Math, U_Disp, U_Process, DateUtils,
  U_TcpClient, U_TcpServer, Menus, StrUtils, DB, ADODB, U_DataModule,
  U_Status, U_SysCtrl, U_ParamChk,

  //深圳市合尔凯科技有限公司
  U_Rdt, U_Multi;

const WM_DISPLAY_TCP_ACTION = WM_USER + 1;
      WM_UPDATE_START       = WM_USER + 2;
      WM_UPDATE_START_OK    = WM_USER + 3;
      WM_UPDATE_START_ERROR = WM_USER + 4;
      WM_UPDATE_SEND_DATA   = WM_USER + 5;
      WM_UPDATE_READ_MAP    = WM_USER + 6;
      WM_UPDATE_END         = WM_USER + 7;

type TMyStrGrid = class(TStringgrid);
type
  TF_Main = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    cbb_ConnMode: TComboBox;
    cbb_Comm: TComboBox;
    cbb_Baudrate: TComboBox;
    lbl1: TLabel;
    btnConn: TBitBtn;
    btnDisConn: TBitBtn;
    btn_stop: TBitBtn;
    btn_Clear: TBitBtn;
    stat_bar: TStatusBar;
    cbb_Parity: TComboBox;
    txt1: TStaticText;
    edt_con_addr: TEdit;
    pnl3: TPanel;
    pgc1: TPageControl;
    ts_update: TTabSheet;
    ts_chkmeter: TTabSheet;
    ts_param_read_write: TTabSheet;
    ts_debug: TTabSheet;
    spl1: TSplitter;
    tmr1: TTimer;
    pgc2: TPageControl;
    ts_operation: TTabSheet;
    ts_frame: TTabSheet;
    pnl4: TPanel;
    txt_sel_protocol: TStaticText;
    spl2: TSplitter;
    lbl7: TLabel;
    edt_timeout: TEdit;
    ts_meter_file: TTabSheet;
    ts_status: TTabSheet;
    ts_sys_ctrl: TTabSheet;
    ts_rdt: TTabSheet;
    ts_key: TTabSheet;
    ts_temp: TTabSheet;
    ts_noise: TTabSheet;
    ts_pda: TTabSheet;
    cbb_DataBits: TComboBox;
    cbb_StopBits: TComboBox;
    procedure cbb_ConnModeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnConnClick(Sender: TObject);
    procedure btnDisConnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_stopClick(Sender: TObject);
    procedure btn_ClearClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_con_addrKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmr1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure strngrd_ipMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn1Click(Sender: TObject);
    procedure txt_sel_protocolClick(Sender: TObject);
    procedure txt_sel_protocolMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure pnl4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure txt_sel_protocolMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edt_timeoutKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N_CloseConnectionClick(Sender: TObject);
        
  private
    { Private declarations }
    m_nTxCounter:Int64;
    m_nRxCounter:Int64;
    m_tcpClient:T_TcpClient;
    m_tcpServer:T_TcpServer;
    
    procedure OnCommData(Var Msg:TMessage);Message WM_COMM_RECEIVE_DATA;
    procedure OnTcpAction(Var Msg:TMessage);Message WM_DISPLAY_TCP_ACTION;

    procedure OnTcpClientReceive(pRevBuf:PByte; nRevLen:Integer; var nProLen:Integer);

    procedure OnTcpSvrConnect(ip:string; port:Integer);
    procedure OnTcpSvrDisconnect(ip:string; port:Integer);
    procedure OnTcpSvrReceive(ip:string; port:Integer; pRevBuf:PByte; nRevLen:Integer; var nProLen:Integer);
      
    procedure SetDeviceAddr();

    function  SendData(pCommEntity:Pointer=nil):Boolean;overload;
    function  SendData(IP:string;port:Integer):Boolean;overload;

    function  SelProtocol():Boolean;
    
    function  GetStrIP(AThread: TIdPeerThread):string;
    function  GetStrPort(AThread: TIdPeerThread):string; overload;
    function  GetStrPort(port:Integer):string; overload;
    function  GetIntPort(AThread: TIdPeerThread):Integer;
    //function  ProcessTcpData(ip:string; port:Integer):Boolean;

    function  StrAddrToInt(strAddr:string):Int64; overload;
    function  StrAddrToInt(strAddr:string; var distCode:Integer; var termAddr:Integer):Int64; overload;
  public
    { Public declarations }
    m_O_ProTmp: T_Protocol;
    
    function  SendDataAuto():Boolean;
    function  SendData(pBuf:PByte;len:Integer;pCommEntity:Pointer=nil):Boolean;overload;
    function  SendData(pBuf:PByte; len:Integer; IP:string; port:Integer):Boolean;overload;
    function  GetCommEntity(var ip:string; var port:Integer; devAddr:Int64=INVALID_DEVADDR):Boolean;
    function  AddConnection(ip:string; port:Integer):Boolean;
    function  DelConnection(ip:string; port:Integer):Boolean;
    procedure ParseFrame(pBuf:PByte; len:Integer; ip:string; port:Integer);
    function  DispDevAddr(ip:string; port:Integer; devAddr:Int64):Boolean;
    function  GotoDevAddr(devAddr:Int64):Boolean;
  end;

var
  F_Main: TF_Main;

const Version = 'v2015.05.29';

implementation

uses U_Update,U_ParseFrame, U_Debug, U_Debug_Con, U_Operation,U_Frame, U_Sel_Protocol,
     U_Param_Mod, U_Param_Con, U_Param_ChkMeter,U_Update_Con_Mod,U_Param_Con_Mod,
  U_Debug_Con_Mod, U_Container, U_Key, U_Temp, U_Noise, U_PDA;

{$R *.dfm}

type TTcpAction = (taOnConn, taOnDisconn, taOnData);

const
  conn_mode_comm = 0;
  conn_mode_tcp_server  = 1;
  conn_mode_tcp_client  = 2;

const ip_col_ip    = 1;
      ip_col_port  = 2;
      ip_col_addr  = 3;
      ip_col_name  = 4;
      ip_col_ver   = 5;
      
//var tcp_Buf:array[0..10*1024-1]of Byte;

procedure TF_Main.OnTcpSvrConnect(ip:string; port:Integer);
begin
    g_disp.DispConn(ip, port);
end;

procedure TF_Main.OnTcpSvrDisconnect(ip:string; port:Integer);
begin
    g_disp.DispDisConn(ip, port);
end;

procedure TF_Main.OnTcpSvrReceive(ip:string; port:Integer; pRevBuf:PByte; nRevLen:Integer; var nProLen:Integer);
begin
    g_disp.DispRevData(pRevBuf, nRevLen, ip, port);
    g_Process.ProcessData(pRevBuf, nRevLen, ip, port);
end;

procedure TF_Main.FormCreate(Sender: TObject);
begin
    
    g_disp := T_Disp.Create;
    g_Process := T_Process.Create;
    m_tcpClient := T_TcpClient.Create('192.168.0.1', 12712);
    m_tcpClient.OnReceive := OnTcpClientReceive;

    m_tcpServer := T_TcpServer.Create;
    m_tcpServer.OnConnect := OnTcpSvrConnect;
    m_tcpServer.OnDisconnect := OnTcpSvrDisconnect;
    m_tcpServer.OnReceive := OnTcpSvrReceive;

    //strngrd_ip.Cells[ip_col_name,1] := 'aaaa';
    
    O_ComComm := TO_ComComm.Create;
    m_nTxCounter := 0;
    {
    O_ProTx := T_Protocol_mod.Create;
    O_ProRx := T_Protocol_mod.Create;
    }
end;

function  TF_Main.SelProtocol():Boolean;
var i:Integer;
    addr:Int64;
    key:Word;
begin
    Result := False;

    {
    Application.CreateForm(TF_Sel_Protocol, F_Sel_Protocol);

    if F_Sel_Protocol.ShowModal<> mrOk then
    begin
        FreeAndNil(F_Sel_Protocol);
        Exit;
    end;
    FreeAndNil(F_Sel_Protocol);
    }
    
    g_func_type := FUNC_RF_TEST;
    
    if F_Update<>nil then         FreeAndNil(F_Update);
    if F_ParamReadWrite<>nil then FreeAndNil(F_ParamReadWrite);
    if F_Debug<>nil then          FreeAndNil(F_Debug);
    if F_Operation<>nil then      FreeAndNil(F_Operation);
    if F_Frame<>nil then          FreeAndNil(F_Frame);
    if F_Param_ChkMeter<>nil then FreeAndNil(F_Param_ChkMeter);
        
    if O_ProTx<>nil then      FreeAndNil(O_ProTx);
    if O_ProRx<>nil then      FreeAndNil(O_ProRx);
    if m_O_ProTmp<>nil then   FreeAndNil(m_O_ProTmp);
    if O_ProTx_Mod<>nil then  FreeAndNil(O_ProTx_Mod);
    if O_ProRx_Mod<>nil then  FreeAndNil(O_ProRx_Mod);
    if O_ProTx_645<>nil then  FreeAndNil(O_ProTx_645);
    if O_ProRx_645<>nil then  FreeAndNil(O_ProRx_645);

    if g_func_type = FUNC_MOD_UPDATE then
    begin
    end
    else if g_func_type = FUNC_CON_UPDATE then
    begin
        O_ProTx := T_Protocol.Create;
        O_ProRx := T_Protocol.Create;
        m_O_ProTmp := T_Protocol.Create;

        Application.CreateForm(TF_Param_Con, F_ParamReadWrite);
        Application.CreateForm(TF_Update, F_Update);
        Application.CreateForm(TF_Status, F_Status);
        Application.CreateForm(TF_SysCtrl, F_SysCtrl);
        Application.CreateForm(TF_ParamChk, F_ParamChk);
        Application.CreateForm(TF_Param_ChkMeter, F_Param_ChkMeter);
        Application.CreateForm(TF_Debug_Con, F_Debug);
        Application.CreateForm(TF_Operation, F_Operation);
        Application.CreateForm(TF_Frame, F_Frame);
        Application.Title := 'Modbus';
    end
    else if g_func_type = FUNC_CON_CHKMETER then
    begin
    end
    else if g_func_type = FUNC_CON_MOD then
    begin
    end
    else if g_func_type = FUNC_RF_TEST then //深圳市合尔凯科技有限公司
    begin
        O_ProTx := T_Protocol.Create;
        O_ProRx := T_Protocol.Create;
        m_O_ProTmp := T_Protocol.Create;

        Application.CreateForm(TF_Rdt, F_Rdt);
        Application.CreateForm(TF_Operation, F_Operation);
        Application.CreateForm(TF_DataModule, F_DataModule);
        Application.CreateForm(TF_Frame, F_Frame);
        Application.Title := 'PC 软件';
    end;

    edt_con_addrKeyUp(edt_con_addr, key, []);
    
    SetDeviceAddr();

    Caption := Application.Title;

    for i:=pgc1.PageCount-1 downto 0 do
    begin
        pgc1.Pages[i].TabVisible := False;
    end;

    if F_Update<>nil then
    begin
        F_Update.Parent := ts_update;           F_Update.Show;
        ts_update.TabVisible := True;
    end;
    
    if F_Status<>nil then
    begin
        F_Status.Parent := ts_status;           F_Status.Show;
        ts_status.TabVisible := True;
    end;
    
    if F_SysCtrl<>nil then
    begin
        F_SysCtrl.Parent := ts_sys_ctrl;        F_SysCtrl.Show;
        ts_sys_ctrl.TabVisible := True;
    end;
    
    if F_ParamReadWrite<>nil then
    begin
        F_ParamReadWrite.Parent := ts_param_read_write; F_ParamReadWrite.Show;
        ts_param_read_write.TabVisible := True;
    end;

    if F_Debug<>nil then
    begin
        F_Debug.Parent      := ts_debug;            F_Debug.Show;
        ts_debug.TabVisible := True;
    end;

    if F_ParamChk<>nil then
    begin
        F_ParamChk.Parent := ts_chkmeter;   F_ParamChk.Show;
        ts_chkmeter.TabVisible := True;
    end;

    if F_Param_ChkMeter<>nil then
    begin
        F_Param_ChkMeter.Parent := ts_chkmeter;   F_Param_ChkMeter.Show;
        ts_chkmeter.TabVisible := True;
    end;
    

    //深圳市合尔凯科技有限公司
    if F_Rdt<>nil then
    begin
        F_Rdt.Parent := ts_rdt;   F_Rdt.Show;
        ts_rdt.TabVisible := True;
    end;

    if F_Key<>nil then
    begin
        F_Key.Parent := ts_key;   F_Key.Show;
        ts_key.TabVisible := True;
    end;

    if F_Temp<>nil then
    begin
        F_Temp.Parent := ts_temp;   F_Temp.Show;
        ts_temp.TabVisible := True;
    end;

    if F_Noise<>nil then
    begin
        F_Noise.Parent := ts_noise;   F_Noise.Show;
        ts_noise.TabVisible := True;
    end;

    if F_Operation<>nil then
    begin
        F_Operation.Parent      := ts_operation;        F_Operation.Show;
        ts_operation.TabVisible := True;
    end;

    if F_Frame<>nil then
    begin
        F_Frame.Parent          := ts_frame;            F_Frame.Show;
        ts_frame.TabVisible := True;
    end;

    if F_PDA<>nil then
    begin
        F_PDA.Parent            := ts_pda;              F_PDA.Show;
        ts_pda.TabVisible := True;
    end;

    for i:=pgc1.PageCount-1 downto 0 do
    begin
        if pgc1.Pages[i].TabVisible then
        begin
            pgc1.ActivePageIndex := i;
        end;
    end;

    cbb_ConnModeChange(cbb_ConnMode);
    
    Result := True;
end;
    
procedure TF_Main.FormShow(Sender: TObject);
var buf:array[0..9]of Byte;
    //fValue:Real;
begin
    //fValue := $66866B40;
    //ShowMessage(Format('%d %f',[SizeOf(fValue), fValue]));
    
  {
    a := 0.05;
    b := 0.06;
    ShowMessage(Format('%f', [Abs(a-b)]));
   } 
    //ShowMessage( Format('%x%x%x%x%x',[ord('C'),ord('M'),ord('N'),ord('E'),ord('T')]) );
    //ShowMessage( Format('%d',[ Round(Power(10,0))]) );
    {
    Application.CreateForm(TF_Container, F_Container);
    F_Container.Parent := ts1;           F_Container.Show;
    ts1.TabVisible := True;
    }
    //ShowMessage( Format('%.2f', [-2.7123]) );

    //ShowMessage(IntToHex(MinuteOf(Now), 2));
{
    T_Protocol_con.FloatToDatabuf(1.23, @buf[0], 2);
    ShowMessage(BufToHex(@buf[0], 2));
    Close;
    Exit;
}

    if not {F_Container.}SelProtocol() then
    begin
        F_Main.Close;
        Exit;
    end;

    stat_bar.Panels[0].Text := Application.Title + '   ' + Version + '   Copyleft @ 华兄   Email：591881218@qq.com';

    cbb_ConnMode.ItemIndex := conn_mode_comm;
    cbb_ConnModeChange(cbb_ConnMode);

    edt_timeout.Text := Format('%d', [g_timeout]);

    //i := $30; ShowMessage(Format('%s',[PChar(@i)^]));
{
    F_Param_Con_Mod.Test();
    TF_ParamReadWrite(F_Param_Con_Mod).Test();
    }
end;

procedure TF_Main.cbb_ConnModeChange(Sender: TObject);
begin
    if cbb_ConnMode.ItemIndex = conn_mode_comm then
    begin
        cbb_Comm.Enabled := True;
        cbb_Baudrate.Enabled := True;
        cbb_Parity.Enabled := True;
        edt_con_addr.Enabled := True;
        if (F_Update<>nil) and not(F_Update is TF_Update_Con_Mod) then
        begin
            F_Update.edt_send_interval.Text := '200';
        end;
    end
    else if cbb_ConnMode.ItemIndex = conn_mode_tcp_server then
    begin
        cbb_Comm.Enabled := False;
        cbb_Baudrate.Enabled := False;
        cbb_Parity.Enabled := False;
        edt_con_addr.Enabled := False;
        if (F_Update<>nil) and not(F_Update is TF_Update_Con_Mod) then
        begin
            F_Update.edt_send_interval.Text := '1200';
        end;
    end
    else if cbb_ConnMode.ItemIndex = conn_mode_tcp_client then
    begin
        cbb_Comm.Enabled := False;
        cbb_Baudrate.Enabled := False;
        cbb_Parity.Enabled := False;
        edt_con_addr.Enabled := False;
        if (F_Update<>nil) and not(F_Update is TF_Update_Con_Mod) then
        begin
            F_Update.edt_send_interval.Text := '2500';
        end;
    end;
end;

procedure TF_Main.btnConnClick(Sender: TObject);
var nPort,nBaud,nDataBits:Integer;
begin
    if cbb_ConnMode.ItemIndex = conn_mode_comm then
    begin
        nPort := cbb_Comm.ItemIndex+1;
        nBaud := StrToInt(cbb_Baudrate.Text);
        nDataBits := StrToInt(cbb_DataBits.Text);
        if O_ComComm.IniCom(nPort,nBaud,cbb_Parity.ItemIndex,nDataBits,cbb_StopBits.ItemIndex) then
        begin
            O_ComComm.SetFrameInterval(100);
            O_ComComm.WriteCom(Handle,nil,0);
            cbb_ConnMode.Enabled := False;
            cbb_Comm.Enabled := False;
            cbb_Baudrate.Enabled := False;
            cbb_Parity.Enabled := False;
            cbb_DataBits.Enabled := False;
            cbb_StopBits.Enabled := False;
            btnConn.Enabled := False;
            btnDisConn.Enabled := True;
            g_disp.DispLog('打开串口成功');
        end
        else
        begin
            g_disp.DispLog('打开串口失败');
        end
    end
    else if cbb_ConnMode.ItemIndex = conn_mode_tcp_server then
    begin
        try
        except
        end;
    end
    else if cbb_ConnMode.ItemIndex = conn_mode_tcp_client then
    begin
    end;
end;

procedure TF_Main.FormDestroy(Sender: TObject);
begin
    O_ComComm.Free;
end;

function  TF_Main.GetStrIP(AThread: TIdPeerThread):string;
begin
    Result := AThread.Connection.Socket.Binding.PeerIP;
end;

function  TF_Main.GetStrPort(AThread: TIdPeerThread):string;
begin
    Result := Format('%d',[AThread.Connection.Socket.Binding.PeerPort]);
end;

function  TF_Main.GetStrPort(port:Integer):string;
begin
    Result := Format('%d',[port]);
end;

function  TF_Main.GetIntPort(AThread: TIdPeerThread):Integer;
begin
    Result := AThread.Connection.Socket.Binding.PeerPort;
end;
    
procedure TF_Main.OnTcpAction(Var Msg:TMessage);
var tmpThread:TIdPeerThread;
begin
    tmpThread := TIdPeerThread(Msg.LParam);
    case TTcpAction(Msg.WParam) of
      taOnConn:
        begin
            AddConnection(GetStrIP(tmpThread), GetIntPort(tmpThread));
        end;
      taOnDisconn:
        begin
            DelConnection(GetStrIP(tmpThread), GetIntPort(tmpThread));
        end;
      taOnData:
        begin
            //ProcessTcpData(GetStrIP(tmpThread), GetIntPort(tmpThread));
        end;
    end;
    Msg.Result := 1;
end;

function  TF_Main.AddConnection(ip:string; port:Integer):Boolean;
var i,nRow,nRowCount:Integer;
    strIP,strPort:string;
    List:TList;
    tmpThread:TIdPeerThread;
begin
    g_disp.DispLog(Format('设备连接：%s %d',[ip, port]));

    strIP := ip;
    strPort := GetStrPort(port);
{
    //把重复IP的去掉
    nRowCount := strngrd_ip.RowCount;
    for nRow := nRowCount-1 downto 1 do
    begin
        if (strngrd_ip.Cells[ip_col_ip,nRow] = strIP) then
        begin
            //把之前的链接断开
            //idtcpsrvr.OnExecute := nil;
            //idtcpsrvr.OnDisconnect := nil;
            List := idtcpsrvr.Threads.LockList;
            try
                for i := 0 to List.Count - 1 do
                begin
                    try
                        tmpThread := TIdPeerThread(List.Items[i]);
                        if (GetStrIP(tmpThread)=strIP)
                         and ( GetStrPort(tmpThread)<>strPort )
                        then
                        begin
                            g_disp.DispLog(Format('主站关闭连接：%s %s',[GetStrIP(tmpThread), GetStrPort(tmpThread)]));
                            //tmpThread.Connection.Disconnect();
                            //tmpThread.Connection.DisconnectSocket;
                            //tmpThread.Terminate;
                            //tmpThread.Connection.Disconnect();
                            //tmpThread.Connection.Free;
                            //tmpThread.Connection.CleanupInstance;
                            tmpThread.Connection.Socket.Close;
                            
                            if strngrd_ip.RowCount > 2 then
                                TMyStrGrid(strngrd_ip).DeleteRow(nRow)
                            else
                                strngrd_ip.Rows[nRow].Clear;
                            Break;
                        end;
                    except
                        on E: Exception do
                        begin
                        end;
                    end;
                end;
            finally
                idtcpsrvr.Threads.UnlockList;
                //idtcpsrvr.OnDisconnect := idtcpsrvrDisconnect;
                //idtcpsrvr.OnExecute := idtcpsrvrExecute;
            end;
            //Break;
        end;
    end;
}
    //添加新的IP
    
    Result := True;
end;

procedure TF_Main.btnDisConnClick(Sender: TObject);
var
    List: TList;
    i,j: Integer;
    AThread:TIdPeerThread;
begin
    if cbb_ConnMode.ItemIndex = conn_mode_comm then
    begin
        { TF_Rdt }
        F_Rdt.btn_cancel.Click;

        {TF_Key}
        F_Key.btn_cancel.Click;
        
        O_ComComm.UniniCom;
        cbb_ConnMode.Enabled := False;
        cbb_Comm.Enabled := True;
        cbb_Baudrate.Enabled := True;
        cbb_Parity.Enabled := True;
        cbb_DataBits.Enabled := True;
        cbb_StopBits.Enabled := True;
        g_disp.DispLog('关闭串口');
    end
    else if cbb_ConnMode.ItemIndex = conn_mode_tcp_server then
    begin
        if m_tcpServer.Active then
        begin
            try
                m_tcpServer.CloseListen();
            finally
                g_disp.DispLog(Format('主站关闭所有连接！',[]));
            end;
        end;
    end
    else if cbb_ConnMode.ItemIndex = conn_mode_tcp_client then
    begin
        m_tcpClient.Disconnect;
    end;

    btnConn.Enabled := True;
    btnDisConn.Enabled := False;
end;

function  TF_Main.DelConnection(ip:string; port:Integer):Boolean;
var nRow:Integer;
    strIp, strPort:string;
begin
    try
        //AThread.Connection.CheckForDisconnect();
        //AThread.Connection.CheckForGracefulDisconnect();
        //if AThread.Connection.Connected then
        begin
            strIp := ip;
            strPort := GetStrPort(port);
        end;

    except

    end;
    Result := True;
end;

procedure TF_Main.OnTcpClientReceive(pRevBuf:PByte; nRevLen:Integer; var nProLen:Integer);
var ip:string;
    port:Integer;
begin
    nProLen := nRevLen;
    m_tcpClient.GetConnParam(ip, port);
    g_disp.DispRevData(pRevBuf, nRevLen, ip, port);
    g_Process.ProcessData(pRevBuf, nRevLen, ip, port);
end;

procedure TF_Main.OnCommData(Var Msg:TMessage);
var pBuf:PByte;
    BufferLength:Integer;
begin
    pBuf := PByte(Msg.LParam);
    BufferLength := Msg.WParam;
    g_Process.ProcessData(pBuf, BufferLength);
    g_disp.DispRevData(pBuf, BufferLength);
end;

function  TF_Main.DispDevAddr(ip:string; port:Integer; devAddr:Int64):Boolean;
var i:Integer;
begin
end;

{
procedure TF_Main.ParseFrame(pBuf:PByte; len:Integer; ip:string; port:Integer);
var i, deviceAddr:Integer;
    DI:LongWord;
    buf:array[0..32] of Byte;
    strIP,strPort:string;
    distCode2, termAddr2:string;
begin
    strIP := ip;
    strPort := GetStrPort(port);

    while m_O_ProTmp.CheckFrame(pBuf, len) and O_ProRx.CheckFrame(pBuf, len) do
    begin
        Inc(m_nRxCounter);

        deviceAddr := O_ProRx.GetDeviceAddr();
    
        //更新地址
        if (ip<>'') and (O_ProRx.IsLogin or O_ProRx.IsHarteBeate)  then
        begin
            g_disp.DispDevAddr(ip, port, O_ProRx.GetDeviceAddr());
        end;
        //数据解释
        if m_O_ProTmp.IsLogin() or m_O_ProTmp.IsHarteBeate() or m_O_ProTmp.IsLogout() then
        begin
            //链路报文，需要回复确认否认
            if ip<>'' then
            begin
                i := 0;
                buf[i] := m_O_ProTmp.GetAFN();  Inc(i);
                DI := m_O_ProTmp.GetDI();
                MoveMemory(@buf[i], @DI, 4); Inc(i,4);
                buf[i] := 0;  Inc(i);
                m_O_ProTmp.MakeRespFrame(AFN_CONFIRM, F3, @buf[0], i);
                SendData(m_O_ProTmp.GetFrameBuf(), m_O_ProTmp.GetFrameLen(), ip, port);
            end;
        end
        else
        begin
            //各窗口的数据处理
            if F_Update<>nil then F_Update.ParseData();
            if F_ParamReadWrite<>nil then F_ParamReadWrite.ParseData();
            if F_Param_ChkMeter<>nil then F_Param_ChkMeter.ParseData();
            if F_Status<>nil then F_Status.ParseData();
            if F_SysCtrl<>nil then F_SysCtrl.ParseData();
            if F_ParamChk<>nil then F_ParamChk.ParseData();
        end;

        Inc(pBuf,O_ProRx.GetFrameLen()); 
        len := len - O_ProRx.GetFrameLen();
        //Break;
    end;
end;
}

procedure TF_Main.ParseFrame(pBuf:PByte; len:Integer; ip:string; port:Integer);
begin
  if CommCheckFrame(pBuf, len) then
  begin
    Inc(m_nRxCounter);
    Inc(RxCnt);
    CommRecved := True;
  end;
end;

function  TF_Main.SendData(pBuf:PByte; len:Integer; pCommEntity:Pointer=nil):Boolean;
var pTcp:TIdPeerThread;
    ip:string;
    port:Integer;
begin
    Result := False;
    if {pCommEntity=nil} True then
    begin
        if O_ComComm.WriteCom(Handle,pBuf,len)>0 then
        begin
            g_disp.DispSndData(pBuf, len);
            Result := True;
            Inc(m_nTxCounter);
        end
        else
        begin
            g_disp.DispLog('没有通讯链路');
        end;
    end
    else if cbb_ConnMode.ItemIndex = conn_mode_tcp_server then
    begin
        pTcp := pCommEntity;
        pTcp.Connection.WriteBuffer(pBuf^, len, True);
        g_disp.DispSndData(pBuf, len, GetStrIP(pTcp), GetIntPort(pTcp));
        Result := True;
        Inc(m_nTxCounter);
    end
    else if cbb_ConnMode.ItemIndex = conn_mode_tcp_client then
    begin
        m_tcpClient.SendData(pBuf, len);
        m_tcpClient.GetConnParam(ip, port);
        g_disp.DispSndData(pBuf, len, ip, port);
        Result := True;
        Inc(m_nTxCounter);
    end;
end;

function  TF_Main.SendData(pCommEntity:Pointer=nil):Boolean;
begin
    {Result := SendData(O_ProTx.GetFrameBuf(),O_ProTx.GetFrameLen(),pCommEntity);}
    Result := SendData(GetCommSendBufAddr(), GetCommSendDataLen);
end;

function  TF_Main.SendData(IP:string;port:Integer):Boolean;
begin
    Result := SendData(O_ProTx.GetFrameBuf(), O_ProTx.GetFrameLen(), IP, port);
end;

function TF_Main.SendData(pBuf:PByte; len:Integer; IP:string; port:Integer):Boolean;
var
    List: TList;
    i,j: Integer;
    pTcp:TIdPeerThread;
begin
    if cbb_ConnMode.ItemIndex = conn_mode_tcp_server then
    begin
        m_tcpServer.SendData(IP, port, pBuf, len);
        Result := g_disp.DispSndData(pBuf, len, ip, port);
        Inc(m_nTxCounter);
        {
        Result := False;
        if idtcpsrvr.Active then
        begin
            List := idtcpsrvr.Threads.LockList;
            try
                for i := 0 to List.Count - 1 do
                begin
                    try
                        pTcp := TIdPeerThread(List.Items[i]);
                        if (pTcp.Connection.Socket.Binding.PeerIP = IP) and (pTcp.Connection.Socket.Binding.PeerPort = port) then
                        begin
                            Result := SendData(pBuf, len, pTcp);
                        end;
                    except on E: Exception do
                        begin
                        end;
                    end;
                end;
            finally
                idtcpsrvr.Threads.UnlockList;
            end;
        end;
        }
    end
    else if cbb_ConnMode.ItemIndex = conn_mode_tcp_client then
    begin
        Result := SendData(pBuf, len, m_tcpClient);
    end
end;

{
function  TF_Main.SendDataAuto():Boolean;
var IP:string;
    port:Integer;
begin
    if GetCommEntity(IP, port) then
        Result := SendData(IP, port)
    else
        Result := SendData();
end;
}

function  TF_Main.SendDataAuto():Boolean;
begin
    Result := SendData();
end;

function  TF_Main.GetCommEntity(var ip:string; var port:Integer; devAddr:Int64=INVALID_DEVADDR):Boolean;
var i:Integer;
    tmpAddr:Int64;
begin
    Result := False;
    
    if cbb_ConnMode.ItemIndex = conn_mode_tcp_server then
    begin
        if devAddr=INVALID_DEVADDR then //对应没地址码的设备，选择哪个就用哪个发送
        begin
        end
        else //对于有地址码的设备应寻找对应地址码的发送
        begin
        end;
    end
    else if cbb_ConnMode.ItemIndex = conn_mode_tcp_client then
    begin
        if m_tcpClient.IsConnected then
        begin
            m_tcpClient.GetConnParam(ip, port);
            Result := True;
        end;
    end;
end;

procedure TF_Main.btn_stopClick(Sender: TObject);
begin
    //TMyStrGrid(strngrd_ip).DeleteRow(1);
    //strngrd_ip.Rows[1].Clear;
    g_bStop := True;
end;

procedure TF_Main.btn_ClearClick(Sender: TObject);
begin
    F_Operation.ClearOperation();
    F_Frame.ClearFrame();
    m_nTxCounter := 0;
    m_nRxCounter := 0;
    //ShowMessage(Format('%d',[strngrd_ip.Row]));
end;

function  TF_Main.StrAddrToInt(strAddr:string):Int64;
var addr, distCode:Int64;
begin
    addr := 0;
    if 9 = Length(strAddr) then
    begin
        if TryStrToInt64('x'+LeftStr(strAddr, 4), distCode) and TryStrToInt64(RightStr(strAddr, 5), addr) then
        begin
            addr := addr or (distCode shl 16);
            //ShowMessage(Format('%x', [addr]));
        end;
    end;
    Result := addr;
end;

function  TF_Main.StrAddrToInt(strAddr:string; var distCode:Integer; var termAddr:Integer):Int64;
begin
    Result := StrAddrToInt(strAddr);
    distCode := Result shr 16 and $ffff;
    termAddr := Result and $ffff;
end;

procedure TF_Main.edt_con_addrKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    inherited;
    //O_ProTx.SetDeviceAddr(StrAddrToInt(TEdit(Sender).Text));
    O_ProTx.SetDeviceAddr(StrToInt(TEdit(Sender).Text));
end;

procedure TF_Main.tmr1Timer(Sender: TObject);
var now:SYSTEMTIME;
begin
    GetLocalTime(now);
    stat_bar.Panels[1].Text := Format('  %.4d-%.2d-%.2d   %.2d:%.2d:%.2d',[Now.wYear, Now.wMonth, Now.wDay, Now.wHour, Now.wMinute, Now.wSecond]);
    stat_bar.Panels[2].Text := Format('Tx: %d',[m_nTxCounter]);
    stat_bar.Panels[3].Text := Format('Rx: %d',[m_nRxCounter]);
end;

procedure TF_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if MyMessageBox(Handle, '确定要退出系统吗？', '温馨提示', MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
        btnDisConnClick(btnDisConn);
        g_Process.Free;
        g_disp.Free;
        Action := caFree;
    end
    else
    begin
        Action := caNone;
    end;
end;

procedure TF_Main.SetDeviceAddr();
begin
end;
    
procedure TF_Main.strngrd_ipMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    SetDeviceAddr();
end;

function  TF_Main.GotoDevAddr(devAddr:Int64):Boolean;
var i:Integer;
begin
    Result := True;
end;

procedure TF_Main.btn1Click(Sender: TObject);
var buf:array[0..1024] of Byte;
    i:Integer;
begin
    buf[0] := $AA;
    buf[1] := $01;
    buf[2] := $BB;
    buf[3] := $4F;
    buf[4] := $46;
    {
    for i:=0 to 255 do
    begin
        buf[1] := i;
        O_ComComm.WriteCom(Handle, @buf[0], 5);
        Delay(500);
    end;
    }

    ZeroMemory(@buf[0], SizeOf(buf));
    buf[1023] := $16;
    //for i:=0 to 255 do
    begin
        //F_Operation.DisplayOperation( Format('%d', [i]) );
        //F_Frame.DisplayFrame(@buf[0], 1024);
    end;
end;

procedure TF_Main.txt_sel_protocolClick(Sender: TObject);
begin
    {F_Container.}SelProtocol();
end;

procedure TF_Main.txt_sel_protocolMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    TStaticText(Sender).Font.Color := clRed;
end;

procedure TF_Main.pnl4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i:Integer;
begin
    for i:=0 to TPanel(Sender).ControlCount-1 do
    begin
        if TPanel(Sender).Controls[i] is TStaticText then
        begin
            TStaticText(TPanel(Sender).Controls[i]).Font.Color := clBlack; 
        end;
    end;
end;

procedure TF_Main.txt_sel_protocolMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    TStaticText(Sender).Font.Color := clBlack; 
end;

procedure TF_Main.edt_timeoutKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    TryStrToInt(edt_timeout.Text, g_timeout);
end;

procedure TF_Main.N_CloseConnectionClick(Sender: TObject);
var ip:string;
    port:Integer;
begin
    if cbb_ConnMode.ItemIndex = conn_mode_tcp_server then
    begin
    end;
end;

end.
