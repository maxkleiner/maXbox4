unit uPSI_WaveTimer;
{
   time set let
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
  TPSImport_WaveTimer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMultimediaTimer(CL: TPSPascalCompiler);
procedure SIRegister_WaveTimer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMultimediaTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_WaveTimer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,mmSystem
  ,WaveTimer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WaveTimer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMultimediaTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TMultimediaTimer') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TMultimediaTimer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
    RegisterMethod('Function TimerCaps : TTimeCaps');
    RegisterProperty('TimerID', 'Integer', iptr);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Interval', 'WORD', iptrw);
    RegisterProperty('Resolution', 'WORD', iptrw);
    RegisterProperty('OnTimer', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_WaveTimer(CL: TPSPascalCompiler);
begin
  SIRegister_TMultimediaTimer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerOnTimer_W(Self: TMultimediaTimer; const T: TNotifyEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerOnTimer_R(Self: TMultimediaTimer; var T: TNotifyEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerResolution_W(Self: TMultimediaTimer; const T: WORD);
begin Self.Resolution := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerResolution_R(Self: TMultimediaTimer; var T: WORD);
begin T := Self.Resolution; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerInterval_W(Self: TMultimediaTimer; const T: WORD);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerInterval_R(Self: TMultimediaTimer; var T: WORD);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerEnabled_W(Self: TMultimediaTimer; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerEnabled_R(Self: TMultimediaTimer; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TMultimediaTimerTimerID_R(Self: TMultimediaTimer; var T: Integer);
begin T := Self.TimerID; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMultimediaTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMultimediaTimer) do begin
    RegisterConstructor(@TMultimediaTimer.Create, 'Create');
     RegisterMethod(@TMultimediaTimer.Destroy, 'Free');
     RegisterMethod(@TMultimediaTimer.TimerCaps, 'TimerCaps');
    RegisterPropertyHelper(@TMultimediaTimerTimerID_R,nil,'TimerID');
    RegisterPropertyHelper(@TMultimediaTimerEnabled_R,@TMultimediaTimerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TMultimediaTimerInterval_R,@TMultimediaTimerInterval_W,'Interval');
    RegisterPropertyHelper(@TMultimediaTimerResolution_R,@TMultimediaTimerResolution_W,'Resolution');
    RegisterPropertyHelper(@TMultimediaTimerOnTimer_R,@TMultimediaTimerOnTimer_W,'OnTimer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WaveTimer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMultimediaTimer(CL);
end;

 
 
{ TPSImport_WaveTimer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WaveTimer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WaveTimer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WaveTimer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WaveTimer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
