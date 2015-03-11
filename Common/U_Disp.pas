unit U_Disp;

interface

uses Windows, Messages, SysUtils, Classes;

type
  T_Disp = class(TThread)
    private
      procedure Execute;override;
      function MyPostThreadMessage(msg:Cardinal; wParam:Integer; lParam:Integer):LongBool;
      procedure DispConnPro();
      procedure DispDisConnPro();
      procedure DispSndDataPro();
      procedure DispRevDataPro();
      procedure DispDevAddrPro();
      procedure DispLogPro();
    public                           
      constructor Create();
      destructor Destroy; override;
      function  DispConn(ip:string; port:Integer):Boolean;
      function  DispDisConn(ip:string; port:Integer):Boolean;
      function  DispSndData(pData:PByte; nDataLen:Integer; ip:string=''; port:Integer=0):Boolean;
      function  DispRevData(pData:PByte; nDataLen:Integer; ip:string=''; port:Integer=0):Boolean;
      function  DispDevAddr(ip:string; port:Integer; devAddr:Int64):Boolean;
      function  DispLog(strLog:string; ip:string=''; port:Integer=0):Boolean;
  end;

var g_disp:T_Disp;

implementation

uses U_Main, U_Frame, U_Operation;

const
  WM_ON_CONN      = WM_USER + 1;
  WM_ON_DISCONN   = WM_USER + 2;
  WM_ON_SND_DATA  = WM_USER + 3;
  WM_ON_REV_DATA  = WM_USER + 4;
  WM_DEV_ADDR     = WM_USER + 5;
  WM_LOG          = WM_USER + 6;

type
  PTDispNet = ^TDispNet;
  TDispNet = record
    ip:string;
    port:Integer;
    pData:PByte;
    nDataLen:Integer;
    nValue:Int64;
    strValue:string;
  end;

var s_pDispNet:PTDispNet = nil;

constructor T_Disp.Create();
begin
    FreeOnTerminate := False;
    inherited Create(False);
end;

destructor T_Disp.Destroy;
begin
    Terminate();
    inherited;
end;

procedure T_Disp.Execute;
var msg:TMsg;
begin
    while not Terminated do
    begin
        Sleep(50);
        while PeekMessage(msg, INVALID_HANDLE_VALUE, WM_ON_CONN, WM_LOG, PM_REMOVE) do
        begin
            s_pDispNet := nil;
            case msg.message of
              WM_ON_CONN:
                begin
                    s_pDispNet := PTDispNet(msg.lParam);
                    Synchronize(DispConnPro);
                end;
              WM_ON_DISCONN:
                begin
                    s_pDispNet := PTDispNet(msg.lParam);
                    Synchronize(DispDisConnPro);
                end;
              WM_ON_SND_DATA:
                begin
                    s_pDispNet := PTDispNet(msg.lParam);
                    Synchronize(DispSndDataPro);
                end;
              WM_ON_REV_DATA:
                begin
                    s_pDispNet := PTDispNet(msg.lParam);
                    Synchronize(DispRevDataPro);
                end;
              WM_DEV_ADDR:
                begin
                    s_pDispNet := PTDispNet(msg.lParam);
                    Synchronize(DispDevAddrPro);
                end;
              WM_LOG:
                begin
                    s_pDispNet := PTDispNet(msg.lParam);
                    Synchronize(DispLogPro);
                end;
            end;
            if s_pDispNet<>nil then
            begin
                if s_pDispNet.pData<>nil then
                begin
                    FreeMemory(s_pDispNet.pData);
                    s_pDispNet.pData := nil;
                end;
                Dispose(PTDispNet(s_pDispNet));
                s_pDispNet := nil;
            end;
        end;
    end;
end;

function T_Disp.MyPostThreadMessage(msg:Cardinal; wParam:Integer; lParam:Integer):LongBool;
begin
    PostThreadMessage(ThreadID, msg, wParam, lParam);
    Result := True;
end;

procedure  T_Disp.DispConnPro();
begin
    if s_pDispNet<>nil then
    begin
        F_Main.AddConnection(s_pDispNet.ip, s_pDispNet.port);
    end;
end;

procedure T_Disp.DispDisConnPro();
begin
    if s_pDispNet<>nil then
    begin
        F_Main.DelConnection(s_pDispNet.ip, s_pDispNet.port);
    end;
