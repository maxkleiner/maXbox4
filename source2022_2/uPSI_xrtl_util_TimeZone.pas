unit uPSI_xrtl_util_TimeZone;
{
   set free method
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
  TPSImport_xrtl_util_TimeZone = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXRTLTimeZones(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLTimeZone(CL: TPSPascalCompiler);
procedure SIRegister_xrtl_util_TimeZone(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_TimeZone_Routines(S: TPSExec);
procedure RIRegister_TXRTLTimeZones(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLTimeZone(CL: TPSRuntimeClassImporter);
procedure RIRegister_xrtl_util_TimeZone(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Contnrs
  ,Registry
  ,xrtl_util_TimeZone
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_TimeZone]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLTimeZones(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TXRTLTimeZones') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TXRTLTimeZones') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('Item', 'TXRTLTimeZone Integer', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Current', 'TXRTLTimeZone', iptr);
    RegisterMethod('Function IndexOf( Display : string) : Integer');
    RegisterMethod('Procedure Refresh');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLTimeZone(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TXRTLTimeZone') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TXRTLTimeZone') do begin
    RegisterProperty('Display', 'string', iptrw);
    RegisterProperty('Daylight', 'string', iptrw);
    RegisterProperty('Standard', 'string', iptrw);
    RegisterProperty('RTZI', 'REGTIMEZONEINFORMATION', iptrw);
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_TimeZone(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('REGTIMEZONEINFORMATION', 'record Bias : LongInt; StandardBias : '
   +'LongInt; DaylightBias : LongInt; StandardDate : SYSTEMTIME; DaylightDate :'
   +' SYSTEMTIME; end');
  SIRegister_TXRTLTimeZone(CL);
  SIRegister_TXRTLTimeZones(CL);
 CL.AddDelphiFunction('Function XRTLDateTimeToTimeZoneTime( DT : TDateTime; TimeZone : TXRTLTimeZone) : TDateTime');
 CL.AddDelphiFunction('Function XRTLGetTimeZones : TXRTLTimeZones');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXRTLTimeZonesCurrent_R(Self: TXRTLTimeZones; var T: TXRTLTimeZone);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeZonesCount_R(Self: TXRTLTimeZones; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeZonesItem_R(Self: TXRTLTimeZones; var T: TXRTLTimeZone; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeZoneRTZI_W(Self: TXRTLTimeZone; const T: REGTIMEZONEINFORMATION);
Begin Self.RTZI := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeZoneRTZI_R(Self: TXRTLTimeZone; var T: REGTIMEZONEINFORMATION);
Begin T := Self.RTZI; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeZoneStandard_W(Self: TXRTLTimeZone; const T: string);
Begin Self.Standard := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeZoneStandard_R(Self: TXRTLTimeZone; var T: string);
Begin T := Self.Standard; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeZoneDaylight_W(Self: TXRTLTimeZone; const T: string);
Begin Self.Daylight := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeZoneDaylight_R(Self: TXRTLTimeZone; var T: string);
Begin T := Self.Daylight; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeZoneDisplay_W(Self: TXRTLTimeZone; const T: string);
Begin Self.Display := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeZoneDisplay_R(Self: TXRTLTimeZone; var T: string);
Begin T := Self.Display; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_TimeZone_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLDateTimeToTimeZoneTime, 'XRTLDateTimeToTimeZoneTime', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetTimeZones, 'XRTLGetTimeZones', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLTimeZones(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLTimeZones) do begin
    RegisterConstructor(@TXRTLTimeZones.Create, 'Create');
    RegisterMethod(@TXRTLTimeZones.Destroy, 'Free');

    RegisterPropertyHelper(@TXRTLTimeZonesItem_R,nil,'Item');
    RegisterPropertyHelper(@TXRTLTimeZonesCount_R,nil,'Count');
    RegisterPropertyHelper(@TXRTLTimeZonesCurrent_R,nil,'Current');
    RegisterMethod(@TXRTLTimeZones.IndexOf, 'IndexOf');
    RegisterMethod(@TXRTLTimeZones.Refresh, 'Refresh');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLTimeZone(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLTimeZone) do
  begin
    RegisterPropertyHelper(@TXRTLTimeZoneDisplay_R,@TXRTLTimeZoneDisplay_W,'Display');
    RegisterPropertyHelper(@TXRTLTimeZoneDaylight_R,@TXRTLTimeZoneDaylight_W,'Daylight');
    RegisterPropertyHelper(@TXRTLTimeZoneStandard_R,@TXRTLTimeZoneStandard_W,'Standard');
    RegisterPropertyHelper(@TXRTLTimeZoneRTZI_R,@TXRTLTimeZoneRTZI_W,'RTZI');
    RegisterConstructor(@TXRTLTimeZone.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_TimeZone(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXRTLTimeZone(CL);
  RIRegister_TXRTLTimeZones(CL);
end;

 
 
{ TPSImport_xrtl_util_TimeZone }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_TimeZone.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_TimeZone(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_TimeZone.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_util_TimeZone(ri);
  RIRegister_xrtl_util_TimeZone_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
