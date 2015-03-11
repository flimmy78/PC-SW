inherited F_MeterFileSyn: TF_MeterFileSyn
  Left = 243
  Top = 105
  Align = alNone
  BorderStyle = bsDialog
  Caption = #26723#26696#21516#27493
  ClientHeight = 558
  ClientWidth = 1115
  OldCreateOrder = True
  Position = poScreenCenter
  WindowState = wsNormal
  PixelsPerInch = 96
  TextHeight = 12
  inherited scrlbx1: TScrollBox
    Width = 1115
    Height = 558
    object grp2: TGroupBox
      Left = 0
      Top = 0
      Width = 1111
      Height = 554
      Align = alClient
      Caption = #30005#34920#26723#26696
      TabOrder = 0
      object crdbgrd2: TCRDBGrid
        Left = 2
        Top = 14
        Width = 1107
        Height = 498
        OnGetCellParams = crdbgrd2GetCellParams
        Align = alClient
        DataSource = ds_meter
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        PopupMenu = pm1
        TabOrder = 0
        TitleFont.Charset = GB2312_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #23435#20307
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'MSN_M'
            Title.Caption = #20027#31449'|'#24207#21495
            Width = 35
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MADDR_M'
            Title.Caption = #20027#31449'|'#34920#21495
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MSPEED_M'
            Title.Caption = #20027#31449'|'#36895#29575
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MPORT_M'
            Title.Caption = #20027#31449'|'#31471#21475
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MPROTOCOL_M'
            Title.Caption = #20027#31449'|'#21327#35758
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MPWD_M'
            Title.Caption = #20027#31449'|'#23494#30721
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MTARIFF_M'
            Title.Caption = #20027#31449'|'#36153#29575
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MENERINTNUM_M'
            Title.Caption = #20027#31449'|'#25972#25968
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MENERDECNUM_M'
            Title.Caption = #20027#31449'|'#23567#25968
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MCOLLADDR_M'
            Title.Caption = #20027#31449'|'#37319#38598#22120
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MLARGECLASS_M'
            Title.Caption = #20027#31449'|'#22823#31867
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MSMALLCLASS_M'
            Title.Caption = #20027#31449'|'#23567#31867
            Width = 30
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'MFLAG'
            Title.Alignment = taCenter
            Title.Caption = #26631#24535
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MSN_T'
            Title.Caption = #32456#31471'|'#24207#21495
            Width = 35
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MADDR_T'
            Title.Caption = #32456#31471'|'#34920#21495
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MSPEED_T'
            Title.Caption = #32456#31471'|'#36895#29575
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MPORT_T'
            Title.Caption = #32456#31471'|'#31471#21475
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MPROTOCOL_T'
            Title.Caption = #32456#31471'|'#21327#35758
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MPWD_T'
            Title.Caption = #32456#31471'|'#23494#30721
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MTARIFF_T'
            Title.Caption = #32456#31471'|'#36153#29575
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MENERINTNUM_T'
            Title.Caption = #32456#31471'|'#25972#25968
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MENERDECNUM_T'
            Title.Caption = #32456#31471'|'#23567#25968
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MCOLLADDR_T'
            Title.Caption = #32456#31471'|'#37319#38598#22120
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MLARGECLASS_T'
            Title.Caption = #32456#31471'|'#22823#31867
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MSMALLCLASS_T'
            Title.Caption = #32456#31471'|'#23567#31867
            Width = 30
            Visible = True
          end>
      end
      object pnl3: TPanel
        Left = 2
        Top = 512
        Width = 1107
        Height = 40
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 1
        object btn_read_file: TBitBtn
          Left = 32
          Top = 9
          Width = 75
          Height = 25
          Caption = #35835#21462
          TabOrder = 0
          OnClick = btn_read_fileClick
        end
        object btn_syn_file: TBitBtn
          Left = 112
          Top = 9
          Width = 75
          Height = 25
          Caption = #21516#27493#26723#26696
          TabOrder = 1
          OnClick = btn_syn_fileClick
        end
        object btn_syn_file_reverse: TBitBtn
          Left = 192
          Top = 9
          Width = 75
          Height = 25
          Caption = #21453#21521#21516#27493#26723#26696
          TabOrder = 2
        end
        object btn_stop: TBitBtn
          Left = 384
          Top = 9
          Width = 75
          Height = 25
          Caption = #20572#27490
          TabOrder = 3
          OnClick = btn_stopClick
        end
      end
    end
  end
  object ds_meter: TDataSource
    DataSet = vrtltbl_meter
    Left = 281
    Top = 120
  end
  object vrtltbl_meter: TVirtualTable
    Active = True
    FieldDefs = <
      item
        Name = 'MSN_M'
        DataType = ftInteger
      end
      item
        Name = 'MADDR_M'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'MSPEED_M'
        DataType = ftInteger
      end
      item
        Name = 'MPORT_M'
        DataType = ftInteger
      end
      item
        Name = 'MPROTOCOL_M'
        DataType = ftInteger
      end
      item
        Name = 'MPWD_M'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'MTARIFF_M'
        DataType = ftInteger
      end
      item
        Name = 'MENERINTNUM_M'
        DataType = ftInteger
      end
      item
        Name = 'MENERDECNUM_M'
        DataType = ftInteger
      end
      item
        Name = 'MCOLLADDR_M'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'MLARGECLASS_M'
        DataType = ftInteger
      end
      item
        Name = 'MSMALLCLASS_M'
        DataType = ftInteger
      end
      item
        Name = 'MSN_T'
        DataType = ftInteger
      end
      item
        Name = 'MADDR_T'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'MSPEED_T'
        DataType = ftInteger
      end
      item
        Name = 'MPORT_T'
        DataType = ftInteger
      end
      item
        Name = 'MPROTOCOL_T'
        DataType = ftInteger
      end
      item
        Name = 'MPWD_T'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'MTARIFF_T'
        DataType = ftInteger
      end
      item
        Name = 'MENERINTNUM_T'
        DataType = ftInteger
      end
      item
        Name = 'MENERDECNUM_T'
        DataType = ftInteger
      end
      item
        Name = 'MCOLLADDR_T'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'MLARGECLASS_T'
        DataType = ftInteger
      end
      item
        Name = 'MSMALLCLASS_T'
        DataType = ftInteger
      end
      item
        Name = 'MFLAG'
        DataType = ftString
        Size = 20
      end>
    Left = 281
    Top = 152
    Data = {
      0300190005004D534E5F4D030000000000000007004D414444525F4D01001400
      0000000008004D53504545445F4D030000000000000007004D504F52545F4D03
      000000000000000B004D50524F544F434F4C5F4D030000000000000006004D50
      57445F4D010014000000000009004D5441524946465F4D03000000000000000D
      004D454E4552494E544E554D5F4D03000000000000000D004D454E4552444543
      4E554D5F4D03000000000000000B004D434F4C4C414444525F4D010014000000
      00000D004D4C41524745434C4153535F4D03000000000000000D004D534D414C
      4C434C4153535F4D030000000000000005004D534E5F54030000000000000007
      004D414444525F54010014000000000008004D53504545445F54030000000000
      000007004D504F52545F5403000000000000000B004D50524F544F434F4C5F54
      030000000000000006004D5057445F54010014000000000009004D5441524946
      465F5403000000000000000D004D454E4552494E544E554D5F54030000000000
      00000D004D454E45524445434E554D5F5403000000000000000B004D434F4C4C
      414444525F5401001400000000000D004D4C41524745434C4153535F54030000
      00000000000D004D534D414C4C434C4153535F54030000000000000005004D46
      4C41470100140000000000000000000000}
  end
  object pm1: TPopupMenu
    Left = 176
    Top = 176
    object N_DelCurMeter_T: TMenuItem
      Caption = #21024#38500#38598#20013#22120#24403#21069#30005#34920
      OnClick = N_DelCurMeter_TClick
    end
    object N_DelTotalMeter_T: TMenuItem
      Caption = #21024#38500#38598#20013#22120#20840#37096#30005#34920
      Visible = False
      OnClick = N_DelTotalMeter_TClick
    end
    object N_DelPlcMeter_T: TMenuItem
      Caption = #21024#38500#25152#26377#36733#27874#34920
      OnClick = N_DelPlcMeter_TClick
    end
    object N_Del485Meter_T: TMenuItem
      Caption = #21024#38500#25152#26377'485'#34920
      OnClick = N_Del485Meter_TClick
    end
    object N_DelAcsMeter_T: TMenuItem
      Caption = #21024#38500#25152#26377#20132#37319#34920
      OnClick = N_DelAcsMeter_TClick
    end
  end
end
