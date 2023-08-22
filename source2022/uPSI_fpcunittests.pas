unit uPSI_fpcunittests;
{
    with decorator
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
  TPSImport_fpcunittests = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTestDecoratorTest(CL: TPSPascalCompiler);
procedure SIRegister_TMyTestSetup(CL: TPSPascalCompiler);
procedure SIRegister_TEncapsulatedTestCase(CL: TPSPascalCompiler);
procedure SIRegister_TMyIntfObj(CL: TPSPascalCompiler);
procedure SIRegister_IMyIntf(CL: TPSPascalCompiler);
procedure SIRegister_TListenerTest(CL: TPSPascalCompiler);
procedure SIRegister_TExampleStepTest(CL: TPSPascalCompiler);
procedure SIRegister_TExampleTest(CL: TPSPascalCompiler);
procedure SIRegister_TMockListener(CL: TPSPascalCompiler);
procedure SIRegister_TAssertTest(CL: TPSPascalCompiler);
procedure SIRegister_TTestSuiteTest(CL: TPSPascalCompiler);
procedure SIRegister_TTestCaseTest(CL: TPSPascalCompiler);
procedure SIRegister_fpcunittests(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTestDecoratorTest(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMyTestSetup(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEncapsulatedTestCase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMyIntfObj(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListenerTest(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExampleStepTest(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExampleTest(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMockListener(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAssertTest(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTestSuiteTest(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTestCaseTest(CL: TPSRuntimeClassImporter);
procedure RIRegister_fpcunittests(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   fpcunit
  ,testutils
  //,testregistry
  ,testdecorator
  ,fpcunittests
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_fpcunittests]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTestDecoratorTest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestCase', 'TTestDecoratorTest') do
  with CL.AddClassN(CL.FindClass('TTestCase'),'TTestDecoratorTest') do
  begin
    RegisterMethod('Procedure TestRun');
    RegisterMethod('Procedure TestOneTimeSetup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMyTestSetup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestSetup', 'TMyTestSetup') do
  with CL.AddClassN(CL.FindClass('TTestSetup'),'TMyTestSetup') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEncapsulatedTestCase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestCase', 'TEncapsulatedTestCase') do
  with CL.AddClassN(CL.FindClass('TTestCase'),'TEncapsulatedTestCase') do
  begin
    RegisterMethod('Procedure TestOne');
    RegisterMethod('Procedure TestTwo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMyIntfObj(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TMyIntfObj') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TMyIntfObj') do
  begin
    RegisterMethod('Procedure SayGoodbye');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IMyIntf(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IMyIntf') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IMyIntf, 'IMyIntf') do
  begin
    RegisterMethod('Procedure SayGoodbye', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListenerTest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestCase', 'TListenerTest') do
  with CL.AddClassN(CL.FindClass('TTestCase'),'TListenerTest') do
  begin
    RegisterMethod('Procedure TestStartAndEndTest');
    RegisterMethod('Procedure TestAddError');
    RegisterMethod('Procedure TestAddFailure');
    RegisterMethod('Procedure TestSetUpTearDown');
    RegisterMethod('Procedure TestSetUpException');
    RegisterMethod('Procedure TestTearDownException');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExampleStepTest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestCase', 'TExampleStepTest') do
  with CL.AddClassN(CL.FindClass('TTestCase'),'TExampleStepTest') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('WhenException', 'TTestStep', iptrw);
    RegisterMethod('Procedure TestException');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExampleTest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestCase', 'TExampleTest') do
  with CL.AddClassN(CL.FindClass('TTestCase'),'TExampleTest') do
  begin
    RegisterMethod('Procedure TestOne');
    RegisterMethod('Procedure TestWithError');
    RegisterMethod('Procedure TestWithFailure');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMockListener(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNoRefCountObject', 'TMockListener') do
  with CL.AddClassN(CL.FindClass('TNoRefCountObject'),'TMockListener') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure AddFailure( ATest : TTest; AFailure : TTestFailure)');
    RegisterMethod('Procedure AddError( ATest : TTest; AError : TTestFailure)');
    RegisterMethod('Procedure StartTest( ATest : TTest)');
    RegisterMethod('Procedure EndTest( ATest : TTest)');
    RegisterMethod('Procedure AddExpectedLine( ALine : string)');
    RegisterMethod('Procedure Verify( ActualList : TStrings)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAssertTest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestCase', 'TAssertTest') do
  with CL.AddClassN(CL.FindClass('TTestCase'),'TAssertTest') do
  begin
    RegisterMethod('Procedure TestEqualsInt');
    RegisterMethod('Procedure TestEqualsInt64');
    RegisterMethod('Procedure TestEqualsCurrency');
    RegisterMethod('Procedure TestEqualsDouble');
    RegisterMethod('Procedure TestEqualsBoolean');
    RegisterMethod('Procedure TestEqualsChar');
    RegisterMethod('Procedure TestEqualsTClass');
    RegisterMethod('Procedure TestEqualsTObject');
    RegisterMethod('Procedure TestNull');
    RegisterMethod('Procedure TestNullInterface');
    RegisterMethod('Procedure TestNotNull');
    RegisterMethod('Procedure TestNotNullWithInterface');
    RegisterMethod('Procedure TestNotNullInterface');
    RegisterMethod('Procedure TestFailEqualsInt');
    RegisterMethod('Procedure TestFailEqualsInt64');
    RegisterMethod('Procedure TestFailEqualsCurrency');
    RegisterMethod('Procedure TestFailEqualsDouble');
    RegisterMethod('Procedure TestFailEqualsBoolean');
    RegisterMethod('Procedure TestFailEqualsChar');
    RegisterMethod('Procedure TestFailEqualsTClass');
    RegisterMethod('Procedure TestFailEqualsTObject');
    RegisterMethod('Procedure TestFailNull');
    RegisterMethod('Procedure TestFailNullInterface');
    RegisterMethod('Procedure TestFailNotNull');
    RegisterMethod('Procedure TestFailNotNullInterface');
    RegisterMethod('Procedure TestAssertException');
    RegisterMethod('Procedure TestComparisonMsg');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTestSuiteTest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestCase', 'TTestSuiteTest') do
  with CL.AddClassN(CL.FindClass('TTestCase'),'TTestSuiteTest') do
  begin
    RegisterMethod('Procedure CheckCountTestCases');
    RegisterMethod('Procedure TestExtractMethods');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTestCaseTest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestCase', 'TTestCaseTest') do
  with CL.AddClassN(CL.FindClass('TTestCase'),'TTestCaseTest') do
  begin
    RegisterMethod('Procedure TestSetUp');
    RegisterMethod('Procedure TestAsString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_fpcunittests(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMyException');
  SIRegister_TTestCaseTest(CL);
  SIRegister_TTestSuiteTest(CL);
  SIRegister_TAssertTest(CL);
  SIRegister_TMockListener(CL);
  SIRegister_TExampleTest(CL);
  SIRegister_TExampleStepTest(CL);
  SIRegister_TListenerTest(CL);
  SIRegister_IMyIntf(CL);
  SIRegister_TMyIntfObj(CL);
  SIRegister_TEncapsulatedTestCase(CL);
  SIRegister_TMyTestSetup(CL);
  SIRegister_TTestDecoratorTest(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TExampleStepTestWhenException_W(Self: TExampleStepTest; const T: TTestStep);
begin Self.WhenException := T; end;

(*----------------------------------------------------------------------------*)
procedure TExampleStepTestWhenException_R(Self: TExampleStepTest; var T: TTestStep);
begin T := Self.WhenException; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTestDecoratorTest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTestDecoratorTest) do
  begin
    RegisterMethod(@TTestDecoratorTest.TestRun, 'TestRun');
    RegisterMethod(@TTestDecoratorTest.TestOneTimeSetup, 'TestOneTimeSetup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMyTestSetup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMyTestSetup) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEncapsulatedTestCase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEncapsulatedTestCase) do
  begin
    RegisterMethod(@TEncapsulatedTestCase.TestOne, 'TestOne');
    RegisterMethod(@TEncapsulatedTestCase.TestTwo, 'TestTwo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMyIntfObj(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMyIntfObj) do
  begin
    RegisterMethod(@TMyIntfObj.SayGoodbye, 'SayGoodbye');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListenerTest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListenerTest) do
  begin
    RegisterMethod(@TListenerTest.TestStartAndEndTest, 'TestStartAndEndTest');
    RegisterMethod(@TListenerTest.TestAddError, 'TestAddError');
    RegisterMethod(@TListenerTest.TestAddFailure, 'TestAddFailure');
    RegisterMethod(@TListenerTest.TestSetUpTearDown, 'TestSetUpTearDown');
    RegisterMethod(@TListenerTest.TestSetUpException, 'TestSetUpException');
    RegisterMethod(@TListenerTest.TestTearDownException, 'TestTearDownException');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExampleStepTest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExampleStepTest) do
  begin
    RegisterConstructor(@TExampleStepTest.Create, 'Create');
    RegisterPropertyHelper(@TExampleStepTestWhenException_R,@TExampleStepTestWhenException_W,'WhenException');
    RegisterMethod(@TExampleStepTest.TestException, 'TestException');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExampleTest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExampleTest) do
  begin
    RegisterMethod(@TExampleTest.TestOne, 'TestOne');
    RegisterMethod(@TExampleTest.TestWithError, 'TestWithError');
    RegisterMethod(@TExampleTest.TestWithFailure, 'TestWithFailure');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMockListener(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMockListener) do
  begin
    RegisterVirtualConstructor(@TMockListener.Create, 'Create');
    RegisterMethod(@TMockListener.AddFailure, 'AddFailure');
    RegisterMethod(@TMockListener.AddError, 'AddError');
    RegisterMethod(@TMockListener.StartTest, 'StartTest');
    RegisterMethod(@TMockListener.EndTest, 'EndTest');
    RegisterMethod(@TMockListener.AddExpectedLine, 'AddExpectedLine');
    RegisterMethod(@TMockListener.Verify, 'Verify');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAssertTest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAssertTest) do
  begin
    RegisterMethod(@TAssertTest.TestEqualsInt, 'TestEqualsInt');
    RegisterMethod(@TAssertTest.TestEqualsInt64, 'TestEqualsInt64');
    RegisterMethod(@TAssertTest.TestEqualsCurrency, 'TestEqualsCurrency');
    RegisterMethod(@TAssertTest.TestEqualsDouble, 'TestEqualsDouble');
    RegisterMethod(@TAssertTest.TestEqualsBoolean, 'TestEqualsBoolean');
    RegisterMethod(@TAssertTest.TestEqualsChar, 'TestEqualsChar');
    RegisterMethod(@TAssertTest.TestEqualsTClass, 'TestEqualsTClass');
    RegisterMethod(@TAssertTest.TestEqualsTObject, 'TestEqualsTObject');
    RegisterMethod(@TAssertTest.TestNull, 'TestNull');
    RegisterMethod(@TAssertTest.TestNullInterface, 'TestNullInterface');
    RegisterMethod(@TAssertTest.TestNotNull, 'TestNotNull');
    RegisterMethod(@TAssertTest.TestNotNullWithInterface, 'TestNotNullWithInterface');
    RegisterMethod(@TAssertTest.TestNotNullInterface, 'TestNotNullInterface');
    RegisterMethod(@TAssertTest.TestFailEqualsInt, 'TestFailEqualsInt');
    RegisterMethod(@TAssertTest.TestFailEqualsInt64, 'TestFailEqualsInt64');
    RegisterMethod(@TAssertTest.TestFailEqualsCurrency, 'TestFailEqualsCurrency');
    RegisterMethod(@TAssertTest.TestFailEqualsDouble, 'TestFailEqualsDouble');
    RegisterMethod(@TAssertTest.TestFailEqualsBoolean, 'TestFailEqualsBoolean');
    RegisterMethod(@TAssertTest.TestFailEqualsChar, 'TestFailEqualsChar');
    RegisterMethod(@TAssertTest.TestFailEqualsTClass, 'TestFailEqualsTClass');
    RegisterMethod(@TAssertTest.TestFailEqualsTObject, 'TestFailEqualsTObject');
    RegisterMethod(@TAssertTest.TestFailNull, 'TestFailNull');
    RegisterMethod(@TAssertTest.TestFailNullInterface, 'TestFailNullInterface');
    RegisterMethod(@TAssertTest.TestFailNotNull, 'TestFailNotNull');
    RegisterMethod(@TAssertTest.TestFailNotNullInterface, 'TestFailNotNullInterface');
    RegisterMethod(@TAssertTest.TestAssertException, 'TestAssertException');
    RegisterMethod(@TAssertTest.TestComparisonMsg, 'TestComparisonMsg');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTestSuiteTest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTestSuiteTest) do
  begin
    RegisterMethod(@TTestSuiteTest.CheckCountTestCases, 'CheckCountTestCases');
    RegisterMethod(@TTestSuiteTest.TestExtractMethods, 'TestExtractMethods');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTestCaseTest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTestCaseTest) do
  begin
    RegisterMethod(@TTestCaseTest.TestSetUp, 'TestSetUp');
    RegisterMethod(@TTestCaseTest.TestAsString, 'TestAsString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_fpcunittests(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EMyException) do
  RIRegister_TTestCaseTest(CL);
  RIRegister_TTestSuiteTest(CL);
  RIRegister_TAssertTest(CL);
  RIRegister_TMockListener(CL);
  RIRegister_TExampleTest(CL);
  RIRegister_TExampleStepTest(CL);
  RIRegister_TListenerTest(CL);
  RIRegister_TMyIntfObj(CL);
  RIRegister_TEncapsulatedTestCase(CL);
  RIRegister_TMyTestSetup(CL);
  RIRegister_TTestDecoratorTest(CL);
end;

 
 
{ TPSImport_fpcunittests }
(*----------------------------------------------------------------------------*)
procedure TPSImport_fpcunittests.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_fpcunittests(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_fpcunittests.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
