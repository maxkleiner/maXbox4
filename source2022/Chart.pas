{******************************************}
{   TCustomChart & TChart Components       }
{ Copyright (c) 1995-2007 by David Berneda }
{    All Rights Reserved                   }
{******************************************}
unit Chart;
{$I TeeDefs.inc}

interface

uses {$IFNDEF LINUX}
     Windows,
     {$ENDIF}
     Classes, SysUtils,
     {$IFDEF CLX}
     QGraphics, QControls, QExtCtrls, QForms, QButtons, Types, Qt,
     {$ELSE}
     Graphics,
     Controls,
     {$IFDEF D9}
     Types,
     {$ENDIF}
     {$IFNDEF D5}
     {$IFNDEF LCL}
     Buttons,
     {$ENDIF}
     {$ENDIF}
     {$ENDIF}
     TeeProcs, TeEngine, TeCanvas;

Const TeeMsg_DefaultFunctionName = 'TeeFunction';  { <-- dont translate }
      TeeMsg_DefaultSeriesName   = 'Series';       { <-- dont translate }
      TeeMsg_DefaultToolName     = 'ChartTool';    { <-- dont translate }
      ChartComponentPalette      = 'TeeChart';     { <-- dont translate }

      TeeMaxLegendColumns        =  2;
      TeeDefaultLegendSymbolWidth= 20;

      // Default pixels distance between titles chart.
      // Corresponds to Chart1.Title.VertMargin property.
      TeeTitleFootDistance       =  5;

var   AnimatedZoomFactor   : Double=3.0;   { controls the animated zoom "speed" }
      TeeScrollKeyShift    : TShiftState=[];  { keys that should be pressed to start scroll }

      TeeUseMouseWheel     : Boolean=True;  { use the mouse wheel to scroll the axes }

type
  TCustomChartWall=class(TTeeCustomShape)
  private
    FAutoHide : Boolean;
    FDark3D   : Boolean;
    FEnd      : Integer;
    FSize     : Integer;
    FStart    : Integer;

    Function ApplyDark3D:Boolean;
    procedure CalcPositions(out ATop,ABottom:Integer);
    Function GetPen:TChartPen;
    Function HasGradient:Boolean;
    Procedure InitColor(const AColor:TColor);
    Function IsColorStored:Boolean;
    procedure SetAutoHide(const Value: Boolean);
    Procedure SetDark3D(const Value:Boolean);
    Procedure SetEnd(const Value:Integer);
    Procedure SetPen(const Value:TChartPen);
    Procedure SetSize(const Value:Integer);
    Procedure SetStart(const Value:Integer);
    Function TryDrawWall(const APos1,APos2:Integer):TTeeBlend;
  protected
    DefaultColor : TColor;

    procedure DoEndBlending(Blend:TTeeBlend);
    Function ShouldDraw:Boolean;
  public
    Constructor Create(AOwner:TCustomTeePanel); override;
    Procedure Assign(Source:TPersistent); override;

    property AutoHide:Boolean read FAutoHide write SetAutoHide default False;
    property Color stored IsColorStored nodefault;
    property Dark3D:Boolean read FDark3D write SetDark3D default True;
    property EndPosition:Integer read FEnd write SetEnd default 100;
    property Pen:TChartPen read GetPen write SetPen;
    property Size:Integer read FSize write SetSize default 0;
    property StartPosition:Integer read FStart write SetStart default 0;
    property Transparency;
  end;

  TChartWall=class(TCustomChartWall)
  published
    property AutoHide;  // 7.0
    property Brush;
    property Color;
    property Dark3D;
    property EndPosition; // 8.0
    property Gradient;
    property Pen;
    property Size;
    property StartPosition; // 8.0
    property Transparency;
    property Transparent;
    property Visible default True;
  end;

  TChartLegendGradient=class(TChartGradient)
  public
    Constructor Create(ChangedEvent:TNotifyEvent); override;
  published
    property Direction default gdRightLeft;
    property EndColor default clWhite;
    property StartColor default clSilver;
  end;

  { TCustomChartLegend Component }

  TLegendStyle    =(lsAuto,lsSeries,lsValues,lsLastValues,lsSeriesGroups);

  TLegendAlignment=(laLeft,laRight,laTop,laBottom);

  LegendException =class(Exception);

  TOnGetLegendText=Procedure( Sender:TCustomAxisPanel;
			      LegendStyle:TLegendStyle;
			      Index:Integer;
			      var LegendText:String) of Object;

  TCustomChartLegend=class;

  TLegendSymbolSize=(lcsPercent,lcsPixels);

  TLegendSymbolPosition=(spLeft,spRight);

  TSymbolDrawEvent=procedure(Sender:TObject; Series:TChartSeries;
                             ValueIndex:Integer; R:TRect) of object; // 7.0

  TSymbolCalcHeight=function:Integer of object; // 7.06

  TLegendSymbol=class(TPersistent)
  private
    FContinuous : Boolean;
    FDefaultPen : Boolean;
    FGradient   : TTeeGradient;
    FOnDraw     : TSymbolDrawEvent; // 7.0
    FPen        : TChartPen;
    FPosition   : TLegendSymbolPosition;
    FShadow     : TTeeShadow;
    FSquared    : Boolean;
    FVisible    : Boolean;
    FWidth      : Integer;
    FWidthUnits : TLegendSymbolSize;

    Procedure CanvasChanged(Sender:TObject);
    procedure Repaint;
    procedure SetBooleanProperty(var Variable:Boolean; const Value: Boolean);
    procedure SetContinuous(const Value: Boolean);
    procedure SetDefaultPen(const Value: Boolean);
    Procedure SetGradient(Value:TTeeGradient);
    procedure SetPen(const Value: TChartPen);
    Procedure SetPosition(Const Value:TLegendSymbolPosition);
    Procedure SetShadow(const Value:TTeeShadow);
    procedure SetSquared(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetWidth(Const Value: Integer);
    procedure SetWidthUnits(const Value: TLegendSymbolSize);
  protected
    CalcItemHeight : TSymbolCalcHeight;
    Function CalcWidth(Value:Integer):Integer;
    procedure Draw(AColor:TColor; const R:TRect);
  public
    Parent : TCustomTeePanel;

    Constructor Create(AParent:TCustomTeePanel);
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
  published
    property Continuous:Boolean read FContinuous write SetContinuous default False;
    property DefaultPen:Boolean read FDefaultPen write SetDefaultPen default True;
    property Gradient:TTeeGradient read FGradient write SetGradient;
    property Pen:TChartPen read FPen write SetPen;
    property Position:TLegendSymbolPosition read FPosition write SetPosition default spLeft;
    property Shadow:TTeeShadow read FShadow write SetShadow;
    property Squared:Boolean read FSquared write SetSquared default False;
    property Visible:Boolean read FVisible write SetVisible default True;
    property Width:Integer read FWidth write SetWidth default TeeDefaultLegendSymbolWidth;
    property WidthUnits:TLegendSymbolSize read FWidthUnits
                                 write SetWidthUnits default lcsPercent;

    property OnDraw:TSymbolDrawEvent read FOnDraw write FOnDraw;
  end;

  TTeeCustomShapePosition=class(TTeeCustomShape)
  private
    Function GetLeft:Integer; {$IFDEF D9}inline;{$ENDIF}
    Function GetTop:Integer; {$IFDEF D9}inline;{$ENDIF}
    function IsCustomStored:Boolean;
    procedure SetCustomPosition(Const Value:Boolean);
    procedure SetLeft(Const Value: Integer);
    procedure SetTop(Const Value: Integer);
  protected
    FCustomPosition : Boolean;

    {$IFDEF CLR}
  public
    {$ENDIF}

    DefaultCustom   : Boolean;
  public
    Procedure Assign(Source:TPersistent); override;

    property CustomPosition:Boolean read FCustomPosition write SetCustomPosition stored IsCustomStored;
    property Left:Integer read GetLeft write SetLeft stored FCustomPosition;
    property Top:Integer read GetTop write SetTop stored FCustomPosition;
  end;

  TCheckBoxesStyle=(cbsCheck, cbsRadio);

  TLegendTitle=class(TTeeShape)
  private
    FText      : TStringList;
    FTextAlign : TAlignment;

    procedure CalcHeight;
    procedure CalcShapeBounds(Const R:TRect);
    procedure SetText(const Value: TStringList);
    procedure SetTextAlign(const Value: TAlignment);
    procedure TextChanged(Sender:TObject);
    function TotalWidth:Integer;
    function GetCaption: String;
    procedure SetCaption(const Value: String);
  protected
    procedure DrawText;
  public
    Constructor Create(AOwner: TCustomTeePanel); override;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    property Caption:String read GetCaption write SetCaption;
  published
    property Text:TStringList read FText write SetText;
    property TextAlignment:TAlignment read FTextAlign
                                      write SetTextAlign default taLeftJustify;
    property TextFormat;
    property Visible default True;
  end;

  TLegendItem=class {$IFDEF CLR}sealed{$ENDIF} (TPersistent)
  private
    FAlign  : Integer;
    FLeft   : Integer;
    FSymbol : TRect;
    FText   : String;
    FText2  : String;
    FTop    : Integer;

    ILegend : TCustomChartLegend;
    procedure SetText(const Value:String);
    procedure SetText2(const Value:String);
    procedure SetTextVariable(var Variable:String; const Value:String);
  public
    property SymbolRect:TRect read FSymbol write FSymbol;
  published
    property Align:Integer read FAlign;
    property Left:Integer read FLeft;
    property Text:String read FText write SetText;
    property Text2:String read FText2 write SetText2;
    property Top:Integer read FTop;
  end;

  TLegendItems=class {$IFDEF CLR}sealed{$ENDIF}(TList)
  private
    FCustom : Boolean;
    ILegend : TCustomChartLegend;

    Procedure ClearItems;
    function Get(Index:Integer):TLegendItem;
  public
    Procedure Clear; override;

    property Custom:Boolean read FCustom write FCustom;
    property Items[Index:Integer]:TLegendItem read Get; default;
  end;

  TLegendCalcSize=procedure(Sender:TCustomChartLegend; var ASize:Integer) of object;

  TCustomChart=class;

  TCustomChartLegend=class(TTeeCustomShapePosition)
  private
    FAlignment       : TLegendAlignment;
    FCheckBoxes      : Boolean;
    FCheckBoxesStyle : TCheckBoxesStyle;
    FCurrentPage     : Boolean;
    FDividingLines   : TChartHiddenPen;
    FFirstValue      : Integer;
    FFontSeriesColor : Boolean;
    FHorizMargin     : Integer;
    FInverted        : Boolean;
    FItems           : TLegendItems;
    FLeftPercent     : Integer; // 7.06
    FLegendStyle     : TLegendStyle;
    FMaxNumRows      : Integer;
    FPosUnits        : TTeeUnits; // 7.06
    FResizeChart     : Boolean;
    FSeries          : TChartSeries;
    FSymbol          : TLegendSymbol;
    FTextStyle       : TLegendTextStyle;
    FTitle           : TLegendTitle;
    FTopLeftPos      : Integer;
    FTopPercent      : Integer; // 7.06
    FVertMargin      : Integer;
    FVertSpacing     : Integer;

    { Internal }
    IColorWidth  : Integer;
    ILastValue   : Integer;
    ITotalItems  : Integer;
    IDrawTitle   : Boolean;

    Function CalcItemHeight:Integer;
    Function FirstItemTop:Integer;
    function GetItem(Index:Integer):TLegendItem;
    Function GetLegendSeries:TChartSeries;
    Function GetRectLegend:TRect;
    Function GetSymbolWidth:Integer;
    Function GetVertical:Boolean;
    Function HasCheckBoxes:Boolean;
    Procedure PrepareSymbolPen;
    Procedure SetAlignment(Const Value:TLegendAlignment);
    Procedure SetCheckBoxes(Const Value:Boolean);
    Procedure SetCheckBoxesStyle(Const Value:TCheckBoxesStyle);
    procedure SetCurrentPage(Const Value: Boolean);
    Procedure SetDividingLines(Const Value:TChartHiddenPen);
    Procedure SetFirstValue(Const Value:Integer);
    procedure SetFontSeriesColor(const Value: Boolean);
    Procedure SetHorizMargin(Const Value:Integer);
    Procedure SetInverted(Const Value:Boolean);
    Procedure SetLeftPercent(Const Value:Integer);
    Procedure SetLegendStyle(Const Value:TLegendStyle);
    Procedure SetMaxNumRows(Const Value:Integer);
    Procedure SetPosUnits(Const Value:TTeeUnits);
    Procedure SetResizeChart(Const Value:Boolean);
    Procedure SetSeries(Const Value:TChartSeries);
    Procedure SetSymbol(Const Value:TLegendSymbol);
    Procedure SetSymbolWidth(Const Value:Integer);
    Procedure SetTextStyle(Const Value:TLegendTextStyle);
    procedure SetTitle(const Value: TLegendTitle);
    Procedure SetTopLeftPos(Const Value:Integer);
    Procedure SetTopPercent(Const Value:Integer);
    Procedure SetVertMargin(Const Value:Integer);
    Procedure SetVertSpacing(Const Value:Integer);
  protected
    InternalLegendStyle : TLegendStyle;
    FOnCalcSize         : TLegendCalcSize;

    Procedure CalcLegendStyle;
    Function DoMouseDown(Const x,y:Integer; PointIndex:Integer):Boolean;
    Function GetGradientClass:TChartGradientClass; override;
  public
    NumCols        : Integer;
    NumRows        : Integer;
    ColumnWidthAuto: Boolean;
    ColumnWidths   : Array[0..TeeMaxLegendColumns-1] of Integer;

    Constructor Create(AOwner:TCustomTeePanel); override;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Function Clicked(x,y:Integer):Integer;
    Procedure DrawLegend;
    Function FormattedValue(ASeries:TChartSeries; ValueIndex:Integer):String;
    Function FormattedLegend(Index:Integer):String;
    Function ShouldDraw:Boolean;  // 6.02
    property TotalLegendItems:Integer read ITotalItems;

    { public properties }
    property RectLegend:TRect read GetRectLegend;
    property Vertical:Boolean read GetVertical;

    { to be published }
    property Alignment:TLegendAlignment read FAlignment write SetAlignment
					default laRight;
    property CheckBoxes:Boolean read FCheckBoxes write SetCheckBoxes default False;
    property CheckBoxesStyle:TCheckBoxesStyle read FCheckBoxesStyle write SetCheckBoxesStyle default cbsCheck;
    property ColorWidth:Integer read GetSymbolWidth write SetSymbolWidth default TeeDefaultLegendSymbolWidth;
    property CurrentPage:Boolean read FCurrentPage write SetCurrentPage default True;
    property DividingLines:TChartHiddenPen read FDividingLines write SetDividingLines;
    property FirstValue:Integer read FFirstValue write SetFirstValue default 0;
    property FontSeriesColor:Boolean read FFontSeriesColor write SetFontSeriesColor default False;
    property HorizMargin:Integer read FHorizMargin write SetHorizMargin default 0;
    property Inverted:Boolean read FInverted write SetInverted default False;
    property Item[Index:Integer]:TLegendItem read GetItem; default;
    property Items:TLegendItems read FItems;
    property LastValue:Integer read ILastValue;  // 6.02
    property LeftPercent:Integer read FLeftPercent write SetLeftPercent default 0;
    property LegendStyle:TLegendStyle read FLegendStyle
				      write SetLegendStyle default lsAuto;
    property MaxNumRows:Integer read FMaxNumRows write SetMaxNumRows default 10;
    property PositionUnits:TTeeUnits read FPosUnits write SetPosUnits default muPixels;
    property ResizeChart:Boolean read FResizeChart write SetResizeChart default True;
    property Series:TChartSeries read FSeries write SetSeries;
    property Symbol:TLegendSymbol read FSymbol write SetSymbol;
    property TextStyle:TLegendTextStyle read FTextStyle
					write SetTextStyle default ltsLeftValue;
    property Title:TLegendTitle read FTitle write SetTitle;
    property TopPercent:Integer read FTopPercent write SetTopPercent default 0;
    property TopPos:Integer read FTopLeftPos write SetTopLeftPos default 10;
    property VertMargin:Integer read FVertMargin write SetVertMargin default 0;
    property VertSpacing:Integer read FVertSpacing write SetVertSpacing default 0;
    property Visible default True;
  end;

  TChartLegend=class(TCustomChartLegend)
  published
    property Alignment;
    property Bevel;
    property BevelWidth;
    property Brush;
    property CheckBoxes;
    property CheckBoxesStyle;
    property Color;
    property ColorWidth;
    property CurrentPage;
    property CustomPosition;
    property DividingLines;
    property FirstValue;
    property Font;
    property FontSeriesColor;
    property Frame;
    property Gradient;
    property HorizMargin;
    property Inverted;
    property Left;
    property LeftPercent;
    property LegendStyle;
    property MaxNumRows;
    property Picture;
    property PositionUnits;
    property ResizeChart;
    property Shadow;
    property ShapeStyle;
    property Symbol;
    property TextStyle;
    property Title;
    property Top;
    property TopPercent;
    property TopPos;
    property Transparency;
    property Transparent;
    property VertMargin;
    property VertSpacing;
    property Visible;
  end;

  TChartTitle=class(TTeeCustomShapePosition)
  private
    FAdjustFrame : Boolean;
    FAlignment   : TAlignment;
    FText        : TStrings;
    FVertMargin  : Integer;

    IOnTop       : Boolean;
    function GetCaption: String;
    Function GetShapeBounds:TRect;
    Procedure SetAdjustFrame(Value:Boolean);
    Procedure SetAlignment(Value:TAlignment);
    procedure SetCaption(const Value: String);
    Procedure SetText(Value:TStrings);
    Procedure SetVertMargin(const Value:Integer);
  public
    Constructor Create(AOwner: TCustomTeePanel); override;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    procedure Clear;
    Function Clicked(x,y:Integer):Boolean;
    procedure DrawTitle;

    property Caption:String read GetCaption write SetCaption;
    property TitleRect:TRect read GetShapeBounds;
  published
    property AdjustFrame:Boolean read FAdjustFrame write SetAdjustFrame
				 default True;
    property Alignment: TAlignment read FAlignment
				   write SetAlignment default taCenter;
    property Bevel;
    property BevelWidth;
    property Brush;
    property Color;
    property CustomPosition;
    property Font;
    property Frame;
    property Gradient;
    property Left;
    property Picture;
    property Shadow;
    property ShapeStyle;
    property Text:TStrings read FText write SetText;
    property TextFormat;
    property Top;
    property Transparency;
    property Transparent default True;
    property VertMargin:Integer read FVertMargin write SetVertMargin
                                default TeeTitleFootDistance;
    property Visible default True;
  end;

  TChartFootTitle=class(TChartTitle)
  public
    Constructor Create(AOwner: TCustomTeePanel); override;
  end;

  TChartClick=procedure( Sender:TCustomChart;
			 Button:TMouseButton;
			 Shift: TShiftState;
			 X, Y: Integer) of object;

  TChartClickAxis=procedure( Sender:TCustomChart;
			     Axis:TChartAxis;
			     Button:TMouseButton;
			     Shift: TShiftState;
			     X, Y: Integer) of object;

  TChartClickSeries=procedure( Sender:TCustomChart;
			       Series:TChartSeries;
			       ValueIndex:Integer;
			       Button:TMouseButton;
			       Shift: TShiftState;
			       X, Y: Integer) of object;

  TChartClickTitle=procedure( Sender:TCustomChart;
			      ATitle:TChartTitle;
			      Button:TMouseButton;
			      Shift: TShiftState;
			      X, Y: Integer) of object;

  TOnGetLegendPos=Procedure( Sender:TCustomChart; Index:Integer;
			     var X,Y,XColor:Integer) of object;

  TOnGetLegendRect=Procedure( Sender:TCustomChart; var Rect:TRect) of object;

  TAxisSavedScales=Record
    Auto    : Boolean;
    AutoMin : Boolean;
    AutoMax : Boolean;
    Min     : Double;
    Max     : Double;
  end;

  TAllAxisSavedScales=Array of TAxisSavedScales;

  TChartBackWall=class(TChartWall)
  public
    Constructor Create(AOwner: TCustomTeePanel); override;
  published
    property Color default clSilver;
    property Picture;
    property Shadow;  // 8.01
    property Transparent default True;
  end;

  TChartRightWall=class(TChartWall)
  published
    property Color default clSilver;
    property Picture;
    property Visible default False;
  end;

  TChartBottomWall=class(TChartWall)
  published
    property Picture;
  end;

  TChartLeftWall=class(TChartWall)
  published
    property Picture;
  end;

  TChartWalls=class(TPersistent)
  private
    FBack   : TChartBackWall;
    FBottom : TChartBottomWall;
    FChart  : TCustomChart;
    FLeft   : TChartLeftWall;
    FRight  : TChartRightWall;

    function GetVisible: Boolean;
    procedure SetBack(const Value: TChartBackWall);
    procedure SetBottom(const Value: TChartBottomWall);
    procedure SetLeft(const Value: TChartLeftWall);
    procedure SetRight(const Value: TChartRightWall);
    procedure SetSize(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
  public
    Constructor Create(Chart:TCustomChart);
    Destructor Destroy; override;
    Procedure Assign(Source:TPersistent); override;

    property Back:TChartBackWall read FBack write SetBack;
    property Bottom:TChartBottomWall read FBottom write SetBottom;
    property Left:TChartLeftWall read FLeft write SetLeft;
    property Right:TChartRightWall read FRight write SetRight;
    property Size:Integer write SetSize;  // 7.0
    property Visible:Boolean read GetVisible write SetVisible;
  end;

  TChartAllowScrollEvent=Procedure( Sender:TChartAxis; var AMin,AMax:Double;
				    var AllowScroll:Boolean ) of object;

  TCustomChart=class(TCustomAxisPanel)
  private
    {$IFNDEF CLR}
    FColorPaletteIndex : Integer;
    {$ENDIF}
 
    FFoot              : TChartTitle;
    FLegend            : TChartLegend;
    FSavedScales       : TAllAxisSavedScales;
    FScrollMouse       : TMouseButton;
    FSubFoot           : TChartTitle;
    FSubTitle          : TChartTitle;
    FTitle             : TChartTitle;
    FWalls             : TChartWalls;

    { events }
    FOnAllowScroll     : TChartAllowScrollEvent;
    FOnClickAxis       : TChartClickAxis;
    FOnClickBackGround : TChartClick;
    FOnClickLegend     : TChartClick;
    FOnClickSeries     : TChartClickSeries;
    FOnClickTitle      : TChartClickTitle;
    FOnGetLegendPos    : TOnGetLegendPos;
    FOnGetLegendRect   : TOnGetLegendRect;
    FOnGetLegendText   : TOnGetLegendText;

    Function ActiveSeriesUseAxis:Boolean;
    procedure BroadcastMouseEvent(AEvent:TChartMouseEvent;
                         Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    //procedure BroadcastWheelEvent(AEvent:TWheelMouseEvent;
      //                   WheelDelta:Integer; X, Y: Integer);
    Function CalcNeedClickedPart(Pos:TPoint; Needed:Boolean):TChartClickedPart;
    function CanWheelScroll:Boolean;
    Procedure DrawBackWall;
    Procedure DrawLeftWall;
    Procedure DrawRightWall;
    Function DrawWallFirst(APos:Integer):Boolean;
    function GetBackWall: TChartBackWall;
    function GetBottomWall: TChartBottomWall;
    Function GetFrame:TChartPen;
    function GetLeftWall: TChartLeftWall;
    function GetRightWall: TChartRightWall;
    Procedure PrepareWallCanvas(AWall:TChartWall);
    procedure ReadBackColor(Reader: TReader);
    procedure ReadColorPalette(Reader: TReader);
    Procedure RestoreScales(var Saved:TAllAxisSavedScales);
    Function SaveScales:TAllAxisSavedScales;
    Procedure ScrollVerticalAxes(Up:Boolean);
    Procedure SetBackColor(Value:TColor);
    Procedure SetBackWall(Value:TChartBackWall);
    Procedure SetBottomWall(Value:TChartBottomWall);
    procedure SetColorPaletteIndex(const Value:Integer);
    Procedure SetFoot(Value:TChartTitle);
    Procedure SetFrame(Value:TChartPen);
    Procedure SetLeftWall(Value:TChartLeftWall);
    Procedure SetLegend(Value:TChartLegend);
    Procedure SetRightWall(Value:TChartRightWall);
    procedure SetSubFoot(const Value: TChartTitle);
    procedure SetSubTitle(const Value: TChartTitle);
    procedure SetTitle(Value:TChartTitle);
    procedure SetWalls(Value:TChartWalls);
    procedure WriteColorPalette(Writer: TWriter);
    procedure SetScrollMouseButton(const Value: TMouseButton);
  protected
    RestoredAxisScales : Boolean;

    Procedure CalcWallsRect; override;
    Function CalcWallSize(Axis:TChartAxis):Integer; override;
    Procedure CalcZoomPoints; dynamic;
    Procedure DefineProperties(Filer:TFiler); override;

    {$IFDEF CLX}
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
                          const MousePos: TPoint): Boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; const MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; const MousePos: TPoint): Boolean; override;
    {$ELSE}
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
                          MousePos: TPoint): Boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    {$ENDIF}

    Procedure DoZoom(Const TopI,TopF,BotI,BotF,LefI,LefF,RigI,RigF:Double);

    {$IFNDEF CLR}
    Function DrawLeftWallFirst:Boolean;
    Function DrawRightWallAfter:Boolean;
    {$ENDIF}

    procedure DrawLegendShape(const Rect:TRect); override; // 7.05
    procedure DrawTitlesAndLegend(BeforeSeries:Boolean); override;
    Procedure DrawWalls; override;

    {$IFNDEF CLR}
    Function GetBackColor:TColor; override;

    {$IFNDEF D11}
    Procedure GetChildren(Proc:TGetChildProc; Root:TComponent); override;
    {$ENDIF}

    {$ENDIF}

    Function InternalFormattedLegend( ALegend:TCustomChartLegend;
                                      SeriesOrValueIndex:Integer):String;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    {$IFDEF CLR}
    FColorPaletteIndex : Integer;
    {$ENDIF}

    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Function AxisTitleOrName(Axis:TChartAxis):String;
    Procedure CalcClickedPart(Pos:TPoint; var Part:TChartClickedPart);

    {$IFDEF CLR}
    Function DrawLeftWallFirst:Boolean;
    Function DrawRightWallAfter:Boolean;
    {$ENDIF}

    Procedure FillSeriesSourceItems(ASeries:TChartSeries; Proc:TGetStrProc); dynamic;
    Procedure FillValueSourceItems(ValueList:TChartValueList; Proc:TGetStrProc); dynamic;
    Function GetASeries:TChartSeries; { return first active Series }

    {$IFDEF CLR}
    Function GetBackColor:TColor; override;
    Procedure GetChildren(Proc:TGetChildProc; Root:TComponent); override;
    {$ELSE}
    {$IFDEF D11}
    Procedure GetChildren(Proc:TGetChildProc; Root:TComponent); override;
    {$ENDIF}
    {$ENDIF}

    Function IsFreeSeriesColor(AColor:TColor; CheckBackground:Boolean;
                               ASeries:TChartSeries=nil):Boolean; override;
    Procedure NextPage;
    Procedure PreviousPage;
    Procedure RemoveAllSeries;
    Procedure SeriesDown(ASeries:TChartSeries);
    Procedure SeriesUp(ASeries:TChartSeries);
    procedure UndoZoom; override;
    Procedure ZoomPercent(Const PercentZoom:Double);
    Procedure ZoomRect(Const Rect:TRect);
    Function FormattedValueLegend(ASeries:TChartSeries; ValueIndex:Integer):String; override;
    Function FormattedLegend(SeriesOrValueIndex:Integer):String;

    property BackColor:TColor read GetBackColor write SetBackColor; { compatibility }
    property ColorPaletteIndex:Integer read FColorPaletteIndex write SetColorPaletteIndex;
    property Walls:TChartWalls read FWalls write SetWalls;

    { to be published }
    property BackWall:TChartBackWall read GetBackWall write SetBackWall;
    property Frame:TChartPen read GetFrame write SetFrame;
    property BottomWall:TChartBottomWall read GetBottomWall write SetBottomWall;
    property Foot:TChartTitle read FFoot write SetFoot;
    property LeftWall:TChartLeftWall read GetLeftWall write SetLeftWall;
    property Legend:TChartLegend read FLegend write SetLegend;
    property RightWall:TChartRightWall read GetRightWall write SetRightWall;
    property ScrollMouseButton:TMouseButton read FScrollMouse write SetScrollMouseButton default mbRight;
    property SubFoot:TChartTitle read FSubFoot write SetSubFoot;
    property SubTitle:TChartTitle read FSubTitle write SetSubTitle;
    property Title:TChartTitle read FTitle write SetTitle;

    { events }
    property OnAllowScroll:TChartAllowScrollEvent read FOnAllowScroll write FOnAllowScroll;
    property OnClickAxis:TChartClickAxis read FOnClickAxis write FOnClickAxis;
    property OnClickBackground:TChartClick read FOnClickbackground write FOnClickBackGround;
    property OnClickLegend:TChartClick read FOnClickLegend write FOnClickLegend;
    property OnClickSeries:TChartClickSeries read FOnClickSeries write FOnClickSeries;
    property OnClickTitle:TChartClickTitle read FOnClickTitle write FOnClickTitle;
    property OnGetLegendPos:TOnGetLegendPos read FOnGetLegendPos write FOnGetLegendPos;
    property OnGetLegendRect:TOnGetLegendRect read FOnGetLegendRect write FOnGetLegendRect;
    property OnGetLegendText:TOnGetLegendText read FOnGetLegendText write FOnGetLegendText;

    { TPanel properties }
    property Align;

    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    {$IFDEF CLX}
    property Bitmap;
    {$ENDIF}
    property BorderWidth;
    property Color;
    {$IFNDEF CLX}
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    {$ENDIF}
    property DragMode;
    property Enabled;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    property Anchors;
    {$IFNDEF CLX}
    property AutoSize;
    {$ENDIF}
    property Constraints;
    {$IFNDEF CLX}
    property DragKind;
    {$IFNDEF LCL}
    property Locked;
    {$ENDIF}
    {$ENDIF}

    { TPanel events }
    property OnClick;
    {$IFDEF D5}
    property OnContextPopup;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnStartDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    {$IFNDEF CLX}
    {$IFNDEF LCL}
    property OnCanResize;
    {$ENDIF}
    {$ENDIF}
    property OnConstrainedResize;
    {$IFNDEF CLX}
    property OnDockDrop;
    property OnDockOver;
    property OnEndDock;
    property OnGetSiteInfo;
    property OnStartDock;
    property OnUnDock;
    {$ENDIF}

    {$IFDEF K3}
    property OnMouseEnter;
    property OnMouseLeave;
    {$ELSE}
    {$IFDEF D10}
    property OnMouseEnter;
    property OnMouseLeave;
    {$ENDIF}
    {$ENDIF}
  end;

  TChart=class(TCustomChart)
  {$IFNDEF CLX}
  public
    property DockManager;
  {$ENDIF}
  published
    { TCustomChart Properties }
    property AllowPanning;
    property BackImage;
    property BackImageInside;
    property BackImageMode;
    property BackImageTransp;
    property BackWall;
    property Border;
    property BorderRound;
    property BottomWall;
    property Foot;
    property Gradient;
    property LeftWall;
    property Legend;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property MarginTop;
    property MarginUnits;
    property PrintProportional;
    property RightWall;
    property ScrollMouseButton;
    property SubFoot;
    property SubTitle;
    property Title;

    { TCustomChart Events }
    property OnAllowScroll;
    property OnClickAxis;
    property OnClickBackground;
    property OnClickLegend;
    property OnClickSeries;
    property OnClickTitle;
    property OnGetLegendPos;
    property OnGetLegendRect;
    property OnScroll;
    property OnUndoZoom;
    property OnZoom;

    { TCustomAxisPanel properties }
    property AxisBehind;
    property AxisVisible;
    property BottomAxis;
    property Chart3DPercent;
    property ClipPoints;
    property DepthAxis;
    property DepthTopAxis;
    property CustomAxes;
    property Frame;
    property LeftAxis;
    property Monochrome;
    //property Pages;
    property RightAxis;
    //property SeriesGroups;
    property SeriesList;
    property Shadow;
    property Tools;
    property TopAxis;
    property View3D;
    property View3DOptions;
    property View3DWalls;
    property Zoom;

    { TCustomAxisPanel events }
    //property OnAddSeries;
    property OnAfterDraw;
    property OnBeforeDrawAxes;
    property OnBeforeDrawChart;
    property OnBeforeDrawSeries;
    property OnBeforePrint;
    property OnGetAxisLabel;
    property OnGetLegendText;
    property OnGetNextAxisLabel;
    property OnPageChange;
    //property OnRemoveSeries;

    { TPanel properties }
    property Align;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property Color;
    {$IFNDEF CLX}
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragMode;
    {$ELSE}
    property DragMode;
    {$ENDIF}
    property Enabled;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property Anchors;
    {$IFNDEF CLX}
    property AutoSize;
    {$ENDIF}
    property Constraints;
    {$IFNDEF CLX}
    property DragKind;
    {$IFNDEF LCL}
    property Locked;
    {$ENDIF}
    {$ENDIF}

    {$IFDEF CLX}
    property Bitmap;
    {$ENDIF}

    { TPanel events }
    property OnClick;
    {$IFDEF D5}
    property OnContextPopup;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnStartDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;

    {$IFDEF K3}
    property OnMouseEnter;
    property OnMouseLeave;
    {$ELSE}
    {$IFDEF D10}
    property OnMouseEnter;
    property OnMouseLeave;
    {$ENDIF}
    {$ENDIF}

    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    {$IFNDEF CLX}
    {$IFNDEF LCL}
    property OnCanResize;
    {$ENDIF}
    {$ENDIF}
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnConstrainedResize;
    {$IFNDEF CLX}
    property OnDockDrop;
    property OnDockOver;
    property OnEndDock;
    property OnGetSiteInfo;
    property OnStartDock;
    property OnUnDock;
    {$ENDIF}
  end;

  TTeeSeriesTypes=class(TList)
  private
    Function Get(Index:Integer):TTeeSeriesType;
  public
    Procedure Clear; override;
    Function Find(ASeriesClass:TChartSeriesClass):TTeeSeriesType;
    property Items[Index:Integer]:TTeeSeriesType read Get; default;
  end;

  TTeeToolTypes=class(TList)
  private
    Function Get(Index:Integer):TTeeCustomToolClass;
  public
    property Items[Index:Integer]:TTeeCustomToolClass read Get; default;
  end;

  {$IFNDEF CLX}
  TTeeDragObject = class(TDragObject)
  private
    FPart: TChartClickedPart;
  protected
    function GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor; override;
    procedure Finished(Target: TObject; X, Y: Integer; Accepted: Boolean); override;
  public
    constructor Create(Const APart: TChartClickedPart);
    property Part: TChartClickedPart read FPart;
  end;
  {$ENDIF}

  TColorPalettes=class(TStringList)
  public
    class procedure AddTo(const Items:TStrings; AddDefault:Boolean=False);
    class procedure ApplyPalette(Chart:TCustomAxisPanel; Index:Integer); overload; {$IFDEF CLR}static;{$ENDIF}
    class procedure ApplyPalette(Chart:TCustomAxisPanel; const Palette:Array of TColor); overload; {$IFDEF CLR}static;{$ENDIF} 
  end;

