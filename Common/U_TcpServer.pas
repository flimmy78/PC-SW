unit U_TcpServer;

//Delphi与Socket  http://hi.baidu.com/fufeng1015/blog/item/edff743fcb2217c47c1e7150.html
//利用Delphi编写Socket通信程序  http://www.programfan.com/article/showarticle.asp?id=2289
//http://apps.hi.baidu.com/share/detail/34393467

interface

uses Classes, SysUtils, Windows, Sockets, WinSock, InWinSock2{, IdWinSock2};

type
    TTcpSvrOnConnect    = procedure(ip:string; port:Integer) of object;
    TTcpSvrOnDisconnect = procedure(ip:string; port:Integer) of object;
    TTcpSvrOnReceive    = procedure(ip:string; port:Integer; pRevBuf:PByte; nRevLen:Integer; var nProLen:Integer) of object;
    //T_TcpServer = class(TObject)
    T_TcpServer = class
    private
        m_hSem:THandle;
        m_tcpsrvr: TTcpServer;
        m_OnConnect:TTcpSvrOnConnect;
        m_OnDisconnect:TTcpSvrOnDisconnect;
        m_OnReceive:TTcpSvrOnReceive;
        //m_revBuf:array[0..2047] of Byte;
        m_conList:TList;
        procedure tcpsrvr_OnAccept(Sender: TObject; ClientSocket: TCustomIpClient);
        procedure tcpsrvr_OnGetThread(Sender: TObject; var ClientSocketThread: TClientSocketThread);

        function Lock():Boolean;                //逻辑锁
        function Unlock():Boolean;
        function IsListening():Boolean;
    public
        constructor Create();
        destructor Destroy(); override;
        function Listen(ip:string; port:Integer):Boolean;
        function CloseListen():Boolean;
        function CloseConnection(ip:string; port:Integer):Boolean;
        function SendData(ip:string; port:Integer; pBuf:PByte; len:Integer):Boolean;overload;
        function SendData(ip:string; port:Integer; strSend:string):Boolean;overload;
        function BroacastData(pBuf:PByte; len:Integer):Boolean;overload;
        function BroacastData(strSend:string):Boolean;overload;
        function GetAllLinks(var ipList:TStringList; var portList:TStringList):Boolean;
    Published
        Property OnConnect:TTcpSvrOnConnect Read m_OnConnect Write m_OnConnect;
        Property OnDisconnect:TTcpSvrOnDisconnect Read m_OnDisconnect Write m_OnDisconnect;
        Property OnReceive:TTcpSvrOnReceive Read m_OnReceive Write m_OnReceive;
        property Active:Boolean read IsListening;
  end;

implementation

//http://www.ooppoo.com/html/43/n-175343.html
//http://topic.csdn.net/u/20101206/19/9831b935-5826-4227-88cf-09af892f3d3d.html?r=70404036
//http://blog.csdn.net/jimaliu/article/details/4908658

const
    IOC_IN              = $80000000;
    IOC_VENDOW          = $18000000;
    SIO_KEEPALIVE_VALS  = IOC_IN or IOC_VENDOW or 4;

type
    TCP_KEEPALIVE = record
        onoff:LongWord;
        keepalivetime:LongWord;
        keepaliveinterval:LongWord;
    end;
var
  WSAData: TWSAData;
  
constructor T_TcpServer.Create();
var ErrorCode: Integer;
begin
    m_OnConnect  := nil;
    OnDisconnect := nil;
    m_OnReceive  := nil;

    m_hSem    := CreateSemaphore(nil, 1, 1, nil);

    m_conList := TList.Create;

    //WSACleanup();

    ErrorCode := WSAStartup($0202, WSAData);
    if ErrorCode <> 0 then
    begin
        //m_tcpsrvr.OnGetThread := tcpsrvr_OnGetThread;
    end;

    m_tcpsrvr := TTcpServer.Create(nil);
    m_tcpsrvr.OnAccept := tcpsrvr_OnAccept;
    
    //m_tcpsrvr.OnGetThread := tcpsrvr_OnGetThread;
end;

destructor T_TcpServer.Destroy();
var i:Integer;
begin
    try
        m_tcpsrvr.Active := False;

        //g_queue_mng.DispLog(Format('开始断开 %s', [m_tcpsrvr.LocalPort]));
        while m_conList.Count>0 do
        begin
            Lock();
            for i:=0 to m_conList.Count-1 do
            begin
                TCustomIpClient(m_conList.Items[i]).Disconnect;
            end;
            Unlock();
            if m_conList.Count>0 then
            begin
                Sleep(0);
            end;
        end;

        //g_queue_mng.DispLog(Format('已断开 %s', [m_tcpsrvr.LocalPort]));

        if m_tcpsrvr<>nil then
        begin
            //m_tcpsrvr.FreeOnRelease;
            //m_tcpsrvr.Free;   //目前还不知道怎么释放
            m_tcpsrvr := nil;
        end;
        if m_conList<>nil then
        begin
            m_conList.Free;
            m_conList := nil;
        end;
        CloseHandle(m_hSem);
    finally
    end;
