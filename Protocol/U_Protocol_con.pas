unit U_Protocol_con;

interface

uses Windows,SysUtils,U_MyFunction,DateUtils,U_Protocol, Math;

//const
    //AFN_CFG = $04;
    //AFN_READ_CLASS1   = $0C;
    //AFN_READ_CLASS2   = $0D;
    //AFN_

const
    GPRS_FLAG_HUAWEI = 0;
    GPRS_FLAG_YOUFANG = 1;


    FREEZE_FLAG_LAST_DAY = 0;
    FREEZE_FLAG_CURRENT = 1;

    CUSTOMER_FLAG_COMMON = 0;
    CUSTOMER_FLAG_XIAOCHENG = 1;
    CUSTOMER_FLAG_ZAHT      = 2;


    ACS_FLAG_NOT_ON_CONCENTRATOR = 0;
    ACS_FLAG_ON_CONCENTRATOR = 1;

    en_mode_release = 0; //发布模式
    en_mode_debug = 1;   //调试模式

Type
  PDataTranParam = ^TDataTranParam;
  TDataTranParam = packed record
      nPort:Byte; //终端通信端口号	BIN		1
      tranCtrl:Byte;  //透明转发通信控制字	BS8		1
      nFrameTimeout:Byte;  //透明转发接收等待报文超时时间	BS8	10ms或1s	1
      nByteTimeout:Byte;   //透明转发接收等待字节超时时间	BIN	10ms	1
      nTranLen:Word;      //透明转发内容字节数k	BIN	字节	2
      data:array[0..0]of Byte;//透明转发内容			k
  end;
  
Type
  P_CFG_INFO_VERSIONS = ^CFG_INFO_VERSIONS;
  CFG_INFO_VERSIONS = packed record
      gprsModeFlag:BYTE;        //GPRS标识，有方，华为等
      freezeFlag:BYTE;          //冻结标识，当前，上一日
      customerFlag:BYTE;        //客户标识，晓程，江西等
      acsFlag:BYTE;             //交采标识，旧交采，新交采
  end;

Type
  PTMeterStat = ^TMeterStat;
  TMeterStat = packed record
      port:Byte;          //终端通信端口号	BIN	1
      meterCount:Word;    //要抄电表总数	BIN	2
      readStatus:Byte;    //当前抄表工作状态标志	BS8	1
      successCount:Word;  //抄表成功块数	BIN	2
      vipSuccessCount:Byte; //抄重点表成功块数	BIN	1
      startTime:array[0..5]of Byte; //抄表开始时间	见附录A.1	6
      endTime:array[0..5]of Byte;   //抄表结束时间	见附录A.1	6
  end;

  type PTMeterFile3761=^TMeterFile3761;
  TMeterFile3761=packed record
      nMeterSn:         Word;//表序号
      nTpSn:            Word;//所属测量点号
      nCommParam:       Byte;//通信速率及端口号
      nProtoType:       Byte;//通信协议类型
      aMeterNo:         array[0..5] of Byte;//表号
      aMeterPwd:        array[0..5] of Byte;//通信密码,bin格式,StrToInt(PASSWORD)
      nTariffCount:     Byte;//电能费率个数
      nActEnerDisplay:  Byte;//有功电能示值整数位及小数位个数
      aCollTerNo:       array[0..5] of Byte;//采集终端编号
      nUserType:        Byte;//用户大类号及用户小类号
  end;
  
Type
  PTFrameCon = ^TFrameCon;
  TFrameCon = packed record
      m_start1:Byte;
      m_len1:Word;
      m_len2:Word;
      m_start2:Byte;
      m_ctrl:Byte;
      m_codeAddr:Word; //行政区划码A1
      m_termAddr:Word;//终端地址A2
      m_hostAddr:Byte;//主站地址和组地址标志A3

      m_AFN:Byte;
      m_SEQ:Byte;
      //以下为数据单元标识，数据单元，校验和，结束
      m_userData:array[0..1023] of Byte;
  end;

