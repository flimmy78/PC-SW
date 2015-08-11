unit U_Protocol;

interface
uses Windows,SysUtils,U_MyFunction,DateUtils, Graphics;

const
    F1    = 1;
    F2    = 2;
    F3    = 3;
    F5    = 5;
    F7    = 7;
    F10   = 10;
    F11   = 11;
    F31   = 31;
    F49   = 49;
    F50   = 50;
    F73   = 73;
    F80   = 80;
    F88   = 88;
    F89   = 89;
    F97   = 97;
    F98   = 98;
    F99   = 99;
    F100  = 100;
    F101  = 101;
    F102  = 102;
    F129  = 129;
    F161  = 161;
    F213  = 213;
var
    AFN_UPDATE_SELF:Byte = $F6;   //升级
const
    AFN_READ_SELF   = $F3;   //自定义抄读参数
    AFN_WRITE_SELF  = $F5;   //自定义设置参数
    AFN_CONFIRM     = $00;   //确认报文
    AFN_CHK_LINK    = $02;   //链路接口检测
    AFN_TRANS       = $10;   //数据转发
    AFN_WRITE_PARAM = $04;   //读取参数
    AFN_READ_PARAM  = $0A;   //读取参数
    AFN_CLASS_1     = $0C;   //实时数据
    AFN_CLASS_2     = $0D;   //历史数据
    AFN_READ_CFG_IFO  = $09;   //请求终端配置及信息（AFN=09H）
    AFN_CTRL = 05;
    AFN_CTRL_ROUTER = $12;

    AFN_ROUTER_TRANS = $13;    //数据转发

var g_resend_count:Integer = 3;//重发次数
    g_bStop:Boolean = False;
    g_timeout:Integer = 3000;
const
    clSucced = clBlue;
    clFailed = clRed;
const
    FUNC_DEFAULT      = 0; //默认
    FUNC_MOD_UPDATE   = 1; //路由板升级
    FUNC_CON_UPDATE   = 2; //集中器升级
    FUNC_CON_CHKMETER = 3; //通过集中器校表
    FUNC_CON_MOD      = 4; //通过集中器升级路由板
const
    INVALID_DEVADDR = $ffffffffffff;

const
    PLC_PORT_NO = 31;
    PLC_TRAN_TIMEOUT = 20; //20秒
    
var
    g_func_type:Byte = FUNC_CON_UPDATE;

type pByteBuf=array of Byte;
     PINT64 = ^Int64;
     
const	MAX_USER_DATA = 20;

const
// FUNC
    MODBUS_CTRL_OUTPUT    = $05;		//设置继电器输出
    MODBUS_READ_REG			  =	$03;		//读取单个或多个寄存器
    MODBUS_WRITE_REG		  =	$10;		//写入单个或者多个寄存器
    MODBUS_EXT_READ_REG		=	$46;		//读取秘密寄存器
    MODBUS_EXT_WRITE_REG	=	$47;		//写入秘密寄存器

const
// REG
    MODBUS_CTRL_START_ADDR    =	10000;		//遥控寄存器地址
    MODBUS_CTRL_END_ADDR	    =	20000;		//遥控寄存器地址

    MODBUS_FAST_START_ADDR	  =	30000;		//快速寄存器地址
    MODBUS_FAST_END_ADDR	    =	40000;		//快速寄存器地址

    MODBUS_GRP_START_ADDR	    =	40000;		//遥测和定值寄存器地址
    MODBUS_GRP_END_ADDR	      =	60000;		//遥测和定值寄存器地址
    MODBUS_TIME_START_ADDR    =	60000;		//时间寄存器地址
    MODBUS_TIME_END_ADDR	    =	60500;		//时间寄存器地址

    //MODBUS_EXT_GRP_START_ADDR =	63000;		//秘密定值寄存器地址
    //MODBUS_EXT_GRP_END_ADDR	  =	65000;		//秘密定值寄存器地址
    MODBUS_CONF_START_ADDR    =	61000;		//配置寄存器地址
    MODBUS_CONF_END_ADDR	    =	65500;		//配置寄存器地址

const
    MODBUS_CONF0_ADDR		= 0;			//配置寄存器地址
    MODBUS_CONF1_ADDR		= 500;		//初值寄存器地址
    MODBUS_CONF2_ADDR		= 1000;	  //初值寄存器地址
    MODBUS_CONF3_ADDR		= 2000;	  //初值寄存器地址
    MODBUS_CONF4_ADDR		= 3000;		//初值寄存器地址
    MODBUS_CONF_SIZE		= 4000;

