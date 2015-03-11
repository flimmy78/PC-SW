unit U_Process;

interface

uses Windows, Messages, SysUtils, Classes;

type
  T_Process = class(TThread)
    private
      procedure Execute;override;
      function MyPostThreadMessage(msg:Cardinal; wParam:Integer; lParam:Integer):LongBool;
      procedure ProcessDataPro();
    public                           
      constructor Create();
      destructor Destroy; override;
      function ProcessData(pData:PByte; len:Integer; ip:string=''; port:Integer=0):Boolean;
  end;

var g_process:T_Process;

implementation

uses U_Main;

const
  WM_PRO_DATA = WM_USER + 1;

type
  PTCommEntity = ^TCommEntity;
  TCommEntity = record
    ip:string;
    port:Integer;
    pData:PByte;
    nDataLen:Integer;
  end;

var s_pCommEntity:PTCommEntity = nil;

constructor T_Process.Create();
begin
    FreeOnTerminate := False;
    inherited Create(False);
end;

destructor T_Process.Destroy;
begin
    Terminate();
    inherited;
end;

procedure T_Process.Execute;
var msg:TMsg;
begin
    while not Terminated do
    begin
        Sleep(50);

        while PeekMessage(msg, INVALID_HANDLE_VALUE, WM_PRO_DATA, WM_PRO_DATA, PM_REMOVE) do
        begin
            case msg.message of
              WM_PRO_DATA:
                begin
                    s_pCommEntity := PTCommEntity(msg.lParam);
                    Synchronize(ProcessDataPro);
                    Dispose(PTCommEntity(s_pCommEntity));
                    s_pCommEntity := nil;
                end;
            end;
        end;
    end;
end;

function T_Process.MyPostThreadMessage(msg:Cardinal; wParam:Integer; lParam:Integer):LongBool;
begin
    Result := PostThreadMessage(ThreadID, msg, wParam, lParam);
end;

procedure T_Process.ProcessDataPro();
begin
    F_Main.ParseFrame(s_pCommEntity.pData, s_pCommEntity.nDataLen, s_pCommEntity.ip, s_pCommEntity.port);
end;

function T_Process.ProcessData(pData:PByte; len:Integer; ip:string=''; port:Integer=0):Boolean;
var pCommEntity:PTCommEntity;
begin
    New(pCommEntity);
    pCommEntity.ip := ip;
    pCommEntity.port := port;
    pCommEntity.pData := nil;
    pCommEntity.nDataLen := 0;
    if (pData<>nil) and (len>0) then
    begin
        pCommEntity.pData := GetMemory(len);
        MoveMemory(pCommEntity.pData, pData, len);
        pCommEntity.nDataLen := len;
    end;
    Result := MyPostThreadMessage(WM_PRO_DATA, 0, Integer(pCommEntity));
end;
      
end.
