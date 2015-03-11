inherited F_SysCtrl: TF_SysCtrl
  Caption = #31995#32479#25511#21046
  PixelsPerInch = 96
  TextHeight = 12
  inherited scrlbx1: TScrollBox
    object grp1: TGroupBox
      Left = 80
      Top = 56
      Width = 385
      Height = 105
      Caption = #32487#30005#22120#25805#20316
      TabOrder = 0
      object btn_switch_on: TBitBtn
        Left = 22
        Top = 40
        Width = 75
        Height = 25
        Caption = #24320
        TabOrder = 0
        OnClick = btn_switch_onClick
      end
      object btn_switch_off: TBitBtn
        Left = 110
        Top = 40
        Width = 75
        Height = 25
        Caption = #20851
        TabOrder = 1
        OnClick = btn_switch_offClick
      end
      object btn_switch_on_off: TBitBtn
        Left = 198
        Top = 40
        Width = 75
        Height = 25
        Caption = #24320'->'#20851
        TabOrder = 2
        OnClick = btn_switch_on_offClick
      end
      object btn_switch_off_on: TBitBtn
        Left = 286
        Top = 40
        Width = 75
        Height = 25
        Caption = #20851'->'#24320
        TabOrder = 3
        OnClick = btn_switch_off_onClick
      end
    end
    object grp2: TGroupBox
      Left = 480
      Top = 56
      Width = 185
      Height = 105
      Caption = #31995#32479#22797#20301
      TabOrder = 1
      object btn_sys_reset: TBitBtn
        Left = 54
        Top = 40
        Width = 75
        Height = 25
        Caption = #31995#32479#22797#20301
        TabOrder = 0
        OnClick = btn_sys_resetClick
      end
    end
  end
end
