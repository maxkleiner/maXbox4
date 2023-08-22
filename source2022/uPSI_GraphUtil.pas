unit uPSI_GraphUtil;
{

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
  TPSImport_GraphUtil = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_GraphUtil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GraphUtil_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,GraphUtil
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GraphUtil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_GraphUtil(CL: TPSPascalCompiler);
begin

{type
  TIdentMapEntry = record
    Value: Integer;
    Name: String;
  end;}
  CL.AddTypeS('TIdentMapEntry', 'record Value: Integer; Name: String; end');
             //tcolorref
  CL.AddTypeS('TColorRef','DWORD');
  CL.AddTypeS('TColorArray', 'array of TIdentMapEntry');
 CL.AddConstantN('WebNamedColorsCount','LongInt').SetInt( 138);
  CL.AddTypeS('TScrollDirection', '( sdLeft, sdRight, sdUp, sdDown )');
  CL.AddTypeS('TArrowType', '( atSolid, atArrows )');
 CL.AddDelphiFunction('Function GetHighLightColor( const Color : TColor; Luminance : Integer) : TColor');
 CL.AddDelphiFunction('Function GetShadowColor( const Color : TColor; Luminance : Integer) : TColor');
 CL.AddDelphiFunction('Procedure DrawCheck( ACanvas : TCanvas; Location : TPoint; Size : Integer; Shadow : Boolean)');
 CL.AddDelphiFunction('Procedure DrawChevron( ACanvas : TCanvas; Direction : TScrollDirection; Location : TPoint; Size : Integer)');
 CL.AddDelphiFunction('Procedure DrawArrow( ACanvas : TCanvas; Direction : TScrollDirection; Location : TPoint; Size : Integer)');
 CL.AddDelphiFunction('Procedure ColorRGBToHLS( clrRGB : TColorRef; var Hue, Luminance, Saturation : Word)');
 CL.AddDelphiFunction('Function ColorHLSToRGB( Hue, Luminance, Saturation : Word) : TColorRef');
 CL.AddDelphiFunction('Function ColorAdjustLuma( clrRGB : TColor; n : Integer; fScale :BOOLean) : TColor');
  CL.AddTypeS('TGradientDirection', '( gdHorizontal, gdVertical )');
 CL.AddDelphiFunction('Procedure GradientFillCanvas( const ACanvas : TCanvas; const AStartColor, AEndColor : TColor; const ARect : TRect; const Direction : TGradientDirection)');
 CL.AddDelphiFunction('Procedure ScaleImage( const SourceBitmap, ResizedBitmap : TBitmap; const ScaleAmount : Double)');
 CL.AddDelphiFunction('Function ColorToWebColorStr( Color : TColor) : string');
 CL.AddDelphiFunction('Function ColorToWebColorName( Color : TColor) : string');
 CL.AddDelphiFunction('Function WebColorToRGB( WebColor : Integer) : Integer');
 CL.AddDelphiFunction('Function RGBToWebColorStr( RGB : Integer) : string');
 CL.AddDelphiFunction('Function RGBToWebColorName( RGB : Integer) : string');
 CL.AddDelphiFunction('Function WebColorNameToColor( WebColorName : string) : TColor');
 CL.AddDelphiFunction('Function WebColorStrToColor( WebColor : string) : TColor');
  CL.AddTypeS('TColorArraySortType', '( stHue, stSaturation, stLuminance, stRed'
   +', stGreen, stBlue, stCombo )');
 CL.AddDelphiFunction('Procedure SortColorArray(ColorArray: TColorArray; L,R: Integer; SortType : TColorArraySortType; Reverse : Boolean)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_GraphUtil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetHighLightColor, 'GetHighLightColor', cdRegister);
 S.RegisterDelphiFunction(@GetShadowColor, 'GetShadowColor', cdRegister);
 S.RegisterDelphiFunction(@DrawCheck, 'DrawCheck', cdRegister);
 S.RegisterDelphiFunction(@DrawChevron, 'DrawChevron', cdRegister);
 S.RegisterDelphiFunction(@DrawArrow, 'DrawArrow', cdRegister);
 S.RegisterDelphiFunction(@ColorRGBToHLS, 'ColorRGBToHLS', cdRegister);
 S.RegisterDelphiFunction(@ColorHLSToRGB, 'ColorHLSToRGB', cdRegister);
 S.RegisterDelphiFunction(@ColorAdjustLuma, 'ColorAdjustLuma', cdRegister);
 S.RegisterDelphiFunction(@GradientFillCanvas, 'GradientFillCanvas', cdRegister);
 S.RegisterDelphiFunction(@ScaleImage, 'ScaleImage', cdRegister);
 S.RegisterDelphiFunction(@ColorToWebColorStr, 'ColorToWebColorStr', cdRegister);
 S.RegisterDelphiFunction(@ColorToWebColorName, 'ColorToWebColorName', cdRegister);
 S.RegisterDelphiFunction(@WebColorToRGB, 'WebColorToRGB', cdRegister);
 S.RegisterDelphiFunction(@RGBToWebColorStr, 'RGBToWebColorStr', cdRegister);
 S.RegisterDelphiFunction(@RGBToWebColorName, 'RGBToWebColorName', cdRegister);
 S.RegisterDelphiFunction(@WebColorNameToColor, 'WebColorNameToColor', cdRegister);
 S.RegisterDelphiFunction(@WebColorStrToColor, 'WebColorStrToColor', cdRegister);
 S.RegisterDelphiFunction(@SortColorArray, 'SortColorArray', cdRegister);
end;

 
 
{ TPSImport_GraphUtil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GraphUtil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GraphUtil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GraphUtil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_GraphUtil(ri);
  RIRegister_GraphUtil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
