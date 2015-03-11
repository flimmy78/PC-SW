unit U_MeterFileSyn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_ParamReadWrite, U_DataModule, StdCtrls, Buttons, ExtCtrls,
  Grids, DBGrids, CRGrid, DB, MemDS, VirtualTable, U_Protocol, U_Protocol_con,
  Menus, U_MyFunction;

type
  TF_MeterFileSyn = class(TF_ParamReadWrite)
    grp2: TGroupBox;
    crdbgrd2: TCRDBGrid;
    pnl3: TPanel;
    btn_read_file: TBitBtn;
    btn_syn_file: TBitBtn;
    btn_syn_file_reverse: TBitBtn;
    ds_meter: TDataSource;
    vrtltbl_meter: TVirtualTable;
    pm1: TPopupMenu;
    N_DelCurMeter_T: TMenuItem;
    N_DelTotalMeter_T: TMenuItem;
    N_DelPlcMeter_T: TMenuItem;
    N_Del485Meter_T: TMenuItem;
    N_DelAcsMeter_T: TMenuItem;
    btn_stop: TBitBtn;
    procedure btn_read_fileClick(Sender: TObject);
    procedure btn_syn_fileClick(Sender: TObject);
    procedure crdbgrd2GetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; State: TGridDrawState;
      StateEx: TGridDrawStateEx);
    procedure N_DelCurMeter_TClick(Sender: TObject);
    procedure N_DelTotalMeter_TClick(Sender: TObject);
    procedure N_DelPlcMeter_TClick(Sender: TObject);
    procedure N_Del485Meter_TClick(Sender: TObject);
    procedure N_DelAcsMeter_TClick(Sender: TObject);
    procedure btn_stopClick(Sender: TObject);
  private
    { Private declarations }
    //m_strDistCode, m_strTermAddr:string;
    function MeterNoToString(pMeterNo:PByte):string;//电表表号转为字符串
    function IsMeterEqual():Boolean;
  public
    { Public declarations }
  end;

var
  F_MeterFileSyn: TF_MeterFileSyn;

implementation

{$R *.dfm}

uses U_MeterFile, U_Main;

function TF_MeterFileSyn.MeterNoToString(pMeterNo:PByte):string;//电表表号转为字符串
begin
    Result:=Format('%.2X%.2X%.2X%.2X%.2X%.2X',[
        PByte(Integer(pMeterNo)+5)^,
        PByte(Integer(pMeterNo)+4)^,
        PByte(Integer(pMeterNo)+3)^,
        PByte(Integer(pMeterNo)+2)^,
        PByte(Integer(pMeterNo)+1)^,
        PByte(Integer(pMeterNo)+0)^
        ]);
end;

procedure TF_MeterFileSyn.btn_read_fileClick(Sender: TObject);
var i, j, nHasReadCounter, nTotalMeterCount, nMeterSn:Integer;
    pMeterStat:PTMeterStat;
    pMeterFile:PTMeterFile3761;
    p, p0:PByte;
    nPortCount:Byte;
    nReadCount:Word;
    buf:array[0..1023] of Byte;
    curRecNo:Integer;
