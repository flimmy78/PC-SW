unit U_MEMS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Spin, Grids, ExtCtrls, Menus, U_MyFunction, U_Protocol, 
  U_Protocol_645, U_Multi, U_Disp, U_Main, ComCtrls, DateUtils;

type
  TF_MEMS = class(TForm)
    scrlbx1: TScrollBox;
    scrlbx3: TGroupBox;
    lbl_hard: TLabel;
    lbl_soft: TLabel;
    btn_restore_defaults: TBitBtn;
    edt_sys_time: TEdit;
    btn_sysinfo_write_para: TButton;
    chk_sys_time: TCheckBox;
    chk_version: TCheckBox;
    edt_hardware_version: TEdit;
    edt_software_version: TEdit;
    chk_all: TCheckBox;
    scrlbx2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edt_cal_read_grp2: TEdit;
    edt_cal_write_grp1: TEdit;
    edt_cal_read_grp4: TEdit;
    edt_cal_read_grp3: TEdit;
    edt_cal_read_grp1: TEdit;
    edt_cal_write_grp2: TEdit;
    edt_cal_write_grp3: TEdit;
    edt_cal_write_grp4: TEdit;
    btn_cal_save_grp1: TButton;
    btn_cal_save_grp2: TButton;
    btn_cal_save_grp3: TButton;
    btn_cal_save_grp4: TButton;
    Label5: TLabel;
    edt_cal_read_grp5: TEdit;
    edt_cal_write_grp5: TEdit;
    btn_cal_save_grp5: TButton;
    btn_cal_read_para: TBitBtn;
    btn_sysinfo_read_para: TBitBtn;
    GroupBox1: TGroupBox;
    btn_debounce_read_para: TButton;
    btn_cal_confirm: TButton;
    Label6: TLabel;
    edt_debounce_threshold_read: TEdit;
    edt_debounce_threshold_write: TEdit;
    btn_debounce_save_threshold: TButton;
    procedure FormCreate(Sender: TObject);
    procedure chk_allClick(Sender: TObject);
    procedure edt_memsInput(Sender: TObject; var Key: Char);
    procedure btn_sysinfo_read_paraClick(Sender: TObject);
    procedure btn_sysinfo_write_paraClick(Sender: TObject);
    procedure btn_restore_defaultsClick(Sender: TObject);
    procedure btn_cal_read_paraClick(Sender: TObject);
    procedure btn_cal_save_grp1Click(Sender: TObject);
    procedure btn_cal_save_grp2Click(Sender: TObject);
    procedure btn_cal_save_grp3Click(Sender: TObject);
    procedure btn_cal_save_grp4Click(Sender: TObject);
    procedure btn_cal_save_grp5Click(Sender: TObject);
    procedure btn_cal_confirmClick(Sender: TObject);
    procedure btn_debounce_read_paraClick(Sender: TObject);
    procedure btn_debounce_save_thresholdClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_MEMS: TF_MEMS;

implementation

{$R *.dfm}

const
	SHAKE_HANDS_CMD = $FF000001;
	READ_TIME_CMD = $FF000002;
	WRITE_TIME_CMD = $FF000003;
	READ_VERSION_CMD = $FF000004;
	RESTORE_CMD = $FF000005;
	READ_CAL_CMD = $FF000006;
	WRITE_CAL_GRP1_CMD = $FF000007;
	WRITE_CAL_GRP2_CMD = $FF000008;
	WRITE_CAL_GRP3_CMD = $FF000009;
	WRITE_CAL_GRP4_CMD = $FF00000A;
	WRITE_CAL_GRP5_CMD = $FF00000B;
	CAL_CONFIRM_CMD = $FF00000C;
	READ_DEBOUNCE_CMD = $FF00000D;
	WRITE_DEBOUNCE_THRESHOLD_CMD = $FF00000E;

var
	DL645: T_Protocol_645;
	P_DL645_Frame: PByte;
	DL645_Len: Integer;
	DL645_Ctrl: Byte;
	DL645_DI: LongWord;
	DL645_Data: Array[0..255] of Byte;

procedure TF_MEMS.FormCreate(Sender: TObject);
begin
    DL645 := T_Protocol_645.Create();
end;

procedure TF_MEMS.chk_allClick(Sender: TObject);
begin
    MakeCheck(TCheckBox(Sender).Parent, TCheckBox(Sender).Checked);
end;

