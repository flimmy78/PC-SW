program Project;

uses
  Forms,
  U_MyFunction in '..\Common\U_MyFunction.pas',
  U_ComComm in '..\Common\U_ComComm.pas',
  U_Hex in '..\Common\U_Hex.pas',
  U_Disp in '..\Common\U_Disp.pas',
  U_Process in '..\Common\U_Process.pas',
  U_TcpClient in '..\Common\U_TcpClient.pas',
  U_TcpServer in '..\Common\U_TcpServer.pas',
  U_Multi in '..\Common\U_Multi.pas',
  U_Protocol in '..\Protocol\U_Protocol.pas',
  U_Protocol_mod in '..\Protocol\U_Protocol_mod.pas',
  U_Protocol_con in '..\Protocol\U_Protocol_con.pas',
  U_Protocol_645 in '..\Protocol\U_Protocol_645.pas',
  U_UpdateDev in '..\Protocol\U_UpdateDev.pas',
  U_Main in '..\Form\U_Main.pas' {F_Main},
  U_Update in '..\Form\U_Update.pas' {F_Update},
  U_ParamReadWrite in '..\Form\U_ParamReadWrite.pas' {F_ParamReadWrite},
  U_Debug in '..\Form\U_Debug.pas' {F_Debug},
  U_Operation in '..\Form\U_Operation.pas' {F_Operation},
  U_Frame in '..\Form\U_Frame.pas' {F_Frame},
  U_Sel_Protocol in '..\Form\U_Sel_Protocol.pas' {F_Sel_Protocol},
  U_Debug_Con in '..\Form\U_Debug_Con.pas' {F_Debug_Con},
  U_Param_Mod in '..\Form\U_Param_Mod.pas' {F_Param_Mod},
  U_Param_Con in '..\Form\U_Param_Con.pas' {F_Param_Con},
  U_Param_ChkMeter in '..\Form\U_Param_ChkMeter.pas' {F_Param_ChkMeter},
  U_Update_Con_Mod in '..\Form\U_Update_Con_Mod.pas' {F_Update_Con_Mod},
  U_Param_Con_Mod in '..\Form\U_Param_Con_Mod.pas' {F_Param_Con_Mod},
  U_Debug_Con_Mod in '..\Form\U_Debug_Con_Mod.pas' {F_Debug_Con_Mod},
  U_Container in '..\Form\U_Container.pas' {F_Container},
  U_DataModule in '..\Form\U_DataModule.pas' {F_DataModule},
  U_Status in '..\Form\U_Status.pas' {F_Status},
  U_SysCtrl in '..\Form\U_SysCtrl.pas' {F_SysCtrl},
  U_ParamChk in '..\Form\U_ParamChk.pas' {F_ParamChk},
  U_Rdt in '..\Form\U_Rdt.pas' {F_Rdt},
  U_Key in '..\Form\U_Key.pas' {F_Key},
  U_Temp in '..\Form\U_Temp.pas' {F_Temp},
  U_Noise in '..\Form\U_Noise.pas' {F_Noise},
  U_PDA in '..\Form\U_PDA.pas' {F_PDA},
  U_MEMS in '..\Form\U_MEMS.pas' {F_MEMS};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'PC-SW';
  Application.CreateForm(TF_Main, F_Main);
  Application.CreateForm(TF_Frame, F_Frame);
  Application.CreateForm(TF_Operation, F_Operation);
  Application.CreateForm(TF_DataModule, F_DataModule);
  Application.CreateForm(TF_Rdt, F_Rdt);
  Application.CreateForm(TF_Key, F_Key);
  Application.CreateForm(TF_Temp, F_Temp);
  Application.CreateForm(TF_Noise, F_Noise);
  Application.CreateForm(TF_PDA, F_PDA);
  Application.CreateForm(TF_MEMS, F_MEMS);
  Application.Run;
end.
