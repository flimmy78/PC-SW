unit U_Languages;
{$I MySet.inc}
interface
uses
  IniFiles,StdCtrls,ExtCtrls,Menus,ActnList,
  SysUtils,Classes,Controls,Forms,Dialogs,ComCtrls,CRGrid,TypInfo,

  Windows, Messages, Variants, Graphics, 

  dbcgrids, Grids, DBGrids,ChkEdit,
  Buttons, DB, MemDS, DBAccess;//, Ora

const
    lang_cn = 0;
    lang_en = 1;    

type strArray=array of string;
type strArray1=array[0..1] of string;

type TBufIndexEnum=(
        en_buf_result_name,
        en_buf_result_num,
        en_buf_result_rate,
        en_buf_ten_name,
        en_buf_end
    );
var BufPointerArray:array[low(TBufIndexEnum)..high(TBufIndexEnum)] of Pointer;//用于管理数组的指针，以便生产多语言文件
var BufPointerLowHigh:array[0..1,low(TBufIndexEnum)..high(TBufIndexEnum)] of Integer;//
var
    languagefile:string='.\lanuage\lanuage.ini';
    languagefile_cn:string='.\lanuage\lanuage_cn.ini';
    languagefile_en:string='.\lanuage\lanuage_en.ini';

type TMsgIndexEnum=(
  //*******************messagebox提示*************************//
    en_MsgBegin,

    en_tip,//提示
    en_period_n,//第%d时段
    en_timezone_n,//第%d时区
    en_holiday_n,//第%d公共假日
    en_hour,//时
    en_minute,//分
    en_tariff_no,//费率号
    en_month,//月
    en_day,//日
    en_period_no,//时段表号
    en_meter_no,//表号
    en_operation,//操作
    en_result,//结果
    en_time,//时间
    en_resp_ok,//正常应答
    en_resp_error,//异常应答
    en_resp_timeout,//应答超时
        
    en_MsgEnd
               );
var msgArray:array[low(TMsgIndexEnum)..high(TMsgIndexEnum)] of string;
//procedure SetMsgArray();

function Msg(index:TMsgIndexEnum):string;

function SetLanguage(const FileName:string;var msg:array of string;Handle:HWND=INVALID_HANDLE_VALUE;const IgnoreTagValue:byte=$FF):Boolean;

implementation

function Msg(index:TMsgIndexEnum):string;
begin
    Result := '';
    if (index>en_MsgBegin) and (index<en_MsgEnd) then
    begin
        Result := msgArray[index];
    end;
end;

{****************************************
  *   模块说明：利用切换INI切换语言函数*
  *   作者：Kingron@163.net   *
  ****************************************}
  {****************************************
  下面的编译指定表示是否导出成一个INI文件
  一般的情况下面，没有必要修改，但需要母本
  INI的时候，可以把注释去掉
  ****************************************}
  //{$IFNDEF   INI_EXPORT}
  //{$DEFINE   INI_EXPORT}
  //{$ENDIF}
  {****************************************
  函数参数说明：
  FileName:Ini语言文件名
  msg:用于程序中的信息的保存数组
  IgnoreTagValue:需要忽略的组件的Tag值
  使用举例：
  var
  Msg:array   of   string;
  .....
  SetLanguage(ExtractFilePath(ParamStr(0))+'English.Ini',msg,$FF);
  那么函数会忽略所有Tag值为$FF的控件
  Handle=INVALID_HANDLE_VALUE时，只导出或导入当前窗口的界面值
  ****************************************}
//procedure SetLanguage(const FileName:string;var msg:array of string;const IgnoreTagValue:byte=$FF);
function SetLanguage(const FileName:string;var msg:array of string;Handle:HWND=INVALID_HANDLE_VALUE;const IgnoreTagValue:byte=$FF):Boolean;
const
	//下面是一些常量
	TRANS_SECTION='Translations';
	MESSAGES='Messages';
  BUF_ARRAY='BufArray';
	COMMON='Common';
	HINT='Hint';
	CAPTION='Caption';
	MSG_PRE='SS_Msg_';
	BUF_ARRAY_PRE='Buf_Array_';
