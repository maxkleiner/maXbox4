unit uPSI_cHTTPUtils;
{
   build with stringbuilder from CStrings, one way unit
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
  TPSImport_cHTTPUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{type
  TAnsiStringBuilder = class
  protected
    FString : AnsiString;
    FLength : Integer;

    procedure EnsureCapacity(const L: Integer);

    function  GetAsAnsiString: AnsiString;
    procedure SetAsAnsiString(const S: AnsiString);
    function  GetAsString: String;

  public
    constructor Create(const S: AnsiString = ''); overload;
    constructor Create(const Capacity: Integer); overload;

    property  Length: Integer read FLength;
    property  AsAnsiString: AnsiString read GetAsAnsiString write SetAsAnsiString;
    property  AsString: String read GetAsString;

    procedure Clear;
    procedure Assign(const S: TAnsiStringBuilder);

    procedure Append(const S: AnsiString); overload;
    procedure AppendCRLF;
    procedure AppendLn(const S: AnsiString = '');
    procedure Append(const S: AnsiString; const Count: Integer); overload;
    procedure AppendCh(const C: AnsiChar); overload;
    procedure AppendCh(const C: AnsiChar; const Count: Integer); overload;
    procedure Append(const BufPtr: Pointer; const Size: Integer); overload;
    procedure Append(const S: TAnsiStringBuilder); overload;

    procedure Pack;
  end;  }
  
 
 
{ compile-time registration functions }
procedure SIRegister_THTTPContentWriter(CL: TPSPascalCompiler);
procedure SIRegister_THTTPContentReader(CL: TPSPascalCompiler);
procedure SIRegister_THTTPContentDecoder(CL: TPSPascalCompiler);
procedure SIRegister_THTTPParser(CL: TPSPascalCompiler);
procedure SIRegister_cHTTPUtils(CL: TPSPascalCompiler);
procedure SIRegister_TAnsiStringBuilder(CL: TPSPascalCompiler);


{ run-time registration functions }
procedure RIRegister_THTTPContentWriter(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTTPContentReader(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTTPContentDecoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTTPParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_cHTTPUtils_Routines(S: TPSExec);
procedure RIRegister_cHTTPUtils(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAnsiStringBuilder(CL: TPSRuntimeClassImporter);


procedure Register;

implementation


uses
  // cStrings
  cTCPBuffer
  ,cHTTPUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cHTTPUtils]);
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAnsiStringBuilder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TAnsiStringBuilder') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TAnsiStringBuilder') do begin
    RegisterMethod('Constructor Create( const S : AnsiString);');
    RegisterMethod('Constructor Create1( const Capacity : Integer);');
    RegisterProperty('Length', 'Integer', iptr);
    RegisterProperty('AsAnsiString', 'AnsiString', iptrw);
    RegisterProperty('AsString', 'String', iptr);
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Assign( const S : TAnsiStringBuilder)');
    RegisterMethod('Procedure Append( const S : AnsiString);');
    RegisterMethod('Procedure AppendCRLF');
    RegisterMethod('Procedure AppendLn( const S : AnsiString)');
    RegisterMethod('Procedure Append1( const S : AnsiString; const Count : Integer);');
    RegisterMethod('Procedure AppendCh( const C : AnsiChar);');
    RegisterMethod('Procedure AppendCh1( const C : AnsiChar; const Count : Integer);');
    RegisterMethod('Procedure Append2( const BufPtr : Pointer; const Size : Integer);');
    RegisterMethod('Procedure Append3( const S : TAnsiStringBuilder);');
    RegisterMethod('Procedure Pack');
  end;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THTTPContentWriter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THTTPContentWriter') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THTTPContentWriter') do begin
    RegisterMethod('Constructor Create( const WriteProc : THTTPContentWriterWriteProc)');
    RegisterMethod('Procedure Free');
    RegisterProperty('OnLog', 'THTTPContentWriterLogEvent', iptrw);
    RegisterProperty('Mechanism', 'THTTPContentWriterMechanism', iptrw);
    RegisterProperty('ContentString', 'AnsiString', iptrw);
    RegisterProperty('ContentStream', 'TStream', iptrw);
    RegisterProperty('ContentFileName', 'String', iptrw);
    RegisterMethod('Procedure InitContent( var ContentLength : Int64)');
    RegisterMethod('Procedure SendContent');
    RegisterProperty('ContentComplete', 'Boolean', iptr);
    RegisterMethod('Procedure FinaliseContent');
    RegisterMethod('Procedure Reset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTTPContentReader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THTTPContentReader') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THTTPContentReader') do begin
    RegisterMethod('Constructor Create( const ReadProc : THTTPContentReaderReadProc; const ContentProc : THTTPContentReaderContentProc; const CompleteProc : THTTPContentReaderProc)');
    RegisterMethod('Procedure Free');
    RegisterProperty('OnLog', 'THTTPContentReaderLogEvent', iptrw);
    RegisterProperty('Mechanism', 'THTTPContentReaderMechanism', iptrw);
    RegisterProperty('ContentStream', 'TStream', iptrw);
    RegisterProperty('ContentFileName', 'String', iptrw);
    RegisterMethod('Procedure InitReader( const CommonHeaders : THTTPCommonHeaders)');
    RegisterMethod('Procedure Process');
    RegisterProperty('ContentComplete', 'Boolean', iptr);
    RegisterProperty('ContentString', 'AnsiString', iptr);
    RegisterMethod('Procedure Reset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTTPContentDecoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THTTPContentDecoder') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THTTPContentDecoder') do begin
    RegisterMethod('Constructor Create( const ReadProc : THTTPContentDecoderReadProc; const ContentProc : THTTPContentDecoderContentProc; const CompleteProc : THTTPContentDecoderProc)');
    RegisterMethod('Procedure Free');
    RegisterProperty('OnLog', 'THTTPContentDecoderLogEvent', iptrw);
    RegisterProperty('ContentSize', 'Int64', iptr);
    RegisterProperty('ContentReceived', 'Int64', iptr);
    RegisterProperty('ContentComplete', 'Boolean', iptr);
    RegisterMethod('Procedure InitDecoder( const CommonHeaders : THTTPCommonHeaders)');
    RegisterMethod('Procedure Process');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTTPParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THTTPParser') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'cTHTTPParser') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure SetTextStr( const S : AnsiString)');
    RegisterMethod('procedure SetTextBuf(const Buf: string; const BufSize: Integer)');

    RegisterMethod('Procedure ParseRequest( var Request : THTTPRequest)');
    RegisterMethod('Procedure ParseResponse( var Response : cTHTTPResponse)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cHTTPUtils(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EHTTP');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EHTTPParser');
  //CL.AddTypeS('AnsiCharSet', 'set of AnsiChar');
  CL.AddTypeS('AnsiStringArray', 'array of AnsiString');
  //CL.AddTypeS('cTHTTPParser', 'THTTPParser');
  SIRegister_TAnsiStringBuilder(CL);

  CL.AddTypeS('THTTPProtocolEnum', '( hpNone, hpCustom, hpHTTP, hpHTTPS )');
  CL.AddTypeS('THTTPVersionEnum', '( hvNone, hvCustom, hvHTTP10, hvHTTP11 )');
  CL.AddTypeS('THTTPVersion', 'record Version : THTTPVersionEnum; Protocol : TH'
   +'TTPProtocolEnum; CustomProtocol : AnsiString; CustomMajVersion : Integer; '
   +'CustomMinVersion : Integer; end');
  CL.AddTypeS('THTTPHeaderNameEnum', '( hntCustom, hntHost, hntContentType, hnt'
   +'ContentLength, hntContentTransferEncoding, hntContentLocation, hntContentL'
   +'anguage, hntContentEncoding, hntTransferEncoding, hntDate, hntServer, hntU'
   +'serAgent, hntLocation, hntConnection, hntExpires, hntCacheControl, hntSetC'
   +'ookie, hntCookie, hntAuthorization, hntVia, hntWarning, hntContentRange, h'
   +'ntXForwardedFor, hntPragma, hntXPoweredBy, hntWWWAuthenticate, hntLastModi'
   +'fied, hntETag, hntProxyAuthorization, hntReferer, hntAge, hntAcceptRanges,'
   +' hntAcceptEncoding, hntAcceptLanguage, hntAcceptCharset, hntIfModifiedSinc'
   +'e, hntIfUnmodifiedSince, hntRetryAfter, hntUpgrade, hntStatus, hntProxyCon'
   +'nection, hntOrigin, hntKeepAlive )');
  CL.AddTypeS('THTTPHeaderName', 'record Value : THTTPHeaderNameEnum; Custom: AnsiString; end');
  CL.AddTypeS('THTTPCustomHeader', 'record FieldName : AnsiString; FieldValue :'
   +' AnsiString; end');
  //CL.AddTypeS('PHTTPCustomHeader', '^THTTPCustomHeader // will not work');
  CL.AddTypeS('THTTPContentLengthEnum', '( hcltNone, hcltByteCount )');
  CL.AddTypeS('THTTPContentLength', 'record Value : THTTPContentLengthEnum; ByteCount : Int64; end');
  //CL.AddTypeS('PHTTPContentLength', '^THTTPContentLength // will not work');
  CL.AddTypeS('THTTPContentTypeMajor', '( hctmCustom, hctmText, hctmImage )');
  CL.AddTypeS('THTTPContentTypeEnum', '( hctNone, hctCustomParts, hctCustomStri'
   +'ng, hctTextHtml, hctTextAscii, hctTextCss, hctTextPlain, hctTextXml, hctTe'
   +'xtCustom, hctImageJpeg, hctImagePng, hctImageGif, hctImageCustom, hctAppli'
   +'cationJSON, hctApplicationOctetStream, hctApplicationJavaScript, hctApplic'
   +'ationCustom, hctAudioCustom, hctVideoCustom )');
  CL.AddTypeS('THTTPContentType', 'record Value : THTTPContentTypeEnum; CustomM'
   +'ajor : AnsiString; CustomMinor : AnsiString; Parameters : AnsiStringArray;'
   +' CustomStr : AnsiString; end');
  CL.AddTypeS('THTTPDateFieldEnum', '( hdNone, hdCustom, hdParts, hdDateTime )');
  CL.AddTypeS('THTTPDateField', 'record Value : THTTPDateFieldEnum; DayOfWeek :'
   +' Integer; Day : integer; Month : integer; Year : Integer; Hour : integer; '
   +'Min : integer; Sec : Integer; TimeZoneGMT : Boolean; CustomTimeZone : Ansi'
   +'String; DateTime : TDateTime; Custom : AnsiString; end');
  CL.AddTypeS('THTTPTransferEncodingEnum', '( hteNone, hteCustom, hteChunked )');
  CL.AddTypeS('THTTPTransferEncoding', 'record Value : THTTPTransferEncodingEnu'
   +'m; Custom : AnsiString; end');
  CL.AddTypeS('THTTPConnectionFieldEnum', '( hcfNone, hcfCustom, hcfClose, hcfKeepAlive )');
  CL.AddTypeS('THTTPConnectionField', 'record Value : THTTPConnectionFieldEnum;'
   +' Custom : AnsiString; end');
  CL.AddTypeS('THTTPAgeFieldEnum', '( hafNone, hafCustom, hafAge )');
  CL.AddTypeS('THTTPAgeField', 'record Value : THTTPAgeFieldEnum; Age : Int64; '
   +'Custom : AnsiString; end');
  CL.AddTypeS('THTTPCacheControlFieldEnum', '( hccfNone, hccfDecoded, hccfCustom )');
  CL.AddTypeS('THTTPCacheControlRequestSubField', '( hccsfNoCache, hccsfNoStore'
   +', hccsfMaxAge, hccsfMaxStale, hccsfMinFresh, hccsfNoTransform, hccsfOnlyIfCached )');
  CL.AddTypeS('THTTPCacheControlResponseSubField', '( hccrfPublic, hccrfPrivate'
   +', hccrfNoCache, hccrfNoStore, hccrfNoTransform, hccrfMustRevalidate, hccrf'
   +'ProxyRevalidate, hccrfMaxAge, hccrfSMaxAge )');
  CL.AddTypeS('THTTPCacheControlField', 'record Value : THTTPCacheControlFieldEnum; end');
  CL.AddTypeS('THTTPContentEncodingEnum', '( hceNone, hceCustom, hceIdentity, h'
   +'ceCompress, hceDeflate, hceExi, hceGzip, hcePack200Gzip )');
  CL.AddTypeS('THTTPContentEncoding', 'record Value : THTTPContentEncodingEnum;'
   +' Custom : AnsiString; end');
  CL.AddTypeS('THTTPContentEncodingFieldEnum', '( hcefNone, hcefList )');
  CL.AddTypeS('THTTPContentEncodingField', 'record Value : THTTPContentEncoding'
   +'FieldEnum; List : array of THTTPContentEncoding; end');
  CL.AddTypeS('THTTPRetryAfterFieldEnum', '( hrafNone, hrafCustom, harfDate, harfSeconds )');
  CL.AddTypeS('THTTPRetryAfterField', 'record Value : THTTPRetryAfterFieldEnum;'
   +' Custom : AnsiString; Date : TDateTime; Seconds : Int64; end');
  CL.AddTypeS('THTTPContentRangeFieldEnum', '( hcrfNone, hcrfCustom, hcrfByteRange )');
  CL.AddTypeS('THTTPContentRangeField', 'record Value : THTTPContentRangeFieldE'
   +'num; ByteFirst : Int64; ByteLast : Int64; ByteSize : Int64; Custom : AnsiString; end');
  CL.AddTypeS('THTTPSetCookieFieldEnum', '( hscoNone, hscoDecoded, hscoCustom )');
  CL.AddTypeS('THTTPSetCookieCustomField', 'record Name : AnsiString; Value : AnsiString; end');
  CL.AddTypeS('THTTPSetCookieCustomFieldArray', 'array of THTTPSetCookieCustomField');
  CL.AddTypeS('THTTPSetCookieField', 'record Value : THTTPSetCookieFieldEnum; D'
   +'omain : AnsiString; Path : AnsiString; Expires : THTTPDateField; MaxAge : '
   +'Int64; HttpOnly : Boolean; Secure : Boolean; CustomFields : THTTPSetCookie'
   +'CustomFieldArray; Custom : AnsiString; end');
  //CL.AddTypeS('PHTTPSetCookieField', '^THTTPSetCookieField // will not work');
  CL.AddTypeS('THTTPSetCookieFieldArray', 'array of THTTPSetCookieField');
  CL.AddTypeS('THTTPCookieFieldEnum', '( hcoNone, hcoDecoded, hcoCustom )');
  CL.AddTypeS('THTTPCookieFieldEntry', 'record Name : AnsiString; Value : AnsiString; end');
  //CL.AddTypeS('PHTTPCookieFieldEntry', '^THTTPCookieFieldEntry // will not work');
  CL.AddTypeS('THTTPCookieFieldEntryArray', 'array of THTTPCookieFieldEntry');
  CL.AddTypeS('THTTPCookieField', 'record Value : THTTPCookieFieldEnum; Entries'
   +' : THTTPCookieFieldEntryArray; Custom : AnsiString; end');
  CL.AddTypeS('THTTPCommonHeaders', 'record TransferEncoding : THTTPTransferEnc'
   +'oding; ContentType : THTTPContentType; ContentLength : THTTPContentLength;'
   +' Connection : THTTPConnectionField; ProxyConnection : THTTPConnectionField'
   +'; Date : THTTPDateField; ContentEncoding : THTTPContentEncodingField; end');
  CL.AddTypeS('THTTPCustomHeaders', 'array of THTTPCustomHeader');

   CL.AddTypeS('THTTPHeaderNameEnums','set of THTTPHeaderNameEnum');

  //CL.AddTypeS('THTTPFixedHeaders','array[THTTPHeaderNameEnum] of AnsiString');
  //CL.AddTypeS('THTTPFixedHeaders','array[0..43] of AnsiString');
  //CL.AddTypeS('THTTPFixedHeaders','array[0..43] of AnsiString');
  //CL.AddTypeS('THTTPFixedHeaders','array[0..42] of THTTPHeaderNameEnums');
  //CL.AddTypeS('THTTPFixedHeaders','array[0..42] of THTTPHeaderNameEnums');

  //CL.AddTypeS('THTTPFixedHeaders','array[hntCustom..hntKeepAlive] of THTTPHeaderNameEnums');
  //CL.AddTypeS('THTTPFixedHeaders','array[0..42] of THTTPHeaderNameEnums');
  CL.AddTypeS('THTTPFixedHeaders','array[0..42] of THTTPHeaderNameEnums of AnsiString');
  //CL.AddTypeS('THTTPFixedHeaders','array of THTTPHeaderNameEnums of AnsiString');

    CL.AddTypeS('THTTPMethodEnum', '( hmNone, hmCustom, hmGET, hmPUT, hmPOST, hmC'
   +'ONNECT, hmHEAD, hmDELETE, hmOPTIONS, hmTRACE )');
  CL.AddTypeS('THTTPMethod', 'record Value : THTTPMethodEnum; Custom : AnsiString; end');
  CL.AddTypeS('THTTPRequestStartLine', 'record Method : THTTPMethod; URI : Ansi'
   +'String; Version : THTTPVersion; end');
  CL.AddTypeS('THTTPRequestHeader', 'record CommonHeaders : THTTPCommonHeaders;'
   +' FixedHeaders : THTTPFixedHeaders; CustomHeaders : THTTPCustomHeaders; Coo'
   +'kie : THTTPCookieField; IfModifiedSince : THTTPDateField; IfUnmodifiedSinc'
   +'e : THTTPDateField; end');
  //CL.AddTypeS('PHTTPRequestHeader', '^THTTPRequestHeader // will not work');
  CL.AddTypeS('THTTPRequest', 'record StartLine : THTTPRequestStartLine; Header'
   +' : THTTPRequestHeader; HeaderComplete : Boolean; HasContent : Boolean; end;');

  //CL.AddTypeS('THTTPRequest', 'record HeaderComplete : Boolean; HasContent : Boolean; end;');


  CL.AddTypeS('THTTPResponseStartLineMessage', '( hslmNone, hslmCustom, hslmOK)');
  CL.AddTypeS('THTTPResponseStartLine', 'record Version : THTTPVersion; Code : '
   +'Integer; Msg : THTTPResponseStartLineMessage; CustomMsg : AnsiString; end');
  CL.AddTypeS('THTTPResponseHeader', 'record CommonHeaders : THTTPCommonHeaders'
   +'; FixedHeaders : THTTPFixedHeaders; CustomHeaders : THTTPCustomHeaders; Co'
   +'okies : THTTPSetCookieFieldArray; Expires : THTTPDateField; LastModified :'
   +' THTTPDateField; Age : THTTPAgeField; end'); 
  //CL.AddTypeS('PHTTPResponseHeader', '^THTTPResponseHeader // will not work');
  CL.AddTypeS('cTHTTPResponse', 'record StartLine : THTTPResponseStartLine; Head'
   +'er : THTTPResponseHeader; HeaderComplete : Boolean; HasContent : Boolean; end');
 CL.AddDelphiFunction('Function HTTPMessageHasContent( const H : THTTPCommonHeaders) : Boolean');
 CL.AddDelphiFunction('Procedure InitHTTPRequest( var A : THTTPRequest)');
 CL.AddDelphiFunction('Procedure InitHTTPResponse( var A : cTHTTPResponse)');
 CL.AddDelphiFunction('Procedure ClearHTTPVersion( var A : THTTPVersion)');
 CL.AddDelphiFunction('Procedure ClearHTTPContentLength( var A : THTTPContentLength)');
 CL.AddDelphiFunction('Procedure ClearHTTPContentType( var A : THTTPContentType)');
 CL.AddDelphiFunction('Procedure ClearHTTPDateField( var A : THTTPDateField)');
 CL.AddDelphiFunction('Procedure ClearHTTPTransferEncoding( var A : THTTPTransferEncoding)');
 CL.AddDelphiFunction('Procedure ClearHTTPConnectionField( var A : THTTPConnectionField)');
 CL.AddDelphiFunction('Procedure ClearHTTPAgeField( var A : THTTPAgeField)');
 CL.AddDelphiFunction('Procedure ClearHTTPContentEncoding( var A : THTTPContentEncoding)');
 CL.AddDelphiFunction('Procedure ClearHTTPContentEncodingField( var A : THTTPContentEncodingField)');
 CL.AddDelphiFunction('Procedure ClearHTTPContentRangeField( var A : THTTPContentRangeField)');
 CL.AddDelphiFunction('Procedure ClearHTTPSetCookieField( var A : THTTPSetCookieField)');
 CL.AddDelphiFunction('Procedure ClearHTTPCommonHeaders( var A : THTTPCommonHeaders)');
 CL.AddDelphiFunction('Procedure ClearHTTPFixedHeaders( var A : THTTPFixedHeaders)');
 CL.AddDelphiFunction('Procedure ClearHTTPCustomHeaders( var A : THTTPCustomHeaders)');
 CL.AddDelphiFunction('Procedure ClearHTTPCookieField( var A : THTTPCookieField)');
 CL.AddDelphiFunction('Procedure ClearHTTPMethod( var A : THTTPMethod)');
 CL.AddDelphiFunction('Procedure ClearHTTPRequestStartLine( var A : THTTPRequestStartLine)');
 CL.AddDelphiFunction('Procedure ClearHTTPRequestHeader( var A : THTTPRequestHeader)');
 CL.AddDelphiFunction('Procedure ClearHTTPRequest( var A : THTTPRequest)');
 CL.AddDelphiFunction('Procedure ClearHTTPResponseStartLine( var A : THTTPResponseStartLine)');
 CL.AddDelphiFunction('Procedure ClearHTTPResponseHeader( var A : THTTPResponseHeader)');
 CL.AddDelphiFunction('Procedure ClearHTTPResponse( var A : cTHTTPResponse)');
  CL.AddTypeS('THTTPStringOption', '( hsoNone )');
  CL.AddTypeS('THTTPStringOptions', 'set of THTTPStringOption');
   CL.AddClassN(CL.FindClass('TOBJECT'),'TAnsiStringBuilder');

 CL.AddDelphiFunction('Procedure BuildStrHTTPVersion( const A : THTTPVersion; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPContentLengthValue( const A : THTTPContentLength; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPContentLength( const A : THTTPContentLength; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPContentTypeValue( const A : THTTPContentType; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPContentType( const A : THTTPContentType; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrRFCDateTime( const DOW, Da, Mo, Ye, Ho, Mi, Se : Integer; const TZ : AnsiString; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPDateFieldValue( const A : THTTPDateField; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPDateField( const A : THTTPDateField; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPTransferEncodingValue( const A : THTTPTransferEncoding; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPTransferEncoding( const A : THTTPTransferEncoding; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPContentRangeField( const A : THTTPContentRangeField; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPConnectionFieldValue( const A : THTTPConnectionField; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPConnectionField( const A : THTTPConnectionField; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPAgeField( const A : THTTPAgeField; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPContentEncoding( const A : THTTPContentEncoding; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPContentEncodingField( const A : THTTPContentEncodingField; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPProxyConnectionField( const A : THTTPConnectionField; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPCommonHeaders( const A : THTTPCommonHeaders; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPFixedHeaders( const A : THTTPFixedHeaders; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPCustomHeaders( const A : THTTPCustomHeaders; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPSetCookieFieldValue( const A : THTTPSetCookieField; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPCookieFieldValue( const A : THTTPCookieField; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPCookieField( const A : THTTPCookieField; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPMethod( const A : THTTPMethod; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPRequestStartLine( const A : THTTPRequestStartLine; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPRequestHeader( const A : THTTPRequestHeader; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPRequest( const A : THTTPRequest; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPResponseCookieFieldArray( const A : THTTPSetCookieFieldArray; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPResponseStartLine( const A : THTTPResponseStartLine; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPResponseHeader( const A : THTTPResponseHeader; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Procedure BuildStrHTTPResponse( const A : cTHTTPResponse; const B : TAnsiStringBuilder; const P : THTTPStringOptions)');
 CL.AddDelphiFunction('Function HTTPContentTypeValueToStr( const A : THTTPContentType) : AnsiString');
 CL.AddDelphiFunction('Function HTTPSetCookieFieldValueToStr( const A : THTTPSetCookieField) : AnsiString');
 CL.AddDelphiFunction('Function HTTPCookieFieldValueToStr( const A : THTTPCookieField) : AnsiString');
 CL.AddDelphiFunction('Function HTTPMethodToStr( const A : THTTPMethod) : AnsiString');
 CL.AddDelphiFunction('Function HTTPRequestToStr( const A : THTTPRequest) : AnsiString');
 CL.AddDelphiFunction('Function HTTPResponseToStr( const A : cTHTTPResponse) : AnsiString');
 CL.AddDelphiFunction('Procedure PrepareCookie( var A : THTTPCookieField; const B : THTTPSetCookieFieldArray; const Domain : AnsiString; const Secure : Boolean)');
  CL.AddTypeS('THTTPParserHeaderParseFunc', 'Function ( const HeaderName : THTT'
   +'PHeaderNameEnum; const HeaderPtr : ___Pointer) : Boolean');
  SIRegister_THTTPParser(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'THTTPContentDecoder');
  CL.AddTypeS('THTTPContentDecoderProc', 'Procedure ( const Sender : THTTPContentDecoder)');
  CL.AddTypeS('THTTPContentDecoderContentType', '( crctFixedSize, crctChunked, crctUnsized )');
  CL.AddTypeS('THTTPContentDecoderChunkState', '( crcsChunkHeader, crcsContent,'
   +' crcsContentCRLF, crcsTrailer, crcsFinished )');
  CL.AddTypeS('THTTPContentDecoderLogEvent', 'Procedure ( const Sender : THTTPC'
   +'ontentDecoder; const LogMsg : String)');
  SIRegister_THTTPContentDecoder(CL);
  CL.AddTypeS('THTTPContentReaderMechanism', '( hcrmEvent, hcrmString, hcrmStream, hcrmFile )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'THTTPContentReader');
  CL.AddTypeS('THTTPContentReaderProc', 'Procedure ( const Sender : THTTPContentReader)');
  CL.AddTypeS('THTTPContentReaderLogEvent', 'Procedure ( const Sender : THTTPContentReader; const LogMsg : String; const LogLevel : Integer)');
  SIRegister_THTTPContentReader(CL);
  CL.AddTypeS('THTTPContentWriterMechanism', '( hctmEvent, hctmString, hctmStream, hctmFile )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'THTTPContentWriter');
  CL.AddTypeS('THTTPContentWriterLogEvent', 'Procedure ( const Sender : THTTPCo'
   +'ntentWriter; const LogMsg : AnsiString)');
  SIRegister_THTTPContentWriter(CL);
 CL.AddDelphiFunction('Procedure SelfTestcHTTPUtils');
 CL.AddDelphiFunction('Procedure SelfTestcHTTPUtilsReader');


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THTTPContentWriterContentComplete_R(Self: THTTPContentWriter; var T: Boolean);
begin T := Self.ContentComplete; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentWriterContentFileName_W(Self: THTTPContentWriter; const T: String);
begin Self.ContentFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentWriterContentFileName_R(Self: THTTPContentWriter; var T: String);
begin T := Self.ContentFileName; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentWriterContentStream_W(Self: THTTPContentWriter; const T: TStream);
begin Self.ContentStream := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentWriterContentStream_R(Self: THTTPContentWriter; var T: TStream);
begin T := Self.ContentStream; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentWriterContentString_W(Self: THTTPContentWriter; const T: AnsiString);
begin Self.ContentString := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentWriterContentString_R(Self: THTTPContentWriter; var T: AnsiString);
begin T := Self.ContentString; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentWriterMechanism_W(Self: THTTPContentWriter; const T: THTTPContentWriterMechanism);
begin Self.Mechanism := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentWriterMechanism_R(Self: THTTPContentWriter; var T: THTTPContentWriterMechanism);
begin T := Self.Mechanism; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentWriterOnLog_W(Self: THTTPContentWriter; const T: THTTPContentWriterLogEvent);
begin Self.OnLog := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentWriterOnLog_R(Self: THTTPContentWriter; var T: THTTPContentWriterLogEvent);
begin T := Self.OnLog; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentReaderContentString_R(Self: THTTPContentReader; var T: AnsiString);
begin T := Self.ContentString; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentReaderContentComplete_R(Self: THTTPContentReader; var T: Boolean);
begin T := Self.ContentComplete; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentReaderContentFileName_W(Self: THTTPContentReader; const T: String);
begin Self.ContentFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentReaderContentFileName_R(Self: THTTPContentReader; var T: String);
begin T := Self.ContentFileName; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentReaderContentStream_W(Self: THTTPContentReader; const T: TStream);
begin Self.ContentStream := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentReaderContentStream_R(Self: THTTPContentReader; var T: TStream);
begin T := Self.ContentStream; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentReaderMechanism_W(Self: THTTPContentReader; const T: THTTPContentReaderMechanism);
begin Self.Mechanism := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentReaderMechanism_R(Self: THTTPContentReader; var T: THTTPContentReaderMechanism);
begin T := Self.Mechanism; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentReaderOnLog_W(Self: THTTPContentReader; const T: THTTPContentReaderLogEvent);
begin Self.OnLog := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentReaderOnLog_R(Self: THTTPContentReader; var T: THTTPContentReaderLogEvent);
begin T := Self.OnLog; end;

(*----------------------------------------------------------------------------*)
Procedure THTTPContentReaderLog1_P(Self: THTTPContentReader;  const LogMsg : String; const LogArgs : array of const; const LogLevel : Integer);
Begin //Self.Log(LogMsg, LogArgs, LogLevel);
END;

(*----------------------------------------------------------------------------*)
Procedure THTTPContentReaderLog_P(Self: THTTPContentReader;  const LogMsg : String; const LogLevel : Integer);
Begin //Self.Log(LogMsg, LogLevel);
END;

(*----------------------------------------------------------------------------*)
procedure THTTPContentDecoderContentComplete_R(Self: THTTPContentDecoder; var T: Boolean);
begin T := Self.ContentComplete; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentDecoderContentReceived_R(Self: THTTPContentDecoder; var T: Int64);
begin T := Self.ContentReceived; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentDecoderContentSize_R(Self: THTTPContentDecoder; var T: Int64);
begin T := Self.ContentSize; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentDecoderOnLog_W(Self: THTTPContentDecoder; const T: THTTPContentDecoderLogEvent);
begin Self.OnLog := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPContentDecoderOnLog_R(Self: THTTPContentDecoder; var T: THTTPContentDecoderLogEvent);
begin T := Self.OnLog; end;

(*----------------------------------------------------------------------------*)
Procedure THTTPContentDecoderLog1_P(Self: THTTPContentDecoder;  const LogMsg : String; const LogArgs : array of const);
Begin //Self.Log(LogMsg, LogArgs);
END;

(*----------------------------------------------------------------------------*)
Procedure THTTPContentDecoderLog_P(Self: THTTPContentDecoder;  const LogMsg : String);
Begin //Self.Log(LogMsg);
 END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTTPContentWriter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTTPContentWriter) do begin
    RegisterConstructor(@THTTPContentWriter.Create, 'Create');
  RegisterMethod(@THTTPContentWriter.Destroy, 'Free');
    RegisterPropertyHelper(@THTTPContentWriterOnLog_R,@THTTPContentWriterOnLog_W,'OnLog');
    RegisterPropertyHelper(@THTTPContentWriterMechanism_R,@THTTPContentWriterMechanism_W,'Mechanism');
    RegisterPropertyHelper(@THTTPContentWriterContentString_R,@THTTPContentWriterContentString_W,'ContentString');
    RegisterPropertyHelper(@THTTPContentWriterContentStream_R,@THTTPContentWriterContentStream_W,'ContentStream');
    RegisterPropertyHelper(@THTTPContentWriterContentFileName_R,@THTTPContentWriterContentFileName_W,'ContentFileName');
    RegisterMethod(@THTTPContentWriter.InitContent, 'InitContent');
    RegisterMethod(@THTTPContentWriter.SendContent, 'SendContent');
    RegisterPropertyHelper(@THTTPContentWriterContentComplete_R,nil,'ContentComplete');
    RegisterMethod(@THTTPContentWriter.FinaliseContent, 'FinaliseContent');
    RegisterMethod(@THTTPContentWriter.Reset, 'Reset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTTPContentReader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTTPContentReader) do begin
    RegisterConstructor(@THTTPContentReader.Create, 'Create');
    RegisterMethod(@THTTPContentReader.Destroy, 'Free');
    RegisterPropertyHelper(@THTTPContentReaderOnLog_R,@THTTPContentReaderOnLog_W,'OnLog');
    RegisterPropertyHelper(@THTTPContentReaderMechanism_R,@THTTPContentReaderMechanism_W,'Mechanism');
    RegisterPropertyHelper(@THTTPContentReaderContentStream_R,@THTTPContentReaderContentStream_W,'ContentStream');
    RegisterPropertyHelper(@THTTPContentReaderContentFileName_R,@THTTPContentReaderContentFileName_W,'ContentFileName');
    RegisterMethod(@THTTPContentReader.InitReader, 'InitReader');
    RegisterMethod(@THTTPContentReader.Process, 'Process');
    RegisterPropertyHelper(@THTTPContentReaderContentComplete_R,nil,'ContentComplete');
    RegisterPropertyHelper(@THTTPContentReaderContentString_R,nil,'ContentString');
    RegisterMethod(@THTTPContentReader.Reset, 'Reset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTTPContentDecoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTTPContentDecoder) do begin
    RegisterConstructor(@THTTPContentDecoder.Create, 'Create');
  RegisterMethod(@THTTPContentDecoder.Destroy, 'Free');
    RegisterPropertyHelper(@THTTPContentDecoderOnLog_R,@THTTPContentDecoderOnLog_W,'OnLog');
    RegisterPropertyHelper(@THTTPContentDecoderContentSize_R,nil,'ContentSize');
    RegisterPropertyHelper(@THTTPContentDecoderContentReceived_R,nil,'ContentReceived');
    RegisterPropertyHelper(@THTTPContentDecoderContentComplete_R,nil,'ContentComplete');
    RegisterMethod(@THTTPContentDecoder.InitDecoder, 'InitDecoder');
    RegisterMethod(@THTTPContentDecoder.Process, 'Process');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTTPParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(cTHTTPParser) do begin
    RegisterConstructor(@cTHTTPParser.Create, 'Create');
 RegisterMethod(@cTHTTPParser.Destroy, 'Free');
    RegisterMethod(@cTHTTPParser.SetTextStr, 'SetTextStr');
    RegisterMethod(@cTHTTPParser.SetTextBuf, 'SetTextBuf');
      RegisterMethod(@cTHTTPParser.ParseRequest, 'ParseRequest');
    RegisterMethod(@cTHTTPParser.ParseResponse, 'ParseResponse');
  end;
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppend3_P(Self: TAnsiStringBuilder;  const S : TAnsiStringBuilder);
Begin Self.Append(S); END;

(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppend2_P(Self: TAnsiStringBuilder;  const BufPtr : Pointer; const Size : Integer);
Begin Self.Append(BufPtr, Size); END;

(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppendCh1_P(Self: TAnsiStringBuilder;  const C : AnsiChar; const Count : Integer);
Begin Self.AppendCh(C, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppendCh_P(Self: TAnsiStringBuilder;  const C : AnsiChar);
Begin Self.AppendCh(C); END;

(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppend1_P(Self: TAnsiStringBuilder;  const S : AnsiString; const Count : Integer);
Begin Self.Append(S, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TAnsiStringBuilderAppend_P(Self: TAnsiStringBuilder;  const S : AnsiString);
Begin Self.Append(S); END;

(*----------------------------------------------------------------------------*)
procedure TAnsiStringBuilderAsString_R(Self: TAnsiStringBuilder; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TAnsiStringBuilderAsAnsiString_W(Self: TAnsiStringBuilder; const T: AnsiString);
begin Self.AsAnsiString := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnsiStringBuilderAsAnsiString_R(Self: TAnsiStringBuilder; var T: AnsiString);
begin T := Self.AsAnsiString; end;

(*----------------------------------------------------------------------------*)
procedure TAnsiStringBuilderLength_R(Self: TAnsiStringBuilder; var T: Integer);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
Function TAnsiStringBuilderCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const Capacity : Integer):TObject;
Begin Result := TAnsiStringBuilder.Create(Capacity); END;

(*----------------------------------------------------------------------------*)
Function TAnsiStringBuilderCreate_P(Self: TClass; CreateNewInstance: Boolean;  const S : AnsiString):TObject;
Begin Result := TAnsiStringBuilder.Create(S); END;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAnsiStringBuilder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAnsiStringBuilder) do begin
    RegisterConstructor(@TAnsiStringBuilderCreate_P, 'Create');
    RegisterConstructor(@TAnsiStringBuilderCreate1_P, 'Create1');
    RegisterPropertyHelper(@TAnsiStringBuilderLength_R,nil,'Length');
    RegisterPropertyHelper(@TAnsiStringBuilderAsAnsiString_R,@TAnsiStringBuilderAsAnsiString_W,'AsAnsiString');
    RegisterPropertyHelper(@TAnsiStringBuilderAsString_R,nil,'AsString');
    RegisterMethod(@TAnsiStringBuilder.Clear, 'Clear');
    RegisterMethod(@TAnsiStringBuilder.Assign, 'Assign');
    RegisterMethod(@TAnsiStringBuilderAppend_P, 'Append');
    RegisterMethod(@TAnsiStringBuilder.AppendCRLF, 'AppendCRLF');
    RegisterMethod(@TAnsiStringBuilder.AppendLn, 'AppendLn');
    RegisterMethod(@TAnsiStringBuilderAppend1_P, 'Append1');
    RegisterMethod(@TAnsiStringBuilderAppendCh_P, 'AppendCh');
    RegisterMethod(@TAnsiStringBuilderAppendCh1_P, 'AppendCh1');
    RegisterMethod(@TAnsiStringBuilderAppend2_P, 'Append2');
    RegisterMethod(@TAnsiStringBuilderAppend3_P, 'Append3');
    RegisterMethod(@TAnsiStringBuilder.Pack, 'Pack');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_cHTTPUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HTTPMessageHasContent, 'HTTPMessageHasContent', cdRegister);
 S.RegisterDelphiFunction(@InitHTTPRequest, 'InitHTTPRequest', cdRegister);
 S.RegisterDelphiFunction(@InitHTTPResponse, 'InitHTTPResponse', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPVersion, 'ClearHTTPVersion', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPContentLength, 'ClearHTTPContentLength', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPContentType, 'ClearHTTPContentType', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPDateField, 'ClearHTTPDateField', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPTransferEncoding, 'ClearHTTPTransferEncoding', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPConnectionField, 'ClearHTTPConnectionField', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPAgeField, 'ClearHTTPAgeField', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPContentEncoding, 'ClearHTTPContentEncoding', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPContentEncodingField, 'ClearHTTPContentEncodingField', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPContentRangeField, 'ClearHTTPContentRangeField', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPSetCookieField, 'ClearHTTPSetCookieField', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPCommonHeaders, 'ClearHTTPCommonHeaders', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPFixedHeaders, 'ClearHTTPFixedHeaders', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPCustomHeaders, 'ClearHTTPCustomHeaders', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPCookieField, 'ClearHTTPCookieField', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPMethod, 'ClearHTTPMethod', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPRequestStartLine, 'ClearHTTPRequestStartLine', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPRequestHeader, 'ClearHTTPRequestHeader', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPRequest, 'ClearHTTPRequest', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPResponseStartLine, 'ClearHTTPResponseStartLine', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPResponseHeader, 'ClearHTTPResponseHeader', cdRegister);
 S.RegisterDelphiFunction(@ClearHTTPResponse, 'ClearHTTPResponse', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPVersion, 'BuildStrHTTPVersion', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPContentLengthValue, 'BuildStrHTTPContentLengthValue', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPContentLength, 'BuildStrHTTPContentLength', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPContentTypeValue, 'BuildStrHTTPContentTypeValue', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPContentType, 'BuildStrHTTPContentType', cdRegister);
 S.RegisterDelphiFunction(@BuildStrRFCDateTime, 'BuildStrRFCDateTime', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPDateFieldValue, 'BuildStrHTTPDateFieldValue', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPDateField, 'BuildStrHTTPDateField', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPTransferEncodingValue, 'BuildStrHTTPTransferEncodingValue', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPTransferEncoding, 'BuildStrHTTPTransferEncoding', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPContentRangeField, 'BuildStrHTTPContentRangeField', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPConnectionFieldValue, 'BuildStrHTTPConnectionFieldValue', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPConnectionField, 'BuildStrHTTPConnectionField', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPAgeField, 'BuildStrHTTPAgeField', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPContentEncoding, 'BuildStrHTTPContentEncoding', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPContentEncodingField, 'BuildStrHTTPContentEncodingField', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPProxyConnectionField, 'BuildStrHTTPProxyConnectionField', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPCommonHeaders, 'BuildStrHTTPCommonHeaders', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPFixedHeaders, 'BuildStrHTTPFixedHeaders', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPCustomHeaders, 'BuildStrHTTPCustomHeaders', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPSetCookieFieldValue, 'BuildStrHTTPSetCookieFieldValue', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPCookieFieldValue, 'BuildStrHTTPCookieFieldValue', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPCookieField, 'BuildStrHTTPCookieField', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPMethod, 'BuildStrHTTPMethod', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPRequestStartLine, 'BuildStrHTTPRequestStartLine', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPRequestHeader, 'BuildStrHTTPRequestHeader', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPRequest, 'BuildStrHTTPRequest', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPResponseCookieFieldArray, 'BuildStrHTTPResponseCookieFieldArray', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPResponseStartLine, 'BuildStrHTTPResponseStartLine', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPResponseHeader, 'BuildStrHTTPResponseHeader', cdRegister);
 S.RegisterDelphiFunction(@BuildStrHTTPResponse, 'BuildStrHTTPResponse', cdRegister);
 S.RegisterDelphiFunction(@HTTPContentTypeValueToStr, 'HTTPContentTypeValueToStr', cdRegister);
 S.RegisterDelphiFunction(@HTTPSetCookieFieldValueToStr, 'HTTPSetCookieFieldValueToStr', cdRegister);
 S.RegisterDelphiFunction(@HTTPCookieFieldValueToStr, 'HTTPCookieFieldValueToStr', cdRegister);
 S.RegisterDelphiFunction(@HTTPMethodToStr, 'HTTPMethodToStr', cdRegister);
 S.RegisterDelphiFunction(@HTTPRequestToStr, 'HTTPRequestToStr', cdRegister);
 S.RegisterDelphiFunction(@HTTPResponseToStr, 'HTTPResponseToStr', cdRegister);
 S.RegisterDelphiFunction(@PrepareCookie, 'PrepareCookie', cdRegister);
  {RIRegister_THTTPParser(CL);
  with CL.Add(THTTPContentDecoder) do
  RIRegister_THTTPContentDecoder(CL);
  with CL.Add(THTTPContentReader) do
  RIRegister_THTTPContentReader(CL);
  with CL.Add(THTTPContentWriter) do
  RIRegister_THTTPContentWriter(CL); }
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestcHTTPUtils', cdRegister);
  S.RegisterDelphiFunction(@SelfTestReader, 'SelfTestcHTTPUtilsReader', cdRegister);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cHTTPUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EHTTP) do
  with CL.Add(EHTTPParser) do
   RIRegister_THTTPParser(CL);
  with CL.Add(THTTPContentDecoder) do
  RIRegister_THTTPContentDecoder(CL);
  with CL.Add(THTTPContentReader) do
  RIRegister_THTTPContentReader(CL);
  with CL.Add(THTTPContentWriter) do
  RIRegister_THTTPContentWriter(CL);
  RIRegister_TAnsiStringBuilder(CL);

end;

 
 
{ TPSImport_cHTTPUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cHTTPUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cHTTPUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cHTTPUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cHTTPUtils(ri);
  RIRegister_cHTTPUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
