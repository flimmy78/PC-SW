object F_Noise: TF_Noise
  Left = 248
  Top = 175
  Align = alClient
  BorderStyle = bsNone
  Caption = #22122#22768#26657#20934
  ClientHeight = 442
  ClientWidth = 912
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
    Width = 912
    Height = 442
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    object scrlbx1: TGroupBox
      Left = 20
      Top = 16
      Width = 397
      Height = 392
      Caption = #36890#36947#36873#25321#21306
      TabOrder = 0
      object rb_ext_mic: TRadioButton
        Left = 16
        Top = 32
        Width = 113
        Height = 17
        Caption = #22806#37096'MIC'#26657#20934
        TabOrder = 0
      end
      object rb_int_mic: TRadioButton
        Left = 16
        Top = 96
        Width = 113
        Height = 17
        Caption = #20869#37096'MIC'#26657#20934
        TabOrder = 1
      end
      object btn_confirm: TButton
        Left = 29
        Top = 352
        Width = 75
        Height = 25
        Caption = #30830#23450
        TabOrder = 2
        OnClick = btn_confirmClick
      end
      object btn_cancel: TButton
        Left = 158
        Top = 352
        Width = 75
        Height = 25
        Caption = #21462#28040
        TabOrder = 3
        OnClick = btn_cancelClick
      end
      object btn_shake: TBitBtn
        Left = 285
        Top = 352
        Width = 75
        Height = 25
        Caption = #25569#25163
        TabOrder = 4
        OnClick = btn_shakeClick
      end
    end
    object scrlbx2: TGroupBox
      Left = 438
      Top = 16
      Width = 491
      Height = 392
      Caption = #20889#21442#25968#21306
      TabOrder = 1
      object auto_send_cycle: TLabel
        Left = 24
        Top = 38
        Width = 42
        Height = 13
        Caption = #31532#19968#32452'  '
      end
      object Label1: TLabel
        Left = 24
        Top = 94
        Width = 42
        Height = 13
        Caption = #31532#20108#32452'  '
      end
      object Label2: TLabel
        Left = 24
        Top = 150
        Width = 42
        Height = 13
        Caption = #31532#19977#32452'  '
      end
      object Label3: TLabel
        Left = 24
        Top = 206
        Width = 42
        Height = 13
        Caption = #31532#22235#32452'  '
      end
      object btn_restore: TBitBtn
        Left = 29
        Top = 352
        Width = 75
        Height = 25
        Caption = #24674#22797#20986#21378
        TabOrder = 0
        Visible = False
        OnClick = btn_restoreClick
      end
      object edt_dbg_view1: TEdit
        Left = 80
        Top = 32
        Width = 121
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        OnKeyPress = edt_noiseInput
      end
      object edt_stard_db1: TEdit
        Left = 224
        Top = 32
        Width = 121
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnKeyPress = edt_noiseInput
      end
      object edt_dbg_view2: TEdit
        Left = 80
        Top = 88
        Width = 121
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        OnKeyPress = edt_noiseInput
      end
      object edt_dbg_view3: TEdit
        Left = 80
        Top = 144
        Width = 121
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
        OnKeyPress = edt_noiseInput
      end
      object edt_dbg_view4: TEdit
        Left = 80
        Top = 200
        Width = 121
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
        OnKeyPress = edt_noiseInput
      end
      object edt_stard_db2: TEdit
        Left = 224
        Top = 88
        Width = 121
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnKeyPress = edt_noiseInput
      end
      object edt_stard_db3: TEdit
        Left = 224
        Top = 144
        Width = 121
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnKeyPress = edt_noiseInput
      end
      object edt_stard_db4: TEdit
        Left = 224
        Top = 200
        Width = 121
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        OnKeyPress = edt_noiseInput
      end
      object btn_save1: TButton
        Left = 374
        Top = 32
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 9
        OnClick = btn_save1Click
      end
      object btn_save2: TButton
        Left = 374
        Top = 88
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 10
        OnClick = btn_save2Click
      end
      object btn_save3: TButton
        Left = 374
        Top = 144
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 11
        OnClick = btn_save3Click
      end
      object btn_save4: TButton
        Left = 374
        Top = 200
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 12
        OnClick = btn_save4Click
      end
    end
  end
end
