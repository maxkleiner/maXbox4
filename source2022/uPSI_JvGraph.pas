unit uPSI_JvGraph;
{
  with zoom routine
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
  TPSImport_JvGraph = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvGradient(CL: TPSPascalCompiler);
procedure SIRegister_JvGraph(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvGraph_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,WinTypes
  //,WinProcs
  ,Graphics
  ,JvVCLUtils
  ,JvGraph
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvGraph]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvGradient') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvGradient') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Draw( Canvas : TCanvas; Rect : TRect)');
    RegisterProperty('Direction', 'TFillDirection', iptrw);
    RegisterProperty('EndColor', 'TColor', iptrw);
    RegisterProperty('StartColor', 'TColor', iptrw);
    RegisterProperty('StepCount', 'Byte', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvGraph(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPixelFormat', '( pfDevice, pf1bit, pf4bit, pf8bit, pf24bit )');
  CL.AddTypeS('TMappingMethod', '( mmHistogram, mmQuantize, mmTrunc784, mmTrunc'
   +'666, mmTripel, mmGrayscale )');
 CL.AddDelphiFunction('Function GetBitmapPixelFormat( Bitmap : TBitmap) : TPixelFormat');
 CL.AddDelphiFunction('Function GetPaletteBitmapFormat( Bitmap : TBitmap) : TPixelFormat');
 CL.AddDelphiFunction('Procedure SetBitmapPixelFormat( Bitmap : TBitmap; PixelFormat : TPixelFormat; Method : TMappingMethod)');
 CL.AddDelphiFunction('Function BitmapToMemoryStream( Bitmap : TBitmap; PixelFormat : TPixelFormat; Method : TMappingMethod) : TMemoryStream');
 CL.AddDelphiFunction('Procedure GrayscaleBitmap( Bitmap : TBitmap)');
 CL.AddDelphiFunction('Function BitmapToMemory( Bitmap : TBitmap; Colors : Integer) : TStream');
 CL.AddDelphiFunction('Procedure SaveBitmapToFile( const Filename : string; Bitmap : TBitmap; Colors : Integer)');
 CL.AddDelphiFunction('Function ScreenPixelFormat : TPixelFormat');
 CL.AddDelphiFunction('Function ScreenColorCount : Integer');
 CL.AddDelphiFunction('Procedure TileImage( Canvas : TCanvas; Rect : TRect; Image : TGraphic)');
 CL.AddDelphiFunction('Function ZoomImage( ImageW, ImageH, MaxW, MaxH : Integer; Stretch : Boolean) : TPoint');
  SIRegister_TJvGradient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvGradientOnChange_W(Self: TJvGradient; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGradientOnChange_R(Self: TJvGradient; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvGradientVisible_W(Self: TJvGradient; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGradientVisible_R(Self: TJvGradient; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TJvGradientStepCount_W(Self: TJvGradient; const T: Byte);
begin Self.StepCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGradientStepCount_R(Self: TJvGradient; var T: Byte);
begin T := Self.StepCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvGradientStartColor_W(Self: TJvGradient; const T: TColor);
begin Self.StartColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGradientStartColor_R(Self: TJvGradient; var T: TColor);
begin T := Self.StartColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvGradientEndColor_W(Self: TJvGradient; const T: TColor);
begin Self.EndColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGradientEndColor_R(Self: TJvGradient; var T: TColor);
begin T := Self.EndColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvGradientDirection_W(Self: TJvGradient; const T: TFillDirection);
begin Self.Direction := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGradientDirection_R(Self: TJvGradient; var T: TFillDirection);
begin T := Self.Direction; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvGradient) do begin
    RegisterConstructor(@TJvGradient.Create, 'Create');
    RegisterMethod(@TJvGradient.Draw, 'Draw');
    RegisterPropertyHelper(@TJvGradientDirection_R,@TJvGradientDirection_W,'Direction');
    RegisterPropertyHelper(@TJvGradientEndColor_R,@TJvGradientEndColor_W,'EndColor');
    RegisterPropertyHelper(@TJvGradientStartColor_R,@TJvGradientStartColor_W,'StartColor');
    RegisterPropertyHelper(@TJvGradientStepCount_R,@TJvGradientStepCount_W,'StepCount');
    RegisterPropertyHelper(@TJvGradientVisible_R,@TJvGradientVisible_W,'Visible');
    RegisterPropertyHelper(@TJvGradientOnChange_R,@TJvGradientOnChange_W,'OnChange');
  end;

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvGraph_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetBitmapPixelFormat, 'GetBitmapPixelFormat', cdRegister);
 S.RegisterDelphiFunction(@GetPaletteBitmapFormat, 'GetPaletteBitmapFormat', cdRegister);
 S.RegisterDelphiFunction(@SetBitmapPixelFormat, 'SetBitmapPixelFormat', cdRegister);
 S.RegisterDelphiFunction(@BitmapToMemoryStream, 'BitmapToMemoryStream', cdRegister);
 S.RegisterDelphiFunction(@GrayscaleBitmap, 'GrayscaleBitmap', cdRegister);
 S.RegisterDelphiFunction(@BitmapToMemory, 'BitmapToMemory', cdRegister);
 S.RegisterDelphiFunction(@SaveBitmapToFile, 'SaveBitmapToFile', cdRegister);
 S.RegisterDelphiFunction(@ScreenPixelFormat, 'ScreenPixelFormat', cdRegister);
 S.RegisterDelphiFunction(@ScreenColorCount, 'ScreenColorCount', cdRegister);
 S.RegisterDelphiFunction(@TileImage, 'TileImage', cdRegister);
 S.RegisterDelphiFunction(@ZoomImage, 'ZoomImage', cdRegister);
 // RIRegister_TJvGradient(CL);
end;

 
 
{ TPSImport_JvGraph }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvGraph.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvGraph(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvGraph.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvGraph(ri);
  RIRegister_JvGraph_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
