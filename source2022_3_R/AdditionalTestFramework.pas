unit AdditionalTestFramework;

interface

uses
  TestFramework, Classes, StrUtils;

type
  IApplicationProperties = interface(IUnknown)
    ['{8FADE3D2-D3E6-4141-A3DE-6C348069EF96}']
    procedure SetProperties( props: TStrings );
    function  GetProperties: TStrings;
  end;

  TFilteredTestSuite = class(TTestSuite)
  private
    function CommandLine: String;
    function GetRunPattern(CMD: String): String;
  public
    procedure FilterTests; virtual;
    procedure AddTests(testClass: TTestCaseClass); override;
  end;

  TAppPropsTestCase = class(TTestCase, IApplicationProperties)
  protected
    FProperties: TStrings;
    FContext: String;
    FLogFileName: String;
    procedure SetUp; override;
    function GetUserToken: WideString; virtual;
  public
    procedure SetProperties( props: TStrings );
    function  GetProperties: TStrings;

    property Properties: TStrings read getProperties;
    class function Suite: ITestSuite; override;
  end;



  TInterval = class(TObject)
  private
    FStart: TDateTime;
    FStop: TDateTime;

    function GetTotalSeconds: Int64;
    function GetTotalMinuets: Int64;
    function GetTotalHours: Int64;
    function GetTimeSpan: TDateTime;
  public
    constructor Create;
    procedure Start;
    procedure Stop;
    procedure Clear;
    property TimeSpan: TDateTime read GetTimeSpan;
    property TotalSeconds: Int64 read GetTotalSeconds;
    property TotalMinuets: Int64 read GetTotalMinuets;
    property TotalHours: Int64 read GetTotalHours;
    function ToString: String; overload;
  end;


const
  SelectSwitch = '-S:';


//for reporting
procedure SetTestingArea(sArea: String);
procedure SetContext(AContext: String);
function  GetPropertyValue(Key: String): String;
procedure SetPropertyValue(Key: String; Value: String);
procedure CopyAppProperties(Destination: TStrings);

var
  sTestingArea: String;
  sContext: String;


implementation

uses
  SysUtils, Windows, DateUtils;

var
  //global properties object that is passed into tests
  AppProperties: TStringList;

procedure BuildPropertiesFromCommandLine;
var
  I: Integer;
  S: String;
begin
  if not Assigned(AppProperties) then
    AppProperties := TStringList.Create;

    //loop thorugh cmd params and initialize name=value pairs and insert into properites object
    for I := 0 to ParamCount  do
      if Pos('=',ParamStr(I)) > 0 then
        S := S + ParamStr(I) + ' ';
    // assign sTemp to delim text ( space is considered valid line break )
    AppProperties.DelimitedText := Trim(S);
end;

function  GetPropertyValue(Key: String): String;
begin
  Result := AppProperties.Values[Key];
end;

procedure SetPropertyValue(Key: String; Value: String);
begin
  AppProperties.Values[Trim(Key)] := Trim(Value);
end;

procedure SetTestingArea( sArea: String );
begin
  sTestingArea := sArea;
end;

procedure SetContext(AContext: String);
begin
  sContext := AContext;
end;

procedure CopyAppProperties(Destination: TStrings);
begin
  if Assigned(Destination) then
    Destination.AddStrings(AppProperties);
end;


{ TBorlandTestCase }

function TAppPropsTestCase.GetUserToken: WideString;
var
  UserName: WideString;
const
  MAXTokenLength = 8;
begin
  UserName := GetEnvironmentVariable('USERNAME');
  UserName := StringReplace(UserName, '-', '_', []);
  if Length(UserName) > MAXTokenLength then
    UserName := LeftStr(UserName,MAXTokenLength)
  else if UserName = '' then
    UserName := 'Tmp' + IntToStr(Random(9)) + IntToStr(Random(9));

  //Changing to return a trimmed down user token per Steve's request 
  Result := UserName;
end;

function TAppPropsTestCase.getProperties: TStrings;
begin
  if not Assigned(FProperties) then
    FProperties := TStringList.Create;
  Result := fProperties;
end;


procedure TAppPropsTestCase.SetProperties(Props: TStrings);
begin
  if not Assigned(FProperties) then
    FProperties := TStringList.Create;
  if Assigned(Props) then
    FProperties.AddStrings(Props);
end;

procedure TAppPropsTestCase.SetUp;
begin
  inherited;
  if Supports(Self,IApplicationProperties) then
    (Self as IApplicationProperties).SetProperties( AppProperties );
