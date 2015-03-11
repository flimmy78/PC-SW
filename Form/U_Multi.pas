unit U_Multi;

interface

uses
  Windows, SysUtils, U_MyFunction, DateUtils, U_ComComm, U_Disp, U_Protocol;

function CommMakeFrame1(str:string):Boolean;
function CommMakeFrame2(pBuf:PByte; len:Integer):Boolean;
function CommWaitForResp():Boolean;
function GetCommSendBufAddr():PByte;
function GetCommSendDataLen():Integer;
function GetCommRecvBufAddr():PByte;
function GetCommRecvDataLen():Integer;
function CommCheckFrame(pBuf:PByte; len:Integer):Boolean;

var
  tx_buf:array[0..2048] of pByte; //串口发送缓冲区
  tx_len:Integer; //串口发送数据长度
  rx_buf:array[0..2048] of pByte; //串口接收缓冲区
  rx_len:Integer; //串口接收数据长度
  CommRecved:Boolean = False;
  TxCnt:Int64 = 0;
  RxCnt:Int64 = 0;
  CommTimeOut:Integer = 1000;

implementation

function CommMakeFrame1(str:string):Boolean;
begin
    strpcopy(@tx_buf[0], str);
    tx_len := Length(str);
    Result := True;
end;

function CommMakeFrame2(pBuf:PByte; len:Integer):Boolean;
begin
    MoveMemory(@tx_buf[0], pBuf, len);
    tx_len := len;
    Result := True;
end;

function CommCheckFrame(pBuf:PByte; len:Integer):Boolean;
begin
    Result := True;
    MoveMemory(@rx_buf[0], pBuf, len);
    rx_len := len;
end;

function CommWaitForResp():Boolean;
var beginWait:TDateTime;
    nWaitTime:Integer;
begin
    Result := True;
    beginWait := Now;

    nWaitTime := CommTimeOut;

    while (Abs(MilliSecondsBetween(Now,beginWait))<nWaitTime) do
    begin
        Delay(100);
    end;
end;

function GetCommSendBufAddr():PByte;
begin
    Result := @tx_buf[0];
end;

function GetCommSendDataLen():Integer;
begin
    Result := tx_len;
end;

function GetCommRecvBufAddr():PByte;
begin
    Result := @rx_buf[0];
end;

function GetCommRecvDataLen():Integer; 
begin
    Result := rx_len;
end;

end.
