{*********************************************}
{  TeeChart Standard Series Types             }
{  Copyright (c) 1995-2007 by David Berneda   }
{  All Rights Reserved                        }
{                                             }
{   TCustomSeries                             }
{     TLineSeries                             }
{      THorizLineSeries                       }
{     TAreaSeries                             }
{      THorizAreaSeries                       }
{     TPointSeries                            }
{   TCustomBarSeries                          }
{     TBarSeries                              }
{     THorizBarSeries                         }
{   TCircledSeries                            }
{     TPieSeries                              }
{   TFastLineSeries                           }
{                                             }
{*********************************************}
unit Series;
{$I TeeDefs.inc}

interface

{$IFDEF D9}
{$INLINE OFF}  // Enable or disable inlining in Delphi 9
{$ENDIF}

uses
  {$IFNDEF LINUX}
  Windows,
  {$ENDIF}
  {$IFDEF CLX}
  QGraphics, QForms, QTypes,
  {$ELSE}
  Graphics, Forms,
  {$ENDIF}
  {$IFDEF D9}
  Types,
  {$ENDIF}
  SysUtils, Classes, TeEngine, Chart, TeCanvas, TeeProcs;

const
  PiDegree : Double = Pi/180.0;
  Tee_CircledShadowColor = TColor($A0A0A0);

type
  TTreatNullsStyle=(tnDontPaint, tnSkip, tnIgnore);

  TCustomLineSeries=class(TChartSeries)
  private
    FTreatNulls : TTreatNullsStyle;
    procedure SetTreatNulls(const Value:TTreatNullsStyle);
  protected
    Function GetLinePen:TChartPen;
  public
    Procedure Assign(Source:TPersistent); override;

    property LinePen:TChartPen read GetLinePen write SetPen;
    property TreatNulls:TTreatNullsStyle read FTreatNulls write SetTreatNulls
                                          default tnDontPaint;
  end;

  TCustomSeries=class;

  TSeriesClickPointerEvent=Procedure( Sender:TCustomSeries;
                                      ValueIndex:Integer;
                                      X, Y: Integer) of object;

  TCustomSeriesStack=(cssNone, cssOverlap, cssStack, cssStack100);

  TOnGetPointerStyle=Function( Sender:TChartSeries;
                               ValueIndex:Integer):TSeriesPointerStyle of object;

  TCustomSeries=class(TCustomLineSeries)
  private
    FAreaBrush          : TChartBrush;
    FAreaColor          : TColor;
    FAreaLinesPen       : TChartPen;
    FClickableLine      : Boolean;
    FColorEachLine      : Boolean;
    FDark3D             : Boolean;
    FDrawArea           : Boolean;
    FDrawLine           : Boolean;
    FInvertedStairs     : Boolean;
    FLineHeight         : Integer;
    FOutLine            : TChartHiddenPen;
    FPointer            : TSeriesPointer;
    FShadow             : TTeeShadow;  // 7.0
    FStacked            : TCustomSeriesStack;
    FStairs             : Boolean;
    FTransparency       : TTeeTransparency;

    { events }
    FOnClickPointer     : TSeriesClickPointerEvent;
    FOnGetPointerStyle  : TOnGetPointerStyle;

    {$IFDEF TEEOCX}
    FFastPoint : Boolean;
    {$ENDIF}

    { internal }
    BottomPos      : Integer;
    OldBottomPos   : Integer;
    OldX           : Integer;
    OldY           : Integer;
    OldColor       : TColor;
    tmpDark3DRatio : Double;

    Function CalcStackedPos(ValueIndex:Integer; Value:Double):Integer;
    Function GetAreaBrush:TBrushStyle;
    Function GetLineBrush:TBrushStyle;
    Procedure InternalCalcMargin(SameSide,Horizontal:Boolean; var A,B:Integer);
    Function PointOrigin(ValueIndex:Integer; SumAll:Boolean):Double;

    Procedure SetAreaBrush(Value:TChartBrush);
    Procedure SetAreaBrushStyle(Value:TBrushStyle);
    Procedure SetAreaColor(Value:TColor);
    Procedure SetAreaLinesPen(Value:TChartPen);
    procedure SetColorEachLine(const Value: Boolean);
    Procedure SetDark3D(Value:Boolean);
    Procedure SetDrawArea(Value:Boolean);
    Procedure SetGradient(Value:TChartGradient);
    Procedure SetInvertedStairs(Value:Boolean);
    Procedure SetLineBrush(Value:TBrushStyle);
    Procedure SetLineHeight(Value:Integer);
    procedure SetOutLine(const Value: TChartHiddenPen);
    Procedure SetPointer(Value:TSeriesPointer);
    Procedure SetShadow(Value:TTeeShadow);
    Procedure SetStacked(Value:TCustomSeriesStack);
    Procedure SetStairs(Value:Boolean);
    {$IFDEF TEEOCX}
    Procedure SetFastPoint(Value:Boolean);
    {$ENDIF}
  protected
    FGradient : TChartGradient;

    Procedure CalcHorizMargins(var LeftMargin,RightMargin:Integer); override;
    Function CalcMarkLength:Integer; virtual;
    function CalcMinMaxValue(IsMin:Boolean):TChartValue;
    Procedure CalcVerticalMargins(var TopMargin,BottomMargin:Integer); override;
    Procedure CalcZOrder; override;

    Function ClickedPointer( ValueIndex,tmpX,tmpY:Integer;
                             x,y:Integer):Boolean; virtual;

    function DoGetPointerStyle(ValueIndex:Integer):TSeriesPointerStyle;

    Procedure DrawAllValues; override; { 5.02 }
    Procedure DrawLegendShape(ValueIndex:Integer; Const Rect:TRect); override;
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
    Procedure DrawPointer(AX,AY:Integer; AColor:TColor; ValueIndex:Integer); dynamic;
    procedure DrawValue(ValueIndex:Integer); override;

    Function GetAreaBrushColor(AColor:TColor):TColor;
    class Function GetEditorClass:String; override;
    Function GetGradient:TChartGradient; virtual;
    Function GetTransparency:TTeeTransparency; virtual;
    procedure SetTransparency(const Value: TTeeTransparency); virtual;

    property Gradient:TChartGradient read GetGradient write SetGradient; { 5.03 }

    procedure LinePrepareCanvas(tmpCanvas:TCanvas3D; tmpColor:TColor);
    procedure PreparePointer(ValueIndex:Integer); virtual;

    function SameClassOrigin(ASeries:TChartSeries):Boolean; virtual;
    Procedure SetParentChart(Const Value:TCustomAxisPanel); override;

    property Stacked:TCustomSeriesStack read FStacked write SetStacked default cssNone;
    property Transparency:TTeeTransparency read GetTransparency write SetTransparency default 0;

  {$IFDEF CLR}
  public
  {$ENDIF}
    function RaiseClicked:Boolean; override; // 7.07

  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Function CalcXPos(ValueIndex:Integer):Integer; override;
    Function CalcYPos(ValueIndex:Integer):Integer; override;
    Function Clicked(x,y:Integer):Integer; override;
    Function GetOriginPos(ValueIndex:Integer):Integer; virtual;
    Function MaxXValue:Double; override;
    Function MinXValue:Double; override;
    Function MaxYValue:Double; override;
    Function MinYValue:Double; override;

    property AreaBrush:TBrushStyle read GetAreaBrush write SetAreaBrushStyle
                                        default bsSolid;
    property AreaChartBrush:TChartBrush read FAreaBrush write SetAreaBrush;
    property AreaColor:TColor read FAreaColor write SetAreaColor default clTeeColor;
    property AreaLinesPen:TChartPen read FAreaLinesPen write SetAreaLinesPen;
    property ClickableLine:Boolean read FClickableLine write FClickableLine default True;
    property ColorEachLine:Boolean read FColorEachLine write SetColorEachLine default True;
    property Dark3D:Boolean read FDark3D write SetDark3D default True;
    property DrawArea:Boolean read FDrawArea write SetDrawArea default False;
    property InvertedStairs:Boolean read FInvertedStairs write SetInvertedStairs default False;
    property LineBrush:TBrushStyle read GetLineBrush write SetLineBrush default bsSolid;
    property LineHeight:Integer read FLineHeight write SetLineHeight default 0;
    property OutLine:TChartHiddenPen read FOutLine write SetOutLine;
    property Pointer:TSeriesPointer read FPointer write SetPointer;
    property Shadow:TTeeShadow read FShadow write SetShadow;
    property Stairs:Boolean read FStairs write SetStairs default False;
    {$IFDEF TEEOCX}
    property FastPoint:Boolean read FFastPoint write SetFastPoint default False;
    {$ENDIF}

    { events }
    property OnClickPointer:TSeriesClickPointerEvent read FOnClickPointer
                                                     write FOnClickPointer;
  published
    { events }
    property OnGetPointerStyle:TOnGetPointerStyle read FOnGetPointerStyle
                                                  write FOnGetPointerStyle;
  end;

  TLineSeries=Class(TCustomSeries)
  protected
    class Procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; var BackColor:TColor;
                                   var BrushStyle:TBrushStyle); override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
  public
    Constructor Create(AOwner: TComponent); override;
    Procedure Assign(Source:TPersistent); override;
  published
    property Active;
    property ColorEachLine;
    property ColorEachPoint;
    property ColorSource;
    property Cursor;
    property Depth;
    property Gradient;
    property HorizAxis;
    property Marks;
    property ParentChart;
    property DataSource;  { after parentchart }
    property PercentFormat;
    property SeriesColor;
    property Shadow; // 7.02
    property ShowInLegend;
    property Stacked;
    property Title;
    property ValueFormat;
    property VertAxis;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    property Brush;
    property ClickableLine;
    property Dark3D;
    property InvertedStairs;
    property LineBrush;
    property LineHeight;
    property LinePen;
    property OutLine;
    property Pointer;
    property Stairs;
    property TreatNulls;
    property XValues;
    property YValues;

    { event }
    property OnClickPointer;
  end;

  THorizLineSeries=class(TLineSeries)
  protected
    Function CalcMarkLength:Integer; override;
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
  public
    Constructor Create(AOwner: TComponent); override;
  end;

  TPointSeries=Class(TCustomSeries)
  private
    Procedure SetFixed;
  protected
    class Function CanDoExtra:Boolean; virtual;
    class Procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    class Function GetEditorClass:String; override;
    Function GetTransparency:TTeeTransparency; override;
    Procedure PrepareForGallery(IsEnabled:Boolean); override;
    Procedure SetColorEachPoint(Value:Boolean); override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
    procedure SetTransparency(const Value: TTeeTransparency); override;
  public
    Constructor Create(AOwner: TComponent); override;
    Procedure Assign(Source:TPersistent); override;
  published
    property Active;
    property ColorEachPoint;
    property ColorSource;
    property Cursor;
    property Depth;
    property HorizAxis;
    property Marks;
    property ParentChart;
    property DataSource;  { after parentchart }
    property PercentFormat;
    property SeriesColor;
    property ShowInLegend;
    property Stacked;
    property Title;
    property ValueFormat;
    property VertAxis;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    // Published inherited properties
    property ClickableLine;
    property Pointer;
    property Transparency;
    property XValues;
    property YValues;

    { events }
    property OnClickPointer;
  end;

  TMultiArea=(maNone,maStacked,maStacked100);

  TAreaSeries=Class(TCustomSeries)
  private
    FOrigin     : Double;
    FStackGroup : Integer;
    FUseOrigin  : Boolean;

    Function GetMultiArea:TMultiArea;
    Procedure SetMultiArea(Value:TMultiArea);
    Procedure SetOrigin(Const Value:Double);
    Procedure SetStackGroup(const Value:Integer);
    Procedure SetUseOrigin(Value:Boolean);
  protected
    Procedure CalcZOrder; override;
    class Procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    Procedure DrawLegendShape(ValueIndex:Integer; Const Rect:TRect); override;
    class Function GetEditorClass:String; override;
    Procedure PrepareForGallery(IsEnabled:Boolean); override;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; var BackColor:TColor;
                                   var BrushStyle:TBrushStyle); override;
    function SameClassOrigin(ASeries:TChartSeries):Boolean; override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
  public
    Constructor Create(AOwner: TComponent); override;

    Procedure Assign(Source:TPersistent); override;
    Function DrawSeriesForward(ValueIndex:Integer):Boolean; override;
    Function GetOriginPos(ValueIndex:Integer):Integer; override;
    Function MaxXValue:Double; override;
    Function MinXValue:Double; override;
    Function MaxYValue:Double; override;
    Function MinYValue:Double; override;
  published
    property Active;
    property ColorEachLine;
    property ColorEachPoint;
    property ColorSource;
    property Cursor;
    property Depth;
    property Gradient;
    property HorizAxis;
    property Marks;
    property ParentChart;
    property DataSource;  // After ParentChart
    property PercentFormat;
    property SeriesColor;
    property ShowInLegend;
    property Title;
    property ValueFormat;
    property VertAxis;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    property AreaBrush;
    property AreaChartBrush;
    property AreaColor;
    property AreaLinesPen;
    property ClickableLine;
    property Dark3D;
    property DrawArea;
    property InvertedStairs;
    property LinePen;
    property MultiArea:TMultiArea read GetMultiArea write SetMultiArea default maNone;
    property Pointer;
    property Stairs;
    property StackGroup:Integer read FStackGroup write SetStackGroup default 0;
    property Transparency;
    property TreatNulls;
    property UseYOrigin:Boolean read FUseOrigin write SetUseOrigin default False;
    property XValues;
    property YOrigin:Double read FOrigin write SetOrigin;
    property YValues;

    { events }
    property OnClickPointer;
  end;

  THorizAreaSeries=class(TAreaSeries)
  protected
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
  public
    Constructor Create(AOwner: TComponent); override;
    Function NumSampleValues:Integer; override;
  end;

  TMultiBar=(mbNone,mbSide,mbStacked,mbStacked100,mbSideAll,mbSelfStack);

  TCustomBarSeries=class;

  TBarStyle=( bsRectangle, bsPyramid, bsInvPyramid,
              bsCilinder, bsEllipse, bsArrow, bsRectGradient, bsCone, bsBevel,
              bsSlantCube, bsDiamond, bsInvArrow, bsInvCone);  // 7.04

  TGetBarStyleEvent=Procedure( Sender:TCustomBarSeries; ValueIndex:Integer;
                               var TheBarStyle:TBarStyle) of object;

  TBarSeriesGradient=class(TCustomTeeGradient)
  private
    FRelative: Boolean;
    procedure SetRelative(const Value: Boolean);
  published
    property Angle;
    property Balance;
    property Direction nodefault;
    property MidColor;
    property RadialX;
    property RadialY;
    property Relative:Boolean read FRelative write SetRelative default False;
    property SubGradient;
    property StartColor;
    property Visible default True;
  end;

  TCustomBarSeries=class(TChartSeries)
  private
    FAutoBarSize     : Boolean;
    FAutoMarkPosition: Boolean;
    FBarStyle        : TBarStyle;
    FBarWidthPercent : Integer;
    FBevelSize       : Integer;
    FConePercent     : Integer;
    FDark3D          : Boolean;
    FDarkPen         : Integer;
    FDepthPercent    : Integer;
    FGradient        : TBarSeriesGradient;
    FMultiBar        : TMultiBar;
    FOffsetPercent   : Integer;
    FShadow          : TTeeShadow;
    FSideMargins     : Boolean;
    FStackGroup      : Integer;
    FTickLines       : TChartHiddenPen;
    FTransparency    : TTeeTransparency;
    FUseOrigin       : Boolean;
    FOrigin          : Double;

    { events }
    FOnGetBarStyle   : TGetBarStyleEvent;

    { internal }
    FBarBounds     : TRect;
    INumBars       : Integer;
    IMaxBarPoints  : Integer;
    IOrderPos      : Integer;
    IPreviousCount : Integer;

    Procedure CalcGradientColor(ValueIndex:Integer);
    Function CreateBlend(Transp:Integer):TTeeBlend;
    Procedure DrawBevel;
    Function GetBarBrush:TChartBrush;
    Function GetBarPen:TChartPen;
    Function GetBarStyle(ValueIndex:Integer):TBarStyle;
    Procedure PrepareBarPen(ValueIndex:Integer);
    Procedure SetAutoBarSize(Value:Boolean);
    Procedure SetAutoMarkPosition(Value:Boolean);
    Procedure SetBarWidthPercent(Value:Integer);
    Procedure SetOffsetPercent(Value:Integer);
    Procedure SetBarStyle(Value:TBarStyle);
    procedure SetBevelSize(const Value: Integer);
    procedure SetConePercent(const Value: Integer);
    Procedure SetDark3D(Value:Boolean);
    Procedure SetDarkPen(Value:Integer);
    Procedure SetDepthPercent(Value:Integer);
    Procedure SetGradient(Value:TBarSeriesGradient);
    Procedure SetMultiBar(Value:TMultiBar);
    Procedure SetOrigin(Const Value:Double);
    Procedure SetOtherBars(SetOthers:Boolean);
    procedure SetShadow(Const Value:TTeeShadow);
    Procedure SetSideMargins(Value:Boolean);
    Procedure SetStackGroup(Value:Integer);
    procedure SetTickLines(const Value: TChartHiddenPen);
    procedure SetTransparency(const Value: TTeeTransparency);
    Procedure SetUseOrigin(Value:Boolean);

    Procedure BarGradient(ValueIndex:Integer; R:TRect);
    Procedure InternalApplyBarMargin(var MarginA,MarginB:Integer);
    Function InternalGetOriginPos(ValueIndex:Integer; DefaultOrigin:Integer):Integer;
    Function MaxMandatoryValue(Const Value:Double):Double;
    Function MinMandatoryValue(Const Value:Double):Double;
  protected
    IBarSize         : Integer; { 5.01 }
    FCustomBarSize   : Integer;

    Procedure AddSampleValues(NumValues:Integer; Sequential:Boolean=False); override; // 6.02
    procedure CalcDepthPositions; override;
    Procedure CalcFirstLastVisibleIndex; override;
    Procedure CalcZOrder; override;
    class procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    Procedure DoBeforeDrawChart; override;
    Procedure DrawLegendShape(ValueIndex:Integer; Const Rect:TRect); override;
    Procedure DrawTickLine(TickPos:Integer; AStyle:TBarStyle); dynamic;
    Procedure DrawTickLines(StartPos,EndPos:Integer; AStyle:TBarStyle);
    procedure DrawValue(ValueIndex:Integer); override;
    class Function GetEditorClass:String; override;
    Function InternalCalcMarkLength(ValueIndex:Integer):Integer; virtual; // abstract;
    Function InternalClicked(ValueIndex:Integer; P:TPoint):Boolean; virtual; // abstract;
    Procedure PrepareForGallery(IsEnabled:Boolean); override;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; var BackColor:TColor;
                                   var BrushStyle:TBrushStyle); override;
    Procedure SetCustomBarSize(Value:Integer); { 5.01 BCB cannot compile if private }
    Procedure SetParentChart(Const Value:TCustomAxisPanel); override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
    class Function SubGalleryStack:Boolean; virtual;
  public
    NormalBarColor : TColor;

    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    Function AddBar(Const AValue:Double; Const ALabel:String; AColor:TColor):Integer;
    Function ApplyBarOffset(Position:Integer):Integer;
    Procedure Assign(Source:TPersistent); override;
    Function BarMargin:Integer; {virtual; 4.02 }
    Procedure BarRectangle(BarColor:TColor; ALeft,ATop,ARight,ABottom:Integer);
    procedure CalcBarBounds(ValueIndex:Integer); virtual; abstract;
    Function CalcMarkLength(ValueIndex:Integer):Integer;
    Function Clicked(x,y:Integer):Integer; override;
    Procedure DrawBar(BarIndex,StartPos,EndPos:Integer); virtual; abstract;
    Function NumSampleValues:Integer; override;
    Function PointOrigin(ValueIndex:Integer; SumAll:Boolean):Double; virtual;
    Procedure SetPenBrushBar(BarColor:TColor; ValueIndex:Integer=-1);

    property BarBounds:TRect read FBarBounds;
    property ConePercent:Integer read FConePercent write SetConePercent
                                default 0;
    property Transparency:TTeeTransparency read FTransparency write SetTransparency default 0;
  published
    property Active;
    property BarBrush:TChartBrush read GetBarBrush write SetBrush;
    property BarPen:TChartPen read GetBarPen write SetPen;
    property BevelSize:Integer read FBevelSize write SetBevelSize default 1;
    property ColorEachPoint;
    property ColorSource;
    property Cursor;
    property DarkPen:Integer read FDarkPen write SetDarkPen default 0;
    property Depth;
    property HorizAxis;
    property Marks;
    property ParentChart;
    property DataSource;
    property PercentFormat;
    property SeriesColor;
    property ShowInLegend;
    property Title;
    property ValueFormat;
    property VertAxis;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    property AutoBarSize:Boolean read FAutoBarSize write SetAutoBarSize default False;
    property AutoMarkPosition:Boolean read FAutoMarkPosition write SetAutoMarkPosition default True;
    property BarStyle:TBarStyle read FBarStyle write SetBarStyle
                                default bsRectangle;
    property BarWidthPercent:Integer read FBarWidthPercent
                                     write SetBarWidthPercent default 70;
    property Dark3D:Boolean read FDark3D write SetDark3D default True;
    property DepthPercent:Integer read FDepthPercent write SetDepthPercent default 100;
    property Gradient:TBarSeriesGradient read FGradient write SetGradient;
    property MultiBar:TMultiBar read FMultiBar write SetMultiBar default mbSide;
    property OffsetPercent:Integer read FOffsetPercent
                                   write SetOffsetPercent default 0;
    property Shadow:TTeeShadow read FShadow write SetShadow;
    property SideMargins:Boolean read FSideMargins write SetSideMargins default True;
    property StackGroup:Integer read FStackGroup write SetStackGroup default 0;
    property TickLines:TChartHiddenPen read FTickLines write SetTickLines;
    property UseYOrigin:Boolean read FUseOrigin write SetUseOrigin default True;
    property YOrigin:Double read FOrigin write SetOrigin;

    { inherited published }
    property XValues;
    property YValues;
    { events }
    property OnGetBarStyle:TGetBarStyleEvent read FOnGetBarStyle write
                                             FOnGetBarStyle;
  end;

  TBarSeries=class(TCustomBarSeries)
  protected
    Procedure CalcHorizMargins(var LeftMargin,RightMargin:Integer); override;
    procedure CalcSelectionPos(ValueIndex:Integer; out X,Y:Integer); override;
    Procedure CalcVerticalMargins(var TopMargin,BottomMargin:Integer); override;
    Procedure DrawTickLine(TickPos:Integer; AStyle:TBarStyle); override;
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
    Function InternalCalcMarkLength(ValueIndex:Integer):Integer; override;
    Function InternalClicked(ValueIndex:Integer; P:TPoint):Boolean; override;
    Function MoreSameZOrder:Boolean; override;
  public
    Constructor Create(AOwner:TComponent); override;

    procedure CalcBarBounds(ValueIndex:Integer); override;
    Function CalcXPos(ValueIndex:Integer):Integer; override;
    Function CalcYPos(ValueIndex:Integer):Integer; override;
    Procedure DrawBar(BarIndex,StartPos,EndPos:Integer); override;
    Function DrawSeriesForward(ValueIndex:Integer):Boolean; override;
    Function GetOriginPos(ValueIndex:Integer):Integer;
    Function MaxXValue:Double; override;
    Function MinXValue:Double; override;
    Function MaxYValue:Double; override;
    Function MinYValue:Double; override;

    property BarWidth:Integer read IBarSize;
  published
    property CustomBarWidth:Integer read FCustomBarSize
                                    write SetCustomBarSize default 0;
  end;

  THorizBarSeries=class(TCustomBarSeries)
  protected
    Procedure CalcHorizMargins(var LeftMargin,RightMargin:Integer); override;
    procedure CalcSelectionPos(ValueIndex:Integer; out X,Y:Integer); override;
    Procedure CalcVerticalMargins(var TopMargin,BottomMargin:Integer); override;
    Procedure DrawTickLine(TickPos:Integer; AStyle:TBarStyle); override;
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
    Function InternalCalcMarkLength(ValueIndex:Integer):Integer; override;
    Function InternalClicked(ValueIndex:Integer; P:TPoint):Boolean; override;
  public
    Constructor Create(AOwner:TComponent); override;

    procedure CalcBarBounds(ValueIndex:Integer); override;
    Function CalcXPos(ValueIndex:Integer):Integer; override;
    Function CalcYPos(ValueIndex:Integer):Integer; override;
    Procedure DrawBar(BarIndex,StartPos,EndPos:Integer); override;
    Function DrawSeriesForward(ValueIndex:Integer):Boolean; override;
    Function GetOriginPos(ValueIndex:Integer):Integer;
    Function MaxXValue:Double; override;
    Function MinXValue:Double; override;
    Function MaxYValue:Double; override;
    Function MinYValue:Double; override;

    property BarHeight:Integer read IBarSize;
  published
    property CustomBarHeight:Integer read FCustomBarSize
                                     write SetCustomBarSize default 0;
  end;

  TCircledShadow=class(TTeeShadow) { 5.02 }
  published
    property Color default Tee_CircledShadowColor;
  end;

  TCircledSeries=class(TChartSeries)
  private
    FCircleBackColor : TColor;
    FCircled         : Boolean;
    FCustomXRadius   : Integer;
    FCustomYRadius   : Integer;
    FRotationAngle   : Integer;
    FShadow          : TCircledShadow;
    FXRadius         : Integer;
    FYRadius         : Integer;

    { internal }
    IBack3D         : TView3DOptions;
    FCircleWidth    : Integer;
    FCircleHeight   : Integer;
    FCircleXCenter  : Integer;
    FCircleYCenter  : Integer;
    FCircleRect     : TRect;

    Procedure SetBackupProperties;
    procedure SetCircleBackColor(Value:TColor);
    Procedure SetCircled(Value:Boolean);
    procedure SetCustomXRadius(Value:Integer);
    procedure SetCustomYRadius(Value:Integer);
    procedure SetOtherCustomRadius(IsXRadius:Boolean; Value:Integer);
    Procedure SetShadow(const Value:TCircledShadow);
  protected
    FCircleGradient : TChartGradient;
    IRotDegree      : Double;

    Procedure AdjustCircleRect;
    Function CalcCircleBackColor:TColor;
    Procedure CalcRadius;
    Procedure CheckOtherSeriesMarks; dynamic; // 6.02, 5.03
    Procedure DoBeforeDrawValues; override;
    Procedure DrawCircleGradient; virtual;
    Function HasBackColor:Boolean;
    Procedure InitCustom3DOptions; dynamic;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; var BackColor:TColor;
                                   var BrushStyle:TBrushStyle); override;
    Procedure SetActive(Value:Boolean); override;
    procedure SetCircleGradient(const Value: TChartGradient);
    Procedure SetParentChart(Const Value:TCustomAxisPanel); override;
    Procedure SetParentProperties(EnableParentProps:Boolean); dynamic;
    Procedure SetRotationAngle(const Value:Integer);

    property CircleGradient:TChartGradient read FCircleGradient write SetCircleGradient;
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    class procedure AdjustScreenRatio(ACanvas:TCanvas3D;
                                      AXRadius,AYRadius:Integer; var R:TRect);
    Procedure AngleToPos( Const Angle,AXRadius,AYRadius:Double;
                          out X,Y:Integer);
    Procedure Assign(Source:TPersistent); override;
    Function AssociatedToAxis(Axis:TChartAxis):Boolean; override;
    Function PointToAngle(x,y:Integer):Double;
    Function PointToRadius(x,y: Integer): Double;  // 7.02
    Procedure Rotate(const Angle:Integer);
    Function UseAxis:Boolean; override;

    { read only properties }
    property CircleBackColor:TColor read FCircleBackColor
                                    write SetCircleBackColor default clTeeColor;
    property CircleHeight:Integer read FCircleHeight;
    property CircleRect:TRect read FCircleRect;
    property CircleWidth:Integer read FCircleWidth;
    property CircleXCenter:Integer read FCircleXCenter;
    property CircleYCenter:Integer read FCircleYCenter;
    property RotationAngle:Integer read FRotationAngle write SetRotationAngle
                                   default 0;
    property XRadius:Integer read FXRadius;
    property YRadius:Integer read FYRadius;
  published
    property ColorSource;
    property Cursor;
    property Marks;
    property ParentChart;
    property DataSource;
    property PercentFormat;
    property SeriesColor;
    property ShowInLegend;
    property Title;
    property ValueFormat;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    property Circled:Boolean read FCircled write SetCircled default False;
    property CustomXRadius:Integer read FCustomXRadius write SetCustomXRadius default 0;
    property CustomYRadius:Integer read FCustomYRadius write SetCustomYRadius default 0;
    property Shadow:TCircledShadow read FShadow write SetShadow;
  end;

  TPieAngle=Packed Record
    StartAngle : Double;
    MidAngle   : Double;
    EndAngle   : Double;
  end;

  TPieAngles=Array of TPieAngle;

  TSliceValueList=class(TList)
  private
    Function Get(Index:Integer):Integer;
    Procedure Put(Index,Value:Integer);
  protected
    OwnerSeries : TChartSeries;
  public
    {$IFNDEF D6}
    procedure Assign(Source:TList);
    {$ENDIF}
    property Value[Index:Integer]:Integer read Get write Put; default;
  end;

  TPieOtherStyle=(poNone, poBelowPercent, poBelowValue);

  TPieOtherSlice=class(TPersistent)
  private
    FColor    : TColor;
    FLegend   : TChartLegend;
    FStyle    : TPieOtherStyle;
    FText     : String;
    FValue    : Double;
    FOwner    : TChartSeries;

    function GetLegend: TChartLegend;
    Function GetText:String;
    Function IsTextStored:Boolean;
    procedure SetColor(Value:TColor);
    procedure SetLegend(const Value: TChartLegend);
    procedure SetStyle(Value:TPieOtherStyle);
    procedure SetText(Const Value:String);
    procedure SetValue(Const Value:Double);
  public
    Constructor Create(AOwner:TChartSeries);
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
  published
    property Color:TColor read FColor write SetColor default clTeeColor;
    property Legend:TChartLegend read GetLegend write SetLegend;
    property Style:TPieOtherStyle read FStyle write SetStyle default poNone;
    property Text:String read GetText write SetText stored IsTextStored;
    property Value:Double read FValue write SetValue;
  end;

  TPieMarks=class(TPersistent)
  private
    FLegSize    : Integer;
    FVertCenter : Boolean;

    IParent : TChartSeries;
    procedure SetLegSize(const Value:Integer);
    procedure SetVertCenter(const Value:Boolean);
  public
    Procedure Assign(Source:TPersistent); override;
  published
    property VertCenter:Boolean read FVertCenter write SetVertCenter default False;
    property LegSize:Integer read FLegSize write SetLegSize default 0;
  end;

  TMultiPie=(mpAutomatic, mpDisabled);

  TPieSeries=class(TCircledSeries)
  private
    FAngleSize        : Integer;
    FAutoMarkPosition : Boolean;
    FDark3D           : Boolean;
    FDarkPen          : Integer;
    FDonutPercent     : Integer;
    FExplodedSlice    : TSliceValueList; { <-- Exploded slice % storage }
    FExplodeBiggest   : Integer;
    FMultiPie         : TMultiPie;  // v7.0
    FOtherSlice       : TPieOtherSlice;
    FPieMarks         : TPieMarks;
    FSliceHeights     : TSliceValueList; { <-- Slice Heights % storage }
    FUsePatterns      : Boolean;

    ISortedSlice      : Array of Integer;
    IOldChartRect     : TRect;

    Procedure CalcExplodeBiggest;
    Function CompareSlice(A,B:Integer):Integer;
    Procedure DisableRotation;
    Function GetPiePen:TChartPen;
    Function GetPieValues:TChartValueList;
    function PieCount:Integer;
    Procedure PreparePiePen(ValueIndex:Integer);
    procedure RemoveOtherSlice;
    Procedure SetAngleSize(Value:Integer);
    Procedure SetAutoMarkPosition(Value:Boolean);
    Procedure SetDark3D(Value:Boolean);
    procedure SetDarkPen(const Value: Integer);
    procedure SetExplodeBiggest(Value:Integer);
    procedure SetMultiPie(const Value:TMultiPie);
    procedure SetOtherSlice(Value:TPieOtherSlice);
    Procedure SetPieMarks(const Value:TPieMarks);
    Procedure SetPieValues(Value:TChartValueList);
    procedure SetUsePatterns(Value:Boolean);
    Function SliceBrushStyle(ValueIndex:Integer):TBrushStyle;
    Function SliceEndZ(ValueIndex:Integer):Integer;
    Procedure SwapSlice(a,b:Integer);
  protected
    FAngles    : TPieAngles;
    IsExploded : Boolean;

    Procedure AddSampleValues(NumValues:Integer; Sequential:Boolean=False); override;
    Procedure CalcAngles;
    Procedure CalcExplodedOffset( ValueIndex:Integer;
                                  out OffsetX,OffsetY:Integer);
    Procedure CalcExplodedRadius(ValueIndex:Integer; out AXRadius,AYRadius:Integer);
    Procedure CalcFirstLastVisibleIndex; override;
    procedure CalcSelectionPos(ValueIndex:Integer; out X,Y:Integer); override;
    Procedure CalcZOrder; override; // 7.0
    procedure CheckAngles;
    Procedure CheckOtherSeriesMarks; override; // 6.02
    Procedure ClearLists; override;
    class Procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    procedure DoAfterDrawValues; override;
    procedure DoBeforeDrawChart; override;
    procedure DoBeforeDrawValues; override;
    procedure DrawAllValues; override;
    Procedure DrawLegendShape(ValueIndex:Integer; Const Rect:TRect); override;
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
    Procedure DrawPie(ValueIndex:Integer); virtual;
    procedure DrawValue(ValueIndex:Integer); override;
    Procedure GalleryChanged3D(Is3D:Boolean); override;
    class Function GetEditorClass:String; override;
    Procedure InitCustom3DOptions; override;
    Function MoreSameZOrder:Boolean; override; // 7.0
    Procedure PrepareForGallery(IsEnabled:Boolean); override;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; var BackColor:TColor;
                                   var BrushStyle:TBrushStyle); override;
    procedure SetDonutPercent(Value:Integer);
    Procedure SetParentChart(Const Value:TCustomAxisPanel); override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
    procedure WriteData(Stream: TStream); override;
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    Function AddPie(Const AValue:Double; Const ALabel:String='';
                    AColor:TColor=clTeeColor):Integer;
    Procedure Assign(Source:TPersistent); override;
    Function BelongsToOtherSlice(ValueIndex:Integer):Boolean;
    Function CalcClickedPie(x,y:Integer; Exploded:Boolean=True):Integer; // 7.07
    Function CalcXPos(ValueIndex:Integer):Integer; override;
    Procedure CheckOrder; override;
    procedure Clear; override;
    Function Clicked(x,y:Integer):Integer; override;
    Function CountLegendItems:Integer; override;
    procedure Delete(ValueIndex:Integer); override;  // 7.0
    Function LegendToValueIndex(LegendIndex:Integer):Integer; override;
    Function MaxXValue:Double; override;
    Function MinXValue:Double; override;
    Function MaxYValue:Double; override;
    Function MinYValue:Double; override;
    Function NumSampleValues:Integer; override;
    procedure SwapValueIndex(a,b:Integer); override;

    property Angles:TPieAngles read FAngles;
    property DonutPercent:Integer read FDonutPercent write SetDonutPercent;
    property ExplodedSlice:TSliceValueList read FExplodedSlice;
    property SliceHeight:TSliceValueList read FSliceHeights;
  published
    property Active;
    property AngleSize:Integer read FAngleSize write SetAngleSize default 360;
    property AutoMarkPosition:Boolean read FAutoMarkPosition write SetAutoMarkPosition default True;
    property CircleBackColor;
    property ColorEachPoint default True;
    property Dark3D:Boolean read FDark3D write SetDark3D default True;
    property DarkPen:Integer read FDarkPen write SetDarkPen default 0;
    property ExplodeBiggest:Integer read FExplodeBiggest write SetExplodeBiggest default 0;
    property Gradient:TChartGradient read FCircleGradient write SetCircleGradient;
    property MultiPie:TMultiPie read FMultiPie write SetMultiPie default mpAutomatic;
    property OtherSlice:TPieOtherSlice read FOtherSlice write SetOtherSlice;
    property PieMarks:TPieMarks read FPieMarks write SetPieMarks;
    property PiePen:TChartPen read GetPiePen write SetPen;
    property PieValues:TChartValueList read GetPieValues write SetPieValues;
    property RotationAngle;
    property UsePatterns:Boolean read FUsePatterns write SetUsePatterns default False;
  end;

  TFastLineSeries=class(TCustomLineSeries)
  private
    FAutoRepaint    : Boolean;
    FDrawAll        : Boolean;

    {$IFDEF TEEOCX}
    FExpandAxis     : Integer; // 7.01
    {$ENDIF}

    FFastPen        : Boolean;
    FIgnoreNulls    : Boolean; // 6.0
    FInvertedStairs : Boolean; // 6.0
    FStairs         : Boolean; // 6.0

    {$IFNDEF CLX}
    DCPEN        : HGDIOBJ;
    {$ENDIF}

    { internal }
    OldX         : Integer;
    OldY         : Integer;

    procedure DoMove(X,Y:Integer);
    Procedure SetDrawAll(Const Value:Boolean);
    procedure SetFastPen(const Value: Boolean);
    procedure SetIgnoreNulls(const Value: Boolean);
    procedure SetInvertedStairs(const Value: Boolean);
    procedure SetStairs(const Value: Boolean);
  protected
    Procedure CalcHorizMargins(var LeftMargin,RightMargin:Integer); override;
    Procedure CalcPosition(ValueIndex:Integer; out x,y:Integer);
    Procedure CalcVerticalMargins(var TopMargin,BottomMargin:Integer); override;
    class Procedure CreateSubGallery(AddSubChart:TChartSubGalleryProc); override;
    procedure DrawAllValues; override;
    Procedure DrawLegendShape(ValueIndex:Integer; Const Rect:TRect); override;
    Procedure DrawMark( ValueIndex:Integer; Const St:String;
                        APosition:TSeriesMarkPosition); override;
    procedure DrawValue(ValueIndex:Integer); override;
    class Function GetEditorClass:String; override;
    Procedure NotifyNewValue(Sender:TChartSeries; ValueIndex:Integer); override;  // 7.0 moved from public
    procedure PrepareCanvas;
    Procedure PrepareLegendCanvas( ValueIndex:Integer; var BackColor:TColor;
                                   var BrushStyle:TBrushStyle); override;
    Procedure SetPen(Const Value:TChartPen); override;
    Procedure SetSeriesColor(AColor:TColor); override;
    class Procedure SetSubGallery(ASeries:TChartSeries; Index:Integer); override;
  public
    Constructor Create(AOwner: TComponent); override;

    Procedure Assign(Source:TPersistent); override;
    Function Clicked(x,y:Integer):Integer; override;
    property FastPen:Boolean read FFastPen write SetFastPen default False;
  published
    property Active;
    property Cursor;
    property Depth;
    property HorizAxis;
    property Marks;
    property ParentChart;
    property DataSource;
    property PercentFormat;
    property SeriesColor;
    property ShowInLegend;
    property Title;
    property ValueFormat;
    property VertAxis;
    property XLabelsSource;

    { events }
    property AfterDrawValues;
    property BeforeDrawValues;
    property OnAfterAdd;
    property OnBeforeAdd;
    property OnClearValues;
    property OnClick;
    property OnDblClick;
    property OnGetMarkText;
    property OnMouseEnter;
    property OnMouseLeave;

    property AutoRepaint:Boolean read FAutoRepaint write FAutoRepaint default True;

    {$IFDEF TEEOCX}
    property ExpandAxis:Integer read FExpandAxis write FExpandAxis default 25;
    {$ENDIF}

    property DrawAllPoints:Boolean read FDrawAll write SetDrawAll default True;

    // obsolete and redundant, please use TreatNulls property:
    property IgnoreNulls:Boolean read FIgnoreNulls write SetIgnoreNulls default True;

    property InvertedStairs:Boolean read FInvertedStairs write SetInvertedStairs default False;
    property LinePen;
    property Stairs:Boolean read FStairs write SetStairs default False;
    property TreatNulls default tnIgnore;
    property XValues;
    property YValues;
  end;

