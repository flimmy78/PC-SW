inherited F_Param_Mod: TF_Param_Mod
  Left = 355
  Top = 221
  Caption = 'F_Param_Mod'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited scrlbx1: TScrollBox
    object btn_read: TBitBtn
      Left = 160
      Top = 225
      Width = 75
      Height = 25
      Caption = #25220#35835
      TabOrder = 0
      OnClick = btn_readClick
    end
    object btn_write: TBitBtn
      Left = 248
      Top = 225
      Width = 75
      Height = 25
      Caption = #35774#32622
      TabOrder = 1
      OnClick = btn_writeClick
    end
    object chk_plc_frequency: TCheckBox
      Left = 40
      Top = 40
      Width = 73
      Height = 17
      Caption = #36733#27874#39057#29575
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cbb_plc_frequency: TComboBox
      Left = 160
      Top = 40
      Width = 249
      Height = 20
      Style = csDropDownList
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 3
      Text = '80/120K'#65292#21452#25193#39057#27169#24335'  '
      Items.Strings = (
        '80/120K'#65292#21452#25193#39057#27169#24335'  '
        '80/120K'#65292'XC'#20860#23481#27169#24335'  '
        '96/160K'#65292#21452#25193#39057#27169#24335'  '
        '96/160K'#65292#39640#36895#27169#24335)
    end
    object chk_version: TCheckBox
      Left = 40
      Top = 113
      Width = 121
      Height = 17
      Caption = #38598#20013#22120#27169#22359#29256#26412#21495
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object edt_version: TEdit
      Left = 160
      Top = 110
      Width = 249
      Height = 20
      Color = clMenuBar
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ReadOnly = True
      TabOrder = 5
    end
    object chk_version_plc: TCheckBox
      Left = 40
      Top = 149
      Width = 105
      Height = 17
      Caption = #36733#27874#27169#22359#29256#26412#21495
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object edt_version_plc: TEdit
      Left = 160
      Top = 146
      Width = 249
      Height = 20
      Color = clMenuBar
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ReadOnly = True
      TabOrder = 7
    end
    object btn_stop_plc: TBitBtn
      Left = 45
      Top = 292
      Width = 92
      Height = 25
      Caption = #26242#20572#36733#27874#25220#34920
      TabOrder = 8
      OnClick = btn_stop_plcClick
    end
    object btn_resume_plc: TBitBtn
      Left = 157
      Top = 292
      Width = 92
      Height = 25
      Caption = #24674#22797#36733#27874#25220#34920
      TabOrder = 9
      OnClick = btn_resume_plcClick
    end
    object chk_plcnode_count: TCheckBox
      Left = 40
      Top = 185
      Width = 105
      Height = 17
      Caption = #36733#27874#33410#28857#25968#37327
      Checked = True
      State = cbChecked
      TabOrder = 10
    end
    object edt_plcnode_count: TEdit
      Left = 160
      Top = 182
      Width = 249
      Height = 20
      Color = clMenuBar
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ReadOnly = True
      TabOrder = 11
    end
    object chk_all: TCheckBox
      Left = 40
      Top = 221
      Width = 97
      Height = 17
      Caption = #20840#36873
      Checked = True
      State = cbChecked
      TabOrder = 12
      OnClick = chk_allClick
    end
    object chk_rt_mode: TCheckBox
      Left = 40
      Top = 75
      Width = 113
      Height = 17
      Caption = #36335#30001#36816#34892#27169#24335
      Checked = True
      State = cbChecked
      TabOrder = 13
    end
    object cbb_rt_mode: TComboBox
      Left = 160
      Top = 75
      Width = 249
      Height = 20
      Style = csDropDownList
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 14
      Text = '01H'#26631#20934#21327#35758
      Items.Strings = (
        '01H'#26631#20934#21327#35758
        '02H'#25193#23637#36335#30001#21327#35758
        '03H'#19996#36719'RT-III'#21327#35758)
    end
    object grp1: TGroupBox
      Left = 440
      Top = 36
      Width = 161
      Height = 149
      Caption = #28857#25220
      TabOrder = 15
      object lbl1: TLabel
        Left = 15
        Top = 28
        Width = 24
        Height = 12
        Caption = #21327#35758
      end
      object lbl2: TLabel
        Left = 15
        Top = 54
        Width = 24
        Height = 12
        Caption = #34920#21495
      end
      object lbl3: TLabel
        Left = 15
        Top = 79
        Width = 24
        Height = 12
        Caption = #25968#25454
      end
      object cbb_meter_protocol: TComboBox
        Left = 47
        Top = 23
        Width = 97
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 12
        ItemIndex = 1
        TabOrder = 0
        Text = '07'#35268#32422
        Items.Strings = (
          '97'#35268#32422
          '07'#35268#32422)
      end
      object edt_meter_no: TEdit
        Left = 47
        Top = 49
        Width = 97
        Height = 20
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        MaxLength = 12
        TabOrder = 1
        Text = '000000000001'
      end
      object edt_read_energy: TEdit
        Left = 47
        Top = 76
        Width = 97
        Height = 20
        Color = clBtnFace
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ReadOnly = True
        TabOrder = 2
      end
      object btn_read_meter_energy: TBitBtn
        Left = 48
        Top = 108
        Width = 75
        Height = 25
        Caption = #28857#25220
        TabOrder = 3
        OnClick = btn_read_meter_energyClick
      end
    end
    object grp2: TGroupBox
      Left = 440
      Top = 196
      Width = 161
      Height = 237
      Caption = #28857#25220
      TabOrder = 16
      object lbl4: TLabel
        Left = 15
        Top = 28
        Width = 24
        Height = 12
        Caption = #21327#35758
      end
      object lbl5: TLabel
        Left = 15
        Top = 83
        Width = 48
        Height = 12
        Caption = #36215#22987#24207#21495
      end
      object lbl6: TLabel
        Left = 15
        Top = 109
        Width = 48
        Height = 12
        Caption = #25130#27490#24207#21495
      end
      object lbl7: TLabel
        Left = 15
        Top = 136
        Width = 36
        Height = 12
        Caption = #25104#21151#25968
      end
      object lbl8: TLabel
        Left = 15
        Top = 163
        Width = 36
        Height = 12
        Caption = #36229#26102#25968
      end
      object lbl9: TLabel
        Left = 15
        Top = 55
        Width = 36
        Height = 12
        Caption = #26631#35782#31526
      end
      object cbb_meter_protocol_sn: TComboBox
        Left = 47
        Top = 23
        Width = 97
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 12
        ItemIndex = 1
        TabOrder = 0
        Text = '07'#35268#32422
        OnChange = cbb_meter_protocol_snChange
        Items.Strings = (
          '97'#35268#32422
          '07'#35268#32422)
      end
      object edt_meter_sn_start: TEdit
        Left = 72
        Top = 78
        Width = 72
        Height = 20
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        MaxLength = 12
        TabOrder = 1
        Text = '1'
      end
      object btn_read_meter_energy_by_sn: TBitBtn
        Left = 48
        Top = 193
        Width = 75
        Height = 25
        Caption = #28857#25220
        TabOrder = 2
        OnClick = btn_read_meter_energy_by_snClick
      end
      object edt_meter_sn_end: TEdit
        Left = 72
        Top = 104
        Width = 72
        Height = 20
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        MaxLength = 12
        TabOrder = 3
        Text = '10'
      end
      object edt_success: TEdit
        Left = 72
        Top = 131
        Width = 72
        Height = 20
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        MaxLength = 12
        ReadOnly = True
        TabOrder = 4
        Text = '0'
      end
      object edt_failed: TEdit
        Left = 72
        Top = 158
        Width = 72
        Height = 20
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        MaxLength = 12
        ReadOnly = True
        TabOrder = 5
        Text = '0'
      end
      object edt_DI: TEdit
        Left = 72
        Top = 50
        Width = 72
        Height = 20
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        MaxLength = 12
        TabOrder = 6
        Text = '1'
      end
    end
  end
end
