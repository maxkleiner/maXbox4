unit uPSI_OverbyteIcsTicks64;
{
   time space since
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
  TPSImport_OverbyteIcsTicks64 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_OverbyteIcsTicks64(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_OverbyteIcsTicks64_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,OverbyteIcsTicks64
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OverbyteIcsTicks64]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_OverbyteIcsTicks64(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ISODateMask','String').SetString( 'yyyy-mm-dd');
 CL.AddConstantN('ISODateTimeMask','String').SetString( 'yyyy-mm-dd"T"hh:nn:ss');
 CL.AddConstantN('ISODateLongTimeMask','String').SetString( 'yyyy-mm-dd"T"hh:nn:ss.zzz');
 CL.AddConstantN('ISOTimeMask','String').SetString( 'hh:nn:ss');
 CL.AddConstantN('LongTimeMask','String').SetString( 'hh:nn:ss:zzz');
 CL.AddConstantN('Ticks64PerDay','int64').SetInt64( 24 * 60 * 60 * 1000);
 CL.AddConstantN('Ticks64PerHour','int64').SetInt64( 60 * 60 * 1000);
 CL.AddConstantN('Ticks64PerMinute','int64').SetInt64( 60 * 1000);
 CL.AddConstantN('Ticks64PerSecond','int64').SetInt64( 1000);
  CL.AddTypeS('TTicks64Mode', '( TicksNone, TicksAPI64, TicksPerf, TicksAPI32 )');
 CL.AddDelphiFunction('Function IcsGetTickCount64 : int64');
 CL.AddDelphiFunction('Procedure IcsInitTick64( NewMode : TTicks64Mode)');
 CL.AddDelphiFunction('Function IcsNowPC : TDateTime');
 CL.AddDelphiFunction('Procedure IcsAlignNowPC');
 CL.AddDelphiFunction('Function IcsLastBootDT : TDateTime');
 CL.AddDelphiFunction('Function IcsGetPerfCountsPerSec : int64');
 CL.AddDelphiFunction('Function IcsPerfCountCurrent : int64');
 CL.AddDelphiFunction('Function IcsPerfCountCurrMilli : int64');
 CL.AddDelphiFunction('Function IcsPerfCountToMilli( LI : int64) : int64');
 CL.AddDelphiFunction('Function IcsPerfCountGetMilli( startLI : int64) : int64');
 CL.AddDelphiFunction('Function IcsPerfCountGetMillStr( startLI : int64) : string');
 CL.AddDelphiFunction('Function IcsPerfCountToSecs( LI : int64) : integer');
 CL.AddDelphiFunction('Function IcsPerfCountGetSecs( startLI : int64) : integer');
 CL.AddDelphiFunction('Function IcsDiffTicks64( const StartTick, EndTick : int64) : int64');
 CL.AddDelphiFunction('Function IcsElapsedTicks64( const StartTick : int64) : int64');
 CL.AddDelphiFunction('Function IcsElapsedMsecs64( const StartTick : int64) : int64');
 CL.AddDelphiFunction('Function IcsElapsedSecs64( const StartTick : int64) : integer');
 CL.AddDelphiFunction('Function IcsElapsedMins64( const StartTick : int64) : integer');
 CL.AddDelphiFunction('Function IcsWaitingSecs64( const EndTick : int64) : integer');
 CL.AddDelphiFunction('Function IcsGetTrgMSecs64( const MilliSecs : int64) : int64');
 CL.AddDelphiFunction('Function IcsGetTrgSecs64( const DurSecs : integer) : int64');
 CL.AddDelphiFunction('Function IcsGetTrgMins64( const DurMins : integer) : int64');
 CL.AddDelphiFunction('Function IcsTestTrgTick64( const TrgTick : int64) : boolean');
 CL.AddDelphiFunction('Function IcsAddTrgMsecs64( const TickCount, MilliSecs : int64) : int64');
 CL.AddDelphiFunction('Function IcsAddTrgSecs64( const TickCount : int64; DurSecs : integer) : int64');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_OverbyteIcsTicks64_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IcsGetTickCount64, 'IcsGetTickCount64', cdRegister);
 S.RegisterDelphiFunction(@IcsInitTick64, 'IcsInitTick64', cdRegister);
 S.RegisterDelphiFunction(@IcsNowPC, 'IcsNowPC', cdRegister);
 S.RegisterDelphiFunction(@IcsAlignNowPC, 'IcsAlignNowPC', cdRegister);
 S.RegisterDelphiFunction(@IcsLastBootDT, 'IcsLastBootDT', cdRegister);
 S.RegisterDelphiFunction(@IcsGetPerfCountsPerSec, 'IcsGetPerfCountsPerSec', cdRegister);
 S.RegisterDelphiFunction(@IcsPerfCountCurrent, 'IcsPerfCountCurrent', cdRegister);
 S.RegisterDelphiFunction(@IcsPerfCountCurrMilli, 'IcsPerfCountCurrMilli', cdRegister);
 S.RegisterDelphiFunction(@IcsPerfCountToMilli, 'IcsPerfCountToMilli', cdRegister);
 S.RegisterDelphiFunction(@IcsPerfCountGetMilli, 'IcsPerfCountGetMilli', cdRegister);
 S.RegisterDelphiFunction(@IcsPerfCountGetMillStr, 'IcsPerfCountGetMillStr', cdRegister);
 S.RegisterDelphiFunction(@IcsPerfCountToSecs, 'IcsPerfCountToSecs', cdRegister);
 S.RegisterDelphiFunction(@IcsPerfCountGetSecs, 'IcsPerfCountGetSecs', cdRegister);
 S.RegisterDelphiFunction(@IcsDiffTicks64, 'IcsDiffTicks64', cdRegister);
 S.RegisterDelphiFunction(@IcsElapsedTicks64, 'IcsElapsedTicks64', cdRegister);
 S.RegisterDelphiFunction(@IcsElapsedMsecs64, 'IcsElapsedMsecs64', cdRegister);
 S.RegisterDelphiFunction(@IcsElapsedSecs64, 'IcsElapsedSecs64', cdRegister);
 S.RegisterDelphiFunction(@IcsElapsedMins64, 'IcsElapsedMins64', cdRegister);
 S.RegisterDelphiFunction(@IcsWaitingSecs64, 'IcsWaitingSecs64', cdRegister);
 S.RegisterDelphiFunction(@IcsGetTrgMSecs64, 'IcsGetTrgMSecs64', cdRegister);
 S.RegisterDelphiFunction(@IcsGetTrgSecs64, 'IcsGetTrgSecs64', cdRegister);
 S.RegisterDelphiFunction(@IcsGetTrgMins64, 'IcsGetTrgMins64', cdRegister);
 S.RegisterDelphiFunction(@IcsTestTrgTick64, 'IcsTestTrgTick64', cdRegister);
 S.RegisterDelphiFunction(@IcsAddTrgMsecs64, 'IcsAddTrgMsecs64', cdRegister);
 S.RegisterDelphiFunction(@IcsAddTrgSecs64, 'IcsAddTrgSecs64', cdRegister);
end;

 
 
{ TPSImport_OverbyteIcsTicks64 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsTicks64.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OverbyteIcsTicks64(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsTicks64.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OverbyteIcsTicks64_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