var
	i,j,k:integer;
	Component:TComponent;
	Control:TControl;
	Strings:TStrings;
	Id:string;
	OldCaption:pchar;
	L:integer;
  nItemIndex:integer;
  pt,pt1:PTypeInfo;
  ii:TBufIndexEnum;
begin
    pt:=TypeInfo(TMsgIndexEnum);
    pt1:=TypeInfo(TBufIndexEnum);
    with TIniFile.Create(FileName) do
    begin
        try
            Result:=False;
            {$IFDEF   INI_EXPORT}
              if Application.Title<>''then WriteString(COMMON,'Application.Title',Application.Title);
                WriteBool(COMMON,'CheckValid',True);
            {$ELSE}
              if not ReadBool(COMMON,'CheckValid',False)then exit;   //不是合法的语言文件
                Application.Title:=ReadString(COMMON,'Application.Title',Application.Title);
            {$ENDIF}
            Result:=True;
            if Handle=INVALID_HANDLE_VALUE then
            begin

                for i:=Low(msg) to High(msg)do   ///读取非控件的一些语言元素
                  {$IFDEF   INI_EXPORT}
                    if Msg[i]<>''then
                    //WriteString(MESSAGES,MSG_PRE+IntToStr(i),msg[i]);
                    WriteString(MESSAGES,MSG_PRE+GetEnumName(pt,i),msg[i]);
                  {$ELSE}
                    //msg[i]:=ReadString(MESSAGES,MSG_PRE+IntToStr(i),msg[i]);
                    msg[i]:=ReadString(MESSAGES,MSG_PRE+GetEnumName(pt,i),msg[i]);
                  {$ENDIF}

                for ii:=Low(BufPointerArray) to High(BufPointerArray) do
                begin
                    if BufPointerArray[ii]<>nil then
                    begin
                        for k:=BufPointerLowHigh[0,ii] to BufPointerLowHigh[1,ii] do
                        begin
                            {$IFDEF   INI_EXPORT}
                              WriteString(BUF_ARRAY,BUF_ARRAY_PRE+GetEnumName(pt1,Ord(ii))+'_'+IntToStr(k),strArray(BufPointerArray[ii])[k]);
                            {$ELSE}
                              strArray(BufPointerArray[ii])[k]:=
                              ReadString (BUF_ARRAY,BUF_ARRAY_PRE+GetEnumName(pt1,Ord(ii))+'_'+IntToStr(k),strArray(BufPointerArray[ii])[k]);
                            {$ENDIF}
                        end;

                    end;
                end;

            end;



            for i:=0 to Screen.FormCount-1 do   ///遍历程序所有窗体
            begin
                if Handle<>INVALID_HANDLE_VALUE then
                begin
                    if Screen.Forms[i].Handle<> Handle then
                        Continue;
                end;
                {$IFDEF   INI_EXPORT}
                  if Screen.Forms[i].Caption<>'' then
                    WriteString(TRANS_SECTION,Screen.Forms[i].Name+'.'+CAPTION,Screen.Forms[i].Caption);
                  if Screen.Forms[i].Hint<>''then
                    WriteString(TRANS_SECTION,Screen.Forms[i].Name+'.'+HINT,Screen.Forms[i].Hint);
                {$ELSE}
                  Screen.Forms[i].Caption:=ReadString(TRANS_SECTION,Screen.Forms[i].Name+'.'+CAPTION,Screen.Forms[i].Caption);
                  Screen.Forms[i].Hint:=ReadString(TRANS_SECTION,Screen.Forms[i].Name+'.'+HINT,Screen.Forms[i].Hint);
                {$ENDIF}
                for j:=0 to Screen.Forms[i].ComponentCount-1 do   ///遍历窗体所有组件
                begin
                    Component:=Screen.Forms[i].Components[j]as TComponent;
                    if Component.Tag=IgnoreTagValue then Continue;   ///需要忽略的控件
                    Id:=Screen.Forms[i].Name+'.'+Component.Name+'.';
                    if Component is TCRDBGrid then
                    begin
                        for k:=0 to TCRDBGrid(Component).Columns.Count-1 do
                        begin
                            {$IFDEF   INI_EXPORT}
                              WriteString(TRANS_SECTION,Id+Format('Columns[%d].Title.Caption',[k]),TCRDBGrid(Component).Columns[k].Title.Caption);
                            {$ELSE}
                              TCRDBGrid(Component).Columns[k].Title.Caption:=ReadString(TRANS_SECTION,Id+Format('Columns[%d].Title.Caption',[k]),TCRDBGrid(Component).Columns[k].Title.Caption);
                            {$ENDIF}
                        end;
                    end;
                    if Component is TChkEdit then
                    begin
                        {$IFDEF   INI_EXPORT}
                          WriteString(TRANS_SECTION,Id+Format('ChkCaption',[]),TChkEdit(Component).ChkCaption);
                        {$ELSE}
                          TChkEdit(Component).ChkCaption:=ReadString(TRANS_SECTION,Id+Format('ChkCaption',[]),TChkEdit(Component).ChkCaption);
                        {$ENDIF}                        
                    end;
                    if Component is TControl then///普通的控件如：TButton,TSpeedButton,TBitBtn,TCheckBox....
                    begin
                        Control:=Component as TControl;
                        ///   下面的代码是用来生成第一个INI文件使用的
                        {$IFDEF   INI_EXPORT}
                          if Control.Hint<>'' then
                            WriteString(TRANS_SECTION,Id+HINT,Control.Hint);
                        {$ELSE}
                          Control.Hint:=ReadString(TRANS_SECTION,Id+HINT,Control.Hint);
                        {$ENDIF}
                        if Control is TCustomEdit then Continue;   ///忽略TMemo,TEdit之类的
                        if(Component is TCustomListBox)or(Component is TCustomRadioGroup)or(Component is TCustomComboBox)then   ///   Listbox,RadioGroup,Combobox必须单独处理
                        begin
                          Strings:=nil;   ///本行用于忽略编译信息
                          if Component is TCustomListBox then Strings:=TCustomListBox(Component).Items;
                          if Component is TCustomRadioGroup then Strings:=TRadioGroup(Component).Items;
                          if Component is TCustomComboBox then
                          begin
                            Strings:=TCustomComboBox(Component).Items;
                            nItemIndex:=TCustomComboBox(Component).ItemIndex;
                            //showmessage(inttostr(nItemIndex));
                          end;
                          for k:=0 to Strings.Count-1 do   ///遍历Items的每一项
                            {$IFDEF   INI_EXPORT}
                              WriteString(TRANS_SECTION,   ID   +   'Items.'   +   IntToStr(k),   Strings.Strings[k]);
                            {$ELSE}
                              Strings.Strings[k]:=ReadString(TRANS_SECTION,   ID   +   'Items.'   +   IntToStr(k),   Strings.Strings[k]);
                            {$ENDIF}
                          if Component is TCustomComboBox then
                          begin
                            TCustomComboBox(Component).ItemIndex:=nItemIndex;
                          end;

                        end;//if(Component is TCustomListBox)or(Component is TCustomRadioGroup)or(Component is TCustomComboBox)then   ///   Listbox,RadioGroup,Combobox必须单独处理
                        if Control is TStatusBar then
                        begin
                            for k:=0 to TStatusBar(Control).Panels.Count-1 do
                            begin
                              {$IFDEF   INI_EXPORT}
                                WriteString(TRANS_SECTION,ID+'Panels['+inttostr(k)+'].Text',TStatusBar(Control).Panels[k].Text);
                              {$ELSE}
                                TStatusBar(Control).Panels[k].Text:=ReadString(TRANS_SECTION,ID+'Panels['+inttostr(k)+'].Text',TStatusBar(Control).Panels[k].Text);
                              {$ENDIF}
                            end;
                        end;//if Component is TStatusBar then

                        if Component is TCustomComboBox then Continue;   ///Combobox还有一点儿问题，:-(
                        L:=Control.GetTextLen+1;
                        GetMem(OldCaption,L);
                        Control.GetTextBuf(OldCaption,L);
                        {$IFDEF   INI_EXPORT}
                          if StrPas(OldCaption)<>''then
                            WriteString(TRANS_SECTION,   Id   +   CAPTION,   OldCaption);
                        {$ELSE}
                          Control.SetTextBuf(pchar(ReadString(TRANS_SECTION,   Id   +   CAPTION,   OldCaption)));
                        {$ENDIF}
                        FreeMem(OldCaption,   L);
                        continue;
                    end;//if Component is TControl then///普通的控件如：TButton,TSpeedButton,TBitBtn,TCheckBox....
                    if Component is TMenuItem then   ///   处理TMenuItem
                    begin
                        {$IFDEF   INI_EXPORT}
                        if(TMenuItem(Component).Caption<>'')and(TMenuItem(Component).Caption<>'-')then
                          WriteString(TRANS_SECTION,Id+CAPTION,TMenuItem(Component).Caption);
                        if TMenuItem(Component).Hint<>''then
                          WriteString(TRANS_SECTION,Id+HINT,TMenuItem(Component).Hint);
                        {$ELSE}
                        TMenuItem(Component).Caption   :=   ReadString(TRANS_SECTION,   ID   +   CAPTION,   TMenuItem(Component).Caption);
                        TMenuItem(Component).Hint   :=   ReadString(TRANS_SECTION,   ID   +   HINT,   TMenuItem(Component).Hint);
                        {$ENDIF}
                        Continue;
                    end;//if Component is TMenuItem then   ///   处理TMenuItem
                    if Component is TCustomAction then///   处理TAction
                    begin
                        {$IFDEF   INI_EXPORT}
                        if TCustomAction(Component).Caption<>''then
                          WriteString(TRANS_SECTION,   Id   +   CAPTION,   TCustomAction(Component).Caption);
                        if TCustomAction(Component).Hint<>''   then
                          WriteString(TRANS_SECTION,   Id   +   HINT,   TCustomAction(Component).Hint);
                        {$ELSE}
                        TCustomAction(Component).Caption   :=   ReadString(TRANS_SECTION,   CAPTION,   TCustomAction(Component).Caption);
                        TCustomAction(Component).Hint   :=   ReadString(TRANS_SECTION,   ID   +   HINT,   TCustomAction(Component).Hint);
                        {$ENDIF}
                        Continue;
                    end;//if Component is TCustomAction then///   处理TAction  
                    if Component is TOpenDialog then   ///处理TOpenDialog,TSaveDialog,....
                    begin
                      {$IFDEF   INI_EXPORT}
                        if TOpenDialog(Component).Filter<>''then
                          WriteString(TRANS_SECTION,   Id   +   'Filter',   TOpenDialog(Component).Filter);
                        if TOpenDialog(Component).Title<>''then
                          WriteString(TRANS_SECTION,   Id   +   'Title',   TOpenDialog(Component).Title);
                      {$ELSE}
                        TOpenDialog(Component).Filter   :=   ReadString(TRANS_SECTION,   ID   +   HINT,   TOpenDialog(Component).Filter);
                        TOpenDialog(Component).Title   :=   ReadString(TRANS_SECTION,   CAPTION,   TOpenDialog(Component).Title);
                      {$ENDIF}
                    end;//if Component is TOpenDialog then   ///处理TOpenDialog,TSaveDialog,....

                end;//for j:=0 to Screen.Forms[i].ComponentCount-1 do   ///遍历窗体所有组件
            end;//for i:=0 to Screen.FormCount-1 do   ///遍历程序所有窗体
			
        finally
          Free;
        end;//try
    end;//with TIniFile.Create(FileName) do
end;//procedure SetLanguage(const FileName:string;var msg:array of string;const IgnoreTagValue:byte=$FF);


end.
