unit uPSI_JvWinHelp;
{
  to get the MARS help
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
  TPSImport_JvWinHelp = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvWinHelp(CL: TPSPascalCompiler);
procedure SIRegister_JvWinHelp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvWinHelp(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvWinHelp(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Controls
  ,Forms
  ,Menus
  ,JvTypes
  ,JvComponentBase
  ,JvWinHelp
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvWinHelp]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvWinHelp(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvWinHelp') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvWinHelp') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function ShowContextualHelp( Control : TWinControl) : Boolean');
    RegisterMethod('Function ExecuteCommand( MacroCommand : string) : Boolean');
    RegisterMethod('Function ShowHelp( Control : TWinControl) : Boolean');
    RegisterMethod('Function ShowContents : Boolean');
    RegisterMethod('Function ShowHelpOnHelp : Boolean');
    RegisterMethod('Function ShowIndex : Boolean');
    RegisterMethod('Function ShowKeyword( Keyword : string) : Boolean');
    RegisterMethod('Function ShowPartialKeyWord( Keyword : string) : Boolean');
    RegisterMethod('Function SetWindowPos( Left, Top, Width, Height : Integer; Visibility : Integer) : Boolean');
    RegisterProperty('HelpFile', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvWinHelp(CL: TPSPascalCompiler);
begin
  SIRegister_TJvWinHelp(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvWinHelpHelpFile_W(Self: TJvWinHelp; const T: string);
begin Self.HelpFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinHelpHelpFile_R(Self: TJvWinHelp; var T: string);
begin T := Self.HelpFile; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvWinHelp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvWinHelp) do begin
    RegisterConstructor(@TJvWinHelp.Create, 'Create');
       RegisterMethod(@TJvWinHelp.Destroy, 'Free');
      RegisterMethod(@TJvWinHelp.ShowContextualHelp, 'ShowContextualHelp');
    RegisterMethod(@TJvWinHelp.ExecuteCommand, 'ExecuteCommand');
    RegisterMethod(@TJvWinHelp.ShowHelp, 'ShowHelp');
    RegisterMethod(@TJvWinHelp.ShowContents, 'ShowContents');
    RegisterMethod(@TJvWinHelp.ShowHelpOnHelp, 'ShowHelpOnHelp');
    RegisterMethod(@TJvWinHelp.ShowIndex, 'ShowIndex');
    RegisterMethod(@TJvWinHelp.ShowKeyword, 'ShowKeyword');
    RegisterMethod(@TJvWinHelp.ShowPartialKeyWord, 'ShowPartialKeyWord');
    RegisterMethod(@TJvWinHelp.SetWindowPos, 'SetWindowPos');
    RegisterPropertyHelper(@TJvWinHelpHelpFile_R,@TJvWinHelpHelpFile_W,'HelpFile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvWinHelp(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvWinHelp(CL);
end;

 
 
{ TPSImport_JvWinHelp }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvWinHelp.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvWinHelp(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvWinHelp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvWinHelp(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
