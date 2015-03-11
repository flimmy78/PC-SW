inherited F_Param_Con: TF_Param_Con
  Left = 348
  Top = 139
  Caption = 'F_Param_Con'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited scrlbx1: TScrollBox
    object lbl1: TLabel
      Left = 116
      Top = 65
      Width = 72
      Height = 12
      Caption = #26179#30005#20445#25252#24320#20851
    end
    object lbl2: TLabel
      Left = 116
      Top = 97
      Width = 84
      Height = 12
      Caption = #20877#21551#21160#20445#25252#24320#20851
    end
    object lbl3: TLabel
      Left = 116
      Top = 161
      Width = 96
      Height = 12
      Caption = #26179#30005#20445#25252#26102#38271'(ms)'
    end
    object lbl4: TLabel
      Left = 116
      Top = 193
      Width = 84
      Height = 12
      Caption = #20877#21551#21160#26102#38388'(ms)'
    end
    object lbl5: TLabel
      Left = 116
      Top = 289
      Width = 48
      Height = 12
      Caption = #35774#22791#22320#22336
    end
    object lbl6: TLabel
      Left = 116
      Top = 257
      Width = 102
      Height = 12
      Caption = #20877#21551#21160#30005#21387#38376#38480'(%)'
    end
    object lbl7: TLabel
      Left = 116
      Top = 129
      Width = 84
      Height = 12
      Caption = #20877#21551#21160#24037#20316#26041#24335
    end
    object lbl8: TLabel
      Left = 116
      Top = 225
      Width = 126
      Height = 12
      Caption = #26368#22823#20801#35768#20877#21551#21160#24310#26102'(s)'
    end
    object btn_read_param: TBitBtn
      Left = 261
      Top = 352
      Width = 75
      Height = 25
      Caption = #35835#21442#25968
      TabOrder = 0
      OnClick = btn_read_paramClick
    end
    object btn_write_param: TBitBtn
      Left = 349
      Top = 352
      Width = 75
      Height = 25
      Caption = #20889#21442#25968
      TabOrder = 1
      OnClick = btn_write_paramClick
    end
    object chk1: TCheckBox
      Left = 20
      Top = 324
      Width = 101
      Height = 16
      Caption = #20840#36873
      TabOrder = 2
      OnClick = chk1Click
    end
    object chk_con_time: TCheckBox
      Left = 20
      Top = 32
      Width = 93
      Height = 17
      Caption = #31995#32479#26102#38388#65306
      TabOrder = 3
    end
    object edt_con_time_r: TEdit
      Left = 117
      Top = 29
      Width = 220
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
      TabOrder = 4
    end
    object dtp_con_date_w: TDateTimePicker
      Left = 349
      Top = 29
      Width = 84
      Height = 20
      Date = 40711.447308842590000000
      Format = 'yyyy-MM-dd'
      Time = 40711.447308842590000000
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 5
    end
    object dtp_con_time_w: TDateTimePicker
      Left = 437
      Top = 29
      Width = 72
      Height = 20
      Date = 40711.447308842590000000
      Format = 'HH:mm:ss'
      Time = 40711.447308842590000000
      DateMode = dmUpDown
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      Kind = dtkTime
      TabOrder = 6
    end
    object chk_sys_cfg: TCheckBox
      Left = 20
      Top = 64
      Width = 93
      Height = 17
      Caption = #31995#32479#37197#32622#65306
      TabOrder = 7
    end
    object edt_sloshing_keeptime_r: TEdit
      Left = 253
      Top = 157
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
    object edt_sloshing_keeptime_w: TEdit
      Left = 349
      Top = 157
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
      Text = '800'
    end
    object chk_use_systime: TCheckBox
      Left = 520
      Top = 32
      Width = 97
      Height = 17
      Caption = #20351#29992#31995#32479#26102#38047
      Checked = True
      State = cbChecked
      TabOrder = 10
    end
    object cbb_sloshing_switch_r: TComboBox
      Left = 253
      Top = 62
      Width = 84
      Height = 20
      Style = csDropDownList
      Enabled = False
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 11
      Text = #20851
      Items.Strings = (
        #20851
        #24320)
    end
    object cbb_sloshing_switch_w: TComboBox
      Left = 349
      Top = 62
      Width = 84
      Height = 20
      Style = csDropDownList
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      ItemIndex = 1
      TabOrder = 12
      Text = #24320
      Items.Strings = (
        #20851
        #24320)
    end
    object cbb_again_switch_r: TComboBox
      Left = 253
      Top = 94
      Width = 84
      Height = 20
      Style = csDropDownList
      Enabled = False
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 13
      Text = #20851
      Items.Strings = (
        #20851
        #24320)
    end
    object cbb_again_switch_w: TComboBox
      Left = 349
      Top = 94
      Width = 84
      Height = 20
      Style = csDropDownList
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      ItemIndex = 1
      TabOrder = 14
      Text = #24320
      Items.Strings = (
        #20851
        #24320)
    end
    object edt_again_keeptime_r: TEdit
      Left = 253
      Top = 189
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
      TabOrder = 15
    end
    object edt_dev_addr_r: TEdit
      Left = 253
      Top = 285
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
      TabOrder = 16
    end
    object edt_again_voltage_r: TEdit
      Left = 253
      Top = 253
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
      TabOrder = 17
    end
    object edt_again_keeptime_w: TEdit
      Left = 349
      Top = 189
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
      TabOrder = 18
      Text = '2000'
    end
    object edt_again_voltage_w: TEdit
      Left = 349
      Top = 253
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
      TabOrder = 19
      Text = '90'
    end
    object edt_dev_addr_w: TEdit
      Left = 349
      Top = 285
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
      TabOrder = 20
      Text = '001'
    end
    object cbb_again_mode_r: TComboBox
      Left = 253
      Top = 126
      Width = 84
      Height = 20
      Style = csDropDownList
      Enabled = False
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 21
      Text = #26102#38388#27169#24335
      Items.Strings = (
        #26102#38388#27169#24335
        #30005#21387#27169#24335)
    end
    object cbb_again_mode_w: TComboBox
      Left = 349
      Top = 126
      Width = 84
      Height = 20
      Style = csDropDownList
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 22
      Text = #26102#38388#27169#24335
      Items.Strings = (
        #26102#38388#27169#24335
        #30005#21387#27169#24335)
    end
    object edt_again_max_delay_r: TEdit
      Left = 253
      Top = 221
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
      TabOrder = 23
    end
    object edt_again_max_delay_w: TEdit
      Left = 349
      Top = 221
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
      TabOrder = 24
      Text = '3'
    end
  end
end