Const
  bsCylinder=bsCilinder;  { <-- better spelling... }

// Calls RegisterTeeSeries for each "standard" series type:
// Line, Bar, Pie, FastLine, HorizBar, Area, Point and HorizLine
Procedure RegisterTeeStandardSeries;

Procedure TeePointerDrawLegend(Pointer:TSeriesPointer; AColor:TColor;
                               Const Rect:TRect; DrawPen:Boolean;
                               AStyle:TSeriesPointerStyle);


implementation

Uses Math, TeeConst;

Function GetDefaultPattern(const PatternIndex:Integer):TBrushStyle;
Const MaxDefaultPatterns = 6;
      PatternPalette     : Array[1..MaxDefaultPatterns] of TBrushStyle=
	( bsHorizontal,
	  bsVertical,
	  bsFDiagonal,
	  bsBDiagonal,
	  bsCross,
	  bsDiagCross
	);
Begin
  result:=PatternPalette[1+(PatternIndex mod MaxDefaultPatterns)];
End;

Procedure TeePointerDrawLegend(Pointer:TSeriesPointer; AColor:TColor;
                               Const Rect:TRect; DrawPen:Boolean;
                               AStyle:TSeriesPointerStyle);
var tmpHoriz : Integer;
    tmpVert  : Integer;
begin
  if Assigned(Pointer.ParentChart) then
  begin
    Pointer.PrepareCanvas(Pointer.ParentChart.Canvas,AColor);

    with TCustomChart(Pointer.ParentChart) do
    if not Legend.Symbol.DefaultPen then
    begin
      Canvas.AssignVisiblePen(Legend.Symbol.Pen); { use custom legend pen }
      DrawPen:=Legend.Symbol.Pen.Visible;
    end;

    With Rect do
    begin
      if DrawPen then
      begin
        tmpHoriz:=(Right-Left) div 3;
        tmpVert :=(Bottom-Top) div 3;
      end
      else
      begin
        tmpHoriz:=1+((Right-Left) div 2);
        tmpVert :=1+((Bottom-Top) div 2);
      end;

      Pointer.DrawPointer(Pointer.ParentChart.Canvas,
                          False, (Left+Right) div 2,(Top+Bottom) div 2,
                          Math.Min(Pointer.HorizSize,tmpHoriz),
                          Math.Min(Pointer.VertSize,tmpVert),AColor,AStyle);
    end;
  end;
end;

{ TCustomLineSeries }
Procedure TCustomLineSeries.Assign(Source:TPersistent);
begin
  if Source is TCustomLineSeries then
     FTreatNulls:=TCustomLineSeries(Source).FTreatNulls;

  inherited;
end;

Function TCustomLineSeries.GetLinePen:TChartPen;
Begin
  result:=Pen;
end;

procedure TCustomLineSeries.SetTreatNulls(const Value:TTreatNullsStyle);
begin
  if FTreatNulls<>Value then
  begin
    FTreatNulls:=Value;
    Repaint;
  end;
end;

{ TCustomSeries }
Constructor TCustomSeries.Create(AOwner: TComponent);
Begin
  inherited;
  FClickableLine:=True;
  FColorEachLine:=True;
  DrawBetweenPoints:=True;
  FPointer:=TSeriesPointer.Create(Self);

  FAreaLinesPen:=CreateChartPen;
  FOutLine:=TChartHiddenPen.Create(CanvasChanged);
  FShadow:=TTeeShadow.Create(CanvasChanged);
  FAreaBrush:=TChartBrush.Create(CanvasChanged);
  FAreaColor:=clTeeColor;
  FDark3D:=True;
  FGradient:=TChartGradient.Create(CanvasChanged);
end;

Destructor TCustomSeries.Destroy;
Begin
  FGradient.Free;
  FAreaBrush.Free;
  FAreaLinesPen.Free;
  FShadow.Free;
  FOutLine.Free;
  FreeAndNil(FPointer);
  inherited;
end;

Procedure TCustomSeries.DrawMark( ValueIndex:Integer; Const St:String;
                                  APosition:TSeriesMarkPosition);
begin
  Marks.ZPosition:=StartZ;
  if YMandatory then Marks.ApplyArrowLength(APosition);
  inherited;
end;

function TCustomSeries.DoGetPointerStyle(ValueIndex:Integer):TSeriesPointerStyle;
begin
  if Assigned(FOnGetPointerStyle) then
     result:=FOnGetPointerStyle(Self,ValueIndex)
  else
     result:=Pointer.Style;
end;

Function TCustomSeries.ClickedPointer( ValueIndex,tmpX,tmpY:Integer;
                                       x,y:Integer):Boolean;
begin
  PreparePointer(ValueIndex); // 7.0

  result:=(DoGetPointerStyle(ValueIndex)<>psNothing) and
          (Abs(tmpX-X)<FPointer.HorizSize) and
          (Abs(tmpY-Y)<FPointer.VertSize);
end;

Procedure TCustomSeries.Assign(Source:TPersistent);
begin
  if Source is TCustomSeries then
  With TCustomSeries(Source) do
  begin
    Self.ClickableLine   :=ClickableLine;
    Self.AreaChartBrush  :=FAreaBrush;
    Self.FAreaColor      :=FAreaColor;
    Self.AreaLinesPen    :=AreaLinesPen;
    Self.FColorEachLine  :=ColorEachLine;
    Self.FDark3D         :=FDark3D;
    Self.FDrawArea       :=FDrawArea;
    Self.FDrawLine       :=FDrawLine;
    Self.FInvertedStairs :=FInvertedStairs;
    Self.FLineHeight     :=FLineHeight;
    Self.Pointer         :=FPointer;
    Self.FStacked        :=FStacked;
    Self.FStairs         :=FStairs;
    Self.OutLine         :=OutLine;
    Self.Shadow          :=Shadow;
    Self.FTransparency   :=FTransparency;
    Self.Gradient        :=FGradient;
  end;

  inherited;
end;

Function TCustomSeries.Clicked(x,y:Integer):Integer;
var OldXPos  : Integer;
    OldYPos  : Integer;
    tmpX     : Integer;
    tmpY     : Integer;
    P        : TPoint;

    Function CheckPointInLine:Boolean;

      Function PointInVertLine(x0,y0,y1:Integer):Boolean;
      begin
        result:=PointInLine(P,x0,y0,x0,y1);
      end;

      Function PointInHorizLine(x0,y0,x1:Integer):Boolean;
      begin
        result:=PointInLine(P,x0,y0,x1,y0);
      end;

    begin
      With ParentChart do
      if View3D then
         result:=PointInPolygon( P,[ TeePoint(tmpX,tmpY),
                                     TeePoint(tmpX+SeriesWidth3D,tmpY-SeriesHeight3D),
                                     TeePoint(OldXPos+SeriesWidth3D,OldYPos-SeriesHeight3D),
                                     TeePoint(OldXPos,OldYPos) ])
      else
         if FStairs then
         begin
            if FInvertedStairs then result:= PointInVertLine(OldXPos,OldYPos,tmpY) or
                                             PointInHorizLine(OldXPos,tmpY,tmpX)
                               else result:= PointInHorizLine(OldXPos,OldYPos,tmpX) or
                                             PointInVertLine(tmpX,OldYPos,tmpY);
         end
         else
            result:=PointInLine(P,tmpX,tmpY,OldXPos,OldYPos)
    end;

    function PointInArea(Index:Integer):Boolean; // TV52011421
    var tmp : TFourPoints;
    begin
      if YMandatory then
      begin
        tmp[0].X:=OldXPos;
        tmp[1].X:=tmpX;
        tmp[2]:=TeePoint(tmpX,GetOriginPos(Index));
        tmp[3]:=TeePoint(OldXPos,GetOriginPos(Index-1));

        if FStairs then
           if FInvertedStairs then
           begin
             tmp[0].Y:=tmpY;
             tmp[1].Y:=tmpY;
           end
           else
           begin
             tmp[0].Y:=OldYPos;
             tmp[1].Y:=OldYPos;
           end
        else
        begin
          tmp[0].Y:=OldYPos;
          tmp[1].Y:=tmpY;
        end;
      end
      else
      begin
        tmp[0].Y:=OldYPos;
        tmp[1].Y:=tmpY;
        tmp[2]:=TeePoint(GetOriginPos(Index),tmpY);
        tmp[3]:=TeePoint(GetOriginPos(Index-1),OldYPos);

        if FStairs then
           if FInvertedStairs then
           begin
             tmp[0].X:=tmpX;
             tmp[1].X:=tmpX;
           end
           else
           begin
             tmp[0].X:=OldXPos;
             tmp[1].X:=OldXPos;
           end
        else
        begin
          tmp[0].X:=OldXPos;
          tmp[1].X:=tmpX;
        end;
      end;

      result:=PointInPolygon(P,tmp);
    end;

var t        : Integer;
    tmpFirst : Integer;
begin
  if Assigned(ParentChart) then
     ParentChart.Canvas.Calculate2DPosition(X,Y,StartZ);

  result:=inherited Clicked(x,y);

  if (result=TeeNoPointClicked) and
     (FirstValueIndex>-1) and (LastValueIndex>-1) then
  begin
    OldXPos:=0;
    OldYPos:=0;
    OldBottomPos:=0;
    P.X:=X;
    P.Y:=Y;

    // Consider hidden previous segment (including non-visible leftmost part)
    // TV52010286  7.05
    if ClickableLine then
       tmpFirst:=Max(0,Pred(FirstValueIndex))
    else
       tmpFirst:=FirstValueIndex;

    for t:=tmpFirst to LastValueIndex do
    begin
      if t>=Count then exit;  // prevent re-entrancy if series is cleared.

      tmpX:=CalcXPos(t);
      tmpY:=CalcYPos(t);

      if FPointer.Visible and ClickedPointer(t,tmpX,tmpY,x,y) then
      begin
        if Assigned(FOnClickPointer) then
           FOnClickPointer(Self,t,x,y);

        result:=t;
        break;
      end;

      if (tmpX=X) and (tmpY=Y) then
      begin
        result:=t;
        break;
      end;

      if (t>tmpFirst) and ClickableLine then
         if CheckPointInLine or (FDrawArea and PointInArea(t)) then
         begin
           result:=t-1;
           break;
         end;

      OldXPos:=tmpX;
      OldYPos:=tmpY;
      OldBottomPos:=BottomPos;
    end;
  end;
end;

Procedure TCustomSeries.SetDrawArea(Value:Boolean);
Begin
  SetBooleanProperty(FDrawArea,Value);
end;

Procedure TCustomSeries.SetPointer(Value:TSeriesPointer);
Begin
  FPointer.Assign(Value);
end;

Procedure TCustomSeries.SetShadow(Value:TTeeShadow);
begin
  FShadow.Assign(Value);
end;

Procedure TCustomSeries.SetAreaLinesPen(Value:TChartPen);
Begin
  FAreaLinesPen.Assign(Value);
end;

Procedure TCustomSeries.SetLineHeight(Value:Integer);
Begin
  SetIntegerProperty(FLineHeight,Value);
end;

Procedure TCustomSeries.SetStairs(Value:Boolean);
Begin
  SetBooleanProperty(FStairs,Value);
end;

{$IFDEF TEEOCX}
Procedure TCustomSeries.SetFastPoint(Value:Boolean);
Begin
  SetBooleanProperty(FFastPoint,Value);
end;
{$ENDIF}

Procedure TCustomSeries.SetInvertedStairs(Value:Boolean);
Begin
  SetBooleanProperty(FInvertedStairs,Value);
end;

Procedure TCustomSeries.SetAreaColor(Value:TColor);
Begin
  SetColorProperty(FAreaColor,Value);
end;

Procedure TCustomSeries.SetAreaBrushStyle(Value:TBrushStyle);
Begin
  FAreaBrush.Style:=Value;
end;

Function TCustomSeries.GetLineBrush:TBrushStyle;
Begin
  result:=Brush.Style;
end;

Procedure TCustomSeries.SetLineBrush(Value:TBrushStyle);
Begin
  Brush.Style:=Value;
end;

Procedure TCustomSeries.DrawLegendShape(ValueIndex:Integer; Const Rect:TRect);
var tmpColor : TColor;

  Procedure DrawLine(DrawRectangle:Boolean);
  begin
    if TCustomChart(ParentChart).Legend.Symbol.DefaultPen then
       LinePrepareCanvas(ParentChart.Canvas,tmpColor);

    With ParentChart.Canvas do
    if DrawRectangle then
       Rectangle(Rect)
    else
    With Rect do
       DoHorizLine(Left,Right,(Top+Bottom) div 2);
  end;

var tmp : TSeriesPointerStyle;
begin
  if ValueIndex=TeeAllValues then tmpColor:=SeriesColor
                             else tmpColor:=LegendItemColor(ValueIndex);

  if FPointer.Visible then
  begin
    if FDrawLine then DrawLine(False);

    if Assigned(FOnGetPointerStyle) and (ValueIndex<>TeeAllValues) then
    begin
      tmp:=FOnGetPointerStyle(Self,ValueIndex);
      {$IFNDEF TEEOCX}
      tmpColor:=Pointer.Color;
      {$ENDIF}
    end
    else
       tmp:=Pointer.Style;

    TeePointerDrawLegend(Pointer,tmpColor,Rect,LinePen.Visible,tmp);
  end
  else
  if FDrawLine and (not FDrawArea) then
     DrawLine(ParentChart.View3D)
  else
     inherited
end;

procedure TCustomSeries.LinePrepareCanvas(tmpCanvas:TCanvas3D; tmpColor:TColor);
begin
  with tmpCanvas do
  begin
    if MonoChrome then tmpColor:=clWhite;

    if ParentChart.View3D then
    begin
      if Assigned(Self.Brush.Image.Graphic) then
         Brush.Bitmap:=Self.Brush.Image.Bitmap
      else
      begin
        Brush.Style:=LineBrush;
        Brush.Color:=tmpColor;
      end;

      AssignVisiblePen(LinePen);
    end
    else
    begin
      Brush.Style:=bsClear;
      AssignVisiblePenColor(LinePen,tmpColor);
    end;
  end;
end;

procedure TCustomSeries.PreparePointer(ValueIndex:Integer);
begin  // empty. Overriden at BubbleSeries
end;

function TCustomSeries.RaiseClicked:Boolean; // 7.07
begin
  result:=(inherited RaiseClicked) or
          (Pointer.Visible and Assigned(FOnClickPointer));
end;

Procedure TCustomSeries.SetParentChart(Const Value:TCustomAxisPanel);
begin
  inherited;
  if Assigned(FPointer) then FPointer.ParentChart:=Value;
end;

Function TCustomSeries.GetAreaBrushColor(AColor:TColor):TColor;
begin
  if ColorEachPoint or (FAreaColor=clTeeColor) then
     result:=AColor
  else
     result:=FAreaColor;
end;

type TCustomAxisPanelAccess=class(TCustomAxisPanel);

