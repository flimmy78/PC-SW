unit U_Param_ChkMeter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_ParamReadWrite, StdCtrls, Buttons, ComCtrls, ExtCtrls, Mask, U_Protocol_con;

type TUn = (Ua, Ub, Uc);
type
  TF_Param_ChkMeter = class(TF_ParamReadWrite)
    pnl1: TPanel;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    pnl2: TPanel;
    txt1: TStaticText;
    edt_meterno: TEdit;
    txt2: TStaticText;
    edt_meter_pwd: TEdit;
    ts3: TTabSheet;
    scrlbx2: TScrollBox;
    grp_param: TGroupBox;
    lbl1: TLabel;
    lbl3: TLabel;
    lbl2: TLabel;
    lbl4: TLabel;
    lbl_Imin: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    chk_meter_const: TCheckBox;
    edt_meter_const_r: TEdit;
    cbb_meter_const_w: TComboBox;
    cbb_remote_const_w: TComboBox;
    chk_remote_const: TCheckBox;
    chk_Ib: TCheckBox;
    edt_Ib_r: TEdit;
    medt_Ib_w: TMaskEdit;
    medt_Ub_w: TMaskEdit;
    edt_Ub_r: TEdit;
    chk_Ub: TCheckBox;
    chk_Imax: TCheckBox;
    edt_Imin_r: TEdit;
    medt_Imin_w: TMaskEdit;
    medt_Imax_w: TMaskEdit;
    edt_Imax_r: TEdit;
    edt_remote_const_r: TEdit;
    btn_read_param: TBitBtn;
    btn_write_param: TBitBtn;
    chk_all: TCheckBox;
    scrlbx3: TScrollBox;
    grp1: TGroupBox;
    btn_init_reg: TBitBtn;
    btn_write_reg: TBitBtn;
    chk_threshold_voltage_loss: TCheckBox;
    chk_comb_phase: TCheckBox;
    chk_area: TCheckBox;
    chk_boot_cur: TCheckBox;
    chk_pulse: TCheckBox;
    edt_pulse_w: TEdit;
    edt_boot_cur_w: TEdit;
    edt_comb_phase_w: TEdit;
    edt_area_w: TEdit;
    edt_threshold_voltage_loss_w: TEdit;
    edt_phase_angle4_w: TEdit;
    edt_phase_angle1_w: TEdit;
    edt_phase_angle2_w: TEdit;
    edt_phase_angle3_w: TEdit;
    chk_phase_angle1: TCheckBox;
    chk_phase_angle2: TCheckBox;
    chk_phase_angle3: TCheckBox;
    chk_phase_angle4: TCheckBox;
    btn_read_reg: TBitBtn;
    edt_area_r: TEdit;
    edt_boot_cur_r: TEdit;
    edt_pulse_r: TEdit;
    edt_phase_angle1_r: TEdit;
    edt_phase_angle2_r: TEdit;
    edt_phase_angle3_r: TEdit;
    edt_phase_angle4_r: TEdit;
    edt_comb_phase_r: TEdit;
    edt_threshold_voltage_loss_r: TEdit;
    chk10: TCheckBox;
    chk_harm_en: TCheckBox;
    edt_harm_en_w: TEdit;
    edt_harm_en_r: TEdit;
    chk_harm_sw: TCheckBox;
    edt_harm_sw_w: TEdit;
    edt_harm_sw_r: TEdit;
    btn_reg_init: TBitBtn;
    scrlbx4: TScrollBox;
    grp2: TGroupBox;
    grp3: TGroupBox;
    lbl_vol_1: TLabel;
    lbl_vol_2: TLabel;
    lbl_vol_3: TLabel;
    chk1: TCheckBox;
    chk2: TCheckBox;
    chk3: TCheckBox;
    grp4: TGroupBox;
    lbl_cur_1: TLabel;
    lbl_cur_2: TLabel;
    lbl_cur_3: TLabel;
    chk4: TCheckBox;
    chk5: TCheckBox;
    chk6: TCheckBox;
    btn_init_volcur: TBitBtn;
    btn_chk_volcur: TBitBtn;
    grp6: TGroupBox;
    lbl20: TLabel;
    lbl21: TLabel;
    lbl22: TLabel;
    lbl23: TLabel;
    lbl24: TLabel;
    lbl25: TLabel;
    lbl26: TLabel;
    lbl27: TLabel;
    lbl28: TLabel;
    lbl29: TLabel;
    btn_chk_angle: TBitBtn;
    btn_init_angle: TBitBtn;
    rb7: TRadioButton;
    rb8: TRadioButton;
    rb9: TRadioButton;
    edt_err_angle: TEdit;
    rb10: TRadioButton;
    rb11: TRadioButton;
    rb12: TRadioButton;
    rb13: TRadioButton;
    rb14: TRadioButton;
    rb15: TRadioButton;
    rb16: TRadioButton;
    rb17: TRadioButton;
    rb18: TRadioButton;
    rb19: TRadioButton;
    rb20: TRadioButton;
    rb21: TRadioButton;
    grp5: TGroupBox;
    lbl13: TLabel;
    lbl14: TLabel;
    lbl15: TLabel;
    lbl16: TLabel;
    lbl17: TLabel;
    lbl18: TLabel;
    lbl19: TLabel;
    edt_err_gain: TEdit;
    btn_chk_gain: TBitBtn;
    btn_init_gain: TBitBtn;
    rb1: TRadioButton;
    rb2: TRadioButton;
    rb3: TRadioButton;
    rb4: TRadioButton;
    rb5: TRadioButton;
    rb6: TRadioButton;
    chk_voltage: TCheckBox;
    edt_voltage: TEdit;
    chk_current: TCheckBox;
    edt_current: TEdit;
    ts4: TTabSheet;
    scrlbx5: TScrollBox;
    grp7: TGroupBox;
    lbl8: TLabel;
    cbb_pro: TComboBox;
    lbl9: TLabel;
    edt_ctrl: TEdit;
    lbl5: TLabel;
    edt_di: TEdit;
    lbl10: TLabel;
    edt_dataunit: TEdit;
    btn_create_frame: TBitBtn;
    btn_send: TBitBtn;
    lbl11: TLabel;
    edt_frame: TEdit;
    lbl12: TLabel;
    edt_meter_resp: TEdit;
    btn1: TBitBtn;
    edt1: TEdit;
    chk_acs_version: TCheckBox;
    edt_acs_version: TEdit;
    ts5: TTabSheet;
    scrlbx6: TScrollBox;
    grp8: TGroupBox;
    lbl31: TLabel;
    lbl32: TLabel;
    lbl33: TLabel;
    lbl34: TLabel;
    edt_input_1: TEdit;
    edt_input_2: TEdit;
    edt_chk_param: TEdit;
    btn_chk_param: TBitBtn;
    btn_cur_dc_value: TBitBtn;
    edt_cur_dc_value: TEdit;
    btn_input_1: TBitBtn;
    btn_input_2: TBitBtn;
    procedure btn_reg_initClick(Sender: TObject);
    procedure chk_allClick(Sender: TObject);
    procedure btn_read_paramClick(Sender: TObject);
    procedure btn_write_paramClick(Sender: TObject);
    procedure chk10Click(Sender: TObject);
    procedure btn_read_regClick(Sender: TObject);
    procedure btn_write_regClick(Sender: TObject);
    procedure btn_init_regClick(Sender: TObject);
    procedure btn_init_volcurClick(Sender: TObject);
    procedure btn_chk_volcurClick(Sender: TObject);
    procedure btn_init_gainClick(Sender: TObject);
    procedure btn_chk_gainClick(Sender: TObject);
    procedure btn_init_angleClick(Sender: TObject);
    procedure btn_chk_angleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_meter_pwdKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_create_frameClick(Sender: TObject);
    procedure btn_sendClick(Sender: TObject);
    procedure edt_meternoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn1Click(Sender: TObject);
    procedure btn_input_1Click(Sender: TObject);
    procedure btn_input_2Click(Sender: TObject);
    procedure btn_chk_paramClick(Sender: TObject);
    procedure btn_cur_dc_valueClick(Sender: TObject);
  private
    { Private declarations }
    //m_pData:PByte;  //ָ��Ӧ��֡�����ݵ�Ԫ
    //m_data:Int64;   //�洢Ӧ��֡�����ݵ�Ԫ��������ֽڿ�ʼ
    //m_nLen:Integer; //�洢Ӧ��֡�����ݵ�Ԫ�ĳ���
    m_input1, m_input2:Double;
    m_dc_a, m_dc_b:Double;
    function SetRegData(Sender:TObject;DispMsg:string;RegAddr:Byte;nValue:Int64;nLen:Integer=3):Boolean;//���üĴ�����ֵ
    function GetRegData(Sender:TObject;DispMsg:string;RegAddr:Byte;var nValue:Int64;nGetCount:Integer=1):Boolean;//��ȡ�Ĵ�����ֵ
    //��ȡ�Ĵ�����ֵ����У���������
    function GetRegParamData(Sender:TObject;DispMsg:string;RegAddr:Byte;var nValue:Int64;nGetCount:Integer=1):Boolean;
    function WriteAndCheck(Sender:TObject;DispMsg:string;RegAddr:Byte;Data:Int64;DataLen:Byte=3):Boolean;
    function SendFrame_645(Sender: TObject; ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):Boolean;override;

    function Formula_4(Err:Double):Int64;      //�й�����У��1.0(100)Ib/(10)Ib��ʽ��������������Ҫд��Ĵ�����ֵ
    function Formula_5(Err:Double):Int64;      //��λУ׼��0.5L)A,B,C��������������Ҫд��Ĵ�����ֵ
    function Formula_9(Err:Double):Int64;      //��ѹ����У׼��ʽ��������������Ҫд��Ĵ�����ֵ

    function GetUn(Un:TUn; var dValue:Double):Boolean; //��ȡ��ѹ
  public
    { Public declarations }
    //procedure ParseData(pCommEntity:Pointer=nil);override;
    //function WaitForResp(Sender: TObject;AFN,Fn:Byte):Boolean;override;
  end;

