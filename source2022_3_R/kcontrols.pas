{ @abstract(This unit contains the base class for all visible controls.)
  @author(Tomas Krysl (tk@tkweb.eu))
  @created(18 Sep 2009)
  @lastmod(6 Jul 2014)

  This unit implements the base class TKCustomControl for all visible controls
  from the KControls Development Suite.<BR><BR>

  Copyright � Tomas Krysl (tk@@tkweb.eu)<BR><BR>

  <B>License:</B><BR>
  This code is distributed as a freeware. You are free to use it as part
  of your application for any purpose including freeware, commercial and
  shareware applications. The origin of this source code must not be
  misrepresented; you must not claim your authorship. You may modify this code
  solely for your own purpose. Please feel free to contact the author if you
  think your changes might be useful for other users. You may distribute only
  the original package. The author accepts no liability for any damage
  that may result from using this code. }
       
unit KControls;

{$include kcontrols.inc}
{$WEAKPACKAGEUNIT ON}

interface

uses
{$IFDEF FPC}
  LCLType, LCLIntf, LMessages, LCLProc, LResources,
{$ELSE}
  Windows, Messages,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Contnrs, Printers, Forms, KFunctions
{$IFDEF USE_THEMES}
  , Themes
 {$IFNDEF FPC}
  , UxTheme
 {$ENDIF}
{$ENDIF}
  ;

