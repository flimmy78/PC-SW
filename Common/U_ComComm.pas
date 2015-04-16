unit U_ComComm;
{
*功能：串口异步通讯，协议解释
}
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, 
  Dialogs, StdCtrls, ExtCtrls,DateUtils,U_MyFunction;
  
const WM_COMM_RECEIVE_DATA = WM_USER + 11111;

  //线程状态
type TThreadStatus=(
    ThreadStatus_Freeed,//0-已释放；
    ThreadStatus_Running,//1-正在运行；
    ThreadStatus_TerminateNotFree,//2-已终止但未释放；
    ThreadStatus_NotExist//3-未建立或不存在
        );

type
  //线程声明
  TO_ComComm=Class(TThread)
  private
    m_hcom:Thandle;//串口句柄
    m_Overlapped:TOverlapped;
    m_bComOpened:bool;//是否打开串口
    m_bSendData:bool;//是否正在发送数据，从开始发送~~收到数据前或超时前为true
    m_bSendInterval:bool;//是否要通知发送间隔时间到了，true为要通知，false为不要通知
    m_DTWrite:TDateTime;//发送数据时刻
    m_lwHandle:LongWord;//帧标识
    m_ReadBuffer:array[0..4095] of byte;//读取数据缓冲区
    m_nPos:integer;//指向m_ReadBuffer下一个要写入的位置，即当前m_ReadBuffer的长度
    function CheckThreadStatus(aThread:TThread):TThreadStatus;
  Published
  protected
    procedure Execute;override;
  public
    m_WriteBuffer:array[0..1023] of byte;//发送数据缓冲区
    m_nTimeOut:Int64;//读取超时
    m_SendInterval:integer;//发送间隔 ms
    //m_protocol:TProtocol;//协议类型
    m_frame_interval : Integer;
    function SetHandle(lwHandle:LongWord):Boolean;
    function IniCom(nPort,nBaudRate:integer;nParity:integer=NOPARITY;nDataBits:integer=8;nStopBits:integer=ONESTOPBIT):Boolean;
    function SetComParam(nBaudRate:integer;nParity:integer=NOPARITY;nDataBits:integer=8;nStopBits:integer=ONESTOPBIT):Boolean;
    function WriteCom(nHandle:integer;sendBuffer:PByte;nNumberOfBytesToWrite:DWORD):DWORD;
    function UniniCom():Boolean;
    function IsComOpen():Boolean;
    function SetFrameInterval(interval:integer):Boolean;
    constructor Create();
  end;

var O_ComComm:TO_ComComm;

implementation

function TO_ComComm.SetHandle(lwHandle:LongWord):Boolean;
begin
    m_lwHandle := lwHandle;
end;

function TO_ComComm.SetFrameInterval(interval:integer):Boolean;
begin
    m_frame_interval := interval;
end;

function TO_ComComm.IsComOpen():Boolean;
begin
    if m_hcom = INVALID_HANDLE_VALUE then
    begin
        Result:=False;
    end
    else
    begin
        Result:=True;
    end;
end;

constructor TO_ComComm.Create();
begin
    m_nTimeOut:=10*1000;
    m_DTWrite:=Now();
    m_hcom := INVALID_HANDLE_VALUE;
    m_bComOpened:=False;
    m_bSendData:=False;
    m_nPos:=0;
    m_SendInterval:=500;
    m_bSendInterval:=false;
    fillchar(m_ReadBuffer,sizeof(m_ReadBuffer),0);
    inherited create(True);
    //Priority:=tpidle;
    Priority:=tpTimeCritical;

    //m_frame_interval := 15;
    //m_frame_interval := 100;
    m_frame_interval := 40;//适合300波特率，分帧
end;

function TO_ComComm.IniCom(nPort,nBaudRate:integer;nParity:integer=NOPARITY;nDataBits:integer=8;nStopBits:integer=ONESTOPBIT):Boolean;
var lpdcb:Tdcb;
    pcCom:pchar;
