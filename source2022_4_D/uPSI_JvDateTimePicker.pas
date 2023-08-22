unit uPSI_JvDateTimePicker;
{
   for UML Tutor
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
  TPSImport_JvDateTimePicker = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDateTimePicker(CL: TPSPascalCompiler);
procedure SIRegister_JvDateTimePicker(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvDateTimePicker(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDateTimePicker(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Messages
  ,Controls
  ,ComCtrls
  //,JvExComCtrls
  ,JvDateTimePicker
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDateTimePicker]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDateTimePicker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvExDateTimePicker', 'TJvDateTimePicker') do
  //with CL.AddClassN(CL.FindClass('TJvExDateTimePicker'),'TJvDateTimePicker') do begin
  with CL.AddClassN(CL.FindClass('TDateTimePicker'),'TJvDateTimePicker') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('DropDownDate', 'TDate', iptrw);
    RegisterProperty('NullDate', 'TDateTime', iptrw);
    RegisterProperty('NullText', 'string', iptrw);
    RegisterProperty('WeekNumbers', 'Boolean', iptrw);
    RegisterProperty('ShowToday', 'Boolean', iptrw);
    RegisterProperty('ShowTodayCircle', 'Boolean', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     RegisterProperty('ParentColor', 'TColor', iptrw);
    RegisterProperty('BevelWidth','TBevelWidth',iptrw);
    //RegisterProperty('Parent','TWinControl',iptrw);
    // property Parent: TWinControl read FParent write SetParent;
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
    //  RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDateTimePicker(CL: TPSPascalCompiler);
begin
  SIRegister_TJvDateTimePicker(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerShowTodayCircle_W(Self: TJvDateTimePicker; const T: Boolean);
begin Self.ShowTodayCircle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerShowTodayCircle_R(Self: TJvDateTimePicker; var T: Boolean);
begin T := Self.ShowTodayCircle; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerShowToday_W(Self: TJvDateTimePicker; const T: Boolean);
begin Self.ShowToday := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerShowToday_R(Self: TJvDateTimePicker; var T: Boolean);
begin T := Self.ShowToday; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerWeekNumbers_W(Self: TJvDateTimePicker; const T: Boolean);
begin Self.WeekNumbers := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerWeekNumbers_R(Self: TJvDateTimePicker; var T: Boolean);
begin T := Self.WeekNumbers; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerNullText_W(Self: TJvDateTimePicker; const T: string);
begin Self.NullText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerNullText_R(Self: TJvDateTimePicker; var T: string);
begin T := Self.NullText; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerNullDate_W(Self: TJvDateTimePicker; const T: TDateTime);
begin Self.NullDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerNullDate_R(Self: TJvDateTimePicker; var T: TDateTime);
begin T := Self.NullDate; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerDropDownDate_W(Self: TJvDateTimePicker; const T: TDate);
begin Self.DropDownDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDateTimePickerDropDownDate_R(Self: TJvDateTimePicker; var T: TDate);
begin T := Self.DropDownDate; end;

(*----------------------------------------------------------------------------*)
Function TJvDateTimePickerCheckNullValue1_P(Self: TJvDateTimePicker;  const ANullText, AFormat : string; AKind : TDateTimeKind; ADateTime, ANullDate : TDateTime) : Boolean;
Begin //Result := Self.CheckNullValue(ANullText, AFormat, AKind, ADateTime, ANullDate);
END;

(*----------------------------------------------------------------------------*)
Function TJvDateTimePickerCheckNullValue_P(Self: TJvDateTimePicker) : Boolean;
Begin //Result := Self.CheckNullValue;
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDateTimePicker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDateTimePicker) do begin
    RegisterConstructor(@TJvDateTimePicker.Create, 'Create');
      RegisterMethod(@TJvDateTimePicker.Destroy, 'Free');
      RegisterPropertyHelper(@TJvDateTimePickerDropDownDate_R,@TJvDateTimePickerDropDownDate_W,'DropDownDate');
    RegisterPropertyHelper(@TJvDateTimePickerNullDate_R,@TJvDateTimePickerNullDate_W,'NullDate');
    RegisterPropertyHelper(@TJvDateTimePickerNullText_R,@TJvDateTimePickerNullText_W,'NullText');
    RegisterPropertyHelper(@TJvDateTimePickerWeekNumbers_R,@TJvDateTimePickerWeekNumbers_W,'WeekNumbers');
    RegisterPropertyHelper(@TJvDateTimePickerShowToday_R,@TJvDateTimePickerShowToday_W,'ShowToday');
    RegisterPropertyHelper(@TJvDateTimePickerShowTodayCircle_R,@TJvDateTimePickerShowTodayCircle_W,'ShowTodayCircle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDateTimePicker(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDateTimePicker(CL);
end;

 
 
{ TPSImport_JvDateTimePicker }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDateTimePicker.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDateTimePicker(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDateTimePicker.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDateTimePicker(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
