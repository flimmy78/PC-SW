unit U_Param_Mod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_ParamReadWrite, StdCtrls, Buttons;

type
  TF_Param_Mod = class(TF_ParamReadWrite)
    btn_read: TBitBtn;
    btn_write: TBitBtn;
    chk_plc_frequency: TCheckBox;
    cbb_plc_frequency: TComboBox;
    chk_version: TCheckBox;
    edt_version: TEdit;
    chk_version_plc: TCheckBox;
    edt_version_plc: TEdit;
    btn_stop_plc: TBitBtn;
    btn_resume_plc: TBitBtn;
    chk_plcnode_count: TCheckBox;
    edt_plcnode_count: TEdit;
    chk_all: TCheckBox;
    chk_rt_mode: TCheckBox;
    cbb_rt_mode: TComboBox;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    cbb_meter_protocol: TComboBox;
    edt_meter_no: TEdit;
    edt_read_energy: TEdit;
    btn_read_meter_energy: TBitBtn;
    grp2: TGroupBox;
    lbl4: TLabel;
    lbl5: TLabel;
    cbb_meter_protocol_sn: TComboBox;
    edt_meter_sn_start: TEdit;
    btn_read_meter_energy_by_sn: TBitBtn;
    lbl6: TLabel;
    edt_meter_sn_end: TEdit;
    lbl7: TLabel;
    edt_success: TEdit;
    lbl8: TLabel;
    edt_failed: TEdit;
    lbl9: TLabel;
    edt_DI: TEdit;
    procedure btn_readClick(Sender: TObject);
    procedure btn_writeClick(Sender: TObject);
    procedure btn_stop_plcClick(Sender: TObject);
    procedure btn_resume_plcClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chk_allClick(Sender: TObject);
    procedure btn_read_meter_energyClick(Sender: TObject);
    procedure btn_read_meter_energy_by_snClick(Sender: TObject);
    procedure cbb_meter_protocol_snChange(Sender: TObject);
  private
    { Private declarations }
    function SendFrame_645(Sender: TObject; ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):Boolean;override;
    function SendFrame_645_2(Sender: TObject; ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):Boolean;virtual;
  public
    { Public declarations }
  end;

var
  F_Param_Mod: TF_Param_Mod;

implementation

uses U_Main, U_Operation, U_Protocol, U_Protocol_645, U_MyFunction;

{$R *.dfm}

type TFreType = (ftOld, ftNew);

const g_fre_type: TFreType = ftOld;
//const g_fre_type: TFreType = ftNew;

function TF_Param_Mod.SendFrame_645(Sender: TObject; ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):Boolean;
var i,sendcounter:Integer;
    p:PByte;
    dataUnit:array[0..255]of Byte;
begin
    Result := False;
    
    O_ProTx_645.MakeFrame_645(ctrl, DI, pData, datalen);

    case ctrl of
      ctrl_read_97,
      ctrl_write_97:
        dataUnit[0] := 1;     //��Լ����
      ctrl_read_07,
      ctrl_write_07:
        dataUnit[0] := 2;     //��Լ����
      else
        dataUnit[0] := 3;     //��Լ����
    end;
    dataUnit[1] := 0;     //�ӽڵ㸽���ڵ�����n
    dataUnit[2] := O_ProTx_645.GetFrameLen();     //���ĳ���L
    MoveMemory(@dataUnit[3], O_ProTx_645.GetFrameBuf(), O_ProTx_645.GetFrameLen());
    MakeFrame(AFN_ROUTER_TRANS, F1, @dataUnit[0],O_ProTx_645.GetFrameLen()+3);

    if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clBlack;
    if Sender is TButton then TButton(Sender).Font.Color :=clBlack;

    if F_Main.SendDataAuto()
      and WaitForResp(Sender,AFN_ROUTER_TRANS,F1)
      and O_ProRx_645.CheckFrame(GetDataUnit(), GetDataUnitLen())
      and O_ProRx_645.IsRespOK()
    then
    begin
        m_pData := O_ProRx_645.GetDataUnit();
        m_nLen := O_ProRx_645.GetDataUnitLen();
        
        m_data := 0;
        p := m_pData;
        for i:=0 to m_nLen-1 do
        begin
            m_data := m_data or (Int64(p^ and $ff) shl (i*8)); //�������ȼ��ȳ˷�����
            Inc(p);
        end;
        
        if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clSucced;
        if Sender is TButton then TButton(Sender).Font.Color :=clSucced;

        Result := True;
    end
    else
    begin
        if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clFailed;
        if Sender is TButton then TButton(Sender).Font.Color :=clFailed;
    end;
end;

function TF_Param_Mod.SendFrame_645_2(Sender: TObject; ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):Boolean;
var i,sendcounter:Integer;
    p:PByte;
    dataUnit:array[0..255]of Byte;
