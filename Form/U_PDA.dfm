object F_PDA: TF_PDA
  Left = 115
  Top = 112
  Align = alClient
  BorderStyle = bsNone
  Caption = #25484#26426
  ClientHeight = 464
  ClientWidth = 895
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
  object CheckBox1: TCheckBox
    Left = 25
    Top = 32
    Width = 109
    Height = 17
    Caption = #20351#29992#31995#32479#26102#38047
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object scrlbx1: TScrollBox
    Left = 0
    Top = 0
    Width = 895
    Height = 464
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    object grp1: TGroupBox
      Left = 20
      Top = 14
      Width = 805
      Height = 392
      Caption = #25991#20214#31649#29702
      TabOrder = 0
      object pnl1: TPanel
        Left = 2
        Top = 349
        Width = 801
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object btn_upload: TBitBtn
          Left = 511
          Top = 8
          Width = 75
          Height = 25
          Caption = #19978#20256
          TabOrder = 0
          OnClick = btn_uploadClick
        end
        object btn_sync: TBitBtn
          Left = 215
          Top = 8
          Width = 75
          Height = 25
          Caption = #21516#27493
          TabOrder = 1
          OnClick = btn_syncClick
        end
        object btn_shake_hands: TBitBtn
          Left = 363
          Top = 8
          Width = 75
          Height = 25
          Caption = #25569#25163
          TabOrder = 2
          OnClick = btn_shake_handsClick
        end
      end
      object strngrd_file_manage: TStringGrid
        Left = 2
        Top = 15
        Width = 801
        Height = 334
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 16
        FixedColor = clActiveBorder
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        PopupMenu = pm_file_manage
        TabOrder = 1
      end
    end
    object scrlbx3: TGroupBox
      Left = 846
      Top = 14
      Width = 485
      Height = 392
      Caption = #31995#32479#37197#32622
      TabOrder = 1
      object lbl1: TLabel
        Left = 94
        Top = 74
        Width = 60
        Height = 13
        Caption = #30828#20214#29256#26412'    '
      end
      object Label1: TLabel
        Left = 93
        Top = 114
        Width = 60
        Height = 13
        Caption = #36719#20214#29256#26412'    '
      end
      object Label2: TLabel
        Left = 93
        Top = 154
        Width = 60
        Height = 13
        Caption = #29256#26412#26085#26399'    '
      end
      object btn_restore_defaults: TBitBtn
        Left = 285
        Top = 357
        Width = 75
        Height = 25
        Caption = #24674#22797#20986#21378
        TabOrder = 0
        OnClick = btn_restore_defaultsClick
      end
      object btn_read_para: TBitBtn
        Left = 29
        Top = 357
        Width = 75
        Height = 25
        Caption = #35835#21442#25968
        TabOrder = 1
        OnClick = btn_read_paraClick
      end
      object edt_sys_time: TEdit
        Left = 96
        Top = 29
        Width = 210
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
      object btn_write_para: TButton
        Left = 158
        Top = 357
        Width = 75
        Height = 25
        Caption = #20889#21442#25968
        TabOrder = 3
        OnClick = btn_write_paraClick
      end
      object chk_sys_time: TCheckBox
        Left = 9
        Top = 32
        Width = 80
        Height = 17
        Caption = #31995#32479#26102#38388#65306
        TabOrder = 4
      end
      object chk_version: TCheckBox
        Left = 9
        Top = 73
        Width = 80
        Height = 17
        Caption = #29256#26412#21495#65306
        TabOrder = 5
      end
      object edt_hardware_version: TEdit
        Left = 157
        Top = 69
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
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 6
      end
      object edt_software_version: TEdit
        Left = 157
        Top = 109
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
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
      end
      object edt_version_date: TEdit
        Left = 157
        Top = 149
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
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
      end
      object chk_all: TCheckBox
        Left = 9
        Top = 289
        Width = 80
        Height = 17
        Caption = #20840#36873
        TabOrder = 9
        OnClick = chk_allClick
      end
    end
  end
  object pm_file_manage: TPopupMenu
    Left = 32
    Top = 88
    object N_scroll: TMenuItem
      AutoCheck = True
      Caption = #28378#23631
      Checked = True
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N_clear: TMenuItem
      Caption = #28165#31354
      OnClick = N_clearClick
    end
  end
end
