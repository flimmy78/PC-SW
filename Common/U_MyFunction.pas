unit U_MyFunction;

interface
Uses Forms,ADODB,Dialogs,Messages,
     Windows, SysUtils, Variants, Classes, Graphics, Controls,DateUtils,
     DB, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls,Clipbrd,StrUtils;

type  
  TFileInfo = packed record
      CommpanyName:   string;
      FileDescription:   string;  
      FileVersion:   string;  
      InternalName:   string;  
      LegalCopyright:   string;  
      LegalTrademarks:   string;
      OriginalFileName:   string;  
      ProductName:   string;  
      ProductVersion:   string;  
      Comments:   string;  
      VsFixedFileInfo:VS_FIXEDFILEINFO;  
      UserDefineValue:string;  
  end;

type userarray=array of string;
type AArayBool=Array of Array of bool;
type  AArayLongword= Array of Array of Longword;
//type  AArayLongword= array[0..10,0..67] of Longword;
function split(s:string;dot:char):userarray;
function GetSum(p:PByte;len:integer):byte;
function CalcBCC(pBuf:pByte;len:Word):Word;

function calccrc(crcbuf:Byte;crc:Word):Word;
//function chkcrc(buf:array of Byte;len:Word):Word;
function chkcrc(buf:pByte;len:Word):Word;

function IntToBCD(src:integer):int64;
function BCDToIntByte(src:Byte):Byte;
function IntToHexnum(src:integer):integer;
function Delay(nMilliSeconds:Int64):Boolean;
function IsEqual(src1,src2:PByte;len:Integer):Boolean;
function MyMessageBox(Handle:HWND; const Text, Caption: string; Flags: Longint = MB_OK): Integer;
function GetFileVersionInfomation(const FileName:string;var info:TFileInfo;p_fixed_info:PVSFixedFileInfo;UserDefine:string=''):boolean;
function GetVersionString(FileName: string): string;//得到文件版本
function RegisterOleFile(strOleFileName: STRING;OleAction: Byte): BOOLEAN;
function ByteToAscii(lpSrc:PByte;nSrcLen:Integer;lpDes:PByte):Word;
function AsciiToByte(lpSrc:PByte;nSrcLen:Integer;lpDes:PByte):Word;
procedure MakeCheck(Sender: TObject;Checked:Boolean);
function BufToHex(pBuf:PByte;len:Integer):string;
function HexToBuf(strHex:string;pBuf:PByte):Integer;
function StringGridSelectText(mStringGrid: TStringGrid): string;
procedure StringGridCopyToClipboard(mStringGrid: TStringGrid);
function mb_swap(usData:word):Word;overload;
function mb_swap_32(usData:LongWord):LongWord;overload;
function mb_swap_buf(pData:PByte; len:Integer):PByte;

implementation

function mb_swap(usData:word):Word;
begin
    Result := (usData shr 8 and $ff) or (usData shl 8 and $ff00);
end;

function mb_swap_32(usData:LongWord):LongWord;
begin
    mb_swap_buf(@usData, 4);
    Result := usData;
end;

function mb_swap_buf(pData:PByte; len:Integer):PByte;
var p0, p:PByte;
    i:Integer;
    tmp:Byte;
begin
    p0 := pData;
    p := PByte(Integer(pData) + len - 1);
    for i:=1 to len div 2 do
    begin
        tmp := p0^;
        p0^ := p^;
        p^  := tmp;
        Inc(p0, 1);
        Inc(p, -1);
    end;
    Result := pData;
end;

procedure StringGridCopyToClipboard(mStringGrid: TStringGrid);
begin
  Clipboard.AsText := StringGridSelectText(mStringGrid);
end; { StringGridCopyToClipboard }

function StringGridSelectText(mStringGrid: TStringGrid): string;
var
  I, J: Integer;
  S: string;
begin
  Result := '';
  if not Assigned(mStringGrid) then Exit;
  for J := mStringGrid.Selection.Top to mStringGrid.Selection.Bottom do
  begin
    S := '';
    for I := mStringGrid.Selection.Left to mStringGrid.Selection.Right do
      S := S + #9 + mStringGrid.Cells[I, J];
    Delete(S, 1, 1);
    Result := Result + S + #13#10;
  end;
end; { StringGridSelectText }

function BufToHex(pBuf:PByte;len:Integer):string;
var i:Integer;
begin
    Result := '';
    for i:=1 to len do
    begin
        if Result='' then
        begin
            Result := Format('%.2X',[pBuf^]);
        end
        else
        begin
            Result := Format('%s %.2X',[Result,pBuf^]);
        end;
        Inc(pBuf);
    end;