const MAX_READ_METER_COUNT = 20;
begin
    g_bStop := False;
    TButton(Sender).Enabled := False;
    if vrtltbl_meter.RecordCount>0 then
    begin
        curRecNo := vrtltbl_meter.RecNo;
        vrtltbl_meter.DisableControls;
        vrtltbl_meter.First;
        i := vrtltbl_meter.FieldByName('MSN_T').Index;
        while not vrtltbl_meter.Eof do
        begin
            if vrtltbl_meter.FieldByName('MSN_M').AsString<>'' then
            begin
                vrtltbl_meter.Edit;
                for j:=i to vrtltbl_meter.FieldCount-1 do
                begin
                    vrtltbl_meter.Fields[j].AsString := '';
                end;
                vrtltbl_meter.Post;
            end
            else
            begin
                vrtltbl_meter.Delete;
            end;
            vrtltbl_meter.Next;
        end;
        vrtltbl_meter.EnableControls;
        vrtltbl_meter.RecNo := curRecNo;
    end;

    nHasReadCounter := 0;
    nTotalMeterCount  := 0;

    p0 := @buf[0];
    
    MakeFrame(AFN_CLASS_1, F11);
    if F_Main.SendDataAuto()
      and WaitForResp(Sender, AFN_CLASS_1, F11)
    then
    begin
        p := O_ProRx.GetDataUnit;
        nPortCount := p^;   Inc(p);
        pMeterStat := PTMeterStat(p);
        
        if nPortCount<=10 then
        begin
            for i:=1 to nPortCount do
            begin
                Inc(nTotalMeterCount, pMeterStat.meterCount);
                Inc(pMeterStat);
            end;
        end;

        nMeterSn := 1;
        while (nHasReadCounter<nTotalMeterCount) and (not g_bStop) do
        begin
            p := p0;
            PWord(p)^ := MAX_READ_METER_COUNT;
            Inc(p, 2);
            for i:=1 to MAX_READ_METER_COUNT do
            begin
                PWord(p)^ := nMeterSn;
                Inc(nMeterSn);
                Inc(p, 2);
            end;
            MakeFrame(AFN_READ_PARAM, F10, p0, Integer(p)-Integer(p0));
            if F_Main.SendDataAuto()
              and WaitForResp(Sender, AFN_READ_PARAM, F10)
            then
            begin
                p := O_ProRx.GetDataUnit;
                nReadCount := PWord(p)^;  Inc(p, 2);
                Inc(nHasReadCounter, nReadCount);
                pMeterFile := PTMeterFile3761(p);
                for i:=1 to nReadCount do
                begin
                    if vrtltbl_meter.Locate('MSN_M', pMeterFile.nMeterSn, []) then
                    begin
                        vrtltbl_meter.Edit;
                    end
                    else
                    begin
                        vrtltbl_meter.Append;
                    end;
                    vrtltbl_meter.FieldByName('MSN_T').AsInteger := pMeterFile.nMeterSn;
                    vrtltbl_meter.FieldByName('MADDR_T').AsString := MeterNoToString(@pMeterFile.aMeterNo[0]);
                    vrtltbl_meter.FieldByName('MSPEED_T').AsInteger := pMeterFile.nCommParam shr 5 and $07;
                    vrtltbl_meter.FieldByName('MPORT_T').AsInteger := pMeterFile.nCommParam shr 0 and $1f;
                    vrtltbl_meter.FieldByName('MPROTOCOL_T').AsInteger := pMeterFile.nProtoType;
                    vrtltbl_meter.FieldByName('MPWD_T').AsString := Format('%.8d',[PInt64(@pMeterFile.aMeterPwd[0])^ and $ffffffffffff]);
                    vrtltbl_meter.FieldByName('MTARIFF_T').AsInteger := pMeterFile.nTariffCount;
                    vrtltbl_meter.FieldByName('MENERINTNUM_T').AsInteger := pMeterFile.nActEnerDisplay shr 2 and $03;
                    vrtltbl_meter.FieldByName('MENERDECNUM_T').AsInteger := pMeterFile.nActEnerDisplay shr 0 and $03;
                    vrtltbl_meter.FieldByName('MCOLLADDR_T').AsString := MeterNoToString(@pMeterFile.aCollTerNo[0]);
                    vrtltbl_meter.FieldByName('MLARGECLASS_T').AsInteger := pMeterFile.nUserType shr 4 and $0f;
                    vrtltbl_meter.FieldByName('MSMALLCLASS_T').AsInteger := pMeterFile.nUserType shr 0 and $0f;
                    vrtltbl_meter.Post;
                    
                    Inc(pMeterFile);
                end;
            end
            else
            begin
                Break;
            end;
        end;
    end;

    vrtltbl_meter.DisableControls;
    vrtltbl_meter.First;
    while not vrtltbl_meter.Eof do
    begin
        vrtltbl_meter.Edit;
        if IsMeterEqual() then
            vrtltbl_meter.FieldByName('MFLAG').AsString := '＝'
        else
            vrtltbl_meter.FieldByName('MFLAG').AsString := '≠';
        vrtltbl_meter.Post;
        vrtltbl_meter.Next;
    end;
    vrtltbl_meter.EnableControls;
    TButton(Sender).Enabled := True;
