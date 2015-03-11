unit U_Status;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_ParamReadWrite, StdCtrls, Buttons, U_Protocol, U_MyFunction;

type
  TF_Status = class(TF_ParamReadWrite)
    chk1: TCheckBox;
    btn_read_status: TBitBtn;
    chk_running_status: TCheckBox;
    edt_voltage: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    cbb_eeprom: TComboBox;
    cbb_drop_action: TComboBox;
    cbb_POWER_CHECK_FLAG: TComboBox;
    cbb_RELAY_ON_FLAG: TComboBox;
    cbb_JDQ_ON_FLAG: TComboBox;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    edt_PowerDropCount: TEdit;
    edt_SelfPowerOnCount: TEdit;
    procedure btn_read_statusClick(Sender: TObject);
    procedure chk1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Status: TF_Status;

implementation

{$R *.dfm}

uses U_Main;

procedure TF_Status.btn_read_statusClick(Sender: TObject);
var chk:TCheckBox;
    p:PByte;
    dataUnit:array[0..63]of Byte;
    strTmp:string;
    i, nCount:Integer;
    nTmp:Int64;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    //ϵͳ״̬
    chk := chk_running_status;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        
        cbb_eeprom.ItemIndex := -1;
        cbb_drop_action.ItemIndex := -1;
        cbb_POWER_CHECK_FLAG.ItemIndex := -1;
        cbb_RELAY_ON_FLAG.ItemIndex := -1;
        cbb_JDQ_ON_FLAG.ItemIndex := -1;
        edt_voltage.Text := '';
        edt_PowerDropCount.Text := '';
        edt_SelfPowerOnCount.Text := '';

        MakeFrame(MODBUS_EXT_READ_REG, MODBUS_CONF_START_ADDR+MODBUS_CONF1_ADDR, 6);
        //MakeFrame(MODBUS_EXT_READ_REG, MODBUS_CONF1_ADDR, 6);
        
        if F_Main.SendDataAuto()
          and WaitForResp(chk, MODBUS_EXT_READ_REG)
        then
        begin
            p := O_ProRx.GetUserData();
            Inc(p, 1);
            nTmp := mb_swap_32(PLongWord(p)^);  Inc(p, 4);
            cbb_eeprom.ItemIndex            := (nTmp shr 0 and $00000001);
            cbb_drop_action.ItemIndex       := (nTmp shr 2 and $00000001);
            cbb_POWER_CHECK_FLAG.ItemIndex  := (nTmp shr 3 and $00000001);
            cbb_RELAY_ON_FLAG.ItemIndex     := (nTmp shr 4 and $00000001);
            cbb_JDQ_ON_FLAG.ItemIndex       := (nTmp shr 5 and $00000001);

            //edt_voltage.Text := Format('%d', [mb_swap_32(PLongWord(p)^)]); Inc(p, 4);
            edt_voltage.Text := Format('%f', [1.0*mb_swap_32(PLongWord(p)^)/100]); Inc(p, 4);
            
            edt_PowerDropCount.Text := Format('%d', [mb_swap(PLongWord(p)^)]); Inc(p, 2);
            edt_SelfPowerOnCount.Text := Format('%d', [mb_swap(PLongWord(p)^)]); Inc(p, 2);
        end;
    end;

    TButton(Sender).Enabled := True;
end;

procedure TF_Status.chk1Click(Sender: TObject);
begin
    MakeCheck(TCheckBox(Sender).Parent, TCheckBox(Sender).Checked);
end;

end.
