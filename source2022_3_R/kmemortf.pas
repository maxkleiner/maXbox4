{ @abstract(This unit contains RTF reader and writer for TKMemo control)
  @author(Tomas Krysl (tk@tkweb.eu))
  @created(28 Apr 2009)
  @lastmod(30 July 2015)

  Copyright � Tomas Krysl (tk@@tkweb.eu)<BR><BR>

  <B>License:</B><BR>
  This code is distributed as a freeware. You are free to use it as part
  of your application for any purpose including freeware, commercial and
  shareware applications. The origin of this source code must not be
  misrepresented; you must not claim your authorship. All redistributions
  of the original or modified source code must retain the original copyright
  notice. The Author accepts no liability for any damage that may result
  from using this code.
}

unit KMemoRTF;

{$include kcontrols.inc}
{$WEAKPACKAGEUNIT ON}

interface

uses
  Classes, Contnrs, Graphics, Controls, Types,
  KControls, KFunctions, KGraphics, KMemo;

type
  TKMemoRTFCtrlMethod = procedure(ACtrl: Integer; var AText: AnsiString; AParam: Integer) of object;

  { Specifies the RTF control word descriptor. Is only used by RTF reader. }
  TKMemoRTFCtrl = class(TObject)
  private
    FCode: Integer;
    FCtrl: AnsiString;
    FMethod: TKMemoRTFCtrlMethod;
  public
    constructor Create;
    property Code: Integer read FCode write FCode;
    property Ctrl: AnsiString read FCtrl write FCtrl;
    property Method: TKMemoRTFCtrlMethod read FMethod write FMethod;
  end;

  { Specifies the RTF control word table. Is only used by RTF reader. Maybe using hash table would be even faster. }
  TKMemoRTFCtrlTable = class(TObjectList)
  private
    function GetItem(Index: Integer): TKMemoRTFCtrl;
    procedure SetItem(Index: Integer; const Value: TKMemoRTFCtrl);
  public
    procedure AddCtrl(const ACtrl: AnsiString; ACode: Integer; AMethod: TKMemoRTFCtrlMethod);
    function FindByCtrl(const ACtrl: AnsiString): TKMemoRtfCtrl; virtual;
    procedure SortTable; virtual;
    property Items[Index: Integer]: TKMemoRTFCtrl read GetItem write SetItem; default;
  end;

  { Specifies the RTF color descriptor. }
  TKMemoRTFColor = class(TObject)
  private
    FColorRec: TKColorRec;
  public
    constructor Create;
    property ColorRec: TKColorRec read FColorRec write FColorRec;
    property Red: Byte read FColorRec.R write FColorRec.R;
    property Green: Byte read FColorRec.G write FColorRec.G;
    property Blue: Byte read FColorRec.B write FColorRec.B;
  end;

  { Specifies the RTF color table. }
  TKMemoRTFColorTable = class(TObjectList)
  private
    function GetItem(Index: Integer): TKMemoRTFColor;
    procedure SetItem(Index: Integer; const Value: TKMemoRTFColor);
  public
    procedure AddColor(AColor: TColor); virtual;
    function GetColor(AIndex: Integer): TColor; virtual;
    function GetIndex(AColor: TColor): Integer; virtual;
    property Items[Index: Integer]: TKMemoRTFColor read GetItem write SetItem; default;
  end;

  { Specifies the RTF font descriptor. }
  TKMemoRTFFont = class(TObject)
  private
    FFont: TFont;
    FFontIndex: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property Font: TFont read FFont;
    property FontIndex: Integer read FFontIndex write FFontIndex;
  end;

  { Specifies the RTF font table. }
  TKMemoRTFFontTable = class(TObjectList)
  private
    function GetItem(Index: Integer): TKMemoRTFFont;
    procedure SetItem(Index: Integer; const Value: TKMemoRTFFont);
  public
    function AddFont(AFont: TFont): Integer; virtual;
    function GetFont(AFontIndex: Integer): TFont; virtual;
    function GetIndex(AFont: TFont): Integer; virtual;
    property Items[Index: Integer]: TKMemoRTFFont read GetItem write SetItem; default;
  end;

  { Specifies the RTF list level descriptor. }
  TKMemoRTFListLevel = class(TObject)
  private
    FFirstIndent: Integer;
    FJustify: Integer;
    FLeftIndent: Integer;
    FNumberType: Integer;
    FStartAt: Integer;
    FNumberingFormat: TKMemoNumberingFormat;
    FFontIndex: Integer;
    function GetNumberTypeAsNumbering: TKMemoParaNumbering;
    procedure SetNumberTypeAsNumbering(const Value: TKMemoParaNumbering);
  public
    constructor Create;
    destructor Destroy; override;
    property FirstIndent: Integer read FFirstIndent write FFirstIndent;
    property FontIndex: Integer read FFontIndex write FFontIndex;
    property Justify: Integer read FJustify write FJustify;
    property LeftIndent: Integer read FLeftIndent write FLeftIndent;
    property NumberingFormat: TKMemoNumberingFormat read FNumberingFormat;
    property NumberType: Integer read FNumberType write FNumberType;
    property NumberTypeAsNumbering: TKMemoParaNumbering read GetNumberTypeAsNumbering write SetNumberTypeAsNumbering;
    property StartAt: Integer read FStartAt write FStartAt;
  end;

  { Specifies the RTF list levels. }
  TKMemoRTFListLevels = class(TObjectList)
  private
    function GetItem(Index: Integer): TKMemoRTFListLevel;
    procedure SetItem(Index: Integer; const Value: TKMemoRTFListLevel);
  public
    property Items[Index: Integer]: TKMemoRTFListLevel read GetItem write SetItem; default;
  end;

  TKMemoRTFListTable = class;

  { Specifies the RTF list descriptor. }
  TKMemoRTFList = class(TObject)
  private
    FID: Integer;
    FLevels: TKMemoRTFListLevels;
  public
    constructor Create(AParent: TKMemoRTFListTable);
    destructor Destroy; override;
    property ID: Integer read FID write FID;
    property Levels: TKMemoRTFListLevels read FLevels;
  end;

  { Specifies the RTF list table. }
  TKMemoRTFListTable = class(TObjectList)
  private
    FOverrides: TKMemoDictionary;
    function GetItem(Index: Integer): TKMemoRTFList;
    procedure SetItem(Index: Integer; const Value: TKMemoRTFList);
  protected
    FIDCounter: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AssignFromListTable(AListTable: TKMemoListTable; AFontTable: TKMemoRTFFontTable);
    procedure AssignToListTable(AListTable: TKMemoListTable; AFontTable: TKMemoRTFFontTable);
    function FindByID(AListID: Integer): Integer;
    function FindByIndex(AIndex: Integer): Integer;
    function IDByIndex(AIndex: Integer): Integer;
    function NextID: Integer;
    property Items[Index: Integer]: TKMemoRTFList read GetItem write SetItem; default;
    property Overrides: TKMemoDictionary read FOverrides;
  end;

  { Specifies the supported RTF shape object type. }
  TKMemoRTFShapeContentType = (sctUnknown, sctTextBox, sctImage, sctRectangle, sctText);

  { Specifies the RTF shape object since KMemo has no generic drawing object support. }
  TKMemoRTFShape = class(TObject)
  private
    FBackground: Boolean;
    FContentPosition: TKRect;
    FContentType: TKMemoRTFShapeContentType;
    FCtrlName: AnsiString;
    FCtrlValue: AnsiString;
    FFitToShape: Boolean;
    FFitToText: Boolean;
    FHorzPosCode: Integer;
    FItem: TKMemoBlock;
    FStyle: TKMemoBlockStyle;
    FVertPosCode: Integer;
    FWrap: Integer;
    FWrapSide: Integer;
    FFillBlip: Boolean;
    procedure SetWrap(const Value: Integer);
    procedure SetWrapSide(const Value: Integer);
    function GetWrap: Integer;
    function GetWrapSide: Integer;
  protected
    procedure RTFWrapToWrapMode; virtual;
    procedure WrapModeToRTFWrap; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    property Background: Boolean read FBackground write FBackground;
    property ContentPosition: TKRect read FContentPosition;
    property ContentType: TKMemoRTFShapeContentType read FContentType write FContentType;
    property CtrlName: AnsiString read FCtrlName write FCtrlName;
    property CtrlValue: AnsiString read FCtrlValue write FCtrlValue;
    property FillBlip: Boolean read FFillBlip write FFillBlip;
    property FitToShape: Boolean read FFitToShape write FFitToShape;
    property FitToText: Boolean read FFitToText write FFitToText;
    property HorzPosCode: Integer read FHorzPosCode write FHorzPosCode;
    property Item: TKMemoBlock read FItem write FItem;
    property Style: TKMemoBlockStyle read FStyle;
    property VertPosCode: Integer read FVertPosCode write FVertPosCode;
    property Wrap: Integer read GetWrap write SetWrap;
    property WrapSide: Integer read GetWrapSide write SetWrapSide;
  end;

  TKMemoRTFGroup = (rgNone, rgUnknown, rgColorTable, rgField, rgFieldInst, rgFieldResult, rgFontTable, rgFooter, rgHeader, rgInfo,
    rgListTable, rgList, rgListLevel, rgListLevelText, rgListOverrideTable, rgListOverride, rgPageBackground, rgPicture, rgPicProp,
    rgShape, rgShapeInst, rgShapePict, rgStyleSheet, rgTextBox);

  { Specifies the RTF reader state. This class is used by RTF reader to store reader state on the stack. }
  TKMemoRTFState = class(TObject)
  private
    FTextStyle: TKMemoTextStyle;
    FParaStyle: TKMemoParaStyle;
    FGroup: TKMemoRTFGroup;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(ASource: TKmemoRTFState); virtual;
    property Group: TKMemoRTFGroup read FGroup write FGroup;
    property ParaStyle: TKMemoParaStyle read FParaStyle write FParaStyle;
    property TextStyle: TKMemoTextStyle read FTextStyle write FTextStyle;
  end;

  { Specifies the stack for the RTF reader state. }
  TKMemoRTFStack = class(TStack)
  public
    function Push(AObject: TKMemoRTFState): TKMemoRTFState;
    function Pop: TKMemoRTFState;
    function Peek: TKMemoRTFState;
  end;

  TKMemoRTFHeaderProp = (rphRtf, rphCodePage, rphDefaultFont, rphIgnoreCharsAfterUnicode, rphFontTable, rphColorTable, rphStyleSheet);
  TKMemoRTFDocumentProp = (rpdFooter, rpdFooterLeft, rpdFooterRight, rpdHeader, rpdHeaderLeft, rpdHeaderRight, rpdInfo);
  TKMemoRTFColorProp = (rpcRed, rpcGreen, rpcBlue);
  TKMemoRTFFieldProp = (rpfiField, rpfiResult);
  TKMemoRTFFontProp = (rpfIndex, rpfCharset, rpfPitch);
  TKMemoRTFImageProp = (rpiPict, rpiJPeg, rpiPng, rpiEmf, rpiWmf, rpiWidth, rpiHeight, rpiCropBottom, rpiCropLeft, rpiCropRight, rpiCropTop,
    rpiReqWidth, rpiReqHeight, rpiScaleX, rpiScaleY);
  TKMemoRTFListProp = (rplList, rplListOverride, rplListLevel, rplListId, rplListIndex, rplListText, rplLevelStartAt, rplLevelNumberType, rplLevelJustify, rplLevelText,
    rplLevelFontIndex, rplLevelFirstIndent, rplLevelLeftIndent);
  TKMemoRTFParaProp = (rppParD, rppIndentFirst, rppIndentBottom, rppIndentLeft, rppIndentRight, rppIndentTop, rppAlignLeft, rppAlignCenter, rppAlignRight, rppAlignJustify,
    rppBackColor, rppNoWordWrap, rppBorderBottom, rppBorderLeft, rppBorderRight, rppBorderTop, rppBorderAll, rppBorderWidth, rppBorderNone, rppBorderRadius, rppBorderColor,
    rppLineSpacing, rppLineSpacingMode, rppPar, rppListIndex, rppListLevel, rppListStartAt);
  TKMemoRTFShapeProp = (rpsShape, rpsBottom, rpsLeft, rpsRight, rpsTop, rpsXColumn, rpsYPara, rpsWrap, rpsWrapSide, rpsSn, rpsSv, rpsShapeText);
  TKMemoRTFSpecialCharProp = (rpscTab, rpscLquote, rpscRQuote, rpscLDblQuote, rpscRDblQuote, rpscEnDash, rpscEmDash, rpscBullet, rpscNBSP, rpscEmSpace, rpscEnSpace,
    rpscAnsiChar, rpscUnicodeChar);
  TKMemoRTFTableProp = (rptbRowBegin, rptbCellEnd, rptbRowEnd, rptbLastRow, rptbRowPaddBottom, rptbRowPaddLeft, rptbRowPaddRight, rptbRowPaddTop, rptbBorderBottom, rptbBorderLeft,
    rptbPaddAll, rptbBorderRight, rptbBorderTop, rptbBorderWidth, rptbBorderNone, rptbBorderColor, rptbBackColor, rptbHorzMergeBegin, rptbHorzMerge,
    rptbVertMergeBegin, rptbVertMerge, rptbCellPaddBottom, rptbCellPaddLeft, rptbCellPaddRight, rptbCellPaddTop, rptbCellWidth, rptbCellX);
  TKMemoRTFTextProp = (rptPlain, rptFontIndex, rptBold, rptItalic, rptUnderline, rptStrikeout, rptCaps, rptSmallCaps, rptFontSize, rptForeColor, rptBackColor,
    rptSubscript, rptSuperscript);
  TKMemoRTFUnknownProp = (rpuUnknownSym, rpuPageBackground, rpuPicProp, rpuShapeInst, rpuShapePict, rpuNonShapePict, rpuFieldInst, rpuListTable, rpuListOverrideTable);

  { Specifies the RTF reader. }
  TKMemoRTFReader = class(TObject)
  private
    function GetActiveFont: TKMemoRTFFont;
    function GetActiveColor: TKMemoRTFColor;
    function GetActiveImage: TKMemoImageBlock;
    function GetActiveShape: TKMemoRTFShape;
    function GetActiveContainer: TKMemoContainer;
    function GetActiveTable: TKMemoTable;
    function GetActiveList: TKMemoRTFList;
    function GetActiveListLevel: TKMemoRTFListLevel;
    function GetActiveListOverride: TKMemoDictionaryItem;
  protected
    FActiveBlocks: TKMemoBlocks;
    FActiveColor: TKMemoRTFColor;
    FActiveContainer: TKMemoContainer;
    FActiveFont: TKMemoRTFFont;
    FActiveImage: TKMemoImageBlock;
    FActiveImageClass: TGraphicClass;
    FActiveImageIsEMF: Boolean;
    FActiveList: TKMemoRTFList;
    FActiveListLevel: TKMemoRTFListLevel;
    FActiveListOverride: TKMemoDictionaryItem;
    FActiveParaBorder: TAlign;
    FActiveShape: TKMemoRTFShape;
    FActiveString: TKString;
    FActiveState: TKMemoRTFState;
    FActiveTable: TKMemoTable;
    FActiveTableBorder: TAlign;
    FActiveTableCell: TKMemoTableCell;
    FActiveTableCellXPos: Integer;
    FActiveTableCol: Integer;
    FActiveTableColCount: Integer;
    FActiveTableLastRow: Boolean;
    FActiveTableRow: TKMemoTableRow;
    FActiveTableRowPadd: TRect;
    FActiveText: TKMemoTextBlock;
    FActiveURL: TKString;
    FAtIndex: Integer;
    FColorTable: TKMemoRTFColorTable;
    FCtrlTable: TKMemoRTFCtrlTable;
    FDefaultCodePage: Integer;
    FDefaultFontIndex: Integer;
    FFontTable: TKMemoRTFFontTable;
    FIgnoreChars: Integer;
    FIgnoreCharsAfterUnicode: Integer;
    FIndexStack: TKMemoSparseStack;
    FGraphicClass: TGraphicClass;
    FListTable: TKMemoRTFListTable;
    FMemo: TKCustomMemo;
    FStack: TKMemoRTFStack;
    FStream: TStream;
    FTmpTextStyle: TKMemoTextStyle;
    procedure AddText(const APart: TKString); virtual;
    procedure AddTextToNumberingFormat(const APart: TKString); virtual;
    procedure ApplyFont(ATextStyle: TKMemoTextStyle; AFontIndex: Integer); virtual;
    procedure ApplyHighlight(ATextStyle: TKMemoTextStyle; AHighlightCode: Integer); virtual;
    procedure FillCtrlTable; virtual;
    function ParamToBool(const AValue: AnsiString): Boolean; virtual;
    function ParamToColor(const AValue: AnsiString): TColor; virtual;
    function ParamToInt(const AValue: AnsiString): Integer; virtual;
    function ParamToEMU(const AValue: AnsiString): Integer; virtual;
    function EMUToPoints(AValue: Integer): Integer;
    procedure FlushColor; virtual;
    procedure FlushContainer; virtual;
    procedure FlushFont; virtual;
    procedure FlushHyperlink; virtual;
    procedure FlushImage; virtual;
    procedure FlushList; virtual;
    procedure FlushListLevel; virtual;
    procedure FlushListOverride; virtual;
    procedure FlushParagraph; virtual;
    procedure FlushShape; virtual;
    procedure FlushTable; virtual;
    procedure FlushText; virtual;
    function HighlightCodeToColor(AValue: Integer): TColor; virtual;
    procedure PopFromStack(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure PushToStack(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    function ReadNext(out ACtrl, AText: AnsiString; out AParam: Int64): Boolean; virtual;
    procedure ReadColorGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadDocumentGroups(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadFieldGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadFontGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadHeaderGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadListGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadParaFormatting(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadPictureGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadShapeGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadSpecialCharacter(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadStream; virtual;
    procedure ReadTableFormatting(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadTextFormatting(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    procedure ReadUnknownGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer); virtual;
    property ActiveColor: TKMemoRTFColor read GetActiveColor;
    property ActiveContainer: TKMemoContainer read GetActiveContainer;
    property ActiveFont: TKMemoRTFFont read GetActiveFont;
    property ActiveList: TKMemoRTFList read GetActiveList;
    property ActiveListLevel: TKMemoRTFListLevel read GetActiveListLevel;
    property ActiveListOverride: TKMemoDictionaryItem read GetActiveListOverride;
    property ActiveImage: TKMemoImageBlock read GetActiveImage;
    property ActiveShape: TKMemoRTFShape read GetActiveShape;
    property ActiveTable: TKMemoTable read GetActiveTable;
  public
    constructor Create(AMemo: TKCustomMemo); virtual;
    destructor Destroy; override;
    procedure LoadFromFile(const AFileName: TKString; AtIndex: Integer = -1); virtual;
    procedure LoadFromStream(AStream: TStream; AtIndex: Integer = -1); virtual;
  end;

  { Specifies the RTF writer. }
  TKMemoRTFWriter = class(TObject)
  protected
    FCodePage: Integer;
    FColorTable: TKMemoRTFColorTable;
    FFontTable: TKMemoRTFFontTable;
    FListTable: TKMemoRTFListTable;
    FMemo: TKCustomMemo;
    FSelectedOnly: Boolean;
    FStream: TStream;
    function BoolToParam(AValue: Boolean): AnsiString; virtual;
    function CanSave(AItem: TKMemoBlock): Boolean; virtual;
    function ColorToHighlightCode(AValue: TColor): Integer; virtual;
    function ColorToParam(AValue: TColor): AnsiString; virtual;
    function EMUToParam(AValue: Integer): AnsiString; virtual;
    procedure FillColorTable(ABlocks: TKMemoBlocks); virtual;
    procedure FillFontTable(ABlocks: TKMemoBlocks); virtual;
    function PointsToEMU(AValue: Integer): Integer; virtual;
    procedure WriteBackground; virtual;
    procedure WriteBody(ABlocks: TKMemoBlocks; AInsideTable: Boolean); virtual;
    procedure WriteColorTable; virtual;
    procedure WriteContainer(ABlock: TKMemoContainer; AInsideTable: Boolean); virtual;
    procedure WriteCtrl(const ACtrl: AnsiString);
    procedure WriteCtrlParam(const ACtrl: AnsiString; AParam: Integer);
    procedure WriteFontTable; virtual;
    procedure WriteGroupBegin;
    procedure WriteGroupEnd;
    procedure WriteHeader; virtual;
    procedure WriteHyperlinkBegin(AItem: TKMemoHyperlink); virtual;
    procedure WriteHyperlinkEnd; virtual;
    procedure WriteImage(AItem: TKmemoImageBlock); virtual;
    procedure WriteImageBlock(AItem: TKmemoImageBlock; AInsideTable: Boolean); virtual;
    procedure WriteListTable; virtual;
    procedure WriteListText(ANumberBlock: TKMemoTextBlock); virtual;
    procedure WriteParagraph(AItem: TKMemoParagraph; AInsideTable: Boolean); virtual;
    procedure WriteParaStyle(AParaStyle: TKMemoParaStyle); virtual;
    procedure WritePicture(AImage: TGraphic); virtual;
    procedure WriteSemiColon;
    procedure WriteShape(AShape: TKMemoRTFShape; AInsideTable: Boolean); virtual;
    procedure WriteShapeProp(const APropName, APropValue: AnsiString); virtual;
    procedure WriteShapeProperties(AShape: TKMemoRTFShape); virtual;
    procedure WriteShapePropName(const APropName: AnsiString);
    procedure WriteShapePropValue(const APropValue: AnsiString);
    procedure WriteSpace;
    procedure WriteString(const AText: AnsiString);
    procedure WriteTable(AItem: TKMemoTable); virtual;
    procedure WriteTableRowProperties(ATable: TKMemoTable; ARowIndex, ASavedRowIndex: Integer); virtual;
    procedure WriteTextBlock(AItem: TKMemoTextBlock; ASelectedOnly: Boolean); virtual;
    procedure WriteTextStyle(ATextStyle: TKMemoTextStyle); virtual;
    procedure WriteUnicodeString(const AText: TKString); virtual;
    procedure WriteUnknownGroup;
  public
    constructor Create(AMemo: TKCustomMemo); virtual;
    destructor Destroy; override;
    procedure SaveToFile(const AFileName: TKString; ASelectedOnly: Boolean); virtual;
    procedure SaveToStream(AStream: TStream; ASelectedOnly: Boolean); virtual;
  end;

function CharSetToCP(ACharSet: TFontCharSet): Integer;
function CPToCharSet(ACodePage: Integer): TFontCharSet;
function TwipsToPoints(AValue: Integer): Integer;
function PointsToTwips(AValue: Integer): Integer;

implementation

uses
  Math, SysUtils, KHexEditor, KRes
{$IFDEF FPC}
  , LCLProc, LConvEncoding, LCLType
{$ELSE}
  , JPeg, Windows
{$ENDIF}
  ;

const
  cRTFHyperlink = 'HYPERLINK';

function CharSetToCP(ACharSet: TFontCharSet): Integer;
begin
  case ACharset of
    1: Result := 0; //Default
    2: Result := 42; //Symbol
    77: Result := 10000; //Mac Roman
    78: Result := 10001; //Mac Shift Jis
    79: Result := 10003; //Mac Hangul
    80: Result := 10008; //Mac GB2312
    81: Result := 10002; //Mac Big5
    83: Result := 10005; //Mac Hebrew
    84: Result := 10004; //Mac Arabic
    85: Result := 10006; //Mac Greek
    86: Result := 10081; //Mac Turkish
    87: Result := 10021; //Mac Thai
    88: Result := 10029; //Mac East Europe
    89: Result := 10007; //Mac Russian
    128: Result := 932; //Shift JIS
    129: Result := 949; //Hangul
    130: Result := 1361; //Johab
    134: Result := 936; //GB2312
    136: Result := 950; //Big5
    161: Result := 1253; //Greek
    162: Result := 1254; //Turkish
    163: Result := 1258; //Vietnamese
    177: Result := 1255; //Hebrew
    178: Result := 1256; //Arabic
    186: Result := 1257; //Baltic
    204: Result := 1251; //Russian
    222: Result := 874; //Thai
    238: Result := 1250; //Eastern European
    254: Result := 437; //PC 437
    255: Result := 850; //OEM
  else
    Result := SystemCodePage; //system default
  end;
end;

function CPToCharSet(ACodePage: Integer): TFontCharSet;
begin
  case ACodePage of
    0: Result := 1; //Default
    42: Result := 2; //Symbol
    10000: Result := 77; //Mac Roman
    10001: Result := 78; //Mac Shift Jis
    10003: Result := 79; //Mac Hangul
    10008: Result := 80; //Mac GB2312
    10002: Result := 81; //Mac Big5
    10005: Result := 83; //Mac Hebrew
    10004: Result := 84; //Mac Arabic
    10006: Result := 85; //Mac Greek
    10081: Result := 86; //Mac Turkish
    10021: Result := 87; //Mac Thai
    10029: Result := 88; //Mac East Europe
    10007: Result := 89; //Mac Russian
    932: Result := 128; //Shift JIS
    949: Result := 129; //Hangul
    1361: Result := 130; //Johab
    936: Result := 134; //GB2312
    950: Result := 136; //Big5
    1253: Result := 161; //Greek
    1254: Result := 162; //Turkish
    1258: Result := 163; //Vietnamese
    1255: Result := 177; //Hebrew
    1256: Result := 178; //Arabic
    1257: Result := 186; //Baltic
    1251: Result := 204; //Russian
    874: Result := 222; //Thai
    1250: Result := 238; //Eastern European
    437: Result := 254; //PC 437
    850: Result := 255; //OEM
  else
    Result := 0; //ANSI
  end;
end;

function AdobeSymbolToUTF16(AValue: Integer): Integer;
begin
  case AValue of
    $20: Result := $0020;  //SPACE //space
    {/$20: Result := $00A0;  //NO-BREAK SPACE	//space }
    $21: Result := $0021;  //EXCLAMATION MARK //exclam
    $22: Result := $2200;  //FOR ALL //universal
    $23: Result := $0023;  //NUMBER SIGN //numbersign
    $24: Result := $2203;  //THERE EXISTS //existential
    $25: Result := $0025;  //PERCENT SIGN //percent
    $26: Result := $0026;  //AMPERSAND //ampersand
    $27: Result := $220B;  //CONTAINS AS MEMBER //suchthat
    $28: Result := $0028;  //LEFT PARENTHESIS //parenleft
    $29: Result := $0029;  //RIGHT PARENTHESIS //parenright
    $2A: Result := $2217;  //ASTERISK OPERATOR //asteriskmath
    $2B: Result := $002B;  //PLUS SIGN //plus
    $2C: Result := $002C; //COMMA //comma
    $2D: Result := $2212; //MINUS SIGN //minus
    $2E: Result := $002E; //FULL STOP //period
    $2F: Result := $002F; //SOLIDUS //slash
    $30: Result := $0030; //DIGIT ZERO //zero
    $31: Result := $0031; //DIGIT ONE //one
    $32: Result := $0032; //DIGIT TWO //two
    $33: Result := $0033; //DIGIT THREE //three
    $34: Result := $0034; //DIGIT FOUR //four
    $35: Result := $0035; //DIGIT FIVE //five
    $36: Result := $0036; //DIGIT SIX //six
    $37: Result := $0037; //DIGIT SEVEN //seven
    $38: Result := $0038; //DIGIT EIGHT //eight
    $39: Result := $0039; //DIGIT NINE //nine
    $3A: Result := $003A; //COLON //colon
    $3B: Result := $003B; //SEMICOLON //semicolon
    $3C: Result := $003C; //LESS-THAN SIGN //less
    $3D: Result := $003D; //EQUALS SIGN //equal
    $3E: Result := $003E; //GREATER-THAN SIGN //greater
    $3F: Result := $003F; //QUESTION MARK //question
    $40: Result := $2245; //APPROXIMATELY EQUAL TO //congruent
    $41: Result := $0391; //GREEK CAPITAL LETTER ALPHA //Alpha
    $42: Result := $0392; //GREEK CAPITAL LETTER BETA //Beta
    $43: Result := $03A7; //GREEK CAPITAL LETTER CHI //Chi
    $44: Result := $0394; //GREEK CAPITAL LETTER DELTA //Delta
    {/$44: Result := $2206; //INCREMENT //Delta}
    $45: Result := $0395; //GREEK CAPITAL LETTER EPSILON //Epsilon
    $46: Result := $03A6; //GREEK CAPITAL LETTER PHI //Phi
    $47: Result := $0393; //GREEK CAPITAL LETTER GAMMA //Gamma
    $48: Result := $0397; //GREEK CAPITAL LETTER ETA //Eta
    $49: Result := $0399; //GREEK CAPITAL LETTER IOTA //Iota
    $4A: Result := $03D1; //GREEK THETA SYMBOL //theta1
    $4B: Result := $039A; //GREEK CAPITAL LETTER KAPPA //Kappa
    $4C: Result := $039B; //GREEK CAPITAL LETTER LAMDA //Lambda
    $4D: Result := $039C; //GREEK CAPITAL LETTER MU //Mu
    $4E: Result := $039D; //GREEK CAPITAL LETTER NU //Nu
    $4F: Result := $039F; //GREEK CAPITAL LETTER OMICRON //Omicron
    $50: Result := $03A0; //GREEK CAPITAL LETTER PI //Pi
    $51: Result := $0398; //GREEK CAPITAL LETTER THETA //Theta
    $52: Result := $03A1; //GREEK CAPITAL LETTER RHO //Rho
    $53: Result := $03A3; //GREEK CAPITAL LETTER SIGMA //Sigma
    $54: Result := $03A4; //GREEK CAPITAL LETTER TAU //Tau
    $55: Result := $03A5; //GREEK CAPITAL LETTER UPSILON //Upsilon
    $56: Result := $03C2; //GREEK SMALL LETTER FINAL SIGMA //sigma1
    $57: Result := $03A9; //GREEK CAPITAL LETTER OMEGA //Omega
    {/$57: Result := $2126; //OHM SIGN //Omega}
    $58: Result := $039E; //GREEK CAPITAL LETTER XI //Xi
    $59: Result := $03A8; //GREEK CAPITAL LETTER PSI //Psi
    $5A: Result := $0396; //GREEK CAPITAL LETTER ZETA //Zeta
    $5B: Result := $005B; //LEFT SQUARE BRACKET //bracketleft
    $5C: Result := $2234; //THEREFORE //therefore
    $5D: Result := $005D; //RIGHT SQUARE BRACKET //bracketright
    $5E: Result := $22A5; //UP TACK //perpendicular
    $5F: Result := $005F; //LOW LINE //underscore
    $60: Result := $F8E5; //RADICAL EXTENDER //radicalex (CUS)
    $61: Result := $03B1; //GREEK SMALL LETTER ALPHA //alpha
    $62: Result := $03B2; //GREEK SMALL LETTER BETA //beta
    $63: Result := $03C7; //GREEK SMALL LETTER CHI //chi
    $64: Result := $03B4; //GREEK SMALL LETTER DELTA //delta
    $65: Result := $03B5; //GREEK SMALL LETTER EPSILON //epsilon
    $66: Result := $03C6; //GREEK SMALL LETTER PHI //phi
    $67: Result := $03B3; //GREEK SMALL LETTER GAMMA //gamma
    $68: Result := $03B7; //GREEK SMALL LETTER ETA //eta
    $69: Result := $03B9; //GREEK SMALL LETTER IOTA //iota
    $6A: Result := $03D5; //GREEK PHI SYMBOL //phi1
    $6B: Result := $03BA; //GREEK SMALL LETTER KAPPA //kappa
    $6C: Result := $03BB; //GREEK SMALL LETTER LAMDA //lambda
    $6D: Result := $00B5; //MICRO SIGN //mu
    {/$6D: Result := $03BC; //GREEK SMALL LETTER MU //mu}
    $6E: Result := $03BD; //GREEK SMALL LETTER NU //nu
    $6F: Result := $03BF; //GREEK SMALL LETTER OMICRON //omicron
    $70: Result := $03C0; //GREEK SMALL LETTER PI //pi
    $71: Result := $03B8; //GREEK SMALL LETTER THETA //theta
    $72: Result := $03C1; //GREEK SMALL LETTER RHO //rho
    $73: Result := $03C3; //GREEK SMALL LETTER SIGMA //sigma
    $74: Result := $03C4; //GREEK SMALL LETTER TAU //tau
    $75: Result := $03C5; //GREEK SMALL LETTER UPSILON //upsilon
    $76: Result := $03D6; //GREEK PI SYMBOL //omega1
    $77: Result := $03C9; //GREEK SMALL LETTER OMEGA //omega
    $78: Result := $03BE; //GREEK SMALL LETTER XI //xi
    $79: Result := $03C8; //GREEK SMALL LETTER PSI //psi
    $7A: Result := $03B6; //GREEK SMALL LETTER ZETA //zeta
    $7B: Result := $007B; //LEFT CURLY BRACKET //braceleft
    $7C: Result := $007C; //VERTICAL LINE //bar
    $7D: Result := $007D; //RIGHT CURLY BRACKET //braceright
    $7E: Result := $007E; //TILDE OPERATOR //similar
    $A0: Result := $20AC; //EURO SIGN //Euro
    $A1: Result := $03D2; //GREEK UPSILON WITH HOOK SYMBOL //Upsilon1
    $A2: Result := $2032; //PRIME //minute
    $A3: Result := $2264; //LESS-THAN OR EQUAL TO //lessequal
    $A4: Result := $2044; //FRACTION SLASH //fraction
    {/$A4: Result := $2215; //DIVISION SLASH //fraction}
    $A5: Result := $221E; //INFINITY //infinity
    $A6: Result := $0192; //LATIN SMALL LETTER F WITH HOOK //florin
    $A7: Result := $2663; //BLACK CLUB SUIT //club
    $A8: Result := $2666; //BLACK DIAMOND SUIT //diamond
    $A9: Result := $2665; //BLACK HEART SUIT //heart
    $AA: Result := $2660; //BLACK SPADE SUIT //spade
    $AB: Result := $2194; //LEFT RIGHT ARROW //arrowboth
    $AC: Result := $2190; //LEFTWARDS ARROW //arrowleft
    $AD: Result := $2191; //UPWARDS ARROW //arrowup
    $AE: Result := $2192; //RIGHTWARDS ARROW //arrowright
    $AF: Result := $2193; //DOWNWARDS ARROW //arrowdown
    $B0: Result := $00B0; //DEGREE SIGN //degree
    $B1: Result := $00B1; //PLUS-MINUS SIGN //plusminus
    $B2: Result := $2033; //DOUBLE PRIME //second
    $B3: Result := $2265; //GREATER-THAN OR EQUAL TO //greaterequal
    $B4: Result := $00D7; //MULTIPLICATION SIGN //multiply
    $B5: Result := $221D; //PROPORTIONAL TO //proportional
    $B6: Result := $2202; //PARTIAL DIFFERENTIAL //partialdiff
    $B7: Result := $2022; //BULLET //bullet
    $B8: Result := $00F7; //DIVISION SIGN //divide
    $B9: Result := $2260; //NOT EQUAL TO //notequal
    $BA: Result := $2261; //IDENTICAL TO //equivalence
    $BB: Result := $2248; //ALMOST EQUAL TO //approxequal
    $BC: Result := $2026; //HORIZONTAL ELLIPSIS //ellipsis
    $BD: Result := $F8E6; //VERTICAL ARROW EXTENDER //arrowvertex (CUS)
    $BE: Result := $F8E7; //HORIZONTAL ARROW EXTENDER //arrowhorizex (CUS)
    $BF: Result := $21B5; //DOWNWARDS ARROW WITH CORNER LEFTWARDS //carriagereturn
    $C0: Result := $2135; //ALEF SYMBOL //aleph
    $C1: Result := $2111; //BLACK-LETTER CAPITAL I //Ifraktur
    $C2: Result := $211C; //BLACK-LETTER CAPITAL R //Rfraktur
    $C3: Result := $2118; //SCRIPT CAPITAL P //weierstrass
    $C4: Result := $2297; //CIRCLED TIMES //circlemultiply
    $C5: Result := $2295; //CIRCLED PLUS //circleplus
    $C6: Result := $2205; //EMPTY SET //emptyset
    $C7: Result := $2229; //INTERSECTION //intersection
    $C8: Result := $222A; //UNION //union
    $C9: Result := $2283; //SUPERSET OF //propersuperset
    $CA: Result := $2287; //SUPERSET OF OR EQUAL TO //reflexsuperset
    $CB: Result := $2284; //NOT A SUBSET OF //notsubset
    $CC: Result := $2282; //SUBSET OF //propersubset
    $CD: Result := $2286; //SUBSET OF OR EQUAL TO //reflexsubset
    $CE: Result := $2208; //ELEMENT OF //element
    $CF: Result := $2209; //NOT AN ELEMENT OF //notelement
    $D0: Result := $2220; //ANGLE //angle
    $D1: Result := $2207; //NABLA //gradient
    $D2: Result := $F6DA; //REGISTERED SIGN SERIF //registerserif (CUS)
    $D3: Result := $F6D9; //COPYRIGHT SIGN SERIF //copyrightserif (CUS)
    $D4: Result := $F6DB; //TRADE MARK SIGN SERIF //trademarkserif (CUS)
    $D5: Result := $220F; //N-ARY PRODUCT //product
    $D6: Result := $221A; //SQUARE ROOT //radical
    $D7: Result := $22C5; //DOT OPERATOR //dotmath
    $D8: Result := $00AC; //NOT SIGN //logicalnot
    $D9: Result := $2227; //LOGICAL AND //logicaland
    $DA: Result := $2228; //LOGICAL OR //logicalor
    $DB: Result := $21D4; //LEFT RIGHT DOUBLE ARROW //arrowdblboth
    $DC: Result := $21D0; //LEFTWARDS DOUBLE ARROW //arrowdblleft
    $DD: Result := $21D1; //UPWARDS DOUBLE ARROW //arrowdblup
    $DE: Result := $21D2; //RIGHTWARDS DOUBLE ARROW //arrowdblright
    $DF: Result := $21D3; //DOWNWARDS DOUBLE ARROW //arrowdbldown
    $E0: Result := $25CA; //LOZENGE //lozenge
    $E1: Result := $2329; //LEFT-POINTING ANGLE BRACKET //angleleft
    $E2: Result := $F8E8; //REGISTERED SIGN SANS SERIF //registersans (CUS)
    $E3: Result := $F8E9; //COPYRIGHT SIGN SANS SERIF //copyrightsans (CUS)
    $E4: Result := $F8EA; //TRADE MARK SIGN SANS SERIF //trademarksans (CUS)
    $E5: Result := $2211; //N-ARY SUMMATION //summation
    $E6: Result := $F8EB; //LEFT PAREN TOP //parenlefttp (CUS)
    $E7: Result := $F8EC; //LEFT PAREN EXTENDER //parenleftex (CUS)
    $E8: Result := $F8ED; //LEFT PAREN BOTTOM //parenleftbt (CUS)
    $E9: Result := $F8EE; //LEFT SQUARE BRACKET TOP //bracketlefttp (CUS)
    $EA: Result := $F8EF; //LEFT SQUARE BRACKET EXTENDER //bracketleftex (CUS)
    $EB: Result := $F8F0; //LEFT SQUARE BRACKET BOTTOM //bracketleftbt (CUS)
    $EC: Result := $F8F1; //LEFT CURLY BRACKET TOP //bracelefttp (CUS)
    $ED: Result := $F8F2; //LEFT CURLY BRACKET MID //braceleftmid (CUS)
    $EE: Result := $F8F3; //LEFT CURLY BRACKET BOTTOM //braceleftbt (CUS)
    $EF: Result := $F8F4; //CURLY BRACKET EXTENDER //braceex (CUS)
    $F1: Result := $232A; //RIGHT-POINTING ANGLE BRACKET //angleright
    $F2: Result := $222B; //INTEGRAL //integral
    $F3: Result := $2320; //TOP HALF INTEGRAL //integraltp
    $F4: Result := $F8F5; //INTEGRAL EXTENDER //integralex (CUS)
    $F5: Result := $2321; //BOTTOM HALF INTEGRAL //integralbt
    $F6: Result := $F8F6; //RIGHT PAREN TOP //parenrighttp (CUS)
    $F7: Result := $F8F7; //RIGHT PAREN EXTENDER //parenrightex (CUS)
    $F8: Result := $F8F8; //RIGHT PAREN BOTTOM //parenrightbt (CUS)
    $F9: Result := $F8F9; //RIGHT SQUARE BRACKET TOP //bracketrighttp (CUS)
    $FA: Result := $F8FA; //RIGHT SQUARE BRACKET EXTENDER //bracketrightex (CUS)
    $FB: Result := $F8FB; //RIGHT SQUARE BRACKET BOTTOM //bracketrightbt (CUS)
    $FC: Result := $F8FC; //RIGHT CURLY BRACKET TOP //bracerighttp (CUS)
    $FD: Result := $F8FD; //RIGHT CURLY BRACKET MID //bracerightmid (CUS)
    $FE: Result := $F8FE; //RIGHT CURLY BRACKET BOTTOM //bracerightbt (CUS)
  else
    Result := AValue;
  end;
end;

function TwipsToPoints(AValue: Integer): Integer;
begin
  Result := DivUp(AValue, 20);
end;

function PointsToTwips(AValue: Integer): Integer;
begin
  Result := AValue * 20;
end;

{ TKMemoRTFCtrlItem }

constructor TKMemoRTFCtrl.Create;
begin
  FCode := 0;
  FCtrl := '';
  FMethod := nil;
end;

{ TKMemoRTFCtrlTable }

function KMemoRTFSearchCompare(Data: Pointer; Index: Integer; KeyPtr: Pointer): Integer;
var
  Tbl: TKMemoRTFCtrlTable;
  TblCtrl, Ctrl: AnsiString;
begin
  Tbl := TKMemoRTFCtrlTable(Data);
  Ctrl := AnsiString(keyPtr);
  TblCtrl := Tbl[Index].Ctrl;
  if Ctrl > TblCtrl then
    Result := 1
  else if Ctrl < TblCtrl then
    Result := -1
  else
    Result := 0;
end;

function KMemoRTFSortCompare(Data: Pointer; Index1, Index2: Integer): Integer;
var
  Tbl: TKMemoRTFCtrlTable;
  TblCtrl1, TblCtrl2: AnsiString;
begin
  Tbl := TKMemoRTFCtrlTable(Data);
  TblCtrl1 := Tbl[Index1].Ctrl;
  TblCtrl2 := Tbl[Index2].Ctrl;
  if TblCtrl1 > TblCtrl2 then
    Result := 1
  else if TblCtrl1 < TblCtrl2 then
    Result := -1
  else
    Result := 0;
end;

procedure KMemoRTFSortExchange(Data: Pointer; Index1, Index2: Integer);
var
  Tbl: TKMemoRTFCtrlTable;
begin
  Tbl := TKMemoRTFCtrlTable(Data);
  Tbl.Exchange(Index1, Index2);
end;

procedure TKMemoRTFCtrlTable.AddCtrl(const ACtrl: AnsiString; ACode: Integer; AMethod: TKMemoRTFCtrlMethod);
var
  Item: TKMemoRTFCtrl;
begin
  Item := TKMemoRTFCtrl.Create;
  Item.Ctrl := ACtrl;
  Item.Code := ACode;
  Item.Method := AMethod;
  inherited Add(Item);
end;

function TKMemoRTFCtrlTable.FindByCtrl(const ACtrl: AnsiString): TKMemoRtfCtrl;
var
  Index: Integer;
begin
  Index := BinarySearch(Self, Count, Pointer(ACtrl), KMemoRTFSearchCompare, True);
  if Index >= 0 then
    Result := Items[Index]
  else
    Result := nil;
end;

function TKMemoRTFCtrlTable.GetItem(Index: Integer): TKMemoRTFCtrl;
begin
  Result := TKMemoRTFCtrl(inherited GetItem(Index));
end;

procedure TKMemoRTFCtrlTable.SetItem(Index: Integer; const Value: TKMemoRTFCtrl);
begin
  inherited SetItem(Index, Value);
end;

procedure TKMemoRTFCtrlTable.SortTable;
begin
  QuickSort(Self, Count, KMemoRTFSortCompare, KMemoRTFSortExchange, True);
end;

{ TKMemoRTFColor }

constructor TKMemoRTFColor.Create;
begin
  FColorRec.Value := 0;
end;

{ TKMemoRTFColorTable }

procedure TKMemoRTFColorTable.AddColor(AColor: TColor);
var
  RTFColor: TKMemoRTFColor;
begin
  if AColor <> clNone then
  begin
    if GetIndex(AColor) < 0 then
    begin
      RTFColor := TKMemoRTFColor.Create;
      RTFColor.ColorRec := ColorToColorRec(AColor);
      Add(RTFColor);
    end;
  end;
end;

function TKMemoRTFColorTable.getColor(AIndex: Integer): TColor;
begin
  if (AIndex >= 0) and (AIndex < Count) then
    Result := ColorRecToColor(Items[AIndex].ColorRec)
  else
    Result := clNone;
end;

function TKMemoRTFColorTable.GetIndex(AColor: TColor): Integer;
var
  I: Integer;
  Color, ColorRec: TKColorRec;
begin
  Color := ColorToColorRec(AColor);
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    ColorRec := Items[I].ColorRec;
    if ColorRec.Value = Color.Value then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TKMemoRTFColorTable.GetItem(Index: Integer): TKMemoRTFColor;
begin
  Result := TKMemoRTFColor(inherited GetItem(Index));
end;

procedure TKMemoRTFColorTable.SetItem(Index: Integer; const Value: TKMemoRTFColor);
begin
  inherited SetItem(Index, Value);
end;

{ TKMemoRTFFont }

constructor TKMemoRTFFont.Create;
begin
  FFont := TFont.Create;
end;

destructor TKMemoRTFFont.Destroy;
begin
  FFont.Free;
  inherited;
end;

{ TKMemoRTFFontTable }

function TKMemoRTFFontTable.AddFont(AFont: TFont): Integer;
var
  RTFFont: TKMemoRTFFont;
begin
  Result := GetIndex(AFont);
  if Result < 0 then
  begin
    RTFFont := TKmemoRTFFont.Create;
    RTFFont.Font.Assign(AFont);
    RTFFont.FontIndex := Count;
    Result := Add(RTFFont);
  end;
end;

function TKMemoRTFFontTable.GetFont(AFontIndex: Integer): TFont;
var
  I: Integer;
  Item: TKMemoRTFFont;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    Item := Items[I];
    if Item.FontIndex = AFontIndex then
    begin
      Result := Item.Font;
      Exit;
    end;
  end;
end;

function TKMemoRTFFontTable.GetIndex(AFont: TFont): Integer;
var
  I: Integer;
  Font: TFont;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    Font := Items[I].Font;
    if (Font.Name = AFont.Name) and (Font.Charset = AFont.Charset) and (Font.Pitch = AFont.Pitch) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TKMemoRTFFontTable.GetItem(Index: Integer): TKMemoRTFFont;
begin
  Result := TKMemoRTFFont(inherited GetItem(Index));
end;

procedure TKMemoRTFFontTable.SetItem(Index: Integer;
  const Value: TKMemoRTFFont);
begin
  inherited SetItem(Index, Value);
end;

{ TKMemoRTFListLevel }

constructor TKMemoRTFListLevel.Create;
begin
  FFirstIndent := 0;
  FFontIndex := -1;
  FNumberingFormat := TKMemoNumberingFormat.Create;
  FJustify := 0;
  FLeftIndent := 0;
  FNumberType := 0;
  FStartAt := 1;
end;

destructor TKMemoRTFListLevel.Destroy;
begin
  FNumberingFormat.Free;
  inherited;
end;

function TKMemoRTFListLevel.GetNumberTypeAsNumbering: TKMemoParaNumbering;
begin
  // we support only basic types of Word numberings...
  case FNumberType of
    1: Result := pnuRomanHi;
    2: Result := pnuRomanLo;
    3: Result := pnuLetterHi;
    4: Result := pnuLetterLo;
    23: Result := pnuBullets;
    255: Result := pnuNone;
  else
    Result := pnuArabic;
  end;
end;

procedure TKMemoRTFListLevel.SetNumberTypeAsNumbering(const Value: TKMemoParaNumbering);
begin
  case Value of
    pnuBullets: FNumberType := 23;
    pnuArabic: FNumberType := 0;
    pnuLetterLo: FNumberType := 4;
    pnuLetterHi: FNumberType := 3;
    pnuRomanLo: FNumberType := 2;
    pnuRomanHi: FNumberType := 1;
  else
    FNumberType := 255; // pnuNone
  end;
end;

{ TKMemoRTFListLevels }

function TKMemoRTFListLevels.GetItem(Index: Integer): TKMemoRTFListLevel;
begin
  Result := TKMemoRTFListLevel(inherited GetItem(Index));
end;

procedure TKMemoRTFListLevels.SetItem(Index: Integer; const Value: TKMemoRTFListLevel);
begin
  inherited SetItem(Index, Value);
end;

{ TKMemoRTFList }

constructor TKMemoRTFList.Create(AParent: TKMemoRTFListTable);
begin
  if AParent <> nil then
    FID := AParent.NextID
  else
    FID := Random(MaxInt);
  FLevels := TKMemoRTFListLevels.Create;
end;

destructor TKMemoRTFList.Destroy;
begin
  FLevels.Free;
  inherited;
end;

{ TKMemoRTFListTable }

constructor TKMemoRTFListTable.Create;
begin
  inherited;
  FIdCounter := 0;
  FOverrides := TKMemoDictionary.Create;
end;

destructor TKMemoRTFListTable.Destroy;
begin
  FOverrides.Free;
  inherited;
end;

procedure TKMemoRTFListTable.AssignFromListTable(AListTable: TKMemoListTable; AFontTable: TKMemoRTFFontTable);
var
  List: TKMemoList;
  ListLevel: TKMemoListLevel;
  RTFList: TKMemoRTFList;
  RTFListLevel: TKMemoRTFListLevel;
  NFItem: TKMemoNumberingFormatItem;
  I, J, K, Len: Integer;
begin
  Clear;
  for I := 0 to AListTable.Count - 1 do
  begin
    List := AListTable.Items[I];
    RTFList := TKMemoRTFList.Create(Self);
    RTFList.ID := List.ID;
    for J := 0 to List.Levels.Count - 1 do
    begin
      ListLevel := List.Levels[J];
      RTFListLevel := TKMemoRTFListLevel.Create;
      RTFListLevel.FirstIndent := ListLevel.FirstIndent;
      RTFListLevel.LeftIndent := ListLevel.LeftIndent;
      if ListLevel.NumberingFontChanged then
        RTFListLevel.FontIndex := AFontTable.AddFont(ListLevel.NumberingFont);
      RTFListLevel.NumberTypeAsNumbering := ListLevel.Numbering;
      RTFListLevel.NumberingFormat.Assign(ListLevel.NumberingFormat);
      // fixup numbering format for RTF save
      // add length field
      Len := 0;
      for K := 0 to RTFListLevel.NumberingFormat.Count - 1 do
      begin
        NFItem := RTFListLevel.NumberingFormat[K];
        if (NFItem.Level >= 0) and (NFItem.Text = '') then
          Inc(Len)
        else
          Inc(Len, StringLength(NFItem.Text));
      end;
      RTFListLevel.NumberingFormat.InsertItem(0, Len, '');
      RTFListLevel.StartAt := ListLevel.NumberStartAt;
      RTFList.Levels.Add(RTFListLevel);
    end;
    Add(RTFList);
    FOverrides.AddItem(I, RTFList.ID);
  end;
end;

procedure TKMemoRTFListTable.AssignToListTable(AListTable: TKMemoListTable; AFontTable: TKMemoRTFFontTable);
var
  List: TKMemoList;
  ListLevel: TKMemoListLevel;
  RTFList: TKMemoRTFList;
  RTFListLevel: TKMemoRTFListLevel;
  NFItem: TKMemoNumberingFormatItem;
  Font: TFont;
  I, J, K, L, UnicodeValue: Integer;
  S: TKString;
begin
  AListTable.LockUpdate;
  try
    for I := 0 to Count - 1 do
    begin
      RTFList := Items[I];
      List := AListTable.FindByID(RTFList.ID);
      if List = nil then
      begin
        List := TKMemoList.Create;
        List.Parent := AListTable;
        List.ID := RTFList.ID;
        AListTable.Add(List);
      end;
      List.Levels.Clear;
      for J := 0 to RTFList.Levels.Count - 1 do
      begin
        RTFListLevel := RTFList.Levels[J];
        ListLevel := TKMemoListLevel.Create;
        ListLevel.Parent := List.Levels;
        ListLevel.FirstIndent := RTFListLevel.FirstIndent;
        ListLevel.LeftIndent := RTFListLevel.LeftIndent;
        ListLevel.Numbering := RTFListLevel.NumberTypeAsNumbering;
        ListLevel.NumberingFormat.Assign(RTFListLevel.NumberingFormat);
        ListLevel.NumberStartAt := RTFListLevel.StartAt;
        if RTFListLevel.FontIndex >= 0 then
        begin
          Font := AFontTable.GetFont(RTFListLevel.FontIndex);
          if Font <> nil then
          begin
            ListLevel.NumberingFont.Assign(Font);
            if ListLevel.NumberingFont.Name = 'Symbol' then
            begin
              ListLevel.NumberingFont.Name := 'Arial';
              ListLevel.NumberingFont.Charset := 0;
              for K := 0 to ListLevel.NumberingFormat.Count - 1 do
              begin
                NFItem := ListLevel.NumberingFormat[K];
                S := '';
                for L := 1 to StringLength(NFItem.Text) do
                begin
                  UnicodeValue := Ord(NativeUTFToUnicode(StringCopy(NFItem.Text, L, 1)));
                  S := S + UnicodeToNativeUTF(WideChar(AdobeSymbolToUTF16(Byte(UnicodeValue))));
                end;
                NFItem.Text := S;
              end;
            end;
          end;
        end;
        List.Levels.Add(ListLevel);
      end;
    end;
  finally
    AListTable.UnLockUpdate;
  end;
end;

function TKMemoRTFListTable.FindByID(AListID: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if Items[I].ID = AListID then
    begin
      Result := I;
      Break;
    end;
end;

function TKMemoRTFListTable.FindByIndex(AIndex: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FOverrides.Count - 1 do
    if FOverrides.Items[I].Index = AIndex then
    begin
      Result := FindByID(FOverrides.Items[I].Value);
      Break;
    end;
end;

function TKMemoRTFListTable.GetItem(Index: Integer): TKMemoRTFList;
begin
  Result := TKMemoRTFList(inherited GetItem(Index));
end;

function TKMemoRTFListTable.IDByIndex(AIndex: Integer): Integer;
var
  I: Integer;
begin
  I := FindByIndex(AIndex);
  if I >= 0 then
    Result := Items[I].ID
  else
    Result := cInvalidListID;
end;

function TKMemoRTFListTable.NextID: Integer;
begin
  Result := FIDCounter;
  Inc(FIDCounter);
end;

procedure TKMemoRTFListTable.SetItem(Index: Integer; const Value: TKMemoRTFList);
begin
  inherited SetItem(Index, Value);
end;

{ TKMemoRTFShape }

constructor TKMemoRTFShape.Create;
begin
  FBackground := False;
  FContentPosition := TKRect.Create;
  FContentType := sctUnknown;
  FFillBlip := False;
  FFitToShape := False;
  FFitToText := True;
  FHorzPosCode := 0;
  FItem := nil;
  FStyle := TKMemoBlockStyle.Create;
  FStyle.Brush.Color := clWhite;
  FStyle.ContentMargin.AssignFromValues(5, 5, 5, 5);
  FVertPosCode := 0;
  FWrap := 0;
  FWrapSide := 0;
end;

destructor TKMemoRTFShape.Destroy;
begin
  FContentPosition.Free;
  FStyle.Free;
  inherited;
end;

function TKMemoRTFShape.GetWrap: Integer;
begin
  WrapModeToRTFWrap;
  Result := FWrap;
end;

function TKMemoRTFShape.GetWrapSide: Integer;
begin
  WrapModeToRTFWrap;
  Result := FWrapSide;
end;

procedure TKMemoRTFShape.SetWrap(const Value: Integer);
begin
  FWrap := Value;
  RTFWrapToWrapMode;
end;

procedure TKMemoRTFShape.SetWrapSide(const Value: Integer);
begin
  FWrapSide := Value;
  RTFWrapToWrapMode;
end;

procedure TKMemoRTFShape.WrapModeToRTFWrap;
begin
  FWrapSide := 0;
  FWrap := 0;
  case FStyle.WrapMode of
    wrAround: FWrap := 2;
    wrAroundLeft: begin FWrap := 2; FWrapSide := 1; end;
    wrAroundRight: begin FWrap := 2; FWrapSide := 2; end;
    wrTight: FWrap := 2; // FWrap should be 4, change when tight wrapping supported
    wrTightLeft: begin FWrap := 2; FWrapSide := 1; end; // FWrap should be 4, change when tight wrapping supported
    wrTightRight: begin FWrap := 2; FWrapSide := 2; end; // FWrap should be 4, change when tight wrapping supported
    wrTopBottom: FWrap := 1;
    wrNone: FWrap := 3;
  end;
end;

procedure TKMemoRTFShape.RTFWrapToWrapMode;
begin
  case FWrap of
    1: FStyle.WrapMode := wrTopBottom;
    2: case FWrapSide of
         1: FStyle.WrapMode := wrAroundLeft;
         2: FStyle.WrapMode := wrAroundRight;
       else
         FStyle.WrapMode := wrAround;
       end;
    3: FStyle.WrapMode := wrNone;
    4: case FWrapSide of
         1: FStyle.WrapMode := wrTightLeft;
         2: FStyle.WrapMode := wrTightRight;
       else
         FStyle.WrapMode := wrTight;
       end;
  else
    FStyle.WrapMode := wrAround;
  end;
end;

{ TKMemoRTFState }

procedure TKMemoRTFState.Assign(ASource: TKmemoRTFState);
begin
  if ASource <> nil then
  begin
    FGroup := ASource.Group;
    FParaStyle.Assign(ASource.ParaStyle);
    FTextStyle.Assign(ASource.TextStyle);
    // don't assign the IsShape and IsPicture properties, they should not be inherited
  end;
end;

constructor TKMemoRTFState.Create;
begin
  FGroup := rgNone;
  FParaStyle := TKMemoParaStyle.Create;
  FTextStyle := TKMemoTextStyle.Create;
end;

destructor TKMemoRTFState.Destroy;
begin
  FParaStyle.Free;
  FTextStyle.Free;
  inherited;
end;

{ TKMemoRTFStack }

function TKMemoRTFStack.Peek: TKMemoRTFState;
begin
  Result := TKMemoRTFState(inherited Peek);
end;

function TKMemoRTFStack.Pop: TKMemoRTFState;
begin
  Result := TKMemoRTFState(inherited Pop);
end;

function TKMemoRTFStack.Push(AObject: TKMemoRTFState): TKMemoRTFState;
begin
  Result := TKMemoRTFState(inherited Push(AObject));
end;

{ TKMemoRTFReader }

constructor TKMemoRTFReader.Create(AMemo: TKCustomMemo);
begin
  FColorTable := TKMemoRTFColorTable.Create;
  FCtrlTable := TKMemoRTFCtrlTable.Create;
  FFontTable := TKMemoRTFFontTable.Create;
  FIndexStack := TKMemoSparseStack.Create;
  FListTable := TKMemoRTFListTable.Create;
  FMemo := AMemo;
  FStack := TKMemoRTFStack.Create;
  FStream := nil;
  FTmpTextStyle := TKMemoTextStyle.Create;
  FillCtrlTable;
  FCtrlTable.SortTable;
end;

destructor TKMemoRTFReader.Destroy;
begin
  FColorTable.Free;
  FCtrlTable.Free;
  FFontTable.Free;
  FIndexStack.Free;
  FListTable.Free;
  FStack.Free;
  FTmpTextStyle.Free;
  inherited;
end;

procedure TKMemoRTFReader.FillCtrlTable;
begin
  // control symbols
  FCtrlTable.AddCtrl('{', 0, PushToStack);
  FCtrlTable.AddCtrl('}', 0, PopFromStack);
  FCtrlTable.AddCtrl('*', Integer(rpuUnknownSym), ReadUnknownGroup);
  FCtrlTable.AddCtrl('shpinst', Integer(rpuShapeInst), ReadUnknownGroup);
  FCtrlTable.AddCtrl('shppict', Integer(rpuShapePict), ReadUnknownGroup);
  FCtrlTable.AddCtrl('nonshppict', Integer(rpuNonShapePict), ReadUnknownGroup);
  FCtrlTable.AddCtrl('background', Integer(rpuPageBackground), ReadUnknownGroup);
  FCtrlTable.AddCtrl('picprop', Integer(rpuPicProp), ReadUnknownGroup);
  FCtrlTable.AddCtrl('fldinst', Integer(rpuFieldInst), ReadUnknownGroup);
  FCtrlTable.AddCtrl('listtable', Integer(rpuListTable), ReadUnknownGroup);
  FCtrlTable.AddCtrl('listoverridetable', Integer(rpuListOverrideTable), ReadUnknownGroup);
  // header ctrls
  FCtrlTable.AddCtrl('rtf', Integer(rphRtf), ReadHeaderGroup);
  FCtrlTable.AddCtrl('ansicpg', Integer(rphCodePage), ReadHeaderGroup);
  FCtrlTable.AddCtrl('deff', Integer(rphDefaultFont), ReadHeaderGroup);
  FCtrlTable.AddCtrl('uc', Integer(rphIgnoreCharsAfterUnicode), ReadHeaderGroup);
  FCtrlTable.AddCtrl('fonttbl', Integer(rphFontTable), ReadHeaderGroup);
  FCtrlTable.AddCtrl('colortbl', Integer(rphColorTable), ReadHeaderGroup);
  FCtrlTable.AddCtrl('stylesheet', Integer(rphStyleSheet), ReadHeaderGroup);
  // document ctrls
  FCtrlTable.AddCtrl('footer', Integer(rpdFooter), ReadDocumentGroups);
  FCtrlTable.AddCtrl('footerl', Integer(rpdFooterLeft), ReadDocumentGroups);
  FCtrlTable.AddCtrl('footerr', Integer(rpdFooterRight), ReadDocumentGroups);
  FCtrlTable.AddCtrl('header', Integer(rpdHeader), ReadDocumentGroups);
  FCtrlTable.AddCtrl('headerl', Integer(rpdHeaderLeft), ReadDocumentGroups);
  FCtrlTable.AddCtrl('headerr', Integer(rpdHeaderRight), ReadDocumentGroups);
  FCtrlTable.AddCtrl('info', Integer(rpdInfo), ReadDocumentGroups);
  // color table ctrls
  FCtrlTable.AddCtrl('red', Integer(rpcRed), ReadColorGroup);
  FCtrlTable.AddCtrl('green', Integer(rpcGreen), ReadColorGroup);
  FCtrlTable.AddCtrl('blue', Integer(rpcBlue), ReadColorGroup);
  // field ctrls
  FCtrlTable.AddCtrl('field', Integer(rpfiField), ReadFieldGroup);
  FCtrlTable.AddCtrl('fldrslt', Integer(rpfiResult), ReadFieldGroup);
  // font table ctrls
  FCtrlTable.AddCtrl('f', Integer(rpfIndex), ReadFontGroup);
  FCtrlTable.AddCtrl('fcharset', Integer(rpfCharset), ReadFontGroup);
  FCtrlTable.AddCtrl('fprq', Integer(rpfPitch), ReadFontGroup);
  // list (override) table ctrls
  FCtrlTable.AddCtrl('list', Integer(rplList), ReadListGroup);
  FCtrlTable.AddCtrl('listoverride', Integer(rplListOverride), ReadListGroup);
  FCtrlTable.AddCtrl('listlevel', Integer(rplListLevel), ReadListGroup);
  FCtrlTable.AddCtrl('listid', Integer(rplListId), ReadListGroup);
  FCtrlTable.AddCtrl('listtext', Integer(rplListText), ReadListGroup);
  FCtrlTable.AddCtrl('levelstartat', Integer(rplLevelStartAt), ReadListGroup);
  FCtrlTable.AddCtrl('levelnfc', Integer(rplLevelNumberType), ReadListGroup);
  FCtrlTable.AddCtrl('leveljc', Integer(rplLevelJustify), ReadListGroup);
  FCtrlTable.AddCtrl('leveltext', Integer(rplLevelText), ReadListGroup);
  // paragraph formatting ctrls
  FCtrlTable.AddCtrl('pard', Integer(rppParD), ReadParaFormatting);
  FCtrlTable.AddCtrl('fi', Integer(rppIndentFirst), ReadParaFormatting);
  FCtrlTable.AddCtrl('li', Integer(rppIndentLeft), ReadParaFormatting);
  FCtrlTable.AddCtrl('ri', Integer(rppIndentRight), ReadParaFormatting);
  FCtrlTable.AddCtrl('sb', Integer(rppIndentTop), ReadParaFormatting);
  FCtrlTable.AddCtrl('sa', Integer(rppIndentBottom), ReadParaFormatting);
  FCtrlTable.AddCtrl('ql', Integer(rppAlignLeft), ReadParaFormatting);
  FCtrlTable.AddCtrl('qc', Integer(rppAlignCenter), ReadParaFormatting);
  FCtrlTable.AddCtrl('qr', Integer(rppAlignRight), ReadParaFormatting);
  FCtrlTable.AddCtrl('qj', Integer(rppAlignJustify), ReadParaFormatting);
  FCtrlTable.AddCtrl('cbpat', Integer(rppBackColor), ReadParaFormatting);
  FCtrlTable.AddCtrl('nowwrap', Integer(rppNoWordWrap), ReadParaFormatting);
  FCtrlTable.AddCtrl('brdrb', Integer(rppBorderBottom), ReadParaFormatting);
  FCtrlTable.AddCtrl('brdrl', Integer(rppBorderLeft), ReadParaFormatting);
  FCtrlTable.AddCtrl('brdrr', Integer(rppBorderRight), ReadParaFormatting);
  FCtrlTable.AddCtrl('brdrt', Integer(rppBorderTop), ReadParaFormatting);
  FCtrlTable.AddCtrl('box', Integer(rppBorderAll), ReadParaFormatting);
  FCtrlTable.AddCtrl('brdrw', Integer(rppBorderWidth), ReadParaFormatting);
  FCtrlTable.AddCtrl('brdrnone', Integer(rppBorderNone), ReadParaFormatting);
  FCtrlTable.AddCtrl('brdrradius', Integer(rppBorderRadius), ReadParaFormatting);
  FCtrlTable.AddCtrl('brdrcf', Integer(rppBorderColor), ReadParaFormatting);
  FCtrlTable.AddCtrl('sl', Integer(rppLineSpacing), ReadParaFormatting);
  FCtrlTable.AddCtrl('slmult', Integer(rppLineSpacingMode), ReadParaFormatting);
  FCtrlTable.AddCtrl('par', Integer(rppPar), ReadParaFormatting);
  FCtrlTable.AddCtrl('ls', Integer(rppListIndex), ReadParaFormatting);
  FCtrlTable.AddCtrl('ilvl', Integer(rppListLevel), ReadParaFormatting);
  FCtrlTable.AddCtrl('lsstartat', Integer(rppListStartAt), ReadParaFormatting);
  // picture group ctrls
  FCtrlTable.AddCtrl('pict', Integer(rpiPict), ReadPictureGroup);
  FCtrlTable.AddCtrl('jpegblip', Integer(rpiJpeg), ReadPictureGroup);
  FCtrlTable.AddCtrl('pngblip', Integer(rpiPng), ReadPictureGroup);
  FCtrlTable.AddCtrl('emfblip', Integer(rpiEmf), ReadPictureGroup);
  FCtrlTable.AddCtrl('wmetafile', Integer(rpiWmf), ReadPictureGroup);
  FCtrlTable.AddCtrl('picw', Integer(rpiWidth), ReadPictureGroup);
  FCtrlTable.AddCtrl('pich', Integer(rpiHeight), ReadPictureGroup);
  FCtrlTable.AddCtrl('piccropb', Integer(rpiCropBottom), ReadPictureGroup);
  FCtrlTable.AddCtrl('piccropl', Integer(rpiCropLeft), ReadPictureGroup);
  FCtrlTable.AddCtrl('piccropr', Integer(rpiCropRight), ReadPictureGroup);
  FCtrlTable.AddCtrl('piccropt', Integer(rpiCropTop), ReadPictureGroup);
  FCtrlTable.AddCtrl('picscalex', Integer(rpiScaleX), ReadPictureGroup);
  FCtrlTable.AddCtrl('picscaley', Integer(rpiScaleY), ReadPictureGroup);
  FCtrlTable.AddCtrl('picwgoal', Integer(rpiReqWidth), ReadPictureGroup);
  FCtrlTable.AddCtrl('pichgoal', Integer(rpiReqHeight), ReadPictureGroup);
  // shape ctrls
  FCtrlTable.AddCtrl('shp', Integer(rpsShape), ReadShapeGroup);
  FCtrlTable.AddCtrl('shpbottom', Integer(rpsBottom), ReadShapeGroup);
  FCtrlTable.AddCtrl('shpleft', Integer(rpsLeft), ReadShapeGroup);
  FCtrlTable.AddCtrl('shpright', Integer(rpsRight), ReadShapeGroup);
  FCtrlTable.AddCtrl('shptop', Integer(rpsTop), ReadShapeGroup);
  FCtrlTable.AddCtrl('shpbxcolumn', Integer(rpsXColumn), ReadShapeGroup);
  FCtrlTable.AddCtrl('shpbypara', Integer(rpsYPara), ReadShapeGroup);
  FCtrlTable.AddCtrl('shpwr', Integer(rpsWrap), ReadShapeGroup);
  FCtrlTable.AddCtrl('shpwrk', Integer(rpsWrapSide), ReadShapeGroup);
  FCtrlTable.AddCtrl('sn', Integer(rpsSn), ReadShapeGroup);
  FCtrlTable.AddCtrl('sv', Integer(rpsSv), ReadShapeGroup);
  FCtrlTable.AddCtrl('shptxt', Integer(rpsShapeText), ReadShapeGroup);
  // special character ctrls
  FCtrlTable.AddCtrl('tab', Integer(rpscTab), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('lquote', Integer(rpscLQuote), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('rquote', Integer(rpscRQuote), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('ldblquote', Integer(rpscLDblQuote), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('rdblquote', Integer(rpscRDblQuote), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('endash', Integer(rpscEnDash), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('emdash', Integer(rpscEmDash), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('bullet', Integer(rpscBullet), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('~', Integer(rpscNBSP), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('emspace', Integer(rpscEmSpace), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('enspace', Integer(rpscEnSpace), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('''', Integer(rpscAnsiChar), ReadSpecialCharacter);
  FCtrlTable.AddCtrl('u', Integer(rpscUnicodeChar), ReadSpecialCharacter);
  // table formatting ctrls
  FCtrlTable.AddCtrl('trowd', Integer(rptbRowBegin), ReadTableFormatting);
  FCtrlTable.AddCtrl('intbl', Integer(rptbRowBegin), ReadTableFormatting);
  FCtrlTable.AddCtrl('cell', Integer(rptbCellEnd), ReadTableFormatting);
  FCtrlTable.AddCtrl('row', Integer(rptbRowEnd), ReadTableFormatting);
  FCtrlTable.AddCtrl('lastrow', Integer(rptbLastRow), ReadTableFormatting);
  FCtrlTable.AddCtrl('trpaddb', Integer(rptbRowPaddBottom), ReadTableFormatting);
  FCtrlTable.AddCtrl('trpaddl', Integer(rptbRowPaddLeft), ReadTableFormatting);
  FCtrlTable.AddCtrl('trpaddr', Integer(rptbRowPaddRight), ReadTableFormatting);
  FCtrlTable.AddCtrl('trpaddt', Integer(rptbRowPaddTop), ReadTableFormatting);
  FCtrlTable.AddCtrl('trgaph', Integer(rptbPaddAll), ReadTableFormatting);
  FCtrlTable.AddCtrl('clbrdrb', Integer(rptbBorderBottom), ReadTableFormatting);
  FCtrlTable.AddCtrl('clbrdrl', Integer(rptbBorderLeft), ReadTableFormatting);
  FCtrlTable.AddCtrl('clbrdrr', Integer(rptbBorderRight), ReadTableFormatting);
  FCtrlTable.AddCtrl('clbrdrt', Integer(rptbBorderTop), ReadTableFormatting);
  FCtrlTable.AddCtrl('clpadb', Integer(rptbCellPaddBottom), ReadTableFormatting);
  FCtrlTable.AddCtrl('clpadl', Integer(rptbCellPaddLeft), ReadTableFormatting);
  FCtrlTable.AddCtrl('clpadr', Integer(rptbCellPaddRight), ReadTableFormatting);
  FCtrlTable.AddCtrl('clpadt', Integer(rptbCellPaddTop), ReadTableFormatting);
//  FCtrlTable.AddCtrl('brdrw', Integer(rptbBorderWidth), ReadTableFormatting); // see ReadParaFormatting
//  FCtrlTable.AddCtrl('brdrnone', Integer(rptbBorderNone), ReadTableFormatting); // see ReadParaFormatting
//  FCtrlTable.AddCtrl('brdrcf', Integer(rptbBorderColor), ReadParaFormatting); // see ReadParaFormatting
  FCtrlTable.AddCtrl('clcbpat', Integer(rptbBackColor), ReadTableFormatting);
  FCtrlTable.AddCtrl('clmgf', Integer(rptbHorzMergeBegin), ReadTableFormatting);
  FCtrlTable.AddCtrl('clhmrg', Integer(rptbHorzMerge), ReadTableFormatting);
  FCtrlTable.AddCtrl('clvmgf', Integer(rptbVertMergeBegin), ReadTableFormatting);
  FCtrlTable.AddCtrl('clvmrg', Integer(rptbVertMerge), ReadTableFormatting);
  FCtrlTable.AddCtrl('clwWidth', Integer(rptbCellWidth), ReadTableFormatting);
  FCtrlTable.AddCtrl('cellx', Integer(rptbCellX), ReadTableFormatting);
  // text formatting ctrls
  FCtrlTable.AddCtrl('plain', Integer(rptPlain), ReadTextFormatting);
//  FCtrlTable.AddCtrl('f', Integer(rptFontIndex), ReadTextFormatting); see ReadFontGroup
  FCtrlTable.AddCtrl('b', Integer(rptBold), ReadTextFormatting);
  FCtrlTable.AddCtrl('i', Integer(rptItalic), ReadTextFormatting);
  FCtrlTable.AddCtrl('ul', Integer(rptUnderline), ReadTextFormatting);
  FCtrlTable.AddCtrl('strike', Integer(rptStrikeout), ReadTextFormatting);
  FCtrlTable.AddCtrl('caps', Integer(rptCaps), ReadTextFormatting);
  FCtrlTable.AddCtrl('scaps', Integer(rptSmallCaps), ReadTextFormatting);
  FCtrlTable.AddCtrl('fs', Integer(rptFontSize), ReadTextFormatting);
  FCtrlTable.AddCtrl('cf', Integer(rptForeColor), ReadTextFormatting);
  FCtrlTable.AddCtrl('cb', Integer(rptBackColor), ReadTextFormatting);
  FCtrlTable.AddCtrl('highlight', Integer(rptBackColor), ReadTextFormatting);
  FCtrlTable.AddCtrl('sub', Integer(rptSubscript), ReadTextFormatting);
  FCtrlTable.AddCtrl('super', Integer(rptSuperscript), ReadTextFormatting);
end;

procedure TKMemoRTFReader.AddText(const APart: TKString);
var
  S: TKString;
begin
  S := APart;
  while (FIgnoreChars > 0) and (S <> '') do
  begin
    Delete(S, 1, 1);
    Dec(FIgnoreChars);
  end;
  if S <> '' then
  begin
    FTmpTextStyle.Assign(FActiveState.TextStyle);
    if FTmpTextStyle.StyleChanged then
    begin
      FlushText;
      FTmpTextStyle.StyleChanged := False;
    end;
    if FActiveText = nil then
    begin
      FActiveText := TKMemoTextBlock.Create;
      FActiveText.TextStyle.Assign(FTmpTextStyle);
    end;
    FActiveString := FActiveString + S;
  end;
end;

procedure TKMemoRTFReader.AddTextToNumberingFormat(const APart: TKString);
var
  S: TKString;
begin
  if APart <> '' then
  begin
    S := APart;
    while (FIgnoreChars > 0) and (S <> '') do
    begin
      Delete(S, 1, 1);
      Dec(FIgnoreChars);
    end;
    if S <> '' then
    begin
      if Ord(S[1]) < $20 then
        ActiveListLevel.NumberingFormat.AddItem(Ord(S[1]), '')
      else
        ActiveListLevel.NumberingFormat.AddItem(-1, S);
    end;
  end;
end;

procedure TKMemoRTFReader.ApplyFont(ATextStyle: TKMemoTextStyle; AFontIndex: Integer);
var
  Font: TFont;
begin
  Font := FFontTable.GetFont(AFontIndex);
  if Font <> nil then
  begin
    ATextStyle.Font.Name := Font.Name;
    ATextStyle.Font.Charset := Font.Charset;
    ATextStyle.Font.Pitch := Font.Pitch;
  end else
  asm
    nop // debug line
  end;
end;

procedure TKMemoRTFReader.ApplyHighlight(ATextStyle: TKMemoTextStyle; AHighlightCode: Integer);
var
  Color: TColor;
begin
  Color := HighlightCodeToColor(AHighlightCode);
  if Color <> clNone then
    ATextStyle.Brush.Color := Color
  else
    ATextStyle.Brush.Style := bsClear;
end;

function TKMemoRTFReader.EMUToPoints(AValue: Integer): Integer;
begin
  Result := DivUp(AValue, 12700);
end;

procedure TKMemoRTFReader.FlushColor;
begin
  if FActiveColor <> nil then
  begin
    FColorTable.Add(FActiveColor);
    FActiveColor := nil;
  end;
end;

procedure TKMemoRTFReader.FlushContainer;
begin
  if FActiveContainer <> nil then
  begin
    FActiveBlocks := FActiveContainer.ParentBlocks;
    FAtIndex := FIndexStack.PopValue;
    FActiveBlocks.AddAt(FActiveContainer, FAtIndex);
    Inc(FAtIndex);
    FActiveContainer := nil;
  end;
end;

procedure TKMemoRTFReader.FlushFont;
begin
  if FActiveFont <> nil then
  begin
    FFontTable.Add(FActiveFont);
    FActiveFont := nil;
  end;
end;

procedure TKMemoRTFReader.FlushHyperlink;
begin
  FlushText;
  FActiveURL := '';
end;

procedure TKMemoRTFReader.FlushImage;
begin
  if FActiveImage <> nil then
  begin
    FActiveBlocks.AddAt(FActiveImage, FAtIndex);
    Inc(FAtIndex);
    FActiveImage := nil;
  end;
end;

procedure TKMemoRTFReader.FlushList;
begin
  if FActiveList <> nil then
  begin
    if FActiveList.Levels.Count > 0 then
    begin
      FListTable.Add(FActiveList);
      FActiveList := nil;
    end else
      FreeAndNil(FActiveList);
  end;
end;

procedure TKMemoRTFReader.FlushListLevel;
var
  NFItem: TKMemoNumberingFormatItem;
  S: TKString;
begin
  if FActiveListLevel <> nil then
  begin
    // fixup numbering format
    FActiveListLevel.NumberingFormat.Delete(0); // first item should be length, remove it
    NFItem := FActiveListLevel.NumberingFormat[FActiveListLevel.NumberingFormat.Count - 1];
    S := NFItem.Text; // last item should be string and end with a semicolon, remove it
    if S[Length(S)] = ';' then
    begin
      System.Delete(S, Length(S), 1);
      NFItem.Text := S;
    end;
    ActiveList.Levels.Add(FActiveListLevel);
    FActiveListLevel := nil;
  end;
end;

procedure TKMemoRTFReader.FlushListOverride;
begin
  if FActiveListOverride <> nil then
  begin
    FListTable.Overrides.Add(FActiveListOverride);
    FActiveListOverride := nil;
  end;
end;

procedure TKMemoRTFReader.FlushParagraph;
var
  PA: TKMemoParagraph;
begin
  PA := FActiveBlocks.AddParagraph(FAtIndex);
  PA.TextStyle.Assign(FActiveState.TextStyle);
  PA.ParaStyle.Assign(FActiveState.ParaStyle);
  Inc(FAtIndex);
  FActiveParaBorder := alNone;
end;

procedure TKMemoRTFReader.FlushShape;
var
  State: TKMemoRTFState;
begin
  if FActiveShape <> nil then
  begin
    case FActiveShape.ContentType of
      sctImage:
      begin
        // image was inside shape
        if FActiveImage <> nil then
        begin
          ActiveImage.Position := mbpRelative;
          if FActiveShape.HorzPosCode = 2 then
            ActiveImage.LeftOffset := FActiveShape.ContentPosition.Left;
          if FActiveShape.VertPosCode = 2 then
            ActiveImage.TopOffset := FActiveShape.ContentPosition.Top;
          ActiveImage.ImageStyle.Assign(FActiveShape.Style);
          FlushImage;
        end;
      end;
      sctRectangle:
      begin
        // currently only document background supported, look if it is the case
        State := FStack.Peek;
        if (State <> nil) and (State.Group = rgPageBackground) then
        begin
          if FActiveShape.FillBlip then
          begin
            if FActiveImage <> nil then
            begin
              FMemo.BackgroundImage.Assign(ActiveImage.Image);
              FreeAndNil(FActiveImage);
            end;
          end else
            FMemo.Colors.BkGnd := FActiveShape.Style.Brush.Color;
        end;
      end;
      sctTextBox:
      begin
        if FActiveContainer <> nil then
        begin
          // container was inside shape
          ActiveContainer.Position := mbpRelative;
          ActiveContainer.Clip := True;
          ActiveContainer.FixedWidth := True;
          if not FActiveShape.FitToText then
            ActiveContainer.FixedHeight := True;
          if FActiveShape.HorzPosCode = 2 then
            ActiveContainer.LeftOffset := FActiveShape.ContentPosition.Left;
          if FActiveShape.VertPosCode = 2 then
            ActiveContainer.TopOffset := FActiveShape.ContentPosition.Top;
          ActiveContainer.RequiredWidth := FActiveShape.ContentPosition.Right - FActiveShape.ContentPosition.Left;
          ActiveContainer.RequiredHeight := FActiveShape.ContentPosition.Bottom - FActiveShape.ContentPosition.Top;
          ActiveContainer.BlockStyle.Assign(FActiveShape.Style);
          FlushContainer;
        end;
      end;
      sctText:
      begin
        // unformatted text was inside shape
        FlushText;
      end;
    end;
    FreeAndNil(FActiveShape);
  end;
end;

procedure TKMemoRTFReader.FlushTable;
begin
  if FActiveTable <> nil then
  begin
    FActiveTable.FixupCellSpanFromRTF;
    FActiveTable.FixupBorders;
    FActiveTable.UnlockUpdate;
    FActiveBlocks := FActiveTable.ParentBlocks;
    FAtIndex := FIndexStack.PopValue;
    if not FActiveBlocks.InsideOfTable then // no support for nested tables yet
    begin
      FActiveBlocks.AddAt(FActiveTable, FAtIndex);
      Inc(FAtIndex);
    end else
      FActiveTable.Free;
    FActiveTable := nil;
    FActiveTableRow := nil;
    FActiveTableCell := nil;
  end;
end;

procedure TKMemoRTFReader.FlushText;
var
  Item: TKMemoHyperlink;
begin
  if FActiveText <> nil then
  begin
    if FActiveString <> '' then
    begin
      FActiveText.InsertString(FActiveString);
      FActiveString := '';
    end;
    if FActiveText.TextStyle.Font.Name = 'Symbol' then
    begin
      FActiveText.TextStyle.Font.Name := 'Arial';
      FActiveText.TextStyle.Font.Charset := 0;
    end;
    if FActiveURL <> '' then
    begin
      TrimWhiteSpaces(FActiveURL, cWordBreaks);
      Item := TKMemoHyperlink.Create;
      Item.Assign(FActiveText);
      Item.URL := FActiveURL;
      FreeAndNil(FActiveText);
      FActiveText := Item;
    end;
    FActiveBlocks.AddAt(FActiveText, FAtIndex);
    Inc(FAtIndex);
    FActiveText := nil;
  end;
end;

function TKMemoRTFReader.GetActiveColor: TKMemoRTFColor;
begin
  if FActiveColor = nil then
    FActiveColor := TKMemoRTFColor.Create;
  Result := FActiveColor;
end;

function TKMemoRTFReader.GetActiveContainer: TKMemoContainer;
begin
  if FActiveContainer = nil then
    FActiveContainer := TKMemoContainer.Create;
  Result := FActiveContainer;
end;

function TKMemoRTFReader.GetActiveFont: TKMemoRTFFont;
begin
  if FActiveFont = nil then
    FActiveFont := TKMemoRTFFont.Create;
  Result := FActiveFont;
end;

function TKMemoRTFReader.GetActiveImage: TKMemoImageBlock;
begin
  if FActiveImage = nil then
    FActiveImage := TKMemoImageBlock.Create;
  Result := FActiveImage;
end;

function TKMemoRTFReader.GetActiveList: TKMemoRTFList;
begin
  if FActiveList = nil then
    FActiveList := TKMemoRTFList.Create(nil);
  Result := FActiveList;
end;

function TKMemoRTFReader.GetActiveListLevel: TKMemoRTFListLevel;
begin
  if FActiveListLevel = nil then
    FActiveListLevel := TKMemoRTFListLevel.Create;
  Result := FActiveListLevel;
end;

function TKMemoRTFReader.GetActiveListOverride: TKMemoDictionaryItem;
begin
  if FActiveListOverride = nil then
    FActiveListOverride := TKMemoDictionaryItem.Create;
  Result := FActiveListOverride;
end;

function TKMemoRTFReader.GetActiveShape: TKMemoRTFShape;
begin
  if FActiveShape = nil then
    FActiveShape := TKMemoRTFShape.Create;
  Result := FActiveShape;
end;

function TKMemoRTFReader.GetActiveTable: TKMemoTable;
begin
  if FActiveTable = nil then
    FActiveTable := TKMemoTable.Create;
  Result := FActiveTable;
end;

function TKMemoRTFReader.HighlightCodeToColor(AValue: Integer): TColor;
begin
  // it seems that highlight color is taken from color table, is it correct?
  case AValue of
    1: Result := clBlack;
    2: Result := clBlue;
    3: Result := clAqua; // cyan
    4: Result := clLime; // green
    5: Result := clFuchsia; // magenta
    6: Result := clRed;
    7: Result := clYellow;
    9: Result := clNavy;
    10: Result := clTeal; // dark cyan
    11: Result := clGreen; // dark green
    12: Result := clPurple; // dark magenta
    13: Result := clMaroon; // dark red
    14: Result := clOlive; // dark yellow
    15: Result := clGray; // dark gray
    16: Result := clSilver; // light gray
  else
    Result := clNone;
  end;
end;

procedure TKMemoRTFReader.LoadFromFile(const AFileName: TKString; AtIndex: Integer);
var
  Stream: TMemoryStream;
begin
  if FileExists(AFileName) then
  begin
    Stream := TMemoryStream.Create;
    try
      Stream.LoadFromFile(AFileName);
      LoadFromStream(Stream, AtIndex);
    finally
      Stream.Free;
    end;
  end;
end;

procedure TKMemoRTFReader.LoadFromStream(AStream: TStream; AtIndex: Integer);
var
  Item, NewItem: TKMemoBlock;
  ContLocalIndex, BlockLocalIndex: Integer;
begin
  try
    if AtIndex < 0 then
    begin
      FMemo.Clear;
      FMemo.Blocks.Clear; // delete everything
      FActiveBlocks := FMemo.Blocks;
      FAtIndex := 0; // just append new blocks to active blocks
    end else
    begin
      FActiveBlocks := FMemo.Blocks.IndexToBlocks(AtIndex, ContLocalIndex); // get active blocks
      if FActiveBlocks <> nil then
      begin
        FAtIndex := FActiveBlocks.IndexToBlock(ContLocalIndex, BlockLocalIndex); // get block index within active blocks
        if FAtIndex >= 0 then
        begin
          // if active block is splittable do it and make space for new blocks
          Item := FActiveBlocks.Items[FAtIndex];
          NewItem := Item.Split(BlockLocalIndex);
          if NewItem <> nil then
          begin
            Inc(FAtIndex);
            FActiveBlocks.AddAt(NewItem, FAtIndex);
          end;
        end else
          FAtIndex := 0; // just append new blocks to active blocks
      end else
      begin
        FActiveBlocks := FMemo.Blocks;
        FAtIndex := 0; // just append new blocks to active blocks
      end;
    end;
    FActiveBlocks.LockUpdate;
    try
      FActiveColor := nil;
      FActiveContainer := nil;
      FActiveFont := nil;
      FActiveImage := nil;
      FActiveImageClass := nil;
      FActiveList := nil;
      FActiveListLevel := nil;
      FActiveListOverride := nil;
      FActiveParaBorder := alNone;
      FActiveShape := nil;
      FActiveState := TKMemoRTFState.Create;
      FActiveState.Group := rgUnknown; // we wait for file header
      FActiveState.ParaStyle.Assign(FMemo.ParaStyle);
      FActiveState.TextStyle.Assign(FMemo.TextStyle);
      FActiveString := '';
      FActiveTable := nil;
      FActiveTableBorder := alNone;
      FActiveTableCell := nil;
      FActiveTableCol := -1;
      FActiveTableColCount := 0;
      FActiveTableRow := nil;
      FActiveText := nil;
      FColorTable.Clear;
      FDefaultFontIndex := 0;
      FIgnoreChars := 0;
      FStream := AStream;
      ReadStream;
    finally
      FlushText;
      FlushShape;
      FlushImage;
      FlushTable;
      FActiveState.Free;
      FListTable.AssignToListTable(FMemo.ListTable, FFontTable);
      FActiveBlocks.ConcatEqualBlocks;
      FActiveBlocks.UnlockUpdate;
    end;
  except
    KFunctions.Error(sErrMemoLoadFromRTF);
  end;
end;

function TKMemoRTFReader.ParamToBool(const AValue: AnsiString): Boolean;
begin
  Result := Boolean(StrToIntDef(string(AValue), 0));
end;

function TKMemoRTFReader.ParamToColor(const AValue: AnsiString): TColor;
begin
  Result := ColorRecToColor(MakeColorRec(StrToIntDef(string(AValue), 0)));
end;

function TKMemoRTFReader.ParamToEMU(const AValue: AnsiString): Integer;
begin
  Result := EMUToPoints(StrToIntDef(string(AValue), 0));
end;

function TKMemoRTFReader.ParamToInt(const AValue: AnsiString): Integer;
begin
  Result := StrToIntDef(string(AValue), 0);
end;

procedure TKMemoRTFReader.PopFromStack(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
var
  State: TKMemoRTFState;
begin
  State := FStack.Peek;
  if State <> nil then
  begin
    // flush shapes, images and other embedded objects to memo
    if FActiveState.Group = rgShape then
    begin
      // standard shape group
      FlushShape
    end
    else if FActiveState.Group = rgShapePict then
    begin
      // image inside of shppict group (Word 97 and newer images)
      FlushText;
      if FActiveImage <> nil then
      begin
        if FActiveShape <> nil then
          FActiveImage.ImageStyle.Assign(FActiveShape.Style);
        FlushImage;
      end;
    end
    else if (FActiveState.Group = rgPicture) and (State.Group in [rgNone, rgTextBox]) then
    begin
      // standalone image outside of shppict and shape group (e.g. results of embedded objects)
      FlushText;
      FlushImage;
    end
    else if FActiveState.Group = rgField then
    begin
      // we only support hyperlinks now
      FlushHyperlink;
    end
    else if (FActiveState.Group = rgListLevel) and (State.Group = rgList) then
    begin
      FlushListLevel;
    end
    else if (FActiveState.Group = rgList) and (State.Group = rgListTable) then
    begin
      FlushList;
    end
    else if (FActiveState.Group = rgListOverride) and (State.Group = rgListOverrideTable) then
    begin
      FlushListOverride;
    end;
    FActiveState.Free;
    FActiveState := FStack.Pop;
  end;
end;

procedure TKMemoRTFReader.PushToStack(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
var
  State: TKMemoRTFState;
begin
  FStack.Push(FActiveState);
  State := TKMemoRTFState.Create;
  State.Assign(FActiveState);
  FActiveState := State;
end;

function TKMemoRTFReader.ReadNext(out ACtrl, AText: AnsiString; out AParam: Int64): Boolean;

  procedure ReadText(var AText: AnsiString; AChar: AnsiChar);
  begin
    repeat
      if (AChar <> cCR) and (AChar <> cLF) then
        AText := AText + AChar;
      Result := FStream.Read(AChar, 1) > 0;
    until CharInSetEx(AChar, ['{', '}', '\']) or not Result;
    if Result then
      FStream.Seek(-1, soFromCurrent);
  end;

var
  C: AnsiChar;
  ParamStr: AnsiString;
  Code: Integer;
begin
  AParam := MaxInt;
  ACtrl := '';
  AText := '';
  Result := FStream.Read(C, 1) > 0;
  if C = '\' then
  begin
    FStream.Read(C, 1);
    if CharInSetEx(C, cLetters) then
    begin
      // control word
      repeat
        ACtrl := ACtrl + C;
        Result := FStream.Read(C, 1) > 0;
      until not (Result and CharInSetEx(C, cLetters));
      if (C = '-') or CharInSetEx(C, cNumbers) then
      begin
        // control word parameter
        ParamStr := '';
        repeat
          ParamStr := ParamStr + C;
          Result := FStream.Read(C, 1) > 0;
        until not (Result and CharInSetEx(C, cNumbers));
        AParam := StrToIntDef(TKString(ParamStr), 0);
        if Result and (C <> ' ') then
          FStream.Seek(-1, soFromCurrent);
      end
      else if Result and (C <> ' ') then
        FStream.Seek(-1, soFromCurrent);
    end else
    begin
      ACtrl := C; //control symbol
      if C = '''' then
      begin
        //hexadecimal value - special symbol
        SetLength(ParamStr, 2);
        Result := FStream.Read(ParamStr[1], 2) = 2;
        if Result then
          AParam := HexStrToInt(string(ParamStr), Length(ParamStr), False, Code);
      end
      else if CharInSetEx(C, ['{', '}', '\'])  then
      begin
        AText := C; // control symbol is printable character
        ACtrl := '';
      end;
    end;
    if FStream.Read(C, 1) > 0 then
    begin
      if CharInSetEx(C, ['{', '}', '\']) then
        FStream.Seek(-1, soFromCurrent)
      else
        ReadText(AText, C);
    end;
  end
  else if CharInSetEx(C, ['{', '}', ';']) then
    ACtrl := C // group
  else
    ReadText(AText, C);
end;

procedure TKMemoRTFReader.ReadColorGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
begin
  if FActiveState.Group = rgColorTable then
  begin
    case TKMemoRTFColorProp(ACtrl) of
      rpcRed: ActiveColor.Red := Byte(AParam);
      rpcGreen: ActiveColor.Green := Byte(AParam);
      rpcBlue: ActiveColor.Blue := Byte(AParam);
    end;
    if AText = ';' then
    begin
      FlushColor;
      AText := ''; // we used the text as end of the color record
    end;
  end;
end;

procedure TKMemoRTFReader.ReadDocumentGroups(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
begin
  if FActiveState.Group = rgNone then case TKMemoRTFDocumentProp(ACtrl) of
    rpdFooter, rpdFooterLeft, rpdFooterRight: FActiveState.Group := rgFooter;
    rpdHeader, rpdHeaderLeft, rpdHeaderRight: FActiveState.Group := rgHeader;
    rpdInfo: FActiveState.Group := rgInfo;
  end;
end;

procedure TKMemoRTFReader.ReadFieldGroup(ACtrl: Integer; var AText: AnsiString;
  AParam: Integer);
begin
  case TKMemoRTFFieldProp(ACtrl) of
    rpfiField: FActiveState.Group := rgField;
    rpfiResult:
    begin
      FlushText;
      FActiveState.Group := rgFieldResult;
    end
  else
    case FActiveState.Group of
      rgFieldInst:
      begin
        if AText <> '' then
        begin
          if Pos(cRTFHyperlink, string(AText)) = 1 then
          begin
            Delete(AText, 1, Length(cRTFHyperlink));
            FActiveURL := TKString(AText);
          end else
          begin
            if FActiveURL <> '' then
              FActiveURL := FActiveURL + TKString(AText);
          end;
          AText := '';
        end;
      end;
    end;
  end;
end;

procedure TKMemoRTFReader.ReadFontGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
var
  I: Integer;
  S: TKString;
begin
  case FActiveState.Group of
    rgFontTable:
    begin
      case TKMemoRTFFontProp(ACtrl) of
        rpfIndex: ActiveFont.FFontIndex := AParam;
        rpfCharSet: ActiveFont.Font.Charset := AParam;
        rpfPitch:
        begin
          case AParam of
            1: ActiveFont.Font.Pitch := fpFixed;
            2: ActiveFont.Font.Pitch := fpVariable;
          else
            ActiveFont.Font.Pitch := fpDefault;
          end;
        end;
      end;
      if AText <> '' then
      begin
        S := TKString(AText);
        I := Pos(';', S);
        if I > 0 then
          Delete(S, I, 1);
        ActiveFont.Font.Name := S;
        FlushFont;
        AText := ''; // we used the text as font name
      end
    end;
    rgNone, rgTextBox:
    begin
      case TKMemoRTFFontProp(ACtrl) of
        rpfIndex: ReadTextFormatting(Integer(rptFontIndex), AText, AParam);
      end;
    end;
    rgListLevel:
    begin
      case TKMemoRTFFontProp(ACtrl) of
        rpfIndex: ReadListGroup(Integer(rplLevelFontIndex), AText, AParam);
      end;
    end;
  end;
end;

procedure TKMemoRTFReader.ReadHeaderGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
begin
  if FActiveState.Group = rgUnknown then
  begin
    case TKMemoRTFheaderProp(ACtrl) of
      rphRtf: FActiveState.Group := rgNone;
    end;
  end
  else if FActiveState.Group = rgNone then case TKMemoRTFheaderProp(ACtrl) of
    rphCodePage: FDefaultCodePage := AParam;
    rphDefaultFont: FDefaultFontIndex := AParam;
    rphIgnoreCharsAfterUnicode: FIgnoreCharsAfterUnicode := AParam;
    rphFontTable: FActiveState.Group := rgFontTable;
    rphColorTable: FActiveState.Group := rgColorTable;
    rphStyleSheet: FActiveState.Group := rgStyleSheet;
  end;
end;

procedure TKMemoRTFReader.ReadListGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
begin
  case FActiveState.Group of
    rgListTable: case TKMemoRTFListProp(ACtrl) of
      rplList: FActiveState.Group := rgList;
    end;
    rgList: case TKMemoRTFListProp(ACtrl) of
      rplListLevel: FActiveState.Group := rgListLevel;
      rplListId: ActiveList.ID := AParam;
    end;
    rgListLevel: case TKMemoRTFListProp(ACtrl) of
      rplLevelText: FActiveState.Group := rgListLevelText;
      rplLevelStartAt: ActiveListLevel.StartAt := AParam;
      rplLevelNumberType: ActiveListLevel.NumberType := AParam;
      rplLevelJustify: ActiveListLevel.Justify := AParam;
      rplLevelFontIndex: ActiveListLevel.FontIndex := AParam;
      rplLevelFirstIndent: ActiveListLevel.FirstIndent := TwipsToPoints(AParam);
      rplLevelLeftIndent: ActiveListLevel.LeftIndent := TwipsToPoints(AParam);
    end;
    rgListOverrideTable: case TKMemoRTFListProp(ACtrl) of
      rplListOverride: FActiveState.Group := rgListOverride;
    end;
    rgListOverride: case TKMemoRTFListProp(ACtrl) of
      rplListId: ActiveListOverride.Value := AParam;
      rplListIndex: ActiveListOverride.Index := AParam;
    end;
    rgListLevelText: AddTextToNumberingFormat(string(AText));
  else
    case TKMemoRTFListProp(ACtrl) of
      rplListText: FActiveState.Group := rgUnknown; // ignore text
    end;
  end;
end;

procedure TKMemoRTFReader.ReadParaFormatting(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
begin
  case FActiveState.Group of
    rgNone, rgTextBox, rgFieldResult: case TKMemoRTFParaProp(ACtrl) of
      rppParD: FActiveState.ParaStyle.Assign(FMemo.ParaStyle);
      rppIndentFirst: FActiveState.ParaStyle.FirstIndent := TwipsToPoints(AParam);
      rppIndentBottom: FActiveState.ParaStyle.BottomPadding := TwipsToPoints(AParam);
      rppIndentLeft: FActiveState.ParaStyle.LeftPadding := TwipsToPoints(AParam);
      rppIndentRight: FActiveState.ParaStyle.RightPadding := TwipsToPoints(AParam);
      rppIndentTop: FActiveState.ParaStyle.TopPadding := TwipsToPoints(AParam);
      rppAlignLeft: FActiveState.ParaStyle.HAlign := halLeft;
      rppAlignCenter: FActiveState.ParaStyle.HAlign := halCenter;
      rppAlignRight: FActiveState.ParaStyle.HAlign := halRight;
      rppAlignJustify: FActiveState.ParaStyle.HAlign := halJustify;
      rppBackColor: FActiveState.ParaStyle.Brush.Color := FColorTable.GetColor(AParam - 1);
      rppNoWordWrap: FActiveState.ParaStyle.WordWrap := False;
      rppBorderBottom: FActiveParaBorder := alBottom;
      rppBorderLeft: FActiveParaBorder := alLeft;
      rppBorderRight: FActiveParaBorder := alRight;
      rppBorderTop: FActiveParaBorder := alTop;
      rppBorderAll: FActiveParaBorder := alClient;
      rppBorderWidth:
      case FActiveParaBorder of
        alBottom: FActiveState.ParaStyle.BorderWidths.Bottom := TwipsToPoints(AParam);
        alLeft: FActiveState.ParaStyle.BorderWidths.Left := TwipsToPoints(AParam);
        alRight: FActiveState.ParaStyle.BorderWidths.Right := TwipsToPoints(AParam);
        alTop: FActiveState.ParaStyle.BorderWidths.Top := TwipsToPoints(AParam);
        alClient: FActiveState.ParaStyle.BorderWidth := TwipsToPoints(AParam);
      else
        if FActiveTableBorder <> alNone then
          ReadTableFormatting(Integer(rptbBorderWidth), AText, AParam)
      end;
      rppBorderNone:
      case FActiveParaBorder of
        alBottom: FActiveState.ParaStyle.BorderWidths.Bottom := 0;
        alLeft: FActiveState.ParaStyle.BorderWidths.Left := 0;
        alRight: FActiveState.ParaStyle.BorderWidths.Right := 0;
        alTop: FActiveState.ParaStyle.BorderWidths.Top := 0;
        alClient: FActiveState.ParaStyle.BorderWidth := 0;
      else
        if FActiveTableBorder <> alNone then
          ReadTableFormatting(Integer(rptbBorderNone), AText, AParam)
      end;
      rppBorderRadius: FActiveState.ParaStyle.BorderRadius := TwipsToPoints(AParam);
      rppBorderColor:
      begin
        if FActiveParaBorder <> alNone then
          FActiveState.ParaStyle.BorderColor := FColorTable.GetColor(AParam - 1)
        else if FActiveTableBorder <> alNone then
          ReadTableFormatting(Integer(rptbBorderColor), AText, AParam)
      end;
      rppLineSpacing:
      begin
        FActiveState.ParaStyle.LineSpacingValue := TwipsToPoints(AParam);
        FActiveState.ParaStyle.LineSpacingFactor := AParam / 240;
      end;
      rppLineSpacingMode:
      begin
        if AParam = 0 then
          FActiveState.ParaStyle.LineSpacingMode := lsmValue
        else
          FActiveState.ParaStyle.LineSpacingMode := lsmFactor
      end;
      rppPar:
      begin
        FlushText;
        FlushParagraph;
      end;
      rppListIndex: FActiveState.ParaStyle.NumberingList := FListTable.IDByIndex(AParam);
      rppListLevel: FActiveState.ParaStyle.NumberingListLevel := AParam;
      rppListStartAt: FActiveState.ParaStyle.NumberStartAt := AParam;
    end;
    rgListLevel: case TKMemoRTFParaProp(ACtrl) of
      rppIndentFirst: ReadListgroup(Integer(rplLevelFirstIndent), AText, AParam);
      rppIndentLeft: ReadListgroup(Integer(rplLevelLeftIndent), AText, AParam);
    end;
    rgListOverride: case TKMemoRTFParaProp(ACtrl) of
      rppListIndex: ReadListgroup(Integer(rplListIndex), AText, AParam);
    end;
  end;
end;

procedure TKMemoRTFReader.ReadPictureGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
var
  S: AnsiString;
  MS: TMemoryStream;
  Image: TGraphic;
  Tmp: Integer;
begin
  if FActiveState.Group in [rgShapeInst, rgShapePict, rgNone, rgTextBox] then
  begin
    case TKMemoRTFImageProp(ACtrl) of
      rpiPict:
      begin
        FActiveState.Group := rgPicture;
      end;
    end;
  end
  else if FActiveState.Group in [rgPicture] then
  begin
    case TKMemoRTFImageProp(ACtrl) of
      rpiJPeg: FActiveImageClass := TJpegImage;
    {$IFDEF USE_PNG_SUPPORT}
      rpiPng: FActiveImageClass := TKPngImage;
    {$ENDIF}
    {$IFDEF USE_WINAPI}
      rpiEmf:
      begin
        FActiveImageClass := TKMetafile;
        FActiveImageIsEMF := True;
      end;
      rpiWmf:
      begin
        FActiveImageClass := TKMetafile;
        FActiveImageIsEMF := False;
      end;
    {$ENDIF}
      rpiWidth: ActiveImage.OriginalWidth := TwipsToPoints(AParam);
      rpiHeight: ActiveImage.OriginalHeight := TwipsToPoints(AParam);
      rpiCropBottom: ActiveImage.Crop.Bottom := TwipsToPoints(AParam);
      rpiCropLeft: ActiveImage.Crop.Left := TwipsToPoints(AParam);
      rpiCropRight: ActiveImage.Crop.Right := TwipsToPoints(AParam);
      rpiCropTop: ActiveImage.Crop.Top := TwipsToPoints(AParam);
      rpiScaleX:
      begin
        if AParam > 0 then
          ActiveImage.ScaleX := AParam;
      end;
      rpiScaleY:
      begin
        if AParam > 0 then
          ActiveImage.ScaleY := AParam;
      end;
      rpiReqWidth: if ActiveImage.OriginalWidth > 0 then
      begin
        Tmp := MulDiv(TwipsToPoints(AParam), 100, ActiveImage.OriginalWidth);
        if Tmp < ActiveImage.ScaleX then
          ActiveImage.ScaleX := Tmp;
      end;
      rpiReqHeight: if ActiveImage.OriginalHeight > 0 then
      begin
        Tmp := MulDiv(TwipsToPoints(AParam), 100, ActiveImage.OriginalHeight);
        if Tmp < ActiveImage.ScaleY then
          ActiveImage.ScaleY := Tmp;
      end;
    end;
    if AText <> '' then
    begin
      if FActiveImageClass <> nil then
      begin
        S := AText;
        if DigitsToBinStr(S) then
        begin
          S := BinStrToBinary(S);
          try
            MS := TMemoryStream.Create;
            try
              MS.Write(S[1], Length(S));
              MS.Seek(0, soFromBeginning);
              Image := FActiveImageClass.Create;
              try
              {$IFDEF USE_WINAPI}
                if Image is TKMetafile then
                begin
                  //if not FImageEnhMetafile then MS.SaveToFile('test.wmf');
                  TKMetafile(Image).CopyOnAssign := False; // we will destroy this instance anyway...
                  TKMetafile(Image).Enhanced := FActiveImageIsEMF;
                  TKmetafile(Image).LoadFromStream(MS);
                  if not FActiveImageIsEMF then
                  begin
                    // WMF extent could be incorrect here, so use RTF info
                    TKMetafile(Image).Width := PointsToTwips(ActiveImage.OriginalWidth);
                    TKMetafile(Image).Height := PointsToTwips(ActiveImage.OriginalHeight);
                  end;
                end else
              {$ENDIF}
                  Image.LoadFromStream(MS);
                ActiveImage.Image.Graphic := Image;
              finally
                Image.Free;
              end;
            finally
              MS.Free;
            end;
          except
            KFunctions.Error(sErrMemoLoadImageFromRTF);
          end;
        end;
        FActiveImageClass := nil;
      end else
      asm
        nop; // debug line
      end;
      AText := ''; // we used the text as image data
    end;
  end;
end;

procedure TKMemoRTFReader.ReadShapeGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
begin
  case TKMemoRTFShapeProp(ACtrl) of
    rpsShape: FActiveState.Group := rgShape;
  end;
  if FActiveState.Group in [rgShapeInst, rgShapePict, rgPicProp] then case TKMemoRTFShapeProp(ACtrl) of
    rpsBottom: ActiveShape.ContentPosition.Bottom := TwipsToPoints(AParam);
    rpsLeft: ActiveShape.ContentPosition.Left := TwipsToPoints(AParam);
    rpsRight: ActiveShape.ContentPosition.Right := TwipsToPoints(AParam);
    rpsTop: ActiveShape.ContentPosition.Top := TwipsToPoints(AParam);
    rpsXColumn: ActiveShape.HorzPosCode := 2; // we silently assume posrelh always comes later
    rpsYPara: ActiveShape.VertPosCode := 2; // we silently assume posrelv always comes later
    rpsWrap: ActiveShape.Wrap := AParam;
    rpsWrapSide: ActiveShape.WrapSide := AParam;
    rpsSn: ActiveShape.CtrlName := AText;
    rpsSv:
    begin
      ActiveShape.CtrlValue := AText;
      // do different things according to CtrlName property
      if ActiveShape.CtrlName = 'posrelh' then
      begin
        ActiveShape.HorzPosCode := ParamToInt(AText);
      end
      else if ActiveShape.CtrlName = 'posrelv' then
      begin
        ActiveShape.VertPosCode := ParamToInt(AText);
      end
      else if ActiveShape.CtrlName = 'fFitShapeToText' then
        ActiveShape.FitToText := True
      else if ActiveShape.CtrlName = 'fFitTextToShape' then
        ActiveShape.FitToShape := True
      else if ActiveShape.CtrlName = 'fFilled' then
      begin
        if not ParamToBool(AText) then
          ActiveShape.Style.Brush.Style := bsClear;
      end
      else if ActiveShape.CtrlName = 'fillColor' then
        ActiveShape.Style.Brush.Color := ParamToColor(AText)
      else if ActiveShape.CtrlName = 'fillBlip' then
        ActiveShape.FillBlip := True
      else if ActiveShape.CtrlName = 'fLine' then
      begin
        if not ParamToBool(AText) then
          ActiveShape.Style.BorderWidth := 0;
      end
      else if ActiveShape.CtrlName = 'lineColor' then
        ActiveShape.Style.BorderColor := ParamToColor(AText)
      else if ActiveShape.CtrlName = 'lineWidth' then
        ActiveShape.Style.BorderWidth := ParamToEMU(AText)
      else if ActiveShape.CtrlName = 'shapeType' then
      begin
        // supported shape types
        case StrToIntDef(string(ActiveShape.CtrlValue), 0) of
          1: ActiveShape.ContentType := sctRectangle;
          75: ActiveShape.ContentType := sctImage;
          202:
          begin
            ActiveShape.ContentType := sctTextBox;
            ActiveShape.Style.ContentPadding.AssignFromValues(5, 5, 5, 5); //default padding for text box
          end;
        end;
      end;
    end;
    rpsShapeText:
    begin
      // this keyword starts the actual text box contents
      FlushText;
      ActiveContainer.Parent := FActiveBlocks;
      FActiveBlocks := ActiveContainer.Blocks;
      FIndexStack.PushValue(FAtIndex);
      FAtIndex := 0;
      FActiveState.Group := rgTextBox;
    end;
  end;
end;

procedure TKMemoRTFReader.ReadSpecialCharacter(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
var
  S: TKString;
  CodePage: Integer;
  SetIgnoreChars: Boolean;
begin
  SetIgnoreChars := False;
  S := '';
  // we must suppose here selected font supports these Unicode characters
  case TKMemoRTFSpecialCharProp(ACtrl) of
    rpscTab: S := #9; // tab is rendered with an arrow symbol
    rpscLquote: S := UnicodeToNativeUTF(#$2018);
    rpscRQuote: S := UnicodeToNativeUTF(#$2019);
    rpscLDblQuote: S := UnicodeToNativeUTF(#$201C);
    rpscRDblQuote: S := UnicodeToNativeUTF(#$201D);
    rpscEnDash: S := UnicodeToNativeUTF(#$2013);
    rpscEmDash: S := UnicodeToNativeUTF(#$2014);
    rpscBullet: S := UnicodeToNativeUTF(#$2022);
    rpscNBSP: S := ' '; // nonbreaking spaces not supported
    rpscEmSpace: S := ' ';
    rpscEnSpace: S := ' ';
    rpscAnsiChar:
    begin
      if AParam < $20 then
        S := Chr(AParam)
      else
      begin
        if FActiveState.TextStyle.Font.Name = 'Symbol' then
          S := UnicodeToNativeUTF(WideChar(AdobeSymbolToUTF16(AParam)))
        else
        begin
          if FActiveState.TextStyle.Font.Charset = 0 then
            CodePage := FDefaultCodePage
          else
            CodePage := CharSetToCP(FActiveState.TextStyle.Font.Charset);
          S := AnsiStringToString(AnsiChar(AParam), CodePage);
        end;
      end;
    end;
    rpscUnicodeChar:
    begin
      S := UnicodeToNativeUTF(WideChar(AParam));
      SetIgnoreChars := True;
    end;
  end;
  case FActiveState.Group of
    rgNone, rgTextBox, rgFieldResult: AddText(S);
    rgListLevelText: AddTextToNumberingFormat(S);
  end;
  if SetIgnoreChars then
    FIgnoreChars := FIgnoreCharsAfterUnicode;
end;

procedure TKMemoRTFReader.ReadStream;
var
  Ctrl: AnsiString;
  Text: AnsiString;
  Param: Int64;
  CtrlItem: TKMemoRTFCtrl;
begin
  while FStream.Position < FStream.Size do
  begin
    ReadNext(Ctrl, Text, Param);
    if (Ctrl <> '') or (Text <> '') then
    begin
      if Ctrl <> '' then
      begin
        CtrlItem := FCtrlTable.FindByCtrl(Ctrl);
        if CtrlItem <> nil then
          CtrlItem.Method(CtrlItem.Code, Text, Param);
      end;
      if Text <> '' then
      begin
        // if Method did not use Text use it according to active group
        case FActiveState.Group of
          rgColorTable: ReadColorGroup(-1, Text, 0);
          rgFieldInst: ReadFieldGroup(-1, Text, 0);
          rgFontTable: ReadFontGroup(-1, Text, 0);
          rgPicture: ReadPictureGroup(-1, Text, 0);
          rgListLevelText: ReadListGroup(-1, Text, 0);
          rgNone, rgTextBox, rgFieldResult: AddText(TKString(Text));
        end;
      end;
    end;
  end;
end;

procedure TKMemoRTFReader.ReadTableFormatting(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
var
  I, Value: Integer;
  Cell: TKMemoTableCell;
begin
  if FActiveState.Group in [rgNone, rgTextBox] then case TKMemoRTFTableProp(ACtrl) of
    rptbRowBegin:
    begin
      if FActiveTableColCount = 0 then
      begin
        FlushText;
        if FActiveTable = nil then
        begin
          ActiveTable.LockUpdate;
          ActiveTable.RowCount := 1;
          ActiveTable.ColCount := 1;
          ActiveTable.Parent := FActiveBlocks;
          FActiveTableColCount := 1;
          FActiveTableRow := ActiveTable.Rows[ActiveTable.RowCount - 1];
          FActiveBlocks := FActiveTableRow.Cells[FActiveTableColCount - 1].Blocks; // starting new cell
          FIndexStack.PushValue(FAtIndex);
          FAtIndex := 0;
          FActiveTableCellXPos := 0;
          FActiveTableLastRow := False;
        end;
      end
      else if (FActiveTableRow <> nil) and (FActiveTableRow.CellCount > 1) then
      begin
        // this block comes again after definition of the row and is used to read row/cell properties (at least Word saves this)
        // we don't support reading cell properties before entire row is defined with /cell control words
        FActiveTableCol := 0;
        FActiveTableCell := FActiveTableRow.Cells[FActiveTableCol];
      end
    end;
    rptbCellEnd: if FActiveTableRow <> nil then
    begin
      FlushText;
      Cell := FActiveTableRow.Cells[FActiveTableColCount - 1];
      Cell.ParaStyle.Assign(FActiveState.ParaStyle);
      Inc(FActiveTableColCount);
      FActiveTableRow.CellCount := FActiveTableColCount;
      FActiveBlocks := FActiveTableRow.Cells[FActiveTableColCount - 1].Blocks; // starting new cell
      FAtIndex := 0;
    end;
    rptbRowEnd: if FActiveTableRow <> nil then
    begin
      // delete previously started cell if empty
      if FActiveTableRow.Cells[FActiveTableColCount - 1].Blocks.Count = 0 then
        FActiveTableRow.CellCount := FActiveTableRow.CellCount - 1;
      if FActiveTableLastRow then
      begin
        FlushTable;
        FActiveTableLastRow := False;
        FActiveTableColCount := 0;
      end else
      begin
        ActiveTable.RowCount := ActiveTable.RowCount + 1;
        ActiveTable.ColCount := Max(ActiveTable.ColCount, FActiveTableRow.CellCount);
        FActiveTableRow := ActiveTable.Rows[ActiveTable.RowCount - 1];
        FActiveTableColCount := 1;
        FActiveTableRow.CellCount := FActiveTableColCount;
        FActiveBlocks := FActiveTableRow.Cells[FActiveTableColCount - 1].Blocks; // starting new cell
        FAtIndex := 0;
        FActiveTableCellXPos := 0;
      end;
      FActiveTableCol := -1;
      FActiveTableCell := nil;
      FActiveTableBorder := alNone;
    end;
    rptbLastRow: FActiveTableLastRow := True;
  end;
  // read row/cell formatting (if any)
  if (FActiveTableRow <> nil) and (FActiveTableCell <> nil) then case TKMemoRTFTableProp(ACtrl) of
    rptbPaddAll:
    begin
      // we silently assume this will come before other rptbRowPaddxx ctrls
      Value := TwipsToPoints(AParam);
      for I := 0 to FActiveTableRow.CellCount - 1 do
        FActiveTableRow.Cells[I].BlockStyle.ContentPadding.AssignFromValues(Value, Value, Value, Value);
    end;
    rptbRowPaddBottom:
    begin
      FActiveTableRowPadd.Bottom := TwipsToPoints(AParam);
      for I := 0 to FActiveTableRow.CellCount - 1 do
        FActiveTableRow.Cells[I].BlockStyle.BottomPadding := FActiveTableRowPadd.Bottom;
    end;
    rptbRowPaddLeft:
    begin
      FActiveTableRowPadd.Left := TwipsToPoints(AParam);
      for I := 0 to FActiveTableRow.CellCount - 1 do
        FActiveTableRow.Cells[I].BlockStyle.LeftPadding := FActiveTableRowPadd.Left;
    end;
    rptbRowPaddRight:
    begin
      FActiveTableRowPadd.Right := TwipsToPoints(AParam);
      for I := 0 to FActiveTableRow.CellCount - 1 do
        FActiveTableRow.Cells[I].BlockStyle.RightPadding := FActiveTableRowPadd.Right;
    end;
    rptbRowPaddTop:
    begin
      FActiveTableRowPadd.Top := TwipsToPoints(AParam);
      for I := 0 to FActiveTableRow.CellCount - 1 do
        FActiveTableRow.Cells[I].BlockStyle.TopPadding := FActiveTableRowPadd.Top;
    end;
    rptbBorderBottom: FActiveTableBorder := alBottom;
    rptbBorderLeft: FActiveTableBorder := alLeft;
    rptbBorderRight: FActiveTableBorder := alRight;
    rptbBorderTop: FActiveTableBorder := alTop;
    rptbBorderWidth:
    begin
      case FActiveTableBorder of
        alBottom: FActiveTableCell.RequiredBorderWidths.Bottom := TwipsToPoints(AParam);
        alLeft: FActiveTableCell.RequiredBorderWidths.Left := TwipsToPoints(AParam);
        alRight: FActiveTableCell.RequiredBorderWidths.Right := TwipsToPoints(AParam);
        alTop: FActiveTableCell.RequiredBorderWidths.Top := TwipsToPoints(AParam);
      end;
    end;
    rptbBorderNone:
    begin
      case FActiveTableBorder of
        alBottom: FActiveTableCell.RequiredBorderWidths.Bottom := 0;
        alLeft: FActiveTableCell.RequiredBorderWidths.Left := 0;
        alRight: FActiveTableCell.RequiredBorderWidths.Right := 0;
        alTop: FActiveTableCell.RequiredBorderWidths.Top := 0;
      end;
    end;
    rptbBorderColor: FActiveTableCell.BlockStyle.BorderColor := FColorTable.GetColor(AParam - 1); // no support for different colors for different borders
    rptbBackColor: FActiveTableCell.BlockStyle.Brush.Color := FColorTable.GetColor(AParam - 1);
    rptbHorzMerge: FActiveTableCell.ColSpan := 0; // indicate for later fixup
    rptbVertMerge: FActiveTableCell.RowSpan := 0; // indicate for later fixup
    rptbCellPaddBottom: FActiveTableCell.BlockStyle.BottomPadding := TwipsToPoints(AParam);
    rptbCellPaddLeft: FActiveTableCell.BlockStyle.LeftPadding := TwipsToPoints(AParam);
    rptbCellPaddRight: FActiveTableCell.BlockStyle.RightPadding := TwipsToPoints(AParam);
    rptbCellPaddTop: FActiveTableCell.BlockStyle.TopPadding := TwipsToPoints(AParam);
    rptbCellWidth:
    begin
      FActiveTableCell.FixedWidth := True;
      FActiveTableCell.RequiredWidth := TwipsToPoints(AParam);
    end;
    rptbCellX:
    begin
      // this command comes as the last for current cell
      Value := FActiveTableCellXPos;
      FActiveTableCellXPos := TwipsToPoints(AParam);
      FActiveTableCell.RequiredWidth := FActiveTableCellXPos - Value;
      Inc(FActiveTableCol);
      if FActiveTableCol < FActiveTableRow.CellCount then
        FActiveTableCell := FActiveTableRow.Cells[FActiveTableCol]
      else
        FActiveTableCell := nil; // error in RTF, ignore next properties
    end;
  end;
end;

procedure TKMemoRTFReader.ReadTextFormatting(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
begin
  if FActiveState.Group in [rgNone, rgTextBox, rgFieldResult] then case TKMemoRTFTextProp(ACtrl) of
    rptPlain: FActiveState.TextStyle.Assign(FMemo.TextStyle);
    rptFontIndex: ApplyFont(FActiveState.TextStyle, AParam);
    rptBold:
    begin
      if AParam = 0 then
        FActiveState.TextStyle.Font.Style := FActiveState.TextStyle.Font.Style - [fsBold]
      else
        FActiveState.TextStyle.Font.Style := FActiveState.TextStyle.Font.Style + [fsBold];
    end;
    rptItalic:
    begin
      if AParam = 0 then
        FActiveState.TextStyle.Font.Style := FActiveState.TextStyle.Font.Style - [fsItalic]
      else
        FActiveState.TextStyle.Font.Style := FActiveState.TextStyle.Font.Style + [fsItalic];
    end;
    rptUnderline:
    begin
      if AParam = 0 then
        FActiveState.TextStyle.Font.Style := FActiveState.TextStyle.Font.Style - [fsUnderline]
      else
        FActiveState.TextStyle.Font.Style := FActiveState.TextStyle.Font.Style + [fsUnderline];
    end;
    rptStrikeout:
    begin
      if AParam = 0 then
        FActiveState.TextStyle.Font.Style := FActiveState.TextStyle.Font.Style - [fsStrikeout]
      else
        FActiveState.TextStyle.Font.Style := FActiveState.TextStyle.Font.Style + [fsStrikeout];
    end;
    rptCaps: FActiveState.TextStyle.Capitals := tcaNormal;
    rptSmallCaps: FActiveState.TextStyle.Capitals := tcaSmall;
    rptFontSize: FActiveState.TextStyle.Font.Size := DivUp(AParam, 2);
    rptForeColor: FActiveState.TextStyle.Font.Color := FColorTable.GetColor(AParam - 1);
    rptBackColor: FActiveState.TextStyle.Brush.Color := FColorTable.GetColor(AParam - 1);
    rptSubscript: FActiveState.TextStyle.ScriptPosition := tpoSubscript;
    rptSuperscript: FActiveState.TextStyle.ScriptPosition := tpoSuperscript;
  end;
end;

procedure TKMemoRTFReader.ReadUnknownGroup(ACtrl: Integer; var AText: AnsiString; AParam: Integer);
begin
  if not (FActiveState.Group in [rgInfo, rgHeader, rgFooter]) then case TKMemoRTFUnknownProp(ACtrl) of
    rpuUnknownSym: FActiveState.Group := rgUnknown;
    rpuNonShapePict: FActiveState.Group := rgUnknown; // we ignore this picture
  end;
  if FActiveState.Group = rgUnknown then case TKMemoRTFUnknownProp(ACtrl) of
    rpuFieldInst: FActiveState.Group := rgFieldInst; // field inside text
    rpuShapeInst: FActiveState.Group := rgShapeInst; // picture inside text
    rpuShapePict: FActiveState.Group := rgShapePict; // picture inside text
    rpuPageBackground: FActiveState.Group := rgPageBackground; // this is the page background, read it
    rpuPicProp: FActiveState.Group := rgPicProp; // non shape picture has some shape properties, read them
    rpuListTable: FActiveState.Group := rgListTable;
    rpuListOverrideTable: FActiveState.Group := rgListOverrideTable;
  end;
end;

{ TKMemoRTFWriter }

constructor TKMemoRTFWriter.Create(AMemo: TKCustomMemo);
begin
  FMemo := AMemo;
  FColorTable := TKMemoRTFColorTable.Create;
  FFontTable := TKMemoRTFFontTable.Create;
  FListTable := TKMemoRTFListTable.Create;
  FSelectedOnly := False;
  FStream := nil;
end;

destructor TKMemoRTFWriter.Destroy;
begin
  FColorTable.Free;
  FFontTable.Free;
  FListTable.Free;
  inherited;
end;

function TKMemoRTFWriter.BoolToParam(AValue: Boolean): AnsiString;
begin
  Result := AnsiString(IntToStr(Integer(AValue)));
end;

function TKMemoRTFWriter.CanSave(AItem: TKMemoBlock): Boolean;
begin
  Result := not FSelectedOnly or (AItem <> nil) and (AItem.SelLength > 0);
end;

function TKMemoRTFWriter.ColorToHighlightCode(AValue: TColor): Integer;
begin
  // we save highlight color as reference to color table, is it correct?
  case AValue of
    clBlack: Result := 1;
    clBlue: Result := 2;
    clAqua: Result := 3; // cyan
    clLime: Result := 4; // green
    clFuchsia: Result := 5; // magenta
    clRed: Result := 6;
    clYellow: Result := 7;
    clNavy: Result := 9;
    clTeal: Result := 10; // dark cyan
    clGreen: Result := 11; // dark green
    clPurple: Result := 12; // dark magenta
    clMaroon: Result := 13; // dark red
    clOlive: Result := 14; // dark yellow
    clGray: Result := 15; // dark gray
    clSilver: Result := 16; // light gray
  else
    Result := 0;
  end;
end;

function TKMemoRTFWriter.ColorToParam(AValue: TColor): AnsiString;
begin
  Result := AnsiString(IntToStr(ColorToColorRec(Avalue).Value));
end;

function TKMemoRTFWriter.EMUToParam(AValue: Integer): AnsiString;
begin
  Result := AnsiString(IntToStr(PointsToEMU(AValue)));
end;

procedure TKMemoRTFWriter.FillColorTable(ABlocks: TKMemoBlocks);
var
  I: Integer;
  Item: TKmemoBlock;
begin
  if ABlocks <> nil then
  begin
    for I := 0 to ABlocks.Count - 1 do
    begin
      Item := Ablocks[I];
      if CanSave(Item) then
      begin
        if Item is TKMemoTextBlock then
        begin
          FColorTable.AddColor(TKmemoTextBlock(Item).TextStyle.Brush.Color);
          FColorTable.AddColor(TKmemoTextBlock(Item).TextStyle.Font.Color);
          if Item is TKMemoParagraph then
          begin
            FColorTable.AddColor(TKMemoParagraph(Item).ParaStyle.Brush.Color);
            FColorTable.AddColor(TKMemoParagraph(Item).ParaStyle.BorderColor);
          end;
        end
        else if Item is TKMemoContainer then
        begin
          FColorTable.AddColor(TKmemoContainer(Item).BlockStyle.Brush.Color);
          FColorTable.AddColor(TKmemoContainer(Item).BlockStyle.BorderColor);
          if Item is TKMemoTable then
          begin
            FColorTable.AddColor(TKmemoTable(Item).CellStyle.Brush.Color);
            FColorTable.AddColor(TKmemoTable(Item).CellStyle.BorderColor);
          end;
          FillColorTable(TKmemoContainer(Item).Blocks);
        end;
      end;
    end;
  end;
end;

procedure TKMemoRTFWriter.FillFontTable(ABlocks: TKMemoBlocks);
var
  I: Integer;
  Item: TKmemoBlock;
begin
  if ABlocks <> nil then
  begin
    for I := 0 to ABlocks.Count - 1 do
    begin
      Item := Ablocks[I];
      if CanSave(Item) then
      begin
        if Item is TKMemoTextBlock then
          FFontTable.AddFont(TKmemoTextBlock(Item).TextStyle.Font)
        else if Item is TKmemoContainer then
          FillFontTable(TKmemoContainer(Item).Blocks);
      end;
    end;
  end;
end;

function TKMemoRTFWriter.PointsToEMU(AValue: Integer): Integer;
begin
  Result := AValue * 12700;
end;

procedure TKMemoRTFWriter.SaveToFile(const AFileName: TKString; ASelectedOnly: Boolean);
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    SaveToStream(Stream, ASelectedOnly);
    Stream.SaveToFile(AFileName);
  finally
    Stream.Free;
  end;
end;

procedure TKMemoRTFWriter.SaveToStream(AStream: TStream; ASelectedOnly: Boolean);
var
  ActiveBlocks, Blocks1, Blocks2, SavedBlocks1: TKMemoBlocks;
  LocalIndex: Integer;
begin
  try
    FStream := AStream;
    FSelectedOnly := ASelectedOnly;
    if FSelectedOnly then
    begin
      // find common parent blocks for the selection and use this instead of main blocks
      ActiveBlocks := FMemo.Blocks;
      Blocks1 := ActiveBlocks.IndexToBlocks(FMemo.SelStart, LocalIndex);
      Blocks2 := ActiveBlocks.IndexToBlocks(FMemo.SelEnd, LocalIndex);
      SavedBlocks1 := Blocks1;
      while Blocks1 <> Blocks2 do
      begin
        Blocks1 := Blocks1.ParentBlocks;
        if Blocks1 = nil then
        begin
          Blocks2 := Blocks2.ParentBlocks;
          if Blocks2 <> nil then
            Blocks1 := SavedBlocks1;
        end;
      end;
      ActiveBlocks := Blocks1;
    end else
      ActiveBlocks := FMemo.Blocks;
    ActiveBlocks.ConcatEqualBlocks;
    FCodePage := SystemCodepage;
    WriteGroupBegin;
    try
      WriteHeader;
      WriteBackground;
      WriteBody(ActiveBlocks, False);
    finally
      WriteGroupEnd;
    end;
  except
    KFunctions.Error(sErrMemoSaveToRTF);
  end;
end;

procedure TKMemoRTFWriter.WriteBackground;
var
  Shape: TKMemoRTFShape;
begin
  if not FSelectedOnly and (FMemo <> nil) and ((FMemo.Colors.BkGnd <> clWindow) or (FMemo.BackgroundImage.Graphic <> nil)) then
  begin
    WriteCtrlParam('viewbksp', 1);
    WriteGroupBegin;
    try
      WriteUnknownGroup;
      WriteCtrl('background');
      WriteSpace;
      Shape := TKmemoRTFShape.Create;
      try
        Shape.ContentType := sctRectangle;
        Shape.FitToShape := False;
        Shape.FitToText := False;
        Shape.Style.WrapMode := wrUnknown;
        Shape.Style.Brush.Color := FMemo.Colors.BkGnd;
        Shape.Style.FillBlip := FMemo.BackgroundImage.Graphic;
        Shape.Background := True;
        Shape.HorzPosCode := 0;
        Shape.VertPosCode := 0;
        WriteShape(Shape, False);
      finally
        Shape.Free;
      end;
    finally
      WriteGroupEnd;
    end;
  end;
end;

procedure TKMemoRTFWriter.WriteBody(ABlocks: TKMemoBlocks; AInsideTable: Boolean);
var
  I: Integer;
  Item: TKMemoBlock;
  PA: TKMemoParagraph;
  IsParagraph: Boolean;
  URL: TKString;
begin
  if ABlocks <> nil then
  begin
    URL := '';
    IsParagraph := False;
    for I := 0 to ABlocks.Count - 1 do
    begin
      Item := ABlocks[I];
      if CanSave(Item) then
      begin
        if Item is TKMemoHyperlink then
        begin
          if URL <> TKMemoHyperlink(Item).URL then
          begin
            if URL <> '' then
              WriteHyperlinkEnd;
            WriteHyperlinkBegin(TKMemoHyperlink(Item));
            URL := TKMemoHyperlink(Item).URL;
          end;
          WriteTextBlock(TKMemoTextBlock(Item), FSelectedOnly)
        end else
        begin
          if URL <> '' then
          begin
            WriteHyperlinkEnd;
            URL := '';
          end;
          if IsParagraph then
          begin
            PA := ABlocks.GetNearestParagraph(I);
            if PA <> nil then
              WriteListText(PA.NumberBlock);
            IsParagraph := False;
          end;
          if Item is TKMemoParagraph then
          begin
            if not AInsideTable or (I < ABlocks.Count - 1) then
              WriteParagraph(TKMemoParagraph(Item), AInsideTable);
            IsParagraph := True;
          end
          else if Item is TKMemoTextBlock then
            WriteTextBlock(TKMemoTextBlock(Item), FSelectedOnly)
          else if Item is TKMemoImageBlock then
            WriteImageBlock(TKMemoImageBlock(Item), AInsideTable)
          else if Item is TKMemoContainer then
          begin
            if Item is TKMemoTable then
              WriteTable(TKMemoTable(Item))
            else if Item.Position <> mbpText then
              WriteContainer(TKMemoContainer(Item), AInsideTable)
            else
              WriteBody(TKMemoContainer(Item).Blocks, AInsideTable) // just save the contents
          end;
        end;
      end;
    end;
    if URL <> '' then
      WriteHyperlinkEnd;
  end;
end;

procedure TKMemoRTFWriter.WriteColorTable;
var
  I: Integer;
  ColorRec: TKColorRec;
begin
  WriteGroupBegin;
  try
    WriteCtrl('colortbl');
    WriteSemicolon;
    for I := 0 to FColorTable.Count - 1 do
    begin
      ColorRec := FColorTable[I].ColorRec;
      WriteCtrlParam('red', ColorRec.R);
      WriteCtrlParam('green', ColorRec.G);
      WriteCtrlParam('blue', ColorRec.B);
      WriteSemiColon;
    end;
  finally
    WriteGroupEnd;
  end;
end;

procedure TKMemoRTFWriter.WriteContainer(ABlock: TKMemoContainer;
  AInsideTable: Boolean);
var
  Shape: TKMemoRTFShape;
begin
  // write generic container - write as RTF text box
  Shape := TKMemoRTFShape.Create;
  try
    Shape.ContentType := sctTextBox;
    Shape.Item := ABlock;
    Shape.ContentPosition.Left := ABlock.LeftOffset;
    Shape.ContentPosition.Top := ABlock.TopOffset;
    Shape.ContentPosition.Right := ABlock.LeftOffset + ABlock.RequiredWidth;
    Shape.ContentPosition.Bottom := ABlock.TopOffset + ABlock.RequiredHeight;
    Shape.FitToText := not ABlock.FixedHeight;
    Shape.HorzPosCode := 2; // position by column, we don't support any other
    Shape.VertPosCode := 2; // position by paragraph, we don't support any other
    Shape.Style.Assign(ABlock.BlockStyle);
    WriteShape(Shape, AInsideTable);
  finally
    Shape.Free;
  end;
end;

procedure TKMemoRTFWriter.WriteCtrl(const ACtrl: AnsiString);
begin
  WriteString('\' + ACtrl);
end;

procedure TKMemoRTFWriter.WriteCtrlParam(const ACtrl: AnsiString;
  AParam: Integer);
begin
  WriteString(AnsiString(Format('\%s%d', [ACtrl, AParam])));
end;

procedure TKMemoRTFWriter.WriteFontTable;
var
  I, Pitch, Charset: Integer;
begin
  WriteGroupBegin;
  try
    WriteCtrl('fonttbl');
    for I := 0 to FFontTable.Count - 1 do
    begin
      WriteGroupBegin;
      try
        WriteCtrlParam('f', I);
        Charset := FFontTable[I].Font.Charset;
       {if Charset = 0 then
          Charset := CPToCharset(FCodePage); // don't override charset, it is still important for certain fonts!}
        WriteCtrlParam('fcharset', Charset);
        case FFontTable[I].Font.Pitch of
          fpFixed: Pitch := 1;
          fpVariable: Pitch := 2;
        else
          Pitch := 0;
        end;
        WriteCtrlParam('fprq', Pitch);
        WriteSpace;
        WriteString(AnsiString(FFontTable[I].Font.Name));
        WriteSemiColon;
      finally
        WriteGroupEnd;
      end;
    end;
  finally
    WriteGroupEnd;
  end;
end;

procedure TKMemoRTFWriter.WriteGroupBegin;
begin
  WriteString('{');
end;

procedure TKMemoRTFWriter.WriteGroupEnd;
begin
  WriteString('}');
end;

procedure TKMemoRTFWriter.WriteHeader;
begin
  FFontTable.AddFont(FMemo.TextStyle.Font);
  FillFontTable(FMemo.Blocks);
  FillColorTable(FMemo.Blocks);
  FListTable.AssignFromListTable(FMemo.ListTable, FFontTable);
  WriteCtrl('rtf1');
  WriteCtrl('ansi');
  WriteCtrlParam('ansicpg', FCodePage);
  if FFontTable.Count > 0 then
    WriteCtrlParam('deff', 0);
  WriteCtrlParam('uc', 1);
  WriteFontTable;
  WriteColorTable;
  WriteListTable;
end;

procedure TKMemoRTFWriter.WriteHyperlinkBegin(AItem: TKMemoHyperlink);
begin
  WriteGroupBegin;
  WriteCtrl('field');
  WriteGroupBegin;
  try
    WriteUnknownGroup;
    WriteCtrl('fldinst');
    WriteSpace;
    WriteString(cRTFHyperlink);
    WriteSpace;
    WriteUnicodeString(TKMemoHyperLink(AItem).URL);
  finally
    WriteGroupEnd;
  end;
  WriteGroupBegin;
  WriteCtrl('fldrslt');
end;

procedure TKMemoRTFWriter.WriteHyperlinkEnd;
begin
  WriteGroupEnd;
  WriteGroupEnd;
end;

procedure TKMemoRTFWriter.WriteImage(AItem: TKmemoImageBlock);
begin
  WriteCtrlParam('picw', PointsToTwips(AItem.OriginalWidth));
  WriteCtrlParam('pich', PointsToTwips(AItem.OriginalHeight));
  WriteCtrlParam('picscalex', MulDiv(AItem.ScaleWidth, 100, AItem.OriginalWidth));
  WriteCtrlParam('picscaley', MulDiv(AItem.ScaleHeight, 100, AItem.OriginalHeight));
  WriteCtrlParam('picwgoal', PointsToTwips(AItem.ScaleWidth));
  WriteCtrlParam('pichgoal', PointsToTwips(AItem.ScaleHeight));
  WriteCtrlParam('piccropb', PointsToTwips(AItem.Crop.Bottom));
  WriteCtrlParam('piccropl', PointsToTwips(AItem.Crop.Left));
  WriteCtrlParam('piccropr', PointsToTwips(AItem.Crop.Right));
  WriteCtrlParam('piccropt', PointsToTwips(AItem.Crop.Top));
  WritePicture(AItem.Image.Graphic);
end;

procedure TKMemoRTFWriter.WriteImageBlock(AItem: TKmemoImageBlock; AInsideTable: Boolean);
var
  Shape: TKMemoRTFShape;
begin
  // write generic container - write as RTF text box
  Shape := TKMemoRTFShape.Create;
  try
    Shape.ContentType := sctImage;
    Shape.FitToShape := False;
    Shape.FitToText := False;
    Shape.Style.Assign(AItem.ImageStyle);
    if AItem.Position = mbpText then
    begin
      WriteGroupBegin;
      try
        WriteUnknownGroup;
        WriteCtrl('shppict');
        WriteGroupBegin;
        try
          WriteCtrl('pict');
          WriteGroupBegin;
          try
            WriteUnknownGroup;
            WriteCtrl('picprop');
            WriteShapeProperties(Shape);
          finally
            WriteGroupEnd;
          end;
          WriteImage(AItem);
        finally
          WriteGroupEnd;
        end;
      finally
        WriteGroupEnd;
      end;
    end else
    begin
      Shape.Item := AItem;
      Shape.ContentPosition.Left := AItem.LeftOffset;
      Shape.ContentPosition.Top := AItem.TopOffset;
      Shape.ContentPosition.Right := AItem.LeftOffset + AItem.ScaleWidth + AItem.ImageStyle.LeftPadding + AItem.ImageStyle.RightPadding;
      Shape.ContentPosition.Bottom := AItem.TopOffset + AItem.ScaleHeight + AItem.ImageStyle.TopPadding + AItem.ImageStyle.BottomPadding;
      Shape.HorzPosCode := 2; // we don't support any other
      Shape.VertPosCode := 2; // we don't support any other
      WriteShape(Shape, AInsideTable);
    end;
  finally
    Shape.Free;
  end;
end;

procedure TKMemoRTFWriter.WriteListTable;
var
  I, J, K, Len: Integer;
  Item: TKMemoRTFList;
  Level: TKMemoRTFListLevel;
  NFItem: TKMemoNumberingFormatItem;
  OverrideItem: TKMemoDictionaryItem;
begin
  // first write list table
  WriteGroupBegin;
  try
    WriteUnknownGroup;
    WriteCtrl('listtable');
    for I := 0 to FListTable.Count - 1 do
    begin
      Item := FListTable[I];
      WriteGroupBegin;
      try
        WriteCtrl('list');
        for J := 0 to Item.Levels.Count - 1 do
        begin
          Level := Item.Levels[J];
          WriteGroupBegin;
          try
            WriteCtrl('listlevel');
            WriteCtrlParam('levelnfc', Level.NumberType);
            WriteCtrlParam('levelstartat', Level.StartAt);
            WriteGroupBegin;
            try
              WriteCtrl('leveltext');
              for K := 0 to Level.NumberingFormat.Count - 1 do
              begin
                NFItem := Level.NumberingFormat[K];
                if (NFItem.Level >= 0) and (NFItem.Text = '') then
                  WriteString(AnsiString(Format('\''%.2x', [NFItem.Level])))
                else
                  WriteUnicodeString(NFItem.Text)
              end;
              WriteSemiColon;
            finally
              WriteGroupEnd;
            end;
            WriteGroupBegin;
            try
              WriteCtrl('levelnumbers');
              Len := 1;
              for K := 1 to Level.NumberingFormat.Count - 1 do
              begin
                NFItem := Level.NumberingFormat[K];
                if (NFItem.Level >= 0) and (NFItem.Text = '') then
                begin
                  WriteString(AnsiString(Format('\''%.2x', [Len])));
                  Inc(Len);
                end else
                  Inc(Len, StringLength(NFItem.Text));
              end;
              WriteSemiColon;
            finally
              WriteGroupEnd;
            end;
            if Level.FontIndex >= 0 then
              WriteCtrlParam('f', Level.FontIndex);
            WriteCtrlParam('fi', PointsToTwips(Level.FirstIndent));
            WriteCtrlParam('li', PointsToTwips(Level.LeftIndent));
          finally
            WriteGroupEnd;
          end;
        end;
        WriteCtrlParam('listid', Item.ID);
      finally
        WriteGroupEnd;
      end;
    end;
  finally
    WriteGroupEnd;
  end;
  // next write list override table
  WriteGroupBegin;
  try
    WriteUnknownGroup;
    WriteCtrl('listoverridetable');
    for I := 0 to FListTable.Overrides.Count - 1 do
    begin
      OverrideItem := FListTable.Overrides[I];
      WriteGroupBegin;
      try
        WriteCtrl('listoverride');
        WriteCtrlParam('listid', OverrideItem.Value);
        WriteCtrlParam('ls', OverrideItem.Index);
      finally
        WriteGroupEnd;
      end;
    end;
  finally
    WriteGroupEnd;
  end;
end;

procedure TKMemoRTFWriter.WriteListText(ANumberBlock: TKMemoTextBlock);
begin
  if ANumberBlock <> nil then
  begin
    WriteGroupBegin;
    try
      WriteCtrl('listtext');
      WriteTextBlock(ANumberBlock, False);
    finally
      WriteGroupEnd;
    end;
  end;
end;

procedure TKMemoRTFWriter.WriteParagraph(AItem: TKMemoParagraph; AInsideTable: Boolean);
begin
  WriteGroupBegin;
  try
    WriteParaStyle(AItem.ParaStyle);
    WriteTextStyle(AItem.TextStyle);
    if AinsideTable then
      WriteCtrl('intbl');
    WriteCtrl('par');
  finally
    WriteGroupEnd;
  end;
end;

procedure TKMemoRTFWriter.WriteParaStyle(AParaStyle: TKMemoParaStyle);
begin
  WriteCtrl('pard'); // always store complete paragraph properties
  if AParaStyle.FirstIndent <> 0 then
    WriteCtrlParam('fi', PointsToTwips(AParaStyle.FirstIndent));
  if AParaStyle.LeftPadding <> 0 then
    WriteCtrlParam('li', PointsToTwips(AParaStyle.LeftPadding));
  if AParaStyle.RightPadding <> 0 then
    WriteCtrlParam('ri', PointsToTwips(AParaStyle.RightPadding));
  if AParaStyle.TopPadding <> 0 then
    WriteCtrlParam('sb', PointsToTwips(AParaStyle.TopPadding));
  if AParaStyle.BottomPadding <> 0 then
    WriteCtrlParam('sa', PointsToTwips(AParaStyle.BottomPadding));
  case AParaStyle.HAlign of
    halLeft: WriteCtrl('ql');
    halCenter: WriteCtrl('qc');
    halRight: WriteCtrl('qr');
    halJustify: WriteCtrl('qj');
  end;
  if AParaStyle.Brush.Style <> bsClear then
    WriteCtrlParam('cbpat', FColorTable.GetIndex(AParaStyle.Brush.Color) + 1);
  if not AParaStyle.WordWrap then
    WriteCtrl('nowwrap');
  if AParaStyle.BorderWidths.NonZero then
  begin
    if AParaStyle.BorderWidths.Bottom > 0 then
    begin
      WriteCtrl('brdrb');
      WriteCtrlParam('brdrw', PointsToTwips(AParaStyle.BorderWidths.Bottom))
    end;
    if AParaStyle.BorderWidths.Left > 0 then
    begin
      WriteCtrl('brdrl');
      WriteCtrlParam('brdrw', PointsToTwips(AParaStyle.BorderWidths.Left))
    end;
    if AParaStyle.BorderWidths.Right > 0 then
    begin
      WriteCtrl('brdrr');
      WriteCtrlParam('brdrw', PointsToTwips(AParaStyle.BorderWidths.Right))
    end;
    if AParaStyle.BorderWidths.Top > 0 then
    begin
      WriteCtrl('brdrt');
      WriteCtrlParam('brdrw', PointsToTwips(AParaStyle.BorderWidths.Top))
    end;
  end else
  begin
    if AParaStyle.BorderWidth > 0 then
    begin
      WriteCtrl('box');
      WriteCtrlParam('brdrw', PointsToTwips(AParaStyle.BorderWidth))
    end;
    if AParaStyle.BorderRadius > 0 then
      WriteCtrlParam('brdrradius', PointsToTwips(AParaStyle.BorderRadius))
  end;
  if AParaStyle.BorderColor <> clNone then
    WriteCtrlParam('brdrcf', FColorTable.GetIndex(AParaStyle.BorderColor) + 1);
  if AParaStyle.LineSpacingValue <> 0 then
  begin
    if AParaStyle.LineSpacingMode = lsmValue then
    begin
      WriteCtrlParam('sl', PointsToTwips(AParaStyle.LineSpacingValue));
      WriteCtrlParam('slmult', 0)
    end else
    begin
      WriteCtrlParam('sl', Round(AParaStyle.LineSpacingFactor * 240));
      WriteCtrlParam('slmult', 1)
    end;
  end;
  if AParaStyle.NumberingList <> cInvalidListID then
    WriteCtrlParam('ls', FListTable.FindByID(AParaStyle.NumberingList));
  if AParaStyle.NumberingListLevel >= 0 then
    WriteCtrlParam('ilvl', AParaStyle.NumberingListLevel);
  if AParaStyle.NumberStartAt > 0 then
    WriteCtrlParam('lsstartat', AParaStyle.NumberStartAt);
end;

procedure TKMemoRTFWriter.WritePicture(AImage: TGraphic);
var
  MS: TMemoryStream;
  S, ImgData: AnsiString;
begin
  if AImage <> nil then
  begin
    if AImage is TJPegImage then
      WriteCtrl('jpegblip')
  {$IFDEF USE_PNG_SUPPORT}
    else if AImage is TKPngImage then
      WriteCtrl('pngblip')
  {$ENDIF}
  {$IFDEF USE_WINAPI}
    else if AImage is TKMetafile then
    begin
      if TKMetafile(AImage).Enhanced then
        WriteCtrl('emfblip')
      else
        WriteCtrlParam('wmetafile', 8);
    end
  {$ENDIF}
    ;
    MS := TMemoryStream.Create;
    try
      AImage.SaveToStream(MS);
      MS.Seek(0, soFromBeginning);
      SetLength(S, MS.Size);
      MS.Read(S[1], MS.Size);
    finally
      MS.Free;
    end;
    WriteSpace;
    ImgData := BinaryToDigits(S);
    WriteString(ImgData);
  end;
end;

procedure TKMemoRTFWriter.WriteSemiColon;
begin
  WriteString(';');
end;

procedure TKMemoRTFWriter.WriteShape(AShape: TKMemoRTFShape; AInsideTable: Boolean);
begin
  WriteGroupBegin;
  try
    WriteCtrl('shp');
    WriteGroupBegin;
    try
      WriteUnknownGroup;
      WriteCtrl('shpinst');
      WriteCtrlParam('shpbottom', PointsToTwips(Ashape.ContentPosition.Bottom));
      WriteCtrlParam('shpleft', PointsToTwips(Ashape.ContentPosition.Left));
      WriteCtrlParam('shpright', PointsToTwips(Ashape.ContentPosition.Right));
      WriteCtrlParam('shptop', PointsToTwips(Ashape.ContentPosition.Top));
      case AShape.HorzPosCode of
        1: WriteCtrl('shpbxpage');
        2: WriteCtrl('shpbxcolumn');
      else
        WriteCtrl('shpbxmargin');
      end;
      case AShape.VertPosCode of
        1: WriteCtrl('shpbypage');
        2: WriteCtrl('shpbypara');
      else
        WriteCtrl('shpbymargin');
      end;
      WriteCtrlParam('shpfhdr', 0);
      WriteCtrlParam('shpwr', AShape.Wrap);
      WriteCtrlParam('shpwrk', AShape.WrapSide);
      WriteShapeProperties(AShape);
      case AShape.ContentType of
        sctImage: if AShape.Item <> nil then
        begin
          WriteGroupBegin;
          try
            WriteCtrl('sp');
            WriteShapePropName('pib');
            WriteGroupBegin;
            try
              WriteCtrl('sv');
              WriteSpace;
              WriteGroupBegin;
              try
                WriteCtrl('pict');
                WriteImage(AShape.Item as TKMemoImageBlock);
              finally
                WriteGroupEnd;
              end;
            finally
              WriteGroupEnd;
            end;
          finally
            WriteGroupEnd;
          end;
        end;
        sctRectangle: if AShape.Style.FillBlip <> nil then
        begin
          WriteShapeProp('fillType', '3');
          WriteGroupBegin;
          try
            WriteCtrl('sp');
            WriteShapePropName('fillBlip');
            WriteGroupBegin;
            try
              WriteCtrl('sv');
              WriteSpace;
              WriteGroupBegin;
              try
                WriteCtrl('pict');
                WritePicture(AShape.Style.FillBlip);
              finally
                WriteGroupEnd;
              end;
            finally
              WriteGroupEnd;
            end;
          finally
            WriteGroupEnd;
          end;
        end;
        sctTextbox: if AShape.Item <> nil then
        begin
          WriteGroupBegin;
          try
            WriteCtrl('shptxt');
            WriteBody((AShape.Item as TKMemoContainer).Blocks, AInsideTable);
          finally
            WriteGroupEnd;
          end;
        end;
      end;
    finally
      WriteGroupEnd;
    end;
  finally
    WriteGroupEnd;
  end;
end;

procedure TKMemoRTFWriter.WriteShapeProp(const APropName,
  APropValue: AnsiString);
begin
  WriteGroupBegin;
  try
    WriteCtrl('sp');
    WriteShapePropName(APropName);
    WriteShapePropValue(APropValue);
  finally
    WriteGroupEnd;
  end;
end;

procedure TKMemoRTFWriter.WriteShapeProperties(AShape: TKMemoRTFShape);
var
  B: Boolean;
begin
  B := AShape.Style.Brush.Style <> bsClear;
  case AShape.ContentType of
    sctImage: WriteShapeProp('shapeType', '75');
    sctRectangle: WriteShapeProp('shapeType', '1');
    sctTextbox: WriteShapeProp('shapeType', '202');
  end;
  if AShape.FitToShape then
    WriteShapeProp('fFitTextToShape', BoolToParam(True));
  if AShape.FitToText then
    WriteShapeProp('fFitShapeToText', BoolToParam(True));
  WriteShapeProp('fFilled', BoolToParam(B));
  if B then
    WriteShapeProp('fillColor', ColorToParam(AShape.Style.Brush.Color));
  B := AShape.Style.BorderWidth > 0;
  WriteShapeProp('fLine', BoolToParam(B));
  if B then
  begin
    WriteShapeProp('lineColor', ColorToParam(AShape.Style.BorderColor));
    WriteShapeProp('lineWidth', EMUToParam(AShape.Style.BorderWidth));
  end;
  if AShape.Background then
    WriteShapeProp('fBackground', BoolToParam(True));
end;

procedure TKMemoRTFWriter.WriteShapePropName(const APropName: AnsiString);
begin
  WriteGroupBegin;
  try
    WriteCtrl('sn');
    WriteSpace;
    WriteString(APropName);
  finally
    WriteGroupEnd;
  end;
end;

procedure TKMemoRTFWriter.WriteShapePropValue(const APropValue: AnsiString);
begin
  WriteGroupBegin;
  try
    WriteCtrl('sv');
    WriteSpace;
    WriteString(APropValue);
  finally
    WriteGroupEnd;
  end;
end;

procedure TKMemoRTFWriter.WriteSpace;
begin
  WriteString(' ');
end;

procedure TKMemoRTFWriter.WriteString(const AText: AnsiString);
begin
  FStream.Write(AText[1], Length(AText));
end;

procedure TKMemoRTFWriter.WriteTable(AItem: TKMemoTable);
var
  I, J, SavedRow, SavedRowCount: Integer;
  Row: TKMemoTableRow;
  Cell: TKMemoTableCell;
begin
  SavedRowCount := 0;
  for I := 0 to AItem.RowCount - 1 do
  begin
    Row := AItem.Rows[I];
    if CanSave(Row) then
      Inc(SavedRowCount);
  end;
  SavedRow := 0;
  for I := 0 to AItem.RowCount - 1 do
  begin
    Row := AItem.Rows[I];
    if CanSave(Row) then
    begin
      WriteCtrl('trowd');
      WriteTableRowProperties(AItem, I, SavedRow);
      for J := 0 to Row.CellCount - 1 do
      begin
        Cell := Row.Cells[J];
        if Cell.ColSpan >= 0 then
        begin
          WriteParaStyle(Cell.ParaStyle);
          if (Cell.Blocks.Count > 0) and ((Cell.Blocks.Count > 1) or not(Cell.Blocks[0] is TKmemoParagraph)) then
          begin
            WriteGroupBegin;
            try
              WriteBody(Cell.Blocks, True);
            finally
              WriteGroupEnd;
            end;
          end;
          WriteCtrl('cell');
        end;
      end;
      WriteGroupBegin;
      try
        WriteCtrl('trowd');
        WriteTableRowProperties(AItem, I, SavedRow);
        if SavedRow = SavedRowCount - 1 then
          WriteCtrl('lastrow');
        WriteCtrl('row');
      finally
        WriteGroupEnd;
      end;
      Inc(SavedRow);
    end;
  end;
end;

procedure TKMemoRTFWriter.WriteTableRowProperties(ATable: TKMemoTable; ARowIndex, ASavedRowIndex: Integer);

  procedure WriteBorderWidth(AWidth: Integer);
  begin
    if AWidth <> 0 then
    begin
      WriteCtrl('brdrs');
      WriteCtrlParam('brdrw', PointsToTwips(AWidth))
    end else
      WriteCtrl('brdrnone');
  end;

var
  Cell: TKMemoTableCell;
  Row: TKMemoTableRow;
  I, W, XPos: Integer;
  RowPadd: TRect;
begin
  WriteCtrlParam('irow', ASavedRowIndex);
  Xpos := 0;
  Row := ATable.Rows[ARowIndex];
  RowPadd := CreateEmptyRect;
  for I := 0 to Row.CellCount - 1 do
  begin
    Cell := Row.Cells[I];
    RowPadd.Bottom := Max(RowPadd.Bottom, Cell.BlockStyle.BottomPadding);
    RowPadd.Left := Max(RowPadd.Left, Cell.BlockStyle.LeftPadding);
    RowPadd.Right := Max(RowPadd.Right, Cell.BlockStyle.RightPadding);
    RowPadd.Top := Max(RowPadd.Top, Cell.BlockStyle.TopPadding);
  end;
  WriteCtrlParam('trpaddb', PointsToTwips(RowPadd.Bottom));
  WriteCtrlParam('trpaddl', PointsToTwips(RowPadd.Left));
  WriteCtrlParam('trpaddr', PointsToTwips(RowPadd.Right));
  WriteCtrlParam('trpaddt', PointsToTwips(RowPadd.Top));
  for I := 0 to Row.CellCount - 1 do
  begin
    Cell := Row.Cells[I];
    if Cell.ColSpan >= 0 then
    begin
      if Cell.BlockStyle.BottomPadding <> RowPadd.Bottom then
        WriteCtrlParam('clpadb', PointsToTwips(RowPadd.Bottom));
      if Cell.BlockStyle.LeftPadding <> RowPadd.Left then
        WriteCtrlParam('clpadl', PointsToTwips(RowPadd.Left));
      if Cell.BlockStyle.RightPadding <> RowPadd.Right then
        WriteCtrlParam('clpadr', PointsToTwips(RowPadd.Right));
      if Cell.BlockStyle.TopPadding <> RowPadd.Top then
        WriteCtrlParam('clpadt', PointsToTwips(RowPadd.Top));
      if Cell.RowSpan > 1 then
        WriteCtrl('clvmgf')
      else if Cell.RowSpan <= 0 then
        WriteCtrl('clvmrg');
      WriteCtrl('clbrdrb');
      WriteBorderWidth(Cell.RequiredBorderWidths.Bottom);
      WriteCtrlParam('brdrcf', FColorTable.GetIndex(Cell.BlockStyle.BorderColor) + 1);
      WriteCtrl('clbrdrl');
      WriteBorderWidth(Cell.RequiredBorderWidths.Left);
      WriteCtrlParam('brdrcf', FColorTable.GetIndex(Cell.BlockStyle.BorderColor) + 1);
      WriteCtrl('clbrdrr');
      WriteBorderWidth(Cell.RequiredBorderWidths.Right);
      WriteCtrlParam('brdrcf', FColorTable.GetIndex(Cell.BlockStyle.BorderColor) + 1);
      WriteCtrl('clbrdrt');
      WriteBorderWidth(Cell.RequiredBorderWidths.Top);
      WriteCtrlParam('brdrcf', FColorTable.GetIndex(Cell.BlockStyle.BorderColor) + 1);
      if Cell.BlockStyle.Brush.Style <> bsClear then
        WriteCtrlParam('clcbpat', FColorTable.GetIndex(Cell.BlockStyle.Brush.Color) + 1);
      W := Max(ATable.CalcTotalCellWidth(I, ARowIndex), 5);
      WriteCtrlParam('clwWidth', PointsToTwips(W));
      Inc(Xpos, W);
      WriteCtrlParam('cellx', PointsToTwips(XPos));
    end else
    asm
      nop // debug line
    end;
  end;
end;

procedure TKMemoRTFWriter.WriteTextBlock(AItem: TKMemoTextBlock; ASelectedOnly: Boolean);
var
  S: TKString;
begin
  WriteGroupBegin;
  try
    if ASelectedOnly then
      S := AItem.SelText
    else
      S := AItem.Text;
    WriteTextStyle(AItem.TextStyle);
    WriteSpace;
    WriteUnicodeString(S);
  finally
    WriteGroupEnd;
  end;
end;

procedure TKMemoRTFWriter.WriteTextStyle(ATextStyle: TKMemoTextStyle);
begin
  WriteCtrlParam('f', FFontTable.GetIndex(ATextStyle.Font));
  if fsBold in ATextStyle.Font.Style then
    WriteCtrl('b');
  if fsItalic in ATextStyle.Font.Style then
    WriteCtrl('i');
  if fsUnderline in ATextStyle.Font.Style then
    WriteCtrl('ul');
  if fsStrikeout in ATextStyle.Font.Style then
    WriteCtrl('strike');
  case ATextStyle.Capitals of
    tcaNormal: WriteCtrl('caps');
    tcaSmall: WriteCtrl('scaps');
  end;
  WriteCtrlParam('fs', ATextStyle.Font.Size * 2);
  if ATextStyle.Font.Color <> clNone then
    WriteCtrlParam('cf', FColorTable.GetIndex(ATextStyle.Font.Color) + 1);
  if ATextStyle.Brush.Style <> bsClear then
    WriteCtrlParam('highlight', FColorTable.GetIndex(ATextStyle.Brush.Color) + 1);
  case ATextStyle.ScriptPosition of
    tpoSuperscript: WriteCtrl('super');
    tpoSubscript: WriteCtrl('sub');
  end;
end;

procedure TKMemoRTFWriter.WriteUnicodeString(const AText: TKString);
var
  I: Integer;
  UnicodeValue: SmallInt;
  WasAnsi: Boolean;
  S, Ansi: AnsiString;
  C: TKChar;
{$IFDEF FPC}
  CharLen: Integer;
{$ENDIF}
begin
  S := '';
  for I := 1 to StringLength(AText) do
  begin
  {$IFDEF FPC}
    C := UTF8Copy(AText, I, 1);
    if Length(C) = 1 then
  {$ELSE}
    C := AText[I];
    if Ord(C) < $80 then
  {$ENDIF}
    begin
      if C = #9 then
        S := AnsiString(Format('%s\tab ', [S]))
      else if (C = '\') or (C = '{') or (C = '}') then
        S := AnsiString(Format('%s\%s', [S, TKString(C)]))
      else
        S := S + AnsiString(C)
    end else
    begin
      WasAnsi := False;
      if FCodePage <> 0 then
      begin
        // first try Ansi codepage conversion for better backward compatibility
        Ansi := StringToAnsiString(C, FCodePage);
        if (Ansi <> '') and (Ansi <> #0) then
        begin
          S := AnsiString(Format('%s\''%.2x', [S, Ord(Ansi[1])]));
          WasAnsi := True;
        end;
      end;
      if not WasAnsi then
      begin
        // next store as Unicode character
        UnicodeValue := Ord(NativeUTFToUnicode(C));
        S := AnsiString(Format('%s\u%d\''3F', [S, UnicodeValue]));
      end;
    end;
  end;
  if S <> '' then
    WriteString(S);
end;

procedure TKMemoRTFWriter.WriteUnknownGroup;
begin
  WriteCtrl('*');
end;

end.


