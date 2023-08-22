unit uPSI_jpeg;
{
  from VCL
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
  TPSImport_jpeg = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJPEGImage(CL: TPSPascalCompiler);
procedure SIRegister_TJPEGData(CL: TPSPascalCompiler);
procedure SIRegister_jpeg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJPEGImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJPEGData(CL: TPSRuntimeClassImporter);
procedure RIRegister_jpeg(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,jpeg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_jpeg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJPEGImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphic', 'TJPEGImage') do
  with CL.AddClassN(CL.FindClass('TGraphic'),'TJPEGImage') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Compress');
    RegisterMethod('Procedure DIBNeeded');
    RegisterMethod('Procedure JPEGNeeded');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromClipboardFormat( AFormat : Word; AData : THandle; APalette : HPALETTE)');
    RegisterMethod('Procedure SaveToClipboardFormat( var AFormat : Word; var AData : THandle; var APalette : HPALETTE)');
    RegisterProperty('Grayscale', 'Boolean', iptrw);
    RegisterProperty('ProgressiveEncoding', 'Boolean', iptrw);
    RegisterProperty('CompressionQuality', 'TJPEGQualityRange', iptrw);
    RegisterProperty('PixelFormat', 'TJPEGPixelFormat', iptrw);
    RegisterProperty('ProgressiveDisplay', 'Boolean', iptrw);
    RegisterProperty('Performance', 'TJPEGPerformance', iptrw);
    RegisterProperty('Scale', 'TJPEGScale', iptrw);
    RegisterProperty('Smoothing', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJPEGData(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSharedImage', 'TJPEGData') do
  with CL.AddClassN(CL.FindClass('TSharedImage'),'TJPEGData') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_jpeg(CL: TPSPascalCompiler);
begin
  SIRegister_TJPEGData(CL);
  CL.AddTypeS('TJPEGQualityRange', 'Integer');
  CL.AddTypeS('TJPEGPerformance', '( jpBestQuality, jpBestSpeed )');
  CL.AddTypeS('TJPEGScale', '( jsFullSize, jsHalf, jsQuarter, jsEighth )');
  CL.AddTypeS('TJPEGPixelFormat', '( jf24Bit, jf8Bit )');
  SIRegister_TJPEGImage(CL);
  CL.AddTypeS('TJPEGDefaults', 'record CompressionQuality : TJPEGQualityRange; '
   +'Grayscale : Boolean; Performance : TJPEGPerformance; PixelFormat : TJPEGPi'
   +'xelFormat; ProgressiveDisplay : Boolean; ProgressiveEncoding : Boolean; Sc'
   +'ale : TJPEGScale; Smoothing : Boolean; end');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJPEGImageSmoothing_W(Self: TJPEGImage; const T: Boolean);
begin Self.Smoothing := T; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImageSmoothing_R(Self: TJPEGImage; var T: Boolean);
begin T := Self.Smoothing; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImageScale_W(Self: TJPEGImage; const T: TJPEGScale);
begin Self.Scale := T; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImageScale_R(Self: TJPEGImage; var T: TJPEGScale);
begin T := Self.Scale; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImagePerformance_W(Self: TJPEGImage; const T: TJPEGPerformance);
begin Self.Performance := T; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImagePerformance_R(Self: TJPEGImage; var T: TJPEGPerformance);
begin T := Self.Performance; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImageProgressiveDisplay_W(Self: TJPEGImage; const T: Boolean);
begin Self.ProgressiveDisplay := T; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImageProgressiveDisplay_R(Self: TJPEGImage; var T: Boolean);
begin T := Self.ProgressiveDisplay; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImagePixelFormat_W(Self: TJPEGImage; const T: TJPEGPixelFormat);
begin Self.PixelFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImagePixelFormat_R(Self: TJPEGImage; var T: TJPEGPixelFormat);
begin T := Self.PixelFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImageCompressionQuality_W(Self: TJPEGImage; const T: TJPEGQualityRange);
begin Self.CompressionQuality := T; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImageCompressionQuality_R(Self: TJPEGImage; var T: TJPEGQualityRange);
begin T := Self.CompressionQuality; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImageProgressiveEncoding_W(Self: TJPEGImage; const T: Boolean);
begin Self.ProgressiveEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImageProgressiveEncoding_R(Self: TJPEGImage; var T: Boolean);
begin T := Self.ProgressiveEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImageGrayscale_W(Self: TJPEGImage; const T: Boolean);
begin Self.Grayscale := T; end;

(*----------------------------------------------------------------------------*)
procedure TJPEGImageGrayscale_R(Self: TJPEGImage; var T: Boolean);
begin T := Self.Grayscale; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJPEGImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJPEGImage) do
  begin
    RegisterConstructor(@TJPEGImage.Create, 'Create');
    RegisterMethod(@TJPEGImage.Compress, 'Compress');
    RegisterMethod(@TJPEGImage.DIBNeeded, 'DIBNeeded');
    RegisterMethod(@TJPEGImage.JPEGNeeded, 'JPEGNeeded');
    RegisterMethod(@TJPEGImage.Assign, 'Assign');
    RegisterMethod(@TJPEGImage.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJPEGImage.SaveToStream, 'SaveToStream');
    RegisterMethod(@TJPEGImage.LoadFromClipboardFormat, 'LoadFromClipboardFormat');
    RegisterMethod(@TJPEGImage.SaveToClipboardFormat, 'SaveToClipboardFormat');
    RegisterPropertyHelper(@TJPEGImageGrayscale_R,@TJPEGImageGrayscale_W,'Grayscale');
    RegisterPropertyHelper(@TJPEGImageProgressiveEncoding_R,@TJPEGImageProgressiveEncoding_W,'ProgressiveEncoding');
    RegisterPropertyHelper(@TJPEGImageCompressionQuality_R,@TJPEGImageCompressionQuality_W,'CompressionQuality');
    RegisterPropertyHelper(@TJPEGImagePixelFormat_R,@TJPEGImagePixelFormat_W,'PixelFormat');
    RegisterPropertyHelper(@TJPEGImageProgressiveDisplay_R,@TJPEGImageProgressiveDisplay_W,'ProgressiveDisplay');
    RegisterPropertyHelper(@TJPEGImagePerformance_R,@TJPEGImagePerformance_W,'Performance');
    RegisterPropertyHelper(@TJPEGImageScale_R,@TJPEGImageScale_W,'Scale');
    RegisterPropertyHelper(@TJPEGImageSmoothing_R,@TJPEGImageSmoothing_W,'Smoothing');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJPEGData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJPEGData) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_jpeg(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJPEGData(CL);
  RIRegister_TJPEGImage(CL);
end;

 
 
{ TPSImport_jpeg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_jpeg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_jpeg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_jpeg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_jpeg(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