end;

procedure T_Disp.DispSndDataPro();
begin
    if s_pDispNet<>nil then
    begin
        F_Frame.DisplayFrame(s_pDispNet.pData, s_pDispNet.nDataLen, True, s_pDispNet.ip, s_pDispNet.port);
    end;
end;

procedure T_Disp.DispRevDataPro();
begin
    if s_pDispNet<>nil then
    begin
        F_Frame.DisplayFrame(s_pDispNet.pData, s_pDispNet.nDataLen, False, s_pDispNet.ip, s_pDispNet.port);
    end;
end;

procedure T_Disp.DispDevAddrPro();
begin
    if s_pDispNet<>nil then
    begin
        F_Main.DispDevAddr(s_pDispNet.ip, s_pDispNet.port, s_pDispNet.nValue);
    end;
end;

procedure T_Disp.DispLogPro();
begin
    if s_pDispNet<>nil then
    begin
        F_Operation.DisplayOperation(s_pDispNet.strValue);
    end;
end;
      
function  T_Disp.DispConn(ip:string; port:Integer):Boolean;
var pDispNet:PTDispNet;
begin
    New(pDispNet);
    pDispNet.ip := ip;
    pDispNet.port := port;
    pDispNet.pData := nil;
    pDispNet.nDataLen := 0;
    MyPostThreadMessage(WM_ON_CONN, 0, Integer(pDispNet));
    Result := True;
end;

function  T_Disp.DispDisConn(ip:string; port:Integer):Boolean;
var pDispNet:PTDispNet;
begin
    New(pDispNet);
    pDispNet.ip := ip;
    pDispNet.port := port;
    pDispNet.pData := nil;
    pDispNet.nDataLen := 0;
    MyPostThreadMessage(WM_ON_DISCONN, 0, Integer(pDispNet));
    Result := True;
end;

function  T_Disp.DispSndData(pData:PByte; nDataLen:Integer; ip:string=''; port:Integer=0):Boolean;
var pDispNet:PTDispNet;
    pDataDisp:PByte;
begin
    New(pDispNet);
    pDispNet.ip := ip;
    pDispNet.port := port;
    pDispNet.pData := nil;
    pDispNet.nDataLen := 0;
    if (pData<>nil) and (nDataLen>0) then
    begin
        pDataDisp := GetMemory(nDataLen);
        MoveMemory(pDataDisp, pData, nDataLen);
        pDispNet.pData := pDataDisp;
        pDispNet.nDataLen := nDataLen;
    end;  
    MyPostThreadMessage(WM_ON_SND_DATA, 0, Integer(pDispNet));
    Result := True;
end;
      
function  T_Disp.DispRevData(pData:PByte; nDataLen:Integer; ip:string=''; port:Integer=0):Boolean;
var pDispNet:PTDispNet;
    pDataDisp:PByte;
begin
    New(pDispNet);
    pDispNet.ip := ip;
    pDispNet.port := port;
    pDispNet.pData := nil;
    pDispNet.nDataLen := 0;
    if (pData<>nil) and (nDataLen>0) then
    begin
        pDataDisp := GetMemory(nDataLen);
        MoveMemory(pDataDisp, pData, nDataLen);
        pDispNet.pData := pDataDisp;
        pDispNet.nDataLen := nDataLen;
    end;  
    MyPostThreadMessage(WM_ON_REV_DATA, 0, Integer(pDispNet));
    Result := True;
end;

function  T_Disp.DispDevAddr(ip:string; port:Integer; devAddr:Int64):Boolean;
var pDispNet:PTDispNet;
begin
    New(pDispNet);
    pDispNet.ip := ip;
    pDispNet.port := port;
    pDispNet.nValue := devAddr;
    pDispNet.pData := nil;
    pDispNet.nDataLen := 0;
    Result := MyPostThreadMessage(WM_DEV_ADDR, 0, Integer(pDispNet));
end;

function  T_Disp.DispLog(strLog:string; ip:string=''; port:Integer=0):Boolean;
var pDispNet:PTDispNet;
begin
    New(pDispNet);
    pDispNet.ip := ip;
    pDispNet.port := port;
    pDispNet.strValue := strLog;
    pDispNet.pData := nil;
    Result := MyPostThreadMessage(WM_LOG, 0, Integer(pDispNet));
end;
  
end.