begin
    Result := False;
    
    O_ProTx_645.MakeFrame_645(ctrl, DI, pData, datalen);

    case ctrl of
      ctrl_read_97,
      ctrl_write_97:
        dataUnit[0] := 1;     //��Լ����
      ctrl_read_07,
      ctrl_write_07:
        dataUnit[0] := 2;     //��Լ����
      else
        dataUnit[0] := 3;     //��Լ����
    end;
    dataUnit[1] := 0;     //�ӽڵ㸽���ڵ�����n
    dataUnit[2] := O_ProTx_645.GetFrameLen();     //���ĳ���L
    MoveMemory(@dataUnit[3], O_ProTx_645.GetFrameBuf(), O_ProTx_645.GetFrameLen());
    MakeFrame(AFN_ROUTER_TRANS, F213, @dataUnit[0],O_ProTx_645.GetFrameLen()+3);

    if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clBlack;
    if Sender is TButton then TButton(Sender).Font.Color :=clBlack;

    if F_Main.SendDataAuto()
      and WaitForResp(Sender,AFN_ROUTER_TRANS,F1)
      and O_ProRx_645.CheckFrame(GetDataUnit(), GetDataUnitLen())
      and O_ProRx_645.IsRespOK()
    then
    begin
        m_pData := O_ProRx_645.GetDataUnit();
        m_nLen := O_ProRx_645.GetDataUnitLen();
        
        m_data := 0;
        p := m_pData;
        for i:=0 to m_nLen-1 do
        begin
            m_data := m_data or (Int64(p^ and $ff) shl (i*8)); //�������ȼ��ȳ˷�����
            Inc(p);
        end;
        
        if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clSucced;
        if Sender is TButton then TButton(Sender).Font.Color :=clSucced;

        Result := True;
    end
    else
    begin
        if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clFailed;
        if Sender is TButton then TButton(Sender).Font.Color :=clFailed;
    end;
end;