end;

procedure T_TcpServer.tcpsrvr_OnGetThread(Sender: TObject; var ClientSocketThread: TClientSocketThread);
begin
    //ClientSocketThread.ServerSocketThread.ThreadCacheSize := 11;
end;

procedure T_TcpServer.tcpsrvr_OnAccept(Sender: TObject; ClientSocket: TCustomIpClient);
var i, len, proLen:Integer;
    pBuf:PByte;
    nResult:Integer;
    ip:string;
    port:Integer;

var keepAliveIn:TCP_KEEPALIVE;
    keepAliveOut:TCP_KEEPALIVE;
    status :Integer;
    BytesReturned:Cardinal;
    bKeepAlive:BOOL;
begin
    ip := ClientSocket.RemoteHost;
    port := StrToInt(ClientSocket.RemotePort);
    
    if Assigned(m_OnConnect) then
    begin
        m_OnConnect(ip, port);
    end;

    Lock();
    m_conList.Add(ClientSocket);
    Unlock();

    //if Result then
    begin
{
        bKeepAlive := True;
        status := setsockopt(ClientSocket.Handle, SOL_SOCKET, SO_KEEPALIVE, @bKeepAlive, SizeOf(bKeepAlive));
        if status<>0 then
        begin
            //错误
            status := WSAGetLastError();
        end;
}
        //status := WSAStartup($0202, WSAData);
        //设置socket的keep alive为10秒，并且发送次数为3次
        keepAliveIn.onoff := 1;
        keepAliveIn.keepaliveinterval := 1;
        //keepAliveIn.keepalivetime := 30000;
        keepAliveIn.keepalivetime := 1800000; //底层设备不应答这个TCP驱动层的心跳，所以改为30分钟，检测应用层心跳
        status :=  WSAIoctl(ClientSocket.Handle, SIO_KEEPALIVE_VALS,
                          @keepAliveIn, SizeOf(keepAliveIn),
                          @keepAliveOut, SizeOf(keepAliveOut),
                          @BytesReturned, nil, nil);
        if status<>0 then
        begin
            //错误
            status := WSAGetLastError();
        end;
        if status<>0 then
        begin
            //错误
            status := WSAGetLastError();
        end;
    end;

    len := 4096;
    pBuf := AllocMem(len+10); //留出10个字节的空余空间

    repeat
        nResult := 0;
        try
            //if ClientSocket.WaitForData() then
            begin
                FillChar(pBuf^, len+10, 0);
                nResult := ClientSocket.ReceiveBuf(pBuf^, len); //MSG_PEEK or MSG_MAXIOVLEN
                if (nResult>0) and Assigned(m_OnReceive) then
                begin
                    m_OnReceive(ip,
                            port,
                            pBuf,
                            nResult,
                            proLen
                            );
                    //ClientSocket.SendBuf(pBuf^, nResult);
                    //SendData(ip, port, pBuf, nResult);
                end;
            end;
        finally
            //Sleep(1000);
        end;
    until (nResult<=0) or (not ClientSocket.Connected) or (not m_tcpsrvr.Active);
    
    if Assigned(m_OnDisconnect) then
    begin
        m_OnDisconnect(ip, port);
    end;

    Lock();
    for i:=0 to m_conList.Count-1 do
    begin
        if ClientSocket=TCustomIpClient(m_conList.Items[i]) then
        begin
            m_conList.Delete(i);
            Break;
        end;
    end;
    Unlock();

    if pBuf<>nil then
    begin
        FreeMem(pBuf);
        pBuf := nil;
    end;
    //ClientSocket.Handle
end;

function T_TcpServer.CloseListen():Boolean;
var i:Integer;
begin
    try
        Result := False;
        m_tcpsrvr.Active := False;
        //g_queue_mng.DispLog(Format('开始断开 %s', [m_tcpsrvr.LocalPort]));
        while m_conList.Count>0 do
        begin
            Lock();
            for i:=0 to m_conList.Count-1 do
            begin
                TCustomIpClient(m_conList.Items[i]).Disconnect;
            end;
            Unlock();
            if m_conList.Count>0 then
            begin
                Sleep(0);
            end;
        end;
        Result := True;
    finally
    end;
end;

function T_TcpServer.IsListening():Boolean;
begin
    Result := m_tcpsrvr.Active;
end;

function T_TcpServer.Listen(ip:string; port:Integer):Boolean;
var keepAliveIn:TCP_KEEPALIVE;
    keepAliveOut:TCP_KEEPALIVE;
    status :Integer;
    BytesReturned:Cardinal;
    bKeepAlive:BOOL;