var
  ColorPalettes : TColorPalettes=nil;

  TeeSeriesTypes: TTeeSeriesTypes=nil; { List of Series types }
  TeeToolTypes: TTeeToolTypes=nil; { List of Tool types }

{ Adds a new Series component definition for the Gallery }
{ Setting ANumGallerySeries to zero makes the Series to not appear on the
  Gallery. }
Procedure RegisterTeeSeries( ASeriesClass:TChartSeriesClass;
			     ADescription,AGalleryPage:PString;
			     ANumGallerySeries : Integer ); overload;

// Same as above, at default "Standard" tab with NumSeries = 2
Procedure RegisterTeeSeries( ASeriesClass:TChartSeriesClass;
			     ADescription:PString); overload;

{ Adds a new Function component definition for the Gallery }
Procedure RegisterTeeFunction( AFunctionClass:TTeeFunctionClass;
			       ADescription,AGalleryPage:PString;
			       ANumGallerySeries : Integer=1 );

{ Adds a new Function component to the basic functions gallery }
Procedure RegisterTeeBasicFunction( AFunctionClass:TTeeFunctionClass;
				    ADescription:PString);

{ Adds a new Series & Function components definition for the Gallery }
Procedure RegisterTeeSeriesFunction( ASeriesClass:TChartSeriesClass;
				     AFunctionClass:TTeeFunctionClass;
				     ADescription,AGalleryPage:PString;
				     ANumGallerySeries:Integer=1;
             ASubIndex:Integer=0);

{ Removes Series from Gallery }
Procedure UnRegisterTeeSeries(Const ASeriesList:Array of TChartSeriesClass);

{ Removes Functions from Gallery }
Procedure UnRegisterTeeFunctions(Const AFunctionList:Array of TTeeFunctionClass);

{ Assigns all Series properties from Old to New. (Data values ARE assigned). }
Procedure AssignSeries(var OldSeries,NewSeries:TChartSeries);

{ Creates a new "class" TeeFunction and sets its ParentSeries to ASeries }
Function CreateNewTeeFunction( ASeries:TChartSeries;
			       AClass:TTeeFunctionClass):TTeeFunction;

{ Creates a new "class" TChartSeries and sets its ParentChart to AChart }
Function CreateNewSeries( AOwner:TComponent;
			  AChart:TCustomAxisPanel;
			  AClass:TChartSeriesClass;
			  AFunctionClass:TTeeFunctionClass=nil):TChartSeries;

// Creates a new Series that is a copy of ASeries.
Function CloneChartSeries(ASeries:TChartSeries):TChartSeries; overload;
Function CloneChartSeries(ASeries:TChartSeries; AChart:TCustomAxisPanel):TChartSeries; overload;
Function CloneChartSeries(ASeries:TChartSeries; AOwner:TComponent; AChart:TCustomAxisPanel):TChartSeries; overload;

// Duplicates a Chart Tool. Adds the new Tool to ATool.ParentChart
function CloneChartTool(ATool:TTeeCustomTool; AOwner:TComponent):TTeeCustomTool;

Function ChangeSeriesType(var ASeries:TChartSeries; NewType:TChartSeriesClass ):TChartSeries;

procedure ChangeAllSeriesType( AChart:TCustomChart; AClass:TChartSeriesClass );

Function GetNewSeriesName(AOwner:TComponent):TComponentName;

Procedure RegisterTeeTools({$IFNDEF BCB}const{$ENDIF} ATools:Array of TTeeCustomToolClass);
Procedure UnRegisterTeeTools({$IFNDEF BCB}const{$ENDIF} ATools:Array of TTeeCustomToolClass);

{ Returns the name of a Series in it´s "gallery" style:
   TLineSeries returns "Line"
   TPieSeries returns "Pie"
   etc.
}
Function GetGallerySeriesName(ASeries:TChartSeries):String;

{ Draws the Series "Legend" on the specified rectangle and Canvas }
Procedure PaintSeriesLegend(ASeries:TChartSeries; ACanvas:TCanvas; Const R:TRect;
                            ReferenceChart:TCustomChart=nil);  // 7.0

var
  TeePageNumToolClass : TTeeCustomToolClass = nil;

type
  TChartTheme=class(TPersistent)
  protected
    procedure ChangeAxis(Axis:TChartAxis); virtual;
  public
    Chart : TCustomChart;

    constructor Create(AChart: TCustomChart); {$IFDEF CLR}overload;{$ENDIF} virtual;

    procedure Apply; virtual;
    function Description:string; virtual;
  end;

  TChartThemeClass=class of TChartTheme;
  TTeeThemeSelectorProc=Function(Chart:TCustomChart):TChartThemeClass;

  TCanvasClass=class of TCanvas3D;

var
  TeeThemeSelectorHook : TTeeThemeSelectorProc=nil;
  TeeNewChartHook      : TTeeThemeSelectorProc=nil;
  TeeAntiAliasCanvas   : TCanvasClass=nil;

const
  ExcelPalette:Array[0..21] of TColor=
  (
    $FF9999,
    $663399,
    $CCFFFF,
    $FFFFCC,
    $660066,
    $8080FF,
    $CC6600,
    $FFCCCC,
    $800000,
    $FF00FF,
    $00FFFF,
    $FFFF00,
    $800080,
    $000080,
    $808000,
    $FF0000,
    $FFCC00,
    $FFFFCC,
    $CCFFCC,
    $00FFFF,
    $FFCC99,
    $CC99FF
  );

  VictorianPalette:Array[0..10] of TColor=
  (
    $A1A55D,
    $3153C4,
    $0996E7,
    $4AE8F6,
    $A7A2B1,
    $84A7C9,
    $51798C,
    $B7CDD8,
    $536508,
    $7BD8F7,
    $846401
  );

  PastelsPalette:Array[0..13] of TColor=
  (
    $FFFFCC,
    $CCFFFF,
    $FFCCCC,
    $CCCC00,
    $CCCCCC,
    $999900,
    $999999,
    $CCCCFF,
    $66CCFF,
    $FFCCCC,
    $9999FF,
    $99FFFF,
    $FFCC99,
    $CCFFCC
  );

  SolidPalette:Array[0..7] of TColor=
  (
    $FF0000,
    $0000FF,
    $00FF00,
    $00CCFF,
    $404040,
    $00FFFF,
    $C000FF,
    $FFFFFF
  );

  ClassicPalette:Array[0..11] of TColor=
  (
    $FF0000,
    $00FF00,
    $FFFF00,
    $0000FF,
    $FF00FF,
    $00FFFF,
    $800000,
    $008000,
    $808000,
    $000080,
    $800080,
    $008080
  );

  WebPalette:Array[0..8] of TColor=
  (
    $00A5FF,
    $CE0000,
    $00CE00,
    $40FFFF,
    $FFFF40,
    $FF40FF,
    $0040FF,
    $A58080,
    $408080
  );

  ModernPalette:Array[0..13] of TColor=
  (
    $6699FF,
    $6666FF,
    $FFCC99,
    $669966,
    $99CCCC,
    $CC6699,
    $6666CC,
    $99CCFF,
    $FF6699,
    $CCCCCC,
    $CCFF66,
    $FF9966,
    $996699,
    $FFCCCC 
  );

  RainbowPalette:Array[0..24] of TColor=
  (
    $000099,
    $0000C3,
    $0000EE,
    $001AFF,
    $0046FF,
    $0073FF,
    $009FFF,
    $00CBFF,
    $00F7FF,
    $08F4E3,
    $11E7C3,
    $1BDAA3,
    $25CD83,
    $2EC063,
    $38B342,
    $42A622,
    $4B9A02,
    $6A870C,
    $8A751A,
    $AA6328,
    $CB5036,
    $EB3E44,
    $FF2A61,
    $FF1596,
    $FF00CC
  );

  WindowsXPPalette:Array[0..12] of TColor=
  (
    $FE9B82,
    $24D1FC,
    $0DBC7C,
    $2F85FD,
    $FCFEFD,
    $214EE2,
    $D63829,
    $0094B7,
    $00865A,
    $0046D2,
    $FAE5D3,
    $D8D8D8,
    $7B715F
  );

  MacOSPalette:Array[0..15] of TColor=
  (
    $FFFFFF,
    $05F3FC,
    $0264FF,
    $0608DD,
    $8408F2,
    $A50046,
    $D40000,
    $EAAB02,
    $14B71F,
    $116400,
    $052C56,
    $3A7190,
    $C0C0C0,
    $808080,
    $404040,
    $000000
  );

  WindowsVistaPalette:Array[0..14] of TColor=
  (
    $D21F00,
    $0102E0,
    $02661E,
    $7ECDE8,
    $ACABAF,
    $D9D0A4,
    $3C3B3D,
    $31DD95,
    $01009E,
    $74F7DC,
    $FDFD45,
    $748ED1,
    $91D8A0,
    $657AD5,
    $D99596
  );

  GrayScalePalette:Array[0..14] of TColor=
  (
    $f0f0f0,
    $e0e0e0,
    $d0d0d0,
    $c0c0c0,
    $b0b0b0,
    $a0a0a0,
    $909090,
    $808080,
    $707070,
    $606060,
    $505050,
    $404040,
    $303030,
    $202020,
    $101010
  );

  OperaPalette:Array[0..11] of TColor=
  (
    $a36644,
    $359cf3,
    $144cf1,
    $a8974e,
    $6b402b,
    $637b1d,
    $0e08b3,
    $5dc0f2,
    $9eb75d,
    $707070,
    $8deaf3,
    $b4b4b4
  );

  WarmPalette:Array[0..7] of TColor=
  (
    $8deaf3,
    $5dc0f2,
    $359cf3,
    $1c81f5,
    $156bf3,
    $144cf1,
    $0a18e6,
    $0e08b3
  );

  CoolPalette:Array[0..7] of TColor=
  (
    $6b402b,
    $8c543b,
    $a36644,
    $a8974e,
    $9eb75d,
    $8aa041,
    $7d922b,
    $637b1d
  );