procedure TCustomSeries.DrawValue(ValueIndex:Integer);
var x : Integer;
    y : Integer;

  { calculate vertical pixel }
  Function CalcYPosLeftRight(Const YLimit:Double; AnotherIndex:Integer):Integer;
  var tmpPredValueX : Double;
      tmpPredValueY : Double;
      tmpDif        : Double;
      tmpY          : Double;
  begin
    tmpPredValueX:=XValues.Value[AnotherIndex];
    tmpDif:=XValues.Value[ValueIndex]-tmpPredValueX;

    With ParentChart do
    if tmpDif=0 then result:=CalcYPos(AnotherIndex)
    else
    begin
      tmpPredValueY:=YValues.Value[AnotherIndex];

      if MandatoryAxis.Logarithmic then // 7.0 #1225
          if (tmpPredValueY>0) and (YValues.Value[ValueIndex]>0) then
             tmpY:=Exp(Ln(tmpPredValueY)+(YLimit-tmpPredValueX)*
                      (Ln(YValues.Value[ValueIndex])-Ln(tmpPredValueY))/tmpDif)
          else
             tmpY:=0 // TV52010688
      else
          tmpY:=1.0*tmpPredValueY+(YLimit-tmpPredValueX)*
                (YValues.Value[ValueIndex]-tmpPredValueY)/tmpDif;

      result:=CalcYPosValue(tmpY);
    end;
  end;


var tmpColor    : TColor;
    IsLastValue : Boolean;

   Procedure InternalDrawArea(BrushColor:TColor);

     Function RectFromPoints(const P:TFourPoints):TRect;
     begin
       with result do
       begin
         Left  :=Math.Min(P[3].X,Math.Min(P[2].X,Math.Min(P[0].X,P[1].X)));
         Top   :=Math.Min(P[3].Y,Math.Min(P[2].Y,Math.Min(P[0].Y,P[1].Y)));
         Right :=Math.Max(P[3].X,Math.Max(P[2].X,Math.Max(P[0].X,P[1].X)));
         Bottom:=Math.Max(P[3].Y,Math.Max(P[2].Y,Math.Max(P[0].Y,P[1].Y)));
       end;

       if ParentChart.View3D then
          result:=ParentChart.Canvas.CalcRect3D(result,StartZ); { 5.03 }
     end;

   var tmpY      : Integer;
       tmpBottom : Integer;
       tmpR      : TRect;
       tmpBlend  : TTeeBlend;
       tmpP      : TFourPoints;
       tmpMax    : Integer;
       tmpMin    : Integer;
       tmpColor2 : TColor;
       tmpZ      : Integer;
   begin
     tmpColor2:=FAreaBrush.Color;
     if tmpColor2=clTeeColor then
        tmpColor2:=SeriesColor;

     if Assigned(FAreaBrush.Image.Graphic) and (tmpColor2=BrushColor) then
        tmpColor2:=clWhite;  // 7.04 TV52010270

     ParentChart.SetBrushCanvas(BrushColor,FAreaBrush,tmpColor2);

     with ParentChart do
     begin
       // Draw side at last Area edge, or inside middle Null area points.
       if ParentChart.View3D and
            ( IsLastValue
              or
              ((ValueIndex<Count-1) and IsNull(Succ(ValueIndex))
                and (FTreatNulls=tnDontPaint))
              or
              ((ValueIndex>0) and IsNull(Pred(ValueIndex))
                and (FTreatNulls=tnDontPaint))
              )
                    then
       begin
         if Dark3D then
            Canvas.Brush.Color:=ApplyDark(Canvas.Brush.Color,DarkColorQuantity);

         if YMandatory then
            Canvas.RectangleZ(X,Y,BottomPos,StartZ,EndZ)
         else
            Canvas.RectangleY(X,Y,BottomPos,StartZ,EndZ);

         if Dark3D then
            SetBrushCanvas(BrushColor,FAreaBrush,tmpColor2);
       end;

       if FStairs then
       begin
         if FInvertedStairs then
         begin
           if YMandatory then tmpY:=Y
                         else tmpY:=X;

           tmpBottom:=BottomPos;
         end
         else
         begin
           if YMandatory then tmpY:=OldY
                         else tmpY:=OldX;

           tmpBottom:=OldBottomPos;
         end;

         if YMandatory then tmpR:=TeeRect(OldX,tmpBottom,X+1,tmpY)
                       else tmpR:=TeeRect(tmpBottom,OldY+1,tmpY+1,Y);

         with Canvas do
         begin
           if Transparency>0 then
              if View3D then
                 tmpBlend:=BeginBlending(RectFromRectZ(tmpR,StartZ),Transparency)  // 6.01
              else
                 tmpBlend:=BeginBlending(tmpR,Transparency)  // 6.01
           else
              tmpBlend:=nil;

           if View3D then
           begin
             RectangleWithZ(tmpR,StartZ);

             if SupportsFullRotation then
                RectangleWithZ(tmpR,EndZ);
           end
           else
           begin
             if FGradient.Visible then
             begin
               FGradient.Draw(Canvas,tmpR);  // 5.03

               if Pen.Style<>psClear then
               begin
                 Brush.Style:=bsClear;
                 Rectangle(tmpR);
               end;
             end
             else Rectangle(tmpR);
           end;

           if Transparency>0 then
              EndBlending(tmpBlend);
         end;

         if LinePen.Visible then // TV52011701
         begin
           Canvas.AssignVisiblePen(LinePen);

           if YMandatory then
              if FInvertedStairs then
              begin
                Canvas.LineWithZ(OldX,Y,X,Y,StartZ);

                if ValueIndex>FirstValueIndex+1 then
                   Canvas.LineWithZ(OldX,OldY,OldX,Y,StartZ);
              end
              else
              begin
                Canvas.LineWithZ(OldX,OldY,X,OldY,StartZ);

                if ValueIndex<LastValueIndex then
                   Canvas.LineWithZ(X,OldY,X,Y,StartZ);

                if (ValueIndex>(FirstDisplayedIndex+1)) then
                   Canvas.LineWithZ(OldX,OldY,OldX,CalcYPos(ValueIndex-2),StartZ);
              end
           else
              if FInvertedStairs then
              begin
                Canvas.LineWithZ(X,OldY,X,Y,StartZ);

                if ValueIndex>FirstValueIndex+1 then
                   Canvas.LineWithZ(OldX,OldY,X,OldY,StartZ);
              end
              else
              begin
                Canvas.LineWithZ(OldX,OldY,OldX,Y,StartZ);

                if ValueIndex<LastValueIndex then
                   Canvas.LineWithZ(OldX,Y,X,Y,StartZ);

                if (ValueIndex>(FirstDisplayedIndex+1)) then
                   Canvas.LineWithZ(OldX,OldY,CalcXPos(ValueIndex-2),OldY,StartZ);
              end;
         end;

       end
       else // not in "stairs" mode...
       With Canvas do
       begin

         if YMandatory then
         begin
           tmpP[0]:=TeePoint(OldX,OldBottomPos);
           tmpP[3]:=TeePoint(X,BottomPos);
         end
         else
         begin
           tmpP[0]:=TeePoint(OldBottomPos,OldY);
           tmpP[3]:=TeePoint(BottomPos,Y);
         end;

         tmpP[1]:=TeePoint(OldX,OldY);
         tmpP[2]:=TeePoint(X,Y);

         if Transparency>0 then
            tmpBlend:=Canvas.BeginBlending(RectFromPoints(tmpP),Transparency)
         else
            tmpBlend:=nil;

         if View3D then
         begin
           if (View3DOptions.Rotation>90) and (View3DOptions.Rotation<270) then
              tmpZ:=EndZ
           else
              tmpZ:=StartZ;

           if FGradient.Visible then
              FGradient.Draw(Canvas,tmpP,tmpZ)
           else
              PlaneWithZ(tmpP,tmpZ);
         end
         else // 5.02
         begin
           if FGradient.Visible then { 5.03 }
           begin
             ClipPolygon(tmpP,4);

             tmpMax:=CalcPosValue(MandatoryValueList.MaxValue);

             //tmpMin:=CalcPosValue(MandatoryValueList.MinValue);

             tmpMin:=BottomPos;

             if YMandatory then tmpR:=TeeRect(OldX,tmpMax,X,tmpMin)
                           else tmpR:=TeeRect(tmpMin,OldY,tmpMax,Y);

             FGradient.Draw(Canvas,tmpR);
             UnClipRectangle;

             Brush.Style:=bsClear;

             if Pen.Style<>psClear then
                if YMandatory then DoVertLine(OldX,OldY,OldBottomPos)
                              else DoHorizLine(OldBottomPos,OldX,OldY);

           end
           else Polygon(tmpP);
         end;

         if Transparency>0 then
            Canvas.EndBlending(tmpBlend);

         if SupportsFullRotation then PlaneWithZ(tmpP,EndZ);

         if LinePen.Visible then
         begin
           AssignVisiblePen(LinePen);
           LineWithZ(OldX,OldY,X,Y,StartZ);
         end;
       end;
     end;
   end;

   Procedure DrawPoint(DrawOldPointer:Boolean);
   var
     tmpPoint : TPoint;
     tmpOldP  : TPoint;

     procedure DrawLineHeight;
     var P4 : TFourPoints;
     begin
       if not FDrawArea then
       begin
         P4[0]:=tmpPoint;
         P4[1]:=tmpOldP;

         P4[2].X:=tmpOldP.X;
         P4[2].Y:=tmpOldP.Y+LineHeight;

         P4[3].X:=tmpPoint.X;
         P4[3].Y:=tmpPoint.Y+LineHeight;

         ParentChart.Canvas.PlaneFour3D(P4,StartZ,StartZ);

         if IsLastValue then
            ParentChart.Canvas.RectangleZ(tmpPoint.X,tmpPoint.Y,
                                       tmpPoint.Y+FLineHeight,StartZ,EndZ);
       end;
     end;

   var tmpDifX      : Integer;
       OldDarkColor : TColor;
       tmpDark3D    : Boolean;
       tmpP         : TFourPoints;
   begin
     if ((x<>OldX) or (y<>OldY)) and
        ((FTreatNulls=tnIgnore) or (tmpColor<>clNone)) then
     with ParentChart,Canvas do
     begin
       if View3D then
       Begin
         { 3D }
         if FDrawArea or FDrawLine then
         begin

           if FColorEachLine or FDrawArea then
              OldDarkColor:=GetAreaBrushColor(tmpColor)
           else
              OldDarkColor:=SeriesColor;

           if Assigned(Self.Brush.Image.Graphic) then
              SetBrushCanvas(OldDarkColor,Self.Brush,clWhite) // 8.0 TV52011447
           else
           begin
             if Brush.Color<>OldDarkColor then
                Brush.Color:=OldDarkColor;

             if Brush.Style<>LineBrush then
                Brush.Style:=LineBrush;
           end;

           //CDI TV52012170
         // DB: This fix breaks LinePen.Color
//           if LinePen.Color<>OldDarkColor then
//              LinePen.Color:=OldDarkColor;

           AssignVisiblePen(LinePen);

           tmpPoint.X:=X;
           tmpPoint.Y:=Y;
           tmpOldP.X :=OldX;
           tmpOldP.Y :=OldY;

           if FStairs then
           Begin
             if FInvertedStairs then
             begin
               if FDark3D then
                  Brush.Color:=ApplyDark(Brush.Color,DarkColorQuantity);

               if YMandatory then
                  RectangleZ( tmpOldP.X,tmpOldP.Y, Y,StartZ,EndZ)
               else
                  RectangleY( tmpPoint.X, tmpPoint.Y,OldX,StartZ,EndZ);

               if FDark3D then Brush.Color:=OldDarkColor;

               if YMandatory then
                  RectangleY( tmpPoint.X, tmpPoint.Y,OldX,StartZ,EndZ)
               else
                  RectangleZ( X, tmpOldP.Y, Y, StartZ, EndZ);
             end
             else
             begin
               if YMandatory then
                  RectangleY( tmpOldP.X, tmpOldP.Y, X, StartZ, EndZ)
               else
                  RectangleZ( OldX, tmpOldP.Y, Y, StartZ, EndZ);

               if FDark3D then Brush.Color:=ApplyDark(Brush.Color,DarkColorQuantity);

               if YMandatory then
                  RectangleZ( tmpPoint.X,tmpPoint.Y, OldY,StartZ,EndZ)
               else
                  RectangleY( OldX, tmpPoint.Y, X,StartZ,EndZ);

               if FDark3D then
                  Brush.Color:=OldDarkColor;
             end;
           end
           else
           begin
             if LineHeight<>0 then
                DrawLineHeight;

             tmpDark3D:=FDark3D and (not SupportsFullRotation);

             if tmpDark3D then
             begin
               tmpDifX:=tmpPoint.X-tmpOldP.X;

               if (tmpDifX<>0) and
                  (tmpDark3DRatio<>0) and
                  ((tmpOldP.Y-tmpPoint.Y)/tmpDifX > tmpDark3DRatio) then
                      Brush.Color:=ApplyDark(Brush.Color,DarkColorQuantity);
             end;

             if Monochrome then
                Brush.Color:=clWhite;

             if FGradient.Visible then
             begin
               tmpP[0]:=Canvas.Calculate3DPosition(tmpPoint,StartZ);
               tmpP[1]:=Canvas.Calculate3DPosition(tmpOldP,StartZ);
               tmpP[2]:=Canvas.Calculate3DPosition(tmpOldP,EndZ);
               tmpP[3]:=Canvas.Calculate3DPosition(tmpPoint,EndZ);

               Canvas.ClipPolygon(tmpP,4);
               FGradient.StartColor:=Brush.Color;
               FGradient.Draw(Canvas,PolygonBounds(tmpP));
               Canvas.UnClipRectangle;

               if Pen.Style<>psClear then
               begin
                 Brush.Style:=bsClear;
                 Plane3D(tmpPoint,tmpOldP,StartZ,EndZ);
               end;
             end
             else
                Plane3D(tmpPoint,tmpOldP,StartZ,EndZ);

             if tmpDark3D then
                Brush.Color:=OldDarkColor;
           end;
         end;
       end;

       if FDrawArea then
       Begin { area }
         Brush.Color:=GetAreaBrushColor(tmpColor);

         if (FAreaLinesPen.Color=clTeeColor) or (not FAreaLinesPen.Visible) then
            AssignVisiblePenColor(FAreaLinesPen,tmpColor)
         else
            AssignVisiblePen(FAreaLinesPen);

         InternalDrawArea(Brush.Color);
       end
       else
       if (not View3D) and FDrawLine then
       begin // line 2D
         if ColorEachPoint and ColorEachLine then
            LinePrepareCanvas(Canvas,tmpColor)
         else
            LinePrepareCanvas(Canvas,SeriesColor);

         if FStairs then
         begin
           if FInvertedStairs then DoVertLine(OldX,OldY,Y)
                              else DoHorizLine(OldX,X,OldY);
           LineTo(X,Y);
         end
         else Line(OldX,OldY,X,Y);
       end;
     end;

     { pointers }
     if FPointer.Visible and DrawOldPointer then
     begin
       if OldColor=clNone then
       begin
         if FTreatNulls<>tnDontPaint then
            DrawPointer(OldX,OldY,tmpColor,Pred(ValueIndex));
       end
       else
          DrawPointer(OldX,OldY,OldColor,Pred(ValueIndex));

       if IsLastValue and (tmpColor<>clNone) then {<-- if not null }
          DrawPointer(X,Y,tmpColor,ValueIndex);
     end;
   end;

var tmpFirst : Integer;
Begin
  With ParentChart.Canvas do
  Begin
    tmpColor:=ValueColor[ValueIndex];
    X:=CalcXPos(ValueIndex);
    Y:=CalcYPos(ValueIndex);

    if (tmpColor=clNone) and (TreatNulls=tnSkip) then
    begin
      // skip
      X:=OldX;
      Y:=OldY;
    end;

    if Pen.Color<>clBlack then
       Pen.Color:=clBlack;

    if tmpColor<>Brush.Color then
       Brush.Color:=tmpColor;

    if OldColor=clNone then { if null }
    if FTreatNulls=tnDontPaint then
    begin
      OldX:=X;
      OldY:=Y;
    end;

    BottomPos:=GetOriginPos(ValueIndex);

    tmpFirst:=FirstDisplayedIndex;
    if DrawValuesForward then IsLastValue:=ValueIndex=LastValueIndex
                         else IsLastValue:=ValueIndex=FirstValueIndex;

    if ValueIndex=tmpFirst then { first point }
    Begin
      if FDark3D then
      With ParentChart do
         if SeriesWidth3D<>0 then
            tmpDark3DRatio:=Abs(SeriesHeight3D/SeriesWidth3D)
         else
            tmpDark3DRatio:=1;

      if (tmpFirst=FirstValueIndex) and (ValueIndex>0) then
      Begin  { previous point outside left }
        if FDrawArea then
        begin
          OldX:=CalcXPos(Pred(ValueIndex));
          OldY:=CalcYPos(Pred(ValueIndex));
          OldBottomPos:=GetOriginPos(Pred(ValueIndex));
        end
        else
        begin
          if GetHorizAxis.Inverted then OldX:=ParentChart.ChartRect.Right
                                   else OldX:=ParentChart.ChartRect.Left;

          if FStairs Then
             OldY:=CalcYPos(Pred(ValueIndex))
          else
             OldY:=CalcYPosLeftRight(GetHorizAxis.CalcPosPoint(OldX),Pred(ValueIndex))
        end;

        if not IsNull(Pred(ValueIndex)) then
           DrawPoint(False);
      end;

      // Draw pointer (only if point is not "null")
      if IsLastValue and FPointer.Visible and (tmpColor<>clNone) then
         DrawPointer(X,Y,tmpColor,ValueIndex);

      if SupportsFullRotation and FDrawArea and ParentChart.View3D then
         RectangleZ(X,Y,BottomPos,StartZ,EndZ);
    end
    else
       DrawPoint(True);

    OldX:=X;
    OldY:=Y;
    OldBottomPos:=BottomPos;
    OldColor:=tmpColor;
  end;
end;

Procedure TCustomSeries.DrawPointer(AX,AY:Integer; AColor:TColor; ValueIndex:Integer);
var tmpStyle : TSeriesPointerStyle;
begin
  // Set canvas properties to Pointer (Brush, Color, Pen)
  Pointer.PrepareCanvas(ParentChart.Canvas,AColor);

  // Call the OnGetPointerStyle event if assigned.
  tmpStyle:=DoGetPointerStyle(ValueIndex);

  // Repeat again setting Canvas parameters, thus allowing the developer
  // to use the OnGetPointerStyle event to modify other Pointer properties
  // like Color, Pen, etc.
  if Assigned(FOnGetPointerStyle) then
     Pointer.PrepareCanvas(ParentChart.Canvas,AColor);

  Pointer.Draw(AX,AY,AColor,tmpStyle);
end;

class Function TCustomSeries.GetEditorClass:String;
Begin
  result:='TCustomSeriesEditor'; { <-- dont translate ! }
end;

type
  TPointerAccess=class(TSeriesPointer);

Procedure TCustomSeries.InternalCalcMargin(SameSide,Horizontal:Boolean; var A,B:Integer);
var tmp : Integer;
begin
  if Horizontal then
     TPointerAccess(FPointer).CalcHorizMargins(A,B)
  else
     TPointerAccess(FPointer).CalcVerticalMargins(A,B);

  if FDrawLine then
  begin
    if FStairs then
    begin
      A:=Math.Max(A,LinePen.Width);
      B:=Math.Max(B,LinePen.Width);
    end;

    if FOutLine.Visible then { 5.02 }
    begin
      A:=Math.Max(A,FOutLine.Width);
      B:=Math.Max(B,FOutLine.Width);
    end;
  end;

  if Marks.Visible and SameSide then
  begin
    tmp:=CalcMarkLength;
    if YMandatory then A:=Math.Max(B,tmp)
                  else B:=Math.Max(A,tmp);
  end;
end;

Function TCustomSeries.CalcMarkLength:Integer;
begin
  result:=Marks.Callout.Length+Marks.Callout.Distance;
end;

Procedure TCustomSeries.CalcHorizMargins(var LeftMargin,RightMargin:Integer);
begin
  inherited;
  InternalCalcMargin(not YMandatory,True,LeftMargin,RightMargin);
end;

Procedure TCustomSeries.CalcVerticalMargins(var TopMargin,BottomMargin:Integer);
begin
  inherited;

  InternalCalcMargin(YMandatory,False,TopMargin,BottomMargin);

  if (FLineHeight>0) and (not FDrawArea) and ParentChart.View3D then
     if FLineHeight>BottomMargin then
        BottomMargin:=FLineHeight;
end;

Procedure TCustomSeries.CalcZOrder;
Begin
  if FStacked=cssNone then inherited
                      else IZOrder:=ParentChart.MaxZOrder;
End;

function TCustomSeries.SameClassOrigin(ASeries:TChartSeries):Boolean;
begin
  result:=ASeries.SameClass(Self);
end;

Function TCustomSeries.PointOrigin(ValueIndex:Integer; SumAll:Boolean):Double;
var t         : Integer;
    tmpSeries : TChartSeries;
    tmp       : Double;
    tmpValue  : Double;
Begin
  result:=0;

  if Assigned(ParentChart) then
  with ParentChart do
  begin
    tmpValue:=MandatoryValueList.Value[ValueIndex];

    for t:=0 to SeriesCount-1 do
    Begin
      tmpSeries:=Series[t];

      if (not SumAll) and (tmpSeries=Self) then Break
      else
      With tmpSeries do
      if Active and SameClassOrigin(tmpSeries) and (Count>ValueIndex) then
      begin
        tmp:=GetOriginValue(ValueIndex);

        if tmpValue<0 then
        begin
          if tmp<0 then result:=result+tmp;
        end
        else
          if tmp>0 then result:=result+tmp; { 5.01 }
      end;
    end;
  end;
end;

Function TCustomSeries.CalcStackedPos(ValueIndex:Integer; Value:Double):Integer;
var tmp : Double;
begin
  Value:=Value+PointOrigin(ValueIndex,False);

  if FStacked=cssStack then
     result:=Math.Min(MandatoryAxis.IEndPos,CalcPosValue(Value))
  else
  begin
    tmp:=PointOrigin(ValueIndex,True);

    if tmp<>0 then result:=CalcPosValue(Value*100.0/tmp)
              else result:=MandatoryAxis.IEndPos;
  end;
end;

Function TCustomSeries.GetOriginPos(ValueIndex:Integer):Integer;
Begin
  if (FStacked=cssNone) or (FStacked=cssOverlap) then
     if YMandatory then
     begin
       with GetVertAxis do
       if Inverted then result:=IStartPos else result:=IEndPos;
     end
     else
     begin
       with GetHorizAxis do
       if Inverted then result:=IEndPos else result:=IStartPos;
     end
  else
     result:=CalcStackedPos(ValueIndex,0);
end;

Function TCustomSeries.MaxXValue:Double;
var t : Integer;
Begin
  if YMandatory then
     result:=inherited MaxXValue
  else
  begin
    if FStacked=cssStack100 then
       result:=100
    else
    begin
      result:=CalcMinMaxValue(False);

      if FStacked=cssStack then
      for t:=0 to Count-1 do
          result:=Math.Max(result,PointOrigin(t,False)+XValues.Value[t]);
    end;
  end;
end;

Function TCustomSeries.MinXValue:Double;
Begin
  if not YMandatory then
     if FStacked=cssStack100 then
        result:=0
     else
        result:=CalcMinMaxValue(True)
  else
     result:=inherited MinXValue;
end;

Function TCustomSeries.MaxYValue:Double;
var t : Integer;
Begin
  if not YMandatory then
     result:=inherited MaxYValue
  else
  begin
    if FStacked=cssStack100 then
       result:=100
    else
    begin
      result:=CalcMinMaxValue(False);

      if FStacked=cssStack then
      for t:=0 to Count-1 do
          result:=Math.Max(result,PointOrigin(t,False)+YValues.Value[t]);
    end;
  end;
end;

function TCustomSeries.CalcMinMaxValue(IsMin:Boolean):TChartValue;
var t : Integer;
    tmpFirst : Boolean;
    tmpValue : TChartValue;
begin
  result:=0;
  tmpFirst:=True;

  for t:=0 to Count-1 do
  begin
    if (not IsNull(t)) or (TreatNulls=tnIgnore) then
    begin
      tmpValue:=MandatoryValueList.Value[t];

      if tmpFirst then
      begin
        result:=tmpValue;
        tmpFirst:=False;
      end
      else
      if IsMin then
         result:=Math.Min(result,tmpValue)
      else
         result:=Math.Max(result,tmpValue);
    end;
  end;
end;

Function TCustomSeries.MinYValue:Double;
var t : Integer;
Begin
  if YMandatory and (FStacked=cssStack100) then
     result:=0
  else
  begin
    if YMandatory then
       result:=CalcMinMaxValue(True)
    else
       result:=inherited MinYValue;

    if FStacked=cssStack then
    for t:=0 to Count-1 do
        result:=Math.Min(result,PointOrigin(t,False)+YValues.Value[t]);
  end;
end;

Function TCustomSeries.CalcXPos(ValueIndex:Integer):Integer;
Begin
  if (YMandatory) or (FStacked=cssNone) or (FStacked=cssOverlap) then
     result:=inherited CalcXPos(ValueIndex)
  else
     result:=CalcStackedPos(ValueIndex,XValues.Value[ValueIndex]);
end;

Function TCustomSeries.CalcYPos(ValueIndex:Integer):Integer;
Begin
  if (not YMandatory) or (FStacked=cssNone) or (FStacked=cssOverlap) then
     result:=inherited CalcYPos(ValueIndex)
  else
     result:=CalcStackedPos(ValueIndex,YValues.Value[ValueIndex]);
end;

function TCustomSeries.GetAreaBrush: TBrushStyle;
begin
  result:=FAreaBrush.Style;
end;

procedure TCustomSeries.SetStacked(Value: TCustomSeriesStack);

  Procedure SetOther;
  var t : Integer;
  Begin
    if Assigned(ParentChart) then
    with ParentChart do
    for t:=0 to SeriesCount-1 do
      if Self is Series[t].ClassType then
         TCustomSeries(Series[t]).FStacked:=FStacked;
  end;

Begin
  if Value<>FStacked then
  Begin
    FStacked:=Value;
    SetOther;
    Repaint;
  end;
end;

procedure TCustomSeries.SetAreaBrush(Value: TChartBrush);
begin
  FAreaBrush.Assign(Value);
end;

procedure TCustomSeries.SetColorEachLine(const Value: Boolean);
begin
  SetBooleanProperty(FColorEachLine,Value);
end;

Procedure TCustomSeries.SetDark3D(Value:Boolean);
begin
  SetBooleanProperty(FDark3D,Value);
end;

procedure TCustomSeries.SetOutLine(const Value: TChartHiddenPen);
begin
  FOutLine.Assign(Value);
end;

procedure TCustomSeries.DrawAllValues;
var tmpPen   : TChartPen;
    tmpColor : TColor;
    tmpPColor : Boolean;
    tmpSize  : Integer;
