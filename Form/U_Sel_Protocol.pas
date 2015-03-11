unit U_Sel_Protocol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TF_Sel_Protocol = class(TForm)
    rg_protocol: TRadioGroup;
    btn_ok: TBitBtn;
    btn1: TBitBtn;
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Sel_Protocol: TF_Sel_Protocol;

implementation

uses
  U_Protocol,U_Protocol_con,U_Protocol_mod;

{$R *.dfm}

procedure TF_Sel_Protocol.btn_okClick(Sender: TObject);
begin
    case rg_protocol.ItemIndex of
      0:
        g_func_type := FUNC_CON_CHKMETER;
      1:
        g_func_type := FUNC_CON_UPDATE;
      2:
        g_func_type := FUNC_MOD_UPDATE;
      3:
        g_func_type := FUNC_CON_MOD;
    end;
end;

procedure TF_Sel_Protocol.FormShow(Sender: TObject);
begin
    case g_func_type of
      FUNC_CON_CHKMETER:
        rg_protocol.ItemIndex := 0;
      FUNC_CON_UPDATE:
        rg_protocol.ItemIndex := 1;
      FUNC_MOD_UPDATE:
        rg_protocol.ItemIndex := 2;
      FUNC_CON_MOD:
        rg_protocol.ItemIndex := 3;
    end;
    {
    rg_protocol.Controls[0].Enabled := False;
    rg_protocol.Controls[2].Enabled := False;
    rg_protocol.Controls[3].Enabled := False;
    }
end;

end.
