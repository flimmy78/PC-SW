inherited F_MeterFile: TF_MeterFile
  Left = 303
  Top = 190
  Caption = #26723#26696#32500#25252
  ClientWidth = 784
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited scrlbx1: TScrollBox
    Width = 784
    object grp1: TGroupBox
      Left = 16
      Top = 8
      Width = 329
      Height = 401
      Caption = #26179#30005#35760#24405
      TabOrder = 0
      object pnl1: TPanel
        Left = 2
        Top = 358
        Width = 325
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object btn_read_status: TBitBtn
          Left = 125
          Top = 8
          Width = 75
          Height = 25
          Caption = #35835#35760#24405
          TabOrder = 0
          OnClick = btn_read_statusClick
        end
      end
      object strngrd_PowerDropRecord: TStringGrid
        Left = 2
        Top = 14
        Width = 325
        Height = 344
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 16
        FixedColor = clActiveBorder
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        TabOrder = 1
      end
    end
    object grp2: TGroupBox
      Left = 416
      Top = 8
      Width = 329
      Height = 401
      Caption = #20877#21551#21160#35760#24405
      TabOrder = 1
      object pnl2: TPanel
        Left = 2
        Top = 358
        Width = 325
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object btn_SelfPowerOn: TBitBtn
          Left = 133
          Top = 8
          Width = 75
          Height = 25
          Caption = #35835#35760#24405
          TabOrder = 0
          OnClick = btn_SelfPowerOnClick
        end
      end
      object strngrd_SelfPowerOnCountRecord: TStringGrid
        Left = 2
        Top = 14
        Width = 325
        Height = 344
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 16
        FixedColor = clActiveBorder
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        TabOrder = 1
      end
    end
  end
end