begin
  if Shadow.Visible then
     tmpSize:=Shadow.Size
  else
     tmpSize:=0;

  if tmpSize<>0 then
  begin
    tmpColor:=SeriesColor;
    SeriesColor:=Shadow.Color;

    tmpPColor:=Pointer.Visible;
    Pointer.Visible:=False;

    Inc(GetHorizAxis.IStartPos,Shadow.HorizSize);
    Inc(GetHorizAxis.IEndPos,Shadow.HorizSize);
    Inc(GetVertAxis.IStartPos,Shadow.VertSize);
    Inc(GetVertAxis.IEndPos,Shadow.VertSize);

    inherited;

    Dec(GetVertAxis.IStartPos,Shadow.VertSize);
    Dec(GetVertAxis.IEndPos,Shadow.VertSize);
    Dec(GetHorizAxis.IStartPos,Shadow.HorizSize);
    Dec(GetHorizAxis.IEndPos,Shadow.HorizSize);

    Pointer.Visible:=tmpPColor;
    SeriesColor:=tmpColor;
  end;

  if OutLine.Visible then { 5.02 }
  begin
    tmpPen:=TChartPen.Create(nil);
    try
      tmpColor:=SeriesColor;
      tmpPen.Assign(LinePen);
      LinePen:=OutLine;
      SeriesColor:=OutLine.Color;
      LinePen.Width:=2*tmpPen.Width+OutLine.Width+1;

      inherited;

      LinePen:=tmpPen;

      if not ParentChart.View3D then
         SeriesColor:=LinePen.Color  // 7.04 TV52010022
      else
         SeriesColor:=tmpColor;
    finally
      tmpPen.Free;
    end;
  end;

  inherited;
end;

procedure TCustomSeries.SetTransparency(const Value: TTeeTransparency);
begin
  if FTransparency<>Value then
  begin
    FTransparency:=Value;
    Repaint;
  end;
end;

procedure TCustomSeries.SetGradient(Value: TChartGradient);
begin
  FGradient.Assign(Value);
end;

function TCustomSeries.GetTransparency: TTeeTransparency;
begin
  result:=FTransparency;
end;

function TCustomSeries.GetGradient: TChartGradient;
begin
  result:=FGradient;
end;

{ TLineSeries }
Constructor TLineSeries.Create(AOwner: TComponent);
Begin
  inherited;
  FDrawLine:=True;
  AllowSinglePoint:=False;
  FPointer.Hide;
  IMandatoryPen2D:=True;
end;

Procedure TLineSeries.PrepareLegendCanvas( ValueIndex:Integer; var BackColor:TColor;
                                           var BrushStyle:TBrushStyle);
Begin
  ParentChart.Canvas.AssignVisiblePen(LinePen);
  BrushStyle:=LineBrush;
end;

Procedure TLineSeries.Assign(Source:TPersistent);
begin
  inherited;

  if (not (Source is Self.ClassType)) and
     (not (Source is TLineSeries)) then
         FPointer.Hide;

  FDrawArea:= False;
  FDrawLine:= True;
end;

class Procedure TLineSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
begin
  With TLineSeries(ASeries) do
  Case Index of
    1: Stairs:=True;
    2: Pointer.Visible:=True;
    3: LineHeight:=5;
    4: LineBrush:=bsClear;
    5: ColorEachPoint:=True;
    6: Marks.Visible:=True;
    7: Pen.Hide;
    8: OutLine.Show;
  end;
end;

class Procedure TLineSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Stairs);
  AddSubChart(TeeMsg_Points);
  AddSubChart(TeeMsg_Height);
  AddSubChart(TeeMsg_Hollow);
  AddSubChart(TeeMsg_Colors);
  AddSubChart(TeeMsg_Marks);
  AddSubChart(TeeMsg_NoBorder);
  AddSubChart(TeeMsg_Outline);
end;

{ THorizLineSeries }
Constructor THorizLineSeries.Create(AOwner: TComponent);
begin
  inherited;
  SetHorizontal;
  CalcVisiblePoints:=False; { avoid bug first point and scroll }
  XValues.Order:=loNone;
  YValues.Order:=loAscending;
end;

Function THorizLineSeries.CalcMarkLength:Integer; // 7.0
begin
  result:=MaxMarkWidth;
end;

Procedure THorizLineSeries.DrawMark( ValueIndex:Integer; Const St:String;
                                     APosition:TSeriesMarkPosition);
var DifW : Integer;
    tmp  : Boolean;
Begin
  With APosition do
  begin
    DifW:=Marks.Callout.Length+Marks.Callout.Distance;
    tmp:=ArrowFrom.X<GetOriginPos(ValueIndex);
    if tmp then DifW:=-DifW-Width;

    Inc(LeftTop.X,DifW+(Width div 2));
    Inc(LeftTop.Y,Height div 2);
    Inc(ArrowTo.X,DifW);

    if tmp then
       Dec(ArrowFrom.X,Marks.Callout.Distance)
    else
       Inc(ArrowFrom.X,Marks.Callout.Distance);
  end;

  inherited;
end;

type
  TCalloutAccess=class(TMarksCallout);

{ TPointSeries }
Constructor TPointSeries.Create(AOwner: TComponent);
Begin
  inherited;
  SetFixed;
  Marks.Callout.Length:=0;
  TCalloutAccess(Marks.Callout).DefaultLength:=0;
end;

Procedure TPointSeries.Assign(Source:TPersistent);
begin
  inherited;
  SetFixed;
end;

Procedure TPointSeries.SetFixed;
begin
  FPointer.Visible:=True;
  FDrawArea:=False;
  FDrawLine:=False;
  ClickableLine:=False;
end;

class Function TPointSeries.GetEditorClass:String;
begin
  result:='TSeriesPointerEditor'; // Do not localize
end;

Procedure TPointSeries.PrepareForGallery(IsEnabled:Boolean);
var tmp : Integer;
begin
  inherited;

  With ParentChart do
  begin
    if Width<50 then tmp:=4
                else tmp:=6;

    Pointer.HorizSize:=tmp;
    Pointer.VertSize:=tmp;

    if (SeriesCount>1) and (Self=Series[1]) then
       Pointer.Style:=psTriangle;
  end;
end;

Procedure TPointSeries.SetColorEachPoint(Value:Boolean);
begin
  inherited;

  if Value then
     Pointer.Color:=clTeeColor;
end;

class Procedure TPointSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Colors);
  AddSubChart(TeeMsg_Marks);
  AddSubChart(TeeMsg_Hollow);
  AddSubChart(TeeMsg_NoBorder);
  AddSubChart(TeeMsg_Gradient);

  if CanDoExtra then
  begin
    AddSubChart(TeeMsg_Point2D);
    AddSubChart(TeeMsg_Triangle);
    AddSubChart(TeeMsg_Star);
    AddSubChart(TeeMsg_Circle);
    AddSubChart(TeeMsg_DownTri);
    AddSubChart(TeeMsg_Cross);
    AddSubChart(TeeMsg_Diamond);
    AddSubChart(TeeMsg_Hexagon);
  end;
end;

class Procedure TPointSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
begin
  With TPointSeries(ASeries) do
  Case Index of
    1: ColorEachPoint:=True;
    2: Marks.Visible:=True;
    3: Pointer.Brush.Style:=bsClear;
    4: Pointer.Pen.Hide;
    5: Pointer.Gradient.Visible:=True;
  else
  if CanDoExtra then
    Case Index of
      6: Pointer.Draw3D:=False;
      7: Pointer.Style:=psTriangle;
      8: Pointer.Style:=psStar;
      9: With Pointer do
         begin
           Style:=psCircle;
           HorizSize:=8;
           VertSize:=8;
         end;
     10: Pointer.Style:=psDownTriangle;
     11: Pointer.Style:=psCross;
     12: Pointer.Style:=psDiamond;
     13: Pointer.Style:=psHexagon;
    end;
  end;
end;

// For sub-gallery only. 
class function TPointSeries.CanDoExtra: Boolean;
begin
  result:=True;
end;

function TPointSeries.GetTransparency: TTeeTransparency;
begin
  result:=Pointer.Transparency;
end;

procedure TPointSeries.SetTransparency(const Value: TTeeTransparency);
begin
  Pointer.Transparency:=Value;
end;

{ TAreaSeries }
Constructor TAreaSeries.Create(AOwner: TComponent);
Begin
  inherited;
  FDrawArea:=True;
  AllowSinglePoint:=False;
  FPointer.Hide;
end;

Procedure TAreaSeries.PrepareLegendCanvas( ValueIndex:Integer; var BackColor:TColor;
                                           var BrushStyle:TBrushStyle);
Begin
  BackColor:=GetAreaBrushColor(ParentChart.Canvas.Brush.Color);
  ParentChart.Canvas.AssignVisiblePen(FAreaLinesPen);
  BrushStyle:=FAreaBrush.Style;
end;

Procedure TAreaSeries.Assign(Source:TPersistent);
begin
  inherited;

  FDrawArea:=True;
  FDrawLine:=True;

  if (Source is Self.ClassType) or (Self is Source.ClassType) then
  With TAreaSeries(Source) do
  begin
    Self.FOrigin    :=YOrigin;
    Self.FStackGroup:=StackGroup;
    Self.FUseOrigin :=UseYOrigin;
  end
  else FPointer.Hide;
end;

class Function TAreaSeries.GetEditorClass:String;
Begin
  result:='TAreaSeriesEditor'; { <-- dont translate ! }
end;

function TAreaSeries.GetMultiArea: TMultiArea;
begin
  Case Stacked of
    cssStack: result:=maStacked;
    cssStack100: result:=maStacked100;
  else
    result:=maNone;
  end;
end;

Procedure TAreaSeries.SetMultiArea(Value:TMultiArea);
Begin
  if Value<>MultiArea then
  Case Value of
    maNone      : Stacked:=cssNone;
    maStacked   : Stacked:=cssStack;
    maStacked100: Stacked:=cssStack100;
  end;
End;

function TAreaSeries.SameClassOrigin(ASeries:TChartSeries):Boolean;
begin
  result:=inherited SameClassOrigin(ASeries) and
          (TAreaSeries(ASeries).StackGroup=StackGroup);
end;

type
  TSeriesAccess=class(TChartSeries);

Procedure TAreaSeries.CalcZOrder;
var t   : Integer;
    tmp : TChartSeries;
    tmpZOrder : Integer;
    Old : TCustomSeriesStack;
begin
  if MultiArea=maNone then
     inherited
  else
  begin
    // Copy ZOrder from previous active Area series with same StackGroup...

    tmpZOrder:=-1;

    with ParentChart do
    for t:=0 to SeriesCount-1 do
    begin
      tmp:=Series[t];

      if tmp.Active then
      begin
        if tmp=Self then
           break
        else
        if SameClassOrigin(tmp) then
        begin
          tmpZOrder:=tmp.ZOrder;
          break;
        end;
      end;
    end;

    if tmpZOrder=-1 then
    begin
      Old:=FStacked;
      FStacked:=cssNone;
      try
        inherited;
      finally
        FStacked:=Old;
      end;
    end
    else
       IZOrder:=tmpZOrder;
  end;
end;

class Procedure TAreaSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Stairs);
  AddSubChart(TeeMsg_Marks);
  AddSubChart(TeeMsg_Colors);
  AddSubChart(TeeMsg_Hollow);
  AddSubChart(TeeMsg_NoLines);
//  AType.NumGallerySeries:=2;
  AddSubChart(TeeMsg_Stack);
  AddSubChart(TeeMsg_Stack100);
//  AType.NumGallerySeries:=1;
  AddSubChart(TeeMsg_Points);
  AddSubChart(TeeMsg_Gradient);
end;

class Procedure TAreaSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
begin
  With TAreaSeries(ASeries) do
  Case Index of
    1: Stairs:=True;
    2: Marks.Visible:=True;
    3: ColorEachPoint:=True;
    4: AreaBrush:=bsClear;
    5: AreaLinesPen.Hide;
    6: MultiArea:=maStacked;
    7: MultiArea:=maStacked100;
    8: Pointer.Visible:=True;
    9: Gradient.Visible:=True;
  end;
end;

Function TAreaSeries.DrawSeriesForward(ValueIndex:Integer):Boolean;
begin
  if MultiArea=maNone then
     result:=inherited DrawSeriesForward(ValueIndex)
  else
     result:=not MandatoryAxis.Inverted;
end;

procedure TAreaSeries.SetOrigin(const Value: Double);
begin
  SetDoubleProperty(FOrigin,Value)
end;

Procedure TAreaSeries.SetStackGroup(const Value:Integer);
begin
  SetIntegerProperty(FStackGroup,Value);
end;

procedure TAreaSeries.SetUseOrigin(Value: Boolean);
begin
  SetBooleanProperty(FUseOrigin,Value)
end;

function TAreaSeries.MaxXValue: Double;
begin
  result:=inherited MaxXValue;
  if (not YMandatory) and UseYOrigin and (result<YOrigin) then result:=YOrigin;
end;

function TAreaSeries.MinXValue: Double;
begin
  result:=inherited MinXValue;
  if (not YMandatory) and UseYOrigin and (result>YOrigin) then result:=YOrigin;
end;

function TAreaSeries.MaxYValue: Double;
begin
  result:=inherited MaxYValue;
  if YMandatory and UseYOrigin and (result<YOrigin) then result:=YOrigin;
end;

function TAreaSeries.MinYValue: Double;
begin
  result:=inherited MinYValue;
  if YMandatory and UseYOrigin and (result>YOrigin) then result:=YOrigin;
end;

function TAreaSeries.GetOriginPos(ValueIndex: Integer): Integer;
begin
  if UseYOrigin then result:=CalcPosValue(YOrigin)
                else result:=inherited GetOriginPos(ValueIndex);
end;

procedure TAreaSeries.DrawLegendShape(ValueIndex: Integer; const Rect: TRect);
var tmpColor : TColor;
    tmpBack  : TColor;
begin
  if FGradient.Visible then
     FGradient.Draw(ParentChart.Canvas,Rect)
  else
  begin
    if Assigned(FAreaBrush.Image.Graphic) then  // 7.04 TV52010270
    begin
      tmpColor:=FAreaBrush.Color;
      if tmpColor=clTeeColor then
         tmpColor:=LegendItemColor(ValueIndex);

      tmpBack:=GetAreaBrushColor(ParentChart.Canvas.Brush.Color);
      if tmpColor=tmpBack then
         tmpBack:=clWhite;

      ParentChart.Canvas.AssignBrush(FAreaBrush,tmpColor,tmpBack);
    end;

    inherited;
  end;
end;

procedure TAreaSeries.PrepareForGallery(IsEnabled: Boolean);
begin
  inherited;
  Gradient.Visible:=True;
  Color:=ParentChart.GetDefaultColor(clTeeGallery2);
  Gradient.EndColor:=ParentChart.GetDefaultColor(clTeeGallery1);
end;

{ THorizAreaSeries }
Constructor THorizAreaSeries.Create(AOwner: TComponent);
begin
  inherited;
  SetHorizontal;

  //  CalcVisiblePoints:=False; { avoid bug first point and scroll }

  XValues.Order:=loNone;
  YValues.Order:=loAscending;
  FGradient.Direction:=gdRightLeft;
end;

procedure THorizAreaSeries.DrawMark(ValueIndex: Integer; const St: String;
  APosition: TSeriesMarkPosition);
var DifH : Integer;
    DifW : Integer;
begin
  With APosition do
  begin
    DifH:=Height div 2;

    DifW:=Marks.Callout.Length+Marks.Callout.Distance;

    LeftTop.Y:=ArrowTo.Y-DifH;

    Inc(LeftTop.X,DifW+(Width div 2));

    Inc(ArrowTo.X,DifW);

    ArrowFrom.Y:=ArrowTo.Y;
    Inc(ArrowFrom.X,Marks.Callout.Distance);
  end;

  inherited;
end;

function THorizAreaSeries.NumSampleValues: Integer;
begin
  result:=10;
end;

{ TBarSeriesGradient }
procedure TBarSeriesGradient.SetRelative(const Value: Boolean);
begin
  if Relative<>Value then
  begin
    FRelative:=Value;
    Changed(Self);
  end;
end;

{$IFNDEF CLR}
type
  TShadowAccess=class(TTeeShadow);
{$ENDIF}

{ TCustomBarSeries }
Constructor TCustomBarSeries.Create(AOwner:TComponent);
Begin
  inherited;
  FBarWidthPercent:=70;
  FDepthPercent:=100;
  FBarStyle:=bsRectangle;

  FGradient:=TBarSeriesGradient.Create(CanvasChanged);
  FGradient.Visible:=True; { 5.02 }

  FBevelSize:=1;
  FUseOrigin:=True;
  FMultiBar:=mbSide;
  FAutoMarkPosition:=True;

  Marks.Visible:=True;

  Marks.Callout.Length:=20;
  TCalloutAccess(Marks.Callout).DefaultLength:=20;

  FDark3D:=True;
  FSideMargins:=True;

  FTickLines:=TChartHiddenPen.Create(CanvasChanged);

  FShadow:=TTeeShadow.Create(CanvasChanged);
  FShadow.Color:=clDkGray;
  {$IFNDEF CLR}TShadowAccess{$ENDIF}(FShadow).DefaultColor:=clDkGray;
end;

Destructor TCustomBarSeries.Destroy;
begin
  FShadow.Free;
  FTickLines.Free;
  FGradient.Free;
  inherited;
end;

Procedure TCustomBarSeries.CalcZOrder;
var t         : Integer;
    tmpZOrder : Integer;
    tmp       : TChartSeries;
Begin
  if FMultiBar=mbNone then
     inherited
  else
  begin
    tmpZOrder:=-1;

    // Copy ZOrder from previous active CustomBar series...
    with ParentChart do
    for t:=0 to SeriesCount-1 do
    begin
      tmp:=Series[t];

      if tmp.Active then
      begin
        if tmp=Self then break
        else
        if SameClass(tmp) then
        Begin
          tmpZOrder:=tmp.ZOrder;
          break;
        end;
      end;
    end;

    if tmpZOrder=-1 then inherited
                    else IZOrder:=tmpZOrder;
  end;
End;

procedure TCustomBarSeries.CalcDepthPositions;
var tmp : Integer;
begin
  inherited;

  if DepthPercent<>0 then
  begin
    tmp:=Round((EndZ-StartZ)*(100-DepthPercent)*0.005);
    StartZ:=StartZ+tmp;
    EndZ:=EndZ-tmp;
  end;
end;

Procedure TCustomBarSeries.CalcFirstLastVisibleIndex;
begin
  if FMultiBar=mbSelfStack then
  begin
    FFirstVisibleIndex:=0;
    FLastVisibleIndex:=Count-1;
  end
  else
  if ParentChart.MaxPointsPerPage=1 then
  begin
    // 7.01 Very special case, only for THorizBar and TBar series
    FFirstVisibleIndex:=ParentChart.Pages.Current-1;

    if FFirstVisibleIndex>=Count then
       FFirstVisibleIndex:=-1;

    FLastVisibleIndex:=FFirstVisibleIndex;
  end
  else
    inherited;
end;

Function TCustomBarSeries.NumSampleValues:Integer;
var t : Integer;
Begin
  result:=6; { default number of BarSeries random sample values }
  if Assigned(ParentChart) and (ParentChart.SeriesCount>1) then
     for t:=0 to ParentChart.SeriesCount-1 do
     if (ParentChart[t]<>Self) and
        (ParentChart[t] is TCustomBarSeries) and
        (ParentChart[t].Count>0) then
     begin
       result:=ParentChart[t].Count;
       break;
     end;
end;

Procedure TCustomBarSeries.SetBarWidthPercent(Value:Integer);
Begin
  SetIntegerProperty(FBarWidthPercent,Value);
end;

Procedure TCustomBarSeries.SetDepthPercent(Value:Integer);
Begin
  SetIntegerProperty(FDepthPercent,Value);
end;

Procedure TCustomBarSeries.SetOffsetPercent(Value:Integer);
Begin
  SetIntegerProperty(FOffsetPercent,Value);
End;

Procedure TCustomBarSeries.SetCustomBarSize(Value:Integer);
Begin
  SetIntegerProperty(FCustomBarSize,Value);
end;

Procedure TCustomBarSeries.SetParentChart(Const Value:TCustomAxisPanel);
begin
  inherited;
  SetOtherBars(False);
end;

Procedure TCustomBarSeries.SetBarStyle(Value:TBarStyle);
Begin
  if FBarStyle<>Value then
  begin
    FBarStyle:=Value;
    Repaint;
  end;
end;

{ If more than one bar series exists in chart,
  which position are we? the first, the second, the third? }
Procedure TCustomBarSeries.DoBeforeDrawChart;
var Groups : Array of Integer;

  Function NewGroup(AGroup:Integer):Boolean;
  var t : Integer;
  begin
    for t:=0 to Length(Groups)-1 do
    if Groups[t]=AGroup then
    begin
      result:=False;
      exit;
    end;

    SetLength(Groups,Length(Groups)+1);
    Groups[Length(Groups)-1]:=AGroup;
    result:=True;
  end;

var t    : Integer;
    Stop : Boolean;
    tmp  : Integer;
begin
  inherited;

  IOrderPos:=1;
  IPreviousCount:=0;
  INumBars:=0;
  IMaxBarPoints:=TeeAllValues;
  Groups:=nil;
  Stop:=False;

  With ParentChart do
  for t:=0 to SeriesCount-1 do
  if Series[t].Active and SameClass(Series[t]) then
  begin
    Stop:=Stop or (Series[t]=Self);
    tmp:=Series[t].Count;

    if (IMaxBarPoints=TeeAllValues) or (tmp>IMaxBarPoints) then
    begin
      IMaxBarPoints:=tmp;

      if FSideMargins and (tmp>0) then // 7.06
         Inc(IMaxBarPoints);
    end;

    Case FMultiBar of
      mbNone: INumBars:=1;
      mbSide,
      mbSideAll: begin
                   Inc(INumBars);
                   if not Stop then Inc(IOrderPos);
                 end;
      mbStacked,
      mbStacked100: if NewGroup(TCustomBarSeries(Series[t]).FStackGroup) then
                    begin
                      Inc(INumBars);
                      if not Stop then Inc(IOrderPos);
                    end;
      mbSelfStack: INumBars:=1;
    end;

    if not Stop then
       Inc(IPreviousCount,tmp);
  end;

  for t:=0 to Length(Groups)-1 do
  if Groups[t]=FStackGroup then
  begin
    IOrderPos:=t+1;
    break;
  end;

  Groups:=nil;

  { this should be after calculating INumBars }
  if FMultiBar=mbSelfStack then
     if ParentChart.MaxPointsPerPage=0 then
        IMaxBarPoints:=INumBars
     else
        IMaxBarPoints:=ParentChart.MaxPointsPerPage

  else
  if ParentChart.MaxPointsPerPage>0 then
     IMaxBarPoints:=ParentChart.MaxPointsPerPage;
end;

Function TCustomBarSeries.CalcMarkLength(ValueIndex:Integer):Integer;
Begin
  if (Count>0) and Marks.Visible then
  Begin
    ParentChart.Canvas.AssignFont(Marks.Font);
    result:=Marks.Callout.Length+InternalCalcMarkLength(ValueIndex);

    with Marks.Frame do
    if Visible then
       Inc(result,2*Width);
  end
  else result:=0;
end;

Procedure TCustomBarSeries.SetUseOrigin(Value:Boolean);
Begin
  SetBooleanProperty(FUseOrigin,Value);
End;

procedure TCustomBarSeries.SetShadow(Const Value:TTeeShadow);
begin
  FShadow.Assign(Value);
end;

Procedure TCustomBarSeries.SetSideMargins(Value:Boolean);
Begin
  SetBooleanProperty(FSideMargins,Value);
  SetOtherBars(True);
end;

Procedure TCustomBarSeries.SetDark3D(Value:Boolean);
Begin
  SetBooleanProperty(FDark3D,Value);
End;

Procedure TCustomBarSeries.SetDarkPen(Value:Integer);
begin
  SetIntegerProperty(FDarkPen,Value);
end;

Function TCustomBarSeries.InternalCalcMarkLength(ValueIndex:Integer):Integer; // virtual; abstract;
begin
  result:=0;
end;

Function TCustomBarSeries.InternalClicked(ValueIndex:Integer; P:TPoint):Boolean; // virtual; abstract;
begin
  result:=False;
end;

Procedure TCustomBarSeries.PrepareForGallery(IsEnabled:Boolean);
Begin
  inherited;
  BarWidthPercent:=85;
  BarStyle:=bsRectGradient;
  Gradient.Visible:=True;
  MultiBar:=mbNone;
  DarkPen:=130;
end;

Procedure TCustomBarSeries.SetOrigin(Const Value:Double);
Begin
  SetDoubleProperty(FOrigin,Value);
End;

Function TCustomBarSeries.Clicked(x,y:Integer):Integer;
var t : Integer;
    P : TPoint;
Begin
  if (FirstValueIndex>-1) and (LastValueIndex>-1) then
  begin
    P.X:=X;
    P.Y:=Y;

    for t:=FirstValueIndex to Min(LastValueIndex,Count-1) do
    if InternalClicked(t,P) then
    begin
      result:=t;
      exit;
    end;
  end;

  result:=TeeNoPointClicked;
end;

Procedure TCustomBarSeries.SetOtherBars(SetOthers:Boolean);
var t : Integer;
Begin
  if Assigned(ParentChart) then
  with ParentChart do
  for t:=0 to SeriesCount-1 do
    if SameClass(Series[t]) then
       With TCustomBarSeries(Series[t]) do
       begin
         if SetOthers then
         begin
           FMultiBar:=Self.FMultiBar;
           FSideMargins:=Self.FSideMargins;
         end
         else
         begin
           Self.FMultiBar:=FMultiBar;
           Self.FSideMargins:=FSideMargins;
           break;
         end;
         
         CalcVisiblePoints:=FMultiBar<>mbSelfStack;
       end;
end;

Procedure TCustomBarSeries.SetMultiBar(Value:TMultiBar);
Begin
  if Value<>FMultiBar then
  Begin
    FMultiBar:=Value;
    SetOtherBars(True);
    Repaint;
  end;
End;

Function TCustomBarSeries.InternalGetOriginPos(ValueIndex:Integer; DefaultOrigin:Integer):Integer;
var tmp      : Double;
    tmpValue : Double;
Begin
  tmpValue:=PointOrigin(ValueIndex,False);
  Case FMultiBar of
    mbStacked,
    mbSelfStack: result:=CalcPosValue(tmpValue);
    mbStacked100:
      begin
        tmp:=PointOrigin(ValueIndex,True);
        if tmp<>0 then result:=CalcPosValue(tmpValue*100.0/tmp)
                  else result:=0;
      end;
  else
    if FUseOrigin then result:=CalcPosValue(tmpValue)
                  else result:=DefaultOrigin;
  end;
end;

Function TCustomBarSeries.PointOrigin(ValueIndex:Integer; SumAll:Boolean):Double;

  Function InternalPointOrigin:Double;
  var t         : Integer;
      tmpSeries : TChartSeries;
      tmp       : Double;
      tmpValue  : Double;
  Begin
    result:=0;

    if Assigned(ParentChart) then
    with ParentChart do
    begin
      tmpValue:=MandatoryValueList.Value[ValueIndex];

      for t:=0 to SeriesCount-1 do
      Begin
        tmpSeries:=Series[t];

        if (not SumAll) and (tmpSeries=Self) then Break
        else
        With tmpSeries do
        if Active and SameClass(Self) and (Count>ValueIndex)
           and (TCustomBarSeries(tmpSeries).StackGroup=Self.StackGroup) then
        begin
          tmp:=GetOriginValue(ValueIndex);

          if tmpValue<0 then
          begin
            if tmp<0 then result:=result+tmp;
          end
          else
            if tmp>0 then result:=result+tmp; { 5.01 }
        end;
      end;
    end;
  end;

var t : Integer;
begin
  if (FMultiBar=mbStacked) or
     (FMultiBar=mbStacked100) then
    result:=InternalPointOrigin
  else
  if FMultiBar=mbSelfStack then
  begin
    result:=0;
    for t:=0 to ValueIndex-1 do result:=result+MandatoryValueList.Value[t];
  end
  else
    result:=FOrigin;
