unit U_Temp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, U_Multi, U_Disp, U_Protocol, U_MyFunction,
  ExtCtrls, Spin;

type
  TF_Temp = class(TForm)
    scrlbx0: TScrollBox;
    scrlbx1: TGroupBox;
    btn_write_param: TButton;
    scrlbx2: TGroupBox;
    btn_read_param: TBitBtn;
    scrlbx3: TGroupBox;
    chk_power_up_write: TCheckBox;
    chk_power_low_write: TCheckBox;
    chk_fan_up_write: TCheckBox;
    cbb_fan_up_write: TComboBox;
    chk_fan_low_write: TCheckBox;
    cbb_fan_low_write: TComboBox;
    chk_all_write: TCheckBox;
    edt_power_up_write: TEdit;
    edt_power_low_write: TEdit;
    chk_power_up_read: TCheckBox;
    chk_power_low_read: TCheckBox;
    chk_fan_up_read: TCheckBox;
    chk_fan_low_read: TCheckBox;
    chk_all_read: TCheckBox;
    edt_power_up_read: TEdit;
    edt_power_low_read: TEdit;
    edt_fan_up_read: TEdit;
    edt_fan_low_read: TEdit;
    chk_power_factor_read: TCheckBox;
    edt_power_factor_read: TEdit;
    chk_power_factor_write: TCheckBox;
    edt_power_factor_write: TEdit;
    chk_fan_limit_write: TCheckBox;
    cbb_fan_limit_write: TComboBox;
    chk_fan_limit_read: TCheckBox;
    edt_fan_limit_read: TEdit;
    procedure btn_read_paramClick(Sender: TObject);
    procedure btn_write_paramClick(Sender: TObject);
    procedure edt_ParamInput(Sender: TObject; var Key: Char);
    procedure chk_all_readClick(Sender: TObject);
    procedure chk_all_writeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Temp: TF_Temp;

implementation

uses U_Main;

{$R *.dfm}


procedure TF_Temp.btn_read_paramClick(Sender: TObject);
var
  len, i, temp, data:Integer;
  p:PByte;
  strTmp:String;
  tmp_buf:array[0..24] of Byte;