implementation

Uses {$IFNDEF D5}
     {$IFNDEF LCL}
     DsgnIntf,
     {$ENDIF}
     {$ENDIF}

     {$IFDEF LCL}
     GraphType,
     {$ENDIF}

     Math, TeeHtml, TeeConst;

{ TCustomChartWall }
Constructor TCustomChartWall.Create(AOwner:TCustomTeePanel);
Begin
  inherited;
  FDark3D:=True;
  FEnd:=100;
  Color:=clTeeColor;
  DefaultColor:=clTeeColor;
End;

Function TCustomChartWall.IsColorStored:Boolean;
begin
  result:=Color<>DefaultColor;
end;

Procedure TCustomChartWall.Assign(Source:TPersistent);
Begin
  if Source is TCustomChartWall then
  With TCustomChartWall(Source) do
  Begin
    Self.FAutoHide:=AutoHide;
    Self.FDark3D:=Dark3D;
    Self.FEnd:=EndPosition;
    Self.FSize:=Size;
    Self.FStart:=StartPosition;
  end;

  inherited;
End;

Function TCustomChartWall.ApplyDark3D:Boolean;
begin
  result:=(Brush.Style<>bsClear) and
          ((Brush.Bitmap=nil) {$IFDEF CLX}or (Brush.Bitmap.Empty){$ENDIF}) and
          Dark3D;
end;

Function TCustomChartWall.GetPen:TChartPen;
begin
  result:=Frame;
end;

type
  TTeePanelAccess=class(TCustomTeePanel);

Procedure TCustomChartWall.SetDark3D(const Value:Boolean);
begin
  TTeePanelAccess(ParentChart).SetBooleanProperty(FDark3D,Value);
end;

Procedure TCustomChartWall.SetEnd(const Value:Integer);
begin
  TTeePanelAccess(ParentChart).SetIntegerProperty(FEnd,Value);
end;

Procedure TCustomChartWall.SetPen(const Value:TChartPen);
Begin
  Frame:=Value;
end;

Procedure TCustomChartWall.SetSize(const Value:Integer);
Begin
  TTeePanelAccess(ParentChart).SetIntegerProperty(FSize,Value);
End;

Procedure TCustomChartWall.SetStart(const Value:Integer);
begin
  TTeePanelAccess(ParentChart).SetIntegerProperty(FStart,Value);
end;

procedure TCustomChartWall.InitColor(const AColor: TColor);
begin
  Color:=AColor;
  DefaultColor:=AColor;
end;

function TCustomChartWall.HasGradient: Boolean;
begin
  result:=Assigned(FGradient) and FGradient.Visible;
end;

procedure TCustomChartWall.CalcPositions(out ATop,ABottom:Integer);
begin
  with TCustomChart(ParentChart) do
       ABottom:=ChartRect.Bottom+CalcWallSize(BottomAxis);

  if EndPosition<>100 then
     Dec(ABottom,Round((ABottom-ParentChart.ChartRect.Top)*(100-EndPosition)*0.01));

  ATop:=ParentChart.ChartRect.Top;

  if StartPosition<>0 then
     Inc(ATop,Round((ParentChart.ChartRect.Bottom-ATop)*StartPosition*0.01));
end;

Function TCustomChartWall.TryDrawWall(const APos1,APos2:Integer):TTeeBlend;
var P         : TFourPoints;
    tmpTop    : Integer;
    tmpBottom : Integer;
begin
  result:=nil;

  if (not Transparent) and ((Transparency>0) or HasGradient) then
  begin
    CalcPositions(tmpTop,tmpBottom);

    with ParentChart.Canvas do
    begin
      P[0]:=Calculate3DPosition(APos1, tmpTop, 0);
      P[1]:=Calculate3DPosition(APos1, tmpTop, ParentChart.Width3D);
      P[2]:=Calculate3DPosition(APos1, APos2, ParentChart.Width3D);
      P[3]:=Calculate3DPosition(APos1, APos2, 0);
    end;

    if Transparency>0 then
       result:=ParentChart.Canvas.BeginBlending(RectFromPolygon(P,4),Transparency);

    if HasGradient then
    begin
      Gradient.Draw(ParentChart.Canvas,P);
      ParentChart.Canvas.Brush.Style:=bsClear;
    end;
  end;
end;

procedure TCustomChartWall.SetAutoHide(const Value: Boolean);
begin
  TTeePanelAccess(ParentChart).SetBooleanProperty(FAutoHide,Value);
end;

procedure TCustomChartWall.DoEndBlending(Blend:TTeeBlend);
begin
  if Assigned(Blend) then
  begin
    if (Picture.Filters.Count>0) and (not Assigned(Picture.Graphic)) then
       Picture.Filters.ApplyTo(Blend.Bitmap);

    ParentChart.Canvas.EndBlending(Blend);
  end;
end;

function TCustomChartWall.ShouldDraw: Boolean;
begin
  result:=TCustomChart(ParentChart).View3DWalls and Visible and (not AutoHide);
end;

{$IFNDEF CLR}
type
  TShadowAccess=class(TTeeShadow);
{$ENDIF}

{ TChartBackWall }
Constructor TChartBackWall.Create(AOwner: TCustomTeePanel);
begin
  inherited;
  InitColor(clSilver);
  DefaultTransparent:=True;
  Transparent:=True;

  Shadow.Visible:=False;
  {$IFNDEF CLR}TShadowAccess{$ENDIF}(Shadow).DefaultVisible:=Shadow.Visible;

  Shadow.Color:=clDkGray;
  {$IFNDEF CLR}TShadowAccess{$ENDIF}(Shadow).DefaultColor:=Shadow.Color;
end;

{ TChartTitle }
type
  TTeeFontAccess=class(TTeeFont);

Constructor TChartTitle.Create(AOwner: TCustomTeePanel);
Begin
  inherited;
  IOnTop:=True;

  FAlignment:=taCenter;
  FAdjustFrame:=True;
  FText:=TStringList.Create;
  TStringList(FText).OnChange:=AOwner.CanvasChanged;

  FVertMargin:=TeeTitleFootDistance;

  { inherited }
  Transparent:=True;
  DefaultTransparent:=Transparent;

  Font.Color:=clBlue;
  TTeeFontAccess(Font).IDefColor:=clBlue;
end;

Destructor TChartTitle.Destroy;
Begin
  FText.Free;
  inherited;
end;

Procedure TChartTitle.Assign(Source:TPersistent);
Begin
  if Source is TChartTitle then
  With TChartTitle(Source) do
  Begin
    Self.FAdjustFrame:=FAdjustFrame;
    Self.FAlignment:=FAlignment;
    Self.Text:=FText;
    Self.FVertMargin:=FVertMargin;
  end;

  inherited;
end;

Function TChartTitle.Clicked(x,y:Integer):Boolean;
begin
  result:=Visible and PointInRect(ShapeBounds,x,y);
end;

procedure TChartTitle.DrawTitle;
var tmpXPosTitle  : Integer;
    tmpMargin     : Integer;
    FontH         : Integer;
    tmpFrameWidth : Integer;

  function CalculateYPos(APos:Integer):Integer;
  begin
    if IOnTop then result:=APos+ShapeBounds.Top
              else result:=ShapeBounds.Bottom-FontH-APos;
  end;

  // Draws a line of title/footer text }
  procedure DrawTitleLine(AIndex:Integer);
  var St   : String;
      APos : Integer;
  begin
    St:=Text[AIndex];

    APos:=CalculateYPos(AIndex*FontH+tmpFrameWidth);

    if Alignment=taRightJustify then
       tmpXPosTitle:=ShapeBounds.Right-ParentChart.Canvas.TextWidth(St)-(tmpMargin div 2)
    else
    if Alignment=taCenter then
       tmpXPosTitle:=((ShapeBounds.Left+ShapeBounds.Right) div 2)-(ParentChart.Canvas.TextWidth(St) div 2);

    ParentChart.Canvas.TextOut(tmpXPosTitle,APos,St);
  end;

  procedure ResizeChartRect(VertMargin:Integer);
  var tmpR : TRect;
  begin
    tmpR:=ParentChart.ChartRect;

    if IOnTop then
       tmpR.Top:=ShapeBounds.Bottom+VertMargin
    else
       tmpR.Bottom:=ShapeBounds.Bottom-VertMargin-Text.Count*FontH;

    ParentChart.ChartRect:=tmpR;
  end;

var t               : Integer;
    tmpMaxWidth     : Integer;
    tmp             : Integer;
    tmpFrameVisible : Boolean;
Begin
  if Visible and (Text.Count>0) then
  begin
    { calculate title shape margin }
    tmpFrameVisible:=Frame.Visible and (Frame.Color<>clTeeColor);
    if tmpFrameVisible then tmpFrameWidth:=Frame.Width
                       else tmpFrameWidth:=0;

    if Bevel<>bvNone then tmpFrameWidth:=BevelWidth;

    { apply title margins }
    if not FCustomPosition then
    begin
      ShapeBounds:=ParentChart.ChartRect;

      if IOnTop then
         ShapeBounds.Top:=ShapeBounds.Top+tmpFrameWidth;
    end;

    { prepare title font }
    With ParentChart.Canvas do
    begin
      AssignFont(Self.Font);
      TextAlign:=TA_LEFT;
      FontH:=FontHeight;
    end;

    { autosize title height on number of text lines }
    if IOnTop or FCustomPosition then
       ShapeBounds.Bottom:=ShapeBounds.Top+Text.Count*FontH
    else
       ShapeBounds.Top   :=ShapeBounds.Bottom-Text.Count*FontH;

    { apply margins to bottom and right sides }
    if not FCustomPosition then
       InflateRect(ShapeBounds,tmpFrameWidth,tmpFrameWidth);

    tmpMargin:=ParentChart.Canvas.TextWidth(TeeCharForHeight);

    { resize Title to maximum Chart width }
    if AdjustFrame then
    begin
      tmpMaxWidth:=0;
      for t:=0 to Text.Count-1 do
      Begin
        tmp:=ParentChart.Canvas.TextWidth(Text[t]);
        if tmp>tmpMaxWidth then tmpMaxWidth:=tmp;
      end;

      Inc(tmpMaxWidth,tmpMargin+tmpFrameWidth);

      With ShapeBounds do
      Case Alignment of
          taLeftJustify  : Right:=Left +tmpMaxWidth;
          taRightJustify : Left :=Right-tmpMaxWidth;
          taCenter       : begin
                             if FCustomPosition then Right:=Left+tmpMaxWidth;
                             tmp:=(Left+Right) div 2;
                             Left :=tmp-(tmpMaxWidth div 2);
                             Right:=tmp+(tmpMaxWidth div 2);
                           end;
      end;
    end;

    { draw title shape }
    Draw;

    tmpXPosTitle:=ShapeBounds.Left+(tmpMargin div 2);

    { draw all Title text lines }
    ParentChart.Canvas.BackMode:=cbmTransparent;

    if TextFormat=ttfNormal then
       for t:=0 to Text.Count-1 do DrawTitleLine(t)
    else
       ParentChart.Canvas.TextOut(tmpXPosTitle,CalculateYPos(tmpFrameWidth),
                                  Text.Text,True);

    { calculate Chart positions after drawing the titles / footers }
    if not FCustomPosition then
    begin
      tmp:=FVertMargin+tmpFrameWidth;

      if (not Transparent) and Shadow.Visible then
         Inc(tmp,Shadow.VertSize);

      if not {$IFNDEF CLR}TTeePanelAccess{$ENDIF}(ParentChart).CustomChartRect then
         ResizeChartRect(tmp);

      ParentChart.RecalcWidthHeight;
    end;
  end;
end;

Function TChartTitle.GetShapeBounds:TRect;
begin
  result:=ShapeBounds;
end;

Procedure TChartTitle.SetAdjustFrame(Value:Boolean);
begin
  TTeePanelAccess(ParentChart).SetBooleanProperty(FAdjustFrame,Value);
end;

Procedure TChartTitle.SetAlignment(Value:TAlignment);
Begin
  if FAlignment<>Value then
  begin
    FAlignment:=Value;
    Repaint;
  end;
end;

Procedure TChartTitle.SetText(Value:TStrings);
begin
  FText.Assign(Value);
  Repaint;
end;

Procedure TChartTitle.SetVertMargin(const Value:Integer);
begin
  if FVertMargin<>Value then
  begin
    FVertMargin:=Value;
    Repaint;
  end;
end;

function TChartTitle.GetCaption: String;
begin
  if Text.Count>0 then result:=Text[0]
                  else result:='';
end;

procedure TChartTitle.SetCaption(const Value: String);
begin
  Text.Clear;

  if Value<>'' then
     Text.Add(Value);
end;

procedure TChartTitle.Clear;
begin
  Caption:='';
end;

{ TChartFootTitle }
Constructor TChartFootTitle.Create(AOwner: TCustomTeePanel);
Begin
  inherited {$IFDEF CLR}Create(AOwner){$ENDIF};
  IOnTop:=False;
  With Font do
  Begin
    Color:=clRed;
    Style:=[fsItalic];
  end;

  //TODO: DCCIL problem prevents using "with" here...
  TTeeFontAccess(Font).IDefColor:=clRed;
  TTeeFontAccess(Font).IDefStyle:=[fsItalic];
end;

{ TChartWalls }
constructor TChartWalls.Create(Chart: TCustomChart);
begin
  inherited Create;
  FChart:=Chart;
  FBack:=TChartBackWall.Create(FChart);
  FLeft:=TChartLeftWall.Create(FChart);
  FLeft.InitColor($80FFFF); { ChartMarkColor }

  FBottom:=TChartBottomWall.Create(FChart);
  FBottom.InitColor(clWhite);

  FRight:=TChartRightWall.Create(FChart);
  With FRight do
  begin
    Visible:=False;
    InitColor(clSilver);
  end;
end;

procedure TChartWalls.Assign(Source: TPersistent);
begin
  if Source is TChartWalls then
  with TChartWalls(Source) do
  begin
    Self.Back   :=Back;
    Self.Bottom :=Bottom;
    Self.Left   :=Left;
    Self.Right  :=Right;
  end
  else inherited;
end;

destructor TChartWalls.Destroy;
begin
  FBack.Free;
  FBottom.Free;
  FLeft.Free;
  FRight.Free;
  inherited;
end;

procedure TChartWalls.SetBack(const Value: TChartBackWall);
begin
  Back.Assign(Value);
end;

procedure TChartWalls.SetBottom(const Value: TChartBottomWall);
begin
  Bottom.Assign(Value);
end;

procedure TChartWalls.SetLeft(const Value: TChartLeftWall);
begin
  Left.Assign(Value);
end;

procedure TChartWalls.SetRight(const Value: TChartRightWall);
begin
  Right.Assign(Value);
end;

function TChartWalls.GetVisible: Boolean;
begin
  result:=FChart.View3DWalls;
end;

procedure TChartWalls.SetVisible(const Value: Boolean);
begin
  FChart.View3DWalls:=Value;
end;

procedure TChartWalls.SetSize(const Value: Integer);
begin
  Left.Size:=Value;
  Right.Size:=Value;
  Back.Size:=Value;
  Bottom.Size:=Value;
end;

{ TCustomChart }
Constructor TCustomChart.Create(AOwner: TComponent);
Begin
  inherited;
  AutoRepaint:=False;
  FTitle:=TChartTitle.Create(Self);
  if csDesigning in ComponentState then FTitle.FText.Add(ClassName);

  FScrollMouse:=mbRight;

  FSubTitle:=TChartTitle.Create(Self);
  FFoot    :=TChartFootTitle.Create(Self);
  FSubFoot :=TChartFootTitle.Create(Self);

  FWalls:=TChartWalls.Create(Self);
  FLegend:=TChartLegend.Create(Self);

  RestoredAxisScales:=True;
  AutoRepaint :=True;

  if Assigned(TeeNewChartHook) then
     if (csDesigning in ComponentState) and
        Assigned(Owner) and 
        (not (csLoading in Owner.ComponentState)) then
           TeeNewChartHook(Self);
end;

Destructor TCustomChart.Destroy;
Begin
  FSavedScales:=nil;
  AutoRepaint:=False;  { 5.01 }
  FSubTitle.Free;
  FTitle.Free;
  FSubFoot.Free;
  FFoot.Free;
  FWalls.Free;
  FreeAndNil(FLegend);
  inherited;
end;

type
  TSeriesAccess=class(TChartSeries);

Function TCustomChart.FormattedValueLegend(ASeries:TChartSeries; ValueIndex:Integer):String;
var tmp : TCustomChartLegend;
Begin
  if Assigned(ASeries) then
  begin
    tmp:=TCustomChartLegend(TSeriesAccess(ASeries).ILegend);
    if not Assigned(tmp) then tmp:=Legend;
    result:=tmp.FormattedValue(ASeries,ValueIndex);
  end
  else
     result:='';
end;

Function TCustomChart.InternalFormattedLegend( ALegend:TCustomChartLegend;
                                               SeriesOrValueIndex:Integer):String;
begin
  result:=ALegend.FormattedLegend(SeriesOrValueIndex);

  if Assigned(FOnGetLegendText) then
     FOnGetLegendText(Self,ALegend.InternalLegendStyle,SeriesOrValueIndex,result);
end;

Function TCustomChart.FormattedLegend(SeriesOrValueIndex:Integer):String;
Begin
  result:=InternalFormattedLegend(Legend,SeriesOrValueIndex);
end;

procedure TCustomChart.SetLegend(Value:TChartLegend);
begin
  FLegend.Assign(Value);
end;

// "remember" the axis scales when zooming, to restore when unzooming
Function TCustomChart.SaveScales:TAllAxisSavedScales;
var t : Integer;
begin
  SetLength(result,Axes.Count);
  for t:=0 to Axes.Count-1 do
  with Axes[t] do
    if not IsDepthAxis then
    begin
      result[t].Auto:=Automatic;
      result[t].AutoMin:=AutomaticMinimum;
      result[t].AutoMax:=AutomaticMaximum;
      result[t].Min:=Minimum;
      result[t].Max:=Maximum;
    end;
end;

type
  TAxisAccess=class(TChartAxis);

// restore the "remembered" axis scales when unzooming
Procedure TCustomChart.RestoreScales(var Saved:TAllAxisSavedScales);
var t : Integer;
begin
  for t:=0 to Axes.Count-1 do
  with {$IFNDEF CLR}TAxisAccess{$ENDIF}(Axes[t]) do
    if not IsDepthAxis then
    begin
      Automatic:=Saved[t].Auto;
      AutomaticMinimum:=Saved[t].AutoMin;
      AutomaticMaximum:=Saved[t].AutoMax;
      
      {$IFDEF LCL} // Lazarus FPC bug?
      SetMinMax(Saved[t].Min,Saved[t].Max);
      {$ELSE}
      
      {$IFDEF CLR}TAxisAccess(Axes[t]).{$ENDIF}InternalSetMinimum(Saved[t].Min);
      {$IFDEF CLR}TAxisAccess(Axes[t]).{$ENDIF}InternalSetMaximum(Saved[t].Max);
      
      {$ENDIF}
//      if not Automatic then SetMinMax(Saved[t].Min,Saved[t].Max);  // 7.0 Removed
    end;

  Saved:=nil;
end;

procedure TCustomChart.SetBackWall(Value:TChartBackWall);
begin
  Walls.Back:=Value;
end;

function TCustomChart.GetBackWall: TChartBackWall;
begin
  result:=Walls.Back;
end;

function TCustomChart.GetBottomWall: TChartBottomWall;
begin
  result:=Walls.Bottom;
end;

function TCustomChart.GetLeftWall: TChartLeftWall;
begin
  result:=Walls.Left;
end;

function TCustomChart.GetRightWall: TChartRightWall;
begin
  result:=Walls.Right;
end;

Function TCustomChart.GetFrame:TChartPen;
begin
  if Assigned(Walls.Back) then result:=Walls.Back.Pen
                          else result:=nil;
end;

Procedure TCustomChart.SetFrame(Value:TChartPen);
begin
  BackWall.Pen.Assign(Value);
end;

Function TCustomChart.GetBackColor:TColor;
begin
  if BackWall.Transparent then result:=Color
                          else result:=BackWall.Color;
end;

Procedure TCustomChart.SetBackColor(Value:TColor);
begin
  BackWall.Color:=Value;
  { fix 4.01: do not set backwall solid when loading dfms... }
  if Assigned(Parent) and (not (csLoading in ComponentState)) then
     BackWall.Brush.Style:=bsSolid;
end;

Function TCustomChart.IsFreeSeriesColor(AColor:TColor; CheckBackground:Boolean;
                                        ASeries:TChartSeries=nil):Boolean;
var t : Integer;
Begin
  for t:=0 to SeriesCount-1 do
  if ((Series[t]<>ASeries) and (Series[t].SeriesColor=AColor)) or  // 6.02
     (CheckBackground and
     ( (AColor=Color) or (AColor=BackWall.Color) )) then
  begin
    result:=False;
    exit;
  end;
  result:=(not CheckBackground) or ( (AColor<>Color) and (AColor<>BackWall.Color) );
end;

procedure TCustomChart.SetLeftWall(Value:TChartLeftWall);
begin
  Walls.Left:=Value;
end;

procedure TCustomChart.SetBottomWall(Value:TChartBottomWall);
begin
  Walls.Bottom:=Value;
end;

procedure TCustomChart.SetRightWall(Value:TChartRightWall);
begin
  Walls.Right:=Value;
end;

Procedure TCustomChart.DrawRightWall;
var tmpB : Integer;
    tmp  : Integer;
    tmpTop   : Integer;
    tmpBlend : TTeeBlend;
begin
  if RightWall.Visible and ActiveSeriesUseAxis and View3D and View3DWalls then
  begin
    PrepareWallCanvas(RightWall);

    RightWall.CalcPositions(tmpTop,tmpB);

    tmpBlend:=RightWall.TryDrawWall(ChartRect.Right,tmpB);

    with RightWall do
    begin
      if Size>0 then
      begin
        if BackWall.Visible then tmp:=BackWall.Size
                            else tmp:=0;

        Canvas.Cube(ChartRect.Right,ChartRect.Right+Size,tmpTop,tmpB,0,Width3D+tmp,ApplyDark3D)
      end
      else
        Canvas.RectangleZ(ChartRect.Right,tmpTop,tmpB,0,Succ(Width3D));

      if Assigned(FPicture) and Assigned(FPicture.Graphic) then
         Canvas.StretchDraw(TeeRect(0,tmpTop,Width3D,tmpB),
                            Picture.Filtered,
                            ChartRect.Right,cpX);

      DoEndBlending(tmpBlend);
    end;
  end;
