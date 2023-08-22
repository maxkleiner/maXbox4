unit uPSI_ovcclock;
{
  clock stock
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
  TPSImport_ovcclock = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcClock(CL: TPSPascalCompiler);
procedure SIRegister_TOvcCustomClock(CL: TPSPascalCompiler);
procedure SIRegister_TOvcHandOptions(CL: TPSPascalCompiler);
procedure SIRegister_TOvcDigitalOptions(CL: TPSPascalCompiler);
procedure SIRegister_TOvcLEDClockDisplay(CL: TPSPascalCompiler);
procedure SIRegister_ovcclock(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcClock(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcCustomClock(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcHandOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcDigitalOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcLEDClockDisplay(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcclock(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Dialogs
  ,Forms
  ,Graphics
  ,Menus
  ,Messages
  ,OvcBase
  ,OvcMisc
  ,OvcDate
  ,O32LEDLabel
  ,ovcclock
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcclock]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcClock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcCustomClock', 'TOvcClock') do
  with CL.AddClassN(CL.FindClass('TOvcCustomClock'),'TOvcClock') do begin
     REgisterPublishedProperties;
     RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     RegisterProperty('ParentColor', 'TColor', iptrw);
    RegisterProperty('BevelWidth','TBevelWidth',iptrw);
    RegisterProperty('Parent','TWinControl',iptrw);
    // property Parent: TWinControl read FParent write SetParent;
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
    //  RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('ClockFace', 'TBitMap', iptrw);
    RegisterProperty('ClockMode', 'TOvcClockMode', iptrw);
    RegisterProperty('DigitalOptions', 'DigitalOptions', iptrw);
    RegisterProperty('DrawMarks', 'Boolean', iptrw);
    RegisterProperty('HandOptions', 'TOvcHandOptions', iptrw);
    RegisterProperty('MinuteOffset', 'integer', iptrw);
    RegisterProperty('TimeOffset', 'integer', iptrw);
    RegisterProperty('HourOffset', 'integer', iptrw);
    RegisterProperty('SecondOffset', 'integer', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCustomClock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcCustomControlEx', 'TOvcCustomClock') do
  with CL.AddClassN(CL.FindClass('TOvcCustomControlEx'),'TOvcCustomClock') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free)');
     RegisterMethod('Procedure SetBounds( ALeft, ATop, AWidth, AHeight : Integer)');
    RegisterProperty('DisplayMode', 'TOvcClockDisplayMode', iptrw);
      RegisterProperty('Parent','TWinControl',iptrw);
     RegisterProperty('ElapsedDays', 'Integer', iptr);
    RegisterProperty('ElapsedHours', 'Integer', iptr);
    RegisterProperty('ElapsedMinutes', 'LongInt', iptr);
    RegisterProperty('ElapsedSeconds', 'LongInt', iptr);
    RegisterProperty('ElapsedSecondsTotal', 'LongInt', iptr);
    RegisterProperty('Time', 'TDateTime', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcHandOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TOvcHandOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TOvcHandOptions') do begin
    RegisterMethod('procedure Assign(Source : TPersistent);');
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('HourHandColor', 'TColor', iptrw);
    RegisterProperty('HourHandLength', 'TOvcPercent', iptrw);
    RegisterProperty('HourHandWidth', 'Integer', iptrw);
    RegisterProperty('MinuteHandColor', 'TColor', iptrw);
    RegisterProperty('MinuteHandLength', 'TOvcPercent', iptrw);
    RegisterProperty('MinuteHandWidth', 'Integer', iptrw);
    RegisterProperty('SecondHandColor', 'TColor', iptrw);
    RegisterProperty('SecondHandLength', 'TOvcPercent', iptrw);
    RegisterProperty('SecondHandWidth', 'Integer', iptrw);
    RegisterProperty('ShowSecondHand', 'Boolean', iptrw);
    RegisterProperty('SolidHands', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcDigitalOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TOvcDigitalOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TOvcDigitalOptions') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('MilitaryTime', 'Boolean', iptrw);
    RegisterProperty('OnColor', 'TColor', iptrw);
    RegisterProperty('OffColor', 'TColor', iptrw);
    RegisterProperty('BgColor', 'TColor', iptrw);
    RegisterProperty('Size', 'TSegmentSize', iptrw);
    RegisterProperty('ShowSeconds', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcLEDClockDisplay(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TO32CustomLEDLabel', 'TOvcLEDClockDisplay') do
  with CL.AddClassN(CL.FindClass('TO32CustomLEDLabel'),'TOvcLEDClockDisplay') do
  begin
    RegisterMethod('Procedure PaintSelf');
     REgisterPublishedProperties;
       RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
    //  RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
     RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcclock(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOvcPercent', 'Integer');
  CL.AddTypeS('TOvcClockMode', '( cmClock, cmTimer, cmCountdownTimer )');
  CL.AddTypeS('TOvcClockDisplayMode', '( dmAnalog, dmDigital )');
  SIRegister_TOvcLEDClockDisplay(CL);
  SIRegister_TOvcDigitalOptions(CL);
  SIRegister_TOvcHandOptions(CL);
  SIRegister_TOvcCustomClock(CL);
  SIRegister_TOvcClock(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcCustomClockParent_W(Self: TOvcCustomClock; const T: TWincontrol);
begin Self.parent:= T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomClockParent_R(Self: TOvcCustomClock; var T: TWinControl);
begin T:= Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomClockTime_W(Self: TOvcCustomClock; const T: TDateTime);
begin Self.Time := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomClockTime_R(Self: TOvcCustomClock; var T: TDateTime);
begin T := Self.Time; end;


(*----------------------------------------------------------------------------*)
procedure TOvcCustomClockElapsedSecondsTotal_R(Self: TOvcCustomClock; var T: LongInt);
begin T := Self.ElapsedSecondsTotal; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomClockElapsedSeconds_R(Self: TOvcCustomClock; var T: LongInt);
begin T := Self.ElapsedSeconds; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomClockElapsedMinutes_R(Self: TOvcCustomClock; var T: LongInt);
begin T := Self.ElapsedMinutes; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomClockElapsedHours_R(Self: TOvcCustomClock; var T: Integer);
begin T := Self.ElapsedHours; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomClockElapsedDays_R(Self: TOvcCustomClock; var T: Integer);
begin T := Self.ElapsedDays; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomClockDisplayMode_W(Self: TOvcCustomClock; const T: TOvcClockDisplayMode);
begin Self.DisplayMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomClockDisplayMode_R(Self: TOvcCustomClock; var T: TOvcClockDisplayMode);
begin T := Self.DisplayMode; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsSolidHands_W(Self: TOvcHandOptions; const T: Boolean);
begin Self.SolidHands := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsSolidHands_R(Self: TOvcHandOptions; var T: Boolean);
begin T := Self.SolidHands; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsShowSecondHand_W(Self: TOvcHandOptions; const T: Boolean);
begin Self.ShowSecondHand := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsShowSecondHand_R(Self: TOvcHandOptions; var T: Boolean);
begin T := Self.ShowSecondHand; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsSecondHandWidth_W(Self: TOvcHandOptions; const T: Integer);
begin Self.SecondHandWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsSecondHandWidth_R(Self: TOvcHandOptions; var T: Integer);
begin T := Self.SecondHandWidth; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsSecondHandLength_W(Self: TOvcHandOptions; const T: TOvcPercent);
begin Self.SecondHandLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsSecondHandLength_R(Self: TOvcHandOptions; var T: TOvcPercent);
begin T := Self.SecondHandLength; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsSecondHandColor_W(Self: TOvcHandOptions; const T: TColor);
begin Self.SecondHandColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsSecondHandColor_R(Self: TOvcHandOptions; var T: TColor);
begin T := Self.SecondHandColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsMinuteHandWidth_W(Self: TOvcHandOptions; const T: Integer);
begin Self.MinuteHandWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsMinuteHandWidth_R(Self: TOvcHandOptions; var T: Integer);
begin T := Self.MinuteHandWidth; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsMinuteHandLength_W(Self: TOvcHandOptions; const T: TOvcPercent);
begin Self.MinuteHandLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsMinuteHandLength_R(Self: TOvcHandOptions; var T: TOvcPercent);
begin T := Self.MinuteHandLength; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsMinuteHandColor_W(Self: TOvcHandOptions; const T: TColor);
begin Self.MinuteHandColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsMinuteHandColor_R(Self: TOvcHandOptions; var T: TColor);
begin T := Self.MinuteHandColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsHourHandWidth_W(Self: TOvcHandOptions; const T: Integer);
begin Self.HourHandWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsHourHandWidth_R(Self: TOvcHandOptions; var T: Integer);
begin T := Self.HourHandWidth; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsHourHandLength_W(Self: TOvcHandOptions; const T: TOvcPercent);
begin Self.HourHandLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsHourHandLength_R(Self: TOvcHandOptions; var T: TOvcPercent);
begin T := Self.HourHandLength; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsHourHandColor_W(Self: TOvcHandOptions; const T: TColor);
begin Self.HourHandColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsHourHandColor_R(Self: TOvcHandOptions; var T: TColor);
begin T := Self.HourHandColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsOnChange_W(Self: TOvcHandOptions; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcHandOptionsOnChange_R(Self: TOvcHandOptions; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsShowSeconds_W(Self: TOvcDigitalOptions; const T: Boolean);
begin Self.ShowSeconds := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsShowSeconds_R(Self: TOvcDigitalOptions; var T: Boolean);
begin T := Self.ShowSeconds; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsSize_W(Self: TOvcDigitalOptions; const T: TSegmentSize);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsSize_R(Self: TOvcDigitalOptions; var T: TSegmentSize);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsBgColor_W(Self: TOvcDigitalOptions; const T: TColor);
begin Self.BgColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsBgColor_R(Self: TOvcDigitalOptions; var T: TColor);
begin T := Self.BgColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsOffColor_W(Self: TOvcDigitalOptions; const T: TColor);
begin Self.OffColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsOffColor_R(Self: TOvcDigitalOptions; var T: TColor);
begin T := Self.OffColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsOnColor_W(Self: TOvcDigitalOptions; const T: TColor);
begin Self.OnColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsOnColor_R(Self: TOvcDigitalOptions; var T: TColor);
begin T := Self.OnColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsMilitaryTime_W(Self: TOvcDigitalOptions; const T: Boolean);
begin Self.MilitaryTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsMilitaryTime_R(Self: TOvcDigitalOptions; var T: Boolean);
begin T := Self.MilitaryTime; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsOnChange_W(Self: TOvcDigitalOptions; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDigitalOptionsOnChange_R(Self: TOvcDigitalOptions; var T: TNotifyEvent);
begin T := Self.OnChange; end;


(*----------------------------------------------------------------------------*)
procedure TOvcClockParent_W(Self: TOvcCustomClock; const T: TWincontrol);
begin Self.parent:= T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcClockParent_R(Self: TOvcCustomClock; var T: TWinControl);
begin T:= Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcClock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcClock) do begin
    RegisterPropertyHelper(@TOvcClockParent_R,@TOvcClockParent_W,'Parent');
  end;
end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCustomClock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCustomClock) do begin
    RegisterConstructor(@TOvcCustomClock.Create, 'Create');
    RegisterMethod(@TOvcCustomClock.Free, 'Free');
    RegisterPropertyHelper(@TOvcCustomClockParent_R,@TOvcCustomClockParent_W,'Parent');
    RegisterMethod(@TOvcCustomClock.SetBounds, 'SetBounds');
    RegisterPropertyHelper(@TOvcCustomClockDisplayMode_R,@TOvcCustomClockDisplayMode_W,'DisplayMode');
    RegisterPropertyHelper(@TOvcCustomClockElapsedDays_R,nil,'ElapsedDays');
    RegisterPropertyHelper(@TOvcCustomClockElapsedHours_R,nil,'ElapsedHours');
    RegisterPropertyHelper(@TOvcCustomClockElapsedMinutes_R,nil,'ElapsedMinutes');
    RegisterPropertyHelper(@TOvcCustomClockElapsedSeconds_R,nil,'ElapsedSeconds');
    RegisterPropertyHelper(@TOvcCustomClockElapsedSecondsTotal_R,nil,'ElapsedSecondsTotal');
    RegisterPropertyHelper(@TOvcCustomClockTime_R,@TOvcCustomClockTime_W,'Time');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcHandOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcHandOptions) do begin
    RegisterMethod(@TOvcHandOptions.Assign, 'Assign');
     RegisterPropertyHelper(@TOvcHandOptionsOnChange_R,@TOvcHandOptionsOnChange_W,'OnChange');
    RegisterPropertyHelper(@TOvcHandOptionsHourHandColor_R,@TOvcHandOptionsHourHandColor_W,'HourHandColor');
    RegisterPropertyHelper(@TOvcHandOptionsHourHandLength_R,@TOvcHandOptionsHourHandLength_W,'HourHandLength');
    RegisterPropertyHelper(@TOvcHandOptionsHourHandWidth_R,@TOvcHandOptionsHourHandWidth_W,'HourHandWidth');
    RegisterPropertyHelper(@TOvcHandOptionsMinuteHandColor_R,@TOvcHandOptionsMinuteHandColor_W,'MinuteHandColor');
    RegisterPropertyHelper(@TOvcHandOptionsMinuteHandLength_R,@TOvcHandOptionsMinuteHandLength_W,'MinuteHandLength');
    RegisterPropertyHelper(@TOvcHandOptionsMinuteHandWidth_R,@TOvcHandOptionsMinuteHandWidth_W,'MinuteHandWidth');
    RegisterPropertyHelper(@TOvcHandOptionsSecondHandColor_R,@TOvcHandOptionsSecondHandColor_W,'SecondHandColor');
    RegisterPropertyHelper(@TOvcHandOptionsSecondHandLength_R,@TOvcHandOptionsSecondHandLength_W,'SecondHandLength');
    RegisterPropertyHelper(@TOvcHandOptionsSecondHandWidth_R,@TOvcHandOptionsSecondHandWidth_W,'SecondHandWidth');
    RegisterPropertyHelper(@TOvcHandOptionsShowSecondHand_R,@TOvcHandOptionsShowSecondHand_W,'ShowSecondHand');
    RegisterPropertyHelper(@TOvcHandOptionsSolidHands_R,@TOvcHandOptionsSolidHands_W,'SolidHands');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcDigitalOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcDigitalOptions) do begin
    RegisterConstructor(@TOvcDigitalOptions.Create, 'Create');
    RegisterPropertyHelper(@TOvcDigitalOptionsOnChange_R,@TOvcDigitalOptionsOnChange_W,'OnChange');
    RegisterPropertyHelper(@TOvcDigitalOptionsMilitaryTime_R,@TOvcDigitalOptionsMilitaryTime_W,'MilitaryTime');
    RegisterPropertyHelper(@TOvcDigitalOptionsOnColor_R,@TOvcDigitalOptionsOnColor_W,'OnColor');
    RegisterPropertyHelper(@TOvcDigitalOptionsOffColor_R,@TOvcDigitalOptionsOffColor_W,'OffColor');
    RegisterPropertyHelper(@TOvcDigitalOptionsBgColor_R,@TOvcDigitalOptionsBgColor_W,'BgColor');
    RegisterPropertyHelper(@TOvcDigitalOptionsSize_R,@TOvcDigitalOptionsSize_W,'Size');
    RegisterPropertyHelper(@TOvcDigitalOptionsShowSeconds_R,@TOvcDigitalOptionsShowSeconds_W,'ShowSeconds');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcLEDClockDisplay(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcLEDClockDisplay) do
  begin
    RegisterMethod(@TOvcLEDClockDisplay.PaintSelf, 'PaintSelf');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcclock(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcLEDClockDisplay(CL);
  RIRegister_TOvcDigitalOptions(CL);
  RIRegister_TOvcHandOptions(CL);
  RIRegister_TOvcCustomClock(CL);
  RIRegister_TOvcClock(CL);
end;

 
 
{ TPSImport_ovcclock }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcclock.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcclock(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcclock.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcclock(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
