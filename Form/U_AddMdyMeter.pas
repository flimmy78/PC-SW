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
    cbb_speed.Items.AddObject('Ĭ��', TObject(0));
    cbb_speed.Items.AddObject('600', TObject(1));
    cbb_speed.Items.AddObject('1200', TObject(2));
    cbb_speed.Items.AddObject('2400', TObject(3));
    cbb_speed.Items.AddObject('4800', TObject(4));
    cbb_speed.Items.AddObject('7200', TObject(5));
    cbb_speed.Items.AddObject('9600', TObject(6));
    cbb_speed.Items.AddObject('19200', TObject(7));

    cbb_port.Items.AddObject('����', TObject(1));
    cbb_port.Items.AddObject('485', TObject(2));
    cbb_port.Items.AddObject('�ز�', TObject(31));

    cbb_protocol.Items.AddObject('DL/T 645-1997', TObject(1));
    cbb_protocol.Items.AddObject('DL/T 645-2007', TObject(30));
    cbb_protocol.Items.AddObject('��������װ��ͨ��Э��', TObject(2));
    cbb_protocol.Items.AddObject('���нӿ�����խ����ѹ�ز�ͨ��ģ��', TObject(31));
    
    cbb_tariff.Items.AddObject('������', TObject(1));
    cbb_tariff.Items.AddObject('������', TObject(2));
    cbb_tariff.Items.AddObject('������', TObject(3));
    cbb_tariff.Items.AddObject('�ķ���', TObject(4));

    cbb_int.Items.AddObject('4λ', TObject(0));
    cbb_int.Items.AddObject('5λ', TObject(1));
    cbb_int.Items.AddObject('6λ', TObject(2));
    cbb_int.Items.AddObject('7λ', TObject(3));

    cbb_dec.Items.AddObject('1λ', TObject(0));
    cbb_dec.Items.AddObject('2λ', TObject(1));
    cbb_dec.Items.AddObject('3λ', TObject(2));
    cbb_dec.Items.AddObject('4λ', TObject(3));

    cbb_largeClass.Items.AddObject('Ĭ��',                      TObject(0));
    cbb_largeClass.Items.AddObject('����ר���û���A�ࣩ',       TObject(1));
    cbb_largeClass.Items.AddObject('��С��ר���û���B�ࣩ',     TObject(2));
    cbb_largeClass.Items.AddObject('����һ�㹤��ҵ�û���C�ࣩ', TObject(3));
    cbb_largeClass.Items.AddObject('����һ�㹤��ҵ�û���D�ࣩ', TObject(4));
    cbb_largeClass.Items.AddObject('�����û���E�ࣩ',           TObject(5));
    cbb_largeClass.Items.AddObject('������俼�˼����㣨F�ࣩ', TObject(6));

    cbb_smallClass.Items.AddObject('Ĭ��',                TObject(0));
    cbb_smallClass.Items.AddObject('�������ܵ��ܱ��û�',  TObject(1));
    cbb_smallClass.Items.AddObject('�������ܵ��ܱ��û�',  TObject(2));
end;

procedure TF_AddMdyMeter.btn_cancelClick(Sender: TObject);
begin
    Close;
end;

end.