const
//系统状态
    SYS_ERROR_EEPROM_RW    = $0001;
    //RECORD_DROP_TIME_FLAG  = $0002;   //是否已经保存了最后一次掉电的时间
    SYS_DROP_ACTION        = $0004;   //是否有电容继电器投切动作
    SYS_POWER_CHECK_FLAG   = $0008;   //是否进行再启动检查
    SYS_RELAY_ON_FLAG      = $0010;   //接触器是否在闭合状态
    SYS_JDQ_ON_FLAG        = $0020;   //继电器是否在闭合状态
 
Type
  P_USER_DATA = ^USER_DATA;
  USER_DATA = packed record
      nDICount      :Word; //PnFn的个数
      Pn            :array[0..MAX_USER_DATA-1] of Word;
      Fn            :array[0..MAX_USER_DATA-1] of Word;
      dataUnit      :array[0..MAX_USER_DATA-1, 0..50-1] of Byte;
      dataUnitLen   :array[0..MAX_USER_DATA-1] of Word;
  end;

type
  T_Protocol = class
  private
    { Private declarations }
  public
    { Public declarations }
    m_buf:array[0..4096] of Byte;    //存放的是接收帧的内容，包括多余的字节
    m_len:Integer;    //存放的是接收帧的长度，包括多余的字节
    m_addr:Int64;
    m_pwd:Int64;
    m_bSetFrameHeader:Boolean;
    
    constructor Create();
    function MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;overload;virtual;//组桢
    function MakeFrame(AFN:Byte; pUserData:P_USER_DATA):PByte;overload;virtual;
    function MakeFrame(ctrl:Byte; regAddr:Integer; pDataUnit:PByte=nil; len:Integer=0):PByte;overload;virtual;
    function MakeFrame(ctrl:Byte; regAddr:Integer; regLen:Integer):PByte;overload;virtual;

    function MakeRespFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;virtual;//组桢
    function CheckFrame(pBuf:PByte;len:Integer):Boolean;virtual;//检查帧是否正确
    function GetRelayLevel():Byte;virtual;
    function GetAFN():Byte;virtual;
    function GetFn():Byte;overload;virtual;
    function GetFn(DT1:Byte; DT2:Byte):Byte;overload;virtual;
    function GetPn():Integer;overload;virtual;
    function GetPn(DA1:Byte; DA2:Byte):Integer;overload;virtual;
    function GetDataUnit():PByte;virtual;       //国电系列返回数据单元，645返回数据标识后面的数据
    function GetDataUnitLen():Integer;virtual;  //国电系列返回数据单元的长度，645返回数据标识后面的数据的长度
    function GetUserData():PByte;virtual;
    function GetUserDataLen():Integer;virtual;
    function GetBuf():PByte;virtual;          //获取的是整个缓冲的地址
    function GetLen():Integer;virtual;        //获取的是整个缓冲的长度
    function GetFrameBuf():PByte;virtual;     //获取的是正确帧的地址
    function GetFrameLen():Integer;virtual;   //获取的是正确帧的长度
    function SetDeviceAddr(nAddr:Int64):Boolean;virtual; //设置设备地址到协议，以组成发送帧
    function GetDeviceAddr():Int64;virtual;              //从应答协议帧中获取设备地址
    function SetDevicePwd(nPwd:Int64):Boolean;virtual; //设置设备密码到协议
    function IsRespOK():Boolean;virtual;//是否正常应答
    function IsLogin():Boolean;virtual;//是否登录报文
    function IsLogout():Boolean;virtual;//是否登出报文
    function IsHarteBeate():Boolean;virtual;//是否心跳报文
    function SetFrameHeader(pBuf:PByte;len:Integer):Boolean;virtual;//设置帧头，如FE FC

    function IsGetDevName():Boolean;virtual; //是否获取设备名称
    function GetDevName():string;virtual; //获取设备名称
    
    function IsGetDevVersion():Boolean;virtual; //是否获取版本
    function GetDevVersion():string;virtual; //获取设备版本
    
    //以下645专业
    function GetDI():LongWord;virtual;        //返回645规约的数据标识符，或者国电规约的数据单元标识
    function GetCtrl():Byte;virtual;
    function MakeFrame_645(ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):PByte;virtual;

    function mb_crc16(ucFrame:PByte; iLen:Integer):word;
  end;

var
  //O_Protocol: T_Protocol;
  O_ProTx: T_Protocol;
  O_ProRx: T_Protocol;
  O_ProTx_645: T_Protocol;
  O_ProRx_645: T_Protocol;
  O_ProTx_Mod: T_Protocol;
  O_ProRx_Mod: T_Protocol;
      