begin
    Result := False;
    m_bComOpened := False;
    if m_hcom <> INVALID_HANDLE_VALUE then
    begin
        outputdebugstring(pchar('if m_hcom <> INVALID_HANDLE_VALUE then')) ;
        UniniCom();
        Sleep(100);
    end;
    pcCom:=pchar('com'+inttostr(nPort));
    m_hcom:=createfile(pcCom,
                     generic_read or generic_write,
                     0,
                     nil,
                     open_existing,
                     file_attribute_normal or file_flag_overlapped,
                     0);//打开串行口

    if m_hcom = INVALID_HANDLE_VALUE then Exit;
    //指定串行口事件为接收到字符； EV_RXCHAR or EV_CTS or EV_DSR or EV_RING
    //EV_BREAK or EV_CTS or EV_DSR or EV_ERR or EV_RING or EV_RLSD or EV_RXCHAR or EV_RXFLAG or EV_TXEMPTY
    if not setcommMask(m_hcom,EV_RXCHAR or EV_CTS or EV_DSR or EV_RING) then
    begin
        UniniCom();
        Exit;
    end;
    if not setupcomm(m_hcom,4096,4096) then //设置输入、输出缓冲区皆为4096字节
    begin
        UniniCom();
        Exit;
    end;
    if not getcommstate(m_hcom,lpdcb) then //获取串行口当前默认设置
    begin
        UniniCom();
        Exit;
    end;
    lpdcb.baudrate:=nBaudRate;
    lpdcb.StopBits:=nStopBits;
    lpdcb.Parity:=nParity;
    lpdcb.ByteSize:=nDataBits;
    if not Setcommstate(m_hcom,lpdcb) then
    begin
        UniniCom();
        Exit;
    end;
    m_bComOpened := True;
    Result:=m_bComOpened;
    if Suspended then
        Resume();
end;

function TO_ComComm.SetComParam(nBaudRate:integer;nParity:integer=NOPARITY;nDataBits:integer=8;nStopBits:integer=ONESTOPBIT):Boolean;
var lpdcb:Tdcb;
begin
    Result := False;
    if m_hcom = INVALID_HANDLE_VALUE then Exit;
    if not getcommstate(m_hcom,lpdcb) then Exit;
    lpdcb.baudrate:=nBaudRate;
    lpdcb.StopBits:=nStopBits;
    lpdcb.Parity:=nParity;
    lpdcb.ByteSize:=nDataBits;
    if not Setcommstate(m_hcom,lpdcb) then Exit;
    Result := True;
end;

function TO_ComComm.UniniCom():Boolean;
begin
    //Comm.Terminate;Comm.WaitFor;
    setcommMask(m_hcom,DWORD(Nil));
    if m_hcom <> INVALID_HANDLE_VALUE then
    begin
        if CloseHandle(m_hcom)=true then
        begin
            m_hcom := INVALID_HANDLE_VALUE;
            result:=true;
        end
        else
        begin
            result:=false;
            setcommMask(m_hcom,EV_RXCHAR or EV_CTS or EV_DSR or EV_RING);
            exit;
        end;
    end;
    result:=true;
    m_bComOpened:=False;
end;

//返回值：0-已释放；1-正在运行；2-已终止但未释放；3-未建立或不存在
function TO_ComComm.CheckThreadStatus(aThread: TThread): TThreadStatus;
var
  i: DWord;
  IsQuit: Boolean;
begin
    if Assigned(aThread) then
    begin
        IsQuit := GetExitCodeThread(aThread.Handle, i);
        if IsQuit then //If the function succeeds, the return value is nonzero.//If the function fails, the return value is zero.
        begin
            if i = STILL_ACTIVE then //If the specified thread has not terminated,//the termination status returned is STILL_ACTIVE.
                Result := ThreadStatus_Running
            else
                Result := ThreadStatus_TerminateNotFree; //aThread未Free，因为Tthread.Destroy中有执行语句
        end
        else
            Result := ThreadStatus_Freeed; //可以用GetLastError取得错误代码
    end
    else
        Result := ThreadStatus_NotExist;
end;

function TO_ComComm.WriteCom(nHandle:integer;sendBuffer:PByte;nNumberOfBytesToWrite:DWORD):DWORD;
var dwBytesWrite:DWORD;
    bWriteStat:BOOL;
