unit uPSI_dateext4;
{
a last time to frame

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
  TPSImport_dateext4 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_dateext4(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_dateext4_Routines(S: TPSExec);

procedure Register;

implementation


uses
   dateutils
  ,dateext4
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_dateext4]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_dateext4(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('tfiletime2', 'record LowDateTime : longword; HighDateTime : longword; end');

 // CL.AddTypeS('big_integer_t', 'int64');

 CL.AddDelphiFunction('Function DosToWinTime( DTime : longint; var Wtime : TFileTime) : longbool');
 CL.AddDelphiFunction('Function WinToDosTime( const Wtime : TFileTime; var DTime : longint) : longbool');
 CL.AddDelphiFunction('Function TryStrToDateTimeExt( const S : string; var Value : TDateTime; var UTC : boolean) : Boolean');
 CL.AddDelphiFunction('Function TryEncodeDateAndTimeToStr( const Year, Month, Day, Hour, Minute, Second, MilliSecond : word; UTC : boolean; var AValue : string) : boolean');
 CL.AddDelphiFunction('Function DateTimeToStrExt( DateTime : TDateTime; utc : boolean) : string');
 CL.AddDelphiFunction('Procedure GetCurrentDate( var Year, Month, Day, DayOfWeek : integer)');
 CL.AddDelphiFunction('Procedure GetCurrentTime2( var Hour, Minute, Second, Sec100 : integer)');
 CL.AddDelphiFunction('Function TryUNIXToDateTimeExt( unixtime : big_integer_t; var DateTime : TDateTime; var UTC : boolean) : boolean');
 CL.AddDelphiFunction('Function TryFileTimeToDateTimeExt( ftime : tfiletime; var DateTime : TDateTime; var UTC : boolean) : boolean');
 CL.AddDelphiFunction('procedure JulianToGregorian(JulianDN:big_integer_t;var Year,Month,Day:Word);');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_dateext4_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DosToWinTime, 'DosToWinTime', cdRegister);
 S.RegisterDelphiFunction(@WinToDosTime, 'WinToDosTime', cdRegister);
 S.RegisterDelphiFunction(@TryStrToDateTimeExt, 'TryStrToDateTimeExt', cdRegister);
 S.RegisterDelphiFunction(@TryEncodeDateAndTimeToStr, 'TryEncodeDateAndTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToStrExt, 'DateTimeToStrExt', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentDate, 'GetCurrentDate', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentTime, 'GetCurrentTime2', cdRegister);
 S.RegisterDelphiFunction(@TryUNIXToDateTimeExt, 'TryUNIXToDateTimeExt', cdRegister);
 S.RegisterDelphiFunction(@TryFileTimeToDateTimeExt, 'TryFileTimeToDateTimeExt', cdRegister);
 S.RegisterDelphiFunction(@JulianToGregorian, 'JulianToGregorian', cdRegister);


end;

 
 
{ TPSImport_dateext4 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_dateext4.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_dateext4(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_dateext4.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_dateext4_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
