unit uPSI_GR32;
{
  just a fight to win minesweeper
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
  TPSImport_GR32 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCustomResampler(CL: TPSPascalCompiler);
procedure SIRegister_TCustomSampler(CL: TPSPascalCompiler);
procedure SIRegister_TCustomBackend(CL: TPSPascalCompiler);
procedure SIRegister_TBitmap32(CL: TPSPascalCompiler);
procedure SIRegister_TCustomBitmap32(CL: TPSPascalCompiler);
procedure SIRegister_TCustomMap(CL: TPSPascalCompiler);
procedure SIRegister_GR32(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCustomResampler(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomSampler(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomBackend(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBitmap32(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomBitmap32(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_GR32_Routines(S: TPSExec);
procedure RIRegister_GR32(CL: TPSRuntimeClassImporter);


procedure Register;

implementation


uses
   //LCLIntf
  //,LCLType
  Types
  ,Controls
  ,Graphics
  ,Windows
  //,Messages
  ,GR32_System
  ,GR32
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GR32]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomResampler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSampler', 'TCustomResampler') do
  with CL.AddClassN(CL.FindClass('TCustomSampler'),'TCustomResampler') do begin
    RegisterMethod('Constructor Create2;');
    RegisterMethod('Constructor Create3( ABitmap : TCustomBitmap32);');
    RegisterProperty('Bitmap', 'TCustomBitmap32', iptrw);
    RegisterProperty('Width', 'TFloat', iptr);
    RegisterProperty('PixelAccessMode', 'TPixelAccessMode', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomSampler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNotifiablePersistent', 'TCustomSampler') do
  with CL.AddClassN(CL.FindClass('TNotifiablePersistent'),'TCustomSampler') do begin
    RegisterMethod('Function GetSampleInt( X, Y : Integer) : TColor32');
    RegisterMethod('Function GetSampleFixed( X, Y : TFixed) : TColor32');
    RegisterMethod('Function GetSampleFloat( X, Y : TFloat) : TColor32');
    RegisterMethod('Procedure PrepareSampling');
    RegisterMethod('Procedure FinalizeSampling');
    RegisterMethod('Function HasBounds : Boolean');
    RegisterMethod('Function GetSampleBounds : TFloatRect');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomBackend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThreadPersistent', 'TCustomBackend') do
  with CL.AddClassN(CL.FindClass('TThreadPersistent'),'TCustomBackend') do begin
    RegisterMethod('Constructor Create1( Owner : TCustomBitmap32);');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure ChangeSize( var Width, Height : Integer; NewWidth, NewHeight : Integer; ClearBuffer : Boolean)');
    RegisterProperty('OnChanging', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBitmap32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomBitmap32', 'TBitmap32') do
  with CL.AddClassN(CL.FindClass('TCustomBitmap32'),'TBitmap32') do begin
    RegisterMethod('Procedure DrawA( const DstRect, SrcRect : TRect; hSrc : Cardinal);');
    //RegisterMethod('Procedure Draw1( const DstRect, SrcRect : TRect; hSrc : HDC);');
   //RegisterMethod('Constructor Create');
   // RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function BoundsRect : TRect');
    RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure DrawTo( hDst : Cardinal; DstX, DstY : Integer);');
    RegisterMethod('Procedure DrawTo1( hDst : Cardinal; const DstRect, SrcRect : TRect);');
    RegisterMethod('Procedure TileTo( hDst : Cardinal; const DstRect, SrcRect : TRect)');
    RegisterMethod('Procedure DrawTo2( hDst : HDC; DstX, DstY : Integer);');
    RegisterMethod('Procedure DrawTo3( hDst : HDC; const DstRect, SrcRect : TRect);');
    RegisterMethod('Procedure TileTo( hDst : HDC; const DstRect, SrcRect : TRect)');
    RegisterMethod('Procedure UpdateFont');
    RegisterMethod('Procedure Textout( X, Y : Integer; const Text : String);');
    RegisterMethod('Procedure Textout1( X, Y : Integer; const ClipRect : TRect; const Text : String);');
    RegisterMethod('Procedure Textout2( DstRect : TRect; const Flags : Cardinal; const Text : String);');
    RegisterMethod('Function TextExtent( const Text : String) : TSize');
    RegisterMethod('Function TextHeight( const Text : String) : Integer');
    RegisterMethod('Function TextWidth( const Text : String) : Integer');
    RegisterMethod('Procedure RenderText( X, Y : Integer; const Text : String; AALevel : Integer; Color : TColor32)');
    RegisterMethod('Procedure TextoutW( X, Y : Integer; const Text : Widestring);');
    RegisterMethod('Procedure TextoutW1( X, Y : Integer; const ClipRect : TRect; const Text : Widestring);');
    RegisterMethod('Procedure TextoutW2( DstRect : TRect; const Flags : Cardinal; const Text : Widestring);');
    RegisterMethod('Function TextExtentW( const Text : Widestring) : TSize');
    RegisterMethod('Function TextHeightW( const Text : Widestring) : Integer');
    RegisterMethod('Function TextWidthW( const Text : Widestring) : Integer');
    RegisterMethod('Procedure RenderTextW( X, Y : Integer; const Text : Widestring; AALevel : Integer; Color : TColor32)');
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterMethod('Function CanvasAllocated : Boolean');
    RegisterMethod('Procedure DeleteCanvas');
    RegisterProperty('DrawMode', 'TDrawMode', iptrw);   // in custom
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('BitmapHandle', 'HBITMAP', iptr);
    RegisterProperty('BitmapInfo', 'TBitmapInfo', iptr);
    RegisterProperty('Handle', 'HDC', iptr);
    RegisterProperty('OnHandleChanged', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomBitmap32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMap', 'TCustomBitmap32') do
  with CL.AddClassN(CL.FindClass('TCustomMap'),'TCustomBitmap32') do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function BoundsRect : TRect');
    RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Clear1( FillColor : TColor32)');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Procedure BeginMeasuring( const Callback : TAreaChangedEvent)');
    RegisterMethod('Procedure EndMeasuring');
    RegisterMethod('Function ReleaseBackend : TCustomBackend');
    RegisterMethod('Procedure PropertyChanged');
    RegisterMethod('Procedure Changed1( const Area : TRect; const Info : Cardinal);');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream; SaveTopDown : Boolean)');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure SaveToFile( const FileName : string; SaveTopDown : Boolean)');
    RegisterMethod('Procedure LoadFromResourceID( Instance : THandle; ResID : Integer)');
    RegisterMethod('Procedure LoadFromResourceName( Instance : THandle; const ResName : string)');
    RegisterMethod('Procedure ResetAlpha;');
    RegisterMethod('Procedure ResetAlpha1( const AlphaValue : Byte);');
    RegisterMethod('Procedure Draw( DstX, DstY : Integer; Src : TCustomBitmap32);');
    RegisterMethod('Procedure Draw1( DstX, DstY : Integer; const SrcRect : TRect; Src : TCustomBitmap32);');
    RegisterMethod('Procedure Draw2( const DstRect, SrcRect : TRect; Src : TCustomBitmap32);');
    RegisterMethod('Procedure SetPixelT( X, Y : Integer; Value : TColor32);');
    RegisterMethod('Procedure SetPixelT1( var Ptr : PColor32; Value : TColor32);');
    RegisterMethod('Procedure SetPixelTS( X, Y : Integer; Value : TColor32)');
    RegisterMethod('Procedure DrawTo( Dst : TCustomBitmap32);');
    RegisterMethod('Procedure DrawTo1( Dst : TCustomBitmap32; DstX, DstY : Integer; const SrcRect : TRect);');
    RegisterMethod('Procedure DrawTo2( Dst : TCustomBitmap32; DstX, DstY : Integer);');
    RegisterMethod('Procedure DrawTo3( Dst : TCustomBitmap32; const DstRect : TRect);');
    RegisterMethod('Procedure DrawTo4( Dst : TCustomBitmap32; const DstRect, SrcRect : TRect);');
    RegisterMethod('Procedure SetStipple( NewStipple : TArrayOfColor32);');
    RegisterMethod('Procedure SetStipple1( NewStipple : array of TColor32);');
    RegisterMethod('Procedure AdvanceStippleCounter( LengthPixels : Single)');
    RegisterMethod('Function GetStippleColor : TColor32');
    RegisterMethod('Procedure HorzLine( X1, Y, X2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure HorzLineS( X1, Y, X2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure HorzLineT( X1, Y, X2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure HorzLineTS( X1, Y, X2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure HorzLineTSP( X1, Y, X2 : Integer)');
    RegisterMethod('Procedure HorzLineX( X1, Y, X2 : TFixed; Value : TColor32)');
    RegisterMethod('Procedure HorzLineXS( X1, Y, X2 : TFixed; Value : TColor32)');
    RegisterMethod('Procedure VertLine( X, Y1, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure VertLineS( X, Y1, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure VertLineT( X, Y1, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure VertLineTS( X, Y1, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure VertLineTSP( X, Y1, Y2 : Integer)');
    RegisterMethod('Procedure VertLineX( X, Y1, Y2 : TFixed; Value : TColor32)');
    RegisterMethod('Procedure VertLineXS( X, Y1, Y2 : TFixed; Value : TColor32)');
    RegisterMethod('Procedure Line( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure LineS( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure LineT( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure LineTS( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure LineA( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure LineAS( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure LineX( X1, Y1, X2, Y2 : TFixed; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure LineF( X1, Y1, X2, Y2 : Single; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure LineXS( X1, Y1, X2, Y2 : TFixed; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure LineFS( X1, Y1, X2, Y2 : Single; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure LineXP( X1, Y1, X2, Y2 : TFixed; L : Boolean)');
    RegisterMethod('Procedure LineFP( X1, Y1, X2, Y2 : Single; L : Boolean)');
    RegisterMethod('Procedure LineXSP( X1, Y1, X2, Y2 : TFixed; L : Boolean)');
    RegisterMethod('Procedure LineFSP( X1, Y1, X2, Y2 : Single; L : Boolean)');
    RegisterProperty('PenColor', 'TColor32', iptrw);
    RegisterMethod('Procedure MoveTo( X, Y : Integer)');
    RegisterMethod('Procedure LineToS( X, Y : Integer)');
    RegisterMethod('Procedure LineToTS( X, Y : Integer)');
    RegisterMethod('Procedure LineToAS( X, Y : Integer)');
    RegisterMethod('Procedure MoveToX( X, Y : TFixed)');
    RegisterMethod('Procedure MoveToF( X, Y : Single)');
    RegisterMethod('Procedure LineToXS( X, Y : TFixed)');
    RegisterMethod('Procedure LineToFS( X, Y : Single)');
    RegisterMethod('Procedure LineToXSP( X, Y : TFixed)');
    RegisterMethod('Procedure LineToFSP( X, Y : Single)');
    RegisterMethod('Procedure FillRect( X1, Y1, X2, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure FillRectS( X1, Y1, X2, Y2 : Integer; Value : TColor32);');
    RegisterMethod('Procedure FillRectT( X1, Y1, X2, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure FillRectTS( X1, Y1, X2, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure FillRectS( const ARect : TRect; Value : TColor32)');
    RegisterMethod('Procedure FillRectTS( const ARect : TRect; Value : TColor32)');
    RegisterMethod('Procedure FrameRectS( X1, Y1, X2, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure FrameRectTS( X1, Y1, X2, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure FrameRectTSP( X1, Y1, X2, Y2 : Integer)');
    RegisterMethod('Procedure FrameRectS( const ARect : TRect; Value : TColor32)');
    RegisterMethod('Procedure FrameRectTS( const ARect : TRect; Value : TColor32)');
    RegisterMethod('Procedure RaiseRectTS( X1, Y1, X2, Y2 : Integer; Contrast : Integer);');
    RegisterMethod('Procedure RaiseRectTS1( const ARect : TRect; Contrast : Integer);');
    RegisterMethod('Procedure Roll( Dx, Dy : Integer; FillBack : Boolean; FillColor : TColor32)');
    RegisterMethod('Procedure FlipHorz( Dst : TCustomBitmap32)');
    RegisterMethod('Procedure FlipVert( Dst : TCustomBitmap32)');
    RegisterMethod('Procedure Rotate90( Dst : TCustomBitmap32)');
    RegisterMethod('Procedure Rotate180( Dst : TCustomBitmap32)');
    RegisterMethod('Procedure Rotate270( Dst : TCustomBitmap32)');
    RegisterMethod('Procedure ResetClipRect');
    RegisterProperty('Pixel', 'TColor32 Integer Integer', iptrw);
    SetDefaultPropery('Pixel');
    RegisterProperty('PixelS', 'TColor32 Integer Integer', iptrw);
    RegisterProperty('PixelW', 'TColor32 Integer Integer', iptrw);
    RegisterProperty('PixelX', 'TColor32 TFixed TFixed', iptrw);
    RegisterProperty('PixelXS', 'TColor32 TFixed TFixed', iptrw);
    RegisterProperty('PixelXW', 'TColor32 TFixed TFixed', iptrw);
    RegisterProperty('PixelF', 'TColor32 Single Single', iptrw);
    RegisterProperty('PixelFS', 'TColor32 Single Single', iptrw);
    RegisterProperty('PixelFW', 'TColor32 Single Single', iptrw);
    RegisterProperty('PixelFR', 'TColor32 Single Single', iptr);
    RegisterProperty('PixelXR', 'TColor32 TFixed TFixed', iptr);
    RegisterProperty('Backend', 'TCustomBackend', iptrw);
    RegisterProperty('DrawMode', 'TDrawMode', iptrw);
    RegisterProperty('CombineMode', 'TCombineMode', iptrw);
    RegisterProperty('WrapMode', 'TWrapMode', iptrw);
    RegisterProperty('MasterAlpha', 'Cardinal', iptrw);
    RegisterProperty('OuterColor', 'TColor32', iptrw);
    RegisterProperty('StretchFilter', 'TStretchFilter', iptrw);
    RegisterProperty('ResamplerClassName', 'string', iptrw);
    RegisterProperty('Resampler', 'TCustomResampler', iptrw);
    RegisterProperty('OnPixelCombine', 'TPixelCombineEvent', iptrw);
    RegisterProperty('OnAreaChanged', 'TAreaChangedEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThreadPersistent', 'TCustomMap') do
  with CL.AddClassN(CL.FindClass('TThreadPersistent'),'TCustomMap') do begin
    RegisterMethod('Procedure Delete');
    RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure Resized');
    RegisterMethod('Function SetSizeFrom( Source : TPersistent) : Boolean');
    RegisterMethod('Function SetSize( NewWidth, NewHeight : Integer) : Boolean');
    RegisterMethod('procedure Changed');
    RegisterMethod('procedure BeginUpdate');
    RegisterMethod('procedure EndUpdate;');
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('OnResize', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GR32(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('Graphics32Version','String').SetString( '1.9.1');
 // CL.AddTypeS('PColor32', '^TColor32 // will not work');
  CL.AddTypeS('TColor32', 'Cardinal');
 // CL.AddTypeS('PColor32Array', '^TColor32Array // will not work');
  CL.AddTypeS('TArrayOfColor32', 'array of TColor32');
  CL.AddTypeS('TColor32Component', '( ccBlue, ccGreen, ccRed, ccAlpha )');
  CL.AddTypeS('TColor32Components', 'set of TColor32Component');
 // CL.AddTypeS('PColor32EntryArray', '^TColor32EntryArray // will not work');
  //CL.AddTypeS('TArrayOfColor32Entry', 'array of TColor32Entry');
 // CL.AddTypeS('PPalette32', '^TPalette32 // will not work');
 CL.AddConstantN('clBlack32','LongWord').SetUInt( TColor32 ( $FF000000 ));
 CL.AddConstantN('clDimGray32','LongWord').SetUInt( TColor32 ( $FF3F3F3F ));
 CL.AddConstantN('clGray32','LongWord').SetUInt( TColor32 ( $FF7F7F7F ));
 CL.AddConstantN('clLightGray32','LongWord').SetUInt( TColor32 ( $FFBFBFBF ));
 CL.AddConstantN('clWhite32','LongWord').SetUInt( TColor32 ( $FFFFFFFF ));
 CL.AddConstantN('clMaroon32','LongWord').SetUInt( TColor32 ( $FF7F0000 ));
 CL.AddConstantN('clGreen32','LongWord').SetUInt( TColor32 ( $FF007F00 ));
 CL.AddConstantN('clOlive32','LongWord').SetUInt( TColor32 ( $FF7F7F00 ));
 CL.AddConstantN('clNavy32','LongWord').SetUInt( TColor32 ( $FF00007F ));
 CL.AddConstantN('clPurple32','LongWord').SetUInt( TColor32 ( $FF7F007F ));
 CL.AddConstantN('clTeal32','LongWord').SetUInt( TColor32 ( $FF007F7F ));
 CL.AddConstantN('clRed32','LongWord').SetUInt( TColor32 ( $FFFF0000 ));
 CL.AddConstantN('clLime32','LongWord').SetUInt( TColor32 ( $FF00FF00 ));
 CL.AddConstantN('clYellow32','LongWord').SetUInt( TColor32 ( $FFFFFF00 ));
 CL.AddConstantN('clBlue32','LongWord').SetUInt( TColor32 ( $FF0000FF ));
 CL.AddConstantN('clFuchsia32','LongWord').SetUInt( TColor32 ( $FFFF00FF ));
 CL.AddConstantN('clAqua32','LongWord').SetUInt( TColor32 ( $FF00FFFF ));
 CL.AddConstantN('clAliceBlue32','LongWord').SetUInt( TColor32 ( $FFF0F8FF ));
 CL.AddConstantN('clAntiqueWhite32','LongWord').SetUInt( TColor32 ( $FFFAEBD7 ));
 CL.AddConstantN('clAquamarine32','LongWord').SetUInt( TColor32 ( $FF7FFFD4 ));
 CL.AddConstantN('clAzure32','LongWord').SetUInt( TColor32 ( $FFF0FFFF ));
 CL.AddConstantN('clBeige32','LongWord').SetUInt( TColor32 ( $FFF5F5DC ));
 CL.AddConstantN('clBisque32','LongWord').SetUInt( TColor32 ( $FFFFE4C4 ));
 CL.AddConstantN('clBlancheDalmond32','LongWord').SetUInt( TColor32 ( $FFFFEBCD ));
 CL.AddConstantN('clBlueViolet32','LongWord').SetUInt( TColor32 ( $FF8A2BE2 ));
 CL.AddConstantN('clBrown32','LongWord').SetUInt( TColor32 ( $FFA52A2A ));
 CL.AddConstantN('clBurlyWood32','LongWord').SetUInt( TColor32 ( $FFDEB887 ));
 CL.AddConstantN('clCadetblue32','LongWord').SetUInt( TColor32 ( $FF5F9EA0 ));
 CL.AddConstantN('clChartReuse32','LongWord').SetUInt( TColor32 ( $FF7FFF00 ));
 CL.AddConstantN('clChocolate32','LongWord').SetUInt( TColor32 ( $FFD2691E ));
 CL.AddConstantN('clCoral32','LongWord').SetUInt( TColor32 ( $FFFF7F50 ));
 CL.AddConstantN('clCornFlowerBlue32','LongWord').SetUInt( TColor32 ( $FF6495ED ));
 CL.AddConstantN('clCornSilk32','LongWord').SetUInt( TColor32 ( $FFFFF8DC ));
 CL.AddConstantN('clCrimson32','LongWord').SetUInt( TColor32 ( $FFDC143C ));
 CL.AddConstantN('clDarkBlue32','LongWord').SetUInt( TColor32 ( $FF00008B ));
 CL.AddConstantN('clDarkCyan32','LongWord').SetUInt( TColor32 ( $FF008B8B ));
 CL.AddConstantN('clDarkGoldenRod32','LongWord').SetUInt( TColor32 ( $FFB8860B ));
 CL.AddConstantN('clDarkGray32','LongWord').SetUInt( TColor32 ( $FFA9A9A9 ));
 CL.AddConstantN('clDarkGreen32','LongWord').SetUInt( TColor32 ( $FF006400 ));
 CL.AddConstantN('clDarkGrey32','LongWord').SetUInt( TColor32 ( $FFA9A9A9 ));
 CL.AddConstantN('clDarkKhaki32','LongWord').SetUInt( TColor32 ( $FFBDB76B ));
 CL.AddConstantN('clDarkMagenta32','LongWord').SetUInt( TColor32 ( $FF8B008B ));
 CL.AddConstantN('clDarkOliveGreen32','LongWord').SetUInt( TColor32 ( $FF556B2F ));
 CL.AddConstantN('clDarkOrange32','LongWord').SetUInt( TColor32 ( $FFFF8C00 ));
 CL.AddConstantN('clDarkOrchid32','LongWord').SetUInt( TColor32 ( $FF9932CC ));
 CL.AddConstantN('clDarkRed32','LongWord').SetUInt( TColor32 ( $FF8B0000 ));
 CL.AddConstantN('clDarkSalmon32','LongWord').SetUInt( TColor32 ( $FFE9967A ));
 CL.AddConstantN('clDarkSeaGreen32','LongWord').SetUInt( TColor32 ( $FF8FBC8F ));
 CL.AddConstantN('clDarkSlateBlue32','LongWord').SetUInt( TColor32 ( $FF483D8B ));
 CL.AddConstantN('clDarkSlateGray32','LongWord').SetUInt( TColor32 ( $FF2F4F4F ));
 CL.AddConstantN('clDarkSlateGrey32','LongWord').SetUInt( TColor32 ( $FF2F4F4F ));
 CL.AddConstantN('clDarkTurquoise32','LongWord').SetUInt( TColor32 ( $FF00CED1 ));
 CL.AddConstantN('clDarkViolet32','LongWord').SetUInt( TColor32 ( $FF9400D3 ));
 CL.AddConstantN('clDeepPink32','LongWord').SetUInt( TColor32 ( $FFFF1493 ));
 CL.AddConstantN('clDeepSkyBlue32','LongWord').SetUInt( TColor32 ( $FF00BFFF ));
 CL.AddConstantN('clDodgerBlue32','LongWord').SetUInt( TColor32 ( $FF1E90FF ));
 CL.AddConstantN('clFireBrick32','LongWord').SetUInt( TColor32 ( $FFB22222 ));
 CL.AddConstantN('clFloralWhite32','LongWord').SetUInt( TColor32 ( $FFFFFAF0 ));
 CL.AddConstantN('clGainsBoro32','LongWord').SetUInt( TColor32 ( $FFDCDCDC ));
 CL.AddConstantN('clGhostWhite32','LongWord').SetUInt( TColor32 ( $FFF8F8FF ));
 CL.AddConstantN('clGold32','LongWord').SetUInt( TColor32 ( $FFFFD700 ));
 CL.AddConstantN('clGoldenRod32','LongWord').SetUInt( TColor32 ( $FFDAA520 ));
 CL.AddConstantN('clGreenYellow32','LongWord').SetUInt( TColor32 ( $FFADFF2F ));
 CL.AddConstantN('clGrey32','LongWord').SetUInt( TColor32 ( $FF808080 ));
 CL.AddConstantN('clHoneyDew32','LongWord').SetUInt( TColor32 ( $FFF0FFF0 ));
 CL.AddConstantN('clHotPink32','LongWord').SetUInt( TColor32 ( $FFFF69B4 ));
 CL.AddConstantN('clIndianRed32','LongWord').SetUInt( TColor32 ( $FFCD5C5C ));
 CL.AddConstantN('clIndigo32','LongWord').SetUInt( TColor32 ( $FF4B0082 ));
 CL.AddConstantN('clIvory32','LongWord').SetUInt( TColor32 ( $FFFFFFF0 ));
 CL.AddConstantN('clKhaki32','LongWord').SetUInt( TColor32 ( $FFF0E68C ));
 CL.AddConstantN('clLavender32','LongWord').SetUInt( TColor32 ( $FFE6E6FA ));
 CL.AddConstantN('clLavenderBlush32','LongWord').SetUInt( TColor32 ( $FFFFF0F5 ));
 CL.AddConstantN('clLawnGreen32','LongWord').SetUInt( TColor32 ( $FF7CFC00 ));
 CL.AddConstantN('clLemonChiffon32','LongWord').SetUInt( TColor32 ( $FFFFFACD ));
 CL.AddConstantN('clLightBlue32','LongWord').SetUInt( TColor32 ( $FFADD8E6 ));
 CL.AddConstantN('clLightCoral32','LongWord').SetUInt( TColor32 ( $FFF08080 ));
 CL.AddConstantN('clLightCyan32','LongWord').SetUInt( TColor32 ( $FFE0FFFF ));
 CL.AddConstantN('clLightGoldenRodYellow32','LongWord').SetUInt( TColor32 ( $FFFAFAD2 ));
 CL.AddConstantN('clLightGreen32','LongWord').SetUInt( TColor32 ( $FF90EE90 ));
 CL.AddConstantN('clLightGrey32','LongWord').SetUInt( TColor32 ( $FFD3D3D3 ));
 CL.AddConstantN('clLightPink32','LongWord').SetUInt( TColor32 ( $FFFFB6C1 ));
 CL.AddConstantN('clLightSalmon32','LongWord').SetUInt( TColor32 ( $FFFFA07A ));
 CL.AddConstantN('clLightSeagreen32','LongWord').SetUInt( TColor32 ( $FF20B2AA ));
 CL.AddConstantN('clLightSkyblue32','LongWord').SetUInt( TColor32 ( $FF87CEFA ));
 CL.AddConstantN('clLightSlategray32','LongWord').SetUInt( TColor32 ( $FF778899 ));
 CL.AddConstantN('clLightSlategrey32','LongWord').SetUInt( TColor32 ( $FF778899 ));
 CL.AddConstantN('clLightSteelblue32','LongWord').SetUInt( TColor32 ( $FFB0C4DE ));
 CL.AddConstantN('clLightYellow32','LongWord').SetUInt( TColor32 ( $FFFFFFE0 ));
 CL.AddConstantN('clLtGray32','LongWord').SetUInt( TColor32 ( $FFC0C0C0 ));
 CL.AddConstantN('clMedGray32','LongWord').SetUInt( TColor32 ( $FFA0A0A4 ));
 CL.AddConstantN('clDkGray32','LongWord').SetUInt( TColor32 ( $FF808080 ));
 CL.AddConstantN('clMoneyGreen32','LongWord').SetUInt( TColor32 ( $FFC0DCC0 ));
 CL.AddConstantN('clLegacySkyBlue32','LongWord').SetUInt( TColor32 ( $FFA6CAF0 ));
 CL.AddConstantN('clCream32','LongWord').SetUInt( TColor32 ( $FFFFFBF0 ));
 CL.AddConstantN('clLimeGreen32','LongWord').SetUInt( TColor32 ( $FF32CD32 ));
 CL.AddConstantN('clLinen32','LongWord').SetUInt( TColor32 ( $FFFAF0E6 ));
 CL.AddConstantN('clMediumAquamarine32','LongWord').SetUInt( TColor32 ( $FF66CDAA ));
 CL.AddConstantN('clMediumBlue32','LongWord').SetUInt( TColor32 ( $FF0000CD ));
 CL.AddConstantN('clMediumOrchid32','LongWord').SetUInt( TColor32 ( $FFBA55D3 ));
 CL.AddConstantN('clMediumPurple32','LongWord').SetUInt( TColor32 ( $FF9370DB ));
 CL.AddConstantN('clMediumSeaGreen32','LongWord').SetUInt( TColor32 ( $FF3CB371 ));
 CL.AddConstantN('clMediumSlateBlue32','LongWord').SetUInt( TColor32 ( $FF7B68EE ));
 CL.AddConstantN('clMediumSpringGreen32','LongWord').SetUInt( TColor32 ( $FF00FA9A ));
 CL.AddConstantN('clMediumTurquoise32','LongWord').SetUInt( TColor32 ( $FF48D1CC ));
 CL.AddConstantN('clMediumVioletRed32','LongWord').SetUInt( TColor32 ( $FFC71585 ));
 CL.AddConstantN('clMidnightBlue32','LongWord').SetUInt( TColor32 ( $FF191970 ));
 CL.AddConstantN('clMintCream32','LongWord').SetUInt( TColor32 ( $FFF5FFFA ));
 CL.AddConstantN('clMistyRose32','LongWord').SetUInt( TColor32 ( $FFFFE4E1 ));
 CL.AddConstantN('clMoccasin32','LongWord').SetUInt( TColor32 ( $FFFFE4B5 ));
 CL.AddConstantN('clNavajoWhite32','LongWord').SetUInt( TColor32 ( $FFFFDEAD ));
 CL.AddConstantN('clOldLace32','LongWord').SetUInt( TColor32 ( $FFFDF5E6 ));
 CL.AddConstantN('clOliveDrab32','LongWord').SetUInt( TColor32 ( $FF6B8E23 ));
 CL.AddConstantN('clOrange32','LongWord').SetUInt( TColor32 ( $FFFFA500 ));
 CL.AddConstantN('clOrangeRed32','LongWord').SetUInt( TColor32 ( $FFFF4500 ));
 CL.AddConstantN('clOrchid32','LongWord').SetUInt( TColor32 ( $FFDA70D6 ));
 CL.AddConstantN('clPaleGoldenRod32','LongWord').SetUInt( TColor32 ( $FFEEE8AA ));
 CL.AddConstantN('clPaleGreen32','LongWord').SetUInt( TColor32 ( $FF98FB98 ));
 CL.AddConstantN('clPaleTurquoise32','LongWord').SetUInt( TColor32 ( $FFAFEEEE ));
 CL.AddConstantN('clPaleVioletred32','LongWord').SetUInt( TColor32 ( $FFDB7093 ));
 CL.AddConstantN('clPapayaWhip32','LongWord').SetUInt( TColor32 ( $FFFFEFD5 ));
 CL.AddConstantN('clPeachPuff32','LongWord').SetUInt( TColor32 ( $FFFFDAB9 ));
 CL.AddConstantN('clPeru32','LongWord').SetUInt( TColor32 ( $FFCD853F ));
 CL.AddConstantN('clPlum32','LongWord').SetUInt( TColor32 ( $FFDDA0DD ));
 CL.AddConstantN('clPowderBlue32','LongWord').SetUInt( TColor32 ( $FFB0E0E6 ));
 CL.AddConstantN('clRosyBrown32','LongWord').SetUInt( TColor32 ( $FFBC8F8F ));
 CL.AddConstantN('clRoyalBlue32','LongWord').SetUInt( TColor32 ( $FF4169E1 ));
 CL.AddConstantN('clSaddleBrown32','LongWord').SetUInt( TColor32 ( $FF8B4513 ));
 CL.AddConstantN('clSalmon32','LongWord').SetUInt( TColor32 ( $FFFA8072 ));
 CL.AddConstantN('clSandyBrown32','LongWord').SetUInt( TColor32 ( $FFF4A460 ));
 CL.AddConstantN('clSeaGreen32','LongWord').SetUInt( TColor32 ( $FF2E8B57 ));
 CL.AddConstantN('clSeaShell32','LongWord').SetUInt( TColor32 ( $FFFFF5EE ));
 CL.AddConstantN('clSienna32','LongWord').SetUInt( TColor32 ( $FFA0522D ));
 CL.AddConstantN('clSilver32','LongWord').SetUInt( TColor32 ( $FFC0C0C0 ));
 CL.AddConstantN('clSkyblue32','LongWord').SetUInt( TColor32 ( $FF87CEEB ));
 CL.AddConstantN('clSlateBlue32','LongWord').SetUInt( TColor32 ( $FF6A5ACD ));
 CL.AddConstantN('clSlateGray32','LongWord').SetUInt( TColor32 ( $FF708090 ));
 CL.AddConstantN('clSlateGrey32','LongWord').SetUInt( TColor32 ( $FF708090 ));
 CL.AddConstantN('clSnow32','LongWord').SetUInt( TColor32 ( $FFFFFAFA ));
 CL.AddConstantN('clSpringgreen32','LongWord').SetUInt( TColor32 ( $FF00FF7F ));
 CL.AddConstantN('clSteelblue32','LongWord').SetUInt( TColor32 ( $FF4682B4 ));
 CL.AddConstantN('clTan32','LongWord').SetUInt( TColor32 ( $FFD2B48C ));
 CL.AddConstantN('clThistle32','LongWord').SetUInt( TColor32 ( $FFD8BFD8 ));
 CL.AddConstantN('clTomato32','LongWord').SetUInt( TColor32 ( $FFFF6347 ));
 CL.AddConstantN('clTurquoise32','LongWord').SetUInt( TColor32 ( $FF40E0D0 ));
 CL.AddConstantN('clViolet32','LongWord').SetUInt( TColor32 ( $FFEE82EE ));
 CL.AddConstantN('clWheat32','LongWord').SetUInt( TColor32 ( $FFF5DEB3 ));
 CL.AddConstantN('clWhitesmoke32','LongWord').SetUInt( TColor32 ( $FFF5F5F5 ));
 CL.AddConstantN('clYellowgreen32','LongWord').SetUInt( TColor32 ( $FF9ACD32 ));
 CL.AddConstantN('clTrWhite32','LongWord').SetUInt( TColor32 ( $7FFFFFFF ));
 CL.AddConstantN('clTrBlack32','LongWord').SetUInt( TColor32 ( $7F000000 ));
 CL.AddConstantN('clTrRed32','LongWord').SetUInt( TColor32 ( $7FFF0000 ));
 CL.AddConstantN('clTrGreen32','LongWord').SetUInt( TColor32 ( $7F00FF00 ));
 CL.AddConstantN('clTrBlue32','LongWord').SetUInt( TColor32 ( $7F0000FF ));
 CL.AddDelphiFunction('Function Color32( WinColor : TColor) : TColor32;');
 CL.AddDelphiFunction('Function Color321( R, G, B : Byte; A : Byte) : TColor32;');
 CL.AddDelphiFunction('Function Color322( Index : Byte; var Palette : TPalette32) : TColor32;');
 CL.AddDelphiFunction('Function Gray32( Intensity : Byte; Alpha : Byte) : TColor32');
 CL.AddDelphiFunction('Function WinColor( Color32 : TColor32) : TColor');
 CL.AddDelphiFunction('Function ArrayOfColor32( Colors : array of TColor32) : TArrayOfColor32');
 CL.AddDelphiFunction('Procedure Color32ToRGB( Color32 : TColor32; var R, G, B : Byte)');
 CL.AddDelphiFunction('Procedure Color32ToRGBA( Color32 : TColor32; var R, G, B, A : Byte)');
 CL.AddDelphiFunction('Function Color32Components( R, G, B, A : Boolean) : TColor32Components');
 CL.AddDelphiFunction('Function RedComponent( Color32 : TColor32) : Integer');
 CL.AddDelphiFunction('Function GreenComponent( Color32 : TColor32) : Integer');
 CL.AddDelphiFunction('Function BlueComponent( Color32 : TColor32) : Integer');
 CL.AddDelphiFunction('Function AlphaComponent( Color32 : TColor32) : Integer');
 CL.AddDelphiFunction('Function Intensity( Color32 : TColor32) : Integer');
 CL.AddDelphiFunction('Function SetAlpha( Color32 : TColor32; NewAlpha : Integer) : TColor32');
 CL.AddDelphiFunction('Function HSLtoRGB( H, S, L : Single) : TColor32;');
 CL.AddDelphiFunction('Procedure RGBtoHSL( RGB : TColor32; out H, S, L : Single);');
 CL.AddDelphiFunction('Function HSLtoRGB1( H, S, L : Integer) : TColor32;');
 CL.AddDelphiFunction('Procedure RGBtoHSL1( RGB : TColor32; out H, S, L : Byte);');
 CL.AddDelphiFunction('Function WinPalette( const P : TPalette32) : HPALETTE');
 // CL.AddTypeS('PFixed', '^TFixed // will not work');
  CL.AddTypeS('TFixed', 'Integer');
  //CL.AddTypeS('PFixedArray', '^TFixedArray // will not work');
  //CL.AddTypeS('PArrayOfFixed', '^TArrayOfFixed // will not work');
  CL.AddTypeS('TArrayOfFixed', 'array of TFixed');
 // CL.AddTypeS('PArrayOfArrayOfFixed', '^TArrayOfArrayOfFixed // will not work');
  CL.AddTypeS('TArrayOfArrayOfFixed', 'array of TArrayOfFixed');
  //CL.AddTypeS('PFloat', '^TFloat // will not work');
  CL.AddTypeS('TFloat', 'Single');
  //CL.AddTypeS('PByteArray', '^TByteArray // will not work');
  //CL.AddTypeS('PArrayOfByte', '^TArrayOfByte // will not work');
  CL.AddTypeS('TArrayOfByte', 'array of Byte');
  //CL.AddTypeS('PWordArray', '^TWordArray // will not work');
  //CL.AddTypeS('PArrayOfWord', '^TArrayOfWord // will not work');
  CL.AddTypeS('TArrayOfWord', 'array of Word');
 // CL.AddTypeS('PIntegerArray', '^TIntegerArray // will not work');
 // CL.AddTypeS('PArrayOfInteger', '^TArrayOfInteger // will not work');
  CL.AddTypeS('TArrayOfInteger', 'array of Integer');
  CL.AddTypeS('TArrayOfArrayOfInteger', 'array of TArrayOfInteger');
  //CL.AddTypeS('PSingleArray', '^TSingleArray // will not work');
  //CL.AddTypeS('PArrayOfSingle', '^TArrayOfSingle // will not work');
  CL.AddTypeS('TArrayOfSingle', 'array of Single');
  //CL.AddTypeS('PFloatArray', '^TFloatArray // will not work');
  //CL.AddTypeS('PArrayOfFloat', '^TArrayOfFloat // will not work');
  CL.AddTypeS('TArrayOfFloat', 'array of TFloat');
 CL.AddConstantN('FixedOne','LongWord').SetUInt( $10000);
 CL.AddConstantN('FixedHalf','LongWord').SetUInt( $7FFF);
 CL.AddDelphiFunction('Function Fixed( S : Single) : TFixed;');
 CL.AddDelphiFunction('Function Fixed1( I : Integer) : TFixed;');
  //CL.AddTypeS('PPointArray', '^TPointArray // will not work');
  //CL.AddTypeS('PArrayOfPoint', '^TArrayOfPoint // will not work');
  CL.AddTypeS('TArrayOfPoint', 'array of TPoint');
  //CL.AddTypeS('PArrayOfArrayOfPoint', '^TArrayOfArrayOfPoint // will not work');
  CL.AddTypeS('TArrayOfArrayOfPoint', 'array of TArrayOfPoint');
  //CL.AddTypeS('PFloatPoint', '^TFloatPoint // will not work');
  CL.AddTypeS('TFloatPoint', 'record X : TFloat; Y : TFloat; end');
  //CL.AddTypeS('PFloatPointArray', '^TFloatPointArray // will not work');
  //CL.AddTypeS('PArrayOfFloatPoint', '^TArrayOfFloatPoint // will not work');
  CL.AddTypeS('TArrayOfFloatPoint', 'array of TFloatPoint');
  CL.AddTypeS('TArrayOfArrayOfFloatPoint', 'array of TArrayOfFloatPoint');
  //CL.AddTypeS('PFixedPoint', '^TFixedPoint // will not work');
  CL.AddTypeS('TFixedPoint', 'record X : TFixed; Y : TFixed; end');
 // CL.AddTypeS('PFixedPointArray', '^TFixedPointArray // will not work');
  //CL.AddTypeS('PArrayOfFixedPoint', '^TArrayOfFixedPoint // will not work');
  CL.AddTypeS('TArrayOfFixedPoint', 'array of TFixedPoint');
  CL.AddTypeS('TArrayOfArrayOfFixedPoint', 'array of TArrayOfFixedPoint');
 CL.AddDelphiFunction('Function GFloatPoint( X, Y : Single) : TFloatPoint;');
 CL.AddDelphiFunction('Function FloatPoint1( const P : TPoint) : TFloatPoint;');
 CL.AddDelphiFunction('Function FloatPoint2( const FXP : TFixedPoint) : TFloatPoint;');
 CL.AddDelphiFunction('Function FixedPoint( X, Y : Integer) : TFixedPoint;');
 CL.AddDelphiFunction('Function FixedPoint1( X, Y : Single) : TFixedPoint;');
 CL.AddDelphiFunction('Function FixedPoint2( const P : TPoint) : TFixedPoint;');
 CL.AddDelphiFunction('Function FixedPoint3( const FP : TFloatPoint) : TFixedPoint;');
  CL.AddTypeS('TRectRounding', '( rrClosest, rrOutside, rrInside )');
 CL.AddDelphiFunction('Function MakeRect( const L, T, R, B : Integer) : TRect;');
 CL.AddDelphiFunction('Function MakeRect1( const FR : TFloatRect; Rounding : TRectRounding) : TRect;');
 CL.AddDelphiFunction('Function MakeRect2( const FXR : TRect; Rounding : TRectRounding) : TRect;');
 CL.AddDelphiFunction('Function GFixedRect( const L, T, R, B : TFixed) : TRect;');
 CL.AddDelphiFunction('Function FixedRect1( const ARect : TRect) : TRect;');
 CL.AddDelphiFunction('Function FixedRect2( const FR : TFloatRect) : TRect;');
 CL.AddDelphiFunction('Function GFloatRect( const L, T, R, B : TFloat) : TFloatRect;');
 CL.AddDelphiFunction('Function FloatRect1( const ARect : TRect) : TFloatRect;');
 CL.AddDelphiFunction('Function FloatRect2( const FXR : TRect) : TFloatRect;');
 CL.AddDelphiFunction('Function GIntersectRect( out Dst : TRect; const R1, R2 : TRect) : Boolean;');
 CL.AddDelphiFunction('Function IntersectRect1( out Dst : TFloatRect; const FR1, FR2 : TFloatRect) : Boolean;');
 CL.AddDelphiFunction('Function GUnionRect( out Rect : TRect; const R1, R2 : TRect) : Boolean;');
 CL.AddDelphiFunction('Function UnionRect1( out Rect : TFloatRect; const R1, R2 : TFloatRect) : Boolean;');
 CL.AddDelphiFunction('Function GEqualRect( const R1, R2 : TRect) : Boolean;');
 CL.AddDelphiFunction('Function EqualRect1( const R1, R2 : TFloatRect) : Boolean;');
 CL.AddDelphiFunction('Procedure GInflateRect( var R : TRect; Dx, Dy : Integer);');
 CL.AddDelphiFunction('Procedure InflateRect1( var FR : TFloatRect; Dx, Dy : TFloat);');
 CL.AddDelphiFunction('Procedure GOffsetRect( var R : TRect; Dx, Dy : Integer);');
 CL.AddDelphiFunction('Procedure OffsetRect1( var FR : TFloatRect; Dx, Dy : TFloat);');
 CL.AddDelphiFunction('Function IsRectEmpty( const R : TRect) : Boolean;');
 CL.AddDelphiFunction('Function IsRectEmpty1( const FR : TFloatRect) : Boolean;');
 CL.AddDelphiFunction('Function GPtInRect( const R : TRect; const P : TPoint) : Boolean;');
 CL.AddDelphiFunction('Function PtInRect1( const R : TFloatRect; const P : TPoint) : Boolean;');
 CL.AddDelphiFunction('Function PtInRect2( const R : TRect; const P : TFloatPoint) : Boolean;');
 CL.AddDelphiFunction('Function PtInRect3( const R : TFloatRect; const P : TFloatPoint) : Boolean;');
 CL.AddDelphiFunction('Function EqualRectSize( const R1, R2 : TRect) : Boolean;');
 CL.AddDelphiFunction('Function EqualRectSize1( const R1, R2 : TFloatRect) : Boolean;');
  CL.AddTypeS('TDrawMode', '( dmOpaque, dmBlend, dmCustom, dmTransparent )');
  CL.AddTypeS('TCombineMode', '( cmBlend, cmMerge )');
  CL.AddTypeS('TWrapMode', '( wmClamp, wmRepeat, wmMirror )');
  CL.AddTypeS('TStretchFilter','(sfNearest, sfDraft, sfLinear, sfCosine, sfSpline, sfLanczos, sfMitchell )');
 CL.AddDelphiFunction('Procedure SetGamma( Gamma : Single)');
  SIRegister_TCustomMap(CL);
 CL.AddConstantN('AREAINFO_RECT','LongWord').SetUInt( $80000000);
 CL.AddConstantN('AREAINFO_LINE','LongWord').SetUInt( $40000000);
 CL.AddConstantN('AREAINFO_ELLIPSE','LongWord').SetUInt( $20000000);
 CL.AddConstantN('AREAINFO_ABSOLUTE','LongWord').SetUInt( $10000000);
 CL.AddConstantN('AREAINFO_MASK','LongWord').SetUInt( $FF000000);
  CL.AddTypeS('TPixelCombineEvent', 'Procedure ( F : TColor32; var B : TColor32; M : TColor32)');
  CL.AddTypeS('TAreaChangedEvent', 'Procedure (Sender: TObject; const Area: TRect; const Info : Cardinal)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomResampler');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomBackend');
  //CL.AddTypeS('TCustomBackendClass', 'class of TCustomBackend');
  SIRegister_TCustomBitmap32(CL);
  SIRegister_TBitmap32(CL);
  SIRegister_TCustomBackend(CL);
  SIRegister_TCustomSampler(CL);
  CL.AddTypeS('TPixelAccessMode', '(pamUnsafe, pamSafe, pamWrap, pamTransparentEdge )');
  SIRegister_TCustomResampler(CL);
  //CL.AddTypeS('TCustomResamplerClass', 'class of TCustomResampler');
 //CL.AddDelphiFunction('Function GetPlatformBackendClass : TCustomBackendClass');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomResamplerPixelAccessMode_W(Self: TCustomResampler; const T: TPixelAccessMode);
begin Self.PixelAccessMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomResamplerPixelAccessMode_R(Self: TCustomResampler; var T: TPixelAccessMode);
begin T := Self.PixelAccessMode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomResamplerWidth_R(Self: TCustomResampler; var T: TFloat);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TCustomResamplerBitmap_W(Self: TCustomResampler; const T: TCustomBitmap32);
begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomResamplerBitmap_R(Self: TCustomResampler; var T: TCustomBitmap32);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
Function TCustomResamplerCreate3_P(Self: TClass; CreateNewInstance: Boolean;  ABitmap : TCustomBitmap32):TObject;
Begin Result := TCustomResampler.Create(ABitmap); END;

(*----------------------------------------------------------------------------*)
Function TCustomResamplerCreate2_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TCustomResampler.Create; END;

(*----------------------------------------------------------------------------*)
procedure TCustomBackendOnChanging_W(Self: TCustomBackend; const T: TNotifyEvent);
begin Self.OnChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBackendOnChanging_R(Self: TCustomBackend; var T: TNotifyEvent);
begin T := Self.OnChanging; end;

(*----------------------------------------------------------------------------*)
Function TCustomBackendCreate1_P(Self: TClass; CreateNewInstance: Boolean;  Owner : TCustomBitmap32):TObject;
Begin Result := TCustomBackend.Create(Owner); END;

(*----------------------------------------------------------------------------*)
Function TCustomBackendCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TCustomBackend.Create; END;

(*----------------------------------------------------------------------------*)
procedure TBitmap32OnHandleChanged_W(Self: TBitmap32; const T: TNotifyEvent);
begin Self.OnHandleChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32OnHandleChanged_R(Self: TBitmap32; var T: TNotifyEvent);
begin T := Self.OnHandleChanged; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32Handle_R(Self: TBitmap32; var T: HDC);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32BitmapInfo_R(Self: TBitmap32; var T: TBitmapInfo);
begin T := Self.BitmapInfo; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32BitmapHandle_R(Self: TBitmap32; var T: HBITMAP);
begin T := Self.BitmapHandle; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32Font_W(Self: TBitmap32; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32Font_R(Self: TBitmap32; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32Canvas_R(Self: TBitmap32; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32TextoutW2_P(Self: TBitmap32;  DstRect : TRect; const Flags : Cardinal; const Text : Widestring);
Begin Self.TextoutW(DstRect, Flags, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32TextoutW1_P(Self: TBitmap32;  X, Y : Integer; const ClipRect : TRect; const Text : Widestring);
Begin Self.TextoutW(X, Y, ClipRect, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32TextoutW_P(Self: TBitmap32;  X, Y : Integer; const Text : Widestring);
Begin Self.TextoutW(X, Y, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32Textout2_P(Self: TBitmap32;  DstRect : TRect; const Flags : Cardinal; const Text : String);
Begin Self.Textout(DstRect, Flags, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32Textout1_P(Self: TBitmap32;  X, Y : Integer; const ClipRect : TRect; const Text : String);
Begin Self.Textout(X, Y, ClipRect, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32Textout_P(Self: TBitmap32;  X, Y : Integer; const Text : String);
Begin Self.Textout(X, Y, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32DrawTo3_P(Self: TBitmap32;  hDst : HDC; const DstRect, SrcRect : TRect);
Begin Self.DrawTo(hDst, DstRect, SrcRect); END;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32DrawTo2_P(Self: TBitmap32;  hDst : HDC; DstX, DstY : Integer);
Begin Self.DrawTo(hDst, DstX, DstY); END;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32DrawTo1_P(Self: TBitmap32;  hDst : Cardinal; const DstRect, SrcRect : TRect);
Begin Self.DrawTo(hDst, DstRect, SrcRect); END;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32DrawTo_P(Self: TBitmap32;  hDst : Cardinal; DstX, DstY : Integer);
Begin Self.DrawTo(hDst, DstX, DstY); END;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32Draw1_P(Self: TBitmap32;  const DstRect, SrcRect : TRect; hSrc : HDC);
Begin Self.Draw(DstRect, SrcRect, hSrc); END;

(*----------------------------------------------------------------------------*)
Procedure TBitmap32Draw_P(Self: TBitmap32;  const DstRect, SrcRect : TRect; hSrc : Cardinal);
Begin Self.Draw(DstRect, SrcRect, hSrc); END;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32OnAreaChanged_W(Self: TCustomBitmap32; const T: TAreaChangedEvent);
begin Self.OnAreaChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32OnAreaChanged_R(Self: TCustomBitmap32; var T: TAreaChangedEvent);
begin T := Self.OnAreaChanged; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32OnPixelCombine_W(Self: TCustomBitmap32; const T: TPixelCombineEvent);
begin Self.OnPixelCombine := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32OnPixelCombine_R(Self: TCustomBitmap32; var T: TPixelCombineEvent);
begin T := Self.OnPixelCombine; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32Resampler_W(Self: TCustomBitmap32; const T: TCustomResampler);
begin Self.Resampler := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32Resampler_R(Self: TCustomBitmap32; var T: TCustomResampler);
begin T := Self.Resampler; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32ResamplerClassName_W(Self: TCustomBitmap32; const T: string);
begin Self.ResamplerClassName := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32ResamplerClassName_R(Self: TCustomBitmap32; var T: string);
begin T := Self.ResamplerClassName; end;

(*----------------------------------------------------------------------------*)
(*procedure TCustomBitmap32StretchFilter_W(Self: TCustomBitmap32; const T: TStretchFilter);
begin Self.StretchFilter := T; end;   *)

(*----------------------------------------------------------------------------*)
//procedure TCustomBitmap32StretchFilter_R(Self: TCustomBitmap32; var T: TStretchFilter);
//begin T := Self.StretchFilter; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32OuterColor_W(Self: TCustomBitmap32; const T: TColor32);
begin Self.OuterColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32OuterColor_R(Self: TCustomBitmap32; var T: TColor32);
begin T := Self.OuterColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32MasterAlpha_W(Self: TCustomBitmap32; const T: Cardinal);
begin Self.MasterAlpha := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32MasterAlpha_R(Self: TCustomBitmap32; var T: Cardinal);
begin T := Self.MasterAlpha; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32WrapMode_W(Self: TCustomBitmap32; const T: TWrapMode);
begin Self.WrapMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32WrapMode_R(Self: TCustomBitmap32; var T: TWrapMode);
begin T := Self.WrapMode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32CombineMode_W(Self: TCustomBitmap32; const T: TCombineMode);
begin Self.CombineMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32CombineMode_R(Self: TCustomBitmap32; var T: TCombineMode);
begin T := Self.CombineMode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32DrawMode_W(Self: TCustomBitmap32; const T: TDrawMode);
begin Self.DrawMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32DrawMode_R(Self: TCustomBitmap32; var T: TDrawMode);
begin T := Self.DrawMode; end;

procedure TBitmap32DrawMode_W(Self: TBitmap32; const T: TDrawMode);
begin Self.DrawMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32DrawMode_R(Self: TBitmap32; var T: TDrawMode);
begin T := Self.DrawMode; end;


(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32Backend_W(Self: TCustomBitmap32; const T: TCustomBackend);
begin Self.Backend := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32Backend_R(Self: TCustomBitmap32; var T: TCustomBackend);
begin T := Self.Backend; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelXR_R(Self: TCustomBitmap32; var T: TColor32; const t1: TFixed; const t2: TFixed);
begin T := Self.PixelXR[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelFR_R(Self: TCustomBitmap32; var T: TColor32; const t1: Single; const t2: Single);
begin T := Self.PixelFR[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelFW_W(Self: TCustomBitmap32; const T: TColor32; const t1: Single; const t2: Single);
begin Self.PixelFW[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelFW_R(Self: TCustomBitmap32; var T: TColor32; const t1: Single; const t2: Single);
begin T := Self.PixelFW[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelFS_W(Self: TCustomBitmap32; const T: TColor32; const t1: Single; const t2: Single);
begin Self.PixelFS[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelFS_R(Self: TCustomBitmap32; var T: TColor32; const t1: Single; const t2: Single);
begin T := Self.PixelFS[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelF_W(Self: TCustomBitmap32; const T: TColor32; const t1: Single; const t2: Single);
begin Self.PixelF[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelF_R(Self: TCustomBitmap32; var T: TColor32; const t1: Single; const t2: Single);
begin T := Self.PixelF[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelXW_W(Self: TCustomBitmap32; const T: TColor32; const t1: TFixed; const t2: TFixed);
begin Self.PixelXW[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelXW_R(Self: TCustomBitmap32; var T: TColor32; const t1: TFixed; const t2: TFixed);
begin T := Self.PixelXW[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelXS_W(Self: TCustomBitmap32; const T: TColor32; const t1: TFixed; const t2: TFixed);
begin Self.PixelXS[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelXS_R(Self: TCustomBitmap32; var T: TColor32; const t1: TFixed; const t2: TFixed);
begin T := Self.PixelXS[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelX_W(Self: TCustomBitmap32; const T: TColor32; const t1: TFixed; const t2: TFixed);
begin Self.PixelX[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelX_R(Self: TCustomBitmap32; var T: TColor32; const t1: TFixed; const t2: TFixed);
begin T := Self.PixelX[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelW_W(Self: TCustomBitmap32; const T: TColor32; const t1: Integer; const t2: Integer);
begin Self.PixelW[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelW_R(Self: TCustomBitmap32; var T: TColor32; const t1: Integer; const t2: Integer);
begin T := Self.PixelW[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelS_W(Self: TCustomBitmap32; const T: TColor32; const t1: Integer; const t2: Integer);
begin Self.PixelS[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PixelS_R(Self: TCustomBitmap32; var T: TColor32; const t1: Integer; const t2: Integer);
begin T := Self.PixelS[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32Pixel_W(Self: TCustomBitmap32; const T: TColor32; const t1: Integer; const t2: Integer);
begin Self.Pixel[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32Pixel_R(Self: TCustomBitmap32; var T: TColor32; const t1: Integer; const t2: Integer);
begin T := Self.Pixel[t1, t2]; end;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32RaiseRectTS1_P(Self: TCustomBitmap32;  const ARect : TRect; Contrast : Integer);
Begin Self.RaiseRectTS(ARect, Contrast); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32RaiseRectTS_P(Self: TCustomBitmap32;  X1, Y1, X2, Y2 : Integer; Contrast : Integer);
Begin Self.RaiseRectTS(X1, Y1, X2, Y2, Contrast); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32FillRectS_P(Self: TCustomBitmap32;  X1, Y1, X2, Y2 : Integer; Value : TColor32);
Begin Self.FillRectS(X1, Y1, X2, Y2, Value); END;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PenColor_W(Self: TCustomBitmap32; const T: TColor32);
begin Self.PenColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomBitmap32PenColor_R(Self: TCustomBitmap32; var T: TColor32);
begin T := Self.PenColor; end;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32SetStipple1_P(Self: TCustomBitmap32;  NewStipple : array of TColor32);
Begin Self.SetStipple(NewStipple); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32SetStipple_P(Self: TCustomBitmap32;  NewStipple : TArrayOfColor32);
Begin Self.SetStipple(NewStipple); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32DrawTo4_P(Self: TCustomBitmap32;  Dst : TCustomBitmap32; const DstRect, SrcRect : TRect);
Begin Self.DrawTo(Dst, DstRect, SrcRect); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32DrawTo3_P(Self: TCustomBitmap32;  Dst : TCustomBitmap32; const DstRect : TRect);
Begin Self.DrawTo(Dst, DstRect); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32DrawTo2_P(Self: TCustomBitmap32;  Dst : TCustomBitmap32; DstX, DstY : Integer);
Begin Self.DrawTo(Dst, DstX, DstY); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32DrawTo1_P(Self: TCustomBitmap32;  Dst : TCustomBitmap32; DstX, DstY : Integer; const SrcRect : TRect);
Begin Self.DrawTo(Dst, DstX, DstY, SrcRect); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32DrawTo_P(Self: TCustomBitmap32;  Dst : TCustomBitmap32);
Begin Self.DrawTo(Dst); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32SetPixelT1_P(Self: TCustomBitmap32;  var Ptr : PColor32; Value : TColor32);
Begin Self.SetPixelT(Ptr, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32SetPixelT_P(Self: TCustomBitmap32;  X, Y : Integer; Value : TColor32);
Begin Self.SetPixelT(X, Y, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32Draw2_P(Self: TCustomBitmap32;  const DstRect, SrcRect : TRect; Src : TCustomBitmap32);
Begin Self.Draw(DstRect, SrcRect, Src); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32Draw1_P(Self: TCustomBitmap32;  DstX, DstY : Integer; const SrcRect : TRect; Src : TCustomBitmap32);
Begin Self.Draw(DstX, DstY, SrcRect, Src); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32Draw_P(Self: TCustomBitmap32;  DstX, DstY : Integer; Src : TCustomBitmap32);
Begin Self.Draw(DstX, DstY, Src); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32ResetAlpha1_P(Self: TCustomBitmap32;  const AlphaValue : Byte);
Begin Self.ResetAlpha(AlphaValue); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32ResetAlpha_P(Self: TCustomBitmap32);
Begin Self.ResetAlpha; END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32Changed1_P(Self: TCustomBitmap32;  const Area : TRect; const Info : Cardinal);
Begin Self.Changed(Area, Info); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomBitmap32Changed_P(Self: TCustomBitmap32);
Begin Self.Changed; END;

(*----------------------------------------------------------------------------*)
procedure TCustomMapOnResize_W(Self: TCustomMap; const T: TNotifyEvent);
begin Self.OnResize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomMapOnResize_R(Self: TCustomMap; var T: TNotifyEvent);
begin T := Self.OnResize; end;

(*----------------------------------------------------------------------------*)
procedure TCustomMapWidth_W(Self: TCustomMap; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomMapWidth_R(Self: TCustomMap; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TCustomMapHeight_W(Self: TCustomMap; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomMapHeight_R(Self: TCustomMap; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
Function EqualRectSize1_P( const R1, R2 : TFloatRect) : Boolean;
Begin Result := GR32.EqualRectSize(R1, R2); END;

(*----------------------------------------------------------------------------*)
Function EqualRectSize_P( const R1, R2 : TRect) : Boolean;
Begin Result := GR32.EqualRectSize(R1, R2); END;

(*----------------------------------------------------------------------------*)
Function PtInRect3_P( const R : TFloatRect; const P : TFloatPoint) : Boolean;
Begin Result := GR32.PtInRect(R, P); END;

(*----------------------------------------------------------------------------*)
Function PtInRect2_P( const R : TRect; const P : TFloatPoint) : Boolean;
Begin Result := GR32.PtInRect(R, P); END;

(*----------------------------------------------------------------------------*)
Function PtInRect1_P( const R : TFloatRect; const P : TPoint) : Boolean;
Begin Result := GR32.PtInRect(R, P); END;

(*----------------------------------------------------------------------------*)
Function PtInRect_P( const R : TRect; const P : TPoint) : Boolean;
Begin Result := GR32.PtInRect(R, P); END;

(*----------------------------------------------------------------------------*)
Function IsRectEmpty1_P( const FR : TFloatRect) : Boolean;
Begin Result := GR32.IsRectEmpty(FR); END;

(*----------------------------------------------------------------------------*)
Function IsRectEmpty_P( const R : TRect) : Boolean;
Begin Result := GR32.IsRectEmpty(R); END;

(*----------------------------------------------------------------------------*)
Procedure OffsetRect1_P( var FR : TFloatRect; Dx, Dy : TFloat);
Begin GR32.OffsetRect(FR, Dx, Dy); END;

(*----------------------------------------------------------------------------*)
Procedure OffsetRect_P( var R : TRect; Dx, Dy : Integer);
Begin GR32.OffsetRect(R, Dx, Dy); END;

(*----------------------------------------------------------------------------*)
Procedure InflateRect1_P( var FR : TFloatRect; Dx, Dy : TFloat);
Begin GR32.InflateRect(FR, Dx, Dy); END;

(*----------------------------------------------------------------------------*)
Procedure InflateRect_P( var R : TRect; Dx, Dy : Integer);
Begin GR32.InflateRect(R, Dx, Dy); END;

(*----------------------------------------------------------------------------*)
Function EqualRect1_P( const R1, R2 : TFloatRect) : Boolean;
Begin Result := GR32.EqualRect(R1, R2); END;

(*----------------------------------------------------------------------------*)
Function EqualRect_P( const R1, R2 : TRect) : Boolean;
Begin Result := GR32.EqualRect(R1, R2); END;

(*----------------------------------------------------------------------------*)
Function UnionRect1_P( out Rect : TFloatRect; const R1, R2 : TFloatRect) : Boolean;
Begin Result := GR32.UnionRect(Rect, R1, R2); END;

(*----------------------------------------------------------------------------*)
Function UnionRect_P( out Rect : TRect; const R1, R2 : TRect) : Boolean;
Begin Result := GR32.UnionRect(Rect, R1, R2); END;

(*----------------------------------------------------------------------------*)
Function IntersectRect1_P( out Dst : TFloatRect; const FR1, FR2 : TFloatRect) : Boolean;
Begin Result := GR32.IntersectRect(Dst, FR1, FR2); END;

(*----------------------------------------------------------------------------*)
Function IntersectRect_P( out Dst : TRect; const R1, R2 : TRect) : Boolean;
Begin Result := GR32.IntersectRect(Dst, R1, R2); END;

(*----------------------------------------------------------------------------*)
Function FloatRect2_P( const FXR : TFixedRect) : TFloatRect;
Begin Result := GR32.FloatRect(FXR); END;

(*----------------------------------------------------------------------------*)
Function FloatRect1_P( const ARect : TRect) : TFloatRect;
Begin Result := GR32.FloatRect(ARect); END;

(*----------------------------------------------------------------------------*)
Function FloatRect_P( const L, T, R, B : TFloat) : TFloatRect;
Begin Result := GR32.FloatRect(L, T, R, B); END;

(*----------------------------------------------------------------------------*)
Function FixedRect2_P( const FR : TFloatRect) : TFixedRect;
Begin Result := GR32.FixedRect(FR); END;

(*----------------------------------------------------------------------------*)
Function FixedRect1_P( const ARect : TRect) : TFixedRect;
Begin Result := GR32.FixedRect(ARect); END;

(*----------------------------------------------------------------------------*)
Function FixedRect_P( const L, T, R, B : TFixed) : TFixedRect;
Begin Result := GR32.FixedRect(L, T, R, B); END;

(*----------------------------------------------------------------------------*)
Function MakeRect2_P( const FXR : TFixedRect; Rounding : TRectRounding) : TRect;
Begin Result := GR32.MakeRect(FXR, Rounding); END;

(*----------------------------------------------------------------------------*)
Function MakeRect1_P( const FR : TFloatRect; Rounding : TRectRounding) : TRect;
Begin Result := GR32.MakeRect(FR, Rounding); END;

(*----------------------------------------------------------------------------*)
Function MakeRect_P( const L, T, R, B : Integer) : TRect;
Begin Result := GR32.MakeRect(L, T, R, B); END;

(*----------------------------------------------------------------------------*)
Function FixedPoint3_P( const FP : TFloatPoint) : TFixedPoint;
Begin Result := GR32.FixedPoint(FP); END;

(*----------------------------------------------------------------------------*)
Function FixedPoint2_P( const P : TPoint) : TFixedPoint;
Begin Result := GR32.FixedPoint(P); END;

(*----------------------------------------------------------------------------*)
Function FixedPoint1_P( X, Y : Single) : TFixedPoint;
Begin Result := GR32.FixedPoint(X, Y); END;

(*----------------------------------------------------------------------------*)
Function FixedPoint_P( X, Y : Integer) : TFixedPoint;
Begin Result := GR32.FixedPoint(X, Y); END;

(*----------------------------------------------------------------------------*)
Function FloatPoint2_P( const FXP : TFixedPoint) : TFloatPoint;
Begin Result := GR32.FloatPoint(FXP); END;

(*----------------------------------------------------------------------------*)
Function FloatPoint1_P( const P : TPoint) : TFloatPoint;
Begin Result := GR32.FloatPoint(P); END;

(*----------------------------------------------------------------------------*)
Function FloatPoint_P( X, Y : Single) : TFloatPoint;
Begin Result := GR32.FloatPoint(X, Y); END;

(*----------------------------------------------------------------------------*)
Function Fixed1_P( I : Integer) : TFixed;
Begin Result := GR32.Fixed(I); END;

(*----------------------------------------------------------------------------*)
Function Fixed_P( S : Single) : TFixed;
Begin Result := GR32.Fixed(S); END;

(*----------------------------------------------------------------------------*)
Procedure RGBtoHSL1_P( RGB : TColor32; out H, S, L : Byte);
Begin GR32.RGBtoHSL(RGB, H, S, L); END;

(*----------------------------------------------------------------------------*)
Function HSLtoRGB1_P( H, S, L : Integer) : TColor32;
Begin Result := GR32.HSLtoRGB(H, S, L); END;

(*----------------------------------------------------------------------------*)
Procedure RGBtoHSL_P( RGB : TColor32; out H, S, L : Single);
Begin GR32.RGBtoHSL(RGB, H, S, L); END;

(*----------------------------------------------------------------------------*)
Function HSLtoRGB_P( H, S, L : Single) : TColor32;
Begin Result := GR32.HSLtoRGB(H, S, L); END;

(*----------------------------------------------------------------------------*)
Function Color322_P( Index : Byte; var Palette : TPalette32) : TColor32;
Begin Result := GR32.Color32(Index, Palette); END;

(*----------------------------------------------------------------------------*)
Function Color321_P( R, G, B : Byte; A : Byte) : TColor32;
Begin Result := GR32.Color32(R, G, B, A); END;

(*----------------------------------------------------------------------------*)
Function Color32_P( WinColor : TColor) : TColor32;
Begin Result := GR32.Color32(WinColor); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomResampler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomResampler) do begin
    RegisterConstructor(@TCustomResamplerCreate2_P, 'Create2');
    RegisterConstructor(@TCustomResamplerCreate3_P, 'Create3');
    RegisterPropertyHelper(@TCustomResamplerBitmap_R,@TCustomResamplerBitmap_W,'Bitmap');
    RegisterPropertyHelper(@TCustomResamplerWidth_R,nil,'Width');
    RegisterPropertyHelper(@TCustomResamplerPixelAccessMode_R,@TCustomResamplerPixelAccessMode_W,'PixelAccessMode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomSampler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomSampler) do begin
    RegisterVirtualMethod(@TCustomSampler.GetSampleInt, 'GetSampleInt');
    RegisterVirtualMethod(@TCustomSampler.GetSampleFixed, 'GetSampleFixed');
    RegisterVirtualMethod(@TCustomSampler.GetSampleFloat, 'GetSampleFloat');
    RegisterVirtualMethod(@TCustomSampler.PrepareSampling, 'PrepareSampling');
    RegisterVirtualMethod(@TCustomSampler.FinalizeSampling, 'FinalizeSampling');
    RegisterVirtualMethod(@TCustomSampler.HasBounds, 'HasBounds');
    RegisterVirtualMethod(@TCustomSampler.GetSampleBounds, 'GetSampleBounds');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomBackend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomBackend) do begin
    RegisterConstructor(@TCustomBackendCreate1_P, 'Create1');
    RegisterVirtualMethod(@TCustomBackend.Clear, 'Clear');
    RegisterVirtualMethod(@TCustomBackend.Empty, 'Empty');
    RegisterVirtualMethod(@TCustomBackend.ChangeSize, 'ChangeSize');
    RegisterPropertyHelper(@TCustomBackendOnChanging_R,@TCustomBackendOnChanging_W,'OnChanging');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBitmap32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBitmap32) do begin
    RegisterMethod(@TBitmap32Draw_P, 'DrawA');
    //RegisterMethod(@TBitmap32Draw1_P, 'Draw1');
    RegisterMethod(@TBitmap32DrawTo_P, 'DrawTo');
    RegisterMethod(@TBitmap32DrawTo1_P, 'DrawTo1');
    RegisterMethod(@TBitmap32.TileTo, 'TileTo');
    RegisterMethod(@TBitmap32DrawTo2_P, 'DrawTo2');
    RegisterMethod(@TBitmap32DrawTo3_P, 'DrawTo3');
    RegisterMethod(@TBitmap32.TileTo, 'TileTo');
    RegisterMethod(@TBitmap32.UpdateFont, 'UpdateFont');
    RegisterMethod(@TBitmap32Textout_P, 'Textout');
    RegisterMethod(@TBitmap32Textout1_P, 'Textout1');
    RegisterMethod(@TBitmap32Textout2_P, 'Textout2');
    RegisterMethod(@TBitmap32.TextExtent, 'TextExtent');
    RegisterMethod(@TBitmap32.TextHeight, 'TextHeight');
    RegisterMethod(@TBitmap32.TextWidth, 'TextWidth');
    RegisterMethod(@TBitmap32.RenderText, 'RenderText');
    RegisterMethod(@TBitmap32TextoutW_P, 'TextoutW');
    RegisterMethod(@TBitmap32TextoutW1_P, 'TextoutW1');
    RegisterMethod(@TBitmap32TextoutW2_P, 'TextoutW2');
    RegisterMethod(@TBitmap32.TextExtentW, 'TextExtentW');
    RegisterMethod(@TBitmap32.TextHeightW, 'TextHeightW');
    RegisterMethod(@TBitmap32.TextWidthW, 'TextWidthW');
    RegisterMethod(@TBitmap32.RenderTextW, 'RenderTextW');
    RegisterPropertyHelper(@TBitmap32Canvas_R,nil,'Canvas');
    RegisterMethod(@TBitmap32.CanvasAllocated, 'CanvasAllocated');
    RegisterMethod(@TBitmap32.DeleteCanvas, 'DeleteCanvas');
    RegisterPropertyHelper(@TBitmap32DrawMode_R,@TCustomBitmap32DrawMode_W,'DrawMode');
    RegisterPropertyHelper(@TBitmap32Font_R,@TBitmap32Font_W,'Font');
    RegisterPropertyHelper(@TBitmap32BitmapHandle_R,nil,'BitmapHandle');
    RegisterPropertyHelper(@TBitmap32BitmapInfo_R,nil,'BitmapInfo');
    RegisterPropertyHelper(@TBitmap32Handle_R,nil,'Handle');
    RegisterPropertyHelper(@TBitmap32OnHandleChanged_R,@TBitmap32OnHandleChanged_W,'OnHandleChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomBitmap32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomBitmap32) do begin
    RegisterConstructor(@TCustomBitmap32.Create, 'Create');
    RegisterMethod(@TCustomBitmap32.Destroy, 'Free');
    RegisterMethod(@TCustomBitmap32.Assign, 'Assign');
    RegisterMethod(@TCustomBitmap32.BoundsRect, 'BoundsRect');
    RegisterMethod(@TCustomBitmap32.Empty, 'Empty');
    RegisterMethod(@TCustomBitmap32.Clear, 'Clear');
    RegisterMethod(@TCustomBitmap32.Clear, 'Clear');
    RegisterMethod(@TCustomBitmap32.Delete, 'Delete');
    RegisterMethod(@TCustomBitmap32.BeginMeasuring, 'BeginMeasuring');
    RegisterMethod(@TCustomBitmap32.EndMeasuring, 'EndMeasuring');
    RegisterMethod(@TCustomBitmap32.ReleaseBackend, 'ReleaseBackend');
    RegisterVirtualMethod(@TCustomBitmap32.PropertyChanged, 'PropertyChanged');
    RegisterVirtualMethod(@TCustomBitmap32Changed1_P, 'Changed1');
    RegisterVirtualMethod(@TCustomBitmap32.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TCustomBitmap32.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TCustomBitmap32.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TCustomBitmap32.SaveToFile, 'SaveToFile');
    RegisterMethod(@TCustomBitmap32.LoadFromResourceID, 'LoadFromResourceID');
    RegisterMethod(@TCustomBitmap32.LoadFromResourceName, 'LoadFromResourceName');
    RegisterMethod(@TCustomBitmap32ResetAlpha_P, 'ResetAlpha');
    RegisterMethod(@TCustomBitmap32ResetAlpha1_P, 'ResetAlpha1');
    RegisterMethod(@TCustomBitmap32Draw_P, 'Draw');
    RegisterMethod(@TCustomBitmap32Draw1_P, 'Draw1');
    RegisterMethod(@TCustomBitmap32Draw2_P, 'Draw2');
    RegisterMethod(@TCustomBitmap32SetPixelT_P, 'SetPixelT');
    RegisterMethod(@TCustomBitmap32SetPixelT1_P, 'SetPixelT1');
    RegisterMethod(@TCustomBitmap32.SetPixelTS, 'SetPixelTS');
    RegisterMethod(@TCustomBitmap32DrawTo_P, 'DrawTo');
    RegisterMethod(@TCustomBitmap32DrawTo1_P, 'DrawTo1');
    RegisterMethod(@TCustomBitmap32DrawTo2_P, 'DrawTo2');
    RegisterMethod(@TCustomBitmap32DrawTo3_P, 'DrawTo3');
    RegisterMethod(@TCustomBitmap32DrawTo4_P, 'DrawTo4');
    RegisterMethod(@TCustomBitmap32SetStipple_P, 'SetStipple');
    RegisterMethod(@TCustomBitmap32SetStipple1_P, 'SetStipple1');
    RegisterMethod(@TCustomBitmap32.AdvanceStippleCounter, 'AdvanceStippleCounter');
    RegisterMethod(@TCustomBitmap32.GetStippleColor, 'GetStippleColor');
    RegisterMethod(@TCustomBitmap32.HorzLine, 'HorzLine');
    RegisterMethod(@TCustomBitmap32.HorzLineS, 'HorzLineS');
    RegisterMethod(@TCustomBitmap32.HorzLineT, 'HorzLineT');
    RegisterMethod(@TCustomBitmap32.HorzLineTS, 'HorzLineTS');
    RegisterMethod(@TCustomBitmap32.HorzLineTSP, 'HorzLineTSP');
    RegisterMethod(@TCustomBitmap32.HorzLineX, 'HorzLineX');
    RegisterMethod(@TCustomBitmap32.HorzLineXS, 'HorzLineXS');
    RegisterMethod(@TCustomBitmap32.VertLine, 'VertLine');
    RegisterMethod(@TCustomBitmap32.VertLineS, 'VertLineS');
    RegisterMethod(@TCustomBitmap32.VertLineT, 'VertLineT');
    RegisterMethod(@TCustomBitmap32.VertLineTS, 'VertLineTS');
    RegisterMethod(@TCustomBitmap32.VertLineTSP, 'VertLineTSP');
    RegisterMethod(@TCustomBitmap32.VertLineX, 'VertLineX');
    RegisterMethod(@TCustomBitmap32.VertLineXS, 'VertLineXS');
    RegisterMethod(@TCustomBitmap32.Line, 'Line');
    RegisterMethod(@TCustomBitmap32.LineS, 'LineS');
    RegisterMethod(@TCustomBitmap32.LineT, 'LineT');
    RegisterMethod(@TCustomBitmap32.LineTS, 'LineTS');
    RegisterMethod(@TCustomBitmap32.LineA, 'LineA');
    RegisterMethod(@TCustomBitmap32.LineAS, 'LineAS');
    RegisterMethod(@TCustomBitmap32.LineX, 'LineX');
    RegisterMethod(@TCustomBitmap32.LineF, 'LineF');
    RegisterMethod(@TCustomBitmap32.LineXS, 'LineXS');
    RegisterMethod(@TCustomBitmap32.LineFS, 'LineFS');
    RegisterMethod(@TCustomBitmap32.LineXP, 'LineXP');
    RegisterMethod(@TCustomBitmap32.LineFP, 'LineFP');
    RegisterMethod(@TCustomBitmap32.LineXSP, 'LineXSP');
    RegisterMethod(@TCustomBitmap32.LineFSP, 'LineFSP');
    RegisterPropertyHelper(@TCustomBitmap32PenColor_R,@TCustomBitmap32PenColor_W,'PenColor');
    RegisterMethod(@TCustomBitmap32.MoveTo, 'MoveTo');
    RegisterMethod(@TCustomBitmap32.LineToS, 'LineToS');
    RegisterMethod(@TCustomBitmap32.LineToTS, 'LineToTS');
    RegisterMethod(@TCustomBitmap32.LineToAS, 'LineToAS');
    RegisterMethod(@TCustomBitmap32.MoveToX, 'MoveToX');
    RegisterMethod(@TCustomBitmap32.MoveToF, 'MoveToF');
    RegisterMethod(@TCustomBitmap32.LineToXS, 'LineToXS');
    RegisterMethod(@TCustomBitmap32.LineToFS, 'LineToFS');
    RegisterMethod(@TCustomBitmap32.LineToXSP, 'LineToXSP');
    RegisterMethod(@TCustomBitmap32.LineToFSP, 'LineToFSP');
    RegisterMethod(@TCustomBitmap32.FillRect, 'FillRect');
    RegisterMethod(@TCustomBitmap32FillRectS_P, 'FillRectS');
    RegisterMethod(@TCustomBitmap32.FillRectT, 'FillRectT');
    RegisterMethod(@TCustomBitmap32.FillRectTS, 'FillRectTS');
    RegisterMethod(@TCustomBitmap32.FillRectS, 'FillRectS');
    RegisterMethod(@TCustomBitmap32.FillRectTS, 'FillRectTS');
    RegisterMethod(@TCustomBitmap32.FrameRectS, 'FrameRectS');
    RegisterMethod(@TCustomBitmap32.FrameRectTS, 'FrameRectTS');
    RegisterMethod(@TCustomBitmap32.FrameRectTSP, 'FrameRectTSP');
    RegisterMethod(@TCustomBitmap32.FrameRectS, 'FrameRectS');
    RegisterMethod(@TCustomBitmap32.FrameRectTS, 'FrameRectTS');
    RegisterMethod(@TCustomBitmap32RaiseRectTS_P, 'RaiseRectTS');
    RegisterMethod(@TCustomBitmap32RaiseRectTS1_P, 'RaiseRectTS1');
    RegisterMethod(@TCustomBitmap32.Roll, 'Roll');
    RegisterMethod(@TCustomBitmap32.FlipHorz, 'FlipHorz');
    RegisterMethod(@TCustomBitmap32.FlipVert, 'FlipVert');
    RegisterMethod(@TCustomBitmap32.Rotate90, 'Rotate90');
    RegisterMethod(@TCustomBitmap32.Rotate180, 'Rotate180');
    RegisterMethod(@TCustomBitmap32.Rotate270, 'Rotate270');
    RegisterMethod(@TCustomBitmap32.ResetClipRect, 'ResetClipRect');
    RegisterPropertyHelper(@TCustomBitmap32Pixel_R,@TCustomBitmap32Pixel_W,'Pixel');
    RegisterPropertyHelper(@TCustomBitmap32PixelS_R,@TCustomBitmap32PixelS_W,'PixelS');
    RegisterPropertyHelper(@TCustomBitmap32PixelW_R,@TCustomBitmap32PixelW_W,'PixelW');
    RegisterPropertyHelper(@TCustomBitmap32PixelX_R,@TCustomBitmap32PixelX_W,'PixelX');
    RegisterPropertyHelper(@TCustomBitmap32PixelXS_R,@TCustomBitmap32PixelXS_W,'PixelXS');
    RegisterPropertyHelper(@TCustomBitmap32PixelXW_R,@TCustomBitmap32PixelXW_W,'PixelXW');
    RegisterPropertyHelper(@TCustomBitmap32PixelF_R,@TCustomBitmap32PixelF_W,'PixelF');
    RegisterPropertyHelper(@TCustomBitmap32PixelFS_R,@TCustomBitmap32PixelFS_W,'PixelFS');
    RegisterPropertyHelper(@TCustomBitmap32PixelFW_R,@TCustomBitmap32PixelFW_W,'PixelFW');
    RegisterPropertyHelper(@TCustomBitmap32PixelFR_R,nil,'PixelFR');
    RegisterPropertyHelper(@TCustomBitmap32PixelXR_R,nil,'PixelXR');
    RegisterPropertyHelper(@TCustomBitmap32Backend_R,@TCustomBitmap32Backend_W,'Backend');
    RegisterPropertyHelper(@TCustomBitmap32DrawMode_R,@TCustomBitmap32DrawMode_W,'DrawMode');
    RegisterPropertyHelper(@TCustomBitmap32CombineMode_R,@TCustomBitmap32CombineMode_W,'CombineMode');
    RegisterPropertyHelper(@TCustomBitmap32WrapMode_R,@TCustomBitmap32WrapMode_W,'WrapMode');
    RegisterPropertyHelper(@TCustomBitmap32MasterAlpha_R,@TCustomBitmap32MasterAlpha_W,'MasterAlpha');
    RegisterPropertyHelper(@TCustomBitmap32OuterColor_R,@TCustomBitmap32OuterColor_W,'OuterColor');
    //RegisterPropertyHelper(@TCustomBitmap32StretchFilter_R,@TCustomBitmap32StretchFilter_W,'StretchFilter');
    RegisterPropertyHelper(@TCustomBitmap32ResamplerClassName_R,@TCustomBitmap32ResamplerClassName_W,'ResamplerClassName');
    RegisterPropertyHelper(@TCustomBitmap32Resampler_R,@TCustomBitmap32Resampler_W,'Resampler');
    RegisterPropertyHelper(@TCustomBitmap32OnPixelCombine_R,@TCustomBitmap32OnPixelCombine_W,'OnPixelCombine');
    RegisterPropertyHelper(@TCustomBitmap32OnAreaChanged_R,@TCustomBitmap32OnAreaChanged_W,'OnAreaChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomMap) do begin
    RegisterVirtualMethod(@TCustomMap.Delete, 'Delete');
    RegisterVirtualMethod(@TCustomMap.Empty, 'Empty');
    RegisterVirtualMethod(@TCustomMap.Resized, 'Resized');
    RegisterMethod(@TCustomMap.SetSizeFrom, 'SetSizeFrom');
    RegisterVirtualMethod(@TCustomMap.SetSize, 'SetSize');
    RegisterVirtualMethod(@TCustomMap.changed, 'changed');
    RegisterVirtualMethod(@TCustomMap.BeginUpdate, 'BeginUpdate');
    RegisterVirtualMethod(@TCustomMap.EndUpdate, 'EndUpdate');
    RegisterPropertyHelper(@TCustomMapHeight_R,@TCustomMapHeight_W,'Height');
    RegisterPropertyHelper(@TCustomMapWidth_R,@TCustomMapWidth_W,'Width');
    RegisterPropertyHelper(@TCustomMapOnResize_R,@TCustomMapOnResize_W,'OnResize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Color32, 'Color32', cdRegister);
 S.RegisterDelphiFunction(@Color321_P, 'Color321', cdRegister);
 S.RegisterDelphiFunction(@Color322_P, 'Color322', cdRegister);
 S.RegisterDelphiFunction(@Gray32, 'Gray32', cdRegister);
 S.RegisterDelphiFunction(@WinColor, 'WinColor', cdRegister);
 S.RegisterDelphiFunction(@ArrayOfColor32, 'ArrayOfColor32', cdRegister);
 S.RegisterDelphiFunction(@Color32ToRGB, 'Color32ToRGB', cdRegister);
 S.RegisterDelphiFunction(@Color32ToRGBA, 'Color32ToRGBA', cdRegister);
 S.RegisterDelphiFunction(@Color32Components, 'Color32Components', cdRegister);
 S.RegisterDelphiFunction(@RedComponent, 'RedComponent', cdRegister);
 S.RegisterDelphiFunction(@GreenComponent, 'GreenComponent', cdRegister);
 S.RegisterDelphiFunction(@BlueComponent, 'BlueComponent', cdRegister);
 S.RegisterDelphiFunction(@AlphaComponent, 'AlphaComponent', cdRegister);
 S.RegisterDelphiFunction(@Intensity, 'Intensity', cdRegister);
 S.RegisterDelphiFunction(@SetAlpha, 'SetAlpha', cdRegister);
 S.RegisterDelphiFunction(@HSLtoRGB, 'HSLtoRGB', cdRegister);
 S.RegisterDelphiFunction(@RGBtoHSL, 'RGBtoHSL', cdRegister);
 S.RegisterDelphiFunction(@HSLtoRGB1_P, 'HSLtoRGB1', cdRegister);
 S.RegisterDelphiFunction(@RGBtoHSL1_P, 'RGBtoHSL1', cdRegister);
 S.RegisterDelphiFunction(@WinPalette, 'WinPalette', cdRegister);
 S.RegisterDelphiFunction(@Fixed, 'Fixed', cdRegister);
 S.RegisterDelphiFunction(@Fixed1_P, 'Fixed1', cdRegister);
 S.RegisterDelphiFunction(@FloatPoint, 'GFloatPoint', cdRegister);
 S.RegisterDelphiFunction(@FloatPoint1_P, 'FloatPoint1', cdRegister);
 S.RegisterDelphiFunction(@FloatPoint2_P, 'FloatPoint2', cdRegister);
 S.RegisterDelphiFunction(@FixedPoint, 'FixedPoint', cdRegister);
 S.RegisterDelphiFunction(@FixedPoint1_P, 'FixedPoint1', cdRegister);
 S.RegisterDelphiFunction(@FixedPoint2_P, 'FixedPoint2', cdRegister);
 S.RegisterDelphiFunction(@FixedPoint3_P, 'FixedPoint3', cdRegister);
 S.RegisterDelphiFunction(@MakeRect, 'MakeRect', cdRegister);
 S.RegisterDelphiFunction(@MakeRect1_P, 'MakeRect1', cdRegister);
 S.RegisterDelphiFunction(@MakeRect2_P, 'MakeRect2', cdRegister);
 S.RegisterDelphiFunction(@FixedRect, 'GFixedRect', cdRegister);
 S.RegisterDelphiFunction(@FixedRect1_P, 'FixedRect1', cdRegister);
 S.RegisterDelphiFunction(@FixedRect2_P, 'FixedRect2', cdRegister);
 S.RegisterDelphiFunction(@FloatRect, 'FloatRect', cdRegister);
 S.RegisterDelphiFunction(@FloatRect1_P, 'GFloatRect1', cdRegister);
 S.RegisterDelphiFunction(@FloatRect2_P, 'FloatRect2', cdRegister);
 S.RegisterDelphiFunction(@IntersectRect, 'IntersectRect', cdRegister);
 S.RegisterDelphiFunction(@IntersectRect1_P, 'IntersectRect1', cdRegister);
 S.RegisterDelphiFunction(@UnionRect, 'GUnionRect', cdRegister);
 S.RegisterDelphiFunction(@UnionRect1_P, 'UnionRect1', cdRegister);
 S.RegisterDelphiFunction(@EqualRect, 'GEqualRect', cdRegister);
 S.RegisterDelphiFunction(@EqualRect1_P, 'EqualRect1', cdRegister);
 S.RegisterDelphiFunction(@InflateRect, 'GInflateRect', cdRegister);
 S.RegisterDelphiFunction(@InflateRect1_P, 'InflateRect1', cdRegister);
 S.RegisterDelphiFunction(@OffsetRect, 'GOffsetRect', cdRegister);
 S.RegisterDelphiFunction(@OffsetRect1_P, 'OffsetRect1', cdRegister);
 S.RegisterDelphiFunction(@IsRectEmpty, 'IsRectEmpty', cdRegister);
 S.RegisterDelphiFunction(@IsRectEmpty1_P, 'IsRectEmpty1', cdRegister);
 S.RegisterDelphiFunction(@PtInRect, 'GPtInRect', cdRegister);
 S.RegisterDelphiFunction(@PtInRect1_P, 'PtInRect1', cdRegister);
 S.RegisterDelphiFunction(@PtInRect2_P, 'PtInRect2', cdRegister);
 S.RegisterDelphiFunction(@PtInRect3_P, 'PtInRect3', cdRegister);
 S.RegisterDelphiFunction(@EqualRectSize, 'EqualRectSize', cdRegister);
 S.RegisterDelphiFunction(@EqualRectSize1_P, 'EqualRectSize1', cdRegister);
 S.RegisterDelphiFunction(@SetGamma, 'SetGamma', cdRegister);
 { RIRegister_TCustomMap(CL);
  with CL.Add(TCustomResampler) do
  with CL.Add(TCustomBackend) do
  RIRegister_TCustomBitmap32(CL);
  RIRegister_TBitmap32(CL);
  RIRegister_TCustomBackend(CL);
  RIRegister_TCustomSampler(CL);
  RIRegister_TCustomResampler(CL); }
 S.RegisterDelphiFunction(@GetPlatformBackendClass, 'GetPlatformBackendClass', cdRegister);
end;

procedure RIRegister_GR32(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomMap(CL);
  with CL.Add(TCustomResampler) do
  with CL.Add(TCustomBackend) do
  RIRegister_TCustomBitmap32(CL);
  RIRegister_TBitmap32(CL);
  RIRegister_TCustomBackend(CL);
  RIRegister_TCustomSampler(CL);
  RIRegister_TCustomResampler(CL);

end;



{ TPSImport_GR32 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GR32(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GR32(ri);
  RIRegister_GR32_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
