unit uPSI_BoldUtils;
{
  for persistence of BOLD you remember
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
  TPSImport_BoldUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBoldPassthroughNotifier(CL: TPSPascalCompiler);
procedure SIRegister_BoldUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BoldUtils_Routines(S: TPSExec);
procedure RIRegister_TBoldPassthroughNotifier(CL: TPSRuntimeClassImporter);
procedure RIRegister_BoldUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,TypInfo
  ,BoldDefs
  ,BoldUtils, uPSI_PerlRegEx
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BoldUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldPassthroughNotifier(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TBoldPassthroughNotifier') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TBoldPassthroughNotifier') do
  begin
    RegisterMethod('Constructor CreateWithEvent( NotificationEvent : TBoldNotificationEvent; Owner : TComponent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BoldUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TBoldNotificationEvent', 'Procedure ( AComponent : TComponent; O'
   +'peration : TOperation)');
  SIRegister_TBoldPassthroughNotifier(CL);
 CL.AddDelphiFunction('Function CharCount( c : char; const s : string) : integer');
 CL.AddDelphiFunction('Function BoldNamesEqual( const name1, name2 : string) : Boolean');
 CL.AddDelphiFunction('Procedure BoldAppendToStrings( strings : TStrings; const aString : string; const ForceNewLine : Boolean)');
 CL.AddDelphiFunction('Function BoldSeparateStringList( strings : TStringList; const Separator, PreString, PostString : String) : String');
 CL.AddDelphiFunction('Function BoldSeparatedAppend( const S1, S2 : string; const Separator : string) : string');
 CL.AddDelphiFunction('Function BoldTrim( const S : string) : string');
 CL.AddDelphiFunction('Function BoldIsPrefix( const S, Prefix : string) : Boolean');
 CL.AddDelphiFunction('Function BoldStrEqual( P1, P2 : PChar; Len : integer) : Boolean');
 CL.AddDelphiFunction('Function BoldStrAnsiEqual( P1, P2 : PChar; Len : integer) : Boolean');
 CL.AddDelphiFunction('Function BoldAnsiEqual( const S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function BoldStrStringEqual( const S1 : string; P2 : PChar; Len : integer) : Boolean');
 CL.AddDelphiFunction('Function BoldCaseIndependentPos( const Substr, S : string) : Integer');
 //CL.AddDelphiFunction('Procedure EnumToStrings( aTypeInfo : pTypeInfo; Strings : TStrings)');
 CL.AddDelphiFunction('Function CapitalisedToSpaced( Capitalised : String) : String');
 CL.AddDelphiFunction('Function SpacedToCapitalised( Spaced : String) : String');
 CL.AddDelphiFunction('Function BooleanToString( BoolValue : Boolean) : String');
 CL.AddDelphiFunction('Function StringToBoolean( StrValue : String) : Boolean');
 CL.AddDelphiFunction('Function GetUpperLimitForMultiplicity( const Multiplicity : String) : Integer');
 CL.AddDelphiFunction('Function GetLowerLimitForMultiplicity( const Multiplicity : String) : Integer');
 CL.AddDelphiFunction('Function StringListToVarArray( List : TStringList) : variant');
 CL.AddDelphiFunction('Function IsLocalMachine( const Machinename : WideString) : Boolean');
 CL.AddDelphiFunction('Function GetComputerNameStr : string');
 CL.AddDelphiFunction('Function TimeStampComp( const Time1, Time2 : TTimeStamp) : Integer');
 CL.AddDelphiFunction('Function BoldStrToDateFmt( const S : string; const DateFormat : string; const DateSeparatorChar : char) : TDateTime');
 CL.AddDelphiFunction('Function BoldDateToStrFmt( const aDate : TDateTime; DateFormat : string; const DateSeparatorChar : char) : String');
 CL.AddDelphiFunction('Function BoldParseFormattedDateList( const value : String; const formats : TStrings; var Date : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function BoldParseFormattedDate( const value : String; const formats : array of string; var Date : TDateTime) : Boolean');
 CL.AddDelphiFunction('Procedure EnsureTrailing( var Str : String; ch : char)');
 CL.AddDelphiFunction('Function BoldDirectoryExists( const Name : string) : Boolean');
 CL.AddDelphiFunction('Function BoldForceDirectories( Dir : string) : Boolean');
 CL.AddDelphiFunction('Function BoldRootRegistryKey : string');
 CL.AddDelphiFunction('Function GetModuleFileNameAsString( IncludePath : Boolean) : string');
 CL.AddDelphiFunction('Function BoldVariantToStrings( V : OleVariant; Strings : TStrings) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CharCount, 'CharCount', cdRegister);
 S.RegisterDelphiFunction(@BoldNamesEqual, 'BoldNamesEqual', cdRegister);
 S.RegisterDelphiFunction(@BoldAppendToStrings, 'BoldAppendToStrings', cdRegister);
 S.RegisterDelphiFunction(@BoldSeparateStringList, 'BoldSeparateStringList', cdRegister);
 S.RegisterDelphiFunction(@BoldSeparatedAppend, 'BoldSeparatedAppend', cdRegister);
 S.RegisterDelphiFunction(@BoldTrim, 'BoldTrim', cdRegister);
 S.RegisterDelphiFunction(@BoldIsPrefix, 'BoldIsPrefix', cdRegister);
 S.RegisterDelphiFunction(@BoldStrEqual, 'BoldStrEqual', cdRegister);
 S.RegisterDelphiFunction(@BoldStrAnsiEqual, 'BoldStrAnsiEqual', cdRegister);
 S.RegisterDelphiFunction(@BoldAnsiEqual, 'BoldAnsiEqual', cdRegister);
 S.RegisterDelphiFunction(@BoldStrStringEqual, 'BoldStrStringEqual', cdRegister);
 S.RegisterDelphiFunction(@BoldCaseIndependentPos, 'BoldCaseIndependentPos', cdRegister);
 S.RegisterDelphiFunction(@EnumToStrings, 'EnumToStrings', cdRegister);
 S.RegisterDelphiFunction(@CapitalisedToSpaced, 'CapitalisedToSpaced', cdRegister);
 S.RegisterDelphiFunction(@SpacedToCapitalised, 'SpacedToCapitalised', cdRegister);
 S.RegisterDelphiFunction(@BooleanToString, 'BooleanToString', cdRegister);
 S.RegisterDelphiFunction(@StringToBoolean, 'StringToBoolean', cdRegister);
 S.RegisterDelphiFunction(@GetUpperLimitForMultiplicity, 'GetUpperLimitForMultiplicity', cdRegister);
 S.RegisterDelphiFunction(@GetLowerLimitForMultiplicity, 'GetLowerLimitForMultiplicity', cdRegister);
 S.RegisterDelphiFunction(@StringListToVarArray, 'StringListToVarArray', cdRegister);
 S.RegisterDelphiFunction(@IsLocalMachine, 'IsLocalMachine', cdRegister);
 S.RegisterDelphiFunction(@GetComputerNameStr, 'GetComputerNameStr', cdRegister);
 S.RegisterDelphiFunction(@TimeStampComp, 'TimeStampComp', cdRegister);
 S.RegisterDelphiFunction(@StrToDateFmt, 'BoldStrToDateFmt', cdRegister);
 S.RegisterDelphiFunction(@DateToStrFmt, 'BoldDateToStrFmt', cdRegister);
 S.RegisterDelphiFunction(@BoldParseFormattedDateList, 'BoldParseFormattedDateList', cdRegister);
 S.RegisterDelphiFunction(@BoldParseFormattedDate, 'BoldParseFormattedDate', cdRegister);
 S.RegisterDelphiFunction(@EnsureTrailing, 'EnsureTrailing', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'BoldDirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'BoldForceDirectories', cdRegister);
 S.RegisterDelphiFunction(@BoldRootRegistryKey, 'BoldRootRegistryKey', cdRegister);
 S.RegisterDelphiFunction(@GetModuleFileNameAsString, 'GetModuleFileNameAsString', cdRegister);
 S.RegisterDelphiFunction(@BoldVariantToStrings, 'BoldVariantToStrings', cdRegister);
 S.RegisterDelphiFunction(@getMatchString, 'getMatchString', cdRegister);



end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldPassthroughNotifier(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldPassthroughNotifier) do
  begin
    RegisterConstructor(@TBoldPassthroughNotifier.CreateWithEvent, 'CreateWithEvent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBoldPassthroughNotifier(CL);
end;

 
 
{ TPSImport_BoldUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BoldUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BoldUtils(ri);
  RIRegister_BoldUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
