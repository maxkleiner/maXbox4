{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 4.00                                        }
{   File name:        cHTTPUtils.pas                                           }
{   File version:     0.08                                                     }
{   Description:      HTTP utilities.                                          }
{                                                                              }
{   Copyright:        Copyright (c) 2011, David J Butler                       }
{                     All rights reserved.                                     }
{                     This file is licensed under the BSD License.             }
{                     See http://www.opensource.org/licenses/bsd-license.php   }
{                     Redistribution and use in source and binary forms, with  }
{                     or without modification, are permitted provided that     }
{                     the following conditions are met:                        }
{                     Redistributions of source code must retain the above     }
{                     copyright notice, this list of conditions and the        }
{                     following disclaimer.                                    }
{                     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND   }
{                     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED          }
{                     WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED   }
{                     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A          }
{                     PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL     }
{                     THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,    }
{                     INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR             }
{                     CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,    }
{                     PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF     }
{                     USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)         }
{                     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER   }
{                     IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING        }
{                     NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE   }
{                     USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE             }
{                     POSSIBILITY OF SUCH DAMAGE.                              }
{                                                                              }
{   Home page:        http://fundementals.sourceforge.net                      }
{   Forum:            http://sourceforge.net/forum/forum.php?forum_id=2117     }
{   E-mail:           fundamentals.library@gmail.com                           }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{  2011/06/05  0.01  Initial development on HTTP parser                        }
{  2011/06/11  0.02  Further development. Simple test cases.                   }
{  2011/06/12  0.03  Structure to string functions.                            }
{  2011/06/13  0.04  Content decoder class.                                    }
{  2011/06/16  0.05  Chunked encoding decoder.                                 }
{  2011/06/17  0.06  Cookie/Set-Cookie fields.                                 }
{  2011/06/25  0.07  Content reader/writer classes.                            }
{  2011/07/31  0.08  Improved logging.                                         }
{                                                                              }
{ References:                                                                  }
{ * HTTP/1.1 : http://www.w3.org/Protocols/rfc2616/rfc2616.html                }
{ * Chunked encoding : http://tools.ietf.org/html/rfc2616#section-3.6.1        }
{ * Origin header : https://wiki.mozilla.org/Security/Origin                   }
{ * http://homepage.ntlworld.com./jonathan.deboynepollard/FGA/web-proxy-connection-header.html }
{ * http://www.w3.org/TR/html4/interact/forms.html                             }
{                                                                              }
{******************************************************************************}

//{$INCLUDE cHTTP.inc}

{$DEFINE HTTP_SELFTEST}


unit cHTTPUtils;

interface

uses
  { System }
  SysUtils,
  Classes,
  { Fundamentals }
  //cStrings,
  cTCPBuffer;



type
  { Errors }

  EHTTP = class(Exception);

  EHTTPParser = class(EHTTP);



  { Generic types }

  AnsiCharSet = set of AnsiChar;
  AnsiStringArray = array of AnsiString;



  { Version }

  THTTPProtocolEnum = (
    hpNone,
    hpCustom,
    hpHTTP,
    hpHTTPS);

  THTTPVersionEnum = (
    hvNone,
    hvCustom,
    hvHTTP10,
    hvHTTP11);

  THTTPVersion = record
    Version          : THTTPVersionEnum;
    Protocol         : THTTPProtocolEnum;
    CustomProtocol   : AnsiString;
    CustomMajVersion : Integer;
    CustomMinVersion : Integer;
  end;



  { Header name }

  THTTPHeaderNameEnum = (
    hntCustom,
    hntHost,
    hntContentType,
    hntContentLength,
    hntContentTransferEncoding,
    hntContentLocation,
    hntContentLanguage,
    hntContentEncoding,
    hntTransferEncoding,
    hntDate,
    hntServer,
    hntUserAgent,
    hntLocation,
    hntConnection,
    hntExpires,
    hntCacheControl,
    hntSetCookie,
    hntCookie,
    hntAuthorization,
    hntVia,
    hntWarning,
    hntContentRange,
    hntXForwardedFor,
    hntPragma,
    hntXPoweredBy,
    hntWWWAuthenticate,
    hntLastModified,
    hntETag,
    hntProxyAuthorization,
    hntReferer,
    hntAge,
    hntAcceptRanges,
    hntAcceptEncoding,
    hntAcceptLanguage,
    hntAcceptCharset,
    hntIfModifiedSince,
    hntIfUnmodifiedSince,
    hntRetryAfter,
    hntUpgrade,
    hntStatus,
    hntProxyConnection,
    hntOrigin,
    hntKeepAlive);

  THTTPHeaderName = record
    Value  : THTTPHeaderNameEnum;
    Custom : AnsiString;
  end;



  { Header }

  THTTPCustomHeader = record
    FieldName  : AnsiString;
    FieldValue : AnsiString;
  end;
  PHTTPCustomHeader = ^THTTPCustomHeader;



  { Content Length }

  THTTPContentLengthEnum = (
    hcltNone,
    hcltByteCount);

  THTTPContentLength = record
    Value     : THTTPContentLengthEnum;
    ByteCount : Int64;
  end;
  PHTTPContentLength = ^THTTPContentLength;



  { Content Type }

  THTTPContentTypeMajor = (
    hctmCustom,
    hctmText,
    hctmImage);

  THTTPContentTypeEnum = (
    hctNone,
    hctCustomParts,
    hctCustomString,
    hctTextHtml,
    hctTextAscii,
    hctTextCss,
    hctTextPlain,
    hctTextXml,
    hctTextCustom,
    hctImageJpeg,
    hctImagePng,
    hctImageGif,
    hctImageCustom,
    hctApplicationJSON,
    hctApplicationOctetStream,
    hctApplicationJavaScript,
    hctApplicationCustom,
    hctAudioCustom,
    hctVideoCustom);

  THTTPContentType = record
    Value       : THTTPContentTypeEnum;
    CustomMajor : AnsiString;
    CustomMinor : AnsiString;
    Parameters  : AnsiStringArray;
    CustomStr   : AnsiString;
  end;



  { Date }

  THTTPDateFieldEnum = (
    hdNone,
    hdCustom,
    hdParts,
    hdDateTime);

  THTTPDateField = record
    Value            : THTTPDateFieldEnum;
    DayOfWeek        : Integer;
    Day, Month, Year : Integer;
    Hour, Min, Sec   : Integer;
    TimeZoneGMT      : Boolean;
    CustomTimeZone   : AnsiString;
    DateTime         : TDateTime;
    Custom           : AnsiString;
  end;



  { Transfer-Encoding }

  THTTPTransferEncodingEnum = (
    hteNone,
    hteCustom,
    hteChunked);

  THTTPTransferEncoding = record
    Value  : THTTPTransferEncodingEnum;
    Custom : AnsiString;
  end;



  { Connection }

  THTTPConnectionFieldEnum = (
    hcfNone,
    hcfCustom,
    hcfClose,
    hcfKeepAlive);

  THTTPConnectionField = record
    Value  : THTTPConnectionFieldEnum;
    Custom : AnsiString;
  end;



  { Age }

  THTTPAgeFieldEnum = (
    hafNone,
    hafCustom,
    hafAge);

  THTTPAgeField = record
    Value  : THTTPAgeFieldEnum;
    Age    : Int64;
    Custom : AnsiString;
  end;



  { Cache Control *** }

  THTTPCacheControlFieldEnum = (
    hccfNone,
    hccfDecoded,
    hccfCustom);

  THTTPCacheControlRequestSubField = (
    hccsfNoCache,
    hccsfNoStore,
    hccsfMaxAge,
    hccsfMaxStale,
    hccsfMinFresh,
    hccsfNoTransform,
    hccsfOnlyIfCached);

  THTTPCacheControlResponseSubField = (
    hccrfPublic,
    hccrfPrivate,
    hccrfNoCache,
    hccrfNoStore,
    hccrfNoTransform,
    hccrfMustRevalidate,
    hccrfProxyRevalidate,
    hccrfMaxAge,
    hccrfSMaxAge);

  THTTPCacheControlField = record
    Value : THTTPCacheControlFieldEnum;
  end;



  { Content-Encoding }

  THTTPContentEncodingEnum = (
    hceNone,
    hceCustom,
    hceIdentity,
    hceCompress,
    hceDeflate,
    hceExi,
    hceGzip,
    hcePack200Gzip);

  THTTPContentEncoding = record
    Value  : THTTPContentEncodingEnum;
    Custom : AnsiString;
  end;

  THTTPContentEncodingFieldEnum = (
    hcefNone,
    hcefList);

  THTTPContentEncodingField = record
    Value : THTTPContentEncodingFieldEnum;
    List  : array of THTTPContentEncoding;
  end;



  { Retry After *** }

  THTTPRetryAfterFieldEnum = (
    hrafNone,
    hrafCustom,
    harfDate,
    harfSeconds);

  THTTPRetryAfterField = record
    Value   : THTTPRetryAfterFieldEnum;
    Custom  : AnsiString;
    Date    : TDateTime;
    Seconds : Int64;
  end;

  

  { Content-Range *** }

  THTTPContentRangeFieldEnum = (
    hcrfNone,
    hcrfCustom,
    hcrfByteRange);

  THTTPContentRangeField = record
    Value     : THTTPContentRangeFieldEnum;
    ByteFirst : Int64;
    ByteLast  : Int64;
    ByteSize  : Int64;
    Custom    : AnsiString;
  end;



  { Set Cookie }

  THTTPSetCookieFieldEnum = (
    hscoNone,
    hscoDecoded,
    hscoCustom);

  THTTPSetCookieCustomField = record
    Name  : AnsiString;
    Value : AnsiString;
  end;
  PHTTPSetCookieCustomField = ^THTTPSetCookieCustomField;

  THTTPSetCookieCustomFieldArray = array of THTTPSetCookieCustomField;

  THTTPSetCookieField = record
    Value        : THTTPSetCookieFieldEnum;
    Domain       : AnsiString;
    Path         : AnsiString;
    Expires      : THTTPDateField;
    MaxAge       : Int64;
    HttpOnly     : Boolean;
    Secure       : Boolean;
    CustomFields : THTTPSetCookieCustomFieldArray;
    Custom       : AnsiString;
  end;
  PHTTPSetCookieField = ^THTTPSetCookieField;

  THTTPSetCookieFieldArray = array of THTTPSetCookieField;



  { Cookie }

  THTTPCookieFieldEnum = (
    hcoNone,
    hcoDecoded,
    hcoCustom);

  THTTPCookieFieldEntry = record
    Name  : AnsiString;
    Value : AnsiString;
  end;
  PHTTPCookieFieldEntry = ^THTTPCookieFieldEntry;

  THTTPCookieFieldEntryArray = array of THTTPCookieFieldEntry;

  THTTPCookieField = record
    Value   : THTTPCookieFieldEnum;
    Entries : THTTPCookieFieldEntryArray;
    Custom  : AnsiString;
  end;

  

  { Common headers }

  THTTPCommonHeaders = record
    TransferEncoding : THTTPTransferEncoding;
    ContentType      : THTTPContentType;
    ContentLength    : THTTPContentLength;
    Connection       : THTTPConnectionField;
    ProxyConnection  : THTTPConnectionField;
    Date             : THTTPDateField;
    ContentEncoding  : THTTPContentEncodingField;
  end;



  { Fixed headers }

  THTTPFixedHeaders = array[THTTPHeaderNameEnum] of AnsiString;



  { Custom headers }

  THTTPCustomHeaders = array of THTTPCustomHeader;



  { Method }

  THTTPMethodEnum = (
    hmNone,
    hmCustom,
    hmGET,
    hmPUT,
    hmPOST,
    hmCONNECT,
    hmHEAD,
    hmDELETE,
    hmOPTIONS,
    hmTRACE);

  THTTPMethod = record
    Value  : THTTPMethodEnum;
    Custom : AnsiString;
  end;



  { Request }

  THTTPRequestStartLine = record
    Method  : THTTPMethod;
    URI     : AnsiString;
    Version : THTTPVersion;
  end;

  THTTPRequestHeader = record
    CommonHeaders     : THTTPCommonHeaders;
    FixedHeaders      : THTTPFixedHeaders;
    CustomHeaders     : THTTPCustomHeaders;
    Cookie            : THTTPCookieField;
    IfModifiedSince   : THTTPDateField;
    IfUnmodifiedSince : THTTPDateField;
  end;
  PHTTPRequestHeader = ^THTTPRequestHeader;

  THTTPRequest = record
    StartLine      : THTTPRequestStartLine;
    Header         : THTTPRequestHeader;
    HeaderComplete : Boolean;
    HasContent     : Boolean;
  end;



  { Response }

  THTTPResponseStartLineMessage = (
    hslmNone,
    hslmCustom,
    hslmOK);

  THTTPResponseStartLine = record
    Version   : THTTPVersion;
    Code      : Integer;
    Msg       : THTTPResponseStartLineMessage;
    CustomMsg : AnsiString;
  end;

  THTTPResponseHeader = record
    CommonHeaders : THTTPCommonHeaders;
    FixedHeaders  : THTTPFixedHeaders;
    CustomHeaders : THTTPCustomHeaders;
    Cookies       : THTTPSetCookieFieldArray;
    Expires       : THTTPDateField;
    LastModified  : THTTPDateField;
    Age           : THTTPAgeField;
  end;
  PHTTPResponseHeader = ^THTTPResponseHeader;

  THTTPResponse = record
    StartLine      : THTTPResponseStartLine;
    Header         : THTTPResponseHeader;
    HeaderComplete : Boolean;
    HasContent     : Boolean;
  end;

  type
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
  end;




{ Structure helpers }

function  HTTPMessageHasContent(const H: THTTPCommonHeaders): Boolean;

procedure InitHTTPRequest(var A: THTTPRequest);
procedure InitHTTPResponse(var A: THTTPResponse);

procedure ClearHTTPVersion(var A: THTTPVersion);
procedure ClearHTTPContentLength(var A: THTTPContentLength);
procedure ClearHTTPContentType(var A: THTTPContentType);
procedure ClearHTTPDateField(var A: THTTPDateField);
procedure ClearHTTPTransferEncoding(var A: THTTPTransferEncoding);
procedure ClearHTTPConnectionField(var A: THTTPConnectionField);
procedure ClearHTTPAgeField(var A: THTTPAgeField);
procedure ClearHTTPContentEncoding(var A: THTTPContentEncoding);
procedure ClearHTTPContentEncodingField(var A: THTTPContentEncodingField);
procedure ClearHTTPContentRangeField(var A: THTTPContentRangeField);
procedure ClearHTTPSetCookieField(var A: THTTPSetCookieField);
procedure ClearHTTPCommonHeaders(var A: THTTPCommonHeaders);
procedure ClearHTTPFixedHeaders(var A: THTTPFixedHeaders);
procedure ClearHTTPCustomHeaders(var A: THTTPCustomHeaders);
procedure ClearHTTPCookieField(var A: THTTPCookieField);
procedure ClearHTTPMethod(var A: THTTPMethod);
procedure ClearHTTPRequestStartLine(var A: THTTPRequestStartLine);
procedure ClearHTTPRequestHeader(var A: THTTPRequestHeader);
procedure ClearHTTPRequest(var A: THTTPRequest);
procedure ClearHTTPResponseStartLine(var A: THTTPResponseStartLine);
procedure ClearHTTPResponseHeader(var A: THTTPResponseHeader);
procedure ClearHTTPResponse(var A: THTTPResponse);

type
  THTTPStringOption = (hsoNone);
  THTTPStringOptions = set of THTTPStringOption;

procedure BuildStrHTTPVersion(const A: THTTPVersion; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPContentLengthValue(const A: THTTPContentLength; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPContentLength(const A: THTTPContentLength; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPContentTypeValue(const A: THTTPContentType; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPContentType(const A: THTTPContentType; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrRFCDateTime(
          const DOW, Da, Mo, Ye, Ho, Mi, Se: Integer;
          const TZ: AnsiString;
          const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPDateFieldValue(const A: THTTPDateField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPDateField(const A: THTTPDateField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPTransferEncodingValue(const A: THTTPTransferEncoding; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPTransferEncoding(const A: THTTPTransferEncoding; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPContentRangeField(const A: THTTPContentRangeField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPConnectionFieldValue(const A: THTTPConnectionField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPConnectionField(const A: THTTPConnectionField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPAgeField(const A: THTTPAgeField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPContentEncoding(const A: THTTPContentEncoding; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPContentEncodingField(const A: THTTPContentEncodingField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPProxyConnectionField(const A: THTTPConnectionField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPCommonHeaders(const A: THTTPCommonHeaders; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPFixedHeaders(const A: THTTPFixedHeaders; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPCustomHeaders(const A: THTTPCustomHeaders; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPSetCookieFieldValue(const A: THTTPSetCookieField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPCookieFieldValue(const A: THTTPCookieField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPCookieField(const A: THTTPCookieField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPMethod(const A: THTTPMethod; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPRequestStartLine(const A: THTTPRequestStartLine; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPRequestHeader(const A: THTTPRequestHeader; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPRequest(const A: THTTPRequest; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPResponseCookieFieldArray(const A: THTTPSetCookieFieldArray; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPResponseStartLine(const A: THTTPResponseStartLine; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPResponseHeader(const A: THTTPResponseHeader; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
procedure BuildStrHTTPResponse(const A: THTTPResponse; const B: TAnsiStringBuilder; const P: THTTPStringOptions);

function  HTTPContentTypeValueToStr(const A: THTTPContentType): AnsiString;
function  HTTPSetCookieFieldValueToStr(const A: THTTPSetCookieField): AnsiString;
function  HTTPCookieFieldValueToStr(const A: THTTPCookieField): AnsiString;
function  HTTPMethodToStr(const A: THTTPMethod): AnsiString;

function  HTTPRequestToStr(const A: THTTPRequest): AnsiString;
function  HTTPResponseToStr(const A: THTTPResponse): AnsiString;

procedure PrepareCookie(var A: THTTPCookieField;
          const B: THTTPSetCookieFieldArray;
          const Domain: AnsiString;
          const Secure: Boolean);

          

{ THTTPParser }

type
  THTTPParserHeaderParseFunc = function (const HeaderName: THTTPHeaderNameEnum; const HeaderPtr: Pointer): Boolean of object;

  THTTPParser = class
  private
    FBufPtr    : Pointer;
    FBufSize   : Integer;
    FBufPos    : Integer;
    FBufStrRef : AnsiString;

    function  EOF: Boolean;

    function  MatchStrAndCh(const S: AnsiString; const CaseSensitive: Boolean; const C: AnsiCharSet): Boolean;
    function  MatchStr(const S: AnsiString; const CaseSensitive: Boolean): Boolean;

    function  SkipStrAndCh(const S: AnsiString; const DelimSet: AnsiCharSet; const SkipDelim: Boolean; const CaseSensitive: Boolean): Boolean;
    function  SkipCh(const C: AnsiCharSet): Boolean;
    function  SkipAllCh(const C: AnsiCharSet): Boolean;
    function  SkipToStr(const S: AnsiString; const CaseSensitive: Boolean): Boolean;

    function  SkipCRLF: Boolean;
    function  SkipSpace: Boolean;
    function  SkipLWS: Boolean;
    function  SkipToCRLF: Boolean;

    function  ExtractAllCh(const C: AnsiCharSet): AnsiString;
    function  ExtractTo(const C: AnsiCharSet; var S: AnsiString; const SkipDelim: Boolean): AnsiChar;
    function  ExtractStrTo(const C: AnsiCharSet; const SkipDelim: Boolean): AnsiString;
    function  ExtractInt(const Default: Int64): Int64;
    function  ExtractIntTo(const C: AnsiCharSet; const SkipDelim: Boolean; const Default: Int64): Int64;

    procedure ParseCustomVersion(var Protocol: THTTPVersion);
    procedure ParseVersion(var Version: THTTPVersion);

    procedure ParseHeaderName(var HeaderName: THTTPHeaderName);
    procedure ParseHeaderValue(var HeaderValue: AnsiString);

    procedure ParseTransferEncoding(var Value: THTTPTransferEncoding);
    procedure ParseContentType(var Value: THTTPContentType);
    procedure ParseContentLength(var Value: THTTPContentLength);
    procedure ParseConnectionField(var Value: THTTPConnectionField);
    procedure ParseDateField(var Value: THTTPDateField);
    procedure ParseAgeField(var Value: THTTPAgeField);
    procedure ParseContentEncoding(var Value: THTTPContentEncoding);
    procedure ParseContentEncodingField(var Value: THTTPContentEncodingField);
    function  ParseCommonHeaderValue(const HeaderName: THTTPHeaderNameEnum; var Headers: THTTPCommonHeaders): Boolean;
    procedure ParseSetCookieField(var Cookie: THTTPSetCookieField);

    function  ParseHeader(
              const ParseEvent: THTTPParserHeaderParseFunc;
              const HeaderPtr: Pointer;
              var CommonHeaders: THTTPCommonHeaders;
              var HeaderName: THTTPHeaderName;
              var HeaderValue: AnsiString): Boolean;

    function  ParseContent(const Headers: THTTPCommonHeaders): Boolean;

    procedure ParseRequestMethod(var Method: THTTPMethod);
    procedure ParseRequestURI(var URI: AnsiString);
    function  ParseRequestStartLine(var StartLine: THTTPRequestStartLine): Boolean;
    function  ParseRequestHeaderValue(const HeaderName: THTTPHeaderNameEnum; const HeaderPtr: Pointer): Boolean;
    function  ParseRequestHeader(var Header: THTTPRequestHeader): Boolean;
    function  ParseRequestContent(var Request: THTTPRequest): Boolean;

    procedure ParseResponseCode(var Code: Integer);
    function  ParseResponseStartLine(var StartLine: THTTPResponseStartLine): Boolean;
    function  ParseResponseHeaderValue(const HeaderName: THTTPHeaderNameEnum; const HeaderPtr: Pointer): Boolean;
    function  ParseResponseHeader(var Header: THTTPResponseHeader): Boolean;
    function  ParseResponseContent(var Response: THTTPResponse): Boolean;

  public
    constructor Create;
    destructor Destroy; override;

    procedure SetTextBuf(const Buf; const BufSize: Integer);
    procedure SetTextStr(const S: AnsiString);

    procedure ParseRequest(var Request: THTTPRequest);
    procedure ParseResponse(var Response: THTTPResponse);
  end;



{ THTTPContentDecoder } 

type
  THTTPContentDecoder = class;

  THTTPContentDecoderReadProc = function (const Sender: THTTPContentDecoder;
      var Buf; const Size: Integer): Integer of object;
  THTTPContentDecoderProc = procedure (const Sender: THTTPContentDecoder) of object;
  THTTPContentDecoderContentProc = procedure (const Sender: THTTPContentDecoder;
      const Buf; const Size: Integer) of object;

  THTTPContentDecoderContentType = (
      crctFixedSize,
      crctChunked,
      crctUnsized);

  THTTPContentDecoderChunkState = (
      crcsChunkHeader,
      crcsContent,
      crcsContentCRLF,
      crcsTrailer,
      crcsFinished);

  THTTPContentDecoderLogEvent = procedure (const Sender: THTTPContentDecoder;
      const LogMsg: String) of object;

  THTTPContentDecoder = class
  private
    FReadProc        : THTTPContentDecoderReadProc;
    FContentProc     : THTTPContentDecoderContentProc;
    FCompleteProc    : THTTPContentDecoderProc;

    FOnLog           : THTTPContentDecoderLogEvent;

    FContentType     : THTTPContentDecoderContentType;
    FContentSize     : Int64;
    FContentReceived : Int64;
    FContentComplete : Boolean;

    FChunkState      : THTTPContentDecoderChunkState;
    FChunkBuf        : TTCPBuffer;
    FChunkSize       : Int64;
    FChunkProcessed  : Int64;

    procedure Init;

    procedure Log(const LogMsg: String); overload;
    procedure Log(const LogMsg: String; const LogArgs: array of const); overload;

    procedure TriggerContentBuffer(const Buf; const Size: Integer);
    procedure TriggerContentComplete;
    procedure TriggerTrailer(const Hdr: AnsiString);

    procedure ProcessFixedSize;
    procedure ProcessUnsized;
    function  ProcessChunked_FillBuf(const Size: Integer): Boolean;
    function  ProcessChunked_FillBufBlock(const Size: Integer): Boolean;
    function  ProcessChunked_FillBufToCRLF(const BlockSize: Integer): Integer;
    function  ProcessChunked_ReadStrToCRLF(const BlockSize: Integer; var Str: AnsiString): Boolean;
    function  ProcessChunked_ExpectCRLF: Boolean;
    function  ProcessChunked_BufferCRLFPosition: Integer;
    function  ProcessChunked_ReadHeader(var HdrStr: AnsiString; var ChunkSize: Int64): Boolean;
    function  ProcessChunked_Header: Boolean;
    function  ProcessChunked_Content: Boolean;
    function  ProcessChunked_ContentCRLF: Boolean;
    function  ProcessChunked_Trailer: Boolean;
    procedure ProcessChunked_Finalise;
    procedure ProcessChunked;

  public
    constructor Create(
                const ReadProc: THTTPContentDecoderReadProc;
                const ContentProc: THTTPContentDecoderContentProc;
                const CompleteProc: THTTPContentDecoderProc);
    destructor Destroy; override;

    property  OnLog: THTTPContentDecoderLogEvent read FOnLog write FOnLog;

    property  ContentSize: Int64 read FContentSize;
    property  ContentReceived: Int64 read FContentReceived;
    property  ContentComplete: Boolean read FContentComplete;

    procedure InitDecoder(const CommonHeaders: THTTPCommonHeaders);
    procedure Process;
  end;



{ THTTPContentReader }

type
  THTTPContentReaderMechanism = (
      hcrmEvent,
      hcrmString,
      hcrmStream,
      hcrmFile);

  THTTPContentReader = class;

  THTTPContentReaderReadProc = function (const Sender: THTTPContentReader;
      var Buf; const Size: Integer): Integer of object;
  THTTPContentReaderContentProc = procedure (const Sender: THTTPContentReader;
      const Buffer; const Size: Integer) of object;
  THTTPContentReaderProc = procedure (const Sender: THTTPContentReader) of object;

  THTTPContentReaderLogEvent = procedure (const Sender: THTTPContentReader;
      const LogMsg: String; const LogLevel: Integer) of object;

  THTTPContentReader = class
  private
    FReadProc     : THTTPContentReaderReadProc;
    FContentProc  : THTTPContentReaderContentProc;
    FCompleteProc : THTTPContentReaderProc;

    FOnLog        : THTTPContentReaderLogEvent;

    FMechanism       : THTTPContentReaderMechanism;
    FContentStream   : TStream;
    FContentFileName : String;

    FContentDecoder       : THTTPContentDecoder;
    FContentStringBuilder : TAnsiStringBuilder;
    FContentString        : AnsiString;
    FContentFile          : TStream;
    FContentComplete      : Boolean;

    procedure Init;

    procedure Log(const LogMsg: String; const LogLevel: Integer = 0); overload;
    procedure Log(const LogMsg: String; const LogArgs: array of const; const LogLevel: Integer = 0); overload;

    procedure ContentDecoderLog(const Sender: THTTPContentDecoder; const LogMsg: String);
    function  ContentDecoderReadProc(const Sender: THTTPContentDecoder;
              var Buf; const Size: Integer): Integer;
    procedure ContentDecoderContentProc(const Sender: THTTPContentDecoder;
              const Buf; const Size: Integer);
    procedure ContentDecoderCompleteProc(const Sender: THTTPContentDecoder);

    procedure InternalReset;

  public
    constructor Create(
                const ReadProc: THTTPContentReaderReadProc;
                const ContentProc: THTTPContentReaderContentProc;
                const CompleteProc: THTTPContentReaderProc);
    destructor Destroy; override;

    property  OnLog: THTTPContentReaderLogEvent read FOnLog write FOnLog;

    property  Mechanism: THTTPContentReaderMechanism read FMechanism write FMechanism;
    property  ContentStream: TStream read FContentStream write FContentStream;
    property  ContentFileName: String read FContentFileName write FContentFileName;

    procedure InitReader(const CommonHeaders: THTTPCommonHeaders);
    procedure Process;

    property  ContentComplete: Boolean read FContentComplete;
    property  ContentString: AnsiString read FContentString;

    procedure Reset;
  end;



{ THTTPContentWriter }

type
  THTTPContentWriterMechanism = (
      hctmEvent,
      hctmString,
      hctmStream,
      hctmFile);

  THTTPContentWriter = class;

  THTTPContentWriterWriteProc = function (const Sender: THTTPContentWriter;
      const Buf; const Size: Integer): Integer of object;

  THTTPContentWriterLogEvent = procedure (const Sender: THTTPContentWriter;
      const LogMsg: AnsiString) of object;

  THTTPContentWriter = class
  private
    FWriteProc : THTTPContentWriterWriteProc;

    FOnLog : THTTPContentWriterLogEvent;

    FMechanism       : THTTPContentWriterMechanism;
    FContentString   : AnsiString;
    FContentStream   : TStream;
    FContentFileName : String;

    FContentFile     : TStream;
    FContentComplete : Boolean;

    procedure Init;

    procedure Log(const LogMsg: AnsiString);

    procedure WriteBuf(const Buf; const Size: Integer);
    procedure WriteStr(const S: AnsiString);

    procedure InternalReset;

  public
    constructor Create(const WriteProc: THTTPContentWriterWriteProc);
    destructor Destroy; override;

    property  OnLog: THTTPContentWriterLogEvent read FOnLog write FOnLog;

    property  Mechanism: THTTPContentWriterMechanism read FMechanism write FMechanism;
    property  ContentString: AnsiString read FContentString write FContentString;
    property  ContentStream: TStream read FContentStream write FContentStream;
    property  ContentFileName: String read FContentFileName write FContentFileName;

    procedure InitContent(var ContentLength: Int64);
    procedure SendContent;
    property  ContentComplete: Boolean read FContentComplete;
    procedure FinaliseContent;
    procedure Reset;
  end;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF HTTP_SELFTEST}
procedure SelfTest;
{$ENDIF}


               implementation

uses
  { Fundamentals }
  cUtils,
  cDateTime;



{ Structure helpers }

const
  HTTP_Space = #32;
  HTTP_CRLF  = #13#10;

  HTTP_MethodStr : array[THTTPMethodEnum] of AnsiString = (
    '',
    '',
    'GET',
    'PUT',
    'POST',
    'CONNECT',
    'HEAD',
    'DELETE',
    'OPTIONS',
    'TRACE');

  HTTP_HeaderNameList : array[THTTPHeaderNameEnum] of AnsiString = (
    '',
    'Host',
    'Content-Type',
    'Content-Length',
    'Content-Transfer-Encoding',
    'Content-Location',
    'Content-Language',
    'Content-Encoding',
    'Transfer-Encoding',
    'Date',
    'Server',
    'User-Agent',
    'Location',
    'Connection',
    'Expires',
    'Cache-Control',
    'Set-Cookie',
    'Cookie',
    'Authorization',
    'Via',
    'Warning',
    'Content-Range',
    'X-Forwarded-For',
    'Pragma',
    'X-Powered-By',
    'WWW-Authenticate',
    'Last-Modified',
    'ETag',
    'Proxy-Authorization',
    'Referer',
    'Age',
    'Accept-Ranges',
    'Accept-Encoding',
    'Accept-Language',
    'Accept-Charset',
    'If-Modified-Since',
    'If-Unmodified-Since',
    'Retry-After',
    'Upgrade',
    'Status',
    'Proxy-Connection',
    'Origin',
    'Keep-Alive');

  HTTP_ContentTypeStr : array[THTTPContentTypeEnum] of AnsiString = (
    '',
    '',
    '',
    'text/html',
    'text/ascii',
    'text/css',
    'text/plain',
    'text/xml',
    'text/',
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/',
    'application/json',
    'application/octet-stream',
    'application/javascript',
    'application/',
    'audio/',
    'video/');

  HTTP_ContentEncodingStr : array[THTTPContentEncodingEnum] of AnsiString = (
    '',
    '',
    'identity',
    'compress',
    'deflate',
    'exi',
    'gzip',
    'pack200-gzip');

const
  RFC850DayNames : array[1..7] of AnsiString = (
      'Sunday', 'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday');
  RFC1123DayNames : array[1..7] of AnsiString = (
      'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
  RFCMonthNames : array[1..12] of AnsiString = (
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');



procedure AddCustomHeader(
          var CustomHeaders: THTTPCustomHeaders;
          const HeaderName: AnsiString;
          const HeaderValue: AnsiString);
var L : Integer;
begin
  L := Length(CustomHeaders);
  SetLength(CustomHeaders, L + 1);
  CustomHeaders[L].FieldName := HeaderName;
  CustomHeaders[L].FieldValue := HeaderValue;
end;

procedure AddStringArray(var A: AnsiStringArray; const B: AnsiString);
var L : Integer;
begin
  L := Length(A);
  SetLength(A, L + 1);
  A[L] := B;
end;

function HTTPMessageHasContent(const H: THTTPCommonHeaders): Boolean;
begin
  if H.ContentLength.Value <> hcltNone then
    Result := True else
  if H.ContentType.Value <> hctNone then
    Result := True else
  if H.TransferEncoding.Value <> hteNone then
    Result := True
  else
    Result := False;
end;



{ Structure initialise }

procedure InitHTTPRequest(var A: THTTPRequest);
begin
  FillChar(A, SizeOf(THTTPRequest), 0);
end;

procedure InitHTTPResponse(var A: THTTPResponse);
begin
  FillChar(A, SizeOf(THTTPResponse), 0);
end;



{ Structure clear }

procedure ClearHTTPVersion(var A: THTTPVersion);
begin
  A.Version := hvNone;
  A.Protocol := hpNone;
  A.CustomProtocol := '';
  A.CustomMajVersion := 0;
  A.CustomMinVersion := 0;
end;

procedure ClearHTTPContentLength(var A: THTTPContentLength);
begin
  A.Value := hcltNone;
  A.ByteCount := 0;
end;

procedure ClearHTTPContentType(var A: THTTPContentType);
begin
  A.Value := hctNone;
  A.CustomMajor := '';
  A.CustomMinor := '';
  A.Parameters := nil;
  A.CustomStr := '';
end;

procedure ClearHTTPDateField(var A: THTTPDateField);
begin
  A.Value := hdNone;
  A.DayOfWeek := 0;
  A.Day := 0;
  A.Month := 0;
  A.Year := 0;
  A.Hour := 0;
  A.Min := 0;
  A.Sec := 0;
  A.TimeZoneGMT := False;
  A.CustomTimeZone := '';
  A.DateTime := 0.0;
  A.Custom := '';
end;

procedure ClearHTTPTransferEncoding(var A: THTTPTransferEncoding);
begin
  A.Value := hteNone;
  A.Custom := '';
end;

procedure ClearHTTPConnectionField(var A: THTTPConnectionField);
begin
  A.Value := hcfNone;
  A.Custom := '';
end;

procedure ClearHTTPAgeField(var A: THTTPAgeField);
begin
  A.Value := hafNone;
  A.Age := 0;
  A.Custom := '';
end;

procedure ClearHTTPContentEncoding(var A: THTTPContentEncoding);
begin
  A.Value := hceNone;
  A.Custom := '';
end;

procedure ClearHTTPContentEncodingField(var A: THTTPContentEncodingField);
begin
  A.Value := hcefNone;
  A.List := nil;
end;

procedure ClearHTTPContentRangeField(var A: THTTPContentRangeField);
begin
  A.Value := hcrfNone;
  A.ByteFirst := 0;
  A.ByteLast := 0;
  A.ByteSize := 0;
  A.Custom := '';
end;

procedure ClearHTTPSetCookieField(var A: THTTPSetCookieField);
begin
  A.Value := hscoNone;
  A.Domain := '';
  A.Path := '';
  ClearHTTPDateField(A.Expires);
  A.MaxAge := 0;
  A.HttpOnly := False;
  A.Secure := False;
  A.CustomFields := nil;
  A.Custom := '';
end;

procedure ClearHTTPCommonHeaders(var A: THTTPCommonHeaders);
begin
  ClearHTTPTransferEncoding(A.TransferEncoding);
  ClearHTTPContentType(A.ContentType);
  ClearHTTPContentLength(A.ContentLength);
  ClearHTTPConnectionField(A.Connection);
  ClearHTTPConnectionField(A.ProxyConnection);
  ClearHTTPDateField(A.Date);
  ClearHTTPContentEncodingField(A.ContentEncoding);
end;

procedure ClearHTTPFixedHeaders(var A: THTTPFixedHeaders);
var I : THTTPHeaderNameEnum;
begin
  for I := Low(THTTPHeaderNameEnum) to High(THTTPHeaderNameEnum) do
    A[I] := '';
end;

procedure ClearHTTPCustomHeaders(var A: THTTPCustomHeaders);
begin
  A := nil;
end;

procedure ClearHTTPCookieField(var A: THTTPCookieField);
begin
  A.Value := hcoNone;
  A.Entries := nil;
  A.Custom := '';
end;

procedure ClearHTTPMethod(var A: THTTPMethod);
begin
  A.Value := hmNone;
  A.Custom := '';
end;

procedure ClearHTTPRequestStartLine(var A: THTTPRequestStartLine);
begin
  ClearHTTPMethod(A.Method);
  A.URI := '';
  ClearHTTPVersion(A.Version);
end;

procedure ClearHTTPRequestHeader(var A: THTTPRequestHeader);
begin
  ClearHTTPCommonHeaders(A.CommonHeaders);
  ClearHTTPFixedHeaders(A.FixedHeaders);
  ClearHTTPCustomHeaders(A.CustomHeaders);
  ClearHTTPCookieField(A.Cookie);
  ClearHTTPDateField(A.IfModifiedSince);
  ClearHTTPDateField(A.IfUnmodifiedSince);
end;

procedure ClearHTTPRequest(var A: THTTPRequest);
begin
  ClearHTTPRequestStartLine(A.StartLine);
  ClearHTTPRequestHeader(A.Header);
  A.HeaderComplete := False;
  A.HasContent := False;
end;

procedure ClearHTTPResponseStartLine(var A: THTTPResponseStartLine);
begin
  ClearHTTPVersion(A.Version);
  A.Code := 0;
  A.Msg := hslmNone;
  A.CustomMsg := '';
end;

procedure ClearHTTPResponseHeader(var A: THTTPResponseHeader);
begin
  ClearHTTPCommonHeaders(A.CommonHeaders);
  ClearHTTPFixedHeaders(A.FixedHeaders);
  ClearHTTPCustomHeaders(A.CustomHeaders);
  A.Cookies := nil;
  ClearHTTPDateField(A.Expires);
  ClearHTTPDateField(A.LastModified);
  ClearHTTPAgeField(A.Age);
end;

procedure ClearHTTPResponse(var A: THTTPResponse);
begin
  ClearHTTPResponseStartLine(A.StartLine);
  ClearHTTPResponseHeader(A.Header);
  A.HeaderComplete := False;
  A.HasContent := False;
end;



{ Structure to string }

procedure BuildStrHTTPVersion(const A: THTTPVersion; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  case A.Version of
    hvNone   : ;
    hvCustom :
      if A.Protocol <> hpNone then
        begin
          case A.Protocol of
            hpCustom : B.Append(A.CustomProtocol);
            hpHTTP   : B.Append('HTTP');
            hpHTTPS  : B.Append('HTTPS');
          end;
          B.AppendCh('/');
          B.Append(IntToStr(A.CustomMajVersion));
          B.AppendCh('.');
          B.Append(IntToStr(A.CustomMinVersion));
        end;
    hvHTTP10 : B.Append('HTTP/1.0');
    hvHTTP11 : B.Append('HTTP/1.1');
  end;
end;

procedure BuildStrHTTPHeaderName(const A: THTTPHeaderNameEnum; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  B.Append(HTTP_HeaderNameList[A]);
  B.Append(': ');
end;

procedure BuildStrHTTPContentLengthValue(const A: THTTPContentLength; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  case A.Value of
    hcltNone      : ;
    hcltByteCount : B.Append(IntToStr(A.ByteCount));
  end;
end;

procedure BuildStrHTTPContentLength(const A: THTTPContentLength; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  if A.Value = hcltNone then
    exit;
  BuildStrHTTPHeaderName(hntContentLength, B, P);
  BuildStrHTTPContentLengthValue(A, B, P);
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPContentTypeValue(const A: THTTPContentType; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
var S : AnsiString;
    I, L : Integer;
begin
  case A.Value of
    hctNone : exit;
    hctCustomParts :
      begin
        B.Append(A.CustomMajor);
        B.AppendCh('/');
        B.Append(A.CustomMinor);
      end;
    hctCustomString : B.Append(A.CustomStr);
  else
    begin
      S := HTTP_ContentTypeStr[A.Value];
      if S <> '' then
        begin
          B.Append(S);
          {if StrMatchRight(S, '/') then
            begin
              B.Append(A.CustomMinor);
            end;}
        end;
    end;
  end;
  L := Length(A.Parameters);
  for I := 0 to L - 1 do
    begin
      B.Append('; ');
      B.Append(A.Parameters[I]);
    end;
end;

procedure BuildStrHTTPContentType(const A: THTTPContentType; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  if A.Value = hctNone then
    exit;
  BuildStrHTTPHeaderName(hntContentType, B, P);
  BuildStrHTTPContentTypeValue(A, B, P);
  B.Append(HTTP_CRLF);
end;

procedure BuildStrRFCDateTime(
          const DOW, Da, Mo, Ye, Ho, Mi, Se: Integer;
          const TZ: AnsiString;
          const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  B.Append(RFC1123DayNames[DOW]);
  B.Append(', ');
  B.Append(IntToStr(Da));
  B.AppendCh(' ');
  B.Append(RFCMonthNames[Mo]);
  B.AppendCh(' ');
  B.Append(IntToStr(Ye));
  B.AppendCh(' ');
  B.Append(IntToStr(Ho));
  B.AppendCh(':');
  B.Append(IntToStr(Mi));
  B.AppendCh(':');
  B.Append(IntToStr(Se));
  B.AppendCh(' ');
  B.Append(TZ);
end;

procedure BuildStrHTTPDateFieldValue(const A: THTTPDateField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
var T : TDateTime;
    Z : AnsiString;
    Ye, Mo, Da, DOW : Word;
    Ho, Mi, Se, S1 : Word;
begin
  case A.Value of
    hdNone : ;
    hdCustom : B.Append(A.Custom);
    hdParts :
      begin
        if A.TimeZoneGMT then
          Z := 'GMT'
        else
          Z := A.CustomTimeZone;
        BuildStrRFCDateTime(
            A.DayOfWeek, A.Day, A.Month, A.Year,
            A.Hour, A.Min, A.Sec, Z,
            B, P);
      end;
    hdDateTime :
      begin
        T := LocalTimeToGMTTime(A.DateTime);
        DecodeDateFully(T, Ye, Mo, Da, DOW);
        DecodeTime(T, Ho, Mi, Se, S1);
        BuildStrRFCDateTime(
            DOW, Da, Mo, Ye,
            Ho, Mi, Se, 'GMT',
            B, P);
      end;
  end;
end;

procedure BuildStrHTTPDateField(const A: THTTPDateField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  if A.Value = hdNone then
    exit;
  BuildStrHTTPHeaderName(hntDate, B, P);
  BuildStrHTTPDateFieldValue(A, B, P);
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPTransferEncodingValue(const A: THTTPTransferEncoding; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  case A.Value of
    hteNone    : ;
    hteCustom  : B.Append(A.Custom);
    hteChunked : B.Append('chunked');
  end;
end;

procedure BuildStrHTTPTransferEncoding(const A: THTTPTransferEncoding; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  if A.Value = hteNone then
    exit;
  BuildStrHTTPHeaderName(hntTransferEncoding, B, P);
  BuildStrHTTPTransferEncodingValue(A, B, P);
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPContentRangeField(const A: THTTPContentRangeField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  if A.Value = hcrfNone then
    exit;
  BuildStrHTTPHeaderName(hntContentRange, B, P);
  case A.Value of
    hcrfCustom    : B.Append(A.Custom);
    hcrfByteRange :
      begin
        B.Append(IntToStr(A.ByteFirst));
        B.AppendCh('-');
        B.Append(IntToStr(A.ByteLast));
        B.AppendCh('/');
        B.Append(IntToStr(A.ByteSize));
      end;
  end;
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPConnectionFieldValue(const A: THTTPConnectionField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  case A.Value of
    hcfNone      : ;
    hcfCustom    : B.Append(A.Custom);
    hcfClose     : B.Append('close');
    hcfKeepAlive : B.Append('keep-alive');
  end;
end;

procedure BuildStrHTTPConnectionField(const A: THTTPConnectionField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  if A.Value = hcfNone then
    exit;
  BuildStrHTTPHeaderName(hntConnection, B, P);
  BuildStrHTTPConnectionFieldValue(A, B, P);
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPAgeField(const A: THTTPAgeField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  if A.Value = hafNone then
    exit;
  BuildStrHTTPHeaderName(hntAge, B, P);
  case A.Value of
    hafCustom : B.Append(A.Custom);
    hafAge    : B.Append(IntToStr(A.Age));
  end;
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPContentEncoding(const A: THTTPContentEncoding; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  case A.Value of
    hceNone   : ;
    hceCustom : B.Append(A.Custom);
  else
    B.Append(HTTP_ContentEncodingStr[A.Value]);
  end;
end;

procedure BuildStrHTTPContentEncodingField(const A: THTTPContentEncodingField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
var I : Integer;
begin
  if A.Value = hcefNone then
    exit;
  BuildStrHTTPHeaderName(hntContentEncoding, B, P);
  case A.Value of
    hcefList :
      for I := 0 to Length(A.List) - 1 do
        begin
          if I > 0 then
            B.Append(', ');
          BuildStrHTTPContentEncoding(A.List[I], B, P);
        end;
  end;
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPProxyConnectionField(const A: THTTPConnectionField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  if A.Value = hcfNone then
    exit;
  BuildStrHTTPHeaderName(hntProxyConnection, B, P);
  BuildStrHTTPConnectionFieldValue(A, B, P);
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPCommonHeaders(const A: THTTPCommonHeaders; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  BuildStrHTTPTransferEncoding(A.TransferEncoding, B, P);
  BuildStrHTTPContentType(A.ContentType, B, P);
  BuildStrHTTPContentLength(A.ContentLength, B, P);
  BuildStrHTTPConnectionField(A.Connection, B, P);
  BuildStrHTTPProxyConnectionField(A.ProxyConnection, B, P);
  BuildStrHTTPDateField(A.Date, B, P);
  BuildStrHTTPContentEncodingField(A.ContentEncoding, B, P);
end;

procedure BuildStrHTTPFixedHeaders(const A: THTTPFixedHeaders; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
var I : THTTPHeaderNameEnum;
    S : AnsiString;
begin
  for I := Low(THTTPHeaderNameEnum) to High(THTTPHeaderNameEnum) do
    begin
      S := A[I];
      if S <> '' then
        begin
          B.Append(HTTP_HeaderNameList[I]);
          B.Append(': ');
          B.Append(S);
          B.Append(HTTP_CRLF);
        end;
    end;
end;

procedure BuildStrHTTPCustomHeaders(const A: THTTPCustomHeaders; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
var I : Integer;
    H : PHTTPCustomHeader;
begin
  for I := 0 to Length(A) - 1 do
    begin
      H := @A[I];
      B.Append(H^.FieldName);
      B.Append(': ');
      B.Append(H^.FieldValue);
      B.Append(HTTP_CRLF);
    end;
end;

procedure BuildStrHTTPSetCookieFieldValue(const A: THTTPSetCookieField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
var L : Integer;

  procedure BuildParam(const F: AnsiString);
  begin
    if L > 0 then
      B.Append('; ');
    Inc(L);
    B.Append(F);
  end;

  procedure BuildNameValue(const N, V: AnsiString);
  begin
    BuildParam(N);
    B.AppendCh('=');
    B.Append(V);
  end;

var I : Integer;
    S : AnsiString;
begin
  case A.Value of
    hscoNone    : ;
    hscoDecoded :
      begin
        L := 0;
        BuildNameValue('Domain', A.Domain);
        BuildNameValue('Path', A.Path);
        if A.Expires.Value <> hdNone then
          begin
            BuildParam('Expires=');
            BuildStrHTTPDateFieldValue(A.Expires, B, P);
          end;
        if A.MaxAge > 0 then
          begin
            BuildParam('Max-Age=');
            B.Append(IntToStr(A.MaxAge));
          end;
        for I := 0 to Length(A.CustomFields) - 1 do
          begin
            BuildParam(A.CustomFields[I].Name);
            S := A.CustomFields[I].Value;
            if S <> '' then
              begin
                B.AppendCh('=');
                B.Append(S);
              end;
          end;
        if A.HttpOnly then
          BuildParam('HttpOnly');
        if A.Secure then
          BuildParam('Secure');
      end;
    hscoCustom  : B.Append(A.Custom);
  end;
end;

procedure BuildStrHTTPCookieFieldValue(const A: THTTPCookieField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
var I : Integer;
begin
  case A.Value of
    hcoNone : ;
    hcoDecoded :
      begin
        for I := 0 to Length(A.Entries) - 1 do
          begin
            if I > 0 then
              B.AppendCh(';');
            B.Append(A.Entries[I].Name);
            B.AppendCh('=');
            B.Append(A.Entries[I].Value);
          end;
      end;
    hcoCustom :
      begin
        B.Append(A.Custom);
      end;
  end;
end;

procedure BuildStrHTTPCookieField(const A: THTTPCookieField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  if A.Value = hcoNone then
    exit;
  BuildStrHTTPHeaderName(hntCookie, B, P);
  BuildStrHTTPCookieFieldValue(A, B, P);
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPIfModifiedSince(const A: THTTPDateField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  if A.Value = hdNone then
    exit;
  BuildStrHTTPHeaderName(hntIfModifiedSince, B, P);
  BuildStrHTTPDateFieldValue(A, B, P);
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPIfUnmodifiedSince(const A: THTTPDateField; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  if A.Value = hdNone then
    exit;
  BuildStrHTTPHeaderName(hntIfUnmodifiedSince, B, P);
  BuildStrHTTPDateFieldValue(A, B, P);
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPMethod(const A: THTTPMethod; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  case A.Value of
    hmNone   : ;
    hmCustom : B.Append(A.Custom);
  else
    B.Append(HTTP_MethodStr[A.Value]);
  end;
end;

procedure BuildStrHTTPRequestStartLine(const A: THTTPRequestStartLine; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  BuildStrHTTPMethod(A.Method, B, P);
  B.AppendCh(' ');
  B.Append(A.URI);
  B.AppendCh(' ');
  BuildStrHTTPVersion(A.Version, B, P);
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPRequestHeader(const A: THTTPRequestHeader; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  BuildStrHTTPCommonHeaders(A.CommonHeaders, B, P);
  BuildStrHTTPFixedHeaders(A.FixedHeaders, B, P);
  BuildStrHTTPCustomHeaders(A.CustomHeaders, B, P);
  BuildStrHTTPCookieField(A.Cookie, B, P);
  BuildStrHTTPIfModifiedSince(A.IfModifiedSince, B, P);
  BuildStrHTTPIfUnmodifiedSince(A.IfUnmodifiedSince, B, P);
end;

procedure BuildStrHTTPRequest(const A: THTTPRequest; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  BuildStrHTTPRequestStartLine(A.StartLine, B, P);
  BuildStrHTTPRequestHeader(A.Header, B, P);
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPResponseCookieFieldArray(const A: THTTPSetCookieFieldArray; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
var I : Integer;
begin
  for I := 0 to Length(A) - 1 do
    begin
      BuildStrHTTPHeaderName(hntSetCookie, B, P);
      BuildStrHTTPSetCookieFieldValue(A[I], B, P);
      B.Append(HTTP_CRLF);
    end;
end;

procedure BuildStrHTTPResponseStartLine(const A: THTTPResponseStartLine; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  BuildStrHTTPVersion(A.Version, B, P);
  B.AppendCh(' ');
  B.Append(IntToStr(A.Code));
  B.AppendCh(' ');
  case A.Msg of
    hslmNone   : ;
    hslmCustom : B.Append(A.CustomMsg);
    hslmOK     : B.Append('OK');
  end;
  B.Append(HTTP_CRLF);
end;

procedure BuildStrHTTPResponseHeader(const A: THTTPResponseHeader; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  BuildStrHTTPCommonHeaders(A.CommonHeaders, B, P);
  BuildStrHTTPFixedHeaders(A.FixedHeaders, B, P);
  BuildStrHTTPCustomHeaders(A.CustomHeaders, B, P);
  BuildStrHTTPResponseCookieFieldArray(A.Cookies, B, P);
  // A.Expires
  // A.LastModified
  BuildStrHTTPAgeField(A.Age, B, P);
end;

procedure BuildStrHTTPResponse(const A: THTTPResponse; const B: TAnsiStringBuilder; const P: THTTPStringOptions);
begin
  BuildStrHTTPResponseStartLine(A.StartLine, B, P);
  BuildStrHTTPResponseHeader(A.Header, B, P);
  B.Append(HTTP_CRLF);
end;

function HTTPContentTypeValueToStr(const A: THTTPContentType): AnsiString;
var B : TAnsiStringBuilder;
begin
  B := TAnsiStringBuilder.Create;
  try
    BuildStrHTTPContentTypeValue(A, B, []);
    Result := B.AsAnsiString;
  finally
    B.Free;
  end;
end;

function HTTPSetCookieFieldValueToStr(const A: THTTPSetCookieField): AnsiString;
var B : TAnsiStringBuilder;
begin
  B := TAnsiStringBuilder.Create;
  try
    BuildStrHTTPSetCookieFieldValue(A, B, []);
    Result := B.AsAnsiString;
  finally
    B.Free;
  end;
end;

function HTTPCookieFieldValueToStr(const A: THTTPCookieField): AnsiString;
var B : TAnsiStringBuilder;
begin
  B := TAnsiStringBuilder.Create;
  try
    BuildStrHTTPCookieFieldValue(A, B, []);
    Result := B.AsAnsiString;
  finally
    B.Free;
  end;
end;

function HTTPMethodToStr(const A: THTTPMethod): AnsiString;
var B : TAnsiStringBuilder;
begin
  B := TAnsiStringBuilder.Create;
  try
    BuildStrHTTPMethod(A, B, []);
    Result := B.AsAnsiString;
  finally
    B.Free;
  end;
end;

function HTTPRequestToStr(const A: THTTPRequest): AnsiString;
var B : TAnsiStringBuilder;
begin
  B := TAnsiStringBuilder.Create;
  try
    BuildStrHTTPRequest(A, B, []);
    Result := B.AsAnsiString;
  finally
    B.Free;
  end;
end;

function HTTPResponseToStr(const A: THTTPResponse): AnsiString;
var B : TAnsiStringBuilder;
begin
  B := TAnsiStringBuilder.Create;
  try
    BuildStrHTTPResponse(A, B, []);
    Result := B.AsAnsiString;
  finally
    B.Free;
  end;
end;



{ Cookies }

function GetHTTPCookieFieldEntryIndexByName(const A: THTTPCookieFieldEntryArray; const Name: AnsiString): Integer;
var I : Integer;
begin
  for I := 0 to Length(A) - 1 do
    {if StrEqualNoAsciiCaseA(A[I].Name, Name) then
      begin
        Result := I;
        exit;
      end;}
  Result := -1;
end;

procedure PrepareCookie(var A: THTTPCookieField;
          const B: THTTPSetCookieFieldArray;
          const Domain: AnsiString;
          const Secure: Boolean);
var I, J, T, L : Integer;
    F : PHTTPSetCookieField;
    G : PHTTPSetCookieCustomField;
    H : PHTTPCookieFieldEntry;
begin
  ClearHTTPCookieField(A);
  A.Value := hcoDecoded;
  for I := 0 to Length(B) - 1 do
    begin
      F := @B[I];
      if F^.Secure = Secure then
        //if StrEqualNoAsciiCaseA(F^.Domain, Domain) then
          for J := 0 to Length(F^.CustomFields) - 1 do
            begin
              G := @F^.CustomFields[J];
              T := GetHTTPCookieFieldEntryIndexByName(A.Entries, G^.Name);
              if T < 0 then
                begin
                  L := Length(A.Entries);
                  SetLength(A.Entries, L + 1);
                  H := @A.Entries[L];
                  H^.Name := G^.Name;
                  H^.Value := G^.Value;
                end
              else
                begin
                  H := @A.Entries[T];
                  H^.Value := G^.Value;
                end;
            end;
    end;
end;



{ Errors }




{ HTTP parser helpers }

const
  HTTP_SpaceSet : AnsiCharSet = [' '];
  HTTP_DelimSet : AnsiCharSet = [' ', #13];
  HTTP_FieldValueDelimSet : AnsiCharSet = [#13];
  HTTP_CRSet : AnsiCharSet = [#13];



{ THTTPParser }

const
  SHTTPErr_InvalidParameter = 'Invalid parameter';

constructor THTTPParser.Create;
begin
  inherited Create;
end;

destructor THTTPParser.Destroy;
begin
  inherited Destroy;
end;

procedure THTTPParser.SetTextBuf(const Buf; const BufSize: Integer);
begin
  if BufSize < 0 then
    raise EHTTPParser.Create(SHTTPErr_InvalidParameter);
  FBufPtr := @Buf;
  FBufSize := BufSize;
  FBufPos := 0;
  FBufStrRef := '';
end;

procedure THTTPParser.SetTextStr(const S: AnsiString);
begin
  FBufStrRef := S;
  FBufSize := Length(S);
  FBufPtr := PAnsiChar(FBufStrRef);
  FBufPos := 0;
end;

function THTTPParser.EOF: Boolean;
begin
  Result := FBufPos >= FBufSize;
end;

function THTTPParser.MatchStrAndCh(const S: AnsiString; const CaseSensitive: Boolean; const C: AnsiCharSet): Boolean;
var L, T, N, F : Integer;
    P : PAnsiChar;
    D : Boolean;
begin
  D := C <> [];
  L := Length(S);
  T := L;
  if D then
    Inc(T);
  if T = 0 then
    begin
      Result := False;
      exit;
    end;
  F := FBufPos;
  N := FBufSize - F;
  if N < T then
    begin
      Result := False;
      exit;
    end;
  P := FBufPtr;
  Inc(P, F);
  if L > 0 then
    begin
      if CaseSensitive then
        Result := SysUtils.CompareMem(PAnsiChar(S), P, L)
      else
        Result := AnsiStrLIComp(PAnsiChar(S), P, L) = 0;
      if not Result then
        exit;
    end
  else
    Result := True;
  if D then
    begin
      Inc(P, L);
      if not (P^ in C) then
        Result := False;
    end;
end;

function THTTPParser.MatchStr(const S: AnsiString; const CaseSensitive: Boolean): Boolean;
begin
  Result := MatchStrAndCh(S, CaseSensitive, []);
end;

function THTTPParser.SkipStrAndCh(const S: AnsiString; const DelimSet: AnsiCharSet; const SkipDelim: Boolean; const CaseSensitive: Boolean): Boolean;
var L : Integer;
begin
  Result := MatchStrAndCh(S, CaseSensitive, DelimSet);
  if not Result then
    exit;
  L := Length(S);
  if SkipDelim then
    if DelimSet <> [] then
      Inc(L);
  Inc(FBufPos, L);
end;

function THTTPParser.SkipCh(const C: AnsiCharSet): Boolean;
var N, F : Integer;
    P : PAnsiChar;
begin
  F := FBufPos;
  N := FBufSize - F;
  if N <= 0 then
    begin
      Result := False;
      exit;
    end;
  P := FBufPtr;
  Inc(P, F);
  if P^ in C then
    begin
      Inc(FBufPos);
      Result := True;
    end
  else
    Result := False;
end;

function THTTPParser.SkipAllCh(const C: AnsiCharSet): Boolean;
var N, L, F : Integer;
    P : PAnsiChar;
begin
  L := 0;
  F := FBufPos;
  N := FBufSize - F;
  P := FBufPtr;
  Inc(P, F);
  while N > 0 do
    if P^ in C then
      begin
        Inc(P);
        Dec(N);
        Inc(L);
      end
    else
      break;
  if L > 0 then
    begin
      Inc(FBufPos, L);
      Result := True;
    end
  else
    Result := False;
end;

function THTTPParser.SkipToStr(const S: AnsiString; const CaseSensitive: Boolean): Boolean;
var N, L, F, C : Integer;
    P : PAnsiChar;
    R, T : Boolean;
begin
  L := Length(S);
  F := FBufPos;
  N := FBufSize - F;
  P := FBufPtr;
  Inc(P, F);
  R := False;
  C := 0;
  while N >= L do
    begin
      if CaseSensitive then
        T := SysUtils.CompareMem(PAnsiChar(S), P, L)
      else
        T := AnsiStrLIComp(PAnsiChar(S), P, L) = 0;
      if T then
        break;
      Dec(N);
      Inc(P);
      Inc(C);
      R := True;
    end;
  Inc(FBufPos, C);
  Result := R;
end;

function THTTPParser.SkipCRLF: Boolean;
begin
  Result := SkipStrAndCh(HTTP_CRLF, [], False, True);
end;

function THTTPParser.SkipSpace: Boolean;
begin
  Result := SkipAllCh(HTTP_SpaceSet);
end;

function THTTPParser.SkipLWS: Boolean;
var R, T : Boolean;
begin
  R := False;
  repeat
    T := SkipSpace;
    if SkipStrAndCh(HTTP_CRLF, [#9, #32], True, True) then
      T := True;
    if T then
      R := True;
  until not T or EOF;
  Result := R;
end;

function THTTPParser.SkipToCRLF: Boolean;
begin
  Result := SkipToStr(HTTP_CRLF, False);
end;

function THTTPParser.ExtractAllCh(const C: AnsiCharSet): AnsiString;
var N, L : Integer;
    P, Q : PAnsiChar;
    D : AnsiChar;
    R : Boolean;
    S : AnsiString;
begin
  P := FBufPtr;
  Inc(P, FBufPos);
  Q := P;
  N := FBufSize - FBufPos;
  L := 0;
  while N > 0 do
    begin
      D := P^;
      R := D in C;
      if not R then
        break
      else
        Inc(L);
      Inc(P);
      Dec(N);
    end;
  SetLength(S, L);
  if L > 0 then
    Move(Q^, S[1], L);
  Inc(FBufPos, L);
  Result := S;
end;

function THTTPParser.ExtractTo(const C: AnsiCharSet; var S: AnsiString; const SkipDelim: Boolean): AnsiChar;
var N, L : Integer;
    P, Q : PAnsiChar;
    D : AnsiChar;
    R : Boolean;
begin
  P := FBufPtr;
  Inc(P, FBufPos);
  Q := P;
  N := FBufSize - FBufPos;
  L := 0;
  R := False;
  D := #0;
  while N > 0 do
    begin
      D := P^;
      R := D in C;
      if R then
        break
      else
        Inc(L);
      Inc(P);
      Dec(N);
    end;
  SetLength(S, L);
  if L > 0 then
    Move(Q^, S[1], L);
  Inc(FBufPos, L);
  if R and SkipDelim then
    Inc(FBufPos);
  Result := D;
end;

function THTTPParser.ExtractStrTo(const C: AnsiCharSet; const SkipDelim: Boolean): AnsiString;
begin
  ExtractTo(C, Result, SkipDelim);
end;

function THTTPParser.ExtractInt(const Default: Int64): Int64;
var S : AnsiString;
begin
  S := ExtractAllCh(['0'..'9']);
  if not TryStrToInt64(S,Result) then
    Result := Default;
end;

function THTTPParser.ExtractIntTo(const C: AnsiCharSet; const SkipDelim: Boolean; const Default: Int64): Int64;
var S : AnsiString;
begin
  ExtractTo(C, S, SkipDelim);
  if not TryStrToInt64(S, Result) then
    Result := Default;
end;

procedure THTTPParser.ParseCustomVersion(var Protocol: THTTPVersion);
begin
  if SkipStrAndCh('HTTP/', [], False, False) then
    Protocol.Protocol := hpHTTP else
  if SkipStrAndCh('HTTPS/', [], False, False) then
    Protocol.Protocol := hpHTTPS
  else
    begin
      Protocol.Protocol := hpCustom;
      Protocol.CustomProtocol := ExtractStrTo(['/', #13], False);
      SkipCh(['/']);
    end;
  Protocol.CustomMajVersion := ExtractIntTo(['.', #13], False, -1);
  if SkipCh(['.']) then
    Protocol.CustomMinVersion := ExtractInt(-1)
  else
    Protocol.CustomMinVersion := -1;
end;

procedure THTTPParser.ParseVersion(var Version: THTTPVersion);
begin
  ClearHTTPVersion(Version);
  if SkipStrAndCh('HTTP/1.1', HTTP_DelimSet, False, False) then
    Version.Version := hvHTTP11 else
  if SkipStrAndCh('HTTP/1.0', HTTP_DelimSet, False, False) then
    Version.Version := hvHTTP10
  else
    begin
      Version.Version := hvCustom;
      ParseCustomVersion(Version);
    end;
end;

procedure THTTPParser.ParseHeaderName(var HeaderName: THTTPHeaderName);
const
  HTTP_HeaderNameDelimSet : AnsiCharSet = [' ', #9, ':', #13];
var
  I : THTTPHeaderNameEnum;
  S : AnsiString;
begin
  for I := Low(THTTPHeaderNameEnum) to High(THTTPHeaderNameEnum) do
    begin
      S := HTTP_HeaderNameList[I];
      if S <> '' then
        if SkipStrAndCh(S, HTTP_HeaderNameDelimSet, False, False) then
          begin
            HeaderName.Value := I;
            HeaderName.Custom := '';
            exit;
          end;
    end;
  HeaderName.Value := hntCustom;
  HeaderName.Custom := ExtractStrTo(HTTP_HeaderNameDelimSet, False);
end;

procedure THTTPParser.ParseHeaderValue(var HeaderValue: AnsiString);
var S : AnsiString;
    R : Boolean;
begin
  S := '';
  R := False;
  repeat
    S := S + ExtractStrTo(HTTP_CRSet, False);
    SkipLWS;
    if MatchStr(HTTP_CRLF, True) then
      R := True
    else
      if SkipCh(HTTP_CRSet) then
        S := S + #13;
  until R or EOF;
  HeaderValue := S;
end;

procedure THTTPParser.ParseTransferEncoding(var Value: THTTPTransferEncoding);
begin
  Value.Custom := '';
  if SkipStrAndCh('chunked', HTTP_FieldValueDelimSet, False, False) then
    Value.Value := hteChunked
  else
    begin
      Value.Value := hteCustom;
      ParseHeaderValue(Value.Custom);
    end;
end;

{ Content-Type   = "Content-Type" ":" media-type }
{ media-type     = type "/" subtype *( ";" parameter ) }
procedure THTTPParser.ParseContentType(var Value: THTTPContentType);
const
  HTTP_ContentTypeDelimSet = [' ', #9, #13, ';'];
var
  I : THTTPContentTypeEnum;
  S : AnsiString;
  L : Integer;
begin
  ClearHTTPContentType(Value);
  for I := Low(THTTPContentTypeEnum) to High(THTTPContentTypeEnum) do
    begin
      S := HTTP_ContentTypeStr[I];
      //if (S <> '') and not StrMatchRight(S, '/') then
        if SkipStrAndCh(S, HTTP_ContentTypeDelimSet, False, False) then
          begin
            Value.Value := I;
            break;
          end;
    end;
  if Value.Value = hctNone then
    begin
      if SkipStrAndCh('text/', [], False, False) then
        Value.Value := hctTextCustom else
      if SkipStrAndCh('image/', [], False, False) then
        Value.Value := hctImageCustom else
      if SkipStrAndCh('application/', [], False, False) then
        Value.Value := hctApplicationCustom else
      if SkipStrAndCh('audio/', [], False, False) then
        Value.Value := hctAudioCustom else
      if SkipStrAndCh('video/', [], False, False) then
        Value.Value := hctVideoCustom
      else
        begin
          Value.Value := hctCustomParts;
          Value.CustomMajor := ExtractStrTo(['/'], True);
          Value.CustomMinor := ExtractStrTo(HTTP_ContentTypeDelimSet, False);
        end;
    end;
  if Value.Value in [
      hctTextCustom,
      hctImageCustom,
      hctApplicationCustom,
      hctAudioCustom] then
    Value.CustomMinor := ExtractStrTo(HTTP_ContentTypeDelimSet, False);
  SkipLWS;
  L := 0;
  while SkipCh([';']) do
    begin
      SkipLWS;
      SetLength(Value.Parameters, L + 1);
      Value.Parameters[L] := ExtractStrTo(HTTP_DelimSet, False);
      Inc(L);
      SkipLWS;
    end;
end;

{ "Content-Length" ":" 1*DIGIT }
procedure THTTPParser.ParseContentLength(var Value: THTTPContentLength);
begin
  Value.Value := hcltByteCount;
  Value.ByteCount := ExtractInt(-1);
end;

{ "Connection" ":" 1#(connection-token) }
procedure THTTPParser.ParseConnectionField(var Value: THTTPConnectionField);
begin
  Value.Custom := '';
  if SkipStrAndCh('close', HTTP_FieldValueDelimSet, False, False) then
    Value.Value := hcfClose else
  if SkipStrAndCh('keep-alive', HTTP_FieldValueDelimSet, False, False) then
    Value.Value := hcfKeepAlive
  else
    begin
      Value.Value := hcfCustom;
      ParseHeaderValue(Value.Custom);
    end;
end;

{
  Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
  Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
  Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format                    // not supported
}
procedure THTTPParser.ParseDateField(var Value: THTTPDateField);
const
  HTTP_DayNameDelim = [',', ' '];
var I : Integer;
    D, T : TDateTime;
begin
  ClearHTTPDateField(Value);
  for I := 1 to 7 do
    if SkipStrAndCh(RFC850DayNames[I], HTTP_DayNameDelim, True, False) then
      begin
        Value.DayOfWeek := I;
        break;
      end;
  if Value.DayOfWeek = 0 then
    for I := 1 to 7 do
      if SkipStrAndCh(RFC1123DayNames[I], HTTP_DayNameDelim, True, False) then
        begin
          Value.DayOfWeek := I;
          break;
        end;
  if Value.DayOfWeek > 0 then
    begin
      Value.Value := hdParts;
      SkipSpace;
      Value.Day := ExtractInt(0);
      SkipSpace;
      SkipCh(['-']);
      SkipSpace;
      for I := 1 to 12 do
        if SkipStrAndCh(RFCMonthNames[I], [' ', '-'], False, False) then
          begin
            SkipSpace;
            SkipCh(['-']);
            Value.Month := I;
            break;
          end;
      SkipSpace;
      Value.Year := ExtractInt(0);
      SkipSpace;
      Value.Hour := ExtractInt(0);
      SkipSpace;
      SkipCh([':']);
      SkipSpace;
      Value.Min := ExtractInt(0);
      SkipSpace;
      SkipCh([':']);
      SkipSpace;
      Value.Sec := ExtractInt(0);
      SkipSpace;
      if SkipStrAndCh('GMT', [';', ' ', #13], False, False) then
        Value.TimeZoneGMT := True
      else
        Value.CustomTimeZone := ExtractStrTo(HTTP_FieldValueDelimSet, False);
      if not TryEncodeDate(Value.Year, Value.Month, Value.Day, D) then
        D := 0.0;
      if not TryEncodeTime(Value.Hour, Value.Min, Value.Sec, 0, T) then
        T := 0.0;
      Value.DateTime := D + T;
    end
  else
    begin
      Value.Value := hdCustom;
      ParseHeaderValue(Value.Custom);
    end;
end;

procedure THTTPParser.ParseAgeField(var Value: THTTPAgeField);
begin
  ClearHTTPAgeField(Value);
  if MatchStrAndCh('', True, ['0'..'9']) then
    begin
      Value.Value := hafAge;
      Value.Age := ExtractInt(-1);
    end
  else
    begin
      Value.Value := hafCustom;
      Value.Custom := ExtractStrTo(HTTP_DelimSet, False);
    end;
end;

{ Content-Encoding  = "Content-Encoding" ":" 1#content-coding }
procedure THTTPParser.ParseContentEncoding(var Value: THTTPContentEncoding);
var I, E : THTTPContentEncodingEnum;
    S : AnsiString;
begin
  ClearHTTPContentEncoding(Value);
  E := hceNone;
  for I := Low(THTTPContentEncodingEnum) to High(THTTPContentEncodingEnum) do
    begin
      S := HTTP_ContentEncodingStr[I];
      if S <> '' then
        if SkipStrAndCh(S, [#13, ' ', ','], False, False) then
          begin
            E := I;
            break;
          end;
    end;
  if E = hceNone then
    begin
      S := ExtractStrTo([#13, ' ', ','], False);
      if S <> '' then
        begin
          E := hceCustom;
          Value.Custom := S;
        end;
    end;
  Value.Value := E;
end;

procedure THTTPParser.ParseContentEncodingField(var Value: THTTPContentEncodingField);
var E : THTTPContentEncoding;
    L : Integer;
    R : Boolean;
begin
  ClearHTTPContentEncodingField(Value);
  L := 0;
  repeat
    SkipLWS;
    ParseContentEncoding(E);
    if E.Value = hceNone then
      R := False
    else
      begin
        SetLength(Value.List, L + 1);
        Value.List[L] := E;
        Inc(L);
        SkipLWS;
        R := SkipCh([',']);
      end;
  until not R;
  Value.Value := hcefList;
end;

function THTTPParser.ParseCommonHeaderValue(const HeaderName: THTTPHeaderNameEnum; var Headers: THTTPCommonHeaders): Boolean;
var R : Boolean;
begin
  R := True;
  case HeaderName of
    hntTransferEncoding : ParseTransferEncoding(Headers.TransferEncoding);
    hntContentType      : ParseContentType(Headers.ContentType);
    hntContentLength    : ParseContentLength(Headers.ContentLength);
    hntConnection       : ParseConnectionField(Headers.Connection);
    hntProxyConnection  : ParseConnectionField(Headers.ProxyConnection);
    hntDate             : ParseDateField(Headers.Date);
    hntContentEncoding  : ParseContentEncodingField(Headers.ContentEncoding);
  else
    R := False;
  end;
  Result := R;
end;

{
Set-Cookie: LSID=DQAAAK�Eaem_vYg; Domain=docs.foo.com; Path=/accounts; Expires=Wed, 13-Jan-2021 22:23:01 GMT; Secure; HttpOnly
Set-Cookie: PHPSESSID=4234b9b46c7d355416fc5366b529bdd1; path=/; domain=.mtgox.com; secure; HttpOnly
}
type
  THTTPSetCookieSubField = (scsfNone, scsfCustom, scsfDomain, scsfPath, scsfExpires, scsfMaxAge);

procedure THTTPParser.ParseSetCookieField(var Cookie: THTTPSetCookieField);
var R : Boolean;
    F : THTTPSetCookieSubField;
    FieldName : AnsiString;
    FieldValue : AnsiString;
    L : Integer;
begin
  ClearHTTPSetCookieField(Cookie);
  Cookie.Value := hscoDecoded;
  repeat
    SkipLWS;
    R := True;
    if SkipStrAndCh('HttpOnly', [';', #13, ' '], False, False) then
      Cookie.HttpOnly := True else
    if SkipStrAndCh('Secure', [';', #13, ' '], False, False) then
      Cookie.Secure := True
    else
      R := False;
    if not R then
      begin
        if SkipStrAndCh('Domain', ['=', ';', #13, ' '], False, False) then
          F := scsfDomain else
        if SkipStrAndCh('Path', ['=', ';', #13, ' '], False, False) then
          F := scsfPath else
        if SkipStrAndCh('Expires', ['=', ';', #13, ' '], False, False) then
          F := scsfExpires else
        if SkipStrAndCh('Max-Age', ['=', ';', #13, ' '], False, False) then
          F := scsfMaxAge
        else
          F := scsfNone;
        if F = scsfNone then
          begin
            FieldName := ExtractStrTo(['=', #13, ';', ' '], False);
            F := scsfCustom;
          end;
        SkipLWS;
        if SkipCh(['=']) then
          begin
            SkipLWS;
            case F of
              scsfExpires : ParseDateField(Cookie.Expires);
            else
              FieldValue := ExtractStrTo([#13, ';', ' '], False);
            end;
          end
        else
          FieldValue := '';
        case F of
          scsfDomain : Cookie.Domain := FieldValue;
          scsfPath   : Cookie.Path := FieldValue;
          //scsfMaxAge : Cookie.MaxAge := TryStrToInt64(FieldValue, -1);
          scsfCustom :
            begin
              L := Length(Cookie.CustomFields);
              SetLength(Cookie.CustomFields, L + 1);
              Cookie.CustomFields[L].Name := FieldName;
              Cookie.CustomFields[L].Value := FieldValue;
            end;
        end;
      end;
    SkipLWS;
    SkipCh([';']);
  until EOF or MatchStrAndCh('', False, [#13]);
end;

function THTTPParser.ParseHeader(
         const ParseEvent: THTTPParserHeaderParseFunc;
         const HeaderPtr: Pointer;
         var CommonHeaders: THTTPCommonHeaders;
         var HeaderName: THTTPHeaderName;
         var HeaderValue: AnsiString): Boolean;
begin
  HeaderValue := '';
  ParseHeaderName(HeaderName);
  SkipLWS;
  if SkipCh([':']) then
    begin
      SkipLWS;
      if not ParseCommonHeaderValue(HeaderName.Value, CommonHeaders) then
        if not ParseEvent(HeaderName.Value, HeaderPtr) then
          ParseHeaderValue(HeaderValue);
      SkipLWS;
    end;
  SkipToCRLF;
  Result := SkipCRLF;
end;

function THTTPParser.ParseContent(const Headers: THTTPCommonHeaders): Boolean;
begin
  Result := HTTPMessageHasContent(Headers);
  if not Result then
    exit;
  if EOF then
    exit;
end;

function THTTPParser.ParseRequestHeaderValue(const HeaderName: THTTPHeaderNameEnum; const HeaderPtr: Pointer): Boolean;
var Hdr : PHTTPRequestHeader;
    R : Boolean;
begin
  Hdr := HeaderPtr;
  R := True;
  case HeaderName of
    hntIfModifiedSince   : ParseDateField(Hdr^.IfModifiedSince);
    hntIfUnmodifiedSince : ParseDateField(Hdr^.IfUnmodifiedSince);
  else
    R := False;
  end;
  Result := R;
end;

function THTTPParser.ParseRequestHeader(var Header: THTTPRequestHeader): Boolean;
var R : Boolean;
    N : THTTPHeaderName;
    V : AnsiString;
begin
  repeat
    ParseHeader(ParseRequestHeaderValue, @Header, Header.CommonHeaders, N, V);
    case N.Value of
      hntCustom : AddCustomHeader(Header.CustomHeaders, N.Custom, V);
      hntCookie :
        begin
          Header.Cookie.Value := hcoCustom;
          Header.Cookie.Custom := V;
        end;
    else
      Header.FixedHeaders[N.Value] := V;
    end;
    R := SkipCRLF;
  until R or EOF;
  Result := R;
end;

function THTTPParser.ParseRequestContent(var Request: THTTPRequest): Boolean;
begin
  Result := Request.HeaderComplete;
  if not Result then
    exit;
  Result := ParseContent(Request.Header.CommonHeaders);
end;

procedure THTTPParser.ParseRequestMethod(var Method: THTTPMethod);
var I : THTTPMethodEnum;
    S : AnsiString;
begin
  ClearHTTPMethod(Method);
  for I := Low(THTTPMethodEnum) to High(THTTPMethodEnum) do
    begin
      S := HTTP_MethodStr[I];
      if S <> '' then
        if SkipStrAndCh(S, HTTP_SpaceSet, False, False) then
          begin
            Method.Value := I;
            exit;
          end;
    end;
  Method.Value := hmCustom;
  Method.Custom := ExtractStrTo(HTTP_SpaceSet, False);
end;

procedure THTTPParser.ParseRequestURI(var URI: AnsiString);
begin
  URI := ExtractStrTo([' ', #13], False);
end;

function THTTPParser.ParseRequestStartLine(var StartLine: THTTPRequestStartLine): Boolean;
begin
  ParseRequestMethod(StartLine.Method);
  SkipSpace;
  ParseRequestURI(StartLine.URI);
  SkipSpace;
  ParseVersion(StartLine.Version);
  Result := SkipCRLF;
end;

procedure THTTPParser.ParseRequest(var Request: THTTPRequest);
begin
  ParseRequestStartLine(Request.StartLine);
  Request.HeaderComplete := ParseRequestHeader(Request.Header);
  Request.HasContent := ParseRequestContent(Request);
end;

procedure THTTPParser.ParseResponseCode(var Code: Integer);
begin
  Code := ExtractIntTo(HTTP_SpaceSet, False, -1);
end;

function THTTPParser.ParseResponseStartLine(var StartLine: THTTPResponseStartLine): Boolean;
begin
  ParseVersion(StartLine.Version);
  SkipSpace;
  ParseResponseCode(StartLine.Code);
  SkipSpace;
  if SkipStrAndCh('OK', HTTP_CRSet, False, True) then
    begin
      StartLine.Msg := hslmOK;
      StartLine.CustomMsg := '';
    end
  else
    begin
      StartLine.Msg := hslmCustom;
      StartLine.CustomMsg := ExtractStrTo(HTTP_CRSet, False);
    end;
  Result := SkipCRLF;
end;

function THTTPParser.ParseResponseHeaderValue(const HeaderName: THTTPHeaderNameEnum; const HeaderPtr: Pointer): Boolean;
var Hdr : PHTTPResponseHeader;
    R : Boolean;
    L : Integer;
begin
  Hdr := HeaderPtr;
  R := True;
  case HeaderName of
    hntExpires      : ParseDateField(Hdr^.Expires);
    hntLastModified : ParseDateField(Hdr^.LastModified);
    hntAge          : ParseAgeField(Hdr^.Age);
    hntSetCookie    :
      begin
        L := Length(Hdr^.Cookies);
        SetLength(Hdr^.Cookies, L + 1);
        ParseSetCookieField(Hdr^.Cookies[L]);
      end;
  else
    R := False;
  end;
  Result := R;
end;

function THTTPParser.ParseResponseHeader(var Header: THTTPResponseHeader): Boolean;
var R : Boolean;
    N : THTTPHeaderName;
    V : AnsiString;
begin
  repeat
    ParseHeader(ParseResponseHeaderValue, @Header, Header.CommonHeaders, N, V);
    case N.Value of
      hntCustom : AddCustomHeader(Header.CustomHeaders, N.Custom, V);
    else
      Header.FixedHeaders[N.Value] := V;
    end;
    R := SkipCRLF;
  until R or EOF;
  Result := R;
end;

function THTTPParser.ParseResponseContent(var Response: THTTPResponse): Boolean;
begin
  Result := Response.HeaderComplete;
  if not Result then
    exit;
  Result := ParseContent(Response.Header.CommonHeaders);
end;

procedure THTTPParser.ParseResponse(var Response: THTTPResponse);
begin
  ParseResponseStartLine(Response.StartLine);
  Response.HeaderComplete := ParseResponseHeader(Response.Header);
  Response.HasContent := ParseResponseContent(Response);
end;



{ THTTPContentDecoder }

const
  SError_UnknownContentEncoding = 'Unknown content encoding';
  SError_InvalidChunkedEncoding = 'Invalid chunked encoding';

constructor THTTPContentDecoder.Create(
            const ReadProc: THTTPContentDecoderReadProc;
            const ContentProc: THTTPContentDecoderContentProc;
            const CompleteProc: THTTPContentDecoderProc);
begin
  Assert(Assigned(ReadProc));
  Assert(Assigned(ContentProc));
  Assert(Assigned(CompleteProc));
  inherited Create;
  FReadProc := ReadProc;
  FContentProc := ContentProc;
  FCompleteProc := CompleteProc;
  Init;
end;

procedure THTTPContentDecoder.Init;
begin
end;

destructor THTTPContentDecoder.Destroy;
begin
  TCPBufferFinalise(FChunkBuf);
  inherited Destroy;
end;

procedure THTTPContentDecoder.Log(const LogMsg: String);
begin
  if Assigned(FOnLog) then
    FOnLog(self, LogMsg);
end;

procedure THTTPContentDecoder.Log(const LogMsg: String; const LogArgs: array of const);
begin
  Log(Format(LogMsg, LogArgs));
end;

procedure THTTPContentDecoder.InitDecoder(const CommonHeaders: THTTPCommonHeaders);
begin
  Log('Init');
  if CommonHeaders.ContentLength.Value = hcltByteCount then
    begin
      FContentType := crctFixedSize;
      FContentSize := CommonHeaders.ContentLength.ByteCount;
      Log('ContentType:FixedSize:%db', [FContentSize]);
      if FContentSize = 0 then
        TriggerContentComplete;
    end
  else
  if CommonHeaders.TransferEncoding.Value = hteChunked then
    begin
      Log('ContentType:Chunked');
      FContentType := crctChunked;
      FContentSize := -1;
      FChunkState := crcsChunkHeader;
      TCPBufferFinalise(FChunkBuf);
      TCPBufferInitialise(FChunkBuf, 65536, 256);
    end
  else
  if CommonHeaders.ContentType.Value <> hctNone then
    begin
      Log('ContentType:Unsized');
      FContentType := crctUnsized;
      FContentSize := -1;
    end
  else
    raise EHTTP.Create(SError_UnknownContentEncoding);
  FContentReceived := 0;
  FContentComplete := False;
end;

procedure THTTPContentDecoder.TriggerContentBuffer(const Buf; const Size: Integer);
begin
  {$IFDEF HTTP_DEBUG}
  Log('ContentBuffer:%db', [Size]);
  {$ENDIF}
  FContentProc(self, Buf, Size);
end;

procedure THTTPContentDecoder.TriggerContentComplete;
begin
  {$IFDEF HTTP_DEBUG}
  Log('ContentComplete');
  {$ENDIF}
  FContentComplete := True;
  FCompleteProc(self);
end;

procedure THTTPContentDecoder.TriggerTrailer(const Hdr: AnsiString);
begin
end;

procedure THTTPContentDecoder.ProcessFixedSize;
const
  ContentBlockSize = 65536;
var
  Buf         : array[0..ContentBlockSize - 1] of Byte;
  BufSize     : Integer;
  GotContent  : Boolean;
  ContentLeft : Int64;
  ContentSize : Integer;
begin
  ContentLeft := FContentSize - FContentReceived;
  repeat
    BufSize := ContentBlockSize;
    if BufSize > ContentLeft then
      BufSize := ContentLeft;
    ContentSize := FReadProc(self, Buf[0], BufSize);
    GotContent := ContentSize > 0;
    if GotContent then
      begin
        Inc(FContentReceived, ContentSize);
        TriggerContentBuffer(Buf, ContentSize);
        Dec(ContentLeft, ContentSize);
        if ContentLeft <= 0 then
          begin
            TriggerContentComplete;
            break;
          end;
      end;
  until not GotContent;
end;

procedure THTTPContentDecoder.ProcessUnsized;
const
  ContentBlockSize = 65536;
var
  Buf         : array[0..ContentBlockSize - 1] of Byte;
  GotContent  : Boolean;
  ContentSize : Integer;
begin
  repeat
    ContentSize := FReadProc(self, Buf[0], ContentBlockSize);
    GotContent := ContentSize > 0;
    if GotContent then
      begin
        Inc(FContentReceived, ContentSize);
        TriggerContentBuffer(Buf, ContentSize);
      end;
  until not GotContent;
end;

function THTTPContentDecoder.ProcessChunked_FillBuf(const Size: Integer): Boolean;
var
  P : Pointer;
  L, N : Integer;
begin
  L := TCPBufferUsed(FChunkBuf);
  {$IFDEF HTTP_DEBUG}
  Log('Chunk:FillBuf:BufferUsed:%db', [L]);
  {$ENDIF}
  Result := L >= Size;
  if Result then
    exit;
  N := Size - L;
  P := TCPBufferAddPtr(FChunkBuf, N);
  L := FReadProc(self, P^, N);
  {$IFDEF HTTP_DEBUG}
  Log('Chunk:FillBuf:Read:%db:%db', [N, L]);
  {$ENDIF}
  if L > 0 then
    begin
      Inc(FChunkBuf.Used, L);
      Result := L = N;
    end;
end;

function THTTPContentDecoder.ProcessChunked_FillBufBlock(const Size: Integer): Boolean;
var
  P : Pointer;
  L : Integer;
begin
  {$IFDEF HTTP_DEBUG}
  Log('Chunk:FillBufBlock:Size:%db', [Size]);
  {$ENDIF}
  P := TCPBufferAddPtr(FChunkBuf, Size);
  L := FReadProc(self, P^, Size);
  if L > 0 then
    begin
      {$IFDEF HTTP_DEBUG}
      Log('Chunk:FillBufBlock:Read:%db', [L]);
      {$ENDIF}
      Inc(FChunkBuf.Used, L);
      Result := True;
    end
  else
    Result := False;
end;

function THTTPContentDecoder.ProcessChunked_FillBufToCRLF(const BlockSize: Integer): Integer;
var I : Integer;
begin
  I := ProcessChunked_BufferCRLFPosition;
  if I < 0 then
    repeat
      if not ProcessChunked_FillBufBlock(BlockSize) then
        begin
          Result := -1;
          exit;
        end;
      I := ProcessChunked_BufferCRLFPosition;
    until I >= 0;
  Result := I;
end;

function THTTPContentDecoder.ProcessChunked_ReadStrToCRLF(const BlockSize: Integer; var Str: AnsiString): Boolean;
var I : Integer;
begin
  I := ProcessChunked_FillBufToCRLF(BlockSize);
  if I < 0 then
    begin
      Str := '';
      Result := False;
      exit;
    end;
  SetLength(Str, I);
  if I > 0 then
    TCPBufferRemove(FChunkBuf, Str[1], I);
  TCPBufferDiscard(FChunkBuf, 2);
  {$IFDEF HTTP_DEBUG}
  Log('Chunk:ReadStrToCRLF:%s', [Str]);
  {$ENDIF}
  Result := True;
end;

function THTTPContentDecoder.ProcessChunked_ExpectCRLF: Boolean;
var P : PAnsiChar;
begin
  Result := ProcessChunked_FillBuf(2);
  if not Result then
    exit;
  P := TCPBufferPtr(FChunkBuf);
  if P^ <> #13 then
    raise EHTTP.Create(SError_InvalidChunkedEncoding);
  Inc(P);
  if P^ <> #10 then
    raise EHTTP.Create(SError_InvalidChunkedEncoding);
  TCPBufferDiscard(FChunkBuf, 2);
  Result := True;
end;

function THTTPContentDecoder.ProcessChunked_BufferCRLFPosition: Integer;
var P : Pointer;
    A, B : PByte;
    L, I : Integer;
begin
  L := TCPBufferPeekPtr(FChunkBuf, P);
  A := P;
  B := P;
  Inc(A);
  for I := 0 to L - 2 do
    if (B^ = 13) and (A^ = 10) then
      begin
        Result := I;
        exit;
      end
    else
      begin
        Inc(A);
        Inc(B);
      end;
  Result := -1;
end;

function THTTPContentDecoder.ProcessChunked_ReadHeader(var HdrStr: AnsiString; var ChunkSize: Int64): Boolean;
const
  HeaderBlockSize = 256;
var
  ParamPos : Integer;
  HdrValid : Boolean;
  Chunk32  : LongWord;
begin
  Result := ProcessChunked_ReadStrToCRLF(HeaderBlockSize, HdrStr);
  if not Result then
    exit;
  //ParamPos := PosCharA(';', HdrStr);
  if ParamPos > 0 then
    SetLength(HdrStr, ParamPos - 1);
  //HdrStr := StrTrimRightA(HdrStr);
  //HdrValid := TryHexToLongWordA(HdrStr, Chunk32);
  if not HdrValid then
    raise EHTTP.Create(SError_InvalidChunkedEncoding);
  ChunkSize := Chunk32;
  Result := True;
end;

function THTTPContentDecoder.ProcessChunked_Header: Boolean;
var
  HdrStr : AnsiString;
begin
  {$IFDEF HTTP_DEBUG}
  Log('Chunk:Header:BufferUsed:%db', [TCPBufferUsed(FChunkBuf)]);
  {$ENDIF}
  Result := ProcessChunked_ReadHeader(HdrStr, FChunkSize);
  if not Result then
    exit;
  FChunkProcessed := 0;
  if FChunkSize = 0 then
    begin
      FChunkState := crcsTrailer;
      exit;
    end;
  FChunkState := crcsContent;
  {$IFDEF HTTP_DEBUG}
  Log('Chunk:Header:State:Content:BufferUsed:%db:ChunkSize:%db', [TCPBufferUsed(FChunkBuf), FChunkSize]);
  {$ENDIF}
end;

function THTTPContentDecoder.ProcessChunked_Content: Boolean;
const
  ContentBlockSize = 32768;
var
  L : Integer;
  BufPtr : Pointer;
  ChunkLeft : Int64;
begin
  ChunkLeft := FChunkSize - FChunkProcessed;
  repeat
    L := TCPBufferUsed(FChunkBuf);
    {$IFDEF HTTP_DEBUG}
    Log('Chunk:Content:BufferUsed:%db', [L]);
    {$ENDIF}
    if L > ChunkLeft then
      L := ChunkLeft;
    if L > 0 then
      begin
        TCPBufferPeekPtr(FChunkBuf, BufPtr);
        TriggerContentBuffer(BufPtr^, L);
        TCPBufferDiscard(FChunkBuf, L);
        Dec(ChunkLeft, L);
        Inc(FChunkProcessed, L);
        Inc(FContentReceived, L);
        if ChunkLeft = 0 then
          begin
            Result := True;
            FChunkState := crcsContentCRLF;
            {$IFDEF HTTP_DEBUG}
            Log('Chunk:Content:Complete');
            {$ENDIF}
            exit;
          end;
      end;
  until not ProcessChunked_FillBufBlock(ContentBlockSize);
  {$IFDEF HTTP_DEBUG}
  Log('Chunk:Content:ExitProcess');
  {$ENDIF}
  Result := False;
end;

function THTTPContentDecoder.ProcessChunked_ContentCRLF: Boolean;
begin
  Result := ProcessChunked_ExpectCRLF;
  if not Result then
    exit;
  FChunkState := crcsChunkHeader;
  {$IFDEF HTTP_DEBUG}
  Log('Chunk:ContentCRLF');
  {$ENDIF}
end;

function THTTPContentDecoder.ProcessChunked_Trailer: Boolean;
const
  TrailerBlockSize = 512;
var
  HdrStr : AnsiString;
begin
  {$IFDEF HTTP_DEBUG}
  Log('Chunk:Trailer');
  {$ENDIF}
  Result := True;
  while ProcessChunked_ReadStrToCRLF(TrailerBlockSize, HdrStr) do
    begin
      if HdrStr = '' then
        begin
          TriggerContentComplete;
          FChunkState := crcsFinished;
          ProcessChunked_Finalise;
          exit;
        end;
      TriggerTrailer(HdrStr);
    end;
end;

procedure THTTPContentDecoder.ProcessChunked_Finalise;
begin
  {$IFDEF HTTP_DEBUG}
  Log('Chunk:Finalise');
  {$ENDIF}
  TCPBufferFinalise(FChunkBuf);
end;

{
       Chunked-Body   = *chunk
                        last-chunk
                        trailer
                        CRLF
       chunk          = chunk-size [ chunk-extension ] CRLF
                        chunk-data CRLF
       chunk-size     = 1*HEX
       last-chunk     = 1*("0") [ chunk-extension ] CRLF
       chunk-extension= *( ";" chunk-ext-name [ "=" chunk-ext-val ] )
       chunk-ext-name = token
       chunk-ext-val  = token | quoted-string
       chunk-data     = chunk-size(OCTET)
       trailer        = *(entity-header CRLF)
}
procedure THTTPContentDecoder.ProcessChunked;
var R : Boolean;
begin
  repeat
    case FChunkState of
      crcsChunkHeader : R := ProcessChunked_Header;
      crcsContent     : R := ProcessChunked_Content;
      crcsContentCRLF : R := ProcessChunked_ContentCRLF;
      crcsTrailer     : R := ProcessChunked_Trailer;
      crcsFinished    : R := False;
    else
      R := False;
    end;
  until not R;
end;

procedure THTTPContentDecoder.Process;
begin
  {$IFDEF HTTP_DEBUG}
  Log('Process');
  {$ENDIF}
  case FContentType of
    crctFixedSize : ProcessFixedSize;
    crctChunked   : ProcessChunked;
    crctUnsized   : ProcessUnsized;
  end;
end;



{ THTTPContentReader }

constructor THTTPContentReader.Create(
    const ReadProc: THTTPContentReaderReadProc;
    const ContentProc: THTTPContentReaderContentProc;
    const CompleteProc: THTTPContentReaderProc);
begin
  Assert(Assigned(ReadProc));
  Assert(Assigned(ContentProc));
  Assert(Assigned(CompleteProc));
  inherited Create;
  FReadProc := ReadProc;
  FContentProc := ContentProc;
  FCompleteProc := CompleteProc;
  Init;
end;

destructor THTTPContentReader.Destroy;
begin
  FreeAndNil(FContentStringBuilder);
  FreeAndNil(FContentDecoder);
  inherited Destroy;
end;

procedure THTTPContentReader.Init;
begin
  FContentDecoder := THTTPContentDecoder.Create(
      ContentDecoderReadProc,
      ContentDecoderContentProc,
      ContentDecoderCompleteProc);
  FContentDecoder.OnLog := ContentDecoderLog;
end;

procedure THTTPContentReader.Log(const LogMsg: String; const LogLevel: Integer);
begin
  if Assigned(FOnLog) then
    FOnLog(self, LogMsg, LogLevel);
end;

procedure THTTPContentReader.Log(const LogMsg: String; const LogArgs: array of const; const LogLevel: Integer);
begin
  Log(Format(LogMsg, LogArgs), LogLevel);
end;

procedure THTTPContentReader.ContentDecoderLog(const Sender: THTTPContentDecoder; const LogMsg: String);
begin
  {$IFDEF HTTP_DEBUG}
  Log('Decoder:%s', [LogMsg], 1);
  {$ENDIF}
end;

function THTTPContentReader.ContentDecoderReadProc(const Sender: THTTPContentDecoder; var Buf; const Size: Integer): Integer;
begin
  Result := FReadProc(self, Buf, Size);
  {$IFDEF HTTP_DEBUG}
  Log('Read:%db:%db', [Size, Result]);
  {$ENDIF}
end;

procedure THTTPContentReader.ContentDecoderContentProc(const Sender: THTTPContentDecoder; const Buf; const Size: Integer);
begin
  {$IFDEF HTTP_DEBUG}
  Log('Content:%db', [Size]);
  {$ENDIF}
  FContentProc(self, Buf, Size);
  
  case FMechanism of
    hcrmEvent  : ;
    hcrmString : FContentStringBuilder.Append(@Buf, Size);
    hcrmStream :
      if Assigned(FContentStream) then
        FContentStream.WriteBuffer(Buf, Size);
    hcrmFile   :
      if Assigned(FContentFile) then
        FContentFile.WriteBuffer(Buf, Size);
  end;
end;

procedure THTTPContentReader.ContentDecoderCompleteProc(const Sender: THTTPContentDecoder);
begin
  {$IFDEF HTTP_DEBUG}
  Log('Complete');
  {$ENDIF}
  case FMechanism of
    hcrmEvent  : ;
    hcrmString :
      begin
        FContentString := FContentStringBuilder.AsAnsiString;
        FreeAndNil(FContentStringBuilder);
      end;
    hcrmStream : ;
    hcrmFile   : FreeAndNil(FContentFile);
  end;
  FContentComplete := True;

  FCompleteProc(self);
end;

procedure THTTPContentReader.InitReader(const CommonHeaders: THTTPCommonHeaders);
begin
  {$IFDEF HTTP_DEBUG}
  Log('InitReader:Mechanism:%d', [Ord(FMechanism)]);
  {$ENDIF}
  InternalReset;
  FContentDecoder.InitDecoder(CommonHeaders);
  case FMechanism of
    hcrmEvent  : ;
    hcrmString : FContentStringBuilder := TAnsiStringBuilder.Create;
    hcrmStream : ;
    hcrmFile   :
      if FContentFileName <> '' then
        FContentFile := TFileStream.Create(FContentFileName, fmCreate);
  end;
end;

procedure THTTPContentReader.Process;
begin
  {$IFDEF HTTP_DEBUG}
  Log('Process');
  {$ENDIF}
  FContentDecoder.Process;
end;

procedure THTTPContentReader.InternalReset;
begin
  FContentString := '';
  FreeAndNil(FContentStringBuilder);
  FreeAndNil(FContentFile);
  FContentComplete := False;
end;

procedure THTTPContentReader.Reset;
begin
  InternalReset;
end;



{ THTTPContentWriter }

constructor THTTPContentWriter.Create(const WriteProc: THTTPContentWriterWriteProc);
begin
  Assert(Assigned(WriteProc));
  inherited Create;
  FWriteProc := WriteProc;
  Init;
end;

procedure THTTPContentWriter.Init;
begin
end;

destructor THTTPContentWriter.Destroy;
begin
  inherited Destroy;
end;

procedure THTTPContentWriter.Log(const LogMsg: AnsiString);
begin
  if Assigned(FOnLog) then
    FOnLog(self, LogMsg);
end;

procedure THTTPContentWriter.InitContent(var ContentLength: Int64);
var L : Int64;
begin
  {$IFDEF HTTP_DEBUG}
  Log('InitContent');
  {$ENDIF}
  InternalReset;
  case FMechanism of
    hctmEvent   : raise EHTTP.Create('Mechanism not supported');
    hctmString  : L := Length(FContentString);
    hctmStream  :
      if Assigned(FContentStream) then
        L := FContentStream.Size
      else
        L := 0;
    hctmFile    :
      if FContentFileName <> '' then
        begin
          FContentFile := TFileStream.Create(FContentFileName, fmOpenRead);
          L := FContentFile.Size;
        end
      else
        L := 0;
  else
    raise EHTTP.Create('Mechanism not supported');
  end;
  {$IFDEF HTTP_DEBUG}
  Log('ContentLength:' + IntToStr(L));
  {$ENDIF}
  ContentLength := L;
  FContentComplete := (L = 0);
end;

procedure THTTPContentWriter.WriteBuf(const Buf; const Size: Integer);
begin
  if Size <= 0 then
    exit;
  Assert(Assigned(FWriteProc));
  FWriteProc(self, Buf, Size);
end;

procedure THTTPContentWriter.WriteStr(const S: AnsiString);
var L : Integer;
begin
  L := Length(S);
  if L = 0 then
    exit;
  Assert(Assigned(FWriteProc));
  FWriteProc(self, PAnsiChar(S)^, L);
end;

procedure THTTPContentWriter.SendContent;

  procedure SendContentFromStream(const S: TStream);
  const
    ContentBufSize = 32768;
  var
    ContentBuf : array[0..ContentBufSize - 1] of Byte;
    L : Integer;
  begin
    L := S.Read(ContentBuf[0], ContentBufSize);
    if L > 0 then
      WriteBuf(ContentBuf[0], L);
    FContentComplete := S.Position >= S.Size;
  end;

begin
  case FMechanism of
    hctmEvent  : ;
    hctmString :
      begin
        WriteStr(FContentString);
        FContentComplete := True;
      end;
    hctmStream :
      if Assigned(FContentStream) then
        SendContentFromStream(FContentStream);
    hctmFile   :
      if Assigned(FContentFile) then
        SendContentFromStream(FContentFile);
  end;
end;

procedure THTTPContentWriter.FinaliseContent;
begin
  case FMechanism of
    hctmEvent  : ;
    hctmString : ;
    hctmStream : ;
    hctmFile   : FreeAndNil(FContentFile);
  end;
end;

procedure THTTPContentWriter.InternalReset;
begin
  FreeAndNil(FContentFile);
end;

procedure THTTPContentWriter.Reset;
begin
  InternalReset;
end;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF HTTP_SELFTEST}
{$ASSERTIONS ON}
const
  // HTTP/1.1
  TestReq1 =
      'GET / HTTP/1.1'#13#10 +
      'Host: www.example.com'#13#10 +
      'Date: Mon 1 Jan 2010 12:23:34 GMT'#13#10 +
      'Connection: close'#13#10 +
      'Cookie: id=123'#13#10 +
      #13#10;

  // HTTP/1.0; Empty field values; Unknown field values; LWS
  TestReq2 =
      'GET / HTTP/1.0'#13#10 +
      'Host: abc'#13#10 +
      'Date: '#13#10 +
      'Connection: '#13#10' invalid'#13#10 +
      'Cookie: invalid'#13#10 +
      #13#10;

  // Pre-HTTP/1.0 response; Incomplete request
  TestReq3 =
      'GET /'#13#10 +
      'Host: abc'#13#10 +
      'X:';

  // HTTP/1.1
  TestResp1 =
      'HTTP/1.1 200 OK'#13#10 +
      'Server: Fundamentals'#13#10 +
      'Date: Monday, 2 Jan 2010 12:23:34 GMT'#13#10 +
      'Last-Modified: Monday, 2 Jan 2010 12:23:30 GMT'#13#10 +
      'Content-Type: text/html; charset=iso123'#13#10 +
      'Content-Length: 1'#13#10 +
      'Content-Encoding: gzip'#13#10 +
      'Age: 15'#13#10 +
      'Connection: Keep-Alive'#13#10 +
      'Set-Cookie: Domain=www.example.com; id=123'#13#10 +
      'Set-Cookie: Domain=www.example.com; id=222'#13#10 +
      #13#10 +
      '1';

  // HTTP/1.0; LWS; Empty field value; Custom field
  TestResp2 =
      'HTTP/1.0 401 Bad'#13#10 +
      'Server: '#13#10#9'Fundamentals'#13#10 +
      'Content-Type: text/abc;'#13#10' charset=iso123'#13#10 +
      'Content-Length: 1'#13#10 +
      'Connection: '#13#10 +
      'My-Field: abc'#13#10 +
      #13#10 +
      '1';

  // HTTP/1.0; Incomplete response; Incorrect date value
  TestResp3 =
      'HTTP/1.0 200 OK'#13#10 +
      'Content-Length: 1'#13#10 +
      'Date: 1 Jan 2001'#13#10 +
      'X:';

procedure SelfTest_Parser;
var P : THTTPParser;
    S : AnsiString;
    R : THTTPRequest;
    T : THTTPResponse;
begin
  InitHTTPRequest(R);
  InitHTTPResponse(T);

  P := THTTPParser.Create;
  try
    S := TestReq1;
    P.SetTextBuf(S[1], Length(S));
    P.ParseRequest(R);
    Assert(R.HeaderComplete);
    Assert(R.StartLine.Method.Value = hmGET);
    Assert(R.StartLine.URI = '/');
    Assert(R.StartLine.Version.Version = hvHTTP11);
    Assert(R.Header.FixedHeaders[hntHost] = 'www.example.com');
    Assert(R.Header.CommonHeaders.Date.Value = hdParts);
    Assert(R.Header.CommonHeaders.Date.DayOfWeek = 2);
    Assert(Abs(R.Header.CommonHeaders.Date.DateTime - (EncodeDate(2010, 1, 1) + EncodeTime(12, 23, 34, 0))) < 1e-06);
    Assert(R.Header.CommonHeaders.Date.TimeZoneGMT);
    Assert(R.Header.CommonHeaders.Connection.Value = hcfClose);
    Assert(R.Header.Cookie.Custom = 'id=123');
    Assert(not R.HasContent);
    Assert(not HTTPMessageHasContent(T.Header.CommonHeaders));

    ClearHTTPRequest(R);
    Assert(not R.HeaderComplete);
    Assert(R.StartLine.Method.Value = hmNone);
    Assert(R.StartLine.URI = '');
    Assert(R.Header.CommonHeaders.Connection.Value = hcfNone);
    Assert(R.Header.CommonHeaders.ContentType.Value = hctNone);
    Assert(R.Header.FixedHeaders[hntHost] = '');

    P.SetTextStr(TestReq2);
    P.ParseRequest(R);
    Assert(R.HeaderComplete);
    Assert(R.StartLine.Method.Value = hmGET);
    Assert(R.StartLine.URI = '/');
    Assert(R.StartLine.Version.Version = hvHTTP10);
    Assert(R.Header.FixedHeaders[hntHost] = 'abc');
    Assert(R.Header.CommonHeaders.Date.Custom = '');
    Assert(R.Header.CommonHeaders.Connection.Value = hcfCustom);
    Assert(R.Header.CommonHeaders.Connection.Custom = 'invalid');
    Assert(R.Header.Cookie.Value = hcoCustom);
    Assert(R.Header.Cookie.Custom = 'invalid');

    P.SetTextStr(TestReq3);
    P.ParseRequest(R);
    Assert(not R.HeaderComplete);
    Assert(R.StartLine.Method.Value = hmGET);
    Assert(R.StartLine.URI = '/');
    Assert(R.StartLine.Version.Version = hvCustom);
    Assert(R.StartLine.Version.Protocol = hpCustom);
    Assert(R.StartLine.Version.CustomProtocol = '');
    Assert(R.Header.FixedHeaders[hntHost] = 'abc');

    S := TestResp1;
    P.SetTextBuf(S[1], Length(S));
    P.ParseResponse(T);
    Assert(T.HeaderComplete);
    Assert(T.StartLine.Version.Version = hvHTTP11);
    Assert(T.StartLine.Code = 200);
    Assert(T.StartLine.Msg = hslmOK);
    Assert(T.Header.FixedHeaders[hntServer] = 'Fundamentals');
    Assert(T.Header.CommonHeaders.ContentType.Value = hctTextHtml);
    Assert(Length(T.Header.CommonHeaders.ContentType.Parameters) = 1);
    Assert(T.Header.CommonHeaders.Date.DayOfWeek = 2);
    Assert(Abs(T.Header.CommonHeaders.Date.DateTime - (EncodeDate(2010, 1, 2) + EncodeTime(12, 23, 34, 0))) < 1e-06);
    Assert(T.Header.CommonHeaders.Date.TimeZoneGMT);
    Assert(T.Header.LastModified.Value = hdParts);
    Assert(Abs(T.Header.LastModified.DateTime - (EncodeDate(2010, 1, 2) + EncodeTime(12, 23, 30, 0))) < 1e-06);
    Assert(T.Header.CommonHeaders.ContentType.Parameters[0] = 'charset=iso123');
    Assert(T.Header.CommonHeaders.ContentLength.Value = hcltByteCount);
    Assert(T.Header.CommonHeaders.ContentLength.ByteCount = 1);
    Assert(T.Header.CommonHeaders.Connection.Value = hcfKeepAlive);
    Assert(Length(T.Header.Cookies) = 2);
    Assert(T.Header.Cookies[0].Domain = 'www.example.com');
    Assert(Length(T.Header.Cookies[0].CustomFields) = 1);
    Assert(T.Header.Cookies[0].CustomFields[0].Name = 'id');
    Assert(T.Header.Cookies[0].CustomFields[0].Value = '123');
    Assert(T.Header.CommonHeaders.ContentEncoding.Value = hcefList);
    Assert(Length(T.Header.CommonHeaders.ContentEncoding.List) = 1);
    Assert(T.Header.CommonHeaders.ContentEncoding.List[0].Value = hceGzip);
    Assert(T.Header.Age.Value = hafAge);
    Assert(T.Header.Age.Age = 15);
    Assert(T.HasContent);
    Assert(HTTPMessageHasContent(T.Header.CommonHeaders));

    ClearHTTPResponse(T);
    Assert(not T.HeaderComplete);
    Assert(T.StartLine.Version.Version = hvNone);
    Assert(T.StartLine.Msg = hslmNone);
    Assert(T.Header.FixedHeaders[hntServer] = '');
    Assert(T.Header.CommonHeaders.Connection.Value = hcfNone);
    Assert(T.Header.CommonHeaders.ContentType.Value = hctNone);

    P.SetTextStr(TestResp2);
    P.ParseResponse(T);
    Assert(T.HeaderComplete);
    Assert(T.StartLine.Version.Version = hvHTTP10);
    Assert(T.StartLine.Code = 401);
    Assert(T.StartLine.CustomMsg = 'Bad');
    Assert(T.Header.FixedHeaders[hntServer] = 'Fundamentals');
    Assert(T.Header.CommonHeaders.ContentType.Value = hctTextCustom);
    Assert(T.Header.CommonHeaders.ContentType.CustomMinor = 'abc');
    Assert(Length(T.Header.CommonHeaders.ContentType.Parameters) = 1);
    Assert(T.Header.CommonHeaders.ContentType.Parameters[0] = 'charset=iso123');
    Assert(T.Header.CommonHeaders.ContentLength.Value = hcltByteCount);
    Assert(T.Header.CommonHeaders.ContentLength.ByteCount = 1);
    Assert(T.Header.CommonHeaders.Connection.Value = hcfCustom);
    Assert(T.Header.CommonHeaders.Connection.Custom = '');
    Assert(T.Header.CommonHeaders.Date.Value = hdNone);
    Assert(Length(T.Header.CustomHeaders) = 1);
    Assert(T.Header.CustomHeaders[0].FieldName = 'My-Field');
    Assert(T.Header.CustomHeaders[0].FieldValue = 'abc');
    Assert(T.HasContent);
    Assert(HTTPMessageHasContent(T.Header.CommonHeaders));

    ClearHTTPResponse(T);
    Assert(Length(T.Header.CustomHeaders) = 0);

    P.SetTextStr(TestResp3);
    P.ParseResponse(T);
    Assert(not T.HeaderComplete);
    Assert(T.StartLine.Version.Version = hvHTTP10);
    Assert(T.StartLine.Code = 200);
    Assert(T.StartLine.Msg = hslmOK);
    Assert(T.Header.CommonHeaders.ContentLength.Value = hcltByteCount);
    Assert(T.Header.CommonHeaders.ContentLength.ByteCount = 1);
    Assert(T.Header.CommonHeaders.Date.Value = hdCustom);
    Assert(T.Header.CommonHeaders.Date.Custom = '1 Jan 2001');

    ClearHTTPRequest(R);
    R.StartLine.Method.Value := hmGET;
    R.StartLine.URI := '/';
    R.StartLine.Version.Version := hvHTTP11;
    R.Header.CommonHeaders.Date.Value := hdDateTime;
    R.Header.CommonHeaders.Date.DateTime := GMTTimeToLocalTime(EncodeDate(2011, 6, 12) + EncodeTime(16, 15, 56, 0));
    R.Header.FixedHeaders[hntHost] := 'abc';
    R.Header.Cookie.Value := hcoCustom;
    R.Header.Cookie.Custom := 'id=123';
    S := HTTPRequestToStr(R);
    Assert(S =
        'GET / HTTP/1.1'#$D#$A +
        'Date: Sun, 12 Jun 2011 16:15:56 GMT'#$D#$A +
        'Host: abc'#$D#$A +
        'Cookie: id=123'#$D#$A +
        #$D#$A);

    ClearHTTPResponse(T);
    T.StartLine.Version.Version := hvHTTP11;
    T.StartLine.Code := 200;
    T.StartLine.Msg := hslmOK;
    T.Header.CommonHeaders.Date.Value := hdDateTime;
    T.Header.CommonHeaders.Date.DateTime := GMTTimeToLocalTime(EncodeDate(2011, 6, 12) + EncodeTime(16, 15, 56, 0));
    T.Header.FixedHeaders[hntServer] := 'abc';
    S := HTTPResponseToStr(T);
    Assert(S =
        'HTTP/1.1 200 OK'#$D#$A +
        'Date: Sun, 12 Jun 2011 16:15:56 GMT'#$D#$A +
        'Server: abc'#$D#$A +
        #$D#$A);
  finally
    P.Free;
  end;
end;

type
  THTTPContentReader_TestObj = class
    FBuf : AnsiString;
    FBufPos : Integer;
    FComplete : Boolean;
    FContent : AnsiString;
    procedure SetTestStr(const S: AnsiString);
    function  ReaderRead(const Sender: THTTPContentDecoder; var Buf; const Size: Integer): Integer;
    procedure ReaderContentComplete(const Sender: THTTPContentDecoder);
    procedure ReaderContentBuf(const Sender: THTTPContentDecoder; const Buf; const Size: Integer);
  end;

procedure THTTPContentReader_TestObj.SetTestStr(const S: AnsiString);
begin
  FBuf := S;
  FBufPos := 0;
  FComplete := False;
  FContent := '';
end;

function THTTPContentReader_TestObj.ReaderRead(const Sender: THTTPContentDecoder; var Buf; const Size: Integer): Integer;
var L, N : Integer;
begin
  L := Size;
  N := Length(FBuf) - FBufPos;
  if N < L then
    L := N;
  Move(FBuf[FBufPos + 1], Buf, L);
  Inc(FBufPos, L);
  Result := L;
end;

procedure THTTPContentReader_TestObj.ReaderContentBuf(const Sender: THTTPContentDecoder; const Buf; const Size: Integer);
var L : Integer;
begin
  L := Length(FContent);
  SetLength(FContent, L + Size);
  Move(Buf, FContent[L + 1], Size);
end;

procedure THTTPContentReader_TestObj.ReaderContentComplete(const Sender: THTTPContentDecoder);
begin
  FComplete := True;
end;

const
  TestChunked1 =
      '5' + #13#10 +
      '12345' + #13#10 +
      '10 ;Test=1'#13#10 +
      '1234567890123456' + #13#10 +
      '0'#13#10 +
      'Footer1: 123' + #13#10 +
      'Footer2: 456' + #13#10 +
      #13#10;

  TestChunked2 =
      '0' + #13#10 +
      #13#10;

  TestStr512 =
      '1234567890123456789012345678901234567890123456789012345678901234' +
      '1234567890123456789012345678901234567890123456789012345678901234' +
      '1234567890123456789012345678901234567890123456789012345678901234' +
      '1234567890123456789012345678901234567890123456789012345678901234' +
      '1234567890123456789012345678901234567890123456789012345678901234' +
      '1234567890123456789012345678901234567890123456789012345678901234' +
      '1234567890123456789012345678901234567890123456789012345678901234' +
      '1234567890123456789012345678901234567890123456789012345678901234';

  TestChunked3 =
      '200' + #13#10 +
      TestStr512 + #13#10 +
      '200' + #13#10 +
      TestStr512 + #13#10 +
      '1' + #13#10 +
      'X' + #13#10 +
      '0' + #13#10 +
      #13#10;

procedure SelfTest_Reader;
var T : THTTPContentReader_TestObj;
    R : THTTPContentDecoder;
    H : THTTPCommonHeaders;
begin
  T := THTTPContentReader_TestObj.Create;
  R := THTTPContentDecoder.Create(T.ReaderRead, T.ReaderContentBuf, T.ReaderContentComplete);
  try
    FillChar(H, SizeOf(H), 0);
    H.TransferEncoding.Value := hteChunked;

    R.InitDecoder(H);
    T.SetTestStr(TestChunked1);
    repeat
      R.Process;
    until T.FComplete;
    Assert(T.FBufPos >= Length(T.FBuf));
    Assert(T.FContent = '123451234567890123456');
    Assert(R.ContentReceived = 21);

    R.InitDecoder(H);
    T.SetTestStr(TestChunked2);
    repeat
      R.Process;
    until T.FComplete;
    Assert(T.FBufPos >= Length(T.FBuf));
    Assert(T.FContent = '');
    Assert(R.ContentReceived = 0);

    R.InitDecoder(H);
    T.SetTestStr(TestChunked3);
    repeat
      R.Process;
    until T.FComplete;
    Assert(T.FBufPos >= Length(T.FBuf));
    Assert(T.FContent = TestStr512 + TestStr512 + 'X');
    Assert(R.ContentReceived = 1025);
  finally
    R.Free;
    T.Free;
  end;
end;

procedure SelfTest;
begin
  SelfTest_Parser;
  SelfTest_Reader;
end;
{$ENDIF}


function StringBuilderNewCapacity(const L, N: Integer): Integer; {$IFDEF UseInline}inline;{$ENDIF}
begin
  // memory allocation strategy
  if N = 0 then        // first allocation is exactly as requested
    Result := L else
  if L < 16 then       // if grow to < 16 then allocate 16
    Result := 16
  else                 // if grow to >= 16 then pre-allocate 1/4
    Result := L + (L shr 2);
end;




{                                                                              }
{ TAnsiStringBuilder                                                           }
{                                                                              }
constructor TAnsiStringBuilder.Create(const S: AnsiString);
begin
  inherited Create;
  SetAsAnsiString(S);
end;

constructor TAnsiStringBuilder.Create(const Capacity: Integer);
begin
  inherited Create;
  EnsureCapacity(Capacity);
end;

procedure TAnsiStringBuilder.EnsureCapacity(const L: Integer);
var N : Integer;
begin
  N := System.Length(FString);
  if L > N then
    begin
      N := StringBuilderNewCapacity(L, N);
      SetLength(FString, N);
    end;
end;

function TAnsiStringBuilder.GetAsAnsiString: AnsiString;
begin
  if FLength = System.Length(FString) then
    Result := FString // return reference instead of copy
  else
    Result := Copy(FString, 1, FLength);
end;

procedure TAnsiStringBuilder.SetAsAnsiString(const S: AnsiString);
begin
  FString := S;
  FLength := System.Length(S);
end;

function TAnsiStringBuilder.GetAsString: String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(GetAsAnsiString);
  {$ELSE}
  Result := GetAsAnsiString;
  {$ENDIF}
end;

procedure TAnsiStringBuilder.Clear;
begin
  FString := '';
  FLength := 0;
end;

procedure TAnsiStringBuilder.Assign(const S: TAnsiStringBuilder);
var L : Integer;
begin
  L := S.FLength;
  FString := Copy(S.FString, 1, L);
  FLength := L;
end;

procedure TAnsiStringBuilder.Append(const S: AnsiString);
var M, L, N : Integer;
    P       : PAnsiChar;
begin
  M := System.Length(S);
  if M = 0 then
    exit;
  N := FLength;
  L := N + M;
  if L > System.Length(FString) then
    EnsureCapacity(L);
  P := Pointer(FString);
  Inc(P, N);
  Move(Pointer(S)^, P^, M);  //movemem
  FLength := L;
end;

procedure TAnsiStringBuilder.AppendCRLF;
begin
  Append(#13#10);
end;

procedure TAnsiStringBuilder.AppendLn(const S: AnsiString);
begin
  Append(S);
  AppendCRLF;
end;

procedure TAnsiStringBuilder.Append(const S: AnsiString; const Count: Integer);
var M, L, N, I : Integer;
    P          : PAnsiChar;
begin
  if Count <= 0 then
    exit;
  M := System.Length(S);
  if M = 0 then
    exit;
  N := FLength;
  L := N + (M * Count);
  if L > System.Length(FString) then
    EnsureCapacity(L);
  P := Pointer(FString);
  Inc(P, N);
  for I := 1 to Count do
    begin
      Move(Pointer(S)^, P^, M);
      Inc(P, M);
    end;
  FLength := L;
end;

procedure TAnsiStringBuilder.AppendCh(const C: AnsiChar);
var L, N : Integer;
    P    : PAnsiChar;
begin
  N := FLength;
  L := N + 1;
  if L > System.Length(FString) then
    EnsureCapacity(L);
  P := Pointer(FString);
  Inc(P, N);
  P^ := C;
  FLength := L;
end;

procedure TAnsiStringBuilder.AppendCh(const C: AnsiChar; const Count: Integer);
var L, N : Integer;
    P    : PAnsiChar;
begin
  if Count <= 0 then
    exit;
  N := FLength;
  L := N + Count;
  if L > System.Length(FString) then
    EnsureCapacity(L);
  P := Pointer(FString);
  Inc(P, N);
  FillChar(P^, Count, Ord(C)); //FillMem
  FLength := L;
end;

procedure TAnsiStringBuilder.Append(const BufPtr: Pointer; const Size: Integer);
var L, N : Integer;
    P    : PAnsiChar;
begin
  if Size <= 0 then
    exit;
  N := FLength;
  L := N + Size;
  if L > System.Length(FString) then
    EnsureCapacity(L);
  P := Pointer(FString);
  Inc(P, N);
  Move(BufPtr^, P^, Size);
  FLength := L;
end;

procedure TAnsiStringBuilder.Append(const S: TAnsiStringBuilder);
var M, L, N : Integer;
    P       : PAnsiChar;
begin
  M := S.FLength;
  if M = 0 then
    exit;
  N := FLength;
  L := N + M;
  if L > System.Length(FString) then
    EnsureCapacity(L);
  P := Pointer(FString);
  Inc(P, N);
  Move(Pointer(S.FString)^, P^, M);
  FLength := L;
end;

procedure TAnsiStringBuilder.Pack;
var L : Integer;
begin
  L := FLength;
  if L = System.Length(FString) then
    exit;
  SetLength(FString, L);
end;




end.

