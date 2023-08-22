{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{  for maXbox a merge between indy 9 and indy 10, locs=4001
{ $Log:  10169: IdGlobal.pas 
{
{   Rev 1.5    7/23/04 6:09:48 PM  RLebeau
{ TFileStream access right tweak for CopyFileTo() and FileSizeByName()
}
{
{   Rev 1.4    2004-05-07 10:09:00  Mattias
{ Added GetCurrentThreadHandle from Indy10
}
{
{   Rev 1.3    9/10/2003 03:17:28 AM  JPMugaas
{ Added EnsureMsgIDBrackets() function.  Checked in on behalf of Remy Lebeau
}
{
{   Rev 1.2    1/9/2003 05:44:10 PM  JPMugaas
{ Added workaround for if a space is missing after the comma in a date.  For
{ example:
{ 
{ Wed,08 Jan 2003 08:09:16 PM
}
{
{   Rev 1.1    29/11/2002 10:16:40 AM  SGrobety
{ Changed GetTickCount to use high permormance counters if possible under
{ Windows
}
{
{   Rev 1.0    2002.11.12 10:39:16 PM  czhower
}
unit IdGlobal_max;

interface
{
2002-04-02 - Darren Kosinski (Borland) - Have SetThreadPriority do nothing on Linux.
2002-01-28 - Hadi Hariri. Fixes for C++ Builder. Thanks to Chuck Smith.
2001-12-21 - Andrew P.Rybin
 - Fetch,FetchCaseInsensitive,IsNumeric(Chr),PosIdx,AnsiPosIdx optimization
2001-Nov-26 - Peter Mee
 - Added IndyStrToBool
2001-Nov-21 - Peter Mee
 - Moved the Fetch function's default values to constants.
 - Added FetchCaseInsensitive.
11-10-2001 - J. Peter Mugaas
  - Merged changes proposed by Andrew P.Rybin}

{$I IdCompilerDefines.inc}

{This is the only unit with references to OS specific units and IFDEFs. NO OTHER units
are permitted to do so except .pas files which are counterparts to dfm/xfm files, and only for
support of that.}

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  Classes,
  IdException,
  SyncObjs, SysUtils;

type
  TIdOSType = (otUnknown, otLinux, otWindows);

  TBytes = array of Byte;

  TIdBytes = TBytes;
  TIdPort = Integer;

  //TIdStrings

  EIdException = class(Exception);
  TClassIdException = class of EIdException;
    //used for index out of range
  EIdRangeException = class(EIdException);

const
  IdTimeoutDefault = -1;
  IdTimeoutInfinite = -2;

  IdFetchDelimDefault = ' ';    {Do not Localize}
  IdFetchDeleteDefault = true;
  IdFetchCaseSensitiveDefault = true;
  //We make the version things an INC so that they can be managed independantly
  //by the package builder.
  {$I IdVers.inc}
  //
  POWER_1 = $000000FF;
  POWER_2 = $0000FFFF;
  POWER_3 = $00FFFFFF;
  POWER_4 = $FFFFFFFF;

   // Sets UnixStartDate to TIdDateTime of 01/01/1970
  UNIXSTARTDATE : TDateTime = 25569.0;
   {This indicates that the default date is Jan 1, 1900 which was specified
    by RFC 868.}
  TIME_BASEDATE = 2;


  CHAR0 = #0;
  BACKSPACE = #8;
  LF = #10;
  CR = #13;
  EOL = CR + LF;
  TAB = #9;
  CHAR32 = #32;
  {$IFNDEF VCL6ORABOVE}
  //Only D6&Kylix have this constant
  sLineBreak = EOL;
  {$ENDIF}

  LWS = [TAB, CHAR32];
  wdays: array[1..7] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'    {Do not Localize}
   , 'Sat'); {do not localize}
  monthnames: array[1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May'    {Do not Localize}
   , 'Jun',  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'); {do not localize}
  IdHexDigits: array [0..15] of Char = '0123456789ABCDEF';    {Do not Localize}

  IdOctalDigits: array [0..7] of AnsiChar = ('0','1','2','3','4','5','6','7'); {do not localize}
  //IdHexDigits: array [0..15] of AnsiChar = ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'); {do not localize}
  HEXPREFIX = '0x';  {Do not translate}


  {$IFDEF Linux}
  GPathDelim = '/'; {do not localize}
  GOSType = otLinux;
  INFINITE = LongWord($FFFFFFFF);     { Infinite timeout }


  // approximate values, its finer grained on Linux
  tpIdle = 19;
  tpLowest = 12;
  tpLower = 6;
  tpNormal = 0;
  tpHigher = -7;
  tpHighest = -13;
  tpTimeCritical = -20;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  GPathDelim = '\'; {do not localize}
  GOSType = otWindows;
  infinite = windows.INFINITE; { redeclare here for use elsewhere without using Windows.pas }  // cls modified 1/23/2002
  {$ENDIF}

type
  {$IFDEF LINUX}
    {$IFNDEF VCL6ORABOVE}
    THandle = LongWord; //D6.System
    {$ENDIF}
  TIdThreadPriority = -20..19;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
    {$IFNDEF VCL6ORABOVE}
    THandle = Windows.THandle;
    {$ENDIF}
  TIdThreadPriority = TThreadPriority;
  {$ENDIF}
  TIdEncoding = (enDefault, enANSI, enUTF8);
  //We don't have a native type that can hold an IPv6 address.
  TIdIPv6Address = array [0..7] of word;

  {$IFDEF LINUX}
  TIdPID = Integer;
  TIdThreadPriority = -20..19;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  TIdPID = LongWord;
  {$ENDIF}

   //TIdDateTimeBase = TDateTime;!
   //TIdDateTime = TIdDateTimeBase;

  {This way instead of a boolean for future expansion of other actions}
  TIdMaxLineAction = (maException, maSplit);

  TIdReadLnFunction = function: string of object;
  TStringEvent = procedure(ASender: TComponent; const AString: String);
  TPosProc = function(const Substr, S: string): Integer;
  TIdReuseSocket = (rsOSDependent, rsTrue, rsFalse);

  TIdCardinalBytes = record
    case Integer of
    0: (
      Byte1: Byte;
      Byte2: Byte;
      Byte3: Byte;
      Byte4: Byte;);
    1: (Whole: Cardinal);
    2: (CharArray : array[0..3] of Char);
  end;

  TIdLocalEvent = class(TEvent)
  public
    constructor Create(const AInitialState: Boolean = False;
     const AManualReset: Boolean = False); reintroduce;
    function WaitFor: TWaitResult; overload;
  end;

  TIdMimeTable = class(TObject)
  protected
    FOnBuildCache: TNotifyEvent;
    FMIMEList: TStringList;
    FFileExt: TStringList;
    procedure BuildDefaultCache; virtual;
  public
    procedure BuildCache; virtual;
    procedure AddMimeType(const Ext, MIMEType: string);
    function GetFileMIMEType(const AFileName: string): string;
    function GetDefaultFileExt(Const MIMEType: string): string;
    procedure LoadFromStrings(AStrings: TStrings; const MimeSeparator: Char = '=');    {Do not Localize}
    procedure SaveToStrings(AStrings: TStrings; const MimeSeparator: Char = '=');    {Do not Localize}
    constructor Create(Autofill: boolean=true); virtual;
    destructor Destroy; override;
    //
    property  OnBuildCache: TNotifyEvent read FOnBuildCache write FOnBuildCache;
  end;

  //APR: for fast Stream reading (ex: StringStream killer)
  TIdReadMemoryStream = class (TCustomMemoryStream)
  public
    procedure SetPointer(Ptr: Pointer; Size: Longint);
    function Write(const Buffer; Count: Longint): Longint; override;
  End;

  // TODO: add ALL IANA charsets
  TIdCharSet = (csGB2312, csBig5, csIso2022jp, csEucKR, csIso88591);

  {$IFNDEF VCL6ORABOVE}
  PByte =^Byte;
  PWord =^Word;
  {$ENDIF}


  {$IFDEF MSWINDOWS}
  //TIdWin32Type = (Win32s, WindowsNT40, Windows95, Windows95OSR2, Windows98, Windows98SE,Windows2000, WindowsMe, WindowsXP);
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  TIdWin32Type = (Win32s,
    WindowsNT40PreSP6Workstation, WindowsNT40PreSP6Server, WindowsNT40PreSP6AdvancedServer,
    WindowsNT40Workstation, WindowsNT40Server, WindowsNT40AdvancedServer,
    Windows95, Windows95OSR2,
    Windows98, Windows98SE,
    Windows2000Pro, Windows2000Server, Windows2000AdvancedServer,
    WindowsMe,
    WindowsXPPro,
    Windows2003Server, Windows2003AdvancedServer);
  {$ENDIF}


  //This is called whenever there is a failure to retreive the time zone information
  EIdFailedToRetreiveTimeZoneInfo = class(EIdException);
  //This usually is a property editor exception
  EIdCorruptServicesFile = class(EIdException);
  //
  EIdExtensionAlreadyExists = class(EIdException);

  // TIdBytes utilities indy10
  procedure AppendBytes(var VBytes: TIdBytes; AAdd: TIdBytes);
  procedure AppendByte(var VBytes: TIdBytes; AByte: byte);
  procedure AppendString(var VBytes: TIdBytes; const AStr: String; ALength: Integer = -1);
  procedure CopyTIdBytes(const ASource: TIdBytes; const ASourceIndex: Integer;
    var VDest: TIdBytes; const ADestIndex: Integer; const ALength: Integer);
  procedure CopyTIdByteArray(const ASource: array of Byte; const ASourceIndex: Integer;
    var VDest: array of Byte; const ADestIndex: Integer; const ALength: Integer);
  procedure CopyTIdWord(const ASource: Word;
    var VDest: TIdBytes; const ADestIndex: Integer);
  procedure CopyTIdString(const ASource: String;
    var VDest: TIdBytes; const ADestIndex: Integer; ALength: Integer = -1);
  // To and From Bytes conversion routines
  function ToBytes(const AValue: string; const AEncoding: TIdEncoding = enANSI): TIdBytes; overload;
  function ToBytes(const AValue: Char): TIdBytes; overload;
  function ToBytes(const AValue: Integer): TIdBytes; overload;
  function ToBytes(const AValue: Short): TIdBytes; overload;
  function ToBytes(const AValue: Word): TIdBytes; overload;
  function ToBytes(const AValue: Byte): TIdBytes; overload;
  function ToBytes(const AValue: Cardinal): TIdBytes; overload;
  function ToBytes(const AValue: Int64): TIdBytes; overload;
  function ToBytes(const AValue: TIdBytes; const ASize: Integer): TIdBytes; overload;
// RLebeau - not using the same "ToBytes" naming convention for RawToBytes()
// in order to prevent ambiquious errors with ToBytes(TIdBytes) above
  function RawToBytes(const AValue; const ASize: Integer): TIdBytes;
    procedure CopyBytesToHostCardinal(const ASource : TIdBytes; const ASourceIndex: Integer;
    var VDest : Cardinal);
  procedure CopyBytesToHostWord(const ASource : TIdBytes; const ASourceIndex: Integer;
    var VDest : Word);
  procedure CopyTIdNetworkCardinal(const ASource: Cardinal;
    var VDest: TIdBytes; const ADestIndex: Integer);
  procedure CopyTIdNetworkWord(const ASource: Word;
    var VDest: TIdBytes; const ADestIndex: Integer);
  procedure CopyTIdLongWord(const ASource: LongWord;
    var VDest: TIdBytes; const ADestIndex: Integer);

  procedure CopyTIdCardinal(const ASource: Cardinal;
    var VDest: TIdBytes; const ADestIndex: Integer);

  procedure CopyTIdInt64(const ASource: Int64;
    var VDest: TIdBytes; const ADestIndex: Integer);

   procedure CopyTIdIPV6Address(const ASource: TIdIPv6Address;
    var VDest: TIdBytes; const ADestIndex: Integer);


// Procs - KEEP THESE ALPHABETICAL!!!!!
  function  AnsiMemoryPos(const ASubStr: String; MemBuff: PChar; MemorySize: Integer): Integer;
  function  AnsiPosIdx(const ASubStr,AStr: AnsiString; AStartPos: Cardinal=0): Cardinal;
  {$IFNDEF VCL5ORABOVE}
  function  AnsiSameText(const S1, S2: string): Boolean;
  procedure FreeAndNil(var Obj);
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  function GetFileCreationTime(const Filename: string): TDateTime;
  function GetInternetFormattedFileTimeStamp(const AFilename: String): String;
  {$ENDIF}
//  procedure BuildMIMETypeMap(dest: TStringList);
  // TODO: IdStrings have optimized SplitColumns* functions, can we remove it?


  function ABNFToText(const AText : String) : String;
  function BinStrToInt(const ABinary: String): Integer;
  //function BreakApart(BaseString, BreakString: string; StringList: TIdStrings): TIdStrings;
  function CardinalToFourChar(ACardinal : Cardinal): string;
  function CharRange(const AMin, AMax : Char): String;
   Function CharToHex(const APrefix : String; const c : AnsiChar) : shortstring;

  function CharIsInSet(const AString: string; const ACharPos: Integer; const ASet:  String): Boolean;
   function CharIsInEOF(const AString: string; ACharPos: Integer): Boolean;

    function BytesToCardinal(const AValue: TIdBytes; const AIndex: Integer = 0): Cardinal;
  function BytesToWord(const AValue: TIdBytes; const AIndex : Integer = 0): Word;
  function BytesToChar(const AValue: TIdBytes; const AIndex: Integer = 0): Char;
 function BytesToShort(const AValue: TIdBytes; const AIndex: Integer = 0): Short;
 function BytesToInteger(const AValue: TIdBytes; const AIndex: Integer = 0): Integer;
 function BytesToInt64(const AValue: TIdBytes; const AIndex: Integer = 0): Int64;
 function BytesToIPv6(const AValue: TIdBytes; const AIndex: Integer = 0): TIdIPv6Address;
  function BytesToString(ABytes: TIdBytes; AStartIndex: Integer = 0; AMaxCount: Integer = MaxInt): string; overload;
 function ByteToHex(const AByte: Byte): string;
 function ByteToOctal(const AByte: Byte): string;

 function ByteToBin(Int: Byte): String; //from is in IdGlobal 64bit
 function BinToByte(Binary: String): Byte;


  function BreakApart(BaseString, BreakString: string; StringList: TStrings): TStrings;
  procedure CommaSeparatedToStringList(AList: TStrings; const Value:string);
  function CompareDateTime(const ADateTime1, ADateTime2 : TDateTime) : Integer;


  function CopyFileTo(const Source, Destination: string): Boolean;
  function CurrentProcessId: TIdPID;

    //MLIST FTP DateTime conversion functions
  function FTPMLSToGMTDateTime(const ATimeStamp : String):TDateTime;
  function FTPMLSToLocalDateTime(const ATimeStamp : String):TDateTime;

  function FTPGMTDateTimeToMLS(const ATimeStamp : TDateTime; const AIncludeMSecs : Boolean=True): String;
  function FTPLocalDateTimeToMLS(const ATimeStamp : TDateTime; const AIncludeMSecs : Boolean=True): String;


  function GetCurrentThreadHandle : THandle;
  function DateTimeToGmtOffSetStr(ADateTime: TDateTime; SubGMT: Boolean): string;
  function DateTimeGMTToHttpStr(const GMTValue: TDateTime) : String;
  Function DateTimeToInternetStr(const Value: TDateTime; const AIsGMT : Boolean = False) : String;
  procedure DebugOutput(const AText: string);
  function DomainName(const AHost: String): String;
  function EnsureMsgIDBrackets(const AMsgID: String): String;
  function Fetch(var AInput: string; const ADelim: string = IdFetchDelimDefault;
    const ADelete: Boolean = IdFetchDeleteDefault;
    const ACaseSensitive : Boolean = IdFetchCaseSensitiveDefault) : string;
  function FetchCaseInsensitive(var AInput: string; const ADelim: string = IdFetchDelimDefault;
    const ADelete: Boolean = IdFetchDeleteDefault) : string;
  function FileSizeByName(const AFilename: string): Int64;
  function GetMIMETypeFromFile(const AFile: TFileName): string;
  function GetMIMEDefaultFileExt(const MIMEType: string): string;
  function GetUniqueFileName(const APath, APrefix, AExt : String) : String;
  function GetGMTDateByName(const AFileName : String) : TDateTime;

  function GetSystemLocale: TIdCharSet;
  function GetThreadHandle(AThread: TThread): THandle;
  procedure FillBytes(var VBytes : TIdBytes; const ACount : Integer; const AValue : Byte);
  function CurrentThreadId: TIdPID;

  function GetTickCount: Cardinal;
  //required because GetTickCount will wrap
  function GetTickDiff(const AOldTickCount, ANewTickCount : Cardinal):Cardinal;
  function GmtOffsetStrToDateTime(S: string): TDateTime;
  function GMTToLocalDateTime(S: string): TDateTime;
  procedure IdDelete(var s: string; AOffset, ACount: Integer);
  procedure IdInsert(const Source: string; var S: string; Index: Integer);

  function IdPorts: TList;
  function IdPorts2: TStringList;
  function iif(ATest: Boolean; const ATrue: Integer; const AFalse: Integer): Integer; overload;
  function iif(ATest: Boolean; const ATrue: string;  const AFalse: string): string; overload;
  function iif(ATest: Boolean; const ATrue: Boolean; const AFalse: Boolean): Boolean; overload;
  function iif(ATest: Boolean; const ATrue: double; const AFalse: double): double; overload;

  function IncludeTrailingSlash(const APath: string): string;
  function IntToBin(Value: cardinal): string;
  function IndyGetHostName: string;
  function IndyInterlockedIncrement(var I: Integer): Integer;
  function IndyInterlockedDecrement(var I: Integer): Integer;
  function IndyInterlockedExchange(var A: Integer; B: Integer): Integer;
  function IndyInterlockedExchangeAdd(var A: Integer; B: Integer): Integer;
  function IndyStrToBool(const AString: String): Boolean;
  function IsCurrentThread(AThread: TThread): boolean;
  function IsDomain(const S: String): Boolean;
  function IsFQDN(const S: String): Boolean;
  function IsHostname(const S: String): Boolean;
  function IsNumeric(AChar: Char): Boolean; overload;
  function IsNumeric(const AString: string): Boolean; overload;
  function IsBinary(const AChar : Char) : Boolean;
  function IsHex(const AChar : Char) : Boolean;
  function IsTopDomain(const AStr: string): Boolean;
  function IsValidIP(const S: String): Boolean;
  function IsLeadChar(ACh : Char):Boolean;
  function IsASCII(const AByte: Byte): Boolean;
  function IsASCIILDH(const AByte: Byte): Boolean;
  function IsHexidecimal(AChar: Char): Boolean;
  function IsHexidecimalString(const AString: string): Boolean;
  function IsOctal(AChar: Char): Boolean;
  function IsOctalString(const AString: string): Boolean;


  function InMainThread: boolean;
  function Max(AValueOne,AValueTwo: Integer): Integer;
  function Max64(const AValueOne,AValueTwo: Int64): Int64;
  function Min64(const AValueOne, AValueTwo: Int64): Int64;
   procedure MoveChars(const ASource:String;ASourceStart:integer;var ADest:String;ADestStart, ALen:integer);
  // function OrdFourByteToCardinal(AByte1, AByte2, AByte3, AByte4 : Byte): Cardinal;
  function OctalToInt64(const AValue: string): Int64;

  function IPv4ToDWord(const AIPAddress: string): Cardinal; overload;
  function IPv4ToDWord(const AIPAddress: string; var VErr: Boolean): Cardinal; overload;
  function IPv4MakeCardInRange(const AInt: Int64; const A256Power: Integer): Cardinal;

  function IPv6AddressToStr(const AValue: TIdIPv6Address): string;

  function MakeDWordIntoIPv4Address(const ADWord: Cardinal): string;
  function MakeCanonicalIPv4Address(const AAddr: string): string;


  {APR: Help function to construct TMethod record. Can be useful to assign regular type procedure/function as event handler
  for event, defined as object method (do not forget, that in that case it must have first dummy parameter to replace @Self,
  passed in EAX to methods of object)}
  function MakeMethod (DataSelf, Code: Pointer): TMethod;
  function MakeTempFilename(const APath: String = ''): string;
  function Min(AValueOne, AValueTwo: Integer): Integer;
  function OffsetFromUTC: TDateTime;
  function PosIdx (const ASubStr,AStr: AnsiString; AStartPos: Cardinal=0): Cardinal;//For "ignoreCase" use AnsiUpperCase
  function PosInStrArray(const SearchStr: string; Contents: array of string;
    const CaseSensitive: Boolean=True): Integer;
  function ProcessPath(const ABasePath: String; const APath: String;
    const APathDelim: string = '/'): string;    {Do not Localize}
  function ProcessPath2(const ABasePath: String; const APath: String;
    const APathDelim: string = '/'): string;    {Do not Localize}

  function RightStr(const AStr: String; Len: Integer): String;
  function ROL(AVal: LongWord; AShift: Byte): LongWord;
  function ROR(AVal: LongWord; AShift: Byte): LongWord;
  function RPos(const ASub, AIn: String; AStart: Integer = -1): Integer;
  function PosInSmallIntArray(const ASearchInt: SmallInt; AArray: array of SmallInt): Integer;

  function ServicesFilePath: string;
  function SetLocalTime(Value: TDateTime): boolean;
  procedure SetThreadPriority(AThread: TThread; const APriority: TIdThreadPriority; const APolicy: Integer = -MaxInt);
  procedure Sleep(ATime: cardinal);
  function StrToCard(const AStr: String): Cardinal;
  function StrInternetToDateTime(Value: string): TDateTime;
  function StrToDay(const ADay: string): Byte;
  function StrToMonth(const AMonth: string): Byte;
  function StartsWith(const ANSIStr, APattern : String) : Boolean;
  function WordToStr(const Value: Word): String;
  function StrToWord(const Value: String): Word;
  function OrdFourByteToCardinal(AByte1, AByte2, AByte3, AByte4 : Byte): Cardinal;
  function TwoCharToWord(AChar1, AChar2: Char):Word;
  function TwoByteToWord(AByte1, AByte2: Byte): Word;
  procedure WordToTwoBytes(AWord : Word; ByteArray: TIdBytes; Index: integer);
  function StartsWithACE(const ABytes: TIdBytes): Boolean;
  function UnixDateTimeToDelphiDateTime(UnixDateTime: Cardinal): TDateTime;
  function TextIsSame(const A1: string; const A2: string): Boolean;
  function TextStartsWith(const S, SubS: string): Boolean;
  function IndyUpperCase(const A1: string): string;
  function IndyLowerCase(const A1: string): string;
  function IndyCompareStr(const A1: string; const A2: string): Integer;
  function Ticks: Cardinal;
  procedure ToDo;

  function MemoryPos(const ASubStr: String; MemBuff: PChar; MemorySize: Integer): Integer;
  function TimeZoneBias: TDateTime;
  function UpCaseFirst(const AStr: string): string;
  function GetClockValue : Int64;
  FUNCTION GetIPHostByName(const AComputerName: STRING): STRING;


  {$IFDEF MSWINDOWS}
  function Win32Type : TIdWin32Type;
  {$ENDIF}

var
  IndyPos: TPosProc = nil;
  {$IFDEF LINUX}
  // For linux the user needs to set these variables to be accurate where used (mail, etc)
  GOffsetFromUTC: TDateTime = 0;
  GSystemLocale: TIdCharSet = csIso88591;
  GTimeZoneBias: TDateTime = 0;
  {$ENDIF}

  IndyFalseBoolStrs : array of String;
  IndyTrueBoolStrs : array of String;

implementation

uses
  {$IFDEF LINUX}
  Libc,
  IdStackLinux,
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  IdStackWindows,
  Registry,
  WinSock,  //gethostbyname
  {$ENDIF}
  IdStack, IdResourceStrings, IdURI;

const
  WhiteSpace = [#0..#12, #14..' ']; {do not localize}


var
  FIdPorts: TList;
  vidPorts: TStringList;
  {$IFDEF MSWINDOWS}
  ATempPath: string;
  {$ENDIF}

{This routine is based on JPM Open by J. Peter Mugaas.  Permission is granted
to use this with Indy under Indy's Licenses

Note that JPM Open is under a different Open Source license model.

It is available at http://www.wvnet.edu/~oma00215/jpm.html }

{$IFDEF MSWINDOWS}

type
  TNTEditionType = (workstation, server, advancedserver);


function GetNTType : TNTEditionType;
var
  RtlGetNtProductType:function(ProductType:PULONG):BOOL;stdcall;
  Lh:THandle;
  LVersion:ULONG;
begin
  result:=workstation;
  lh:=LoadLibrary('ntdll.dll'); {do not localize}
  if Lh>0 then begin
    @RtlGetNtProductType:=GetProcAddress(lh,'RtlGetNtProductType'); {do not localize}
    if @RtlGetNtProductType<>nil then begin
      RtlGetNtProductType(@LVersion);
      case LVersion of
        1: result := workstation;
        2: result := server;
        3: result := advancedserver;
      end;
    end;
    FreeLibrary(lh);
  end;
end;

function GetOSServicePack : Integer;
var LNumber : String;
  LBuf : String;
  i : Integer;
  OS : TOSVersionInfo;
begin
  OS.dwOSVersionInfoSize := SizeOf(OS);
  GetVersionEx(OS);
  LBuf := OS.szCSDVersion;
  //Strip off "Service Pack" words
  Fetch(LBuf,' ');
  Fetch(LBuf,' ');
  //get the version number without any letters
  LNumber := '';
  for i := 1 to Length(LBuf) do
  begin
    if IsNumeric(LBuf[i]) then
    begin
      LNumber := LNumber+LBuf[i];
    end
    else
    begin
      Break;
    end;
  end;
  Result := StrToIntDef(LNumber,0);
end;


function Win32Type: TIdWin32Type;
begin
  {VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);  GetVersionEx(VerInfo);}
  {is this Windows 2000, 2003, or XP?}
  if Win32MajorVersion >= 5 then begin
    if Win32MinorVersion >= 2 then begin
      case GetNTType of
        server : Result := Windows2003Server;
        advancedserver : Result := Windows2003Server;
      else
        Result := WindowsXPPro; // Windows 2003 has no desktop version
      end;
    end
    else
    begin
      if Win32MinorVersion >= 1 then begin
        case GetNTType of
          server : Result := Windows2000Server; // hmmm, winXp has no server versions
          advancedserver : Result := Windows2000AdvancedServer; // hmmm, winXp has no server versions
        else
          Result := WindowsXPPro;
        end;
      end
      else begin
        case GetNTType of
          server : Result := Windows2000Server;
          advancedserver : Result := Windows2000AdvancedServer;
        else
          Result := Windows2000Pro;
        end;
      end;
    end;
  end
  else begin
    {is this WIndows 95, 98, Me, or NT 40}
    if Win32MajorVersion > 3 then begin
      if Win32Platform = VER_PLATFORM_WIN32_NT then begin
        //Bas requested that we specifically check for anything below SP6
        if (GetOSServicePack<6) then
        begin
          case GetNTType of
            server : Result := WindowsNT40PreSP6Server;
            advancedserver : Result := WindowsNT40PreSP6AdvancedServer;
          else
            Result := WindowsNT40PreSP6Workstation;
          end;
        end
        else
        begin
          case GetNTType of
        //WindowsNT40Workstation, WindowsNT40Server, WindowsNT40AdvancedServer
            server : Result := WindowsNT40Server;
            advancedserver : Result := WindowsNT40AdvancedServer;
          else
            Result := WindowsNT40Workstation;
          end;
        end;
      end
      else begin
        {mask off junk}
        Win32BuildNumber := Win32BuildNumber and $FFFF;
        if Win32MinorVersion >= 90 then begin
          Result := WindowsMe;
        end
        else begin
          if Win32MinorVersion >= 10 then begin
            {Windows 98}
            if Win32BuildNumber >= 2222 then begin
              Result := Windows98SE
            end
            else begin
              Result := Windows98;
            end;
          end
          else begin {Windows 95}
            if Win32BuildNumber >= 1000 then begin
              Result := Windows95OSR2
            end
            else begin
              Result := Windows95;
            end;
          end;
        end;
      end;//if VER_PLATFORM_WIN32_NT
    end
    else begin
      Result := Win32s;
    end;
  end;//if Win32MajorVersion >= 5
end;
{$ENDIF}


FUNCTION GetIPHostByName(const AComputerName: STRING): STRING;
VAR
TMPResult: STRING;
WSA: TWSAData;
H: PHostEnt;
P: PChar;
BEGIN
IF WSAStartUp($101, WSA) = 0 THEN BEGIN
GetMem(P,255 + 1);
StrPCopy(P, AComputerName);
H:= GetHostByName(P);
FreeMem(P);
IF H <> NIL THEN BEGIN
P:= inet_ntoa(PInAddr(H^.h_addr_list^)^);
TMPResult:= StrPas(P)
END;
WSACleanUp;
IF TMPResult <> '' THEN
Result:=TMPResult
ELSE
Result:= '0';
END;
END;


procedure FillBytes(var VBytes : TIdBytes; const ACount : Integer; const AValue : Byte);
begin
  {$IFDEF DOTNET}
     System.&Array.Clear(VBytes,0,ACount);
  {$ELSE}
     FilLChar(VBytes[0],ACount,AValue);
  {$ENDIF}
end;

function CurrentThreadId: TIdPID;
begin
{$IFDEF DotNet}
  // SG: I'm not sure if this return the handle of the dotnet thread or the handle of the application domain itself (or even if there is a difference)
  Result := AppDomain.GetCurrentThreadId;
  // RLebeau
  // TODO: find if there is something like the following instead:
  // System.Diagnostics.Thread.GetCurrentThread.ID
  // System.Threading.Thread.CurrentThread.ID

{$ELSE}
  // TODO: is GetCurrentThreadId() available on Linux?
  Result := GetCurrentThreadID;
{$ENDIF}
end;


function GetThreadHandle(AThread : TThread) : THandle;
begin
  {$IFDEF LINUX}
  Result := AThread.ThreadID;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Result := AThread.Handle;
  {$ENDIF}
end;

{This is an internal procedure so the StrInternetToDateTime and GMTToLocalDateTime can share common code}
function RawStrInternetToDateTime(var Value: string): TDateTime;
var
  i: Integer;
  Dt, Mo, Yr, Ho, Min, Sec: Word;
  sTime: String;
  ADelim: string;

  Procedure ParseDayOfMonth;
  begin
    Dt :=  StrToIntDef( Fetch(Value, ADelim), 1);
    Value := TrimLeft(Value);
  end;

  Procedure ParseMonth;
  begin
    Mo := StrToMonth( Fetch ( Value, ADelim )  );
    Value := TrimLeft(Value);
  end;
begin
  Result := 0.0;
  Value := Trim(Value);
  if Length(Value) = 0 then begin
    Exit;
  end;

  try
    {Day of Week}
    if StrToDay(Copy(Value, 1, 3)) > 0 then begin
      //workaround in case a space is missing after the initial column
      if (Copy(Value,4,1)=',') and (Copy(Value,5,1)<>' ') then
      begin
        System.Insert(' ',Value,5);
      end;
      Fetch(Value);
      Value := TrimLeft(Value);
    end;

    // Workaround for some buggy web servers which use '-' to separate the date parts.    {Do not Localize}
    if (IndyPos('-', Value) > 1) and (IndyPos('-', Value) < IndyPos(' ', Value)) then begin    {Do not Localize}
      ADelim := '-';    {Do not Localize}
    end
    else begin
      ADelim := ' ';    {Do not Localize}
    end;
    //workaround for improper dates such as 'Fri, Sep 7 2001'    {Do not Localize}
    //RFC 2822 states that they should be like 'Fri, 7 Sep 2001'    {Do not Localize}
    if (StrToMonth(Fetch(Value, ADelim,False)) > 0) then
    begin
      {Month}
      ParseMonth;
      {Day of Month}
      ParseDayOfMonth;
    end
    else
    begin
      {Day of Month}
      ParseDayOfMonth;
      {Month}
      ParseMonth;
    end;
    {Year}
    // There is sometrage date/time formats like
    // DayOfWeek Month DayOfMonth Time Year

    sTime := Fetch(Value);
    Yr := StrToIntDef(sTime, 1900);
    // Is sTime valid Integer
    if Yr = 1900 then begin
      Yr := StrToIntDef(Value, 1900);
      Value := sTime;
    end;
    if Yr < 80 then begin
      Inc(Yr, 2000);
    end else if Yr < 100 then begin
      Inc(Yr, 1900);
    end;

    Result := EncodeDate(Yr, Mo, Dt);
    // SG 26/9/00: Changed so that ANY time format is accepted
    i := IndyPos(':', Value); {do not localize}
    if i > 0 then begin
      // Copy time string up until next space (before GMT offset)
      sTime := fetch(Value, ' ');  {do not localize}
      {Hour}
      Ho  := StrToIntDef( Fetch ( sTime,':'), 0);  {do not localize}
      {Minute}
      Min := StrToIntDef( Fetch ( sTime,':'), 0);  {do not localize}
      {Second}
      Sec := StrToIntDef( Fetch ( sTime ), 0);
      {The date and time stamp returned}
      Result := Result + EncodeTime(Ho, Min, Sec, 0);
    end;
    Value := TrimLeft(Value);
  except
    Result := 0.0;
  end;
end;

function IncludeTrailingSlash(const APath: string): string;
begin
  {for some odd reason, the IFDEF's were not working in Delphi 4    
  so as a workaround and to ensure some code is actually compiled into
  the procedure, I use a series of $elses}
  {$IFDEF VCL5O}
  Result := IncludeTrailingBackSlash(APath);
  {$ELSE}
    {$IFDEF VCL6ORABOVE}
    Result :=  IncludeTrailingPathDelimiter(APath);
    {$ELSE}
    Result := APath;
    if not IsPathDelimiter(Result, Length(Result)) then begin
      Result := Result + GPathDelim;
    end;
    {$ENDIF}
  {$ENDIF}
end;

{$IFNDEF VCL5ORABOVE}
function AnsiSameText(const S1, S2: string): Boolean;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, PChar(S1)
   , Length(S1), PChar(S2), Length(S2)) = 2;
end;

procedure FreeAndNil(var Obj);
var
  P: TObject;
begin
  if TObject(Obj) <> nil then begin
    P := TObject(Obj);
    TObject(Obj) := nil;  // clear reference before destroying the object
    P.Free;
  end;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
  {$IFNDEF VCL5ORABOVE}
  function CreateTRegistry: TRegistry;
  begin
    Result := TRegistry.Create;
  end;
  {$ELSE}
  function CreateTRegistry: TRegistry;
  begin
    Result := TRegistry.Create(KEY_READ);
  end;
  {$ENDIF}
{$ENDIF}

function Max(AValueOne,AValueTwo: Integer): Integer;
begin
  if AValueOne < AValueTwo then
  begin
    Result := AValueTwo
  end //if AValueOne < AValueTwo then
  else
  begin
    Result := AValueOne;
  end; //else..if AValueOne < AValueTwo then
end;

function Max64(const AValueOne,AValueTwo: Int64): Int64;
begin
  if AValueOne < AValueTwo then begin
    Result := AValueTwo
  end
  else begin
    Result := AValueOne;
  end;
end;

function Min64(const AValueOne, AValueTwo: Int64): Int64;
begin
  If AValueOne > AValueTwo then begin
    Result := AValueTwo
  end
  else begin
    Result := AValueOne;
  end;
end;


function Min(AValueOne, AValueTwo : Integer): Integer;
begin
  If AValueOne > AValueTwo then
  begin
    Result := AValueTwo
  end //If AValueOne > AValueTwo then
  else
  begin
    Result := AValueOne;
  end; //..If AValueOne > AValueTwo then
end;

procedure MoveChars(const ASource:String;ASourceStart:integer;var ADest:String;ADestStart, ALen:integer);
{$ifdef DotNet}
var a:integer;
{$endif}
begin
  {$ifdef DotNet}
  for a:=1 to ALen do begin
    ADest[ADestStart]:= ASource[ASourceStart];
    inc(ADestStart);
    inc(ASourceStart);
  end;
  {$else}
    System.Move(ASource[ASourceStart], ADest[ADestStart], ALen);
  {$endif}
end;


{This should never be localized}
function DateTimeGMTToHttpStr(const GMTValue: TDateTime) : String;
// should adhere to RFC 2616
var
  wDay,
  wMonth,
  wYear: Word;
begin
  DecodeDate(GMTValue, wYear, wMonth, wDay);
  Result := Format('%s, %.2d %s %.4d %s %s',    {do not localize}
                   [wdays[DayOfWeek(GMTValue)], wDay, monthnames[wMonth],
                    wYear, FormatDateTime('HH":"NN":"SS', GMTValue), 'GMT']);  {do not localize}
end;

{This should never be localized}
function DateTimeToInternetStr(const Value: TDateTime; const AIsGMT : Boolean = False) : String;
var
  wDay,
  wMonth,
  wYear: Word;
begin
  DecodeDate(Value, wYear, wMonth, wDay);
  Result := Format('%s, %d %s %d %s %s',    {do not localize}
                   [wdays[DayOfWeek(Value)], wDay, monthnames[wMonth],
                    wYear, FormatDateTime('HH":"NN":"SS', Value),  {do not localize}
                    DateTimeToGmtOffSetStr(OffsetFromUTC, AIsGMT)]);
end;

function StrInternetToDateTime(Value: string): TDateTime;
begin
  Result := RawStrInternetToDateTime(Value);
end;

{$IFDEF MSWINDOWS}
function GetInternetFormattedFileTimeStamp(const AFilename: String):String;
const
  wdays: array[1..7] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'); {do not localize}
  monthnames: array[1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',   {do not localize}
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'); {do not localize}
var
  DT1, DT2 : TDateTime;
  wDay, wMonth, wYear: Word;
begin
  DT1 := GetFileCreationTime(AFilename);
  DecodeDate(DT1, wYear, wMonth, wDay);
  DT2 := TimeZoneBias;
  Result := Format('%s, %d %s %d %s %s', [wdays[DayOfWeek(DT1)], wDay, monthnames[wMonth],   {do not localize}
   wYear, FormatDateTime('HH":"NN":"SS', DT1), DateTimeToGmtOffSetStr(DT2,False)]);   {do not localize}
end;

function GetFileCreationTime(const Filename: string): TDateTime;
var
  Data: TWin32FindData;
  H: THandle;
  FT: TFileTime;
  I: Integer;
begin
  H := FindFirstFile(PCHAR(Filename), Data);
  if H <> INVALID_HANDLE_VALUE then begin
    try
      FileTimeToLocalFileTime(Data.ftLastWriteTime, FT);
      FileTimeToDosDateTime(FT, LongRec(I).Hi, LongRec(I).Lo);
      Result := FileDateToDateTime(I);
    finally
      Windows.FindClose(H);
    end
  end else begin
    Result := 0;
  end;
end;
{$ENDIF}

function BreakApart(BaseString, BreakString: string; StringList: TStrings): TStrings;
var
  EndOfCurrentString: integer;
begin
  repeat
    EndOfCurrentString := Pos(BreakString, BaseString);
    if (EndOfCurrentString = 0) then
    begin
      StringList.add(BaseString);
    end
    else
      StringList.add(Copy(BaseString, 1, EndOfCurrentString - 1));
    delete(BaseString, 1, EndOfCurrentString + Length(BreakString) - 1); //Copy(BaseString, EndOfCurrentString + length(BreakString), length(BaseString) - EndOfCurrentString);
  until EndOfCurrentString = 0;
  result := StringList;
end;

procedure CommaSeparatedToStringList(AList: TStrings; const Value:string);
var
  iStart,
  iEnd,
  iQuote,
  iPos,
  iLength : integer ;
  sTemp : string ;
begin
  iQuote := 0;
  iPos := 1 ;
  iLength := Length(Value) ;
  AList.Clear ;
  while (iPos <= iLength) do
  begin
    iStart := iPos ;
    iEnd := iStart ;
    while ( iPos <= iLength ) do
    begin
      if Value[iPos] = '"' then  {do not localize}
      begin
        inc(iQuote);
      end;
      if Value[iPos] = ',' then  {do not localize}
      begin
        if iQuote <> 1 then
        begin
          break;
        end;
      end;
      inc(iEnd);
      inc(iPos);
    end ;
    sTemp := Trim(Copy(Value, iStart, iEnd - iStart));
    if Length(sTemp) > 0 then
    begin
      AList.Add(sTemp);
    end;
    iPos := iEnd + 1 ;
    iQuote := 0 ;
  end ;
end;

function CompareDateTime(const ADateTime1, ADateTime2 : TDateTime) : Integer;
var
  LYear1, LYear2 : Word;
  LMonth1, LMonth2 : Word;
  LDay1, LDay2 : Word;
  LHour1, LHour2 : Word;
  LMin1, LMin2 : Word;
  LSec1, LSec2 : Word;
  LMSec1, LMSec2 : Word;
{
The return value is less than 0 if ADateTime1 is less than ADateTime2,
0 if ADateTime1 equals ADateTime2, or
greater than 0 if ADateTime1 is greater than ADateTime2.
}
begin
  DecodeDate(ADateTime1,LYear1,LMonth1,LDay1);
  DecodeDate(ADateTime2,LYear2,LMonth2,LDay2);
  // year
  Result := LYear1 - LYear2;
  if Result <> 0 then
  begin
    Exit;
  end;
  // month
  Result := LMonth1 - LMonth2;
  if Result <> 0 then
  begin
    Exit;
  end;
  // day
  Result := LDay1 - LDay2;
  if Result <> 0 then
  begin
    Exit;
  end;
  DecodeTime(ADateTime1,LHour1,LMin1,LSec1,LMSec1);
  DecodeTime(ADateTime2,LHour2,LMin2,LSec2,LMSec2);
  //hour
  Result := LHour1 - LHour2;
  if Result <> 0 then
  begin
    Exit;
  end;
  //minute
  Result := LMin1 - LMin2;
  if Result <> 0 then
  begin
    Exit;
  end;
  //second
  Result := LSec1 - LSec2;
  if Result <> 0 then
  begin
    Exit;
  end;
  //millasecond
  Result := LMSec1 - LMSec2;
end;


{$IFDEF LINUX}
function CopyFileTo(const Source, Destination: string): Boolean;
var
  SourceStream: TFileStream;
begin
  // -TODO: Change to use a Linux copy function
  // There is no native Linux copy function (at least "cp" doesn't use one
  // and I can't find one anywhere (Johannes Berg))
  Result := false;
  if not FileExists(Destination) then begin
    SourceStream := TFileStream.Create(Source, fmOpenRead or fmShareDenyWrite); try
      with TFileStream.Create(Destination, fmCreate) do try
        CopyFrom(SourceStream, 0);
      finally Free; end;
    finally SourceStream.free; end;
    Result := true;
  end;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
function CopyFileTo(const Source, Destination: string): Boolean;
begin
  Result := CopyFile(PChar(Source), PChar(Destination), true);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function TempPath: string;
var
	i: integer;
begin
  SetLength(Result, MAX_PATH);
	i := GetTempPath(Length(Result), PChar(Result));
	SetLength(Result, i);
  IncludeTrailingSlash(Result);
end;
{$ENDIF}

function MakeTempFilename(const APath: String = ''): string;
Begin
  {$IFDEF LINUX}
    {
    man tempnam
    [...]
    BUGS
       The precise meaning of `appropriate' is undefined;  it  is
       unspecified  how  accessibility  of  a directory is deter­
       mined.  Never use this function. Use tmpfile(3) instead.
    [...]

    Should we really use this?
    Alternatives would be to use tmpfile, but this creates a file.
    So maybe it would be worth checking if we ever need the name w/o a file!
  }
  Result := tempnam(nil, 'Indy');    {do not localize}
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  SetLength(Result, MAX_PATH + 1);
  if APath > '' then begin  {Do not localize}
    GetTempFileName(PChar(IncludeTrailingSlash(APath)), 'Indy', 0, PChar(Result));  {do not localize}
  end
  else begin
    GetTempFileName(PChar(ATempPath), 'Indy', 0, PChar(Result));  {do not localize}
  end;
  Result := PChar(Result);
  {$ENDIF}
End;

// Find a token given a direction (>= 0 from start; < 0 from end)
// S.G. 19/4/00:
//  Changed to be more readable
function RPos(const ASub, AIn: String; AStart: Integer = -1): Integer;
var
  i: Integer;
  LStartPos: Integer;
  LTokenLen: Integer;
begin
  result := 0;
  LTokenLen := Length(ASub);
  // Get starting position
  if AStart = -1 then begin
    AStart := Length(AIn);
  end;
  if AStart < (Length(AIn) - LTokenLen + 1) then begin
    LStartPos := AStart;
  end else begin
    LStartPos := (Length(AIn) - LTokenLen + 1);
  end;
  // Search for the string
  for i := LStartPos downto 1 do begin
    if AnsiSameText(Copy(AIn, i, LTokenLen), ASub) then begin
      result := i;
      break;
    end;
  end;
end;

function GetSystemLocale: TIdCharSet;
begin
{$IFDEF LINUX}
  Result := GSystemLocale;
{$ENDIF}
{$IFDEF MSWINDOWS}
  case SysLocale.PriLangID of
    LANG_CHINESE:
      if SysLocale.SubLangID = SUBLANG_CHINESE_SIMPLIFIED then
        Result := csGB2312
      else
        Result := csBig5;
    LANG_JAPANESE: Result := csIso2022jp;
    LANG_KOREAN: Result := csEucKR;
    else
      Result := csIso88591;
  end;
{$ENDIF}
end;

// OS-independant version      max - Int64
function FileSizeByName(const AFilename: string): Int64;
begin
  with TFileStream.Create(AFilename, fmOpenRead or fmShareDenyWrite) do
  try
    Result := Size;
  finally Free; end;
end;


Function RightStr(const AStr: String; Len: Integer): String;
var
  LStrLen : Integer;
begin
  LStrLen := Length (AStr);
  if (Len > LStrLen) or (Len < 0) then begin
    Result := AStr;
  end  //f ( Len > Length ( st ) ) or ( Len < 0 ) then
  else begin
    //+1 is necessary for the Index because it is one based
    Result := Copy(AStr, LStrLen - Len+1, Len);
  end; //else ... f ( Len > Length ( st ) ) or ( Len < 0 ) then
end;

{$IFDEF LINUX}
function OffsetFromUTC: TDateTime;
begin
  //TODO: Fix OffsetFromUTC for Linux to be automatic from OS
  Result := GOffsetFromUTC;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
function OffsetFromUTC: TDateTime;
var
  iBias: Integer;
  tmez: TTimeZoneInformation;
begin
  Case GetTimeZoneInformation(tmez) of
    TIME_ZONE_ID_INVALID:
      raise EIdFailedToRetreiveTimeZoneInfo.Create(RSFailedTimeZoneInfo);
    TIME_ZONE_ID_UNKNOWN  :
       iBias := tmez.Bias;
    TIME_ZONE_ID_DAYLIGHT :
      iBias := tmez.Bias + tmez.DaylightBias;
    TIME_ZONE_ID_STANDARD :
      iBias := tmez.Bias + tmez.StandardBias;
    else
      raise EIdFailedToRetreiveTimeZoneInfo.Create(RSFailedTimeZoneInfo);
  end;
  {We use ABS because EncodeTime will only accept positve values}
  Result := EncodeTime(Abs(iBias) div 60, Abs(iBias) mod 60, 0, 0);
  {The GetTimeZone function returns values oriented towards convertin
   a GMT time into a local time.  We wish to do the do the opposit by returning
   the difference between the local time and GMT.  So I just make a positive
   value negative and leave a negative value as positive}
  if iBias > 0 then begin
    Result := 0 - Result;
  end;
end;
{$ENDIF}

function StrToCard(const AStr: String): Cardinal;
begin
  Result := StrToInt64Def(Trim(AStr),0);
end;

{$IFDEF LINUX}
function TimeZoneBias: TDateTime;
begin
  //TODO: Fix TimeZoneBias for Linux to be automatic
  Result := GTimeZoneBias;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
function TimeZoneBias: TDateTime;
var
  ATimeZone: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(ATimeZone) of
    TIME_ZONE_ID_DAYLIGHT:
      Result := ATimeZone.Bias + ATimeZone.DaylightBias;
    TIME_ZONE_ID_STANDARD:
      Result := ATimeZone.Bias + ATimeZone.StandardBias;
    TIME_ZONE_ID_UNKNOWN:
      Result := ATimeZone.Bias;
    else
      raise EIdException.Create(SysErrorMessage(GetLastError));
  end;
  Result := Result / 1440;
end;
{$ENDIF}

{$IFDEF LINUX}
function GetTickCount: Cardinal;
var
  tv: timeval;
begin
  gettimeofday(tv, nil);
  {$RANGECHECKS OFF}
  Result := int64(tv.tv_sec) * 1000 + tv.tv_usec div 1000;
  {
    I've implemented this correctly for now. I'll argue for using
    an int64 internally, since apparently quite some functionality
    (throttle, etc etc) depends on it, and this value may wrap
    at any point in time.
    For Windows: Uptime > 72 hours isn't really that rare any more,
    For Linux: no control over when this wraps.

    IdEcho has code to circumvent the wrap, but its not very good
    to have code for that at all spots where it might be relevant.

  }
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
// S.G. 27/11/2002: Changed to use high-performance counters as per suggested
// S.G. 27/11/2002: by David B. Ferguson (david.mcs@ns.sympatico.ca)
function GetTickCount: Cardinal;
var
  nTime, freq: Int64;
begin
  if Windows.QueryPerformanceFrequency(freq) then
    if Windows.QueryPerformanceCounter(nTime) then
       result:=Trunc(nTime/Freq*1000)
    else
       result:= Windows.GetTickCount
  else
    result:= Windows.GetTickCount;
end;
{$ENDIF}

function GetTickDiff(const AOldTickCount, ANewTickCount : Cardinal):Cardinal;
begin
  {This is just in case the TickCount rolled back to zero}
    if ANewTickCount >= AOldTickCount then begin
      Result := ANewTickCount - AOldTickCount;
    end else begin
      Result := High(Cardinal) - AOldTickCount + ANewTickCount;
    end;
end;

function IndyStrToBool(const AString : String) : Boolean;
var
  LCount : Integer;
begin
  // First check against each of the elements of the FalseBoolStrs
  for LCount := Low(IndyFalseBoolStrs) to High(IndyFalseBoolStrs) do
  begin
    if AnsiSameText(AString, IndyFalseBoolStrs[LCount]) then
    begin
      result := false;
      exit;
    end;
  end;
  // Second check against each of the elements of the TrueBoolStrs
  for LCount := Low(IndyTrueBoolStrs) to High(IndyTrueBoolStrs) do
  begin
    if AnsiSameText(AString, IndyTrueBoolStrs[LCount]) then
    begin
      result := true;
      exit;
    end;
  end;
  // None of the strings match, so convert to numeric (allowing an
  // EConvertException to be thrown if not) and test against zero.
  // If zero, return false, otherwise return true.
  LCount := StrToInt(AString);
  if LCount = 0 then
  begin
    result := false;
  end else
  begin
    result := true;
  end;
end;

{$IFDEF LINUX}
function SetLocalTime(Value: TDateTime): boolean;
begin
  //TODO: Implement SetTime for Linux. This call is not critical.
  result := False;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
function SetLocalTime(Value: TDateTime): boolean;
{I admit that this routine is a little more complicated than the one
in Indy 8.0.  However, this routine does support Windows NT privillages
meaning it will work if you have administrative rights under that OS

Original author Kerry G. Neighbour with modifications and testing
from J. Peter Mugaas}
var
   dSysTime: TSystemTime;
   buffer: DWord;
   tkp, tpko: TTokenPrivileges;
   hToken: THandle;
begin
  Result := False;
  if SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    if not Windows.OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
      hToken) then
    begin
      exit;
    end;
    Windows.LookupPrivilegeValue(nil, 'SE_SYSTEMTIME_NAME', tkp.Privileges[0].Luid);    {Do not Localize}
    tkp.PrivilegeCount := 1;
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    if not Windows.AdjustTokenPrivileges(hToken, FALSE, tkp, sizeof(tkp), tpko, buffer) then
    begin
      exit;
    end;
  end;
  DateTimeToSystemTime(Value, dSysTime);
  Result := Windows.SetLocalTime(dSysTime);
  {Undo the Process Privillage change we had done for the set time
  and close the handle that was allocated}
  if SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    Windows.AdjustTokenPrivileges(hToken, FALSE,tpko, sizeOf(tpko), tkp, Buffer);
    Windows.CloseHandle(hToken);
  end;
end;
{$ENDIF}

function ServicesFilePath: string;
var sLocation: string;
begin
    {$IFDEF LINUX}
    sLocation := '/etc/';  // assume Berkeley standard placement   {do not localize}
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    SetLength(sLocation, MAX_PATH);
    SetLength(sLocation, GetWindowsDirectory(pchar(sLocation), MAX_PATH));
    sLocation := IncludeTrailingPathDelimiter(sLocation);
    if Win32Platform = VER_PLATFORM_WIN32_NT then begin
      sLocation := sLocation + 'system32\drivers\etc\'; {do not localize}
    end;
    {$ENDIF}
  Result := sLocation + 'services'; {do not localize}
end;


// IdPorts returns a list of defined ports in /etc/services
// set return from tlist to stringlist
function IdPorts: TList;
var
  sLocation, s: String;
  idx, i, iPrev, iPosSlash: integer;
  sl: TStringList;
begin
  if FIdPorts = nil then
  begin
    FIdPorts := TList.Create;
    {$IFDEF LINUX}
    sLocation := '/etc/';  // assume Berkeley standard placement   {do not localize}
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    SetLength(sLocation, MAX_PATH);
    SetLength(sLocation, GetWindowsDirectory(pchar(sLocation), MAX_PATH));
    sLocation := IncludeTrailingSlash(sLocation);
    if Win32Platform = VER_PLATFORM_WIN32_NT then begin
      sLocation := sLocation + 'system32\drivers\etc\'; {do not localize}
    end;
    {$ENDIF}
    sl := TStringList.Create;
    try
      sl.LoadFromFile(sLocation + 'services');  {do not localize}
      iPrev := 0;
      for idx := 0 to sl.Count - 1 do
      begin
        s := sl[idx];
        iPosSlash := IndyPos('/', s);   {do not localize}
        if (iPosSlash > 0) and (not (IndyPos('#', s) in [1..iPosSlash])) then {do not localize}
        begin // presumably found a port number that isn't commented    {Do not Localize}
          i := iPosSlash;
          repeat
            dec(i);
            if i = 0 then begin
              raise EIdCorruptServicesFile.CreateFmt(RSCorruptServicesFile, [sLocation + 'services']); {do not localize}
            end;
          until s[i] in WhiteSpace;
          i := StrToInt(Copy(s, i+1, iPosSlash-i-1));
          if i <> iPrev then begin
            FIdPorts.Add(TObject(i));
          end;
          iPrev := i;
        end;
      end;
    finally
      sl.Free;
    end;
  end;
  Result := FIdPorts;
end;

function IdPorts2: TStringList;
var
  sLocation, s: String;
  idx, i, iPrev, iPosSlash: integer;
  sl: TStringList;
begin
  if vidports = nil then begin
    vidports:= TStringList.Create;
    {$IFDEF LINUX}
    sLocation := '/etc/';
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    SetLength(sLocation, MAX_PATH);
    SetLength(sLocation, GetWindowsDirectory(pchar(sLocation), MAX_PATH));
    sLocation := IncludeTrailingSlash(sLocation);
    if Win32Platform = VER_PLATFORM_WIN32_NT then begin
      sLocation := sLocation + 'system32\drivers\etc\'; {do not localize}
    end;
    {$ENDIF}
    sl := TStringList.Create;
    try
      sl.LoadFromFile(sLocation + 'services');  {do not localize}
      iPrev := 0;
      for idx := 0 to sl.Count - 1 do begin
        s := sl[idx];
        iPosSlash := IndyPos('/', s);   {do not localize}
        if (iPosSlash > 0) and (not (IndyPos('#', s) in [1..iPosSlash])) then begin
          i := iPosSlash;
          repeat
            dec(i);
            if i = 0 then begin
              raise EIdCorruptServicesFile.CreateFmt(RSCorruptServicesFile, [sLocation + 'services']); {do not localize}
            end;
          until s[i] in WhiteSpace;
          i := StrToInt(Copy(s, i+1, iPosSlash-i-1));
          if i <> iPrev then begin
            vidports.Add(s);
          end;
          iPrev := i;
        end;
      end;
    finally
      sl.Free;
    end;
  end;
  Result := vidports;
end;

function FetchCaseInsensitive(var AInput: string; const ADelim: string = IdFetchDelimDefault;
 const ADelete: Boolean = IdFetchDeleteDefault): String;
var
  LPos: integer;
begin
  if ADelim = #0 then begin
    // AnsiPos does not work with #0
    LPos := Pos(ADelim, AInput);
  end else begin
    //? may be AnsiUpperCase?
    LPos := IndyPos(UpperCase(ADelim), UpperCase(AInput));
  end;
  if LPos = 0 then begin
    Result := AInput;
    if ADelete then begin
      AInput := '';    {Do not Localize}
    end;
  end else begin
    Result := Copy(AInput, 1, LPos - 1);
    if ADelete then begin
      //This is faster than Delete(AInput, 1, LPos + Length(ADelim) - 1);
      AInput := Copy(AInput, LPos + Length(ADelim), MaxInt);
    end;
  end;
end;

function Fetch(var AInput: string; const ADelim: string = IdFetchDelimDefault;
 const ADelete: Boolean = IdFetchDeleteDefault;
 const ACaseSensitive: Boolean = IdFetchCaseSensitiveDefault): String;
var
  LPos: integer;
begin
  if ACaseSensitive then begin
    if ADelim = #0 then begin
      // AnsiPos does not work with #0
      LPos := Pos(ADelim, AInput);
    end else begin
      LPos := IndyPos(ADelim, AInput);
    end;
    if LPos = 0 then begin
      Result := AInput;
      if ADelete then begin
        AInput := '';    {Do not Localize}
      end;
    end
    else begin
      Result := Copy(AInput, 1, LPos - 1);
      if ADelete then begin
        //slower Delete(AInput, 1, LPos + Length(ADelim) - 1);
        AInput:=Copy(AInput, LPos + Length(ADelim), MaxInt);
      end;
    end;
  end else begin
    Result := FetchCaseInsensitive(AInput, ADelim, ADelete);
  end;
end;

{This searches an array of string for an occurance of SearchStr}
function PosInStrArray(const SearchStr: string; Contents: array of string; const CaseSensitive: Boolean=True): Integer;
begin
  for Result := Low(Contents) to High(Contents) do begin
    if CaseSensitive then begin
      if SearchStr = Contents[Result] then begin
        Exit;
      end;
    end else begin
      if ANSISameText(SearchStr, Contents[Result]) then begin
        Exit;
      end;
    end;
  end;  //for Result := Low(Contents) to High(Contents) do
  Result := -1;
end;

function IsCurrentThread(AThread: TThread): boolean;
begin
  result := AThread.ThreadID = GetCurrentThreadID;
end;

function IsNumeric(AChar: char): Boolean;
begin
  // Do not use IsCharAlpha or IsCharAlphaNumeric - they are Win32 routines
  Result := AChar in ['0'..'9'];    {Do not Localize}
end;

{$HINTS OFF}
function IsNumeric(const AString: string): Boolean;
var
  LCode: Integer;
  LVoid: Integer;
begin
  Val(AString, LVoid, LCode);
  Result := LCode = 0;
end;
{$HINTS ON}

function StrToDay(const ADay: string): Byte;
begin
  Result := Succ(PosInStrArray(Uppercase(ADay),
    ['SUN','MON','TUE','WED','THU','FRI','SAT']));   {do not localize}
end;

function StrToMonth(const AMonth: string): Byte;
begin
  Result := Succ(PosInStrArray(Uppercase(AMonth),
    ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC']));   {do not localize}
end;

function UpCaseFirst(const AStr: string): string;
begin
  Result := LowerCase(TrimLeft(AStr));
  if Result <> '' then begin   {Do not Localize}
    Result[1] := UpCase(Result[1]);
  end;
end;

function StartsWith(const ANSIStr, APattern : String) : Boolean;
begin
  Result := (ANSIStr<>'') and (IndyPos(APattern, UpperCase(ANSIStr)) = 1)  {do not localize}
    //tentative fix for a problem with Korean indicated by "SungDong Kim" <infi@acrosoft.pe.kr>
   {$IFNDEF DOTNET}
   //note that in DotNET, everything is MBCS
    and (ByteType(ANSIStr, 1) = mbSingleByte)
   {$ENDIF}
    ;
  //just in case someone is doing a recursive listing and there's a dir with the name total
end;


function DateTimeToGmtOffSetStr(ADateTime: TDateTime; SubGMT: Boolean): string;
var
  AHour, AMin, ASec, AMSec: Word;
begin
  if (ADateTime = 0.0) and SubGMT then
  begin
    Result := 'GMT'; {do not localize}
    Exit;
  end;
  DecodeTime(ADateTime, AHour, AMin, ASec, AMSec);
  Result := Format(' %0.2d%0.2d', [AHour, AMin]); {do not localize}
  if ADateTime < 0.0 then
  begin
    Result[1] := '-'; {do not localize}
  end
  else
  begin
    Result[1] := '+';  {do not localize}
  end;
end;

// Currently this function is not used
(*
procedure BuildMIMETypeMap(dest: TStringList);
{$IFDEF LINUX}
begin
  // TODO: implement BuildMIMETypeMap in Linux
  raise EIdException.Create('BuildMIMETypeMap not implemented yet.');    {Do not Localize}
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
var
  Reg: TRegistry;
  slSubKeys: TStringList;
  i: integer;
begin
  Reg := CreateTRegistry; try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKeyreadOnly('\MIME\Database\Content Type'); {do not localize}
    slSubKeys := TStringList.Create;
    try
      Reg.GetKeyNames(slSubKeys);
      reg.Closekey;
      for i := 0 to slSubKeys.Count - 1 do
      begin
        Reg.OpenKeyreadOnly('\MIME\Database\Content Type\' + slSubKeys[i]);  {do not localize}
        dest.Append(LowerCase(reg.ReadString('Extension')) + '=' + slSubKeys[i]); {do not localize}
        Reg.CloseKey;
      end;
    finally
      slSubKeys.Free;
    end;
  finally
    reg.free;
  end;
end;
{$ENDIF}
*)

function GetMIMETypeFromFile(const AFile: TFileName): string;
var
  MIMEMap: TIdMIMETable;
begin
  MIMEMap := TIdMimeTable.Create(true);
  try
    result := MIMEMap.GetFileMIMEType(AFile);
  finally
    MIMEMap.Free;
  end;
end;

function GmtOffsetStrToDateTime(S: string): TDateTime;
begin
  Result := 0.0;
  S := Copy(Trim(s), 1, 5);
  if Length(S) > 0 then
  begin
    if s[1] in ['-', '+'] then   {do not localize}
    begin
      try
        Result := EncodeTime(StrToInt(Copy(s, 2, 2)), StrToInt(Copy(s, 4, 2)), 0, 0);
        if s[1] = '-' then  {do not localize}
        begin
          Result := -Result;
        end;
      except
        Result := 0.0;
      end;
    end;
  end;
end;

function GMTToLocalDateTime(S: string): TDateTime;
var  {-Always returns date/time relative to GMT!!  -Replaces StrInternetToDateTime}
  DateTimeOffset: TDateTime;
begin
  Result := RawStrInternetToDateTime(S);
  if Length(S) < 5 then begin
    DateTimeOffset := 0.0
  end else begin
    DateTimeOffset := GmtOffsetStrToDateTime(S);
  end;
  {-Apply GMT offset here}
  if DateTimeOffset < 0.0 then begin
    Result := Result + Abs(DateTimeOffset);
  end else begin
    Result := Result - DateTimeOffset;
  end;
  // Apply local offset
  Result := Result + OffSetFromUTC;
end;


procedure Sleep(ATime: cardinal);
begin
  {$IFDEF LINUX}
  if (not Assigned(GStack)) then begin
    GStack := TIdStack.CreateStack;
  end;
  // what if the user just calls sleep? without doing anything...
  GStack.WSSelect(nil, nil, nil, ATime);
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Windows.Sleep(ATime);
  {$ENDIF}
end;

{ Takes a cardinal (DWORD)  value and returns the string representation of it's binary value}    {Do not Localize}
function IntToBin(Value: cardinal): string;
var
  i: Integer;
begin
  SetLength(result, 32);
  for i := 1 to 32 do begin
    if ((Value shl (i-1)) shr 31) = 0 then
      result[i] := '0'  {do not localize}
    else
      result[i] := '1'; {do not localize}
  end;
end;

function ByteToBin(Int: Byte): String; //from is in IdGlobal 64bit
var
  i: integer;
begin
  Result:= '';
  for i:= 7 downto 0 do
  Result:= Result + IntToStr((Int shr i) and 1);
end;


function BinToByte(Binary: String): Byte;
var
  i: integer;
begin
  Result:= 0;
  if Length(Binary) > 0 then
    for i:= 1 to Length(Binary) do begin
    result:= result + result +(ord(Binary[i]) and 1);
  end
end;


function CurrentProcessId: TIdPID;
begin
  {$IFDEF LINUX}
  Result := getpid;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Result := GetCurrentProcessID;
  {$ENDIF}
end;

{class function TIdSysVCL.StrToInt(const S: string;
  Default: Integer): Integer;
begin
  Result := SysUtils.StrToIntDef(Trim(S),Default);
end;}


function FTPMLSToGMTDateTime(const ATimeStamp : String):TDateTime;
var LYear, LMonth, LDay, LHour, LMin, LSec, LMSec : Integer;
    LBuffer : String;
begin
  Result := 0;
  LBuffer := ATimeStamp;
  if LBuffer <> '' then
  begin
  //  1234 56 78  90 12 34
  //  ---------- ---------
  //  1998 11 07  08 52 15
      LYear := StrToIntDef( Copy( LBuffer,1,4),0);
      LMonth := StrToIntDef(Copy(LBuffer,5,2),0);
      LDay := StrToIntDef(Copy(LBuffer,7,2),0);

      LHour := StrToIntDef(Copy(LBuffer,9,2),0);
      LMin := StrToIntDef(Copy(LBuffer,11,2),0);
      LSec := StrToIntDef(Copy(LBuffer,13,2),0);
      Fetch(LBuffer,'.');
      LMSec := StrToIntDef(LBuffer,0);
      Result := EncodeDate(LYear,LMonth,LDay);
      Result := Result + EncodeTime(LHour,LMin,LSec,LMSec);
  end;
end;

function FTPMLSToLocalDateTime(const ATimeStamp : String):TDateTime;
begin
  Result := 0;
  if ATimeStamp <> '' then
  begin
    Result := FTPMLSToGMTDateTime(ATimeStamp);
    // Apply local offset
    Result := Result + OffSetFromUTC;
  end;
end;

function FTPGMTDateTimeToMLS(const ATimeStamp : TDateTime; const AIncludeMSecs : Boolean=True): String;
var LYear, LMonth, LDay,
    LHour, LMin, LSec, LMSec : Word;

begin
  DecodeDate(ATimeStamp,LYear,LMonth,LDay);
  DecodeTime(ATimeStamp,LHour,LMin,LSec,LMSec);
  Result := Format('%4d%2d%2d%2d%2d%2d',[LYear,LMonth,LDay,LHour,LMin,LSec]);
  if AIncludeMSecs then
  begin
    if (LMSec <> 0) then
    begin
      Result := Result + Format('.%3d',[LMSec]);
    end;
  end;
  Result := StringReplace(Result,' ','0',[rfReplaceAll]);
end;
{
Note that MS-DOS displays the time in the Local Time Zone - MLISx commands use
stamps based on GMT)
}
function FTPLocalDateTimeToMLS(const ATimeStamp : TDateTime; const AIncludeMSecs : Boolean=True): String;
begin
  Result := FTPGMTDateTimeToMLS(ATimeStamp - OffSetFromUTC, AIncludeMSecs);
end;


function GetGMTDateByName(const AFileName : String) : TDateTime;
 {$IFDEF WIN32}
var LRec : TWin32FindData;
  LHandle : THandle;
   LTime : Integer;
 {$ENDIF}
 {$IFDEF LINUX}
var LRec : TStatBuf;
  LTime : Integer;
  LU : TUnixTime;
 {$ENDIF}
begin
  Result := -1;
  {$IFDEF DOTNET}
  if System.IO.File.Exists(AFileName) then
  begin
    Result := System.IO.File.GetLastWriteTimeUtc(AFileName).ToOADate;
  end;
  {$ENDIF}
  {$IFDEF WIN32}
  LHandle := FindFirstFile(PChar(AFileName), LRec);
  if LHandle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(LHandle);
    if (LRec.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
       FileTimeToDosDateTime(LRec.ftLastWriteTime, LongRec(LTime).Hi, LongRec(LTime).Lo);
       Result := FileDateToDateTime(LTime);
    end;
  end;
  {$ENDIF}
  {$IFDEF LINUX}
  if stat(PChar(AFileName), LRec) = 0 then
  begin
    LTime := LRec.st_mtime;
    gmtime_r(@LTime, LU);
    Result := EncodeDate(LU.tm_year + 1900, LU.tm_mon + 1, LU.tm_mday) +
              EncodeTime(LU.tm_hour, LU.tm_min, LU.tm_sec, 0);
  end;
  {$ENDIF}
end;

function UnixDateTimeToDelphiDateTime(UnixDateTime: Cardinal): TDateTime;
begin
   Result := (UnixDateTime / 86400) + UnixStartDate;
{
From: http://homepages.borland.com/efg2lab/Library/UseNet/1999/0309b.txt
 }
   //  Result := EncodeDate(1970, 1, 1) + (UnixDateTime / 86400); {86400=No. of secs. per day}
end;


{$IFDEF WIN32}
function GetClockValue : Int64;
var LFTime : TFileTime;
type
 TLong64Rec = record
   case LongInt of
   0 : (High : Cardinal;
       Low : Cardinal);
   1 : (Long : Int64);
 end;
begin
  Windows.GetSystemTimeAsFileTime(LFTime);
  TLong64Rec(Result).Low := LFTime.dwLowDateTime;
  TLong64Rec(Result).High := LFTime.dwHighDateTime;
end;
{$ENDIF}

{$IFDEF LINUX}
function GetClockValue : Int64;
var
  TheTms: tms;
begin
  //Is the following correct?
  Result := Libc.Times(TheTms);
end;
{$ENDIF}

function GetCurrentThreadHandle : THandle;
begin
  // Copied from Indy10 - works for Linux?
  Result := GetCurrentThreadID;
end;

// Arg1=EAX, Arg2=DL
function ROL(AVal: LongWord; AShift: Byte): LongWord;
asm
  mov  cl, dl
  rol  eax, cl
end;

function ROR(AVal: LongWord; AShift: Byte): LongWord;
asm
  mov  cl, dl
  ror  eax, cl
end;

procedure DebugOutput(const AText: string);
begin
  {$IFDEF LINUX}
  __write(stderr, AText, Length(AText));
  __write(stderr, EOL, Length(EOL));
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  OutputDebugString(PChar(AText));
  {$ENDIF}
end;

function InMainThread: boolean;
begin
  Result := GetCurrentThreadID = MainThreadID;
end;

{ TIdMimeTable }

{$IFDEF LINUX}
procedure LoadMIME(const AFileName : String; AMIMEList : TStringList);
var
  KeyList: TStringList;
  i, p: Integer;
  s, LMimeType, LExtension: String;
begin
  If FileExists(AFileName) Then  {Do not localize}
  Begin
    // build list from /etc/mime.types style list file
    // I'm lazy so I'm using a stringlist to load the file, ideally
    // this should not be done, reading the file line by line is better
    // I think - at least in terms of storage
    KeyList := TStringList.Create;
    try
      KeyList.LoadFromFile(AFileName); {Do not localize}
      for i := 0 to KeyList.Count -1 do begin
        s := KeyList[i];
        p := IndyPos('#', s); {Do not localize}
        if (p>0) then
        begin
          setlength(s, p-1);
        end;
        if s <> '' then
        begin {Do not localize}
          s := Trim(s);
          LMimeType := Fetch(s);
          if LMimeType <> '' then
          begin {Do not localize}
             while (s<>'') do
             begin {Do not localize}
               LExtension := Fetch(s);
               if LExtension <> '' then
               try {Do not localize}
                 AMIMEList.Values['.'+LExtension]:= LMimeType; {Do not localize}
               except
                 on EListError do {ignore} ;
               end;
             end;
          end;
        end;
      end;
    except
      on EFOpenError do {ignore} ;
    end;
  End;
end;
{$ENDIF}

procedure FillMimeTable(AMIMEList : TStringList);
{$IFDEF MSWINDOWS}
var
  reg: TRegistry;
  KeyList: TStringList;
  i: Integer;
  s: String;
{$ENDIF}
begin
  { Protect if someone is allready filled (custom MomeConst) }
  if not Assigned(AMIMEList) then
  begin
    Exit;
  end;
  if AMIMEList.Count > 0 then
  begin
    Exit;
  end;

  AMIMEList.Duplicates := dupError;

  with AMIMEList do
  begin
    {NOTE:  All of these strings should never be translated
    because they are protocol specific and are important for some
    web-browsers}

    { Audio }
    Add('.aiff=audio/x-aiff');    {Do not Localize}
    Add('.au=audio/basic');    {Do not Localize}
    Add('.mid=midi/mid');    {Do not Localize}
    Add('.mp3=audio/x-mpg');    {Do not Localize}
    Add('.m3u=audio/x-mpegurl');    {Do not Localize}
    Add('.qcp=audio/vnd.qcelp');    {Do not Localize}
    Add('.ra=audio/x-realaudio');    {Do not Localize}
    Add('.wav=audio/x-wav');    {Do not Localize}
    Add('.gsm=audio/x-gsm');    {Do not Localize}
    Add('.wax=audio/x-ms-wax');    {Do not Localize}
    Add('.wma=audio/x-ms-wma');    {Do not Localize}
    Add('.ram=audio/x-pn-realaudio');    {Do not Localize}
    Add('.mjf=audio/x-vnd.AudioExplosion.MjuiceMediaFile');    {Do not Localize}


    { Image }
    Add('.bmp=image/bmp');    {Do not Localize}
    Add('.gif=image/gif');    {Do not Localize}
    Add('.jpg=image/jpeg');    {Do not Localize}
    Add('.jpeg=image/jpeg');    {Do not Localize}
    Add('.jpe=image/jpeg');    {Do not Localize}
    Add('.pict=image/x-pict');    {Do not Localize}
    Add('.png=image/x-png');    {Do not Localize}
    Add('.svg=image/svg-xml');    {Do not Localize}
    Add('.tif=image/x-tiff');    {Do not Localize}
    Add('.rf=image/vnd.rn-realflash');    {Do not Localize}
    Add('.rp=image/vnd.rn-realpix');    {Do not Localize}
    Add('.ico=image/x-icon');    {Do not Localize}
    Add('.art=image/x-jg');    {Do not Localize}
    Add('.pntg=image/x-macpaint');    {Do not Localize}
    Add('.qtif=image/x-quicktime');    {Do not Localize}
    Add('.sgi=image/x-sgi');    {Do not Localize}
    Add('.targa=image/x-targa');    {Do not Localize}
    Add('.xbm=image/xbm');    {Do not Localize}
    Add('.psd=image/x-psd');    {Do not Localize}
    Add('.pnm=image/x-portable-anymap');    {Do not Localize}
    Add('.pbm=image/x-portable-bitmap');    {Do not Localize}
    Add('.pgm=image/x-portable-graymap');    {Do not Localize}
    Add('.ppm=image/x-portable-pixmap');    {Do not Localize}
    Add('.rgb=image/x-rgb');    {Do not Localize}
    Add('.xbm=image/x-xbitmap');    {Do not Localize}
    Add('.xpm=image/x-xpixmap');    {Do not Localize}
    Add('.xwd=image/x-xwindowdump');    {Do not Localize}


    { Text }
    Add('.323=text/h323');    {Do not Localize}
    Add('.xml=text/xml');    {Do not Localize}
    Add('.uls=text/iuls');    {Do not Localize}
    Add('.txt=text/plain');    {Do not Localize}
    Add('.rtx=text/richtext');    {Do not Localize}
    Add('.wsc=text/scriptlet');    {Do not Localize}
    Add('.rt=text/vnd.rn-realtext');    {Do not Localize}
    Add('.htt=text/webviewhtml');    {Do not Localize}
    Add('.htc=text/x-component');    {Do not Localize}
    Add('.vcf=text/x-vcard');    {Do not Localize}


    { video/ }
    Add('.avi=video/x-msvideo');    {Do not Localize}
    Add('.flc=video/flc');    {Do not Localize}
    Add('.mpeg=video/x-mpeg2a');    {Do not Localize}
    Add('.mov=video/quicktime');    {Do not Localize}
    Add('.rv=video/vnd.rn-realvideo');    {Do not Localize}
    Add('.ivf=video/x-ivf');    {Do not Localize}
    Add('.wm=video/x-ms-wm');    {Do not Localize}
    Add('.wmp=video/x-ms-wmp');    {Do not Localize}
    Add('.wmv=video/x-ms-wmv');    {Do not Localize}
    Add('.wmx=video/x-ms-wmx');    {Do not Localize}
    Add('.wvx=video/x-ms-wvx');    {Do not Localize}
    Add('.rms=video/vnd.rn-realvideo-secure');    {Do not Localize}
    Add('.asx=video/x-ms-asf-plugin');    {Do not Localize}
    Add('.movie=video/x-sgi-movie');    {Do not Localize}

    { application/ }
    Add('.wmd=application/x-ms-wmd');    {Do not Localize}
    Add('.wms=application/x-ms-wms');    {Do not Localize}
    Add('.wmz=application/x-ms-wmz');    {Do not Localize}
    Add('.p12=application/x-pkcs12');    {Do not Localize}
    Add('.p7b=application/x-pkcs7-certificates');    {Do not Localize}
    Add('.p7r=application/x-pkcs7-certreqresp');    {Do not Localize}
    Add('.qtl=application/x-quicktimeplayer');    {Do not Localize}
    Add('.rtsp=application/x-rtsp');    {Do not Localize}
    Add('.swf=application/x-shockwave-flash');    {Do not Localize}
    Add('.sit=application/x-stuffit');    {Do not Localize}
    Add('.tar=application/x-tar');    {Do not Localize}
    Add('.man=application/x-troff-man');    {Do not Localize}
    Add('.urls=application/x-url-list');    {Do not Localize}
    Add('.zip=application/x-zip-compressed');    {Do not Localize}
    Add('.cdf=application/x-cdf');    {Do not Localize}
    Add('.fml=application/x-file-mirror-list');    {Do not Localize}
    Add('.fif=application/fractals');    {Do not Localize}
    Add('.spl=application/futuresplash');    {Do not Localize}
    Add('.hta=application/hta');    {Do not Localize}
    Add('.hqx=application/mac-binhex40');    {Do not Localize}
    Add('.doc=application/msword');    {Do not Localize}
    Add('.pdf=application/pdf');    {Do not Localize}
    Add('.p10=application/pkcs10');    {Do not Localize}
    Add('.p7m=application/pkcs7-mime');    {Do not Localize}
    Add('.p7s=application/pkcs7-signature');    {Do not Localize}
    Add('.cer=application/x-x509-ca-cert');    {Do not Localize}
    Add('.crl=application/pkix-crl');    {Do not Localize}
    Add('.ps=application/postscript');    {Do not Localize}
    Add('.sdp=application/x-sdp');    {Do not Localize}
    Add('.setpay=application/set-payment-initiation');    {Do not Localize}
    Add('.setreg=application/set-registration-initiation');    {Do not Localize}
    Add('.smil=application/smil');    {Do not Localize}
    Add('.ssm=application/streamingmedia');    {Do not Localize}
    Add('.xfdf=application/vnd.adobe.xfdf');    {Do not Localize}
    Add('.fdf=application/vnd.fdf');    {Do not Localize}
    Add('.xls=application/x-msexcel');    {Do not Localize}
    Add('.sst=application/vnd.ms-pki.certstore');    {Do not Localize}
    Add('.pko=application/vnd.ms-pki.pko');    {Do not Localize}
    Add('.cat=application/vnd.ms-pki.seccat');    {Do not Localize}
    Add('.stl=application/vnd.ms-pki.stl');    {Do not Localize}
    Add('.rmf=application/vnd.rmf');    {Do not Localize}
    Add('.rm=application/vnd.rn-realmedia');    {Do not Localize}
    Add('.rnx=application/vnd.rn-realplayer');    {Do not Localize}
    Add('.rjs=application/vnd.rn-realsystem-rjs');    {Do not Localize}
    Add('.rmx=application/vnd.rn-realsystem-rmx');    {Do not Localize}
    Add('.rmp=application/vnd.rn-rn_music_package');    {Do not Localize}
    Add('.rsml=application/vnd.rn-rsml');    {Do not Localize}
    Add('.vsl=application/x-cnet-vsl');    {Do not Localize}
    Add('.z=application/x-compress');    {Do not Localize}
    Add('.tgz=application/x-compressed');    {Do not Localize}
    Add('.dir=application/x-director');    {Do not Localize}
    Add('.gz=application/x-gzip');    {Do not Localize}
    Add('.uin=application/x-icq');    {Do not Localize}
    Add('.hpf=application/x-icq-hpf');    {Do not Localize}
    Add('.pnq=application/x-icq-pnq');    {Do not Localize}
    Add('.scm=application/x-icq-scm');    {Do not Localize}
    Add('.ins=application/x-internet-signup');    {Do not Localize}
    Add('.iii=application/x-iphone');    {Do not Localize}
    Add('.latex=application/x-latex');    {Do not Localize}
    Add('.nix=application/x-mix-transfer');    {Do not Localize}

    { WAP }
    Add('.wbmp=image/vnd.wap.wbmp');    {Do not Localize}
    Add('.wml=text/vnd.wap.wml');    {Do not Localize}
    Add('.wmlc=application/vnd.wap.wmlc');    {Do not Localize}
    Add('.wmls=text/vnd.wap.wmlscript');    {Do not Localize}
    Add('.wmlsc=application/vnd.wap.wmlscriptc');    {Do not Localize}

    { WEB }
    Add('.css=text/css');    {Do not Localize}
    Add('.htm=text/html');    {Do not Localize}
    Add('.html=text/html');    {Do not Localize}
    Add('.shtml=server-parsed-html');    {Do not Localize}
    Add('.xml=text/xml');    {Do not Localize}
    Add('.sgm=text/sgml');    {Do not Localize}
    Add('.sgml=text/sgml');    {Do not Localize}
  end;
  {$IFDEF MSWINDOWS}
  // Build the file type/MIME type map
  Reg := CreateTRegistry; try
    KeyList := TStringList.create;
    try
      Reg.RootKey := HKEY_CLASSES_ROOT;
      if Reg.OpenKeyReadOnly('\') then  {do not localize}
      begin
        Reg.GetKeyNames(KeyList);
      //  reg.Closekey;
      end;
      // get a list of registered extentions
      for i := 0 to KeyList.Count - 1 do
      begin
        if Copy(KeyList[i], 1, 1) = '.' then   {do not localize}
        begin
          if reg.OpenKeyReadOnly(KeyList[i]) then
          begin
            s := Reg.ReadString('Content Type');  {do not localize}
{          if Reg.ValueExists('Content Type') then  {do not localize}
{          begin
            FFileExt.Values[KeyList[i]] := Reg.ReadString('Content Type');  {do not localize}
{          end;   }

{ for some odd reason, the code above was triggering a memory leak inside
the TIdHTTPServer demo program even though simply testing the MIME Table
alone did not cause a memory leak.  That is what I found in my leak testing.
Got me <shrug>.

}
            if Length(s) > 0 then
            begin
              AMIMEList.Values[KeyList[i]] := s;
            end;
//            reg.CloseKey;
          end;
        end;
      end;
      if Reg.OpenKeyreadOnly('\MIME\Database\Content Type') then {do not localize}
      begin
        // get a list of registered MIME types
        KeyList.Clear;

        Reg.GetKeyNames(KeyList);
  //      reg.Closekey;
        for i := 0 to KeyList.Count - 1 do
        begin
          if Reg.OpenKeyreadOnly('\MIME\Database\Content Type\' + KeyList[i]) then {do not localize}
          begin
            s := reg.ReadString('Extension');  {do not localize}
            AMIMEList.Values[s] := KeyList[i];
    //        Reg.CloseKey;
          end;
        end;
      end;
    finally
      KeyList.Free;
    end;
  finally
    reg.free;
  end;
{$ENDIF}
{$IFDEF LINUX}
  {/etc/mime.types is not present in all Linux distributions.
  It turns out that "/etc/htdig/mime.types" and "/etc/usr/share/webmin/mime.types"
  are in the same format as what Johannes Berg had expected.
  Just read those files for best coverage.  MIME Tables are not centrolized
  on Linux.
  }
  LoadMIME('/etc/mime.types', AMIMEList);
  LoadMIME('/etc/htdig/mime.types', AMIMEList);
  LoadMIME('/etc/usr/share/webmin/mime.types', AMIMEList);
{$ENDIF}
end;

procedure TIdMimeTable.AddMimeType(const Ext, MIMEType: string);
var
  LExt,
  LMIMEType: string;
begin
  { Check and fix extension }
  LExt := AnsiLowerCase(Ext);
  if Length(LExt) = 0 then
  begin
    raise EIdException.Create(RSMIMEExtensionEmpty);
  end
  else
  begin
   if LExt[1] <> '.' then    {Do not Localize}
   begin
     LExt := '.' + LExt;    {Do not Localize}
   end;
  end;
  { Check and fix MIMEType }
  LMIMEType := AnsiLowerCase(MIMEType);
  if Length(LMIMEType) = 0 then
    raise EIdException.Create(RSMIMEMIMETypeEmpty);

  if FFileExt.IndexOf(LExt) = -1 then
  begin
    FFileExt.Add(LExt);
    FMIMEList.Add(LMIMEType);
  end
  else
    raise EIdException.Create(RSMIMEMIMEExtAlreadyExists);
end;

procedure TIdMimeTable.BuildCache;
begin
  if Assigned(FOnBuildCache) then
  begin
    FOnBuildCache(Self);
  end
  else
  begin
    if FFileExt.Count = 0 then
    begin
      BuildDefaultCache;
    end;
  end;
end;

procedure TIdMimeTable.BuildDefaultCache;
{This is just to provide some default values only}
var LKeys : TStringList;

begin
  LKeys := TStringList.Create;
  try
    FillMIMETable(LKeys);
    LoadFromStrings(LKeys);
  finally
    FreeAndNil(LKeys);
  end;
end;

constructor TIdMimeTable.Create(Autofill: boolean);
begin
  FFileExt := TStringList.Create;
  FFileExt.Sorted := False;
  FMIMEList := TStringList.Create;
  FMIMEList.Sorted := False;
  if Autofill then begin
    BuildCache;
  end;
end;

destructor TIdMimeTable.Destroy;
begin
  FreeAndNil(FMIMEList);
  FreeAndNil(FFileExt);
  inherited Destroy;
end;

function TIdMimeTable.getDefaultFileExt(const MIMEType: string): String;
var
  Index : Integer;
  LMimeType: string;
begin
  Result := '';    {Do not Localize}
  LMimeType := AnsiLowerCase(MIMEType);
  Index := FMIMEList.IndexOf(LMimeType);
  if Index <> -1 then
  begin
    Result := FFileExt[Index];
  end
  else
  begin
    BuildCache;
    Index := FMIMEList.IndexOf(LMIMEType);
    if Index <> -1 then
      Result := FFileExt[Index];
  end;
end;

function TIdMimeTable.GetFileMIMEType(const AFileName: string): string;
var
  Index : Integer;
  LExt: string;
begin
  LExt := AnsiLowerCase(ExtractFileExt(AFileName));
  Index := FFileExt.IndexOf(LExt);
  if Index <> -1 then
  begin
    Result := FMIMEList[Index];
  end
  else
  begin
    BuildCache;
    Index := FFileExt.IndexOf(LExt);
    if Index = -1 then
    begin
      Result := 'application/octet-stream' {do not localize}
    end
    else
    begin
      Result := FMIMEList[Index];
    end;
  end;  { if .. else }
end;

procedure TIdMimeTable.LoadFromStrings(AStrings: TStrings;const MimeSeparator: Char = '=');    {Do not Localize}
var
  I   : Integer;
  Ext : string;
begin
  FFileExt.Clear;
  FMIMEList.Clear;
  for I := 0 to AStrings.Count - 1 do
  begin
    Ext := AnsiLowerCase(Copy(AStrings[I], 1, Pos(MimeSeparator, AStrings[I]) - 1));
    if Length(Ext) > 0 then
      if FFileExt.IndexOf(Ext) = -1 then
        AddMimeType(Ext, Copy(AStrings[I], Pos(MimeSeparator, AStrings[I]) + 1, Length(AStrings[I])));
  end;  { For I := }
end;



procedure TIdMimeTable.SaveToStrings(AStrings: TStrings;
  const MimeSeparator: Char);
var
  I : Integer;
begin
  AStrings.Clear;
  for I := 0 to FFileExt.Count - 1 do
    AStrings.Add(FFileExt[I] + MimeSeparator + FMIMEList[I]);
end;

procedure SetThreadPriority(AThread: TThread; const APriority: TIdThreadPriority; const APolicy: Integer = -MaxInt);
begin
  {$IFDEF LINUX}
  // Linux only allows root to adjust thread priorities, so we just ingnore this call in Linux?
  // actually, why not allow it if root
  // and also allow setting *down* threadpriority (anyone can do that)
  // note that priority is called "niceness" and positive is lower priority
  if (getpriority(PRIO_PROCESS, 0) < APriority) or (geteuid = 0) then begin
    setpriority(PRIO_PROCESS, 0, APriority);
  end;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  AThread.Priority := APriority;
  {$ENDIF}
end;

function SBPos(const Substr, S: string): Integer;
// Necessary because of "Compiler magic"
begin
  Result := Pos(Substr, S);
end;

function MemoryPos(const ASubStr: String; MemBuff: PChar; MemorySize: Integer): Integer;
var
  LSearchLength: Integer;
  LS1: Integer;
  LChar: Char;
  LPS,LPM: PChar;
begin
  LSearchLength := Length(ASubStr);
  if (LSearchLength = 0) or (LSearchLength > MemorySize) then begin
    Result := 0;
    Exit;
  end;

  LChar := PChar(Pointer(ASubStr))^; //first char
  LPS:=PChar(Pointer(ASubStr))+1;//tail string
  LPM:=MemBuff;
  LS1:=LSearchLength-1;
  LSearchLength := MemorySize-LS1;//MemorySize-LS+1
  if LS1=0 then begin //optimization for freq used LF
    while LSearchLength>0 do begin
      if LPM^= LChar then begin
        Result:=LPM-MemBuff+1;
        EXIT;
      end;
      inc(LPM);
      dec(LSearchLength);
    end;//while
  end else begin
    while LSearchLength>0 do begin
      if LPM^= LChar then begin
        inc(LPM);
        if CompareMem(LPM,LPS,LS1) then begin
          Result:=LPM-MemBuff;
          EXIT;
        end;
      end
      else begin
        inc(LPM);
      end;
      dec(LSearchLength);
    end;//while
  end;//if OneChar
  Result:=0;
End;

// Assembly is not allowed in Indy, however these routines can only be done in assembly because of
// the LOCK instruction. Both the Windows API and Kylix support these routines, but Windows 95
// fubars them up (Win98 works ok) so its necessary to have our own implementations.
function IndyInterlockedIncrement(var I: Integer): Integer;
asm
  MOV     EDX,1
  XCHG    EAX,EDX
  LOCK  XADD    [EDX],EAX
  INC     EAX
end;

function IndyInterlockedDecrement(var I: Integer): Integer;
asm
  MOV     EDX,-1
  XCHG    EAX,EDX
  LOCK  XADD    [EDX],EAX
  DEC     EAX
end;

function IndyInterlockedExchange(var A: Integer; B: Integer): Integer;
asm
  XCHG    [EAX],EDX
  MOV     EAX,EDX
end;

function IndyInterlockedExchangeAdd(var A: Integer; B: Integer): Integer;
asm
  XCHG    EAX,EDX
  LOCK  XADD    [EDX],EAX
end;

{$IFDEF LINUX}
function IndyGetHostName: string;
var
  LHost: array[1..255] of Char;
  i: LongWord;
begin
  //TODO: No need for LHost at all? Prob can use just Result
  if GetHostname(@LHost[1], 255) <> -1 then begin
    i := IndyPos(#0, LHost);
    SetLength(Result, i - 1);
    Move(LHost, Result[1], i - 1);
  end;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
function IndyGetHostName: string;
var
  i: LongWord;
begin
  SetLength(Result, MAX_COMPUTERNAME_LENGTH + 1);
  i := Length(Result);
  if GetComputerName(@Result[1], i) then begin
    SetLength(Result, i);
  end;
end;
{$ENDIF}


function IsValidIP(const S: String): Boolean;
var
  j, i: Integer;
  LTmp: String;
begin
  Result := True;
  LTmp := Trim(S);
  for i := 1 to 4 do begin
    j := StrToIntDef(Fetch(LTmp, '.'), -1);    {Do not Localize}
    Result := Result and (j > -1) and (j < 256);
    if NOT Result then begin
      Break;
    end;
  end;
end;


function IsLeadChar(ACh : Char):Boolean;
begin
  {$IFDEF DOTNET}
  result := false;
  {$ELSE}
  result := ACh in LeadBytes;
  {$ENDIF}
end;


// everething that does not start with '.' is treathed as hostname    {Do not Localize}

function IsHostname(const S: String): Boolean;
begin
  Result := ((IndyPos('.', S) = 0) or (S[1] <> '.')) and NOT IsValidIP(S);    {Do not Localize}
end;

function IsTopDomain(const AStr: string): Boolean;
Var
  i: Integer;
  S1,LTmp: String;
begin
  i := 0;

  LTmp := AnsiUpperCase(Trim(AStr));
  while IndyPos('.', LTmp) > 0 do begin    {Do not Localize}
    S1 := LTmp;
    Fetch(LTmp, '.');    {Do not Localize}
    i := i + 1;
  end;

  Result := ((Length(LTmp) > 2) and (i = 1));
  if Length(LTmp) = 2 then begin  // Country domain names
    S1 := Fetch(S1, '.');    {Do not Localize}
    // here will be the exceptions check: com.uk, co.uk, com.tw and etc.
    if LTmp = 'UK' then begin    {Do not Localize}
      if S1 = 'CO' then result := i = 2;    {Do not Localize}
      if S1 = 'COM' then result := i = 2;    {Do not Localize}
    end;

    if LTmp = 'TW' then begin    {Do not Localize}
      if S1 = 'CO' then result := i = 2;    {Do not Localize}
      if S1 = 'COM' then result := i = 2;    {Do not Localize}
    end;
  end;
end;

function IsDomain(const S: String): Boolean;
begin
  Result := NOT IsHostname(S) and (IndyPos('.', S) > 0) and NOT IsTopDomain(S);    {Do not Localize}
end;

function DomainName(const AHost: String): String;
begin
  result := Copy(AHost, IndyPos('.', AHost), Length(AHost));    {Do not Localize}
end;

function IsFQDN(const S: String): Boolean;
begin
  Result := IsHostName(S) and IsDomain(DomainName(S));
end;

// The password for extracting password.bin from password.zip is indyrules

function ProcessPath(const ABasePath: string;
  const APath: string;
  const APathDelim: string = '/'): string;    {Do not Localize}
// Dont add / - sometimes a file is passed in as well and the only way to determine is
// to test against the actual targets
var
  i: Integer;
  LPreserveTrail: Boolean;
  LWork: string;
begin
  if IndyPos(APathDelim, APath) = 1 then begin
    Result := APath;
  end else begin
    Result := '';    {Do not Localize}
    LPreserveTrail := (Copy(APath, Length(APath), 1) = APathDelim) or (Length(APath) = 0);
    LWork := ABasePath;
    // If LWork = '' then we just want it to be APath, no prefixed /    {Do not Localize}
    if (Length(LWork) > 0) and (Copy(LWork, Length(LWork), 1) <> APathDelim) then begin
      LWork := LWork + APathDelim;
    end;
    LWork := LWork + APath;
    if Length(LWork) > 0 then begin
      i := 1;
      while i <= Length(LWork) do begin
        if LWork[i] = APathDelim then begin
          if i = 1 then begin
            Result := APathDelim;
          end else if Copy(Result, Length(Result), 1) <> APathDelim then begin
            Result := Result + LWork[i];
          end;
        end else if LWork[i] = '.' then begin    {Do not Localize}
          // If the last character was a PathDelim then the . is a relative path modifier.
          // If it doesnt follow a PathDelim, its part of a filename
          if (Copy(Result, Length(Result), 1) = APathDelim) and (Copy(LWork, i, 2) = '..') then begin    {Do not Localize}
            // Delete the last PathDelim
            Delete(Result, Length(Result), 1);
            // Delete up to the next PathDelim
            while (Length(Result) > 0) and (Copy(Result, Length(Result), 1) <> APathDelim) do begin
              Delete(Result, Length(Result), 1);
            end;
            // Skip over second .
            Inc(i);
          end else begin
            Result := Result + LWork[i];
          end;
        end else begin
          Result := Result + LWork[i];
        end;
        Inc(i);
      end;
    end;
    // Sometimes .. semantics can put a PathDelim on the end
    // But dont modify if it is only a PathDelim and nothing else, or it was there to begin with
    if (Result <> APathDelim) and (Copy(Result, Length(Result), 1) = APathDelim)
     and (LPreserveTrail = False) then begin
      Delete(Result, Length(Result), 1);
    end;
  end;
end;

function ProcessPath2(const ABasePath: string;
  const APath: string;
  const APathDelim: string = '/'): string;    {Do not Localize}
// Dont add / - sometimes a file is passed in as well and the only way to determine is
// to test against the actual targets
var
  i: Integer;
  LPreserveTrail: Boolean;
  LWork: string;
begin
  if IndyPos(APathDelim, APath) = 1 then begin
    Result := APath;
  end else begin
    Result := '';    {Do not Localize}
    LPreserveTrail := (Copy(APath, Length(APath), 1) = APathDelim) or (Length(APath) = 0);
    LWork := ABasePath;
    // If LWork = '' then we just want it to be APath, no prefixed /    {Do not Localize}
    if (Length(LWork) > 0) and (Copy(LWork, Length(LWork), 1) <> APathDelim) then begin
      LWork := LWork + APathDelim;
    end;
    LWork := LWork + APath;
    if Length(LWork) > 0 then begin
      i := 1;
      while i <= Length(LWork) do begin
        if LWork[i] = APathDelim then begin
          if i = 1 then begin
            Result := APathDelim;
          end else if Copy(Result, Length(Result), 1) <> APathDelim then begin
            Result := Result + LWork[i];
          end;
        end else if LWork[i] = '.' then begin    {Do not Localize}
          // If the last character was a PathDelim then the . is a relative path modifier.
          // If it doesnt follow a PathDelim, its part of a filename
          if (Copy(Result, Length(Result), 1) = APathDelim) and (Copy(LWork, i, 2) = '..') then begin    {Do not Localize}
            // Delete the last PathDelim
            Delete(Result, Length(Result), 1);
            // Delete up to the next PathDelim
            while (Length(Result) > 0) and (Copy(Result, Length(Result), 1) <> APathDelim) do begin
              Delete(Result, Length(Result), 1);
            end;
            // Skip over second .
            Inc(i);
          end else begin
            Result := Result + LWork[i];
          end;
        end else begin
          Result := Result + LWork[i];
        end;
        Inc(i);
      end;
    end;
    // Sometimes .. semantics can put a PathDelim on the end
    // But dont modify if it is only a PathDelim and nothing else, or it was there to begin with
    if (Result <> APathDelim) and (Copy(Result, Length(Result), 1) = APathDelim)
     and (LPreserveTrail = False) then begin
      Delete(Result, Length(Result), 1);
    end;
  end;
end;

{ TIdLocalEvent }

constructor TIdLocalEvent.Create(const AInitialState: Boolean = False;
 const AManualReset: Boolean = False);
begin
  inherited Create(nil, AManualReset, AInitialState, '');    {Do not Localize}
end;

function TIdLocalEvent.WaitFor: TWaitResult;
begin
  Result := WaitFor(Infinite);
end;

function iif(ATest: Boolean; const ATrue: Integer; const AFalse: Integer): Integer;
begin
  if ATest then begin
    Result := ATrue;
  end else begin
    Result := AFalse;
  end;
end;

function iif(ATest: Boolean; const ATrue: string; const AFalse: string): string;
begin
  if ATest then begin
    Result := ATrue;
  end else begin
    Result := AFalse;
  end;
end;

function iif(ATest: Boolean; const ATrue: Boolean; const AFalse: Boolean): Boolean;
begin
  if ATest then begin
    Result := ATrue;
  end else begin
    Result := AFalse;
  end;
end;

function iif(ATest: Boolean; const ATrue: double; const AFalse: double): double;
begin
  if ATest then begin
    Result := ATrue;
  end else begin
    Result := AFalse;
  end;
end;

{ TIdReadMemoryStream }

procedure TIdReadMemoryStream.SetPointer(Ptr: Pointer; Size: Integer);
Begin
  inherited SetPointer(Ptr, Size);
  Seek(0,0);//Position:=0;
End;//SetPointer

function TIdReadMemoryStream.Write(const Buffer; Count: Integer): Longint;
begin
  Result := 0; //bytes actually written-NONE
End;//Write

// Universal "AnsiPosIdx" function. AnsiPosIdx&AnsiMemoryPos are just simple interfaces for it
function  AnsiPosIdx_ (const ASubStr: AnsiString; AStr: PChar; L1: Cardinal; AStartPos: Cardinal=0): Cardinal;
var
  L2: Cardinal;
  ByteType : TMbcsByteType;
  Str, SubStr, CurResult: PChar;
Begin
  Result:= 0; //not found
  //*L1 := Length(AStr);
  L2 := Length(ASubStr);
  if (L2=0) or (L2>L1) then Exit;
  Str:=Pointer(AStr);
  SubStr:=Pointer(ASubStr);
  //posIDX
  if AStartPos>0 then begin
    Str := Str + AStartPos - 1;
    L1  := L1 + 1 - AStartPos;
  end;//if
  if L1<=0 then EXIT;

  CurResult := StrPos(Str, SubStr);
  while (CurResult <> nil) and ((L1 - Cardinal(CurResult - Str)) >= L2) do begin //found and LenStr-Pos>=LenSubStr
    ByteType := StrByteType(Str, Integer(CurResult-Str));
{$IFDEF MSWINDOWS}
    if (ByteType <> mbTrailByte) and
      (Windows.CompareString(LOCALE_USER_DEFAULT, 0, CurResult, L2, SubStr, L2) = 2) then begin
      Result:=CurResult-Pointer(AStr)+1;
      Exit;
    end;//if
    if (ByteType = mbLeadByte) then Inc(Result);
{$ENDIF}
{$IFDEF LINUX}
    if (ByteType <> mbTrailByte) and
      (strncmp(CurResult, SubStr, L2) = 0) then begin
      Result:=CurResult-Pointer(AStr)+1;
      Exit;
    end;//if
{$ENDIF}
    Inc(Result);
    CurResult := StrPos(CurResult, SubStr);
  end;
End;//AnsiPosIdx

function  AnsiPosIdx(const ASubStr,AStr: AnsiString; AStartPos: Cardinal=0): Cardinal;
Begin
  Result:=AnsiPosIdx_(ASubStr, Pointer(AStr), Length(AStr), AStartPos);
End;//

function  AnsiMemoryPos(const ASubStr: String; MemBuff: PChar; MemorySize: Integer): Integer;
Begin
  Result:=AnsiPosIdx_(ASubStr, MemBuff, MemorySize, 0);
End;//


Function  PosIdx (const ASubStr,AStr: AnsiString; AStartPos: Cardinal): Cardinal;
var
  lpSubStr,lpS: PChar;
  LenSubStr,LenS: Integer;
  LChar: Char;
Begin
  LenSubStr:=Length(ASubStr);
  LenS:=Length(AStr);

  if (LenSubStr=0) or (LenSubStr>LenS) then begin
    Result:=0;//not found
    EXIT;
  end;//if

  lpSubStr:=Pointer(ASubStr);
  lpS:=Pointer(AStr);
  if AStartPos>0 then begin
    lpS:=lpS+AStartPos-1;
    LenS:=LenS+1-Integer(AStartPos);
  end;//if

  LChar :=lpSubStr[0];//first char
  lpSubStr:=lpSubStr  +1;//next char
  LenSubStr:=LenSubStr-1;//len w/o first char

  LenS:=LenS-LenSubStr; //Length(S)-Length(SubStr) +1(!) MUST BE >0
  if LenS<=0 then begin
    Result:=0;
    EXIT;
  end;//if

  while LenS>0 do begin
    if lpS^= LChar then begin
      inc(lpS);
      if CompareMem(lpS,lpSubStr,LenSubStr) then begin
        Result:=lpS-Pointer(AStr);//+1 already here
        EXIT;
      end;
    end
    else begin
      inc(lpS);
    end;
    dec(LenS);
  end;//while
  Result:=0;
End;//PosIdx

function MakeMethod (DataSelf, Code: Pointer): TMethod;
Begin
  Result.Data := DataSelf;
  Result.Code := Code;
End;//

// make sure that an RFC MsgID has angle brackets on it
function EnsureMsgIDBrackets(const AMsgID: String): String;
begin
  Result := AMsgID;
  if Length(Result) > 0 then begin
    if Result[1] <> #60 then begin
      Result := '<' + Result;
    end;
    if Result[Length(Result)] <> #62 then begin
      Result := Result + '>';
    end;
  end;
end;

const
  HexNumbers = '01234567890ABCDEF';  {Do not Localize}
  BinNumbers = '01'; {Do not localize}

function IsHex(const AChar : Char) : Boolean;
begin
  Result := (IndyPos(UpperCase(AChar),HexNumbers)>0);
end;

function IsBinary(const AChar : Char) : Boolean;
begin
  Result := (IndyPos(UpperCase(AChar),BinNumbers)>0);
end;


procedure IdDelete(var s: string; AOffset, ACount: Integer);
begin
  Delete(s, AOffset, ACount);
end;

procedure IdInsert(const Source: string; var S: string; Index: Integer);
begin
  Insert(Source,S,Index);
end;


function BinStrToInt(const ABinary: String): Integer;
var
  I: Integer;
//From: http://www.experts-exchange.com/Programming/Programming_Languages/Delphi/Q_20622755.html
begin
  Result := 0;
  for I := 1 to Length(ABinary) do
  begin
    Result := Result shl 1 or (Byte(ABinary[I]) and 1);
  end;
end;

function CharRange(const AMin, AMax : Char): String;
var i : Char;
begin
  Result := '';
  for i := Amin to AMax do
  begin
    Result := Result + i;
  end;
end;


Function CharToHex(const APrefix : String; const c : AnsiChar) : shortstring;
begin
  SetLength(Result,2);
  Result[1] := IdHexDigits[byte(c) shr 4];
  Result[2] := IdHexDigits[byte(c) AND $0F];
  Result := APrefix + Result;
end;


procedure CopyTIdByteArray(const ASource: array of Byte; const ASourceIndex: Integer;
    var VDest: array of Byte; const ADestIndex: Integer; const ALength: Integer);
begin
  Move(ASource[ASourceIndex], VDest[ADestIndex], ALength);
end;


procedure CopyTIdBytes(const ASource: TIdBytes; const ASourceIndex: Integer;
    var VDest: TIdBytes; const ADestIndex: Integer; const ALength: Integer);
begin
  //if this assert fails, then it indicates an attempted read-past-end-of-buffer.
  Assert(ALength<=Length(aSource));
  Move(ASource[ASourceIndex], VDest[ADestIndex], ALength);
end;

procedure CopyTIdWord(const ASource: Word; var VDest: TIdBytes; const ADestIndex: Integer);
begin
  Move(ASource, VDest[ADestIndex], SizeOf(Word));
end;

procedure CopyTIdString(const ASource: String; var VDest: TIdBytes;
    const ADestIndex: Integer; ALength: Integer = -1);
begin
  if ALength < 0 then begin
    ALength := Length(ASource);
  end;
  Move(ASource[1], VDest[ADestIndex], ALength);
end;

function BytesToWord(const AValue: TIdBytes; const AIndex: Integer = 0): Word;
begin
  Assert(Length(AValue) >= (SizeOf(Word)+AIndex));
  Result := PWord(@AValue[AIndex])^;
end;

function BytesToCardinal(const AValue: TIdBytes; const AIndex: Integer = 0): Cardinal;
begin
  Assert(Length(AValue) >= (SizeOf(Cardinal)+AIndex));
  Result := PCardinal(@AValue[AIndex])^;
end;

{function HostToNetwork(AValue: TIdIPv6Address): TIdIPv6Address;
var i : Integer;
begin
  for i := 0 to 7 do begin
    Result[i] := HostToNetwork(AValue[i]);
  end;
end;

function NetworkToHost(AValue: TIdIPv6Address): TIdIPv6Address;
var i : Integer;
begin
  for i := 0 to 7 do begin
    Result[i] := NetworkToHost(AValue[i]);
  end;
end;}
function GetMIMEDefaultFileExt(const MIMEType: string): string;
var
  MIMEMap: TIdMIMETable;
begin
  MIMEMap := TIdMimeTable.Create(true);
  try
    Result := MIMEMap.GetDefaultFileExt(MIMEType);
  finally
    MIMEMap.Free;
  end;
end;



function GetUniqueFileName(const APath, APrefix, AExt : String) : String;
var
  LNamePart : Cardinal;
  LFQE : String;
  LFName: String;
begin
  {$IFDEF LINUX}

  {
    man tempnam BUGS
      The precise meaning of `appropriate' is undefined;  it  is
       unspecified  how  accessibility  of  a directory is deter­
       mined.  Never use this function. Use tmpfile(3) instead.

    Alternative is to use tmpfile, but this creates the temp file.
       Indy is using this to retain it's logic and use of TMPDIR and
    p_dir in the function.
       If the caller passes an invalid path, the results are unpredicatable.
  }

  if APath = '' then begin
    Result := tempnam(nil, 'Indy');
  end
  else
  begin
    Result := tempnam(PChar(APath), 'Indy');
  end;

  {$ELSE}

  LFQE := AExt;

  // period is optional in the extension... force it
  if AExt <> '' then
  begin
    if AExt[1] <> '.' then
    begin
      LFQE := '.' + AExt;
    end;
  end;

  // validate path and add path delimiter before file name prefix
  if APath <> '' then begin
    if not DirectoryExists(APath) then
    begin
      LFName := APrefix;
    end
    else
    begin
      // uses the Indy function... not the Borland one
      LFName := IncludeTrailingPathDelimiter(APath) + APrefix;
    end;
  end
  else
  begin
    LFName := APrefix;
  end;

  LNamePart := gettickcount;            //Ticks;
  repeat
    Result := LFName + IntToHex(LNamePart, 8) + LFQE;

    if not FileExists(Result) then
    begin
      break;
    end
    else
    begin
      Inc(LNamePart);
    end;
  until False;

  {$ENDIF}
end;


function CharIsInSet(const AString: string; const ACharPos: Integer; const ASet:  String): Boolean;
begin
  //EIdException.IfTrue(ACharPos < 1, 'Invalid ACharPos in CharIsInSet.');{ do not localize }
  if ACharPos > Length(AString) then begin
    Result := False;
  end else begin
    Result := IndyPos( AString[ACharPos], ASet)>0;
  end;
end;

function CharIsInEOF(const AString: string; ACharPos: Integer): Boolean;
begin
  //EIdException.IfTrue(ACharPos < 1, 'Invalid ACharPos in CharIsInEOF.');{ do not localize }
  if ACharPos > Length(AString) then begin
    Result := False;
  end else begin
    Result := (AString[ACharPos] = CR) or (AString[ACharPos] = LF);
  end;
end;


procedure CopyBytesToHostWord(const ASource : TIdBytes; const ASourceIndex: Integer;
  var VDest : Word);
begin
  VDest := IdGlobal_max.BytesToWord(ASource, ASourceIndex);
  //VDest := GStack.NetworkToHost(VDest);
end;

procedure CopyBytesToHostCardinal(const ASource : TIdBytes; const ASourceIndex: Integer;
  var VDest : Cardinal);
begin
  VDest := IdGlobal_max.BytesToCardinal(ASource, ASourceIndex);
  //VDest := GStack.NetworkToHost(VDest);
end;

procedure CopyTIdNetworkWord(const ASource: Word;
    var VDest: TIdBytes; const ADestIndex: Integer);
var LWord : Word;
begin
  //LWord := GStack.HostToNetwork(ASource);
  CopyTIdWord(LWord,VDest,ADestIndex);
end;

procedure CopyTIdNetworkCardinal(const ASource: Cardinal;
    var VDest: TIdBytes; const ADestIndex: Integer);
var LCard : Cardinal;
begin
  //LCard := GStack.HostToNetwork(ASource);
  CopyTIdCardinal(LCard,VDest,ADestIndex);
end;


procedure CopyTIdLongWord(const ASource: LongWord;
    var VDest: TIdBytes; const ADestIndex: Integer);
{$IFDEF DotNet}
var LWord : TIdBytes;
{$ENDIF}
begin
  {$IFDEF DotNet}
  LWord := System.BitConverter.GetBytes(ASource);
  System.array.Copy(LWord, 0, VDest, ADestIndex, SizeOf(LongWord));
  {$ELSE}
  Move(ASource, VDest[ADestIndex], SizeOf(LongWord));
  {$ENDIF}
end;

procedure CopyTIdInt64(const ASource: Int64;
    var VDest: TIdBytes; const ADestIndex: Integer);
{$IFDEF DotNet}
var LWord : TIdBytes;
{$ENDIF}
begin
  {$IFDEF DotNet}
  LWord := System.BitConverter.GetBytes(ASource);
  System.array.Copy(LWord, 0, VDest, ADestIndex, SizeOf(Int64));
  {$ELSE}
  Move(ASource, VDest[ADestIndex], SizeOf(Int64));
  {$ENDIF}
end;

procedure CopyTIdIPV6Address(const ASource: TIdIPv6Address;
    var VDest: TIdBytes; const ADestIndex: Integer);
{$IFDEF DotNet}
var i : Integer;
{$ENDIF}
begin
  {$IFDEF DotNet}
  for i := 0 to 7 do begin
    CopyTIdWord(ASource[i], VDest, ADestIndex + (i * 2));
  end;
  {$ELSE}
  Move(ASource, VDest[ADestIndex], 16);
  {$ENDIF}
end;

procedure CopyTIdCardinal(const ASource: Cardinal;
    var VDest: TIdBytes; const ADestIndex: Integer);
{$IFDEF DotNet}
var LCard : TIdBytes;
{$ENDIF}
begin
  {$IFDEF DotNet}
  LCard := System.BitConverter.GetBytes(ASource);
  System.array.Copy(LCard, 0, VDest, ADestIndex, SizeOf(Cardinal));
  {$ELSE}
  Move(ASource, VDest[ADestIndex], SizeOf(Cardinal));
  {$ENDIF}
end;


procedure AppendBytes(var VBytes: TIdBytes; AAdd: TIdBytes);
var
  LOldLen: Integer;
begin
  LOldLen := Length(VBytes);
  SetLength(VBytes, LOldLen + Length(AAdd));
  CopyTIdBytes(AAdd, 0, VBytes, LOldLen, Length(AAdd));
end;

procedure AppendByte(var VBytes: TIdBytes; AByte: byte);
var
  LOldLen: Integer;
begin
  LOldLen := Length(VBytes);
  SetLength(VBytes, LOldLen + 1);
  VBytes[High(VBytes)] := AByte;
end;

procedure AppendString(var VBytes: TIdBytes; const AStr: String; ALength: Integer = -1);
var
  LOldLen: Integer;
begin
  if ALength < 0 then begin
    ALength := Length(AStr);
  end;
  LOldLen := Length(VBytes);
  SetLength(VBytes, LOldLen + ALength);
  CopyTIdString(AStr, VBytes, LOldLen, ALength);
end;

function TwoByteToWord(AByte1, AByte2: Byte): Word;
//Since Replys are returned as Strings, we need a routine to convert two
// characters which are a 2 byte U Int into a two byte unsigned Integer
var
  LWord: TIdBytes;
begin
  SetLength(LWord, 2);
  LWord[0] := AByte1;
  LWord[1] := AByte2;
  Result := BytesToWord(LWord);
//  Result := Word((AByte1 shl 8) and $FF00) or Word(AByte2 and $00FF);
end;

function TwoCharToWord(AChar1,AChar2: Char):Word;
//Since Replys are returned as Strings, we need a rountime to convert two
// characters which are a 2 byte U Int into a two byte unsigned integer
var
  LWord: TIdBytes;
begin
  SetLength(LWord,2);
  LWord[0] := Ord(AChar1);
  LWord[1] := Ord(AChar2);
  Result := BytesToWord(LWord);
//Result := Word((Ord(AChar1) shl 8) and $FF00) or Word(Ord(AChar2) and $00FF);
end;

procedure WordToTwoBytes(AWord : Word; ByteArray: TIdBytes; Index: integer);
begin
  //ByteArray[Index] := AWord div 256;
  //ByteArray[Index + 1] := AWord mod 256;
  ByteArray[Index + 1] := AWord div 256;
  ByteArray[Index] := AWord mod 256;
end;


function StartsWithACE(const ABytes: TIdBytes): Boolean;
var LS: string;
const DASH = ord('-');
begin
  Result := False;
  if Length(ABytes)>4 then
  begin
    if (ABytes[2]=DASH) and (ABytes[3]=DASH) then
    begin
      SetLength(LS,2);
      LS[1] := Char(ABytes[2]);
      LS[2] := Char(ABytes[3]);
      if PosInStrArray(LS,['bl','bq','dq','lq','mq','ra','wq','zq'],False)>-1 then {do not localize}
      begin
        Result := True;
      end;
    end;
  end;
end;

function TextIsSame(const A1: string; const A2: string): Boolean;
begin
  {$IFDEF DotNet}
  Result := A1.Compare(A1, A2, True) = 0;
  {$ELSE}
  Result := AnsiCompareText(A1, A2) = 0;
  {$ENDIF}
end;

function TextStartsWith(const S, SubS: string): Boolean;
{$IFNDEF DotNet}
const
  CSTR_EQUAL = 2;
var
  LLen: Integer;
{$ENDIF}
begin
  {$IFDEF DotNet}
  Result := System.String.Compare(S, 0, SubS, 0, Length(SubS), True) = 0;
  {$ELSE}
  LLen :=  Length(SubS);
  {$IFDEF MSWINDOWS}
  Result := (LLen <= Length(S)) and
    (CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE,
      PChar(S), LLen, PChar(SubS), LLen) = CSTR_EQUAL);
  {$ELSE}
  Result := Sys.AnsiCompareText(Copy(S, 1, LLen), SubS) = 0;
  {$ENDIF}
  {$ENDIF}
end;

function IndyLowerCase(const A1: string): string;
begin
  {$IFDEF DotNet}
  Result := A1.ToLower;
  {$ELSE}
  Result := AnsiLowerCase(A1);
  {$ENDIF}
end;

function IndyUpperCase(const A1: string): string;
begin
  {$IFDEF DotNet}
  Result := A1.ToUpper;
  {$ELSE}
  Result := AnsiUpperCase(A1);
  {$ENDIF}
end;

function IndyCompareStr(const A1: string; const A2: string): Integer;
begin
  {$IFDEF DotNet}
  Result := CompareStr(A1, A2);
  {$ELSE}
  Result := AnsiCompareStr(A1, A2);
  {$ENDIF}
end;

{$IFDEF LINUX}
function Ticks: Cardinal;
var                          
  tv: timeval;
begin
  gettimeofday(tv, nil);
  {$RANGECHECKS OFF}
  Result := int64(tv.tv_sec) * 1000 + tv.tv_usec div 1000;
  {
    I've implemented this correctly for now. I'll argue for using
    an int64 internally, since apparently quite some functionality
    (throttle, etc etc) depends on it, and this value may wrap
    at any point in time.
    For Windows: Uptime > 72 hours isn't really that rare any more,
    For Linux: no control over when this wraps.
     IdEcho has code to circumvent the wrap, but its not very good
    to have code for that at all spots where it might be relevant.

  }
end;
{$ENDIF}


// S.G. 27/11/2002: Changed to use high-performance counters as per suggested
// S.G. 27/11/2002: by David B. Ferguson (david.mcs@ns.sympatico.ca)
function Ticks: Cardinal;
var
  nTime, freq: Int64;
begin
  if Windows.QueryPerformanceFrequency(freq) then begin
    if Windows.QueryPerformanceCounter(nTime) then begin
      Result := Trunc((nTime / Freq) * 1000) and High(Cardinal)
    end else begin
      Result := Windows.GetTickCount;
    end;
  end else begin
    Result:= Windows.GetTickCount;
  end;
end;

procedure ToDo;
begin
  raise EIdException.Create('To do item undone.'); {do not localize}
end;


function StrToWord(const Value: String): Word;
begin
  if Length(Value)>1 then begin
    {$IFDEF DOTNET}
    Result := TwoCharToWord(Value[1],Value[2]);
    {$ELSE}
    Result := Word(pointer(@Value[1])^);
    {$ENDIF}
  end
  else
  begin
    Result := 0;
  end;
end;

function WordToStr(const Value: Word): String;
begin
  {$IFDEF DOTNET}
  Result := BytesToString(ToBytes(Value));
  {$ELSE}
  SetLength(Result, SizeOf(Value));
  Move(Value, Result[1], SizeOf(Value));
  {$ENDIF}
end;


function IsASCII(const AByte: Byte): Boolean;
begin
  Result := AByte <= $7F;
end;

function IsASCIILDH(const AByte: Byte): Boolean;
begin
  Result := True;
    //Verify the absence of non-LDH ASCII code points; that is, the
   //absence of 0..2C, 2E..2F, 3A..40, 5B..60, and 7B..7F.
   //Permissable chars are in this set
   //['-','0'..'9','A'..'Z','a'..'z']
    if AByte <= $2C then
    begin
      Result := False;
    end;
    if (AByte >= $2E) and (AByte <= $2F) then
    begin
      Result := False;
    end;
    if (AByte >= $3A) and (AByte <= $40) then
    begin
      Result := False;
    end;
    if (AByte >= $5B) and (AByte <= $60) then
    begin
      Result := False;
    end;
    if (AByte >= $7B) and (AByte <= $7F) then
    begin
      Result := False;
    end;
end;


function PosInSmallIntArray(const ASearchInt: SmallInt; AArray: array of SmallInt): Integer;
begin
  for Result := Low(AArray) to High(AArray) do begin
    if ASearchInt = AArray[Result] then begin
        Exit;
    end;
  end;
  Result := -1;
end;


function IPv6AddressToStr(const AValue: TIdIPv6Address): string;
var i:Integer;
begin
  Result := '';
  for i := 0 to 7 do begin
    Result := Result + ':' + IntToHex(AValue[i], 4);
  end;
end;


function IPv4MakeCardInRange(const AInt: Int64; const A256Power: Integer): Cardinal;
//Note that this function is only for stripping off some extra bits
//from an address that might appear in some spam E-Mails.
begin
  case A256Power of
    4: Result := (AInt and POWER_4);
    3: Result := (AInt and POWER_3);
    2: Result := (AInt and POWER_2);
  else
    Result := Lo(AInt and POWER_1);
  end;
end;


function OctalToInt64(const AValue: string): Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(AValue) do
  begin
    Result := (Result shl 3) +  StrToInt(copy(AValue, i, 1));
  end;
end;


function IPv4ToDWord(const AIPAddress: string; var VErr: Boolean): Cardinal; overload;
var
  LBuf, LBuf2: string;
  L256Power: Integer;
  LParts: Integer; //how many parts should we process at a time
begin
  // S.G. 11/8/2003: Added overflow checking disabling and change multiplys by SHLs.
  // Locally disable overflow checking so we can safely use SHL and SHR
  {$ifopt Q+} // detect previous setting
  {$define _QPlusWasEnabled}
  {$Q-}
  {$endif}
  VErr := True;
  L256Power := 4;
  LBuf2 := AIPAddress;
  Result := 0;
  repeat
    LBuf := Fetch(LBuf2,'.');
    if LBuf = '' then begin
      Break;
    end;
    //We do things this way because we have to treat
    //IP address parts differently than a whole number
    //and sometimes, there can be missing periods.
    if (LBuf2='') and (L256Power > 1) then begin
      LParts := L256Power;
      Result := Result shl (L256Power SHL 3);
//      Result := Result shl ((L256Power - 1) SHL 8);
    end
    else begin
      LParts := 1;
      result := result SHL 8;
    end;
    if (Copy(LBuf,1,2)=HEXPREFIX) then begin
      //this is a hexideciaml number
      if IsHexidecimalString(Copy(LBuf,3,MaxInt))=False then begin
        Exit;
      end
      else begin
        Result :=  Result + IPv4MakeCardInRange(StrToInt64Def(LBuf,0), LParts);
      end;
    end
    else
    begin
      if IsNumeric(LBuf) then begin
        if (LBuf[1]='0') and IsOctalString(LBuf) then begin
          //this is octal
          Result := Result + IPv4MakeCardInRange(OctalToInt64(LBuf),LParts);
        end
        else begin
          //this must be a decimal
          Result :=  Result + IPv4MakeCardInRange(StrToInt64Def(LBuf,0), LParts);
        end;
      end
      else begin
        //There was an error meaning an invalid IP address
        Exit;
      end;
    end;
    Dec(L256Power);
  until False;
  VErr := False;
  // Restore overflow checking
  {$ifdef _QPlusWasEnabled} // detect previous setting
  {$undef _QPlusWasEnabled}
  {$Q-}
  {$endif}
end;


function IPv4ToDWord(const AIPAddress: string): Cardinal; overload;
var
  LErr: Boolean;
begin
  Result := IPv4ToDWord(AIPAddress,LErr);
end;


//convert a dword into an IPv4 address in dotted form
function MakeDWordIntoIPv4Address(const ADWord: Cardinal): string;
begin
  Result := IntToStr((ADWord shr 24) and $FF) + '.';
  Result := Result + IntToStr((ADWord shr 16) and $FF) + '.';
  Result := Result + IntToStr((ADWord shr 8) and $FF) + '.';
  Result := Result + IntToStr(ADWord and $FF);
end;

function MakeCanonicalIPv4Address(const AAddr: string): string;
var LErr: Boolean;
  LIP: Cardinal;
begin
  LIP := IPv4ToDWord(AAddr,LErr);
  if LErr then begin
    Result := '';
  end else begin
    Result := MakeDWordIntoIPv4Address(LIP);
  end;
end;


function IsHexidecimal(AChar: Char): Boolean; overload;
begin
  Result := ((AChar >= '0') and (AChar <= '9')) {Do not Localize}
   or ((AChar >= 'A') and (AChar <= 'F')) {Do not Localize}
   or ((AChar >= 'a') and (AChar <= 'f')); {Do not Localize}
end;

function IsHexidecimalString(const AString: string): Boolean; overload;
var
  i: Integer;
begin
  Result := True;
  for i := 1 to Length(AString) do
  begin
    if IsHexidecimal(AString[i])=False then
    begin
      Result := False;
    end;
  end;
end;


function IsOctal(AChar: Char): Boolean;
begin
  Result := (AChar >= '0') and (AChar <= '7') {Do not Localize}
end;

function IsOctalString(const AString: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 1 to Length(AString) do
  begin
    if IsOctal(AString[i])=False then
    begin
      Result := False;
    end;
  end;
end;


function OrdFourByteToCardinal(AByte1, AByte2, AByte3, AByte4 : Byte): Cardinal;
var
  LCardinal: TIdBytes;
begin
  SetLength(LCardinal,4);
  LCardinal[0] := AByte1;
  LCardinal[1] := AByte2;
  LCardinal[2] := AByte3;
  LCardinal[3] := AByte4;
  Result := BytesToCardinal( LCardinal);
end;


function BytesToChar(const AValue: TIdBytes; const AIndex: Integer = 0): Char;
const
  //don't use SizeOf(Char) as it's different depending on OS
  cSizeOfChar=1;
begin
  Assert(Length(AValue) >= (cSizeOfChar+AIndex));
  {$IFDEF DotNet}
  //there is possibly a nicer way to do this
  //ToChar requires a 2-byte array
  SetLength(aBytes,2);
  aBytes[0]:=aValue[0];
  //to get mime working, may need something like this, ISO-8859-1 codepage
  //aEnc:=Encoding.GetEncoding(1252);//28591);
  //Result := aEnc.GetChars(aBytes,0,1)[0];
  Result := System.BitConverter.ToChar(ABytes, AIndex);
  {$ELSE}
  Result := Char(AValue[AIndex]);
  {$ENDIF}
end;

function BytesToInteger(const AValue: TIdBytes; const AIndex: Integer = 0): Integer;
begin
  Assert(Length(AValue) >= (SizeOf(Integer)+AIndex));
  {$IFDEF DotNet}
  Result := System.BitConverter.ToInt32(AValue, AIndex);
  {$ELSE}
  Result := PInteger(@AValue[AIndex])^;
  {$ENDIF}
end;

function BytesToInt64(const AValue: TIdBytes; const AIndex: Integer = 0): Int64;
begin
  Assert(Length(AValue) >= (SizeOf(Int64)+AIndex));
  {$IFDEF DotNet}
  Result := System.BitConverter.ToInt64(AValue, AIndex);
  {$ELSE}
  Result := PInt64(@AValue[AIndex])^;
  {$ENDIF}
end;


function BytesToShort(const AValue: TIdBytes; const AIndex: Integer = 0): Short;
begin
  Assert(Length(AValue) >= (SizeOf(Short)+AIndex));
  {$IFDEF DotNet}
  Result := System.BitConverter.ToInt16(AValue, AIndex);
  {$ELSE}
  Result := PSmallInt(@AValue[AIndex])^;
  {$ENDIF}
end;

function BytesToIPv6(const AValue: TIdBytes; const AIndex: Integer = 0): TIdIPv6Address;
{$IFDEF DotNet}
var i: Integer;
{$ENDIF}
begin
  Assert(Length(AValue) >= (AIndex+16));
  {$IFDEF DotNet}
  for i := 0 to 7 do
  begin
    Result[i]:= TwoByteToWord(AValue[(i*2)+AIndex], AValue[(i*2)+1+AIndex]);
  end;
  {$ELSE}
  Move(AValue[AIndex], Result, 16);
  {$ENDIF}
end;

//IPv4 address conversion
function ByteToHex(const AByte: Byte): string;
begin
  Result := IdHexDigits[AByte shr 4] + IdHexDigits[AByte and $F];
end;

function ByteToOctal(const AByte: Byte): string;
begin
  Result := IdOctalDigits[(AByte shr 6) and $7] +
            IdOctalDigits[(AByte shr 3) and $7] +
            IdOctalDigits[AByte and $7];

  if Result[1] <> '0' then
  begin
    Result := '0' + Result;
  end;
end;

function BytesToString(ABytes: TIdBytes; AStartIndex: Integer; AMaxCount: Integer): string;
begin
  if ((Length(ABytes) > 0) or (AStartIndex <> 0)) then begin
    EIdRangeException.Create('Index out of bounds.'); {do not localize}
  end;
  AMaxCount := Min(Length(ABytes) - AStartIndex, AMaxCount);
  // For VCL we just do a byte to byte copy with no translation. VCL uses ANSI or MBCS.
  // With MBCS we still map 1:1
  SetLength(Result, AMaxCount);
  if AMaxCount > 0 then begin
    Move(ABytes[AStartIndex], Result[1], AMaxCount);
  end;
end;

function ToBytes(
  const AValue: string;
  const AEncoding: TIdEncoding = enANSI
  ): TIdBytes; overload;
begin
  //EIdException.IfTrue(AEncoding = enDefault, 'No encoding specified.'); {do not localize}
  // For now we just ignore encodings in VCL
  SetLength(Result, Length(AValue));
  if AValue <> '' then begin
    Move(AValue[1], Result[0], Length(AValue));
  end;
end;

function ToBytes(const AValue: Char): TIdBytes; overload;
begin
  SetLength(Result, SizeOf(Byte));
  Result[0] := Byte(AValue);
end;

function ToBytes(const AValue: Int64): TIdBytes; overload;
begin
  SetLength(Result, SizeOf(Int64));
  PInt64(@Result[0])^:= AValue;
end;

function ToBytes(const AValue: Integer): TIdBytes; overload;
begin
  SetLength(Result, SizeOf(Integer));
  PInteger(@Result[0])^ := AValue;
end;

function ToBytes(const AValue: Cardinal): TIdBytes; overload;
begin
  SetLength(Result, SizeOf(Cardinal));
  PCardinal(@Result[0])^ := AValue;
end;

function ToBytes(const AValue: Short): TIdBytes; overload;
begin
  SetLength(Result, SizeOf(SmallInt));
  PSmallInt(@Result[0])^ := AValue;
end;

function ToBytes(const AValue: Word): TIdBytes; overload;
begin
  SetLength(Result, SizeOf(Word));
  PWord(@Result[0])^ := AValue;
end;

function ToBytes(const AValue: Byte): TIdBytes; overload;
begin
  SetLength(Result, SizeOf(Byte));
  Result[0] := AValue;
end;

function ToBytes(const AValue: TIdBytes; const ASize: Integer): TIdBytes; overload;
begin
  SetLength(Result, ASize);
  CopyTIdBytes(AValue, 0, Result, 0, ASize);
end;

function CardinalToFourChar(ACardinal : Cardinal): string;
begin
  Result := BytesToString(ToBytes(ACardinal));
end;

function RawToBytes(const AValue; const ASize: Integer): TIdBytes;
begin
  SetLength(Result, ASize);
  Move(AValue, Result[0], ASize);
end;


function ABNFToText(const AText : String) : String;
type TIdRuleMode = (data,rule,decimal,hex, binary);
var i : Integer;
    LR : TIdRuleMode;
    LNum : String;
begin
  LR :=data;
  Result := '';
  for i := 1 to Length(AText) do begin
    case LR of
      data :
        if (AText[i]='%') and (i < Length(AText)) then begin
          LR := rule;
        end
        else begin
          Result := Result + AText[i];
        end;
      rule :
        case AText[i] of
          'd','D' : LR := decimal;
          'x','X' : LR := hex;
          'b','B' : LR := binary;
        else begin
            LR := data;
            Result := Result + '%';
          end;
        end;
      decimal :
        If IsNumeric(AText[i]) then begin
          LNum := LNum + AText[i];
          if StrToInt(LNum)>$FF then begin
            IdDelete(LNum,Length(LNum),1);
            Result := Result + Char(StrToInt(LNum));
            LR := Data;
            Result := Result + AText[i];
          end;
        end
        else begin
          Result := Result + Char(StrToInt(LNum));
          LNum := '';
          if AText[i]<>'.' then begin
            LR := Data;
            Result := Result + AText[i];
          end;
        end;
      hex :
        If IsHex(AText[i]) and (Length(LNum)<2) then begin
          LNum := LNum + AText[i];
          if (StrToInt('$'+LNum)>$FF)  then begin
            IdDelete(LNum,Length(LNum),1);
            Result := Result + Char(StrToInt(LNum));
            LR := Data;
            Result := Result + AText[i];
          end;
        end
        else begin
          Result := Result + Char(StrToInt('$'+LNum));
          LNum := '';
          if AText[i]<>'.' then begin
            LR := Data;
            Result := Result + AText[i];
          end;
        end;
    binary :
        If IsBinary(AText[i]) and (Length(LNum)<8) then begin
          LNum := LNum + AText[i];
          if (BinStrToInt(LNum)>$FF) then begin
            IdDelete(LNum,Length(LNum),1);
            Result := Result + Char(BinStrToInt(LNum));
            LR := Data;
            Result := Result + AText[i];
          end;
        end
        else begin
          Result := Result + Char(StrToInt('$'+LNum));
          LNum := '';
          if AText[i]<>'.' then begin
            LR := Data;
            Result := Result + AText[i];
          end;
        end;
    end;
  end;
end;


initialization
  {$IFDEF LINUX}
  GStackClass := TIdStackLinux;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  ATempPath := TempPath;
  GStackClass := TIdStackWindows;
  {$ENDIF}
  // AnsiPos does not handle strings with #0 and is also very slow compared to Pos
  if LeadBytes = [] then begin
    IndyPos := SBPos;
  end else begin
    IndyPos := AnsiPos;
  end;

  SetLength(IndyFalseBoolStrs, 1);
  IndyFalseBoolStrs[Low(IndyFalseBoolStrs)] := 'FALSE';    {Do not Localize}
  SetLength(IndyTrueBoolStrs, 1);
  IndyTrueBoolStrs[Low(IndyTrueBoolStrs)] := 'TRUE';    {Do not Localize}

finalization
  FreeAndNil(FIdPorts);
  FreeAndNil(vidPorts);
end.

