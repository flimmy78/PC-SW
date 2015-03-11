unit U_MyClass;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,Grids,
  StdCtrls, Menus, ToolWin, ComCtrls, ExtCtrls,Dialogs,Forms;

{********************************************************************************
*�����ƣ�TStringGridInputType
*�๦�ܣ��ؼ����ƶ��壬ÿһ����begin��end�ָ�����0����ʾû�пؼ������һ����ʾǰ������пؼ�
*���ߣ�Sen,2008.11.27
********************************************************************************}
type TStringGridInputType=(
        InputTypeRemove,//��ʼΪ0��ûЧ�ؼ�
    InputTypeCheckBegin,
        InputTypeCheck,
        InputTypeUncheck,
    InputTypeCheckEnd,
    InputTypeListBegin,
        InputTypeComboBox,
        InputTypeDateTimePicker,
        InputTypeListAll,
    InputTypeListEnd,
    InputTypeAll//������������
        );
{********************************************************************************
*�����ƣ�TStringGridCheckBox
*�๦�ܣ���TStringGrid�ĵ�Ԫ��CheckBox���ȶ�̬����CheckBoxЧ�ʸߵö�
*���ߣ�Sen,2008.10.6
********************************************************************************}
type
  TStringGridCheckBox = class
  private
    FCheck,FNoCheck:TBitmap;
    GridDrawState:TGridDrawState;
    ACol,ARow:Integer;
  public
    constructor Create();
    destructor Destroy();override;
    procedure DrawCellWithCheckBox(Sender: TObject; ACol,ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure CheckHorizontalFixedTile(Sender: TObject;Checked:bool=true);//��һ�л���checkbox
    procedure CheckVerticalFixedTile(Sender: TObject;Checked:bool=true);//��һ�л���checkbox
    procedure CheckCell(Sender: TObject;ACol,ARow:Integer;Checked:bool=true);//��Ԫ����checkbox
    function  GetCellChecked(Sender: TObject;ACol,ARow:Integer):bool;//��ȡcheckbox��״̬
    procedure RemoveCheckBox(Sender: TObject;ACol,ARow:Integer);//ɾ��checkbox
    procedure StringGridCheckBoxOnMouse(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);//�л���ѡ��״̬
    procedure ClearContent(Sender: TObject);//��ձ�����ݣ�������������
end;//end type TStringGridCheckBox
var StrintGridCheckBox:TStringGridCheckBox;

{********************************************************************************
*�����ƣ�TStringGridInput
*�๦�ܣ���TStringGrid�ĵ�Ԫ�������������ؼ�
*���ߣ�Sen,2008.11.26
********************************************************************************}
type
  TStringGridInput = class(TForm)
  private
    nCol,nRow:integer;
    StringGrid:TStringGrid;
    procedure CreateInput(InputType:TStringGridInputType);
    procedure DestroyInput(InputType:TStringGridInputType);
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
  public
    ComboBox:TComboBox;
    DateTimePicker:TDateTimePicker;
    constructor Create();
    destructor Destroy();override;
    procedure SetOwner(AOwner:TStringGrid);
    procedure SetCellInputType(Sender:TObject;ACol,ARow:Integer;InputType:TStringGridInputType);
    procedure StringGridInputSelectCell(Sender:TObject;ACol,ARow:Integer;var CanSelect:Boolean);
    procedure OnClickEvent(Sender:TObject);
    procedure OnExitEvent(Sender:TObject);
    procedure FreeOwner();
end;//end type TStringGridInput

implementation
{*************************************************************
*����ΪTStringGridInput���ʵ�ֲ���
*************************************************************}
constructor TStringGridInput.Create();
begin
  ComboBox:=Nil;
  DateTimePicker:=Nil;
  StringGrid:=Nil;
end;
destructor TStringGridInput.Destroy();
begin
  FreeOwner();
  Release;
end;

procedure TStringGridInput.SetOwner(AOwner:TStringGrid);
begin
  StringGrid:=AOwner;
  CreateInput(InputTypeListAll);
end;

procedure TStringGridInput.StringGridInputSelectCell(Sender: TObject; ACol,ARow: Integer; var CanSelect: Boolean);
var Rect:TRect;
    i:integer;
begin
  SetOwner(Sender as TStringGrid);
  Rect:=StringGrid.CellRect(ACol,ARow);
  case TStringGridInputType(StringGrid.Objects[ACol,ARow]) of
    InputTypeComboBox:
    begin
        nCol:=ACol;nRow:=ARow;
			  ComboBox.ItemIndex:=0;
			  for i:=0 to ComboBox.Items.Count-1 do
			    if StringGrid.Cells[Acol,ARow]=ComboBox.Items.Strings[i] then
			    begin
			      ComboBox.ItemIndex:=i;
			      break;
			    end;
			  ComboBox.ItemHeight:=Rect.Bottom-Rect.Top-3;
			  ComboBox.SetBounds(Rect.Left+StringGrid.Left,Rect.Top+StringGrid.Top,Rect.Right-Rect.Left+3,Rect.Bottom-Rect.Top);
			  ComboBox.Visible:=true;
			  ComboBox.SetFocus;
    end;
    InputTypeDateTimePicker:
    begin
        nCol:=ACol;nRow:=ARow;
        DateTimePicker.SetBounds(Rect.Left+StringGrid.Left,Rect.Top+StringGrid.Top,Rect.Right-Rect.Left+3,Rect.Bottom-Rect.Top+4);
        DateTimePicker.Visible:=true;
        DateTimePicker.SetFocus;
    end;
    else
    begin
      nCol:=0;nRow:=0;
    end;
  end;//end case
end;

procedure TStringGridInput.OnClickEvent(Sender: TObject);
var FormatSettings:TFormatSettings;
    Formatstring:string;
    i:integer;
begin
  if Sender is TComboBox then
  begin
    StringGrid.Cells[nCol,nRow]:=ComboBox.Items.Strings[ComboBox.ItemIndex];
    ComboBox.Visible:=false;
  end
  else if Sender is TDateTimePicker then
  begin
    DateTimePicker.Visible:=false;
    //FormatSettings.ShortDateFormat:='yyyy-MM-dd';
    FormatSettings.ShortDateFormat:=DateTimePicker.Format;
    //StringGrid.Cells[nCol,nRow]:=DateTimeToStr(DateTimePicker.DateTime,FormatSettings);
    if DateTimePicker.Kind=dtkTime then
    begin
      Formatstring:=DateTimePicker.Format;
      for i:=0 to length(Formatstring)-1 do
      begin
        if Formatstring[i]='m' then
        begin
          Formatstring[i]:='n';
        end;
      end;
      StringGrid.Cells[nCol,nRow]:=formatdatetime(Formatstring,DateTimePicker.DateTime);
    end
    else
    begin
      StringGrid.Cells[nCol,nRow]:=formatdatetime(DateTimePicker.Format,DateTimePicker.DateTime);
    end;
  end
  else;
end;

procedure TStringGridInput.OnExitEvent(Sender:TObject);
begin
  OnClickEvent(Sender);
end;

procedure TStringGridInput.SetCellInputType(Sender:TObject;ACol,ARow:Integer;InputType:TStringGridInputType);
begin
  StringGrid.Objects[ACol,ARow]:=TObject(InputType);
end;

procedure TStringGridInput.CreateInput(InputType:TStringGridInputType);
var i:integer;
begin
  case InputType of
    InputTypeComboBox:
    begin
			  if not Assigned(ComboBox) then
			  begin
			    ComboBox:=TComboBox.Create(Application);
			    ComboBox.Style:=csOwnerDrawFixed;
			    ComboBox.Visible:=false;
			    ComboBox.OnClick:=OnClickEvent;
          ComboBox.OnExit:=OnExitEvent;
          ComboBox.Parent:=StringGrid.Parent;
          //ComboBox.FreeNotification(self);//self     StringGridInput
			  end;
        if Assigned(ComboBox) and Assigned(StringGrid.Parent) then // 
        begin
          ComboBox.Parent:=StringGrid.Parent;
        end;
    end;
    InputTypeDateTimePicker:
    begin
			  if not Assigned(DateTimePicker) then
			  begin
			    DateTimePicker:=TDateTimePicker.Create(Application);
			    DateTimePicker.Visible:=false;
			    DateTimePicker.OnCloseUp:=OnClickEvent;
          DateTimePicker.OnExit:=OnExitEvent;
			    DateTimePicker.Parent:=StringGrid.Parent;
          DateTimePicker.Format:='yyyy-MM-dd';
			  end;
        if Assigned(DateTimePicker) and Assigned(StringGrid.Parent) then
        begin
          DateTimePicker.Parent:=StringGrid.Parent;
        end;
    end;
    InputTypeListAll://�ݹ鴴����������ؼ�
    begin
        for i:=ord(InputTypeListBegin)+1 to ord(InputTypeListAll)-1 do
        begin
          CreateInput(TStringGridInputType(i));
        end;
    end;
    else;
  end;//end case
end;

procedure TStringGridInput.DestroyInput(InputType:TStringGridInputType);
var i:integer;
begin
  case InputType of
    InputTypeComboBox:
    begin
          if Assigned(ComboBox) then
          begin
            ComboBox.Items.Clear();
            ComboBox.Parent:=Nil;
            ComboBox:=Nil;
            ComboBox.Free();
          end;
    end;
    InputTypeDateTimePicker:
    begin
        if Assigned(DateTimePicker) then
        begin
          DateTimePicker.Parent:=Nil;
          DateTimePicker:=Nil;
          DateTimePicker.Free();
        end;
    end;
    InputTypeListAll://�ݹ�ע����������ؼ�
    begin
        for i:=ord(InputTypeListBegin)+1 to ord(InputTypeListAll)-1 do
        begin
          DestroyInput(TStringGridInputType(i));
        end;
    end;
    else;
  end;//end case
end;

procedure TStringGridInput.FreeOwner();
begin
  DestroyInput(InputTypeListAll);
end;

procedure TStringGridInput.Notification(AComponent:TComponent;Operation:TOperation);
begin
  Showmessage('Notification');
end;


{*************************************************************
*����ΪTStringGridCheckBox���ʵ�ֲ���
*************************************************************}
constructor TStringGridCheckBox.Create();
var bmp: TBitmap;
begin
	FCheck:= TBitmap.Create;
	FNoCheck:= TBitmap.Create;
	bmp:= TBitmap.create;
	try
	    bmp.handle := LoadBitmap( 0, PChar(OBM_CHECKBOXES ));
	    // bmp now has a 4x3 bitmap of divers state images
	    // used by checkboxes and radiobuttons
      With FNoCheck Do 
		Begin
		    // the first subimage is the unchecked box
		    width := bmp.width div 4;
		    height := bmp.height div 3;
		    canvas.copyrect( canvas.cliprect, bmp.canvas, canvas.cliprect );
	    End;
	    With FCheck Do 
		Begin
		    // the second subimage is the checked box
		    width := bmp.width div 4;
		    height := bmp.height div 3;
		    canvas.copyrect(canvas.cliprect,bmp.canvas,rect( width, 0, 2*width, height ));
	    End;
	finally
	    bmp.free
	end;
end;
destructor TStringGridCheckBox.Destroy();
begin
  FNoCheck.Free;
  FCheck.Free;
end;
procedure TStringGridCheckBox.DrawCellWithCheckBox(Sender: TObject; ACol,ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  grid: TStringgrid;
  tmpRect:TRect;
  x,y:integer;
begin
  //if (ARow=0)or(ACol=0) then
  begin
	    With (Sender As TStringgrid).Canvas Do
			Begin
        tmpRect:=rect;
		    //brush.color := $E0E0E0;// checkboxes look better on a non-white background
		    Fillrect( tmpRect );
        x:= rect.left+5;
        y:=(rect.bottom + rect.top - FCheck.height) div 2;
		    If ((Sender As TStringgrid).Objects[ACol,ARow]=TObject(InputTypeCheck)) Then //(ARow<>ACol)and
        begin
            Draw(x,y,FCheck);
            tmpRect.Left:=x+3+FCheck.Width;
            Textrect(tmpRect,tmpRect.Left,y,(Sender as TStringGrid).Cells[aCol,aRow]);
        end
		    Else If ((Sender As TStringgrid).Objects[ACol,ARow]=TObject(InputTypeUncheck)) Then //(ARow<>ACol)and
        begin
            Draw(x,y,FNoCheck);
            tmpRect.Left:=x+3+FCheck.Width;
            Textrect(tmpRect,tmpRect.Left,y,(Sender as TStringGrid).Cells[aCol,aRow]);
        end
		    Else
        begin
          tmpRect.Left:=x+3;
          Textrect(tmpRect,tmpRect.Left,y,(Sender as TStringGrid).Cells[aCol,aRow]);
        end;

      End;
  end;
end;
procedure TStringGridCheckBox.CheckHorizontalFixedTile(Sender:TObject;Checked:bool=true);
var
  grid: TStringgrid;
  i:integer;
begin
  grid:=Sender As TStringgrid;
  ARow:=grid.FixedRows-1;
  for i:= grid.FixedCols to grid.ColCount-1 do
  begin
    //if Checked then grid.Objects[i,ARow]:=TObject(InputTypeCheck)
    if (Checked)and(grid.ColWidths[i]<>-1) then grid.Objects[i,ARow]:=TObject(InputTypeCheck)//2009��9��16��14:55:09���������в�ѡ��
    else grid.Objects[i,ARow]:=TObject(InputTypeUncheck);
  end;
end;

procedure TStringGridCheckBox.CheckVerticalFixedTile(Sender: TObject;Checked:bool=true);
var
  grid: TStringgrid;
  i:integer;
begin
  grid:=Sender As TStringgrid;
  for i:= grid.FixedRows to grid.RowCount-1 do
  begin
    //if Checked then grid.Objects[grid.FixedCols-1,i]:=TObject(InputTypeCheck)
    if (Checked)and(grid.RowHeights[i]<>-1) then grid.Objects[grid.FixedCols-1,i]:=TObject(InputTypeCheck)//2009��9��16��14:55:09���������в�ѡ��
    else grid.Objects[grid.FixedCols-1,i]:=TObject(InputTypeUncheck);
  end;
end;

procedure TStringGridCheckBox.CheckCell(Sender: TObject;ACol,ARow:Integer;Checked:bool=true);
var
  grid: TStringgrid;
begin
  grid:=Sender As TStringgrid;
  if Checked then
    grid.Objects[ACol,ARow]:=TObject(InputTypeCheck)
  else
    grid.Objects[ACol,ARow]:=TObject(InputTypeUncheck);
end;

function TStringGridCheckBox.GetCellChecked(Sender: TObject;ACol,ARow:Integer):bool;
var grid: TStringgrid;
begin
  grid:=Sender As TStringgrid;
  if grid.Objects[ACol,ARow]=TObject(InputTypeCheck) then
    result:=true
  else
    result:=false;
end;

procedure TStringGridCheckBox.RemoveCheckBox(Sender: TObject;ACol,ARow:Integer);
var grid: TStringgrid;
begin
  grid:=Sender As TStringgrid;
  grid.Objects[ACol,ARow]:=TObject(InputTypeRemove);
end;

procedure TStringGridCheckBox.StringGridCheckBoxOnMouse(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i,j:integer;
    grid: TStringgrid;
    Rect: TGridRect;
begin
  grid:=Sender As TStringgrid;
  for i:=0 to grid.RowCount-1 do//��һ��
  begin
    for j:=0 to grid.ColCount-1 do
    begin
      if PtInRect(grid.CellRect(j,i),Point(X,Y))then
      begin
        if grid.Objects[j,i]=TObject(InputTypeCheck) then
          grid.Objects[j,i]:=TObject(InputTypeUncheck)
        else if grid.Objects[j,i]=TObject(InputTypeUncheck) then
          grid.Objects[j,i]:=TObject(InputTypeCheck)
        else;
        exit;
      end;
    end;
  end;
end;

procedure TStringGridCheckBox.ClearContent(Sender: TObject);
var i,j:integer;
    grid: TStringgrid;
begin
  grid:=Sender As TStringgrid;
  for i:=1 to grid.RowCount-1 do
  begin
    for j:=1 to grid.ColCount-1 do
    begin
      grid.Cells[j,i]:='';
    end;
  end;
end;

initialization
    

end.
