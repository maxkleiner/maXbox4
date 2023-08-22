unit uPSI_TeEngine;
{
   just for this second TEE    add labels properties  and fonts  fix sealed  TChartSeriesList   TMarginsTE
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
  TPSImport_TeEngine = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 
{ compile-time registration functions }
procedure SIRegister_TTeeSeriesSource(CL: TPSPascalCompiler);
procedure SIRegister_TChartSeries(CL: TPSPascalCompiler);
procedure SIRegister_TDataSourcesList(CL: TPSPascalCompiler);
procedure SIRegister_TLabelsList(CL: TPSPascalCompiler);
procedure SIRegister_TTeeSeriesType(CL: TPSPascalCompiler);
procedure SIRegister_TCustomChartSeries(CL: TPSPascalCompiler);
procedure SIRegister_TChartValueLists(CL: TPSPascalCompiler);
procedure SIRegister_TTeeMovingFunction(CL: TPSPascalCompiler);
procedure SIRegister_TTeeFunction(CL: TPSPascalCompiler);
procedure SIRegister_TSeriesMarks(CL: TPSPascalCompiler);
procedure SIRegister_TMarginsTe(CL: TPSPascalCompiler);
procedure SIRegister_TSeriesMarksSymbol(CL: TPSPascalCompiler);
procedure SIRegister_TMarksCallout(CL: TPSPascalCompiler);
procedure SIRegister_TCallout(CL: TPSPascalCompiler);
procedure SIRegister_TSeriesPointer(CL: TPSPascalCompiler);
procedure SIRegister_TSeriesMarksGradient(CL: TPSPascalCompiler);
procedure SIRegister_TMarksItems(CL: TPSPascalCompiler);
procedure SIRegister_TMarksItem(CL: TPSPascalCompiler);
procedure SIRegister_TSeriesMarksPositions(CL: TPSPascalCompiler);
procedure SIRegister_TSeriesMarkPosition(CL: TPSPascalCompiler);
procedure SIRegister_TCustomAxisPanel(CL: TPSPascalCompiler);
procedure SIRegister_TTeeSeriesEvent(CL: TPSPascalCompiler);
procedure SIRegister_TChartPage(CL: TPSPascalCompiler);
procedure SIRegister_TTeeCustomToolAxis(CL: TPSPascalCompiler);
procedure SIRegister_TTeeCustomToolSeries(CL: TPSPascalCompiler);
procedure SIRegister_TChartTools(CL: TPSPascalCompiler);
procedure SIRegister_TTeeCustomTool(CL: TPSPascalCompiler);
procedure SIRegister_TTeeCustomDesigner(CL: TPSPascalCompiler);
procedure SIRegister_TChartCustomAxes(CL: TPSPascalCompiler);
procedure SIRegister_TChartAxes(CL: TPSPascalCompiler);
procedure SIRegister_TSeriesGroups(CL: TPSPascalCompiler);
procedure SIRegister_TSeriesGroup(CL: TPSPascalCompiler);
procedure SIRegister_TChartSeriesList(CL: TPSPascalCompiler);
procedure SIRegister_TCustomSeriesList(CL: TPSPascalCompiler);
procedure SIRegister_TSeriesEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_TChartDepthAxis(CL: TPSPascalCompiler);
procedure SIRegister_TChartAxis(CL: TPSPascalCompiler);
procedure SIRegister_TChartAxisPen(CL: TPSPascalCompiler);
procedure SIRegister_TAxisItems(CL: TPSPascalCompiler);
procedure SIRegister_TAxisItem(CL: TPSPascalCompiler);
procedure SIRegister_TAxisGridPen(CL: TPSPascalCompiler);
procedure SIRegister_TChartAxisTitle(CL: TPSPascalCompiler);
procedure SIRegister_TChartValueList(CL: TPSPascalCompiler);
procedure SIRegister_TCustomChartElement(CL: TPSPascalCompiler);
procedure SIRegister_TeEngine(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TeEngine_Routines(S: TPSExec);
procedure RIRegister_TTeeSeriesSource(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartSeries(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDataSourcesList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLabelsList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeSeriesType(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomChartSeries(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartValueLists(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeMovingFunction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeFunction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSeriesMarks(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMarginsTe(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSeriesMarksSymbol(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMarksCallout(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCallout(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSeriesPointer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSeriesMarksGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMarksItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMarksItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSeriesMarksPositions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSeriesMarkPosition(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomAxisPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeSeriesEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartPage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeCustomToolAxis(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeCustomToolSeries(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartTools(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeCustomTool(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeCustomDesigner(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartCustomAxes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartAxes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSeriesGroups(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSeriesGroup(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartSeriesList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomSeriesList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSeriesEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartDepthAxis(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartAxis(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartAxisPen(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAxisItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAxisItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAxisGridPen(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartAxisTitle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartValueList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomChartElement(CL: TPSRuntimeClassImporter);
procedure RIRegister_TeEngine(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // LCLIntf
  //,LMessages
  Windows
  ,Messages
  //,QGraphics
  //,QControls
  //,QDialogs
  ,Types
  ,Graphics
  ,Controls
  //,TeeAbout
  ,TeeProcs
  ,TeCanvas
  ,TeEngine
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TeEngine]);
end;

//type TmarginsTE = TMargins;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeSeriesSource(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TTeeSeriesSource') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TTeeSeriesSource') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function Available( AChart : TCustomAxisPanel) : Boolean');
    RegisterMethod('Function Description : String');
    RegisterMethod('Function Editor : TComponentClass');
    RegisterMethod('Function HasNew : Boolean');
    RegisterMethod('Function HasSeries( ASeries : TChartSeries) : Boolean');
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure Load');
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure Refresh');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('LoadMode', 'TSourceLoadMode', iptrw);
    RegisterProperty('Series', 'TChartSeries', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartSeries(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomChartSeries', 'TChartSeries') do
  with CL.AddClassN(CL.FindClass('TCustomChartSeries'),'TChartSeries') do begin
    RegisterMethod('Function RaiseClicked : Boolean');
    RegisterProperty('CalcVisiblePoints', 'Boolean', iptrw);
    RegisterProperty('DrawBetweenPoints', 'Boolean', iptrw);
    RegisterProperty('AllowSinglePoint', 'Boolean', iptrw);
    RegisterProperty('HasZValues', 'Boolean', iptrw);
    RegisterProperty('StartZ', 'Integer', iptrw);
    RegisterProperty('MiddleZ', 'Integer', iptrw);
    RegisterProperty('EndZ', 'Integer', iptrw);
    RegisterProperty('MandatoryValueList', 'TChartValueList', iptrw);
    RegisterProperty('NotMandatoryValueList', 'TChartValueList', iptrw);
    RegisterProperty('YMandatory', 'Boolean', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function Add( const AValue : Double; const ALabel : String; AColor : TColor) : Integer;');
    RegisterMethod('Function AddArray( const Values : array of TChartValue) : Integer;');
    RegisterMethod('Function AddNull( const Value : Double) : Integer;');
    RegisterMethod('Function AddNull1( const ALabel : String) : Integer;');
    RegisterMethod('Function AddNullXY( const X, Y : Double; const ALabel : String) : Integer');
    RegisterMethod('Function AddX( const AXValue : Double; const ALabel : String; AColor : TColor) : Integer');
    RegisterMethod('Function AddXY( const AXValue, AYValue : Double; const ALabel : String; AColor : TColor) : Integer');
    RegisterMethod('Function AddY( const AYValue : Double; const ALabel : String; AColor : TColor) : Integer');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure AssignFormat( Source : TChartSeries)');
    RegisterMethod('Function AssociatedToAxis( Axis : TChartAxis) : Boolean');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure CheckOrder');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Count : Integer');
    RegisterMethod('Function CountLegendItems : Integer');
    RegisterMethod('Procedure Delete( ValueIndex : Integer);');
    RegisterMethod('Procedure Delete1( Start, Quantity : Integer; RemoveGap : Boolean);');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Procedure FillSampleValues( NumValues : Integer)');
    RegisterMethod('Function FirstDisplayedIndex : Integer');
    RegisterMethod('Function IsNull( ValueIndex : Integer) : Boolean');
    RegisterMethod('Function IsValidSourceOf( Value : TChartSeries) : Boolean');
    RegisterMethod('Function IsValidSeriesSource( Value : TChartSeries) : Boolean');
    RegisterMethod('Function LegendToValueIndex( LegendIndex : Integer) : Integer');
    RegisterMethod('Function LegendItemColor( LegendIndex : Integer) : TColor');
    RegisterMethod('Function LegendString( LegendIndex : Integer; LegendTextStyle : TLegendTextStyle) : String');
    RegisterProperty('LinkedSeries', 'TCustomSeriesList', iptr);
    RegisterMethod('Function MaxXValue : Double');
    RegisterMethod('Function MaxYValue : Double');
    RegisterMethod('Function MaxZValue : Double');
    RegisterMethod('Function MinXValue : Double');
    RegisterMethod('Function MinYValue : Double');
    RegisterMethod('Function MinZValue : Double');
    RegisterMethod('Function NumSampleValues : Integer');
    RegisterMethod('Function RandomBounds( NumValues : Integer) : TSeriesRandomBounds');
    RegisterMethod('Procedure RemoveDataSource( Value : TComponent)');
    RegisterMethod('Procedure SetNull( ValueIndex : Integer; Null : Boolean)');
    RegisterMethod('Procedure SortByLabels( Order : TChartListOrder)');
    RegisterMethod('Function VisibleCount : Integer');
    RegisterProperty('ValuesList', 'TChartValueLists', iptr);
    RegisterProperty('XValue', 'TChartValue Integer', iptrw);
    RegisterProperty('YValue', 'TChartValue Integer', iptrw);
    RegisterProperty('ZOrder', 'Integer', iptrw);
    RegisterMethod('Function MaxMarkWidth : Integer');
    RegisterMethod('Function CalcXPos( ValueIndex : Integer) : Integer');
    RegisterMethod('Function CalcXPosValue( const Value : Double) : Integer');
    RegisterMethod('Function CalcXSizeValue( const Value : Double) : Integer');
    RegisterMethod('Function CalcYPos( ValueIndex : Integer) : Integer');
    RegisterMethod('Function CalcYPosValue( const Value : Double) : Integer');
    RegisterMethod('Function CalcYSizeValue( const Value : Double) : Integer');
    RegisterMethod('Function CalcPosValue( const Value : Double) : Integer');
    RegisterMethod('Function XScreenToValue( ScreenPos : Integer) : Double');
    RegisterMethod('Function YScreenToValue( ScreenPos : Integer) : Double');
    RegisterMethod('Function XValueToText( const AValue : Double) : String');
    RegisterMethod('Function YValueToText( const AValue : Double) : String');
    RegisterMethod('Procedure ColorRange( AValueList : TChartValueList; const FromValue, ToValue : Double; AColor : TColor)');
    RegisterMethod('Procedure CheckDataSource');
    RegisterProperty('Labels', 'TLabelsList', iptr);
    RegisterProperty('XLabel', 'String Integer', iptrw);
    RegisterProperty('ValueMarkText', 'String Integer', iptrw);
    RegisterProperty('ValueColor', 'TColor Integer', iptrw);
    RegisterProperty('XValues', 'TChartValueList', iptrw);
    RegisterProperty('YValues', 'TChartValueList', iptrw);
    RegisterMethod('Function GetYValueList( AListName : String) : TChartValueList');
    RegisterProperty('GetVertAxis', 'TChartAxis', iptr);
    RegisterProperty('GetHorizAxis', 'TChartAxis', iptr);
    RegisterMethod('Function MarkPercent( ValueIndex : Integer; AddTotal : Boolean) : String');
    RegisterMethod('Function Clicked( x, y : Integer) : Integer;');
    RegisterMethod('Function Clicked1( const P : TPoint) : Integer;');
    RegisterMethod('Procedure RefreshSeries');
    RegisterProperty('FirstValueIndex', 'Integer', iptr);
    RegisterProperty('LastValueIndex', 'Integer', iptr);
    RegisterMethod('Function GetOriginValue( ValueIndex : Integer) : Double');
    RegisterMethod('Function GetMarkValue( ValueIndex : Integer) : Double');
    RegisterMethod('Procedure AssignValues( Source : TChartSeries)');
    RegisterMethod('Function DrawValuesForward : Boolean');
    RegisterMethod('Function DrawSeriesForward( ValueIndex : Integer) : Boolean');
    RegisterMethod('Procedure SwapValueIndex( a, b : Integer)');
    RegisterProperty('RecalcOptions', 'TSeriesRecalcOptions', iptrw);
    RegisterMethod('Function GetCursorValueIndex : Integer');
    RegisterMethod('Procedure GetCursorValues( out XValue, YValue : Double)');
    RegisterMethod('Procedure DrawLegend( ValueIndex : Integer; const Rect : TRect)');
    RegisterMethod('Function UseAxis : Boolean');
    RegisterMethod('Procedure SetFunction( AFunction : TTeeFunction)');
    RegisterProperty('SeriesColor', 'TColor', iptrw);
    RegisterProperty('DataSources', 'TDataSourcesList', iptr);
    RegisterProperty('FunctionType', 'TTeeFunction', iptrw);
    RegisterMethod('Procedure CheckOtherSeries( Source : TChartSeries)');
    RegisterMethod('Procedure ReplaceList( OldList, NewList : TChartValueList)');
    RegisterProperty('CustomHorizAxis', 'TChartAxis', iptrw);
    RegisterProperty('CustomVertAxis', 'TChartAxis', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('ColorEachPoint', 'Boolean', iptrw);
    RegisterProperty('ColorSource', 'String', iptrw);
    RegisterProperty('Cursor', 'TCursor', iptrw);
    RegisterProperty('Depth', 'Integer', iptrw);
    RegisterProperty('HorizAxis', 'THorizAxis', iptrw);
    RegisterProperty('Marks', 'TSeriesMarks', iptrw);
    RegisterProperty('DataSource', 'TComponent', iptrw);
    RegisterProperty('PercentFormat', 'String', iptrw);
    RegisterProperty('ValueFormat', 'String', iptrw);
    RegisterProperty('VertAxis', 'TVertAxis', iptrw);
    RegisterProperty('XLabelsSource', 'String', iptrw);
    RegisterProperty('AfterDrawValues', 'TNotifyEvent', iptrw);
    RegisterProperty('BeforeDrawValues', 'TNotifyEvent', iptrw);
    RegisterProperty('OnAfterAdd', 'TSeriesOnAfterAdd', iptrw);
    RegisterProperty('OnBeforeAdd', 'TSeriesOnBeforeAdd', iptrw);
    RegisterProperty('OnClearValues', 'TSeriesOnClear', iptrw);
    RegisterProperty('OnClick', 'TSeriesClick', iptrw);
    RegisterProperty('OnDblClick', 'TSeriesClick', iptrw);
    RegisterProperty('OnGetMarkText', 'TSeriesOnGetMarkText', iptrw);
    RegisterProperty('OnMouseEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMouseLeave', 'TNotifyEvent', iptrw);
    //RegisterProperty('Title', 'String', iptrw);
    //RegisterProperty('Active', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataSourcesList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDataSourcesList') do
  with CL.AddClassN(CL.FindClass('TList'),'TDataSourcesList') do    //changed from tobject
  begin
    RegisterMethod('Function Add( Value : TComponent) : Integer');
    RegisterMethod('Procedure Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLabelsList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TLabelsList') do
  with CL.AddClassN(CL.FindClass('TList'),'TLabelsList') do begin
    RegisterMethod('Procedure Assign( Source : TLabelsList)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function IndexOfLabel( const ALabel : String; CaseSensitive : Boolean) : Integer');
    RegisterProperty('Labels', 'String Integer', iptrw);
    SetDefaultPropery('Labels');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeSeriesType(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTeeSeriesType') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTeeSeriesType') do begin
    RegisterProperty('SeriesClass', 'TChartSeriesClass', iptrw);
    RegisterProperty('FunctionClass', 'TTeeFunctionClass', iptrw);
    RegisterProperty('Description', 'PString', iptrw);
    RegisterProperty('GalleryPage', 'PString', iptrw);
    RegisterProperty('NumGallerySeries', 'Integer', iptrw);
    RegisterProperty('SubIndex', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomChartSeries(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomChartElement', 'TCustomChartSeries') do
  with CL.AddClassN(CL.FindClass('TCustomChartElement'),'TCustomChartSeries') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function SameClass( tmpSeries : TChartSeries) : Boolean');
    RegisterProperty('ShowInLegend', 'Boolean', iptrw);
    RegisterProperty('Title', 'String', iptrw);
    RegisterProperty('Identifier', 'String', iptrw);
    RegisterProperty('Style', 'TChartSeriesStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartValueLists(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TChartValueLists') do
  with CL.AddClassN(CL.FindClass('TList'),'TChartValueLists') do begin
    RegisterProperty('ValueList', 'TChartValueList Integer', iptr);
    SetDefaultPropery('ValueList');
    RegisterMethod('Procedure Clear;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeMovingFunction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeFunction', 'TTeeMovingFunction') do
  with CL.AddClassN(CL.FindClass('TTeeFunction'),'TTeeMovingFunction') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeFunction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TTeeFunction') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TTeeFunction') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure AddPoints( Source : TChartSeries)');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Function Calculate( SourceSeries : TChartSeries; First, Last : Integer) : Double');
    RegisterMethod('Function CalculateMany( SourceSeriesList : TList; ValueIndex : Integer) : Double');
    RegisterMethod('Procedure EndUpdate');
    RegisterProperty('ParentSeries', 'TChartSeries', iptrw);
    RegisterMethod('Procedure ReCalculate');
    RegisterProperty('Period', 'Double', iptrw);
    RegisterProperty('PeriodAlign', 'TFunctionPeriodAlign', iptrw);
    RegisterProperty('PeriodStyle', 'TFunctionPeriodStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSeriesMarks(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCustomShape', 'TSeriesMarks') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShape'),'TSeriesMarks') do begin
    RegisterMethod('Constructor Create( AOwner : TChartSeries)');
      RegisterMethod('Procedure Free;');
      RegisterMethod('Procedure ApplyArrowLength( APosition : TSeriesMarkPosition)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Clicked( X, Y : Integer) : Integer');
    RegisterMethod('Procedure DrawItem( Shape : TTeeCustomShape; AColor : TColor; const Text : String; APosition : TSeriesMarkPosition)');
    RegisterMethod('Procedure DrawText( const R : TRect; const St : String)');
    RegisterProperty('Item', 'TMarksItem Integer', iptr);
    SetDefaultPropery('Item');
    RegisterProperty('Items', 'TMarksItems', iptr);
    RegisterProperty('ParentSeries', 'TChartSeries', iptr);
    RegisterProperty('Positions', 'TSeriesMarksPositions', iptr);
    RegisterMethod('Procedure ResetPositions');
    RegisterProperty('ZPosition', 'Integer', iptrw);
    RegisterProperty('Angle', 'Integer', iptrw);
    RegisterProperty('Arrow', 'TChartArrowPen', iptrw);
    RegisterProperty('ArrowLength', 'Integer', iptrw);
    RegisterProperty('Callout', 'TMarksCallout', iptrw);
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('Clip', 'Boolean', iptrw);
    RegisterProperty('DrawEvery', 'Integer', iptrw);
    //RegisterProperty('Margins', 'TMarginsTe', iptrw);   //TMargins in controls!
     RegisterProperty('Margins', 'TMarginsTe', iptrw);   //TMargins in controls!
       RegisterProperty('Margins2', 'TMargins', iptrw);   //TMargins in controls!
    RegisterProperty('MultiLine', 'Boolean', iptrw);
    RegisterProperty('Style', 'TSeriesMarksStyle', iptrw);
    RegisterProperty('Symbol', 'TSeriesMarksSymbol', iptrw);
    RegisterProperty('TextAlign', 'TAlignment', iptrw);
       RegisterPublishedProperties;
     RegisterProperty('Brush', 'TChartBrush', iptrw);
    RegisterProperty('Font', 'TTeeFont', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    //RegisterProperty('Handle', 'TTeeCanvasHandle', iptr);
    RegisterProperty('Gradient', 'TTeeGradient', iptrw);
    RegisterProperty('Picture', 'TBackimage', iptrw);
     RegisterProperty('Shadow', 'TTEEShadow', iptrw);
     RegisterProperty('ShypeStyle', 'TChartObjectShapeStyle', iptrw);
    RegisterProperty('Frame', 'TChartPen', iptrw);
     RegisterProperty('Transparent', 'boolean', iptrw);
    RegisterProperty('Tranparency', 'integer', iptrw);
     RegisterProperty('Visible', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMarginsTe(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TMargins') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TMarginsTe') do begin
    RegisterMethod('Constructor Create( AParent : TTeeCustomShapeBrushPen)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Calculate( const Width, Height, FontSize : Integer)');
    RegisterMethod('Function HorizSize : Integer');
    RegisterMethod('Function VertSize : Integer');
    RegisterProperty('Size', 'TRect', iptr);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('Right', 'Integer', iptrw);
    RegisterProperty('Bottom', 'Integer', iptrw);
    RegisterProperty('Units', 'TMarginUnits', iptrw);
  end;
end;

//type TmarginsTE = TMargins;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSeriesMarksSymbol(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSeriesMarksSymbol') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShape'),'TSeriesMarksSymbol') do begin
  RegisterPublishedProperties;
     RegisterProperty('Brush', 'TChartBrush', iptrw);
     RegisterProperty('Pen', 'TChartPen', iptrw);
    //RegisterProperty('Font', 'TTeeFont', iptrw);
    //RegisterProperty('Color', 'TColor', iptrw);
    //RegisterProperty('Handle', 'TTeeCanvasHandle', iptr);
    RegisterProperty('Gradient', 'TTeeGradient', iptrw);
    RegisterProperty('Picture', 'TBackimage', iptrw);
     RegisterProperty('Shadow', 'TTEEShadow', iptrw);
     RegisterProperty('ShypeStyle', 'TChartObjectShapeStyle', iptrw);
      RegisterProperty('Style', 'TPenStyle', iptrw);
    RegisterProperty('Frame', 'TChartPen', iptrw);
    // RegisterProperty('Transparent', 'boolean', iptrw);
    RegisterProperty('Tranparency', 'integer', iptrw);
     RegisterProperty('Visible', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMarksCallout(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCallout', 'TMarksCallout') do
  with CL.AddClassN(CL.FindClass('TCallout'),'TMarksCallout') do begin
    RegisterMethod('Constructor Create( AOwner : TChartSeries)');
     RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Length', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCallout(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSeriesPointer', 'TCallout') do
  with CL.AddClassN(CL.FindClass('TSeriesPointer'),'TCallout') do begin
    RegisterMethod('Constructor Create( AOwner : TChartSeries)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
      RegisterMethod('Procedure Free;');
    RegisterProperty('Arrow', 'TChartArrowPen', iptrw);
    RegisterProperty('ArrowHead', 'TArrowHeadStyle', iptrw);
    RegisterProperty('ArrowHeadSize', 'Integer', iptrw);
    RegisterProperty('Distance', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSeriesPointer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCustomShapeBrushPen', 'TSeriesPointer') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShapeBrushPen'),'TSeriesPointer') do begin
    RegisterMethod('Constructor Create( AOwner : TChartSeries)');
      RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Draw( P : TPoint);');
    RegisterMethod('Procedure Draw1( X, Y : Integer);');
    RegisterMethod('Procedure Draw2( px, py : Integer; ColorValue : TColor; AStyle : TSeriesPointerStyle);');
    RegisterMethod('Procedure DrawPointer( ACanvas : TCanvas3D; Is3D : Boolean; px, py, tmpHoriz, tmpVert : Integer; ColorValue : TColor; AStyle : TSeriesPointerStyle)');
    RegisterMethod('Procedure PrepareCanvas( ACanvas : TCanvas3D; ColorValue : TColor)');
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('ParentSeries', 'TChartSeries', iptr);
    RegisterProperty('Size', 'Integer', iptrw);
    RegisterProperty('Dark3D', 'Boolean', iptrw);
    RegisterProperty('Draw3D', 'Boolean', iptrw);
    RegisterProperty('Gradient', 'TTeeGradient', iptrw);
    RegisterProperty('HorizSize', 'Integer', iptrw);
    RegisterProperty('InflateMargins', 'Boolean', iptrw);
    RegisterProperty('Shadow', 'TTeeShadow', iptrw);
    RegisterProperty('Style', 'TSeriesPointerStyle', iptrw);
    RegisterProperty('Transparency', 'TTeeTransparency', iptrw);
    RegisterProperty('VertSize', 'Integer', iptrw);
    RegisterpublishedProperties;
     RegisterProperty('Brush', 'TChartBrush', iptrw);
     RegisterProperty('Pen', 'TChartPen', iptrw);
     RegisterProperty('Visible', 'boolean', iptrw); 
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSeriesMarksGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSeriesMarksGradient') do
  with CL.AddClassN(CL.FindClass('TChartGradient'),'TSeriesMarksGradient') do begin
    RegisterMethod('Constructor Create( ChangedEvent : TNotifyEvent)');
     RegisterPublishedProperties;
     RegisterProperty('Direction', 'TGradientDirection', iptrw);
    RegisterProperty('EndColor', 'TColor', iptrw);
     RegisterProperty('StartColor', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMarksItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMarksItems') do
  with CL.AddClassN(CL.FindClass('TList'),'TMarksItems') do begin
    RegisterProperty('Format', 'TMarksItem Integer', iptr);
    SetDefaultPropery('Format');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMarksItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMarksItem') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShape'),'TMarksItem') do begin
    RegisterProperty('Text', 'TStrings', iptrw);
     RegisterPublishedProperties;
     //RegisterProperty('Brush', 'TChartBrush', iptrw);
     // RegisterProperty('Pen', 'TChartPen', iptrw);
    RegisterProperty('Font', 'TTeeFont', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    //RegisterProperty('Handle', 'TTeeCanvasHandle', iptr);
    RegisterProperty('Gradient', 'TTeeGradient', iptrw);
    RegisterProperty('Picture', 'TBackimage', iptrw);
     RegisterProperty('Shadow', 'TTEEShadow', iptrw);
     RegisterProperty('ShypeStyle', 'TChartObjectShapeStyle', iptrw);
      //RegisterProperty('Style', 'TPenStyle', iptrw);
    //RegisterProperty('Text', 'TStrings', iptrw);
     RegisterProperty('Transparent', 'boolean', iptrw);
    RegisterProperty('Tranparency', 'integer', iptrw);
    // RegisterProperty('Visible', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSeriesMarksPositions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSeriesMarksPositions') do
  with CL.AddClassN(CL.FindClass('TList'),'TSeriesMarksPositions') do begin
    RegisterMethod('Procedure Automatic( Index : Integer)');
     RegisterMethod('Procedure Clear');
    RegisterMethod('Function ExistCustom : Boolean');
    RegisterMethod('Procedure MoveTo( var Position : TSeriesMarkPosition; XPos, YPos : Integer)');
    RegisterProperty('Position', 'TSeriesMarkPosition Integer', iptrw);
    SetDefaultPropery('Position');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSeriesMarkPosition(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSeriesMarkPosition') do
  with CL.AddClassN(CL.FindClass('TList'),'TSeriesMarkPosition') do begin   //change from tobject
    RegisterProperty('ArrowFrom', 'TPoint', iptrw);
    RegisterProperty('ArrowFix', 'Boolean', iptrw);
    RegisterProperty('ArrowTo', 'TPoint', iptrw);
    RegisterProperty('Custom', 'Boolean', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('LeftTop', 'TPoint', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('MidPoint', 'TPoint', iptrw);
    RegisterProperty('HasMid', 'Boolean', iptrw);
    RegisterMethod('Procedure Assign( Source : TSeriesMarkPosition)');
    RegisterMethod('Function Bounds : TRect');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomAxisPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTeePanelExtended', 'TCustomAxisPanel') do
  with CL.AddClassN(CL.FindClass('TCustomTeePanelExtended'),'TCustomAxisPanel') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Free;');
    RegisterProperty('Designer', 'TTeeCustomDesigner', iptrw);
    RegisterProperty('ColorPalette', 'TColorArray', iptrw);
    RegisterMethod('Function ActiveSeriesLegend( ItemIndex : Integer) : TChartSeries');
    RegisterMethod('Function AddSeries( const ASeries : TChartSeries) : TChartSeries;');
    RegisterMethod('Function AddSeries1( const ASeriesClass : TChartSeriesClass) : TChartSeries;');
    RegisterMethod('Procedure AddSeries2( const SeriesArray : array of TChartSeries);');
    RegisterMethod('Procedure CalcSize3DWalls');
    RegisterMethod('Procedure CheckDatasource( ASeries : TChartSeries)');
    RegisterMethod('Function CountActiveSeries : Integer');
    RegisterMethod('Procedure ExchangeSeries( a, b : Integer);');
    RegisterMethod('Procedure ExchangeSeries1( a, b : TCustomChartSeries);');
    RegisterMethod('Function FormattedValueLegend( ASeries : TChartSeries; ValueIndex : Integer) : String');
    RegisterMethod('Procedure FreeAllSeries( SeriesClass : TChartSeriesClass)');
    RegisterMethod('Function GetAxisSeries( Axis : TChartAxis) : TChartSeries');
    RegisterMethod('Function GetDefaultColor( Index : Integer) : TColor');
    RegisterMethod('Function GetFreeSeriesColor( CheckBackground : Boolean; Series : TChartSeries) : TColor');
    RegisterMethod('Function GetMaxValuesCount : Integer');
    RegisterMethod('Function IsFreeSeriesColor( AColor : TColor; CheckBackground : Boolean; Series : TChartSeries) : Boolean');
    RegisterMethod('Function IsValidDataSource( ASeries : TChartSeries; AComponent : TComponent) : Boolean');
    RegisterMethod('Function MaxXValue( AAxis : TChartAxis) : Double');
    RegisterMethod('Function MaxYValue( AAxis : TChartAxis) : Double');
    RegisterMethod('Function MinXValue( AAxis : TChartAxis) : Double');
    RegisterMethod('Function MinYValue( AAxis : TChartAxis) : Double');
    RegisterMethod('Function MaxMarkWidth : Integer');
    RegisterMethod('Function MaxTextWidth : Integer');
    RegisterMethod('Function MultiLineTextWidth( S : String; out NumLines : Integer) : Integer');
    RegisterMethod('Function NumPages : Integer');
    RegisterMethod('Procedure PrintPages( FromPage : Integer; ToPage : Integer)');
    RegisterMethod('Procedure RemoveSeries( ASeries : TCustomChartSeries);');
    RegisterMethod('Procedure RemoveSeries1( SeriesIndex : Integer);');
    RegisterProperty('Series', 'TChartSeries Integer', iptr);
    SetDefaultPropery('Series');
    RegisterMethod('Function SeriesCount : Integer');
    RegisterMethod('Function SeriesLegend( ItemIndex : Integer; OnlyActive : Boolean) : TChartSeries');
    RegisterMethod('Function SeriesTitleLegend( SeriesIndex : Integer; OnlyActive : Boolean) : String');
    RegisterProperty('Axes', 'TChartAxes', iptr);
    RegisterProperty('AxesList', 'TChartAxes', iptr);
    RegisterProperty('CustomAxes', 'TChartCustomAxes', iptrw);
    RegisterProperty('MaxZOrder', 'Integer', iptrw);
    RegisterProperty('SeriesWidth3D', 'Integer', iptr);
    RegisterProperty('SeriesHeight3D', 'Integer', iptr);
    RegisterProperty('AxisBehind', 'Boolean', iptrw);
    RegisterProperty('AxisVisible', 'Boolean', iptrw);
    RegisterProperty('BottomAxis', 'TChartAxis', iptrw);
    RegisterProperty('Chart3DPercent', 'Integer', iptrw);
    RegisterProperty('ClipPoints', 'Boolean', iptrw);
    RegisterProperty('DepthAxis', 'TChartDepthAxis', iptrw);
    RegisterProperty('DepthTopAxis', 'TChartDepthAxis', iptrw);
    RegisterProperty('LeftAxis', 'TChartAxis', iptrw);
    RegisterProperty('MaxPointsPerPage', 'Integer', iptrw);
    RegisterProperty('Page', 'Integer', iptrw);
    RegisterProperty('Pages', 'TChartPage', iptrw);
    RegisterProperty('RightAxis', 'TChartAxis', iptrw);
    RegisterProperty('ScaleLastPage', 'Boolean', iptrw);
    RegisterProperty('SeriesGroups', 'TSeriesGroups', iptrw);
    RegisterProperty('SeriesList', 'TChartSeriesList', iptr);
    RegisterProperty('Tools', 'TChartTools', iptr);
    RegisterProperty('TopAxis', 'TChartAxis', iptrw);
    RegisterProperty('View3DWalls', 'Boolean', iptrw);
    RegisterProperty('OnAddSeries', 'TSeriesNotifyEvent', iptrw);
    RegisterProperty('OnBeforeDrawChart', 'TNotifyEvent', iptrw);
    RegisterProperty('OnBeforeDrawAxes', 'TNotifyEvent', iptrw);
    RegisterProperty('OnBeforeDrawSeries', 'TNotifyEvent', iptrw);
    RegisterProperty('OnGetAxisLabel', 'TAxisOnGetLabel', iptrw);
    RegisterProperty('OnGetNextAxisLabel', 'TAxisOnGetNextLabel', iptrw);
    RegisterProperty('OnPageChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRemoveSeries', 'TSeriesNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeSeriesEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeEvent', 'TTeeSeriesEvent') do
  with CL.AddClassN(CL.FindClass('TTeeEvent'),'TTeeSeriesEvent') do begin
    RegisterProperty('Event', 'TChartSeriesEvent', iptrw);
    RegisterProperty('Series', 'TCustomChartSeries', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartPage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TChartPage') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TChartPage') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function Count : Integer');
    RegisterMethod('Function FirstValueIndex : Integer');
    RegisterMethod('Procedure NextPage');
    RegisterMethod('Procedure PreviousPage');
    RegisterProperty('Parent', 'TCustomAxisPanel', iptr);
    RegisterProperty('AutoScale', 'Boolean', iptrw);
    RegisterProperty('Current', 'Integer', iptrw);
    RegisterProperty('MaxPointsPerPage', 'Integer', iptrw);
    RegisterProperty('ScaleLastPage', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeCustomToolAxis(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCustomTool', 'TTeeCustomToolAxis') do
  with CL.AddClassN(CL.FindClass('TTeeCustomTool'),'TTeeCustomToolAxis') do
  begin
    RegisterProperty('Axis', 'TChartAxis', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeCustomToolSeries(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCustomTool', 'TTeeCustomToolSeries') do
  with CL.AddClassN(CL.FindClass('TTeeCustomTool'),'TTeeCustomToolSeries') do
  begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Series', 'TChartSeries', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartTools(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TChartTools') do
  with CL.AddClassN(CL.FindClass('TList'),'TChartTools') do begin
    RegisterMethod('Function Add2( Tool : TTeeCustomTool) : TTeeCustomTool;');
     RegisterMethod('Function Add( Tool : TTeeCustomTool) : TTeeCustomTool;');
    RegisterMethod('procedure Clear;');
    RegisterProperty('Active', 'Boolean', iptw);
    RegisterProperty('Items', 'TTeeCustomTool Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('Owner', 'TCustomAxisPanel', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeCustomTool(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomChartElement', 'TTeeCustomTool') do
  with CL.AddClassN(CL.FindClass('TCustomChartElement'),'TTeeCustomTool') do
  begin
    RegisterMethod('Function Description : String');
    RegisterMethod('Function LongDescription : String');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeCustomDesigner(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TTeeCustomDesigner') do
  with CL.AddClassN(CL.FindClass('TObject'),'TTeeCustomDesigner') do begin
    RegisterMethod('Procedure Refresh');
    RegisterMethod('Procedure Repaint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartCustomAxes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TChartCustomAxes') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TChartCustomAxes') do begin
    RegisterMethod('Procedure ResetScales( Axis : TChartAxis)');
    RegisterProperty('Items', 'TChartAxis Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartAxes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TChartAxes') do
  with CL.AddClassN(CL.FindClass('TList'),'TChartAxes') do begin
    RegisterMethod('Procedure Hide');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Reset');
    RegisterProperty('Items', 'TChartAxis Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('Bottom', 'TChartAxis', iptr);
    RegisterProperty('Depth', 'TChartDepthAxis', iptr);
    RegisterProperty('DepthTop', 'TChartDepthAxis', iptr);
    RegisterProperty('Left', 'TChartAxis', iptr);
    RegisterProperty('Right', 'TChartAxis', iptr);
    RegisterProperty('Top', 'TChartAxis', iptr);
    RegisterProperty('Behind', 'Boolean', iptrw);
    RegisterProperty('FastCalc', 'Boolean', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSeriesGroups(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSeriesGroups') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TSeriesGroups') do begin
    RegisterMethod('Function Contains( Series : TChartSeries) : Integer');
    RegisterMethod('Function FindByName( const Name : String; CaseSensitive : Boolean) : TSeriesGroup');
    RegisterProperty('Items', 'TSeriesGroup Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSeriesGroup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSeriesGroup') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TSeriesGroup') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Add( Series : TChartSeries)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Hide');
    RegisterMethod('Procedure Show');
    RegisterProperty('Active', 'TSeriesGroupActive', iptrw);
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('Series', 'TCustomSeriesList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartSeriesList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TChartSeriesList') do
  with CL.AddClassN(CL.FindClass('TCustomSeriesList'),'TChartSeriesList') do begin
    RegisterMethod('Function AddGroup( const Name : String) : TSeriesGroup');
    RegisterMethod('Procedure Assign( Source : TChartSeriesList)');
    RegisterProperty('AllActive', 'Boolean', iptrw);
    RegisterProperty('Groups', 'TSeriesGroups', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomSeriesList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TCustomSeriesList') do
  with CL.AddClassN(CL.FindClass('TList'),'TCustomSeriesList') do begin
    RegisterMethod('Procedure ClearValues');
    RegisterMethod('Procedure FillSampleValues( Num : Integer)');
    RegisterMethod('Function First : TChartSeries');
    RegisterMethod('Function GetEnumerator : TSeriesEnumerator');
    RegisterMethod('Function Last : TChartSeries');
    RegisterProperty('Items', 'TChartSeries Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('Owner', 'TCustomAxisPanel', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSeriesEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSeriesEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TSeriesEnumerator') do begin
    RegisterMethod('Constructor Create( List : TCustomSeriesList)');
    RegisterMethod('Function GetCurrent : TChartSeries');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TChartSeries', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartDepthAxis(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartAxis', 'TChartDepthAxis') do
  with CL.AddClassN(CL.FindClass('TChartAxis'),'TChartDepthAxis') do begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartAxis(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TChartAxis') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TChartAxis') do begin
    RegisterProperty('IStartPos', 'Integer', iptrw);
    RegisterProperty('IEndPos', 'Integer', iptrw);
    RegisterProperty('IAxisSize', 'Integer', iptrw);
    RegisterProperty('CalcXPosValue', 'TAxisCalcPos', iptrw);
    RegisterProperty('CalcYPosValue', 'TAxisCalcPos', iptrw);
    RegisterProperty('CalcPosValue', 'TAxisCalcPos', iptrw);
    RegisterProperty('Tick', 'TAxisTicks', iptrw);
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AdjustMaxMin');
    RegisterMethod('Procedure AdjustMaxMinRect( const Rect : TRect)');
    RegisterMethod('Function CalcIncrement : Double');
    RegisterMethod('Function CalcLabelStyle : TAxisLabelStyle');
    RegisterMethod('Procedure CalcMinMax( out AMin, AMax : Double)');
    RegisterMethod('Function CalcPosPoint( Value : Integer) : Double');
    RegisterMethod('Function CalcSizeValue( const Value : Double) : Integer');
    RegisterMethod('Function CalcXYIncrement( MaxLabelSize : Integer) : Double');
    RegisterMethod('Procedure CustomDraw( APosLabels, APosTitle, APosAxis : Integer; GridVisible : Boolean)');
    RegisterMethod('Procedure CustomDrawMinMax( APosLabels, APosTitle, APosAxis : Integer; GridVisible : Boolean; const AMinimum, AMaximum, AIncrement : Double)');
    RegisterMethod('Procedure CustomDrawMinMaxStartEnd( APosLabels, APosTitle, APosAxis : Integer; GridVisible : Boolean; const AMinimum, AMaximum, AIncrement : Double; AStartPos, AEndPos : Integer)');
    RegisterMethod('Procedure CustomDrawStartEnd( APosLabels, APosTitle, APosAxis : Integer; GridVisible : Boolean; AStartPos, AEndPos : Integer)');
    RegisterMethod('Function Clicked( x, y : Integer) : Boolean');
    RegisterMethod('Procedure Draw( CalcPosAxis : Boolean)');
    RegisterMethod('Procedure DrawAxisLabel( x, y, Angle : Integer; const St : String; Format : TTeeCustomShape; z : Integer)');
    RegisterMethod('Function IsDateTime : Boolean');
    RegisterMethod('Function LabelWidth( const Value : Double) : Integer');
    RegisterMethod('Function LabelHeight( const Value : Double) : Integer');
    RegisterMethod('Function LabelValue( const Value : Double) : String');
    RegisterMethod('Function MaxLabelsWidth : Integer');
    RegisterMethod('Procedure Scroll( const Offset : Double; CheckLimits : Boolean)');
    RegisterMethod('Procedure SetMinMax( AMin, AMax : Double)');
    RegisterProperty('IsDepthAxis', 'Boolean', iptr);
    RegisterProperty('Items', 'TAxisItems', iptr);
    RegisterProperty('MasterAxis', 'TChartAxis', iptrw);
    RegisterProperty('PosAxis', 'Integer', iptr);
    RegisterProperty('PosLabels', 'Integer', iptr);
    RegisterProperty('PosTitle', 'Integer', iptr);
    RegisterProperty('ParentChart', 'TCustomAxisPanel', iptr);
    RegisterProperty('Automatic', 'Boolean', iptrw);
    RegisterProperty('AutomaticMaximum', 'Boolean', iptrw);
    RegisterProperty('AutomaticMinimum', 'Boolean', iptrw);
    RegisterProperty('Axis', 'TChartAxisPen', iptrw);
    RegisterProperty('AxisValuesFormat', 'String', iptrw);
    RegisterProperty('DateTimeFormat', 'String', iptrw);
    RegisterProperty('ExactDateTime', 'Boolean', iptrw);
    RegisterProperty('Grid', 'TAxisGridPen', iptrw);
    RegisterProperty('GridCentered', 'Boolean', iptrw);
    RegisterProperty('Increment', 'Double', iptrw);
    RegisterProperty('Inverted', 'Boolean', iptrw);
    RegisterProperty('Horizontal', 'Boolean', iptrw);
    RegisterProperty('OtherSide', 'Boolean', iptrw);
    RegisterProperty('Labels', 'Boolean', iptrw);
    RegisterProperty('LabelsAlign', 'TAxisLabelAlign', iptrw);
    RegisterProperty('LabelsAlternate', 'Boolean', iptrw);
    RegisterProperty('LabelsAngle', 'Integer', iptrw);
    RegisterProperty('LabelsExponent', 'Boolean', iptrw);
    RegisterProperty('LabelsFont', 'TTeeFont', iptrw);
    RegisterProperty('LabelsMultiLine', 'Boolean', iptrw);
    RegisterProperty('LabelsOnAxis', 'Boolean', iptrw);
    RegisterProperty('LabelsSeparation', 'Integer', iptrw);
    RegisterProperty('LabelsSize', 'Integer', iptrw);
    RegisterProperty('LabelStyle', 'TAxisLabelStyle', iptrw);
    RegisterProperty('Logarithmic', 'Boolean', iptrw);
    RegisterProperty('LogarithmicBase', 'Double', iptrw);
    RegisterProperty('Maximum', 'Double', iptrw);
    RegisterProperty('MaximumOffset', 'Integer', iptrw);
    RegisterProperty('MaximumRound', 'Boolean', iptrw);
    RegisterProperty('Minimum', 'Double', iptrw);
    RegisterProperty('MinimumOffset', 'Integer', iptrw);
    RegisterProperty('MinimumRound', 'Boolean', iptrw);
    RegisterProperty('MinorGrid', 'TChartHiddenPen', iptrw);
    RegisterProperty('MinorTickCount', 'Integer', iptrw);
    RegisterProperty('MinorTickLength', 'Integer', iptrw);
    RegisterProperty('MinorTicks', 'TDarkGrayPen', iptrw);
    RegisterProperty('StartPosition', 'Double', iptrw);
    RegisterProperty('EndPosition', 'Double', iptrw);
    RegisterProperty('PositionPercent', 'Double', iptrw);
    RegisterProperty('PositionUnits', 'TTeeUnits', iptrw);
    RegisterProperty('RoundFirstLabel', 'Boolean', iptrw);
    RegisterProperty('TickInnerLength', 'Integer', iptrw);
    RegisterProperty('TickLength', 'Integer', iptrw);
    RegisterProperty('Ticks', 'TDarkGrayPen', iptrw);
    RegisterProperty('TicksInner', 'TDarkGrayPen', iptrw);
    RegisterProperty('TickOnLabelsOnly', 'Boolean', iptrw);
    RegisterProperty('Title', 'TChartAxisTitle', iptrw);
    RegisterProperty('TitleSize', 'Integer', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('ZPosition', 'Double', iptrw);
    RegisterProperty('OnDrawLabel', 'TAxisDrawLabelEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartAxisPen(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TChartAxisPen') do
  with CL.AddClassN(CL.FindClass('TChartPen'),'TChartAxisPen') do begin
    RegisterMethod('Constructor Create( OnChangeEvent : TNotifyEvent)');
    RegisterProperty('LineMode', 'TPenLineMode', iptrw);
    RegisterPublishedProperties;
     RegisterProperty('Width', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAxisItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TAxisItems') do
  with CL.AddClassN(CL.FindClass('TList'),'TAxisItems') do begin
    RegisterMethod('Constructor Create( Axis : TChartAxis)');
    RegisterMethod('Function Add( const Value : Double) : TAxisItem;');
    RegisterMethod('Function Add1( const Value : Double; const Text : String) : TAxisItem;');
    RegisterMethod('Procedure CopyFrom( Source : TAxisItems)');
    RegisterProperty('Automatic', 'Boolean', iptrw);
    RegisterProperty('Format', 'TTeeShape', iptr);
    RegisterProperty('Item', 'TAxisItem Integer', iptr);
    SetDefaultPropery('Item');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAxisItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCustomShape', 'TAxisItem') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShape'),'TAxisItem') do begin
    RegisterMethod('Procedure Repaint');
    RegisterProperty('Text', 'String', iptrw);
    RegisterProperty('Value', 'Double', iptrw);
      RegisterPublishedProperties;
     RegisterProperty('Brush', 'TChartBrush', iptrw);
    RegisterProperty('Font', 'TTeeFont', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    //RegisterProperty('Handle', 'TTeeCanvasHandle', iptr);
    RegisterProperty('Gradient', 'TTeeGradient', iptrw);
    RegisterProperty('Picture', 'TBackimage', iptrw);
    //RegisterProperty('Pen', 'TChartPen', iptrw);
     RegisterProperty('Transparent', 'boolean', iptrw);
    RegisterProperty('Tranparency', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAxisGridPen(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TAxisGridPen') do
  with CL.AddClassN(CL.FindClass('TDottedGrayPen'),'TAxisGridPen') do begin
    RegisterMethod('Constructor Create( OnChangeEvent : TNotifyEvent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Centered', 'Boolean', iptrw);
    RegisterProperty('DrawEvery', 'Integer', iptrw);
    RegisterProperty('ZPosition', 'Double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartAxisTitle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TChartAxisTitle') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShape'),'TChartAxisTitle') do begin
    RegisterMethod('Constructor Create( AOwner : TCustomTeePanel)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function Clicked( x, y : Integer) : Boolean');
    RegisterProperty('Angle', 'Integer', iptrw);
    RegisterProperty('Caption', 'String', iptrw);
    RegisterPublishedProperties;
     RegisterProperty('Brush', 'TChartBrush', iptrw);
    RegisterProperty('Font', 'TTeeFont', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    //RegisterProperty('Handle', 'TTeeCanvasHandle', iptr);
    RegisterProperty('Gradient', 'TTeeGradient', iptrw);
    RegisterProperty('Picture', 'TBackimage', iptrw);
    RegisterProperty('Pen', 'TChartPen', iptrw);
     RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('Tranparency', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartValueList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TChartValueList') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TChartValueList') do begin
    RegisterProperty('Value', 'TChartValues', iptrw);
    RegisterMethod('Constructor Create( AOwner : TChartSeries; const AName : String)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function Count : Integer');
    RegisterMethod('Procedure Delete( ValueIndex : Integer);');
    RegisterMethod('Procedure Delete1( Start, Quantity : Integer);');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Procedure FillSequence');
    RegisterMethod('Function First : TChartValue');
    RegisterMethod('Function Last : TChartValue');
    RegisterMethod('Function Locate( const AValue : TChartValue) : Integer;');
    RegisterMethod('Function Locate1( const AValue : TChartValue; FirstIndex, LastIndex : Integer) : Integer;');
    RegisterMethod('Function Range : TChartValue');
    RegisterMethod('Procedure Scroll');
    RegisterMethod('Procedure Sort');
    RegisterProperty('MaxValue', 'TChartValue', iptr);
    RegisterProperty('MinValue', 'TChartValue', iptr);
    RegisterProperty('Modified', 'Boolean', iptrw);
    RegisterProperty('Owner', 'TChartSeries', iptr);
    RegisterProperty('TempValue', 'TChartValue', iptrw);
    RegisterMethod('Function ToString( Index : Integer) : String');
    RegisterProperty('Total', 'Double', iptr);
    RegisterProperty('TotalABS', 'Double', iptrw);
    RegisterProperty('Items', 'TChartValue Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('Value', 'TChartValue Integer', iptrw);
    SetDefaultPropery('Value');
    RegisterProperty('DateTime', 'Boolean', iptrw);
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('Multiplier', 'Double', iptrw);
    RegisterProperty('Order', 'TChartListOrder', iptrw);
    RegisterProperty('ValueSource', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomChartElement(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomChartElement') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomChartElement') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function EditorClass : String');
    RegisterMethod('Procedure Repaint');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Brush', 'TChartBrush', iptrw);
    RegisterProperty('ParentChart', 'TCustomAxisPanel', iptrw);
    RegisterProperty('Pen', 'TChartPen', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('ShowInEditor', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TeEngine(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('ChartMarkColor','').SetString( clInfoBk);
 CL.AddConstantN('MinAxisIncrement','Double').setExtended( 0.000000000001);
 CL.AddConstantN('MinAxisRange','Double').setExtended( 0.0000000001);
 CL.AddConstantN('TeeAllValues','LongInt').SetInt( - 1);
 CL.AddConstantN('clTeeColor','LongWord').SetUInt( TColor ( $20000000 ));
 CL.AddConstantN('ChartSamplesMax','LongInt').SetInt( 1000);
 CL.AddConstantN('TeeAutoZOrder','LongInt').SetInt( - 1);
 CL.AddConstantN('TeeAutoDepth','LongInt').SetInt( - 1);
 CL.AddConstantN('TeeNoPointClicked','LongInt').SetInt( - 1);
 CL.AddConstantN('TeeDef3DPercent','LongInt').SetInt( 15);
 CL.AddConstantN('TeeInitialCustomAxis','LongInt').SetInt( 6);
 CL.AddConstantN('TeeDefaultLabelsSeparation','LongInt').SetInt( 10);
  CL.AddClassN(CL.FindClass('TCustomTeePanelExtended'),'TCustomAxisPanel');
  CL.AddTypeS('TChartArrowPen','TWhitePen');
  SIRegister_TCustomChartElement(CL);
  CL.AddClassN(CL.FindClass('TCustomChartElement'),'TCustomChartSeries');
  CL.AddClassN(CL.FindClass('TCustomChartSeries'),'TChartSeries');
  //CL.AddTypeS('TChartValue', 'Single');
  //CL.AddTypeS('TChartValue', 'Double');
  //CL.AddTypeS('TChartValue', 'Extended');
  CL.AddTypeS('TChartValue', 'Double');
  CL.AddTypeS('TChartValues', 'array of TChartValue');
  //CL.AddTypeS('PChartValue', '^TChartValue // will not work');
  CL.AddTypeS('TChartListOrder', '( loNone, loAscending, loDescending )');
  SIRegister_TChartValueList(CL);
  SIRegister_TChartAxisTitle(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'AxisException');
  CL.AddTypeS('TAxisLabelStyle', '( talAuto, talNone, talValue, talMark, talText )');
  CL.AddTypeS('TAxisLabelAlign', '( alDefault, alOpposite )');
  CL.AddTypeS('TAxisCalcPos', 'Function ( const Value : TChartValue) : Integer');
  CL.AddClassN(CL.FindClass('TList'),'TCustomSeriesList');
  SIRegister_TAxisGridPen(CL);
  CL.AddTypeS('TAxisTicks', 'array of Integer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TChartAxis');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAxisItems');
  SIRegister_TAxisItem(CL);
  SIRegister_TAxisItems(CL);
  CL.AddTypeS('TPenLineMode', '( lmLine, lmCylinder, lmRectangle )');
  SIRegister_TChartAxisPen(CL);
  CL.AddTypeS('TAxisDrawLabelEvent', 'Procedure ( Sender : TChartAxis; var X, Y'
   +', Z : Integer; var Text : String; var DrawLabel : Boolean)');
  CL.AddTypeS('TAxisDrawGrids', 'Procedure ( Sender : TChartAxis)');
  SIRegister_TChartAxis(CL);
  SIRegister_TChartDepthAxis(CL);
  CL.AddTypeS('TAxisOnGetLabel', 'Procedure ( Sender : TChartAxis; Series : TCh'
   +'artSeries; ValueIndex : Integer; var LabelText : String)');
  CL.AddTypeS('TAxisOnGetNextLabel', 'Procedure ( Sender : TChartAxis; LabelInd'
   +'ex : Integer; var LabelValue : Double; var Stop : Boolean)');
  CL.AddTypeS('TSeriesClick', 'Procedure ( Sender : TChartSeries; ValueIndex : '
   +'Integer; Button : TMouseButton; Shift : TShiftState; X, Y : Integer)');
  CL.AddTypeS('TValueEvent', '( veClear, veAdd, veDelete, veRefresh, veModify )');
  CL.AddTypeS('THorizAxis', '( aTopAxis, aBottomAxis, aBothHorizAxis, aCustomHorizAxis )');
  CL.AddTypeS('TVertAxis', '( aLeftAxis, aRightAxis, aBothVertAxis, aCustomVertAxis )');
  CL.AddTypeS('TChartClickedPartStyle', '( cpNone, cpLegend, cpAxis, cpSeries, '
   +'cpTitle, cpFoot, cpChartRect, cpSeriesMarks, cpSubTitle, cpSubFoot, cpAxisTitle )');
  CL.AddTypeS('TChartClickedPart', 'record Part : TChartClickedPartStyle; Point'
   +'Index : Integer; ASeries : TChartSeries; AAxis : TChartAxis; end');
  SIRegister_TSeriesEnumerator(CL);
  SIRegister_TCustomSeriesList(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSeriesGroup');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSeriesGroups');
  SIRegister_TChartSeriesList(CL);     //from tcustomserieslist
  CL.AddTypeS('TSeriesGroupActive', '( gaYes, gaNo, gaSome )');
  SIRegister_TSeriesGroup(CL);
  SIRegister_TSeriesGroups(CL);
  CL.AddTypeS('TAxisCalcPosLabels', 'Function ( Axis : TChartAxis; Value : Integer) : Integer');
  SIRegister_TChartAxes(CL);
  SIRegister_TChartCustomAxes(CL);
  SIRegister_TTeeCustomDesigner(CL);
  CL.AddTypeS('TChartSeriesEvent', '( seAdd, seRemove, seChangeTitle, seChangeC'
   +'olor, seSwap, seChangeActive, seDataChanged )');
  CL.AddClassN(CL.FindClass('TTeeEvent'),'TChartChangePage');      //finder
  CL.AddTypeS('TChartToolEvent', '( cteAfterDraw, cteBeforeDrawSeries, cteBefor'
   +'eDraw, cteBeforeDrawAxes, cteAfterDrawSeries, cteMouseLeave )');
  CL.AddTypeS('TChartMouseEvent', '( cmeDown, cmeMove, cmeUp )');
  CL.AddTypeS('TWheelMouseEvent', '( wmeDown, wmeMove, wmeUp )');
  SIRegister_TTeeCustomTool(CL);
  //CL.AddTypeS('TTeeCustomToolClass', 'class of TTeeCustomTool');
  SIRegister_TChartTools(CL);
  SIRegister_TTeeCustomToolSeries(CL);
  SIRegister_TTeeCustomToolAxis(CL);
  SIRegister_TChartPage(CL);
  //CL.AddTypeS('TTeeEventClass', 'class of TTeeEvent');
  SIRegister_TTeeSeriesEvent(CL);
  CL.AddTypeS('TSeriesNotifyEvent', 'Procedure ( Sender : TCustomChartSeries)');
  //CL.AddTypeS('TChartSeriesClass', 'class of TChartSeries');
  SIRegister_TCustomAxisPanel(CL);
  SIRegister_TSeriesMarkPosition(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSeriesMarks');
  SIRegister_TSeriesMarksPositions(CL);
  SIRegister_TMarksItem(CL);
  SIRegister_TMarksItems(CL);
  CL.AddTypeS('TSeriesMarksStyle', '( smsValue, smsPercent, smsLabel, smsLabelP'
   +'ercent, smsLabelValue, smsLegend, smsPercentTotal, smsLabelPercentTotal, s'
   +'msXValue, smsXY, smsSeriesTitle, smsPointIndex, smsPercentRelative )');
  SIRegister_TSeriesMarksGradient(CL);
  CL.AddTypeS('TSeriesPointerStyle', '( psRectangle, psCircle, psTriangle, psDo'
   +'wnTriangle, psCross, psDiagCross, psStar, psDiamond, psSmallDot, psNothing'
   +', psLeftTriangle, psRightTriangle, psHexagon )');
  SIRegister_TSeriesPointer(CL);
  CL.AddTypeS('TArrowHeadStyle', '( ahNone, ahLine, ahSolid )');
  SIRegister_TCallout(CL);
  SIRegister_TMarksCallout(CL);
  SIRegister_TSeriesMarksSymbol(CL);
  CL.AddTypeS('TMarginUnits', '( maPercentFont, maPercentSize, maPixels )');
  SIRegister_TMarginsTe(CL);
  SIRegister_TSeriesMarks(CL);
  CL.AddTypeS('TSeriesOnBeforeAdd', 'Function ( Sender : TChartSeries) : Boolean');
  CL.AddTypeS('TSeriesOnAfterAdd', 'Procedure ( Sender : TChartSeries; ValueIndex : Integer)');
  CL.AddTypeS('TSeriesOnClear', 'Procedure ( Sender : TChartSeries)');
  CL.AddTypeS('TSeriesOnGetMarkText', 'Procedure ( Sender : TChartSeries; ValueIndex : Integer; var MarkText : String)');
  CL.AddTypeS('TSeriesRecalcOptions', '( rOnDelete, rOnModify, rOnInsert, rOnClear )');
  CL.AddTypeS('TFunctionPeriodStyle', '( psNumPoints, psRange )');
  CL.AddTypeS('TFunctionPeriodAlign', '( paFirst, paCenter, paLast )');
  SIRegister_TTeeFunction(CL);
  SIRegister_TTeeMovingFunction(CL);
  SIRegister_TChartValueLists(CL);
  CL.AddTypeS('TChartSeriesStyles','(tssIsTemplate, tssDenyChangeType, tssDenyDelete,'+
   'tssDenyClone, tssIsPersistent, tssHideDataSource)');
  CL.AddTypeS('TChartSeriesStyle', 'set of TChartSeriesStyles');
  // +'tssDenyDelete, tssDenyClone, tssIsPersistent, tssHideDataSource )');
  SIRegister_TCustomChartSeries(CL);
  //CL.AddTypeS('TTeeFunctionClass', 'class of TTeeFunction');
  SIRegister_TTeeSeriesType(CL);
  CL.AddTypeS('TChartSubGalleryProc', 'Function ( const AName : String) : TCustomAxisPanel');
  CL.AddTypeS('TLegendTextStyle', '( ltsPlain, ltsLeftValue, ltsRightValue, lts'
   +'LeftPercent, ltsRightPercent, ltsXValue, ltsValue, ltsPercent, ltsXAndValue, ltsXAndPercent )');
  CL.AddTypeS('TeeFormatFlags', '( tfNoMandatory, tfColor, tfLabel, tfMarkPosition )');
  CL.AddTypeS('TeeFormatFlag', 'set of TeeFormatFlags');
  SIRegister_TLabelsList(CL);
  SIRegister_TDataSourcesList(CL);
  SIRegister_TChartSeries(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ChartException');
  CL.AddTypeS('TSourceLoadMode', '( lmClear, lmAppend )');
  SIRegister_TTeeSeriesSource(CL);
  //CL.AddTypeS('TTeeSeriesSourceClass', 'class of TTeeSeriesSource');
 //CL.AddDelphiFunction('Function TeeSources : TList');
 CL.AddDelphiFunction('Function SeriesNameOrIndex( ASeries : TCustomChartSeries) : String');
 CL.AddDelphiFunction('Function SeriesTitleOrName( ASeries : TCustomChartSeries) : String');
 CL.AddDelphiFunction('Procedure FillSeriesItems( AItems : TStrings; AList : TCustomSeriesList; UseTitles : Boolean)');
 CL.AddDelphiFunction('Procedure ShowMessageUser( const S : String)');
 CL.AddDelphiFunction('Function HasNoMandatoryValues( ASeries : TChartSeries) : Boolean');
 CL.AddDelphiFunction('Function HasLabels( ASeries : TChartSeries) : Boolean');
 CL.AddDelphiFunction('Function HasColors( ASeries : TChartSeries) : Boolean');
 CL.AddDelphiFunction('Function SeriesGuessContents( ASeries : TChartSeries) : TeeFormatFlag');
 CL.AddDelphiFunction('Procedure TeeDrawBitmapEditor( Canvas : TCanvas; Element : TCustomChartElement; Left, Top : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTeeSeriesSourceSeries_W(Self: TTeeSeriesSource; const T: TChartSeries);
begin Self.Series := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesSourceSeries_R(Self: TTeeSeriesSource; var T: TChartSeries);
begin T := Self.Series; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesSourceLoadMode_W(Self: TTeeSeriesSource; const T: TSourceLoadMode);
begin Self.LoadMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesSourceLoadMode_R(Self: TTeeSeriesSource; var T: TSourceLoadMode);
begin T := Self.LoadMode; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesSourceActive_W(Self: TTeeSeriesSource; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesSourceActive_R(Self: TTeeSeriesSource; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnMouseLeave_W(Self: TChartSeries; const T: TNotifyEvent);
begin Self.OnMouseLeave := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnMouseLeave_R(Self: TChartSeries; var T: TNotifyEvent);
begin T := Self.OnMouseLeave; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnMouseEnter_W(Self: TChartSeries; const T: TNotifyEvent);
begin Self.OnMouseEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnMouseEnter_R(Self: TChartSeries; var T: TNotifyEvent);
begin T := Self.OnMouseEnter; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnGetMarkText_W(Self: TChartSeries; const T: TSeriesOnGetMarkText);
begin Self.OnGetMarkText := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnGetMarkText_R(Self: TChartSeries; var T: TSeriesOnGetMarkText);
begin T := Self.OnGetMarkText; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnDblClick_W(Self: TChartSeries; const T: TSeriesClick);
begin Self.OnDblClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnDblClick_R(Self: TChartSeries; var T: TSeriesClick);
begin T := Self.OnDblClick; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnClick_W(Self: TChartSeries; const T: TSeriesClick);
begin Self.OnClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnClick_R(Self: TChartSeries; var T: TSeriesClick);
begin T := Self.OnClick; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnClearValues_W(Self: TChartSeries; const T: TSeriesOnClear);
begin Self.OnClearValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnClearValues_R(Self: TChartSeries; var T: TSeriesOnClear);
begin T := Self.OnClearValues; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnBeforeAdd_W(Self: TChartSeries; const T: TSeriesOnBeforeAdd);
begin Self.OnBeforeAdd := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnBeforeAdd_R(Self: TChartSeries; var T: TSeriesOnBeforeAdd);
begin T := Self.OnBeforeAdd; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnAfterAdd_W(Self: TChartSeries; const T: TSeriesOnAfterAdd);
begin Self.OnAfterAdd := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesOnAfterAdd_R(Self: TChartSeries; var T: TSeriesOnAfterAdd);
begin T := Self.OnAfterAdd; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesBeforeDrawValues_W(Self: TChartSeries; const T: TNotifyEvent);
begin Self.BeforeDrawValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesBeforeDrawValues_R(Self: TChartSeries; var T: TNotifyEvent);
begin T := Self.BeforeDrawValues; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesAfterDrawValues_W(Self: TChartSeries; const T: TNotifyEvent);
begin Self.AfterDrawValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesAfterDrawValues_R(Self: TChartSeries; var T: TNotifyEvent);
begin T := Self.AfterDrawValues; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesXLabelsSource_W(Self: TChartSeries; const T: String);
begin Self.XLabelsSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesXLabelsSource_R(Self: TChartSeries; var T: String);
begin T := Self.XLabelsSource; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesVertAxis_W(Self: TChartSeries; const T: TVertAxis);
begin Self.VertAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesVertAxis_R(Self: TChartSeries; var T: TVertAxis);
begin T := Self.VertAxis; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesValueFormat_W(Self: TChartSeries; const T: String);
begin Self.ValueFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesValueFormat_R(Self: TChartSeries; var T: String);
begin T := Self.ValueFormat; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesPercentFormat_W(Self: TChartSeries; const T: String);
begin Self.PercentFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesPercentFormat_R(Self: TChartSeries; var T: String);
begin T := Self.PercentFormat; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesDataSource_W(Self: TChartSeries; const T: TComponent);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesDataSource_R(Self: TChartSeries; var T: TComponent);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesMarks_W(Self: TChartSeries; const T: TSeriesMarks);
begin Self.Marks := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesMarks_R(Self: TChartSeries; var T: TSeriesMarks);
begin T := Self.Marks; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesHorizAxis_W(Self: TChartSeries; const T: THorizAxis);
begin Self.HorizAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesHorizAxis_R(Self: TChartSeries; var T: THorizAxis);
begin T := Self.HorizAxis; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesDepth_W(Self: TChartSeries; const T: Integer);
begin Self.Depth := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesDepth_R(Self: TChartSeries; var T: Integer);
begin T := Self.Depth; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesCursor_W(Self: TChartSeries; const T: TCursor);
begin Self.Cursor := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesCursor_R(Self: TChartSeries; var T: TCursor);
begin T := Self.Cursor; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesColorSource_W(Self: TChartSeries; const T: String);
begin Self.ColorSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesColorSource_R(Self: TChartSeries; var T: String);
begin T := Self.ColorSource; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesColorEachPoint_W(Self: TChartSeries; const T: Boolean);
begin Self.ColorEachPoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesColorEachPoint_R(Self: TChartSeries; var T: Boolean);
begin T := Self.ColorEachPoint; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesColor_W(Self: TChartSeries; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesColor_R(Self: TChartSeries; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesCustomVertAxis_W(Self: TChartSeries; const T: TChartAxis);
begin Self.CustomVertAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesCustomVertAxis_R(Self: TChartSeries; var T: TChartAxis);
begin T := Self.CustomVertAxis; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesCustomHorizAxis_W(Self: TChartSeries; const T: TChartAxis);
begin Self.CustomHorizAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesCustomHorizAxis_R(Self: TChartSeries; var T: TChartAxis);
begin T := Self.CustomHorizAxis; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesFunctionType_W(Self: TChartSeries; const T: TTeeFunction);
begin Self.FunctionType := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesFunctionType_R(Self: TChartSeries; var T: TTeeFunction);
begin T := Self.FunctionType; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesDataSources_R(Self: TChartSeries; var T: TDataSourcesList);
begin T := Self.DataSources; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesSeriesColor_W(Self: TChartSeries; const T: TColor);
begin Self.SeriesColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesSeriesColor_R(Self: TChartSeries; var T: TColor);
begin T := Self.SeriesColor; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesRecalcOptions_W(Self: TChartSeries; const T: TSeriesRecalcOptions);
begin Self.RecalcOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesRecalcOptions_R(Self: TChartSeries; var T: TSeriesRecalcOptions);
begin T := Self.RecalcOptions; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesLastValueIndex_R(Self: TChartSeries; var T: Integer);
begin T := Self.LastValueIndex; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesFirstValueIndex_R(Self: TChartSeries; var T: Integer);
begin T := Self.FirstValueIndex; end;

(*----------------------------------------------------------------------------*)
Function TChartSeriesClicked1_P(Self: TChartSeries;  const P : TPoint) : Integer;
Begin Result := Self.Clicked(P); END;

(*----------------------------------------------------------------------------*)
Function TChartSeriesClicked_P(Self: TChartSeries;  x, y : Integer) : Integer;
Begin Result := Self.Clicked(x, y); END;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesGetHorizAxis_R(Self: TChartSeries; var T: TChartAxis);
begin T := Self.GetHorizAxis; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesGetVertAxis_R(Self: TChartSeries; var T: TChartAxis);
begin T := Self.GetVertAxis; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesYValues_W(Self: TChartSeries; const T: TChartValueList);
begin Self.YValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesYValues_R(Self: TChartSeries; var T: TChartValueList);
begin T := Self.YValues; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesXValues_W(Self: TChartSeries; const T: TChartValueList);
begin Self.XValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesXValues_R(Self: TChartSeries; var T: TChartValueList);
begin T := Self.XValues; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesValueColor_W(Self: TChartSeries; const T: TColor; const t1: Integer);
begin Self.ValueColor[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesValueColor_R(Self: TChartSeries; var T: TColor; const t1: Integer);
begin T := Self.ValueColor[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesValueMarkText_W(Self: TChartSeries; const T: String; const t1: Integer);
begin Self.ValueMarkText[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesValueMarkText_R(Self: TChartSeries; var T: String; const t1: Integer);
begin T := Self.ValueMarkText[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesXLabel_W(Self: TChartSeries; const T: String; const t1: Integer);
begin Self.XLabel[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesXLabel_R(Self: TChartSeries; var T: String; const t1: Integer);
begin T := Self.XLabel[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesLabels_R(Self: TChartSeries; var T: TLabelsList);
begin T := Self.Labels; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesZOrder_W(Self: TChartSeries; const T: Integer);
begin Self.ZOrder := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesZOrder_R(Self: TChartSeries; var T: Integer);
begin T := Self.ZOrder; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesYValue_W(Self: TChartSeries; const T: TChartValue; const t1: Integer);
begin Self.YValue[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesYValue_R(Self: TChartSeries; var T: TChartValue; const t1: Integer);
begin T := Self.YValue[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesXValue_W(Self: TChartSeries; const T: TChartValue; const t1: Integer);
begin Self.XValue[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesXValue_R(Self: TChartSeries; var T: TChartValue; const t1: Integer);
begin T := Self.XValue[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesValuesList_R(Self: TChartSeries; var T: TChartValueLists);
begin T := Self.ValuesList; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesLinkedSeries_R(Self: TChartSeries; var T: TCustomSeriesList);
begin T := Self.LinkedSeries; end;

(*----------------------------------------------------------------------------*)
Procedure TChartSeriesDelete1_P(Self: TChartSeries;  Start, Quantity : Integer; RemoveGap : Boolean);
Begin Self.Delete(Start, Quantity, RemoveGap); END;

(*----------------------------------------------------------------------------*)
Procedure TChartSeriesDelete_P(Self: TChartSeries;  ValueIndex : Integer);
Begin Self.Delete(ValueIndex); END;

(*----------------------------------------------------------------------------*)
Function TChartSeriesAddNull1_P(Self: TChartSeries;  const ALabel : String) : Integer;
Begin Result := Self.AddNull(ALabel); END;

(*----------------------------------------------------------------------------*)
Function TChartSeriesAddNull_P(Self: TChartSeries;  const Value : Double) : Integer;
Begin Result := Self.AddNull(Value); END;

(*----------------------------------------------------------------------------*)
Function TChartSeriesAddArray_P(Self: TChartSeries;  const Values : array of TChartValue) : Integer;
Begin Result := Self.AddArray(Values); END;

(*----------------------------------------------------------------------------*)
Function TChartSeriesAdd_P(Self: TChartSeries;  const AValue : Double; const ALabel : String; AColor : TColor) : Integer;
Begin Result := Self.Add(AValue, ALabel, AColor); END;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesYMandatory_W(Self: TChartSeries; const T: Boolean);
Begin Self.YMandatory := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesYMandatory_R(Self: TChartSeries; var T: Boolean);
Begin T := Self.YMandatory; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesNotMandatoryValueList_W(Self: TChartSeries; const T: TChartValueList);
Begin Self.NotMandatoryValueList := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesNotMandatoryValueList_R(Self: TChartSeries; var T: TChartValueList);
Begin T := Self.NotMandatoryValueList; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesMandatoryValueList_W(Self: TChartSeries; const T: TChartValueList);
Begin Self.MandatoryValueList := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesMandatoryValueList_R(Self: TChartSeries; var T: TChartValueList);
Begin T := Self.MandatoryValueList; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesEndZ_W(Self: TChartSeries; const T: Integer);
Begin Self.EndZ := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesEndZ_R(Self: TChartSeries; var T: Integer);
Begin T := Self.EndZ; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesMiddleZ_W(Self: TChartSeries; const T: Integer);
Begin Self.MiddleZ := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesMiddleZ_R(Self: TChartSeries; var T: Integer);
Begin T := Self.MiddleZ; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesStartZ_W(Self: TChartSeries; const T: Integer);
Begin Self.StartZ := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesStartZ_R(Self: TChartSeries; var T: Integer);
Begin T := Self.StartZ; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesHasZValues_W(Self: TChartSeries; const T: Boolean);
Begin Self.HasZValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesHasZValues_R(Self: TChartSeries; var T: Boolean);
Begin T := Self.HasZValues; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesAllowSinglePoint_W(Self: TChartSeries; const T: Boolean);
Begin Self.AllowSinglePoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesAllowSinglePoint_R(Self: TChartSeries; var T: Boolean);
Begin T := Self.AllowSinglePoint; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesDrawBetweenPoints_W(Self: TChartSeries; const T: Boolean);
Begin Self.DrawBetweenPoints := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesDrawBetweenPoints_R(Self: TChartSeries; var T: Boolean);
Begin T := Self.DrawBetweenPoints; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesCalcVisiblePoints_W(Self: TChartSeries; const T: Boolean);
Begin Self.CalcVisiblePoints := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesCalcVisiblePoints_R(Self: TChartSeries; var T: Boolean);
Begin T := Self.CalcVisiblePoints; end;

(*----------------------------------------------------------------------------*)
procedure TLabelsListLabels_W(Self: TLabelsList; const T: String; const t1: Integer);
begin Self.Labels[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TLabelsListLabels_R(Self: TLabelsList; var T: String; const t1: Integer);
begin T := Self.Labels[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeSubIndex_W(Self: TTeeSeriesType; const T: Integer);
Begin Self.SubIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeSubIndex_R(Self: TTeeSeriesType; var T: Integer);
Begin T := Self.SubIndex; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeNumGallerySeries_W(Self: TTeeSeriesType; const T: Integer);
Begin Self.NumGallerySeries := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeNumGallerySeries_R(Self: TTeeSeriesType; var T: Integer);
Begin T := Self.NumGallerySeries; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeGalleryPage_W(Self: TTeeSeriesType; const T: PString);
Begin Self.GalleryPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeGalleryPage_R(Self: TTeeSeriesType; var T: PString);
Begin T := Self.GalleryPage; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeDescription_W(Self: TTeeSeriesType; const T: PString);
Begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeDescription_R(Self: TTeeSeriesType; var T: PString);
Begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeFunctionClass_W(Self: TTeeSeriesType; const T: TTeeFunctionClass);
Begin Self.FunctionClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeFunctionClass_R(Self: TTeeSeriesType; var T: TTeeFunctionClass);
Begin T := Self.FunctionClass; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeSeriesClass_W(Self: TTeeSeriesType; const T: TChartSeriesClass);
Begin Self.SeriesClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypeSeriesClass_R(Self: TTeeSeriesType; var T: TChartSeriesClass);
Begin T := Self.SeriesClass; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSeriesStyle_W(Self: TCustomChartSeries; const T: TChartSeriesStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSeriesStyle_R(Self: TCustomChartSeries; var T: TChartSeriesStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSeriesIdentifier_W(Self: TCustomChartSeries; const T: String);
begin Self.Identifier := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSeriesIdentifier_R(Self: TCustomChartSeries; var T: String);
begin T := Self.Identifier; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSeriesTitle_W(Self: TCustomChartSeries; const T: String);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSeriesTitle_R(Self: TCustomChartSeries; var T: String);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSeriesShowInLegend_W(Self: TCustomChartSeries; const T: Boolean);
begin Self.ShowInLegend := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSeriesShowInLegend_R(Self: TCustomChartSeries; var T: Boolean);
begin T := Self.ShowInLegend; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListsValueList_R(Self: TChartValueLists; var T: TChartValueList; const t1: Integer);
begin T := Self.ValueList[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFunctionPeriodStyle_W(Self: TTeeFunction; const T: TFunctionPeriodStyle);
begin Self.PeriodStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFunctionPeriodStyle_R(Self: TTeeFunction; var T: TFunctionPeriodStyle);
begin T := Self.PeriodStyle; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFunctionPeriodAlign_W(Self: TTeeFunction; const T: TFunctionPeriodAlign);
begin Self.PeriodAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFunctionPeriodAlign_R(Self: TTeeFunction; var T: TFunctionPeriodAlign);
begin T := Self.PeriodAlign; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFunctionPeriod_W(Self: TTeeFunction; const T: Double);
begin Self.Period := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFunctionPeriod_R(Self: TTeeFunction; var T: Double);
begin T := Self.Period; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFunctionParentSeries_W(Self: TTeeFunction; const T: TChartSeries);
begin Self.ParentSeries := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFunctionParentSeries_R(Self: TTeeFunction; var T: TChartSeries);
begin T := Self.ParentSeries; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksTextAlign_W(Self: TSeriesMarks; const T: TAlignment);
begin Self.TextAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksTextAlign_R(Self: TSeriesMarks; var T: TAlignment);
begin T := Self.TextAlign; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksSymbol_W(Self: TSeriesMarks; const T: TSeriesMarksSymbol);
begin Self.Symbol := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksSymbol_R(Self: TSeriesMarks; var T: TSeriesMarksSymbol);
begin T := Self.Symbol; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksStyle_W(Self: TSeriesMarks; const T: TSeriesMarksStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksStyle_R(Self: TSeriesMarks; var T: TSeriesMarksStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksMultiLine_W(Self: TSeriesMarks; const T: Boolean);
begin Self.MultiLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksMultiLine_R(Self: TSeriesMarks; var T: Boolean);
begin T := Self.MultiLine; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksMargins_W(Self: TSeriesMarks; const T: TMargins);
begin Self.Margins := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksMargins_R(Self: TSeriesMarks; var T: TMargins);
begin T := Self.Margins; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksDrawEvery_W(Self: TSeriesMarks; const T: Integer);
begin Self.DrawEvery := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksDrawEvery_R(Self: TSeriesMarks; var T: Integer);
begin T := Self.DrawEvery; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksClip_W(Self: TSeriesMarks; const T: Boolean);
begin Self.Clip := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksClip_R(Self: TSeriesMarks; var T: Boolean);
begin T := Self.Clip; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksBackColor_W(Self: TSeriesMarks; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksBackColor_R(Self: TSeriesMarks; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksCallout_W(Self: TSeriesMarks; const T: TMarksCallout);
begin Self.Callout := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksCallout_R(Self: TSeriesMarks; var T: TMarksCallout);
begin T := Self.Callout; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksArrowLength_W(Self: TSeriesMarks; const T: Integer);
begin Self.ArrowLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksArrowLength_R(Self: TSeriesMarks; var T: Integer);
begin T := Self.ArrowLength; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksArrow_W(Self: TSeriesMarks; const T: TChartArrowPen);
begin Self.Arrow := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksArrow_R(Self: TSeriesMarks; var T: TChartArrowPen);
begin T := Self.Arrow; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksAngle_W(Self: TSeriesMarks; const T: Integer);
begin Self.Angle := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksAngle_R(Self: TSeriesMarks; var T: Integer);
begin T := Self.Angle; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksZPosition_W(Self: TSeriesMarks; const T: Integer);
begin Self.ZPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksZPosition_R(Self: TSeriesMarks; var T: Integer);
begin T := Self.ZPosition; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksPositions_R(Self: TSeriesMarks; var T: TSeriesMarksPositions);
begin T := Self.Positions; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksParentSeries_R(Self: TSeriesMarks; var T: TChartSeries);
begin T := Self.ParentSeries; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksItems_R(Self: TSeriesMarks; var T: TMarksItems);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksItem_R(Self: TSeriesMarks; var T: TMarksItem; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsUnits_W(Self: TMarginsTe; const T: TMarginUnits);
begin Self.Units := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsUnits_R(Self: TMarginsTe; var T: TMarginUnits);
begin T := Self.Units; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsBottom_W(Self: TMarginsTe; const T: Integer);
begin Self.Bottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsBottom_R(Self: TMarginsTe; var T: Integer);
begin T := Self.Bottom; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsRight_W(Self: TMarginsTe; const T: Integer);
begin Self.Right := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsRight_R(Self: TMarginsTe; var T: Integer);
begin T := Self.Right; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsTop_W(Self: TMarginsTe; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsTop_R(Self: TMarginsTe; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsLeft_W(Self: TMarginsTe; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsLeft_R(Self: TMarginsTe; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsSize_R(Self: TMarginsTe; var T: TRect);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TMarksCalloutLength_W(Self: TMarksCallout; const T: Integer);
begin Self.Length := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarksCalloutLength_R(Self: TMarksCallout; var T: Integer);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
procedure TCalloutDistance_W(Self: TCallout; const T: Integer);
begin Self.Distance := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalloutDistance_R(Self: TCallout; var T: Integer);
begin T := Self.Distance; end;

(*----------------------------------------------------------------------------*)
procedure TCalloutArrowHeadSize_W(Self: TCallout; const T: Integer);
begin Self.ArrowHeadSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalloutArrowHeadSize_R(Self: TCallout; var T: Integer);
begin T := Self.ArrowHeadSize; end;

(*----------------------------------------------------------------------------*)
procedure TCalloutArrowHead_W(Self: TCallout; const T: TArrowHeadStyle);
begin Self.ArrowHead := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalloutArrowHead_R(Self: TCallout; var T: TArrowHeadStyle);
begin T := Self.ArrowHead; end;

(*----------------------------------------------------------------------------*)
procedure TCalloutArrow_W(Self: TCallout; const T: TChartArrowPen);
begin Self.Arrow := T; end;

(*----------------------------------------------------------------------------*)
procedure TCalloutArrow_R(Self: TCallout; var T: TChartArrowPen);
begin T := Self.Arrow; end;

(*----------------------------------------------------------------------------*)
Procedure TCalloutDraw3_P(Self: TCallout;  AColor : TColor; AFrom, AMid, ATo : TPoint; Z : Integer; MidPoint : Boolean);
Begin //Self.Draw(AColor, AFrom, AMid, ATo, Z, MidPoint);
 END;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerVertSize_W(Self: TSeriesPointer; const T: Integer);
begin Self.VertSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerVertSize_R(Self: TSeriesPointer; var T: Integer);
begin T := Self.VertSize; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerTransparency_W(Self: TSeriesPointer; const T: TTeeTransparency);
begin Self.Transparency := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerTransparency_R(Self: TSeriesPointer; var T: TTeeTransparency);
begin T := Self.Transparency; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerStyle_W(Self: TSeriesPointer; const T: TSeriesPointerStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerStyle_R(Self: TSeriesPointer; var T: TSeriesPointerStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerShadow_W(Self: TSeriesPointer; const T: TTeeShadow);
begin Self.Shadow := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerShadow_R(Self: TSeriesPointer; var T: TTeeShadow);
begin T := Self.Shadow; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerInflateMargins_W(Self: TSeriesPointer; const T: Boolean);
begin Self.InflateMargins := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerInflateMargins_R(Self: TSeriesPointer; var T: Boolean);
begin T := Self.InflateMargins; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerHorizSize_W(Self: TSeriesPointer; const T: Integer);
begin Self.HorizSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerHorizSize_R(Self: TSeriesPointer; var T: Integer);
begin T := Self.HorizSize; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerGradient_W(Self: TSeriesPointer; const T: TTeeGradient);
begin Self.Gradient := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerGradient_R(Self: TSeriesPointer; var T: TTeeGradient);
begin T := Self.Gradient; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerDraw3D_W(Self: TSeriesPointer; const T: Boolean);
begin Self.Draw3D := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerDraw3D_R(Self: TSeriesPointer; var T: Boolean);
begin T := Self.Draw3D; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerDark3D_W(Self: TSeriesPointer; const T: Boolean);
begin Self.Dark3D := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerDark3D_R(Self: TSeriesPointer; var T: Boolean);
begin T := Self.Dark3D; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerSize_W(Self: TSeriesPointer; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerSize_R(Self: TSeriesPointer; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerParentSeries_R(Self: TSeriesPointer; var T: TChartSeries);
begin T := Self.ParentSeries; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerColor_W(Self: TSeriesPointer; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesPointerColor_R(Self: TSeriesPointer; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
Procedure TSeriesPointerDraw2_P(Self: TSeriesPointer;  px, py : Integer; ColorValue : TColor; AStyle : TSeriesPointerStyle);
Begin Self.Draw(px, py, ColorValue, AStyle); END;

(*----------------------------------------------------------------------------*)
Procedure TSeriesPointerDraw1_P(Self: TSeriesPointer;  X, Y : Integer);
Begin Self.Draw(X, Y); END;

(*----------------------------------------------------------------------------*)
Procedure TSeriesPointerDraw_P(Self: TSeriesPointer;  P : TPoint);
Begin Self.Draw(P); END;

(*----------------------------------------------------------------------------*)
procedure TMarksItemsFormat_R(Self: TMarksItems; var T: TMarksItem; const t1: Integer);
begin T := Self.Format[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMarksItemText_W(Self: TMarksItem; const T: TStrings);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarksItemText_R(Self: TMarksItem; var T: TStrings);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksPositionsPosition_W(Self: TSeriesMarksPositions; const T: TSeriesMarkPosition; const t1: Integer);
begin Self.Position[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarksPositionsPosition_R(Self: TSeriesMarksPositions; var T: TSeriesMarkPosition; const t1: Integer);
begin T := Self.Position[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionHasMid_W(Self: TSeriesMarkPosition; const T: Boolean);
Begin Self.HasMid := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionHasMid_R(Self: TSeriesMarkPosition; var T: Boolean);
Begin T := Self.HasMid; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionMidPoint_W(Self: TSeriesMarkPosition; const T: TPoint);
Begin Self.MidPoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionMidPoint_R(Self: TSeriesMarkPosition; var T: TPoint);
Begin T := Self.MidPoint; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionWidth_W(Self: TSeriesMarkPosition; const T: Integer);
Begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionWidth_R(Self: TSeriesMarkPosition; var T: Integer);
Begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionLeftTop_W(Self: TSeriesMarkPosition; const T: TPoint);
Begin Self.LeftTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionLeftTop_R(Self: TSeriesMarkPosition; var T: TPoint);
Begin T := Self.LeftTop; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionHeight_W(Self: TSeriesMarkPosition; const T: Integer);
Begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionHeight_R(Self: TSeriesMarkPosition; var T: Integer);
Begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionCustom_W(Self: TSeriesMarkPosition; const T: Boolean);
Begin Self.Custom := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionCustom_R(Self: TSeriesMarkPosition; var T: Boolean);
Begin T := Self.Custom; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionArrowTo_W(Self: TSeriesMarkPosition; const T: TPoint);
Begin Self.ArrowTo := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionArrowTo_R(Self: TSeriesMarkPosition; var T: TPoint);
Begin T := Self.ArrowTo; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionArrowFix_W(Self: TSeriesMarkPosition; const T: Boolean);
Begin Self.ArrowFix := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionArrowFix_R(Self: TSeriesMarkPosition; var T: Boolean);
Begin T := Self.ArrowFix; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionArrowFrom_W(Self: TSeriesMarkPosition; const T: TPoint);
Begin Self.ArrowFrom := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesMarkPositionArrowFrom_R(Self: TSeriesMarkPosition; var T: TPoint);
Begin T := Self.ArrowFrom; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnRemoveSeries_W(Self: TCustomAxisPanel; const T: TSeriesNotifyEvent);
begin Self.OnRemoveSeries := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnRemoveSeries_R(Self: TCustomAxisPanel; var T: TSeriesNotifyEvent);
begin T := Self.OnRemoveSeries; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnPageChange_W(Self: TCustomAxisPanel; const T: TNotifyEvent);
begin Self.OnPageChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnPageChange_R(Self: TCustomAxisPanel; var T: TNotifyEvent);
begin T := Self.OnPageChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnGetNextAxisLabel_W(Self: TCustomAxisPanel; const T: TAxisOnGetNextLabel);
begin Self.OnGetNextAxisLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnGetNextAxisLabel_R(Self: TCustomAxisPanel; var T: TAxisOnGetNextLabel);
begin T := Self.OnGetNextAxisLabel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnGetAxisLabel_W(Self: TCustomAxisPanel; const T: TAxisOnGetLabel);
begin Self.OnGetAxisLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnGetAxisLabel_R(Self: TCustomAxisPanel; var T: TAxisOnGetLabel);
begin T := Self.OnGetAxisLabel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnBeforeDrawSeries_W(Self: TCustomAxisPanel; const T: TNotifyEvent);
begin Self.OnBeforeDrawSeries := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnBeforeDrawSeries_R(Self: TCustomAxisPanel; var T: TNotifyEvent);
begin T := Self.OnBeforeDrawSeries; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnBeforeDrawAxes_W(Self: TCustomAxisPanel; const T: TNotifyEvent);
begin Self.OnBeforeDrawAxes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnBeforeDrawAxes_R(Self: TCustomAxisPanel; var T: TNotifyEvent);
begin T := Self.OnBeforeDrawAxes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnBeforeDrawChart_W(Self: TCustomAxisPanel; const T: TNotifyEvent);
begin Self.OnBeforeDrawChart := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnBeforeDrawChart_R(Self: TCustomAxisPanel; var T: TNotifyEvent);
begin T := Self.OnBeforeDrawChart; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnAddSeries_W(Self: TCustomAxisPanel; const T: TSeriesNotifyEvent);
begin Self.OnAddSeries := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelOnAddSeries_R(Self: TCustomAxisPanel; var T: TSeriesNotifyEvent);
begin T := Self.OnAddSeries; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelView3DWalls_W(Self: TCustomAxisPanel; const T: Boolean);
begin Self.View3DWalls := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelView3DWalls_R(Self: TCustomAxisPanel; var T: Boolean);
begin T := Self.View3DWalls; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelTopAxis_W(Self: TCustomAxisPanel; const T: TChartAxis);
begin Self.TopAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelTopAxis_R(Self: TCustomAxisPanel; var T: TChartAxis);
begin T := Self.TopAxis; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelTools_R(Self: TCustomAxisPanel; var T: TChartTools);
begin T := Self.Tools; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelSeriesList_R(Self: TCustomAxisPanel; var T: TChartSeriesList);
begin T := Self.SeriesList; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelSeriesGroups_W(Self: TCustomAxisPanel; const T: TSeriesGroups);
begin Self.SeriesGroups := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelSeriesGroups_R(Self: TCustomAxisPanel; var T: TSeriesGroups);
begin T := Self.SeriesGroups; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelScaleLastPage_W(Self: TCustomAxisPanel; const T: Boolean);
begin Self.ScaleLastPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelScaleLastPage_R(Self: TCustomAxisPanel; var T: Boolean);
begin T := Self.ScaleLastPage; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelRightAxis_W(Self: TCustomAxisPanel; const T: TChartAxis);
begin Self.RightAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelRightAxis_R(Self: TCustomAxisPanel; var T: TChartAxis);
begin T := Self.RightAxis; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelPages_W(Self: TCustomAxisPanel; const T: TChartPage);
begin Self.Pages := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelPages_R(Self: TCustomAxisPanel; var T: TChartPage);
begin T := Self.Pages; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelPage_W(Self: TCustomAxisPanel; const T: Integer);
begin Self.Page := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelPage_R(Self: TCustomAxisPanel; var T: Integer);
begin T := Self.Page; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelMaxPointsPerPage_W(Self: TCustomAxisPanel; const T: Integer);
begin Self.MaxPointsPerPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelMaxPointsPerPage_R(Self: TCustomAxisPanel; var T: Integer);
begin T := Self.MaxPointsPerPage; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelLeftAxis_W(Self: TCustomAxisPanel; const T: TChartAxis);
begin Self.LeftAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelLeftAxis_R(Self: TCustomAxisPanel; var T: TChartAxis);
begin T := Self.LeftAxis; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelDepthTopAxis_W(Self: TCustomAxisPanel; const T: TChartDepthAxis);
begin Self.DepthTopAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelDepthTopAxis_R(Self: TCustomAxisPanel; var T: TChartDepthAxis);
begin T := Self.DepthTopAxis; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelDepthAxis_W(Self: TCustomAxisPanel; const T: TChartDepthAxis);
begin Self.DepthAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelDepthAxis_R(Self: TCustomAxisPanel; var T: TChartDepthAxis);
begin T := Self.DepthAxis; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelClipPoints_W(Self: TCustomAxisPanel; const T: Boolean);
begin Self.ClipPoints := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelClipPoints_R(Self: TCustomAxisPanel; var T: Boolean);
begin T := Self.ClipPoints; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelChart3DPercent_W(Self: TCustomAxisPanel; const T: Integer);
begin Self.Chart3DPercent := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelChart3DPercent_R(Self: TCustomAxisPanel; var T: Integer);
begin T := Self.Chart3DPercent; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelBottomAxis_W(Self: TCustomAxisPanel; const T: TChartAxis);
begin Self.BottomAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelBottomAxis_R(Self: TCustomAxisPanel; var T: TChartAxis);
begin T := Self.BottomAxis; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelAxisVisible_W(Self: TCustomAxisPanel; const T: Boolean);
begin Self.AxisVisible := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelAxisVisible_R(Self: TCustomAxisPanel; var T: Boolean);
begin T := Self.AxisVisible; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelAxisBehind_W(Self: TCustomAxisPanel; const T: Boolean);
begin Self.AxisBehind := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelAxisBehind_R(Self: TCustomAxisPanel; var T: Boolean);
begin T := Self.AxisBehind; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelSeriesHeight3D_R(Self: TCustomAxisPanel; var T: Integer);
begin T := Self.SeriesHeight3D; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelSeriesWidth3D_R(Self: TCustomAxisPanel; var T: Integer);
begin T := Self.SeriesWidth3D; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelMaxZOrder_W(Self: TCustomAxisPanel; const T: Integer);
begin Self.MaxZOrder := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelMaxZOrder_R(Self: TCustomAxisPanel; var T: Integer);
begin T := Self.MaxZOrder; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelCustomAxes_W(Self: TCustomAxisPanel; const T: TChartCustomAxes);
begin Self.CustomAxes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelCustomAxes_R(Self: TCustomAxisPanel; var T: TChartCustomAxes);
begin T := Self.CustomAxes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelAxesList_R(Self: TCustomAxisPanel; var T: TChartAxes);
begin T := Self.AxesList; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelAxes_R(Self: TCustomAxisPanel; var T: TChartAxes);
begin T := Self.Axes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelSeries_R(Self: TCustomAxisPanel; var T: TChartSeries; const t1: Integer);
begin T := Self.Series[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TCustomAxisPanelRemoveSeries1_P(Self: TCustomAxisPanel;  SeriesIndex : Integer);
Begin Self.RemoveSeries(SeriesIndex); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomAxisPanelRemoveSeries_P(Self: TCustomAxisPanel;  ASeries : TCustomChartSeries);
Begin Self.RemoveSeries(ASeries); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomAxisPanelExchangeSeries1_P(Self: TCustomAxisPanel;  a, b : TCustomChartSeries);
Begin Self.ExchangeSeries(a, b); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomAxisPanelExchangeSeries_P(Self: TCustomAxisPanel;  a, b : Integer);
Begin Self.ExchangeSeries(a, b); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomAxisPanelAddSeries2_P(Self: TCustomAxisPanel;  const SeriesArray : array of TChartSeries);
Begin Self.AddSeries(SeriesArray); END;

(*----------------------------------------------------------------------------*)
Function TCustomAxisPanelAddSeries1_P(Self: TCustomAxisPanel;  const ASeriesClass : TChartSeriesClass) : TChartSeries;
Begin Result := Self.AddSeries(ASeriesClass); END;

(*----------------------------------------------------------------------------*)
Function TCustomAxisPanelAddSeries_P(Self: TCustomAxisPanel;  const ASeries : TChartSeries) : TChartSeries;
Begin Result := Self.AddSeries(ASeries); END;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelColorPalette_W(Self: TCustomAxisPanel; const T: TColorArray);
Begin Self.ColorPalette := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelColorPalette_R(Self: TCustomAxisPanel; var T: TColorArray);
Begin T := Self.ColorPalette; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelDesigner_W(Self: TCustomAxisPanel; const T: TTeeCustomDesigner);
Begin Self.Designer := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomAxisPanelDesigner_R(Self: TCustomAxisPanel; var T: TTeeCustomDesigner);
Begin T := Self.Designer; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesEventSeries_W(Self: TTeeSeriesEvent; const T: TCustomChartSeries);
Begin Self.Series := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesEventSeries_R(Self: TTeeSeriesEvent; var T: TCustomChartSeries);
Begin T := Self.Series; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesEventEvent_W(Self: TTeeSeriesEvent; const T: TChartSeriesEvent);
Begin Self.Event := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesEventEvent_R(Self: TTeeSeriesEvent; var T: TChartSeriesEvent);
Begin T := Self.Event; end;

(*----------------------------------------------------------------------------*)
procedure TChartPageScaleLastPage_W(Self: TChartPage; const T: Boolean);
begin Self.ScaleLastPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartPageScaleLastPage_R(Self: TChartPage; var T: Boolean);
begin T := Self.ScaleLastPage; end;

(*----------------------------------------------------------------------------*)
procedure TChartPageMaxPointsPerPage_W(Self: TChartPage; const T: Integer);
begin Self.MaxPointsPerPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartPageMaxPointsPerPage_R(Self: TChartPage; var T: Integer);
begin T := Self.MaxPointsPerPage; end;

(*----------------------------------------------------------------------------*)
procedure TChartPageCurrent_W(Self: TChartPage; const T: Integer);
begin Self.Current := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartPageCurrent_R(Self: TChartPage; var T: Integer);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TChartPageAutoScale_W(Self: TChartPage; const T: Boolean);
begin Self.AutoScale := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartPageAutoScale_R(Self: TChartPage; var T: Boolean);
begin T := Self.AutoScale; end;

(*----------------------------------------------------------------------------*)
procedure TChartPageParent_R(Self: TChartPage; var T: TCustomAxisPanel);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomToolAxisAxis_W(Self: TTeeCustomToolAxis; const T: TChartAxis);
begin Self.Axis := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomToolAxisAxis_R(Self: TTeeCustomToolAxis; var T: TChartAxis);
begin T := Self.Axis; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomToolSeriesSeries_W(Self: TTeeCustomToolSeries; const T: TChartSeries);
begin Self.Series := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomToolSeriesSeries_R(Self: TTeeCustomToolSeries; var T: TChartSeries);
begin T := Self.Series; end;

(*----------------------------------------------------------------------------*)
procedure TChartToolsOwner_R(Self: TChartTools; var T: TCustomAxisPanel);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TChartToolsItems_R(Self: TChartTools; var T: TTeeCustomTool; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TChartToolsActive_W(Self: TChartTools; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
Function TChartToolsAdd2_P(Self: TChartTools;  Tool : TTeeCustomTool) : TTeeCustomTool;
Begin Result := Self.Add(Tool); END;

(*----------------------------------------------------------------------------*)
procedure TChartCustomAxesItems_W(Self: TChartCustomAxes; const T: TChartAxis; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartCustomAxesItems_R(Self: TChartCustomAxes; var T: TChartAxis; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesVisible_W(Self: TChartAxes; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesVisible_R(Self: TChartAxes; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesFastCalc_W(Self: TChartAxes; const T: Boolean);
begin Self.FastCalc := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesFastCalc_R(Self: TChartAxes; var T: Boolean);
begin T := Self.FastCalc; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesBehind_W(Self: TChartAxes; const T: Boolean);
begin Self.Behind := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesBehind_R(Self: TChartAxes; var T: Boolean);
begin T := Self.Behind; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesTop_R(Self: TChartAxes; var T: TChartAxis);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesRight_R(Self: TChartAxes; var T: TChartAxis);
begin T := Self.Right; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesLeft_R(Self: TChartAxes; var T: TChartAxis);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesDepthTop_R(Self: TChartAxes; var T: TChartDepthAxis);
begin T := Self.DepthTop; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesDepth_R(Self: TChartAxes; var T: TChartDepthAxis);
begin T := Self.Depth; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesBottom_R(Self: TChartAxes; var T: TChartAxis);
begin T := Self.Bottom; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxesItems_R(Self: TChartAxes; var T: TChartAxis; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesGroupsItems_W(Self: TSeriesGroups; const T: TSeriesGroup; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesGroupsItems_R(Self: TSeriesGroups; var T: TSeriesGroup; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesGroupSeries_W(Self: TSeriesGroup; const T: TCustomSeriesList);
begin Self.Series := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesGroupSeries_R(Self: TSeriesGroup; var T: TCustomSeriesList);
begin T := Self.Series; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesGroupName_W(Self: TSeriesGroup; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesGroupName_R(Self: TSeriesGroup; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesGroupActive_W(Self: TSeriesGroup; const T: TSeriesGroupActive);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesGroupActive_R(Self: TSeriesGroup; var T: TSeriesGroupActive);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesListGroups_W(Self: TChartSeriesList; const T: TSeriesGroups);
begin Self.Groups := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesListGroups_R(Self: TChartSeriesList; var T: TSeriesGroups);
begin T := Self.Groups; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesListAllActive_W(Self: TChartSeriesList; const T: Boolean);
begin Self.AllActive := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartSeriesListAllActive_R(Self: TChartSeriesList; var T: Boolean);
begin T := Self.AllActive; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSeriesListOwner_R(Self: TCustomSeriesList; var T: TCustomAxisPanel);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSeriesListItems_W(Self: TCustomSeriesList; const T: TChartSeries; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSeriesListItems_R(Self: TCustomSeriesList; var T: TChartSeries; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSeriesEnumeratorCurrent_R(Self: TSeriesEnumerator; var T: TChartSeries);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisOnDrawLabel_W(Self: TChartAxis; const T: TAxisDrawLabelEvent);
begin Self.OnDrawLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisOnDrawLabel_R(Self: TChartAxis; var T: TAxisDrawLabelEvent);
begin T := Self.OnDrawLabel; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisZPosition_W(Self: TChartAxis; const T: Double);
begin Self.ZPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisZPosition_R(Self: TChartAxis; var T: Double);
begin T := Self.ZPosition; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisVisible_W(Self: TChartAxis; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisVisible_R(Self: TChartAxis; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTitleSize_W(Self: TChartAxis; const T: Integer);
begin Self.TitleSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTitleSize_R(Self: TChartAxis; var T: Integer);
begin T := Self.TitleSize; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTitle_W(Self: TChartAxis; const T: TChartAxisTitle);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTitle_R(Self: TChartAxis; var T: TChartAxisTitle);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTickOnLabelsOnly_W(Self: TChartAxis; const T: Boolean);
begin Self.TickOnLabelsOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTickOnLabelsOnly_R(Self: TChartAxis; var T: Boolean);
begin T := Self.TickOnLabelsOnly; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTicksInner_W(Self: TChartAxis; const T: TDarkGrayPen);
begin Self.TicksInner := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTicksInner_R(Self: TChartAxis; var T: TDarkGrayPen);
begin T := Self.TicksInner; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTicks_W(Self: TChartAxis; const T: TDarkGrayPen);
begin Self.Ticks := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTicks_R(Self: TChartAxis; var T: TDarkGrayPen);
begin T := Self.Ticks; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTickLength_W(Self: TChartAxis; const T: Integer);
begin Self.TickLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTickLength_R(Self: TChartAxis; var T: Integer);
begin T := Self.TickLength; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTickInnerLength_W(Self: TChartAxis; const T: Integer);
begin Self.TickInnerLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTickInnerLength_R(Self: TChartAxis; var T: Integer);
begin T := Self.TickInnerLength; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisRoundFirstLabel_W(Self: TChartAxis; const T: Boolean);
begin Self.RoundFirstLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisRoundFirstLabel_R(Self: TChartAxis; var T: Boolean);
begin T := Self.RoundFirstLabel; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisPositionUnits_W(Self: TChartAxis; const T: TTeeUnits);
begin Self.PositionUnits := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisPositionUnits_R(Self: TChartAxis; var T: TTeeUnits);
begin T := Self.PositionUnits; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisPositionPercent_W(Self: TChartAxis; const T: Double);
begin Self.PositionPercent := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisPositionPercent_R(Self: TChartAxis; var T: Double);
begin T := Self.PositionPercent; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisEndPosition_W(Self: TChartAxis; const T: Double);
begin Self.EndPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisEndPosition_R(Self: TChartAxis; var T: Double);
begin T := Self.EndPosition; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisStartPosition_W(Self: TChartAxis; const T: Double);
begin Self.StartPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisStartPosition_R(Self: TChartAxis; var T: Double);
begin T := Self.StartPosition; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinorTicks_W(Self: TChartAxis; const T: TDarkGrayPen);
begin Self.MinorTicks := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinorTicks_R(Self: TChartAxis; var T: TDarkGrayPen);
begin T := Self.MinorTicks; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinorTickLength_W(Self: TChartAxis; const T: Integer);
begin Self.MinorTickLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinorTickLength_R(Self: TChartAxis; var T: Integer);
begin T := Self.MinorTickLength; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinorTickCount_W(Self: TChartAxis; const T: Integer);
begin Self.MinorTickCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinorTickCount_R(Self: TChartAxis; var T: Integer);
begin T := Self.MinorTickCount; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinorGrid_W(Self: TChartAxis; const T: TChartHiddenPen);
begin Self.MinorGrid := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinorGrid_R(Self: TChartAxis; var T: TChartHiddenPen);
begin T := Self.MinorGrid; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinimumRound_W(Self: TChartAxis; const T: Boolean);
begin Self.MinimumRound := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinimumRound_R(Self: TChartAxis; var T: Boolean);
begin T := Self.MinimumRound; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinimumOffset_W(Self: TChartAxis; const T: Integer);
begin Self.MinimumOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinimumOffset_R(Self: TChartAxis; var T: Integer);
begin T := Self.MinimumOffset; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinimum_W(Self: TChartAxis; const T: Double);
begin Self.Minimum := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMinimum_R(Self: TChartAxis; var T: Double);
begin T := Self.Minimum; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMaximumRound_W(Self: TChartAxis; const T: Boolean);
begin Self.MaximumRound := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMaximumRound_R(Self: TChartAxis; var T: Boolean);
begin T := Self.MaximumRound; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMaximumOffset_W(Self: TChartAxis; const T: Integer);
begin Self.MaximumOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMaximumOffset_R(Self: TChartAxis; var T: Integer);
begin T := Self.MaximumOffset; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMaximum_W(Self: TChartAxis; const T: Double);
begin Self.Maximum := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMaximum_R(Self: TChartAxis; var T: Double);
begin T := Self.Maximum; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLogarithmicBase_W(Self: TChartAxis; const T: Double);
begin Self.LogarithmicBase := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLogarithmicBase_R(Self: TChartAxis; var T: Double);
begin T := Self.LogarithmicBase; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLogarithmic_W(Self: TChartAxis; const T: Boolean);
begin Self.Logarithmic := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLogarithmic_R(Self: TChartAxis; var T: Boolean);
begin T := Self.Logarithmic; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelStyle_W(Self: TChartAxis; const T: TAxisLabelStyle);
begin Self.LabelStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelStyle_R(Self: TChartAxis; var T: TAxisLabelStyle);
begin T := Self.LabelStyle; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsSize_W(Self: TChartAxis; const T: Integer);
begin Self.LabelsSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsSize_R(Self: TChartAxis; var T: Integer);
begin T := Self.LabelsSize; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsSeparation_W(Self: TChartAxis; const T: Integer);
begin Self.LabelsSeparation := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsSeparation_R(Self: TChartAxis; var T: Integer);
begin T := Self.LabelsSeparation; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsOnAxis_W(Self: TChartAxis; const T: Boolean);
begin Self.LabelsOnAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsOnAxis_R(Self: TChartAxis; var T: Boolean);
begin T := Self.LabelsOnAxis; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsMultiLine_W(Self: TChartAxis; const T: Boolean);
begin Self.LabelsMultiLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsMultiLine_R(Self: TChartAxis; var T: Boolean);
begin T := Self.LabelsMultiLine; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsFont_W(Self: TChartAxis; const T: TTeeFont);
begin Self.LabelsFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsFont_R(Self: TChartAxis; var T: TTeeFont);
begin T := Self.LabelsFont; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsExponent_W(Self: TChartAxis; const T: Boolean);
begin Self.LabelsExponent := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsExponent_R(Self: TChartAxis; var T: Boolean);
begin T := Self.LabelsExponent; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsAngle_W(Self: TChartAxis; const T: Integer);
begin Self.LabelsAngle := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsAngle_R(Self: TChartAxis; var T: Integer);
begin T := Self.LabelsAngle; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsAlternate_W(Self: TChartAxis; const T: Boolean);
begin Self.LabelsAlternate := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsAlternate_R(Self: TChartAxis; var T: Boolean);
begin T := Self.LabelsAlternate; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsAlign_W(Self: TChartAxis; const T: TAxisLabelAlign);
begin Self.LabelsAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabelsAlign_R(Self: TChartAxis; var T: TAxisLabelAlign);
begin T := Self.LabelsAlign; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabels_W(Self: TChartAxis; const T: Boolean);
begin Self.Labels := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisLabels_R(Self: TChartAxis; var T: Boolean);
begin T := Self.Labels; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisOtherSide_W(Self: TChartAxis; const T: Boolean);
begin Self.OtherSide := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisOtherSide_R(Self: TChartAxis; var T: Boolean);
begin T := Self.OtherSide; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisHorizontal_W(Self: TChartAxis; const T: Boolean);
begin Self.Horizontal := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisHorizontal_R(Self: TChartAxis; var T: Boolean);
begin T := Self.Horizontal; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisInverted_W(Self: TChartAxis; const T: Boolean);
begin Self.Inverted := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisInverted_R(Self: TChartAxis; var T: Boolean);
begin T := Self.Inverted; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisIncrement_W(Self: TChartAxis; const T: Double);
begin Self.Increment := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisIncrement_R(Self: TChartAxis; var T: Double);
begin T := Self.Increment; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisGridCentered_W(Self: TChartAxis; const T: Boolean);
begin Self.GridCentered := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisGridCentered_R(Self: TChartAxis; var T: Boolean);
begin T := Self.GridCentered; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisGrid_W(Self: TChartAxis; const T: TAxisGridPen);
begin Self.Grid := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisGrid_R(Self: TChartAxis; var T: TAxisGridPen);
begin T := Self.Grid; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisExactDateTime_W(Self: TChartAxis; const T: Boolean);
begin Self.ExactDateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisExactDateTime_R(Self: TChartAxis; var T: Boolean);
begin T := Self.ExactDateTime; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisDateTimeFormat_W(Self: TChartAxis; const T: String);
begin Self.DateTimeFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisDateTimeFormat_R(Self: TChartAxis; var T: String);
begin T := Self.DateTimeFormat; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisAxisValuesFormat_W(Self: TChartAxis; const T: String);
begin Self.AxisValuesFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisAxisValuesFormat_R(Self: TChartAxis; var T: String);
begin T := Self.AxisValuesFormat; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisAxis_W(Self: TChartAxis; const T: TChartAxisPen);
begin Self.Axis := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisAxis_R(Self: TChartAxis; var T: TChartAxisPen);
begin T := Self.Axis; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisAutomaticMinimum_W(Self: TChartAxis; const T: Boolean);
begin Self.AutomaticMinimum := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisAutomaticMinimum_R(Self: TChartAxis; var T: Boolean);
begin T := Self.AutomaticMinimum; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisAutomaticMaximum_W(Self: TChartAxis; const T: Boolean);
begin Self.AutomaticMaximum := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisAutomaticMaximum_R(Self: TChartAxis; var T: Boolean);
begin T := Self.AutomaticMaximum; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisAutomatic_W(Self: TChartAxis; const T: Boolean);
begin Self.Automatic := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisAutomatic_R(Self: TChartAxis; var T: Boolean);
begin T := Self.Automatic; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisParentChart_R(Self: TChartAxis; var T: TCustomAxisPanel);
begin T := Self.ParentChart; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisPosTitle_R(Self: TChartAxis; var T: Integer);
begin T := Self.PosTitle; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisPosLabels_R(Self: TChartAxis; var T: Integer);
begin T := Self.PosLabels; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisPosAxis_R(Self: TChartAxis; var T: Integer);
begin T := Self.PosAxis; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMasterAxis_W(Self: TChartAxis; const T: TChartAxis);
begin Self.MasterAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisMasterAxis_R(Self: TChartAxis; var T: TChartAxis);
begin T := Self.MasterAxis; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisItems_R(Self: TChartAxis; var T: TAxisItems);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisIsDepthAxis_R(Self: TChartAxis; var T: Boolean);
begin T := Self.IsDepthAxis; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTick_W(Self: TChartAxis; const T: TAxisTicks);
Begin Self.Tick := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTick_R(Self: TChartAxis; var T: TAxisTicks);
Begin T := Self.Tick; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisCalcPosValue_W(Self: TChartAxis; const T: TAxisCalcPos);
Begin Self.CalcPosValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisCalcPosValue_R(Self: TChartAxis; var T: TAxisCalcPos);
Begin T := Self.CalcPosValue; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisCalcYPosValue_W(Self: TChartAxis; const T: TAxisCalcPos);
Begin Self.CalcYPosValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisCalcYPosValue_R(Self: TChartAxis; var T: TAxisCalcPos);
Begin T := Self.CalcYPosValue; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisCalcXPosValue_W(Self: TChartAxis; const T: TAxisCalcPos);
Begin Self.CalcXPosValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisCalcXPosValue_R(Self: TChartAxis; var T: TAxisCalcPos);
Begin T := Self.CalcXPosValue; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisIAxisSize_W(Self: TChartAxis; const T: Integer);
Begin Self.IAxisSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisIAxisSize_R(Self: TChartAxis; var T: Integer);
Begin T := Self.IAxisSize; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisIEndPos_W(Self: TChartAxis; const T: Integer);
Begin Self.IEndPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisIEndPos_R(Self: TChartAxis; var T: Integer);
Begin T := Self.IEndPos; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisIStartPos_W(Self: TChartAxis; const T: Integer);
Begin Self.IStartPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisIStartPos_R(Self: TChartAxis; var T: Integer);
Begin T := Self.IStartPos; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisPenLineMode_W(Self: TChartAxisPen; const T: TPenLineMode);
begin Self.LineMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisPenLineMode_R(Self: TChartAxisPen; var T: TPenLineMode);
begin T := Self.LineMode; end;

(*----------------------------------------------------------------------------*)
procedure TAxisItemsItem_R(Self: TAxisItems; var T: TAxisItem; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TAxisItemsFormat_R(Self: TAxisItems; var T: TTeeShape);
begin T := Self.Format; end;

(*----------------------------------------------------------------------------*)
procedure TAxisItemsAutomatic_W(Self: TAxisItems; const T: Boolean);
begin Self.Automatic := T; end;

(*----------------------------------------------------------------------------*)
procedure TAxisItemsAutomatic_R(Self: TAxisItems; var T: Boolean);
begin T := Self.Automatic; end;

(*----------------------------------------------------------------------------*)
Function TAxisItemsAdd1_P(Self: TAxisItems;  const Value : Double; const Text : String) : TAxisItem;
Begin Result := Self.Add(Value, Text); END;

(*----------------------------------------------------------------------------*)
Function TAxisItemsAdd_P(Self: TAxisItems;  const Value : Double) : TAxisItem;
Begin Result := Self.Add(Value); END;

(*----------------------------------------------------------------------------*)
procedure TAxisItemValue_W(Self: TAxisItem; const T: Double);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TAxisItemValue_R(Self: TAxisItem; var T: Double);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TAxisItemText_W(Self: TAxisItem; const T: String);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TAxisItemText_R(Self: TAxisItem; var T: String);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TAxisGridPenZPosition_W(Self: TAxisGridPen; const T: Double);
begin Self.ZPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TAxisGridPenZPosition_R(Self: TAxisGridPen; var T: Double);
begin T := Self.ZPosition; end;

(*----------------------------------------------------------------------------*)
procedure TAxisGridPenDrawEvery_W(Self: TAxisGridPen; const T: Integer);
begin Self.DrawEvery := T; end;

(*----------------------------------------------------------------------------*)
procedure TAxisGridPenDrawEvery_R(Self: TAxisGridPen; var T: Integer);
begin T := Self.DrawEvery; end;

(*----------------------------------------------------------------------------*)
procedure TAxisGridPenCentered_W(Self: TAxisGridPen; const T: Boolean);
begin Self.Centered := T; end;

(*----------------------------------------------------------------------------*)
procedure TAxisGridPenCentered_R(Self: TAxisGridPen; var T: Boolean);
begin T := Self.Centered; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTitleCaption_W(Self: TChartAxisTitle; const T: String);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTitleCaption_R(Self: TChartAxisTitle; var T: String);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTitleAngle_W(Self: TChartAxisTitle; const T: Integer);
begin Self.Angle := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartAxisTitleAngle_R(Self: TChartAxisTitle; var T: Integer);
begin T := Self.Angle; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListValueSource_W(Self: TChartValueList; const T: String);
begin Self.ValueSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListValueSource_R(Self: TChartValueList; var T: String);
begin T := Self.ValueSource; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListOrder_W(Self: TChartValueList; const T: TChartListOrder);
begin Self.Order := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListOrder_R(Self: TChartValueList; var T: TChartListOrder);
begin T := Self.Order; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListMultiplier_W(Self: TChartValueList; const T: Double);
begin //Self.Multiplier := T;
end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListMultiplier_R(Self: TChartValueList; var T: Double);
begin //T := Self.Multiplier;
end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListName_W(Self: TChartValueList; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListName_R(Self: TChartValueList; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListDateTime_W(Self: TChartValueList; const T: Boolean);
begin Self.DateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListDateTime_R(Self: TChartValueList; var T: Boolean);
begin T := Self.DateTime; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListValue_W(Self: TChartValueList; const T: TChartValue; const t1: Integer);
begin Self.Value[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListValue_R(Self: TChartValueList; var T: TChartValue; const t1: Integer);
begin T := Self.Value[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListItems_W(Self: TChartValueList; const T: TChartValue; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListItems_R(Self: TChartValueList; var T: TChartValue; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListTotalABS_W(Self: TChartValueList; const T: Double);
begin Self.TotalABS := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListTotalABS_R(Self: TChartValueList; var T: Double);
begin T := Self.TotalABS; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListTotal_R(Self: TChartValueList; var T: Double);
begin T := Self.Total; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListTempValue_W(Self: TChartValueList; const T: TChartValue);
begin Self.TempValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListTempValue_R(Self: TChartValueList; var T: TChartValue);
begin T := Self.TempValue; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListOwner_R(Self: TChartValueList; var T: TChartSeries);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListModified_W(Self: TChartValueList; const T: Boolean);
begin Self.Modified := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListModified_R(Self: TChartValueList; var T: Boolean);
begin T := Self.Modified; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListMinValue_R(Self: TChartValueList; var T: TChartValue);
begin T := Self.MinValue; end;

(*----------------------------------------------------------------------------*)
procedure TChartValueListMaxValue_R(Self: TChartValueList; var T: TChartValue);
begin T := Self.MaxValue; end;

(*----------------------------------------------------------------------------*)
Function TChartValueListLocate1_P(Self: TChartValueList;  const AValue : TChartValue; FirstIndex, LastIndex : Integer) : Integer;
Begin Result := Self.Locate(AValue, FirstIndex, LastIndex); END;

(*----------------------------------------------------------------------------*)
Function TChartValueListLocate_P(Self: TChartValueList;  const AValue : TChartValue) : Integer;
Begin Result := Self.Locate(AValue); END;

(*----------------------------------------------------------------------------*)
Procedure TChartValueListDelete1_P(Self: TChartValueList;  Start, Quantity : Integer);
Begin Self.Delete(Start, Quantity); END;

(*----------------------------------------------------------------------------*)
Procedure TChartValueListDelete_P(Self: TChartValueList;  ValueIndex : Integer);
Begin Self.Delete(ValueIndex); END;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
Procedure TChartValueListRecalcStats1_P(Self: TChartValueList;  StartIndex : Integer);
Begin //Self.RecalcStats(StartIndex);
 END;

(*----------------------------------------------------------------------------*)
Procedure TChartValueListRecalcStats_P(Self: TChartValueList);
Begin //Self.RecalcStats;
 END;

(*----------------------------------------------------------------------------*)
Function TChartValueListAddChartValue1_P(Self: TChartValueList;  const AValue : TChartValue) : Integer;
Begin //Result := Self.AddChartValue(AValue);
END;

(*----------------------------------------------------------------------------*)
Function TChartValueListAddChartValue_P(Self: TChartValueList) : Integer;
Begin //Result := Self.AddChartValue;
END;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementShowInEditor_W(Self: TCustomChartElement; const T: Boolean);
begin Self.ShowInEditor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementShowInEditor_R(Self: TCustomChartElement; var T: Boolean);
begin T := Self.ShowInEditor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementVisible_W(Self: TCustomChartElement; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementVisible_R(Self: TCustomChartElement; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementPen_W(Self: TCustomChartElement; const T: TChartPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementPen_R(Self: TCustomChartElement; var T: TChartPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementParentChart_W(Self: TCustomChartElement; const T: TCustomAxisPanel);
begin Self.ParentChart := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementParentChart_R(Self: TCustomChartElement; var T: TCustomAxisPanel);
begin T := Self.ParentChart; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementBrush_W(Self: TCustomChartElement; const T: TChartBrush);
begin Self.Brush := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementBrush_R(Self: TCustomChartElement; var T: TChartBrush);
begin T := Self.Brush; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementActive_W(Self: TCustomChartElement; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartElementActive_R(Self: TCustomChartElement; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TeEngine_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TeeSources, 'TeeSources', cdRegister);
 S.RegisterDelphiFunction(@SeriesNameOrIndex, 'SeriesNameOrIndex', cdRegister);
 S.RegisterDelphiFunction(@SeriesTitleOrName, 'SeriesTitleOrName', cdRegister);
 S.RegisterDelphiFunction(@FillSeriesItems, 'FillSeriesItems', cdRegister);
 S.RegisterDelphiFunction(@ShowMessageUser, 'ShowMessageUser', cdRegister);
 S.RegisterDelphiFunction(@HasNoMandatoryValues, 'HasNoMandatoryValues', cdRegister);
 S.RegisterDelphiFunction(@HasLabels, 'HasLabels', cdRegister);
 S.RegisterDelphiFunction(@HasColors, 'HasColors', cdRegister);
 S.RegisterDelphiFunction(@SeriesGuessContents, 'SeriesGuessContents', cdRegister);
 S.RegisterDelphiFunction(@TeeDrawBitmapEditor, 'TeeDrawBitmapEditor', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeSeriesSource(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeSeriesSource) do begin
    RegisterConstructor(@TTeeSeriesSource.Create, 'Create');
     RegisterMethod(@TTeeSeriesSource.Destroy, 'Free');
    RegisterVirtualMethod(@TTeeSeriesSource.Available, 'Available');
    RegisterVirtualMethod(@TTeeSeriesSource.Description, 'Description');
    RegisterVirtualMethod(@TTeeSeriesSource.Editor, 'Editor');
    RegisterVirtualMethod(@TTeeSeriesSource.HasNew, 'HasNew');
    RegisterVirtualMethod(@TTeeSeriesSource.HasSeries, 'HasSeries');
    RegisterVirtualMethod(@TTeeSeriesSource.Close, 'Close');
    RegisterVirtualMethod(@TTeeSeriesSource.Load, 'Load');
    RegisterVirtualMethod(@TTeeSeriesSource.Open, 'Open');
    RegisterMethod(@TTeeSeriesSource.Refresh, 'Refresh');
    RegisterPropertyHelper(@TTeeSeriesSourceActive_R,@TTeeSeriesSourceActive_W,'Active');
    RegisterPropertyHelper(@TTeeSeriesSourceLoadMode_R,@TTeeSeriesSourceLoadMode_W,'LoadMode');
    RegisterPropertyHelper(@TTeeSeriesSourceSeries_R,@TTeeSeriesSourceSeries_W,'Series');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartSeries(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartSeries) do begin
    //RegisterVirtualMethod(@TChartSeries.RaiseClicked, 'RaiseClicked');
    RegisterPropertyHelper(@TChartSeriesCalcVisiblePoints_R,@TChartSeriesCalcVisiblePoints_W,'CalcVisiblePoints');
    RegisterPropertyHelper(@TChartSeriesDrawBetweenPoints_R,@TChartSeriesDrawBetweenPoints_W,'DrawBetweenPoints');
    RegisterPropertyHelper(@TChartSeriesAllowSinglePoint_R,@TChartSeriesAllowSinglePoint_W,'AllowSinglePoint');
    RegisterPropertyHelper(@TChartSeriesHasZValues_R,@TChartSeriesHasZValues_W,'HasZValues');
    RegisterPropertyHelper(@TChartSeriesStartZ_R,@TChartSeriesStartZ_W,'StartZ');
    RegisterPropertyHelper(@TChartSeriesMiddleZ_R,@TChartSeriesMiddleZ_W,'MiddleZ');
    RegisterPropertyHelper(@TChartSeriesEndZ_R,@TChartSeriesEndZ_W,'EndZ');
    RegisterPropertyHelper(@TChartSeriesMandatoryValueList_R,@TChartSeriesMandatoryValueList_W,'MandatoryValueList');
    RegisterPropertyHelper(@TChartSeriesNotMandatoryValueList_R,@TChartSeriesNotMandatoryValueList_W,'NotMandatoryValueList');
    RegisterPropertyHelper(@TChartSeriesYMandatory_R,@TChartSeriesYMandatory_W,'YMandatory');
    RegisterConstructor(@TChartSeries.Create, 'Create');
    RegisterMethod(@TChartSeries.Destroy, 'Free');
    //RegisterVirtualMethod(@TChartSeriesAdd_P, 'Add');
    RegisterMethod(@TChartSeries.Add, 'Add');
    RegisterMethod(@TChartSeriesAddArray_P, 'AddArray');
    RegisterMethod(@TChartSeriesAddNull_P, 'AddNull');
    RegisterVirtualMethod(@TChartSeriesAddNull1_P, 'AddNull1');
    RegisterVirtualMethod(@TChartSeries.AddNullXY, 'AddNullXY');
    RegisterMethod(@TChartSeries.AddX, 'AddX');
    RegisterVirtualMethod(@TChartSeries.AddXY, 'AddXY');
    RegisterMethod(@TChartSeries.AddY, 'AddY');
    RegisterMethod(@TChartSeries.Assign, 'Assign');
    RegisterMethod(@TChartSeries.AssignFormat, 'AssignFormat');
    RegisterVirtualMethod(@TChartSeries.AssociatedToAxis, 'AssociatedToAxis');
    RegisterMethod(@TChartSeries.BeginUpdate, 'BeginUpdate');
    RegisterVirtualMethod(@TChartSeries.CheckOrder, 'CheckOrder');
    RegisterVirtualMethod(@TChartSeries.Clear, 'Clear');
    RegisterMethod(@TChartSeries.Count, 'Count');
    RegisterVirtualMethod(@TChartSeries.CountLegendItems, 'CountLegendItems');
    RegisterVirtualMethod(@TChartSeriesDelete_P, 'Delete');
    RegisterVirtualMethod(@TChartSeriesDelete1_P, 'Delete1');
    RegisterMethod(@TChartSeries.EndUpdate, 'EndUpdate');
    RegisterVirtualMethod(@TChartSeries.FillSampleValues, 'FillSampleValues');
    RegisterMethod(@TChartSeries.FirstDisplayedIndex, 'FirstDisplayedIndex');
    RegisterMethod(@TChartSeries.IsNull, 'IsNull');
    RegisterVirtualMethod(@TChartSeries.IsValidSourceOf, 'IsValidSourceOf');
    RegisterVirtualMethod(@TChartSeries.IsValidSeriesSource, 'IsValidSeriesSource');
    RegisterVirtualMethod(@TChartSeries.LegendToValueIndex, 'LegendToValueIndex');
    RegisterVirtualMethod(@TChartSeries.LegendItemColor, 'LegendItemColor');
    RegisterVirtualMethod(@TChartSeries.LegendString, 'LegendString');
    RegisterPropertyHelper(@TChartSeriesLinkedSeries_R,nil,'LinkedSeries');
    RegisterVirtualMethod(@TChartSeries.MaxXValue, 'MaxXValue');
    RegisterVirtualMethod(@TChartSeries.MaxYValue, 'MaxYValue');
    RegisterVirtualMethod(@TChartSeries.MaxZValue, 'MaxZValue');
    RegisterVirtualMethod(@TChartSeries.MinXValue, 'MinXValue');
    RegisterVirtualMethod(@TChartSeries.MinYValue, 'MinYValue');
    RegisterVirtualMethod(@TChartSeries.MinZValue, 'MinZValue');
    RegisterVirtualMethod(@TChartSeries.NumSampleValues, 'NumSampleValues');
    RegisterMethod(@TChartSeries.RandomBounds, 'RandomBounds');
    RegisterMethod(@TChartSeries.RemoveDataSource, 'RemoveDataSource');
    RegisterMethod(@TChartSeries.SetNull, 'SetNull');
    RegisterMethod(@TChartSeries.SortByLabels, 'SortByLabels');
    RegisterMethod(@TChartSeries.VisibleCount, 'VisibleCount');
    RegisterPropertyHelper(@TChartSeriesValuesList_R,nil,'ValuesList');
    RegisterPropertyHelper(@TChartSeriesXValue_R,@TChartSeriesXValue_W,'XValue');
    RegisterPropertyHelper(@TChartSeriesYValue_R,@TChartSeriesYValue_W,'YValue');
    RegisterPropertyHelper(@TChartSeriesZOrder_R,@TChartSeriesZOrder_W,'ZOrder');
    RegisterMethod(@TChartSeries.MaxMarkWidth, 'MaxMarkWidth');
    RegisterVirtualMethod(@TChartSeries.CalcXPos, 'CalcXPos');
    RegisterMethod(@TChartSeries.CalcXPosValue, 'CalcXPosValue');
    RegisterMethod(@TChartSeries.CalcXSizeValue, 'CalcXSizeValue');
    RegisterVirtualMethod(@TChartSeries.CalcYPos, 'CalcYPos');
    RegisterMethod(@TChartSeries.CalcYPosValue, 'CalcYPosValue');
    RegisterMethod(@TChartSeries.CalcYSizeValue, 'CalcYSizeValue');
    RegisterMethod(@TChartSeries.CalcPosValue, 'CalcPosValue');
    RegisterMethod(@TChartSeries.XScreenToValue, 'XScreenToValue');
    RegisterMethod(@TChartSeries.YScreenToValue, 'YScreenToValue');
    RegisterMethod(@TChartSeries.XValueToText, 'XValueToText');
    RegisterMethod(@TChartSeries.YValueToText, 'YValueToText');
    RegisterMethod(@TChartSeries.ColorRange, 'ColorRange');
    RegisterMethod(@TChartSeries.CheckDataSource, 'CheckDataSource');
    RegisterPropertyHelper(@TChartSeriesLabels_R,nil,'Labels');
    RegisterPropertyHelper(@TChartSeriesXLabel_R,@TChartSeriesXLabel_W,'XLabel');
    RegisterPropertyHelper(@TChartSeriesValueMarkText_R,@TChartSeriesValueMarkText_W,'ValueMarkText');
    RegisterPropertyHelper(@TChartSeriesValueColor_R,@TChartSeriesValueColor_W,'ValueColor');
    RegisterPropertyHelper(@TChartSeriesXValues_R,@TChartSeriesXValues_W,'XValues');
    RegisterPropertyHelper(@TChartSeriesYValues_R,@TChartSeriesYValues_W,'YValues');
    RegisterVirtualMethod(@TChartSeries.GetYValueList, 'GetYValueList');
    RegisterPropertyHelper(@TChartSeriesGetVertAxis_R,nil,'GetVertAxis');
    RegisterPropertyHelper(@TChartSeriesGetHorizAxis_R,nil,'GetHorizAxis');
    RegisterMethod(@TChartSeries.MarkPercent, 'MarkPercent');
    RegisterVirtualMethod(@TChartSeriesClicked_P, 'Clicked');
    RegisterMethod(@TChartSeriesClicked1_P, 'Clicked1');
    RegisterMethod(@TChartSeries.RefreshSeries, 'RefreshSeries');
    RegisterPropertyHelper(@TChartSeriesFirstValueIndex_R,nil,'FirstValueIndex');
    RegisterPropertyHelper(@TChartSeriesLastValueIndex_R,nil,'LastValueIndex');
    RegisterVirtualMethod(@TChartSeries.GetOriginValue, 'GetOriginValue');
    RegisterVirtualMethod(@TChartSeries.GetMarkValue, 'GetMarkValue');
    RegisterMethod(@TChartSeries.AssignValues, 'AssignValues');
    RegisterVirtualMethod(@TChartSeries.DrawValuesForward, 'DrawValuesForward');
    RegisterVirtualMethod(@TChartSeries.DrawSeriesForward, 'DrawSeriesForward');
    RegisterVirtualMethod(@TChartSeries.SwapValueIndex, 'SwapValueIndex');
    RegisterPropertyHelper(@TChartSeriesRecalcOptions_R,@TChartSeriesRecalcOptions_W,'RecalcOptions');
    RegisterMethod(@TChartSeries.GetCursorValueIndex, 'GetCursorValueIndex');
    RegisterMethod(@TChartSeries.GetCursorValues, 'GetCursorValues');
    RegisterVirtualMethod(@TChartSeries.DrawLegend, 'DrawLegend');
    RegisterVirtualMethod(@TChartSeries.UseAxis, 'UseAxis');
    RegisterVirtualMethod(@TChartSeries.SetFunction, 'SetFunction');
    RegisterPropertyHelper(@TChartSeriesSeriesColor_R,@TChartSeriesSeriesColor_W,'SeriesColor');
    RegisterPropertyHelper(@TChartSeriesDataSources_R,nil,'DataSources');
    RegisterPropertyHelper(@TChartSeriesFunctionType_R,@TChartSeriesFunctionType_W,'FunctionType');
    RegisterMethod(@TChartSeries.CheckOtherSeries, 'CheckOtherSeries');
    RegisterMethod(@TChartSeries.ReplaceList, 'ReplaceList');
    RegisterPropertyHelper(@TChartSeriesCustomHorizAxis_R,@TChartSeriesCustomHorizAxis_W,'CustomHorizAxis');
    RegisterPropertyHelper(@TChartSeriesCustomVertAxis_R,@TChartSeriesCustomVertAxis_W,'CustomVertAxis');
    RegisterPropertyHelper(@TChartSeriesColor_R,@TChartSeriesColor_W,'Color');
    RegisterPropertyHelper(@TChartSeriesColorEachPoint_R,@TChartSeriesColorEachPoint_W,'ColorEachPoint');
    RegisterPropertyHelper(@TChartSeriesColorSource_R,@TChartSeriesColorSource_W,'ColorSource');
    RegisterPropertyHelper(@TChartSeriesCursor_R,@TChartSeriesCursor_W,'Cursor');
    RegisterPropertyHelper(@TChartSeriesDepth_R,@TChartSeriesDepth_W,'Depth');
    RegisterPropertyHelper(@TChartSeriesHorizAxis_R,@TChartSeriesHorizAxis_W,'HorizAxis');
    RegisterPropertyHelper(@TChartSeriesMarks_R,@TChartSeriesMarks_W,'Marks');
    RegisterPropertyHelper(@TChartSeriesDataSource_R,@TChartSeriesDataSource_W,'DataSource');
    RegisterPropertyHelper(@TChartSeriesPercentFormat_R,@TChartSeriesPercentFormat_W,'PercentFormat');
    RegisterPropertyHelper(@TChartSeriesValueFormat_R,@TChartSeriesValueFormat_W,'ValueFormat');
    RegisterPropertyHelper(@TChartSeriesVertAxis_R,@TChartSeriesVertAxis_W,'VertAxis');
    RegisterPropertyHelper(@TChartSeriesXLabelsSource_R,@TChartSeriesXLabelsSource_W,'XLabelsSource');
    RegisterPropertyHelper(@TChartSeriesAfterDrawValues_R,@TChartSeriesAfterDrawValues_W,'AfterDrawValues');
    RegisterPropertyHelper(@TChartSeriesBeforeDrawValues_R,@TChartSeriesBeforeDrawValues_W,'BeforeDrawValues');
    RegisterPropertyHelper(@TChartSeriesOnAfterAdd_R,@TChartSeriesOnAfterAdd_W,'OnAfterAdd');
    RegisterPropertyHelper(@TChartSeriesOnBeforeAdd_R,@TChartSeriesOnBeforeAdd_W,'OnBeforeAdd');
    RegisterPropertyHelper(@TChartSeriesOnClearValues_R,@TChartSeriesOnClearValues_W,'OnClearValues');
    RegisterPropertyHelper(@TChartSeriesOnClick_R,@TChartSeriesOnClick_W,'OnClick');
    RegisterPropertyHelper(@TChartSeriesOnDblClick_R,@TChartSeriesOnDblClick_W,'OnDblClick');
    RegisterPropertyHelper(@TChartSeriesOnGetMarkText_R,@TChartSeriesOnGetMarkText_W,'OnGetMarkText');
    RegisterPropertyHelper(@TChartSeriesOnMouseEnter_R,@TChartSeriesOnMouseEnter_W,'OnMouseEnter');
    RegisterPropertyHelper(@TChartSeriesOnMouseLeave_R,@TChartSeriesOnMouseLeave_W,'OnMouseLeave');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataSourcesList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataSourcesList) do
  begin
    RegisterMethod(@TDataSourcesList.Add, 'Add');
    RegisterMethod(@TDataSourcesList.Clear, 'Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLabelsList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLabelsList) do
  begin
    RegisterMethod(@TLabelsList.Assign, 'Assign');
    RegisterMethod(@TLabelsList.Clear, 'Clear');
    RegisterMethod(@TLabelsList.IndexOfLabel, 'IndexOfLabel');
    RegisterPropertyHelper(@TLabelsListLabels_R,@TLabelsListLabels_W,'Labels');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeSeriesType(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeSeriesType) do
  begin
    RegisterPropertyHelper(@TTeeSeriesTypeSeriesClass_R,@TTeeSeriesTypeSeriesClass_W,'SeriesClass');
    RegisterPropertyHelper(@TTeeSeriesTypeFunctionClass_R,@TTeeSeriesTypeFunctionClass_W,'FunctionClass');
    RegisterPropertyHelper(@TTeeSeriesTypeDescription_R,@TTeeSeriesTypeDescription_W,'Description');
    RegisterPropertyHelper(@TTeeSeriesTypeGalleryPage_R,@TTeeSeriesTypeGalleryPage_W,'GalleryPage');
    RegisterPropertyHelper(@TTeeSeriesTypeNumGallerySeries_R,@TTeeSeriesTypeNumGallerySeries_W,'NumGallerySeries');
    RegisterPropertyHelper(@TTeeSeriesTypeSubIndex_R,@TTeeSeriesTypeSubIndex_W,'SubIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomChartSeries(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomChartSeries) do
  begin
    RegisterConstructor(@TCustomChartSeries.Create, 'Create');
    RegisterMethod(@TCustomChartSeries.Assign, 'Assign');
    RegisterMethod(@TCustomChartSeries.SameClass, 'SameClass');
    RegisterPropertyHelper(@TCustomChartSeriesShowInLegend_R,@TCustomChartSeriesShowInLegend_W,'ShowInLegend');
    RegisterPropertyHelper(@TCustomChartSeriesTitle_R,@TCustomChartSeriesTitle_W,'Title');
    RegisterPropertyHelper(@TCustomChartSeriesIdentifier_R,@TCustomChartSeriesIdentifier_W,'Identifier');
    RegisterPropertyHelper(@TCustomChartSeriesStyle_R,@TCustomChartSeriesStyle_W,'Style');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartValueLists(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartValueLists) do begin
    RegisterPropertyHelper(@TChartValueListsValueList_R,nil,'ValueList');
    RegisterMethod(@TChartValueLists.Clear, 'Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeMovingFunction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeMovingFunction) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeFunction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeFunction) do
  begin
    RegisterConstructor(@TTeeFunction.Create, 'Create');
    RegisterMethod(@TTeeFunction.Assign, 'Assign');
    RegisterVirtualMethod(@TTeeFunction.AddPoints, 'AddPoints');
    RegisterMethod(@TTeeFunction.BeginUpdate, 'BeginUpdate');
    RegisterVirtualMethod(@TTeeFunction.Calculate, 'Calculate');
    RegisterVirtualMethod(@TTeeFunction.CalculateMany, 'CalculateMany');
    RegisterMethod(@TTeeFunction.EndUpdate, 'EndUpdate');
    RegisterPropertyHelper(@TTeeFunctionParentSeries_R,@TTeeFunctionParentSeries_W,'ParentSeries');
    RegisterMethod(@TTeeFunction.ReCalculate, 'ReCalculate');
    RegisterPropertyHelper(@TTeeFunctionPeriod_R,@TTeeFunctionPeriod_W,'Period');
    RegisterPropertyHelper(@TTeeFunctionPeriodAlign_R,@TTeeFunctionPeriodAlign_W,'PeriodAlign');
    RegisterPropertyHelper(@TTeeFunctionPeriodStyle_R,@TTeeFunctionPeriodStyle_W,'PeriodStyle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSeriesMarks(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSeriesMarks) do begin
    RegisterConstructor(@TSeriesMarks.Create, 'Create');
     RegisterMethod(@TSeriesMarks.Destroy, 'Free');
       RegisterMethod(@TSeriesMarks.ApplyArrowLength, 'ApplyArrowLength');
    RegisterMethod(@TSeriesMarks.Assign, 'Assign');
    RegisterMethod(@TSeriesMarks.Clear, 'Clear');
    RegisterMethod(@TSeriesMarks.Clicked, 'Clicked');
    RegisterMethod(@TSeriesMarks.DrawItem, 'DrawItem');
    RegisterMethod(@TSeriesMarks.DrawText, 'DrawText');
    RegisterPropertyHelper(@TSeriesMarksItem_R,nil,'Item');
    RegisterPropertyHelper(@TSeriesMarksItems_R,nil,'Items');
    RegisterPropertyHelper(@TSeriesMarksParentSeries_R,nil,'ParentSeries');
    RegisterPropertyHelper(@TSeriesMarksPositions_R,nil,'Positions');
    RegisterMethod(@TSeriesMarks.ResetPositions, 'ResetPositions');
    RegisterPropertyHelper(@TSeriesMarksZPosition_R,@TSeriesMarksZPosition_W,'ZPosition');
    RegisterPropertyHelper(@TSeriesMarksAngle_R,@TSeriesMarksAngle_W,'Angle');
    RegisterPropertyHelper(@TSeriesMarksArrow_R,@TSeriesMarksArrow_W,'Arrow');
    RegisterPropertyHelper(@TSeriesMarksArrowLength_R,@TSeriesMarksArrowLength_W,'ArrowLength');
    RegisterPropertyHelper(@TSeriesMarksCallout_R,@TSeriesMarksCallout_W,'Callout');
    RegisterPropertyHelper(@TSeriesMarksBackColor_R,@TSeriesMarksBackColor_W,'BackColor');
    RegisterPropertyHelper(@TSeriesMarksClip_R,@TSeriesMarksClip_W,'Clip');
    RegisterPropertyHelper(@TSeriesMarksDrawEvery_R,@TSeriesMarksDrawEvery_W,'DrawEvery');
    RegisterPropertyHelper(@TSeriesMarksMargins_R,@TSeriesMarksMargins_W,'Margins');
    RegisterPropertyHelper(@TSeriesMarksMultiLine_R,@TSeriesMarksMultiLine_W,'MultiLine');
    RegisterPropertyHelper(@TSeriesMarksStyle_R,@TSeriesMarksStyle_W,'Style');
    RegisterPropertyHelper(@TSeriesMarksSymbol_R,@TSeriesMarksSymbol_W,'Symbol');
    RegisterPropertyHelper(@TSeriesMarksTextAlign_R,@TSeriesMarksTextAlign_W,'TextAlign');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMarginsTe(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMarginsTe) do begin
    RegisterConstructor(@TMarginsTe.Create, 'Create');
    RegisterMethod(@TMarginsTE.Assign, 'Assign');
    RegisterMethod(@TMarginsTE.Calculate, 'Calculate');
    RegisterMethod(@TMarginsTE.HorizSize, 'HorizSize');
    RegisterMethod(@TMarginsTE.VertSize, 'VertSize');
    RegisterPropertyHelper(@TMarginsSize_R,nil,'Size');
    RegisterPropertyHelper(@TMarginsLeft_R,@TMarginsLeft_W,'Left');
    RegisterPropertyHelper(@TMarginsTop_R,@TMarginsTop_W,'Top');
    RegisterPropertyHelper(@TMarginsRight_R,@TMarginsRight_W,'Right');
    RegisterPropertyHelper(@TMarginsBottom_R,@TMarginsBottom_W,'Bottom');
    RegisterPropertyHelper(@TMarginsUnits_R,@TMarginsUnits_W,'Units');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSeriesMarksSymbol(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSeriesMarksSymbol) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMarksCallout(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMarksCallout) do
  begin
    RegisterConstructor(@TMarksCallout.Create, 'Create');
    RegisterMethod(@TMarksCallout.Assign, 'Assign');
     //RegisterMethod(@TSeriesMarks.Destroy, 'Free');
     RegisterPropertyHelper(@TMarksCalloutLength_R,@TMarksCalloutLength_W,'Length');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCallout(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCallout) do
  begin
    RegisterConstructor(@TCallout.Create, 'Create');
    RegisterMethod(@TCallout.Assign, 'Assign');
     RegisterMethod(@TSeriesMarks.Destroy, 'Free');
    RegisterPropertyHelper(@TCalloutArrow_R,@TCalloutArrow_W,'Arrow');
    RegisterPropertyHelper(@TCalloutArrowHead_R,@TCalloutArrowHead_W,'ArrowHead');
    RegisterPropertyHelper(@TCalloutArrowHeadSize_R,@TCalloutArrowHeadSize_W,'ArrowHeadSize');
    RegisterPropertyHelper(@TCalloutDistance_R,@TCalloutDistance_W,'Distance');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSeriesPointer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSeriesPointer) do begin
    RegisterConstructor(@TSeriesPointer.Create, 'Create');
     RegisterMethod(@TSeriesMarks.Destroy, 'Free');
    RegisterMethod(@TSeriesMarks.Assign, 'Assign');
    RegisterMethod(@TSeriesPointerDraw_P, 'Draw');
    RegisterMethod(@TSeriesPointerDraw1_P, 'Draw1');
    RegisterMethod(@TSeriesPointerDraw2_P, 'Draw2');
    RegisterMethod(@TSeriesPointer.DrawPointer, 'DrawPointer');
    RegisterMethod(@TSeriesPointer.PrepareCanvas, 'PrepareCanvas');
    RegisterPropertyHelper(@TSeriesPointerColor_R,@TSeriesPointerColor_W,'Color');
    RegisterPropertyHelper(@TSeriesPointerParentSeries_R,nil,'ParentSeries');
    RegisterPropertyHelper(@TSeriesPointerSize_R,@TSeriesPointerSize_W,'Size');
    RegisterPropertyHelper(@TSeriesPointerDark3D_R,@TSeriesPointerDark3D_W,'Dark3D');
    RegisterPropertyHelper(@TSeriesPointerDraw3D_R,@TSeriesPointerDraw3D_W,'Draw3D');
    RegisterPropertyHelper(@TSeriesPointerGradient_R,@TSeriesPointerGradient_W,'Gradient');
    RegisterPropertyHelper(@TSeriesPointerHorizSize_R,@TSeriesPointerHorizSize_W,'HorizSize');
    RegisterPropertyHelper(@TSeriesPointerInflateMargins_R,@TSeriesPointerInflateMargins_W,'InflateMargins');
    RegisterPropertyHelper(@TSeriesPointerShadow_R,@TSeriesPointerShadow_W,'Shadow');
    RegisterPropertyHelper(@TSeriesPointerStyle_R,@TSeriesPointerStyle_W,'Style');
    RegisterPropertyHelper(@TSeriesPointerTransparency_R,@TSeriesPointerTransparency_W,'Transparency');
    RegisterPropertyHelper(@TSeriesPointerVertSize_R,@TSeriesPointerVertSize_W,'VertSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSeriesMarksGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSeriesMarksGradient) do
  begin
    RegisterConstructor(@TSeriesMarksGradient.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMarksItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMarksItems) do
  begin
    RegisterPropertyHelper(@TMarksItemsFormat_R,nil,'Format');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMarksItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMarksItem) do
  begin
    RegisterPropertyHelper(@TMarksItemText_R,@TMarksItemText_W,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSeriesMarksPositions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSeriesMarksPositions) do
  begin
    RegisterMethod(@TSeriesMarksPositions.Automatic, 'Automatic');
    RegisterMethod(@TSeriesMarksPositions.Clear, 'Clear');
    RegisterMethod(@TSeriesMarksPositions.ExistCustom, 'ExistCustom');
    RegisterMethod(@TSeriesMarksPositions.MoveTo, 'MoveTo');
    RegisterPropertyHelper(@TSeriesMarksPositionsPosition_R,@TSeriesMarksPositionsPosition_W,'Position');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSeriesMarkPosition(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSeriesMarkPosition) do
  begin
    RegisterPropertyHelper(@TSeriesMarkPositionArrowFrom_R,@TSeriesMarkPositionArrowFrom_W,'ArrowFrom');
    RegisterPropertyHelper(@TSeriesMarkPositionArrowFix_R,@TSeriesMarkPositionArrowFix_W,'ArrowFix');
    RegisterPropertyHelper(@TSeriesMarkPositionArrowTo_R,@TSeriesMarkPositionArrowTo_W,'ArrowTo');
    RegisterPropertyHelper(@TSeriesMarkPositionCustom_R,@TSeriesMarkPositionCustom_W,'Custom');
    RegisterPropertyHelper(@TSeriesMarkPositionHeight_R,@TSeriesMarkPositionHeight_W,'Height');
    RegisterPropertyHelper(@TSeriesMarkPositionLeftTop_R,@TSeriesMarkPositionLeftTop_W,'LeftTop');
    RegisterPropertyHelper(@TSeriesMarkPositionWidth_R,@TSeriesMarkPositionWidth_W,'Width');
    RegisterPropertyHelper(@TSeriesMarkPositionMidPoint_R,@TSeriesMarkPositionMidPoint_W,'MidPoint');
    RegisterPropertyHelper(@TSeriesMarkPositionHasMid_R,@TSeriesMarkPositionHasMid_W,'HasMid');
    RegisterMethod(@TSeriesMarkPosition.Assign, 'Assign');
    RegisterMethod(@TSeriesMarkPosition.Bounds, 'Bounds');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomAxisPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomAxisPanel) do begin
    RegisterConstructor(@TCustomAxisPanel.Create, 'Create');
    RegisterMethod(@TCustomAxisPanel.Destroy, 'Free');
    RegisterMethod(@TCustomAxisPanel.Assign, 'Assign');
    RegisterPropertyHelper(@TCustomAxisPanelDesigner_R,@TCustomAxisPanelDesigner_W,'Designer');
    RegisterPropertyHelper(@TCustomAxisPanelColorPalette_R,@TCustomAxisPanelColorPalette_W,'ColorPalette');
    RegisterMethod(@TCustomAxisPanel.ActiveSeriesLegend, 'ActiveSeriesLegend');
    RegisterMethod(@TCustomAxisPanelAddSeries_P, 'AddSeries');
    RegisterMethod(@TCustomAxisPanelAddSeries1_P, 'AddSeries1');
    RegisterMethod(@TCustomAxisPanelAddSeries2_P, 'AddSeries2');
    RegisterMethod(@TCustomAxisPanel.CalcSize3DWalls, 'CalcSize3DWalls');
    RegisterVirtualMethod(@TCustomAxisPanel.CheckDatasource, 'CheckDatasource');
    RegisterMethod(@TCustomAxisPanel.CountActiveSeries, 'CountActiveSeries');
    RegisterMethod(@TCustomAxisPanelExchangeSeries_P, 'ExchangeSeries');
    RegisterMethod(@TCustomAxisPanelExchangeSeries1_P, 'ExchangeSeries1');
    RegisterVirtualMethod(@TCustomAxisPanel.FormattedValueLegend, 'FormattedValueLegend');
    RegisterMethod(@TCustomAxisPanel.FreeAllSeries, 'FreeAllSeries');
    RegisterMethod(@TCustomAxisPanel.GetAxisSeries, 'GetAxisSeries');
    RegisterMethod(@TCustomAxisPanel.GetDefaultColor, 'GetDefaultColor');
    RegisterMethod(@TCustomAxisPanel.GetFreeSeriesColor, 'GetFreeSeriesColor');
    RegisterMethod(@TCustomAxisPanel.GetMaxValuesCount, 'GetMaxValuesCount');
    //RegisterVirtualAbstractMethod(@TCustomAxisPanel, @!.IsFreeSeriesColor, 'IsFreeSeriesColor');
    RegisterVirtualMethod(@TCustomAxisPanel.IsValidDataSource, 'IsValidDataSource');
    RegisterMethod(@TCustomAxisPanel.MaxXValue, 'MaxXValue');
    RegisterMethod(@TCustomAxisPanel.MaxYValue, 'MaxYValue');
    RegisterMethod(@TCustomAxisPanel.MinXValue, 'MinXValue');
    RegisterMethod(@TCustomAxisPanel.MinYValue, 'MinYValue');
    RegisterMethod(@TCustomAxisPanel.MaxMarkWidth, 'MaxMarkWidth');
    RegisterMethod(@TCustomAxisPanel.MaxTextWidth, 'MaxTextWidth');
    RegisterMethod(@TCustomAxisPanel.MultiLineTextWidth, 'MultiLineTextWidth');
    RegisterVirtualMethod(@TCustomAxisPanel.NumPages, 'NumPages');
    RegisterMethod(@TCustomAxisPanel.PrintPages, 'PrintPages');
    RegisterMethod(@TCustomAxisPanelRemoveSeries_P, 'RemoveSeries');
    RegisterMethod(@TCustomAxisPanelRemoveSeries1_P, 'RemoveSeries1');
    RegisterPropertyHelper(@TCustomAxisPanelSeries_R,nil,'Series');
    RegisterMethod(@TCustomAxisPanel.SeriesCount, 'SeriesCount');
    RegisterMethod(@TCustomAxisPanel.SeriesLegend, 'SeriesLegend');
    RegisterMethod(@TCustomAxisPanel.SeriesTitleLegend, 'SeriesTitleLegend');
    RegisterPropertyHelper(@TCustomAxisPanelAxes_R,nil,'Axes');
    RegisterPropertyHelper(@TCustomAxisPanelAxesList_R,nil,'AxesList');
    RegisterPropertyHelper(@TCustomAxisPanelCustomAxes_R,@TCustomAxisPanelCustomAxes_W,'CustomAxes');
    RegisterPropertyHelper(@TCustomAxisPanelMaxZOrder_R,@TCustomAxisPanelMaxZOrder_W,'MaxZOrder');
    RegisterPropertyHelper(@TCustomAxisPanelSeriesWidth3D_R,nil,'SeriesWidth3D');
    RegisterPropertyHelper(@TCustomAxisPanelSeriesHeight3D_R,nil,'SeriesHeight3D');
    RegisterPropertyHelper(@TCustomAxisPanelAxisBehind_R,@TCustomAxisPanelAxisBehind_W,'AxisBehind');
    RegisterPropertyHelper(@TCustomAxisPanelAxisVisible_R,@TCustomAxisPanelAxisVisible_W,'AxisVisible');
    RegisterPropertyHelper(@TCustomAxisPanelBottomAxis_R,@TCustomAxisPanelBottomAxis_W,'BottomAxis');
    RegisterPropertyHelper(@TCustomAxisPanelChart3DPercent_R,@TCustomAxisPanelChart3DPercent_W,'Chart3DPercent');
    RegisterPropertyHelper(@TCustomAxisPanelClipPoints_R,@TCustomAxisPanelClipPoints_W,'ClipPoints');
    RegisterPropertyHelper(@TCustomAxisPanelDepthAxis_R,@TCustomAxisPanelDepthAxis_W,'DepthAxis');
    RegisterPropertyHelper(@TCustomAxisPanelDepthTopAxis_R,@TCustomAxisPanelDepthTopAxis_W,'DepthTopAxis');
    RegisterPropertyHelper(@TCustomAxisPanelLeftAxis_R,@TCustomAxisPanelLeftAxis_W,'LeftAxis');
    RegisterPropertyHelper(@TCustomAxisPanelMaxPointsPerPage_R,@TCustomAxisPanelMaxPointsPerPage_W,'MaxPointsPerPage');
    RegisterPropertyHelper(@TCustomAxisPanelPage_R,@TCustomAxisPanelPage_W,'Page');
    RegisterPropertyHelper(@TCustomAxisPanelPages_R,@TCustomAxisPanelPages_W,'Pages');
    RegisterPropertyHelper(@TCustomAxisPanelRightAxis_R,@TCustomAxisPanelRightAxis_W,'RightAxis');
    RegisterPropertyHelper(@TCustomAxisPanelScaleLastPage_R,@TCustomAxisPanelScaleLastPage_W,'ScaleLastPage');
    RegisterPropertyHelper(@TCustomAxisPanelSeriesGroups_R,@TCustomAxisPanelSeriesGroups_W,'SeriesGroups');
    RegisterPropertyHelper(@TCustomAxisPanelSeriesList_R,nil,'SeriesList');
    RegisterPropertyHelper(@TCustomAxisPanelTools_R,nil,'Tools');
    RegisterPropertyHelper(@TCustomAxisPanelTopAxis_R,@TCustomAxisPanelTopAxis_W,'TopAxis');
    RegisterPropertyHelper(@TCustomAxisPanelView3DWalls_R,@TCustomAxisPanelView3DWalls_W,'View3DWalls');
    RegisterPropertyHelper(@TCustomAxisPanelOnAddSeries_R,@TCustomAxisPanelOnAddSeries_W,'OnAddSeries');
    RegisterPropertyHelper(@TCustomAxisPanelOnBeforeDrawChart_R,@TCustomAxisPanelOnBeforeDrawChart_W,'OnBeforeDrawChart');
    RegisterPropertyHelper(@TCustomAxisPanelOnBeforeDrawAxes_R,@TCustomAxisPanelOnBeforeDrawAxes_W,'OnBeforeDrawAxes');
    RegisterPropertyHelper(@TCustomAxisPanelOnBeforeDrawSeries_R,@TCustomAxisPanelOnBeforeDrawSeries_W,'OnBeforeDrawSeries');
    RegisterPropertyHelper(@TCustomAxisPanelOnGetAxisLabel_R,@TCustomAxisPanelOnGetAxisLabel_W,'OnGetAxisLabel');
    RegisterPropertyHelper(@TCustomAxisPanelOnGetNextAxisLabel_R,@TCustomAxisPanelOnGetNextAxisLabel_W,'OnGetNextAxisLabel');
    RegisterPropertyHelper(@TCustomAxisPanelOnPageChange_R,@TCustomAxisPanelOnPageChange_W,'OnPageChange');
    RegisterPropertyHelper(@TCustomAxisPanelOnRemoveSeries_R,@TCustomAxisPanelOnRemoveSeries_W,'OnRemoveSeries');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeSeriesEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeSeriesEvent) do
  begin
    RegisterPropertyHelper(@TTeeSeriesEventEvent_R,@TTeeSeriesEventEvent_W,'Event');
    RegisterPropertyHelper(@TTeeSeriesEventSeries_R,@TTeeSeriesEventSeries_W,'Series');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartPage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartPage) do
  begin
    RegisterConstructor(@TChartPage.Create, 'Create');
    RegisterMethod(@TChartPage.Assign, 'Assign');
    RegisterMethod(@TChartPage.Count, 'Count');
    RegisterMethod(@TChartPage.FirstValueIndex, 'FirstValueIndex');
    RegisterMethod(@TChartPage.NextPage, 'NextPage');
    RegisterMethod(@TChartPage.PreviousPage, 'PreviousPage');
    RegisterPropertyHelper(@TChartPageParent_R,nil,'Parent');
    RegisterPropertyHelper(@TChartPageAutoScale_R,@TChartPageAutoScale_W,'AutoScale');
    RegisterPropertyHelper(@TChartPageCurrent_R,@TChartPageCurrent_W,'Current');
    RegisterPropertyHelper(@TChartPageMaxPointsPerPage_R,@TChartPageMaxPointsPerPage_W,'MaxPointsPerPage');
    RegisterPropertyHelper(@TChartPageScaleLastPage_R,@TChartPageScaleLastPage_W,'ScaleLastPage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeCustomToolAxis(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeCustomToolAxis) do
  begin
    RegisterPropertyHelper(@TTeeCustomToolAxisAxis_R,@TTeeCustomToolAxisAxis_W,'Axis');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeCustomToolSeries(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeCustomToolSeries) do
  begin
    RegisterMethod(@TTeeCustomToolSeries.Assign, 'Assign');
    RegisterPropertyHelper(@TTeeCustomToolSeriesSeries_R,@TTeeCustomToolSeriesSeries_W,'Series');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartTools(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartTools) do
  begin
    RegisterMethod(@TChartToolsAdd2_P, 'Add2');
     RegisterMethod(@TChartToolsAdd2_P, 'Add');
    RegisterMethod(@TChartTools.Clear, 'Clear');
    RegisterPropertyHelper(nil,@TChartToolsActive_W,'Active');
    RegisterPropertyHelper(@TChartToolsItems_R,nil,'Items');
    RegisterPropertyHelper(@TChartToolsOwner_R,nil,'Owner');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeCustomTool(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeCustomTool) do
  begin
    RegisterVirtualMethod(@TTeeCustomTool.Description, 'Description');
    RegisterVirtualMethod(@TTeeCustomTool.LongDescription, 'LongDescription');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeCustomDesigner(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeCustomDesigner) do
  begin
    RegisterVirtualMethod(@TTeeCustomDesigner.Refresh, 'Refresh');
    RegisterVirtualMethod(@TTeeCustomDesigner.Repaint, 'Repaint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartCustomAxes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartCustomAxes) do
  begin
    RegisterMethod(@TChartCustomAxes.ResetScales, 'ResetScales');
    RegisterPropertyHelper(@TChartCustomAxesItems_R,@TChartCustomAxesItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartAxes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartAxes) do begin
    RegisterMethod(@TChartAxes.Hide, 'Hide');
    RegisterMethod(@TChartAxes.Reset, 'Reset');
    RegisterMethod(@TChartAxes.Clear, 'Clear');
    RegisterPropertyHelper(@TChartAxesItems_R,nil,'Items');
    RegisterPropertyHelper(@TChartAxesBottom_R,nil,'Bottom');
    RegisterPropertyHelper(@TChartAxesDepth_R,nil,'Depth');
    RegisterPropertyHelper(@TChartAxesDepthTop_R,nil,'DepthTop');
    RegisterPropertyHelper(@TChartAxesLeft_R,nil,'Left');
    RegisterPropertyHelper(@TChartAxesRight_R,nil,'Right');
    RegisterPropertyHelper(@TChartAxesTop_R,nil,'Top');
    RegisterPropertyHelper(@TChartAxesBehind_R,@TChartAxesBehind_W,'Behind');
    RegisterPropertyHelper(@TChartAxesFastCalc_R,@TChartAxesFastCalc_W,'FastCalc');
    RegisterPropertyHelper(@TChartAxesVisible_R,@TChartAxesVisible_W,'Visible');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSeriesGroups(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSeriesGroups) do
  begin
    RegisterMethod(@TSeriesGroups.Contains, 'Contains');
    RegisterMethod(@TSeriesGroups.FindByName, 'FindByName');
    RegisterPropertyHelper(@TSeriesGroupsItems_R,@TSeriesGroupsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSeriesGroup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSeriesGroup) do begin
    RegisterConstructor(@TSeriesGroup.Create, 'Create');
     RegisterMethod(@TSeriesGroup.Destroy, 'Free');
    RegisterMethod(@TSeriesGroup.Add, 'Add');
    RegisterMethod(@TSeriesGroup.Assign, 'Assign');
    RegisterMethod(@TSeriesGroup.Hide, 'Hide');
    RegisterMethod(@TSeriesGroup.Show, 'Show');
    RegisterPropertyHelper(@TSeriesGroupActive_R,@TSeriesGroupActive_W,'Active');
    RegisterPropertyHelper(@TSeriesGroupName_R,@TSeriesGroupName_W,'Name');
    RegisterPropertyHelper(@TSeriesGroupSeries_R,@TSeriesGroupSeries_W,'Series');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartSeriesList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartSeriesList) do
  begin
    RegisterMethod(@TChartSeriesList.AddGroup, 'AddGroup');
    RegisterMethod(@TChartSeriesList.Assign, 'Assign');
    RegisterPropertyHelper(@TChartSeriesListAllActive_R,@TChartSeriesListAllActive_W,'AllActive');
    RegisterPropertyHelper(@TChartSeriesListGroups_R,@TChartSeriesListGroups_W,'Groups');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomSeriesList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomSeriesList) do
  begin
    RegisterMethod(@TCustomSeriesList.ClearValues, 'ClearValues');
    RegisterMethod(@TCustomSeriesList.FillSampleValues, 'FillSampleValues');
    RegisterMethod(@TCustomSeriesList.First, 'First');
    RegisterMethod(@TCustomSeriesList.GetEnumerator, 'GetEnumerator');
    RegisterMethod(@TCustomSeriesList.Last, 'Last');
    RegisterPropertyHelper(@TCustomSeriesListItems_R,@TCustomSeriesListItems_W,'Items');
    RegisterPropertyHelper(@TCustomSeriesListOwner_R,nil,'Owner');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSeriesEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSeriesEnumerator) do
  begin
    RegisterConstructor(@TSeriesEnumerator.Create, 'Create');
    RegisterMethod(@TSeriesEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TSeriesEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TSeriesEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartDepthAxis(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartDepthAxis) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartAxis(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartAxis) do begin
    RegisterPropertyHelper(@TChartAxisIStartPos_R,@TChartAxisIStartPos_W,'IStartPos');
    RegisterPropertyHelper(@TChartAxisIEndPos_R,@TChartAxisIEndPos_W,'IEndPos');
    RegisterPropertyHelper(@TChartAxisIAxisSize_R,@TChartAxisIAxisSize_W,'IAxisSize');
    RegisterPropertyHelper(@TChartAxisCalcXPosValue_R,@TChartAxisCalcXPosValue_W,'CalcXPosValue');
    RegisterPropertyHelper(@TChartAxisCalcYPosValue_R,@TChartAxisCalcYPosValue_W,'CalcYPosValue');
    RegisterPropertyHelper(@TChartAxisCalcPosValue_R,@TChartAxisCalcPosValue_W,'CalcPosValue');
    RegisterPropertyHelper(@TChartAxisTick_R,@TChartAxisTick_W,'Tick');
    RegisterConstructor(@TChartAxis.Create, 'Create');
     RegisterMethod(@TChartAxis.Destroy, 'Free');
    RegisterMethod(@TChartAxis.Assign, 'Assign');
    RegisterMethod(@TChartAxis.AdjustMaxMin, 'AdjustMaxMin');
    RegisterMethod(@TChartAxis.AdjustMaxMinRect, 'AdjustMaxMinRect');
    RegisterMethod(@TChartAxis.CalcIncrement, 'CalcIncrement');
    RegisterMethod(@TChartAxis.CalcLabelStyle, 'CalcLabelStyle');
    RegisterMethod(@TChartAxis.CalcMinMax, 'CalcMinMax');
    RegisterMethod(@TChartAxis.CalcPosPoint, 'CalcPosPoint');
    RegisterMethod(@TChartAxis.CalcSizeValue, 'CalcSizeValue');
    RegisterMethod(@TChartAxis.CalcXYIncrement, 'CalcXYIncrement');
    RegisterMethod(@TChartAxis.CustomDraw, 'CustomDraw');
    RegisterMethod(@TChartAxis.CustomDrawMinMax, 'CustomDrawMinMax');
    RegisterMethod(@TChartAxis.CustomDrawMinMaxStartEnd, 'CustomDrawMinMaxStartEnd');
    RegisterMethod(@TChartAxis.CustomDrawStartEnd, 'CustomDrawStartEnd');
    RegisterMethod(@TChartAxis.Clicked, 'Clicked');
    RegisterMethod(@TChartAxis.Draw, 'Draw');
    RegisterMethod(@TChartAxis.DrawAxisLabel, 'DrawAxisLabel');
    RegisterMethod(@TChartAxis.IsDateTime, 'IsDateTime');
    RegisterMethod(@TChartAxis.LabelWidth, 'LabelWidth');
    RegisterMethod(@TChartAxis.LabelHeight, 'LabelHeight');
    RegisterVirtualMethod(@TChartAxis.LabelValue, 'LabelValue');
    RegisterMethod(@TChartAxis.MaxLabelsWidth, 'MaxLabelsWidth');
    RegisterMethod(@TChartAxis.Scroll, 'Scroll');
    RegisterMethod(@TChartAxis.SetMinMax, 'SetMinMax');
    RegisterPropertyHelper(@TChartAxisIsDepthAxis_R,nil,'IsDepthAxis');
    RegisterPropertyHelper(@TChartAxisItems_R,nil,'Items');
    RegisterPropertyHelper(@TChartAxisMasterAxis_R,@TChartAxisMasterAxis_W,'MasterAxis');
    RegisterPropertyHelper(@TChartAxisPosAxis_R,nil,'PosAxis');
    RegisterPropertyHelper(@TChartAxisPosLabels_R,nil,'PosLabels');
    RegisterPropertyHelper(@TChartAxisPosTitle_R,nil,'PosTitle');
    RegisterPropertyHelper(@TChartAxisParentChart_R,nil,'ParentChart');
    RegisterPropertyHelper(@TChartAxisAutomatic_R,@TChartAxisAutomatic_W,'Automatic');
    RegisterPropertyHelper(@TChartAxisAutomaticMaximum_R,@TChartAxisAutomaticMaximum_W,'AutomaticMaximum');
    RegisterPropertyHelper(@TChartAxisAutomaticMinimum_R,@TChartAxisAutomaticMinimum_W,'AutomaticMinimum');
    RegisterPropertyHelper(@TChartAxisAxis_R,@TChartAxisAxis_W,'Axis');
    RegisterPropertyHelper(@TChartAxisAxisValuesFormat_R,@TChartAxisAxisValuesFormat_W,'AxisValuesFormat');
    RegisterPropertyHelper(@TChartAxisDateTimeFormat_R,@TChartAxisDateTimeFormat_W,'DateTimeFormat');
    RegisterPropertyHelper(@TChartAxisExactDateTime_R,@TChartAxisExactDateTime_W,'ExactDateTime');
    RegisterPropertyHelper(@TChartAxisGrid_R,@TChartAxisGrid_W,'Grid');
    RegisterPropertyHelper(@TChartAxisGridCentered_R,@TChartAxisGridCentered_W,'GridCentered');
    RegisterPropertyHelper(@TChartAxisIncrement_R,@TChartAxisIncrement_W,'Increment');
    RegisterPropertyHelper(@TChartAxisInverted_R,@TChartAxisInverted_W,'Inverted');
    RegisterPropertyHelper(@TChartAxisHorizontal_R,@TChartAxisHorizontal_W,'Horizontal');
    RegisterPropertyHelper(@TChartAxisOtherSide_R,@TChartAxisOtherSide_W,'OtherSide');
    RegisterPropertyHelper(@TChartAxisLabels_R,@TChartAxisLabels_W,'Labels');
    RegisterPropertyHelper(@TChartAxisLabelsAlign_R,@TChartAxisLabelsAlign_W,'LabelsAlign');
    RegisterPropertyHelper(@TChartAxisLabelsAlternate_R,@TChartAxisLabelsAlternate_W,'LabelsAlternate');
    RegisterPropertyHelper(@TChartAxisLabelsAngle_R,@TChartAxisLabelsAngle_W,'LabelsAngle');
    RegisterPropertyHelper(@TChartAxisLabelsExponent_R,@TChartAxisLabelsExponent_W,'LabelsExponent');
    RegisterPropertyHelper(@TChartAxisLabelsFont_R,@TChartAxisLabelsFont_W,'LabelsFont');
    RegisterPropertyHelper(@TChartAxisLabelsMultiLine_R,@TChartAxisLabelsMultiLine_W,'LabelsMultiLine');
    RegisterPropertyHelper(@TChartAxisLabelsOnAxis_R,@TChartAxisLabelsOnAxis_W,'LabelsOnAxis');
    RegisterPropertyHelper(@TChartAxisLabelsSeparation_R,@TChartAxisLabelsSeparation_W,'LabelsSeparation');
    RegisterPropertyHelper(@TChartAxisLabelsSize_R,@TChartAxisLabelsSize_W,'LabelsSize');
    RegisterPropertyHelper(@TChartAxisLabelStyle_R,@TChartAxisLabelStyle_W,'LabelStyle');
    RegisterPropertyHelper(@TChartAxisLogarithmic_R,@TChartAxisLogarithmic_W,'Logarithmic');
    RegisterPropertyHelper(@TChartAxisLogarithmicBase_R,@TChartAxisLogarithmicBase_W,'LogarithmicBase');
    RegisterPropertyHelper(@TChartAxisMaximum_R,@TChartAxisMaximum_W,'Maximum');
    RegisterPropertyHelper(@TChartAxisMaximumOffset_R,@TChartAxisMaximumOffset_W,'MaximumOffset');
    RegisterPropertyHelper(@TChartAxisMaximumRound_R,@TChartAxisMaximumRound_W,'MaximumRound');
    RegisterPropertyHelper(@TChartAxisMinimum_R,@TChartAxisMinimum_W,'Minimum');
    RegisterPropertyHelper(@TChartAxisMinimumOffset_R,@TChartAxisMinimumOffset_W,'MinimumOffset');
    RegisterPropertyHelper(@TChartAxisMinimumRound_R,@TChartAxisMinimumRound_W,'MinimumRound');
    RegisterPropertyHelper(@TChartAxisMinorGrid_R,@TChartAxisMinorGrid_W,'MinorGrid');
    RegisterPropertyHelper(@TChartAxisMinorTickCount_R,@TChartAxisMinorTickCount_W,'MinorTickCount');
    RegisterPropertyHelper(@TChartAxisMinorTickLength_R,@TChartAxisMinorTickLength_W,'MinorTickLength');
    RegisterPropertyHelper(@TChartAxisMinorTicks_R,@TChartAxisMinorTicks_W,'MinorTicks');
    RegisterPropertyHelper(@TChartAxisStartPosition_R,@TChartAxisStartPosition_W,'StartPosition');
    RegisterPropertyHelper(@TChartAxisEndPosition_R,@TChartAxisEndPosition_W,'EndPosition');
    RegisterPropertyHelper(@TChartAxisPositionPercent_R,@TChartAxisPositionPercent_W,'PositionPercent');
    RegisterPropertyHelper(@TChartAxisPositionUnits_R,@TChartAxisPositionUnits_W,'PositionUnits');
    RegisterPropertyHelper(@TChartAxisRoundFirstLabel_R,@TChartAxisRoundFirstLabel_W,'RoundFirstLabel');
    RegisterPropertyHelper(@TChartAxisTickInnerLength_R,@TChartAxisTickInnerLength_W,'TickInnerLength');
    RegisterPropertyHelper(@TChartAxisTickLength_R,@TChartAxisTickLength_W,'TickLength');
    RegisterPropertyHelper(@TChartAxisTicks_R,@TChartAxisTicks_W,'Ticks');
    RegisterPropertyHelper(@TChartAxisTicksInner_R,@TChartAxisTicksInner_W,'TicksInner');
    RegisterPropertyHelper(@TChartAxisTickOnLabelsOnly_R,@TChartAxisTickOnLabelsOnly_W,'TickOnLabelsOnly');
    RegisterPropertyHelper(@TChartAxisTitle_R,@TChartAxisTitle_W,'Title');
    RegisterPropertyHelper(@TChartAxisTitleSize_R,@TChartAxisTitleSize_W,'TitleSize');
    RegisterPropertyHelper(@TChartAxisVisible_R,@TChartAxisVisible_W,'Visible');
    RegisterPropertyHelper(@TChartAxisZPosition_R,@TChartAxisZPosition_W,'ZPosition');
    RegisterPropertyHelper(@TChartAxisOnDrawLabel_R,@TChartAxisOnDrawLabel_W,'OnDrawLabel');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartAxisPen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartAxisPen) do
  begin
    RegisterConstructor(@TChartAxisPen.Create, 'Create');
    RegisterPropertyHelper(@TChartAxisPenLineMode_R,@TChartAxisPenLineMode_W,'LineMode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAxisItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAxisItems) do
  begin
    RegisterConstructor(@TAxisItems.Create, 'Create');
    RegisterMethod(@TAxisItemsAdd_P, 'Add');
    RegisterMethod(@TAxisItemsAdd1_P, 'Add1');
    RegisterMethod(@TAxisItems.CopyFrom, 'CopyFrom');
    RegisterPropertyHelper(@TAxisItemsAutomatic_R,@TAxisItemsAutomatic_W,'Automatic');
    RegisterPropertyHelper(@TAxisItemsFormat_R,nil,'Format');
    RegisterPropertyHelper(@TAxisItemsItem_R,nil,'Item');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAxisItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAxisItem) do
  begin
    RegisterMethod(@TAxisItem.Repaint, 'Repaint');
    RegisterPropertyHelper(@TAxisItemText_R,@TAxisItemText_W,'Text');
    RegisterPropertyHelper(@TAxisItemValue_R,@TAxisItemValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAxisGridPen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAxisGridPen) do
  begin
    RegisterConstructor(@TAxisGridPen.Create, 'Create');
    RegisterMethod(@TAxisGridPen.Assign, 'Assign');
    RegisterPropertyHelper(@TAxisGridPenCentered_R,@TAxisGridPenCentered_W,'Centered');
    RegisterPropertyHelper(@TAxisGridPenDrawEvery_R,@TAxisGridPenDrawEvery_W,'DrawEvery');
    RegisterPropertyHelper(@TAxisGridPenZPosition_R,@TAxisGridPenZPosition_W,'ZPosition');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartAxisTitle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartAxisTitle) do
  begin
    RegisterConstructor(@TChartAxisTitle.Create, 'Create');
    RegisterMethod(@TChartAxisTitle.Assign, 'Assign');
    RegisterMethod(@TChartAxisTitle.Clicked, 'Clicked');
    RegisterPropertyHelper(@TChartAxisTitleAngle_R,@TChartAxisTitleAngle_W,'Angle');
    RegisterPropertyHelper(@TChartAxisTitleCaption_R,@TChartAxisTitleCaption_W,'Caption');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartValueList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartValueList) do begin
    RegisterPropertyHelper(@TChartValueListValue_R,@TChartValueListValue_W,'Value');
    RegisterConstructor(@TChartValueList.Create, 'Create');
    RegisterMethod(@TChartValueList.Assign, 'Assign');
     RegisterMethod(@TChartValueList.Destroy, 'Free');
    //RegisterVirtualMethod(@TChartValueList.Count, 'Count');
    RegisterVirtualMethod(@TChartValueListDelete_P, 'Delete');
    RegisterMethod(@TChartValueListDelete1_P, 'Delete1');
    RegisterMethod(@TChartValueList.Exchange, 'Exchange');
    RegisterMethod(@TChartValueList.FillSequence, 'FillSequence');
    RegisterMethod(@TChartValueList.First, 'First');
    RegisterMethod(@TChartValueList.Last, 'Last');
    RegisterMethod(@TChartValueListLocate_P, 'Locate');
    RegisterMethod(@TChartValueListLocate1_P, 'Locate1');
    RegisterMethod(@TChartValueList.Range, 'Range');
    RegisterVirtualMethod(@TChartValueList.Scroll, 'Scroll');
    RegisterMethod(@TChartValueList.Sort, 'Sort');
    RegisterPropertyHelper(@TChartValueListMaxValue_R,nil,'MaxValue');
    RegisterPropertyHelper(@TChartValueListMinValue_R,nil,'MinValue');
    RegisterPropertyHelper(@TChartValueListModified_R,@TChartValueListModified_W,'Modified');
    RegisterPropertyHelper(@TChartValueListOwner_R,nil,'Owner');
    RegisterPropertyHelper(@TChartValueListTempValue_R,@TChartValueListTempValue_W,'TempValue');
    RegisterMethod(@TChartValueList.ToString, 'ToString');
    RegisterPropertyHelper(@TChartValueListTotal_R,nil,'Total');
    RegisterPropertyHelper(@TChartValueListTotalABS_R,@TChartValueListTotalABS_W,'TotalABS');
    RegisterPropertyHelper(@TChartValueListItems_R,@TChartValueListItems_W,'Items');
    RegisterPropertyHelper(@TChartValueListValue_R,@TChartValueListValue_W,'Value');
    RegisterPropertyHelper(@TChartValueListDateTime_R,@TChartValueListDateTime_W,'DateTime');
    RegisterPropertyHelper(@TChartValueListName_R,@TChartValueListName_W,'Name');
    RegisterPropertyHelper(@TChartValueListMultiplier_R,@TChartValueListMultiplier_W,'Multiplier');
    RegisterPropertyHelper(@TChartValueListOrder_R,@TChartValueListOrder_W,'Order');
    RegisterPropertyHelper(@TChartValueListValueSource_R,@TChartValueListValueSource_W,'ValueSource');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomChartElement(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomChartElement) do
  begin
    RegisterConstructor(@TCustomChartElement.Create, 'Create');
    RegisterMethod(@TCustomChartElement.Destroy, 'Free');
    RegisterMethod(@TCustomChartElement.Assign, 'Assign');
    RegisterMethod(@TCustomChartElement.EditorClass, 'EditorClass');
    RegisterMethod(@TCustomChartElement.Repaint, 'Repaint');
    RegisterPropertyHelper(@TCustomChartElementActive_R,@TCustomChartElementActive_W,'Active');
    RegisterPropertyHelper(@TCustomChartElementBrush_R,@TCustomChartElementBrush_W,'Brush');
    RegisterPropertyHelper(@TCustomChartElementParentChart_R,@TCustomChartElementParentChart_W,'ParentChart');
    RegisterPropertyHelper(@TCustomChartElementPen_R,@TCustomChartElementPen_W,'Pen');
    RegisterPropertyHelper(@TCustomChartElementVisible_R,@TCustomChartElementVisible_W,'Visible');
    RegisterPropertyHelper(@TCustomChartElementShowInEditor_R,@TCustomChartElementShowInEditor_W,'ShowInEditor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TeEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomAxisPanel) do
  RIRegister_TCustomChartElement(CL);
  with CL.Add(TCustomChartSeries) do
  with CL.Add(TChartSeries) do
  RIRegister_TChartValueList(CL);
  RIRegister_TChartAxisTitle(CL);
  with CL.Add(AxisException) do
  with CL.Add(TCustomSeriesList) do
  RIRegister_TAxisGridPen(CL);
  with CL.Add(TChartAxis) do
  with CL.Add(TAxisItems) do
  RIRegister_TAxisItem(CL);
  RIRegister_TAxisItems(CL);
  RIRegister_TChartAxisPen(CL);
  RIRegister_TChartAxis(CL);
  RIRegister_TChartDepthAxis(CL);
  RIRegister_TSeriesEnumerator(CL);
  RIRegister_TCustomSeriesList(CL);
  with CL.Add(TSeriesGroup) do
  with CL.Add(TSeriesGroups) do
  RIRegister_TChartSeriesList(CL);
  RIRegister_TSeriesGroup(CL);
  RIRegister_TSeriesGroups(CL);
  RIRegister_TChartAxes(CL);
  RIRegister_TChartCustomAxes(CL);
  RIRegister_TTeeCustomDesigner(CL);
  with CL.Add(TChartChangePage) do
  RIRegister_TTeeCustomTool(CL);
  RIRegister_TChartTools(CL);
  RIRegister_TTeeCustomToolSeries(CL);
  RIRegister_TTeeCustomToolAxis(CL);
  RIRegister_TChartPage(CL);
  RIRegister_TTeeSeriesEvent(CL);
  RIRegister_TCustomAxisPanel(CL);
  RIRegister_TSeriesMarkPosition(CL);
  with CL.Add(TSeriesMarks) do
  RIRegister_TSeriesMarksPositions(CL);
  RIRegister_TMarksItem(CL);
  RIRegister_TMarksItems(CL);
  RIRegister_TSeriesMarksGradient(CL);
  RIRegister_TSeriesPointer(CL);
  RIRegister_TCallout(CL);
  RIRegister_TMarksCallout(CL);
  RIRegister_TSeriesMarksSymbol(CL);
  RIRegister_TMarginsTe(CL);
  RIRegister_TSeriesMarks(CL);
  RIRegister_TTeeFunction(CL);
  RIRegister_TTeeMovingFunction(CL);
  RIRegister_TChartValueLists(CL);
  RIRegister_TCustomChartSeries(CL);
  RIRegister_TTeeSeriesType(CL);
  RIRegister_TLabelsList(CL);
  RIRegister_TDataSourcesList(CL);
  RIRegister_TChartSeries(CL);
  with CL.Add(ChartException) do
  RIRegister_TTeeSeriesSource(CL);
end;

 
 
{ TPSImport_TeEngine }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TeEngine.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TeEngine(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TeEngine.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TeEngine(ri);
  RIRegister_TeEngine_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
