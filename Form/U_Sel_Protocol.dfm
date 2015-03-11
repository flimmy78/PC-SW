object F_Sel_Protocol: TF_Sel_Protocol
  Left = 449
  Top = 167
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #21151#33021#36873#25321
  ClientHeight = 225
  ClientWidth = 279
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object rg_protocol: TRadioGroup
    Left = 44
    Top = 24
    Width = 197
    Height = 137
    Caption = #36719#20214#21151#33021
    ItemIndex = 3
    Items.Strings = (
      #20132#37319#26657#20934
      #38598#20013#22120#21319#32423
      #36335#30001#26495#21319#32423
      #36335#30001#26495#21319#32423#65288#38598#20013#22120#36716#21457#65289)
    TabOrder = 1
  end
  object btn_ok: TBitBtn
    Left = 57
    Top = 176
    Width = 75
    Height = 25
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 0
    OnClick = btn_okClick
  end
  object btn1: TBitBtn
    Left = 153
    Top = 176
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 2
    OnClick = btn_okClick
  end
end
