unit uPSI_JclTimeZones;
{
time to get real UTC

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
  TPSImport_JclTimeZones = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclTimeZones(CL: TPSPascalCompiler);
procedure SIRegister_TJclTimeZoneInfo(CL: TPSPascalCompiler);
procedure SIRegister_JclTimeZones(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclTimeZones_Routines(S: TPSExec);
procedure RIRegister_TJclTimeZones(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclTimeZoneInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclTimeZones(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  //(( JclUnitVersioning
  Windows
  ,Contnrs
  ,JclBase
  ,JclTimeZones
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclTimeZones]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclTimeZones(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclTimeZones') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclTimeZones') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function SetDateTime( DateTime : TDateTime) : Boolean');
    RegisterMethod('Procedure SetAutoAdjustEnabled( Value : Boolean)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'TJclTimeZoneInfo Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('ActiveTimeZone', 'TJclTimeZoneInfo', iptr);
    RegisterProperty('AutoAdjustEnabled', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclTimeZoneInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclTimeZoneInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclTimeZoneInfo') do
  begin
    RegisterMethod('Procedure Assign( Source : TJclTimeZoneRegInfo)');
    RegisterMethod('Procedure ApplyTimeZone');
    RegisterMethod('Function DayLightSavingsPeriod : string');
    RegisterMethod('Function DateTimeIsInDaylightSavings( ADateTime : TDateTime) : Boolean');
    RegisterMethod('Function StandardStartDateInYear( const AYear : Integer) : TDateTime');
    RegisterMethod('Function DaylightStartDateInYear( const AYear : Integer) : TDateTime');
    RegisterProperty('ActiveBias', 'Integer', iptr);
    RegisterProperty('CurrentDateTime', 'TDateTime', iptr);
    RegisterProperty('DaylightName', 'string', iptr);
    RegisterProperty('DaylightSavingsStartDate', 'TDateTime', iptr);
    RegisterProperty('DisplayDescription', 'string', iptr);
    RegisterProperty('GMTOffset', 'string', iptr);
    RegisterProperty('MapID', 'string', iptr);
    RegisterProperty('SortIndex', 'Integer', iptr);
    RegisterProperty('StandardName', 'string', iptr);
    RegisterProperty('StandardStartDate', 'TDateTime', iptr);
    RegisterProperty('SupportsDaylightSavings', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclTimeZones(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJclTZIValueInfo', 'record Bias : Longint; StandardBias : Intege'
   +'r; DaylightBias : Integer; StandardDate : TSystemTime; DaylightDate : TSystemTime; end');
  //CL.AddTypeS('PJclTimeZoneRegInfo', '^TJclTimeZoneRegInfo // will not work');
  CL.AddTypeS('TJclTimeZoneRegInfo', 'record DisplayDesc : string; StandardName'
   +' : string; DaylightName : string; SortIndex : Integer; MapID : string; TZI: TJclTZIValueInfo; end');
  CL.AddTypeS('TJclTimeZoneCallBackFunc', 'Function ( const TimeZoneRec : TJclTimeZoneRegInfo) : Boolean');
  SIRegister_TJclTimeZoneInfo(CL);
  SIRegister_TJclTimeZones(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EDaylightSavingsNotSupported');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAutoAdjustNotEnabled');
 CL.AddDelphiFunction('Function EnumTimeZones( CallBackFunc : TJclTimeZoneCallBackFunc) : Boolean');
 CL.AddDelphiFunction('Function IsAutoAdjustEnabled : Boolean');
 CL.AddDelphiFunction('Function CurrentTimeZoneSupportsDaylightSavings : Boolean');
 CL.AddDelphiFunction('Function DateCurrentTimeZoneClocksChangeToStandard : TDateTime');
 CL.AddDelphiFunction('Function DateCurrentTimeZoneClocksChangeToDaylightSavings : TDateTime');
 CL.AddDelphiFunction('Function GetCurrentTimeZoneDescription : string');
 CL.AddDelphiFunction('Function GetCurrentTimeZoneDaylightSavingsPeriod : string');
 CL.AddDelphiFunction('Function GetCurrentTimeZoneGMTOffset : string');
 CL.AddDelphiFunction('Function GetCurrentTimeZoneUTCBias : Integer');
 CL.AddDelphiFunction('Function GetWMIScheduledJobUTCTime( Time : TDateTime) : string');
 CL.AddDelphiFunction('Function UTCNow : TDateTime');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclTimeZonesAutoAdjustEnabled_W(Self: TJclTimeZones; const T: Boolean);
begin Self.AutoAdjustEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZonesAutoAdjustEnabled_R(Self: TJclTimeZones; var T: Boolean);
begin T := Self.AutoAdjustEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZonesActiveTimeZone_R(Self: TJclTimeZones; var T: TJclTimeZoneInfo);
begin T := Self.ActiveTimeZone; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZonesItems_R(Self: TJclTimeZones; var T: TJclTimeZoneInfo; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZonesCount_R(Self: TJclTimeZones; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZoneInfoSupportsDaylightSavings_R(Self: TJclTimeZoneInfo; var T: Boolean);
begin T := Self.SupportsDaylightSavings; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZoneInfoStandardStartDate_R(Self: TJclTimeZoneInfo; var T: TDateTime);
begin T := Self.StandardStartDate; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZoneInfoStandardName_R(Self: TJclTimeZoneInfo; var T: string);
begin T := Self.StandardName; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZoneInfoSortIndex_R(Self: TJclTimeZoneInfo; var T: Integer);
begin T := Self.SortIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZoneInfoMapID_R(Self: TJclTimeZoneInfo; var T: string);
begin T := Self.MapID; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZoneInfoGMTOffset_R(Self: TJclTimeZoneInfo; var T: string);
begin T := Self.GMTOffset; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZoneInfoDisplayDescription_R(Self: TJclTimeZoneInfo; var T: string);
begin T := Self.DisplayDescription; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZoneInfoDaylightSavingsStartDate_R(Self: TJclTimeZoneInfo; var T: TDateTime);
begin T := Self.DaylightSavingsStartDate; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZoneInfoDaylightName_R(Self: TJclTimeZoneInfo; var T: string);
begin T := Self.DaylightName; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZoneInfoCurrentDateTime_R(Self: TJclTimeZoneInfo; var T: TDateTime);
begin T := Self.CurrentDateTime; end;

(*----------------------------------------------------------------------------*)
procedure TJclTimeZoneInfoActiveBias_R(Self: TJclTimeZoneInfo; var T: Integer);
begin T := Self.ActiveBias; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclTimeZones_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EnumTimeZones, 'EnumTimeZones', cdRegister);
 S.RegisterDelphiFunction(@IsAutoAdjustEnabled, 'IsAutoAdjustEnabled', cdRegister);
 S.RegisterDelphiFunction(@CurrentTimeZoneSupportsDaylightSavings, 'CurrentTimeZoneSupportsDaylightSavings', cdRegister);
 S.RegisterDelphiFunction(@DateCurrentTimeZoneClocksChangeToStandard, 'DateCurrentTimeZoneClocksChangeToStandard', cdRegister);
 S.RegisterDelphiFunction(@DateCurrentTimeZoneClocksChangeToDaylightSavings, 'DateCurrentTimeZoneClocksChangeToDaylightSavings', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentTimeZoneDescription, 'GetCurrentTimeZoneDescription', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentTimeZoneDaylightSavingsPeriod, 'GetCurrentTimeZoneDaylightSavingsPeriod', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentTimeZoneGMTOffset, 'GetCurrentTimeZoneGMTOffset', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentTimeZoneUTCBias, 'GetCurrentTimeZoneUTCBias', cdRegister);
 S.RegisterDelphiFunction(@GetWMIScheduledJobUTCTime, 'GetWMIScheduledJobUTCTime', cdRegister);
 S.RegisterDelphiFunction(@UTCNow, 'UTCNow', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclTimeZones(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclTimeZones) do begin
    RegisterConstructor(@TJclTimeZones.Create, 'Create');
    RegisterMethod(@TJclTimeZones.Destroy, 'Free');
    RegisterMethod(@TJclTimeZones.SetDateTime, 'SetDateTime');
    RegisterMethod(@TJclTimeZones.SetAutoAdjustEnabled, 'SetAutoAdjustEnabled');
    RegisterPropertyHelper(@TJclTimeZonesCount_R,nil,'Count');
    RegisterPropertyHelper(@TJclTimeZonesItems_R,nil,'Items');
    RegisterPropertyHelper(@TJclTimeZonesActiveTimeZone_R,nil,'ActiveTimeZone');
    RegisterPropertyHelper(@TJclTimeZonesAutoAdjustEnabled_R,@TJclTimeZonesAutoAdjustEnabled_W,'AutoAdjustEnabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclTimeZoneInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclTimeZoneInfo) do
  begin
    RegisterMethod(@TJclTimeZoneInfo.Assign, 'Assign');
    RegisterMethod(@TJclTimeZoneInfo.ApplyTimeZone, 'ApplyTimeZone');
    RegisterMethod(@TJclTimeZoneInfo.DayLightSavingsPeriod, 'DayLightSavingsPeriod');
    RegisterMethod(@TJclTimeZoneInfo.DateTimeIsInDaylightSavings, 'DateTimeIsInDaylightSavings');
    RegisterMethod(@TJclTimeZoneInfo.StandardStartDateInYear, 'StandardStartDateInYear');
    RegisterMethod(@TJclTimeZoneInfo.DaylightStartDateInYear, 'DaylightStartDateInYear');
    RegisterPropertyHelper(@TJclTimeZoneInfoActiveBias_R,nil,'ActiveBias');
    RegisterPropertyHelper(@TJclTimeZoneInfoCurrentDateTime_R,nil,'CurrentDateTime');
    RegisterPropertyHelper(@TJclTimeZoneInfoDaylightName_R,nil,'DaylightName');
    RegisterPropertyHelper(@TJclTimeZoneInfoDaylightSavingsStartDate_R,nil,'DaylightSavingsStartDate');
    RegisterPropertyHelper(@TJclTimeZoneInfoDisplayDescription_R,nil,'DisplayDescription');
    RegisterPropertyHelper(@TJclTimeZoneInfoGMTOffset_R,nil,'GMTOffset');
    RegisterPropertyHelper(@TJclTimeZoneInfoMapID_R,nil,'MapID');
    RegisterPropertyHelper(@TJclTimeZoneInfoSortIndex_R,nil,'SortIndex');
    RegisterPropertyHelper(@TJclTimeZoneInfoStandardName_R,nil,'StandardName');
    RegisterPropertyHelper(@TJclTimeZoneInfoStandardStartDate_R,nil,'StandardStartDate');
    RegisterPropertyHelper(@TJclTimeZoneInfoSupportsDaylightSavings_R,nil,'SupportsDaylightSavings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclTimeZones(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJclTimeZoneInfo(CL);
  RIRegister_TJclTimeZones(CL);
  with CL.Add(EDaylightSavingsNotSupported) do
  with CL.Add(EAutoAdjustNotEnabled) do
end;

 
 
{ TPSImport_JclTimeZones }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclTimeZones.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclTimeZones(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclTimeZones.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclTimeZones(ri);
  RIRegister_JclTimeZones_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
