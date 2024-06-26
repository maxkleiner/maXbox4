unit uPSI_LinarBitmap;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
 a lot of work to set the inheritance to TPNGLoader et al. to TBitmapLoader, max
}
interface
 
uses
   SysUtils
  ,Classes
  ,Graphics
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_LinarBitmap = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 

{ compile-time registration functions }
procedure SIRegister_TBitmapLoaders(CL: TPSPascalCompiler);
procedure SIRegister_TLinearGraphic(CL: TPSPascalCompiler);
procedure SIRegister_TBitmapLoader(CL: TPSPascalCompiler);
procedure SIRegister_TLinearBitmap(CL: TPSPascalCompiler);
procedure SIRegister_LinarBitmap(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_LinarBitmap_Routines(S: TPSExec);
procedure RIRegister_TBitmapLoaders(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLinearGraphic(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBitmapLoader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLinearBitmap(CL: TPSRuntimeClassImporter);
procedure RIRegister_LinarBitmap(CL: TPSRuntimeClassImporter);

procedure Register;

procedure SaveCanvas2(vCanvas: TCanvas; FileName: string);


implementation


uses
   //Windows
  //,Graphics
  Streams
  ,DelphiStream
  //,MemUtils
  //,Math
  //,Monitor
  ,MathUtils
  ,LinarBitmap
  ,Types
  ,IdHTTP
  ,HTTPApp;
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_LinarBitmap]);
end;

{$IFNDEF LINUX}
procedure SaveCanvas2(vCanvas: TCanvas; FileName: string);
var
  Bmp: TBitmap;
  bmp1: TLinearBitmap;
  MyRect: TRect;
begin
  Bmp:= TBitmap.Create;
  bmp1:= TLinearBitmap.create;
  try
    MyRect:= vCanvas.ClipRect;
    Bmp.Width:= MyRect.Right - MyRect.Left;
    Bmp.Height:= MyRect.Bottom - MyRect.Top;
    Bmp.Canvas.CopyRect(MyRect, vCanvas, MyRect);
    bmp1.Assign(Bmp);
    Bmp1.SaveToFile(FileName);
  finally
    Bmp.Free;
    bmp1.Free;
  end;
end;

Const
   UrlGoogleQrCode='http://chart.apis.google.com/chart?chs=%dx%d&cht=qr&chld=%s&chl=%s';


function GetQrCode4(Width,Height: Word; Correct_Level: string;
           const Data:string; aformat: string): TLinearBitmap;
var
  encodedURL: string;
  idhttp: TIdHttp;// THTTPSend;
  png: TLinearBitmap;//TPNGObject;
  pngStream: TMemoryStream;
begin
  encodedURL:= Format(UrlGoogleQrCode,[Width,Height, Correct_Level, HTTPEncode(Data)]);
  //WinInet_HttpGet(EncodedURL,StreamImage);
  idHTTP:= TIdHTTP.Create(NIL);
  pngStream:= TMemoryStream.create;
  png:= TLinearBitmap.Create;
  with png do try
    idHTTP.Get(EncodedURL, pngStream);
    pngStream.Position:= 0;
    LoadFromStream(pngStream,aformat);
    //AssignTo(aimage.picture.bitmap);
    result:= png;
  finally
    //Dispose;
    //Free;
    idHTTP.Free;
    pngStream.Free;
  end;
end;


{$ENDIF}

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBitmapLoaders(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMonitorObject', 'TBitmapLoaders') do
  with CL.AddClassN(CL.FindClass('TMonitorObject'),'TBitmapLoaders') do begin
    RegisterProperty('Loaders', 'PBitmapLoaderList', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('MemCount', 'Integer', iptrw);
    RegisterMethod('Procedure AddLoader( Loader : TBitmapLoader)');
    RegisterMethod('Function GetLoader( Ext : string) : TBitmapLoader');
    RegisterMethod('Function GetSaver( Ext : string) : TBitmapLoader');
    RegisterMethod('Function GetLoadFilter : string');
    RegisterMethod('Function GetSaveFilter : string');
    RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLinearGraphic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphic', 'TLinearGraphic') do
  with CL.AddClassN(CL.FindClass('TGraphic'),'TLinearGraphic') do begin
    RegisterProperty('Bitmap', 'TLinearBitmap', iptr);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Draw( ACanvas : TCanvas; const Rect : TRect)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure LoadFromClipboardFormat( AFormat : Word; AData : THandle; APalette : HP)');
    RegisterMethod('Procedure SaveToClipboardFormat( var AFormat : Word; var AData : THandle; var APalette : HPALETTE)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBitmapLoader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMonitorObject', 'TBitmapLoader') do
  with CL.AddClassN(CL.FindClass('TMonitorObject'),'TBitmapLoader') do begin
    RegisterMethod('Function CanLoad( const Ext : string) : Boolean');
    RegisterMethod('Function CanSave( const Ext : string) : Boolean');
    RegisterMethod('Function GetLoadFilter : string');
    RegisterMethod('Function GetSaveFilter : string');
    RegisterMethod('Procedure LoadFromStream( Stream : TSeekableStream; const Ext : string; Bitmap : TLinearBitmap)');
    RegisterMethod('Procedure SaveToStream( Stream : TSeekableStream; const Ext : string; Bitmap : TLinearBitmap)');
    RegisterMethod('Procedure LoadFromFile( const FileName, FileType : string; Bitmap : TLinearBitmap)');
    RegisterMethod('Procedure SaveToFile( const FileName, FileType : string; Bitmap : TLinearBitmap)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLinearBitmap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAssignObject', 'TLinearBitmap') do
  with CL.AddClassN(CL.FindClass('TAssignObject'),'TLinearBitmap') do begin
    RegisterProperty('Map', 'PByteArray', iptrw);
    RegisterProperty('Palette', 'PPalette', iptrw);
    RegisterProperty('Width', 'Integer', iptr);
    RegisterProperty('Height', 'Integer', iptr);
    RegisterProperty('BytesPerLine', 'Integer', iptr);
    RegisterProperty('PixelFormat', 'TPixelFormat', iptrw);
    RegisterProperty('PixelSize', 'Integer', iptr);
    //RegisterProperty('ScanLine', 'Pointer Integer', iptr);
    //RegisterProperty('Pixel', 'Pointer Integer Integer', iptr);
    //SetDefaultPropery('Pixel');
    RegisterProperty('PixelColor', 'TColor Integer Integer', iptrw);
    RegisterProperty('Size', 'Integer', iptr);
    RegisterProperty('Present', 'Boolean', iptr);
    RegisterMethod('Constructor Create;');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Constructor Create1( Width, Height : Integer; PixFormat : TPixelFormat);');
    RegisterMethod('Constructor Create2( Other : TObject);');
    RegisterMethod('Procedure New( Width, Height : Integer; PixFormat : TPixelFormat)');
    RegisterMethod('Procedure Dispose');
    RegisterMethod('Procedure Clear( Value : Byte)');
    RegisterMethod('Procedure ClearColor( Color : TColor)');
    RegisterMethod('Procedure AssignTo( Other : TObject)');
    RegisterMethod('Procedure Assign( Other : TObject)');
    RegisterMethod('Procedure TakeOver( Other : TLinearBitmap)');
    RegisterMethod('Procedure OptimizeMem');
    RegisterMethod('Procedure CopyToClipboard');
    RegisterMethod('Function GetFromClipboard : Boolean');
    RegisterMethod('Procedure PasteImage( Source : TLinearBitmap; X, Y : Integer)');
    RegisterMethod('Function LoadFromFile( const FileName : string) : TBitmapLoader');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure LoadFromStream1( Stream : TSeekableStream; const FormatExt : string);');
    RegisterMethod('Procedure LoadFromStream2( Stream : TStream; const FormatExt : string);');
    RegisterMethod('Procedure SaveToStream1( Stream : TSeekableStream; const FormatExt : string);');
    RegisterMethod('Procedure SaveToStream2( Stream : TStream; const FormatExt : string);');
    RegisterMethod('Function IsGrayScale : Boolean');
    RegisterMethod('Procedure ResizeCanvas( XSiz, YSiz, XPos, YPos : Integer; Color : TColor)');
    RegisterMethod('Procedure GetFromDIB( var DIB : TBitmapInfo)');
    RegisterMethod('Procedure GetFromHDIB( HDIB : HBitmap)');
    RegisterMethod('Function MakeDIB( out Bitmap : PBitmapInfo) : Integer');
    RegisterMethod('Procedure PaintToCanvas( Canvas : TCanvas; const Dest : TRect; HalftoneStretch : Boolean)');
    RegisterMethod('Procedure StretchDIBits( DC : THandle; const Dest : TRect; HalftoneStretch : Boolean)');
    RegisterMethod('Procedure PaintToTBitmap( Target : TBitmap)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_LinarBitmap(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBitmapLoader');
  SIRegister_TLinearBitmap(CL);
  CL.AddTypeS('TLinearBitmapArray', 'array of TLinearBitmap');
  CL.AddTypeS('TLinarBitmap', 'TLinearBitmap');
  SIRegister_TBitmapLoader(CL);
  SIRegister_TLinearGraphic(CL);
  CL.AddTypeS('TLinarGraphic', 'TLinearGraphic');
  //CL.AddTypeS('PBitmapLoaderList', '^TBitmapLoaderList // will not work');
  SIRegister_TBitmapLoaders(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ELinearBitmap');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EUnsupportedFileFormat');
  CL.AddTypeS('TProgressUpdate', 'Procedure ( Done : Integer)');
 //CL.AddDelphiFunction('Function GrayPix24( Level : Byte) : RGBRec');
 CL.AddDelphiFunction('Function RGB2BGR( const Color : TColor) : TColor');
 CL.AddDelphiFunction('Function RGB2TColor( R, G, B : Byte) : TColor');
 //CL.AddDelphiFunction('Function GetRGBRec1( R, G, B : Byte) : RGBRec;');
 //CL.AddDelphiFunction('Function GetRGBRec2( Color : TColor) : RGBRec;');
 //CL.AddDelphiFunction('Procedure MakeLogPalette( const Pal : TPalette; var PalEntries, ColorCount : Integer)');
 //CL.AddDelphiFunction('Function MakeHPalette( const Pal : TPalette; ColorCount : Integer) : HPALETTE');
 //CL.AddDelphiFunction('Function GetFromRGBPalette( var Pal) : TPalette');
 //CL.AddDelphiFunction('Function GetFromHPalette( const HPal : HPALETTE; ColorCount : Integer) : TPalette');
 //CL.AddDelphiFunction('Function BestColorMatch( Color : TColor; const Palette : TPalette) : Byte');
 CL.AddDelphiFunction('Procedure AddLoader( Loader : TBitmapLoader)');
 CL.AddDelphiFunction('Procedure DrawHDIBToTBitmap( HDIB : THandle; Bitmap : TBitmap)');
 //CL.AddDelphiFunction('Procedure DrawDIBToTBitmap( var DIB : TBitmapInfo; Bitmap : TBitmap)');
 CL.AddDelphiFunction('Procedure MakeGrayPal( var Palette, ColorCount : Integer)');
 //CL.AddDelphiFunction('Procedure DeInterleave( Image : TLinearBitmap; Source : PByteArray; Planes : Integer)');
 CL.AddDelphiFunction('Function ExtractFileExtNoDotUpper( const FileName : string) : string');
 CL.AddDelphiFunction('function GetQrCode4(Width,Height: Word; Correct_Level: string;'+
          'const Data:string; aformat: string): TLinearBitmap;');
 CL.AddDelphiFunction('function GetQrCodetoFile(Width,Height: Word; Correct_Level: string;'+
          'const Data:string; aformat: string): TLinearBitmap;');
 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function GetRGBRec2_P( Color : TColor) : RGBRec;
Begin Result := LinarBitmap.GetRGBRec(Color); END;

(*----------------------------------------------------------------------------*)
Function GetRGBRec1_P( R, G, B : Byte) : RGBRec;
Begin Result := LinarBitmap.GetRGBRec(R, G, B); END;

(*----------------------------------------------------------------------------*)
procedure TBitmapLoadersMemCount_W(Self: TBitmapLoaders; const T: Integer);
Begin Self.MemCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapLoadersMemCount_R(Self: TBitmapLoaders; var T: Integer);
Begin T := Self.MemCount; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapLoadersCount_W(Self: TBitmapLoaders; const T: Integer);
Begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapLoadersCount_R(Self: TBitmapLoaders; var T: Integer);
Begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapLoadersLoaders_W(Self: TBitmapLoaders; const T: PBitmapLoaderList);
Begin Self.Loaders := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapLoadersLoaders_R(Self: TBitmapLoaders; var T: PBitmapLoaderList);
Begin T := Self.Loaders; end;

(*----------------------------------------------------------------------------*)
procedure TLinearGraphicBitmap_R(Self: TLinearGraphic; var T: TLinearBitmap);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
Procedure TLinearBitmapSaveToStream2_P(Self: TLinearBitmap;  Stream : TStream; const FormatExt : string);
Begin Self.SaveToStream(Stream, FormatExt); END;

(*----------------------------------------------------------------------------*)
Procedure TLinearBitmapSaveToStream1_P(Self: TLinearBitmap;  Stream : TSeekableStream; const FormatExt : string);
Begin Self.SaveToStream(Stream, FormatExt); END;

(*----------------------------------------------------------------------------*)
Procedure TLinearBitmapLoadFromStream2_P(Self: TLinearBitmap;  Stream : TStream; const FormatExt : string);
Begin Self.LoadFromStream(Stream, FormatExt); END;

(*----------------------------------------------------------------------------*)
Procedure TLinearBitmapLoadFromStream1_P(Self: TLinearBitmap;  Stream : TSeekableStream; const FormatExt : string);
Begin Self.LoadFromStream(Stream, FormatExt); END;

(*----------------------------------------------------------------------------*)
Function TLinearBitmapCreate2_P(Self: TClass; CreateNewInstance: Boolean;  Other : TObject):TObject;
Begin Result := TLinearBitmap.Create(Other); END;

(*----------------------------------------------------------------------------*)
Function TLinearBitmapCreate1_P(Self: TClass; CreateNewInstance: Boolean;  Width, Height : Integer; PixFormat : TPixelFormat):TObject;
Begin Result := TLinearBitmap.Create(Width, Height, PixFormat); END;

(*----------------------------------------------------------------------------*)
Function TLinearBitmapCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TLinearBitmap.Create; END;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapPresent_R(Self: TLinearBitmap; var T: Boolean);
begin T := Self.Present; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapSize_R(Self: TLinearBitmap; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapPixelColor_W(Self: TLinearBitmap; const T: TColor; const t1: Integer; const t2: Integer);
begin Self.PixelColor[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapPixelColor_R(Self: TLinearBitmap; var T: TColor; const t1: Integer; const t2: Integer);
begin T := Self.PixelColor[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapPixel_R(Self: TLinearBitmap; var T: Pointer; const t1: Integer; const t2: Integer);
begin T := Self.Pixel[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapScanLine_R(Self: TLinearBitmap; var T: Pointer; const t1: Integer);
begin T := Self.ScanLine[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapPixelSize_R(Self: TLinearBitmap; var T: Integer);
begin T := Self.PixelSize; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapPixelFormat_W(Self: TLinearBitmap; const T: TPixelFormat);
begin Self.PixelFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapPixelFormat_R(Self: TLinearBitmap; var T: TPixelFormat);
begin T := Self.PixelFormat; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapBytesPerLine_R(Self: TLinearBitmap; var T: Integer);
begin T := Self.BytesPerLine; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapHeight_R(Self: TLinearBitmap; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapWidth_R(Self: TLinearBitmap; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapPalette_W(Self: TLinearBitmap; const T: PPalette);
Begin Self.Palette := T; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapPalette_R(Self: TLinearBitmap; var T: PPalette);
Begin T := Self.Palette; end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapMap_W(Self: TLinearBitmap; const T: PByteArray);
Begin
  //Self.Map := T;
end;

(*----------------------------------------------------------------------------*)
procedure TLinearBitmapMap_R(Self: TLinearBitmap; var T: PByteArray);
Begin
 //T := Self.Map;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_LinarBitmap_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GrayPix24, 'GrayPix24', cdRegister);
 S.RegisterDelphiFunction(@RGB2BGR, 'RGB2BGR', cdRegister);
 S.RegisterDelphiFunction(@RGB2TColor, 'RGB2TColor', cdRegister);
 S.RegisterDelphiFunction(@GetRGBRec1_P, 'GetRGBRec1', cdRegister);
 S.RegisterDelphiFunction(@GetRGBRec2_P, 'GetRGBRec2', cdRegister);
 S.RegisterDelphiFunction(@MakeLogPalette, 'MakeLogPalette', cdRegister);
 S.RegisterDelphiFunction(@MakeHPalette, 'MakeHPalette', cdRegister);
 S.RegisterDelphiFunction(@GetFromRGBPalette, 'GetFromRGBPalette', cdRegister);
 S.RegisterDelphiFunction(@GetFromHPalette, 'GetFromHPalette', cdRegister);
 S.RegisterDelphiFunction(@BestColorMatch, 'BestColorMatch', cdRegister);
 S.RegisterDelphiFunction(@AddLoader, 'AddLoader', cdRegister);
 S.RegisterDelphiFunction(@DrawHDIBToTBitmap, 'DrawHDIBToTBitmap', cdRegister);
 S.RegisterDelphiFunction(@DrawDIBToTBitmap, 'DrawDIBToTBitmap', cdRegister);
 S.RegisterDelphiFunction(@MakeGrayPal, 'MakeGrayPal', cdRegister);
 S.RegisterDelphiFunction(@DeInterleave, 'DeInterleave', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExtNoDotUpper, 'ExtractFileExtNoDotUpper', cdRegister);
 S.RegisterDelphiFunction(@GetQrCode4, 'GetQrCode4', cdRegister);
 S.RegisterDelphiFunction(@GetQrCode4, 'GetQrCodetoFile', cdRegister);
 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBitmapLoaders(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBitmapLoaders) do
  begin
    RegisterPropertyHelper(@TBitmapLoadersLoaders_R,@TBitmapLoadersLoaders_W,'Loaders');
    RegisterPropertyHelper(@TBitmapLoadersCount_R,@TBitmapLoadersCount_W,'Count');
    RegisterPropertyHelper(@TBitmapLoadersMemCount_R,@TBitmapLoadersMemCount_W,'MemCount');
    RegisterMethod(@TBitmapLoaders.AddLoader, 'AddLoader');
    RegisterMethod(@TBitmapLoaders.GetLoader, 'GetLoader');
    RegisterMethod(@TBitmapLoaders.GetSaver, 'GetSaver');
    RegisterMethod(@TBitmapLoaders.GetLoadFilter, 'GetLoadFilter');
    RegisterMethod(@TBitmapLoaders.GetSaveFilter, 'GetSaveFilter');
    RegisterMethod(@TBitmapLoaders.Free, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLinearGraphic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLinearGraphic) do
  begin
    RegisterPropertyHelper(@TLinearGraphicBitmap_R,nil,'Bitmap');
    RegisterConstructor(@TLinearGraphic.Create, 'Create');
    RegisterVirtualMethod(@TLinearGraphic.Free, 'Free');
    // is protected so we have to change the orig class
    RegisterMethod(@TLinearGraphic.Draw, 'Draw');
    RegisterMethod(@TLinearGraphic.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TLinearGraphic.SaveToStream, 'SaveToStream');
    RegisterMethod(@TLinearGraphic.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TLinearGraphic.SaveToFile, 'SaveToFile');
    RegisterMethod(@TLinearGraphic.LoadFromClipboardFormat, 'LoadFromClipboardFormat');
    RegisterMethod(@TLinearGraphic.SaveToClipboardFormat, 'SaveToClipboardFormat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBitmapLoader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBitmapLoader) do
  begin
    RegisterVirtualMethod(@TBitmapLoader.CanLoad, 'CanLoad');
    RegisterVirtualMethod(@TBitmapLoader.CanSave, 'CanSave');
    RegisterVirtualMethod(@TBitmapLoader.GetLoadFilter, 'GetLoadFilter');
    RegisterVirtualMethod(@TBitmapLoader.GetSaveFilter, 'GetSaveFilter');
    RegisterVirtualMethod(@TBitmapLoader.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TBitmapLoader.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TBitmapLoader.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TBitmapLoader.SaveToFile, 'SaveToFile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLinearBitmap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLinearBitmap) do
  begin
    RegisterPropertyHelper(@TLinearBitmapMap_R,@TLinearBitmapMap_W,'Map');
    RegisterPropertyHelper(@TLinearBitmapPalette_R,@TLinearBitmapPalette_W,'Palette');
    RegisterPropertyHelper(@TLinearBitmapWidth_R,nil,'Width');
    RegisterPropertyHelper(@TLinearBitmapHeight_R,nil,'Height');
    RegisterPropertyHelper(@TLinearBitmapBytesPerLine_R,nil,'BytesPerLine');
    RegisterPropertyHelper(@TLinearBitmapPixelFormat_R,@TLinearBitmapPixelFormat_W,'PixelFormat');
    RegisterPropertyHelper(@TLinearBitmapPixelSize_R,nil,'PixelSize');
    RegisterPropertyHelper(@TLinearBitmapScanLine_R,nil,'ScanLine');
    RegisterPropertyHelper(@TLinearBitmapPixel_R,nil,'Pixel');
    RegisterPropertyHelper(@TLinearBitmapPixelColor_R,@TLinearBitmapPixelColor_W,'PixelColor');
    RegisterPropertyHelper(@TLinearBitmapSize_R,nil,'Size');
    RegisterPropertyHelper(@TLinearBitmapPresent_R,nil,'Present');
    RegisterConstructor(@TLinearBitmapCreate_P, 'Create');
    RegisterConstructor(@TLinearBitmapCreate1_P, 'Create1');
    RegisterConstructor(@TLinearBitmapCreate2_P, 'Create2');
    RegisterMethod(@TLinearBitmap.New, 'New');
    RegisterVirtualMethod(@TLinearBitmap.Dispose, 'Dispose');
    RegisterMethod(@TLinearBitmap.Clear, 'Clear');
    RegisterMethod(@TLinearBitmap.Destroy, 'Free');
    RegisterMethod(@TLinearBitmap.ClearColor, 'ClearColor');
    RegisterMethod(@TLinearBitmap.AssignTo, 'AssignTo');
    RegisterMethod(@TLinearBitmap.Assign, 'Assign');
    RegisterMethod(@TLinearBitmap.TakeOver, 'TakeOver');
    RegisterVirtualMethod(@TLinearBitmap.OptimizeMem, 'OptimizeMem');
    RegisterMethod(@TLinearBitmap.CopyToClipboard, 'CopyToClipboard');
    RegisterMethod(@TLinearBitmap.GetFromClipboard, 'GetFromClipboard');
    RegisterMethod(@TLinearBitmap.PasteImage, 'PasteImage');
    RegisterMethod(@TLinearBitmap.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TLinearBitmap.SaveToFile, 'SaveToFile');
    RegisterMethod(@TLinearBitmapLoadFromStream1_P, 'LoadFromStream1');
    RegisterMethod(@TLinearBitmapLoadFromStream2_P, 'LoadFromStream2');
    RegisterMethod(@TLinearBitmapSaveToStream1_P, 'SaveToStream1');
    RegisterMethod(@TLinearBitmapSaveToStream2_P, 'SaveToStream2');
    RegisterMethod(@TLinearBitmap.IsGrayScale, 'IsGrayScale');
    RegisterMethod(@TLinearBitmap.ResizeCanvas, 'ResizeCanvas');
    RegisterMethod(@TLinearBitmap.GetFromDIB, 'GetFromDIB');
    RegisterMethod(@TLinearBitmap.GetFromHDIB, 'GetFromHDIB');
    RegisterMethod(@TLinearBitmap.MakeDIB, 'MakeDIB');
    RegisterMethod(@TLinearBitmap.PaintToCanvas, 'PaintToCanvas');
    RegisterMethod(@TLinearBitmap.StretchDIBits, 'StretchDIBits');
    RegisterMethod(@TLinearBitmap.PaintToTBitmap, 'PaintToTBitmap');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_LinarBitmap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBitmapLoader) do
  RIRegister_TLinearBitmap(CL);
  RIRegister_TBitmapLoader(CL);
  RIRegister_TLinearGraphic(CL);
  RIRegister_TBitmapLoaders(CL);
  with CL.Add(ELinearBitmap) do
  with CL.Add(EUnsupportedFileFormat) do
end;

 
 
{ TPSImport_LinarBitmap }
(*----------------------------------------------------------------------------*)
procedure TPSImport_LinarBitmap.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_LinarBitmap(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_LinarBitmap.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_LinarBitmap(ri);
  RIRegister_LinarBitmap_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
