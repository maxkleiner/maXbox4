{*******************************************************}
{                                                       }
{ Borland Delphi Visual Component Library               }
{                SOAP Support                           }
{                                                       }
{ Copyright (c) 2001-2005 Borland Software Corporation  }
{                                                       }
{*******************************************************}

unit SOAPConst; 

interface

uses TypInfo, XMLSchema;

const

  SHTTPPrefix = 'http://';                                     { Do not localize }
  SContentId = 'Content-ID';                                   { Do not localize }
  SContentLocation = 'Content-Location';                       { Do not localize }
  SContentLength = 'Content-Length';                           { Do not localize }
  SContentType = 'Content-Type';                               { Do not localize }

  SWSDLMIMENamespace = 'http://schemas.xmlsoap.org/wsdl/mime/';{ Do not location }
  SBorlandMimeBoundary = 'MIME_boundaryB0R9532143182121';
  SSoapXMLHeader = '<?xml version="1.0" encoding=''UTF-8''?>'; { Do not localize }
  SUTF8 = 'UTF-8';                                             { Do not localize }
  ContentTypeTemplate = 'Content-Type: %s';                    { Do not localize }
  ContentTypeApplicationBinary = 'application/binary';         { Do not localize }
  SBinaryEncoding = 'binary';                                  { Do not localize }
  S8BitEncoding   = '8bit';                                    { Do not localize }
  ContentTypeTextPlain = 'text/plain';                         { Do not localize }
  SCharacterEncodingFormat = 'Content-transfer-encoding: %s';  { Do not localize }
  SCharacterEncoding = 'Content-transfer-encoding';            { Do not localize }
  SBoundary = 'boundary=';                                     { Do not localize }
  SMultiPartRelated = 'multipart/related';                     { Do not localize }
  SMultiPartRelatedNoSlash = 'multipartRelated';               { Do not localize }
  ContentHeaderMime = SMultiPartRelated + '; boundary=%s';     { Do not localize }
  SStart = '; start="<%s>"';                                   { Do not localize}
  SBorlandSoapStart = 'http://www.borland.com/rootpart.xml';   { Do not localize}
  SAttachmentIdPrefix = 'cid:';                                { Do not localize }

  MimeVersion = 'MIME-Version: 1.0';
  sTextHtml = 'text/html';                                 { Do not localize }
  sTextXML  = 'text/xml';                                  { Do not localize }

  ContentTypeUTF8 = 'text/xml; charset="utf-8"';           { Do not localize }
  ContentTypeNoUTF8 = 'text/xml';                          { Do not localize }

  SSoapNameSpace = 'http://schemas.xmlsoap.org/soap/envelope/'; { do not localize}
  SXMLNS = 'xmlns';                                        { do not localize}
  SSoapEncodingAttr = 'encodingStyle';                     { do not localize}
  SSoap11EncodingS5 = 'http://schemas.xmlsoap.org/soap/encoding/';  { do not localize}

  SSoapEncodingArray = 'Array';                            { do not localize}
  SSoapEncodingArrayType = 'arrayType';                    { do not localize}

  SSoapHTTPTransport = 'http://schemas.xmlsoap.org/soap/http';   { do not localize}
  SSoapBodyUseEncoded = 'encoded';                         { do not localize}
  SSoapBodyUseLiteral = 'literal';                         { do not localize}

  SSoapEnvelope = 'Envelope';                              { do not localize}
  SSoapHeader = 'Header';                                  { do not localize}
  SSoapBody = 'Body';                                      { do not localize}
  SSoapResponseSuff = 'Response';                          { do not localize}

  SRequired = 'required';                                  { do not localize }
  SSoapActor = 'actor';                                    { do not localize}
  STrue = 'true';                                          { do not localize}

  SSoapServerFaultCode = 'Server';                         { do not localize}
  SSoapServerFaultString = 'Server Error';                 { do not localize}
  SSoapFault = 'Fault';                                    { do not localize}
  SSoapFaultCode = 'faultcode';                            { do not localize}
  SSoapFaultString = 'faultstring';                        { do not localize}
  SSoapFaultActor = 'faultactor';                          { do not localize}
  SSoapFaultDetails =  'detail';                           { do not localize}
  SFaultCodeMustUnderstand = 'MustUnderstand';             { do not localize}

  SHTTPSoapAction = 'SOAPAction';                          { do not localize}

  SHeaderMustUnderstand = 'mustUnderstand';                { do not localize}
  SHeaderActor = 'actor';                                  { do not localize}
  SActorNext= 'http://schemas.xmlsoap.org/soap/actor/next';{ do not localize}

  SSoapType = 'type';                                      { do not localize}
  SSoapResponse = 'Response';                              { do not localize}
  SDefaultReturnName = 'return';                           { do not localize}
  SDefaultResultName = 'result';                           { do not localize}

  SXMLID = 'id';                                           { do not localize}
  SXMLHREF = 'href';                                       { do not localize}

  SSoapNULL = 'NULL';                                      { do not localize}
  SSoapNIL  = 'nil';                                       { do not localize}

  SHREFPre = '#';                                          { do not localize}
  SArrayIDPre = 'Array-';                                  { do not localize}
  SDefVariantElemName = 'V';                               { do not localize}

  SDefaultBaseURI = 'thismessage:/';                       { do not localize}
  SDelphiTypeNamespace = 'http://www.borland.com/namespaces/Delphi/Types';    { do not localize}
  SBorlandTypeNamespace= 'http://www.borland.com/namespaces/Types';           { do not localize}

  SOperationNameSpecifier = '%operationName%';             { Do not localize }
  SDefaultReturnParamNames= 'Result;Return';               { Do not localize }
  sReturnParamDelimiters  = ';,/:';                        { Do not localize }



  KindNameArray:  array[tkUnknown..tkDynArray] of string =
    ('Unknown', 'Integer', 'Char', 'Enumeration', 'Float',                    { do not localize }
    'String', 'Set', 'Class', 'Method', 'WChar', 'LString', 'WString',        { do not localize }
    'Variant', 'Array', 'Record', 'Interface', 'Int64', 'DynArray');          { do not localize }

  SSoapNameSpacePre = 'SOAP-ENV';            { do not localize }
  SXMLSchemaNameSpacePre = 'xsd';            { do not localize}
  SXMLSchemaInstNameSpace99Pre = 'xsi';      { do not localize}
  SSoapEncodingPre = 'SOAP-ENC';             { do not localize}

