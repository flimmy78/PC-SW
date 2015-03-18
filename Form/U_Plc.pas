unit U_Plc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Grids, ExtCtrls;

type
  TF_Plc = class(TForm)
    scrlbx1: TScrollBox;
    grp1: TGroupBox;
    pnl1: TPanel;
    btn_read_prm: TBitBtn;
    strngrd_file_manage: TStringGrid;
    rb_name: TRadioButton;
    rb_size: TRadioButton;
    rb_content: TRadioButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Plc: TF_Plc;

implementation

{$R *.dfm}

const file_manage_name = 1;
      file_manage_size = 2;

procedure TF_Plc.FormCreate(Sender: TObject);
begin
    inherited;
    strngrd_file_manage.ColWidths[0] := 0;
    strngrd_file_manage.ColWidths[file_manage_name] := 650;
    strngrd_file_manage.ColWidths[file_manage_size] := 650;
    strngrd_file_manage.Cells[file_manage_name, 0]  := 'Ãû³Æ';
    strngrd_file_manage.Cells[file_manage_size, 0]  := '´óÐ¡';
end;

end.
