object F_MEMS: TF_MEMS
  Left = -8
  Top = -8
  Align = alClient
  BorderStyle = bsNone
  Caption = #27668#20307#27969#37327#35745
  ClientHeight = 706
  ClientWidth = 1366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object scrlbx1: TScrollBox
    Left = 0
    Top = 0
    Width = 1366
    Height = 706
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    object scrlbx3: TGroupBox
      Left = 934
      Top = 14
      Width = 397
      Height = 392
      Caption = #31995#32479#20449#24687
      TabOrder = 0
      object lbl_hard: TLabel
        Left = 94
        Top = 74
        Width = 60
        Height = 13
        Caption = #30828#20214#29256#26412'    '
      end
      object lbl_soft: TLabel
        Left = 94
        Top = 114
        Width = 60
        Height = 13
        Caption = #36719#20214#29256#26412'    '
      end
      object btn_restore_defaults: TBitBtn
        Left = 285
        Top = 352
        Width = 75
        Height = 25
        Caption = #24674#22797#20986#21378
        TabOrder = 0
        OnClick = btn_restore_defaultsClick
      end
      object edt_sys_time: TEdit
        Left = 96
        Top = 29
        Width = 210
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object btn_sysinfo_write_para: TButton
        Left = 158
        Top = 352
        Width = 75
        Height = 25
        Caption = #20889#21442#25968
        TabOrder = 2
        OnClick = btn_sysinfo_write_paraClick
      end
      object chk_sys_time: TCheckBox
        Left = 9
        Top = 32
        Width = 80
        Height = 17
        Caption = #31995#32479#26102#38388#65306
        TabOrder = 3
      end
      object chk_version: TCheckBox
        Left = 9
        Top = 73
        Width = 80
        Height = 17
        Caption = #29256#26412#21495#65306
        TabOrder = 4
      end
      object edt_hardware_version: TEdit
        Left = 157
        Top = 69
        Width = 108
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
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
      end
      object edt_software_version: TEdit
        Left = 157
        Top = 109
        Width = 108
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
        ImeName = #20013#25991'('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        TabOrder = 6
      end
      object chk_all: TCheckBox
        Left = 9
        Top = 289
        Width = 80
        Height = 17
        Caption = #20840#36873
        TabOrder = 7
        OnClick = chk_allClick
      end
      object btn_sysinfo_read_para: TBitBtn
        Left = 29
        Top = 352
        Width = 75
        Height = 25
        Caption = #35835#21442#25968
        TabOrder = 8
        OnClick = btn_sysinfo_read_paraClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 20
      Top = 14
      Width = 893
      Height = 392
      Caption = #27969#37327#35745#26657#20934
      TabOrder = 1
      object Label6: TLabel
        Left = 33
        Top = 37
        Width = 54
        Height = 13
        Caption = #26679#26412#25968#30446'  '
      end
      object Label7: TLabel
        Left = 24
        Top = 77
        Width = 69
        Height = 13
        Caption = #27969#37327#27979#37327#20540'   '
      end
      object Label8: TLabel
        Left = 24
        Top = 117
        Width = 69
        Height = 13
        Caption = #27969#37327#26631#20934#20540'   '
      end
      object Label9: TLabel
        Left = 32
        Top = 157
        Width = 54
        Height = 13
        Caption = #26657#20934#31995#25968'  '
      end
      object btn_mems_para_read: TButton
        Left = 29
        Top = 352
        Width = 75
        Height = 25
        Caption = #35835#21442#25968
        TabOrder = 0
        OnClick = btn_mems_para_readClick
      end
      object edt_mems_sample_num_read: TEdit
        Left = 104
        Top = 32
        Width = 97
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object edt_mems_sample_num_write: TEdit
        Left = 216
        Top = 32
        Width = 94
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnKeyPress = edt_memsInput
      end
      object btn_mems_sample_num_save: TButton
        Left = 330
        Top = 30
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 3
        OnClick = btn_mems_sample_num_saveClick
      end
      object edt_mems_measure_flow_read: TEdit
        Left = 104
        Top = 73
        Width = 206
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
      end
      object btn_mems_standard_flow_save: TButton
        Left = 330
        Top = 110
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 5
        OnClick = btn_mems_standard_flow_saveClick
      end
      object edt_mems_standard_flow_write: TEdit
        Left = 104
        Top = 112
        Width = 206
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnKeyPress = edt_memsInput
      end
    end
  end
  object edt_mems_cal_coefficient_read: TEdit
    Left = 126
    Top = 169
    Width = 206
    Height = 23
    Color = 15199215
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
end