end;

procedure TF_MeterFileSyn.N_DelCurMeter_TClick(Sender: TObject);
var buf:array[0..1023] of Byte;
    p, p0:PByte;
    nRecNo:Integer;
begin
    inherited;
    if ''<>vrtltbl_meter.FieldByName('MSN_T').AsString then
    begin
        if MyMessageBox(Handle, Format('确定要删除集中器内的电表“%s-%s”吗？', [vrtltbl_meter.FieldByName('MSN_T').AsString, vrtltbl_meter.FieldByName('MADDR_T').AsString]), '提示', MB_YESNO or MB_ICONQUESTION) = IDYES then
        begin
            p0 := @buf[0];
            nRecNo := vrtltbl_meter.RecNo;
            p := p0;
            PWord(p)^ := 1; Inc(p, 2);
            PWord(p)^ := vrtltbl_meter.FieldByName('MSN_T').AsInteger; Inc(p, 2);
            PWord(p)^ := 0; Inc(p, 2);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MSPEED_T').AsInteger shl 5) or (vrtltbl_meter.FieldByName('MPORT_T').AsInteger and $1f); Inc(p, 1);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MPROTOCOL_T').AsInteger); Inc(p, 1);
            TryStrToInt64('x'+vrtltbl_meter.FieldByName('MADDR_T').AsString, PInt64(p)^);   Inc(p, 6);
            TryStrToInt64(vrtltbl_meter.FieldByName('MPWD_T').AsString, PInt64(p)^);   Inc(p, 6);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MTARIFF_T').AsInteger); Inc(p, 1);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MENERINTNUM_T').AsInteger shl 2 and $0c) or (vrtltbl_meter.FieldByName('MENERDECNUM_T').AsInteger and $03); Inc(p, 1);
            TryStrToInt64('x'+vrtltbl_meter.FieldByName('MCOLLADDR_T').AsString, PInt64(p)^);   Inc(p, 6);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MLARGECLASS_T').AsInteger shl 4 and $f0) or (vrtltbl_meter.FieldByName('MSMALLCLASS_T').AsInteger and $0f); Inc(p, 1);
            
            MakeFrame(AFN_WRITE_PARAM, F10, p0, Integer(p)-Integer(p0));
            if F_Main.SendDataAuto()
              and WaitForResp(Sender, AFN_CONFIRM, F1)
            then
            begin
                vrtltbl_meter.RecNo := nRecNo;
                vrtltbl_meter.Edit;
                vrtltbl_meter.FieldByName('MSN_T').AsString         := '';
                vrtltbl_meter.FieldByName('MADDR_T').AsString       := '';
                vrtltbl_meter.FieldByName('MSPEED_T').AsString      := '';
                vrtltbl_meter.FieldByName('MPROTOCOL_T').AsString   := '';
                vrtltbl_meter.FieldByName('MPWD_T').AsString        := '';
                vrtltbl_meter.FieldByName('MTARIFF_T').AsString     := '';
                vrtltbl_meter.FieldByName('MENERINTNUM_T').AsString := '';
                vrtltbl_meter.FieldByName('MENERDECNUM_T').AsString := '';
                vrtltbl_meter.FieldByName('MCOLLADDR_T').AsString   := '';
                vrtltbl_meter.FieldByName('MLARGECLASS_T').AsString := '';
                vrtltbl_meter.FieldByName('MSMALLCLASS_T').AsString := '';
                vrtltbl_meter.FieldByName('MFLAG').AsString := '≠';
                vrtltbl_meter.Post;
            end;
        end;
    end;
end;

