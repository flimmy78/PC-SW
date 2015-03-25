unit U_Protocol_645;

interface

uses Windows,SysUtils,U_MyFunction,DateUtils,U_Protocol;

const
    DI_CHKMETER:LongWord    = $e802;
    DI_SET_ENER:LongWord    = $c119;    //设置底数
    DI_READ_ENER:LongWord   = $9010;    //读电量
    //DI_BROC_MAC:LongWord    = $3434;    //广播写MAC
    DI_SWITCH_OUT:LongWord  = $c03c;    //跳闸
    DI_SWITCH_IN:LongWord   = $c03d;    //合闸

const
    INVALID_DI = $ffffffff;

    ctrl_read_07  =  $11;//读数据
    ctrl_ext_read_07  =  $12;//读数据
    ctrl_write_07 =  $14;//写数据

    ctrl_read_97  =  $01;//读数据
    ctrl_write_97 =  $04;//写数据

    ctrl_mac_97   =  $0A;//MAC地址
const
    BROADCAST_ADDR = $999999999999;
    
Type
  PTFrame645 = ^TFrame645;
  TFrame645 = packed record
      m_start1:Byte;//帧起始符
      m_addrBuf:Array[0..5] of Byte;//地址域
      m_start2:Byte;//帧起始符
      m_ctrl:Byte;//控制码
      m_dataLen:Byte;//数据域长度
      m_dataBuf:Array[0..511] of Byte;//数据域，后面两个分别为检验和，结束符
  end;
  
type
  T_Protocol_645 = class(T_Protocol)
  private
    { Private declarations }
    m_pFrame:PTFrame645;
    function AddValue(pData:PByte; len:Integer; value:Integer):PByte;
    function MakeFrame(ctrl:Byte;pData:PByte;datalen:Integer):PByte;
  public
    { Public declarations }
    constructor Create();
    function MakeFrame_645(ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):PByte;override;
    function CheckFrame(pBuf:PByte;len:Integer):Boolean;override;
    function GetDI():LongWord;override;
    function GetCtrl():Byte;override;
    function GetDataUnit():PByte;override;
    function GetDataUnitLen():Integer;override;
    function GetFrameBuf():PByte;override;     //获取的是正确帧的地址
    function GetFrameLen():Integer;override;   //获取的是正确帧的长度
    function IsRespOK():Boolean;override;//是否正常应答
    function SetFrameHeader(pBuf:PByte;len:Integer):Boolean;override;//设置帧头，如FE FC
  end;
  
implementation

constructor T_Protocol_645.Create();
begin
    m_pFrame := @m_buf[0];
    m_addr := $999999999999;
    m_pwd := $66709600;
end;

function T_Protocol_645.SetFrameHeader(pBuf:PByte;len:Integer):Boolean;//设置帧头，如FE FC
begin
    MoveMemory(@m_buf[0],pBuf,6);
    m_pFrame := @m_buf[len];
    m_bSetFrameHeader := True;
end;

function T_Protocol_645.MakeFrame(ctrl:Byte;pData:PByte;datalen:Integer):PByte;
var i:Integer;
begin
    m_pFrame.m_start1 := $68;
    MoveMemory(@m_pFrame.m_addrBuf[0],@m_addr,6);
    m_pFrame.m_start2 := $68;
    m_pFrame.m_ctrl := ctrl;
    m_pFrame.m_dataLen := datalen;
    for i:=0 to datalen-1 do
    begin
        m_pFrame.m_dataBuf[i] := pData^ + $33;
        Inc(pData);
    end;
    m_pFrame.m_dataBuf[datalen] := GetSum(PByte(m_pFrame),10+m_pFrame.m_dataLen);
    m_pFrame.m_dataBuf[datalen+1] := $16;
    Result := PByte(m_pFrame);
end;

function T_Protocol_645.MakeFrame_645(ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):PByte;
var buf:array[0..255] of Byte;
    p:Integer;
begin
    p := 0;
    case (ctrl and $1f) of
      ctrl_read_97,
      ctrl_write_97:
      begin
        MoveMemory(@buf[p], @DI, 2);  Inc(p, 2);
      end;
      ctrl_read_07,
      ctrl_write_07,
      ctrl_ext_read_07:
      begin
        MoveMemory(@buf[p], @DI, 4);  Inc(p, 4);
      end;
      else
      begin
      end;
    end;

    case (ctrl and $1f) of
      ctrl_write_97:
      begin
        MoveMemory(@buf[p], @m_pwd, 4);  Inc(p, 4);
      end;
      ctrl_write_07:
      begin
        MoveMemory(@buf[p], @m_pwd, 4);  Inc(p, 4);
        FillMemory(@buf[p], 4, 0);  Inc(p, 4);
      end;
      else
      begin
      end;
    end;

    if (pData<>nil) and (datalen>0) then
    begin
        MoveMemory(@buf[p], pData, datalen);  Inc(p, datalen);
    end;
    
    Result := MakeFrame(ctrl, @buf[0], p);
