object F_MEMS: TF_MEMS
  Left = 477
  Top = 272
  Align = alClient
  BorderStyle = bsNone
  Caption = #27668#20307#27969#37327#35745
  ClientHeight = 408
  ClientWidth = 843
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
    Width = 843
    Height = 408
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
    object scrlbx2: TGroupBox
      Left = 414
      Top = 14
      Width = 499
      Height = 392
      Caption = #27969#37327#26657#20934
      TabOrder = 1
      object Label1: TLabel
        Left = 24
        Top = 38
        Width = 99
        Height = 13
        Caption = #31532#19968#32452#65288'10%FS'#65289'  '
      end
      object Label2: TLabel
        Left = 24
        Top = 94
        Width = 99
        Height = 13
        Caption = #31532#20108#32452#65288'30%FS'#65289'  '
      end
      object Label3: TLabel
        Left = 24
        Top = 150
        Width = 99
        Height = 13
        Caption = #31532#19977#32452#65288'50%FS'#65289'  '
      end
      object Label4: TLabel
        Left = 24
        Top = 206
        Width = 99
        Height = 13
        Caption = #31532#22235#32452#65288'70%FS'#65289'  '
      end
      object Label5: TLabel
        Left = 24
        Top = 262
        Width = 99
        Height = 13
        Caption = #31532#20116#32452#65288'90%FS'#65289'  '
      end
      object edt_cal_read_grp2: TEdit
        Left = 128
        Top = 88
        Width = 121
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object edt_cal_write_grp1: TEdit
        Left = 264
        Top = 32
        Width = 121
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnKeyPress = edt_memsInput
      end
      object edt_cal_read_grp4: TEdit
        Left = 128
        Top = 200
        Width = 121
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
      object edt_cal_read_grp3: TEdit
        Left = 128
        Top = 144
        Width = 121
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
      object edt_cal_read_grp1: TEdit
        Left = 128
        Top = 32
        Width = 121
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
      object edt_cal_write_grp2: TEdit
        Left = 264
        Top = 88
        Width = 121
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnKeyPress = edt_memsInput
      end
      object edt_cal_write_grp3: TEdit
        Left = 264
        Top = 144
        Width = 121
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
      object edt_cal_write_grp4: TEdit
        Left = 264
        Top = 200
        Width = 121
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnKeyPress = edt_memsInput
      end
      object btn_cal_save_grp1: TButton
        Left = 406
        Top = 30
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 8
        OnClick = btn_cal_save_grp1Click
      end
      object btn_cal_save_grp2: TButton
        Left = 406
        Top = 86
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 9
        OnClick = btn_cal_save_grp2Click
      end
      object btn_cal_save_grp3: TButton
        Left = 406
        Top = 142
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 10
        OnClick = btn_cal_save_grp3Click
      end
      object btn_cal_save_grp4: TButton
        Left = 406
        Top = 198
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 11
        OnClick = btn_cal_save_grp4Click
      end
      object edt_cal_read_grp5: TEdit
        Left = 128
        Top = 256
        Width = 121
        Height = 23
        Color = 15199215
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 12
      end
      object edt_cal_write_grp5: TEdit
        Left = 264
        Top = 256
        Width = 121
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 13
        OnKeyPress = edt_memsInput
      end
      object btn_cal_save_grp5: TButton
        Left = 406
        Top = 254
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 14
        OnClick = btn_cal_save_grp5Click
      end
      object btn_cal_read_para: TBitBtn
        Left = 29
        Top = 352
        Width = 75
        Height = 25
        Caption = #35835#21442#25968
        TabOrder = 15
        OnClick = btn_cal_read_paraClick
      end
      object btn_cal_confirm: TButton
        Left = 158
        Top = 352
        Width = 75
        Height = 25
        Caption = #30830#35748
        TabOrder = 16
        OnClick = btn_cal_confirmClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 20
      Top = 14
      Width = 373
      Height = 392
      Caption = #27969#37327#28040#25238
      TabOrder = 2
      object Label6: TLabel
        Left = 24
        Top = 38
        Width = 30
        Height = 13
        Caption = #38408#20540'  '
      end
      object Label7: TLabel
        Left = 24
        Top = 94
        Width = 30
        Height = 13
        Caption = #27425#25968'  '
      end
      object btn_debounce_read_para: TButton
        Left = 29
        Top = 352
        Width = 75
        Height = 25
        Caption = #35835#21442#25968
        TabOrder = 0
        OnClick = btn_debounce_read_paraClick
      end
      object edt_debounce_threshold_read: TEdit
        Left = 56
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
      object edt_debounce_times_read: TEdit
        Left = 56
        Top = 88
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
        TabOrder = 2
      end
      object edt_debounce_threshold_write: TEdit
        Left = 168
        Top = 32
        Width = 94
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnKeyPress = edt_memsInput
      end
      object edt_debounce_times_write: TEdit
        Left = 168
        Top = 88
        Width = 94
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnKeyPress = edt_memsInput
      end
      object btn_debounce_save_threshold: TButton
        Left = 282
        Top = 30
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 5
        OnClick = btn_debounce_save_thresholdClick
      end
      object btn_debounce_save_times: TButton
        Left = 282
        Top = 86
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 6
        OnClick = btn_debounce_save_timesClick
      end
    end
  end
end
