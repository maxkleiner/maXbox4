unit uPSI_JvPickDate;
{
   only functions
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
  TPSImport_JvPickDate = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvPickDate(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvPickDate_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Variants
  ,Controls
  ,Graphics
  ,JvDateUtil
  ,JvPickDate
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvPickDate]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvPickDate(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function SelectDate( Sender : TWinControl; var Date : TDateTime; const DlgCaption : TCaption; AStartOfWeek : TDayOfWeekName; AWeekends : TDaysOfWeek; AWeekendColor : TColor; BtnHints : TStrings; MinDate : TDateTime; MaxDate : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function SelectDateStr( Sender : TWinControl; var StrDate : string; const DlgCaption : TCaption; AStartOfWeek : TDayOfWeekName; AWeekends : TDaysOfWeek; AWeekendColor : TColor; BtnHints : TStrings; MinDate : TDateTime; MaxDate : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function PopupDate( var Date : TDateTime; Edit : TWinControl; MinDate : TDateTime; MaxDate : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function CreatePopupCalendar( AOwner : TComponent; ABiDiMode : TBiDiMode; MinDate : TDateTime; MaxDate : TDateTime) : TWinControl');
 CL.AddDelphiFunction('Procedure SetupPopupCalendar( PopupCalendar : TWinControl; AStartOfWeek : TDayOfWeekName; AWeekends : TDaysOfWeek; AWeekendColor : TColor; BtnHints : TStrings; FourDigitYear : Boolean; MinDate : TDateTime; MaxDate : TDateTime)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvPickDate_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SelectDate, 'SelectDate', cdRegister);
 S.RegisterDelphiFunction(@SelectDateStr, 'SelectDateStr', cdRegister);
 S.RegisterDelphiFunction(@PopupDate, 'PopupDate', cdRegister);
 S.RegisterDelphiFunction(@CreatePopupCalendar, 'CreatePopupCalendar', cdRegister);
 S.RegisterDelphiFunction(@SetupPopupCalendar, 'SetupPopupCalendar', cdRegister);
end;

 
 
{ TPSImport_JvPickDate }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPickDate.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvPickDate(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPickDate.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvPickDate(ri);
  RIRegister_JvPickDate_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