var
  F_Param_ChkMeter: TF_Param_ChkMeter;

implementation

uses U_Protocol,U_Protocol_645, U_Main, U_Operation, U_MyFunction, Math;

{$R *.dfm}

procedure TF_Param_ChkMeter.btn_reg_initClick(Sender: TObject);
const
  regIfo:array[0..41,0..1] of string =
  (
    ('02','��λ1'),
    ('03','��λ2'),
    ('04','��λ3'),
    ('05','��λ4'),
    ('06','A����0'),
    ('07','B����0'),
    ('08','C����0'),
    ('09','A����1'),
    ('0a','B����1'),
    ('0b','C����1'),
    ('0c','A0��λУ��'),
    ('0d','A1��λУ��'),
    ('0e','A2��λУ��'),
    ('0f','A3��λУ��'),
    ('10','A4��λУ��'),
    ('11','B0��λУ��'),
    ('12','B1��λУ��'),
    ('19','C3��λУ��'),
    ('1a','C4��λУ��'),
    ('21','��Ƶ��������'),
    ('13','B2��λУ��'),
    ('14','B3��λУ��'),
    ('15','B4��λУ��'),
    ('16','C0��λУ��'),
    ('17','C1��λУ��'),
    ('18','C2��λУ��'),
    ('1b','A���ѹУ��'),
    ('1c','B���ѹУ��'),
    ('1d','C���ѹУ��'),
    ('1e','�Ȳ���������'),
    ('1f','�𶯵�������'),
    ('20','��Ƶ��������'),
    ('26','A�����У��'),
    ('27','B�����У��'),
    ('28','C�����У��'),
    ('29','3-4/3-3ģʽ'),
    ('2a','����ģʽ'),
    ('2d','����/г��ʹ��'),
    ('30','�����������'),
    ('3c','����/г���л�ѡ��'),
    ('3e','���峣���ӱ�'),
    ('3f','APHCAL')
  );
