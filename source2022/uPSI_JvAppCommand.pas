unit uPSI_JvAppCommand;
{
  command struct
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_JvAppCommand = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvAppCommand(CL: TPSPascalCompiler);
procedure SIRegister_JvAppCommand(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvAppCommand_Routines(S: TPSExec);
procedure RIRegister_TJvAppCommand(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvAppCommand(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  //Messages
  //,Controls
  //Forms
  JvComponentBase
  ,JvAppCommand
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvAppCommand]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAppCommand(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvAppCommand') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvAppCommand') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('OnAppCommand', 'TJvAppCommandEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvAppCommand(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('WM_APPCOMMAND','LongWord').SetUInt( $0319);
 CL.AddConstantN('APPCOMMAND_BROWSER_BACKWARD','LongInt').SetInt( 1);
 CL.AddConstantN('APPCOMMAND_BROWSER_FORWARD','LongInt').SetInt( 2);
 CL.AddConstantN('APPCOMMAND_BROWSER_REFRESH','LongInt').SetInt( 3);
 CL.AddConstantN('APPCOMMAND_BROWSER_STOP','LongInt').SetInt( 4);
 CL.AddConstantN('APPCOMMAND_BROWSER_SEARCH','LongInt').SetInt( 5);
 CL.AddConstantN('APPCOMMAND_BROWSER_FAVORITES','LongInt').SetInt( 6);
 CL.AddConstantN('APPCOMMAND_BROWSER_HOME','LongInt').SetInt( 7);
 CL.AddConstantN('APPCOMMAND_VOLUME_MUTE','LongInt').SetInt( 8);
 CL.AddConstantN('APPCOMMAND_VOLUME_DOWN','LongInt').SetInt( 9);
 CL.AddConstantN('APPCOMMAND_VOLUME_UP','LongInt').SetInt( 10);
 CL.AddConstantN('APPCOMMAND_MEDIA_NEXTTRACK','LongInt').SetInt( 11);
 CL.AddConstantN('APPCOMMAND_MEDIA_PREVIOUSTRACK','LongInt').SetInt( 12);
 CL.AddConstantN('APPCOMMAND_MEDIA_STOP','LongInt').SetInt( 13);
 CL.AddConstantN('APPCOMMAND_MEDIA_PLAY_PAUSE','LongInt').SetInt( 14);
 CL.AddConstantN('APPCOMMAND_LAUNCH_MAIL','LongInt').SetInt( 15);
 CL.AddConstantN('APPCOMMAND_LAUNCH_MEDIA_SELECT','LongInt').SetInt( 16);
 CL.AddConstantN('APPCOMMAND_LAUNCH_APP1','LongInt').SetInt( 17);
 CL.AddConstantN('APPCOMMAND_LAUNCH_APP2','LongInt').SetInt( 18);
 CL.AddConstantN('APPCOMMAND_BASS_DOWN','LongInt').SetInt( 19);
 CL.AddConstantN('APPCOMMAND_BASS_BOOST','LongInt').SetInt( 20);
 CL.AddConstantN('APPCOMMAND_BASS_UP','LongInt').SetInt( 21);
 CL.AddConstantN('APPCOMMAND_TREBLE_DOWN','LongInt').SetInt( 22);
 CL.AddConstantN('APPCOMMAND_TREBLE_UP','LongInt').SetInt( 23);
 CL.AddConstantN('APPCOMMAND_MICROPHONE_VOLUME_MUTE','LongInt').SetInt( 24);
 CL.AddConstantN('APPCOMMAND_MICROPHONE_VOLUME_DOWN','LongInt').SetInt( 25);
 CL.AddConstantN('APPCOMMAND_MICROPHONE_VOLUME_UP','LongInt').SetInt( 26);
 CL.AddConstantN('APPCOMMAND_HELP','LongInt').SetInt( 27);
 CL.AddConstantN('APPCOMMAND_FIND','LongInt').SetInt( 28);
 CL.AddConstantN('APPCOMMAND_NEW','LongInt').SetInt( 29);
 CL.AddConstantN('APPCOMMAND_OPEN','LongInt').SetInt( 30);
 CL.AddConstantN('APPCOMMAND_CLOSE','LongInt').SetInt( 31);
 CL.AddConstantN('APPCOMMAND_SAVE','LongInt').SetInt( 32);
 CL.AddConstantN('APPCOMMAND_PRINT','LongInt').SetInt( 33);
 CL.AddConstantN('APPCOMMAND_UNDO','LongInt').SetInt( 34);
 CL.AddConstantN('APPCOMMAND_REDO','LongInt').SetInt( 35);
 CL.AddConstantN('APPCOMMAND_COPY','LongInt').SetInt( 36);
 CL.AddConstantN('APPCOMMAND_CUT','LongInt').SetInt( 37);
 CL.AddConstantN('APPCOMMAND_PASTE','LongInt').SetInt( 38);
 CL.AddConstantN('APPCOMMAND_REPLY_TO_MAIL','LongInt').SetInt( 39);
 CL.AddConstantN('APPCOMMAND_FORWARD_MAIL','LongInt').SetInt( 40);
 CL.AddConstantN('APPCOMMAND_SEND_MAIL','LongInt').SetInt( 41);
 CL.AddConstantN('APPCOMMAND_SPELL_CHECK','LongInt').SetInt( 42);
 CL.AddConstantN('APPCOMMAND_DICTATE_OR_COMMAND_CONTROL_TOGGLE','LongInt').SetInt( 43);
 CL.AddConstantN('APPCOMMAND_MIC_ON_OFF_TOGGLE','LongInt').SetInt( 44);
 CL.AddConstantN('APPCOMMAND_CORRECTION_LIST','LongInt').SetInt( 45);
 CL.AddConstantN('APPCOMMAND_MEDIA_PLAY','LongInt').SetInt( 46);
 CL.AddConstantN('APPCOMMAND_MEDIA_PAUSE','LongInt').SetInt( 47);
 CL.AddConstantN('APPCOMMAND_MEDIA_RECORD','LongInt').SetInt( 48);
 CL.AddConstantN('APPCOMMAND_MEDIA_FAST_FORWARD','LongInt').SetInt( 49);
 CL.AddConstantN('APPCOMMAND_MEDIA_REWIND','LongInt').SetInt( 50);
 CL.AddConstantN('APPCOMMAND_MEDIA_CHANNEL_UP','LongInt').SetInt( 51);
 CL.AddConstantN('APPCOMMAND_MEDIA_CHANNEL_DOWN','LongInt').SetInt( 52);
 CL.AddConstantN('MK_LBUTTON','LongWord').SetUInt( $0001);
 CL.AddConstantN('MK_RBUTTON','LongWord').SetUInt( $0002);
 CL.AddConstantN('MK_SHIFT','LongWord').SetUInt( $0004);
 CL.AddConstantN('MK_CONTROL','LongWord').SetUInt( $0008);
 CL.AddConstantN('MK_MBUTTON','LongWord').SetUInt( $0010);
 CL.AddConstantN('MK_XBUTTON1','LongWord').SetUInt( $0020);
 CL.AddConstantN('MK_XBUTTON2','LongWord').SetUInt( $0040);
  CL.AddTypeS('TJvAppCommandDevice', '( acdKey, acdMouse, acdOEM )');
  CL.AddTypeS('TJvAppCommandEvent', 'Procedure ( Handle : THandle; Cmd : WORD; '
   +'Device : TJvAppCommandDevice; KeyState : WORD; var Handled : Boolean)');
  SIRegister_TJvAppCommand(CL);
 CL.AddDelphiFunction('Function GET_APPCOMMAND_LPARAM( lParam : LPARAM) : WORD');
 CL.AddDelphiFunction('Function GET_DEVICE_LPARAM( lParam : LPARAM) : WORD');
 CL.AddDelphiFunction('Function GET_KEYSTATE_LPARAM( lParam : LPARAM) : WORD');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvAppCommandOnAppCommand_W(Self: TJvAppCommand; const T: TJvAppCommandEvent);
begin Self.OnAppCommand := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppCommandOnAppCommand_R(Self: TJvAppCommand; var T: TJvAppCommandEvent);
begin T := Self.OnAppCommand; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppCommandActive_W(Self: TJvAppCommand; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppCommandActive_R(Self: TJvAppCommand; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvAppCommand_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GET_APPCOMMAND_LPARAM, 'GET_APPCOMMAND_LPARAM', cdRegister);
 S.RegisterDelphiFunction(@GET_DEVICE_LPARAM, 'GET_DEVICE_LPARAM', cdRegister);
 S.RegisterDelphiFunction(@GET_KEYSTATE_LPARAM, 'GET_KEYSTATE_LPARAM', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAppCommand(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAppCommand) do begin
    RegisterConstructor(@TJvAppCommand.Create, 'Create');
    RegisterMethod(@TJvAppCommand.Destroy, 'Free');
    RegisterPropertyHelper(@TJvAppCommandActive_R,@TJvAppCommandActive_W,'Active');
    RegisterPropertyHelper(@TJvAppCommandOnAppCommand_R,@TJvAppCommandOnAppCommand_W,'OnAppCommand');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvAppCommand(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvAppCommand(CL);
end;

 
 
{ TPSImport_JvAppCommand }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAppCommand.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvAppCommand(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAppCommand.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvAppCommand(ri);
  RIRegister_JvAppCommand_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
