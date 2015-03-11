unit U_ParamChk;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_ParamReadWrite, StdCtrls, Buttons, U_Protocol, U_MyFunction;

type
  TF_ParamChk = class(TF_ParamReadWrite)
    chk_voltage: TCheckBox;
    edt_voltage_r: TEdit;
    edt_voltage_w: TEdit;
    btn_read_param: TBitBtn;
    btn_write_param: TBitBtn;
    chk1: TCheckBox;
    procedure btn_write_paramClick(Sender: TObject);
    procedure btn_read_paramClick(Sender: TObject);
    procedure chk1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_ParamChk: TF_ParamChk;

implementation

uses U_Main;

{$R *.dfm}

procedure TF_ParamChk.btn_write_paramClick(Sender: TObject);
var chk:TCheckBox;
    i,p:Integer;
    dataUnit:array[0..63]of Byte;
    ur1,ur2:userarray;
    nTmp:Int64;
    fTmp:Extended;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    chk := chk_voltage;
    if chk.Checked then
    begin
        chk.Font.Color := clBlack;

        p := 0;

        PWord(@dataUnit[p])^   := mb_swap(Word(2));  Inc(p, 2);
        dataUnit[p] := 4; Inc(p);

        TryStrToFloat(edt_voltage_w.Text, fTmp);
        fTmp := fTmp*100;
        nTmp := trunc(fTmp);        
        PLongWord(@dataUnit[p])^   := mb_swap_32(nTmp);  Inc(p, 4);

        MakeFrame(MODBUS_EXT_WRITE_REG, MODBUS_CONF_START_ADDR+MODBUS_CONF4_ADDR, @dataUnit[0], p);
        
        if F_Main.SendDataAuto()
          and WaitForResp(chk, MODBUS_EXT_WRITE_REG)
        then
        begin
        end;
    end;
    
    TButton(Sender).Enabled := True;
end;

procedure TF_ParamChk.btn_read_paramClick(Sender: TObject);
var chk:TCheckBox;
    p:PByte;
    dataUnit:array[0..63]of Byte;
    strTmp:string;
    i, nCount:Integer;
    nTmp:Int64;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    chk := chk_voltage;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        edt_voltage_r.Text := '';
        
        MakeFrame(MODBUS_EXT_READ_REG, MODBUS_CONF_START_ADDR+MODBUS_CONF4_ADDR, 2);
        if F_Main.SendDataAuto()
          and WaitForResp(chk, MODBUS_EXT_READ_REG)
        then
        begin
            p := O_ProRx.GetUserData();
            Inc(p, 1);

            //edt_voltage_r.Text := Format('%d', [mb_swap_32(PLongWord(p)^)]); Inc(p, 4);
            edt_voltage_r.Text := Format('%f', [1.0*mb_swap_32(PLongWord(p)^)/100]); Inc(p, 4);
        end;
    end;
    
    TButton(Sender).Enabled := True;
end;

procedure TF_ParamChk.chk1Click(Sender: TObject);
begin
    MakeCheck(TCheckBox(Sender).Parent, TCheckBox(Sender).Checked);
end;

end.
