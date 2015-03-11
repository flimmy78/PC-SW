unit U_AddMdyMeter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, U_MyFunction;

type
  TF_AddMdyMeter = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lbl11: TLabel;
    lbl12: TLabel;
    btn_ok: TBitBtn;
    btn_cancel: TBitBtn;
    edt_meterSn: TEdit;
    edt_meterAddr: TEdit;
    cbb_speed: TComboBox;
    cbb_port: TComboBox;
    cbb_protocol: TComboBox;
    edt_pwd: TEdit;
    cbb_tariff: TComboBox;
    cbb_int: TComboBox;
    cbb_dec: TComboBox;
    edt_coll: TEdit;
    cbb_largeClass: TComboBox;
    cbb_smallClass: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
      m_editFlag:Integer;
  end;

var
  F_AddMdyMeter: TF_AddMdyMeter;

implementation

{$R *.dfm}

uses U_MeterFile;

procedure TF_AddMdyMeter.FormCreate(Sender: TObject);
begin
    cbb_speed.Items.AddObject('默认', TObject(0));
    cbb_speed.Items.AddObject('600', TObject(1));
    cbb_speed.Items.AddObject('1200', TObject(2));
    cbb_speed.Items.AddObject('2400', TObject(3));
    cbb_speed.Items.AddObject('4800', TObject(4));
    cbb_speed.Items.AddObject('7200', TObject(5));
    cbb_speed.Items.AddObject('9600', TObject(6));
    cbb_speed.Items.AddObject('19200', TObject(7));

    cbb_port.Items.AddObject('交采', TObject(1));
    cbb_port.Items.AddObject('485', TObject(2));
    cbb_port.Items.AddObject('载波', TObject(31));

    cbb_protocol.Items.AddObject('DL/T 645-1997', TObject(1));
    cbb_protocol.Items.AddObject('DL/T 645-2007', TObject(30));
    cbb_protocol.Items.AddObject('交流采样装置通信协议', TObject(2));
    cbb_protocol.Items.AddObject('串行接口连接窄带低压载波通信模块', TObject(31));
    
    cbb_tariff.Items.AddObject('单费率', TObject(1));
    cbb_tariff.Items.AddObject('二费率', TObject(2));
    cbb_tariff.Items.AddObject('三费率', TObject(3));
    cbb_tariff.Items.AddObject('四费率', TObject(4));

    cbb_int.Items.AddObject('4位', TObject(0));
    cbb_int.Items.AddObject('5位', TObject(1));
    cbb_int.Items.AddObject('6位', TObject(2));
    cbb_int.Items.AddObject('7位', TObject(3));

    cbb_dec.Items.AddObject('1位', TObject(0));
    cbb_dec.Items.AddObject('2位', TObject(1));
    cbb_dec.Items.AddObject('3位', TObject(2));
    cbb_dec.Items.AddObject('4位', TObject(3));

    cbb_largeClass.Items.AddObject('默认',                      TObject(0));
    cbb_largeClass.Items.AddObject('大型专变用户（A类）',       TObject(1));
    cbb_largeClass.Items.AddObject('中小型专变用户（B类）',     TObject(2));
    cbb_largeClass.Items.AddObject('三相一般工商业用户（C类）', TObject(3));
    cbb_largeClass.Items.AddObject('单相一般工商业用户（D类）', TObject(4));
    cbb_largeClass.Items.AddObject('居民用户（E类）',           TObject(5));
    cbb_largeClass.Items.AddObject('公用配变考核计量点（F类）', TObject(6));

    cbb_smallClass.Items.AddObject('默认',                TObject(0));
    cbb_smallClass.Items.AddObject('单相智能电能表用户',  TObject(1));
    cbb_smallClass.Items.AddObject('三相智能电能表用户',  TObject(2));
end;

procedure TF_AddMdyMeter.btn_cancelClick(Sender: TObject);
begin
    Close;
end;

end.
