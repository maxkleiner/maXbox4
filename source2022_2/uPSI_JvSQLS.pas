unit uPSI_JvSQLS;
{

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
  TPSImport_JvSQLS = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvaSQLScript(CL: TPSPascalCompiler);
procedure SIRegister_JvSQLS(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvaSQLScript(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvSQLS(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DBTables
  ,JvDBUtil
  ,JvComponent
  ,JvSQLS
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvSQLS]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvaSQLScript(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvaSQLScript') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvaSQLScript') do begin
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
procedure SIRegister_JvSQLS(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvaSQLScript');
  CL.AddTypeS('TOnScriptProgress', 'Procedure ( Sender : TJvaSQLScript; var Can'
   +'cel : Boolean; Line : Integer)');
  SIRegister_TJvaSQLScript(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvaSQLScriptDatabase_W(Self: TJvaSQLScript; const T: TDatabase);
begin Self.Database := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvaSQLScriptDatabase_R(Self: TJvaSQLScript; var T: TDatabase);
begin T := Self.Database; end;

(*----------------------------------------------------------------------------*)
procedure TJvaSQLScriptCommit_W(Self: TJvaSQLScript; const T: TCommit);
begin Self.Commit := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvaSQLScriptCommit_R(Self: TJvaSQLScript; var T: TCommit);
begin T := Self.Commit; end;

(*----------------------------------------------------------------------------*)
procedure TJvaSQLScriptScript_W(Self: TJvaSQLScript; const T: TStrings);
begin Self.Script := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvaSQLScriptScript_R(Self: TJvaSQLScript; var T: TStrings);
begin T := Self.Script; end;

(*----------------------------------------------------------------------------*)
procedure TJvaSQLScriptOnProgress_W(Self: TJvaSQLScript; const T: TOnScriptProgress);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvaSQLScriptOnProgress_R(Self: TJvaSQLScript; var T: TOnScriptProgress);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvaSQLScript(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvaSQLScript) do begin
    RegisterConstructor(@TJvaSQLScript.Create, 'Create');
    RegisterMethod(@TJvaSQLScript.Destroy, 'Free');
    RegisterMethod(@TJvaSQLScript.Execute, 'Execute');
    RegisterPropertyHelper(@TJvaSQLScriptOnProgress_R,@TJvaSQLScriptOnProgress_W,'OnProgress');
    RegisterPropertyHelper(@TJvaSQLScriptScript_R,@TJvaSQLScriptScript_W,'Script');
    RegisterPropertyHelper(@TJvaSQLScriptCommit_R,@TJvaSQLScriptCommit_W,'Commit');
    RegisterPropertyHelper(@TJvaSQLScriptDatabase_R,@TJvaSQLScriptDatabase_W,'Database');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvSQLS(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvaSQLScript) do
  RIRegister_TJvaSQLScript(CL);
end;

 
 
{ TPSImport_JvSQLS }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSQLS.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvSQLS(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSQLS.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvSQLS(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
