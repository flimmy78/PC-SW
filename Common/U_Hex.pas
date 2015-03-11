unit U_Hex;

interface

Uses Forms,ADODB,Dialogs,Messages,
     Windows, SysUtils, Variants, Classes, Graphics, Controls,
     DB, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls,Clipbrd,StrUtils;

procedure ShowMsgB(Msg: String);
function ReadAndCheckHexFile(strFileName:string):string;//合法返回数据串，不合法返回串'-1'
function LoadHexFile(strFileName:string;var pBuf:array of Byte;var pLen:Integer):Boolean;//成功返回True，失败返回False
function LoadBinFile(strFileName:string;var pBuf:array of Byte;var pLen:Integer):Boolean;//成功返回True，失败返回False
function CutFFFromEnd(pBuf:PByte;len:Integer):Integer;

implementation

function CutFFFromEnd(pBuf:PByte;len:Integer):Integer;
var i:Integer;
begin
    Inc(pBuf,len-1);
    for i:=len-1 downto 0 do
    begin
        if pBuf^<>$ff then Break;
        if (i<len-1)and(i mod 1024 = 0) then
        begin
            Inc(len,-1024);
        end;
        Inc(pBuf,-1);
    end;
    Result := len;
end;

procedure ShowMsgB(Msg: String);
begin
  MessageBox(Application.Handle, pchar(Msg),pchar('提示！'), MB_OK + MB_ICONWARNING);
end;

function ReadAndCheckHexFile(strFileName:string):string;//合法返回数据串，不合法返回串'-1'
var FText:TextFile;
    i,LenInt,old_inttype,inttype,oldLenInt:integer;
    new_addr,old_addr,sline,HexStr,xcsender:string;//new_seg_addr,old_seg_addr,
    label endto;
begin
    old_addr := '0';
    new_addr := '0';
    LenInt := 0;
    oldLenInt := 0;
    xcsender := '';
    //new_seg_addr:='1';
    //old_seg_addr:='2';i:=0;
    AssignFile(FText,strFileName);//打开外部盘点单文件
    Reset(FText);
    Application.ProcessMessages;
    while not eof( Ftext) do
    begin
        inc(i);
        ReadLn(Ftext,sline);
        //每行记录合法性
        //第一个字符应为冒号":"
        //if leftstr(sline,1)<>':' then
        if copy(sline,1,1)<>':' then
        begin
          if length(sline)=0 then
          begin
             ShowMsgB(strFileName+'文件中含有空行!');
             result:='-1';CloseFile(FText);exit;
          end;
          ShowMsgB(strFileName+'文件中内容非法!');
          result:='-1';CloseFile(FText);exit;
        end;
        //冒号后开始
        new_addr:= copy(sline,4,4);//new_addr:= midstr(sline,4,4);//地址;
        LenInt := strtoint('$'+copy(sline,2,2)); //LenInt := strtoint('$'+midstr(sline,2,2));//[长度域]一个字节
        HexStr := copy(sline,10,LenInt*2);//HexStr := midstr(sline,10,LenInt*2);//[数据域]
        inttype := strtoint('$'+copy(sline,8,2));//inttype := strtoint('$'+midstr(sline,8,2));//文件类型
      
        //if (LenInt=0) and (inttype<>0) then
        if (LenInt=0) or (inttype<>0) then
        begin
            //outputdebugstring(pchar('goto endto'));
            goto endto;
        end;
        //if (strtoint('$'+new_addr)<>strtoint('$'+old_addr)+oldLenInt) and (old_addr<>'0') then
        if (strtoint('$'+new_addr)<>strtoint('$'+old_addr)+oldLenInt) and (old_addr<>'0') and (old_inttype<>$02)and (inttype<>$02) then // and (old_seg_addr=new_seg_addr)
        begin
            //outputdebugstring(pchar('地址不连续:'+'第'+inttostr(i)+'行'+sline));
            ShowMsgB('文件中内容非法!地址不连续！');
            result:='-1';CloseFile(FText);exit;
        end;
        //outputdebugstring(pchar(sline));
        xcsender := xcsender + HexStr;
     endto:
        //outputdebugstring(pchar('endto:'));
        oldLenInt := LenInt;
        old_addr := new_addr;
        //old_seg_addr:=new_seg_addr;
        old_inttype:=inttype;
        //result:=result+sline;//RichEdit1.Lines.Add(sline);   //保存字符串
    end; //while not eof( Ftext) do
    CloseFile(FText);
    result:=xcsender;
