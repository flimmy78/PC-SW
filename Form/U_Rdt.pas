unit U_Rdt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, U_Multi, U_Disp, U_Protocol, U_MyFunction,
  ExtCtrls, Spin;

type
    TF_Rdt = class(TForm)
    scrlbx0: TScrollBox;
    scrlbx3: TGroupBox;
    btn_send: TBitBtn;
    btn_clear: TBitBtn;
    memo_send: TMemo;
    chkbx_send: TCheckBox;
    scrlbx2: TGroupBox;
    chkbx_recv_num: TCheckBox;
    chkbx_rssi: TCheckBox;
    chkbx_cfo: TCheckBox;
    chkbx_crc_err: TCheckBox;
    chkbx_send_timeout: TCheckBox;
    chkbx_recv_timeout: TCheckBox;
    chkbx_uart_baud: TCheckBox;
    chkbx_slt_all: TCheckBox;
    chkbx_send_num: TCheckBox;
    btn_sys_rst: TBitBtn;
    btn_read_param: TBitBtn;
    btn_write_param: TBitBtn;
    combobx_uart_baud: TComboBox;
    edt_recv_num: TEdit;
    edt_send_num: TEdit;
    Timer1: TTimer;
    chkbx_auto_send: TCheckBox;
    spinedt_send: TSpinEdit;
    auto_send_cycle: TLabel;
    ms: TLabel;
    edt_tx: TEdit;
    btn_tx_clr: TBitBtn;
    scrlbx1: TGroupBox;
    rb_send: TRadioButton;
    rb_recv: TRadioButton;
    rb_other: TRadioButton;
    btn_confirm: TButton;
    btn_cancel: TButton;
    edt_rssi: TEdit;
    edt_cfo: TEdit;
    edt_crc: TEdit;
    edt_send_timeout: TEdit;
    edt_recv_timeout: TEdit;
    procedure btn_sys_rstClick(Sender: TObject);
    procedure btn_read_paramClick(Sender: TObject);
    procedure chkbx_slt_allClick(Sender: TObject);
    procedure btn_clearClick(Sender: TObject);
    procedure btn_sendClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure chkbx_auto_sendClick(Sender: TObject);
    procedure spinedt_sendChange(Sender: TObject);
    procedure btn_tx_clrClick(Sender: TObject);
    procedure btn_confirmClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure formcreate(Sender: TObject);
  private
    { Private declarations }
    procedure ShowTX;
  public
    { Public declarations }
  end;

procedure TrArrInit();

var
  F_Rdt: TF_Rdt;

implementation

uses U_Main;

Type
   TRecord = record
   chkbx : TCheckBox;
   edt : TEdit;
   off : Integer;
   opt : string;
   cmd : string;
end;

var
  tr_arr:array[0..3] of TRecord;
  TxNum:Integer = 0;

{$R *.dfm}

procedure TF_Rdt.btn_sys_rstClick(Sender: TObject);
var strTmp:string;
begin
    TButton(Sender).Enabled := False;

    strTmp := 'hwcrstXcmdt';
    CommMakeFrame1(strTmp);
    
    if F_Main.SendDataAuto()
        and CommWaitForResp()
    then
    begin
        g_disp.DispLog('复位系统');
        btn_cancel.Click;
        //rb_send.Checked := True;
        rb_other.Checked := True;
        btn_confirm.Click;
        //chkbx_auto_send.Checked := True;
        chkbx_rssi.Checked := True;
        chkbx_cfo.Checked := True;
    end;

    TButton(Sender).Enabled := True;
end;

procedure TF_Rdt.btn_read_paramClick(Sender: TObject);
var chk:TCheckBox;
    p:PByte;
    len,i,j:Integer;
    strTmp:string;
begin
    TButton(Sender).Enabled := False;
    
    for i:=0 to 3 do
    begin
        chk := tr_arr[i].chkbx;
        if chk.Checked then
        begin
            chk.Font.Color := clBlack;
            tr_arr[i].edt.Clear;
            strTmp := tr_arr[i].cmd;
            CommMakeFrame1(strTmp);

            if F_Main.SendDataAuto()
                and CommWaitForResp()
            then
            begin
                g_disp.DispLog(tr_arr[i].opt);
                if CommRecved = True then
                begin
                    CommRecved := False;
                    p := GetCommRecvBufAddr();
                    len := GetCommRecvDataLen();
                    Inc(p, tr_arr[i].off);
                    Dec(len); //减换行
                    Dec(len, tr_arr[i].off); //数据长度
                    strTmp := '';

                    for j:=0 to len do
                    begin
                        strTmp := strTmp + chr(p^);
                        Inc(p);
                    end;

                    SetWindowLong(tr_arr[i].edt.Handle, GWL_STYLE, GetWindowLong(tr_arr[i].edt.Handle, GWL_STYLE) or ES_CENTER{ES_RIGHT});
                    tr_arr[i].edt.Invalidate; //仅限数字

                    tr_arr[i].edt.Text := strTmp;
                end
                else
                begin
                    g_disp.DispLog('串口接收无数据');
                end;
            end;
        end;
    end;
    
    TButton(Sender).Enabled := True;
