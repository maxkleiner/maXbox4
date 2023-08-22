unit uPSI_TeeProcs;
{
  procedure to TEE   fix    'TList'),'TTeeEventListeners  TChartBrush style  TTeeMouseEvent
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
  TPSImport_TeeProcs = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TTeeExportData(CL: TPSPascalCompiler);
procedure SIRegister_TTeeShape(CL: TPSPascalCompiler);
procedure SIRegister_TTeeCustomShape(CL: TPSPascalCompiler);
procedure SIRegister_TTeeCustomShapeBrushPen(CL: TPSPascalCompiler);
procedure SIRegister_TCustomTeePanelExtended(CL: TPSPascalCompiler);
procedure SIRegister_TBackImage(CL: TPSPascalCompiler);
procedure SIRegister_TTeeZoom(CL: TPSPascalCompiler);
procedure SIRegister_TTeeZoomBrush(CL: TPSPascalCompiler);
procedure SIRegister_TTeeZoomPen(CL: TPSPascalCompiler);
procedure SIRegister_TCustomTeePanel(CL: TPSPascalCompiler);
procedure SIRegister_TTeeMouseEvent(CL: TPSPascalCompiler);
procedure SIRegister_TTeeEventListeners(CL: TPSPascalCompiler);
procedure SIRegister_TTeeEvent(CL: TPSPascalCompiler);
procedure SIRegister_TZoomPanning(CL: TPSPascalCompiler);
procedure SIRegister_TCustomPanelNoCaption(CL: TPSPascalCompiler);
procedure SIRegister_TMetafile(CL: TPSPascalCompiler);
procedure SIRegister_TeeProcs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TeeProcs_Routines(S: TPSExec);
procedure RIRegister_TTeeExportData(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeShape(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeCustomShape(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeCustomShapeBrushPen(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomTeePanelExtended(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBackImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeZoom(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeZoomBrush(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeZoomPen(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomTeePanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeMouseEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeEventListeners(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TZoomPanning(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomPanelNoCaption(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMetafile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TeeProcs(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  {,Qt
  ,QClipbrd
  ,QGraphics
  ,QStdCtrls
  ,QExtCtrls
  ,QControls
  ,QForms
  ,QPrinters  }
  ,Printers
  ,Clipbrd
  ,ExtCtrls
  ,Controls
  ,Graphics
  ,Forms
  ,Buttons
  ,Types
  //,GraphType
  //,LMessages
  ,TeCanvas
  ,TeeFilters
  ,TeeProcs
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TeeProcs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeExportData(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTeeExportData') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTeeExportData') do
  begin
    RegisterMethod('Function AsString : String');
    RegisterMethod('Procedure CopyToClipboard');
    RegisterMethod('Procedure SaveToFile( const FileName : String)');
    RegisterMethod('Procedure SaveToStream( AStream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeShape(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCustomShape', 'TTeeShape') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShape'),'TTeeShape') do begin
  RegisterPublishedProperties;
   RegisterProperty('Font', 'TTeeFont', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
     RegisterProperty('BevelWidth', 'Integer', iptrw);
     RegisterProperty('Bevel', 'TBevelCut', iptrw);
    //RegisterProperty('Handle', 'TTeeCanvasHandle', iptr);
    RegisterProperty('Gradient', 'TTeeGradient', iptrw);
    RegisterProperty('Picture', 'TBackimage', iptrw);
     RegisterProperty('Shadow', 'TTEEShadow', iptrw);
     RegisterProperty('ShypeStyle', 'TChartObjectShapeStyle', iptrw);
    //  RegisterProperty('Style', 'TPenStyle', iptrw);
    //RegisterProperty('Frame', 'TChartPen', iptrw);
     RegisterProperty('Transparent', 'boolean', iptrw);
    //RegisterProperty('Tranparency', 'integer', iptrw);
     RegisterProperty('Visible', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeCustomShape(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCustomShapeBrushPen', 'TTeeCustomShape') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShapeBrushPen'),'TTeeCustomShape') do
  begin
    RegisterProperty('DefaultTransparent', 'Boolean', iptrw);
    RegisterProperty('ShapeBounds', 'TRect', iptrw);
    RegisterMethod('Constructor Create( AOwner : TCustomTeePanel)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Draw');
    RegisterMethod('Procedure DrawRectRotated( Rect : TRect; Angle : Integer; AZ : Integer);');
    RegisterMethod('Procedure DrawRectRotated1( Panel : TCustomTeePanel; Rect : TRect; Angle : Integer; AZ : Integer);');
    RegisterProperty('ShadowColor', 'TColor', iptrw);
    RegisterProperty('ShadowSize', 'Integer', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('Bevel', 'TPanelBevel', iptrw);
    RegisterProperty('BevelWidth', 'TBevelWidth', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('Font', 'TTeeFont', iptrw);
    RegisterProperty('Gradient', 'TChartGradient', iptrw);
    RegisterProperty('Picture', 'TBackImage', iptrw);
    RegisterProperty('RoundSize', 'Integer', iptrw);
    RegisterProperty('Shadow', 'TTeeShadow', iptrw);
    RegisterProperty('ShapeStyle', 'TChartObjectShapeStyle', iptrw);
    RegisterProperty('TextFormat', 'TTextFormat', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeCustomShapeBrushPen(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTeeCustomShapeBrushPen') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTeeCustomShapeBrushPen') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Show');
    RegisterMethod('Procedure Hide');
    RegisterMethod('Procedure Repaint');
    RegisterProperty('Brush', 'TChartBrush', iptrw);
    RegisterProperty('Frame', 'TChartPen', iptrw);
    RegisterProperty('ParentChart', 'TCustomTeePanel', iptrw);
    RegisterProperty('Pen', 'TChartPen', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomTeePanelExtended(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTeePanel', 'TCustomTeePanelExtended') do
  with CL.AddClassN(CL.FindClass('TCustomTeePanel'),'TCustomTeePanelExtended') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
     RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure DrawZoomRectangle');
    RegisterMethod('Function HasBackImage : Boolean');
    RegisterMethod('Procedure UndoZoom');
    RegisterProperty('Zoomed', 'Boolean', iptrw);
    RegisterProperty('AllowPanning', 'TPanningMode', iptrw);
    RegisterProperty('AllowZoom', 'Boolean', iptrw);
    RegisterProperty('AnimatedZoom', 'Boolean', iptrw);
    RegisterProperty('AnimatedZoomSteps', 'Integer', iptrw);
    RegisterProperty('BackImage', 'TBackImage', iptrw);
    RegisterProperty('BackImageInside', 'Boolean', iptrw);
    RegisterProperty('BackImageMode', 'TTeeBackImageMode', iptrw);
    RegisterProperty('BackImageTransp', 'Boolean', iptrw);
    RegisterProperty('Gradient', 'TChartGradient', iptrw);
    RegisterProperty('Zoom', 'TTeeZoom', iptrw);
    RegisterProperty('OnAfterDraw', 'TNotifyEvent', iptrw);
    RegisterProperty('OnScroll', 'TNotifyEvent', iptrw);
    RegisterProperty('OnUndoZoom', 'TNotifyEvent', iptrw);
    RegisterProperty('OnZoom', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBackImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeePicture', 'TBackImage') do
  with CL.AddClassN(CL.FindClass('TTeePicture'),'TBackImage') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Draw( Panel : TCustomTeePanelExtended; Rect : TRect; Z : Integer)');
    RegisterProperty('Inside', 'Boolean', iptrw);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Mode', 'TTeeBackImageMode', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeZoom(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTeeZoom') do
  with CL.AddClassN(CL.FindClass('TZoomPanning'),'TTeeZoom') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Allow', 'Boolean', iptrw);
    RegisterProperty('Animated', 'Boolean', iptrw);
    RegisterProperty('AnimatedSteps', 'Integer', iptrw);
    RegisterProperty('Brush', 'TTeeZoomBrush', iptrw);
    RegisterProperty('Direction', 'TTeeZoomDirection', iptrw);
    RegisterProperty('KeyShift', 'TShiftState', iptrw);
    RegisterProperty('MinimumPixels', 'Integer', iptrw);
    RegisterProperty('MouseButton', 'TMouseButton', iptrw);
    RegisterProperty('Pen', 'TTeeZoomPen', iptrw);
    RegisterProperty('UpLeftZooms', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeZoomBrush(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTeeZoomBrush') do
  with CL.AddClassN(CL.FindClass('TChartBrush'),'TTeeZoomBrush') do begin
    RegisterPublishedProperties;
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('Style', 'TBrushStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeZoomPen(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartPen', 'TTeeZoomPen') do
  with CL.AddClassN(CL.FindClass('TChartPen'),'TTeeZoomPen') do begin
    RegisterProperty('DefaultColor', 'TColor', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('Color', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomTeePanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPanelNoCaption', 'TCustomTeePanel') do
  with CL.AddClassN(CL.FindClass('TCustomPanelNoCaption'),'TCustomTeePanel') do begin
    RegisterProperty('GLComponent', 'TComponent', iptrw);
    RegisterProperty('ChartRect', 'TRect', iptrw);
     RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Assign;');
    RegisterProperty('InternalCanvas', 'TCanvas3D', iptrw);
    RegisterMethod('Procedure CalcMetaBounds( var R : TRect; const AChartRect : TRect; var WinWidth, WinHeight, ViewWidth, ViewHeight : Integer)');
    RegisterMethod('Function CalcProportionalMargins : TRect');
    RegisterMethod('Function CanClip : Boolean');
    RegisterMethod('Procedure CanvasChanged( Sender : TObject)');
    RegisterMethod('Function ChartPrintRect : TRect');
    RegisterMethod('Procedure CopyToClipboardBitmap;');
    RegisterMethod('Procedure CopyToClipboardBitmap1( const R : TRect);');
    RegisterMethod('Procedure CopyToClipboardMetafile( Enhanced : Boolean);');
    RegisterMethod('Procedure CopyToClipboardMetafile1( Enhanced : Boolean; const R : TRect);');
    RegisterMethod('Function TeeCreateBitmap( ABackColor : TColor; const Rect : TRect; APixelFormat : TPixelFormat) : TBitmap;');
    RegisterMethod('Function TeeCreateBitmap1 : TBitmap;');
    RegisterMethod('Procedure Draw( UserCanvas : TCanvas; const UserRect : TRect);');
    RegisterMethod('Procedure Draw1;');
    RegisterMethod('Procedure DrawPanelBevels( Rect : TRect)');
    RegisterMethod('Procedure DrawToMetaCanvas( ACanvas : TCanvas; const Rect : TRect)');
    RegisterMethod('Function GetBackColor : TColor');
    RegisterMethod('Function GetCursorPos : TPoint');
    RegisterMethod('Function GetRectangle : TRect');
    RegisterMethod('Function IsScreenHighColor : Boolean');
    RegisterMethod('Procedure Print');
    RegisterMethod('Procedure PrintLandscape');
    RegisterMethod('Procedure PrintOrientation( AOrientation : TPrinterOrientation)');
    RegisterMethod('Procedure PrintPartial( const PrinterRect : TRect)');
    RegisterMethod('Procedure PrintPartialCanvas( PrintCanvas : TCanvas; const PrinterRect : TRect)');
    RegisterMethod('Procedure PrintPortrait');
    RegisterMethod('Procedure PrintRect( const R : TRect)');
    RegisterMethod('Procedure RemoveListener( Sender : ITeeEventListener)');
    RegisterMethod('Procedure SaveToBitmapFile( const FileName : String);');
    RegisterMethod('Procedure SaveToBitmapFile1( const FileName : String; const R : TRect);');
    RegisterMethod('Procedure SaveToMetafile( const FileName : String)');
    RegisterMethod('Procedure SaveToMetafileEnh( const FileName : String)');
    RegisterMethod('Procedure SaveToMetafileRect( Enhanced : Boolean; const FileName : String; const Rect : TRect)');
    RegisterMethod('Procedure SetBrushCanvas( AColor : TColor; ABrush : TChartBrush; ABackColor : TColor)');
    RegisterMethod('Procedure SetInternalCanvas( NewCanvas : TCanvas3D)');
    RegisterMethod('Procedure ReCalcWidthHeight');
    RegisterMethod('Function TeeCreateMetafile( Enhanced : Boolean; const Rect : TRect) : TMetafile');
    RegisterProperty('ApplyZOrder', 'Boolean', iptrw);
    RegisterProperty('AutoRepaint', 'Boolean', iptrw);
    RegisterProperty('Border', 'TChartHiddenPen', iptrw);
    RegisterProperty('BorderRound', 'Integer', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('BufferedDisplay', 'Boolean', iptrw);
    RegisterProperty('CancelMouse', 'Boolean', iptrw);
    RegisterProperty('Canvas', 'TCanvas3D', iptrw);
    RegisterProperty('ChartBounds', 'TRect', iptr);
    RegisterProperty('ChartHeight', 'Integer', iptr);
    RegisterProperty('ChartWidth', 'Integer', iptr);
    RegisterProperty('ChartXCenter', 'Integer', iptr);
    RegisterProperty('ChartYCenter', 'Integer', iptr);
    RegisterProperty('CustomChartRect', 'Boolean', iptrw);
    RegisterProperty('DelphiCanvas', 'TCanvas', iptr);
    RegisterProperty('Height3D', 'Integer', iptrw);
    RegisterProperty('IPanning', 'TZoomPanning', iptr);
    RegisterProperty('Listeners', 'TTeeEventListeners', iptr);
    RegisterProperty('OriginalCursor', 'TCursor', iptrw);
    RegisterProperty('Printing', 'Boolean', iptrw);
    RegisterProperty('Width3D', 'Integer', iptrw);
    RegisterProperty('PrintResolution', 'Integer', iptrw);
    RegisterProperty('MarginLeft', 'Integer', iptrw);
    RegisterProperty('MarginTop', 'Integer', iptrw);
    RegisterProperty('MarginRight', 'Integer', iptrw);
    RegisterProperty('MarginBottom', 'Integer', iptrw);
    RegisterProperty('MarginUnits', 'TTeeUnits', iptrw);
    RegisterProperty('Monochrome', 'Boolean', iptrw);
    RegisterProperty('PrintProportional', 'Boolean', iptrw);
    RegisterProperty('Shadow', 'TTeeShadow', iptrw);
    RegisterProperty('View3D', 'Boolean', iptrw);
    RegisterProperty('View3DOptions', 'TView3DOptions', iptrw);
    RegisterProperty('Aspect', 'TView3DOptions', iptrw);
    RegisterProperty('OnBeforePrint', 'TTeePrintEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeMouseEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTeeMouseEvent') do
  with CL.AddClassN(CL.FindClass('TTeeEvent'),'TTeeMouseEvent') do begin
    RegisterProperty('Event', 'TTeeMouseEventKind', iptrw);
    RegisterProperty('Button', 'TMouseButton', iptrw);
    RegisterProperty('Shift', 'TShiftState', iptrw);
    RegisterProperty('X', 'Integer', iptrw);
    RegisterProperty('Y', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeEventListeners(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTeeEventListeners') do
  with CL.AddClassN(CL.FindClass('TList'),'TTeeEventListeners') do begin
    RegisterMethod('Function Add( const Item : ITeeEventListener) : Integer');
    RegisterMethod('Function Remove( Item : ITeeEventListener) : Integer');
    RegisterProperty('Items', 'ITeeEventListener Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTeeEvent') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTeeEvent') do begin
    RegisterProperty('Sender', 'TCustomTeePanel', iptrw);
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TZoomPanning(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TZoomPanning') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TZoomPanning') do begin
    RegisterProperty('X0', 'Integer', iptrw);
    RegisterProperty('Y0', 'Integer', iptrw);
    RegisterProperty('X1', 'Integer', iptrw);
    RegisterProperty('Y1', 'Integer', iptrw);
    RegisterMethod('Procedure Check');
    RegisterMethod('Procedure Activate( x, y : Integer)');
    RegisterProperty('Active', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomPanelNoCaption(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPanel', 'TCustomPanelNoCaption') do
  with CL.AddClassN(CL.FindClass('TCustomPanel'),'TCustomPanelNoCaption') do begin
     RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMetafile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBitmap', 'TMetafile') do
  with CL.AddClassN(CL.FindClass('TBitmap'),'TMetafile') do
  begin
    RegisterProperty('Enhanced', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TeeProcs(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('TeeFormBorderStyle','').SetString( bsNone);
  SIRegister_TMetafile(CL);
 CL.AddConstantN('TeeDefVerticalMargin','LongInt').SetInt( 4);
 CL.AddConstantN('TeeDefHorizMargin','LongInt').SetInt( 3);
 CL.AddConstantN('crTeeHand','LongInt').SetInt( TCursor ( 2020 ));
 CL.AddConstantN('TeeMsg_TeeHand','String').SetString( 'crTeeHand');
 CL.AddConstantN('TeeNormalPrintDetail','LongInt').SetInt( 0);
 CL.AddConstantN('TeeHighPrintDetail','LongInt').SetInt( - 100);
 CL.AddConstantN('TeeDefault_PrintMargin','LongInt').SetInt( 15);
 CL.AddConstantN('MaxDefaultColors','LongInt').SetInt( 19);
 CL.AddConstantN('TeeTabDelimiter','Char').SetString( #9);
  CL.AddTypeS('TDateTimeStep', '( dtOneMicroSecond, dtOneMillisecond, dtOneSeco'
   +'nd, dtFiveSeconds, dtTenSeconds, dtFifteenSeconds, dtThirtySeconds, dtOneM'
   +'inute, dtFiveMinutes, dtTenMinutes, dtFifteenMinutes, dtThirtyMinutes, dtO'
   +'neHour, dtTwoHours, dtSixHours, dtTwelveHours, dtOneDay, dtTwoDays, dtThre'
   +'eDays, dtOneWeek, dtHalfMonth, dtOneMonth, dtTwoMonths, dtThreeMonths, dtF'
   +'ourMonths, dtSixMonths, dtOneYear, dtNone )');
  SIRegister_TCustomPanelNoCaption(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomTeePanel');
  SIRegister_TZoomPanning(CL);
  SIRegister_TTeeEvent(CL);
  //SIRegister_TTeeEventListeners(CL);
  CL.AddTypeS('TFourPoints', 'Array[0..3] of TPoint;');      //fix as second decl.
  CL.AddTypeS('TTeeMouseEventKind', '( meDown, meUp, meMove )');
  CL.AddTypeS('TTeeUnits', '(muPercent,muPixels)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCanvas3D');  //fix canvas  4.7.6.10
  SIRegister_TTeeMouseEvent(CL);
  SIRegister_TCustomTeePanel(CL);
  //CL.AddTypeS('TChartGradient', 'TTeeGradient');
  //CL.AddTypeS('TChartGradientClass', 'class of TChartGradient');
  CL.AddTypeS('TPanningMode', '( pmNone, pmHorizontal, pmVertical, pmBoth )');
  //CL.AddClassN(CL.FindClass('TOBJECT'),'TPenStyle');
  SIRegister_TTeeZoomPen(CL);
  SIRegister_TTeeZoomBrush(CL);
  CL.AddTypeS('TTeeZoomDirection', '( tzdHorizontal, tzdVertical, tzdBoth )');
  SIRegister_TTeeZoom(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomTeePanelExtended');
  CL.AddTypeS('TTeeBackImageMode', '( pbmStretch, pbmTile, pbmCenter, pbmCustom )');
  SIRegister_TBackImage(CL);
  SIRegister_TCustomTeePanelExtended(CL);
  //CL.AddTypeS('TChartBrushClass', 'class of TChartBrush');
  SIRegister_TTeeCustomShapeBrushPen(CL);
  CL.AddTypeS('TChartObjectShapeStyle', '( fosRectangle, fosRoundRectangle, fosEllipse )');
  CL.AddTypeS('TTextFormat', '( ttfNormal, ttfHtml )');
  SIRegister_TTeeCustomShape(CL);
  SIRegister_TTeeShape(CL);
  SIRegister_TTeeExportData(CL);
 CL.AddDelphiFunction('Function TeeStr( const Num : Integer) : String');
 CL.AddDelphiFunction('Function DateTimeDefaultFormat( const AStep : Double) : String');
 CL.AddDelphiFunction('Function TEEDaysInMonth( Year, Month : Word) : Word');
 CL.AddDelphiFunction('Function FindDateTimeStep( const StepValue : Double) : TDateTimeStep');
 CL.AddDelphiFunction('Function NextDateTimeStep( const AStep : Double) : Double');
 CL.AddDelphiFunction('Function PointInLine( const P : TPoint; const px, py, qx, qy : Integer) : Boolean;');
 CL.AddDelphiFunction('Function PointInLine1( const P, FromPoint, ToPoint : TPoint) : Boolean;');
 CL.AddDelphiFunction('Function PointInLine2( const P, FromPoint, ToPoint : TPoint; const TolerancePixels : Integer) : Boolean;');
 CL.AddDelphiFunction('Function PointInLine3( const P : TPoint; const px, py, qx, qy, TolerancePixels : Integer) : Boolean;');
 CL.AddDelphiFunction('Function PointInLineTolerance( const P : TPoint; const px, py, qx, qy, TolerancePixels : Integer) : Boolean');
 CL.AddDelphiFunction('Function PointInPolygon( const P : TPoint; const Poly : array of TPoint) : Boolean');
 CL.AddDelphiFunction('Function PointInTriangle( const P, P0, P1, P2 : TPoint) : Boolean;');
 CL.AddDelphiFunction('Function PointInTriangle1( const P : TPoint; X0, X1, Y0, Y1 : Integer) : Boolean;');
 CL.AddDelphiFunction('Function PointInHorizTriangle( const P : TPoint; Y0, Y1, X0, X1 : Integer) : Boolean');
 CL.AddDelphiFunction('Function PointInEllipse( const P : TPoint; const Rect : TRect) : Boolean;');
 CL.AddDelphiFunction('Function PointInEllipse1( const P : TPoint; Left, Top, Right, Bottom : Integer) : Boolean;');
 CL.AddDelphiFunction('Function DelphiToLocalFormat( const Format : String) : String');
 CL.AddDelphiFunction('Function LocalToDelphiFormat( const Format : String) : String');
 CL.AddDelphiFunction('Procedure TEEEnableControls( Enable : Boolean; const ControlArray : array of TControl)');
 CL.AddDelphiFunction('Function TeeRoundDate( const ADate : TDateTime; AStep : TDateTimeStep) : TDateTime');
 CL.AddDelphiFunction('Procedure TeeDateTimeIncrement( IsDateTime : Boolean; Increment : Boolean; var Value : Double; const AnIncrement : Double; tmpWhichDateTime : TDateTimeStep)');
  CL.AddTypeS('TTeeSortCompare', 'Function ( a, b : Integer) : Integer');
  CL.AddTypeS('TTeeSortSwap', 'Procedure ( a, b : Integer)');
 CL.AddDelphiFunction('Procedure TeeSort( StartIndex, EndIndex : Integer; CompareFunc : TTeeSortCompare; SwapFunc : TTeeSortSwap)');
 CL.AddDelphiFunction('Function TeeGetUniqueName( AOwner : TComponent; const AStartName : String) : string');
 CL.AddDelphiFunction('Function TeeExtractField( St : String; Index : Integer) : String;');
 CL.AddDelphiFunction('Function TeeExtractField1( St : String; Index : Integer; const Separator : String) : String;');
 CL.AddDelphiFunction('Function TeeNumFields( St : String) : Integer;');
 CL.AddDelphiFunction('Function TeeNumFields1( const St, Separator : String) : Integer;');
 CL.AddDelphiFunction('Procedure TeeGetBitmapEditor( AObject : TObject; var Bitmap : TBitmap)');
 CL.AddDelphiFunction('Procedure TeeLoadBitmap( Bitmap : TBitmap; const Name1, Name2 : String)');
 // CL.AddTypeS('TColorArray', 'array of TColor');
 CL.AddDelphiFunction('Function GetDefaultColor( const Index : Integer) : TColor');
 CL.AddDelphiFunction('Procedure SetDefaultColorPalette;');
 CL.AddDelphiFunction('Procedure SetDefaultColorPalette1( const Palette : array of TColor);');
 CL.AddConstantN('TeeCheckBoxSize','LongInt').SetInt( 11);
 CL.AddDelphiFunction('Procedure TeeDrawCheckBox( x, y : Integer; Canvas : TCanvas; Checked : Boolean; ABackColor : TColor; CheckBox : Boolean)');
 CL.AddDelphiFunction('Function TEEStrToFloatDef( const S : string; const Default : Extended) : Extended');
 CL.AddDelphiFunction('Function TryStrToFloat( const S : String; var Value : Double) : Boolean');
 CL.AddDelphiFunction('Function CrossingLines( const X1, Y1, X2, Y2, X3, Y3, X4, Y4 : Double; out x, y : Double) : Boolean');
 CL.AddDelphiFunction('Procedure TeeTranslateControl( AControl : TControl);');
 CL.AddDelphiFunction('Procedure TeeTranslateControl1( AControl : TControl; const ExcludeChilds : array of TControl);');
 CL.AddDelphiFunction('Function ReplaceChar( const AString : String; const Search : Char; const Replace : Char) : String');
 CL.AddDelphiFunction('Procedure RectToFourPoints( const ARect : TRect; const Angle : Double; var P : TFourPoints)');
 CL.AddDelphiFunction('Function TeeAntiAlias( Panel : TCustomTeePanel; ChartRect : Boolean) : TBitmap');
 //CL.AddDelphiFunction('Procedure DrawBevel( Canvas : TTeeCanvas; Bevel : TPanelBevel; var R : TRect; Width : Integer; Round : Integer)');
 CL.AddDelphiFunction('Function TeeScreenRatio( ACanvas : TCanvas3D) : Double');
 CL.AddDelphiFunction('Function TeeReadBoolOption( const AKey : String; DefaultValue : Boolean) : Boolean');
 CL.AddDelphiFunction('Procedure TeeSaveBoolOption( const AKey : String; Value : Boolean)');
 CL.AddDelphiFunction('Function TeeReadIntegerOption( const AKey : String; DefaultValue : Integer) : Integer');
 CL.AddDelphiFunction('Procedure TeeSaveIntegerOption( const AKey : String; Value : Integer)');
 CL.AddDelphiFunction('Function TeeReadStringOption( const AKey, DefaultValue : String) : String');
 CL.AddDelphiFunction('Procedure TeeSaveStringOption( const AKey, Value : String)');
 CL.AddDelphiFunction('Function TeeDefaultXMLEncoding : String');
 CL.AddDelphiFunction('Procedure ConvertTextToXML( Stream : TStream; XMLHeader : Boolean)');
  CL.AddTypeS('TeeWindowHandle', 'Integer');
 CL.AddDelphiFunction('Procedure TeeGotoURL( Handle : TeeWindowHandle; const URL : String)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TeeTranslateControl1_P( AControl : TControl; const ExcludeChilds : array of TControl);
Begin TeeProcs.TeeTranslateControl(AControl, ExcludeChilds); END;

(*----------------------------------------------------------------------------*)
Procedure TeeTranslateControl_P( AControl : TControl);
Begin TeeProcs.TeeTranslateControl(AControl); END;

(*----------------------------------------------------------------------------*)
Procedure SetDefaultColorPalette1_P( const Palette : array of TColor);
Begin TeeProcs.SetDefaultColorPalette(Palette); END;

(*----------------------------------------------------------------------------*)
Procedure SetDefaultColorPalette_P;
Begin TeeProcs.SetDefaultColorPalette; END;

(*----------------------------------------------------------------------------*)
Function TeeNumFields1_P( const St, Separator : String) : Integer;
Begin Result := TeeProcs.TeeNumFields(St, Separator); END;

(*----------------------------------------------------------------------------*)
Function TeeNumFields_P( St : String) : Integer;
Begin Result := TeeProcs.TeeNumFields(St); END;

(*----------------------------------------------------------------------------*)
Function TeeExtractField1_P( St : String; Index : Integer; const Separator : String) : String;
Begin Result := TeeProcs.TeeExtractField(St, Index, Separator); END;

(*----------------------------------------------------------------------------*)
Function TeeExtractField_P( St : String; Index : Integer) : String;
Begin Result := TeeProcs.TeeExtractField(St, Index); END;

(*----------------------------------------------------------------------------*)
Function PointInEllipse1_P( const P : TPoint; Left, Top, Right, Bottom : Integer) : Boolean;
Begin Result := TeeProcs.PointInEllipse(P, Left, Top, Right, Bottom); END;

(*----------------------------------------------------------------------------*)
Function PointInEllipse_P( const P : TPoint; const Rect : TRect) : Boolean;
Begin Result := TeeProcs.PointInEllipse(P, Rect); END;

(*----------------------------------------------------------------------------*)
Function PointInTriangle1_P( const P : TPoint; X0, X1, Y0, Y1 : Integer) : Boolean;
Begin Result := TeeProcs.PointInTriangle(P, X0, X1, Y0, Y1); END;

(*----------------------------------------------------------------------------*)
Function PointInTriangle_P( const P, P0, P1, P2 : TPoint) : Boolean;
Begin Result := TeeProcs.PointInTriangle(P, P0, P1, P2); END;

(*----------------------------------------------------------------------------*)
Function PointInLine3_P( const P : TPoint; const px, py, qx, qy, TolerancePixels : Integer) : Boolean;
Begin Result := TeeProcs.PointInLine(P, px, py, qx, qy, TolerancePixels); END;

(*----------------------------------------------------------------------------*)
Function PointInLine2_P( const P, FromPoint, ToPoint : TPoint; const TolerancePixels : Integer) : Boolean;
Begin Result := TeeProcs.PointInLine(P, FromPoint, ToPoint, TolerancePixels); END;

(*----------------------------------------------------------------------------*)
Function PointInLine1_P( const P, FromPoint, ToPoint : TPoint) : Boolean;
Begin Result := TeeProcs.PointInLine(P, FromPoint, ToPoint); END;

(*----------------------------------------------------------------------------*)
Function PointInLine_P( const P : TPoint; const px, py, qx, qy : Integer) : Boolean;
Begin Result := TeeProcs.PointInLine(P, px, py, qx, qy); END;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeTransparent_W(Self: TTeeCustomShape; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeTransparent_R(Self: TTeeCustomShape; var T: Boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeTextFormat_W(Self: TTeeCustomShape; const T: TTextFormat);
begin Self.TextFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeTextFormat_R(Self: TTeeCustomShape; var T: TTextFormat);
begin T := Self.TextFormat; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeShapeStyle_W(Self: TTeeCustomShape; const T: TChartObjectShapeStyle);
begin Self.ShapeStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeShapeStyle_R(Self: TTeeCustomShape; var T: TChartObjectShapeStyle);
begin T := Self.ShapeStyle; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeShadow_W(Self: TTeeCustomShape; const T: TTeeShadow);
begin Self.Shadow := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeShadow_R(Self: TTeeCustomShape; var T: TTeeShadow);
begin T := Self.Shadow; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeRoundSize_W(Self: TTeeCustomShape; const T: Integer);
begin Self.RoundSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeRoundSize_R(Self: TTeeCustomShape; var T: Integer);
begin T := Self.RoundSize; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapePicture_W(Self: TTeeCustomShape; const T: TBackImage);
begin Self.Picture := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapePicture_R(Self: TTeeCustomShape; var T: TBackImage);
begin T := Self.Picture; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeGradient_W(Self: TTeeCustomShape; const T: TChartGradient);
begin Self.Gradient := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeGradient_R(Self: TTeeCustomShape; var T: TChartGradient);
begin T := Self.Gradient; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeFont_W(Self: TTeeCustomShape; const T: TTeeFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeFont_R(Self: TTeeCustomShape; var T: TTeeFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeColor_W(Self: TTeeCustomShape; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeColor_R(Self: TTeeCustomShape; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBevelWidth_W(Self: TTeeCustomShape; const T: TBevelWidth);
begin Self.BevelWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBevelWidth_R(Self: TTeeCustomShape; var T: TBevelWidth);
begin T := Self.BevelWidth; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBevel_W(Self: TTeeCustomShape; const T: TPanelBevel);
begin Self.Bevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBevel_R(Self: TTeeCustomShape; var T: TPanelBevel);
begin T := Self.Bevel; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeWidth_W(Self: TTeeCustomShape; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeWidth_R(Self: TTeeCustomShape; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeHeight_W(Self: TTeeCustomShape; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeHeight_R(Self: TTeeCustomShape; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeShadowSize_W(Self: TTeeCustomShape; const T: Integer);
begin Self.ShadowSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeShadowSize_R(Self: TTeeCustomShape; var T: Integer);
begin T := Self.ShadowSize; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeShadowColor_W(Self: TTeeCustomShape; const T: TColor);
begin Self.ShadowColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeShadowColor_R(Self: TTeeCustomShape; var T: TColor);
begin T := Self.ShadowColor; end;

(*----------------------------------------------------------------------------*)
Procedure TTeeCustomShapeDrawRectRotated1_P(Self: TTeeCustomShape;  Panel : TCustomTeePanel; Rect : TRect; Angle : Integer; AZ : Integer);
Begin Self.DrawRectRotated(Panel, Rect, Angle, AZ); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCustomShapeDrawRectRotated_P(Self: TTeeCustomShape;  Rect : TRect; Angle : Integer; AZ : Integer);
Begin Self.DrawRectRotated(Rect, Angle, AZ); END;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeShapeBounds_W(Self: TTeeCustomShape; const T: TRect);
Begin Self.ShapeBounds := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeShapeBounds_R(Self: TTeeCustomShape; var T: TRect);
Begin T := Self.ShapeBounds; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeDefaultTransparent_W(Self: TTeeCustomShape; const T: Boolean);
Begin //Self.DefaultTransparent := T;
end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeDefaultTransparent_R(Self: TTeeCustomShape; var T: Boolean);
Begin //T := //Self.DefaultTransparent;
end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBrushPenVisible_W(Self: TTeeCustomShapeBrushPen; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBrushPenVisible_R(Self: TTeeCustomShapeBrushPen; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBrushPenPen_W(Self: TTeeCustomShapeBrushPen; const T: TChartPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBrushPenPen_R(Self: TTeeCustomShapeBrushPen; var T: TChartPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBrushPenParentChart_W(Self: TTeeCustomShapeBrushPen; const T: TCustomTeePanel);
begin Self.ParentChart := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBrushPenParentChart_R(Self: TTeeCustomShapeBrushPen; var T: TCustomTeePanel);
begin T := Self.ParentChart; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBrushPenFrame_W(Self: TTeeCustomShapeBrushPen; const T: TChartPen);
begin Self.Frame := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBrushPenFrame_R(Self: TTeeCustomShapeBrushPen; var T: TChartPen);
begin T := Self.Frame; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBrushPenBrush_W(Self: TTeeCustomShapeBrushPen; const T: TChartBrush);
begin Self.Brush := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapeBrushPenBrush_R(Self: TTeeCustomShapeBrushPen; var T: TChartBrush);
begin T := Self.Brush; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedOnZoom_W(Self: TCustomTeePanelExtended; const T: TNotifyEvent);
begin Self.OnZoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedOnZoom_R(Self: TCustomTeePanelExtended; var T: TNotifyEvent);
begin T := Self.OnZoom; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedOnUndoZoom_W(Self: TCustomTeePanelExtended; const T: TNotifyEvent);
begin Self.OnUndoZoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedOnUndoZoom_R(Self: TCustomTeePanelExtended; var T: TNotifyEvent);
begin T := Self.OnUndoZoom; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedOnScroll_W(Self: TCustomTeePanelExtended; const T: TNotifyEvent);
begin Self.OnScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedOnScroll_R(Self: TCustomTeePanelExtended; var T: TNotifyEvent);
begin T := Self.OnScroll; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedOnAfterDraw_W(Self: TCustomTeePanelExtended; const T: TNotifyEvent);
begin Self.OnAfterDraw := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedOnAfterDraw_R(Self: TCustomTeePanelExtended; var T: TNotifyEvent);
begin T := Self.OnAfterDraw; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedZoom_W(Self: TCustomTeePanelExtended; const T: TTeeZoom);
begin Self.Zoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedZoom_R(Self: TCustomTeePanelExtended; var T: TTeeZoom);
begin T := Self.Zoom; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedGradient_W(Self: TCustomTeePanelExtended; const T: TChartGradient);
begin Self.Gradient := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedGradient_R(Self: TCustomTeePanelExtended; var T: TChartGradient);
begin T := Self.Gradient; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedBackImageTransp_W(Self: TCustomTeePanelExtended; const T: Boolean);
begin Self.BackImageTransp := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedBackImageTransp_R(Self: TCustomTeePanelExtended; var T: Boolean);
begin T := Self.BackImageTransp; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedBackImageMode_W(Self: TCustomTeePanelExtended; const T: TTeeBackImageMode);
begin Self.BackImageMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedBackImageMode_R(Self: TCustomTeePanelExtended; var T: TTeeBackImageMode);
begin T := Self.BackImageMode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedBackImageInside_W(Self: TCustomTeePanelExtended; const T: Boolean);
begin Self.BackImageInside := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedBackImageInside_R(Self: TCustomTeePanelExtended; var T: Boolean);
begin T := Self.BackImageInside; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedBackImage_W(Self: TCustomTeePanelExtended; const T: TBackImage);
begin Self.BackImage := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedBackImage_R(Self: TCustomTeePanelExtended; var T: TBackImage);
begin T := Self.BackImage; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedAnimatedZoomSteps_W(Self: TCustomTeePanelExtended; const T: Integer);
begin Self.AnimatedZoomSteps := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedAnimatedZoomSteps_R(Self: TCustomTeePanelExtended; var T: Integer);
begin T := Self.AnimatedZoomSteps; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedAnimatedZoom_W(Self: TCustomTeePanelExtended; const T: Boolean);
begin Self.AnimatedZoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedAnimatedZoom_R(Self: TCustomTeePanelExtended; var T: Boolean);
begin T := Self.AnimatedZoom; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedAllowZoom_W(Self: TCustomTeePanelExtended; const T: Boolean);
begin Self.AllowZoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedAllowZoom_R(Self: TCustomTeePanelExtended; var T: Boolean);
begin T := Self.AllowZoom; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedAllowPanning_W(Self: TCustomTeePanelExtended; const T: TPanningMode);
begin Self.AllowPanning := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedAllowPanning_R(Self: TCustomTeePanelExtended; var T: TPanningMode);
begin T := Self.AllowPanning; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedZoomed_W(Self: TCustomTeePanelExtended; const T: Boolean);
begin Self.Zoomed := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelExtendedZoomed_R(Self: TCustomTeePanelExtended; var T: Boolean);
begin T := Self.Zoomed; end;

(*----------------------------------------------------------------------------*)
procedure TBackImageTop_W(Self: TBackImage; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TBackImageTop_R(Self: TBackImage; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TBackImageMode_W(Self: TBackImage; const T: TTeeBackImageMode);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TBackImageMode_R(Self: TBackImage; var T: TTeeBackImageMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TBackImageLeft_W(Self: TBackImage; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TBackImageLeft_R(Self: TBackImage; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TBackImageInside_W(Self: TBackImage; const T: Boolean);
begin Self.Inside := T; end;

(*----------------------------------------------------------------------------*)
procedure TBackImageInside_R(Self: TBackImage; var T: Boolean);
begin T := Self.Inside; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomUpLeftZooms_W(Self: TTeeZoom; const T: Boolean);
begin Self.UpLeftZooms := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomUpLeftZooms_R(Self: TTeeZoom; var T: Boolean);
begin T := Self.UpLeftZooms; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomPen_W(Self: TTeeZoom; const T: TTeeZoomPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomPen_R(Self: TTeeZoom; var T: TTeeZoomPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomMouseButton_W(Self: TTeeZoom; const T: TMouseButton);
begin Self.MouseButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomMouseButton_R(Self: TTeeZoom; var T: TMouseButton);
begin T := Self.MouseButton; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomMinimumPixels_W(Self: TTeeZoom; const T: Integer);
begin Self.MinimumPixels := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomMinimumPixels_R(Self: TTeeZoom; var T: Integer);
begin T := Self.MinimumPixels; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomKeyShift_W(Self: TTeeZoom; const T: TShiftState);
begin Self.KeyShift := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomKeyShift_R(Self: TTeeZoom; var T: TShiftState);
begin T := Self.KeyShift; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomDirection_W(Self: TTeeZoom; const T: TTeeZoomDirection);
begin Self.Direction := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomDirection_R(Self: TTeeZoom; var T: TTeeZoomDirection);
begin T := Self.Direction; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomBrush_W(Self: TTeeZoom; const T: TTeeZoomBrush);
begin Self.Brush := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomBrush_R(Self: TTeeZoom; var T: TTeeZoomBrush);
begin T := Self.Brush; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomAnimatedSteps_W(Self: TTeeZoom; const T: Integer);
begin Self.AnimatedSteps := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomAnimatedSteps_R(Self: TTeeZoom; var T: Integer);
begin T := Self.AnimatedSteps; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomAnimated_W(Self: TTeeZoom; const T: Boolean);
begin Self.Animated := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomAnimated_R(Self: TTeeZoom; var T: Boolean);
begin T := Self.Animated; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomAllow_W(Self: TTeeZoom; const T: Boolean);
begin Self.Allow := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomAllow_R(Self: TTeeZoom; var T: Boolean);
begin T := Self.Allow; end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomPenDefaultColor_W(Self: TTeeZoomPen; const T: TColor);
Begin //Self.DefaultColor := T;
end;

(*----------------------------------------------------------------------------*)
procedure TTeeZoomPenDefaultColor_R(Self: TTeeZoomPen; var T: TColor);
Begin //T := Self.DefaultColor;
end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelOnBeforePrint_W(Self: TCustomTeePanel; const T: TTeePrintEvent);
begin Self.OnBeforePrint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelOnBeforePrint_R(Self: TCustomTeePanel; var T: TTeePrintEvent);
begin T := Self.OnBeforePrint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelAspect_W(Self: TCustomTeePanel; const T: TView3DOptions);
begin Self.Aspect := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelAspect_R(Self: TCustomTeePanel; var T: TView3DOptions);
begin T := Self.Aspect; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelView3DOptions_W(Self: TCustomTeePanel; const T: TView3DOptions);
begin Self.View3DOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelView3DOptions_R(Self: TCustomTeePanel; var T: TView3DOptions);
begin T := Self.View3DOptions; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelView3D_W(Self: TCustomTeePanel; const T: Boolean);
begin Self.View3D := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelView3D_R(Self: TCustomTeePanel; var T: Boolean);
begin T := Self.View3D; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelShadow_W(Self: TCustomTeePanel; const T: TTeeShadow);
begin Self.Shadow := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelShadow_R(Self: TCustomTeePanel; var T: TTeeShadow);
begin T := Self.Shadow; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelPrintProportional_W(Self: TCustomTeePanel; const T: Boolean);
begin Self.PrintProportional := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelPrintProportional_R(Self: TCustomTeePanel; var T: Boolean);
begin T := Self.PrintProportional; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMonochrome_W(Self: TCustomTeePanel; const T: Boolean);
begin Self.Monochrome := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMonochrome_R(Self: TCustomTeePanel; var T: Boolean);
begin T := Self.Monochrome; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMarginUnits_W(Self: TCustomTeePanel; const T: TTeeUnits);
begin Self.MarginUnits := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMarginUnits_R(Self: TCustomTeePanel; var T: TTeeUnits);
begin T := Self.MarginUnits; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMarginBottom_W(Self: TCustomTeePanel; const T: Integer);
begin Self.MarginBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMarginBottom_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.MarginBottom; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMarginRight_W(Self: TCustomTeePanel; const T: Integer);
begin Self.MarginRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMarginRight_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.MarginRight; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMarginTop_W(Self: TCustomTeePanel; const T: Integer);
begin Self.MarginTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMarginTop_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.MarginTop; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMarginLeft_W(Self: TCustomTeePanel; const T: Integer);
begin Self.MarginLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelMarginLeft_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.MarginLeft; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelPrintResolution_W(Self: TCustomTeePanel; const T: Integer);
begin Self.PrintResolution := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelPrintResolution_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.PrintResolution; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelWidth3D_W(Self: TCustomTeePanel; const T: Integer);
begin Self.Width3D := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelWidth3D_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.Width3D; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelPrinting_W(Self: TCustomTeePanel; const T: Boolean);
begin Self.Printing := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelPrinting_R(Self: TCustomTeePanel; var T: Boolean);
begin T := Self.Printing; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelOriginalCursor_W(Self: TCustomTeePanel; const T: TCursor);
begin Self.OriginalCursor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelOriginalCursor_R(Self: TCustomTeePanel; var T: TCursor);
begin T := Self.OriginalCursor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelListeners_R(Self: TCustomTeePanel; var T: TTeeEventListeners);
begin //T := Self.Listeners;
end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelIPanning_R(Self: TCustomTeePanel; var T: TZoomPanning);
begin T := Self.IPanning; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelHeight3D_W(Self: TCustomTeePanel; const T: Integer);
begin Self.Height3D := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelHeight3D_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.Height3D; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelDelphiCanvas_R(Self: TCustomTeePanel; var T: TCanvas);
begin T := Self.DelphiCanvas; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelCustomChartRect_W(Self: TCustomTeePanel; const T: Boolean);
begin Self.CustomChartRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelCustomChartRect_R(Self: TCustomTeePanel; var T: Boolean);
begin T := Self.CustomChartRect; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelChartYCenter_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.ChartYCenter; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelChartXCenter_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.ChartXCenter; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelChartWidth_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.ChartWidth; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelChartHeight_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.ChartHeight; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelChartBounds_R(Self: TCustomTeePanel; var T: TRect);
begin T := Self.ChartBounds; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelCanvas_W(Self: TCustomTeePanel; const T: TCanvas3D);
begin Self.Canvas := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelCanvas_R(Self: TCustomTeePanel; var T: TCanvas3D);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelCancelMouse_W(Self: TCustomTeePanel; const T: Boolean);
begin Self.CancelMouse := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelCancelMouse_R(Self: TCustomTeePanel; var T: Boolean);
begin T := Self.CancelMouse; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelBufferedDisplay_W(Self: TCustomTeePanel; const T: Boolean);
begin Self.BufferedDisplay := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelBufferedDisplay_R(Self: TCustomTeePanel; var T: Boolean);
begin T := Self.BufferedDisplay; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelBorderStyle_W(Self: TCustomTeePanel; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelBorderStyle_R(Self: TCustomTeePanel; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelBorderRound_W(Self: TCustomTeePanel; const T: Integer);
begin Self.BorderRound := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelBorderRound_R(Self: TCustomTeePanel; var T: Integer);
begin T := Self.BorderRound; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelBorder_W(Self: TCustomTeePanel; const T: TChartHiddenPen);
begin Self.Border := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelBorder_R(Self: TCustomTeePanel; var T: TChartHiddenPen);
begin T := Self.Border; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelAutoRepaint_W(Self: TCustomTeePanel; const T: Boolean);
begin Self.AutoRepaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelAutoRepaint_R(Self: TCustomTeePanel; var T: Boolean);
begin T := Self.AutoRepaint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelApplyZOrder_W(Self: TCustomTeePanel; const T: Boolean);
begin Self.ApplyZOrder := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelApplyZOrder_R(Self: TCustomTeePanel; var T: Boolean);
begin T := Self.ApplyZOrder; end;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeePanelSaveToBitmapFile1_P(Self: TCustomTeePanel;  const FileName : String; const R : TRect);
Begin Self.SaveToBitmapFile(FileName, R); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeePanelSaveToBitmapFile_P(Self: TCustomTeePanel;  const FileName : String);
Begin Self.SaveToBitmapFile(FileName); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeePanelDraw1_P(Self: TCustomTeePanel);
Begin Self.Draw; END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeePanelDraw_P(Self: TCustomTeePanel;  UserCanvas : TCanvas; const UserRect : TRect);
Begin Self.Draw(UserCanvas, UserRect); END;

(*----------------------------------------------------------------------------*)
Function TCustomTeePanelTeeCreateBitmap1_P(Self: TCustomTeePanel) : TBitmap;
Begin Result := Self.TeeCreateBitmap; END;

(*----------------------------------------------------------------------------*)
Function TCustomTeePanelTeeCreateBitmap_P(Self: TCustomTeePanel;  ABackColor : TColor; const Rect : TRect; APixelFormat : TPixelFormat) : TBitmap;
Begin Result := Self.TeeCreateBitmap(ABackColor, Rect, APixelFormat); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeePanelCopyToClipboardMetafile1_P(Self: TCustomTeePanel;  Enhanced : Boolean; const R : TRect);
Begin Self.CopyToClipboardMetafile(Enhanced, R); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeePanelCopyToClipboardMetafile_P(Self: TCustomTeePanel;  Enhanced : Boolean);
Begin Self.CopyToClipboardMetafile(Enhanced); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeePanelCopyToClipboardBitmap1_P(Self: TCustomTeePanel;  const R : TRect);
Begin Self.CopyToClipboardBitmap(R); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeePanelCopyToClipboardBitmap_P(Self: TCustomTeePanel);
Begin Self.CopyToClipboardBitmap; END;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelInternalCanvas_W(Self: TCustomTeePanel; const T: TCanvas3D);
Begin //Self.InternalCanvas := T;
 end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelInternalCanvas_R(Self: TCustomTeePanel; var T: TCanvas3D);
Begin //T := Self.InternalCanvas;
 end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelChartRect_W(Self: TCustomTeePanel; const T: TRect);
Begin Self.ChartRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelChartRect_R(Self: TCustomTeePanel; var T: TRect);
Begin T := Self.ChartRect; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelGLComponent_W(Self: TCustomTeePanel; const T: TComponent);
begin //Self.GLComponent := T;
 end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeePanelGLComponent_R(Self: TCustomTeePanel; var T: TComponent);
begin //T := Self.GLComponent;
end;

(*----------------------------------------------------------------------------*)
procedure TTeeMouseEventY_W(Self: TTeeMouseEvent; const T: Integer);
Begin Self.Y := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeMouseEventY_R(Self: TTeeMouseEvent; var T: Integer);
Begin T := Self.Y; end;

(*----------------------------------------------------------------------------*)
procedure TTeeMouseEventX_W(Self: TTeeMouseEvent; const T: Integer);
Begin Self.X := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeMouseEventX_R(Self: TTeeMouseEvent; var T: Integer);
Begin T := Self.X; end;

(*----------------------------------------------------------------------------*)
procedure TTeeMouseEventShift_W(Self: TTeeMouseEvent; const T: TShiftState);
Begin Self.Shift := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeMouseEventShift_R(Self: TTeeMouseEvent; var T: TShiftState);
Begin T := Self.Shift; end;

(*----------------------------------------------------------------------------*)
procedure TTeeMouseEventButton_W(Self: TTeeMouseEvent; const T: TMouseButton);
Begin Self.Button := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeMouseEventButton_R(Self: TTeeMouseEvent; var T: TMouseButton);
Begin T := Self.Button; end;

(*----------------------------------------------------------------------------*)
procedure TTeeMouseEventEvent_W(Self: TTeeMouseEvent; const T: TTeeMouseEventKind);
Begin Self.Event := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeMouseEventEvent_R(Self: TTeeMouseEvent; var T: TTeeMouseEventKind);
Begin T := Self.Event; end;

(*----------------------------------------------------------------------------*)
procedure TTeeEventListenersItems_R(Self: TTeeEventListeners; var T: ITeeEventListener; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTeeEventSender_W(Self: TTeeEvent; const T: TCustomTeePanel);
Begin Self.Sender := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeEventSender_R(Self: TTeeEvent; var T: TCustomTeePanel);
Begin T := Self.Sender; end;

(*----------------------------------------------------------------------------*)
procedure TZoomPanningActive_W(Self: TZoomPanning; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TZoomPanningActive_R(Self: TZoomPanning; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TZoomPanningY1_W(Self: TZoomPanning; const T: Integer);
Begin Self.Y1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TZoomPanningY1_R(Self: TZoomPanning; var T: Integer);
Begin T := Self.Y1; end;

(*----------------------------------------------------------------------------*)
procedure TZoomPanningX1_W(Self: TZoomPanning; const T: Integer);
Begin Self.X1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TZoomPanningX1_R(Self: TZoomPanning; var T: Integer);
Begin T := Self.X1; end;

(*----------------------------------------------------------------------------*)
procedure TZoomPanningY0_W(Self: TZoomPanning; const T: Integer);
Begin Self.Y0 := T; end;

(*----------------------------------------------------------------------------*)
procedure TZoomPanningY0_R(Self: TZoomPanning; var T: Integer);
Begin T := Self.Y0; end;

(*----------------------------------------------------------------------------*)
procedure TZoomPanningX0_W(Self: TZoomPanning; const T: Integer);
Begin Self.X0 := T; end;

(*----------------------------------------------------------------------------*)
procedure TZoomPanningX0_R(Self: TZoomPanning; var T: Integer);
Begin T := Self.X0; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileEnhanced_W(Self: TMetafile; const T: Boolean);
begin Self.Enhanced := T; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileEnhanced_R(Self: TMetafile; var T: Boolean);
begin T := Self.Enhanced; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TeeProcs_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TeeStr, 'TeeStr', cdRegister);
 S.RegisterDelphiFunction(@DateTimeDefaultFormat, 'DateTimeDefaultFormat', cdRegister);
 S.RegisterDelphiFunction(@DaysInMonth, 'TEEDaysInMonth', cdRegister);
 S.RegisterDelphiFunction(@FindDateTimeStep, 'FindDateTimeStep', cdRegister);
 S.RegisterDelphiFunction(@NextDateTimeStep, 'NextDateTimeStep', cdRegister);
 S.RegisterDelphiFunction(@PointInLine, 'PointInLine', cdRegister);
 S.RegisterDelphiFunction(@PointInLine1_P, 'PointInLine1', cdRegister);
 S.RegisterDelphiFunction(@PointInLine2_p, 'PointInLine2', cdRegister);
 S.RegisterDelphiFunction(@PointInLine3_P, 'PointInLine3', cdRegister);
 S.RegisterDelphiFunction(@PointInLineTolerance, 'PointInLineTolerance', cdRegister);
 S.RegisterDelphiFunction(@PointInPolygon, 'PointInPolygon', cdRegister);
 S.RegisterDelphiFunction(@PointInTriangle, 'PointInTriangle', cdRegister);
 S.RegisterDelphiFunction(@PointInTriangle1_P, 'PointInTriangle1', cdRegister);
 S.RegisterDelphiFunction(@PointInHorizTriangle, 'PointInHorizTriangle', cdRegister);
 S.RegisterDelphiFunction(@PointInEllipse, 'PointInEllipse', cdRegister);
 S.RegisterDelphiFunction(@PointInEllipse1_P, 'PointInEllipse1', cdRegister);
 S.RegisterDelphiFunction(@DelphiToLocalFormat, 'DelphiToLocalFormat', cdRegister);
 S.RegisterDelphiFunction(@LocalToDelphiFormat, 'LocalToDelphiFormat', cdRegister);
 S.RegisterDelphiFunction(@EnableControls, 'TEEEnableControls', cdRegister);
 S.RegisterDelphiFunction(@TeeRoundDate, 'TeeRoundDate', cdRegister);
 S.RegisterDelphiFunction(@TeeDateTimeIncrement, 'TeeDateTimeIncrement', cdRegister);
 S.RegisterDelphiFunction(@TeeSort, 'TeeSort', cdRegister);
 S.RegisterDelphiFunction(@TeeGetUniqueName, 'TeeGetUniqueName', cdRegister);
 S.RegisterDelphiFunction(@TeeExtractField, 'TeeExtractField', cdRegister);
 S.RegisterDelphiFunction(@TeeExtractField1_P, 'TeeExtractField1', cdRegister);
 S.RegisterDelphiFunction(@TeeNumFields, 'TeeNumFields', cdRegister);
 S.RegisterDelphiFunction(@TeeNumFields1_P, 'TeeNumFields1', cdRegister);
 S.RegisterDelphiFunction(@TeeGetBitmapEditor, 'TeeGetBitmapEditor', cdRegister);
 S.RegisterDelphiFunction(@TeeLoadBitmap, 'TeeLoadBitmap', cdRegister);
 S.RegisterDelphiFunction(@GetDefaultColor, 'GetDefaultColor', cdRegister);
 S.RegisterDelphiFunction(@SetDefaultColorPalette, 'SetDefaultColorPalette', cdRegister);
 S.RegisterDelphiFunction(@SetDefaultColorPalette1_P, 'SetDefaultColorPalette1', cdRegister);
 S.RegisterDelphiFunction(@TeeDrawCheckBox, 'TeeDrawCheckBox', cdRegister);
 S.RegisterDelphiFunction(@StrToFloatDef, 'TEEStrToFloatDef', cdRegister);
 S.RegisterDelphiFunction(@TryStrToFloat, 'TryStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@CrossingLines, 'CrossingLines', cdRegister);
 S.RegisterDelphiFunction(@TeeTranslateControl, 'TeeTranslateControl', cdRegister);
 S.RegisterDelphiFunction(@TeeTranslateControl1_P, 'TeeTranslateControl1', cdRegister);
 S.RegisterDelphiFunction(@ReplaceChar, 'ReplaceChar', cdRegister);
 S.RegisterDelphiFunction(@RectToFourPoints, 'RectToFourPoints', cdRegister);
 S.RegisterDelphiFunction(@TeeAntiAlias, 'TeeAntiAlias', cdRegister);
 S.RegisterDelphiFunction(@DrawBevel, 'DrawBevel', cdRegister);
 S.RegisterDelphiFunction(@ScreenRatio, 'TEEScreenRatio', cdRegister);
 S.RegisterDelphiFunction(@TeeReadBoolOption, 'TeeReadBoolOption', cdRegister);
 S.RegisterDelphiFunction(@TeeSaveBoolOption, 'TeeSaveBoolOption', cdRegister);
 S.RegisterDelphiFunction(@TeeReadIntegerOption, 'TeeReadIntegerOption', cdRegister);
 S.RegisterDelphiFunction(@TeeSaveIntegerOption, 'TeeSaveIntegerOption', cdRegister);
 S.RegisterDelphiFunction(@TeeReadStringOption, 'TeeReadStringOption', cdRegister);
 S.RegisterDelphiFunction(@TeeSaveStringOption, 'TeeSaveStringOption', cdRegister);
 S.RegisterDelphiFunction(@TeeDefaultXMLEncoding, 'TeeDefaultXMLEncoding', cdRegister);
 S.RegisterDelphiFunction(@ConvertTextToXML, 'ConvertTextToXML', cdRegister);
 S.RegisterDelphiFunction(@TeeGotoURL, 'TeeGotoURL', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeExportData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeExportData) do begin
    RegisterVirtualMethod(@TTeeExportData.AsString, 'AsString');
    RegisterVirtualMethod(@TTeeExportData.CopyToClipboard, 'CopyToClipboard');
    RegisterVirtualMethod(@TTeeExportData.SaveToFile, 'SaveToFile');
    RegisterVirtualMethod(@TTeeExportData.SaveToStream, 'SaveToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeShape(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeShape) do begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeCustomShape(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeCustomShape) do begin
    RegisterPropertyHelper(@TTeeCustomShapeDefaultTransparent_R,@TTeeCustomShapeDefaultTransparent_W,'DefaultTransparent');
    RegisterPropertyHelper(@TTeeCustomShapeShapeBounds_R,@TTeeCustomShapeShapeBounds_W,'ShapeBounds');
    RegisterConstructor(@TTeeCustomShape.Create, 'Create');
     RegisterMethod(@TTeeCustomShape.Destroy, 'Free');
    RegisterMethod(@TTeeCustomShape.Assign, 'Assign');
    RegisterMethod(@TTeeCustomShape.Draw, 'Draw');
    RegisterMethod(@TTeeCustomShapeDrawRectRotated_P, 'DrawRectRotated');
    RegisterMethod(@TTeeCustomShapeDrawRectRotated1_P, 'DrawRectRotated1');
    RegisterPropertyHelper(@TTeeCustomShapeShadowColor_R,@TTeeCustomShapeShadowColor_W,'ShadowColor');
    RegisterPropertyHelper(@TTeeCustomShapeShadowSize_R,@TTeeCustomShapeShadowSize_W,'ShadowSize');
    RegisterPropertyHelper(@TTeeCustomShapeHeight_R,@TTeeCustomShapeHeight_W,'Height');
    RegisterPropertyHelper(@TTeeCustomShapeWidth_R,@TTeeCustomShapeWidth_W,'Width');
    RegisterPropertyHelper(@TTeeCustomShapeBevel_R,@TTeeCustomShapeBevel_W,'Bevel');
    RegisterPropertyHelper(@TTeeCustomShapeBevelWidth_R,@TTeeCustomShapeBevelWidth_W,'BevelWidth');
    RegisterPropertyHelper(@TTeeCustomShapeColor_R,@TTeeCustomShapeColor_W,'Color');
    RegisterPropertyHelper(@TTeeCustomShapeFont_R,@TTeeCustomShapeFont_W,'Font');
    RegisterPropertyHelper(@TTeeCustomShapeGradient_R,@TTeeCustomShapeGradient_W,'Gradient');
    RegisterPropertyHelper(@TTeeCustomShapePicture_R,@TTeeCustomShapePicture_W,'Picture');
    RegisterPropertyHelper(@TTeeCustomShapeRoundSize_R,@TTeeCustomShapeRoundSize_W,'RoundSize');
    RegisterPropertyHelper(@TTeeCustomShapeShadow_R,@TTeeCustomShapeShadow_W,'Shadow');
    RegisterPropertyHelper(@TTeeCustomShapeShapeStyle_R,@TTeeCustomShapeShapeStyle_W,'ShapeStyle');
    RegisterPropertyHelper(@TTeeCustomShapeTextFormat_R,@TTeeCustomShapeTextFormat_W,'TextFormat');
    RegisterPropertyHelper(@TTeeCustomShapeTransparent_R,@TTeeCustomShapeTransparent_W,'Transparent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeCustomShapeBrushPen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeCustomShapeBrushPen) do begin
    RegisterConstructor(@TTeeCustomShapeBrushPen.Create, 'Create');
     RegisterMethod(@TTeeCustomShapeBrushPen.Destroy, 'Free');
    RegisterMethod(@TTeeCustomShapeBrushPen.Assign, 'Assign');
    RegisterMethod(@TTeeCustomShapeBrushPen.Show, 'Show');
    RegisterMethod(@TTeeCustomShapeBrushPen.Hide, 'Hide');
    RegisterMethod(@TTeeCustomShapeBrushPen.Repaint, 'Repaint');
    RegisterPropertyHelper(@TTeeCustomShapeBrushPenBrush_R,@TTeeCustomShapeBrushPenBrush_W,'Brush');
    RegisterPropertyHelper(@TTeeCustomShapeBrushPenFrame_R,@TTeeCustomShapeBrushPenFrame_W,'Frame');
    RegisterPropertyHelper(@TTeeCustomShapeBrushPenParentChart_R,@TTeeCustomShapeBrushPenParentChart_W,'ParentChart');
    RegisterPropertyHelper(@TTeeCustomShapeBrushPenPen_R,@TTeeCustomShapeBrushPenPen_W,'Pen');
    RegisterPropertyHelper(@TTeeCustomShapeBrushPenVisible_R,@TTeeCustomShapeBrushPenVisible_W,'Visible');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomTeePanelExtended(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomTeePanelExtended) do begin
    RegisterConstructor(@TCustomTeePanelExtended.Create, 'Create');
       RegisterMethod(@TCustomTeePanelExtended.Destroy, 'Free');
    RegisterMethod(@TCustomTeePanelExtended.Assign, 'Assign');
    RegisterMethod(@TCustomTeePanelExtended.DrawZoomRectangle, 'DrawZoomRectangle');
    RegisterMethod(@TCustomTeePanelExtended.HasBackImage, 'HasBackImage');
    RegisterVirtualMethod(@TCustomTeePanelExtended.UndoZoom, 'UndoZoom');
    RegisterPropertyHelper(@TCustomTeePanelExtendedZoomed_R,@TCustomTeePanelExtendedZoomed_W,'Zoomed');
    RegisterPropertyHelper(@TCustomTeePanelExtendedAllowPanning_R,@TCustomTeePanelExtendedAllowPanning_W,'AllowPanning');
    RegisterPropertyHelper(@TCustomTeePanelExtendedAllowZoom_R,@TCustomTeePanelExtendedAllowZoom_W,'AllowZoom');
    RegisterPropertyHelper(@TCustomTeePanelExtendedAnimatedZoom_R,@TCustomTeePanelExtendedAnimatedZoom_W,'AnimatedZoom');
    RegisterPropertyHelper(@TCustomTeePanelExtendedAnimatedZoomSteps_R,@TCustomTeePanelExtendedAnimatedZoomSteps_W,'AnimatedZoomSteps');
    RegisterPropertyHelper(@TCustomTeePanelExtendedBackImage_R,@TCustomTeePanelExtendedBackImage_W,'BackImage');
    RegisterPropertyHelper(@TCustomTeePanelExtendedBackImageInside_R,@TCustomTeePanelExtendedBackImageInside_W,'BackImageInside');
    RegisterPropertyHelper(@TCustomTeePanelExtendedBackImageMode_R,@TCustomTeePanelExtendedBackImageMode_W,'BackImageMode');
    RegisterPropertyHelper(@TCustomTeePanelExtendedBackImageTransp_R,@TCustomTeePanelExtendedBackImageTransp_W,'BackImageTransp');
    RegisterPropertyHelper(@TCustomTeePanelExtendedGradient_R,@TCustomTeePanelExtendedGradient_W,'Gradient');
    RegisterPropertyHelper(@TCustomTeePanelExtendedZoom_R,@TCustomTeePanelExtendedZoom_W,'Zoom');
    RegisterPropertyHelper(@TCustomTeePanelExtendedOnAfterDraw_R,@TCustomTeePanelExtendedOnAfterDraw_W,'OnAfterDraw');
    RegisterPropertyHelper(@TCustomTeePanelExtendedOnScroll_R,@TCustomTeePanelExtendedOnScroll_W,'OnScroll');
    RegisterPropertyHelper(@TCustomTeePanelExtendedOnUndoZoom_R,@TCustomTeePanelExtendedOnUndoZoom_W,'OnUndoZoom');
    RegisterPropertyHelper(@TCustomTeePanelExtendedOnZoom_R,@TCustomTeePanelExtendedOnZoom_W,'OnZoom');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBackImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBackImage) do
  begin
    RegisterConstructor(@TBackImage.Create, 'Create');
    RegisterMethod(@TBackImage.Assign, 'Assign');
    RegisterMethod(@TBackImage.Draw, 'Draw');
    RegisterPropertyHelper(@TBackImageInside_R,@TBackImageInside_W,'Inside');
    RegisterPropertyHelper(@TBackImageLeft_R,@TBackImageLeft_W,'Left');
    RegisterPropertyHelper(@TBackImageMode_R,@TBackImageMode_W,'Mode');
    RegisterPropertyHelper(@TBackImageTop_R,@TBackImageTop_W,'Top');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeZoom(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeZoom) do
  begin
    RegisterConstructor(@TTeeZoom.Create, 'Create');
    RegisterMethod(@TTeeZoom.Assign, 'Assign');
    RegisterPropertyHelper(@TTeeZoomAllow_R,@TTeeZoomAllow_W,'Allow');
    RegisterPropertyHelper(@TTeeZoomAnimated_R,@TTeeZoomAnimated_W,'Animated');
    RegisterPropertyHelper(@TTeeZoomAnimatedSteps_R,@TTeeZoomAnimatedSteps_W,'AnimatedSteps');
    RegisterPropertyHelper(@TTeeZoomBrush_R,@TTeeZoomBrush_W,'Brush');
    RegisterPropertyHelper(@TTeeZoomDirection_R,@TTeeZoomDirection_W,'Direction');
    RegisterPropertyHelper(@TTeeZoomKeyShift_R,@TTeeZoomKeyShift_W,'KeyShift');
    RegisterPropertyHelper(@TTeeZoomMinimumPixels_R,@TTeeZoomMinimumPixels_W,'MinimumPixels');
    RegisterPropertyHelper(@TTeeZoomMouseButton_R,@TTeeZoomMouseButton_W,'MouseButton');
    RegisterPropertyHelper(@TTeeZoomPen_R,@TTeeZoomPen_W,'Pen');
    RegisterPropertyHelper(@TTeeZoomUpLeftZooms_R,@TTeeZoomUpLeftZooms_W,'UpLeftZooms');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeZoomBrush(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeZoomBrush) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeZoomPen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeZoomPen) do
  begin
    RegisterPropertyHelper(@TTeeZoomPenDefaultColor_R,@TTeeZoomPenDefaultColor_W,'DefaultColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomTeePanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomTeePanel) do begin
      RegisterConstructor(@TCustomTeePanel.Create, 'Create');
       RegisterMethod(@TCustomTeePanel.Destroy, 'Free');
    RegisterMethod(@TCustomTeePanel.Assign, 'Assign');
    RegisterPropertyHelper(@TCustomTeePanelGLComponent_R,@TCustomTeePanelGLComponent_W,'GLComponent');
    RegisterPropertyHelper(@TCustomTeePanelChartRect_R,@TCustomTeePanelChartRect_W,'ChartRect');
    RegisterPropertyHelper(@TCustomTeePanelInternalCanvas_R,@TCustomTeePanelInternalCanvas_W,'InternalCanvas');
    RegisterMethod(@TCustomTeePanel.CalcMetaBounds, 'CalcMetaBounds');
    RegisterMethod(@TCustomTeePanel.CalcProportionalMargins, 'CalcProportionalMargins');
    RegisterMethod(@TCustomTeePanel.CanClip, 'CanClip');
    RegisterVirtualMethod(@TCustomTeePanel.CanvasChanged, 'CanvasChanged');
    RegisterMethod(@TCustomTeePanel.ChartPrintRect, 'ChartPrintRect');
    RegisterMethod(@TCustomTeePanelCopyToClipboardBitmap_P, 'CopyToClipboardBitmap');
    RegisterMethod(@TCustomTeePanelCopyToClipboardBitmap1_P, 'CopyToClipboardBitmap1');
    RegisterMethod(@TCustomTeePanelCopyToClipboardMetafile_P, 'CopyToClipboardMetafile');
    RegisterMethod(@TCustomTeePanelCopyToClipboardMetafile1_P, 'CopyToClipboardMetafile1');
    RegisterMethod(@TCustomTeePanelTeeCreateBitmap_P, 'TeeCreateBitmap');
    RegisterMethod(@TCustomTeePanelTeeCreateBitmap1_P, 'TeeCreateBitmap1');
    RegisterVirtualMethod(@TCustomTeePanelDraw_P, 'Draw');
    RegisterMethod(@TCustomTeePanelDraw1_P, 'Draw1');
    RegisterVirtualMethod(@TCustomTeePanel.DrawPanelBevels, 'DrawPanelBevels');
    RegisterMethod(@TCustomTeePanel.DrawToMetaCanvas, 'DrawToMetaCanvas');
    //RegisterVirtualMethod(@TCustomTeePanel.GetBackColor, 'GetBackColor');
    RegisterMethod(@TCustomTeePanel.GetCursorPos, 'GetCursorPos');
    RegisterVirtualMethod(@TCustomTeePanel.GetRectangle, 'GetRectangle');
    RegisterMethod(@TCustomTeePanel.IsScreenHighColor, 'IsScreenHighColor');
    RegisterMethod(@TCustomTeePanel.Print, 'Print');
    RegisterMethod(@TCustomTeePanel.PrintLandscape, 'PrintLandscape');
    RegisterMethod(@TCustomTeePanel.PrintOrientation, 'PrintOrientation');
    RegisterMethod(@TCustomTeePanel.PrintPartial, 'PrintPartial');
    RegisterMethod(@TCustomTeePanel.PrintPartialCanvas, 'PrintPartialCanvas');
    RegisterMethod(@TCustomTeePanel.PrintPortrait, 'PrintPortrait');
    RegisterMethod(@TCustomTeePanel.PrintRect, 'PrintRect');
    //RegisterMethod(@TCustomTeePanel.RemoveListener, 'RemoveListener');
    RegisterMethod(@TCustomTeePanelSaveToBitmapFile_P, 'SaveToBitmapFile');
    RegisterMethod(@TCustomTeePanelSaveToBitmapFile1_P, 'SaveToBitmapFile1');
    RegisterMethod(@TCustomTeePanel.SaveToMetafile, 'SaveToMetafile');
    RegisterMethod(@TCustomTeePanel.SaveToMetafileEnh, 'SaveToMetafileEnh');
    RegisterMethod(@TCustomTeePanel.SaveToMetafileRect, 'SaveToMetafileRect');
    RegisterMethod(@TCustomTeePanel.SetBrushCanvas, 'SetBrushCanvas');
    RegisterMethod(@TCustomTeePanel.SetInternalCanvas, 'SetInternalCanvas');
    RegisterMethod(@TCustomTeePanel.ReCalcWidthHeight, 'ReCalcWidthHeight');
    RegisterMethod(@TCustomTeePanel.TeeCreateMetafile, 'TeeCreateMetafile');
    RegisterPropertyHelper(@TCustomTeePanelApplyZOrder_R,@TCustomTeePanelApplyZOrder_W,'ApplyZOrder');
    RegisterPropertyHelper(@TCustomTeePanelAutoRepaint_R,@TCustomTeePanelAutoRepaint_W,'AutoRepaint');
    RegisterPropertyHelper(@TCustomTeePanelBorder_R,@TCustomTeePanelBorder_W,'Border');
    RegisterPropertyHelper(@TCustomTeePanelBorderRound_R,@TCustomTeePanelBorderRound_W,'BorderRound');
    RegisterPropertyHelper(@TCustomTeePanelBorderStyle_R,@TCustomTeePanelBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TCustomTeePanelBufferedDisplay_R,@TCustomTeePanelBufferedDisplay_W,'BufferedDisplay');
    RegisterPropertyHelper(@TCustomTeePanelCancelMouse_R,@TCustomTeePanelCancelMouse_W,'CancelMouse');
    RegisterPropertyHelper(@TCustomTeePanelCanvas_R,@TCustomTeePanelCanvas_W,'Canvas');
    RegisterPropertyHelper(@TCustomTeePanelChartBounds_R,nil,'ChartBounds');
    RegisterPropertyHelper(@TCustomTeePanelChartHeight_R,nil,'ChartHeight');
    RegisterPropertyHelper(@TCustomTeePanelChartWidth_R,nil,'ChartWidth');
    RegisterPropertyHelper(@TCustomTeePanelChartXCenter_R,nil,'ChartXCenter');
    RegisterPropertyHelper(@TCustomTeePanelChartYCenter_R,nil,'ChartYCenter');
    RegisterPropertyHelper(@TCustomTeePanelCustomChartRect_R,@TCustomTeePanelCustomChartRect_W,'CustomChartRect');
    RegisterPropertyHelper(@TCustomTeePanelDelphiCanvas_R,nil,'DelphiCanvas');
    RegisterPropertyHelper(@TCustomTeePanelHeight3D_R,@TCustomTeePanelHeight3D_W,'Height3D');
    RegisterPropertyHelper(@TCustomTeePanelIPanning_R,nil,'IPanning');
    RegisterPropertyHelper(@TCustomTeePanelListeners_R,nil,'Listeners');
    RegisterPropertyHelper(@TCustomTeePanelOriginalCursor_R,@TCustomTeePanelOriginalCursor_W,'OriginalCursor');
    RegisterPropertyHelper(@TCustomTeePanelPrinting_R,@TCustomTeePanelPrinting_W,'Printing');
    RegisterPropertyHelper(@TCustomTeePanelWidth3D_R,@TCustomTeePanelWidth3D_W,'Width3D');
    RegisterPropertyHelper(@TCustomTeePanelPrintResolution_R,@TCustomTeePanelPrintResolution_W,'PrintResolution');
    RegisterPropertyHelper(@TCustomTeePanelMarginLeft_R,@TCustomTeePanelMarginLeft_W,'MarginLeft');
    RegisterPropertyHelper(@TCustomTeePanelMarginTop_R,@TCustomTeePanelMarginTop_W,'MarginTop');
    RegisterPropertyHelper(@TCustomTeePanelMarginRight_R,@TCustomTeePanelMarginRight_W,'MarginRight');
    RegisterPropertyHelper(@TCustomTeePanelMarginBottom_R,@TCustomTeePanelMarginBottom_W,'MarginBottom');
    RegisterPropertyHelper(@TCustomTeePanelMarginUnits_R,@TCustomTeePanelMarginUnits_W,'MarginUnits');
    RegisterPropertyHelper(@TCustomTeePanelMonochrome_R,@TCustomTeePanelMonochrome_W,'Monochrome');
    RegisterPropertyHelper(@TCustomTeePanelPrintProportional_R,@TCustomTeePanelPrintProportional_W,'PrintProportional');
    RegisterPropertyHelper(@TCustomTeePanelShadow_R,@TCustomTeePanelShadow_W,'Shadow');
    RegisterPropertyHelper(@TCustomTeePanelView3D_R,@TCustomTeePanelView3D_W,'View3D');
    RegisterPropertyHelper(@TCustomTeePanelView3DOptions_R,@TCustomTeePanelView3DOptions_W,'View3DOptions');
    RegisterPropertyHelper(@TCustomTeePanelAspect_R,@TCustomTeePanelAspect_W,'Aspect');
    RegisterPropertyHelper(@TCustomTeePanelOnBeforePrint_R,@TCustomTeePanelOnBeforePrint_W,'OnBeforePrint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeMouseEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeMouseEvent) do
  begin
    RegisterPropertyHelper(@TTeeMouseEventEvent_R,@TTeeMouseEventEvent_W,'Event');
    RegisterPropertyHelper(@TTeeMouseEventButton_R,@TTeeMouseEventButton_W,'Button');
    RegisterPropertyHelper(@TTeeMouseEventShift_R,@TTeeMouseEventShift_W,'Shift');
    RegisterPropertyHelper(@TTeeMouseEventX_R,@TTeeMouseEventX_W,'X');
    RegisterPropertyHelper(@TTeeMouseEventY_R,@TTeeMouseEventY_W,'Y');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeEventListeners(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeEventListeners) do
  begin
    RegisterMethod(@TTeeEventListeners.Add, 'Add');
    RegisterMethod(@TTeeEventListeners.Remove, 'Remove');
    RegisterPropertyHelper(@TTeeEventListenersItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeEvent) do begin
    RegisterPropertyHelper(@TTeeEventSender_R,@TTeeEventSender_W,'Sender');
    RegisterConstructor(@TTeeEvent.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZoomPanning(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZoomPanning) do
  begin
    RegisterPropertyHelper(@TZoomPanningX0_R,@TZoomPanningX0_W,'X0');
    RegisterPropertyHelper(@TZoomPanningY0_R,@TZoomPanningY0_W,'Y0');
    RegisterPropertyHelper(@TZoomPanningX1_R,@TZoomPanningX1_W,'X1');
    RegisterPropertyHelper(@TZoomPanningY1_R,@TZoomPanningY1_W,'Y1');
    RegisterMethod(@TZoomPanning.Check, 'Check');
    RegisterMethod(@TZoomPanning.Activate, 'Activate');
    RegisterPropertyHelper(@TZoomPanningActive_R,@TZoomPanningActive_W,'Active');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomPanelNoCaption(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomPanelNoCaption) do begin
    RegisterConstructor(@TCustomPanelNoCaption.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMetafile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMetafile) do
  begin
    RegisterPropertyHelper(@TMetafileEnhanced_R,@TMetafileEnhanced_W,'Enhanced');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TeeProcs(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMetafile(CL);
  RIRegister_TCustomPanelNoCaption(CL);
  with CL.Add(TCustomTeePanel) do
  RIRegister_TZoomPanning(CL);
  RIRegister_TTeeEvent(CL);
  RIRegister_TTeeEventListeners(CL);
  RIRegister_TTeeMouseEvent(CL);
  RIRegister_TCustomTeePanel(CL);
  RIRegister_TTeeZoomPen(CL);
  RIRegister_TTeeZoomBrush(CL);
  RIRegister_TTeeZoom(CL);
  with CL.Add(TCustomTeePanelExtended) do
  RIRegister_TBackImage(CL);
  RIRegister_TCustomTeePanelExtended(CL);
  RIRegister_TTeeCustomShapeBrushPen(CL);
  RIRegister_TTeeCustomShape(CL);
  RIRegister_TTeeShape(CL);
  RIRegister_TTeeExportData(CL);
end;

 
 
{ TPSImport_TeeProcs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TeeProcs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TeeProcs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TeeProcs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TeeProcs(ri);
  RIRegister_TeeProcs_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