{$IFDEF D6_STYLE_COLORS}
  sDefaultColor = '#006699';
  sIntfColor    = '#006699';
  sTblHdrColor  = '#CCCC99';
  sTblColor1    = '#FFFFCC';
  sTblColor0    = '#CCCC99';
  sBkgndColor   = '#CCCC99';
  sTipColor     = '#666666';
  sWSDLColor    = '#666699';
  sOFFColor     = '#A0A0A0';
  sNavBarColor  = '#006699';
  sNavBkColor   = '#cccccc';
{$ELSE}
  sDefaultColor = '#333333';
  sIntfColor    = '#660000';
  sTblHdrColor  = '#CCCC99';
  sTblColor1    = '#f5f5dc';
  sTblColor0    = '#d9d4aa';
  sBkgndColor   = '#d9d4aa';
  sTipColor     = '#666666';
  sWSDLColor    = '#990000';
  sOFFColor     = '#A0A0A0';
  sNavBarColor  = '#660000';
  sNavBkColor   = '#f5f5dc';
{$ENDIF}

  HTMLStylBeg = '<style type="text/css"><!--' + sLineBreak;
  HTMLStylEnd = '--></style>'                 + sLineBreak;
  BodyStyle1  = 'body       {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; }'                                                       + sLineBreak;
  BodyStyle2  = 'body       {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; margin-left: 0px; margin-top: 0px; margin-right: 0px; }' + sLineBreak;
  OtherStyles = 'h1         {color: '+sDefaultColor+'; font-size: 18pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                'h2         {color: '+sDefaultColor+'; font-size: 14pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                'h3         {color: '+sDefaultColor+'; font-size: 12pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                '.h1Style   {color: '+sDefaultColor+'; font-size: 18pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                '.TblRow    {color: '+sDefaultColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: normal; }' + sLineBreak +
                '.TblRow1   {color: '+sDefaultColor+'; background-color: '+sTblColor1+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: normal; }' + sLineBreak +
                '.TblRow0   {color: '+sDefaultColor+'; background-color: '+sTblColor0+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: normal; }' + sLineBreak +
                '.TblHdr    {color: '+sTblHdrColor+ '; background-color: '+sDefaultColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: bold; text-align: center;}' + sLineBreak +
                '.IntfName  {color: '+sIntfColor  + '; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: bold; }'                             + sLineBreak +
                '.MethName  {color: '+sDefaultColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; text-decoration: none; }'       + sLineBreak +
                '.ParmName  {color: '+sDefaultColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; text-decoration: none; }'                          + sLineBreak +
                '.Namespace {color: '+sDefaultColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-style: italic; }'                             + sLineBreak +
                '.WSDL      {color: '+sWSDLColor+   '; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; }'                              + sLineBreak +
                '.MainBkgnd {background-color : '+sBkgndColor+'; }'                                                                                                          + sLineBreak +
                '.Info      {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12pt; font-weight: bold; }'                                             + sLineBreak +
                '.NavBar    {color: '+sNavBarColor+'; background-color: '+sNavBkColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold;text-decoration: none; }'+ sLineBreak +
                '.Off       {color: '+sOFFColor+'; }'                                                                                                                     + sLineBreak +
                '.Tip 	    {color: '+sTipColor+'; font-family : Verdana, Arial, Helvetica, sans-serif; font-weight : normal; font-size : 9pt; }'                         + sLineBreak;


  HTMLStyles  = HTMLStylBeg + BodyStyle1 + OtherStyles + HTMLStylEnd;
  HTMLNoMargin= HTMLStylBeg + BodyStyle2 + OtherStyles + HTMLStylEnd;

  TableStyle  = 'border=1 cellspacing=1 cellpadding=2 ';

