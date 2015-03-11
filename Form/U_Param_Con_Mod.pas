unit U_Param_Con_Mod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_Param_Mod, StdCtrls, Buttons, U_MyFunction, DateUtils;

type
  TF_Param_Con_Mod = class(TF_Param_Mod)
    procedure btn_stop_plcClick(Sender: TObject);
    procedure btn_resume_plcClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_dataUnit:array[0..2047] of Byte;
    m_bResp_con:Boolean;
    function WaitForResp_con(Sender: TObject;AFN,Fn:Byte):Boolean;
  public
    { Public declarations }
    function MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;override;
    function GetDataUnit():PByte;override;
    function GetDataUnitLen():Integer;override;
    function GetAFN():Byte;override;
    function GetFn():Byte;override;
    procedure ParseData(pCommEntity:Pointer=nil);override;
    function Test():Byte;
  end;

var
  F_Param_Con_Mod: TF_Param_Con_Mod;

implementation

{$R *.dfm}
uses
  U_Protocol,U_Protocol_con, U_Protocol_645, U_Main, U_ParamReadWrite;

function TF_Param_Con_Mod.Test():Byte;
begin
    ShowMessage('22222');
end;

function TF_Param_Con_Mod.MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
var pParam:PDataTranParam;
begin
    O_ProTx_Mod.MakeFrame(AFN, Fn, pDataUnit, len, Pn, IS_COMM_MODULE_ID_PLC);
    pParam := @m_dataUnit[0];
    pParam.nPort := PLC_PORT_NO;
    pParam.tranCtrl := 0;
    pParam.nFrameTimeout := $80 or (g_timeout div 1000);
    pParam.nByteTimeout := 1;
    pParam.nTranLen := O_ProTx_Mod.GetFrameLen();
    MoveMemory(@pParam.data[0], O_ProTx_Mod.GetFrameBuf(), O_ProTx_Mod.GetFrameLen());
    Result := O_ProTx.MakeFrame(AFN_TRANS,F1,@(pParam^),O_ProTx_Mod.GetFrameLen()+sizeof(TDataTranParam)-sizeof(pParam.data));
end;

function TF_Param_Con_Mod.GetDataUnit():PByte;
begin
    Result := O_ProRx_Mod.GetDataUnit();
end;
  
function TF_Param_Con_Mod.GetDataUnitLen():Integer;
begin
    Result := O_ProRx_Mod.GetDataUnitLen();
end;

function TF_Param_Con_Mod.GetAFN():Byte;
begin
    Result := O_ProRx_Mod.GetAFN();
end;

function TF_Param_Con_Mod.GetFn():Byte;
begin
    Result := O_ProRx_Mod.GetFn();
end;

procedure TF_Param_Con_Mod.ParseData(pCommEntity:Pointer=nil);
begin
    m_bResp_con := True;
    if O_ProRx_Mod.CheckFrame(O_ProRx.GetDataUnit(), O_ProRx.GetDataUnitLen()) then
    begin
        m_bResp := True;
    end;
end;

function TF_Param_Con_Mod.WaitForResp_con(Sender: TObject;AFN,Fn:Byte):Boolean;
var beginWait:TDateTime;
    clr:TColor;
    nWaitTime:Integer;
begin
    m_bResp_con := False;
    Result := False;
    beginWait := Now;

    nWaitTime := 12000;
    nWaitTime := nWaitTime + 2000*(O_ProTx.GetRelayLevel());

    if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clBlack;
    if Sender is TButton then TButton(Sender).Font.Color := clBlack;
    
    while (not m_bResp_con)and (Abs(MilliSecondsBetween(Now,beginWait))<nWaitTime) do
    begin
        Delay(100);
    end;

    if (m_bResp_con) then
    begin
        if (O_ProRx.GetAFN()=AFN)and(O_ProRx.GetFn()=Fn) then
        begin
            Result := True;
        end;
    end;

    if Result then
    begin
        clr := clSucced;
    end
    else
    begin
        clr := clFailed;
    end;
    if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clr;
    if Sender is TButton then TButton(Sender).Font.Color :=clr; 
end;

procedure TF_Param_Con_Mod.btn_stop_plcClick(Sender: TObject);
var dataUnit:array[0..127]of Byte;
begin
    //inherited;
    TButton(Sender).Enabled := False;
    g_bStop := False;
    dataUnit[0] := 31;
    O_ProTx.MakeFrame(AFN_CTRL,F49,@dataUnit[0],1);
    if F_Main.SendDataAuto()
      and WaitForResp_con(Sender,AFN_CONFIRM,F1)
    then;
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_Con_Mod.btn_resume_plcClick(Sender: TObject);
var dataUnit:array[0..127]of Byte;
begin
    //inherited;
    TButton(Sender).Enabled := False;
    g_bStop := False;
    dataUnit[0] := 31;
    O_ProTx.MakeFrame(AFN_CTRL,F50,@dataUnit[0],1);
    if F_Main.SendDataAuto()
      and WaitForResp_con(Sender,AFN_CONFIRM,F1)
    then;
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_Con_Mod.FormCreate(Sender: TObject);
begin
    inherited;
    m_bResp_con := False;
end;

end.
