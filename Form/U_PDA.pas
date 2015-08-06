unit U_PDA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Spin, Grids, ExtCtrls, Menus, U_MyFunction, U_Protocol, 
  U_Protocol_645, U_Multi, U_Disp, U_Main, ComCtrls, DateUtils;

type
  TF_PDA = class(TForm)
    pm_file_manage: TPopupMenu;
    N_scroll: TMenuItem;
    N2: TMenuItem;
    N_clear: TMenuItem;
    CheckBox1: TCheckBox;
    scrlbx1: TScrollBox;
    grp1: TGroupBox;
    pnl1: TPanel;
    btn_upload: TBitBtn;
    btn_sync: TBitBtn;
    btn_shake_hands: TBitBtn;
    strngrd_file_manage: TStringGrid;
    scrlbx3: TGroupBox;
    btn_restore_defaults: TBitBtn;
    btn_read_para: TBitBtn;
    edt_sys_time: TEdit;
    btn_write_para: TButton;
    chk_sys_time: TCheckBox;
    chk_version: TCheckBox;
    edt_hardware_version: TEdit;
    lbl1: TLabel;
    edt_software_version: TEdit;
    edt_version_date: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    chk_all: TCheckBox;
    procedure chk_allClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure strngrd_file_manage_DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure strngrd_file_manage_KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N_clearClick(Sender: TObject);
    procedure btn_syncClick(Sender: TObject);
    procedure btn_uploadClick(Sender: TObject);
    procedure btn_shake_handsClick(Sender: TObject);
    procedure btn_read_paraClick(Sender: TObject);
    procedure btn_write_paraClick(Sender: TObject);
    procedure btn_restore_defaultsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function strngrd_file_manage_Display(fname:string; fsize:string):Boolean;
    function strngrd_file_manage_Clear():Boolean;
  end;

var
  F_PDA: TF_PDA;
  DL645:T_Protocol_645;
  P_DL645_Frame:PByte;
  DL645_Ctrl:Byte;
  DL645_Len:Integer;
  DL645_DI:LongWord;
  DL645_Data:Array[0..255] of Byte;

implementation

{$R *.dfm}

const file_manage_null = 0;
      file_manage_name = 1;
      file_manage_size = 2;

procedure TF_PDA.FormCreate(Sender: TObject);
begin
    inherited;
    strngrd_file_manage.ColWidths[file_manage_null] := 0;
    strngrd_file_manage.ColWidths[file_manage_name] := 402;
    strngrd_file_manage.ColWidths[file_manage_size] := 391;
    strngrd_file_manage.Cells[file_manage_name, 0]  := '名称';
    strngrd_file_manage.Cells[file_manage_size, 0]  := '大小';

    DL645 := T_Protocol_645.Create();
end;

function TF_PDA.strngrd_file_manage_Display(fname:string; fsize:string):Boolean;
var 
    nRow:Integer;
begin
    nRow := strngrd_file_manage.RowCount - 1;
    
    if strngrd_file_manage.Cells[file_manage_name, nRow] <> '' then
    begin
        Inc(nRow);
        strngrd_file_manage.RowCount := nRow + 1;
    end;

    strngrd_file_manage.Cells[file_manage_name, nRow] := fname;
    strngrd_file_manage.Cells[file_manage_size, nRow] := fsize;
    
    if N_scroll.Checked then
    begin
        strngrd_file_manage.Row := strngrd_file_manage.RowCount - 1;
    end;
end;

function TF_PDA.strngrd_file_manage_Clear():Boolean;
begin
    strngrd_file_manage.RowCount := 2;
    strngrd_file_manage.Rows[1].Clear;
end;
    
