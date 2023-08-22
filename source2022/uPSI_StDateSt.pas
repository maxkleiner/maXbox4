unit uPSI_StDateSt;
{
  time and tome  - link to stDate
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
  TPSImport_StDateSt = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StDateSt(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StDateSt_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,StStrS
  ,StStrZ
  ,StStrL
  ,StConst
  ,StBase
  ,StUtils
  ,StDate
  ,StDateSt
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StDateSt]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StDateSt(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MonthOnly','String').SetString( 'm');
 CL.AddConstantN('DayOnly','String').SetString( 'd');
 CL.AddConstantN('YearOnly','String').SetString( 'y');
 CL.AddConstantN('MonthOnlyU','String').SetString( 'M');
 CL.AddConstantN('DayOnlyU','String').SetString( 'D');
 CL.AddConstantN('DateSlash','String').SetString( '/');
 CL.AddConstantN('NameOnly','String').SetString( 'n');
 CL.AddConstantN('NameOnlyU','String').SetString( 'N');
 CL.AddConstantN('WeekDayOnly','String').SetString( 'w');
 CL.AddConstantN('WeekDayOnlyU','String').SetString( 'W');
 CL.AddConstantN('LongDateSub1','String').SetString( 'f');
 CL.AddConstantN('LongDateSub2','String').SetString( 'g');
 CL.AddConstantN('LongDateSub3','String').SetString( 'h');
 CL.AddConstantN('HourOnly','String').SetString( 'h');
 CL.AddConstantN('MinOnly','String').SetString( 'm');
 CL.AddConstantN('SecOnly','String').SetString( 's');
 CL.AddConstantN('HourOnlyU','String').SetString( 'H');
 CL.AddConstantN('MinOnlyU','String').SetString( 'M');
 CL.AddConstantN('SecOnlyU','String').SetString( 'S');
 CL.AddConstantN('TimeOnly','String').SetString( 't');
 CL.AddConstantN('TimeColon','String').SetString( ':');
 CL.AddDelphiFunction('Function DateStringHMStoAstJD( const Picture, DS : string; H, M, S, Epoch : integer) : Double');
 CL.AddDelphiFunction('Function MonthToString( const Month : Integer) : string');
 CL.AddDelphiFunction('Function DateStringToStDate( const Picture, S : string; Epoch : Integer) : TStDate');
 CL.AddDelphiFunction('Function DateStringToDMY( const Picture, S : string; Epoch : Integer; var D, M, Y : Integer) : Boolean');
 CL.AddDelphiFunction('Function StDateToDateString( const Picture : string; const Julian : TStDate; Pack : Boolean) : string');
 CL.AddDelphiFunction('Function DayOfWeekToString( const WeekDay : TStDayType) : string');
 CL.AddDelphiFunction('Function DMYtoDateString( const Picture : string; Day, Month, Year, Epoch : Integer; Pack : Boolean) : string');
 CL.AddDelphiFunction('Function CurrentDateString( const Picture : string; Pack : Boolean) : string');
 CL.AddDelphiFunction('Function CurrentTimeString( const Picture : string; Pack : Boolean) : string');
 CL.AddDelphiFunction('Function TimeStringToHMS( const Picture, St : string; var H, M, S : Integer) : Boolean');
 CL.AddDelphiFunction('Function TimeStringToStTime( const Picture, S : string) : TStTime');
 CL.AddDelphiFunction('Function StTimeToAmPmString( const Picture : string; const T : TStTime; Pack : Boolean) : string');
 CL.AddDelphiFunction('Function StTimeToTimeString( const Picture : string; const T : TStTime; Pack : Boolean) : string');
 CL.AddDelphiFunction('Function DateStringIsBlank( const Picture, S : string) : Boolean');
 CL.AddDelphiFunction('Function InternationalDate( ForceCentury : Boolean) : string');
 CL.AddDelphiFunction('Function InternationalLongDate( ShortNames : Boolean; ExcludeDOW : Boolean) : string');
 CL.AddDelphiFunction('Function InternationalTime( ShowSeconds : Boolean) : string');
 CL.AddDelphiFunction('Procedure ResetInternationalInfo');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StDateSt_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DateStringHMStoAstJD, 'DateStringHMStoAstJD', cdRegister);
 S.RegisterDelphiFunction(@MonthToString, 'MonthToString', cdRegister);
 S.RegisterDelphiFunction(@DateStringToStDate, 'DateStringToStDate', cdRegister);
 S.RegisterDelphiFunction(@DateStringToDMY, 'DateStringToDMY', cdRegister);
 S.RegisterDelphiFunction(@StDateToDateString, 'StDateToDateString', cdRegister);
 S.RegisterDelphiFunction(@DayOfWeekToString, 'DayOfWeekToString', cdRegister);
 S.RegisterDelphiFunction(@DMYtoDateString, 'DMYtoDateString', cdRegister);
 S.RegisterDelphiFunction(@CurrentDateString, 'CurrentDateString', cdRegister);
 S.RegisterDelphiFunction(@CurrentTimeString, 'CurrentTimeString', cdRegister);
 S.RegisterDelphiFunction(@TimeStringToHMS, 'TimeStringToHMS', cdRegister);
 S.RegisterDelphiFunction(@TimeStringToStTime, 'TimeStringToStTime', cdRegister);
 S.RegisterDelphiFunction(@StTimeToAmPmString, 'StTimeToAmPmString', cdRegister);
 S.RegisterDelphiFunction(@StTimeToTimeString, 'StTimeToTimeString', cdRegister);
 S.RegisterDelphiFunction(@DateStringIsBlank, 'DateStringIsBlank', cdRegister);
 S.RegisterDelphiFunction(@InternationalDate, 'InternationalDate', cdRegister);
 S.RegisterDelphiFunction(@InternationalLongDate, 'InternationalLongDate', cdRegister);
 S.RegisterDelphiFunction(@InternationalTime, 'InternationalTime', cdRegister);
 S.RegisterDelphiFunction(@ResetInternationalInfo, 'ResetInternationalInfo', cdRegister);
end;

 
 
{ TPSImport_StDateSt }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDateSt.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StDateSt(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDateSt.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StDateSt(ri);
  RIRegister_StDateSt_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
