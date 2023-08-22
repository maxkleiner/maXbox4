{******************************************}
{   Base types and Procedures              }
{ Copyright (c) 1995-2007 by David Berneda }
{        All Rights Reserved               }
{******************************************}
unit TeeProcs;
{$I TeeDefs.inc}

interface

Uses {$IFNDEF LINUX}
     Windows, Messages,
     {$ENDIF}

     {$IFDEF TEEVCL}

     {$IFDEF CLX}
     Qt, QClipbrd, QGraphics, QStdCtrls, QExtCtrls, QControls, QForms, QPrinters,
     {$ELSE}
     Printers, Clipbrd, ExtCtrls, Controls, Graphics, Forms,
     {$IFNDEF D6}
     {$IFNDEF D5}
     Buttons,
     {$ENDIF}
     {$ENDIF}
     {$ENDIF}

     {$ENDIF}

     {$IFDEF D6}
     Types,
     {$ENDIF}

     {$IFDEF LCL}
     GraphType, LMessages,
     {$ENDIF}
     
     Classes, SysUtils, TeCanvas, TeeFilters;

{$IFDEF CLX}
{$DEFINE TEE_METAFILE}
{$ENDIF}

{$IFDEF LCL} // Lazarus
{$DEFINE TEE_METAFILE}

// Moved from TeePenDlg.pas until finished
Const
  TeeFormBorderStyle=bsNone;
{$ENDIF}

{$IFNDEF CLX}
{$IFNDEF LCL}
{$DEFINE IGNOREPALETTE}
{$ENDIF}
{$ENDIF}

{$IFDEF TEE_METAFILE}
type
  TMetafile=class(TBitmap)
  private
    FEnhanced: Boolean;
  published
    property Enhanced:Boolean read FEnhanced write FEnhanced;
  end;
{$ENDIF}

Const
   TeeDefVerticalMargin = 4;
   TeeDefHorizMargin    = 3;

   crTeeHand              = TCursor(2020); { Hand cursor }
   TeeMsg_TeeHand         = 'crTeeHand'; { string cursor name (dont translate) }

   TeeNormalPrintDetail   =    0;
   TeeHighPrintDetail     = -100;

   TeeDefault_PrintMargin =   15;

   MaxDefaultColors=19;  // Length of DefaultPalette (+1)

   TeeTabDelimiter        = #9;  { separator used in TeExport.pas }

var
  TeeClipWhenPrinting   : Boolean=True;  { Apply clipping when printing }
  TeeClipWhenMetafiling : Boolean=True;  { Apply clipping when creating metafiles }
  TeeEraseBack          : Boolean=False; { erase background before repainting panel }

  { Should Panel background to be printed ? Default: False }
  PrintTeePanel         : Boolean=False;

type
  TDateTimeStep=(  dtOneMicroSecond,
                   dtOneMillisecond,
                   dtOneSecond,
                   dtFiveSeconds,
                   dtTenSeconds,
                   dtFifteenSeconds,
                   dtThirtySeconds,
                   dtOneMinute,
                   dtFiveMinutes,
                   dtTenMinutes,
                   dtFifteenMinutes,
                   dtThirtyMinutes,
                   dtOneHour,
                   dtTwoHours,
                   dtSixHours,
                   dtTwelveHours,
                   dtOneDay,
                   dtTwoDays,
                   dtThreeDays,
                   dtOneWeek,
                   dtHalfMonth,
                   dtOneMonth,
                   dtTwoMonths,
                   dtThreeMonths,
                   dtFourMonths,
                   dtSixMonths,
                   dtOneYear,
                   dtNone );

const
    DateTimeStep:Array[TDateTimeStep] of Double=
      ( 1.0/(1000000.0*86400.0), 1.0/(1000.0*86400.0), 1.0/86400.0,
        5.0/86400.0,  10.0/86400.0,
        0.25/1440.0,  0.5/1440.0,    1.0/1440.0,
        5.0/1440.0,  10.0/1440.0,    0.25/24.0,
        0.5/24.0 ,    1.0/24.0 ,  2.0/24.0 ,  6.0/24.0 ,
        12.0/24.0,    1, 2, 3, 7, 15, 30, 60, 90, 120, 182, 365, {none:} 1
      );

type
  TCustomPanelNoCaption=class(TCustomPanel)
  public
    Constructor Create(AOwner: TComponent); override;
  end;

  TCustomTeePanel=class;

  TZoomPanning=class(TPersistent)
  private
    FActive     : Boolean;
  public
    X0,Y0,X1,Y1 : Integer;
    Procedure Check;
    Procedure Activate(x,y:Integer);

    property Active:Boolean read FActive write FActive;
  end;

  TTeeEvent=class
  public
    Sender : TCustomTeePanel;
    {$IFDEF CLR}
    Constructor Create; virtual;
    {$ENDIF}
  end;

  ITeeEventListener=interface
    procedure TeeEvent(Event:TTeeEvent);
  end;

  TTeeEventListeners=class {$IFDEF CLR}sealed{$ENDIF} (TList)
  private
    Function Get(Index:Integer):ITeeEventListener;
  public
    function Add(Const Item: ITeeEventListener): Integer;
    function Remove(Item: ITeeEventListener): Integer;
    property Items[Index:Integer]:ITeeEventListener read Get; default;
  end;

  TTeeMouseEventKind=(meDown,meUp,meMove);

  TTeeMouseEvent=class {$IFDEF CLR}sealed{$ENDIF} (TTeeEvent)
  public
    Event  : TTeeMouseEventKind;
    Button : TMouseButton;
    Shift  : TShiftState;
    X      : Integer;
    Y      : Integer;
  end;

  TTeeView3DEvent=class {$IFDEF CLR}sealed{$ENDIF}(TTeeEvent);

  TTeeUnits=(muPercent,muPixels);

  TTeePrintEvent=procedure(Sender:TCustomTeePanel; Canvas:TCanvas; var R:TRect) of object;

  TCustomTeePanel=class(TCustomPanelNoCaption)
  private
    FApplyZOrder      : Boolean;
    FAutoRepaint      : Boolean;  { when False, it does not refresh }
    FBorder           : TChartHiddenPen;
    FBorderRound      : Integer;
    FCancelMouse      : Boolean;  { when True, it does not finish mouse events }
    FChartBounds      : TRect;
    FChartWidth       : Integer;
    FChartHeight      : Integer;
    FChartXCenter     : Integer;
    FChartYCenter     : Integer;
    FDelphiCanvas     : TCanvas;
    FHeight3D         : Integer;
    FMargins          : TRect;
    FMarginUnits      : TTeeUnits;
    FOnBeforePrint    : TTeePrintEvent;
    FOriginalCursor   : TCursor;
    FPanning          : TZoomPanning;
    FPrinting         : Boolean;
    FPrintMargins     : TRect;
    FPrintProportional: Boolean;
    FPrintResolution  : Integer;
    FShadow           : TTeeShadow;
    FView3D           : Boolean;
    FView3DOptions    : TView3DOptions;
    FWidth3D          : Integer;

    FGLComponent      : TComponent; { internal }

    IEventListeners   : TTeeEventListeners;
    {$IFNDEF CLX}
    IRounding         : Boolean;
    {$ENDIF}
    Procedure BroadcastMouseEvent(Kind:TTeeMouseEventKind;
                                  Button: TMouseButton;
                                  Shift: TShiftState; X, Y: Integer);
    Function GetBorderStyle:TBorderStyle;
    Function GetBufferedDisplay:Boolean;
    Function GetMargin(Index:Integer):Integer;
    Function GetMonochrome:Boolean;

    {$IFDEF BCB}
    function GetPrintMargins:TRect;
    {$ENDIF}

    Procedure NonBufferDraw(ACanvas:TCanvas; Const R:TRect);
    procedure ReadBorderStyle(Reader: TReader); // obsolete
    Procedure SetBorder(const Value:TChartHiddenPen);
    Procedure SetBorderRound(Value:Integer);
    Procedure SetTheBorderStyle(Value:TBorderStyle);
    Procedure SetBufferedDisplay(Value:Boolean);
    procedure SetControlRounded;
    Procedure SetMargin(Index,Value:Integer);
    Procedure SetMarginUnits(const Value:TTeeUnits);
    Procedure SetMonochrome(Value:Boolean);
    Procedure SetShadow(Value:TTeeShadow);
    procedure SetView3D(Value:Boolean);
    procedure SetView3DOptions(Value:TView3DOptions);
  protected
    FCustomChartRect : Boolean;  // 7.07 Default is False.

    {$IFNDEF CLR}
    InternalCanvas : TCanvas3D;
    {$ENDIF}

    procedure AssignTo(Dest: TPersistent); override;
    Function BroadcastTeeEvent(Event:TTeeEvent):TTeeEvent;
    {$IFNDEF CLX}
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;

    {$IFNDEF LCL}
    procedure CreateParams(var Params: TCreateParams); override;
    {$ENDIF}

    {$ELSE}
    procedure BoundsChanged; override;
    procedure MouseLeave(AControl: TControl); override;
    {$ENDIF}
    Procedure DefineProperties(Filer:TFiler); override; // obsolete
    procedure DblClick; override; // 7.0

    {$IFNDEF CLR}
    Function GetBackColor:TColor; virtual;
    {$ENDIF}

    Procedure InternalDraw(Const UserRectangle:TRect); virtual; // abstract;

    {$IFNDEF CLR}
    property Listeners:TTeeEventListeners read IEventListeners;
    {$ENDIF}

    Procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;

    {$IFNDEF CLR}
    procedure RemoveListener(Sender:ITeeEventListener);
    {$ENDIF}

    procedure Resize; override;
    Procedure SetBooleanProperty(var Variable:Boolean; Value:Boolean);
    Procedure SetColorProperty(var Variable:TColor; Value:TColor);
    Procedure SetDoubleProperty(var Variable:Double; Const Value:Double);
    Procedure SetIntegerProperty(var Variable:Integer; Value:Integer);
    Procedure SetStringProperty(var Variable:String; Const Value:String);
    {$IFDEF CLX}
    function WidgetFlags: Integer; override;
    {$ELSE}
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    {$ENDIF}

  {$IFDEF CLR}
  public
  {$ENDIF}
    property GLComponent:TComponent read FGLComponent write FGLComponent; { internal }
  public

    // Do not make this a "property" (ie: breaks --> ChartRect.Left:=123)
    ChartRect : TRect; // The rectangle bounded by 4 axes, in pixels

    {$IFDEF CLR}
    InternalCanvas : TCanvas3D;
    {$ENDIF}

    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Procedure CalcMetaBounds( var R:TRect; Const AChartRect:TRect;
                              var WinWidth,WinHeight,ViewWidth,ViewHeight:Integer);
    Function CalcProportionalMargins:TRect;
    Function CanClip:Boolean;
    Procedure CanvasChanged(Sender:TObject); virtual;
    Function ChartPrintRect:TRect;
    Procedure CopyToClipboardBitmap; overload;
    Procedure CopyToClipboardBitmap(Const R:TRect); overload;
    Procedure CopyToClipboardMetafile(Enhanced:Boolean); overload;
    Procedure CopyToClipboardMetafile(Enhanced:Boolean; Const R:TRect); overload;
    Function TeeCreateBitmap(ABackColor:TColor; Const Rect:TRect;
                             APixelFormat:TPixelFormat=
                               {$IFDEF CLX}TeePixelFormat{$ELSE}pfDevice{$ENDIF}
                            ):TBitmap; overload;
    Function TeeCreateBitmap:TBitmap; overload;
    Procedure Draw(UserCanvas:TCanvas; Const UserRect:TRect); overload; virtual;
    Procedure Draw; overload;
    Procedure DrawPanelBevels(Rect:TRect); dynamic;
    Procedure DrawToMetaCanvas(ACanvas:TCanvas; Const Rect:TRect);

    {$IFDEF CLR}
    Function GetBackColor:TColor; virtual;
    {$ENDIF}

    Function GetCursorPos:TPoint; {$IFDEF D9}inline;{$ENDIF}
    Function GetRectangle:TRect; virtual;
    procedure Invalidate; override;
    Function IsScreenHighColor:Boolean;

    Procedure Print;
    Procedure PrintLandscape;
    Procedure PrintOrientation(AOrientation:TPrinterOrientation);
    Procedure PrintPartial(Const PrinterRect:TRect);
    Procedure PrintPartialCanvas( PrintCanvas:TCanvas;
                                  Const PrinterRect:TRect);
    Procedure PrintPortrait;
    Procedure PrintRect(Const R:TRect);

    {$IFDEF CLR}
    procedure RemoveListener(Sender:ITeeEventListener);
    {$ENDIF}

    Procedure SaveToBitmapFile(Const FileName:String); overload;
    Procedure SaveToBitmapFile(Const FileName:String; Const R:TRect); overload;
    Procedure SaveToMetafile(Const FileName:String);
    Procedure SaveToMetafileEnh(Const FileName:String);
    Procedure SaveToMetafileRect( Enhanced:Boolean; Const FileName:String;
                                  Const Rect:TRect );
    Procedure SetBrushCanvas( AColor:TColor; ABrush:TChartBrush;
                              ABackColor:TColor);
    Procedure SetInternalCanvas(NewCanvas:TCanvas3D);
    Procedure ReCalcWidthHeight;
    Function  TeeCreateMetafile(Enhanced:Boolean; Const Rect:TRect):TMetafile;

    { public properties }
    property ApplyZOrder:Boolean read FApplyZOrder write FApplyZOrder;
    property AutoRepaint:Boolean read FAutoRepaint write FAutoRepaint;  { when False, it does not refresh }
    property Border:TChartHiddenPen read FBorder write SetBorder;
    property BorderRound:Integer read FBorderRound write SetBorderRound default 0;
    property BorderStyle:TBorderStyle read GetBorderStyle write SetTheBorderStyle; // obsolete
    property BufferedDisplay:Boolean read GetBufferedDisplay
                                     write SetBufferedDisplay;
    property CancelMouse:Boolean read FCancelMouse write FCancelMouse; { when True, it does not finish mouse events }
    property Canvas:TCanvas3D read InternalCanvas write SetInternalCanvas;
    property ChartBounds:TRect read FChartBounds;
    property ChartHeight:Integer read FChartHeight;
    property ChartWidth:Integer read FChartWidth;
    property ChartXCenter:Integer read FChartXCenter;
    property ChartYCenter:Integer read FChartYCenter;

    property CustomChartRect:Boolean read FCustomChartRect write FCustomChartRect;

    property DelphiCanvas:TCanvas read FDelphiCanvas;
    property Height3D:Integer read FHeight3D write FHeight3D;
    property IPanning:TZoomPanning read FPanning;

    {$IFDEF CLR}
    property Listeners:TTeeEventListeners read IEventListeners;
    {$ENDIF}

    property OriginalCursor:TCursor read FOriginalCursor write FOriginalCursor;
    property Printing:Boolean read FPrinting write FPrinting;
    property Width3D:Integer read FWidth3D write FWidth3D;

    property PrintResolution:Integer read FPrintResolution
                                     write FPrintResolution default TeeNormalPrintDetail;
    { to be published properties }
    property MarginLeft:Integer   index 0 read GetMargin write SetMargin default TeeDefHorizMargin;
    property MarginTop:Integer    index 1 read GetMargin write SetMargin default TeeDefVerticalMargin;
    property MarginRight:Integer  index 2 read GetMargin write SetMargin default TeeDefHorizMargin;
    property MarginBottom:Integer index 3 read GetMargin write SetMargin default TeeDefVerticalMargin;
    property MarginUnits:TTeeUnits read FMarginUnits write SetMarginUnits
                                   default muPercent;

    property Monochrome:Boolean read GetMonochrome write SetMonochrome default False;
    property PrintMargins:TRect read {$IFDEF BCB}GetPrintMargins{$ELSE}FPrintMargins{$ENDIF}
                                write FPrintMargins;    { the percent of paper printer margins }
    property PrintProportional:Boolean read FPrintProportional
                                       write FPrintProportional default True;
    property Shadow:TTeeShadow read FShadow write SetShadow;
    property View3D:Boolean read FView3D write SetView3D default True;
    property View3DOptions:TView3DOptions read FView3DOptions write SetView3DOptions;

    // "Aspect" not to be published. Just an alias to View3DOptions
    property Aspect:TView3DOptions read FView3DOptions write SetView3DOptions;

    { TPanel properties }
    property Align;
    property Anchors;

    property BevelInner;
    property BevelOuter;
    property BevelWidth;

    {$IFDEF CLX}
    property Bitmap;
    {$ENDIF}

    property BorderWidth;
    property Color {$IFDEF CLX}default clBackground{$ENDIF};

    {$IFNDEF CLX}
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

    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;

    {$IFDEF K3}
    property OnMouseEnter;
    property OnMouseLeave;
    {$ELSE}
    {$IFDEF D10}
    property OnMouseEnter;
    property OnMouseLeave;
    {$ENDIF}
    {$ENDIF}

    property OnBeforePrint:TTeePrintEvent read FOnBeforePrint write FOnBeforePrint;
  published
  end;

  TChartGradient=TTeeGradient;

  TChartGradientClass=class of TChartGradient;

  TPanningMode=(pmNone,pmHorizontal,pmVertical,pmBoth);

  TTeeZoomPen=class(TChartPen) // do not seal (TeeTree)
  private
    Function IsColorStored:Boolean;
  {$IFNDEF CLR}
  protected
  {$ELSE}
  public
  {$ENDIF}
    DefaultColor : TColor;
  published
    property Color stored IsColorStored nodefault;  // 5.03
  end;

  TTeeZoomBrush=class {$IFDEF CLR}sealed{$ENDIF}(TChartBrush)
  published
    property Color default clWhite;
    property Style default bsClear;
  end;

  TTeeZoomDirection=(tzdHorizontal, tzdVertical, tzdBoth);

  TTeeZoom=class {$IFDEF CLR}sealed{$ENDIF} (TZoomPanning)
  private
    FAllow         : Boolean;
    FAnimated      : Boolean;
    FAnimatedSteps : Integer;
    FBrush         : TTeeZoomBrush;
    FDirection     : TTeeZoomDirection;
    FKeyShift      : TShiftState;
    FMinimumPixels : Integer;
    FMouseButton   : TMouseButton;
    FPen           : TTeeZoomPen;
    FUpLeftZooms   : Boolean;

    Function GetBrush:TTeeZoomBrush;
    Function GetPen:TTeeZoomPen;
    Procedure SetBrush(Value:TTeeZoomBrush);
    Procedure SetPen(Value:TTeeZoomPen);
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Assign(Source:TPersistent); override;
  published
    property Allow:Boolean read FAllow write FAllow default True;
    property Animated:Boolean read FAnimated write FAnimated default False;
    property AnimatedSteps:Integer read FAnimatedSteps write FAnimatedSteps default 8;
    property Brush:TTeeZoomBrush read GetBrush write SetBrush;
    property Direction:TTeeZoomDirection read FDirection write FDirection default tzdBoth;
    property KeyShift:TShiftState read FKeyShift write FKeyShift default [];
    property MinimumPixels:Integer read FMinimumPixels write FMinimumPixels default 16;
    property MouseButton:TMouseButton read FMouseButton write FMouseButton default mbLeft;
    property Pen:TTeeZoomPen read GetPen write SetPen;
    property UpLeftZooms:Boolean read FUpLeftZooms write FUpLeftZooms default False;
  end;

  TCustomTeePanelExtended=class;

  TTeeBackImageMode=(pbmStretch,pbmTile,pbmCenter,pbmCustom); // 7.0

  TBackImage=class(TTeePicture)  // 8.0
  private
    FInside : Boolean;
    FLeft   : Integer;
    FMode   : TTeeBackImageMode;
    FTop    : Integer;

    procedure SetInside(Const Value:Boolean);
    procedure SetLeft(Value:Integer);
    procedure SetMode(Const Value:TTeeBackImageMode);
    procedure SetTop(Value:Integer);
  public
    Constructor Create;

    procedure Assign(Source:TPersistent); override;

    procedure Draw(Panel:TCustomTeePanelExtended; Rect:TRect; Z:Integer);
  published
    property Inside:Boolean read FInside write SetInside default False;
    property Left:Integer read FLeft write SetLeft default 0;
    property Mode:TTeeBackImageMode read FMode write SetMode default pbmStretch;
    property Top:Integer read FTop write SetTop default 0;
  end;

  TCustomTeePanelExtended=class(TCustomTeePanel)
  private
    FAllowPanning      : TPanningMode;
    FGradient          : TChartGradient;
    FZoom              : TTeeZoom;
    FZoomed            : Boolean;

    { for compatibility with Tee4 }
    Function GetAllowZoom:Boolean;
    Function GetAnimatedZoom:Boolean;
    Function GetAnimatedZoomSteps:Integer;
    Function GetBackImage:TBackImage;
    Function GetBackImageInside:Boolean;
    Function GetBackImageMode:TTeeBackImageMode;
    Function GetBackImageTransp:Boolean;
    Function GetGradient:TChartGradient;

    procedure PaintBack(const ARect:TRect; AColor:TColor;
                        BorderRound:Integer=0);
    
    procedure ReadAnimatedZoomSteps(Reader: TReader);
    procedure ReadAnimatedZoom(Reader: TReader);
    procedure ReadAllowZoom(Reader: TReader);
    procedure ReadPrintMargins(Reader: TReader);
    procedure SavePrintMargins(Writer: TWriter);
    Procedure SetAllowZoom(Value:Boolean);
    Procedure SetAnimatedZoom(Value:Boolean);
    Procedure SetAnimatedZoomSteps(Value:Integer);

    procedure SetBackImage(const Value:TBackImage);
    procedure SetBackImageInside(Const Value:Boolean);
    procedure SetBackImageMode(Const Value:TTeeBackImageMode);
    procedure SetBackImageTransp(Const Value:Boolean);
    Procedure SetGradient(Value:TChartGradient);
    Procedure SetZoom(Value:TTeeZoom);
  protected
    FBackImage   : TBackImage;

    FOnAfterDraw : TNotifyEvent;
    FOnScroll    : TNotifyEvent;
    FOnUndoZoom  : TNotifyEvent;
    FOnZoom      : TNotifyEvent;
    Procedure DefineProperties(Filer:TFiler); override;
    procedure DrawBitmap(Rect:TRect; Z:Integer);
    procedure FillPanelRect(Const Rect:TRect); virtual;
    {$IFNDEF CLR}
    {$IFNDEF CLX}
    function GetPalette: HPALETTE; override;    { override the method }
    {$ENDIF}
    {$ENDIF}
    procedure PanelPaint(Const UserRect:TRect); virtual;
  public
    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Procedure DrawZoomRectangle;
    function HasBackImage:Boolean; // Returns True when has BackImage.Graphic
    procedure UndoZoom; dynamic;

    property Zoomed:Boolean read FZoomed write FZoomed;

    property AllowPanning:TPanningMode read FAllowPanning
				       write FAllowPanning default pmBoth;

    { for compatibility with Tee4 }
    property AllowZoom:Boolean read GetAllowZoom write SetAllowZoom default True;
    property AnimatedZoom:Boolean read GetAnimatedZoom
				  write SetAnimatedZoom default False;
    property AnimatedZoomSteps:Integer read GetAnimatedZoomSteps
				       write SetAnimatedZoomSteps default 8;
    {}

    property BackImage:TBackImage read GetBackImage write SetBackImage;
    property BackImageInside:Boolean read GetBackImageInside
				     write SetBackImageInside default False;
    property BackImageMode:TTeeBackImageMode read GetBackImageMode
					     write SetBackImageMode
					     default pbmStretch;
    property BackImageTransp:Boolean read GetBackImageTransp
                                     write SetBackImageTransp default False;

    property Gradient:TChartGradient read GetGradient write SetGradient;
    property Zoom:TTeeZoom read FZoom write SetZoom;

    { events }
    property OnAfterDraw:TNotifyEvent read FOnAfterDraw write FOnAfterDraw;
    property OnScroll:TNotifyEvent read FOnScroll write FOnScroll;
    property OnUndoZoom:TNotifyEvent read FOnUndoZoom write FOnUndoZoom;
    property OnZoom:TNotifyEvent read FOnZoom write FOnZoom;
  end;

  TChartBrushClass=class of TChartBrush;

  TTeeCustomShapeBrushPen=class(TPersistent)
  private
    FBrush   : TChartBrush;
    FParent  : TCustomTeePanel;
    FPen     : TChartPen;
    FVisible : Boolean;

    Procedure SetBrush(Value:TChartBrush);
    Procedure SetPen(Value:TChartPen);
    Procedure SetVisible(Value:Boolean);
  protected
    Procedure CanvasChanged(Sender:TObject);
    Function GetBrushClass:TChartBrushClass; dynamic;
    Procedure SetParent(Value:TCustomTeePanel); virtual;
  public
    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Procedure Show; {$IFDEF D9}inline;{$ENDIF}
    Procedure Hide; {$IFDEF D9}inline;{$ENDIF}
    Procedure Repaint; {$IFDEF D9}inline;{$ENDIF}

    property Brush:TChartBrush read FBrush write SetBrush;
    property Frame:TChartPen read FPen write SetPen; // alias obsolete
    property ParentChart:TCustomTeePanel read FParent write SetParent;
    property Pen:TChartPen read FPen write SetPen;
    property Visible:Boolean read FVisible write SetVisible;
  end;

  TChartObjectShapeStyle=(fosRectangle,fosRoundRectangle,fosEllipse);

  TTextFormat=(ttfNormal, ttfHtml);

  TTeeCustomShape=class(TTeeCustomShapeBrushPen)
  private
    FBevel        : TPanelBevel;
    FBevelWidth   : TBevelWidth;
    FColor        : TColor;
    FFont         : TTeeFont;
    FRoundSize    : Integer;
    FShadow       : TTeeShadow;
    FShapeStyle   : TChartObjectShapeStyle;
    FTextFormat   : TTextFormat;
    FTransparent  : Boolean;

    Function GetGradient:TChartGradient;
    Function GetHeight:Integer;
    Function GetWidth:Integer;
    Function GetPicture:TBackImage;
    Function GetShadowColor:TColor; // obsolete
    Function GetShadowSize:Integer; // obsolete

    Function IsTranspStored:Boolean;

    procedure ReadShadowColor(Reader: TReader); // obsolete
    procedure ReadShadowSize(Reader: TReader); // obsolete

    Procedure PictureChanged(Sender:TObject);
    Procedure SetBevel(Value:TPanelBevel);
    procedure SetBevelWidth(Value: TBevelWidth);
    Procedure SetColor(Value:TColor);
    Procedure SetFont(Value:TTeeFont);
    procedure SetGradient(Value:TChartGradient);
    procedure SetHeight(Value:Integer);
    Procedure SetPicture(Value:TBackImage);
    procedure SetRoundSize(Value:Integer);
    Procedure SetShadow(Value:TTeeShadow);
    Procedure SetShadowColor(Value:TColor); // obsolete
    Procedure SetShadowSize(Value:Integer); // obsolete
    Procedure SetShapeStyle(Value:TChartObjectShapeStyle);
    procedure SetTextFormat(Value:TTextFormat);
    procedure SetTransparency(Value:TTeeTransparency);
    procedure SetTransparent(Value:Boolean);
    procedure SetWidth(Value:Integer);
  protected
    {$IFNDEF CLR}
    DefaultTransparent : Boolean;
    {$ENDIF}

    FGradient     : TChartGradient;
    FPicture      : TBackImage;
    FTransparency : TTeeTransparency;

    Procedure DefineProperties(Filer:TFiler); override;
    Function GetGradientClass:TChartGradientClass; dynamic;
    procedure InitShadow(AShadow:TTeeShadow); dynamic;
    property Transparency:TTeeTransparency read FTransparency
                                           write SetTransparency default 0;
  public
    {$IFDEF CLR}
    DefaultTransparent : Boolean;  // to avoid .Net typecast
    {$ENDIF}

    // Do not make this a property (it can't be accessed ie: ShapeBounds.Left:=123)
    ShapeBounds : TRect;

    Constructor Create(AOwner: TCustomTeePanel); overload; virtual;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Procedure Draw;
    Procedure DrawRectRotated(Rect:TRect; Angle:Integer=0; AZ:Integer=0); overload;
    Procedure DrawRectRotated(Panel:TCustomTeePanel; Rect:TRect;
                              Angle:Integer=0; AZ:Integer=0); overload;

    // compatibility with TeeChart v5  (obsolete)
    property ShadowColor:TColor read GetShadowColor write SetShadowColor default clBlack;
                               // {$IFDEF D11}deprecated 'Please use Shadow.Color property.';{$ENDIF}

    property ShadowSize:Integer read GetShadowSize write SetShadowSize default 3;
                               // {$IFDEF D11}deprecated 'Please use Shadow.Size property.';{$ENDIF}

    // public properties
    property Height:Integer read GetHeight write SetHeight;
    property Width:Integer read GetWidth write SetWidth;

    // to be published
    property Bevel:TPanelBevel read FBevel write SetBevel default bvNone;
    property BevelWidth:TBevelWidth read FBevelWidth write SetBevelWidth default 2;
    property Color:TColor read FColor write SetColor default clWhite;
    property Font:TTeeFont read FFont write SetFont;
    property Gradient:TChartGradient read GetGradient write SetGradient;
    property Picture:TBackImage read GetPicture write SetPicture;
    property RoundSize:Integer read FRoundSize write SetRoundSize default 16;
    property Shadow:TTeeShadow read FShadow write SetShadow;

    property ShapeStyle:TChartObjectShapeStyle read FShapeStyle
                                   write SetShapeStyle default fosRectangle;
    property TextFormat:TTextFormat read FTextFormat write SetTextFormat default ttfNormal;
    property Transparent:Boolean read FTransparent write SetTransparent stored IsTranspStored;
  end;

  TTeeShape=class(TTeeCustomShape)
  public
    property Transparency;
  published
    property Bevel;
    property BevelWidth;
    property Color;
    property Font;
    property Gradient;
    property Picture;
    property RoundSize;
    property Shadow;
    property ShapeStyle;
    property Transparent;
    property Visible;
  end;

  TeeString256=Array[0..255] of Char;

  // Used at TeExport, TeeStore and TeeTree export dialog.
  TTeeExportData=class(TPersistent)
  public
    Function AsString:String; virtual; // abstract;
    Procedure CopyToClipboard; dynamic;
    Procedure SaveToFile(Const FileName:String); dynamic;
    Procedure SaveToStream(AStream:TStream); dynamic;
  end;