resourcestring
  HTMLContentLanguage   = ''; // '<meta http-equiv="Content-Language" content="ja"><meta http-equiv="Content-Type" content="text/html; charset=shift_jis">';

const
  HTMLHead    = '<html><head>';
  HTMLServiceInspection = '<META name="serviceInspection" content="inspection.wsil">';

{resourcestring - these are getting truncated as resources currently resulting in bad HTML pages!!} 
  HTMLTopPlain              = HTMLHead + '</head><body>';
  HTMLTop                   = HTMLHead + '</head>'+HTMLStyles+'<body>';
  HTMLTopNoMargin           = HTMLHead + '</head>'+HTMLNoMargin+'<body>';
  HTMLTopTitleNoMargin      = HTMLHead + '<title>%s</title></head>'+HTMLNoMargin+'<body>';
  HTMLTopNoStyles           = HTMLHead + '</head><body>';
  HTMLTopTitle              = HTMLHead + '<title>%s</title></head>'+HTMLStyles+'<body>';
  HTMLTopTitleNoMarginWSIL  = HTMLHead + HTMLServiceInspection + '<title>%s</title></head>'+HTMLNoMargin+'<body>';

const
  HTMLEnd     = '</body></html>';
  InfoTitle1  = '<table class="MainBkgnd" border=0 cellpadding=0 cellspacing=0 width="100%">' +
                '<tr><td>&nbsp;</td></tr>';
  InfoTitle2  = '<tr><td class="h1Style" align="center">%s - %s</td></tr>' +
                '</table>';
  TblCls: array[Boolean] of string = ('TblRow0', 'TblRow1');
  sTblRow     = 'TblRow';
  sTblHdrCls  = 'TblHdr';

  sQueryStringIntf = 'intf';                                    { Do not localize }
  sQueryStringTypes= 'types';                                   { Do not localize }
  sNBSP = '&nbsp;';                                             { Do not localize }

var

  XMLSchemaNameSpace: string = SXMLSchemaURI_2001;    { Default namespace we publish under }
  XMLSchemaInstNameSpace: string =  SXMLSchemaInstURI;