begin
    try
        //m_tcpsrvr.Protocol := IPPROTO_TCP; //IPPROTO_IP
        //m_tcpsrvr.Protocol := 0;
        //m_tcpsrvr.SockType := stRaw;
        
        m_tcpsrvr.Active := False;
        m_tcpsrvr.LocalHost := ip;
        //m_tcpsrvr.LocalHost := '192.168.41.109';
        m_tcpsrvr.LocalPort := Format('%d', [port]);
        m_tcpsrvr.Active := True;
    finally
        m_tcpsrvr.ServerSocketThread.ThreadCacheSize := 5000;   //服务器端支持的连接数
        Result := m_tcpsrvr.Active;
    end;

    //SIO_RCVALL

    Exit;
    
    //经测试，在这里设置也有效
    if Result then
    begin
      {
        bKeepAlive := True;
        status := setsockopt(m_tcpsrvr.Handle, SOL_SOCKET, SO_KEEPALIVE, @bKeepAlive, SizeOf(bKeepAlive));
        if status<>0 then
        begin
            //错误
            status := WSAGetLastError();
        end;
        }
        //status := WSAStartup($0202, WSAData);
        //设置socket的keep alive为10秒，并且发送次数为3次
        keepAliveIn.onoff := 1;
        keepAliveIn.keepaliveinterval := 1;
        keepAliveIn.keepalivetime := 60000;
{
        status :=  WSAIoctl(m_tcpsrvr.Handle, SIO_KEEPALIVE_VALS,
                          @keepAliveIn, SizeOf(keepAliveIn),
                          @keepAliveOut, SizeOf(keepAliveOut),
                          @BytesReturned, nil, nil);
}
        if status<>0 then
        begin
            //错误
            status := WSAGetLastError();
        end;
        if status<>0 then
        begin
            //错误
            status := WSAGetLastError();
        end;
    end;

end;

function T_TcpServer.Lock():Boolean;
begin
    Result := False;
    if m_hSem<>0 then
    begin
        WaitForSingleObject(m_hSem, INFINITE);
        Result := True;
    end;
end;

function T_TcpServer.Unlock():Boolean;
begin
    Result := False;
    if m_hSem<>0 then
    begin
        ReleaseSemaphore(m_hSem, 1, nil);
        Result := True;
    end;
end;

function T_TcpServer.SendData(ip:string; port:Integer; strSend:string):Boolean;
begin
    Result := SendData(ip, port, @strSend[1], Length(strSend) + 1);
end;

function T_TcpServer.SendData(ip:string; port:Integer; pBuf:PByte; len:Integer):Boolean;
var i:Integer;
    ClientSocket:TCustomIpClient;
begin
    Result := False;
    try
        Lock();
        for i:=0 to m_conList.Count-1 do
        begin
            ClientSocket := TCustomIpClient(m_conList.Items[i]);
            if (ClientSocket.RemoteHost=ip) and (ClientSocket.RemotePort = Format('%d',[port])) then
            begin
                if ClientSocket.SendBuf(pBuf^, len) = len then
                begin
                    Result := True;
                end;
                Break;
            end;
        end;
    finally
        if not Result then
        begin
        end;
        Unlock();
    end;
end;

function T_TcpServer.CloseConnection(ip:string; port:Integer):Boolean;
var i:Integer;
    ClientSocket:TCustomIpClient;
begin
    Result := False;
    try
        Lock();
        for i:=0 to m_conList.Count-1 do
        begin
            ClientSocket := TCustomIpClient(m_conList.Items[i]);
            if (ClientSocket.RemoteHost=ip) and (ClientSocket.RemotePort = Format('%d',[port])) then
            begin
                ClientSocket.Disconnect;
                Result := True;
                Break;
            end;
        end;
    finally
        if not Result then
        begin
        end;
        Unlock();
    end;
end;

function T_TcpServer.BroacastData(strSend:string):Boolean;
begin
    Result := BroacastData(@strSend[1], Length(strSend)+1);
end;

function T_TcpServer.BroacastData(pBuf:PByte; len:Integer):Boolean;
var i:Integer;
    ClientSocket:TCustomIpClient;
begin
    Result := False;
    try
        Lock();
        for i:=0 to m_conList.Count-1 do
        begin
            ClientSocket := TCustomIpClient(m_conList.Items[i]);
            begin
                ClientSocket.SendBuf(pBuf^, len);
            end;
        end;
        Result := True;
    finally
        Unlock();
    end;
end;

function T_TcpServer.GetAllLinks(var ipList:TStringList; var portList:TStringList):Boolean;
var i:Integer;
    ClientSocket:TCustomIpClient;
begin
    Result := False;
    try
        Lock();
        ipList.Clear;
        portList.Clear;
        for i:=0 to m_conList.Count-1 do
        begin
            ClientSocket := TCustomIpClient(m_conList.Items[i]);
            ipList.Add(ClientSocket.RemoteHost);
            portList.Add(ClientSocket.RemotePort);
        end;
        Result := True;
    finally
        Unlock();
    end;
end;
  
end.
