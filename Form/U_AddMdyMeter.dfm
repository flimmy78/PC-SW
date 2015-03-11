object F_AddMdyMeter: TF_AddMdyMeter
  Left = 440
  Top = 166
  BorderStyle = bsDialog
  Caption = #20462#25913#26723#26696
  ClientHeight = 457
  ClientWidth = 412
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object lbl1: TLabel
    Left = 100
    Top = 32
    Width = 48
    Height = 12
    Caption = #34920#24207#21495#65306
  end
  object lbl2: TLabel
    Left = 100
    Top = 61
    Width = 36
    Height = 12
    Caption = #34920#21495#65306
  end
  object lbl3: TLabel
    Left = 100
    Top = 91
    Width = 36
    Height = 12
    Caption = #36895#29575#65306
  end
  object lbl4: TLabel
    Left = 100
    Top = 121
    Width = 36
    Height = 12
    Caption = #31471#21475#65306
  end
  object lbl5: TLabel
    Left = 100
    Top = 151
    Width = 36
    Height = 12
    Caption = #21327#35758#65306
  end
  object lbl6: TLabel
    Left = 100
    Top = 181
    Width = 36
    Height = 12
    Caption = #23494#30721#65306
  end
  object lbl7: TLabel
    Left = 100
    Top = 210
    Width = 36
    Height = 12
    Caption = #36153#29575#65306
  end
  object lbl8: TLabel
    Left = 100
    Top = 240
    Width = 36
    Height = 12
    Caption = #25972#25968#65306
  end
  object lbl9: TLabel
    Left = 100
    Top = 270
    Width = 36
    Height = 12
    Caption = #23567#25968#65306
  end
  object lbl10: TLabel
    Left = 100
    Top = 300
    Width = 48
    Height = 12
    Caption = #37319#38598#22120#65306
  end
  object lbl11: TLabel
    Left = 100
    Top = 330
    Width = 36
    Height = 12
    Caption = #22823#31867#65306
  end
  object lbl12: TLabel
    Left = 100
    Top = 360
    Width = 36
    Height = 12
    Caption = #23567#31867#65306
  end
  object btn_ok: TBitBtn
    Left = 113
    Top = 403
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 0
  end
  object btn_cancel: TBitBtn
    Left = 217
    Top = 403
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btn_cancelClick
  end
  object edt_meterSn: TEdit
    Left = 156
    Top = 27
    Width = 145
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 2
  end
  object edt_meterAddr: TEdit
    Left = 156
    Top = 56
    Width = 145
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    MaxLength = 12
    TabOrder = 3
    Text = 'edt_meterAddr'
  end
  object cbb_speed: TComboBox
    Left = 156
    Top = 86
    Width = 145
    Height = 20
    Style = csDropDownList
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 12
    TabOrder = 4
  end
  object cbb_port: TComboBox
    Left = 156
    Top = 116
    Width = 145
    Height = 20
    Style = csDropDownList
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 12
    TabOrder = 5
  end
  object cbb_protocol: TComboBox
    Left = 156
    Top = 146
    Width = 145
    Height = 20
    Style = csDropDownList
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 12
    TabOrder = 6
  end
  object edt_pwd: TEdit
    Left = 156
    Top = 176
    Width = 145
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 7
    Text = 'edt_pwd'
  end
  object cbb_tariff: TComboBox
    Left = 156
    Top = 205
    Width = 145
    Height = 20
    Style = csDropDownList
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 12
    TabOrder = 8
  end
  object cbb_int: TComboBox
    Left = 156
    Top = 235
    Width = 145
    Height = 20
    Style = csDropDownList
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 12
    TabOrder = 9
  end
  object cbb_dec: TComboBox
    Left = 156
    Top = 265
    Width = 145
    Height = 20
    Style = csDropDownList
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 12
    TabOrder = 10
  end
  object edt_coll: TEdit
    Left = 156
    Top = 295
    Width = 145
    Height = 20
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    MaxLength = 12
    TabOrder = 11
    Text = 'edt_coll'
  end
  object cbb_largeClass: TComboBox
    Left = 156
    Top = 325
    Width = 145
    Height = 20
    Style = csDropDownList
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 12
    TabOrder = 12
  end
  object cbb_smallClass: TComboBox
    Left = 156
    Top = 355
    Width = 145
    Height = 20
    Style = csDropDownList
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 12
    TabOrder = 13
  end
end
