object F_Plc: TF_Plc
  Left = 482
  Top = 189
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
        object btn_read_prm: TBitBtn
          Left = 493
          Top = 8
          Width = 75
          Height = 25
          Caption = #35835#21442#25968
          TabOrder = 0
        end
        object rb_name: TRadioButton
          Left = 16
          Top = 13
          Width = 113
          Height = 17
          Caption = #21517#31216
          TabOrder = 1
        end
        object rb_size: TRadioButton
          Left = 129
          Top = 13
          Width = 113
          Height = 17
          Caption = #22823#23567
          TabOrder = 2
        end
        object rb_content: TRadioButton
          Left = 242
          Top = 13
          Width = 113
          Height = 17
          Caption = #20869#23481
          TabOrder = 3
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
        TabOrder = 1
      end
    end
  end
end