end;

function T_Protocol_645.CheckFrame(pBuf:PByte;len:Integer):Boolean;
var i:Integer;
    crc:Word;
    buf:pByteBuf;
begin
    Result := False;
    MoveMemory(@m_buf[0],pBuf,len);
    for i:=0 to len-1 do
    begin
        m_pFrame := PTFrame645(@m_buf[i]);
        if    (m_pFrame.m_start1 = $68)
          and (m_pFrame.m_start2 = $68)
          and (m_pFrame.m_dataBuf[m_pFrame.m_dataLen+1] = $16)
          and (m_pFrame.m_dataBuf[m_pFrame.m_dataLen] = GetSum(PByte(m_pFrame),10+m_pFrame.m_dataLen))
        then
        begin
            //-33
            AddValue(@m_pFrame.m_dataBuf[0], m_pFrame.m_dataLen, -$33);
            m_addr := PINT64(@m_pFrame.m_addrBuf[0])^ and $ffffffffffff;
            Result := True;
            Exit;
        end;
    end;
end;
    
function T_Protocol_645.AddValue(pData:PByte; len:Integer; value:Integer):PByte;
var i:Integer;
begin
    for i:=1 to len do
    begin
        pData^ := pData^ + value;
        Inc(pData);
    end;
    Result := pData;
end;

function T_Protocol_645.GetDI():LongWord;
begin
    Result := INVALID_DI;
    case (m_pFrame.m_ctrl and $1f) of
      ctrl_read_07,
      ctrl_write_07,
      ctrl_ext_read_07:
      begin
        if m_pFrame.m_dataLen >= 4 then
        begin
            MoveMemory(@Result, @m_pFrame.m_dataBuf[0], 4);
        end;
      end;
      ctrl_read_97,
      ctrl_write_97:
      begin
        if m_pFrame.m_dataLen >= 2 then
        begin
            Result := 0;
            MoveMemory(@Result, @m_pFrame.m_dataBuf[0], 2);
        end;
      end;
      else
      begin
      end;
    end;
end;

function T_Protocol_645.GetCtrl():Byte;
begin
    Result := m_pFrame.m_ctrl;
end;

function T_Protocol_645.GetDataUnit():PByte;
begin
    Result := @m_pFrame.m_dataBuf[0];
    case (m_pFrame.m_ctrl and $1f) of
      ctrl_read_07,
      ctrl_write_07,
      ctrl_ext_read_07:
      begin
        if m_pFrame.m_dataLen >= 4 then
        begin
            Result := @m_pFrame.m_dataBuf[4];
        end;
      end;
      ctrl_read_97,
      ctrl_write_97:
      begin
        if m_pFrame.m_dataLen >= 2 then
        begin
            Result := @m_pFrame.m_dataBuf[2];
        end;
      end;
      else
      begin
      end;
    end;
end;

function T_Protocol_645.GetDataUnitLen():Integer;
begin
    Result := m_pFrame.m_dataLen;
    case (m_pFrame.m_ctrl and $1f) of
      ctrl_read_07,
      ctrl_write_07,
      ctrl_ext_read_07:
      begin
          Inc(Result,-4);
      end;
      ctrl_read_97,
      ctrl_write_97:
      begin
        if m_pFrame.m_dataLen >= 2 then
        begin
            Inc(Result,-2);
        end;
      end;
      else
      begin
      end;
    end;
end;

function T_Protocol_645.GetFrameBuf():PByte;     //获取的是正确帧的地址
begin
    if m_bSetFrameHeader then
    begin
        Result := @m_buf[0];
    end
    else
    begin
        Result := PByte(m_pFrame);
    end;
end;

function T_Protocol_645.GetFrameLen():Integer;   //获取的是正确帧的长度
begin
    if m_bSetFrameHeader then
    begin
        Result := m_pFrame.m_dataLen + 12 + (Integer(m_pFrame)-Integer(@m_buf[0]));
    end
    else
    begin
        Result := m_pFrame.m_dataLen + 12;
    end;
end;

function T_Protocol_645.IsRespOK():Boolean;//是否正常应答
begin
    if (m_pFrame.m_ctrl and $40)>0 then
    begin
        Result := False;
    end
    else
    begin
        Result := True;
    end;
end;

end.