resourcestring

  SUnsupportedEncodingSyle = 'Unsupported SOAP encodingStyle %s';
  SInvalidSoapRequest = 'Invalid SOAP request';
  SInvalidSoapResponse = 'Invalid SOAP response';
  SMultiBodyNotSupported = 'Multiple body elements not supported';
  SUnsupportedCC = 'Unsupported calling convention: %s';
  SUnsupportedCCIntfMeth = 'Remote Method Call: unsupported calling convention %s for method %s on interface %s';
  SInvClassNotRegistered  = 'No invokable class registered that implements interface %s of (soap action/path) %s';
  SInvInterfaceNotReg = 'No interface  registered for soap action ''%s''';
  SInvInterfaceNotRegURL = 'No interface  registered for URL ''%s''';
  SRemTypeNotRegistered  = 'Remotable Type %s not registered';
  STypeMismatchInParam = 'Type mismatch in parameter %s';
  SNoSuchMethod = 'No method named ''%s'' is supported by interface ''%s''';
  SInterfaceNotReg = 'Interface not registered, UUID = %s';
  SInterfaceNoRTTI = 'Interface has no RTTI, UUID = %s';
  SNoWSDL = 'No WSDL document associated with WSDLView';
  SWSDLError = 'Invalid WSDL document ''%s'' - Please verify the location and content!'#13#10'Error: %s';
  SEmptyWSDL = 'Empty document';
  sNoWSDLURL = 'No WSDL or URL property was set in the THTTPRIO component. You must set the WSDL or URL property before invoking the Web Service';
  sCantGetURL= 'Unable to retrieve the URL endpoint for Service/Port ''%s''/''%s'' from WSDL ''%s''';
  SDataTypeNotSupported = 'Datatype of TypeKind: %s not supported as argument for remote invocation';
{$IFDEF LINUX}
  SNoMatchingDelphiType = 'No matching Kylix type was found for type: URI = %s, Name = %s on Node %s';
{$ENDIF}
  SUnknownSOAPAction = 'Unknown SOAPAction %s';
  SScalarFromTRemotableS = 'Classes that represent scalar types must descend from TRemotableXS, %s does not';
  SNoSerializeGraphs = 'Must enable multiref output for objects when serializing a graph of objects - (%s)';
  SUnsuportedClassType = 'Conversion from class %s to SOAP is not supported - SOAP classes must derive from TRemotable';
  SUnexpectedDataType = 'Internal error: data type kind %s not expected in this context';
  SInvalidContentType = 'Received content of invalid Content-Type setting: %s - SOAP expects "text/xml"';

  SArrayTooManyElem = 'Array Node: %s has too many elements';
  SWrongDocElem = 'DocumentElement %s:%s expected, %s:%s found';
  STooManyParameters = 'Too many parameters in method %s';
  SArrayExpected = 'Array type expected. Node %s';

  SNoInterfaceGUID = 'Class %s does not implement interface GUID %s';
  SNoArrayElemRTTI = 'Element of Array type %s has no RTTI';
  SInvalidResponse = 'Invalid SOAP Response';
  SInvalidArraySpec = 'Invalid SOAP array specification';
  SCannotFindNodeID = 'Cannot find node referenced by ID %s';
  SNoNativeNULL = 'Option not set to allow Native type to be set to NULL';
  SFaultCodeOnlyAllowed = 'Only one FaultCode element allowed';
  SFaultStringOnlyAllowed = 'Only one FaultString element allowed';
  SMissingFaultValue = 'Missing FaultString or FaultCode element';
  SNoInterfacesInClass = 'Invokable Class %s implements no interfaces';
  SCantReturnInterface = 'Pascal code generated by WSDL import cannot be modified to return an interface.  GUID %s';

  SVariantCastNotSupported = 'Type cannot be cast as Variant';
  SVarDateNotSupported = 'varDate type not supported';
  SVarDispatchNotSupported = 'varDispatch type not supported';
  SVarErrorNotSupported = 'varError type not supported';
  SVarVariantNotSupported = 'varVariant type not supported';
  SHeaderError = 'Error Processing Header (%s)%s';
  SMissingSoapReturn = 'SOAP Response Packet: result element expected, received "%s"';
  SInvalidPointer = 'Invalid Pointer';
  SNoMessageConverter = 'No Native to Message converter set';
  SNoMsgProcessingNode = 'No Message processing node set';
  SHeaderAttributeError = 'Soap header %s with attribute ''mustUnderstand'' set to true was not handled';

  {IntfInfo}
  SNoRTTI = 'Interface %s has no RTTI';
  SNoRTTIParam = 'Parameter %s on Method %s of Interface %s has no RTTI';

  {XSBuiltIns}
  SInvalidDateString        = 'Invalid date string: %s';
  SInvalidTimeString        = 'Invalid time string: %s';
  SInvalidHour              = 'Invalid hour: %d';
  SInvalidMinute            = 'Invalid minute: %d';
  SInvalidSecond            = 'Invalid second: %d';
  SInvalidFractionSecond    = 'Invalid second: %f';
  SInvalidMillisecond       = 'Invalid millisecond: %d';
  SInvalidFractionalSecond  = 'Invalid fractional second: %f';
  SInvalidHourOffset        = 'Invalid hour offset: %d';
  SInvalidDay               = 'Invalid day: %d';
  SInvalidMonth             = 'Invalid month: %d';
  SInvalidDuration          = 'Invalid duration string: %s';
  SMilSecRangeViolation     = 'Millisecond Values must be between 000 - 999';
  SInvalidYearConversion    = 'Year portion of date too large for conversion';
  SInvalidTimeOffset        = 'Hour Offset portion of time invalid';
  SInvalidDecimalString     = 'Invalid decimal string: ''''%s''''';
  SEmptyDecimalString       = 'Cannot convert empty string to TBcd value';
  SNoSciNotation            = 'Cannot convert scientific notation to TBcd value';
  SNoNAN                    = 'Cannot convert NAN to TBcd value';
  SInvalidBcd               = 'Invalid Bcd Precision (%d) or Scale (%d)';
  SBcdStringTooBig          = 'Cannot convert to TBcd: string has more than 64 digits: %s';
  SInvalidHexValue          = '%s is not a valid hex string';
  SInvalidHTTPRequest       = 'Invalid HTTP Request: Length is 0';
  SInvalidHTTPResponse      = 'Invalid HTTP Response: Length is 0';

  {WebServExp}
  SInvalidBooleanParameter  = 'ByteBool, WordBool and LongBool cannot be exposed by WebServices. Please use ''Boolean''';    

  {WSDLIntf}
  SWideStringOutOfBounds = 'WideString index out of bounds';

  {WSDLPub}
  IWSDLPublishDoc = 'Lists all the PortTypes published by this Service';

  SNoServiceForURL = 'No service available for URL %s';
  SNoInterfaceForURL = 'No interface is registered to handle URL %s';
  SNoClassRegisteredForURL = 'No Class is regisgtered to implement interface %s';
  SEmptyURL = 'No URL was specified for ''GET''';
  SInvalidURL = 'Invalid url ''%s'' - only supports ''http'' and ''https'' schemes';
  SNoClassRegistered = 'No class registered for invokable interface %s';
  SNoDispatcher = 'No Dispatcher set';
  SMethNoRTTI = 'Method has no RTTI';
  SUnsupportedVariant = 'Unsuppported variant type %d';
  SNoVarDispatch = 'varDispatch type not supported';
  SNoErrorDispatch = 'varError type not supported';
  SUnknownInterface = '(Unknown)';

  SInvalidTimeZone = 'Invalid or Unknown Time Zone';

  sUnknownError = 'Unknown Error';
  sErrorColon   = 'Error: ';
  sServiceInfo  = '%s - PortTypes:';
  sInterfaceInfo= '<a href="%s">%s</a>&nbsp;&gt;&nbsp;<span class="Off">%s</span>';
  sWSILInfo     = 'WSIL:';
  sWSILLink     = '&nbsp;&nbsp;<span class="Tip">Link to WS-Inspection document of Services <a href="%s">here</a></span>';
  sRegTypes     = 'Registered Types';

  sWebServiceListing      = 'EKON 10 WebService Listing';
  sWebServiceListingAdmin = 'WebService Listing Administrator';
  sPortType               = 'Port Type';
  sNameSpaceURI           = 'Namespace URI';
  sDocumentation          = 'Documentation';
  sWSDL                   = 'WSDL';
  sPortName               = 'PortName';
  sInterfaceNotFound      = HTMLHead + '</head><body>' + '<h1>Error Encountered</h1><P>Interface %s not found</P>' +HTMLEnd;
  sForbiddenAccess        = HTMLHead + '</head><body>' + '<h1>Forbidden (403)</h1><P>Access Forbidden</P>' +HTMLEnd;
  sWSDLPortsforPortType   = 'WSDL Ports for PortType';
  sWSDLFor                = '';
  sServiceInfoPage        = 'Service Info Page';

{SOAPAttach}
  SEmptyStream = 'TAggregateStream Error: no internal streams';
  SMethodNotSupported = 'method not supported';
  SInvalidMethod = 'Method not permitted in TSoapDataList';
  SNoContentLength = 'Content-Length header not found';
  SInvalidContentLength = 'Insufficient data for Content-Length';
  SMimeReadError = 'Error reading from Mime Request Stream';
{$IFDEF MSWINDOWS}
  STempFileAccessError = 'No access to temporary file';
{$ENDIF}
{$IFDEF LINUX}
  STempFileAccessError = 'No access to temporary file: check TMPDIR setting';
{$ENDIF}

{SoapConn}
  SSOAPServerIIDFmt = '%s - %s';
  SNoURL = 'No URL property set - please specify the URL of the Service you wish to connect to';
  SSOAPInterfaceNotRegistered = 'Interface (%s) is not registered - please include the unit that registers this interface to your project';
  SSOAPInterfaceNotRemotable  = 'Interface (%s) canno be remoted - please verify the interface declaration - specially the methods calling convention!';

  SCantLoadLocation = 'Unable to load WSDL File/Location: %s.  Error [%s]';

implementation

end.
