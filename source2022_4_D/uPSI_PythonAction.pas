unit uPSI_PythonAction;
{
as a last for the past

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
  TPSImport_PythonAction = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPythonAction(CL: TPSPascalCompiler);
procedure SIRegister_PythonAction(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PythonAction_Routines(S: TPSExec);
procedure RIRegister_TPythonAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_PythonAction(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ActnList
  ,PythonEngine
  ,PythonAction
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PythonAction]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPythonAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAction', 'TPythonAction') do
  with CL.AddClassN(CL.FindClass('TAction'),'TPythonAction') do
  begin
    RegisterProperty('fRegisteredMethods', 'TList', iptrw);
    RegisterProperty('fPythonModule', 'TPythonModule', iptrw);
    RegisterProperty('fClearname', 'string', iptrw);
    RegisterProperty('fRegistername', 'string', iptrw);
    RegisterProperty('fUnregistername', 'string', iptrw);
    RegisterMethod('Procedure ClearMethods');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function HandlesTarget( Target : TObject) : Boolean');
    RegisterMethod('Function Execute : Boolean');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
    RegisterMethod('Procedure InitializeAction');
    RegisterProperty('RegisteredMethods', 'TList', iptr);
    RegisterProperty('PythonModule', 'TPythonModule', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PythonAction(CL: TPSPascalCompiler);
begin
  SIRegister_TPythonAction(CL);
 CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPythonActionPythonModule_W(Self: TPythonAction; const T: TPythonModule);
begin Self.PythonModule := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionPythonModule_R(Self: TPythonAction; var T: TPythonModule);
begin T := Self.PythonModule; end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionRegisteredMethods_R(Self: TPythonAction; var T: TList);
begin T := Self.RegisteredMethods; end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionfUnregistername_W(Self: TPythonAction; const T: string);
Begin //Self.fUnregistername := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionfUnregistername_R(Self: TPythonAction; var T: string);
Begin //T := Self.fUnregistername;
end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionfRegistername_W(Self: TPythonAction; const T: string);
Begin //Self.fRegistername := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionfRegistername_R(Self: TPythonAction; var T: string);
Begin //T := Self.fRegistername;
end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionfClearname_W(Self: TPythonAction; const T: string);
Begin //Self.fClearname := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionfClearname_R(Self: TPythonAction; var T: string);
Begin //T := Self.fClearname;
end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionfPythonModule_W(Self: TPythonAction; const T: TPythonModule);
Begin //Self.fPythonModule := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionfPythonModule_R(Self: TPythonAction; var T: TPythonModule);
Begin //T := Self.fPythonModule;
end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionfRegisteredMethods_W(Self: TPythonAction; const T: TList);
Begin //Self.fRegisteredMethods := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPythonActionfRegisteredMethods_R(Self: TPythonAction; var T: TList);
Begin //T := Self.fRegisteredMethods;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PythonAction_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPythonAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPythonAction) do
  begin
    RegisterPropertyHelper(@TPythonActionfRegisteredMethods_R,@TPythonActionfRegisteredMethods_W,'fRegisteredMethods');
    RegisterPropertyHelper(@TPythonActionfPythonModule_R,@TPythonActionfPythonModule_W,'fPythonModule');
    RegisterPropertyHelper(@TPythonActionfClearname_R,@TPythonActionfClearname_W,'fClearname');
    RegisterPropertyHelper(@TPythonActionfRegistername_R,@TPythonActionfRegistername_W,'fRegistername');
    RegisterPropertyHelper(@TPythonActionfUnregistername_R,@TPythonActionfUnregistername_W,'fUnregistername');
    RegisterMethod(@TPythonAction.ClearMethods, 'ClearMethods');
    RegisterConstructor(@TPythonAction.Create, 'Create');
    RegisterMethod(@TPythonAction.HandlesTarget, 'HandlesTarget');
    RegisterMethod(@TPythonAction.Execute, 'Execute');
    RegisterMethod(@TPythonAction.UpdateTarget, 'UpdateTarget');
    RegisterMethod(@TPythonAction.InitializeAction, 'InitializeAction');
    RegisterPropertyHelper(@TPythonActionRegisteredMethods_R,nil,'RegisteredMethods');
    RegisterPropertyHelper(@TPythonActionPythonModule_R,@TPythonActionPythonModule_W,'PythonModule');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PythonAction(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPythonAction(CL);
end;

 
 
{ TPSImport_PythonAction }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PythonAction.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PythonAction(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PythonAction.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PythonAction(ri);
  RIRegister_PythonAction_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
