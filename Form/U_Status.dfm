inherited F_Status: TF_Status
  Top = 266
  Caption = #29366#24577#35835#21462
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited scrlbx1: TScrollBox
    object lbl1: TLabel
      Left = 120
      Top = 32
      Width = 36
      Height = 12
      Caption = 'EEPROM'
    end
    object lbl2: TLabel
      Left = 120
      Top = 64
      Width = 108
      Height = 12
      Caption = #30005#23481#32487#30005#22120#25237#20999#21160#20316
    end
    object lbl3: TLabel
      Left = 120
      Top = 96
      Width = 60
      Height = 12
      Caption = #20877#21551#21160#26816#26597
    end
    object lbl4: TLabel
      Left = 120
      Top = 128
      Width = 60
      Height = 12
      Caption = #25509#35302#22120#29366#24577
    end
    object lbl5: TLabel
      Left = 120
      Top = 160
      Width = 60
      Height = 12
      Caption = #32487#30005#22120#29366#24577
    end
    object lbl6: TLabel
      Left = 120
      Top = 192
      Width = 24
      Height = 12
      Caption = #30005#21387
    end
    object lbl7: TLabel
      Left = 120
      Top = 224
      Width = 72
      Height = 12
      Caption = #24653#30005#20445#25252#27425#25968
    end
    object lbl8: TLabel
      Left = 120
      Top = 256
      Width = 84
      Height = 12
      Caption = #20877#21551#21160#20445#25252#27425#25968
    end
    object chk1: TCheckBox
      Left = 20
      Top = 284
      Width = 101
      Height = 16
      Caption = #20840#36873
      TabOrder = 0
      OnClick = chk1Click
    end
    object btn_read_status: TBitBtn
      Left = 229
      Top = 320
      Width = 75
      Height = 25
      Caption = #35835#29366#24577
      TabOrder = 1
      OnClick = btn_read_statusClick
    end
    object chk_running_status: TCheckBox
      Left = 20
      Top = 32
      Width = 93
      Height = 17
      Caption = #36816#34892#29366#24577#65306
      TabOrder = 2
    end
    object edt_voltage: TEdit
      Left = 253
      Top = 186
      Width = 84
      Height = 22
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ImeName = #26368#24378#20116#31508#36755#20837#27861
      ParentFont = False
      TabOrder = 3
    end
    object cbb_eeprom: TComboBox
      Left = 253
      Top = 26
      Width = 84
      Height = 20
      Style = csDropDownList
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      TabOrder = 4
      Items.Strings = (
        #27491#24120
        #20986#38169)
    end
    object cbb_drop_action: TComboBox
      Left = 253
      Top = 58
      Width = 84
      Height = 20
      Style = csDropDownList
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      TabOrder = 5
      Items.Strings = (
        #26080
        #26377)
    end
    object cbb_POWER_CHECK_FLAG: TComboBox
      Left = 253
      Top = 90
      Width = 84
      Height = 20
      Style = csDropDownList
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      TabOrder = 6
      Items.Strings = (
        #20851
        #24320)
    end
    object cbb_RELAY_ON_FLAG: TComboBox
      Left = 253
      Top = 122
      Width = 84
      Height = 20
      Style = csDropDownList
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      TabOrder = 7
      Items.Strings = (
        #20851
        #24320)
    end
    object cbb_JDQ_ON_FLAG: TComboBox
      Left = 253
      Top = 154
      Width = 84
      Height = 20
      Style = csDropDownList
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      TabOrder = 8
      Items.Strings = (
        #20851
        #24320)
    end
    object edt_PowerDropCount: TEdit
      Left = 253
      Top = 218
      Width = 84
      Height = 22
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ImeName = #26368#24378#20116#31508#36755#20837#27861
      ParentFont = False
      TabOrder = 9
    end
    object edt_SelfPowerOnCount: TEdit
      Left = 253
      Top = 250
      Width = 84
      Height = 22
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ImeName = #26368#24378#20116#31508#36755#20837#27861
      ParentFont = False
      TabOrder = 10
    end
  end
end
