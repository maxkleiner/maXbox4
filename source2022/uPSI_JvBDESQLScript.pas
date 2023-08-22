unit uPSI_JvBDESQLScript;
{
   with redesign!
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
  TPSImport_JvBDESQLScript = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvBDESQLScript(CL: TPSPascalCompiler);
procedure SIRegister_JvBDESQLScript(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvBDESQLScript(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvBDESQLScript(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  DBTables
  ,JvDBUtils
  ,JvComponentBase

  ,JvBDESQLScript
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvBDESQLScript]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvBDESQLScript(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvBDESQLScript') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvBDESQLScript') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Execute');
    RegisterProperty('OnProgress', 'TOnScriptProgress', iptrw);
    RegisterProperty('Script', 'TStrings', iptrw);
    RegisterProperty('Commit', 'TCommit', iptrw);
    RegisterProperty('Database', 'TDatabase', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvBDESQLScript(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvBDESQLScript');
  CL.AddTypeS('TOnScriptProgress', 'Procedure ( Sender : TJvBDESQLScript; var Cancel : Boolean; Line : Integer)');
  SIRegister_TJvBDESQLScript(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvBDESQLScriptDatabase_W(Self: TJvBDESQLScript; const T: TDatabase);
begin Self.Database := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBDESQLScriptDatabase_R(Self: TJvBDESQLScript; var T: TDatabase);
begin T := Self.Database; end;

(*----------------------------------------------------------------------------*)
procedure TJvBDESQLScriptCommit_W(Self: TJvBDESQLScript; const T: TCommit);
begin Self.Commit := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBDESQLScriptCommit_R(Self: TJvBDESQLScript; var T: TCommit);
begin T := Self.Commit; end;

(*----------------------------------------------------------------------------*)
procedure TJvBDESQLScriptScript_W(Self: TJvBDESQLScript; const T: TStrings);
begin Self.Script := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBDESQLScriptScript_R(Self: TJvBDESQLScript; var T: TStrings);
begin T := Self.Script; end;

(*----------------------------------------------------------------------------*)
procedure TJvBDESQLScriptOnProgress_W(Self: TJvBDESQLScript; const T: TOnScriptProgress);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBDESQLScriptOnProgress_R(Self: TJvBDESQLScript; var T: TOnScriptProgress);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvBDESQLScript(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvBDESQLScript) do begin
    RegisterConstructor(@TJvBDESQLScript.Create, 'Create');
    RegisterMethod(@TJvBDESQLScript.Destroy, 'Free');
    RegisterMethod(@TJvBDESQLScript.Execute, 'Execute');
    RegisterPropertyHelper(@TJvBDESQLScriptOnProgress_R,@TJvBDESQLScriptOnProgress_W,'OnProgress');
    RegisterPropertyHelper(@TJvBDESQLScriptScript_R,@TJvBDESQLScriptScript_W,'Script');
    RegisterPropertyHelper(@TJvBDESQLScriptCommit_R,@TJvBDESQLScriptCommit_W,'Commit');
    RegisterPropertyHelper(@TJvBDESQLScriptDatabase_R,@TJvBDESQLScriptDatabase_W,'Database');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvBDESQLScript(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvBDESQLScript) do
  RIRegister_TJvBDESQLScript(CL);
end;

 
 
{ TPSImport_JvBDESQLScript }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvBDESQLScript.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvBDESQLScript(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvBDESQLScript.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvBDESQLScript(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
