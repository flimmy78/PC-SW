object F_Key: TF_Key
  Left = 300
  Top = 331
  Align = alClient
  BorderStyle = bsNone
  Caption = #38053#21273
  ClientHeight = 431
  ClientWidth = 994
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object scrlbx0: TScrollBox
    Left = 0
    Top = 0
    Width = 994
    Height = 431
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
      object auto_send_cycle: TLabel
        Left = 24
        Top = 38
        Width = 77
        Height = 13
        Caption = #38053#21273'ID'#33539#22260'      '
      end
      object Label2: TLabel
        Left = 24
        Top = 86
        Width = 66
        Height = 13
        Caption = #29992#25143#23494#30721'      '
      end
      object Label1: TLabel
        Left = 224
        Top = 38
        Width = 30
        Height = 13
        Caption = #65374'      '
      end
      object btn_load: TButton
        Left = 29
        Top = 352
        Width = 75
        Height = 25
        Caption = #21152#36733
        TabOrder = 0
        OnClick = btn_loadClick
      end
      object btn_cancel: TButton
        Left = 158
        Top = 352
        Width = 75
        Height = 25
        Caption = #21462#28040
        TabOrder = 1
        OnClick = btn_cancelClick
      end
      object edt_id_begin: TEdit
        Left = 96
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
        OnKeyPress = edt_idInput
      end
      object edt_id_end: TEdit
        Left = 245
        Top = 32
        Width = 121
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnKeyPress = edt_idInput
      end
      object edt_user_pwd: TEdit
        Left = 96
        Top = 80
        Width = 121
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        PasswordChar = '*'
        ReadOnly = True
        TabOrder = 4
        Text = '123s'
      end
    end
    object scrlbx2: TGroupBox
      Left = 438
      Top = 16
      Width = 387
      Height = 392
      TabOrder = 1
      object Label5: TLabel
        Left = 24
        Top = 38
        Width = 65
        Height = 13
        Caption = #24050#28903#20889'ID      '
      end
      object Label6: TLabel
        Left = 24
        Top = 86
        Width = 77
        Height = 13
        Caption = #21363#23558#28903#20889'ID      '
      end
      object btn_write_param: TBitBtn
        Left = 29
        Top = 352
        Width = 75
        Height = 25
        Caption = #20889#38053#21273'ID'
        TabOrder = 0
        OnClick = btn_write_paramClick
      end
      object edt_id_yet: TEdit
        Left = 120
        Top = 32
        Width = 210
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
      end
      object edt_id_soon: TEdit
        Left = 120
        Top = 80
        Width = 210
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
    end
    object scrlbx3: TGroupBox
      Left = 846
      Top = 16
      Width = 485
      Height = 392
      TabOrder = 2
      object Label7: TLabel
        Left = 24
        Top = 38
        Width = 53
        Height = 13
        Caption = #38053#21273'ID      '
      end
      object Label4: TLabel
        Left = 24
        Top = 86
        Width = 66
        Height = 13
        Caption = #36719#20214#29256#26412'      '
      end
      object edt_read_id: TEdit
        Left = 120
        Top = 32
        Width = 210
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object btn_restore_defaults: TBitBtn
        Left = 285
        Top = 352
        Width = 75
        Height = 25
        Caption = #24674#22797#20986#21378
        TabOrder = 1
        OnClick = btn_restore_defaultsClick
      end
      object btn_read_param: TBitBtn
        Left = 29
        Top = 352
        Width = 75
        Height = 25
        Caption = #35835#38053#21273'ID'
        TabOrder = 2
        OnClick = btn_read_paramClick
      end
      object edt_soft_version: TEdit
        Left = 120
        Top = 80
        Width = 210
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
      end
      object btn_soft_version: TButton
        Left = 158
        Top = 352
        Width = 75
        Height = 25
        Caption = #35835#29256#26412
        TabOrder = 4
        OnClick = btn_soft_versionClick
      end
    end
  end
end
