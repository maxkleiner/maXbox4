unit uPSI_JvChart;
{
   after all we got it the chart component, 3.9.8.
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
  TPSImport_JvChart = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvChart(CL: TPSPascalCompiler);
procedure SIRegister_TJvChartOptions(CL: TPSPascalCompiler);
procedure SIRegister_TJvChartYAxisOptions(CL: TPSPascalCompiler);
procedure SIRegister_TJvChartData(CL: TPSPascalCompiler);
procedure SIRegister_TJvChartVerticalBar(CL: TPSPascalCompiler);
procedure SIRegister_TJvChartHorizontalBar(CL: TPSPascalCompiler);
procedure SIRegister_TJvChartGradientBar(CL: TPSPascalCompiler);
procedure SIRegister_TJvChartFloatingMarker(CL: TPSPascalCompiler);
procedure SIRegister_JvChart(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvChart(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvChartOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvChartYAxisOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvChartData(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvChartVerticalBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvChartHorizontalBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvChartGradientBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvChartFloatingMarker(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvChart(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  //,Messages
  //,Types
  Graphics
  ,Controls
  ,Contnrs
  ,JvComponent
  ,JvChart
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvChart]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvChart(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvGraphicControl', 'TJvChart') do
  with CL.AddClassN(CL.FindClass('TJvGraphicControl'),'TJvChart') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function MouseToXValue( X : Integer) : Integer');
    RegisterMethod('Function MouseToYValue( Y : Integer) : Double');
    RegisterMethod('Procedure ResetGraphModule');
    RegisterMethod('Procedure PlotGraph');
    RegisterMethod('Procedure PlotPicture( picture : TPicture; fontScaling : Double)');
    RegisterMethod('Procedure PrintGraph');
    RegisterMethod('Procedure AddGraphToOpenPrintCanvas( XStartPos, YStartPos, GraphWidth, GraphHeight : Longint)');
    RegisterMethod('Procedure GraphToClipboard');
    RegisterMethod('Procedure ResizeChartCanvas');
    RegisterMethod('Procedure PivotData');
    RegisterMethod('Procedure AutoHint');
    RegisterMethod('Procedure SetCursorPosition( Pos : Integer)');
    RegisterMethod('Procedure DisplayBars');
    RegisterMethod('Function AddFloatingMarker : TJvChartFloatingMarker');
    RegisterProperty('FloatingMarker', 'TJvChartFloatingMarker Integer', iptr);
    RegisterProperty('HorizontalBar', 'TJvChartHorizontalBar Integer', iptr);
    RegisterProperty('VerticalBar', 'TJvChartVerticalBar Integer', iptr);
    RegisterMethod('Procedure DeleteFloatingMarker( Index : Integer)');
    RegisterMethod('Procedure DeleteFloatingMarkerObj( Marker : TJvChartFloatingMarker)');
    RegisterMethod('Procedure CopyFloatingMarkers( Source : TJvChart)');
    RegisterMethod('Procedure ClearFloatingMarkers');
    RegisterMethod('Function FloatingMarkerCount : Integer');
    RegisterMethod('Function AddHorizontalBar : TJvChartHorizontalBar');
    RegisterMethod('Procedure ClearHorizontalBars');
    RegisterMethod('Function HorizontalBarsCount : Integer');
    RegisterMethod('Function AddVerticalBar : TJvChartVerticalBar');
    RegisterMethod('Procedure ClearVerticalBars');
    RegisterMethod('Function VerticalBarsCount : Integer');
    RegisterProperty('Data', 'TJvChartData', iptr);
    RegisterProperty('AverageData', 'TJvChartData', iptr);
    RegisterProperty('Picture', 'TPicture', iptr);
    RegisterProperty('CursorPosition', 'Integer', iptrw);
    RegisterProperty('Options', 'TJvChartOptions', iptrw);
    RegisterProperty('OnChartClick', 'TJvChartClickEvent', iptrw);
    RegisterProperty('OnChartPaint', 'TJvChartPaintEvent', iptrw);
    RegisterProperty('OnBeginFloatingMarkerDrag', 'TJvChartFloatingMarkerDragEvent', iptrw);
    RegisterProperty('OnEndFloatingMarkerDrag', 'TJvChartFloatingMarkerDragEvent', iptrw);
    RegisterProperty('OnYAxisClick', 'TJvChartEvent', iptrw);
    RegisterProperty('OnXAxisClick', 'TJvChartEvent', iptrw);
    RegisterProperty('OnAltYAxisClick', 'TJvChartEvent', iptrw);
    RegisterProperty('OnTitleClick', 'TJvChartEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvChartOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvChartOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvChartOptions') do begin
    RegisterMethod('Constructor Create( Owner : TJvChart)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('AverageValue', 'Double Integer', iptrw);
    RegisterProperty('PenAxis', 'TJvChartYAxisOptions Integer', iptr);
    RegisterProperty('XLegends', 'TStrings', iptrw);
    RegisterProperty('XEnd', 'Longint', iptrw);
    RegisterProperty('YEnd', 'Longint', iptrw);
    RegisterProperty('GradientColor', 'TColor', iptrw);
    RegisterProperty('GradientDirection', 'TJvChartGradientDirection', iptrw);
    RegisterProperty('XPixelGap', 'Double', iptrw);
    RegisterProperty('XLegendMaxTextWidth', 'Integer', iptrw);
    RegisterProperty('PenColor', 'TColor Integer', iptrw);
    RegisterProperty('PenStyle', 'TPenStyle Integer', iptrw);
    RegisterProperty('PenMarkerKind', 'TJvChartPenMarkerKind Integer', iptrw);
    RegisterProperty('PenSecondaryAxisFlag', 'Boolean Integer', iptrw);
    RegisterProperty('PenValueLabels', 'Boolean Integer', iptrw);
    RegisterProperty('PenLegends', 'TStrings', iptrw);
    RegisterProperty('PenUnit', 'TStrings', iptrw);
    RegisterProperty('ChartKind', 'TJvChartKind', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('NoDataMessage', 'string', iptrw);
    RegisterProperty('YAxisHeader', 'string', iptrw);
    RegisterProperty('YAxisDivisionMarkers', 'Boolean', iptrw);
    RegisterProperty('XAxisDivisionMarkers', 'Boolean', iptrw);
    RegisterProperty('XAxisValuesPerDivision', 'Integer', iptrw);
    RegisterProperty('XAxisLabelAlignment', 'TAlignment', iptrw);
    RegisterProperty('XAxisDateTimeMode', 'Boolean', iptrw);
    RegisterProperty('XAxisDateTimeDivision', 'Double', iptrw);
    RegisterProperty('XAxisDateTimeFormat', 'string', iptrw);
    RegisterProperty('XAxisHeader', 'string', iptrw);
    RegisterProperty('XAxisLegendSkipBy', 'Integer', iptrw);
    RegisterProperty('DateTimeFormat', 'string', iptrw);
    RegisterProperty('PenCount', 'Integer', iptrw);
    RegisterProperty('XGap', 'Double', iptrw);
    RegisterProperty('XOrigin', 'Integer', iptrw);
    RegisterProperty('YOrigin', 'Integer', iptrw);
    RegisterProperty('XStartOffset', 'Longint', iptrw);
    RegisterProperty('YStartOffset', 'Longint', iptrw);
    RegisterProperty('MarkerSize', 'Integer', iptrw);
    RegisterProperty('PrimaryYAxis', 'TJvChartYAxisOptions', iptrw);
    RegisterProperty('SecondaryYAxis', 'TJvChartYAxisOptions', iptrw);
    RegisterProperty('AutoUpdateGraph', 'Boolean', iptrw);
    RegisterProperty('MouseEdit', 'Boolean', iptrw);
    RegisterProperty('MouseDragObjects', 'Boolean', iptrw);
    RegisterProperty('MouseInfo', 'Boolean', iptrw);
    RegisterProperty('Legend', 'TJvChartLegend', iptrw);
    RegisterProperty('LegendRowCount', 'Integer', iptrw);
    RegisterProperty('LegendWidth', 'Integer', iptrw);
    RegisterProperty('PenLineWidth', 'Integer', iptrw);
    RegisterProperty('AxisLineWidth', 'Integer', iptrw);
    RegisterProperty('XValueCount', 'Integer', iptrw);
    RegisterProperty('HeaderFont', 'TFont', iptrw);
    RegisterProperty('LegendFont', 'TFont', iptrw);
    RegisterProperty('AxisFont', 'TFont', iptrw);
    RegisterProperty('DivisionLineColor', 'TColor', iptrw);
    RegisterProperty('ShadowColor', 'TColor', iptrw);
    RegisterProperty('PaperColor', 'TColor', iptrw);
    RegisterProperty('AxisLineColor', 'TColor', iptrw);
    RegisterProperty('HintColor', 'TColor', iptrw);
    RegisterProperty('AverageLineColor', 'TColor', iptrw);
    RegisterProperty('CursorColor', 'TColor', iptrw);
    RegisterProperty('CursorStyle', 'TPenStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvChartYAxisOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvChartYAxisOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvChartYAxisOptions') do begin
    RegisterMethod('Constructor Create( Owner : TJvChartOptions)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Normalize');
    RegisterMethod('Procedure Clear');
    RegisterProperty('YPixelGap', 'Double', iptrw);
    RegisterProperty('Active', 'Boolean', iptr);
    RegisterProperty('YGap', 'Double', iptr);
    RegisterProperty('YGap1', 'Double', iptr);
    RegisterProperty('YLegends', 'TStrings', iptrw);
    RegisterProperty('YMax', 'Double', iptrw);
    RegisterProperty('YMin', 'Double', iptrw);
    RegisterProperty('YDivisions', 'Integer', iptrw);
    RegisterProperty('MaxYDivisions', 'Integer', iptrw);
    RegisterProperty('MinYDivisions', 'Integer', iptrw);
    RegisterProperty('MarkerValueDecimals', 'Integer', iptrw);
    RegisterProperty('YLegendDecimalPlaces', 'Integer', iptrw);
    RegisterProperty('DefaultYLegends', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvChartData(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvChartData') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvChartData') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure PreGrow( Pen, ValueIndex : Integer)');
    RegisterMethod('Function DebugStr( ValueIndex : Integer) : string');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure ClearPenValues');
    RegisterMethod('Procedure Scroll');
    RegisterProperty('Value', 'Double Integer Integer', iptrw);
    SetDefaultPropery('Value');
    RegisterProperty('Timestamp', 'TDateTime Integer', iptrw);
    RegisterProperty('ValueCount', 'Integer', iptrw);
    RegisterProperty('ClearToValue', 'Double', iptrw);
    RegisterProperty('StartDateTime', 'TDateTime', iptrw);
    RegisterProperty('EndDateTime', 'TDateTime', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvChartVerticalBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvChartGradientBar', 'TJvChartVerticalBar') do
  with CL.AddClassN(CL.FindClass('TJvChartGradientBar'),'TJvChartVerticalBar') do begin
    RegisterProperty('XLeft', 'Integer', iptrw);
    RegisterProperty('XRight', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvChartHorizontalBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvChartGradientBar', 'TJvChartHorizontalBar') do
  with CL.AddClassN(CL.FindClass('TJvChartGradientBar'),'TJvChartHorizontalBar') do begin
    RegisterProperty('YTop', 'Double', iptrw);
    RegisterProperty('YBottom', 'Double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvChartGradientBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvChartGradientBar') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvChartGradientBar') do begin
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('YTop', 'Double', iptrw);
    RegisterProperty('YBottom', 'Double', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('GradDirection', 'TJvChartGradientDirection', iptrw);
    RegisterProperty('GradColor', 'TColor', iptrw);
    RegisterProperty('PenStyle', 'TPenStyle', iptrw);
    RegisterProperty('PenColor', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvChartFloatingMarker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvChartFloatingMarker') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvChartFloatingMarker') do begin
    RegisterProperty('Index', 'Integer', iptr);
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Marker', 'TJvChartPenMarkerKind', iptrw);
    RegisterProperty('MarkerColor', 'TColor', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('XPosition', 'Integer', iptrw);
    RegisterProperty('YPosition', 'Double', iptrw);
    RegisterProperty('XDraggable', 'Boolean', iptrw);
    RegisterProperty('XDragMin', 'Integer', iptrw);
    RegisterProperty('XDragMax', 'Integer', iptrw);
    RegisterProperty('YDraggable', 'Boolean', iptrw);
    RegisterProperty('LineToMarker', 'Integer', iptrw);
    RegisterProperty('LineVertical', 'Boolean', iptrw);
    RegisterProperty('LineStyle', 'TPenStyle', iptrw);
    RegisterProperty('LineColor', 'TColor', iptrw);
    RegisterProperty('LineWidth', 'Integer', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('CaptionColor', 'TColor', iptrw);
    RegisterProperty('CaptionPosition', 'TJvChartCaptionPosition', iptrw);
    RegisterProperty('CaptionBoxed', 'Boolean', iptrw);
    RegisterProperty('Tag', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvChart(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('JvChartVersion','LongInt').SetInt( 300);
 CL.AddConstantN('JvDefaultHintColor','LongWord').SetUInt( TColor ( $00DDFBFA ));
 CL.AddConstantN('JvDefaultAvgLineColor','LongWord').SetUInt( TColor ( $00EEDDDD ));
 //  clLtGray = TColor($C0C0C0);
 CL.AddConstantN('JvDefaultDivisionLineColor','longword').SetUInt(TColor($C0C0C0));
 CL.AddConstantN('JvDefaultShadowColor','longword').SetUint(TColor($C0C0C0));
 CL.AddConstantN('JvDefaultYLegends','LongInt').SetInt( 20);
 CL.AddConstantN('MaxShowXValueInLegends','LongInt').SetInt( 10);
 CL.AddConstantN('jvChartAverageLineColorIndex','LongInt').SetInt( - 6);
 CL.AddConstantN('jvChartDivisionLineColorIndex','LongInt').SetInt( - 5);
 CL.AddConstantN('jvChartShadowColorIndex','LongInt').SetInt( - 4);
 CL.AddConstantN('jvChartAxisColorIndex','LongInt').SetInt( - 3);
 CL.AddConstantN('jvChartHintColorIndex','LongInt').SetInt( - 2);
 CL.AddConstantN('jvChartPaperColorIndex','LongInt').SetInt( - 1);
 CL.AddConstantN('JvChartDefaultMarkerSize','LongInt').SetInt( 3);
  CL.AddTypeS('TJvChartKind', '( ckChartNone, ckChartLine, ckChartBar, ckChartS'
   +'tackedBar, ckChartBarAverage, ckChartStackedBarAverage, ckChartPieChart, c'
   +'kChartMarkers, ckChartDeltaAverage )');
  CL.AddTypeS('TJvChartPenMarkerKind', '( pmkNone, pmkDiamond, pmkCircle, pmkSquare, pmkCross )');
  CL.AddTypeS('TJvChartGradientDirection', '( grNone, grUp, grDown, grLeft, grRight )');
  CL.AddTypeS('TJvChartLegend', '( clChartLegendNone, clChartLegendRight, clChartLegendBelow )');
  CL.AddTypeS('TJvChartDataArray', 'array of array of Double');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvChart');
  CL.AddTypeS('TJvChartCaptionPosition', '( cpMarker, cpXAxisBottom, cpXAxisTop, cpTitleArea )');
  SIRegister_TJvChartFloatingMarker(CL);
  SIRegister_TJvChartGradientBar(CL);
  SIRegister_TJvChartHorizontalBar(CL);
  SIRegister_TJvChartVerticalBar(CL);
  SIRegister_TJvChartData(CL);
  CL.AddTypeS('TJvChartPaintEvent', 'Procedure ( Sender : TJvChart; ACanvas : TCanvas)');
  CL.AddTypeS('TJvChartEvent', 'Procedure ( Sender : TJvChart)');
  CL.AddTypeS('TJvChartFloatingMarkerDragEvent', 'Procedure ( Sender : TJvChart'
   +'; FloatingMarker : TJvChartFloatingMarker)');
  CL.AddTypeS('TJvChartClickEvent', 'Procedure ( Sender : TJvChart; Button : TM'
   +'ouseButton; Shift : TShiftState; X, Y : Integer; ChartValueIndex : Integer'
   +'; ChartPenIndex : Integer; var ShowHint, HintFirstLineBold : Boolean; HintStrs : TStrings)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvChartOptions');
  SIRegister_TJvChartYAxisOptions(CL);
  SIRegister_TJvChartOptions(CL);
  SIRegister_TJvChart(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvChartOnTitleClick_W(Self: TJvChart; const T: TJvChartEvent);
begin Self.OnTitleClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnTitleClick_R(Self: TJvChart; var T: TJvChartEvent);
begin T := Self.OnTitleClick; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnAltYAxisClick_W(Self: TJvChart; const T: TJvChartEvent);
begin Self.OnAltYAxisClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnAltYAxisClick_R(Self: TJvChart; var T: TJvChartEvent);
begin T := Self.OnAltYAxisClick; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnXAxisClick_W(Self: TJvChart; const T: TJvChartEvent);
begin Self.OnXAxisClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnXAxisClick_R(Self: TJvChart; var T: TJvChartEvent);
begin T := Self.OnXAxisClick; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnYAxisClick_W(Self: TJvChart; const T: TJvChartEvent);
begin Self.OnYAxisClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnYAxisClick_R(Self: TJvChart; var T: TJvChartEvent);
begin T := Self.OnYAxisClick; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnEndFloatingMarkerDrag_W(Self: TJvChart; const T: TJvChartFloatingMarkerDragEvent);
begin Self.OnEndFloatingMarkerDrag := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnEndFloatingMarkerDrag_R(Self: TJvChart; var T: TJvChartFloatingMarkerDragEvent);
begin T := Self.OnEndFloatingMarkerDrag; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnBeginFloatingMarkerDrag_W(Self: TJvChart; const T: TJvChartFloatingMarkerDragEvent);
begin Self.OnBeginFloatingMarkerDrag := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnBeginFloatingMarkerDrag_R(Self: TJvChart; var T: TJvChartFloatingMarkerDragEvent);
begin T := Self.OnBeginFloatingMarkerDrag; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnChartPaint_W(Self: TJvChart; const T: TJvChartPaintEvent);
begin Self.OnChartPaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnChartPaint_R(Self: TJvChart; var T: TJvChartPaintEvent);
begin T := Self.OnChartPaint; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnChartClick_W(Self: TJvChart; const T: TJvChartClickEvent);
begin Self.OnChartClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOnChartClick_R(Self: TJvChart; var T: TJvChartClickEvent);
begin T := Self.OnChartClick; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptions_W(Self: TJvChart; const T: TJvChartOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptions_R(Self: TJvChart; var T: TJvChartOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartCursorPosition_W(Self: TJvChart; const T: Integer);
begin Self.CursorPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartCursorPosition_R(Self: TJvChart; var T: Integer);
begin T := Self.CursorPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartPicture_R(Self: TJvChart; var T: TPicture);
begin T := Self.Picture; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartAverageData_R(Self: TJvChart; var T: TJvChartData);
begin T := Self.AverageData; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartData_R(Self: TJvChart; var T: TJvChartData);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartVerticalBar_R(Self: TJvChart; var T: TJvChartVerticalBar; const t1: Integer);
begin T := Self.VerticalBar[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartHorizontalBar_R(Self: TJvChart; var T: TJvChartHorizontalBar; const t1: Integer);
begin T := Self.HorizontalBar[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarker_R(Self: TJvChart; var T: TJvChartFloatingMarker; const t1: Integer);
begin T := Self.FloatingMarker[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsCursorStyle_W(Self: TJvChartOptions; const T: TPenStyle);
begin Self.CursorStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsCursorStyle_R(Self: TJvChartOptions; var T: TPenStyle);
begin T := Self.CursorStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsCursorColor_W(Self: TJvChartOptions; const T: TColor);
begin Self.CursorColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsCursorColor_R(Self: TJvChartOptions; var T: TColor);
begin T := Self.CursorColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAverageLineColor_W(Self: TJvChartOptions; const T: TColor);
begin Self.AverageLineColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAverageLineColor_R(Self: TJvChartOptions; var T: TColor);
begin T := Self.AverageLineColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsHintColor_W(Self: TJvChartOptions; const T: TColor);
begin Self.HintColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsHintColor_R(Self: TJvChartOptions; var T: TColor);
begin T := Self.HintColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAxisLineColor_W(Self: TJvChartOptions; const T: TColor);
begin Self.AxisLineColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAxisLineColor_R(Self: TJvChartOptions; var T: TColor);
begin T := Self.AxisLineColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPaperColor_W(Self: TJvChartOptions; const T: TColor);
begin Self.PaperColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPaperColor_R(Self: TJvChartOptions; var T: TColor);
begin T := Self.PaperColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsShadowColor_W(Self: TJvChartOptions; const T: TColor);
begin Self.ShadowColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsShadowColor_R(Self: TJvChartOptions; var T: TColor);
begin T := Self.ShadowColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsDivisionLineColor_W(Self: TJvChartOptions; const T: TColor);
begin Self.DivisionLineColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsDivisionLineColor_R(Self: TJvChartOptions; var T: TColor);
begin T := Self.DivisionLineColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAxisFont_W(Self: TJvChartOptions; const T: TFont);
begin Self.AxisFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAxisFont_R(Self: TJvChartOptions; var T: TFont);
begin T := Self.AxisFont; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsLegendFont_W(Self: TJvChartOptions; const T: TFont);
begin Self.LegendFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsLegendFont_R(Self: TJvChartOptions; var T: TFont);
begin T := Self.LegendFont; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsHeaderFont_W(Self: TJvChartOptions; const T: TFont);
begin Self.HeaderFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsHeaderFont_R(Self: TJvChartOptions; var T: TFont);
begin T := Self.HeaderFont; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXValueCount_W(Self: TJvChartOptions; const T: Integer);
begin Self.XValueCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXValueCount_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.XValueCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAxisLineWidth_W(Self: TJvChartOptions; const T: Integer);
begin Self.AxisLineWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAxisLineWidth_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.AxisLineWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenLineWidth_W(Self: TJvChartOptions; const T: Integer);
begin Self.PenLineWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenLineWidth_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.PenLineWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsLegendWidth_W(Self: TJvChartOptions; const T: Integer);
begin Self.LegendWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsLegendWidth_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.LegendWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsLegendRowCount_W(Self: TJvChartOptions; const T: Integer);
begin Self.LegendRowCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsLegendRowCount_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.LegendRowCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsLegend_W(Self: TJvChartOptions; const T: TJvChartLegend);
begin Self.Legend := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsLegend_R(Self: TJvChartOptions; var T: TJvChartLegend);
begin T := Self.Legend; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsMouseInfo_W(Self: TJvChartOptions; const T: Boolean);
begin Self.MouseInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsMouseInfo_R(Self: TJvChartOptions; var T: Boolean);
begin T := Self.MouseInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsMouseDragObjects_W(Self: TJvChartOptions; const T: Boolean);
begin Self.MouseDragObjects := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsMouseDragObjects_R(Self: TJvChartOptions; var T: Boolean);
begin T := Self.MouseDragObjects; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsMouseEdit_W(Self: TJvChartOptions; const T: Boolean);
begin Self.MouseEdit := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsMouseEdit_R(Self: TJvChartOptions; var T: Boolean);
begin T := Self.MouseEdit; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAutoUpdateGraph_W(Self: TJvChartOptions; const T: Boolean);
begin Self.AutoUpdateGraph := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAutoUpdateGraph_R(Self: TJvChartOptions; var T: Boolean);
begin T := Self.AutoUpdateGraph; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsSecondaryYAxis_W(Self: TJvChartOptions; const T: TJvChartYAxisOptions);
begin Self.SecondaryYAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsSecondaryYAxis_R(Self: TJvChartOptions; var T: TJvChartYAxisOptions);
begin T := Self.SecondaryYAxis; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPrimaryYAxis_W(Self: TJvChartOptions; const T: TJvChartYAxisOptions);
begin Self.PrimaryYAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPrimaryYAxis_R(Self: TJvChartOptions; var T: TJvChartYAxisOptions);
begin T := Self.PrimaryYAxis; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsMarkerSize_W(Self: TJvChartOptions; const T: Integer);
begin Self.MarkerSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsMarkerSize_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.MarkerSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsYStartOffset_W(Self: TJvChartOptions; const T: Longint);
begin Self.YStartOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsYStartOffset_R(Self: TJvChartOptions; var T: Longint);
begin T := Self.YStartOffset; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXStartOffset_W(Self: TJvChartOptions; const T: Longint);
begin Self.XStartOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXStartOffset_R(Self: TJvChartOptions; var T: Longint);
begin T := Self.XStartOffset; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsYOrigin_W(Self: TJvChartOptions; const T: Integer);
begin Self.YOrigin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsYOrigin_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.YOrigin; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXOrigin_W(Self: TJvChartOptions; const T: Integer);
begin Self.XOrigin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXOrigin_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.XOrigin; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXGap_W(Self: TJvChartOptions; const T: Double);
begin Self.XGap := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXGap_R(Self: TJvChartOptions; var T: Double);
begin T := Self.XGap; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenCount_W(Self: TJvChartOptions; const T: Integer);
begin Self.PenCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenCount_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.PenCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsDateTimeFormat_W(Self: TJvChartOptions; const T: string);
begin Self.DateTimeFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsDateTimeFormat_R(Self: TJvChartOptions; var T: string);
begin T := Self.DateTimeFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisLegendSkipBy_W(Self: TJvChartOptions; const T: Integer);
begin Self.XAxisLegendSkipBy := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisLegendSkipBy_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.XAxisLegendSkipBy; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisHeader_W(Self: TJvChartOptions; const T: string);
begin Self.XAxisHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisHeader_R(Self: TJvChartOptions; var T: string);
begin T := Self.XAxisHeader; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisDateTimeFormat_W(Self: TJvChartOptions; const T: string);
begin Self.XAxisDateTimeFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisDateTimeFormat_R(Self: TJvChartOptions; var T: string);
begin T := Self.XAxisDateTimeFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisDateTimeDivision_W(Self: TJvChartOptions; const T: Double);
begin Self.XAxisDateTimeDivision := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisDateTimeDivision_R(Self: TJvChartOptions; var T: Double);
begin T := Self.XAxisDateTimeDivision; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisDateTimeMode_W(Self: TJvChartOptions; const T: Boolean);
begin Self.XAxisDateTimeMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisDateTimeMode_R(Self: TJvChartOptions; var T: Boolean);
begin T := Self.XAxisDateTimeMode; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisLabelAlignment_W(Self: TJvChartOptions; const T: TAlignment);
begin Self.XAxisLabelAlignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisLabelAlignment_R(Self: TJvChartOptions; var T: TAlignment);
begin T := Self.XAxisLabelAlignment; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisValuesPerDivision_W(Self: TJvChartOptions; const T: Integer);
begin Self.XAxisValuesPerDivision := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisValuesPerDivision_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.XAxisValuesPerDivision; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisDivisionMarkers_W(Self: TJvChartOptions; const T: Boolean);
begin Self.XAxisDivisionMarkers := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXAxisDivisionMarkers_R(Self: TJvChartOptions; var T: Boolean);
begin T := Self.XAxisDivisionMarkers; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsYAxisDivisionMarkers_W(Self: TJvChartOptions; const T: Boolean);
begin Self.YAxisDivisionMarkers := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsYAxisDivisionMarkers_R(Self: TJvChartOptions; var T: Boolean);
begin T := Self.YAxisDivisionMarkers; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsYAxisHeader_W(Self: TJvChartOptions; const T: string);
begin Self.YAxisHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsYAxisHeader_R(Self: TJvChartOptions; var T: string);
begin T := Self.YAxisHeader; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsNoDataMessage_W(Self: TJvChartOptions; const T: string);
begin Self.NoDataMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsNoDataMessage_R(Self: TJvChartOptions; var T: string);
begin T := Self.NoDataMessage; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsTitle_W(Self: TJvChartOptions; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsTitle_R(Self: TJvChartOptions; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsChartKind_W(Self: TJvChartOptions; const T: TJvChartKind);
begin Self.ChartKind := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsChartKind_R(Self: TJvChartOptions; var T: TJvChartKind);
begin T := Self.ChartKind; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenUnit_W(Self: TJvChartOptions; const T: TStrings);
begin Self.PenUnit := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenUnit_R(Self: TJvChartOptions; var T: TStrings);
begin T := Self.PenUnit; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenLegends_W(Self: TJvChartOptions; const T: TStrings);
begin Self.PenLegends := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenLegends_R(Self: TJvChartOptions; var T: TStrings);
begin T := Self.PenLegends; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenValueLabels_W(Self: TJvChartOptions; const T: Boolean; const t1: Integer);
begin Self.PenValueLabels[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenValueLabels_R(Self: TJvChartOptions; var T: Boolean; const t1: Integer);
begin T := Self.PenValueLabels[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenSecondaryAxisFlag_W(Self: TJvChartOptions; const T: Boolean; const t1: Integer);
begin Self.PenSecondaryAxisFlag[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenSecondaryAxisFlag_R(Self: TJvChartOptions; var T: Boolean; const t1: Integer);
begin T := Self.PenSecondaryAxisFlag[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenMarkerKind_W(Self: TJvChartOptions; const T: TJvChartPenMarkerKind; const t1: Integer);
begin Self.PenMarkerKind[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenMarkerKind_R(Self: TJvChartOptions; var T: TJvChartPenMarkerKind; const t1: Integer);
begin T := Self.PenMarkerKind[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenStyle_W(Self: TJvChartOptions; const T: TPenStyle; const t1: Integer);
begin Self.PenStyle[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenStyle_R(Self: TJvChartOptions; var T: TPenStyle; const t1: Integer);
begin T := Self.PenStyle[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenColor_W(Self: TJvChartOptions; const T: TColor; const t1: Integer);
begin Self.PenColor[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenColor_R(Self: TJvChartOptions; var T: TColor; const t1: Integer);
begin T := Self.PenColor[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXLegendMaxTextWidth_W(Self: TJvChartOptions; const T: Integer);
begin Self.XLegendMaxTextWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXLegendMaxTextWidth_R(Self: TJvChartOptions; var T: Integer);
begin T := Self.XLegendMaxTextWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXPixelGap_W(Self: TJvChartOptions; const T: Double);
begin Self.XPixelGap := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXPixelGap_R(Self: TJvChartOptions; var T: Double);
begin T := Self.XPixelGap; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsGradientDirection_W(Self: TJvChartOptions; const T: TJvChartGradientDirection);
begin Self.GradientDirection := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsGradientDirection_R(Self: TJvChartOptions; var T: TJvChartGradientDirection);
begin T := Self.GradientDirection; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsGradientColor_W(Self: TJvChartOptions; const T: TColor);
begin Self.GradientColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsGradientColor_R(Self: TJvChartOptions; var T: TColor);
begin T := Self.GradientColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsYEnd_W(Self: TJvChartOptions; const T: Longint);
begin Self.YEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsYEnd_R(Self: TJvChartOptions; var T: Longint);
begin T := Self.YEnd; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXEnd_W(Self: TJvChartOptions; const T: Longint);
begin Self.XEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXEnd_R(Self: TJvChartOptions; var T: Longint);
begin T := Self.XEnd; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXLegends_W(Self: TJvChartOptions; const T: TStrings);
begin Self.XLegends := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsXLegends_R(Self: TJvChartOptions; var T: TStrings);
begin T := Self.XLegends; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsPenAxis_R(Self: TJvChartOptions; var T: TJvChartYAxisOptions; const t1: Integer);
begin T := Self.PenAxis[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAverageValue_W(Self: TJvChartOptions; const T: Double; const t1: Integer);
begin Self.AverageValue[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartOptionsAverageValue_R(Self: TJvChartOptions; var T: Double; const t1: Integer);
begin T := Self.AverageValue[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsDefaultYLegends_W(Self: TJvChartYAxisOptions; const T: Integer);
begin Self.DefaultYLegends := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsDefaultYLegends_R(Self: TJvChartYAxisOptions; var T: Integer);
begin T := Self.DefaultYLegends; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYLegendDecimalPlaces_W(Self: TJvChartYAxisOptions; const T: Integer);
begin Self.YLegendDecimalPlaces := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYLegendDecimalPlaces_R(Self: TJvChartYAxisOptions; var T: Integer);
begin T := Self.YLegendDecimalPlaces; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsMarkerValueDecimals_W(Self: TJvChartYAxisOptions; const T: Integer);
begin Self.MarkerValueDecimals := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsMarkerValueDecimals_R(Self: TJvChartYAxisOptions; var T: Integer);
begin T := Self.MarkerValueDecimals; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsMinYDivisions_W(Self: TJvChartYAxisOptions; const T: Integer);
begin Self.MinYDivisions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsMinYDivisions_R(Self: TJvChartYAxisOptions; var T: Integer);
begin T := Self.MinYDivisions; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsMaxYDivisions_W(Self: TJvChartYAxisOptions; const T: Integer);
begin Self.MaxYDivisions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsMaxYDivisions_R(Self: TJvChartYAxisOptions; var T: Integer);
begin T := Self.MaxYDivisions; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYDivisions_W(Self: TJvChartYAxisOptions; const T: Integer);
begin Self.YDivisions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYDivisions_R(Self: TJvChartYAxisOptions; var T: Integer);
begin T := Self.YDivisions; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYMin_W(Self: TJvChartYAxisOptions; const T: Double);
begin Self.YMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYMin_R(Self: TJvChartYAxisOptions; var T: Double);
begin T := Self.YMin; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYMax_W(Self: TJvChartYAxisOptions; const T: Double);
begin Self.YMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYMax_R(Self: TJvChartYAxisOptions; var T: Double);
begin T := Self.YMax; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYLegends_W(Self: TJvChartYAxisOptions; const T: TStrings);
begin Self.YLegends := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYLegends_R(Self: TJvChartYAxisOptions; var T: TStrings);
begin T := Self.YLegends; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYGap1_R(Self: TJvChartYAxisOptions; var T: Double);
begin T := Self.YGap1; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYGap_R(Self: TJvChartYAxisOptions; var T: Double);
begin T := Self.YGap; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsActive_R(Self: TJvChartYAxisOptions; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYPixelGap_W(Self: TJvChartYAxisOptions; const T: Double);
begin Self.YPixelGap := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartYAxisOptionsYPixelGap_R(Self: TJvChartYAxisOptions; var T: Double);
begin T := Self.YPixelGap; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataEndDateTime_W(Self: TJvChartData; const T: TDateTime);
begin Self.EndDateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataEndDateTime_R(Self: TJvChartData; var T: TDateTime);
begin T := Self.EndDateTime; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataStartDateTime_W(Self: TJvChartData; const T: TDateTime);
begin Self.StartDateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataStartDateTime_R(Self: TJvChartData; var T: TDateTime);
begin T := Self.StartDateTime; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataClearToValue_W(Self: TJvChartData; const T: Double);
begin Self.ClearToValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataClearToValue_R(Self: TJvChartData; var T: Double);
begin T := Self.ClearToValue; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataValueCount_W(Self: TJvChartData; const T: Integer);
begin Self.ValueCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataValueCount_R(Self: TJvChartData; var T: Integer);
begin T := Self.ValueCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataTimestamp_W(Self: TJvChartData; const T: TDateTime; const t1: Integer);
begin Self.Timestamp[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataTimestamp_R(Self: TJvChartData; var T: TDateTime; const t1: Integer);
begin T := Self.Timestamp[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataValue_W(Self: TJvChartData; const T: Double; const t1: Integer; const t2: Integer);
begin Self.Value[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartDataValue_R(Self: TJvChartData; var T: Double; const t1: Integer; const t2: Integer);
begin T := Self.Value[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartVerticalBarXRight_W(Self: TJvChartVerticalBar; const T: Integer);
begin Self.XRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartVerticalBarXRight_R(Self: TJvChartVerticalBar; var T: Integer);
begin T := Self.XRight; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartVerticalBarXLeft_W(Self: TJvChartVerticalBar; const T: Integer);
begin Self.XLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartVerticalBarXLeft_R(Self: TJvChartVerticalBar; var T: Integer);
begin T := Self.XLeft; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartHorizontalBarYBottom_W(Self: TJvChartHorizontalBar; const T: Double);
begin Self.YBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartHorizontalBarYBottom_R(Self: TJvChartHorizontalBar; var T: Double);
begin T := Self.YBottom; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartHorizontalBarYTop_W(Self: TJvChartHorizontalBar; const T: Double);
begin Self.YTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartHorizontalBarYTop_R(Self: TJvChartHorizontalBar; var T: Double);
begin T := Self.YTop; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarPenColor_W(Self: TJvChartGradientBar; const T: TColor);
begin Self.PenColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarPenColor_R(Self: TJvChartGradientBar; var T: TColor);
begin T := Self.PenColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarPenStyle_W(Self: TJvChartGradientBar; const T: TPenStyle);
begin Self.PenStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarPenStyle_R(Self: TJvChartGradientBar; var T: TPenStyle);
begin T := Self.PenStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarGradColor_W(Self: TJvChartGradientBar; const T: TColor);
begin Self.GradColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarGradColor_R(Self: TJvChartGradientBar; var T: TColor);
begin T := Self.GradColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarGradDirection_W(Self: TJvChartGradientBar; const T: TJvChartGradientDirection);
begin Self.GradDirection := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarGradDirection_R(Self: TJvChartGradientBar; var T: TJvChartGradientDirection);
begin T := Self.GradDirection; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarColor_W(Self: TJvChartGradientBar; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarColor_R(Self: TJvChartGradientBar; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarYBottom_W(Self: TJvChartGradientBar; const T: Double);
begin Self.YBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarYBottom_R(Self: TJvChartGradientBar; var T: Double);
begin T := Self.YBottom; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarYTop_W(Self: TJvChartGradientBar; const T: Double);
begin Self.YTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarYTop_R(Self: TJvChartGradientBar; var T: Double);
begin T := Self.YTop; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarVisible_W(Self: TJvChartGradientBar; const T: boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartGradientBarVisible_R(Self: TJvChartGradientBar; var T: boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerTag_W(Self: TJvChartFloatingMarker; const T: Integer);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerTag_R(Self: TJvChartFloatingMarker; var T: Integer);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerCaptionBoxed_W(Self: TJvChartFloatingMarker; const T: Boolean);
begin Self.CaptionBoxed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerCaptionBoxed_R(Self: TJvChartFloatingMarker; var T: Boolean);
begin T := Self.CaptionBoxed; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerCaptionPosition_W(Self: TJvChartFloatingMarker; const T: TJvChartCaptionPosition);
begin Self.CaptionPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerCaptionPosition_R(Self: TJvChartFloatingMarker; var T: TJvChartCaptionPosition);
begin T := Self.CaptionPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerCaptionColor_W(Self: TJvChartFloatingMarker; const T: TColor);
begin Self.CaptionColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerCaptionColor_R(Self: TJvChartFloatingMarker; var T: TColor);
begin T := Self.CaptionColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerCaption_W(Self: TJvChartFloatingMarker; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerCaption_R(Self: TJvChartFloatingMarker; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerLineWidth_W(Self: TJvChartFloatingMarker; const T: Integer);
begin Self.LineWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerLineWidth_R(Self: TJvChartFloatingMarker; var T: Integer);
begin T := Self.LineWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerLineColor_W(Self: TJvChartFloatingMarker; const T: TColor);
begin Self.LineColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerLineColor_R(Self: TJvChartFloatingMarker; var T: TColor);
begin T := Self.LineColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerLineStyle_W(Self: TJvChartFloatingMarker; const T: TPenStyle);
begin Self.LineStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerLineStyle_R(Self: TJvChartFloatingMarker; var T: TPenStyle);
begin T := Self.LineStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerLineVertical_W(Self: TJvChartFloatingMarker; const T: Boolean);
begin Self.LineVertical := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerLineVertical_R(Self: TJvChartFloatingMarker; var T: Boolean);
begin T := Self.LineVertical; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerLineToMarker_W(Self: TJvChartFloatingMarker; const T: Integer);
begin Self.LineToMarker := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerLineToMarker_R(Self: TJvChartFloatingMarker; var T: Integer);
begin T := Self.LineToMarker; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerYDraggable_W(Self: TJvChartFloatingMarker; const T: Boolean);
begin Self.YDraggable := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerYDraggable_R(Self: TJvChartFloatingMarker; var T: Boolean);
begin T := Self.YDraggable; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerXDragMax_W(Self: TJvChartFloatingMarker; const T: Integer);
begin Self.XDragMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerXDragMax_R(Self: TJvChartFloatingMarker; var T: Integer);
begin T := Self.XDragMax; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerXDragMin_W(Self: TJvChartFloatingMarker; const T: Integer);
begin Self.XDragMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerXDragMin_R(Self: TJvChartFloatingMarker; var T: Integer);
begin T := Self.XDragMin; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerXDraggable_W(Self: TJvChartFloatingMarker; const T: Boolean);
begin Self.XDraggable := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerXDraggable_R(Self: TJvChartFloatingMarker; var T: Boolean);
begin T := Self.XDraggable; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerYPosition_W(Self: TJvChartFloatingMarker; const T: Double);
begin Self.YPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerYPosition_R(Self: TJvChartFloatingMarker; var T: Double);
begin T := Self.YPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerXPosition_W(Self: TJvChartFloatingMarker; const T: Integer);
begin Self.XPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerXPosition_R(Self: TJvChartFloatingMarker; var T: Integer);
begin T := Self.XPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerVisible_W(Self: TJvChartFloatingMarker; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerVisible_R(Self: TJvChartFloatingMarker; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerMarkerColor_W(Self: TJvChartFloatingMarker; const T: TColor);
begin Self.MarkerColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerMarkerColor_R(Self: TJvChartFloatingMarker; var T: TColor);
begin T := Self.MarkerColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerMarker_W(Self: TJvChartFloatingMarker; const T: TJvChartPenMarkerKind);
begin Self.Marker := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerMarker_R(Self: TJvChartFloatingMarker; var T: TJvChartPenMarkerKind);
begin T := Self.Marker; end;

(*----------------------------------------------------------------------------*)
procedure TJvChartFloatingMarkerIndex_R(Self: TJvChartFloatingMarker; var T: Integer);
begin T := Self.Index; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvChart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvChart) do begin
    RegisterConstructor(@TJvChart.Create, 'Create');
    RegisterMethod(@TJvChart.Destroy, 'Free');
    RegisterMethod(@TJvChart.MouseToXValue, 'MouseToXValue');
    RegisterMethod(@TJvChart.MouseToYValue, 'MouseToYValue');
    RegisterMethod(@TJvChart.ResetGraphModule, 'ResetGraphModule');
    RegisterMethod(@TJvChart.PlotGraph, 'PlotGraph');
    RegisterMethod(@TJvChart.PlotPicture, 'PlotPicture');
    RegisterMethod(@TJvChart.PrintGraph, 'PrintGraph');
    RegisterMethod(@TJvChart.AddGraphToOpenPrintCanvas, 'AddGraphToOpenPrintCanvas');
    RegisterMethod(@TJvChart.GraphToClipboard, 'GraphToClipboard');
    RegisterMethod(@TJvChart.ResizeChartCanvas, 'ResizeChartCanvas');
    RegisterMethod(@TJvChart.PivotData, 'PivotData');
    RegisterMethod(@TJvChart.AutoHint, 'AutoHint');
    RegisterMethod(@TJvChart.SetCursorPosition, 'SetCursorPosition');
    RegisterMethod(@TJvChart.DisplayBars, 'DisplayBars');
    RegisterMethod(@TJvChart.AddFloatingMarker, 'AddFloatingMarker');
    RegisterPropertyHelper(@TJvChartFloatingMarker_R,nil,'FloatingMarker');
    RegisterPropertyHelper(@TJvChartHorizontalBar_R,nil,'HorizontalBar');
    RegisterPropertyHelper(@TJvChartVerticalBar_R,nil,'VerticalBar');
    RegisterMethod(@TJvChart.DeleteFloatingMarker, 'DeleteFloatingMarker');
    RegisterMethod(@TJvChart.DeleteFloatingMarkerObj, 'DeleteFloatingMarkerObj');
    RegisterMethod(@TJvChart.CopyFloatingMarkers, 'CopyFloatingMarkers');
    RegisterMethod(@TJvChart.ClearFloatingMarkers, 'ClearFloatingMarkers');
    RegisterMethod(@TJvChart.FloatingMarkerCount, 'FloatingMarkerCount');
    RegisterMethod(@TJvChart.AddHorizontalBar, 'AddHorizontalBar');
    RegisterMethod(@TJvChart.ClearHorizontalBars, 'ClearHorizontalBars');
    RegisterMethod(@TJvChart.HorizontalBarsCount, 'HorizontalBarsCount');
    RegisterMethod(@TJvChart.AddVerticalBar, 'AddVerticalBar');
    RegisterMethod(@TJvChart.ClearVerticalBars, 'ClearVerticalBars');
    RegisterMethod(@TJvChart.VerticalBarsCount, 'VerticalBarsCount');
    RegisterPropertyHelper(@TJvChartData_R,nil,'Data');
    RegisterPropertyHelper(@TJvChartAverageData_R,nil,'AverageData');
    RegisterPropertyHelper(@TJvChartPicture_R,nil,'Picture');
    RegisterPropertyHelper(@TJvChartCursorPosition_R,@TJvChartCursorPosition_W,'CursorPosition');
    RegisterPropertyHelper(@TJvChartOptions_R,@TJvChartOptions_W,'Options');
    RegisterPropertyHelper(@TJvChartOnChartClick_R,@TJvChartOnChartClick_W,'OnChartClick');
    RegisterPropertyHelper(@TJvChartOnChartPaint_R,@TJvChartOnChartPaint_W,'OnChartPaint');
    RegisterPropertyHelper(@TJvChartOnBeginFloatingMarkerDrag_R,@TJvChartOnBeginFloatingMarkerDrag_W,'OnBeginFloatingMarkerDrag');
    RegisterPropertyHelper(@TJvChartOnEndFloatingMarkerDrag_R,@TJvChartOnEndFloatingMarkerDrag_W,'OnEndFloatingMarkerDrag');
    RegisterPropertyHelper(@TJvChartOnYAxisClick_R,@TJvChartOnYAxisClick_W,'OnYAxisClick');
    RegisterPropertyHelper(@TJvChartOnXAxisClick_R,@TJvChartOnXAxisClick_W,'OnXAxisClick');
    RegisterPropertyHelper(@TJvChartOnAltYAxisClick_R,@TJvChartOnAltYAxisClick_W,'OnAltYAxisClick');
    RegisterPropertyHelper(@TJvChartOnTitleClick_R,@TJvChartOnTitleClick_W,'OnTitleClick');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvChartOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvChartOptions) do begin
    RegisterConstructor(@TJvChartOptions.Create, 'Create');
   RegisterMethod(@TJvChartOptions.Destroy, 'Free');
    RegisterMethod(@TJvChartOptions.Assign, 'Assign');
    RegisterPropertyHelper(@TJvChartOptionsAverageValue_R,@TJvChartOptionsAverageValue_W,'AverageValue');
    RegisterPropertyHelper(@TJvChartOptionsPenAxis_R,nil,'PenAxis');
    RegisterPropertyHelper(@TJvChartOptionsXLegends_R,@TJvChartOptionsXLegends_W,'XLegends');
    RegisterPropertyHelper(@TJvChartOptionsXEnd_R,@TJvChartOptionsXEnd_W,'XEnd');
    RegisterPropertyHelper(@TJvChartOptionsYEnd_R,@TJvChartOptionsYEnd_W,'YEnd');
    RegisterPropertyHelper(@TJvChartOptionsGradientColor_R,@TJvChartOptionsGradientColor_W,'GradientColor');
    RegisterPropertyHelper(@TJvChartOptionsGradientDirection_R,@TJvChartOptionsGradientDirection_W,'GradientDirection');
    RegisterPropertyHelper(@TJvChartOptionsXPixelGap_R,@TJvChartOptionsXPixelGap_W,'XPixelGap');
    RegisterPropertyHelper(@TJvChartOptionsXLegendMaxTextWidth_R,@TJvChartOptionsXLegendMaxTextWidth_W,'XLegendMaxTextWidth');
    RegisterPropertyHelper(@TJvChartOptionsPenColor_R,@TJvChartOptionsPenColor_W,'PenColor');
    RegisterPropertyHelper(@TJvChartOptionsPenStyle_R,@TJvChartOptionsPenStyle_W,'PenStyle');
    RegisterPropertyHelper(@TJvChartOptionsPenMarkerKind_R,@TJvChartOptionsPenMarkerKind_W,'PenMarkerKind');
    RegisterPropertyHelper(@TJvChartOptionsPenSecondaryAxisFlag_R,@TJvChartOptionsPenSecondaryAxisFlag_W,'PenSecondaryAxisFlag');
    RegisterPropertyHelper(@TJvChartOptionsPenValueLabels_R,@TJvChartOptionsPenValueLabels_W,'PenValueLabels');
    RegisterPropertyHelper(@TJvChartOptionsPenLegends_R,@TJvChartOptionsPenLegends_W,'PenLegends');
    RegisterPropertyHelper(@TJvChartOptionsPenUnit_R,@TJvChartOptionsPenUnit_W,'PenUnit');
    RegisterPropertyHelper(@TJvChartOptionsChartKind_R,@TJvChartOptionsChartKind_W,'ChartKind');
    RegisterPropertyHelper(@TJvChartOptionsTitle_R,@TJvChartOptionsTitle_W,'Title');
    RegisterPropertyHelper(@TJvChartOptionsNoDataMessage_R,@TJvChartOptionsNoDataMessage_W,'NoDataMessage');
    RegisterPropertyHelper(@TJvChartOptionsYAxisHeader_R,@TJvChartOptionsYAxisHeader_W,'YAxisHeader');
    RegisterPropertyHelper(@TJvChartOptionsYAxisDivisionMarkers_R,@TJvChartOptionsYAxisDivisionMarkers_W,'YAxisDivisionMarkers');
    RegisterPropertyHelper(@TJvChartOptionsXAxisDivisionMarkers_R,@TJvChartOptionsXAxisDivisionMarkers_W,'XAxisDivisionMarkers');
    RegisterPropertyHelper(@TJvChartOptionsXAxisValuesPerDivision_R,@TJvChartOptionsXAxisValuesPerDivision_W,'XAxisValuesPerDivision');
    RegisterPropertyHelper(@TJvChartOptionsXAxisLabelAlignment_R,@TJvChartOptionsXAxisLabelAlignment_W,'XAxisLabelAlignment');
    RegisterPropertyHelper(@TJvChartOptionsXAxisDateTimeMode_R,@TJvChartOptionsXAxisDateTimeMode_W,'XAxisDateTimeMode');
    RegisterPropertyHelper(@TJvChartOptionsXAxisDateTimeDivision_R,@TJvChartOptionsXAxisDateTimeDivision_W,'XAxisDateTimeDivision');
    RegisterPropertyHelper(@TJvChartOptionsXAxisDateTimeFormat_R,@TJvChartOptionsXAxisDateTimeFormat_W,'XAxisDateTimeFormat');
    RegisterPropertyHelper(@TJvChartOptionsXAxisHeader_R,@TJvChartOptionsXAxisHeader_W,'XAxisHeader');
    RegisterPropertyHelper(@TJvChartOptionsXAxisLegendSkipBy_R,@TJvChartOptionsXAxisLegendSkipBy_W,'XAxisLegendSkipBy');
    RegisterPropertyHelper(@TJvChartOptionsDateTimeFormat_R,@TJvChartOptionsDateTimeFormat_W,'DateTimeFormat');
    RegisterPropertyHelper(@TJvChartOptionsPenCount_R,@TJvChartOptionsPenCount_W,'PenCount');
    RegisterPropertyHelper(@TJvChartOptionsXGap_R,@TJvChartOptionsXGap_W,'XGap');
    RegisterPropertyHelper(@TJvChartOptionsXOrigin_R,@TJvChartOptionsXOrigin_W,'XOrigin');
    RegisterPropertyHelper(@TJvChartOptionsYOrigin_R,@TJvChartOptionsYOrigin_W,'YOrigin');
    RegisterPropertyHelper(@TJvChartOptionsXStartOffset_R,@TJvChartOptionsXStartOffset_W,'XStartOffset');
    RegisterPropertyHelper(@TJvChartOptionsYStartOffset_R,@TJvChartOptionsYStartOffset_W,'YStartOffset');
    RegisterPropertyHelper(@TJvChartOptionsMarkerSize_R,@TJvChartOptionsMarkerSize_W,'MarkerSize');
    RegisterPropertyHelper(@TJvChartOptionsPrimaryYAxis_R,@TJvChartOptionsPrimaryYAxis_W,'PrimaryYAxis');
    RegisterPropertyHelper(@TJvChartOptionsSecondaryYAxis_R,@TJvChartOptionsSecondaryYAxis_W,'SecondaryYAxis');
    RegisterPropertyHelper(@TJvChartOptionsAutoUpdateGraph_R,@TJvChartOptionsAutoUpdateGraph_W,'AutoUpdateGraph');
    RegisterPropertyHelper(@TJvChartOptionsMouseEdit_R,@TJvChartOptionsMouseEdit_W,'MouseEdit');
    RegisterPropertyHelper(@TJvChartOptionsMouseDragObjects_R,@TJvChartOptionsMouseDragObjects_W,'MouseDragObjects');
    RegisterPropertyHelper(@TJvChartOptionsMouseInfo_R,@TJvChartOptionsMouseInfo_W,'MouseInfo');
    RegisterPropertyHelper(@TJvChartOptionsLegend_R,@TJvChartOptionsLegend_W,'Legend');
    RegisterPropertyHelper(@TJvChartOptionsLegendRowCount_R,@TJvChartOptionsLegendRowCount_W,'LegendRowCount');
    RegisterPropertyHelper(@TJvChartOptionsLegendWidth_R,@TJvChartOptionsLegendWidth_W,'LegendWidth');
    RegisterPropertyHelper(@TJvChartOptionsPenLineWidth_R,@TJvChartOptionsPenLineWidth_W,'PenLineWidth');
    RegisterPropertyHelper(@TJvChartOptionsAxisLineWidth_R,@TJvChartOptionsAxisLineWidth_W,'AxisLineWidth');
    RegisterPropertyHelper(@TJvChartOptionsXValueCount_R,@TJvChartOptionsXValueCount_W,'XValueCount');
    RegisterPropertyHelper(@TJvChartOptionsHeaderFont_R,@TJvChartOptionsHeaderFont_W,'HeaderFont');
    RegisterPropertyHelper(@TJvChartOptionsLegendFont_R,@TJvChartOptionsLegendFont_W,'LegendFont');
    RegisterPropertyHelper(@TJvChartOptionsAxisFont_R,@TJvChartOptionsAxisFont_W,'AxisFont');
    RegisterPropertyHelper(@TJvChartOptionsDivisionLineColor_R,@TJvChartOptionsDivisionLineColor_W,'DivisionLineColor');
    RegisterPropertyHelper(@TJvChartOptionsShadowColor_R,@TJvChartOptionsShadowColor_W,'ShadowColor');
    RegisterPropertyHelper(@TJvChartOptionsPaperColor_R,@TJvChartOptionsPaperColor_W,'PaperColor');
    RegisterPropertyHelper(@TJvChartOptionsAxisLineColor_R,@TJvChartOptionsAxisLineColor_W,'AxisLineColor');
    RegisterPropertyHelper(@TJvChartOptionsHintColor_R,@TJvChartOptionsHintColor_W,'HintColor');
    RegisterPropertyHelper(@TJvChartOptionsAverageLineColor_R,@TJvChartOptionsAverageLineColor_W,'AverageLineColor');
    RegisterPropertyHelper(@TJvChartOptionsCursorColor_R,@TJvChartOptionsCursorColor_W,'CursorColor');
    RegisterPropertyHelper(@TJvChartOptionsCursorStyle_R,@TJvChartOptionsCursorStyle_W,'CursorStyle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvChartYAxisOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvChartYAxisOptions) do begin
    RegisterConstructor(@TJvChartYAxisOptions.Create, 'Create');
    RegisterMethod(@TJvChartYAxisOptions.Assign, 'Assign');
    RegisterMethod(@TJvChartYAxisOptions.Normalize, 'Normalize');
    RegisterMethod(@TJvChartYAxisOptions.Clear, 'Clear');
    RegisterPropertyHelper(@TJvChartYAxisOptionsYPixelGap_R,@TJvChartYAxisOptionsYPixelGap_W,'YPixelGap');
    RegisterPropertyHelper(@TJvChartYAxisOptionsActive_R,nil,'Active');
    RegisterPropertyHelper(@TJvChartYAxisOptionsYGap_R,nil,'YGap');
    RegisterPropertyHelper(@TJvChartYAxisOptionsYGap1_R,nil,'YGap1');
    RegisterPropertyHelper(@TJvChartYAxisOptionsYLegends_R,@TJvChartYAxisOptionsYLegends_W,'YLegends');
    RegisterPropertyHelper(@TJvChartYAxisOptionsYMax_R,@TJvChartYAxisOptionsYMax_W,'YMax');
    RegisterPropertyHelper(@TJvChartYAxisOptionsYMin_R,@TJvChartYAxisOptionsYMin_W,'YMin');
    RegisterPropertyHelper(@TJvChartYAxisOptionsYDivisions_R,@TJvChartYAxisOptionsYDivisions_W,'YDivisions');
    RegisterPropertyHelper(@TJvChartYAxisOptionsMaxYDivisions_R,@TJvChartYAxisOptionsMaxYDivisions_W,'MaxYDivisions');
    RegisterPropertyHelper(@TJvChartYAxisOptionsMinYDivisions_R,@TJvChartYAxisOptionsMinYDivisions_W,'MinYDivisions');
    RegisterPropertyHelper(@TJvChartYAxisOptionsMarkerValueDecimals_R,@TJvChartYAxisOptionsMarkerValueDecimals_W,'MarkerValueDecimals');
    RegisterPropertyHelper(@TJvChartYAxisOptionsYLegendDecimalPlaces_R,@TJvChartYAxisOptionsYLegendDecimalPlaces_W,'YLegendDecimalPlaces');
    RegisterPropertyHelper(@TJvChartYAxisOptionsDefaultYLegends_R,@TJvChartYAxisOptionsDefaultYLegends_W,'DefaultYLegends');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvChartData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvChartData) do begin
    RegisterConstructor(@TJvChartData.Create, 'Create');
    RegisterMethod(@TJvChartData.Destroy, 'Free');
    RegisterMethod(@TJvChartData.PreGrow, 'PreGrow');
    RegisterMethod(@TJvChartData.DebugStr, 'DebugStr');
    RegisterMethod(@TJvChartData.Clear, 'Clear');
    RegisterMethod(@TJvChartData.ClearPenValues, 'ClearPenValues');
    RegisterMethod(@TJvChartData.Scroll, 'Scroll');
    RegisterPropertyHelper(@TJvChartDataValue_R,@TJvChartDataValue_W,'Value');
    RegisterPropertyHelper(@TJvChartDataTimestamp_R,@TJvChartDataTimestamp_W,'Timestamp');
    RegisterPropertyHelper(@TJvChartDataValueCount_R,@TJvChartDataValueCount_W,'ValueCount');
    RegisterPropertyHelper(@TJvChartDataClearToValue_R,@TJvChartDataClearToValue_W,'ClearToValue');
    RegisterPropertyHelper(@TJvChartDataStartDateTime_R,@TJvChartDataStartDateTime_W,'StartDateTime');
    RegisterPropertyHelper(@TJvChartDataEndDateTime_R,@TJvChartDataEndDateTime_W,'EndDateTime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvChartVerticalBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvChartVerticalBar) do begin
    RegisterPropertyHelper(@TJvChartVerticalBarXLeft_R,@TJvChartVerticalBarXLeft_W,'XLeft');
    RegisterPropertyHelper(@TJvChartVerticalBarXRight_R,@TJvChartVerticalBarXRight_W,'XRight');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvChartHorizontalBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvChartHorizontalBar) do begin
    RegisterPropertyHelper(@TJvChartHorizontalBarYTop_R,@TJvChartHorizontalBarYTop_W,'YTop');
    RegisterPropertyHelper(@TJvChartHorizontalBarYBottom_R,@TJvChartHorizontalBarYBottom_W,'YBottom');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvChartGradientBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvChartGradientBar) do begin
    RegisterPropertyHelper(@TJvChartGradientBarVisible_R,@TJvChartGradientBarVisible_W,'Visible');
    RegisterPropertyHelper(@TJvChartGradientBarYTop_R,@TJvChartGradientBarYTop_W,'YTop');
    RegisterPropertyHelper(@TJvChartGradientBarYBottom_R,@TJvChartGradientBarYBottom_W,'YBottom');
    RegisterPropertyHelper(@TJvChartGradientBarColor_R,@TJvChartGradientBarColor_W,'Color');
    RegisterPropertyHelper(@TJvChartGradientBarGradDirection_R,@TJvChartGradientBarGradDirection_W,'GradDirection');
    RegisterPropertyHelper(@TJvChartGradientBarGradColor_R,@TJvChartGradientBarGradColor_W,'GradColor');
    RegisterPropertyHelper(@TJvChartGradientBarPenStyle_R,@TJvChartGradientBarPenStyle_W,'PenStyle');
    RegisterPropertyHelper(@TJvChartGradientBarPenColor_R,@TJvChartGradientBarPenColor_W,'PenColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvChartFloatingMarker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvChartFloatingMarker) do begin
    RegisterPropertyHelper(@TJvChartFloatingMarkerIndex_R,nil,'Index');
    RegisterMethod(@TJvChartFloatingMarker.Assign, 'Assign');
    RegisterPropertyHelper(@TJvChartFloatingMarkerMarker_R,@TJvChartFloatingMarkerMarker_W,'Marker');
    RegisterPropertyHelper(@TJvChartFloatingMarkerMarkerColor_R,@TJvChartFloatingMarkerMarkerColor_W,'MarkerColor');
    RegisterPropertyHelper(@TJvChartFloatingMarkerVisible_R,@TJvChartFloatingMarkerVisible_W,'Visible');
    RegisterPropertyHelper(@TJvChartFloatingMarkerXPosition_R,@TJvChartFloatingMarkerXPosition_W,'XPosition');
    RegisterPropertyHelper(@TJvChartFloatingMarkerYPosition_R,@TJvChartFloatingMarkerYPosition_W,'YPosition');
    RegisterPropertyHelper(@TJvChartFloatingMarkerXDraggable_R,@TJvChartFloatingMarkerXDraggable_W,'XDraggable');
    RegisterPropertyHelper(@TJvChartFloatingMarkerXDragMin_R,@TJvChartFloatingMarkerXDragMin_W,'XDragMin');
    RegisterPropertyHelper(@TJvChartFloatingMarkerXDragMax_R,@TJvChartFloatingMarkerXDragMax_W,'XDragMax');
    RegisterPropertyHelper(@TJvChartFloatingMarkerYDraggable_R,@TJvChartFloatingMarkerYDraggable_W,'YDraggable');
    RegisterPropertyHelper(@TJvChartFloatingMarkerLineToMarker_R,@TJvChartFloatingMarkerLineToMarker_W,'LineToMarker');
    RegisterPropertyHelper(@TJvChartFloatingMarkerLineVertical_R,@TJvChartFloatingMarkerLineVertical_W,'LineVertical');
    RegisterPropertyHelper(@TJvChartFloatingMarkerLineStyle_R,@TJvChartFloatingMarkerLineStyle_W,'LineStyle');
    RegisterPropertyHelper(@TJvChartFloatingMarkerLineColor_R,@TJvChartFloatingMarkerLineColor_W,'LineColor');
    RegisterPropertyHelper(@TJvChartFloatingMarkerLineWidth_R,@TJvChartFloatingMarkerLineWidth_W,'LineWidth');
    RegisterPropertyHelper(@TJvChartFloatingMarkerCaption_R,@TJvChartFloatingMarkerCaption_W,'Caption');
    RegisterPropertyHelper(@TJvChartFloatingMarkerCaptionColor_R,@TJvChartFloatingMarkerCaptionColor_W,'CaptionColor');
    RegisterPropertyHelper(@TJvChartFloatingMarkerCaptionPosition_R,@TJvChartFloatingMarkerCaptionPosition_W,'CaptionPosition');
    RegisterPropertyHelper(@TJvChartFloatingMarkerCaptionBoxed_R,@TJvChartFloatingMarkerCaptionBoxed_W,'CaptionBoxed');
    RegisterPropertyHelper(@TJvChartFloatingMarkerTag_R,@TJvChartFloatingMarkerTag_W,'Tag');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvChart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvChart) do
  RIRegister_TJvChartFloatingMarker(CL);
  RIRegister_TJvChartGradientBar(CL);
  RIRegister_TJvChartHorizontalBar(CL);
  RIRegister_TJvChartVerticalBar(CL);
  RIRegister_TJvChartData(CL);
  with CL.Add(TJvChartOptions) do
  RIRegister_TJvChartYAxisOptions(CL);
  RIRegister_TJvChartOptions(CL);
  RIRegister_TJvChart(CL);
end;

 
 
{ TPSImport_JvChart }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvChart.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvChart(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvChart.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvChart(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