end;

Function TCustomChart.DrawWallFirst(APos:Integer):Boolean;
var P : TFourPoints;
    tmpBottom : Integer;
begin
  if Canvas.SupportsFullRotation then
     result:=True
  else
  begin
    With ChartRect do
    begin
      P[0]:=Canvas.Calculate3DPosition(APos,Top,0);
      tmpBottom:=Bottom+CalcWallSize(BottomAxis);
      P[1]:=Canvas.Calculate3DPosition(APos,tmpBottom,0);
      P[2]:=Canvas.Calculate3DPosition(APos,tmpBottom,Width3D+BackWall.Size);
    end;

    result:=TeeCull(P);
  end;
end;

Function TCustomChart.DrawRightWallAfter:Boolean;
begin
  result:=not DrawWallFirst(ChartRect.Right);
end;

Function TCustomChart.DrawLeftWallFirst:Boolean;
begin
  result:=DrawWallFirst(ChartRect.Left);
end;

type
  TChartAxisAccess=class(TChartAxis);
  TCanvasAccess=class(TCanvas3D);

procedure TCustomChart.DrawTitlesAndLegend(BeforeSeries:Boolean);

  Procedure DrawAxisAfter(Axis:TChartAxis);
  begin
    if IsAxisVisible(Axis) then
    begin
      TChartAxisAccess(Axis).IHideBackGrid:=True;
      Axis.Draw(False);
      TChartAxisAccess(Axis).IHideBackGrid:=False;
    end;
  end;

  Procedure DrawAxisGridAfter(Axis:TChartAxis);
  begin
    if IsAxisVisible(Axis) then
    begin
      TChartAxisAccess(Axis).IHideSideGrid:=True;
      TChartAxisAccess(Axis).DrawGrids(Length(Axis.Tick));
      TChartAxisAccess(Axis).IHideSideGrid:=False;
    end;
  end;

  Procedure DrawTitleFoot(CustomOnly:Boolean);

    Procedure DoDrawTitle(ATitle:TChartTitle; const TitleID:String);
    begin
      if ATitle.CustomPosition=CustomOnly then
      begin
        TCanvasAccess(Canvas).BeginEntity(TitleID);

        ATitle.DrawTitle;

        TCanvasAccess(Canvas).EndEntity;
      end;
    end;

  begin
    DoDrawTitle(FTitle,'title');
    DoDrawTitle(FSubTitle,'subtitle');
    DoDrawTitle(FFoot,'foot');
    DoDrawTitle(FSubFoot,'subfoot');
  end;

  { draw title and foot, or draw foot and title, depending
    if legend is at left/right or at top/bottom. }
  { top/bottom legends need to leave space for the title and foot
    before they get displayed.  }
  { If the Legend.CustomPosition is True, then draw the Legend AFTER
    all Series and Axes (on top of chart) }
begin
  Canvas.FrontPlaneBegin;

  if BeforeSeries then
  begin { draw titles and legend before series }
    if (not Legend.CustomPosition) and Legend.ShouldDraw then
    begin
      if Legend.Vertical then
      begin
        Legend.DrawLegend;
        DrawTitleFoot(False);
      end
      else
      begin
        DrawTitleFoot(False);
        Legend.DrawLegend;
      end;
    end
    else DrawTitleFoot(False);
  end
  else
  begin { after series }
    if Legend.CustomPosition and Legend.ShouldDraw then
       Legend.DrawLegend;

    DrawTitleFoot(True);
  end;

  Canvas.FrontPlaneEnd;

  if not BeforeSeries then
  if ActiveSeriesUseAxis then
  begin
    if View3D then
    begin
      if DrawRightWallAfter then
      begin
        if Walls.Right.ShouldDraw then
           DrawRightWall;

        DrawAxisAfter(RightAxis);
      end;

      if DrawLeftWallFirst then
      begin
        if Walls.Left.ShouldDraw then
           DrawLeftWall;
        DrawAxisAfter(LeftAxis);
      end;

      if DrawBackWallAfter(Width3D) then
      begin
        DrawAxisGridAfter(TopAxis);
        DrawAxisGridAfter(BottomAxis);

        if Walls.Back.ShouldDraw then
           DrawBackWall;
      end;
    end;
  end;
end;

// Returns wall size in pixels corresponding to Axis parameter.
// For example: Left axis corresponds to Left wall.
Function TCustomChart.CalcWallSize(Axis:TChartAxis):Integer;
var tmpW : TCustomChartWall;
begin
  result:=0;

  if View3D and View3DWalls then
  begin
    if Axis=LeftAxis then tmpW:=Walls.Left else
    if Axis=BottomAxis then tmpW:=Walls.Bottom else
    if Axis=RightAxis then tmpW:=Walls.Right else tmpW:=Walls.Back;

    if tmpW.Visible then result:=tmpW.Size;
  end;
end;

Function TCustomChart.ActiveSeriesUseAxis:Boolean;
var t : Integer;
begin
  result:=True;
  for t:=0 to SeriesCount-1 do
  With Series[t] do
  if Active then
     if UseAxis then
     begin
       result:=True;
       Exit;
     end
     else result:=False;
end;

Procedure TCustomChart.PrepareWallCanvas(AWall:TChartWall);
begin
  With AWall do
  begin
    Canvas.AssignVisiblePen(Frame);

    if Transparent then Canvas.Brush.Style:=bsClear
                   else SetBrushCanvas(Color,Brush,Brush.Color)
  end;
end;

Procedure TCustomChart.DrawLeftWall;  { Left wall only }
var tmpB     : Integer;
    tmpBlend : TTeeBlend;
    tmpTop   : Integer;
begin
  if View3D and View3DWalls then
  begin
    PrepareWallCanvas(LeftWall);

    LeftWall.CalcPositions(tmpTop,tmpB);

    tmpBlend:=LeftWall.TryDrawWall(ChartRect.Left,tmpB);

    with LeftWall do
    begin
      if Size>0 then
         Canvas.Cube(ChartRect.Left-Size,ChartRect.Left,tmpTop,tmpB,0,Width3D,ApplyDark3D)
      else
         Canvas.RectangleZ(ChartRect.Left,tmpTop,tmpB,0,Width3D);

      if Assigned(FPicture) and Assigned(FPicture.Graphic) then
         Canvas.StretchDraw(TeeRect(0,tmpTop,Width3D,tmpB),
                              Picture.Filtered,
                              ChartRect.Left,cpX);

      DoEndBlending(tmpBlend);
    end;
  end;
end;

Procedure TCustomChart.DrawBackWall;
var tmpRect : TRect;

  Procedure DrawBackWallGradient;
  var P : TFourPoints;
  begin
    if (not BackWall.Transparent) and BackWall.HasGradient then
    begin
      if View3DOptions.Orthogonal then
         BackWall.Gradient.Draw(Canvas,Canvas.CalcRect3D(tmpRect,Width3D))
      else
      begin
        if Canvas.SupportsFullRotation then
        begin
          TCanvasAccess(Canvas).GradientZ:=Width3D;
          BackWall.Gradient.Draw(Canvas,tmpRect);
          TCanvasAccess(Canvas).GradientZ:=0;
        end
        else
        begin
          Canvas.FourPointsFromRect(tmpRect,Width3D,P);
          BackWall.Gradient.Draw(Canvas,P);
        end;
      end;

      if not Canvas.SupportsFullRotation then
         Canvas.Brush.Style:=bsClear;
    end;
  end;

var
  tmpBlend : TTeeBlend;

  Procedure CreateBlender;
  begin
    with BackWall do
    if Transparency>0 then
       tmpBlend:=Canvas.BeginBlending(Canvas.RectFromRectZ(tmpRect,Width3D),Transparency);
  end;

var
  tmpTop    : Integer;
  tmpBottom : Integer;

  procedure SetChartRect;
  begin
    tmpRect.Left:=ChartRect.Left;
    tmpRect.Top:=tmpTop;
    tmpRect.Right:=ChartRect.Right;
    tmpRect.Bottom:=tmpBottom;
  end;

var tmp  : Integer;
    tmpP : TFourPoints;

    {$IFNDEF D5}
    tmpP2 : TPointArray;
    {$ENDIF}
begin
  PrepareWallCanvas(BackWall);

  with BackWall do
  begin
    tmpBlend:=nil;

    CalcPositions(tmpTop,tmpBottom);

    if View3D then
    begin
      if View3DWalls then
      begin
        if Width3D<0 then tmp:=-Size else tmp:=Size;

        SetChartRect;

        if Size>0 then
           Dec(tmpRect.Left,CalcWallSize(LeftAxis));

        CreateBlender;

        if Shadow.Visible and (Shadow.Size<>0) then
           if View3DOptions.Orthogonal then
              Shadow.Draw(Canvas,Canvas.CalcRect3D(tmpRect,Width3D))
           else
           begin
             Canvas.FourPointsFromRect(tmpRect,Width3D,tmpP);

             {$IFDEF D5}
             Shadow.Draw(Canvas,tmpP);
             {$ELSE}
             SetLength(tmpP2,4);
             tmpP2[0]:=tmpP[0];
             tmpP2[1]:=tmpP[1];
             tmpP2[2]:=tmpP[2];
             tmpP2[3]:=tmpP[3];

             Shadow.Draw(Canvas,tmpP2);
             tmpP2:=nil;
             {$ENDIF}
           end;

        DrawBackWallGradient;
        Canvas.AssignVisiblePen(Frame);

        if Size>0 then
           Canvas.Cube(tmpRect,Width3D,Width3D+tmp,ApplyDark3D)
        else
           Canvas.RectangleWithZ(tmpRect,Width3D);
      end;
    end
    else
    begin
      SetChartRect;

      Inc(tmpRect.Right);

      if EndPosition=100 then
         Inc(tmpRect.Bottom);

      CreateBlender;

      if Shadow.Visible and (Shadow.Size<>0) then
         Shadow.Draw(Canvas,tmpRect);

      if Gradient.Visible and (not Transparent) then
      begin
        Gradient.Draw(Canvas,tmpRect);
        Canvas.Brush.Style:=bsClear;
      end;

      Canvas.Rectangle(tmpRect);
    end;

    if Assigned(Picture.Graphic) then
    begin
      SetChartRect;
      Picture.Draw(Self,tmpRect,Width3D);
    end
    else
    if HasBackImage and BackImage.Inside then
    begin
      SetChartRect;

      if Pen.Visible then
      begin
        Inc(tmpRect.Top);
        Inc(tmpRect.Left);
      end;

      DrawBitmap(tmpRect,Width3D);
    end;

    DoEndBlending(tmpBlend);
  end;
end;

Procedure TCustomChart.DrawWalls;  { Left and Bottom wall only }

  Procedure DrawBottomWall;
  var P    : TFourPoints;
      tmpB : Integer;
      tmpLeft : Integer;
      tmpZ0 : Integer;
      tmpZ1 : Integer;

    Procedure CalcBottomWallPoints;
    begin
      tmpB:=ChartRect.Bottom;
      P[0]:=Canvas.Calculate3DPosition(tmpLeft,  tmpB,tmpZ0);
      P[1]:=Canvas.Calculate3DPosition(tmpLeft,  tmpB,tmpZ1);
      P[2]:=Canvas.Calculate3DPosition(ChartRect.Right, tmpB,tmpZ1);
      P[3]:=Canvas.Calculate3DPosition(ChartRect.Right, tmpB,tmpZ0);
    end;

  var tmpBlend : TTeeBlend;
      tmpRight : Integer;
  begin
    PrepareWallCanvas(BottomWall);

    tmpB:=ChartRect.Bottom;
    if Canvas.SupportsFullRotation then Inc(tmpB);

    tmpZ0:=0;
    if BottomWall.StartPosition<>0 then
       Inc(tmpZ0,Round(Width3D*BottomWall.StartPosition*0.01));

    tmpZ1:=Width3D;
    if BottomWall.EndPosition<>100 then
       Dec(tmpZ1,Round(Width3D*(100-BottomWall.EndPosition)*0.01));

    tmpLeft:=ChartRect.Left;

    //MM TV52010497
    with Walls.Left do
    if Visible and AutoHide and DrawLeftWallFirst then  // 7.05
       Dec(tmpLeft,CalcWallSize(Axes.Left));

    tmpBlend:=nil;

    if not BottomWall.Transparent then
    begin
      CalcBottomWallPoints;

      if BottomWall.Transparency>0 then // 5.03
         tmpBlend:=Canvas.BeginBlending(RectFromPolygon(P,4),BottomWall.Transparency);

      if BottomWall.HasGradient then
      begin
        BottomWall.Gradient.Draw(Canvas,P);
        Canvas.Brush.Style:=bsClear;
      end;
    end;

    tmpRight:=ChartRect.Right;

    With BottomWall do
    begin
      if Size>0 then
         Canvas.Cube(tmpLeft,tmpRight,tmpB,tmpB+Size,tmpZ0,tmpZ1,ApplyDark3D)
      else
         Canvas.RectangleY(tmpLeft,tmpB,tmpRight,tmpZ0,tmpZ1);

      if Assigned(FPicture) and Assigned(FPicture.Graphic) then
         Canvas.StretchDraw(TeeRect(tmpLeft,tmpZ1,tmpRight,tmpZ0),
                            Picture.Filtered,
                            tmpB,cpY);

      DoEndBlending(tmpBlend);
    end;
  end;

begin
  if ActiveSeriesUseAxis then
  begin
    if View3D and View3DWalls then
    begin
      if RightWall.Visible and (not DrawRightWallAfter) then
         DrawRightWall;
    end;

    if View3DWalls then
      if BackWall.Visible and (not DrawBackWallAfter(Width3D)) then
         DrawBackWall;

    if View3D and View3DWalls then
    begin
      if LeftWall.Visible and (not DrawLeftWallFirst) then
         DrawLeftWall;

      if BottomWall.Visible then DrawBottomWall;

      if DrawBackWallAfter(0) then
      begin
        if IsAxisVisible(Axes.Top) then Axes.Top.Draw(True);
        if IsAxisVisible(Axes.Bottom) then Axes.Bottom.Draw(True);
      end;
    end;
  end;
end;

Procedure TCustomChart.SeriesUp(ASeries:TChartSeries);
var t : Integer;
Begin  { scroll up ASeries in SeriesList. This changes the Z order }
  t:=SeriesList.IndexOf(ASeries);
  if t>0 then ExchangeSeries(t,t-1);
end;

Procedure TCustomChart.SeriesDown(ASeries:TChartSeries);
var t : Integer;
Begin  { scroll down ASeries in SeriesList. This changes the Z order }
  t:=SeriesList.IndexOf(ASeries);
  if t<SeriesCount-1 then ExchangeSeries(t,t+1);
end;

Procedure TCustomChart.NextPage;
Begin
  Pages.NextPage;
End;

Procedure TCustomChart.PreviousPage;
Begin
  Pages.PreviousPage;
End;

Procedure TCustomChart.RemoveAllSeries;
Begin
  While SeriesCount>0 do RemoveSeries(0);
End;

Procedure TCustomChart.DoZoom(Const topi,topf,boti,botf,lefi,leff,rigi,rigf:Double);

  Procedure DoZoomAnimated;

    Procedure ZoomAxis(AAxis:TChartAxis; Const tmpA,tmpB:Double);
    Begin { apply a portion of the desired zoom to achieve animation }
      with AAxis do
        SetMinMax(Minimum+((tmpA-Minimum)/AnimatedZoomFactor),
                  Maximum-((Maximum-tmpB)/AnimatedZoomFactor));
    end;

  var t : Integer;
  begin
    for t:=1 to Zoom.AnimatedSteps-1 do
    begin
      ZoomAxis(LeftAxis,Lefi,Leff);
      ZoomAxis(RightAxis,Rigi,Rigf);
      ZoomAxis(TopAxis,Topi,Topf);
      ZoomAxis(BottomAxis,Boti,Botf);

      Refresh;  // force repaint

      // OnAnimatedZoom event ?
    end;
  end;

Begin
  if RestoredAxisScales then
  begin
    FSavedScales:=SaveScales;
    RestoredAxisScales:=False;
  end;

  if Zoom.Animated then DoZoomAnimated; { animation... }

  { final zoom }
  LeftAxis.SetMinMax(Lefi,Leff);
  RightAxis.SetMinMax(Rigi,Rigf);
  TopAxis.SetMinMax(Topi,Topf);
  BottomAxis.SetMinMax(Boti,Botf);
  Zoomed:=True;

  if Assigned(FOnZoom) then FOnZoom(Self);
end;

Procedure TCustomChart.ZoomRect(Const Rect:TRect);
Begin
  With Zoom do
  Begin
    X0:=Rect.Left;
    Y0:=Rect.Top;
    X1:=Rect.Right;
    Y1:=Rect.Bottom;
    CalcZoomPoints;
  end;
End;

Procedure TCustomChart.ZoomPercent(Const PercentZoom:Double);

  Procedure CalcAxisScale(Axis:TChartAxis; out tmpA,tmpB:Double);
  var tmpDelta  : Double;
      AMin      : Double;
      AMax      : Double;
      a,b       : Integer;
      ApplyZoom : Boolean;
  Begin
    if not Axis.Horizontal then
    begin
      ApplyZoom:=Zoom.Direction<>tzdHorizontal;
      a:=Axis.IEndPos;   // ChartRect.Bottom
      b:=Axis.IStartPos; // ChartRect.Top
    end
    else
    begin
      ApplyZoom:=Zoom.Direction<>tzdVertical;
      a:=Axis.IStartPos; // ChartRect.Left
      b:=Axis.IEndPos;   // ChartRect.Right;
    end;

    AMin:=Axis.CalcPosPoint(a);
    AMax:=Axis.CalcPosPoint(b);

    if ApplyZoom then
    begin
      tmpDelta:=(AMax-AMin)*(PercentZoom-100.0)*0.01;
      tmpA:=AMin+tmpDelta;
      tmpB:=AMax-tmpDelta;
    end
    else
    begin
      tmpA:=AMin;
      tmpB:=AMax;
    end;
  end;

var Lefi : Double;
    Leff : Double;
    Rigi : Double;
    Rigf : Double;
    Topi : Double;
    Topf : Double;
    Boti : Double;
    Botf : Double;
Begin  { zoom a given "percent" }
  CalcAxisScale(LeftAxis,Lefi,Leff);
  CalcAxisScale(RightAxis,Rigi,Rigf);
  CalcAxisScale(TopAxis,Topi,Topf);
  CalcAxisScale(BottomAxis,Boti,Botf);
  DoZoom(Topi,Topf,Boti,Botf,Lefi,Leff,Rigi,Rigf);
  Repaint;
end;

Procedure TCustomChart.CalcClickedPart(Pos:TPoint; var Part:TChartClickedPart);
begin
  Part:=CalcNeedClickedPart(Pos,False);
end;

Function TCustomChart.CalcNeedClickedPart(Pos:TPoint; Needed:Boolean):TChartClickedPart;

  procedure ClickedAxis(Axis:TChartAxis);
  begin
    if Axis.Clicked(Pos.x,Pos.y) then
    begin
      result.Part:=cpAxis;
      result.AAxis:=Axis;
    end
    else
    with Axis.Title do
    if Visible and (Caption<>'') then
       if Clicked(Pos.X,Pos.Y) then
       begin
         result.Part:=cpAxisTitle;
         result.AAxis:=Axis;
       end;
  end;

  Function ClickedLegend(var Part:TChartClickedPart):Boolean;  // 6.02
  begin
    Part.PointIndex:=Legend.Clicked(Pos.X,Pos.Y);

    if Part.PointIndex<>-1 then
    begin
      Part.Part:=cpLegend;
      result:=True;
    end
    else
      result:=False;
  end;

  Function LegendOnTop:Boolean;
  begin
    result:=Legend.CustomPosition;
         //((Legend.HorizMargin>=0) and (Legend.VertMargin>=0));
  end;

var t : Integer;
begin
  With result do
  begin
    Part:=cpNone;
    PointIndex:=-1;
    ASeries:=nil;
    AAxis:=nil;

    if Legend.Visible and LegendOnTop then
       if ClickedLegend(result) then
          Exit;

    { IMPORTANT: Z order inverted }

    for t:=SeriesCount-1 downto 0 do
    With {$IFNDEF CLR}TSeriesAccess{$ENDIF}(Self.Series[t]) do
    if Active and
       ((not Needed) or RaiseClicked or Assigned(FOnClickSeries)) then
    Begin
      PointIndex:=Clicked(Pos.X,Pos.Y);

      if PointIndex<>-1 then
      begin
        ASeries:=Series[t];
        Part:=cpSeries;
        Exit;
      end;

      if Marks.Visible then
      begin
        PointIndex:=Marks.Clicked(Pos.X,Pos.Y);

        if PointIndex<>-1 then
        begin
          ASeries:=Series[t];
          Part:=cpSeriesMarks;
          Exit;
        end;
      end;
    end;

    for t:=0 to Axes.Count-1 do
    begin
      ClickedAxis(Axes[t]);

      if Assigned(result.AAxis) then
         Exit;
    end;

    if Legend.Visible and (not LegendOnTop) then  // 6.02
       if ClickedLegend(result) then
          Exit;

    if Title.Clicked(Pos.X,Pos.Y) then Part:=cpTitle
    else
    if SubTitle.Clicked(Pos.X,Pos.Y) then Part:=cpSubTitle
    else
    if Foot.Clicked(Pos.X,Pos.Y) then Part:=cpFoot
    else
    if SubFoot.Clicked(Pos.X,Pos.Y) then Part:=cpSubFoot
    else
    if PointInRect(ChartRect,Pos) and  { <-- should be PtInCube(ChartRect,0,MaxZ) }
       (CountActiveSeries>0) then
	        Part:=cpChartRect;
  end;
end;

Function TCustomChart.AxisTitleOrName(Axis:TChartAxis):String;
Begin
  result:=Axis.Title.Caption;

  if result='' then
  begin
    if Axis=DepthAxis then result:=TeeMsg_DepthAxis
    else
    if Axis=Axes.DepthTop then result:=TeeMsg_DepthTopAxis
    else
    With Axis do
    if Horizontal then
       if OtherSide then result:=TeeMsg_TopAxis
		                else result:=TeeMsg_BottomAxis
    else
       if OtherSide then result:=TeeMsg_RightAxis
		                else result:=TeeMsg_LeftAxis;
  end;
end;

type
  TToolAccess=class(TTeeCustomTool);

