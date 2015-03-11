unit U_Update_Con_Mod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_Update, ImgList, ExtCtrls, StdCtrls, Buttons,U_Protocol,
  U_Protocol_con, U_MyFunction, U_UpdateDev;

type
  TF_Update_Con_Mod = class(TF_Update)
  private
    { Private declarations }
  public
    { Public declarations }
    function GetDataUnit():PByte;override;
    function GetDataUnitLen():Integer;override;
    procedure ParseData(pCommEntity:Pointer=nil);override;
    function MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;override;
  end;

var
  F_Update_Con_Mod: TF_Update_Con_Mod;

implementation

{$R *.dfm}

function TF_Update_Con_Mod.MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
var pParam:PDataTranParam;
    pHeader:PFileHeader;
begin
    O_ProTx_Mod.MakeFrame(AFN, Fn, pDataUnit, len, Pn, IS_COMM_MODULE_ID_PLC);

    pHeader := PFileHeader(pDataUnit);

    pParam := @m_dataUnit[0];
    pParam.nPort := PLC_PORT_NO;
    pParam.tranCtrl := 0;
    if (pHeader<>nil) and (pHeader.fileCmd=file_cmd_tran) then
    begin
        pParam.nFrameTimeout := 80; //80*10ms
    end
    else
    begin
        pParam.nFrameTimeout := $80 or (g_timeout div 1000) ; //PLC_TRAN_TIMEOUT*1000ms
    end;
    
    pParam.nByteTimeout := 1;
    pParam.nTranLen := O_ProTx_Mod.GetFrameLen();
    MoveMemory(@pParam.data[0], O_ProTx_Mod.GetFrameBuf(), O_ProTx_Mod.GetFrameLen());

    O_ProTx.MakeFrame(AFN_TRANS,F1,@(pParam^),O_ProTx_Mod.GetFrameLen()+sizeof(TDataTranParam)-sizeof(pParam.data));
end;

function TF_Update_Con_Mod.GetDataUnit():PByte;
begin
    Result := O_ProRx_Mod.GetDataUnit();
end;

function TF_Update_Con_Mod.GetDataUnitLen():Integer;
begin
    Result := O_ProRx_Mod.GetDataUnitLen();
end;

procedure TF_Update_Con_Mod.ParseData(pCommEntity:Pointer=nil);
begin
    if (O_ProRx.GetAFN() = AFN_TRANS) and (O_ProRx.GetFn() = F1) then
    begin
        if O_ProRx_Mod.CheckFrame(O_ProRx.GetDataUnit(), O_ProRx.GetDataUnitLen()) then
        begin
            if (O_ProRx_Mod.GetAFN() = AFN_UPDATE_SELF) and (O_ProRx_Mod.GetFn() = F1) then
            begin
                ParseUpdate(GetDataUnit(), GetDataUnitLen());
            end;
        end;
    end;
end;
  
end.
