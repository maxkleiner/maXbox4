unit uPSI_St2DBarC;
{
   internal 2Dbarcode
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
  TPSImport_St2DBarC = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStMaxiCodeBarcode(CL: TPSPascalCompiler);
procedure SIRegister_TStPDF417Barcode(CL: TPSPascalCompiler);
procedure SIRegister_TStCustom2DBarcode(CL: TPSPascalCompiler);
procedure SIRegister_St2DBarC(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStMaxiCodeBarcode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStPDF417Barcode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStCustom2DBarcode(CL: TPSRuntimeClassImporter);
procedure RIRegister_St2DBarC(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Controls
  ,Graphics
  ,StdCtrls
  ,Math
  ,ClipBrd
  ,StConst
  ,St2DBarC
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_St2DBarC]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStMaxiCodeBarcode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStCustom2DBarcode', 'TStMaxiCodeBarcode') do
  with CL.AddClassN(CL.FindClass('TStCustom2DBarcode'),'TStMaxiCodeBarcode') do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free;');
      RegisterMethod('Procedure RenderToResolution( var OutBitmap : TBitmap; ResX : Integer; ResY : Integer; var SizeX : Integer; var SizeY : Integer)');
    RegisterProperty('AutoScale', 'Boolean', iptrw);
    RegisterProperty('CarrierCountryCode', 'Integer', iptrw);
    RegisterProperty('CarrierPostalCode', 'string', iptrw);
    RegisterProperty('CarrierServiceClass', 'Integer', iptrw);
    RegisterProperty('HorPixelsPerMM', 'Extended', iptrw);
    RegisterProperty('Mode', 'TStMaxiCodeMode', iptrw);
    RegisterProperty('VerPixelsPerMM', 'Extended', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStPDF417Barcode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStCustom2DBarcode', 'TStPDF417Barcode') do
  with CL.AddClassN(CL.FindClass('TStCustom2DBarcode'),'TStPDF417Barcode') do begin
      RegisterPublishedProperties;
      RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
     RegisterMethod('Procedure RenderToResolution( var OutBitmap : TBitmap; ResX : Integer; ResY : Integer; var SizeX : Integer; var SizeY : Integer)');
    RegisterProperty('ECCLevel', 'TStPDF417ECCLevels', iptrw);
    RegisterProperty('NumColumns', 'Integer', iptrw);
    RegisterProperty('NumRows', 'Integer', iptrw);
    RegisterProperty('Truncated', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStCustom2DBarcode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TStCustom2DBarcode') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TStCustom2DBarcode') do begin
      RegisterPublishedProperties;
      RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
     RegisterMethod('Procedure CopyToClipboard');
    RegisterMethod('Procedure CopyToClipboardRes( ResX : Integer; ResY : Integer)');
    RegisterMethod('Procedure PaintToCanvas( ACanvas : TCanvas; Position : TPoint)');
    RegisterMethod('Procedure PaintToCanvasRes( ACanvas : TCanvas; Position : TPoint; ResX : Integer; ResY : Integer)');
    RegisterMethod('Procedure PaintToCanvasSize( ACanvas : TCanvas; X, Y, H : Double)');
    RegisterMethod('Procedure PaintToDC( DC : hDC; Position : TPoint)');
    RegisterMethod('Procedure PaintToDCRes( DC : hDC; Position : TPoint; ResX : Integer; ResY : Integer)');
    RegisterMethod('Procedure PaintToPrinterCanvas( ACanvas : TCanvas; Position : TPoint)');
    RegisterMethod('Procedure PaintToPrinterCanvasRes( ACanvas : TCanvas; Position : TPoint; ResX : Integer; ResY : Integer)');
    RegisterMethod('Procedure PaintToPrinterCanvasSize( ACanvas : TCanvas; X, Y, H : Double)');
    RegisterMethod('Procedure PaintToPrinterDC( DC : hDC; Position : TPoint)');
    RegisterMethod('Procedure PaintToPrinterDCRes( DC : hDC; Position : TPoint; ResX : Integer; ResY : Integer)');
    RegisterMethod('Procedure RenderToResolution( var OutBitmap : TBitmap; ResX : Integer; ResY : Integer; var SizeX : Integer; var SizeY : Integer)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure SaveToFileRes( const FileName : string; ResX : Integer; ResY : Integer)');
    RegisterProperty('Alignment', 'TAlignment', iptrw);
    RegisterProperty('BackgroundColor', 'TColor', iptrw);
    RegisterProperty('BarCodeHeight', 'Integer', iptr);
    RegisterProperty('BarCodeRect', 'TRect', iptr);
    RegisterProperty('BarCodeWidth', 'Integer', iptr);
    RegisterProperty('BarHeight', 'Integer', iptrw);
    RegisterProperty('BarHeightToWidth', 'Integer', iptrw);
    RegisterProperty('BarWidth', 'Integer', iptrw);
    RegisterProperty('Bitmap', 'TBitmap', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('CaptionLayout', 'TTextLayout', iptrw);
    RegisterProperty('Code', 'string', iptrw);
    RegisterProperty('ECCLevel', 'Integer', iptrw);
    RegisterProperty('ExtendedSyntax', 'Boolean', iptrw);
    RegisterProperty('FreeCodewords', 'Integer', iptr);
    RegisterProperty('RelativeBarHeight', 'Boolean', iptrw);
    RegisterProperty('QuietZone', 'Integer', iptrw);
    RegisterProperty('TotalCodewords', 'Integer', iptr);
    RegisterProperty('UsedCodewords', 'Integer', iptr);
    RegisterProperty('UsedECCCodewords', 'Integer', iptr);
    RegisterProperty('Version', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_St2DBarC(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('StEBadBarHeight','String').SetString( 'Bar Height cannot be less than one');
 CL.AddConstantN('StEBadBarHeightToWidth','String').SetString( 'BarHeightToWidth cannot be less than one');
 CL.AddConstantN('StEBadBarWidth','String').SetString( 'Bar Width cannot be less than one');
 CL.AddConstantN('StEBadCountryCode','String').SetString( 'Invalid Country Code');
 CL.AddConstantN('StEBadNumCols','String').SetString( 'Invalid Number of columns');
 CL.AddConstantN('StEBadNumRows','String').SetString( 'Invalid number of rows');
 CL.AddConstantN('StEBadPostalCode','String').SetString( 'Invalid Postal Code');
 CL.AddConstantN('StEBadServiceClass','String').SetString( 'Invalid Service Class');
 CL.AddConstantN('StEBadQuietZone','String').SetString( 'Invalid Quiet Zone');
 CL.AddConstantN('StECodeTooLarge','String').SetString( 'Code too large for barcode');
 CL.AddConstantN('StEGLIOutOfRange','String').SetString( 'GLI value out of range');
 CL.AddConstantN('StEInvalidCodeword','String').SetString( 'Invalid Codeword');
 CL.AddConstantN('StENeedBarHeight','String').SetString( 'Either BarHeight or BarHeightToWidth is required');
 CL.AddConstantN('StENeedHorz','String').SetString( 'Horizontal size needs to be specified');
 CL.AddConstantN('StENeedVert','String').SetString( 'Vertical size needs to be specified');
  CL.AddTypeS('TStDataMode', '( dmBinary, dmText, dmNumeric )');
  CL.AddTypeS('TStPDF417ECCLevels', '( ecAuto, ecLevel0, ecLevel1, ecLevel2, ec'
   +'Level3, ecLevel4, ecLevel5, ecLevel6, ecLevel7, ecLevel8 )');
  CL.AddTypeS('TStMaxiCodeMode', '( cmMode2, cmMode3, cmMode4, cmMode5, cmMode6)');
 CL.AddConstantN('StMaxiCodeGaloisField','LongInt').SetInt( 64);
 CL.AddConstantN('StMaxiCodeECCPoly','LongInt').SetInt( 67);
 CL.AddConstantN('StMaxMaxiCodeECCDataSize','LongInt').SetInt( 144);
  CL.AddTypeS('TStMaxiCodeECCPoly', '( epPrimary, epStandard, epEnhanced )');
  CL.AddTypeS('TStMaxiCodeECCInterleave', '( imNone, imEven, imOdd )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'E2DBarcodeError');
  SIRegister_TStCustom2DBarcode(CL);
  SIRegister_TStPDF417Barcode(CL);
  SIRegister_TStMaxiCodeBarcode(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeVerPixelsPerMM_W(Self: TStMaxiCodeBarcode; const T: Extended);
begin Self.VerPixelsPerMM := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeVerPixelsPerMM_R(Self: TStMaxiCodeBarcode; var T: Extended);
begin T := Self.VerPixelsPerMM; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeMode_W(Self: TStMaxiCodeBarcode; const T: TStMaxiCodeMode);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeMode_R(Self: TStMaxiCodeBarcode; var T: TStMaxiCodeMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeHorPixelsPerMM_W(Self: TStMaxiCodeBarcode; const T: Extended);
begin Self.HorPixelsPerMM := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeHorPixelsPerMM_R(Self: TStMaxiCodeBarcode; var T: Extended);
begin T := Self.HorPixelsPerMM; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeCarrierServiceClass_W(Self: TStMaxiCodeBarcode; const T: Integer);
begin Self.CarrierServiceClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeCarrierServiceClass_R(Self: TStMaxiCodeBarcode; var T: Integer);
begin T := Self.CarrierServiceClass; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeCarrierPostalCode_W(Self: TStMaxiCodeBarcode; const T: string);
begin Self.CarrierPostalCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeCarrierPostalCode_R(Self: TStMaxiCodeBarcode; var T: string);
begin T := Self.CarrierPostalCode; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeCarrierCountryCode_W(Self: TStMaxiCodeBarcode; const T: Integer);
begin Self.CarrierCountryCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeCarrierCountryCode_R(Self: TStMaxiCodeBarcode; var T: Integer);
begin T := Self.CarrierCountryCode; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeAutoScale_W(Self: TStMaxiCodeBarcode; const T: Boolean);
begin Self.AutoScale := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMaxiCodeBarcodeAutoScale_R(Self: TStMaxiCodeBarcode; var T: Boolean);
begin T := Self.AutoScale; end;

(*----------------------------------------------------------------------------*)
procedure TStPDF417BarcodeTruncated_W(Self: TStPDF417Barcode; const T: Boolean);
begin Self.Truncated := T; end;

(*----------------------------------------------------------------------------*)
procedure TStPDF417BarcodeTruncated_R(Self: TStPDF417Barcode; var T: Boolean);
begin T := Self.Truncated; end;

(*----------------------------------------------------------------------------*)
procedure TStPDF417BarcodeNumRows_W(Self: TStPDF417Barcode; const T: Integer);
begin Self.NumRows := T; end;

(*----------------------------------------------------------------------------*)
procedure TStPDF417BarcodeNumRows_R(Self: TStPDF417Barcode; var T: Integer);
begin T := Self.NumRows; end;

(*----------------------------------------------------------------------------*)
procedure TStPDF417BarcodeNumColumns_W(Self: TStPDF417Barcode; const T: Integer);
begin Self.NumColumns := T; end;

(*----------------------------------------------------------------------------*)
procedure TStPDF417BarcodeNumColumns_R(Self: TStPDF417Barcode; var T: Integer);
begin T := Self.NumColumns; end;

(*----------------------------------------------------------------------------*)
procedure TStPDF417BarcodeECCLevel_W(Self: TStPDF417Barcode; const T: TStPDF417ECCLevels);
begin Self.ECCLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TStPDF417BarcodeECCLevel_R(Self: TStPDF417Barcode; var T: TStPDF417ECCLevels);
begin T := Self.ECCLevel; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeVersion_W(Self: TStCustom2DBarcode; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeVersion_R(Self: TStCustom2DBarcode; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeUsedECCCodewords_R(Self: TStCustom2DBarcode; var T: Integer);
begin T := Self.UsedECCCodewords; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeUsedCodewords_R(Self: TStCustom2DBarcode; var T: Integer);
begin T := Self.UsedCodewords; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeTotalCodewords_R(Self: TStCustom2DBarcode; var T: Integer);
begin T := Self.TotalCodewords; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeQuietZone_W(Self: TStCustom2DBarcode; const T: Integer);
begin Self.QuietZone := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeQuietZone_R(Self: TStCustom2DBarcode; var T: Integer);
begin T := Self.QuietZone; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeRelativeBarHeight_W(Self: TStCustom2DBarcode; const T: Boolean);
begin Self.RelativeBarHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeRelativeBarHeight_R(Self: TStCustom2DBarcode; var T: Boolean);
begin T := Self.RelativeBarHeight; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeFreeCodewords_R(Self: TStCustom2DBarcode; var T: Integer);
begin T := Self.FreeCodewords; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeExtendedSyntax_W(Self: TStCustom2DBarcode; const T: Boolean);
begin Self.ExtendedSyntax := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeExtendedSyntax_R(Self: TStCustom2DBarcode; var T: Boolean);
begin T := Self.ExtendedSyntax; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeECCLevel_W(Self: TStCustom2DBarcode; const T: Integer);
begin Self.ECCLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeECCLevel_R(Self: TStCustom2DBarcode; var T: Integer);
begin T := Self.ECCLevel; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeCode_W(Self: TStCustom2DBarcode; const T: string);
begin Self.Code := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeCode_R(Self: TStCustom2DBarcode; var T: string);
begin T := Self.Code; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeCaptionLayout_W(Self: TStCustom2DBarcode; const T: TTextLayout);
begin Self.CaptionLayout := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeCaptionLayout_R(Self: TStCustom2DBarcode; var T: TTextLayout);
begin T := Self.CaptionLayout; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeCaption_W(Self: TStCustom2DBarcode; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeCaption_R(Self: TStCustom2DBarcode; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBitmap_W(Self: TStCustom2DBarcode; const T: TBitmap);
begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBitmap_R(Self: TStCustom2DBarcode; var T: TBitmap);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBarWidth_W(Self: TStCustom2DBarcode; const T: Integer);
begin Self.BarWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBarWidth_R(Self: TStCustom2DBarcode; var T: Integer);
begin T := Self.BarWidth; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBarHeightToWidth_W(Self: TStCustom2DBarcode; const T: Integer);
begin Self.BarHeightToWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBarHeightToWidth_R(Self: TStCustom2DBarcode; var T: Integer);
begin T := Self.BarHeightToWidth; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBarHeight_W(Self: TStCustom2DBarcode; const T: Integer);
begin Self.BarHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBarHeight_R(Self: TStCustom2DBarcode; var T: Integer);
begin T := Self.BarHeight; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBarCodeWidth_R(Self: TStCustom2DBarcode; var T: Integer);
begin T := Self.BarCodeWidth; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBarCodeRect_R(Self: TStCustom2DBarcode; var T: TRect);
begin T := Self.BarCodeRect; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBarCodeHeight_R(Self: TStCustom2DBarcode; var T: Integer);
begin T := Self.BarCodeHeight; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBackgroundColor_W(Self: TStCustom2DBarcode; const T: TColor);
begin Self.BackgroundColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeBackgroundColor_R(Self: TStCustom2DBarcode; var T: TColor);
begin T := Self.BackgroundColor; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeAlignment_W(Self: TStCustom2DBarcode; const T: TAlignment);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCustom2DBarcodeAlignment_R(Self: TStCustom2DBarcode; var T: TAlignment);
begin T := Self.Alignment; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStMaxiCodeBarcode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStMaxiCodeBarcode) do begin
    RegisterConstructor(@TStMaxiCodeBarcode.Create, 'Create');
      RegisterMethod(@TStMaxiCodeBarcode.Destroy, 'Free');
      RegisterMethod(@TStMaxiCodeBarcode.RenderToResolution, 'RenderToResolution');
    RegisterPropertyHelper(@TStMaxiCodeBarcodeAutoScale_R,@TStMaxiCodeBarcodeAutoScale_W,'AutoScale');
    RegisterPropertyHelper(@TStMaxiCodeBarcodeCarrierCountryCode_R,@TStMaxiCodeBarcodeCarrierCountryCode_W,'CarrierCountryCode');
    RegisterPropertyHelper(@TStMaxiCodeBarcodeCarrierPostalCode_R,@TStMaxiCodeBarcodeCarrierPostalCode_W,'CarrierPostalCode');
    RegisterPropertyHelper(@TStMaxiCodeBarcodeCarrierServiceClass_R,@TStMaxiCodeBarcodeCarrierServiceClass_W,'CarrierServiceClass');
    RegisterPropertyHelper(@TStMaxiCodeBarcodeHorPixelsPerMM_R,@TStMaxiCodeBarcodeHorPixelsPerMM_W,'HorPixelsPerMM');
    RegisterPropertyHelper(@TStMaxiCodeBarcodeMode_R,@TStMaxiCodeBarcodeMode_W,'Mode');
    RegisterPropertyHelper(@TStMaxiCodeBarcodeVerPixelsPerMM_R,@TStMaxiCodeBarcodeVerPixelsPerMM_W,'VerPixelsPerMM');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStPDF417Barcode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStPDF417Barcode) do begin
    RegisterConstructor(@TStPDF417Barcode.Create, 'Create');
      RegisterMethod(@TStPDF417Barcode.Destroy, 'Free');
      RegisterMethod(@TStPDF417Barcode.RenderToResolution, 'RenderToResolution');
    RegisterPropertyHelper(@TStPDF417BarcodeECCLevel_R,@TStPDF417BarcodeECCLevel_W,'ECCLevel');
    RegisterPropertyHelper(@TStPDF417BarcodeNumColumns_R,@TStPDF417BarcodeNumColumns_W,'NumColumns');
    RegisterPropertyHelper(@TStPDF417BarcodeNumRows_R,@TStPDF417BarcodeNumRows_W,'NumRows');
    RegisterPropertyHelper(@TStPDF417BarcodeTruncated_R,@TStPDF417BarcodeTruncated_W,'Truncated');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStCustom2DBarcode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStCustom2DBarcode) do begin
    RegisterConstructor(@TStCustom2DBarcode.Create, 'Create');
      RegisterMethod(@TStCustom2DBarcode.Destroy, 'Free');
      RegisterMethod(@TStCustom2DBarcode.CopyToClipboard, 'CopyToClipboard');
    RegisterMethod(@TStCustom2DBarcode.CopyToClipboardRes, 'CopyToClipboardRes');
    RegisterMethod(@TStCustom2DBarcode.PaintToCanvas, 'PaintToCanvas');
    RegisterMethod(@TStCustom2DBarcode.PaintToCanvasRes, 'PaintToCanvasRes');
    RegisterMethod(@TStCustom2DBarcode.PaintToCanvasSize, 'PaintToCanvasSize');
    RegisterMethod(@TStCustom2DBarcode.PaintToDC, 'PaintToDC');
    RegisterMethod(@TStCustom2DBarcode.PaintToDCRes, 'PaintToDCRes');
    RegisterMethod(@TStCustom2DBarcode.PaintToPrinterCanvas, 'PaintToPrinterCanvas');
    RegisterMethod(@TStCustom2DBarcode.PaintToPrinterCanvasRes, 'PaintToPrinterCanvasRes');
    RegisterMethod(@TStCustom2DBarcode.PaintToPrinterCanvasSize, 'PaintToPrinterCanvasSize');
    RegisterMethod(@TStCustom2DBarcode.PaintToPrinterDC, 'PaintToPrinterDC');
    RegisterMethod(@TStCustom2DBarcode.PaintToPrinterDCRes, 'PaintToPrinterDCRes');
    //RegisterVirtualAbstractMethod(@TStCustom2DBarcode, @!.RenderToResolution, 'RenderToResolution');
    RegisterMethod(@TStCustom2DBarcode.SaveToFile, 'SaveToFile');
    RegisterMethod(@TStCustom2DBarcode.SaveToFileRes, 'SaveToFileRes');
    RegisterPropertyHelper(@TStCustom2DBarcodeAlignment_R,@TStCustom2DBarcodeAlignment_W,'Alignment');
    RegisterPropertyHelper(@TStCustom2DBarcodeBackgroundColor_R,@TStCustom2DBarcodeBackgroundColor_W,'BackgroundColor');
    RegisterPropertyHelper(@TStCustom2DBarcodeBarCodeHeight_R,nil,'BarCodeHeight');
    RegisterPropertyHelper(@TStCustom2DBarcodeBarCodeRect_R,nil,'BarCodeRect');
    RegisterPropertyHelper(@TStCustom2DBarcodeBarCodeWidth_R,nil,'BarCodeWidth');
    RegisterPropertyHelper(@TStCustom2DBarcodeBarHeight_R,@TStCustom2DBarcodeBarHeight_W,'BarHeight');
    RegisterPropertyHelper(@TStCustom2DBarcodeBarHeightToWidth_R,@TStCustom2DBarcodeBarHeightToWidth_W,'BarHeightToWidth');
    RegisterPropertyHelper(@TStCustom2DBarcodeBarWidth_R,@TStCustom2DBarcodeBarWidth_W,'BarWidth');
    RegisterPropertyHelper(@TStCustom2DBarcodeBitmap_R,@TStCustom2DBarcodeBitmap_W,'Bitmap');
    RegisterPropertyHelper(@TStCustom2DBarcodeCaption_R,@TStCustom2DBarcodeCaption_W,'Caption');
    RegisterPropertyHelper(@TStCustom2DBarcodeCaptionLayout_R,@TStCustom2DBarcodeCaptionLayout_W,'CaptionLayout');
    RegisterPropertyHelper(@TStCustom2DBarcodeCode_R,@TStCustom2DBarcodeCode_W,'Code');
    RegisterPropertyHelper(@TStCustom2DBarcodeECCLevel_R,@TStCustom2DBarcodeECCLevel_W,'ECCLevel');
    RegisterPropertyHelper(@TStCustom2DBarcodeExtendedSyntax_R,@TStCustom2DBarcodeExtendedSyntax_W,'ExtendedSyntax');
    RegisterPropertyHelper(@TStCustom2DBarcodeFreeCodewords_R,nil,'FreeCodewords');
    RegisterPropertyHelper(@TStCustom2DBarcodeRelativeBarHeight_R,@TStCustom2DBarcodeRelativeBarHeight_W,'RelativeBarHeight');
    RegisterPropertyHelper(@TStCustom2DBarcodeQuietZone_R,@TStCustom2DBarcodeQuietZone_W,'QuietZone');
    RegisterPropertyHelper(@TStCustom2DBarcodeTotalCodewords_R,nil,'TotalCodewords');
    RegisterPropertyHelper(@TStCustom2DBarcodeUsedCodewords_R,nil,'UsedCodewords');
    RegisterPropertyHelper(@TStCustom2DBarcodeUsedECCCodewords_R,nil,'UsedECCCodewords');
    RegisterPropertyHelper(@TStCustom2DBarcodeVersion_R,@TStCustom2DBarcodeVersion_W,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_St2DBarC(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(E2DBarcodeError) do
  RIRegister_TStCustom2DBarcode(CL);
  RIRegister_TStPDF417Barcode(CL);
  RIRegister_TStMaxiCodeBarcode(CL);
end;

 
 
{ TPSImport_St2DBarC }
(*----------------------------------------------------------------------------*)
procedure TPSImport_St2DBarC.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_St2DBarC(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_St2DBarC.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_St2DBarC(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