type
  { This array serves as storage place for all colors. }
  TKColorArray = array of TColor;

  { Declares possible indexes for colors available in @link(TKPreviewColors). }
  TKPreviewColorIndex = Integer;

  { Declares print options - possible values for the @link(TKPrintPageSetup.Options) property. }
  TKPrintOption = (
    { If there are more printed copies these will be collated. }
    poCollate,
    { The printed shape will be scaled to fit on page. }
    poFitToPage,
    { Every even page will be printed with mirrored (swapped) margins. }
    poMirrorMargins,
    { Page numbers will be added to the bottom of each printed page. }
    poPageNumbers,
    { Paints the selection in control's specific manner. }
    poPaintSelection,
    { Title will be printed to the top of each printed page. }
    poTitle,
    { Color page will be printed instead of B/W page. }
    poUseColor
  );

  { Print options can be arbitrary combined. }
  TKPrintOptions = set of TKPrintOption;

  { Declares possible values for the @link(TKPrintPageSetup.Range) property. }
  TKPrintRange = (
    { All pages will be printed. }
    prAll,
    { Only selected block will be printed. }
    prSelectedOnly,
    { Only given range of pages will be printed. }
    prRange
  );

  { Declares measurement units for KControls printing system. }
  TKPrintUnits = (
    { Corresponding value is given in millimeters. }
    puMM,
    { Corresponding value is given in centimeters. }
    puCM,
    { Corresponding value is given in inches. }
    puInch,
    { Corresponding value is given in hundredths of inches. }
    puHundredthInch
  );

const
  { Default value for the @link(TKCustomControl.BorderStyle) property. }
  cBorderStyleDef = bsSingle;

  cContentPaddingBottomDef = 0;
  cContentPaddingLeftDef = 0;
  cContentPaddingRightDef = 0;
  cContentPaddingTopDef = 0;

  { Minimum for the @link(TKPrintPageSetup.Copies) property }
  cCopiesMin = 1;
  { Maximum for the @link(TKPrintPageSetup.Copies) property }
  cCopiesMax = 1000;
  { Default value for the @link(TKPrintPageSetup.Copies) property }
  cCopiesDef = 1;

  { Default value for the @link(TKPrintPageSetup.UnitMarginBottom) property }
  cMarginBottomDef = 2.0;
  { Default value for the @link(TKPrintPageSetup.UnitMarginLeft) property }
  cMarginLeftDef = 1.5;
  { Default value for the @link(TKPrintPageSetup.UnitMarginRight) property }
  cMarginRightDef = 1.5;
  { Default value for the @link(TKPrintPageSetup.UnitMarginTop) property }
  cMarginTopDef = 1.8;

  { Default value for the @link(TKPrintPageSetup.Options) property. }
  cOptionsDef = [poFitToPage, poPageNumbers, poUseColor];

  { Default value for the @link(TKPrintPageSetup.Options) property. }
  cRangeDef = prAll;

  { Minimum for the @link(TKPrintPageSetup.Scale) property }
  cScaleDef = 100;
  { Maximum for the @link(TKPrintPageSetup.Scale) property }
  cScaleMin = 10;
  { Default value for the @link(TKPrintPageSetup.Scale) property }
  cScaleMax = 500;

  { Default value for the @link(TKPrintPageSetup.Units) property. }
  cUnitsDef = puCM;

  { Default value for the @link(TKPreviewColors.Paper) color property. }
  cPaperDef = clWhite;
  { Default value for the @link(TKPreviewColors.BkGnd) color property. }
  cBkGndDef = clAppWorkSpace;
  { Default value for the @link(TKPreviewColors.Border) color property. }
  cBorderDef = clBlack;
  { Default value for the @link(TKPreviewColors.SelectedBorder) color property. }
  cSelectedBorderDef = clNavy;

  { Index for the @link(TKPreviewColors.Paper) property. }
  ciPaper = TKPreviewColorIndex(0);
  { Index for the @link(TKPreviewColors.BkGnd) property. }
  ciBkGnd = TKPreviewColorIndex(1);
  { Index for the @link(TKPreviewColors.Border) property. }
  ciBorder = TKPreviewColorIndex(2);
  { Index for the @link(TKPreviewColors.SelectedBorder) property. }
  ciSelectedBorder = TKPreviewColorIndex(3);
  { Maximum color array index }
  ciPreviewColorsMax = ciSelectedBorder;

  { Constant for control scrollbars. It means: Leave that scrollbar untouched. }
  cScrollNoAction = -1;

  { Constant for control scrollbars. It means: Use given Delta to update scrollbar. }
  cScrollDelta = -2;

  { Internal flag for TKPrintPreview. }
  cPF_Dragging          = $00000001;
  { Internal flag for TKPrintPreview. }
  cPF_UpdateRange       = $00000002;

type
  { Declares possible values for the @link(ScaleMode) property }
  TKPreviewScaleMode = (
    { Apply scale defined by the @link(Scale) property }
    smScale,
    { Scale the page so that it horizontally fits to the window client area }
    smPageWidth,
    { Scale the page so that it fits to the window client area }
    smWholePage);

  { @abstract(Declares @link(TKPrintPreview.OnChanged) event handler)
    <UL>
    <LH>Parameters:</LH>
    <LI><I>Sender</I> - identifies the event caller</LI>
    </UL>
  }
  TKPreviewChangedEvent = procedure(Sender: TObject) of object;

  { @abstract(Declares the information structure for the @link(TKCustomControl.MeasurePages) method)
    <UL>
    <LH>Members:</LH>
    <LI><I>OutlineWidth</I> - printed outline width (maximum of all pages) in desktop pixels</LI>
    <LI><I>OutlineHeight</I> - printed outline height (maximum of all pages) in desktop pixels</LI>
    <LI><I>ControlHorzPageCount</I> - number of pages to split control shape into</LI>
    <LI><I>ControlVertPageCount</I> - number of pages to split control shape into</LI>
    <LI><I>ExtraLeftHorzPageCount</I> - number of horizontal pages to the left of control</LI>
    <LI><I>ExtraLeftVertPageCount</I> - number of vertical pages to the left of control</LI>
    <LI><I>ExtraRightHorzPageCount</I> - number of horizontal pages to the right of control</LI>
    <LI><I>ExtraRightVertPageCount</I> - number of vertical pages to the right of control</LI>
    </UL>
  }
  TKPrintMeasureInfo = record
    OutlineWidth: Integer;
    OutlineHeight: Integer;
    ControlHorzPageCount: Integer;
    ControlVertPageCount: Integer;
    ExtraLeftHorzPageCount: Integer;
    ExtraLeftVertPageCount: Integer;
    ExtraRightHorzPageCount: Integer;
    ExtraRightVertPageCount: Integer;
  end;

  { Declares possible values for the Status parameter in the @link(TKPrintNotifyEvent) event }
  TKPrintStatus = (
    { This event occurs at the beginning of the print job - you may show an Abort dialog here }
    epsBegin,
    { This event occurs after each page has been printed - you may update the Page/Copy information
      in the Abort dialog }
    epsNewPage,
    { This event occurs at the end of the print job - you may hide the Abort dialog here }
    epsEnd
  );

  { @abstract(Declares @link(TKCustomControl.OnPrintNotify) event handler)
    <UL>
    <LH>Parameters:</LH>
    <LI><I>Sender</I> - identifies the event caller</LI>
    <LI><I>Status</I> - specifies the event type</LI>
    <LI><I>Abort</I> - set to True to abort the print job</LI>
    </UL>
    Remark: At certain time slots, the print spooler allows the message queue
    to be processed for the thread where the print job is running. This e.g. allows
    the user to press a button on the Abort dialog. Because this message loop can be invoked
    e.g. during a Printer.Canvas.TextRect function and any painting messages may hover in
    the message queue, any functions used both to print a job and to process particular
    messages should be reentrant to avoid conflicts. Perhaps should print jobs be run
    in seperate threads?
  }
  TKPrintNotifyEvent = procedure(Sender: TObject; Status: TKPrintStatus;
    var Abort: Boolean) of object;

  { @abstract(Declares @link(TKCustomControl.OnPrintPaint) event handler)
    <UL>
    <LH>Parameters:</LH>
    <LI><I>Sender</I> - identifies the event caller</LI>
    </UL>
  }
  TKPrintPaintEvent = procedure(Sender: TObject) of object;

  TKPrintPageSetup = class;
  TKPrintPreview = class;

  TKRect = class(TPersistent)
  private
    FLeft, FTop, FRight, FBottom: Integer;
    FOnChanged: TNotifyEvent;
    procedure SetBottom(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetRight(const Value: Integer);
    procedure SetTop(const Value: Integer);
  protected
    procedure Changed;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure AssignFromRect(const ARect: TRect);
    procedure AssignFromValues(ALeft, ATop, ARight, ABottom: Integer);
    function ContainsPoint(const APoint: TPoint): Boolean;
    function EqualProperties(const ARect: TKRect): Boolean;
    function NonZero: Boolean;
    function OffsetRect(ARect: TKRect): TRect; overload;
    function OffsetRect(const ARect: TRect): TRect; overload;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  published
    property Left: Integer read FLeft write SetLeft default cContentPaddingLeftDef;
    property Top: Integer read FTop write SetTop default cContentPaddingTopDef;
    property Right: Integer read FRight write SetRight default cContentPaddingRightDef;
    property Bottom: Integer read FBottom write SetBottom default cContentPaddingBottomDef;
  end;

  TKObjectList = class;

  TKObject = class(TObject)
  private
    FParent: TKObjectList;
    procedure SetParent(const Value: TKObjectList);
  protected
    FUpdateLock: Integer;
    procedure CallBeforeUpdate; virtual;
    procedure CallAfterUpdate; virtual;
    procedure ParentChanged; virtual;
  public
    constructor Create; virtual;
    procedure Assign(ASource: TKObject); virtual;
    function EqualProperties(AValue: TKObject): Boolean; virtual;
    procedure LockUpdate; virtual;
    procedure UnLockUpdate; virtual;
    function UpdateUnlocked: Boolean; virtual;
    property Parent: TKObjectList read FParent write SetParent;
  end;

  TKObjectClass = class of TKObject;

  TKObjectList = class(TObjectList)
  protected
    FUpdateLock: Integer;
    procedure CallBeforeUpdate; virtual;
    procedure CallAfterUpdate; virtual;
  public
    constructor Create; virtual;
    function Add(AObject: TObject): Integer;
    procedure Assign(ASource: TKObjectList); virtual;
    function EqualProperties(AValue: TKObjectList): Boolean; virtual;
    procedure Insert(Index: Integer; AObject: TObject);
    procedure LockUpdate; virtual;
    procedure UnLockUpdate; virtual;
    function UpdateUnlocked: Boolean; virtual;
  end;

  { Base class for all visible controls in KControls. }
  TKCustomControl = class(TCustomControl)
  private
  {$IF DEFINED(FPC) OR NOT DEFINED(COMPILER10_UP)}
    FParentBackground: Boolean;
    FParentDoubleBuffered: Boolean;
  {$IFEND}
  {$IFNDEF FPC}
    FBorderStyle: TBorderStyle;
  {$ENDIF}
  {$IFNDEF COMPILER10_UP}
    FMouseInClient: Boolean;
  {$ENDIF}
    FMemoryCanvas: TCanvas;
    FMemoryCanvasRect: TRect;
    FPageSetup: TKPrintPageSetup;
    FUpdateLock: Integer;
    FOnPrintNotify: TKPrintNotifyEvent;
    FOnPrintPaint: TKPrintPaintEvent;
  {$IFNDEF FPC}
    procedure CMCancelMode(var Msg: TMessage); message CM_CANCELMODE;
    procedure CMCtl3DChanged(var Msg: TMessage); message CM_CTL3DCHANGED;
  {$ENDIF}
    procedure CMMouseLeave(var Msg: TLMessage); message CM_MOUSELEAVE;
    function GetCanPrint: Boolean;
    function GetPageSetup: TKPrintPageSetup;
    function GetPageSetupAllocated: Boolean;
    procedure KMLateUpdate(var Msg: TLMessage); message KM_LATEUPDATE;
  {$IFNDEF FPC}
    procedure SetBorderStyle(Value: TBorderStyle);
  {$ENDIF}
    procedure SetPageSetup(Value: TKPrintPageSetup);
  {$IFNDEF FPC}
    procedure WMCancelMode(var Msg: TWMCancelMode); message WM_CANCELMODE;
  {$ENDIF}
  {$IFNDEF COMPILER10_UP}
    procedure WMMouseLeave(var Msg: TLMessage); message KM_MOUSELEAVE;
  {$ENDIF}
  {$IFNDEF FPC}
    procedure WMNCPaint(var Msg: TWMNCPaint); message WM_NCPAINT;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
  {$ENDIF}
    procedure WMSize(var Msg: TLMSize); message LM_SIZE;
  {$IFNDEF FPC}
   {$IFDEF USE_THEMES}
    procedure WMThemeChanged(var Msg: TMessage); message WM_THEMECHANGED;
   {$ENDIF}
  {$ENDIF}
  protected
    { Holds the mutually inexclusive state as cXF... flags. }
    FFlags: Cardinal;
    { Defines the message queue for late update. }
    FMessages: array of TLMessage;
    { Gains access to the list of associated previews. }
    FPreviewList: TList;
    { Adds a preview control to the internal list of associated previews. }
    procedure AddPreview(APreview: TKPrintPreview);
    { Gives the descendant the possibility to adjust the associated TKPrintPageSetup
      instance just before printing. }
    procedure AdjustPageSetup; virtual;
    { Cancels any dragging or resizing operations performed by mouse. }
    procedure CancelMode; virtual;
    { Overriden method. Calls @link(TKCustomControl.UpdateSize). }
    procedure CreateHandle; override;
    { Defines additional styles. }
    procedure CreateParams(var Params: TCreateParams); override;
  {$IFDEF FPC}
    { Overriden method. Calls @link(TKCustomControl.UpdateSize). }
    procedure DoOnChangeBounds; override;
  {$ENDIF}
    { If Value is True, includes the flag specified by AFLag to @link(FFlags).
      If Value is False, excludes the flag specified by AFLag from @link(FFlags). }
    procedure FlagAssign(AFlag: Cardinal; Value: Boolean);
    { Excludes the flag specified by AFLag from @link(FFlags). }
    procedure FlagClear(AFlag: Cardinal);
    { Includes the flag specified by AFLag to @link(FFlags). }
    procedure FlagSet(AFlag: Cardinal);
    { If the flag specified by AFLag is included in @link(FFlags), FlagToggle
      excludes it and vice versa. }
    procedure FlagToggle(AFlag: Cardinal);
    { Invalidates the page setup settings. If page setup is required again,
      it's UpdateSettings method is called. }
    procedure InvalidatePageSetup;
    { Invalidates a rectangular part of the client area if control updating is not locked
      by @link(TKCustomControl.LockUpdate). }
    procedure InvalidateRectArea(const R: TRect); virtual;
    { Returns True if the control has a selection. }
    function InternalGetSelAvail: Boolean; virtual;
    { Called in UnlockUpdate. Allows the changes to be reflected. }
    procedure InternalUnlockUpdate; virtual;
    { Determines if control can be painted with OS themes. }
    function IsThemed: Boolean; virtual;
    { Called from KM_LATEUPDATE. Performs late update. Override to adapt. }
    procedure LateUpdate(var Msg: TLMessage); virtual;
    { Updates information about printed shape. }
    procedure MeasurePages(var Info: TKPrintMeasureInfo); virtual;
    { Retrieves a message from message queue if there is one. Used for late update.}
    function MessagePeek(out Msg: TLMessage): Boolean;
    { Puts a new message into the message queue. Used for late update.}
    procedure MessagePoke(const Msg: TLMessage);
    { Searches the message queue for given message code. }
    function MessageSearch(MsgCode: Cardinal): Boolean;
    { Responds to WM_MOUSELEAVE message. }
    procedure MouseFormLeave; virtual;
    { Overriden method - see Delphi help. }
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    { Notifies all associated previews about a change in the associated page setup. }
    procedure NotifyPreviews;
    { Overriden method - see Delphi help. Paints the entire control client area. }
    procedure Paint; override;
    { Paints a page to a printer/preview canvas. }
    procedure PaintPage; virtual;
    { Paints the control to the specified canvas. Must always be overriden. }
    procedure PaintToCanvas(ACanvas: TCanvas); virtual; abstract;
    { Adds a message to message queue for late update. Set IfNotExists to True to
      add that message only if the specified message code does not exist in the
      message queue at this moment. }
    procedure PostLateUpdate(const Msg: TLMessage; IfNotExists: Boolean = False);
    { Calls the @link(TKCustomControl.OnPrintNotify) event }
    procedure PrintNotify(Status: TKPrintStatus; var Abort: Boolean); virtual;
    { Calls the @link(TKCustomControl.OnPrintPaint) event }
    procedure PrintPaint; virtual;
    { Allows descendant to make necessary adjustments before printing or painting to preview starts. }
    procedure PrintPaintBegin; virtual;
    { Allows descendant to make necessary adjustments after printing or painting to preview ended. }
    procedure PrintPaintEnd; virtual;
    { Removse a preview control to the internal list of associated previews. }
    procedure RemovePreview(APreview: TKPrintPreview);
    { Updates mouse cursor according to the state determined from current mouse
      position. Returns True if cursor has been changed. }
    function SetMouseCursor(X, Y: Integer): Boolean; virtual;
    { Updates the control size. Responds to WM_SIZE under Delphi and similar
      notifications under Lazarus. }
    procedure UpdateSize; virtual;
  public
    { Creates the instance. Assigns default values to properties, allocates
      default column, row and cell data. }
    constructor Create(AOwner: TComponent); override;
    { Destroys the instance along with all allocated column, row and cell data.
      See TObject.Destroy in Delphi help. }
    destructor Destroy; override;
    { Determines whether a flag specified by AFlag is included in @link(FFlags). }
    function Flag(AFlag: Cardinal): Boolean;
    { Invalidates the entire control if control updating is not locked
      by @link(TKCustomControl.LockUpdate). }
    procedure Invalidate; override;
    { Locks control updating so that all possibly slow operations such as all Invalidate...
      methods will not be performed. This is useful e.g. when assigning many
      properties at one time. Every LockUpdate call must have
      a corresponding @link(TKCustomControl.UnlockUpdate) call, please use a
      try-finally section. }
    procedure LockUpdate; virtual;
    { Prints the control. }
    procedure PrintOut;
    { Unlocks back to normal control updating and calls InternalUnlockUpdate
      to reflect (possible) multiple changes made. Each @link(LockUpdate) call must
      be always followed by the UnlockUpdate call. }
    procedure UnlockUpdate; virtual;
    { Returns True if control updating is not locked, i.e. there is no open
      LockUpdate and UnlockUpdate pair. }
    function UpdateUnlocked: Boolean; virtual;
    { Determines whether a single line border is drawn around the control.
      Set BorderStyle to bsSingle to add a single line border around the control.
      Set BorderStyle to bsNone to omit the border. }
  {$IFDEF FPC}
    property BorderStyle default cBorderStyleDef;
  {$ELSE}
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default cBorderStyleDef;
  {$ENDIF}
    { Returns True if the control has anything to print and a printer is installed. }
    property CanPrint: Boolean read GetCanPrint;
  {$IFNDEF COMPILER10_UP}
    { This property has the same meaning as the MouseInClient property introduced
      into TWinControl in BDS 2006. }
    property MouseInClient: Boolean read FMouseInClient;
  {$ENDIF}
    { Setting this property causes the control to be painted to MemoryCanvas in it's
      Paint method. This approach replaces PaintTo as it does not work good for all
      LCL widget sets. The control is painted normally on it's Canvas and then
      copied only once to MemoryCanvas. MemoryCanvas is then set to nil (not freed)
      to indicate the copying is complete. }
    property MemoryCanvas: TCanvas read FMemoryCanvas write FMemoryCanvas;
    { Specifies what rectangular part of the control should be copied on MemoryCanvas. }
    property MemoryCanvasRect: TRect read FMemoryCanvasRect write FMemoryCanvasRect;
    { This event is called at certain phases of the actually running print job. }
    property OnPrintNotify: TKPrintNotifyEvent read FOnPrintNotify write FOnPrintNotify;
    { This event is called after the shape was drawn onto the printer canvas. }
    property OnPrintPaint: TKPrintPaintEvent read FOnPrintPaint write FOnPrintPaint;
    { Specifies the page setup component used for this control. }
    property PageSetup: TKPrintPageSetup read GetPageSetup write SetPageSetup;
    {Returns True if page setup component is allocated for this control. }
    property PageSetupAllocated: Boolean read GetPageSetupAllocated;
    { Just to be compatible with Delphi. }
  {$IF DEFINED(FPC) OR NOT DEFINED(COMPILER10_UP)}
    property ParentBackground: Boolean read FParentBackground write FParentBackground default True;
    property ParentDoubleBuffered: Boolean read FParentDoubleBuffered write FParentDoubleBuffered default True;
  {$IFEND}
  end;

  { Declares possible values for the @link(TKCustomColors.ColorScheme) property. }
  TKColorScheme = (
    { GetColor returns normal color currently defined for each item }
    csNormal,
    { GetColor returns gray for text and line colors and white for background colors }
    csGrayed,
    { GetColor returns brighter version of normal color }
    csBright,
    { GetColor returns grayscaled color versions }
    csGrayScale
  );

  { Declares possible indexes e.g. for the @link(TKCustomColors.Color) property. }
  TKColorIndex = Integer;

  { @abstract(Declares the color description structure returned by @link(TKCustomColors.ColorData) property)
    <UL>
    <LH>Members:</LH>
    <LI><I>Index</I> - color index</LI>
    <LI><I>Color</I> - current color value</LI>
    <LI><I>Default</I> - default color value</LI>
    <LI><I>Name</I> - color name</LI>
    </UL>
  }
  TKColorData = record
    Index: TKColorIndex;
    Color: TColor;
    Default: TColor;
    Name: string;
  end;

  { @abstract(Declares @link(TKCustomColors) color item description)
    <UL>
    <LH>Members:</LH>
    <LI><I>Def</I> - default color value</LI>
    <LI><I>Name</I> - color name (can be localized)</LI>
    </UL>
  }
  TKColorSpec = record
    Def: TColor;
    Name: string;
  end;

  { @abstract(Container for all colors used by specific control)
    This container allows to group many colors into one item in object inspector.
    Colors are accessible via published properties or several public Color*
    properties. }
  TKCustomColors = class(TPersistent)
  private
    function GetColorData(Index: TKColorIndex): TKColorData;
    function GetColorEx(Index: TKColorIndex): TColor;
    function GetColorName(Index: TKColorIndex): string;
    function GetDefaultColor(Index: TKColorIndex): TColor;
    procedure SetColorEx(Index: TKColorIndex; Value: TColor);
    procedure SetColors(const Value: TKColorArray);
  protected
    FControl: TKCustomControl;
    FColorScheme: TKColorScheme;
    FBrightColors: TKColorArray;
    FColors: TKColorArray;
    { Returns the specific color. Use for property assignments. }
    function GetColor(Index: TKColorIndex): TColor;
    { Returns color specification structure for given index. }
    function GetColorSpec(Index: TKColorIndex): TKColorSpec; virtual;
    { Returns maximum color index. }
    function GetMaxIndex: Integer; virtual;
    { Initializes the color array. }
    procedure Initialize; virtual;
    { Returns the specific color according to ColorScheme. }
    function InternalGetColor(Index: TKColorIndex): TColor; virtual;
    { Replaces the specific color. }
    procedure InternalSetColor(Index: TKColorIndex; Value: TColor); virtual;
    { Replaces the specific color. Use for property assignments. }
    procedure SetColor(Index: TKColorIndex; Value: TColor);
  public
    { Creates the instance. You can create a custom instance and pass it
      e.g. to a @link(TKCustomGrid.Colors) property. The AGrid parameter has no meaning
      in this case and you may set it to nil. }
    constructor Create(AControl: TKCustomControl); virtual;
    { Copies the properties of another instance that inherits from
      TPersistent into this TKGridColors instance. }
    procedure Assign(Source: TPersistent); override;
    { Clears cached brighter colors. }
    procedure ClearBrightColors; virtual;
    { Returns always normal color - regardless of the ColorScheme setting. }
    property Color[Index: TKColorIndex]: TColor read GetColorEx write SetColorEx;
    { Returns always a complete color description }
    property ColorData[Index: TKColorIndex]: TKColorData read GetColorData;
    { Returns (localizable) color name. }
    property ColorName[Index: TKColorIndex]: string read GetColorName;
    { Returns array of normal colors. }
    property Colors: TKColorArray read FColors write SetColors;
    { Specifies color scheme for reading of published properties - see GetColor in source code. }
    property ColorScheme: TKColorScheme read FColorScheme write FColorScheme;
    { Returns default color. }
    property DefaultColor[Index: TKColorIndex]: TColor read GetDefaultColor;
  end;

  { @abstract(Declares @link(TKPrintPageSetup.OnPrintMeasure) event handler)
    <UL>
    <LH>Parameters:</LH>
    <LI><I>Sender</I> - identifies the event caller</LI>
    <LI><I>Info</I> - print measure info structure already filled by the associated control</LI>
    </UL>
  }
  TKPrintMeasureEvent = procedure(Sender: TObject; var Info: TKPrintMeasureInfo) of object;

  { @abstract(Class to specify the print job parameters) }
  TKPrintPageSetup = class(TPersistent)
  private
    FActive: Boolean;
    FCanvas: TCanvas;
    FControl: TKCustomControl;
    FControlHorzPageCount: Integer;
    FControlPageCount: Integer;
    FControlVertPageCount: Integer;
    FCopies: Integer;
    FCurrentCopy: Integer;
    FCurrentPage: Integer;
    FCurrentScale: Double;
    FDesktopPixelsPerInchX: Integer;
    FDesktopPixelsPerInchY: Integer;
    FEndPage: Integer;
    FExtraLeftHorzPageCount: Integer;
    FExtraLeftPageCount: Integer;
    FExtraLeftVertPageCount: Integer;
    FExtraRightHorzPageCount: Integer;
    FExtraRightPageCount: Integer;
    FExtraRightVertPageCount: Integer;
    FIsValid: Boolean;
    FMappedControlPaintAreaWidth: Integer;
    FMappedExtraSpaceLeft: Integer;
    FMappedExtraSpaceRight: Integer;
    FMappedFooterSpace: Integer;
    FMappedHeaderSpace: Integer;
    FMappedMarginBottom: Integer;
    FMappedMarginLeft: Integer;
    FMappedMarginLeftMirrored: Integer;
    FMappedMarginRight: Integer;
    FMappedMarginRightMirrored: Integer;
    FMappedMarginTop: Integer;
    FMappedOutlineHeight: Integer;
    FMappedOutlineWidth: Integer;
    FMappedPaintAreaHeight: Integer;
    FMappedPaintAreaWidth: Integer;
    FMappedPageHeight: Integer;
    FMappedPageWidth: Integer;
    FOptions: TKPrintOptions;
    FOrientation: TPrinterOrientation;
    FPageCount: Integer;
    FPreviewing: Boolean;
    FPrinterControlPaintAreaWidth: Integer;
    FPrinterExtraSpaceLeft: Integer;
    FPrinterExtraSpaceRight: Integer;
    FPrinterFooterSpace: Integer;
    FPrinterHeaderSpace: Integer;
    FPrinterMarginBottom: Integer;
    FPrinterMarginLeft: Integer;
    FPrinterMarginLeftMirrored: Integer;
    FPrinterMarginRight: Integer;
    FPrinterMarginRightMirrored: Integer;
    FPrinterMarginTop: Integer;
    FPrinterName: string;
    FPrinterPageHeight: Integer;
    FPrinterPageWidth: Integer;
    FPrinterPaintAreaHeight: Integer;
    FPrinterPaintAreaWidth: Integer;
    FPrinterPixelsPerInchX: Integer;
    FPrinterPixelsPerInchY: Integer;
    FPrintingMapped: Boolean;
    FRange: TKPrintRange;
    FStartPage: Integer;
    FScale: Integer;
    FTitle: string;
    FUnitControlPaintAreaWidth: Double;
    FUnitExtraSpaceLeft: Double;
    FUnitExtraSpaceRight: Double;
    FUnitFooterSpace: Double;
    FUnitHeaderSpace: Double;
    FUnitMarginBottom: Double;
    FUnitMarginLeft: Double;
    FUnitMarginRight: Double;
    FUnitMarginTop: Double;
    FUnitPaintAreaHeight: Double;
    FUnitPaintAreaWidth: Double;
    FUnits: TKPrintUnits;
    FUpdateLock: Integer;
    FValidating: Boolean;
    FOnPrintMeasure: TKPrintMeasureEvent;
    FOnUpdateSettings: TNotifyEvent;
    function GetCanPrint: Boolean;
    function GetSelAvail: Boolean;
    procedure SetCopies(Value: Integer);
    procedure SetEndPage(Value: Integer);
    procedure SetUnitExtraSpaceLeft(Value: Double);
    procedure SetUnitExtraSpaceRight(Value: Double);
    procedure SetUnitFooterSpace(Value: Double);
    procedure SetUnitHeaderSpace(Value: Double);
    procedure SetUnitMarginBottom(Value: Double);
    procedure SetUnitMarginLeft(Value: Double);
    procedure SetUnitMarginRight(Value: Double);
    procedure SetUnitMarginTop(Value: Double);
    procedure SetOptions(Value: TKPrintOptions);
    procedure SetOrientation(AValue: TPrinterOrientation);
    procedure SetPrinterName(const Value: string);
    procedure SetPrintingMapped(Value: Boolean);
    procedure SetRange(Value: TKPrintRange);
    procedure SetScale(Value: Integer);
    procedure SetStartPage(Value: Integer);
    procedure SetUnits(Value: TKPrintUnits);
    function GetCurrentPageControl: Integer;
    function GetCurrentPageExtraLeft: Integer;
    function GetCurrentPageExtraRight: Integer;
  protected
    { Called before new Units are set. Converts the margins to inches by default. }
    procedure AfterUnitsChange; virtual;
    { Called after new Units are set. Converts the margins from inches by default. }
    procedure BeforeUnitsChange; virtual;
    { Paints a page to APreview.Canvas. }
    procedure PaintPageToPreview(APreview: TKPrintPreview); virtual;
    { Prints the page number at the bottom of the page, horizontally centered. }
    procedure PrintPageNumber(Value: Integer); virtual;
    { Prints the title at the top of the page. }
    procedure PrintTitle; virtual;
    { Updates entire printing information. }
    procedure UpdateSettings; virtual;
  public
    { Creates the instance. Assigns default values to properties. }
    constructor Create(AControl: TKCustomControl);
    { Copies shareable properties of another TKPrintPageSetup instance
      to this instance. }
    procedure Assign(Source: TPersistent); override;
    { Returns a value mapped from desktop horizontal units to printer horizontal units. }
    function HMap(Value: Integer): Integer;
    { Invalidates the settings. }
    procedure Invalidate;
    { Prints the associated control. }
    procedure PrintOut;
    { Locks page setup updating. Use this if you assign many properties at the
      same time. Every LockUpdate call must have a corresponding
      @link(TKPrintPageSetup.UnlockUpdate) call, please use a try-finally section. }
    procedure LockUpdate; virtual;
    { Unlocks page setup updating and updates the page settings.
      Each @link(TKPrintPageSetup.LockUpdate) call must be always followed
      by the UnlockUpdate call. }
    procedure UnlockUpdate; virtual;
    { Returns True if updating is not locked, i.e. there is no open
      LockUpdate and UnlockUpdate pair. }
    function UpdateUnlocked: Boolean; virtual;
    { Validates the settings. }
    procedure Validate;
    { Returns a value mapped from desktop vertical units to printer vertical units. }
    function VMap(Value: Integer): Integer;
    { Returns True if printing or previewing is active. }
    property Active: Boolean read FActive;
    { Returns True if the control is associated and has anything to print. }
    property CanPrint: Boolean read GetCanPrint;
    { Returns the Printer.Canvas or TkPrintPreview.Canvas. Do not access outside
      print job. }
    property Canvas: TCanvas read FCanvas;
    { Returns the control to which this TKPrintPageSetup instance is assigned. }
    property Control: TKCustomControl read FControl;
    { Returns the maximum amount of control pages for horizontal axis. }
    property ControlHorzPageCount: Integer read FControlHorzPageCount;
    { Returns the maximum amount of control pages for vertical axis. }
    property ControlVertPageCount: Integer read FControlVertPageCount;
    { Specifies the number of copies to print. }
    property Copies: Integer read FCopies write SetCopies;
    { Returns the currently printed copy. }
    property CurrentCopy: Integer read FCurrentCopy;
    { Returns the currently printed page. }
    property CurrentPage: Integer read FCurrentPage;
    { Returns the currently printed page relative to the control shape.
      It must be used with associated control to print page. }
    property CurrentPageControl: Integer read GetCurrentPageControl;
    { Returns the currently printed page relative to the extra left shape. }
    property CurrentPageExtraLeft: Integer read GetCurrentPageExtraLeft;
    { Returns the currently printed page relative to the extra left shape. }
    property CurrentPageExtraRight: Integer read GetCurrentPageExtraRight;
    { Returns the horizontal scale for the printed shape, without dimension. }
    property CurrentScale: Double read FCurrentScale;
    { Returns the control paint area width on canvas in units depending on PrintingMapped. }
    property MappedControlPaintAreaWidth: Integer read FMappedControlPaintAreaWidth;
    { Returns the width of extra left paint area on canvas in units depending on PrintingMapped. }
    property MappedExtraSpaceLeft: Integer read FMappedExtraSpaceLeft;
    { Returns the width of extra right paint area on canvas in units depending on PrintingMapped. }
    property MappedExtraSpaceRight: Integer read FMappedExtraSpaceRight;
    { Returns the footer space in units depending on PrintingMapped. }
    property MappedFooterSpace: Integer read FMappedFooterSpace;
    { Returns the header space in units depending on PrintingMapped. }
    property MappedHeaderSpace: Integer read FMappedHeaderSpace;
    { Returns the bottom margin in units depending on PrintingMapped. }
    property MappedMarginBottom: Integer read FMappedMarginBottom;
    { Returns the left margin in units depending on PrintingMapped. }
    property MappedMarginLeft: Integer read FMappedMarginLeft;
    { Returns the left margin respecting current page in units depending on PrintingMapped. }
    property MappedMarginLeftMirrored: Integer read FMappedMarginLeftMirrored;
    { Returns the right margin in units depending on PrintingMapped. }
    property MappedMarginRight: Integer read FMappedMarginRight;
    { Returns the left margin respecting current page in units depending on PrintingMapped. }
    property MappedMarginRightMirrored: Integer read FMappedMarginRightMirrored;
    { Returns the top margin in units depending on PrintingMapped. }
    property MappedMarginTop: Integer read FMappedMarginTop;
    { Returns the printed shape height (maximum of all pages) in units depending on PrintingMapped. }
    property MappedOutlineHeight: Integer read FMappedOutlineHeight;
    { Returns the printed shape width (maximum of all pages) in units depending on PrintingMapped. }
    property MappedOutlineWidth: Integer read FMappedOutlineWidth;
    { Returns the paint area height on canvas in units depending on PrintingMapped. }
    property MappedPaintAreaHeight: Integer read FMappedPaintAreaHeight;
    { Returns the paint area width on canvas in units depending on PrintingMapped. }
    property MappedPaintAreaWidth: Integer read FMappedPaintAreaWidth;
    { Returns the page height in units depending on PrintingMapped. }
    property MappedPageHeight: Integer read FMappedPageHeight;
    { Returns the page width in units depending on PrintingMapped. }
    property MappedPageWidth: Integer read FMappedPageWidth;
    { Returns the amount of pixels per inch for the desktop device context's horizontal axis }
    property DesktopPixelsPerInchX: Integer read FDesktopPixelsPerInchX;
    { Returns the amount of pixels per inch for the desktop device context's vertical axis }
    property DesktopPixelsPerInchY: Integer read FDesktopPixelsPerInchY;
    { Specifies last page printed if Range is eprRange. }
    property EndPage: Integer read FEndPage write SetEndPage;
    { Returns extra horizontal pages needed to print extra left space. }
    property ExtraLeftHorzPageCount: Integer read FExtraLeftHorzPageCount;
    { Returns extra vertical pages needed to print extra left space. }
    property ExtraLeftVertPageCount: Integer read FExtraLeftVertPageCount;
    { Returns extra horizontal pages needed to print extra right space. }
    property ExtraRightHorzPageCount: Integer read FExtraRightHorzPageCount;
    { Returns extra vertical pages needed to print extra right space. }
    property ExtraRightVertPageCount: Integer read FExtraRightVertPageCount;
    { Specifies the printing options. }
    property Options: TKPrintOptions read FOptions write SetOptions;
    { Specifies the paper orientation. }
    property Orientation: TPrinterOrientation read FOrientation write SetOrientation;
    { Returns the amount of all pages. Includes the extra left and right areas. }
    property PageCount: Integer read FPageCount;
    { Returns True if painting to a TKPrintPreview.Canvas is active. }
    property Previewing: Boolean read FPreviewing;
    { Returns the control paint area width in printer device context's units. }
    property PrinterControlPaintAreaWidth: Integer read FPrinterControlPaintAreaWidth;
    { Returns the left extra space in printer device context's units. }
    property PrinterExtraSpaceLeft: Integer read FPrinterExtraSpaceLeft;
    { Returns the right extra space in printer device context's units. }
    property PrinterExtraSpaceRight: Integer read FPrinterExtraSpaceRight;
    { Returns the footer space in printer device context's units. }
    property PrinterFooterSpace: Integer read FPrinterFooterSpace;
    { Returns the header space in printer device context's units. }
    property PrinterHeaderSpace: Integer read FPrinterHeaderSpace;
    { Returns the bottom margin in printer device context's units. }
    property PrinterMarginBottom: Integer read FPrinterMarginBottom;
    { Returns the left margin in printer device context's units. }
    property PrinterMarginLeft: Integer read FPrinterMarginLeft;
    { Returns the left margin in printer device context's units with respect to current page. }
    property PrinterMarginLeftMirrored: Integer read FPrinterMarginLeftMirrored;
    { Returns the right margin in printer device context's units. }
    property PrinterMarginRight: Integer read FPrinterMarginRight;
    { Returns the left margin in printer device context's units with respect to current page. }
    property PrinterMarginRightMirrored: Integer read FPrinterMarginRightMirrored;
    { Returns the top margin in printer device context's units. }
    property PrinterMarginTop: Integer read FPrinterMarginTop;
    { Specifies the printer name. }
    property PrinterName: string read FPrinterName write SetPrinterName;
    { Returns the page height in printer device context's pixels. }
    property PrinterPageHeight: Integer read FPrinterPageHeight;
    { Returns the page width in printer device context's pixels. }
    property PrinterPageWidth: Integer read FPrinterPageWidth;
    { Returns the paint area height in printer device context's units. }
    property PrinterPaintAreaHeight: Integer read FPrinterPaintAreaHeight;
    { Returns the paint area width in printer device context's units. }
    property PrinterPaintAreaWidth: Integer read FPrinterPaintAreaWidth;
    { Returns the amount of pixels per inch for the printer device context's horizontal axis }
    property PrinterPixelsPerInchX: Integer read FPrinterPixelsPerInchX;
    { Returns the amount of pixels per inch for the printer device context's vertical axis }
    property PrinterPixelsPerInchY: Integer read FPrinterPixelsPerInchY;
    { Specifies the units for MappedX properties.
      If True, those extents are given in printer device context's pixels,
      otherwise in desktop device context's pixels. It can be adjusted by the descendant
      in the AdjustPageSetup method. }
    property PrintingMapped: Boolean read FPrintingMapped write SetPrintingMapped;
    { Specifies the printing range. }
    property Range: TKPrintRange read FRange write SetRange;
    { Returns True if the associated control has a selection. }
    property SelAvail: Boolean read GetSelAvail;
    { Specifies first page printed if Range is eprRange. }
    property StartPage: Integer read FStartPage write SetStartPage;
    { Specifies the requested scale for the printed shape, in percent.
      If epoFitToPage is specified in Options, this parameter is ignored. }
    property Scale: Integer read FScale write SetScale;
    { Specifies the document title as it appears in printer manager. }
    property Title: string read FTitle write FTitle;
    { Returns the control paint area width on canvas in Units. }
    property UnitControlPaintAreaWidth: Double read FUnitControlPaintAreaWidth;
    { Specifies the horizontal space that should stay free for application
      specific contents at the left side of printed control. Value is given in Units. }
    property UnitExtraSpaceLeft: Double read FUnitExtraSpaceLeft write SetUnitExtraSpaceLeft;
    { Specifies the horizontal space that should stay free for application
      specific contents at the right side of printed control. Value is given in Units. }
    property UnitExtraSpaceRight: Double read FUnitExtraSpaceRight write SetUnitExtraSpaceRight;
    { Specifies the vertical space that should stay free for application
      specific footer. Value is given in Units. }
    property UnitFooterSpace: Double read FUnitFooterSpace write SetUnitFooterSpace;
    { Specifies the vertical space that should stay free for application
      specific header. Value is given in Units. }
    property UnitHeaderSpace: Double read FUnitHeaderSpace write SetUnitHeaderSpace;
    { Specifies the bottom margin. Value is given in Units. }
    property UnitMarginBottom: Double read FUnitMarginBottom write SetUnitMarginBottom;
    { Specifies the left margin. Value is given in Units. }
    property UnitMarginLeft: Double read FUnitMarginLeft write SetUnitMarginLeft;
    { Specifies the right margin. Value is given in Units. }
    property UnitMarginRight: Double read FUnitMarginRight write SetUnitMarginRight;
    { Specifies the top margin. Value is given in Units. }
    property UnitMarginTop: Double read FUnitMarginTop write SetUnitMarginTop;
    { Returns the paint area height on canvas in Units. }
    property UnitPaintAreaHeight: Double read FUnitPaintAreaHeight;
    { Returns the paint area width on canvas in Units. }
    property UnitPaintAreaWidth: Double read FUnitPaintAreaWidth;
    { Specifies the units for print margins. }
    property Units: TKPrintUnits read FUnits write SetUnits;
    { Allows to customize measure info filled from associated control just before
      respective calculations are performed. }
    property OnPrintMeasure: TKPrintMeasureEvent read FOnPrintMeasure write FOnPrintMeasure;
    { Allows to inspect settings before printing information is updated. }
    property OnUpdateSettings: TNotifyEvent read FOnUpdateSettings write FOnUpdateSettings;
  end;

  { @abstract(Container for all colors used by @link(TKPrintPreview) class)
    This container allows to group many colors into one item in object inspector.
    Colors are accessible via published properties or several public Color*
    properties. }
  TKPreviewColors = class(TKCustomColors)
  protected
    { Returns color specification structure for given index. }
    function GetColorSpec(Index: TKColorIndex): TKColorSpec; override;
    { Returns maximum color index. }
    function GetMaxIndex: Integer; override;
  published
    { Specifies the paper background color. }
    property Paper: TColor index ciPaper read GetColor write SetColor default cPaperDef;
    { Specifies the color of the background around paper. }
    property BkGnd: TColor index ciBkGnd read GetColor write SetColor default cBkGndDef;
    { Specifies the color of the paper border. }
    property Border: TColor index ciBorder read GetColor write SetColor default cBorderDef;
    { Specifies the color of the paper border when the control has input focus. }
    property SelectedBorder: TColor index ciSelectedBorder read GetColor write SetColor default cSelectedBorderDef;
  end;

  { @abstract(Print preview control for the TKCustomControl component) }
  TKPrintPreview = class(TKCustomControl)
  private
    FColors: TKPreviewColors;
    FControl: TKCustomControl;
    FMouseWheelAccumulator: Integer;
    FPage: Integer;
    FPageOld: Integer;
    FPageSize: TPoint;
    FExtent: TPoint;
    FPageOffset: TPoint;
    FScale: Integer;
    FScaleMode: TKPreviewScaleMode;
    FScrollExtent: TPoint;
    FScrollPos: TPoint;
    FScrollPosOld: TPoint;
    FX: Integer;
    FY: Integer;
    FOnChanged: TKPreviewChangedEvent;
    function GetCurrentScale: Integer;
    function GetEndPage: Integer;
    function GetStartPage: Integer;
    procedure SetControl(Value: TKCustomControl);
    procedure SetPage(Value: Integer);
    procedure SetScale(Value: Integer);
    procedure SetScaleMode(Value: TKPreviewScaleMode);
    procedure WMEraseBkgnd(var Msg: TLMessage); message LM_ERASEBKGND;
    procedure WMGetDlgCode(var Msg: TLMNoParams); message LM_GETDLGCODE;
    procedure WMHScroll(var Msg: TLMHScroll); message LM_HSCROLL;
    procedure WMKillFocus(var Msg: TLMKillFocus); message LM_KILLFOCUS;
    procedure WMSetFocus(var Msg: TLMSetFocus); message LM_SETFOCUS;
    procedure WMVScroll(var Msg: TLMVScroll); message LM_VSCROLL;
    procedure SetColors(const Value: TKPreviewColors);
  protected
    { Initializes a scroll message handling. }
    procedure BeginScrollWindow;
    { Defines additional styles. }
    procedure CreateParams(var Params: TCreateParams); override;
    { Overriden method - handles mouse wheel messages. }
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    { Calls the ScrollWindowEx function to complete a scroll message. }
    procedure EndScrollWindow;
    { Returns current page rectangle inside of the window client area. }
    function GetPageRect: TRect;
    { Processes virtual key strokes. }
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    { Processes scrollbar messages.
      <UL>
      <LH>Parameters:</LH>
      <LI><I>ScrollBar</I> - scrollbar type from OS</LI>
      <LI><I>ScrollCode</I> - scrollbar action from OS</LI>
      <LI><I>Delta</I> - scrollbar position change</LI>
      </UL> }
    procedure ModifyScrollBar(ScrollBar, ScrollCode, Delta: Integer);
    { Initializes drag&scroll functionality. }
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    { Performs drag&scroll functionality. }
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    { Finalizes drag&scroll functionality. }
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    { Notifies about associated TKCustomControl control removal. }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    { Paints paper and control shape. }
    procedure Paint; override;
    { Calls the @link(OnChanged) event. }
    procedure Changed;
    { Grants the input focus to the control when possible and the control has had none before. }
    procedure SafeSetFocus;
    { Updates mouse cursor. }
    function SetMouseCursor(X, Y: Integer): Boolean; override;
    { Updates page sizes and scrollbar ranges. }
    procedure UpdateScrollRange;
    { Updates the control size. }
    procedure UpdateSize; override;
  public
    { Performs necessary initializations - default values to properties. }
    constructor Create(AOwner: TComponent); override;
    { Destroy instance... }
    destructor Destroy; override;
    { Shows first page for the given range. }
    procedure FirstPage;
    { Shows last page for the given range. }
    procedure LastPage;
    { Shows next page. }
    procedure NextPage;
    { Shows previous page. }
    procedure PreviousPage;
    { Updates the preview. }
    procedure UpdatePreview;
    { Returns the page scaling with regard to the @link(ScaleMode) property. }
    property CurrentScale: Integer read GetCurrentScale;
    { Returns the current page area rectangle in desktop pixels. }
    property PageRect: TRect read GetPageRect;
    { Returns the last page for the given range. }
    property EndPage: Integer read GetEndPage;
    { Returns the first page for the given range. }
    property StartPage: Integer read GetStartPage;
  published
    { Inherited property - see Delphi help. }
    property Align;
    { Inherited property - see Delphi help. }
    property Anchors;
    { See TKCustomControl.@link(TKCustomControl.BorderStyle) for details. }
    property BorderStyle;
    { Inherited property - see Delphi help. }
    property BorderWidth;
    { Specifies all colors used by TKPrintPreview's default painting. }
    property Colors: TKPreviewColors read FColors write SetColors;
    { Inherited property - see Delphi help. }
    property Constraints;
    { Specifies the associated control. }
    property Control: TKCustomControl read FControl write SetControl;
    { Inherited property - see Delphi help. }
    property DragCursor;
    { Inherited property - see Delphi help. }
    property DragKind;
    { Inherited property - see Delphi help. }
    property DragMode;
    { Specifies the currently displayed page. }
    property Page: Integer read FPage write SetPage default 1;
    { Inherited property - see Delphi help. }
    property ParentShowHint;
    { Inherited property - see Delphi help. }
    property PopupMenu;
    { Specifies the user defined page scale - i.e. when ScaleMode = smScale. }
    property Scale: Integer read FScale write SetScale default 100;
    { Specifies the scale mode to display and scroll previewed pages. }
    property ScaleMode: TKPreviewScaleMode read FScaleMode write SetScaleMode default smPageWidth;
    { Inherited property - see Delphi help. }
    property ShowHint;
    { Inherited property - see Delphi help. }
    property TabStop;
    { Inherited property - see Delphi help. }
    property TabOrder;
    { Inherited property - see Delphi help. }
    property Visible;
    { Called whenever print preview is updated. }
    property OnChanged: TKPreviewChangedEvent read FOnChanged write FOnChanged;
    { Inherited property - see Delphi help. }
    property OnClick;
    { Inherited property - see Delphi help. }
    property OnContextPopup;
    { Inherited property - see Delphi help. }
    property OnDblClick;
    { Inherited property - see Delphi help. }
    property OnDockDrop;
    { Inherited property - see Delphi help. }
    property OnDockOver;
    { Inherited property - see Delphi help. }
    property OnDragDrop;
    { Inherited property - see Delphi help. }
    property OnDragOver;
    { Inherited property - see Delphi help. }
    property OnEndDock;
    { Inherited property - see Delphi help. }
    property OnEndDrag;
    { Inherited property - see Delphi help. }
    property OnEnter;
    { Inherited property - see Delphi help. }
    property OnExit;
    { Inherited property - see Delphi help. }
    property OnGetSiteInfo;
    { Inherited property - see Delphi help. }
    property OnKeyDown;
    { Inherited property - see Delphi help. }
    property OnKeyPress;
    { Inherited property - see Delphi help. }
    property OnKeyUp;
    { Inherited property - see Delphi help. }
    property OnMouseDown;
  {$IFDEF COMPILER9_UP}
    { Inherited property - see Delphi help. }
    property OnMouseEnter;
    { Inherited property - see Delphi help. }
    property OnMouseLeave;
  {$ENDIF}
    { Inherited property - see Delphi help. }
    property OnMouseMove;
    { Inherited property - see Delphi help. }
    property OnMouseUp;
    { Inherited property - see Delphi help. }
    property OnMouseWheel;
    { Inherited property - see Delphi help. }
    property OnMouseWheelDown;
    { Inherited property - see Delphi help. }
    property OnMouseWheelUp;
    { Inherited property - see Delphi help. }
    property OnResize;
    { Inherited property - see Delphi help. }
    property OnStartDock;
    { Inherited property - see Delphi help. }
    property OnStartDrag;
    { Inherited property - see Delphi help. }
    property OnUnDock;
  end;

{ Converts a value given in inches into a value given in specified units.
  <UL>
  <LH>Parameters:</LH>
  <LI><I>Units</I> - measurement units for the output value</LI>
  <LI><I>Value</I> - input value to convert</LI>
  </UL> }
function InchesToValue(Units: TKPrintUnits; Value: Double): Double;

{ Converts value given in specified units into a value given in inches.
  <UL>
  <LH>Parameters:</LH>
  <LI><I>Units</I> - measurement units for the input value</LI>
  <LI><I>Value</I> - input value to convert</LI>
  </UL> }
function ValueToInches(Units: TKPrintUnits; Value: Double): Double;

implementation

uses
  Math, Types, KGraphics;

const
  cPreviewHorzBorder = 30;
  cPreviewVertBorder = 30;
  cPreviewShadowSize = 3;

function InchesToValue(Units: TKPrintUnits; Value: Double): Double;
begin
  case Units of
    puMM: Result := Value * 25.4;
    puCM: Result := Value * 2.54;
    puHundredthInch: Result := Value * 100;
  else
    Result := Value;
  end;
end;

function ValueToInches(Units: TKPrintUnits; Value: Double): Double;
begin
  case Units of
    puMM: Result := Value / 25.4;
    puCM: Result := Value / 2.54;
    puHundredthInch: Result := Value / 100;
  else
    Result := Value;
  end;
end;

{ TKRect }

constructor TKRect.Create;
begin
  inherited Create;
  FOnChanged := nil;
  FBottom := cContentPaddingBottomDef;
  FLeft := cContentPaddingLeftDef;
  FRight := cContentPaddingRightDef;
  FTop := cContentPaddingTopDef;
end;

procedure TKRect.Assign(Source: TPersistent);
begin
  if Source is TKRect then
  begin
    Bottom := TKRect(Source).Bottom;
    Left := TKRect(Source).Left;
    Right := TKRect(Source).Right;
    Top := TKRect(Source).Top;
  end;
end;

procedure TKRect.AssignFromRect(const ARect: TRect);
begin
  FBottom := ARect.Bottom;
  FLeft := ARect.Left;
  FRight := ARect.Right;
  FTop := ARect.Top;
end;

procedure TKRect.AssignFromValues(ALeft, ATop, ARight, ABottom: Integer);
begin
  FBottom := ABottom;
  FLeft := ALeft;
  FRight := ARight;
  FTop := ATop;
end;

procedure TKRect.Changed;
begin
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

function TKRect.ContainsPoint(const APoint: TPoint): Boolean;
begin
  Result :=
    (FLeft <= APoint.X) and (APoint.X < FRight) and
    (FTop <= APoint.Y) and (APoint.Y < FBottom);
end;

function TKRect.EqualProperties(const ARect: TKRect): Boolean;
begin
  Result := (ARect <> nil) and
    (FLeft = ARect.Left) and (FRight = ARect.Right) and
    (FTop = ARect.Top) and (FBottom = ARect.Bottom);
end;

function TKRect.NonZero: Boolean;
begin
  Result := (FLeft <> 0) or (FTop <> 0) or (FRight <> 0) or (FBottom <> 0);
end;

function TKRect.OffsetRect(ARect: TKRect): TRect;
begin
  if ARect <> nil then
    Result := Rect(ARect.Left + FLeft, ARect.Top + FTop, ARect.Right - FRight, ARect.Bottom - FBottom)
  else
    Result := CreateEmptyRect;
end;

function TKRect.OffsetRect(const ARect: TRect): TRect;
begin
  Result := Rect(ARect.Left + FLeft, ARect.Top + FTop, ARect.Right - FRight, ARect.Bottom - FBottom);
end;

procedure TKRect.SetBottom(const Value: Integer);
begin
  if FBottom <> Value then
  begin
    FBottom := Value;
    Changed;
  end;
end;

procedure TKRect.SetLeft(const Value: Integer);
begin
  if FLeft <> Value then
  begin
    FLeft := Value;
    Changed;
  end;
end;

procedure TKRect.SetRight(const Value: Integer);
begin
  if FRight <> Value then
  begin
    FRight := Value;
    Changed;
  end;
end;

procedure TKRect.SetTop(const Value: Integer);
begin
  if FTop <> Value then
  begin
    FTop := Value;
    Changed;
  end;
end;

{ TKObject }

constructor TKObject.Create;
begin
  inherited;
  FParent := nil;
  FUpdateLock := 0;
end;

procedure TKObject.Assign(ASource: TKObject);begin
end;

procedure TKObject.CallAfterUpdate;
begin
end;

procedure TKObject.CallBeforeUpdate;
begin
end;

function TKObject.EqualProperties(AValue: TKObject): Boolean;
begin
  Result := True;
end;

procedure TKObject.LockUpdate;
begin
  if FUpdateLock <= 0 then
    CallBeforeUpdate;
  Inc(FUpdateLock);
end;

procedure TKObject.ParentChanged;
begin
end;

procedure TKObject.SetParent(const Value: TKObjectList);
begin
  if Value <> FParent then
  begin
    FParent := Value;
    ParentChanged;
  end;
end;

procedure TKObject.UnLockUpdate;
begin
  if FUpdateLock > 0 then
  begin
    Dec(FUpdateLock);
    if FUpdateLock = 0 then
      CallAfterUpdate;
  end;
end;

function TKObject.UpdateUnlocked: Boolean;
begin
  Result := FUpdateLock <= 0;
end;

{ TKObjectList }

constructor TKObjectList.Create;
begin
  inherited;
  FUpdateLock := 0;
end;

function TKObjectList.Add(AObject: TObject): Integer;begin
  if AObject is TKObject then
    TKObject(AObject).Parent := Self;
  Result := inherited Add(AObject);
end;

procedure TKObjectList.Assign(ASource: TKObjectList);var  I: Integer;  Cls: TKObjectClass;  SrcItem, DstItem: TKObject;begin
  if ASource <> nil then
  begin
    Clear;
    for I := 0 to ASource.Count - 1 do
    begin
      SrcItem := ASource.Items[I] as TKObject;
      Cls := TKObjectClass(SrcItem.ClassType);
      DstItem := Cls.Create;
      DstItem.Parent := Self;
      DstItem.Assign(SrcItem);
      Add(DstItem);
    end;
  end;
end;

procedure TKObjectList.CallBeforeUpdate;
begin
end;

procedure TKObjectList.CallAfterUpdate;
begin
end;

function TKObjectList.EqualProperties(AValue: TKObjectList): Boolean;
var
  I: Integer;
begin
  Result := False;
  if AValue <> nil then
  begin
    Result := AValue.Count = Count;
    if Result then
    begin
      for I := 0 to Count - 1 do
        if not TKObject(Items[I]).EqualProperties(TKObject(AValue[I])) then
        begin
          Result := False;
          Break;
        end;
    end;
  end;
end;

procedure TKObjectList.Insert(Index: Integer; AObject: TObject);
begin
  if AObject is TKObject then
    TKObject(AObject).Parent := Self;
  inherited Insert(Index, AObject);
end;

procedure TKObjectList.LockUpdate;
begin
  if FUpdateLock <= 0 then
    CallBeforeUpdate;
  Inc(FUpdateLock);
end;

procedure TKObjectList.UnLockUpdate;
begin
  if FUpdateLock > 0 then
  begin
    Dec(FUpdateLock);
    if FUpdateLock = 0 then
      CallAfterUpdate;
  end;
end;

function TKObjectList.UpdateUnlocked: Boolean;
begin
  Result := FUpdateLock <= 0;
end;

{ TKCustomControl }

constructor TKCustomControl.Create(AOwner: TComponent);
begin
  inherited;
  BorderStyle := cBorderStyleDef;
  FFlags := 0;
  FMemoryCanvas := nil;
  FMessages := nil;
{$IFNDEF COMPILER10_UP}
  FMouseInClient := False;
{$ENDIF}
  FPageSetup := nil;
{$IF DEFINED(FPC) OR NOT DEFINED(COMPILER10_UP)}
  FParentBackground := True;
  FParentDoubleBuffered := True;
{$IFEND}
  FPreviewList := TList.Create;
  FUpdateLock := 0;
  FOnPrintNotify := nil;
  FOnPrintPaint := nil;
end;

destructor TKCustomControl.Destroy;
begin
  inherited;
  FMessages := nil;
  FreeAndNil(FPreviewList);
  FreeAndNil(FPageSetup);
end;

procedure TKCustomControl.AddPreview(APreview: TKPrintPreview);
begin
  if Assigned(APreview) then
    FPreviewList.Add(APreview);
end;

procedure TKCustomControl.AdjustPageSetup;
begin
end;

procedure TKCustomControl.CancelMode;
begin
end;

{$IFNDEF FPC}
procedure TKCustomControl.CMCancelMode(var Msg: TLMessage);
begin
  inherited;
  CancelMode;
end;

procedure TKCustomControl.CMCtl3DChanged(var Msg: TLMessage);
begin
  inherited;
  RecreateWnd;
end;
{$ENDIF}

procedure TKCustomControl.CMMouseLeave(var Msg: TLMessage);
begin
  inherited;
  try
    MouseFormLeave;
  except
  end;
end;

procedure TKCustomControl.CreateHandle;
begin
  inherited;
  UpdateSize;
end;

procedure TKCustomControl.CreateParams(var Params: TCreateParams);
begin
  inherited;
{$IFNDEF FPC}
  with Params do
  begin
    WindowClass.style := CS_DBLCLKS;
    if BorderStyle = bsSingle then
      if NewStyleControls and Ctl3D then
      begin
        Style := Style and not WS_BORDER;
        ExStyle := ExStyle or WS_EX_CLIENTEDGE;
      end
      else
        Style := Style or WS_BORDER;
  end;
{$ENDIF}
end;

{$IFDEF FPC}
procedure TKCustomControl.DoOnChangeBounds;
begin
  inherited;
  UpdateSize;
end;
{$ENDIF}

function TKCustomControl.Flag(AFlag: Cardinal): Boolean;
begin
  Result := FFlags and AFlag <> 0;
end;

procedure TKCustomControl.FlagAssign(AFlag: Cardinal; Value: Boolean);
begin
  if Value then
    FlagSet(AFlag)
  else
    FlagClear(AFlag);
end;

procedure TKCustomControl.FlagClear(AFlag: Cardinal);
begin
  FFlags := FFlags and not AFlag;
end;

procedure TKCustomControl.FlagSet(AFlag: Cardinal);
begin
  FFlags := FFlags or AFlag;
end;

procedure TKCustomControl.FlagToggle(AFlag: Cardinal);
begin
  FFlags := FFlags xor AFlag;
end;

function TKCustomControl.GetCanPrint: Boolean;
begin
  Result := PageSetup.CanPrint;
end;

function TKCustomControl.GetPageSetup: TKPrintPageSetup;
begin
  if not Assigned(FPageSetup) and not (csDestroying in ComponentState) then
  begin
    FPageSetup := TKPrintPageSetup.Create(Self);
    AdjustPageSetup;
  end;
  if Assigned(FPageSetup) then
    FPageSetup.Validate;
  Result := FPageSetup;
end;

function TKCustomControl.GetPageSetupAllocated: Boolean;
begin
  Result := Assigned(FPageSetup);
end;

function TKCustomControl.InternalGetSelAvail: Boolean;
begin
  Result := False;
end;

procedure TKCustomControl.InternalUnlockUpdate;
begin
end;

procedure TKCustomControl.Invalidate;
begin
  if UpdateUnlocked and HandleAllocated then
    inherited;
end;

procedure TKCustomControl.InvalidatePageSetup;
begin
  if Assigned(FPageSetup) then
    FPageSetup.Invalidate;
end;

procedure TKCustomControl.InvalidateRectArea(const R: TRect);
begin
  if UpdateUnlocked and HandleAllocated then
    InvalidateRect(Handle, @R, False);
end;

function TKCustomControl.IsThemed: Boolean;
begin
  Result := True;
end;

procedure TKCustomControl.KMLateUpdate(var Msg: TLMessage);
var
  M: TLMessage;
begin
  if MessagePeek(M) then
    LateUpdate(M);
end;

procedure TKCustomControl.LateUpdate(var Msg: TLMessage);
begin
  case Msg.Msg of
    LM_SIZE: UpdateSize;
  end;
end;

procedure TKCustomControl.LockUpdate;
begin
  Inc(FUpdateLock);
end;

procedure TKCustomControl.MeasurePages(var Info: TKPrintMeasureInfo);
begin
end;

function TKCustomControl.MessagePeek(out Msg: TLMessage): Boolean;
var
  ALen: Integer;
begin
  ALen := Length(FMessages);
  if ALen > 0 then
  begin
    Dec(ALen);
    Msg := FMessages[ALen];
    SetLength(FMessages, ALen);
    Result := True;
  end else
    Result := False;
end;

procedure TKCustomControl.MessagePoke(const Msg: TLMessage);
var
  ALen: Integer;
begin
  ALen := Length(FMessages);
  SetLength(FMessages, ALen + 1);
  FMessages[ALen] := Msg;
end;

function TKCustomControl.MessageSearch(MsgCode: Cardinal): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Length(FMessages) - 1 do
    if FMessages[I].Msg = MsgCode then
    begin
      Result := True;
      Exit;
    end;
end;

procedure TKCustomControl.MouseFormLeave;
begin
end;

procedure TKCustomControl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
{$IFNDEF COMPILER10_UP}
  CallTrackMouseEvent(Self, FMouseInClient);
{$ENDIF}
{$IFDEF FPC}
  if not MouseCapture then
    SetMouseCursor(X, Y);
{$ENDIF}
end;

procedure TKCustomControl.NotifyPreviews;
var
  I: Integer;
begin
  for I := 0 to FPreviewList.Count - 1 do
    TKPrintPreview(FPreviewList[I]).UpdatePreview;
end;

procedure TKCustomControl.Paint;
begin
  PaintToCanvas(Canvas);
  if Assigned(FMemoryCanvas) then
  begin
  {$IFDEF USE_WINAPI}
    // this is the best method but does not work both on QT and GTK!
    MoveWindowOrg(FMemoryCanvas.Handle, -FMemoryCanvasRect.Left, -FMemoryCanvasRect.Top);
    try
      PaintToCanvas(FMemoryCanvas);
    finally
      MoveWindowOrg(FMemoryCanvas.Handle, FMemoryCanvasRect.Left, FMemoryCanvasRect.Top);
    end;
  {$ELSE}
    FMemoryCanvas.CopyRect(Rect(0, 0, FMemoryCanvasRect.Right - FMemoryCanvasRect.Left,
      FMemoryCanvasRect.Bottom - FMemoryCanvasRect.Top), Canvas, FMemoryCanvasRect);
  {$ENDIF}
    FMemoryCanvas := nil;
  end;
end;

procedure TKCustomControl.PostLateUpdate(const Msg: TLMessage;
  IfNotExists: Boolean);
begin
  if HandleAllocated then
  begin
    if not IfNotExists or not MessageSearch(Msg.Msg) then
      MessagePoke(Msg);
    PostMessage(Handle, KM_LATEUPDATE, 0, 0);
  end;
end;

procedure TKCustomControl.PrintNotify(Status: TKPrintStatus; var Abort: Boolean);
begin
  if Assigned(FOnPrintNotify) then
    FOnPrintNotify(Self, Status, Abort);
end;

procedure TKCustomControl.PrintPaint;
begin
  if Assigned(FOnPrintPaint) then
    FOnPrintPaint(Self);
end;

procedure TKCustomControl.PrintPaintBegin;
begin
end;

procedure TKCustomControl.PrintPaintEnd;
begin
end;

procedure TKCustomControl.PrintOut;
begin
  GetPageSetup.PrintOut;
end;

procedure TKCustomControl.PaintPage;
begin
end;

procedure TKCustomControl.RemovePreview(APreview: TKPrintPreview);
begin
  if Assigned(FPreviewList) and (FPreviewList.IndexOf(APreview) >= 0) then
    FPreviewList.Remove(APreview);
end;

{$IFNDEF FPC}
procedure TKCustomControl.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;
{$ENDIF}

function TKCustomControl.SetMouseCursor(X, Y: Integer): Boolean;
begin
  Result := False;
end;

procedure TKCustomControl.SetPageSetup(Value: TKPrintPageSetup);
begin
  if Value <> FPageSetup then
    GetPageSetup.Assign(Value);
end;

procedure TKCustomControl.UnlockUpdate;
begin
  if FUpdateLock > 0 then
  begin
    Dec(FUpdateLock);
    if FUpdateLock = 0 then
      InternalUnlockUpdate;
  end;
end;

procedure TKCustomControl.UpdateSize;
begin
end;

function TKCustomControl.UpdateUnlocked: Boolean;
begin
  Result := FUpdateLock = 0;
end;

{$IFNDEF FPC}
procedure TKCustomControl.WMCancelMode(var Msg: TWMCancelMode);
begin
  inherited;
  CancelMode;
end;
{$ENDIF}

{$IFNDEF COMPILER10_UP}
procedure TKCustomControl.WMMouseLeave(var Msg: TLMessage);
begin
  { this is because of CM_MOUSELEAVE is not sent if mouse has left client area
    and entered any of the standard control scrollbars. This behavior has been
    fixed via TrackMouseEvent in BDS 2006. }
  inherited;
  FMouseInClient := False;
  Perform(CM_MOUSELEAVE, 0, 0);
end;
{$ENDIF}

{$IFNDEF FPC}
procedure TKCustomControl.WMNCPaint(var Msg: TWMNCPaint);
{$IFDEF USE_THEMES}
var
  R: TRect;
  ExStyle: Integer;
  TempRgn: HRGN;
  BorderWidth,
  BorderHeight: Integer;
{$ENDIF}
begin
{$IFDEF USE_THEMES}
  with ThemeServices do if IsThemed and ThemesEnabled then
  begin
    // If OS themes are enabled and the client edge border is set for the window then prevent the default window proc
    // from painting the old border to avoid flickering.
    ExStyle := GetWindowLong(Handle, GWL_EXSTYLE);
    if (ExStyle and WS_EX_CLIENTEDGE) <> 0 then
    begin
      GetWindowRect(Handle, R);
      // Determine width of the client edge.
      BorderWidth := GetSystemMetrics(SM_CXEDGE);
      BorderHeight := GetSystemMetrics(SM_CYEDGE);
      InflateRect(R, -BorderWidth, -BorderHeight);
      TempRgn := CreateRectRgnIndirect(R);
      // Exclude the border from the message region if there is one. Otherwise just use the inflated
      // window area region.
      if Msg.Rgn <> 1 then
        CombineRgn(TempRgn, Msg.Rgn, TempRgn, RGN_AND);
      DefWindowProc(Handle, Msg.Msg, Integer(TempRgn), 0);
      DeleteObject(TempRgn);
      PaintBorder(Self, True);
    end else
      inherited;
  end else
{$ENDIF}
    inherited;
end;

procedure TKCustomControl.WMSetCursor(var Msg: TWMSetCursor);
var
  MousePt: TPoint;
begin
  if (Msg.HitTest = HTCLIENT) and (Msg.CursorWnd = Handle) then
  begin
    MousePt := ScreenToClient(Mouse.CursorPos);
    if SetMouseCursor(MousePt.X, MousePt.Y) then
      Msg.Result := 1
    else
      inherited
  end else
    inherited;
end;
{$ENDIF}

procedure TKCustomControl.WMSize(var Msg: TLMSize);
begin
  inherited;
  PostLateUpdate(FillMessage(LM_SIZE, 0, 0), True);
end;

{$IFNDEF FPC}
{$IFDEF USE_THEMES}
procedure TKCustomControl.WMThemeChanged(var Msg: TLMessage);
begin
  if IsThemed then
  begin
    inherited;
    ThemeServices.UpdateThemes;
    RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_VALIDATE or RDW_FRAME);
  end;
end;
{$ENDIF}
{$ENDIF}

{ TKCustomColors }

constructor TKCustomColors.Create(AControl: TKCustomControl);
begin
  inherited Create;
  FControl := AControl;
  Initialize;
  ClearBrightColors;
end;

procedure TKCustomColors.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TKCustomColors then
  begin
    Colors := TKCustomColors(Source).Colors;
    FControl.Invalidate;
  end
end;

procedure TKCustomColors.ClearBrightColors;
var
  I: TKColorIndex;
begin
  for I := 0 to Length(FBrightColors) - 1 do
    FBrightColors[I] := clNone;
end;

function TKCustomColors.GetColor(Index: TKColorIndex): TColor;
begin
  Result := InternalGetColor(Index);
end;

function TKCustomColors.GetColorData(Index: TKColorIndex): TKColorData;
var
  ColorSpec: TKColorSpec;
begin
  Result.Index := Index;
  Result.Color := FColors[Index];
  ColorSpec := GetColorSpec(Index);
  Result.Default := ColorSpec.Def;
  Result.Name := ColorSpec.Name;
end;

function TKCustomColors.GetColorEx(Index: TKColorIndex): TColor;
begin
  Result := FColors[Index];
end;

function TKCustomColors.GetColorName(Index: TKColorIndex): string;
begin
  Result := GetColorSpec(Index).Name;
end;

function TKCustomColors.GetColorSpec(Index: TKColorIndex): TKColorSpec;
begin
  Result.Def := clNone;
  Result.Name := '';
end;

function TKCustomColors.GetDefaultColor(Index: TKColorIndex): TColor;
begin
  Result := GetColorSpec(Index).Def;
end;

function TKCustomColors.GetMaxIndex: Integer;
begin
  Result := -1;
end;

procedure TKCustomColors.Initialize;
var
  I, MaxIndex: TKColorIndex;
begin
  MaxIndex := GetMaxIndex;
  SetLength(FColors, MaxIndex + 1);
  SetLength(FBrightColors, MaxIndex + 1);
  for I := 0 to Length(FColors) - 1 do
    FColors[I] := GetColorSpec(I).Def;
end;

function TKCustomColors.InternalGetColor(Index: TKColorIndex): TColor;
begin
  case FColorScheme of
    csBright:
    begin
      if FBrightColors[Index] = clNone then
        FBrightColors[Index] := BrightColor(FColors[Index], 0.5, bsOfTop);
      Result := FBrightColors[Index];
    end;
    csGrayScale:
      Result := ColorToGrayScale(FColors[Index]);
  else
    Result := FColors[Index];
  end;
end;

procedure TKCustomColors.InternalSetColor(Index: TKColorIndex; Value: TColor);
begin
  if FColors[Index] <> Value then
  begin
    FColors[Index] := Value;
    FBrightColors[Index] := clNone;
    if not (csLoading in FControl.ComponentState) then
      FControl.Invalidate;
  end;
end;

procedure TKCustomColors.SetColor(Index: TKColorIndex; Value: TColor);
begin
  InternalSetColor(Index, Value);
end;

procedure TKCustomColors.SetColorEx(Index: TKColorIndex; Value: TColor);
begin
  if FColors[Index] <> Value then
  begin
    FColors[Index] := Value;
    FBrightColors[Index] := clNone;
  end;
end;

procedure TKCustomColors.SetColors(const Value: TKColorArray);
var
  I: Integer;
begin
  for I := 0 to Min(Length(FColors), Length(Value)) - 1 do
    FColors[I] := Value[I];
  ClearBrightColors;
end;

{ TKPrintPageSetup }

constructor TKPrintPageSetup.Create(AControl: TKCustomControl);
begin
  inherited Create;
  FActive := False;
  FCanvas := nil;
  FControl := AControl;
  FControlHorzPageCount := 0;
  FControlPageCount := 0;
  FControlVertPageCount := 0;
  FCopies := cCopiesDef;
  FCurrentCopy := 0;
  FCurrentPage := 0;
  FCurrentScale := 0;
  FMappedOutlineHeight := 0;
  FMappedOutlineWidth := 0;
  FDesktopPixelsPerInchX := 0;
  FDesktopPixelsPerInchY := 0;
  FEndPage := 0;
  FExtraLeftHorzPageCount := 0;
  FExtraLeftPageCount := 0;
  FExtraLeftVertPageCount := 0;
  FExtraRightHorzPageCount := 0;
  FExtraRightPageCount := 0;
  FExtraRightVertPageCount := 0;
  FIsValid := False;
  FOptions := cOptionsDef;
  FOrientation := poPortrait;
  FPageCount := 0;
  FPreviewing := False;
  FPrinterExtraSpaceLeft := 0;
  FPrinterExtraSpaceRight := 0;
  FPrinterFooterSpace := 0;
  FPrinterHeaderSpace := 0;
  FPrinterMarginBottom := 0;
  FPrinterMarginLeft := 0;
  FPrinterMarginLeftMirrored := 0;
  FPrinterMarginRight := 0;
  FPrinterMarginRightMirrored := 0;
  FPrinterMarginTop := 0;
  FPrinterName := '';
  FPrinterPageHeight := 0;
  FPrinterPageWidth := 0;
  FPrinterPixelsPerInchX := 0;
  FPrinterPixelsPerInchY := 0;
  FPrintingMapped := True;
  FRange := cRangeDef;
  FStartPage := 0;
  FScale := cScaleDef;
  FTitle := '';
  FUnitExtraSpaceLeft := 0;
  FUnitExtraSpaceRight := 0;
  FUnitFooterSpace := 0;
  FUnitHeaderSpace := 0;
  FUnitMarginBottom := cMarginBottomDef;
  FUnitMarginLeft := cMarginLeftDef;
  FUnitMarginRight := cMarginRightDef;
  FUnitMarginTop := cMarginTopDef;
  FUnitPaintAreaHeight := 0;
  FUnitPaintAreaWidth := 0;
  FUnits := cUnitsDef;
  FUpdateLock := 0;
  FValidating := False;
  FOnPrintMeasure := nil;
  FOnUpdateSettings := nil;
end;

function TKPrintPageSetup.GetCanPrint: Boolean;
begin
  Result := Assigned(FControl) and (FPageCount > 0) and (Printer.Printers.Count > 0);
end;

function TKPrintPageSetup.GetCurrentPageControl: Integer;
begin
  if (FCurrentPage > FExtraLeftPageCount) and (FCurrentPage <= FExtraLeftPageCount + FControlPageCount) then
    Result := FCurrentPage - FExtraLeftPageCount
  else
    Result := 0; // we are in extra left or right area
end;

function TKPrintPageSetup.GetCurrentPageExtraLeft: Integer;
begin
  if (FCurrentPage > 0) and (FCurrentPage <= FExtraLeftPageCount) then
    Result := FCurrentPage - FExtraLeftPageCount
  else
    Result := 0; // we are in control or extra right area
end;

function TKPrintPageSetup.GetCurrentPageExtraRight: Integer;
begin
  if FCurrentPage > FExtraLeftPageCount + FControlPageCount then
    Result := FCurrentPage - FExtraLeftPageCount - FControlPageCount
  else
    Result := 0; // we are in control or extra left area
end;

function TKPrintPageSetup.GetSelAvail: Boolean;
begin
  if Assigned(FControl) then
    Result := FControl.InternalGetSelAvail
  else
    Result := False;
end;

procedure TKPrintPageSetup.AfterUnitsChange;
begin
  FUnitExtraSpaceLeft := InchesToValue(FUnits, FUnitExtraSpaceLeft);
  FUnitExtraSpaceRight := InchesToValue(FUnits, FUnitExtraSpaceRight);
  FUnitFooterSpace := InchesToValue(FUnits, FUnitFooterSpace);
  FUnitHeaderSpace := InchesToValue(FUnits, FUnitHeaderSpace);
  FUnitMarginBottom := InchesToValue(FUnits, FUnitMarginBottom);
  FUnitMarginLeft := InchesToValue(FUnits, FUnitMarginLeft);
  FUnitMarginRight := InchesToValue(FUnits, FUnitMarginRight);
  FUnitMarginTop := InchesToValue(FUnits, FUnitMarginTop);
end;

procedure TKPrintPageSetup.Assign(Source: TPersistent);
begin
  if Source is TKPrintPageSetup then
  begin
    LockUpdate;
    try
      Copies := TKPrintPageSetup(Source).Copies;
      EndPage := TKPrintPageSetup(Source).EndPage;
      Options := TKPrintPageSetup(Source).Options;
      PrinterName := TKPrintPageSetup(Source).PrinterName;
      Range := TKPrintPageSetup(Source).Range;
      StartPage := TKPrintPageSetup(Source).StartPage;
      Scale := TKPrintPageSetup(Source).Scale;
      Title := TKPrintPageSetup(Source).Title;
      UnitExtraSpaceLeft := TKPrintPageSetup(Source).UnitExtraSpaceLeft;
      UnitExtraSpaceRight := TKPrintPageSetup(Source).UnitExtraSpaceRight;
      UnitFooterSpace := TKPrintPageSetup(Source).UnitFooterSpace;
      UnitHeaderSpace := TKPrintPageSetup(Source).UnitHeaderSpace;
      UnitMarginBottom := TKPrintPageSetup(Source).UnitMarginBottom;
      UnitMarginLeft := TKPrintPageSetup(Source).UnitMarginLeft;
      UnitMarginRight := TKPrintPageSetup(Source).UnitMarginRight;
      UnitMarginTop := TKPrintPageSetup(Source).UnitMarginTop;
      Units := TKPrintPageSetup(Source).Units;
      OnUpdateSettings := TKPrintPageSetup(Source).OnUpdateSettings;
    finally
      UnlockUpdate;
    end;
  end;
end;

procedure TKPrintPageSetup.BeforeUnitsChange;
begin
  FUnitExtraSpaceLeft := ValueToInches(FUnits, FUnitExtraSpaceLeft);
  FUnitExtraSpaceRight := ValueToInches(FUnits, FUnitExtraSpaceRight);
  FUnitFooterSpace := ValueToInches(FUnits, FUnitFooterSpace);
  FUnitHeaderSpace := ValueToInches(FUnits, FUnitHeaderSpace);
  FUnitMarginBottom := ValueToInches(FUnits, FUnitMarginBottom);
  FUnitMarginLeft := ValueToInches(FUnits, FUnitMarginLeft);
  FUnitMarginRight := ValueToInches(FUnits, FUnitMarginRight);
  FUnitMarginTop := ValueToInches(FUnits, FUnitMarginTop);
end;

function TKPrintPageSetup.HMap(Value: Integer): Integer;
begin
  Result := MulDiv(Value, FPrinterPixelsPerInchX, FDesktopPixelsPerInchX);
end;

procedure TKPrintPageSetup.Invalidate;
begin
  FIsValid := False;
end;

procedure TKPrintPageSetup.LockUpdate;
begin
  Inc(FUpdateLock);
end;

procedure TKPrintPageSetup.PaintPageToPreview(APreview: TKPrintPreview);
var
  PaperWidth, PaperHeight,
  DesktopPageWidth, DesktopPageHeight,
  SaveIndex, LeftOffset: Integer;
  R, PageRect: TRect;
begin
  if UpdateUnlocked and Assigned(FControl) then
  begin
    if FActive then
      Invalidate
    else
    begin
      FCanvas := APreview.Canvas;
      FActive := True;
      FPreviewing := True;
      try
        FControl.PrintPaintBegin;
        FCurrentCopy := 1;
        FCurrentPage := APreview.Page;
        if (poMirrorMargins in FOptions) and (FCurrentPage and 1 <> 0) then
        begin
          FPrinterMarginLeftMirrored := FPrinterMarginRight;
          FPrinterMarginRightMirrored := FPrinterMarginLeft;
        end else
        begin
          FPrinterMarginLeftMirrored := FPrinterMarginLeft;
          FPrinterMarginRightMirrored := FPrinterMarginRight;
        end;
        R := APreview.PageRect;
        PaperWidth := R.Right - R.Left;
        PaperHeight := R.Bottom - R.Top;

        if CurrentPageControl > 0 then
        begin
          SaveIndex := SaveDC(FCanvas.Handle);
          try
            if poFitToPage in FOptions then
              LeftOffset := FPrinterExtraSpaceLeft
            else
              LeftOffset := 0;
            // change the canvas mapping mode to scale the page outline
            CanvasSetOffset(FCanvas,
              R.Left + MulDiv(FPrinterMarginLeftMirrored + LeftOffset, PaperWidth, FPrinterPageWidth),
              R.Top + MulDiv(FPrinterMarginTop + FPrinterHeaderSpace, PaperHeight, FPrinterPageHeight));
            if FPrintingMapped then
            begin
              DesktopPageWidth := MulDiv(FPrinterPageWidth, FDesktopPixelsPerInchX, FPrinterPixelsPerInchX);
              DesktopPageHeight := MulDiv(FPrinterPageHeight, FDesktopPixelsPerInchY, FPrinterPixelsPerInchY);
              CanvasSetScale(FCanvas, Round(PaperWidth * FCurrentScale), Round(PaperHeight * FCurrentScale), DesktopPageWidth, DesktopPageHeight);
            end
            else
              CanvasSetScale(FCanvas, PaperWidth, PaperHeight, FPrinterPageWidth, FPrinterPageHeight);
            FControl.PaintPage;
          finally
            RestoreDC(FCanvas.Handle, SaveIndex);
          end;
        end;
        PaperWidth := R.Right - R.Left;
        PaperHeight := R.Bottom - R.Top;
        SaveIndex := SaveDC(FCanvas.Handle);
        try
          CanvasSetOffset(FCanvas, R.Left, R.Top);
          CanvasSetScale(FCanvas, PaperWidth, PaperHeight, FPrinterPageWidth, FPrinterPageHeight);
          PageRect := Rect(0, 0, FPrinterPageWidth, FPrinterPageHeight);
          TranslateRectToDevice(FCanvas.Handle, PageRect);
          SelectClipRect(FCanvas.Handle, PageRect);
          FControl.PrintPaint;
        finally
          RestoreDC(FCanvas.Handle, SaveIndex);
        end;
        SaveIndex := SaveDC(FCanvas.Handle);
        try
          CanvasSetOffset(FCanvas, R.Left, R.Top);
          CanvasSetScale(FCanvas, PaperWidth, PaperHeight, FPrinterPageWidth, FPrinterPageHeight);
          PageRect := Rect(0, 0, FPrinterPageWidth, FPrinterPageHeight);
          TranslateRectToDevice(FCanvas.Handle, PageRect);
          SelectClipRect(FCanvas.Handle, PageRect);
          PrintTitle;
          PrintPageNumber(FCurrentPage);
        finally
          RestoreDC(FCanvas.Handle, SaveIndex);
        end;
        FControl.PrintPaintEnd;
      finally
        FActive := False;
        FPreviewing := False;
        FCanvas := nil;
      end;
    end;
  end;
end;

procedure TKPrintPageSetup.PrintPageNumber(Value: Integer);
var
  S: string;
begin
  if poPageNumbers in FOptions then
  begin
    SetBkMode(FCanvas.Handle, TRANSPARENT);
    FCanvas.Brush.Style := bsClear;
    FCanvas.Font.Color := clBlack;
    FCanvas.Font.Height := 1;
    FCanvas.Font.Height := VMap(16);
    FCanvas.Font.Name := 'Arial';
    FCanvas.Font.Pitch := fpDefault;
    FCanvas.Font.Style := [fsBold];
    S := Format('- %d -', [Value]);
    FCanvas.TextOut(FPrinterMarginLeftMirrored + (FPrinterPageWidth - FPrinterMarginLeft - FPrinterMarginRight - FCanvas.TextWidth(S)) div 2,
      FPrinterPageHeight - FPrinterMarginBottom + VMap(5), S);
  end;
end;

procedure TKPrintPageSetup.PrintTitle;
begin
  if poTitle in FOptions then
  begin
    SetBkMode(FCanvas.Handle, TRANSPARENT);
    FCanvas.Brush.Style := bsClear;
    FCanvas.Font.Color := clBlack;
    FCanvas.Font.Height := 1;
    FCanvas.Font.Height := VMap(16);
    FCanvas.Font.Name := 'Arial';
    FCanvas.Font.Pitch := fpDefault;
    FCanvas.Font.Style := [fsBold];
    FCanvas.TextOut(FPrinterMarginLeftMirrored, FPrinterMarginTop - VMap(36), Title);
    FCanvas.Brush.Style := bsSolid;
    FCanvas.Brush.Color := clBlack;
    FCanvas.FillRect(Rect(FPrinterMarginLeftMirrored, FPrinterMarginTop - VMap(14), FPrinterPageWidth - FPrinterMarginRight, FPrinterMarginTop - VMap(12)));
  end;
end;

procedure TKPrintPageSetup.PrintOut;

  function DoPrint: Boolean;
  var
    LeftOffset, SaveIndex: Integer;
    PageRect: TRect;
  begin
    Result := False;
    if (poMirrorMargins in FOptions) and (FCurrentPage and 1 <> 0) then
    begin
      FPrinterMarginLeftMirrored := FPrinterMarginRight;
      FPrinterMarginRightMirrored := FPrinterMarginLeft;
    end else
    begin
      FPrinterMarginLeftMirrored := FPrinterMarginLeft;
      FPrinterMarginRightMirrored := FPrinterMarginRight;
    end;
    if CurrentPageControl > 0 then
    begin
      SaveIndex := SaveDC(FCanvas.Handle);
      try
        if poFitToPage in FOptions then
          LeftOffset := FPrinterExtraSpaceLeft
        else
          LeftOffset := 0;
        CanvasSetOffset(FCanvas, FPrinterMarginLeftMirrored + LeftOffset, FPrinterMarginTop + FPrinterHeaderSpace);
        if FPrintingMapped then
        begin
          // change the canvas mapping mode to scale the page outline
          CanvasSetScale(FCanvas, Round(FPrinterPageWidth * FCurrentScale), Round(FPrinterPageHeight * FCurrentScale),
            MulDiv(FPrinterPageWidth, FDesktopPixelsPerInchX, FPrinterPixelsPerInchX),
            MulDiv(FPrinterPageHeight, FDesktopPixelsPerInchY, FPrinterPixelsPerInchY));
        end else
          CanvasResetScale(FCanvas);
        FControl.PaintPage;
      finally
        RestoreDC(FCanvas.Handle, SaveIndex);
      end;
    end;
    SaveIndex := SaveDC(FCanvas.Handle);
    try
      CanvasResetScale(FCanvas);
      PageRect := Rect(0, 0, FPrinterPageWidth, FPrinterPageHeight);
      TranslateRectToDevice(FCanvas.Handle, PageRect);
      SelectClipRect(FCanvas.Handle, PageRect);
      FControl.PrintPaint;
    finally
      RestoreDC(FCanvas.Handle, SaveIndex);
    end;
    SaveIndex := SaveDC(FCanvas.Handle);
    try
      CanvasResetScale(FCanvas);
      PageRect := Rect(0, 0, FPrinterPageWidth, FPrinterPageHeight);
      TranslateRectToDevice(FCanvas.Handle, PageRect);
      SelectClipRect(FCanvas.Handle, PageRect);
      PrintTitle;
      PrintPageNumber(FCurrentPage);
    finally
      RestoreDC(FCanvas.Handle, SaveIndex);
    end;
    FControl.PrintNotify(epsNewPage, Result);
    if ((FCurrentPage < FEndPage) or (FCurrentCopy < FCopies)) and not Result then
      Printer.NewPage;
  end;

var
  I, J: Integer;
  AbortPrint: Boolean;
{  Orientation: TPrinterOrientation;
  PaperSize: TPaperSize;
  APageWidth, ApageHeight, APaperWidth, APaperHeight: Integer;
  PrinterType: TPrinterType;
  APaperRect: TPaperRect;}
begin
  if UpdateUnlocked and Assigned(FControl) and not FActive then
  begin
    UpdateSettings;
    if FPageCount > 0 then
    begin
      AbortPrint := False;
      Printer.Title := FTitle;
      Printer.Copies := 1;
{      PrinterType := Printer.PrinterType;
      APageWidth := Printer.PageWidth;
      APageHeight := Printer.PageHeight;
      APaperRect := Printer.PaperSize.PaperRect;
      Orientation := Printer.Orientation;}
      Printer.BeginDoc;
      FActive := True;
      try
        FControl.PrintPaintBegin;
        FCanvas := Printer.Canvas;
        FControl.PrintNotify(epsBegin, AbortPrint);
{        Printer.Canvas.Font.Name := 'Arial';
        Printer.Canvas.Font.color := clBlack;
        Printer.Canvas.Font.height := 100;
        Printer.Canvas.TextOut(200, 200, 'hello!');}
        if not AbortPrint then
        begin
          if poCollate in FOptions then
            for I := 1 to FCopies do
            begin
              FCurrentCopy := I;
              for J := FStartPage to FEndPage do
              begin
                FCurrentPage := J;
                AbortPrint := DoPrint;
                if AbortPrint then Break;
              end;
              if AbortPrint then Break;
            end
          else
            for J := FStartPage to FEndPage do
            begin
              FCurrentPage := J;
              for I := 1 to FCopies do
              begin
                FCurrentCopy := I;
                AbortPrint := DoPrint;
                if AbortPrint then Break;
              end;
              if AbortPrint then Break;
            end
        end;
        FCurrentPage := 0;
        FCurrentCopy := 0;
        FControl.PrintNotify(epsEnd, AbortPrint);
        FControl.PrintPaintEnd;
      finally
        FActive := False;
        Printer.EndDoc;
        FCanvas := nil;
      end;
    end;
  end;
end;

procedure TKPrintPageSetup.SetCopies(Value: Integer);
begin
  if FActive then Exit;
  if Value <> FCopies then
  begin
    FCopies := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetEndPage(Value: Integer);
begin
  if FActive then Exit;
  if Value <> FEndPage then
  begin
    FEndPage := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetOptions(Value: TKPrintOptions);
begin
  if FActive then Exit;
  if Value <> FOptions then
  begin
    FOptions := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetOrientation(AValue: TPrinterOrientation);
begin
  if AValue <> FOrientation then
  begin
    FOrientation := AValue;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetPrinterName(const Value: string);
begin
  if FActive then Exit;
  if Value <> FPrinterName then
  begin
    FPrinterName := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetPrintingMapped(Value: Boolean);
begin
  if FActive then Exit;
  if Value <> FPrintingMapped then
  begin
    FPrintingMapped := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetRange(Value: TKPrintRange);
begin
  if FActive then Exit;
  if Value <> FRange then
  begin
    FRange := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetScale(Value: Integer);
begin
  if FActive then Exit;
  if Value <> FScale then
  begin
    FScale := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetStartPage(Value: Integer);
begin
  if FActive then Exit;
  if Value <> FStartPage then
  begin
    FStartPage := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetUnitExtraSpaceLeft(Value: Double);
begin
  if FActive then Exit;
  if Value <> FUnitExtraSpaceLeft then
  begin
    FUnitExtraSpaceLeft := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetUnitExtraSpaceRight(Value: Double);
begin
  if FActive then Exit;
  if Value <> FUnitExtraSpaceRight then
  begin
    FUnitExtraSpaceRight := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetUnitFooterSpace(Value: Double);
begin
  if FActive then Exit;
  if Value <> FUnitFooterSpace then
  begin
    FUnitFooterSpace := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetUnitHeaderSpace(Value: Double);
begin
  if FActive then Exit;
  if Value <> FUnitHeaderSpace then
  begin
    FUnitHeaderSpace := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetUnitMarginBottom(Value: Double);
begin
  if FActive then Exit;
  if Value <> FUnitMarginBottom then
  begin
    FUnitMarginBottom := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetUnitMarginLeft(Value: Double);
begin
  if FActive then Exit;
  if Value <> FUnitMarginLeft then
  begin
    FUnitMarginLeft := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetUnitMarginRight(Value: Double);
begin
  if FActive then Exit;
  if Value <> FUnitMarginRight then
  begin
    FUnitMarginRight := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetUnitMarginTop(Value: Double);
begin
  if FActive then Exit;
  if Value <> FUnitMarginTop then
  begin
    FUnitMarginTop := Value;
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.SetUnits(Value: TKPrintUnits);
begin
  if FActive then Exit;
  if Value <> FUnits then
  begin
    BeforeUnitsChange;
    FUnits := Value;
    AfterUnitsChange;
  end;
end;

procedure TKPrintPageSetup.UnlockUpdate;
begin
  if FUpdateLock > 0 then
  begin
    Dec(FUpdateLock);
    UpdateSettings;
  end;
end;

procedure TKPrintPageSetup.UpdateSettings;
var
  I, PixelsPerInchX, PixelsPerInchY: Integer;
  D: Double;
  DC: HDC;
  Info: TKPrintMeasureInfo;
begin
  if UpdateUnlocked and not FActive and not FValidating then
  begin
    FValidating := True;
    try
      if Assigned(FOnUpdateSettings) then
        FOnUpdateSettings(Self);
//      Printer.Refresh;
      I := Printer.Printers.IndexOf(FPrinterName);
      if I >= 0 then
        Printer.PrinterIndex := I;
      // set orientation in case somebody assigned it programmatically
      try
        Printer.Orientation := FOrientation;
      except
        FOrientation := Printer.Orientation;
      end;
      // limit copies and Scale
      FCopies := MinMax(FCopies, cCopiesMin, cCopiesMax);
      FScale := MinMax(FScale, cScaleMin, cScaleMax);
      // get metrics for the desktop
      DC := GetDC(0);
      try
        FDesktopPixelsPerInchX := GetDeviceCaps(DC, LOGPIXELSX);
        FDesktopPixelsPerInchY := GetDeviceCaps(DC, LOGPIXELSY);
      finally
        ReleaseDC(0, DC);
      end;
      // get metrics for the printer
      if Printer.Printers.Count > 0 then
      begin
        FPrinterPageWidth := Printer.PageWidth;
        FPrinterPageHeight := Printer.PageHeight;
      {$IFDEF FPC}
        FPrinterPixelsPerInchX := Printer.XDPI;
        FPrinterPixelsPerInchY := Printer.YDPI;
      {$ELSE}
        FPrinterPixelsPerInchX := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
        FPrinterPixelsPerInchY := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
      {$ENDIF}
      end else
      begin
        // fake printer metrics if no printer is installed
        FPrinterPageWidth := 2360;
        FPrinterPageHeight := 3400;
        FPrinterPixelsPerInchX := 300;
        FPrinterPixelsPerInchY := 300;
      end;
      // decide how to outline extent
      if FPrintingMapped then
      begin
        PixelsPerInchX := FDesktopPixelsPerInchX;
        PixelsPerInchY := FDesktopPixelsPerInchY;
      end else
      begin
        PixelsPerInchX := FPrinterPixelsPerInchX;
        PixelsPerInchY := FPrinterPixelsPerInchY;
      end;
      FMappedPageHeight := MulDiv(FPrinterPageHeight, PixelsPerInchX, FPrinterPixelsPerInchX);
      FMappedPageWidth := MulDiv(FPrinterPageWidth, PixelsPerInchX, FPrinterPixelsPerInchX);
      // limit and convert margins
      D := FPrinterPageWidth * 0.4; // 40% of the page
      FPrinterMarginLeft := Round(MinMax(ValueToInches(FUnits, FUnitMarginLeft) * FPrinterPixelsPerInchX, 0, D));
      FUnitMarginLeft := InchesToValue(FUnits, FPrinterMarginLeft / FPrinterPixelsPerInchX);
      FMappedMarginLeft := MulDiv(FPrinterMarginLeft, PixelsPerInchX, FPrinterPixelsPerInchX);
      FPrinterMarginLeftMirrored := FPrinterMarginLeft;
      FMappedMarginLeftMirrored := FMappedMarginLeft;
      FPrinterMarginRight := Round(MinMax(ValueToInches(FUnits, FUnitMarginRight) * FPrinterPixelsPerInchX, 0, D));
      FUnitMarginRight := InchesToValue(FUnits, FPrinterMarginRight / FPrinterPixelsPerInchX);
      FMappedMarginRight := MulDiv(FPrinterMarginRight, PixelsPerInchX, FPrinterPixelsPerInchX);
      FPrinterMarginRightMirrored := FPrinterMarginRight;
      FMappedMarginRightMirrored := FMappedMarginRight;
      D := FPrinterPageHeight * 0.4; // 40% of the page
      FPrinterMarginTop := Round(MinMax(ValueToInches(FUnits, FUnitMarginTop) * FPrinterPixelsPerInchY, 0, D));
      FUnitMarginTop := InchesToValue(FUnits, FPrinterMarginTop / FPrinterPixelsPerInchY);
      FMappedMarginTop := MulDiv(FPrinterMarginTop, PixelsPerInchX, FPrinterPixelsPerInchX);
      FPrinterMarginBottom := Round(MinMax(ValueToInches(FUnits, FUnitMarginBottom) * FPrinterPixelsPerInchY, 0, D));
      FUnitMarginBottom := InchesToValue(FUnits, FPrinterMarginBottom / FPrinterPixelsPerInchY);
      FMappedMarginBottom := MulDiv(FPrinterMarginBottom, PixelsPerInchX, FPrinterPixelsPerInchX);
      // limit and convert header and footer space
      FPrinterHeaderSpace := Round(MinMax(ValueToInches(FUnits, Max(FUnitHeaderSpace, 0)) * FPrinterPixelsPerInchY, 0, D -  FPrinterMarginTop));
      FUnitHeaderSpace := InchesToValue(FUnits, FPrinterHeaderSpace / FPrinterPixelsPerInchY);
      FMappedHeaderSpace := MulDiv(FPrinterHeaderSpace, PixelsPerInchX, FPrinterPixelsPerInchX);
      FPrinterFooterSpace := Round(MinMax(ValueToInches(FUnits, Max(FUnitFooterSpace, 0)) * FPrinterPixelsPerInchY, 0, D -  FPrinterMarginBottom));
      FUnitFooterSpace := InchesToValue(FUnits, FPrinterFooterSpace / FPrinterPixelsPerInchY);
      FMappedFooterSpace := MulDiv(FPrinterFooterSpace, PixelsPerInchX, FPrinterPixelsPerInchX);
      // limit and convert extra space
      FPrinterExtraSpaceLeft := Round(ValueToInches(FUnits, Max(FUnitExtraSpaceLeft, 0)) * FPrinterPixelsPerInchX);
      FUnitExtraSpaceLeft := InchesToValue(FUnits, FPrinterExtraSpaceLeft / FPrinterPixelsPerInchX);
      FMappedExtraSpaceLeft := MulDiv(FPrinterExtraSpaceLeft, PixelsPerInchX, FPrinterPixelsPerInchX);
      FPrinterExtraSpaceRight := Round(ValueToInches(FUnits, Max(FUnitExtraSpaceRight, 0)) * FPrinterPixelsPerInchX);
      FUnitExtraSpaceRight := InchesToValue(FUnits, FPrinterExtraSpaceRight / FPrinterPixelsPerInchX);
      FMappedExtraSpaceRight := MulDiv(FPrinterExtraSpaceRight, PixelsPerInchX, FPrinterPixelsPerInchX);
      // paint area extent
      FPrinterPaintAreaHeight := FPrinterPageHeight - FPrinterMarginTop - FPrinterMarginBottom - FPrinterHeaderSpace - FPrinterFooterSpace;
      FUnitPaintAreaHeight := InchesToValue(FUnits, FPrinterPaintAreaHeight / FPrinterPixelsPerInchY);
      FMappedPaintAreaHeight := MulDiv(FPrinterPaintAreaHeight, PixelsPerInchY, FPrinterPixelsPerInchY);
      FPrinterPaintAreaWidth := FPrinterPageWidth - FPrinterMarginLeft - FPrinterMarginRight;
      FUnitPaintAreaWidth := InchesToValue(FUnits, FPrinterPaintAreaWidth / FPrinterPixelsPerInchX);
      FMappedPaintAreaWidth := MulDiv(FPrinterPaintAreaWidth, PixelsPerInchX, FPrinterPixelsPerInchX);
      // control paint area extent
      FPrinterControlPaintAreaWidth := FPrinterPaintAreaWidth;
      if poFitToPage in FOptions then
        Dec(FPrinterControlPaintAreaWidth, FPrinterExtraSpaceLeft + FPrinterExtraSpaceRight);
      FUnitControlPaintAreaWidth := InchesToValue(FUnits, FPrinterControlPaintAreaWidth / FPrinterPixelsPerInchX);
      FMappedControlPaintAreaWidth := MulDiv(FPrinterControlPaintAreaWidth, PixelsPerInchX, FPrinterPixelsPerInchX);

      // default horizontal scaling
      FCurrentScale := FScale / 100;
      // default page/copy info
      FCurrentCopy := 0;
      FCurrentPage := 0;
      // measured data
      if Assigned(FControl) then
      begin
        FillChar(Info, SizeOf(TKPrintMeasureInfo), 0);
        FControl.MeasurePages(Info);
        if Assigned(FOnPrintMeasure) then
          FOnPrintMeasure(Self, Info);
        FMappedOutlineWidth := Info.OutlineWidth;
        FMappedOutlineHeight := Info.OutlineHeight;
        FExtraLeftHorzPageCount := Info.ExtraLeftHorzPageCount;
        FExtraLeftVertPageCount := Info.ExtraLeftVertPageCount;
        FExtraLeftPageCount := FExtraLeftHorzPageCount * FExtraLeftVertPageCount;
        FExtraRightHorzPageCount := Info.ExtraRightHorzPageCount;
        FExtraRightVertPageCount := Info.ExtraRightVertPageCount;
        FExtraRightPageCount := FExtraRightHorzPageCount * FExtraRightVertPageCount;
        FControlHorzPageCount := Info.ControlHorzPageCount;
        FControlVertPageCount := Info.ControlVertPageCount;
        FControlPageCount := FControlHorzPageCount * FControlVertPageCount;
        FPageCount := FExtraLeftPageCount + FControlPageCount + FExtraRightPageCount;
        if FPageCount > 0 then
        begin
          // update horizontal scaling
          if (poFitToPage in FOptions) and (FMappedOutlineWidth > 0) then
            FCurrentScale := FMappedControlPaintAreaWidth / FMappedOutlineWidth;
          // limit start and end page
          case FRange of
            prAll, prSelectedOnly:
            begin
              FStartPage := 1;
              FEndPage := FPageCount;
            end;
            prRange:
            begin
              FEndPage := MinMax(FEndPage, 1, FPageCount);
              FStartPage := MinMax(FStartPage, 1, FEndPage);
            end;
          end;
        end;
        // notify all previews/ force their repainting
        FControl.NotifyPreviews;
      end else
      begin
        FMappedOutlineWidth := 0;
        FMappedOutlineHeight := 0;
        FExtraLeftHorzPageCount := 0;
        FExtraLeftVertPageCount := 0;
        FExtraRightHorzPageCount := 0;
        FExtraRightVertPageCount := 0;
        FControlHorzPageCount := 0;
        FControlVertPageCount := 0;
        FPageCount := 0;
        FEndPage := 0;
        FStartPage := 0;
      end;
      FIsValid := True;
    finally
      FValidating := False;
    end;
  end;
end;

function TKPrintPageSetup.UpdateUnlocked: Boolean;
begin
  Result := FUpdateLock = 0;
end;

procedure TKPrintPageSetup.Validate;
begin
  if not FIsValid and not FValidating then
    UpdateSettings;
end;

function TKPrintPageSetup.VMap(Value: Integer): Integer;
begin
  Result := MulDiv(Value, FPrinterPixelsPerInchY, FDesktopPixelsPerInchY);
end;

{ TKPreviewColors }

function TKPreviewColors.GetColorSpec(Index: TKColorIndex): TKColorSpec;
begin
  case Index of
    ciPaper: begin Result.Def := cPaperDef; Result.Name := ''; end;
    ciBkGnd: begin Result.Def := cBkGndDef; Result.Name := ''; end;
    ciBorder: begin Result.Def := cBorderDef; Result.Name := ''; end;
    ciSelectedBorder: begin Result.Def := cSelectedBorderDef; Result.Name := ''; end;
  else
    Result := inherited GetColorSpec(Index);
  end;
end;

function TKPreviewColors.GetMaxIndex: Integer;
begin
  Result := ciPreviewColorsMax;
end;

{ TKPrintPreview }

constructor TKPrintPreview.Create(AOwner: TComponent);
begin
  inherited;
  FColors := TKPreviewColors.Create(Self);
  FControl := nil;
  FMouseWheelAccumulator := 0;
  FPage := 1;
  FPageSize := CreateEmptyPoint;
  FScale := 100;
  FScaleMode := smPageWidth;
  FOnChanged := nil;
  LoadCustomCursor(crDragHandFree, 'KPREVIEW_CURSOR_HAND_FREE');
  LoadCustomCursor(crDragHandGrip, 'KPREVIEW_CURSOR_HAND_GRIP');
  Width := 300;
  Height := 200;
end;

destructor TKPrintPreview.Destroy;
begin
  if Assigned(FControl) then
    FControl.RemovePreview(Self);
  inherited;
  FColors.Free;
end;

procedure TKPrintPreview.BeginScrollWindow;
begin
  FPageOld := FPage;
  FScrollPosOld := FScrollPos;
end;

procedure TKPrintPreview.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
    Style := Style or WS_HSCROLL or WS_VSCROLL;
end;

function TKPrintPreview.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
const
  cWheelDivisor = 120;
var
  Delta, WheelClicks: Integer;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if not Result then
  begin
    if ssCtrl in Shift then
    begin
      if FScaleMode = smWholePage then Delta := 10 else Delta := ClientHeight;
    end else
      if FScaleMode = smWholePage then Delta := 1 else Delta := ClientHeight div 10;
    Inc(FMouseWheelAccumulator, WheelDelta);
    WheelClicks := FMouseWheelAccumulator div cWheelDivisor;
    FMouseWheelAccumulator := FMouseWheelAccumulator mod cWheelDivisor;
    BeginScrollWindow;
    ModifyScrollBar(SB_VERT, -1, -WheelClicks * Delta);
    EndScrollWindow;
    Result := True;
  end;
end;

procedure TKPrintPreview.EndScrollWindow;
begin
  if (FPage <> FPageOld) then
    Invalidate
  else if (FScrollPos.X <> FScrollPosOld.X) or (FScrollPos.Y <> FScrollPosOld.Y) then
  begin
    ScrollWindowEx(Handle, FScrollPosOld.X - FScrollPos.X, FScrollPosOld.Y - FScrollPos.Y,
      nil, nil, 0, nil, SW_INVALIDATE);
  end;
end;

procedure TKPrintPreview.FirstPage;
begin
  Page := StartPage;
end;

function TKPrintPreview.GetCurrentScale: Integer;
begin
  if Assigned(FControl) then
    Result := MulDiv(FPageSize.X, 100, MulDiv(FControl.PageSetup.PrinterPageWidth, 300, FControl.PageSetup.PrinterPixelsPerInchX))
  else
    Result := FScale;
end;

function TKPrintPreview.GetEndPage: Integer;
begin
  if Assigned(FControl) then
  begin
    Result := FControl.PageSetup.EndPage;
    if Result = 0 then
    begin
      FControl.PageSetup.UpdateSettings;
      Result := FControl.PageSetup.EndPage
    end;
  end else
    Result := 0;
end;

function TKPrintPreview.GetPageRect: TRect;
begin
  with Result do
  begin
    Left := FPageOffset.X - FScrollPos.X;
    if FScaleMode = smWholePage then
      Top := FPageOffset.Y
    else
      Top := FPageOffset.Y - FScrollPos.Y;
    Right := Left + FPageSize.X;
    Bottom := Top + FPageSize.Y;
  end;
end;

function TKPrintPreview.GetStartPage: Integer;
begin
  if Assigned(FControl) then
  begin
    Result := FControl.PageSetup.StartPage;
    if Result = 0 then
    begin
      FControl.PageSetup.UpdateSettings;
      Result := FControl.PageSetup.StartPage
    end;
  end else
    Result := 0;
end;

procedure TKPrintPreview.KeyDown(var Key: Word; Shift: TShiftState);
var
  DeltaX, DeltaY, LineX, PageY: Integer;
  NoAlt, NoAltCtrl: Boolean;
begin
  NoAlt := Shift * [ssAlt] = [];
  NoAltCtrl := Shift * [ssAlt, ssCtrl] = [];
  DeltaX := 0;
  DeltaY := 0;
  LineX := ClientWidth div 10;
  PageY := ClientHeight;
  case Key of
    VK_UP:
      if NoAltCtrl then
      begin
        if FScaleMode = smWholePage then
          PreviousPage
        else
          DeltaY := -PageY div 10;
      end;
    VK_DOWN:
      if NoAltCtrl then
      begin
        if FScaleMode = smWholePage then
          NextPage
        else
          DeltaY := PageY div 10;
      end;
    VK_PRIOR:
      if NoAltCtrl then
      begin
        if FScaleMode = smWholePage then
          PreviousPage
        else
          DeltaY := -PageY;
      end;
    VK_NEXT:
      if NoAltCtrl then
      begin
        if FScaleMode = smWholePage then
          NextPage
        else
          DeltaY := PageY;
      end;
    VK_LEFT: if NoAltCtrl then DeltaX := -LineX;
    VK_RIGHT: if NoAltCtrl then DeltaX := LineX;
    VK_HOME:
      if NoAlt then
      begin
        if ssCtrl in Shift then
          FirstPage
        else
          DeltaX := -FScrollPos.X;
      end;
    VK_END:
      if NoAlt then
      begin
        if ssCtrl in Shift then
          LastPage
        else
          DeltaX := FScrollExtent.X - FScrollPos.X;
      end;
  end;
  if (DeltaX <> 0) or (DeltaY <> 0) then
  begin
    BeginScrollWindow;
    if DeltaX <> 0 then
      ModifyScrollBar(SB_HORZ, -1, DeltaX);
    if DeltaY <> 0 then
      ModifyScrollBar(SB_VERT, -1, DeltaY);
    EndScrollWindow;
  end;
end;

procedure TKPrintPreview.LastPage;
begin
  Page := EndPage;
end;

procedure TKPrintPreview.ModifyScrollBar(ScrollBar, ScrollCode, Delta: Integer);
var
  I, AEndPage: Integer;
  Divisor: Cardinal;
  PPos, PExtent: PInteger;
  SI: TScrollInfo;
begin
  Divisor := 10;
  if ScrollBar = SB_HORZ then
  begin
    PPos := @FScrollPos.X;
    PExtent := @FScrollExtent.X;
  end else
  begin
    if FScaleMode = smWholePage then
    begin
      PPos := @FPage;
      AEndPage := EndPage;
      PExtent := @AEndPage;
      Divisor := 1;
    end else
    begin
      PPos := @FScrollPos.Y;
      PExtent := @FScrollExtent.Y;
    end;
  end;
  if PExtent^ > 0 then
  begin
    SI.cbSize := SizeOf(TScrollInfo);
    SI.fMask := SIF_RANGE or SIF_PAGE or SIF_TRACKPOS;
    GetScrollInfo(Handle, ScrollBar, SI);
  {$IF DEFINED(LCLGTK2)}
    {.$WARNING "scrollbar arrows still not working properly on GTK2 in some cases!"}
    SI.nTrackPos := Delta;
  {$IFEND}
    I := PPos^;
    case ScrollCode of
      SB_TOP: I := SI.nMin;
      SB_BOTTOM: I := SI.nMax; // will be trimmed below
      SB_LINEUP: Dec(I, SI.nPage div Divisor);
      SB_LINEDOWN: Inc(I, SI.nPage div Divisor);
      SB_PAGEUP: Dec(I, SI.nPage);
      SB_PAGEDOWN: Inc(I, SI.nPage);
      SB_THUMBTRACK, SB_THUMBPOSITION: I := SI.nTrackPos;
    else
      Inc(I, Delta)
    end;
    if FScaleMode = smWholePage then
      I := MinMax(I, 1, PExtent^)
    else
      I := MinMax(I, 0, PExtent^);
    PPos^ := I;  
    SI.nPos := I;
    SI.fMask := SIF_POS;
    SetScrollInfo(Handle, ScrollBar, SI, True);
  end;
end;

procedure TKPrintPreview.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if ssLeft in Shift then
  begin
    SafeSetFocus;
    if (FScaleMode <> smWholePage) and PtInRect(GetPageRect, Point(X, Y)) then
    begin
      FlagSet(cPF_Dragging);
      FX := X;
      FY := Y;
      SetMouseCursor(X, Y);
    end;
  end;
end;

procedure TKPrintPreview.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Flag(cPF_Dragging) and MouseCapture then
  begin
    BeginScrollWindow;
    if (X > FX) and (FScrollPos.X > 0) or (X < FX) and (FScrollPos.X < FScrollExtent.X) then
    begin
      ModifyScrollBar(SB_HORZ, -1, FX - X);
      FX := X;
    end;
    if (Y > FY) and (FScrollPos.Y > 0) or (Y < FY) and (FScrollPos.Y < FScrollExtent.Y) then
    begin
      ModifyScrollBar(SB_VERT, -1, FY - Y);
      FY := Y;
    end;
    EndScrollWindow;
  end;
end;

procedure TKPrintPreview.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FlagClear(cPF_Dragging);
  SetMouseCursor(X, Y);
end;

procedure TKPrintPreview.NextPage;
begin
  Page := Page + 1;
end;

procedure TKPrintPreview.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FControl) then
  begin
    FControl := nil;
    UpdatePreview;
  end;
end;

procedure TKPrintPreview.Paint;

  procedure DoPaint(IsBuffer: Boolean);
  var
    C: TColor;
    R, RPaper, RPage: TRect;
    RgnPaper: HRGN;
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Pen.Mode := pmCopy;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Width := 1;
    RPage := GetPageRect;
    RPaper := RPage;
    with RPaper do
    begin
      Inc(Right, cPreviewShadowSize);
      Inc(Bottom, cPreviewShadowSize);
    end;
    if not IsBuffer then
      RgnPaper := CreateRectRgnIndirect(RPaper)
    else
      RgnPaper := 0;
    try
      // paint background around paper, we don't want at least this to flicker
      if IsBuffer or (ExtSelectClipRgn(Canvas.Handle, RgnPaper, RGN_DIFF) <> NULLREGION) then
      begin
        Canvas.Brush.Color := FColors.BkGnd;
        Canvas.FillRect(ClientRect);
      end;
      if not IsBuffer then
        SelectClipRgn(Canvas.Handle, RgnPaper);
    finally
      if not IsBuffer then
        DeleteObject(rgnPaper);
    end;
    // paint paper outline
    if Focused then
      C := FColors.SelectedBorder
    else
      C := FColors.Border;
    Canvas.Pen.Color := C;
    Canvas.Brush.Color := FColors.Paper;
    Canvas.Rectangle(RPage);
    Canvas.Brush.Color := FColors.BkGnd;
    R := Rect(RPage.Left, RPage.Bottom, RPage.Left + cPreviewShadowSize, RPage.Bottom + cPreviewShadowSize);
    Canvas.FillRect(R);
    R := Rect(RPage.Right, RPage.Top, RPage.Right + cPreviewShadowSize, RPage.Top + cPreviewShadowSize);
    Canvas.FillRect(R);
    Canvas.Brush.Color := C;
    R := Rect(RPage.Left + cPreviewShadowSize, RPage.Bottom, RPaper.Right, RPaper.Bottom);
    Canvas.FillRect(R);
    R := Rect(RPage.Right, RPage.Top + cPreviewShadowSize, RPaper.Right, RPaper.Bottom);
    Canvas.FillRect(R);
    // paint page outline
    InflateRect(RPage, -1, -1);
    FControl.PageSetup.PaintPageToPreview(Self);
  end;

var
  SaveIndex: Integer;
  RClient: TRect;
{$IFDEF USE_WINAPI}
  Org: TPoint;
  MemBitmap, OldBitmap: HBITMAP;
  DC: HDC;
{$ENDIF}
begin
  RClient := ClientRect;
  if Assigned(FControl) then
  begin
    SaveIndex := SaveDC(Canvas.Handle);
    try
    {$IFDEF USE_WINAPI}
      if DoubleBuffered then
      begin
        // we must paint always the entire client because of canvas scaling
        MemBitmap := CreateCompatibleBitmap(Canvas.Handle, RClient.Right - RClient.Left, RClient.Bottom - RClient.Top);
        try
          OldBitmap := SelectObject(Canvas.Handle, MemBitmap);
          try
            SetWindowOrgEx(Canvas.Handle, 0, 0, @Org);
            SelectClipRect(Canvas.Handle, Rect(0, 0, RClient.Right - RClient.Left, RClient.Bottom - RClient.Top));
            DoPaint(True);
          finally
            SelectObject(Canvas.Handle, OldBitmap);
            SetWindowOrgEx(Canvas.Handle, Org.X, Org.Y, nil);
          end;
          // copy MemBitmap to original canvas
          DC := CreateCompatibleDC(Canvas.Handle);
          try
            OldBitmap := SelectObject(DC, MemBitmap);
            try
              CopyBitmap(Canvas.Handle, RClient, DC, 0, 0);
            finally
              SelectObject(DC, OldBitmap);
            end;
          finally
            DeleteDC(DC);
          end;
        finally
          DeleteObject(MemBitmap);
        end;
      end else
    {$ENDIF}
        DoPaint(False);
    finally
      RestoreDC(Canvas.Handle, SaveIndex);
    end;
  end else
  begin
    Canvas.Brush.Color := FColors.BkGnd;
    Canvas.FillRect(RClient);
  end;
end;

procedure TKPrintPreview.Changed;
begin
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TKPrintPreview.PreviousPage;
begin
  Page := Page - 1;
end;

procedure TKPrintPreview.SafeSetFocus;
var
  Form: TCustomForm;
begin
  Form := GetParentForm(Self);
  if (Form <> nil) and Form.Visible and Form.Enabled and Visible and Enabled then
    Form.ActiveControl := Self;
end;

procedure TKPrintPreview.SetColors(const Value: TKPreviewColors);
begin
  FColors.Assign(Value);
end;

procedure TKPrintPreview.SetControl(Value: TKCustomControl);
begin
  if (Value <> FControl) and (Value <> Self) and not (Value is TKPrintPreview) then
  begin
    if Assigned(FControl) then
      FControl.RemovePreview(Self);
    FControl := Value;
    if Assigned(FControl) then
      FControl.AddPreview(Self);
    UpdatePreview;
  end;
end;

procedure TKPrintPreview.SetPage(Value: Integer);
begin
  Value := MinMax(Value, StartPage, EndPage);
  if Value <> FPage then
  begin
    BeginScrollWindow;
    if FScaleMode = smWholePage then
      ModifyScrollBar(SB_VERT, -1, Value - FPage)
    else
      FPage := Value;
    EndScrollWindow;
    Changed;
  end;
end;

procedure TKPrintPreview.SetScale(Value: Integer);
begin
  Value := MinMax(Value, cScaleMin, cScaleMax);
  if Value <> FScale then
  begin
    FScale := Value;
    UpdatePreview;
  end;
end;

procedure TKPrintPreview.SetScaleMode(Value: TKPreviewScaleMode);
begin
  if Value <> FScaleMode then
  begin
    FScaleMode := Value;
    UpdatePreview;
  end;
end;

function TKPrintPreview.SetMouseCursor(X, Y: Integer): Boolean;
var
  ACursor: TCursor;
begin
  if PtInRect(GetPageRect, Point(X, Y)) and (FScaleMode <> smWholePage) then
  begin
    if MouseCapture then
      ACursor := crDragHandGrip
    else
      ACursor := crDragHandFree;
  end else
    ACursor := crDefault;
{$IFDEF FPC}
  FCursor := ACursor;
  SetTempCursor(ACursor);
{$ELSE}
  Windows.SetCursor(Screen.Cursors[ACursor]);
{$ENDIF}
  Result := True;
end;

procedure TKPrintPreview.UpdatePreview;
begin
  Page := FPage;
  UpdateScrollRange;
  Changed;
end;

procedure TKPrintPreview.UpdateScrollRange;
var
  I: Integer;
  PageWidth100Percent, PageHeight100Percent: Integer;
  SI: TScrollInfo;
begin
  if HandleAllocated and not Flag(cPF_UpdateRange) then
  begin
    FlagSet(cPF_UpdateRange);
    try
      if Assigned(FControl) then
      begin
        // get isotropic page size in 300 dpi
        PageWidth100Percent := MulDiv(FControl.PageSetup.PrinterPageWidth, 300, FControl.PageSetup.PrinterPixelsPerInchX);
        PageHeight100Percent := MulDiv(FControl.PageSetup.PrinterPageHeight, 300, FControl.PageSetup.PrinterPixelsPerInchY);
        case FScaleMode of
          smScale:
          begin
            FPageSize.X := MulDiv(PageWidth100Percent, FScale, 100);
            FPageSize.Y := MulDiv(PageHeight100Percent, FScale, 100);
          end;
          smPageWidth:
          begin
            FPageSize.X := Max(ClientWidth - 2 * cPreviewHorzBorder - cPreviewShadowSize, 40);
            FPageSize.Y := MulDiv(FPageSize.X, PageHeight100Percent, PageWidth100Percent);
          end;
          smWholePage:
          begin
            FPageSize.X := Max(ClientWidth - 2 * cPreviewHorzBorder - cPreviewShadowSize, 40);
            FPageSize.Y := Max(ClientHeight - 2 * cPreviewVertBorder - cPreviewShadowSize, 40);
            I := MulDiv(FPageSize.Y, PageWidth100Percent, PageHeight100Percent);
            if I < FPageSize.X then
              FPageSize.X := I
            else
              FPageSize.Y := MulDiv(FPageSize.X, PageHeight100Percent, PageWidth100Percent);
          end;
        end;
        FExtent.X := FPageSize.X + 2 * cPreviewHorzBorder + cPreviewShadowSize;
        FExtent.Y := FPageSize.Y + 2 * cPreviewVertBorder + cPreviewShadowSize;
        FPageOffset.X := cPreviewHorzBorder;
        if (FExtent.X < ClientWidth) then
          Inc(FPageOffset.X, (ClientWidth - FExtent.X) div 2);
        FPageOffset.Y := cPreviewVertBorder;
        if (FExtent.Y < ClientHeight) then
          Inc(FPageOffset.Y, (ClientHeight - FExtent.Y) div 2);
        // adjust horizontal scroll position
        I := FScrollPos.X + ClientWidth - FExtent.X - 1;
        if I > 0 then
          Dec(FScrollPos.X, I);
        FScrollPos.X := Max(FScrollPos.X, 0);
        // adjust vertical scroll position
        I := FScrollPos.Y + ClientHeight - FExtent.Y - 1;
        if I > 0 then
          Dec(FScrollPos.Y, I);
        FScrollPos.Y := Max(FScrollPos.Y, 0);
        // update scroll range
        FScrollExtent.X := 0;
        FScrollExtent.Y := 0;
        FillChar(SI, SizeOf(TScrollInfo), 0);
        SI.cbSize := SizeOf(TScrollInfo);
        SI.fMask := SIF_RANGE or SIF_PAGE or SIF_POS or SIF_DISABLENOSCROLL {$IFDEF UNIX}or SIF_UPDATEPOLICY{$ENDIF};
        SI.nMin := 0;
      {$IFDEF UNIX}
        SI.ntrackPos := SB_POLICY_CONTINUOUS;
      {$ENDIF}
        case FScaleMode of
          smScale:
          begin
            ShowScrollbar(Handle, SB_HORZ, True);
            ShowScrollbar(Handle, SB_VERT, True);
            SI.nMax := FExtent.X{$IFDEF FPC}+ 1{$ENDIF};
            SI.nPage := ClientWidth;
            SI.nPos := FScrollPos.X;
            FScrollExtent.X := SI.nMax - Integer(SI.nPage);
            SetScrollInfo(Handle, SB_HORZ, SI, True);
            SI.nMax := FExtent.Y{$IFDEF FPC}+ 1{$ENDIF};
            SI.nPage := ClientHeight;
            SI.nPos := FScrollPos.Y;
            FScrollExtent.Y := SI.nMax - Integer(SI.nPage);
            SetScrollInfo(Handle, SB_VERT, SI, True);
          end;
          smPageWidth:
          begin
            ShowScrollbar(Handle, SB_HORZ, False);
            ShowScrollbar(Handle, SB_VERT, True);
            SI.nMax := FExtent.Y{$IFDEF FPC}+ 1{$ENDIF};
            SI.nPage := ClientHeight;
            SI.nPos := FScrollPos.Y;
            FScrollExtent.Y := SI.nMax - Integer(SI.nPage);
            SetScrollInfo(Handle, SB_VERT, SI, True);
          end;
          smWholePage:
          begin
            // another mode for vertical scrollbar - page selection
            ShowScrollbar(Handle, SB_HORZ, False);
            ShowScrollbar(Handle, SB_VERT, True);
            SI.nMin := StartPage;
            SI.nMax := EndPage{$IFDEF FPC}+ 1{$ENDIF};
            SI.nPage := 1;
            SI.nPos := FPage;
            SetScrollInfo(Handle, SB_VERT, SI, True);
          end;
        end;
      end else
      begin
        ShowScrollbar(Handle, SB_HORZ, False);
        ShowScrollbar(Handle, SB_VERT, False);
      end;
      Invalidate;
    finally
      FlagClear(cPF_UpdateRange);
    end;
  end;
end;

procedure TKPrintPreview.UpdateSize;
begin
  inherited;
  UpdatePreview;
end;

procedure TKPrintPreview.WMEraseBkgnd(var Msg: TLMessage);
begin
  Msg.Result := 1;
end;

procedure TKPrintPreview.WMGetDlgCode(var Msg: TLMNoParams);
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TKPrintPreview.WMHScroll(var Msg: TLMHScroll);
begin
  SafeSetFocus;
  BeginScrollWindow;
  ModifyScrollBar(SB_HORZ, Msg.ScrollCode, Msg.Pos);
  EndScrollWindow;
end;

procedure TKPrintPreview.WMKillFocus(var Msg: TLMKillFocus);
begin
  inherited;
  Invalidate;
end;

procedure TKPrintPreview.WMSetFocus(var Msg: TLMSetFocus);
begin
  inherited;
  Invalidate;
end;

procedure TKPrintPreview.WMVScroll(var Msg: TLMVScroll);
begin
  SafeSetFocus;
  BeginScrollWindow;
  ModifyScrollBar(SB_VERT, Msg.ScrollCode, Msg.Pos);
  EndScrollWindow;
end;

{$IFDEF FPC}
initialization
  {$i kcontrols.lrs}
{$ELSE}
  {$R kcontrols.res}
{$ENDIF}
end.