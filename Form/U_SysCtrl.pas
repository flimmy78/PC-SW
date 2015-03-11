unit U_SysCtrl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_ParamReadWrite, StdCtrls, Buttons, U_Protocol, U_MyFunction;

type
  TF_SysCtrl = class(TF_ParamReadWrite)
    grp1: TGroupBox;
    btn_switch_on: TBitBtn;
    btn_switch_off: TBitBtn;
    btn_switch_on_off: TBitBtn;
    btn_switch_off_on: TBitBtn;
    grp2: TGroupBox;
    btn_sys_reset: TBitBtn;
    procedure btn_switch_onClick(Sender: TObject);
    procedure btn_switch_offClick(Sender: TObject);
    procedure btn_switch_on_offClick(Sender: TObject);
    procedure btn_switch_off_onClick(Sender: TObject);
    procedure btn_sys_resetClick(Sender: TObject);
  private
    { Private declarations }
    function  SwitchCtrl(Sender: TObject; ctrlType:Word):Boolean;
  public
    { Public declarations }
  end;

var
  F_SysCtrl: TF_SysCtrl;

implementation

uses U_Main;

{$R *.dfm}

function  TF_SysCtrl.SwitchCtrl(Sender: TObject; ctrlType:Word):Boolean;
var i,p:Integer;
    dataUnit:array[0..63]of Byte;
    conTime:TDateTime;
    nTmp:Int64;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    p := 0;

    Pword(@dataUnit[p])^ := mb_swap(ctrlType); Inc(p, 2);

    MakeFrame(MODBUS_CTRL_OUTPUT, MODBUS_CTRL_START_ADDR+12, @dataUnit[0], p);
    if F_Main.SendDataAuto()
      and WaitForResp(Sender, MODBUS_CTRL_OUTPUT)
    then
    begin
    end;
        
    TButton(Sender).Enabled := True;
end;

procedure TF_SysCtrl.btn_switch_onClick(Sender: TObject);
begin
    SwitchCtrl(Sender, $ff00);
end;

procedure TF_SysCtrl.btn_switch_offClick(Sender: TObject);
begin
    SwitchCtrl(Sender, $0000);
end;

procedure TF_SysCtrl.btn_switch_on_offClick(Sender: TObject);
begin
    SwitchCtrl(Sender, $5500);
end;

procedure TF_SysCtrl.btn_switch_off_onClick(Sender: TObject);
begin
    SwitchCtrl(Sender, $aa00);
end;

procedure TF_SysCtrl.btn_sys_resetClick(Sender: TObject);
var i,p:Integer;
    dataUnit:array[0..63]of Byte;
    conTime:TDateTime;
    nTmp:Int64;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    p := 0;

    Pword(@dataUnit[p])^ := mb_swap($ff00); Inc(p, 2);

    MakeFrame(MODBUS_CTRL_OUTPUT, MODBUS_CTRL_START_ADDR+10, @dataUnit[0], p);
    if F_Main.SendDataAuto()
      and WaitForResp(Sender, MODBUS_CTRL_OUTPUT)
    then
    begin
    end;
        
    TButton(Sender).Enabled := True;
end;

end.
