unit U_Operation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, U_MyFunction, Menus;

type
  TF_Operation = class(TForm)
    strngrd_oper: TStringGrid;
    pm1: TPopupMenu;
    N_scroll: TMenuItem;
    N2: TMenuItem;
    N_clear: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure strngrd_operDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure strngrd_operKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N_clearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function  DisplayOperation(strConten:string):Boolean;
    function  ClearOperation():Boolean;
  end;

var
  F_Operation: TF_Operation;

implementation

{$R *.dfm}
const oper_col_time    = 1;
      oper_col_oper    = 2;

procedure TF_Operation.FormCreate(Sender: TObject);
begin
    //strngrd_oper.ColWidths[0] := 12;
    strngrd_oper.ColWidths[0] := 0;
    strngrd_oper.ColWidths[oper_col_time] := 150;
    strngrd_oper.ColWidths[oper_col_oper] := 1195;
    strngrd_oper.Cells[oper_col_time,0] := 'Ê±¼ä';
    strngrd_oper.Cells[oper_col_oper,0] := '²Ù×÷';
end;

function  TF_Operation.DisplayOperation(strConten:string):Boolean;
var t:SYSTEMTIME;
    strTime:string;
    nRow:Integer;
begin
    GetLocalTime(t);
    strTime := Format('%.2d:%.2d:%.2d %.3d',[t.wHour,t.wMinute,t.wSecond,t.wMilliseconds]);
    nRow := strngrd_oper.RowCount-1;
    if strngrd_oper.Cells[oper_col_time,nRow]<>'' then
    begin
        Inc(nRow);
        strngrd_oper.RowCount := nRow + 1;
    end;
    strngrd_oper.Cells[oper_col_time,nRow] := strTime;
    strngrd_oper.Cells[oper_col_oper,nRow] := strConten;
    
    if N_scroll.Checked then
    begin
        strngrd_oper.Row := strngrd_oper.RowCount-1;
    end;
end;

function  TF_Operation.ClearOperation():Boolean;
var i:Integer;
begin
    strngrd_oper.RowCount := 2;
    strngrd_oper.Rows[1].Clear;
end;
    
procedure TF_Operation.strngrd_operDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
    if (gdSelected in State) or (ARow=0) then Exit;
    if ACol<=(Sender as TStringGrid).FixedCols-1 then Exit;
    if ARow mod 2 =1 then
    begin
        (Sender as TStringGrid).Canvas.Brush.Color := clInfoBk;
        (Sender as TStringGrid).canvas.FillRect(rect);
        (Sender as TStringGrid).Canvas.textrect(Rect,Rect.left+1,Rect.Top+1,(Sender as TStringGrid).Cells[aCol,aRow]);
    end
    else
    begin
        (Sender as TStringGrid).Canvas.Brush.Color := RGB(191, 255, 223);
        (Sender as TStringGrid).canvas.FillRect(rect);
        (Sender as TStringGrid).Canvas.textrect(Rect,Rect.left+1,Rect.Top+1,(Sender as TStringGrid).Cells[aCol,aRow]);
    end;
end;

procedure TF_Operation.strngrd_operKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if ssCtrl in Shift then
        case Key of
            Ord('C'): StringGridCopyToClipboard(TStringGrid(Sender));
        end;
end;

procedure TF_Operation.N_clearClick(Sender: TObject);
begin
    ClearOperation();
end;

end.
