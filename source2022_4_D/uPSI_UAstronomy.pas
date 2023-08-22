unit uPSI_UAstronomy;
{
   my kepler    add zto decimals and overload   sunpos() bug
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
  TPSImport_UAstronomy = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAstronomy(CL: TPSPascalCompiler);
procedure SIRegister_UAstronomy(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_UAstronomy_Routines(S: TPSExec);
procedure RIRegister_TAstronomy(CL: TPSRuntimeClassImporter);
procedure RIRegister_UAstronomy(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   UAstronomy
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UAstronomy]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAstronomy(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAstronomy') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAstronomy') do begin
    RegisterProperty('NuLong', 'extended', iptrw);
    RegisterProperty('NuOblique', 'extended', iptrw);
    RegisterProperty('Obliquity', 'extended', iptrw);
    RegisterMethod('Constructor create');
    RegisterMethod('Procedure assign( F : TAstronomy)');
    RegisterMethod('Procedure SunPos( var Sunrec : TSunrec)');
     RegisterMethod('Procedure SunPos2( var Sunrec : TSunrec2)');    //double
    RegisterMethod('Procedure MoonPos( var Moonrec : TMoonRec)');
    RegisterMethod('Procedure MoonPos2( var Moonrec : TMoonRec2)');     //double
    RegisterMethod('Function RiseSet( Inval : TRPoint; InDI : extended; var AzUp, AzDn, LSTUp, LSTDn : extended) : String');
    RegisterMethod('Function SunRiseSet( CalcType : integer; var UpTmAz, DNTmAz : TRPoint) : String');
    RegisterMethod('Function MoonRiseSet( var UpTmAz, DNTmAz : TRPoint) : String;');
    RegisterMethod('Function MoonRiseSet1( var UpTmAz, DNTmAz : TRPoint; var altitude : extended) : String;');
    RegisterMethod('Procedure NewFullMoon( Date : TDateTime; var FULLDATETIME, NEWDATETIME : TDATETIME; var FULLLAT, NEWLAT : EXTENDED)');
    RegisterMethod('Procedure ConvertLSTime( Value : TDateTime; var GSTime, LCTime, UTime : TDatetime)');
    RegisterMethod('Procedure ECLIPSE( Etype : char; NearDate : TDatetime; var EclipseRec : TEclipseRec; var MoonAdd : TMoonEclipseAdd)');
    RegisterMethod('Procedure Planets( Planet : TPlanet; var RecOut : TPlanetLocRec)');
    RegisterMethod('Function ConvertCoord( FromType, ToType : TCoordType; Input : TRpoint) : TRPoint');
    RegisterMethod('Function getprintdatetime( FromType, ToType : TDtType; DT : TDateTime; IncludeDate : Boolean; var convertedDT : TDateTime) : string');
    RegisterProperty('ADate', 'TDateTime', iptrw);
    RegisterProperty('LocalTime', 'TDateTime', iptrw);
    RegisterProperty('LSTime', 'TDateTime', iptrw);
    RegisterProperty('UniversalTime', 'TDateTime', iptrw);
    RegisterProperty('GSTime', 'TDateTime', iptrw);
    RegisterProperty('TZHours', 'integer', iptrw);
    RegisterProperty('DLSHours', 'Integer', iptrw);
    RegisterProperty('LonLat', 'TRPoint', iptrw);
    RegisterProperty('AzAlt', 'TRPoint', iptrw);
    RegisterProperty('EclonLat', 'TRPoint', iptrw);
    RegisterProperty('GalLonLat', 'TRPoint', iptrw);
    RegisterProperty('HADecl', 'TRPoint', iptrw);
    RegisterProperty('RADecl', 'TRPoint', iptrw);
    RegisterProperty('Height', 'Extended', iptrw);
    RegisterProperty('DecimalFormat', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UAstronomy(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCoordType', '(astroctUnknown, ctAzAlt, ctEclLonLat, ctRADecl, ctHADecl, ctGalLonLat )');
  CL.AddTypeS('TDTType', '( ttLocal, ttUT, ttGST, ttLST )');
  CL.AddTypeS('TRPoint', 'record x : extended; y : extended; CoordType : TCoordType; end');
  CL.AddTypeS('TSunrec', 'record TrueEclLon : extended; AppEclLon : extended; AUDistance : extended; TrueHADecl : TRPoint; TrueRADecl : TRPoint; TrueAzAl'
   +'t : TRPoint; AppHADecl : TRPoint; AppRADecl : TRPoint; AppAzAlt : TRpoint; SunMeanAnomaly : extended; end');
  CL.AddTypeS('TSunrec2', 'record TrueEclLon : double; AppEclLon : double; AUDistance : double; TrueHADecl : TRPoint; TrueRADecl : TRPoint; TrueAzAl'
   +'t : TRPoint; AppHADecl : TRPoint; AppRADecl : TRPoint; AppAzAlt : TRpoint; SunMeanAnomaly : double; end');

  CL.AddTypeS('TMoonRec', 'record ECLonLat : TRPoint; AZAlt : TRPoint; RADecl :'
   +' TRPoint; HorizontalParallax : extended; AngularDiameter : extended; KMtoEarth : extended; Phase : extended; end');
   CL.AddTypeS('TMoonRec2', 'record ECLonLat : TRPoint; AZAlt : TRPoint; RADecl :'
   +' TRPoint; HorizontalParallax : double; AngularDiameter : double; KMtoEarth : double; Phase : double; end');
  CL.AddTypeS('TMoonEclipseAdd', 'record UmbralStartTime : TDatetime; UmbralEnd'
   +'Time : TDatetime; TotalStartTime : TDatetime; TotalEndTime : TDateTime; end');
  CL.AddTypeS('TEclipseRec', 'record Msg : string; Status : integer; FirstConta'
   +'ct : TDatetime; LastContact : TDateTime; Magnitude : Extended; MaxeclipseUTime : TDateTime; end');
  CL.AddTypeS('TPlanet', '( MERCURY, VENUS, MARS, JUPITER, SATURN, URANUS, NEPTUNE, PLUTO )');
  CL.AddTypeS('TPlanetRec', 'record AsOf : TDateTime; Name : string; MeanLon : '
   +'extended; MeanLonMotion : extended; LonOfPerihelion : extended; Eccentrici'
   +'ty : extended; Inclination : extended; LonAscendingNode : extended; SemiMa'
   +'jorAxis : extended; AngularDiameter : extended; Magnitude : extended; end');
  CL.AddTypeS('TPlanetLocRec', 'record PlanetBaseData : TPlanetrec; HelioCentri'
   +'cLonLat : TRpoint; RadiusVector : extended; UncorrectedEarthDistance : ext'
   +'ended; GeoEclLonLat : TRpoint; CorrectedEarthDistance : extended; ApparentRaDecl : TRPoint; end');
  SIRegister_TAstronomy(CL);
 CL.AddDelphiFunction('Function AngleToStr( angle : extended) : string');
 CL.AddDelphiFunction('Function StrToAngle( s : string; var angle : extended) : boolean');
 CL.AddDelphiFunction('Function HoursToStr24( t : extended) : string');
 CL.AddDelphiFunction('Function RPoint( x, y : extended) : TRPoint');
 CL.AddDelphiFunction('Function getStimename( t : TDTType) : string');
 CL.AddDelphiFunction('Function AngleToStr2( angle : extended; decimal:boolean) : string');

  //function AngleToStr2(angle:extended; decimal:boolean):string;

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAstronomyHeight_W(Self: TAstronomy; const T: Extended);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyHeight_R(Self: TAstronomy; var T: Extended);
begin T := Self.Height; end;

procedure TAstronomyDecimal_W(Self: TAstronomy; const T: boolean);
begin Self.DecimalFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyDecimal_R(Self: TAstronomy; var T: boolean);
begin T := Self.DecimalFormat; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyRADecl_W(Self: TAstronomy; const T: TRPoint);
begin Self.RADecl := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyRADecl_R(Self: TAstronomy; var T: TRPoint);
begin T := Self.RADecl; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyHADecl_W(Self: TAstronomy; const T: TRPoint);
begin Self.HADecl := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyHADecl_R(Self: TAstronomy; var T: TRPoint);
begin T := Self.HADecl; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyGalLonLat_W(Self: TAstronomy; const T: TRPoint);
begin Self.GalLonLat := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyGalLonLat_R(Self: TAstronomy; var T: TRPoint);
begin T := Self.GalLonLat; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyEclonLat_W(Self: TAstronomy; const T: TRPoint);
begin Self.EclonLat := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyEclonLat_R(Self: TAstronomy; var T: TRPoint);
begin T := Self.EclonLat; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyAzAlt_W(Self: TAstronomy; const T: TRPoint);
begin Self.AzAlt := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyAzAlt_R(Self: TAstronomy; var T: TRPoint);
begin T := Self.AzAlt; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyLonLat_W(Self: TAstronomy; const T: TRPoint);
begin Self.LonLat := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyLonLat_R(Self: TAstronomy; var T: TRPoint);
begin T := Self.LonLat; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyDLSHours_W(Self: TAstronomy; const T: Integer);
begin Self.DLSHours := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyDLSHours_R(Self: TAstronomy; var T: Integer);
begin T := Self.DLSHours; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyTZHours_W(Self: TAstronomy; const T: integer);
begin Self.TZHours := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyTZHours_R(Self: TAstronomy; var T: integer);
begin T := Self.TZHours; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyGSTime_W(Self: TAstronomy; const T: TDateTime);
begin Self.GSTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyGSTime_R(Self: TAstronomy; var T: TDateTime);
begin T := Self.GSTime; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyUniversalTime_W(Self: TAstronomy; const T: TDateTime);
begin Self.UniversalTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyUniversalTime_R(Self: TAstronomy; var T: TDateTime);
begin T := Self.UniversalTime; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyLSTime_W(Self: TAstronomy; const T: TDateTime);
begin Self.LSTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyLSTime_R(Self: TAstronomy; var T: TDateTime);
begin T := Self.LSTime; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyLocalTime_W(Self: TAstronomy; const T: TDateTime);
begin Self.LocalTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyLocalTime_R(Self: TAstronomy; var T: TDateTime);
begin T := Self.LocalTime; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyADate_W(Self: TAstronomy; const T: TDateTime);
begin Self.ADate := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyADate_R(Self: TAstronomy; var T: TDateTime);
begin T := Self.ADate; end;

(*----------------------------------------------------------------------------*)
Function TAstronomyMoonRiseSet1_P(Self: TAstronomy;  var UpTmAz, DNTmAz : TRPoint; var altitude : extended) : String;
Begin Result := Self.MoonRiseSet(UpTmAz, DNTmAz, altitude); END;

(*----------------------------------------------------------------------------*)
Function TAstronomyMoonRiseSet_P(Self: TAstronomy;  var UpTmAz, DNTmAz : TRPoint) : String;
Begin Result := Self.MoonRiseSet(UpTmAz, DNTmAz); END;

(*----------------------------------------------------------------------------*)
procedure TAstronomyObliquity_W(Self: TAstronomy; const T: extended);
Begin Self.Obliquity := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyObliquity_R(Self: TAstronomy; var T: extended);
Begin T := Self.Obliquity; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyNuOblique_W(Self: TAstronomy; const T: extended);
Begin Self.NuOblique := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyNuOblique_R(Self: TAstronomy; var T: extended);
Begin T := Self.NuOblique; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyNuLong_W(Self: TAstronomy; const T: extended);
Begin Self.NuLong := T; end;

(*----------------------------------------------------------------------------*)
procedure TAstronomyNuLong_R(Self: TAstronomy; var T: extended);
Begin T := Self.NuLong; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UAstronomy_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AngleToStr, 'AngleToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToAngle, 'StrToAngle', cdRegister);
 S.RegisterDelphiFunction(@HoursToStr24, 'HoursToStr24', cdRegister);
 S.RegisterDelphiFunction(@RPoint, 'RPoint', cdRegister);
 S.RegisterDelphiFunction(@getStimename, 'getStimename', cdRegister);
 S.RegisterDelphiFunction(@AngleToStr2, 'AngleToStr2', cdRegister);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAstronomy(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAstronomy) do begin
    RegisterPropertyHelper(@TAstronomyNuLong_R,@TAstronomyNuLong_W,'NuLong');
    RegisterPropertyHelper(@TAstronomyNuOblique_R,@TAstronomyNuOblique_W,'NuOblique');
    RegisterPropertyHelper(@TAstronomyObliquity_R,@TAstronomyObliquity_W,'Obliquity');
    RegisterConstructor(@TAstronomy.create, 'create');
    RegisterMethod(@TAstronomy.assign, 'assign');
    RegisterMethod(@TAstronomy.SunPos, 'SunPos');
    RegisterMethod(@TAstronomy.SunPos, 'SunPos2');
    RegisterMethod(@TAstronomy.MoonPos, 'MoonPos');
    RegisterMethod(@TAstronomy.MoonPos, 'MoonPos2');
    RegisterMethod(@TAstronomy.RiseSet, 'RiseSet');
    RegisterMethod(@TAstronomy.SunRiseSet, 'SunRiseSet');
    RegisterMethod(@TAstronomyMoonRiseSet_P, 'MoonRiseSet');
    RegisterMethod(@TAstronomyMoonRiseSet1_P, 'MoonRiseSet1');
    RegisterMethod(@TAstronomy.NewFullMoon, 'NewFullMoon');
    RegisterMethod(@TAstronomy.ConvertLSTime, 'ConvertLSTime');
    RegisterMethod(@TAstronomy.ECLIPSE, 'ECLIPSE');
    RegisterMethod(@TAstronomy.Planets, 'Planets');
    RegisterMethod(@TAstronomy.ConvertCoord, 'ConvertCoord');
    RegisterMethod(@TAstronomy.getprintdatetime, 'getprintdatetime');
    RegisterPropertyHelper(@TAstronomyADate_R,@TAstronomyADate_W,'ADate');
    RegisterPropertyHelper(@TAstronomyLocalTime_R,@TAstronomyLocalTime_W,'LocalTime');
    RegisterPropertyHelper(@TAstronomyLSTime_R,@TAstronomyLSTime_W,'LSTime');
    RegisterPropertyHelper(@TAstronomyUniversalTime_R,@TAstronomyUniversalTime_W,'UniversalTime');
    RegisterPropertyHelper(@TAstronomyGSTime_R,@TAstronomyGSTime_W,'GSTime');
    RegisterPropertyHelper(@TAstronomyTZHours_R,@TAstronomyTZHours_W,'TZHours');
    RegisterPropertyHelper(@TAstronomyDLSHours_R,@TAstronomyDLSHours_W,'DLSHours');
    RegisterPropertyHelper(@TAstronomyLonLat_R,@TAstronomyLonLat_W,'LonLat');
    RegisterPropertyHelper(@TAstronomyAzAlt_R,@TAstronomyAzAlt_W,'AzAlt');
    RegisterPropertyHelper(@TAstronomyEclonLat_R,@TAstronomyEclonLat_W,'EclonLat');
    RegisterPropertyHelper(@TAstronomyGalLonLat_R,@TAstronomyGalLonLat_W,'GalLonLat');
    RegisterPropertyHelper(@TAstronomyHADecl_R,@TAstronomyHADecl_W,'HADecl');
    RegisterPropertyHelper(@TAstronomyRADecl_R,@TAstronomyRADecl_W,'RADecl');
    RegisterPropertyHelper(@TAstronomyHeight_R,@TAstronomyHeight_W,'Height');
    RegisterPropertyHelper(@TAstronomyDecimal_R,@TAstronomyDecimal_W,'DecimalFormat');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UAstronomy(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAstronomy(CL);
end;

 
 
{ TPSImport_UAstronomy }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UAstronomy.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UAstronomy(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UAstronomy.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UAstronomy(ri);
  RIRegister_UAstronomy_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