type
  T_Protocol_con = class(T_Protocol)
  private
    { Private declarations }
    m_pFrame:PTFrameCon;
  public
    { Public declarations }
    constructor Create();
    function MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;overload;override;
    function MakeFrame(AFN:Byte; pUserData:P_USER_DATA):PByte;overload;override;
    function MakeRespFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;override;//组桢
    function CheckFrame(pBuf:PByte;len:Integer):Boolean;override;//检查帧是否正确
    function GetAFN():Byte;override;
    function GetFn():Byte;overload;override;
    function GetFn(DT1:Byte; DT2:Byte):Byte;overload;override;
    function GetPn():Integer;overload;override;
    function GetPn(DA1:Byte; DA2:Byte):Integer;overload;override;
    function GetDataUnit():PByte;override;
    function GetDataUnitLen():Integer;override;
    function GetUserData():PByte;override;
    function GetUserDataLen():Integer;override;
    function GetFrameBuf():PByte;override;     //获取的是正确帧的地址
    function GetFrameLen():Integer;override;   //获取的是正确帧的长度
    function GetDI():LongWord;override;

    function IsLogin():Boolean;override;//是否登录报文
    function IsLogout():Boolean;override;//是否登出报文
    function IsHarteBeate():Boolean;override;//是否心跳报文

    function IsGetDevName():Boolean;override; //是否获取设备名称
    function GetDevName():string;override; //获取设备名称
    
    function IsGetDevVersion():Boolean;override;
    function GetDevVersion():string;override; //获取设备版本

    class function DatabufToFloat(pData:PByte;data_format_id:Integer):Double;
    class function FloatToDatabuf(fValue:Double; pData:PByte; data_format_id:Integer):Integer; //返回长度
  end;

var
  O_Protocol_con: T_Protocol_con;
  
implementation

var
    m_seq:Byte;
const
    CTRL_DIR_UPLINK            = $80;

class function T_Protocol_con.DatabufToFloat(pData:PByte;data_format_id:Integer):Double;
var fValue:Double;
    mulRange:Integer;
    pValue:PInt64;
begin
    fValue := 0.0;
    mulRange := 0;

    pValue := PInt64(pData);
    case data_format_id of
      2:
        begin
            fValue := (pValue^ shr 8 and $0f)*100 + (pValue^ shr 4 and $0f)*10 + (pValue^ shr 0 and $0f);
            mulRange := 4-(pValue^ shr 13 and $07);
            fValue := fValue * power(10,mulRange);
            if (pValue^ shr 12 and $01)>0 then
            begin
                fValue := -fValue;
            end;
        end;
    end;
    
    Result := fValue;
end;

class function T_Protocol_con.FloatToDatabuf(fValue:Double; pData:PByte; data_format_id:Integer):Integer; //返回长度
var mulRange:Integer;
    nValue:Integer;
    absValue:Double;
    pValue:PInt64;
begin
    Result := 0;
    pValue := PInt64(pData);

    mulRange := 0;
    nValue := Round(fValue);
    absValue := Abs(fValue);
    pValue^ := 0;
    
    case data_format_id of
    2:
        begin
            if fValue<0 then
            begin
                pValue^ := pValue^ or (1 shl 12);
            end;

            if(absValue >= 1000)then
            begin
                nValue := abs(nValue);
                while(nValue>=1000)do
                begin
                    nValue := nValue div 10;
                    Inc(mulRange);
                end;
            end
            else
            begin
                if ((Round(fValue*1000))mod 1000 <> 0) and (absValue*1000 < 1000) then //千分位
                begin
                    nValue := Round(absValue*1000);
                    mulRange := mulRange-3;
                end
                else if ((Round(fValue*100))mod 100 <> 0) and (absValue*100 < 1000) then //百分位
                begin
                    nValue := Round(absValue*100);
                    mulRange := mulRange-2;
                end
                else if((Round(fValue*10))mod 10 <> 0) and (absValue*10 < 1000) then//十分位
                begin
                    nValue := Round(absValue*10);
                    mulRange := mulRange-1;
                end;
            end;
            nValue := Abs(nValue);
            pValue^ := pValue^ or (nValue mod 10);
            pValue^ := pValue^ or ((nValue div 10 mod 10) shl 4);
            pValue^ := pValue^ or ((nValue div 100 mod 10) shl 8);
            pValue^ := pValue^ or ((4-mulRange) shl 13);
            Result := 2;
        end;
    end;
end;

