{ Compiletime Graphics support }

{Date: 2010-05-19 08:24:27 +0200 (Wed, 19 May 2010)
New Revision: 227, max: 228 draw..polyline -->set TGraphic in top of Register List!
                   polyline... with array of TPoint doesn't work!?
Modified:
Source/uPSC_graphics.pas
Source/uPSR_graphics.pas
Source/uPSRuntime.pas
Source/x86.inc
Log:
0: New "TPicture" support; better FPC support (Thanks Raymond van Venetie)
1: metafile and Icon for 3.6 and reengineered TPicture
2: add graphic functions Graphics_Routines(Exec)
3: Canvas with 15 update methods and properties
4: penpos of canvas  Cl.AddTypeS('TPoint', 'record X, Y: LongInt; end;');  in uPSC_std!!
       more const of cmblackness
5: override more methods  constructor, destructor, assign metafile
6: bugfix picture.loadfromfile          brush bug

 }


unit uPSC_graphics;

{$I PascalScript.inc}
interface
uses
  uPSCompiler, uPSUtils;


procedure SIRegister_Graphics_TypesAndConsts(Cl: TPSPascalCompiler);

procedure SIRegisterTGraphic(CL: TPSPascalCompiler);
procedure SIRegisterTGRAPHICSOBJECT(Cl: TPSPascalCompiler);
procedure SIRegister_TMetafile(CL: TPSPascalCompiler);
procedure SIRegister_TIcon(CL: TPSPascalCompiler);

procedure SIRegisterTFont(Cl: TPSPascalCompiler);
procedure SIRegisterTPEN(Cl: TPSPascalCompiler);
procedure SIRegisterTBRUSH(Cl: TPSPascalCompiler);
procedure SIRegisterTCanvas(cl: TPSPascalCompiler);
procedure SIRegisterTBitmap(CL: TPSPascalCompiler; Streams: Boolean);
procedure SIRegisterTPicture(CL: TPSPascalCompiler);

procedure SIRegister_Graphics(Cl: TPSPascalCompiler; Streams: Boolean);


implementation
{$IFNDEF PS_NOGRAPHCONST}
uses
  {$IFDEF CLX}QGraphics{$ELSE}Graphics, Windows, Types,  uPSI_Types{$ENDIF};
{$ELSE}
{$IFNDEF CLX}
{$IFNDEF FPC}
uses
  Windows, Types, IFSI_WinForm1puzzle;
{$ENDIF}
{$ENDIF}
{$ENDIF}

{type
 TPointArray = array of TPoint;}