begin

  F_Temp.btn_read_param.Enabled := FALSE;

  // --------------------------------------------------------------------------

  { ����ѹ���� }
  if F_Temp.chk_power_up_read.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $07; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $01; //������
    tmp_buf[6] := $00; //����
    tmp_buf[7] := $24;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    temp := 0;
    for i:=0 to 9 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[10] := temp and $ff; //CRC
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := $16; //β

    CommMakeFrame2(@tmp_buf, 13);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('����ѹ����');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;
        
        F_Temp.edt_power_up_read.Clear; //����ı���
        if tmp_buf[5] = $81 then //�������ɹ�
        begin
          data := tmp_buf[10] or (tmp_buf[11] shl 8) or (tmp_buf[12] shl 16) or (tmp_buf[13] shl 24);
          strTmp := inttostr(data);
          F_Temp.edt_power_up_read.Text := strTmp;
        end
        else
        begin
          g_disp.DispLog('����ѹ����ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;

  // --------------------------------------------------------------------------

  { ����ѹ���� }
  if F_Temp.chk_power_low_read.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $07; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $01; //������
    tmp_buf[6] := $01; //����
    tmp_buf[7] := $24;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    temp := 0;
    for i:=0 to 9 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[10] := temp and $ff; //CRC
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := $16; //β

    CommMakeFrame2(@tmp_buf, 13);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('����ѹ����');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;
        
        F_Temp.edt_power_low_read.Clear; //����ı���
        if tmp_buf[5] = $81 then //�������ɹ�
        begin
          data := tmp_buf[10] or (tmp_buf[11] shl 8) or (tmp_buf[12] shl 16) or (tmp_buf[13] shl 24);
          strTmp := inttostr(data);
          F_Temp.edt_power_low_read.Text := strTmp;
        end
        else
        begin
          g_disp.DispLog('����ѹ����ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;

  // --------------------------------------------------------------------------

  { ���¶�(����)���� }
  if F_Temp.chk_fan_up_read.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $07; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $01; //������
    tmp_buf[6] := $00; //����
    tmp_buf[7] := $28;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    temp := 0;
    for i:=0 to 9 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[10] := temp and $ff; //CRC
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := $16; //β

    CommMakeFrame2(@tmp_buf, 13);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('���¶�(����)����');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;
        
        F_Temp.edt_fan_up_read.Clear; //����ı���
        if tmp_buf[5] = $81 then //�������ɹ�
        begin
          data := tmp_buf[10] or (tmp_buf[11] shl 8) or (tmp_buf[12] shl 16) or (tmp_buf[13] shl 24);
          strTmp := inttostr(data);
          F_Temp.edt_fan_up_read.Text := strTmp;
        end
        else
        begin
          g_disp.DispLog('���¶�(����)����ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;

  // --------------------------------------------------------------------------

  { ���¶�(����)���� }
  if F_Temp.chk_fan_low_read.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $07; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $01; //������
    tmp_buf[6] := $01; //����
    tmp_buf[7] := $28;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    temp := 0;
    for i:=0 to 9 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[10] := temp and $ff; //CRC
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := $16; //β

    CommMakeFrame2(@tmp_buf, 13);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('���¶�(����)����');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;
        
        F_Temp.edt_fan_low_read.Clear; //����ı���
        if tmp_buf[5] = $81 then //�������ɹ�
        begin
          data := tmp_buf[10] or (tmp_buf[11] shl 8) or (tmp_buf[12] shl 16) or (tmp_buf[13] shl 24);
          strTmp := inttostr(data);
          F_Temp.edt_fan_low_read.Text := strTmp;
        end
        else
        begin
          g_disp.DispLog('���¶�(����)����ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;

  // --------------------------------------------------------------------------

  { ���¶�(����)���� }
  if F_Temp.chk_fan_limit_read.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $07; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $01; //������
    tmp_buf[6] := $02; //����
    tmp_buf[7] := $28;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    temp := 0;
    for i:=0 to 9 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[10] := temp and $ff; //CRC
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := $16; //β

    CommMakeFrame2(@tmp_buf, 13);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('���¶�(����)����');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;
        
        F_Temp.edt_fan_limit_read.Clear; //����ı���
        if tmp_buf[5] = $81 then //�������ɹ�
        begin
          data := tmp_buf[10] or (tmp_buf[11] shl 8) or (tmp_buf[12] shl 16) or (tmp_buf[13] shl 24);
          strTmp := inttostr(data);
          F_Temp.edt_fan_limit_read.Text := strTmp;
        end
        else
        begin
          g_disp.DispLog('���¶�(����)����ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;  

  // --------------------------------------------------------------------------

  { ����Դ��ѹУ������ }
  if F_Temp.chk_power_factor_read.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $07; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $01; //������
    tmp_buf[6] := $02; //����
    tmp_buf[7] := $24;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    temp := 0;
    for i:=0 to 9 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[10] := temp and $ff; //CRC
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := $16; //β

    CommMakeFrame2(@tmp_buf, 13);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('����Դ��ѹУ������');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;
        
        F_Temp.edt_power_factor_read.Clear; //����ı���
        if tmp_buf[5] = $81 then //�������ɹ�
        begin
          data := tmp_buf[10] or (tmp_buf[11] shl 8) or (tmp_buf[12] shl 16) or (tmp_buf[13] shl 24);
          strTmp := inttostr(data);
          F_Temp.edt_power_factor_read.Text := strTmp;
        end
        else
        begin
          g_disp.DispLog('����Դ��ѹУ������ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;

  // --------------------------------------------------------------------------

  F_Temp.btn_read_param.Enabled := TRUE;

end;

procedure TF_Temp.btn_write_paramClick(Sender: TObject);
var
  p:PByte;
  i, temp, len:Integer;
  tmp_buf:array[0..24] of Byte;
begin

  F_Temp.btn_write_param.Enabled := FALSE;

  // --------------------------------------------------------------------------

  { д��ѹ���� }
  if F_Temp.chk_power_up_write.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $0B; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $04; //������
    tmp_buf[6] := $00; //����
    tmp_buf[7] := $24;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    if edt_power_up_write.Text = '' then
    begin
      g_disp.DispLog('����Ƿ�');
      F_Temp.btn_write_param.Enabled := TRUE;
      Abort(); //��ֹ���������
    end;

    temp := strtoint(edt_power_up_write.Text); //����

    tmp_buf[10] := temp and $ff;
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := (temp shr 16) and $ff;
    tmp_buf[13] := (temp shr 24) and $ff;

    temp := 0;
    for i:=0 to 12 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[14] := temp and $ff; //CRC
    tmp_buf[15] := (temp shr 8) and $ff;
    tmp_buf[16] := $16; //β

    CommMakeFrame2(@tmp_buf, 17);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('д��ѹ����');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;

        if tmp_buf[5] = $84 then //д�����ɹ�
        begin
          g_disp.DispLog('д��ѹ���޳ɹ�');
        end
        else
        begin
          g_disp.DispLog('д��ѹ����ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;

  // --------------------------------------------------------------------------

  { д��ѹ���� }
  if F_Temp.chk_power_low_write.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $0B; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $04; //������
    tmp_buf[6] := $01; //����
    tmp_buf[7] := $24;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    if edt_power_low_write.Text = '' then
    begin
      g_disp.DispLog('����Ƿ�');
      F_Temp.btn_write_param.Enabled := TRUE;
      Abort(); //��ֹ���������
    end;    

    temp := strtoint(edt_power_low_write.Text); //����

    tmp_buf[10] := temp and $ff;
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := (temp shr 16) and $ff;
    tmp_buf[13] := (temp shr 24) and $ff;

    temp := 0;
    for i:=0 to 12 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[14] := temp and $ff; //CRC
    tmp_buf[15] := (temp shr 8) and $ff;
    tmp_buf[16] := $16; //β

    CommMakeFrame2(@tmp_buf, 17);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('д��ѹ����');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;

        if tmp_buf[5] = $84 then //д�����ɹ�
        begin
          g_disp.DispLog('д��ѹ���޳ɹ�');
        end
        else
        begin
          g_disp.DispLog('д��ѹ����ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;

  // --------------------------------------------------------------------------

  { д�¶�(����)���� }
  if F_Temp.chk_fan_up_write.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $0B; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $04; //������
    tmp_buf[6] := $00; //����
    tmp_buf[7] := $28;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    if cbb_fan_up_write.Text = '' then
    begin
      g_disp.DispLog('����Ƿ�');
      F_Temp.btn_write_param.Enabled := TRUE;
      Abort(); //��ֹ���������
    end;    

    temp := strtoint(cbb_fan_up_write.Text); //����

    tmp_buf[10] := temp and $ff;
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := (temp shr 16) and $ff;
    tmp_buf[13] := (temp shr 24) and $ff;

    temp := 0;
    for i:=0 to 12 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[14] := temp and $ff; //CRC
    tmp_buf[15] := (temp shr 8) and $ff;
    tmp_buf[16] := $16; //β

    CommMakeFrame2(@tmp_buf, 17);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('д�¶�(����)����');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;

        if tmp_buf[5] = $84 then //д�����ɹ�
        begin
          g_disp.DispLog('д�¶�(����)���޳ɹ�');
        end
        else
        begin
          g_disp.DispLog('д�¶�(����)����ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;

  // --------------------------------------------------------------------------

  { д�¶�(����)���� }
  if F_Temp.chk_fan_low_write.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $0B; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $04; //������
    tmp_buf[6] := $01; //����
    tmp_buf[7] := $28;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    if cbb_fan_low_write.Text = '' then
    begin
      g_disp.DispLog('����Ƿ�');
      F_Temp.btn_write_param.Enabled := TRUE;
      Abort(); //��ֹ���������
    end;      

    temp := strtoint(cbb_fan_low_write.Text); //����

    tmp_buf[10] := temp and $ff;
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := (temp shr 16) and $ff;
    tmp_buf[13] := (temp shr 24) and $ff;

    temp := 0;
    for i:=0 to 12 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[14] := temp and $ff; //CRC
    tmp_buf[15] := (temp shr 8) and $ff;
    tmp_buf[16] := $16; //β

    CommMakeFrame2(@tmp_buf, 17);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('д�¶�(����)����');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;

        if tmp_buf[5] = $84 then //д�����ɹ�
        begin
          g_disp.DispLog('д�¶�(����)���޳ɹ�');
        end
        else
        begin
          g_disp.DispLog('д�¶�(����)����ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;

  // --------------------------------------------------------------------------

  { д�¶�(����)���� }
  if F_Temp.chk_fan_limit_write.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $0B; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $04; //������
    tmp_buf[6] := $02; //����
    tmp_buf[7] := $28;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    if cbb_fan_limit_write.Text = '' then
    begin
      g_disp.DispLog('����Ƿ�');
      F_Temp.btn_write_param.Enabled := TRUE;
      Abort(); //��ֹ���������
    end;      

    temp := strtoint(cbb_fan_limit_write.Text); //����

    tmp_buf[10] := temp and $ff;
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := (temp shr 16) and $ff;
    tmp_buf[13] := (temp shr 24) and $ff;

    temp := 0;
    for i:=0 to 12 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[14] := temp and $ff; //CRC
    tmp_buf[15] := (temp shr 8) and $ff;
    tmp_buf[16] := $16; //β

    CommMakeFrame2(@tmp_buf, 17);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('д�¶�(����)����');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;

        if tmp_buf[5] = $84 then //д�����ɹ�
        begin
          g_disp.DispLog('д�¶�(����)���޳ɹ�');
        end
        else
        begin
          g_disp.DispLog('д�¶�(����)����ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;

  // --------------------------------------------------------------------------

  { д��Դ��ѹУ������ }
  if F_Temp.chk_power_factor_write.Checked then
  begin
    tmp_buf[0] := $68; //ͷ
    tmp_buf[1] := $0B; //����
    tmp_buf[2] := $00;
    tmp_buf[3] := $00; //��ַ
    tmp_buf[4] := $00;
    tmp_buf[5] := $04; //������
    tmp_buf[6] := $02; //����
    tmp_buf[7] := $24;
    tmp_buf[8] := $00;
    tmp_buf[9] := $00;

    if edt_power_factor_write.Text = '' then
    begin
      g_disp.DispLog('����Ƿ�');
      F_Temp.btn_write_param.Enabled := TRUE;
      Abort(); //��ֹ���������
    end;

    temp := strtoint(edt_power_factor_write.Text); //����

    tmp_buf[10] := temp and $ff;
    tmp_buf[11] := (temp shr 8) and $ff;
    tmp_buf[12] := (temp shr 16) and $ff;
    tmp_buf[13] := (temp shr 24) and $ff;

    temp := 0;
    for i:=0 to 12 do
    begin
      temp := temp + tmp_buf[i];
    end;

    tmp_buf[14] := temp and $ff; //CRC
    tmp_buf[15] := (temp shr 8) and $ff;
    tmp_buf[16] := $16; //β

    CommMakeFrame2(@tmp_buf, 17);
    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      g_disp.DispLog('д��Դ��ѹУ������');
      if CommRecved = True then
      begin
        CommRecved := False;
        p := GetCommRecvBufAddr();
        len := GetCommRecvDataLen();

        for i:=0 to len do
        begin
          tmp_buf[i] := p^;
          Inc(p);
        end;

        if tmp_buf[5] = $84 then //д�����ɹ�
        begin
          g_disp.DispLog('д��Դ��ѹУ�����ӳɹ�');
        end
        else
        begin
          g_disp.DispLog('д��Դ��ѹУ������ʧ��');
        end;
      end
      else
      begin
        g_disp.DispLog('���ڽ���������');
      end;
    end;
  end;

  // --------------------------------------------------------------------------

  F_Temp.btn_write_param.Enabled := TRUE;

end;

procedure TF_Temp.edt_ParamInput(Sender: TObject; var Key: Char);
begin
  if not(key in ['0'..'9', #8]) then //0 - 9, BackSpace
  begin
    key := #0; //�����ÿ�
    Beep(); //����ϵͳ����
  end;
end;

procedure TF_Temp.chk_all_readClick(Sender: TObject);
begin
  if F_Temp.chk_all_read.Checked then
  begin
    F_Temp.chk_power_up_read.Checked := TRUE;
    F_Temp.chk_power_low_read.Checked := TRUE;
    F_Temp.chk_fan_up_read.Checked := TRUE;
    F_Temp.chk_fan_low_read.Checked := TRUE;
    F_Temp.chk_fan_limit_read.Checked := TRUE;
    F_Temp.chk_power_factor_read.Checked := TRUE;
  end
  else
  begin
    F_Temp.chk_power_up_read.Checked := FALSE;
    F_Temp.chk_power_low_read.Checked := FALSE;
    F_Temp.chk_fan_up_read.Checked := FALSE;
    F_Temp.chk_fan_low_read.Checked := FALSE;
    F_Temp.chk_fan_limit_read.Checked := FALSE;
    F_Temp.chk_power_factor_read.Checked := FALSE;
  end;
end;

procedure TF_Temp.chk_all_writeClick(Sender: TObject);
begin
  if F_Temp.chk_all_write.Checked then
  begin
    F_Temp.chk_power_up_write.Checked := TRUE;
    F_Temp.chk_power_low_write.Checked := TRUE;
    F_Temp.chk_fan_up_write.Checked := TRUE;
    F_Temp.chk_fan_low_write.Checked := TRUE;
    F_Temp.chk_fan_limit_write.Checked := TRUE;
    F_Temp.chk_power_factor_write.Checked := TRUE;
  end
  else
  begin
    F_Temp.chk_power_up_write.Checked := FALSE;
    F_Temp.chk_power_low_write.Checked := FALSE;
    F_Temp.chk_fan_up_write.Checked := FALSE;
    F_Temp.chk_fan_low_write.Checked := FALSE;
    F_Temp.chk_fan_limit_write.Checked := FALSE;
    F_Temp.chk_power_factor_write.Checked := FALSE;
  end;
end;

end.