constructor T_Protocol_con.Create();
begin
    m_pFrame := @m_buf[0];

    AFN_UPDATE_SELF := $0F;
    m_seq := $00;
    m_addr := $07550001;
end;

function T_Protocol_con.MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
var pDA1,pDA2,pDT1,pDT2:PByte;
    p:Integer;
begin
    m_pFrame.m_start1 := $68;
    //m_pFrame.m_len1 := ((len+12)shl 2 and $fffc) or $02;
    //m_pFrame.m_len2 := m_pFrame.m_len1;
    m_pFrame.m_start2 := $68;
    m_pFrame.m_ctrl := $40;
    if (AFN=AFN_UPDATE_SELF) then
    begin
        m_pFrame.m_ctrl := m_pFrame.m_ctrl or 10;
    end;

    m_pFrame.m_AFN  := AFN;
    m_pFrame.m_termAddr  := m_addr shr 00 and $ffff;
    m_pFrame.m_codeAddr  := m_addr shr 16 and $ffff;
    m_pFrame.m_hostAddr := 0;

    m_pFrame.m_SEQ := $60 or (m_seq and $0f);

    if (AFN=AFN_UPDATE_SELF) and (Fn=F1) then
    begin
        //m_pFrame.m_SEQ := m_pFrame.m_SEQ or $10;  //需要确认
    end;

    p := 0;
    
    pDA1 := @m_pFrame.m_userData[p];  Inc(p);
    pDA2 := @m_pFrame.m_userData[p];  Inc(p);

    if Pn>0 then
    begin
        pDA1^ := 1 shl ((Pn-1) mod 8);
        pDA2^ := (Pn-1) div 8 + 1;
    end
    else
    begin
        pDA1^ := 0;
        pDA2^ := 0;
    end;

    pDT1 := @m_pFrame.m_userData[p];  Inc(p);
    pDT2 := @m_pFrame.m_userData[p];  Inc(p);
    pDT1^ := 1 shl ((Fn-1) mod 8);
    pDT2^ := (Fn-1) div 8;

    MoveMemory(@m_pFrame.m_userData[p], pDataUnit, len);  Inc(p, len);

    //密码
    case AFN of
      AFN_WRITE_PARAM,
      AFN_CTRL:
        begin
          Inc(p, 16);
          Inc(len, 16);
        end;
    end;

    m_pFrame.m_len1 := ((len+12)shl 2 and $fffc) or $02;
    m_pFrame.m_len2 := m_pFrame.m_len1;

    m_pFrame.m_userData[p] := GetSum(@m_pFrame.m_ctrl,m_pFrame.m_len1 shr 2 and $3fff);  Inc(p);
    m_pFrame.m_userData[p] := $16; Inc(p);

    m_len := GetFrameLen();
    Result := PByte(m_pFrame);
end;

function T_Protocol_con.MakeFrame(AFN:Byte; pUserData:P_USER_DATA):PByte;
var p, p0:PByte;
    buf:array[0..1023]of Byte;
    i, len:Integer;
    pDA1,pDA2,pDT1,pDT2:PByte;
    Fn:Byte;
    Pn:Integer;
begin
    p0 := @buf[0];
    p := p0;

    len := pUserData.dataUnitLen[0];
    if len>0 then
    begin
        MoveMemory(p, @pUserData.dataUnit[0], len);  Inc(p, len);
    end;
    for i:=1 to pUserData.nDICount-1 do
    begin
        Pn := pUserData.Pn[i];
        Fn := pUserData.Fn[i];
        
        pDA1 := p;  Inc(p);
        pDA2 := p;  Inc(p);

        if Pn>0 then
        begin
            pDA1^ := 1 shl ((Pn-1) mod 8);
            pDA2^ := (Pn-1) div 8 + 1;
        end
        else
        begin
            pDA1^ := 0;
            pDA2^ := 0;
        end;

        pDT1 := p;  Inc(p);
        pDT2 := p;  Inc(p);
        pDT1^ := 1 shl ((Fn-1) mod 8);
        pDT2^ := (Fn-1) div 8;
        
        len := pUserData.dataUnitLen[i];
        if len>0 then
        begin
            MoveMemory(p, @pUserData.dataUnit[i], len);  Inc(p, len);
        end;
    end;
    Result := MakeFrame(AFN, pUserData.Fn[0], p0, Integer(p)-Integer(p0), pUserData.Pn[0]);