End;

Procedure TCustomBarSeries.DrawTickLine(TickPos:Integer; AStyle:TBarStyle);
begin
end;

Procedure TCustomBarSeries.DrawLegendShape(ValueIndex:Integer; Const Rect:TRect);
begin
  if Assigned(BarBrush.Image.Graphic) then
     ParentChart.Canvas.Brush.Bitmap:=BarBrush.Image.Bitmap;

  inherited;
end;

Procedure TCustomBarSeries.PrepareBarPen(ValueIndex:Integer);
begin
  with ParentChart.Canvas do
  if (FDarkPen>0) and (ValueIndex<>-1) then
     AssignVisiblePenColor(BarPen,ApplyDark(ValueColor[ValueIndex],255-FDarkPen))
  else
     AssignVisiblePen(BarPen);
end;

Procedure TCustomBarSeries.PrepareLegendCanvas( ValueIndex:Integer; var BackColor:TColor;
                                                var BrushStyle:TBrushStyle);
Begin
  PrepareBarPen(ValueIndex);

  BrushStyle:=BarBrush.Style;

  if BarBrush.Color=clTeeColor then BackColor:=ParentChart.Color
                               else BackColor:=BarBrush.Color;
end;

Procedure TCustomBarSeries.SetPenBrushBar(BarColor:TColor; ValueIndex:Integer=-1);
var tmpBack : TColor;
Begin
  With ParentChart do
  begin
    PrepareBarPen(ValueIndex);

    if BarBrush.Color=clTeeColor then tmpBack:=Color
                                 else tmpBack:=BarBrush.Color;

    SetBrushCanvas(BarColor,BarBrush,tmpBack);
  end;
end;

Procedure TCustomBarSeries.BarRectangle( BarColor:TColor;
                                         ALeft,ATop,ARight,ABottom:Integer);
begin
  With ParentChart.Canvas do
  begin
    if Brush.Style=bsSolid then
    Begin
      if (ARight=ALeft) or (ATop=ABottom) then
      Begin
        Pen.Color:=Brush.Color;
        if Pen.Style=psClear then Pen.Style:=psSolid;
        Line(ALeft,ATop,ARight,ABottom);
      end
      else
      if (Abs(ARight-ALeft)<Pen.Width) or
         (Abs(ABottom-ATop)<Pen.Width) then
      Begin
        Pen.Color:=Brush.Color;
        if Pen.Style=psClear then Pen.Style:=psSolid;
        Brush.Style:=bsClear;
      end;
    end;

    Rectangle(ALeft,ATop,ARight,ABottom);
  end;
End;

Function TCustomBarSeries.GetBarStyle(ValueIndex:Integer):TBarStyle;
Begin
  result:=FBarStyle;
  if Assigned(FOnGetBarStyle) then FOnGetBarStyle(Self,ValueIndex,result);
end;

Function TCustomBarSeries.GetBarBrush:TChartBrush;
begin
  result:=Brush;
end;

Function TCustomBarSeries.GetBarPen:TChartPen;
begin
  result:=Pen;
end;

Procedure TCustomBarSeries.SetGradient(Value:TBarSeriesGradient);
begin
  FGradient.Assign(Value);
end;

class Function TCustomBarSeries.GetEditorClass:String;
Begin
  result:='TBarSeriesEditor'; { <-- dont translate ! }
end;

Function TCustomBarSeries.BarMargin:Integer;
Begin
  result:=IBarSize;
  if FMultiBar<>mbSideAll then result:=result*INumBars;
  if not SideMargins then result:=result div 2;
end;

Function TCustomBarSeries.ApplyBarOffset(Position:Integer):Integer;
Begin
  result:=Position;
  if OffsetPercent<>0 then Inc(result,Round(OffsetPercent*IBarSize*0.01));
end;

Procedure TCustomBarSeries.SetAutoMarkPosition(Value:Boolean);
Begin
  SetBooleanProperty(FAutoMarkPosition,Value);
end;

Procedure TCustomBarSeries.SetAutoBarSize(Value:Boolean);
Begin
  SetBooleanProperty(FAutoBarSize,Value);
end;

Procedure TCustomBarSeries.Assign(Source:TPersistent);
begin
  if Source is TCustomBarSeries then
  With TCustomBarSeries(Source) do
  begin
    Self.FAutoMarkPosition:=FAutoMarkPosition;
    Self.FBarWidthPercent:=FBarWidthPercent;
    Self.FBarStyle       :=FBarStyle;
    Self.FBevelSize      :=FBevelSize;
    Self.FCustomBarSize  :=FCustomBarSize;
    Self.FDark3D         :=FDark3D;
    Self.FDarkPen        :=FDarkPen;
    Self.FDepthPercent   :=FDepthPercent;
    Self.Gradient        :=FGradient;
    Self.FMultiBar       :=FMultiBar;
    Self.FOffsetPercent  :=FOffsetPercent;
    Self.FOrigin         :=FOrigin;
    Self.Shadow          :=Shadow;
    Self.FSideMargins    :=FSideMargins;
    Self.FStackGroup     :=FStackGroup;
    Self.TickLines       :=TickLines;
    Self.FTransparency   :=FTransparency;
    Self.FUseOrigin      :=FUseOrigin;
  end;

  inherited;
end;

Function TCustomBarSeries.AddBar( Const AValue:Double;
                                  Const ALabel:String; AColor:TColor):Integer;
begin
  result:=Add(AValue,ALabel,AColor);
end;

Procedure TCustomBarSeries.BarGradient(ValueIndex:Integer; R:TRect);
var P : TFourPoints;
    tmpW : Integer;
begin
  CalcGradientColor(ValueIndex);

  if ParentChart.View3D then
  begin
    if ParentChart.View3DOptions.Orthogonal then
    begin
      if BarPen.Visible then
      begin
        Inc(R.Left);
        Inc(R.Top);
        Dec(R.Right,BarPen.Width-1);
        Dec(R.Bottom,BarPen.Width-1);
      end;
      R:=ParentChart.Canvas.CalcRect3D(R,StartZ);
    end
    else
    begin
      ParentChart.Canvas.FourPointsFromRect(R,StartZ,P);

      if BarPen.Visible then
      begin
        tmpW:=BarPen.Width;
        Inc(P[0].X,tmpW); Inc(P[0].Y,tmpW);
        Dec(P[1].X,tmpW); Inc(P[1].Y,tmpW);
        Dec(P[2].X,tmpW); Dec(P[2].Y,tmpW);
        Inc(P[3].X,tmpW); Dec(P[3].Y,tmpW);
      end;

      Gradient.Draw(ParentChart.Canvas,P);

      Exit;
    end;
  end
  else
  if BarPen.Visible then
  begin
    Inc(R.Left);
    Inc(R.Top);
    Dec(R.Right,BarPen.Width);
    Dec(R.Bottom,BarPen.Width);
  end;

  Gradient.Draw(ParentChart.Canvas,R);
end;

Function TCustomBarSeries.MaxMandatoryValue(Const Value:Double):Double;
var t   : Integer;
    tmp : Double;
begin
  if FMultiBar=mbStacked100 then result:=100
  else
  begin
    result:=Value;

    if FMultiBar=mbSelfStack then result:=MandatoryValueList.Total
    else
    if FMultiBar=mbStacked then
    for t:=0 to Count-1 do
    Begin
      tmp:=PointOrigin(t,False)+MandatoryValueList.Value[t];
      if tmp>result then result:=tmp;
    end;

    if FUseOrigin and (result<FOrigin) then result:=FOrigin;
  end;
end;

Function TCustomBarSeries.MinMandatoryValue(Const Value:Double):Double;
var t   : Integer;
    tmp : Double;
begin
  if FMultiBar=mbStacked100 then result:=0
  else
  begin
    result:=Value;

    if (FMultiBar=mbStacked) or (FMultiBar=mbSelfStack) then
    for t:=0 to Count-1 do
    Begin
      tmp:=PointOrigin(t,False)+MandatoryValueList.Value[t];
      if tmp<result then result:=tmp;
    end;

    if FUseOrigin and (result>FOrigin) then result:=FOrigin;
  end;
end;

Procedure TCustomBarSeries.InternalApplyBarMargin(var MarginA,MarginB:Integer);

  Procedure CalcBarWidth;
  var tmpAxis : TChartAxis;
      tmp     : Integer;
  begin
    if FCustomBarSize<>0 then IBarSize:=FCustomBarSize
    else
    if IMaxBarPoints>0 then
    Begin
      if YMandatory then tmpAxis:=GetHorizAxis
                    else tmpAxis:=GetVertAxis;

      With ParentChart,tmpAxis do
      if FAutoBarSize then
         tmp:=Round(IAxisSize/(2.0+Maximum-Minimum))
      else
         tmp:=IAxisSize div IMaxBarPoints;

      IBarSize:=Round((FBarWidthPercent*0.01)*tmp) div INumBars;
      if (IBarSize mod 2)=1 then Inc(IBarSize);
    end
    else IBarSize:=0;
  end;

var tmp : Integer;
begin
  CalcBarWidth;
  tmp:=BarMargin;
  Inc(MarginA,tmp);
  Inc(MarginB,tmp);
end;

Procedure TCustomBarSeries.CalcGradientColor(ValueIndex:Integer);
var tmpRatio : Double;
    tmp      : Double;
    T0,T1,T2 : Byte;
    RGB      : TRGB;
begin
  if Gradient.Relative then { 5.02 }
  begin
    with MandatoryValueList do
    begin
      if UseYOrigin then tmp:=YOrigin else tmp:=MinValue;
      tmpRatio:=(Value[ValueIndex]-tmp)/(MaxValue-tmp);
    end;

    T0:=Byte(Gradient.StartColor);
    T1:=Byte(Gradient.StartColor shr 8);
    T2:=Byte(Gradient.StartColor shr 16);

    RGB:=RGBValue(NormalBarColor);

    Gradient.EndColor:=
         (( T0 + Round(tmpRatio*(RGB.Red-T0))) or
         (( T1 + Round(tmpRatio*(RGB.Green-T1)) ) shl 8) or
         (( T2 + Round(tmpRatio*(RGB.Blue-T2)) ) shl 16));

  end
  else Gradient.EndColor:=NormalBarColor;
end;

procedure TCustomBarSeries.DrawValue(ValueIndex:Integer);

  procedure DoDrawBar(Transp:Integer);
  var tmpBlend : TTeeBlend;
  begin
    if Transp>0 then
       tmpBlend:=CreateBlend(Transp)
    else
       tmpBlend:=nil;

    with FBarBounds do
    if YMandatory then
       if Bottom>Top then DrawBar(ValueIndex,Top,Bottom)
                     else DrawBar(ValueIndex,Bottom,Top)
    else
       if Right>Left then DrawBar(ValueIndex,Left,Right)
                     else DrawBar(ValueIndex,Right,Left);

    if Transp>0 then
       ParentChart.Canvas.EndBlending(tmpBlend);
  end;

  procedure CalcShadowBounds;
  begin
    with FBarBounds do
    if YMandatory then
    begin
      Inc(Left,FShadow.HorizSize);
      Inc(Right,FShadow.HorizSize);

      if Bottom>Top then
         Inc(Top,FShadow.VertSize)
      else
         Dec(Bottom,FShadow.VertSize);
    end
    else
    begin
      Inc(Top,FShadow.VertSize);
      Inc(Bottom,FShadow.VertSize);

      if Right>Left then
         Inc(Right,FShadow.HorizSize)
      else
         Dec(Left,FShadow.HorizSize);
    end;
  end;

var Old     : TColor;
    OldRect : TRect;
    tmpP    : TFourPoints;

    {$IFNDEF D5}
    tmpP2   : TPointArray;
    {$ENDIF}
begin
  inherited;

  NormalBarColor:=ValueColor[ValueIndex];

  if NormalBarColor<>clNone then { if not null }
  begin
    CalcBarBounds(ValueIndex);

    if Shadow.Visible and (Shadow.Size<>0) then
    begin
      Old:=BarPen.Color;
      NormalBarColor:=Shadow.Color;
      BarPen.Color:=NormalBarColor;

      OldRect:=FBarBounds;
      CalcShadowBounds;

      if Shadow.Smooth and
         ( (BarStyle=bsRectangle) or
           (BarStyle=bsRectGradient) or
           //(BarStyle=bsCilinder) or
           //(BarStyle=bsSlantCube) or
           (BarStyle=bsBevel) ) then
         if ParentChart.View3D then
            if ParentChart.View3DOptions.Orthogonal then
               Shadow.Draw(ParentChart.Canvas,ParentChart.Canvas.CalcRect3D(OldRect,EndZ))
            else
            begin
              ParentChart.Canvas.FourPointsFromRect(OldRect,EndZ,tmpP);

              {$IFDEF D5}
              Shadow.Draw(ParentChart.Canvas,tmpP);
              {$ELSE}
              SetLength(tmpP2,4);
              tmpP2[0]:=tmpP[0];
              tmpP2[1]:=tmpP[1];
              tmpP2[2]:=tmpP[2];
              tmpP2[3]:=tmpP[3];

              Shadow.Draw(ParentChart.Canvas,tmpP2);
              tmpP2:=nil;
              {$ENDIF}
            end
         else
            Shadow.Draw(ParentChart.Canvas,OldRect)
      else
         DoDrawBar(Shadow.Transparency);

      FBarBounds:=OldRect;

      NormalBarColor:=ValueColor[ValueIndex];
      BarPen.Color:=Old;
    end;

    DoDrawBar(Transparency);
  end;
end;

class Procedure TCustomBarSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
var tmp : TChartSeries;
begin
  With TCustomBarSeries(ASeries) do
  Case Index of
     0: ;
     1: ColorEachPoint:=True;
     2: BarStyle:=bsPyramid;
     3: BarStyle:=bsEllipse;
     4: BarStyle:=bsInvPyramid;
     5: BarStyle:=bsRectGradient;
  else
  begin
    if Assigned(ParentChart) and
       (ParentChart.SeriesCount=1) then
    begin
      FillSampleValues(2);
      tmp:=ParentChart.AddSeries(TChartSeriesClass(ClassType));
      tmp.Name:=GetNewSeriesName(ParentChart.Owner);
      tmp.Title:=''; { <-- force broadcast event to ChartListBox and others }
      tmp.FillsampleValues(2);
      tmp.Marks.Hide;
      (tmp as TCustomBarSeries).BarWidthPercent:=BarWidthPercent;
      Marks.Hide;
      SetSubGallery(tmp,Index);
    end;

    if not SubGalleryStack then { 5.01 }
       Inc(Index,3);

    Case Index of
       6: MultiBar:=mbStacked;
       7: MultiBar:=mbStacked100;
       8: MultiBar:=mbSelfStack;
       9: MultiBar:=mbSide;
      10: MultiBar:=mbSideAll;
    else inherited;
    end;
  end;
  end;
end;

class Procedure TCustomBarSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Colors);
  AddSubChart(TeeMsg_Pyramid);
  AddSubChart(TeeMsg_Ellipse);
  AddSubChart(TeeMsg_InvPyramid);
  AddSubChart(TeeMsg_Gradient);

  if SubGalleryStack then { 5.01 }
  begin
    AddSubChart(TeeMsg_Stack);
    AddSubChart(TeeMsg_Stack100);
    AddSubChart(TeeMsg_SelfStack);
  end;

  AddSubChart(TeeMsg_Sides);
  AddSubChart(TeeMsg_SideAll);
end;

procedure TCustomBarSeries.SetStackGroup(Value: Integer);
begin
  SetIntegerProperty(FStackGroup,Value);
end;

procedure TCustomBarSeries.SetConePercent(const Value: Integer);
begin
  SetIntegerProperty(FConePercent,Value);
end;

class function TCustomBarSeries.SubGalleryStack: Boolean;
begin
  result:=True; { 5.01 }
end;

function TCustomBarSeries.CreateBlend(Transp:Integer): TTeeBlend;
var R  : TRect;
    R1 : TRect;
    R2 : TRect;
begin
  if ParentChart.View3D then
  begin
    R1:=OrientRectangle(ParentChart.Canvas.CalcRect3D(FBarBounds,StartZ));
    R2:=OrientRectangle(ParentChart.Canvas.CalcRect3D(FBarBounds,EndZ));
    UnionRect(R,R1,R2);
  end
  else R:=FBarBounds;

  result:=ParentChart.Canvas.BeginBlending(R,Transp);
end;

procedure TCustomBarSeries.SetTransparency(const Value: TTeeTransparency);
begin
  if FTransparency<>Value then
  begin
    FTransparency:=Value;
    Repaint;
  end;
end;

procedure TCustomBarSeries.DrawBevel;
var tmpR : TRect;
begin
  if ParentChart.View3D and (not ParentChart.View3DOptions.Orthogonal) then
     exit;

  tmpR:=BarBounds;

  if BarPen.Visible then
  begin
    InflateRect(tmpR,-BarPen.Width,-BarPen.Width);

    if ParentChart.View3D and ParentChart.View3DOptions.Orthogonal then
    begin
      Inc(tmpR.Right);
      Inc(tmpR.Bottom);
    end;
  end;

  ParentChart.Canvas.Frame3D(tmpR,ApplyBright(NormalBarColor,DarkerColorQuantity),
                             ApplyDark(NormalBarColor,DarkColorQuantity),BevelSize);
end;

procedure TCustomBarSeries.SetBevelSize(const Value: Integer);
begin
  SetIntegerProperty(FBevelSize,Value);
end;

procedure TCustomBarSeries.SetTickLines(const Value: TChartHiddenPen);
begin
  FTickLines.Assign(Value);
end;

procedure TCustomBarSeries.DrawTickLines(StartPos,EndPos:Integer; AStyle:TBarStyle);
var t : Integer;
begin
  if FTickLines.Visible then
  begin
    ParentChart.Canvas.AssignVisiblePen(FTickLines);
    with MandatoryAxis do
    for t:=0 to Length(Tick)-1 do
        if (Tick[t]>StartPos) and (Tick[t]<EndPos) then
           DrawTickLine(Tick[t],AStyle);
  end;
end;

procedure TCustomBarSeries.AddSampleValues(NumValues: Integer; Sequential:Boolean=False);
var t : Integer;
begin
  if Assigned(ParentChart) then
  with ParentChart do
  for t:=0 to SeriesCount-1 do
  if (Series[t]<>Self) and SameClass(Series[t]) and HasNoMandatoryValues(Series[t]) then
  begin
    inherited;
    break;
  end;

  inherited AddSampleValues(NumValues,True); // 6.02, same sequential "X" 
end;

{ TBarSeries }
Constructor TBarSeries.Create(AOwner:TComponent);
begin
  inherited;
  FGradient.Direction:=gdTopBottom;
  MandatoryValueList.Name:=TeeMsg_ValuesBar;
end;

procedure TBarSeries.CalcSelectionPos(ValueIndex:Integer; out X,Y:Integer);
begin
  inherited;
  Inc(X,(IBarSize shr 1));
end;

{ The horizontal Bar position is the "real" X pos +
  the BarWidth by our BarSeries order }
Function TBarSeries.CalcXPos(ValueIndex:Integer):Integer;
Begin
  if FMultiBar=mbSideAll then
     result:=GetHorizAxis.CalcXPosValue(IPreviousCount+ValueIndex)-(IBarSize shr 1)
  else
  if FMultiBar=mbSelfStack then
     result:=(inherited CalcXPosValue(MinXValue))-(IBarSize shr 1)
  else
  begin
    result:=inherited CalcXPos(ValueIndex);
    if FMultiBar<>mbNone then
       result:=result+Round(IBarSize*((IOrderPos-(INumBars*0.5))-1.0))
    else
       result:=result-(IBarSize shr 1);
  end;

  result:=ApplyBarOffset(result);
End;

Function TBarSeries.MaxXValue:Double;
Begin
  case FMultiBar of
    mbSideAll  : result:=IPreviousCount+Count-1;
    mbSelfStack: result:=MinXValue;
  else result:=inherited MaxXValue;
  end;
end;

Function TBarSeries.MinXValue:Double;
Begin
  if MultiBar=mbSelfStack then
     result:=ParentChart.SeriesList.IndexOf(Self)
  else
     result:=inherited MinXValue;
end;

Function TBarSeries.MaxYValue:Double;
Begin
  result:=MaxMandatoryValue(inherited MaxYValue);
end;

Function TBarSeries.MinYValue:Double;
Begin
  result:=MinMandatoryValue(inherited MinYValue);
end;

Procedure TBarSeries.CalcHorizMargins(var LeftMargin,RightMargin:Integer);
begin
  inherited;
  InternalApplyBarMargin(LeftMargin,RightMargin);
end;

Procedure TBarSeries.CalcVerticalMargins(var TopMargin,BottomMargin:Integer);
var tmp : Integer;
begin
  inherited;

  tmp:=CalcMarkLength(0);

  if tmp>0 then
  begin
    Inc(tmp);

    if FUseOrigin and (inherited MinYValue<FOrigin) then
       if GetVertAxis.Inverted then Inc(TopMargin,tmp) { 4.01 }
                               else Inc(BottomMargin,tmp);

    if (not FUseOrigin) or (inherited MaxYValue>FOrigin) then
       if GetVertAxis.Inverted then Inc(BottomMargin,tmp)
                               else Inc(TopMargin,tmp);
  end;
end;

Function TBarSeries.InternalCalcMarkLength(ValueIndex:Integer):Integer;
Begin
  result:=ParentChart.Canvas.FontHeight;
end;

type
  TSeriesMarksAccess=class {$IFDEF CLR}sealed{$ENDIF} (TSeriesMarks);

Procedure TBarSeries.DrawMark( ValueIndex:Integer; Const St:String;
                               APosition:TSeriesMarkPosition);
var DifW : Integer;
    DifH : Integer;
Begin
  With APosition do
  begin
    DifW:=IBarSize div 2;
    DifH:=Marks.Callout.Length+Marks.Callout.Distance;

    if ArrowFrom.Y>GetOriginPos(ValueIndex) then
    begin
      DifH:=-DifH-Height;
      Inc(ArrowFrom.Y,Marks.Callout.Distance);
    end
    else
      Dec(ArrowFrom.Y,Marks.Callout.Distance);

    Inc(LeftTop.X,DifW);
    Dec(LeftTop.Y,DifH);
    Inc(ArrowTo.X,DifW);
    Dec(ArrowTo.Y,DifH);
    Inc(ArrowFrom.X,DifW);
  end;

  if AutoMarkPosition then
     TSeriesMarksAccess(Marks).AntiOverlap(FirstValueIndex,ValueIndex,APosition);

  inherited;
end;

Procedure TBarSeries.DrawBar(BarIndex,StartPos,EndPos:Integer);
var tmpMidX : Integer;
    tmpMidY : Integer;
    tmp     : TBarStyle;
    Old     : Integer;
begin
  SetPenBrushBar(NormalBarColor,BarIndex);

  tmp:=GetBarStyle(BarIndex);

  With ParentChart,Canvas,BarBounds do
  begin
    tmpMidX:=(Left+Right) div 2;

    if View3D then
    Case tmp of
      bsRectangle,
      bsRectGradient,
      bsBevel      : Cube(Left,Right,StartPos,EndPos,StartZ,EndZ,FDark3D);
      bsPyramid    : Pyramid(True,Left,StartPos,Right,EndPos,StartZ,EndZ,FDark3D);
      bsInvPyramid : Pyramid(True,Left,EndPos,Right,StartPos,StartZ,EndZ,FDark3D);
      bsCylinder   : Cylinder(True,Left,Top,Right,Bottom,StartZ,EndZ,FDark3D);
      bsEllipse    : EllipseWithZ(Left,Top,Right,Bottom,MiddleZ);
      bsArrow      : Arrow(True, TeePoint(tmpMidX,EndPos),
                               TeePoint(tmpMidX,StartPos),
                               Right-Left,(Right-Left) div 2,MiddleZ);
      bsInvArrow   : Arrow(True, TeePoint(tmpMidX,StartPos),
                                 TeePoint(tmpMidX,EndPos),
                                 Right-Left,(Right-Left) div 2,MiddleZ);
      bsCone       : Cone(True,Left,StartPos,Right,EndPos,StartZ,EndZ,FDark3D,ConePercent);
      bsInvCone    : Cone(True,Left,EndPos,Right,StartPos,StartZ,EndZ,FDark3D,ConePercent);
      bsSlantCube  :
        begin
           Old:=TeeNumCylinderSides;
           TeeNumCylinderSides:=4;
           Cylinder(True,Left,Top,Right,Bottom,StartZ,EndZ,FDark3D);
           TeeNumCylinderSides:=Old;
        end;
      bsDiamond    : begin
                        tmpMidY:=(StartPos+EndPos) div 2;
                        PolygonWithZ([TeePoint(tmpMidX,StartPos),
                                 TeePoint(Right,tmpMidY),
                                 TeePoint(tmpMidX,EndPos),
                                 TeePoint(Left,tmpMidY)],MiddleZ);
                     end;
    end
    else
    Case tmp of
      bsRectangle,
      bsRectGradient,
      bsBevel,
      bsCylinder   : BarRectangle(NormalBarColor,Left,Top,Right,Bottom);
      bsPyramid,
      bsCone       : Polygon([ TeePoint(Left,EndPos),
                               TeePoint(tmpMidX,StartPos),
                               TeePoint(Right,EndPos) ]);
      bsInvPyramid,
      bsInvCone    : Polygon([ TeePoint(Left,StartPos),
                               TeePoint(tmpMidX,EndPos),
                               TeePoint(Right,StartPos) ]);
      bsEllipse    : Ellipse(BarBounds);
      bsArrow      : Arrow(True, TeePoint(tmpMidX,EndPos),
                                 TeePoint(tmpMidX,StartPos),
                                 Right-Left,(Right-Left) div 2,MiddleZ);
      bsInvArrow      : Arrow(True, TeePoint(tmpMidX,StartPos),
                                 TeePoint(tmpMidX,EndPos),
                                 Right-Left,(Right-Left) div 2,MiddleZ);
      bsSlantCube    :
        begin
          BarRectangle(NormalBarColor,Left,Top,Right,Bottom);
          DoVertLine(tmpMidX,Top,Bottom);
        end;
      bsDiamond    : begin
                        tmpMidY:=(StartPos+EndPos) div 2;
                        Polygon([TeePoint(tmpMidX,StartPos),
                                 TeePoint(Right,tmpMidY),
                                 TeePoint(tmpMidX,EndPos),
                                 TeePoint(Left,tmpMidY)]);
                     end;
    end;

    if tmp=bsRectGradient then
       BarGradient(BarIndex,TeeRect(Left,StartPos,Right,EndPos))
    else
    if tmp=bsBevel then DrawBevel;

  end;

  DrawTickLines(StartPos,EndPos,tmp);
end;

Procedure TBarSeries.DrawTickLine(TickPos:Integer; AStyle:TBarStyle);
var tmp : Integer;
    P0,
    P1,
    P2 : TPoint;
