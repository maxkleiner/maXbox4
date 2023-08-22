unit niTestCase;

interface

uses Classes, SysUtils, Contnrs;

type

TniTestCaseResult = class;

// ==============================================================================================
// Procedure Type: TniTestProcedure
// ================================

{: Useful Procedure type for declaring tests }
TniTestProcedure = procedure( const sTest: string) of object;

// ==============================================================================================
// Abstract Class: TniCustomTestCase
// =================================

{: Abstract ancestor for all test classes }

TniTestCase = class( TObject)
private

  // Properties

  FsName:        string;

  FoTestCases:   TObjectList;
  FoParent:      TniTestCase;

  FbCheckingInvariants: boolean;

  FoResults:     TObjectList;
  FiPassCount:   integer;
  FiFailCount:   integer;
  FiCheckpoints: integer;

protected

  // Property Methods

  {: Get method for <see property=TestCaseCount> property }
  function GetTestCaseCount: integer;

  {: Get method for <see property=TestCases> property }
  function GetTestCaseByIndex( iIndex: integer): TniTestCase;

  {: Get method for <see property=TestCount> property }
  function GetResultCount: integer;

  {: Get method for <see property=Results> property }
  function GetResultByIndex( iIndex: integer): TniTestCaseResult;

  // Descendent Methods

  {: Prepare the test to run.
     Carry out any preparation required to run the test. Override this as required in any
     descendant}
  procedure Setup; virtual;

  {: Run actual tests for this case.
     Do all of the actions required for the test. }
  procedure RunTest; virtual;

  {: Clean up after the test.
     Tidy up after the test is complete - usually to dispose of any resources allocated by the
     <see Method=Setup> method. Override this as required in any descendant. }
  procedure Cleanup; virtual;

  {: Connect a test case to us for running }
  procedure ConnectTestCase( oTestCase: TniTestCase);

  {: Disconnect a test case }
  procedure DisconnectTestCase( oTestCase: TniTestCase);

  // Test status methods

  {: Log a test failure
     @param sMessage Description of failure }
  procedure Fail( const sMessage: string); overload;

  {: Log a test failure
     @param sMessage Description of failure
     @param acParameters Parameters to substitute for place holders in sMessage
     @see The Format function for placeholder usage }
  procedure Fail( const sMessage: string; acxParameters: array of const); overload;

  {: Log test success
     @param sMessage Description of success }
  procedure Pass( const sMessage: string); overload;

  {: Log a test success
     @param sMessage Description of pass
     @param acParameters Parameters to substitute for place holders in sMessage
     @see The Format function for placeholder usage }
  procedure Pass( const sMessage: string; acxParameters: array of const); overload;

  {: Log checkpoint
     @param sMessage Description of checkpoint }
  procedure Checkpoint( const sMessage: string); overload;

  {: Log checkpoint
     @param sMessage Description of checkpoint
     @param acParameters Parameters to substitute for place holders in sMessage
     @see The Format function for placeholder usage }
  procedure Checkpoint( const sMessage: string; acxParameters: array of const); overload;

  {: Invoke <see method=VerifyInvariants> to check invariants for the test case with checks
     to avoid recursion. }
  procedure CheckInvariants;

  {: Perform a sequence of tests
     @param asSequence Sequence of tests to perform
     @param xTestProcedure Test to perform }
  procedure TestSequence( asSequence: array of string; xTestProcedure: TniTestProcedure);

  // Verification methods

  {: Check class invariants
     Perform all invariant tests which should be satisfied by the test at all times }
  procedure VerifyInvariants; virtual;

  {: Check a condition is true
     @param bCondition Condition to check
     @param sMessage Optional Description of test }
  procedure Verify( bCondition: boolean; const sMessage: string = '');

  {: Check two string values are the same
     @param sReference Expected Value
     @param sResult Obtained Value
     @param sMessage Optional description of test }
  procedure VerifyEquals( const sReference: string; const sResult: string;
                          const sMessage: string = ''); overload;

  {: Check two integer values are the same
     @param iReference Expected Value
     @param iResult Obtained Value
     @param sMessage Optional description of test }
  procedure VerifyEquals( iReference: integer; const iResult: integer;
                          const sMessage: string = ''); overload;

  {: Check two floating point values are sufficiently close
     @param nReference Expected Value
     @param nResult Obtained Value
     @param nDelta Permissible absolute difference
     @param sMessage Optional description of test }
  procedure VerifyEquals( nReference: double; const nResult: double; nDelta: double;
                          const sMessage: string = ''); overload;

  {: Check a pointer reference is nil
     @param pPointer Reference to check
     @param sMessage Optional description of test }
  procedure VerifyNil( pPointer: pointer; const sMessage: string = ''); overload;

  {: Check an object reference is null
     @param pPointer Reference to check
     @param sMessage Optional description of test }
  procedure VerifyNil( oInstance: TObject; const sMessage: string = ''); overload;

  {: Check a pointer reference is not nil
     @param pPointer Reference to check
     @param sMessage Optional description of test }
  procedure VerifyAssigned( pPointer: pointer; const sMessage: string = ''); overload;

  {: Check an object reference is not nil
     @param pPointer Reference to check
     @param sMessage Optional description of test }
  procedure VerifyAssigned( oInstance: TObject; const sMessage: string = ''); overload;

  {: Check that an exception occured - or did not occur..
     Call this method immediately after an exception should have occurred (or in a handler
     for an unexpected exception) - if the method is invoked at all, it logs a failure.
     @param sMessage Optional description of test }
  procedure VerifyException( const sMessage: string = '');

  {: Check that two pointer references are the same object
     @param pReference Reference pointer
     @param pResult    Result pointer }
  procedure VerifyObject( pReference: pointer; pResult: pointer;
                          const sMessage: string =''); overload;

  {: Check that two object references are the same object
     @param oReference Reference pointer
     @param oResult    Result pointer }
  procedure VerifyObject( oReference: TObject; oResult: TObject;
                          const sMessage: string =''); overload;