end;

function LoadBinFile(strFileName:string;var pBuf:array of Byte;var pLen:Integer):Boolean;//成功返回True，失败返回False
var FileStream:TFileStream;
    p:PByte;
    nRead:Integer;
    buf:array[0..127] of Byte;
begin
    p := @pBuf[Low(pBuf)];
    Result := False;

    FileStream := TFileStream.Create(strFileName,fmOpenRead);
    FileStream.Position := 0;

    while True do
    begin
        nRead := FileStream.Read(buf,SizeOf(buf));
        if nRead>0 then
        begin
            MoveMemory(p, @buf[0], nRead);
            Inc(p,nRead);
        end
        else
            Break;
    end;

    pLen := Integer(p) - Integer(@pBuf[Low(pBuf)]);
    Result := True;

    FileStream.Free;
end;

function LoadHexFile(strFileName:string;var pBuf:array of Byte;var pLen:Integer):Boolean;//成功返回True，失败返回False
var FText:TextFile;
    i,LenInt,old_inttype,inttype,oldLenInt:integer;
    new_addr,old_addr,sline,HexStr,xcsender:string;//new_seg_addr,old_seg_addr,
    p:PByte;
    label endto;

begin
    p := @pBuf[Low(pBuf)];

    Result := False;

    old_addr := '0';
    new_addr := '0';
    LenInt := 0;
    oldLenInt := 0;
    //new_seg_addr:='1';
    //old_seg_addr:='2';i:=0;
    AssignFile(FText,strFileName);//打开外部盘点单文件
    Reset(FText);
    Application.ProcessMessages;
    while not eof( Ftext) do
    begin
        //inc(i);
        ReadLn(Ftext,sline);
        //每行记录合法性
        //第一个字符应为冒号":"
        //if leftstr(sline,1)<>':' then
        if copy(sline,1,1)<>':' then
        begin
            if length(sline)=0 then
            begin
               ShowMsgB(strFileName+'文件中含有空行!');
               CloseFile(FText);exit;
            end;
            ShowMsgB(strFileName+'文件中内容非法!');
            CloseFile(FText);exit;
        end;
        //冒号后开始
        new_addr:= copy(sline,4,4);//new_addr:= midstr(sline,4,4);//地址;
        LenInt := strtoint('$'+copy(sline,2,2)); //LenInt := strtoint('$'+midstr(sline,2,2));//[长度域]一个字节
        HexStr := copy(sline,10,LenInt*2);//HexStr := midstr(sline,10,LenInt*2);//[数据域]
        inttype := strtoint('$'+copy(sline,8,2));//inttype := strtoint('$'+midstr(sline,8,2));//文件类型
      
        //if (LenInt=0) and (inttype<>0) then
        if (LenInt=0) or (inttype<>0) then
        begin
            //outputdebugstring(pchar('goto endto'));
            goto endto;
        end;
        //if (strtoint('$'+new_addr)<>strtoint('$'+old_addr)+oldLenInt) and (old_addr<>'0') then
        {
        if (strtoint('$'+new_addr)<>strtoint('$'+old_addr)+oldLenInt) and (old_addr<>'0') and (old_inttype<>$02)and (inttype<>$02) then // and (old_seg_addr=new_seg_addr)
        begin
            //outputdebugstring(pchar('地址不连续:'+'第'+inttostr(i)+'行'+sline));
            ShowMsgB('文件中内容非法!地址不连续！');
            CloseFile(FText);exit;
        end;
        }
        //outputdebugstring(pchar(sline));
        //xcsender := xcsender + HexStr;
        pLen := Length(HexStr) div 2;
        for i:=1 to pLen do
        begin
            p^ := StrToInt('x'+Copy(HexStr,i*2-1,2));
            Inc(p);
            //outputdebugstring(pchar( IntToStr(Integer(p) - Integer(@pBuf[Low(pBuf)]))));
        end;
     endto:
        //outputdebugstring(pchar('endto:'));
        oldLenInt := LenInt;
        old_addr := new_addr;
        //old_seg_addr:=new_seg_addr;
        old_inttype:=inttype;
        //result:=result+sline;//RichEdit1.Lines.Add(sline);   //保存字符串
    end; //while not eof( Ftext) do
    CloseFile(FText);
    //result:=xcsender;
    pLen := Integer(p) - Integer(@pBuf[Low(pBuf)]);
    Result := True;

end;

end.
