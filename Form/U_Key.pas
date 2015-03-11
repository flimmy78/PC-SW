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
  prefix_title:string = '������Կ�׼ӹ�����������־�ļ���';
  prefix_range:string = '��дID��Χ: ';
  prefix_soon:string = '������дID: ';
  prefix_finish:string = 'ID��д���: ';
  prefix_warn:string = '����Ķ����ļ���';

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
  AssignFile(F, fname); //���ļ�����F����
  if FileExists(fname) then
  begin
    Append(F);
    Closefile(F); //�ر��ļ�F
    Result := False;
  end
  else
  begin
    ReWrite(F); //����TXT�ļ���������Ϊ'fname'
    Closefile(F); //�ر��ļ�F
    tlist := TStringList.Create;
    tlist.LoadFromFile('key_log.txt');
    tlist.Add(prefix_title); //��һ��
    tlist.Add(prefix_range); //�ڶ���
    tlist.Add(prefix_soon); //������
    tlist.Add(prefix_finish); //������
    tlist.Add(prefix_warn); //������
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
    g_disp.DispLog('������־�ļ���' + ExtractFilePath(ParamStr(0)) + fname); //����ʾ·���Լ��ļ���
    tlist := TStringList.Create;
    tlist.LoadFromFile(fname);
    edt_id_begin.Text := copy(tlist.Strings[line_range], 13, 8);
    edt_id_end.Text := copy(tlist.Strings[line_range], 22, 8);
    edt_id_soon.Text := copy(tlist.Strings[line_soon], 13, 8);
    tlist.Free;
  end
  else
  begin
    g_disp.DispLog('������־�ļ���' + ExtractFilePath(ParamStr(0)) + fname);

    bp := False;
    
    id_len_begin := length(edt_id_begin.Text); //ID����
    id_len_end := length(edt_id_end.Text);
    if (id_len_begin <> 8) or (id_len_end <> 8) then
    begin
      bp := True;
      g_disp.DispLog('����Կ��ID���ȣ�' + inttostr(id_len_begin) + ' ' + 'V' + ' ' + inttostr(id_len_end));
    end;

    id_prefix_begin := Copy(edt_id_begin.Text, 1, 3); //��ȡID����ֵ����
    id_prefix_end := Copy(edt_id_end.Text, 1, 3);
    if AnsiCompareStr(id_prefix_end, id_prefix_begin) <> 0 then
    begin
      bp := True;
      g_disp.DispLog('Կ��ID��Ϣ��һ�£�' + id_prefix_begin + ' ' + 'V' + ' ' + id_prefix_end);
    end;

    id_num_begin := Copy(edt_id_begin.Text, 4, 5); //��ȡID��ֵ����
    id_num_end := Copy(edt_id_end.Text, 4, 5);
    if AnsiCompareStr(id_num_end, id_num_begin) <= 0 then
    begin
      bp := True;
      g_disp.DispLog('Կ�׽���ID�������Կ�׿�ʼID��' + id_num_begin + ' ' + 'V' + ' ' + id_num_end);
    end;

    if bp = True then
    begin
      Beep();
      g_disp.DispLog('ɾ����Ч��־�ļ���' + ExtractFilePath(ParamStr(0)) + fname);
      deleteFile(fname);
      Abort(); //��ֹ���������
    end;

    log_date := FormatdateTime('c', now); //��־ʱ��

    tlist := TStringList.Create; //������־�ļ�
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
    key := #0; //�����ÿ�
    Beep(); //����ϵͳ����
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
    g_disp.DispLog('��Կ��ID');
    if CommRecved = True then
    begin
      CommRecved := False;
      p := GetCommRecvBufAddr();
      len := GetCommRecvDataLen();
      Inc(p, 8);
      Dec(len); //������
      Dec(len, 8); //���ݳ���
      strTmp := '';

      for i:=0 to len do
      begin
        strTmp := strTmp + chr(p^);
        Inc(p);
      end;

      strTmp := StringReplace(strTmp,' ', '', [rfReplaceAll]); //ȥ���ַ����еĿո�

      edt_read_id.Text := strTmp;
    end
    else
    begin
      g_disp.DispLog('���ڽ���������');
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
    g_disp.DispLog('�ָ���������');
  end;

  TButton(Sender).Enabled := True;
end;

