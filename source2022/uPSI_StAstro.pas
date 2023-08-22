unit uPSI_StAstro;
{
  and ASTROP
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
  TPSImport_StAstro = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StAstro(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StAstro_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,StConst
  ,StBase
  ,StDate
  ,StStrS
  ,StDateSt
  ,StMath
  ,StAstro
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StAstro]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StAstro(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStTwilight', '( ttCivil, ttNautical, ttAstronomical )');
  CL.AddTypeS('TStRiseSetRec', 'record ORise : TStTime; OSet : TStTime; end');
  CL.AddTypeS('TStPosRec', 'record RA : Double; RC : Double; end');
  CL.AddTypeS('TStLunarRecord', 'record T: array[0..1] of TStDateTimeRec; end');
  //CL.AddTypeS('TStLunarRecord', 'T: TStDateTimeRec; end');

  CL.AddTypeS('TStSunXYZRec', 'record SunX : double; SunY : double; SunZ : doub'
   +'le; RV : double; SLong : double; SLat : Double; end');
  CL.AddTypeS('TStPhaseRecord', 'record NMDate : double; FQDate : double; FMDat'
   +'e : double; LQDate : Double; end');
  CL.AddTypeS('TStDLSDateRec', 'record Starts : TStDate; Ends : TStDate; end');
  CL.AddTypeS('TStMoonPosRec', 'record RA : double; DC : double; Phase : double'
   +'; Dia : double; Plx : double; Elong : Double; end');
 CL.AddConstantN('radcor','Extended').setExtended( 57.29577951308232);
 CL.AddConstantN('StdDate','Extended').setExtended( 2451545.0);
 CL.AddConstantN('OB2000','Extended').setExtended( 0.409092804);
 CL.AddDelphiFunction('Function AmountOfSunlight( LD : TStDate; Longitude, Latitude : Double) : TStTime');
 CL.AddDelphiFunction('Function FixedRiseSet( LD : TStDate; RA, DC, Longitude, Latitude : Double) : TStRiseSetRec');
 CL.AddDelphiFunction('Function SunPos( UT : TStDateTimeRec) : TStPosRec');
 CL.AddDelphiFunction('Function SunPosPrim( UT : TStDateTimeRec) : TStSunXYZRec');
 CL.AddDelphiFunction('Function SunRiseSet( LD : TStDate; Longitude, Latitude : Double) : TStRiseSetRec');
 CL.AddDelphiFunction('Function Twilight( LD : TStDate; Longitude, Latitude : Double; TwiType : TStTwilight) : TStRiseSetRec');
 CL.AddDelphiFunction('Function LunarPhase( UT : TStDateTimeRec) : Double');
 CL.AddDelphiFunction('Function MoonPos( UT : TStDateTimeRec) : TStMoonPosRec');
 CL.AddDelphiFunction('Function MoonRiseSet( LD : TStDate; Longitude, Latitude : Double) : TStRiseSetRec');
 CL.AddDelphiFunction('Function FirstQuarter( D : TStDate) : TStLunarRecord');
 CL.AddDelphiFunction('Function FullMoon( D : TStDate) : TStLunarRecord');
 CL.AddDelphiFunction('Function LastQuarter( D : TStDate) : TStLunarRecord');
 CL.AddDelphiFunction('Function NewMoon( D : TStDate) : TStLunarRecord');
 CL.AddDelphiFunction('Function NextFirstQuarter( D : TStDate) : TStDateTimeRec');
 CL.AddDelphiFunction('Function NextFullMoon( D : TStDate) : TStDateTimeRec');
 CL.AddDelphiFunction('Function NextLastQuarter( D : TStDate) : TStDateTimeRec');
 CL.AddDelphiFunction('Function NextNewMoon( D : TStDate) : TStDateTimeRec');
 CL.AddDelphiFunction('Function PrevFirstQuarter( D : TStDate) : TStDateTimeRec');
 CL.AddDelphiFunction('Function PrevFullMoon( D : TStDate) : TStDateTimeRec');
 CL.AddDelphiFunction('Function PrevLastQuarter( D : TStDate) : TStDateTimeRec');
 CL.AddDelphiFunction('Function PrevNewMoon( D : TStDate) : TStDateTimeRec');
 CL.AddDelphiFunction('Function SiderealTime( UT : TStDateTimeRec) : Double');
 CL.AddDelphiFunction('Function Solstice( Y, Epoch : Integer; Summer : Boolean) : TStDateTimeRec');
 CL.AddDelphiFunction('Function Equinox( Y, Epoch : Integer; Vernal : Boolean) : TStDateTimeRec');
 CL.AddDelphiFunction('Function SEaster( Y, Epoch : Integer) : TStDate');
 CL.AddDelphiFunction('Function DateTimeToAJD( D : TDateTime) : Double');
 CL.AddDelphiFunction('Function HoursMin( RA : Double) : ShortString');
 CL.AddDelphiFunction('Function DegsMin( DC : Double) : ShortString');
 CL.AddDelphiFunction('Function AJDToDateTime( D : Double) : TDateTime');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StAstro_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AmountOfSunlight, 'AmountOfSunlight', cdRegister);
 S.RegisterDelphiFunction(@FixedRiseSet, 'FixedRiseSet', cdRegister);
 S.RegisterDelphiFunction(@SunPos, 'SunPos', cdRegister);
 S.RegisterDelphiFunction(@SunPosPrim, 'SunPosPrim', cdRegister);
 S.RegisterDelphiFunction(@SunRiseSet, 'SunRiseSet', cdRegister);
 S.RegisterDelphiFunction(@Twilight, 'Twilight', cdRegister);
 S.RegisterDelphiFunction(@LunarPhase, 'LunarPhase', cdRegister);
 S.RegisterDelphiFunction(@MoonPos, 'MoonPos', cdRegister);
 S.RegisterDelphiFunction(@MoonRiseSet, 'MoonRiseSet', cdRegister);
 S.RegisterDelphiFunction(@FirstQuarter, 'FirstQuarter', cdRegister);
 S.RegisterDelphiFunction(@FullMoon, 'FullMoon', cdRegister);
 S.RegisterDelphiFunction(@LastQuarter, 'LastQuarter', cdRegister);
 S.RegisterDelphiFunction(@NewMoon, 'NewMoon', cdRegister);
 S.RegisterDelphiFunction(@NextFirstQuarter, 'NextFirstQuarter', cdRegister);
 S.RegisterDelphiFunction(@NextFullMoon, 'NextFullMoon', cdRegister);
 S.RegisterDelphiFunction(@NextLastQuarter, 'NextLastQuarter', cdRegister);
 S.RegisterDelphiFunction(@NextNewMoon, 'NextNewMoon', cdRegister);
 S.RegisterDelphiFunction(@PrevFirstQuarter, 'PrevFirstQuarter', cdRegister);
 S.RegisterDelphiFunction(@PrevFullMoon, 'PrevFullMoon', cdRegister);
 S.RegisterDelphiFunction(@PrevLastQuarter, 'PrevLastQuarter', cdRegister);
 S.RegisterDelphiFunction(@PrevNewMoon, 'PrevNewMoon', cdRegister);
 S.RegisterDelphiFunction(@SiderealTime, 'SiderealTime', cdRegister);
 S.RegisterDelphiFunction(@Solstice, 'Solstice', cdRegister);
 S.RegisterDelphiFunction(@Equinox, 'Equinox', cdRegister);
 S.RegisterDelphiFunction(@Easter, 'SEaster', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToAJD, 'DateTimeToAJD', cdRegister);
 S.RegisterDelphiFunction(@HoursMin, 'HoursMin', cdRegister);
 S.RegisterDelphiFunction(@DegsMin, 'DegsMin', cdRegister);
 S.RegisterDelphiFunction(@AJDToDateTime, 'AJDToDateTime', cdRegister);
end;

 
 
{ TPSImport_StAstro }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StAstro.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StAstro(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StAstro.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StAstro(ri);
  RIRegister_StAstro_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
