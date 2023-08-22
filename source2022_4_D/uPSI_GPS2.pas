unit uPSI_GPS2;
{
    calculus without form
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
  TPSImport_GPS2 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGPS2(CL: TPSPascalCompiler);
procedure SIRegister_GPS2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GPS2_Routines(S: TPSExec);
procedure RIRegister_TGPS2(CL: TPSRuntimeClassImporter);
procedure RIRegister_GPS2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ExtCtrls
  ,AdPort
  ,NavUtils
  ,NMEA
  ,GPS2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GPS2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGPS2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TGPS2') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TGPS2') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Function Accepted( const sNmea : string) : Boolean');
    RegisterMethod('Procedure SendStr( const S : string)');
    RegisterMethod('Function SetSysClock : Boolean');
    RegisterMethod('Function FixSatSet : TPrnSet');
    RegisterMethod('Procedure GDOP( out HDOP, VDOP, PDOP : Double)');
    RegisterProperty('NmeaSentence', 'string', iptr);
    RegisterProperty('UTCTime', 'TDateTime', iptr);
    RegisterProperty('LatAsStr', 'string', iptr);
    RegisterProperty('LonAsStr', 'string', iptr);
    RegisterProperty('HasMagVar', 'Boolean', iptr);
    RegisterProperty('MagVar', 'Double', iptr);
    RegisterProperty('Altitude', 'Double', iptr);
    RegisterProperty('AltUnits', 'Char', iptr);
    RegisterProperty('HasGeoidDelta', 'Boolean', iptr);
    RegisterProperty('GeoidDelta', 'Double', iptr);
    RegisterProperty('DeltaUnits', 'Char', iptr);
    RegisterProperty('IsDGPS', 'Boolean', iptr);
    RegisterProperty('AgeDGPS', 'Double', iptr);
    RegisterProperty('StnDGPS', 'string', iptr);
    RegisterProperty('FixMode', 'string', iptr);
    RegisterProperty('FixSatCount', 'Integer', iptr);
    RegisterProperty('ComBaud', 'Integer', iptrw);
    RegisterProperty('ComNumber', 'Word', iptrw);
    RegisterProperty('ComOpen', 'Boolean', iptrw);
    RegisterProperty('ComTimeOut', 'Integer', iptrw);
    RegisterProperty('Units', 'tGPSUnits', iptrw);
    RegisterProperty('StrFormat', 'tStrFormat', iptrw);
    RegisterProperty('PosUnits', 'tFloatUnits', iptrw);
    RegisterProperty('FixLossAlarm', 'Boolean', iptrw);
    RegisterProperty('ErrorBeep', 'Boolean', iptrw);
    RegisterProperty('Version', 'string', iptrw);
    RegisterProperty('OnSentence', 'TRecEvent', iptrw);
    RegisterProperty('OnValidFix', 'TFixEvent', iptrw);
    RegisterProperty('OnFixLoss', 'TNotifyEvent', iptrw);
    RegisterProperty('OnFixProgress', 'TProgEvent', iptrw);
    RegisterProperty('OnFixQuality', 'TQalEvent', iptrw);
    RegisterProperty('OnError', 'TErrEvent', iptrw);
    RegisterProperty('OnComLoss', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GPS2(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TPrnSets', 'Integer');
  CL.AddTypeS('TPrnSet', 'set of byte');
  CL.AddTypeS('TGPSUnits', '( Nautical, Statute, Metric )');
  CL.AddTypeS('TStrFormat', '( DDMMSS, DDMMmm, DDddd )');
  CL.AddTypeS('TFloatUnits', '( aaDeg, aaMin, aaSec, aaRad )');
  CL.AddTypeS('TgpsDataArray', 'array [0..20] of string;');
  // TDataArray = array [0..20] of string;
  CL.AddTypeS('TRecEvent', 'Procedure ( Sender : TObject; SenID : string; A : TGPSDataArray)');
  CL.AddTypeS('TFixEvent', 'Procedure ( Sender : TObject; Lat, Lon, SOG, COG : Double)');
  CL.AddTypeS('TProgEvent', 'Procedure ( Sender : TObject; Progress : string; FixD : Integer)');
  CL.AddTypeS('TQalEvent', 'Procedure ( Sender : TObject; Quality : string; FixQ : Integer)');
  CL.AddTypeS('TErrEvent', 'Procedure ( Sender : TObject; ErrMsg : string)');
  SIRegister_TGPS2(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TGPS2OnComLoss_W(Self: TGPS2; const T: TNotifyEvent);
begin Self.OnComLoss := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnComLoss_R(Self: TGPS2; var T: TNotifyEvent);
begin T := Self.OnComLoss; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnError_W(Self: TGPS2; const T: TErrEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnError_R(Self: TGPS2; var T: TErrEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnFixQuality_W(Self: TGPS2; const T: TQalEvent);
begin Self.OnFixQuality := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnFixQuality_R(Self: TGPS2; var T: TQalEvent);
begin T := Self.OnFixQuality; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnFixProgress_W(Self: TGPS2; const T: TProgEvent);
begin Self.OnFixProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnFixProgress_R(Self: TGPS2; var T: TProgEvent);
begin T := Self.OnFixProgress; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnFixLoss_W(Self: TGPS2; const T: TNotifyEvent);
begin Self.OnFixLoss := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnFixLoss_R(Self: TGPS2; var T: TNotifyEvent);
begin T := Self.OnFixLoss; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnValidFix_W(Self: TGPS2; const T: TFixEvent);
begin Self.OnValidFix := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnValidFix_R(Self: TGPS2; var T: TFixEvent);
begin T := Self.OnValidFix; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnSentence_W(Self: TGPS2; const T: TRecEvent);
begin Self.OnSentence := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2OnSentence_R(Self: TGPS2; var T: TRecEvent);
begin T := Self.OnSentence; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2Version_W(Self: TGPS2; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2Version_R(Self: TGPS2; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2ErrorBeep_W(Self: TGPS2; const T: Boolean);
begin Self.ErrorBeep := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2ErrorBeep_R(Self: TGPS2; var T: Boolean);
begin T := Self.ErrorBeep; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2FixLossAlarm_W(Self: TGPS2; const T: Boolean);
begin Self.FixLossAlarm := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2FixLossAlarm_R(Self: TGPS2; var T: Boolean);
begin T := Self.FixLossAlarm; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2PosUnits_W(Self: TGPS2; const T: tFloatUnits);
begin Self.PosUnits := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2PosUnits_R(Self: TGPS2; var T: tFloatUnits);
begin T := Self.PosUnits; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2StrFormat_W(Self: TGPS2; const T: tStrFormat);
begin Self.StrFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2StrFormat_R(Self: TGPS2; var T: tStrFormat);
begin T := Self.StrFormat; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2Units_W(Self: TGPS2; const T: tUnits);
begin Self.Units := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2Units_R(Self: TGPS2; var T: tUnits);
begin T := Self.Units; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2ComTimeOut_W(Self: TGPS2; const T: Integer);
begin Self.ComTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2ComTimeOut_R(Self: TGPS2; var T: Integer);
begin T := Self.ComTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2ComOpen_W(Self: TGPS2; const T: Boolean);
begin Self.ComOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2ComOpen_R(Self: TGPS2; var T: Boolean);
begin T := Self.ComOpen; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2ComNumber_W(Self: TGPS2; const T: Word);
begin Self.ComNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2ComNumber_R(Self: TGPS2; var T: Word);
begin T := Self.ComNumber; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2ComBaud_W(Self: TGPS2; const T: Integer);
begin Self.ComBaud := T; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2ComBaud_R(Self: TGPS2; var T: Integer);
begin T := Self.ComBaud; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2FixSatCount_R(Self: TGPS2; var T: Integer);
begin T := Self.FixSatCount; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2FixMode_R(Self: TGPS2; var T: string);
begin T := Self.FixMode; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2StnDGPS_R(Self: TGPS2; var T: string);
begin T := Self.StnDGPS; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2AgeDGPS_R(Self: TGPS2; var T: Double);
begin T := Self.AgeDGPS; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2IsDGPS_R(Self: TGPS2; var T: Boolean);
begin T := Self.IsDGPS; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2DeltaUnits_R(Self: TGPS2; var T: Char);
begin T := Self.DeltaUnits; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2GeoidDelta_R(Self: TGPS2; var T: Double);
begin T := Self.GeoidDelta; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2HasGeoidDelta_R(Self: TGPS2; var T: Boolean);
begin T := Self.HasGeoidDelta; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2AltUnits_R(Self: TGPS2; var T: Char);
begin T := Self.AltUnits; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2Altitude_R(Self: TGPS2; var T: Double);
begin T := Self.Altitude; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2MagVar_R(Self: TGPS2; var T: Double);
begin T := Self.MagVar; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2HasMagVar_R(Self: TGPS2; var T: Boolean);
begin T := Self.HasMagVar; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2LonAsStr_R(Self: TGPS2; var T: string);
begin T := Self.LonAsStr; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2LatAsStr_R(Self: TGPS2; var T: string);
begin T := Self.LatAsStr; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2UTCTime_R(Self: TGPS2; var T: TDateTime);
begin T := Self.UTCTime; end;

(*----------------------------------------------------------------------------*)
procedure TGPS2NmeaSentence_R(Self: TGPS2; var T: string);
begin T := Self.NmeaSentence; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GPS2_Routines(S: TPSExec);
begin
// S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGPS2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGPS2) do begin
    RegisterConstructor(@TGPS2.Create, 'Create');
     RegisterMethod(@TGPS2.Destroy, 'Free');
     RegisterMethod(@TGPS2.Accepted, 'Accepted');
    RegisterMethod(@TGPS2.SendStr, 'SendStr');
    RegisterMethod(@TGPS2.SetSysClock, 'SetSysClock');
    RegisterMethod(@TGPS2.FixSatSet, 'FixSatSet');
    RegisterMethod(@TGPS2.GDOP, 'GDOP');
    RegisterPropertyHelper(@TGPS2NmeaSentence_R,nil,'NmeaSentence');
    RegisterPropertyHelper(@TGPS2UTCTime_R,nil,'UTCTime');
    RegisterPropertyHelper(@TGPS2LatAsStr_R,nil,'LatAsStr');
    RegisterPropertyHelper(@TGPS2LonAsStr_R,nil,'LonAsStr');
    RegisterPropertyHelper(@TGPS2HasMagVar_R,nil,'HasMagVar');
    RegisterPropertyHelper(@TGPS2MagVar_R,nil,'MagVar');
    RegisterPropertyHelper(@TGPS2Altitude_R,nil,'Altitude');
    RegisterPropertyHelper(@TGPS2AltUnits_R,nil,'AltUnits');
    RegisterPropertyHelper(@TGPS2HasGeoidDelta_R,nil,'HasGeoidDelta');
    RegisterPropertyHelper(@TGPS2GeoidDelta_R,nil,'GeoidDelta');
    RegisterPropertyHelper(@TGPS2DeltaUnits_R,nil,'DeltaUnits');
    RegisterPropertyHelper(@TGPS2IsDGPS_R,nil,'IsDGPS');
    RegisterPropertyHelper(@TGPS2AgeDGPS_R,nil,'AgeDGPS');
    RegisterPropertyHelper(@TGPS2StnDGPS_R,nil,'StnDGPS');
    RegisterPropertyHelper(@TGPS2FixMode_R,nil,'FixMode');
    RegisterPropertyHelper(@TGPS2FixSatCount_R,nil,'FixSatCount');
    RegisterPropertyHelper(@TGPS2ComBaud_R,@TGPS2ComBaud_W,'ComBaud');
    RegisterPropertyHelper(@TGPS2ComNumber_R,@TGPS2ComNumber_W,'ComNumber');
    RegisterPropertyHelper(@TGPS2ComOpen_R,@TGPS2ComOpen_W,'ComOpen');
    RegisterPropertyHelper(@TGPS2ComTimeOut_R,@TGPS2ComTimeOut_W,'ComTimeOut');
    RegisterPropertyHelper(@TGPS2Units_R,@TGPS2Units_W,'Units');
    RegisterPropertyHelper(@TGPS2StrFormat_R,@TGPS2StrFormat_W,'StrFormat');
    RegisterPropertyHelper(@TGPS2PosUnits_R,@TGPS2PosUnits_W,'PosUnits');
    RegisterPropertyHelper(@TGPS2FixLossAlarm_R,@TGPS2FixLossAlarm_W,'FixLossAlarm');
    RegisterPropertyHelper(@TGPS2ErrorBeep_R,@TGPS2ErrorBeep_W,'ErrorBeep');
    RegisterPropertyHelper(@TGPS2Version_R,@TGPS2Version_W,'Version');
    RegisterPropertyHelper(@TGPS2OnSentence_R,@TGPS2OnSentence_W,'OnSentence');
    RegisterPropertyHelper(@TGPS2OnValidFix_R,@TGPS2OnValidFix_W,'OnValidFix');
    RegisterPropertyHelper(@TGPS2OnFixLoss_R,@TGPS2OnFixLoss_W,'OnFixLoss');
    RegisterPropertyHelper(@TGPS2OnFixProgress_R,@TGPS2OnFixProgress_W,'OnFixProgress');
    RegisterPropertyHelper(@TGPS2OnFixQuality_R,@TGPS2OnFixQuality_W,'OnFixQuality');
    RegisterPropertyHelper(@TGPS2OnError_R,@TGPS2OnError_W,'OnError');
    RegisterPropertyHelper(@TGPS2OnComLoss_R,@TGPS2OnComLoss_W,'OnComLoss');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GPS2(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TGPS2(CL);
end;

 
 
{ TPSImport_GPS2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GPS2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GPS2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GPS2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GPS2(ri);
  //RIRegister_GPS2_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
