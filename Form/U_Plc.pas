unit U_Plc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Spin, Grids, ExtCtrls, Menus, U_MyFunction, U_Protocol, 
  U_Protocol_645, U_Multi, U_Disp, U_Main;

type
  TF_Plc = class(TForm)
    scrlbx1: TScrollBox;
    grp1: TGroupBox;
    pnl1: TPanel;
    btn_upload: TBitBtn;
    strngrd_file_manage: TStringGrid;
    btn_sync: TBitBtn;
    pm_file_manage: TPopupMenu;
    N_scroll: TMenuItem;
    N2: TMenuItem;
    N_clear: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure strngrd_file_manage_DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure strngrd_file_manage_KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N_clearClick(Sender: TObject);
    procedure btn_syncClick(Sender: TObject);
    procedure btn_uploadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function strngrd_file_manage_Display(strConten:string):Boolean;
    function strngrd_file_manage_Clear():Boolean;
  end;

var
  F_Plc: TF_Plc;
  DLT645:T_Protocol_645;
  P_DLT645_Frame:PByte;
  DLT645_Ctrl:Byte;
  DLT645_Len:Integer;
  DLT645_DI:LongWord;
  DLT645_Data:Array[0..255] of Byte;

implementation

{$R *.dfm}

const file_manage_null = 0;
      file_manage_name = 1;
      file_manage_size = 2;

procedure TF_Plc.FormCreate(Sender: TObject);
begin
    inherited;
    strngrd_file_manage.ColWidths[file_manage_null] := 0;
    strngrd_file_manage.ColWidths[file_manage_name] := 650;
    strngrd_file_manage.ColWidths[file_manage_size] := 650;
    strngrd_file_manage.Cells[file_manage_name, 0]  := '名称';
    strngrd_file_manage.Cells[file_manage_size, 0]  := '大小';

    DLT645 := T_Protocol_645.Create();
end;

function TF_Plc.strngrd_file_manage_Display(strConten:string):Boolean;
var 
	t:SYSTEMTIME;
    strTime:string;
    nRow:Integer;
begin
    GetLocalTime(t);
    strTime := Format('%.2d:%.2d:%.2d %.3d',[t.wHour,t.wMinute,t.wSecond,t.wMilliseconds]);
    nRow := strngrd_file_manage.RowCount - 1;
    
    if strngrd_file_manage.Cells[file_manage_name, nRow] <> '' then
    begin
        Inc(nRow);
        strngrd_file_manage.RowCount := nRow + 1;
    end;
    
    strngrd_file_manage.Cells[file_manage_size, nRow] := strTime;
    strngrd_file_manage.Cells[file_manage_name, nRow] := strConten;
    
    if N_scroll.Checked then
    begin
        strngrd_file_manage.Row := strngrd_file_manage.RowCount - 1;
    end;
end;

function TF_Plc.strngrd_file_manage_Clear():Boolean;
begin
    strngrd_file_manage.RowCount := 2;
    strngrd_file_manage.Rows[1].Clear;
end;
    
