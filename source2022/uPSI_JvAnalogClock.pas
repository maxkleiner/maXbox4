unit uPSI_JvAnalogClock;
{
  more events
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
  TPSImport_JvAnalogClock = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvAnalogClock(CL: TPSPascalCompiler);
procedure SIRegister_JvAnalogClock(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvAnalogClock(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvAnalogClock(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ExtCtrls
  ,JvComponent
  ,JvAnalogClock
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvAnalogClock]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAnalogClock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomPanel', 'TJvAnalogClock') do
  with CL.AddClassN(CL.FindClass('TJvCustomPanel'),'TJvAnalogClock') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterPublishedProperties;
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('ParentColor', 'TColor', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('BevelWidth','TBevelWidth',iptrw);
    RegisterProperty('OnClick', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDblClick', 'TNotifyEvent', iptrw);
    RegisterProperty('OnEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnExit', 'TNotifyEvent', iptrw);
    RegisterProperty('Transparent', 'boolean', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);

   {property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible; }

    RegisterProperty('Date', 'Boolean', iptrw);
    RegisterProperty('ClockEnabled', 'Boolean', iptrw);
    RegisterProperty('TimeSet', 'TDateTime', iptrw);
    RegisterProperty('TimeOffset', 'Integer', iptrw);
    RegisterProperty('SpiderClock', 'Boolean', iptrw);
    RegisterProperty('SecJump', 'Boolean', iptrw);
    RegisterProperty('Seconds', 'Boolean', iptrw);
    RegisterProperty('MinMarks', 'Boolean', iptrw);
    RegisterProperty('HourStyle', 'TJvHourStyle', iptrw);
    RegisterProperty('MinuteStyle', 'TJvHourStyle', iptrw);
    RegisterProperty('HourMarks', 'TJvHourMarks', iptrw);
    RegisterProperty('HourSize', 'Integer', iptrw);
    RegisterProperty('MinuteSize', 'Integer', iptrw);
    RegisterProperty('MinuteFontSize', 'Integer', iptrw);
    RegisterProperty('ColorHr', 'TColor', iptrw);
    RegisterProperty('ColorHrIn', 'TColor', iptrw);
    RegisterProperty('ColorMin', 'TColor', iptrw);
    RegisterProperty('ColorMinIn', 'TColor', iptrw);
    RegisterProperty('ColorHandHr', 'TColor', iptrw);
    RegisterProperty('ColorHandMin', 'TColor', iptrw);
    RegisterProperty('ColorHandSec', 'TColor', iptrw);
    RegisterProperty('WidthHandSec', 'Byte', iptrw);
    RegisterProperty('WidthHandMin', 'Byte', iptrw);
    RegisterProperty('WidthHandHr', 'Byte', iptrw);
    RegisterProperty('WidthHr', 'Byte', iptrw);
    RegisterProperty('WidthMin', 'Byte', iptrw);
    RegisterProperty('CenterSize', 'Byte', iptrw);
    RegisterProperty('CenterCol', 'TColor', iptrw);
    RegisterProperty('OnChangeSec', 'TJvNotifyTime', iptrw);
    RegisterProperty('OnChangeMin', 'TJvNotifyTime', iptrw);
    RegisterProperty('OnChangeHour', 'TJvNotifyTime', iptrw);
    RegisterProperty('OnSameTime', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvAnalogClock(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvNotifyTime', 'Procedure (Sender: TObject; Hour,Min,Sec: Integer)');
  CL.AddTypeS('TJvHourStyle', '( hsLine, hsCircle, hsNumber, hsNumberInCircle )');
  CL.AddTypeS('TJvHourMarks', '( hmNone, hmFour, hmAll )');
  SIRegister_TJvAnalogClock(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockOnSameTime_W(Self: TJvAnalogClock; const T: TNotifyEvent);
begin Self.OnSameTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockOnSameTime_R(Self: TJvAnalogClock; var T: TNotifyEvent);
begin T := Self.OnSameTime; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockOnChangeHour_W(Self: TJvAnalogClock; const T: TJvNotifyTime);
begin Self.OnChangeHour := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockOnChangeHour_R(Self: TJvAnalogClock; var T: TJvNotifyTime);
begin T := Self.OnChangeHour; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockOnChangeMin_W(Self: TJvAnalogClock; const T: TJvNotifyTime);
begin Self.OnChangeMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockOnChangeMin_R(Self: TJvAnalogClock; var T: TJvNotifyTime);
begin T := Self.OnChangeMin; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockOnChangeSec_W(Self: TJvAnalogClock; const T: TJvNotifyTime);
begin Self.OnChangeSec := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockOnChangeSec_R(Self: TJvAnalogClock; var T: TJvNotifyTime);
begin T := Self.OnChangeSec; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockCenterCol_W(Self: TJvAnalogClock; const T: TColor);
begin Self.CenterCol := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockCenterCol_R(Self: TJvAnalogClock; var T: TColor);
begin T := Self.CenterCol; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockCenterSize_W(Self: TJvAnalogClock; const T: Byte);
begin Self.CenterSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockCenterSize_R(Self: TJvAnalogClock; var T: Byte);
begin T := Self.CenterSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockWidthMin_W(Self: TJvAnalogClock; const T: Byte);
begin Self.WidthMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockWidthMin_R(Self: TJvAnalogClock; var T: Byte);
begin T := Self.WidthMin; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockWidthHr_W(Self: TJvAnalogClock; const T: Byte);
begin Self.WidthHr := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockWidthHr_R(Self: TJvAnalogClock; var T: Byte);
begin T := Self.WidthHr; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockWidthHandHr_W(Self: TJvAnalogClock; const T: Byte);
begin Self.WidthHandHr := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockWidthHandHr_R(Self: TJvAnalogClock; var T: Byte);
begin T := Self.WidthHandHr; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockWidthHandMin_W(Self: TJvAnalogClock; const T: Byte);
begin Self.WidthHandMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockWidthHandMin_R(Self: TJvAnalogClock; var T: Byte);
begin T := Self.WidthHandMin; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockWidthHandSec_W(Self: TJvAnalogClock; const T: Byte);
begin Self.WidthHandSec := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockWidthHandSec_R(Self: TJvAnalogClock; var T: Byte);
begin T := Self.WidthHandSec; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorHandSec_W(Self: TJvAnalogClock; const T: TColor);
begin Self.ColorHandSec := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorHandSec_R(Self: TJvAnalogClock; var T: TColor);
begin T := Self.ColorHandSec; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorHandMin_W(Self: TJvAnalogClock; const T: TColor);
begin Self.ColorHandMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorHandMin_R(Self: TJvAnalogClock; var T: TColor);
begin T := Self.ColorHandMin; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorHandHr_W(Self: TJvAnalogClock; const T: TColor);
begin Self.ColorHandHr := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorHandHr_R(Self: TJvAnalogClock; var T: TColor);
begin T := Self.ColorHandHr; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorMinIn_W(Self: TJvAnalogClock; const T: TColor);
begin Self.ColorMinIn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorMinIn_R(Self: TJvAnalogClock; var T: TColor);
begin T := Self.ColorMinIn; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorMin_W(Self: TJvAnalogClock; const T: TColor);
begin Self.ColorMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorMin_R(Self: TJvAnalogClock; var T: TColor);
begin T := Self.ColorMin; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorHrIn_W(Self: TJvAnalogClock; const T: TColor);
begin Self.ColorHrIn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorHrIn_R(Self: TJvAnalogClock; var T: TColor);
begin T := Self.ColorHrIn; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorHr_W(Self: TJvAnalogClock; const T: TColor);
begin Self.ColorHr := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockColorHr_R(Self: TJvAnalogClock; var T: TColor);
begin T := Self.ColorHr; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockMinuteFontSize_W(Self: TJvAnalogClock; const T: Integer);
begin Self.MinuteFontSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockMinuteFontSize_R(Self: TJvAnalogClock; var T: Integer);
begin T := Self.MinuteFontSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockMinuteSize_W(Self: TJvAnalogClock; const T: Integer);
begin Self.MinuteSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockMinuteSize_R(Self: TJvAnalogClock; var T: Integer);
begin T := Self.MinuteSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockHourSize_W(Self: TJvAnalogClock; const T: Integer);
begin Self.HourSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockHourSize_R(Self: TJvAnalogClock; var T: Integer);
begin T := Self.HourSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockHourMarks_W(Self: TJvAnalogClock; const T: TJvHourMarks);
begin Self.HourMarks := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockHourMarks_R(Self: TJvAnalogClock; var T: TJvHourMarks);
begin T := Self.HourMarks; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockMinuteStyle_W(Self: TJvAnalogClock; const T: TJvHourStyle);
begin Self.MinuteStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockMinuteStyle_R(Self: TJvAnalogClock; var T: TJvHourStyle);
begin T := Self.MinuteStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockHourStyle_W(Self: TJvAnalogClock; const T: TJvHourStyle);
begin Self.HourStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockHourStyle_R(Self: TJvAnalogClock; var T: TJvHourStyle);
begin T := Self.HourStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockMinMarks_W(Self: TJvAnalogClock; const T: Boolean);
begin Self.MinMarks := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockMinMarks_R(Self: TJvAnalogClock; var T: Boolean);
begin T := Self.MinMarks; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockSeconds_W(Self: TJvAnalogClock; const T: Boolean);
begin Self.Seconds := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockSeconds_R(Self: TJvAnalogClock; var T: Boolean);
begin T := Self.Seconds; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockSecJump_W(Self: TJvAnalogClock; const T: Boolean);
begin Self.SecJump := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockSecJump_R(Self: TJvAnalogClock; var T: Boolean);
begin T := Self.SecJump; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockSpiderClock_W(Self: TJvAnalogClock; const T: Boolean);
begin Self.SpiderClock := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockSpiderClock_R(Self: TJvAnalogClock; var T: Boolean);
begin T := Self.SpiderClock; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockTimeOffset_W(Self: TJvAnalogClock; const T: Integer);
begin Self.TimeOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockTimeOffset_R(Self: TJvAnalogClock; var T: Integer);
begin T := Self.TimeOffset; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockTimeSet_W(Self: TJvAnalogClock; const T: TDateTime);
begin Self.TimeSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockTimeSet_R(Self: TJvAnalogClock; var T: TDateTime);
begin T := Self.TimeSet; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockClockEnabled_W(Self: TJvAnalogClock; const T: Boolean);
begin Self.ClockEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockClockEnabled_R(Self: TJvAnalogClock; var T: Boolean);
begin T := Self.ClockEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockDate_W(Self: TJvAnalogClock; const T: Boolean);
begin Self.Date := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnalogClockDate_R(Self: TJvAnalogClock; var T: Boolean);
begin T := Self.Date; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAnalogClock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAnalogClock) do begin
    RegisterConstructor(@TJvAnalogClock.Create, 'Create');
     RegisterMethod(@TJvAnalogClock.Destroy, 'Free');
    RegisterPropertyHelper(@TJvAnalogClockDate_R,@TJvAnalogClockDate_W,'Date');
    RegisterPropertyHelper(@TJvAnalogClockClockEnabled_R,@TJvAnalogClockClockEnabled_W,'ClockEnabled');
    RegisterPropertyHelper(@TJvAnalogClockTimeSet_R,@TJvAnalogClockTimeSet_W,'TimeSet');
    RegisterPropertyHelper(@TJvAnalogClockTimeOffset_R,@TJvAnalogClockTimeOffset_W,'TimeOffset');
    RegisterPropertyHelper(@TJvAnalogClockSpiderClock_R,@TJvAnalogClockSpiderClock_W,'SpiderClock');
    RegisterPropertyHelper(@TJvAnalogClockSecJump_R,@TJvAnalogClockSecJump_W,'SecJump');
    RegisterPropertyHelper(@TJvAnalogClockSeconds_R,@TJvAnalogClockSeconds_W,'Seconds');
    RegisterPropertyHelper(@TJvAnalogClockMinMarks_R,@TJvAnalogClockMinMarks_W,'MinMarks');
    RegisterPropertyHelper(@TJvAnalogClockHourStyle_R,@TJvAnalogClockHourStyle_W,'HourStyle');
    RegisterPropertyHelper(@TJvAnalogClockMinuteStyle_R,@TJvAnalogClockMinuteStyle_W,'MinuteStyle');
    RegisterPropertyHelper(@TJvAnalogClockHourMarks_R,@TJvAnalogClockHourMarks_W,'HourMarks');
    RegisterPropertyHelper(@TJvAnalogClockHourSize_R,@TJvAnalogClockHourSize_W,'HourSize');
    RegisterPropertyHelper(@TJvAnalogClockMinuteSize_R,@TJvAnalogClockMinuteSize_W,'MinuteSize');
    RegisterPropertyHelper(@TJvAnalogClockMinuteFontSize_R,@TJvAnalogClockMinuteFontSize_W,'MinuteFontSize');
    RegisterPropertyHelper(@TJvAnalogClockColorHr_R,@TJvAnalogClockColorHr_W,'ColorHr');
    RegisterPropertyHelper(@TJvAnalogClockColorHrIn_R,@TJvAnalogClockColorHrIn_W,'ColorHrIn');
    RegisterPropertyHelper(@TJvAnalogClockColorMin_R,@TJvAnalogClockColorMin_W,'ColorMin');
    RegisterPropertyHelper(@TJvAnalogClockColorMinIn_R,@TJvAnalogClockColorMinIn_W,'ColorMinIn');
    RegisterPropertyHelper(@TJvAnalogClockColorHandHr_R,@TJvAnalogClockColorHandHr_W,'ColorHandHr');
    RegisterPropertyHelper(@TJvAnalogClockColorHandMin_R,@TJvAnalogClockColorHandMin_W,'ColorHandMin');
    RegisterPropertyHelper(@TJvAnalogClockColorHandSec_R,@TJvAnalogClockColorHandSec_W,'ColorHandSec');
    RegisterPropertyHelper(@TJvAnalogClockWidthHandSec_R,@TJvAnalogClockWidthHandSec_W,'WidthHandSec');
    RegisterPropertyHelper(@TJvAnalogClockWidthHandMin_R,@TJvAnalogClockWidthHandMin_W,'WidthHandMin');
    RegisterPropertyHelper(@TJvAnalogClockWidthHandHr_R,@TJvAnalogClockWidthHandHr_W,'WidthHandHr');
    RegisterPropertyHelper(@TJvAnalogClockWidthHr_R,@TJvAnalogClockWidthHr_W,'WidthHr');
    RegisterPropertyHelper(@TJvAnalogClockWidthMin_R,@TJvAnalogClockWidthMin_W,'WidthMin');
    RegisterPropertyHelper(@TJvAnalogClockCenterSize_R,@TJvAnalogClockCenterSize_W,'CenterSize');
    RegisterPropertyHelper(@TJvAnalogClockCenterCol_R,@TJvAnalogClockCenterCol_W,'CenterCol');
    RegisterPropertyHelper(@TJvAnalogClockOnChangeSec_R,@TJvAnalogClockOnChangeSec_W,'OnChangeSec');
    RegisterPropertyHelper(@TJvAnalogClockOnChangeMin_R,@TJvAnalogClockOnChangeMin_W,'OnChangeMin');
    RegisterPropertyHelper(@TJvAnalogClockOnChangeHour_R,@TJvAnalogClockOnChangeHour_W,'OnChangeHour');
    RegisterPropertyHelper(@TJvAnalogClockOnSameTime_R,@TJvAnalogClockOnSameTime_W,'OnSameTime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvAnalogClock(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvAnalogClock(CL);
end;

 
 
{ TPSImport_JvAnalogClock }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAnalogClock.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvAnalogClock(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAnalogClock.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvAnalogClock(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
