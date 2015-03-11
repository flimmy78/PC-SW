unit U_Param_Con;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_ParamReadWrite, StdCtrls, Buttons, U_MyFunction, ComCtrls,
  DateUtils, StrUtils;

type
  TF_Param_Con = class(TF_ParamReadWrite)
    btn_read_param: TBitBtn;
    btn_write_param: TBitBtn;
    chk1: TCheckBox;
    chk_con_time: TCheckBox;
    edt_con_time_r: TEdit;
    dtp_con_date_w: TDateTimePicker;
    dtp_con_time_w: TDateTimePicker;
    chk_sys_cfg: TCheckBox;
    edt_sloshing_keeptime_r: TEdit;
    edt_sloshing_keeptime_w: TEdit;
    chk_use_systime: TCheckBox;
    lbl1: TLabel;
    cbb_sloshing_switch_r: TComboBox;
    cbb_sloshing_switch_w: TComboBox;
    cbb_again_switch_r: TComboBox;
    cbb_again_switch_w: TComboBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    edt_again_keeptime_r: TEdit;
    lbl5: TLabel;
    edt_dev_addr_r: TEdit;
    lbl6: TLabel;
    edt_again_voltage_r: TEdit;
    edt_again_keeptime_w: TEdit;
    edt_again_voltage_w: TEdit;
    edt_dev_addr_w: TEdit;
    lbl7: TLabel;
    cbb_again_mode_r: TComboBox;
    cbb_again_mode_w: TComboBox;
    lbl8: TLabel;
    edt_again_max_delay_r: TEdit;
    edt_again_max_delay_w: TEdit;
    procedure btn_read_paramClick(Sender: TObject);
    procedure btn_write_paramClick(Sender: TObject);
    procedure chk1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Param_Con: TF_Param_Con;

implementation

uses U_Protocol,U_Protocol_con, U_Main;
{$R *.dfm}

procedure TF_Param_Con.btn_read_paramClick(Sender: TObject);
var chk:TCheckBox;
    p:PByte;
    dataUnit:array[0..63]of Byte;
    strTmp:string;
    i, nCount:Integer;
    nTmp:Int64;
    pVersions:P_CFG_INFO_VERSIONS;
