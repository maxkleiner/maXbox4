unit uPSI_ovctimer;
{
  oneshot timer
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
  TPSImport_ovctimer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcTimerPool(CL: TPSPascalCompiler);
procedure SIRegister_ovctimer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcTimerPool(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovctimer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Forms
  ,OvcExcpt
  ,OvcVer
  ,ovctimer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovctimer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcTimerPool(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TOvcTimerPool') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TOvcTimerPool') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function AddOneShot( OnTrigger : TTriggerEvent; Interval : Cardinal) : Integer');
    RegisterMethod('Function AddOneTime( OnTrigger : TTriggerEvent; Interval : Cardinal) : Integer');
    RegisterMethod('Function Add( OnTrigger : TTriggerEvent; Interval : Cardinal) : Integer');
    RegisterMethod('Procedure Remove( Handle : Integer)');
    RegisterMethod('Procedure RemoveAll');
    RegisterMethod('Procedure ResetElapsedTime( Handle : Integer)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('ElapsedTime', 'LongInt Integer', iptr);
    RegisterProperty('ElapsedTimeSec', 'LongInt Integer', iptr);
    RegisterProperty('Enabled', 'Boolean Integer', iptrw);
    RegisterProperty('Interval', 'Cardinal Integer', iptrw);
    RegisterProperty('OnTrigger', 'TovTriggerEvent Integer', iptrw);
    RegisterProperty('About', 'string', iptrw);
    RegisterProperty('OnAllTriggers', 'TovTriggerEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovctimer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TovTriggerEvent', 'Procedure ( Sender : TObject; Handle : Integer;'
   +' Interval : Cardinal; ElapsedTime : LongInt)');
  //CL.AddTypeS('PEventRec', '^TEventRec // will not work');
  CL.AddTypeS('TEventRec', 'record erHandle : Integer; erInitTime : LongInt; er'
   +'Elapsed : LongInt; erInterval : Cardinal; erLastTrigger : LongInt; erOnTri'
   +'gger : TovTriggerEvent; erEnabled : Boolean; erRecurring : Boolean; end');
  SIRegister_TOvcTimerPool(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolOnAllTriggers_W(Self: TOvcTimerPool; const T: TTriggerEvent);
begin Self.OnAllTriggers := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolOnAllTriggers_R(Self: TOvcTimerPool; var T: TTriggerEvent);
begin T := Self.OnAllTriggers; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolAbout_W(Self: TOvcTimerPool; const T: string);
begin Self.About := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolAbout_R(Self: TOvcTimerPool; var T: string);
begin T := Self.About; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolOnTrigger_W(Self: TOvcTimerPool; const T: TTriggerEvent; const t1: Integer);
begin Self.OnTrigger[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolOnTrigger_R(Self: TOvcTimerPool; var T: TTriggerEvent; const t1: Integer);
begin T := Self.OnTrigger[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolInterval_W(Self: TOvcTimerPool; const T: Cardinal; const t1: Integer);
begin Self.Interval[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolInterval_R(Self: TOvcTimerPool; var T: Cardinal; const t1: Integer);
begin T := Self.Interval[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolEnabled_W(Self: TOvcTimerPool; const T: Boolean; const t1: Integer);
begin Self.Enabled[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolEnabled_R(Self: TOvcTimerPool; var T: Boolean; const t1: Integer);
begin T := Self.Enabled[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolElapsedTimeSec_R(Self: TOvcTimerPool; var T: LongInt; const t1: Integer);
begin T := Self.ElapsedTimeSec[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolElapsedTime_R(Self: TOvcTimerPool; var T: LongInt; const t1: Integer);
begin T := Self.ElapsedTime[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TOvcTimerPoolCount_R(Self: TOvcTimerPool; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcTimerPool(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcTimerPool) do begin
    RegisterConstructor(@TOvcTimerPool.Create, 'Create');
      RegisterMethod(@TOvcTimerPool.Destroy, 'Free');
     RegisterMethod(@TOvcTimerPool.AddOneShot, 'AddOneShot');
    RegisterMethod(@TOvcTimerPool.AddOneTime, 'AddOneTime');
    RegisterMethod(@TOvcTimerPool.Add, 'Add');
    RegisterMethod(@TOvcTimerPool.Remove, 'Remove');
    RegisterMethod(@TOvcTimerPool.RemoveAll, 'RemoveAll');
    RegisterMethod(@TOvcTimerPool.ResetElapsedTime, 'ResetElapsedTime');
    RegisterPropertyHelper(@TOvcTimerPoolCount_R,nil,'Count');
    RegisterPropertyHelper(@TOvcTimerPoolElapsedTime_R,nil,'ElapsedTime');
    RegisterPropertyHelper(@TOvcTimerPoolElapsedTimeSec_R,nil,'ElapsedTimeSec');
    RegisterPropertyHelper(@TOvcTimerPoolEnabled_R,@TOvcTimerPoolEnabled_W,'Enabled');
    RegisterPropertyHelper(@TOvcTimerPoolInterval_R,@TOvcTimerPoolInterval_W,'Interval');
    RegisterPropertyHelper(@TOvcTimerPoolOnTrigger_R,@TOvcTimerPoolOnTrigger_W,'OnTrigger');
    RegisterPropertyHelper(@TOvcTimerPoolAbout_R,@TOvcTimerPoolAbout_W,'About');
    RegisterPropertyHelper(@TOvcTimerPoolOnAllTriggers_R,@TOvcTimerPoolOnAllTriggers_W,'OnAllTriggers');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovctimer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcTimerPool(CL);
end;

 
 
{ TPSImport_ovctimer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovctimer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovctimer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovctimer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovctimer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