end;

function T_Protocol_con.MakeRespFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
var pDA1,pDA2,pDT1,pDT2:PByte;
    p:Integer;
begin
    m_pFrame.m_start1 := $68;
    m_pFrame.m_len1 := ((len+12)shl 2 and $fffc) or $02;
    m_pFrame.m_len2 := m_pFrame.m_len1;
    m_pFrame.m_start2 := $68;
    m_pFrame.m_ctrl := m_pFrame.m_ctrl and $7f;
    m_pFrame.m_ctrl := m_pFrame.m_ctrl and (not $40);

    m_pFrame.m_AFN  := AFN;

    p := 0;
    
    pDA1 := @m_pFrame.m_userData[p];  Inc(p);
    pDA2 := @m_pFrame.m_userData[p];  Inc(p);

    if Pn>0 then
    begin
        pDA1^ := 1 shl ((Pn-1) mod 8);
        pDA2^ := (Pn-1) div 8 + 1;
    end
    else
    begin
        pDA1^ := 0;
        pDA2^ := 0;
    end;

    pDT1 := @m_pFrame.m_userData[p];  Inc(p);
    pDT2 := @m_pFrame.m_userData[p];  Inc(p);
    pDT1^ := 1 shl ((Fn-1) mod 8);
    pDT2^ := (Fn-1) div 8;

    MoveMemory(@m_pFrame.m_userData[p], pDataUnit, len);  Inc(p, len);
    m_pFrame.m_userData[p] := GetSum(@m_pFrame.m_ctrl,m_pFrame.m_len1 shr 2 and $3fff);  Inc(p);
    m_pFrame.m_userData[p] := $16; Inc(p);

    m_len := GetFrameLen();
    Result := PByte(m_pFrame);
end;

function T_Protocol_con.CheckFrame(pBuf:PByte;len:Integer):Boolean;//检查帧是否正确
var i:Integer;
    crc:Word;
    buf:pByteBuf;
    p:PByte;
begin
    Result := False;
    MoveMemory(@m_buf[0],pBuf,len);
    p := @m_buf[0];
    m_pFrame := nil;
    for i:=0 to len-1 do
    begin
        m_pFrame := PTFrameCon(p);
        if    (m_pFrame.m_start1 = $68)
          and (m_pFrame.m_start2 = $68)
          and ((m_pFrame.m_ctrl and CTRL_DIR_UPLINK) >0 )
          and (m_pFrame.m_len1=m_pFrame.m_len2)
          and (GetFrameLen()<=len-i)
          and (PByte(Integer(m_pFrame)+GetFrameLen()-1)^ = $16)
          and (PByte(Integer(m_pFrame)+GetFrameLen()-2)^ = GetSum(PByte(@m_pFrame.m_ctrl),m_pFrame.m_len1 shr 2 and $3fff))
        then
        begin
            Inc(m_seq);
            Result := True;
            m_addr := (m_pFrame.m_codeAddr shl 16) or m_pFrame.m_termAddr;
            Exit;
        end;
        Inc(p);
    end;
end;

function T_Protocol_con.GetAFN():Byte;
begin
    Result := m_pFrame.m_AFN;
end;

function T_Protocol_con.GetFn():Byte;
var p:Integer;
    DT1,DT2:Byte;
begin
    p := 0;
    Inc(p);   //DA1
    Inc(p);   //DA2
    DT1 := m_pFrame.m_userData[p];    Inc(p);
    DT2 := m_pFrame.m_userData[p];    Inc(p);

    Result := GetFn(DT1, DT2);
end;

function T_Protocol_con.GetFn(DT1:Byte; DT2:Byte):Byte;
var i:Integer;
begin
    for i:=0 to 7 do
    begin
        if (DT1 shr i and 1)>0 then
        begin
            Result := DT2*8 + i + 1;
            Break;
        end;
    end;  
end;

function T_Protocol_con.GetPn():Integer;
var p:Integer;
    DA1,DA2:Byte;
begin
    p := 0;
    DA1 := m_pFrame.m_userData[p];    Inc(p);
    DA2 := m_pFrame.m_userData[p];    Inc(p);

    Result := GetPn(DA1, DA2);
end;