const weekCaption:array[0..6] of string = ('星期天', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六');
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    //系统时间
    chk := chk_con_time;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        edt_con_time_r.Text := '';
        MakeFrame(MODBUS_READ_REG, MODBUS_TIME_START_ADDR, 5);
        if F_Main.SendDataAuto()
          and WaitForResp(chk, MODBUS_READ_REG)
        then
        begin
            p := O_ProRx.GetUserData();
            Inc(p, 1);
            edt_con_time_r.Text := Format('%.4d-%.2d-%.2d %.2d:%.2d:%.2d %d %s', [
                mb_swap(PWord(Integer(p)+0)^),
                PByte(Integer(p)+2)^,
                PByte(Integer(p)+3)^,
                PByte(Integer(p)+5)^,
                PByte(Integer(p)+6)^,
                PByte(Integer(p)+7)^,
                mb_swap(PWord(Integer(p)+8)^),
                weekCaption[PByte(Integer(p)+4)^ mod 7]
                ]);
        end;
    end;

    //系统配置
    chk := chk_sys_cfg;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;

        cbb_sloshing_switch_r.ItemIndex := -1;
        cbb_again_switch_r.ItemIndex := -1;
        cbb_again_mode_r.ItemIndex := -1;
        edt_sloshing_keeptime_r.Text := '';
        edt_again_keeptime_r.Text := '';
        edt_again_voltage_r.Text := '';
        edt_again_max_delay_r.Text := '';
        edt_dev_addr_r.Text := '';

        MakeFrame(MODBUS_EXT_READ_REG, MODBUS_CONF_START_ADDR, 7);
        
        if F_Main.SendDataAuto()
          and WaitForResp(chk, MODBUS_EXT_READ_REG)
        then
        begin
            p := O_ProRx.GetUserData();

            Inc(p);
            nTmp := mb_swap_32(PLongWord(p)^);  Inc(p, 4);
            cbb_sloshing_switch_r.ItemIndex     := (nTmp shr 0 and $00000001);
            cbb_again_switch_r.ItemIndex        := (nTmp shr 1 and $00000001);
            cbb_again_mode_r.ItemIndex          := (nTmp shr 2 and $00000001);

            nTmp := mb_swap(PWord(p)^);         Inc(p, 2);
            edt_sloshing_keeptime_r.Text        := Format('%d', [nTmp]);

            nTmp := mb_swap(PWord(p)^);         Inc(p, 2);
            edt_again_keeptime_r.Text           := Format('%d', [nTmp*100]);

            nTmp := mb_swap(PWord(p)^);         Inc(p, 2);
            edt_again_voltage_r.Text            := Format('%d', [nTmp]);

            nTmp := mb_swap(PWord(p)^);         Inc(p, 2);
            edt_again_max_delay_r.Text          := Format('%d', [nTmp]);
            
            nTmp := mb_swap(PWord(p)^);         Inc(p, 2);
            edt_dev_addr_r.Text                 := Format('%.3d', [nTmp]);
        end;
    end;
    
{
    chk := chk_con_version;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        edt_con_version.Text := '';
        MakeFrame(AFN_READ_CFG_IFO,F1);
        if F_Main.SendDataAuto()
          and WaitForResp(chk,AFN_READ_CFG_IFO,F1)
        then
        begin
            edt_con_version.Text := O_ProRx.GetDevVersion();
        end;
    end;
    }
{

    chk := chk_dcanalog;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        edt_dcanalog_r.Text := '';
        MakeFrame(AFN_CLASS_1,F73,nil,0,1);
        if F_Main.SendDataAuto()
          and WaitForResp(chk,AFN_CLASS_1,F73)
        then
        begin
            p := GetDataUnit();
            //edt_dcanalog_r.Text := Format('%d',[Round(T_Protocol_con.DatabufToFloat(p, 2))]);
            edt_dcanalog_r.Text := Format('%.3f',[T_Protocol_con.DatabufToFloat(p, 2)]);
        end;
    end;

    chk := chk_con_name;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        edt_con_name_r.Text := '';
        MakeFrame(AFN_READ_PARAM,F97);
        if F_Main.SendDataAuto()
          and WaitForResp(chk,AFN_READ_PARAM,F97)
        then
        begin
            edt_con_name_r.Text := O_ProRx.GetDevName();
        end;
    end;

    //集中器地址
    chk := chk_Addr;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        edt_Addr_r.Text := '';
        MakeFrame(AFN_READ_PARAM, F100);
        if F_Main.SendDataAuto()
          and WaitForResp(chk, AFN_READ_PARAM,F100)
        then
        begin
            p := GetDataUnit();
            edt_Addr_r.Text := Format('%.4x%.5d', [ PWord(Integer(p)+0)^, PWord(Integer(p)+2)^ ])
        end;
    end;
 }

{
    chk := chk_acs_crc;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        cbb_acs_crc.ItemIndex := -1;
        MakeFrame(AFN_READ_PARAM,F98);
        if F_Main.SendDataAuto()
          and WaitForResp(chk,AFN_READ_PARAM,F98)
        then
        begin
            p := GetDataUnit();
            if p^=0 then
            begin
                cbb_acs_crc.ItemIndex := 0;
            end
            else
            begin
                cbb_acs_crc.ItemIndex := 1;
            end;
        end;
    end;

    //版本信息
    chk := chk_read_versions;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        edt_read_versions.Text := '';
        MakeFrame(AFN_READ_PARAM, F99);
        if F_Main.SendDataAuto()
          and WaitForResp(chk, AFN_READ_PARAM, F99)
        then
        begin
            p := O_ProRx.GetDataUnit;

            pVersions := P_CFG_INFO_VERSIONS(p);

            if GPRS_FLAG_HUAWEI=pVersions.gprsModeFlag then
            begin
                edt_read_versions.Text := edt_read_versions.Text + 'GPRS：华为';
            end
            else if GPRS_FLAG_YOUFANG=pVersions.gprsModeFlag then
            begin
                edt_read_versions.Text := edt_read_versions.Text + 'GPRS：有方';
            end;
            if FREEZE_FLAG_LAST_DAY=pVersions.freezeFlag then
            begin
                edt_read_versions.Text := edt_read_versions.Text + '；冻结：上一日';
            end
            else if FREEZE_FLAG_CURRENT=pVersions.freezeFlag then
            begin
                edt_read_versions.Text := edt_read_versions.Text + '；冻结：当前';
            end;
            if CUSTOMER_FLAG_XIAOCHENG=pVersions.customerFlag then
            begin
                edt_read_versions.Text := edt_read_versions.Text + '；客户：XC';
            end
            else if CUSTOMER_FLAG_ZAHT=pVersions.customerFlag then
            begin
                edt_read_versions.Text := edt_read_versions.Text + '；客户：ZAHT';
            end;
            if ACS_FLAG_NOT_ON_CONCENTRATOR=pVersions.acsFlag then
            begin
                edt_read_versions.Text := edt_read_versions.Text + '；交采：旧';
            end
            else if ACS_FLAG_ON_CONCENTRATOR=pVersions.acsFlag then
            begin
                edt_read_versions.Text := edt_read_versions.Text + '；交采：新';
            end;
        end;
    end;

    //nCount
    //表计统计
    chk := chk_meter_count;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        edt_meter_count.Text := '';
        MakeFrame(AFN_CLASS_1, F11);
        if F_Main.SendDataAuto()
          and WaitForResp(chk, AFN_CLASS_1, F11)
        then
        begin
            p := O_ProRx.GetDataUnit;
            nCount := p^;
            Inc(p);
            if nCount<=10 then
            begin
                for i:=1 to nCount do
                begin
                    if p^=1 then
                    begin
                        edt_meter_count.Text := edt_meter_count.Text + Format('交采数：%d；', [PWord(Integer(p)+1)^]);
                    end
                    else if p^=2 then
                    begin
                        edt_meter_count.Text := edt_meter_count.Text + Format('485表数：%d；', [PWord(Integer(p)+1)^]);
                    end
                    else if p^=31 then
                    begin
                        edt_meter_count.Text := edt_meter_count.Text + Format('载波表数：%d，已抄读：%d；', [PWord(Integer(p)+1)^, PWord(Integer(p)+4)^]);
                    end;
                    Inc(p, 19);
                end;
            end;
        end;
    end;

    //模式设置
    chk := chk_sys_mode;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        cbb_sys_mode.ItemIndex := -1;
        MakeFrame(AFN_READ_PARAM,F102);
        if F_Main.SendDataAuto()
          and WaitForResp(chk,AFN_READ_PARAM,F102)
        then
        begin
            p := GetDataUnit();
            cbb_sys_mode.ItemIndex := p^;
        end;
    end;
}
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_Con.btn_write_paramClick(Sender: TObject);
var chk:TCheckBox;
    i,p:Integer;
    dataUnit:array[0..63]of Byte;
    ur1,ur2:userarray;
    conTime:TDateTime;
    nTmp:Int64;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    //系统时间
    chk := chk_con_time;
    if chk.Checked then
    begin
        chk.Font.Color := clBlack;

        conTime := Now;
        if not chk_use_systime.Checked then
        begin
            dtp_con_date_w.Time := dtp_con_time_w.Time;
            conTime := dtp_con_date_w.DateTime;
        end;
        
        p := 0;

        PWord(@dataUnit[p])^   := mb_swap(Word(5));  Inc(p, 2);
        
        dataUnit[p] := 10; Inc(p);
       
        Pword(@dataUnit[p])^ := mb_swap(YearOf(conTime)); Inc(p, 2);
        dataUnit[p] := (MonthOf(conTime));  Inc(p);
        dataUnit[p] := (DayOf(conTime));    Inc(p);

        dataUnit[p] := (DayOfTheWeek(conTime));
        if dataUnit[p]=7 then dataUnit[p] := 0;
        Inc(p);

        dataUnit[p] := (HourOf(conTime));   Inc(p);
        dataUnit[p] := (MinuteOf(conTime)); Inc(p);
        dataUnit[p] := (SecondOf(conTime)); Inc(p);
        Pword(@dataUnit[p])^ := mb_swap(MilliSecondOf(conTime)); Inc(p, 2);
        
        MakeFrame(MODBUS_WRITE_REG, MODBUS_TIME_START_ADDR, @dataUnit[0], p);
        if F_Main.SendDataAuto()
          and WaitForResp(chk, MODBUS_WRITE_REG)
        then
        begin
        end;
    end;
    
    //系统配置
    chk := chk_sys_cfg;
    if chk.Checked then
    begin
        chk.Font.Color := clBlack;

        p := 0;

        PWord(@dataUnit[p])^   := mb_swap(Word(7));  Inc(p, 2);
        
        dataUnit[p] := 14; Inc(p);
        
        nTmp := (cbb_sloshing_switch_w.ItemIndex) or (cbb_again_switch_w.ItemIndex shl 1) or (cbb_again_mode_w.ItemIndex shl 2);
        PLongWord(@dataUnit[p])^ := mb_swap_32(nTmp); Inc(p, 4);

        TryStrToInt64(edt_sloshing_keeptime_w.Text, nTmp);
        PWord(@dataUnit[p])^ := mb_swap(nTmp); Inc(p, 2);

        TryStrToInt64(edt_again_keeptime_w.Text, nTmp);
        PWord(@dataUnit[p])^ := mb_swap(nTmp div 100); Inc(p, 2);
        
        TryStrToInt64(edt_again_voltage_w.Text, nTmp);
        PWord(@dataUnit[p])^ := mb_swap(nTmp); Inc(p, 2);

        TryStrToInt64(edt_again_max_delay_w.Text, nTmp);
        PWord(@dataUnit[p])^ := mb_swap(nTmp); Inc(p, 2);
            
        TryStrToInt64(edt_dev_addr_w.Text, nTmp);
        PWord(@dataUnit[p])^ := mb_swap(nTmp); Inc(p, 2);

        MakeFrame(MODBUS_EXT_WRITE_REG, MODBUS_CONF_START_ADDR, @dataUnit[0], p);
        if F_Main.SendDataAuto()
          and WaitForResp(chk, MODBUS_EXT_WRITE_REG)
        then
        begin
        end;
    end;
{

    chk := chk_acs_crc;
    if chk.Checked then
    begin
        chk.Font.Color := clBlack;
        dataUnit[0] := cbb_acs_crc.ItemIndex;
        MakeFrame(AFN_WRITE_PARAM, F98, @dataUnit[0], 1);
        if F_Main.SendDataAuto()
          and WaitForResp(chk,AFN_CONFIRM,F1)
        then
        begin
        end;
    end;

    chk := chk_sys_mode;
    if chk.Checked then
    begin
        chk.Font.Color := clBlack;
        dataUnit[0] := cbb_sys_mode.ItemIndex;
        MakeFrame(AFN_WRITE_PARAM, F102, @dataUnit[0], 1);
        if F_Main.SendDataAuto()
          and WaitForResp(chk,AFN_CONFIRM,F1)
        then
        begin
        end;
    end;
}
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_Con.chk1Click(Sender: TObject);
begin
    MakeCheck(TCheckBox(Sender).Parent, TCheckBox(Sender).Checked);
end;

procedure TF_Param_Con.FormCreate(Sender: TObject);
begin
    inherited;
    dtp_con_date_w.DateTime := Now;
    dtp_con_time_w.DateTime := Now;
end;

end.
