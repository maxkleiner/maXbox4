unit uPSI_JvTFUtils;
{
   for the time machine
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
  TPSImport_JvTFUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvTFUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvTFUtils_Routines(S: TPSExec);
procedure RIRegister_JvTFUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  //,Graphics
  Controls
  ,JvTFUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvTFUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvTFUtils(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TJvTFVisibleScrollBars', 'set of ( vsbHorz, vsbVert )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJvTFDateError');
  CL.AddTypeS('TTFDayOfWeek', '( dowSunday, dowMonday, dowTuesday, dowWednesday'
   +', dowThursday, dowFriday, dowSaturday )');
  CL.AddTypeS('TTFDaysOfWeek', 'set of TTFDayOfWeek');
  CL.AddTypeS('TJvTFVAlignment', '( vaTop, vaCenter, vaBottom )');
  CL.AddTypeS('TJvTFDirection', '( dirUp, dirDown, dirLeft, dirRight )');
 //CL.AddConstantN('DOW_WEEKEND','TTFDaysOfWeek').SetString(ord(dowSunday) or ord(dowSaturday));
 {CL.AddConstantN('ONE_HOUR','LongInt').SetInt( 1 / 24);
 CL.AddConstantN('ONE_MINUTE','LongInt').SetInt( ONE_HOUR / 60);
 CL.AddConstantN('ONE_SECOND','LongInt').SetInt( ONE_MINUTE / 60);
 CL.AddConstantN('ONE_MILLISECOND','LongInt').SetInt( ONE_SECOND / 1000);}
 CL.AddDelphiFunction('Function JExtractYear( ADate : TDateTime) : Word');
 CL.AddDelphiFunction('Function JExtractMonth( ADate : TDateTime) : Word');
 CL.AddDelphiFunction('Function JExtractDay( ADate : TDateTime) : Word');
 CL.AddDelphiFunction('Function ExtractHours( ATime : TDateTime) : Word');
 CL.AddDelphiFunction('Function ExtractMins( ATime : TDateTime) : Word');
 CL.AddDelphiFunction('Function ExtractSecs( ATime : TDateTime) : Word');
 CL.AddDelphiFunction('Function ExtractMSecs( ATime : TDateTime) : Word');
 CL.AddDelphiFunction('Function FirstOfMonth( ADate : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function GetDayOfNthDOW( Year, Month, DOW, N : Word) : Word');
 CL.AddDelphiFunction('Function GetWeeksInMonth( Year, Month : Word; StartOfWeek : Integer) : Word');
 CL.AddDelphiFunction('Procedure IncBorlDOW( var BorlDOW : Integer; N : Integer)');
 CL.AddDelphiFunction('Procedure IncDOW( var DOW : TTFDayOfWeek; N : Integer)');
 CL.AddDelphiFunction('Procedure IncDays( var ADate : TDateTime; N : Integer)');
 CL.AddDelphiFunction('Procedure IncWeeks( var ADate : TDateTime; N : Integer)');
 CL.AddDelphiFunction('Procedure IncMonths( var ADate : TDateTime; N : Integer)');
 CL.AddDelphiFunction('Procedure IncYears( var ADate : TDateTime; N : Integer)');
 CL.AddDelphiFunction('Function EndOfMonth( ADate : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function IsFirstOfMonth( ADate : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsEndOfMonth( ADate : TDateTime) : Boolean');
 CL.AddDelphiFunction('Procedure EnsureMonth( Month : Word)');
 CL.AddDelphiFunction('Procedure EnsureDOW( DOW : Word)');
 CL.AddDelphiFunction('Function EqualDates( D1, D2 : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function Lesser( N1, N2 : Integer) : Integer');
 CL.AddDelphiFunction('Function Greater( N1, N2 : Integer) : Integer');
 CL.AddDelphiFunction('Function GetDivLength( TotalLength, DivCount, DivNum : Integer) : Integer');
 CL.AddDelphiFunction('Function GetDivNum( TotalLength, DivCount, X : Integer) : Integer');
 CL.AddDelphiFunction('Function GetDivStart( TotalLength, DivCount, DivNum : Integer) : Integer');
 CL.AddDelphiFunction('Function DOWToBorl( ADOW : TTFDayOfWeek) : Integer');
 CL.AddDelphiFunction('Function BorlToDOW( BorlDOW : Integer) : TTFDayOfWeek');
 CL.AddDelphiFunction('Function DateToDOW( ADate : TDateTime) : TTFDayOfWeek');
 CL.AddDelphiFunction('Procedure CalcTextPos( HostRect : TRect; var TextLeft, TextTop : Integer; var TextBounds : TRect; AFont : TFont; AAngle : Integer; HAlign : TAlignment; VAlign : TJvTFVAlignment; ATxt : string)');
 CL.AddDelphiFunction('Procedure DrawAngleText( ACanvas : TCanvas; HostRect : TRect; var TextBounds : TRect; AAngle : Integer; HAlign : TAlignment; VAlign : TJvTFVAlignment; ATxt : string)');
 CL.AddDelphiFunction('Function JRectWidth( ARect : TRect) : Integer');
 CL.AddDelphiFunction('Function JRectHeight( ARect : TRect) : Integer');
 CL.AddDelphiFunction('Function JEmptyRect : TRect');
 CL.AddDelphiFunction('Function IsClassByName( Obj : TObject; ClassName : string) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvTFUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ExtractYear, 'JExtractYear', cdRegister);
 S.RegisterDelphiFunction(@ExtractMonth, 'JExtractMonth', cdRegister);
 S.RegisterDelphiFunction(@ExtractDay, 'JExtractDay', cdRegister);
 S.RegisterDelphiFunction(@ExtractHours, 'ExtractHours', cdRegister);
 S.RegisterDelphiFunction(@ExtractMins, 'ExtractMins', cdRegister);
 S.RegisterDelphiFunction(@ExtractSecs, 'ExtractSecs', cdRegister);
 S.RegisterDelphiFunction(@ExtractMSecs, 'ExtractMSecs', cdRegister);
 S.RegisterDelphiFunction(@FirstOfMonth, 'FirstOfMonth', cdRegister);
 S.RegisterDelphiFunction(@GetDayOfNthDOW, 'GetDayOfNthDOW', cdRegister);
 S.RegisterDelphiFunction(@GetWeeksInMonth, 'GetWeeksInMonth', cdRegister);
 S.RegisterDelphiFunction(@IncBorlDOW, 'IncBorlDOW', cdRegister);
 S.RegisterDelphiFunction(@IncDOW, 'IncDOW', cdRegister);
 S.RegisterDelphiFunction(@IncDays, 'IncDays', cdRegister);
 S.RegisterDelphiFunction(@IncWeeks, 'IncWeeks', cdRegister);
 S.RegisterDelphiFunction(@IncMonths, 'IncMonths', cdRegister);
 S.RegisterDelphiFunction(@IncYears, 'IncYears', cdRegister);
 S.RegisterDelphiFunction(@EndOfMonth, 'EndOfMonth', cdRegister);
 S.RegisterDelphiFunction(@IsFirstOfMonth, 'IsFirstOfMonth', cdRegister);
 S.RegisterDelphiFunction(@IsEndOfMonth, 'IsEndOfMonth', cdRegister);
 S.RegisterDelphiFunction(@EnsureMonth, 'EnsureMonth', cdRegister);
 S.RegisterDelphiFunction(@EnsureDOW, 'EnsureDOW', cdRegister);
 S.RegisterDelphiFunction(@EqualDates, 'EqualDates', cdRegister);
 S.RegisterDelphiFunction(@Lesser, 'Lesser', cdRegister);
 S.RegisterDelphiFunction(@Greater, 'Greater', cdRegister);
 S.RegisterDelphiFunction(@GetDivLength, 'GetDivLength', cdRegister);
 S.RegisterDelphiFunction(@GetDivNum, 'GetDivNum', cdRegister);
 S.RegisterDelphiFunction(@GetDivStart, 'GetDivStart', cdRegister);
 S.RegisterDelphiFunction(@DOWToBorl, 'DOWToBorl', cdRegister);
 S.RegisterDelphiFunction(@BorlToDOW, 'BorlToDOW', cdRegister);
 S.RegisterDelphiFunction(@DateToDOW, 'DateToDOW', cdRegister);
 S.RegisterDelphiFunction(@CalcTextPos, 'CalcTextPos', cdRegister);
 S.RegisterDelphiFunction(@DrawAngleText, 'DrawAngleText', cdRegister);
 S.RegisterDelphiFunction(@RectWidth, 'JRectWidth', cdRegister);
 S.RegisterDelphiFunction(@RectHeight, 'JRectHeight', cdRegister);
 S.RegisterDelphiFunction(@EmptyRect, 'JEmptyRect', cdRegister);
 S.RegisterDelphiFunction(@IsClassByName, 'IsClassByName', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvTFUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJvTFDateError) do
end;

 
 
{ TPSImport_JvTFUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTFUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvTFUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTFUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvTFUtils(ri);
  RIRegister_JvTFUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