begin
  case AStyle of
    bsRectangle,
    bsRectGradient,
    bsBevel: ParentChart.Canvas.HorizLine3D(BarBounds.Left,BarBounds.Right,TickPos,StartZ);
    bsArrow:
    begin
      tmp:=(BarBounds.Right-BarBounds.Left) div 4;
      ParentChart.Canvas.HorizLine3D(BarBounds.Left+tmp,BarBounds.Right-tmp,TickPos,MiddleZ);
    end;
  end;

  if ParentChart.View3D then
  case AStyle of
    bsRectangle,
    bsRectGradient,
    bsBevel:
      begin
        P0:=ParentChart.Canvas.Calculate3DPosition(BarBounds.BottomRight,StartZ);
        P1:=ParentChart.Canvas.Calculate3DPosition(BarBounds.BottomRight,EndZ);
        P2:=ParentChart.Canvas.Calculate3DPosition(TeePoint(BarBounds.Right,BarBounds.Top),EndZ);
        if TeeCull(P0,P1,P2) then
        begin
          P0:=ParentChart.Canvas.Calculate3DPosition(TeePoint(BarBounds.Left,BarBounds.Bottom),StartZ);
          P1:=ParentChart.Canvas.Calculate3DPosition(TeePoint(BarBounds.Left,BarBounds.Bottom),EndZ);
          P2:=ParentChart.Canvas.Calculate3DPosition(TeePoint(BarBounds.Left,BarBounds.Top),EndZ);
          if TeeCull(P0,P1,P2) then
             ParentChart.Canvas.ZLine3D(BarBounds.Left,TickPos,StartZ,EndZ)
        end
        else
           ParentChart.Canvas.ZLine3D(BarBounds.Right,TickPos,StartZ,EndZ);
      end;
  end;
end;

procedure TBarSeries.CalcBarBounds(ValueIndex:Integer);

  function PenWidth:Integer;
  begin
    if Pen.Visible then result:=Max(1,Pen.Width)
                   else result:=0;
  end;

begin
  with FBarBounds do
  Begin
    Left:=CalcXPos(ValueIndex);

    if (BarWidthPercent=100) and (FCustomBarSize=0) and (FMultiBar<>mbSelfStack) then
    begin
      if GetHorizAxis.Inverted then
         if ValueIndex>0 then
            Right:=CalcXPos(Pred(ValueIndex))
         else
            Right:=Left+IBarSize+PenWidth
      else
         if ValueIndex<Count-1 then
            Right:=CalcXPos(Succ(ValueIndex))+1-(PenWidth div 2)
         else
            Right:=Left+IBarSize+1-(PenWidth div 2);
    end
    else
       Right:=Left+IBarSize+1;  // 5.02

    Top   :=CalcYPos(ValueIndex);
    Bottom:=GetOriginPos(ValueIndex);

    if not BarPen.Visible then
    begin
      if Bottom>Top then
         Inc(Bottom)
      else
         Inc(Top);

      Inc(Right);
    end;
  end;
end;

Function TBarSeries.CalcYPos(ValueIndex:Integer):Integer;
var tmp      : Double;
    tmpValue : Double;
Begin
  Case FMultiBar of
    mbNone,mbSide,mbSideAll: result:=inherited CalcYPos(ValueIndex)
  else
  begin
    tmpValue:=YValues.Value[ValueIndex]+PointOrigin(ValueIndex,False);
    if (FMultiBar=mbStacked) or (FMultiBar=mbSelfStack) then
       result:=CalcYPosValue(tmpValue)
    else
    begin
      tmp:=PointOrigin(ValueIndex,True);
      if tmp<>0 then result:=CalcYPosValue(tmpValue*100.0/tmp)
                else result:=0;
    end;
  end;
  end;
End;

Function TBarSeries.GetOriginPos(ValueIndex:Integer):Integer;
Begin
  result:=InternalGetOriginPos(ValueIndex,GetVertAxis.IEndPos);
end;

Function TBarSeries.InternalClicked(ValueIndex:Integer; P:TPoint):Boolean;
var tmpX : Integer;

  Function InTriangle(Y1,Y2:Integer):Boolean;
  var TriP : TTrianglePoints;
  begin
    if ParentChart.View3D then
    begin
      with ParentChart.Canvas do
      begin
        TriP[0]:=Calculate3DPosition(tmpX,Y1,StartZ);
        TriP[1]:=Calculate3DPosition(tmpX+(IBarSize div 2),Y2,MiddleZ);
        TriP[2]:=Calculate3DPosition(tmpX+IBarSize,Y1,StartZ);
      end;
      result:=PointInPolygon(P,TriP);
    end
    else result:=PointInTriangle(P,tmpX,tmpX+IBarSize,Y1,Y2);
  end;

var tmpY : Integer;
    endY : Integer;

  Function OtherClicked:Boolean;
  begin
    if BarStyle=bsEllipse then
       result:=PointInEllipse(P,tmpX,tmpY,tmpX+IBarSize,endY)
    else
       result:=(P.Y>=tmpY) and (P.Y<=endY);
  end;

begin
  result:=False;
  tmpX:=CalcXPos(ValueIndex);

  if (not ParentChart.View3D) and
     ((P.X<tmpX) or (P.X>(tmpX+IBarSize))) then exit;

  tmpY:=CalcYPos(ValueIndex);
  endY:=GetOriginPos(ValueIndex);
  if endY<tmpY then SwapInteger(tmpY,endY);

  Case BarStyle of
   bsInvPyramid,
      bsInvCone : result:=InTriangle(tmpY,endY);
      bsPyramid,
      bsCone    : result:=InTriangle(endY,tmpY);
   else
     if ParentChart.View3D then
     begin
       ParentChart.Canvas.Calculate2DPosition(P.X,P.Y,StartZ);
       if ((P.X>=tmpX) and (P.X<=(tmpX+IBarSize))) then
          result:=OtherClicked;
     end
     else result:=OtherClicked;
   end;
end;

Function TBarSeries.MoreSameZOrder:Boolean;
begin
  if FMultiBar=mbSideAll then result:=False
                         else result:=inherited MoreSameZOrder;
end;

Function TBarSeries.DrawSeriesForward(ValueIndex:Integer):Boolean;
begin
  Case FMultiBar of
    mbNone,
    mbSide,
    mbSideAll: result:=inherited DrawSeriesForward(ValueIndex);
    mbStacked,
    mbSelfStack:
               begin
                 result:=YValues.Value[ValueIndex]>=YOrigin; { 5.01 }
                 if GetVertAxis.Inverted then result:=not result;
               end;
  else
    result:=(not GetVertAxis.Inverted);
  end;
end;

{ THorizBarSeries }
Constructor THorizBarSeries.Create(AOwner:TComponent);
begin
  inherited;
  SetHorizontal;
  XValues.Order:=loNone;
  YValues.Order:=loAscending;
  FGradient.Direction:=gdLeftRight;
  MandatoryValueList.Name:=TeeMsg_ValuesBar;
end;

Procedure THorizBarSeries.CalcHorizMargins(var LeftMargin,RightMargin:Integer);
var tmp : Integer;
begin
  inherited;
  tmp:=CalcMarkLength(TeeAllValues);
  if tmp>0 then Inc(tmp);
  if (FUseOrigin and (inherited MinXValue<FOrigin)) then
     Inc(LeftMargin,tmp);
  if (not FUseOrigin) or (inherited MaxXValue>FOrigin) then
     if GetHorizAxis.Inverted then Inc(LeftMargin,tmp)
                              else Inc(RightMargin,tmp);
end;

Procedure THorizBarSeries.CalcVerticalMargins(var TopMargin,BottomMargin:Integer);
begin
  inherited;
  InternalApplyBarMargin(TopMargin,BottomMargin);
end;

procedure THorizBarSeries.CalcSelectionPos(ValueIndex:Integer; out X,Y:Integer);
begin
  inherited;
  Inc(Y,(IBarSize shr 1));
end;

Function THorizBarSeries.CalcXPos(ValueIndex:Integer):Integer;
var tmp      : Double;
    tmpValue : Double;
Begin
  if (FMultiBar=mbNone) or (FMultiBar=mbSide) or (FMultiBar=mbSideAll) then
     result:=inherited CalcXPos(ValueIndex)
  else
  begin
    tmpValue:=XValues.Value[ValueIndex]+PointOrigin(ValueIndex,False);
    if (FMultiBar=mbStacked) or (FMultiBar=mbSelfStack) then
       result:=CalcXPosValue(tmpValue)
    else
    begin
      tmp:=PointOrigin(ValueIndex,True);
      if tmp<>0 then result:=CalcXPosValue(tmpValue*100.0/tmp)
                else result:=0;
    end;
  end;
End;

Function THorizBarSeries.GetOriginPos(ValueIndex:Integer):Integer;
Begin
  result:=InternalGetOriginPos(ValueIndex,GetHorizAxis.IStartPos);
end;

{ The vertical Bar position is the "real" Y pos +
  the Barwidth by our BarSeries order }
Function THorizBarSeries.CalcYPos(ValueIndex:Integer):Integer;
Begin
  if FMultiBar=mbSideAll then
     result:=GetVertAxis.CalcYPosValue(IPreviousCount+ValueIndex)-(IBarSize shr 1)
  else
  if FMultiBar=mbSelfStack then
     result:=(inherited CalcYPosValue(MinYValue))-(IBarSize shr 1)
  else
  begin
    result:=inherited CalcYPos(ValueIndex);

    if FMultiBar<>mbNone then
       result:=result+Round(IBarSize*( ((INumBars*0.5)-(1+INumBars-IOrderPos)) ))
    else
       result:=result-(IBarSize shr 1);
  end;

  result:=ApplyBarOffset(result);
end;

Function THorizBarSeries.InternalClicked(ValueIndex:Integer; P:TPoint):Boolean;
var tmpY : Integer;

  Function InTriangle(X1,X2:Integer):Boolean;
  var TriP : TTrianglePoints;
  begin
    if ParentChart.View3D then
    begin
      with ParentChart.Canvas do
      begin
        TriP[0]:=Calculate3DPosition(X1,tmpY,StartZ);
        TriP[1]:=Calculate3DPosition(X2,tmpY+(IBarSize div 2),MiddleZ);
        TriP[2]:=Calculate3DPosition(X1,tmpY+IBarSize,StartZ);
      end;
      result:=PointInPolygon(P,TriP);
    end
    else result:=PointInHorizTriangle(P,tmpY,tmpY+IBarSize,X1,X2);
  end;

var tmpX : Integer;
    endX : Integer;

  Function OtherClicked:Boolean;
  begin
    if BarStyle=bsEllipse then
       result:=PointInEllipse(P,tmpX,tmpY,endX,tmpY+IBarSize)
    else
       result:=(P.X>=tmpX) and (P.X<=endX);
  end;

begin
  result:=False;

  tmpY:=CalcYPos(ValueIndex);

  if (not ParentChart.View3D) and
     ((P.Y<tmpY) or (P.Y>(tmpY+IBarSize))) then exit;

  tmpX:=CalcXPos(ValueIndex);
  endX:=GetOriginPos(ValueIndex);
  if endX<tmpX then SwapInteger(tmpX,endX);

  Case FBarStyle of
   bsInvPyramid,
      bsInvCone : result:=InTriangle(endX,tmpX);
      bsPyramid,
      bsCone    : result:=InTriangle(tmpX,endX);
   else
     if ParentChart.View3D then
     begin
       ParentChart.Canvas.Calculate2DPosition(P.X,P.Y,StartZ);
       if ((P.Y>=tmpY) and (P.Y<=(tmpY+IBarSize))) then
          result:=OtherClicked;
     end
     else result:=OtherClicked;
  end;
end;

Function THorizBarSeries.MaxXValue:Double;
Begin
  result:=MaxMandatoryValue(inherited MaxXValue);
end;

Function THorizBarSeries.MinXValue:Double;
Begin
  result:=MinMandatoryValue(inherited MinXValue);
end;

Function THorizBarSeries.MaxYValue:Double;
Begin
  case FMultiBar of
    mbSideAll  : result:=IPreviousCount+Count-1;
    mbSelfStack: result:=MinYValue;
  else result:=inherited MaxYValue;
  end;
end;

Function THorizBarSeries.InternalCalcMarkLength(ValueIndex:Integer):Integer;
Begin
  if ValueIndex=TeeAllValues then result:=MaxMarkWidth
                             else result:=TSeriesMarksAccess(Marks).TextWidth(ValueIndex);
end;

Procedure THorizBarSeries.DrawMark( ValueIndex:Integer; Const St:String;
                                    APosition:TSeriesMarkPosition);
var DifH : Integer;
    DifW : Integer;
    tmp  : Boolean;
Begin
  With APosition do
  begin
    DifH:=IBarSize div 2;
    DifW:=Marks.Callout.Length+Marks.Callout.Distance;
    tmp:=ArrowFrom.X<GetOriginPos(ValueIndex);
    if tmp then DifW:=-DifW-Width;

    Inc(LeftTop.X,DifW+(Width div 2));
    Inc(LeftTop.Y,DifH+(Height div 2));
    Inc(ArrowTo.X,DifW);
    Inc(ArrowTo.Y,DifH);
    Inc(ArrowFrom.Y,DifH);

    if tmp then
       Dec(ArrowFrom.X,Marks.Callout.Distance)
    else
       Inc(ArrowFrom.X,Marks.Callout.Distance);
  end;

  inherited;
end;

Procedure THorizBarSeries.DrawBar(BarIndex,StartPos,EndPos:Integer);
var tmpMidY : Integer;
    tmpMidX : Integer;
    tmp     : TBarStyle;
    Old     : Integer;
Begin
  SetPenBrushBar(NormalBarColor,BarIndex);

  tmp:=GetBarStyle(BarIndex);

  With ParentChart,Canvas,BarBounds do
  begin
    tmpMidY:=(Top+Bottom) div 2;

    if View3D then
    Case tmp of
      bsRectangle,
      bsRectGradient,
      bsBevel      : Cube(StartPos,EndPos,Top,Bottom,StartZ,EndZ,FDark3D);
      bsPyramid    : Pyramid(False,StartPos,Top,EndPos,Bottom,StartZ,EndZ,FDark3D);
      bsInvPyramid : Pyramid(False,EndPos,Top,StartPos,Bottom,StartZ,EndZ,FDark3D);
      bsCylinder   : Cylinder(False,Left,Top,Right,Bottom,StartZ,EndZ,FDark3D);
      bsEllipse    : EllipseWithZ(Left,Top,Right,Bottom,MiddleZ);
      bsArrow      : Arrow(True, TeePoint(StartPos,tmpMidY),
                                 TeePoint(EndPos,tmpMidY),
                                 Bottom-Top,
                                 (Bottom-Top) div 2,MiddleZ);
      bsInvArrow   : Arrow(True, TeePoint(EndPos,tmpMidY),
                                 TeePoint(StartPos,tmpMidY),
                                 Bottom-Top,
                                 (Bottom-Top) div 2,MiddleZ);
      bsCone       : Cone(False,StartPos,Top,EndPos,Bottom,StartZ,EndZ,FDark3D,ConePercent);
      bsInvCone    : Cone(False,EndPos,Top,StartPos,Bottom,StartZ,EndZ,FDark3D,ConePercent);
      bsSlantCube  :
        begin
           Old:=TeeNumCylinderSides;
           TeeNumCylinderSides:=4;
           Cylinder(False,Left,Top,Right,Bottom,StartZ,EndZ,FDark3D);
           TeeNumCylinderSides:=Old;
        end;
      bsDiamond    : begin
                        tmpMidX:=(StartPos+EndPos) div 2;
                        PolygonWithZ([TeePoint(StartPos,tmpMidY),
                                 TeePoint(tmpMidX,Top),
                                 TeePoint(EndPos,tmpMidY),
                                 TeePoint(tmpMidX,Bottom)],MiddleZ);
                     end;
    end
    else
    Case tmp of
      bsRectangle,
      bsRectGradient,
      bsBevel,
      bsCylinder   : BarRectangle(NormalBarColor,Left,Top,Right,Bottom);
      bsPyramid,
      bsCone       : Polygon([ TeePoint(StartPos,Top),
                               TeePoint(EndPos,tmpMidY),
                               TeePoint(StartPos,Bottom) ]);
      bsInvPyramid,
      bsInvCone    : Polygon([ TeePoint(EndPos,Top),
                               TeePoint(StartPos,tmpMidY),
                               TeePoint(EndPos,Bottom) ]);
      bsEllipse    : Ellipse(BarBounds);
      bsArrow      : Arrow(True, TeePoint(StartPos,tmpMidY),
                                 TeePoint(EndPos,tmpMidY),
                                 Bottom-Top,
                                 (Bottom-Top) div 2,MiddleZ);
      bsInvArrow      : Arrow(True, TeePoint(EndPos,tmpMidY),
                                 TeePoint(StartPos,tmpMidY),
                                 Bottom-Top,
                                 (Bottom-Top) div 2,MiddleZ);
      bsSlantCube  :
        begin
          BarRectangle(NormalBarColor,Left,Top,Right,Bottom);
          DoHorizLine(Left,Right,tmpMidY);
        end;
      bsDiamond    : begin
                        tmpMidX:=(StartPos+EndPos) div 2;
                        Polygon([TeePoint(StartPos,tmpMidY),
                                 TeePoint(tmpMidX,Top),
                                 TeePoint(EndPos,tmpMidY),
                                 TeePoint(tmpMidX,Bottom)]);
                     end;
    end;

    if tmp=bsRectGradient then
       BarGradient(BarIndex,TeeRect(StartPos,Top,EndPos,Bottom))
    else
    if tmp=bsBevel then DrawBevel;

  end;

  DrawTickLines(StartPos,EndPos,tmp);
end;

procedure THorizBarSeries.CalcBarBounds(ValueIndex:Integer);

  function PenWidth:Integer;
  begin
    if Pen.Visible then result:=Pen.Width
                   else result:=0;
  end;

begin
  with FBarBounds do
  Begin
    Top:=CalcYPos(ValueIndex);

    if (BarWidthPercent=100) and (FCustomBarSize=0) and (FMultiBar<>mbSelfStack) then
    begin
      if GetVertAxis.Inverted then
         if ValueIndex<Count-1 then
            Bottom:=CalcYPos(Succ(ValueIndex))
         else
            Bottom:=Top+IBarSize-PenWidth
      else
         if ValueIndex>0 then
            Bottom:=CalcYPos(Pred(ValueIndex))
         else
            Bottom:=Top+IBarSize-PenWidth
    end
    else
       Bottom:=Top+IBarSize-1;  // 5.02

    Right:=CalcXPos(ValueIndex);
    Left:=GetOriginPos(ValueIndex);

    if not BarPen.Visible then
    begin
      if Right>Left then
         Inc(Right)
      else
      begin
        Inc(Left);
        Dec(Right);
      end;

      Inc(Bottom); // 5.02
    end;
  end;
end;

(*
procedure THorizBarSeries.DrawValue(ValueIndex:Integer);
var tmpBlend : TTeeBlend;
Begin
  inherited;
  NormalBarColor:=ValueColor[ValueIndex];

  if NormalBarColor<>clNone then  { <-- if not null }
  begin
    CalcBarBounds(ValueIndex);

    if Transparency>0 then
       tmpBlend:=CreateBlend(Transparency)
    else
       tmpBlend:=nil;

    with FBarBounds do
    if Right>Left then DrawBar(ValueIndex,Left,Right)
                  else DrawBar(ValueIndex,Right,Left);

    if Transparency>0 then
       ParentChart.Canvas.EndBlending(tmpBlend);
  end;
end;
*)

Function THorizBarSeries.DrawSeriesForward(ValueIndex:Integer):Boolean;
begin
  Case FMultiBar of
    mbNone   : result:=inherited DrawSeriesForward(ValueIndex);
    mbSide,
    mbSideAll: result:=False;
    mbStacked,
    mbSelfStack:
               begin
                 result:=MandatoryValueList.Value[ValueIndex]>=0; { 5.01 }
                 if GetHorizAxis.Inverted then result:=not result;
               end;
  else
    result:=not GetHorizAxis.Inverted;
  end;
end;

function THorizBarSeries.MinYValue: Double;
begin
  if MultiBar=mbSelfStack then
     result:=ParentChart.SeriesList.IndexOf(Self)
  else
     result:=inherited MinYValue;
end;

procedure THorizBarSeries.DrawTickLine(TickPos: Integer; AStyle:TBarStyle);
var tmp : Integer;
    P0,
    P1,
    P2 : TPoint;
begin
  case AStyle of
    bsRectangle,
    bsRectGradient,
    bsBevel: ParentChart.Canvas.VertLine3D(TickPos,BarBounds.Top,BarBounds.Bottom,StartZ);
    bsArrow:
    begin
      tmp:=(BarBounds.Bottom-BarBounds.Top) div 4;
      ParentChart.Canvas.VertLine3D(TickPos,BarBounds.Top+tmp,BarBounds.Bottom-tmp,MiddleZ);
    end;
  end;

  if ParentChart.View3D then
  case AStyle of
    bsRectangle,
    bsRectGradient,
    bsBevel:
      begin
        P0:=ParentChart.Canvas.Calculate3DPosition(BarBounds.TopLeft,StartZ);
        P1:=ParentChart.Canvas.Calculate3DPosition(BarBounds.TopLeft,EndZ);
        P2:=ParentChart.Canvas.Calculate3DPosition(TeePoint(BarBounds.Top,BarBounds.Right),EndZ);
        if TeeCull(P0,P1,P2) then
        begin
          P0:=ParentChart.Canvas.Calculate3DPosition(TeePoint(BarBounds.Left,BarBounds.Bottom),StartZ);
          P1:=ParentChart.Canvas.Calculate3DPosition(TeePoint(BarBounds.Left,BarBounds.Bottom),EndZ);
          P2:=ParentChart.Canvas.Calculate3DPosition(BarBounds.BottomRight,EndZ);
          if TeeCull(P0,P1,P2) then
             ParentChart.Canvas.ZLine3D(TickPos,BarBounds.Top,StartZ,EndZ)
        end
        else
           ParentChart.Canvas.ZLine3D(TickPos,BarBounds.Bottom,StartZ,EndZ);
      end;

//    ParentChart.Canvas.ZLine3D(TickPos,BarBounds.Top,StartZ,EndZ);
  end;
end;

{ TCircledSeries }
Constructor TCircledSeries.Create(AOwner: TComponent);
begin
  inherited;

  CalcVisiblePoints:=False; { always draw all points }
  XValues.Name:=TeeMsg_ValuesAngle;

  FCircleBackColor:=clTeeColor;
  FCircleGradient:=TChartGradient.Create(CanvasChanged);

  FShadow:=TCircledShadow.Create(CanvasChanged);
  FShadow.InitValues(Tee_CircledShadowColor,3);
end;

Destructor TCircledSeries.Destroy;
begin
  FShadow.Free;
  FCircleGradient.Free;
  SetParentProperties(True);
  FreeAndNil(IBack3D);
  inherited;
end;

procedure TCircledSeries.SetCircled(Value:Boolean);
var t : Integer;
Begin
  SetBooleanProperty(FCircled,Value);
  if Assigned(ParentChart) then
  with ParentChart do
  for t:=0 to SeriesCount-1 do
    if Self is Series[t].ClassType then
      With TCircledSeries(Series[t]) do
      begin
        FCircled:=Value;
        if not (csLoading in ComponentState) then
        begin
          FCustomXRadius:=0;
          FCustomYRadius:=0;
        end;
      end;
end;

Procedure TCircledSeries.SetRotationAngle(const Value:Integer);
Begin
  SetIntegerProperty(FRotationAngle,Value mod 360);
  IRotDegree:=FRotationAngle*PiDegree;
end;

procedure TCircledSeries.SetOtherCustomRadius(IsXRadius:Boolean; Value:Integer);
var t : Integer;
Begin
  if Assigned(ParentChart) then
  with ParentChart do
  for t:=0 to SeriesCount-1 do
  With TCircledSeries(Series[t]) do
    if Self is ClassType then
       if IsXRadius then FCustomXRadius:=Value
                    else FCustomYRadius:=Value;
end;

Function TCircledSeries.UseAxis:Boolean;
begin
  result:=False;
end;

procedure TCircledSeries.SetCustomXRadius(Value:Integer);
Begin
  SetIntegerProperty(FCustomXRadius,Value);
  SetOtherCustomRadius(True,Value);
End;

procedure TCircledSeries.SetCustomYRadius(Value:Integer);
Begin
  SetIntegerProperty(FCustomYRadius,Value);
  SetOtherCustomRadius(False,Value);
End;

Procedure TCircledSeries.SetShadow(const Value:TCircledShadow);
begin
  FShadow.Assign(Value)
end;

Procedure TCircledSeries.SetParentProperties(EnableParentProps:Boolean);
begin
  if Assigned(ParentChart) then
  With ParentChart do
  if (not (csDestroying in ComponentState)) and
     (not Canvas.SupportsFullRotation) and
      Assigned(View3DOptions) then
  begin
    if EnableParentProps and
      ((not Active) or (csDestroying in Self.ComponentState)) { 5.02 }
         then
           SetBackupProperties
    else
    if not Assigned(IBack3D) then
    begin
      IBack3D:=TView3DOptions.Create({$IFDEF TEEVCL}ParentChart{$ENDIF});
      IBack3D.Assign(View3DOptions);
      InitCustom3DOptions;
    end;
  end;
end;

Procedure TCircledSeries.InitCustom3DOptions;
begin
  // Nothing
end;

Procedure TCircledSeries.SetBackupProperties;
begin
  if Assigned(ParentChart) then
  begin
    ParentChart.View3DOptions.Assign(IBack3D);
    FreeAndNil(IBack3D);
  end;
end;

Procedure TCircledSeries.SetParentChart(Const Value:TCustomAxisPanel);
Begin
  if Value=nil then SetBackupProperties;

  if Value<>ParentChart then
  begin
    inherited;
    if Assigned(ParentChart) then SetParentProperties(False);
  end;
end;

Procedure TCircledSeries.Rotate(const Angle:Integer);
Begin
  RotationAngle:=(RotationAngle+Angle) mod 360;
End;

Function TCircledSeries.AssociatedToAxis(Axis:TChartAxis):Boolean;
Begin
  result:=True;
end;

Procedure TCircledSeries.AdjustCircleRect;
Begin
  with FCircleRect do
  Begin
    if Odd(Right-Left) then Dec(Right);
    if Odd(Bottom-Top) then Dec(Bottom);
    if (Right-Left)<4 then Right:=Left+4;
    if (Bottom-Top)<4 then Bottom:=Top+4;
    FCircleWidth  :=Right-Left;
    FCircleHeight :=Bottom-Top;
  end;

  RectCenter(FCircleRect,FCircleXCenter,FCircleYCenter);
End;

// If there's another Circled series in Chart,
// adjusts the circle rectangle using all series.
Procedure TCircledSeries.CheckOtherSeriesMarks; // 6.02, 5.03
var t : Integer;
    tmp : TChartSeries;
begin
  if Assigned(ParentChart) then
  with ParentChart do
  for t:=0 to SeriesCount-1 do
  begin
    tmp:=Series[t];

    if tmp.Active and SameClass(tmp) and tmp.Marks.Visible then
    begin
      if t>SeriesList.IndexOf(Self) then
         TSeriesAccess(tmp).DoBeforeDrawValues;

      Self.FCircleRect:=TCircledSeries(tmp).CircleRect;
      AdjustCircleRect;
      CalcRadius;
      break;
    end;
  end;
end;

class Procedure TCircledSeries.AdjustScreenRatio(ACanvas:TCanvas3D;
             AXRadius,AYRadius:Integer; var R:TRect);

    function AdjustRatio(Const ARatio:Double):Double;
    var tmpRatio : Double;
    begin
      tmpRatio:=ScreenRatio(ACanvas);
      if tmpRatio=0 then result:=ARatio
                    else result:=1.0*ARatio/tmpRatio;
    end;

var Ratio : Double;
    Dif   : Integer;
begin
  Ratio:=AdjustRatio(Screen.Width/Screen.Height);

  if Round(Ratio*AYRadius)<AXRadius then
  Begin
    dif:=(AXRadius-Round(Ratio*AYRadius));
    Inc(R.Left,Dif);
    Dec(R.Right,Dif);
  end
  else
  Begin
    dif:=(AYRadius-Round(1.0*AXRadius/Ratio));
    Inc(R.Top,Dif);
    Dec(R.Bottom,Dif);
  end;
