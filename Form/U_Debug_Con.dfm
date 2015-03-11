inherited F_Debug_Con: TF_Debug_Con
  Left = 304
  Top = 204
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited scrlbx1: TScrollBox
    inherited lbl1: TLabel
      Visible = False
    end
    inherited lbl2: TLabel
      Top = 74
      Visible = False
    end
    inherited lbl3: TLabel
      Top = 98
      Width = 24
      Caption = #25968#25454
    end
    inherited lbl4: TLabel
      Top = 122
    end
    object lbl5: TLabel [4]
      Left = 24
      Top = 49
      Width = 12
      Height = 12
      Caption = 'Pn'
      Visible = False
    end
    inherited edt_AFN: TEdit
      Visible = False
    end
    inherited edt_Fn: TEdit
      Top = 71
      Visible = False
    end
    inherited edt_dataunit: TEdit
      Top = 95
      Text = ''
    end
    inherited edt_frame: TEdit
      Top = 119
    end
    inherited btn_create_frame: TBitBtn
      Top = 154
    end
    inherited btn_send: TBitBtn
      Top = 154
    end
    object edt_Pn: TEdit
      Left = 80
      Top = 46
      Width = 500
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 6
      Text = '0'
      Visible = False
    end
    object btn1: TBitBtn
      Left = 320
      Top = 266
      Width = 75
      Height = 25
      Caption = #21457#36865'2'
      TabOrder = 7
      Visible = False
      OnClick = btn1Click
    end
    object edt1: TEdit
      Left = 296
      Top = 208
      Width = 121
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 8
      Text = '127.0.0.1'
      Visible = False
    end
    object edt2: TEdit
      Left = 296
      Top = 232
      Width = 121
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 9
      Text = '3332'
      Visible = False
    end
  end
end
