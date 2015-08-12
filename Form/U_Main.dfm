object F_Main: TF_Main
  Left = 219
  Top = 197
  Width = 1092
  Height = 546
  Caption = 'Delphi'
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 1076
    Height = 489
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object spl2: TSplitter
      Left = 0
      Top = 49
      Width = 5
      Height = 440
    end
    object pnl2: TPanel
      Left = 0
      Top = 0
      Width = 1076
      Height = 49
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Color = 13093572
      TabOrder = 0
      object lbl1: TLabel
        Left = 16
        Top = 17
        Width = 48
        Height = 12
        Caption = #36890#35759#35774#32622
      end
      object lbl7: TLabel
        Left = 672
        Top = 17
        Width = 24
        Height = 12
        Caption = #36229#26102
        Visible = False
      end
      object cbb_ConnMode: TComboBox
        Left = 71
        Top = 13
        Width = 60
        Height = 20
        Style = csDropDownList
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 0
        Text = #20018#21475
        OnChange = cbb_ConnModeChange
        Items.Strings = (
          #20018#21475
          'GPRS'#26381#21153#22120
          'GPRS'#23458#25143#31471)
      end
      object cbb_Comm: TComboBox
        Left = 131
        Top = 13
        Width = 60
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 1
        Text = 'COM1'
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4'
          'COM5'
          'COM6'
          'COM7'
          'COM8'
          'COM9')
      end
      object cbb_Baudrate: TComboBox
        Left = 190
        Top = 13
        Width = 60
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 12
        ItemIndex = 9
        TabOrder = 2
        Text = '9600'
        Items.Strings = (
          '50'
          '75'
          '100'
          '150'
          '300'
          '600'
          '1200'
          '2400'
          '4800'
          '9600'
          '19200'
          '38400'
          '56000'
          '57600'
          '115200')
      end
      object btnConn: TBitBtn
        Left = 791
        Top = 13
        Width = 75
        Height = 22
        Caption = #36830#25509
        TabOrder = 3
        OnClick = btnConnClick
      end
      object btnDisConn: TBitBtn
        Left = 886
        Top = 13
        Width = 75
        Height = 22
        Caption = #26029#24320
        Enabled = False
        TabOrder = 4
        OnClick = btnDisConnClick
      end
      object btn_stop: TBitBtn
        Left = 1076
        Top = 13
        Width = 75
        Height = 22
        Caption = #20572#27490
        TabOrder = 5
        Visible = False
        OnClick = btn_stopClick
      end
      object btn_Clear: TBitBtn
        Left = 981
        Top = 13
        Width = 75
        Height = 22
        Caption = #28165#31354
        TabOrder = 6
        OnClick = btn_ClearClick
      end
      object cbb_Parity: TComboBox
        Left = 249
        Top = 13
        Width = 92
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 7
        Text = 'NOPARITY'
        Items.Strings = (
          'NOPARITY'
          'ODDPARITY'
          'EVENPARITY'
          'MARKPARITY'
          'SPACEPARITY')
      end
      object txt1: TStaticText
        Left = 529
        Top = 17
        Width = 52
        Height = 16
        Caption = #35774#22791#22320#22336
        TabOrder = 8
        Visible = False
      end
      object edt_con_addr: TEdit
        Left = 582
        Top = 13
        Width = 63
        Height = 20
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        MaxLength = 9
        TabOrder = 9
        Text = '001'
        Visible = False
        OnKeyUp = edt_con_addrKeyUp
      end
      object pnl4: TPanel
        Left = 960
        Top = 2
        Width = 114
        Height = 45
        Align = alRight
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 10
        OnMouseMove = pnl4MouseMove
        object txt_sel_protocol: TStaticText
          Left = 13
          Top = 16
          Width = 76
          Height = 16
          Cursor = crHandPoint
          Caption = #36719#20214#21151#33021#36873#25321
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = [fsUnderline]
          ParentFont = False
          TabOrder = 0
          Visible = False
          OnClick = txt_sel_protocolClick
          OnMouseMove = txt_sel_protocolMouseMove
          OnMouseUp = txt_sel_protocolMouseUp
        end
      end
      object edt_timeout: TEdit
        Left = 700
        Top = 13
        Width = 49
        Height = 20
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        MaxLength = 12
        TabOrder = 11
        Text = '30'
        Visible = False
        OnKeyUp = edt_timeoutKeyUp
      end
      object cbb_DataBits: TComboBox
        Left = 340
        Top = 13
        Width = 60
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 12
        ItemIndex = 3
        TabOrder = 12
        Text = '8'
        Items.Strings = (
          '5'
          '6'
          '7'
          '8')
      end
      object cbb_StopBits: TComboBox
        Left = 399
        Top = 13
        Width = 98
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 13
        Text = 'ONESTOPBIT'
        Items.Strings = (
          'ONESTOPBIT'
          'ONE5STOPBITS'
          'TWOSTOPBITS')
      end
    end
    object pnl3: TPanel
      Left = 5
      Top = 49
      Width = 1071
      Height = 440
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnl3'
      TabOrder = 1
      object spl1: TSplitter
        Left = 0
        Top = 255
        Width = 1071
        Height = 5
        Cursor = crVSplit
        Align = alBottom
      end
      object pgc1: TPageControl
        Left = 0
        Top = 0
        Width = 1071
        Height = 255
        ActivePage = ts_rdt
        Align = alClient
        TabOrder = 0
        object ts_update: TTabSheet
          Caption = #21319#32423
          TabVisible = False
        end
        object ts_param_read_write: TTabSheet
          Caption = #21442#25968#25220#35774
          ImageIndex = 2
        end
        object ts_status: TTabSheet
          Caption = #31995#32479#29366#24577
          ImageIndex = 5
        end
        object ts_meter_file: TTabSheet
          Caption = #31995#32479#35760#24405
          ImageIndex = 4
        end
        object ts_sys_ctrl: TTabSheet
          Caption = #31995#32479#25511#21046
          ImageIndex = 6
        end
        object ts_chkmeter: TTabSheet
          Caption = #21442#25968#26657#20934
          ImageIndex = 5
        end
        object ts_debug: TTabSheet
          Caption = #35843#35797
          ImageIndex = 4
        end
        object ts_rdt: TTabSheet
          Caption = #26080#32447#36879#20256
          ImageIndex = 7
        end
        object ts_key: TTabSheet
          Caption = #26080#32447#38053#21273
          ImageIndex = 8
        end
        object ts_temp: TTabSheet
          Caption = #28201#25511#26495
          ImageIndex = 9
        end
        object ts_noise: TTabSheet
          Caption = #22122#22768#26657#20934
          ImageIndex = 10
        end
        object ts_pda: TTabSheet
          Caption = #25484#26426
          ImageIndex = 11
        end
      end
      object pgc2: TPageControl
        Left = 0
        Top = 260
        Width = 1071
        Height = 180
        ActivePage = ts_operation
        Align = alBottom
        TabOrder = 1
        object ts_operation: TTabSheet
          Caption = #25805#20316
        end
        object ts_frame: TTabSheet
          Caption = #25253#25991
          ImageIndex = 1
        end
      end
    end
  end
  object stat_bar: TStatusBar
    Left = 0
    Top = 489
    Width = 1076
    Height = 19
    Panels = <
      item
        Width = 500
      end
      item
        Width = 150
      end
      item
        Width = 350
      end
      item
        Width = 50
      end>
  end
  object tmr1: TTimer
    OnTimer = tmr1Timer
    Left = 653
    Top = 465
  end
end