end;

procedure TF_Rdt.chkbx_slt_allClick(Sender: TObject);
begin
    MakeCheck(TCheckBox(Sender).Parent, TCheckBox(Sender).Checked);
end;

procedure TF_Rdt.btn_clearClick(Sender: TObject);
begin
    memo_send.Clear;
end;

procedure TF_Rdt.btn_sendClick(Sender: TObject);
var strTmp:string;
    len:Integer;
begin
    strTmp := memo_send.Text;
    len := Length(strTmp);

    if len=0 then
    begin
        g_disp.DispLog('串口发送无数据');
    end
    else
    begin
        if chkbx_send.Checked then
        begin
            strTmp := buftohex(pByte(strTmp), len);
        end;

        CommMakeFrame1(strTmp);
        if F_Main.SendDataAuto()
        then
        begin
            Inc(TxNum, len);
            ShowTX;
        end;
    end;
end;

procedure TF_Rdt.Timer1Timer(Sender: TObject);
begin
  if memo_send.Text<>'' then
    btn_send.Click;
end;

procedure TF_Rdt.chkbx_auto_sendClick(Sender: TObject);
begin
  Timer1.Enabled := chkbx_auto_send.Checked;
  spinedt_send.Enabled := not chkbx_auto_send.Checked;
end;

procedure TF_Rdt.spinedt_sendChange(Sender: TObject);
begin
  Timer1.Interval := spinedt_send.Value;
end;

procedure TF_Rdt.ShowTX;
begin
  edt_tx.Text:='Bytes: '+IntTostr(TxNum);
end;

procedure TF_Rdt.btn_tx_clrClick(Sender: TObject);
begin
  TxNum := 0;
  ShowTx;
end;

procedure TF_Rdt.btn_confirmClick(Sender: TObject);
var
  rb : TRadioButton;
  cmd : string;
begin
  rb := rb_send;
  if rb.Checked = True then
  begin
    cmd := 'hw0XXXXcmdt';
    CommMakeFrame1(cmd);

    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      F_Rdt.chkbx_send_num.Checked := True;
      TButton(Sender).Enabled := False;
      g_disp.DispLog('发送模式');
    end;
  end;

  rb := rb_recv;
  if rb.Checked = True then
  begin
    cmd := 'hw1XXXXcmdt';
    CommMakeFrame1(cmd);

    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      F_Rdt.chkbx_recv_num.Checked := True;
      TButton(Sender).Enabled := False;
      g_disp.DispLog('接收模式');
    end;
  end;

  rb := rb_other;
  if rb.Checked = True then
  begin
    cmd := 'hw2XXXXcmdt';
    CommMakeFrame1(cmd);

    if F_Main.SendDataAuto()
      and CommWaitForResp()
    then
    begin
      cmd := 'hw6XXXXcmdt';
      CommMakeFrame1(cmd);

      if F_Main.SendDataAuto()
      and CommWaitForResp()
      then
      begin
      F_Rdt.chkbx_rssi.Checked := True;
      F_Rdt.chkbx_cfo.Checked := True;
      TButton(Sender).Enabled := False;
      g_disp.DispLog('信号强度、频偏测量模式');
      end;
    end;
  end;
end;

procedure TF_Rdt.btn_cancelClick(Sender: TObject);
begin
  CommWaitForResp();
  rb_send.Checked := False;
  rb_recv.Checked := False;
  rb_other.Checked := False;
  btn_confirm.Enabled := True;
  F_Rdt.chkbx_auto_send.Checked := False;
  F_Rdt.chkbx_send_num.Checked := False;
  F_Rdt.chkbx_recv_num.Checked := False;
  F_Rdt.chkbx_rssi.Checked := False;
  F_Rdt.chkbx_cfo.Checked := False;
end;

procedure TrArrInit();
begin
    tr_arr[0].chkbx := F_Rdt.chkbx_send_num;
    tr_arr[0].edt := F_Rdt.edt_send_num;
    tr_arr[0].off := 9;
    tr_arr[0].opt := '读发送包数目';
    tr_arr[0].cmd := 'hr0XXXXcmdt';

    tr_arr[1].chkbx := F_Rdt.chkbx_recv_num;
    tr_arr[1].edt := F_Rdt.edt_recv_num;
    tr_arr[1].off := 9;
    tr_arr[1].opt := '读接收包数目';
    tr_arr[1].cmd := 'hr1XXXXcmdt';

    tr_arr[2].chkbx := F_Rdt.chkbx_rssi;
    tr_arr[2].edt := F_Rdt.edt_rssi;
    tr_arr[2].off := 9;
    tr_arr[2].opt := '读信号强度';
    tr_arr[2].cmd := 'hrcXXXXcmdt';

    tr_arr[3].chkbx := F_Rdt.chkbx_cfo;
    tr_arr[3].edt := F_Rdt.edt_cfo;
    tr_arr[3].off := 8;
    tr_arr[3].opt := '读频偏';
    tr_arr[3].cmd := 'hrdXXXXcmdt';
end;

procedure TF_Rdt.formcreate(Sender: TObject);
begin
  TrArrInit();
end;

end.
