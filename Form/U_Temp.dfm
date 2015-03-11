object F_Temp: TF_Temp
  Left = 219
  Top = 147
  Align = alClient
  BorderStyle = bsNone
  Caption = #28201#25511#26495
  ClientHeight = 462
  ClientWidth = 935
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object scrlbx0: TScrollBox
    Left = 0
    Top = 0
    Width = 935
    Height = 462
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    object scrlbx1: TGroupBox
      Left = 20
      Top = 16
      Width = 397
      Height = 392
      TabOrder = 0
      object btn_write_param: TButton
        Left = 29
        Top = 352
        Width = 75
        Height = 25
        Caption = #20889#21442#25968
        TabOrder = 0
        OnClick = btn_write_paramClick
      end
      object chk_power_up_write: TCheckBox
        Left = 28
        Top = 32
        Width = 93
        Height = 17
        Caption = #30005#21387#19978#38480#65306
        TabOrder = 1
      end
      object chk_power_low_write: TCheckBox
        Left = 28
        Top = 80
        Width = 93
        Height = 17
        Caption = #30005#21387#19979#38480#65306
        TabOrder = 2
      end
      object chk_fan_up_write: TCheckBox
        Left = 28
        Top = 128
        Width = 93
        Height = 17
        Caption = #28201#24230#19978#38480#65306
        TabOrder = 3
      end
      object cbb_fan_up_write: TComboBox
        Left = 229
        Top = 122
        Width = 84
        Height = 21
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 4
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          '32'
          '33'
          '34'
          '35'
          '36'
          '37'
          '38'
          '39'
          '40'
          '41'
          '42'
          '43'
          '44'
          '45'
          '46'
          '47'
          '48'
          '49'
          '50'
          '51'
          '52'
          '53'
          '54'
          '55'
          '56'
          '57'
          '58'
          '59'
          '60'
          '61'
          '62'
          '63'
          '64'
          '65'
          '66'
          '67'
          '68'
          '69'
          '70'
          '71'
          '72'
          '73'
          '74'
          '75'
          '76'
          '77'
          '78'
          '79'
          '80'
          '81'
          '82'
          '83'
          '84'
          '85'
          '86'
          '87'
          '88'
          '89'
          '90'
          '91'
          '92'
          '93'
          '94'
          '95'
          '96'
          '97'
          '98'
          '99'
          '100')
      end
      object chk_fan_low_write: TCheckBox
        Left = 28
        Top = 176
        Width = 93
        Height = 17
        Caption = #28201#24230#19979#38480#65306
        TabOrder = 5
      end
      object cbb_fan_low_write: TComboBox
        Left = 229
        Top = 170
        Width = 84
        Height = 21
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 6
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          '32'
          '33'
          '34'
          '35'
          '36'
          '37'
          '38'
          '39'
          '40'
          '41'
          '42'
          '43'
          '44'
          '45'
          '46'
          '47'
          '48'
          '49'
          '50'
          '51'
          '52'
          '53'
          '54'
          '55'
          '56'
          '57'
          '58'
          '59'
          '60'
          '61'
          '62'
          '63'
          '64'
          '65'
          '66'
          '67'
          '68'
          '69'
          '70'
          '71'
          '72'
          '73'
          '74'
          '75'
          '76'
          '77'
          '78'
          '79'
          '80'
          '81'
          '82'
          '83'
          '84'
          '85'
          '86'
          '87'
          '88'
          '89'
          '90'
          '91'
          '92'
          '93'
          '94'
          '95'
          '96'
          '97'
          '98'
          '99'
          '100')
      end
      object chk_all_write: TCheckBox
        Left = 28
        Top = 316
        Width = 101
        Height = 16
        Caption = #20840#36873
        TabOrder = 7
        OnClick = chk_all_writeClick
      end
      object edt_power_up_write: TEdit
        Left = 229
        Top = 26
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
        TabOrder = 8
        OnKeyPress = edt_ParamInput
      end
      object edt_power_low_write: TEdit
        Left = 229
        Top = 74
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
        OnKeyPress = edt_ParamInput
      end
      object chk_power_factor_write: TCheckBox
        Left = 28
        Top = 272
        Width = 93
        Height = 17
        Caption = #26657#27491#22240#23376#65306
        TabOrder = 10
      end
      object edt_power_factor_write: TEdit
        Left = 229
        Top = 266
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
        TabOrder = 11
        OnKeyPress = edt_ParamInput
      end
      object chk_fan_limit_write: TCheckBox
        Left = 28
        Top = 224
        Width = 93
        Height = 17
        Caption = #28201#24230#26497#38480#65306
        TabOrder = 12
      end
      object cbb_fan_limit_write: TComboBox
        Left = 229
        Top = 218
        Width = 84
        Height = 21
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 13
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          '32'
          '33'
          '34'
          '35'
          '36'
          '37'
          '38'
          '39'
          '40'
          '41'
          '42'
          '43'
          '44'
          '45'
          '46'
          '47'
          '48'
          '49'
          '50'
          '51'
          '52'
          '53'
          '54'
          '55'
          '56'
          '57'
          '58'
          '59'
          '60'
          '61'
          '62'
          '63'
          '64'
          '65'
          '66'
          '67'
          '68'
          '69'
          '70'
          '71'
          '72'
          '73'
          '74'
          '75'
          '76'
          '77'
          '78'
          '79'
          '80'
          '81'
          '82'
          '83'
          '84'
          '85'
          '86'
          '87'
          '88'
          '89'
          '90'
          '91'
          '92'
          '93'
          '94'
          '95'
          '96'
          '97'
          '98'
          '99'
          '100')
      end
    end
    object scrlbx2: TGroupBox
      Left = 438
      Top = 16
      Width = 387
      Height = 392
      TabOrder = 1
      object btn_read_param: TBitBtn
        Left = 29
        Top = 352
        Width = 75
        Height = 25
        Caption = #35835#21442#25968
        TabOrder = 0
        OnClick = btn_read_paramClick
      end
      object chk_power_up_read: TCheckBox
        Left = 28
        Top = 32
        Width = 93
        Height = 17
        Caption = #30005#21387#19978#38480
        TabOrder = 1
      end
      object chk_power_low_read: TCheckBox
        Left = 28
        Top = 80
        Width = 93
        Height = 17
        Caption = #30005#21387#19979#38480
        TabOrder = 2
      end
      object chk_fan_up_read: TCheckBox
        Left = 28
        Top = 128
        Width = 93
        Height = 17
        Caption = #28201#24230#19978#38480
        TabOrder = 3
      end
      object chk_fan_low_read: TCheckBox
        Left = 28
        Top = 176
        Width = 93
        Height = 17
        Caption = #28201#24230#19979#38480
        TabOrder = 4
      end
      object chk_all_read: TCheckBox
        Left = 28
        Top = 316
        Width = 101
        Height = 16
        Caption = #20840#36873
        TabOrder = 5
        OnClick = chk_all_readClick
      end
      object edt_power_up_read: TEdit
        Left = 229
        Top = 26
        Width = 84
        Height = 22
        BevelInner = bvNone
        BevelKind = bkFlat
        BorderStyle = bsNone
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ImeName = #26368#24378#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 6
      end
      object edt_power_low_read: TEdit
        Left = 229
        Top = 74
        Width = 84
        Height = 22
        BevelInner = bvNone
        BevelKind = bkFlat
        BorderStyle = bsNone
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ImeName = #26368#24378#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
      end
      object edt_fan_up_read: TEdit
        Left = 229
        Top = 122
        Width = 84
        Height = 22
        BevelInner = bvNone
        BevelKind = bkFlat
        BorderStyle = bsNone
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ImeName = #26368#24378#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
      end
      object edt_fan_low_read: TEdit
        Left = 229
        Top = 170
        Width = 84
        Height = 22
        BevelInner = bvNone
        BevelKind = bkFlat
        BorderStyle = bsNone
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ImeName = #26368#24378#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 9
      end
      object chk_power_factor_read: TCheckBox
        Left = 28
        Top = 272
        Width = 93
        Height = 17
        Caption = #26657#27491#22240#23376
        TabOrder = 10
      end
      object edt_power_factor_read: TEdit
        Left = 229
        Top = 266
        Width = 84
        Height = 22
        BevelInner = bvNone
        BevelKind = bkFlat
        BorderStyle = bsNone
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ImeName = #26368#24378#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 11
      end
      object chk_fan_limit_read: TCheckBox
        Left = 28
        Top = 224
        Width = 93
        Height = 17
        Caption = #28201#24230#26497#38480
        TabOrder = 12
      end
      object edt_fan_limit_read: TEdit
        Left = 229
        Top = 218
        Width = 84
        Height = 22
        BevelInner = bvNone
        BevelKind = bkFlat
        BorderStyle = bsNone
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ImeName = #26368#24378#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 13
      end
    end
    object scrlbx3: TGroupBox
      Left = 846
      Top = 16
      Width = 485
      Height = 392
      TabOrder = 2
      Visible = False
    end
  end
end