procedure SIRegisterTGRAPHICSOBJECT(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TPERSISTENT'), 'TGRAPHICSOBJECT') do begin
   RegisterMethod('function HandleAllocated: Boolean)');
    RegisterProperty('ONCHANGE', 'TNOTIFYEVENT', iptrw);
  end;
end;

procedure SIRegisterTGraphic(CL: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TPersistent'),'TGraphic') do begin
    RegisterMethod('constructor Create');
    RegisterMethod('Procedure LoadFromFile( const Filename : string)');
    RegisterMethod('Procedure SaveToFile( const Filename : string)');

    //RegisterMethod('procedure SetSize(AWidth: Integer; AHeight: Integer); virtual)');
    {RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromClipboardFormat( AFormat : Word; AData : THandle; APalette : HPALETTE)');
    RegisterMethod('Procedure SaveToClipboardFormat( var AFormat : Word; var AData : THandle; var APalette : HPALETTE)');
    abstract }
    RegisterMethod('Procedure SetSize( AWidth, AHeight : Integer)');

    RegisterProperty('Palette', 'HPALETTE', iptrw);
    RegisterProperty('PaletteModified', 'Boolean', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);

    RegisterProperty('Empty', 'Boolean', iptr);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Modified', 'Boolean', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnProgress', 'TProgressEvent', iptrw);

   // property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
  end;
end;


procedure SIRegister_TMetafile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphic', 'TMetafile') do
  with CL.AddClassN(CL.FindClass('TGraphic'),'TMetafile') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure SaveToFile( const Filename : string)');
      RegisterMethod('Procedure SaveToStream( Stream : TStream)');
     RegisterMethod('Procedure LoadFromClipboardFormat( AFormat : Word; AData : THandle; APalette : HPALETTE)');
    RegisterMethod('Procedure SaveToClipboardFormat( var AFormat : Word; var AData : THandle; var APalette : HPALETTE)');
    //RegisterMethod('procedure SetSize(AWidth: Integer; AHeight: Integer); virtual)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterMethod('Procedure SetSize( AWidth, AHeight : Integer)');

    RegisterMethod('Procedure Clear');
    RegisterMethod('Function HandleAllocated : Boolean');
    RegisterMethod('Function ReleaseHandle : HENHMETAFILE');
    RegisterProperty('CreatedBy', 'String', iptr);
    RegisterProperty('Description', 'String', iptr);
    RegisterProperty('Enhanced', 'Boolean', iptrw);
    RegisterProperty('Handle', 'HENHMETAFILE', iptrw);
    RegisterProperty('MMWidth', 'Integer', iptrw);
    RegisterProperty('MMHeight', 'Integer', iptrw);
    RegisterProperty('Inch', 'Word', iptrw);
  end;
end;

procedure SIRegister_TIcon(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphic', 'TIcon') do
  with CL.AddClassN(CL.FindClass('TGraphic'),'TIcon') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    //RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterMethod('Procedure SaveToStream( Stream : TStream)');
     RegisterMethod('Procedure LoadFromClipboardFormat( AFormat : Word; AData : THandle; APalette : HPALETTE)');
    RegisterMethod('Procedure SaveToClipboardFormat( var AFormat : Word; var AData : THandle; var APalette : HPALETTE)');
    //RegisterMethod('procedure SetSize(AWidth: Integer; AHeight: Integer); virtual)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('procedure Assign(Source: TPersistent)');
     RegisterMethod('Procedure SetSize( AWidth, AHeight : Integer)');
     RegisterMethod('Function HandleAllocated : Boolean');
    RegisterMethod('Procedure LoadFromResourceName( Instance : THandle; const ResName : String)');
    RegisterMethod('Procedure LoadFromResourceID( Instance : THandle; ResID : Integer)');
    RegisterMethod('Function ReleaseHandle : HICON');
    RegisterProperty('Handle', 'HICON', iptrw);
  end;
end;


procedure SIRegisterTFont(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGraphicsObject'), 'TFONT') do begin
    RegisterMethod('constructor Create;');
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure Assign(Source: TPersistent)');
{$IFNDEF CLX}
    RegisterProperty('Handle', 'Integer', iptRW);
{$ENDIF}
    //RegisterProperty('PixelsPerInch', 'Integer', iptrw);
    RegisterProperty('Charset', 'TFontCharset', iptrw);
    RegisterProperty('Orientation', 'Integer', iptrw);

    RegisterProperty('Color', 'TColor', iptRW);
    RegisterProperty('Height', 'Integer', iptRW);
    RegisterProperty('Name', 'string', iptRW);
    RegisterProperty('Pitch', 'Byte', iptRW);
    RegisterProperty('Size', 'Integer', iptRW);
    RegisterProperty('PixelsPerInch', 'Integer', iptRW);
    RegisterProperty('Style', 'TFontStyles', iptrw);
  end;
end;

procedure SIRegisterTCanvas(cl: TPSPascalCompiler); // requires TPersistent
begin
  with Cl.AddClassN(cl.FindClass('TPersistent'), 'TCANVAS') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);');
    RegisterMethod('procedure Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);');
    RegisterMethod('procedure Draw(X, Y: Integer; Graphic: TGraphic);');
    RegisterMethod('procedure DrawFocusRect(const Rect: TRect);');
    RegisterMethod('procedure Ellipse(X1, Y1, X2, Y2: Integer);');
    RegisterMethod('procedure FillRect(const Rect: TRect);');
    RegisterMethod('procedure CopyRect(const Dest: TRect; Canvas: TCanvas;const Source: TRect);');
    RegisterMethod('procedure StretchDraw(const Rect: TRect; Graphic: TGraphic);');

     // CL.AddTypeS('TPointArray', 'array of TPoint');

    RegisterMethod('procedure Polyline(const aPoints: array of TPoint);');
    RegisterMethod('procedure Polygon(const aPoints: array of TPoint);');
    RegisterMethod('procedure PolyBezier(const aPoints: array of TPoint);');
    RegisterMethod('procedure PolyBezierTo(const aPoints: array of TPoint);');
    {RegisterMethod('procedure Polyline(const Points: TPointarray);');
    RegisterMethod('procedure Polygon(const Points: TPointarray);');
    RegisterMethod('procedure PolyBezier(const Points: TPointarray);');
    RegisterMethod('procedure PolyBezierTo(const Points: TPointarray);');}

    RegisterMethod('procedure Pie(X1: Integer; Y1: Integer; X2: Integer; Y2: Integer; X3: Integer; Y3: Integer; X4: Integer; Y4: Integer);');
    RegisterMethod('procedure FrameRect(const Rect: TRect);');
    RegisterMethod('procedure TextRect(Rect: TRect; X: Integer; Y: Integer; const Text: string);');
    RegisterMethod('procedure Refresh;');
    //3.6
    RegisterMethod('Procedure BrushCopy(const Dest : TRect; Bitmap : TBitmap; const Source : TRect; Color : TColor)');
    RegisterMethod('Procedure Ellipse1( const Rect : TRect);');
    RegisterMethod('Procedure FloodFill( X, Y : Integer; Color : TColor; FillStyle : TFillStyle)');
    //RegisterMethod('Procedure FrameRect( const Rect : TRect)');
    RegisterMethod('Function HandleAllocated : Boolean');
    //RegisterMethod('Procedure LineTo( X, Y : Integer)');
    RegisterMethod('Procedure Lock');
    //RegisterMethod('Procedure MoveTo( X, Y : Integer)');
    //RegisterMethod('Procedure PolyBezierTo( const Points : array of TPoint)');
    RegisterMethod('Procedure Rectangle1( const Rect : TRect);');
    RegisterMethod('Function TextExtent( const Text : string) : TSize');
    RegisterMethod('Procedure TextRect( Rect : TRect; X, Y : Integer; const Text : string);');
    RegisterMethod('Procedure TextRect1( var Rect : TRect; var Text : string; TextFormat : TTextFormat);');
    RegisterMethod('Function TryLock : Boolean');
    RegisterMethod('Procedure Unlock');

{$IFNDEF CLX}
    //RegisterMethod('procedure FloodFill(X, Y: Integer; Color: TColor; FillStyle: Byte);');
{$ENDIF}
    RegisterMethod('procedure LineTo(X, Y: Integer);');
    RegisterMethod('procedure MoveTo(X, Y: Integer);');
    RegisterMethod('procedure Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);');
    RegisterMethod('procedure Rectangle(X1, Y1, X2, Y2: Integer);');
    RegisterMethod('procedure Refresh;');
    RegisterMethod('procedure RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer);');
    RegisterMethod('function TextHeight(Text: string): Integer;');
    RegisterMethod('procedure TextOut(X, Y: Integer; Text: string);');
    RegisterMethod('function TextWidth(Text: string): Integer;');
    //RegisterMethod('procedure Draw(X, Y: Integer; Graphic: TGraphic);');

{$IFNDEF CLX}
    RegisterProperty('Handle', 'Integer', iptRw);
{$ENDIF}
    RegisterProperty('Pixels', 'Integer Integer Integer', iptRW);
    RegisterProperty('Brush', 'TBrush', iptRw);
    //RegisterProperty('CopyMode', 'Byte', iptRw);
    RegisterProperty('Font', 'TFont', iptRw);
    RegisterProperty('Pen', 'TPen', iptRw);
    RegisterProperty('ClipRect','TRect', iptRw);
    //3.6
    RegisterProperty('LockCount', 'Integer', iptr);
    RegisterProperty('CanvasOrientation', 'TCanvasOrientation', iptr);
    RegisterProperty('PenPos', 'TPoint', iptrw);
    //RegisterProperty('Pixels', 'TColor Integer Integer', iptrw);
    RegisterProperty('TextFlags', 'Longint', iptrw);
    RegisterProperty('CopyMode', 'TCopyMode', iptrw);
    //RegisterProperty('Brush', 'TBrush', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChanging', 'TNotifyEvent', iptrw);

   end;
end;

procedure SIRegisterTPEN(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICSOBJECT'), 'TPEN') do begin
    RegisterMethod('constructor CREATE');
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure Assign(Source: TPersistent)');
    RegisterProperty('Handle', 'HPen', iptrw);     //3.6
    RegisterProperty('COLOR', 'TCOLOR', iptrw);
    RegisterProperty('MODE', 'TPENMODE', iptrw);
    RegisterProperty('STYLE', 'TPENSTYLE', iptrw);
    RegisterProperty('WIDTH', 'INTEGER', iptrw);
  end;
end;

procedure SIRegisterTBRUSH(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICSOBJECT'), 'TBRUSH') do begin
    RegisterMethod('constructor CREATE');
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure Assign(Source: TPersistent)');
    RegisterProperty('Handle', 'HBrush', iptrw);      //3.6
    RegisterProperty('COLOR', 'TCOLOR', iptrw);
    RegisterProperty('STYLE', 'TBRUSHSTYLE', iptrw);
    RegisterProperty('BITMAP', 'TBITMAP', iptrw);
    RegisterProperty('Handle', 'Integer', iptRw);
  end;
end;

procedure SIRegister_Graphics_TypesAndConsts(Cl: TPSPascalCompiler);
{$IFDEF PS_NOGRAPHCONST}
const
  clSystemColor = {$IFDEF DELPHI7UP} $FF000000 {$ELSE} $80000000 {$ENDIF};
{$ENDIF}
begin
{$IFNDEF PS_NOGRAPHCONST}
  cl.AddConstantN('clScrollBar', 'Integer').Value.ts32 := clScrollBar;
  cl.AddConstantN('clBackground', 'Integer').Value.ts32 := clBackground;
  cl.AddConstantN('clActiveCaption', 'Integer').Value.ts32 := clActiveCaption;
  cl.AddConstantN('clInactiveCaption', 'Integer').Value.ts32 := clInactiveCaption;
  cl.AddConstantN('clMenu', 'Integer').Value.ts32 := clMenu;
  cl.AddConstantN('clWindow', 'Integer').Value.ts32 := clWindow;
  cl.AddConstantN('clWindowFrame', 'Integer').Value.ts32 := clWindowFrame;
  cl.AddConstantN('clMenuText', 'Integer').Value.ts32 := clMenuText;
  cl.AddConstantN('clWindowText', 'Integer').Value.ts32 := clWindowText;
  cl.AddConstantN('clCaptionText', 'Integer').Value.ts32 := clCaptionText;
  cl.AddConstantN('clActiveBorder', 'Integer').Value.ts32 := clActiveBorder;
  cl.AddConstantN('clInactiveBorder', 'Integer').Value.ts32 := clInactiveCaption;
  cl.AddConstantN('clAppWorkSpace', 'Integer').Value.ts32 := clAppWorkSpace;
  cl.AddConstantN('clHighlight', 'Integer').Value.ts32 := clHighlight;
  cl.AddConstantN('clHighlightText', 'Integer').Value.ts32 := clHighlightText;
  cl.AddConstantN('clBtnFace', 'Integer').Value.ts32 := clBtnFace;
  cl.AddConstantN('clBtnShadow', 'Integer').Value.ts32 := clBtnShadow;
  cl.AddConstantN('clGrayText', 'Integer').Value.ts32 := clGrayText;
  cl.AddConstantN('clBtnText', 'Integer').Value.ts32 := clBtnText;
  cl.AddConstantN('clInactiveCaptionText', 'Integer').Value.ts32 := clInactiveCaptionText;
  cl.AddConstantN('clBtnHighlight', 'Integer').Value.ts32 := clBtnHighlight;
  cl.AddConstantN('cl3DDkShadow', 'Integer').Value.ts32 := cl3DDkShadow;
  cl.AddConstantN('cl3DLight', 'Integer').Value.ts32 := cl3DLight;
  cl.AddConstantN('clInfoText', 'Integer').Value.ts32 := clInfoText;
  cl.AddConstantN('clInfoBk', 'Integer').Value.ts32 := clInfoBk;
{$ELSE}
{$IFNDEF CLX}  // These are VCL-only; CLX uses different constant values
  cl.AddConstantN('clScrollBar', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_SCROLLBAR);
  cl.AddConstantN('clBackground', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_BACKGROUND);
  cl.AddConstantN('clActiveCaption', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_ACTIVECAPTION);
  cl.AddConstantN('clInactiveCaption', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_INACTIVECAPTION);
  cl.AddConstantN('clMenu', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_MENU);
  cl.AddConstantN('clWindow', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_WINDOW);
  cl.AddConstantN('clWindowFrame', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_WINDOWFRAME);
  cl.AddConstantN('clMenuText', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_MENUTEXT);
  cl.AddConstantN('clWindowText', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_WINDOWTEXT);
  cl.AddConstantN('clCaptionText', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_CAPTIONTEXT);
  cl.AddConstantN('clActiveBorder', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_ACTIVEBORDER);
  cl.AddConstantN('clInactiveBorder', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_INACTIVEBORDER);
  cl.AddConstantN('clAppWorkSpace', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_APPWORKSPACE);
  cl.AddConstantN('clHighlight', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_HIGHLIGHT);
  cl.AddConstantN('clHighlightText', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_HIGHLIGHTTEXT);
  cl.AddConstantN('clBtnFace', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_BTNFACE);
  cl.AddConstantN('clBtnShadow', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_BTNSHADOW);
  cl.AddConstantN('clGrayText', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_GRAYTEXT);
  cl.AddConstantN('clBtnText', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_BTNTEXT);
  cl.AddConstantN('clInactiveCaptionText', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_INACTIVECAPTIONTEXT);
  cl.AddConstantN('clBtnHighlight', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_BTNHIGHLIGHT);
  cl.AddConstantN('cl3DDkShadow', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_3DDKSHADOW);
  cl.AddConstantN('cl3DLight', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_3DLIGHT);
  cl.AddConstantN('clInfoText', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_INFOTEXT);
  cl.AddConstantN('clInfoBk', 'Integer').Value.ts32 := Integer(clSystemColor or COLOR_INFOBK);
{$ENDIF}
{$ENDIF}
  cl.AddConstantN('clBlack', 'Integer').Value.ts32 := $000000;
  cl.AddConstantN('clMaroon', 'Integer').Value.ts32 := $000080;
  cl.AddConstantN('clGreen', 'Integer').Value.ts32 := $008000;
  cl.AddConstantN('clOlive', 'Integer').Value.ts32 := $008080;
  cl.AddConstantN('clNavy', 'Integer').Value.ts32 := $800000;
  cl.AddConstantN('clPurple', 'Integer').Value.ts32 := $800080;
  cl.AddConstantN('clTeal', 'Integer').Value.ts32 := $808000;
  cl.AddConstantN('clGray', 'Integer').Value.ts32 := $808080;
  cl.AddConstantN('clSilver', 'Integer').Value.ts32 := $C0C0C0;
  cl.AddConstantN('clRed', 'Integer').Value.ts32 := $0000FF;
  cl.AddConstantN('clLime', 'Integer').Value.ts32 := $00FF00;
  cl.AddConstantN('clYellow', 'Integer').Value.ts32 := $00FFFF;
  cl.AddConstantN('clBlue', 'Integer').Value.ts32 := $FF0000;
  cl.AddConstantN('clFuchsia', 'Integer').Value.ts32 := $FF00FF;
  cl.AddConstantN('clAqua', 'Integer').Value.ts32 := $FFFF00;
  cl.AddConstantN('clLtGray', 'Integer').Value.ts32 := $C0C0C0;
  cl.AddConstantN('clDkGray', 'Integer').Value.ts32 := $808080;
  cl.AddConstantN('clWhite', 'Integer').Value.ts32 := $FFFFFF;
  cl.AddConstantN('clNone', 'Integer').Value.ts32 := $1FFFFFFF;
  cl.AddConstantN('clDefault', 'Integer').Value.ts32 := $20000000;
   CL.AddConstantN('clWebSnow','LongWord').SetUInt( $FAFAFF);
 CL.AddConstantN('clWebFloralWhite','LongWord').SetUInt( $F0FAFF);
 CL.AddConstantN('clWebLavenderBlush','LongWord').SetUInt( $F5F0FF);
 CL.AddConstantN('clWebOldLace','LongWord').SetUInt( $E6F5FD);
 CL.AddConstantN('clWebIvory','LongWord').SetUInt( $F0FFFF);
 CL.AddConstantN('clWebCornSilk','LongWord').SetUInt( $DCF8FF);
 CL.AddConstantN('clWebBeige','LongWord').SetUInt( $DCF5F5);
 CL.AddConstantN('clWebAntiqueWhite','LongWord').SetUInt( $D7EBFA);
 CL.AddConstantN('clWebWheat','LongWord').SetUInt( $B3DEF5);
 CL.AddConstantN('clWebAliceBlue','LongWord').SetUInt( $FFF8F0);
 CL.AddConstantN('clWebGhostWhite','LongWord').SetUInt( $FFF8F8);
 CL.AddConstantN('clWebLavender','LongWord').SetUInt( $FAE6E6);
 CL.AddConstantN('clWebSeashell','LongWord').SetUInt( $EEF5FF);
 CL.AddConstantN('clWebLightYellow','LongWord').SetUInt( $E0FFFF);
 CL.AddConstantN('clWebPapayaWhip','LongWord').SetUInt( $D5EFFF);
 CL.AddConstantN('clWebNavajoWhite','LongWord').SetUInt( $ADDEFF);
 CL.AddConstantN('clWebMoccasin','LongWord').SetUInt( $B5E4FF);
 CL.AddConstantN('clWebBurlywood','LongWord').SetUInt( $87B8DE);
 CL.AddConstantN('clWebAzure','LongWord').SetUInt( $FFFFF0);
 CL.AddConstantN('clWebMintcream','LongWord').SetUInt( $FAFFF5);
 CL.AddConstantN('clWebHoneydew','LongWord').SetUInt( $F0FFF0);
 CL.AddConstantN('clWebLinen','LongWord').SetUInt( $E6F0FA);
 CL.AddConstantN('clWebLemonChiffon','LongWord').SetUInt( $CDFAFF);
 CL.AddConstantN('clWebBlanchedAlmond','LongWord').SetUInt( $CDEBFF);
 CL.AddConstantN('clWebBisque','LongWord').SetUInt( $C4E4FF);
 CL.AddConstantN('clWebPeachPuff','LongWord').SetUInt( $B9DAFF);
 CL.AddConstantN('clWebTan','LongWord').SetUInt( $8CB4D2);
 CL.AddConstantN('clWebYellow','LongWord').SetUInt( $00FFFF);
 CL.AddConstantN('clWebDarkOrange','LongWord').SetUInt( $008CFF);
 CL.AddConstantN('clWebRed','LongWord').SetUInt( $0000FF);
 CL.AddConstantN('clWebDarkRed','LongWord').SetUInt( $00008B);
 CL.AddConstantN('clWebMaroon','LongWord').SetUInt( $000080);
 CL.AddConstantN('clWebIndianRed','LongWord').SetUInt( $5C5CCD);
 CL.AddConstantN('clWebSalmon','LongWord').SetUInt( $7280FA);
 CL.AddConstantN('clWebCoral','LongWord').SetUInt( $507FFF);
 CL.AddConstantN('clWebGold','LongWord').SetUInt( $00D7FF);
 CL.AddConstantN('clWebTomato','LongWord').SetUInt( $4763FF);
 CL.AddConstantN('clWebCrimson','LongWord').SetUInt( $3C14DC);
 CL.AddConstantN('clWebBrown','LongWord').SetUInt( $2A2AA5);
 CL.AddConstantN('clWebChocolate','LongWord').SetUInt( $1E69D2);
 CL.AddConstantN('clWebSandyBrown','LongWord').SetUInt( $60A4F4);
 CL.AddConstantN('clWebLightSalmon','LongWord').SetUInt( $7AA0FF);
 CL.AddConstantN('clWebLightCoral','LongWord').SetUInt( $8080F0);
 CL.AddConstantN('clWebOrange','LongWord').SetUInt( $00A5FF);
 CL.AddConstantN('clWebOrangeRed','LongWord').SetUInt( $0045FF);
 CL.AddConstantN('clWebFirebrick','LongWord').SetUInt( $2222B2);
 CL.AddConstantN('clWebSaddleBrown','LongWord').SetUInt( $13458B);
 CL.AddConstantN('clWebSienna','LongWord').SetUInt( $2D52A0);
 CL.AddConstantN('clWebPeru','LongWord').SetUInt( $3F85CD);
 CL.AddConstantN('clWebDarkSalmon','LongWord').SetUInt( $7A96E9);
 CL.AddConstantN('clWebRosyBrown','LongWord').SetUInt( $8F8FBC);
 CL.AddConstantN('clWebPaleGoldenrod','LongWord').SetUInt( $AAE8EE);
 CL.AddConstantN('clWebLightGoldenrodYellow','LongWord').SetUInt( $D2FAFA);
 CL.AddConstantN('clWebOlive','LongWord').SetUInt( $008080);
 CL.AddConstantN('clWebForestGreen','LongWord').SetUInt( $228B22);
 CL.AddConstantN('clWebGreenYellow','LongWord').SetUInt( $2FFFAD);
 CL.AddConstantN('clWebChartreuse','LongWord').SetUInt( $00FF7F);
 CL.AddConstantN('clWebLightGreen','LongWord').SetUInt( $90EE90);
 CL.AddConstantN('clWebAquamarine','LongWord').SetUInt( $D4FF7F);
 CL.AddConstantN('clWebSeaGreen','LongWord').SetUInt( $578B2E);
 CL.AddConstantN('clWebGoldenRod','LongWord').SetUInt( $20A5DA);
 CL.AddConstantN('clWebKhaki','LongWord').SetUInt( $8CE6F0);
 CL.AddConstantN('clWebOliveDrab','LongWord').SetUInt( $238E6B);
 CL.AddConstantN('clWebGreen','LongWord').SetUInt( $008000);
 CL.AddConstantN('clWebYellowGreen','LongWord').SetUInt( $32CD9A);
 CL.AddConstantN('clWebLawnGreen','LongWord').SetUInt( $00FC7C);
 CL.AddConstantN('clWebPaleGreen','LongWord').SetUInt( $98FB98);
 CL.AddConstantN('clWebMediumAquamarine','LongWord').SetUInt( $AACD66);
 CL.AddConstantN('clWebMediumSeaGreen','LongWord').SetUInt( $71B33C);
 CL.AddConstantN('clWebDarkGoldenRod','LongWord').SetUInt( $0B86B8);
 CL.AddConstantN('clWebDarkKhaki','LongWord').SetUInt( $6BB7BD);
 CL.AddConstantN('clWebDarkOliveGreen','LongWord').SetUInt( $2F6B55);
 CL.AddConstantN('clWebDarkgreen','LongWord').SetUInt( $006400);
 CL.AddConstantN('clWebLimeGreen','LongWord').SetUInt( $32CD32);
 CL.AddConstantN('clWebLime','LongWord').SetUInt( $00FF00);
 CL.AddConstantN('clWebSpringGreen','LongWord').SetUInt( $7FFF00);
 CL.AddConstantN('clWebMediumSpringGreen','LongWord').SetUInt( $9AFA00);
 CL.AddConstantN('clWebDarkSeaGreen','LongWord').SetUInt( $8FBC8F);
 CL.AddConstantN('clWebLightSeaGreen','LongWord').SetUInt( $AAB220);
 CL.AddConstantN('clWebPaleTurquoise','LongWord').SetUInt( $EEEEAF);
 CL.AddConstantN('clWebLightCyan','LongWord').SetUInt( $FFFFE0);
 CL.AddConstantN('clWebLightBlue','LongWord').SetUInt( $E6D8AD);
 CL.AddConstantN('clWebLightSkyBlue','LongWord').SetUInt( $FACE87);
 CL.AddConstantN('clWebCornFlowerBlue','LongWord').SetUInt( $ED9564);
 CL.AddConstantN('clWebDarkBlue','LongWord').SetUInt( $8B0000);
 CL.AddConstantN('clWebIndigo','LongWord').SetUInt( $82004B);
 CL.AddConstantN('clWebMediumTurquoise','LongWord').SetUInt( $CCD148);
 CL.AddConstantN('clWebTurquoise','LongWord').SetUInt( $D0E040);
 CL.AddConstantN('clWebCyan','LongWord').SetUInt( $FFFF00);
 CL.AddConstantN('clWebAqua','LongWord').SetUInt( $FFFF00);
 CL.AddConstantN('clWebPowderBlue','LongWord').SetUInt( $E6E0B0);
 CL.AddConstantN('clWebSkyBlue','LongWord').SetUInt( $EBCE87);
 CL.AddConstantN('clWebRoyalBlue','LongWord').SetUInt( $E16941);
 CL.AddConstantN('clWebMediumBlue','LongWord').SetUInt( $CD0000);
 CL.AddConstantN('clWebMidnightBlue','LongWord').SetUInt( $701919);
 CL.AddConstantN('clWebDarkTurquoise','LongWord').SetUInt( $D1CE00);
 CL.AddConstantN('clWebCadetBlue','LongWord').SetUInt( $A09E5F);
 CL.AddConstantN('clWebDarkCyan','LongWord').SetUInt( $8B8B00);
 CL.AddConstantN('clWebTeal','LongWord').SetUInt( $808000);
 CL.AddConstantN('clWebDeepskyBlue','LongWord').SetUInt( $FFBF00);
 CL.AddConstantN('clWebDodgerBlue','LongWord').SetUInt( $FF901E);
 CL.AddConstantN('clWebBlue','LongWord').SetUInt( $FF0000);
 CL.AddConstantN('clWebNavy','LongWord').SetUInt( $800000);
 CL.AddConstantN('clWebDarkViolet','LongWord').SetUInt( $D30094);
 CL.AddConstantN('clWebDarkOrchid','LongWord').SetUInt( $CC3299);
 CL.AddConstantN('clWebMagenta','LongWord').SetUInt( $FF00FF);
 CL.AddConstantN('clWebFuchsia','LongWord').SetUInt( $FF00FF);
 CL.AddConstantN('clWebDarkMagenta','LongWord').SetUInt( $8B008B);
 CL.AddConstantN('clWebMediumVioletRed','LongWord').SetUInt( $8515C7);
 CL.AddConstantN('clWebPaleVioletRed','LongWord').SetUInt( $9370DB);
 CL.AddConstantN('clWebBlueViolet','LongWord').SetUInt( $E22B8A);
 CL.AddConstantN('clWebMediumOrchid','LongWord').SetUInt( $D355BA);
 CL.AddConstantN('clWebMediumPurple','LongWord').SetUInt( $DB7093);
 CL.AddConstantN('clWebPurple','LongWord').SetUInt( $800080);
 CL.AddConstantN('clWebDeepPink','LongWord').SetUInt( $9314FF);
 CL.AddConstantN('clWebLightPink','LongWord').SetUInt( $C1B6FF);
 CL.AddConstantN('clWebViolet','LongWord').SetUInt( $EE82EE);
 CL.AddConstantN('clWebOrchid','LongWord').SetUInt( $D670DA);
 CL.AddConstantN('clWebPlum','LongWord').SetUInt( $DDA0DD);
 CL.AddConstantN('clWebThistle','LongWord').SetUInt( $D8BFD8);
 CL.AddConstantN('clWebHotPink','LongWord').SetUInt( $B469FF);
 CL.AddConstantN('clWebPink','LongWord').SetUInt( $CBC0FF);
 CL.AddConstantN('clWebLightSteelBlue','LongWord').SetUInt( $DEC4B0);
 CL.AddConstantN('clWebMediumSlateBlue','LongWord').SetUInt( $EE687B);
 CL.AddConstantN('clWebLightSlateGray','LongWord').SetUInt( $998877);
 CL.AddConstantN('clWebWhite','LongWord').SetUInt( $FFFFFF);
 CL.AddConstantN('clWebLightgrey','LongWord').SetUInt( $D3D3D3);
 CL.AddConstantN('clWebGray','LongWord').SetUInt( $808080);
 CL.AddConstantN('clWebSteelBlue','LongWord').SetUInt( $B48246);
 CL.AddConstantN('clWebSlateBlue','LongWord').SetUInt( $CD5A6A);
 CL.AddConstantN('clWebSlateGray','LongWord').SetUInt( $908070);
 CL.AddConstantN('clWebWhiteSmoke','LongWord').SetUInt( $F5F5F5);
 CL.AddConstantN('clWebSilver','LongWord').SetUInt( $C0C0C0);
 CL.AddConstantN('clWebDimGray','LongWord').SetUInt( $696969);
 CL.AddConstantN('clWebMistyRose','LongWord').SetUInt( $E1E4FF);
 CL.AddConstantN('clWebDarkSlateBlue','LongWord').SetUInt( $8B3D48);
 CL.AddConstantN('clWebDarkSlategray','LongWord').SetUInt( $4F4F2F);
 CL.AddConstantN('clWebGainsboro','LongWord').SetUInt( $DCDCDC);
 CL.AddConstantN('clWebDarkGray','LongWord').SetUInt( $A9A9A9);
 CL.AddConstantN('clWebBlack','LongWord').SetUInt( $000000);
 CL.AddConstantN('WebColorsCount','LongInt').SetInt( 140);
  CL.AddConstantN('SRCCOPY','LongWord').SetUInt( $00CC0020);
 CL.AddConstantN('SRCPAINT','LongWord').SetUInt( $00EE0086);
 CL.AddConstantN('SRCAND','LongWord').SetUInt( $008800C6);
 CL.AddConstantN('SRCINVERT','LongWord').SetUInt( $00660046);
 CL.AddConstantN('SRCERASE','LongWord').SetUInt( $00440328);
 CL.AddConstantN('NOTSRCCOPY','LongWord').SetUInt( $00330008);
 CL.AddConstantN('NOTSRCERASE','LongWord').SetUInt( $001100A6);
 CL.AddConstantN('MERGECOPY','LongWord').SetUInt( $00C000CA);
 CL.AddConstantN('MERGEPAINT','LongWord').SetUInt( $00BB0226);
 CL.AddConstantN('PATCOPY','LongWord').SetUInt( $00F00021);
 CL.AddConstantN('PATPAINT','LongWord').SetUInt( $00FB0A09);
 CL.AddConstantN('PATINVERT','LongWord').SetUInt( $005A0049);
 CL.AddConstantN('DSTINVERT','LongWord').SetUInt( $00550009);
 CL.AddConstantN('BLACKNESS','LongWord').SetUInt( $00000042);
 CL.AddConstantN('WHITENESS','LongWord').SetUInt( $00FF0062);

 CL.AddConstantN('cmBlackness','LongWord').SetUint(BLACKNESS);
 CL.AddConstantN('cmDstInvert','LongWord').SetUint(DSTINVERT);
 CL.AddConstantN('cmMergeCopy','LongWord').SetUint(MERGECOPY);
 CL.AddConstantN('cmMergePaint','LongWord').SetUint(MERGEPAINT);
 CL.AddConstantN('cmNotSrcCopy','LongWord').SetUint(NOTSRCCOPY);
 CL.AddConstantN('cmNotSrcErase','LongWord').SetUint(NOTSRCERASE);
 CL.AddConstantN('cmPatCopy','LongWord').SetUint(PATCOPY);
 CL.AddConstantN('cmPatInvert','LongWord').SetUint(PATINVERT);
 CL.AddConstantN('cmPatPaint','LongWord').SetUint(PATPAINT);
 CL.AddConstantN('cmSrcAnd','LongWord').SetUint(SRCAND);
 CL.AddConstantN('cmSrcCopy','LongWord').SetUint(SRCCOPY);
 CL.AddConstantN('cmSrcErase','LongWord').SetUint(SRCERASE);
 CL.AddConstantN('cmSrcInvert','LongWord').SetUint(SRCINVERT);
 CL.AddConstantN('cmSrcPaint','LongWord').SetUint(SRCPAINT);
 CL.AddConstantN('cmWhiteness','LongWord').SetUint(WHITENESS);
 CL.AddConstantN('rc3_StockIcon','LongInt').SetInt(0);
 CL.AddConstantN('rc3_Icon','LongInt').SetInt(1);
 CL.AddConstantN('rc3_Cursor','LongInt').SetInt(2);

 { CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidGraphic');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidGraphicOperation');}
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidGraphic');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidGraphicOperation');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TGraphic');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBitmap');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIcon');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMetafile');
  //  CL.AddTypeS('TPointArray', 'array of TPoint');

  CL.AddTypeS('TIconRec', 'record Width : Byte; Height : Byte; Colors : Word; R'
   +'eserved1 : Word; Reserved2 : Word; DIBSize : Longint; DIBOffset : Longint; end');
  CL.AddTypeS('HMETAFILE', 'THandle');
  CL.AddTypeS('HENHMETAFILE', 'THandle');
  CL.AddTypeS('TResData', 'record Handle : THandle; end');
  //CL.AddTypeS('TFontPitch', '( fpDefault, fpVariable, fpFixed )');
  CL.AddTypeS('TFontName', 'string');
  CL.AddTypeS('TFontCharset', 'Integer');
  //CL.AddTypeS('TFontStyle', '( fsBold, fsItalic, fsUnderline, fsStrikeOut )');
  //CL.AddTypeS('TFontStyles', 'set of TFontStyle');
    CL.AddTypeS('TSize', 'record cx: Longint; cy: Longint; end');   //also in JvVCLUtils

   CL.AddTypeS('TFillStyle', '( fsSurface, fsBorder )');
  CL.AddTypeS('TFillMode', '( fmAlternate, fmWinding )');
  CL.AddTypeS('TCopyMode', 'Longint');
  CL.AddTypeS('TCanvasStates', '( csHandleValid, csFontValid, csPenValid, csBrushValid )');
  CL.AddTypeS('TCanvasState', 'set of TCanvasStates');
  CL.AddTypeS('TCanvasOrientation', '( coLeftToRight, coRightToLeft )');
  CL.AddTypeS('TTextFormats', '( tfBottom, tfCalcRect, tfCenter, tfEditControl,'
   +' tfEndEllipsis, tfPathEllipsis, tfExpandTabs, tfExternalLeading, tfLeft, t'
   +'fModifyString, tfNoClip, tfNoPrefix, tfRight, tfRtlReading, tfSingleLine, '
   +'tfTop, tfVerticalCenter, tfWordBreak )');
  CL.AddTypeS('TTextFormat', 'set of TTextFormats');
   CL.AddTypeS('TTextFormat', 'set of TTextFormats');
   CL.AddTypeS('TProgressStage', '( psStarting1, psRunning1,  psEnding1)');

   //TProgressStage = (psStarting, psRunning, psEnding);
  //TProgressEvent = procedure (Sender: TObject; Stage: TProgressStage;
    //PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string) of object;


  ///CL.AddTypeS('TPoint', 'record x: longint; y: longint; end;');
 {TPoint = packed record
    X: Longint;
    Y: Longint;
   end;}
   //cl.AddTypeCopyN('TPoint','packed record x,y: longint; end;');
    //CL.AddTypeS('TPointArray', 'array of TPoint');
   //CL.FindType('TPointArray');
   CL.FindType('TPoint');
   // tpoint
  //CL.AddTypeS('TPointArray','array of TPoint;');

  Cl.addTypeS('TFONTSTYLE', '(FSBOLD, FSITALIC, FSUNDERLINE, FSSTRIKEOUT)');
  Cl.addTypeS('TFONTSTYLES', 'set of TFONTSTYLE');
  CL.AddTypeS('TFontStylesBase', 'set of TFontStyle');
  cl.AddTypeS('TFontPitch', '(fpDefault, fpVariable, fpFixed)');
  cl.AddTypeS('TPenStyle', '(psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame)');
  //cl.AddTypeS('TPenMode', '(pmBlack, pmWhite, pmNop, pmNot, pmCopy, pmNotCopy, pmMergePenNot, pmMaskPenNot, pmMergeNotPen, pmMaskNotPen, pmMerge, pmNotMerge, pmMask, pmNotMask, pmXor, pmNotXor)');
  cl.AddTypeS('TBrushStyle', '(bsSolid, bsClear, bsHorizontal, bsVertical, bsFDiagonal, bsBDiagonal, bsCross, bsDiagCross)');
  cl.addTypeS('TColor', 'integer');
  cl.addTypeS('HPEN', 'LongWord');
  //CL.AddTypeS('TPointArray', 'array of TPoint;');

  { CL.AddTypeS('TPenStyle', '( psSolid, psDash, psDot, psDashDot, psDashDotDot, '
   +'psClear, psInsideFrame, psUserStyle, psAlternate )'); }
  CL.AddTypeS('TPenMode', '( pmBlack, pmWhite, pmNop, pmNot, pmCopy, pmNotCopy,'
   +' pmMergePenNot, pmMaskPenNot, pmMergeNotPen, pmMaskNotPen, pmMerge, pmNotM'
   +'erge, pmMask, pmNotMask, pmXor, pmNotXor )');
  CL.AddTypeS('TPenData', 'record Handle : HPen; Color : TColor; Width : Intege'
   +'r; Style : TPenStyle; end');
  {CL.AddTypeS('TBrushStyle', '( bsSolid, bsClear, bsHorizontal, bsVertical, bsF'
   +'Diagonal, bsBDiagonal, bsCross, bsDiagCross )'); }

  {  TPoint = packed record  X: Longint; Y: Longint;  end;}
  //CL.AddTypeS('TPoint', 'record X: LongInt; Y: LongInt; end');
  //CL.AddTypeS('Points', 'array of TPoint;');

  CL.AddTypeS('TBitmapHandleType', '( bmDIB, bmDDB )');
  CL.AddTypeS('TPixelFormat', '( pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf1'
   +'6bit, pf24bit, pf32bit, pfCustom )');
  CL.AddTypeS('TTransparentMode', '( tmAuto, tmFixed )');

