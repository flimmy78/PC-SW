unit U_Noise;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons, U_Disp, U_Multi;

type
  TF_Noise = class(TForm)
    scrlbx0: TScrollBox;
    scrlbx1: TGroupBox;
    rb_ext_mic: TRadioButton;
    rb_int_mic: TRadioButton;
    btn_confirm: TButton;
    btn_cancel: TButton;
    scrlbx2: TGroupBox;
    btn_restore: TBitBtn;
    auto_send_cycle: TLabel;
    edt_dbg_view1: TEdit;
    btn_shake: TBitBtn;
    edt_stard_db1: TEdit;
    edt_dbg_view2: TEdit;
    edt_dbg_view3: TEdit;
    edt_dbg_view4: TEdit;
    edt_stard_db2: TEdit;
    edt_stard_db3: TEdit;
    edt_stard_db4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btn_save1: TButton;
    btn_save2: TButton;
    btn_save3: TButton;
    btn_save4: TButton;
    procedure edt_noiseInput(Sender: TObject; var Key: Char);
    procedure btn_shakeClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_confirmClick(Sender: TObject);
    procedure btn_restoreClick(Sender: TObject);
    procedure btn_save1Click(Sender: TObject);
    procedure btn_save2Click(Sender: TObject);
    procedure btn_save3Click(Sender: TObject);
    procedure btn_save4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Noise: TF_Noise;
  chn:Integer = $10;

implementation

uses U_Main;

{$R *.dfm}

