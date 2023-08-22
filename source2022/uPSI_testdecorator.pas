unit uPSI_testdecorator;
{
   over unittest
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
  TPSImport_testdecorator = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTestSetup(CL: TPSPascalCompiler);
procedure SIRegister_TTestDecorator(CL: TPSPascalCompiler);
procedure SIRegister_testdecorator(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTestSetup(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTestDecorator(CL: TPSRuntimeClassImporter);
procedure RIRegister_testdecorator(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   fpcunit
  ,testdecorator
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_testdecorator]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTestSetup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestDecorator', 'TTestSetup') do
  with CL.AddClassN(CL.FindClass('TTestDecorator'),'TTestSetup') do
  begin
    RegisterMethod('Procedure Run( AResult : TTestResult)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTestDecorator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAssert', 'TTestDecorator') do
  with CL.AddClassN(CL.FindClass('TAssert'),'TTestDecorator') do
  begin
    RegisterMethod('Constructor Create( aTest : TTest);');
    RegisterMethod('Procedure BasicRun( AResult : TTestResult)');
    RegisterProperty('Test', 'TTest', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_testdecorator(CL: TPSPascalCompiler);
begin
  SIRegister_TTestDecorator(CL);
  SIRegister_TTestSetup(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTestDecoratorTest_R(Self: TTestDecorator; var T: TTest);
begin T := Self.Test; end;

(*----------------------------------------------------------------------------*)
Function TTestDecoratorCreate_P(Self: TClass; CreateNewInstance: Boolean;  aTest : TTest):TObject;
Begin Result := TTestDecorator.Create(aTest); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTestSetup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTestSetup) do
  begin
    RegisterMethod(@TTestSetup.Run, 'Run');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTestDecorator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTestDecorator) do
  begin
    RegisterConstructor(@TTestDecoratorCreate_P, 'Create');
    RegisterVirtualMethod(@TTestDecorator.BasicRun, 'BasicRun');
    RegisterPropertyHelper(@TTestDecoratorTest_R,nil,'Test');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_testdecorator(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTestDecorator(CL);
  RIRegister_TTestSetup(CL);
end;

 
 
{ TPSImport_testdecorator }
(*----------------------------------------------------------------------------*)
procedure TPSImport_testdecorator.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_testdecorator(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_testdecorator.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_testdecorator(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
