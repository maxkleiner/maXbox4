unit uPSI_JvZoom;
{
   another fractal
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
  TPSImport_JvZoom = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvZoom(CL: TPSPascalCompiler);
procedure SIRegister_JvZoom(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvZoom(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvZoom(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  //,Messages
  Graphics
  ,Controls
  //,Forms
  //,ExtCtrls
  ,JvComponent
  ,JvZoom
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvZoom]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvZoom(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomControl', 'TJvZoom') do
  with CL.AddClassN(CL.FindClass('TJvCustomControl'),'TJvZoom') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ForceUpdate');
    RegisterMethod('Procedure ZoomInAt( X, Y : Integer)');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('ZoomLevel', 'Integer', iptrw);
    RegisterProperty('ZoomPercentage', 'Integer', iptrw);
    RegisterProperty('Delay', 'Cardinal', iptrw);
    RegisterProperty('Crosshair', 'Boolean', iptrw);
    RegisterProperty('CrossHairPicture', 'TPicture', iptrw);
    RegisterProperty('CrosshairColor', 'TColor', iptrw);
    RegisterProperty('CrosshairSize', 'Integer', iptrw);
    RegisterProperty('CacheOnDeactivate', 'Boolean', iptrw);
    RegisterProperty('OnContentsChanged', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvZoom(CL: TPSPascalCompiler);
begin
  SIRegister_TJvZoom(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvZoomOnContentsChanged_W(Self: TJvZoom; const T: TNotifyEvent);
begin Self.OnContentsChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomOnContentsChanged_R(Self: TJvZoom; var T: TNotifyEvent);
begin T := Self.OnContentsChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomCacheOnDeactivate_W(Self: TJvZoom; const T: Boolean);
begin Self.CacheOnDeactivate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomCacheOnDeactivate_R(Self: TJvZoom; var T: Boolean);
begin T := Self.CacheOnDeactivate; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomCrosshairSize_W(Self: TJvZoom; const T: Integer);
begin Self.CrosshairSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomCrosshairSize_R(Self: TJvZoom; var T: Integer);
begin T := Self.CrosshairSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomCrosshairColor_W(Self: TJvZoom; const T: TColor);
begin Self.CrosshairColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomCrosshairColor_R(Self: TJvZoom; var T: TColor);
begin T := Self.CrosshairColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomCrossHairPicture_W(Self: TJvZoom; const T: TPicture);
begin Self.CrossHairPicture := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomCrossHairPicture_R(Self: TJvZoom; var T: TPicture);
begin T := Self.CrossHairPicture; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomCrosshair_W(Self: TJvZoom; const T: Boolean);
begin Self.Crosshair := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomCrosshair_R(Self: TJvZoom; var T: Boolean);
begin T := Self.Crosshair; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomDelay_W(Self: TJvZoom; const T: Cardinal);
begin Self.Delay := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomDelay_R(Self: TJvZoom; var T: Cardinal);
begin T := Self.Delay; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomZoomPercentage_W(Self: TJvZoom; const T: Integer);
begin Self.ZoomPercentage := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomZoomPercentage_R(Self: TJvZoom; var T: Integer);
begin T := Self.ZoomPercentage; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomZoomLevel_W(Self: TJvZoom; const T: Integer);
begin Self.ZoomLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomZoomLevel_R(Self: TJvZoom; var T: Integer);
begin T := Self.ZoomLevel; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomActive_W(Self: TJvZoom; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvZoomActive_R(Self: TJvZoom; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvZoom(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvZoom) do begin
    RegisterConstructor(@TJvZoom.Create, 'Create');
    RegisterMethod(@TJvZoom.Destroy, 'Free');
    RegisterMethod(@TJvZoom.ForceUpdate, 'ForceUpdate');
    RegisterMethod(@TJvZoom.ZoomInAt, 'ZoomInAt');
    RegisterPropertyHelper(@TJvZoomActive_R,@TJvZoomActive_W,'Active');
    RegisterPropertyHelper(@TJvZoomZoomLevel_R,@TJvZoomZoomLevel_W,'ZoomLevel');
    RegisterPropertyHelper(@TJvZoomZoomPercentage_R,@TJvZoomZoomPercentage_W,'ZoomPercentage');
    RegisterPropertyHelper(@TJvZoomDelay_R,@TJvZoomDelay_W,'Delay');
    RegisterPropertyHelper(@TJvZoomCrosshair_R,@TJvZoomCrosshair_W,'Crosshair');
    RegisterPropertyHelper(@TJvZoomCrossHairPicture_R,@TJvZoomCrossHairPicture_W,'CrossHairPicture');
    RegisterPropertyHelper(@TJvZoomCrosshairColor_R,@TJvZoomCrosshairColor_W,'CrosshairColor');
    RegisterPropertyHelper(@TJvZoomCrosshairSize_R,@TJvZoomCrosshairSize_W,'CrosshairSize');
    RegisterPropertyHelper(@TJvZoomCacheOnDeactivate_R,@TJvZoomCacheOnDeactivate_W,'CacheOnDeactivate');
    RegisterPropertyHelper(@TJvZoomOnContentsChanged_R,@TJvZoomOnContentsChanged_W,'OnContentsChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvZoom(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvZoom(CL);
end;

 
 
{ TPSImport_JvZoom }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvZoom.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvZoom(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvZoom.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvZoom(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