var i,nErrorCount:Integer;
begin
    g_bStop := False;
    TButton(Sender).Enabled := False;
    nErrorCount := 0;
    for i:=Low(regIfo) to High(regIfo) do
    begin
        if g_bStop then Break;
        if WriteAndCheck(nil, regIfo[i][1], StrToInt('x'+regIfo[i][0]), 0, 3) then
        begin
            F_Operation.DisplayOperation( Format('��ʼ��[%s]�ɹ�', [regIfo[i][1]]));
        end
        else
        begin
            F_Operation.DisplayOperation( Format('��ʼ��[%s]ʧ��', [regIfo[i][1]]));
            Inc(nErrorCount);
            Break;
        end;
    end;
    if nErrorCount=0 then
       TButton(Sender).Font.Color := clSucced
    else
       TButton(Sender).Font.Color := clFailed;
    TButton(Sender).Enabled := True;
end;

function TF_Param_ChkMeter.GetRegParamData(Sender:TObject;DispMsg:string;RegAddr:Byte;var nValue:Int64;nGetCount:Integer=1):Boolean;//��ȡ�Ĵ�����ֵ
var nCurValue:Int64;
    nAllValue:Int64;
    i,j,p:Integer;
    //buf:array[0..63]of Byte;
    ptr:PByte;
    DI:LongWord;
begin
    Result:=False;
    nAllValue:=0;
    if Sender is TButton then TButton(Sender).Font.Color := clblack;
    if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clblack;
    if (nGetCount<=0)then
        Exit;

    //02 90 ee xx ��7022�Ĵ����� xx �ǼĴ�����ַ
    
    DI := $0290ee00 or RegAddr;
    for i:=0 to nGetCount-1 do
    begin
        if SendFrame_645(Sender, ctrl_read_07, DI) then
        begin
            nCurValue:=0;
            ptr := m_pData;
            for j:=0 to m_nLen-1 do
            begin
                nCurValue:=nCurValue or (ptr^ shl (8*j));
                Inc(ptr);
            end;
            nAllValue:=nAllValue+nCurValue;
        end
        else
        begin
            if Sender is TButton then TButton(Sender).Font.Color := clFailed;
            if Sender is TCheckBox then TCheckBox(Sender).Font.Color :=clFailed;
            Exit;
        end;
    end;
    if Sender is TButton then TButton(Sender).Font.Color := clSucced;
    if Sender is TCheckBox then TCheckBox(Sender).Font.Color :=clSucced;
    Result:=True;
    nValue:=Trunc(nAllValue/nGetCount);
end;

function TF_Param_ChkMeter.GetRegData(Sender:TObject;DispMsg:string;RegAddr:Byte;var nValue:Int64;nGetCount:Integer=1):Boolean;//��ȡ�Ĵ�����ֵ
var nCurValue:Int64;
    nAllValue:Int64;
    i,j,p:Integer;
    buf:array[0..63]of Byte;
    ptr:PByte;
begin
    Result:=False;
    nAllValue:=0;
    if Sender is TButton then TButton(Sender).Font.Color :=clblack;
    if Sender is TCheckBox then TCheckBox(Sender).Font.Color :=clblack;
    if (nGetCount<=0)then
        Exit;

    p := 0;
    buf[p] := RegAddr;   Inc(p);
    
    for i:=0 to nGetCount-1 do
    begin
        if SendFrame_645(Sender, ctrl_read_97, DI_CHKMETER, @buf[0], p) then
        begin
            nCurValue:=0;
            ptr := m_pData;
            for j:=0 to m_nLen-1 do
            begin
                nCurValue:=nCurValue or (ptr^ shl (8*j));
                Inc(ptr);
            end;
            nAllValue:=nAllValue+nCurValue;
        end
        else
        begin
            if Sender is TButton then TButton(Sender).Font.Color := clFailed;
            if Sender is TCheckBox then TCheckBox(Sender).Font.Color :=clFailed;
            Exit;
        end;
    end;
    if Sender is TButton then TButton(Sender).Font.Color := clSucced;
    if Sender is TCheckBox then TCheckBox(Sender).Font.Color :=clSucced;
    Result:=True;
    nValue:=Trunc(nAllValue/nGetCount);
end;

function TF_Param_ChkMeter.GetUn(Un:TUn; var dValue:Double):Boolean; //��ȡ��ѹ
var nValue:Int64;
begin
    Result := False;
    case Un of
      Ua:
        Result := GetRegParamData(nil, '', $0d, nValue);
      Ub:
        Result := GetRegParamData(nil, '', $0e, nValue);
      Uc:
        Result := GetRegParamData(nil, '', $0f, nValue);
    end;

    if Result then
    begin
        //dValue := Double(nValue)*1024.0/8388608.0;
        dValue := nValue*1024.0/8388608.0;
    end;
end;

function TF_Param_ChkMeter.SetRegData(Sender:TObject;DispMsg:string;RegAddr:Byte;nValue:Int64;nLen:Integer=3):Boolean;//���üĴ�����ֵ
var i,p:Integer;
    buf:array[0..63]of Byte;
begin
    p := 0;
    buf[p] := RegAddr;   Inc(p);
    MoveMemory(@buf[p], @nValue, nLen);   Inc(p, nLen);
    Result := SendFrame_645(Sender, ctrl_write_97, DI_CHKMETER, @buf[0], p);
end;

function TF_Param_ChkMeter.WriteAndCheck(Sender:TObject;DispMsg:string;RegAddr:Byte;Data:Int64;DataLen:Byte=3):Boolean;
var regReaded:Int64;
begin
    Result := False;
    if SetRegData(Sender, DispMsg, RegAddr, Data, DataLen)
       and GetRegData(Sender, DispMsg, RegAddr, regReaded)
       and (Data=regReaded)
    then
    begin
        Result := True;
    end
    else
    begin
        Exit;
    end;
end;

procedure TF_Param_ChkMeter.chk_allClick(Sender: TObject);
begin
    MakeCheck(TCheckBox(Sender).Parent, TCheckBox(Sender).Checked);
end;

function TF_Param_ChkMeter.SendFrame_645(Sender: TObject; ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):Boolean;
var i,sendcounter:Integer;
    p:PByte;
    dataUnit:array[0..255]of Byte;
