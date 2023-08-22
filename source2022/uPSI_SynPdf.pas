unit uPSI_SynPdf;
{
  for pdf to set
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
  TPSImport_SynPdf = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPdfForm(CL: TPSPascalCompiler);
procedure SIRegister_TPdfImage(CL: TPSPascalCompiler);
procedure SIRegister_TPdfDocumentGDI(CL: TPSPascalCompiler);
procedure SIRegister_TPdfPageGDI(CL: TPSPascalCompiler);
procedure SIRegister_TPdfOutlineRoot(CL: TPSPascalCompiler);
procedure SIRegister_TPdfOutlineEntry(CL: TPSPascalCompiler);
procedure SIRegister_TPdfDestination(CL: TPSPascalCompiler);
procedure SIRegister_TPdfFontTrueType(CL: TPSPascalCompiler);
procedure SIRegister_TPdfTTF(CL: TPSPascalCompiler);
procedure SIRegister_TPdfFontCIDFontType2(CL: TPSPascalCompiler);
procedure SIRegister_TPdfFontType1(CL: TPSPascalCompiler);
procedure SIRegister_TPdfFontWinAnsi(CL: TPSPascalCompiler);
procedure SIRegister_TPdfFont(CL: TPSPascalCompiler);
procedure SIRegister_TPdfCatalog(CL: TPSPascalCompiler);
procedure SIRegister_TPdfInfo(CL: TPSPascalCompiler);
procedure SIRegister_TPdfDictionaryWrapper(CL: TPSPascalCompiler);
procedure SIRegister_TPdfCanvas(CL: TPSPascalCompiler);
procedure SIRegister_TPdfPage(CL: TPSPascalCompiler);
procedure SIRegister_TPdfDocument(CL: TPSPascalCompiler);
procedure SIRegister_TPdfXref(CL: TPSPascalCompiler);
procedure SIRegister_TPdfXrefEntry(CL: TPSPascalCompiler);
procedure SIRegister_TPdfTrailer(CL: TPSPascalCompiler);
procedure SIRegister_TPdfBinary(CL: TPSPascalCompiler);
procedure SIRegister_TPdfStream(CL: TPSPascalCompiler);
procedure SIRegister_TPdfDictionary(CL: TPSPascalCompiler);
procedure SIRegister_TPdfDictionaryElement(CL: TPSPascalCompiler);
procedure SIRegister_TPdfArray(CL: TPSPascalCompiler);
procedure SIRegister_TPdfName(CL: TPSPascalCompiler);
procedure SIRegister_TPdfRawText(CL: TPSPascalCompiler);
procedure SIRegister_TPdfTextString(CL: TPSPascalCompiler);
procedure SIRegister_TPdfTextUTF8(CL: TPSPascalCompiler);
procedure SIRegister_TPdfText(CL: TPSPascalCompiler);
procedure SIRegister_TPdfReal(CL: TPSPascalCompiler);
procedure SIRegister_TPdfNumber(CL: TPSPascalCompiler);
procedure SIRegister_TPdfNull(CL: TPSPascalCompiler);
procedure SIRegister_TPdfBoolean(CL: TPSPascalCompiler);
procedure SIRegister_TPdfVirtualObject(CL: TPSPascalCompiler);
procedure SIRegister_TPdfObject(CL: TPSPascalCompiler);
procedure SIRegister_TPdfObjectMgr(CL: TPSPascalCompiler);
procedure SIRegister_TPdfWrite(CL: TPSPascalCompiler);
procedure SIRegister_TPdfEncryptionRC4MD5(CL: TPSPascalCompiler);
procedure SIRegister_TPdfEncryption(CL: TPSPascalCompiler);
procedure SIRegister_SynPdf(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SynPdf_Routines(S: TPSExec);
procedure RIRegister_TPdfForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfDocumentGDI(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfPageGDI(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfOutlineRoot(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfOutlineEntry(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfDestination(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfFontTrueType(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfTTF(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfFontCIDFontType2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfFontType1(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfFontWinAnsi(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfFont(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfCatalog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfDictionaryWrapper(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfCanvas(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfPage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfDocument(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfXref(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfXrefEntry(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfTrailer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfBinary(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfDictionary(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfDictionaryElement(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfName(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfRawText(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfTextString(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfTextUTF8(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfText(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfReal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfNumber(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfNull(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfBoolean(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfVirtualObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfObjectMgr(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfWrite(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfEncryptionRC4MD5(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPdfEncryption(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynPdf(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,WinSpool
  ,SysConst
  ,Types
  ,Graphics
  ,SynCommons
  ,SynLZ
  ,SynZip
  //,ZLib
  //,SynCrypto
  ,jpeg
  ,SynPdf
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynPdf]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfXObject', 'TPdfForm') do
  with CL.AddClassN(CL.FindClass('TPdfXObject'),'TPdfForm') do begin
    RegisterMethod('Constructor Create( aDoc : TPdfDocumentGDI; aMetaFile : TMetafile)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfXObject', 'TPdfImage') do
  with CL.AddClassN(CL.FindClass('TPdfXObject'),'TPdfImage') do begin
    RegisterMethod('Constructor Create( aDoc : TPdfDocument; aImage : TGraphic; DontAddToFXref : boolean)');
    RegisterMethod('Constructor CreateJpegDirect( aDoc : TPdfDocument; const aJpegFileName : TFileName; DontAddToFXref : boolean);');
    RegisterMethod('Constructor CreateJpegDirect1( aDoc : TPdfDocument; aJpegFile : TMemoryStream; DontAddToFXref : boolean);');
    RegisterProperty('PixelWidth', 'Integer', iptr);
    RegisterProperty('PixelHeight', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfDocumentGDI(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfDocument', 'TPdfDocumentGDI') do
  with CL.AddClassN(CL.FindClass('TPdfDocument'),'TPdfDocumentGDI') do begin
    RegisterMethod('Constructor Create( AUseOutlines : Boolean; ACodePage : integer; APDFA1 : boolean;)');
    RegisterMethod('Constructor Create1;');
    RegisterProperty('VCLCanvas', 'TCanvas', iptr);
    RegisterProperty('VCLCanvasSize', 'TSize', iptr);
    RegisterProperty('UseSetTextJustification', 'Boolean', iptrw);
    RegisterProperty('KerningHScaleBottom', 'Single', iptrw);
    RegisterProperty('KerningHScaleTop', 'Single', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfPageGDI(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfPage', 'TPdfPageGDI') do
  with CL.AddClassN(CL.FindClass('TPdfPage'),'TPdfPageGDI') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfOutlineRoot(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfOutlineEntry', 'TPdfOutlineRoot') do
  with CL.AddClassN(CL.FindClass('TPdfOutlineEntry'),'TPdfOutlineRoot') do begin
    RegisterMethod('Constructor Create( ADoc : TPdfDocument)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfOutlineEntry(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfDictionaryWrapper', 'TPdfOutlineEntry') do
  with CL.AddClassN(CL.FindClass('TPdfDictionaryWrapper'),'TPdfOutlineEntry') do begin
    RegisterMethod('Constructor Create( AParent : TPdfOutlineEntry; TopPosition : integer)');
    RegisterMethod('Function AddChild( TopPosition : integer) : TPdfOutlineEntry');
    RegisterProperty('Doc', 'TPdfDocument', iptr);
    RegisterProperty('Parent', 'TPdfOutlineEntry', iptr);
    RegisterProperty('Next', 'TPdfOutlineEntry', iptr);
    RegisterProperty('Prev', 'TPdfOutlineEntry', iptr);
    RegisterProperty('First', 'TPdfOutlineEntry', iptr);
    RegisterProperty('Last', 'TPdfOutlineEntry', iptr);
    RegisterProperty('Dest', 'TPdfDestination', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Opened', 'boolean', iptrw);
    RegisterProperty('Reference', 'TObject', iptrw);
    RegisterProperty('Level', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfDestination(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPdfDestination') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPdfDestination') do begin
    RegisterMethod('Constructor Create( APdfDoc : TPdfDocument)');
    RegisterMethod('Function GetValue : TPdfArray');
    RegisterProperty('DestinationType', 'TPdfDestinationType', iptrw);
    RegisterProperty('Doc', 'TPdfDocument', iptr);
    RegisterProperty('Page', 'TPdfPage', iptr);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('Right', 'Integer', iptrw);
    RegisterProperty('Bottom', 'Integer', iptrw);
    RegisterProperty('PageHeight', 'Integer', iptr);
    RegisterProperty('PageWidth', 'Integer', iptr);
    RegisterProperty('Zoom', 'Single', iptrw);
    RegisterProperty('Reference', 'TObject', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfFontTrueType(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfFontWinAnsi', 'TPdfFontTrueType') do
  with CL.AddClassN(CL.FindClass('TPdfFontWinAnsi'),'TPdfFontTrueType') do begin
    RegisterMethod('Constructor Create( ADoc : TPdfDocument; AFontIndex : integer; AStyle : TFontStyles; const ALogFont : TLogFontW; AWinAnsiFont : TPdfFontTrueType)');
    RegisterMethod('Function FindOrAddUsedWideChar( aWideChar : WideChar) : integer');
    RegisterMethod('Function GetWideCharWidth( aWideChar : WideChar) : Integer');
    RegisterProperty('WideCharUsed', 'Boolean', iptr);
    RegisterProperty('Style', 'TFontStyles', iptr);
    RegisterProperty('FixedWidth', 'boolean', iptr);
    RegisterProperty('UnicodeFont', 'TPdfFontTrueType', iptr);
    RegisterProperty('WinAnsiFont', 'TPdfFontTrueType', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfTTF(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPdfTTF') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfTTF') do begin
    //RegisterProperty('head', ' ^TCmapHEAD // will not work', iptrw);
    //RegisterProperty('hhea', ' ^TCmapHHEA // will not work', iptrw);
    //RegisterProperty('fmt4', ' ^TCmapFmt4 // will not work', iptrw);
    RegisterProperty('startCode', 'PWordArray', iptrw);
    RegisterProperty('endCode', 'PWordArray', iptrw);
    RegisterProperty('idDelta', 'PSmallIntArray', iptrw);
    RegisterProperty('idRangeOffset', 'PWordArray', iptrw);
    RegisterProperty('glyphIndexArray', 'PWordArray', iptrw);
    RegisterMethod('Constructor Create( aUnicodeTTF : TPdfFontTrueType)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfFontCIDFontType2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfFont', 'TPdfFontCIDFontType2') do
  with CL.AddClassN(CL.FindClass('TPdfFont'),'TPdfFontCIDFontType2') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfFontType1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfFontWinAnsi', 'TPdfFontType1') do
  with CL.AddClassN(CL.FindClass('TPdfFontWinAnsi'),'TPdfFontType1') do begin
    RegisterMethod('Constructor Create( AXref : TPdfXref; const AName : PDFString; WidthArray : PSmallIntArray)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfFontWinAnsi(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfFont', 'TPdfFontWinAnsi') do
  with CL.AddClassN(CL.FindClass('TPdfFont'),'TPdfFontWinAnsi') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfFont(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfDictionaryWrapper', 'TPdfFont') do
  with CL.AddClassN(CL.FindClass('TPdfDictionaryWrapper'),'TPdfFont') do begin
    RegisterMethod('Constructor Create( AXref : TPdfXref; const AName : PDFString)');
    RegisterMethod('Procedure AddUsedWinAnsiChar( aChar : AnsiChar)');
    RegisterMethod('Function GetAnsiCharWidth( const AText : PDFString; APos : integer) : integer');
    RegisterProperty('Name', 'PDFString', iptr);
    RegisterProperty('ShortCut', 'PDFString', iptr);
    RegisterProperty('Unicode', 'boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfCatalog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfDictionaryWrapper', 'TPdfCatalog') do
  with CL.AddClassN(CL.FindClass('TPdfDictionaryWrapper'),'TPdfCatalog') do begin
    RegisterProperty('OpenAction', 'TPdfDestination', iptrw);
    RegisterProperty('PageLayout', 'TPdfPageLayout', iptrw);
    RegisterProperty('NonFullScreenPageMode', 'TPdfPageMode', iptrw);
    RegisterProperty('PageMode', 'TPdfPageMode', iptrw);
    RegisterProperty('ViewerPreference', 'TPdfViewerPreferences', iptrw);
    RegisterProperty('Pages', 'TPdfDictionary', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfDictionaryWrapper', 'TPdfInfo') do
  with CL.AddClassN(CL.FindClass('TPdfDictionaryWrapper'),'TPdfInfo') do begin
    RegisterProperty('Author', 'string', iptrw);
    RegisterProperty('CreationDate', 'TDateTime', iptrw);
    RegisterProperty('Creator', 'string', iptrw);
    RegisterProperty('Keywords', 'string', iptrw);
    RegisterProperty('ModDate', 'TDateTime', iptrw);
    RegisterProperty('Subject', 'string', iptrw);
    RegisterProperty('Title', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfDictionaryWrapper(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TPdfDictionaryWrapper') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TPdfDictionaryWrapper') do begin
    RegisterProperty('Data', 'TPdfDictionary', iptrw);
    RegisterProperty('HasData', 'boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfCanvas(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPdfCanvas') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPdfCanvas') do begin
    RegisterMethod('Constructor Create( APdfDoc : TPdfDocument)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure GSave');
    RegisterMethod('Procedure GRestore');
    RegisterMethod('Procedure ConcatToCTM( a, b, c, d, e, f : Single; Decimals : Cardinal)');
    RegisterMethod('Procedure SetFlat( flatness : Byte)');
    RegisterMethod('Procedure SetLineCap( linecap : TLineCapStyle)');
    RegisterMethod('Procedure SetDash( const aarray : array of integer; phase : integer)');
    RegisterMethod('Procedure SetLineJoin( linejoin : TLineJoinStyle)');
    RegisterMethod('Procedure SetLineWidth( linewidth : Single)');
    RegisterMethod('Procedure SetMiterLimit( miterlimit : Single)');
    RegisterMethod('Procedure MoveTo( x, y : Single)');
    RegisterMethod('Procedure LineTo( x, y : Single)');
    RegisterMethod('Procedure CurveToC( x1, y1, x2, y2, x3, y3 : Single)');
    RegisterMethod('Procedure CurveToV( x2, y2, x3, y3 : Single)');
    RegisterMethod('Procedure CurveToY( x1, y1, x3, y3 : Single)');
    RegisterMethod('Procedure Rectangle( x, y, width, height : Single)');
    RegisterMethod('Procedure Closepath');
    RegisterMethod('Procedure NewPath');
    RegisterMethod('Procedure Stroke');
    RegisterMethod('Procedure ClosePathStroke');
    RegisterMethod('Procedure Fill');
    RegisterMethod('Procedure EoFill');
    RegisterMethod('Procedure FillStroke');
    RegisterMethod('Procedure ClosepathFillStroke');
    RegisterMethod('Procedure EofillStroke');
    RegisterMethod('Procedure ClosepathEofillStroke');
    RegisterMethod('Procedure Clip');
    RegisterMethod('Procedure EoClip');
    RegisterMethod('Procedure SetCharSpace( charSpace : Single)');
    RegisterMethod('Procedure SetWordSpace( wordSpace : Single)');
    RegisterMethod('Procedure SetHorizontalScaling( hScaling : Single)');
    RegisterMethod('Procedure SetLeading( leading : Single)');
    RegisterMethod('Procedure SetFontAndSize( const fontshortcut : PDFString; size : Single)');
    RegisterMethod('Procedure SetTextRenderingMode( mode : TTextRenderingMode)');
    RegisterMethod('Procedure SetTextRise( rise : word)');
    RegisterMethod('Procedure BeginText');
    RegisterMethod('Procedure EndText');
    RegisterMethod('Procedure MoveTextPoint( tx, ty : Single)');
    RegisterMethod('Procedure SetTextMatrix( a, b, c, d, x, y : Single)');
    RegisterMethod('Procedure MoveToNextLine');
    RegisterMethod('Procedure ShowText( const text : UnicodeString; NextLine : boolean);');
    RegisterMethod('Procedure ShowText1( const text : PDFString; NextLine : boolean);');
    RegisterMethod('Procedure ShowText2( const text : PDFString; NextLine : boolean);');
    RegisterMethod('Procedure ShowText3( PW : PWideChar; NextLine : boolean);');
    RegisterMethod('Procedure ShowGlyph( PW : PWord; Count : integer)');
    RegisterMethod('Procedure ExecuteXObject( const xObject : PDFString)');
    RegisterMethod('Procedure SetRGBFillColor( Value : TPdfColor)');
    RegisterMethod('Procedure SetRGBStrokeColor( Value : TPdfColor)');
    RegisterMethod('Procedure SetCMYKFillColor( C, M, Y, K : integer)');
    RegisterMethod('Procedure SetCMYKStrokeColor( C, M, Y, K : integer)');
    RegisterMethod('Procedure SetPage( APage : TPdfPage)');
    RegisterMethod('Procedure SetPDFFont( AFont : TPdfFont; ASize : Single)');
    RegisterMethod('Function SetFont( const AName : RawUTF8; ASize : Single; AStyle : TFontStyles; ACharSet : integer; AForceTTF : integer; AIsFixedWidth : boolean) : TPdfFont;');
    RegisterMethod('Function SetFont1( ADC : HDC; const ALogFont : TLogFontW; ASize : single) : TPdfFont;');
    //RegisterMethod('Function SetFont2( const AName : RawUTF8; ASize : Single; AStyle : TFontStyles; ACharSet : integer; AForceTTF : integer; AIsFixedWidth : boolean) : TPdfFont;');
    RegisterMethod('Procedure TextOut( X, Y : Single; const Text : PDFString)');
    RegisterMethod('Procedure TextOutW( X, Y : Single; PW : PWideChar)');
    RegisterMethod('Procedure TextRect( ARect : TPdfRect; const Text : PDFString; Alignment : TPdfAlignment; Clipping : boolean)');
    RegisterMethod('Procedure MultilineTextRect( ARect : TPdfRect; const Text : PDFString; WordWrap : boolean)');
    RegisterMethod('Procedure DrawXObject( X, Y, AWidth, AHeight : Single; const AXObjectName : PDFString)');
    RegisterMethod('Procedure DrawXObjectEx( X, Y, AWidth, AHeight : Single; ClipX, ClipY, ClipWidth, ClipHeight : Single; const AXObjectName : PDFString)');
    RegisterMethod('Procedure Ellipse( x, y, width, height : Single)');
    RegisterMethod('Procedure RoundRect( x1, y1, x2, y2, cx, cy : Single)');
    RegisterMethod('Function TextWidth( const Text : PDFString) : Single');
    RegisterMethod('Function UnicodeTextWidth( PW : PWideChar) : Single');
    RegisterMethod('Function MeasureText( const Text : PDFString; AWidth : Single) : integer');
    RegisterMethod('Function GetNextWord( const S : PDFString; var Index : integer) : PDFString');
    RegisterMethod('Procedure RenderMetaFile( MF : TMetaFile; Scale : Single; XOff : single; YOff : single; UseSetTextJustification : boolean; KerningHScaleBottom : single; KerningHScaleTop : single)');
    RegisterProperty('Contents', 'TPdfStream', iptr);
    RegisterProperty('Page', 'TPdfPage', iptr);
    RegisterProperty('Doc', 'TPdfDocument', iptr);
    RegisterProperty('RightToLeftText', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfPage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfDictionary', 'TPdfPage') do
  with CL.AddClassN(CL.FindClass('TPdfDictionary'),'TPdfPage') do begin
    RegisterMethod('Constructor Create( ADoc : TPdfDocument)');
    RegisterMethod('Function TextWidth( const Text : PDFString) : Single');
    RegisterMethod('Function MeasureText( const Text : PDFString; Width : Single) : integer');
    RegisterProperty('WordSpace', 'Single', iptrw);
    RegisterProperty('CharSpace', 'Single', iptrw);
    RegisterProperty('HorizontalScaling', 'Single', iptrw);
    RegisterProperty('Leading', 'Single', iptrw);
    RegisterProperty('FontSize', 'Single', iptrw);
    RegisterProperty('Font', 'TPdfFont', iptrw);
    RegisterProperty('PageWidth', 'integer', iptrw);
    RegisterProperty('PageHeight', 'integer', iptrw);
    RegisterProperty('PageLandscape', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfDocument(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPdfDocument') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPdfDocument') do begin
    RegisterMethod('Constructor Create( AUseOutlines : Boolean; ACodePage : integer; APDFA1 : boolean; AEncryption : TPdfEncryption)');
    //RegisterMethod('Constructor Create(AUseOutlines : Boolean; ACodePage : integer; APDFA1 : boolean;)');
    RegisterMethod('Constructor Create1');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure NewDoc');
    RegisterMethod('Function AddPage : TPdfPage');
    RegisterMethod('Function CreatePages( Parent : TPdfDictionary) : TPdfDictionary');
    RegisterMethod('Function RegisterXObject( AObject : TPdfXObject; const AName : PDFString) : integer');
    RegisterMethod('Function AddXObject( const AName : PDFString; AXObject : TPdfXObject) : integer');
    RegisterMethod('Procedure SaveToStream( AStream : TStream; ForceModDate : TDateTime)');
    RegisterMethod('Procedure SaveToStreamDirectBegin( AStream : TStream; ForceModDate : TDateTime)');
    RegisterMethod('Procedure SaveToStreamDirectPageFlush');
    RegisterMethod('Procedure SaveToStreamDirectEnd');
    RegisterMethod('Function SaveToFile( const aFileName : TFileName) : boolean');
    RegisterMethod('Function GetXObject( const AName : PDFString) : TPdfXObject');
    RegisterMethod('Function GetXObjectIndex( const AName : PDFString) : integer');
    RegisterMethod('Function GetXObjectImageName( const Hash : TPdfImageHash; Width, Height : Integer) : PDFString');
    RegisterMethod('Function CreateAnnotation( AType : TPdfAnnotationSubType; const ARect : TPdfRect) : TPdfDictionary;');
    RegisterMethod('Function CreateLink( const ARect : TPdfRect; const aBookmarkName : RawUTF8) : TPdfDictionary');
    RegisterMethod('Function CreateOutline( const Title : string; Level : integer; TopPosition : Single) : TPdfOutlineEntry');
    RegisterMethod('Function CreateDestination : TPdfDestination');
    RegisterMethod('Procedure CreateBookMark( TopPosition : Single; const aBookmarkName : RawUTF8)');
    RegisterMethod('Function CreateOrGetImage( B : TBitmap; DrawAt : PPdfBox; ClipRc : PPdfBox) : PDFString');
    RegisterProperty('Canvas', 'TPdfCanvas', iptr);
    RegisterProperty('Info', 'TPdfInfo', iptr);
    RegisterProperty('Root', 'TPdfCatalog', iptr);
    RegisterProperty('OutlineRoot', 'TPdfOutlineRoot', iptr);
    RegisterProperty('DefaultPageWidth', 'cardinal', iptrw);
    RegisterProperty('DefaultPageHeight', 'cardinal', iptrw);
    RegisterProperty('DefaultPageLandscape', 'boolean', iptrw);
    RegisterProperty('DefaultPaperSize', 'TPDFPaperSize', iptrw);
    RegisterProperty('CompressionMethod', 'TPdfCompressionMethod', iptrw);
    RegisterProperty('EmbeddedTTF', 'boolean', iptrw);
    RegisterProperty('EmbeddedTTFIgnore', 'TRawUTF8List', iptr);
    RegisterProperty('EmbeddedWholeTTF', 'boolean', iptrw);
    RegisterProperty('UseOutlines', 'boolean', iptrw);
    RegisterProperty('CodePage', 'cardinal', iptr);
    RegisterProperty('CharSet', 'integer', iptr);
    RegisterProperty('StandardFontsReplace', 'boolean', iptrw);
    RegisterProperty('UseUniscribe', 'boolean', iptrw);
    RegisterProperty('UseFontFallBack', 'boolean', iptrw);
    RegisterProperty('FontFallBackName', 'string', iptrw);
    RegisterProperty('ForceJPEGCompression', 'integer', iptrw);
    RegisterProperty('ForceNoBitmapReuse', 'boolean', iptrw);
    RegisterProperty('RawPages', 'TList', iptr);
    RegisterProperty('ScreenLogPixels', 'Integer', iptrw);
    RegisterProperty('PDFA1', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfXref(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObjectMgr', 'TPdfXref') do
  with CL.AddClassN(CL.FindClass('TPdfObjectMgr'),'TPdfXref') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Items', 'TPdfXrefEntry integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('ItemCount', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfXrefEntry(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPdfXrefEntry') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPdfXrefEntry') do begin
    RegisterMethod('Constructor Create( AValue : TPdfObject)');
    RegisterMethod('Procedure SaveToPdfWrite( var W : TPdfWrite)');
    RegisterProperty('EntryType', 'PDFString', iptrw);
    RegisterProperty('ByteOffset', 'integer', iptr);
    RegisterProperty('GenerationNumber', 'integer', iptrw);
    RegisterProperty('Value', 'TPdfObject', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfTrailer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPdfTrailer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPdfTrailer') do begin
    RegisterMethod('Constructor Create( AObjectMgr : TPdfObjectMgr)');
    RegisterProperty('XrefAddress', 'integer', iptrw);
    RegisterProperty('Attributes', 'TPdfDictionary', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfBinary(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObject', 'TPdfBinary') do
  with CL.AddClassN(CL.FindClass('TPdfObject'),'TPdfBinary') do begin
    RegisterProperty('Stream', 'TMemoryStream', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObject', 'TPdfStream') do
  with CL.AddClassN(CL.FindClass('TPdfObject'),'TPdfStream') do begin
    RegisterMethod('Constructor Create( ADoc : TPdfDocument; DontAddToFXref : boolean)');
    RegisterProperty('Attributes', 'TPdfDictionary', iptr);
    RegisterProperty('Writer', 'TPdfWrite', iptr);
    RegisterProperty('Filter', 'TPdfArray', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfDictionary(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObject', 'TPdfDictionary') do
  with CL.AddClassN(CL.FindClass('TPdfObject'),'TPdfDictionary') do begin
    RegisterMethod('Constructor Create( AObjectMgr : TPdfObjectMgr)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function ValueByName( const AKey : PDFString) : TPdfObject');
    RegisterMethod('Function PdfBooleanByName( const AKey : PDFString) : TPdfBoolean');
    RegisterMethod('Function PdfNumberByName( const AKey : PDFString) : TPdfNumber');
    RegisterMethod('Function PdfTextByName( const AKey : PDFString) : TPdfText');
    RegisterMethod('Function PdfTextValueByName( const AKey : PDFString) : PDFString');
    RegisterMethod('Function PdfTextUTF8ValueByName( const AKey : PDFString) : RawUTF8');
    RegisterMethod('Function PdfTextStringValueByName( const AKey : PDFString) : string');
    RegisterMethod('Function PdfRealByName( const AKey : PDFString) : TPdfReal');
    RegisterMethod('Function PdfNameByName( const AKey : PDFString) : TPdfName');
    RegisterMethod('Function PdfDictionaryByName( const AKey : PDFString) : TPdfDictionary');
    RegisterMethod('Function PdfArrayByName( const AKey : PDFString) : TPdfArray');
    RegisterMethod('Procedure AddItem( const AKey : PDFString; AValue : TPdfObject; AInternal : Boolean);');
    RegisterMethod('Procedure AddItem1( const AKey, AValue : PDFString);');
    RegisterMethod('Procedure AddItem2( const AKey : PDFString; AValue : integer);');
    RegisterMethod('Procedure AddItemText( const AKey, AValue : PDFString);');
    RegisterMethod('Procedure AddItemTextUTF8( const AKey : PDFString; const AValue : RawUTF8);');
    RegisterMethod('Procedure AddItemTextString( const AKey : PDFString; const AValue : string);');
    RegisterMethod('Procedure RemoveItem( const AKey : PDFString)');
    RegisterProperty('Items', 'TPdfDictionaryElement integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('ItemCount', 'integer', iptr);
    RegisterProperty('ObjectMgr', 'TPdfObjectMgr', iptr);
    RegisterProperty('TypeOf', 'PDFString', iptr);
    RegisterProperty('List', 'TList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfDictionaryElement(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPdfDictionaryElement') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPdfDictionaryElement') do begin
    RegisterMethod('Constructor Create( const AKey : PDFString; AValue : TPdfObject; AInternal : Boolean)');
    RegisterProperty('Key', 'PDFString', iptr);
    RegisterProperty('Value', 'TPdfObject', iptr);
    RegisterProperty('IsInternal', 'boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObject', 'TPdfArray') do
  with CL.AddClassN(CL.FindClass('TPdfObject'),'TPdfArray') do begin
    RegisterMethod('Constructor Create( AObjectMgr : TPdfObjectMgr);');
    RegisterMethod('Constructor Create1( AObjectMgr : TPdfObjectMgr; const AArray : array of Integer);');
    RegisterMethod('Constructor Create2( AObjectMgr : TPdfObjectMgr; AArray : PWordArray; AArrayCount : integer);');
    RegisterMethod('Constructor CreateNames( AObjectMgr : TPdfObjectMgr; const AArray : array of PDFString);');
    RegisterMethod('Constructor CreateReals( AObjectMgr : TPdfObjectMgr; const AArray : array of double);');
    RegisterMethod('Function AddItem( AItem : TPdfObject) : integer');
    RegisterMethod('Function FindName( const AName : PDFString) : TPdfName');
    RegisterMethod('Function RemoveName( const AName : PDFString) : boolean');
    RegisterProperty('Items', 'TPdfObject integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('ItemCount', 'integer', iptr);
    RegisterProperty('ObjectMgr', 'TPdfObjectMgr', iptr);
    RegisterProperty('List', 'TList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfName(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfText', 'TPdfName') do
  with CL.AddClassN(CL.FindClass('TPdfText'),'TPdfName') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfRawText(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfText', 'TPdfRawText') do
  with CL.AddClassN(CL.FindClass('TPdfText'),'TPdfRawText') do begin
    RegisterMethod('Constructor CreateFmt( Fmt : PAnsiChar; const Args : array of Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfTextString(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfTextUTF8', 'TPdfTextString') do
  with CL.AddClassN(CL.FindClass('TPdfTextUTF8'),'TPdfTextString') do
  begin
    RegisterMethod('Constructor Create( const AValue : string)');
    RegisterProperty('Value', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfTextUTF8(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObject', 'TPdfTextUTF8') do
  with CL.AddClassN(CL.FindClass('TPdfObject'),'TPdfTextUTF8') do
  begin
    RegisterMethod('Constructor Create( const AValue : RawUTF8)');
    RegisterProperty('Value', 'RawUTF8', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfText(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObject', 'TPdfText') do
  with CL.AddClassN(CL.FindClass('TPdfObject'),'TPdfText') do begin
    RegisterMethod('Constructor Create( const AValue : PDFString)');
    RegisterProperty('Value', 'PDFString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfReal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObject', 'TPdfReal') do
  with CL.AddClassN(CL.FindClass('TPdfObject'),'TPdfReal') do
  begin
    RegisterMethod('Constructor Create( AValue : double)');
    RegisterProperty('Value', 'double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfNumber(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObject', 'TPdfNumber') do
  with CL.AddClassN(CL.FindClass('TPdfObject'),'TPdfNumber') do
  begin
    RegisterMethod('Constructor Create( AValue : Integer)');
    RegisterProperty('Value', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfNull(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObject', 'TPdfNull') do
  with CL.AddClassN(CL.FindClass('TPdfObject'),'TPdfNull') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfBoolean(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObject', 'TPdfBoolean') do
  with CL.AddClassN(CL.FindClass('TPdfObject'),'TPdfBoolean') do begin
    RegisterMethod('Constructor Create( AValue : Boolean)');
    RegisterProperty('Value', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfVirtualObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfObject', 'TPdfVirtualObject') do
  with CL.AddClassN(CL.FindClass('TPdfObject'),'TPdfVirtualObject') do
  begin
    RegisterMethod('Constructor Create( AObjectId : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPdfObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPdfObject') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure WriteTo( var W : TPdfWrite)');
    RegisterMethod('Procedure WriteValueTo( var W : TPdfWrite)');
    RegisterProperty('ObjectNumber', 'integer', iptrw);
    RegisterProperty('GenerationNumber', 'integer', iptr);
    RegisterProperty('ObjectType', 'TPdfObjectType', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfObjectMgr(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPdfObjectMgr') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPdfObjectMgr') do begin
    RegisterMethod('Procedure AddObject( AObject : TPdfObject)');
    RegisterMethod('Function GetObject( ObjectID : integer) : TPdfObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfWrite(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPdfWrite') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfWrite') do begin
    RegisterMethod('Constructor Create( DestStream : TStream; CodePage : integer)');
    RegisterMethod('Function Add( c : AnsiChar) : TPdfWrite;');
    RegisterMethod('Function Add1( Value : Integer) : TPdfWrite;');
    RegisterMethod('Function AddWithSpace( Value : Integer) : TPdfWrite;');
    RegisterMethod('Function Add2( Value, DigitCount : Integer) : TPdfWrite;');
    RegisterMethod('Function Add3( Value : Extended) : TPdfWrite;');
    RegisterMethod('Function AddWithSpace1( Value : Extended) : TPdfWrite;');
    RegisterMethod('Function AddWithSpace2( Value : Extended; Decimals : cardinal) : TPdfWrite;');
    RegisterMethod('Function Add4( Text : PAnsiChar; Len : integer) : TPdfWrite;');
    RegisterMethod('Function Add5( const Text : RawByteString) : TPdfWrite;');
    RegisterMethod('Function AddHex( const Bin : PDFString) : TPdfWrite');
    RegisterMethod('Function AddHex4( aWordValue : cardinal) : TPdfWrite');
    RegisterMethod('Function AddToUnicodeHex( const Text : PDFString) : TPdfWrite');
    RegisterMethod('Function AddUnicodeHex( PW : PWideChar; WideCharCount : integer) : TPdfWrite');
    RegisterMethod('Function AddToUnicodeHexText( const Text : PDFString; NextLine : boolean; Canvas : TPdfCanvas) : TPdfWrite');
    RegisterMethod('Function AddUnicodeHexText( PW : PWideChar; NextLine : boolean; Canvas : TPdfCanvas) : TPdfWrite');
    RegisterMethod('Function AddGlyphs( Glyphs : PWord; GlyphsCount : integer; Canvas : TPdfCanvas) : TPdfWrite');
    RegisterMethod('Function AddEscape( Text : PAnsiChar) : TPdfWrite');
    RegisterMethod('Function AddEscapeText( Text : PAnsiChar; Font : TPdfFont) : TPdfWrite');
    RegisterMethod('Function AddEscapeName( Text : PAnsiChar) : TPdfWrite');
    RegisterMethod('Function AddColorStr( Color : TColorRef) : TPdfWrite');
    RegisterMethod('Procedure AddRGB( P : PAnsiChar; PInc, Count : integer)');
    RegisterMethod('Function AddIso8601( DateTime : TDateTime) : TPdfWrite');
    RegisterMethod('Procedure Save');
    RegisterMethod('Function Position : Integer');
    RegisterMethod('Function ToPDFString : PDFString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfEncryptionRC4MD5(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPdfEncryption', 'TPdfEncryptionRC4MD5') do
  with CL.AddClassN(CL.FindClass('TPdfEncryption'),'TPdfEncryptionRC4MD5') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPdfEncryption(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPdfEncryption') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfEncryption') do
  begin
    RegisterMethod('Constructor Create( aLevel : TPdfEncryptionLevel; aPermissions : TPdfEncryptionPermissions; const aUserPassword, aOwnerPassword : string)');
    RegisterMethod('Function New( aLevel : TPdfEncryptionLevel; const aUserPassword, aOwnerPassword : string; aPermissions : TPdfEncryptionPermissions) : TPdfEncryption');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynPdf(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MWT_IDENTITY','LongInt').SetInt( 1);
 CL.AddConstantN('MWT_LEFTMULTIPLY','LongInt').SetInt( 2);
 CL.AddConstantN('MWT_RIGHTMULTIPLY','LongInt').SetInt( 3);
 CL.AddConstantN('MWT_SET','LongInt').SetInt( 4);
 CL.AddConstantN('MAX_INT64','Int64').SetInt64( 9223372036854775807);
  //CL.AddTypeS('PSmallIntArray', '^TSmallIntArray // will not work');
  //CL.AddTypeS('PPointArray', '^TPointArray // will not work');
  //CL.AddTypeS('PSmallPointArray', '^TSmallPointArray // will not work');
  CL.AddTypeS('TCmapHeader', 'record version : word; numberSubtables : word; end');
  CL.AddTypeS('TCmapHHEA', 'record version : longint; ascent : word; descent : '
   +'word; lineGap : word; advanceWidthMax : word; minLeftSideBearing : word; m'
   +'inRightSideBearing : word; xMaxExtent : word; caretSlopeRise : SmallInt; c'
   +'aretSlopeRun : SmallInt; caretOffset : SmallInt; reserved : Int64; metricD'
   +'ataFormat : SmallInt; numOfLongHorMetrics : word; end');
  CL.AddTypeS('TCmapHEAD', 'record version : longint; fontRevision : longint; c'
   +'heckSumAdjustment : cardinal; magicNumber : cardinal; flags : word; unitsP'
   +'erEm : word; createdDate : Int64; modifiedDate : Int64; xMin : SmallInt; y'
   +'Min : SmallInt; xMax : SmallInt; yMax : SmallInt; macStyle : word; lowestR'
   +'ec : word; fontDirection : SmallInt; indexToLocFormat : SmallInt; glyphDat'
   +'aFormat : SmallInt; end');
  CL.AddTypeS('TCmapFmt4', 'record format : word; length : word; language : wor'
   +'d; segCountX2 : word; searchRange : word; entrySelector : word; rangeShift: word; end');
  CL.AddTypeS('PDFString', 'AnsiString');
  CL.AddTypeS('TPdfDate', 'PDFString');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPdfInvalidValue');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPdfInvalidOperation');
  CL.AddTypeS('TPdfPageMode', '( pmUseNone, pmUseOutlines, pmUseThumbs, pmFullScreen )');
  CL.AddTypeS('TLineCapStyle', '( lcButt_End, lcRound_End, lcProjectingSquareEnd )');
  CL.AddTypeS('TLineJoinStyle', '( ljMiterJoin, ljRoundJoin, ljBevelJoin )');
  CL.AddTypeS('TTextRenderingMode', '( trFill, trStroke, trFillThenStroke, trIn'
   +'visible, trFillClipping, trStrokeClipping, trFillStrokeClipping, trClipping )');
  CL.AddTypeS('TPdfAnnotationSubType', '( asTextNotes, asLink )');
  CL.AddTypeS('TPdfDestinationType', '( dtXYZ, dtFit, dtFitH, dtFitV, dtFitR, d'
   +'tFitB, dtFitBH, dtFitBV )');
  CL.AddTypeS('TPdfPageLayout', '( plSinglePage, plOneColumn, plTwoColumnLeft, '
   +'plTwoColumnRight )');
  CL.AddTypeS('TPdfViewerPreference', '( vpHideToolbar, vpHideMenubar, vpHideWi'
   +'ndowUI, vpFitWindow, vpCenterWindow )');
  CL.AddTypeS('TPdfViewerPreferences', 'set of TPdfViewerPreference');
  CL.AddTypeS('TPDFPaperSize', '( psA4, psA5, psA3, psLetter, psLegal, psUserDefined )');
  CL.AddTypeS('TPdfCompressionMethod', '( cmNone, cmFlateDecode )');
  CL.AddTypeS('TXObjectID', 'integer');
 CL.AddConstantN('PDF_IN_USE_ENTRY','String').SetString( 'n');
 CL.AddConstantN('PDF_FREE_ENTRY','String').SetString( 'f');
 CL.AddConstantN('PDF_MAX_GENERATION_NUM','LongInt').SetInt( 65535);
 CL.AddConstantN('PDF_ENTRY_CLOSED','LongInt').SetInt( 0);
 CL.AddConstantN('PDF_ENTRY_OPENED','LongInt').SetInt( 1);
 CL.AddConstantN('CRLF','string').SetString(#13#10);
 CL.AddConstantN('LF','Char').SetString( #10);
 CL.AddConstantN('PDF_MIN_HORIZONTALSCALING','LongInt').SetInt( 10);
 CL.AddConstantN('PDF_MAX_HORIZONTALSCALING','LongInt').SetInt( 300);
 CL.AddConstantN('PDF_MAX_WORDSPACE','LongInt').SetInt( 300);
 CL.AddConstantN('PDF_MIN_CHARSPACE','LongInt').SetInt( - 30);
 CL.AddConstantN('PDF_MAX_CHARSPACE','LongInt').SetInt( 300);
 CL.AddConstantN('PDF_MAX_FONTSIZE','LongInt').SetInt( 2000);
 CL.AddConstantN('PDF_MAX_ZOOMSIZE','LongInt').SetInt( 10);
 CL.AddConstantN('PDF_MAX_LEADING','LongInt').SetInt( 300);
 //CL.AddConstantN('MSWINDOWS_DEFAULT_FONTS','RawUTF8').SetString( 'Arial' #13#10 'Courier New' #13#10 'Georgia' #13#10 + 'Impact' #13#10 'Lucida Console' #13#10 'Roman' #13#10 'Symbol' #13#10 + 'Tahoma' #13#10 'Times New Roman' #13#10 'Trebuchet' #13#10 + 'Verdana' #13#10 'WingDings');
  CL.AddTypeS('TPdfAlignment', '( paLeftJustify, paRightJustify, paCenter )');
  CL.AddTypeS('TGradientDirection', '( gdHorizontal, gdVertical )');
  CL.AddTypeS('TPdfRect', 'record Left : single; Top : single; Right : single; '
   +'Bottom : Single; end');
 // CL.AddTypeS('PPdfRect', '^TPdfRect // will not work');
  CL.AddTypeS('TPdfBox', 'record Left : single; Top : single; Width : single; H'
   +'eight : Single; end');
  //CL.AddTypeS('PPdfBox', '^TPdfBox // will not work');
  CL.AddTypeS('TPdfObjectType', '( otDirectObject, otIndirectObject, otVirtualObject )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfObject');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfCanvas');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfFont');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfFontTrueType');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfDocument');
  CL.AddTypeS('TPdfEncryptionLevel', '( elNone, elRC4_40, elRC4_128 )');
  CL.AddTypeS('TPdfEncryptionPermission', '( epPrinting, epGeneralEditing, epCo'
   +'ntentCopy, epAuthoringComment, epPrintingHighResolution, epFillingForms, e'
   +'pContentExtraction, epDocumentAssembly )');
  CL.AddTypeS('TPdfEncryptionPermissions', 'set of TPdfEncryptionPermission');
  SIRegister_TPdfEncryption(CL);
  SIRegister_TPdfEncryptionRC4MD5(CL);
  SIRegister_TPdfWrite(CL);
  SIRegister_TPdfObjectMgr(CL);
  SIRegister_TPdfObject(CL);
  SIRegister_TPdfVirtualObject(CL);
  SIRegister_TPdfBoolean(CL);
  SIRegister_TPdfNull(CL);
  SIRegister_TPdfNumber(CL);
  SIRegister_TPdfReal(CL);
  SIRegister_TPdfText(CL);
  SIRegister_TPdfTextUTF8(CL);
  SIRegister_TPdfTextString(CL);
  SIRegister_TPdfRawText(CL);
  SIRegister_TPdfName(CL);
  SIRegister_TPdfArray(CL);
  SIRegister_TPdfDictionaryElement(CL);
  SIRegister_TPdfDictionary(CL);
  SIRegister_TPdfStream(CL);
  SIRegister_TPdfBinary(CL);
  SIRegister_TPdfTrailer(CL);
  SIRegister_TPdfXrefEntry(CL);
  SIRegister_TPdfXref(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfXObject');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfOutlines');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfInfo');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfCatalog');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfDestination');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfOutlineEntry');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfOutlineRoot');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPdfPage');
  //CL.AddTypeS('TPdfPageClass', 'class of TPdfPage');
  SIRegister_TPdfDocument(CL);
  SIRegister_TPdfPage(CL);
  SIRegister_TPdfCanvas(CL);
  SIRegister_TPdfDictionaryWrapper(CL);
  CL.AddTypeS('TPdfGDIComment', '( pgcOutline, pgcBookmark, pgcLink )');
  CL.AddTypeS('RawUTF8', 'AnsiString');
  //RawUTF8 = type AnsiString
  SIRegister_TPdfInfo(CL);
  SIRegister_TPdfCatalog(CL);
  SIRegister_TPdfFont(CL);
  //CL.AddTypeS('PPdfWinAnsiWidth', '^TPdfWinAnsiWidth // will not work');
  SIRegister_TPdfFontWinAnsi(CL);
  SIRegister_TPdfFontType1(CL);
  SIRegister_TPdfFontCIDFontType2(CL);
  SIRegister_TPdfTTF(CL);
  SIRegister_TPdfFontTrueType(CL);
  SIRegister_TPdfDestination(CL);
  SIRegister_TPdfOutlineEntry(CL);
  SIRegister_TPdfOutlineRoot(CL);
  SIRegister_TPdfPageGDI(CL);
  SIRegister_TPdfDocumentGDI(CL);
  SIRegister_TPdfImage(CL);
  SIRegister_TPdfForm(CL);
 //CL.AddDelphiFunction('Function _HasMultiByteString( Value : PAnsiChar) : boolean');
 CL.AddDelphiFunction('Function RawUTF8ToPDFString( const Value : RawUTF8) : PDFString');
 CL.AddDelphiFunction('Function _DateTimeToPdfDate( ADate : TDateTime) : TPdfDate');
 CL.AddDelphiFunction('Function _PdfDateToDateTime( const AText : TPdfDate) : TDateTime');
 CL.AddDelphiFunction('Function PdfRect( Left, Top, Right, Bottom : Single) : TPdfRect;');
 CL.AddDelphiFunction('Function PdfRect1( const Box : TPdfBox) : TPdfRect;');
 CL.AddDelphiFunction('Function PdfBox( Left, Top, Width, Height : Single) : TPdfBox');
 //CL.AddDelphiFunction('Function _GetCharCount( Text : PAnsiChar) : integer');
 //CL.AddDelphiFunction('Procedure L2R( W : PWideChar; L : integer)');
 CL.AddDelphiFunction('Function PdfCoord( MM : single) : integer');
 CL.AddDelphiFunction('Function CurrentPrinterPaperSize : TPDFPaperSize');
 CL.AddDelphiFunction('Function CurrentPrinterRes : TPoint');
 CL.AddDelphiFunction('Procedure GDICommentBookmark( MetaHandle : HDC; const aBookmarkName : RawUTF8)');
 CL.AddDelphiFunction('Procedure GDICommentOutline( MetaHandle : HDC; const aTitle : RawUTF8; aLevel : Integer)');
 CL.AddDelphiFunction('Procedure GDICommentLink( MetaHandle : HDC; const aBookmarkName : RawUTF8; const aRect : TRect)');
 CL.AddConstantN('Usp10','String').SetString( 'usp10.dll');
  CL.AddTypeS('TScriptState_enum', '( rr0, rr1, rr2, rr3, rr4, fOverrideDirection, f'
   +'InhibitSymSwap, fCharShape, fDigitSubstitute, fInhibitLigate, fDisplayZWG,'
   +' fArabicNumContext, fGcpClusters )');
  CL.AddTypeS('TScriptState_set', 'set of TScriptState_enum');
  //CL.AddTypeS('PScriptState', '^TScriptState // will not work');
  CL.AddTypeS('TScriptAnalysis_enum', '( ss0, ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9'
   +', fRTL, fLayoutRTL, fLinkBefore, fLinkAfter, fLogicalOrder, fNoGlyphIndex)');
  CL.AddTypeS('TScriptAnalysis_set', 'set of TScriptAnalysis_enum');
  //CL.AddTypeS('PScriptAnalysis', '^TScriptAnalysis // will not work');
  //CL.AddTypeS('PScriptItem', '^TScriptItem // will not work');
  //CL.AddTypeS('TScriptItem', 'record iCharPos : Integer; a : TScriptAnalysis; end');
  CL.AddTypeS('TScriptProperties_enum', '( fNumeric, fComplex, fNeedsWordBreaki'
   +'ng, fNeedsCaretInfo, bCharSet0, bCharSet1, bCharSet2, bCharSet3, bCharSet4'
   +', bCharSet5, bCharSet6, bCharSet7, fControl, fPrivateUseArea, fNeedsCharac'
   +'terJustify, fInvalidGlyph, fInvalidLogAttr, fCDM, fAmbiguousCharSet, fClus'
   +'terSizeVaries, fRejectInvalid )');
  CL.AddTypeS('TScriptProperties_set', 'set of TScriptProperties_enum');
  //CL.AddTypeS('PScriptProperties', '^TScriptProperties // will not work');
  CL.AddTypeS('TScriptProperties', 'record langid : Word; fFlags : TScriptProperties_set; end');
  //CL.AddTypeS('PScriptPropertiesArray', '^TPScriptPropertiesArray // will not work');
  CL.AddTypeS('TScriptVisAttr_enum', '( aa0, aa1, aa2, aa3, fClusterStart, fDiacrit'
   +'ic, fZeroWidth, fReserved )');
  CL.AddTypeS('TScriptVisAttr_set', 'set of TScriptVisAttr_enum');
  //CL.AddTypeS('PScriptVisAttr', '^TScriptVisAttr // will not work');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function PdfRect1_P( const Box : TPdfBox) : TPdfRect;
Begin Result := SynPdf.PdfRect(Box); END;

(*----------------------------------------------------------------------------*)
Function PdfRect_P( Left, Top, Right, Bottom : Single) : TPdfRect;
Begin Result := SynPdf.PdfRect(Left, Top, Right, Bottom); END;

(*----------------------------------------------------------------------------*)
procedure TPdfImagePixelHeight_R(Self: TPdfImage; var T: Integer);
begin T := Self.PixelHeight; end;

(*----------------------------------------------------------------------------*)
procedure TPdfImagePixelWidth_R(Self: TPdfImage; var T: Integer);
begin T := Self.PixelWidth; end;

(*----------------------------------------------------------------------------*)
Function TPdfImageCreateJpegDirect1_P(Self: TClass; CreateNewInstance: Boolean;  aDoc : TPdfDocument; aJpegFile : TMemoryStream; DontAddToFXref : boolean):TObject;
Begin Result := TPdfImage.CreateJpegDirect(aDoc, aJpegFile, DontAddToFXref); END;

(*----------------------------------------------------------------------------*)
Function TPdfImageCreateJpegDirect_P(Self: TClass; CreateNewInstance: Boolean;  aDoc : TPdfDocument; const aJpegFileName : TFileName; DontAddToFXref : boolean):TObject;
Begin Result := TPdfImage.CreateJpegDirect(aDoc, aJpegFileName, DontAddToFXref); END;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentGDIKerningHScaleTop_W(Self: TPdfDocumentGDI; const T: Single);
begin Self.KerningHScaleTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentGDIKerningHScaleTop_R(Self: TPdfDocumentGDI; var T: Single);
begin T := Self.KerningHScaleTop; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentGDIKerningHScaleBottom_W(Self: TPdfDocumentGDI; const T: Single);
begin Self.KerningHScaleBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentGDIKerningHScaleBottom_R(Self: TPdfDocumentGDI; var T: Single);
begin T := Self.KerningHScaleBottom; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentGDIUseSetTextJustification_W(Self: TPdfDocumentGDI; const T: Boolean);
begin Self.UseSetTextJustification := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentGDIUseSetTextJustification_R(Self: TPdfDocumentGDI; var T: Boolean);
begin T := Self.UseSetTextJustification; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentGDIVCLCanvasSize_R(Self: TPdfDocumentGDI; var T: TSize);
begin T := Self.VCLCanvasSize; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentGDIVCLCanvas_R(Self: TPdfDocumentGDI; var T: TCanvas);
begin T := Self.VCLCanvas; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryLevel_W(Self: TPdfOutlineEntry; const T: integer);
begin Self.Level := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryLevel_R(Self: TPdfOutlineEntry; var T: integer);
begin T := Self.Level; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryReference_W(Self: TPdfOutlineEntry; const T: TObject);
begin Self.Reference := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryReference_R(Self: TPdfOutlineEntry; var T: TObject);
begin T := Self.Reference; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryOpened_W(Self: TPdfOutlineEntry; const T: boolean);
begin Self.Opened := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryOpened_R(Self: TPdfOutlineEntry; var T: boolean);
begin T := Self.Opened; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryTitle_W(Self: TPdfOutlineEntry; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryTitle_R(Self: TPdfOutlineEntry; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryDest_W(Self: TPdfOutlineEntry; const T: TPdfDestination);
begin Self.Dest := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryDest_R(Self: TPdfOutlineEntry; var T: TPdfDestination);
begin T := Self.Dest; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryLast_R(Self: TPdfOutlineEntry; var T: TPdfOutlineEntry);
begin T := Self.Last; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryFirst_R(Self: TPdfOutlineEntry; var T: TPdfOutlineEntry);
begin T := Self.First; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryPrev_R(Self: TPdfOutlineEntry; var T: TPdfOutlineEntry);
begin T := Self.Prev; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryNext_R(Self: TPdfOutlineEntry; var T: TPdfOutlineEntry);
begin T := Self.Next; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryParent_R(Self: TPdfOutlineEntry; var T: TPdfOutlineEntry);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TPdfOutlineEntryDoc_R(Self: TPdfOutlineEntry; var T: TPdfDocument);
begin T := Self.Doc; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationReference_W(Self: TPdfDestination; const T: TObject);
begin Self.Reference := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationReference_R(Self: TPdfDestination; var T: TObject);
begin T := Self.Reference; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationZoom_W(Self: TPdfDestination; const T: Single);
begin Self.Zoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationZoom_R(Self: TPdfDestination; var T: Single);
begin T := Self.Zoom; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationPageWidth_R(Self: TPdfDestination; var T: Integer);
begin T := Self.PageWidth; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationPageHeight_R(Self: TPdfDestination; var T: Integer);
begin T := Self.PageHeight; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationBottom_W(Self: TPdfDestination; const T: Integer);
begin Self.Bottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationBottom_R(Self: TPdfDestination; var T: Integer);
begin T := Self.Bottom; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationRight_W(Self: TPdfDestination; const T: Integer);
begin Self.Right := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationRight_R(Self: TPdfDestination; var T: Integer);
begin T := Self.Right; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationTop_W(Self: TPdfDestination; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationTop_R(Self: TPdfDestination; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationLeft_W(Self: TPdfDestination; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationLeft_R(Self: TPdfDestination; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationPage_R(Self: TPdfDestination; var T: TPdfPage);
begin T := Self.Page; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationDoc_R(Self: TPdfDestination; var T: TPdfDocument);
begin T := Self.Doc; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationDestinationType_W(Self: TPdfDestination; const T: TPdfDestinationType);
begin Self.DestinationType := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDestinationDestinationType_R(Self: TPdfDestination; var T: TPdfDestinationType);
begin T := Self.DestinationType; end;

(*----------------------------------------------------------------------------*)
procedure TPdfFontTrueTypeWinAnsiFont_R(Self: TPdfFontTrueType; var T: TPdfFontTrueType);
begin T := Self.WinAnsiFont; end;

(*----------------------------------------------------------------------------*)
procedure TPdfFontTrueTypeUnicodeFont_R(Self: TPdfFontTrueType; var T: TPdfFontTrueType);
begin T := Self.UnicodeFont; end;

(*----------------------------------------------------------------------------*)
procedure TPdfFontTrueTypeFixedWidth_R(Self: TPdfFontTrueType; var T: boolean);
begin T := Self.FixedWidth; end;

(*----------------------------------------------------------------------------*)
procedure TPdfFontTrueTypeStyle_R(Self: TPdfFontTrueType; var T: TFontStyles);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TPdfFontTrueTypeWideCharUsed_R(Self: TPdfFontTrueType; var T: Boolean);
begin T := Self.WideCharUsed; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTTFglyphIndexArray_W(Self: TPdfTTF; const T: PWordArray);
Begin Self.glyphIndexArray := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTTFglyphIndexArray_R(Self: TPdfTTF; var T: PWordArray);
Begin T := Self.glyphIndexArray; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTTFidRangeOffset_W(Self: TPdfTTF; const T: PWordArray);
Begin Self.idRangeOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTTFidRangeOffset_R(Self: TPdfTTF; var T: PWordArray);
Begin T := Self.idRangeOffset; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTTFidDelta_W(Self: TPdfTTF; const T: PSmallIntArray);
Begin Self.idDelta := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTTFidDelta_R(Self: TPdfTTF; var T: PSmallIntArray);
Begin T := Self.idDelta; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTTFendCode_W(Self: TPdfTTF; const T: PWordArray);
Begin Self.endCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTTFendCode_R(Self: TPdfTTF; var T: PWordArray);
Begin T := Self.endCode; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTTFstartCode_W(Self: TPdfTTF; const T: PWordArray);
Begin Self.startCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTTFstartCode_R(Self: TPdfTTF; var T: PWordArray);
Begin T := Self.startCode; end;

(*procedure TPdfTTFfmt4_W(Self: TPdfTTF; const T:  ^TCmapFmt4 // will not work);
Begin Self.fmt4 := T; end;

procedure TPdfTTFfmt4_R(Self: TPdfTTF; var T:  ^TCmapFmt4 // will not work);
Begin T := Self.fmt4; end;

procedure TPdfTTFhhea_W(Self: TPdfTTF; const T:  ^TCmapHHEA // will not work);
Begin Self.hhea := T; end;

procedure TPdfTTFhhea_R(Self: TPdfTTF; var T:  ^TCmapHHEA // will not work);
Begin T := Self.hhea; end;

procedure TPdfTTFhead_W(Self: TPdfTTF; const T:  ^TCmapHEAD // will not work);
Begin Self.head := T; end;

procedure TPdfTTFhead_R(Self: TPdfTTF; var T:  ^TCmapHEAD // will not work);
Begin T := Self.head; end; *)

(*----------------------------------------------------------------------------*)
procedure TPdfFontUnicode_R(Self: TPdfFont; var T: boolean);
begin T := Self.Unicode; end;

(*----------------------------------------------------------------------------*)
procedure TPdfFontShortCut_R(Self: TPdfFont; var T: PDFString);
begin T := Self.ShortCut; end;

(*----------------------------------------------------------------------------*)
procedure TPdfFontName_R(Self: TPdfFont; var T: PDFString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogPages_W(Self: TPdfCatalog; const T: TPdfDictionary);
begin Self.Pages := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogPages_R(Self: TPdfCatalog; var T: TPdfDictionary);
begin T := Self.Pages; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogViewerPreference_W(Self: TPdfCatalog; const T: TPdfViewerPreferences);
begin Self.ViewerPreference := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogViewerPreference_R(Self: TPdfCatalog; var T: TPdfViewerPreferences);
begin T := Self.ViewerPreference; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogPageMode_W(Self: TPdfCatalog; const T: TPdfPageMode);
begin Self.PageMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogPageMode_R(Self: TPdfCatalog; var T: TPdfPageMode);
begin T := Self.PageMode; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogNonFullScreenPageMode_W(Self: TPdfCatalog; const T: TPdfPageMode);
begin Self.NonFullScreenPageMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogNonFullScreenPageMode_R(Self: TPdfCatalog; var T: TPdfPageMode);
begin T := Self.NonFullScreenPageMode; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogPageLayout_W(Self: TPdfCatalog; const T: TPdfPageLayout);
begin Self.PageLayout := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogPageLayout_R(Self: TPdfCatalog; var T: TPdfPageLayout);
begin T := Self.PageLayout; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogOpenAction_W(Self: TPdfCatalog; const T: TPdfDestination);
begin Self.OpenAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCatalogOpenAction_R(Self: TPdfCatalog; var T: TPdfDestination);
begin T := Self.OpenAction; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoTitle_W(Self: TPdfInfo; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoTitle_R(Self: TPdfInfo; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoSubject_W(Self: TPdfInfo; const T: string);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoSubject_R(Self: TPdfInfo; var T: string);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoModDate_W(Self: TPdfInfo; const T: TDateTime);
begin Self.ModDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoModDate_R(Self: TPdfInfo; var T: TDateTime);
begin T := Self.ModDate; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoKeywords_W(Self: TPdfInfo; const T: string);
begin Self.Keywords := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoKeywords_R(Self: TPdfInfo; var T: string);
begin T := Self.Keywords; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoCreator_W(Self: TPdfInfo; const T: string);
begin Self.Creator := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoCreator_R(Self: TPdfInfo; var T: string);
begin T := Self.Creator; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoCreationDate_W(Self: TPdfInfo; const T: TDateTime);
begin Self.CreationDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoCreationDate_R(Self: TPdfInfo; var T: TDateTime);
begin T := Self.CreationDate; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoAuthor_W(Self: TPdfInfo; const T: string);
begin Self.Author := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfInfoAuthor_R(Self: TPdfInfo; var T: string);
begin T := Self.Author; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDictionaryWrapperHasData_R(Self: TPdfDictionaryWrapper; var T: boolean);
begin T := Self.HasData; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDictionaryWrapperData_W(Self: TPdfDictionaryWrapper; const T: TPdfDictionary);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDictionaryWrapperData_R(Self: TPdfDictionaryWrapper; var T: TPdfDictionary);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCanvasRightToLeftText_W(Self: TPdfCanvas; const T: Boolean);
begin Self.RightToLeftText := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPdfCanvasRightToLeftText_R(Self: TPdfCanvas; var T: Boolean);
begin T := Self.RightToLeftText;
 end;

(*----------------------------------------------------------------------------*)
procedure TPdfCanvasDoc_R(Self: TPdfCanvas; var T: TPdfDocument);
begin T := Self.Doc; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCanvasPage_R(Self: TPdfCanvas; var T: TPdfPage);
begin T := Self.Page; end;

(*----------------------------------------------------------------------------*)
procedure TPdfCanvasContents_R(Self: TPdfCanvas; var T: TPdfStream);
begin T := Self.Contents; end;

(*----------------------------------------------------------------------------*)
Function TPdfCanvasSetFont1_P(Self: TPdfCanvas;  ADC : HDC; const ALogFont : TLogFontW; ASize : single) : TPdfFont;
Begin Result := Self.SetFont(ADC, ALogFont, ASize); END;

(*----------------------------------------------------------------------------*)
Function TPdfCanvasSetFont_P(Self: TPdfCanvas;  const AName : RawUTF8; ASize : Single; AStyle : TFontStyles; ACharSet : integer; AForceTTF : integer; AIsFixedWidth : boolean) : TPdfFont;
Begin Result := Self.SetFont(AName, ASize, AStyle, ACharSet, AForceTTF, AIsFixedWidth); END;

(*----------------------------------------------------------------------------*)
Procedure TPdfCanvasShowText3_P(Self: TPdfCanvas;  PW : PWideChar; NextLine : boolean);
Begin Self.ShowText(PW, NextLine); END;

(*----------------------------------------------------------------------------*)
Procedure TPdfCanvasShowText2_P(Self: TPdfCanvas;  const text : PDFString; NextLine : boolean);
Begin Self.ShowText(text, NextLine); END;

(*----------------------------------------------------------------------------*)
Procedure TPdfCanvasShowText1_P(Self: TPdfCanvas;  const text : PDFString; NextLine : boolean);
Begin Self.ShowText(text, NextLine); END;

(*----------------------------------------------------------------------------*)
Procedure TPdfCanvasShowText_P(Self: TPdfCanvas;  const text : String; NextLine : boolean);
Begin Self.ShowText(text, NextLine); END;

(*----------------------------------------------------------------------------*)
Procedure TPdfCanvasMoveToI1_P(Self: TPdfCanvas;  x, y : Single);
Begin
  Self.MoveTo(x, y);
END;

(*----------------------------------------------------------------------------*)
Procedure TPdfCanvasMoveToI_P(Self: TPdfCanvas;  x, y : Integer);
Begin
  Self.MoveTo(x, y);
END;

(*----------------------------------------------------------------------------*)
Procedure TPdfCanvasLineToI1_P(Self: TPdfCanvas;  x, y : Single);
Begin Self.LineTo(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure TPdfCanvasLineToI_P(Self: TPdfCanvas;  x, y : Integer);
Begin Self.LineTo(x, y); END;

(*----------------------------------------------------------------------------*)
Function TPdfCanvasI2Y1_P(Self: TPdfCanvas;  Y : Single) : Single;
Begin //Result := Self.I2Y(Y);
 END;

(*----------------------------------------------------------------------------*)
Function TPdfCanvasI2Y_P(Self: TPdfCanvas;  Y : Integer) : Single;
Begin //Result := Self.I2Y(Y);
END;

(*----------------------------------------------------------------------------*)
Function TPdfCanvasI2X1_P(Self: TPdfCanvas;  X : Single) : Single;
Begin //Result := Self.I2X(X);
 END;

(*----------------------------------------------------------------------------*)
Function TPdfCanvasI2X_P(Self: TPdfCanvas;  X : Integer) : Single;
Begin //Result := Self.I2X(X);
END;

(*----------------------------------------------------------------------------*)
procedure TPdfPagePageLandscape_W(Self: TPdfPage; const T: Boolean);
begin Self.PageLandscape := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPagePageLandscape_R(Self: TPdfPage; var T: Boolean);
begin T := Self.PageLandscape; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPagePageHeight_W(Self: TPdfPage; const T: integer);
begin Self.PageHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPagePageHeight_R(Self: TPdfPage; var T: integer);
begin T := Self.PageHeight; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPagePageWidth_W(Self: TPdfPage; const T: integer);
begin Self.PageWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPagePageWidth_R(Self: TPdfPage; var T: integer);
begin T := Self.PageWidth; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageFont_W(Self: TPdfPage; const T: TPdfFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageFont_R(Self: TPdfPage; var T: TPdfFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageFontSize_W(Self: TPdfPage; const T: Single);
begin Self.FontSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageFontSize_R(Self: TPdfPage; var T: Single);
begin T := Self.FontSize; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageLeading_W(Self: TPdfPage; const T: Single);
begin Self.Leading := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageLeading_R(Self: TPdfPage; var T: Single);
begin T := Self.Leading; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageHorizontalScaling_W(Self: TPdfPage; const T: Single);
begin Self.HorizontalScaling := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageHorizontalScaling_R(Self: TPdfPage; var T: Single);
begin T := Self.HorizontalScaling; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageCharSpace_W(Self: TPdfPage; const T: Single);
begin Self.CharSpace := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageCharSpace_R(Self: TPdfPage; var T: Single);
begin T := Self.CharSpace; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageWordSpace_W(Self: TPdfPage; const T: Single);
begin Self.WordSpace := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfPageWordSpace_R(Self: TPdfPage; var T: Single);
begin T := Self.WordSpace; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentPDFA1_W(Self: TPdfDocument; const T: boolean);
begin Self.PDFA1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentPDFA1_R(Self: TPdfDocument; var T: boolean);
begin T := Self.PDFA1; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentScreenLogPixels_W(Self: TPdfDocument; const T: Integer);
begin Self.ScreenLogPixels := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentScreenLogPixels_R(Self: TPdfDocument; var T: Integer);
begin T := Self.ScreenLogPixels; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentRawPages_R(Self: TPdfDocument; var T: TList);
begin T := Self.RawPages; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentForceNoBitmapReuse_W(Self: TPdfDocument; const T: boolean);
begin Self.ForceNoBitmapReuse := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentForceNoBitmapReuse_R(Self: TPdfDocument; var T: boolean);
begin T := Self.ForceNoBitmapReuse; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentForceJPEGCompression_W(Self: TPdfDocument; const T: integer);
begin Self.ForceJPEGCompression := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentForceJPEGCompression_R(Self: TPdfDocument; var T: integer);
begin T := Self.ForceJPEGCompression; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentFontFallBackName_W(Self: TPdfDocument; const T: string);
begin Self.FontFallBackName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentFontFallBackName_R(Self: TPdfDocument; var T: string);
begin T := Self.FontFallBackName; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentUseFontFallBack_W(Self: TPdfDocument; const T: boolean);
begin Self.UseFontFallBack := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentUseFontFallBack_R(Self: TPdfDocument; var T: boolean);
begin T := Self.UseFontFallBack; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentUseUniscribe_W(Self: TPdfDocument; const T: boolean);
begin Self.UseUniscribe := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentUseUniscribe_R(Self: TPdfDocument; var T: boolean);
begin T:= Self.UseUniscribe;
 end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentStandardFontsReplace_W(Self: TPdfDocument; const T: boolean);
begin Self.StandardFontsReplace := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentStandardFontsReplace_R(Self: TPdfDocument; var T: boolean);
begin T := Self.StandardFontsReplace; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentCharSet_R(Self: TPdfDocument; var T: integer);
begin T := Self.CharSet; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentCodePage_R(Self: TPdfDocument; var T: cardinal);
begin T := Self.CodePage; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentUseOutlines_W(Self: TPdfDocument; const T: boolean);
begin Self.UseOutlines := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentUseOutlines_R(Self: TPdfDocument; var T: boolean);
begin T := Self.UseOutlines; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentEmbeddedWholeTTF_W(Self: TPdfDocument; const T: boolean);
begin Self.EmbeddedWholeTTF := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentEmbeddedWholeTTF_R(Self: TPdfDocument; var T: boolean);
begin T := Self.EmbeddedWholeTTF; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentEmbeddedTTFIgnore_R(Self: TPdfDocument; var T: TRawUTF8List);
begin T := Self.EmbeddedTTFIgnore; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentEmbeddedTTF_W(Self: TPdfDocument; const T: boolean);
begin Self.EmbeddedTTF := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentEmbeddedTTF_R(Self: TPdfDocument; var T: boolean);
begin T := Self.EmbeddedTTF; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentCompressionMethod_W(Self: TPdfDocument; const T: TPdfCompressionMethod);
begin Self.CompressionMethod := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentCompressionMethod_R(Self: TPdfDocument; var T: TPdfCompressionMethod);
begin T := Self.CompressionMethod; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentDefaultPaperSize_W(Self: TPdfDocument; const T: TPDFPaperSize);
begin Self.DefaultPaperSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentDefaultPaperSize_R(Self: TPdfDocument; var T: TPDFPaperSize);
begin T := Self.DefaultPaperSize; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentDefaultPageLandscape_W(Self: TPdfDocument; const T: boolean);
begin Self.DefaultPageLandscape := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentDefaultPageLandscape_R(Self: TPdfDocument; var T: boolean);
begin T := Self.DefaultPageLandscape; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentDefaultPageHeight_W(Self: TPdfDocument; const T: cardinal);
begin Self.DefaultPageHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentDefaultPageHeight_R(Self: TPdfDocument; var T: cardinal);
begin T := Self.DefaultPageHeight; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentDefaultPageWidth_W(Self: TPdfDocument; const T: cardinal);
begin Self.DefaultPageWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentDefaultPageWidth_R(Self: TPdfDocument; var T: cardinal);
begin T := Self.DefaultPageWidth; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentOutlineRoot_R(Self: TPdfDocument; var T: TPdfOutlineRoot);
begin T := Self.OutlineRoot; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentRoot_R(Self: TPdfDocument; var T: TPdfCatalog);
begin T := Self.Root; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentInfo_R(Self: TPdfDocument; var T: TPdfInfo);
begin T := Self.Info; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDocumentCanvas_R(Self: TPdfDocument; var T: TPdfCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
Function TPdfDocumentCreateAnnotation_P(Self: TPdfDocument;  AType : TPdfAnnotationSubType; const ARect : TPdfRect) : TPdfDictionary;
Begin Result := Self.CreateAnnotation(AType, ARect); END;

(*----------------------------------------------------------------------------*)
Function TPdfDocumentGetRegisteredTrueTypeFont1_P(Self: TPdfDocument;  const AFontLog : TLogFontW) : TPdfFont;
Begin //Result := Self.GetRegisteredTrueTypeFont(AFontLog);
END;

(*----------------------------------------------------------------------------*)
Function TPdfDocumentGetRegisteredTrueTypeFont_P(Self: TPdfDocument;  AFontIndex : integer; AStyle : TFontStyles; ACharSet : byte) : TPdfFont;
Begin //Result := Self.GetRegisteredTrueTypeFont(AFontIndex, AStyle, ACharSet);
END;

(*----------------------------------------------------------------------------*)
procedure TPdfXrefItemCount_R(Self: TPdfXref; var T: integer);
begin T := Self.ItemCount; end;

(*----------------------------------------------------------------------------*)
procedure TPdfXrefItems_R(Self: TPdfXref; var T: TPdfXrefEntry; const t1: integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPdfXrefEntryValue_R(Self: TPdfXrefEntry; var T: TPdfObject);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TPdfXrefEntryGenerationNumber_W(Self: TPdfXrefEntry; const T: integer);
begin Self.GenerationNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfXrefEntryGenerationNumber_R(Self: TPdfXrefEntry; var T: integer);
begin T := Self.GenerationNumber; end;

(*----------------------------------------------------------------------------*)
procedure TPdfXrefEntryByteOffset_R(Self: TPdfXrefEntry; var T: integer);
begin T := Self.ByteOffset; end;

(*----------------------------------------------------------------------------*)
procedure TPdfXrefEntryEntryType_W(Self: TPdfXrefEntry; const T: PDFString);
begin Self.EntryType := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfXrefEntryEntryType_R(Self: TPdfXrefEntry; var T: PDFString);
begin T := Self.EntryType; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTrailerAttributes_R(Self: TPdfTrailer; var T: TPdfDictionary);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTrailerXrefAddress_W(Self: TPdfTrailer; const T: integer);
begin Self.XrefAddress := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTrailerXrefAddress_R(Self: TPdfTrailer; var T: integer);
begin T := Self.XrefAddress; end;

(*----------------------------------------------------------------------------*)
procedure TPdfBinaryStream_R(Self: TPdfBinary; var T: TMemoryStream);
begin T := Self.Stream; end;

(*----------------------------------------------------------------------------*)
procedure TPdfStreamFilter_R(Self: TPdfStream; var T: TPdfArray);
begin T := Self.Filter; end;

(*----------------------------------------------------------------------------*)
procedure TPdfStreamWriter_R(Self: TPdfStream; var T: TPdfWrite);
begin T := Self.Writer; end;

(*----------------------------------------------------------------------------*)
procedure TPdfStreamAttributes_R(Self: TPdfStream; var T: TPdfDictionary);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDictionaryList_R(Self: TPdfDictionary; var T: TList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDictionaryTypeOf_R(Self: TPdfDictionary; var T: PDFString);
begin T := Self.TypeOf; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDictionaryObjectMgr_R(Self: TPdfDictionary; var T: TPdfObjectMgr);
begin T := Self.ObjectMgr; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDictionaryItemCount_R(Self: TPdfDictionary; var T: integer);
begin T := Self.ItemCount; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDictionaryItems_R(Self: TPdfDictionary; var T: TPdfDictionaryElement; const t1: integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TPdfDictionaryAddItemTextString_P(Self: TPdfDictionary;  const AKey : PDFString; const AValue : string);
Begin Self.AddItemTextString(AKey, AValue); END;

(*----------------------------------------------------------------------------*)
Procedure TPdfDictionaryAddItemTextUTF8_P(Self: TPdfDictionary;  const AKey : PDFString; const AValue : RawUTF8);
Begin Self.AddItemTextUTF8(AKey, AValue); END;

(*----------------------------------------------------------------------------*)
Procedure TPdfDictionaryAddItemText_P(Self: TPdfDictionary;  const AKey, AValue : PDFString);
Begin Self.AddItemText(AKey, AValue); END;

(*----------------------------------------------------------------------------*)
Procedure TPdfDictionaryAddItem2_P(Self: TPdfDictionary;  const AKey : PDFString; AValue : integer);
Begin Self.AddItem(AKey, AValue); END;

(*----------------------------------------------------------------------------*)
Procedure TPdfDictionaryAddItem1_P(Self: TPdfDictionary;  const AKey, AValue : PDFString);
Begin Self.AddItem(AKey, AValue); END;

(*----------------------------------------------------------------------------*)
Procedure TPdfDictionaryAddItem_P(Self: TPdfDictionary;  const AKey : PDFString; AValue : TPdfObject; AInternal : Boolean);
Begin Self.AddItem(AKey, AValue, AInternal); END;

(*----------------------------------------------------------------------------*)
procedure TPdfDictionaryElementIsInternal_R(Self: TPdfDictionaryElement; var T: boolean);
begin T := Self.IsInternal; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDictionaryElementValue_R(Self: TPdfDictionaryElement; var T: TPdfObject);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TPdfDictionaryElementKey_R(Self: TPdfDictionaryElement; var T: PDFString);
begin T := Self.Key; end;

(*----------------------------------------------------------------------------*)
procedure TPdfArrayList_R(Self: TPdfArray; var T: TList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TPdfArrayObjectMgr_R(Self: TPdfArray; var T: TPdfObjectMgr);
begin T := Self.ObjectMgr; end;

(*----------------------------------------------------------------------------*)
procedure TPdfArrayItemCount_R(Self: TPdfArray; var T: integer);
begin T := Self.ItemCount; end;

(*----------------------------------------------------------------------------*)
procedure TPdfArrayItems_R(Self: TPdfArray; var T: TPdfObject; const t1: integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TPdfArrayCreateReals_P(Self: TClass; CreateNewInstance: Boolean;  AObjectMgr : TPdfObjectMgr; const AArray : array of double):TObject;
Begin Result := TPdfArray.CreateReals(AObjectMgr, AArray); END;

(*----------------------------------------------------------------------------*)
Function TPdfArrayCreateNames_P(Self: TClass; CreateNewInstance: Boolean;  AObjectMgr : TPdfObjectMgr; const AArray : array of PDFString):TObject;
Begin Result := TPdfArray.CreateNames(AObjectMgr, AArray); END;

(*----------------------------------------------------------------------------*)
Function TPdfArrayCreate2_P(Self: TClass; CreateNewInstance: Boolean;  AObjectMgr : TPdfObjectMgr; AArray : PWordArray; AArrayCount : integer):TObject;
Begin Result := TPdfArray.Create(AObjectMgr, AArray, AArrayCount); END;

(*----------------------------------------------------------------------------*)
Function TPdfArrayCreate1_P(Self: TClass; CreateNewInstance: Boolean;  AObjectMgr : TPdfObjectMgr; const AArray : array of Integer):TObject;
Begin Result := TPdfArray.Create(AObjectMgr, AArray); END;

(*----------------------------------------------------------------------------*)
Function TPdfArrayCreate_P(Self: TClass; CreateNewInstance: Boolean;  AObjectMgr : TPdfObjectMgr):TObject;
Begin Result := TPdfArray.Create(AObjectMgr); END;

(*----------------------------------------------------------------------------*)
procedure TPdfTextStringValue_W(Self: TPdfTextString; const T: string);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTextStringValue_R(Self: TPdfTextString; var T: string);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTextUTF8Value_W(Self: TPdfTextUTF8; const T: RawUTF8);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTextUTF8Value_R(Self: TPdfTextUTF8; var T: RawUTF8);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTextValue_W(Self: TPdfText; const T: PDFString);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfTextValue_R(Self: TPdfText; var T: PDFString);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TPdfRealValue_W(Self: TPdfReal; const T: double);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfRealValue_R(Self: TPdfReal; var T: double);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TPdfNumberValue_W(Self: TPdfNumber; const T: integer);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfNumberValue_R(Self: TPdfNumber; var T: integer);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TPdfBooleanValue_W(Self: TPdfBoolean; const T: boolean);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfBooleanValue_R(Self: TPdfBoolean; var T: boolean);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TPdfObjectObjectType_R(Self: TPdfObject; var T: TPdfObjectType);
begin T := Self.ObjectType; end;

(*----------------------------------------------------------------------------*)
procedure TPdfObjectGenerationNumber_R(Self: TPdfObject; var T: integer);
begin T := Self.GenerationNumber; end;

(*----------------------------------------------------------------------------*)
procedure TPdfObjectObjectNumber_W(Self: TPdfObject; const T: integer);
begin Self.ObjectNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TPdfObjectObjectNumber_R(Self: TPdfObject; var T: integer);
begin T := Self.ObjectNumber; end;

(*----------------------------------------------------------------------------*)
Function TPdfWriteAdd5_P(Self: TPdfWrite;  const Text : RawByteString) : TPdfWrite;
Begin Result := Self.Add(Text); END;

(*----------------------------------------------------------------------------*)
Function TPdfWriteAdd4_P(Self: TPdfWrite;  Text : PAnsiChar; Len : integer) : TPdfWrite;
Begin Result := Self.Add(Text, Len); END;

(*----------------------------------------------------------------------------*)
Function TPdfWriteAddWithSpace2_P(Self: TPdfWrite;  Value : Extended; Decimals : cardinal) : TPdfWrite;
Begin Result := Self.AddWithSpace(Value, Decimals); END;

(*----------------------------------------------------------------------------*)
Function TPdfWriteAddWithSpace1_P(Self: TPdfWrite;  Value : Extended) : TPdfWrite;
Begin Result := Self.AddWithSpace(Value); END;

(*----------------------------------------------------------------------------*)
Function TPdfWriteAdd3_P(Self: TPdfWrite;  Value : Extended) : TPdfWrite;
Begin Result := Self.Add(Value); END;

(*----------------------------------------------------------------------------*)
Function TPdfWriteAdd2_P(Self: TPdfWrite;  Value, DigitCount : Integer) : TPdfWrite;
Begin Result := Self.Add(Value, DigitCount); END;

(*----------------------------------------------------------------------------*)
Function TPdfWriteAddWithSpace_P(Self: TPdfWrite;  Value : Integer) : TPdfWrite;
Begin Result := Self.AddWithSpace(Value); END;

(*----------------------------------------------------------------------------*)
Function TPdfWriteAdd1_P(Self: TPdfWrite;  Value : Integer) : TPdfWrite;
Begin Result := Self.Add(Value); END;

(*----------------------------------------------------------------------------*)
Function TPdfWriteAdd_P(Self: TPdfWrite;  c : AnsiChar) : TPdfWrite;
Begin Result := Self.Add(c); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynPdf_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@_HasMultiByteString, '_HasMultiByteString', cdRegister);
 S.RegisterDelphiFunction(@RawUTF8ToPDFString, 'RawUTF8ToPDFString', cdRegister);
 S.RegisterDelphiFunction(@_DateTimeToPdfDate, '_DateTimeToPdfDate', cdRegister);
 S.RegisterDelphiFunction(@_PdfDateToDateTime, '_PdfDateToDateTime', cdRegister);
 S.RegisterDelphiFunction(@PdfRect, 'PdfRect', cdRegister);
 S.RegisterDelphiFunction(@PdfRect1_P, 'PdfRect1', cdRegister);
 S.RegisterDelphiFunction(@PdfBox, 'PdfBox', cdRegister);
 S.RegisterDelphiFunction(@_GetCharCount, '_GetCharCount', cdRegister);
 S.RegisterDelphiFunction(@L2R, 'L2R', cdRegister);
 S.RegisterDelphiFunction(@PdfCoord, 'PdfCoord', cdRegister);
 S.RegisterDelphiFunction(@CurrentPrinterPaperSize, 'CurrentPrinterPaperSize', cdRegister);
 S.RegisterDelphiFunction(@CurrentPrinterRes, 'CurrentPrinterRes', cdRegister);
 S.RegisterDelphiFunction(@GDICommentBookmark, 'GDICommentBookmark', cdRegister);
 S.RegisterDelphiFunction(@GDICommentOutline, 'GDICommentOutline', cdRegister);
 S.RegisterDelphiFunction(@GDICommentLink, 'GDICommentLink', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfForm) do begin
    RegisterConstructor(@TPdfForm.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfImage) do begin
    RegisterConstructor(@TPdfImage.Create, 'Create');
    RegisterConstructor(@TPdfImageCreateJpegDirect_P, 'CreateJpegDirect');
    RegisterConstructor(@TPdfImageCreateJpegDirect1_P, 'CreateJpegDirect1');
    RegisterPropertyHelper(@TPdfImagePixelWidth_R,nil,'PixelWidth');
    RegisterPropertyHelper(@TPdfImagePixelHeight_R,nil,'PixelHeight');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfDocumentGDI(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfDocumentGDI) do begin
    RegisterConstructor(@TPdfDocumentGDI.Create, 'Create');
    RegisterPropertyHelper(@TPdfDocumentGDIVCLCanvas_R,nil,'VCLCanvas');
    RegisterPropertyHelper(@TPdfDocumentGDIVCLCanvasSize_R,nil,'VCLCanvasSize');
    RegisterPropertyHelper(@TPdfDocumentGDIUseSetTextJustification_R,@TPdfDocumentGDIUseSetTextJustification_W,'UseSetTextJustification');
    RegisterPropertyHelper(@TPdfDocumentGDIKerningHScaleBottom_R,@TPdfDocumentGDIKerningHScaleBottom_W,'KerningHScaleBottom');
    RegisterPropertyHelper(@TPdfDocumentGDIKerningHScaleTop_R,@TPdfDocumentGDIKerningHScaleTop_W,'KerningHScaleTop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfPageGDI(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfPageGDI) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfOutlineRoot(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfOutlineRoot) do
  begin
    RegisterConstructor(@TPdfOutlineRoot.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfOutlineEntry(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfOutlineEntry) do begin
    RegisterConstructor(@TPdfOutlineEntry.Create, 'Create');
    RegisterMethod(@TPdfOutlineEntry.AddChild, 'AddChild');
    RegisterPropertyHelper(@TPdfOutlineEntryDoc_R,nil,'Doc');
    RegisterPropertyHelper(@TPdfOutlineEntryParent_R,nil,'Parent');
    RegisterPropertyHelper(@TPdfOutlineEntryNext_R,nil,'Next');
    RegisterPropertyHelper(@TPdfOutlineEntryPrev_R,nil,'Prev');
    RegisterPropertyHelper(@TPdfOutlineEntryFirst_R,nil,'First');
    RegisterPropertyHelper(@TPdfOutlineEntryLast_R,nil,'Last');
    RegisterPropertyHelper(@TPdfOutlineEntryDest_R,@TPdfOutlineEntryDest_W,'Dest');
    RegisterPropertyHelper(@TPdfOutlineEntryTitle_R,@TPdfOutlineEntryTitle_W,'Title');
    RegisterPropertyHelper(@TPdfOutlineEntryOpened_R,@TPdfOutlineEntryOpened_W,'Opened');
    RegisterPropertyHelper(@TPdfOutlineEntryReference_R,@TPdfOutlineEntryReference_W,'Reference');
    RegisterPropertyHelper(@TPdfOutlineEntryLevel_R,@TPdfOutlineEntryLevel_W,'Level');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfDestination(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfDestination) do begin
    RegisterConstructor(@TPdfDestination.Create, 'Create');
    RegisterMethod(@TPdfDestination.GetValue, 'GetValue');
    RegisterPropertyHelper(@TPdfDestinationDestinationType_R,@TPdfDestinationDestinationType_W,'DestinationType');
    RegisterPropertyHelper(@TPdfDestinationDoc_R,nil,'Doc');
    RegisterPropertyHelper(@TPdfDestinationPage_R,nil,'Page');
    RegisterPropertyHelper(@TPdfDestinationLeft_R,@TPdfDestinationLeft_W,'Left');
    RegisterPropertyHelper(@TPdfDestinationTop_R,@TPdfDestinationTop_W,'Top');
    RegisterPropertyHelper(@TPdfDestinationRight_R,@TPdfDestinationRight_W,'Right');
    RegisterPropertyHelper(@TPdfDestinationBottom_R,@TPdfDestinationBottom_W,'Bottom');
    RegisterPropertyHelper(@TPdfDestinationPageHeight_R,nil,'PageHeight');
    RegisterPropertyHelper(@TPdfDestinationPageWidth_R,nil,'PageWidth');
    RegisterPropertyHelper(@TPdfDestinationZoom_R,@TPdfDestinationZoom_W,'Zoom');
    RegisterPropertyHelper(@TPdfDestinationReference_R,@TPdfDestinationReference_W,'Reference');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfFontTrueType(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfFontTrueType) do begin
    RegisterConstructor(@TPdfFontTrueType.Create, 'Create');
    RegisterMethod(@TPdfFontTrueType.FindOrAddUsedWideChar, 'FindOrAddUsedWideChar');
    RegisterMethod(@TPdfFontTrueType.GetWideCharWidth, 'GetWideCharWidth');
    RegisterPropertyHelper(@TPdfFontTrueTypeWideCharUsed_R,nil,'WideCharUsed');
    RegisterPropertyHelper(@TPdfFontTrueTypeStyle_R,nil,'Style');
    RegisterPropertyHelper(@TPdfFontTrueTypeFixedWidth_R,nil,'FixedWidth');
    RegisterPropertyHelper(@TPdfFontTrueTypeUnicodeFont_R,nil,'UnicodeFont');
    RegisterPropertyHelper(@TPdfFontTrueTypeWinAnsiFont_R,nil,'WinAnsiFont');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfTTF(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfTTF) do begin
    //RegisterPropertyHelper(@TPdfTTFhead_R,@TPdfTTFhead_W,'head');
    //RegisterPropertyHelper(@TPdfTTFhhea_R,@TPdfTTFhhea_W,'hhea');
    //RegisterPropertyHelper(@TPdfTTFfmt4_R,@TPdfTTFfmt4_W,'fmt4');
    RegisterPropertyHelper(@TPdfTTFstartCode_R,@TPdfTTFstartCode_W,'startCode');
    RegisterPropertyHelper(@TPdfTTFendCode_R,@TPdfTTFendCode_W,'endCode');
    RegisterPropertyHelper(@TPdfTTFidDelta_R,@TPdfTTFidDelta_W,'idDelta');
    RegisterPropertyHelper(@TPdfTTFidRangeOffset_R,@TPdfTTFidRangeOffset_W,'idRangeOffset');
    RegisterPropertyHelper(@TPdfTTFglyphIndexArray_R,@TPdfTTFglyphIndexArray_W,'glyphIndexArray');
    RegisterConstructor(@TPdfTTF.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfFontCIDFontType2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfFontCIDFontType2) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfFontType1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfFontType1) do
  begin
    RegisterConstructor(@TPdfFontType1.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfFontWinAnsi(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfFontWinAnsi) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfFont(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfFont) do begin
    RegisterConstructor(@TPdfFont.Create, 'Create');
    RegisterMethod(@TPdfFont.AddUsedWinAnsiChar, 'AddUsedWinAnsiChar');
    RegisterVirtualMethod(@TPdfFont.GetAnsiCharWidth, 'GetAnsiCharWidth');
    RegisterPropertyHelper(@TPdfFontName_R,nil,'Name');
    RegisterPropertyHelper(@TPdfFontShortCut_R,nil,'ShortCut');
    RegisterPropertyHelper(@TPdfFontUnicode_R,nil,'Unicode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfCatalog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfCatalog) do begin
    RegisterPropertyHelper(@TPdfCatalogOpenAction_R,@TPdfCatalogOpenAction_W,'OpenAction');
    RegisterPropertyHelper(@TPdfCatalogPageLayout_R,@TPdfCatalogPageLayout_W,'PageLayout');
    RegisterPropertyHelper(@TPdfCatalogNonFullScreenPageMode_R,@TPdfCatalogNonFullScreenPageMode_W,'NonFullScreenPageMode');
    RegisterPropertyHelper(@TPdfCatalogPageMode_R,@TPdfCatalogPageMode_W,'PageMode');
    RegisterPropertyHelper(@TPdfCatalogViewerPreference_R,@TPdfCatalogViewerPreference_W,'ViewerPreference');
    RegisterPropertyHelper(@TPdfCatalogPages_R,@TPdfCatalogPages_W,'Pages');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfInfo) do begin
    RegisterPropertyHelper(@TPdfInfoAuthor_R,@TPdfInfoAuthor_W,'Author');
    RegisterPropertyHelper(@TPdfInfoCreationDate_R,@TPdfInfoCreationDate_W,'CreationDate');
    RegisterPropertyHelper(@TPdfInfoCreator_R,@TPdfInfoCreator_W,'Creator');
    RegisterPropertyHelper(@TPdfInfoKeywords_R,@TPdfInfoKeywords_W,'Keywords');
    RegisterPropertyHelper(@TPdfInfoModDate_R,@TPdfInfoModDate_W,'ModDate');
    RegisterPropertyHelper(@TPdfInfoSubject_R,@TPdfInfoSubject_W,'Subject');
    RegisterPropertyHelper(@TPdfInfoTitle_R,@TPdfInfoTitle_W,'Title');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfDictionaryWrapper(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfDictionaryWrapper) do begin
    RegisterPropertyHelper(@TPdfDictionaryWrapperData_R,@TPdfDictionaryWrapperData_W,'Data');
    RegisterPropertyHelper(@TPdfDictionaryWrapperHasData_R,nil,'HasData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfCanvas(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfCanvas) do begin
    RegisterConstructor(@TPdfCanvas.Create, 'Create');
    RegisterMethod(@TPdfCanvas.Destroy, 'Free');
    RegisterMethod(@TPdfCanvas.GSave, 'GSave');
    RegisterMethod(@TPdfCanvas.GRestore, 'GRestore');
    RegisterMethod(@TPdfCanvas.ConcatToCTM, 'ConcatToCTM');
    RegisterMethod(@TPdfCanvas.SetFlat, 'SetFlat');
    RegisterMethod(@TPdfCanvas.SetLineCap, 'SetLineCap');
    RegisterMethod(@TPdfCanvas.SetDash, 'SetDash');
    RegisterMethod(@TPdfCanvas.SetLineJoin, 'SetLineJoin');
    RegisterMethod(@TPdfCanvas.SetLineWidth, 'SetLineWidth');
    RegisterMethod(@TPdfCanvas.SetMiterLimit, 'SetMiterLimit');
    RegisterMethod(@TPdfCanvas.MoveTo, 'MoveTo');
    RegisterMethod(@TPdfCanvas.LineTo, 'LineTo');
    RegisterMethod(@TPdfCanvas.CurveToC, 'CurveToC');
    RegisterMethod(@TPdfCanvas.CurveToV, 'CurveToV');
    RegisterMethod(@TPdfCanvas.CurveToY, 'CurveToY');
    RegisterMethod(@TPdfCanvas.Rectangle, 'Rectangle');
    RegisterMethod(@TPdfCanvas.Closepath, 'Closepath');
    RegisterMethod(@TPdfCanvas.NewPath, 'NewPath');
    RegisterMethod(@TPdfCanvas.Stroke, 'Stroke');
    RegisterMethod(@TPdfCanvas.ClosePathStroke, 'ClosePathStroke');
    RegisterMethod(@TPdfCanvas.Fill, 'Fill');
    RegisterMethod(@TPdfCanvas.EoFill, 'EoFill');
    RegisterMethod(@TPdfCanvas.FillStroke, 'FillStroke');
    RegisterMethod(@TPdfCanvas.ClosepathFillStroke, 'ClosepathFillStroke');
    RegisterMethod(@TPdfCanvas.EofillStroke, 'EofillStroke');
    RegisterMethod(@TPdfCanvas.ClosepathEofillStroke, 'ClosepathEofillStroke');
    RegisterMethod(@TPdfCanvas.Clip, 'Clip');
    RegisterMethod(@TPdfCanvas.EoClip, 'EoClip');
    RegisterMethod(@TPdfCanvas.SetCharSpace, 'SetCharSpace');
    RegisterMethod(@TPdfCanvas.SetWordSpace, 'SetWordSpace');
    RegisterMethod(@TPdfCanvas.SetHorizontalScaling, 'SetHorizontalScaling');
    RegisterMethod(@TPdfCanvas.SetLeading, 'SetLeading');
    RegisterMethod(@TPdfCanvas.SetFontAndSize, 'SetFontAndSize');
    RegisterMethod(@TPdfCanvas.SetTextRenderingMode, 'SetTextRenderingMode');
    RegisterMethod(@TPdfCanvas.SetTextRise, 'SetTextRise');
    RegisterMethod(@TPdfCanvas.BeginText, 'BeginText');
    RegisterMethod(@TPdfCanvas.EndText, 'EndText');
    RegisterMethod(@TPdfCanvas.MoveTextPoint, 'MoveTextPoint');
    RegisterMethod(@TPdfCanvas.SetTextMatrix, 'SetTextMatrix');
    RegisterMethod(@TPdfCanvas.MoveToNextLine, 'MoveToNextLine');
    RegisterMethod(@TPdfCanvasShowText_P, 'ShowText');
    RegisterMethod(@TPdfCanvasShowText1_P, 'ShowText1');
    RegisterMethod(@TPdfCanvasShowText2_P, 'ShowText2');
    RegisterMethod(@TPdfCanvasShowText3_P, 'ShowText3');
    RegisterMethod(@TPdfCanvas.ShowGlyph, 'ShowGlyph');
    RegisterMethod(@TPdfCanvas.ExecuteXObject, 'ExecuteXObject');
    RegisterMethod(@TPdfCanvas.SetRGBFillColor, 'SetRGBFillColor');
    RegisterMethod(@TPdfCanvas.SetRGBStrokeColor, 'SetRGBStrokeColor');
    RegisterMethod(@TPdfCanvas.SetCMYKFillColor, 'SetCMYKFillColor');
    RegisterMethod(@TPdfCanvas.SetCMYKStrokeColor, 'SetCMYKStrokeColor');
    RegisterVirtualMethod(@TPdfCanvas.SetPage, 'SetPage');
    RegisterMethod(@TPdfCanvas.SetPDFFont, 'SetPDFFont');
    RegisterMethod(@TPdfCanvasSetFont_P, 'SetFont');
    RegisterMethod(@TPdfCanvasSetFont1_P, 'SetFont1');
    RegisterMethod(@TPdfCanvas.TextOut, 'TextOut');
    RegisterMethod(@TPdfCanvas.TextOutW, 'TextOutW');
    RegisterMethod(@TPdfCanvas.TextRect, 'TextRect');
    RegisterMethod(@TPdfCanvas.MultilineTextRect, 'MultilineTextRect');
    RegisterMethod(@TPdfCanvas.DrawXObject, 'DrawXObject');
    RegisterMethod(@TPdfCanvas.DrawXObjectEx, 'DrawXObjectEx');
    RegisterMethod(@TPdfCanvas.Ellipse, 'Ellipse');
    RegisterMethod(@TPdfCanvas.RoundRect, 'RoundRect');
    RegisterMethod(@TPdfCanvas.TextWidth, 'TextWidth');
    RegisterMethod(@TPdfCanvas.UnicodeTextWidth, 'UnicodeTextWidth');
    RegisterMethod(@TPdfCanvas.MeasureText, 'MeasureText');
    RegisterMethod(@TPdfCanvas.GetNextWord, 'GetNextWord');
    RegisterMethod(@TPdfCanvas.RenderMetaFile, 'RenderMetaFile');
    RegisterPropertyHelper(@TPdfCanvasContents_R,nil,'Contents');
    RegisterPropertyHelper(@TPdfCanvasPage_R,nil,'Page');
    RegisterPropertyHelper(@TPdfCanvasDoc_R,nil,'Doc');
    RegisterPropertyHelper(@TPdfCanvasRightToLeftText_R,@TPdfCanvasRightToLeftText_W,'RightToLeftText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfPage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfPage) do begin
    RegisterConstructor(@TPdfPage.Create, 'Create');
    RegisterMethod(@TPdfPage.TextWidth, 'TextWidth');
    RegisterMethod(@TPdfPage.MeasureText, 'MeasureText');
    RegisterPropertyHelper(@TPdfPageWordSpace_R,@TPdfPageWordSpace_W,'WordSpace');
    RegisterPropertyHelper(@TPdfPageCharSpace_R,@TPdfPageCharSpace_W,'CharSpace');
    RegisterPropertyHelper(@TPdfPageHorizontalScaling_R,@TPdfPageHorizontalScaling_W,'HorizontalScaling');
    RegisterPropertyHelper(@TPdfPageLeading_R,@TPdfPageLeading_W,'Leading');
    RegisterPropertyHelper(@TPdfPageFontSize_R,@TPdfPageFontSize_W,'FontSize');
    RegisterPropertyHelper(@TPdfPageFont_R,@TPdfPageFont_W,'Font');
    RegisterPropertyHelper(@TPdfPagePageWidth_R,@TPdfPagePageWidth_W,'PageWidth');
    RegisterPropertyHelper(@TPdfPagePageHeight_R,@TPdfPagePageHeight_W,'PageHeight');
    RegisterPropertyHelper(@TPdfPagePageLandscape_R,@TPdfPagePageLandscape_W,'PageLandscape');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfDocument(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfDocument) do begin
    RegisterConstructor(@TPdfDocument.Create, 'Create');
    RegisterConstructor(@TPdfDocument.Create, 'Create1');
    RegisterMethod(@TPdfDocument.Destroy, 'Free');
    RegisterMethod(@TPdfDocument.NewDoc, 'NewDoc');
    RegisterVirtualMethod(@TPdfDocument.AddPage, 'AddPage');
    RegisterMethod(@TPdfDocument.CreatePages, 'CreatePages');
    RegisterMethod(@TPdfDocument.RegisterXObject, 'RegisterXObject');
    RegisterMethod(@TPdfDocument.AddXObject, 'AddXObject');
    RegisterVirtualMethod(@TPdfDocument.SaveToStream, 'SaveToStream');
    RegisterMethod(@TPdfDocument.SaveToStreamDirectBegin, 'SaveToStreamDirectBegin');
    RegisterMethod(@TPdfDocument.SaveToStreamDirectPageFlush, 'SaveToStreamDirectPageFlush');
    RegisterMethod(@TPdfDocument.SaveToStreamDirectEnd, 'SaveToStreamDirectEnd');
    RegisterMethod(@TPdfDocument.SaveToFile, 'SaveToFile');
    RegisterMethod(@TPdfDocument.GetXObject, 'GetXObject');
    RegisterMethod(@TPdfDocument.GetXObjectIndex, 'GetXObjectIndex');
    RegisterMethod(@TPdfDocument.GetXObjectImageName, 'GetXObjectImageName');
    RegisterMethod(@TPdfDocumentCreateAnnotation_P, 'CreateAnnotation');
    RegisterMethod(@TPdfDocument.CreateLink, 'CreateLink');
    RegisterMethod(@TPdfDocument.CreateOutline, 'CreateOutline');
    RegisterMethod(@TPdfDocument.CreateDestination, 'CreateDestination');
    RegisterMethod(@TPdfDocument.CreateBookMark, 'CreateBookMark');
    RegisterMethod(@TPdfDocument.CreateOrGetImage, 'CreateOrGetImage');
    RegisterPropertyHelper(@TPdfDocumentCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TPdfDocumentInfo_R,nil,'Info');
    RegisterPropertyHelper(@TPdfDocumentRoot_R,nil,'Root');
    RegisterPropertyHelper(@TPdfDocumentOutlineRoot_R,nil,'OutlineRoot');
    RegisterPropertyHelper(@TPdfDocumentDefaultPageWidth_R,@TPdfDocumentDefaultPageWidth_W,'DefaultPageWidth');
    RegisterPropertyHelper(@TPdfDocumentDefaultPageHeight_R,@TPdfDocumentDefaultPageHeight_W,'DefaultPageHeight');
    RegisterPropertyHelper(@TPdfDocumentDefaultPageLandscape_R,@TPdfDocumentDefaultPageLandscape_W,'DefaultPageLandscape');
    RegisterPropertyHelper(@TPdfDocumentDefaultPaperSize_R,@TPdfDocumentDefaultPaperSize_W,'DefaultPaperSize');
    RegisterPropertyHelper(@TPdfDocumentCompressionMethod_R,@TPdfDocumentCompressionMethod_W,'CompressionMethod');
    RegisterPropertyHelper(@TPdfDocumentEmbeddedTTF_R,@TPdfDocumentEmbeddedTTF_W,'EmbeddedTTF');
    RegisterPropertyHelper(@TPdfDocumentEmbeddedTTFIgnore_R,nil,'EmbeddedTTFIgnore');
    RegisterPropertyHelper(@TPdfDocumentEmbeddedWholeTTF_R,@TPdfDocumentEmbeddedWholeTTF_W,'EmbeddedWholeTTF');
    RegisterPropertyHelper(@TPdfDocumentUseOutlines_R,@TPdfDocumentUseOutlines_W,'UseOutlines');
    RegisterPropertyHelper(@TPdfDocumentCodePage_R,nil,'CodePage');
    RegisterPropertyHelper(@TPdfDocumentCharSet_R,nil,'CharSet');
    RegisterPropertyHelper(@TPdfDocumentStandardFontsReplace_R,@TPdfDocumentStandardFontsReplace_W,'StandardFontsReplace');
    RegisterPropertyHelper(@TPdfDocumentUseUniscribe_R,@TPdfDocumentUseUniscribe_W,'UseUniscribe');
    RegisterPropertyHelper(@TPdfDocumentUseFontFallBack_R,@TPdfDocumentUseFontFallBack_W,'UseFontFallBack');
    RegisterPropertyHelper(@TPdfDocumentFontFallBackName_R,@TPdfDocumentFontFallBackName_W,'FontFallBackName');
    RegisterPropertyHelper(@TPdfDocumentForceJPEGCompression_R,@TPdfDocumentForceJPEGCompression_W,'ForceJPEGCompression');
    RegisterPropertyHelper(@TPdfDocumentForceNoBitmapReuse_R,@TPdfDocumentForceNoBitmapReuse_W,'ForceNoBitmapReuse');
    RegisterPropertyHelper(@TPdfDocumentRawPages_R,nil,'RawPages');
    RegisterPropertyHelper(@TPdfDocumentScreenLogPixels_R,@TPdfDocumentScreenLogPixels_W,'ScreenLogPixels');
    RegisterPropertyHelper(@TPdfDocumentPDFA1_R,@TPdfDocumentPDFA1_W,'PDFA1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfXref(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfXref) do begin
    RegisterConstructor(@TPdfXref.Create, 'Create');
    RegisterPropertyHelper(@TPdfXrefItems_R,nil,'Items');
    RegisterPropertyHelper(@TPdfXrefItemCount_R,nil,'ItemCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfXrefEntry(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfXrefEntry) do begin
    RegisterConstructor(@TPdfXrefEntry.Create, 'Create');
    RegisterMethod(@TPdfXrefEntry.SaveToPdfWrite, 'SaveToPdfWrite');
    RegisterPropertyHelper(@TPdfXrefEntryEntryType_R,@TPdfXrefEntryEntryType_W,'EntryType');
    RegisterPropertyHelper(@TPdfXrefEntryByteOffset_R,nil,'ByteOffset');
    RegisterPropertyHelper(@TPdfXrefEntryGenerationNumber_R,@TPdfXrefEntryGenerationNumber_W,'GenerationNumber');
    RegisterPropertyHelper(@TPdfXrefEntryValue_R,nil,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfTrailer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfTrailer) do begin
    RegisterConstructor(@TPdfTrailer.Create, 'Create');
    RegisterPropertyHelper(@TPdfTrailerXrefAddress_R,@TPdfTrailerXrefAddress_W,'XrefAddress');
    RegisterPropertyHelper(@TPdfTrailerAttributes_R,nil,'Attributes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfBinary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfBinary) do
  begin
    RegisterPropertyHelper(@TPdfBinaryStream_R,nil,'Stream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfStream) do begin
    RegisterConstructor(@TPdfStream.Create, 'Create');
    RegisterPropertyHelper(@TPdfStreamAttributes_R,nil,'Attributes');
    RegisterPropertyHelper(@TPdfStreamWriter_R,nil,'Writer');
    RegisterPropertyHelper(@TPdfStreamFilter_R,nil,'Filter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfDictionary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfDictionary) do begin
    RegisterConstructor(@TPdfDictionary.Create, 'Create');
    RegisterMethod(@TPdfDictionary.Destroy, 'Free');
    RegisterMethod(@TPdfDictionary.ValueByName, 'ValueByName');
    RegisterMethod(@TPdfDictionary.PdfBooleanByName, 'PdfBooleanByName');
    RegisterMethod(@TPdfDictionary.PdfNumberByName, 'PdfNumberByName');
    RegisterMethod(@TPdfDictionary.PdfTextByName, 'PdfTextByName');
    RegisterMethod(@TPdfDictionary.PdfTextValueByName, 'PdfTextValueByName');
    RegisterMethod(@TPdfDictionary.PdfTextUTF8ValueByName, 'PdfTextUTF8ValueByName');
    RegisterMethod(@TPdfDictionary.PdfTextStringValueByName, 'PdfTextStringValueByName');
    RegisterMethod(@TPdfDictionary.PdfRealByName, 'PdfRealByName');
    RegisterMethod(@TPdfDictionary.PdfNameByName, 'PdfNameByName');
    RegisterMethod(@TPdfDictionary.PdfDictionaryByName, 'PdfDictionaryByName');
    RegisterMethod(@TPdfDictionary.PdfArrayByName, 'PdfArrayByName');
    RegisterMethod(@TPdfDictionaryAddItem_P, 'AddItem');
    RegisterMethod(@TPdfDictionaryAddItem1_P, 'AddItem1');
    RegisterMethod(@TPdfDictionaryAddItem2_P, 'AddItem2');
    RegisterMethod(@TPdfDictionaryAddItemText_P, 'AddItemText');
    RegisterMethod(@TPdfDictionaryAddItemTextUTF8_P, 'AddItemTextUTF8');
    RegisterMethod(@TPdfDictionaryAddItemTextString_P, 'AddItemTextString');
    RegisterMethod(@TPdfDictionary.RemoveItem, 'RemoveItem');
    RegisterPropertyHelper(@TPdfDictionaryItems_R,nil,'Items');
    RegisterPropertyHelper(@TPdfDictionaryItemCount_R,nil,'ItemCount');
    RegisterPropertyHelper(@TPdfDictionaryObjectMgr_R,nil,'ObjectMgr');
    RegisterPropertyHelper(@TPdfDictionaryTypeOf_R,nil,'TypeOf');
    RegisterPropertyHelper(@TPdfDictionaryList_R,nil,'List');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfDictionaryElement(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfDictionaryElement) do begin
    RegisterConstructor(@TPdfDictionaryElement.Create, 'Create');
    RegisterPropertyHelper(@TPdfDictionaryElementKey_R,nil,'Key');
    RegisterPropertyHelper(@TPdfDictionaryElementValue_R,nil,'Value');
    RegisterPropertyHelper(@TPdfDictionaryElementIsInternal_R,nil,'IsInternal');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfArray) do begin
    RegisterConstructor(@TPdfArrayCreate_P, 'Create');
    RegisterConstructor(@TPdfArrayCreate1_P, 'Create1');
    RegisterConstructor(@TPdfArrayCreate2_P, 'Create2');
    RegisterConstructor(@TPdfArrayCreateNames_P, 'CreateNames');
    RegisterConstructor(@TPdfArrayCreateReals_P, 'CreateReals');
    RegisterMethod(@TPdfArray.AddItem, 'AddItem');
    RegisterMethod(@TPdfArray.FindName, 'FindName');
    RegisterMethod(@TPdfArray.RemoveName, 'RemoveName');
    RegisterPropertyHelper(@TPdfArrayItems_R,nil,'Items');
    RegisterPropertyHelper(@TPdfArrayItemCount_R,nil,'ItemCount');
    RegisterPropertyHelper(@TPdfArrayObjectMgr_R,nil,'ObjectMgr');
    RegisterPropertyHelper(@TPdfArrayList_R,nil,'List');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfName(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfName) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfRawText(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfRawText) do
  begin
    RegisterConstructor(@TPdfRawText.CreateFmt, 'CreateFmt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfTextString(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfTextString) do
  begin
    RegisterConstructor(@TPdfTextString.Create, 'Create');
    RegisterPropertyHelper(@TPdfTextStringValue_R,@TPdfTextStringValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfTextUTF8(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfTextUTF8) do
  begin
    RegisterConstructor(@TPdfTextUTF8.Create, 'Create');
    RegisterPropertyHelper(@TPdfTextUTF8Value_R,@TPdfTextUTF8Value_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfText(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfText) do
  begin
    RegisterConstructor(@TPdfText.Create, 'Create');
    RegisterPropertyHelper(@TPdfTextValue_R,@TPdfTextValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfReal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfReal) do begin
    RegisterConstructor(@TPdfReal.Create, 'Create');
    RegisterPropertyHelper(@TPdfRealValue_R,@TPdfRealValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfNumber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfNumber) do begin
    RegisterConstructor(@TPdfNumber.Create, 'Create');
    RegisterPropertyHelper(@TPdfNumberValue_R,@TPdfNumberValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfNull(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfNull) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfBoolean(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfBoolean) do begin
    RegisterConstructor(@TPdfBoolean.Create, 'Create');
    RegisterPropertyHelper(@TPdfBooleanValue_R,@TPdfBooleanValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfVirtualObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfVirtualObject) do
  begin
    RegisterConstructor(@TPdfVirtualObject.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfObject) do begin
    RegisterConstructor(@TPdfObject.Create, 'Create');
    RegisterMethod(@TPdfObject.Destroy, 'Free');
    RegisterMethod(@TPdfObject.WriteTo, 'WriteTo');
    RegisterMethod(@TPdfObject.WriteValueTo, 'WriteValueTo');
    RegisterPropertyHelper(@TPdfObjectObjectNumber_R,@TPdfObjectObjectNumber_W,'ObjectNumber');
    RegisterPropertyHelper(@TPdfObjectGenerationNumber_R,nil,'GenerationNumber');
    RegisterPropertyHelper(@TPdfObjectObjectType_R,nil,'ObjectType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfObjectMgr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfObjectMgr) do begin
    //RegisterVirtualAbstractMethod(@TPdfObjectMgr, @!.AddObject, 'AddObject');
    //RegisterVirtualAbstractMethod(@TPdfObjectMgr, @!.GetObject, 'GetObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfWrite(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPdfWrite) do begin
    RegisterConstructor(@TPdfWrite.Create, 'Create');
    RegisterMethod(@TPdfWriteAdd_P, 'Add');
    RegisterMethod(@TPdfWriteAdd1_P, 'Add1');
    RegisterMethod(@TPdfWriteAddWithSpace_P, 'AddWithSpace');
    RegisterMethod(@TPdfWriteAdd2_P, 'Add2');
    RegisterMethod(@TPdfWriteAdd3_P, 'Add3');
    RegisterMethod(@TPdfWriteAddWithSpace1_P, 'AddWithSpace1');
    RegisterMethod(@TPdfWriteAddWithSpace2_P, 'AddWithSpace2');
    RegisterMethod(@TPdfWriteAdd4_P, 'Add4');
    RegisterMethod(@TPdfWriteAdd5_P, 'Add5');
    RegisterMethod(@TPdfWrite.AddHex, 'AddHex');
    RegisterMethod(@TPdfWrite.AddHex4, 'AddHex4');
    RegisterMethod(@TPdfWrite.AddToUnicodeHex, 'AddToUnicodeHex');
    RegisterMethod(@TPdfWrite.AddUnicodeHex, 'AddUnicodeHex');
    RegisterMethod(@TPdfWrite.AddToUnicodeHexText, 'AddToUnicodeHexText');
    RegisterMethod(@TPdfWrite.AddUnicodeHexText, 'AddUnicodeHexText');
    RegisterMethod(@TPdfWrite.AddGlyphs, 'AddGlyphs');
    RegisterMethod(@TPdfWrite.AddEscape, 'AddEscape');
    RegisterMethod(@TPdfWrite.AddEscapeText, 'AddEscapeText');
    RegisterMethod(@TPdfWrite.AddEscapeName, 'AddEscapeName');
    RegisterMethod(@TPdfWrite.AddColorStr, 'AddColorStr');
    RegisterMethod(@TPdfWrite.AddRGB, 'AddRGB');
    RegisterMethod(@TPdfWrite.AddIso8601, 'AddIso8601');
    RegisterMethod(@TPdfWrite.Save, 'Save');
    RegisterMethod(@TPdfWrite.Position, 'Position');
    RegisterMethod(@TPdfWrite.ToPDFString, 'ToPDFString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfEncryptionRC4MD5(CL: TPSRuntimeClassImporter);
begin
  //with CL.Add(TPdfEncryptionRC4MD5) do
  //begin
  //end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPdfEncryption(CL: TPSRuntimeClassImporter);
begin
  //with CL.Add(TPdfEncryption) do begin
    //RegisterVirtualConstructor(@TPdfEncryption.Create, 'Create');
    //RegisterMethod(@TPdfEncryption.New, 'New');
  //end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynPdf(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EPdfInvalidValue) do
  with CL.Add(EPdfInvalidOperation) do
  with CL.Add(TPdfObject) do
  with CL.Add(TPdfCanvas) do
  with CL.Add(TPdfFont) do
  with CL.Add(TPdfFontTrueType) do
  with CL.Add(TPdfDocument) do
  RIRegister_TPdfEncryption(CL);
  RIRegister_TPdfEncryptionRC4MD5(CL);
  RIRegister_TPdfWrite(CL);
  RIRegister_TPdfObjectMgr(CL);
  RIRegister_TPdfObject(CL);
  RIRegister_TPdfVirtualObject(CL);
  RIRegister_TPdfBoolean(CL);
  RIRegister_TPdfNull(CL);
  RIRegister_TPdfNumber(CL);
  RIRegister_TPdfReal(CL);
  RIRegister_TPdfText(CL);
  RIRegister_TPdfTextUTF8(CL);
  RIRegister_TPdfTextString(CL);
  RIRegister_TPdfRawText(CL);
  RIRegister_TPdfName(CL);
  RIRegister_TPdfArray(CL);
  RIRegister_TPdfDictionaryElement(CL);
  RIRegister_TPdfDictionary(CL);
  RIRegister_TPdfStream(CL);
  RIRegister_TPdfBinary(CL);
  RIRegister_TPdfTrailer(CL);
  RIRegister_TPdfXrefEntry(CL);
  RIRegister_TPdfXref(CL);
  with CL.Add(TPdfXObject) do
  with CL.Add(TPdfOutlines) do
  with CL.Add(TPdfInfo) do
  with CL.Add(TPdfCatalog) do
  with CL.Add(TPdfDestination) do
  with CL.Add(TPdfOutlineEntry) do
  with CL.Add(TPdfOutlineRoot) do
  with CL.Add(TPdfPage) do
  RIRegister_TPdfDocument(CL);
  RIRegister_TPdfPage(CL);
  RIRegister_TPdfCanvas(CL);
  RIRegister_TPdfDictionaryWrapper(CL);
  RIRegister_TPdfInfo(CL);
  RIRegister_TPdfCatalog(CL);
  RIRegister_TPdfFont(CL);
  RIRegister_TPdfFontWinAnsi(CL);
  RIRegister_TPdfFontType1(CL);
  RIRegister_TPdfFontCIDFontType2(CL);
  RIRegister_TPdfTTF(CL);
  RIRegister_TPdfFontTrueType(CL);
  RIRegister_TPdfDestination(CL);
  RIRegister_TPdfOutlineEntry(CL);
  RIRegister_TPdfOutlineRoot(CL);
  RIRegister_TPdfPageGDI(CL);
  RIRegister_TPdfDocumentGDI(CL);
  RIRegister_TPdfImage(CL);
  RIRegister_TPdfForm(CL);
end;

 
 
{ TPSImport_SynPdf }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynPdf.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynPdf(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynPdf.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynPdf(ri);
  RIRegister_SynPdf_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
