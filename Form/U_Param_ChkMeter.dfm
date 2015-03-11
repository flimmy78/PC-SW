inherited F_Param_ChkMeter: TF_Param_ChkMeter
  Left = 358
  Top = 35
  Caption = #26657#34920
  ClientHeight = 566
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  inherited scrlbx1: TScrollBox
    Height = 566
    object pnl1: TPanel
      Left = 0
      Top = 0
      Width = 916
      Height = 562
      Align = alClient
      TabOrder = 0
      object pgc1: TPageControl
        Left = 1
        Top = 42
        Width = 914
        Height = 519
        ActivePage = ts2
        Align = alClient
        TabOrder = 0
        object ts1: TTabSheet
          Caption = #30005#34920#21442#25968
          object scrlbx2: TScrollBox
            Left = 0
            Top = 0
            Width = 906
            Height = 492
            Align = alClient
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            object grp_param: TGroupBox
              Left = 20
              Top = 15
              Width = 393
              Height = 386
              Caption = #21442#25968
              TabOrder = 0
              object lbl1: TLabel
                Left = 309
                Top = 26
                Width = 76
                Height = 13
                AutoSize = False
                Caption = '(imp/'#21315#29926#26102')'
                WordWrap = True
              end
              object lbl3: TLabel
                Left = 309
                Top = 57
                Width = 76
                Height = 13
                AutoSize = False
                Caption = '(imp/'#21315#29926#26102')'
                WordWrap = True
              end
              object lbl2: TLabel
                Left = 309
                Top = 88
                Width = 46
                Height = 13
                AutoSize = False
                Caption = '('#23433#22521')'
                WordWrap = True
              end
              object lbl4: TLabel
                Left = 309
                Top = 119
                Width = 46
                Height = 13
                AutoSize = False
                Caption = '('#20239#29305')'
                WordWrap = True
              end
              object lbl_Imin: TLabel
                Left = 38
                Top = 181
                Width = 120
                Height = 12
                Caption = #23433#26816#26368#23567#30005#27969' Imin '#65306
              end
              object lbl6: TLabel
                Left = 309
                Top = 181
                Width = 46
                Height = 13
                AutoSize = False
                Caption = '('#23433#22521')'
                Visible = False
                WordWrap = True
              end
              object lbl7: TLabel
                Left = 309
                Top = 150
                Width = 46
                Height = 13
                AutoSize = False
                Caption = '('#23433#22521')'
                Visible = False
                WordWrap = True
              end
              object chk_meter_const: TCheckBox
                Left = 20
                Top = 26
                Width = 159
                Height = 17
                Caption = #30005#34920#24120#25968'('#26377#21151'/'#26080#21151')'#65306
                TabOrder = 0
              end
              object edt_meter_const_r: TEdit
                Left = 166
                Top = 26
                Width = 61
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
              object cbb_meter_const_w: TComboBox
                Left = 238
                Top = 26
                Width = 61
                Height = 20
                BevelInner = bvNone
                BevelKind = bkFlat
                Style = csDropDownList
                ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
                ItemHeight = 12
                ItemIndex = 6
                TabOrder = 2
                Text = '6400'
                Items.Strings = (
                  '200'
                  '400'
                  '800'
                  '1600'
                  '3000'
                  '3200'
                  '6400'
                  '12800'
                  '15000'
                  '25600')
              end
              object cbb_remote_const_w: TComboBox
                Left = 238
                Top = 57
                Width = 61
                Height = 20
                BevelInner = bvNone
                BevelKind = bkFlat
                Style = csDropDownList
                ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
                ItemHeight = 12
                ItemIndex = 6
                TabOrder = 3
                Text = '6400'
                Items.Strings = (
                  '200'
                  '400'
                  '800'
                  '1600'
                  '3000'
                  '3200'
                  '6400'
                  '12800'
                  '15000'
                  '25600')
              end
              object chk_remote_const: TCheckBox
                Left = 20
                Top = 57
                Width = 149
                Height = 16
                Caption = #36828#21160#24120#25968'('#26377#21151'/'#26080#21151')'#65306
                TabOrder = 4
              end
              object chk_Ib: TCheckBox
                Left = 20
                Top = 88
                Width = 88
                Height = 17
                Caption = #39069#23450#30005#27969'Ib'#65306
                TabOrder = 5
              end
              object edt_Ib_r: TEdit
                Left = 166
                Top = 88
                Width = 61
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
                ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
                ParentFont = False
                ReadOnly = True
                TabOrder = 6
              end
              object medt_Ib_w: TMaskEdit
                Left = 238
                Top = 88
                Width = 60
                Height = 22
                BevelInner = bvNone
                BevelKind = bkFlat
                BorderStyle = bsNone
                EditMask = '!99.99;1;x'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'Microsoft Sans Serif'
                Font.Style = []
                ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
                MaxLength = 5
                ParentFont = False
                TabOrder = 7
                Text = '01.50'
              end
              object medt_Ub_w: TMaskEdit
                Left = 238
                Top = 119
                Width = 60
                Height = 22
                BevelInner = bvNone
                BevelKind = bkFlat
                BorderStyle = bsNone
                EditMask = '!999;1;x'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'Microsoft Sans Serif'
                Font.Style = []
                ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
                MaxLength = 3
                ParentFont = False
                TabOrder = 8
                Text = '220'
              end
              object edt_Ub_r: TEdit
                Left = 166
                Top = 119
                Width = 61
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
                TabOrder = 9
              end
              object chk_Ub: TCheckBox
                Left = 20
                Top = 119
                Width = 102
                Height = 17
                Caption = #39069#23450#30005#21387'Ub'#65306
                TabOrder = 10
              end
              object chk_Imax: TCheckBox
                Left = 20
                Top = 150
                Width = 143
                Height = 17
                Caption = #23433#26816#26368#22823#30005#27969' Imax '#65306
                TabOrder = 11
              end
              object edt_Imin_r: TEdit
                Left = 166
                Top = 181
                Width = 61
                Height = 23
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
                TabOrder = 12
              end
              object medt_Imin_w: TMaskEdit
                Left = 238
                Top = 181
                Width = 59
                Height = 22
                BevelInner = bvNone
                BevelKind = bkFlat
                BorderStyle = bsNone
                EditMask = '!99.99;1;x'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'Microsoft Sans Serif'
                Font.Style = []
                ImeName = #26368#24378#20116#31508#36755#20837#27861
                MaxLength = 5
                ParentFont = False
                TabOrder = 13
                Text = '01.50'
              end
              object medt_Imax_w: TMaskEdit
                Left = 238
                Top = 150
                Width = 58
                Height = 22
                BevelInner = bvNone
                BevelKind = bkFlat
                BorderStyle = bsNone
                EditMask = '!99.99;1;x'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'Microsoft Sans Serif'
                Font.Style = []
                ImeName = #26368#24378#20116#31508#36755#20837#27861
                MaxLength = 5
                ParentFont = False
                TabOrder = 14
                Text = '06.00'
              end
              object edt_Imax_r: TEdit
                Left = 166
                Top = 150
                Width = 61
                Height = 23
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
                TabOrder = 15
              end
              object edt_remote_const_r: TEdit
                Left = 166
                Top = 57
                Width = 61
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
                TabOrder = 16
              end
              object btn_read_param: TBitBtn
                Left = 152
                Top = 319
                Width = 75
                Height = 25
                Caption = #35835#21442#25968
                TabOrder = 17
                OnClick = btn_read_paramClick
              end
              object btn_write_param: TBitBtn
                Left = 240
                Top = 319
                Width = 75
                Height = 25
                Caption = #35774#21442#25968
                TabOrder = 18
                OnClick = btn_write_paramClick
              end
              object chk_all: TCheckBox
                Left = 20
                Top = 311
                Width = 97
                Height = 17
                Caption = #20840#36873
                TabOrder = 19
                OnClick = chk_allClick
              end
              object chk_voltage: TCheckBox
                Left = 20
                Top = 212
                Width = 102
                Height = 17
                Caption = #19977#30456#30005#21387#65306
                TabOrder = 20
              end
              object edt_voltage: TEdit
                Left = 104
                Top = 212
                Width = 193
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
                TabOrder = 21
              end
              object chk_current: TCheckBox
                Left = 20
                Top = 242
                Width = 102
                Height = 17
                Caption = #19977#30456#30005#27969#65306
                TabOrder = 22
              end
              object edt_current: TEdit
                Left = 104
                Top = 242
                Width = 193
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
                TabOrder = 23
              end
              object chk_acs_version: TCheckBox
                Left = 20
                Top = 274
                Width = 77
                Height = 17
                Caption = #20132#37319#29256#26412
                TabOrder = 24
              end
              object edt_acs_version: TEdit
                Left = 104
                Top = 272
                Width = 193
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
                TabOrder = 25
              end
            end
          end
        end
        object ts2: TTabSheet
          Caption = #24555#36895#35774#32622#23492#23384#22120
          ImageIndex = 1
          object scrlbx3: TScrollBox
            Left = 0
            Top = 0
            Width = 906
            Height = 492
            Align = alClient
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            object grp1: TGroupBox
              Left = 20
              Top = 15
              Width = 681
              Height = 313
              Caption = #37096#20998#23492#23384#22120#24555#36895#35774#32622
              TabOrder = 0
              object btn_init_reg: TBitBtn
                Left = 120
                Top = 268
                Width = 75
                Height = 25
                Caption = #21021#22987#21270
                TabOrder = 0
                OnClick = btn_init_regClick
              end
              object btn_write_reg: TBitBtn
                Left = 312
                Top = 268
                Width = 75
                Height = 25
                Caption = #35774'  '#32622
                TabOrder = 1
                OnClick = btn_write_regClick
              end
              object chk_threshold_voltage_loss: TCheckBox
                Left = 16
                Top = 196
                Width = 129
                Height = 17
                Caption = #22833#21387#38400#20540#65288'29'#65289
                TabOrder = 2
              end
              object chk_comb_phase: TCheckBox
                Left = 16
                Top = 164
                Width = 137
                Height = 17
                Caption = #21512#30456#27169#24335#35774#32622#65288'2A'#65289#65306
                TabOrder = 3
              end
              object chk_area: TCheckBox
                Left = 16
                Top = 132
                Width = 137
                Height = 17
                Caption = #27604#24046#21306#22495#35774#32622#65288'1E'#65289#65306
                TabOrder = 4
              end
              object chk_boot_cur: TCheckBox
                Left = 16
                Top = 100
                Width = 137
                Height = 17
                Caption = #21551#21160#30005#27969#35774#32622#65288'1F'#65289#65306
                TabOrder = 5
              end
              object chk_pulse: TCheckBox
                Left = 16
                Top = 60
                Width = 137
                Height = 25
                Caption = #39640#39057#33033#20914#35774#32622#65288'20'#65289#65306
                TabOrder = 6
              end
              object edt_pulse_w: TEdit
                Left = 248
                Top = 62
                Width = 65
                Height = 20
                TabOrder = 7
                Text = '00001C'
              end
              object edt_boot_cur_w: TEdit
                Left = 248
                Top = 96
                Width = 65
                Height = 20
                TabOrder = 8
                Text = '00009E'
              end
              object edt_comb_phase_w: TEdit
                Left = 248
                Top = 162
                Width = 65
                Height = 20
                TabOrder = 9
                Text = '000001'
              end
              object edt_area_w: TEdit
                Left = 248
                Top = 129
                Width = 65
                Height = 20
                TabOrder = 10
                Text = '02E72E'
              end
              object edt_threshold_voltage_loss_w: TEdit
                Left = 248
                Top = 196
                Width = 65
                Height = 20
                TabOrder = 11
                Text = '02C000'
              end
              object edt_phase_angle4_w: TEdit
                Left = 573
                Top = 164
                Width = 81
                Height = 20
                TabOrder = 12
                Text = '013E81'
              end
              object edt_phase_angle1_w: TEdit
                Left = 573
                Top = 57
                Width = 81
                Height = 20
                TabOrder = 13
                Text = '000000'
              end
              object edt_phase_angle2_w: TEdit
                Left = 573
                Top = 92
                Width = 81
                Height = 20
                TabOrder = 14
                Text = '000000'
              end
              object edt_phase_angle3_w: TEdit
                Left = 573
                Top = 128
                Width = 81
                Height = 20
                TabOrder = 15
                Text = '000000'
              end
              object chk_phase_angle1: TCheckBox
                Left = 336
                Top = 60
                Width = 97
                Height = 17
                Caption = #30456#20301'1'#65288'02'#65289#65306
                TabOrder = 16
              end
              object chk_phase_angle2: TCheckBox
                Left = 336
                Top = 93
                Width = 97
                Height = 25
                Caption = #30456#20301'2'#65288'03'#65289#65306
                TabOrder = 17
              end
              object chk_phase_angle3: TCheckBox
                Left = 336
                Top = 129
                Width = 97
                Height = 17
                Caption = #30456#20301'3'#65288'04'#65289#65306
                TabOrder = 18
              end
              object chk_phase_angle4: TCheckBox
                Left = 336
                Top = 160
                Width = 97
                Height = 25
                Caption = #30456#20301'4'#65288'05'#65289#65306
                TabOrder = 19
              end
              object btn_read_reg: TBitBtn
                Left = 216
                Top = 268
                Width = 75
                Height = 25
                Caption = #25220'  '#25910
                TabOrder = 20
                OnClick = btn_read_regClick
              end
              object edt_area_r: TEdit
                Left = 156
                Top = 129
                Width = 81
                Height = 20
                ReadOnly = True
                TabOrder = 21
                Text = '44'
              end
              object edt_boot_cur_r: TEdit
                Left = 156
                Top = 95
                Width = 81
                Height = 20
                ReadOnly = True
                TabOrder = 22
                Text = '45'
              end
              object edt_pulse_r: TEdit
                Left = 156
                Top = 62
                Width = 81
                Height = 20
                ReadOnly = True
                TabOrder = 23
                Text = '46'
              end
              object edt_phase_angle1_r: TEdit
                Left = 480
                Top = 57
                Width = 81
                Height = 20
                ReadOnly = True
                TabOrder = 24
                Text = '47'
              end
              object edt_phase_angle2_r: TEdit
                Left = 480
                Top = 92
                Width = 81
                Height = 20
                ReadOnly = True
                TabOrder = 25
                Text = '48'
              end
              object edt_phase_angle3_r: TEdit
                Left = 480
                Top = 127
                Width = 81
                Height = 20
                ReadOnly = True
                TabOrder = 26
                Text = '49'
              end
              object edt_phase_angle4_r: TEdit
                Left = 480
                Top = 163
                Width = 81
                Height = 20
                ReadOnly = True
                TabOrder = 27
                Text = '50'
              end
              object edt_comb_phase_r: TEdit
                Left = 156
                Top = 162
                Width = 81
                Height = 20
                ReadOnly = True
                TabOrder = 28
                Text = '51'
              end
              object edt_threshold_voltage_loss_r: TEdit
                Left = 156
                Top = 196
                Width = 81
                Height = 20
                ReadOnly = True
                TabOrder = 29
                Text = '52'
              end
              object chk10: TCheckBox
                Left = 16
                Top = 224
                Width = 97
                Height = 17
                Caption = #20840#36873
                TabOrder = 30
                OnClick = chk10Click
              end
              object chk_harm_en: TCheckBox
                Left = 336
                Top = 194
                Width = 113
                Height = 17
                Caption = #22522#27874'/'#35856#27874#20351#33021#65306
                TabOrder = 31
              end
              object edt_harm_en_w: TEdit
                Left = 573
                Top = 196
                Width = 81
                Height = 20
                TabOrder = 32
                Text = '007812'
              end
              object edt_harm_en_r: TEdit
                Left = 480
                Top = 196
                Width = 81
                Height = 20
                TabOrder = 33
                Text = '53'
              end
              object chk_harm_sw: TCheckBox
                Left = 336
                Top = 228
                Width = 129
                Height = 17
                Caption = #22522#27874'/'#35856#27874#20999#25442#36873#25321#65306
                TabOrder = 34
              end
              object edt_harm_sw_w: TEdit
                Left = 573
                Top = 227
                Width = 81
                Height = 20
                TabOrder = 35
                Text = '0055aa'
              end
              object edt_harm_sw_r: TEdit
                Left = 480
                Top = 226
                Width = 81
                Height = 20
                TabOrder = 36
                Text = '54'
              end
              object btn_reg_init: TBitBtn
                Left = 16
                Top = 24
                Width = 129
                Height = 25
                Caption = #24517#35201#23492#23384#22120#21021#22987#21270
                TabOrder = 37
                OnClick = btn_reg_initClick
              end
            end
          end
        end
        object ts3: TTabSheet
          Caption = #19977#30456#26657#34920
          ImageIndex = 2
          object scrlbx4: TScrollBox
            Left = 0
            Top = 0
            Width = 906
            Height = 492
            Align = alClient
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            object grp2: TGroupBox
              Left = 20
              Top = 15
              Width = 422
              Height = 149
              Caption = #30005#21387#30005#27969#26657#20934
              TabOrder = 0
              object grp3: TGroupBox
                Left = 11
                Top = 24
                Width = 150
                Height = 102
                Caption = #30005#21387#26657#20934
                TabOrder = 0
                object lbl_vol_1: TLabel
                  Left = 87
                  Top = 22
                  Width = 37
                  Height = 13
                  Caption = '       V'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clNavy
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object lbl_vol_2: TLabel
                  Left = 87
                  Top = 46
                  Width = 37
                  Height = 13
                  Caption = '       V'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clNavy
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object lbl_vol_3: TLabel
                  Left = 87
                  Top = 70
                  Width = 37
                  Height = 13
                  Caption = '       V'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clNavy
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object chk1: TCheckBox
                  Left = 19
                  Top = 22
                  Width = 65
                  Height = 17
                  Caption = 'A'#30456' 1B'
                  TabOrder = 0
                end
                object chk2: TCheckBox
                  Left = 19
                  Top = 46
                  Width = 65
                  Height = 17
                  Caption = 'B'#30456' 1C'
                  TabOrder = 1
                end
                object chk3: TCheckBox
                  Left = 19
                  Top = 70
                  Width = 65
                  Height = 17
                  Caption = 'C'#30456' 1D'
                  TabOrder = 2
                end
              end
              object grp4: TGroupBox
                Left = 166
                Top = 24
                Width = 156
                Height = 102
                Caption = #30005#27969#26657#20934
                TabOrder = 1
                object lbl_cur_1: TLabel
                  Left = 82
                  Top = 22
                  Width = 37
                  Height = 13
                  Caption = '       A'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clNavy
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object lbl_cur_2: TLabel
                  Left = 82
                  Top = 46
                  Width = 37
                  Height = 13
                  Caption = '       A'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clNavy
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object lbl_cur_3: TLabel
                  Left = 82
                  Top = 70
                  Width = 37
                  Height = 13
                  Caption = '       A'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clNavy
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object chk4: TCheckBox
                  Left = 18
                  Top = 22
                  Width = 65
                  Height = 17
                  Caption = 'A'#30456' 26'
                  TabOrder = 0
                end
                object chk5: TCheckBox
                  Left = 18
                  Top = 46
                  Width = 65
                  Height = 17
                  Caption = 'B'#30456' 27'
                  TabOrder = 1
                end
                object chk6: TCheckBox
                  Left = 18
                  Top = 70
                  Width = 65
                  Height = 17
                  Caption = 'C'#30456' 28'
                  TabOrder = 2
                end
              end
              object btn_init_volcur: TBitBtn
                Left = 333
                Top = 100
                Width = 75
                Height = 25
                Caption = #21021#22987#21270
                TabOrder = 2
                OnClick = btn_init_volcurClick
              end
              object btn_chk_volcur: TBitBtn
                Left = 333
                Top = 63
                Width = 75
                Height = 25
                Caption = #26657#20934
                TabOrder = 3
                OnClick = btn_chk_volcurClick
              end
            end
            object grp6: TGroupBox
              Left = 456
              Top = 15
              Width = 355
              Height = 305
              Caption = #30456#20301#26657#20934
              TabOrder = 1
              object lbl20: TLabel
                Left = 128
                Top = 29
                Width = 22
                Height = 13
                Caption = 'A'#30456
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl21: TLabel
                Left = 40
                Top = 208
                Width = 24
                Height = 12
                Caption = 'ER'#65306
              end
              object lbl22: TLabel
                Left = 144
                Top = 208
                Width = 14
                Height = 13
                Caption = ' %'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl23: TLabel
                Left = 26
                Top = 48
                Width = 96
                Height = 13
                Caption = '100%'#26377#21151#22686#30410#65306
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl24: TLabel
                Left = 26
                Top = 76
                Width = 96
                Height = 13
                Caption = '400%'#26377#21151#22686#30410#65306
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl25: TLabel
                Left = 26
                Top = 105
                Width = 96
                Height = 13
                Caption = '200%'#26377#21151#22686#30410#65306
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl26: TLabel
                Left = 26
                Top = 136
                Width = 97
                Height = 13
                Caption = '  20%'#26377#21151#22686#30410#65306
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl27: TLabel
                Left = 26
                Top = 168
                Width = 97
                Height = 13
                Caption = '  10%'#26377#21151#22686#30410#65306
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl28: TLabel
                Left = 214
                Top = 29
                Width = 22
                Height = 13
                Caption = 'B'#30456
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl29: TLabel
                Left = 296
                Top = 29
                Width = 22
                Height = 13
                Caption = 'C'#30456
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object btn_chk_angle: TBitBtn
                Left = 174
                Top = 198
                Width = 75
                Height = 25
                Caption = #26657#20934
                TabOrder = 0
                OnClick = btn_chk_angleClick
              end
              object btn_init_angle: TBitBtn
                Left = 260
                Top = 198
                Width = 75
                Height = 25
                Caption = #21021#22987#21270
                TabOrder = 1
                OnClick = btn_init_angleClick
              end
              object rb7: TRadioButton
                Left = 125
                Top = 47
                Width = 42
                Height = 17
                Caption = '0C'
                Checked = True
                TabOrder = 2
                TabStop = True
              end
              object rb8: TRadioButton
                Left = 213
                Top = 47
                Width = 42
                Height = 17
                Caption = '11'
                TabOrder = 3
              end
              object rb9: TRadioButton
                Left = 296
                Top = 47
                Width = 42
                Height = 15
                Caption = '16'
                TabOrder = 4
              end
              object edt_err_angle: TEdit
                Left = 75
                Top = 202
                Width = 65
                Height = 20
                TabOrder = 5
                Text = '0.8'
              end
              object rb10: TRadioButton
                Left = 125
                Top = 104
                Width = 42
                Height = 17
                Caption = '0E'
                TabOrder = 6
              end
              object rb11: TRadioButton
                Left = 125
                Top = 74
                Width = 42
                Height = 17
                Caption = '0D'
                TabOrder = 7
              end
              object rb12: TRadioButton
                Left = 125
                Top = 136
                Width = 42
                Height = 17
                Caption = '0F'
                TabOrder = 8
              end
              object rb13: TRadioButton
                Left = 125
                Top = 168
                Width = 42
                Height = 17
                Caption = '10'
                TabOrder = 9
              end
              object rb14: TRadioButton
                Left = 213
                Top = 74
                Width = 42
                Height = 13
                Caption = '12'
                TabOrder = 10
              end
              object rb15: TRadioButton
                Left = 213
                Top = 104
                Width = 42
                Height = 15
                Caption = '13'
                TabOrder = 11
              end
              object rb16: TRadioButton
                Left = 213
                Top = 136
                Width = 42
                Height = 17
                Caption = '14'
                TabOrder = 12
              end
              object rb17: TRadioButton
                Left = 213
                Top = 168
                Width = 42
                Height = 17
                Caption = '15'
                TabOrder = 13
              end
              object rb18: TRadioButton
                Left = 296
                Top = 74
                Width = 42
                Height = 12
                Caption = '17'
                TabOrder = 14
              end
              object rb19: TRadioButton
                Left = 296
                Top = 104
                Width = 42
                Height = 16
                Caption = '18'
                TabOrder = 15
              end
              object rb20: TRadioButton
                Left = 296
                Top = 136
                Width = 42
                Height = 16
                Caption = '19'
                TabOrder = 16
              end
              object rb21: TRadioButton
                Left = 296
                Top = 168
                Width = 42
                Height = 15
                Caption = '1A'
                TabOrder = 17
              end
            end
            object grp5: TGroupBox
              Left = 20
              Top = 172
              Width = 422
              Height = 149
              Caption = #26377#21151#22686#30410#26657#20934
              TabOrder = 2
              object lbl13: TLabel
                Left = 141
                Top = 109
                Width = 14
                Height = 13
                Caption = ' %'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl14: TLabel
                Left = 33
                Top = 109
                Width = 24
                Height = 12
                Caption = 'ER'#65306
              end
              object lbl15: TLabel
                Left = 26
                Top = 40
                Width = 96
                Height = 13
                Caption = '100%'#26377#21151#22686#30410#65306
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl16: TLabel
                Left = 32
                Top = 72
                Width = 89
                Height = 13
                Caption = '10%'#26377#21151#22686#30410#65306
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl17: TLabel
                Left = 129
                Top = 23
                Width = 22
                Height = 13
                Caption = 'A'#30456
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl18: TLabel
                Left = 215
                Top = 23
                Width = 22
                Height = 13
                Caption = 'B'#30456
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lbl19: TLabel
                Left = 297
                Top = 23
                Width = 22
                Height = 13
                Caption = 'C'#30456
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clNavy
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object edt_err_gain: TEdit
                Left = 65
                Top = 105
                Width = 66
                Height = 20
                Color = clCream
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = []
                MaxLength = 12
                ParentFont = False
                TabOrder = 0
                Text = '0.04'
              end
              object btn_chk_gain: TBitBtn
                Left = 170
                Top = 101
                Width = 75
                Height = 25
                Caption = #26657#20934
                TabOrder = 1
                OnClick = btn_chk_gainClick
              end
              object btn_init_gain: TBitBtn
                Left = 256
                Top = 101
                Width = 75
                Height = 25
                Caption = #21021#22987#21270
                TabOrder = 2
                OnClick = btn_init_gainClick
              end
              object rb1: TRadioButton
                Left = 125
                Top = 40
                Width = 42
                Height = 17
                Caption = '06'
                Checked = True
                TabOrder = 3
                TabStop = True
              end
              object rb2: TRadioButton
                Left = 212
                Top = 40
                Width = 42
                Height = 17
                Caption = '07'
                TabOrder = 4
              end
              object rb3: TRadioButton
                Left = 295
                Top = 40
                Width = 42
                Height = 17
                Caption = '08'
                TabOrder = 5
              end
              object rb4: TRadioButton
                Left = 125
                Top = 72
                Width = 42
                Height = 17
                Caption = '09'
                TabOrder = 6
              end
              object rb5: TRadioButton
                Left = 212
                Top = 69
                Width = 42
                Height = 17
                Caption = '0A'
                TabOrder = 7
              end
              object rb6: TRadioButton
                Left = 295
                Top = 70
                Width = 42
                Height = 17
                Caption = '0B'
                TabOrder = 8
              end
            end
            object btn1: TBitBtn
              Left = 232
              Top = 328
              Width = 75
              Height = 25
              Caption = 'btn1'
              TabOrder = 3
              Visible = False
              OnClick = btn1Click
            end
            object edt1: TEdit
              Left = 152
              Top = 328
              Width = 65
              Height = 20
              TabOrder = 4
              Text = '0d'
              Visible = False
            end
          end
        end
        object ts5: TTabSheet
          Caption = #30452#27969#27169#25311#37327#26657#20934
          ImageIndex = 4
          object scrlbx6: TScrollBox
            Left = 0
            Top = 0
            Width = 906
            Height = 492
            Align = alClient
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            object grp8: TGroupBox
              Left = 20
              Top = 15
              Width = 349
              Height = 186
              Caption = #30452#27969#27169#25311#37327#26657#20934
              TabOrder = 0
              object lbl31: TLabel
                Left = 40
                Top = 34
                Width = 42
                Height = 12
                Caption = #36755#20837#20540'1'
              end
              object lbl32: TLabel
                Left = 40
                Top = 68
                Width = 42
                Height = 12
                Caption = #36755#20837#20540'2'
              end
              object lbl33: TLabel
                Left = 40
                Top = 102
                Width = 48
                Height = 12
                Caption = #26657#20934#21442#25968
              end
              object lbl34: TLabel
                Left = 40
                Top = 136
                Width = 36
                Height = 12
                Caption = #24403#21069#20540
              end
              object edt_input_1: TEdit
                Left = 96
                Top = 30
                Width = 121
                Height = 20
                TabOrder = 0
                Text = '5.00'
              end
              object edt_input_2: TEdit
                Left = 96
                Top = 64
                Width = 121
                Height = 20
                TabOrder = 1
                Text = '15.00'
              end
              object edt_chk_param: TEdit
                Left = 96
                Top = 98
                Width = 121
                Height = 20
                Color = clBtnFace
                ReadOnly = True
                TabOrder = 2
              end
              object btn_chk_param: TBitBtn
                Left = 232
                Top = 95
                Width = 75
                Height = 25
                Caption = #26657#20934
                TabOrder = 3
                OnClick = btn_chk_paramClick
              end
              object btn_cur_dc_value: TBitBtn
                Left = 232
                Top = 129
                Width = 75
                Height = 25
                Caption = #35835#21462
                TabOrder = 4
                OnClick = btn_cur_dc_valueClick
              end
              object edt_cur_dc_value: TEdit
                Left = 96
                Top = 132
                Width = 121
                Height = 20
                Color = clBtnFace
                ReadOnly = True
                TabOrder = 5
              end
              object btn_input_1: TBitBtn
                Left = 232
                Top = 27
                Width = 75
                Height = 25
                Caption = #30830#23450
                TabOrder = 6
                OnClick = btn_input_1Click
              end
              object btn_input_2: TBitBtn
                Left = 232
                Top = 61
                Width = 75
                Height = 25
                Caption = #30830#23450
                TabOrder = 7
                OnClick = btn_input_2Click
              end
            end
          end
        end
        object ts4: TTabSheet
          Caption = #35843#35797
          ImageIndex = 3
          object scrlbx5: TScrollBox
            Left = 0
            Top = 0
            Width = 906
            Height = 492
            Align = alClient
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            object grp7: TGroupBox
              Left = 20
              Top = 15
              Width = 741
              Height = 266
              Caption = #35843#35797
              TabOrder = 0
              object lbl8: TLabel
                Left = 288
                Top = 32
                Width = 24
                Height = 12
                Caption = #21327#35758
                Visible = False
              end
              object lbl9: TLabel
                Left = 40
                Top = 34
                Width = 36
                Height = 12
                Caption = #25511#21046#23383
              end
              object lbl5: TLabel
                Left = 40
                Top = 68
                Width = 36
                Height = 12
                Caption = #26631#35782#31526
              end
              object lbl10: TLabel
                Left = 40
                Top = 102
                Width = 48
                Height = 12
                Caption = #25968#25454#21333#20803
              end
              object lbl11: TLabel
                Left = 40
                Top = 136
                Width = 36
                Height = 12
                Caption = #29983#25104#24103
              end
              object lbl12: TLabel
                Left = 40
                Top = 168
                Width = 48
                Height = 12
                Caption = #34920#24212#31572#24103
              end
              object cbb_pro: TComboBox
                Left = 344
                Top = 28
                Width = 121
                Height = 20
                Style = csDropDownList
                ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
                ItemHeight = 12
                ItemIndex = 1
                TabOrder = 0
                Text = '07'#35268#32422
                Visible = False
                Items.Strings = (
                  '97'#35268#32422
                  '07'#35268#32422)
              end
              object edt_ctrl: TEdit
                Left = 96
                Top = 30
                Width = 121
                Height = 20
                TabOrder = 1
                Text = '11'
              end
              object edt_di: TEdit
                Left = 96
                Top = 64
                Width = 121
                Height = 20
                TabOrder = 2
                Text = '00010000'
              end
              object edt_dataunit: TEdit
                Left = 96
                Top = 98
                Width = 500
                Height = 20
                TabOrder = 3
              end
              object btn_create_frame: TBitBtn
                Left = 96
                Top = 208
                Width = 75
                Height = 25
                Caption = #29983#25104
                TabOrder = 4
                OnClick = btn_create_frameClick
              end
              object btn_send: TBitBtn
                Left = 184
                Top = 208
                Width = 75
                Height = 25
                Caption = #21457#36865
                TabOrder = 5
                OnClick = btn_sendClick
              end
              object edt_frame: TEdit
                Left = 96
                Top = 132
                Width = 500
                Height = 20
                TabOrder = 6
              end
              object edt_meter_resp: TEdit
                Left = 96
                Top = 164
                Width = 500
                Height = 20
                TabOrder = 7
              end
            end
          end
        end
      end
      object pnl2: TPanel
        Left = 1
        Top = 1
        Width = 914
        Height = 41
        Align = alTop
        Color = 13093572
        TabOrder = 1
        object txt1: TStaticText
          Left = 16
          Top = 16
          Width = 40
          Height = 16
          Caption = #34920#21495#65306
          TabOrder = 0
        end
        object edt_meterno: TEdit
          Left = 58
          Top = 11
          Width = 87
          Height = 20
          MaxLength = 12
          TabOrder = 1
          Text = '999999999999'
          OnKeyUp = edt_meternoKeyUp
        end
        object txt2: TStaticText
          Left = 168
          Top = 16
          Width = 52
          Height = 16
          Caption = #34920#23494#30721#65306
          TabOrder = 2
        end
        object edt_meter_pwd: TEdit
          Left = 218
          Top = 11
          Width = 87
          Height = 20
          MaxLength = 8
          TabOrder = 3
          Text = '66709600'
          OnKeyUp = edt_meter_pwdKeyUp
        end
      end
    end
  end
end
