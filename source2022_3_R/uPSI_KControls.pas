unit uPSI_KControls;
{
coolcode! a last unit in 4.2.2.90 maxlab

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
  TPSImport_KControls = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TKPrintPreview(CL: TPSPascalCompiler);
procedure SIRegister_TKPreviewColors(CL: TPSPascalCompiler);
procedure SIRegister_TKPrintPageSetup(CL: TPSPascalCompiler);
procedure SIRegister_TKCustomColors(CL: TPSPascalCompiler);
procedure SIRegister_TKCustomControl(CL: TPSPascalCompiler);
procedure SIRegister_TKObjectList(CL: TPSPascalCompiler);
procedure SIRegister_TKObject(CL: TPSPascalCompiler);
procedure SIRegister_TKRect(CL: TPSPascalCompiler);
procedure SIRegister_KControls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_KControls_Routines(S: TPSExec);
procedure RIRegister_TKPrintPreview(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKPreviewColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKPrintPageSetup(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKCustomColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKCustomControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKObjectList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKRect(CL: TPSRuntimeClassImporter);
procedure RIRegister_KControls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
 {  LCLType
  ,LCLIntf
  ,LMessages
  ,LCLProc
  ,LResources }
  Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Contnrs
  ,Printers
  ,Forms
  ,KFunctions
  ,Themes
  ,UxTheme
  ,KControls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_KControls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TKPrintPreview(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKCustomControl', 'TKPrintPreview') do
  with CL.AddClassN(CL.FindClass('TKCustomControl'),'TKPrintPreview') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');

    RegisterMethod('Procedure FirstPage');
    RegisterMethod('Procedure LastPage');
    RegisterMethod('Procedure NextPage');
    RegisterMethod('Procedure PreviousPage');
    RegisterMethod('Procedure UpdatePreview');
    RegisterProperty('CurrentScale', 'Integer', iptr);
    RegisterProperty('PageRect', 'TRect', iptr);
    RegisterProperty('EndPage', 'Integer', iptr);
    RegisterProperty('StartPage', 'Integer', iptr);
    RegisterProperty('Colors', 'TKPreviewColors', iptrw);
    RegisterProperty('Control', 'TKCustomControl', iptrw);
    RegisterProperty('Page', 'Integer', iptrw);
    RegisterProperty('Scale', 'Integer', iptrw);
    RegisterProperty('ScaleMode', 'TKPreviewScaleMode', iptrw);
    RegisterProperty('OnChanged', 'TKPreviewChangedEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKPreviewColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKCustomColors', 'TKPreviewColors') do
  with CL.AddClassN(CL.FindClass('TKCustomColors'),'TKPreviewColors') do
  begin
    RegisterProperty('Paper', 'TColor', iptrw);
    RegisterProperty('BkGnd', 'TColor', iptrw);
    RegisterProperty('Border', 'TColor', iptrw);
    RegisterProperty('SelectedBorder', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKPrintPageSetup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TKPrintPageSetup') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TKPrintPageSetup') do
  begin
    RegisterMethod('Constructor Create( AControl : TKCustomControl)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function HMap( Value : Integer) : Integer');
    RegisterMethod('Procedure Invalidate');
    RegisterMethod('Procedure PrintOut');
    RegisterMethod('Procedure LockUpdate');
    RegisterMethod('Procedure UnlockUpdate');
    RegisterMethod('Function UpdateUnlocked : Boolean');
    RegisterMethod('Procedure Validate');
    RegisterMethod('Function VMap( Value : Integer) : Integer');
    RegisterProperty('Active', 'Boolean', iptr);
    RegisterProperty('CanPrint', 'Boolean', iptr);
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('Control', 'TKCustomControl', iptr);
    RegisterProperty('ControlHorzPageCount', 'Integer', iptr);
    RegisterProperty('ControlVertPageCount', 'Integer', iptr);
    RegisterProperty('Copies', 'Integer', iptrw);
    RegisterProperty('CurrentCopy', 'Integer', iptr);
    RegisterProperty('CurrentPage', 'Integer', iptr);
    RegisterProperty('CurrentPageControl', 'Integer', iptr);
    RegisterProperty('CurrentPageExtraLeft', 'Integer', iptr);
    RegisterProperty('CurrentPageExtraRight', 'Integer', iptr);
    RegisterProperty('CurrentScale', 'Double', iptr);
    RegisterProperty('MappedControlPaintAreaWidth', 'Integer', iptr);
    RegisterProperty('MappedExtraSpaceLeft', 'Integer', iptr);
    RegisterProperty('MappedExtraSpaceRight', 'Integer', iptr);
    RegisterProperty('MappedFooterSpace', 'Integer', iptr);
    RegisterProperty('MappedHeaderSpace', 'Integer', iptr);
    RegisterProperty('MappedMarginBottom', 'Integer', iptr);
    RegisterProperty('MappedMarginLeft', 'Integer', iptr);
    RegisterProperty('MappedMarginLeftMirrored', 'Integer', iptr);
    RegisterProperty('MappedMarginRight', 'Integer', iptr);
    RegisterProperty('MappedMarginRightMirrored', 'Integer', iptr);
    RegisterProperty('MappedMarginTop', 'Integer', iptr);
    RegisterProperty('MappedOutlineHeight', 'Integer', iptr);
    RegisterProperty('MappedOutlineWidth', 'Integer', iptr);
    RegisterProperty('MappedPaintAreaHeight', 'Integer', iptr);
    RegisterProperty('MappedPaintAreaWidth', 'Integer', iptr);
    RegisterProperty('MappedPageHeight', 'Integer', iptr);
    RegisterProperty('MappedPageWidth', 'Integer', iptr);
    RegisterProperty('DesktopPixelsPerInchX', 'Integer', iptr);
    RegisterProperty('DesktopPixelsPerInchY', 'Integer', iptr);
    RegisterProperty('EndPage', 'Integer', iptrw);
    RegisterProperty('ExtraLeftHorzPageCount', 'Integer', iptr);
    RegisterProperty('ExtraLeftVertPageCount', 'Integer', iptr);
    RegisterProperty('ExtraRightHorzPageCount', 'Integer', iptr);
    RegisterProperty('ExtraRightVertPageCount', 'Integer', iptr);
    RegisterProperty('Options', 'TKPrintOptions', iptrw);
    RegisterProperty('Orientation', 'TPrinterOrientation', iptrw);
    RegisterProperty('PageCount', 'Integer', iptr);
    RegisterProperty('Previewing', 'Boolean', iptr);
    RegisterProperty('PrinterControlPaintAreaWidth', 'Integer', iptr);
    RegisterProperty('PrinterExtraSpaceLeft', 'Integer', iptr);
    RegisterProperty('PrinterExtraSpaceRight', 'Integer', iptr);
    RegisterProperty('PrinterFooterSpace', 'Integer', iptr);
    RegisterProperty('PrinterHeaderSpace', 'Integer', iptr);
    RegisterProperty('PrinterMarginBottom', 'Integer', iptr);
    RegisterProperty('PrinterMarginLeft', 'Integer', iptr);
    RegisterProperty('PrinterMarginLeftMirrored', 'Integer', iptr);
    RegisterProperty('PrinterMarginRight', 'Integer', iptr);
    RegisterProperty('PrinterMarginRightMirrored', 'Integer', iptr);
    RegisterProperty('PrinterMarginTop', 'Integer', iptr);
    RegisterProperty('PrinterName', 'string', iptrw);
    RegisterProperty('PrinterPageHeight', 'Integer', iptr);
    RegisterProperty('PrinterPageWidth', 'Integer', iptr);
    RegisterProperty('PrinterPaintAreaHeight', 'Integer', iptr);
    RegisterProperty('PrinterPaintAreaWidth', 'Integer', iptr);
    RegisterProperty('PrinterPixelsPerInchX', 'Integer', iptr);
    RegisterProperty('PrinterPixelsPerInchY', 'Integer', iptr);
    RegisterProperty('PrintingMapped', 'Boolean', iptrw);
    RegisterProperty('Range', 'TKPrintRange', iptrw);
    RegisterProperty('SelAvail', 'Boolean', iptr);
    RegisterProperty('StartPage', 'Integer', iptrw);
    RegisterProperty('Scale', 'Integer', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('UnitControlPaintAreaWidth', 'Double', iptr);
    RegisterProperty('UnitExtraSpaceLeft', 'Double', iptrw);
    RegisterProperty('UnitExtraSpaceRight', 'Double', iptrw);
    RegisterProperty('UnitFooterSpace', 'Double', iptrw);
    RegisterProperty('UnitHeaderSpace', 'Double', iptrw);
    RegisterProperty('UnitMarginBottom', 'Double', iptrw);
    RegisterProperty('UnitMarginLeft', 'Double', iptrw);
    RegisterProperty('UnitMarginRight', 'Double', iptrw);
    RegisterProperty('UnitMarginTop', 'Double', iptrw);
    RegisterProperty('UnitPaintAreaHeight', 'Double', iptr);
    RegisterProperty('UnitPaintAreaWidth', 'Double', iptr);
    RegisterProperty('Units', 'TKPrintUnits', iptrw);
    RegisterProperty('OnPrintMeasure', 'TKPrintMeasureEvent', iptrw);
    RegisterProperty('OnUpdateSettings', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKCustomColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TKCustomColors') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TKCustomColors') do
  begin
    RegisterMethod('Constructor Create( AControl : TKCustomControl)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure ClearBrightColors');
    RegisterProperty('Color', 'TColor TKColorIndex', iptrw);
    RegisterProperty('ColorData', 'TKColorData TKColorIndex', iptr);
    RegisterProperty('ColorName', 'string TKColorIndex', iptr);
    RegisterProperty('Colors', 'TKColorArray', iptrw);
    RegisterProperty('ColorScheme', 'TKColorScheme', iptrw);
    RegisterProperty('DefaultColor', 'TColor TKColorIndex', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKCustomControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TKCustomControl') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TKCustomControl') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');

    RegisterMethod('Function Flag( AFlag : Cardinal) : Boolean');
    RegisterMethod('Procedure Invalidate');
    RegisterMethod('Procedure LockUpdate');
    RegisterMethod('Procedure PrintOut');
    RegisterMethod('Procedure UnlockUpdate');
    RegisterMethod('Function UpdateUnlocked : Boolean');
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('CanPrint', 'Boolean', iptr);
    RegisterProperty('MouseInClient', 'Boolean', iptr);
    RegisterProperty('MemoryCanvas', 'TCanvas', iptrw);
    RegisterProperty('MemoryCanvasRect', 'TRect', iptrw);
    RegisterProperty('OnPrintNotify', 'TKPrintNotifyEvent', iptrw);
    RegisterProperty('OnPrintPaint', 'TKPrintPaintEvent', iptrw);
    RegisterProperty('PageSetup', 'TKPrintPageSetup', iptrw);
    RegisterProperty('PageSetupAllocated', 'Boolean', iptr);
    RegisterProperty('ParentBackground', 'Boolean', iptrw);
    RegisterProperty('ParentDoubleBuffered', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKObjectList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TKObjectList') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TKObjectList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Add( AObject : TObject) : Integer');
    RegisterMethod('Procedure Assign( ASource : TKObjectList)');
    RegisterMethod('Function EqualProperties( AValue : TKObjectList) : Boolean');
    RegisterMethod('Procedure Insert( Index : Integer; AObject : TObject)');
    RegisterMethod('Procedure LockUpdate');
    RegisterMethod('Procedure UnLockUpdate');
    RegisterMethod('Function UpdateUnlocked : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TKObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'TKObject') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( ASource : TKObject)');
    RegisterMethod('Function EqualProperties( AValue : TKObject) : Boolean');
    RegisterMethod('Procedure LockUpdate');
    RegisterMethod('Procedure UnLockUpdate');
    RegisterMethod('Function UpdateUnlocked : Boolean');
    RegisterProperty('Parent', 'TKObjectList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKRect(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TKRect') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TKRect') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure AssignFromRect( const ARect : TRect)');
    RegisterMethod('Procedure AssignFromValues( ALeft, ATop, ARight, ABottom : Integer)');
    RegisterMethod('Function ContainsPoint( const APoint : TPoint) : Boolean');
    RegisterMethod('Function EqualProperties( const ARect : TKRect) : Boolean');
    RegisterMethod('Function NonZero : Boolean');
    RegisterMethod('Function OffsetRect0( ARect : TKRect) : TRect;');
    RegisterMethod('Function OffsetRect1( const ARect : TRect) : TRect;');
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('Right', 'Integer', iptrw);
    RegisterProperty('Bottom', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_KControls(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TKColorArray', 'array of TColor');
  CL.AddTypeS('TKPreviewColorIndex', 'Integer');
  CL.AddTypeS('TKPrintOption', '( poCollate, poFitToPage, poMirrorMargins, poPa'
   +'geNumbers, poPaintSelection, poTitle, poUseColor )');
  CL.AddTypeS('TKPrintOptions', 'set of TKPrintOption');
  CL.AddTypeS('TKPrintRange', '( kprAll, kprSelectedOnly, kprRange )');
  CL.AddTypeS('TKPrintUnits', '( kpuMM, kpuCM, kpuInch, kpuHundredthInch )');
 //CL.AddConstantN('cBorderStyleDef','').SetString( bsSingle);
 CL.AddConstantN('cContentPaddingBottomDef','LongInt').SetInt( 0);
 CL.AddConstantN('cContentPaddingLeftDef','LongInt').SetInt( 0);
 CL.AddConstantN('cContentPaddingRightDef','LongInt').SetInt( 0);
 CL.AddConstantN('cContentPaddingTopDef','LongInt').SetInt( 0);
 CL.AddConstantN('cCopiesMin','LongInt').SetInt( 1);
 CL.AddConstantN('cCopiesMax','LongInt').SetInt( 1000);
 CL.AddConstantN('cCopiesDef','LongInt').SetInt( 1);
 CL.AddConstantN('cMarginBottomDef','Extended').setExtended( 2.0);
 CL.AddConstantN('cMarginLeftDef','Extended').setExtended( 1.5);
 CL.AddConstantN('cMarginRightDef','Extended').setExtended( 1.5);
 CL.AddConstantN('cMarginTopDef','Extended').setExtended( 1.8);
 CL.AddConstantN('cOptionsDef','LongInt').Value.ts32 := ord(poFitToPage) or ord(poPageNumbers) or ord(poUseColor);
 //CL.AddConstantN('cRangeDef','').SetString( prAll);
 CL.AddConstantN('cScaleDef','LongInt').SetInt( 100);
 CL.AddConstantN('cScaleMin','LongInt').SetInt( 10);
 CL.AddConstantN('cScaleMax','LongInt').SetInt( 500);
 //CL.AddConstantN('cUnitsDef','').SetString( puCM);
 //CL.AddConstantN('cPaperDef','').SetString( clWhite);
 //CL.AddConstantN('cBkGndDef','').SetString( clAppWorkSpace);
 //CL.AddConstantN('cBorderDef','').SetString( clBlack);
 //CL.AddConstantN('cSelectedBorderDef','').SetString( clNavy);
 CL.AddConstantN('ciPaper','LongInt').SetInt( TKPreviewColorIndex ( 0 ));
 CL.AddConstantN('ciBkGnd','LongInt').SetInt( TKPreviewColorIndex ( 1 ));
 CL.AddConstantN('ciBorder','LongInt').SetInt( TKPreviewColorIndex ( 2 ));
 CL.AddConstantN('ciSelectedBorder','LongInt').SetInt( TKPreviewColorIndex ( 3 ));
 // CL.AddConstantN('ciPreviewColorsMax','').SetString( ciSelectedBorder);
 CL.AddConstantN('cScrollNoAction','LongInt').SetInt( - 1);
 CL.AddConstantN('cScrollDelta','LongInt').SetInt( - 2);
 CL.AddConstantN('cPF_Dragging','LongWord').SetUInt( $00000001);
 CL.AddConstantN('cPF_UpdateRange','LongWord').SetUInt( $00000002);
  CL.AddTypeS('TKPreviewScaleMode', '( smScale, smPageWidth, smWholePage )');
  CL.AddTypeS('TKPreviewChangedEvent', 'Procedure ( Sender : TObject)');
  CL.AddTypeS('TKPrintMeasureInfo', 'record OutlineWidth : Integer; OutlineHeig'
   +'ht : Integer; ControlHorzPageCount : Integer; ControlVertPageCount : Integ'
   +'er; ExtraLeftHorzPageCount : Integer; ExtraLeftVertPageCount : Integer; Ex'
   +'traRightHorzPageCount : Integer; ExtraRightVertPageCount : Integer; end');
  CL.AddTypeS('TKPrintStatus', '( kepsBegin, kepsNewPage, kepsEnd )');
  CL.AddTypeS('TKPrintNotifyEvent', 'Procedure ( Sender : TObject; Status: TKPrintStatus; var Abort: Boolean)');
  CL.AddTypeS('TKPrintPaintEvent', 'Procedure ( Sender : TObject)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKPrintPageSetup');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKPrintPreview');
  SIRegister_TKRect(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKObjectList');
  SIRegister_TKObject(CL);
  //CL.AddTypeS('TKObjectClass', 'class of TKObject');
  SIRegister_TKObjectList(CL);
  SIRegister_TKCustomControl(CL);
  CL.AddTypeS('TKColorScheme', '( kcsNormal, kcsGrayed, kcsBright, kcsGrayScale )');
  CL.AddTypeS('TKColorIndex', 'Integer');
  CL.AddTypeS('TKColorData', 'record Index : TKColorIndex; Color : TColor; Default : TColor; Name : string; end');
  CL.AddTypeS('TKColorSpec', 'record Def : TColor; Name : string; end');
  SIRegister_TKCustomColors(CL);
  CL.AddTypeS('TKPrintMeasureEvent', 'Procedure ( Sender : TObject; var Info : TKPrintMeasureInfo)');
  SIRegister_TKPrintPageSetup(CL);
  SIRegister_TKPreviewColors(CL);
  SIRegister_TKPrintPreview(CL);
 CL.AddDelphiFunction('Function InchesToValue( Units : TKPrintUnits; Value : Double) : Double');
 CL.AddDelphiFunction('Function ValueToInches( Units : TKPrintUnits; Value : Double) : Double');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewOnChanged_W(Self: TKPrintPreview; const T: TKPreviewChangedEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewOnChanged_R(Self: TKPrintPreview; var T: TKPreviewChangedEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewScaleMode_W(Self: TKPrintPreview; const T: TKPreviewScaleMode);
begin Self.ScaleMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewScaleMode_R(Self: TKPrintPreview; var T: TKPreviewScaleMode);
begin T := Self.ScaleMode; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewScale_W(Self: TKPrintPreview; const T: Integer);
begin Self.Scale := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewScale_R(Self: TKPrintPreview; var T: Integer);
begin T := Self.Scale; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewPage_W(Self: TKPrintPreview; const T: Integer);
begin Self.Page := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewPage_R(Self: TKPrintPreview; var T: Integer);
begin T := Self.Page; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewControl_W(Self: TKPrintPreview; const T: TKCustomControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewControl_R(Self: TKPrintPreview; var T: TKCustomControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewColors_W(Self: TKPrintPreview; const T: TKPreviewColors);
begin Self.Colors := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewColors_R(Self: TKPrintPreview; var T: TKPreviewColors);
begin T := Self.Colors; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewStartPage_R(Self: TKPrintPreview; var T: Integer);
begin T := Self.StartPage; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewEndPage_R(Self: TKPrintPreview; var T: Integer);
begin T := Self.EndPage; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewPageRect_R(Self: TKPrintPreview; var T: TRect);
begin T := Self.PageRect; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewCurrentScale_R(Self: TKPrintPreview; var T: Integer);
begin T := Self.CurrentScale; end;

(*----------------------------------------------------------------------------*)
procedure TKPreviewColorsSelectedBorder_W(Self: TKPreviewColors; const T: TColor);
begin Self.SelectedBorder := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPreviewColorsSelectedBorder_R(Self: TKPreviewColors; var T: TColor);
begin T := Self.SelectedBorder; end;

(*----------------------------------------------------------------------------*)
procedure TKPreviewColorsBorder_W(Self: TKPreviewColors; const T: TColor);
begin Self.Border := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPreviewColorsBorder_R(Self: TKPreviewColors; var T: TColor);
begin T := Self.Border; end;

(*----------------------------------------------------------------------------*)
procedure TKPreviewColorsBkGnd_W(Self: TKPreviewColors; const T: TColor);
begin Self.BkGnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPreviewColorsBkGnd_R(Self: TKPreviewColors; var T: TColor);
begin T := Self.BkGnd; end;

(*----------------------------------------------------------------------------*)
procedure TKPreviewColorsPaper_W(Self: TKPreviewColors; const T: TColor);
begin Self.Paper := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPreviewColorsPaper_R(Self: TKPreviewColors; var T: TColor);
begin T := Self.Paper; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupOnUpdateSettings_W(Self: TKPrintPageSetup; const T: TNotifyEvent);
begin Self.OnUpdateSettings := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupOnUpdateSettings_R(Self: TKPrintPageSetup; var T: TNotifyEvent);
begin T := Self.OnUpdateSettings; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupOnPrintMeasure_W(Self: TKPrintPageSetup; const T: TKPrintMeasureEvent);
begin Self.OnPrintMeasure := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupOnPrintMeasure_R(Self: TKPrintPageSetup; var T: TKPrintMeasureEvent);
begin T := Self.OnPrintMeasure; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnits_W(Self: TKPrintPageSetup; const T: TKPrintUnits);
begin Self.Units := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnits_R(Self: TKPrintPageSetup; var T: TKPrintUnits);
begin T := Self.Units; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitPaintAreaWidth_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.UnitPaintAreaWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitPaintAreaHeight_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.UnitPaintAreaHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitMarginTop_W(Self: TKPrintPageSetup; const T: Double);
begin Self.UnitMarginTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitMarginTop_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.UnitMarginTop; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitMarginRight_W(Self: TKPrintPageSetup; const T: Double);
begin Self.UnitMarginRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitMarginRight_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.UnitMarginRight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitMarginLeft_W(Self: TKPrintPageSetup; const T: Double);
begin Self.UnitMarginLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitMarginLeft_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.UnitMarginLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitMarginBottom_W(Self: TKPrintPageSetup; const T: Double);
begin Self.UnitMarginBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitMarginBottom_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.UnitMarginBottom; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitHeaderSpace_W(Self: TKPrintPageSetup; const T: Double);
begin Self.UnitHeaderSpace := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitHeaderSpace_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.UnitHeaderSpace; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitFooterSpace_W(Self: TKPrintPageSetup; const T: Double);
begin Self.UnitFooterSpace := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitFooterSpace_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.UnitFooterSpace; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitExtraSpaceRight_W(Self: TKPrintPageSetup; const T: Double);
begin Self.UnitExtraSpaceRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitExtraSpaceRight_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.UnitExtraSpaceRight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitExtraSpaceLeft_W(Self: TKPrintPageSetup; const T: Double);
begin Self.UnitExtraSpaceLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitExtraSpaceLeft_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.UnitExtraSpaceLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupUnitControlPaintAreaWidth_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.UnitControlPaintAreaWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupTitle_W(Self: TKPrintPageSetup; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupTitle_R(Self: TKPrintPageSetup; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupScale_W(Self: TKPrintPageSetup; const T: Integer);
begin Self.Scale := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupScale_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.Scale; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupStartPage_W(Self: TKPrintPageSetup; const T: Integer);
begin Self.StartPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupStartPage_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.StartPage; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupSelAvail_R(Self: TKPrintPageSetup; var T: Boolean);
begin T := Self.SelAvail; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupRange_W(Self: TKPrintPageSetup; const T: TKPrintRange);
begin Self.Range := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupRange_R(Self: TKPrintPageSetup; var T: TKPrintRange);
begin T := Self.Range; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrintingMapped_W(Self: TKPrintPageSetup; const T: Boolean);
begin Self.PrintingMapped := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrintingMapped_R(Self: TKPrintPageSetup; var T: Boolean);
begin T := Self.PrintingMapped; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterPixelsPerInchY_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterPixelsPerInchY; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterPixelsPerInchX_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterPixelsPerInchX; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterPaintAreaWidth_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterPaintAreaWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterPaintAreaHeight_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterPaintAreaHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterPageWidth_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterPageWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterPageHeight_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterPageHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterName_W(Self: TKPrintPageSetup; const T: string);
begin Self.PrinterName := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterName_R(Self: TKPrintPageSetup; var T: string);
begin T := Self.PrinterName; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterMarginTop_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterMarginTop; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterMarginRightMirrored_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterMarginRightMirrored; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterMarginRight_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterMarginRight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterMarginLeftMirrored_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterMarginLeftMirrored; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterMarginLeft_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterMarginLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterMarginBottom_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterMarginBottom; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterHeaderSpace_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterHeaderSpace; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterFooterSpace_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterFooterSpace; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterExtraSpaceRight_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterExtraSpaceRight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterExtraSpaceLeft_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterExtraSpaceLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPrinterControlPaintAreaWidth_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PrinterControlPaintAreaWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPreviewing_R(Self: TKPrintPageSetup; var T: Boolean);
begin T := Self.Previewing; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupPageCount_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.PageCount; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupOrientation_W(Self: TKPrintPageSetup; const T: TPrinterOrientation);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupOrientation_R(Self: TKPrintPageSetup; var T: TPrinterOrientation);
begin T := Self.Orientation; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupOptions_W(Self: TKPrintPageSetup; const T: TKPrintOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupOptions_R(Self: TKPrintPageSetup; var T: TKPrintOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupExtraRightVertPageCount_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.ExtraRightVertPageCount; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupExtraRightHorzPageCount_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.ExtraRightHorzPageCount; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupExtraLeftVertPageCount_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.ExtraLeftVertPageCount; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupExtraLeftHorzPageCount_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.ExtraLeftHorzPageCount; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupEndPage_W(Self: TKPrintPageSetup; const T: Integer);
begin Self.EndPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupEndPage_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.EndPage; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupDesktopPixelsPerInchY_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.DesktopPixelsPerInchY; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupDesktopPixelsPerInchX_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.DesktopPixelsPerInchX; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedPageWidth_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedPageWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedPageHeight_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedPageHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedPaintAreaWidth_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedPaintAreaWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedPaintAreaHeight_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedPaintAreaHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedOutlineWidth_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedOutlineWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedOutlineHeight_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedOutlineHeight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedMarginTop_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedMarginTop; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedMarginRightMirrored_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedMarginRightMirrored; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedMarginRight_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedMarginRight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedMarginLeftMirrored_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedMarginLeftMirrored; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedMarginLeft_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedMarginLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedMarginBottom_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedMarginBottom; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedHeaderSpace_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedHeaderSpace; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedFooterSpace_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedFooterSpace; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedExtraSpaceRight_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedExtraSpaceRight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedExtraSpaceLeft_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedExtraSpaceLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupMappedControlPaintAreaWidth_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.MappedControlPaintAreaWidth; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupCurrentScale_R(Self: TKPrintPageSetup; var T: Double);
begin T := Self.CurrentScale; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupCurrentPageExtraRight_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.CurrentPageExtraRight; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupCurrentPageExtraLeft_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.CurrentPageExtraLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupCurrentPageControl_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.CurrentPageControl; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupCurrentPage_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.CurrentPage; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupCurrentCopy_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.CurrentCopy; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupCopies_W(Self: TKPrintPageSetup; const T: Integer);
begin Self.Copies := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupCopies_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.Copies; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupControlVertPageCount_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.ControlVertPageCount; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupControlHorzPageCount_R(Self: TKPrintPageSetup; var T: Integer);
begin T := Self.ControlHorzPageCount; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupControl_R(Self: TKPrintPageSetup; var T: TKCustomControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupCanvas_R(Self: TKPrintPageSetup; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupCanPrint_R(Self: TKPrintPageSetup; var T: Boolean);
begin T := Self.CanPrint; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPageSetupActive_R(Self: TKPrintPageSetup; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomColorsDefaultColor_R(Self: TKCustomColors; var T: TColor; const t1: TKColorIndex);
begin T := Self.DefaultColor[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomColorsColorScheme_W(Self: TKCustomColors; const T: TKColorScheme);
begin Self.ColorScheme := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomColorsColorScheme_R(Self: TKCustomColors; var T: TKColorScheme);
begin T := Self.ColorScheme; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomColorsColors_W(Self: TKCustomColors; const T: TKColorArray);
begin Self.Colors := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomColorsColors_R(Self: TKCustomColors; var T: TKColorArray);
begin T := Self.Colors; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomColorsColorName_R(Self: TKCustomColors; var T: string; const t1: TKColorIndex);
begin T := Self.ColorName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomColorsColorData_R(Self: TKCustomColors; var T: TKColorData; const t1: TKColorIndex);
begin T := Self.ColorData[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomColorsColor_W(Self: TKCustomColors; const T: TColor; const t1: TKColorIndex);
begin Self.Color[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomColorsColor_R(Self: TKCustomColors; var T: TColor; const t1: TKColorIndex);
begin T := Self.Color[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlParentDoubleBuffered_W(Self: TKCustomControl; const T: Boolean);
begin
  //Self.ParentDoubleBuffered := T;
end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlParentDoubleBuffered_R(Self: TKCustomControl; var T: Boolean);
begin //T := Self.ParentDoubleBuffered;
end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlParentBackground_W(Self: TKCustomControl; const T: Boolean);
begin //Self.ParentBackground := T;
end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlParentBackground_R(Self: TKCustomControl; var T: Boolean);
begin //T := Self.ParentBackground;
end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlPageSetupAllocated_R(Self: TKCustomControl; var T: Boolean);
begin T := Self.PageSetupAllocated; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlPageSetup_W(Self: TKCustomControl; const T: TKPrintPageSetup);
begin Self.PageSetup := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlPageSetup_R(Self: TKCustomControl; var T: TKPrintPageSetup);
begin T := Self.PageSetup; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlOnPrintPaint_W(Self: TKCustomControl; const T: TKPrintPaintEvent);
begin Self.OnPrintPaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlOnPrintPaint_R(Self: TKCustomControl; var T: TKPrintPaintEvent);
begin T := Self.OnPrintPaint; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlOnPrintNotify_W(Self: TKCustomControl; const T: TKPrintNotifyEvent);
begin Self.OnPrintNotify := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlOnPrintNotify_R(Self: TKCustomControl; var T: TKPrintNotifyEvent);
begin T := Self.OnPrintNotify; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlMemoryCanvasRect_W(Self: TKCustomControl; const T: TRect);
begin Self.MemoryCanvasRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlMemoryCanvasRect_R(Self: TKCustomControl; var T: TRect);
begin T := Self.MemoryCanvasRect; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlMemoryCanvas_W(Self: TKCustomControl; const T: TCanvas);
begin Self.MemoryCanvas := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlMemoryCanvas_R(Self: TKCustomControl; var T: TCanvas);
begin T := Self.MemoryCanvas; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlMouseInClient_R(Self: TKCustomControl; var T: Boolean);
begin T := Self.MouseInClient; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlCanPrint_R(Self: TKCustomControl; var T: Boolean);
begin T := Self.CanPrint; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlBorderStyle_W(Self: TKCustomControl; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKCustomControlBorderStyle_R(Self: TKCustomControl; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKObjectParent_W(Self: TKObject; const T: TKObjectList);
begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKObjectParent_R(Self: TKObject; var T: TKObjectList);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TKRectBottom_W(Self: TKRect; const T: Integer);
begin Self.Bottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TKRectBottom_R(Self: TKRect; var T: Integer);
begin T := Self.Bottom; end;

(*----------------------------------------------------------------------------*)
procedure TKRectRight_W(Self: TKRect; const T: Integer);
begin Self.Right := T; end;

(*----------------------------------------------------------------------------*)
procedure TKRectRight_R(Self: TKRect; var T: Integer);
begin T := Self.Right; end;

(*----------------------------------------------------------------------------*)
procedure TKRectTop_W(Self: TKRect; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TKRectTop_R(Self: TKRect; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TKRectLeft_W(Self: TKRect; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TKRectLeft_R(Self: TKRect; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TKRectOnChanged_W(Self: TKRect; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TKRectOnChanged_R(Self: TKRect; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
Function TKRectOffsetRect1_P(Self: TKRect;  const ARect : TRect) : TRect;
Begin Result := Self.OffsetRect(ARect); END;

(*----------------------------------------------------------------------------*)
Function TKRectOffsetRect0_P(Self: TKRect;  ARect : TKRect) : TRect;
Begin Result := Self.OffsetRect(ARect); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KControls_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InchesToValue, 'InchesToValue', cdRegister);
 S.RegisterDelphiFunction(@ValueToInches, 'ValueToInches', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKPrintPreview(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKPrintPreview) do begin
    RegisterConstructor(@TKPrintPreview.Create, 'Create');
    RegisterMethod(@TKPrintPreview.Destroy, 'Free');
      RegisterMethod(@TKPrintPreview.FirstPage, 'FirstPage');
    RegisterMethod(@TKPrintPreview.LastPage, 'LastPage');
    RegisterMethod(@TKPrintPreview.NextPage, 'NextPage');
    RegisterMethod(@TKPrintPreview.PreviousPage, 'PreviousPage');
    RegisterMethod(@TKPrintPreview.UpdatePreview, 'UpdatePreview');
    RegisterPropertyHelper(@TKPrintPreviewCurrentScale_R,nil,'CurrentScale');
    RegisterPropertyHelper(@TKPrintPreviewPageRect_R,nil,'PageRect');
    RegisterPropertyHelper(@TKPrintPreviewEndPage_R,nil,'EndPage');
    RegisterPropertyHelper(@TKPrintPreviewStartPage_R,nil,'StartPage');
    RegisterPropertyHelper(@TKPrintPreviewColors_R,@TKPrintPreviewColors_W,'Colors');
    RegisterPropertyHelper(@TKPrintPreviewControl_R,@TKPrintPreviewControl_W,'Control');
    RegisterPropertyHelper(@TKPrintPreviewPage_R,@TKPrintPreviewPage_W,'Page');
    RegisterPropertyHelper(@TKPrintPreviewScale_R,@TKPrintPreviewScale_W,'Scale');
    RegisterPropertyHelper(@TKPrintPreviewScaleMode_R,@TKPrintPreviewScaleMode_W,'ScaleMode');
    RegisterPropertyHelper(@TKPrintPreviewOnChanged_R,@TKPrintPreviewOnChanged_W,'OnChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKPreviewColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKPreviewColors) do
  begin
    RegisterPropertyHelper(@TKPreviewColorsPaper_R,@TKPreviewColorsPaper_W,'Paper');
    RegisterPropertyHelper(@TKPreviewColorsBkGnd_R,@TKPreviewColorsBkGnd_W,'BkGnd');
    RegisterPropertyHelper(@TKPreviewColorsBorder_R,@TKPreviewColorsBorder_W,'Border');
    RegisterPropertyHelper(@TKPreviewColorsSelectedBorder_R,@TKPreviewColorsSelectedBorder_W,'SelectedBorder');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKPrintPageSetup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKPrintPageSetup) do
  begin
    RegisterConstructor(@TKPrintPageSetup.Create, 'Create');
    RegisterMethod(@TKPrintPageSetup.Assign, 'Assign');
    RegisterMethod(@TKPrintPageSetup.HMap, 'HMap');
    RegisterMethod(@TKPrintPageSetup.Invalidate, 'Invalidate');
    RegisterMethod(@TKPrintPageSetup.PrintOut, 'PrintOut');
    RegisterVirtualMethod(@TKPrintPageSetup.LockUpdate, 'LockUpdate');
    RegisterVirtualMethod(@TKPrintPageSetup.UnlockUpdate, 'UnlockUpdate');
    RegisterVirtualMethod(@TKPrintPageSetup.UpdateUnlocked, 'UpdateUnlocked');
    RegisterMethod(@TKPrintPageSetup.Validate, 'Validate');
    RegisterMethod(@TKPrintPageSetup.VMap, 'VMap');
    RegisterPropertyHelper(@TKPrintPageSetupActive_R,nil,'Active');
    RegisterPropertyHelper(@TKPrintPageSetupCanPrint_R,nil,'CanPrint');
    RegisterPropertyHelper(@TKPrintPageSetupCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TKPrintPageSetupControl_R,nil,'Control');
    RegisterPropertyHelper(@TKPrintPageSetupControlHorzPageCount_R,nil,'ControlHorzPageCount');
    RegisterPropertyHelper(@TKPrintPageSetupControlVertPageCount_R,nil,'ControlVertPageCount');
    RegisterPropertyHelper(@TKPrintPageSetupCopies_R,@TKPrintPageSetupCopies_W,'Copies');
    RegisterPropertyHelper(@TKPrintPageSetupCurrentCopy_R,nil,'CurrentCopy');
    RegisterPropertyHelper(@TKPrintPageSetupCurrentPage_R,nil,'CurrentPage');
    RegisterPropertyHelper(@TKPrintPageSetupCurrentPageControl_R,nil,'CurrentPageControl');
    RegisterPropertyHelper(@TKPrintPageSetupCurrentPageExtraLeft_R,nil,'CurrentPageExtraLeft');
    RegisterPropertyHelper(@TKPrintPageSetupCurrentPageExtraRight_R,nil,'CurrentPageExtraRight');
    RegisterPropertyHelper(@TKPrintPageSetupCurrentScale_R,nil,'CurrentScale');
    RegisterPropertyHelper(@TKPrintPageSetupMappedControlPaintAreaWidth_R,nil,'MappedControlPaintAreaWidth');
    RegisterPropertyHelper(@TKPrintPageSetupMappedExtraSpaceLeft_R,nil,'MappedExtraSpaceLeft');
    RegisterPropertyHelper(@TKPrintPageSetupMappedExtraSpaceRight_R,nil,'MappedExtraSpaceRight');
    RegisterPropertyHelper(@TKPrintPageSetupMappedFooterSpace_R,nil,'MappedFooterSpace');
    RegisterPropertyHelper(@TKPrintPageSetupMappedHeaderSpace_R,nil,'MappedHeaderSpace');
    RegisterPropertyHelper(@TKPrintPageSetupMappedMarginBottom_R,nil,'MappedMarginBottom');
    RegisterPropertyHelper(@TKPrintPageSetupMappedMarginLeft_R,nil,'MappedMarginLeft');
    RegisterPropertyHelper(@TKPrintPageSetupMappedMarginLeftMirrored_R,nil,'MappedMarginLeftMirrored');
    RegisterPropertyHelper(@TKPrintPageSetupMappedMarginRight_R,nil,'MappedMarginRight');
    RegisterPropertyHelper(@TKPrintPageSetupMappedMarginRightMirrored_R,nil,'MappedMarginRightMirrored');
    RegisterPropertyHelper(@TKPrintPageSetupMappedMarginTop_R,nil,'MappedMarginTop');
    RegisterPropertyHelper(@TKPrintPageSetupMappedOutlineHeight_R,nil,'MappedOutlineHeight');
    RegisterPropertyHelper(@TKPrintPageSetupMappedOutlineWidth_R,nil,'MappedOutlineWidth');
    RegisterPropertyHelper(@TKPrintPageSetupMappedPaintAreaHeight_R,nil,'MappedPaintAreaHeight');
    RegisterPropertyHelper(@TKPrintPageSetupMappedPaintAreaWidth_R,nil,'MappedPaintAreaWidth');
    RegisterPropertyHelper(@TKPrintPageSetupMappedPageHeight_R,nil,'MappedPageHeight');
    RegisterPropertyHelper(@TKPrintPageSetupMappedPageWidth_R,nil,'MappedPageWidth');
    RegisterPropertyHelper(@TKPrintPageSetupDesktopPixelsPerInchX_R,nil,'DesktopPixelsPerInchX');
    RegisterPropertyHelper(@TKPrintPageSetupDesktopPixelsPerInchY_R,nil,'DesktopPixelsPerInchY');
    RegisterPropertyHelper(@TKPrintPageSetupEndPage_R,@TKPrintPageSetupEndPage_W,'EndPage');
    RegisterPropertyHelper(@TKPrintPageSetupExtraLeftHorzPageCount_R,nil,'ExtraLeftHorzPageCount');
    RegisterPropertyHelper(@TKPrintPageSetupExtraLeftVertPageCount_R,nil,'ExtraLeftVertPageCount');
    RegisterPropertyHelper(@TKPrintPageSetupExtraRightHorzPageCount_R,nil,'ExtraRightHorzPageCount');
    RegisterPropertyHelper(@TKPrintPageSetupExtraRightVertPageCount_R,nil,'ExtraRightVertPageCount');
    RegisterPropertyHelper(@TKPrintPageSetupOptions_R,@TKPrintPageSetupOptions_W,'Options');
    RegisterPropertyHelper(@TKPrintPageSetupOrientation_R,@TKPrintPageSetupOrientation_W,'Orientation');
    RegisterPropertyHelper(@TKPrintPageSetupPageCount_R,nil,'PageCount');
    RegisterPropertyHelper(@TKPrintPageSetupPreviewing_R,nil,'Previewing');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterControlPaintAreaWidth_R,nil,'PrinterControlPaintAreaWidth');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterExtraSpaceLeft_R,nil,'PrinterExtraSpaceLeft');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterExtraSpaceRight_R,nil,'PrinterExtraSpaceRight');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterFooterSpace_R,nil,'PrinterFooterSpace');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterHeaderSpace_R,nil,'PrinterHeaderSpace');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterMarginBottom_R,nil,'PrinterMarginBottom');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterMarginLeft_R,nil,'PrinterMarginLeft');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterMarginLeftMirrored_R,nil,'PrinterMarginLeftMirrored');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterMarginRight_R,nil,'PrinterMarginRight');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterMarginRightMirrored_R,nil,'PrinterMarginRightMirrored');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterMarginTop_R,nil,'PrinterMarginTop');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterName_R,@TKPrintPageSetupPrinterName_W,'PrinterName');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterPageHeight_R,nil,'PrinterPageHeight');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterPageWidth_R,nil,'PrinterPageWidth');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterPaintAreaHeight_R,nil,'PrinterPaintAreaHeight');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterPaintAreaWidth_R,nil,'PrinterPaintAreaWidth');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterPixelsPerInchX_R,nil,'PrinterPixelsPerInchX');
    RegisterPropertyHelper(@TKPrintPageSetupPrinterPixelsPerInchY_R,nil,'PrinterPixelsPerInchY');
    RegisterPropertyHelper(@TKPrintPageSetupPrintingMapped_R,@TKPrintPageSetupPrintingMapped_W,'PrintingMapped');
    RegisterPropertyHelper(@TKPrintPageSetupRange_R,@TKPrintPageSetupRange_W,'Range');
    RegisterPropertyHelper(@TKPrintPageSetupSelAvail_R,nil,'SelAvail');
    RegisterPropertyHelper(@TKPrintPageSetupStartPage_R,@TKPrintPageSetupStartPage_W,'StartPage');
    RegisterPropertyHelper(@TKPrintPageSetupScale_R,@TKPrintPageSetupScale_W,'Scale');
    RegisterPropertyHelper(@TKPrintPageSetupTitle_R,@TKPrintPageSetupTitle_W,'Title');
    RegisterPropertyHelper(@TKPrintPageSetupUnitControlPaintAreaWidth_R,nil,'UnitControlPaintAreaWidth');
    RegisterPropertyHelper(@TKPrintPageSetupUnitExtraSpaceLeft_R,@TKPrintPageSetupUnitExtraSpaceLeft_W,'UnitExtraSpaceLeft');
    RegisterPropertyHelper(@TKPrintPageSetupUnitExtraSpaceRight_R,@TKPrintPageSetupUnitExtraSpaceRight_W,'UnitExtraSpaceRight');
    RegisterPropertyHelper(@TKPrintPageSetupUnitFooterSpace_R,@TKPrintPageSetupUnitFooterSpace_W,'UnitFooterSpace');
    RegisterPropertyHelper(@TKPrintPageSetupUnitHeaderSpace_R,@TKPrintPageSetupUnitHeaderSpace_W,'UnitHeaderSpace');
    RegisterPropertyHelper(@TKPrintPageSetupUnitMarginBottom_R,@TKPrintPageSetupUnitMarginBottom_W,'UnitMarginBottom');
    RegisterPropertyHelper(@TKPrintPageSetupUnitMarginLeft_R,@TKPrintPageSetupUnitMarginLeft_W,'UnitMarginLeft');
    RegisterPropertyHelper(@TKPrintPageSetupUnitMarginRight_R,@TKPrintPageSetupUnitMarginRight_W,'UnitMarginRight');
    RegisterPropertyHelper(@TKPrintPageSetupUnitMarginTop_R,@TKPrintPageSetupUnitMarginTop_W,'UnitMarginTop');
    RegisterPropertyHelper(@TKPrintPageSetupUnitPaintAreaHeight_R,nil,'UnitPaintAreaHeight');
    RegisterPropertyHelper(@TKPrintPageSetupUnitPaintAreaWidth_R,nil,'UnitPaintAreaWidth');
    RegisterPropertyHelper(@TKPrintPageSetupUnits_R,@TKPrintPageSetupUnits_W,'Units');
    RegisterPropertyHelper(@TKPrintPageSetupOnPrintMeasure_R,@TKPrintPageSetupOnPrintMeasure_W,'OnPrintMeasure');
    RegisterPropertyHelper(@TKPrintPageSetupOnUpdateSettings_R,@TKPrintPageSetupOnUpdateSettings_W,'OnUpdateSettings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKCustomColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKCustomColors) do
  begin
    RegisterVirtualConstructor(@TKCustomColors.Create, 'Create');
    RegisterMethod(@TKCustomColors.Assign, 'Assign');
    RegisterVirtualMethod(@TKCustomColors.ClearBrightColors, 'ClearBrightColors');
    RegisterPropertyHelper(@TKCustomColorsColor_R,@TKCustomColorsColor_W,'Color');
    RegisterPropertyHelper(@TKCustomColorsColorData_R,nil,'ColorData');
    RegisterPropertyHelper(@TKCustomColorsColorName_R,nil,'ColorName');
    RegisterPropertyHelper(@TKCustomColorsColors_R,@TKCustomColorsColors_W,'Colors');
    RegisterPropertyHelper(@TKCustomColorsColorScheme_R,@TKCustomColorsColorScheme_W,'ColorScheme');
    RegisterPropertyHelper(@TKCustomColorsDefaultColor_R,nil,'DefaultColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKCustomControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKCustomControl) do begin
    RegisterConstructor(@TKCustomControl.Create, 'Create');
     RegisterMethod(@TKCustomControl.Destroy, 'Free');

    RegisterMethod(@TKCustomControl.Flag, 'Flag');
    RegisterMethod(@TKCustomControl.Invalidate, 'Invalidate');
    RegisterVirtualMethod(@TKCustomControl.LockUpdate, 'LockUpdate');
    RegisterMethod(@TKCustomControl.PrintOut, 'PrintOut');
    RegisterVirtualMethod(@TKCustomControl.UnlockUpdate, 'UnlockUpdate');
    RegisterVirtualMethod(@TKCustomControl.UpdateUnlocked, 'UpdateUnlocked');
    RegisterPropertyHelper(@TKCustomControlBorderStyle_R,@TKCustomControlBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TKCustomControlCanPrint_R,nil,'CanPrint');
    RegisterPropertyHelper(@TKCustomControlMouseInClient_R,nil,'MouseInClient');
    RegisterPropertyHelper(@TKCustomControlMemoryCanvas_R,@TKCustomControlMemoryCanvas_W,'MemoryCanvas');
    RegisterPropertyHelper(@TKCustomControlMemoryCanvasRect_R,@TKCustomControlMemoryCanvasRect_W,'MemoryCanvasRect');
    RegisterPropertyHelper(@TKCustomControlOnPrintNotify_R,@TKCustomControlOnPrintNotify_W,'OnPrintNotify');
    RegisterPropertyHelper(@TKCustomControlOnPrintPaint_R,@TKCustomControlOnPrintPaint_W,'OnPrintPaint');
    RegisterPropertyHelper(@TKCustomControlPageSetup_R,@TKCustomControlPageSetup_W,'PageSetup');
    RegisterPropertyHelper(@TKCustomControlPageSetupAllocated_R,nil,'PageSetupAllocated');
    RegisterPropertyHelper(@TKCustomControlParentBackground_R,@TKCustomControlParentBackground_W,'ParentBackground');
    RegisterPropertyHelper(@TKCustomControlParentDoubleBuffered_R,@TKCustomControlParentDoubleBuffered_W,'ParentDoubleBuffered');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKObjectList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKObjectList) do
  begin
    RegisterVirtualConstructor(@TKObjectList.Create, 'Create');
    RegisterMethod(@TKObjectList.Add, 'Add');
    RegisterVirtualMethod(@TKObjectList.Assign, 'Assign');
    RegisterVirtualMethod(@TKObjectList.EqualProperties, 'EqualProperties');
    RegisterMethod(@TKObjectList.Insert, 'Insert');
    RegisterVirtualMethod(@TKObjectList.LockUpdate, 'LockUpdate');
    RegisterVirtualMethod(@TKObjectList.UnLockUpdate, 'UnLockUpdate');
    RegisterVirtualMethod(@TKObjectList.UpdateUnlocked, 'UpdateUnlocked');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKObject) do
  begin
    RegisterVirtualConstructor(@TKObject.Create, 'Create');
    RegisterVirtualMethod(@TKObject.Assign, 'Assign');
    RegisterVirtualMethod(@TKObject.EqualProperties, 'EqualProperties');
    RegisterVirtualMethod(@TKObject.LockUpdate, 'LockUpdate');
    RegisterVirtualMethod(@TKObject.UnLockUpdate, 'UnLockUpdate');
    RegisterVirtualMethod(@TKObject.UpdateUnlocked, 'UpdateUnlocked');
    RegisterPropertyHelper(@TKObjectParent_R,@TKObjectParent_W,'Parent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKRect(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKRect) do
  begin
    RegisterConstructor(@TKRect.Create, 'Create');
    RegisterMethod(@TKRect.Assign, 'Assign');
    RegisterMethod(@TKRect.AssignFromRect, 'AssignFromRect');
    RegisterMethod(@TKRect.AssignFromValues, 'AssignFromValues');
    RegisterMethod(@TKRect.ContainsPoint, 'ContainsPoint');
    RegisterMethod(@TKRect.EqualProperties, 'EqualProperties');
    RegisterMethod(@TKRect.NonZero, 'NonZero');
    RegisterMethod(@TKRectOffsetRect0_P, 'OffsetRect0');
    RegisterMethod(@TKRectOffsetRect1_P, 'OffsetRect1');
    RegisterPropertyHelper(@TKRectOnChanged_R,@TKRectOnChanged_W,'OnChanged');
    RegisterPropertyHelper(@TKRectLeft_R,@TKRectLeft_W,'Left');
    RegisterPropertyHelper(@TKRectTop_R,@TKRectTop_W,'Top');
    RegisterPropertyHelper(@TKRectRight_R,@TKRectRight_W,'Right');
    RegisterPropertyHelper(@TKRectBottom_R,@TKRectBottom_W,'Bottom');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KControls(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKPrintPageSetup) do
  with CL.Add(TKPrintPreview) do
  RIRegister_TKRect(CL);
  with CL.Add(TKObjectList) do
  RIRegister_TKObject(CL);
  RIRegister_TKObjectList(CL);
  RIRegister_TKCustomControl(CL);
  RIRegister_TKCustomColors(CL);
  RIRegister_TKPrintPageSetup(CL);
  RIRegister_TKPreviewColors(CL);
  RIRegister_TKPrintPreview(CL);
end;

 
 
{ TPSImport_KControls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_KControls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_KControls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_KControls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_KControls(ri);
  RIRegister_KControls_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
