unit U_TcpClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ExtCtrls,DateUtils, ADODB,U_MyFunction,
  StrUtils, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient;



type
    TTcpRevDataEvent = procedure(pRevBuf:PByte; nRevLen:Integer; var nProLen:Integer) of object;
    T_TcpClient=Class(TThread)
    private
        //m_snd_buf:array[0..1023] of Byte;
        m_rev_buf:array[0..2047] of Byte;
        //m_snd_len:Integer;
        m_rev_len:Integer;
        m_idtcpclnt: TIdTCPClient;
        m_tcpRevDataEvent:TTcpRevDataEvent;
        procedure Execute;override;
        function  WriteData(pData:PByte; len:Integer):Integer;
        function  MyPostMessage(Msg:Cardinal; wParam:Integer=0; lParam:Integer=0):Boolean;
    public
        constructor Create(IP:string; port:Integer; CreateSuspended:Boolean=True);
        destructor Destroy; override;
        function  SendData(pData:PByte; len:Integer):Integer;overload;
        function  SendData(strData:string):Integer;overload;
        function  Connect(IP:string; port:Integer):Boolean;
        function  Disconnect():Boolean;
        function  GetConnParam(var IP:string; var port:Integer):Boolean;
        function  IsConnected():Boolean;
    Published
        Property OnReceive:TTcpRevDataEvent Read m_tcpRevDataEvent Write m_tcpRevDataEvent;
  end;
  
implementation

const WM_SEND_DATA = WM_USER + 1;

type
  PTSendData = ^TSendData;
  TSendData = record
    pBuf:PByte;
    len:Integer;
  end;
  
constructor T_TcpClient.Create(IP:string; port:Integer; CreateSuspended:Boolean=True);
begin
    //inherited Create(CreateSuspended);
    FreeOnTerminate := False;
    FillChar(m_rev_buf, SizeOf(m_rev_buf), 0);
    m_rev_len := 0;
    m_idtcpclnt := TIdTCPClient.Create(nil);
    m_idtcpclnt.Host := IP;
    m_idtcpclnt.Port := port;
    //m_idtcpclnt.Connect();
    m_tcpRevDataEvent := nil;
    inherited Create(CreateSuspended);
end;

destructor T_TcpClient.Destroy;
begin
    Terminate;
    inherited;
end;


function  T_TcpClient.Connect(IP:string; port:Integer):Boolean;
begin
    Suspend();
    m_idtcpclnt.Host := IP;
    m_idtcpclnt.Port := port;
    m_idtcpclnt.Disconnect();
    m_idtcpclnt.Connect();
    Result := m_idtcpclnt.Connected;
    while Suspended do
    begin
        Resume();
    end;
end;

function  T_TcpClient.Disconnect():Boolean;
begin
    Suspend();
    m_idtcpclnt.Disconnect();
end;

function  T_TcpClient.GetConnParam(var IP:string; var port:Integer):Boolean;
begin
    IP := m_idtcpclnt.Host;
    port := m_idtcpclnt.Port;
    Result := True;
end;

function  T_TcpClient.IsConnected():Boolean;
begin
    Result := m_idtcpclnt.Connected;
end;

procedure T_TcpClient.Execute;
var msg:TMsg;
    proLen:Integer;
begin
    while (not Terminated) do
    begin
        Sleep(10);
        try
            m_idtcpclnt.CheckForDisconnect(False);
            if not m_idtcpclnt.Connected then
            begin
                m_idtcpclnt.Connect();
            end;
            if m_idtcpclnt.Connected then
            begin
                //处理发送
                if PeekMessage(msg, INVALID_HANDLE_VALUE, WM_SEND_DATA, WM_SEND_DATA, PM_REMOVE) then
                begin
                    WriteData(PTSendData(msg.lParam).pBuf, PTSendData(msg.lParam).len);
                    FreeMem(PTSendData(msg.lParam).pBuf);
                    Dispose(PTSendData(msg.lParam));
                end;

                //处理接收
                m_rev_len := m_idtcpclnt.ReadFromStack(False, 300, False);
                if m_rev_len>0 then
                begin
                    FillChar(m_rev_buf, SizeOf(m_rev_buf), 0);
                    m_idtcpclnt.ReadBuffer(m_rev_buf, m_rev_len);
                    if Assigned(m_tcpRevDataEvent) then
                    begin
                        m_tcpRevDataEvent(@m_rev_buf[0], m_rev_len, proLen);
                    end;
                end;
            end;
        except
            m_idtcpclnt.Socket.Close;
            m_idtcpclnt.Disconnect;
        end;
    end;

    if m_idtcpclnt.Connected then
    begin
        m_idtcpclnt.Socket.Close;
        m_idtcpclnt.Disconnect;
    end;
    m_idtcpclnt.Free;

end;

function T_TcpClient.MyPostMessage(Msg:Cardinal; wParam:Integer=0; lParam:Integer=0):Boolean;
begin
    PostThreadMessage(ThreadID, Msg, wParam, lParam);
    Result := True;
end;

function  T_TcpClient.SendData(pData:PByte; len:Integer):Integer;
var pSendData:PTSendData;
begin
    New(pSendData);
    pSendData.pBuf := AllocMem(len);
    pSendData.len := len;
    MoveMemory(pSendData.pBuf, pData, len);
    MyPostMessage(WM_SEND_DATA, 0, Integer(pSendData));
    Result := len;
end;

function  T_TcpClient.SendData(strData:string):Integer;
begin
    Result := SendData(PByte(@strData[1]), Length(strData)+1);
end;

function T_TcpClient.WriteData(pData:PByte; len:Integer):Integer;
begin
    Result := 0;
    try
        if not m_idtcpclnt.Connected then
        begin
            m_idtcpclnt.Connect();
        end;
    except
    end;
    try
        if m_idtcpclnt.Connected then
        begin
            m_idtcpclnt.WriteBuffer(pData^, len, True);
            Result := len;
        end;
    except
        try
            m_idtcpclnt.Connect();
            if m_idtcpclnt.Connected then
            begin
                m_idtcpclnt.WriteBuffer(pData^, len, True);
                Result := len;
            end;
        except
        end;
    end;
    if Result=0 then
    begin
    end;
end;


end.
