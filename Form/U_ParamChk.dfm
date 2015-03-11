inherited F_ParamChk: TF_ParamChk
  Caption = #21442#25968#26657#20934
  PixelsPerInch = 96
  TextHeight = 12
  inherited scrlbx1: TScrollBox
    object chk_voltage: TCheckBox
      Left = 20
      Top = 32
      Width = 93
      Height = 17
      Caption = #30005#21387#26657#20934#65306
      TabOrder = 0
    end
    object edt_voltage_r: TEdit
      Left = 117
      Top = 29
      Width = 124
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
      ImeName = #26368#24378#20116#31508#36755#20837#27861
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object edt_voltage_w: TEdit
      Left = 253
      Top = 29
      Width = 124
      Height = 22
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ImeName = #26368#24378#20116#31508#36755#20837#27861
      ParentFont = False
      TabOrder = 2
      Text = '220.00'
    end
    object btn_read_param: TBitBtn
      Left = 141
      Top = 96
      Width = 75
      Height = 25
      Caption = #35835#21462
      TabOrder = 3
      OnClick = btn_read_paramClick
    end
    object btn_write_param: TBitBtn
      Left = 277
      Top = 96
      Width = 75
      Height = 25
      Caption = #26657#20934
      TabOrder = 4
      OnClick = btn_write_paramClick
    end
    object chk1: TCheckBox
      Left = 20
      Top = 76
      Width = 101
      Height = 16
      Caption = #20840#36873
      TabOrder = 5
      OnClick = chk1Click
    end
  end
end
