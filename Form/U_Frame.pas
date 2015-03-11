unit U_Frame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, U_MyFunction, Menus, StdCtrls, ComCtrls;

type
  TF_Frame = class(TForm)
    strngrd_frame: TStringGrid;
    pm1: TPopupMenu;
    N_scroll: TMenuItem;
    N2: TMenuItem;
    N_clear: TMenuItem;
    lv_frame: TListView;
    redt_frame: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure strngrd_frameDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure strngrd_frameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N_clearClick(Sender: TObject);
    procedure lv_frameCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    function  DisplayFrame(pBuf:PByte; len:Integer; bSend:Boolean=True; strIP:string=''; nPort:Integer=0):Boolean;
    function  ClearFrame():Boolean;
  end;

var
  F_Frame: TF_Frame;

implementation

{$R *.dfm}
const frame_col_time    = 1;
      frame_col_oper    = 2;
      frame_col_frame   = 3;

procedure TF_Frame.FormCreate(Sender: TObject);
begin
  {
    strngrd_frame.ColWidths[0] := 0;
    strngrd_frame.ColWidths[frame_col_time] := 85;
    strngrd_frame.ColWidths[frame_col_oper] := 60;
    strngrd_frame.ColWidths[frame_col_frame] := 590;
    strngrd_frame.Cells[frame_col_time,0] := '时间';
    strngrd_frame.Cells[frame_col_oper,0] := '操作';
    strngrd_frame.Cells[frame_col_frame,0] := '报文';
   }

end;

function  TF_Frame.DisplayFrame(pBuf:PByte;len:Integer;bSend:Boolean=True; strIP:string=''; nPort:Integer=0):Boolean;
var t:SYSTEMTIME;
    strOper:string;
    strTime:string;
    nRow:Integer;

    pListItem:TListItem;
    aa:   integer;
    tagS:   tagScrollInfo;
begin
    GetLocalTime(t);
    //strTime := Format('%.2d:%.2d:%.2d %.3d',[t.wHour,t.wMinute,t.wSecond,t.wMilliseconds]);

    redt_frame.SelStart := redt_frame.GetTextLen;
    //redt_frame.SelLength := redt_frame.GetTextLen;

    if bSend then
    begin
        strOper := '发送';
        redt_frame.SelAttributes.Color := clBlue;
    end
    else
    begin
        //strOper := '    接收';
        strOper := '接收';
        redt_frame.SelAttributes.Color := clGreen;
    end;

    if {strIP=''} True then
    begin
        redt_frame.Lines.Add(Format('[%.2d:%.2d:%.2d %.3d][%s %.4d][%s]', [
                  t.wHour, t.wMinute, t.wSecond, t.wMilliseconds,
                  strOper, len,
                  BufToHex(pBuf,len)
                  ]));
    end
    else
    begin
        redt_frame.Lines.Add(Format('[%.2d:%.2d:%.2d %.3d][%s %d][%s %.4d][%s]', [
                  t.wHour, t.wMinute, t.wSecond, t.wMilliseconds,
                  strIP, nPort,
                  strOper, len,
                  BufToHex(pBuf,len)
                  ]));
    end;


    GetScrollInfo(redt_frame.Handle,SB_VERT,tagS);
    aa := MakeLong(SB_ENDSCROLL, 0);
    SendMessage(redt_frame.Handle, WM_VSCROLL, aa, tagS.fMask);


  {
    GetLocalTime(t);
    strTime := Format('%.2d:%.2d:%.2d %.3d',[t.wHour,t.wMinute,t.wSecond,t.wMilliseconds]);

    pListItem := lv_frame.Items.Add;
    pListItem.Caption := strTime;

    if bSend then
        strOper := Format('发送[%d]',[len])
    else
        strOper := Format('    接收[%d]',[len]);

    if (strIP<>'') or (nPort<>0) then
        strOper := strOper + Format('[%s %d]',[strIP, nPort]);

    pListItem.SubItems.Add(strOper);

    if len<=4096 then
    begin
        pListItem.SubItems.Add(BufToHex(pBuf,len));
    end
    else
    begin
        pListItem.SubItems.Add(BufToHex(pBuf,4096));
    end;

    if N_scroll.Checked then
    begin
        //lv_frame.SetFocus;
        //lv_frame.ItemIndex := lv_frame.Items.Count-1;
        lv_frame.Perform(WM_VSCROLL,SB_BOTTOM,0)
        //strngrd_frame.Row := strngrd_frame.RowCount-1;
    end;
}


  {
    GetLocalTime(t);
    strTime := Format('%.2d:%.2d:%.2d %.3d',[t.wHour,t.wMinute,t.wSecond,t.wMilliseconds]);
    nRow := strngrd_frame.RowCount-1;
    if strngrd_frame.Cells[frame_col_time,nRow]<>'' then
    begin
        Inc(nRow);
        strngrd_frame.RowCount := nRow + 1;
    end;
    strngrd_frame.Cells[frame_col_time,nRow] := strTime;
    if bSend then
        strOper := Format('发送[%d]',[len])
    else
        strOper := Format('    接收[%d]',[len]);

    if (strIP<>'') or (nPort<>0) then
        strOper := strOper + Format('[%s %d]',[strIP, nPort]);

    strngrd_frame.Cells[frame_col_oper,nRow] := strOper;

    if len<=4096 then
    begin
        strngrd_frame.Cells[frame_col_frame,nRow] := BufToHex(pBuf,len);
    end
    else
    begin
        strngrd_frame.Cells[frame_col_frame,nRow] := BufToHex(pBuf,4096);
    end;

    if N_scroll.Checked then
    begin
        strngrd_frame.Row := strngrd_frame.RowCount-1;
    end;
    }
end;

function  TF_Frame.ClearFrame():Boolean;
begin
    lv_frame.Items.Clear;
    redt_frame.Clear;
  {
    strngrd_frame.RowCount := 2;
    strngrd_frame.Rows[1].Clear;
    }
end;

procedure TF_Frame.strngrd_frameDrawCell(Sender: TObject; ACol,
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

procedure TF_Frame.strngrd_frameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if ssCtrl in Shift then
        case Key of
            Ord('C'): StringGridCopyToClipboard(TStringGrid(Sender));
        end;
end;

procedure TF_Frame.N_clearClick(Sender: TObject);
begin
    ClearFrame();
end;

procedure TF_Frame.lv_frameCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var i:Integer;
    Rect: TRect;
begin
    //if (cdsSelected in State) then Exit;

    i := (Sender as TListView).Items.IndexOf(Item);

    if Odd(i) then
        Sender.Canvas.Brush.Color := clInfoBk
    else
        Sender.Canvas.Brush.Color := RGB(191, 255, 223);

    Rect := Item.DisplayRect(drIcon);
    Sender.Canvas.FillRect(Rect);
    Sender.Canvas.textrect(Rect, Rect.left+1, Rect.Top+1, 'aaaaa');
    //Sender.Canvas.TextRect();
        
    if (cdsSelected in State) then
    begin
        Sender.Canvas.Brush.Color := clRed;
        Sender.Canvas.FillRect(Item.DisplayRect(drIcon));
    end;

    //DefaultDraw := False;
end;

end.