function T_Protocol_con.GetPn(DA1:Byte; DA2:Byte):Integer;
var nCount, nPos:Byte;
    i:Integer;
begin
		nCount := 0;
		nPos := 8;

    for i:=0 to 7 do
    begin
        if((DA1 shr i and $01)=1) then
        begin
            Inc(nCount);
            if nCount>1 then //两个或以上的 1
            begin
                Result := -1;
                Exit;
            end;
            nPos := i;
        end;
    end;
		if (nPos>=8) then//没有1
		begin
			  Result := -1;
        Exit;
		end;
    
    Result := 8*(DA2-1)+nPos+1;
end;

function T_Protocol_con.GetDataUnit():PByte;
var
    p:Integer;
begin
    p := 0;
    Inc(p,2);//pn
    Inc(p,2);//fn
    Result := @m_pFrame.m_userData[p];
end;

function T_Protocol_con.GetDataUnitLen():Integer;
var pDataUnit,pSum:PByte;
begin
    pDataUnit := GetDataUnit();
    pSum := PByte(Integer(m_pFrame)+GetFrameLen()-2);
    Result := Integer(pSum) - Integer(pDataUnit);
end;

function T_Protocol_con.GetUserData():PByte;
begin
    Result := @m_pFrame.m_userData[0];
end;

function T_Protocol_con.GetUserDataLen():Integer;
var pSum:PByte;
begin
    pSum := PByte(Integer(m_pFrame)+GetFrameLen()-2);
    Result := Integer(pSum) - Integer(GetUserData());
end;

function T_Protocol_con.GetFrameBuf():PByte;     //获取的是正确帧的地址
begin
    Result := PByte(m_pFrame);
end;

function T_Protocol_con.GetFrameLen():Integer;   //获取的是正确帧的长度
begin
    Result := (m_pFrame.m_len1 shr 2 and $3fff) + 8;
end;

function T_Protocol_con.GetDI():LongWord;
begin
    Result :=   m_pFrame.m_userData[0]
            or (m_pFrame.m_userData[1] shl 8)
            or (m_pFrame.m_userData[2] shl 16)
            or (m_pFrame.m_userData[3] shl 24);
end;

function T_Protocol_con.IsLogin():Boolean;//是否登录报文
begin
    if (GetAFN()=AFN_CHK_LINK)and(GetFn()=F1) then
        Result := True
    else
        Result := False;
end;

function T_Protocol_con.IsLogout():Boolean;//是否登出报文
begin
    if (GetAFN()=AFN_CHK_LINK)and(GetFn()=F2) then
        Result := True
    else
        Result := False;
end;

function T_Protocol_con.IsHarteBeate():Boolean;//是否心跳报文
begin
    if (GetAFN()=AFN_CHK_LINK)and(GetFn()=F3) then
        Result := True
    else
        Result := False;
end;

function T_Protocol_con.IsGetDevName():Boolean; //是否获取设备名称
begin
    if (GetAFN()=AFN_READ_PARAM)and(GetFn()=F97) then
        Result := True
    else
        Result := False;
end;

function T_Protocol_con.GetDevName():string; //获取设备名称
var p:PByte;
    i,len:Integer;
begin
    Result := '';
    if IsGetDevName then
    begin
        p := GetDataUnit();
        len := GetDataUnitLen();
        for i:=0 to len-1 do
        begin
            Result := Result + Char(p^);
            Inc(p);
        end;
    end;
end;

function T_Protocol_con.IsGetDevVersion():Boolean;
begin
    if (GetAFN()=AFN_READ_CFG_IFO)and(GetFn()=F1) then
        Result := True
    else
        Result := False;
end;

function T_Protocol_con.GetDevVersion():string; //获取设备版本
var p:PByte;
begin
    Result := '';
    if IsGetDevVersion then
    begin
        p := GetDataUnit();
        Inc(p, 12);
        Result := Format('%.2x-%.2x-%.2x %s.%s.%s.%s',[
            PByte(Integer(p)+6)^,
            PByte(Integer(p)+5)^,
            PByte(Integer(p)+4)^,
            PChar(Integer(p)+0)^,
            PChar(Integer(p)+1)^,
            PChar(Integer(p)+2)^,
            PChar(Integer(p)+3)^
            ]);
    end;
end;
  
end.