begin
    Result := False;
    if Sender is TCheckBox then
    begin
        if g_bStop or (not TCheckBox(Sender).Checked) then
            Exit;
        TCheckBox(Sender).Font.Color := clBlack;
    end;
    if Sender is TButton then TButton(Sender).Font.Color :=clblack;

    O_ProTx_645.MakeFrame_645(ctrl, DI, pData, datalen);
    dataUnit[0] := 1;  //�ն�ͨ�Ŷ˿ں�
    dataUnit[1] := 0;  //͸��ת��ͨ�ſ�����
    dataUnit[2] := $80 or 5;  //͸��ת�����յȴ����ĳ�ʱʱ��
    dataUnit[3] := 1;  //͸��ת�����յȴ��ֽڳ�ʱʱ��
    dataUnit[4] := O_ProTx_645.GetFrameLen() shr 0 and $ff;  //͸��ת�������ֽ���k
    dataUnit[5] := O_ProTx_645.GetFrameLen() shr 8 and $ff;  //͸��ת�������ֽ���k
    MoveMemory(@dataUnit[6], O_ProTx_645.GetFrameBuf(), O_ProTx_645.GetFrameLen());
    O_ProTx.MakeFrame(AFN_TRANS,F1,@dataUnit[0],O_ProTx_645.GetFrameLen()+6);

    for sendcounter:=1 to g_resend_count do
    begin
        if sendcounter>= 2 then
        begin
            if Sender is TButton then TButton(Sender).Font.Color :=clblack;
        end;
        if F_Main.SendDataAuto()
          and WaitForResp(Sender,AFN_TRANS,F1)
          //and O_ProRx_645.CheckFrame(O_ProRx.GetDataUnit(),O_ProRx.GetDataUnitLen())
          and O_ProRx_645.CheckFrame(GetDataUnit(),GetDataUnitLen())
          and O_ProRx_645.IsRespOK()
        then
        begin
            m_pData := O_ProRx_645.GetDataUnit();
            m_nLen := O_ProRx_645.GetDataUnitLen();
        
            m_data := 0;
            p := m_pData;
            for i:=0 to m_nLen-1 do
            begin
                //ShowMessage(Format('%.2X', [p^]));
                m_data := m_data or (Int64(p^ and $ff) shl (i*8)); //�������ȼ��ȳ˷�����
                Inc(p);
            end;
            Result := True;
            Break;
        end
        else
        begin
            if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clFailed;
            if Sender is TButton then TButton(Sender).Font.Color :=clFailed;
        end;
    end;

end;
    
procedure TF_Param_ChkMeter.btn_read_paramClick(Sender: TObject);
var chk:TCheckBox;
    strResult:string;
    i:Integer;
    pData:PByte;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;
    
    chk := chk_meter_const;
    if chk.Checked then
    begin
        edt_meter_const_r.Text := '';
    end;
    if SendFrame_645(chk, ctrl_read_97, $C030) then
    begin
        edt_meter_const_r.Text := Format('%.6x',[m_data and $ffffff]);
    end;

    chk := chk_remote_const;
    if chk.Checked then
    begin
        edt_remote_const_r.Text := '';
    end;
    if SendFrame_645(chk, ctrl_read_97, $C031) then
    begin
        edt_remote_const_r.Text := Format('%.6x',[m_data and $ffffff]);
    end;
    
    chk := chk_Ib;
    if chk.Checked then
    begin
        edt_Ib_r.Text := '';
    end;
    if SendFrame_645(chk, ctrl_read_97, $C142) then
    begin
        edt_Ib_r.Text := Format('%.2x.%.2x',[m_data shr 8 and $ff, m_data and $ff]);
    end;

    chk := chk_Ub;
    if chk.Checked then
    begin
        edt_Ub_r.Text := '';
    end;
    if SendFrame_645(chk, ctrl_read_97, $C141) then
    begin
        edt_Ub_r.Text := Format('%.4x',[m_data and $ffff]);
    end;

    chk := chk_Imax;
    if chk.Checked then
    begin
        edt_Imax_r.Text := '';
        edt_Imin_r.Text := '';
    end;
    if SendFrame_645(chk, ctrl_read_97, $C143) then
    begin
        edt_Imax_r.Text := Format('%.2x.%.2x',[m_data shr 08 and $ff, m_data shr 00 and $ff]);
        edt_Imin_r.Text := Format('%.2x.%.2x',[m_data shr 24 and $ff, m_data shr 16 and $ff]);
    end;
    
    chk := chk_voltage;
    if chk.Checked then
    begin
        edt_voltage.Text := '';
    end;
    if SendFrame_645(chk, ctrl_read_07, $0201ff00) then
    begin
        edt_voltage.Text := Format('A��: %.3x.%.1x B��: %.3x.%.1x C��: %.3x.%.1x',[
                m_data shr 04 and $fff,
                m_data shr 00 and $0f,
                m_data shr 20 and $fff,
                m_data shr 16 and $0f,
                m_data shr 36 and $fff,
                m_data shr 32 and $0f
                ]);
    end;

    chk := chk_current;
    if chk.Checked then
    begin
        edt_current.Text := '';
    end;
    if SendFrame_645(chk, ctrl_read_07, $0202ff00) then
    begin
        edt_current.Text := Format('A��: %.3x.%.3x B��: %.3x.%.3x C��: %.3x.%.3x',[
                PInteger(Integer(m_pData)+0)^ shr 12 and $fff,
                PInteger(Integer(m_pData)+0)^ shr 00 and $fff,
                PInteger(Integer(m_pData)+3)^ shr 12 and $fff,
                PInteger(Integer(m_pData)+3)^ shr 00 and $fff,
                PInteger(Integer(m_pData)+6)^ shr 12 and $fff,
                PInteger(Integer(m_pData)+6)^ shr 00 and $fff
                ]);
    end;



    chk := chk_acs_version;
    if chk.Checked then
    begin
        edt_acs_version.Text := '';
    end;
    if SendFrame_645(chk, ctrl_read_07, $04800001) then
    begin
        strResult := '';
        pData := m_pData;
        Inc(pData, m_nLen-1);
        for i:=m_nLen-1 downto 0 do
        begin
            if pData^<>0 then
                strResult := strResult + Char(pData^);
            Inc(pData, -1);
        end;
        edt_acs_version.Text := strResult;
    end;
    
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_ChkMeter.btn_write_paramClick(Sender: TObject);
var data,data1:Int64;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    if TryStrToInt64('x'+cbb_meter_const_w.Text, data) then
        SendFrame_645(chk_meter_const, ctrl_write_97, $C030, @data, 3);

    if TryStrToInt64('x'+cbb_remote_const_w.Text, data) then
        SendFrame_645(chk_remote_const, ctrl_write_97, $C031, @data, 3);

    if TryStrToInt64('x'+FormatFloat('#0000',StrtoFloat(medt_Ib_w.Text)*100), data) then
        SendFrame_645(chk_Ib, ctrl_write_97, $C142, @data, 2);

    if TryStrToInt64('x'+FormatFloat('#0000',StrtoFloat(medt_Ub_w.Text)), data) then
        SendFrame_645(chk_Ub, ctrl_write_97, $C141, @data, 2);

    if TryStrToInt64('x'+FormatFloat('#0000',StrtoFloat(medt_Imax_w.Text)*100), data)
      and TryStrToInt64('x'+FormatFloat('#0000',StrtoFloat(medt_Imin_w.Text)*100), data1)
    then
    begin
        data := data or (data1 shl 16 and $ffff0000);
        SendFrame_645(chk_Imax, ctrl_write_97, $C143, @data, 4);
    end;

    TButton(Sender).Enabled := True;