Function TeeStr(const Num:Integer):String; // same as IntToStr but a bit faster

{ returns the appropiate string date or time format according to "step" }
Function DateTimeDefaultFormat(Const AStep:Double):String;

{ returns the number of days of month-year }
Function DaysInMonth(Year,Month:Word):Word;

{ Given a "step", return the corresponding set element }
Function FindDateTimeStep(Const StepValue:Double):TDateTimeStep;

{ Returns the next "step" in ascending order. (eg: TwoDays follows OneDay }
Function NextDateTimeStep(Const AStep:Double):Double;

{ Returns True if point T is over line:  P --> Q }
Function PointInLine(Const P:TPoint; const px,py,qx,qy:Integer):Boolean; overload;
Function PointInLine(Const P,FromPoint,ToPoint:TPoint):Boolean; overload;

{ Returns True if point T is over (more or less "Tolerance" pixels)
  line:  P --> Q }
Function PointInLine(const P,FromPoint,ToPoint:TPoint; const TolerancePixels:Integer):Boolean; overload; // obsolete;
Function PointInLine(const P:TPoint; const px,py,qx,qy,TolerancePixels:Integer):Boolean; overload;

Function PointInLineTolerance(Const P:TPoint;
                              Const px,py,qx,qy,TolerancePixels:Integer):Boolean;
                              {$IFDEF D11}deprecated 'Please use PointInLine function.';{$ENDIF}

{ Returns True if point P is inside Poly polygon }
Function PointInPolygon(Const P:TPoint; Const Poly:Array of TPoint):Boolean;

{ Returns True if point P is inside the triangle formed with P0,P1 and P2 }
Function PointInTriangle(Const P,P0,P1,P2:TPoint):Boolean; overload; {$IFDEF D9}inline;{$ENDIF}

{ Returns True if point P is inside the vert triangle of x0y0, midxY1, x1y0 }
Function PointInTriangle(Const P:TPoint; X0,X1,Y0,Y1:Integer):Boolean; overload;

{ Returns True if point P is inside the horiz triangle of x0y0, x1midY, x0y0 }
Function PointInHorizTriangle(Const P:TPoint; Y0,Y1,X0,X1:Integer):Boolean;

{ Returns True if point P is inside the ellipse bounded by Rect }
Function PointInEllipse(Const P:TPoint; Const Rect:TRect):Boolean; overload;
Function PointInEllipse(Const P:TPoint; Left,Top,Right,Bottom:Integer):Boolean; overload;

{ This functions try to solve locale problems with formatting numbers }
Function DelphiToLocalFormat(Const Format:String):String;
Function LocalToDelphiFormat(Const Format:String):String;

{ For all controls in the array, set the Enabled property }
Procedure EnableControls(Enable:Boolean; Const ControlArray:Array of TControl);

{ Round "ADate" to the nearest "AStep" value }
Function TeeRoundDate(Const ADate:TDateTime; AStep:TDateTimeStep):TDateTime;

{ Increment or Decrement "Value", for DateTime and not-DateTime }
Procedure TeeDateTimeIncrement( IsDateTime:Boolean;
                                Increment:Boolean;
                                var Value:Double;
                                Const AnIncrement:Double;
                                tmpWhichDateTime:TDateTimeStep);


{ Generic "QuickSort" sorting algorithm }
type TTeeSortCompare=Function(a,b:Integer):Integer of object;
     TTeeSortSwap=Procedure(a,b:Integer) of object;

Procedure TeeSort( StartIndex,EndIndex:Integer;
                   CompareFunc:TTeeSortCompare;
                   SwapFunc:TTeeSortSwap);

{ Returns a valid component name }
Function TeeGetUniqueName(AOwner:TComponent; Const AStartName:String):TComponentName;

{ Delimited field routines }
var
  TeeFieldsSeparator:String=';';

{ Returns the "index" item in string, using "TeeFieldsSeparator" character }
Function TeeExtractField(St:String; Index:Integer):String; overload;

{ Returns the "index" item in string, using "Separator" parameter }
Function TeeExtractField(St:String; Index:Integer; const Separator:String):String; overload;

{ Returns the number of fields in string, using "TeeFieldsSeparator" character }
Function TeeNumFields(St:String):Integer; overload;
{ Returns the number of fields in string, using "Separator" parameter }
Function TeeNumFields(const St,Separator:String):Integer; overload;

{ Try to find a resource bitmap and load it }
Procedure TeeGetBitmapEditor(AObject:TObject; var Bitmap:TBitmap);
Procedure TeeLoadBitmap(Bitmap:TBitmap; Const Name1,Name2:String);

type TColorArray=Array of TColor;

{ returns one of the sample colors in default ColorPalette constant array }
Function GetDefaultColor(Const Index:Integer):TColor;

// Resets ColorPalette to default one.
Procedure SetDefaultColorPalette; overload;
Procedure SetDefaultColorPalette(const Palette:Array of TColor); overload;

var
  ColorPalette:TColorArray;

const
  TeeBorderStyle={$IFDEF CLX}fbsDialog{$ELSE}bsDialog{$ENDIF};

  TeeCheckBoxSize=11; { for TChart Legend }

  { Keyboard codes }
  TeeKey_Escape = {$IFDEF CLX}Key_Escape {$ELSE}VK_ESCAPE{$ENDIF};
  TeeKey_Up     = {$IFDEF CLX}Key_Up     {$ELSE}VK_UP{$ENDIF};
  TeeKey_Down   = {$IFDEF CLX}Key_Down   {$ELSE}VK_DOWN{$ENDIF};
  TeeKey_Insert = {$IFDEF CLX}Key_Insert {$ELSE}VK_INSERT{$ENDIF};
  TeeKey_Delete = {$IFDEF CLX}Key_Delete {$ELSE}VK_DELETE{$ENDIF};
  TeeKey_Left   = {$IFDEF CLX}Key_Left   {$ELSE}VK_LEFT{$ENDIF};
  TeeKey_Right  = {$IFDEF CLX}Key_Right  {$ELSE}VK_RIGHT{$ENDIF};
  TeeKey_Return = {$IFDEF CLX}Key_Return {$ELSE}VK_RETURN{$ENDIF};
  TeeKey_Space  = {$IFDEF CLX}Key_Space  {$ELSE}VK_SPACE{$ENDIF};
  TeeKey_Back   = {$IFDEF CLX}Key_BackSpace {$ELSE}VK_BACK{$ENDIF};

  TeeKey_F1     = {$IFDEF CLX}Key_F1     {$ELSE}VK_F1{$ENDIF};
  TeeKey_F2     = {$IFDEF CLX}Key_F2     {$ELSE}VK_F2{$ENDIF};
  TeeKey_F3     = {$IFDEF CLX}Key_F3     {$ELSE}VK_F3{$ENDIF};
  TeeKey_F4     = {$IFDEF CLX}Key_F4     {$ELSE}VK_F4{$ENDIF};
  TeeKey_F5     = {$IFDEF CLX}Key_F5     {$ELSE}VK_F5{$ENDIF};
  TeeKey_F6     = {$IFDEF CLX}Key_F6     {$ELSE}VK_F6{$ENDIF};
  TeeKey_F7     = {$IFDEF CLX}Key_F7     {$ELSE}VK_F7{$ENDIF};
  TeeKey_F8     = {$IFDEF CLX}Key_F8     {$ELSE}VK_F8{$ENDIF};
  TeeKey_F9     = {$IFDEF CLX}Key_F9     {$ELSE}VK_F9{$ENDIF};
  TeeKey_F10    = {$IFDEF CLX}Key_F10    {$ELSE}VK_F10{$ENDIF};
  TeeKey_F11    = {$IFDEF CLX}Key_F11    {$ELSE}VK_F11{$ENDIF};
  TeeKey_F12    = {$IFDEF CLX}Key_F12    {$ELSE}VK_F12{$ENDIF};

Procedure TeeDrawCheckBox( x,y:Integer; Canvas:TCanvas; Checked:Boolean;
                           ABackColor:TColor; CheckBox:Boolean=True);

{$IFNDEF D6}
function StrToFloatDef(const S: string; const Default: Extended): Extended;
function TryStrToFloat(const S: String; var Value:Double):Boolean;
{$ENDIF}

{ Returns True if line1 and line2 cross each other.
  xy is returned with crossing point. }
function CrossingLines(const X1,Y1,X2,Y2,X3,Y3,X4,Y4:Double; out x,y:Double):Boolean;

// TRANSLATIONS
type
  TTeeTranslateHook=procedure(AControl:TControl; const ExcludedChilds:Array of TControl);

var
  TeeTranslateHook:TTeeTranslateHook=nil;

// Main procedure to translate a control (or Form)
Procedure TeeTranslateControl(AControl:TControl); overload;
Procedure TeeTranslateControl(AControl:TControl; const ExcludeChilds:Array of TControl); overload;

// Replaces "Search" char with "Replace" char
// in all occurrences in AString parameter.
// Returns "AString" with replace characters.
Function ReplaceChar(const AString:String; const Search:{$IFDEF NET}String{$ELSE}Char{$ENDIF};
                     const Replace:Char=#0):String;

// Returns "P" calculating 4 rotated corners using Angle parameter
// Note: Due to a C++ Builder v5 bug, this procedure is not a function.
Procedure RectToFourPoints(Const ARect:TRect; const Angle:Double; var P:TFourPoints);

Function TeeAntiAlias(Panel:TCustomTeePanel; ChartRect:Boolean=False):TBitmap;

Procedure DrawBevel(Canvas:TTeeCanvas; Bevel:TPanelBevel; var R:TRect;
                    Width:Integer; Round:Integer=0);


function ScreenRatio(ACanvas:TCanvas3D):Double;

// Internal use. Reads and saves values from / to TRegistry / Inifile
// Used by TGalleryPanel, TChartEditor, TeeChartReg unit and TeeDesignOptions
function TeeReadBoolOption(const AKey:String; DefaultValue:Boolean):Boolean;
procedure TeeSaveBoolOption(const AKey:String; Value:Boolean);
Function TeeReadIntegerOption(const AKey:String; DefaultValue:Integer):Integer;
procedure TeeSaveIntegerOption(const AKey:String; Value:Integer);
function TeeReadStringOption(const AKey,DefaultValue:String):String;
procedure TeeSaveStringOption(const AKey,Value:String);

function TeeDefaultXMLEncoding:String;

// Converts a Stream with a *.tee file in Text format, to XML format
procedure ConvertTextToXML(Stream:TStream; XMLHeader:Boolean=True);

type
  TeeWindowHandle={$IFDEF CLX}QOpenScrollViewH{$ELSE}Integer{$ENDIF};

Procedure TeeGotoURL(Handle: TeeWindowHandle; Const URL:String);

{$IFDEF CLR}
var
  HInstance : THandle=0;  // WORKAROUND..pending.
{$ENDIF}

{$IFDEF LCL}
const
  CM_SHOWINGCHANGED = CM_BASE + 25;
{$ENDIF}

implementation

Uses {$IFDEF CLR}
     System.Runtime.InteropServices,
     System.Reflection,
     System.IO,
     System.Drawing,
     {$ENDIF}

     {$IFNDEF D5}
     {$IFNDEF LCL}
     DsgnIntf,
     {$ENDIF}
     {$ENDIF}

     Math, TypInfo,

     {$IFDEF LINUX}
     IniFiles,
     {$ELSE}
     Registry,
     {$ENDIF}

     {$IFNDEF LINUX}
     ShellApi,
     {$ENDIF}
     
     TeeConst;

{.$DEFINE MONITOR_REDRAWS}

{$IFDEF MONITOR_REDRAWS}
var RedrawCount:Integer=0;
{$ENDIF}

{$IFNDEF CLR}
{$R TeeResou.res}
{$ENDIF}

{$IFDEF CLX}
Const
  LOGPIXELSX = 0;
  LOGPIXELSY = 1;
{$ENDIF}

var
  Tee19000101:TDateTime=0; { Optimization for TeeRoundDate function, 5.02 }

{ Same as IntToStr but faster }
Function TeeStr(const Num:Integer):String; {$IFDEF D9}inline;{$ENDIF}
begin
  Str(Num,Result);
end;

// Returns one of the sample colors in default ColorPalette constant array
Function GetDefaultColor(Const Index:Integer):TColor;
Begin
  result:=ColorPalette[Low(ColorPalette)+(Index mod Succ(High(ColorPalette)))]; // 6.02
end;

{$IFDEF D5}
Function DaysInMonth(Year,Month:Word):Word;
begin
  result:=MonthDays[IsLeapYear(Year),Month]
end;
{$ELSE}
Function DaysInMonth(Year,Month:Word):Word;
Const DaysMonths:Array[1..12] of Byte=(31,28,31,30,31,30,31,31,30,31,30,31);
Begin
  result:=DaysMonths[Month];
  if (Month=2) and IsLeapYear(Year) then Inc(result);
End;
{$ENDIF}

Function DateTimeDefaultFormat(Const AStep:Double):String; {$IFDEF D9}inline;{$ENDIF}
Begin
  if AStep<=1 then result:=ShortTimeFormat
              else result:=ShortDateFormat;
end;

Function NextDateTimeStep(Const AStep:Double):Double;
var t : TDateTimeStep;
Begin
  for t:=Pred(dtOneYear) downto Low(DateTimeStep) do
  if AStep>=DateTimeStep[t] then
  Begin
    result:=DateTimeStep[Succ(t)];
    exit;
  end;
  result:=DateTimeStep[dtOneYear];
end;

Function FindDateTimeStep(Const StepValue:Double):TDateTimeStep;
var Min : Double;
begin
  Min:=DateTimeStep[Low(DateTimeStep)];
  for result:=Pred(High(DateTimeStep)) downto Low(DateTimeStep) do
      if Abs(DateTimeStep[result]-StepValue)<Min then
         exit;

  result:=dtNone;
end;

{ draw a simulated checkbox on Canvas }
Procedure TeeDrawCheckBox( x,y:Integer; Canvas:TCanvas; Checked:Boolean;
                           ABackColor:TColor; CheckBox:Boolean=True);

  {$IFDEF CLX}
  Procedure DoHorizLine(x1,x2,y:Integer);
  begin
    with Canvas do
    begin
      MoveTo(x1,y);
      LineTo(x2,y);
    end;
  end;

  Procedure DoVertLine(x,y1,y2:Integer);
  begin
    with Canvas do
    begin
      MoveTo(x,y1);
      LineTo(x,y2);
    end;
  end;
  {$ENDIF}

var t : Integer;
begin
  {$IFNDEF CLX}
  if CheckBox then t:=DFCS_BUTTONCHECK
              else t:=DFCS_BUTTONRADIO;

  if Checked then
     t:=t or DFCS_CHECKED;

  DrawFrameControl(Canvas.Handle,Bounds(x,y,13,13),DFC_BUTTON,t);

  {$ELSE}
  With Canvas do
  begin
    // RadioButton ????

    Pen.Style:=psSolid;
    Pen.Width:=1;
    Pen.Color:=clGray;
    DoHorizLine(x+TeeCheckBoxSize,x,y);
    LineTo(x,y+TeeCheckBoxSize+1);
    ABackColor:=ColorToRGB(ABackColor);
    if (ABackColor=clWhite) {$IFDEF CLX}or (ABackColor=1){$ENDIF} then
        Pen.Color:=clSilver
    else
        Pen.Color:=clWhite;
    DoHorizLine(x,x+TeeCheckBoxSize+1,y+TeeCheckBoxSize+1);

    LineTo(x+TeeCheckBoxSize+1,y-1);
    Pen.Color:=clBlack;
    DoHorizLine(x+TeeCheckBoxSize-1,x+1,y+1);
    LineTo(x+1,y+TeeCheckBoxSize);

    Brush.Style:=bsSolid;
    Brush.Color:=clWindow;
    Pen.Style:=psClear;
    Rectangle(x+2,y+2,x+TeeCheckBoxSize+1,y+TeeCheckBoxSize+1);

    if Checked then
    begin
      Pen.Style:=psSolid;
      Pen.Color:=clWindowText;
      for t:=1 to 3 do DoVertLine(x+2+t,y+4+t,y+7+t);
      for t:=1 to 4 do DoVertLine(x+5+t,y+7-t,y+10-t);
    end;
  end;
  {$ENDIF}
end;

{ TCustomPanelNoCaption }
Constructor TCustomPanelNoCaption.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle:=ControlStyle-[csSetCaption {$IFDEF CLX},csNoFocus{$ENDIF} ];
end;

{$IFNDEF CLR}
type
  TChartPenAccess=class(TChartPen);
{$ENDIF}

{ TCustomTeePanel }
Constructor TCustomTeePanel.Create(AOwner: TComponent);
begin
  inherited;
  IEventListeners:=TTeeEventListeners.Create;

  Width := 400;
  Height:= 250;

  FApplyZOrder :=True;
  FDelphiCanvas:=inherited Canvas;

  FView3D      :=True;
  FView3DOptions:=TView3DOptions.Create({$IFDEF TEEVCL}Self{$ENDIF});

  InternalCanvas:=TTeeCanvas3D.Create;
  InternalCanvas.ReferenceCanvas:=FDelphiCanvas;

  FMargins:= TeeRect( TeeDefHorizMargin,TeeDefVerticalMargin,
                      TeeDefHorizMargin,TeeDefVerticalMargin);
  FPrintProportional:=True;
  FPrintResolution:=TeeNormalPrintDetail;

  FPrintMargins.Left:=TeeDefault_PrintMargin;
  FPrintMargins.Right:=TeeDefault_PrintMargin;
  FPrintMargins.Top:=TeeDefault_PrintMargin;
  FPrintMargins.Bottom:=TeeDefault_PrintMargin;

  FOriginalCursor:=Cursor;
  FPanning:=TZoomPanning.Create;

  FShadow:=TTeeShadow.Create(CanvasChanged);
  FBorder:=TChartHiddenPen.Create(CanvasChanged);
  FBorder.EndStyle:=esFlat;

  {$IFDEF CLR}
  FBorder.DefaultEnd:=esFlat;
  {$ELSE}
  TChartPenAccess(FBorder).DefaultEnd:=esFlat;
  {$ENDIF}

  if TeeEraseBack then
     TeeEraseBack:=not (csDesigning in ComponentState);

  AutoRepaint:=True;

  {$IFDEF CLX}
  // Avoid flicker when resizing or repainting 
  QWidget_setBackgroundMode(Handle,QWidgetBackgroundMode_NoBackground);
  {$ENDIF}
end;

Destructor TCustomTeePanel.Destroy;
Begin
  FreeAndNil(InternalCanvas);
  FBorder.Free;
  FShadow.Free;
  FView3DOptions.Free;
  FPanning.Free;
  FreeAndNil(IEventListeners);
  inherited;
end;

Procedure TCustomTeePanel.CanvasChanged(Sender:TObject);
Begin
  Invalidate;
end;

{$IFNDEF CLX}
{$IFNDEF LCL}
procedure TCustomTeePanel.CreateParams(var Params: TCreateParams);
begin
  inherited;

// OpenGL:
// Params.WindowClass.Style:=Params.WindowClass.Style or CS_OWNDC;

  if Color=clNone then
     Params.ExStyle:=Params.ExStyle or WS_EX_TRANSPARENT; { 5.02 }

  InternalCanvas.View3DOptions:=nil;
end;
{$ENDIF}
{$ENDIF}

Procedure TCustomTeePanel.SetShadow(Value:TTeeShadow);
begin
  FShadow.Assign(Value);
end;

Procedure TCustomTeePanel.InternalDraw(Const UserRectangle:TRect); // virtual; abstract;
begin
end;

procedure TCustomTeePanel.SetView3DOptions(Value:TView3DOptions);
begin
  FView3DOptions.Assign(Value);
end;

procedure TCustomTeePanel.SetView3D(Value:Boolean);
Begin
  if FView3D<>Value then // 6.0
  begin
    SetBooleanProperty(FView3D,Value);
    BroadcastTeeEvent(TTeeView3DEvent.Create).Free;
  end;
end;

Procedure TCustomTeePanel.Draw;
begin
  Draw(FDelphiCanvas,GetClientRect);
end;

type
  TCanvasAccess=class {$IFDEF CLR}sealed{$ENDIF} (TTeeCanvas3D);

Procedure TCustomTeePanel.Draw(UserCanvas:TCanvas; Const UserRect:TRect);

  Procedure AdjustChartBounds;

    Function GetMargin(Value,Range:Integer):Integer;
    begin
      if MarginUnits=muPercent then result:=Value*Range div 100
                               else result:=Value;
    end;

  var tmpW : Integer;
      tmpH : Integer;
      tmpBorder : Integer;
  begin
    RectSize(FChartBounds,tmpW,tmpH);

    // Calculate amount of pixels for border and bevels...
    tmpBorder:=BorderWidth;

    //if Shadow.Visible then Inc(tmpBorder,Shadow.Size);
    if BevelInner<>bvNone then Inc(tmpBorder,BevelWidth);
    if BevelOuter<>bvNone then Inc(tmpBorder,BevelWidth);
    if Border.Visible then Inc(tmpBorder,Border.Width);

    // Apply margins
    if not CustomChartRect then
    With FChartBounds do
    begin
      ChartRect:=TeeRect( Left  + tmpBorder + GetMargin(MarginLeft,tmpW),
                          Top   + tmpBorder + GetMargin(MarginTop,tmpH),
                          Right - tmpBorder - GetMargin(MarginRight,tmpW),
                          Bottom- tmpBorder - GetMargin(MarginBottom,tmpH) );

      if Shadow.Visible then
      begin
        Dec(ChartRect.Right, 2*Shadow.HorizSize);
        Dec(ChartRect.Bottom, 2*Shadow.VertSize);
      end;
    end;

  end;

Begin
  {$IFDEF CLX}
  UserCanvas.Start;
  try
  {$ENDIF}

  FChartBounds:=InternalCanvas.InitWindow(UserCanvas,FView3DOptions,Color,FView3D,UserRect);

  AdjustChartBounds;
  RecalcWidthHeight;
  InternalDraw(FChartBounds);

  {$IFDEF MONITOR_REDRAWS}
  Inc(RedrawCount);
  InternalCanvas.TextAlign:=TA_LEFT;
  InternalCanvas.Font.Size:=8;
  TCanvasAccess(InternalCanvas).IFont:=nil;
  InternalCanvas.TextOut(0,0,TeeStr(RedrawCount));
  {$ENDIF}

  InternalCanvas.ShowImage(UserCanvas,FDelphiCanvas,UserRect);

  {$IFDEF CLX}
  finally
    UserCanvas.Stop;
  end;
  {$ENDIF}
end;

procedure TCustomTeePanel.Paint;

  {$IFDEF TEEOCX}
  procedure TeeFpuInit;
  asm
    FNINIT
    FWAIT
    FLDCW   Default8087CW
  end;
  {$ENDIF}

begin
  {$IFDEF TEEOCX}
  TeeFPUInit;
  {$ENDIF}

  {$IFDEF CLX}
  if csDestroying in ComponentState then Exit;
  {$ENDIF}
  
  if (not FPrinting) and (not InternalCanvas.ReDrawBitmap) then Draw;
end;

{$IFDEF TEE_METAFILE}
type
  TMetafileCanvas=class(TCanvas)
  public
    Constructor Create(Meta:TMetafile; Ref:Integer);
  end;

{ TMetafileCanvas }
Constructor TMetafileCanvas.Create(Meta: TMetafile; Ref: Integer);
begin
  inherited Create;
end;
{$ENDIF}

Function TCustomTeePanel.TeeCreateMetafile( Enhanced:Boolean; Const Rect:TRect ):TMetafile;
var tmpCanvas : TMetafileCanvas;
begin
  result:=TMetafile.Create;
  { bug in Delphi 3.02 : graphics.pas metafile reduces width/height.
    Fixed in Delphi 4.0x and BCB4.  }
  result.Width :=Max(1,Rect.Right-Rect.Left);
  result.Height:=Max(1,Rect.Bottom-Rect.Top);
  result.Enhanced:=Enhanced;
  tmpCanvas:=TMetafileCanvas.Create(result,0);
  try
    DrawToMetaCanvas(tmpCanvas,Rect);
  finally
    tmpCanvas.Free;
  end;
end;

Procedure TCustomTeePanel.SetBrushCanvas( AColor:TColor; ABrush:TChartBrush;
                                          ABackColor:TColor);
begin
  if (ABrush.Style<>bsSolid) and (AColor=ABackColor) then
     if ABackColor=clBlack then
        AColor:=clWhite
     else
        AColor:=clBlack;

  Canvas.AssignBrush(ABrush,AColor,ABackColor);
end;

Function TeeGetDeviceCaps(Handle:{$IFDEF CLX}QPaintDeviceH
                                 {$ELSE}TTeeCanvasHandle
                                 {$ENDIF}; Cap:Integer):Integer;
begin
  {$IFDEF CLX}
  case Cap of
    HORZSIZE: result:=Screen.Width;
    VERTSIZE: result:=Screen.Height;
  else
    result:=1;
  end;
  {$ELSE}
  result:=GetDeviceCaps(Handle,Cap);
  {$ENDIF}
end;

function IsRemoteSession:Boolean;
begin
  {$IFDEF CLX}
  result:=False;
  {$ELSE}
  result:=GetSystemMetrics($1000)<>0;
  {$ENDIF}
end;

function ScreenRatio(ACanvas:TCanvas3D):Double;
var tmpH : Integer;
begin
  // if not IsRemoteSession then ...  // <-- check for Remote Desktop

  tmpH:=TeeGetDeviceCaps({$IFDEF CLX}nil{$ELSE}ACanvas.Handle{$ENDIF},VERTSIZE);

  if tmpH<>0 then
     result:=1.0*TeeGetDeviceCaps({$IFDEF CLX}nil{$ELSE}ACanvas.Handle{$ENDIF},HORZSIZE)/tmpH
  else
     result:=0;
end;

Function TCustomTeePanel.IsScreenHighColor:Boolean;
Begin
  {$IFNDEF CLX}
  With InternalCanvas do
    result:= SupportsFullRotation
             or
             (TeeGetDeviceCaps(Handle,BITSPIXEL)*
              TeeGetDeviceCaps(Handle,PLANES)>=15);
  {$ELSE}
  result:=True;
  {$ENDIF}
End;

Function TCustomTeePanel.CanClip:Boolean;
begin
  result:= (not Canvas.SupportsFullrotation) and
          (
            ((not Printing) and (not Canvas.Metafiling)) or
            (Printing and TeeClipWhenPrinting) or
            (Canvas.Metafiling and TeeClipWhenMetafiling)
          )
end;

Procedure TCustomTeePanel.SetStringProperty(var Variable:String; Const Value:String);
Begin
  if Variable<>Value then
  begin
    Variable:=Value; Invalidate;
  end;
end;

Procedure TCustomTeePanel.SetDoubleProperty(var Variable:Double; Const Value:Double);
begin
  if Variable<>Value then
  begin
    Variable:=Value; Invalidate;
  end;
end;

Procedure TCustomTeePanel.SetColorProperty(var Variable:TColor; Value:TColor);
Begin
  if Variable<>Value then
  begin
    Variable:=Value; Invalidate;
  end;
end;

Procedure TCustomTeePanel.SetBooleanProperty(var Variable:Boolean; Value:Boolean);
Begin
  if Variable<>Value then
  begin
    Variable:=Value; Invalidate;
  end;
end;

Procedure TCustomTeePanel.SetIntegerProperty(var Variable:Integer; Value:Integer);
Begin
  if Variable<>Value then
  begin
    Variable:=Value; Invalidate;
  end;
end;

procedure TCustomTeePanel.ReadBorderStyle(Reader: TReader); // obsolete
begin
  Border.Visible:=Reader.ReadIdent='bsSingle';
end;

Procedure TCustomTeePanel.DefineProperties(Filer:TFiler); // obsolete
begin
  inherited;
  Filer.DefineProperty('BorderStyle',ReadBorderStyle,nil,False);
end;

Function TCustomTeePanel.GetBackColor:TColor;
begin
  result:=Color;
end;

Procedure TCustomTeePanel.Loaded;
begin
  inherited;
  FOriginalCursor:=Cursor; { save cursor }
  if BorderRound>0 then  // 6.01
     SetControlRounded;
end;

{$IFDEF CLX}
procedure TCustomTeePanel.BoundsChanged;
begin
  inherited;
  Invalidate;
end;
{$ENDIF}

{$IFDEF CLX}
procedure TCustomTeePanel.MouseLeave(AControl: TControl);
{$ELSE}
procedure TCustomTeePanel.CMMouseLeave(var Message: TMessage);
{$ENDIF}
begin
  Cursor:=FOriginalCursor;
  FPanning.Active:=False;
  inherited;
end;

{$IFNDEF CLX}
procedure TCustomTeePanel.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TCustomTeePanel.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result:=Message.Result or DLGC_WANTARROWS;
end;

procedure TCustomTeePanel.WMEraseBkgnd(var Message: TWmEraseBkgnd);
Begin
  if TeeEraseBack then Inherited;
  Message.Result:=1;
End;
{$ENDIF}

procedure TCustomTeePanel.Invalidate;
begin
  if AutoRepaint then
  begin
    if Assigned(InternalCanvas) then InternalCanvas.Invalidate;
    inherited;
  end;
end;

procedure TCustomTeePanel.AssignTo(Dest: TPersistent);
var tmp : TBitmap;
begin
  if (Dest is TGraphic) or (Dest is TPicture) then
  begin
    tmp:=TeeCreateBitmap;
    try
      Dest.Assign(tmp);
    finally
      tmp.Free;
    end;
  end
  else inherited;
end;

procedure TCustomTeePanel.RemoveListener(Sender:ITeeEventListener);
begin
  if Assigned(IEventListeners) then IEventListeners.Remove(Sender);
end;

procedure TCustomTeePanel.Resize;
begin
  if (not (csLoading in ComponentState)) and (BorderRound>0) then
     SetControlRounded;
  inherited;
end;

Function TCustomTeePanel.BroadcastTeeEvent(Event:TTeeEvent):TTeeEvent;
var t   : Integer;
    tmp : ITeeEventListener;
begin
  result:=Event;
  if not (csDestroying in ComponentState) then
  begin
    Event.Sender:=Self;

    t:=0;
    while t<Listeners.Count do
    begin
      tmp:=Listeners[t];
      tmp.TeeEvent(Event);

      if (Event is TTeeMouseEvent) and CancelMouse then
         break;  { 5.01 }

      Inc(t);
    end;
  end;
end;

procedure TCustomTeePanel.BroadcastMouseEvent(Kind:TTeeMouseEventKind;
                                           Button: TMouseButton;
                                           Shift: TShiftState; X, Y: Integer);
var tmp : TTeeMouseEvent;
begin
  if Listeners.Count>0 then
  begin
    tmp:=TTeeMouseEvent.Create;
    try
      tmp.Event:=Kind;
      tmp.Button:=Button;
      tmp.Shift:=Shift;
      tmp.X:=X;
      tmp.Y:=Y;
      BroadcastTeeEvent(tmp);
    finally
      tmp.Free;
    end;
  end;
end;

procedure TCustomTeePanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CancelMouse:=False;
  inherited;
  BroadcastMouseEvent(meDown,Button,Shift,X,Y);
end;

procedure TCustomTeePanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  BroadcastMouseEvent(meUp,Button,Shift,X,Y);
end;

procedure TCustomTeePanel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  CancelMouse:=False;
  inherited;
  if (Listeners.Count>0) and (not (csDesigning in ComponentState)) then
     BroadcastMouseEvent(meMove,mbLeft,Shift,X,Y);
end;

procedure TCustomTeePanel.DblClick;
begin
  CancelMouse:=False;
  inherited;
  if CancelMouse then Abort;
end;

{$IFNDEF CLR}
type TRectArray=array[0..3] of Integer;
{$ENDIF}

Function TCustomTeePanel.GetMargin(Index:Integer):Integer;
begin
  {$IFDEF CLR}
  case Index of
    0: result:=FMargins.Left;
    1: result:=FMargins.Top;
    2: result:=FMargins.Right;
  else
    result:=FMargins.Bottom;
  end;
  {$ELSE}
  result:=TRectArray(FMargins)[Index];
  {$ENDIF}
end;

Procedure TCustomTeePanel.SetMargin(Index,Value:Integer);
begin
  {$IFDEF CLR}
  case Index of
    0: SetIntegerProperty(FMargins.Left,Value);
    1: SetIntegerProperty(FMargins.Top,Value);
    2: SetIntegerProperty(FMargins.Right,Value);
    3: SetIntegerProperty(FMargins.Bottom,Value);
  end;
  {$ELSE}
  SetIntegerProperty(TRectArray(FMargins)[Index],Value);
  {$ENDIF}
end;

Function TCustomTeePanel.GetBufferedDisplay:Boolean;
begin
  result:=InternalCanvas.UseBuffer;
end;

Procedure TCustomTeePanel.SetBorder(const Value:TChartHiddenPen);
begin
  Border.Assign(Value);
end;

procedure TCustomTeePanel.SetControlRounded;
{$IFDEF CLX}
begin
end;
{$ELSE}
var Region : HRGN;
begin
  if not IRounding then  // re-entrance protection (from Resize method)
  if Assigned(Parent) then // <-- needs Parent to obtain Handle below
  begin
    IRounding:=True;
    try
      if BorderRound>0 then
         Region:=CreateRoundRectRgn(0,0,Width,Height,BorderRound,BorderRound)
      else
         Region:=0;

      SetWindowRgn(Handle,Region,True);
    finally
      IRounding:=False;
    end;
  end;
end;
{$ENDIF}

Procedure TCustomTeePanel.SetBorderRound(Value:Integer);
begin
  if FBorderRound<>Value then
  begin
    FBorderRound:=Value;
    if not (csLoading in ComponentState) then
       SetControlRounded;
  end;
end;

Function TCustomTeePanel.GetBorderStyle:TBorderStyle;
begin
  if FBorder.Visible then result:=bsSingle
                     else result:=bsNone; 
end;

// SetBorderStyle conflicts with LCL. Renamed to SetTheBorderStyle
Procedure TCustomTeePanel.SetTheBorderStyle(Value:TBorderStyle);
begin
  FBorder.Visible:=Value=bsSingle;
end;

Procedure TCustomTeePanel.SetBufferedDisplay(Value:Boolean);
begin
  InternalCanvas.UseBuffer:=Value;
end;

Procedure TCustomTeePanel.SetInternalCanvas(NewCanvas:TCanvas3D);
var Old : Boolean;
begin
  if Assigned(NewCanvas) then
  begin
    NewCanvas.ReferenceCanvas:=FDelphiCanvas;

    if Assigned(InternalCanvas) then
    begin
      Old:=AutoRepaint; { 5.02 }
      AutoRepaint:=False;
      NewCanvas.Assign(InternalCanvas);
      AutoRepaint:=Old; { 5.02 }
      InternalCanvas.Free;
    end;

    InternalCanvas:=NewCanvas;

    if AutoRepaint then
       Invalidate; // Repaint; { 5.02 }
  end;
end;

procedure TCustomTeePanel.RecalcWidthHeight;
Begin
  With ChartRect do
  begin
    if not CustomChartRect then
    begin
      if Left<FChartBounds.Left then Left:=FChartBounds.Left;
      if Top<FChartBounds.Top then Top:=FChartBounds.Top;
      if Right<Left then Right:=Left+1 else
      if Right=Left then Right:=Left+Width;
      if Bottom<Top then Bottom:=Top+1 else
      if Bottom=Top then Bottom:=Top+Height;
    end;

    FChartWidth  :=Right-Left;
    FChartHeight :=Bottom-Top;
  end;

  RectCenter(ChartRect,FChartXCenter,FChartYCenter);
end;

Function TCustomTeePanel.GetCursorPos:TPoint;
Begin
  // Mouse.CursorPos problem in D7 when switching XP themes.
  result:=ScreenToClient(Mouse.CursorPos);
end;

Function TCustomTeePanel.GetRectangle:TRect;
begin
  if Assigned(Parent) then result:=GetClientRect
                      else result:=TeeRect(0,0,Width,Height); // 5.02
end;

Procedure TCustomTeePanel.DrawToMetaCanvas(ACanvas:TCanvas; Const Rect:TRect);
begin  { assume the acanvas is in MM_ANISOTROPIC mode }
  InternalCanvas.Metafiling:=True;
  try
    NonBufferDraw(ACanvas,Rect);
  finally
    InternalCanvas.Metafiling:=False;
  end;
end;

Function TCustomTeePanel.GetMonochrome:Boolean;
Begin
  result:=InternalCanvas.Monochrome;
end;

{$IFDEF BCB}
Function TCustomTeePanel.GetPrintMargins:TRect;
Begin
  result:=FPrintMargins;
end;
{$ENDIF}

Procedure TCustomTeePanel.SetMarginUnits(const Value:TTeeUnits);
begin
  if FMarginUnits<>Value then
  begin
    FMarginUnits:=Value;
    Invalidate;
  end;
end;

Procedure TCustomTeePanel.SetMonochrome(Value:Boolean);
Begin
  InternalCanvas.Monochrome:=Value;
end;

Procedure TCustomTeePanel.Assign(Source:TPersistent);
begin
  if Source is TCustomTeePanel then
  With TCustomTeePanel(Source) do
  begin
    Self.Border             := Border;
    Self.BorderRound        := BorderRound;
    Self.BufferedDisplay    := BufferedDisplay;
    Self.PrintMargins       := PrintMargins;
    Self.FPrintProportional := FPrintProportional;
    Self.FPrintResolution   := FPrintResolution;
    Self.FMargins           := FMargins;
    Self.FMarginUnits       := FMarginUnits; // 6.01.1
    Self.Monochrome         := Monochrome;
    Self.Shadow             := Shadow;
    Self.FView3D            := FView3D;
    Self.View3DOptions      := FView3DOptions;
    Self.Color              := Color;
  end
  else inherited;
end;

Procedure TCustomTeePanel.SaveToMetafile(Const FileName:String);
begin
  SaveToMetaFileRect(False,FileName,GetRectangle);
end;

Procedure TCustomTeePanel.SaveToMetafileEnh(Const FileName:String);
begin
  SaveToMetaFileRect(True,FileName,GetRectangle);
end;

{ Enhanced:Boolean }
Procedure TCustomTeePanel.SaveToMetafileRect( Enhanced:Boolean;
                                              Const FileName:String;
                                              Const Rect:TRect);
var tmpStream : TFileStream;
Begin
  With TeeCreateMetafile(Enhanced,Rect) do
  try
    tmpStream:=TFileStream.Create(FileName,fmCreate);
    try
      SaveToStream(tmpStream);
    finally
      tmpStream.Free;
    end;
  finally
    Free;
  end;
End;

{$IFNDEF CLR}
type
  TTeeCanvas3DAccess=class(TTeeCanvas3D);
{$ENDIF}

Procedure TCustomTeePanel.NonBufferDraw(ACanvas:TCanvas; Const R:TRect);
var Old : Boolean;
begin
  Old:=BufferedDisplay;
  try
    {$IFNDEF CLR}
    if InternalCanvas is TTeeCanvas3D then
       TTeeCanvas3DAccess(InternalCanvas).IKeepBitmap:=True;
    {$ENDIF}

    BufferedDisplay:=False;
    Draw(ACanvas,R);
  finally
    BufferedDisplay:=Old;

    if InternalCanvas is TTeeCanvas3D then
    begin
      {$IFNDEF CLR}
      TTeeCanvas3DAccess(InternalCanvas).IKeepBitmap:=False;
      {$ENDIF}

      Invalidate;
    end;
  end;
end;

Function TCustomTeePanel.TeeCreateBitmap:TBitmap;
begin
  result:=TeeCreateBitmap(Color,GetRectangle);
end;

Function TCustomTeePanel.TeeCreateBitmap(ABackColor:TColor; Const Rect:TRect;
                                         APixelFormat:{$IFNDEF CLX}Graphics.{$ENDIF}TPixelFormat=
                                         {$IFDEF CLX}TeePixelFormat{$ELSE}pfDevice{$ENDIF}
                                         ):TBitmap;
begin
  result:=TBitmap.Create;
  With result do
  begin
    {$IFDEF IGNOREPALETTE}
    IgnorePalette:=PixelFormat=TeePixelFormat;
    {$ENDIF}

    if InternalCanvas.SupportsFullRotation then
       PixelFormat:=TeePixelFormat
    else
       PixelFormat:=APixelFormat;

    TeeSetBitmapSize(result,Rect.Right-Rect.Left,Rect.Bottom-Rect.Top);

    if ABackColor<>clWhite then
    begin
      Canvas.Brush.Color:=ABackColor;
      Canvas.FillRect(Rect);
    end;

    NonBufferDraw(Canvas,Rect);
  end;
end;

Procedure TCustomTeePanel.SaveToBitmapFile(Const FileName:String);
Begin
  SaveToBitmapFile(FileName,GetRectangle);
End;

Procedure TCustomTeePanel.SaveToBitmapFile(Const FileName:String; Const R:TRect);
begin
  With TeeCreateBitmap(clWhite,R) do
  try
    SaveToFile(FileName);
  finally
    Free;
  end;
end;

Procedure TCustomTeePanel.PrintPortrait;
Begin
  PrintOrientation(poPortrait);
end;

Procedure TCustomTeePanel.PrintLandscape;
Begin
  PrintOrientation(poLandscape);
end;

Procedure TCustomTeePanel.PrintOrientation(AOrientation:TPrinterOrientation);
var OldOrientation : TPrinterOrientation;
Begin
  OldOrientation:=Printer.Orientation;
  Printer.Orientation:=AOrientation;
  try
    Print;
  finally
    Printer.Orientation:=OldOrientation;
  end;
end;

Procedure TCustomTeePanel.CopyToClipboardBitmap(Const R:TRect);
var tmpBitmap : TBitmap;
begin
  tmpBitmap:=TeeCreateBitmap(clWhite,R);
  try
    ClipBoard.Assign(tmpBitmap);
  finally
    tmpBitmap.Free;
  end;
end;

Procedure TCustomTeePanel.CopyToClipboardBitmap;
begin
  CopyToClipboardBitmap(GetRectangle);
end;

Procedure TCustomTeePanel.CopyToClipboardMetafile( Enhanced:Boolean;
                                                   Const R:TRect);
var tmpMeta : TMetaFile;
begin
  tmpMeta:=TeeCreateMetafile(Enhanced,R);
  try
    ClipBoard.Assign(tmpMeta);
  finally
    tmpMeta.Free;
  end;
end;

Procedure TCustomTeePanel.CopyToClipboardMetafile(Enhanced:Boolean);
begin
  CopyToClipboardMetafile(Enhanced,GetRectangle);
end;

Procedure TCustomTeePanel.CalcMetaBounds( var R:TRect;
                                          Const AChartRect:TRect;
                                          var WinWidth,WinHeight,
                                          ViewWidth,ViewHeight:Integer);
var tmpRectWidth  : Integer;
    tmpRectHeight : Integer;
begin  { apply PrintResolution to the desired rectangle coordinates }
  RectSize(R,ViewWidth,ViewHeight);
  RectSize(AChartRect,tmpRectWidth,tmpRectHeight);
  WinWidth :=tmpRectWidth -MulDiv(tmpRectWidth, PrintResolution,100);
  WinHeight:=tmpRectHeight-MulDiv(tmpRectHeight,PrintResolution,100);

  With R do
  begin
    Left  :=MulDiv(Left  ,WinWidth,ViewWidth);
    Right :=MulDiv(Right ,WinWidth,ViewWidth);
    Top   :=MulDiv(Top   ,WinHeight,ViewHeight);
    Bottom:=MulDiv(Bottom,WinHeight,ViewHeight);
  end;
end;

Procedure TCustomTeePanel.PrintPartialCanvas( PrintCanvas:TCanvas;
                                              Const PrinterRect:TRect);
var ViewWidth   : Integer;
    ViewHeight  : Integer;
    WinWidth    : Integer;
    WinHeight   : Integer;
    tmpR        : TRect;
    {$IFNDEF CLX}
    OldMapMode  : Integer;
    {$ENDIF}

  Procedure SetAnisotropic; { change canvas/windows metafile mode }
  {$IFNDEF CLX}
  var DC : HDC;
  {$ENDIF}
  begin
    {$IFNDEF CLX}
    DC:=PrintCanvas.Handle;
    OldMapMode:=GetMapMode(DC);
    SetMapMode(DC, MM_ANISOTROPIC);
    SetWindowOrgEx(  DC, 0, 0, nil);
    SetWindowExtEx(  DC, WinWidth, WinHeight, nil);
    SetViewportExtEx(DC, ViewWidth,ViewHeight, nil);
    SetViewportOrgEx(DC, 0, 0, nil);
    {$ENDIF}
  end;

Begin
  { check if margins inverted }
  tmpR:=OrientRectangle(PrinterRect);

  { apply PrintResolution to dimensions }
  CalcMetaBounds(tmpR,GetRectangle,WinWidth,WinHeight,ViewWidth,ViewHeight);

  {//SaveDC}
  SetAnisotropic;
  FPrinting:=True;
  try
    if CanClip then ClipCanvas(PrintCanvas,tmpR);

    if Assigned(FOnBeforePrint) then
       FOnBeforePrint(Self,PrintCanvas,tmpR);  // 7.01

    DrawToMetaCanvas(PrintCanvas,tmpR);
    UnClipCanvas(PrintCanvas);
  finally
    FPrinting:=False;
  end;
  {$IFNDEF CLX}
  SetMapMode(PrintCanvas.Handle,OldMapMode);
  {$ENDIF}
  {//RestoreDC}
end;

Procedure TCustomTeePanel.PrintPartial(Const PrinterRect:TRect);
Begin
  PrintPartialCanvas(Printer.Canvas,PrinterRect);
End;

Procedure TCustomTeePanel.PrintRect(Const R:TRect);
Begin
  if Name<>'' then Printer.Title:=Name;
  Printer.BeginDoc;
  try
    PrintPartial(R);
    Printer.EndDoc;
  except
    on Exception do
    begin
      Printer.Abort;
      if Printer.Printing then Printer.EndDoc;
      Raise;
    end;
  end;
end;

Function TCustomTeePanel.CalcProportionalMargins:TRect;
var tmpPrinterOk : Boolean;

  Function CalcMargin(Size1,Size2:Integer; Const ARatio:Double):Integer;
  var tmpPrinterRatio  : Double;
      tmpDefaultMargin : Double;
  begin
    if tmpPrinterOk then
       {$IFDEF LCL}
       with Printer.PaperSize.PaperRect.WorkRect do
            tmpPrinterRatio:= (Right-Left)/(Bottom-Top)
       {$ELSE}
       tmpPrinterRatio:= TeeGetDeviceCaps(Printer.Handle,LOGPIXELSX)/
                         TeeGetDeviceCaps(Printer.Handle,LOGPIXELSY)
       {$ENDIF}
    else
       tmpPrinterRatio:= 1;

    tmpDefaultMargin:=(2.0*TeeDefault_PrintMargin)*Size1*0.01;   // 7.0

    result:=Round(100.0*(Size2-((Size1-tmpDefaultMargin)*ARatio*tmpPrinterRatio))/Size2) div 2;
  end;

var tmp         : Integer;
    tmpWidth    : Integer;
    tmpHeight   : Integer;
    tmpPrinterW : Integer;  { 5.03 }
    tmpPrinterH : Integer;
begin
  With GetRectangle do
  begin
    tmpWidth:=Right-Left;
    tmpHeight:=Bottom-Top;
  end;

  tmpPrinterOk:=True;

  try
    tmpPrinterW:=Printer.PageWidth;
    tmpPrinterH:=Printer.PageHeight;
  except
    on EPrinter do
    begin
      tmpPrinterOk:=False;
      tmpPrinterW:=Screen.Width;
      tmpPrinterH:=Screen.Height;
    end;
  end;

  if tmpWidth > tmpHeight then
  begin
    tmp:=CalcMargin(tmpPrinterW,tmpPrinterH,tmpHeight/tmpWidth);
    Result:=TeeRect(TeeDefault_PrintMargin,tmp,TeeDefault_PrintMargin,tmp);
  end
  else
  begin
    tmp:=CalcMargin(tmpPrinterH,tmpPrinterW,tmpWidth/tmpHeight);
    Result:=TeeRect(tmp,TeeDefault_PrintMargin,tmp,TeeDefault_PrintMargin);
  end;
end;

Function TCustomTeePanel.ChartPrintRect:TRect;
var tmpLog : Array[Boolean] of Integer;

  Function InchToPixel(Horizontal:Boolean; Const Inch:Double):Integer;
  begin
    result:=Round(Inch*tmpLog[Horizontal]);
  end;

var tmp : Double;
Begin
  if FPrintProportional then PrintMargins:=CalcProportionalMargins;

  {$IFDEF LCL}
  tmpLog[True]:=300;  // Dummy Lazarus
  tmpLog[False]:=300;
  {$ELSE}
  { calculate margins in pixels and calculate the remaining rectangle in pixels }
  tmpLog[True] :=TeeGetDeviceCaps(Printer.Handle,LOGPIXELSX);
  tmpLog[False]:=TeeGetDeviceCaps(Printer.Handle,LOGPIXELSY);
  {$ENDIF}

  With result do
  Begin
    tmp   :=0.01*Printer.PageWidth/(1.0*tmpLog[True]);
    Left  :=InchToPixel(True,1.0*PrintMargins.Left*tmp);
    Right :=Printer.PageWidth-InchToPixel(True,1.0*PrintMargins.Right*tmp);

    tmp   :=0.01*Printer.PageHeight/(1.0*tmpLog[False]);
    Top   :=InchToPixel(False,1.0*PrintMargins.Top*tmp);
    Bottom:=Printer.PageHeight-InchToPixel(False,1.0*PrintMargins.Bottom*tmp);
  end;
end;

Procedure TCustomTeePanel.Print;
Begin
  PrintRect(ChartPrintRect);
end;

Procedure DrawBevel(Canvas:TTeeCanvas; Bevel:TPanelBevel; var R:TRect;
                    Width:Integer; Round:Integer=0);
Const Colors:Array[Boolean] of TColor=(clBtnHighlight,clBtnShadow);
begin
  if Bevel<>bvNone then
     if Round>0 then
     begin
       Canvas.Pen.Color:=Colors[Bevel=bvLowered];
       InflateRect(R,-1,-1);
       Canvas.RoundRect(R,Round,Round);
       InflateRect(R,-Width,-Width);
     end
     else Canvas.Frame3D(R,Colors[Bevel=bvLowered],Colors[Bevel=bvRaised],Width);
end;

Procedure TCustomTeePanel.DrawPanelBevels(Rect:TRect);
var tmp : Integer;
    tmpHoriz : Integer;
begin
  Canvas.FrontPlaneBegin;

  Canvas.Brush.Style:=bsClear;

  if Border.Visible then
  begin
    if Border.SmallDots then tmp:=1
    else
    begin
      // Fix big pen width
      tmp:=Border.Width-1;

      if tmp>0 then
      begin
        tmpHoriz:=tmp div 2;
        if tmp mod 2=1 then Inc(tmpHoriz);

        Inc(Rect.Left,tmpHoriz);
        Inc(Rect.Top,tmpHoriz);

        tmp:=tmp div 2;  // 7.08

        Dec(Rect.Right,tmp);
        Dec(Rect.Bottom,tmp);
      end;
    end;

    Canvas.AssignVisiblePen(Border);

    if BorderRound>0 then
    begin
      Dec(Rect.Right);
      Dec(Rect.Bottom);
      Canvas.RoundRect(Rect,BorderRound,BorderRound)
    end
    else
    begin
      Canvas.Rectangle(Rect);
      if not Border.SmallDots then Inc(tmp);
    end;

    InflateRect(Rect,-tmp,-tmp);
  end;

  if (not Printing) or PrintTeePanel then
  begin
    With Canvas.Pen do
    begin
      Style:=psSolid;
      Width:=1;
      Mode:=pmCopy;
    end;

    DrawBevel(Canvas,BevelOuter,Rect,BevelWidth,BorderRound);

    if BorderWidth>0 then
       Canvas.Frame3D(Rect, Color, Color, BorderWidth);

    DrawBevel(Canvas,BevelInner,Rect,BevelWidth,BorderRound);
  end;

  Canvas.FrontPlaneEnd;
end;

{$IFDEF CLX}
function TCustomTeePanel.WidgetFlags: Integer;
begin
  result:=inherited WidgetFlags or
          Integer(WidgetFlags_WRepaintNoErase) or
          Integer(WidgetFlags_WResizeNoErase);
end;
{$ENDIF}

Function TTeeZoomPen.IsColorStored:Boolean;
begin
  result:=Color<>DefaultColor;
end;

{ TTeeZoom }
Constructor TTeeZoom.Create;
begin
  inherited;
  FAnimatedSteps:=8;
  FAllow:=True;
  FDirection:=tzdBoth;
  FMinimumPixels:=16;
  FMouseButton:=mbLeft;
end;

Destructor TTeeZoom.Destroy;
Begin
  FPen.Free;
  FBrush.Free;
  inherited;
end;

Procedure TTeeZoom.Assign(Source:TPersistent);
begin
  if Source is TTeeZoom then
  With TTeeZoom(Source) do
  begin
    Self.FAllow        := FAllow;
    Self.FAnimated     := FAnimated;
    Self.FAnimatedSteps:= FAnimatedSteps;
    Self.Brush         := FBrush;
    Self.FDirection    := FDirection;
    Self.FKeyShift     := FKeyShift;
    Self.FMouseButton  := FMouseButton;
    Self.Pen           := FPen;
  end;
end;

procedure TTeeZoom.SetBrush(Value:TTeeZoomBrush);
begin
  if Assigned(Value) then Brush.Assign(Value)
                     else FreeAndNil(FBrush);
end;

procedure TTeeZoom.SetPen(Value:TTeeZoomPen);
begin
  if Assigned(Value) then Pen.Assign(Value)
                     else FreeAndNil(FPen);
end;

Function TTeeZoom.GetBrush:TTeeZoomBrush;
begin
  if not Assigned(FBrush) then
  begin
    FBrush:=TTeeZoomBrush.Create(nil);
    FBrush.Color:=clWhite;
    FBrush.Style:=bsClear;
  end;
  result:=FBrush;
end;

Function TTeeZoom.GetPen:TTeeZoomPen;
begin
  if not Assigned(FPen) then
  begin
    FPen:=TTeeZoomPen.Create(nil);
    FPen.Color:=clWhite;
    FPen.DefaultColor:=clWhite;
  end;
  result:=FPen;
end;

// TBackImage
constructor TBackImage.Create;
begin
  inherited;
  FMode:=pbmStretch;
end;

procedure TBackImage.Assign(Source:TPersistent);
begin
  if Source is TBackImage then
  with TBackImage(Source) do
  begin
    Self.FInside:=FInside;
    Self.FLeft:=FLeft;
    Self.FMode:=FMode;
    Self.FTop:=FTop;
  end;

  inherited;
end;

procedure TBackImage.SetInside(Const Value:Boolean);
begin
  if Inside<>Value then
  begin
    FInside:=Value;
    Changed(Self);
  end;
end;

procedure TBackImage.SetMode(Const Value:TTeeBackImageMode);
begin
  if Mode<>Value then
  begin
    FMode:=Value;
    Changed(Self);
  end;
end;

procedure TBackImage.SetLeft(Value:Integer);
begin
  if Left<>Value then
  begin
    FLeft:=Value;
    Changed(Self);
  end;
end;

procedure TBackImage.SetTop(Value:Integer);
begin
  if Top<>Value then
  begin
    FTop:=Value;
    Changed(Self);
  end;
end;

{ TCustomTeePanelExtended }
Constructor TCustomTeePanelExtended.Create(AOwner: TComponent);
begin
  inherited;
  FAllowPanning:=pmBoth;
  FZoom:=TTeeZoom.Create;
end;

Destructor TCustomTeePanelExtended.Destroy;
Begin
  FZoom.Free;
  FGradient.Free;
  FBackImage.Free;
  inherited;
end;

Procedure TCustomTeePanelExtended.SetAnimatedZoom(Value:Boolean);
Begin
  FZoom.Animated:=Value;
end;

Procedure TCustomTeePanelExtended.SetAnimatedZoomSteps(Value:Integer);
Begin
  FZoom.AnimatedSteps:=Value;
end;

Function TCustomTeePanelExtended.GetBackImage:TBackImage;
begin
  if not Assigned(FBackImage) then
  begin
    FBackImage:=TBackImage.Create;
    FBackImage.OnChange:=CanvasChanged;
  end;

  result:=FBackImage;
end;

procedure TCustomTeePanelExtended.SetBackImage(const Value:TBackImage);
begin
  if Assigned(Value) then
     BackImage.Assign(Value)
  else
  begin
    FreeAndNil(FBackImage);
    Invalidate;
  end;
end;

procedure TCustomTeePanelExtended.SetBackImageInside(Const Value:Boolean);
begin
  BackImage.Inside:=Value;
end;

procedure TCustomTeePanelExtended.SetBackImageMode(Const Value:TTeeBackImageMode);
Begin
  BackImage.Mode:=Value;
End;

function TCustomTeePanelExtended.HasBackImage:Boolean;
begin
  result:=Assigned(FBackImage) and Assigned(FBackImage.Graphic);
end;

procedure TCustomTeePanelExtended.SetBackImageTransp(Const Value:Boolean);
begin
  if HasBackImage then { 5.03 }
     FBackImage.Graphic.Transparent:=Value; { 5.02 }
end;

procedure TCustomTeePanelExtended.UndoZoom;
begin
  if Assigned(FOnUndoZoom) then FOnUndoZoom(Self);
  Invalidate;
  FZoomed:=False;
end;

Function TCustomTeePanelExtended.GetGradient:TChartGradient;
begin
  if not Assigned(FGradient) then
     FGradient:=TChartGradient.Create(CanvasChanged);
  result:=FGradient;
end;

procedure TCustomTeePanelExtended.SetGradient(Value:TChartGradient);
begin
  if Assigned(Value) then Gradient.Assign(Value)
                     else FreeAndNil(FGradient);
end;

Procedure TCustomTeePanelExtended.Assign(Source:TPersistent);
begin
  if Source is TCustomTeePanelExtended then
  With TCustomTeePanelExtended(Source) do
  begin
    Self.BackImage    := FBackImage;
    Self.Gradient     := FGradient;
    Self.FAllowPanning:= FAllowPanning;
    Self.Zoom         := Zoom;
  end;
  inherited;
end;

{$IFNDEF CLR}
{$IFNDEF CLX}
function TCustomTeePanelExtended.GetPalette: HPALETTE;
begin
  Result:=0;	{ default result is no palette }
  if HasBackImage and
     (FBackImage.Graphic is TBitmap) then	{ only bitmaps have palettes }
         Result := TBitmap(FBackImage.Graphic).Palette;	{ use it if available }
end;
{$ENDIF}
{$ENDIF}

procedure TCustomTeePanelExtended.DrawBitmap(Rect:TRect; Z:Integer);
begin
  if HasBackImage then
     FBackImage.Draw(Self,Rect,Z);
end;

procedure TBackImage.Draw(Panel:TCustomTeePanelExtended; Rect:TRect; Z:Integer);
var RectH : Integer;
    RectW : Integer;
    tmp   : TGraphic;

    Procedure TileBitmap;
    var tmpWidth  : Integer;
        tmpHeight : Integer;
        tmpX      : Integer;
        tmpY      : Integer;
        tmpIs3D   : Boolean;
    begin
      tmpWidth :=Width;
      tmpHeight:=Height;

      { keep "painting" the wall with tiled small images... }
      if (tmpWidth>0) and (tmpHeight>0) then
      begin
       	tmpY:=0;

        tmpIs3D:=(Z>0) and (not Panel.View3DOptions.Orthogonal);

      	while tmpY<RectH do
      	begin
      	  tmpX:=0;

      	  while tmpX<RectW do
      	  begin
            if tmpIs3D then
               Panel.Canvas.StretchDraw(TeeRect(Rect.Left+tmpX,Rect.Top+tmpY,
                                          Rect.Left+tmpX+tmpWidth,
                                          Rect.Top+tmpY+tmpHeight),
                                          tmp,Z)
            else
               Panel.Canvas.Draw(Rect.Left+tmpX,Rect.Top+tmpY,tmp);

      	    Inc(tmpX,tmpWidth);
      	  end;

       	  Inc(tmpY,tmpHeight);
    	  end;
      end;
    end;

    Procedure Calc3DRect;
    begin
      Rect:=Panel.Canvas.CalcRect3D(Rect,Z);

      if not Panel.View3D then
         Inc(Rect.Top);
    end;

var ShouldClip : Boolean;
begin
  tmp:=Filtered;

  if Mode=pbmStretch then
  begin
    if Z>0 then
       if Panel.Canvas.View3DOptions.Orthogonal then
       begin
         Calc3DRect;
         Panel.Canvas.StretchDraw(Rect,tmp);
       end
       else
         Panel.Canvas.StretchDraw(Rect,tmp,Z)

    else Panel.Canvas.StretchDraw(Rect,tmp);
  end
  else
  begin
    ShouldClip:=Panel.CanClip;

    if ShouldClip then
       if Z=0 then Panel.Canvas.ClipRectangle(Rect)
              else Panel.Canvas.ClipCube(Rect,0,Panel.Width3D);

    if (Z>0) and Panel.View3DOptions.Orthogonal then
       Calc3DRect;

    RectSize(Rect,RectW,RectH);

    if Mode=pbmTile then
       TileBitmap
    else { draw centered }
    begin
      Panel.FillPanelRect(Rect);

      if Mode=pbmCustom then
      begin
        Rect.Left:=Rect.Left+Left;
        Rect.Top:=Rect.Top+Top;
        Rect.Right:=Rect.Left+Width;
        Rect.Bottom:=Rect.Top+Height;
      end
      else
        InflateRect(Rect,-(RectW-Width) div 2,
                         -(RectH-Height) div 2);

      if (Z>0) and (not Panel.View3DOptions.Orthogonal) then
         Panel.Canvas.StretchDraw(Rect,tmp,Z)
      else
         Panel.Canvas.Draw(Rect.Left,Rect.Top,tmp);
    end;

    if ShouldClip then
       Panel.Canvas.UnClipRectangle;
  end;
end;

type
  TControlAccess=class(TControl);

  {$IFNDEF CLR}
  TShadowAccess=class(TTeeShadow);
  {$ENDIF}

procedure TCustomTeePanelExtended.PanelPaint(Const UserRect:TRect);
var Rect : TRect;

  Procedure DrawShadow(AColor:TColor);
  begin
    AColor:=ColorToRGB(AColor);

    PaintBack(Rect,AColor);

    if Shadow.HorizSize>0 then
       Dec(Rect.Right,2*Shadow.HorizSize+1)
    else
       Inc(Rect.Left,-Shadow.HorizSize+1);

    if Shadow.VertSize>0 then
       Dec(Rect.Bottom,2*Shadow.VertSize+1)
    else
       Inc(Rect.Top,-Shadow.VertSize+1);

    {$IFNDEF CLR}TShadowAccess{$ENDIF}(Shadow).FullDraw:= (BorderRound<>0);
    Shadow.Draw(Canvas,Rect,0,BorderRound);

    if Shadow.HorizSize>0 then
       Inc(Rect.Right);

    if Shadow.VertSize>0 then
       Inc(Rect.Bottom);
  end;

begin
  Canvas.FrontPlaneBegin;

  Rect:=UserRect;

  if Shadow.Visible and (Shadow.Size<>0) then
     if Assigned(Parent) then
        DrawShadow({$IFNDEF CLR}TControlAccess{$ENDIF}(Parent).Color)
     else
        DrawShadow(Color);

  FillPanelRect(Rect);

  if HasBackImage and
     (not BackImage.Inside) then
       DrawBitmap(Rect,0);

  DrawPanelBevels(Rect);

  Canvas.FrontPlaneEnd;
end;

procedure TCustomTeePanelExtended.PaintBack(const ARect:TRect; AColor:TColor;
                   BorderRound:Integer=0);
begin
  { PrintTeePanel is a "trick" to paint Chart background also when printing }
  if ((not Printing) or PrintTeePanel) and (AColor<>clNone) then
  With Canvas do
  begin
    Brush.Color:=AColor;
    Brush.Style:=bsSolid;
    Pen.Style:=psClear;

    if BorderRound=0 then
       EraseBackground(ARect)
    else
       RoundRect(ARect,BorderRound,BorderRound);
  end;
end;

procedure TCustomTeePanelExtended.FillPanelRect(Const Rect:TRect);
Begin
  Canvas.FrontPlaneBegin;

  if Assigned(FGradient) and FGradient.Visible then
     FGradient.Draw(Canvas,Rect,BorderRound)
  else
     PaintBack(Rect,Color,BorderRound);

  Canvas.FrontPlaneEnd;
end;

procedure TCustomTeePanelExtended.DrawZoomRectangle;
var tmp:TColor;
Begin
  tmp:=ColorToRGB(GetBackColor);

  if Assigned(Zoom.FBrush) then
     SetBrushCanvas((clWhite-tmp) xor Zoom.Brush.Color,Zoom.Brush,tmp)
  else
     InternalCanvas.Brush.Style:=bsClear;

  Zoom.Pen.Mode:=pmNotXor;

  With InternalCanvas do
  Begin
    AssignVisiblePenColor(Zoom.Pen,(clWhite-tmp) xor Zoom.Pen.Color);

    if (not Assigned(Zoom.FBrush)) or
       (Zoom.FBrush.Style=bsClear) then BackMode:=cbmTransparent;

    With Zoom do Rectangle(X0,Y0,X1,Y1);
  end;
end;

function TCustomTeePanelExtended.GetAllowZoom: Boolean;
begin
  result:=Zoom.Allow;
end;

function TCustomTeePanelExtended.GetAnimatedZoom: Boolean;
begin
  result:=Zoom.Animated;
end;

function TCustomTeePanelExtended.GetAnimatedZoomSteps: Integer;
begin
  result:=Zoom.AnimatedSteps;
end;

Function TCustomTeePanelExtended.GetBackImageTransp:Boolean;
begin
  result:=HasBackImage and FBackImage.Graphic.Transparent;
end;

Function TCustomTeePanelExtended.GetBackImageInside:Boolean;
begin
  result:=HasBackImage and BackImage.Inside;
end;

Function TCustomTeePanelExtended.GetBackImageMode:TTeeBackImageMode;
begin
  result:=BackImage.Mode;
end;

procedure TCustomTeePanelExtended.SetAllowZoom(Value: Boolean);
begin
  Zoom.Allow:=Value;
end;

procedure TCustomTeePanelExtended.SetZoom(Value: TTeeZoom);
begin
  FZoom.Assign(Value);
end;

procedure TCustomTeePanelExtended.ReadAllowZoom(Reader: TReader);
begin
  Zoom.Allow:=Reader.ReadBoolean;
end;

procedure TCustomTeePanelExtended.ReadAnimatedZoom(Reader: TReader);
begin
  Zoom.Animated:=Reader.ReadBoolean;
end;

procedure TCustomTeePanelExtended.ReadAnimatedZoomSteps(Reader: TReader);
begin
  Zoom.AnimatedSteps:=Reader.ReadInteger;
end;

procedure TCustomTeePanelExtended.ReadPrintMargins(Reader: TReader);
begin
  Reader.ReadListBegin;
  with FPrintMargins do
  begin
    Left  :=Reader.ReadInteger;
    Top   :=Reader.ReadInteger;
    Right :=Reader.ReadInteger;
    Bottom:=Reader.ReadInteger;
  end;
  Reader.ReadListEnd;
end;

procedure TCustomTeePanelExtended.SavePrintMargins(Writer: TWriter);
begin
  Writer.WriteListBegin;
  with PrintMargins do
  begin
    Writer.WriteInteger(Left);
    Writer.WriteInteger(Top);
    Writer.WriteInteger(Right);
    Writer.WriteInteger(Bottom);
  end;
  Writer.WriteListEnd;
end;

procedure TCustomTeePanelExtended.DefineProperties(Filer:TFiler);

  Function NotDefaultPrintMargins:Boolean;
  begin
    With PrintMargins do
    result:= (Left<>TeeDefault_PrintMargin) or
             (Top<>TeeDefault_PrintMargin) or
             (Right<>TeeDefault_PrintMargin) or
             (Bottom<>TeeDefault_PrintMargin);
  end;

begin
  inherited;
  Filer.DefineProperty('AllowZoom',ReadAllowZoom,nil,False);
  Filer.DefineProperty('AnimatedZoom',ReadAnimatedZoom,nil,False);
  Filer.DefineProperty('AnimatedZoomSteps',ReadAnimatedZoomSteps,nil,False);
  Filer.DefineProperty('PrintMargins',ReadPrintMargins,SavePrintMargins,NotDefaultPrintMargins);
end;

{ TTeeCustomShapeBrushPen }
Constructor TTeeCustomShapeBrushPen.Create;
Begin
  inherited Create;
  FBrush:=GetBrushClass.Create(CanvasChanged);
  FPen:=TChartPen.Create(CanvasChanged);
  FVisible:=True;
end;

Destructor TTeeCustomShapeBrushPen.Destroy;
begin
  FBrush.Free;
  FPen.Free;
  inherited;
end;

Procedure TTeeCustomShapeBrushPen.Assign(Source:TPersistent);
Begin
  if Source is TTeeCustomShapeBrushPen then
  With TTeeCustomShapeBrushPen(Source) do
  begin
    Self.Brush   :=FBrush;
    Self.Pen     :=FPen;
    Self.FVisible:=FVisible;
  end
  else inherited;
end;

function TTeeCustomShapeBrushPen.GetBrushClass: TChartBrushClass;
begin
  result:=TChartBrush;
end;

Procedure TTeeCustomShapeBrushPen.SetBrush(Value:TChartBrush);
begin
  FBrush.Assign(Value);
end;

Procedure TTeeCustomShapeBrushPen.SetPen(Value:TChartPen);
Begin
  FPen.Assign(Value);
end;

Procedure TTeeCustomShapeBrushPen.Show;
begin
  Visible:=True;
end;

Procedure TTeeCustomShapeBrushPen.Hide;
begin
  Visible:=False;
end;

Procedure TTeeCustomShapeBrushPen.Repaint;
begin
  if Assigned(ParentChart) then
     ParentChart.Invalidate;
end;

Procedure TTeeCustomShapeBrushPen.CanvasChanged(Sender:TObject);
begin
  Repaint;
end;

Procedure TTeeCustomShapeBrushPen.SetParent(Value:TCustomTeePanel);
begin
  FParent:=Value;
end;

procedure TTeeCustomShapeBrushPen.SetVisible(Value:Boolean);
begin
  if Assigned(ParentChart) then ParentChart.SetBooleanProperty(FVisible,Value)
                           else FVisible:=Value;
end;

{ TTeeCustomShape }
Constructor TTeeCustomShape.Create(AOwner: TCustomTeePanel);
Begin
  {$IFDEF CLR}
  inherited Create;
  ParentChart:=AOwner;
  {$ELSE}
  ParentChart:=AOwner;
  inherited Create;
  {$ENDIF}

  FShadow:=TTeeShadow.Create(CanvasChanged);
  InitShadow(FShadow);

  FBevel:=bvNone;
  FBevelWidth:=2;
  FColor:=clWhite;

  FFont:=TTeeFont.Create(CanvasChanged);

  FShapeStyle:=fosRectangle;
  FRoundSize:=16;
end;

Destructor TTeeCustomShape.Destroy;
begin
  FShadow.Free;
  FFont.Free;
  FGradient.Free;
  FPicture.Free;

  inherited;
end;

Procedure TTeeCustomShape.Assign(Source:TPersistent);
Begin
  if Source is TTeeCustomShape then
  With TTeeCustomShape(Source) do
  begin
    Self.FBevel       :=FBevel;
    Self.FBevelWidth  :=FBevelWidth;
    Self.FColor       :=FColor;
    Self.Font         :=FFont;
    Self.Gradient     :=FGradient;
    Self.FShapeStyle  :=FShapeStyle;
    Self.Picture      :=FPicture;
    Self.FRoundSize   :=FRoundSize;
    Self.Shadow       :=FShadow;
    Self.FTextFormat  :=FTextFormat;
    Self.FTransparent :=FTransparent;
    Self.FTransparency:=FTransparency; // 6.02
  end;

  inherited;
end;

Procedure TTeeCustomShape.Draw;
begin
  DrawRectRotated(ShapeBounds);
end;

Procedure RectToFourPoints(Const ARect:TRect; const Angle:Double; var P:TFourPoints);
var tmpSin    : Extended;
    tmpCos    : Extended;
    tmpCenter : TPoint;

  Procedure RotatePoint(var P:TPoint; AX,AY:Integer);
  begin
    P.X:=tmpCenter.x+Round(  AX*tmpCos + AY*tmpSin );
    P.Y:=tmpCenter.y+Round( -AX*tmpSin + AY*tmpCos );
  end;

var tmp : Double;
    tmpRect : TRect;
begin
  RectCenter(ARect,tmpCenter.X,tmpCenter.Y);
  tmp:=Angle*TeePiStep;
  SinCos(tmp,tmpSin,tmpCos);
  tmpRect:=ARect;

  With tmpRect do
  begin
    Dec(Left,tmpCenter.X);
    Dec(Right,tmpCenter.X);
    Dec(Top,tmpCenter.Y);
    Dec(Bottom,tmpCenter.Y);
    RotatePoint(P[0],Left,Top);
    RotatePoint(P[1],Right,Top);
    RotatePoint(P[2],Right,Bottom);
    RotatePoint(P[3],Left,Bottom);
  end;
end;

Procedure TTeeCustomShape.DrawRectRotated(Rect:TRect; Angle:Integer=0; AZ:Integer=0);
begin
  DrawRectRotated(ParentChart,Rect,Angle,AZ);
end;

Procedure TTeeCustomShape.DrawRectRotated(Panel:TCustomTeePanel;
                                    Rect:TRect; Angle:Integer=0; AZ:Integer=0);

  Procedure InternalDrawShape(Const ARect:TRect);
  var P : TFourPoints;
  begin
    if Angle<>0 then
    begin
      RectToFourPoints(ARect,Angle,P);
      Panel.Canvas.PolygonWithZ(P,AZ);
    end
    else
    with Panel.Canvas do
    if SupportsFullRotation then
    begin
      if FShapeStyle=fosEllipse then
         EllipseWithZ(ARect,AZ)
      else
         RectangleWithZ(ARect,AZ);
    end
    else
    case FShapeStyle of
      fosRectangle: Rectangle(ARect);
      fosEllipse  : Ellipse(ARect);
    else
      with ARect do
           RoundRect(Left,Top,Right,Bottom,RoundSize,RoundSize)
    end;
  end;

  Procedure DrawShadow(R:TRect);
  var tmpH     : Integer;
      tmpV     : Integer;
      tmpR     : TRect;
      tmpBlend : TTeeBlend;
      tmp      : Integer;
      tmpP     : TFourPoints;
  begin
    if Angle<>0 then
    begin
      RectToFourPoints(R,Angle,tmpP);
      R:=RectFromPolygon(tmpP,4);
    end;

    if FShapeStyle=fosEllipse then
       FShadow.DrawEllipse(Panel.Canvas,R,AZ)
    else
    begin
      if FShapeStyle=fosRectangle then tmp:=0
                                  else tmp:=RoundSize;

      if Panel.Canvas.SupportsFullRotation then
         FShadow.Draw(Panel.Canvas,R,AZ,tmp)
      else
      begin
        Panel.Canvas.FrontPlaneBegin;
        FShadow.Draw(Panel.Canvas,R,AZ,tmp);
        Panel.Canvas.FrontPlaneEnd;
      end;
    end;

    if Transparency>0 then  // Trick. v7. If we have transparency, draw back.
    begin
      tmpH:=FShadow.HorizSize;
      tmpV:=FShadow.VertSize;

      if (Max(tmpH,tmpV)>0) and Pen.Visible then
      begin
        Inc(tmpH,Pen.Width);
        Inc(tmpV,Pen.Width);
      end;

      With Panel.Canvas do
      begin
        Pen.Style:=psClear;
        Brush.Style:=bsSolid;
        Brush.Color:=FShadow.Color;

        if FShadow.Transparency>0 then
        begin
          with Rect do
               tmpR:=TeeRect(Left+tmpH,Top+tmpV,Right+tmpH,Bottom+tmpV);

          tmpBlend:=Panel.Canvas.BeginBlending(tmpR,FShadow.Transparency);
        end
        else tmpBlend:=nil;

        With Rect do
          InternalDrawShape(TeeRect(Left+tmpH,Top+tmpV,Right+tmpH,Bottom+tmpV));

        if FShadow.Transparency>0 then
           Panel.Canvas.EndBlending(tmpBlend);
      end;
    end;
  end;

  procedure DrawGradient;
  var P   : TFourPoints;
      tmp : Integer;

      {$IFDEF CLX}
      tmpR2 : TRect;
      {$ENDIF}
  begin
    if Angle<>0 then
    begin
      RectToFourPoints(Rect,Angle,P);

      if Panel.Canvas.SupportsFullRotation then
         FGradient.Draw(Panel.Canvas,P,AZ)
      else
         FGradient.Draw(Panel.Canvas,P);
    end
    else
    begin
      if Panel.Canvas.SupportsFullRotation then
      begin
        TCanvasAccess(Panel.Canvas).GradientZ:=AZ;
        FGradient.Draw(Panel.Canvas,Rect);
        TCanvasAccess(Panel.Canvas).GradientZ:=0;
      end
      else
      begin
        if Self.FShapeStyle=fosRoundRectangle then
           tmp:=RoundSize
        else
           tmp:=0;

        {$IFDEF CLX}
        tmpR2:=Rect;
        Dec(tmpR2.Bottom);
        FGradient.Draw(Panel.Canvas,tmpR2,tmp);
        {$ELSE}
        FGradient.Draw(Panel.Canvas,Rect,tmp);
        {$ENDIF}
      end;
    end;

    Panel.Canvas.Brush.Style:=bsClear;
  end;

var tmpR     : TRect;
    tmpBlend : TTeeBlend;
    P        : TFourPoints;
begin
  if not Transparent then
  begin
    if Transparency>0 then
    begin
      if Angle<>0 then
      begin
        RectToFourPoints(Rect,Angle,P);
        tmpR:=RectFromPolygon(P,4);
      end
      else tmpR:=Rect;

      tmpBlend:=Panel.Canvas.BeginBlending(tmpR,Transparency);
    end
    else tmpBlend:=nil;

    if Assigned(FShadow) and FShadow.Visible and
       (FShadow.Size<>0) and (FBrush.Style<>bsClear) then
            DrawShadow(Rect);

    if Assigned(FPicture) and Assigned(FPicture.Graphic) then
    begin
      if ShapeStyle=fosEllipse then
         Panel.Canvas.ClipEllipse(Rect)
      else
      if ShapeStyle=fosRoundRectangle then
         Panel.Canvas.ClipRectangle(Rect,RoundSize);

      FPicture.Draw(TCustomTeePanelExtended(Panel),Rect,0);

      if (ShapeStyle=fosEllipse) or (ShapeStyle=fosRoundRectangle) then
         Panel.Canvas.UnClipRectangle;

      Panel.Canvas.Brush.Style:=bsClear;
    end
    else
    if Assigned(FGradient) and FGradient.Visible then
       DrawGradient
    else
       Panel.Canvas.AssignBrush(Brush,Color);

    Panel.Canvas.AssignVisiblePen(Pen);

    InternalDrawShape(Rect);

    if Angle=0 then
    begin
      tmpR:=Rect;
      DrawBevel(Panel.Canvas,FBevel,tmpR,BevelWidth);
    end;

    if Transparency>0 then
    begin
      if (Picture.Filters.Count>0) and (not Assigned(Picture.Graphic)) then
         Picture.Filters.ApplyTo(tmpBlend.Bitmap);

      Panel.Canvas.EndBlending(tmpBlend);
    end;
  end;
end;

Function TTeeCustomShape.IsTranspStored:Boolean;
begin
  result:=FTransparent<>DefaultTransparent;
end;

procedure TTeeCustomShape.ReadShadowColor(Reader: TReader); // obsolete
begin
  if Reader.NextValue=vaIdent then
     Shadow.Color:=StringToColor(Reader.ReadIdent)
  else
     Shadow.Color:=Reader.ReadInteger;
end;

procedure TTeeCustomShape.ReadShadowSize(Reader: TReader); // obsolete
begin
  Shadow.Size:=Reader.ReadInteger;
end;

Procedure TTeeCustomShape.DefineProperties(Filer:TFiler);
begin
  inherited;
  Filer.DefineProperty('ShadowColor',ReadShadowColor,nil,False);
  Filer.DefineProperty('ShadowSize',ReadShadowSize,nil,False);
end;

function TTeeCustomShape.GetGradientClass: TChartGradientClass;
begin
  result:=TChartGradient;
end;

Function TTeeCustomShape.GetHeight:Integer;
begin
  result:=ShapeBounds.Bottom-ShapeBounds.Top+1;  // 7.01
end;

Function TTeeCustomShape.GetWidth:Integer;
begin
  result:=ShapeBounds.Right-ShapeBounds.Left+1;  // 7.01
end;

procedure TTeeCustomShape.InitShadow(AShadow:TTeeShadow);
begin
  {$IFNDEF CLR}TShadowAccess{$ENDIF}(AShadow).InitValues(clBlack,3);
end;

Procedure TTeeCustomShape.PictureChanged(Sender:TObject);
begin
  Repaint;
end;

Function TTeeCustomShape.GetPicture:TBackImage;
begin
  if not Assigned(FPicture) then
  begin
    FPicture:=TBackImage.Create;
    FPicture.OnChange:=PictureChanged;
  end;

  result:=FPicture;
end;

Function TTeeCustomShape.GetShadowColor:TColor; // obsolete
begin
  result:=Shadow.Color;
end;

Function TTeeCustomShape.GetShadowSize:Integer; // obsolete
begin
  result:=Shadow.Size;
end;

procedure TTeeCustomShape.SetBevel(Value: TPanelBevel);
begin
  if FBevel<>Value then
  begin
    FBevel:=Value;
    Repaint;
  end;
end;

procedure TTeeCustomShape.SetBevelWidth(Value: TBevelWidth);
begin
  if FBevelWidth<>Value then
  begin
    FBevelWidth:=Value;
    Repaint;
  end;
end;

Procedure TTeeCustomShape.SetColor(Value:TColor);
begin
  if Assigned(ParentChart) then ParentChart.SetColorProperty(FColor,Value)
                           else FColor:=Value;
end;

Procedure TTeeCustomShape.SetFont(Value:TTeeFont);
begin
  FFont.Assign(Value);
end;

Function TTeeCustomShape.GetGradient:TChartGradient;
begin
  if not Assigned(FGradient) then
     FGradient:=GetGradientClass.Create(CanvasChanged);
  result:=FGradient;
end;

procedure TTeeCustomShape.SetGradient(Value:TChartGradient);
begin
  if Assigned(Value) then Gradient.Assign(Value)
                     else FreeAndNil(FGradient);
end;

procedure TTeeCustomShape.SetHeight(Value:Integer);
begin
  ShapeBounds.Bottom:=ShapeBounds.Top+Value-1;
end;

procedure TTeeCustomShape.SetWidth(Value:Integer);
begin
  ShapeBounds.Right:=ShapeBounds.Left+Value-1;
end;

procedure TTeeCustomShape.SetRoundSize(Value:Integer);
begin
  if FRoundSize<>Value then
  begin
    FRoundSize:=Value;
    Repaint;
  end;
end;

Procedure TTeeCustomShape.SetPicture(Value:TBackImage);
begin
  if Assigned(Value) then Picture.Assign(Value)
                     else FreeAndNil(FPicture);
  Repaint;
end;

procedure TTeeCustomShape.SetShadow(Value:TTeeShadow);
begin
  if Assigned(Value) then Shadow.Assign(Value)
                     else FreeAndNil(FShadow);
end;

Procedure TTeeCustomShape.SetShadowColor(Value:TColor); // obsolete
begin
  Shadow.Color:=Value;
end;

Procedure TTeeCustomShape.SetShadowSize(Value:Integer); // obsolete
begin
  Shadow.Size:=Value;
end;

Procedure TTeeCustomShape.SetShapeStyle(Value:TChartObjectShapeStyle);
Begin
  if FShapeStyle<>Value then
  begin
    FShapeStyle:=Value;
    Repaint;
  end;
end;

procedure TTeeCustomShape.SetTextFormat(Value:TTextFormat);
begin
  if FTextFormat<>Value then
  begin
    FTextFormat:=Value;
    Repaint;
  end;
end;

procedure TTeeCustomShape.SetTransparency(Value: TTeeTransparency);
begin
  if FTransparency<>Value then
  begin
    FTransparency:=Value;
    Repaint;
  end;
end;

procedure TTeeCustomShape.SetTransparent(Value:Boolean);
begin
  if Assigned(ParentChart) then ParentChart.SetBooleanProperty(FTransparent,Value)
                           else FTransparent:=Value;
end;

{ Zoom & Scroll (Panning) }
Procedure TZoomPanning.Check;
begin
  if X0>X1 Then SwapInteger(X0,X1);
  if Y0>Y1 Then SwapInteger(Y0,Y1);
end;

Procedure TZoomPanning.Activate(x,y:Integer);
Begin
  X0:=x;
  Y0:=y;
  X1:=x;
  Y1:=y;
  Active:=True;
End;

{ TTeeMouseEventListeners }
// Adds Item to the list. If duplicated, do not add again.
function TTeeEventListeners.Add(Const Item: ITeeEventListener): Integer;
begin
  {$IFDEF CLR}
  result:=IndexOf(Item);  // prevent duplicating... 6.0
  {$ELSE}
  result:=IndexOf(Pointer(Item));  // prevent duplicating... 6.0
  {$ENDIF}

  if result=-1 then
  begin
    result:=inherited Add(nil);
    inherited Items[result]:={$IFNDEF CLR}Pointer{$ENDIF}(Item);
  end;
end;

function TTeeEventListeners.Get(Index: Integer): ITeeEventListener;
begin
  {$IFDEF CLR}
  result:=({$IFOPT R-}List{$ELSE}inherited Items{$ENDIF}[Index]) as ITeeEventListener;
  {$ELSE}
  result:=ITeeEventListener({$IFOPT R-}List{$ELSE}inherited Items{$ENDIF}[Index]);
  {$ENDIF}
end;

function TTeeEventListeners.Remove(Item: ITeeEventListener): Integer;
begin
  result:=IndexOf({$IFNDEF CLR}Pointer{$ENDIF}(Item));

  if result>-1 then
  begin
    inherited Items[result]:=nil;

    Delete(result);
  end;
end;

{ TTeeExportData }
Procedure TTeeExportData.CopyToClipboard;
begin
  Clipboard.AsText:=AsString;
end;

Function TTeeExportData.AsString:String; // virtual; abstract;
begin
  result:='';
end;

Procedure TTeeExportData.SaveToStream(AStream:TStream);
var tmpSt : String;
    {$IFDEF CLR}
    Bytes : TBytes;
    {$ENDIF}
begin
  tmpSt:=AsString;
  {$IFDEF CLR}
  Bytes := BytesOf(tmpSt);
  AStream.Write(Bytes, Length(Bytes));
  {$ELSE}
  AStream.Write(PChar(tmpSt)^,Length(tmpSt));
  {$ENDIF}
end;

Procedure TTeeExportData.SaveToFile(Const FileName:String);
var tmp : TFileStream;
begin
  tmp:=TFileStream.Create(FileName,fmCreate);
  try
    SaveToStream(tmp);
  finally
    tmp.Free;
  end;
end;

// Returns True if point P is over (more or less "Tolerance" pixels)
// line:  FromPoint --> ToPoint
function PointInLine(const P,FromPoint,ToPoint:TPoint; const TolerancePixels:Integer):Boolean;
begin
  result:=PointInLine(P,FromPoint.X,FromPoint.Y,ToPoint.X,ToPoint.Y,TolerancePixels);
end;

Function PointInLine(const P:TPoint;
         const px,py,qx,qy,TolerancePixels:Integer):Boolean; overload;  // 7.04

  function Distance:Double;
  var dx : Double;
      dy : Double;
  begin
    if ((qX=pX) and (qY=pY)) Then
    begin
      dx:=P.X-pX;
      dy:=P.Y-pY;
      result:=Sqrt(dx*dx+dy*dy);
    end
    else
    begin
      dx:=qX-pX;
      dy:=qY-pY;

      result:=((P.X-pX)*dx+(P.Y-pY)*dy)/(dx*dx+dy*dy);

      if result<0 then
      begin
        dx:=P.X-pX;
        dy:=P.Y-pY;
      end
      else
      if result>1 then
      begin
        dx:=P.X-qX;
        dy:=P.Y-qY;
      end
      else
      begin
        dx:=P.X-(pX+result*dx);
        dy:=P.Y-(pY+result*dy);
      end;

      result:=Sqrt(dx*dx+dy*dy);
    end;
  end;

begin
  if (((P.X=pX) and (P.Y=pY)) or ((P.X=qX) and (P.Y=qY))) then
     result:=True
  else
     result:=Abs(Distance)<=Succ(TolerancePixels);
end;

Function PointInLineTolerance(Const P:TPoint; const px,py,qx,qy,TolerancePixels:Integer):Boolean; // deprecated / obsolete
begin
  result:=PointInLine(P,px,py,qx,qy,TolerancePixels);
end;

Function PointInLine(Const P:TPoint; const px,py,qx,qy:Integer):Boolean; {$IFDEF D9}inline;{$ENDIF}
Begin
  result:=PointInLine(P,px,py,qx,qy,0);
end;

Function PointInLine(Const P,FromPoint,ToPoint:TPoint):Boolean; overload; {$IFDEF D9}inline;{$ENDIF}
begin
  result:=PointInLine(P,FromPoint.X,FromPoint.Y,ToPoint.X,ToPoint.Y,0);
end;

Function PointInPolygon(Const P:TPoint; Const Poly:Array of TPoint):Boolean;
{ this is slow...
var Region:HRGN;
begin
  Region:=CreatePolygonRgn(Poly,1+High(Poly),0);
  result:=(Region>0) and PtInRegion(Region,p.x,p.y);
  DeleteObject(Region);
end;
}
var i,j : Integer;
begin
  result:=False;
  j:=High(Poly);
  for i:=0 to High(Poly) do
  begin
    if (((( Poly[i].Y <= P.Y ) and ( P.Y < Poly[j].Y ) ) or
         (( Poly[j].Y <= P.Y ) and ( P.Y < Poly[i].Y ) )) and
          ( P.X < (1.0* (( Poly[j].X - Poly[i].X ) * ( P.Y - Poly[i].Y )))
          / (1.0*( Poly[j].Y - Poly[i].Y )) + Poly[i].X )) then
             result:=not result;
    j:=i;
  end;
end;

Function PointInTriangle(Const P,P0,P1,P2:TPoint):Boolean; overload; {$IFDEF D9}inline;{$ENDIF}
begin
  result:=PointInPolygon(P,[P0,P1,P2]);
end;

Function PointInTriangle(Const P:TPoint; X0,X1,Y0,Y1:Integer):Boolean; overload; {$IFDEF D9}inline;{$ENDIF}
begin
  result:=PointInPolygon(P,[ TeePoint(X0,Y0),
                             TeePoint((X0+X1) div 2,Y1),
                             TeePoint(X1,Y0) ]);
end;

Function PointInHorizTriangle(Const P:TPoint; Y0,Y1,X0,X1:Integer):Boolean; {$IFDEF D9}inline;{$ENDIF}
begin
  result:=PointInPolygon(P,[ TeePoint(X0,Y0),
                             TeePoint(X1,(Y0+Y1) div 2),
                             TeePoint(X0,Y1) ]);
end;

Function PointInEllipse(Const P:TPoint; Left,Top,Right,Bottom:Integer):Boolean;
var tmpWidth   : Integer;
    tmpHeight  : Integer;
    tmpXCenter : Integer;
    tmpYCenter : Integer;
begin
  tmpXCenter:=(Left+Right) div 2;  // 6.01
  tmpYCenter:=(Top+Bottom) div 2;
  tmpWidth :=Sqr(tmpXCenter-Left);
  tmpHeight:=Sqr(tmpYCenter-Top);
  result:=(tmpWidth<>0) and (tmpHeight<>0) and
          ( (Sqr(1.0*P.X-tmpXCenter) / tmpWidth ) +
            (Sqr(1.0*P.Y-tmpYCenter) / tmpHeight) <= 1 );
end;

Function PointInEllipse(Const P:TPoint; Const Rect:TRect):Boolean; {$IFDEF D9}inline;{$ENDIF}
begin
  with Rect do
       result:=PointInEllipse(P,Left,Top,Right,Bottom);
end;

Function DelphiToLocalFormat(Const Format:String):String;
var t : Integer;
begin
  result:=Format;

  if ThousandSeparator<>DecimalSeparator then
  for t:=1 to Length(result) do
      if result[t]=',' then result[t]:=ThousandSeparator{$IFDEF CLR}[1]{$ENDIF} else
      if result[t]='.' then result[t]:=DecimalSeparator{$IFDEF CLR}[1]{$ENDIF};
end;

Function LocalToDelphiFormat(Const Format:String):String;
var t : Integer;
begin
  result:=Format;

  if ThousandSeparator<>DecimalSeparator then
  for t:=1 to Length(result) do
      if result[t]=ThousandSeparator{$IFDEF CLR}[1]{$ENDIF} then result[t]:=',' else
      if result[t]=DecimalSeparator then result[t]:='.';
end;

Procedure EnableControls(Enable:Boolean; Const ControlArray:Array of TControl);
var t : Integer;
begin
  for t:=Low(ControlArray) to High(ControlArray) do
  if Assigned(ControlArray[t]) then
     ControlArray[t].Enabled:=Enable;
end;

Function TeeRoundDate(Const ADate:TDateTime; AStep:TDateTimeStep):TDateTime;
var Year  : Word;
    Month : Word;
    Day   : Word;
begin
  if ADate<=Tee19000101 then result:=ADate
  else
  begin
    DecodeDate(ADate,Year,Month,Day);
    Case AStep of
       dtHalfMonth   : if Day>=15 then Day:=15
                                  else Day:=1;
       dtOneMonth,
       dtTwoMonths,
       dtThreeMonths,
       dtFourMonths,
       dtSixMonths   : Day:=1;
       dtOneYear     : begin
                         Day:=1;
                         Month:=1;
                       end;
    end;
    result:=EncodeDate(Year,Month,Day);
  end;
end;

Procedure TeeDateTimeIncrement( IsDateTime:Boolean;
                                Increment:Boolean;
                                var Value:Double;
                                Const AnIncrement:Double;
                                tmpWhichDateTime:TDateTimeStep);
var Year  : Word;
    Month : Word;
    Day   : Word;

 Procedure DecMonths(HowMany:Word);
 begin
   Day:=1;
   if Month>HowMany then Dec(Month,HowMany)
   else
   begin
     Dec(Year);
     Month:=12-(HowMany-Month);
   end;
 end;

 Procedure IncMonths(HowMany:Word);
 begin
   Day:=1;
   Inc(Month,HowMany);
   if Month>12 then
   begin
     Inc(Year);
     Month:=Month-12;
   end;
 end;

 Procedure IncDecMonths(HowMany:Word);
 begin
   if Increment then IncMonths(HowMany)
                else DecMonths(HowMany);
 end;

begin
  if IsDateTime then
  begin
    DecodeDate(Value,year,month,day);
    Case tmpWhichDateTime of
       dtHalfMonth   : Begin
                         if Day>15 then Day:=15
                         else
                         if Day>1 then Day:=1
                         else
                         begin
                           IncDecMonths(1);
                           Day:=15;
                         end;
                       end;
       dtOneMonth    : IncDecMonths(1);
       dtTwoMonths   : IncDecMonths(2);
       dtThreeMonths : IncDecMonths(3);
       dtFourMonths  : IncDecMonths(4);
       dtSixMonths   : IncDecMonths(6);
       dtOneYear     : if Increment then Inc(year) else Dec(year);
    else
    begin
      if Increment then Value:=Value+AnIncrement
                   else Value:=Value-AnIncrement;
      Exit;
    end;
    end;
    Value:=EncodeDate(year,month,day);
  end
  else
  begin
    if Increment then Value:=Value+AnIncrement
                 else Value:=Value-AnIncrement;
  end;
end;

Procedure TeeSort( StartIndex,EndIndex:Integer; CompareFunc:TTeeSortCompare;
                   SwapFunc:TTeeSortSwap);

  procedure PrivateSort(l,r:Integer);
  var i : Integer;
      j : Integer;
      x : Integer;
  begin
    i:=l;
    j:=r;
    x:=(i+j) shr 1;

    while i<j do
    begin
      while CompareFunc(i,x)<0 do inc(i);
      while CompareFunc(x,j)<0 do dec(j);

      if i<j then
      begin
        SwapFunc(i,j);
        if i=x then x:=j else if j=x then x:=i;
      end;

      if i<=j then
      begin
        inc(i);
        dec(j)
      end;
    end;

    if l<j then PrivateSort(l,j);
    if i<r then PrivateSort(i,r);
  end;

begin
  PrivateSort(StartIndex,EndIndex);
end;

{ Helper functions }
Function TeeGetUniqueName(AOwner:TComponent; Const AStartName:String):TComponentName;

  Function FindNameLoop:String;
  var tmp : Integer;
  begin
    if Assigned(AOwner) then
    begin
      tmp:={$IFDEF TEEOCX}0{$ELSE}1{$ENDIF};

      while Assigned(AOwner.FindComponent(AStartName+TeeStr(tmp))) do
           Inc(tmp);

      result:=AStartName+TeeStr(tmp);
    end
    else result:=AStartName+'1';
  end;

{$IFNDEF D6}
{$IFNDEF CLX}
{$IFNDEF LCL}
{$DEFINE USE_DESIGNER}
{$ENDIF}
{$ENDIF}
{$ENDIF}

{$IFDEF USE_DESIGNER}
{$IFNDEF TEEOCX}
var tmpForm : TCustomForm;
    Designer : {$IFDEF D5}IDesigner{$ELSE}IFormDesigner{$ENDIF};
{$ENDIF}
begin
  result:='';
  if Assigned(AOwner) then
  begin
    {$IFNDEF TEEOCX}
    if AOwner is TCustomForm then
    begin
      tmpForm:=TCustomForm(AOwner);
      if Assigned(tmpForm.Designer) then
      begin
        Designer:=nil;
        tmpForm.Designer.QueryInterface({$IFDEF D5}IDesigner{$ELSE}IFormDesigner{$ENDIF},Designer);
        if Assigned(Designer) then result:=Designer.UniqueName('T'+AStartName);
      end;
    end;
    {$ENDIF}

    if result='' then result:=FindNameLoop;
  end;

{$ELSE}
begin
  result:=FindNameLoop;
{$ENDIF}
end;

{ returns number of sections in St string separated by ";" }
Function TeeNumFields(St:String):Integer;
var i : Integer;
begin
  if St='' then result:=0
  else
  begin
    result:=1;
    i:={$IFDEF CLR}Pos{$ELSE}AnsiPos{$ENDIF}(TeeFieldsSeparator,St);
    While i>0 do
    begin
      Inc(result);
      Delete(St,1,i);
      i:={$IFDEF CLR}Pos{$ELSE}AnsiPos{$ENDIF}(TeeFieldsSeparator,St);
    end;
  end;
end;

Function TeeNumFields(const St,Separator:String):Integer;
var Old : String;
begin
  Old:=TeeFieldsSeparator;
  TeeFieldsSeparator:=Separator;
  try
    result:=TeeNumFields(St);
  finally
    TeeFieldsSeparator:=Old;
  end;
end;

{ returns the index-th section in St string separated by ";" }
Function TeeExtractField(St:String; Index:Integer):String;
var i : Integer;
begin
  result:='';
  if (St<>'') and (Index>0) then   { 5.03 }
  begin
    i:={$IFDEF CLR}Pos{$ELSE}AnsiPos{$ENDIF}(TeeFieldsSeparator,St);
    While i>0 do
    begin
      Dec(Index);
      if Index=0 then
      begin
        result:=Copy(St,1,i-1);
        exit;
      end;
      Delete(St,1,i);
      i:={$IFDEF CLR}Pos{$ELSE}AnsiPos{$ENDIF}(TeeFieldsSeparator,St);
    end;
    result:=St;
  end;
end;

Function TeeExtractField(St:String; Index:Integer; const Separator:String):String;
var Old : String;
begin
  Old:=TeeFieldsSeparator;
  TeeFieldsSeparator:=Separator;
  try
    result:=TeeExtractField(St,Index);
  finally
    TeeFieldsSeparator:=Old;
  end;
end;

{$IFNDEF CLR}
type PTeeBitmap=^TTeeBitmap;
     TTeeBitmap=packed record
       Name1  : String;
       Name2  : String;
       Bitmap : TBitmap;
     end;

{ Load the Bitmap resource with Name1 or Name2 name }
function LoadTeeBitmap(AInstance: Integer; Data: Pointer): Boolean;

  { Try to find a resource bitmap and load it }
  Function TryFindResource(Const ResName:String):Boolean;
  var tmpSt : TeeString256;
  begin
    StrPCopy(tmpSt,ResName);

    if FindResource(AInstance, tmpSt, RT_BITMAP)<>0 then
    begin
      PTeeBitmap(Data)^.Bitmap.LoadFromResourceName(AInstance,ResName);
      result:=True;
    end
    else result:=False;
  end;

begin
  result:=True;
  try
    With PTeeBitmap(Data)^ do
    if TryFindResource(Name1) or
       TryFindResource(Name2) then
         result:=False;
  except
    on Exception do ;
  end;
end;
{$ENDIF}

Procedure TeeLoadBitmap(Bitmap:TBitmap; Const Name1,Name2:String);
var {$IFDEF CLR}
    tmpStream : Stream;
    {$ELSE}
    tmpBitmap : TTeeBitmap;
    {$ENDIF}
begin
  {$IFDEF CLR}

  tmpStream:=Assembly.GetExecutingAssembly.GetManifestResourceStream(Name1+'.bmp');
  if Assigned(tmpStream) then
     Bitmap.Assign(System.Drawing.Bitmap.Create(tmpStream))
  else
  begin
    tmpStream:=Assembly.GetExecutingAssembly.GetManifestResourceStream(Name2+'.bmp');
    if Assigned(tmpStream) then
       Bitmap.Assign(System.Drawing.Bitmap.Create(tmpStream))
  end;

  {$ELSE}

  tmpBitmap.Bitmap:=Bitmap;
  tmpBitmap.Name1:=Name1;
  tmpBitmap.Name2:=Name2;

  {$IFDEF LCL}
  LoadTeeBitmap(HInstance,@tmpBitmap);
  {$ELSE}
  EnumModules(LoadTeeBitmap,@tmpBitmap);
  {$ENDIF}
  {$ENDIF}
end;

{ Returns a bitmap from the linked resources that has the same name
  than our class name or parent class name }
Procedure TeeGetBitmapEditor(AObject:TObject; var Bitmap:TBitmap); {$IFDEF D9}inline;{$ENDIF}
begin
  TeeLoadBitmap(Bitmap,AObject.ClassName,AObject.ClassParent.ClassName);
end;

{$IFNDEF D6}
function TryStrToFloat(const S: String; var Value:Double):Boolean;
var tmp : Double;
begin
  result:=TextToFloat(PChar(S), tmp, fvExtended);
  if result then
     Value:=tmp;
end;

function StrToFloatDef(const S: string; const Default: Extended): Extended;
begin
  if not TextToFloat(PChar(S), Result, fvExtended) then
    Result := Default;
end;
{$ENDIF}

// Returns True when lines X1Y1->X2Y2 and X3Y3->X4Y4 cross.
// Returns crossing position at x and y var parameters.
function CrossingLines(const X1,Y1,X2,Y2,X3,Y3,X4,Y4:Double; out x,y:Double):Boolean;
var slope1 : Double;
    slope2 : Double;
    intercept1 : Double;
    intercept2 : Double;
    Dif,
    A1, B1, C1, A2, B2, C2 : Double;
begin
  A1:=Y2-Y1;
  A2:=Y4-Y3;
  B1:=X2-X1;
  B2:=X4-X3;

  slope1 := A1 / B1;
  slope2 := A2 / B2;
  Intercept1 := Y1 - (slope1 * X1);
  Intercept2 := Y3 - (slope2 * X3);

  Dif:=slope2-slope1;
  if Abs(Dif)>1E-15 then
     X:= (Intercept1-Intercept2) / Dif
  else
     X:=X2;

  Y:= (slope1 * X) + Intercept1;

  C1:=(X1*Y2)-(X2*Y1);
  C2:=(X3*Y4)-(X4*Y3);

  result:=(((A1*X3-B1*Y3-C1>0) xor (A1*X4-B1*Y4-C1>0)) and
          ((A2*X1-B2*Y1-C2>0) xor (A2*X2-B2*Y2-C2>0)));
end;

// TRANSLATIONS
Procedure TeeTranslateControl(AControl:TControl; const ExcludeChilds:Array of TControl);
begin
  // if current language is English, do not translate...
  if Assigned(TeeTranslateHook) then
     TeeTranslateHook(AControl,ExcludeChilds);
end;

Procedure TeeTranslateControl(AControl:TControl);
begin
  TeeTranslateControl(AControl,[]);
end;

Function ReplaceChar(const AString:String; const Search:{$IFDEF NET}String{$ELSE}Char{$ENDIF};
                     const Replace:Char=#0):String;
var i : Integer;
begin
  result:=AString;

  Repeat
    i:={$IFDEF CLR}Pos{$ELSE}AnsiPos{$ENDIF}(Search,result);
    if i>0 then
       if Replace=#0 then Delete(result,i,1)
                     else result[i]:=Replace; // 6.01
  Until i=0;
end;

Function TeeAntiAlias(Panel:TCustomTeePanel; ChartRect:Boolean=False):TBitmap;
begin
  result:=Panel.TeeCreateBitmap(Panel.Color,Panel.ClientRect,TeePixelFormat);
  TSoftenFilter.ApplyTo(result);
end;

{$IFDEF CLR}
Constructor TTeeEvent.Create;
begin
  inherited Create;
end;
{$ENDIF}

Const DefaultPalette:Array[0..MaxDefaultColors] of TColor=
        ( clRed,
          clGreen,
          clYellow,
          clBlue,
          clWhite,
          clGray,
          clFuchsia,
          clTeal,
          clNavy,
          clMaroon,
          clLime,
          clOlive,
          clPurple,
          clSilver,
          clAqua,
          clBlack,
          clMoneyGreen,
          clSkyBlue,
          clCream,
          clMedGray
          );

Procedure SetDefaultColorPalette; overload;
begin
  SetDefaultColorPalette(DefaultPalette);
end;

Procedure SetDefaultColorPalette(const Palette:Array of TColor); overload;
var t:Integer;
begin
  if High(Palette)=0 then SetDefaultColorPalette
  else
  begin
    ColorPalette:=nil;
    SetLength(ColorPalette,High(Palette)+1);  // +1 ??
    for t:=Low(Palette) to High(Palette) do
        ColorPalette[t]:=Palette[t];
  end;
end;

function TeeReadBoolOption(const AKey:String; DefaultValue:Boolean):Boolean;
begin
  result:=DefaultValue;

  {$IFDEF LINUX}
  with TIniFile.Create(ExpandFileName('~/.teechart')) do
  try
    result:=ReadBool('Editor', AKey, DefaultValue);
  {$ELSE}
  with TRegistry.Create do
  try
    if OpenKeyReadOnly(TeeMsg_EditorKey) and ValueExists(AKey) then
       result:=ReadBool(AKey);
  {$ENDIF}
  finally
    Free;
  end;
end;

procedure TeeSaveBoolOption(const AKey:String; Value:Boolean);
begin
  {$IFDEF LINUX}
  with TIniFile.Create(ExpandFileName('~/.teechart')) do
  try
    WriteBool('Editor',AKey,Value);
  {$ELSE}
  with TRegistry.Create do
  try
    if OpenKey(TeeMsg_EditorKey,True) then
       WriteBool(AKey,Value);
  {$ENDIF}
  finally
    Free;
  end;
end;

Function TeeReadIntegerOption(const AKey:String; DefaultValue:Integer):Integer;
begin
  result:=DefaultValue;

  {$IFDEF LINUX}
  with TIniFile.Create(ExpandFileName('~/.teechart')) do
  try
    result:=ReadInteger('Editor', AKey, DefaultValue);
  {$ELSE}
  With TRegistry.Create do
  try
    if OpenKeyReadOnly(TeeMsg_EditorKey) and ValueExists(AKey) then
       result:=ReadInteger(AKey);
  {$ENDIF}
  finally
    Free;
  end;
end;

procedure TeeSaveIntegerOption(const AKey:String; Value:Integer);
begin
  {$IFDEF LINUX}
  with TIniFile.Create(ExpandFileName('~/.teechart')) do
  try
    WriteInteger('Editor',AKey,Value);
  {$ELSE}
  With TRegistry.Create do
  try
    if OpenKey(TeeMsg_EditorKey,True) then
       WriteInteger(AKey,Value);
  {$ENDIF}
  finally
    Free;
  end;
end;

function TeeReadStringOption(const AKey,DefaultValue:String):String;
begin
  result:=DefaultValue;

  {$IFDEF LINUX}
  with TIniFile.Create(ExpandFileName('~/.teechart')) do
  try
    result:=ReadString('Editor', AKey, DefaultValue);
  {$ELSE}
  with TRegistry.Create do
  try
    if OpenKeyReadOnly(TeeMsg_EditorKey) and ValueExists(AKey) then
       result:=ReadString(AKey);
  {$ENDIF}
  finally
    Free;
  end;
end;

procedure TeeSaveStringOption(const AKey,Value:String);
begin
  {$IFDEF LINUX}
  with TIniFile.Create(ExpandFileName('~/.teechart')) do
  try
    WriteString('Editor',AKey,Value);
  {$ELSE}
  with TRegistry.Create do
  try
    if OpenKey(TeeMsg_EditorKey,True) then
       WriteString(AKey,Value);
  {$ENDIF}
  finally
    Free;
  end;
end;

function TeeDefaultXMLEncoding:String;
begin
  {$IFNDEF LINUX}
  {$IFNDEF LCL}
  if SysLocale.PriLangID=LANG_JAPANESE then
     result:='shift_jis'
  else
  {$ENDIF}
  {$ENDIF}
     result:='ISO-8859-1';
end;

type
  TStringsStack=class(TStringList)
  public
    function Pop:String;
    function Push(const Value:String):Integer;
  end;

function TStringsStack.Pop:String;
begin
  if Count=0 then result:=''
  else
  begin
    result:=Strings[Count-1];
    Delete(Count-1);
  end;
end;

function TStringsStack.Push(const Value:String):Integer;
begin
  Append(Value);
  result:=Count-1;
end;

procedure ConvertTextToXML(Stream:TStream; XMLHeader:Boolean=True);
const
  ObjectConst='OBJECT';
  TabStep=2;

var n : Integer;
    Dest : TStrings;
    Tags : TStringsStack;
    Objects : TStringsStack;

  function Spaces(Count:Integer):String;
  var t : Integer;
  begin
    SetLength(result,Count);
    for t:=1 to Count do
        result[t]:=' ';
  end;

  procedure BeginObject(const s:String; Source:TStrings; var t:Integer);
  var i : Integer;
      tmp2,
      tmp : String;
  begin
    i:=Pos(':',s);

    if i>0 then
    begin
      tmp:=Trim(Copy(s,i+1,Length(s)));
      tmp2:=tmp+' Name="'+Trim(Copy(s,Length(ObjectConst)+1,i-1-Length(ObjectConst)))+'"';
    end
    else
    begin
      tmp:=Trim(Copy(s,Length(ObjectConst)+1,Length(s)));
      tmp2:=tmp;
    end;

    if UpperCase(Trim(Source[t+1]))='END' then
    begin
      Dest.Add(Spaces(n)+'<'+tmp2+'/>');
      Inc(t);
    end
    else
    begin
      Dest.Add(Spaces(n)+'<'+tmp2+'>');
      Objects.Push(tmp);
      Inc(n,TabStep);
    end;
  end;

  procedure AddTag(const Tag:String);
  begin
    if n>=TabStep then
       Dec(n,TabStep)
    else
       n:=0;

    Dest.Add(Spaces(n)+'</'+Tag+'>');
  end;

  procedure AddTags(TagStart:Integer); overload;
  begin
    while Tags.Count>TagStart do
          AddTag(Tags.Pop);
  end;

  procedure AddTags; overload;
  begin
    AddTags(0);
  end;

  procedure AddStrings(Source:TStrings; var t : Integer);
  var s,
      tmp : String;
  begin
    Inc(n,TabStep);

    repeat
      Inc(t);

      s:=Trim(Source[t]);
      tmp:=Copy(s,Length(s),1);
      s:=Copy(s,1,Length(s)-1);
      s:='String value="'+s+'"';
      Dest.Add(Spaces(n)+'<'+s+'/>');

    until (tmp=')') or (tmp='}');

    Inc(t);
  end;

  procedure AddItems(Source:TStrings; var t : Integer);
  var tmp,
       s : String;
      i : Integer;
      Items : TStringsStack;
  begin
    Items:=TStringsStack.Create;
    try
      Inc(n,TabStep);

      repeat
        Inc(t);

        s:=Trim(Source[t]);

        i:=Pos('=',s);

        tmp:=UpperCase(s);

        if i=0 then
        begin
          if (tmp='END') or (tmp='END>') then
          begin
            Dec(n,TabStep);
            Dest.Add(Spaces(n)+'</'+Items.Pop+'>');
          end
          else
          begin
            Dest.Add(Spaces(n)+'<'+s+'>');
            Items.Push(s);
            Inc(n,TabStep);
          end;
        end
        else
           Dest.Add(Spaces(n)+'<'+Trim(Copy(s,1,i-1))+' value="'+Trim(Copy(s,i+1,Length(s)))+'"/>');

      until tmp='END>';

      Inc(t);
    finally
      Items.Free;
    end;
  end;

var i,
    TagIndex,
    tmpEq,
    t    : Integer;
    ss,
    sss,
    tmpValue,
    tmp,
    tmpTag,
    s : String;

    Source:TStrings;
begin
  Dest:=TStringList.Create;
  Tags:=TStringsStack.Create;
  Objects:=TStringsStack.Create;
  Source:=TStringList.Create;

  try
    if XMLHeader then
       Dest.Add('<?xml version="1.0" encoding="'+TeeDefaultXMLEncoding+'"?>');

    Source.LoadFromStream(Stream);

    n:=0;

    t:=0;
    while t<Source.Count do
    begin
      s:=Trim(Source[t]);

      if s='' then
         Continue;

      if UpperCase(Copy(s,1,Length(ObjectConst)))=ObjectConst then
         BeginObject(s,Source,t)
      else
      begin
        if Pos('.',s)=0 then
           AddTags
        else
        begin

          TagIndex:=-1;

          ss:=s;
          repeat
            tmpEq:=Pos('=',s);
            i:=Pos('.',ss);

            if (tmpEq>0) and (i>tmpEq) then
               i:=0;

            if i>0 then
            begin
              sss:=Copy(ss,1,i-1);

              Inc(TagIndex);

              if (Tags.Count<=TagIndex) or (Tags[TagIndex]<>sss) then
              begin
                AddTags(TagIndex);
                Tags.Add(sss);
                Dest.Add(Spaces(n)+'<'+sss+'>');

                Inc(n,TabStep);
              end;

              Delete(ss,1,i);
              Delete(s,1,i);

            end;

          until i=0;

          if Tags.Count>TagIndex+1 then
             AddTags(TagIndex+1);
        end;

        i:=Pos('=',s);

        if i>0 then
        begin
          tmp:=Trim(Copy(s,i+1,Length(s)));

          if (tmp='{') or (tmp='(') then
          begin
            tmpTag:=Trim(Copy(s,1,i-1));

            Dest.Add(Spaces(n)+'<'+tmpTag+'>');
            Tags.Push(tmpTag);
            AddStrings(Source,t);
            AddTag(Tags.Pop);

            Continue;
          end
          else
          begin
            tmpValue:=Copy(s,i+2,Length(s));

            if Trim(tmpValue)='<' then
            begin
              tmpTag:=Trim(Copy(s,1,i-1));

              Dest.Add(Spaces(n)+'<'+tmpTag+'>');
              Tags.Push(tmpTag);
              AddItems(Source,t);
              AddTag(Tags.Pop);

              Continue;
            end
            else
            begin
              if Trim(tmpValue)='<>' then
                 tmpValue:='';

              s:=Copy(s,1,i-1)+'value="'+tmpValue+'"';

              Dest.Add(Spaces(n)+'<'+s+'/>');
            end;
          end;
        end
        else
        if UpperCase(s)='END' then
        begin
          AddTags;
          Dec(n,TabStep);
          Dest.Add(Spaces(n)+'</'+Objects.Pop+'>');
        end
        else
          Assert(False,'Wrong DFM format: '+s);
      end;

      Inc(t);
    end;

    Stream.Position:=0;
    Dest.SaveToStream(Stream);

  finally
    Source.Free;
    Objects.Free;
    Tags.Free;
    Dest.Free;
  end;
end;

Procedure TeeGotoURL(Handle: TeeWindowHandle; Const URL:String);
{$IFNDEF LINUX}
{$IFNDEF CLR}
Var St : TeeString256;
{$ENDIF}
{$ENDIF}
begin
  {$IFNDEF LINUX}
  {$IFNDEF LCL}
  ShellExecute({$IFDEF CLX}0{$ELSE}Handle{$ENDIF},'open', // Do not localize
               {$IFDEF CLR}URL{$ELSE}StrPCopy(St,URL){$ENDIF},
               nil,
               {$IFDEF CLR}''{$ELSE}nil{$ENDIF},
               SW_SHOW);  { <-- do not translate }
  {$ENDIF}
  {$ENDIF}
end;

const
  NullCursor={$IFDEF CLX}nil{$ELSE}0{$ENDIF};

initialization
  SetDefaultColorPalette;

  {$IFDEF CLR}
  Screen.Cursors[crTeeHand]:=Screen.Cursors[crHandPoint];
  {$ELSE}
  {$IFDEF CLX}
  Screen.Cursors[crTeeHand]:=QCursorH(0);
  {$ELSE}
  Screen.Cursors[crTeeHand]:=LoadCursor(HInstance,'TEE_CURSOR_HAND');
  {$ENDIF}
  {$ENDIF}

  { Optimization for TeeRoundDate function }
  Tee19000101:=EncodeDate(1900,1,1);
finalization
  ColorPalette:=nil;

  {$IFNDEF CLR}
  Screen.Cursors[crTeeHand]:=NullCursor;
  {$ENDIF}
end.