public

  // Standard Methods

  {: Standard constructor }
  constructor Create( const sName: string); overload;

  {: Sub-TestCase constructor }
  constructor Create( oParentTestCase: TniTestCase; const sName: string); overload; virtual;

  {: Standard destructor }
  destructor Destroy; override;

  // Test Methods

  {: Perform the test
     @param Instantiated TStrings to receive the test results }
  procedure Test;

  // Properties

  {: Name of test }
  property Name: string read FsName;

  {: Count of child Test Cases }
  property TestCaseCount: integer read GetTestCaseCount;

  {: Indexed access to child Test Cases }
  property TestCases[ iIndex: integer]: TniTestCase read GetTestCaseByIndex;

  {: Number of Tests completed by this node }
  property ResultCount: integer read GetResultCount;

  {: Indexed access to test results }
  property Results[ iIndex: integer]: TniTestCaseResult read GetResultByIndex;

  {: Count of passes }
  property PassCount: integer read FiPassCount;

  {: Count of fails }
  property FailCount: integer read FiFailCount;

  {: Count of Checkpoints }
  property Checkpoints: integer read FiCheckPoints;

end;

// ==============================================================================================
// Enumeration: TniTestResult
// ==========================

TniTestResult = (trFail, trPass, trCheckPoint);

// ==============================================================================================
// Class Type: TniTestCaseClass
// ============================

TniTestCaseClass = class of TniTestCase;

// ==============================================================================================
// Class: TniTestCaseResult
// ========================

{: Result of a test }

TniTestCaseResult = class( TObject)
private

  // Properties

  FeResult:      TniTestResult;
  FsDescription: string;

public

  // Standard methods

  constructor Create( eResult: TniTestResult; sDescription: string);

  // Properties

  property Result: TniTestResult read FeResult;

  property Description: string read FsDescription;

end;

// ==============================================================================================

implementation

// ==============================================================================================
// Routines
// ========

function StrEmpty( const sString: string): boolean;
begin
  Result := Trim(sString)='';
end;

// ==============================================================================================
// Abstract Class: TniCustomTest
// =============================

// Standard Methods
// ----------------

constructor TniTestCase.Create( const sName: string);
begin
  Create( nil, sName);
end;

constructor TniTestCase.Create( oParentTestCase: TniTestCase; const sName: string);
begin
  inherited Create;

  FoParent := oParentTestCase;
  if Assigned( FoParent) then
    FoParent.ConnectTestCase( self);

  FsName := sName;
  FoResults := TObjectList.Create;
  FoTestCases := TObjectList.Create( true);

  FiPassCount := 0;
  FiFailCount := 0;
  FiCheckpoints := 0;

end;

destructor TniTestCase.Destroy;
begin
  FoResults.Free;
  FoTestCases.Free;

  if Assigned( FoParent) then
    FoParent.DisconnectTestCase( self);

  inherited Destroy;
end;

// Test Methods
// ------------

procedure TniTestCase.Test;
var
  iScan: integer;
begin
  // Run local tests

  try
    Setup;
  except
    on E:Exception do
      Fail( 'Unexpected %s exception: %s', [ E.ClassName, E.Message ]);
  end;
  
  try
    try
      RunTest;
    except
      on E:Exception do
        Fail( 'Unexpected %s exception: %s', [ E.ClassName, E.Message ]);
    end;
  finally
    CleanUp;
  end;

  // Run Child tests

  for iScan := 0 to TestCaseCount-1 do
    try
      TestCases[iScan].Test;
    except
      on E:Exception do
        Fail( 'Unexpected %s exception %s running Test Case %s',
              [ E.ClassName, E.Message, TestCases[iScan].Name ]);
    end;

