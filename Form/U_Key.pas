unit U_Key;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin, U_Disp, U_Multi;

type
  TF_Key = class(TForm)
    scrlbx0: TScrollBox;
    scrlbx1: TGroupBox;
    btn_load: TButton;
    btn_cancel: TButton;
    auto_send_cycle: TLabel;
    edt_id_begin: TEdit;
    edt_id_end: TEdit;
    Label2: TLabel;
    edt_user_pwd: TEdit;
    scrlbx2: TGroupBox;
    btn_write_param: TBitBtn;
    Label3: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    edt_id_yet: TEdit;
    Label6: TLabel;
    edt_id_soon: TEdit;
    scrlbx3: TGroupBox;
    Label7: TLabel;
    edt_read_id: TEdit;
    btn_restore_defaults: TBitBtn;
    btn_read_param: TBitBtn;
    edt_soft_version: TEdit;
    Label4: TLabel;
    btn_soft_version: TButton;
    procedure formcreate(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_loadClick(Sender: TObject);
    procedure edt_idInput(Sender: TObject; var Key: Char);
    procedure btn_read_paramClick(Sender: TObject);
    procedure btn_restore_defaultsClick(Sender: TObject);
    procedure btn_write_paramClick(Sender: TObject);
    procedure btn_soft_versionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function KeyIdRead():string;

var
  F_Key: TF_Key;

implementation

uses U_Main;
var
  prefix_title:string = '《无线钥匙加工、生产的日志文件》';
  prefix_range:string = '烧写ID范围: ';
  prefix_soon:string = '即将烧写ID: ';
  prefix_finish:string = 'ID烧写完成: ';
  prefix_warn:string = '请勿改动本文件！';

  const line_title = 0;
  const line_range = 1;
  const line_soon = 2;
  const line_finish = 3;
  const line_warn = 4;

{$R *.dfm}

function NewTxtFile(fname:string):BOOLEAN;
var
  F:TextFile;
  tlist:TStringList;
begin
  AssignFile(F, fname); //将文件名与F关联
  if FileExists(fname) then
  begin
    Append(F);
    Closefile(F); //关闭文件F
    Result := False;
  end
  else
  begin
    ReWrite(F); //创建TXT文件，并命名为'fname'
    Closefile(F); //关闭文件F
    tlist := TStringList.Create;
    tlist.LoadFromFile('key_log.txt');
    tlist.Add(prefix_title); //第一行
    tlist.Add(prefix_range); //第二行
    tlist.Add(prefix_soon); //第三行
    tlist.Add(prefix_finish); //第四行
    tlist.Add(prefix_warn); //第五行
    tlist.SaveToFile('key_log.txt');
    tlist.Free;
    Result := True;
  end;
end;

procedure TF_Key.formcreate(Sender: TObject);
var
  tlist:TStringList;
begin
  if FileExists('key_log.txt') then
  begin
    tlist := TStringList.Create;
    tlist.LoadFromFile('key_log.txt');
    g_disp.DispLog(tlist.Strings[line_title]);
    g_disp.DispLog(tlist.Strings[line_range]);
    g_disp.DispLog(tlist.Strings[line_soon]);
    g_disp.DispLog(tlist.Strings[line_finish]);
    g_disp.DispLog(tlist.Strings[line_warn]);
    tlist.Free;
  end;
end;

procedure TF_Key.btn_cancelClick(Sender: TObject);
begin
  TButton(Sender).Enabled := False;

  CommWaitForResp();

  edt_id_begin.Color := clWindow;
  edt_id_begin.ReadOnly := False;
  edt_id_begin.Clear;
  edt_id_end.Color := clWindow;
  edt_id_end.ReadOnly := False;
  edt_id_end.Clear;
  edt_id_yet.Clear;
  edt_id_soon.Clear;
  btn_load.Enabled := True;

  TButton(Sender).Enabled := True;
end;

procedure TF_Key.btn_loadClick(Sender: TObject);
var
  fname:string;
  tlist:TStringList;
  bp:BOOLEAN;
  id_len_begin, id_len_end:Integer;
  id_prefix_begin, id_prefix_end, id_num_begin, id_num_end:string;
  log_date:string;
begin
  fname := 'key_log.txt';

  if NewTxtFile(fname) = False then
  begin
    g_disp.DispLog('加载日志文件：' + ExtractFilePath(ParamStr(0)) + fname); //会显示路径以及文件名
    tlist := TStringList.Create;
    tlist.LoadFromFile(fname);
    edt_id_begin.Text := copy(tlist.Strings[line_range], 13, 8);
    edt_id_end.Text := copy(tlist.Strings[line_range], 22, 8);
    edt_id_soon.Text := copy(tlist.Strings[line_soon], 13, 8);
    tlist.Free;
  end
  else
  begin
    g_disp.DispLog('创建日志文件：' + ExtractFilePath(ParamStr(0)) + fname);

    bp := False;
    
    id_len_begin := length(edt_id_begin.Text); //ID长度
    id_len_end := length(edt_id_end.Text);
    if (id_len_begin <> 8) or (id_len_end <> 8) then
    begin
      bp := True;
      g_disp.DispLog('请检查钥匙ID长度：' + inttostr(id_len_begin) + ' ' + 'V' + ' ' + inttostr(id_len_end));
    end;

    id_prefix_begin := Copy(edt_id_begin.Text, 1, 3); //截取ID非数值部分
    id_prefix_end := Copy(edt_id_end.Text, 1, 3);
    if AnsiCompareStr(id_prefix_end, id_prefix_begin) <> 0 then
    begin
      bp := True;
      g_disp.DispLog('钥匙ID信息不一致：' + id_prefix_begin + ' ' + 'V' + ' ' + id_prefix_end);
    end;

    id_num_begin := Copy(edt_id_begin.Text, 4, 5); //截取ID数值部分
    id_num_end := Copy(edt_id_end.Text, 4, 5);
    if AnsiCompareStr(id_num_end, id_num_begin) <= 0 then
    begin
      bp := True;
      g_disp.DispLog('钥匙结束ID必须大于钥匙开始ID：' + id_num_begin + ' ' + 'V' + ' ' + id_num_end);
    end;

    if bp = True then
    begin
      Beep();
      g_disp.DispLog('删除无效日志文件：' + ExtractFilePath(ParamStr(0)) + fname);
      deleteFile(fname);
      Abort(); //中止程序的运行
    end;

    log_date := FormatdateTime('c', now); //日志时间

    tlist := TStringList.Create; //更新日志文件
    tlist.LoadFromFile(fname);

    tlist.Strings[line_range] := prefix_range + edt_id_begin.Text + ' '
                              + edt_id_end.Text + ' ' + log_date;

    edt_id_soon.Text := edt_id_begin.Text;
    tlist.Strings[line_soon] := prefix_soon + edt_id_soon.Text + ' '
                             + log_date;

    tlist.SaveToFile(fname);
    tlist.Free;
  end;

  edt_id_begin.Color := edt_user_pwd.Color;
  edt_id_begin.ReadOnly := True;
  edt_id_end.Color := edt_user_pwd.Color;
  edt_id_begin.ReadOnly := True;
  btn_load.Enabled := False;
end;

procedure TF_Key.edt_idInput(Sender: TObject; var Key: Char);
begin
  if not(key in ['0'..'9', #8]) then //0 - 9, BackSpace
  begin
    key := #0; //输入置空
    Beep(); //调用系统声音
  end;
end;

procedure TF_Key.btn_read_paramClick(Sender: TObject);
var strTmp:string;
    p:PByte;
    len,i:Integer;
begin
  TButton(Sender).Enabled := False;
  
  strTmp := 'hdXXXX123s';
  CommMakeFrame1(strTmp);

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    g_disp.DispLog('读钥匙ID');
    if CommRecved = True then
    begin
      CommRecved := False;
      p := GetCommRecvBufAddr();
      len := GetCommRecvDataLen();
      Inc(p, 8);
      Dec(len); //减换行
      Dec(len, 8); //数据长度
      strTmp := '';

      for i:=0 to len do
      begin
        strTmp := strTmp + chr(p^);
        Inc(p);
      end;

      strTmp := StringReplace(strTmp,' ', '', [rfReplaceAll]); //去除字符串中的空格

      edt_read_id.Text := strTmp;
    end
    else
    begin
      g_disp.DispLog('串口接收无数据');
    end;
  end;

  TButton(Sender).Enabled := True;
end;

procedure TF_Key.btn_restore_defaultsClick(Sender: TObject);
var
  strTmp:string;
begin
  TButton(Sender).Enabled := False;

  strTmp := 'hXXXXX HRK';
  CommMakeFrame1(strTmp);

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    g_disp.DispLog('恢复出厂设置');
  end;

  TButton(Sender).Enabled := True;
end;

procedure TF_Key.btn_write_paramClick(Sender: TObject);
var
  strTmp, key_id, log_date, fname, soon_id:string;
  n:Integer; //2147483647 ～ -2147483648
  s:BOOLEAN;
  id_byte_0, id_byte_1, id_byte_2, id_byte_3, pwd_str:string;
  pwd:array[0..3] of Byte;
  key_frame:array[0..9] of Byte;
  tlist:TStringList;
begin
  TButton(Sender).Enabled := False;
  
  if btn_load.Enabled = True then
  begin
    Beep();
    g_disp.DispLog('请确认加载日志文件，再进行本操作');
    TButton(Sender).Enabled := True;
    Abort(); //中止程序的运行
  end;

  id_byte_0 := '$' + copy(edt_id_soon.Text, 1, 2); //高位起，第一个字节
  id_byte_1 := '$' + copy(edt_id_soon.Text, 3, 2); //高位起，第二个字节
  id_byte_2 := '$' + copy(edt_id_soon.Text, 5, 2); //高位起，第三个字节
  id_byte_3 := '$' + copy(edt_id_soon.Text, 7, 2); //高位起，第四个字节

  pwd_str := copy(edt_user_pwd.Text, 1, 4); //用户密码
  strpcopy(@pwd[0], copy(pwd_str, 1, 1));
  strpcopy(@pwd[1], copy(pwd_str, 2, 1));
  strpcopy(@pwd[2], copy(pwd_str, 3, 1));
  strpcopy(@pwd[3], copy(pwd_str, 4, 1));

  key_frame[0] := Ord('h'); //头
  key_frame[1] := Ord('D'); //命令
  {ID：31200000，0x31 0x20 0x00 0x00 0x00 0x00 0x00}
  key_frame[2] := strtoint(id_byte_0); //参数，strtoint('$31') = 0x31
  key_frame[3] := strtoint(id_byte_1);
  key_frame[4] := strtoint(id_byte_2);
  key_frame[5] := strtoint(id_byte_3);
  key_frame[6] := pwd[0]; //密码
  key_frame[7] := pwd[1];
  key_frame[8] := pwd[2];
  key_frame[9] := pwd[3];

  CommMakeFrame2(@key_frame, 10); //组帧

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    g_disp.DispLog('写钥匙ID');

    key_id := copy(KeyIdRead(), 1, 8); //回读钥匙ID，看有没有写入成功
    soon_id := copy(edt_id_soon.Text, 1, 8);
    
    if AnsiCompareStr(key_id, soon_id) <> 0 then
    begin
      g_disp.DispLog(edt_id_soon.Text + ' ' + 'V' + ' ' + key_id);
      g_disp.DispLog('钥匙ID写入失败');
    end
    else
    begin
      edt_id_yet.Text := edt_id_soon.Text; //更新已烧写文本框

      if AnsiSameStr(edt_id_yet.Text, edt_id_end.Text) then //检查烧写完成
      begin
        log_date := FormatdateTime('c', now);

        fname := 'key_log.txt'; //下面更新烧写完成的日志
        tlist := TStringList.Create;
        tlist.LoadFromFile(fname);
        tlist.Strings[line_finish] := prefix_finish + edt_id_end.Text + ' '
                               + log_date;
        tlist.SaveToFile(fname);
        tlist.Free;
        g_disp.DispLog('钥匙ID烧写完成');
      end
      else
      begin
        strTmp := copy(edt_id_soon.Text, 4, 5); //计算下一个ID
        n := strtoint(strTmp);
        Inc(n); 
        strTmp := copy(edt_id_soon.Text, 1, 3);
        strTmp := strTmp + format('%.5d', [n]); //5位长度

        edt_id_soon.Text := strTmp; //下一个即将烧写的ID

        log_date := FormatdateTime('c', now);

        fname := 'key_log.txt'; //下面更新即将烧写ID的日志
        tlist := TStringList.Create;
        tlist.LoadFromFile(fname);
        tlist.Strings[line_soon] := prefix_soon + edt_id_soon.Text + ' '
                               + log_date;
        tlist.SaveToFile(fname);
        tlist.Free;
      end;
    end;
  end
  else
  begin
    g_disp.DispLog('串口接收无数据');
  end;

  TButton(Sender).Enabled := True;
end;

function KeyIdRead():string;
var strTmp:string;
    p:PByte;
    len,i:Integer;
begin
  strTmp := 'hdXXXX123s';
  CommMakeFrame1(strTmp);

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    //g_disp.DispLog('读钥匙ID');
    if CommRecved = True then
    begin
      CommRecved := False;
      p := GetCommRecvBufAddr();
      len := GetCommRecvDataLen();
      Inc(p, 8);
      Dec(len); //减换行
      Dec(len, 8); //数据长度
      strTmp := '';

      for i:=0 to len do
      begin
        strTmp := strTmp + chr(p^);
        Inc(p);
      end;

      strTmp := StringReplace(strTmp,' ', '', [rfReplaceAll]); //去除字符串中的空格

      Result := strTmp;
    end
    else
    begin
      //g_disp.DispLog('串口接收无数据');
      Result := '';
    end;
  end;
end;

procedure TF_Key.btn_soft_versionClick(Sender: TObject);
var strTmp:string;
    p:PByte;
    len,i:Integer;
begin
  TButton(Sender).Enabled := False;
  
  strTmp := 'hvXXXX123s';
  CommMakeFrame1(strTmp);

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    g_disp.DispLog('读钥匙软件版本');
    if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();
        Inc(p, 9);
        Dec(len); //减换行
        Dec(len, 9); //数据长度
        strTmp := '';

        for i:=0 to len do
        begin
          strTmp := strTmp + chr(p^);
          Inc(p);
        end;

        edt_soft_version.Text := strTmp;
      end
      else
      begin
        g_disp.DispLog('串口接收无数据');
      end;
  end;

  TButton(Sender).Enabled := True;
end;

end.
