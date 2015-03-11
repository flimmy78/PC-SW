unit U_MeterFile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_ParamReadWrite, DB, ADODB, StdCtrls, Grids, DBGrids, CRGrid,
  ExtCtrls, Buttons, MemDS, VirtualTable, U_DataModule, Menus, U_MyFunction,
  U_Protocol, U_Protocol_con, U_AddMdyMeter, ComCtrls, DateUtils;

type
  TF_MeterFile = class(TF_ParamReadWrite)
    grp1: TGroupBox;
    grp2: TGroupBox;
    pnl1: TPanel;
    strngrd_PowerDropRecord: TStringGrid;
    pnl2: TPanel;
    strngrd_SelfPowerOnCountRecord: TStringGrid;
    btn_read_status: TBitBtn;
    btn_SelfPowerOn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btn_read_statusClick(Sender: TObject);
    procedure btn_SelfPowerOnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
      m_strDistCode, m_strTermAddr:string;
      m_maxMeterSn:Integer;
      m_maxMeterNo:Int64;
  end;

var
  F_MeterFile: TF_MeterFile;

implementation

{$R *.dfm}

uses U_Main, U_MeterFileSyn;

const powerdrop_col_time    = 1;
      powerdrop_col_keep    = 2;

      SelfPowerOn_col_time    = 1;
      SelfPowerOn_col_keep    = 2;

procedure TF_MeterFile.FormCreate(Sender: TObject);
begin
    inherited;
    strngrd_PowerDropRecord.ColWidths[0] := 0;
    strngrd_PowerDropRecord.ColWidths[powerdrop_col_time]     := 180;
    strngrd_PowerDropRecord.ColWidths[powerdrop_col_keep]     := 100;
    strngrd_PowerDropRecord.Cells[powerdrop_col_time,0]       := '发生时间';
    strngrd_PowerDropRecord.Cells[powerdrop_col_keep,0]       := '时长(ms)';

    strngrd_SelfPowerOnCountRecord.ColWidths[0] := 0;
    strngrd_SelfPowerOnCountRecord.ColWidths[SelfPowerOn_col_time]     := 180;
    //strngrd_SelfPowerOnCountRecord.ColWidths[SelfPowerOn_col_keep]     := 100;
    strngrd_SelfPowerOnCountRecord.Cells[SelfPowerOn_col_time,0]       := '发生时间';
    //strngrd_SelfPowerOnCountRecord.Cells[SelfPowerOn_col_keep,0]       := '时长(ms)';
end;

procedure TF_MeterFile.btn_read_statusClick(Sender: TObject);
var p:PByte;
    dataUnit:array[0..63]of Byte;
    strTmp:string;
    i, nCount:Integer;
    nTmp:Int64;
    nRow, nRows:Integer;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    if not g_bStop then
    begin
        strngrd_PowerDropRecord.RowCount := 2;
        strngrd_PowerDropRecord.Rows[1].Clear;
        
        MakeFrame(MODBUS_EXT_READ_REG, MODBUS_CONF_START_ADDR+MODBUS_CONF2_ADDR, 46);
        
        if F_Main.SendDataAuto()
          and WaitForResp(Sender, MODBUS_EXT_READ_REG)
        then
        begin
            p := O_ProRx.GetUserData();
            Inc(p, 1);

            nRows := mb_swap(PWord(p)^); Inc(p, 2);

            for nRow:=1 to nRows do
            begin
                if nRow>1 then
                begin
                    strngrd_PowerDropRecord.RowCount := strngrd_PowerDropRecord.RowCount + 1;
                end;
                strngrd_PowerDropRecord.Cells[powerdrop_col_time, nRow] := Format('%.2d-%.2d-%.2d %.2d:%.2d:%.2d', [
                        PByte(Integer(p)+6)^,
                        PByte(Integer(p)+5)^,
                        PByte(Integer(p)+4)^,
                        PByte(Integer(p)+2)^,
                        PByte(Integer(p)+1)^,
                        PByte(Integer(p)+0)^
                        ]);
                Inc(p, 7);
                strngrd_PowerDropRecord.Cells[powerdrop_col_keep, nRow] := Format('%d', [mb_swap(PWord(p)^)]);
                Inc(p, 2);
            end;
        end;
    end;

    TButton(Sender).Enabled := True;
end;

procedure TF_MeterFile.btn_SelfPowerOnClick(Sender: TObject);
var p:PByte;
    dataUnit:array[0..63]of Byte;
    strTmp:string;
    i, nCount:Integer;
    nTmp:Int64;
    nRow, nRows:Integer;
begin
    TButton(Sender).Enabled := False;
    g_bStop := False;

    if not g_bStop then
    begin
        strngrd_SelfPowerOnCountRecord.RowCount := 2;
        strngrd_SelfPowerOnCountRecord.Rows[1].Clear;
        
        MakeFrame(MODBUS_EXT_READ_REG, MODBUS_CONF_START_ADDR+MODBUS_CONF3_ADDR, 36);
        
        if F_Main.SendDataAuto()
          and WaitForResp(Sender, MODBUS_EXT_READ_REG)
        then
        begin
            p := O_ProRx.GetUserData();
            Inc(p, 1);

            nRows := mb_swap(PWord(p)^); Inc(p, 2);

            for nRow:=1 to nRows do
            begin
                if nRow>1 then
                begin
                    strngrd_SelfPowerOnCountRecord.RowCount := strngrd_SelfPowerOnCountRecord.RowCount + 1;
                end;
                strngrd_SelfPowerOnCountRecord.Cells[SelfPowerOn_col_time, nRow] := Format('%.2d-%.2d-%.2d %.2d:%.2d:%.2d', [
                        PByte(Integer(p)+6)^,
                        PByte(Integer(p)+5)^,
                        PByte(Integer(p)+4)^,
                        PByte(Integer(p)+2)^,
                        PByte(Integer(p)+1)^,
                        PByte(Integer(p)+0)^
                        ]);
                Inc(p, 7);
                //strngrd_SelfPowerOnCountRecord.Cells[SelfPowerOn_col_keep, nRow] := Format('%d', [mb_swap(PWord(p)^)]);
                //Inc(p, 2);
            end;
        end;
    end;

    TButton(Sender).Enabled := True;
end;

end.