procedure TF_MEMS.edt_memsInput(Sender: TObject; var Key: Char);
begin
	if not (key in ['0'..'9', #8]) then //0 - 9, BackSpace
	begin
		key := #0; //输入置空
		Beep(); //调用系统声音
	end;
end;

procedure TF_MEMS.btn_sysinfo_read_paraClick(Sender: TObject);
var
  	chk:TCheckBox;
	p, pdata:PByte;
	ctrl:Byte;
	len:Integer;
	DI:LongWord;  
	const weekCaption:array[0..6] of string = ('星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六');
begin
	TButton(Sender).Enabled := FALSE;
	
	//系统时间
	chk := chk_sys_time;
    if chk.Checked then
    begin
    	edt_sys_time.Text := '';
    	
		DL645_Ctrl := $11;

		DL645_DI := READ_TIME_CMD;
		
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
					
	      			if (ctrl = $91) and (DI = READ_TIME_CMD) then
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

		DL645_Ctrl := $11;

		DL645_DI := READ_VERSION_CMD;
		
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
					
	      			if (ctrl = $91) and (DI = READ_VERSION_CMD) then
	      			begin
						edt_hardware_version.Text := Format('%.2x%.2x%.2x%.2x-%.2x', [
															PByte(Integer(pdata) + 0)^,
															PByte(Integer(pdata) + 1)^,
															PByte(Integer(pdata) + 2)^,
															PByte(Integer(pdata) + 3)^,
															PByte(Integer(pdata) + 4)^
															]);

						edt_software_version.Text := Format('%.2x%.2x%.2x%.2x-%.2x', [
															PByte(Integer(pdata) + 5)^,
															PByte(Integer(pdata) + 6)^,
															PByte(Integer(pdata) + 7)^,
															PByte(Integer(pdata) + 8)^,
															PByte(Integer(pdata) + 9)^
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

procedure TF_MEMS.btn_sysinfo_write_paraClick(Sender: TObject);
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

		DL645_DI := WRITE_TIME_CMD;
		
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

procedure TF_MEMS.btn_restore_defaultsClick(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len:Integer;
begin
	TButton(Sender).Enabled := False;

	DL645_Ctrl := $14;

	DL645_DI := RESTORE_CMD;
	
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

      			if ctrl = $94 then
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

procedure TF_MEMS.btn_cal_read_paraClick(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len, cal_complete:Integer;
	DI:LongWord;  
	pdata:PInteger;
begin
	TButton(Sender).Enabled := FALSE;
	
	edt_cal_read_grp1.Text := '';
	edt_cal_read_grp2.Text := '';
	edt_cal_read_grp3.Text := '';
	edt_cal_read_grp4.Text := '';
	edt_cal_read_grp5.Text := '';
	
	DL645_Ctrl := $11;

	DL645_DI := READ_CAL_CMD;
	
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
				p := DL645.GetDataUnit();
				len := DL645.GetDataUnitLen();
				
      			if (ctrl = $91) and (DI = READ_CAL_CMD) then
      			begin
					pdata := PInteger(p);
      			
					cal_complete := PInteger(Integer(pdata) + 0 * 4)^;

					edt_cal_read_grp1.Text := Format('(%.d, %.d)', [
										   		     PInteger(Integer(pdata) + 1 * 4)^,
										   			 PInteger(Integer(pdata) + 2 * 4)^
										   			 ]);

					edt_cal_read_grp2.Text := Format('(%.d, %.d)', [
										   			 PInteger(Integer(pdata) + 3 * 4)^,
										   			 PInteger(Integer(pdata) + 4 * 4)^
										   			 ]);

					edt_cal_read_grp3.Text := Format('(%.d, %.d)', [
										   			 PInteger(Integer(pdata) + 5 * 4)^,
										   			 PInteger(Integer(pdata) + 6 * 4)^
										   			 ]);
										   		
					edt_cal_read_grp4.Text := Format('(%.d, %.d)', [
										   			 PInteger(Integer(pdata) + 7 * 4)^,
										   			 PInteger(Integer(pdata) + 8 * 4)^
										   			 ]);
										   		
					edt_cal_read_grp5.Text := Format('(%.d, %.d)', [
										   			 PInteger(Integer(pdata) + 9 * 4)^,
										   			 PInteger(Integer(pdata) + 10 * 4)^
										   		 	 ]);

					if cal_complete <> 0 then
					begin
      					g_disp.DispLog('读流量校准成功，校准已完成');
      				end
      				else
      				begin
      					g_disp.DispLog('读流量校准成功，校准未完成');
      				end;
      			end
      			else
      			begin
      				g_disp.DispLog('读流量校准失败');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('读流量校准失败');
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

	TButton(Sender).Enabled := TRUE;
end;

procedure TF_MEMS.btn_cal_save_grp1Click(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len, data:Integer;
	buf:array[0..63] of Byte;
begin
	TButton(Sender).Enabled := FALSE;

	data := StrToInt(edt_cal_write_grp1.text);

	CopyMemory(@buf[0], @data, 4);
	
	DL645_Ctrl := $14;

	DL645_DI := WRITE_CAL_GRP1_CMD;
	
	len := 4;

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
      				g_disp.DispLog('第一组流量校准成功');
      			end
      			else
      			begin
      				g_disp.DispLog('第一组流量校准失败');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('第一组流量校准失败');
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

    TButton(Sender).Enabled := TRUE;
end;

procedure TF_MEMS.btn_cal_save_grp2Click(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len, data:Integer;
	buf:array[0..63] of Byte;
begin
	TButton(Sender).Enabled := FALSE;

	data := StrToInt(edt_cal_write_grp2.text);

	CopyMemory(@buf[0], @data, 4);
	
	DL645_Ctrl := $14;

	DL645_DI := WRITE_CAL_GRP2_CMD;
	
	len := 4;

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
      				g_disp.DispLog('第二组流量校准成功');
      			end
      			else
      			begin
      				g_disp.DispLog('第二组流量校准失败');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('第二组流量校准失败');
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

    TButton(Sender).Enabled := TRUE;
end;

procedure TF_MEMS.btn_cal_save_grp3Click(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len, data:Integer;
	buf:array[0..63] of Byte;
begin
	TButton(Sender).Enabled := FALSE;

	data := StrToInt(edt_cal_write_grp3.text);

	CopyMemory(@buf[0], @data, 4);
	
	DL645_Ctrl := $14;

	DL645_DI := WRITE_CAL_GRP3_CMD;
	
	len := 4;

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
      				g_disp.DispLog('第三组流量校准成功');
      			end
      			else
      			begin
      				g_disp.DispLog('第三组流量校准失败');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('第三组流量校准失败');
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

    TButton(Sender).Enabled := TRUE;
end;

procedure TF_MEMS.btn_cal_save_grp4Click(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len, data:Integer;
	buf:array[0..63] of Byte;
begin
	TButton(Sender).Enabled := FALSE;

	data := StrToInt(edt_cal_write_grp4.text);

	CopyMemory(@buf[0], @data, 4);
	
	DL645_Ctrl := $14;

	DL645_DI := WRITE_CAL_GRP4_CMD;
	
	len := 4;

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
      				g_disp.DispLog('第四组流量校准成功');
      			end
      			else
      			begin
      				g_disp.DispLog('第四组流量校准失败');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('第四组流量校准失败');
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

    TButton(Sender).Enabled := TRUE;
end;

procedure TF_MEMS.btn_cal_save_grp5Click(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len, data:Integer;
	buf:array[0..63] of Byte;
begin
	TButton(Sender).Enabled := FALSE;

	data := StrToInt(edt_cal_write_grp5.text);

	CopyMemory(@buf[0], @data, 4);
	
	DL645_Ctrl := $14;

	DL645_DI := WRITE_CAL_GRP5_CMD;
	
	len := 4;

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
      				g_disp.DispLog('第五组流量校准成功');
      			end
      			else
      			begin
      				g_disp.DispLog('第五组流量校准失败');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('第五组流量校准失败');
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

    TButton(Sender).Enabled := TRUE;
end;

procedure TF_MEMS.btn_cal_confirmClick(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len:Integer;
	DI:LongWord;
begin
	TButton(Sender).Enabled := False;

	DL645_Ctrl := $11;

	DL645_DI := CAL_CONFIRM_CMD;
	
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
      			
      			if (ctrl = $91) and (DI = CAL_CONFIRM_CMD) then
      			begin      			
      				g_disp.DispLog('流量校准完成');
      			end
      			else
      			begin
      				g_disp.DispLog('流量校准未完成');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('流量校准未完成');
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

procedure TF_MEMS.btn_debounce_read_paraClick(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len, debounce_threshold:Integer;
	DI:LongWord;
	pdata:PInteger;
begin
	TButton(Sender).Enabled := False;

	edt_debounce_threshold_read.text := '';

	DL645_Ctrl := $11;

	DL645_DI := READ_DEBOUNCE_CMD;
	
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
				p := DL645.GetDataUnit();
				len := DL645.GetDataUnitLen();
					
      			if (ctrl = $91) and (DI = READ_DEBOUNCE_CMD) then
      			begin
					pdata := PInteger(p);
      			
					debounce_threshold := PInteger(Integer(pdata) + 0 * 4)^;

					edt_debounce_threshold_read.text := IntToStr(debounce_threshold);
      			
      				g_disp.DispLog('读流量消抖成功');
      			end
      			else
      			begin
      				g_disp.DispLog('读流量消抖失败');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('读流量消抖失败');
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

procedure TF_MEMS.btn_debounce_save_thresholdClick(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len, data:Integer;
	buf:array[0..63] of Byte;
begin
	TButton(Sender).Enabled := FALSE;

	data := StrToInt(edt_debounce_threshold_write.text);

	CopyMemory(@buf[0], @data, 4);
	
	DL645_Ctrl := $14;

	DL645_DI := WRITE_DEBOUNCE_THRESHOLD_CMD;
	
	len := 4;

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
      				g_disp.DispLog('写流量消抖阈值成功');
      			end
      			else
      			begin
      				g_disp.DispLog('写流量消抖阈值失败');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('写流量消抖阈值失败');
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

    TButton(Sender).Enabled := TRUE;
end;

end.