procedure TF_MeterFileSyn.N_DelPlcMeter_TClick(Sender: TObject);
begin
  inherited;
//
end;

procedure TF_MeterFileSyn.N_Del485Meter_TClick(Sender: TObject);
begin
  inherited;
//
end;

procedure TF_MeterFileSyn.N_DelAcsMeter_TClick(Sender: TObject);
begin
  inherited;
//
end;

procedure TF_MeterFileSyn.N_DelTotalMeter_TClick(Sender: TObject);
var buf:array[0..1023] of Byte;
    p, p0:PByte;
begin
    inherited;
//
end;

procedure TF_MeterFileSyn.btn_syn_fileClick(Sender: TObject);
const MAX_DEL_METER_COUNT = 10;
      MAX_LOAD_METER_COUNT = 10;
var i, j, nMeterCounter, nStartNo, nRecNo:Integer;
    nMeterSnBuf:array [0..MAX_DEL_METER_COUNT-1] of Integer;
    p, p0:PByte;
    buf:array[0..1023] of Byte; 
begin
    inherited;
    g_bStop := False;
    TButton(Sender).Enabled := False;
    p0 := @buf[0];
    //删除集中器存在，主站不存在的电表，删除成功的档案，同时删除当前行
    nMeterCounter := 0;
    p := p0;
    PWord(p)^ := 0; Inc(p, 2);
    i := 1;
    while (i<=vrtltbl_meter.RecordCount) and (not g_bStop) do
    begin
        vrtltbl_meter.RecNo := i;

        if ''=vrtltbl_meter.FieldByName('MSN_M').AsString then
        begin
            nMeterSnBuf[nMeterCounter] := vrtltbl_meter.FieldByName('MSN_T').AsInteger;
            
            PWord(p)^ := vrtltbl_meter.FieldByName('MSN_T').AsInteger; Inc(p, 2);
            PWord(p)^ := 0; Inc(p, 2);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MSPEED_T').AsInteger shl 5) or (vrtltbl_meter.FieldByName('MPORT_T').AsInteger and $1f); Inc(p, 1);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MPROTOCOL_T').AsInteger); Inc(p, 1);
            TryStrToInt64('x'+vrtltbl_meter.FieldByName('MADDR_T').AsString, PInt64(p)^);   Inc(p, 6);
            TryStrToInt64(vrtltbl_meter.FieldByName('MPWD_T').AsString, PInt64(p)^);   Inc(p, 6);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MTARIFF_T').AsInteger); Inc(p, 1);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MENERINTNUM_T').AsInteger shl 2 and $0c) or (vrtltbl_meter.FieldByName('MENERDECNUM_T').AsInteger and $03); Inc(p, 1);
            TryStrToInt64('x'+vrtltbl_meter.FieldByName('MCOLLADDR_T').AsString, PInt64(p)^);   Inc(p, 6);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MLARGECLASS_T').AsInteger shl 4 and $f0) or (vrtltbl_meter.FieldByName('MSMALLCLASS_T').AsInteger and $0f); Inc(p, 1);

            Inc(nMeterCounter);
        end;
        if (nMeterCounter>=MAX_DEL_METER_COUNT)or ((i=vrtltbl_meter.RecordCount) and (nMeterCounter>0)) then
        begin
            //删除
            PWord(p0)^ := nMeterCounter;
            MakeFrame(AFN_WRITE_PARAM, F10, p0, Integer(p)-Integer(p0));
            if F_Main.SendDataAuto()
              and WaitForResp(Sender, AFN_CONFIRM, F1)
            then
            begin
                for j:=0 to nMeterCounter-1 do
                begin
                    if vrtltbl_meter.Locate('MSN_T', nMeterSnBuf[j], []) then
                    begin
                        vrtltbl_meter.Delete;
                        Inc(i, -1);
                    end;
                end;
            end;
            nMeterCounter := 0;
            p := p0;
            PWord(p)^ := 0; Inc(p, 2);
        end;
        Inc(i);
    end;
    
    //加载与主站不一致的电表档案，加载成功右边同时显示已加载的档案
    nMeterCounter := 0;
    p := p0;
    PWord(p)^ := 0; Inc(p, 2);
    i := 1;
    while (i<=vrtltbl_meter.RecordCount) and (not g_bStop) do
    begin
        vrtltbl_meter.RecNo := i;

        if not IsMeterEqual() then
        begin
            vrtltbl_meter.Edit;
            vrtltbl_meter.FieldByName('MFLAG').AsString := '≠';
            vrtltbl_meter.Post;
            nMeterSnBuf[nMeterCounter] := vrtltbl_meter.FieldByName('MSN_M').AsInteger;
            
            PWord(p)^ := vrtltbl_meter.FieldByName('MSN_M').AsInteger; Inc(p, 2);
            PWord(p)^ := vrtltbl_meter.FieldByName('MSN_M').AsInteger; Inc(p, 2);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MSPEED_M').AsInteger shl 5) or (vrtltbl_meter.FieldByName('MPORT_M').AsInteger and $1f); Inc(p, 1);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MPROTOCOL_M').AsInteger); Inc(p, 1);
            TryStrToInt64('x'+vrtltbl_meter.FieldByName('MADDR_M').AsString, PInt64(p)^);   Inc(p, 6);
            TryStrToInt64(vrtltbl_meter.FieldByName('MPWD_M').AsString, PInt64(p)^);   Inc(p, 6);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MTARIFF_M').AsInteger); Inc(p, 1);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MENERINTNUM_M').AsInteger shl 2 and $0c) or (vrtltbl_meter.FieldByName('MENERDECNUM_M').AsInteger and $03); Inc(p, 1);
            TryStrToInt64('x'+vrtltbl_meter.FieldByName('MCOLLADDR_M').AsString, PInt64(p)^);   Inc(p, 6);
            PByte(p)^ := (vrtltbl_meter.FieldByName('MLARGECLASS_M').AsInteger shl 4 and $f0) or (vrtltbl_meter.FieldByName('MSMALLCLASS_M').AsInteger and $0f); Inc(p, 1);

            Inc(nMeterCounter);
        end
        else
        begin
            vrtltbl_meter.Edit;
            vrtltbl_meter.FieldByName('MFLAG').AsString := '＝';
            vrtltbl_meter.Post;
        end;
        if (nMeterCounter>=MAX_DEL_METER_COUNT)or ((i=vrtltbl_meter.RecordCount) and (nMeterCounter>0)) then
        begin
            //增加
            PWord(p0)^ := nMeterCounter;
            MakeFrame(AFN_WRITE_PARAM, F10, p0, Integer(p)-Integer(p0));
            if F_Main.SendDataAuto()
              and WaitForResp(Sender, AFN_CONFIRM, F1)
            then
            begin
                for j:=0 to nMeterCounter-1 do
                begin
                    if vrtltbl_meter.Locate('MSN_M', nMeterSnBuf[j], []) then
                    begin
                        vrtltbl_meter.Edit;
                        vrtltbl_meter.FieldByName('MSN_T').AsString         := vrtltbl_meter.FieldByName('MSN_M').AsString;
                        vrtltbl_meter.FieldByName('MADDR_T').AsString       := vrtltbl_meter.FieldByName('MADDR_M').AsString;
                        vrtltbl_meter.FieldByName('MSPEED_T').AsString      := vrtltbl_meter.FieldByName('MSPEED_M').AsString;
                        vrtltbl_meter.FieldByName('MPROTOCOL_T').AsString   := vrtltbl_meter.FieldByName('MPROTOCOL_M').AsString;
                        vrtltbl_meter.FieldByName('MPWD_T').AsString        := vrtltbl_meter.FieldByName('MPWD_M').AsString;
                        vrtltbl_meter.FieldByName('MTARIFF_T').AsString     := vrtltbl_meter.FieldByName('MTARIFF_M').AsString;
                        vrtltbl_meter.FieldByName('MENERINTNUM_T').AsString := vrtltbl_meter.FieldByName('MENERINTNUM_M').AsString;
                        vrtltbl_meter.FieldByName('MENERDECNUM_T').AsString := vrtltbl_meter.FieldByName('MENERDECNUM_M').AsString;
                        vrtltbl_meter.FieldByName('MCOLLADDR_T').AsString   := vrtltbl_meter.FieldByName('MCOLLADDR_M').AsString;
                        vrtltbl_meter.FieldByName('MLARGECLASS_T').AsString := vrtltbl_meter.FieldByName('MLARGECLASS_M').AsString;
                        vrtltbl_meter.FieldByName('MSMALLCLASS_T').AsString := vrtltbl_meter.FieldByName('MSMALLCLASS_M').AsString;
                        vrtltbl_meter.FieldByName('MFLAG').AsString := '＝';
                        vrtltbl_meter.Post;
                    end;
                end;
            end;
            nMeterCounter := 0;
            p := p0;
            PWord(p)^ := 0; Inc(p, 2);
        end;
        Inc(i);
    end;
    TButton(Sender).Enabled := True;