{$IFNDEF CLX}
  cl.addTypeS('HBITMAP', 'LongWord');    //3.6
  cl.addTypeS('HPALETTE', 'LongWord');
  cl.addTypeS('HDC', 'LongWord');
  CL.AddTypeS('HICON','LongWord');  // from sysutils
    CL.AddTypeS('HWND','LongWord');

  //cl.addTypeS('HENHMETAFILE', 'LongWord');
  //cl.addTypeS('HENHMETAFILE', 'THandle');
 // CL.AddTypeS('TFontCharset','0..255');  // from sysutils                                               tfontcharset
 CL.AddClassN(CL.FindClass('TGraphic'),'TBitmap');    //for alloc pattern bitmap

  //CL.AddTypeS('Points', 'array of TPoint;');
 //CL.AddDelphiFunction('GetItemHeight(Font: TFont): Integer;');
 CL.AddDelphiFunction('Procedure GetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: longWORD; var ImageSize : longWORD)');
 CL.AddDelphiFunction('Function CopyPalette( Palette : HPALETTE) : HPALETTE');
 CL.AddDelphiFunction('Procedure PaletteChanged');
 CL.AddDelphiFunction('Procedure FreeMemoryContexts');
 CL.AddDelphiFunction('Function GetDefFontCharSet : TFontCharSet');
 CL.AddDelphiFunction('Function TransparentStretchBlt( DstDC : HDC; DstX, DstY, DstW, DstH : Integer; SrcDC : HDC; SrcX, SrcY, SrcW, SrcH : Integer; MaskDC : HDC; MaskX, MaskY : Integer) : Boolean');
 CL.AddDelphiFunction('Function CreateMappedBmp(Handle : HBITMAP; const OldColors, NewColors : array of TColor) : HBITMAP');
 CL.AddDelphiFunction('Function CreateMappedRes( Instance : THandle; ResName : PChar; const OldColors, NewColors : array of TColor) : HBITMAP');
 CL.AddDelphiFunction('Function CreateGrayMappedBmp( Handle : HBITMAP) : HBITMAP');
 CL.AddDelphiFunction('Function CreateGrayMappedRes( Instance : THandle; ResName : PChar) : HBITMAP');
 CL.AddDelphiFunction('Function AllocPatternBitmap( BkColor, FgColor : TColor) : TBitmap');
 CL.AddDelphiFunction('Function BytesPerScanline( PixelsPerScanline, BitsPerPixel, Alignment : Longint) : Longint');
 //CL.FindType('TRect');
 //CL.AddDelphiFunction('Function GetWindowRect(hwnd: HWND, arect: TRect): boolean;');

 {$ENDIF}
