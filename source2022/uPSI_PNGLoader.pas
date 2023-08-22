unit uPSI_PNGLoader;
{
  with routines
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
  TPSImport_PNGLoader = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPNGLoader(CL: TPSPascalCompiler);
procedure SIRegister_TMNGGraphic(CL: TPSPascalCompiler);
procedure SIRegister_TPNGGraphic(CL: TPSPascalCompiler);
procedure SIRegister_PNGLoader(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PNGLoader_Routines(S: TPSExec);
procedure RIRegister_TPNGLoader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMNGGraphic(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPNGGraphic(CL: TPSRuntimeClassImporter);
procedure RIRegister_PNGLoader(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,LinarBitmap
  ,Streams
  ,BufStream
  ,Graphics
  ,DelphiStream
  ,MemUtils
  ,CRC32Stream
  ,Deflate
  ,ColorMapper
  ,Monitor
  ,Math
  ,MathUtils
  ,MemStream
  ,PNGLoader
  ;
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_PNGLoader]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPNGLoader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBitmapLoader', 'TPNGLoader') do
  with CL.AddClassN(CL.FindClass('TBitmapLoader'),'TPNGLoader') do begin
    RegisterProperty('ExtraInfo', 'Boolean', iptrw);
    RegisterProperty('Palette', 'PPalette', iptrw);
    RegisterProperty('AlphaChannel', 'TLinearBitmap', iptrw);
    RegisterProperty('AlphaPalette', ' ^TAlphaPalette // will not work', iptrw);
    RegisterProperty('Gamma', 'Double', iptrw);
    RegisterProperty('TransparentColor', 'Integer', iptrw);
    RegisterProperty('BitsPerPixel', 'Integer', iptrw);
    RegisterProperty('ScanLineFilter', 'Integer', iptrw);
    RegisterProperty('QuantizationSteps', 'Integer', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure NewImage');
    RegisterMethod('Function CanLoad( const Ext : string) : Boolean');
    RegisterMethod('Function CanSave( const Ext : string) : Boolean');
    RegisterMethod('Procedure LoadFromStream( Stream : TSeekableStream; const Ext : string; Bitmap : TLinarBitmap)');
    RegisterMethod('Procedure SaveToStream( OutStream : TSeekableStream; const Ext : string; Bitmap : TLinarBitmap)');
    RegisterMethod('Procedure MakeAlphaChannelFromAlphaPalette( Source : TLinearBitmap)');
    RegisterMethod('Procedure MakeAlphaChannelFromColorKey( Source : TLinearBitmap; ColorKey : TColor)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMNGGraphic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TLinarGraphic', 'TMNGGraphic') do
  with CL.AddClassN(CL.FindClass('TLinarGraphic'),'TMNGGraphic') do begin
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPNGGraphic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TLinarGraphic', 'TPNGGraphic') do
  with CL.AddClassN(CL.FindClass('TLinarGraphic'),'TPNGGraphic') do begin
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PNGLoader(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('slfAutoMinSum','LongInt').SetInt( - 1);
 CL.AddConstantN('slfAutoMostRuns','LongInt').SetInt( - 2);
 CL.AddConstantN('slfAutoTryAll','LongInt').SetInt( - 3);
 CL.AddConstantN('slfNone','LongInt').SetInt( 0);
 CL.AddConstantN('slfSub','LongInt').SetInt( 1);
 CL.AddConstantN('slfUp','LongInt').SetInt( 2);
 CL.AddConstantN('slfAverage','LongInt').SetInt( 3);
 CL.AddConstantN('slfPaeth','LongInt').SetInt( 4);
  SIRegister_TPNGGraphic(CL);
  SIRegister_TMNGGraphic(CL);
  SIRegister_TPNGLoader(CL);
 CL.AddDelphiFunction('Function PaethPredictor( a, b, c : Byte) : Byte');
 CL.AddDelphiFunction('Function OptimizeForPNG( Image : TLinearBitmap; QuantizationSteps : Integer; TransparentColor : TColor) : Integer');
 CL.AddDelphiFunction('Procedure TransformRGB2LOCO( Image : TLinearBitmap)');
 CL.AddDelphiFunction('Procedure TransformLOCO2RGB( Image : TLinearBitmap)');
 //CL.AddDelphiFunction('Procedure SortPalette( const Pal : TPalette; var ColorMap : TColorMap)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPNGLoaderQuantizationSteps_W(Self: TPNGLoader; const T: Integer);
Begin Self.QuantizationSteps := T; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderQuantizationSteps_R(Self: TPNGLoader; var T: Integer);
Begin T := Self.QuantizationSteps; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderScanLineFilter_W(Self: TPNGLoader; const T: Integer);
Begin Self.ScanLineFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderScanLineFilter_R(Self: TPNGLoader; var T: Integer);
Begin T := Self.ScanLineFilter; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderBitsPerPixel_W(Self: TPNGLoader; const T: Integer);
Begin Self.BitsPerPixel := T; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderBitsPerPixel_R(Self: TPNGLoader; var T: Integer);
Begin T := Self.BitsPerPixel; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderTransparentColor_W(Self: TPNGLoader; const T: Integer);
Begin Self.TransparentColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderTransparentColor_R(Self: TPNGLoader; var T: Integer);
Begin T := Self.TransparentColor; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderGamma_W(Self: TPNGLoader; const T: Double);
Begin Self.Gamma := T; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderGamma_R(Self: TPNGLoader; var T: Double);
Begin T := Self.Gamma; end;

(*----------------------------------------------------------------------------*)
{procedure TPNGLoaderAlphaPalette_W(Self: TPNGLoader; const T:  ^TAlphaPalette // will not work);
Begin Self.AlphaPalette := T; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderAlphaPalette_R(Self: TPNGLoader; var T:  ^TAlphaPalette // will not work);
Begin T := Self.AlphaPalette; end;}

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderAlphaChannel_W(Self: TPNGLoader; const T: TLinearBitmap);
Begin Self.AlphaChannel := T; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderAlphaChannel_R(Self: TPNGLoader; var T: TLinearBitmap);
Begin T := Self.AlphaChannel; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderPalette_W(Self: TPNGLoader; const T: PPalette);
Begin Self.Palette := T; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderPalette_R(Self: TPNGLoader; var T: PPalette);
Begin T := Self.Palette; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderExtraInfo_W(Self: TPNGLoader; const T: Boolean);
Begin Self.ExtraInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TPNGLoaderExtraInfo_R(Self: TPNGLoader; var T: Boolean);
Begin T := Self.ExtraInfo; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PNGLoader_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PaethPredictor, 'PaethPredictor', cdRegister);
 S.RegisterDelphiFunction(@OptimizeForPNG, 'OptimizeForPNG', cdRegister);
 S.RegisterDelphiFunction(@TransformRGB2LOCO, 'TransformRGB2LOCO', cdRegister);
 S.RegisterDelphiFunction(@TransformLOCO2RGB, 'TransformLOCO2RGB', cdRegister);
 //S.RegisterDelphiFunction(@SortPalette, 'SortPalette', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPNGLoader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPNGLoader) do begin
    RegisterPropertyHelper(@TPNGLoaderExtraInfo_R,@TPNGLoaderExtraInfo_W,'ExtraInfo');
    RegisterPropertyHelper(@TPNGLoaderPalette_R,@TPNGLoaderPalette_W,'Palette');
    RegisterPropertyHelper(@TPNGLoaderAlphaChannel_R,@TPNGLoaderAlphaChannel_W,'AlphaChannel');
    //RegisterPropertyHelper(@TPNGLoaderAlphaPalette_R,@TPNGLoaderAlphaPalette_W,'AlphaPalette');
    RegisterPropertyHelper(@TPNGLoaderGamma_R,@TPNGLoaderGamma_W,'Gamma');
    RegisterPropertyHelper(@TPNGLoaderTransparentColor_R,@TPNGLoaderTransparentColor_W,'TransparentColor');
    RegisterPropertyHelper(@TPNGLoaderBitsPerPixel_R,@TPNGLoaderBitsPerPixel_W,'BitsPerPixel');
    RegisterPropertyHelper(@TPNGLoaderScanLineFilter_R,@TPNGLoaderScanLineFilter_W,'ScanLineFilter');
    RegisterPropertyHelper(@TPNGLoaderQuantizationSteps_R,@TPNGLoaderQuantizationSteps_W,'QuantizationSteps');
    RegisterConstructor(@TPNGLoader.Create, 'Create');
    RegisterMethod(@TPNGLoader.Destroy, 'Free');
    RegisterMethod(@TPNGLoader.NewImage, 'NewImage');
    RegisterMethod(@TPNGLoader.CanLoad, 'CanLoad');
    RegisterMethod(@TPNGLoader.CanSave, 'CanSave');
    RegisterMethod(@TPNGLoader.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TPNGLoader.SaveToStream, 'SaveToStream');
    RegisterMethod(@TPNGLoader.MakeAlphaChannelFromAlphaPalette, 'MakeAlphaChannelFromAlphaPalette');
    RegisterMethod(@TPNGLoader.MakeAlphaChannelFromColorKey, 'MakeAlphaChannelFromColorKey');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMNGGraphic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMNGGraphic) do
  begin
    RegisterMethod(@TMNGGraphic.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TMNGGraphic.SaveToStream, 'SaveToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPNGGraphic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPNGGraphic) do
  begin
    RegisterMethod(@TPNGGraphic.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TPNGGraphic.SaveToStream, 'SaveToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PNGLoader(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPNGGraphic(CL);
  RIRegister_TMNGGraphic(CL);
  RIRegister_TPNGLoader(CL);
end;

 
 
{ TPSImport_PNGLoader }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PNGLoader.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PNGLoader(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PNGLoader.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PNGLoader(ri);
  RIRegister_PNGLoader_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