procedure TCustomChart.BroadcastMouseEvent(AEvent:TChartMouseEvent;
                    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var t : Integer;
    tmp : TTeeCustomTool;
begin
  for t:=0 to Tools.Count-1 do
  begin
    tmp:=Tools[t];
    if tmp.Active then
    begin
      TToolAccess(tmp).ChartMouseEvent(AEvent,Button,Shift,X,Y);
      if CancelMouse then break;
    end;
  end;
end;

{procedure TCustomChart.BroadcastWheelEvent(AEvent:TWheelMouseEvent;
                         WheelDelta:Integer; X, Y: Integer);
var t : Integer;
    tmp : TTeeCustomTool;
begin
  for t:=0 to Tools.Count-1 do
  begin
    tmp:=Tools[t];
    if tmp.Active then
    begin
      TToolAccess(tmp).WheelMouseEvent(AEvent,WheelDelta,X,Y);
      if CancelMouse then break;
    end;
  end;
end;}

procedure TCustomChart.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var IClicked : Boolean;

    Procedure CheckZoomPanning;
    Begin
      if ActiveSeriesUseAxis then
      begin
        if Zoom.Allow and (Button=Zoom.MouseButton) and
           (Zoom.KeyShift<=Shift) then
        Begin
          if Zoom.Direction=tzdVertical then x:=ChartRect.Left;
          if Zoom.Direction=tzdHorizontal then y:=ChartRect.Top;

          Zoom.Activate(x,y);
          
          if Zoom.Direction=tzdVertical then Zoom.X1:=ChartRect.Right;
          if Zoom.Direction=tzdHorizontal then Zoom.Y1:=ChartRect.Bottom;

          DrawZoomRectangle;
          IClicked:=True;
        end;

        if (AllowPanning<>pmNone) and (Button=FScrollMouse) and
           (TeeScrollKeyShift<=Shift ) then
        Begin
          IPanning.Activate(x,y);
          IClicked:=True;
        end;

        // was: crDefault; { <-- todo: ScrollCursor:=crHandPoint }
        if IClicked then Cursor:=OriginalCursor; // 6.0
      end;
    end;

    Procedure CheckBackground;
    begin
      if Assigned(FOnClickBackground) then
      begin
        CancelMouse:=True;
        FOnClickBackGround(Self,Button,Shift,x,y);
        IClicked:=CancelMouse;
      end;
    end;

    Procedure CheckTitle(ATitle:TChartTitle);
    begin
      if Assigned(FOnClickTitle) then
      begin
        CancelMouse:=True;
        FOnClickTitle(Self,ATitle,Button,Shift,x,y);
        IClicked:=CancelMouse;
      end;

      if not IClicked then CheckZoomPanning;
    end;

var tmpPart : TChartClickedPart;
Begin
  inherited;

  if CancelMouse or Zoom.Active or IPanning.Active then
     Exit;

  CancelMouse:=False;
  BroadcastMouseEvent(cmeDown,Button,Shift,X,Y);

  if not CancelMouse then
  begin
    tmpPart:=CalcNeedClickedPart(TeePoint(x,y),True);
    IClicked:=False;

    Case tmpPart.Part of
      cpLegend: begin
                  IClicked:=FLegend.DoMouseDown(x,y,tmpPart.PointIndex);

		  if Assigned(FOnClickLegend) then
		  begin
		    CancelMouse:=True;
		    FOnClickLegend(Self,Button,Shift,x,y);
		    IClicked:=CancelMouse;
		  end;
                end;

      cpSeries: Begin
		  With tmpPart do
                  begin
                    CancelMouse:=False;

                    if ssDouble in Shift then
                    begin
                      if Assigned(ASeries.OnDblClick) then
                         ASeries.OnDblClick(ASeries,PointIndex,Button,Shift,x,y)
                    end
                    else
                    if Assigned(ASeries.OnClick) then
                       ASeries.OnClick(ASeries,PointIndex,Button,Shift,x,y);

                    IClicked:=CancelMouse;
                  end;

		  if Assigned(FOnClickSeries) then
		  begin
		    CancelMouse:=True;
		    FOnClickSeries(Self,tmpPart.ASeries,tmpPart.PointIndex,Button,Shift,x,y);
		    IClicked:=CancelMouse;
		  end;

		  if not IClicked then
                     CheckZoomPanning;
		end;
	cpAxis: begin
		  if Assigned(FOnClickAxis) then
		  begin
		    CancelMouse:=True;
		    FOnClickAxis(Self,TChartAxis(tmpPart.AAxis),Button,Shift,x,y);
		    IClicked:=CancelMouse;
		  end;

		  if not IClicked then
                     CheckZoomPanning;

		end;

     cpTitle   : CheckTitle(Title);
     cpFoot    : CheckTitle(Foot);
     cpSubTitle: CheckTitle(SubTitle);
     cpSubFoot : CheckTitle(SubFoot);

   cpChartRect : begin
                   CheckBackground;

                   if not IClicked then
                      CheckZoomPanning;
                 end;
    end;

    if not IClicked then
       CheckBackground;
  end;

  CancelMouse:=False;
End;

procedure TCustomChart.MouseMove(Shift: TShiftState; X, Y: Integer);

  Procedure ProcessPanning(Axis:TChartAxis; IniPos,EndPos:Integer);
  var Delta          : Double;
      tmpMin         : Double;
      tmpMax         : Double;
      tmpAllowScroll : Boolean;
  Begin
    With Axis do
    begin
      Delta:=CalcPosPoint(IniPos)-CalcPosPoint(EndPos);
      tmpMin:=Minimum+Delta;
      tmpMax:=Maximum+Delta;
    end;

    tmpAllowScroll:=True;

    if Assigned(FOnAllowScroll) then
       FOnAllowScroll(TChartAxis(Axis),tmpMin,tmpMax,tmpAllowScroll);

    if tmpAllowScroll then
       Axis.SetMinMax(tmpMin,tmpMax);
  end;

var
  Panned : Boolean;

   Procedure PanAxis(AxisHorizontal:Boolean; Const Pos1,Pos2:Integer);
   var tmpAxis : TChartAxis;
       t       : Integer;
       tmpMode : TPanningMode;
   begin
     if AxisHorizontal then tmpMode:=pmHorizontal
                       else tmpMode:=pmVertical;

     if (Pos1<>Pos2) and
        ( (AllowPanning=tmpMode) or (AllowPanning=pmBoth) ) then
     begin
       for t:=0 to Axes.Count-1 do
       begin
         tmpAxis:=Axes[t];

      	 if not tmpAxis.IsDepthAxis then
       	    if (AxisHorizontal and tmpAxis.Horizontal) or
	             ((not AxisHorizontal) and (not tmpAxis.Horizontal)) then
       	       ProcessPanning(tmpAxis,Pos2,Pos1);
       end;

       Panned:=True;
     end;
   end;

Begin
  inherited;

  if not (csDesigning in ComponentState) then
     BroadcastMouseEvent(cmeMove,mbLeft,Shift,X,Y);

  if not CancelMouse then
  With Zoom do  { zoom }
  if Active then
  Begin
    if Direction=tzdVertical then x:=ChartRect.Right;

    if Direction=tzdHorizontal then y:=ChartRect.Bottom;

    if (x<>X1) or (y<>Y1) then
    Begin
      DrawZoomRectangle;
      X1:=x;
      Y1:=y;
      DrawZoomRectangle;
    end;

  end
  else
  With IPanning do { scroll }
  if Active then
  Begin

    if PointInRect(ChartRect,x,y) then
    Begin

      if (x<>X1) or (y<>Y1) then
      Begin
        Panned:=False;
        Check;

        if RestoredAxisScales then
        begin
          FSavedScales:=SaveScales;
          RestoredAxisScales:=False;
        end;

        PanAxis(True,X,X1);
        PanAxis(False,Y,Y1);
        X1:=x;
        Y1:=y;

        if Panned then
        Begin
          if Assigned(FOnScroll) then
             FOnScroll(Self);

          Invalidate;
        end;
      End;
    end
    else IPanning.Active:=False;
  end
  else
  if not CheckMouseSeries(x,y) then { is mouse not over Series ? }
     Cursor:=OriginalCursor; { change back original cursor }
end;

Procedure TCustomChart.ScrollVerticalAxes(Up:Boolean);
var t        : Integer;
    tmp      : Double;
    tmpMin   : Double;
    tmpMax   : Double;
    tmpAllow : Boolean;
begin
  for t:=0 to Axes.Count-1 do
  with Axes[t] do
  if not Horizontal then
  begin
    tmp:=(Maximum-Minimum)*3.0*0.01;

    if not Up then
       tmp:=-tmp;

    tmpAllow:=True;

    if Assigned(FOnAllowScroll) then
    begin
      tmpMin:=Axes[t].Minimum+tmp;
      tmpMax:=Axes[t].Maximum+tmp;

      FOnAllowScroll(Axes[t],tmpMin,tmpMax,tmpAllow);
    end;

    if tmpAllow then
       Scroll(tmp,False);
  end;
end;

function TCustomChart.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      {$IFDEF CLX}const{$ENDIF} MousePos: TPoint): Boolean;
begin
  result:=inherited DoMouseWheel(Shift,WheelDelta,MousePos);

  //with GetCursorPos do
    //   BroadcastWheelEvent(wmeMove,WheelDelta,X,Y);
end;

function TCustomChart.CanWheelScroll:Boolean;
begin
  result:=TeeUseMouseWheel and
         ((AllowPanning=pmBoth) or (AllowPanning=pmVertical));
end;

function TCustomChart.DoMouseWheelDown(Shift: TShiftState;
      {$IFDEF CLX}const{$ENDIF} MousePos: TPoint): Boolean;
begin
  result:=inherited DoMouseWheelDown(Shift,MousePos);

  if CanWheelScroll then
     ScrollVerticalAxes(True);

  with GetCursorPos do
       //BroadcastWheelEvent(wmeDown,0,X,Y);
end;

function TCustomChart.DoMouseWheelUp(Shift: TShiftState;
      {$IFDEF CLX}const{$ENDIF} MousePos: TPoint): Boolean;
begin
  result:=inherited DoMouseWheelUp(Shift,MousePos);

  if CanWheelScroll then
     ScrollVerticalAxes(False);

  with GetCursorPos do
       //BroadcastWheelEvent(wmeUp,0,X,Y);
end;

procedure TCustomChart.UndoZoom;
begin
  if not RestoredAxisScales then
  begin
    RestoreScales(FSavedScales);
    RestoredAxisScales:=True;
  end;

  inherited;
end;

Procedure TCustomChart.CalcZoomPoints;
Begin
  With Zoom do
  Begin
    Check;

    DoZoom( TopAxis.CalcPosPoint(X0),TopAxis.CalcPosPoint(X1),
	    BottomAxis.CalcPosPoint(X0),BottomAxis.CalcPosPoint(X1),
	    LeftAxis.CalcPosPoint(Y1),LeftAxis.CalcPosPoint(Y0),
	    RightAxis.CalcPosPoint(Y1),RightAxis.CalcPosPoint(Y0));
  end;
End;

procedure TCustomChart.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  CancelMouse:=False; { 5.03 }

  inherited;

  if Zoom.Active and (Button=Zoom.MouseButton) then
  With Zoom do
  Begin
    Active:=False;
    DrawZoomRectangle;
    Canvas.Pen.Mode:=pmCopy;

    if Direction<>tzdVertical then X1:=x;  // 7.04
    if Direction<>tzdHorizontal then Y1:=y;

    if ((Direction=tzdVertical) or ( Abs(X1-X0)>MinimumPixels )) and
       ((Direction=tzdHorizontal) or ( Abs(Y1-Y0)>MinimumPixels )) then
    begin
      if UpLeftZooms or
         ((Direction=tzdVertical) and (Y1>Y0)) or
         ((Direction<>tzdVertical) and (X1>X0)) then  // 7.04
           CalcZoomPoints // <-- do zoom in !
      else
         UndoZoom; // <-- do zoom out !

      Invalidate;
    end;
  end;

  IPanning.Active:=False;
  BroadcastMouseEvent(cmeUp,Button,Shift,X,Y);
End;

Procedure TCustomChart.CalcWallsRect;
var tmp : Integer;
begin
  CalcSize3DWalls;

  { for 3D orthogonal mode only }
  if View3D and View3DOptions.Orthogonal then
  begin
    if ActiveSeriesUseAxis then tmp:=BackWall.Size
		           else tmp:=0;

    if not CustomChartRect then
    With ChartRect do
    begin
      if View3DOptions.OrthoAngle>90 then
      begin
        Inc(Left,Abs(Width3D)+tmp);

        if LeftWall.Visible then
           Inc(Left,LeftWall.Size+1);
      end
      else
      begin
        Dec(Right,Abs(Width3D)+tmp);

        if RightWall.Visible then
           Dec(Right,RightWall.Size+1);
      end;

      Inc(Top,Abs(Height3D)+tmp);
    end;
  end;

  RecalcWidthHeight;
end;

Procedure TCustomChart.Assign(Source:TPersistent);
begin
  if Source is TCustomChart then
  With TCustomChart(Source) do
  begin
    Self.ColorPaletteIndex:=ColorPaletteIndex;
    Self.Foot       :=FFoot;
    Self.Legend     :=FLegend;
    Self.FScrollMouse:=FScrollMouse;
    Self.SubFoot    :=FSubFoot;
    Self.SubTitle   :=FSubTitle;
    Self.Title      :=FTitle;
    Self.Walls      :=Walls;
  end;

  inherited;
end;

Procedure TCustomChart.GetChildren(Proc:TGetChildProc; Root:TComponent);
var t : Integer;
begin
  inherited;
  for t:=0 to Tools.Count-1 do Proc(Tools[t]);
end;

Procedure TCustomChart.FillSeriesSourceItems( ASeries:TChartSeries;
					Proc:TGetStrProc);
begin { abstract }
end;

Procedure TCustomChart.FillValueSourceItems( ValueList:TChartValueList;
				       Proc:TGetStrProc);
var t:Integer;
Begin
  With ValueList.Owner do
  if Assigned(DataSource) and (DataSource is TChartSeries) then
     With TChartSeries(DataSource) do
     for t:=0 to ValuesList.Count-1 do Proc(ValuesList[t].Name);
end;

Function TCustomChart.GetASeries:TChartSeries;
var t : Integer;
Begin
  for t:=0 to SeriesCount-1 do
  if Series[t].Active then
  begin
    result:=SeriesList[t];
    exit;
  end;

  result:=nil;
End;

procedure TCustomChart.SetTitle(Value:TChartTitle);
begin
  FTitle.Assign(Value);
end;

procedure TCustomChart.SetWalls(Value:TChartWalls);
begin
  Walls.Assign(Value);
end;

procedure TCustomChart.SetColorPaletteIndex(const Value:Integer);
begin
  if FColorPaletteIndex<>Value then
  begin
    FColorPaletteIndex:=Value;
    ColorPalettes.ApplyPalette(Self,FColorPaletteIndex);
  end;
end;

procedure TCustomChart.SetFoot(Value:TChartTitle);
begin
  FFoot.Assign(Value);
end;

procedure TCustomChart.SetSubTitle(const Value: TChartTitle);
begin
  FSubTitle.Assign(Value);
end;

procedure TCustomChart.SetSubFoot(const Value: TChartTitle);
begin
  FSubFoot.Assign(Value);
end;

procedure TCustomChart.ReadBackColor(Reader: TReader);
begin
  if Reader.NextValue=vaIdent then
     BackColor:=StringToColor(Reader.ReadIdent)
  else
     BackColor:=Reader.ReadInteger;
end;

procedure TCustomChart.WriteColorPalette(Writer: TWriter);
begin
  Writer.WriteInteger(ColorPaletteIndex);
end;

procedure TCustomChart.DefineProperties(Filer: TFiler);

  function DoColorPaletteIndex:Boolean;
  begin
    if Filer.Ancestor <> nil then
       result:=ColorPaletteIndex<>TCustomChart(Filer.Ancestor).ColorPaletteIndex
    else
       result:=ColorPaletteIndex>0;
  end;

begin
  inherited;
  Filer.DefineProperty('BackColor',ReadBackColor,nil,False); // Do not localize

  Filer.DefineProperty('ColorPaletteIndex',ReadColorPalette,  // Do not localize
                        WriteColorPalette,DoColorPaletteIndex);
end;

procedure TCustomChart.ReadColorPalette(Reader: TReader);
begin
  ColorPaletteIndex:=Reader.ReadInteger;
end;

procedure TCustomChart.SetScrollMouseButton(const Value: TMouseButton);
begin
  FScrollMouse := Value;
end;

procedure TCustomChart.DrawLegendShape(const Rect: TRect);
begin
  with Legend.Symbol do
  if Gradient.Visible or Shadow.Visible then
     Draw(Canvas.Brush.Color,Rect)
  else
     inherited;
end;

{ TChartLegendGradient }
Constructor TChartLegendGradient.Create(ChangedEvent:TNotifyEvent);
begin
  inherited;
  IChanged:=nil;
  Direction:=gdRightLeft;
  EndColor:=clWhite;
  StartColor:=clSilver;
  IChanged:=ChangedEvent;
end;

{ TTeeCustomShapePosition }
Procedure TTeeCustomShapePosition.SetCustomPosition(Const Value:Boolean);
Begin
  if Assigned(ParentChart) then
     TTeePanelAccess(ParentChart).SetBooleanProperty(FCustomPosition,Value)
  else
     FCustomPosition:=Value;
end;

Procedure TTeeCustomShapePosition.SetLeft(Const Value:Integer);
Begin
  FCustomPosition:=True;

  if Assigned(ParentChart) then
     TTeePanelAccess(ParentChart).SetIntegerProperty(ShapeBounds.Left,Value)
  else
     ShapeBounds.Left:=Value;
end;

Procedure TTeeCustomShapePosition.SetTop(Const Value:Integer);
Begin
  FCustomPosition:=True;

  if Assigned(ParentChart) then
     TTeePanelAccess(ParentChart).SetIntegerProperty(ShapeBounds.Top,Value)
  else
     ShapeBounds.Top:=Value;
end;

Procedure TTeeCustomShapePosition.Assign(Source:TPersistent);
Begin
  if Source is TTeeCustomShapePosition then
  With TTeeCustomShapePosition(Source) do
  Begin
    Self.FCustomPosition:=FCustomPosition;

    if Self.FCustomPosition then
    begin
      Self.Left :=Left;
      Self.Top  :=Top;
    end;
  end;

  inherited;
end;

function TTeeCustomShapePosition.GetLeft: Integer;
begin
  result:=ShapeBounds.Left;
end;

function TTeeCustomShapePosition.GetTop: Integer;
begin
  result:=ShapeBounds.Top;
end;

function TTeeCustomShapePosition.IsCustomStored: Boolean;
begin
  result:=FCustomPosition<>DefaultCustom;
end;

{ TLegendSymbol }
Constructor TLegendSymbol.Create(AParent:TCustomTeePanel);
begin
  inherited Create;

  Parent:=AParent;
  FVisible:=True;
  FDefaultPen:=True;
  FPen:=TChartPen.Create(CanvasChanged);
  FWidth:=TeeDefaultLegendSymbolWidth;
  FGradient:=TTeeGradient.Create(CanvasChanged);

  FShadow:=TTeeShadow.Create(CanvasChanged);
  FShadow.Size:=3;
  {$IFNDEF CLR}TShadowAccess{$ENDIF}(FShadow).DefaultSize:=3;
end;

Destructor TLegendSymbol.Destroy;
begin
  FShadow.Free;
  FGradient.Free;
  FPen.Free;
  inherited;
end;

Procedure TLegendSymbol.CanvasChanged(Sender:TObject);
begin
  Repaint;
end;

Procedure TLegendSymbol.Assign(Source:TPersistent);
Begin
  if Source is TLegendSymbol then
  With TLegendSymbol(Source) do
  Begin
    Self.FContinuous :=Continuous;
    Self.Gradient    :=Gradient;
    Self.Pen         :=Pen;
    Self.FPosition   :=Position;
    Self.Shadow      :=Shadow;
    Self.FSquared    :=Squared;
    Self.FWidth      :=Width;
    Self.FWidthUnits :=WidthUnits;
    Self.FVisible    :=Visible;
  end;
end;

Function TLegendSymbol.CalcWidth(Value:Integer):Integer;
begin
  if Visible then
     if Squared then
        result:=CalcItemHeight-5
     else
     if FWidthUnits=lcsPercent then result:=Round(Width*Value*0.01)
                               else result:=Width
  else
     result:=0;
end;

procedure TLegendSymbol.Repaint;
begin
  if Assigned(Parent) then
     Parent.Repaint;
end;

type
  TPanelAccess=class(TCustomTeePanel);

procedure TLegendSymbol.SetWidth(Const Value: Integer);
begin
  if Assigned(Parent) then
     TPanelAccess(Parent).SetIntegerProperty(FWidth,Value)
  else
     FWidth:=Value;
end;

procedure TLegendSymbol.SetWidthUnits(const Value: TLegendSymbolSize);
begin
  if FWidthUnits<>Value then
  begin
    FWidthUnits:=Value;
    Repaint;
  end;
end;

procedure TLegendSymbol.SetPosition(Const Value: TLegendSymbolPosition);
begin
  if FPosition<>Value then
  begin
    FPosition:=Value;
    Repaint;
  end;
end;

Procedure TLegendSymbol.SetShadow(const Value:TTeeShadow);
begin
  FShadow.Assign(Value);
end;

procedure TLegendSymbol.SetBooleanProperty(var Variable:Boolean; const Value: Boolean);
begin
  if Variable<>Value then
  begin
    Variable:=Value;
    Repaint;
  end;
end;

procedure TLegendSymbol.SetContinuous(const Value: Boolean);
begin
  SetBooleanProperty(FContinuous,Value);
end;

procedure TLegendSymbol.SetVisible(const Value: Boolean);
begin
  SetBooleanProperty(FVisible,Value);
end;

procedure TLegendSymbol.SetDefaultPen(const Value: Boolean);
begin
  if FDefaultPen<>Value then
  begin
    FDefaultPen:=Value;
    Repaint;
  end;
end;

procedure TLegendSymbol.SetPen(const Value: TChartPen);
begin
  FPen.Assign(Value);
end;

procedure TLegendSymbol.SetSquared(const Value: Boolean);
begin
  SetBooleanProperty(FSquared,Value);
end;

procedure TLegendSymbol.SetGradient(Value: TTeeGradient);
begin
  FGradient.Assign(Value);
end;

procedure TLegendSymbol.Draw(AColor: TColor; const R:TRect);
var tmp : TCanvas3D;
begin
  tmp:=Parent.Canvas;

  if FShadow.Visible and (FShadow.Size<>0) then
     FShadow.Draw(tmp,R);

  if not DefaultPen then  // 8.01
     tmp.AssignVisiblePen(Pen);

  if Gradient.Visible then
  begin
    Gradient.EndColor:=AColor;
    Gradient.Draw(tmp,R);
    tmp.Brush.Style:=bsClear;
  end
  else
  begin
    tmp.Brush.Color:=AColor;
  end;

  if Pen.Visible then
     tmp.Rectangle(R);