end;


procedure SIRegisterTBitmap(CL: TPSPascalCompiler; Streams: Boolean);
begin
  with CL.AddClassN(CL.FindClass('TGraphic'),'TBitmap') do begin
    RegisterMethod('constructor Create;');
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure Assign(Source: TPersistent)');
    RegisterMethod('Procedure SetSize( AWidth, AHeight : Integer)');
   if Streams then begin
      RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
      RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    end;
      RegisterMethod('Procedure FreeImage');
      RegisterMethod('Procedure Mask( TransparentColor : TColor)');
      RegisterMethod('function ReleaseMaskHandle: HBITMAP)');


     RegisterProperty('Canvas', 'TCanvas', iptr);
{$IFNDEF CLX}
    RegisterProperty('Handle', 'HBITMAP', iptrw);
{$ENDIF}

 {$IFNDEF IFPS_MINIVCL}
    RegisterMethod('Procedure Dormant');
    RegisterMethod('Procedure FreeImage');
{$IFNDEF CLX}
    RegisterMethod('Procedure LoadFromClipboardFormat( AFormat : Word; AData : THandle; APalette : HPALETTE)');
{$ENDIF}
    RegisterMethod('Procedure LoadFromResourceName( Instance : THandle; const ResName : String)');
    RegisterMethod('Procedure LoadFromRes( Instance : THandle; const ResName : String)');
    RegisterMethod('Procedure LoadFromResourceID( Instance : THandle; ResID : Integer)');
{$IFNDEF CLX}
    RegisterMethod('Function ReleaseHandle : HBITMAP');
    RegisterMethod('Function ReleasePalette : HPALETTE');
    RegisterMethod('Procedure SaveToClipboardFormat( var Format : Word; var Data : THandle; var APalette : HPALETTE)');
    RegisterProperty('Monochrome', 'Boolean', iptrw);
    RegisterProperty('Palette', 'HPALETTE', iptrw);
    RegisterProperty('IgnorePalette', 'Boolean', iptrw);
{$ENDIF}
    RegisterProperty('TransparentColor', 'TColor', iptrw);    //fix
    RegisterProperty('TransparentMode', 'TTransparentMode', iptrw);  //3.6
    RegisterProperty('HandleType', 'TBitmapHandleType', iptrw);
    RegisterProperty('MaskHandle', 'HBITMAP', iptrw);

    //pixelformat
    RegisterProperty('pixelFormat', 'TPixelformat', iptrw);

    {$ENDIF}
  end;
