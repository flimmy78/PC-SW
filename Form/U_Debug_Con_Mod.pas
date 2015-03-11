unit U_Debug_Con_Mod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_Debug, StdCtrls, Buttons, U_Protocol_con, U_Protocol;

type
  TF_Debug_Con_Mod = class(TF_Debug)
  private
    { Private declarations }
    function MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;override;
  public
    { Public declarations }
  end;

var
  F_Debug_Con_Mod: TF_Debug_Con_Mod;

implementation

{$R *.dfm}

function TF_Debug_Con_Mod.MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
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

end.