procedure TF_Param_Mod.btn_readClick(Sender: TObject);
var chk:TCheckBox;
    pData2:PWORD;
    pData1:PByte;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;
    chk := chk_plc_frequency;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        cbb_plc_frequency.ItemIndex := -1;
        MakeFrame(AFN_READ_SELF,F1);
        F_Main.SendDataAuto();
        F_Operation.DisplayOperation(Format('�����ز�Ƶ��',[]));
        if WaitForResp(chk,AFN_READ_SELF,F1) then
        begin
            {
            FB, BB BB BB ΪƵ��  80/120K��˫��Ƶģʽ
            FC, BB BB BB ΪƵ��  80/120K��XC����ģʽ
            FD, CC CC CC ΪƵ��  96/160K��˫��Ƶģʽ
            FA, CC CC CC ΪƵ��  96/160K������ģʽ
            }
            pData2 := @(GetDataUnit()^);
            {
            if pData2^=$BBFB then cbb_plc_frequency.ItemIndex := 0;
            if pData2^=$BBFC then cbb_plc_frequency.ItemIndex := 1;
            if pData2^=$CCFD then cbb_plc_frequency.ItemIndex := 2;
            if pData2^=$CCFA then cbb_plc_frequency.ItemIndex := 3;
            }
            cbb_plc_frequency.ItemIndex := cbb_plc_frequency.Items.IndexOfObject(TObject(pData2^));
        end;
    end;

    chk := chk_rt_mode;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        cbb_rt_mode.ItemIndex := -1;
        MakeFrame($02, F5);
        F_Main.SendDataAuto();
        F_Operation.DisplayOperation(Format('����·������ģʽ',[]));
        if WaitForResp(chk, $02, F5) then
        begin
            pData1 := @(GetDataUnit()^);
            cbb_rt_mode.ItemIndex := cbb_rt_mode.Items.IndexOfObject(TObject(pData1^ and $ff));
        end;
    end;

    chk := chk_version;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        edt_version.Text := '';
        MakeFrame($03,F1);
        F_Main.SendDataAuto();
        F_Operation.DisplayOperation(Format('����������ģ��汾��',[]));
        if WaitForResp(chk,$03,F1) then
        begin
            pData1 := GetDataUnit();
            edt_plcnode_count.Text := Format('', []);
            edt_version.Text := Format('�汾:%.2x%.2x,����:%.2x-%.2x-%.2x,оƬ:%s%s,����:%s%s',[
                PByte(Integer(pData1)+8)^,
                PByte(Integer(pData1)+7)^,
                PByte(Integer(pData1)+6)^,
                PByte(Integer(pData1)+5)^,
                PByte(Integer(pData1)+4)^,
                PChar(Integer(pData1)+3)^,
                PChar(Integer(pData1)+2)^,
                PChar(Integer(pData1)+1)^,
                PChar(Integer(pData1)+0)^
            ]);
        end;
    end;

    chk := chk_version_plc;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        edt_version_plc.Text := '';
        MakeFrame($03,F1,nil,0,0,True);
        F_Main.SendDataAuto();
        F_Operation.DisplayOperation(Format('�����ز��汾��',[]));
        if WaitForResp(chk,$03,F1) then
        begin
            pData1 := GetDataUnit();
            edt_version_plc.Text := Format('�汾:%.2x%.2x,����:%.2x-%.2x-%.2x,оƬ:%s%s,����:%s%s',[
                PByte(Integer(pData1)+8)^,
                PByte(Integer(pData1)+7)^,
                PByte(Integer(pData1)+6)^,
                PByte(Integer(pData1)+5)^,
                PByte(Integer(pData1)+4)^,
                PChar(Integer(pData1)+3)^,
                PChar(Integer(pData1)+2)^,
                PChar(Integer(pData1)+1)^,
                PChar(Integer(pData1)+0)^
            ]);
        end;
    end;

    chk := chk_plcnode_count;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        edt_plcnode_count.Text := '';
        MakeFrame($10,F1);
        F_Main.SendDataAuto();
        F_Operation.DisplayOperation(Format('�����ز��ڵ�����',[]));
        if WaitForResp(chk,$10,F1) then
        begin
            pData2 := @(GetDataUnit()^);
            edt_plcnode_count.Text := Format('%d',[pData2^]);
        end;
    end;
    
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_Mod.btn_writeClick(Sender: TObject);
var chk:TCheckBox;
    buf:array[0..63]of Byte;
    p:Integer;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;
    chk := chk_plc_frequency;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        p := 0;
        {
        if cbb_plc_frequency.ItemIndex=0 then
        begin
            buf[p] := $FB;   Inc(p);
            buf[p] := $BB;   Inc(p);
        end
        else if cbb_plc_frequency.ItemIndex=1 then
        begin
            buf[p] := $FC;   Inc(p);
            buf[p] := $BB;   Inc(p);        
        end
        else if cbb_plc_frequency.ItemIndex=2 then
        begin
            buf[p] := $FD;   Inc(p);
            buf[p] := $CC;   Inc(p);
        end
        else if cbb_plc_frequency.ItemIndex=3 then
        begin
            buf[p] := $FA;   Inc(p);
            buf[p] := $CC;   Inc(p);        
        end;
        }
        if cbb_plc_frequency.ItemIndex>=0 then
        begin
            (PWORD(@buf[p]))^ := Integer(cbb_plc_frequency.Items.Objects[cbb_plc_frequency.ItemIndex]);   Inc(p, 2);
        end;
        
        if p>0 then
        begin
            MakeFrame(AFN_WRITE_SELF,F1,@buf[0],p);
            F_Main.SendDataAuto();
            F_Operation.DisplayOperation(Format('�����ز�Ƶ��',[]));
            //WaitForResp(chk,AFN_WRITE_SELF,F1);
            WaitForResp(chk,AFN_CONFIRM,F1);
        end
        else
        begin
            MyMessageBox(Handle,'��ѡ���ز�Ƶ�ʣ�','��ʾ',MB_OK or MB_ICONINFORMATION);
        end;
    end;

    chk := chk_rt_mode;
    if chk.Checked and not g_bStop then
    begin
        chk.Font.Color := clBlack;
        p := 0;
        
        if cbb_rt_mode.ItemIndex>=0 then
        begin
            (PByte(@buf[p]))^ := Integer(cbb_rt_mode.Items.Objects[cbb_rt_mode.ItemIndex]);   Inc(p, 1);
        end;

        if p>0 then
        begin
            MakeFrame($01, F7, @buf[0], p);
            F_Main.SendDataAuto();
            F_Operation.DisplayOperation(Format('����·������ģʽ',[]));
            WaitForResp(chk, $01, F7);
        end
        else
        begin
            MyMessageBox(Handle,'��ѡ��·������ģʽ��','��ʾ',MB_OK or MB_ICONINFORMATION);
        end;
    end;

    TButton(Sender).Enabled := True;
end;