end;

{ TLegendItem }
procedure TLegendItem.SetText(const Value:String);
begin
  SetTextVariable(FText,Value);
end;

procedure TLegendItem.SetText2(const Value:String);
begin
  SetTextVariable(FText2,Value);
end;

procedure TLegendItem.SetTextVariable(var Variable:String; const Value:String);
begin
  if Variable<>Value then
  begin
    Variable:=Value;

    ILegend.Items.FCustom:=True;
    ILegend.Repaint;
  end;
end;

{ TLegendItems }
function TLegendItems.Get(Index:Integer):TLegendItem;
begin
  while Index>(Count-1) do Add(nil);

  result:=TLegendItem(inherited Items[Index]);

  if not Assigned(result) then
  begin
    result:=TLegendItem.Create;
    result.ILegend:=ILegend;
    inherited Items[Index]:=result;
  end;
end;

Procedure TLegendItems.ClearItems;
var t : Integer;
begin
  for t:=0 to Count-1 do
      TLegendItem(Items[t]).Free;

  inherited Clear;
end;

Procedure TLegendItems.Clear;
begin
  ClearItems;
  ILegend.Repaint;
end;

{ TCustomChartLegend }
Const TeeLegendOff2  = 2;
      TeeLegendOff4  = 4;

Constructor TCustomChartLegend.Create(AOwner: TCustomTeePanel);
begin
  inherited;
  InternalLegendStyle:=lsAuto;
  ILastValue:=TeeAllValues;

  FAlignment:=laRight;
  FCurrentPage:=True;

  FSymbol:=TLegendSymbol.Create(AOwner);
  FSymbol.CalcItemHeight:=CalcItemHeight;

  if Assigned(ParentChart) then
     FDividingLines:=TChartHiddenPen.Create(ParentChart.CanvasChanged)
  else
     FDividingLines:=TChartHiddenPen.Create(nil);

  FLegendStyle:=lsAuto;
  FMaxNumRows:=10;
  FTextStyle:=ltsLeftValue;
  FTopLeftPos:=10; { % }
  FResizeChart:=True;
  ColumnWidthAuto:=True;

  FTitle:=TLegendTitle.Create(ParentChart);

  FItems:=TLegendItems.Create;
  FItems.ILegend:=Self;

  FPosUnits:=muPixels;
end;

Destructor TCustomChartLegend.Destroy;
begin
  FItems.Free;
  FTitle.Free;
  FSymbol.Free;
  FDividingLines.Free;
  inherited;
end;

Procedure TCustomChartLegend.Assign(Source:TPersistent);
Begin
  if Source is TCustomChartLegend then
  With TCustomChartLegend(Source) do
  Begin
    Self.FAlignment   :=FAlignment;
    Self.FCheckBoxes  :=FCheckBoxes;
    Self.FCheckBoxesStyle  :=FCheckBoxesStyle;
    Self.FCurrentPage :=FCurrentPage;
    Self.DividingLines:=DividingLines;
    Self.FFirstValue  :=FFirstValue;
    Self.FFontSeriesColor:=FFontSeriesColor;
    Self.FHorizMargin :=FHorizMargin;
    Self.FInverted    :=FInverted;
    Self.FLeftPercent :=FLeftPercent;
    Self.FLegendStyle :=FLegendStyle;
    Self.FMaxNumRows  :=FMaxNumRows;
    Self.FPosUnits    :=FPosUnits;
    Self.FResizeChart :=FResizeChart;
    Self.Symbol       :=Symbol;
    Self.FTextStyle   :=FTextStyle;
    Self.Title        :=FTitle;
    Self.FTopLeftPos  :=FTopLeftPos;
    Self.FTopPercent  :=FTopPercent;
    Self.FVertMargin  :=FVertMargin;
    Self.FVertSpacing :=FVertSpacing;
  end;
  inherited;
end;

Procedure TCustomChartLegend.SetAlignment(Const Value:TLegendAlignment);
Begin
  if FAlignment<>Value then
  begin
    FAlignment:=Value;
    Repaint;
  end;
end;

Procedure TCustomChartLegend.SetFirstValue(Const Value:Integer);
Begin
  if Value<0 then
     Raise LegendException.Create(TeeMsg_LegendFirstValue)
  else
     TTeePanelAccess(ParentChart).SetIntegerProperty(FFirstValue,Value);
End;

Procedure TCustomChartLegend.SetHorizMargin(Const Value:Integer);
Begin
  TTeePanelAccess(ParentChart).SetIntegerProperty(FHorizMargin,Value);
end;

Procedure TCustomChartLegend.SetInverted(Const Value:Boolean);
Begin
  TTeePanelAccess(ParentChart).SetBooleanProperty(FInverted,Value);
end;

Procedure TCustomChartLegend.SetCurrentPage(Const Value:Boolean);
Begin
  TTeePanelAccess(ParentChart).SetBooleanProperty(FCurrentPage,Value);
end;

procedure TCustomChartLegend.SetFontSeriesColor(const Value: Boolean);
begin
  TTeePanelAccess(ParentChart).SetBooleanProperty(FFontSeriesColor,Value);
end;

Procedure TCustomChartLegend.SetLeftPercent(Const Value:Integer);
begin
  TTeePanelAccess(ParentChart).SetIntegerProperty(FLeftPercent,Value);
end;

Procedure TCustomChartLegend.SetLegendStyle(Const Value:TLegendStyle);
Begin
  if FLegendStyle<>Value then
  begin
    FLegendStyle:=Value;
    CalcLegendStyle; { <-- force recalc of InternalLegendStyle }
    Repaint;
  end;
end;

Procedure TCustomChartLegend.SetMaxNumRows(Const Value:Integer);
Begin
  TTeePanelAccess(ParentChart).SetIntegerProperty(FMaxNumRows,Value);
end;

Procedure TCustomChartLegend.SetPosUnits(Const Value:TTeeUnits);
begin
  if FPosUnits<>Value then
  begin
    FPosUnits:=Value;
    Repaint;
  end;
end;

Procedure TCustomChartLegend.SetResizeChart(Const Value:Boolean);
Begin
  TTeePanelAccess(ParentChart).SetBooleanProperty(FResizeChart,Value);
end;

Procedure TCustomChartLegend.SetCheckBoxes(Const Value:Boolean);
Begin
  TTeePanelAccess(ParentChart).SetBooleanProperty(FCheckBoxes,Value);
end;

Procedure TCustomChartLegend.SetCheckBoxesStyle(Const Value:TCheckBoxesStyle);
var t : Integer;
    tmpCount : Integer;
Begin
  if FCheckBoxesStyle<>Value then
  begin
    FCheckBoxesStyle:=Value;

    if FCheckBoxesStyle=cbsRadio then
    begin
      tmpCount:=0;
      // Ensure only one series is active (visible)
      with TCustomAxisPanel(ParentChart) do
      for t:=0 to SeriesCount-1 do
      if Series[t].Active and Series[t].ShowInLegend then
      begin
        Inc(tmpCount);
        if tmpCount>1 then Series[t].Active:=False;
      end;
    end;

    Repaint;
  end;
end;

Procedure TCustomChartLegend.SetTextStyle(Const Value: TLegendTextStyle);
Begin
  if FTextStyle<>Value then
  begin
    FTextStyle:=Value;
    Repaint;
  end;
end;

Procedure TCustomChartLegend.SetTopLeftPos(Const Value:Integer);
Begin
  TTeePanelAccess(ParentChart).SetIntegerProperty(FTopLeftPos,Value);
end;

Procedure TCustomChartLegend.SetTopPercent(Const Value:Integer);
begin
  TTeePanelAccess(ParentChart).SetIntegerProperty(FTopPercent,Value);
end;

Procedure TCustomChartLegend.SetVertMargin(Const Value:Integer);
Begin
  TTeePanelAccess(ParentChart).SetIntegerProperty(FVertMargin,Value);
end;

Procedure TCustomChartLegend.SetVertSpacing(Const Value:Integer);
Begin
  TTeePanelAccess(ParentChart).SetIntegerProperty(FVertSpacing,Value);
end;

Procedure TCustomChartLegend.SetSymbolWidth(Const Value:Integer);
Begin
  FSymbol.Width:=Value;
end;

Procedure TCustomChartLegend.CalcLegendStyle;
begin
  if FLegendStyle=lsAuto then
  begin
    if CheckBoxes or (TCustomChart(ParentChart).CountActiveSeries>1) then
       InternalLegendStyle:=lsSeries
    else
       InternalLegendStyle:=lsValues;
  end
  else InternalLegendStyle:=FLegendStyle;
end;

Function TCustomChartLegend.FormattedLegend(Index:Integer):String;
var tmpSeries : TChartSeries;
Begin
  With TCustomChart(ParentChart) do
  Case InternalLegendStyle of
    lsSeries: result:=SeriesTitleLegend(Index,not CheckBoxes);
    lsValues: result:=FormattedValueLegend(GetLegendSeries,Index);
lsLastValues: begin
                tmpSeries:=SeriesLegend(Index,not CheckBoxes);
                result:=FormattedValueLegend(tmpSeries, tmpSeries.CountLegendItems-1); // 7.07
              end;
lsSeriesGroups: result:=SeriesList.Groups[Index].Name;  // Active groups only?                    
  end;
end;

Procedure TCustomChartLegend.SetDividingLines(Const Value:TChartHiddenPen);
begin
  FDividingLines.Assign(Value);
end;

Procedure TCustomChartLegend.SetSymbol(Const Value:TLegendSymbol);
begin
  FSymbol.Assign(Value);
end;

Function TCustomChartLegend.GetVertical:Boolean;
begin
  result:=(Alignment=laLeft) or (Alignment=laRight)
end;

function TCustomChartLegend.GetItem(Index:Integer):TLegendItem;
begin
  result:=Items[Index];
end;

Function TCustomChartLegend.GetRectLegend:TRect;
begin
  result:=ShapeBounds;
end;

Function TCustomChartLegend.GetSymbolWidth:Integer;
begin
  result:=FSymbol.Width
end;

Function TCustomChartLegend.GetLegendSeries:TChartSeries;
var t   : Integer;
    tmp : TChartSeries;
begin
  result:=FSeries;

  if not Assigned(result) then
  begin
    result:=TCustomChart(ParentChart).GetASeries;

    // 7.07, if first series has ShowInLegend=False, try to find another one
    if (not Assigned(result)) or (not result.ShowInLegend) then
    for t:=0 to TCustomChart(ParentChart).SeriesCount-1 do
    begin
      tmp:=TCustomChart(ParentChart)[t];

      if tmp.Active and tmp.ShowInLegend then
      begin
        result:=tmp;
        break;
      end;
    end;
  end;
end;

Procedure TCustomChartLegend.PrepareSymbolPen;
begin
  if Symbol.DefaultPen then TCustomChart(ParentChart).LegendPen:=nil
                       else TCustomChart(ParentChart).LegendPen:=Symbol.Pen;
end;

Function TCustomChartLegend.CalcItemHeight:Integer;
begin
  result:=ParentChart.Canvas.FontHeight;

  if HasCheckBoxes then
     result:=Math.Max(6+TeeCheckBoxSize,result);

  Inc(result,FVertSpacing);

  if Vertical and DividingLines.Visible then { 5.02 }
     Inc(result,DividingLines.Width);
end;

Function TCustomChartLegend.FirstItemTop:Integer;
begin
  result:=ShapeBounds.Top;

  if IDrawTitle then
  begin
    Inc(result,Title.Height+2);

    if (not Title.Transparent) and Title.Shadow.Visible then
       Inc(result,Abs(Title.Shadow.VertSize));
  end;
end;

type
  TCustomChartAccess=class(TCustomChart);

Procedure TCustomChartLegend.DrawLegend;

  Procedure DrawSymbol(ASeries:TChartSeries; AIndex:Integer; Const R:TRect);
  begin

    {$IFNDEF TEEOCX} //AX event always assigned
    if not Assigned(Symbol.FOnDraw) then  // 7.0
    {$ENDIF}
    begin
      if IColorWidth>0 then
         if Assigned(ASeries) then
            ASeries.DrawLegend(AIndex,R)
         else
            FSymbol.Draw(clWhite,R);
    end
    {$IFNDEF TEEOCX}
    else
    {$ELSE}
    ;
    {$ENDIF}
      Symbol.FOnDraw(Symbol,ASeries,AIndex,R)
  end;

type
    TLegendItemText=Array[0..TeeMaxLegendColumns-1] of String;

var XLegendText  : Integer;
    XLegendColor : Integer;
    XLegendBox   : Integer;
    tmpMaxWidth  : Integer;
    tmpSeries    : TChartSeries;
    ISpaceWidth  : Integer;
    Items        : Array of TLegendItemText;
    ItemHeight   : Integer;
    ItemsTopMargin : Integer;

  Procedure DrawLegendItem(ItemIndex,ItemOrder:Integer);
  type
    TSetLegendTextStyle=Set of TLegendTextStyle;

  var
    PosXLegend : Integer;
    t          : Integer;
    IncPos     : Boolean;

    Procedure SetRightAlign(Const ASet:TSetLegendTextStyle);
    begin
      if FTextStyle in ASet then
      begin
        ParentChart.Canvas.TextAlign:=ta_Right;
        Inc(posXLegend,ColumnWidths[t]);
        IncPos:=False;
      end
      else ParentChart.Canvas.TextAlign:=ta_Left;
    end;

    procedure DrawBox(Checked:Boolean; OffsetX,PosYLegend:Integer);
    var tmpBox : Integer;
    begin
      tmpBox:=XLegendBox;

      if not Vertical then
         Inc(tmpBox,OffsetX);

      TeeDrawCheckBox( tmpBox,PosYLegend+((ItemHeight-FVertSpacing-TeeCheckBoxSize) div 2)-1,
                       ParentChart.Canvas.ReferenceCanvas,Checked,Color,
                       CheckBoxesStyle=cbsCheck);
    end;

    function GetItemText(ItemOrder,Column:Integer):String;
    begin
      if Vertical then
         result:=Items[ItemOrder,Column]
      else
         result:=Items[ItemOrder+(ITotalItems-ILastValue-1),Column]; // v8 fix
    end;

  var PosYLegend : Integer;
      tmp        : Integer;
      R          : TRect;
      tmpSt      : String;
      tmpOrder   : Integer;
      PosXColor  : Integer;
      tmpX       : Integer;
      tmpTop     : Integer;
      tmpBorder  : Integer;
  begin
    if ItemOrder>=ITotalItems then exit;

    with TCustomChart(ParentChart),Canvas do
    begin
      Brush.Color:=Self.Color;
      Brush.Style:=bsClear;
      BackMode:=cbmTransparent;

      PrepareSymbolPen;

      tmp:=XLegendText;
      tmpX:=0;

      posYLegend:=FirstItemTop+1+ItemsTopMargin;

      PosXColor:=XLegendColor;

      if Self.Vertical then
         tmpOrder:=ItemOrder
      else
      begin
        tmpOrder:=ItemOrder div NumCols;
        tmpX:=tmpMaxWidth+IColorWidth+TeeLegendOff4+2*TeeLegendOff2;

        if HasCheckBoxes then
           Inc(tmpX,TeeCheckBoxSize+2*TeeLegendOff2);

        tmpX:=tmpX*(ItemOrder mod NumCols);
        Inc(tmp,tmpX);
        Inc(PosXColor,tmpX);
      end;

      Inc(posYLegend,tmpOrder*ItemHeight+(FVertSpacing div 2));

      if Assigned(FOnGetLegendPos) then
         FOnGetLegendPos(TCustomChart(ParentChart),ItemIndex,tmp,posYLegend,PosXColor);

      posXLegend:=tmp-TeeLegendOff2;

      if FontSeriesColor then
      begin
        if (InternalLegendStyle=lsSeries) or
           (InternalLegendStyle=lsLastValues) then
            Font.Color:=SeriesLegend(ItemIndex,not CheckBoxes).SeriesColor
        else
            Font.Color:=tmpSeries.LegendItemColor(ItemIndex);
      end;

      for t:=0 to TeeMaxLegendColumns-1 do
      begin
        tmpSt:=GetItemText(ItemOrder,t);

        IncPos:=True;

        if InternalLegendStyle=lsSeries then
           TextAlign:=ta_Left
        else
           if t=0 then
              SetRightAlign([ ltsXValue,
                              ltsValue,
                              ltsPercent,
                              ltsXandValue,
                              ltsXandPercent,
                              ltsLeftPercent,
                              ltsLeftValue ])
           else
           if t=1 then
              SetRightAlign([ ltsRightValue,
                              ltsXandValue,
                              ltsXandPercent,
                              ltsRightPercent ]);
        if tmpSt<>'' then
        begin
          if HasCheckBoxes then tmpTop:=PosYLegend+1
                           else tmpTop:=PosYLegend;

          if FItems.FCustom and (FItems.Count>ItemIndex) then
          begin
            with Item[ItemIndex] do
            if t=0 then
            begin
              posXLegend:=FLeft;
              tmpTop:=FTop;
              tmpSt:=FText;
              TextAlign:=FAlign;
            end
            else
              tmpSt:=FText2;
          end
          else
          with Item[ItemIndex] do // Alias effect. Do not streamline.
          if t=0 then
          begin
            FLeft:=posXLegend;
            FTop:=tmpTop;
            FText:=tmpSt;
            FText2:=GetItemText(ItemOrder,1);
            FAlign:=TextAlign;
          end;

          TextOut(posXLegend,tmpTop,tmpSt,TextFormat=ttfHtml);  { <-- draw text }
        end;

        if IncPos then
           Inc(posXLegend,ColumnWidths[t]);

        Inc(posXLegend,ISpaceWidth);
      end;

      if FItems.Custom then
         R:=Item[ItemIndex].FSymbol
      else
      begin
        R.Left:=PosXColor;
        R.Right:=PosXColor+IColorWidth;
        R.Top:=PosYLegend;
        R.Bottom:=PosYLegend+ItemHeight+1;

        if (not FSymbol.Continuous) or (ItemOrder=0) then
           Inc(R.Top,2);

        if (not FSymbol.Continuous) or (ItemOrder=(ILastValue-FirstValue)) then
           Dec(R.Bottom,1+2+FVertSpacing);

        Item[ItemIndex].FSymbol:=R;
      end;

      if InternalLegendStyle=lsSeriesGroups then
      begin
        if CheckBoxes then
           DrawBox(SeriesList.Groups[ItemIndex].Active<>gaNo,tmpX,PosYLegend);

         // DrawSymbol(nil,-1,R)  // Groups have no symbol ! (yet)
      end
      else
      if (InternalLegendStyle=lsSeries) or (InternalLegendStyle=lsLastValues) then
      begin
        if CheckBoxes then
        begin
          tmpSeries:=SeriesLegend(ItemIndex,False);
          DrawBox(tmpSeries.Active,tmpX,PosYLegend);
          DrawSymbol(tmpSeries, TeeAllValues, R);
        end
        else
          DrawSymbol(ActiveSeriesLegend(ItemIndex), TeeAllValues, R);
      end
      else
      begin
        if Assigned(tmpSeries) then
           DrawSymbol(tmpSeries,tmpSeries.LegendToValueIndex(ItemIndex),R)
        else
           DrawSymbol(nil,-1,R);
      end;

      if (ItemOrder>0) and (FDividingLines.Visible) then
      begin
        // For horizontal legend position, draw lines only when drawing row zero:
        if Self.Vertical or (tmpOrder=0) then
        begin
          AssignVisiblePen(FDividingLines);
          BackMode:=cbmTransparent;

          if Self.Pen.Visible then
             tmpBorder:=(1+Self.Pen.Width) div 2
          else
             tmpBorder:=0;

          if Self.Vertical then
             DoHorizLine(ShapeBounds.Left+tmpBorder,ShapeBounds.Right-tmpBorder,
                         PosYLegend-(FVertSpacing div 2) )
          else
             DoVertLine(ShapeBounds.Left+tmpX+TeeLegendOff2,
                        ShapeBounds.Top+tmpBorder,ShapeBounds.Bottom-tmpBorder);
        end;
      end;
    end;
  end;

