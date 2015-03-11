unit U_ParamReadWrite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,U_Protocol,DateUtils,U_MyFunction;

type
  TF_ParamReadWrite = class(TForm)
    scrlbx1: TScrollBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    m_bResp:Boolean;
    m_pData:PByte;  //指向应答帧的数据单元
    m_data:Int64;   //存储应答帧的数据单元，从最低字节开始
    m_nLen:Integer; //存储应答帧的数据单元的长度
    function MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte; overload; virtual;
    function MakeFrame(AFN:Byte; pUserData:P_USER_DATA):PByte; overload; virtual;
    function MakeFrame(ctrl:Byte; regAddr:Integer; pDataUnit:PByte=nil; len:Integer=0):PByte;overload;virtual;
    function MakeFrame(ctrl:Byte; regAddr:Integer; regLen:Integer):PByte;overload;virtual;
    procedure ParseData(pCommEntity:Pointer=nil);virtual;
    function WaitForResp(Sender: TObject;AFN,Fn:Byte):Boolean;overload;virtual;
    function WaitForResp(Sender: TObject; ctrl:Byte):Boolean;overload;virtual;
    function GetDataUnit():PByte;virtual;
    function GetDataUnitLen():Integer;virtual;
    function GetUserData():PByte;virtual;
    function GetUserDataLen():Integer;virtual;
    function GetAFN():Byte;virtual;
    function GetFn():Byte;overload;virtual;
    function GetFn(DT1:Byte; DT2:Byte):Byte;overload;virtual;
    function GetPn():Integer;overload;virtual;
    function GetPn(DA1:Byte; DA2:Byte):Integer;overload;virtual;
    function SendFrame_645(Sender: TObject; ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):Boolean;virtual;
    function Test():Byte;overload;virtual;
    function Test(a:Integer):Byte;overload;virtual;
  end;

var
  F_ParamReadWrite: TF_ParamReadWrite;

implementation

uses U_Main, U_Operation;

{$R *.dfm}
function TF_ParamReadWrite.Test():Byte;
begin
    ShowMessage('11111');
end;

function TF_ParamReadWrite.Test(a:Integer):Byte;
begin

end;

function TF_ParamReadWrite.MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
begin
    Result := O_ProTx.MakeFrame(AFN, Fn, pDataUnit, len, Pn, IS_COMM_MODULE_ID_PLC);
end;

function TF_ParamReadWrite.MakeFrame(AFN:Byte; pUserData:P_USER_DATA):PByte;
begin
    Result := O_ProTx.MakeFrame(AFN, pUserData);
end;

function TF_ParamReadWrite.MakeFrame(ctrl:Byte; regAddr:Integer; pDataUnit:PByte=nil; len:Integer=0):PByte;
begin
    Result := O_ProTx.MakeFrame(ctrl, regAddr, pDataUnit, len);
end;

function TF_ParamReadWrite.MakeFrame(ctrl:Byte; regAddr:Integer; regLen:Integer):PByte;
begin
    Result := O_ProTx.MakeFrame(ctrl, regAddr, regLen);
end;

function TF_ParamReadWrite.GetDataUnit():PByte;
begin
    Result := O_ProRx.GetDataUnit();
end;

function TF_ParamReadWrite.GetDataUnitLen():Integer;
begin
    Result := O_ProRx.GetDataUnitLen();
end;

function TF_ParamReadWrite.GetUserData():PByte;
begin
    Result := O_ProRx.GetUserData();
end;

function TF_ParamReadWrite.GetUserDataLen():Integer;
begin
    Result := O_ProRx.GetUserDataLen();
end;

function TF_ParamReadWrite.GetAFN():Byte;
begin
    Result := O_ProRx.GetAFN();
end;

function TF_ParamReadWrite.GetFn():Byte;
begin
    Result := O_ProRx.GetFn();
end;

function TF_ParamReadWrite.GetFn(DT1:Byte; DT2:Byte):Byte;
begin
    Result := O_ProRx.GetFn(DT1, DT2);
end;

function TF_ParamReadWrite.GetPn():Integer;
begin
    Result := O_ProRx.GetPn();
end;

function TF_ParamReadWrite.GetPn(DA1:Byte; DA2:Byte):Integer;
begin
    Result := O_ProRx.GetPn(DA1, DA2);
end;

function TF_ParamReadWrite.SendFrame_645(Sender: TObject; ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):Boolean;
begin
    Result := False;
end;

function TF_ParamReadWrite.WaitForResp(Sender: TObject;AFN,Fn:Byte):Boolean;
var beginWait:TDateTime;
    clr:TColor;
    nWaitTime:Integer;
begin
    m_bResp := False;
    Result := False;
    beginWait := Now;

    //nWaitTime := 12000;
    //nWaitTime := nWaitTime + 2000*(O_ProTx.GetRelayLevel());
    nWaitTime := g_timeout + 3000;

    if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clBlack;
    if Sender is TButton then TButton(Sender).Font.Color := clBlack;
    
    while (not m_bResp)and(Abs(MilliSecondsBetween(Now,beginWait))<nWaitTime) do
    begin
        Delay(100);
        if g_bStop then Break;
    end;

    if (m_bResp) then
    begin
        if (GetAFN()=AFN)and(GetFn()=Fn) then
        begin
            Result := True;
        end;
    end;

    if Result then
    begin
        clr := clSucced;
    end
    else
    begin
        clr := clFailed;
    end;
    if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clr;
    if Sender is TButton then TButton(Sender).Font.Color :=clr;    
end;

function TF_ParamReadWrite.WaitForResp(Sender: TObject; ctrl:Byte):Boolean;
var beginWait:TDateTime;
    clr:TColor;
    nWaitTime:Integer;
begin
    m_bResp := False;
    Result := False;
    beginWait := Now;

    nWaitTime := g_timeout + 3000;

    if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clBlack;
    if Sender is TButton then TButton(Sender).Font.Color := clBlack;
    
    while (not m_bResp)and(Abs(MilliSecondsBetween(Now,beginWait))<nWaitTime) do
    begin
        Delay(100);
        if g_bStop then Break;
    end;

    if (m_bResp) then
    begin
        if ctrl = O_ProRx.GetDI() then
        begin
            Result := True;
        end;
    end;

    if Result then
    begin
        clr := clSucced;
    end
    else
    begin
        clr := clFailed;
    end;
    if Sender is TCheckBox then TCheckBox(Sender).Font.Color := clr;
    if Sender is TButton then TButton(Sender).Font.Color :=clr;
end;

procedure TF_ParamReadWrite.ParseData(pCommEntity:Pointer=nil);
begin
    m_bResp := True;
end;

procedure TF_ParamReadWrite.FormCreate(Sender: TObject);
begin
    m_bResp := False;
end;

end.