end;

Procedure TCircledSeries.DoBeforeDrawValues;

  Procedure CalcCircledRatio;
  Begin
    CalcRadius;
    AdjustScreenRatio(ParentChart.Canvas,FXRadius,FYRadius,FCircleRect);
    AdjustCircleRect;
  end;

  Procedure AdjustCircleMarks;
  var tmpH     : Integer;
      tmpW     : Integer;
      tmpFrame : Integer;
  begin
    tmpFrame:=Marks.Callout.Length;

    With Marks.Frame do if Visible then Inc(tmpFrame,2*Width);

    With ParentChart do
    Begin
      Canvas.AssignFont(Marks.Font);
      tmpH:=Canvas.FontHeight+tmpFrame;
      Inc(FCircleRect.Top,tmpH);
      Dec(FCircleRect.Bottom,tmpH);
      tmpW:=MaxMarkWidth+Canvas.TextWidth(TeeCharForHeight)+tmpFrame;
      Inc(FCircleRect.Left,tmpW);
      Dec(FCircleRect.Right,tmpW);
      AdjustCircleRect;
    end;
  end;

begin
  inherited;
  FCircleRect:=ParentChart.ChartRect;
  AdjustCircleRect;

  if Marks.Visible then AdjustCircleMarks
                   else CheckOtherSeriesMarks;

  if FCircled then CalcCircledRatio;
  CalcRadius;
end;

Procedure TCircledSeries.CalcRadius;
Begin
  if CustomXRadius<>0 then
  Begin
    FXRadius:=CustomXRadius;
    FCircleWidth:=2*FXRadius;
  end
  else FXRadius:=FCircleWidth shr 1;

  if CustomYRadius<>0 then
  begin
    FYRadius:=CustomYRadius;
    FCircleHeight:=2*FYRadius;
  end
  else FYRadius:=FCircleHeight shr 1;

  With FCircleRect do
  begin
    Left  :=FCircleXCenter-FXRadius;
    Right :=FCircleXCenter+FXRadius;
    Top   :=FCircleYCenter-FYRadius;
    Bottom:=FCircleYCenter+FYRadius;
  end;
end;

procedure TCircledSeries.SetCircleBackColor(Value:TColor);
begin
  SetColorProperty(FCircleBackColor,Value);
end;

Procedure TCircledSeries.AngleToPos( Const Angle,AXRadius,AYRadius:Double;
                                     out X,Y:Integer);
var tmpSin : Extended;
    tmpCos : Extended;
Begin
  SinCos(IRotDegree+Angle,tmpSin,tmpCos);
  X:=FCircleXCenter+Round(AXRadius*tmpCos);
  Y:=FCircleYCenter-Round(AYRadius*tmpSin);
end;

Function TCircledSeries.CalcCircleBackColor:TColor;
begin
  result:=FCircleBackColor;
  if result=clTeeColor then
     if ParentChart.Printing then result:=clWhite
     else
     With (ParentChart as TCustomChart).BackWall do
        if not Transparent then result:=Color;

  if result=clTeeColor then result:=ParentChart.Color;
end;

Procedure TCircledSeries.PrepareLegendCanvas( ValueIndex:Integer; var BackColor:TColor;
                                              var BrushStyle:TBrushStyle);
Begin
  BackColor:=CalcCircleBackColor;
end;

Function TCircledSeries.PointToAngle(x,y:Integer):Double;
begin
  if (x-FCircleXCenter)=0 then
  begin
    if y>FCircleYCenter then result:=-0.5*Pi{1.5*pi}
                        else result:=0.5*Pi;
  end
  else
  if (FXRadius=0) or (FYRadius=0) then result:=0 // 6.01
  else
    result:=ArcTan2( ((FCircleYCenter-y)/FYRadius),
                     ((x-FCircleXCenter)/FXRadius));

  if result<0 then result:=2.0*Pi+result;
  result:=result-IRotDegree;
  if result<0 then result:=2.0*Pi+result;
end;

Function TCircledSeries.PointToRadius(x,y: Integer): double; // 7.02
var dx,dy,tmp: double;
begin
  With GetVertAxis do
  begin
    tmp := Maximum - Minimum;
    if tmp <> 0.0 then
    begin
      dx := x-FCircleXCenter;
      dx := dx*tmp/FXRadius;
      dy := y-FCircleYCenter;
      dy := dy*tmp/FYRadius;
      Result := Sqrt(dx*dx+dy*dy)+Minimum;
    end
    else Result := 0.0;
  end;
end;

Procedure TCircledSeries.Assign(Source:TPersistent);
begin
  if Source is TCircledSeries then
  With TCircledSeries(Source) do
  begin
    Self.FCircled         := FCircled;
    Self.RotationAngle    := FRotationAngle;  // 7.0

    Self.FCustomXRadius   := CustomXRadius;
    Self.FCustomYRadius   := CustomYRadius;
    Self.FCircleBackColor := FCircleBackColor;
    Self.CircleGradient   := FCircleGradient;
    Self.Shadow           := Shadow;
  end;

  inherited;
end;

Procedure TCircledSeries.SetActive(Value:Boolean);
begin
  inherited;
  SetParentProperties(not Active);
end;

function TCircledSeries.HasBackColor: Boolean;
begin
  result:=(CircleBackColor<>clTeeColor) and (CircleBackColor<>clNone);
end;

procedure TCircledSeries.SetCircleGradient(const Value: TChartGradient);
begin
  FCircleGradient.Assign(Value);
end;

procedure TCircledSeries.DrawCircleGradient;
var tmpR : TRect;
    tmpW : Integer;
    tmpH : Integer;
begin
  if (not ParentChart.View3D) or ParentChart.View3DOptions.Orthogonal then
  begin
    tmpW:=CircleWidth div 2;
    tmpH:=CircleHeight div 2;

    tmpR.Left:=CircleXCenter-tmpW;
    tmpR.Top:=CircleYCenter-tmpH;
    tmpR.Right:=CircleXCenter+tmpW;
    tmpR.Bottom:=CircleYCenter+tmpH;

    if Shadow.Visible then
       Shadow.Draw(ParentChart.Canvas,tmpR,EndZ);

    if ParentChart.View3D then
       tmpR:=ParentChart.Canvas.CalcRect3D(tmpR,EndZ);

    Inc(tmpR.Right,2);
    Inc(tmpR.Bottom,2);
    ParentChart.Canvas.ClipEllipse(tmpR);
    Dec(tmpR.Right,2);
    Dec(tmpR.Bottom,2);

    CircleGradient.Draw(ParentChart.Canvas,tmpR);
    ParentChart.Canvas.UnClipRectangle;
  end;
end;

{ TSliceValueList }
Function TSliceValueList.Get(Index:Integer):Integer;
begin
  if (Index<Count) and Assigned(Items[Index]) then
     result:=Integer({$IFDEF CLR}TObject{$ENDIF}(Items[Index]))
  else
     result:=0
end;

Procedure TSliceValueList.Put(Index,Value:Integer);
{$IFDEF CLR}
const Zero:Integer=0;
{$ELSE}
const Zero=Pointer(0); // 7.02
{$ENDIF}
begin
  While Index>=Count do Add({$IFDEF CLR}TObject{$ENDIF}(Zero));

  if Get(Index)<>Value then
  begin
    Items[Index]:={$IFDEF CLR}TObject{$ELSE}Pointer{$ENDIF}(Value);
    OwnerSeries.Repaint;
  end;
end;

{$IFNDEF D6}
procedure TSliceValueList.Assign(Source:TList);
var t: Integer;
begin
  Clear;
  for t:=0 to Source.Count-1 do Add(Source[t]);
end;
{$ENDIF}

{ TPieOtherSlice }

Constructor TPieOtherSlice.Create(AOwner:TChartSeries);
begin
  inherited Create;
  FOwner:=AOwner;
  FColor:=clTeeColor;
end;

Destructor TPieOtherSlice.Destroy;
begin
  FLegend.Free;
  inherited;
end;

Procedure TPieOtherSlice.Assign(Source:TPersistent);
begin
  if Source is TPieOtherSlice then
  With TPieOtherSlice(Source) do
  begin
    Self.FColor:=FColor;

    if Assigned(FLegend) then Self.Legend:=Legend
                         else FreeAndNil(Self.FLegend);

    Self.FStyle:=FStyle;
    Self.FText :=FText;
    Self.FValue:=FValue;
  end;
end;

Function TPieOtherSlice.IsTextStored:Boolean;
begin
  result:=FText<>'';
end;

procedure TPieOtherSlice.SetColor(Value:TColor);
begin
  TSeriesAccess(FOwner).SetColorProperty(FColor,Value);
end;

procedure TPieOtherSlice.SetStyle(Value:TPieOtherStyle);
begin
  if FStyle<>Value then
  begin
    FStyle:=Value;
    FOwner.Repaint;
  end;
end;

procedure TPieOtherSlice.SetText(Const Value:String);
begin
  if FText<>Value then
  begin
    FText:=Value;
    FOwner.Repaint;
  end;
end;

procedure TPieOtherSlice.SetValue(Const Value:Double);
begin
  TSeriesAccess(FOwner).SetDoubleProperty(FValue,Value);
end;

function TPieOtherSlice.GetText: String;
begin
  if FText='' then result:=TeeMsg_PieOther
              else result:=FText;
end;

function TPieOtherSlice.GetLegend: TChartLegend;
begin
  if not Assigned(FLegend) then
  begin
    FLegend:=TChartLegend.Create(FOwner.ParentChart);
    FLegend.Hide;
    FLegend.Series:=FOwner;
  end;

  result:=FLegend;
end;

procedure TPieOtherSlice.SetLegend(const Value: TChartLegend);
begin
  if Assigned(Value) then
  begin
   Legend.Assign(Value);
   FLegend.Series:=FOwner;
  end
  else FreeAndNil(FLegend);
end;

{ TPieMarks }
procedure TPieMarks.SetLegSize(const Value:Integer);
begin
  if FLegSize<>Value then
  begin
    FLegSize:=Value;
    IParent.Repaint;
  end;
end;

procedure TPieMarks.SetVertCenter(const Value:Boolean);
begin
  if FVertCenter<>Value then
  begin
    FVertCenter:=Value;
    IParent.Repaint;
  end;
end;

Procedure TPieMarks.Assign(Source:TPersistent);
begin
  if Source is TPieMarks then
  with TPieMarks(Source) do
  begin
    Self.FVertCenter:=FVertCenter;
    Self.FLegSize:=FLegSize;
  end
  else inherited;
end;

{ TPieSeries }
Const
  TeePieBelongsToOther = -1;
  TeePieOtherFlag      = MaxLongint;

Constructor TPieSeries.Create(AOwner: TComponent);
begin
  inherited;
  FAngleSize:=360;
  FAutoMarkPosition:=True;

  FExplodedSlice:=TSliceValueList.Create;
  FExplodedSlice.OwnerSeries:=Self;

  FSliceHeights:=TSliceValueList.Create;
  FSliceHeights.OwnerSeries:=Self;

  FOtherSlice:=TPieOtherSlice.Create(Self);

  XValues.Name:='';
  YValues.Name:=TeeMsg_ValuesPie;

  Marks.Visible:=True;
  Marks.Callout.Length:=8;
  TCalloutAccess(Marks.Callout).DefaultLength:=8;

  FDark3D:=True;
  ColorEachPoint:=True;
  IUseSeriesColor:=False;
  IUseNotMandatory:=False;

  CircleGradient.StartColor:=clWhite;
  CircleGradient.Direction:=gdRadial;

  FMultiPie:=mpAutomatic;

  FPieMarks:=TPieMarks.Create;
  FPieMarks.IParent:=Self;
end;

Destructor TPieSeries.Destroy;
begin
  FPieMarks.Free;
  FAngles:=nil;
  FreeAndNil(FSliceHeights);
  FreeAndNil(FExplodedSlice);
  FreeAndNil(FOtherSlice);
  inherited;
end;

Function TPieSeries.CalcXPos(ValueIndex:Integer):Integer;
begin
  if XValues.Value[ValueIndex]=TeePieOtherFlag then  { do not try to calc }
     result:=0
  else
     result:=inherited CalcXPos(ValueIndex);
end;

Function TPieSeries.NumSampleValues:Integer;
Begin
  result:=8;
End;

Procedure TPieSeries.ClearLists;
begin
  inherited;
  if Assigned(FExplodedSlice) then FExplodedSlice.Clear;
  if Assigned(FSliceHeights) then FSliceHeights.Clear;
end;

Procedure TPieSeries.PreparePiePen(ValueIndex:Integer);
begin
  with ParentChart.Canvas do
  if FDarkPen>0 then
     AssignVisiblePenColor(PiePen,ApplyDark(ValueColor[ValueIndex],255-FDarkPen))
  else
     AssignVisiblePen(PiePen);
end;

// Returns number of visible Pie series
function TPieSeries.PieCount:Integer;
var t : Integer;
    tmp : TChartSeries;
begin
  result:=0;
  for t:=0 to ParentChart.SeriesCount-1 do
  begin
    tmp:=ParentChart[t];
    if tmp.Active and SameClass(tmp) then
       Inc(result);
  end;
end;

Procedure TPieSeries.InitCustom3DOptions;
begin
  inherited;

  With ParentChart.View3DOptions do
  begin
    Orthogonal:=False;
    Rotation:=360;
    Elevation:=315;
    Perspective:=0;
    Tilt:=0;
  end;
end;

Function TPieSeries.MoreSameZOrder:Boolean; // 7.0
begin
  result:=False;
end;

Function TPieSeries.SliceBrushStyle(ValueIndex:Integer):TBrushStyle;
begin
  if (UsePatterns or ParentChart.Monochrome) and (ValueIndex<>TeeAllValues) then
     result:=GetDefaultPattern(ValueIndex)
  else
     result:=bsSolid;
end;

Procedure TPieSeries.PrepareLegendCanvas( ValueIndex:Integer; var BackColor:TColor;
                                          var BrushStyle:TBrushStyle);
Begin
  inherited;
  PreparePiePen(ValueIndex);
  BrushStyle:=SliceBrushStyle(ValueIndex);
end;

Procedure TPieSeries.GalleryChanged3D(Is3D:Boolean);
begin
  inherited;
  DisableRotation;
  Circled:=not ParentChart.View3D;
end;

Procedure TPieSeries.AddSampleValues(NumValues:Integer; Sequential:Boolean=False);
var PieSampleStr : Array[0..7] of String;
    t : Integer;
Begin
  PieSampleStr[0]:=TeeMsg_PieSample1;
  PieSampleStr[1]:=TeeMsg_PieSample2;
  PieSampleStr[2]:=TeeMsg_PieSample3;
  PieSampleStr[3]:=TeeMsg_PieSample4;
  PieSampleStr[4]:=TeeMsg_PieSample5;
  PieSampleStr[5]:=TeeMsg_PieSample6;
  PieSampleStr[6]:=TeeMsg_PieSample7;
  PieSampleStr[7]:=TeeMsg_PieSample8;

  for t:=0 to NumValues-1 do
      Add( 1+RandomValue(ChartSamplesMax), { <-- Value }
           PieSampleStr[t mod 8]);      { <-- Label }
end;

Function TPieSeries.CalcClickedPie(x,y:Integer; Exploded:Boolean=True):Integer;  // 7.06 7.07
var tmpOffX : Integer;
    tmpOffY : Integer;

  function CalcAngle(const Angle:Double):TPoint;
  var tmpX : Integer;
      tmpY : Integer;
  begin
    AngleToPos(Angle, XRadius, YRadius, tmpX, tmpY);
    result:=ParentChart.Canvas.Calculate3DPosition(tmpX+tmpOffX, tmpY-tmpOffY, EndZ);
  end;

var tmpDifAngle : Double;
    t        : Integer;
    P        : TPoint;
    Poly     : Array[0..31] of TPoint;
Begin
  if Length(FAngles)>0 then
  begin
    P.X:=X;
    P.Y:=Y;

    tmpOffX:=0;
    tmpOffY:=0;

    for result:=0 to Count-1 do
    With FAngles[result] do
    begin
      if Exploded then
         CalcExplodedOffset(result,tmpOffX,tmpOffY);

      Poly[0]:=CalcAngle(StartAngle);

      Poly[1]:=ParentChart.Canvas.Calculate3DPosition(CircleXCenter+tmpOffX,
                                                   CircleYCenter-tmpOffY, EndZ);

      tmpDifAngle:=(EndAngle-StartAngle)/30;

      for t:=2 to 31 do
          Poly[t]:=CalcAngle(EndAngle-(t-2)*tmpDifAngle);

      if PointInPolygon(P,Poly) then
         Exit;
    end;
  end;

  result:=TeeNoPointClicked;
end;

Function TPieSeries.Clicked(x,y:Integer):Integer;
begin
  result:=inherited Clicked(x,y);

  if result=TeeNoPointClicked then
     result:=CalcClickedPie(x,y);
end;

Function TPieSeries.CountLegendItems:Integer;
var t : Integer;
begin
  result:=0;

  for t:=0 to Count-1 do
      if BelongsToOtherSlice(t) then
         Inc(result);

  if (not Assigned(OtherSlice.FLegend)) or (ILegend<>OtherSlice.FLegend) then
     result:=Count-result;
end;

Function TPieSeries.LegendToValueIndex(LegendIndex:Integer):Integer;
var Num : Integer;
    t   : Integer;
    tmp : Boolean;
    tmpIsOther : Boolean;
begin
  result:=LegendIndex;
  Num:=-1;

  tmpIsOther:=Assigned(OtherSlice.FLegend) and (ILegend=OtherSlice.FLegend);

  for t:=0 to Count-1 do
  begin
    tmp:=BelongsToOtherSlice(t);

    if (tmpIsOther and tmp) or ((not tmpIsOther) and (not tmp)) then
    begin
      Inc(Num);

      if Num=LegendIndex then
      begin
        result:=t;
        break;
      end;
    end;
  end;
end;

Function TPieSeries.BelongsToOtherSlice(ValueIndex:Integer):Boolean;
begin
  result:=NotMandatoryValueList.Value[ValueIndex]=TeePieBelongsToOther;
end;

Procedure TPieSeries.CalcAngles;
const PiRatio=Pi*2.0/360.0;
var tmpSumAbs : Double;
    AcumValue : Double;
    PiPortion : Double;
    t         : Integer;
    TotalAngle: Double;
Begin
  TotalAngle:=PiRatio*FAngleSize;
  AcumValue:=0;

  if (OtherSlice.Style=poNone) and (FirstValueIndex<>-1) then  // 7.0
  begin
    tmpSumAbs:=0;

    for t:=FirstValueIndex to LastValueIndex do
        tmpSumAbs:=tmpSumAbs+Abs(MandatoryValueList.Value[t]);
  end
  else
    tmpSumAbs:=MandatoryValueList.TotalAbs;

  if tmpSumAbs<>0 then PiPortion:=TotalAngle/tmpSumAbs
                  else PiPortion:=0;

  SetLength(FAngles,Count);

  for t:=FirstValueIndex to LastValueIndex do
  With FAngles[t] do
  Begin
    if t=FirstValueIndex then StartAngle:=0
                         else StartAngle:=FAngles[t-1].EndAngle;

    if tmpSumAbs<>0 then
    Begin
      if not BelongsToOtherSlice(t) then
         AcumValue:=AcumValue+Abs(MandatoryValueList.Value[t]);

      if AcumValue=tmpSumAbs then EndAngle:=TotalAngle
                             else EndAngle:=AcumValue*PiPortion;

      { prevent small pie sectors }
      if (EndAngle-StartAngle)>TotalAngle then
         EndAngle:=StartAngle+TotalAngle;
    end
    else EndAngle:=TotalAngle;

    MidAngle:=(StartAngle+EndAngle)*0.5;
  end;
end;

Procedure TPieSeries.CalcExplodedRadius(ValueIndex:Integer; out AXRadius,AYRadius:Integer);
var tmpExp : Double;
begin
  tmpExp:=1.0+FExplodedSlice[ValueIndex]*0.01;
  AXRadius:=Round(FXRadius*tmpExp);
  AYRadius:=Round(FYRadius*tmpExp);
end;

Function TPieSeries.SliceEndZ(ValueIndex:Integer):Integer;
begin
  if FSliceHeights.Count>ValueIndex then  // 7.0
     result:=StartZ+Round((EndZ-StartZ)*FSliceHeights[ValueIndex]*0.01)
  else
     result:=EndZ;
end;

Procedure TPieSeries.DrawLegendShape(ValueIndex:Integer; Const Rect:TRect);  // 7.0
var tmpColor : TColor;
begin
  if CircleGradient.Visible then
  begin
    if ParentChart.Monochrome then tmpColor:=clBlack
                              else tmpColor:=ValueColor[ValueIndex];

    if tmpColor=clNone then inherited
    else
    begin
      CircleGradient.EndColor:=tmpColor;
      CircleGradient.Draw(ParentChart.Canvas,Rect);
      PreparePiePen(ValueIndex);
      ParentChart.Canvas.Brush.Style:=bsClear;
      ParentChart.Canvas.Rectangle(Rect);
    end;
  end
  else inherited;
end;

Procedure TPieSeries.DrawMark( ValueIndex:Integer; Const St:String;
                               APosition:TSeriesMarkPosition);
var tmpXRadius : Integer;
    tmpYRadius : Integer;
    tmp        : Double;
    tmpLength  : Integer;
    tmpYPos    : Integer;
Begin
  if not BelongsToOtherSlice(ValueIndex) then
  begin
    CalcExplodedRadius(ValueIndex,tmpXRadius,tmpYRadius);

    // Verify Pie slice angles are calculated
    CheckAngles;

    if ParentChart.Canvas.SupportsFullRotation then  // ??
    begin
      tmp:=FAngles[ValueIndex].MidAngle+Pi+0.5*Pi;
      Marks.ZPosition:=StartZ;
    end
    else
    begin
      tmp:=FAngles[ValueIndex].MidAngle;
      Marks.ZPosition:=SliceEndZ(ValueIndex);
    end;

    With APosition do
    begin
      ArrowFix:=True;

      tmpLength:=Marks.Callout.Length+Marks.Callout.Distance;
      AngleToPos( tmp,
                  tmpXRadius+tmpLength, tmpYRadius+tmpLength,
                  ArrowTo.X, ArrowTo.Y );

      tmpLength:=Marks.Callout.Distance;
      AngleToPos( tmp,tmpXRadius+tmpLength,tmpYRadius+tmpLength,ArrowFrom.X,ArrowFrom.Y );

      With ArrowTo do
      begin
        if X>FCircleXCenter then LeftTop.X:=X
                            else LeftTop.X:=X-Width;

        if Y>FCircleYCenter then LeftTop.Y:=Y
                            else LeftTop.Y:=Y-Height;

        if Self.PieMarks.VertCenter then
        begin
          tmpYPos:=Height div 2;

          if Y>FCircleYCenter then Y:=Y+tmpYPos
                              else Y:=Y-tmpYPos;
        end;

        if Self.PieMarks.LegSize=0 then
        begin
          HasMid:=False;
          MidPoint.X:=0;
          MidPoint.Y:=0;
        end
        else
        begin
          HasMid:=True;

          if X>FCircleXCenter then
          begin
            if X-PieMarks.LegSize < ArrowFrom.X then
            begin
              MidPoint.X:=ArrowFrom.X;
              X:=X+PieMarks.LegSize;
              LeftTop.X:=X;
            end
            else
              MidPoint.X:=X-PieMarks.LegSize;
          end
          else
          begin
            if X+PieMarks.LegSize > ArrowFrom.X then
            begin
              MidPoint.X:=ArrowFrom.X;
              X:=ArrowFrom.X-PieMarks.LegSize;
              LeftTop.X:=X-Width;
            end
            else
              MidPoint.X:=X+PieMarks.LegSize;
          end;

          MidPoint.Y:=Y;
        end;
      end;
    end;

    if AutoMarkPosition then
       TSeriesMarksAccess(Marks).AntiOverlap(FirstValueIndex,ValueIndex,APosition);

    inherited;
  end;
end;

Function TPieSeries.CompareSlice(A,B:Integer):Integer;
var TotalAngle : Double;
    TotalQuart : Double;

  Function GetAngleSlice(Index:Integer):Double;
  begin
    result:=FAngles[Index].MidAngle+IRotDegree;
    if result>TotalAngle then result:=result-TotalAngle;
    if result>TotalQuart then
    begin
      result:=result-TotalQuart;
      if result>Pi then result:=TotalAngle-result;
    end
    else result:=TotalQuart-result;
  end;

var tmpA : Double;
    tmpB : Double;
begin
  TotalAngle:=Pi*FAngleSize/180.0;
  TotalQuart:=(0.25*TotalAngle);

  tmpA:=GetAngleSlice(ISortedSlice[A]);
  tmpB:=GetAngleSlice(ISortedSlice[B]);

  if tmpA<tmpB then result:=-1 else
  if tmpA>tmpB then result:= 1 else result:= 0;
end;

Procedure TPieSeries.SwapSlice(a,b:Integer);
begin
  SwapInteger(ISortedSlice[a],ISortedSlice[b]);
end;

procedure TPieSeries.DrawAllValues;
var t                : Integer;
    tmpCount         : Integer;
    MaxExploded      : Integer;
    MaxExplodedIndex : Integer;
    tmpOffX          : Integer;
    tmpOffY          : Integer;
    tmpForcedExploded: Boolean;
begin
  if FExplodeBiggest>0 then CalcExplodeBiggest;

  MaxExplodedIndex:=-1;
  MaxExploded:=0;

  tmpCount:=(LastValueIndex-FirstValueIndex)+1;

  { calc biggest exploded index }
  for t:=FirstValueIndex to LastValueIndex do
  if FExplodedSlice[t]>MaxExploded then
  begin
    MaxExploded:=Round(FExplodedSlice[t]);
    MaxExplodedIndex:=t;
  end;

  { calc each slice angles }
  CheckAngles;

  { adjust circle rectangle }
  IsExploded:=(MaxExplodedIndex<>-1) or (FSliceHeights.Count>0);

  if MaxExplodedIndex<>-1 then
  begin
    CalcExplodedOffset(MaxExplodedIndex,tmpOffX,tmpOffY);
    InflateRect(FCircleRect,-Abs(tmpOffX) div 2,-Abs(tmpOffY) div 2);
    AdjustCircleRect;
    CalcRadius;
  end;

  if FShadow.Visible then
     FShadow.DrawEllipse(ParentChart.Canvas,CircleRect,EndZ-10);

  { exploded slices for 3D drawing, sort order... }
  if ParentChart.View3D and (IsExploded or (DonutPercent>0))
     and (not ParentChart.Canvas.SupportsFullRotation) then
  begin
    SetLength(ISortedSlice,tmpCount);
    for t:=FirstValueIndex to LastValueIndex do
        ISortedSlice[t-FirstValueIndex]:=t;

    TeeSort(0,tmpCount-1,CompareSlice,SwapSlice);

    tmpForcedExploded:=False;

    for t:=0 to tmpCount-1 do
    begin
      if (not IsExploded) and (DonutPercent>0) and (AngleSize<>360) then // 7.0
         if (ISortedSlice[t]=FirstValueIndex) or (ISortedSlice[t]=LastValueIndex) then
         begin
           IsExploded:=True;
           tmpForcedExploded:=True;
         end;

      DrawValue(ISortedSlice[t]);

      if tmpForcedExploded then IsExploded:=False;
    end;

    ISortedSlice:=nil;
  end
  else
    inherited;

  if Assigned(OtherSlice.FLegend) and
     OtherSlice.Legend.Visible then
  begin
    ILegend:=OtherSlice.Legend;
    try
      OtherSlice.Legend.DrawLegend;
    finally
      ILegend:=nil;
    end;
  end;
