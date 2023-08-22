unit uPSI_cyDateUtils;
{
   time to loop to time
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
  TPSImport_cyDateUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cyDateUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyDateUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Controls
  ,DateUtils
  ,cyDateUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyDateUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cyDateUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function LongDayName( aDate : TDate) : String');
 CL.AddDelphiFunction('Function LongMonthName( aDate : TDate) : String');
 CL.AddDelphiFunction('Function ShortYearOf( aDate : TDate) : byte');
 CL.AddDelphiFunction('Function DateToStrYYYYMMDD( aDate : TDate) : String');
 CL.AddDelphiFunction('Function StrYYYYMMDDToDate( aStr : String) : TDate');
 CL.AddDelphiFunction('Function SecondsToMinutes( Seconds : Integer) : Double');
 CL.AddDelphiFunction('Function MinutesToSeconds( Minutes : Double) : Integer');
 CL.AddDelphiFunction('Function MinutesToHours( Minutes : Integer) : Double');
 CL.AddDelphiFunction('Function HoursToMinutes( Hours : Double) : Integer');
 CL.AddDelphiFunction('Function ShortTimeStringToTime( ShortTimeStr : String; const ShortTimeFormat : String) : TDateTime');
 CL.AddDelphiFunction('Procedure cyAddMonths( var aMonth, aYear : Word; Months : Integer)');
 CL.AddDelphiFunction('Function MergeDateWithTime( aDate : TDate; aTime : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function GetMinutesBetween( DateTime1, DateTime2 : TDateTime) : Int64;');
 CL.AddDelphiFunction('Function GetMinutesBetween1( From_ShortTimeStr, To_ShortTimeStr : String; const ShortTimeFormat : String) : Int64;');
 CL.AddDelphiFunction('Function GetSecondsBetween( DateTime1, DateTime2 : TDateTime) : Int64;');
 CL.AddDelphiFunction('Function IntersectPeriods( Period1Begin, Period1End, Period2Begin, Period2End : TDateTime; var RsltBegin : TDateTime; RsltEnd : TDateTime) : Boolean;');
 CL.AddDelphiFunction('Function IntersectPeriods1( Period1Begin, Period1End, Period2Begin, Period2End : TDateTime) : Boolean;');
 CL.AddDelphiFunction('Function TryToEncodeDate( Year, Month, Day : Integer; var RsltDate : TDateTime) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function IntersectPeriods1_P( Period1Begin, Period1End, Period2Begin, Period2End : TDateTime) : Boolean;
Begin Result := cyDateUtils.IntersectPeriods(Period1Begin, Period1End, Period2Begin, Period2End); END;

(*----------------------------------------------------------------------------*)
Function IntersectPeriods_P( Period1Begin, Period1End, Period2Begin, Period2End : TDateTime; var RsltBegin : TDateTime; RsltEnd : TDateTime) : Boolean;
Begin Result := cyDateUtils.IntersectPeriods(Period1Begin, Period1End, Period2Begin, Period2End, RsltBegin, RsltEnd); END;

(*----------------------------------------------------------------------------*)
Function GetSecondsBetween_P( DateTime1, DateTime2 : TDateTime) : Int64;
Begin Result := cyDateUtils.GetSecondsBetween(DateTime1, DateTime2); END;

(*----------------------------------------------------------------------------*)
Function GetMinutesBetween1_P( From_ShortTimeStr, To_ShortTimeStr : String; const ShortTimeFormat : String) : Int64;
Begin Result := cyDateUtils.GetMinutesBetween(From_ShortTimeStr, To_ShortTimeStr, ShortTimeFormat); END;

(*----------------------------------------------------------------------------*)
Function GetMinutesBetween_P( DateTime1, DateTime2 : TDateTime) : Int64;
Begin Result := cyDateUtils.GetMinutesBetween(DateTime1, DateTime2); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyDateUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LongDayName, 'LongDayName', cdRegister);
 S.RegisterDelphiFunction(@LongMonthName, 'LongMonthName', cdRegister);
 S.RegisterDelphiFunction(@ShortYearOf, 'ShortYearOf', cdRegister);
 S.RegisterDelphiFunction(@DateToStrYYYYMMDD, 'DateToStrYYYYMMDD', cdRegister);
 S.RegisterDelphiFunction(@StrYYYYMMDDToDate, 'StrYYYYMMDDToDate', cdRegister);
 S.RegisterDelphiFunction(@SecondsToMinutes, 'SecondsToMinutes', cdRegister);
 S.RegisterDelphiFunction(@MinutesToSeconds, 'MinutesToSeconds', cdRegister);
 S.RegisterDelphiFunction(@MinutesToHours, 'MinutesToHours', cdRegister);
 S.RegisterDelphiFunction(@HoursToMinutes, 'HoursToMinutes', cdRegister);
 S.RegisterDelphiFunction(@ShortTimeStringToTime, 'ShortTimeStringToTime', cdRegister);
 S.RegisterDelphiFunction(@AddMonths, 'cyAddMonths', cdRegister);
 S.RegisterDelphiFunction(@MergeDateWithTime, 'MergeDateWithTime', cdRegister);
 S.RegisterDelphiFunction(@GetMinutesBetween, 'GetMinutesBetween', cdRegister);
 S.RegisterDelphiFunction(@GetMinutesBetween1_P, 'GetMinutesBetween1', cdRegister);
 S.RegisterDelphiFunction(@GetSecondsBetween, 'GetSecondsBetween', cdRegister);
 S.RegisterDelphiFunction(@IntersectPeriods, 'IntersectPeriods', cdRegister);
 S.RegisterDelphiFunction(@IntersectPeriods1_P, 'IntersectPeriods1', cdRegister);
 S.RegisterDelphiFunction(@TryToEncodeDate, 'TryToEncodeDate', cdRegister);
end;

 
 
{ TPSImport_cyDateUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyDateUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyDateUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyDateUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cyDateUtils(ri);
  RIRegister_cyDateUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