end;

// Descendent Methods
// ------------------

procedure TniTestCase.Setup;
begin
  // No standard setup
end;

procedure TniTestCase.RunTest;
begin
  // No standard tests
end;

procedure TniTestCase.Cleanup;
begin
  // No standard cleanup
end;

procedure TniTestCase.ConnectTestCase( oTestCase: TniTestCase);
begin
  Assert( FoTestCases.IndexOf( oTestCase)=-1,
          'TniTestCase.ConnectTestCase: '
          +'TestCase  '+oTestCase.Name+' is already linked to '+Name);
  FoTestCases.Add( oTestCase);
  Assert( FoTestCases.IndexOf( oTestCase)<>-1,
          'TniTestCase.ConnectTestCase: '
          +'TestCase  '+oTestCase.Name+' not added to '+Name);
end;

procedure TniTestCase.DisconnectTestCase( oTestCase: TniTestCase);
begin
  Assert( FoTestCases.IndexOf( oTestCase)=-1,
          'TniTestCase.DisconnectTestCase: '
          +'TestCase  '+oTestCase.Name+' is not linked to '+Name);
  FoTestCases.Remove( oTestCase);
  Assert( FoTestCases.IndexOf( oTestCase)<>-1,
          'TniTestCase.DisconnectTestCase: '
          +'TestCase  '+oTestCase.Name+' not removed from '+Name);
end;

// Test status methods
// -------------------

procedure TniTestCase.Fail( const sMessage: string);
var
  oResult: TniTestCaseResult;
begin
  oResult := TniTestCaseResult.Create( trFail, sMessage);
  FoResults.Add( oResult);
  Inc( FiFailCount);
  Assert( ResultCount = PassCount+FailCount+Checkpoints);
end;

procedure TniTestCase.Fail( const sMessage: string; acxParameters: array of const);
begin
  Fail( Format( sMessage, acxParameters));
end;

procedure TniTestCase.Pass( const sMessage: string);
var
  oResult: TniTestCaseResult;
begin
  oResult := TniTestCaseResult.Create( trPass, sMessage);
  FoResults.Add( oResult);
  Inc( FiPassCount);
  Assert( ResultCount = PassCount+FailCount+Checkpoints);
end;

procedure TniTestCase.Pass( const sMessage: string; acxParameters: array of const);
begin
  Pass( Format( sMessage, acxParameters));
end;

procedure TniTestCase.Checkpoint( const sMessage: string);
var
  oResult: TniTestCaseResult;
begin
  oResult := TniTestCaseResult.Create( trCheckpoint, sMessage);
  FoResults.Add( oResult);
  Inc( FiCheckpoints);
  Assert( ResultCount = PassCount+FailCount+Checkpoints);
end;

procedure TniTestCase.Checkpoint( const sMessage: string; acxParameters: array of const);
begin
  CheckPoint( Format( sMessage, acxParameters));
end;

procedure TniTestCase.CheckInvariants;
begin
  if not FbCheckingInvariants then begin
    FbCheckingInvariants := true;
    try
      VerifyInvariants;
    finally
      FbCheckingInvariants := false;
    end;
  end;
end;

procedure TniTestCase.TestSequence( asSequence: array of string;
                                    xTestProcedure: TniTestProcedure);
var
  iScan: integer;
begin
  for iScan := Low( asSequence) to High( asSequence) do begin
    try
      xTestProcedure( asSequence[iScan]);
    except
      on E: Exception do
        VerifyException( 'Unexpected '+E.ClassName+' exception: '+E.Message);
    end;
  end;
end;

// Verification methods
// --------------------

procedure TniTestCase.VerifyInvariants;
begin
  // No standard invariants
end;

procedure TniTestCase.Verify( bCondition: boolean; const sMessage: string = '');
begin
  CheckInvariants;
  if bCondition then
    Pass( sMessage)
  else Fail( sMessage);
end;

procedure TniTestCase.VerifyEquals( const sReference: string; const sResult: string;
                                    const sMessage: string = '');
var
  bCondition: boolean;
  sDiff:      string;
  iScan:      integer;
  iLength:    integer;
  sPrefix:    string;
