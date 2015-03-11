unit U_Protocol_mod;

interface

uses Windows,SysUtils,U_MyFunction,DateUtils,U_Protocol;

Type
  PTFrameMod = ^TFrameMod;
  TFrameMod = packed record
      m_start:Byte;//֡��ʼ��
      m_len:Word;
      m_ctrl:Byte;
      m_userData:array[0..5*1024-1] of Byte;
  end;

type
  T_Protocol_mod = class(T_Protocol)
  private
    { Private declarations }
    m_pFrame:PTFrameMod;
    function MakeFrameByUserData(pUserData:PByte; len:Integer; comm_mode:Byte=1):PByte;//����
  public
    { Public declarations }
    constructor Create();
    function MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;override;
    function CheckFrame(pBuf:PByte;len:Integer):Boolean;override;//���֡�Ƿ���ȷ
    function GetRelayLevel():Byte;override;
    function GetAFN():Byte;override;
    function GetFn():Byte;override;
    function GetDataUnit():PByte;override;
    function GetDataUnitLen():Integer;override;
    function GetFrameBuf():PByte;override;     //��ȡ������ȷ֡�ĵ�ַ
    function GetFrameLen():Integer;override;   //��ȡ������ȷ֡�ĳ���
        
  end;

var
  O_Protocol_mod: T_Protocol_mod;
  
implementation


const
    CTRL_DIR_UPLINK            = $80;
    CTRL_PRM_FROM_MASTER       = $40;
    CTRL_COMM_MODE_CENTRALIZED = 1;
    CTRL_COMM_MODE_DISTRIBUTED = 2;
    CTRL_COMM_MODE_ESCSOFT     = 7;
    CTRL_COMM_MODE_WIRELESS    = 10;
    CTRL_COMM_MODE_TCP         = 20;

const
    IFO_COMM_MODULE_ID_PLCMETER = $04; // ��Ϣ���ͨѶģ���ʶ
    IFO_RELAY_LEVEL             = $f0;
    
constructor T_Protocol_mod.Create();
begin
    m_pFrame := @m_buf[0];
    AFN_UPDATE_SELF := $F6;
end;

function T_Protocol_mod.MakeFrameByUserData(pUserData:PByte; len:Integer; comm_mode:Byte=1):PByte;
begin
    m_pFrame := @m_buf[0];
    m_pFrame.m_start := $68;
    m_pFrame.m_len := len+6;
    //m_pFrame.m_ctrl := CTRL_PRM_FROM_MASTER or CTRL_COMM_MODE_CENTRALIZED;
    m_pFrame.m_ctrl := CTRL_PRM_FROM_MASTER or comm_mode;
    MoveMemory(@m_pFrame.m_userData[0],pUserData,len);
    m_pFrame.m_userData[len] := GetSum(@m_pFrame.m_ctrl,len+1);
    m_pFrame.m_userData[len+1] := $16;
    m_len := GetFrameLen();
    Result := PByte(m_pFrame);
end;

function T_Protocol_mod.MakeFrame(AFN,Fn:Byte; pDataUnit:PByte=nil; len:Integer=0; Pn:Word=0; IS_COMM_MODULE_ID_PLC:Boolean=False):PByte;
var UserData:array[0..5*1024-1]of Byte;
    p:Integer;
    pIfo:^Int64;
    pDT1,pDT2:PByte;
begin
    p := 0;
    pIfo := @UserData[p];   Inc(p,6);
    pIfo^ := 0;
    pIfo^ := $5f0000;

    if (AFN=$02) and (Fn=F5) then
    begin
        pIfo^ := $ff0000;
    end;
    
    if IS_COMM_MODULE_ID_PLC then
    begin
        pIfo^ := pIfo^ or IFO_COMM_MODULE_ID_PLCMETER;
        Inc(p,12);
    end;
    //--·�ɱ�ʶ��0��ʾͨ��ģ���·�ɻ�����·��ģʽ��1��ʾͨ��ģ�鲻��·�ɻ�������·ģʽ��
    //--�����ڵ��ʶ��ָ�ز��ӽڵ㸽���ڵ��ʶ��0��ʾ�޸��ӽڵ㣬1��ʾ�и��ӽڵ㡣
    //--ͨ��ģ���ʶ��0��ʾ�Լ�������ͨ��ģ�������1��ʾ���ز����ͨ��ģ�������
    //--��ͻ��⣺0��ʾ�����г�ͻ��⣬1��ʾҪ���г�ͻ��⡣
    //--�м̼���ȡֵ��Χ0~15��0��ʾ���м̡�
    //--�ŵ���ʶ��ȡֵ0~15��0��ʾ�����ŵ���1~15���α�ʾ��1~15�ŵ���
    //--��������ʶ��ȡֵ��Χ0~15��0��ʾ�ŵ�δ���룬1��ʾRS���룬2~15������
    //--Ԥ��Ӧ���ֽ�����ȡֵ0~255�����ڼ�����ʱ�ȴ�ʱ�䣻Ϊ0ʱ����ʱ�ȴ�ʱ��ΪĬ��ʱ�䡣
    //--ͨ�����ʣ���ʾͨ�Ų����ʣ�BIN��ʽ��0��ʾĬ��ͨ�����ʡ�
    //--���ʵ�λ��ʶ��0��ʾbps��1��ʾkbps��
    UserData[p] := AFN;   Inc(p,1);
    pDT1 := @UserData[p];   Inc(p,1);
    pDT2 := @UserData[p];   Inc(p,1);
    pDT1^ := 1 shl ((Fn-1) mod 8);
    pDT2^ := (Fn-1) div 8;
    MoveMemory(@UserData[p],pDataUnit,len);
    Inc(p,len);

    //if (AFN=$01) or (AFN=$02) then
    if ((AFN=$01)and(Fn=F7))or((AFN=$02)and(Fn=F5)) then
    begin
        Result := MakeFrameByUserData(PByte(@UserData[0]), p, CTRL_COMM_MODE_ESCSOFT);
    end
    else
    begin
        Result := MakeFrameByUserData(PByte(@UserData[0]), p);
    end;
