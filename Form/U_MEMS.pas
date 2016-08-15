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
    btn_sysinfo_read_para: TBitBtn;
    GroupBox1: TGroupBox;
    btn_mems_para_read: TButton;
    Label6: TLabel;
    edt_mems_sample_num_read: TEdit;
    edt_mems_sample_num_write: TEdit;
    btn_mems_sample_num_save: TButton;
    edt_mems_measure_flow_read: TEdit;
    btn_mems_standard_flow_save: TButton;
    edt_mems_standard_flow_write: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edt_mems_cal_coefficient_read: TEdit;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure chk_allClick(Sender: TObject);
    procedure edt_memsInput(Sender: TObject; var Key: Char);
    procedure btn_sysinfo_read_paraClick(Sender: TObject);
    procedure btn_sysinfo_write_paraClick(Sender: TObject);
    procedure btn_restore_defaultsClick(Sender: TObject);
    procedure btn_mems_para_readClick(Sender: TObject);
    procedure btn_mems_sample_num_saveClick(Sender: TObject);
    procedure btn_mems_standard_flow_saveClick(Sender: TObject);
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
	READ_MEMS_PARA_CMD = $FF000006;
	WRITE_MEMS_SAMPLE_NUM_CMD = $FF000007;
	WRITE_MEMS_STANDARD_FLOW_CMD = $FF000008;

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
	TButton(Sender).Enabled := False;
	
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
	      			
	      				g_disp.DispLog('系统时间读取成功');
	      			end
	      			else
	      			begin
	      				g_disp.DispLog('系统时间读取失败');
	      			end;
	      		end	
		    	else
		    	begin
		    		g_disp.DispLog('系统时间读取失败');
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
	      			
	      				g_disp.DispLog('版本号读取成功');
	      			end
	      			else
	      			begin
	      				g_disp.DispLog('版本号读取失败');
	      			end;
	      		end	
		    	else
		    	begin
		    		g_disp.DispLog('版本号读取失败');
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

	TButton(Sender).Enabled := True;    
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
	TButton(Sender).Enabled := False;
	
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
	      				g_disp.DispLog('系统时间写入成功');
	      			end
	      			else
	      			begin
	      				g_disp.DispLog('系统时间写入失败');
	      			end;
	      		end	
		    	else
		    	begin
		    		g_disp.DispLog('系统时间写入失败');
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

    TButton(Sender).Enabled := True;
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

procedure TF_MEMS.btn_mems_para_readClick(Sender: TObject);
var
	p:PByte;
	ctrl:Byte;
	len, measure_flow, sample_num:Integer;
	cal_coefficient:Single;
	DI:LongWord;
	pdata:PInteger;
begin
	TButton(Sender).Enabled := False;

	edt_mems_measure_flow_read.text := '';
  	edt_mems_sample_num_read.text := '';
  	edt_mems_cal_coefficient_read.text := '';

	DL645_Ctrl := $11;

	DL645_DI := READ_MEMS_PARA_CMD;
	
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
					
      			if (ctrl = $91) and (DI = READ_MEMS_PARA_CMD) then
      			begin
					pdata := PInteger(p);
      			
					measure_flow := PInteger(Integer(pdata) + 0 * 4)^;
					sample_num := PInteger(Integer(pdata) + 1 * 4)^;
					cal_coefficient := PSingle(Integer(pdata) + 2 * 4)^;

					edt_mems_measure_flow_read.text := IntToStr(measure_flow);
					edt_mems_sample_num_read.text := IntToStr(sample_num);
					edt_mems_cal_coefficient_read.text := FloatToStr(cal_coefficient);
      			
      				g_disp.DispLog('流量计参数读取成功');
      			end
      			else
      			begin
      				g_disp.DispLog('流量计参数读取失败');
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('流量计参数读取失败');
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

procedure TF_MEMS.btn_mems_sample_num_saveClick(Sender: TObject);
var
	p:PByte;
	ctrl, error_code:Byte;
	len, data:Integer;
	strTmp:String;
	pdata:PInteger;
	buf:array[0..63] of Byte;
begin
	strTmp := edt_mems_sample_num_write.text;

	if strTmp = '' then
	begin
		Beep(); //调用系统声音
		g_disp.DispLog('请输入一个数值');
		Abort(); //中止程序的运行
	end;
	
	TButton(Sender).Enabled := False;
  
	data := StrToInt(edt_mems_sample_num_write.text);

	CopyMemory(@buf[0], @data, 4);
	
	DL645_Ctrl := $14;

	DL645_DI := WRITE_MEMS_SAMPLE_NUM_CMD;
	
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
      			p := DL645.GetDataUnit();
				
      			if ctrl = $94 then
      			begin
      				g_disp.DispLog('流量计样本数目写入成功');
      			end
      			else if ctrl = $D4 then
      			begin
					pdata := PInteger(p);
      			
					error_code := PByte(Integer(pdata) + 0 * 1)^;

      				if error_code = $01 then
      				begin
      					g_disp.DispLog('输入的参数无效');
      				end
      				else if error_code = $02 then
      				begin
      					g_disp.DispLog('流量计样本数目写入失败');
      				end;
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('流量计样本数目写入失败');
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

procedure TF_MEMS.btn_mems_standard_flow_saveClick(Sender: TObject);
var
	p:PByte;
	ctrl, error_code:Byte;
	len, data:Integer;
	strTmp:String;
	pdata:PInteger;
	buf:array[0..63] of Byte;
begin
	strTmp := edt_mems_standard_flow_write.text;

	if strTmp = '' then
	begin
		Beep(); //调用系统声音
		g_disp.DispLog('请输入一个数值');
		Abort(); //中止程序的运行
	end;
	
	TButton(Sender).Enabled := False;

	data := StrToInt(edt_mems_standard_flow_write.text);

	CopyMemory(@buf[0], @data, 4);
	
	DL645_Ctrl := $14;

	DL645_DI := WRITE_MEMS_STANDARD_FLOW_CMD;
	
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
      			p := DL645.GetDataUnit();
				
      			if ctrl = $94 then
      			begin
      				g_disp.DispLog('流量计校准成功');
      			end
      			else if ctrl = $D4 then
      			begin
					pdata := PInteger(p);
      			
					error_code := PByte(Integer(pdata) + 0 * 1)^;

      				if error_code = $01 then
      				begin
      					g_disp.DispLog('输入的参数无效');
      				end
      				else if error_code = $02 then
      				begin
      					g_disp.DispLog('流量计校准失败');
      				end;
      			end;
      		end	
	    	else
	    	begin
	    		g_disp.DispLog('流量计校准失败');
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