var
  FrameWidth : Integer;

  Function MaxLegendValues(YLegend,ItemHeight:Integer):Integer;

    Function CalcMaxLegendValues(A,B,C:Integer):Integer;
    begin
      With ParentChart do
      Begin
        if (YLegend<A) and (ItemHeight>0) then
        Begin
          result:=((B-2*FrameWidth)-YLegend+C) div ItemHeight;  // 6.02
          result:=Math.Min(result,TotalLegendItems);
        end
        else result:=0;
      end;
    end;

  Begin
    With ParentChart do
    if Self.Vertical then
       result:=CalcMaxLegendValues(ChartRect.Bottom,ChartHeight,ChartRect.Top)
    else
       result:=CalcMaxLegendValues(ChartRect.Right,ChartWidth,0);
  end;

  // Returns the maximum number of Legend items available to display
  Function CalcTotalItems:Integer;
  var tmpSeries : TChartSeries;
      t         : Integer;
  begin
    result:=0;

    if InternalLegendStyle=lsSeriesGroups then
       result:=TCustomChart(ParentChart).SeriesList.Groups.Count
    else
    if (InternalLegendStyle=lsSeries) or (InternalLegendStyle=lsLastValues) then
    begin
      for t:=0 to TCustomChart(ParentChart).SeriesCount-1 do
      begin
        With TCustomChart(ParentChart).Series[t] do
             if (CheckBoxes or Active) and ShowInLegend then
                Inc(result);
      end;

      Dec(result,FirstValue);
    end
    else
    begin
      tmpSeries:=GetLegendSeries;

      if Assigned(tmpSeries) and (tmpSeries.ShowInLegend) then
         result:=tmpSeries.CountLegendItems-FirstValue;
    end;

    result:=Math.Max(0,result);
  end;

  // Draws all legend items
  Procedure DrawItems;
  var t : Integer;
  begin
    tmpSeries:=GetLegendSeries;

    if not FItems.Custom then
       FItems.ClearItems;

    if Inverted then
       for t:=ILastValue downto FirstValue do
           DrawLegendItem(t,(ILastValue-t))
    else
       for t:=FirstValue to ILastValue do
           DrawLegendItem(t,(t-FirstValue));
  end;

  // Prepares and stores all legend items to display
  Procedure GetItems;

    Procedure SetItem(AIndex,APos:Integer);
    var tmpSt : String;
        tmp   : Integer;
        i     : Integer;
        tmpC  : TCustomChart;
    begin
      tmpC:=ParentChart as TCustomChart;
      tmpSt:=tmpC.InternalFormattedLegend(Self,APos); { 5.01 }
      tmp:=0;

      Repeat
        i:={$IFDEF CLR}Pos{$ELSE}AnsiPos{$ENDIF}(TeeColumnSeparator,tmpSt);

        if i>0 then
        begin
          Items[AIndex,tmp]:=Copy(tmpSt,1,i-1);
          Delete(tmpSt,1,i);
          Inc(tmp);
        end;

      Until (i=0) or (tmpSt='') or (tmp>1);

      if (tmpSt<>'') and (tmp<=1) then
         Items[AIndex,tmp]:=tmpSt;
    end;

  var t : Integer;
  begin
    SetLength(Items,ILastValue-FirstValue+1);

    if Inverted then
       for t:=ILastValue downto FirstValue do SetItem(ILastValue-t,t)
    else
       for t:=FirstValue to ILastValue do SetItem(t-FirstValue,t);
  end;

  // Calculates the horizontal position of legend symbols
  Procedure CalcSymbolTextPos(ALeftPos:Integer);
  var tmp : Integer;
  begin
    tmp:=ALeftPos+TeeLegendOff2+TeeLegendOff4;

    if Symbol.Position=spLeft then
    begin
      XLegendColor:=tmp;
      XLegendText :=XLegendColor+IColorWidth+TeeLegendOff4;

      if Symbol.Shadow.Visible and (Symbol.Shadow.HorizSize>0) then
         Inc(XLegendText,Symbol.Shadow.HorizSize); // 7.07
    end
    else
    begin
      XLegendText :=tmp;
      XLegendColor:=XLegendText+tmpMaxWidth;
    end;
  end;

  // Prepares coordinates for horizontal legend alignment
  Procedure CalcHorizontalPositions;
  var HalfMaxWidth : Integer;
      tmpW         : Integer;
  begin
    HalfMaxWidth:=4*TeeLegendOff2+((tmpMaxWidth+IColorWidth)*NumCols)+
                  ((TeeLegendOff2+TeeLegendOff4)*(NumCols-1)+TeeLegendOff4);

    if not Vertical then
       Inc(HalfMaxWidth,NumCols*TeeLegendOff2);

    if HasCheckBoxes then
       Inc(HalfMaxWidth,TeeLegendOff4+(TeeCheckBoxSize+TeeLegendOff4)*NumCols);

    if IDrawTitle then {TV52010115 7.07}
       HalfMaxWidth:=Max(HalfMaxWidth,Self.Title.TotalWidth);

    HalfMaxWidth:=Math.Min(ParentChart.ChartWidth,HalfMaxWidth);

    HalfMaxWidth:=HalfMaxWidth div 2;

    With ShapeBounds do
    begin
      if not CustomPosition then
      begin
        tmpW:=Round(1.0*FTopLeftPos*
            (ParentChart.ChartBounds.Right-ParentChart.ChartBounds.Left
             -2*HalfMaxWidth)*0.01); // 5.02

        Left:=ParentChart.ChartXCenter-HalfMaxWidth+tmpW;
      end;

      Right:=Left+(2*HalfMaxWidth);
      tmpW:=Left;
    end;

    if HasCheckBoxes then
    begin
      XLegendBox:=tmpW+TeeLegendOff4;
      Inc(tmpW,TeeCheckBoxSize+TeeLegendOff4);
    end;

    CalcSymbolTextPos(tmpW);
  end;

  // Calls OnGetLegendRect event
  Procedure GetLegendRectangle;
  var tmpRect : TRect;
  begin
    tmpRect:=ShapeBounds;
    TCustomChart(ParentChart).FOnGetLegendRect(TCustomChart(ParentChart),tmpRect);
    ShapeBounds:=tmpRect;
  end;

  // Calculates maximum legend item width
  Function CalcColumnsWidth(NumLegendValues:Integer):Integer;
  var t  : Integer;
      tt : Integer;
      tmpW  : Integer;
      tmpSt : String;
  Begin
    if ColumnWidthAuto then
    for t:=0 to TeeMaxLegendColumns-1 do
    begin
      ColumnWidths[t]:=0;

      With ParentChart.Canvas do
      for tt:=FirstValue to ILastValue do
      begin

        if FItems.Custom and (FItems.Count>tt-FirstValue) then
           if t=0 then
              tmpSt:=FItems[tt-FirstValue].FText
           else
              tmpSt:=FItems[tt-FirstValue].FText2
        else
           tmpSt:=Items[tt-FirstValue,t];

        if tmpSt<>'' then
        begin
          if TextFormat=ttfNormal then
             tmpW:=TextWidth(tmpSt)
          else
             tmpW:=HtmlTextExtent(ParentChart.Canvas,tmpSt).Width;

          ColumnWidths[t]:=Math.Max(ColumnWidths[t],tmpW);
        end;
      end;
    end;

    result:=0;

    for t:=0 to TeeMaxLegendColumns-1 do
    if ColumnWidths[t]>0 then
       Inc(result,ISpaceWidth+ColumnWidths[t]-1);
  end;

  // Prepares coordinates for vertical legend alignment
  Procedure CalcVerticalPositions;
  var tmpTotalWidth : Integer;

    Procedure CalcWidths;
    begin
      tmpMaxWidth:=CalcColumnsWidth(NumRows);
      tmpTotalWidth:=2*TeeLegendOff4+tmpMaxWidth+2*TeeLegendOff2;

      if InternalLegendStyle=lsSeriesGroups then
         IColorWidth:=0  // Series groups have no symbol (yet!)
      else
      begin
        IColorWidth:=Symbol.CalcWidth(tmpTotalWidth);
        Inc(tmpTotalWidth,IColorWidth);

        if Symbol.Visible and Symbol.Shadow.Visible then
           Inc(tmpTotalWidth,Symbol.Shadow.HorizSize);
      end;

      if Assigned(FOnCalcSize) then
         FOnCalcSize(Self,tmpTotalWidth);

      if IDrawTitle then
         tmpTotalWidth:=Max(tmpTotalWidth,Title.TotalWidth);
    end;

  var tmpW : Integer;
  begin
    With ShapeBounds do
    begin
      if CustomPosition or (Alignment=laLeft) then
      begin
        if not CustomPosition then
           Left:=ParentChart.ChartRect.Left+FrameWidth+1;

        CalcWidths;
      end
      else
      begin
        Right:=ParentChart.ChartRect.Right;

        if Shadow.Visible then
           Dec(Right,Shadow.HorizSize);

        Dec(Right,FrameWidth+1);

        CalcWidths;

        Left:=Right-tmpTotalWidth;
        if HasCheckBoxes then
           Dec(Left,TeeCheckBoxSize+TeeLegendOff4);
      end;

      tmpW:=Left;

      if HasCheckBoxes then
      begin
        XLegendBox:=tmpW+TeeLegendOff4;
        tmpW:=XLegendBox+TeeCheckBoxSize;
      end;

      Right:=tmpW+tmpTotalWidth;
      CalcSymbolTextPos(tmpW);
    end;
  end;

  Procedure ResizeVertical;
  var tmp  : Integer;
      tmpH : Integer;
  begin
    ItemsTopMargin:=Round(ItemHeight*0.1); // 7.07
    tmp:=TeeLegendOff2+ItemHeight*NumRows+2*ItemsTopMargin;

    if IDrawTitle then
    begin
      Inc(tmp,Title.Height+2+2);

      if (not Title.Transparent) and Title.Shadow.Visible then
         Inc(tmp,Abs(Title.Shadow.VertSize));
    end;

    if FSymbol.Visible and FSymbol.Shadow.Visible then
    begin
      tmpH:=ItemHeight div 6;

      if FSymbol.Shadow.VertSize>tmpH then
         Inc(tmp,FSymbol.Shadow.VertSize-tmpH);
    end;

    With ShapeBounds do
    if (Alignment=laBottom) and (not CustomPosition) then
       Top:=Bottom-tmp
    else
       Bottom:=Top+tmp;
  end;

  Procedure ResizeChartRect;

    Function CalcMargin(AMargin,ADefault,ASize:Integer):Integer;
    begin
      if AMargin=0 then result:=ADefault*ASize div 100
       	           else result:=AMargin;
    end;

    procedure ResizeChartRect;
    var tmp : Integer;
    begin
      if ResizeChart and (not CustomPosition) then
      with ParentChart do
      begin
        Case {$IFDEF LCL}Self.{$ENDIF}Alignment of
          laLeft   : ChartRect.Left  :=ShapeBounds.Right;
          laRight  : ChartRect.Right :=ShapeBounds.Left;

          laTop    : begin
                       ChartRect.Top:=ShapeBounds.Bottom;
                       if Shadow.Visible then
                          Inc(ChartRect.Top,Shadow.VertSize);
                     end;

          laBottom : ChartRect.Bottom:=ShapeBounds.Top;
        end;

        if Vertical then
        begin
          tmp:=CalcMargin(HorizMargin,TeeDefHorizMargin,ChartWidth);

          if {$IFDEF LCL}Self.{$ENDIF}Alignment=laLeft then
             Inc(ChartRect.Left,tmp)
          else
             Dec(ChartRect.Right,tmp);
        end
        else
        begin
          tmp:=CalcMargin(VertMargin,TeeDefVerticalMargin,ChartHeight);
          if {$IFDEF LCL}Self.{$ENDIF}Alignment=laTop then
             Inc(ChartRect.Top,tmp)
          else
             Dec(ChartRect.Bottom,tmp);
        end;
      end;  // 7.0
    end;

  begin
    if not {$IFNDEF CLR}TCustomChartAccess{$ENDIF}(ParentChart).CustomChartRect then
       ResizeChartRect;

    ParentChart.ReCalcWidthHeight;
  end;

var IsPage   : Boolean;
    tmpCol   : Integer;
    tmpSize  : Integer;
    tmp      : Integer;
    tmpChart : TCustomChart;
    tmpPage  : TChartPage;
Begin
  TCanvasAccess(ParentChart.Canvas).BeginEntity('Legend');

  CalcLegendStyle;

  { calculate Frame Width offset }
  if Frame.Visible then FrameWidth:=Frame.Width
                   else FrameWidth:=0;

  if Bevel<>bvNone then FrameWidth:=BevelWidth;

  if CustomPosition then
  begin
    if PositionUnits=muPercent then
    begin
      tmp:=ShapeBounds.Right-ShapeBounds.Left;
      ShapeBounds.Left:=Round(LeftPercent*ParentChart.Width*0.01);
      ShapeBounds.Right:=ShapeBounds.Left+tmp;

      tmp:=ShapeBounds.Bottom-ShapeBounds.Top;
      ShapeBounds.Top:=Round(TopPercent*ParentChart.Height*0.01);
      ShapeBounds.Bottom:=ShapeBounds.Top+tmp;
    end;

    OffsetRect(ShapeBounds,ParentChart.ChartBounds.Left,
                           ParentChart.ChartBounds.Top);
  end;

  tmpChart:=TCustomChart(ParentChart);
  tmpPage:=tmpChart.Pages;

  IsPage:=(InternalLegendStyle=lsValues) and FCurrentPage and (tmpPage.MaxPointsPerPage>0);

  if IsPage then
     FirstValue:=tmpPage.FirstValueIndex;

  if (tmpPage.MaxPointsPerPage>0) and (InternalLegendStyle<>lsValues) then
     FirstValue:=0;

  ITotalItems:=CalcTotalItems;

  if IsPage then
     ITotalItems:=Math.Min(ITotalItems,tmpPage.MaxPointsPerPage);

  tmpChart.LegendColor:=Color;

  tmpChart.Canvas.AssignFont(Font);
  ISpaceWidth:=tmpChart.Canvas.TextWidth(' '); // Do not localize

  // Calculate default Height for each Legend Item
  ItemHeight:=CalcItemHeight;

  IDrawTitle:=Title.Visible and (Title.Text.Text<>'');
  if IDrawTitle then
  begin
    Title.CalcHeight;
    tmpChart.Canvas.AssignFont(Font); // Reset font again
  end;

  if Vertical then
  begin
    if not FCustomPosition then
    with tmpChart.ChartBounds do
         ShapeBounds.Top:=Top+Round(1.0*FTopLeftPos*(Bottom-Top)*0.01);

    NumCols:=1;
    NumRows:=MaxLegendValues(FirstItemTop,ItemHeight);
    ILastValue:=FirstValue+Math.Min(ITotalItems,NumRows)-1;
    GetItems;  // Only Visible !!
  end
  else
  begin
    ILastValue:=FirstValue+ITotalItems-1;
    GetItems;  // All !!
    tmpMaxWidth:=CalcColumnsWidth(TeeAllValues);
    IColorWidth:=Symbol.CalcWidth(tmpMaxWidth);

    if not FCustomPosition then
       with ShapeBounds do
       if Alignment=laBottom then
       begin
         tmpSize:=FrameWidth+1;

         if Shadow.Visible then
            Inc(tmpSize,Shadow.VertSize);

         if Assigned(FOnCalcSize) then
            FOnCalcSize(Self,tmpSize);

         Bottom:=tmpChart.ChartRect.Bottom-tmpSize;
       end
       else
          Top:=tmpChart.ChartRect.Top+FrameWidth+1;

    tmpCol:=tmpMaxWidth+IColorWidth+2*TeeLegendOff4;
    if HasCheckBoxes then
       Inc(tmpCol,TeeCheckBoxSize+2*TeeLegendOff2+3*TeeLegendOff4); // 5.03

    NumCols:=MaxLegendValues(2*TeeLegendOff4,tmpCol);

    if NumCols>0 then
    begin
      NumRows:=ITotalItems div NumCols;
      if (ITotalItems mod NumCols)>0 then Inc(NumRows);
      NumRows:=Math.Min(NumRows,MaxNumRows);
    end
    else NumRows:=0;

    { adjust the last index now we know the max number of rows... }
    ILastValue:=FirstValue+Math.Min(ITotalItems,NumCols*NumRows)-1;
  end;

  if ILastValue>=FirstValue then  // Should draw legend ?
  begin
    ResizeVertical;

    if Vertical then CalcVerticalPositions
                else CalcHorizontalPositions;

    if Assigned(TCustomChart(ParentChart).FOnGetLegendRect) then
       GetLegendRectangle;

    Draw;

    if IDrawTitle then
    begin
      Title.CalcShapeBounds(ShapeBounds);
      Title.Draw;  // 6.02
      Title.DrawText;
      ParentChart.Canvas.AssignFont(Font);
    end;

    DrawItems;
    ResizeChartRect;
  end;

  if CustomPosition then
     OffsetRect(ShapeBounds,-ParentChart.ChartBounds.Left,
                            -ParentChart.ChartBounds.Top);

  Items:=nil;  // Release memory

  TCanvasAccess(ParentChart.Canvas).EndEntity;
end;

Function TCustomChartLegend.FormattedValue(ASeries:TChartSeries; ValueIndex:Integer):String;
begin
  if ValueIndex<>TeeAllValues then
     // eliminate breaks in string...
     result:=ReplaceChar(ASeries.LegendString(ValueIndex,TextStyle),
                         TeeLineSeparator,' ')  // Do not localize
  else
     result:='';
end;

procedure TCustomChartLegend.SetSeries(const Value: TChartSeries);
begin
  FSeries:=Value;
  Repaint;
end;

Function TCustomChartLegend.Clicked(x,y:Integer):Integer;
var tmpH : Integer;

  Function ClickedRow:Integer;
  var t   : Integer;
      tmp : Integer;
  begin
    result:=-1;

    for t:=0 to NumRows-1 do
    begin
      tmp:=FirstItemTop+1+t*tmpH;

      if (y>=tmp) and (y<=(tmp+tmpH)) then
      begin
      	result:=t;
        if Inverted then result:=NumRows-t-1;
        break;
      end;
    end;
  end;

  Function GetLegendBounds:TRect;
  var tmp : Integer;
  begin
    result:=ShapeBounds;

    if Assigned(FOnCalcSize) then // Has scrollbar ?
    begin
      tmp:=0;
      FOnCalcSize(Self,tmp);
      Dec(result.Right,tmp);
    end;
  end;

var t    : Integer;
    tmp2 : Integer;
    tmpW : Integer;
    tmpMod : Integer;
begin
  result:=-1;

  if PointInRect(GetLegendBounds,x,y) then { inside legend }
  begin
    ParentChart.Canvas.AssignFont(Font);
    tmpH:=CalcItemHeight; // 6.0

    if Vertical then
       result:=ClickedRow+FirstValue  // 7.0
    else
    if NumCols>0 then
    begin
      tmpW:=(ShapeBounds.Right-ShapeBounds.Left) div NumCols;

      for t:=0 to NumCols-1 do
      begin
        tmp2:=ShapeBounds.Left+1+t*tmpW;

        if (x>=tmp2) and (x<=(tmp2+tmpW)) then
        begin
          result:=ClickedRow;

          if result<>-1 then
          begin
            result:=NumCols*result;

            if Inverted then
            begin
              Inc(result,NumCols-t-1);  // 5.02

              // Decrement empty items at last row, if any. (v8 fix)
              tmpMod:=((LastValue-FirstValue)+1) mod NumCols;

              if tmpMod>0 then
                 Dec(result,NumCols-tmpMod); // v8
            end
            else
               Inc(result,t);

            if result>ITotalItems-1 then result:=-1
                                    else Inc(result,FirstValue); // 7.04 TV52010293

          end;
        end;
      end;
    end;
  end;
end;

function TCustomChartLegend.GetGradientClass: TChartGradientClass;
begin
  result:=TChartLegendGradient;
end;

Function TCustomChartLegend.HasCheckBoxes:Boolean;
begin
  result:=CheckBoxes and (InternalLegendStyle<>lsValues);
end;

Function TCustomChartLegend.DoMouseDown(Const x,y:Integer; PointIndex:Integer):Boolean;
var t   : Integer;
    tmpSeries : TChartSeries;
begin
  result:=False;

  if HasCheckBoxes then
  begin
    if PointIndex<>-1 then
    begin

      if InternalLegendStyle=lsSeriesGroups then
      begin
        if CheckBoxesStyle=cbsCheck then
           With TCustomChart(ParentChart).SeriesList.Groups[PointIndex] do
           if Active=gaNo then Active:=gaYes
                          else Active:=gaNo
        else
        With TCustomChart(ParentChart).SeriesList.Groups do
        for t:=0 to Count-1 do
        if t=PointIndex then
           Items[t].Active:=gaYes
        else
           Items[t].Active:=gaNo;
      end
      else
      begin
        if CheckBoxesStyle=cbsCheck then
        begin
          tmpSeries:=TCustomChart(ParentChart).SeriesLegend(PointIndex,False);

          if Assigned(tmpSeries) then
             tmpSeries.Active:=not tmpSeries.Active;
        end
        else
        With TCustomChart(ParentChart) do
        for t:=0 to SeriesCount-1 do
        begin
          tmpSeries:=SeriesLegend(t,False);

          if Assigned(tmpSeries) then
             tmpSeries.Active:=t=PointIndex;
        end;
      end;

      result:=True;
    end;
  end;
end;

{ Utility routines }

{ Draws the Series "Legend" on the specified rectangle and Canvas }
Procedure PaintSeriesLegend(ASeries:TChartSeries; ACanvas:TCanvas; Const R:TRect;
                            ReferenceChart:TCustomChart=nil);
var OldCanvas : TCanvas;
    tmpChart  : TCustomChart;
    IsTempChart : Boolean;
    IsSeriesChart : Boolean;
    OldBitmap     : TBitmap;
begin
  IsTempChart:=False;
  IsSeriesChart:=False;

  tmpChart:=TCustomChart(ASeries.ParentChart);

  if not Assigned(tmpChart) then
  begin
    tmpChart:=ReferenceChart;

    if not Assigned(tmpChart) then
    begin
      tmpChart:=TCustomChart.Create(nil);
      IsTempChart:=True;
    end;

    ASeries.ParentChart:=tmpChart;
    IsSeriesChart:=True;
  end;

  ACanvas.Brush.Style:=bsSolid;
  ACanvas.Brush.Color:=tmpChart.Legend.Color;
  tmpChart.Legend.PrepareSymbolPen;

  With tmpChart do
  if not Canvas.SupportsFullRotation then
  begin
    OldCanvas:=Canvas.ReferenceCanvas;

    if Canvas is TTeeCanvas3D then
    begin
      OldBitmap:=TTeeCanvas3D(Canvas).Bitmap;
      TTeeCanvas3D(Canvas).Bitmap:=nil;
    end
    else
      OldBitmap:=nil;

    Canvas.ReferenceCanvas:=ACanvas;
    try
      ASeries.DrawLegend(-1,R);
    finally
      Canvas.ReferenceCanvas:=OldCanvas;
    end;

    if Canvas is TTeeCanvas3D then
       TTeeCanvas3D(Canvas).Bitmap:=OldBitmap;
  end;

  if IsSeriesChart then
     ASeries.ParentChart:=nil;

  if IsTempChart then
     tmpChart.Free;
end;

{ Returns a valid Name for a new Series (eg: Series1, Series2, etc) }
Function GetNewSeriesName(AOwner:TComponent):TComponentName;
begin
  result:=TeeGetUniqueName(AOwner,TeeMsg_DefaultSeriesName);
end;

{ Copies all properties from OldSeries to NewSeries }
type TChartAccess=class(TCustomAxisPanel);

Procedure AssignSeries(var OldSeries,NewSeries:TChartSeries);
var OldName   : TComponentName;
    tmpSeries : TChartSeries;
    t         : Integer;
begin
  if NewSeries<>OldSeries then
  begin
    NewSeries.Assign(OldSeries);

    With NewSeries do
    begin    { events }
      AfterDrawValues  :=OldSeries.AfterDrawValues;
      BeforeDrawValues :=OldSeries.BeforeDrawValues;
      OnAfterAdd       :=OldSeries.OnAfterAdd;
      OnBeforeAdd      :=OldSeries.OnBeforeAdd;
      OnClearValues    :=OldSeries.OnClearValues;
      OnClick          :=OldSeries.OnClick;
      OnDblClick       :=OldSeries.OnDblClick;
      OnGetMarkText    :=OldSeries.OnGetMarkText;
    end;

    OldName:=OldSeries.Name;

    While OldSeries.LinkedSeries.Count>0 do
    begin
      tmpSeries:=OldSeries.LinkedSeries[0];

      { after removing... }
      With tmpSeries.DataSources do
      begin
        if IndexOf(NewSeries)=-1 then Add(NewSeries);
        if IndexOf(OldSeries)<>-1 then Remove(OldSeries);
      end;

      TSeriesAccess(NewSeries).AddLinkedSeries(tmpSeries);
      TSeriesAccess(OldSeries).RemoveLinkedSeries(tmpSeries);
    end;

    // Replace old series with new series in tools
    with OldSeries.ParentChart do
    for t:=0 to Tools.Count-1 do
    if Tools[t] is TTeeCustomToolSeries then
       with TTeeCustomToolSeries(Tools[t]) do
            if Series=OldSeries then Series:=NewSeries;

    // Swap Series on Chart list
    OldSeries.ParentChart.ExchangeSeries(OldSeries,NewSeries);

    FreeAndNil(OldSeries);

    NewSeries.Name:=OldName;
    TChartAccess(NewSeries.ParentChart).BroadcastSeriesEvent(NewSeries,seChangeTitle);
    NewSeries.CheckDataSource;

    if TSeriesAccess(NewSeries).ManualData then
       NewSeries.RefreshSeries;
  end;
