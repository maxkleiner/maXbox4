unit uPSI_StdFuncs;
{
another enlarger  and  Function GetDirectoryOfFile( FileName : String) : String');
         fix tempfile

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
  TPSImport_StdFuncs = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StdFuncs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StdFuncs_Routines(S: TPSExec);
procedure RIRegister_StdFuncs(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StdFuncs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StdFuncs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StdFuncs(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EParserError');
  CL.AddTypeS('TCharSet', 'set of Char');
 CL.AddDelphiFunction('Function ConvertFromBase( sNum : String; iBase : Integer; cDigits : String) : Integer');
 CL.AddDelphiFunction('Function ConvertToBase( iNum, iBase : Integer; cDigits : String) : String');
 CL.AddDelphiFunction('Function EnsureSentenceTerminates( Sentence : String; Terminator : Char) : String');
 CL.AddDelphiFunction('Function FindTokenStartingAt( st : String; var i : Integer; TokenChars : TCharSet; TokenCharsInToken : Boolean) : String');
 CL.AddDelphiFunction('Function GetDirectoryOfFile( FileName : String) : String');
 CL.AddDelphiFunction('Function GetDirOfFile( FileName : String) : String');

 CL.AddDelphiFunction('Function GetTempFilefib( FilePrefix : String) : String');
 CL.AddDelphiFunction('Function Icon2Bitmap( Icon : HICON) : HBITMAP');
 CL.AddDelphiFunction('Function Maxfib( n1, n2 : Integer) : Integer');
 CL.AddDelphiFunction('Function MaxD( n1, n2 : Double) : Double');
 CL.AddDelphiFunction('Function Minfib( n1, n2 : Integer) : Integer');
 CL.AddDelphiFunction('Function MinD( n1, n2 : Double) : Double');
 CL.AddDelphiFunction('Function RandomStringfib( iLength : Integer) : String');
 CL.AddDelphiFunction('Function RandomIntegerfib( iLow, iHigh : Integer) : Integer');
 CL.AddDelphiFunction('Function RandomIntfib( iLow, iHigh : Integer) : Integer');
 CL.AddDelphiFunction('Function RandomInt( iLow, iHigh : Integer) : Integer');
 CL.AddDelphiFunction('Function Soundexfib( st : String) : String');
 CL.AddDelphiFunction('Function StripStringfib( st : String; CharsToStrip : String) : String');
 CL.AddDelphiFunction('Function ClosestWeekday( const d : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function Yearfib( d : TDateTime) : Integer');
 CL.AddDelphiFunction('Function Monthfib( d : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DayOfYearfib( d : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DayOfMonth( d : TDateTime) : Integer');
 CL.AddDelphiFunction('Function VarCoalesce( V1, V2 : Variant) : Variant');
 CL.AddDelphiFunction('Function VarEqual( V1, V2 : Variant) : Boolean');
 CL.AddDelphiFunction('Procedure WeekOfYearfib( d : TDateTime; var Year, Week : Integer)');
 CL.AddDelphiFunction('Function Degree10( Degree : integer) : double');
 CL.AddDelphiFunction('Function CompToStr( Value : comp) : string');
 CL.AddDelphiFunction('Function StrToComp( const Value : string) : comp');
 CL.AddDelphiFunction('Function CompDiv( A, B : comp) : comp');
 CL.AddDelphiFunction('Function CompMod( A, B : comp) : comp');
 // CL.AddTypeS('PComp', '^Comp // will not work');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StdFuncs_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ConvertFromBase, 'ConvertFromBase', cdRegister);
 S.RegisterDelphiFunction(@ConvertToBase, 'ConvertToBase', cdRegister);
 S.RegisterDelphiFunction(@EnsureSentenceTerminates, 'EnsureSentenceTerminates', cdRegister);
 S.RegisterDelphiFunction(@FindTokenStartingAt, 'FindTokenStartingAt', cdRegister);
 S.RegisterDelphiFunction(@GetDirectoryOfFile, 'GetDirectoryOfFile', cdRegister);
 S.RegisterDelphiFunction(@GetDirectoryOfFile, 'GetDirOfFile', cdRegister);

 S.RegisterDelphiFunction(@GetTempFile, 'GetTempFilefib', cdRegister);
 S.RegisterDelphiFunction(@Icon2Bitmap, 'Icon2Bitmap', cdRegister);
 S.RegisterDelphiFunction(@Max, 'Maxfib', cdRegister);
 S.RegisterDelphiFunction(@MaxD, 'MaxD', cdRegister);
 S.RegisterDelphiFunction(@Min, 'Minfib', cdRegister);
 S.RegisterDelphiFunction(@MinD, 'MinD', cdRegister);
 S.RegisterDelphiFunction(@RandomString, 'RandomStringfib', cdRegister);
 S.RegisterDelphiFunction(@RandomInteger, 'RandomIntegerfib', cdRegister);
 S.RegisterDelphiFunction(@RandomInteger, 'RandomIntfib', cdRegister);
 S.RegisterDelphiFunction(@RandomInteger, 'RandomInt', cdRegister);
 S.RegisterDelphiFunction(@Soundex, 'Soundexfib', cdRegister);
 S.RegisterDelphiFunction(@StripString, 'StripStringfib', cdRegister);
 S.RegisterDelphiFunction(@ClosestWeekday, 'ClosestWeekday', cdRegister);
 S.RegisterDelphiFunction(@Year, 'Yearfib', cdRegister);
 S.RegisterDelphiFunction(@Month, 'Monthfib', cdRegister);
 S.RegisterDelphiFunction(@DayOfYear, 'DayOfYearfib', cdRegister);
 S.RegisterDelphiFunction(@DayOfMonth, 'DayOfMonth', cdRegister);
 S.RegisterDelphiFunction(@VarCoalesce, 'VarCoalesce', cdRegister);
 S.RegisterDelphiFunction(@VarEqual, 'VarEqual', cdRegister);
 S.RegisterDelphiFunction(@WeekOfYear, 'WeekOfYearfib', cdRegister);
 S.RegisterDelphiFunction(@Degree10, 'Degree10', cdRegister);
 S.RegisterDelphiFunction(@CompToStr, 'CompToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToComp, 'StrToComp', cdRegister);
 S.RegisterDelphiFunction(@CompDiv, 'CompDiv', cdRegister);
 S.RegisterDelphiFunction(@CompMod, 'CompMod', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StdFuncs(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EParserError) do
end;

 
 
{ TPSImport_StdFuncs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StdFuncs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StdFuncs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StdFuncs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StdFuncs(ri);
  RIRegister_StdFuncs_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