implementation

const aucCRCHi:array[0..255] of Byte =
(
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $00, $C1, $81, $40,
    $01, $C0, $80, $41, $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41,
    $00, $C1, $81, $40
);

const aucCRCLo:array[0..255] of Byte =
(
    $00, $C0, $C1, $01, $C3, $03, $02, $C2, $C6, $06, $07, $C7,
    $05, $C5, $C4, $04, $CC, $0C, $0D, $CD, $0F, $CF, $CE, $0E,
    $0A, $CA, $CB, $0B, $C9, $09, $08, $C8, $D8, $18, $19, $D9,
    $1B, $DB, $DA, $1A, $1E, $DE, $DF, $1F, $DD, $1D, $1C, $DC,
    $14, $D4, $D5, $15, $D7, $17, $16, $D6, $D2, $12, $13, $D3,
    $11, $D1, $D0, $10, $F0, $30, $31, $F1, $33, $F3, $F2, $32,
    $36, $F6, $F7, $37, $F5, $35, $34, $F4, $3C, $FC, $FD, $3D,
    $FF, $3F, $3E, $FE, $FA, $3A, $3B, $FB, $39, $F9, $F8, $38,
    $28, $E8, $E9, $29, $EB, $2B, $2A, $EA, $EE, $2E, $2F, $EF,
    $2D, $ED, $EC, $2C, $E4, $24, $25, $E5, $27, $E7, $E6, $26,
    $22, $E2, $E3, $23, $E1, $21, $20, $E0, $A0, $60, $61, $A1,
    $63, $A3, $A2, $62, $66, $A6, $A7, $67, $A5, $65, $64, $A4,
    $6C, $AC, $AD, $6D, $AF, $6F, $6E, $AE, $AA, $6A, $6B, $AB,
    $69, $A9, $A8, $68, $78, $B8, $B9, $79, $BB, $7B, $7A, $BA,
    $BE, $7E, $7F, $BF, $7D, $BD, $BC, $7C, $B4, $74, $75, $B5,
    $77, $B7, $B6, $76, $72, $B2, $B3, $73, $B1, $71, $70, $B0,
    $50, $90, $91, $51, $93, $53, $52, $92, $96, $56, $57, $97,
    $55, $95, $94, $54, $9C, $5C, $5D, $9D, $5F, $9F, $9E, $5E,
    $5A, $9A, $9B, $5B, $99, $59, $58, $98, $88, $48, $49, $89,
    $4B, $8B, $8A, $4A, $4E, $8E, $8F, $4F, $8D, $4D, $4C, $8C,
    $44, $84, $85, $45, $87, $47, $46, $86, $82, $42, $43, $83,
    $41, $81, $80, $40
);

function T_Protocol.mb_crc16(ucFrame:PByte; iLen:Integer):word;
var ucCRCHi,ucCRCLo:Byte;
    iIndex, i :Integer;
begin
    ucCRCHi := $FF;
    ucCRCLo := $FF;
    iIndex := 0;
	  i := 0;
  
    Result := 0;
    while iLen>0 do
    begin
        iIndex := ucCRCLo xor ucFrame^; Inc(ucFrame);
        ucCRCLo := ( ucCRCHi xor aucCRCHi[iIndex] );
        ucCRCHi := aucCRCLo[iIndex];
        Inc(iLen, -1);
    end;
    
    Result := ( ucCRCHi shl 8 or ucCRCLo );
end;

constructor T_Protocol.Create();
begin
    m_addr := INVALID_DEVADDR;
    m_pwd := 0;
    m_bSetFrameHeader := False;
end;

function T_Protocol.MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
begin
    Result := nil;
end;

function T_Protocol.MakeFrame(AFN:Byte; pUserData:P_USER_DATA):PByte;
begin
    Result := nil;
end;

{
function T_Protocol.MakeFrame(ctrl:Byte; regAddr:Integer; pDataUnit:PByte=nil; len:Integer=0):PByte;
var p:Integer;
    crc:Word;
begin
    p := 0;
    m_buf[p] := m_addr; Inc(p);
    //m_buf[p] := 1; Inc(p);

    m_buf[p] := ctrl; Inc(p);

    //MoveMemory(@m_buf[p], @regAddr, 2); Inc(p, 2);
    m_buf[p] := regAddr shr 8; Inc(p);
    m_buf[p] := regAddr shr 0; Inc(p);
    
    MoveMemory(@m_buf[p], pDataUnit, len); Inc(p, len);

    crc := mb_crc16(@m_buf[0], p);

    MoveMemory(@m_buf[p], @crc, 2); Inc(p, 2);
    //m_buf[p] := crc shr 8; Inc(p);
    //m_buf[p] := crc shr 0; Inc(p);
    
    m_len := p;
end;
}