end;

procedure TPieSeries.CheckAngles;
begin
  if Length(FAngles)=0 then
     CalcAngles;
end;

Procedure TPieSeries.DrawPie(ValueIndex:Integer);
var tmpOffX : Integer;
    tmpOffY : Integer;
    tmpGradient : TChartGradient;
    IniX,
    IniY,
    EndX,
    EndY  : Integer;
Begin
  CalcExplodedOffset(ValueIndex,tmpOffX,tmpOffY);

  // Special case, when this Pie series is not the only series in the chart,
  // we should check here if "FAngles" array is still empty (not yet calculated).
  //
  // Explanation:
  // By default, CalcAngles is called at Pie "DrawAllValues".
  // DrawAllValues is only called when Pie is the only series in a chart.
  CheckAngles;

  With FAngles[ValueIndex] do
  with ParentChart,Canvas do { Draw pie slice }
  if View3D then
  begin
    if Self.CircleGradient.Visible then
       tmpGradient:=Self.CircleGradient
    else
       tmpGradient:=nil; // 6.02

    Pie3D( FCircleXCenter+tmpOffX,
           FCircleYCenter-tmpOffY,
           FXRadius,FYRadius,
           StartZ,
           SliceEndZ(ValueIndex),
           StartAngle+IRotDegree,EndAngle+IRotDegree,
           FDark3D,
           IsExploded,
           FDonutPercent,
           tmpGradient)
  end
  else
  begin
    if FDonutPercent>0 then
    begin
      if PieValues.Value[ValueIndex]<>0 then // 8.0 TV52011419
         Donut( FCircleXCenter+tmpOffX,
                FCircleYCenter-tmpOffY,
                FXRadius,FYRadius,
                StartAngle+IRotDegree,EndAngle+IRotDegree,
                FDonutPercent)
    end
    else
    begin
      AngleToPos(StartAngle,FXRadius,FYRadius,IniX,IniY);
      AngleToPos(EndAngle,FXRadius,FYRadius,EndX,EndY);

      if ((IniX<>EndX) or (IniY<>EndY)) or (Count=1) or
         ( (Count>1) and (EndAngle-StartAngle>1) )  then { bug win32 api }
      begin
        {$IFDEF CLX}
        if ((IniX=EndX) and (IniY=EndY)) then
           With FCircleRect do
             Ellipse( Left + tmpOffX,Top   -tmpOffY,
                      Right+ tmpOffX,Bottom-tmpOffY)
        else
        {$ENDIF}
        with FCircleRect do
             Pie( Left + tmpOffX,Top   -tmpOffY,
                  Right+ tmpOffX,Bottom-tmpOffY,
                  IniX + tmpOffX,IniY  -tmpOffY,
                  EndX + tmpOffX,EndY  -tmpOffY);
      end;
    end;
  end;
end;

Procedure TPieSeries.CalcExplodedOffset( ValueIndex:Integer;
                                         out OffsetX,OffsetY:Integer);
var tmpExp : Double;
    tmpSin : Extended;
    tmpCos : Extended;
    tmp    : Double;
begin
  OffsetX:=0;
  OffsetY:=0;

  if IsExploded and (FExplodedSlice.Count>0) then
  begin
    tmpExp:=FExplodedSlice[ValueIndex];

    // Apply exploded % to radius
    if tmpExp>0 then
    begin
      with FAngles[ValueIndex] do
      if ParentChart.Canvas.SupportsFullRotation then
         tmp:=MidAngle+(Pi*FAngleSize/45.0)+Pi
      else
         tmp:=MidAngle;

      SinCos(tmp+IRotDegree,tmpSin,tmpCos);
      tmpExp:=tmpExp*0.01;
      OffsetX:=Round(FXRadius*tmpExp*tmpCos);
      OffsetY:=Round(FYRadius*tmpExp*tmpSin);
    end;
  end;
end;

Procedure TPieSeries.CalcExplodeBiggest;
var tmp : Integer;
    t   : Integer;
begin
  if Assigned(ParentChart) and (ParentChart.MaxPointsPerPage>0) then  // 7.0
  begin
    if FirstValueIndex<>-1 then
    begin
      tmp:=FirstValueIndex;

      for t:=FirstValueIndex+1 to LastValueIndex do
          if YValues.Value[t]>YValues.Value[tmp] then
             tmp:=t;
    end
    else tmp:=-1;
  end
  else
     with YValues do tmp:=Locate(MaxValue);

  if tmp<>-1 then
     FExplodedSlice[tmp]:=FExplodeBiggest;
end;

Procedure TPieSeries.SetAngleSize(Value:Integer);
begin
  SetIntegerProperty(FAngleSize,Value);
end;

Procedure TPieSeries.SetAutoMarkPosition(Value:Boolean);
Begin
  SetBooleanProperty(FAutoMarkPosition,Value);
end;

procedure TPieSeries.SetDonutPercent(Value:Integer);
begin
  SetIntegerProperty(FDonutPercent,Value);
end;

procedure TPieSeries.SetExplodeBiggest(Value:Integer);
begin
  SetIntegerProperty(FExplodeBiggest,Value);
  CalcExplodeBiggest;
end;

procedure TPieSeries.SetMultiPie(const Value:TMultiPie);
begin
  if FMultiPie<>Value then
  begin
    FMultiPie:=Value;
    Repaint;
  end;
end;

procedure TPieSeries.SetOtherSlice(Value:TPieOtherSlice);
begin
  FOtherSlice.Assign(Value);
end;

Procedure TPieSeries.DrawValue(ValueIndex:Integer);
var tmpColor : TColor;
Begin
  if (CircleWidth>4) and (CircleHeight>4) then
  if not BelongsToOtherSlice(ValueIndex) then
  begin
    Brush.Style:=SliceBrushStyle(ValueIndex);

    if ParentChart.Monochrome then tmpColor:=clBlack
                              else tmpColor:=ValueColor[ValueIndex];

    { Set slice back color }
    if tmpColor=clNone then
       ParentChart.Canvas.Brush.Style:=bsClear  // 7.0
    else
    begin
      ParentChart.SetBrushCanvas(tmpColor,Brush,CalcCircleBackColor);

      if CircleGradient.Visible then
         CircleGradient.EndColor:=tmpColor;
    end;

    PreparePiePen(ValueIndex);

    DrawPie(ValueIndex);
  end;
end;

procedure TPieSeries.SetUsePatterns(Value:Boolean);
Begin
  SetBooleanProperty(FUsePatterns,Value);
end;

class Function TPieSeries.GetEditorClass:String;
Begin
  result:='TPieSeriesEditor'; { <-- dont translate ! }
end;

Function TPieSeries.GetPieValues:TChartValueList;
Begin
  result:=YValues;
end;

Function TPieSeries.GetPiePen:TChartPen;
begin
  result:=Pen;
end;

Procedure TPieSeries.SetDark3D(Value:Boolean);
Begin
  SetBooleanProperty(FDark3D,Value);
End;

Procedure TPieSeries.SetPieMarks(const Value:TPieMarks);
begin
  FPieMarks.Assign(Value);
end;

Procedure TPieSeries.SetPieValues(Value:TChartValueList);
Begin
  SetYValues(Value);
end;

Function TPieSeries.MaxXValue:Double;
Begin
  result:=GetHorizAxis.Maximum;
End;

Function TPieSeries.MinXValue:Double;
Begin
  result:=GetHorizAxis.Minimum;
End;

Function TPieSeries.MaxYValue:Double;
Begin
  result:=GetVertAxis.Maximum;
End;

Function TPieSeries.MinYValue:Double;
Begin
  result:=GetVertAxis.Minimum;
End;

Procedure TPieSeries.DisableRotation;
begin
  With ParentChart.View3DOptions do
  begin
    Orthogonal:=False;
    Rotation:=0;
    Elevation:=305;
  end;
end;

Procedure TPieSeries.PrepareForGallery(IsEnabled:Boolean);
Begin
  inherited;

  FillSampleValues(8);
  ParentChart.Chart3DPercent:=75;
  Marks.Callout.Length:=0;
  Marks.DrawEvery:=1;
  Gradient.Visible:=True;
  DisableRotation;
  ColorEachPoint:=IsEnabled;
end;

Procedure TPieSeries.Assign(Source:TPersistent);
begin
  if Source is TPieSeries then
  With TPieSeries(Source) do
  begin
    Self.FAngleSize     :=FAngleSize;
    Self.FAutoMarkPosition:=FAutoMarkPosition;
    Self.FDark3D        :=FDark3D;
    Self.FDarkPen       :=FDarkPen;
    Self.FExplodeBiggest:=FExplodeBiggest;
    Self.FExplodedSlice.Assign(FExplodedSlice);
    Self.FMultiPie      :=FMultiPie;
    Self.FSliceHeights.Assign(FSliceHeights);
    Self.FUsePatterns   :=FUsePatterns;
    Self.OtherSlice     :=FOtherSlice;
    Self.PieMarks.Assign(FPieMarks);
  end;

  inherited;
  ColorEachPoint:=True;
end;

Function TPieSeries.AddPie( Const AValue:Double;
                            Const ALabel:String; AColor:TColor):Integer;
begin
  result:=Add(AValue,ALabel,AColor);
end;

procedure TPieSeries.RemoveOtherSlice;
var t : Integer;
begin
  { remove "other" slice, if exists... }
  for t:=0 to Count-1 do
  if XValues.Value[t]=TeePieOtherFlag then
  begin
    Delete(t);
    Break;
  end;
end;

procedure TPieSeries.WriteData(Stream: TStream);
begin
  RemoveOtherSlice;
  inherited;
end;

Procedure TPieSeries.CheckOrder;
begin
  XValues.Order:=loAscending;  // reset X order back to ascending
  Repaint;
  // do not call inherited. Simply repaint.
  // Pie series will already sort values at DoBeforeDrawChart method.
end;

procedure TPieSeries.Clear;
begin
  inherited;
  FAngles:=nil;
end;

procedure TPieSeries.DoBeforeDrawChart;

  // Try to find a custom mark for "Other" slice, and return a copy
  function OtherMarkCustom:TSeriesMarkPosition;
  var t   : Integer;
      tmp : TSeriesMarkPosition;
  begin
    result:=nil;

    for t:=0 to Count-1 do
    if XValues.Value[t]=TeePieOtherFlag then
    begin
      tmp:=Marks.Positions.Position[t];

      if Assigned(tmp) and tmp.Custom then
      begin
        result:=TSeriesMarkPosition.Create;
        result.Assign(tmp);
      end;

      Break;
    end;
  end;

var t            : Integer;
    tmp          : Double;
    tmpValue     : Double;
    tmpHasOther  : Boolean;
    tmpOtherMark : TSeriesMarkPosition;
begin
  inherited;

  tmpOtherMark:=OtherMarkCustom; // 7.07

  { re-order values }
  With PieValues do
       if Order<>loNone then Sort;

  RemoveOtherSlice;

  // Force re-creating all Angles (v8)
  FAngles:=nil;

  // Reset X order, eliminating all slices that could belong to "Other"
  // slice in a previous repaint.
  XValues.FillSequence;

  { calc "Other" slice... }
  if (FOtherSlice.Style<>poNone) and (MandatoryValueList.TotalABS>0) then
  Begin
    tmpHasOther:=False;
    tmpValue:=0;

    for t:=0 to Count-1 do
    begin
      tmp:=Abs(YValues.Value[t]);  // 7.0 Abs
      if FOtherSlice.Style=poBelowPercent then
         tmp:=tmp*100.0/YValues.TotalAbs;

      if tmp<FOtherSlice.Value then
      begin
        tmpValue:=tmpValue+Abs(YValues.Value[t]);  // 7.0 Abs
        XValues.Value[t]:=TeePieBelongsToOther; { <-- belongs to "other" }
        tmpHasOther:=True;
      end;
    end;

    { Add "Other" slice }
    if tmpHasOther then { 5.02 }
    begin
      t:=AddXY(TeePieOtherFlag,tmpValue,FOtherSlice.Text,FOtherSlice.Color);

      With YValues do
           TotalABS:=TotalABS-tmpValue; { reset Y total }

      // 7.07, reset custom mark for "Other" slice
      if Assigned(tmpOtherMark) then
         Marks.Positions.Position[t]:=tmpOtherMark;
    end;
  end;

  FreeAndNil(tmpOtherMark);
end;

procedure TPieSeries.DoAfterDrawValues;
begin
  ParentChart.ChartRect:=IOldChartRect;
  inherited;
end;

procedure TPieSeries.DoBeforeDrawValues;

  procedure GuessRectangle;

    function PieIndex:Integer;
    var t : Integer;
        tmp : TChartSeries;
    begin
      result:=0;
      for t:=0 to ParentChart.SeriesCount-1 do
      begin
        tmp:=ParentChart[t];
        if tmp=Self then break
        else
        if tmp.Active and SameClass(tmp) then
           Inc(result);
      end;
    end;

  var tmpR : TRect;
      tmpIndex : Integer;
      tmpW,
      tmpH : Integer;
      tmpCols,
      tmpRows  : Integer;
      tmpCount : Integer;
  begin
    tmpCount:=PieCount;

    if tmpCount>1 then
    begin
      tmpR:=ParentChart.ChartRect;
      tmpIndex:=PieIndex;
      tmpW:=tmpR.Right-tmpR.Left;
      tmpH:=tmpR.Bottom-tmpR.Top;

      tmpCols:=Round(Sqrt(tmpCount));

      tmpR.Left:=tmpR.Left+(tmpIndex mod tmpCols)*(tmpW div tmpCols);
      tmpR.Right:=tmpR.Left+(tmpW div tmpCols);

      tmpRows:=Round(0.5+Sqrt(tmpCount));

      tmpR.Top:=tmpR.Top+((tmpIndex div tmpCols))*(tmpH div tmpRows);
      tmpR.Bottom:=tmpR.Top+(tmpH div tmpRows);

      ParentChart.ChartRect:=ParentChart.Canvas.CalcRect3D(tmpR,0);
    end;
  end;

begin
  IOldChartRect:=ParentChart.ChartRect;

  if MultiPie=mpAutomatic then
     GuessRectangle;

  inherited;
end;

procedure TPieSeries.SwapValueIndex(a,b:Integer);

  Procedure ExchangeSliceList(AList:TSliceValueList);
  begin
    With AList do
    if Count>0 then // 7.0
    begin
      While Self.Count>Count do Add(nil);  // 7.0
      Exchange(a,b);
    end;
  end;

begin
  inherited;

  ExchangeSliceList(FExplodedSlice);
  ExchangeSliceList(FSliceHeights); // 7.0
end;

procedure TPieSeries.Delete(ValueIndex:Integer); // 7.0
begin
  inherited;
  if FExplodedSlice.Count>ValueIndex then
     FExplodedSlice.Delete(ValueIndex);

  if FSliceHeights.Count>ValueIndex then
     FSliceHeights.Delete(ValueIndex);
end;

class Procedure TPieSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
begin
  With TPieSeries(ASeries) do
  Case Index of
    1: begin
         UsePatterns:=True;
         Gradient.Visible:=False;
       end;
    2: ExplodeBiggest:=30;
    3: With Shadow do
       begin
         HorizSize:=10;
         VertSize:=10;
       end;
    4: begin
         Marks.Visible:=True;
         Clear;
         Add(30,'A'); // Do not localize
         Add(70,'B'); // Do not localize
       end;
    5: AngleSize:=180;
    6: Pen.Hide;
    7: DarkPen:=32;
  end;
end;

class Procedure TPieSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Patterns);
  AddSubChart(TeeMsg_Exploded);
  AddSubChart(TeeMsg_Shadow);
  AddSubChart(TeeMsg_Marks);
  AddSubChart(TeeMsg_SemiPie);
  AddSubChart(TeeMsg_NoBorder);
  AddSubChart(TeeMsg_DarkPen);
end;

procedure TPieSeries.SetParentChart(const Value: TCustomAxisPanel);
begin
  inherited;
  if not (csDestroying in ComponentState) then
     if Assigned(OtherSlice) and Assigned(OtherSlice.FLegend) then
        OtherSlice.Legend.ParentChart:=Value;
end;

procedure TPieSeries.SetDarkPen(const Value: Integer);
begin
  SetIntegerProperty(FDarkPen,Value);
end;

Procedure TPieSeries.CalcFirstLastVisibleIndex;
begin
  if FOtherSlice.Style=poNone then  // 7.0
     CalcFirstLastPage(FFirstVisibleIndex,FLastVisibleIndex)  // 7.0
  else
     FFirstVisibleIndex:=-1;

  if FirstValueIndex=-1 then inherited;
end;

procedure TPieSeries.CalcSelectionPos(ValueIndex:Integer; out X,Y:Integer);
var tmpX : Integer;
    tmpY : Integer;
begin
  if (Count>ValueIndex) and (Length(FAngles)>ValueIndex) then
  begin
    CalcExplodedRadius(ValueIndex,tmpX,tmpY);
    AngleToPos(FAngles[ValueIndex].MidAngle,tmpX,tmpY,X,Y);
  end
  else
     inherited CalcSelectionPos(ValueIndex,X,Y);
end;

Procedure TPieSeries.CalcZOrder; // 7.0
begin
//  inherited;  <-- do not call inherited here !  7.04 TV520100404
  IZOrder:=-1;
end;

// Do not modify the "CircleRect" if there's another Pie series in Chart,
procedure TPieSeries.CheckOtherSeriesMarks;
begin // Dont call inherited.
end;

{ TFastLineSeries }
Constructor TFastLineSeries.Create(AOwner: TComponent);
Begin
  inherited;

  {$IFDEF TEEOCX}
  FExpandAxis:=25;
  {$ENDIF}

  AllowSinglePoint:=False;
  DrawBetweenPoints:=True;
  IMandatoryPen:=True;

  FAutoRepaint:=True;
  FDrawAll:=True;
  FIgnoreNulls:=True;
  FTreatNulls:=tnIgnore;
End;

Procedure TFastLineSeries.CalcPosition(ValueIndex:Integer; out x,y:Integer);
begin
  X:=GetHorizAxis.CalcXPosValue(XValues.Value[ValueIndex]);
  Y:=GetVertAxis.CalcYPosValue(YValues.Value[ValueIndex]);
end;

Procedure TFastLineSeries.NotifyNewValue(Sender:TChartSeries; ValueIndex:Integer);
{$IFNDEF TEEOCX}
var tmp   : Integer;
    {$IFNDEF CLX}
    tmpDC : TTeeCanvasHandle;
    {$ENDIF}
{$ENDIF}
begin
  if AutoRepaint then inherited
  {$IFNDEF TEEOCX}
  else
  begin
    if ValueIndex=0 then tmp:=0 else tmp:=Pred(ValueIndex);

    CalcPosition(tmp,OldX,OldY);

    With ParentChart,Canvas do
    begin
      {$IFDEF CLX}

      AssignVisiblePen(LinePen);

      {$ELSE}

      if FastPen then // 5.03
      begin
        tmpDC:=Handle;
        SelectObject(tmpDC,DCPEN);
        TeeSetDCPenColor(tmpDC,LinePen.Color);
      end
      else AssignVisiblePen(LinePen);

      {$ENDIF}

      if View3D then MoveTo3D(OldX,OldY,MiddleZ)
                else MoveTo(OldX,OldY);
    end;

    DrawValue(ValueIndex);
  end;
  {$ENDIF}
end;

class Function TFastLineSeries.GetEditorClass:String;
Begin
  result:='TFastLineSeriesEditor'; { <-- dont translate ! }
End;

procedure TFastLineSeries.PrepareCanvas;
Begin
  With ParentChart,Canvas do
  begin
    AssignVisiblePen(LinePen);
    Brush.Style:=bsClear;
    BackMode:=cbmTransparent;
  end;
end;

procedure TFastLineSeries.DoMove(X,Y:Integer);
begin
  With ParentChart.Canvas do
  if ParentChart.View3D then MoveTo3D(X,Y,MiddleZ)
                        else MoveTo(X,Y);
end;

procedure TFastLineSeries.DrawAllValues;
var t   : Integer;
    tmp : Integer;
begin
  PrepareCanvas;

  tmp:=FirstValueIndex;

  if tmp>0 then CalcPosition(Pred(tmp),OldX,OldY)
           else CalcPosition(tmp,OldX,OldY);

  DoMove(OldX,OldY);

  if tmp>0 then DrawValue(tmp);

  for t:=Succ(tmp) to LastValueIndex do DrawValue(t)
end;

procedure TFastLineSeries.DrawValue(ValueIndex:Integer);
var X : Integer;
    Y : Integer;

  function ShouldDrawPoint:Boolean;
  begin
    result:=not IsNull(ValueIndex);

    if result then
    begin
      if (TreatNulls=tnDontPaint) and
         (ValueIndex>0) and IsNull(Pred(ValueIndex)) then
            result:=False;
    end
    else
       if TreatNulls=tnIgnore then
          result:=True
       else
       if TreatNulls=tnSkip then
       begin
         X:=OldX;
         Y:=OldY;
       end;
  end;

begin
  CalcPosition(ValueIndex,X,Y);

  if X=OldX then
     if (not DrawAllPoints) or (Y=OldY) then
        Exit;

  if IgnoreNulls or ShouldDrawPoint then
  begin
    With ParentChart.Canvas do
    if ParentChart.View3D then
    begin
      if Stairs then
         if InvertedStairs then LineTo3D(OldX,Y,MiddleZ)
                           else LineTo3D(X,OldY,MiddleZ);

      LineTo3D(X,Y,MiddleZ);
    end
    else
    begin
      if Stairs then
         if InvertedStairs then LineTo(OldX,Y)
                           else LineTo(X,OldY);

      LineTo(X,Y);
    end;
  end
  else DoMove(X,Y);

  OldX:=X;
  OldY:=Y;
end;

// When changing the SeriesColor, set LinePen color
Procedure TFastLineSeries.SetSeriesColor(AColor:TColor);
begin
  inherited;
  LinePen.Color:=AColor;
end;

Procedure TFastLineSeries.DrawLegendShape(ValueIndex:Integer; Const Rect:TRect);
begin
  With Rect do ParentChart.Canvas.DoHorizLine(Left,Right,(Top+Bottom) div 2);
end;

Procedure TFastLineSeries.Assign(Source:TPersistent);
begin
  if Source is TFastLineSeries then
  with TFastLineSeries(Source) do
  begin
    Self.FAutoRepaint:=AutoRepaint;
    Self.FDrawAll:=DrawAllPoints;
    Self.FFastPen:=FastPen;
    Self.FIgnoreNulls:=IgnoreNulls;
    Self.FInvertedStairs:=InvertedStairs;
    Self.FStairs:=Stairs;
  end;

  inherited;
end;

Function TFastLineSeries.Clicked(x,y:Integer):Integer;
var t    : Integer;
    OldX : Integer;
    OldY : Integer;
    tmpX : Integer;
    tmpY : Integer;
    P    : TPoint;
begin
  result:=TeeNoPointClicked;

  if (FirstValueIndex>-1) and (LastValueIndex>-1) then
  begin
    if Assigned(ParentChart) then
       ParentChart.Canvas.Calculate2DPosition(X,Y,MiddleZ);

    OldX:=0;
    OldY:=0;
    P.X:=X;
    P.Y:=Y;

    for t:=FirstValueIndex to LastValueIndex do
    begin
      tmpX:=CalcXPos(t);
      tmpY:=CalcYPos(t);

      if (tmpX=X) and (tmpY=Y) then { clicked right on point }
      begin
        result:=t;
        break;
      end
      else
      if (t>FirstValueIndex) and PointInLine(P,tmpX,tmpY,OldX,OldY) then
      begin
        result:=t-1;
        break;
      end;

      OldX:=tmpX;
      OldY:=tmpY;
    end;
  end;
end;

Procedure TFastLineSeries.DrawMark( ValueIndex:Integer; Const St:String;
                                    APosition:TSeriesMarkPosition);
Begin
  Marks.ApplyArrowLength(APosition);
  inherited;
end;

class Procedure TFastLineSeries.CreateSubGallery(AddSubChart:TChartSubGalleryProc);
begin
  inherited;
  AddSubChart(TeeMsg_Marks);
  AddSubChart(TeeMsg_Dotted);
  AddSubChart(TeeMsg_Stairs);
end;

class Procedure TFastLineSeries.SetSubGallery(ASeries:TChartSeries; Index:Integer);
begin
  with TFastLineSeries(ASeries) do
  case Index of
     1: Marks.Visible:=True;
     2: LinePen.SmallDots:=True;
     3: Stairs:=True;
  end;
end;

// When changing the series Pen, set the SeriesColor to pen color
procedure TFastLineSeries.SetPen(const Value: TChartPen);
begin
  inherited;
  SeriesColor:=LinePen.Color;
end;

procedure TFastLineSeries.SetDrawAll(const Value: Boolean);
begin
  SetBooleanProperty(FDrawAll,Value);
end;

procedure TFastLineSeries.SetFastPen(const Value: Boolean);
begin
  {$IFNDEF CLX}
  if Assigned(@TeeSetDCPenColor) then
  begin
    FFastPen:=Value;
    DCPEN:=GetStockObject(DC_PEN);
  end;
  {$ENDIF}
end;

procedure TFastLineSeries.SetIgnoreNulls(const Value: Boolean);
begin
  SetBooleanProperty(FIgnoreNulls,Value);
end;

procedure TFastLineSeries.SetInvertedStairs(const Value: Boolean);
begin
  SetBooleanProperty(FInvertedStairs,Value);
end;

procedure TFastLineSeries.SetStairs(const Value: Boolean);
begin
  SetBooleanProperty(FStairs,Value);
end;

// Increases and decreases horizontal margins with rounded Pen.Width
procedure TFastLineSeries.CalcHorizMargins(var LeftMargin,
  RightMargin: Integer);
var tmp : Integer;
begin
  inherited;
  tmp:=Pen.Width-((Pen.Width-2) div 2);
  Inc(LeftMargin,tmp);
  Inc(RightMargin,tmp);
end;

// Increases and decreases vertical margins with rounded Pen.Width
procedure TFastLineSeries.CalcVerticalMargins(var TopMargin,
  BottomMargin: Integer);
var tmp : Integer;
begin
  inherited;
  tmp:=Pen.Width-((Pen.Width-2) div 2);
  Inc(TopMargin,tmp);
  Inc(BottomMargin,tmp);

//  if Marks.Visible then
//     TopMargin:=Math.Max(TopMargin,Marks.Callout.Length+Marks.Callout.Distance);
end;

procedure TFastLineSeries.PrepareLegendCanvas(ValueIndex: Integer;
  var BackColor: TColor; var BrushStyle: TBrushStyle);
begin
  PrepareCanvas;
end;

Procedure RegisterTeeStandardSeries;
begin
  RegisterTeeSeries(TLineSeries,     {$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryLine);
  RegisterTeeSeries(TBarSeries,      {$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryBar);
  RegisterTeeSeries(THorizBarSeries, {$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryHorizBar);
  RegisterTeeSeries(TAreaSeries,     {$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryArea);
  RegisterTeeSeries(TPointSeries,    {$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryPoint);
  RegisterTeeSeries(TPieSeries,      {$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryPie,      {$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryStandard,1);
  RegisterTeeSeries(TFastLineSeries, {$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryFastLine);
  RegisterTeeSeries(THorizLineSeries,{$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryHorizLine,{$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryStandard,1);
  RegisterTeeSeries(THorizAreaSeries,{$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryHorizArea,{$IFNDEF CLR}@{$ENDIF}TeeMsg_GalleryStandard,1);
end;

end.