end;

procedure TF_Param_ChkMeter.chk10Click(Sender: TObject);
begin
    MakeCheck(TCheckBox(Sender).Parent, TCheckBox(Sender).Checked);
end;

procedure TF_Param_ChkMeter.btn_read_regClick(Sender: TObject);
var chk:TCheckBox;
    edt:TEdit;
    nValue:Int64;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;
    
    chk := chk_pulse;
    edt := edt_pulse_r;
    if chk.Checked then
    begin
        edt.Text := '';
        if GetRegData(chk, chk.Caption, $20, nValue) then
        begin
            edt.Text := Format('%.6x',[nValue and $ffffff]);
        end;
    end;

    chk := chk_boot_cur;
    edt := edt_boot_cur_r;
    if chk.Checked then
    begin
        edt.Text := '';
        if GetRegData(chk, chk.Caption, $1f, nValue) then
        begin
            edt.Text := Format('%.6x',[nValue and $ffffff]);
        end;
    end;

    chk := chk_area;
    edt := edt_area_r;
    if chk.Checked then
    begin
        edt.Text := '';
        if GetRegData(chk, chk.Caption, $1e, nValue) then
        begin
            edt.Text := Format('%.6x',[nValue and $ffffff]);
        end;
    end;

    chk := chk_comb_phase;
    edt := edt_comb_phase_r;
    if chk.Checked then
    begin
        edt.Text := '';
        if GetRegData(chk, chk.Caption, $2a, nValue) then
        begin
            edt.Text := Format('%.6x',[nValue and $ffffff]);
        end;
    end;

    chk := chk_threshold_voltage_loss;
    edt := edt_threshold_voltage_loss_r;
    if chk.Checked then
    begin
        edt.Text := '';
        if GetRegData(chk, chk.Caption, $29, nValue) then
        begin
            edt.Text := Format('%.6x',[nValue and $ffffff]);
        end;
    end;

    chk := chk_phase_angle1;
    edt := edt_phase_angle1_r;
    if chk.Checked then
    begin
        edt.Text := '';
        if GetRegData(chk, chk.Caption, $02, nValue) then
        begin
            edt.Text := Format('%.6x',[nValue and $ffffff]);
        end;
    end;

    chk := chk_phase_angle2;
    edt := edt_phase_angle2_r;
    if chk.Checked then
    begin
        edt.Text := '';
        if GetRegData(chk, chk.Caption, $03, nValue) then
        begin
            edt.Text := Format('%.6x',[nValue and $ffffff]);
        end;
    end;

    chk := chk_phase_angle3;
    edt := edt_phase_angle3_r;
    if chk.Checked then
    begin
        edt.Text := '';
        if GetRegData(chk, chk.Caption, $04, nValue) then
        begin
            edt.Text := Format('%.6x',[nValue and $ffffff]);
        end;
    end;

    chk := chk_phase_angle4;
    edt := edt_phase_angle4_r;
    if chk.Checked then
    begin
        edt.Text := '';
        if GetRegData(chk, chk.Caption, $05, nValue) then
        begin
            edt.Text := Format('%.6x',[nValue and $ffffff]);
        end;
    end;

    chk := chk_harm_en;
    edt := edt_harm_en_r;
    if chk.Checked then
    begin
        edt.Text := '';
        if GetRegData(chk, chk.Caption, $2D, nValue) then
        begin
            edt.Text := Format('%.6x',[nValue and $ffffff]);
        end;
    end;

    chk := chk_harm_sw;
    edt := edt_harm_sw_r;
    if chk.Checked then
    begin
        edt.Text := '';
        if GetRegData(chk, chk.Caption, $3C, nValue) then
        begin
            edt.Text := Format('%.6x',[nValue and $ffffff]);
        end;
    end;
    
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_ChkMeter.btn_write_regClick(Sender: TObject);
var data:Int64;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    if TryStrToInt64('x'+edt_pulse_w.Text, data) then     WriteAndCheck(chk_pulse, chk_pulse.Caption, $20, data);
    if TryStrToInt64('x'+edt_boot_cur_w.Text, data) then  WriteAndCheck(chk_boot_cur, chk_boot_cur.Caption, $1f, data);
    if TryStrToInt64('x'+edt_area_w.Text, data) then      WriteAndCheck(chk_area, chk_area.Caption, $1e, data);
    if TryStrToInt64('x'+edt_comb_phase_w.Text, data) then              WriteAndCheck(chk_comb_phase, chk_comb_phase.Caption, $2a, data);
    if TryStrToInt64('x'+edt_threshold_voltage_loss_w.Text, data) then  WriteAndCheck(chk_threshold_voltage_loss, chk_threshold_voltage_loss.Caption, $29, data);
    if TryStrToInt64('x'+edt_phase_angle1_w.Text, data) then  WriteAndCheck(chk_phase_angle1, chk_phase_angle1.Caption, $02, data);
    if TryStrToInt64('x'+edt_phase_angle2_w.Text, data) then  WriteAndCheck(chk_phase_angle2, chk_phase_angle2.Caption, $03, data);
    if TryStrToInt64('x'+edt_phase_angle3_w.Text, data) then  WriteAndCheck(chk_phase_angle3, chk_phase_angle3.Caption, $04, data);
    if TryStrToInt64('x'+edt_phase_angle4_w.Text, data) then  WriteAndCheck(chk_phase_angle4, chk_phase_angle4.Caption, $05, data);
    if TryStrToInt64('x'+edt_harm_en_w.Text, data) then       WriteAndCheck(chk_harm_en, chk_harm_en.Caption, $2D, data);
    if TryStrToInt64('x'+edt_harm_sw_w.Text, data) then       WriteAndCheck(chk_harm_sw, chk_harm_sw.Caption, $3C, data);

    TButton(Sender).Enabled := True;