function T_Protocol.MakeFrame(ctrl:Byte; regAddr:Integer; pDataUnit:PByte=nil; len:Integer=0):PByte;
begin
    MoveMemory(@m_buf[0], pDataUnit, len);
    m_len := len;
end;

function T_Protocol.MakeFrame(ctrl:Byte; regAddr:Integer; regLen:Integer):PByte;
var buf:array[0..255]of Byte;
begin
    buf[0] := regLen shr 8;
    buf[1] := regLen shr 0;
    MakeFrame(ctrl, regAddr, @buf[0], 2);
end;

function T_Protocol.MakeRespFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
begin
    Result := nil;
end;

function T_Protocol.CheckFrame(pBuf:PByte;len:Integer):Boolean;//检查帧是否正确
var i:Integer;
    crc:Word;
    p:PByte;
begin
    Result := False;
    MoveMemory(@m_buf[0],pBuf,len);
    p := @m_buf[0];

    crc := mb_crc16(pBuf, len-2);

    if PWord(@m_buf[len-2])^ = crc then
    begin
        m_addr := m_buf[0];
        m_len := len;
        Result := True;
    end;
end;

function T_Protocol.GetRelayLevel():Byte;
begin
    Result := 0;
end;

function T_Protocol.GetAFN():Byte;
begin

end;

function T_Protocol.GetFn():Byte;
begin
end;

function T_Protocol.GetFn(DT1:Byte; DT2:Byte):Byte;
begin
end;

function T_Protocol.GetPn():Integer;
begin
end;

function T_Protocol.GetPn(DA1:Byte; DA2:Byte):Integer;
begin
end;
    
function T_Protocol.GetDataUnit():PByte;
begin

end;

function T_Protocol.GetDataUnitLen():Integer;
begin

end;

function T_Protocol.GetUserData():PByte;
begin
    Result := @m_buf[2];
end;

function T_Protocol.GetUserDataLen():Integer;
begin
    Result := m_len - 4;
end;
    
function T_Protocol.GetBuf():PByte;        //获取的是整个缓冲的地址
begin
    Result := @m_buf[0];
end;

function T_Protocol.GetLen():Integer;        //获取的是整个缓冲的长度
begin
    Result := m_len;
end;

function T_Protocol.GetFrameBuf():PByte;   //获取的是正确帧的地址
begin
    Result := @m_buf[0];
end;

function T_Protocol.GetFrameLen():Integer;   //获取的是正确帧的长度
begin
    Result := m_len;
end;

function T_Protocol.SetDeviceAddr(nAddr:Int64):Boolean; //设置设备地址到协议
begin
    m_addr := nAddr;
    Result := True;
end;

function T_Protocol.GetDeviceAddr():Int64;              //从应答协议帧中获取设备地址
begin
    Result := m_addr;
end;
    
function T_Protocol.SetDevicePwd(nPwd:Int64):Boolean; //设置设备密码到协议
begin
    m_pwd := nPwd;
    Result := True;
end;

function T_Protocol.IsRespOK():Boolean;//是否正常应答
begin
    Result := True;
end;

function T_Protocol.GetDI():LongWord;
begin
    Result := m_buf[1];
end;

function T_Protocol.GetCtrl():Byte;
begin
    Result := m_buf[1];
end;

function T_Protocol.MakeFrame_645(ctrl:Byte; DI:LongWord; pData:PByte=nil; datalen:Integer=0):PByte;
begin
    Result := nil;
end;

function T_Protocol.IsLogin():Boolean;//是否登录报文
begin
    Result := False;
end;

function T_Protocol.IsLogout():Boolean;//是否登出报文
begin
    Result := False;
end;

function T_Protocol.IsHarteBeate():Boolean;//是否心跳报文
begin
    Result := False;
end;

function T_Protocol.SetFrameHeader(pBuf:PByte;len:Integer):Boolean;//设置帧头，如FE FC
begin
    Result := False;
end;

function T_Protocol.IsGetDevName():Boolean; //是否获取设备名称
begin
    Result := False;
end;

function T_Protocol.GetDevName():string; //获取设备名称
begin
    Result := '';
end;

function T_Protocol.IsGetDevVersion():Boolean;
begin
    Result := False;
end;

function T_Protocol.GetDevVersion():string;
begin
    Result := '';
end;
    
end.