end;

function HexToBuf(strHex:string;pBuf:PByte):Integer;
var i,len:Integer;
    tmp:string;
begin
    len := Length(strHex);
    tmp := '';
    Result := 0;
    for i:=1 to len do
    begin
        if strHex[i]<>' ' then
        begin
            if tmp = '' then
            begin
                tmp := strHex[i];
            end
            else
            begin
                tmp := tmp + strHex[i];
                pBuf^ := StrToInt('x'+tmp);
                tmp := '';
                Inc(pBuf);
                Inc(Result);
            end;
        end;
    end;
end;

procedure MakeCheck(Sender: TObject;Checked:Boolean);
var i,nCount:Integer;
    comp:TWinControl;
begin
    if not (Sender is TWinControl) then
        Exit; 
    comp := TWinControl(Sender);
    nCount := comp.ControlCount;
    for i:=0 to nCount-1 do
    begin
        if comp.Controls[i] is TCheckBox then
        begin
            TCheckBox(comp.Controls[i]).Checked := Checked;
        end
        else
        begin
            MakeCheck(comp.Controls[i],Checked);
        end;
    end;
end;

function CalcBCC(pBuf:pByte;len:Word):Word;
var CRC,ShiftBit,Index:Word;
    Bit:Byte;
begin
    CRC := $ffff;
    for Index := 0 to len-1 do
    begin
        //CRC ^= (unsigned short)data[Index];
        CRC := CRC xor pBuf^; Inc(pBuf);
        for Bit := 0 to 7 do
        begin
            ShiftBit := CRC and $0001;
            CRC := CRC shr 1;
            if ( ShiftBit = 1 ) then
                CRC := CRC xor $a001;
        end;
    end;
    Result := CRC And $7F7F;
end;

function AsciiToByte(lpSrc:PByte;nSrcLen:Integer;lpDes:PByte):Word;
var hi,lo:Byte;
    ch:Char;
    i,nValue:Integer;
    p:PWord;
begin
    Result := nSrcLen div 2;
    p := @(lpSrc^);
    for i:=1 to Result do
    begin
        lo := p^ shr 0 and $ff;
        hi := p^ shr 8 and $ff;

        TryStrToInt('x'+chr(lo),nValue);
        lpDes^ := nValue shl 4;
        TryStrToInt('x'+chr(hi),nValue);
        lpDes^ := lpDes^ or nValue;
        
        Inc(p);
        Inc(lpDes);
    end;
end;

function ByteToAscii(lpSrc:PByte;nSrcLen:Integer;lpDes:PByte):Word;
var hi,lo:Byte;
    ch:Char;
    i:Integer;
begin
    //Inc(lpSrc,nSrcLen-1);
    for i:=1 to nSrcLen do
    begin
        lo := lpSrc^ shr 0 and $0f;
        hi := lpSrc^ shr 4 and $0f;
        lpDes^ := Ord(IntToHex(hi,1)[1]);
        Inc(lpDes);
        lpDes^ := Ord(IntToHex(lo,1)[1]);
        Inc(lpDes);
        //Inc(lpSrc,-1);
        Inc(lpSrc);
    end;
    Result := 2*nSrcLen;
end;

function RegisterOleFile(strOleFileName: STRING;OleAction: Byte): BOOLEAN;
const
  RegisterOle = 1;//注册
  UnRegisterOle = 0;//卸载
type
  TOleRegisterFunction = function : HResult;//注册或卸载函数的原型
var
  hLibraryHandle : THandle;//由LoadLibrary返回的DLL或OCX句柄
  hFunctionAddress: TFarProc;//DLL或OCX中的函数句柄,由GetProcAddress返回
  RegFunction : TOleRegisterFunction;//注册或卸载函数指针
begin
  Result := FALSE;
  //打开OLE/DCOM文件,返回的DLL或OCX句柄
  hLibraryHandle := LoadLibrary(PCHAR(strOleFileName));
  if (hLibraryHandle > 0) then//DLL或OCX句柄正确
  try
  //返回注册或卸载函数的指针
  if (OleAction = RegisterOle) then//返回注册函数的指针
  hFunctionAddress := GetProcAddress(hLibraryHandle, pchar('DllRegisterServer'))
  else//返回卸载函数的指针
  hFunctionAddress := GetProcAddress(hLibraryHandle, pchar('DllUnregisterServer'));
  if (hFunctionAddress <> NIL) then//注册或卸载函数存在
    begin
    RegFunction := TOleRegisterFunction(hFunctionAddress);//获取操作函数的指针
    if RegFunction >= 0 then //执行注册或卸载操作,返回值>=0表示执行成功
    result := true;
    end;
  finally
    FreeLibrary(hLibraryHandle);//关闭已打开的OLE/DCOM文件
  end;
