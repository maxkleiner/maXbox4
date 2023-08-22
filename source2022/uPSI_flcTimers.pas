unit uPSI_flcTimers;
{
Time is running out stdout  - np prefix needed

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
  TPSImport_flcTimers = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_flcTimers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcTimers_Routines(S: TPSExec);
procedure RIRegister_flcTimers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   flcStdTypes
  ,flcTimers
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcTimers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_flcTimers(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'ETimerError');
 CL.AddDelphiFunction('Function GetHighResolutionTick : Word64');
 CL.AddDelphiFunction('Function GetHighResolutionFrequency : Word64');
 CL.AddDelphiFunction('Function HighResolutionTickDelta( const T1, T2 : Word64) : Int64');
 CL.AddDelphiFunction('Function HighResolutionTickDeltaU( const T1, T2 : Word64) : Word64');
 CL.AddConstantN('MicroTickFrequency','LongInt').SetInt( 1000000);
 CL.AddDelphiFunction('Function GetMicroTick : Word64');
 CL.AddDelphiFunction('Function MicroTickDelta( const T1, T2 : Word64) : Int64');
 CL.AddDelphiFunction('Function MicroTickDeltaU( const T1, T2 : Word64) : Word64');
 CL.AddConstantN('MilliTickFrequency','LongInt').SetInt( 1000);
 CL.AddDelphiFunction('Function GetMilliTick : Word64');
 CL.AddDelphiFunction('Function MilliTickDelta( const T1, T2 : Word64) : Int64');
 CL.AddDelphiFunction('Function MilliTickDeltaU( const T1, T2 : Word64) : Word64');
 CL.AddDelphiFunction('Function DateTimeToMicroDateTime( const DT : TDateTime) : Word64');
 CL.AddDelphiFunction('Function MicroDateTimeToDateTime( const DT : Word64) : TDateTime');
 CL.AddDelphiFunction('Function GetMicroDateTimeNow : Word64');
 CL.AddDelphiFunction('Function GetNowUT : TDateTime');
 CL.AddDelphiFunction('Function GetMicroDateTimeNowUT : Word64');
 CL.AddDelphiFunction('Function GetNowUTC( const ReInit : Boolean) : TDateTime');
 CL.AddDelphiFunction('Function GetMicroDateTimeNowUTC( const ReInit : Boolean) : Word64');
 CL.AddDelphiFunction('Procedure TestTimerClass');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_flcTimers_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetHighResolutionTick, 'GetHighResolutionTick', cdRegister);
 S.RegisterDelphiFunction(@GetHighResolutionFrequency, 'GetHighResolutionFrequency', cdRegister);
 S.RegisterDelphiFunction(@HighResolutionTickDelta, 'HighResolutionTickDelta', cdRegister);
 S.RegisterDelphiFunction(@HighResolutionTickDeltaU, 'HighResolutionTickDeltaU', cdRegister);
 S.RegisterDelphiFunction(@GetMicroTick, 'GetMicroTick', cdRegister);
 S.RegisterDelphiFunction(@MicroTickDelta, 'MicroTickDelta', cdRegister);
 S.RegisterDelphiFunction(@MicroTickDeltaU, 'MicroTickDeltaU', cdRegister);
 S.RegisterDelphiFunction(@GetMilliTick, 'GetMilliTick', cdRegister);
 S.RegisterDelphiFunction(@MilliTickDelta, 'MilliTickDelta', cdRegister);
 S.RegisterDelphiFunction(@MilliTickDeltaU, 'MilliTickDeltaU', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToMicroDateTime, 'DateTimeToMicroDateTime', cdRegister);
 S.RegisterDelphiFunction(@MicroDateTimeToDateTime, 'MicroDateTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@GetMicroDateTimeNow, 'GetMicroDateTimeNow', cdRegister);
 S.RegisterDelphiFunction(@GetNowUT, 'GetNowUT', cdRegister);
 S.RegisterDelphiFunction(@GetMicroDateTimeNowUT, 'GetMicroDateTimeNowUT', cdRegister);
 S.RegisterDelphiFunction(@GetNowUTC, 'GetNowUTC', cdRegister);
 S.RegisterDelphiFunction(@GetMicroDateTimeNowUTC, 'GetMicroDateTimeNowUTC', cdRegister);
 S.RegisterDelphiFunction(@TestTimer, 'TestTimerClass', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcTimers(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ETimerError) do
end;

 
 
{ TPSImport_flcTimers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcTimers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcTimers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcTimers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcTimers(ri);
  RIRegister_flcTimers_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
