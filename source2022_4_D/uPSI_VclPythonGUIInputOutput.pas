unit uPSI_VclPythonGUIInputOutput;
{
to get the gui

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
  TPSImport_VclPythonGUIInputOutput = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPythonGUIInputOutput(CL: TPSPascalCompiler);
procedure SIRegister_VclPythonGUIInputOutput(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_VclPythonGUIInputOutput_Routines(S: TPSExec);
procedure RIRegister_TPythonGUIInputOutput(CL: TPSRuntimeClassImporter);
procedure RIRegister_VclPythonGUIInputOutput(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,PythonEngine
  ,VclPythonGUIInputOutput
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VclPythonGUIInputOutput]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPythonGUIInputOutput(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPythonInputOutput', 'TPythonGUIInputOutput') do
  with CL.AddClassN(CL.FindClass('TPythonInputOutput'),'TPythonGUIInputOutput') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure DisplayString( const str : string)');
    RegisterProperty('Output', 'TCustomMemo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_VclPythonGUIInputOutput(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('WM_WriteOutput','LongInt').SetInt( WM_USER + 1);
  SIRegister_TPythonGUIInputOutput(CL);
 CL.AddDelphiFunction('Procedure Register_PythonGUI');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPythonGUIInputOutputOutput_W(Self: TPythonGUIInputOutput; const T: TCustomMemo);
begin Self.Output := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonGUIInputOutputOutput_R(Self: TPythonGUIInputOutput; var T: TCustomMemo);
begin T := Self.Output; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VclPythonGUIInputOutput_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register_PythonGUI', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPythonGUIInputOutput(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPythonGUIInputOutput) do begin
    RegisterConstructor(@TPythonGUIInputOutput.Create, 'Create');
    RegisterMethod(@TPythonGUIInputOutput.Destroy, 'Free');
    RegisterMethod(@TPythonGUIInputOutput.DisplayString, 'DisplayString');
    RegisterPropertyHelper(@TPythonGUIInputOutputOutput_R,@TPythonGUIInputOutputOutput_W,'Output');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VclPythonGUIInputOutput(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPythonGUIInputOutput(CL);
end;

 
 
{ TPSImport_VclPythonGUIInputOutput }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VclPythonGUIInputOutput.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VclPythonGUIInputOutput(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VclPythonGUIInputOutput.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_VclPythonGUIInputOutput(ri);
  RIRegister_VclPythonGUIInputOutput_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