procedure TF_Param_Mod.btn_stop_plcClick(Sender: TObject);
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;
    MakeFrame(AFN_CTRL_ROUTER,F2);
    if F_Main.SendDataAuto()
      and WaitForResp(Sender,AFN_CONFIRM,F1)
    then;
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_Mod.btn_resume_plcClick(Sender: TObject);
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;
    MakeFrame(AFN_CTRL_ROUTER,F3);
    if F_Main.SendDataAuto()
      and WaitForResp(Sender,AFN_CONFIRM,F1)
    then;
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_Mod.FormCreate(Sender: TObject);
var i:Integer;
begin
    inherited;
    cbb_plc_frequency.Clear;
    if g_fre_type=ftOld then
    begin
        cbb_plc_frequency.Items.AddObject('80/120K��˫��Ƶģʽ', TObject($BBFB));
        cbb_plc_frequency.Items.AddObject('80/120K��XC����ģʽ', TObject($BBFC));
        cbb_plc_frequency.Items.AddObject('96/160K��˫��Ƶģʽ', TObject($CCFD));
        cbb_plc_frequency.Items.AddObject('96/160K������ģʽ',   TObject($CCFA));
        cbb_plc_frequency.Items.AddObject('F7 ��Ƶģʽ',         TObject($BBF7));
        cbb_plc_frequency.Items.AddObject('F9 ����ģʽ',         TObject($BBF9));
    end
    else
    begin
        cbb_plc_frequency.Items.AddObject('����3��', TObject($BBF3));
        for i:=1 to 15 do
        begin
            //F3, BB BB BB ��������
            //BX, BB BB BB  ����3.5��  X:0-F
            cbb_plc_frequency.Items.AddObject(Format('����3.5����%.2d',[i]), TObject(StrToInt( Format('xBBB%x', [i]) )));
        end;
        cbb_plc_frequency.ItemIndex := cbb_plc_frequency.Items.IndexOfObject(TObject($BBBA));
    end;

    cbb_rt_mode.Clear;
    cbb_rt_mode.Items.AddObject('01H��׼Э��', TObject($01));
    cbb_rt_mode.Items.AddObject('02H��չ·��Э��', TObject($02));
    cbb_rt_mode.Items.AddObject('03H����RT-IIIЭ��', TObject($03));

    cbb_meter_protocol_snChange(cbb_meter_protocol_sn);
end;

procedure TF_Param_Mod.chk_allClick(Sender: TObject);
begin
    inherited;
    MakeCheck(scrlbx1, TCheckBox(Sender).Checked);
end;

procedure TF_Param_Mod.btn_read_meter_energyClick(Sender: TObject);
var ret:Boolean;
    meterNo:Int64;
begin
    if TryStrToInt64('x'+edt_meter_no.Text, meterNo) then
    begin
        O_ProTx_645.SetDeviceAddr(meterNo);
    end;
    
    TButton(Sender).Enabled := False;
    g_bStop := False;

    edt_read_energy.Text := '';
    
    if cbb_meter_protocol.ItemIndex=0 then
        ret := SendFrame_645(Sender, ctrl_read_97, $9010)
    else
        ret := SendFrame_645(Sender, ctrl_read_07, $00010000);

    if ret then
    begin
        edt_read_energy.Text := Format('%.6x.%.2x',[m_data shr 8 and $ffffff, m_data and $ff]);
    end;
        
    TButton(Sender).Enabled := True;
end;

procedure TF_Param_Mod.btn_read_meter_energy_by_snClick(Sender: TObject);
var ret:Boolean;
    meterSn:Int64;
    meter_sn_start:Int64;
    meter_sn_end:Int64;
    pData:PByte;
    DI:Int64;
begin
    TButton(Sender).Enabled := False;
    
    TryStrToInt64(edt_meter_sn_start.Text, meter_sn_start);
    TryStrToInt64(edt_meter_sn_end.Text, meter_sn_end);
    g_bStop := False;
    meterSn := meter_sn_start;
    edt_success.Text := '0';
    edt_failed.Text := '0';
    while not g_bStop do
    begin
        O_ProTx_645.SetDeviceAddr(meterSn);

        TryStrToInt64('x'+edt_DI.Text, DI);
        if cbb_meter_protocol_sn.ItemIndex=0 then
            ret := SendFrame_645_2(Sender, ctrl_read_97, DI)
        else
            ret := SendFrame_645_2(Sender, ctrl_read_07, DI);

        if ret then
        begin
            if (GetAFN()=$13)and(GetFn()=F1) then
            begin
                pData := GetDataUnit();
                Inc(pData);
                if (pData^<>0) then //����ʱ
                begin
                    edt_success.Text := IntToStr(StrToInt(edt_success.Text)+1);
                end
                else //��ʱ
                begin
                    edt_failed.Text := IntToStr(StrToInt(edt_failed.Text)+1);
                end;
            end;
        end
        else
        begin
            edt_failed.Text := IntToStr(StrToInt(edt_failed.Text)+1);
        end;

        Inc(meterSn);
        if meterSn>meter_sn_end then Break;
    end;

    TButton(Sender).Enabled := True;
end;

procedure TF_Param_Mod.cbb_meter_protocol_snChange(Sender: TObject);
begin
    inherited;
    if cbb_meter_protocol_sn.ItemIndex=0 then
        edt_DI.Text := '9010'
    else
        edt_DI.Text := '00010000';
end;

end.
