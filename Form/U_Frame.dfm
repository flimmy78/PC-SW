object F_Frame: TF_Frame
  Left = 416
  Top = 212
  Align = alClient
  BorderStyle = bsNone
  Caption = #25253#25991
  ClientHeight = 455
  ClientWidth = 942
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
  object strngrd_frame: TStringGrid
    Left = 408
    Top = 144
    Width = 193
    Height = 113
    Color = clWhite
    ColCount = 4
    DefaultRowHeight = 16
    FixedColor = clActiveBorder
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    PopupMenu = pm1
    TabOrder = 0
    OnDrawCell = strngrd_frameDrawCell
    OnKeyDown = strngrd_frameKeyDown
  end
  object lv_frame: TListView
    Left = 136
    Top = 160
    Width = 257
    Height = 169
    Columns = <
      item
        Caption = #26102#38388
        Width = 80
      end
      item
        Caption = #25805#20316
        Width = 90
      end
      item
        Caption = #25253#25991
        Width = 4096
      end>
    GridLines = True
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = pm1
    TabOrder = 1
    ViewStyle = vsReport
    Visible = False
    OnCustomDrawItem = lv_frameCustomDrawItem
  end
  object redt_frame: TRichEdit
    Left = 0
    Top = 0
    Width = 942
    Height = 455
    Align = alClient
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
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
