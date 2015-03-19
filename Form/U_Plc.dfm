object F_Plc: TF_Plc
  Left = 397
  Top = 237
  Align = alClient
  BorderStyle = bsNone
  Caption = #30005#21147#25220#34920#25484#26426
  ClientHeight = 442
  ClientWidth = 912
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
  object scrlbx1: TScrollBox
    Left = 0
    Top = 0
    Width = 912
    Height = 442
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    object grp1: TGroupBox
      Left = 20
      Top = 16
      Width = 1311
      Height = 392
      Caption = #25991#20214#31649#29702
      TabOrder = 0
      object pnl1: TPanel
        Left = 2
        Top = 349
        Width = 1307
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object btn_upload: TBitBtn
          Left = 779
          Top = 8
          Width = 75
          Height = 25
          Caption = #19978#20256
          TabOrder = 0
        end
        object btn_sync: TBitBtn
          Left = 462
          Top = 8
          Width = 75
          Height = 25
          Caption = #21516#27493
          TabOrder = 1
          OnClick = btn_syncClick
        end
      end
      object strngrd_file_manage: TStringGrid
        Left = 2
        Top = 15
        Width = 1307
        Height = 334
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 16
        FixedColor = clActiveBorder
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        PopupMenu = pm_file_manage
        TabOrder = 1
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
