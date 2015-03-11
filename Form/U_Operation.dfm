object F_Operation: TF_Operation
  Left = 353
  Top = 235
  Align = alClient
  BorderStyle = bsNone
  Caption = #25805#20316
  ClientHeight = 446
  ClientWidth = 920
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object strngrd_oper: TStringGrid
    Left = 0
    Top = 0
    Width = 920
    Height = 446
    Align = alClient
    ColCount = 3
    DefaultRowHeight = 16
    FixedColor = clActiveBorder
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    PopupMenu = pm1
    TabOrder = 0
    OnDrawCell = strngrd_operDrawCell
    OnKeyDown = strngrd_operKeyDown
  end
  object pm1: TPopupMenu
    Left = 72
    Top = 112
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
