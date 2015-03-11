unit U_Container;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, U_Update, U_Frame, U_Operation,
  U_ParamReadWrite, U_Param_Mod, U_Param_Con, U_Update_Con_Mod, U_Debug,
  U_Param_ChkMeter, U_Protocol, U_Param_Con_Mod, U_Debug_Con_Mod, U_Debug_Con,
  U_Protocol_mod, U_Protocol_con, U_Protocol_645;

type
  TF_Container = class(TForm)
    scrlbx1: TScrollBox;
    pgc2: TPageControl;
    ts_operation: TTabSheet;
    ts_frame: TTabSheet;
    pgc1: TPageControl;
    ts_update: TTabSheet;
    ts_chkmeter: TTabSheet;
    ts_param_read_write: TTabSheet;
    ts_debug: TTabSheet;
    spl1: TSplitter;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_ip:string;
    m_port:Integer;
    m_fUpdate:TF_Update;
    m_fParam:TF_ParamReadWrite;
    m_fDebug:TF_Debug;
    m_fLog:TF_Operation;
    m_fFrame:TF_Frame;
    m_fChkMeter:TF_Param_ChkMeter;
  public
    { Public declarations }
    function  SelProtocol():Boolean;
  end;

var
  F_Container: TF_Container;

implementation

uses U_Sel_Protocol, U_Main;

{$R *.dfm}

procedure TF_Container.FormShow(Sender: TObject);
begin
    m_ip   := '';
    m_port := 0;

    m_fUpdate :=nil;
    m_fParam :=nil;
    m_fDebug :=nil;
    m_fLog :=nil;
    m_fFrame :=nil;
    m_fChkMeter :=nil;

    SelProtocol();
end;

function  TF_Container.SelProtocol():Boolean;
var i:Integer;
    addr:Int64;