end;

{ Creates a new TeeFunction object, associates it with a Series, and returns it }
Function CreateNewTeeFunction(ASeries:TChartSeries; AClass:TTeeFunctionClass):TTeeFunction;
begin
  result:=AClass.Create(ASeries.Owner);
  result.ParentSeries:=ASeries;
  result.Name:=TeeGetUniqueName(ASeries.Owner,TeeMsg_DefaultFunctionName);
end;

{ Creates a new Series object and sets the Name, ParentChart and
  FunctionType properties }
Function CreateNewSeries( AOwner:TComponent;
			  AChart:TCustomAxisPanel;
			  AClass:TChartSeriesClass;
			  AFunctionClass:TTeeFunctionClass=nil):TChartSeries;
var t : Integer;
begin
  if not Assigned(AOwner) then AOwner:=AChart;  { 4.0 }

  { 5.01 If the Chart already contains Series as Owner, make new Series
         have the Chart as owner as well.  This helps when saving charts
         to *.tee files, that have series created at run-time }
  if Assigned(AChart) then { 5.02 }
    for t:=0 to AChart.SeriesCount-1 do
    if AChart[t].Owner=AChart then
    begin
      AOwner:=AChart;
      break;
    end;

  result:=AClass.Create(AOwner);
  result.Name:=GetNewSeriesName(AOwner);
  result.ParentChart:=AChart;

  if Assigned(AFunctionClass) then
     CreateNewTeeFunction(result,AFunctionClass);
end;

// Duplicates a Series. Adds the new Series to ASeries.ParentChart
Function CloneChartSeries(ASeries:TChartSeries):TChartSeries;
begin
  result:=CloneChartSeries(ASeries,ASeries.ParentChart);
end;

// Duplicates ASeries, adds the new Series to AChart
Function CloneChartSeries(ASeries:TChartSeries; AChart:TCustomAxisPanel):TChartSeries;
begin
  result:=CloneChartSeries(ASeries,ASeries.Owner,AChart);
end;

// Duplicates ASeries with AOwner as new series owner, adds the new Series to AChart
Function CloneChartSeries(ASeries:TChartSeries; AOwner:TComponent; AChart:TCustomAxisPanel):TChartSeries;
var tmp : TTeeFunctionClass;
begin
  with ASeries do
  begin
    if FunctionType=nil then
       tmp:=nil
    else
       tmp:=TTeeFunctionClass(FunctionType.ClassType);

    result:=CreateNewSeries(AOwner,AChart,TChartSeriesClass(ClassType),tmp);
  end;

  result.Assign(ASeries);
end;

// Duplicates a Chart Tool. Adds the new Tool to ATool.ParentChart
function CloneChartTool(ATool:TTeeCustomTool; AOwner:TComponent):TTeeCustomTool;
begin
  result:=TTeeCustomToolClass(ATool.ClassType).Create(AOwner);

  {$IFNDEF TEEOCX}
  result.Name:=TeeGetUniqueName(AOwner,TeeMsg_DefaultToolName);
  {$ELSE}
  //due to Owner=nil in ocx version
  //result.Name:=TeeAXGetUniqueName(TeeMsg_DefaultToolName);
  {$ENDIF}

  result.Assign(ATool);
end;

{ Replaces ASeries object with a new Series object of another class }
Function ChangeSeriesType(var ASeries:TChartSeries; NewType:TChartSeriesClass):TChartSeries;
var NewSeries : TChartSeries;
begin
  if ASeries.ClassType<>NewType then { only if different classes }
  begin
    NewSeries:=CreateNewSeries(ASeries.Owner,ASeries.ParentChart,NewType);

    if Assigned(NewSeries) then
    begin
      AssignSeries(ASeries,NewSeries);
      ASeries:=NewSeries;  { <-- change parameter }
    end;
  end;

  result:=ASeries;
end;

{ Replaces all Series objects in a Chart with a new Series class type }
procedure ChangeAllSeriesType( AChart:TCustomChart; AClass:TChartSeriesClass );
var t         : Integer;
    tmpSeries : TChartSeries;
begin
  for t:=0 to AChart.SeriesCount-1 do
  begin
    tmpSeries:=AChart.Series[t];
    ChangeSeriesType(tmpSeries,AClass);
  end;
end;

function TCustomChartLegend.ShouldDraw: Boolean;
begin
  result:=Visible and
      (HasCheckBoxes or (TCustomChart(ParentChart).CountActiveSeries>0))
end;

procedure TCustomChartLegend.SetTitle(const Value: TLegendTitle);
begin
  FTitle.Assign(Value);
end;

{ TTeeSeriesTypes }

Procedure TTeeSeriesTypes.Clear;
var t : Integer;
begin
  for t:=0 to Count-1 do Items[t].Free;
  inherited;
end;

Function TTeeSeriesTypes.Get(Index:Integer):TTeeSeriesType;
begin
  result:=TTeeSeriesType({$IFOPT R-}List{$ELSE}inherited Items{$ENDIF}[Index]);
end;

Function TTeeSeriesTypes.Find(ASeriesClass:TChartSeriesClass):TTeeSeriesType;
var t : Integer;
begin
  for t:=0 to Count-1 do
  begin
    result:=Items[t];
    if (result.SeriesClass=ASeriesClass) and (result.FunctionClass=nil) then
       exit;
  end;
  result:=nil;
end;

// Workaround a possible C++ compiler bug (initialization order of units)
function CheckTeeSeriesTypes:TTeeSeriesTypes;
begin
  if not Assigned(TeeSeriesTypes) then
     TeeSeriesTypes:=TTeeSeriesTypes.Create;

  result:=TeeSeriesTypes;
end;

Procedure RegisterTeeSeriesFunction( ASeriesClass:TChartSeriesClass;
				     AFunctionClass:TTeeFunctionClass;
				     ADescription,AGalleryPage:PString;
				     ANumGallerySeries:Integer=1;
             ASubIndex:Integer=0);
var t             : Integer;
    NewSeriesType : TTeeSeriesType;
    tmpTypes      : TTeeSeriesTypes;
begin
  if Assigned(ASeriesClass) then {$IFNDEF CLR}Classes.{$ENDIF}RegisterClass(ASeriesClass);
  if Assigned(AFunctionClass) then {$IFNDEF CLR}Classes.{$ENDIF}RegisterClass(AFunctionClass);

  tmpTypes:=CheckTeeSeriesTypes;

  if ASubIndex=0 then
  begin
    for t:=0 to tmpTypes.Count-1 do
    With tmpTypes[t] do
      if (SeriesClass=ASeriesClass) and
         (FunctionClass=AFunctionClass) then
            Exit;
  end;

  NewSeriesType:=TTeeSeriesType.Create;
  with NewSeriesType do
  begin
    SeriesClass   := ASeriesClass;
    FunctionClass := AFunctionClass;
    Description   := ADescription;
    GalleryPage   := AGalleryPage;
    NumGallerySeries := ANumGallerySeries;
    SubIndex         := ASubIndex;
  end;

  tmpTypes.Add(NewSeriesType);
end;

{ Adds a new Series component definition for the Gallery }
Procedure RegisterTeeSeries( ASeriesClass:TChartSeriesClass;
			     ADescription,AGalleryPage:PString;
			     ANumGallerySeries : Integer );
begin
  RegisterTeeSeriesFunction( ASeriesClass,
			     nil,
			     ADescription,
			     AGalleryPage,
			     ANumGallerySeries );
end;

Procedure RegisterTeeSeries( ASeriesClass:TChartSeriesClass;
			     ADescription:PString); overload;
begin
  RegisterTeeSeries(ASeriesClass,ADescription,{$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryStandard,2);
end;

Procedure RegisterTeeFunction( AFunctionClass:TTeeFunctionClass;
			       ADescription,AGalleryPage:PString;
			       ANumGallerySeries : Integer=1 );
begin
  RegisterTeeSeriesFunction( nil,
			     AFunctionClass,
			     ADescription,
			     AGalleryPage,
			     ANumGallerySeries);
end;

Procedure RegisterTeeBasicFunction( AFunctionClass:TTeeFunctionClass;
				    ADescription:PString);
begin
  RegisterTeeFunction(AFunctionClass,ADescription,{$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryStandard,2);
end;

Procedure InternalUnRegister(IsSeries:Boolean; AClass:TComponentClass);
var tmp      : TTeeSeriesType;
    t        : Integer;
    tmpTypes : TTeeSeriesTypes;
begin
  t:=0;
  tmpTypes:=CheckTeeSeriesTypes;

  While t<tmpTypes.Count do
  begin
    tmp:=tmpTypes[t];

    if (IsSeries and (tmp.SeriesClass=AClass)) or
     ((not IsSeries) and (tmp.FunctionClass=AClass)) then
    begin
      tmp.Free;
      tmpTypes.Delete(t);
    end
    else Inc(t);
  end;
end;

Procedure UnRegisterTeeSeries(Const ASeriesList:Array of TChartSeriesClass);
var t : Integer;
begin
  for t:=Low(ASeriesList) to High(ASeriesList) do
      InternalUnRegister(True,ASeriesList[t]);
end;

Procedure UnRegisterTeeFunctions(Const AFunctionList:Array of TTeeFunctionClass);
var t : Integer;
begin
  for t:=Low(AFunctionList) to High(AFunctionList) do
      InternalUnRegister(False,AFunctionList[t]);
end;

{$IFNDEF CLX}
{ TTeeDragObject }
constructor TTeeDragObject.Create(Const APart: TChartClickedPart);
begin
  {$IFDEF CLR}
  inherited Create;
  {$ENDIF}
  FPart:=APart;
end;

{function TTeeDragObject.GetDragImages: TCustomImageList;
begin
  Result := FPart.GetDragImages;
end;}

{procedure TTeeDragObject.HideDragImage;
begin
  if FPart.GetDragImages <> nil then
    FPart.GetDragImages.HideDragImage;
end;

procedure TTeeDragObject.ShowDragImage;
begin
  if FPart.GetDragImages <> nil then
    FPart.GetDragImages.ShowDragImage;
end;
}

//Const crTeeDrag      = 2021;
//      TeeMsg_TeeDrag = 'crTeeDrag'; { string cursor name (dont translate) }

function TTeeDragObject.GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor;
begin
  if Accepted then Result := crTeeHand
              else Result := crNoDrop;
end;

procedure TTeeDragObject.Finished(Target: TObject; X, Y: Integer; Accepted: Boolean);
begin
  if not Accepted then
  begin
{    FPart.DragCanceled;}
{    Target := nil;}
  end;
{  if Assigned(FPart. FOnEndDrag) then FOnEndDrag(Self, Target, X, Y);}
{  FPart.DoEndDrag(Target, X, Y);}
end;
{$ENDIF}

{ TTeeToolTypes }
function TTeeToolTypes.Get(Index: Integer): TTeeCustomToolClass;
begin
  result:=TTeeCustomToolClass({$IFOPT R-}List{$ELSE}inherited Items{$ENDIF}[Index]);
end;

// Workaround a possible C++ bug (initialization order of TeeTools vs. Chart units)
function CheckTeeToolTypes:TTeeToolTypes;
begin
  if not Assigned(TeeToolTypes) then
     TeeToolTypes:=TTeeToolTypes.Create;

  result:=TeeToolTypes;
end;

Procedure RegisterTeeTools({$IFNDEF BCB}const{$ENDIF} ATools:Array of TTeeCustomToolClass);
var t : Integer;
begin
  With CheckTeeToolTypes do
  for t:=Low(ATools) to High(ATools) do
  if IndexOf({$IFDEF CLR}TObject{$ENDIF}(ATools[t]))=-1 then
  begin
    {$IFNDEF CLR}Classes.{$ENDIF}RegisterClass(ATools[t]);
    Add({$IFDEF CLR}TObject{$ENDIF}(ATools[t]));
  end;
end;

Procedure UnRegisterTeeTools({$IFNDEF BCB}const{$ENDIF} ATools:Array of TTeeCustomToolClass);
var t   : Integer;
    tmp : Integer;
begin
  With CheckTeeToolTypes do
  for t:=Low(ATools) to High(ATools) do
  begin
    tmp:=IndexOf({$IFDEF CLR}TObject{$ENDIF}(ATools[t]));
    if tmp<>-1 then Delete(tmp);
  end;
end;

Function GetGallerySeriesName(ASeries:TChartSeries):String;
var AType : TTeeSeriesType;
begin
  AType:=CheckTeeSeriesTypes.Find(TChartSeriesClass(ASeries.ClassType));

  if Assigned(AType) then result:=AType.Description{$IFNDEF CLR}^{$ENDIF}
                     else result:=ASeries.ClassName;
end;

{ TLegendTitle }

procedure TLegendTitle.Assign(Source: TPersistent);
begin
  if Source is TLegendTitle then
  with TLegendTitle(Source) do
  begin
    Self.Text:=Text;
    Self.FTextAlign:=TextAlignment;
  end;
  inherited;
end;

Constructor TLegendTitle.Create(AOwner: TCustomTeePanel);
begin
  inherited;

  FText:=TStringList.Create;
  FText.OnChange:=TextChanged;
  Transparent:=True;
  DefaultTransparent:=True;

  Font.Style:=[fsBold];
  TTeeFontAccess(Font).IDefStyle:=Font.Style;

  Shadow.Size:=2;
  Shadow.Color:=clSilver;

  with {$IFNDEF CLR}TShadowAccess{$ENDIF}(Shadow) do
  begin
    DefaultColor:=clSilver;
    DefaultSize:=2;
  end;
end;

destructor TLegendTitle.Destroy;
begin
  FText.Free;
  inherited;
end;

procedure TLegendTitle.TextChanged(Sender:TObject);
begin
  Repaint;
end;

procedure TLegendTitle.DrawText;
var FontH : Integer;
    tmpFrameWidth : Integer;
    tmpXPosTitle : Integer;
    tmpMargin    : Integer;

  Procedure DrawTitleLine(AIndex:Integer);
  var St   : String;
      APos : Integer;
  Begin { draw a title text line }
    St:=Text[AIndex];
    APos:=AIndex*FontH+tmpFrameWidth;
    Inc(APos,ShapeBounds.Top);

    if TextAlignment=taRightJustify then
       tmpXPosTitle:=ShapeBounds.Right-ParentChart.Canvas.TextWidth(St)-(tmpMargin div 2)
    else
    if TextAlignment=taCenter then
       tmpXPosTitle:=((ShapeBounds.Left+ShapeBounds.Right) div 2)-(ParentChart.Canvas.TextWidth(St) div 2);

    with ParentChart do
         Canvas.TextOut(tmpXPosTitle,APos,St);
  end;

var t : Integer;
begin
  // prepare title font
  With ParentChart.Canvas do
  begin
    AssignFont(Self.Font);
    TextAlign:=TA_LEFT;
    FontH:=FontHeight;
    BackMode:=cbmTransparent;
    tmpMargin:=TextWidth(TeeCharForHeight);
  end;

  tmpFrameWidth:=1;

  if TextAlignment=taLeftJustify then
     tmpXPosTitle:=ShapeBounds.Left+(tmpMargin div 2);

  // draw all Title text lines
  if TextFormat=ttfNormal then
     for t:=0 to Text.Count-1 do DrawTitleLine(t)
  else
     ParentChart.Canvas.TextOut(tmpXPosTitle,tmpFrameWidth+ShapeBounds.Top,
                                Text.Text,True);
end;

procedure TLegendTitle.SetText(const Value: TStringList);
begin
  FText.Assign(Value);
  Repaint;
end;

procedure TLegendTitle.SetTextAlign(const Value: TAlignment);
begin
  if FTextAlign<>Value then
  begin
    FTextAlign:=Value;
    Repaint;
  end;
end;

function TLegendTitle.TotalWidth: Integer;
var t : Integer;
begin
  ParentChart.Canvas.AssignFont(Font);

  result:=0;
  for t:=0 to Text.Count-1 do
      result:=Max(result,ParentChart.Canvas.TextWidth(Text[t]));

  Inc(result,ParentChart.Canvas.TextWidth(TeeCharForHeight));

  if not Transparent then
  begin
    if Pen.Visible then
       Inc(result,2*Pen.Width);

    if Shadow.Visible then
       Inc(result,Shadow.HorizSize);
  end;
end;

procedure TLegendTitle.CalcHeight;
begin
  ParentChart.Canvas.AssignFont(Font);
  Height:=ParentChart.Canvas.FontHeight*Text.Count;

  if not Transparent then
  begin
    Height:=Height+2;
    if Pen.Visible then Height:=Height+2*Pen.Width;
  end;
end;

procedure TLegendTitle.CalcShapeBounds(Const R:TRect);
begin
  ShapeBounds:=TeeRect(R.Left+2,R.Top+2,R.Right-2,R.Top+2+Height);

  if (not Transparent) and Shadow.Visible then
  begin
    if Shadow.HorizSize>0 then
       Dec(ShapeBounds.Right,Shadow.HorizSize)
    else
       Dec(ShapeBounds.Left,Shadow.HorizSize);

    if Shadow.VertSize<0 then
       Dec(ShapeBounds.Top,Shadow.VertSize);
  end;
end;

function TLegendTitle.GetCaption: String;
begin
  if Text.Count>0 then result:=Text[0]
                  else result:='';
end;

procedure TLegendTitle.SetCaption(const Value: String);
begin
  Text.Clear;

  if Value<>'' then
     Text.Add(Value);
end;

{ TColorPalettes }

class procedure TColorPalettes.AddTo(const Items:TStrings; AddDefault:Boolean=False);
var t : Integer;
begin
  if AddDefault then
     Items.Add(TeeMsg_Default);

  for t:=0 to ColorPalettes.Count-1 do
      Items.AddObject(ColorPalettes[t],TObject(t));
end;

class procedure TColorPalettes.ApplyPalette(Chart: TCustomAxisPanel;
  Index: Integer);
begin
  case Index of
    1: ApplyPalette(Chart,ExcelPalette);
    2: ApplyPalette(Chart,VictorianPalette);
    3: ApplyPalette(Chart,PastelsPalette);
    4: ApplyPalette(Chart,SolidPalette);
    5: ApplyPalette(Chart,ClassicPalette);
    6: ApplyPalette(Chart,WebPalette);
    7: ApplyPalette(Chart,ModernPalette);
    8: ApplyPalette(Chart,RainbowPalette);
    9: ApplyPalette(Chart,WindowsXPPalette);
   10: ApplyPalette(Chart,MacOSPalette);
   11: ApplyPalette(Chart,WindowsVistaPalette);
   12: ApplyPalette(Chart,GrayScalePalette);
   13: ApplyPalette(Chart,OperaPalette);
   14: ApplyPalette(Chart,WarmPalette);
   15: ApplyPalette(Chart,CoolPalette);
  else
    ApplyPalette(Chart,[]);
  end;

  if Chart is TCustomChart then
     {$IFDEF CLR}TCustomChart{$ELSE}TCustomChartAccess{$ENDIF}(Chart).FColorPaletteIndex:=Index;

  Chart.Invalidate;
end;

type TCustomAxisPanelAccess=class(TCustomAxisPanel);

class procedure TColorPalettes.ApplyPalette(Chart: TCustomAxisPanel;
  const Palette: array of TColor);
var t : Integer;
begin
  if Length(Palette)=0 then
     Chart.ColorPalette:=nil
  else
  begin
    SetLength(Chart.ColorPalette,(High(Palette)-Low(Palette))+1);
    for t:=Low(Palette) to High(Palette) do
        Chart.ColorPalette[t]:=Palette[t];
  end;

  TCustomAxisPanelAccess(Chart).ColorPaletteChanged;
end;

{ TChartTheme }
Constructor TChartTheme.Create(AChart: TCustomChart);
begin
  inherited Create;
  Chart:=AChart;
end;

procedure TChartTheme.ChangeAxis(Axis:TChartAxis);
begin
end;

procedure TChartTheme.Apply; // BCB does not accept "abstract;"
var t : Integer;
begin
  if Assigned(Chart) then
  begin
    for t:=0 to Chart.Axes.Count-1 do
        ChangeAxis(Chart.Axes[t]);

    for t:=0 to Chart.CustomAxes.Count-1 do
        ChangeAxis(Chart.CustomAxes[t]);
  end;
end;

// Not "abstract", due to BCB compatibility
function TChartTheme.Description: String;
begin
  result:=TeeMsg_ThemeDefault;
end;

initialization
  Randomize;
  CheckTeeSeriesTypes;
  CheckTeeToolTypes;

  ColorPalettes:=TColorPalettes.Create;
  ColorPalettes.Add(TeeMsg_ThemeTeeChart);
  ColorPalettes.Add(TeeMsg_ThemeExcel);
  ColorPalettes.Add(TeeMsg_ThemeVictorian);
  ColorPalettes.Add(TeeMsg_ThemePastels);
  ColorPalettes.Add(TeeMsg_ThemeSolid);
  ColorPalettes.Add(TeeMsg_ThemeClassic);
  ColorPalettes.Add(TeeMsg_ThemeWeb);
  ColorPalettes.Add(TeeMsg_ThemeModern);
  ColorPalettes.Add(TeeMsg_ThemeRainbow);
  ColorPalettes.Add(TeeMsg_ThemeWinXP);
  ColorPalettes.Add(TeeMsg_ThemeMacOS);
  ColorPalettes.Add(TeeMsg_ThemeWinVista);
  ColorPalettes.Add(TeeMsg_ThemeGrayScale);
  ColorPalettes.Add(TeeMsg_ThemeOpera);
  ColorPalettes.Add(TeeMsg_ThemeWarm);
  ColorPalettes.Add(TeeMsg_ThemeCool);

finalization
  FreeAndNil(ColorPalettes);
  FreeAndNil(TeeSeriesTypes);
  FreeAndNil(TeeToolTypes);
end.