end;

function TF_MeterFileSyn.IsMeterEqual():Boolean;
begin
    if (vrtltbl_meter.FieldByName('MSN_M').AsString<>vrtltbl_meter.FieldByName('MSN_T').AsString)
      or (vrtltbl_meter.FieldByName('MADDR_M').AsString<>vrtltbl_meter.FieldByName('MADDR_T').AsString)
      or (vrtltbl_meter.FieldByName('MSPEED_M').AsString<>vrtltbl_meter.FieldByName('MSPEED_T').AsString)
      or (vrtltbl_meter.FieldByName('MPORT_M').AsString<>vrtltbl_meter.FieldByName('MPORT_T').AsString)
      or (vrtltbl_meter.FieldByName('MPROTOCOL_M').AsString<>vrtltbl_meter.FieldByName('MPROTOCOL_T').AsString)
      or (vrtltbl_meter.FieldByName('MPWD_M').AsString<>vrtltbl_meter.FieldByName('MPWD_T').AsString)
      or (vrtltbl_meter.FieldByName('MTARIFF_M').AsString<>vrtltbl_meter.FieldByName('MTARIFF_T').AsString)
      or (vrtltbl_meter.FieldByName('MENERINTNUM_M').AsString<>vrtltbl_meter.FieldByName('MENERINTNUM_T').AsString)
      or (vrtltbl_meter.FieldByName('MENERDECNUM_M').AsString<>vrtltbl_meter.FieldByName('MENERDECNUM_T').AsString)
      or (vrtltbl_meter.FieldByName('MCOLLADDR_M').AsString<>vrtltbl_meter.FieldByName('MCOLLADDR_T').AsString)
      or (vrtltbl_meter.FieldByName('MLARGECLASS_M').AsString<>vrtltbl_meter.FieldByName('MLARGECLASS_T').AsString)
      or (vrtltbl_meter.FieldByName('MSMALLCLASS_M').AsString<>vrtltbl_meter.FieldByName('MSMALLCLASS_T').AsString)
    then
    begin
        Result := False;
    end
    else
    begin
        Result := True;
    end;
end;

procedure TF_MeterFileSyn.crdbgrd2GetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor;
  State: TGridDrawState; StateEx: TGridDrawStateEx);
begin
    inherited;
    if gdSelected in State then Exit;
    if ((Sender as TCRDBGrid).DataSource.DataSet.RecNo mod 2 = 0)then
    begin
        Background:=$e4f8da;
    end
    else
    begin
        Background:=$e1ffff;
        //Background:=$ffffe1;//这颜色也不错
    end;

    if 'MFLAG'=Field.FieldName then
    begin
        if '≠'=Field.AsString then
        begin
            Background := clRed;
        end;
    end;
end;


procedure TF_MeterFileSyn.btn_stopClick(Sender: TObject);
begin
    g_bStop := True;
end;

end.