begin
    Result := False;
    Application.CreateForm(TF_Sel_Protocol, F_Sel_Protocol);
    
    if F_Sel_Protocol.ShowModal<> mrOk then
    begin
        FreeAndNil(F_Sel_Protocol);
        Exit;
    end;

    FreeAndNil(F_Sel_Protocol);

    if m_fUpdate<>nil then        FreeAndNil(m_fUpdate);
    if m_fParam<>nil then         FreeAndNil(m_fParam);
    if m_fDebug<>nil then         FreeAndNil(m_fDebug);
    if m_fLog<>nil then           FreeAndNil(m_fLog);
    if m_fFrame<>nil then         FreeAndNil(m_fFrame);
    if m_fChkMeter<>nil then      FreeAndNil(m_fChkMeter);

    if O_ProTx<>nil then      FreeAndNil(O_ProTx);
    if O_ProRx<>nil then      FreeAndNil(O_ProRx);
    if F_Main.m_O_ProTmp<>nil then   FreeAndNil(F_Main.m_O_ProTmp);
    if O_ProTx_Mod<>nil then  FreeAndNil(O_ProTx_Mod);
    if O_ProRx_Mod<>nil then  FreeAndNil(O_ProRx_Mod);
    if O_ProTx_645<>nil then  FreeAndNil(O_ProTx_645);
    if O_ProRx_645<>nil then  FreeAndNil(O_ProRx_645);

    if g_func_type = FUNC_MOD_UPDATE then
    begin
        O_ProTx := T_Protocol_mod.Create;
        O_ProRx := T_Protocol_mod.Create;
        F_Main.m_O_ProTmp := T_Protocol_mod.Create;

        m_fUpdate := TF_Update.Create(Self);
        m_fParam := TF_Param_Mod.Create(Self);
        m_fDebug := TF_Debug.Create(Self);
        m_fLog   := TF_Operation.Create(Self);
        m_fFrame := TF_Frame.Create(Self);

        Application.Title := '路由板升级程序';
    end
    else if g_func_type = FUNC_CON_MOD then
    begin
        O_ProTx := T_Protocol_con.Create;
        O_ProRx := T_Protocol_con.Create;
        F_Main.m_O_ProTmp := T_Protocol_con.Create;
        O_ProTx_Mod := T_Protocol_mod.Create;
        O_ProRx_Mod := T_Protocol_mod.Create;

        m_fUpdate := TF_Update_Con_Mod.Create(Self);
        m_fParam := TF_Param_Con_Mod.Create(Self);
        m_fDebug := TF_Debug_Con_Mod.Create(Self);
        m_fLog   := TF_Operation.Create(Self);
        m_fFrame := TF_Frame.Create(Self);
        
        Application.Title := '路由板升级程序（集中器转发）';
    end
    else if g_func_type = FUNC_CON_UPDATE then
    begin
        O_ProTx := T_Protocol_con.Create;
        O_ProRx := T_Protocol_con.Create;
        F_Main.m_O_ProTmp := T_Protocol_con.Create;

        m_fUpdate := TF_Update.Create(Self);
        m_fParam := TF_Param_Con.Create(Self);
        m_fDebug := TF_Debug_Con.Create(Self);
        m_fLog   := TF_Operation.Create(Self);
        m_fFrame := TF_Frame.Create(Self);
        
        Application.Title := '集中器升级程序';
    end
    else if g_func_type = FUNC_CON_CHKMETER then
    begin
        O_ProTx := T_Protocol_con.Create;
        O_ProRx := T_Protocol_con.Create;
        F_Main.m_O_ProTmp := T_Protocol_con.Create;
        O_ProTx_645 := T_Protocol_645.Create;
        O_ProRx_645 := T_Protocol_645.Create;

        m_fParam := TF_Param_Con.Create(Self);
        m_fDebug := TF_Debug_Con.Create(Self);
        m_fLog   := TF_Operation.Create(Self);
        m_fFrame := TF_Frame.Create(Self);
        m_fChkMeter := TF_Param_ChkMeter.Create(Self);
        
        ts_update.TabVisible := False;
        ts_chkmeter.TabVisible := True;
        
        Application.Title := '交采校准程序';
    end;

    if TryStrToInt64('x'+F_Main.edt_con_addr.Text, addr) then
    begin
        O_ProTx.SetDeviceAddr(addr);
    end;

    F_Main.Caption := Application.Title;

    for i:=pgc1.PageCount-1 downto 0 do
    begin
        pgc1.Pages[i].TabVisible := False;
    end;

    if m_fUpdate<>nil then
    begin
        m_fUpdate.Parent := ts_update;           m_fUpdate.Show;
        ts_update.TabVisible := True;
    end;

    if m_fParam<>nil then
    begin
        m_fParam.Parent := ts_param_read_write; m_fParam.Show;
        ts_param_read_write.TabVisible := True;
    end;

    if m_fDebug<>nil then
    begin
        m_fDebug.Parent          := ts_debug;            m_fDebug.Show;
        ts_debug.TabVisible := True;
    end;

    if m_fLog<>nil then
    begin
        m_fLog.Parent      := ts_operation;        m_fLog.Show;
        ts_operation.TabVisible := True;
    end;

    if m_fFrame<>nil then
    begin
        m_fFrame.Parent          := ts_frame;            m_fFrame.Show;
        ts_frame.TabVisible := True;
    end;

    if m_fChkMeter<>nil then
    begin
        m_fChkMeter.Parent := ts_chkmeter;   m_fChkMeter.Show;
        ts_chkmeter.TabVisible := True;
    end;

    for i:=pgc1.PageCount-1 downto 0 do
    begin
        if pgc1.Pages[i].TabVisible then
        begin
            pgc1.ActivePageIndex := i;
        end;
    end;

    Result := True;
end;
    
procedure TF_Container.FormCreate(Sender: TObject);
begin
    m_fUpdate :=nil;
    m_fParam :=nil;
    m_fDebug :=nil;
    m_fLog :=nil;
    m_fFrame :=nil;
    m_fChkMeter :=nil;
end;

end.