procedure TF_Key.btn_write_paramClick(Sender: TObject);
var
  strTmp, key_id, log_date, fname, soon_id:string;
  n:Integer; //2147483647 �� -2147483648
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
    g_disp.DispLog('��ȷ�ϼ�����־�ļ����ٽ��б�����');
    TButton(Sender).Enabled := True;
    Abort(); //��ֹ���������
  end;

  id_byte_0 := '$' + copy(edt_id_soon.Text, 1, 2); //��λ�𣬵�һ���ֽ�
  id_byte_1 := '$' + copy(edt_id_soon.Text, 3, 2); //��λ�𣬵ڶ����ֽ�
  id_byte_2 := '$' + copy(edt_id_soon.Text, 5, 2); //��λ�𣬵������ֽ�
  id_byte_3 := '$' + copy(edt_id_soon.Text, 7, 2); //��λ�𣬵��ĸ��ֽ�

  pwd_str := copy(edt_user_pwd.Text, 1, 4); //�û�����
  strpcopy(@pwd[0], copy(pwd_str, 1, 1));
  strpcopy(@pwd[1], copy(pwd_str, 2, 1));
  strpcopy(@pwd[2], copy(pwd_str, 3, 1));
  strpcopy(@pwd[3], copy(pwd_str, 4, 1));

  key_frame[0] := Ord('h'); //ͷ
  key_frame[1] := Ord('D'); //����
  {ID��31200000��0x31 0x20 0x00 0x00 0x00 0x00 0x00}
  key_frame[2] := strtoint(id_byte_0); //������strtoint('$31') = 0x31
  key_frame[3] := strtoint(id_byte_1);
  key_frame[4] := strtoint(id_byte_2);
  key_frame[5] := strtoint(id_byte_3);
  key_frame[6] := pwd[0]; //����
  key_frame[7] := pwd[1];
  key_frame[8] := pwd[2];
  key_frame[9] := pwd[3];

  CommMakeFrame2(@key_frame, 10); //��֡

  if F_Main.SendDataAuto()
    and CommWaitForResp()
  then
  begin
    g_disp.DispLog('дԿ��ID');

    key_id := copy(KeyIdRead(), 1, 8); //�ض�Կ��ID������û��д��ɹ�
    soon_id := copy(edt_id_soon.Text, 1, 8);
    
    if AnsiCompareStr(key_id, soon_id) <> 0 then
    begin
      g_disp.DispLog(edt_id_soon.Text + ' ' + 'V' + ' ' + key_id);
      g_disp.DispLog('Կ��IDд��ʧ��');
    end
    else
    begin
      edt_id_yet.Text := edt_id_soon.Text; //��������д�ı���

      if AnsiSameStr(edt_id_yet.Text, edt_id_end.Text) then //�����д���
      begin
        log_date := FormatdateTime('c', now);

        fname := 'key_log.txt'; //���������д��ɵ���־
        tlist := TStringList.Create;
        tlist.LoadFromFile(fname);
        tlist.Strings[line_finish] := prefix_finish + edt_id_end.Text + ' '
                               + log_date;
        tlist.SaveToFile(fname);
        tlist.Free;
        g_disp.DispLog('Կ��ID��д���');
      end
      else
      begin
        strTmp := copy(edt_id_soon.Text, 4, 5); //������һ��ID
        n := strtoint(strTmp);
        Inc(n); 
        strTmp := copy(edt_id_soon.Text, 1, 3);
        strTmp := strTmp + format('%.5d', [n]); //5λ����

        edt_id_soon.Text := strTmp; //��һ��������д��ID

        log_date := FormatdateTime('c', now);

        fname := 'key_log.txt'; //������¼�����дID����־
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
    g_disp.DispLog('���ڽ���������');
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
    //g_disp.DispLog('��Կ��ID');
    if CommRecved = True then
    begin
      CommRecved := False;
      p := GetCommRecvBufAddr();
      len := GetCommRecvDataLen();
      Inc(p, 8);
      Dec(len); //������
      Dec(len, 8); //���ݳ���
      strTmp := '';

      for i:=0 to len do
      begin
        strTmp := strTmp + chr(p^);
        Inc(p);
      end;

      strTmp := StringReplace(strTmp,' ', '', [rfReplaceAll]); //ȥ���ַ����еĿո�

      Result := strTmp;
    end
    else
    begin
      //g_disp.DispLog('���ڽ���������');
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
    g_disp.DispLog('��Կ������汾');
    if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();
        Inc(p, 9);
        Dec(len); //������
        Dec(len, 9); //���ݳ���
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
        g_disp.DispLog('���ڽ���������');
      end;
  end;

  TButton(Sender).Enabled := True;
end;

end.