end;

class function TAppPropsTestCase.Suite: ITestSuite;
begin
  Result := TFilteredTestSuite.Create(Self);
end;

{ TBorlandTestSuite }


procedure TFilteredTestSuite.AddTests(TestClass: TTestCaseClass);
var
  MethodIter     :  Integer;
  NameOfMethod   :  string;
  MethodEnumerator:  TMethodEnumerator;
  TestCase       : ITest;
begin
  { call on the method enumerator to get the names of the test
    cases in the testClass }
  MethodEnumerator := nil;
  try
    MethodEnumerator := TMethodEnumerator.Create(TestClass);
    { make sure we add each test case  to the list of tests }
    for MethodIter := 0 to MethodEnumerator.Methodcount-1 do
    begin
      NameOfMethod := MethodEnumerator.nameOfMethod[MethodIter];
      TestCase := TestClass.Create(NameOfMethod) as ITest;
      if Supports(TestCase,IApplicationProperties) then
        (TestCase as IApplicationProperties).setProperties( AppProperties );
      Self.AddTest(TestCase);
    end;
  finally
    MethodEnumerator.Free;
  end;
  FilterTests;
end;

function TFilteredTestSuite.CommandLine: String;
var
  S: String;
begin
  {$IFDEF WIN32}
    S := getcommandline;
  {$ELSE}
    S := System.Runtime.InteropServices.Marshal.PtrToStringUni(GetCommandLine);
  {$ENDIF}
   Result := Trim(S);
end;

procedure TFilteredTestSuite.FilterTests;
var
  I    : Integer;
  List : IInterfaceList;
  sCMD : String;
  Pattern: String;
  WildCardPos: Integer;
begin
  if ParamCount > 0 then
  begin
    sCMD := CommandLine;
    if Pos(SelectSwitch,UpperCase(sCMD)) > 1 then
    begin
      List := Tests;
      Pattern := UpperCase(GetRunPattern(sCMD));
      WildCardPos := Pos('*',Pattern);
      //if the pattern shows up in the method name then it gets run
      //think pattern= RAID and methond name is RAID_123423
      for I := 0 to List.Count - 1 do
      begin
        //implicit wild card, so if -s:Raid is passed then works like Raid*
        // Name=Raid_XXXX is accepted, Name=oRaid_XXXX is not accepted
        // aslo requires that first character and on matches pattern
        (List.Items[I] as ITest).Enabled :=
          Pos(Pattern,UpperCase((List.Items[I] as ITest).Name)) = 1;

        //wild card was passed, so -s:*Raid or -s:Ra*id
        //todo: solve this problem. For now not supported
        if (WildCardPos > 0) and not (List.Items[I] as ITest).Enabled then
        begin
          Writeln('* not supported in -s: param');
        end;
      end;
    end;
  end
  else
    Exit;
end;

function TFilteredTestSuite.GetRunPattern(CMD: String): String;
var
  S: String;
  I : Integer;
begin
  // extract suite and test case info
  S := Uppercase(CMD);
  Delete(S,1, Pos(SelectSwitch,S)+Length(SelectSwitch)-1);
  I := Pos(' ',S);
  if I > 1 then // clean up items that might come after -s:asdfsd Name=Value
    Delete(S,I,Length(S));
  Result := S;
end;


{ TInterval }

procedure TInterval.Clear;
begin
  FStart := 0;
  FStop := 0;
end;

constructor TInterval.Create;
begin
  inherited;
  Clear;
end;

function TInterval.GetTimeSpan: TDateTime;
begin
  Assert( FStop > FStart );
  Result := FStop - FStart;
end;

function TInterval.GetTotalHours: Int64;
begin
  Result := HoursBetween(FStart,FStop);
end;

function TInterval.GetTotalMinuets: Int64;
begin
  Result := MinutesBetween(FStart,FStop);
end;

function TInterval.GetTotalSeconds: Int64;
begin
  Result := SecondsBetween(FStart,FStop);
end;

procedure TInterval.Start;
begin
  FStart := Now;
end;

procedure TInterval.Stop;
begin
  FStop := Now;
end;

function TInterval.ToString: String;
var
  H,M,S,MS: Word;
const
  TimeFormat = '%d:%d:%d.%d';
begin
  DecodeTime( FStop - FStart,H,M,S,MS );
  Result := Format(TimeFormat,[H,M,S,MS]);
end;



initialization
  BuildPropertiesFromCommandLine;
finalization
  if Assigned(AppProperties) then
    AppProperties.Free;

end.
