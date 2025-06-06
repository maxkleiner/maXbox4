unit uPSI_StDate;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_StDate = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StDate(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StDate_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,StDate
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StDate]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StDate(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStDate', 'LongInt');
  CL.AddTypeS('TStDayType', '( Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday )');
  CL.AddTypeS('TStBondDateType', '( bdtActual, bdt30E360, bdt30360, bdt30360psa)');
  CL.AddTypeS('TStTime', 'LongInt');
  CL.AddTypeS('TStDateTimeRec', 'record D : TStDate; T : TStTime; end');
 CL.AddConstantN('MinYear','LongInt').SetInt( 1600);
 CL.AddConstantN('MaxYear','LongInt').SetInt( 3999);
 CL.AddConstantN('Mindate','LongWord').SetUInt( $00000000);
 CL.AddConstantN('Maxdate','LongWord').SetUInt( $000D6025);
 CL.AddConstantN('Date1900','longint').SetInt( $0001AC05);
 CL.AddConstantN('Date1970','longint').SetInt( $00020FE4);
 CL.AddConstantN('Date1980','longint').SetInt( $00021E28);
 CL.AddConstantN('Date2000','longint').SetInt( $00023AB1);
 CL.AddConstantN('Days400Yr','longint').SetInt( 146097);
 //CL.AddConstantN('BadDate','LongWord').SetUInt( LongInt ( $FFFFFFFF ));
 CL.AddConstantN('DeltaJD','LongWord').SetUInt( $00232DA8);
 CL.AddConstantN('MinTime','LongInt').SetInt( 0);
 CL.AddConstantN('MaxTime','LongInt').SetInt( 86399);
 //CL.AddConstantN('BadTime','LongWord').SetUInt( LongInt ( $FFFFFFFF ));
 CL.AddConstantN('SecondsInDay','LongInt').SetInt( 86400);
 CL.AddConstantN('SecondsInHour','LongInt').SetInt( 3600);
 CL.AddConstantN('SecondsInMinute','LongInt').SetInt( 60);
 CL.AddConstantN('HoursInDay','LongInt').SetInt( 24);
 CL.AddConstantN('MinutesInHour','LongInt').SetInt( 60);
 CL.AddConstantN('MinutesInDay','LongInt').SetInt( 1440);
 CL.AddDelphiFunction('Function CurrentDate : TStDate');
 CL.AddDelphiFunction('Function StValidDate( Day, Month, Year, Epoch : Integer) : Boolean');
 CL.AddDelphiFunction('Function DMYtoStDate( Day, Month, Year, Epoch : Integer) : TStDate');
 CL.AddDelphiFunction('Procedure StDateToDMY( Julian : TStDate; var Day, Month, Year : Integer)');
 CL.AddDelphiFunction('Function StIncDate( Julian : TStDate; Days, Months, Years : Integer) : TStDate');
 CL.AddDelphiFunction('Function IncDateTrunc( Julian : TStDate; Months, Years : Integer) : TStDate');
 CL.AddDelphiFunction('Procedure StDateDiff( Date1, Date2 : TStDate; var Days, Months, Years : Integer)');
 CL.AddDelphiFunction('Function BondDateDiff( Date1, Date2 : TStDate; DayBasis : TStBondDateType) : TStDate');
 CL.AddDelphiFunction('Function WeekOfYear( Julian : TStDate) : Byte');
 CL.AddDelphiFunction('Function AstJulianDate( Julian : TStDate) : Double');
 CL.AddDelphiFunction('Function AstJulianDatetoStDate( AstJulian : Double; Truncate : Boolean) : TStDate');
 CL.AddDelphiFunction('Function AstJulianDatePrim( Year, Month, Date : Integer; UT : TStTime) : Double');
 CL.AddDelphiFunction('Function StDayOfWeek( Julian : TStDate) : TStDayType');
 CL.AddDelphiFunction('Function DayOfWeekDMY( Day, Month, Year, Epoch : Integer) : TStDayType');
 CL.AddDelphiFunction('Function StIsLeapYear( Year : Integer) : Boolean');
 CL.AddDelphiFunction('Function StDaysInMonth( Month : Integer; Year, Epoch : Integer) : Integer');
 CL.AddDelphiFunction('Function ResolveEpoch( Year, Epoch : Integer) : Integer');
 CL.AddDelphiFunction('Function ValidTime( Hours, Minutes, Seconds : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure StTimeToHMS( T : TStTime; var Hours, Minutes, Seconds : Byte)');
 CL.AddDelphiFunction('Function HMStoStTime( Hours, Minutes, Seconds : Byte) : TStTime');
 CL.AddDelphiFunction('Function CurrentTime : TStTime');
 CL.AddDelphiFunction('Procedure TimeDiff( Time1, Time2 : TStTime; var Hours, Minutes, Seconds : Byte)');
 CL.AddDelphiFunction('Function StIncTime( T : TStTime; Hours, Minutes, Seconds : Byte) : TStTime');
 CL.AddDelphiFunction('Function DecTime( T : TStTime; Hours, Minutes, Seconds : Byte) : TStTime');
 CL.AddDelphiFunction('Function RoundToNearestHour( T : TStTime; Truncate : Boolean) : TStTime');
 CL.AddDelphiFunction('Function RoundToNearestMinute( const T : TStTime; Truncate : Boolean) : TStTime');
 CL.AddDelphiFunction('Procedure DateTimeDiff( const DT1 : TStDateTimeRec; var DT2 : TStDateTimeRec; var Days : LongInt; var Secs : LongInt)');
 CL.AddDelphiFunction('Procedure IncDateTime( const DT1 : TStDateTimeRec; var DT2 : TStDateTimeRec; Days : Integer; Secs : LongInt)');
 CL.AddDelphiFunction('Function DateTimeToStDate( DT : TDateTime) : TStDate');
 CL.AddDelphiFunction('Function DateTimeToStTime( DT : TDateTime) : TStTime');
 CL.AddDelphiFunction('Function StDateToDateTime( D : TStDate) : TDateTime');
 CL.AddDelphiFunction('Function StTimeToDateTime( T : TStTime) : TDateTime');
 CL.AddDelphiFunction('Function Convert2ByteDate( TwoByteDate : Word) : TStDate');
 CL.AddDelphiFunction('Function Convert4ByteDate( FourByteDate : TStDate) : Word');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StDate_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CurrentDate, 'CurrentDate', cdRegister);
 S.RegisterDelphiFunction(@ValidDate, 'StValidDate', cdRegister);
 S.RegisterDelphiFunction(@DMYtoStDate, 'DMYtoStDate', cdRegister);
 S.RegisterDelphiFunction(@StDateToDMY, 'StDateToDMY', cdRegister);
 S.RegisterDelphiFunction(@IncDate, 'StIncDate', cdRegister);
 S.RegisterDelphiFunction(@IncDateTrunc, 'IncDateTrunc', cdRegister);
 S.RegisterDelphiFunction(@DateDiff, 'StDateDiff', cdRegister);
 S.RegisterDelphiFunction(@BondDateDiff, 'BondDateDiff', cdRegister);
 S.RegisterDelphiFunction(@WeekOfYear, 'WeekOfYear', cdRegister);
 S.RegisterDelphiFunction(@AstJulianDate, 'AstJulianDate', cdRegister);
 S.RegisterDelphiFunction(@AstJulianDatetoStDate, 'AstJulianDatetoStDate', cdRegister);
 S.RegisterDelphiFunction(@AstJulianDatePrim, 'AstJulianDatePrim', cdRegister);
 S.RegisterDelphiFunction(@DayOfWeek, 'StDayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@DayOfWeekDMY, 'DayOfWeekDMY', cdRegister);
 S.RegisterDelphiFunction(@IsLeapYear, 'StIsLeapYear', cdRegister);
 S.RegisterDelphiFunction(@DaysInMonth, 'StDaysInMonth', cdRegister);
 S.RegisterDelphiFunction(@ResolveEpoch, 'ResolveEpoch', cdRegister);
 S.RegisterDelphiFunction(@ValidTime, 'ValidTime', cdRegister);
 S.RegisterDelphiFunction(@StTimeToHMS, 'StTimeToHMS', cdRegister);
 S.RegisterDelphiFunction(@HMStoStTime, 'HMStoStTime', cdRegister);
 S.RegisterDelphiFunction(@CurrentTime, 'CurrentTime', cdRegister);
 S.RegisterDelphiFunction(@TimeDiff, 'TimeDiff', cdRegister);
 S.RegisterDelphiFunction(@IncTime, 'StIncTime', cdRegister);
 S.RegisterDelphiFunction(@DecTime, 'DecTime', cdRegister);
 S.RegisterDelphiFunction(@RoundToNearestHour, 'RoundToNearestHour', cdRegister);
 S.RegisterDelphiFunction(@RoundToNearestMinute, 'RoundToNearestMinute', cdRegister);
 S.RegisterDelphiFunction(@DateTimeDiff, 'DateTimeDiff', cdRegister);
 S.RegisterDelphiFunction(@IncDateTime, 'IncDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToStDate, 'DateTimeToStDate', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToStTime, 'DateTimeToStTime', cdRegister);
 S.RegisterDelphiFunction(@StDateToDateTime, 'StDateToDateTime', cdRegister);
 S.RegisterDelphiFunction(@StTimeToDateTime, 'StTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@Convert2ByteDate, 'Convert2ByteDate', cdRegister);
 S.RegisterDelphiFunction(@Convert4ByteDate, 'Convert4ByteDate', cdRegister);
end;

 
 
{ TPSImport_StDate }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDate.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StDate(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDate.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StDate(ri);
  RIRegister_StDate_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
