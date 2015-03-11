unit U_Debug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, U_MyFunction, U_Protocol;

type
  TF_Debug = class(TForm)
    scrlbx1: TScrollBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    edt_AFN: TEdit;
    edt_Fn: TEdit;
    edt_dataunit: TEdit;
    edt_frame: TEdit;
    btn_create_frame: TBitBtn;
    btn_send: TBitBtn;
    procedure btn_create_frameClick(Sender: TObject);
    procedure btn_sendClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    m_dataUnit:array[0..2047] of Byte;
    function MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;virtual;
    function GetBuf():PByte;virtual;
    function GetLen():Integer;virtual;
  end;

var
  F_Debug: TF_Debug;

implementation

uses U_Main;
{$R *.dfm}

function TF_Debug.MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
begin
    O_ProTx.MakeFrame(AFN, Fn, pDataUnit, len, Pn, IS_COMM_MODULE_ID_PLC);
end;

function TF_Debug.GetBuf():PByte;
begin
    Result := O_ProTx.GetBuf()
end;

function TF_Debug.GetLen():Integer;
begin
    Result := O_ProTx.GetLen()
end;
    
procedure TF_Debug.btn_create_frameClick(Sender: TObject);
var p:Integer;
    AFN,Fn:Integer;
begin
    p := HexToBuf(edt_dataunit.Text,@m_dataUnit[0]);
    AFN := StrToInt('x'+edt_AFN.Text);
    Fn := StrToInt(edt_Fn.Text);
    MakeFrame(AFN,Fn,@m_dataUnit[0],p);
    edt_frame.Text := BufToHex(GetBuf(), GetLen);
end;

procedure TF_Debug.btn_sendClick(Sender: TObject);
begin
    g_bStop := False;
    F_Main.SendDataAuto();
end;

end.