end;

procedure TF_Param_ChkMeter.btn_init_regClick(Sender: TObject);
var data:Int64;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    data := 0;
    WriteAndCheck(chk_pulse, chk_pulse.Caption, $20, data);
    WriteAndCheck(chk_boot_cur, chk_boot_cur.Caption, $1f, data);
    WriteAndCheck(chk_area, chk_area.Caption, $1e, data);
    WriteAndCheck(chk_comb_phase, chk_comb_phase.Caption, $2a, data);
    WriteAndCheck(chk_threshold_voltage_loss, chk_threshold_voltage_loss.Caption, $29, data);
    WriteAndCheck(chk_phase_angle1, chk_phase_angle1.Caption, $02, data);
    WriteAndCheck(chk_phase_angle2, chk_phase_angle2.Caption, $03, data);
    WriteAndCheck(chk_phase_angle3, chk_phase_angle3.Caption, $04, data);
    WriteAndCheck(chk_phase_angle4, chk_phase_angle4.Caption, $05, data);
    WriteAndCheck(chk_harm_en, chk_harm_en.Caption, $2D, data);
    WriteAndCheck(chk_harm_sw, chk_harm_sw.Caption, $3C, data);

    TButton(Sender).Enabled := True;
end;

procedure TF_Param_ChkMeter.btn_init_volcurClick(Sender: TObject);
var data:Int64;
    i,regAddr:Integer;
    chk:TCheckBox;
    comp:TComponent;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;
    data := 0;

    for i:=1 to 6 do
    begin
        comp := FindComponent( Format('chk%d',[i]) );
        if comp is TCheckBox then
        begin
            chk := TCheckBox(comp);
            regAddr := StrToInt('x'+ Copy(chk.Caption,Length(chk.Caption)-1,2) );
            WriteAndCheck(chk, chk.Caption, regAddr, data);
        end;
    end;
    
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_ChkMeter.btn_chk_volcurClick(Sender: TObject);
var data:Int64;
    i,regAddr:Integer;
    chk:TCheckBox;
    comp:TComponent;
    Ub,Up,Ib,Ip:Double;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;
    data := 0;

    //��ѹУ׼
    for i:=1 to 3 do
    begin
        comp := FindComponent( Format('chk%d',[i]) );
        if comp is TCheckBox then
        begin
            chk := TCheckBox(comp);
            //�������ѹ
            if SendFrame_645(chk, ctrl_read_97, $C141) then
            begin
                Ub := StrToFloat(Format('%.4x',[m_data and $ffff]));//Up := StrToFloat(Format('%.6x',[m_data and $ffffff]));
            end
            else
            begin
                Continue;
            end;
            //���������ѹ
            if not GetUn(TUn(Ord(Ua)+i-1), Up) then
            begin
                Continue;
            end;

            //�ж����Ϊ220���ҾͲ��ı�
            //if (Abs(Ub-Up)<=1) then
            if (Abs(Ub-Up)/Ub<0.005) then
            begin
                //TLabel(findcomponent(Format('lbl_vol_%d',[i]))).Caption := FloattoStr(Up) + ' V';
                TLabel(findcomponent(Format('lbl_vol_%d',[i]))).Caption := Format('%.2f', [Up]) + ' V';
                chk.Font.Color := clSucced;
                continue;
            end;
            //����У׼ֵ��д���Ĵ���
            regAddr := StrToInt('x'+ Copy(chk.Caption,Length(chk.Caption)-1,2) );
            WriteAndCheck(chk, chk.Caption, regAddr, Formula_9(Ub/Up-1));

            //���������ѹ��ʾ
            if GetUn(TUn(Ord(Ua)+i-1), Up) then
            begin
                TLabel(findcomponent(Format('lbl_vol_%d',[i]))).Caption := Format('%.2f', [Up]) + ' V';
            end;
        end;
    end;

    //����У׼
    for i:=4 to 6 do
    begin
        comp := FindComponent( Format('chk%d',[i]) );
        if comp is TCheckBox then
        begin
            chk := TCheckBox(comp);
            //���������
            if SendFrame_645(chk, ctrl_read_97, $C142) then
            begin
                Ib := StrToFloat(Format('%.2x.%.2x',[m_data shr 8 and $ff,m_data and $ff]));
            end
            else
            begin
                Continue;
            end;
            //�����������
            if SendFrame_645(chk, ctrl_read_97, $B621+i-4) then
            begin
                Ip := StrToFloat(Format('%.2x.%.2x',[m_data shr 8 and $ff,m_data and $ff]));
            end
            else
            begin
                Continue;
            end;
            //�жϵ����Ƿ���1.5����.
            //if (Abs(Ib-Ip)<=0.1) then
            //if (Abs(Ib-Ip)/Ib<0.005) then
            if (Abs(Ib-Ip)/Ib<0.003) then
            begin
                TLabel(FindComponent(Format('lbl_cur_%d',[i-3]))).Caption:= Format('%f A',[Ip]); //��ʾ��ǰ����
                chk.Font.Color := clSucced;
                continue;
            end;
            //����У׼ֵ��д���Ĵ���
            regAddr := StrToInt('x'+ Copy(chk.Caption,Length(chk.Caption)-1,2) );
            WriteAndCheck(chk, chk.Caption, regAddr, Formula_9(Ib/Ip-1));
            //�������������ʾ
            if SendFrame_645(chk, ctrl_read_97, $B621+i-4) then
            begin
                Ip := StrToFloat(Format('%.2x.%.2x',[m_data shr 8 and $ff,m_data and $ff]));
                TLabel(FindComponent(Format('lbl_cur_%d',[i-3]))).Caption:= Format('%f A',[Ip]); //��ʾ��ǰ����
            end;
        end;
    end;
    
    TButton(Sender).Enabled := True;