begin
  bCondition := sReference = sResult;
  if not StrEmpty( sMessage) then begin
    Verify( bCondition, sMessage);
    sPrefix := '  ';
  end
  else sPrefix := '';
  if bCondition then
    Pass( sPrefix+'Verified: '''+sReference+'''')
  else begin
    Fail( sPrefix+'Expected: '''+sReference+'''');
    Fail( sPrefix+'Resulted: '''+sResult+'''');

    if Length(sReference) < Length( sResult) then
      iLength := Length( sReference)
    else iLength := Length( sResult);
    sDiff := StringOfChar('.', iLength);
    for iScan := 1 to iLength do
      if sReference[iScan]<>sResult[iScan] then
        sDiff[iScan] := 'X';
    Fail( sPrefix+'Diff Key:  '+sDiff);
  end;
end;

procedure TniTestCase.VerifyEquals( iReference: integer; const iResult: integer;
                                    const sMessage: string = '');
var
  bCondition: boolean;
begin
  bCondition := iReference = iResult;
  if StrEmpty( sMessage) then
    Verify( bCondition, Format( 'Expected %d; Result was %d', [ iReference, iResult ]))
  else Verify( bCondition, sMessage);
end;

procedure TniTestCase.VerifyEquals( nReference: double; const nResult: double; nDelta: double;
                                    const sMessage: string = '');
var
  bCondition: boolean;
begin
  bCondition := Abs(nReference-nResult)<nDelta;
  if StrEmpty( sMessage) then
    Verify( bCondition, Format( 'Expected %g; Result was %g (tolerance %g)',
                                [ nReference, nResult, nDelta ]))
  else Verify( bCondition, sMessage);
end;

procedure TniTestCase.VerifyNil( pPointer: pointer; const sMessage: string = '');
var
  bCondition: boolean;
begin
  bCondition := not Assigned( pPointer);
  if StrEmpty( sMessage) then
    Verify( bCondition, 'Expected Null pointer')
  else Verify( bCondition, sMessage);
end;

procedure TniTestCase.VerifyNil( oInstance: TObject; const sMessage: string = '');
var
  bCondition: boolean;
begin
  bCondition := not Assigned( oInstance);
  if StrEmpty( sMessage) then
    Verify( bCondition, 'Expected no Object (nil pointer)')
  else Verify( bCondition, sMessage);
end;

procedure TniTestCase.VerifyAssigned( pPointer: pointer; const sMessage: string = '');
var
  bCondition: boolean;
begin
  bCondition := Assigned( pPointer);
  if StrEmpty( sMessage) then
    Verify( bCondition, 'Expected Assigned pointer (non nil)')
  else Verify( bCondition, sMessage);
end;

procedure TniTestCase.VerifyAssigned( oInstance: TObject; const sMessage: string = '');
var
  bCondition: boolean;
begin
  bCondition := Assigned( oInstance);
  if StrEmpty( sMessage) then
    Verify( bCondition, 'Expected Object (non nil pointer)')
  else Verify( bCondition, sMessage);
end;

procedure TniTestCase.VerifyException( const sMessage: string = '');
begin
  if StrEmpty( sMessage) then
    Verify( false, 'Expected Exception - none occurred')
  else Verify( false, sMessage);
end;

procedure TniTestCase.VerifyObject( pReference: pointer; pResult: pointer;
                                    const sMessage: string ='');
var
  bCondition: boolean;
begin
  bCondition := pReference=pResult;
  if StrEmpty( sMessage) then
    Verify( bCondition, 'Expected pointers to be identical')
  else Verify( bCondition, sMessage);
end;

procedure TniTestCase.VerifyObject( oReference: TObject; oResult: TObject;
                                    const sMessage: string ='');
var
  bCondition: boolean;
begin
  bCondition := oReference=oResult;
  if StrEmpty( sMessage) then
    Verify( bCondition, 'Expected instances to be identical')
  else Verify( bCondition, sMessage);
end;

// Property Methods
// ----------------

function TniTestCase.GetTestCaseCount: integer;
begin
  Result := FoTestCases.Count;
end;

function TniTestCase.GetTestCaseByIndex( iIndex: integer): TniTestCase;
begin
  Result := FoTestCases[iIndex] as TniTestCase;
end;

function TniTestCase.GetResultCount: integer;
begin
  Result := FoResults.Count;
end;

function TniTestCase.GetResultByIndex( iIndex: integer): TniTestCaseResult;
begin
  Result := FoResults[iIndex] as TniTestCaseResult;
end;

// ==============================================================================================
// Class: TniTestCaseResult
// ========================

constructor TniTestCaseResult.Create( eResult: TniTestResult; sDescription: string);
var
  iScan: integer;
begin
  inherited Create;

  FeResult := eResult;
  FsDescription := sDescription;

  for iScan := Length( FsDescription) downto 1 do
    if not (FsDescription[iScan] in [' '..'~']) then
      Delete( FsDescription, iScan, 1);
end;

end.