end;

procedure SIRegisterTPicture(CL: TPSPascalCompiler);
begin
 with CL.AddClassN(CL.FindClass('TPersistent'),'TPicture') do begin
  RegisterMethod('Constructor Create');
   RegisterMethod('Procedure Free');
   RegisterMethod('procedure Assign(Source: TPersistent)');
   RegisterProperty('Bitmap','TBitmap',iptrw);
   RegisterProperty('Graphic','TGraphic',iptrw);
   RegisterProperty('Icon','TIcon',iptrw);
   RegisterProperty('Height','Integer',iptr);
   RegisterProperty('Width','Integer',iptr);
       RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnProgress', 'TProgressEvent', iptrw);

  //RegisterProperty('Metafile', 'TMetafile', iptrw);
   RegisterProperty('Metafile','TMetafile',iptrw);    //3.1
   RegisterMethod('Procedure LoadFromFile( const Filename : string)');
   RegisterMethod('Procedure SaveToFile( const Filename : string)');  //3.6
   RegisterMethod('Procedure LoadFromClipboardFormat( AFormat : Word; AData : THandle; APalette : HPALETTE)');
  RegisterMethod('Procedure SaveToClipboardFormat( var AFormat : Word; var AData : THandle; var APalette : HPALETTE)');
  RegisterMethod('Function SupportsClipboardFormat( AFormat : Word) : Boolean');
  RegisterMethod('Procedure RegisterFileFormat( const AExtension, ADescription : string; AGraphicClass : TGraphicClass)');

 end;
end;

procedure SIRegister_Graphics(Cl: TPSPascalCompiler; Streams: Boolean);
begin
  SIRegister_Graphics_TypesAndConsts(Cl);
  SIRegisterTGRAPHICSOBJECT(Cl);
  SIRegisterTGraphic(Cl);
  SIRegister_TMetafile(CL);
  SIRegister_TIcon(CL);

  SIRegisterTPEN(cl);
  SIRegisterTFont(Cl);
  SIRegisterTBRUSH(cl);

  SIRegisterTCanvas(cl);
  //SIRegister_Types(cl);       //3.5+3.6

  SIRegisterTBitmap(Cl, Streams);
  SIRegisterTBRUSH(cl);
  SIRegisterTCanvas(cl);
 //SIRegister_Types(cl);       //3.5+3.6

  SIRegisterTPicture(cl);
end;
// this is heavy: canvas.brush.bitmap  - bitmap.canvas.copyrect by max
// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)

End.