end;

//4.�й�����У��1.0(100)Ib/(10)Ib��ʽ
function TF_Param_ChkMeter.Formula_4(Err:Double):Int64;
var AVRMSOS:double;
begin
    AVRMSOS:= -1 * Err /(1+Err);
    AVRMSOS:=AVRMSOS*Power(2,23);
    if Err>0 then
        AVRMSOS := AVRMSOS + Power(2,24);
    Result := trunc(AVRMSOS);
end;

//5. ��λУ׼��0.5L)A,B,C
function TF_Param_ChkMeter.Formula_5( Err:Double ):Int64;
var AVRMSOS:double;
begin
    {
      //ACOS((1+D47)*0.5)-PI()/3
    ACOS:�������ֵķ�����ֵ��������ֵΪһ���Ƕȣ����ýǶȵ�����ֵ��Ϊ�ú����Ĳ�����
    ���صĽǶ�ֵ�Ի��ȱ�ʾ����Χ�� 0 �� pi��
    �﷨
    ACOS(number)
    Number   �Ƕȵ�����ֵ��������� -1��1 ֮�䡣
     ���Ҫ�öȱ�ʾ������ֵ���轫����ٳ��� 180/PI()��
     ʾ��
    ACOS(-0.5) ���� 2.094395��2*pi/3 ���ȣ�
    ACOS(-0.5)*180/PI() ���� 120�� ���ȣ�
    }
    AVRMSOS:= arccos((1+Err)*0.5)-PI/3;
    AVRMSOS:=AVRMSOS*Power(2,23);
    if Err>0 then
        AVRMSOS := AVRMSOS + Power(2,24);
    Result:=trunc(AVRMSOS);
end;

//2.__ AVRMSGAIN = (VN/AVRMS-1)*4096
//9.��ѹ����У׼
//=TRUNC(POWER(2,24)+F27*POWER(2,23))
//=TRUNC(F30*POWER(2,23))
function TF_Param_ChkMeter.Formula_9(Err:Double):Int64;
var AVRMSOS:double;
begin
    AVRMSOS:=Err*Power(2,23);
    if Err<0 then
        AVRMSOS:=Power(2,24)+AVRMSOS;
    Result:=trunc(AVRMSOS);
end;

procedure TF_Param_ChkMeter.btn_init_gainClick(Sender: TObject);
var data:Int64;
    i,regAddr:Integer;
    rb:TRadioButton;
    comp:TComponent;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;
    data := 0;

    for i:=1 to 6 do
    begin
        comp := FindComponent( Format('rb%d',[i]) );
        if comp is TRadioButton then
        begin
            rb := TRadioButton(comp);
            if rb.Checked then
            begin
                regAddr := StrToInt('x'+ Copy(rb.Caption,Length(rb.Caption)-1,2) );
                WriteAndCheck(Sender, rb.Caption, regAddr, data);
            end;
        end;
    end;
    
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_ChkMeter.btn_chk_gainClick(Sender: TObject);
var data:Int64;
    i,regAddr:Integer;
    rb:TRadioButton;
    comp:TComponent;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    for i:=1 to 6 do
    begin
        comp := FindComponent( Format('rb%d',[i]) );
        if comp is TRadioButton then
        begin
            rb := TRadioButton(comp);
            if rb.Checked then
            begin
                regAddr := StrToInt('x'+ Copy(rb.Caption,Length(rb.Caption)-1,2) );
                //����У׼ֵ��д���Ĵ���
                data := Formula_4(StrToFloat(edt_err_gain.Text)/100);
                WriteAndCheck(Sender, rb.Caption, regAddr, data);
            end;
        end;
    end;
    
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_ChkMeter.btn_init_angleClick(Sender: TObject);
var data:Int64;
    i,regAddr:Integer;
    rb:TRadioButton;
    comp:TComponent;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;
    data := 0;

    for i:=7 to 21 do
    begin
        comp := FindComponent( Format('rb%d',[i]) );
        if comp is TRadioButton then
        begin
            rb := TRadioButton(comp);
            if rb.Checked then
            begin
                regAddr := StrToInt('x'+ Copy(rb.Caption,Length(rb.Caption)-1,2) );
                WriteAndCheck(Sender, rb.Caption, regAddr, data);
            end;
        end;
    end;
    
    TButton(Sender).Enabled := True;

end;

procedure TF_Param_ChkMeter.btn_chk_angleClick(Sender: TObject);
var data:Int64;
    i,regAddr:Integer;
    rb:TRadioButton;
    comp:TComponent;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    for i:=7 to 21 do
    begin
        comp := FindComponent( Format('rb%d',[i]) );
        if comp is TRadioButton then
        begin
            rb := TRadioButton(comp);
            if rb.Checked then
            begin
                regAddr := StrToInt('x'+ Copy(rb.Caption,Length(rb.Caption)-1,2) );
                //����У׼ֵ��д���Ĵ���
                data := Formula_5(StrToFloat(edt_err_angle.Text)/100);
                WriteAndCheck(Sender, rb.Caption, regAddr, data);
            end;
        end;
    end;
    
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_ChkMeter.FormShow(Sender: TObject);
var i:Integer;
begin
    inherited;
    for i:=pgc1.PageCount-1 downto 0 do
    begin
        pgc1.ActivePageIndex := i;
    end;
end;
{
procedure TF_Param_ChkMeter.ParseData(pCommEntity:Pointer=nil);
begin
    //inherited;
    m_bResp := True;
end;
}
{
function TF_Param_ChkMeter.WaitForResp(Sender: TObject;AFN,Fn:Byte):Boolean;
begin
    //inherited;
end;
}
procedure TF_Param_ChkMeter.edt_meternoKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var meterNo:Int64;
begin
    //inherited;
    if TryStrToInt64('x'+TEdit(Sender).Text, meterNo) then
    begin
        O_ProTx_645.SetDeviceAddr(meterNo);
    end;
