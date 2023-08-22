unit uPSI_clockExpert;
{
   master clock set
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
  TPSImport_clockExpert = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TExpertClock(CL: TPSPascalCompiler);
procedure SIRegister_clockExpert(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_clockExpert_Routines(S: TPSExec);
procedure RIRegister_TExpertClock(CL: TPSRuntimeClassImporter);
procedure RIRegister_clockExpert(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,ExtCtrls
  ,Serial
  ,clockExpert
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_clockExpert]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TExpertClock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TExpertClock') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TExpertClock') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
       RegisterProperty('Status', 'TDCFStatus', iptr);
    RegisterProperty('ReserveTransmitter', 'BOOLEAN', iptr);
    RegisterProperty('SummerTime', 'BOOLEAN', iptr);
    RegisterProperty('SwitchSecond', 'BOOLEAN', iptr);
    RegisterProperty('Hour', 'WORD', iptr);
    RegisterProperty('Minute', 'WORD', iptr);
    RegisterProperty('Second', 'WORD', iptr);
    RegisterProperty('Day', 'WORD', iptr);
    RegisterProperty('Month', 'WORD', iptr);
    RegisterProperty('Year', 'WORD', iptr);
    RegisterProperty('Now', 'TDateTime', iptr);
    RegisterProperty('DayOfWeek', 'INTEGER', iptr);
    RegisterProperty('Quality', 'INTEGER', iptr);
    RegisterProperty('COMPort', 'INTEGER', iptrw);
    RegisterProperty('QualityLimit', 'INTEGER', iptrw);
    RegisterProperty('Active', 'BOOLEAN', iptrw);
    RegisterProperty('OnDCFClock', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStatusChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTimeChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnQualityAttained', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_clockExpert(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TDCFStatus', '( NotOpened, NoSignal, Synchronizing, ReceiveData, TimeAvailable )');
  SIRegister_TExpertClock(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TExpertClockOnQualityAttained_W(Self: TExpertClock; const T: TNotifyEvent);
begin Self.OnQualityAttained := T; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockOnQualityAttained_R(Self: TExpertClock; var T: TNotifyEvent);
begin T := Self.OnQualityAttained; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockOnTimeChanged_W(Self: TExpertClock; const T: TNotifyEvent);
begin Self.OnTimeChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockOnTimeChanged_R(Self: TExpertClock; var T: TNotifyEvent);
begin T := Self.OnTimeChanged; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockOnStatusChanged_W(Self: TExpertClock; const T: TNotifyEvent);
begin Self.OnStatusChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockOnStatusChanged_R(Self: TExpertClock; var T: TNotifyEvent);
begin T := Self.OnStatusChanged; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockOnDCFClock_W(Self: TExpertClock; const T: TNotifyEvent);
begin Self.OnDCFClock := T; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockOnDCFClock_R(Self: TExpertClock; var T: TNotifyEvent);
begin T := Self.OnDCFClock; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockActive_W(Self: TExpertClock; const T: BOOLEAN);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockActive_R(Self: TExpertClock; var T: BOOLEAN);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockQualityLimit_W(Self: TExpertClock; const T: INTEGER);
begin Self.QualityLimit := T; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockQualityLimit_R(Self: TExpertClock; var T: INTEGER);
begin T := Self.QualityLimit; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockCOMPort_W(Self: TExpertClock; const T: INTEGER);
begin Self.COMPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockCOMPort_R(Self: TExpertClock; var T: INTEGER);
begin T := Self.COMPort; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockQuality_R(Self: TExpertClock; var T: INTEGER);
begin T := Self.Quality; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockDayOfWeek_R(Self: TExpertClock; var T: INTEGER);
begin T := Self.DayOfWeek; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockNow_R(Self: TExpertClock; var T: TDateTime);
begin T := Self.Now; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockYear_R(Self: TExpertClock; var T: WORD);
begin T := Self.Year; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockMonth_R(Self: TExpertClock; var T: WORD);
begin T := Self.Month; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockDay_R(Self: TExpertClock; var T: WORD);
begin T := Self.Day; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockSecond_R(Self: TExpertClock; var T: WORD);
begin T := Self.Second; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockMinute_R(Self: TExpertClock; var T: WORD);
begin T := Self.Minute; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockHour_R(Self: TExpertClock; var T: WORD);
begin T := Self.Hour; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockSwitchSecond_R(Self: TExpertClock; var T: BOOLEAN);
begin T := Self.SwitchSecond; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockSummerTime_R(Self: TExpertClock; var T: BOOLEAN);
begin T := Self.SummerTime; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockReserveTransmitter_R(Self: TExpertClock; var T: BOOLEAN);
begin T := Self.ReserveTransmitter; end;

(*----------------------------------------------------------------------------*)
procedure TExpertClockStatus_R(Self: TExpertClock; var T: TDCFStatus);
begin T := Self.Status; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_clockExpert_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExpertClock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExpertClock) do
  begin
    RegisterConstructor(@TExpertClock.Create, 'Create');
    RegisterMethod(@TExpertClock.Destroy, 'Free');
    RegisterPropertyHelper(@TExpertClockStatus_R,nil,'Status');
    RegisterPropertyHelper(@TExpertClockReserveTransmitter_R,nil,'ReserveTransmitter');
    RegisterPropertyHelper(@TExpertClockSummerTime_R,nil,'SummerTime');
    RegisterPropertyHelper(@TExpertClockSwitchSecond_R,nil,'SwitchSecond');
    RegisterPropertyHelper(@TExpertClockHour_R,nil,'Hour');
    RegisterPropertyHelper(@TExpertClockMinute_R,nil,'Minute');
    RegisterPropertyHelper(@TExpertClockSecond_R,nil,'Second');
    RegisterPropertyHelper(@TExpertClockDay_R,nil,'Day');
    RegisterPropertyHelper(@TExpertClockMonth_R,nil,'Month');
    RegisterPropertyHelper(@TExpertClockYear_R,nil,'Year');
    RegisterPropertyHelper(@TExpertClockNow_R,nil,'Now');
    RegisterPropertyHelper(@TExpertClockDayOfWeek_R,nil,'DayOfWeek');
    RegisterPropertyHelper(@TExpertClockQuality_R,nil,'Quality');
    RegisterPropertyHelper(@TExpertClockCOMPort_R,@TExpertClockCOMPort_W,'COMPort');
    RegisterPropertyHelper(@TExpertClockQualityLimit_R,@TExpertClockQualityLimit_W,'QualityLimit');
    RegisterPropertyHelper(@TExpertClockActive_R,@TExpertClockActive_W,'Active');
    RegisterPropertyHelper(@TExpertClockOnDCFClock_R,@TExpertClockOnDCFClock_W,'OnDCFClock');
    RegisterPropertyHelper(@TExpertClockOnStatusChanged_R,@TExpertClockOnStatusChanged_W,'OnStatusChanged');
    RegisterPropertyHelper(@TExpertClockOnTimeChanged_R,@TExpertClockOnTimeChanged_W,'OnTimeChanged');
    RegisterPropertyHelper(@TExpertClockOnQualityAttained_R,@TExpertClockOnQualityAttained_W,'OnQualityAttained');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_clockExpert(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TExpertClock(CL);
end;

 
 
{ TPSImport_clockExpert }
(*----------------------------------------------------------------------------*)
procedure TPSImport_clockExpert.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_clockExpert(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_clockExpert.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_clockExpert(ri);
 // RIRegister_clockExpert_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
