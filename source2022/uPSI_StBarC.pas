unit uPSI_StBarC;
{
  barchart c for scholz
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
  TPSImport_StBarC = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStBarCode(CL: TPSPascalCompiler);
procedure SIRegister_TStBarCodeInfo(CL: TPSPascalCompiler);
procedure SIRegister_TStBarData(CL: TPSPascalCompiler);
procedure SIRegister_StBarC(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStBarCode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStBarCodeInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStBarData(CL: TPSRuntimeClassImporter);
procedure RIRegister_StBarC(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ClipBrd
  ,Controls
  ,Graphics
  ,Messages
  ,StBase
  ,StConst
  ,StBarC
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StBarC]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStBarCode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TStBarCode') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TStBarCode') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure CopyToClipboard');
    RegisterMethod('Procedure GetCheckCharacters( const S : string; var C, K : Integer)');
    RegisterMethod('Function GetBarCodeWidth( ACanvas : TCanvas) : Double');
    RegisterMethod('Procedure PaintToCanvas( ACanvas : TCanvas; ARect : TRect)');
    RegisterMethod('Procedure PaintToCanvasSize( ACanvas : TCanvas; X, Y, H : Double)');
    RegisterMethod('Procedure PaintToDC( DC : hDC; ARect : TRect)');
    RegisterMethod('Procedure PaintToDCSize( DC : hDC; X, Y, W, H : Double)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Function Validate( DisplayError : Boolean) : Boolean');
    RegisterProperty('AddCheckChar', 'Boolean', iptrw);
    RegisterProperty('BarCodeType', 'TStBarCodeType', iptrw);
    RegisterProperty('BarColor', 'TColor', iptrw);
    RegisterProperty('BarToSpaceRatio', 'Double', iptrw);
    RegisterProperty('BarNarrowToWideRatio', 'Integer', iptrw);
    RegisterProperty('BarWidth', 'Double', iptrw);
    RegisterProperty('BearerBars', 'Boolean', iptrw);
    RegisterProperty('Code', 'string', iptrw);
    RegisterProperty('Code128Subset', 'TStCode128CodeSubset', iptrw);
    RegisterProperty('ExtendedSyntax', 'Boolean', iptrw);
    RegisterProperty('ShowCode', 'Boolean', iptrw);
    RegisterProperty('ShowGuardChars', 'Boolean', iptrw);
    RegisterProperty('SupplementalCode', 'string', iptrw);
    RegisterProperty('TallGuardBars', 'Boolean', iptrw);
    RegisterProperty('Version', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStBarCodeInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStBarCodeInfo') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStBarCodeInfo') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Add( ModuleCount : Integer; BarKind : TStBarKindSet)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Bars', 'TStBarData Integer', iptr);
    SetDefaultPropery('Bars');
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStBarData(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStBarData') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStBarData') do begin
    RegisterProperty('FKind', 'TStBarKindSet', iptrw);
    RegisterProperty('FModules', 'Integer', iptrw);
    RegisterProperty('Kind', 'TStBarKindSet', iptrw);
    RegisterProperty('Modules', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StBarC(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('bcMaxBarCodeLen','LongInt').SetInt( 255);
 //CL.AddConstantN('bcGuardBarAbove','Boolean').SetBool( True);
 //CL.AddConstantN('bcGuardBarBelow','Boolean')BoolToStr( True);
 CL.AddConstantN('bcDefNarrowToWideRatio','LongInt').SetInt( 2);
  CL.AddTypeS('TStBarKind','(bkSpace, bkBar, bkThreeQuarterBar, bkHalfBar, bkGuard, bkSupplement, bkBlankSpace )');
  CL.AddTypeS('TStBarKindSet', 'set of TStBarKind');
  SIRegister_TStBarData(CL);
  SIRegister_TStBarCodeInfo(CL);
  CL.AddTypeS('TStBarCodeType', '( bcUPC_A, bcUPC_E, bcEAN_8, bcEAN_13, bcInter'
   +'leaved2of5, bcCodabar, bcCode11, bcCode39, bcCode93, bcCode128 )');
  CL.AddTypeS('TStCode128CodeSubset', '( csCodeA, csCodeB, csCodeC )');
  SIRegister_TStBarCode(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStBarCodeVersion_W(Self: TStBarCode; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeVersion_R(Self: TStBarCode; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeTallGuardBars_W(Self: TStBarCode; const T: Boolean);
begin Self.TallGuardBars := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeTallGuardBars_R(Self: TStBarCode; var T: Boolean);
begin T := Self.TallGuardBars; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeSupplementalCode_W(Self: TStBarCode; const T: string);
begin Self.SupplementalCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeSupplementalCode_R(Self: TStBarCode; var T: string);
begin T := Self.SupplementalCode; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeShowGuardChars_W(Self: TStBarCode; const T: Boolean);
begin Self.ShowGuardChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeShowGuardChars_R(Self: TStBarCode; var T: Boolean);
begin T := Self.ShowGuardChars; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeShowCode_W(Self: TStBarCode; const T: Boolean);
begin Self.ShowCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeShowCode_R(Self: TStBarCode; var T: Boolean);
begin T := Self.ShowCode; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeExtendedSyntax_W(Self: TStBarCode; const T: Boolean);
begin Self.ExtendedSyntax := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeExtendedSyntax_R(Self: TStBarCode; var T: Boolean);
begin T := Self.ExtendedSyntax; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeCode128Subset_W(Self: TStBarCode; const T: TStCode128CodeSubset);
begin Self.Code128Subset := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeCode128Subset_R(Self: TStBarCode; var T: TStCode128CodeSubset);
begin T := Self.Code128Subset; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeCode_W(Self: TStBarCode; const T: string);
begin Self.Code := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeCode_R(Self: TStBarCode; var T: string);
begin T := Self.Code; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBearerBars_W(Self: TStBarCode; const T: Boolean);
begin Self.BearerBars := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBearerBars_R(Self: TStBarCode; var T: Boolean);
begin T := Self.BearerBars; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBarWidth_W(Self: TStBarCode; const T: Double);
begin Self.BarWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBarWidth_R(Self: TStBarCode; var T: Double);
begin T := Self.BarWidth; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBarNarrowToWideRatio_W(Self: TStBarCode; const T: Integer);
begin Self.BarNarrowToWideRatio := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBarNarrowToWideRatio_R(Self: TStBarCode; var T: Integer);
begin T := Self.BarNarrowToWideRatio; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBarToSpaceRatio_W(Self: TStBarCode; const T: Double);
begin Self.BarToSpaceRatio := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBarToSpaceRatio_R(Self: TStBarCode; var T: Double);
begin T := Self.BarToSpaceRatio; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBarColor_W(Self: TStBarCode; const T: TColor);
begin Self.BarColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBarColor_R(Self: TStBarCode; var T: TColor);
begin T := Self.BarColor; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBarCodeType_W(Self: TStBarCode; const T: TStBarCodeType);
begin Self.BarCodeType := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeBarCodeType_R(Self: TStBarCode; var T: TStBarCodeType);
begin T := Self.BarCodeType; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeAddCheckChar_W(Self: TStBarCode; const T: Boolean);
begin Self.AddCheckChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeAddCheckChar_R(Self: TStBarCode; var T: Boolean);
begin T := Self.AddCheckChar; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeInfoCount_R(Self: TStBarCodeInfo; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TStBarCodeInfoBars_R(Self: TStBarCodeInfo; var T: TStBarData; const t1: Integer);
begin T := Self.Bars[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStBarDataModules_W(Self: TStBarData; const T: Integer);
begin Self.Modules := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarDataModules_R(Self: TStBarData; var T: Integer);
begin T := Self.Modules; end;

(*----------------------------------------------------------------------------*)
procedure TStBarDataKind_W(Self: TStBarData; const T: TStBarKindSet);
begin Self.Kind := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarDataKind_R(Self: TStBarData; var T: TStBarKindSet);
begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TStBarDataFModules_W(Self: TStBarData; const T: Integer);
Begin Self.FModules := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarDataFModules_R(Self: TStBarData; var T: Integer);
Begin T := Self.FModules; end;

(*----------------------------------------------------------------------------*)
procedure TStBarDataFKind_W(Self: TStBarData; const T: TStBarKindSet);
Begin Self.FKind := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBarDataFKind_R(Self: TStBarData; var T: TStBarKindSet);
Begin T := Self.FKind; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStBarCode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStBarCode) do begin
    RegisterConstructor(@TStBarCode.Create, 'Create');
    RegisterMethod(@TStBarCode.Destroy, 'Free');
    RegisterMethod(@TStBarCode.CopyToClipboard, 'CopyToClipboard');
    RegisterMethod(@TStBarCode.GetCheckCharacters, 'GetCheckCharacters');
    RegisterMethod(@TStBarCode.GetBarCodeWidth, 'GetBarCodeWidth');
    RegisterMethod(@TStBarCode.PaintToCanvas, 'PaintToCanvas');
    RegisterMethod(@TStBarCode.PaintToCanvasSize, 'PaintToCanvasSize');
    RegisterMethod(@TStBarCode.PaintToDC, 'PaintToDC');
    RegisterMethod(@TStBarCode.PaintToDCSize, 'PaintToDCSize');
    RegisterMethod(@TStBarCode.SaveToFile, 'SaveToFile');
    RegisterMethod(@TStBarCode.Validate, 'Validate');
    RegisterPropertyHelper(@TStBarCodeAddCheckChar_R,@TStBarCodeAddCheckChar_W,'AddCheckChar');
    RegisterPropertyHelper(@TStBarCodeBarCodeType_R,@TStBarCodeBarCodeType_W,'BarCodeType');
    RegisterPropertyHelper(@TStBarCodeBarColor_R,@TStBarCodeBarColor_W,'BarColor');
    RegisterPropertyHelper(@TStBarCodeBarToSpaceRatio_R,@TStBarCodeBarToSpaceRatio_W,'BarToSpaceRatio');
    RegisterPropertyHelper(@TStBarCodeBarNarrowToWideRatio_R,@TStBarCodeBarNarrowToWideRatio_W,'BarNarrowToWideRatio');
    RegisterPropertyHelper(@TStBarCodeBarWidth_R,@TStBarCodeBarWidth_W,'BarWidth');
    RegisterPropertyHelper(@TStBarCodeBearerBars_R,@TStBarCodeBearerBars_W,'BearerBars');
    RegisterPropertyHelper(@TStBarCodeCode_R,@TStBarCodeCode_W,'Code');
    RegisterPropertyHelper(@TStBarCodeCode128Subset_R,@TStBarCodeCode128Subset_W,'Code128Subset');
    RegisterPropertyHelper(@TStBarCodeExtendedSyntax_R,@TStBarCodeExtendedSyntax_W,'ExtendedSyntax');
    RegisterPropertyHelper(@TStBarCodeShowCode_R,@TStBarCodeShowCode_W,'ShowCode');
    RegisterPropertyHelper(@TStBarCodeShowGuardChars_R,@TStBarCodeShowGuardChars_W,'ShowGuardChars');
    RegisterPropertyHelper(@TStBarCodeSupplementalCode_R,@TStBarCodeSupplementalCode_W,'SupplementalCode');
    RegisterPropertyHelper(@TStBarCodeTallGuardBars_R,@TStBarCodeTallGuardBars_W,'TallGuardBars');
    RegisterPropertyHelper(@TStBarCodeVersion_R,@TStBarCodeVersion_W,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStBarCodeInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStBarCodeInfo) do begin
    RegisterConstructor(@TStBarCodeInfo.Create, 'Create');
    RegisterMethod(@TStBarCodeInfo.Add, 'Add');
    RegisterMethod(@TStBarCodeInfo.Clear, 'Clear');
    RegisterPropertyHelper(@TStBarCodeInfoBars_R,nil,'Bars');
    RegisterPropertyHelper(@TStBarCodeInfoCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStBarData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStBarData) do
  begin
    RegisterPropertyHelper(@TStBarDataFKind_R,@TStBarDataFKind_W,'FKind');
    RegisterPropertyHelper(@TStBarDataFModules_R,@TStBarDataFModules_W,'FModules');
    RegisterPropertyHelper(@TStBarDataKind_R,@TStBarDataKind_W,'Kind');
    RegisterPropertyHelper(@TStBarDataModules_R,@TStBarDataModules_W,'Modules');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StBarC(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStBarData(CL);
  RIRegister_TStBarCodeInfo(CL);
  RIRegister_TStBarCode(CL);
end;

 
 
{ TPSImport_StBarC }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StBarC.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StBarC(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StBarC.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StBarC(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