end;

procedure TF_Param_ChkMeter.edt_meter_pwdKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var pwd:Int64;
begin
    //inherited;
    if TryStrToInt64('x'+TEdit(Sender).Text, pwd) then
    begin
        O_ProTx_645.SetDevicePwd(pwd);
    end;

end;

procedure TF_Param_ChkMeter.btn_create_frameClick(Sender: TObject);
var ctrl:Byte;
    DI:LongWord;
    dataUnit:array[0..127] of Byte;
    p:Integer;
begin
    //inherited;
    ctrl := StrToInt('x'+edt_ctrl.Text);
    DI := StrToInt('x'+StringReplace(edt_di.Text, ' ', '', [rfReplaceAll]));
    p := HexToBuf(edt_dataunit.Text, @dataUnit[0]);
    O_ProTx_645.MakeFrame_645(ctrl, DI, @dataUnit[0], p);
    edt_frame.Text := BufToHex(O_ProTx_645.GetFrameBuf(), O_ProTx_645.GetFrameLen());
end;

procedure TF_Param_ChkMeter.btn_sendClick(Sender: TObject);
var ctrl:Byte;
    DI:LongWord;
    dataUnit:array[0..127] of Byte;
    p:Integer;
begin
    //inherited;
    ctrl := StrToInt('x'+edt_ctrl.Text);
    DI := StrToInt('x'+StringReplace(edt_di.Text, ' ', '', [rfReplaceAll]));
    p := HexToBuf(edt_dataunit.Text, @dataUnit[0]);
    O_ProTx_645.MakeFrame_645(ctrl, DI, @dataUnit[0], p);
    edt_frame.Text := BufToHex(O_ProTx_645.GetFrameBuf(), O_ProTx_645.GetFrameLen());
    edt_meter_resp.Text := '';
    SendFrame_645(Sender, ctrl, DI, @dataUnit[0], p);
    edt_meter_resp.Text := BufToHex(O_ProRx_645.GetFrameBuf(), O_ProRx_645.GetFrameLen());
end;



procedure TF_Param_ChkMeter.btn1Click(Sender: TObject);
var nValue:Int64;
    dValue:Double;
begin
    //inherited;

    if GetRegData(Sender, '', StrToInt('x'+edt1.Text), nValue) then
    begin
        //ShowMessage(Format('%x', [nValue]));
    end;

    {
    if GetUn(Ua, dValue) then
    begin
        ShowMessage(Format('%f', [dValue]));
    end;
    if GetUn(Ub, dValue) then
    begin
        ShowMessage(Format('%f', [dValue]));
    end;
    }
    {
    if GetUn(Uc, dValue) then
    begin
        ShowMessage(Format('%.3f', [dValue]));
        ShowMessage(Format('%.0f', [dValue]));
    end;
    }
end;

procedure TF_Param_ChkMeter.btn_input_1Click(Sender: TObject);
var p:PByte;
begin
    g_bStop := False;
    TButton(Sender).Font.Color := clBlack;
    MakeFrame(AFN_CLASS_1,F80,nil,0,1);
    if F_Main.SendDataAuto()
      and WaitForResp(Sender,AFN_CLASS_1,F80)
    then
    begin
        p := GetDataUnit();
        m_input1 := T_Protocol_con.DatabufToFloat(p, 2);
    end;
end;

procedure TF_Param_ChkMeter.btn_input_2Click(Sender: TObject);
var p:PByte;
    input1,input2:Double;
begin
    g_bStop := False;
    TButton(Sender).Font.Color := clBlack;
    MakeFrame(AFN_CLASS_1,F80,nil,0,1);
    if F_Main.SendDataAuto()
      and WaitForResp(Sender,AFN_CLASS_1,F80)
    then
    begin
        p := GetDataUnit();
        m_input2 := T_Protocol_con.DatabufToFloat(p, 2);

        input1 := StrToFloat(edt_input_1.Text);
        input2 := StrToFloat(edt_input_2.Text);

        if input2 <> input1 then
        begin
            m_dc_a := (m_input2-m_input1)/(input2-input1);
            m_dc_b := m_input1 - m_dc_a*input1;
            edt_chk_param.Text := Format('a = %.3f, b=%.3f', [m_dc_a, m_dc_b]);
        end
        else
        begin
            edt_chk_param.Text := '';
        end;
    end;
end;

procedure TF_Param_ChkMeter.btn_chk_paramClick(Sender: TObject);
var dataUnit:array[0..63]of Byte;
begin
    g_bStop := False;
    TButton(Sender).Font.Color := clBlack;
    T_Protocol_con.FloatToDatabuf(m_dc_a, @dataUnit[0], 2);
    MakeFrame(AFN_WRITE_PARAM,F88,@dataUnit[0], 2);
    if F_Main.SendDataAuto()
      and WaitForResp(Sender,AFN_CONFIRM,F1)
    then
    begin
    end;
    
    TButton(Sender).Font.Color := clBlack;
    T_Protocol_con.FloatToDatabuf(m_dc_b, @dataUnit[0], 2);
    MakeFrame(AFN_WRITE_PARAM,F89,@dataUnit[0], 2);
    if F_Main.SendDataAuto()
      and WaitForResp(Sender,AFN_CONFIRM,F1)
    then
    begin
    end;
end;

procedure TF_Param_ChkMeter.btn_cur_dc_valueClick(Sender: TObject);
var p:PByte;
begin
    g_bStop := False;
    TButton(Sender).Font.Color := clBlack;
    edt_cur_dc_value.Text := '';
    MakeFrame(AFN_CLASS_1,F73,nil,0,1);
    if F_Main.SendDataAuto()
      and WaitForResp(Sender,AFN_CLASS_1,F73)
    then
    begin
        p := GetDataUnit();
        edt_cur_dc_value.Text := Format('%.3f',[T_Protocol_con.DatabufToFloat(p, 2)]);
    end;
end;

end.