procedure TF_PDA.strngrd_file_manage_DrawCell(Sender: TObject; ACol,
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

procedure TF_PDA.strngrd_file_manage_KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if ssCtrl in Shift then
        case Key of
            Ord('C'): StringGridCopyToClipboard(TStringGrid(Sender));
        end;
end;

function FileCreate(fname:string; content:string):BOOLEAN;
var
	F:TextFile;
	i, len:Integer;
begin
	if (fname = '') or (content = '') then
	begin
		g_disp.DispLog('文件名为空，或者内容为空');
		Beep(); //调用系统声音
		Result := False;
	end;

	AssignFile(F, fname); //将文件名与F关联
	len := Length(content); 

	ReWrite(F); //创建文件，并命名为'fname'
	g_disp.DispLog('创建文件: ' + ExtractFilePath(ParamStr(0)) + fname);
	
	for i := 0 to (len - 1) do
	begin
		Write(F, content[i + 1]);
	end;

    Closefile(F); //关闭文件F	
	
	Result := True;	
end;

function FileAppend(fname:string; content:string):BOOLEAN;
var
	F:TextFile;
	i, len:Integer;
	tlist:TStringList;
begin
	if (fname = '') or (content = '') then
	begin
		g_disp.DispLog('文件名为空，或者内容为空');
		Beep(); //调用系统声音
		Result := False;
	end;

	AssignFile(F, fname); //将文件名与F关联
	len := Length(content);
	
	if FileExists(fname) then
	begin
	    Append(F); //追加文件
	    g_disp.DispLog('追加文件: ' + ExtractFilePath(ParamStr(0)) + fname);
	end
	else
	begin
		Closefile(F); //关闭文件F
		g_disp.DispLog('文件不存在');
		Result := False;
	end; 

	for i := 0 to (len - 1) do
	begin
		Write(F, content[i + 1]);
	end;

    Closefile(F); //关闭文件F	
    
{
	tlist := TStringList.Create;
	tlist.LoadFromFile(fname);
	tlist.Add(content);
	tlist.SaveToFile(fname);
	tlist.Free;
}
	
	Result := True;	
end;

procedure TF_PDA.N_clearClick(Sender: TObject);
begin
    strngrd_file_manage_Clear();
end;

procedure TF_PDA.chk_allClick(Sender: TObject);
begin
    MakeCheck(TCheckBox(Sender).Parent, TCheckBox(Sender).Checked);
end;

procedure TF_PDA.btn_syncClick(Sender: TObject);
var
	fname, fsize:string;
	p, pdata:PByte;
	len, i, size:Integer;
	DI:LongWord;
begin
	TButton(Sender).Enabled := False;

	strngrd_file_manage_Clear();

	DL645_Ctrl := $11;

	DL645_DI := $F0000100;
	
	len := 0;

	P_DL645_Frame := DL645.MakeFrame_645(DL645_Ctrl, DL645_DI, nil, len);

	DL645_Len := DL645.GetFrameLen();

	CommMakeFrame2(P_DL645_Frame, DL645_Len);

	if F_Main.SendDataAuto()
		and CommWaitForResp()
	then
	begin	
		if CommRecved = True then
    	begin
    		CommRecved := False;
    		
       		p := GetCommRecvBufAddr();
      		len := GetCommRecvDataLen();   	
      		
      		if DL645.CheckFrame(p, len) = True then
      		begin
      			DI := DL645.GetDI();
      			pdata := DL645.GetDataUnit();
      			len := DL645.GetDataUnitLen(); 

      			inc(pdata);
      			inc(pdata);
      			inc(pdata);
      			inc(pdata);
      			len := len - 4;

				while len > 0 do
				begin
					fname := '';
					for i:=0 to 11 do
					begin
						fname := fname + chr(pdata^);
						inc(pdata);
					end;

					size := 0;
					fsize := '';
					for i:=0 to 3 do
					begin
						size := size + (pdata^ shl (i * 8));
						inc(pdata);
					end;
					fsize := IntToStr(size) + '  Bytes';

					len := len - 16;
					
	      			strngrd_file_manage_Display(fname, fsize);
				end;
      			
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

procedure TF_PDA.btn_uploadClick(Sender: TObject);
var 
	fname, content:string;
	p, pdata:PByte;
	ctrl:Byte;
	len, i:Integer;
	DI:LongWord;
begin
	TButton(Sender).Enabled := False;

	fname := strngrd_file_manage.Cells[file_manage_name, strngrd_file_manage.selection.bottom];

	if fname = '' then
	begin
		g_disp.DispLog('请选择要读取的文件');
		Beep(); //调用系统声音
		TButton(Sender).Enabled := True;
		Abort(); //中止程序的运行
	end;

	DL645_Ctrl := $11;

	DL645_DI := $F0010100;

	len := length(fname);

	if len <> 12 then
	begin
		g_disp.DispLog('文件名.扩展名，总长度为12个字节');
		Beep(); //调用系统声音
		TButton(Sender).Enabled := True;
		Abort(); //中止程序的运行	
	end;

	for i:=0 to (len - 1) do
	begin
		DL645_Data[i] := ord(fname[i + 1]);
	end;

	P_DL645_Frame := DL645.MakeFrame_645(DL645_Ctrl, DL645_DI, @DL645_Data[0], len);

	DL645_Len := DL645.GetFrameLen();

	CommMakeFrame2(P_DL645_Frame, DL645_Len);	

	if F_Main.SendDataAuto()
		and CommWaitForResp()
	then
	begin	
		if CommRecved = True then
    	begin
    		CommRecved := False;
    		
       		p := GetCommRecvBufAddr();
      		len := GetCommRecvDataLen();   	
      		
      		if DL645.CheckFrame(p, len) = True then
      		begin
				ctrl := DL645.GetCtrl();
				DI := DL645.GetDI();
				pdata := DL645.GetDataUnit();
				len := DL645.GetDataUnitLen();

      			case ctrl of
      				$91:
      				begin
						for i:=0 to (12 - 1) do
						begin
							inc(pdata);
						end;

						len := len - 12;

						content := '';
						for i:=0 to (len - 1) do
						begin
							content := content + chr(pdata^);
							inc(pdata);
						end;
						
		      			FileCreate(fname, content);      				
      				end;

      				$B1:
      				begin
						for i:=0 to (12 - 1) do
						begin
							inc(pdata);
						end;

						len := len - 12;

						content := '';
						for i:=0 to (len - 1) do
						begin
							content := content + chr(pdata^);
							inc(pdata);
						end;
						
		      			FileCreate(fname, content);

		      			while ctrl <> $92 do
		      			begin
		      				DL645_Ctrl := $12;

		      				len := length(fname);

							P_DL645_Frame := DL645.MakeFrame_645(DL645_Ctrl, DL645_DI, @DL645_Data[0], len);

							DL645_Len := DL645.GetFrameLen();

							CommMakeFrame2(P_DL645_Frame, DL645_Len);	

							if F_Main.SendDataAuto()
								and CommWaitForResp()
							then
							begin	
								if CommRecved = True then
						    	begin
						    		CommRecved := False;

									p := GetCommRecvBufAddr();
									len := GetCommRecvDataLen();  	

									if DL645.CheckFrame(p, len) = True then
									begin 
										ctrl := DL645.GetCtrl();
										DI := DL645.GetDI();
										pdata := DL645.GetDataUnit();
										len := DL645.GetDataUnitLen();

										for i:=0 to (12 - 1) do
										begin
											inc(pdata);
										end;

										len := len - 12;

										content := '';
										for i:=0 to (len - 2) do
										begin
											content := content + chr(pdata^);
											inc(pdata);
										end;

										FileAppend(fname, content);   
									end
									else
									begin
										g_disp.DispLog('读取文件失败');
										TButton(Sender).Enabled := True;
										Abort(); //中止程序的运行
									end;
						    	end
						    	else
						    	begin
						    		g_disp.DispLog('读取文件失败');
						    		TButton(Sender).Enabled := True;
						    		Abort(); //中止程序的运行
						    	end;
						    end
						    else
						    begin
						    	g_disp.DispLog('读取文件失败');
						    	TButton(Sender).Enabled := True;
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

procedure TF_PDA.btn_shake_handsClick(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len:Integer;
	DI:LongWord;
begin
	TButton(Sender).Enabled := False;

	DL645_Ctrl := $11;

	DL645_DI := $F0000000;
	
	len := 0;

	P_DL645_Frame := DL645.MakeFrame_645(DL645_Ctrl, DL645_DI, nil, len);

	DL645_Len := DL645.GetFrameLen();

	CommMakeFrame2(P_DL645_Frame, DL645_Len);

	if F_Main.SendDataAuto()
		and CommWaitForResp()
	then
	begin	
		if CommRecved = True then
	    begin
	    	CommRecved := False;
	    	
       		p := GetCommRecvBufAddr();
      		len := GetCommRecvDataLen();   	
      		
      		if DL645.CheckFrame(p, len) = True then
      		begin
      			ctrl := DL645.GetCtrl();
      			DI := DL645.GetDI();

      			if (ctrl = $91) and (DI = $F0000000) then
      			begin
      				g_disp.DispLog('握手成功');
      			end
      			else
      			begin
      				g_disp.DispLog('握手失败');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('握手失败');
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

procedure TF_PDA.btn_read_paraClick(Sender: TObject);
var
  	chk:TCheckBox;
	p, pdata:PByte;
	ctrl:Byte;
	len:Integer;
	DI:LongWord;  
	const weekCaption:array[0..6] of string = ('星期天', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六');
begin
	TButton(Sender).Enabled := FALSE;
	
	//系统时间
	chk := chk_sys_time;
    if chk.Checked then
    begin
    	edt_sys_time.Text := '';
    	
		DL645_Ctrl := $11;

		DL645_DI := $F0100000;
		
		len := 0;

		P_DL645_Frame := DL645.MakeFrame_645(DL645_Ctrl, DL645_DI, nil, len);

		DL645_Len := DL645.GetFrameLen();

		CommMakeFrame2(P_DL645_Frame, DL645_Len);

		if F_Main.SendDataAuto()
			and CommWaitForResp()
		then
		begin	
			if CommRecved = True then
		    begin
		    	CommRecved := False;
		    	
	       		p := GetCommRecvBufAddr();
	      		len := GetCommRecvDataLen();   	
	      		
	      		if DL645.CheckFrame(p, len) = True then
	      		begin
	      			ctrl := DL645.GetCtrl();
	      			DI := DL645.GetDI();
					pdata := DL645.GetDataUnit();
					len := DL645.GetDataUnitLen();
					
	      			if (ctrl = $91) and (DI = $F0100000) then
	      			begin
						edt_sys_time.Text := Format('20%.2x-%.2x-%.2x  %.2x:%.2x:%.2x  %s', [
											   		PByte(Integer(pdata) + 6)^,
											   		PByte(Integer(pdata) + 5)^,
											   		PByte(Integer(pdata) + 4)^,
											   		PByte(Integer(pdata) + 2)^,
											   		PByte(Integer(pdata) + 1)^,
											   		PByte(Integer(pdata) + 0)^,
											   		weekCaption[PByte(Integer(pdata) + 3)^ mod 7]
											   		]);
	      			
	      				g_disp.DispLog('读系统时间成功');
	      			end
	      			else
	      			begin
	      				g_disp.DispLog('读系统时间失败');
	      			end;
	      		end	
		    	else
		    	begin
		    		g_disp.DispLog('读系统时间失败');
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
    end;

	//版本号
	chk := chk_version;
    if chk.Checked then
    begin
    	edt_hardware_version.Text := '';
    	edt_software_version.Text := '';
    	edt_version_date.Text := '';

		DL645_Ctrl := $11;

		DL645_DI := $F0100001;
		
		len := 0;

		P_DL645_Frame := DL645.MakeFrame_645(DL645_Ctrl, DL645_DI, nil, len);

		DL645_Len := DL645.GetFrameLen();

		CommMakeFrame2(P_DL645_Frame, DL645_Len);

		if F_Main.SendDataAuto()
			and CommWaitForResp()
		then
		begin	
			if CommRecved = True then
		    begin
		    	CommRecved := False;
		    	
	       		p := GetCommRecvBufAddr();
	      		len := GetCommRecvDataLen();   	
	      		
	      		if DL645.CheckFrame(p, len) = True then
	      		begin
	      			ctrl := DL645.GetCtrl();
	      			DI := DL645.GetDI();
					pdata := DL645.GetDataUnit();
					len := DL645.GetDataUnitLen();
					
	      			if (ctrl = $91) and (DI = $F0100001) then
	      			begin
						edt_hardware_version.Text := Format('v%.d.%.d', [
															PByte(Integer(pdata) + 0)^ div 10,
															PByte(Integer(pdata) + 0)^ mod 10
															]);

						edt_software_version.Text := Format('v%.d.%.d', [
															PByte(Integer(pdata) + 1)^ div 10,
															PByte(Integer(pdata) + 1)^ mod 10
															]);

						edt_version_date.Text := Format('%.4x', [
														PInteger(Integer(pdata) + 2)^
														]);
	      			
	      				g_disp.DispLog('读版本号成功');
	      			end
	      			else
	      			begin
	      				g_disp.DispLog('读版本号失败');
	      			end;
	      		end	
		    	else
		    	begin
		    		g_disp.DispLog('读版本号失败');
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
    end;

	TButton(Sender).Enabled := TRUE;
end;

procedure TF_PDA.btn_write_paraClick(Sender: TObject);
var
	chk:TCheckBox;
	p:PByte;
	ctrl:Byte;
	len, index:Integer;
	DateTime:TDateTime;
	buf:array[0..63] of Byte;
begin
	TButton(Sender).Enabled := FALSE;
	
	//系统时间
	chk := chk_sys_time;
    if chk.Checked then
    begin
    	DateTime := Now;
    	
    	index := 0;

    	buf[index] := SecondOf(DateTime); Inc(index);
    	buf[index] := MinuteOf(DateTime); Inc(index);
    	buf[index] := HourOf(DateTime); Inc(index);
    	buf[index] := DayOfTheWeek(DateTime) mod 7; Inc(index);
    	buf[index] := DayOf(DateTime); Inc(index);
    	buf[index] := MonthOf(DateTime); Inc(index);
    	buf[index] := YearOf(DateTime) - 2000; Inc(index);
    	
		DL645_Ctrl := $14;

		DL645_DI := $F0110000;
		
		len := index;

		P_DL645_Frame := DL645.MakeFrame_645(DL645_Ctrl, DL645_DI, @buf[0], len);

		DL645_Len := DL645.GetFrameLen();

		CommMakeFrame2(P_DL645_Frame, DL645_Len);

		if F_Main.SendDataAuto()
			and CommWaitForResp()
		then
		begin	
			if CommRecved = True then
		    begin
		    	CommRecved := False;
		    	
	       		p := GetCommRecvBufAddr();
	      		len := GetCommRecvDataLen();   	
	      		
	      		if DL645.CheckFrame(p, len) = True then
	      		begin
	      			ctrl := DL645.GetCtrl();
					
	      			if ctrl = $94 then
	      			begin
	      				g_disp.DispLog('写系统时间成功');
	      			end
	      			else
	      			begin
	      				g_disp.DispLog('写系统时间失败');
	      			end;
	      		end	
		    	else
		    	begin
		    		g_disp.DispLog('写系统时间失败');
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
    end;

    TButton(Sender).Enabled := TRUE;
end;

procedure TF_PDA.btn_restore_defaultsClick(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len:Integer;
	DI:LongWord;
begin
	TButton(Sender).Enabled := False;

	DL645_Ctrl := $14;

	DL645_DI := $F0100100;
	
	len := 0;

	P_DL645_Frame := DL645.MakeFrame_645(DL645_Ctrl, DL645_DI, nil, len);

	DL645_Len := DL645.GetFrameLen();

	CommMakeFrame2(P_DL645_Frame, DL645_Len);

	if F_Main.SendDataAuto()
		and CommWaitForResp()
	then
	begin	
		if CommRecved = True then
	    begin
	    	CommRecved := False;
	    	
       		p := GetCommRecvBufAddr();
      		len := GetCommRecvDataLen();   	
      		
      		if DL645.CheckFrame(p, len) = True then
      		begin
      			ctrl := DL645.GetCtrl();
      			DI := DL645.GetDI();

      			if  ctrl = $94 then
      			begin
      				g_disp.DispLog('恢复出厂成功');
      			end
      			else
      			begin
      				g_disp.DispLog('恢复出厂失败');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('恢复出厂失败');
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