procedure TF_Plc.strngrd_file_manage_DrawCell(Sender: TObject; ACol,
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

procedure TF_Plc.strngrd_file_manage_KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if ssCtrl in Shift then
        case Key of
            Ord('C'): StringGridCopyToClipboard(TStringGrid(Sender));
        end;
end;

function AddTxtFile(fname:string; content:string):BOOLEAN;
var
	F:TextFile;
	tlist:TStringList;
begin
	if (fname = '') or (content = '') then
	begin
		g_disp.DispLog('文件名为空，或者内容为空');
		Result := False;
	end;

	AssignFile(F, fname); //将文件名与F关联
	
	if FileExists(fname) then
	begin
	    Append(F); //追加文件
	    Closefile(F); //关闭文件F	
	    g_disp.DispLog('追加文件: ' + ExtractFilePath(ParamStr(0)) + fname);
	end
	else
	begin
		ReWrite(F); //创建TXT文件，并命名为'fname'
		Closefile(F); //关闭文件F  
		g_disp.DispLog('创建文件: ' + ExtractFilePath(ParamStr(0)) + fname);
	end;

	tlist := TStringList.Create;
	tlist.LoadFromFile(fname);
	tlist.Add(content);
	tlist.SaveToFile(fname);
	tlist.Free;
	
	Result := True;	
end;

procedure TF_Plc.N_clearClick(Sender: TObject);
begin
    strngrd_file_manage_Clear();
end;

procedure TF_Plc.btn_syncClick(Sender: TObject);
var
	p, pdata:PByte;
	len, i:Integer;
	DI:LongWord;
	str:string;
begin
	TButton(Sender).Enabled := False;

	DLT645_Ctrl := $91;

	DLT645_DI := $F0000100;
	
	len := 4;

	P_DLT645_Frame := DLT645.MakeFrame_645(DLT645_Ctrl, DLT645_DI, nil, len);

	DLT645_Len := DLT645.GetFrameLen();

	CommMakeFrame2(P_DLT645_Frame, DLT645_Len);

	if F_Main.SendDataAuto()
		and CommWaitForResp()
	then
	begin	
		if CommRecved = True then
    	begin
    		CommRecved := False;
    		
       		p := GetCommRecvBufAddr();
      		len := GetCommRecvDataLen();   	
      		
      		if DLT645.CheckFrame(p, len) = True then
      		begin
      			DI := DLT645.GetDI();
      			pdata := DLT645.GetDataUnit();
      			len := DLT645.GetDataUnitLen(); 

      			inc(pdata);
      			inc(pdata);
      			inc(pdata);
      			inc(pdata);
      			len := len - 4;

				for i:=0 to (len - 1) do
				begin
					str := str + chr(pdata^);
					inc(pdata);
				end;
				
      			strngrd_file_manage_Display(str);
      			
      			g_disp.DispLog('同步成功');
      		end
      		else
      		begin
      			g_disp.DispLog('同步失败');
      		end;
	    end
	    else
	    begin
	      g_disp.DispLog('串口接收无数据');
	    end;      		
	end
	else
	begin	
	
	end;

	TButton(Sender).Enabled := True;
end;

procedure TF_Plc.btn_uploadClick(Sender: TObject);
var 
	fname:string;
	p, pdata:PByte;
	len, i:Integer;
	DI:LongWord;
	content:string;	
	ctrl:Byte;
begin
	//TButton(Sender).Enabled := False;

	fname := strngrd_file_manage.Cells[file_manage_name, strngrd_file_manage.selection.bottom];

	if fname = '' then
	begin
		g_disp.DispLog('请选择要读取的文件');
		Beep(); //调用系统声音
		Abort(); //中止程序的运行
	end;

	DLT645_Ctrl := $11;

	DLT645_DI := $F0010100;

	len := length(fname);

	if len <> 12 then
	begin
		g_disp.DispLog('文件名.扩展名，总长度为12个字节');
		Beep(); //调用系统声音
		Abort(); //中止程序的运行	
	end;

	for i:=0 to (len - 1) do
	begin
		DLT645_Data[i] := ord(fname[i + 1]);
	end;

	P_DLT645_Frame := DLT645.MakeFrame_645(DLT645_Ctrl, DLT645_DI, @DLT645_Data[0], len);

	DLT645_Len := DLT645.GetFrameLen();

	CommMakeFrame2(P_DLT645_Frame, DLT645_Len);	

	if F_Main.SendDataAuto()
		and CommWaitForResp()
	then
	begin	
		if CommRecved = True then
    	begin
    		CommRecved := False;
    		
       		p := GetCommRecvBufAddr();
      		len := GetCommRecvDataLen();   	
      		
      		if DLT645.CheckFrame(p, len) = True then
      		begin
      			DI := DLT645.GetDI();
      			pdata := DLT645.GetDataUnit();
      			len := DLT645.GetDataUnitLen(); 
      			ctrl := DLT645.GetCtrl();

      			case ctrl of
      				$91:
      				begin
						for i:=0 to (12 - 1) do
						begin
							inc(pdata);
						end;

						len := len - 12;
						
						for i:=0 to (len - 1) do
						begin
							content := content + chr(pdata^);
							inc(pdata);
						end;
						
		      			AddTxtFile(fname, content);      				
      				end;

      				$B1:
      				begin
						for i:=0 to (12 - 1) do
						begin
							inc(pdata);
						end;

						len := len - 12;
						
						for i:=0 to (len - 1) do
						begin
							content := content + chr(pdata^);
							inc(pdata);
						end;
						
		      			AddTxtFile(fname, content);

		      			while ctrl <> $92 do
		      			begin
		      				DLT645_Ctrl := $12;

		      				len := length(fname);

							P_DLT645_Frame := DLT645.MakeFrame_645(DLT645_Ctrl, DLT645_DI, @DLT645_Data[0], len);

							DLT645_Len := DLT645.GetFrameLen();

							CommMakeFrame2(P_DLT645_Frame, DLT645_Len);	

							if F_Main.SendDataAuto()
								and CommWaitForResp()
							then
							begin	
								if CommRecved = True then
						    	begin
						    		CommRecved := False;

									p := GetCommRecvBufAddr();
									len := GetCommRecvDataLen();   	

									if DLT645.CheckFrame(p, len) = True then
									begin
										DI := DLT645.GetDI();
										pdata := DLT645.GetDataUnit();
										len := DLT645.GetDataUnitLen(); 
										ctrl := DLT645.GetCtrl();

										for i:=0 to (12 - 1) do
										begin
											inc(pdata);
										end;

										len := len - 12;

										for i:=0 to (len - 2) do
										begin
											content := content + chr(pdata^);
											inc(pdata);
										end;

										AddTxtFile(fname, content);   
									end
									else
									begin
										Abort(); //中止程序的运行
									end;
						    	end
						    	else
						    	begin
						    		Abort(); //中止程序的运行
						    	end;
						    end
						    else
						    begin
						    	Abort(); //中止程序的运行
						    end;		      				
		      			end;
      				end;
      				else
      				begin
      				end;
      			end;	
      			
      			g_disp.DispLog('读取文件成功');
      		end
      		else
      		begin
      			g_disp.DispLog('读取文件失败');
      		end;
	    end
	    else
	    begin
	      g_disp.DispLog('串口接收无数据');
	    end;      		
	end
	else
	begin	
	
	end;
	TButton(Sender).Enabled := True;
end;

end.
