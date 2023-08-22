unit uPSI_cTimers;
{
  to use with arduino RTC Clock
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
  TPSImport_cTimers = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cTimers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cTimers_Routines(S: TPSExec);
procedure RIRegister_cTimers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cTimers;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cTimers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cTimers(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'ETimers');
 CL.AddConstantN('TickFrequency','LongInt').SetInt( 1000);
 CL.AddDelphiFunction('Function GetTick : LongWord');
 CL.AddDelphiFunction('Function TickDelta( const D1, D2 : LongWord) : Integer');
 CL.AddDelphiFunction('Function TickDeltaW( const D1, D2 : LongWord) : LongWord');
  CL.AddTypeS('THPTimer', 'Int64');
 CL.AddDelphiFunction('Procedure StartTimer( var Timer : THPTimer)');
 CL.AddDelphiFunction('Procedure StopTimer( var Timer : THPTimer)');
 CL.AddDelphiFunction('function CPUClockFrequency: Int64');

 CL.AddDelphiFunction('Procedure ResumeTimer( var StoppedTimer : THPTimer)');
 CL.AddDelphiFunction('Procedure InitStoppedTimer( var Timer : THPTimer)');
 CL.AddDelphiFunction('Procedure InitElapsedTimer( var Timer : THPTimer; const Milliseconds : Integer)');
 CL.AddDelphiFunction('Function MillisecondsElapsed( const Timer : THPTimer; const TimerRunning : Boolean) : Integer');
 CL.AddDelphiFunction('Function MicrosecondsElapsed( const Timer : THPTimer; const TimerRunning : Boolean) : Int64');
 CL.AddDelphiFunction('Function Micros( const Timer : THPTimer; const TimerRunning : Boolean) : Int64');
 CL.AddDelphiFunction('Procedure WaitMicroseconds( const MicroSeconds : Integer)');
 CL.AddDelphiFunction('Procedure DelayMicroseconds( const MicroSeconds : Integer)');
 CL.AddDelphiFunction('Function GetHighPrecisionFrequency : Int64');
 CL.AddDelphiFunction('Function GetHighPrecisionTimerOverhead : Int64');
 CL.AddDelphiFunction('Procedure AdjustTimerForOverhead( var StoppedTimer : THPTimer; const Overhead : Int64)');
 CL.AddDelphiFunction('Procedure SelfTestCTimer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_cTimers_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetTick, 'GetTick', cdRegister);
 S.RegisterDelphiFunction(@CPUClockFrequency, 'CPUClockFrequency', cdRegister);
 S.RegisterDelphiFunction(@TickDelta, 'TickDelta', cdRegister);
 S.RegisterDelphiFunction(@TickDeltaW, 'TickDeltaW', cdRegister);
 S.RegisterDelphiFunction(@StartTimer, 'StartTimer', cdRegister);
 S.RegisterDelphiFunction(@StopTimer, 'StopTimer', cdRegister);
 S.RegisterDelphiFunction(@ResumeTimer, 'ResumeTimer', cdRegister);
 S.RegisterDelphiFunction(@InitStoppedTimer, 'InitStoppedTimer', cdRegister);
 S.RegisterDelphiFunction(@InitElapsedTimer, 'InitElapsedTimer', cdRegister);
 S.RegisterDelphiFunction(@MillisecondsElapsed, 'MillisecondsElapsed', cdRegister);
 S.RegisterDelphiFunction(@MicrosecondsElapsed, 'MicrosecondsElapsed', cdRegister);
 S.RegisterDelphiFunction(@MicrosecondsElapsed, 'Micros', cdRegister);
 S.RegisterDelphiFunction(@WaitMicroseconds, 'WaitMicroseconds', cdRegister);
 S.RegisterDelphiFunction(@WaitMicroseconds, 'DelayMicroseconds', cdRegister);

 S.RegisterDelphiFunction(@GetHighPrecisionFrequency, 'GetHighPrecisionFrequency', cdRegister);
 S.RegisterDelphiFunction(@GetHighPrecisionTimerOverhead, 'GetHighPrecisionTimerOverhead', cdRegister);
 S.RegisterDelphiFunction(@AdjustTimerForOverhead, 'AdjustTimerForOverhead', cdRegister);
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestCTimer', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cTimers(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ETimers) do
end;

 
 
{ TPSImport_cTimers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cTimers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cTimers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cTimers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cTimers(ri);
  RIRegister_cTimers_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
