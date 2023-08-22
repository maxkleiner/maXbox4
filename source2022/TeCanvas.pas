{**********************************************}
{   TeeChart and TeeTree TCanvas3D component   }
{                                              }
{   Copyright (c) 1999-2007 by David Berneda   }
{        All Rights Reserved                   }
{**********************************************}
unit TeCanvas;
{$I TeeDefs.inc}

interface

{$DEFINE TEEWINDOWS}

{$IFNDEF CLR}
{$IFDEF D6}
{$DEFINE TEEUNICODE}
{$ENDIF}
{$ENDIF}

{$IFNDEF CLX}
{$IFNDEF LCL}
{$DEFINE IGNOREPALETTE}
{$ENDIF}
{$ENDIF}

Uses {$IFNDEF LINUX}
     {$IFDEF TEEWINDOWS}
     Windows,
     {$ENDIF}
     {$IFDEF TEEVCL}
     Messages,
     {$ENDIF}
     {$ENDIF}

     {$IFDEF TEEVCL}
     Classes, SysUtils,

     {$ENDIF}

     {$IFDEF CLX}
     Qt, QGraphics, QStdCtrls, QControls, QComCtrls, Types,
     {$ELSE}
     Controls, StdCtrls, Graphics,
     {$ENDIF}

     {$IFDEF CLR}
     System.ComponentModel,
     {$ENDIF}

     {$IFDEF LCL}
     Buttons, LMessages,
     {$ENDIF}

     {$IFNDEF CLX}
     {$IFDEF D6}
     Types,
     {$ENDIF}
     {$ENDIF}

     TypInfo
     {$IFDEF AXUNICODE}
     , TeeUnicode
     {$ENDIF}
     ;

Const
  TeePiStep:Double      = Pi/180.0;
  {$NODEFINE TeePiStep}  { for C++ Builder }

  TeeDefaultPerspective = 100;
  TeeMinAngle           = 270;

  {$IFNDEF D6}
  clMoneyGreen = TColor($C0DCC0);
  clSkyBlue    = TColor($F0CAA6);
  clCream      = TColor($F0FBFF);
  clMedGray    = TColor($A4A0A0);
  {$ENDIF}

  {$IFDEF CLX}
  clMoneyGreen = TColor($C0DCC0);
  clSkyBlue    = TColor($F0CAA6);
  clCream      = TColor($F0FBFF);
  clMedGray    = TColor($A4A0A0);

  {$IFDEF LINUX}
  TA_LEFT   = 0;
  TA_RIGHT  = 2;
  TA_CENTER = 6;
  TA_TOP    = 0;
  TA_BOTTOM = 8;

  PATCOPY      = 0;
  {$ENDIF}
  {$ENDIF}

  NumCirclePoints = 64;

  {$IFNDEF TEEWINDOWS}
  DEFAULT_CHARSET = 1;
  ANTIALIASED_QUALITY = 4;
  TA_LEFT = 0;

  bs_Solid=0;
  {$ENDIF}

  {$IFNDEF TEEVCL}
  clGray=0;
  clDkGray=0;
  clWhite=$FFFFFF;
  clSilver=0;
  clDefault=-1;
  clNone=-2;
  clBlack=0;
  clYellow=$FFFF;

  pf24Bit=0;
  pfDevice=1;

  CM_MOUSELEAVE=10000;
  CM_SYSCOLORCHANGE=10001;
  {$ENDIF}

  TeeZeroRect : TRect=( Left:0; Top:0; Right:0; Bottom:0 );

  {$IFDEF LCL}
  DC_BRUSH = 18;
  DC_PEN = 19;
  {$ENDIF}

var
  TeeDefaultConePercent : Integer=0;
  TeeCheckPenWidth      : Boolean=False; { Fix for HP Laserjet printers bug }

type
     {$IFNDEF TEEWINDOWS}
     TPoint=packed record
       X,Y: Integer;
     end;

     TRect = packed record
       case Integer of
         0: (Left, Top, Right, Bottom: Integer);
         1: (TopLeft, BottomRight: TPoint);
     end;

     HDC=Integer;
     HPen=Integer;
     HRgn=Integer;

     COLORREF = LongWord;

     TLogBrush=packed record
       lbStyle:Integer;
       lbColor:TColor;
       lbHatch:Integer;
     end;
     {$ENDIF}

     {$IFNDEF TEEVCL}
     {$DEFINE TEECANVASLOCKS}

     TNotifyEvent = procedure(Sender: TObject) of object;

     TPersistent = class(TObject)
     public
       Procedure Assign(Source:TPersistent); virtual;
     end;

     TComponent=class(TPersistent);

     TCreateParams=class
     end;

     TGraphicObject=class(TPersistent)
     private
       FOnChange : TNotifyEvent;
     public
       procedure Changed;
       property OnChange:TNotifyEvent read FOnChange write FOnChange;
     end;

     TPenStyle=(psSolid,psDash,psDot,psDashDot,psDashDotDot,psClear,psInsideFrame);

     TPenMode = (pmBlack, pmWhite, pmNop, pmNot, pmCopy, pmNotCopy,
      pmMergePenNot, pmMaskPenNot, pmMergeNotPen, pmMaskNotPen, pmMerge,
      pmNotMerge, pmMask, pmNotMask, pmXor, pmNotXor);

     TPen=class(TGraphicObject)
     private
       FColor : TColor;
       FStyle : TPenStyle;
       FWidth : Integer;
       FMode : TPenMode;
       FOnChange : TNotifyEvent;
     public
       Handle : HPen;
       property Color: TColor read FColor write FColor;
       property Mode:TPenMode read FMode write FMode;
       property Style: TPenStyle read FStyle write FStyle;
       property Width: Integer read FWidth write FWidth;
     end;

     TGraphic=class(TPersistent)
     public
       Palette : Integer;
       Width, Height : Integer;
       Empty : Boolean;
     end;

     PByteArray = ^TByteArray;
     TByteArray = array[0..32767] of Byte;

     TCanvas=class;

     TBitmap=class(TGraphic)
     private
     public
       PixelFormat : Integer;
       IgnorePalette : Boolean;
       Canvas : TCanvas;
       ScanLine:Array of Pointer;
     end;

     TPicture=class(TGraphicObject)
     public
       Graphic:TGraphic;
       Bitmap:TBitmap;
     end;

     TBrushStyle=(bsClear, bsSolid,bsDiagonal);

     TBrush=class(TGraphicObject)
     private
       FColor : TColor;
       FBitmap : TBitmap;
       FStyle : TBrushStyle;
     public
       Handle : HBrush;

       property Bitmap:TBitmap read FBitmap write FBitmap;
       property Color: TColor read FColor write FColor;
       property Style: TBrushStyle read FStyle write FStyle;
     end;

     TFontStyle=(fsBold, fsItalic, fsUnderline, fsStrikeThrough);
     TFontStyles=set of TFontStyle;

     TFont=class(TGraphicObject)
     private
       FColor : TColor;
       FHeight : Integer;
       FName : String;
       FStyle : TFontStyles;
       FSize: Integer;
       FSet   : Integer;
     public
       PixelsPerInch : Integer;
       Handle : HFont;

       property CharSet : Integer read FSet write FSet;
       property Color: TColor read FColor write FColor;
       property Height : Integer read FHeight write FHeight;
       property Name : String read FName write FName;
       property Size:Integer read FSize write FSize;
       property Style:TFontStyles read FStyle write FStyle;
     end;

     TCanvas=class(TObject)
     private
       FOnChange:TNotifyEvent;
       FOnChanging:TNotifyEvent;
       function GetPixel(X, Y: Integer): TColor;
       procedure SetPixel(X, Y: Integer; Value: TColor);
     public
       Pen:TPen;
       Brush:TBrush;
       Font:TFont;
       Handle : HDC;
       procedure CopyRect(const Dest: TRect; Canvas: TCanvas; const Source: TRect);
       function TextExtent(const Text:String): TSize;
       property OnChange:TNotifyEvent read FOnChange write FOnChange;
       property OnChanging:TNotifyEvent read FOnChange write FOnChange;
       procedure Draw(X, Y: Integer; Graphic: TGraphic);
       procedure StretchDraw(const Rect: TRect; Graphic: TGraphic);
       property Pixels[X, Y: Integer]: TColor read GetPixel write SetPixel;
     end;

     TStrings=class(TComponent);

     TCursor=Integer;

     TFiler=class
     end;

     TCustomPanel=class(TComponent)
     protected
       procedure AssignTo(Dest: TPersistent); virtual;
       procedure CreateParams(var Params: TCreateParams); virtual;
       Procedure DefineProperties(Filer:TFiler); virtual; // obsolete
     public
       Constructor Create(AOwner: TComponent); virtual;
     end;

     TMouseButton=(mbLeft,mbMiddle,mbRight);
     TBorderStyle=(bsSingle);
     {$ENDIF}

     {$IFDEF CLX}

     // Fake class to support TUpDown in CLX
     // Inherits from CLX TSpinEdit control.
     TUDBtnType=(btNext, btPrev);
     TUDOrientation=(udHorizontal, udVertical);

     TUpDown=class(TSpinEdit)
     private
       FAssociate   : TComponent;
       FOrientation : TUDOrientation;
       FThousands   : Boolean;

       IChangingText : Boolean;
       OldChanged    : TNotifyEvent;
       Procedure DoChangeEdit;
       Procedure ChangedEdit(Sender:TObject);
       Procedure GetOldChanged;
       function GetPosition: Integer;
       procedure SetPosition(const AValue: Integer);
       procedure SetAssociate(const AValue: TComponent);
     protected
       procedure Change(AValue: Integer); override;
       Procedure Loaded; override;
     public
       Constructor Create(AOwner:TComponent); override;
     published
       property Associate:TComponent read FAssociate write SetAssociate;
       property Orientation: TUDOrientation read FOrientation write FOrientation default udVertical;
       property Position:Integer read GetPosition write SetPosition default 0;
       property Thousands: Boolean read FThousands write FThousands default True;
     end;
     {$ENDIF}

  TFilterRegion=class(TPersistent)
  private
    FHeight : Integer;
    FLeft   : Integer;
    FTop    : Integer;
    FWidth  : Integer;

    function GetRectangle:TRect;
    procedure SetRectangle(const Rect:TRect);
  public
    procedure Assign(Source:TPersistent); override;

    property Rectangle:TRect read GetRectangle write SetRectangle;
  published
    property Height:Integer read FHeight write FHeight default 0;
    property Left:Integer read FLeft write FLeft default 0;
    property Top:Integer read FTop write FTop default 0;
    property Width:Integer read FWidth write FWidth default 0;
  end;

  TRGB=packed record
    Blue  : Byte;
    Green : Byte;
    Red   : Byte;

    {$IFDEF CLX}
    Alpha : Byte; // Linux
    {$ENDIF}
  end;

  TRGBs=packed Array[0..0] of TRGB;
  PRGBs=^TRGBs;

  IFormCreator=interface
   ['{6A8D432B-EB81-11D1-AAB1-00C04FB16FBC}']
     function AddCheckBox(const PropName,ACaption:String; OnChange:TNotifyEvent=nil):TCheckBox;
    function AddColor(const PropName,ACaption:String):TButton;
    function AddCombo(const PropName:String):TComboBox;
    function AddInteger(const PropName,ACaption:String; AMin,AMax:Integer):TEdit;
    function AddScroll(const PropName:String; AMin,AMax:Integer):TScrollBar;
  end;

  {$IFDEF CLR}
  {$UNSAFECODE ON}
  {$ENDIF}

  TRGBArray=Array of PRGBs;

  {$IFDEF CLR}
  {$UNSAFECODE OFF}
  {$ENDIF}

  TTeeFilter=class(TCollectionItem)
  private
    FEnabled : Boolean;
    FRegion  : TFilterRegion;

    function GetRegion:TFilterRegion;
  protected
    AllowRegion : Boolean;
    FChanged    : TNotifyEvent;
    ReuseLines  : Boolean;

    procedure CalcLines(Bitmap:TBitmap);
  public
    {$IFDEF CLR}
    {$UNSAFECODE ON}
    {$ENDIF}

    Lines       : TRGBArray;

    {$IFDEF CLR}
    {$UNSAFECODE OFF}
    {$ENDIF}

    Constructor Create(Collection:TCollection); override;
    Destructor Destroy; override;

    class procedure ApplyTo(Bitmap:TBitmap); overload;
    procedure Apply(Bitmap: TBitmap); overload;
    procedure Apply(Bitmap: TBitmap; const R:TRect); overload; virtual;

    procedure Assign(Source:TPersistent); override;

    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); virtual;
    class function Description:String; virtual;
  published
    property Enabled:Boolean read FEnabled write FEnabled default True;
    property Region:TFilterRegion read GetRegion write FRegion;
  end;

  TFilterClass=class of TTeeFilter;

  TFilterItems=class(TOwnedCollection)
  private
    Function Get(Index:Integer):TTeeFilter;
    Procedure Put(Index:Integer; Const Value:TTeeFilter);
  public
    function Add(Filter:TFilterClass):TTeeFilter;
    procedure ApplyTo(ABitmap:TBitmap);

    procedure Assign(Source:TPersistent); override;

    property Item[Index:Integer]:TTeeFilter read Get write Put; default;
  end;

  TConvolveFilter=class(TTeeFilter)  // abstract class
  protected
    {$IFDEF CLR}
    {$UNSAFECODE ON}
    {$ENDIF}

    Prev,
    This,
    Next : PRGBs;

    {$IFDEF CLR}
    {$UNSAFECODE OFF}
    {$ENDIF}

    InvTotalWeight : Single;
  public
    Weights : packed Array[-1..1,-1..1] of Single;

    Constructor Create(Collection:TCollection); override;
    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
  end;

  TBlurFilter=class(TConvolveFilter)
  private
    FAmount : Integer;
    FSteps  : Integer;
  public
    Constructor Create(Collection:TCollection); override;

    procedure Apply(Bitmap:TBitmap; const R:TRect); override;
    class function Description: String; override;

    procedure CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent); override;
  published
    property Amount:Integer read FAmount write FAmount default 1;
    property Steps:Integer read FSteps write FSteps default 1;
  end;

  TTeePicture=class(TPicture)
  private
    FFilters : TFilterItems;
    IBitmap  : TBitmap;

    procedure DoReadFilters(Reader: TReader);
    procedure DoWriteFilters(Writer: TWriter);
    function FiltersStored:Boolean;
    function GetFilters:TFilterItems;
    procedure SetFilters(Const Value:TFilterItems);
  protected
    procedure DefineProperties(Filer:TFiler); override;
  public
    Destructor Destroy; override;

    procedure Assign(Source:TPersistent); override;
    function Filtered:TGraphic;
    procedure Repaint;
    class procedure ReadFilters(Reader:TReader; Filters:TFilterItems);
    class procedure WriteFilters(Writer: TWriter; Filters:TFilterItems);
  published
    property Filters:TFilterItems read GetFilters write SetFilters
                                  stored False;
  end;

     TPenEndStyle=(esRound,esSquare,esFlat);

     TChartPen=class(TPen)
     private
       FEndStyle   : TPenEndStyle;
       FSmallDots  : Boolean;
       FSmallSpace : Integer;
       FVisible    : Boolean;

       {$IFDEF CLR}
       [EditorBrowsable(EditorBrowsableState.Never)]
       {$ENDIF}
       Function IsEndStored:Boolean;

       {$IFDEF CLR}
       [EditorBrowsable(EditorBrowsableState.Never)]
       {$ENDIF}
       Function IsVisibleStored:Boolean;

       procedure SetEndStyle(const Value: TPenEndStyle);
       Procedure SetSmallDots(const Value:Boolean);
       Procedure SetSmallSpace(const Value:Integer);
       Procedure SetVisible(const Value:Boolean);

     {$IFDEF CLR}
     public
     {$ELSE}
     protected
     {$ENDIF}

       DefaultEnd : TPenEndStyle;
       DefaultVisible : Boolean;

     public
       Constructor Create(OnChangeEvent:TNotifyEvent);

       Procedure Assign(Source:TPersistent); override;
       procedure Hide;
       procedure Show;
     published
       property EndStyle:TPenEndStyle read FEndStyle write SetEndStyle stored IsEndStored;
       property SmallDots:Boolean read FSmallDots write SetSmallDots default False;
       property SmallSpace:Integer read FSmallSpace write SetSmallSpace default 0;
       property Visible:Boolean read FVisible write SetVisible stored IsVisibleStored;
     end;

     TChartHiddenPen=class(TChartPen)
     public
       Constructor Create(OnChangeEvent:TNotifyEvent);
     published
       property Visible default False;
     end;

     TDottedGrayPen=class(TChartPen)
     public
       Constructor Create(OnChangeEvent:TNotifyEvent);
     published
       property Color default clGray;
       property Style default psDot;
     end;

     TDarkGrayPen=class(TChartPen)
     public
       Constructor Create(OnChangeEvent:TNotifyEvent);
     published
       property Color default clDkGray;
     end;

     TWhitePen=class(TChartPen)
     private
      Function IsVisibleStored:Boolean;
     public
       Constructor Create(OnChangeEvent:TNotifyEvent);
     published
       property Color default clWhite;
       property Visible stored IsVisibleStored;  // 8.0 TV52010620
     end;

     TChartBrush=class(TBrush)
     private
       FBackColor : TColor;
       FImage     : TPicture;  // @TODO: change to TTeePicture

       Function GetImage:TPicture;
       procedure SetBackColor(const Value:TColor);
       procedure SetImage(const Value:TPicture);
     public
       Constructor Create(OnChangeEvent:TNotifyEvent); virtual;
       Destructor Destroy; override;

       Procedure Assign(Source:TPersistent); override;
       Procedure Clear;
     published
       property BackColor:TColor read FBackColor write SetBackColor default clNone;
       property Color default clDefault;
       property Image:TPicture read GetImage write SetImage;
     end;

     TTeeView3DScrolled=procedure(IsHoriz:Boolean) of object;
     TTeeView3DChangedZoom=procedure(NewZoom:Integer) of object;

     TView3DOptions = class(TPersistent)
     private
       FElevation   : Double;
       FFontZoom    : Integer;
       FHorizOffset : Integer;
       FOrthogonal  : Boolean;
       FOrthoAngle  : Integer;
       FPerspective : Integer;
       FRotation    : Double;
       FTilt        : Integer;
       FVertOffset  : Integer;
       FZoom        : Double;
       FZoomText    : Boolean;
       FOnScrolled  : TTeeView3DScrolled;
       FOnChangedZoom:TTeeView3DChangedZoom;

       {$IFDEF TEEVCL}
       FParent      : TWinControl;
       {$ENDIF}

       function GetElevation:Integer;
       function GetRotation:Integer;
       function GetZoom:Integer;
       Procedure SetElevationInteger(const Value:Integer);
       Procedure SetElevation(const Value:Double);
       Procedure SetFontZoom(Value:Integer);
       Procedure SetPerspective(Value:Integer);
       Procedure SetRotationInteger(const Value:Integer);
       procedure SetRotation(const Value:Double); overload;
       Procedure SetTilt(Value:Integer);
       Procedure SetHorizOffset(Value:Integer);
       Procedure SetVertOffset(Value:Integer);
       Procedure SetOrthoAngle(Value:Integer);
       Procedure SetOrthogonal(Value:Boolean);
       Procedure SetZoomInteger(const Value:Integer);
       Procedure SetZoom(const Value:Double);
       Procedure SetZoomText(Value:Boolean);
       Procedure SetBooleanProperty(Var Variable:Boolean; Value:Boolean);
       Procedure SetIntegerProperty(Var Variable:Integer; Value:Integer);
     protected
       function CalcOrthoRatio:Double;
     public
       Constructor Create({$IFDEF TEEVCL}AParent:TWinControl{$ENDIF});
       Procedure Repaint;
       Procedure Assign(Source:TPersistent); override;

       {$IFDEF TEEVCL}
       property Parent:TWinControl read FParent write FParent;
       {$ENDIF}

       property ElevationFloat:Double read FElevation write SetElevation;
       property RotationFloat:Double read FRotation write SetRotation;
       property ZoomFloat:Double read FZoom write SetZoom;

       property OnChangedZoom:TTeeView3DChangedZoom read FOnChangedZoom
                                                    write FOnChangedZoom;
       property OnScrolled:TTeeView3DScrolled read FOnScrolled write FOnScrolled;
     published
       property Elevation:Integer read GetElevation write SetElevationInteger default 345;
       property FontZoom:Integer read FFontZoom write SetFontZoom default 100;
       property HorizOffset:Integer read FHorizOffset write SetHorizOffset default 0;
       property OrthoAngle:Integer read FOrthoAngle write SetOrthoAngle default 45;
       property Orthogonal:Boolean read FOrthogonal write SetOrthogonal default True;
       property Perspective:Integer read FPerspective
                                    write SetPerspective default TeeDefaultPerspective;
       property Rotation:Integer read GetRotation write SetRotationInteger default 345;
       property Tilt:Integer read FTilt write SetTilt default 0;
       property VertOffset:Integer read FVertOffset write SetVertOffset default 0;
       property Zoom:Integer read GetZoom write SetZoomInteger default 100;
       property ZoomText:Boolean read FZoomText write SetZoomText default True;
     end;

     TTeeCanvas=class;

     TTeeTransparency=0..100;

     TTeeBlend=class
     private
       FBitmap : TBitmap;
       FCanvas : TTeeCanvas;
       FRect   : TRect;

       IValidSize : Boolean;
     public
       Constructor Create(ACanvas:TTeeCanvas; Const R:TRect);
       Destructor Destroy; override;

       Procedure DoBlend(Transparency:TTeeTransparency);
       Procedure SetRectangle(Const R:TRect);

       property Bitmap:TBitmap read FBitmap;
     end;

     TPointArray=Array of TPoint;

     TCanvas3D=class;

     TTeeShadow=class(TPersistent)
     private
       FClip         : Boolean;
       FColor        : TColor;
       FHorizSize    : Integer;
       FSmooth       : Boolean;
       FSmoothBlur   : Integer;
       FTransparency : TTeeTransparency;
       FVertSize     : Integer;
       FVisible      : Boolean;

       IOnChange     : TNotifyEvent;
       IBlend        : TTeeBlend;

       procedure Changed;
       procedure DrawSmooth(ACanvas:TCanvas3D; const Rect:TRect;
                            Ellipse,Polygon:Boolean;
                            RoundSize:Integer;
                            const P:TPointArray);
       procedure FinishBlending(ACanvas:TTeeCanvas);
       function GetSize: Integer;
       function IsColorStored: Boolean;
       function IsHorizStored: Boolean;
       function IsVertStored: Boolean;
       function IsVisibleStored: Boolean;
       Function PrepareCanvas(ACanvas:TCanvas3D; const R:TRect;
                              Z:Integer=0):Boolean;
       Procedure SetClip(const Value:Boolean);
       Procedure SetColor(Value:TColor);
       Procedure SetHorizSize(Value:Integer);
       Procedure SetIntegerProperty(Var Variable:Integer; Const Value:Integer);
       procedure SetSize(const Value: Integer);
       procedure SetSmooth(const Value: Boolean);
       procedure SetSmoothBlur(const Value: Integer);
       procedure SetTransparency(Value: TTeeTransparency);
       Procedure SetVertSize(Value:Integer);
       Procedure SetVisible(Value:Boolean);

       function ValidCanvas(ACanvas:TCanvas3D):Boolean;
     {$IFDEF CLR}
     public
     {$ELSE}
     protected
     {$ENDIF}
       DefaultColor   : TColor;
       DefaultSize    : Integer;
       DefaultVisible : Boolean;
       FullDraw       : Boolean;

       procedure InitValues(AColor:TColor; ASize:Integer);
     public
       Constructor Create(AOnChange:TNotifyEvent);

       Procedure Assign(Source:TPersistent); override;

       procedure Draw(ACanvas:TCanvas3D; const P:{$IFDEF D5}Array of TPoint{$ELSE}TPointArray{$ENDIF}); overload;
       procedure Draw(ACanvas:TCanvas3D; Const Rect:TRect); overload;
       procedure Draw(ACanvas:TCanvas3D; Const Rect:TRect; Z:Integer; RoundSize:Integer=0); overload;
       procedure DrawEllipse(ACanvas:TCanvas3D; Const Rect:TRect; Z:Integer=0);
       property Size:Integer read GetSize write SetSize;
     published
       property Clip:Boolean read FClip write SetClip default False;
       property Color:TColor read FColor write SetColor stored IsColorStored;
       property HorizSize:Integer read FHorizSize write SetHorizSize stored IsHorizStored;
       property Smooth:Boolean read FSmooth write SetSmooth default True;
       property SmoothBlur:Integer read FSmoothBlur write SetSmoothBlur default 0;
       property Transparency:TTeeTransparency read FTransparency write SetTransparency default 0;
       property VertSize:Integer read FVertSize write SetVertSize stored IsVertStored;
       property Visible:Boolean read FVisible write SetVisible stored IsVisibleStored;
     end;

     TFourPoints=Array[0..3] of TPoint;

     TGradientDirection = (gdTopBottom, gdBottomTop,
                           gdLeftRight, gdRightLeft,
                           gdFromCenter, gdFromTopLeft,
                           gdFromBottomLeft, gdRadial,
                           gdDiagonalUp, gdDiagonalDown );

     TSubGradient=class; // forward declared

     TCustomTeeGradient=class(TPersistent)
     private
       FAngle      : Integer;
       FBalance    : Integer;
       FDirection  : TGradientDirection;
       FEndColor   : TColor;
       FMidColor   : TColor;
       FRadialX    : Integer;
       FRadialY    : Integer;
       FStartColor : TColor;
       FSub        : TSubGradient;
       FVisible    : Boolean;

       IHasMiddle : Boolean;

       Procedure DrawRadial(Canvas:TTeeCanvas; Rect:TRect);
       procedure DrawRotated(Canvas:TTeeCanvas; const R:TRect);
       procedure DrawSubGradient(Canvas:TTeeCanvas; Const Rect:TRect;
                                 RoundRectSize:Integer=0);
       Function GetMidColor:TColor;
       function GetSub:TSubGradient;
       Procedure SetAngle(Value:Integer);
       Procedure SetBalance(Value:Integer);
       Procedure SetColorProperty(Var Variable:TColor; const Value:TColor);
       Procedure SetDirection(Value:TGradientDirection);
       Procedure SetEndColor(Value:TColor);
       Procedure SetIntegerProperty(Var Variable:Integer; Value:Integer);
       Procedure SetMidColor(Value:TColor);
       procedure SetRadialX(const Value: Integer);
       procedure SetRadialY(const Value: Integer);
       Procedure SetStartColor(Value:TColor);
       procedure SetSub(const Value:TSubGradient);
       Procedure SetVisible(Value:Boolean);
     protected
       IChanged   : TNotifyEvent;
       procedure DoChanged;
     public
       Constructor Create(ChangedEvent:TNotifyEvent); virtual;
       Destructor Destroy; override;

       Procedure Assign(Source:TPersistent); override;

       Procedure Draw(Canvas:TTeeCanvas; Const Rect:TRect; RoundRectSize:Integer=0); overload;
       Procedure Draw(Canvas:TTeeCanvas; var P:TFourPoints); overload;
       Procedure Draw(Canvas:TCanvas3D; var P:TFourPoints; Z:Integer); overload;
       procedure Draw(Canvas:TCanvas3D; var P:TPointArray; Z:Integer; Is3D:Boolean); overload;

       property Changed:TNotifyEvent read IChanged write IChanged;
       Procedure UseMiddleColor;

       { to be published }
       property Angle:Integer read FAngle write SetAngle default 0;
       property Balance:Integer read FBalance write SetBalance default 50;
       property Direction:TGradientDirection read FDirection write SetDirection default gdTopBottom;
       property EndColor:TColor read FEndColor write SetEndColor default clYellow;
       property MidColor:TColor read GetMidColor write SetMidColor default clNone;
       property RadialX:Integer read FRadialX write SetRadialX default 0;
       property RadialY:Integer read FRadialY write SetRadialY default 0;
       property StartColor:TColor read FStartColor write SetStartColor default clWhite;
       property SubGradient:TSubGradient read GetSub write SetSub;
       property Visible:Boolean read FVisible write SetVisible default False;
     end;

     TSubGradient=class(TCustomTeeGradient)
     private
       FTransparency : TTeeTransparency;
       procedure SetTransparency(const Value:TTeeTransparency);
     published
       property Angle;
       property Balance;
       property Direction;
       property EndColor;
       property MidColor;
       property RadialX;
       property RadialY;
       property StartColor;
       property Transparency:TTeeTransparency read FTransparency
                                              write SetTransparency default 50;
       property Visible;
     end;

     TTeeGradient=class(TCustomTeeGradient)
     published
       property Angle;
       property Balance;
       property Direction;
       property EndColor;
       property MidColor;
       property RadialX;
       property RadialY;
       property StartColor;
       property SubGradient;
       property Visible;
     end;

     TTeeFontGradient=class(TTeeGradient)
     private
       FOutline : Boolean;

       Procedure SetBooleanProperty( Var Variable:Boolean;
                                     Const Value:Boolean);
       procedure SetOutline(const Value: Boolean);
     published
       property Outline:Boolean read FOutline write SetOutline default False;
     end;

     TTeeFont=class(TFont)
     private
       FGradient      : TTeeFontGradient;
       FInterCharSize : Integer;
       FOutLine       : TChartHiddenPen;
       FPicture       : TTeePicture;
       FShadow        : TTeeShadow;

       ICanvas        : TTeeCanvas;

       procedure DoChanged(Sender:TObject);
       function GetGradient: TTeeFontGradient;
       function GetOutLine: TChartHiddenPen;
       function GetPicture: TTeePicture;
       Function GetShadow: TTeeShadow;
       Function IsColorStored:Boolean;
       Function IsHeightStored:Boolean;
       Function IsNameStored:Boolean;
       Function IsStyleStored:Boolean;
       procedure SetGradient(const Value: TTeeFontGradient);
       Procedure SetInterCharSize(Value:Integer);
       Procedure SetOutLine(Value:TChartHiddenPen);
       Procedure SetPicture(Value:TTeePicture);
       Procedure SetShadow(Value:TTeeShadow);
     protected
       IDefColor : TColor;
       IDefStyle : TFontStyles;
     public
       Constructor Create(ChangedEvent:TNotifyEvent);
       Destructor Destroy; override;

       Procedure Assign(Source:TPersistent); override;
     published
       {$IFNDEF CLX}
       property Charset default DEFAULT_CHARSET;
       {$ENDIF}
       property Color stored IsColorStored;
       property Gradient:TTeeFontGradient read GetGradient write SetGradient;
       property Height stored IsHeightStored;
       property InterCharSize:Integer read FInterCharSize
                                      write SetInterCharSize default 0;
       property Name stored IsNameStored;
       property OutLine:TChartHiddenPen read GetOutLine write SetOutLine;
       property Picture:TTeePicture read GetPicture write SetPicture;
       {$IFDEF CLX}
       property Pitch default fpVariable;
       {$ENDIF}
       property Shadow:TTeeShadow read GetShadow write SetShadow;
       property Style stored IsStyleStored;
       {$IFDEF CLX}
       property Weight default 40;
       {$ENDIF}
     end;

     TCanvasBackMode  = ( cbmNone,cbmTransparent,cbmOpaque );
     TCanvasTextAlign = Integer;

     TTeeCanvasHandle={$IFDEF CLX}QPainterH{$ELSE}HDC{$ENDIF};

     TTeeCanvas=class {$IFDEF CLR}abstract{$ENDIF}
     private
       FCanvas     : TCanvas;
       FFont       : TFont;
       FPen        : TPen;
       FBrush      : TBrush;

       FMetafiling : Boolean;
       ITransp     : Integer;

       Function GetFontHeight:Integer; {$IFDEF D10}inline;{$ENDIF} // 7.0
       Procedure InternalDark(Const AColor:TColor; Quantity:Byte);

     protected
       FBounds     : TRect;  // 7.0, moved from TeeCanvas3D
       IFont       : TTeeFont;

       Procedure SetCanvas(ACanvas:TCanvas);

       function GetBackColor:TColor; virtual; abstract;
       Function GetBackMode:TCanvasBackMode; virtual; abstract;
       Function GetHandle:TTeeCanvasHandle; virtual; abstract;
       Function GetMonochrome:Boolean; virtual; abstract;
       Function GetPixel(x,y:Integer):TColor; virtual; abstract;
       Function GetSupportsFullRotation:Boolean; virtual; abstract;
       Function GetTextAlign:TCanvasTextAlign; virtual; abstract;
       Function GetUseBuffer:Boolean; virtual; abstract;
       Procedure SetBackColor(Color:TColor); virtual; abstract;
       Procedure SetBackMode(Mode:TCanvasBackMode); virtual; abstract;
       Procedure SetMonochrome(Value:Boolean); virtual; abstract;
       procedure SetPixel(X, Y: Integer; Value: TColor); virtual; abstract;
       procedure SetTextAlign(Align:TCanvasTextAlign); virtual; abstract;
       Procedure SetUseBuffer(Value:Boolean); virtual; abstract;

       {$IFDEF TEEUNICODE}
       function TextExtent(const Text:WideString):TSize;
       {$ENDIF}
     public
       FontZoom : Double; // % of zoom of all font sizes

       Procedure AssignBrush(ABrush:TChartBrush); overload; {$IFDEF D10}inline;{$ENDIF}
       Procedure AssignBrush(ABrush:TChartBrush; ABackColor:TColor); overload; {$IFDEF D10}inline;{$ENDIF}
       Procedure AssignBrush(ABrush:TChartBrush; AColor,ABackColor:TColor); overload;

       Procedure AssignBrushColor(ABrush:TChartBrush;
                                  AColor,ABackColor:TColor); {$IFDEF D11}deprecated 'Please use AssignBrush method.';{$ENDIF} // Do not localize

       procedure AssignVisiblePen(APen:TPen); {$IFDEF D10}inline;{$ENDIF}
       procedure AssignVisiblePenColor(APen:TPen; AColor:TColor); virtual; // 7.0

       procedure AssignFont(AFont:TTeeFont);
       Procedure ResetState;

       Function BeginBlending(const R:TRect; Transparency:TTeeTransparency):TTeeBlend; virtual;
       procedure EndBlending(Blend:TTeeBlend); virtual;

       { 2d }
       procedure Arc(const Left, Top, Right, Bottom, StartX, StartY, EndX, EndY: Integer); overload; virtual; abstract;
       procedure Arc(const Left, Top, Right, Bottom:Integer; StartAngle,EndAngle:Double); overload; virtual;

       Procedure Arrow( Filled:Boolean; const ArrowPercent:Double;
                        const FromPoint,ToPoint:TPoint;
                        ArrowWidth,ArrowHeight:Integer); overload;

       procedure Donut( XCenter,YCenter,XRadius,YRadius:Integer;
                        Const StartAngle,EndAngle,HolePercent:Double); virtual; abstract;
       procedure Draw(X, Y: Integer; Graphic: TGraphic); virtual; abstract;
       procedure Ellipse(const R:TRect); overload; {$IFDEF D9}inline;{$ENDIF}
       procedure Ellipse(X1, Y1, X2, Y2: Integer); overload; virtual; abstract;
       procedure FillRect(const Rect: TRect); virtual; abstract;
       procedure Frame3D( var Rect: TRect; TopColor,BottomColor: TColor;
                          Width: Integer); virtual;
       procedure LineTo(X,Y:Integer); overload; virtual; abstract;
       procedure LineTo(const P:TPoint); overload;
       procedure MoveTo(X,Y:Integer); overload; virtual; abstract;
       procedure MoveTo(const P:TPoint); overload;
       procedure Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); virtual; abstract;
       procedure Rectangle(const R:TRect); overload; {$IFDEF D9}inline;{$ENDIF}
       procedure Rectangle(X0,Y0,X1,Y1:Integer); overload; virtual; abstract;
       procedure RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer); overload; virtual; abstract;
       procedure RoundRect(Const R:TRect; X,Y:Integer); overload;
       procedure StretchDraw(const Rect: TRect; Graphic: TGraphic); overload; virtual; abstract;
       {$IFDEF AXUNICODE}
       Procedure TextOut(X,Y:Integer; const Text:WideString); overload;
       {$ENDIF}
       Procedure TextOut(X,Y:Integer; const Text:String; AllowHtml:Boolean); overload;
       Procedure TextOut(X,Y:Integer; const Text:String); overload; virtual; abstract;
       Function TextWidth(Const St:String):Integer; overload; virtual;
       Function TextHeight(Const St:String):Integer; overload; virtual;

       {$IFDEF TEEUNICODE}
       Function TextWidth(Const St:WideString):Integer; overload; virtual;
       Function TextHeight(Const St:WideString):Integer; overload; virtual;
       {$ENDIF}

       { 2d extra }
       procedure ClipRectangle(Const Rect:TRect); overload; virtual; abstract;
       Procedure ClipRectangle(Const Rect:TRect; RoundSize:Integer); overload; virtual;
       Procedure ClipEllipse(Const Rect:TRect; Inverted:Boolean=False); virtual;
       Procedure ClipPolygon(const Points:Array of TPoint; NumPoints:Integer;
                             DiffRegion:Boolean=False); virtual;

       // Returns modified Points array with sorted points that define
       // biggest convex polygon.
       // Written by Peter Bone : peterbone@hotmail.com
       function ConvexHull(var Points : TPointArray) : Boolean;

       Procedure DoHorizLine(X0,X1,Y:Integer); virtual;

       Procedure DoRectangle(Const Rect:TRect); {$IFDEF D11}deprecated 'Please use Rectangle method.';{$ENDIF} // Do not localize

       Procedure DoVertLine(X,Y0,Y1:Integer); virtual;
       procedure EraseBackground(const Rect: TRect); virtual; abstract;
       Procedure GradientFill( Const Rect:TRect;
                               StartColor,EndColor:TColor;
                               Direction:TGradientDirection;
                               Balance:Integer=50); virtual; abstract;
       Procedure Invalidate; virtual; abstract;
       Procedure Line(X0,Y0,X1,Y1:Integer);  overload; virtual;
       Procedure Line(const FromPoint,ToPoint:TPoint); overload; {$IFDEF D9}inline;{$ENDIF}
       Procedure Polyline(const Points:{$IFDEF D5}Array of TPoint{$ELSE}TPointArray{$ENDIF}); overload; virtual; abstract;
       Procedure Polygon(const Points: Array of TPoint); virtual; abstract;
       Procedure PolygonGradient(const Points: Array of TPoint; Gradient:TCustomTeeGradient); virtual;

       procedure RotateLabel( x,y:Integer; Const St:String;
                              RotDegree:Double); virtual; abstract;  // 7.0
       property SupportsFullRotation:Boolean read GetSupportsFullRotation;
       procedure UnClipRectangle; virtual; abstract;

       // properties
       property BackColor:TColor read GetBackColor write SetBackColor;
       property BackMode:TCanvasBackMode read GetBackMode write SetBackMode;
       property Bounds:TRect read FBounds;
       property Brush:TBrush read FBrush;
       property Font:TFont read FFont;
       property FontHeight:Integer read GetFontHeight;
       property Handle:TTeeCanvasHandle read GetHandle;
       property Metafiling:Boolean read FMetafiling write FMetafiling;
       property Monochrome:Boolean read GetMonochrome write SetMonochrome;
       property Pen:TPen read FPen;
       property Pixels[X, Y: Integer]: TColor read GetPixel write SetPixel;

       property ReferenceCanvas:TCanvas read FCanvas write SetCanvas;

       property TextAlign:TCanvasTextAlign read GetTextAlign write SetTextAlign;
       property UseBuffer:Boolean read GetUseBuffer write SetUseBuffer;
     end;

     // 2D
     TFloatPoint=packed record
     {$IFDEF CLR}
     public
     {$ENDIF}
       X : Double;
       Y : Double;
     end;

     // 3D
     TPoint3DFloat=packed record
     {$IFDEF CLR}
     public
     {$ENDIF}
       X : Double;
       Y : Double;
       Z : Double;
     end;

     TFloatXYZ=class(TPersistent)
     private
       FX       : Double;
       FY       : Double;
       FZ       : Double;

       procedure SetDoubleProperty(var Variable:Double; const Value:Double);
     protected
       FOnChange : TNotifyEvent;

       function Point:TPoint3DFloat;
       Procedure SetX(Const Value:Double);
       Procedure SetY(Const Value:Double);
       Procedure SetZ(Const Value:Double);
     public
       Procedure Assign(Source:TPersistent); override;
       property OnChange:TNotifyEvent read FOnChange write FOnChange;
     published
       property X:Double read FX write SetX;
       property Y:Double read FY write SetY;
       property Z:Double read FZ write SetZ;
     end;

     TPoint3D         =packed record x,y,z:Integer; end;
     TTrianglePoints3D=Array[0..2] of TPoint3D;
     TTriangleColors3D=Array[0..2] of TColor;

     TTeeCanvasCalcPoints=Function( x,z:Integer; Var P0,P1:TPoint3D;
                                    Var Color0,Color1:TColor):Boolean of object;

     TTeeCanvasSurfaceStyle=(tcsSolid,tcsWire,tcsDot);

     TCanvas3DPlane=(cpX,cpY,cpZ);

     {$IFNDEF D6}
     IInterface=IUnknown;
     {$ENDIF}
     
     TCanvas3D=class {$IFDEF CLR}abstract{$ENDIF} (TTeeCanvas,  IInterface)
     private
       F3DOptions        : TView3DOptions;
       IDisabledRotation : Integer;
     protected
       FIsOrthogonal : Boolean;  // 6.01, moved from private due to RotateTool
       FXCenter      : Integer;
       FYCenter      : Integer;
       FZCenter      : Integer;
       GradientZ     : Integer;  // 7.0, used at TGLCanvas

       // 8.01, used at TFlexCanvas, etc:
       SupportsID    : Boolean;

       procedure BeginEntity(const Entity:String); virtual;
       procedure EndEntity; virtual;

       procedure CalcPieAngles(X1,Y1,X2,Y2,X3,Y3,X4,Y4:Integer; var Theta,Theta2:Extended);
       Function GetPixel3D(X,Y,Z:Integer):TColor; virtual; abstract;
       Function GetSupports3DText:Boolean; virtual; abstract;
       procedure SetPixel3D(X,Y,Z:Integer; Value: TColor); virtual; abstract;

       // IInterface
       {$IFNDEF CLR}
       function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
       function _AddRef: Integer; stdcall;
       function _Release: Integer; stdcall;
       {$ENDIF}
     public
       RotationCenter : TPoint3DFloat;

       { 3d }
       Function CalcRect3D(Const R:TRect; Z:Integer):TRect;
       Procedure Calculate2DPosition(Var x,y:Integer; z:Integer); overload; virtual; abstract;
       Function Calculate3DPosition(const P:TPoint3D):TPoint; overload; {$IFDEF 10}inline;{$ENDIF} // 7.0
       Function Calculate3DPosition(P:TPoint; z:Integer):TPoint; overload; {$IFDEF 10}inline;{$ENDIF}
       Function Calculate3DPosition(x,y,z:Integer):TPoint; overload; virtual; abstract;
       function Calc3DPoints(const Points:Array of TPoint; z:Integer):TPointArray;

       // Changed from "function" to "procedure" in v7.07 (BCB compatibility)
       procedure FourPointsFromRect(Const R:TRect; Z:Integer; var P:TFourPoints);

       Function RectFromRectZ(Const R:TRect; Z:Integer):TRect;

       Function InitWindow( DestCanvas:TCanvas; A3DOptions:TView3DOptions;
                            ABackColor:TColor;
                            Is3D:Boolean;
                            Const UserRect:TRect):TRect; virtual; abstract;

       Procedure Assign(Source:TCanvas3D); virtual;

       Procedure Projection(MaxDepth:Integer; const ABounds,Rect:TRect); virtual; abstract;
       Procedure ShowImage( DestCanvas,DefaultCanvas:TCanvas;
                            Const UserRect:TRect); virtual; abstract;
       Function ReDrawBitmap:Boolean; virtual; abstract;

       Procedure Arrow( Filled:Boolean; Const FromPoint,ToPoint:TPoint;
                        ArrowWidth,ArrowHeight,Z:Integer); overload;
       Procedure Arrow( Filled:Boolean; Const FromPoint,ToPoint:TPoint;
                        ArrowWidth,ArrowHeight,Z:Integer;
                        const ArrowPercent:Double); overload; virtual; abstract;

       procedure ClipCube(Const Rect:TRect; MinZ,MaxZ:Integer); virtual; abstract;
       procedure Cone( Vertical:Boolean; Left,Top,Right,Bottom,Z0,Z1:Integer;
                       Dark3D:Boolean; ConePercent:Integer); virtual; abstract;
       Procedure Cube( Left,Right,Top,Bottom,Z0,Z1:Integer;
                       DarkSides:Boolean=True); overload; virtual; abstract;
       Procedure Cube( const R:TRect; Z0,Z1:Integer;
                       DarkSides:Boolean=True); overload;

       procedure Cylinder( Vertical:Boolean; Left,Top,Right,Bottom,Z0,Z1:Integer;
                           Dark3D:Boolean=True); virtual; abstract;
       procedure DisableRotation; virtual;
       procedure EllipseWithZ(const Rect:TRect; Z: Integer); overload;
       procedure EllipseWithZ(X1, Y1, X2, Y2, Z: Integer); overload; virtual; abstract;
       procedure EnableRotation; virtual;
       Procedure HorizLine3D(Left,Right,Y,Z:Integer); virtual;
       Procedure VertLine3D(X,Top,Bottom,Z:Integer); virtual;
       Procedure ZLine3D(X,Y,Z0,Z1:Integer); virtual;
       procedure FrontPlaneBegin; virtual;
       procedure FrontPlaneEnd; virtual;
       Procedure LineWithZ(X0,Y0,X1,Y1,Z:Integer);  overload; virtual;
       Procedure LineWithZ(const FromPoint,ToPoint:TPoint; Z:Integer); overload;
       procedure MoveTo3D(X,Y,Z:Integer); overload; virtual;
       procedure MoveTo3D(const P:TPoint3D); overload;
       procedure LineTo3D(X,Y,Z:Integer); overload; virtual;
       procedure LineTo3D(const P:TPoint3D); overload;
       procedure Pie3D( XCenter,YCenter,XRadius,YRadius,Z0,Z1:Integer;
                        Const StartAngle,EndAngle:Double;
                        DarkSides,DrawSides:Boolean;
                        DonutPercent:Integer=0;
                        Gradient:TCustomTeeGradient=nil); virtual; abstract;
       procedure Plane3D(Const A,B:TPoint; Z0,Z1:Integer); virtual; abstract;
       procedure PlaneWithZ(const P:TFourPoints; Z:Integer); overload;
       procedure PlaneWithZ(P1,P2,P3,P4:TPoint; Z:Integer); overload; virtual; abstract;
       procedure PlaneFour3D(Var Points:TFourPoints; Z0,Z1:Integer); virtual; abstract;
       Procedure Polygon3D(const Points: Array of TPoint3D); virtual; abstract;
       procedure PolygonWithZ(const Points: Array of TPoint; Z:Integer); virtual;
       procedure Polyline(const Points:{$IFDEF D5}Array of TPoint{$ELSE}TPointArray{$ENDIF}; Z:Integer); overload; virtual;
       procedure Pyramid( Vertical:Boolean; Left,Top,Right,Bottom,z0,z1:Integer;
                          DarkSides:Boolean=True); virtual; abstract;
       Procedure PyramidTrunc(Const R:TRect; StartZ,EndZ:Integer;
                              TruncX,TruncZ:Integer); virtual; abstract;
       Procedure Rectangle(Const R:TRect; Z:Integer); overload;
       Procedure Rectangle(X0,Y0,X1,Y1,Z:Integer); {$IFDEF 10}inline;{$ENDIF} overload;
       Procedure RectangleWithZ(Const Rect:TRect; Z:Integer); virtual; abstract;
       Procedure RectangleY(Left,Top,Right,Z0,Z1:Integer); virtual; abstract;
       Procedure RectangleZ(Left,Top,Bottom,Z0,Z1:Integer); virtual; abstract;
       procedure RotatedEllipse(Left,Top,Right,Bottom,Z:Integer; Const Angle:Double);
       procedure RotateLabel3D( x,y,z:Integer; Const St:String;
                                RotDegree:Double); virtual; abstract;  // 7.0
       procedure Sphere(x,y,z:Integer; Const Radius:Double); overload; virtual; abstract;
       procedure StretchDraw(const Rect: TRect; Graphic: TGraphic; Pos:Integer;
                             Plane:TCanvas3DPlane=cpZ); overload;
       Procedure Surface3D( Style:TTeeCanvasSurfaceStyle;
                            SameBrush:Boolean; NumXValues,NumZValues:Integer;
                            CalcPoints:TTeeCanvasCalcPoints ); virtual; abstract;
       Procedure TextOut3D(x,y,z:Integer; const Text:String); virtual; abstract;
       procedure Triangle3D( Const Points:TTrianglePoints3D;
                             Const Colors:TTriangleColors3D); virtual; abstract;
       procedure TriangleWithZ(Const P1,P2,P3:TPoint; Z:Integer); virtual; abstract;

       property Pixels3D[X,Y,Z:Integer]:TColor read GetPixel3D write SetPixel3D;
       property Supports3DText:Boolean read GetSupports3DText;
       property View3DOptions:TView3DOptions read F3DOptions write F3DOptions;
       property XCenter:Integer read FXCenter write FXCenter;
       property YCenter:Integer read FYCenter write FYCenter;
       property ZCenter:Integer read FZCenter write FZCenter;
     end;

     TTrianglePoints  =Array[0..2] of TPoint;
     TCirclePoints    =Array[0..NumCirclePoints-1] of TPoint;

     TTeeCanvas3D=class(TCanvas3D)
     private
       s1              : Extended;
       s2              : Extended;
       s3              : Extended;
       c1              : Extended;
       c2              : Extended;
       c3              : Extended;

       c2s3            : Double;
       c2c3            : Double;
       tempXX          : Double;
       tempYX          : Double;
       tempXZ          : Double;
       tempYZ          : Double;

       FWas3D          : Boolean;

       FBitmap         : TBitmap;
       {$IFDEF TEEBITMAPSPEED}
       IBitmapCanvas   : TTeeCanvasHandle;
       {$ENDIF}

       FDirty          : Boolean;
       FMonochrome     : Boolean;
       FTextAlign      : TCanvasTextAlign;

       IHasPerspec     : Boolean;
       IHasTilt        : Boolean;
       IOrthoX         : Double;
       IOrthoY         : Double;
       IZoomPerspec    : Double;
       IZoomFactor     : Double;
       IZoomText       : Boolean;

       procedure InternalCylinder(Vertical:Boolean; Left,Top,Right,Bottom,
                            Z0,Z1:Integer; Dark3D:Boolean; ConePercent:Integer);
     protected
       FBufferedDisplay : Boolean;
       FIs3D            : Boolean;

       IKeepBitmap      : Boolean;
       IPoints          : TFourPoints;

       CharacterAngle   : Double;  // 8.0
       XCenterOffset    : Integer;
       YCenterOffset    : Integer;

       { 2d }
       function GetBackColor:TColor; override;
       Function GetBackMode:TCanvasBackMode; override;
       Function GetHandle:TTeeCanvasHandle; override;
       Function GetMonochrome:Boolean; override;
       Function GetPixel(X, Y: Integer):TColor; override;
       Function GetPixel3D(X,Y,Z:Integer):TColor; override;
       Function GetSupports3DText:Boolean; override;
       Function GetSupportsFullRotation:Boolean; override;
       Function GetTextAlign:TCanvasTextAlign; override;
       Function GetUseBuffer:Boolean; override;

       Procedure PolygonFour; virtual;

       Procedure SetBackColor(Color:TColor); override;
       Procedure SetBackMode(Mode:TCanvasBackMode); override;
       Procedure SetMonochrome(Value:Boolean); override;
       procedure SetPixel(X, Y: Integer; Value: TColor); override;
       procedure SetTextAlign(Align:TCanvasTextAlign); override;
       Procedure SetUseBuffer(Value:Boolean); override;

       Procedure DeleteBitmap; virtual;
       Procedure TransferBitmap(ALeft,ATop:Integer; ACanvas:TCanvas); virtual;

       { 3d private }
       Procedure Calc3DTPoint(Var P:TPoint; z:Integer); {$IFDEF D9}inline;{$ENDIF}
       Function Calc3DTPoint3D(Const P:TPoint3D):TPoint; {$IFDEF D9}inline;{$ENDIF}
       Procedure Calc3DPoint(Var P:TPoint; x,y,z:Integer); overload; {$IFDEF D10}inline;{$ENDIF}
       Procedure Calc3DPoint(Var P:TPoint; x,y:Double; z:Integer); overload;

       { 3d }
       procedure SetPixel3D(X,Y,Z:Integer; Value: TColor); override;
       Procedure Calc3DPos(var x,y:Integer; z:Integer); overload;

       Procedure CalcPerspective(const Rect:TRect);

       {$IFNDEF CLR}
       Procedure CalcTrigValues;
       {$ENDIF}

     public
       { public }
       Constructor Create;
       Destructor Destroy; override;

       {$IFDEF CLR}
       Procedure CalcTrigValues;
       {$ENDIF}

       Function InitWindow( DestCanvas:TCanvas;
                            A3DOptions:TView3DOptions;
                            ABackColor:TColor;
                            Is3D:Boolean;
                            Const UserRect:TRect):TRect; override;

       Function ReDrawBitmap:Boolean; override;
       Procedure ShowImage(DestCanvas,DefaultCanvas:TCanvas; Const UserRect:TRect); override;

       procedure Arc(const Left, Top, Right, Bottom, StartX, StartY, EndX, EndY: Integer); override;
       procedure Donut( XCenter,YCenter,XRadius,YRadius:Integer;
                        Const StartAngle,EndAngle,HolePercent:Double); override;
       procedure Draw(X, Y: Integer; Graphic: TGraphic); override;
       procedure Ellipse(X1, Y1, X2, Y2: Integer); override;
       procedure EraseBackground(const Rect: TRect); override;
       procedure FillRect(const Rect: TRect); override;
       procedure LineTo(X,Y:Integer); override;
       procedure MoveTo(X,Y:Integer); override;
       procedure Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); override;
       procedure Rectangle(X0,Y0,X1,Y1:Integer); override;
       procedure RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer); override;
       procedure StretchDraw(const Rect: TRect; Graphic: TGraphic); override;
       Procedure TextOut(X,Y:Integer; const Text:String); override;

       { 2d extra }
       procedure ClipRectangle(Const Rect:TRect); override;
       procedure ClipCube(Const Rect:TRect; MinZ,MaxZ:Integer); override;

       procedure DisableRotation; override;
       procedure EnableRotation; override;
       Procedure GradientFill( Const Rect:TRect;
                               StartColor,EndColor:TColor;
                               Direction:TGradientDirection;
                               Balance:Integer=50); override;
       Procedure Invalidate; override;
       Procedure Polyline(const Points:{$IFDEF D5}Array of TPoint{$ELSE}TPointArray{$ENDIF}); overload; override;
       Procedure Polygon(const Points: Array of TPoint); override;
       procedure RotateLabel(x,y:Integer; const St:String; RotDegree:Double); override;
       procedure RotateLabel3D( x,y,z:Integer;
                                const St:String; RotDegree:Double); override;
       procedure UnClipRectangle; override;

       { 3d }
       Procedure Calculate2DPosition(Var x,y:Integer; z:Integer); overload; override;
       Function Calculate3DPosition(x,y,z:Integer):TPoint; override;
       Procedure Projection(MaxDepth:Integer; const ABounds,Rect:TRect); override;

       Procedure Arrow( Filled:Boolean; Const FromPoint,ToPoint:TPoint;
                        ArrowWidth,ArrowHeight,Z:Integer;
                        const ArrowPercent:Double); override;

       procedure Cone( Vertical:Boolean; Left,Top,Right,Bottom,Z0,Z1:Integer;
                       Dark3D:Boolean; ConePercent:Integer); override;
       Procedure Cube(Left,Right,Top,Bottom,Z0,Z1:Integer; DarkSides:Boolean=True); override;
       procedure Cylinder( Vertical:Boolean; Left,Top,Right,Bottom,Z0,Z1:Integer;
                           Dark3D:Boolean=True); override;
       procedure EllipseWithZ(X1, Y1, X2, Y2, Z: Integer); override;
       procedure GetCirclePoints(var P:{$IFDEF D5}TCirclePoints{$ELSE}TPointArray{$ENDIF}; X1, Y1, X2, Y2, Z: Integer);
       Procedure RectangleZ(Left,Top,Bottom,Z0,Z1:Integer); override;
       Procedure RectangleY(Left,Top,Right,Z0,Z1:Integer); override;
       procedure Pie3D( AXCenter,AYCenter,XRadius,YRadius,Z0,Z1:Integer;
                        Const StartAngle,EndAngle:Double;
                        DarkSides,DrawSides:Boolean; DonutPercent:Integer=0;
                        Gradient:TCustomTeeGradient=nil); override;
       procedure Plane3D(Const A,B:TPoint; Z0,Z1:Integer); override;
       procedure PlaneWithZ(P1,P2,P3,P4:TPoint; Z:Integer); override;
       procedure PlaneFour3D(Var Points:TFourPoints; Z0,Z1:Integer); override;
       Procedure Polygon3D(const Points: Array of TPoint3D); override;
       procedure Pyramid( Vertical:Boolean; Left,Top,Right,Bottom,z0,z1:Integer;
                          DarkSides:Boolean=True); override;
       Procedure PyramidTrunc(Const R:TRect; StartZ,EndZ:Integer;
                              TruncX,TruncZ:Integer); override;
       Procedure RectangleWithZ(Const Rect:TRect; Z:Integer); override;
       procedure Sphere(x,y,z:Integer; Const Radius:Double); overload; override;
       Procedure Surface3D( Style:TTeeCanvasSurfaceStyle;
                            SameBrush:Boolean;
                            NumXValues,NumZValues:Integer;
                            CalcPoints:TTeeCanvasCalcPoints ); override;
       Procedure TextOut3D(X,Y,Z:Integer; const Text:String); override;
       procedure Triangle3D( Const Points:TTrianglePoints3D;
                             Const Colors:TTriangleColors3D); override;
       procedure TriangleWithZ(Const P1,P2,P3:TPoint; Z:Integer); override;

       property Bitmap:TBitmap read FBitmap write FBitmap; // 7.02 rw
     end;

Function ApplyDark(Color:TColor; HowMuch:Byte):TColor;
Function ApplyBright(Color:TColor; HowMuch:Byte):TColor;

Function Point3D(const x,y,z:Integer):TPoint3D; {$IFDEF D9}inline;{$ENDIF}

Procedure SwapDouble(Var a,b:Double); {$IFDEF D10}inline;{$ENDIF}   { exchanges a and b }
Procedure SwapInteger(Var a,b:Integer); {$IFDEF D10}inline;{$ENDIF} { exchanges a and b }

Procedure RectSize(Const R:TRect; Var RectWidth,RectHeight:Integer); {$IFDEF D9}inline;{$ENDIF}
Procedure RectCenter(Const R:TRect; Var X,Y:Integer); {$IFDEF D9}inline;{$ENDIF}
Function RectFromPolygon(Const Points:Array of TPoint; NumPoints:Integer):TRect;
Function RectFromTriangle(Const Points:TTrianglePoints):TRect; {$IFDEF D9}inline;{$ENDIF}

{ Returns True if rectangle Small is inside the rectangle Big }
function RectangleInRectangle(const Small,Big:TRect):Boolean;

Procedure ClipCanvas(ACanvas:TCanvas; Const Rect:TRect);
Procedure UnClipCanvas(ACanvas:TCanvas);

// These Clipxxx routines are now deprecated...
// Use TTeeCanvas.Clipxxx equivalent methods.

Procedure ClipEllipse(ACanvas:TTeeCanvas; Const Rect:TRect); {$IFDEF D10}inline;{$ENDIF}
                         {$IFDEF D11}deprecated 'Please use ACanvas.ClipEllipse method.';{$ENDIF} // Do not localize

Procedure ClipRoundRectangle(ACanvas:TTeeCanvas; Const Rect:TRect; RoundSize:Integer); {$IFDEF D10}inline;{$ENDIF}
                         {$IFDEF D11}deprecated 'Please use ACanvas.ClipRectangle method.';{$ENDIF} // Do not localize

Procedure ClipPolygon(ACanvas:TTeeCanvas; const Points:Array of TPoint; NumPoints:Integer);
                         {$IFDEF D11}deprecated 'Please use ACanvas.ClipPolygon method.';{$ENDIF} // Do not localize

Const
  // This is used to calculate average Text Height
  TeeCharForHeight     = 'W';  // Do not localize

  DarkerColorQuantity  : Byte=128; { <-- for dark 3D sides }
  DarkColorQuantity    : Byte=64;

{$IFDEF TEEVCL}
type
  TButtonGetColorProc=function:TColor of object;

  TTeeButton = class(TButton)
  private
    {$IFNDEF CLX}
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    {$ENDIF}
  protected
    Instance : TObject;
    Info     : {$IFDEF CLR}TPropInfo{$ELSE}PPropInfo{$ENDIF};

    Procedure DrawSymbol(ACanvas:TTeeCanvas); virtual; // abstract;

    {$IFNDEF CLX}
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    {$IFDEF TEEWINDOWS}
    procedure PaintWindow(DC: HDC); override;
    {$ENDIF}

    {$IFNDEF LCL}
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    {$ENDIF}

    {$ELSE}
    procedure Painting(Sender: QObjectH; EventRegion: QRegionH); override;
    {$ENDIF}

    function SymbolRectangle:TRect;
  public
    Procedure LinkProperty(AInstance:TObject; Const PropName:String);
  published
    { Published declarations }
    property Height default 25;
    property Width default 75;
  end;

  TButtonColor = class(TTeeButton)
  private
    FSymbolColor : TColor;
    Function GetSymbolColor : TColor;
    procedure SetSymbolColor(Const Value:TColor); // 7.0
  protected
    procedure DrawSymbol(ACanvas:TTeeCanvas); override;
  public
    GetColorProc : TButtonGetColorProc;
    procedure Click; override;
    property SymbolColor:TColor read GetSymbolColor write SetSymbolColor;
  end;

  TComboFlat=class(TComboBox)
  private
    {$IFNDEF CLX}
    Inside: Boolean;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

    {$IFNDEF LCL}
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    {$ENDIF}

    {$IFNDEF CLR}
    {$IFNDEF LCL}
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}

    function GetDropWidth:Integer;
    function IsDropWidthStored:Boolean;
    procedure SetDropWidth(const Value:Integer);
  public
    Constructor Create(AOwner:TComponent); override;

    procedure Add(const Item:String);

    {$IFDEF CLX}
    procedure AddItem(Item: String; AObject: TObject);
    {$ELSE}
    {$IFNDEF D6}
    procedure AddItem(Item: String; AObject: TObject);
    {$ENDIF}
    {$ENDIF}

    function CurrentItem:String;
    function SelectedObject:TObject;
  published
    property DropDownWidth:Integer read GetDropWidth write SetDropWidth  // 7.05
                                   stored IsDropWidthStored;
    property Height default 21;
    property ItemHeight default 13;
    property ItemIndex;
    property Style default csDropDownList;
  end;
{$ENDIF}

{$IFNDEF D5}
procedure FreeAndNil(var Obj);
{$ENDIF}

{$IFNDEF TEEVCL}
procedure FreeAndNil(var Obj);
function StrToInt(const S: string): Integer;
function ColorToRGB(Color: TColor): Longint;
{$ENDIF}

var IsWindowsNT:Boolean=False;
    GetDefaultFontSize:Integer=0;
    GetDefaultFontName:String='';

{$IFDEF LINUX}
Function GetRValue(Color:Integer):Byte;
Function GetGValue(Color:Integer):Byte;
Function GetBValue(Color:Integer):Byte;
Function RGB(r,g,b:Integer):TColor;
{$ENDIF}

Function TeeCreatePenSmallDots(const AColor:TColor;
                    const Space:Integer=0):{$IFDEF CLX}QPenH{$ELSE}HPen{$ENDIF};

Procedure TeeSetTeePen(FPen:TPen; APen:TChartPen; AColor:TColor; Handle:TTeeCanvasHandle);

Function TeePoint(const aX,aY:Integer):TPoint; {$IFDEF D9}inline;{$ENDIF} { compatibility with D6 CLX }
function PointInRect(Const Rect:TRect; const P:TPoint):Boolean; overload; {$IFDEF D9}inline;{$ENDIF}
function PointInRect(Const Rect:TRect; x,y:Integer):Boolean; overload; {$IFDEF D9}inline;{$ENDIF}{ compatibility with D6 CLX }
function TeeRect(Left,Top,Right,Bottom:Integer):TRect; {$IFDEF D9}inline;{$ENDIF} { compatibility with D6 CLX }
Function OrientRectangle(Const R:TRect):TRect;

procedure TeeSetBitmapSize(Bitmap:TBitmap; Width,Height:Integer);

// Returns bounding rectangle containing all points in polygon P
Function PolygonBounds(Const P:Array of TPoint):TRect;  // 7.0

// Returns True when all points in polygon A are inside polygon B
function PolygonInPolygon(const A,B:Array of TPoint):Boolean;  // 8.0

// Default color depth
const
  TeePixelFormat={$IFDEF CLX}pf32Bit{$ELSE}pf24Bit{$ENDIF};

Function RGBValue(const Color:TColor):TRGB;

{$IFDEF TEEVCL}
{ Show the TColorDialog, return new color if changed }
Function EditColor(AOwner:TComponent; AColor:TColor):TColor;

{ Show the TColorDialog, return True if color changed }
Function EditColorDialog(AOwner:TComponent; var AColor:TColor):Boolean;
{$ENDIF}

// Returns point "ATo" minus ADist pixels from AFrom point.
Function PointAtDistance(AFrom,ATo:TPoint; ADist:Integer):TPoint;

// Returns True when 3 first points in P are "face-viewing".
Function TeeCull(const P:TFourPoints):Boolean; overload;
Function TeeCull(const P0,P1,P2:TPoint):Boolean; overload;

// Draws SRC bitmap with smooth stretch to Dst bitmap
type
  TSmoothStretchOption = (ssBestQuality, ssBestPerformance);

procedure SmoothStretch(Src, Dst: TBitmap); overload;
procedure SmoothStretch(Src, Dst: TBitmap; Option: TSmoothStretchOption); overload;

// Returns Sqrt( Sqr(x)+Sqr(y) )
Function TeeDistance(const x,y:Double):Double;  // 7.0 changed to "double"

{ Used at EditColor function, for the Color Editor dialog }
var TeeCustomEditColors:TStrings=nil;

    {$IFNDEF LINUX}
    TeeFontAntiAlias:Byte=ANTIALIASED_QUALITY;
    {$ENDIF}

    {$IFNDEF CLX}
    TeeSetDCBrushColor:function(DC: HDC; Color: COLORREF): COLORREF; stdcall;
    TeeSetDCPenColor:function(DC: HDC; Color: COLORREF): COLORREF; stdcall;
    {$ENDIF}

// Load a DLL, compatible with Delphi 4 and up.
{$IFNDEF LINUX}
Function TeeLoadLibrary(Const FileName:String):HInst;

// Free Library, but do not free library in Windows 95 (lock bug)
Procedure TeeFreeLibrary(hLibModule: HMODULE);
{$ENDIF}

var
  TeeNumCylinderSides:Integer=16;

procedure TeeBlendBitmaps(Const Percent: Double; ABitmap,BBitmap:TBitmap; BOrigin:TPoint);

type
  TGradientRotate=procedure(Gradient:TCustomTeeGradient; Bitmap:TBitmap);

var
  TeeGradientRotate:TGradientRotate=nil;

// Returns "Lines" array with pointers to all Bitmap row scanlines.
procedure TeeCalcLines(var Lines:TRGBArray; Bitmap:TBitmap);

// Smoothes Bitmap contents, blends with (optional) Back bitmap.
procedure TeeShadowSmooth(Bitmap,Back:TBitmap;
          Left, Top, Width, Height, horz, vert:Integer;
          Smoothness:Double; FullDraw:Boolean;
          ACanvas:TCanvas3D;
          Clip:Boolean);

type
  ICanvasHyperlinks=interface
    ['{84DBB276-CBD2-4BBB-AC31-AACBF8B6F34C}']
    procedure AddLink(x,y:Integer; const Text,URL,Hint:String);
  end;

  ICanvasToolTips=interface
    ['{03EBCB55-D01F-4CA8-8A2F-48EB3BEBC5E3}']
    procedure AddToolTip(const Entity,ToolTip:String);
  end;

{$IFNDEF D6}
function Supports(const Instance: IInterface; const IID: TGUID): Boolean;
{$ENDIF}

implementation

Uses {$IFDEF CLR}
     System.Runtime.InteropServices,
     System.Drawing,
     System.Drawing.Drawing2D,
     System.Reflection,
     {$ENDIF}

     {$IFDEF TEEVCL}
     {$IFDEF CLX}
     QForms, QDialogs,
     {$ELSE}
     Forms, Dialogs,
     {$ENDIF}
     {$ENDIF}

     Math, TeeHtml, TeeConst;

type PPoints = ^TPoints;
     TPoints = Array[0..0] of TPoint;

{$IFNDEF CLX}
var WasOldRegion : Boolean=False;
    OldRegion    : HRgn=0;
{$ENDIF}

{$IFNDEF TEEWINDOWS}
procedure InflateRect(var R:TRect; x,y:Integer); {$IFDEF D9}inline;{$ENDIF}
begin
  Inc(R.Left,-x);
  Inc(R.Right,x);
  Inc(R.Top,-y);
  Inc(R.Bottom,y);
end;
{$ENDIF}

Function TeeCull(const P0,P1,P2:TPoint):Boolean;
begin
  result:=( ((P0.x-P1.x) * (P2.y-P1.y)) -
            ((P2.x-P1.x) * (P0.y-P1.y))
          ) < 0;
end;

Function TeeCull(const P:TFourPoints):Boolean; {$IFDEF D9}inline;{$ENDIF}
begin
  result:=TeeCull(P[0],P[1],P[2]);
end;

Function TeePoint(const aX,aY:Integer):TPoint; {$IFDEF D9}inline;{$ENDIF}
begin
  with result do
  begin
    X:=aX;
    Y:=aY;
  end;
end;

function PointInRect(Const Rect:TRect; x,y:Integer):Boolean; {$IFDEF D9}inline;{$ENDIF}
begin
  result:=(x>=Rect.Left) and (y>=Rect.Top) and
          (x<=Rect.Right) and (y<=Rect.Bottom);  // 7.0
end;

function PointInRect(Const Rect:TRect; const P:TPoint):Boolean; overload; {$IFDEF D9}inline;{$ENDIF}
begin
  result:=PointInRect(Rect,P.X,P.Y);
end;

function TeeRect(Left,Top,Right,Bottom:Integer):TRect; {$IFDEF D9}inline;{$ENDIF}
begin
  result.Left  :=Left;
  result.Top   :=Top;
  result.Bottom:=Bottom;
  result.Right :=Right;
end;

// Makes sure the R rectangle Left is smaller than Right and
// Top is smaller than Bottom. Returns corrected rectangle.
Function OrientRectangle(Const R:TRect):TRect;
{$IFDEF CLR}
var tmp : Integer;
{$ENDIF}
begin
  result:=R;

  with result do
  begin
    if Left>Right then
    {$IFDEF CLR}
    begin
      tmp:=Left; Left:=Right; Right:=tmp;
    end;
    {$ELSE}
    SwapInteger(Left,Right);
    {$ENDIF}

    if Top>Bottom then
    {$IFDEF CLR}
    begin
      tmp:=Top; Top:=Bottom; Bottom:=tmp;
    end;
    {$ELSE}
    SwapInteger(Top,Bottom);
    {$ENDIF}
  end;
end;

Function Point3D(const x,y,z:Integer):TPoint3D; {$IFDEF D9}inline;{$ENDIF}
begin
  result.x:=x;
  result.y:=y;
  result.z:=z;
end;

Procedure RectSize(Const R:TRect; Var RectWidth,RectHeight:Integer); {$IFDEF D9}inline;{$ENDIF}
begin
  With R do
  begin
    RectWidth :=Right-Left;
    RectHeight:=Bottom-Top;
  end;
end;

Procedure RectCenter(Const R:TRect; Var X,Y:Integer); {$IFDEF D9}inline;{$ENDIF}
begin
  With R do
  begin
    X:=(Left+Right) div 2;
    Y:=(Top+Bottom) div 2;
  end;
end;

procedure TeeSetBitmapSize(Bitmap:TBitmap; Width,Height:Integer);
begin
  {$IFDEF D10}
  Bitmap.SetSize(Width,Height); // Faster
  {$ELSE}
  Bitmap.Width:=Width;
  Bitmap.Height:=Height;
  {$ENDIF}
end;

// Returns the minimum left / top and the
// maximum right / bottom for all the points in "P" polygon
Function PolygonBounds(Const P:Array of TPoint):TRect;
var l,t : Integer;
begin
  l:=Length(P);

  if l>0 then
  {$IFDEF CLR}
  begin
    result.Left:=P[0].X;
    result.Top:=P[0].Y;
    result.Right:=result.Left;
    result.Bottom:=result.Top;

    for t:=1 to l-1 do
    with P[t] do
    begin
      if X<result.Left then result.Left:=X
      else
      if X>result.Right then result.Right:=X;

      if Y<result.Top then result.Top:=Y
      else
      if Y>result.Bottom then result.Bottom:=Y;
    end;
  end
  {$ELSE}
  with result do
  begin
    TopLeft:=P[0];
    BottomRight:=TopLeft;

    for t:=1 to l-1 do
    with P[t] do
    begin
      if X<Left then Left:=X
      else
      if X>Right then Right:=X;

      if Y<Top then Top:=Y
      else
      if Y>Bottom then Bottom:=Y;
    end;
  end
  {$ENDIF}
  else
    result:=TeeZeroRect;
end;

function PolygonInPolygon(const A,B:Array of TPoint):Boolean;

  Function InternalPointInPolygon(Const P:TPoint):Boolean;
  var i,j : Integer;
  begin
    result:=False;
    j:=High(B);
    for i:=0 to High(B) do
    begin
      if (((( B[i].Y <= P.Y ) and ( P.Y < B[j].Y ) ) or
           (( B[j].Y <= P.Y ) and ( P.Y < B[i].Y ) )) and
            ( P.X <= (1.0* (( B[j].X - B[i].X ) * ( P.Y - B[i].Y )))
            / (1.0*( B[j].Y - B[i].Y )) + B[i].X )) then
               result:=not result;
      j:=i;
    end;
  end;

var t : Integer;
begin
  for t:=0 to Length(A)-1 do
      if not InternalPointInPolygon(A[t]) then
      begin
        result:=False;
        exit;
      end;

  result:=True;
end;

{ TChartPen }
Constructor TChartPen.Create(OnChangeEvent:TNotifyEvent);
begin
  inherited Create;
  FVisible:=True;
  DefaultVisible:=True;

  DefaultEnd:=esRound;
  OnChange:=OnChangeEvent;

  {$IFDEF CLX}
  ReleaseHandle;
  Width:=1;
  {$ENDIF}
end;

Procedure TChartPen.Assign(Source:TPersistent);
begin
  if Source is TChartPen then
  begin
    FVisible  :=TChartPen(Source).Visible;
    FSmallDots:=TChartPen(Source).SmallDots;
    FSmallSpace:=TChartPen(Source).SmallSpace;
    FEndStyle :=TChartPen(Source).EndStyle;  { 5.01 }
  end;

  {$IFDEF CLX}
  if not Assigned(Handle) then ReleaseHandle;
  {$ENDIF}

  inherited;
end;

procedure TChartPen.Hide;
begin
  Visible:=False;
end;

procedure TChartPen.Show;
begin
  Visible:=True;
end;

Function TChartPen.IsEndStored:Boolean;
begin
  result:=FEndStyle<>DefaultEnd;
end;

Function TChartPen.IsVisibleStored:Boolean;
begin
  result:=FVisible<>DefaultVisible;
end;

procedure TChartPen.SetEndStyle(const Value: TPenEndStyle);
begin
  if FEndStyle<>Value then
  begin
    FEndStyle:=Value;
    Changed;
  end;
end;

Procedure TChartPen.SetSmallDots(const Value:Boolean);
begin
  if FSmallDots<>Value then
  begin
    FSmallDots:=Value;
    Changed;
  end;
end;

Procedure TChartPen.SetSmallSpace(const Value:Integer);
begin
  if FSmallSpace<>Value then
  begin
    FSmallSpace:=Value;
    Changed;
  end;
end;

Procedure TChartPen.SetVisible(const Value:Boolean);
Begin
  if FVisible<>Value then
  begin
    FVisible:=Value;
    Changed;
  end;
end;

{ TChartHiddenPen }
Constructor TChartHiddenPen.Create(OnChangeEvent:TNotifyEvent);
Begin
  inherited;
  FVisible:=False;
  DefaultVisible:=False;
end;

{ TDottedGrayPen }
Constructor TDottedGrayPen.Create(OnChangeEvent:TNotifyEvent);
Begin
  inherited;
  Color:=clGray;
  Style:=psDot;
end;

{ TDarkGrayPen }
Constructor TDarkGrayPen.Create(OnChangeEvent:TNotifyEvent);
Begin
  inherited;
  Color:=clDkGray;
end;

{ TChartBrush }
Constructor TChartBrush.Create(OnChangeEvent:TNotifyEvent);
Begin
  inherited Create;
  Color:=clDefault;
  FBackColor:=clNone;
  OnChange:=OnChangeEvent;
end;

Destructor TChartBrush.Destroy;
begin
  FImage.Free;
  inherited;
end;

Procedure TChartBrush.Assign(Source:TPersistent);
begin
  if Source is TChartBrush then
  begin
    Image:=TChartBrush(Source).FImage;
    FBackColor:=TChartBrush(Source).FBackColor;
  end;

  inherited;
end;

Procedure TChartBrush.Clear;  // 7.0
begin
  Style:=bsClear;
  Image:=nil;
end;

procedure TChartBrush.SetBackColor(const Value:TColor);
begin
  if FBackColor<>Value then
  begin
    FBackColor:=Value;
    Changed;
  end;
end;

procedure TChartBrush.SetImage(const Value: TPicture);
begin
  if Assigned(Value) then Image.Assign(Value)
                     else FreeAndNil(FImage);
  Changed;
end;

Function TChartBrush.GetImage:TPicture;
begin
  if not Assigned(FImage) then
  begin
    FImage:=TPicture.Create;
    FImage.OnChange:=OnChange;
  end;

  result:=FImage;
end;

{ TView3DOptions }
Constructor TView3DOptions.Create({$IFDEF TEEVCL}AParent:TWinControl{$ENDIF});
begin
  inherited Create;

  {$IFDEF TEEVCL}
  FParent      :=AParent;
  {$ENDIF}

  FOrthogonal  :=True;
  FOrthoAngle  :=45;
  FFontZoom    :=100; { % } // 7.0
  FZoom        :=100; { % }
  FZoomText    :=True;
  FRotation    :=345;
  FElevation   :=345;
  FPerspective :=TeeDefaultPerspective; { % }
end;

Procedure TView3DOptions.Repaint;
begin
  {$IFDEF TEEVCL}
  FParent.Invalidate;
  {$ENDIF}
end;

Procedure TView3DOptions.SetIntegerProperty(Var Variable:Integer; Value:Integer);
begin
  if Variable<>Value then
  begin
    Variable:=Value;
    Repaint;
  end;
end;

Procedure TView3DOptions.SetBooleanProperty(Var Variable:Boolean; Value:Boolean);
begin
  if Variable<>Value then
  begin
    Variable:=Value;
    Repaint;
  end;
end;

function TView3DOptions.GetElevation:Integer;
begin
  result:=Round(FElevation);
end;

Procedure TView3DOptions.SetElevationInteger(const Value:Integer);
begin
  SetElevation(Value);
end;

Procedure TView3DOptions.SetElevation(const Value:Double);
begin
  if FElevation<>Value then
  begin
    FElevation:=Value;
    Repaint;
  end;
end;

Procedure TView3DOptions.SetFontZoom(Value:Integer);
begin
  SetIntegerProperty(FFontZoom,Value);
end;

Procedure TView3DOptions.SetPerspective(Value:Integer);
begin
  SetIntegerProperty(FPerspective,Value);
end;

function TView3DOptions.GetRotation:Integer;
begin
  result:=Round(FRotation);
end;

function TView3DOptions.GetZoom:Integer;
begin
  result:=Round(FZoom);
end;

Procedure TView3DOptions.SetRotationInteger(const Value:Integer);
begin
  SetRotation(Value);
end;

Procedure TView3DOptions.SetRotation(const Value:Double);
begin
  if FRotation<>Value then
  begin
    FRotation:=Value;
    Repaint;
  end;
end;

Procedure TView3DOptions.SetTilt(Value:Integer);
begin
  SetIntegerProperty(FTilt,Value);
end;

Procedure TView3DOptions.SetHorizOffset(Value:Integer);
begin
  if FHorizOffset<>Value then
  begin
    FHorizOffset:=Value;
    Repaint;
    if Assigned(FOnScrolled) then FOnScrolled(True);
  end;
end;

Procedure TView3DOptions.SetVertOffset(Value:Integer);
begin
  if FVertOffset<>Value then
  begin
    FVertOffset:=Value;
    Repaint;
    if Assigned(FOnScrolled) then FOnScrolled(False);
  end;
end;

Procedure TView3DOptions.SetOrthoAngle(Value:Integer);
begin
  SetIntegerProperty(FOrthoAngle,Value);
end;

Procedure TView3DOptions.SetOrthogonal(Value:Boolean);
begin
  SetBooleanProperty(FOrthogonal,Value);
end;

Procedure TView3DOptions.SetZoomInteger(const Value:Integer);
begin
  SetZoom(Value);
end;

Procedure TView3DOptions.SetZoom(const Value:Double);
begin
  if FZoom<>Value then
  begin
    if Assigned(FOnChangedZoom) then FOnChangedZoom(Zoom);

    FZoom:=Value;
    Repaint;
  end;
end;

Procedure TView3DOptions.SetZoomText(Value:Boolean);
begin
  SetBooleanProperty(FZoomText,Value);
end;

Procedure TView3DOptions.Assign(Source:TPersistent);
begin
  if Source is TView3DOptions then
  With TView3DOptions(Source) do
  begin
    Self.FElevation   :=FElevation;
    Self.FFontZoom    :=FFontZoom;
    Self.FHorizOffset :=FHorizOffset;
    Self.FOrthoAngle  :=FOrthoAngle;
    Self.FOrthogonal  :=FOrthogonal;
    Self.FPerspective :=FPerspective;
    Self.FRotation    :=FRotation;
    Self.FTilt        :=FTilt;
    Self.FVertOffset  :=FVertOffset;
    Self.FZoom        :=FZoom;
    Self.FZoomText    :=FZoomText;
  end;
end;

function TView3DOptions.CalcOrthoRatio: Double;
var tmpSin   : Extended;
    tmpCos   : Extended;
    tmpAngle : Extended;
begin
  if Orthogonal then
  begin
    tmpAngle:=OrthoAngle;

    if tmpAngle>90 then
       tmpAngle:=180-tmpAngle;

    SinCos(tmpAngle*TeePiStep,tmpSin,tmpCos);

    result:=tmpSin/tmpCos;
  end
  else result:=1;
end;

{ TTeeCanvas }
Procedure TTeeCanvas.InternalDark(Const AColor:TColor; Quantity:Byte);
var tmpColor : TColor;
begin
  tmpColor:=ApplyDark(AColor,Quantity);
  if FBrush.Style=bsSolid then FBrush.Color:=tmpColor
                          else BackColor:=tmpColor;
end;

Function TTeeCanvas.GetFontHeight:Integer;
begin
  result:=TextHeight(TeeCharForHeight);
end;

Procedure TTeeCanvas.SetCanvas(ACanvas:TCanvas);
begin
  FCanvas:=ACanvas;
  FPen   :=FCanvas.Pen;
  FFont  :=FCanvas.Font;
  FBrush :=FCanvas.Brush;

  {$IFNDEF TEECANVASLOCKS}
  {$IFDEF CLR}
  FPen.OwnerLock:=nil;
  FFont.OwnerLock:=nil;
  FBrush.OwnerLock:=nil;
  {$ELSE}
  {$IFNDEF CLX}
  {$IFNDEF LCL}
  FPen.OwnerCriticalSection:=nil;
  FFont.OwnerCriticalSection:=nil;
  FBrush.OwnerCriticalSection:=nil;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
end;

Procedure TTeeCanvas.ResetState;
begin
  With FPen do
  begin
    Color:=clBlack;
    Width:=1;
    Style:=psSolid;
  end;

  With FBrush do
  begin
    Color:=clWhite;
    Style:=bsSolid;
  end;

  With FFont do
  begin
    Color:=clBlack;
    Style:=[];

    {$IFNDEF CLX}
    CharSet:=DEFAULT_CHARSET;
    {$ENDIF}
    Name:=GetDefaultFontName;
    Size:=GetDefaultFontSize;
  end;

  ITransp:=0; // 6.02
  IFont:=nil; // 6.02

  BackColor:=clWhite;
  BackMode:=cbmTransparent;
  TextAlign:=TA_LEFT; { 5.01 }
end;

Procedure TTeeCanvas.AssignBrush(ABrush:TChartBrush);
begin
  AssignBrush(ABrush,ABrush.BackColor,ABrush.Color);
end;

Procedure TTeeCanvas.AssignBrush(ABrush:TChartBrush; ABackColor:TColor);
begin
  AssignBrush(ABrush,ABackColor,ABrush.Color);
end;

{$IFDEF CLX}
Procedure SetTextColor(Handle:QPainterH; Color:Integer);
var QC : QColorH;
begin
  QC:=QColor(Color);
  try
    QPen_setColor(QPainter_pen(Handle), QC);
  finally
    QColor_destroy(QC);
  end;
end;
{$ENDIF}

// deprecated, please use AssignBrush
Procedure TTeeCanvas.AssignBrushColor(ABrush:TChartBrush; AColor,ABackColor:TColor); // deprecated;
begin
  AssignBrush(ABrush,AColor,ABackColor);
end;

Procedure TTeeCanvas.AssignBrush(ABrush:TChartBrush; AColor,ABackColor:TColor);
begin
  if Monochrome then AColor:=clWhite;

  if Assigned(ABrush.FImage) and Assigned(ABrush.FImage.Graphic) then
  begin
    Brush.Style:=bsClear;
    Brush.Bitmap:=ABrush.Image.Bitmap;

    {$IFDEF TEEWINDOWS}
    SetTextColor(Handle,ColorToRGB(AColor));
    {$ENDIF}

    BackMode:=cbmOpaque;
    BackColor:=ABackColor;
  end
  else
  if Assigned(ABrush.Bitmap) then
  begin
    Brush.Style:=bsClear;
    Brush.Bitmap:=ABrush.Bitmap;

    {$IFDEF TEEWINDOWS}
    SetTextColor(Handle,ColorToRGB(AColor));
    {$ENDIF}

    BackMode:=cbmOpaque;
    BackColor:=ABackColor;
  end
  else
  begin
    Brush.Bitmap:=nil;

    if AColor<>Brush.Color then { 5.02 }
       Brush.Color:=AColor;

    if ABrush.Style<>Brush.Style then { 5.02 }
       Brush.Style:=ABrush.Style;

    if ABackColor=clNone then BackMode:=cbmTransparent { 5.02 }
    else
    begin
      BackMode:=cbmOpaque;
      BackColor:=ABackColor;
    end;
  end;
end;

procedure TTeeCanvas.AssignVisiblePen(APen:TPen);
begin
  AssignVisiblePenColor(APen,APen.Color);
end;

Procedure TTeeCanvas.Rectangle(Const R:TRect);
begin
  With R do Rectangle(Left,Top,Right,Bottom);
end;

Procedure TTeeCanvas.DoRectangle(Const Rect:TRect); // obsolete
begin
  Rectangle(Rect);
end;

Procedure TTeeCanvas.DoHorizLine(X0,X1,Y:Integer);
begin
  MoveTo(X0,Y);
  LineTo(X1,Y);
end;

Procedure TTeeCanvas.DoVertLine(X,Y0,Y1:Integer);
begin
  MoveTo(X,Y0);
  LineTo(X,Y1);
end;

Function RGBValue(const Color:TColor):TRGB; {$IFDEF D9}inline;{$ENDIF}
begin
  with result do
  begin
    Red:=Byte(Color);
    Green:=Byte(Color shr 8);
    Blue:=Byte(Color shr 16);
  end;
end;

{$IFDEF TEEWINDOWS}

Function TeeCreatePenSmallDots(const AColor:TColor;
                const Space:Integer=0):{$IFDEF CLX}QPenH{$ELSE}HPen{$ENDIF};
{$IFNDEF CLX}
Var LBrush   : TLogBrush;
    tmpStyle : Array[0..1] of Longint;
{$ENDIF}
begin
  {$IFDEF CLX}
  result:=QPen_create(QColor(AColor),1,PenStyle_DotLine);
  {$ELSE}
  LBrush.lbStyle:=bs_Solid;
  LBrush.lbColor:=ColorToRGB(AColor);
  LBrush.lbHatch:=0;

  {$IFNDEF CLR}
  if Space>0 then
  begin
    tmpStyle[0]:=0;
    tmpStyle[1]:=Space+1;
    result:=ExtCreatePen(PS_GEOMETRIC or PS_USERSTYLE,1,LBrush,2,@tmpStyle);
  end
  else
  {$ENDIF}
    result:=ExtCreatePen(PS_COSMETIC or PS_ALTERNATE,1,LBrush,0,nil);
    
  {$ENDIF}
end;

Procedure TeeSetTeePen(FPen:TPen; APen:TChartPen; AColor:TColor; Handle:TTeeCanvasHandle);
{$IFNDEF CLX}
const
  PenStyles: array[TPenStyle] of Word =

     {$IFDEF LCL}
     (PS_SOLID, PS_DASH, PS_DOT, PS_DASHDOT, PS_DASHDOTDOT,
      PS_INSIDEFRAME, 0 { PS_PATTERN? }, PS_NULL

     {$ELSE}

     (PS_SOLID, PS_DASH, PS_DOT, PS_DASHDOT, PS_DASHDOTDOT, PS_NULL,
      PS_INSIDEFRAME
      {$IFDEF D10}
      ,PS_USERSTYLE, PS_ALTERNATE
      {$ENDIF}
     {$ENDIF}
    );

  PenModes: array[TPenMode] of Word =
    (R2_BLACK, R2_WHITE, R2_NOP, R2_NOT, R2_COPYPEN, R2_NOTCOPYPEN, R2_MERGEPENNOT,
     R2_MASKPENNOT, R2_MERGENOTPEN, R2_MASKNOTPEN, R2_MERGEPEN, R2_NOTMERGEPEN,
     R2_MASKPEN, R2_NOTMASKPEN, R2_XORPEN, R2_NOTXORPEN);
var LBrush   : TLogBrush;
{$ENDIF}
{$IFNDEF CLX}
var tmpEnd : Integer;
{$ENDIF}
begin
  if APen.SmallDots then
  begin
    // Delphi 2005 VCL .Net and Win32 bug.
    // TPen.GetPenData uses TLogPen instead of TExtLogPen
    // Workaround for Delphi 2005: Set "psDot" style
    // Another Delphi 2005 VCL Bug: Setting Pen.Handle leaks GDI Object.

    // These bugs appear fixed in BDS 2006.

    {$IFDEF D9WITHOUTUPDATE2}
    FPen.Color:=AColor;
    FPen.Style:=psDot;
    FPen.Mode:=APen.Mode;

    if TeeCheckPenWidth then FPen.Width:=0
                        else FPen.Width:=1;

    {$ELSE}
    FPen.Handle:=TeeCreatePenSmallDots(AColor,APen.SmallSpace);
    FPen.Mode:=APen.Mode;  // 6.02
    {$ENDIF}
  end
  else
  {$IFNDEF CLX}
  if APen.Width>1 then
  begin
    FPen.Assign(APen);
    FPen.Color:=AColor;

    {$IFDEF D9WITHOUTUPDATE2} // Workaround for VCL bug at TPen.SetData
    if APen.EndStyle<>esRound then
    begin
    {$ENDIF}
      LBrush.lbStyle:=bs_Solid;
      LBrush.lbColor:=ColorToRGB(AColor);
      LBrush.lbHatch:=0;

      Case APen.EndStyle of  { 5.01 }
        esRound : tmpEnd:=PS_ENDCAP_ROUND or PS_JOIN_ROUND;
        esSquare: tmpEnd:=PS_ENDCAP_SQUARE or PS_JOIN_BEVEL;
      else tmpEnd:=PS_ENDCAP_FLAT or PS_JOIN_MITER;
      end;

      FPen.Handle:=ExtCreatePen( PS_GEOMETRIC or
                                 PenStyles[APen.Style] or
                                 tmpEnd,
                                 APen.Width,
                                 LBrush,
                                 0,
                                 nil );

      //  The following helps SVG (VML, etc) exporting when Pen.Width > 1,
      //  but breaks drawing dotted pens.
      //    SelectObject(Handle, ExtCreatePen( PS_GEOMETRIC or
      //         PenStyles[APen.Style] or tmpEnd,APen.Width,LBrush,0,nil));

      // FPen.Mode:=APen.Mode;
      SetROP2(Handle, PenModes[APen.Mode]);

    {$IFDEF D9WITHOUTUPDATE2}
    end;
    {$ENDIF}
  end
  else
  {$ENDIF}
  begin
    FPen.Assign(APen);

    // speed optimizations ?
    //if APen.Style<>FPen.Style then FPen.Style:=APen.Style;
    //if APen.Width<>FPen.Width then FPen.Width:=APen.Width;
    //if APen.Mode<>FPen.Mode then FPen.Mode:=APen.Mode;

    if FPen.Color<>AColor then FPen.Color:=AColor;

    if TeeCheckPenWidth and (FPen.Style<>psSolid) and (FPen.Width=1) then
       FPen.Width:=0;
  end;
end;
{$ENDIF}

procedure TTeeCanvas.AssignVisiblePenColor(APen:TPen; AColor:TColor);
begin
  if MonoChrome then AColor:=clBlack;

  if not (APen is TChartPen) then
  begin
    FPen.Assign(APen);
    FPen.Color:=AColor;

    if TeeCheckPenWidth and (FPen.Style<>psSolid) and (FPen.Width=1) then
       FPen.Width:=0;
  end
  else
  if TChartPen(APen).Visible then
  begin
    {$IFNDEF CLX}
    if IsWindowsNT and (not SupportsFullRotation) then
       TeeSetTeePen(FPen,TChartPen(APen),AColor,Handle) { only valid in Windows-NT }
    else
    {$ENDIF}
    begin
      FPen.Assign(APen);

      //if APen.Style<>FPen.Style then FPen.Style:=APen.Style;
      //if APen.Width<>FPen.Width then FPen.Width:=APen.Width;
      //if APen.Mode<>FPen.Mode then FPen.Mode:=APen.Mode;

      FPen.Color:=AColor;

      if TeeCheckPenWidth and (FPen.Style<>psSolid) and (FPen.Width=1) then
         FPen.Width:=0;

      {$IFDEF CLX}
      if FPen.Style<>psSolid then BackMode:=cbmTransparent;
      {$ENDIF}
    end;
  end
  else FPen.Style:=psClear;
end;

Procedure TTeeCanvas.AssignFont(AFont:TTeeFont);
{$IFNDEF CLX}
var tmp : TTeeCanvasHandle;
{$ENDIF}
Begin
  With FFont do
  begin
    {$IFNDEF LCL}
    AFont.PixelsPerInch:=PixelsPerInch;
    {$ENDIF}

    Assign(AFont);

    if FontZoom<>100 then  // 6.01
       Size:=Round(Size*FontZoom*0.01);
  end;

  if MonoChrome then FFont.Color:=clBlack;

  {$IFNDEF CLX}
  tmp:=Handle;
  {$IFDEF TEEWINDOWS}
  if GetTextCharacterExtra(tmp)<>AFont.InterCharSize then
     SetTextCharacterExtra(tmp,AFont.InterCharSize);
  {$ENDIF}
  {$ENDIF}

  IFont:=AFont;
  AFont.ICanvas:=Self;
end;

Function TTeeCanvas.TextWidth(Const St:String):Integer;
var tmpStr: WideString;
begin
  tmpStr:=St;
  {$IFDEF AXUNICODE}
  if Pos('@U#',St)= 1 then
  Begin
    tmpStr:=Unicoding.ConvertCPList2Char(Unicoding.ConvertUTF82CPList(St))
  end
  else
    tmpStr:=Unicoding.StringToWideString(St,0);
  result:=TextExtent(tmpStr).cx;  //don't go to base method
  {$ELSE}
  {$IFNDEF CLX}
  result:=FCanvas.TextExtent(tmpStr).cx;
  {$ELSE}
  result:=FCanvas.TextWidth(tmpStr);
  {$ENDIF}
  {$ENDIF}

  if Assigned(IFont) and Assigned(IFont.FShadow) and IFont.FShadow.Visible then
     Inc(result,Abs(IFont.FShadow.HorizSize));
end;

Function TTeeCanvas.TextHeight(Const St:String):Integer;
Begin
  {$IFNDEF CLX}
  result:=FCanvas.TextExtent(St).cy;
  {$ELSE}
  result:=FCanvas.TextHeight(St);
  {$ENDIF}

  if Assigned(IFont) and Assigned(IFont.FShadow) and IFont.FShadow.Visible then
     Inc(result,Abs(IFont.FShadow.VertSize));
end;

{$IFDEF TEEUNICODE}
function TTeeCanvas.TextExtent(const Text:WideString):Types.TSize;
begin
  {$IFDEF CLX}
  result:=FCanvas.TextExtent(Text);
  {$ELSE}
  result.cx:=0;
  result.cy:=0;
  Windows.GetTextExtentPoint32W(Handle, PWideChar(Text), Length(Text), result);
  {$ENDIF}
end;

Function TTeeCanvas.TextWidth(Const St:WideString):Integer;
begin
  {$IFNDEF CLX}
  result:=TextExtent(St).cx;
  {$ELSE}
  result:=FCanvas.TextWidth(St);
  {$ENDIF}

  if Assigned(IFont) and Assigned(IFont.FShadow) and IFont.FShadow.Visible then
     Inc(result,Abs(IFont.FShadow.HorizSize));
end;

Function TTeeCanvas.TextHeight(Const St:WideString):Integer;
begin
  {$IFNDEF CLX}
  result:=TextExtent(St).cy;
  {$ELSE}
  result:=FCanvas.TextHeight(St);
  {$ENDIF}

  if Assigned(IFont) and Assigned(IFont.FShadow) and IFont.FShadow.Visible then
     Inc(result,Abs(IFont.FShadow.VertSize));
end;
{$ENDIF}

procedure TTeeCanvas.Ellipse(const R:TRect);
begin
  with R do Ellipse(Left,Top,Right,Bottom);
end;

procedure TTeeCanvas.Frame3D( var Rect: TRect; TopColor,BottomColor: TColor;
                              Width: Integer);
var TopRight   : TPoint;
    BottomLeft : TPoint;
    {$IFNDEF D5}
    P          : TPointArray;
    {$ENDIF}
begin
  FPen.Width:=1;
  FPen.Style:=psSolid;

  Dec(Rect.Bottom);
  Dec(Rect.Right);

  while Width > 0 do
  begin
    Dec(Width);

    with Rect do
    begin
      TopRight.X := Right;
      TopRight.Y := Top;
      BottomLeft.X := Left;
      BottomLeft.Y := Bottom;
      FPen.Color := TopColor;

      {$IFDEF D5}
      Polyline([BottomLeft,TopLeft,TopRight]);
      {$ELSE}
      SetLength(P,3);
      P[0]:=BottomLeft;
      P[1]:=TopLeft;
      P[2]:=TopRight;
      Polyline(P);
      P:=nil;
      {$ENDIF}

      FPen.Color := BottomColor;
      Dec(BottomLeft.X);

      {$IFDEF D5}
      Polyline([TopRight,BottomRight,BottomLeft]);
      {$ELSE}
      SetLength(P,3);
      P[0]:=TopRight;
      P[1]:=BottomRight;
      P[2]:=BottomLeft;
      Polyline(P);
      P:=nil;
      {$ENDIF}
    end;

    InflateRect(Rect, -1, -1);
  end;

  Inc(Rect.Bottom);
  Inc(Rect.Right);
end;

procedure TTeeCanvas.LineTo(const P:TPoint);
begin
  LineTo(P.X,P.Y);
end;

procedure TTeeCanvas.MoveTo(const P:TPoint);
begin
  MoveTo(P.X,P.Y);
end;

procedure TTeeCanvas.RoundRect(const R: TRect; X,Y:Integer);
begin
  with R do RoundRect(Left,Top,Right,Bottom,X,Y);
end;

Procedure TTeeCanvas.TextOut(X,Y:Integer; const Text:String; AllowHtml:Boolean);
begin
  if AllowHtml then HtmlTextOut(Self,X,Y,Text)  // 7.02
               else TextOut(X,Y,Text);
end;

{$IFDEF AXUNICODE}
Procedure TTeeCanvas.TextOut(X,Y:Integer; const Text:WideString);
Var tmpWideString:WideString;
begin
  if Pos('@U#',Text)= 1 then
  Begin
      tmpWideString:=Unicoding.ConvertCPList2Char(Unicoding.ConvertUTF82CPList(Text))
  end
  else
    tmpWideString:=Unicoding.StringToWideString(Text,0);
  Windows.TextOutW(Handle,X, Y, PWideChar(tmpWideString),LStrLenW(PWideChar(tmpWideString)));
end;
{$ENDIF}

Procedure TTeeCanvas.Line(X0,Y0,X1,Y1:Integer);
begin
  MoveTo(X0,Y0);
  LineTo(X1,Y1);
end;

procedure TTeeCanvas.Line(const FromPoint, ToPoint: TPoint);
begin
  Line(FromPoint.X,FromPoint.Y,ToPoint.X,ToPoint.Y)
end;

Function TTeeCanvas.BeginBlending(const R: TRect;
  Transparency: TTeeTransparency):TTeeBlend;
begin
  ITransp:=Transparency;
  result:=TTeeBlend.Create(Self,R);
end;

procedure TTeeCanvas.EndBlending(Blend:TTeeBlend);
begin
  Blend.DoBlend(ITransp);
  Blend.Free;
end;

procedure TTeeCanvas.Arc(const Left, Top, Right, Bottom:Integer; StartAngle,EndAngle:Double);
var
  XRadius, YRadius,
  XCenter, YCenter : Integer;

  Procedure CalcPoint(const Angle:Double; out x,y:Integer);
  var tmpSin : Extended;
      tmpCos : Extended;
  begin
    SinCos(Angle,tmpSin,tmpCos);
    x:=XCenter+Round(XRadius*tmpCos);
    y:=YCenter-Round(YRadius*tmpSin);
  end;

var X3,Y3 : Integer;
    X4,Y4 : Integer;
begin
  XRadius:=(Right-Left) div 2;
  YRadius:=(Bottom-Top) div 2;
  XCenter:=Left+XRadius;
  YCenter:=Top+YRadius;

  CalcPoint(StartAngle*TeePiStep,X3,Y3);
  CalcPoint(EndAngle*TeePiStep,X4,Y4);
  Arc(Left,Top,Right,Bottom,X3,Y3,X4,Y4);
end;

Procedure TTeeCanvas.Arrow(Filled:Boolean; const ArrowPercent:Double;
                           const FromPoint,ToPoint:TPoint;
                           ArrowWidth,ArrowHeight:Integer);
Var x    : Double;
    y    : Double;
    SinA : Double;
    CosA : Double;

    Function CalcArrowPoint:TPoint;
    Begin
      result.X:=Round( x*CosA + y*SinA);
      result.Y:=Round(-x*SinA + y*CosA);
    end;

Var tmpHoriz  : Integer;
    tmpVert   : Integer;
    dx        : Integer;
    dy        : Integer;
    tmpHoriz4 : Double;
    xb        : Double;
    yb        : Double;
    l         : Double;

   { These are the Arrows points coordinates }
    pc,pd,pe,pf,pg,ph : TPoint;

    (*           pc
                   |\
    ph           pf| \
      |------------   \ ToPoint
 From |------------   /
    pg           pe| /
                   |/
                 pd
    *)
begin
  dx:=ToPoint.x-FromPoint.x;
  dy:=FromPoint.y-ToPoint.y;
  l:=TeeDistance(dx,dy);

  if l>0 then  { if at least one pixel... }
  Begin
    tmpHoriz:=ArrowWidth;
    tmpVert :=Math.Min(Round(l),ArrowHeight);
    SinA:= dy / l;
    CosA:= dx / l;

    xb:= ToPoint.x*CosA - ToPoint.y*SinA;
    yb:= ToPoint.x*SinA + ToPoint.y*CosA;

    x := xb - tmpVert;
    y := yb - tmpHoriz*0.5;
    pc:=CalcArrowPoint;

    y := yb + tmpHoriz*0.5;
    pd:=CalcArrowPoint;

    if Filled then
    Begin
      tmpHoriz4:=tmpHoriz*(ArrowPercent*0.005);
      y := yb - tmpHoriz4;
      pe:=CalcArrowPoint;

      y := yb + tmpHoriz4;
      pf:=CalcArrowPoint;

      x := FromPoint.x*cosa - FromPoint.y*sina;
      y := yb - tmpHoriz4;
      pg:=CalcArrowPoint;

      y := yb + tmpHoriz4;
      ph:=CalcArrowPoint;

      Polygon([ ph,pg,pe,pc,ToPoint,pd,pf ]);
    end
    else
    begin
      Line(FromPoint,ToPoint);
      LineTo(pd.x,pd.y);
      Line(ToPoint,pc);
    end
  end;
end;

Procedure TTeeCanvas.PolygonGradient(const Points:Array of TPoint; Gradient:TCustomTeeGradient);
var OldBrush : TBrushStyle;
begin
  ClipPolygon(Points,Length(Points));
  Gradient.Draw(Self,RectFromPolygon(Points,Length(Points)));
  UnClipRectangle;

  if Pen.Style<>psClear then  // outline
  begin
    OldBrush:=Brush.Style;
    Brush.Style:=bsClear;
    Polygon(Points);
    Brush.Style:=OldBrush;
  end;
end;

{ TCanvas3D }
Procedure TCanvas3D.Arrow( Filled:Boolean; Const FromPoint,ToPoint:TPoint;
                           ArrowWidth,ArrowHeight,Z:Integer);
begin
  Arrow(Filled,FromPoint,ToPoint,ArrowWidth,ArrowHeight,Z,50);
end;

Procedure TCanvas3D.Assign(Source:TCanvas3D);
begin
  Monochrome:=Source.Monochrome;
  F3DOptions:=Source.F3DOptions;
end;

procedure TCanvas3D.BeginEntity(const Entity:String);
begin
end;

procedure TCanvas3D.EndEntity;
begin
end;

function TCanvas3D.Calc3DPoints(const Points:Array of TPoint; z:Integer):TPointArray;
var t : Integer;
begin
  SetLength(result,Length(Points));
  for t:=0 to Length(Points)-1 do
      result[t]:=Calculate3DPosition(Points[t].X,Points[t].Y,z);
end;

function TCanvas3D.CalcRect3D(const R: TRect; Z: Integer): TRect;
begin
  result.TopLeft:=Calculate3DPosition(R.TopLeft,Z);
  result.BottomRight:=Calculate3DPosition(R.BottomRight,Z);
end;

Function TCanvas3D.Calculate3DPosition(const P:TPoint3D):TPoint; {$IFDEF 10}inline;{$ENDIF}
begin
  result:=Calculate3DPosition(P.X,P.Y,P.Z)
end;

Function TCanvas3D.Calculate3DPosition(P:TPoint; z:Integer):TPoint; {$IFDEF 10}inline;{$ENDIF}
begin
  result:=Calculate3DPosition(P.X,P.Y,z)
end;

procedure TCanvas3D.Cube(const R: TRect; Z0, Z1: Integer;
  DarkSides: Boolean=True);
begin
  with R do Cube(Left,Right,Top,Bottom,Z0,Z1,DarkSides);
end;

procedure TCanvas3D.DisableRotation;
begin
end;

procedure TCanvas3D.EnableRotation;
begin
end;

procedure TCanvas3D.EllipseWithZ(const Rect:TRect; Z: Integer);
begin
  with Rect do
       EllipseWithZ(Left,Top,Right,Bottom,Z);
end;

procedure TCanvas3D.PolygonWithZ(const Points: Array of TPoint; Z:Integer);
var P : TPointArray;
begin
  P:=Calc3DPoints(Points,Z);
  try
    Polygon(P);
  finally
    P:=nil;
  end;
end;

procedure TCanvas3D.Polyline(const Points:{$IFDEF D5}Array of TPoint{$ELSE}TPointArray{$ENDIF}; Z:Integer);
var P : TPointArray;
begin
  P:=Calc3DPoints(Points,Z);
  try
    Polyline(P);
  finally
    P:=nil;
  end;
end;

procedure TCanvas3D.HorizLine3D(Left, Right, Y, Z: Integer);
begin
  MoveTo3D(Left,Y,Z);
  LineTo3D(Right,Y,Z);
end;

procedure TCanvas3D.VertLine3D(X, Top, Bottom, Z: Integer);
begin
  MoveTo3D(X,Top,Z);
  LineTo3D(X,Bottom,Z);
end;

procedure TCanvas3D.ZLine3D(X, Y, Z0, Z1: Integer);
begin
  MoveTo3D(X,Y,Z0);
  LineTo3D(X,Y,Z1);
end;

// Changed from "function" to "procedure" in v7.07 (BCB compatibility)
procedure TCanvas3D.FourPointsFromRect(const R: TRect;
                          Z: Integer; var P: TFourPoints);
begin
  with R do
  begin
    P[0]:=Calculate3DPosition(TopLeft,Z);
    P[1]:=Calculate3DPosition(Right,Top,Z);
    P[2]:=Calculate3DPosition(BottomRight,Z);
    P[3]:=Calculate3DPosition(Left,Bottom,Z);
  end;
end;

procedure TCanvas3D.FrontPlaneBegin;
begin
  if IDisabledRotation=0 then
     DisableRotation;
  Inc(IDisabledRotation);
end;

procedure TCanvas3D.FrontPlaneEnd;
begin
  Dec(IDisabledRotation);
  if IDisabledRotation=0 then
     EnableRotation;
end;

Procedure TCanvas3D.LineWithZ(X0,Y0,X1,Y1,Z:Integer);
begin
  MoveTo3D(X0,Y0,Z);
  LineTo3D(X1,Y1,Z);
end;

procedure TCanvas3D.LineWithZ(const FromPoint, ToPoint: TPoint;
  Z: Integer);
begin
  LineWithZ(FromPoint.X,FromPoint.Y,ToPoint.X,ToPoint.Y,Z)
end;

procedure TCanvas3D.MoveTo3D(X,Y,Z:Integer);
begin
  MoveTo(Calculate3DPosition(X,Y,Z));
end;

procedure TCanvas3D.MoveTo3D(const P:TPoint3D);
begin
  MoveTo3D(P.x,P.y,P.z);
end;

procedure TCanvas3D.LineTo3D(const P:TPoint3D);
begin
  LineTo3D(P.x,P.y,P.z);
end;

procedure TCanvas3D.LineTo3D(X,Y,Z:Integer);
begin
  LineTo(Calculate3DPosition(X,Y,Z));
end;

procedure TCanvas3D.PlaneWithZ(const P: TFourPoints; Z: Integer);
begin
  PlaneWithZ(P[0],P[1],P[2],P[3],Z);
end;

Procedure TCanvas3D.Rectangle(Const R:TRect; Z:Integer);
begin
  RectangleWithZ(R,Z);
end;

Procedure TCanvas3D.Rectangle(X0,Y0,X1,Y1,Z:Integer); {$IFDEF 10}inline;{$ENDIF}
begin
  RectangleWithZ(TeeRect(X0,Y0,X1,Y1),Z);
end;

function TCanvas3D.RectFromRectZ(const R: TRect; Z: Integer): TRect;
var P : TFourPoints;
begin
  FourPointsFromRect(R,Z,P);
  result:=RectFromPolygon(P,4);
end;

procedure TCanvas3D.RotatedEllipse(Left, Top, Right, Bottom, Z: Integer;
  const Angle: Double);
Var P       : {$IFDEF D5}TCirclePoints{$ELSE}TPointArray{$ENDIF};
    Points  : TTrianglePoints;
    PiStep  : Double;
    t       : Integer;
    tmpX    : Double;
    tmpY    : Double;
    XCenter : Double;
    YCenter : Double;
    XRadius : Double;
    YRadius : Double;
    tmpSin  : Extended;
    tmpCos  : Extended;
    tmpSinAngle  : Extended;
    tmpCosAngle  : Extended;
    Old     : TPenStyle;
begin
  XCenter:=(Right+Left)*0.5;
  YCenter:=(Bottom+Top)*0.5;
  XRadius:=XCenter-Left;
  YRadius:=YCenter-Top;

  piStep:=2*Pi/(NumCirclePoints-1);

  SinCos(Angle*TeePiStep,tmpSinAngle,tmpCosAngle);

  {$IFNDEF D5}
  SetLength(P,NumCirclePoints);
  {$ENDIF}

  for t:=0 to NumCirclePoints-1 do
  begin
    SinCos(t*piStep,tmpSin,tmpCos);
    tmpX:=XRadius*tmpSin;
    tmpY:=YRadius*tmpCos;

    P[t].X:=Round(XCenter+(tmpX*tmpCosAngle+tmpY*tmpSinAngle));
    P[t].Y:=Round(YCenter+(-tmpX*tmpSinAngle+tmpY*tmpCosAngle));
  end;

  if Brush.Style<>bsClear then
  begin
    Old:=Pen.Style;
    Pen.Style:=psClear;

    Points[0].X:=Round(XCenter);
    Points[0].Y:=Round(YCenter);
    Points[1]:=P[0];
    Points[2]:=P[1];
    PolygonWithZ(Points,Z);

    Points[1]:=P[1];
    for t:=2 to NumCirclePoints-1 do
    begin
      Points[2]:=P[t];
      PolygonWithZ(Points,Z);
      Points[1]:=P[t];
    end;

    Pen.Style:=Old;
  end;

  if Pen.Style<>psClear then
     Polyline(P,Z);

  {$IFNDEF D5}
  P:=nil;
  {$ENDIF}
end;

{$IFDEF CLR}
type
  PByteArray=IntPtr;
{$ENDIF}

{$IFNDEF LCL}
{$DEFINE USE_SCANLINE}
{$ENDIF}

procedure TCanvas3D.StretchDraw(const Rect:TRect; Graphic: TGraphic;
                                    Pos:Integer; Plane:TCanvas3DPlane=cpZ);
{$IFNDEF CLX}
const
  BytesPerPixel=3;
{$ENDIF}

var x,y,
    tmpW,
    tmpH  : Integer;
    DestW,
    DestH : Double;
    R     : TRect;
    Bitmap : TBitmap;

    {$IFNDEF CLX}
    tmpScan : PByteArray;
    Line    : PByteArray;
    Dif     : Integer;
    {$ENDIF}

    {$IFNDEF CLR}
    {$IFNDEF CLX}
    P       : PChar;
    {$ENDIF}
    {$ENDIF}

    {$IFNDEF USE_SCANLINE}
    tmpCanvas : TCanvas;
    {$ELSE}
    {$IFDEF CLX}
    tmpCanvas : TCanvas;
    {$ENDIF}
    {$ENDIF}

    {$IFNDEF CLX}
    {$IFNDEF CLR}
    tmpFastBrush : Boolean;
    CanvasDC  : TTeeCanvasHandle;
    {$ENDIF}
    {$ENDIF}

    IPoints   : TFourPoints;
begin
  Pen.Style:=psClear;

  if Graphic is TBitmap then
  begin
    Bitmap:=TBitmap(Graphic);
    Bitmap.PixelFormat:=TeePixelFormat;
  end
  else
  begin
    Bitmap:=TBitmap.Create;
    Bitmap.PixelFormat:=TeePixelFormat;

    {$IFDEF IGNOREPALETTE}
    Bitmap.IgnorePalette:=Graphic.Palette=0;  // 7.0
    {$ENDIF}

    Bitmap.Assign(Graphic);
    Bitmap.PixelFormat:=TeePixelFormat;
  end;

  tmpW:=Bitmap.Width;
  tmpH:=Bitmap.Height;

  if (tmpW=0) or (tmpH=0) then
     Exit;

  DestH:=(Rect.Bottom-Rect.Top)/tmpH;
  DestW:=(Rect.Right-Rect.Left)/tmpW;

  {$IFDEF LCL}
  tmpCanvas:=Bitmap.Canvas;
  {$ELSE}
  {$IFNDEF CLX}
  Line:=Bitmap.ScanLine[0];
  Dif:=Integer(Bitmap.ScanLine[1])-Integer(Line);
  {$ELSE}
  tmpCanvas:=Bitmap.Canvas;
  {$ENDIF}
  {$ENDIF}

  {$IFNDEF CLR}
  {$IFNDEF CLX}
  tmpFastBrush:=Assigned(@TeeSetDCBrushColor);
  if tmpFastBrush then
  begin
    CanvasDC:=Handle;

    {$IFDEF TEEWINDOWS}
    SelectObject(CanvasDC,GetStockObject(DC_BRUSH));
    {$ENDIF}
  end
  else
    CanvasDC:=0;
  {$ENDIF}
  {$ENDIF}

  R.Top:=Rect.Top;

  for y:=0 to tmpH-1 do
  begin
    {$IFDEF USE_SCANLINE}
    {$IFNDEF CLX}
    tmpScan:=PByteArray(Integer(Line)+Dif*y);
    {$ENDIF}
    {$ENDIF}

    R.Bottom:=Rect.Top+Round(DestH*(y+1));

    R.Left:=Rect.Left;

    case Plane of
      cpX: begin
             IPoints[0]:=Calculate3DPosition(Pos,R.Top,R.Left);
             IPoints[3]:=Calculate3DPosition(Pos,R.Bottom,R.Left);
           end;
      cpY: begin
             IPoints[0]:=Calculate3DPosition(R.Left,Pos,R.Top);
             IPoints[3]:=Calculate3DPosition(R.Left,Pos,R.Bottom);
           end;
    else
    begin
      IPoints[0]:=Calculate3DPosition(R.Left,R.Top,Pos);
      IPoints[3]:=Calculate3DPosition(R.Left,R.Bottom,Pos);
    end;
    end;

    for x:=0 to tmpW-1 do
    begin
      R.Right:=Rect.Left+Round(DestW*(x+1));

      case Plane of
        cpX: begin
               IPoints[1]:=Calculate3DPosition(Pos,R.Top,R.Right);
               IPoints[2]:=Calculate3DPosition(Pos,R.Bottom,R.Right);
             end;
        cpY: begin
               IPoints[1]:=Calculate3DPosition(R.Right,Pos,R.Top);
               IPoints[2]:=Calculate3DPosition(R.Right,Pos,R.Bottom);
             end;
      else
      begin
        IPoints[1]:=Calculate3DPosition(R.Right,R.Top,Pos);
        IPoints[2]:=Calculate3DPosition(R.Right,R.Bottom,Pos);
      end;
      end;

      {$IFDEF LCL}
      Brush.Color:=tmpCanvas.Pixels[x,y];
      {$ELSE}
      {$IFDEF CLX}
       {$IFDEF D7}
       Brush.Color:=tmpCanvas.Pixels[x,y];
       {$ELSE}
        {$IFDEF MSWINDOWS}
        Brush.Color:=Windows.GetPixel(QPainter_handle(tmpCanvas.Handle), X, Y);
        {$ELSE}
        Brush.Color:=0; // Not implemented.
        {$ENDIF}
       {$ENDIF}

      {$ELSE}

       {$IFDEF CLR}
        { TODO : ??? }
        {$IFNDEF TEESAFECLR}
        //p:=@tmpScan[X*BytesPerPixel];
        {$ENDIF}
       {$ELSE}
       p:=PChar(@tmpScan[X*BytesPerPixel]);
       {$ENDIF}

       {$IFNDEF TEESAFECLR}
       if tmpFastBrush then // 7.0
          TeeSetDCBrushColor(CanvasDC,Byte((p+2)^) or (Byte((p+1)^) shl 8) or (Byte((p)^) shl 16))
       else
          Brush.Color:=Byte((p+2)^) or (Byte((p+1)^) shl 8) or (Byte((p)^) shl 16);
       {$ENDIF}

      {$ENDIF}
      {$ENDIF}

      Polygon(IPoints);

      R.Left:=R.Right;

      IPoints[0]:=IPoints[1];
      IPoints[3]:=IPoints[2];
    end;

    R.Top:=R.Bottom;
  end;

  {$IFNDEF CLR}
  {$IFNDEF CLX}
  if tmpFastBrush then
     Brush.Handle:=0;
  {$ENDIF}
  {$ENDIF}

  if not (Graphic is TBitmap) then
     Bitmap.Free;
end;

{$IFNDEF CLR}
function TCanvas3D._AddRef: Integer;
begin
  result:=-1;
end;

function TCanvas3D._Release: Integer;
begin
  result:=-1;
end;

function TCanvas3D.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;
{$ENDIF}

{ TTeeCanvas3D }
Constructor TTeeCanvas3D.Create;
begin
  inherited;
  FontZoom:=100;
  IZoomText:=True;
  FBufferedDisplay:=True;
  FDirty:=True;
  FTextAlign:=TA_LEFT;
end;

Procedure TTeeCanvas3D.DeleteBitmap;
begin
  {$IFDEF CLX}
  if Assigned(FBitmap) and QPainter_isActive(FBitmap.Canvas.Handle) then
     QPainter_end(FBitmap.Canvas.Handle);
  {$ENDIF}
  FreeAndNil(FBitmap);
end;

Destructor TTeeCanvas3D.Destroy;
begin
  DeleteBitmap;
  inherited;
end;

Function TTeeCanvas3D.GetBackMode:TCanvasBackMode;
begin
  {$IFDEF CLX}
  if QPainter_BackgroundMode(Handle)=BGMode_TransparentMode then
     result:=cbmTransparent
  else
     result:=cbmOpaque;
  {$ELSE}
  result:=TCanvasBackMode(GetBkMode(FCanvas.Handle));
  {$ENDIF}
end;

Procedure TTeeCanvas3D.SetBackMode(Mode:TCanvasBackMode); { Opaque, Transparent }
begin
  {$IFDEF CLX}
  if Mode<>GetBackMode then
  begin
    FCanvas.Start;
    if Mode=cbmTransparent then QPainter_setBackgroundMode(Handle,BGMode_TransparentMode)
    else
    if Mode=cbmOpaque then QPainter_setBackGroundMode(Handle,BGMode_OpaqueMode);
    FCanvas.Stop;
  end;
  {$ELSE}
  SetBkMode(FCanvas.Handle,Ord(Mode));
  {$ENDIF}
end;

Procedure TTeeCanvas3D.SetBackColor(Color:TColor);
{$IFDEF CLX}
Var QC : QColorH;
{$ENDIF}
begin
  {$IFDEF CLX}
  if Color<>GetBackColor then
  begin
    QC:=QColor(Color);
    FCanvas.Start;
    QPainter_setBackgroundColor(Handle,QC);
    FCanvas.Stop;
    QColor_destroy(QC);
  end;
  {$ELSE}
  SetBkColor(FCanvas.Handle,TColorRef(ColorToRGB(Color)));
  {$ENDIF}
end;

function TTeeCanvas3D.GetBackColor:TColor;
begin
  {$IFDEF CLX}
  result:=QColorColor(QPainter_backgroundColor(Handle));
  {$ELSE}
  result:=TColor(GetBkColor(FCanvas.Handle));
  {$ENDIF}
end;

Procedure TTeeCanvas3D.TextOut(X,Y:Integer; const Text:String);
{$IFNDEF CLX}
var tmpDC  : TTeeCanvasHandle;
{$ENDIF}
  {$IFDEF AXUNICODE}
    tmpWideString : WideString;
  {$ENDIF}

  {$IFDEF CLX}
  Procedure InternalTextOut(AX,AY:Integer);
  var tmp : Integer;
  begin
    tmp:=TextAlign;
    if tmp>=TA_BOTTOM then
    begin
      Dec(AY,TextHeight(Text));
      Dec(tmp,TA_BOTTOM);
    end;

    if tmp=TA_RIGHT then
       Dec(AX,TextWidth(Text))
    else
    if tmp=TA_CENTER then
       Dec(AX,TextWidth(Text) div 2);

    FCanvas.TextOut(AX,AY,Text);
  end;

  {$ELSE}

  Function IsTrueTypeFont:Boolean;
  var tmpMet : TTextMetric;
  begin
    GetTextMetrics(tmpDC,tmpMet);
    result:=(tmpMet.tmPitchAndFamily and TMPF_TRUETYPE)=TMPF_TRUETYPE;
  end;
  {$ENDIF}

  Function RectText(tmpX,tmpY:Integer):TRect;
  var tmpW : Integer;
      tmpH : Integer;
      tmp  : Integer;
  begin
    tmpW:=TextWidth(Text);
    tmpH:=TextHeight(Text);

    tmp:=TextAlign;
    if tmp>=TA_BOTTOM then Dec(tmp,TA_BOTTOM);

    if tmp=TA_RIGHT then
       result:=TeeRect(tmpX-tmpW,tmpY,tmpX,tmpY+tmpH)
    else
    if tmp=TA_CENTER then
       result:=TeeRect(tmpX-(tmpW div 2),tmpY,tmpX+(tmpW div 2),tmpY+tmpH)
    else
       result:=TeeRect(tmpX,tmpY,tmpX+tmpW,tmpY+tmpH);
  end;

  {$IFNDEF CLX}
  procedure DoTextOut(X,Y:Integer);
  begin
    {$IFDEF AXUNICODE}
    {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.TextOutW(tmpDC,X,Y,
                   PWideChar(tmpWideString),LStrLenW(PWideChar(tmpWideString)));
    {$ELSE}
    {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.TextOut(tmpDC,X,Y,
                              {$IFNDEF CLR}PChar{$ENDIF}(Text),Length(Text));
    {$ENDIF}
  end;

  Procedure CreateFontPath;
  begin
    BeginPath(tmpDC);
    DoTextOut(X,Y);
    EndPath(tmpDC);
  end;
  {$ENDIF}

Var tmpX     : Integer;
    tmpY     : Integer;

    {$IFDEF CLX}

    tmpColor : TColor;

    {$ELSE}
    tmpFontGradient : Boolean;
    tmpFontOutLine  : Boolean;
    tmpFontPic      : Boolean;
    tmp      : Integer;
    tmpW     : Integer;
    {$ENDIF}

    tmpBlend : TTeeBlend;
begin
  {$IFNDEF CLX}
  tmpDC:=FCanvas.Handle;
  {$ENDIF}

  if Assigned(IFont) and Assigned(IFont.FShadow) then
  With IFont.FShadow do
  if Visible and ((HorizSize<>0) or (VertSize<>0)) then
  begin
    if HorizSize<0 then
    begin
      tmpX:=X;
      Dec(X,HorizSize);
    end
    else tmpX:=X+HorizSize;

    if VertSize<0 then
    begin
      tmpY:=Y;
      Dec(Y,VertSize);
    end
    else tmpY:=Y+VertSize;

    if Transparency>0 then
       tmpBlend:=BeginBlending(RectText(tmpX,tmpY),Transparency)
    else
       tmpBlend:=nil;

    {$IFNDEF CLX}
    SetTextColor(tmpDC, ColorToRGB(IFont.Shadow.Color));

    DoTextOut(tmpX,tmpY);

    if Smooth and (SmoothBlur>0) then
    if Assigned(Self.FBitmap) then
    begin
      with TBlurFilter.Create(nil) do
      try
        Steps:=SmoothBlur;

        tmpW:=FCanvas.TextWidth(Text);

        tmp:=Self.TextAlign;

        if tmp>=TA_BOTTOM then
           Dec(tmp,TA_BOTTOM);

        if tmp=TA_RIGHT then
           Dec(tmpX,tmpW)
        else
        if tmp=TA_CENTER then
           Dec(tmpX,tmpW div 2);

        // Do not use TextHeight/TextWidth as they already increase shadow size
        Apply(FBitmap,Rect(Max(0,tmpX-1),Max(0,tmpY),
                           Min(FBitmap.Width-1, tmpX+tmpW),
                           Min(FBitmap.Height-1, tmpY+FCanvas.TextHeight(Text)-1))
                           );
      finally;
        Free;
      end;

      tmpDC:=FCanvas.Handle;

      BackMode:=cbmTransparent;

    end;

    {$ELSE}
    tmpColor:=FCanvas.Font.Color;
    FCanvas.Font.Color:=ColorToRGB(IFont.Shadow.Color);
    InternalTextOut(tmpX,tmpY);
    FCanvas.Font.Color:=tmpColor;
    {$ENDIF}

    if Transparency>0 then
       EndBlending(tmpBlend);
  end;

  {$IFDEF CLX}
  FCanvas.Font.Color:=ColorToRGB(FFont.Color);
  {$ELSE}
  SetTextColor(tmpDC, ColorToRGB(FFont.Color));
  {$ENDIF}

  {$IFDEF AXUNICODE}
  if Pos('@U#',Text)= 1 then
  Begin
    tmpWideString:=Unicoding.ConvertCPList2Char(Unicoding.ConvertUTF82CPList(Text))
  end
  else
    tmpWideString:=Unicoding.StringToWideString(Text,0);
  {$ENDIF}

  {$IFNDEF CLX}
  if Assigned(IFont) then // and IsTrueTypeFont then 5.03 (slow)
  begin
    with IFont do
    begin
      tmpFontOutLine:=Assigned(FOutline) and FOutLine.Visible;
      tmpFontGradient:=Assigned(FGradient) and FGradient.Visible;
      tmpFontPic:=Assigned(FPicture) and Assigned(FPicture.Graphic);
    end;

    if tmpFontOutLine or tmpFontGradient or tmpFontPic then
    begin
      if tmpFontOutLine then AssignVisiblePen(IFont.FOutLine)
                        else Pen.Style:=psClear;

      Brush.Color:=FFont.Color;
      Brush.Style:=bsSolid;

      tmpDC:=FCanvas.Handle;
      BackMode:=cbmTransparent;

      CreateFontPath;

      if tmpFontGradient then
      begin
        if IFont.FGradient.Outline then
           WidenPath(tmpDC);

        SelectClipPath(tmpDC,RGN_AND);

        IFont.FGradient.Draw(Self,RectText(x,y));
        UnClipRectangle;

        if IFont.FGradient.Outline then exit;

        // Create path again...
        if tmpFontOutLine then
        begin
          CreateFontPath;
          Brush.Style:=bsClear;
        end;
      end
      else
      if tmpFontPic then
      begin
        SelectClipPath(tmpDC,RGN_AND);
        StretchDraw(RectText(x,y),IFont.FPicture.Filtered);
        UnClipRectangle;

        // Create path again...
        if tmpFontOutLine then
        begin
          CreateFontPath;
          Brush.Style:=bsClear;
        end;
      end;

      if tmpFontOutLine then
         if IFont.Color=clNone then StrokePath(tmpDC)
                               else StrokeAndFillPath(tmpDC);

    end
    else DoTextOut(X,Y);
  end
  else DoTextOut(X,Y);

  {$ELSE}
  InternalTextOut(x,y);
  {$ENDIF}
end;

procedure TTeeCanvas3D.Rectangle(X0,Y0,X1,Y1:Integer);
begin
  {$IFNDEF CLX}
  {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.Rectangle(FCanvas.Handle,X0,Y0,X1,Y1);
  {$ELSE}
  FCanvas.Rectangle(X0,Y0,X1,Y1);
  {$ENDIF}
end;

procedure TTeeCanvas3D.RoundRect(X1,Y1,X2,Y2,X3,Y3:Integer);
begin
  {$IFNDEF CLX}
  {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.RoundRect(FCanvas.Handle,X1,Y1,X2,Y2,X3,Y3);
  {$ELSE}
  FCanvas.RoundRect(X1,Y1,X2,Y2,X3,Y3);
  {$ENDIF}
end;

procedure TTeeCanvas3D.SetTextAlign(Align:TCanvasTextAlign);
begin
  {$IFDEF CLX}
  FTextAlign:=Align;
  {$ELSE}
  {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.SetTextAlign(FCanvas.Handle,Ord(Align));
  {$ENDIF}
end;

procedure TTeeCanvas3D.MoveTo(X,Y:Integer);
begin
  {$IFNDEF CLX}
  {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.MoveToEx(FCanvas.Handle, X, Y, nil);
  {$ELSE}
  FCanvas.MoveTo(X,Y);
  {$ENDIF}
end;

procedure TTeeCanvas3D.LineTo(X,Y:Integer);
begin
  {$IFNDEF CLX}
  {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.LineTo(FCanvas.Handle, X, Y);
  {$ELSE}
  FCanvas.LineTo(X,Y);
  {$ENDIF}
end;

{ 3D Canvas }
Procedure TTeeCanvas3D.PolygonFour;
begin
  Polygon(IPoints);
end;

procedure TTeeCanvas3D.PlaneWithZ(P1,P2,P3,P4:TPoint; Z:Integer);
begin
  Calc3DTPoint(P1,Z);
  Calc3DTPoint(P2,Z);
  Calc3DTPoint(P3,Z);
  Calc3DTPoint(P4,Z);
  IPoints[0]:=P1;
  IPoints[1]:=P2;
  IPoints[2]:=P3;
  IPoints[3]:=P4;
  PolygonFour;
end;

Procedure TTeeCanvas3D.Calc3DTPoint(Var P:TPoint; z:Integer);
{$IFDEF CLR}
var x,y : Integer;
{$ENDIF}
begin
  {$IFDEF CLR}
  x:=P.X;
  y:=P.Y;
  Calc3DPos(x,y,Z);
  P.X:=x;
  P.Y:=y;
  {$ELSE}
  Calc3DPos(P.X,P.Y,Z);
  {$ENDIF}
end;

Function TTeeCanvas3D.Calc3DTPoint3D(Const P:TPoint3D):TPoint;
begin
  Calc3DPoint(result,P.X,P.Y,P.Z);
end;

Function TTeeCanvas3D.Calculate3DPosition(x,y,z:Integer):TPoint;
begin
  Calc3DPos(x,y,z);
  result.x:=x;
  result.y:=y;
end;

Procedure TTeeCanvas3D.Calc3DPoint( Var P:TPoint; x,y,z:Integer);
begin
  Calc3DPos(x,y,z);
  P.x:=x;
  P.y:=y;
end;

Procedure TTeeCanvas3D.Calculate2DPosition(Var x,y:Integer; z:Integer);
var x1  : Integer;
    tmp : Double;
begin
  if IZoomFactor<>0 then
  begin
    tmp:=1.0/IZoomFactor;

    if FIsOrthogonal then
    begin
      x:=Round(((x-XCenterOffset)*tmp)-(IOrthoX*z))+FXCenter;
      y:=Round(((y-YCenterOffset)*tmp)+(IOrthoY*z))+FYCenter;
    end
    else
    if FIs3D and (tempXX<>0) and (c2c3<>0)  then
    begin
      x1:=x;
      z:=z-FZCenter;

      x:=Round((((x1-XCenterOffset)*tmp)-(z*tempXZ)-
                 (y -FYCenter)*c2s3)   / tempXX) + FXCenter;
      y:=Round((((y -YCenterOffset)*tmp)-(z*tempYZ)-
                 (x1-FXCenter)*tempYX) / c2c3)   + FYCenter;
    end;
  end;
end;

// Floating-point version
Procedure TTeeCanvas3D.Calc3DPoint(Var P:TPoint; x,y:Double; z:Integer);
var tmp : Double;
    xx,yy,zz :  Double;
begin
  if FIsOrthogonal then
  begin
    P.X:=Round( IZoomFactor*(x-FXCenter+(IOrthoX*z)) )+XCenterOffset;
    P.Y:=Round( IZoomFactor*(y-FYCenter-(IOrthoY*z)) )+YCenterOffset;
  end
  else
  if FIs3D then
  begin
    Dec(z,FZCenter);
    x:=x-FXCenter;
    y:=y-FYCenter;

    zz:=z*c2 - x*s2;

    xx:=x*c2 + z*s2;
    yy:=y*c1 - zz*s1;

    if IHasPerspec then
       tmp:=IZoomFactor / ( 1+ IZoomPerspec * (zz*c1 + y*s1) )
    else
       tmp:=IZoomFactor;

    P.X:=Round((xx*c3 - yy*s3)*tmp)+XCenterOffset;
    P.Y:=Round((yy*c3 + xx*s3)*tmp)+YCenterOffset;
  end;
end;

// Integer version
Procedure TTeeCanvas3D.Calc3DPos(Var x,y:Integer; z:Integer);
var tmp : Double;
    xx,yy,zz : Double;
begin
  if FIsOrthogonal then
  begin
    x:=Round( IZoomFactor*(x-FXCenter+(IOrthoX*z)) )+XCenterOffset;
    y:=Round( IZoomFactor*(y-FYCenter-(IOrthoY*z)) )+YCenterOffset;
  end
  else
  if FIs3D then
  begin
    Dec(z,FZCenter);
    Dec(x,FXCenter);
    Dec(y,FYCenter);

    zz:=z*c2 - x*s2;

    if IHasPerspec then
       tmp:=IZoomFactor / ( 1+ IZoomPerspec * (zz*c1 + y*s1) )
    else
       tmp:=IZoomFactor;

    if IHasTilt then
    begin
      xx:=x*c2 + z*s2;
      yy:=y*c1 - zz*s1;

      x:=Round((xx*c3 - yy*s3)*tmp)+XCenterOffset;
      y:=Round((yy*c3 + xx*s3)*tmp)+YCenterOffset;
    end
    else
    begin
      x:=Round((x*c2 +  z*s2)*tmp)+XCenterOffset;
      y:=Round((y*c1 - zz*s1)*tmp)+YCenterOffset;
    end;
  end;
end;

Function TTeeCanvas3D.GetHandle:TTeeCanvasHandle;
begin
  result:=FCanvas.Handle;
end;

procedure TTeeCanvas3D.Cone(Vertical:Boolean; Left,Top,Right,Bottom,
                          Z0,Z1:Integer; Dark3D:Boolean; ConePercent:Integer);
begin
  InternalCylinder(Vertical,Left,Top,Right,Bottom,Z0,Z1,Dark3D,ConePercent);
end;

procedure TTeeCanvas3D.Sphere(x,y,z:Integer; Const Radius:Double);
var tmp : Integer;
begin
  tmp:=Round(Radius);
  EllipseWithZ(x-tmp,y-tmp,x+tmp,y+tmp,z);
end;

Procedure TTeeCanvas3D.Surface3D( Style:TTeeCanvasSurfaceStyle;
                                  SameBrush:Boolean;
                                  NumXValues,NumZValues:Integer;
                                  CalcPoints:TTeeCanvasCalcPoints );
begin
  { not implemented in GDI mode. (Use TeeOpenGL) }
end;

Procedure TTeeCanvas3D.TextOut3D(x,y,z:Integer; const Text:String);
var {$IFNDEF CLX}
    tmpSizeChanged : Boolean;
    FDC            : HDC;
    LogRec         : TLogFont;
    NewFont        : HFont;
    OldFont        : HFont;
    {$ENDIF}
    tmp            : Integer;
    OldSize        : Integer;
begin
  Calc3DPos(x,y,z);

  if IZoomText then
  begin
    {$IFNDEF CLX}
    tmpSizeChanged:=False;
    FDC:=0;
    OldFont:=0;
    {$ENDIF}

    if IZoomFactor<>1 then
    With FFont do
    begin
      OldSize:=Size;
      tmp:=Math.Max(1,Round(IZoomFactor*OldSize));

      if OldSize<>tmp then
      begin
        {$IFDEF CLX}
        FFont.Size:=tmp;
        {$ELSE}
        FDC:=FCanvas.Handle;

        {$IFDEF CLR}
        GetObject(FFont.Handle, Marshal.SizeOf(TypeOf(TLogFont)), LogRec);
        {$ELSE}
        GetObject(FFont.Handle, SizeOf(LogRec), @LogRec);
        {$ENDIF}

        LogRec.lfHeight:= -MulDiv( tmp,FFont.PixelsPerInch,72);
        // Extra weights: LogRec.lfWeight:=FW_THIN;

        NewFont:=CreateFontIndirect({$IFDEF LCL}@{$ENDIF}LogRec);
        OldFont:=SelectObject(FDC,NewFont);
        tmpSizeChanged:=True;
        {$ENDIF}
      end;
    end;

    TextOut(X,Y,Text);

    {$IFNDEF CLX}
    if tmpSizeChanged then
       DeleteObject(SelectObject(FDC,OldFont));
    {$ENDIF}
  end
  else TextOut(X,Y,Text);
end;

Procedure TTeeCanvas3D.RectangleWithZ(Const Rect:TRect; Z:Integer);
begin
  With Rect do
  begin
    Calc3DPoint(IPoints[0],Left,Top,Z);
    Calc3DPoint(IPoints[1],Right,Top,Z);
    Calc3DPoint(IPoints[2],Right,Bottom,Z);
    Calc3DPoint(IPoints[3],Left,Bottom,Z);
  end;

  PolygonFour;
end;

{$IFNDEF CLX}
Procedure SetCanvasRegion(DC:TTeeCanvasHandle; Region:HRgn; Mode:Integer=RGN_AND);
begin
  if Region<>0 then
  begin
    WasOldRegion:=GetClipRgn(DC,OldRegion)=1;
    ExtSelectClipRgn(DC,Region,Mode);
    DeleteObject(Region);
  end;
end;
{$ENDIF}

Procedure ClipCanvas(ACanvas:TCanvas; Const Rect:TRect);
var tmpDC  : TTeeCanvasHandle;
    {$IFNDEF CLX}
    P      : Array[0..1] of TPoint;
    Region : HRgn;
    {$ENDIF}
begin
  {$IFNDEF CLX}
  with Rect do
  begin
    p[0]:=TopLeft;
    p[1]:=BottomRight;
  end;
  tmpDC:=ACanvas.Handle;
  LPToDP(tmpDC,P,2);
  Region:=CreateRectRgn(P[0].X,P[0].Y,P[1].X,P[1].Y);
  SetCanvasRegion(tmpDC,Region);
  {$ELSE}
  ACanvas.Start;
  tmpDC:=ACanvas.Handle;
  QPainter_setClipping(tmpDC,True);
  QPainter_setClipRect(tmpDC,@Rect);
  {$ENDIF}
end;

procedure TTeeCanvas3D.ClipRectangle(Const Rect:TRect);
begin
  ClipCanvas(FCanvas,Rect);
end;

Procedure TTeeCanvas.ClipPolygon(const Points:Array of TPoint; NumPoints:Integer;
                                 DiffRegion:Boolean=False);

{$IFNDEF CLX}
type
  PPointArray=^TPointArray;
{$ENDIF}

  {$IFDEF CLR}
  {$UNSAFECODE ON}
  {$ENDIF}

  function PointArrayOf(const Points: array of TPoint; var TempPoints: TPointArray): PPointArray; {$IFDEF CLR}unsafe;{$ENDIF}
  var t:Integer;
  begin
    SetLength(TempPoints, NumPoints);
    for t:=0 to NumPoints-1 do TempPoints[t]:=Points[t];
    Result := @TempPoints[0];
  end;

  {$IFDEF CLR}
  {$UNSAFECODE OFF}
  {$ENDIF}

var {$IFDEF CLX}
    Region : QRegionH;
    P      : TPointArray;
    {$ELSE}
    Region : HRgn;
    tmpMap : Integer;
    tmpPoints : TPointArray;
    {$ENDIF}

    tmpDC  : TTeeCanvasHandle;
begin
  {$IFDEF CLX}
  ReferenceCanvas.Start;
  tmpDC:=ReferenceCanvas.Handle;
  QPainter_setClipping(tmpDC,True);
  Region:=QRegion_create(PointArrayOf(Points,P),False);
  QPainter_setClipRegion(tmpDC,Region);
  QRegion_Destroy(Region);

  {$ELSE}

  tmpDC:=Handle;

  tmpMap:=GetMapMode(tmpDC);

  if tmpMap<>MM_TEXT then
  begin
    PointArrayOf(Points,tmpPoints);

    LPToDP(tmpDC,tmpPoints,NumPoints);
    Region:=CreatePolygonRgn(tmpPoints,NumPoints,ALTERNATE);

    tmpPoints:=nil;
  end
  else
    Region:=CreatePolygonRgn(Points,NumPoints,ALTERNATE);

  if DiffRegion then
     SetCanvasRegion(tmpDC,Region,RGN_DIFF)
  else
     SetCanvasRegion(tmpDC,Region);

  {$ENDIF}
end;

Procedure ClipEllipse(ACanvas:TTeeCanvas; Const Rect:TRect); {$IFDEF D10}inline;{$ENDIF}
begin
  ACanvas.ClipEllipse(Rect);
end;

Procedure TTeeCanvas.ClipEllipse(Const Rect:TRect; Inverted:Boolean=False);
var DC : TTeeCanvasHandle;
{$IFNDEF CLX}
    R  : TRect;
    tmpReg : HRgn;
{$ELSE}
    tmpRegion : QRegionH;
{$ENDIF}
begin
  {$IFNDEF CLX}
  DC:=Handle;
  R:=Rect;

  {$IFNDEF CLR}
  LPToDP(DC,R,2);
  {$ENDIF}

  if Inverted then
  begin
    {$IFDEF LCL}
    tmpReg:=0;  // Lazarus bug?
    {$ELSE}
    tmpReg:=CreateEllipticRgnIndirect(Rect);
    {$ENDIF}

    ExtSelectClipRgn(Handle,tmpReg,RGN_XOR);
    DeleteObject(tmpReg);
  end
  else SetCanvasRegion(DC,CreateEllipticRgnIndirect(R));

  {$ELSE}
  ReferenceCanvas.Start;
  DC:=Handle;
  QPainter_setClipping(DC,True);
  tmpRegion:=QRegion_create(@Rect, QRegionRegionType_Ellipse);
  QPainter_setClipRegion(DC,tmpRegion);
  QRegion_destroy(tmpRegion);
  {$ENDIF}
end;

// Obsolete
Procedure ClipRoundRectangle(ACanvas:TTeeCanvas; Const Rect:TRect; RoundSize:Integer); {$IFDEF D10}inline;{$ENDIF}
begin
  ACanvas.ClipRectangle(Rect,RoundSize);
end;

Procedure TTeeCanvas.ClipRectangle(Const Rect:TRect; RoundSize:Integer);
{$IFNDEF CLX}
var R      : TRect;
    Region : HRgn;
    DC     : HDC;
{$ENDIF}
begin
  {$IFNDEF CLX}
  DC:=Handle;
  R:=Rect;

  {$IFNDEF CLR}
  LPToDP(DC,R,2);
  {$ENDIF}

  with R do
       Region:=CreateRoundRectRgn(Left,Top,Right,Bottom,RoundSize,RoundSize);

  SetCanvasRegion(DC,Region);

  {$ELSE}
  ClipRectangle(Rect);
  {$ENDIF}
end;

// Obsolete
Procedure ClipPolygon(ACanvas:TTeeCanvas; const Points:Array of TPoint; NumPoints:Integer);
begin
  ACanvas.ClipPolygon(Points,NumPoints);
end;

Function RectFromPolygon(Const Points:Array of TPoint; NumPoints:Integer):TRect;
var t : Integer;
begin
  result.TopLeft:=Points[0];
  result.BottomRight:=result.TopLeft;

  for t:=1 to NumPoints-1 do
  With Points[t] do
  begin
    if X<result.Left then result.Left:=X else
       if X>result.Right then result.Right:=X;
    if Y<result.Top then result.Top:=Y else
       if Y>result.Bottom then result.Bottom:=Y;
  end;

  Inc(result.Right);
  Inc(result.Bottom);
end;

Function RectFromTriangle(Const Points:TTrianglePoints):TRect;
begin
  result:=RectFromPolygon(Points,3);
end;

function RectangleInRectangle(const Small,Big:TRect):Boolean;
begin
  result:=PointInRect(Big,Small.TopLeft) and PointInRect(Big,Small.BottomRight);
end;

// Returns the boundary points of the convex hull of a set of 2D xy points.
// Overwrites the input array.
// Written by Peter Bone : peterbone@hotmail.com
function TTeeCanvas.ConvexHull(var Points : TPointArray) : Boolean;

  // sort an array of points by angle
  procedure QuickSortAngle(var A: TPointArray; var Angles : Array of Single; iLo, iHi: Integer);
  var
    Lo, Hi : Integer;
    Mid : Single;
    TempPoint : TPoint;
    TempAngle : Single;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := Angles[(Lo + Hi) div 2];
    repeat
      while Angles[Lo] < Mid do Inc(Lo);
      while Angles[Hi] > Mid do Dec(Hi);

      if Lo <= Hi then
      begin
        // swap points
        TempPoint := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := TempPoint;

        // swap angles
        TempAngle := Angles[Lo];
        Angles[Lo] := Angles[Hi];
        Angles[Hi] := TempAngle;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;

    // perform quicksorts on subsections
    if Hi > iLo then QuickSortAngle(A, Angles, iLo, Hi);
    if Lo < iHi then QuickSortAngle(A, Angles, Lo, iHi);
  end;

var
  LAngles : Array of Single;
  Lindex,
  LMinY,
  LMaxX,
  tmpHigh,
  LPivotIndex : integer;
  LPivot : TPoint;
  LBehind, LInfront : TPoint;
  LRightTurn : Boolean;
  LVecPoint : {$IFDEF LINUX}TPoint{$ELSE}TPointFloat{$ENDIF};
  tmp : Double;
  
  {$IFDEF CLR}
  t : Integer;
  {$ENDIF}
begin
  Result:=True;

  if Length(Points) = 3 then Exit // already a convex hull
  else
  if Length(Points) < 3 then
  begin // not enough points
    Result := False;
    Exit;
  end;

  // find pivot point, which is known to be on the hull
  // point with lowest y - if there are multiple, point with highest x
  LMinY := 10000000;
  LMaxX := 10000000;
  LPivotIndex := 0;

  for Lindex := Low(Points) to High(Points) do
    if Points[Lindex].Y = LMinY then
    begin
      if Points[Lindex].X > LMaxX then
      begin
        LMaxX := Points[Lindex].X;
        LPivotIndex := Lindex;
      end;
    end
    else
    if Points[Lindex].Y < LMinY then
    begin
      LMinY := Points[Lindex].Y;
      LMaxX := Points[Lindex].X;
      LPivotIndex := Lindex;
    end;

  // put pivot into seperate variable and remove from array
  LPivot := Points[LPivotIndex];
  Points[LPivotIndex] := Points[High(Points)];
  SetLength(Points, High(Points));

  // calculate angle to pivot for each point in the array
  // quicker to calculate dot product of point with a horizontal comparison vector
  SetLength(LAngles, Length(Points));
  for Lindex := Low(Points) to High(Points) do
  begin
    LVecPoint.X := LPivot.X - Points[Lindex].X; // point vector
    LVecPoint.Y := LPivot.Y - Points[Lindex].Y;

    // reduce to a unit-vector - length 1
    tmp:=Hypot(LVecPoint.X, LVecPoint.Y);

    if tmp=0 then LAngles[Lindex]:=0
             else LAngles[Lindex] := LVecPoint.X / tmp;
  end;

  // sort the points by angle
  QuickSortAngle(Points, LAngles, Low(Points), High(Points));

  // step through array to remove points that are not part of the convex hull
  Lindex := 1;
  Repeat

    // assign points behind and infront of current point
    if Lindex = 0 then LRightTurn := True
    else
    begin
      LBehind := Points[Lindex-1];
      if Lindex = High(Points) then LInfront := LPivot
                               else LInfront := Points[Lindex + 1];

      // work out if we are making a right or left turn using vector product
      LRightTurn:= ((LBehind.X-Points[Lindex].X)*(LInfront.Y-Points[Lindex].Y))-
                   ((LInfront.X-Points[Lindex].X)*(LBehind.Y-Points[Lindex].Y)) < 0;
    end;

    if LRightTurn then Inc(Lindex) // go to next point
    else
    begin // point is not part of the hull

      tmpHigh:=High(Points);

      // remove point from convex hull
      if Lindex = tmpHigh then
         SetLength(Points, tmpHigh)
      else
      begin
        {$IFDEF CLR}
        for t:=Lindex to tmpHigh-1 do
            Points[t]:=Points[t+1];
        {$ELSE}
        System.Move(Points[Lindex + 1], Points[Lindex], (tmpHigh - Lindex) * SizeOf(TPoint) );
        {$ENDIF}

        SetLength(Points, tmpHigh);
      end;

      Dec(Lindex); // backtrack to previous point
    end;
  until Lindex = High(Points);

  // add pivot back into points array
  SetLength(Points, Length(Points) + 1);
  Points[High(Points)] := LPivot;
end;

procedure TTeeCanvas3D.ClipCube(Const Rect:TRect; MinZ,MaxZ:Integer);
var tmpR : TRect;
    P    : TPointArray;
begin
  if FIs3D then
  begin
    SetLength(P,8);
    with Rect do
    begin
      Calc3DPoint(p[0],Left,Bottom,MinZ);
      Calc3DPoint(p[1],Left,Bottom,MaxZ);
      Calc3DPoint(p[2],Left,Top,MaxZ);
      Calc3DPoint(p[3],Right,Top,MaxZ);
      Calc3DPoint(p[4],Right,Top,MinZ);
      Calc3DPoint(p[5],Right,Bottom,MinZ);
      Calc3DPoint(p[6],Left,Top,MinZ);
      Calc3DPoint(p[7],Right,Bottom,MaxZ);
    end;

    ConvexHull(P);
    ClipPolygon(P,Length(P));
    P:=nil;
  end
  else
  begin
    tmpR:=Rect;
    Inc(tmpR.Left);
    Inc(tmpR.Top);
    Dec(tmpR.Bottom);
    ClipRectangle(tmpR);
  end;
end;

Procedure UnClipCanvas(ACanvas:TCanvas);
begin
  {$IFNDEF CLX}
  if WasOldRegion then SelectClipRgn(ACanvas.Handle,OldRegion)
                  else SelectClipRgn(ACanvas.Handle,0);
  WasOldRegion:=False;
  {$ELSE}
  QPainter_setClipping(ACanvas.Handle,False);
  ACanvas.Stop;
  {$ENDIF}
end;

procedure TTeeCanvas3D.UnClipRectangle;
begin
  UnClipCanvas(FCanvas);
end;

Const PerspecFactor=1.0/150.0;

Procedure TTeeCanvas3D.Projection(MaxDepth:Integer; const ABounds,Rect:TRect);
begin
  RectCenter(Rect,FXCenter,FYCenter);
  Inc(FXCenter,Round(RotationCenter.X));
  Inc(FYCenter,Round(RotationCenter.Y));
  FZCenter:=Round( (MaxDepth*0.5) + RotationCenter.Z );
  XCenterOffset:=FXCenter;
  YCenterOffset:=FYCenter;

  if Assigned(F3DOptions) then
  With F3DOptions do
  begin
    Inc(XCenterOffset,HorizOffset);
    Inc(YCenterOffset,VertOffset);
    CalcPerspective(Rect);
  end;
end;

Procedure TTeeCanvas3D.CalcPerspective(const Rect:TRect);
var tmp : Integer;
begin
  IHasPerspec:=F3DOptions.Perspective>0;

  if IHasPerspec then
  begin
    tmp:=Rect.Right-Rect.Left;
    if tmp<1 then tmp:=1;

    IZoomPerspec:=IZoomFactor*F3DOptions.Perspective*PerspecFactor/tmp;
  end;
end;

Procedure TTeeCanvas3D.CalcTrigValues;
Var rx : Double;
    ry : Double;
    rz : Double;
begin
  if not FIsOrthogonal then
  begin
    if Assigned(F3DOptions) then
    With F3DOptions do
    begin
      rx:=-FElevation;
      ry:=-FRotation;
      rz:=Tilt;
    end
    else
    begin
      rx:=0;
      ry:=0;
      rz:=0;
    end;

    IHasPerspec:=False;
    IZoomPerspec:=0;

    SinCos(rx*TeePiStep,s1,c1);
    SinCos(ry*TeePiStep,s2,c2);

    IHasTilt:=rz<>0;

    SinCos(rz*TeePiStep,s3,c3);

    c2s3:=c2*s3;
    c2c3:=Math.Max(1E-5,c2*c3);

    tempXX:=Math.Max(1E-5, s1*s2*s3 + c1*c3 );
    tempYX:=( c3*s1*s2 - c1*s3 );

    tempXZ:=( c1*s2*s3 - c3*s1 );
    tempYZ:=( c1*c3*s2 + s1*s3 );
  end;
end;

Function TTeeCanvas3D.InitWindow( DestCanvas:TCanvas;
                                  A3DOptions:TView3DOptions;
                                  ABackColor:TColor;
                                  Is3D:Boolean;
                                  Const UserRect:TRect):TRect;
var tmpH      : Integer;
    tmpW      : Integer;
    tmpCanvas : TCanvas;
    tmpSin    : Extended;
    tmpCos    : Extended;
    tmpAngle  : Extended;
begin
  FBounds:=UserRect;
  F3DOptions:=A3DOptions;

  if Assigned(F3DOptions) then
     FontZoom:=F3DOptions.FontZoom;

  FIs3D:=Is3D;
  FIsOrthogonal:=False;
  IZoomFactor:=1;

  if FIs3D then
  begin
    if Assigned(F3DOptions) then
    begin
      FIsOrthogonal:=F3DOptions.Orthogonal;
      if FIsOrthogonal then
      begin
        tmpAngle:=F3DOptions.OrthoAngle;
        if tmpAngle>90 then
        begin
          IOrthoX:=-1;
          tmpAngle:=180-tmpAngle;
        end
        else IOrthoX:=1;

        SinCos(tmpAngle*TeePiStep,tmpSin,tmpCos);
        if tmpCos<0.01 then IOrthoY:=1
                       else IOrthoY:=tmpSin/tmpCos;
      end;

      IZoomFactor:=0.01*F3DOptions.Zoom;

      IZoomText:=F3DOptions.ZoomText;
    end;

    CalcTrigValues;
  end;

  if FBufferedDisplay then
  begin
    RectSize(UserRect,tmpW,tmpH);

    if not Assigned(FBitmap) then
    begin
      FBitmap:=TBitmap.Create;
      {$IFDEF IGNOREPALETTE}
      FBitmap.IgnorePalette:=True;
      {$ENDIF}
    end;

    TeeSetBitmapSize(FBitmap,tmpW+1,tmpH+1);

    tmpCanvas:=FBitmap.Canvas;

    {$IFNDEF CLX}  // 7.01  Qt does not refresh when resizing.
    tmpCanvas.OnChange:=nil;
    tmpCanvas.OnChanging:=nil;
    {$ENDIF}

    SetCanvas(tmpCanvas);
    result:=TeeRect(0,0,tmpW,tmpH);
  end
  else
  begin
    SetCanvas(DestCanvas);
    result:=UserRect;
  end;
end;

{.$DEFINE MONITOR_REPAINTS}

{$IFDEF MONITOR_REPAINTS}
var TeeMonitor:Integer=0;
{$ENDIF}

Procedure TTeeCanvas3D.TransferBitmap(ALeft,ATop:Integer; ACanvas:TCanvas);
begin
  {$IFNDEF CLX}

    {$IFDEF MONITOR_REPAINTS}
    Inc(TeeMonitor);
    FBitmap.Canvas.TextOut(0,0,IntToStr(TeeMonitor));
    {$ENDIF}

  {$IFDEF TEEBITMAPSPEED}
  if IBitmapCanvas=0 then
  begin
    IBitmapCanvas:=CreateCompatibleDC(0);
    SelectObject(IBitmapCanvas, FBitmap.Handle);
  end;

  BitBlt( ACanvas.Handle,ALeft,ATop,
          FBitmap.Width,
          FBitmap.Height,
          IBitmapCanvas,0,0,SRCCOPY);
  {$ELSE}
  BitBlt( ACanvas.Handle,ALeft,ATop,
          FBitmap.Width,
          FBitmap.Height,
          FBitmap.Canvas.Handle,0,0,SRCCOPY);
  {$ENDIF}

  {$ELSE}
  QPainter_drawPixmap(ACanvas.Handle, ALeft, ATop, FBitmap.Handle, 0, 0,
    FBitmap.Width, FBitmap.Height);
  {$ENDIF}
end;

Function TTeeCanvas3D.ReDrawBitmap:Boolean;
begin
  result:=not FDirty;
  if result then
     TransferBitmap(0,0,FCanvas)
  {$IFDEF TEEBITMAPSPEED}
  else
  begin
    DeleteDC(IBitmapCanvas);
    IBitmapCanvas:=0;
  end;
  {$ENDIF}
end;

Procedure TTeeCanvas3D.ShowImage(DestCanvas,DefaultCanvas:TCanvas; Const UserRect:TRect);
begin
  if FBufferedDisplay and Assigned(FBitmap) then
  begin
    With UserRect do TransferBitmap(Left,Top,DestCanvas);
    FDirty:=False;
  end;

  SetCanvas(DefaultCanvas);
end;

procedure TTeeCanvas3D.StretchDraw(const Rect: TRect; Graphic: TGraphic);
begin
  {$IFNDEF CLX}
  if Assigned(Graphic) then
  {$ENDIF}
     FCanvas.StretchDraw(Rect,Graphic);
end;

procedure TTeeCanvas3D.Draw(X, Y: Integer; Graphic: TGraphic);
begin
  {$IFNDEF CLX}
  if Assigned(Graphic) and (not Graphic.Empty) then
  {$ENDIF}
     FCanvas.Draw(x,y,Graphic);
end;

{$IFDEF LINUX}
Function GetRValue(Color:Integer):Byte;
var QC : QColorH;
begin
  QC:=QColor(Color);
  try    result:=QColor_red(QC);  finally    QColor_destroy(QC);  end;
end;

Function GetGValue(Color:Integer):Byte;
var QC : QColorH;
begin
  QC:=QColor(Color);
  try    result:=QColor_green(QC);  finally    QColor_destroy(QC);  end;
end;

Function GetBValue(Color:Integer):Byte;
var QC : QColorH;
begin
  QC:=QColor(Color);
  try    result:=QColor_blue(QC);  finally    QColor_destroy(QC);  end;
end;

Function QRGB(r,g,b:Integer):QColorH;
begin
  result:=QColor_create(r,g,b);
end;

Function RGB(r,g,b:Integer):TColor;
begin
  result:=QColorColor(QRGB(r,g,b))
end;
{$ENDIF}

// For gradient balance
Function TeeSigmoid(const Index,Balance,Total:Double):Double;
const Divisor:Double=1/(200/3);
begin
  result:=Exp((0.5+(Balance*Divisor))*Ln((1+Index)/(1+Total)));
end;

Procedure TTeeCanvas3D.GradientFill( Const Rect : TRect;
                                     StartColor : TColor;
                                     EndColor   : TColor;
                                     Direction  : TGradientDirection;
                                     Balance    : Integer=50);
Var T0,T1,T2 : Integer;
    D0,D1,D2 : Integer;
    Range    : Integer;
    FDC      : TTeeCanvasHandle;
    {$IFDEF CLX}
    tmpBrush : QBrushH;
    {$ELSE}
    tmpBrush : HBRUSH;
    OldColor : TColor;
    {$ENDIF}

  Function CalcColor(Index:Integer):TColor;
  var tmpD : Double;
  begin
    {$IFDEF CLX}
    if Balance=50 then
      result:=QColorColor(QColor_create( (T0 + MulDiv(Index,D0,Range)),
                             (T1 + MulDiv(Index,D1,Range)),
                             (T2 + MulDiv(Index,D2,Range)) ))
    else
    begin
      tmpD:=TeeSigmoid(Index,Balance,Range);

      result:=QColorColor(QColor_create( T0 + Round(tmpD*D0),
                             T1 + Round(tmpD*D1),
                             T2 + Round(tmpD*D2) ));
    end;
    {$ELSE}

    if Balance=50 then
       result:=(( T0 + ((Index*D0) div Range) ) or
               (( T1 + ((Index*D1) div Range) ) shl 8) or
               (( T2 + ((Index*D2) div Range) ) shl 16))
    else
    begin
      tmpD:=TeeSigmoid(Index,Balance,Range);

      result:=(( T0 + Round(tmpD*D0) ) or
              (( T1 + Round(tmpD*D1) ) shl 8) or
              (( T2 + Round(tmpD*D2) ) shl 16));
    end;
    {$ENDIF}
  end;

{$IFNDEF CLX}
var tmpFastBrush : Boolean;
{$ENDIF}

  procedure CheckFastBrush;
  begin
    FDC:=FCanvas.Handle;

    {$IFNDEF CLX}
    tmpFastBrush:=Assigned(@TeeSetDCBrushColor);
    if tmpFastBrush then
       tmpBrush:=SelectObject(FDC,GetStockObject(DC_BRUSH));
    {$ENDIF}
  end;

  Procedure CalcBrushColor(Index:Integer);
  var tmp : {$IFDEF CLX}QColorH{$ELSE}TColor{$ENDIF};
  begin
    tmp:={$IFDEF CLX}QColor{$ENDIF}(CalcColor(Index));

    {$IFDEF CLX}
    QBrush_setColor(tmpBrush,tmp);
    QColor_destroy(tmp);
    {$ELSE}

    if tmp<>OldColor then
    begin
      if tmpFastBrush then
         TeeSetDCBrushColor(FDC,tmp)
      else
      begin
        if tmpBrush<>0 then
           DeleteObject(SelectObject(FDC,tmpBrush)); // <-- Win API is very slow here !
        tmpBrush:=SelectObject(FDC,CreateSolidBrush(tmp));
      end;

      OldColor:=tmp;
    end;
    {$ENDIF}
  end;

Var tmpRect : TRect;

  {$IFDEF CLX}
  Procedure PatBlt(AHandle:TTeeCanvasHandle; A,B,C,D,Mode:Integer);
  begin
    QPainter_fillRect(AHandle, A,B,C,D, tmpBrush);
  end;
  {$ENDIF}

  Procedure RectGradient(Horizontal:Boolean);
  var t,
      P1,
      P2,
      P3    : Integer;
      Size  : Integer;
      Steps : Integer;
  begin
    With tmpRect do
    begin
      if Horizontal then
      begin
        P3:=Bottom-Top;
        Size:=Right-Left;
      end
      else
      begin
        P3:=Right-Left;
        Size:=Bottom-Top;
      end;

      Steps:=Size;
      if Steps>256 then Steps:=256;
      P1:=0;
      {$IFNDEF CLX}
      OldColor:=-1;
      {$ENDIF}
      Range:=Pred(Steps);

      if Range>0 then
      begin
        CheckFastBrush;

        for t:=0 to Steps-1 do
        Begin
          CalcBrushColor(t);
          P2:=(t+1)*Size div Steps;
          if Horizontal then PatBlt(FDC,Right-P1,Top,P1-P2,P3,PATCOPY)
                        else PatBlt(FDC,Left,Bottom-P1,P3,P1-P2,PATCOPY);
          P1:=P2;
        end;
      end;
    end;
  end;

  Procedure FromCorner;
  var FromTop : Boolean;
      SizeX,
      SizeY,
      tmp1,
      tmp2,
      P0,
      P1      : Integer;
  begin
    FromTop:=Direction=gdFromTopLeft;

    With tmpRect do if FromTop then P1:=Top else P1:=Bottom;

    P0:=P1;
    RectSize(tmpRect,SizeX,SizeY);
    Range:=Max(1,SizeX+SizeY);
    tmp1:=0;
    tmp2:=0;

    CheckFastBrush;

    Repeat
      CalcBrushColor(tmp1+tmp2);
      PatBlt(FDC,tmpRect.Left+tmp2,P0,1,P1-P0,PATCOPY);

      if tmp1<SizeY then
      begin
        Inc(tmp1);
        if FromTop then
        begin
          PatBlt(FDC,tmpRect.Left,P0,tmp2+1,1,PATCOPY);
          if P0<tmpRect.Bottom then Inc(P0)
        end
        else
        begin
          PatBlt(FDC,tmpRect.Left,P0-1,tmp2+1,1,PATCOPY);
          if P0>tmpRect.Top then Dec(P0);
        end;
      end;
      if tmp2<SizeX then Inc(tmp2);
    Until (tmp1>=SizeY) and (tmp2>=SizeX);
  end;

  Procedure FromCenter;
  Const TeeGradientPrecision : Integer = 1;   { how many pixels precision, ( 1=best) }
  var tmpXCenter,
      tmpYCenter,
      SizeX,
      SizeY,
      P0,
      P1,
      tmpLeft,
      tmpTop,
      tmp1,
      tmp2        : Integer;
  begin
    RectSize(tmpRect,SizeX,SizeY);
    tmpXCenter:=SizeX shr 1;
    tmpYCenter:=SizeY shr 1;
    tmp1:=0;
    tmp2:=0;
    Range:=Max(1,tmpXCenter+tmpYCenter);

    CheckFastBrush;

    Repeat
      CalcBrushColor(tmp1+tmp2);
      P0:=SizeY-(2*tmp1);
      P1:=SizeX-(2*tmp2);
      tmpLeft:=tmpRect.Left+tmp2;
      tmpTop:=tmpRect.Top+tmp1;
      PatBlt(FDC,tmpLeft,tmpTop,TeeGradientPrecision,P0,PATCOPY);
      PatBlt(FDC,tmpRect.Right-tmp2-1,tmpTop,TeeGradientPrecision,P0,PATCOPY);
      PatBlt(FDC,tmpLeft,tmpTop,P1,TeeGradientPrecision,PATCOPY);
      PatBlt(FDC,tmpLeft,tmpRect.Bottom-tmp1-TeeGradientPrecision,
                P1,TeeGradientPrecision,PATCOPY);
      if tmp1<tmpYCenter then Inc(tmp1,TeeGradientPrecision);
      if tmp2<tmpXCenter then Inc(tmp2,TeeGradientPrecision);
    Until (tmp1>=tmpYCenter) and (tmp2>=tmpXCenter);
  end;

  Procedure DoDrawRadial;
  var tmp : TCustomTeeGradient;
  begin
    tmp:=TCustomTeeGradient.Create(nil);
    try
      tmp.Direction:=gdRadial;
      tmp.StartColor:=StartColor;
      tmp.EndColor:=EndColor;
      tmp.DrawRadial(Self,tmpRect);
    finally
      tmp.Free;
    end;
  end;

  procedure DiagonalGradient(Up:Boolean);  // 7.0
  var tmpFrom,
      tmpTo    : TPoint;
      tmpSize  : Integer;
      Steps    : Integer;
      SizeX,
      SizeY    : Integer;
      t        : Integer;
      tmpPen   : TPen;
  begin
    if Up then
       tmpFrom:=TeePoint(tmpRect.Left,tmpRect.Bottom)
    else
    begin
      tmpFrom:=tmpRect.TopLeft;
      Dec(tmpRect.Bottom); // 7.07
    end;

    tmpTo:=tmpFrom;
    RectSize(tmpRect,SizeX,SizeY);
    tmpSize:=Max(SizeX,SizeY)+Min(SizeX,SizeY);

    Steps:=Pred(tmpSize);
    Range:=Max(1,Min(255,Steps));

    tmpPen:=TPen.Create;
    try
      tmpPen.Assign(Pen);

      Pen.Width:=1;
      Pen.Style:=psSolid;
      Pen.Mode:=pmCopy;

      for t:=0 to tmpSize-1 do
      begin
        // VCL.Net bug.
        // Setting Pen.Color many times leaves Canvas out of resources
        Pen.Color:=CalcColor(t*Range div tmpSize);

        Line(tmpFrom,tmpTo);

        if not Up then
        begin
          if tmpTo.X<tmpRect.Right then Inc(tmpTo.X)
          else
          if tmpTo.Y<tmpRect.Bottom then Inc(tmpTo.Y);

          if tmpFrom.Y<tmpRect.Bottom then Inc(tmpFrom.Y)
          else
          if tmpFrom.X<tmpRect.Right then Inc(tmpFrom.X)
        end
        else
        begin
          if tmpTo.X<tmpRect.Right then Inc(tmpTo.X)
          else
          if tmpTo.Y>tmpRect.Top then Dec(tmpTo.Y);

          if tmpFrom.Y>tmpRect.Top then Dec(tmpFrom.Y)
          else
          if tmpFrom.X<tmpRect.Right then Inc(tmpFrom.X)
        end;
      end;

      Pen.Assign(tmpPen);
    finally
      tmpPen.Free;
    end;
  end;

{$IFDEF CLR}
var tmpColor : TColor;
{$ENDIF}
begin
  tmpRect:=OrientRectangle(Rect);

  // deprecated. Use TTeeGradient.Draw method.
  if Direction=gdRadial then
  begin
    DoDrawRadial;
    exit;
  end;

  if (Direction<>gdTopBottom) and (Direction<>gdLeftRight) and
     (Direction<>gdDiagonalUp) and (Direction<>gdDiagonalDown) then
  {$IFDEF CLR}
  begin
    tmpColor:=StartColor;
    StartColor:=EndColor;
    EndColor:=tmpColor;
  end;
  {$ELSE}
  SwapInteger(Integer(StartColor),Integer(EndColor));
  {$ENDIF}

  StartColor:=ColorToRGB(StartColor);
  EndColor:=ColorToRGB(EndColor);

  T0:=GetRValue(StartColor);
  T1:=GetGValue(StartColor);
  T2:=GetBValue(StartColor);
  D0:=GetRValue(EndColor)-T0;
  D1:=GetGValue(EndColor)-T1;
  D2:=GetBValue(EndColor)-T2;

  {$IFDEF CLX}
  FCanvas.Start;
  tmpBrush:=FCanvas.Brush.Handle;
  {$ELSE}
  tmpBrush:=0;
  OldColor:=-1;
  {$ENDIF}

  Case Direction of
    gdLeftRight,
    gdRightLeft      : RectGradient(True);
    gdTopBottom,
    gdBottomTop      : RectGradient(False);
    gdFromTopLeft,
    gdFromBottomLeft : FromCorner;
    gdFromCenter     : FromCenter;
    gdDiagonalUp     : DiagonalGradient(True);
    gdDiagonalDown   : DiagonalGradient(False);
  end;

  {$IFDEF CLX}
  FCanvas.Stop;
  {$ELSE}
  if tmpBrush<>0 then DeleteObject(SelectObject(FDC,tmpBrush));
  {$ENDIF}
end;

procedure TTeeCanvas3D.EraseBackground(const Rect: TRect);
begin
  FillRect(Rect);
end;

procedure TTeeCanvas3D.FillRect(const Rect: TRect);
begin
  {$IFNDEF CLX}
  {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.FillRect(FCanvas.Handle, Rect, FBrush.Handle);
  {$ELSE}
  FCanvas.FillRect(Rect);
  {$ENDIF}
end;

Function ApplyDark(Color:TColor; HowMuch:Byte):TColor;
Var r : Byte;
    g : Byte;
    b : Byte;
Begin
  Color:=ColorToRGB(Color);
  r:=Byte(Color);
  g:=Byte(Color shr 8);
  b:=Byte(Color shr 16);
  if r>HowMuch then Dec(r,HowMuch) else r:=0;
  if g>HowMuch then Dec(g,HowMuch) else g:=0;
  if b>HowMuch then Dec(b,HowMuch) else b:=0;
  result := (r or (g shl 8) or (b shl 16));
end;

Function ApplyBright(Color:TColor; HowMuch:Byte):TColor;
Var r : Byte;
    g : Byte;
    b : Byte;
Begin
  Color:=ColorToRGB(Color);
  r:=Byte(Color);
  g:=Byte(Color shr 8);
  b:=Byte(Color shr 16);
  if (r+HowMuch)<256 then Inc(r,HowMuch) else r:=255;
  if (g+HowMuch)<256 then Inc(g,HowMuch) else g:=255;
  if (b+HowMuch)<256 then Inc(b,HowMuch) else b:=255;
  result := (r or (g shl 8) or (b shl 16));
end;

Procedure TTeeCanvas3D.Cube(Left,Right,Top,Bottom,Z0,Z1:Integer; DarkSides:Boolean=True);

  Function Culling:Double;
  begin
    result:=((IPoints[3].x-IPoints[2].x) * (IPoints[1].y-IPoints[2].y)) -
            ((IPoints[1].x-IPoints[2].x) * (IPoints[3].y-IPoints[2].y));
  end;

Var OldColor : TColor;
    P0,P1,
    P2,P3    : TPoint;
    tmp      : Double;
    Transparent : Boolean;
begin
  Calc3DPoint(P0,Left,Top,z0);
  Calc3DPoint(P1,Right,Top,z0);
  Calc3DPoint(P2,Right,Bottom,z0);
  Calc3DPoint(P3,Right,Top,z1);

  if FBrush.Style=bsSolid then OldColor:=FBrush.Color
                          else OldColor:=BackColor;

  Transparent:=FBrush.Style=bsClear;

  IPoints[0]:=P0;
  IPoints[1]:=P1;
  IPoints[2]:=P2;
  Calc3DPoint(IPoints[3],Left,Bottom,z0);

  if Transparent or (Culling>0) then
     PolygonFour // front-side
  else
  begin
    Calc3DPoint(IPoints[0],Left,Top,z1);
    Calc3DPoint(IPoints[1],Right,Top,z1);
    Calc3DPoint(IPoints[2],Right,Bottom,z1);
    Calc3DPoint(IPoints[3],Left,Bottom,z1);
    PolygonFour // back-side
  end;

  Calc3DPoint(IPoints[2],Right,Bottom,z1);

  IPoints[0]:=P1;
  IPoints[1]:=P3;
  IPoints[3]:=P2;

  if Transparent or (Culling>0) then
  begin
    if DarkSides then InternalDark(OldColor,DarkerColorQuantity);
    PolygonFour;  // left-side
  end;

  IPoints[0]:=P0;
  Calc3DPoint(IPoints[1],Left,Top,z1);
  Calc3DPoint(IPoints[2],Left,Bottom,z1);
  Calc3DPoint(IPoints[3],Left,Bottom,z0);

  if Transparent then
     tmp:=1
  else
     tmp:=(IPoints[3].x-IPoints[0].x) * (IPoints[1].y-IPoints[0].y) -
          (IPoints[1].x-IPoints[0].x) * (IPoints[3].y-IPoints[0].y);

  if tmp>0 then
  begin
    if DarkSides then InternalDark(OldColor,DarkerColorQuantity);
    PolygonFour;  // right-side
  end;

  Calc3DPoint(IPoints[3],Left,Top,z1);

  // culling
  if Transparent then tmp:=1
                 else tmp:=(P0.x-P1.x) * (P3.y-P1.y) - (P3.x-P1.x) * (P0.y-P1.y);

  if tmp>0 then
  begin
    IPoints[0]:=P0;
    IPoints[1]:=P1;
    IPoints[2]:=P3;
    if DarkSides then InternalDark(OldColor,DarkColorQuantity);
    PolygonFour; // top-side
  end;

  Calc3DPoint(IPoints[0],Left,Bottom,z0);
  Calc3DPoint(IPoints[2],Right,Bottom,z1);
  Calc3DPoint(IPoints[1],Left,Bottom,z1);
  IPoints[3]:=P2;

  if Transparent or (Culling<0) then
  begin
    if DarkSides then InternalDark(OldColor,DarkColorQuantity);
    PolygonFour;
  end;
end;

Procedure TTeeCanvas3D.RectangleZ(Left,Top,Bottom,Z0,Z1:Integer);
begin
  Calc3DPoint(IPoints[0],Left,Top,Z0);
  Calc3DPoint(IPoints[1],Left,Top,Z1);
  Calc3DPoint(IPoints[2],Left,Bottom,Z1);
  Calc3DPoint(IPoints[3],Left,Bottom,Z0);
  PolygonFour;
end;

Procedure TTeeCanvas3D.RectangleY(Left,Top,Right,Z0,Z1:Integer);
begin
  Calc3DPoint(IPoints[0],Left,Top,Z0);
  Calc3DPoint(IPoints[1],Right,Top,Z0);
  Calc3DPoint(IPoints[2],Right,Top,Z1);
  Calc3DPoint(IPoints[3],Left,Top,Z1);
  PolygonFour;
end;

procedure TTeeCanvas3D.DisableRotation;
begin
  FWas3D:=FIs3D;
  FIs3D:=False;
end;

procedure TTeeCanvas3D.EnableRotation;
begin
  FIs3D:=FWas3D;
end;

Procedure TTeeCanvas3D.Invalidate;
begin
  FDirty:=True;
end;

procedure TTeeCanvas3D.RotateLabel3D(x,y,z:Integer; const St:String; RotDegree:Double);
begin
  Calc3DPos(x,y,z);
  RotateLabel(x,y,St,RotDegree);
end;

{$IFDEF LCL}
const
  GM_LAST=2;
{$ENDIF}

procedure TTeeCanvas3D.RotateLabel(x,y:Integer; const St:String; RotDegree:Double);
{$IFNDEF CLX}
var OldFont: HFONT;
    NewFont: HFONT;
    LogRec : TLOGFONT;
    FDC    : HDC;
{$ELSE}
var tmpSt : WideString;
    tmpW  : Integer;
    tmpH  : Integer;
    tmp   : Integer;
{$ENDIF}
begin
  while RotDegree>360 do
        RotDegree:=RotDegree-360;

  {$IFNDEF CLX}
  FBrush.Style := bsClear;
  FDC:=FCanvas.Handle;

  {$IFDEF CLR}
  GetObject(FFont.Handle, Marshal.SizeOf(TypeOf(TLogFont)), LogRec);
  {$ELSE}
  GetObject(FFont.Handle, SizeOf(LogRec), @LogRec);
  {$ENDIF}

  LogRec.lfEscapement:=Round(RotDegree*10.0);

  if CharacterAngle<>0 then
     LogRec.lfOrientation:=Round(CharacterAngle*10.0);

  LogRec.lfOutPrecision := OUT_TT_ONLY_PRECIS;

  if IZoomText then
  if IZoomFactor<>1 then
     LogRec.lfHeight:= -MulDiv( Math.Max(1,Round(IZoomFactor*FFont.Size)),
                                FFont.PixelsPerInch, 72);

  LogRec.lfQuality:=TeeFontAntiAlias;

  NewFont := CreateFontIndirect({$IFDEF LCL}@{$ENDIF}LogRec);

  if CharacterAngle<>0 then
     SetGraphicsMode(FDC,GM_ADVANCED);

  OldFont := SelectObject(FDC,NewFont);

  TextOut(x,y,St);
  DeleteObject(SelectObject(FDC,OldFont));

  if CharacterAngle<>0 then
     SetGraphicsMode(FDC,GM_LAST);

  {$ELSE}

  if RotDegree=0 then TextOut(x,y,St)
  else
  begin
    RotDegree:=360-RotDegree;

    tmp:=TextAlign;
    tmpH:=FCanvas.TextHeight(St);
    if tmp>=TA_BOTTOM then
    begin
      tmpH:=tmpH div 2;
      Dec(tmp,TA_BOTTOM);
    end;

    if tmp=TA_CENTER then
       tmpW:=FCanvas.TextWidth(St) div 2
    else
    if tmp=TA_RIGHT then
       tmpW:=FCanvas.TextWidth(St)
    else
       tmpW:=0;

    FCanvas.Start;
    QPainter_translate(Handle,x,y);
    QPainter_rotate(FCanvas.Handle,RotDegree);
    QPainter_translate(Handle,-x-tmpW,-y+tmpH-2);   // 2 ?

    if IZoomText then
       if IZoomFactor<>1 then
          FFont.Size:=Math.Max(1,Round(IZoomFactor*FFont.Size));

    QPainter_setFont(FCanvas.Handle,FFont.Handle);
    tmpSt:=St;
    QPainter_drawText(FCanvas.Handle,x,y,PWideString(@tmpSt),-1);
    QPainter_resetXForm( FCanvas.Handle ); // 7.0
    FCanvas.Stop;
  end;
  {$ENDIF}
end;

Procedure TTeeCanvas3D.Polyline(const Points:{$IFDEF D5}Array of TPoint{$ELSE}TPointArray{$ENDIF});
Begin
  {$IFNDEF CLX}
  {$IFDEF CLR}
  Borland.VCL.Windows.Polyline(FCanvas.Handle, Points, High(Points)+1);
  {$ELSE}
  {$IFDEF D5}
  Windows.Polyline(FCanvas.Handle, PPoints(@Points)^, High(Points)+1);
  {$ELSE}
  // this is due to a D4 bug...
  FCanvas.Polyline(Points);
  {$ENDIF}
  {$ENDIF}
  {$ELSE}
  FCanvas.Polyline(Points);
  {$ENDIF}
end;

Procedure TTeeCanvas3D.Polygon(const Points:Array of TPoint);
Begin
  {$IFNDEF CLX}
  {$IFDEF CLR}
  Borland.VCL.Windows.Polygon(FCanvas.Handle, Points, High(Points)+1);
  {$ELSE}
  Windows.Polygon(FCanvas.Handle, PPoints(@Points)^, High(Points) + 1);
  {$ENDIF}
  {$ELSE}
  FCanvas.Polygon(Points);
  {$ENDIF}
end;

Procedure TTeeCanvas3D.Polygon3D(const Points: Array of TPoint3D);
var P : TPointArray;
    t : Integer;
begin
  SetLength(P,Length(Points));
  try
    for t:=0 to Length(Points)-1 do
    with Points[t] do
         Calc3DPoint(P[t],x,y,z);

    Polygon(P);
  finally
    P:=nil;
  end;
end;

procedure TTeeCanvas3D.Ellipse(X1, Y1, X2, Y2: Integer);
begin
  {$IFNDEF CLX}
  {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.Ellipse(FCanvas.Handle, X1, Y1, X2, Y2);
  {$ELSE}
  FCanvas.Ellipse(X1,Y1,X2,Y2);
  {$ENDIF}
end;

Procedure TTeeCanvas3D.GetCirclePoints(var P:{$IFDEF D5}TCirclePoints{$ELSE}TPointArray{$ENDIF}; X1, Y1, X2, Y2, Z: Integer);
Const PiStep=2.0*Pi*(360.0/(NumCirclePoints-1))/360.0;
var PCenter : TPoint;
    XRadius : Integer;
    YRadius : Integer;
    t       : Integer;
    tmpSin  : Extended;
    tmpCos  : Extended;
begin
  PCenter.X:=(X2+X1) div 2;
  PCenter.Y:=(Y2+Y1) div 2;
  XRadius:=(X2-X1) div 2;
  YRadius:=(Y2-Y1) div 2;
  P[0]:=Calculate3DPosition(PCenter.X,Y2,Z);

  for t:=1 to NumCirclePoints-1 do
  begin
    SinCos(t*piStep,tmpSin,tmpCos);
    // 6.02, fix for rounding pixel problem:
    Calc3DPoint(P[t],PCenter.X+(XRadius*tmpSin),PCenter.Y+(YRadius*tmpCos),Z);
  end;
end;

procedure TTeeCanvas3D.EllipseWithZ(X1, Y1, X2, Y2, Z: Integer);
Var P       : {$IFDEF D5}TCirclePoints{$ELSE}TPointArray{$ENDIF};
    Points  : TTrianglePoints;
    PCenter : TPoint;
    t       : Integer;
    Old     : TPenStyle;
begin
  if FIsOrthogonal then
  begin
    Calc3DPos(X1,Y1,Z);
    Calc3DPos(X2,Y2,Z);
    Ellipse(X1,Y1,X2,Y2);
  end
  else
  if FIs3D then
  begin
    {$IFNDEF D5}
    SetLength(P,NumCirclePoints);
    {$ENDIF}

    GetCirclePoints(P,X1,Y1,X2,Y2,Z);

    if FBrush.Style<>bsClear then
    begin
      Old:=FPen.Style;
      FPen.Style:=psClear;

      PCenter.X:=(X2+X1) div 2;
      PCenter.Y:=(Y2+Y1) div 2;
      Calc3DTPoint(PCenter,Z);

      Points[0]:=PCenter;
      Points[1]:=P[0];
      Points[2]:=P[1];

      Polygon(Points);

      Points[1]:=P[1];

      for t:=2 to NumCirclePoints-1 do
      begin
        Points[2]:=P[t];
        Polygon(Points);
        Points[1]:=P[t];
      end;

      FPen.Style:=Old;
    end;

    if FPen.Style<>psClear then
       Polyline(P);

    {$IFNDEF D5}
    P:=nil;
    {$ENDIF}
  end
  else Ellipse(X1,Y1,X2+1,Y2+1);
end;

Function TTeeCanvas3D.GetPixel(X, Y: Integer):TColor;
begin
  {$IFDEF D7}
  result:=FCanvas.Pixels[x,y];
  {$ELSE}
   {$IFDEF CLX}
     {$IFDEF MSWINDOWS}
     result:=Windows.GetPixel(QPainter_handle(Handle), X, Y);
     {$ELSE}
     result:=0; // Not implemented.
     {$ENDIF}
   {$ELSE}
    result:=FCanvas.Pixels[x,y];
   {$ENDIF}
  {$ENDIF}
end;

procedure TTeeCanvas3D.SetPixel(X, Y: Integer; Value: TColor);
begin
  {$IFNDEF CLX}
  {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.SetPixel(FCanvas.Handle, X, Y, ColorToRGB(Value));
  {$ELSE}
  QPainter_drawPoint(Handle,x,y);
  {$ENDIF}
end;

procedure TTeeCanvas3D.Arc(const Left, Top, Right, Bottom, StartX, StartY, EndX, EndY: Integer);
begin
  {$IFNDEF CLX}
  {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.Arc(FCanvas.Handle, Left, Top, Right, Bottom, StartX, StartY, EndX, EndY);
  {$ELSE}
  FCanvas.Arc(Left, Top, Right, Bottom, StartX, StartY, EndX, EndY);
  {$ENDIF}
end;

{$IFDEF LCL}
Function Slice(const A:Array of TPoint; Count:Integer):TPointArray; 
var t : Integer;
begin
  SetLength(result,Count);
  for t:=0 to Count-1 do result[t]:=A[t];
end;
{$ENDIF}

{$IFDEF CLR}
Function Slice(const A:Array of TPoint; Count:Integer):TPointArray;
begin
  SetLength(result,Count);
  System.Array.Copy(A,result,Count);
end;
{$ENDIF}

// Donut 2D
procedure TTeeCanvas3D.Donut( XCenter,YCenter,XRadius,YRadius:Integer;
                              Const StartAngle,EndAngle,HolePercent:Double);

var tmpXRadius,
    tmpYRadius  : Double;
    {$IFNDEF CLX}
    tmpDC       : TTeeCanvasHandle;
    {$ENDIF}

  {$IFNDEF CLX}
  procedure ArcTo(const X1,Y1,X2,Y2,X3,Y3,X4,Y4:Integer;
                  const ClockWise:Boolean=False);
  begin
    if ClockWise then
       SetArcDirection(tmpDC,AD_CLOCKWISE);

    {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.ArcTo(tmpDC,X1,Y1,X2,Y2,x3,y3,x4,y4);

    if ClockWise then
       SetArcDirection(tmpDC,AD_COUNTERCLOCKWISE);
  end;

  Procedure CalcPoint(const Angle:Double; out x,y:Integer);
  var tmpSin : Extended;
      tmpCos : Extended;
  begin
    SinCos(Angle,tmpSin,tmpCos);
    x:=XCenter+Round(XRadius*tmpCos);
    y:=YCenter-Round(YRadius*tmpSin);
  end;

  Procedure CalcPoint2(const Angle:Double; out x,y:Integer);
  var tmpSin : Extended;
      tmpCos : Extended;
  begin
    SinCos(Angle,tmpSin,tmpCos);
    x:=XCenter+Round(tmpXRadius*tmpCos);
    y:=YCenter-Round(tmpYRadius*tmpSin);
  end;
  {$ENDIF}

{$IFNDEF CLX}
var x3,y3,
    x4,y4       : Integer;
{$ELSE}
Const MaxCircleSteps=128;
var Points      : Array[0..2*MaxCircleSteps-1] of TPoint;
    t,
    CircleSteps,
    tmp         : Integer;
    Step        : Double;
    tmpAngle    : Extended;
    tmpCos      : Extended;
    tmpSin      : Extended;
{$ENDIF}
begin
  tmpXRadius:=HolePercent*XRadius*0.01;
  tmpYRadius:=HolePercent*YRadius*0.01;

  {$IFNDEF CLX}
  CalcPoint(StartAngle,x3,y3);
  CalcPoint(EndAngle,x4,y4);

  MoveTo(x3,y3);

  tmpDC:=Handle;
  BeginPath(tmpDC);

  ArcTo(XCenter-XRadius,YCenter-YRadius,XCenter+XRadius,YCenter+YRadius,x3,y3,x4,y4);

  CalcPoint2(StartAngle,x3,y3);
  CalcPoint2(EndAngle,x4,y4);

  if (x4<>x3) or (y4<>y3) then
     ArcTo(XCenter-Round(tmpXRadius),YCenter-Round(tmpYRadius),
           XCenter+Round(tmpXRadius),YCenter+Round(tmpYRadius),
           x4,y4,x3,y3,True);

  EndPath(tmpDC);
  StrokeAndFillPath(tmpDC);

  {$ELSE}

  CircleSteps:=Round(MaxCircleSteps*(EndAngle-StartAngle)/Pi);

  if CircleSteps<2 then CircleSteps:=2
  else
  if CircleSteps>MaxCircleSteps then
     CircleSteps:=MaxCircleSteps;

  Step:=(EndAngle-StartAngle)/Pred(CircleSteps);

  tmpAngle:=StartAngle;

  for t:=1 to CircleSteps do
  begin
    SinCos(tmpAngle,tmpSin,tmpCos);
    Points[t].X:=XCenter+Round(XRadius*tmpCos);
    Points[t].Y:=YCenter-Round(YRadius*tmpSin);

    if t=1 then tmp:=0
           else tmp:=2*CircleSteps-t+1;

    Points[tmp].X:=XCenter+Round(tmpXRadius*tmpCos);
    Points[tmp].Y:=YCenter-Round(tmpYRadius*tmpSin);
    tmpAngle:=tmpAngle+Step;
  end;

  Polygon(Slice(Points,2*CircleSteps));
  {$ENDIF}
end;

procedure TTeeCanvas3D.Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
{$IFDEF CLX}
var Theta: Extended;
    Theta2: Extended;
{$ENDIF}
begin
  {$IFNDEF CLX}
  {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.Pie(FCanvas.Handle, X1, Y1, X2, Y2, X3, Y3, X4, Y4);
  {$ELSE}

  // bug in CLX, needs this code:
  CalcPieAngles(X1,X2,Y1,Y2,X3,Y3,X4,Y4,Theta,Theta2);
  FCanvas.Pie(X1, Y1, X2-X1, Y2-Y1, Round(Theta) shl 4, Round(Theta2 - Theta) shl 4);
  {$ENDIF}
end;

procedure TCanvas3D.CalcPieAngles(X1,Y1,X2,Y2,X3,Y3,X4,Y4:Integer; var Theta,Theta2:Extended);
const HalfDivPi=180/Pi;
var
  Width, Height: Integer;
  CenterX, CenterY: Integer;
begin
  Width := X2 - X1;
  Height := Y2 - Y1;
  CenterX := X1 + (Width div 2);
  CenterY := Y1 + (Height div 2);

  Theta:=ArcTan2(CenterY-Y3, X3 - CenterX);
  if Theta<0 then Theta:=2.0*Pi+Theta;
  Theta := Theta*HalfDivPi;

  Theta2:=ArcTan2(CenterY-Y4, X4 - CenterX);
  if Theta2<0 then Theta2:=2.0*Pi+Theta2;
  Theta2 :=Theta2*HalfDivPi;
  if Theta2=0 then
     Theta2:=361;
end;

procedure TTeeCanvas3D.Pie3D( AXCenter,AYCenter,XRadius,YRadius,Z0,Z1:Integer;
                              Const StartAngle,EndAngle:Double;
                              DarkSides,DrawSides:Boolean; DonutPercent:Integer=0;
                              Gradient:TCustomTeeGradient=nil);

Const MaxCircleSteps=96;
var Points      : Array[0..2*MaxCircleSteps+1] of TPoint;
    Points3D2,
    Points3D    : Array[1..2*MaxCircleSteps] of TPoint;
    Start3D,
    End3D,
    CircleSteps : Integer;
    OldColor    : TColor;

  Procedure Draw3DPie;
  var t,tt : Integer;
      {$IFDEF CLR}
      tmp : TPointArray;
      {$ENDIF}
  begin
    if DarkSides then InternalDark(OldColor,32);

    if (Start3D=1) and (End3D=CircleSteps) then
    begin
      for t:=1 to CircleSteps do Points3D[t]:=Points[t];
      tt:=CircleSteps;
    end
    else
    begin
      tt:=0;
      for t:=Start3D to End3D do
      begin
        Inc(tt);
        Points3D[tt]:=Points[t];
        Points3D[End3D-Start3D+1+tt]:=Points3D[2*CircleSteps-End3D+tt];
      end;
    end;

    {$IFDEF CLR}
    tmp:=Slice(Points3D,2*tt);
    if Assigned(Gradient) then PolygonGradient(tmp,Gradient)
                          else Polygon(tmp);

    {$ELSE}
    if Assigned(Gradient) then PolygonGradient(Slice(Points3D,2*tt),Gradient)
                          else Polygon(Slice(Points3D,2*tt));
    {$ENDIF}
  end;

var tmpSin,
    tmpCos   : Extended;
    tmpXRadius,
    tmpYRadius : Double;

  Procedure CalcCenter(Var P:TPoint; const Angle:Double; Z:Integer);
  begin
    if DonutPercent>0 then
    begin
      SinCos(Angle,tmpSin,tmpCos);
      Calc3DPoint(P,AXCenter+(tmpXRadius*tmpCos),AYCenter-Round(tmpYRadius*tmpSin),Z);
    end
    else
       Calc3DPoint(P,AXCenter,AYCenter,Z);
  end;

  Procedure FinishSide(const Angle:Double);
  begin
    CalcCenter(IPoints[3],Angle,Z0);
    if DarkSides then InternalDark(OldColor,32);
    PolygonFour;
  end;

  Procedure DrawPieTop(NumPoints:Integer);
  {$IFDEF CLR}
  var tmp : TPointArray;
  {$ENDIF}
  begin
    {$IFDEF CLR}
    tmp:=Slice(Points,NumPoints);
    if Assigned(Gradient) then PolygonGradient(tmp,Gradient)
                          else Polygon(tmp);
    {$ELSE}
    if Assigned(Gradient) then
       PolygonGradient(Slice(Points,NumPoints),Gradient)
    else
       Polygon(Slice(Points,NumPoints))
    {$ENDIF}
  end;

Var tmpAngle : Extended;
    Step     : Double;
    Started  : Boolean;
    Ended    : Boolean;
    t        : Integer;
    tt       : Integer;
    tmpX     : Double;
    tmpY     : Double;
begin
  CircleSteps:=2+Math.Min(MaxCircleSteps-2,Round(180.0*Abs(EndAngle-StartAngle)/Pi/2.0));

  //  CircleSteps:=MaxCircleSteps; { improved to draw better rounded }

  if DonutPercent>0 then
  begin
    tmpXRadius:=DonutPercent*XRadius*0.01;
    tmpYRadius:=DonutPercent*YRadius*0.01;
  end;

  CalcCenter(Points[0],StartAngle,Z1);

  Step:=(EndAngle-StartAngle)/(CircleSteps-1);
  tmpAngle:=StartAngle;

  for t:=1 to CircleSteps do
  begin
    SinCos(tmpAngle,tmpSin,tmpCos);
    tmpX:=AXCenter+(XRadius*tmpCos); // 6.02, removed "Round"
    tmpY:=AYCenter-(YRadius*tmpSin); //  ""      ""

    Calc3DPoint(Points[t],tmpX,tmpY,Z1);
    Calc3DPoint(Points3D[2*CircleSteps+1-t],tmpX,tmpY,Z0);

    tmpAngle:=tmpAngle+Step;
  end;

  if FBrush.Style=bsSolid then OldColor:=FBrush.Color
                          else OldColor:=BackColor;

  if DonutPercent>0 then
  begin
    CalcCenter(Points[2*CircleSteps+1],EndAngle,Z1);
    Points3D2[1]:=Points[0];

    tmpAngle:=EndAngle;
    for t:=1 to CircleSteps do
    begin
      CalcCenter(Points[CircleSteps+t],tmpAngle,Z1);
      Points3D2[t]:=Points[CircleSteps+t];
      CalcCenter(Points3D2[2*CircleSteps+1-t],tmpAngle,Z0);

      tmpAngle:=tmpAngle-Step;
    end;

    if DarkSides then InternalDark(OldColor,32);

    Polygon(Slice(Points3D2,2*CircleSteps)); { 5.02 }
  end;

  { side }
  if DrawSides then
  begin
    if Points[CircleSteps].X < XCenterOffset then
    begin
      if DonutPercent>0 then IPoints[0]:=Points[2*CircleSteps+1]
                        else IPoints[0]:=Points[0];
      IPoints[1]:=Points[CircleSteps];
      IPoints[2]:=Points3D[CircleSteps+1];
      FinishSide(EndAngle);
    end;

    { side }
    if Points[1].X > XCenterOffset then
    begin
      IPoints[0]:=Points[0];
      IPoints[1]:=Points[1];
      IPoints[2]:=Points3D[2*CircleSteps];
      FinishSide(StartAngle);
    end;
  end;

  { 2d pie }
  if FBrush.Style=bsSolid then FBrush.Color:=OldColor
                          else BackColor:=OldColor;

  if DonutPercent>0 then DrawPieTop(2*CircleSteps+1)
                    else DrawPieTop(CircleSteps+1);

  { 3d pie }
  Ended:=False;
  Start3D:=0;
  End3D:=0;

  for t:=2 to CircleSteps do
  begin
    if Points[t].X>Points[t-1].X then
    begin
      Start3D:=t-1;
      Started:=True;

      for tt:=t+1 to CircleSteps-1 do
      if Points[tt+1].X<Points[tt].X then
      begin
        End3D:=tt;
        Ended:=True;
        Break;
      end;

      if (not Ended) and (Points[CircleSteps].X>=Points[CircleSteps-1].X) then
      begin
        End3D:=CircleSteps;
        Ended:=True;
      end;

      if Started and Ended then
         Draw3DPie;

      if End3D<>CircleSteps then
      if Points[CircleSteps].X>Points[CircleSteps-1].X then
      begin
        End3D:=CircleSteps;
        tt:=CircleSteps-1;

        While (Points[tt].X>Points[tt-1].X) do
        begin
          Dec(tt);
          if tt=1 then break;
        end;

        if tt>1 then
        begin
          Start3D:=tt;
          Draw3DPie;
        end;

      end;

      break;
    end;
  end;
end;

procedure TTeeCanvas3D.Plane3D(Const A,B:TPoint; Z0,Z1:Integer);
begin
  Calc3DPoint(IPoints[0],A.X,A.Y,Z0);
  Calc3DPoint(IPoints[1],B.X,B.Y,Z0);
  Calc3DPoint(IPoints[2],B.X,B.Y,Z1);
  Calc3DPoint(IPoints[3],A.X,A.Y,Z1);
  PolygonFour;
end;

procedure TTeeCanvas3D.InternalCylinder(Vertical:Boolean; Left,Top,Right,Bottom,
                            Z0,Z1:Integer; Dark3D:Boolean; ConePercent:Integer);
var Radius,
    ZRadius,
    tmpMid,
    tmpMidZ : Integer;
    Step:Double;

  Procedure CalcPointZ(Index:Integer; var X,Z:Integer);
  var tmpSin : Extended;
      tmpCos : Extended;
  begin
    SinCos(Index*Step,tmpSin,tmpCos);
    X:=tmpMid+Round(tmpSin*Radius);
    Z:=tmpMidZ-Round(tmpCos*ZRadius);
  end;

var
  tmpSize : Integer;
  Poly    : Array of TPoint3D;
  tmpPoly : Array[1..4] of TPoint;

  Procedure CalcPointV(a,b:Integer);
  begin
    With Poly[a] do
    begin
      Calc3DPoint(tmpPoly[b],x,y+tmpSize,z);
      CalcPointZ(a-4,X,Z);
    end;
  end;

  Procedure CalcPointH(a,b:Integer);
  begin
    With Poly[a] do
    begin
      Calc3DPoint(tmpPoly[b],x-tmpSize,y,z);
      CalcPointZ(a-5,Y,Z);
    end;
  end;

  Function CoverAtLeft:Boolean;
  begin
    Calc3DPoint(tmpPoly[1],0,0,0);
    Calc3DPoint(tmpPoly[2],0,10,0);
    Calc3DPoint(tmpPoly[3],0,10,10);
    result:=TeeCull(tmpPoly[1],tmpPoly[2],tmpPoly[3]);
  end;

var
  OldColor : TColor;

  procedure DrawCover;
  var tmpPoly2 : Array of TPoint;
      t        : Integer;
      tmp      : Double;
  begin
    // Cover
    SetLength(tmpPoly2,TeeNumCylinderSides);

    // TODO : Works fine only for cylider. For cone there are two different covers
    if (not Vertical) and CoverAtLeft then
    begin
      if ConePercent=0 then tmp:=1
                       else tmp:=100/ConePercent;

      for t:=0 to TeeNumCylinderSides-1 do
          tmpPoly2[t]:=Calculate3DPosition(Left,Round(tmp*Poly[1+t].Y),Round(tmp*Poly[1+t].Z));
    end
    else
    for t:=0 to TeeNumCylinderSides-1 do
        tmpPoly2[t]:=Calc3DTPoint3D(Poly[1+t]);

    if Dark3D then
       InternalDark(OldColor,DarkColorQuantity);

    Polygon(tmpPoly2);

    tmpPoly2:=nil;
  end;

Var t        : Integer;
    NumSide  : Integer;
    StepColor: Integer;
    tp: TPoint;
begin
  if ConePercent=0 then
     ConePercent:=TeeDefaultConePercent;

  if FBrush.Style=bsSolid then OldColor:=FBrush.Color
                          else OldColor:=BackColor;
  ZRadius:=(Z1-Z0) div 2;
  tmpMidZ:=(Z1+Z0) div 2;

  SetLength(Poly,1+TeeNumCylinderSides);

  Step:=2.0*Pi/TeeNumCylinderSides;

  if Vertical then
  begin
    Radius:=(Right-Left) div 2;
    tmpMid:=(Right+Left) div 2;
    tmpSize:=(Bottom-Top);

    for t:=1 to TeeNumCylinderSides do
    begin
      Poly[t].Y:=Top;
      CalcPointZ(t-4,Poly[t].X,Poly[t].Z);
    end;
  end
  else
  begin
    Radius:=(Bottom-Top) div 2;
    tmpMid:=(Bottom+Top) div 2;
    tmpSize:=(Right-Left);

    for t:=1 to TeeNumCylinderSides do
    begin
      Poly[t].X:=Right;
      CalcPointZ(t-5,Poly[t].Y,Poly[t].Z);
    end;
  end;

  Radius:=Round(Radius*ConePercent*0.01);
  ZRadius:=Round(ZRadius*ConePercent*0.01);

  if Vertical then CalcPointV(1,2)
              else CalcPointH(1,2);

  tmpPoly[1]:=Calc3DTPoint3D(Poly[1]);
  NumSide:=0;
  tp.X := tmpPoly[2].X;
  tp.Y := tmpPoly[2].Y;

  StepColor:=256 div (TeeNumCylinderSides * 2);

  for t:=2 to TeeNumCylinderSides do
  begin
    if Vertical then CalcPointV(t,3)
                else CalcPointH(t,3);

    tmpPoly[4]:=Calc3DTPoint3D(Poly[t]);

    if not TeeCull(tmpPoly[1],tmpPoly[2],tmpPoly[3]) then
    begin
      if Dark3D then
         InternalDark(OldColor,StepColor*NumSide);

      Polygon(tmpPoly);
    end;

    tmpPoly[1]:=tmpPoly[4];
    tmpPoly[2]:=tmpPoly[3];
    Inc(NumSide);
  end;

  tmpPoly[4] := Calc3DTPoint3D(Poly[1]);
  tmpPoly[3].X := tp.X;
  tmpPoly[3].Y := tp.Y;

  if not TeeCull(tmpPoly[1],tmpPoly[2],tmpPoly[3]) then
     Polygon(tmpPoly);

  DrawCover;

  Poly:=nil;
end;

procedure TTeeCanvas3D.Cylinder(Vertical:Boolean; Left,Top,Right,Bottom,
                                Z0,Z1:Integer; Dark3D:Boolean=True);
Begin
  InternalCylinder(Vertical,Left,Top,Right,Bottom,Z0,Z1,Dark3D,100);
end;

procedure TTeeCanvas3D.Pyramid(Vertical:Boolean; Left,Top,Right,Bottom,
                               z0,z1:Integer; DarkSides:Boolean=True);
Var OldColor : TColor;
    P0,P1,
    P2,P3,
    PTop     : TPoint;
    tmpC     : Boolean;
begin
  if FBrush.Style=bsSolid then OldColor:=FBrush.Color
                          else OldColor:=BackColor;

  if Vertical then
  begin
    if Top<>Bottom then
    Begin
      Calc3DPoint(P0,Left,Bottom,Z0);
      Calc3DPoint(P1,Right,Bottom,Z0);
      Calc3DPoint(PTop,(Left+Right) div 2,Top,(Z0+Z1) div Integer(2));
      Calc3DPoint(P2,Left,Bottom,Z1);
      Calc3DPoint(P3,Right,Bottom,Z1);

      Polygon([P0,PTop,P1]);

      tmpC:=TeeCull(P0,PTop,P2);
      if Top<Bottom then tmpC:=not tmpC;
      if tmpC then Polygon([ P0,PTop,P2] );

      if DarkSides then
         InternalDark(OldColor,DarkerColorQuantity);

      tmpC:=TeeCull(P1,PTop,P3);
      if Top>=Bottom then tmpC:=not tmpC;
      if tmpC then Polygon([ P1,PTop,P3 ] );

      if Top<Bottom then
      begin
        Calc3DPoint(P2,Left,Bottom,Z1);
        if TeeCull(PTop,P2,P3) then
           Polygon([ PTop,P2,P3 ] );
      end;
    end;

    Calc3DPoint(P0,Left,Bottom,Z0);
    Calc3DPoint(P1,Right,Bottom,Z0);
    Calc3DPoint(P2,Left,Bottom,Z1);

    tmpC:=TeeCull(P0,P1,P2);
    if Top>=Bottom then tmpC:=not tmpC;

    if tmpC then
    begin
      if DarkSides then
         InternalDark(OldColor,DarkColorQuantity);

      RectangleY(Left,Bottom,Right,Z0,Z1);
    end;
  end
  else
  begin
    if Left<>Right then
    Begin
      Calc3DPoint(P0,Left,Top,Z0);
      Calc3DPoint(P1,Left,Bottom,Z0);
      Calc3DPoint(PTop,Right,(Top+Bottom) div 2,(Z0+Z1) div 2);
      Calc3DPoint(P2,Left,Top,Z1);
      Calc3DPoint(P3,Left,Bottom,Z1);

      Polygon([P0,PTop,P1]);

      tmpC:=TeeCull(P2,PTop,P3);
      if Left<Right then tmpC:=not tmpC;
      if tmpC then Polygon([ P2,PTop,P3] );

      if DarkSides then
         InternalDark(OldColor,DarkColorQuantity);

      tmpC:=TeeCull(P0,PTop,P2);
      if Left<Right then tmpC:=not tmpC;
      if tmpC then Polygon([ P0,PTop,P2 ] );

      tmpC:=TeeCull(P3,PTop,P1);
      if Left<Right then tmpC:=not tmpC;
      if tmpC then Polygon([ P3,PTop,P1 ] );
    end;

    Calc3DPoint(P0,Left,Top,Z0);
    Calc3DPoint(P1,Left,Bottom,Z0);
    Calc3DPoint(P2,Left,Top,Z1);

    tmpC:=TeeCull(P0,P1,P2);
    if Left>=Right then tmpC:=not tmpC;

    if tmpC then
    begin
      if DarkSides then
         InternalDark(OldColor,DarkerColorQuantity);

      RectangleZ(Left,Top,Bottom,Z0,Z1);
    end;
  end;
end;

Procedure TTeeCanvas3D.PyramidTrunc(Const R:TRect; StartZ,EndZ:Integer;
                                    TruncX,TruncZ:Integer);
var MidX : Integer;
    MidZ : Integer;

  Procedure PyramidFrontWall(StartZ,EndZ:Integer);
  var P : TFourPoints;
      P0,P1,P2,P3 : TPoint;
      tmp : Boolean;
  begin
    P[0].X:=MidX-TruncX;
    P[0].Y:=R.Top;
    P[1].X:=MidX+TruncX;
    P[1].Y:=R.Top;
    P[2].X:=R.Right;
    P[2].Y:=R.Bottom;
    P[3].X:=R.Left;
    P[3].Y:=R.Bottom;

    P0:=Calculate3DPosition(P[0],StartZ);
    P1:=Calculate3DPosition(P[1],StartZ);
    P2:=Calculate3DPosition(P[2],EndZ);
    P3:=Calculate3DPosition(P[3],EndZ);

    tmp:=TeeCull(P1,P2,P3);

    if (EndZ>StartZ) and (StartZ>0) and (R.Top<R.Bottom) then
       tmp:=not tmp  // 7.06  TV52010025
    else
    if (EndZ<StartZ) and (R.Top>R.Bottom) then
       tmp:=not tmp;

    if tmp then
       PlaneFour3D(P,StartZ,EndZ);
  end;

  Procedure PyramidSideWall(HorizPos1,HorizPos2:Integer; IsLeft:Boolean);
  var tmp : Boolean;
  begin
    IPoints[0]:=Calculate3DPosition(HorizPos2,R.Top,MidZ-TruncZ);
    IPoints[1]:=Calculate3DPosition(HorizPos2,R.Top,MidZ+TruncZ);
    IPoints[2]:=Calculate3DPosition(HorizPos1,R.Bottom,EndZ);
    IPoints[3]:=Calculate3DPosition(HorizPos1,R.Bottom,StartZ);

    tmp:=TeeCull(IPoints[3], IPoints[2], IPoints[1]);

    if (HorizPos1>HorizPos2) and (R.Top<R.Bottom) then
       tmp:=not tmp
    else
    if (HorizPos1<HorizPos2) and (R.Top>R.Bottom) then
       tmp:=not tmp;

    if tmp then
       PolygonFour;
  end;

  Procedure BottomCover;
  begin
    RectangleY(R.Left,R.Bottom,R.Right,StartZ,EndZ)
  end;

  Procedure TopCover;
  begin
    if TruncX<>0 then
       RectangleY(MidX-TruncX,R.Top,MidX+TruncX,MidZ-TruncZ,MidZ+TruncZ);
  end;

begin
  MidX:=(R.Left+R.Right) div 2;
  MidZ:=(StartZ+EndZ) div 2;

  if R.Bottom>R.Top then BottomCover else TopCover;

  if (TruncX=0) and (StartZ=EndZ) then
     PyramidFrontWall(MidZ+TruncZ,EndZ)
  else
  begin
    PyramidFrontWall(MidZ+TruncZ,EndZ);
    PyramidSideWall(R.Left,MidX-TruncX,True);

    PyramidFrontWall(MidZ-TruncZ,StartZ);
    PyramidSideWall(R.Right,MidX+TruncX,False);
  end;

  if R.Bottom>R.Top then TopCover else BottomCover;
end;

procedure TTeeCanvas3D.PlaneFour3D(Var Points:TFourPoints; Z0,Z1:Integer);
{$IFNDEF CLR}
var tmpX: Double;
{$ENDIF}
begin
  IPoints:=Points;

  {$IFDEF CLR}
  Calc3DTPoint(IPoints[0],Z0);
  Calc3DTPoint(IPoints[1],Z0);
  Calc3DTPoint(IPoints[2],Z1);
  Calc3DTPoint(IPoints[3],Z1);
  {$ELSE}

  tmpX:=Points[0].X;
  Calc3DPoint(IPoints[0],tmpX,Points[0].Y,Z0);
  tmpX:=Points[1].X;
  Calc3DPoint(IPoints[1],tmpX,Points[1].Y,Z0);
  tmpX:=Points[2].X;
  Calc3DPoint(IPoints[2],tmpX,Points[2].Y,Z1);
  tmpX:=Points[3].X;
  Calc3DPoint(IPoints[3],tmpX,Points[3].Y,Z1);
  {$ENDIF}

  PolygonFour;
end;

Function TTeeCanvas3D.GetPixel3D(X,Y,Z: Integer):TColor;
begin
  Calc3DPos(X,Y,Z);
  result:=GetPixel(x,y);
end;

procedure TTeeCanvas3D.SetPixel3D(X,Y,Z:Integer; Value: TColor);
{$IFNDEF CLX}
var FDC : HDC;
{$ENDIF}
begin
  Calc3DPos(X,Y,Z);

  if FPen.Width=1 then
     SetPixel(X,Y,Value)
  else
  begin { simulate a big dot pixel }
    {$IFNDEF CLX}

    FDC:=FCanvas.Handle;
    {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.MoveToEx(FDC,X,Y,nil);
    {$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.LineTo(FDC,X,Y);

    {$ELSE}
    Pixels[X,Y]:=Value;
    {$ENDIF}
  end;
end;

Function TTeeCanvas3D.GetSupports3DText:Boolean;
begin
  result:=False;
end;

Function TTeeCanvas3D.GetSupportsFullRotation:Boolean;
begin
  result:=False;
end;

Function TTeeCanvas3D.GetTextAlign:TCanvasTextAlign;
begin
  {$IFNDEF CLX}
  result:={$IFDEF CLR}Borland.VCL.{$ENDIF}Windows.GetTextAlign(FCanvas.Handle);
  {$ELSE}
  result:=FTextAlign;
  {$ENDIF}
end;

Function TTeeCanvas3D.GetUseBuffer:Boolean;
begin
  result:=FBufferedDisplay;
end;

Procedure TTeeCanvas3D.SetUseBuffer(Value:Boolean);
begin
  if FBufferedDisplay<>Value then
  begin
    FBufferedDisplay:=Value;

    if (not FBufferedDisplay) and Assigned(FBitmap) then
    begin
      if not IKeepBitmap then
      begin
        DeleteBitmap;
        FDirty:=True;
      end;
    end
    else
    if FBufferedDisplay and Assigned(FBitmap) then
       SetCanvas(FBitmap.Canvas);
  end;
end;

Function TTeeCanvas3D.GetMonochrome:Boolean;
begin
  result:=FMonochrome;
end;

Procedure TTeeCanvas3D.SetMonochrome(Value:Boolean);
begin
  if FMonochrome<>Value then
  begin
    FMonochrome:=Value;
    FDirty:=True;
    if Assigned(F3DOptions) then F3DOptions.Repaint;
  end;
end;

procedure TTeeCanvas3D.Triangle3D( Const Points:TTrianglePoints3D;
                                   Const Colors:TTriangleColors3D);
var P : TTrianglePoints;
begin
  P[0]:=Calc3DTPoint3D(Points[0]);
  P[1]:=Calc3DTPoint3D(Points[1]);
  P[2]:=Calc3DTPoint3D(Points[2]);

  if Brush.Style<>bsClear then Brush.Color:=Colors[0];
  Polygon(P);
end;

procedure TTeeCanvas3D.TriangleWithZ(Const P1,P2,P3:TPoint; Z:Integer);
var Points : TTrianglePoints;
begin
  Calc3DPoint(Points[0],P1.X,P1.Y,Z);
  Calc3DPoint(Points[1],P2.X,P2.Y,Z);
  Calc3DPoint(Points[2],P3.X,P3.Y,Z);
  Polygon(Points);
end;

Procedure TTeeCanvas3D.Arrow( Filled:Boolean;
                              Const FromPoint,ToPoint:TPoint;
                              ArrowWidth,ArrowHeight,Z:Integer;
                              const ArrowPercent:Double);
Var x    : Double;
    y    : Double;
    SinA : Double;
    CosA : Double;

    Function CalcArrowPoint:TPoint;
    Begin
      result.X:=Round( x*CosA + y*SinA);
      result.Y:=Round(-x*SinA + y*CosA);
      Calc3DTPoint(result,Z);
    end;

Var tmpHoriz  : Integer;
    tmpVert   : Integer;
    dx        : Integer;
    dy        : Integer;
    tmpHoriz4 : Double;
    xb        : Double;
    yb        : Double;
    l         : Double;

   { These are the Arrows points coordinates }
    To3D,pc,pd,pe,pf,pg,ph:TPoint;

    (*           pc
                   |\
    ph           pf| \
      |------------   \ ToPoint
 From |------------   /
    pg           pe| /
                   |/
                 pd
    *)
begin
  dx:=ToPoint.x-FromPoint.x;
  dy:=FromPoint.y-ToPoint.y;
  l:=TeeDistance(dx,dy);

  if l>0 then  { if at least one pixel... }
  Begin
    tmpHoriz:=ArrowWidth;
    tmpVert :=Math.Min(Round(l),ArrowHeight);
    SinA:= dy / l;
    CosA:= dx / l;

    xb:= ToPoint.x*CosA - ToPoint.y*SinA;
    yb:= ToPoint.x*SinA + ToPoint.y*CosA;

    x := xb - tmpVert;
    y := yb - tmpHoriz*0.5;
    pc:=CalcArrowPoint;

    y := yb + tmpHoriz*0.5;
    pd:=CalcArrowPoint;

    if Filled then
    Begin
      tmpHoriz4:=tmpHoriz*(ArrowPercent*0.005);
      y := yb - tmpHoriz4;
      pe:=CalcArrowPoint;

      y := yb + tmpHoriz4;
      pf:=CalcArrowPoint;

      x := FromPoint.x*cosa - FromPoint.y*sina;
      y := yb - tmpHoriz4;
      pg:=CalcArrowPoint;

      y := yb + tmpHoriz4;
      ph:=CalcArrowPoint;

      To3D:=ToPoint;
      Calc3DTPoint(To3D,Z);

      Polygon([ ph,pg,pe,pc,To3D,pd,pf ]);
    end
    else
    begin
      LineWithZ(FromPoint,ToPoint,z);
      LineTo3D(pd.x,pd.y,z);
      LineWithZ(ToPoint,pc,z);
    end
  end;
end;

{ TTeeShadow }
Constructor TTeeShadow.Create(AOnChange:TNotifyEvent);
begin
  inherited Create;
  FSmooth:=True;
  IOnChange:=AOnChange;

  FColor:=clSilver;
  DefaultColor:=FColor;

  FVisible:=True;
  DefaultVisible:=FVisible;
end;

Procedure TTeeShadow.Assign(Source:TPersistent);
begin
  if Source is TTeeShadow then
  With TTeeShadow(Source) do
  begin
    Self.FColor        :=Color;
    Self.FHorizSize    :=HorizSize;
    Self.FSmooth       :=Smooth;
    Self.FSmoothBlur   :=SmoothBlur;
    Self.FTransparency :=Transparency;
    Self.FVertSize     :=VertSize;
    Self.FVisible      :=Visible;
  end
  else
    inherited;
end;

procedure TTeeShadow.Changed;
begin
  if Assigned(IOnChange) then IOnChange(Self);
end;

Procedure TTeeShadow.InitValues(AColor:TColor; ASize:Integer);
begin
  FColor:=AColor;
  DefaultColor:=FColor;

  FHorizSize:=ASize;
  FVertSize:=ASize;
  DefaultSize:=ASize;
end;

Procedure TTeeShadow.SetIntegerProperty(Var Variable:Integer; Const Value:Integer);
begin
  if Variable<>Value then
  begin
    Variable:=Value;
    Changed;
  end;
end;

Procedure TTeeShadow.SetClip(const Value:Boolean);
begin
  if FClip<>Value then
  begin
    FClip:=Value;
    Changed;
  end;
end;

Procedure TTeeShadow.SetColor(Value:TColor);
begin
  if FColor<>Value then
  begin
    FColor:=Value;
    Changed;
  end;
end;

Procedure TTeeShadow.SetHorizSize(Value:Integer);
begin
  SetIntegerProperty(FHorizSize,Value);
end;

Procedure TTeeShadow.SetVertSize(Value:Integer);
begin
  SetIntegerProperty(FVertSize,Value);
end;

Procedure TTeeShadow.SetVisible(Value:Boolean);
begin
  if FVisible<>Value then
  begin
    FVisible:=Value;
    Changed;
  end;
end;

function TTeeShadow.GetSize: Integer;
begin
  result:=Math.Max(HorizSize,VertSize)
end;

procedure TTeeShadow.SetSize(const Value: Integer);
begin
  HorizSize:=Value;
  VertSize:=Value;
end;

procedure TTeeShadow.SetSmooth(const Value: Boolean);
begin
  if FSmooth<>Value then
  begin
    FSmooth:=Value;
    Changed;
  end;
end;

procedure TTeeShadow.SetSmoothBlur(const Value: Integer);
begin
  if FSmoothBlur<>Value then
  begin
    FSmoothBlur:=Value;
    Changed;
  end;
end;

procedure TTeeShadow.SetTransparency(Value: TTeeTransparency);
begin
  if FTransparency<>Value then
  begin
    FTransparency:=Value;
    Changed;
  end;
end;

Function TTeeShadow.PrepareCanvas(ACanvas:TCanvas3D; const R:TRect;
                                  Z:Integer=0):Boolean;
begin
  result:=(Color<>clNone) and ((HorizSize<>0) or (VertSize<>0));

  if result then
  begin
    if (not Smooth) or (not ValidCanvas(ACanvas)) then
    With ACanvas do
    begin
      Brush.Color:=Self.Color;
      Brush.Style:=bsSolid;
      Pen.Style:=psClear;
    end;

    if Transparency>0 then
       IBlend:=ACanvas.BeginBlending(ACanvas.RectFromRectZ(TeeRect(R.Left+HorizSize,
                                R.Top+VertSize,R.Right+HorizSize,R.Bottom+VertSize),Z),
                                Transparency);
  end;
end;

procedure TTeeShadow.FinishBlending(ACanvas:TTeeCanvas);
begin
  if Transparency>0 then
     ACanvas.EndBlending(IBlend);
end;

{$IFDEF CLR}
{$UNSAFECODE ON}
{$ENDIF}

procedure TeeCalcLines(var Lines:TRGBArray; Bitmap:TBitmap);
var y   : Integer;
    {$IFNDEF CLR}
    Dif : Integer;
    {$ENDIF}
    tmp : Integer;
begin
  Bitmap.PixelFormat:=TeePixelFormat;

  tmp:=Bitmap.Height;

  SetLength(Lines,tmp);

  if tmp>0 then
  with Bitmap do
  begin
    {$IFDEF CLR}
    for y:=0 to tmp-1 do
        Lines[y]:=ScanLine[y].ToPointer;
    {$ELSE}
    Lines[0]:=ScanLine[0];

    if tmp>1 then
    begin
      Lines[1]:=ScanLine[1];

      Dif:=Integer(Lines[1])-Integer(Lines[0]);

      for y:=2 to tmp-1 do
          Lines[y]:=Pointer(Integer(Lines[y-1])+Dif);
    end;
    {$ENDIF}
  end;
end;

procedure TeeShadowSmooth(Bitmap,Back:TBitmap;
          Left, Top, Width, Height, horz, vert:Integer;
          Smoothness:Double; FullDraw:Boolean;
          ACanvas:TCanvas3D; Clip:Boolean); {$IFDEF CLR}unsafe;{$ENDIF}

const
  WeightFactor=100000;

  function CalcWeight(const x, middle, width:Integer):Integer;
  begin
    if width=0 then
       result:=WeightFactor
    else
       result:=Round(Math.Power(Smoothness, -(1 / width) * Sqr(middle - x))*WeightFactor);
  end;

const
  Inv255=1/255;

var t : packed Array of packed Array of TRGB;
    w, h,
    row, col,
    x, y,
    tmpMinCol,
    tmpMaxCol,
    tmpMinRow,
    tmpMaxRow,
    wMinusHr2,
    hMinusVr2,
    i, hr2, vr2 : Integer;
    weights : packed Array of Integer;
    InvWeightSum : Double;
    r,g,b,
    tmp,
    WeightSum : Integer;
    tmpLines : PRGBs;
    tmpColor : TRGB;
    Lines,
    IBackLines : TRGBArray;
    tmpDrawOk : Boolean;

    {$IFNDEF CLX}
    tmpDC : TTeeCanvasHandle;
    {$ENDIF}
begin
  w:=Width;
  h:=Height;

  TeeCalcLines(Lines,Bitmap);

  SetLength(t,h);
  for i:=0 to h-1 do
      SetLength(t[i],w);

  hr2:=horz * 2 + 1;
  vr2:=vert * 2 + 1;

  Smoothness:=0.01*(Smoothness+180);

  SetLength(weights,hr2);
  for i:=0 to hr2-1 do
      weights[i]:=CalcWeight(i-horz, 0, horz);

  if Left<0 then tmpMinCol:= -Left
            else tmpMinCol:=0;

  if Top<0 then tmpMinRow:= -Top
           else tmpMinRow:=0;

  if Assigned(Back) then
  begin
    if w+Left >= Back.Width then
       tmpMaxCol:=Back.Width-Left-1
    else
       tmpMaxCol:=w-1;

    if h+Top >= Back.Height then
       tmpMaxRow:=Back.Height-Top-1
    else
       tmpMaxRow:=h-1;
  end
  else
  begin
    tmpMaxCol:=w-1;
    tmpMaxRow:=h-1;
  end;

  wMinusHr2:=w-hr2;
  hMinusVr2:=h-vr2;

  // Horizontal
  for row:=tmpMinRow to tmpMaxRow do
  begin
    tmpLines:=Lines[row];

    tmpDrawOk:=FullDraw or (row >= hMinusVr2);

    for col:=tmpMinCol to tmpMaxCol do
    begin
      if tmpDrawOk or (col>=wMinusHr2) then
      begin
        r:=0;
        g:=0;
        b:=0;
        weightsum:=0;

        x:=col-horz;

        if x < 0 then
        begin
          i:= -x;
          x:=0;
        end
        else
          i:=0;

        while i < hr2 do
        begin
          if x >= w then
              break;

          tmp:=weights[i];

          with tmpLines[x] do
          begin
            Inc(r, Red * tmp);
            Inc(g, Green * tmp);
            Inc(b, Blue * tmp);
          end;

          Inc(WeightSum,tmp);

          Inc(i);
          Inc(x);
        end;

        with t[row, col] do
        if WeightSum=0 then
        begin
          Red := r;
          Green := g;
          Blue := b;
        end
        else
        begin
          InvWeightSum:= 1/WeightSum;

          Red := Round(r * InvWeightSum);
          Green := Round(g * InvWeightSum);
          Blue := Round(b * InvWeightSum);
        end
      end;
    end;
  end;

  if Assigned(Back) then
     TeeCalcLines(IBackLines,Back);

  SetLength( weights , vr2);
  for i:=0 to vr2-1 do
      weights[i]:=CalcWeight(i-vert, 0, vert);

  {$IFNDEF CLX}
  if Clip then
     tmpDC:=ACanvas.Handle
  else
     tmpDC:=0;
  {$ENDIF}

  // Vertical
  for col:=tmpMinCol to tmpMaxCol do
  begin
    tmpDrawOk:=FullDraw or (col>=wMinusHr2);

    for row:=tmpMinRow to tmpMaxRow do
    begin
      if tmpDrawOk or (row>=hMinusVr2) then
      {$IFNDEF CLX}
      if (not Clip) or PtVisible(tmpDC,col+Left,row+Top) then  // clip test (slow!)
      {$ENDIF}
      begin
        r:=0;
        g:=0;
        b:=0;
        weightsum:=0;

        y:=row-vert;

        if y < 0 then
        begin
          i:= -y;
          y:=0;
        end
        else
          i:=0;

        while i < vr2 do
        begin
          if y >= h then
              break;

          tmp:=Weights[i];

          with t[y, col] do
          begin
            Inc(r, Red * tmp);
            Inc(g, Green * tmp);
            Inc(b, Blue * tmp);
          end;

          Inc(WeightSum,tmp);

          Inc(i);
          Inc(y);
        end;

        if Assigned(Back) then
        begin
          InvWeightSum:= Inv255/WeightSum;

          with IBackLines[row+Top,col+Left] do
          begin
            Red  :=Round(r * InvWeightSum * Red);
            Green:=Round(g * InvWeightSum * Green);
            Blue :=Round(b * InvWeightSum * Blue);
          end;
        end
        else
        begin
          InvWeightSum:= 1/WeightSum;

          with Lines[row, col] do
          begin
            Red  :=Round(r * InvWeightSum);
            Green:=Round(g * InvWeightSum);
            Blue :=Round(b * InvWeightSum);
          end;
        end;
      end;
    end;
  end;

  Weights:=nil;
  t:=nil;

  Lines:=nil;
  IBackLines:=nil;
end;

procedure TTeeShadow.DrawSmooth(ACanvas:TCanvas3D; const Rect:TRect;
                                Ellipse,Polygon:Boolean;
                                RoundSize:Integer;
                                const P:TPointArray);
var tmpB : TBitmap;
    tmpR : TRect;
    tmpW : Integer;
    tmpH : Integer;
    tmpHorizSize : Integer;
    tmpVertSize  : Integer;
begin
  tmpB:=TBitmap.Create;
  try
    tmpB.PixelFormat:=TeePixelFormat;

    tmpHorizSize:=Abs(HorizSize);
    tmpVertSize:=Abs(VertSize);

    tmpW:=Max(1,1+Rect.Right-Rect.Left+2*tmpHorizSize);
    tmpH:=Max(1,1+Rect.Bottom-Rect.Top+2*tmpVertSize);

    TeeSetBitmapSize(tmpB,tmpW,tmpH);

    tmpR:=TeeRect(tmpHorizSize,tmpVertSize,
                  tmpB.Width-tmpHorizSize,
                  tmpB.Height-tmpVertSize);

    tmpB.Canvas.Brush.Color:=Color;
    tmpB.Canvas.Brush.Style:=bsSolid;
    tmpB.Canvas.Pen.Style:=psClear;

    if Polygon then
       tmpB.Canvas.Polygon(P)
    else
    if Ellipse then
       {$IFDEF D5}
       tmpB.Canvas.Ellipse(tmpR)
       {$ELSE}
       with tmpR do
            tmpB.Canvas.Ellipse(Left,Top,Right,Bottom)
       {$ENDIF}
    else
    if RoundSize=0 then
       {$IFDEF D5}
       tmpB.Canvas.Rectangle(tmpR)
       {$ELSE}
       with tmpR do
            tmpB.Canvas.Rectangle(Left,Top,Right,Bottom)
       {$ENDIF}
    else
    with tmpR do
       tmpB.Canvas.RoundRect(Left,Top,Right,Bottom,RoundSize,RoundSize);

    with Rect do
      TeeShadowSmooth(tmpB,TTeeCanvas3D(ACanvas).FBitmap,
                      Left,
                      Top,
                      tmpW,tmpH,
                      tmpHorizSize,tmpVertSize,
                      0.01*(SmoothBlur+180),
                      Ellipse or Polygon or FullDraw or (RoundSize<>0),
                      ACanvas,Clip);
  finally
    tmpB.Free;
  end;
end;
{$IFDEF CLR}
{$UNSAFECODE OFF}
{$ENDIF}

procedure TTeeShadow.Draw(ACanvas: TCanvas3D; const P:{$IFDEF D5}Array of TPoint{$ELSE}TPointArray{$ENDIF});
var R : TRect;
    t : Integer;
    tmp : TPointArray;
begin
  SetLength(tmp,Length(P));
  try
    for t:=0 to Length(tmp)-1 do
    begin
      tmp[t].X:=P[t].X+HorizSize;
      tmp[t].Y:=P[t].Y+VertSize;
    end;

    R:=PolygonBounds(tmp);

    if PrepareCanvas(ACanvas,R) then
    begin
      if Smooth and ValidCanvas(ACanvas) then
      begin
        for t:=0 to Length(tmp)-1 do
        begin
          Dec(tmp[t].X,R.Left);
          Dec(tmp[t].Y,R.Top);
        end;

        DrawSmooth(ACanvas,R,False,True,0,tmp);
      end
      else
        ACanvas.Polygon(tmp);

      FinishBlending(ACanvas);
    end;

  finally
    tmp:=nil;
  end;
end;

procedure TTeeShadow.Draw(ACanvas: TCanvas3D; const Rect: TRect);
begin
  Draw(ACanvas,Rect,0);
end;

function TTeeShadow.ValidCanvas(ACanvas:TCanvas3D):Boolean;
begin
  result:=(ACanvas is TTeeCanvas3D) and (not ACanvas.Metafiling) and
           Assigned(TTeeCanvas3D(ACanvas).FBitmap);
end;

procedure TTeeShadow.Draw(ACanvas:TCanvas3D; Const Rect:TRect; Z:Integer;
                          RoundSize:Integer=0);

  procedure DrawRoundRect;
  var tmpR : TRect;
  begin
    tmpR:=Rect;
    OffsetRect(tmpR,HorizSize,VertSize);
    ACanvas.RoundRect(tmpR,RoundSize,RoundSize);
  end;

var tmpDelta : Integer;
    tmpRGB   : TRGB;

  Procedure CalcDelta(ASize:Integer);
  begin
    with tmpRGB do
         tmpDelta:=Round((255-((Blue+Green+Red)/3.0))/ASize);
  end;

var t    : Integer;
    tmp  : Integer;
    tmp2 : Integer;
    Is3D : Boolean;
begin
  Is3D:=ACanvas.IDisabledRotation=0;

  if PrepareCanvas(ACanvas,Rect,Z) then
  begin
    if Smooth and (Size<>0) then
    begin
      if ValidCanvas(ACanvas) then
         DrawSmooth(ACanvas,Rect,False,False,RoundSize,nil)
      else
      begin
        if RoundSize>0 then
           DrawRoundRect
        else
        with Rect do
        begin
          tmpRGB:=RGBValue(ColorToRGB(Color));

          ACanvas.Pen.Style:=psSolid;

          if VertSize<>0 then
          begin
            ACanvas.Pen.Color:=Color;
            CalcDelta(VertSize);

            for t:=1 to VertSize do
            begin
              if Is3D then
                 ACanvas.HorizLine3D(Left+HorizSize,Right+HorizSize-VertSize+t-1,Bottom+t-1,Z)
              else
                 ACanvas.DoHorizLine(Left+HorizSize,Right+HorizSize-VertSize+t-1,Bottom+t-1);

              ACanvas.Pen.Color:=ApplyBright(ACanvas.Pen.Color,tmpDelta);
            end;
          end;

          if HorizSize<>0 then
          begin
            ACanvas.Pen.Color:=Color;
            CalcDelta(HorizSize);

            for t:=1 to HorizSize do
            begin
              if Is3D then
              begin
                ACanvas.VertLine3D(Right+t-1,Top+VertSize,Bottom+VertSize-HorizSize+t-1,Z);
                ACanvas.Pixels3D[Right+t-2,Bottom+VertSize-HorizSize+t-2,Z]:=ACanvas.Pen.Color;
              end
              else
              begin
                ACanvas.DoVertLine(Right+t-1,Top+VertSize,Bottom+VertSize-HorizSize+t-1);
                ACanvas.Pixels[Right+t-2,Bottom+VertSize-HorizSize+t-2]:=ACanvas.Pen.Color;
              end;

              ACanvas.Pen.Color:=ApplyBright(ACanvas.Pen.Color,tmpDelta);
            end;
          end;
        end;
      end;
    end
    else
    with Rect do
    begin
      if RoundSize>0 then
         DrawRoundRect
      else
      if Is3D then
      begin
        ACanvas.Rectangle(Left+HorizSize,Bottom,Right+HorizSize,Bottom+VertSize,Z);
        ACanvas.Rectangle(Right,Top+VertSize,Right+HorizSize,Bottom+VertSize,Z);
      end
      else
      begin
        if VertSize<>0 then
        begin
          if VertSize>0 then
          begin
            tmp:=Bottom;
            tmp2:=tmp+1;
          end
          else
          begin
            tmp:=Top+1;
            tmp2:=tmp-1;
          end;

          ACanvas.Rectangle(Left+HorizSize,tmp,Right+HorizSize,tmp2+VertSize);
        end;

        if HorizSize<>0 then
        begin
          if HorizSize>0 then
          begin
            tmp:=Right;
            tmp2:=tmp+1;
          end
          else
          begin
            tmp:=Left+1;
            tmp2:=tmp-1;
          end;

          ACanvas.Rectangle(tmp,Top+VertSize,tmp2+HorizSize,Bottom+VertSize+1);
        end;
      end;
    end;

    FinishBlending(ACanvas);
  end;
end;

procedure TTeeShadow.DrawEllipse(ACanvas: TCanvas3D; const Rect: TRect;
                                 Z:Integer=0);
var tmpR : TRect;
begin
  if PrepareCanvas(ACanvas,Rect,Z) then
  begin
    if Smooth then
    begin
      with Rect do
           tmpR:=ACanvas.CalcRect3D(TeeRect(Left+HorizSize,Top+VertSize,
                                            Right+HorizSize,Bottom+VertSize),Z);

      if ValidCanvas(ACanvas) then
         DrawSmooth(ACanvas,tmpR,True,False,0,nil)
      else
      begin
        // Alternative: Draw gradient to simulate an elliptic shadow
        ACanvas.ClipEllipse(tmpR);

        with TTeeGradient.Create(nil) do
        try
          EndColor:=ApplyBright(Self.Color,32);
          StartColor:=ApplyDark(Self.Color,128);
          DrawRadial(ACanvas,tmpR);
        finally
          Free;
        end;

        ACanvas.UnClipRectangle;
      end;
    end
    else
    With Rect do
       ACanvas.EllipseWithZ(Left+HorizSize,Top+VertSize,
                            Right+HorizSize,Bottom+VertSize,Z);

    FinishBlending(ACanvas);
  end;
end;

function TTeeShadow.IsColorStored: Boolean;
begin
  result:=FColor<>DefaultColor;
end;

function TTeeShadow.IsHorizStored: Boolean;
begin
  result:=FHorizSize<>DefaultSize;
end;

function TTeeShadow.IsVertStored: Boolean;
begin
  result:=FVertSize<>DefaultSize;
end;

function TTeeShadow.IsVisibleStored: Boolean;
begin
  result:=FVisible<>DefaultVisible;
end;

{ TCustomTeeGradient }
Constructor TCustomTeeGradient.Create(ChangedEvent:TNotifyEvent);
Begin
  inherited Create;
  IChanged    :=ChangedEvent;
  FDirection  :=gdTopBottom;
  FStartColor :=clWhite;
  FEndColor   :=clYellow;
  FMidColor   :=clNone;
  FBalance    :=50;
End;

Destructor TCustomTeeGradient.Destroy;
begin
  FreeAndNil(FSub);
  inherited;
end;

Procedure TCustomTeeGradient.UseMiddleColor;
begin
  if not IHasMiddle then
  begin
    IHasMiddle:=True;
    DoChanged;
  end;
end;

Function TCustomTeeGradient.GetMidColor:TColor;
begin
  if IHasMiddle then result:=FMidColor
                else result:=clNone;
end;

Procedure TCustomTeeGradient.DoChanged;
begin
  if Assigned(IChanged) then IChanged(Self);
end;

Procedure TCustomTeeGradient.SetVisible(Value:Boolean);
Begin
  if FVisible<>Value then
  begin
    FVisible:=Value;
    DoChanged;
  end;
End;

Procedure TCustomTeeGradient.SetAngle(Value:Integer);
begin
  SetIntegerProperty(FAngle,Value);
end;

Procedure TCustomTeeGradient.SetBalance(Value:Integer);
begin
  SetIntegerProperty(FBalance,Value);
end;

Procedure TCustomTeeGradient.SetDirection(Value:TGradientDirection);
Begin
  if FDirection<>Value then
  Begin
    FDirection:=Value;
    DoChanged;
  end;
End;

Procedure TCustomTeeGradient.SetIntegerProperty(Var Variable:Integer; Value:Integer);
begin
  if Variable<>Value then
  begin
    Variable:=Value;
    DoChanged;
  end;
end;

Procedure TCustomTeeGradient.SetColorProperty(var Variable:TColor; const Value:TColor);
begin
  if Variable<>Value then
  begin
    Variable:=Value;
    DoChanged;
  end;
end;

Procedure TCustomTeeGradient.SetStartColor(Value:TColor);
Begin
  SetColorProperty(FStartColor,Value);
End;

Procedure TCustomTeeGradient.SetEndColor(Value:TColor);
Begin
  SetColorProperty(FEndColor,Value);
End;

Procedure TCustomTeeGradient.SetMidColor(Value:TColor);
Begin
  if IHasMiddle then { 5.02 }
  begin
    if Value=clNone then
    begin
      IHasMiddle:=False;
      DoChanged;
    end
    else
      SetColorProperty(FMidColor,Value);
  end
  else
  if Value<>clNone then
  begin
    IHasMiddle:=True;
    FMidColor:=Value;
    DoChanged;
  end;
End;

Procedure TCustomTeeGradient.Assign(Source:TPersistent);
Begin
  if Source is TCustomTeeGradient then
  With TCustomTeeGradient(Source) do
  Begin
    Self.FAngle     :=FAngle;
    Self.FBalance   :=FBalance;
    Self.FDirection :=FDirection;
    Self.FEndColor  :=FEndColor;
    Self.FMidColor  :=FMidColor;
    Self.FRadialX   :=FRadialX;
    Self.FRadialY   :=FRadialY;
    Self.FStartColor:=FStartColor;

    if Assigned(FSub) then
       SubGradient:=FSub
    else
       FreeAndNil(FSub);

    Self.FVisible   :=FVisible;
    Self.IHasMiddle :=IHasMiddle;
  end
  else inherited;
end;

function TCustomTeeGradient.GetSub:TSubGradient;
begin
  if not Assigned(FSub) then
  begin
    FSub:=TSubGradient.Create(IChanged);
    FSub.FTransparency:=50;
  end;

  result:=FSub;
end;

procedure TCustomTeeGradient.SetSub(const Value:TSubGradient);
begin
  GetSub.Assign(Value);
  FSub.FTransparency:=Value.Transparency;
end;

{$IFNDEF CLX}
{$IFNDEF CLR}
{$DEFINE USEFASTBRUSH}
{$ENDIF}
{$ENDIF}

Procedure TCustomTeeGradient.DrawRadial(Canvas:TTeeCanvas; Rect:TRect);
var tmpRect : TRect;

  Procedure DoRadialGradient;
  var Step,
      SizeX,
      SizeY,
      t,
      e0,e1,e2 : Integer;
      xc,yc,
      InvStep,
      tmpD,
      tmpX,
      tmpY,
      sx,
      sy : Double;
      dr,
      dg,
      db : Double;
      OldBrushColor : TColor;
      OldPenStyle   : TPenStyle;
      {$IFDEF USEFASTBRUSH}
      IsFastBrush   : Boolean;
      tmpDc         : TTeeCanvasHandle;
      {$ENDIF}
  begin
    RectSize(tmpRect,SizeX,SizeY);

    Step:=Math.Min(255,Math.Max(SizeX,SizeY));
    InvStep:=1/Step;

    sx:=0.5*SizeX*InvStep;
    sy:=0.5*SizeY*InvStep;

    e0:=GetRValue(StartColor);
    e1:=GetGValue(StartColor);
    e2:=GetBValue(StartColor);

    if Balance=50 then
    begin
      dr:=(GetRValue(EndColor)-e0)*InvStep;
      dg:=(GetGValue(EndColor)-e1)*InvStep;
      db:=(GetBValue(EndColor)-e2)*InvStep;
    end
    else
    begin
      dr:=(GetRValue(EndColor)-e0);
      dg:=(GetGValue(EndColor)-e1);
      db:=(GetBValue(EndColor)-e2);
    end;

    OldPenStyle:=Canvas.Pen.Style;
    Canvas.Pen.Style:=psClear;

    OldBrushColor:=Canvas.Brush.Color;
    try
      Canvas.Brush.Color:=EndColor;
      Canvas.FillRect(tmpRect);

      if ((SizeX mod 2)=1) or ((SizeY mod 2)=1) then Dec(Step);

      xc:=1+RadialX+((tmpRect.Left+tmpRect.Right)*0.5);
      yc:=1+RadialY+((tmpRect.Top+tmpRect.Bottom)*0.5);

      {$IFDEF USEFASTBRUSH}
      IsFastBrush:=Assigned(@TeeSetDCBrushColor);
      if IsFastBrush then
      begin
        tmpDC:=Canvas.Handle;
        SelectObject(tmpDC,GetStockObject(DC_BRUSH));
      end
      else
        tmpDC:=0;
      {$ENDIF}

      for t:=Step downto 0 do
      begin
        if Balance=50 then
          {$IFDEF USEFASTBRUSH}
          if IsFastBrush then
             TeeSetDCBrushColor(tmpDC,RGB(e0+Round(dr*t),e1+Round(dg*t),e2+Round(db*t)))
          else
          {$ENDIF}
             Canvas.Brush.Color:=RGB(e0+Round(dr*t),e1+Round(dg*t),e2+Round(db*t))
        else
        begin
          tmpD:=TeeSigmoid(t,Balance,Step);
          {$IFDEF USEFASTBRUSH}
          if IsFastBrush then
             TeeSetDCBrushColor(tmpDC,(( e0 + Round(tmpD*dr) ) or
                              (( e1 + Round(tmpD*dg) ) shl 8) or
                              (( e2 + Round(tmpD*db) ) shl 16)))
          else
          {$ENDIF}
            Canvas.Brush.Color:=(( e0 + Round(tmpD*dr) ) or
                                (( e1 + Round(tmpD*dg) ) shl 8) or
                                (( e2 + Round(tmpD*db) ) shl 16));
        end;

        tmpX:=t*sx;
        tmpY:=t*sy;
        Canvas.Ellipse(Round(xc-tmpX),Round(yc-tmpY),Round(xc+tmpX),Round(yc+tmpY));
      end;

    finally
      Canvas.Brush.Color:=OldBrushColor;
      Canvas.Pen.Style:=OldPenStyle;
    end;
  end;

begin
  tmpRect:=OrientRectangle(Rect);

  {$IFDEF CLX}
  Canvas.FCanvas.Start;
  {$ELSE}
  Canvas.ClipRectangle(tmpRect);
  {$ENDIF}

  DoRadialGradient;

  {$IFDEF CLX}
  Canvas.FCanvas.Stop;
  {$ELSE}
  Canvas.UnClipRectangle;
  {$ENDIF}

  if Assigned(FSub) and FSub.Visible then
     DrawSubGradient(Canvas,Rect);
end;

procedure TCustomTeeGradient.DrawRotated(Canvas:TTeeCanvas; const R:TRect);
var b   : TBitmap;
    tmp : TTeeCanvas3D;
    Sin,
    Cos : Extended;
    Old,
    h,
    w   : Integer;
begin
  b:=TBitmap.Create;
  try
    w:=R.Right-R.Left;
    h:=R.Bottom-R.Top;

    SinCos((360-FAngle)*TeePiStep,Sin,Cos);

    if Sin*Cos>0 then
       TeeSetBitmapSize(b,2+Abs(Round(w*Cos+h*Sin)),2+Abs(Round(w*Sin+h*Cos)))
    else
       TeeSetBitmapSize(b,2+Abs(Round(w*Cos-h*Sin)),2+Abs(Round(w*Sin-h*Cos)));

    tmp:=TTeeCanvas3D.Create;
    try
      tmp.UseBuffer:=False;
      tmp.ReferenceCanvas:=b.Canvas;

      Old:=FAngle;
      FAngle:=0;
      try
        Draw(tmp,TeeRect(0,0,b.Width,b.Height));
      finally
        FAngle:=Old;
      end;

      TeeGradientRotate(Self,b);

      with Canvas do
      begin
        ClipRectangle(R);

        Draw(R.Left-((b.Width-w) div 2),R.Top-((b.Height-h) div 2),b);

        Brush.Style:=bsClear;
        Rectangle(R);

        UnClipRectangle;
      end;
    finally
      tmp.Free;
    end;
  finally
    b.Free;
  end;
end;

procedure TCustomTeeGradient.DrawSubGradient(Canvas:TTeeCanvas; Const Rect:TRect;
                                             RoundRectSize:Integer=0);
var tmpBlend : TTeeBlend;
begin
  tmpBlend:=Canvas.BeginBlending(Rect,FSub.Transparency);
  try
    if FSub.Direction=gdRadial then
       FSub.DrawRadial(Canvas,Rect)
    else
       FSub.Draw(Canvas,Rect,RoundRectSize);
  finally
    Canvas.EndBlending(tmpBlend);
  end;
end;

procedure TCustomTeeGradient.Draw(Canvas:TCanvas3D; var P:TPointArray; Z:Integer; Is3D:Boolean);  // 7.0
var P2 : TPointArray;
    t  : Integer;
begin
  if Is3D then
  begin
    SetLength(P2,Length(P));
    try
      for t:=0 to Length(P)-1 do
          P2[t]:=Canvas.Calculate3DPosition(P[t],Z);

      Canvas.PolygonGradient(P2,Self);
    finally
      P2:=nil;
    end;
  end
  else
    Canvas.PolygonGradient(P,Self);
end;

Procedure TCustomTeeGradient.Draw( Canvas:TTeeCanvas; Const Rect:TRect;
                                   RoundRectSize:Integer=0);
var
  R : TRect;

  Procedure DoVert(C0,C1,C2,C3:TColor);
  begin
    R.Bottom:=(Rect.Bottom+Rect.Top) div 2;
    Canvas.GradientFill(R,C0,C1,Direction);
    R.Top:=R.Bottom;
    R.Bottom:=Rect.Bottom;
    Canvas.GradientFill(R,C2,C3,Direction);
  end;

  Procedure DoHoriz(C0,C1,C2,C3:TColor);
  begin
    R.Right:=(Rect.Left+Rect.Right) div 2;
    Canvas.GradientFill(R,C0,C1,Direction);
    R.Left:=R.Right;
    R.Right:=Rect.Right;
    Canvas.GradientFill(R,C2,C3,Direction);
  end;

  Function TryGrayColor(Const AColor:TColor):TColor;
  var tmp : Byte;
  begin
    if Canvas.Monochrome then
    begin
      with RGBValue(ColorToRGB(AColor)) do
           tmp:=(Blue+Green+Red) div 3;

      result:=RGB(tmp,tmp,tmp);
    end
    else result:=AColor;
  end;

var tmpMid   : TColor;
    tmpStart : TColor;
    tmpEnd   : TColor;
begin
  if FAngle<>0 then
     DrawRotated(Canvas,Rect)
  else
  begin
    tmpMid:=TryGrayColor(MidColor);
    tmpStart:=TryGrayColor(StartColor);
    tmpEnd:=TryGrayColor(EndColor);

    if RoundRectSize>0 then
       Canvas.ClipRectangle(Rect,RoundRectSize);

    if Direction=gdRadial then
       Canvas.GradientFill(Rect,tmpStart,tmpEnd,Direction)
    else
    if IHasMiddle and (Direction<>gdDiagonalUp) and (Direction<>gdDiagonalDown) then
    begin
      R:=Rect;

      Case Direction of
      gdTopBottom: DoVert(tmpMid,tmpEnd,tmpStart,tmpMid);
      gdBottomTop: DoVert(tmpStart,tmpMid,tmpMid,tmpEnd);
      gdLeftRight: DoHoriz(tmpMid,tmpEnd,tmpStart,tmpMid);
      gdRightLeft: DoHoriz(tmpStart,tmpMid,tmpMid,tmpEnd);
      else
         Canvas.GradientFill(Rect,tmpStart,tmpEnd,Direction)
      end;
    end
    else
       Canvas.GradientFill(Rect,tmpStart,tmpEnd,Direction,Balance);

    if RoundRectSize>0 then
       Canvas.UnClipRectangle;

    if Assigned(FSub) and FSub.Visible then
       DrawSubGradient(Canvas,Rect,RoundRectSize);
  end;
end;

procedure TCustomTeeGradient.SetRadialX(const Value: Integer);
begin
  SetIntegerProperty(FRadialX,Value);
end;

procedure TCustomTeeGradient.SetRadialY(const Value: Integer);
begin
  SetIntegerProperty(FRadialY,Value);
end;

procedure TCustomTeeGradient.Draw(Canvas: TTeeCanvas; var P: TFourPoints);
begin
  Canvas.Pen.Style:=psClear;
  Canvas.PolygonGradient(P,Self);
end;

Procedure TCustomTeeGradient.Draw(Canvas:TCanvas3D; var P:TFourPoints; Z:Integer);
var P2 : TFourPoints;
begin
  P2[0]:=Canvas.Calculate3DPosition(P[0],Z);
  P2[1]:=Canvas.Calculate3DPosition(P[1],Z);
  P2[2]:=Canvas.Calculate3DPosition(P[2],Z);
  P2[3]:=Canvas.Calculate3DPosition(P[3],Z);
  Draw(Canvas,P2);
end;

{ TSubGradient }
procedure TSubGradient.SetTransparency(const Value:TTeeTransparency);
begin
  if FTransparency<>Value then
  begin
    FTransparency:=Value;
    DoChanged;
  end;
end;

{ TTeeFont }
Constructor TTeeFont.Create(ChangedEvent:TNotifyEvent);
begin
  inherited Create;

  Color:=clBlack;
  IDefColor:=clBlack;

  {$IFNDEF CLX}
  if CharSet<>DEFAULT_CHARSET then
     CharSet:=DEFAULT_CHARSET;
  {$ENDIF}

  Name:=GetDefaultFontName;

  if Size<>GetDefaultFontSize then
     Size:=GetDefaultFontSize;

  OnChange:=ChangedEvent; { at the create end... 5.02 }
end;

Destructor TTeeFont.Destroy;
begin
  FPicture.Free;
  FOutLine.Free;
  FShadow.Free;
  FGradient.Free;

{ 5.01 removed, ICanvas might be corrupt in some circumstances }
{  if Assigned(ICanvas) and (ICanvas.IFont=Self) then ICanvas.IFont:=nil; }

  inherited;
end;

Procedure TTeeFont.Assign(Source:TPersistent);
begin
  if Source is TTeeFont then
  With TTeeFont(Source) do
  begin
    Self.Gradient      :=FGradient;
    Self.FInterCharSize:=FInterCharSize;
    Self.OutLine       :=FOutLine;
    Self.Shadow        :=FShadow;
    Self.Picture       :=FPicture;
  end;

  inherited;
end;

Procedure TTeeFont.SetInterCharSize(Value:Integer);
begin
  if Value<>FInterCharSize then
  begin
    FInterCharSize:=Value;
    if Assigned(OnChange) then OnChange(Self);
  end;
end;

function TTeeFont.GetOutLine: TChartHiddenPen;
begin
  if not Assigned(FOutLine) then
     FOutLine:=TChartHiddenPen.Create(OnChange);

  result:=FOutLine;
end;

Procedure TTeeFont.SetOutLine(Value:TChartHiddenPen);
begin
  if Assigned(Value) then OutLine.Assign(Value)
                     else FreeAndNil(FOutLine);
end;

function TTeeFont.GetPicture: TTeePicture;
begin
  if not Assigned(FPicture) then
     FPicture:=TTeePicture.Create;

  result:=FPicture;
end;

Function TTeeFont.GetShadow:TTeeShadow;
begin
  if not Assigned(FShadow) then
     FShadow:=TTeeShadow.Create(OnChange);

  result:=FShadow;
end;

Procedure TTeeFont.SetPicture(Value:TTeePicture);
begin
  if Assigned(Value) then Picture.Assign(Value)
                     else FreeAndNil(FPicture);
end;

Procedure TTeeFont.SetShadow(Value:TTeeShadow);
begin
  if Assigned(Value) then Shadow.Assign(Value)
                     else FreeAndNil(FShadow);
end;

function TTeeFont.IsHeightStored: Boolean;
begin
  result:=Size<>GetDefaultFontSize;
end;

function TTeeFont.IsNameStored: Boolean;
begin
  result:=Name<>GetDefaultFontName;
end;

function TTeeFont.IsStyleStored: Boolean;
begin
  result:=Style<>IDefStyle;
end;

Function TTeeFont.IsColorStored:Boolean;
begin
  result:=Color<>IDefColor;
end;

procedure TTeeFont.DoChanged(Sender:TObject);
begin
  Changed;
end;

function TTeeFont.GetGradient: TTeeFontGradient;
begin
  if not Assigned(FGradient) then
     FGradient:=TTeeFontGradient.Create(DoChanged);

  result:=FGradient;
end;

procedure TTeeFont.SetGradient(const Value: TTeeFontGradient);
begin
  if Assigned(Value) then Gradient.Assign(Value)
                     else FreeAndNil(FGradient);
end;

{ Util functions }
Procedure SwapDouble(Var a,b:Double); {$IFDEF D10}inline;{$ENDIF}
var tmp : Double;
begin
  tmp:=a; a:=b; b:=tmp;
end;

Procedure SwapInteger(Var a,b:Integer); {$IFDEF D10}inline;{$ENDIF}
var tmp : Integer;
begin
  tmp:=a; a:=b; b:=tmp;
  // asm bswap eax  // <-- D2005 and BDS2006 can't inline assembler
end;

{$IFDEF TEEVCL}

{ TTeeButton }
Procedure TTeeButton.DrawSymbol(ACanvas:TTeeCanvas); // virtual; abstract;
begin
end;

function TTeeButton.SymbolRectangle:TRect;
Const tmpWidth={$IFDEF CLX}15{$ELSE}19{$ENDIF};
var  tmp : Integer;
begin
  tmp:=Height div 4;
  result:=TeeRect(Width-tmpWidth,Height-3*tmp,Width-6,Height-tmp);
end;

{$IFNDEF CLX}
{$IFNDEF LCL}
procedure TTeeButton.WMPaint(var Message: TWMPaint);
begin
  ControlState:=ControlState+[csCustomPaint];
  inherited;
  ControlState:=ControlState-[csCustomPaint];
end;
{$ENDIF}

procedure TTeeButton.CMTextChanged(var Message: TMessage);  // 7.0
begin
  inherited;
  Invalidate;
end;

procedure TTeeButton.PaintWindow(DC: HDC);
var tmp : TTeeCanvas;
begin
  inherited;

  tmp:=TTeeCanvas3D.Create;
  with tmp do
  try
    ReferenceCanvas:=TCanvas.Create;
    try
      ReferenceCanvas.Handle:=DC;
      DrawSymbol(tmp);
    finally
      ReferenceCanvas.Free;
    end;
  finally
    Free;
  end;
end;

procedure TTeeButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Repaint;
end;
{$ELSE}
procedure TTeeButton.Painting(Sender: QObjectH; EventRegion: QRegionH);
var tmp : TTeeCanvas3D;
begin
  inherited;

  tmp:=TTeeCanvas3D.Create;
  with tmp do
  try
    ReferenceCanvas:=TQtCanvas.Create;
    try
      ReferenceCanvas.Handle:=Handle;
      {$IFNDEF LINUX}  // Kylix bug
      DrawSymbol(tmp);
      {$ENDIF}
    finally
      ReferenceCanvas.Free;
    end;
  finally
    Free;
  end;
end;
{$ENDIF}

procedure TTeeButton.LinkProperty(AInstance: TObject;
  const PropName: String);
begin
  Instance:=AInstance;
  
  if Assigned(Instance) then
  begin
    if PropName='' then
       Info:=nil
    else
       Info:=GetPropInfo(Instance{$IFNDEF D5}.ClassInfo{$ENDIF},PropName);

    Invalidate;  // 5.02
  end;
end;
{$ENDIF}

{$IFNDEF D5}
procedure FreeAndNil(var Obj);
var P : TObject;
begin
  P:=TObject(Obj);
  TObject(Obj):=nil;
  P.Free;
end;
{$ENDIF}

{$IFNDEF TEEVCL}
procedure FreeAndNil(var Obj);
//var P : TObject;
begin
  P:=TObject(Obj);
  TObject(Obj):=nil;
  P.Free;
end;

type
  Exception=class(TObject)
  private
    FMessage: string;
  public
    Constructor Create(S:String);
  end;

  EConvertError=class(Exception);

Constructor Exception.Create(S:String);
begin
  FMessage:=S;
end;

function StrToInt(const S: string): Integer;
var E: Integer;
begin
  Val(S, Result, E);
  if E <> 0 then
     raise EConvertError.Create('Invalid integer: '+S); // Do not localize
end;

function ColorToRGB(Color: TColor): Longint;
begin
  if Color < 0 then
    Result := GetSysColor(Color and $000000FF) else
    Result := Color;
end;

{$IFNDEF LINUX}
function SafeLoadLibrary(const Filename: string; ErrorMode: UINT = SEM_NOOPENFILEERRORBOX): HMODULE;
var
  OldMode: UINT;
  FPUControlWord: Word;
begin
  OldMode := SetErrorMode(ErrorMode);
  try
    asm
      FNSTCW  FPUControlWord
    end;
    try
      Result := LoadLibrary(PChar(Filename));
    finally
      asm
        FNCLEX
        FLDCW FPUControlWord
      end;
    end;
  finally
    SetErrorMode(OldMode);
  end;
end;
{$ELSE}
function SafeLoadLibrary(const FileName: string; Dummy: LongWord): HMODULE;
var
  FPUControlWord: Word;
begin
  asm
    FNSTCW  FPUControlWord
  end;
  try
    Result := LoadLibrary(PChar(Filename));
  finally
    asm
      FNCLEX
      FLDCW FPUControlWord
    end;
  end;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
var
{ Win32 platform identifier.  This will be one of the following values:

    VER_PLATFORM_WIN32s
    VER_PLATFORM_WIN32_WINDOWS
    VER_PLATFORM_WIN32_NT

  See WINDOWS.PAS for the numerical values. }

  Win32Platform: Integer = 0;

{ Win32 OS version information -

  see TOSVersionInfo.dwMajorVersion/dwMinorVersion/dwBuildNumber }

  Win32MajorVersion: Integer = 0;
  Win32MinorVersion: Integer = 0;
  Win32BuildNumber: Integer = 0;


procedure InitPlatformId;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
    with OSVersionInfo do
    begin
      Win32Platform := dwPlatformId;
      Win32MajorVersion := dwMajorVersion;
      Win32MinorVersion := dwMinorVersion;
      if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
        Win32BuildNumber := dwBuildNumber and $FFFF
      else
        Win32BuildNumber := dwBuildNumber;
      //Win32CSDVersion := szCSDVersion;
    end;
end;
{$ENDIF}

{$ENDIF}

Procedure TeeDefaultFont;
Begin
  GetDefaultFontSize:=StrToInt(TeeMsg_DefaultFontSize);

  {$IFNDEF CLR}
  {$IFNDEF CLX}
  {$IFNDEF LCL}
  {$IFDEF TEEVCL}
  {$DEFINE USESYSLOCALE}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  {$IFDEF USESYSLOCALE}
  if (GetDefaultFontSize=8) and (SysLocale.PriLangID=LANG_JAPANESE) then
      GetDefaultFontSize:=-MulDiv(DefFontData.Height,72,Screen.PixelsPerInch);
  {$ENDIF}

  GetDefaultFontName:=TeeMsg_DefaultFontName;

  {$IFDEF USESYSLOCALE}
  if (GetDefaultFontName='Arial') and // Do not localize
     (SysLocale.PriLangID=LANG_JAPANESE) then
        GetDefaultFontName:=DefFontData.Name;
  {$ENDIF}
end;

{$IFNDEF LINUX}

const
  MSIMG32DLL='msimg32.dll'; // Do not localize

{$IFDEF CLR}
[DllImport(MSIMG32DLL, CharSet = CharSet.Ansi, EntryPoint = 'AlphaBlend')] // Do not localize
function AlphaBlendProc(DC: HDC; p2, p3, p4, p5: Integer;
                          DC6: HDC; p7, p8, p9, p10: Integer;
                          p11: TBlendFunction): BOOL; external;
{$ELSE}

type
  AlphaBlendType=function(DC: HDC; p2, p3, p4, p5: Integer;
                          DC6: HDC; p7, p8, p9, p10: Integer;
                          p11: TBlendFunction): BOOL; stdcall;
{$ENDIF}
{$ENDIF}

var
  CanUseWinAlphaBlend : Boolean=False;

  {$IFNDEF LINUX}
  {$IFNDEF CLR}
  AlphaBlendProc      : AlphaBlendType=nil;
  {$ENDIF}
  {$ENDIF}

procedure TeeBlendBitmaps(Const Percent: Double; ABitmap,BBitmap:TBitmap; BOrigin:TPoint);
const
  BytesPerPixel={$IFDEF CLX}4{$ELSE}3{$ENDIF};

{$IFNDEF D5}
type
  PColor = ^TColor;
{$ENDIF}

var tmpW     : Integer;
    tmpH     : Integer;

    {$IFNDEF CLX}
    BlendFunc: BLENDFUNCTION;
    {$ENDIF}

    {$IFNDEF CLR}
    tmpX     : Integer;
    tmpY     : Integer;

    {$IFDEF CLX}
    tmpScanA : PRGBs;
    tmpScanB : PRGBs;
    {$ELSE}

    tmpScanA : PByteArray;
    tmpScanB : PByteArray;
    Line0A   : PByteArray;
    Line0B   : PByteArray;
    DifA     : Integer;
    DifB     : Integer;
    {$ENDIF}

    tmpXB3   : Integer;
    p        : PChar;
    pc       : PChar;
    Percent1 : Integer;
    tmpBBitmap : TBitmap;
    {$ENDIF}
begin
  ABitmap.PixelFormat:=TeePixelFormat;
  BBitmap.PixelFormat:=TeePixelFormat;

  if BOrigin.Y<0 then BOrigin.Y:=0;
  if BOrigin.X<0 then BOrigin.X:=0;

  tmpW:=Math.Min(ABitmap.Width,BBitmap.Width-BOrigin.X);
  tmpH:=Math.Min(ABitmap.Height,BBitmap.Height-BOrigin.Y);

  if (tmpW>0) and (tmpH>0) then  // 7.0 fix
  begin

    {$IFNDEF CLX}
    {$IFNDEF LCL}
    if CanUseWinAlphaBlend then
    begin
      // Alphablend fails in Win98

      BlendFunc.BlendOp:=AC_SRC_OVER;
      BlendFunc.BlendFlags:=0;
      BlendFunc.SourceConstantAlpha:=255-Round(Percent*2.55);
      BlendFunc.AlphaFormat:=0;
      AlphaBlendProc(BBitmap.Canvas.Handle, BOrigin.X, BOrigin.Y, tmpW, tmpH,
                     ABitmap.Canvas.Handle,0,0,tmpW,tmpH, BlendFunc);
      Exit;
    end;
    {$ENDIF}
    {$ENDIF}

    {$IFNDEF CLR}

    {$IFNDEF LINUX}
    tmpBBitmap:=BBitmap;
    {$ELSE}
    tmpBBitmap:=TBitmap.Create;
    TeeSetBitmapSize(tmpBBitmap,BBitmap.Width,BBitmap.Height);

    QPixmap_setOptimization( BBitmap.Handle, QPixmapOptimization_BestOptim );
    QPixmap_setOptimization( tmpBBitmap.Handle, QPixmapOptimization_BestOptim );
    BitBlt( tmpBBitmap.Handle, 0, 0, BBitmap.Handle, 0, 0, 
            BBitmap.Width, BBitmap.Height, RasterOp_CopyROP, true );
    {$ENDIF}

    Percent1:=100-Round(Percent);

    {$IFNDEF CLX}
    {$IFNDEF LCL}
    Line0A:=ABitmap.ScanLine[0];
    Line0B:=tmpBBitmap.ScanLine[BOrigin.Y];

    if tmpH>1 then  // 7.0 fix
    begin
      DifA:=Integer(ABitmap.ScanLine[1])-Integer(Line0A);
      DifB:=Integer(tmpBBitmap.ScanLine[BOrigin.Y+1])-Integer(Line0B);
    end
    else
    begin
      DifA:=0;
      DifB:=0;
    end;
    {$ENDIF}
    {$ENDIF}

    for tmpY:=0 to tmpH-1 do
    begin
      {$IFNDEF CLX}
      // faster version
      tmpScanA:=PByteArray(Integer(Line0A)+DifA*tmpY);
      tmpScanB:=PByteArray(Integer(Line0B)+DifB*tmpY);
      {$ELSE}
      {$IFNDEF LCL}
      // slower (safer?) version
      tmpScanA:=ABitmap.ScanLine[tmpY];
      tmpScanB:=tmpBBitmap.ScanLine[tmpY+BOrigin.Y];
      {$ENDIF}
      {$ENDIF}

      for tmpX:=0 to tmpW-1 do
      begin
        tmpXB3:=(tmpX+BOrigin.X){$IFNDEF CLX}*BytesPerPixel{$ENDIF};
        pc:=PChar(@tmpScanB[tmpXB3]);

        if PColor(pc)^=$FFFFFF then  // Already white color
           {$IFDEF CLX}
           tmpScanB[tmpXB3].Blue:=$FF-1;
           {$ELSE}
           tmpScanB[tmpXB3+2]:=$FF-1;
           {$ENDIF}

        {$IFDEF CLX}
        p:=@tmpScanA[tmpX];
        {$ELSE}
        p:=PChar(@tmpScanA[tmpX*BytesPerPixel]);
        {$ENDIF}

        PByte(pc)^:=Byte(pc^)+((Percent1*(Byte(p^)-Byte(pc^))) div 100);
        Inc(pc);
        PByte(pc)^:=Byte(pc^)+((Percent1*(Byte((p+1)^)-Byte(pc^))) div 100);
        Inc(pc);
        PByte(pc)^:=Byte(pc^)+((Percent1*(Byte((p+2)^)-Byte(pc^))) div 100);
      end;
    end;

    {$IFDEF LINUX}
    BitBlt( BBitmap.Handle, 0, 0,
            tmpBBitmap.Handle, 0, 0, BBitmap.Width, BBitmap.Height, RasterOp_CopyROP, true );
    FreeAndNil(tmpBBitmap);
    {$ENDIF}

    {$ENDIF}
  end;
end;

{ TTeeBlend }
Constructor TTeeBlend.Create(ACanvas: TTeeCanvas; const R: TRect);
begin
  inherited Create;
  FCanvas:=ACanvas;
  SetRectangle(R);
end;

Destructor TTeeBlend.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

Procedure TTeeBlend.SetRectangle(Const R:TRect);
var tmp  : TCanvas;
    tmpW : Integer;
    tmpH : Integer;
begin
  FRect:=OrientRectangle(R);

  with FRect do
  begin
    if Left<0 then Left:=0;
    if Top<0 then Top:=0;
    if Right<0 then Right:=0;
    if Bottom<0 then Bottom:=0;

    if Right-Left<1 then Right:=Left+1;  // 7.0 fix
    if Bottom-Top<1 then Bottom:=Top+1;

    if Right>FCanvas.Bounds.Right then
       Right:=FCanvas.Bounds.Right;

    if Bottom>FCanvas.Bounds.Bottom then
       Bottom:=FCanvas.Bounds.Bottom;

    tmpW:=(Right-Left);
    tmpH:=(Bottom-Top);
  end;

  IValidSize:=(tmpW>0) and (tmpH>0);

  if IValidSize then
  begin
    // speed optimization, recreate FBitmap instead of reusing it
    FBitmap.Free;
    FBitmap:=TBitmap.Create;

    With FBitmap do
    begin
      {$IFDEF IGNOREPALETTE}
      IgnorePalette:=True;
      {$ENDIF}
      PixelFormat:=TeePixelFormat;
    end;

    TeeSetBitmapSize(FBitmap,tmpW,tmpH);

    if (FCanvas is TTeeCanvas3D) and Assigned((FCanvas as TTeeCanvas3D).Bitmap) then
       tmp:=(FCanvas as TTeeCanvas3D).Bitmap.Canvas
    else
       tmp:=FCanvas.ReferenceCanvas;

    FBitmap.Canvas.CopyRect( TeeRect(0,0,tmpW,tmpH), tmp, FRect );
  end;
end;

// BCB5 BUG. Package TeeXC5.bpr should include -$O- in PFLAGS (disable optim.)
// Otherwise, there's an AV here when compiling apps only when "using packages"
procedure TTeeBlend.DoBlend(Transparency: TTeeTransparency);
var tmp       : TBitmap;
    tmpNew    : Boolean;
    tmpPoint  : TPoint;
    {$IFNDEF CLX}
    tmpAlign  : TCanvasTextAlign;
    {$ENDIF}
begin
  if not FCanvas.Metafiling then  // 7.0
  if IValidSize then
  begin
    tmp:=TTeeCanvas3D(FCanvas).Bitmap;

    tmpNew:=not Assigned(tmp);

    if tmpNew then
    begin
      tmp:=TBitmap.Create;
      {$IFDEF IGNOREPALETTE}
      tmp.IgnorePalette:=True;
      {$ENDIF}

      TeeSetBitmapSize(tmp,FRect.Right-FRect.Left,FRect.Bottom-FRect.Top);

      { 5.03 fixed. (Blend inverted rect params) }
      tmp.Canvas.CopyRect(TeeRect(0,0,tmp.Width,tmp.Height),FCanvas.ReferenceCanvas,FRect);
      tmpPoint:=TeePoint(0,0);
    end
    else tmpPoint:=FRect.TopLeft;

    {$IFDEF CLX}
    FCanvas.ReferenceCanvas.Stop;
    {$ELSE}
    tmpAlign:=FCanvas.TextAlign;
    {$ENDIF}

    TeeBlendBitmaps(100-Transparency,FBitmap,tmp,tmpPoint);

    {$IFNDEF CLX}
    if FCanvas.TextAlign<>tmpAlign then
    begin
      if Assigned(FCanvas.IFont) then
         FCanvas.AssignFont(FCanvas.IFont);

      FCanvas.TextAlign:=tmpAlign;
    end;
    {$ENDIF}

    if tmpNew then
    begin
      FCanvas.Draw(FRect.Left,FRect.Top,tmp);
      tmp.Free;
    end;
  end;
end;

{$IFDEF CLX}

{ TUpDown }
Constructor TUpDown.Create(AOwner:TComponent);
begin
  inherited;
  Height:=22;
end;

procedure TUpDown.Change(AValue: Integer);
begin
  inherited;
  if (not IChangingText) and
     Assigned(FAssociate) and
     (not (csDesigning in FAssociate.ComponentState)) and
     (FAssociate is TCustomEdit) then
  begin
    DoChangeEdit;
    if Assigned(OldChanged) then OldChanged(FAssociate);
  end;
end;

procedure TUpDown.ChangedEdit(Sender: TObject);
begin
  if not IChangingText then
  begin
    if TCustomEdit(Sender).Text='' then
       Value:=Min
    else
    begin
      IChangingText:=True;
      Value:=StrToIntDef(TCustomEdit(Sender).Text,Value);
      IChangingText:=False;
    end;
  end;
  if Assigned(OldChanged) then OldChanged(FAssociate);
end;

function TUpDown.GetPosition: Integer;
begin
  result:=Value;
end;

type
  TCustomEditAccess=class(TCustomEdit);

procedure TUpDown.Loaded;
begin
  inherited;
  Height:=23;
  Width:=18;
  GetOldChanged;
end;

Procedure TUpDown.GetOldChanged;
begin
  if Assigned(FAssociate) and
     (FAssociate is TCustomEdit) and
     (not (csDesigning in FAssociate.ComponentState)) then
  begin
    ChangedEdit(TCustomEdit(FAssociate));     
    if @OldChanged=nil then
    begin
      OldChanged:=TCustomEditAccess(FAssociate).OnChange;
      TCustomEditAccess(FAssociate).OnChange:=ChangedEdit;
    end;
  end;
end;

procedure TUpDown.SetAssociate(const AValue: TComponent);
begin
  if Assigned(FAssociate) and
     (FAssociate is TCustomEdit) and
     (not (csDesigning in FAssociate.ComponentState)) and
     (not Assigned(AValue)) then
       TCustomEditAccess(FAssociate).OnChange:=OldChanged;

  FAssociate:=AValue;
//  GetOldChanged;
end;

procedure TUpDown.SetPosition(const AValue: Integer);
begin
  Value:=AValue;
  if Assigned(Associate) and (Associate is TCustomEdit) then
     DoChangeEdit;
end;

Procedure TUpDown.DoChangeEdit;
begin
  IChangingText:=True;
  try
    TCustomEdit(Associate).Text:=IntToStr(Value);
  finally
    IChangingText:=False;
  end;
end;
{$ENDIF}

{$IFDEF TEEVCL}

{ EditColor }
Function EditColor(AOwner:TComponent; AColor:TColor):TColor;
Begin
  With TColorDialog.Create(AOwner) do
  try
    Color:=AColor;

    {$IFNDEF LCL}
    if not Assigned(TeeCustomEditColors) then
       TeeCustomEditColors:=TStringList.Create
    else
       CustomColors:=TeeCustomEditColors;
    {$ENDIF}
    
    if Execute then
    begin
      {$IFNDEF LCL}
      TeeCustomEditColors.Assign(CustomColors);
      {$ENDIF}
      result:=Color;
    end
    else
      result:=AColor;
  finally
    Free;
  end;
end;

{ Show the TColorDialog, return True if color changed }
Function EditColorDialog(AOwner:TComponent; var AColor:TColor):Boolean;
var tmpNew : TColor;
begin
  tmpNew:=EditColor(AOwner,AColor);
  result:=tmpNew<>AColor;
  if result then AColor:=tmpNew;
end;

{ TButtonColor }
procedure TButtonColor.Click;
var tmp : TColor;
begin
  tmp:=GetSymbolColor;

  if EditColorDialog(Self,tmp) then
  begin
    SymbolColor:=tmp;
    Repaint;
    inherited;
  end;
end;

Function TButtonColor.GetSymbolColor:TColor;
begin
  if Assigned(GetColorProc) then
     result:=GetColorProc
  else
  if Assigned(Info) then result:=ColorToRGB(GetOrdProp(Instance,Info)) { 5.03 }
                    else result:=FSymbolColor;
end;

procedure TButtonColor.SetSymbolColor(Const Value:TColor); // 7.0
begin
  if Assigned(Info) then SetOrdProp(Instance,Info,Value)
                    else FSymbolColor:=Value;
end;

procedure TButtonColor.DrawSymbol(ACanvas:TTeeCanvas);
begin
  With ACanvas do
  begin
    Brush.Color:=SymbolColor;

    if Brush.Color<>clNone then
    begin
      if not Enabled then
         Pen.Style:=psClear;

      Rectangle(SymbolRectangle);
    end;
  end;
end;

{ TComboFlat }
constructor TComboFlat.Create(AOwner: TComponent);
begin
  inherited;
  Height:=21;
  ItemHeight:=13;
  Style:=csDropDownList;
end;

procedure TComboFlat.Add(const Item:String);
begin
  Items.Add(Item);
end;

function TComboFlat.GetDropWidth:Integer;
begin
  HandleNeeded;
  
  {$IFDEF CLX}
  result:=Width;
  {$ELSE}
  result:=Perform(CB_GETDROPPEDWIDTH, 0, 0);
  {$ENDIF}
end;

function TComboFlat.IsDropWidthStored:Boolean;
begin
  result:=Width<>DropDownWidth;
end;

procedure TComboFlat.SetDropWidth(const Value:Integer);
begin
  HandleNeeded;

  {$IFDEF CLX}
  Width:=Value;
  {$ELSE}
  Perform(CB_SETDROPPEDWIDTH, Value, 0);
  {$ENDIF}
end;

{$IFDEF CLX}
procedure TComboFlat.AddItem(Item: String; AObject: TObject);
begin
  Items.AddObject(Item, AObject);
end;
{$ELSE}
{$IFNDEF D6}
procedure TComboFlat.AddItem(Item: String; AObject: TObject);
begin
  Items.AddObject(Item, AObject);
end;
{$ENDIF}
{$ENDIF}

function TComboFlat.CurrentItem:String;
begin
  if ItemIndex=-1 then result:=''
                  else result:=Items[ItemIndex];
end;

function TComboFlat.SelectedObject:TObject;
begin
  if ItemIndex=-1 then result:=nil
                  else result:=Items.Objects[ItemIndex];
end;

{$IFNDEF CLX}
{$IFNDEF LCL}
procedure TComboFlat.WMPaint(var Message: TWMPaint);
var R : TRect;
begin
  inherited;

  if (not Inside) and (not Focused) then
  begin
    with TControlCanvas.Create do
    try
      Control:=Self;
      Pen.Color:=clBtnFace;
      Brush.Style:=bsClear;
      R:=ClientRect;

      {$IFNDEF D5}
      with R do Rectangle(Left,Top,Right,Bottom);
      {$ELSE}
      Rectangle(R);
      {$ENDIF}

      InflateRect(R,-1,-1);

      {$IFNDEF D5}
      with R do Rectangle(Left,Top,Right,Bottom);
      {$ELSE}
      Rectangle(R);
      {$ENDIF}

      R.Left:=R.Right-GetSystemMetrics(SM_CXSIZE)-2;

      Inc(R.Top);
      Dec(R.Bottom);
      Pen.Color:=clWindow;

      {$IFNDEF D5}
      with R do Rectangle(Left,Top,Right,Bottom);
      {$ELSE}
      Rectangle(R);
      {$ENDIF}

      MoveTo(R.Right-2,R.Top);
      LineTo(R.Right-2,R.Bottom);
    finally
      Free;
    end;
  end;
end;
{$ENDIF}

procedure TComboFlat.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  Inside:=True;
  Repaint;
end;

procedure TComboFlat.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  Inside:=False;
  Repaint;
end;

{$IFNDEF CLR}
{$IFNDEF LCL}
procedure TComboFlat.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
  Inside:=False;
  Repaint;
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}

{ TTeeFontGradient }

procedure TTeeFontGradient.SetOutline(const Value: Boolean);
begin
  SetBooleanProperty(FOutline,Value);
end;

Procedure TTeeFontGradient.SetBooleanProperty( Var Variable:Boolean;
                                               Const Value:Boolean);
begin
  if Variable<>Value then
  begin
    Variable:=Value;
    DoChanged;
  end;
end;

{ TWhitePen }
constructor TWhitePen.Create(OnChangeEvent: TNotifyEvent);
begin
  inherited;
  Color:=clWhite;
end;

Function TWhitePen.IsVisibleStored:Boolean;
begin
  result:=True;
end;


// Returns point "ATo" minus ADist pixels from AFrom point.
Function PointAtDistance(AFrom,ATo:TPoint; ADist:Integer):TPoint;
var tmpSin : Extended;
    tmpCos : Extended;
begin
  result:=ATo;
  if ATo.X<>AFrom.X then
  begin
    SinCos({$IFDEF CLR}Borland.VCL.{$ENDIF}Math.ArcTan2((ATo.Y-AFrom.Y),(ATo.X-AFrom.X)),tmpSin,tmpCos);
    Dec(result.X,Round(ADist*tmpCos));
    Dec(result.Y,Round(ADist*tmpSin));
  end
  else
  begin
    if ATo.Y<AFrom.Y then Inc(result.Y,ADist)
                     else Dec(result.Y,ADist);
  end;
end;

Function TeeDistance(const x,y:Double):Double; {$IFDEF D9}inline;{$ENDIF}  // 7.0 changed to "double"
begin
  result:=Sqrt(Sqr(x)+Sqr(y));
end;

{$IFNDEF CLR}
// Anders Melander Resample.pas
// www.melander.dk  anders@aztech.dk
// Improvements suggested by David Ullrich.
// Modified and optimized for speed by David Berneda.

type
  TFilterValue=Single;

  // Type of a filter for use with Stretch()
  TFilterProc=function(Value: TFilterValue): TFilterValue;

  // Physical bitmap pixel
  TColorRGB = packed record
    r, g, b : Byte;
    {$IFDEF CLX}
    a       : Byte;
    {$ENDIF}
  end;
  PColorRGB = ^TColorRGB;

  {$IFDEF USE_SCANLINE}
  // Physical bitmap scanline (row)
  TRGBList = packed array[0..0] of TColorRGB;
  PRGBList = ^TRGBList;
  {$ENDIF}

{$R-}

procedure SmoothStretch(Src, Dst: TBitmap; Filter: TFilterProc; const fwidth: TFilterValue); overload;
type
  // Contributor for a pixel
  TContributor=packed record
    Pixel  : Integer; // Source pixel
    Weight : Integer; // Pixel weight
  end;

  TContributorArray=packed Array[0..0] of TContributor;
  PContributorArray=^TContributorArray;

const
  WeightMultiplier=1024;
  MaxRGB=256*WeightMultiplier;

var
  ContribN : packed Array of Integer;
  ContribP : packed Array of PContributorArray;

  procedure CalcSampling(const SrcSize,DstSize:Integer; Scale:TFilterValue);
  var i : Integer;
      j : Integer;
      TwoSizeMinusOne : Integer;
      WeightScale : TFilterValue;
      fScale,
      Width,
      Center : TFilterValue;
  begin
    fScale :=1.0/Scale;
    if Scale >= 1 then
       Scale:=1;

    Width:=fWidth * fScale;
    WeightScale:=WeightMultiplier*Scale;
    TwoSizeMinusOne:=SrcSize+SrcSize-1;

    for i:=0 to DstSize-1 do
    begin
      ContribN[i]:=0;
      Center:= i * fscale;

      for j:=Floor(Center - Width) to Ceil(Center + Width) do
      with ContribP[i,ContribN[i]] do
      begin
        Weight:=Round(WeightScale * Filter( (Center - j) * Scale) );

        if Weight<>0 then
        begin
          if j < 0 then
             Pixel := -j
          else
          if j >= SrcSize then
             Pixel := TwoSizeMinusOne - j
          else
             Pixel := j;

          Inc(ContribN[i]);

          if Pixel<0 then
             Pixel:=-Pixel;
        end;
      end;
    end;
  end;

  {$IFNDEF USE_SCANLINE}
  function Color2RGB(Color: TColor): TColorRGB;
  begin
    {$IFDEF CLX}
    result.a :=0;
    {$ENDIF}
    Result.r := Color AND $000000FF;
    Result.g := (Color AND $0000FF00) SHR 8;
    Result.b := (Color AND $00FF0000) SHR 16;
  end;

  function RGB2Color(const Color: TColorRGB): TColor;
  begin
    Result := Color.r OR (Color.g SHL 8) OR (Color.b SHL 16);
  end;
  {$ENDIF}

var
  Work	    : TBitmap;
  SrcHeight,
  DstWidth  : Integer;

  procedure FilterHorizontally;
  var {$IFDEF USE_SCANLINE}
      SourceLine : PRGBList;
      {$ELSE}
      DestColor  : TColorRGB;
      {$ENDIF}

      k : Integer;
      i : Integer;
      j : Integer;

      rgbr,
      rgbg,
      rgbb  : Integer;

      DestPixel  : PColorRGB;
      tmp : PContributorArray;
  begin
    {$IFNDEF USE_SCANLINE}
    DestPixel:=@DestColor;
    {$ENDIF}

    for k:=0 to SrcHeight-1 do
    begin
      {$IFDEF USE_SCANLINE}
      SourceLine := Src.ScanLine[k];
      DestPixel  := Work.ScanLine[k];
      {$ENDIF}

      for i:=0 to DstWidth-1 do
      begin
        tmp:=ContribP[i];

        rgbr:=0;
        rgbg:=0;
        rgbb:=0;

        for j:=0 to ContribN[i]-1 do
        with {$IFDEF USE_SCANLINE}
             PColorRGB(Integer(SourceLine)+tmp[j].Pixel*3)^ do
             {$ELSE}
             Color2RGB(Src.Canvas.Pixels[tmp[j].Pixel,k]) do
             {$ENDIF}
        begin
          Inc(rgbr, r * tmp[j].Weight);
          Inc(rgbg, g * tmp[j].Weight);
          Inc(rgbb, b * tmp[j].Weight);
        end;

        with DestPixel^ do
        begin
          if rgbr > MaxRGB then
             r := 255
          else
          if rgbr < 0 then
             r := 0
          else
             r := rgbr shr 10;

          if rgbg > MaxRGB then
             g := 255
          else
          if rgbg < 0 then
             g := 0
          else
             g := rgbg shr 10;

          if rgbb > MaxRGB then
             b := 255
          else
          if rgbb < 0 then
             b := 0
          else
             b := rgbb shr 10;
        end;

        {$IFDEF USE_SCANLINE}
        Inc(DestPixel);
        {$ELSE}
        Work.Canvas.Pixels[i,k]:=RGB2Color(DestPixel^);
        {$ENDIF}
      end;
    end;
  end;

var
  DstHeight : Integer;

  procedure FilterVertically;
  var {$IFDEF USE_SCANLINE}
      DestLine   : PRGBList;
      {$ENDIF}
      Delta,
      k : Integer;
      i : Integer;
      j,
      rgbr,
      rgbg,
      rgbb  : Integer;

      {$IFDEF USE_SCANLINE}
      DestDelta	 : Integer;
      SourceLine : PRGBList;
      {$ELSE}
      DestColor : TColorRGB;
      {$ENDIF}

      DestPixel  : PColorRGB;
      tmp : PContributorArray;
  begin
    {$IFDEF USE_SCANLINE}
    SourceLine:= Work.ScanLine[0];
    Delta:= Integer(Work.ScanLine[1]) - Integer(SourceLine);
    DestLine:= Dst.ScanLine[0];
    DestDelta:= Integer(Dst.ScanLine[1]) - Integer(DestLine);
    {$ELSE}
    DestPixel:=@DestColor;
    {$ENDIF}

    for k:= 0 to DstWidth-1 do
    begin
      {$IFDEF USE_SCANLINE}
      DestPixel:=Pointer(DestLine);
      {$ENDIF}

      for i:= 0 to DstHeight-1 do
      begin
        tmp:=ContribP[i];

        rgbr:=0;
        rgbg:=0;
        rgbb:=0;

        for j:= 0 to ContribN[i]-1 do
        with {$IFDEF USE_SCANLINE}
             PColorRGB(Integer(SourceLine)+tmp[j].Pixel*Delta)^ do
             {$ELSE}
             Color2RGB(Work.Canvas.Pixels[k, tmp[j].Pixel]) do
             {$ENDIF}
        begin
          Inc(rgbr, r * tmp[j].Weight);
          Inc(rgbg, g * tmp[j].Weight);
          Inc(rgbb, b * tmp[j].Weight);
        end;

        with DestPixel^ do
        begin
          if rgbr > MaxRGB then
             r := 255
          else
          if rgbr < 0 then
             r := 0
          else
             r := rgbr shr 10;

          if rgbg > MaxRGB then
             g := 255
          else
          if rgbg < 0 then
             g := 0
          else
             g := rgbg shr 10;

          if rgbb > MaxRGB then
             b := 255
          else
          if rgbb < 0 then
             b := 0
          else
             b := rgbb shr 10;
        end;

        {$IFDEF USE_SCANLINE}
        Inc(Integer(DestPixel), DestDelta);
        {$ELSE}
        Dst.Canvas.Pixels[k, i] := RGB2Color(DestPixel^);
        {$ENDIF}
      end;

      {$IFDEF USE_SCANLINE}
      Inc(SourceLine);
      Inc(DestLine);
      {$ENDIF}
    end;
  end;

var Scale : TFilterValue; // Zoom scale factor
    i,
    tmpSize,
    tmpSize2,
    SrcWidth : Integer;
begin
  if (not Assigned(Dst)) or (not Assigned(Src)) then Exit;

  DstWidth := Dst.Width;
  DstHeight := Dst.Height;
  SrcWidth := Src.Width;
  SrcHeight := Src.Height;

  if (SrcWidth <= 1) or (SrcHeight <= 1) then Exit;
  if (DstWidth <= 1) or (DstHeight <= 1) then Exit;

  // Create intermediate image to hold horizontal zoom
  Work:=TBitmap.Create;
  try
    {$IFDEF USE_SCANLINE}
    // This implementation only works on 24-bit images because it uses
    // TBitmap.Scanline
    Src.PixelFormat := TeePixelFormat;
    Dst.PixelFormat := TeePixelFormat;
    Work.PixelFormat := TeePixelFormat;
    {$ENDIF}

    TeeSetBitmapSize(Work,DstWidth,SrcHeight);

    tmpSize:=Max(DstWidth,DstHeight);

    SetLength(ContribN, tmpSize);
    SetLength(ContribP, tmpSize);

    Scale:=Min((DstWidth - 1) / (SrcWidth - 1),(DstHeight - 1) / (SrcHeight - 1));
    tmpSize2:=Trunc((fwidth * (1.0 / Scale)) * 2.0) + 3;

    for i:= 0 to tmpSize-1 do
        GetMem(ContribP[i],tmpSize2*SizeOf(TContributor));

    // Pre-calculate filter contributions for a row
    CalcSampling(SrcWidth,DstWidth,(DstWidth - 1) / (SrcWidth - 1));

    // Apply filter to sample horizontally from Src to Work
    FilterHorizontally;

    // Pre-calculate filter contributions for a column
    CalcSampling(SrcHeight,DstHeight,(DstHeight - 1) / (SrcHeight - 1));

    // Apply filter to sample vertically from Work to Dst
    FilterVertically;

    for i:=0 to Length(ContribP)-1 do
        FreeMem(ContribP[i]);

    ContribP:=nil;
    ContribN:=nil;
  finally
    Work.Free;
  end;
end;

// Lanczos3 filter
function Lanczos3Filter(Value: TFilterValue): TFilterValue;

  function SinC(const Value: TFilterValue): TFilterValue; {$IFDEF D9}inline;{$ENDIF}
  begin
    Result := Sin(Value) / Value
  end;

const PiDiv3 = Pi/3.0;
begin
  if Value < 0 then
     Value := -Value
  else
  if Value=0 then
  begin
    result:=1;
    exit;
  end;

  if Value < 3 then
     result:=SinC(Value*Pi) * SinC(Value*PiDiv3)
  else
     result:=0;
end;

function TriangleFilter(Value: TFilterValue): TFilterValue;
begin
  if (Value < 0.0) then
    Value := -Value;
  if (Value < 1.0) then
    Result := 1.0 - Value
  else
    Result := 0.0;
end;
{$ENDIF}

procedure SmoothStretch(Src, Dst: TBitmap); overload; {$IFDEF D9}inline;{$ENDIF}
begin
  SmoothStretch(Src,Dst,ssBestQuality);
end;

procedure SmoothStretch(Src, Dst: TBitmap; Option:TSmoothStretchOption); overload;
{$IFDEF CLR}
var g: System.Drawing.Graphics;
    i: System.Drawing.Image;
    r: System.Drawing.Rectangle;
    n: Integer;
begin
  if not Src.Empty then
  begin
    n:=Integer(Src.Handle);  // prevent longword-->integer overflow
    i:=System.Drawing.Image.FromHBitmap(IntPtr(n));
    n:=Integer(Dst.Canvas.Handle);  // prevent longword-->integer overflow
    g:=System.Drawing.Graphics.FromHdc(IntPtr(n));
    r:=System.Drawing.Rectangle.FromLTRB(0,0,Dst.Width,Dst.Height);
    g.InterpolationMode:=InterpolationMode.High;
    g.DrawImage(i,r);
    g.Free;
    i.Free;
  end;
end;
{$ELSE}
begin
  if Option=ssBestQuality then
     SmoothStretch(Src,Dst,Lanczos3Filter,3)  // Slower but big quality.
  else
     SmoothStretch(Src,Dst,TriangleFilter,1);  // Faster, but not big quality.
end;
{$ENDIF}

{$IFNDEF CLX}


{$IFDEF CLR}
Function CheckWinAlphaBlend:Boolean;
begin
  result:=True;
end;

{$ELSE}

var
  TeeMSIMG32:THandle=0;   // 7

Function CheckWinAlphaBlend:Boolean;
begin
  TeeMSIMG32:=TeeLoadLibrary(MSIMG32DLL);

  if TeeMSIMG32<>0 then
     @AlphaBlendProc:=GetProcAddress(TeeMSIMG32,'AlphaBlend') // Do not localize
  else
     @AlphaBlendProc:=nil;

  result:=@AlphaBlendProc<>nil;
end;

var TeeGDI32:THandle=0;   // 5.03

Procedure TryLoadSetDC;  // 7.0
begin
  TeeGDI32:=TeeLoadLibrary('gdi32.dll'); // Do not localize

  if TeeGDI32<>0 then
  begin
    @TeeSetDCBrushColor:=GetProcAddress(TeeGDI32,'SetDCBrushColor'); // Do not localize
    @TeeSetDCPenColor:=GetProcAddress(TeeGDI32,'SetDCPenColor'); // Do not localize
  end
  else
  begin
    TeeSetDCBrushColor:=nil;
    TeeSetDCPenColor:=nil;
  end;
end;
{$ENDIF}
{$ENDIF}

{$IFNDEF LINUX}
Function TeeLoadLibrary(Const FileName:String):HInst;
{$IFNDEF D5}
var OldError: Integer;
{$ENDIF}
begin
  {$IFNDEF D5}
  OldError:=SetErrorMode(SEM_NOOPENFILEERRORBOX);
  try
  {$ENDIF}
    result:={$IFDEF D5}SafeLoadLibrary{$ELSE}LoadLibrary{$ENDIF}({$IFNDEF D5}PChar{$ENDIF}(FileName));
  {$IFNDEF D5}
  finally
    SetErrorMode(OldError);
  end;
  {$ENDIF}
end;

// Free Library, but do not free library in Windows 95 (lock bug)
Procedure TeeFreeLibrary(hLibModule: HMODULE);
begin
  if (Win32Platform=VER_PLATFORM_WIN32_WINDOWS) and
     (Win32MinorVersion=0) then
  else
     FreeLibrary(hLibModule);
end;
{$ENDIF}

{$IFNDEF TEEVCL}
Procedure TPersistent.Assign(Source:TPersistent);
begin
  raise Exception.Create('Cannot assign TPersistent'); // Do not localize
end;

procedure TGraphicObject.Changed;
begin
end;

function TCanvas.GetPixel(X, Y: Integer): TColor;
begin
  result:=0;
end;

procedure TCanvas.SetPixel(X, Y: Integer; Value: TColor);
begin
end;

procedure TCanvas.CopyRect(const Dest: TRect; Canvas: TCanvas; const Source: TRect);
begin
end;

function TCanvas.TextExtent(const Text: string): TSize;
begin
  result.cx:=0;
  result.cy:=0;
end;

procedure TCanvas.Draw(X, Y: Integer; Graphic: TGraphic);
begin
end;

procedure TCanvas.StretchDraw(const Rect: TRect; Graphic: TGraphic);
begin
end;

Constructor TCustomPanel.Create(AOwner: TComponent);
begin
end;

procedure TCustomPanel.AssignTo(Dest: TPersistent);
begin
end;

procedure TCustomPanel.CreateParams(var Params: TCreateParams);
begin
end;

Procedure TCustomPanel.DefineProperties(Filer:TFiler);
begin
end;
{$ENDIF}

procedure CreateEmptyRegion;
begin
  {$IFNDEF CLX}
  OldRegion:=CreateRectRgn(0,0,0,0);
  {$ELSE}
//  OldRegion:=QRegion_create(0,0,0,0,QRegionRegionType_Rectangle);
  {$ENDIF}
end;

procedure DeleteEmptyRegion;
begin
  {$IFDEF CLX}
//  if Assigned(OldRegion) then QRegion_destroy(OldRegion);
  {$ELSE}
  if OldRegion>0 then DeleteObject(OldRegion);
  {$ENDIF}
end;

// Filters

{ TFilterRegion }

procedure TFilterRegion.Assign(Source:TPersistent);
begin
  if Source is TFilterRegion then
  with TFilterRegion(Source) do
  begin
    Self.FLeft:=FLeft;
    Self.FTop:=FTop;
    Self.FWidth:=FWidth;
    Self.FHeight:=FHeight;
  end
  else
    inherited;
end;

function TFilterRegion.GetRectangle:TRect;
begin
  result:=TeeRect(FLeft,FTop,FLeft+FWidth,FTop+FHeight);
end;

procedure TFilterRegion.SetRectangle(const Rect: TRect);
begin
  FLeft:=Rect.Left;
  FTop:=Rect.Top;
  FWidth:=Rect.Right-Rect.Left;
  FHeight:=Rect.Bottom-Rect.Top;
end;

{ TFilter }
Constructor TTeeFilter.Create(Collection: TCollection);
begin
  inherited;
  AllowRegion:=True;
  FEnabled:=True;
end;

Destructor TTeeFilter.Destroy;
begin
  Lines:=nil;
  FRegion.Free;
  inherited;
end;

procedure TTeeFilter.Apply(Bitmap:TBitmap);
var tmp : TRect;
begin
  if not Assigned(FRegion) then
     Apply(Bitmap,TeeRect(0,0,Bitmap.Width-1,Bitmap.Height-1))
  else
  begin
    tmp.Left:=FRegion.Left;
    tmp.Top:=FRegion.Top;

    if FRegion.Width=0 then
       tmp.Right:=Max(tmp.Left,Bitmap.Width-1)
    else
       tmp.Right:=Min(Bitmap.Width-1,tmp.Left+FRegion.Width);

    if Region.Height=0 then
       tmp.Bottom:=Max(tmp.Top,Bitmap.Height-1)
    else
       tmp.Bottom:=Min(Bitmap.Height-1,tmp.Top+FRegion.Height);

    Apply(Bitmap,tmp);
  end;
end;

procedure TTeeFilter.Apply(Bitmap:TBitmap; const R:TRect);
begin
  if not ReuseLines then
     CalcLines(Bitmap);
end;

class procedure TTeeFilter.ApplyTo(Bitmap: TBitmap);
begin
  with Create(nil) do
  try
    Apply(Bitmap);
  finally
    Free;
  end;
end;

class function TTeeFilter.Description:String;
begin
  result:=ClassName;
end;

procedure TTeeFilter.CalcLines(Bitmap:TBitmap);
begin
  TeeCalcLines(Lines,Bitmap);
end;

procedure TTeeFilter.CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent);
begin // No properties (abstract)
  FChanged:=AChanged;
end;

procedure TTeeFilter.Assign(Source: TPersistent);
begin
  if Source is TTeeFilter then
  begin
    Enabled:=TTeeFilter(Source).Enabled;
    Region:=TTeeFilter(Source).Region;
  end
  else
     inherited;
end;

function TTeeFilter.GetRegion: TFilterRegion;
begin
  if not Assigned(FRegion) then
     FRegion:=TFilterRegion.Create;

  result:=FRegion;
end;

{ TFilterItems }

function TFilterItems.Get(Index: Integer): TTeeFilter;
begin
  result:=TTeeFilter(GetItem(Index));
end;

procedure TFilterItems.Put(Index: Integer; const Value: TTeeFilter);
begin
  SetItem(Index,Value);
end;

function TFilterItems.Add(Filter:TFilterClass):TTeeFilter;
begin
  result:=Filter.Create(Self) as TTeeFilter;
end;

procedure TFilterItems.ApplyTo(ABitmap: TBitmap);
var t : Integer;
begin
  for t:=0 to Count-1 do
  with Item[t] do
  if Enabled then
     Apply(ABitmap);
end;

procedure TFilterItems.Assign(Source: TPersistent);
var t   : Integer;
    tmp : TTeeFilter;
begin
  if Source is TFilterItems then
  begin
    Clear;

    BeginUpdate;
    try

      with TFilterItems(Source) do
      for t:=0 to Count-1 do
      begin
        tmp:=TFilterClass(Item[t].ClassType).Create(Self);
        tmp.Assign(Item[t]);
      end;
    finally
      EndUpdate;
    end;
  end
  else inherited;
end;

{ TTeePicture }
Destructor TTeePicture.Destroy;
begin
  FFilters.Free;
  IBitmap.Free;
  inherited;
end;

procedure TTeePicture.DefineProperties(Filer:TFiler);
begin
  inherited;
  Filer.DefineProperty('FilterItems',DoReadFilters,DoWriteFilters,FiltersStored); // Do not localize
end;

procedure TTeePicture.Assign(Source: TPersistent);
begin
  if Source is TTeePicture then
     Filters:=TTeePicture(Source).FFilters;

  inherited;
end;

function TTeePicture.Filtered: TGraphic;
begin
  if (not FiltersStored) or (not Assigned(Graphic)) then
     result:=Graphic
  else
  begin
    if not Assigned(IBitmap) then
       IBitmap:=TBitmap.Create;

    IBitmap.Assign(Graphic);
    FFilters.ApplyTo(IBitmap);

    result:=IBitmap;
  end;
end;

function TTeePicture.FiltersStored:Boolean;
begin
  result:=Assigned(FFilters) and (FFilters.Count>0);
end;

function TTeePicture.GetFilters:TFilterItems;
begin
  if not Assigned(FFilters) then
     FFilters:=TFilterItems.Create(Self,TTeeFilter);

  result:=FFilters;
end;

{$IFNDEF CLR}
type
  TReaderAccess=class(TReader);
{$ENDIF}

class procedure TTeePicture.ReadFilters(Reader:TReader; Filters:TFilterItems);
var
  Item: TTeeFilter;
  tmp : String;
  tmpClass : TFilterClass;
begin
  Filters.BeginUpdate;
  try
    if not Reader.EndOfList then
       Filters.Clear;

    Reader.ReadValue;

    while not Reader.EndOfList do
    begin
      if Reader.NextValue in [vaInt8, vaInt16, vaInt32] then
         Reader.ReadInteger;

      Reader.ReadListBegin;

      tmp:=Reader.{$IFDEF LCL}Driver.{$ENDIF}ReadStr;
      tmp:=Reader.ReadString;

      tmpClass:=TFilterClass(FindClass(tmp));
      Item := Filters.Add(tmpClass);

      while not Reader.EndOfList do
            {$IFDEF CLR}
             Reader.GetType.InvokeMember('ReadProperty', // Do not localize
              BindingFlags.NonPublic or BindingFlags.Instance or BindingFlags.InvokeMethod,
              nil,Reader,[Item]);
            {$ELSE}
            TReaderAccess(Reader).ReadProperty(Item);
            {$ENDIF}

      Reader.ReadListEnd;
    end;

    Reader.ReadListEnd;
  finally
    Filters.EndUpdate;
  end;
end;

procedure TTeePicture.DoReadFilters(Reader: TReader);
begin
  ReadFilters(Reader,Filters);
end;

{$IFNDEF CLR}
type
  {$IFDEF LCL}
  TBinaryObjectWriterAccess=class(TBinaryObjectWriter);

  TFilerAccess=class(TWriter)
  private
    {$HINTS OFF}
    FDriver: Pointer;
    FDestroyDriver: Boolean;
    FRootAncestor: TComponent;
    {$HINTS ON}
    FPropPath: string;
  end;

  {$ELSE}

  TFilerAccess=class(TFiler)
  private
    {$HINTS OFF}
    FRootAncestor: TComponent;
    {$HINTS ON}
    FPropPath: string;
  end;

  {$ENDIF}

  TWriterAccess=class(TWriter);

{$ENDIF}

class procedure TTeePicture.WriteFilters(Writer: TWriter; Filters:TFilterItems);

  {$IFNDEF D5}
  procedure WriteProperties(Instance: TPersistent);
  var
    I, Count: Integer;
    PropInfo: PPropInfo;
    PropList: PPropList;
  begin
    Count := GetTypeData(Instance.ClassInfo)^.PropCount;
    if Count > 0 then
    begin
      GetMem(PropList, Count * SizeOf(Pointer));
      try
        GetPropInfos(Instance.ClassInfo, PropList);
        for I := 0 to Count - 1 do
        begin
          PropInfo := PropList^[I];
          if PropInfo = nil then break;
          if IsStoredProp(Instance, PropInfo) then
             TWriterAccess(Writer).WriteProperty(Instance, PropInfo);
        end;
      finally
        FreeMem(PropList, Count * SizeOf(Pointer));
      end;
    end;
    //Instance.DefineProperties(Self);
  end;
  {$ENDIF}

var
  t : Integer;
  v : TValueType;
  {$IFDEF CLR}
  tmp : FieldInfo;
  {$ENDIF}
begin
  v:=vaCollection;

  {$IFDEF LCL}
  TBinaryObjectWriterAccess(Writer.Driver).Write({$IFDEF CLR}Byte{$ENDIF}(v), SizeOf(v));
  {$ELSE}
  Writer.Write({$IFDEF CLR}Byte{$ENDIF}(v), SizeOf(v));
  {$ENDIF}

  for t:=0 to Filters.Count-1 do
  begin
    Writer.WriteListBegin;

    // EXTREME HACK ! SHOULD BE VERIFIED EVERY NEW RTL VERSION

    {$IFDEF CLR}
    tmp:=Writer.GetType.GetField('FPropPath',BindingFlags.Instance or BindingFlags.NonPublic);  // Do not localize
    tmp.SetValue(Writer,'');
    {$ELSE}
    TFilerAccess(Writer).FPropPath:='';
    {$ENDIF}

    {$IFDEF LCL}
    TBinaryObjectWriterAccess(Writer.Driver).WriteStr('ItemClass');  // Do not localize
    {$ELSE}
    Writer.WriteStr('ItemClass'); // Do not localize
    {$ENDIF}

    Writer.WriteString(Filters[t].ClassName);

    {$IFDEF CLR}
      Writer.GetType.InvokeMember('WriteProperties',  // Do not localize
         BindingFlags.NonPublic or BindingFlags.Instance or BindingFlags.InvokeMethod,
         nil,Writer,[Filters[t]]);
    {$ELSE}
      {$IFDEF D5}TWriterAccess(Writer).{$ENDIF}WriteProperties(Filters[t]);
    {$ENDIF}

    Writer.WriteListEnd;
  end;

  Writer.WriteListEnd;
end;

procedure TTeePicture.DoWriteFilters(Writer: TWriter);
begin
  WriteFilters(Writer,Filters);
end;

procedure TTeePicture.SetFilters(const Value: TFilterItems);
begin
  if Assigned(Value) then Filters.Assign(Value)
                     else FreeAndNil(FFilters);
end;

procedure TTeePicture.Repaint;
begin
  Changed(Self);
end;

{ TFloatPosition }

procedure TFloatXYZ.SetDoubleProperty(var Variable:Double; const Value:Double);
begin
  if Variable<>Value then
  begin
    Variable:=Value;

    if Assigned(FOnChange) then
       FOnChange(Self);
  end;
end;

function TFloatXYZ.Point:TPoint3DFloat;
begin
  result.X:=FX;
  result.Y:=FY;
  result.Z:=FZ;
end;

Procedure TFloatXYZ.SetX(Const Value:Double);
begin
  SetDoubleProperty(FX,Value);
end;

Procedure TFloatXYZ.SetY(Const Value:Double);
begin
  SetDoubleProperty(FY,Value);
end;

Procedure TFloatXYZ.SetZ(Const Value:Double);
begin
  SetDoubleProperty(FZ,Value);
end;

Procedure TFloatXYZ.Assign(Source:TPersistent);
begin
  if Source is TFloatXYZ then
  With TFloatXYZ(Source) do
  begin
    Self.FX:=X;
    Self.FY:=Y;
    Self.FZ:=Z;
  end
  else inherited;
end;

{ TConvolveFilter }
constructor TConvolveFilter.Create(Collection:TCollection);
const
  Inv9=1.0/9.0;
begin
  inherited;
  InvTotalWeight:=Inv9;
end;

procedure TConvolveFilter.Apply(Bitmap:TBitmap; const R:TRect);
var f2       : TTeeFilter;
    x,y,
    tmp      : Integer;
    f2Bitmap : TBitmap;
    tmpR     : TRect;
begin
  inherited;

  if Length(Lines)=0 then
     Exit;

  InvTotalWeight:=1.0 / ( Weights[-1,-1]+Weights[-1, 0]+Weights[-1, 1]+
                          Weights[ 0,-1]+Weights[ 0, 0]+Weights[ 0, 1]+
                          Weights[ 1,-1]+Weights[ 1, 0]+Weights[ 1, 1] ) ;

  with R do
  begin
    if Top<0 then tmpR.Top:=0 else tmpR.Top:=Top;
    if Left<0 then tmpR.Left:=0 else tmpR.Left:=Left;

    if Bottom>Bitmap.Height-1 then
       tmpR.Bottom:=Bitmap.Height-1
    else
       tmpR.Bottom:=Bottom;

    if Right>Bitmap.Width-1 then
       tmpR.Right:=Bitmap.Width-1
    else
       tmpR.Right:=Right;
  end;

  Prev:=Lines[tmpR.Top];
  This:=Lines[tmpR.Top+1];

  f2:=TTeeFilter.Create(nil);
  try
    f2Bitmap:=TBitmap.Create;

    TeeSetBitmapSize(f2Bitmap,Bitmap.Width,Bitmap.Height);

    f2.Apply(f2Bitmap);

    for y:=tmpR.Top+1 to tmpR.Bottom-1 do
    begin
      Next:=Lines[y+1];

      for x:=tmpR.Left+1 to tmpR.Right-1 do
      with f2.Lines[y,x] do
      begin
        tmp:=Round(
                  (
                   (Weights[-1,-1]*Prev[x-1].Blue)+
                   (Weights[-1, 0]*Prev[x].Blue)+
                   (Weights[-1, 1]*Prev[x+1].Blue)+
                   (Weights[ 0,-1]*This[x-1].Blue)+
                   (Weights[ 0, 0]*This[x].Blue)+
                   (Weights[ 0, 1]*This[x+1].Blue)+
                   (Weights[ 1,-1]*Next[x-1].Blue)+
                   (Weights[ 1, 0]*Next[x].Blue)+
                   (Weights[ 1, 1]*Next[x+1].Blue)
                  )*InvTotalWeight
                   );

        if tmp>255 then Blue:=255 else
        if tmp<0 then Blue:=0 else Blue:=tmp;

        tmp:=Round(
                  (
                   (Weights[-1,-1]*Prev[x-1].Green)+
                   (Weights[-1, 0]*Prev[x].Green)+
                   (Weights[-1, 1]*Prev[x+1].Green)+
                   (Weights[ 0,-1]*This[x-1].Green)+
                   (Weights[ 0, 0]*This[x].Green)+
                   (Weights[ 0, 1]*This[x+1].Green)+
                   (Weights[ 1,-1]*Next[x-1].Green)+
                   (Weights[ 1, 0]*Next[x].Green)+
                   (Weights[ 1, 1]*Next[x+1].Green)
                  )*InvTotalWeight
                   );

        if tmp>255 then Green:=255 else
        if tmp<0 then Green:=0 else Green:=tmp;

        tmp:=Round(
                  (
                   (Weights[-1,-1]*Prev[x-1].Red)+
                   (Weights[-1, 0]*Prev[x].Red)+
                   (Weights[-1, 1]*Prev[x+1].Red)+
                   (Weights[ 0,-1]*This[x-1].Red)+
                   (Weights[ 0, 0]*This[x].Red)+
                   (Weights[ 0, 1]*This[x+1].Red)+
                   (Weights[ 1,-1]*Next[x-1].Red)+
                   (Weights[ 1, 0]*Next[x].Red)+
                   (Weights[ 1, 1]*Next[x+1].Red)
                  )*InvTotalWeight
                   );

        if tmp>255 then Red:=255 else
        if tmp<0 then Red:=0 else Red:=tmp;
      end;

      Prev:=This;
      This:=Next;
    end;

    // Copy rectangle to destination bitmap
    for y:=tmpR.Top+1 to tmpR.Bottom-1 do
        for x:=tmpR.Left+1 to tmpR.Right-1 do
            Lines[y,x]:=f2.Lines[y,x];  // <-- pending: Fast Move row by row

    f2Bitmap.Free;
  finally
    f2.Free;
  end;
end;

{ TBlurFilter }

Constructor TBlurFilter.Create(Collection:TCollection);
begin
  inherited;
  FAmount:=1;
  FSteps:=1;
end;

procedure TBlurFilter.Apply(Bitmap:TBitmap; const R: TRect);
var tmp : Single;
    t   : Integer;
begin
  tmp:=1;

  Weights[-1,-1]:=1; Weights[-1,0]:=tmp; Weights[-1,1]:=1;
  Weights[ 0,-1]:=tmp; Weights[ 0,0]:=Amount*tmp; Weights[ 0,1]:=tmp;
  Weights[ 1,-1]:=1; Weights[ 1,0]:=tmp; Weights[ 1,1]:=1;

  CalcLines(Bitmap);
  ReuseLines:=True;

  for t:=1 to Steps do
      inherited;

  ReuseLines:=False;
end;

class function TBlurFilter.Description: String;
begin
  result:='TeeMsg_Blur';
end;

procedure TBlurFilter.CreateEditor(Creator:IFormCreator; AChanged:TNotifyEvent);
begin
  inherited;
  Creator.AddScroll('Steps',1,20);  // Do not localize
  Creator.AddScroll('Amount',0,50); // Do not localize
end;

{$IFNDEF D6}
function Supports(const Instance: IInterface; const IID: TGUID): Boolean;
var Temp : IInterface;
begin
  result := (Instance <> nil) and (Instance.QueryInterface(IID, Temp) = 0);
end;
{$ENDIF}

initialization
  {$IFNDEF TEEVCL}
  InitPlatformId;
  {$ENDIF}

  {$IFNDEF CLX}
  IsWindowsNT:=Win32Platform=VER_PLATFORM_WIN32_NT;  // Alphablend fails in Win98

  CanUseWinAlphaBlend:=IsWindowsNT and CheckWinAlphaBlend;

  {$ENDIF}

  CreateEmptyRegion;

  TeeDefaultFont;

  {$IFDEF TEEVCL}
  {$IFDEF D6}
  {$IFNDEF CLR}
  ActivateClassGroup(TControl);
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  {$IFNDEF CLX}
  {$IFNDEF CLR}
  TryLoadSetDC;
  {$ENDIF}
  {$ENDIF}

finalization
  {$IFNDEF CLR}
  {$IFNDEF CLX}
  if TeeGDI32<>0 then
     TeeFreeLibrary(TeeGDI32);
  if TeeMSIMG32<>0 then
     TeeFreeLibrary(TeeMSIMG32);
  {$ENDIF}
  {$ENDIF}

  DeleteEmptyRegion;
  TeeCustomEditColors.Free;
end.
