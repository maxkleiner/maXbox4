unit uPSI_Calendar;
{
   a calendar f own of samples
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
  TPSImport_Calendar = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCalendar2(CL: TPSPascalCompiler);
procedure SIRegister_Calendar(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCalendar2(CL: TPSRuntimeClassImporter);
procedure RIRegister_Calendar(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,Messages
  ,Windows
  ,Forms
  ,Graphics
  ,StdCtrls
  ,Grids
  ,Calendar
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Calendar]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCalendar2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomGrid', 'TCalendar2') do
  with CL.AddClassN(CL.FindClass('TCustomGrid'),'TCalendar2') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('CalendarDate', 'TDateTime', iptrw);
    RegisterProperty('CellText', 'string Integer Integer', iptr);
    RegisterMethod('Procedure NextMonth');
    RegisterMethod('Procedure NextYear');
    RegisterMethod('Procedure PrevMonth');
    RegisterMethod('Procedure PrevYear');
    RegisterMethod('Procedure UpdateCalendar');
    RegisterProperty('Day', 'Integer', iptrw);
    RegisterProperty('Month', 'Integer', iptrw);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
    RegisterProperty('StartOfWeek', 'TDayOfWeek', iptrw);
    RegisterProperty('UseCurrentDate', 'Boolean', iptrw);
    RegisterProperty('Year', 'Integer', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Calendar(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TDayOfWeek', 'Integer');
  SIRegister_TCalendar2(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCalendar2OnChange_W(Self: TCalendar2; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2OnChange_R(Self: TCalendar2; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2Year_W(Self: TCalendar2; const T: Integer);
begin Self.Year := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2Year_R(Self: TCalendar2; var T: Integer);
begin T := Self.Year; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2UseCurrentDate_W(Self: TCalendar2; const T: Boolean);
begin Self.UseCurrentDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2UseCurrentDate_R(Self: TCalendar2; var T: Boolean);
begin T := Self.UseCurrentDate; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2StartOfWeek_W(Self: TCalendar2; const T: TDayOfWeek);
begin Self.StartOfWeek := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2StartOfWeek_R(Self: TCalendar2; var T: TDayOfWeek);
begin T := Self.StartOfWeek; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2ReadOnly_W(Self: TCalendar2; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2ReadOnly_R(Self: TCalendar2; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2Month_W(Self: TCalendar2; const T: Integer);
begin Self.Month := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2Month_R(Self: TCalendar2; var T: Integer);
begin T := Self.Month; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2Day_W(Self: TCalendar2; const T: Integer);
begin Self.Day := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2Day_R(Self: TCalendar2; var T: Integer);
begin T := Self.Day; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2CellText_R(Self: TCalendar2; var T: string; const t1: Integer; const t2: Integer);
begin T := Self.CellText[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2CalendarDate_W(Self: TCalendar2; const T: TDateTime);
begin Self.CalendarDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalendar2CalendarDate_R(Self: TCalendar2; var T: TDateTime);
begin T := Self.CalendarDate; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCalendar2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCalendar2) do
  begin
    RegisterConstructor(@TCalendar2.Create, 'Create');
    RegisterPropertyHelper(@TCalendar2CalendarDate_R,@TCalendar2CalendarDate_W,'CalendarDate');
    RegisterPropertyHelper(@TCalendar2CellText_R,nil,'CellText');
    RegisterMethod(@TCalendar2.NextMonth, 'NextMonth');
    RegisterMethod(@TCalendar2.NextYear, 'NextYear');
    RegisterMethod(@TCalendar2.PrevMonth, 'PrevMonth');
    RegisterMethod(@TCalendar2.PrevYear, 'PrevYear');
    RegisterVirtualMethod(@TCalendar2.UpdateCalendar, 'UpdateCalendar');
    RegisterPropertyHelper(@TCalendar2Day_R,@TCalendar2Day_W,'Day');
    RegisterPropertyHelper(@TCalendar2Month_R,@TCalendar2Month_W,'Month');
    RegisterPropertyHelper(@TCalendar2ReadOnly_R,@TCalendar2ReadOnly_W,'ReadOnly');
    RegisterPropertyHelper(@TCalendar2StartOfWeek_R,@TCalendar2StartOfWeek_W,'StartOfWeek');
    RegisterPropertyHelper(@TCalendar2UseCurrentDate_R,@TCalendar2UseCurrentDate_W,'UseCurrentDate');
    RegisterPropertyHelper(@TCalendar2Year_R,@TCalendar2Year_W,'Year');
    RegisterPropertyHelper(@TCalendar2OnChange_R,@TCalendar2OnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Calendar(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCalendar2(CL);
end;

 
 
{ TPSImport_Calendar }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Calendar.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Calendar(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Calendar.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Calendar(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
