unit uPSI_fpcunit;
{
   the road to a testscript script as dunit
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
  TPSImport_fpcunit = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTestResult(CL: TPSPascalCompiler);
procedure SIRegister_TTestSuite(CL: TPSPascalCompiler);
procedure SIRegister_TTestCase(CL: TPSPascalCompiler);
procedure SIRegister_ITestListener(CL: TPSPascalCompiler);
procedure SIRegister_TTestFailure(CL: TPSPascalCompiler);
procedure SIRegister_TAssert(CL: TPSPascalCompiler);
procedure SIRegister_TTest(CL: TPSPascalCompiler);
procedure SIRegister_EAssertionFailedError(CL: TPSPascalCompiler);
procedure SIRegister_fpcunit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_fpcunit_Routines(S: TPSExec);
procedure RIRegister_TTestResult(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTestSuite(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTestCase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTestFailure(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAssert(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTest(CL: TPSRuntimeClassImporter);
procedure RIRegister_EAssertionFailedError(CL: TPSRuntimeClassImporter);
procedure RIRegister_fpcunit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // LineInfo
  fpcunit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_fpcunit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTestResult(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TTestResult') do
  with CL.AddClassN(CL.FindClass('TObject'),'TTestResult') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Listeners', 'TList', iptr);
    RegisterMethod('Procedure ClearErrorLists');
    RegisterMethod('Procedure StartTest( ATest : TTest)');
    RegisterMethod('Procedure AddFailure( ATest : TTest; E : EAssertionFailedError)');
    RegisterMethod('Procedure AddError( ATest : TTest; E : Exception; AUnitName : string; AFailedMethodName : string; ALineNumber : longint)');
    RegisterMethod('Procedure EndTest( ATest : TTest)');
    RegisterMethod('Procedure AddListener( AListener : ITestListener)');
    RegisterMethod('Procedure RemoveListener( AListener : ITestListener)');
    RegisterMethod('Procedure Run( ATestCase : TTestCase)');
    RegisterMethod('Procedure RunProtected( ATestCase : TTest; protect : TProtect)');
    RegisterMethod('Function WasSuccessful : boolean');
    RegisterMethod('Function SkipTest( ATestCase : TTestCase) : boolean');
    RegisterMethod('Procedure AddToSkipList( ATestCase : TTestCase)');
    RegisterMethod('Procedure RemoveFromSkipList( ATestCase : TTestCase)');
    RegisterProperty('Failures', 'TList', iptr);
    RegisterProperty('Errors', 'TList', iptr);
    RegisterProperty('RunTests', 'integer', iptr);
    RegisterProperty('NumberOfErrors', 'integer', iptr);
    RegisterProperty('NumberOfFailures', 'integer', iptr);
    RegisterProperty('NumberOfSkippedTests', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTestSuite(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTest', 'TTestSuite') do
  with CL.AddClassN(CL.FindClass('TTest'),'TTestSuite') do
  begin
    RegisterMethod('Constructor Create( AClass : TClass; AName : string);');
    RegisterMethod('Constructor Create1( AClass : TClass);');
    RegisterMethod('Constructor Create2( AClassArray : array of TClass);');
    RegisterMethod('Constructor Create3( AName : string);');
    RegisterMethod('Constructor Create4;');
    RegisterMethod('Function CountTestCases : integer');
    RegisterMethod('Procedure Run( AResult : TTestResult)');
    RegisterMethod('Procedure RunTest( ATest : TTest; AResult : TTestResult)');
    RegisterMethod('Procedure AddTest( ATest : TTest);');
    RegisterMethod('Procedure AddTestSuiteFromClass( ATestClass : TClass)');
    RegisterMethod('Function Warning( const aMessage : string) : TTestCase');
    RegisterProperty('Test', 'TTest integer', iptr);
    SetDefaultPropery('Test');
    RegisterProperty('TestSuiteName', 'string', iptrw);
    RegisterProperty('TestName', 'string', iptrw);
    RegisterProperty('Tests', 'TList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTestCase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAssert', 'TTestCase') do
  with CL.AddClassN(CL.FindClass('TAssert'),'TTestCase') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Constructor CreateWith( const ATestName : string; const ATestSuiteName : string)');
    RegisterMethod('Constructor CreateWithName( const AName : string)');
    RegisterMethod('Function CountTestCases : integer');
    RegisterMethod('Function CreateResultAndRun : TTestResult');
    RegisterMethod('Procedure Run( AResult : TTestResult)');
    RegisterMethod('Function AsString : string');
    RegisterProperty('TestSuiteName', 'string', iptrw);
    RegisterProperty('TestName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ITestListener(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ITestListener') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ITestListener, 'ITestListener') do
  begin
    RegisterMethod('Procedure AddFailure( ATest : TTest; AFailure : TTestFailure)', cdRegister);
    RegisterMethod('Procedure AddError( ATest : TTest; AError : TTestFailure)', cdRegister);
    RegisterMethod('Procedure StartTest( ATest : TTest)', cdRegister);
    RegisterMethod('Procedure EndTest( ATest : TTest)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTestFailure(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TTestFailure') do
  with CL.AddClassN(CL.FindClass('TObject'),'TTestFailure') do
  begin
    RegisterMethod('Constructor CreateFailure( ATest : TTest; E : Exception; LastStep : TTestStep)');
    RegisterProperty('ExceptionClass', 'TClass', iptr);
    RegisterProperty('AsString', 'string', iptr);
    RegisterProperty('IsFailure', 'boolean', iptr);
    RegisterProperty('ExceptionMessage', 'string', iptr);
    RegisterProperty('ExceptionClassName', 'string', iptr);
    RegisterProperty('SourceUnitName', 'string', iptrw);
    RegisterProperty('LineNumber', 'longint', iptrw);
    RegisterProperty('FailedMethodName', 'string', iptrw);
    RegisterProperty('TestLastStep', 'TTestStep', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAssert(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTest', 'TAssert') do
  with CL.AddClassN(CL.FindClass('TTest'),'TAssert') do begin
    RegisterMethod('Procedure Fail( const AMessage : string)');
    RegisterMethod('Procedure AssertTrue( const AMessage : string; ACondition : boolean);');
    RegisterMethod('Procedure AssertTrue1( ACondition : boolean);');
    RegisterMethod('Procedure AssertFalse( const AMessage : string; ACondition : boolean);');
    RegisterMethod('Procedure AssertFalse1( ACondition : boolean);');
    RegisterMethod('Procedure AssertEquals( const AMessage : string; Expected, Actual : string);');
    RegisterMethod('Procedure AssertEquals1( Expected, Actual : string);');
    RegisterMethod('Procedure AssertEquals2( const AMessage : string; Expected, Actual : integer);');
    RegisterMethod('Procedure AssertEquals3( Expected, Actual : integer);');
    RegisterMethod('Procedure AssertEquals4( const AMessage : string; Expected, Actual : int64);');
    RegisterMethod('Procedure AssertEquals5( Expected, Actual : int64);');
    RegisterMethod('Procedure AssertEquals6( const AMessage : string; Expected, Actual : currency);');
    RegisterMethod('Procedure AssertEquals7( Expected, Actual : currency);');
    RegisterMethod('Procedure AssertEquals8( const AMessage : string; Expected, Actual, Delta : double);');
    RegisterMethod('Procedure AssertEquals9( Expected, Actual, Delta : double);');
    RegisterMethod('Procedure AssertEquals10( const AMessage : string; Expected, Actual : boolean);');
    RegisterMethod('Procedure AssertEquals11( Expected, Actual : boolean);');
    RegisterMethod('Procedure AssertEquals12( const AMessage : string; Expected, Actual : char);');
    RegisterMethod('Procedure AssertEquals13( Expected, Actual : char);');
    RegisterMethod('Procedure AssertEquals14( const AMessage : string; Expected, Actual : TClass);');
    RegisterMethod('Procedure AssertEquals15( Expected, Actual : TClass);');
    RegisterMethod('Procedure AssertSame( const AMessage : string; Expected, Actual : TObject);');
    RegisterMethod('Procedure AssertSame1( Expected, Actual : TObject);');
    RegisterMethod('Procedure AssertSame2( const AMessage : string; Expected, Actual : Pointer);');
    RegisterMethod('Procedure AssertSame3( Expected, Actual : Pointer);');
    RegisterMethod('Procedure AssertNotSame( const AMessage : string; Expected, Actual : TObject);');
    RegisterMethod('Procedure AssertNotSame1( Expected, Actual : TObject);');
    RegisterMethod('Procedure AssertNotSame2( const AMessage : string; Expected, Actual : Pointer);');
    RegisterMethod('Procedure AssertNotSame3( Expected, Actual : Pointer);');
    RegisterMethod('Procedure AssertNotNull( const AMessage : string; AObject : TObject);');
    RegisterMethod('Procedure AssertNotNull1( AObject : TObject);');
    RegisterMethod('Procedure AssertNotNullIntf( const AMessage : string; AInterface : IInterface);');
    RegisterMethod('Procedure AssertNotNullIntf1( AInterface : IInterface);');
    RegisterMethod('Procedure AssertNotNull( const AMessage : string; APointer : Pointer);');
    RegisterMethod('Procedure AssertNotNull1( APointer : Pointer);');
    RegisterMethod('Procedure AssertNull( const AMessage : string; AObject : TObject);');
    RegisterMethod('Procedure AssertNull1( AObject : TObject);');
    RegisterMethod('Procedure AssertNullIntf( const AMessage : string; AInterface : IInterface);');
    RegisterMethod('Procedure AssertNullIntf1( AInterface : IInterface);');
    RegisterMethod('Procedure AssertNull3( const AMessage : string; APointer : Pointer);');
    RegisterMethod('Procedure AssertNull4( APointer : Pointer);');
    RegisterMethod('Procedure AssertNotNull( const AMessage, AString : string);');
    RegisterMethod('Procedure AssertNotNull1( const AString : string);');
    RegisterMethod('Procedure AssertException( const AMessage : string; AExceptionClass : ExceptClass; AMethod : TRunMethod);');
    RegisterMethod('Procedure AssertException1( AExceptionClass : ExceptClass; AMethod : TRunMethod);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TTest') do
  with CL.AddClassN(CL.FindClass('TObject'),'TTest') do
  begin
    RegisterMethod('Function CountTestCases : integer');
    RegisterMethod('Procedure Run( AResult : TTestResult)');
    RegisterProperty('TestName', 'string', iptr);
    RegisterProperty('TestSuiteName', 'string', iptrw);
    RegisterProperty('LastStep', 'TTestStep', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EAssertionFailedError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EAssertionFailedError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EAssertionFailedError') do
  begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( const msg : string);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_fpcunit(CL: TPSPascalCompiler);
begin
  SIRegister_EAssertionFailedError(CL);
  CL.AddTypeS('TTestStep', '( stSetUp, stRunTest, stTearDown, stNothing )');
  CL.AddTypeS('TRunMethod', 'Procedure');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTestResult');
  SIRegister_TTest(CL);
  SIRegister_TAssert(CL);
  SIRegister_TTestFailure(CL);
  SIRegister_ITestListener(CL);
  SIRegister_TTestCase(CL);
  //CL.AddTypeS('TTestCaseClass', 'class of TTestCase');
  SIRegister_TTestSuite(CL);
  SIRegister_TTestResult(CL);
 CL.AddDelphiFunction('Function ComparisonMsg( const aExpected : string; const aActual : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTestResultNumberOfSkippedTests_R(Self: TTestResult; var T: integer);
begin T := Self.NumberOfSkippedTests; end;

(*----------------------------------------------------------------------------*)
procedure TTestResultNumberOfFailures_R(Self: TTestResult; var T: integer);
begin T := Self.NumberOfFailures; end;

(*----------------------------------------------------------------------------*)
procedure TTestResultNumberOfErrors_R(Self: TTestResult; var T: integer);
begin T := Self.NumberOfErrors; end;

(*----------------------------------------------------------------------------*)
procedure TTestResultRunTests_R(Self: TTestResult; var T: integer);
begin T := Self.RunTests; end;

(*----------------------------------------------------------------------------*)
procedure TTestResultErrors_R(Self: TTestResult; var T: TList);
begin T := Self.Errors; end;

(*----------------------------------------------------------------------------*)
procedure TTestResultFailures_R(Self: TTestResult; var T: TList);
begin T := Self.Failures; end;

(*----------------------------------------------------------------------------*)
procedure TTestResultListeners_R(Self: TTestResult; var T: TList);
begin T := Self.Listeners; end;

(*----------------------------------------------------------------------------*)
procedure TTestSuiteTests_R(Self: TTestSuite; var T: TList);
begin T := Self.Tests; end;

(*----------------------------------------------------------------------------*)
procedure TTestSuiteTestName_W(Self: TTestSuite; const T: string);
begin Self.TestName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTestSuiteTestName_R(Self: TTestSuite; var T: string);
begin T := Self.TestName; end;

(*----------------------------------------------------------------------------*)
procedure TTestSuiteTestSuiteName_W(Self: TTestSuite; const T: string);
begin Self.TestSuiteName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTestSuiteTestSuiteName_R(Self: TTestSuite; var T: string);
begin T := Self.TestSuiteName; end;

(*----------------------------------------------------------------------------*)
procedure TTestSuiteTest_R(Self: TTestSuite; var T: TTest; const t1: integer);
begin T := Self.Test[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TTestSuiteAddTest_P(Self: TTestSuite;  ATest : TTest);
Begin Self.AddTest(ATest); END;

(*----------------------------------------------------------------------------*)
Function TTestSuiteCreate4_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TTestSuite.Create; END;

(*----------------------------------------------------------------------------*)
Function TTestSuiteCreate3_P(Self: TClass; CreateNewInstance: Boolean;  AName : string):TObject;
Begin Result := TTestSuite.Create(AName); END;

(*----------------------------------------------------------------------------*)
Function TTestSuiteCreate2_P(Self: TClass; CreateNewInstance: Boolean;  AClassArray : array of TClass):TObject;
Begin Result := TTestSuite.Create(AClassArray); END;

(*----------------------------------------------------------------------------*)
Function TTestSuiteCreate1_P(Self: TClass; CreateNewInstance: Boolean;  AClass : TClass):TObject;
Begin Result := TTestSuite.Create(AClass); END;

(*----------------------------------------------------------------------------*)
Function TTestSuiteCreate_P(Self: TClass; CreateNewInstance: Boolean;  AClass : TClass; AName : string):TObject;
Begin Result := TTestSuite.Create(AClass, AName); END;

(*----------------------------------------------------------------------------*)
procedure TTestCaseTestName_W(Self: TTestCase; const T: string);
begin Self.TestName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTestCaseTestName_R(Self: TTestCase; var T: string);
begin T := Self.TestName; end;

(*----------------------------------------------------------------------------*)
procedure TTestCaseTestSuiteName_W(Self: TTestCase; const T: string);
begin Self.TestSuiteName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTestCaseTestSuiteName_R(Self: TTestCase; var T: string);
begin T := Self.TestSuiteName; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureTestLastStep_W(Self: TTestFailure; const T: TTestStep);
begin Self.TestLastStep := T; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureTestLastStep_R(Self: TTestFailure; var T: TTestStep);
begin T := Self.TestLastStep; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureFailedMethodName_W(Self: TTestFailure; const T: string);
begin Self.FailedMethodName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureFailedMethodName_R(Self: TTestFailure; var T: string);
begin T := Self.FailedMethodName; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureLineNumber_W(Self: TTestFailure; const T: longint);
begin Self.LineNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureLineNumber_R(Self: TTestFailure; var T: longint);
begin T := Self.LineNumber; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureSourceUnitName_W(Self: TTestFailure; const T: string);
begin Self.SourceUnitName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureSourceUnitName_R(Self: TTestFailure; var T: string);
begin T := Self.SourceUnitName; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureExceptionClassName_R(Self: TTestFailure; var T: string);
begin T := Self.ExceptionClassName; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureExceptionMessage_R(Self: TTestFailure; var T: string);
begin T := Self.ExceptionMessage; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureIsFailure_R(Self: TTestFailure; var T: boolean);
begin T := Self.IsFailure; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureAsString_R(Self: TTestFailure; var T: string);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TTestFailureExceptionClass_R(Self: TTestFailure; var T: TClass);
begin T := Self.ExceptionClass; end;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertException1_P(Self: TAssert;  AExceptionClass : ExceptClass; AMethod : TRunMethod);
Begin Self.AssertException(AExceptionClass, AMethod); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertException_P(Self: TAssert;  const AMessage : string; AExceptionClass : ExceptClass; AMethod : TRunMethod);
Begin Self.AssertException(AMessage, AExceptionClass, AMethod); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNotNull1_P(Self: TAssert;  const AString : string);
Begin Self.AssertNotNull(AString); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNotNull_P(Self: TAssert;  const AMessage, AString : string);
Begin Self.AssertNotNull(AMessage, AString); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNull4_P(Self: TAssert;  APointer : Pointer);
Begin Self.AssertNull(APointer); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNull3_P(Self: TAssert;  const AMessage : string; APointer : Pointer);
Begin Self.AssertNull(AMessage, APointer); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNullIntf1_P(Self: TAssert;  AInterface : IInterface);
Begin Self.AssertNullIntf(AInterface); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNullIntf_P(Self: TAssert;  const AMessage : string; AInterface : IInterface);
Begin Self.AssertNullIntf(AMessage, AInterface); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNull1_P(Self: TAssert;  AObject : TObject);
Begin Self.AssertNull(AObject); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNull_P(Self: TAssert;  const AMessage : string; AObject : TObject);
Begin Self.AssertNull(AMessage, AObject); END;

(*----------------------------------------------------------------------------*)
//Procedure TAssertAssertNotNull1_P(Self: TAssert;  APointer : Pointer);
//Begin Self.AssertNotNull(APointer); END;

(*----------------------------------------------------------------------------*)
//Procedure TAssertAssertNotNull_P(Self: TAssert;  const AMessage : string; APointer : Pointer);
//Begin Self.AssertNotNull(AMessage, APointer); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNotNullIntf1_P(Self: TAssert;  AInterface : IInterface);
Begin Self.AssertNotNullIntf(AInterface); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNotNullIntf_P(Self: TAssert;  const AMessage : string; AInterface : IInterface);
Begin Self.AssertNotNullIntf(AMessage, AInterface); END;

(*----------------------------------------------------------------------------*)
//Procedure TAssertAssertNotNull1_P(Self: TAssert;  AObject : TObject);
//Begin Self.AssertNotNull(AObject); END;

(*----------------------------------------------------------------------------*)
//Procedure TAssertAssertNotNull_P(Self: TAssert;  const AMessage : string; AObject : TObject);
//Begin Self.AssertNotNull(AMessage, AObject); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNotSame3_P(Self: TAssert;  Expected, Actual : Pointer);
Begin Self.AssertNotSame(Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNotSame2_P(Self: TAssert;  const AMessage : string; Expected, Actual : Pointer);
Begin Self.AssertNotSame(AMessage, Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNotSame1_P(Self: TAssert;  Expected, Actual : TObject);
Begin Self.AssertNotSame(Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertNotSame_P(Self: TAssert;  const AMessage : string; Expected, Actual : TObject);
Begin Self.AssertNotSame(AMessage, Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertSame3_P(Self: TAssert;  Expected, Actual : Pointer);
Begin Self.AssertSame(Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertSame2_P(Self: TAssert;  const AMessage : string; Expected, Actual : Pointer);
Begin Self.AssertSame(AMessage, Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertSame1_P(Self: TAssert;  Expected, Actual : TObject);
Begin Self.AssertSame(Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertSame_P(Self: TAssert;  const AMessage : string; Expected, Actual : TObject);
Begin Self.AssertSame(AMessage, Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals15_P(Self: TAssert;  Expected, Actual : TClass);
Begin Self.AssertEquals(Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals14_P(Self: TAssert;  const AMessage : string; Expected, Actual : TClass);
Begin Self.AssertEquals(AMessage, Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals13_P(Self: TAssert;  Expected, Actual : char);
Begin Self.AssertEquals(Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals12_P(Self: TAssert;  const AMessage : string; Expected, Actual : char);
Begin Self.AssertEquals(AMessage, Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals11_P(Self: TAssert;  Expected, Actual : boolean);
Begin Self.AssertEquals(Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals10_P(Self: TAssert;  const AMessage : string; Expected, Actual : boolean);
Begin Self.AssertEquals(AMessage, Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals9_P(Self: TAssert;  Expected, Actual, Delta : double);
Begin Self.AssertEquals(Expected, Actual, Delta); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals8_P(Self: TAssert;  const AMessage : string; Expected, Actual, Delta : double);
Begin Self.AssertEquals(AMessage, Expected, Actual, Delta); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals7_P(Self: TAssert;  Expected, Actual : currency);
Begin Self.AssertEquals(Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals6_P(Self: TAssert;  const AMessage : string; Expected, Actual : currency);
Begin Self.AssertEquals(AMessage, Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals5_P(Self: TAssert;  Expected, Actual : int64);
Begin Self.AssertEquals(Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals4_P(Self: TAssert;  const AMessage : string; Expected, Actual : int64);
Begin Self.AssertEquals(AMessage, Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals3_P(Self: TAssert;  Expected, Actual : integer);
Begin Self.AssertEquals(Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals2_P(Self: TAssert;  const AMessage : string; Expected, Actual : integer);
Begin Self.AssertEquals(AMessage, Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals1_P(Self: TAssert;  Expected, Actual : string);
Begin Self.AssertEquals(Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertEquals_P(Self: TAssert;  const AMessage : string; Expected, Actual : string);
Begin Self.AssertEquals(AMessage, Expected, Actual); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertFalse1_P(Self: TAssert;  ACondition : boolean);
Begin Self.AssertFalse(ACondition); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertFalse_P(Self: TAssert;  const AMessage : string; ACondition : boolean);
Begin Self.AssertFalse(AMessage, ACondition); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertTrue1_P(Self: TAssert;  ACondition : boolean);
Begin Self.AssertTrue(ACondition); END;

(*----------------------------------------------------------------------------*)
Procedure TAssertAssertTrue_P(Self: TAssert;  const AMessage : string; ACondition : boolean);
Begin Self.AssertTrue(AMessage, ACondition); END;

(*----------------------------------------------------------------------------*)
procedure TTestLastStep_R(Self: TTest; var T: TTestStep);
begin T := Self.LastStep; end;

(*----------------------------------------------------------------------------*)
procedure TTestTestSuiteName_W(Self: TTest; const T: string);
begin Self.TestSuiteName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTestTestSuiteName_R(Self: TTest; var T: string);
begin T := Self.TestSuiteName; end;

(*----------------------------------------------------------------------------*)
procedure TTestTestName_R(Self: TTest; var T: string);
begin T := Self.TestName; end;

(*----------------------------------------------------------------------------*)
Function EAssertionFailedErrorCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const msg : string):TObject;
Begin Result := EAssertionFailedError.Create(msg); END;

(*----------------------------------------------------------------------------*)
Function EAssertionFailedErrorCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := EAssertionFailedError.Create; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_fpcunit_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ComparisonMsg, 'ComparisonMsg', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTestResult(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTestResult) do
  begin
    RegisterVirtualConstructor(@TTestResult.Create, 'Create');
    RegisterPropertyHelper(@TTestResultListeners_R,nil,'Listeners');
    RegisterMethod(@TTestResult.ClearErrorLists, 'ClearErrorLists');
    RegisterMethod(@TTestResult.StartTest, 'StartTest');
    RegisterMethod(@TTestResult.AddFailure, 'AddFailure');
    RegisterMethod(@TTestResult.AddError, 'AddError');
    RegisterMethod(@TTestResult.EndTest, 'EndTest');
    RegisterMethod(@TTestResult.AddListener, 'AddListener');
    RegisterMethod(@TTestResult.RemoveListener, 'RemoveListener');
    RegisterMethod(@TTestResult.Run, 'Run');
    RegisterMethod(@TTestResult.RunProtected, 'RunProtected');
    RegisterMethod(@TTestResult.WasSuccessful, 'WasSuccessful');
    RegisterMethod(@TTestResult.SkipTest, 'SkipTest');
    RegisterMethod(@TTestResult.AddToSkipList, 'AddToSkipList');
    RegisterMethod(@TTestResult.RemoveFromSkipList, 'RemoveFromSkipList');
    RegisterPropertyHelper(@TTestResultFailures_R,nil,'Failures');
    RegisterPropertyHelper(@TTestResultErrors_R,nil,'Errors');
    RegisterPropertyHelper(@TTestResultRunTests_R,nil,'RunTests');
    RegisterPropertyHelper(@TTestResultNumberOfErrors_R,nil,'NumberOfErrors');
    RegisterPropertyHelper(@TTestResultNumberOfFailures_R,nil,'NumberOfFailures');
    RegisterPropertyHelper(@TTestResultNumberOfSkippedTests_R,nil,'NumberOfSkippedTests');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTestSuite(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTestSuite) do
  begin
    RegisterVirtualConstructor(@TTestSuiteCreate_P, 'Create');
    RegisterVirtualConstructor(@TTestSuiteCreate1_P, 'Create1');
    RegisterVirtualConstructor(@TTestSuiteCreate2_P, 'Create2');
    RegisterVirtualConstructor(@TTestSuiteCreate3_P, 'Create3');
    RegisterVirtualConstructor(@TTestSuiteCreate4_P, 'Create4');
    RegisterMethod(@TTestSuite.CountTestCases, 'CountTestCases');
    RegisterMethod(@TTestSuite.Run, 'Run');
    RegisterVirtualMethod(@TTestSuite.RunTest, 'RunTest');
    RegisterVirtualMethod(@TTestSuiteAddTest_P, 'AddTest');
    RegisterVirtualMethod(@TTestSuite.AddTestSuiteFromClass, 'AddTestSuiteFromClass');
    RegisterMethod(@TTestSuite.Warning, 'Warning');
    RegisterPropertyHelper(@TTestSuiteTest_R,nil,'Test');
    RegisterPropertyHelper(@TTestSuiteTestSuiteName_R,@TTestSuiteTestSuiteName_W,'TestSuiteName');
    RegisterPropertyHelper(@TTestSuiteTestName_R,@TTestSuiteTestName_W,'TestName');
    RegisterPropertyHelper(@TTestSuiteTests_R,nil,'Tests');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTestCase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTestCase) do
  begin
    RegisterVirtualConstructor(@TTestCase.Create, 'Create');
    RegisterVirtualConstructor(@TTestCase.CreateWith, 'CreateWith');
    RegisterVirtualConstructor(@TTestCase.CreateWithName, 'CreateWithName');
    RegisterMethod(@TTestCase.CountTestCases, 'CountTestCases');
    RegisterVirtualMethod(@TTestCase.CreateResultAndRun, 'CreateResultAndRun');
    RegisterMethod(@TTestCase.Run, 'Run');
    RegisterMethod(@TTestCase.AsString, 'AsString');
    RegisterPropertyHelper(@TTestCaseTestSuiteName_R,@TTestCaseTestSuiteName_W,'TestSuiteName');
    RegisterPropertyHelper(@TTestCaseTestName_R,@TTestCaseTestName_W,'TestName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTestFailure(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTestFailure) do
  begin
    RegisterConstructor(@TTestFailure.CreateFailure, 'CreateFailure');
    RegisterPropertyHelper(@TTestFailureExceptionClass_R,nil,'ExceptionClass');
    RegisterPropertyHelper(@TTestFailureAsString_R,nil,'AsString');
    RegisterPropertyHelper(@TTestFailureIsFailure_R,nil,'IsFailure');
    RegisterPropertyHelper(@TTestFailureExceptionMessage_R,nil,'ExceptionMessage');
    RegisterPropertyHelper(@TTestFailureExceptionClassName_R,nil,'ExceptionClassName');
    RegisterPropertyHelper(@TTestFailureSourceUnitName_R,@TTestFailureSourceUnitName_W,'SourceUnitName');
    RegisterPropertyHelper(@TTestFailureLineNumber_R,@TTestFailureLineNumber_W,'LineNumber');
    RegisterPropertyHelper(@TTestFailureFailedMethodName_R,@TTestFailureFailedMethodName_W,'FailedMethodName');
    RegisterPropertyHelper(@TTestFailureTestLastStep_R,@TTestFailureTestLastStep_W,'TestLastStep');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAssert(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAssert) do
  begin
    RegisterMethod(@TAssert.Fail, 'Fail');
    RegisterMethod(@TAssertAssertTrue_P, 'AssertTrue');
    RegisterMethod(@TAssertAssertTrue1_P, 'AssertTrue1');
    RegisterMethod(@TAssertAssertFalse_P, 'AssertFalse');
    RegisterMethod(@TAssertAssertFalse1_P, 'AssertFalse1');
    RegisterMethod(@TAssertAssertEquals_P, 'AssertEquals');
    RegisterMethod(@TAssertAssertEquals1_P, 'AssertEquals1');
    RegisterMethod(@TAssertAssertEquals2_P, 'AssertEquals2');
    RegisterMethod(@TAssertAssertEquals3_P, 'AssertEquals3');
    RegisterMethod(@TAssertAssertEquals4_P, 'AssertEquals4');
    RegisterMethod(@TAssertAssertEquals5_P, 'AssertEquals5');
    RegisterMethod(@TAssertAssertEquals6_P, 'AssertEquals6');
    RegisterMethod(@TAssertAssertEquals7_P, 'AssertEquals7');
    RegisterMethod(@TAssertAssertEquals8_P, 'AssertEquals8');
    RegisterMethod(@TAssertAssertEquals9_P, 'AssertEquals9');
    RegisterMethod(@TAssertAssertEquals10_P, 'AssertEquals10');
    RegisterMethod(@TAssertAssertEquals11_P, 'AssertEquals11');
    RegisterMethod(@TAssertAssertEquals12_P, 'AssertEquals12');
    RegisterMethod(@TAssertAssertEquals13_P, 'AssertEquals13');
    RegisterMethod(@TAssertAssertEquals14_P, 'AssertEquals14');
    RegisterMethod(@TAssertAssertEquals15_P, 'AssertEquals15');
    RegisterMethod(@TAssertAssertSame_P, 'AssertSame');
    RegisterMethod(@TAssertAssertSame1_P, 'AssertSame1');
    RegisterMethod(@TAssertAssertSame2_P, 'AssertSame2');
    RegisterMethod(@TAssertAssertSame3_P, 'AssertSame3');
    RegisterMethod(@TAssertAssertNotSame_P, 'AssertNotSame');
    RegisterMethod(@TAssertAssertNotSame1_P, 'AssertNotSame1');
    RegisterMethod(@TAssertAssertNotSame2_P, 'AssertNotSame2');
    RegisterMethod(@TAssertAssertNotSame3_P, 'AssertNotSame3');
    RegisterMethod(@TAssertAssertNotNull_P, 'AssertNotNull');
    RegisterMethod(@TAssertAssertNotNull1_P, 'AssertNotNull1');
    RegisterMethod(@TAssertAssertNotNullIntf_P, 'AssertNotNullIntf');
    RegisterMethod(@TAssertAssertNotNullIntf1_P, 'AssertNotNullIntf1');
    RegisterMethod(@TAssertAssertNotNull_P, 'AssertNotNull');
    RegisterMethod(@TAssertAssertNotNull1_P, 'AssertNotNull1');
    RegisterMethod(@TAssertAssertNull_P, 'AssertNull');
    RegisterMethod(@TAssertAssertNull1_P, 'AssertNull1');
    RegisterMethod(@TAssertAssertNullIntf_P, 'AssertNullIntf');
    RegisterMethod(@TAssertAssertNullIntf1_P, 'AssertNullIntf1');
    RegisterMethod(@TAssertAssertNull3_P, 'AssertNull3');
    RegisterMethod(@TAssertAssertNull4_P, 'AssertNull4');
    RegisterMethod(@TAssertAssertNotNull_P, 'AssertNotNull');
    RegisterMethod(@TAssertAssertNotNull1_P, 'AssertNotNull1');
    RegisterMethod(@TAssertAssertException_P, 'AssertException');
    RegisterMethod(@TAssertAssertException1_P, 'AssertException1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTest) do
  begin
    RegisterVirtualMethod(@TTest.CountTestCases, 'CountTestCases');
    RegisterVirtualMethod(@TTest.Run, 'Run');
    RegisterPropertyHelper(@TTestTestName_R,nil,'TestName');
    RegisterPropertyHelper(@TTestTestSuiteName_R,@TTestTestSuiteName_W,'TestSuiteName');
    RegisterPropertyHelper(@TTestLastStep_R,nil,'LastStep');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EAssertionFailedError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EAssertionFailedError) do
  begin
    RegisterConstructor(@EAssertionFailedErrorCreate_P, 'Create');
    RegisterConstructor(@EAssertionFailedErrorCreate1_P, 'Create1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_fpcunit(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EAssertionFailedError(CL);
  with CL.Add(TTestResult) do
  RIRegister_TTest(CL);
  RIRegister_TAssert(CL);
  RIRegister_TTestFailure(CL);
  RIRegister_TTestCase(CL);
  RIRegister_TTestSuite(CL);
  RIRegister_TTestResult(CL);
end;

 
 
{ TPSImport_fpcunit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_fpcunit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_fpcunit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_fpcunit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_fpcunit_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
