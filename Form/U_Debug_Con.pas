unit U_Debug_Con;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_Debug, StdCtrls, Buttons,U_MyFunction,U_Protocol;

type
  TF_Debug_Con = class(TF_Debug)
    lbl5: TLabel;
    edt_Pn: TEdit;
    btn1: TBitBtn;
    edt1: TEdit;
    edt2: TEdit;
    procedure btn_create_frameClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn_sendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
      m_len:Integer;
  public
    { Public declarations }
  end;

var
  F_Debug_Con: TF_Debug_Con;

implementation

uses U_Main;

{$R *.dfm}

procedure TF_Debug_Con.btn_create_frameClick(Sender: TObject);
var p:Integer;
    AFN,Pn,Fn:Integer;
    crc:Word;
begin
    p := HexToBuf(edt_dataunit.Text,@m_dataUnit[0]);

    if p>0 then
    begin
        crc := O_ProTx.mb_crc16(@m_dataUnit[0], p);

        MoveMemory(@m_dataUnit[p], @crc, 2);
        Inc(p, 2);

        edt_frame.Text := BufToHex(@m_dataUnit[0], p);

        m_len := p;
    end;
end;

procedure TF_Debug_Con.btn1Click(Sender: TObject);
var buf:array[0..2047] of Byte;
    len:Integer;
begin
    len := HexToBuf(edt_frame.Text, @buf[0]);
    F_Main.SendData(@buf[0], len, edt1.Text, StrToInt(edt2.Text));
end;

procedure TF_Debug_Con.btn_sendClick(Sender: TObject);
begin
    F_Main.SendData(@m_dataUnit[0], m_len);
end;

procedure TF_Debug_Con.FormCreate(Sender: TObject);
begin
  inherited;
    m_len := 0;
end;

end.