end;

//UserDefine就是用户自定义的了，返回值保存在Info.UserDefineValue中
function GetFileVersionInfomation(const FileName:string;var info:TFileInfo;p_fixed_info:PVSFixedFileInfo;UserDefine:string=''):boolean;
const
    SFInfo=   '\StringFileInfo\';  
var
    VersionInfo:   Pointer;
    InfoSize:   DWORD;
    InfoPointer:   Pointer;
    Translation:   Pointer;
    VersionValue:   string;
    unused:   DWORD;
    VerValue: PVSFixedFileInfo;
begin
    unused   :=   0;  
    Result   :=   False;  
    InfoSize   :=   GetFileVersionInfoSize(pchar(FileName),   unused);  
    if   InfoSize   >   0   then  
    begin  
        GetMem(VersionInfo,   InfoSize);  
        Result   :=   GetFileVersionInfo(pchar(FileName),   0,   InfoSize,   VersionInfo);  
        if   Result   then  
        begin
            VerQueryValue(VersionInfo, '\', Pointer(VerValue), InfoSize);

            MoveMemory(p_fixed_info,VerValue,SizeOf(TVSFixedFileInfo));

            VerQueryValue(VersionInfo,   '\VarFileInfo\Translation',   Translation,   InfoSize);
            VersionValue   :=   SFInfo   +   IntToHex(LoWord(Longint(Translation^)),   4)   +  
                IntToHex(HiWord(Longint(Translation^)),   4)   +   '\';  
            VerQueryValue(VersionInfo,   pchar(VersionValue   +   'CompanyName'),   InfoPointer,   InfoSize);  
            info.CommpanyName   :=   string(pchar(InfoPointer));  
            VerQueryValue(VersionInfo,   pchar(VersionValue   +   'FileDescription'),   InfoPointer,   InfoSize);  
            info.FileDescription   :=   string(pchar(InfoPointer));  
            VerQueryValue(VersionInfo,   pchar(VersionValue   +   'FileVersion'),   InfoPointer,   InfoSize);  
            info.FileVersion   :=   string(pchar(InfoPointer));  
            VerQueryValue(VersionInfo,   pchar(VersionValue   +   'InternalName'),   InfoPointer,   InfoSize);  
            info.InternalName   :=   string(pchar(InfoPointer));  
            VerQueryValue(VersionInfo,   pchar(VersionValue   +   'LegalCopyright'),   InfoPointer,   InfoSize);  
            info.LegalCopyright   :=   string(pchar(InfoPointer));  
            VerQueryValue(VersionInfo,   pchar(VersionValue   +   'LegalTrademarks'),   InfoPointer,   InfoSize);  
            info.LegalTrademarks   :=   string(pchar(InfoPointer));  
            VerQueryValue(VersionInfo,   pchar(VersionValue   +   'OriginalFileName'),   InfoPointer,   InfoSize);  
            info.OriginalFileName   :=   string(pchar(InfoPointer));  
            VerQueryValue(VersionInfo,   pchar(VersionValue   +   'ProductName'),   InfoPointer,   InfoSize);  
            info.ProductName   :=   string(pchar(InfoPointer));  
            VerQueryValue(VersionInfo,   pchar(VersionValue   +   'ProductVersion'),   InfoPointer,   InfoSize);  
            info.ProductVersion   :=   string(pchar(InfoPointer));  
            VerQueryValue(VersionInfo,   pchar(VersionValue   +   'Comments'),   InfoPointer,   InfoSize);  
            info.Comments   :=   string(pchar(InfoPointer));  
            if   VerQueryValue(VersionInfo,   '\',   InfoPointer,   InfoSize)   then  
                info.VsFixedFileInfo   :=   TVSFixedFileInfo(InfoPointer^);  
            if   UserDefine<>''   then  
            begin  
                if   VerQueryValue(VersionInfo,pchar(VersionValue+UserDefine),InfoPointer,InfoSize)   then  
                    info.UserDefineValue:=string(pchar(InfoPointer));  
            end;  
        end;  
        FreeMem(VersionInfo);  
    end;
end;

//得到文件版本
function GetVersionString(FileName: string): string;
var
    VerInfoSize: DWORD;
    VerInfo: Pointer;
    VerValueSize: DWORD;
    Dummy: DWORD;
    VerValue: PVSFixedFileInfo;
begin
    Result := '';
    VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
    if VerInfoSize = 0 then Exit;
    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    Result := IntToStr(VerValue^.dwFileVersionMS shr 16) + '.' +
    IntToStr(VerValue^.dwFileVersionMS and $FFFF) + '.' +
    IntToStr(VerValue^.dwFileVersionLS shr 16) + '.' +
    IntToStr(VerValue^.dwFileVersionLS and $FFFF);
    FreeMem(VerInfo);
end;


function MyMessageBox(Handle:HWND; const Text, Caption: string; Flags: Longint = MB_OK): Integer;
begin
    Result := MessageBox(Handle,PChar(Text), PChar(Caption), Flags);
end;

function IsEqual(src1,src2:PByte;len:Integer):Boolean;
var i:Integer;
begin
    Result := False;
    for i:=1 to len do
    begin
        if src1^ <> src2^ then
            Exit;
        Inc(src1);
        Inc(src2);
    end;
    Result := True;
end;

function Delay(nMilliSeconds:Int64):Boolean;
var start:TDateTime;
begin
    if nMilliSeconds<=0 then Exit;
    Result := True;
    start := Now();
    while True do
    begin
        Application.ProcessMessages;
        if MilliSecondsBetween(Now(),start) >= nMilliSeconds then
        begin
            Break;
        end;
    end;
end;

function calccrc(crcbuf:Byte;crc:Word):Word;
var i,chk:Byte;
begin
    //ShowMessage(IntTohex(crcbuf,2));
		crc:=crc xor crcbuf;
		for i:=0 to 7 do
    begin
			chk:=crc and 1;
			crc:=crc shr 1;
			crc:=crc and $7fff;
			if (chk=1)then
      begin
        crc:=crc xor $a001;
      end;
			crc:=crc and $ffff;
    end;
    Result:=crc;;
end;
function chkcrc(buf:pByte;len:Word):Word;
var
    hi,lo:BYTE;
		i:Word;
		crc:Word;
begin
		crc:=$FFFF;
		for i:=0 to len-1 do
    begin
      crc:=calccrc(buf^,crc);
      Inc(buf);
    end;
    hi:=crc mod 256;
		lo:=crc div 256;
		crc:=(hi shl 8)or lo;
		Result:=crc;
end;

function split(s:string;dot:char):userarray;
var
  str:userarray;
  i,j:integer;
begin
  i:=1;
  j:=0;
  //SetLength(str, 255);
  while Pos(dot, s) > 0 do //Pos返回子串在父串中第一次出现的位置.
  begin
    SetLength(str, j+1);
    str[j]:=copy(s,i,pos(dot,s)-i);
    i:=pos(dot,s)+1;
    s[i-1] := chr(ord(dot)+1);
    j:=j+1;
  end;
  SetLength(str, j+1);
  str[j]:=copy(s,i,strlen(pchar(s))-i+1);
  result:=str;
end;

function GetSum(p:PByte;len:integer):byte;
var tmp:byte;
    i:integer;
begin
  tmp:=0;
  for i:=0 to len-1 do
  begin
    tmp:=tmp+p^;
    Inc(p);
  end;
  result:=tmp;
end;

function IntToBCD(src:integer):int64;
var tmp,nrt:int64;
begin
  nrt:=0;

  tmp := src div 100000000;
  nrt := (((tmp div 10)shl 36) + (tmp mod 10) shl 32) + nrt;
  tmp := src div 1000000 mod 100;
  nrt := (((tmp div 10)shl 28) + (tmp mod 10) shl 24) + nrt;
  tmp := src div 10000 mod 100;
  nrt := (((tmp div 10)shl 20) + (tmp mod 10) shl 16) + nrt;
  tmp := src div 100 mod 100;
  nrt := (((tmp div 10)shl 12) + (tmp mod 10) shl  8) + nrt;
  tmp := src mod 100;
  nrt := (((tmp div 10)shl  4) + (tmp mod 10) shl  0) + nrt;

  result:=nrt;

end;

function BCDToIntByte(src:Byte):Byte;
begin
    Result := (src shr 4)*10 + (src and $0f);
end;

function IntToHexnum(src:integer):integer;
var nrt:longword;
begin
  nrt:=0;
  nrt:= ((src shr 28)*16 and $0F)+((src shr 24)and$0F)shl 24;
  nrt:=(((src shr 20)*16 and $0F)+((src shr 16)and$0F)shl 16) + nrt;
  nrt:=(((src shr 12)*16 and $0F)+((src shr  8)and$0F)shl  8) + nrt;
  nrt:=(((src shr 4 )*16 and $0F)+((src shr 0 )and$0F)shl  0) + nrt;
  result:=nrt;
end;

end.