begin
    outputdebugstring(pchar('发送数据：'+chr($0d)));
    result:=0;
    if not m_bComOpened then
    begin
        //if Assigned(m_FReceiveEvent) then m_FReceiveEvent(m_lwHandle,UMType_Com_Not_Opened,sendBuffer,0);
        Exit;
    end;
    //PurgeComm(m_hcom,PURGE_TXCLEAR or PURGE_RXCLEAR);//异步清空读缓冲有问题
    //if Suspended then Resume();
    dwBytesWrite:=0;
    m_lwHandle:=nHandle;
    //fillchar(m_ReadBuffer,sizeof(m_ReadBuffer),0);
    //m_nPos:=0;
    bWriteStat:=WriteFile(m_hcom,sendBuffer^,nNumberOfBytesToWrite,dwBytesWrite,@m_Overlapped);

    if not bWriteStat then
    begin
        if GetLastError()=ERROR_IO_PENDING then
        begin
            //WaitForSingleObject(m_Overlapped.hEvent,INFINITE);
            WaitForSingleObject(m_Overlapped.hEvent,5000);
            {
            if WaitForSingleObject(m_Overlapped.hEvent,5000)<> WAIT_OBJECT_0 then
            begin
                Exit;
            end;
            }
        end
        else
        begin
            Exit;
        end;
    end;
    //Exit;
    
    m_DTWrite:=Now();
    m_bSendData:=true;
    m_bSendInterval:=true;
    //GetOverlappedResult(m_hcom,m_Overlapped,dwBytesWrite,true);//这句很多时候会死等
    result:=nNumberOfBytesToWrite;//result:=dwBytesWrite;
    if Suspended then Resume();
end;

Procedure TO_ComComm.Execute; //线程执行过程
var dwEvtMask,lpErrors,lpNumberOfBytesRead:Dword;
    Wait,Clear:Boolean;
    nNumberOfBytesToRead:Integer;
    Coms:Tcomstat;
    ErrCode:Integer;
Begin
    fillchar(m_Overlapped,sizeof(TOverlapped),0);
    While true do
    Begin
        //Sleep(100);Continue;
        
        lpNumberOfBytesRead:=0;
        if Terminated then
            break;
        if not m_bComOpened then
        begin
            Suspend();
            //Sleep(1);Continue;
        end;
        dwEvtMask:=0;
        Wait := WaitCommEvent(m_hcom,dwevtmask,@m_Overlapped);  //等待串行口事件；
        Sleep(5);//等待关闭串口
        Clear:=Clearcommerror(m_hcom,lpErrors,@Coms);
        //ClearCommBreak(m_hcom);
        if ( Clear and ( ((dwevtmask and EV_RXCHAR) = EV_RXCHAR) or (Coms.cbInQue>0) ) ) then
        begin
            if ( (Coms.cbInQue>0) ) then
            begin
                nNumberOfBytesToRead:=Coms.cbInQue;

                while True do
                begin
                    Sleep(m_frame_interval);
                    Clear := Clearcommerror(m_hcom,lpErrors,@Coms);
                    //ClearCommBreak(m_hcom);
                    if (Coms.cbInQue > nNumberOfBytesToRead) then
                    begin
                        nNumberOfBytesToRead := Coms.cbInQue;
                    end
                    else Break;
                end;

                if m_nPos+nNumberOfBytesToRead > high(m_ReadBuffer)+1 then
                begin
                    FillChar(m_ReadBuffer, sizeof(m_ReadBuffer),0);
                    m_nPos:=0;
                end;

                if nNumberOfBytesToRead>high(m_ReadBuffer)+1 then
                    nNumberOfBytesToRead := high(m_ReadBuffer)+1;

                lpNumberOfBytesRead:=0;

                if not ReadFile(m_hcom,m_ReadBuffer[m_nPos],nNumberOfBytesToRead,lpNumberOfBytesRead,@m_Overlapped) then//处理接收数据
                begin
                    if GetLastError()=ERROR_IO_PENDING then
                    begin
                        WaitForSingleObject(m_Overlapped.hEvent,INFINITE);
                        lpNumberOfBytesRead := nNumberOfBytesToRead;
                    end;
                end;
                if lpNumberOfBytesRead>0 then
                begin
                    m_nPos := m_nPos + lpNumberOfBytesRead;
                    SendMessage( m_lwHandle,WM_COMM_RECEIVE_DATA,m_nPos,Integer(@m_ReadBuffer[0]));
                    //FillChar(m_ReadBuffer,sizeof(m_ReadBuffer),0);
                    m_nPos := 0;
                end;
            end;
        end;//if (dwevtmask and EV_RXCHAR) = EV_RXCHAR then
    end;//while
end;

end.

