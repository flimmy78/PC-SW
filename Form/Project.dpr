program Project;

uses
  Forms,
  U_Main in 'U_Main.pas' {F_Main},
  U_MyFunction in '..\Common\U_MyFunction.pas',
  U_ComComm in '..\Common\U_ComComm.pas',
  U_Protocol in '..\Protocol\U_Protocol.pas',
  U_Update in 'U_Update.pas' {F_Update},
  U_Hex in '..\Common\U_Hex.pas',
  U_ParseFrame in 'U_ParseFrame.pas',
  U_ParamReadWrite in 'U_ParamReadWrite.pas' {F_ParamReadWrite},
  U_Debug in 'U_Debug.pas' {F_Debug},
  U_Operation in 'U_Operation.pas' {F_Operation},
  U_Frame in 'U_Frame.pas' {F_Frame},
  U_Protocol_mod in '..\Protocol\U_Protocol_mod.pas',
  U_Protocol_con in '..\Protocol\U_Protocol_con.pas',
  U_Sel_Protocol in 'U_Sel_Protocol.pas' {F_Sel_Protocol},
  U_Debug_Con in 'U_Debug_Con.pas' {F_Debug_Con},
  U_Param_Mod in 'U_Param_Mod.pas' {F_Param_Mod},
  U_Param_Con in 'U_Param_Con.pas' {F_Param_Con},
  U_Protocol_645 in '..\Protocol\U_Protocol_645.pas',
  U_Param_ChkMeter in 'U_Param_ChkMeter.pas' {F_Param_ChkMeter},
  U_Update_Con_Mod in 'U_Update_Con_Mod.pas' {F_Update_Con_Mod},
  U_Param_Con_Mod in 'U_Param_Con_Mod.pas' {F_Param_Con_Mod},
  U_UpdateDev in '..\Protocol\U_UpdateDev.pas',
  U_Debug_Con_Mod in 'U_Debug_Con_Mod.pas' {F_Debug_Con_Mod},
  U_Disp in '..\Common\U_Disp.pas',
  U_Process in '..\Common\U_Process.pas',
  U_Container in 'U_Container.pas' {F_Container},
  U_TcpClient in '..\Common\U_TcpClient.pas',
  U_TcpServer in '..\Common\U_TcpServer.pas',
  U_DataModule in 'U_DataModule.pas' {F_DataModule: TDataModule},
  U_Status in 'U_Status.pas' {F_Status},
  U_SysCtrl in 'U_SysCtrl.pas' {F_SysCtrl},
  U_ParamChk in 'U_ParamChk.pas' {F_ParamChk},
  U_Rdt in 'U_Rdt.pas' {F_Rdt},
  U_Multi in 'U_Multi.pas',
  U_Key in 'U_Key.pas' {F_Key},
  U_Temp in 'U_Temp.pas' {F_Temp},
  U_Noise in 'U_Noise.pas' {F_Noise};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Delphi';
  Application.CreateForm(TF_Main, F_Main);
  Application.CreateForm(TF_Key, F_Key);
  Application.CreateForm(TF_Temp, F_Temp);
  Application.CreateForm(TF_Noise, F_Noise);
  Application.Run;
end.
