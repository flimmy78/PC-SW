object F_Container: TF_Container
  Left = 387
  Top = 258
  Align = alClient
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'F_Container'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object scrlbx1: TScrollBox
    Left = 0
    Top = 0
    Width = 920
    Height = 446
    Align = alClient
    TabOrder = 0
    object spl1: TSplitter
      Left = 0
      Top = 259
      Width = 916
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object pgc2: TPageControl
      Left = 0
      Top = 262
      Width = 916
      Height = 180
      ActivePage = ts_frame
      Align = alBottom
      TabOrder = 0
      object ts_operation: TTabSheet
        Caption = #25805#20316
      end
      object ts_frame: TTabSheet
        Caption = #25253#25991
        ImageIndex = 1
      end
    end
    object pgc1: TPageControl
      Left = 0
      Top = 0
      Width = 916
      Height = 259
      ActivePage = ts_update
      Align = alClient
      TabOrder = 1
      object ts_update: TTabSheet
        Caption = #21319#32423
      end
      object ts_chkmeter: TTabSheet
        Caption = #26657#34920
        ImageIndex = 5
        TabVisible = False
      end
      object ts_param_read_write: TTabSheet
        Caption = #21442#25968
        ImageIndex = 2
      end
      object ts_debug: TTabSheet
        Caption = #35843#35797
        ImageIndex = 4
      end
    end
  end
end