end;

function T_Protocol_mod.CheckFrame(pBuf:PByte;len:Integer):Boolean;//���֡�Ƿ���ȷ
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
        m_pFrame := PTFrameMod(p);
        if    (m_pFrame.m_start = $68)
          and ((m_pFrame.m_ctrl and CTRL_DIR_UPLINK) >0 )
          and (m_pFrame.m_len<=len-i)
          and (m_pFrame.m_userData[m_pFrame.m_len-5] = $16)
          and (m_pFrame.m_userData[m_pFrame.m_len-6] = GetSum(PByte(@m_pFrame.m_ctrl),m_pFrame.m_len-5))
        then
        begin
            Result := True;
            Exit;
        end;
        Inc(p);
    end;
end;

function T_Protocol_mod.GetRelayLevel():Byte;
var ifo:Int64;
begin
    ifo := 0;
    MoveMemory(@ifo,@m_pFrame.m_userData[0],6);
    Result := ifo and IFO_RELAY_LEVEL shr 4;
end;

function T_Protocol_mod.GetAFN():Byte;
var ifo:Int64;
    p:Integer;
begin
    p := 0;
    ifo := 0;
    MoveMemory(@ifo,@m_pFrame.m_userData[p],6);
    Inc(p,6);
    if ifo and IFO_COMM_MODULE_ID_PLCMETER > 0 then
    begin
        Inc(p,6*(GetRelayLevel()+2));
    end;
    Result := m_pFrame.m_userData[p];
end;

function T_Protocol_mod.GetFn():Byte;
var ifo:Int64;
    i,p:Integer;
    DT1,DT2:Byte;
begin
    p := 0;
    ifo := 0;
    MoveMemory(@ifo,@m_pFrame.m_userData[p],6);
    Inc(p,6);
    if ifo and IFO_COMM_MODULE_ID_PLCMETER > 0 then
    begin
        Inc(p,6*(GetRelayLevel()+2));
    end;
    Inc(p);//Afn
    DT1 := m_pFrame.m_userData[p];    Inc(p);
    DT2 := m_pFrame.m_userData[p];    Inc(p);
    for i:=0 to 7 do
    begin
        if (DT1 shr i and 1)>0 then
        begin
            Result := DT2*8 + i + 1;
            Break;
        end;
    end;
end;

function T_Protocol_mod.GetDataUnit():PByte;
var ifo:Int64;
    p:Integer;
begin
    p := 0;
    ifo := 0;
    MoveMemory(@ifo,@m_pFrame.m_userData[p],6);
    Inc(p,6);
    if ifo and IFO_COMM_MODULE_ID_PLCMETER > 0 then
    begin
        Inc(p,6*(GetRelayLevel()+2));
    end;
    Inc(p);//Afn
    Inc(p,2);//fn
    Result := @m_pFrame.m_userData[p];
end;

function T_Protocol_mod.GetDataUnitLen():Integer;
var pDataUnit,pSum:PByte;
begin
    pDataUnit := GetDataUnit();
    pSum := @m_pFrame.m_userData[m_pFrame.m_len-6];
    Result := Integer(pSum) - Integer(pDataUnit);
end;

function T_Protocol_mod.GetFrameBuf():PByte;     //��ȡ������ȷ֡�ĵ�ַ
begin
    Result := PByte(m_pFrame);
end;

function T_Protocol_mod.GetFrameLen():Integer;   //��ȡ������ȷ֡�ĳ���
begin
    Result := m_pFrame.m_len;
end;
    
end.
