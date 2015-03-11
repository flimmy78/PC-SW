object F_Debug: TF_Debug
  Left = 297
  Top = 190
  Align = alClient
  BorderStyle = bsNone
  Caption = #35843#35797
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
  PixelsPerInch = 96
  TextHeight = 12
  object scrlbx1: TScrollBox
    Left = 0
    Top = 0
    Width = 920
    Height = 446
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    object lbl1: TLabel
      Left = 24
      Top = 24
      Width = 18
      Height = 12
      Caption = 'AFN'
    end
    object lbl2: TLabel
      Left = 24
      Top = 48
      Width = 12
      Height = 12
      Caption = 'Fn'
    end
    object lbl3: TLabel
      Left = 24
      Top = 72
      Width = 48
      Height = 12
      Caption = #25968#25454#21333#20803
    end
    object lbl4: TLabel
      Left = 24
      Top = 96
      Width = 36
      Height = 12
      Caption = #29983#25104#24103
    end
    object edt_AFN: TEdit
      Left = 80
      Top = 21
      Width = 500
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 0
      Text = 'F6'
    end
    object edt_Fn: TEdit
      Left = 80
      Top = 45
      Width = 500
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 1
      Text = '1'
    end
    object edt_dataunit: TEdit
      Left = 80
      Top = 69
      Width = 500
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 2
      Text = '00 00 12 00 00 00 00 ff 7f ff ff ff ff ff ff'
    end
    object edt_frame: TEdit
      Left = 80
      Top = 93
      Width = 500
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 3
    end
    object btn_create_frame: TBitBtn
      Left = 80
      Top = 128
      Width = 75
      Height = 25
      Caption = #29983#25104
      TabOrder = 4
      OnClick = btn_create_frameClick
    end
    object btn_send: TBitBtn
      Left = 168
      Top = 128
      Width = 75
      Height = 25
      Caption = #21457#36865
      TabOrder = 5
      OnClick = btn_sendClick
    end
  end
end
