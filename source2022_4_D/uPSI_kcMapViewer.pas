unit uPSI_kcMapViewer;
{
  maps of the world
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
  TPSImport_kcMapViewer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMapViewer(CL: TPSPascalCompiler);
procedure SIRegister_TCustomGeolocationEngine(CL: TPSPascalCompiler);
procedure SIRegister_TCustomDownloadEngine(CL: TPSPascalCompiler);
procedure SIRegister_kcMapViewer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMapViewer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomGeolocationEngine(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomDownloadEngine(CL: TPSRuntimeClassImporter);
procedure RIRegister_kcMapViewer(CL: TPSRuntimeClassImporter);


{ compile-time registration functions }
procedure SIRegister_TMVGLGeoNames(CL: TPSPascalCompiler);
procedure SIRegister_kcMapViewerGLGeoNames(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMVGLGeoNames(CL: TPSRuntimeClassImporter);
procedure RIRegister_kcMapViewerGLGeoNames(CL: TPSRuntimeClassImporter);


procedure Register;

implementation


uses
   Controls
  ,Graphics
  ,kcThreadPool
  ,kcMapViewer
  ,kcMapViewerGLGeoNames

  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_kcMapViewer]);
end;


procedure SIRegister_TMVGLGeoNames(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomGeolocationEngine', 'TMVGLGeoNames') do
  with CL.AddClassN(CL.FindClass('TCustomGeolocationEngine'),'TMVGLGeoNames') do
  begin
    RegisterProperty('LocationName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_kcMapViewerGLGeoNames(CL: TPSPascalCompiler);
begin
  SIRegister_TMVGLGeoNames(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMVGLGeoNamesLocationName_W(Self: TMVGLGeoNames; const T: string);
begin Self.LocationName := T; end;

(*----------------------------------------------------------------------------*)
procedure TMVGLGeoNamesLocationName_R(Self: TMVGLGeoNames; var T: string);
begin T := Self.LocationName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMVGLGeoNames(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMVGLGeoNames) do
  begin
    RegisterPropertyHelper(@TMVGLGeoNamesLocationName_R,@TMVGLGeoNamesLocationName_W,'LocationName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_kcMapViewerGLGeoNames(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMVGLGeoNames(CL);
end;



{ TPSImport_kcMapViewerGLGeoNames }
(*----------------------------------------------------------------------------*)


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMapViewer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TMapViewer') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TMapViewer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
          RegisterMethod('Procedure Free');
     RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Function GetMouseMapTile( X, Y : Integer) : TIntPoint');
    RegisterMethod('Function GetMouseMapPixel( X, Y : Integer) : TIntPoint');
    RegisterMethod('Function GetMouseMapLongLat( X, Y : Integer) : TRealPoint');
    RegisterMethod('Procedure Geolocate');
    RegisterMethod('Procedure Center');
    RegisterProperty('CenterLongLat', 'TRealPoint', iptrw);
    RegisterProperty('CacheCount', 'Word', iptr);
    RegisterProperty('AutoZoom', 'Boolean', iptrw);
    RegisterProperty('Zoom', 'Byte', iptrw);
    RegisterProperty('Debug', 'Boolean', iptrw);
    RegisterProperty('Source', 'TMapSource', iptrw);
    RegisterProperty('CacheSize', 'Word', iptrw);
    RegisterProperty('UseThreads', 'Boolean', iptrw);
    RegisterProperty('DownloadEngine', 'TCustomDownloadEngine', iptrw);
    RegisterProperty('GeolocationEngine', 'TCustomGeolocationEngine', iptrw);
    RegisterProperty('DoubleBuffering', 'Boolean', iptrw);
       Registerpublishedproperties;
     RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     //RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('onclick', 'TNotifyEvent', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('onmousedown', 'TNotifyEvent', iptrw);
    RegisterProperty('onmouseup', 'TNotifyEvent', iptrw);
    RegisterProperty('onmousemove', 'TNotifyEvent', iptrw);
    RegisterProperty('ondblclick', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomGeolocationEngine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomGeolocationEngine') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomGeolocationEngine') do
  begin
    RegisterMethod('Procedure Search( AParent : TMapViewer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomDownloadEngine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomDownloadEngine') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomDownloadEngine') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure DownloadFile( const Url : string; str : TStream)');
    RegisterProperty('OnBeforeDownload', 'TOnBeforeDownloadEvent', iptrw);
    RegisterProperty('OnAfterDownload', 'TOnAfterDownloadEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_kcMapViewer(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMapViewer');
  CL.AddTypeS('TMapSource', '( msNone, msGoogleNormal, msGoogleSatellite, msGoo'
   +'gleHybrid, msGooglePhysical, msGooglePhysicalHybrid, msOpenStreetMapMapnik'
   +', msOpenStreetMapOsmarender, msOpenCycleMap, msVirtualEarthBing, msVirtual'
   +'EarthRoad, msVirtualEarthAerial, msVirtualEarthHybrid, msYahooNormal, msYa'
   +'hooSatellite, msYahooHybrid, msOviNormal, msOviSatellite, msOviHybrid, msOviPhysical )');
  CL.AddTypeS('TArea', 'record top : Int64; left : Int64; bottom : Int64; right: Int64; end');
  CL.AddTypeS('TRealArea', 'record top : Extended; left : Extended; bottom : Extended; right : Extended; end');
  CL.AddTypeS('TIntPoint', 'record X : Int64; Y : Int64; end');
  CL.AddTypeS('TkcRealPoint', 'record X : Extended; Y : Extended; end');
  CL.AddTypeS('TOnBeforeDownloadEvent', 'Procedure ( Url : string; str : TStream; var CanHandle : Boolean)');
  CL.AddTypeS('TOnAfterDownloadEvent', 'Procedure ( Url : string; str : TStream)');
  SIRegister_TCustomDownloadEngine(CL);
  SIRegister_TCustomGeolocationEngine(CL);
  SIRegister_TMapViewer(CL);

  //function IsValidPNG(stream: TStream): Boolean;
  //function IsValidJPEG(stream: TStream): Boolean;

 CL.AddDelphiFunction('Function IsValidPNG(stream: TStream): Boolean;');
 CL.AddDelphiFunction('Function IsValidJPEG(stream: TStream): Boolean;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMapViewerDoubleBuffering_W(Self: TMapViewer; const T: Boolean);
begin Self.DoubleBuffering := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerDoubleBuffering_R(Self: TMapViewer; var T: Boolean);
begin T := Self.DoubleBuffering; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerGeolocationEngine_W(Self: TMapViewer; const T: TCustomGeolocationEngine);
begin Self.GeolocationEngine := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerGeolocationEngine_R(Self: TMapViewer; var T: TCustomGeolocationEngine);
begin T := Self.GeolocationEngine; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerDownloadEngine_W(Self: TMapViewer; const T: TCustomDownloadEngine);
begin Self.DownloadEngine := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerDownloadEngine_R(Self: TMapViewer; var T: TCustomDownloadEngine);
begin T := Self.DownloadEngine; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerUseThreads_W(Self: TMapViewer; const T: Boolean);
begin Self.UseThreads := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerUseThreads_R(Self: TMapViewer; var T: Boolean);
begin T := Self.UseThreads; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerCacheSize_W(Self: TMapViewer; const T: Word);
begin Self.CacheSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerCacheSize_R(Self: TMapViewer; var T: Word);
begin T := Self.CacheSize; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerSource_W(Self: TMapViewer; const T: TMapSource);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerSource_R(Self: TMapViewer; var T: TMapSource);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerDebug_W(Self: TMapViewer; const T: Boolean);
begin Self.Debug := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerDebug_R(Self: TMapViewer; var T: Boolean);
begin T := Self.Debug; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerZoom_W(Self: TMapViewer; const T: Byte);
begin Self.Zoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerZoom_R(Self: TMapViewer; var T: Byte);
begin T := Self.Zoom; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerAutoZoom_W(Self: TMapViewer; const T: Boolean);
begin Self.AutoZoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerAutoZoom_R(Self: TMapViewer; var T: Boolean);
begin T := Self.AutoZoom; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerCacheCount_R(Self: TMapViewer; var T: Word);
begin T := Self.CacheCount; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerCenterLongLat_W(Self: TMapViewer; const T: TRealPoint);
begin Self.CenterLongLat := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapViewerCenterLongLat_R(Self: TMapViewer; var T: TRealPoint);
begin T := Self.CenterLongLat; end;

(*----------------------------------------------------------------------------*)
Function TMapViewerGetFromCache1_P(Self: TMapViewer;  source : TMapSource; X, Y, Z : Int64; bitmap : TBitmap) : Boolean;
Begin //Result := Self.GetFromCache(source, X, Y, Z, bitmap);
END;

(*----------------------------------------------------------------------------*)
Function TMapViewerGetFromCache_P(Self: TMapViewer;  url : string; stream : TStream) : Boolean;
Begin //Result := Self.GetFromCache(url, stream);
END;

(*----------------------------------------------------------------------------*)
Procedure TMapViewerAddToCache1_P(Self: TMapViewer;  source : TMapSource; X, Y, Z : Int64; stream : TStream);
Begin //Self.AddToCache(source, X, Y, Z, stream);
END;

(*----------------------------------------------------------------------------*)
Procedure TMapViewerAddToCache_P(Self: TMapViewer;  url : string; stream : TStream);
Begin //Self.AddToCache(url, stream);
END;

(*----------------------------------------------------------------------------*)
procedure TCustomDownloadEngineOnAfterDownload_W(Self: TCustomDownloadEngine; const T: TOnAfterDownloadEvent);
begin Self.OnAfterDownload := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDownloadEngineOnAfterDownload_R(Self: TCustomDownloadEngine; var T: TOnAfterDownloadEvent);
begin T := Self.OnAfterDownload; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDownloadEngineOnBeforeDownload_W(Self: TCustomDownloadEngine; const T: TOnBeforeDownloadEvent);
begin Self.OnBeforeDownload := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDownloadEngineOnBeforeDownload_R(Self: TCustomDownloadEngine; var T: TOnBeforeDownloadEvent);
begin T := Self.OnBeforeDownload; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMapViewer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMapViewer) do begin
    RegisterConstructor(@TMapViewer.Create, 'Create');
       RegisterMethod(@TMapViewer.Destroy, 'Free');
     RegisterMethod(@TMapViewer.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TMapViewer.EndUpdate, 'EndUpdate');
    RegisterMethod(@TMapViewer.GetMouseMapTile, 'GetMouseMapTile');
    RegisterMethod(@TMapViewer.GetMouseMapPixel, 'GetMouseMapPixel');
    RegisterMethod(@TMapViewer.GetMouseMapLongLat, 'GetMouseMapLongLat');
    RegisterMethod(@TMapViewer.Geolocate, 'Geolocate');
    RegisterMethod(@TMapViewer.Center, 'Center');
    RegisterPropertyHelper(@TMapViewerCenterLongLat_R,@TMapViewerCenterLongLat_W,'CenterLongLat');
    RegisterPropertyHelper(@TMapViewerCacheCount_R,nil,'CacheCount');
    RegisterPropertyHelper(@TMapViewerAutoZoom_R,@TMapViewerAutoZoom_W,'AutoZoom');
    RegisterPropertyHelper(@TMapViewerZoom_R,@TMapViewerZoom_W,'Zoom');
    RegisterPropertyHelper(@TMapViewerDebug_R,@TMapViewerDebug_W,'Debug');
    RegisterPropertyHelper(@TMapViewerSource_R,@TMapViewerSource_W,'Source');
    RegisterPropertyHelper(@TMapViewerCacheSize_R,@TMapViewerCacheSize_W,'CacheSize');
    RegisterPropertyHelper(@TMapViewerUseThreads_R,@TMapViewerUseThreads_W,'UseThreads');
    RegisterPropertyHelper(@TMapViewerDownloadEngine_R,@TMapViewerDownloadEngine_W,'DownloadEngine');
    RegisterPropertyHelper(@TMapViewerGeolocationEngine_R,@TMapViewerGeolocationEngine_W,'GeolocationEngine');
    RegisterPropertyHelper(@TMapViewerDoubleBuffering_R,@TMapViewerDoubleBuffering_W,'DoubleBuffering');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomGeolocationEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomGeolocationEngine) do
  begin
    RegisterMethod(@TCustomGeolocationEngine.Search, 'Search');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomDownloadEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomDownloadEngine) do
  begin
    RegisterConstructor(@TCustomDownloadEngine.Create, 'Create');
    RegisterVirtualMethod(@TCustomDownloadEngine.DownloadFile, 'DownloadFile');
    RegisterPropertyHelper(@TCustomDownloadEngineOnBeforeDownload_R,@TCustomDownloadEngineOnBeforeDownload_W,'OnBeforeDownload');
    RegisterPropertyHelper(@TCustomDownloadEngineOnAfterDownload_R,@TCustomDownloadEngineOnAfterDownload_W,'OnAfterDownload');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_kcMapViewer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMapViewer) do
  RIRegister_TCustomDownloadEngine(CL);
  RIRegister_TCustomGeolocationEngine(CL);
  RIRegister_TMapViewer(CL);
end;

 
 
{ TPSImport_kcMapViewer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_kcMapViewer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_kcMapViewer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_kcMapViewer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_kcMapViewer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