procedure TF_Noise.edt_noiseInput(Sender: TObject; var Key: Char);
begin
  if not(key in ['0'..'9', #8]) then //0 - 9, BackSpace
  begin
    key := #0; //输入置空
    Beep(); //调用系统声音
  end;
end;

procedure TF_Noise.btn_shakeClick(Sender: TObject);
var
  crc, i, len, temp:Integer;
  strTmp:String;
  noise_frame:array[0..9] of Byte;
  p, q:PByte;
begin
  noise_frame[0] := Ord('h'); //头;
  noise_frame[1] := 5;
  noise_frame[2] := $10;
  noise_frame[3] := $11;
  noise_frame[4] := $00;
  noise_frame[5] := $00;
  noise_frame[6] := $00;
  
  crc := 0;
  for i:=0 to 6 do
  begin
    crc := crc + noise_frame[i];
  end;

  {
    $44332211
    Lo　　　//获取例数中的$11　
    Hi　　　//获取例数中的$22　
    LoWord　//获取例数中的$2211　
    HiWord　//获取例数中的$4433　
  }
  noise_frame[7] := Lo(crc);
  noise_frame[8] := Hi(crc);

  noise_frame[9] := Ord('t'); //尾;

  len := 10;

  CommMakeFrame2(@noise_frame, len);

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    if CommRecved = True then
    begin
      CommRecved := False;
      p := GetCommRecvBufAddr();
      len := GetCommRecvDataLen();

      q := p;
      temp := 0;
      for i:=0 to (len - 4) do
      begin
        temp := temp + q^;
        Inc(q);
      end;
      crc := q^;
      Inc(q);
      crc := crc + q^ shl 8; //crc校验
      if crc <> temp then
      begin
        g_disp.DispLog('数据校验不正确');
        Abort(); //中止程序的运行
      end;

      Inc(p);
      Inc(p);
      Inc(p);
      temp := p^;
      if temp = $55 then
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
      g_disp.DispLog('串口接收无数据');
    end;
  end;
end;

procedure TF_Noise.btn_cancelClick(Sender: TObject);
begin
  rb_ext_mic.Checked := FALSE;
  rb_int_mic.Checked := FALSE;
  chn := $10;
  rb_ext_mic.Enabled := TRUE;
  rb_int_mic.Enabled := TRUE;
  btn_confirm.Enabled := TRUE;
end;

procedure TF_Noise.btn_confirmClick(Sender: TObject);
begin
  if rb_ext_mic.Checked = TRUE then
  begin
    chn := $00;
  end;

  if rb_int_mic.Checked = TRUE then
  begin
    chn := $01;
  end;

  if chn <> $10 then
  begin
    rb_ext_mic.Enabled := FALSE;
    rb_int_mic.Enabled := FALSE;
    TButton(Sender).Enabled := False;    
  end
  else
  begin
    chn := $10;
    g_disp.DispLog('请选择要校准的通道');
  end;
end;

procedure TF_Noise.btn_restoreClick(Sender: TObject);
var
  crc, i, len, temp:Integer;
  strTmp:String;
  noise_frame:array[0..9] of Byte;
  p, q:PByte;
begin
  noise_frame[0] := Ord('h'); //头;
  noise_frame[1] := 5;
  noise_frame[2] := $10;
  noise_frame[3] := $66;
  noise_frame[4] := $00;
  noise_frame[5] := $00;
  noise_frame[6] := $00;

  crc := 0;
  for i:=0 to 6 do
  begin
    crc := crc + noise_frame[i];
  end;

  {
    $44332211
    Lo　　　//获取例数中的$11　
    Hi　　　//获取例数中的$22　
    LoWord　//获取例数中的$2211　
    HiWord　//获取例数中的$4433　
  }
  noise_frame[7] := Lo(crc);
  noise_frame[8] := Hi(crc);

  noise_frame[9] := Ord('t'); //尾;

  len := 10;

  CommMakeFrame2(@noise_frame, len);

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    if CommRecved = True then
    begin
      CommRecved := False;
      p := GetCommRecvBufAddr();
      len := GetCommRecvDataLen();

      q := p;
      temp := 0;
      for i:=0 to (len - 4) do
      begin
        temp := temp + q^;
        Inc(q);
      end;
      crc := q^;
      Inc(q);
      crc := crc + q^ shl 8; //crc校验
      if crc <> temp then
      begin
        g_disp.DispLog('数据校验不正确');
        Abort(); //中止程序的运行
      end;

      Inc(p);
      Inc(p);
      Inc(p);
      temp := p^;
      if temp = $55 then
      begin
        g_disp.DispLog('恢复出厂成功');
      end
      else
      begin
        Inc(p);
        temp := p^;

        case temp of
        $33: strTmp := '写入FLASH出错';
        end;
        
        g_disp.DispLog(strTmp);
      end;
    end
    else
    begin
      g_disp.DispLog('串口接收无数据');
    end;
  end;
end;

procedure TF_Noise.btn_save1Click(Sender: TObject);
var
  crc, i, len, temp, std_noise:Integer;
  strTmp:String;
  noise_frame:array[0..9] of Byte;
  p, q:PByte;
begin
  strTmp := edt_stard_db1.Text;

  if strTmp = '' then
  begin
    Beep(); //调用系统声音
    g_disp.DispLog('请输入一个数值！');
    Abort(); //中止程序的运行
  end;

  std_noise := strtoint(strTmp);

  if std_noise > 120 then
  begin
    Beep(); //调用系统声音
    g_disp.DispLog('输入的数值不在范围之内（0 ~ 120），请重新输入');
    Abort(); //中止程序的运行
  end;

  if chn = $10 then
  begin
    g_disp.DispLog('请选择要校准的通道');
    Abort(); //中止程序的运行
  end;

  noise_frame[0] := Ord('h'); //头;
  noise_frame[1] := 5;
  noise_frame[2] := chn;
  noise_frame[3] := $22;
  noise_frame[4] := 0; //点1
  noise_frame[5] := Lo(std_noise);
  noise_frame[6] := Hi(std_noise);
  
  crc := 0;
  for i:=0 to 6 do
  begin
    crc := crc + noise_frame[i];
  end;

  {
    $44332211
    Lo　　　//获取例数中的$11　
    Hi　　　//获取例数中的$22　
    LoWord　//获取例数中的$2211　
    HiWord　//获取例数中的$4433　
  }
  noise_frame[7] := Lo(crc);
  noise_frame[8] := Hi(crc);

  noise_frame[9] := Ord('t'); //尾;

  len := 10;

  CommMakeFrame2(@noise_frame, len);

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    if CommRecved = True then
    begin
      CommRecved := False;
      p := GetCommRecvBufAddr();
      len := GetCommRecvDataLen();

      q := p;
      temp := 0;
      for i:=0 to (len - 4) do
      begin
        temp := temp + q^;
        Inc(q);
      end;
      crc := q^;
      Inc(q);
      crc := crc + q^ shl 8; //crc校验
      if crc <> temp then
      begin
        g_disp.DispLog('数据校验不正确');
        Abort(); //中止程序的运行
      end;
            
      Inc(p);
      Inc(p);
      Inc(p);
      temp := p^; //执行状态
      if temp = $55 then
      begin
        Inc(p);
        Inc(p);
        temp := p^ shl 0; //p^左移0位
        Inc(p);
        temp := temp + (p^ shl 8);
        
        edt_dbg_view1.Text := inttostr(temp);

        g_disp.DispLog('校准成功');
      end
      else
      begin
        Inc(p);
        temp := p^;

        case temp of
        $11: strTmp := '校准的通道无效';
        $22: strTmp := '校准的点无效';
        $33: strTmp := '写入FLASH出错';
        end;

        edt_dbg_view1.Text := '';
        g_disp.DispLog(strTmp);
      end;
    end
    else
    begin
      g_disp.DispLog('串口接收无数据');
    end;
  end;
end;

procedure TF_Noise.btn_save2Click(Sender: TObject);
var
  crc, i, len, temp, std_noise:Integer;
  strTmp:String;
  noise_frame:array[0..9] of Byte;
  p, q:PByte;
begin
  strTmp := edt_stard_db2.Text;

  if strTmp = '' then
  begin
    Beep(); //调用系统声音
    g_disp.DispLog('请输入一个数值！');
    Abort(); //中止程序的运行
  end;

  std_noise := strtoint(strTmp);

  if std_noise > 120 then
  begin
    Beep(); //调用系统声音
    g_disp.DispLog('输入的数值不在范围之内（0 ~ 120），请重新输入');
    Abort(); //中止程序的运行
  end;

  if chn = $10 then
  begin
    g_disp.DispLog('请选择要校准的通道');
    Abort(); //中止程序的运行
  end;

  noise_frame[0] := Ord('h'); //头;
  noise_frame[1] := 5;
  noise_frame[2] := chn;
  noise_frame[3] := $22;
  noise_frame[4] := 1; //点2
  noise_frame[5] := Lo(std_noise);
  noise_frame[6] := Hi(std_noise);
  
  crc := 0;
  for i:=0 to 6 do
  begin
    crc := crc + noise_frame[i];
  end;

  {
    $44332211
    Lo　　　//获取例数中的$11　
    Hi　　　//获取例数中的$22　
    LoWord　//获取例数中的$2211　
    HiWord　//获取例数中的$4433　
  }
  noise_frame[7] := Lo(crc);
  noise_frame[8] := Hi(crc);

  noise_frame[9] := Ord('t'); //尾;

  len := 10;

  CommMakeFrame2(@noise_frame, len);

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    if CommRecved = True then
    begin
      CommRecved := False;
      p := GetCommRecvBufAddr();
      len := GetCommRecvDataLen();

      q := p;
      temp := 0;
      for i:=0 to (len - 4) do
      begin
        temp := temp + q^;
        Inc(q);
      end;
      crc := q^;
      Inc(q);
      crc := crc + q^ shl 8; //crc校验
      if crc <> temp then
      begin
        g_disp.DispLog('数据校验不正确');
        Abort(); //中止程序的运行
      end;

      Inc(p);
      Inc(p);
      Inc(p);
      temp := p^; //执行状态
      if temp = $55 then
      begin
        Inc(p);
        Inc(p);
        temp := p^ shl 0; //p^左移0位
        Inc(p);
        temp := temp + (p^ shl 8);
        
        edt_dbg_view2.Text := inttostr(temp);

        g_disp.DispLog('校准成功');
      end
      else
      begin
        Inc(p);
        temp := p^;

        case temp of
        $11: strTmp := '校准的通道无效';
        $22: strTmp := '校准的点无效';
        $33: strTmp := '写入FLASH出错';
        end;

        edt_dbg_view2.Text := '';
        g_disp.DispLog(strTmp);
      end;
    end
    else
    begin
      g_disp.DispLog('串口接收无数据');
    end;
  end;
end;

procedure TF_Noise.btn_save3Click(Sender: TObject);
var
  crc, i, len, temp, std_noise:Integer;
  strTmp:String;
  noise_frame:array[0..9] of Byte;
  p, q:PByte;
begin
  strTmp := edt_stard_db3.Text;

  if strTmp = '' then
  begin
    Beep(); //调用系统声音
    g_disp.DispLog('请输入一个数值！');
    Abort(); //中止程序的运行
  end;

  std_noise := strtoint(strTmp);

  if std_noise > 120 then
  begin
    Beep(); //调用系统声音
    g_disp.DispLog('输入的数值不在范围之内（0 ~ 120），请重新输入');
    Abort(); //中止程序的运行
  end;

  if chn = $10 then
  begin
    g_disp.DispLog('请选择要校准的通道');
    Abort(); //中止程序的运行
  end;

  noise_frame[0] := Ord('h'); //头;
  noise_frame[1] := 5;
  noise_frame[2] := chn;
  noise_frame[3] := $22;
  noise_frame[4] := 2; //点3
  noise_frame[5] := Lo(std_noise);
  noise_frame[6] := Hi(std_noise);
  
  crc := 0;
  for i:=0 to 6 do
  begin
    crc := crc + noise_frame[i];
  end;

  {
    $44332211
    Lo　　　//获取例数中的$11　
    Hi　　　//获取例数中的$22　
    LoWord　//获取例数中的$2211　
    HiWord　//获取例数中的$4433　
  }
  noise_frame[7] := Lo(crc);
  noise_frame[8] := Hi(crc);

  noise_frame[9] := Ord('t'); //尾;

  len := 10;

  CommMakeFrame2(@noise_frame, len);

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    if CommRecved = True then
    begin
      CommRecved := False;
      p := GetCommRecvBufAddr();
      len := GetCommRecvDataLen();
      
      q := p;
      temp := 0;
      for i:=0 to (len - 4) do
      begin
        temp := temp + q^;
        Inc(q);
      end;
      crc := q^;
      Inc(q);
      crc := crc + q^ shl 8; //crc校验
      if crc <> temp then
      begin
        g_disp.DispLog('数据校验不正确');
        Abort(); //中止程序的运行
      end;

      Inc(p);
      Inc(p);
      Inc(p);
      temp := p^; //执行状态
      if temp = $55 then
      begin
        Inc(p);
        Inc(p);
        temp := p^ shl 0; //p^左移0位
        Inc(p);
        temp := temp + (p^ shl 8);
        
        edt_dbg_view3.Text := inttostr(temp);

        g_disp.DispLog('校准成功');
      end
      else
      begin
        Inc(p);
        temp := p^;

        case temp of
        $11: strTmp := '校准的通道无效';
        $22: strTmp := '校准的点无效';
        $33: strTmp := '写入FLASH出错';
        end;

        edt_dbg_view3.Text := '';
        g_disp.DispLog(strTmp);
      end;
    end
    else
    begin
      g_disp.DispLog('串口接收无数据');
    end;
  end;
end;

procedure TF_Noise.btn_save4Click(Sender: TObject);
var
  crc, i, len, temp, std_noise:Integer;
  strTmp:String;
  noise_frame:array[0..9] of Byte;
  p, q:PByte;
begin
  strTmp := edt_stard_db4.Text;

  if strTmp = '' then
  begin
    Beep(); //调用系统声音
    g_disp.DispLog('请输入一个数值！');
    Abort(); //中止程序的运行
  end;

  std_noise := strtoint(strTmp);

  if std_noise > 120 then
  begin
    Beep(); //调用系统声音
    g_disp.DispLog('输入的数值不在范围之内（0 ~ 120），请重新输入');
    Abort(); //中止程序的运行
  end;

  if chn = $10 then
  begin
    g_disp.DispLog('请选择要校准的通道');
    Abort(); //中止程序的运行
  end;

  noise_frame[0] := Ord('h'); //头;
  noise_frame[1] := 5;
  noise_frame[2] := chn;
  noise_frame[3] := $22;
  noise_frame[4] := 3; //点4
  noise_frame[5] := Lo(std_noise);
  noise_frame[6] := Hi(std_noise);
  
  crc := 0;
  for i:=0 to 6 do
  begin
    crc := crc + noise_frame[i];
  end;

  {
    $44332211
    Lo　　　//获取例数中的$11　
    Hi　　　//获取例数中的$22　
    LoWord　//获取例数中的$2211　
    HiWord　//获取例数中的$4433　
  }
  noise_frame[7] := Lo(crc);
  noise_frame[8] := Hi(crc);

  noise_frame[9] := Ord('t'); //尾;

  len := 10;

  CommMakeFrame2(@noise_frame, len);

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    if CommRecved = True then
    begin
      CommRecved := False;
      p := GetCommRecvBufAddr();
      len := GetCommRecvDataLen();

      q := p;
      temp := 0;
      for i:=0 to (len - 4) do
      begin
        temp := temp + q^;
        Inc(q);
      end;
      crc := q^;
      Inc(q);
      crc := crc + q^ shl 8; //crc校验
      if crc <> temp then
      begin
        g_disp.DispLog('数据校验不正确');
        Abort(); //中止程序的运行
      end;

      Inc(p);
      Inc(p);
      Inc(p);
      temp := p^; //执行状态
      if temp = $55 then
      begin
        Inc(p);
        Inc(p);
        temp := p^ shl 0; //p^左移0位
        Inc(p);
        temp := temp + (p^ shl 8);
        
        edt_dbg_view4.Text := inttostr(temp);

        g_disp.DispLog('校准成功');
      end
      else
      begin
        Inc(p);
        temp := p^;

        case temp of
        $11: strTmp := '校准的通道无效';
        $22: strTmp := '校准的点无效';
        $33: strTmp := '写入FLASH出错';
        end;

        edt_dbg_view4.Text := '';
        g_disp.DispLog(strTmp);
      end;
    end
    else
    begin
      g_disp.DispLog('串口接收无数据');
    end;
  end;
end;

end.
