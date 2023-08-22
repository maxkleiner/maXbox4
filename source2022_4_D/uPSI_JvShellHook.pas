unit uPSI_JvShellHook;
{
   shell bell
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
  TPSImport_JvShellHook = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvShellHook(CL: TPSPascalCompiler);
procedure SIRegister_JvShellHook(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvShellHook_Routines(S: TPSExec);
procedure RIRegister_TJvShellHook(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvShellHook(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Messages
  ,JvComponentBase
  ,JvWin32
  ,JvShellHook
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvShellHook]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvShellHook(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvShellHook') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvShellHook') do begin
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('OnShellMessage', 'TJvShellHookEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvShellHook(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PShellHookInfo', '^TShellHookInfo // will not work');
  CL.AddTypeS('TShellHookInfo', 'record hwnd : THandle; rc : TRect; end');
  CL.AddTypeS('SHELLHOOKINFO', 'TShellHookInfo');
  //CL.AddTypeS('LPSHELLHOOKINFO', 'PShellHookInfo');
  CL.AddTypeS('TJvShellHookEvent', 'Procedure ( Sender : TObject; var Msg : TMessage)');
  SIRegister_TJvShellHook(CL);
 CL.AddDelphiFunction('Function InitJvShellHooks : Boolean');
 CL.AddDelphiFunction('Procedure UnInitJvShellHooks');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvShellHookOnShellMessage_W(Self: TJvShellHook; const T: TJvShellHookEvent);
begin Self.OnShellMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvShellHookOnShellMessage_R(Self: TJvShellHook; var T: TJvShellHookEvent);
begin T := Self.OnShellMessage; end;

(*----------------------------------------------------------------------------*)
procedure TJvShellHookActive_W(Self: TJvShellHook; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvShellHookActive_R(Self: TJvShellHook; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvShellHook_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitJvShellHooks, 'InitJvShellHooks', cdRegister);
 S.RegisterDelphiFunction(@UnInitJvShellHooks, 'UnInitJvShellHooks', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvShellHook(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvShellHook) do
  begin
    RegisterPropertyHelper(@TJvShellHookActive_R,@TJvShellHookActive_W,'Active');
    RegisterPropertyHelper(@TJvShellHookOnShellMessage_R,@TJvShellHookOnShellMessage_W,'OnShellMessage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvShellHook(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvShellHook(CL);
end;

 
 
{ TPSImport_JvShellHook }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvShellHook.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvShellHook(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvShellHook.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvShellHook(ri);
  RIRegister_JvShellHook_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
