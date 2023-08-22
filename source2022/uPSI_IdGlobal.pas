unit uPSI_IdGlobal;
{ enhanced with idGlobal_max with indy 9 and 10! V3.45 , locs=630
the unit is a sampler of network functions as maxbox runtime lib
dawdays: array[1..7] of string = 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'
    'Sat';   monthnames: to TEST , processpath name conflict -> processpath2

    MakeDWordIntoIPv4Address - ifthen int missing}

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
  TPSImport_IdGlobal = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdReadMemoryStream(CL: TPSPascalCompiler);
procedure SIRegister_TIdMimeTable(CL: TPSPascalCompiler);
procedure SIRegister_TIdLocalEvent(CL: TPSPascalCompiler);
procedure SIRegister_IdGlobal(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdGlobal_Routines(S: TPSExec);
procedure RIRegister_TIdReadMemoryStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMimeTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdLocalEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdGlobal(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,IdException
  ,SyncObjs
  ,IdGlobal_max
  ,IdStrings
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdGlobal]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdReadMemoryStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMemoryStream', 'TIdReadMemoryStream') do
  with CL.AddClassN(CL.FindClass('TCustomMemoryStream'),'TIdReadMemoryStream') do
  begin
    RegisterMethod('Procedure SetPointer( Ptr : Pointer; Size : Longint)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMimeTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdMimeTable') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdMimeTable') do begin
    RegisterMethod('Procedure BuildCache');
    RegisterMethod('Procedure AddMimeType( const Ext, MIMEType : string)');
    RegisterMethod('Function GetFileMIMEType( const AFileName : string) : string');
    RegisterMethod('Function GetDefaultFileExt( const MIMEType : string) : string');
    RegisterMethod('Procedure LoadFromStrings( AStrings : TStrings; const MimeSeparator : Char)');
    RegisterMethod('Procedure SaveToStrings( AStrings : TStrings; const MimeSeparator : Char)');
    RegisterMethod('Constructor Create( Autofill : boolean)');
    RegisterMethod('Procedure Free');
    RegisterProperty('OnBuildCache', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdLocalEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEvent', 'TIdLocalEvent') do
  with CL.AddClassN(CL.FindClass('TEvent'),'TIdLocalEvent') do begin
    RegisterMethod('Constructor Create( const AInitialState : Boolean; const AManualReset : Boolean)');
    RegisterMethod('Function WaitFor1 : TWaitResult;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdGlobal(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdFileName', 'WideString');
  CL.AddTypeS('TIdFileName', 'String');
  CL.AddTypeS('TBytes', 'array of Byte');
  CL.AddTypeS('TIdBytes', 'TBytes');
 CL.AddTypeS('TIdEncoding', '( enDefault, enANSI, enUTF8 )');
  CL.AddTypeS('Short', 'Smallint');
   CL.AddTypeS('THandle', 'LongWord');
  CL.AddTypeS('THandle', 'Integer');
  //CL.AddTypeS('TBytes', 'array of Byte');
  CL.AddTypeS('TIdIPv6Address', 'array [0..7] of word');
  // CL.AddTypeS('TIdMaxLineAction', '( maException, maSplit )');
    CL.AddTypeS('TIdPort', 'Integer');
  CL.AddTypeS('TIdReadLnFunction', 'Function  : string');
  CL.AddTypeS('TIdOSType', '( otUnknown, otLinux, otWindows )');
 CL.AddConstantN('IdTimeoutDefault','LongInt').SetInt( - 1);
 CL.AddConstantN('IdTimeoutInfinite','LongInt').SetInt( - 2);
 CL.AddConstantN('IdFetchDelimDefault','String').SetString( ' ');
 // CL.AddConstantN('UNIXSTARTDATE','TIdDateTime').SetExtended(25569.0);
 CL.AddConstantN('TIME_BASEDATE','LongInt').SetInt( 2);
 //CL.AddConstantN('IdFetchDeleteDefault','Boolean').BoolToStr( true);
 //CL.AddConstantN('IdFetchCaseSensitiveDefault','Boolean')BoolToStr( true);
 CL.AddConstantN('CHAR0','Char').SetString( #0);
 CL.AddConstantN('BACKSPACE','Char').SetString( #8);
 CL.AddConstantN('LF','Char').SetString( #10);
 CL.AddConstantN('CR','Char').SetString( #13);
 CL.AddConstantN('EOL','Char').SetString( #13+#10);
 CL.AddConstantN('TAB','Char').SetString( #9);
 CL.AddConstantN('CHAR32','Char').SetString( #32);
 //CL.AddConstantN('sLineBreak','EOL').SetString(#13+#10);
 CL.AddConstantN('LWS','LongInt').Value.ts32 := ord(TAB) or ord(CHAR32);
 CL.AddConstantN('GPathDelim','String').SetString( '/');
 //CL.AddConstantN('GOSType','').SetString('otLinux');
 CL.AddConstantN('INFINITE','LongWord').SetUInt( LongWord ( $FFFFFFFF ));
 CL.AddConstantN('tpIdle','LongInt').SetInt( 19);
 CL.AddConstantN('tpLowest','LongInt').SetInt( 12);
 CL.AddConstantN('tpLower','LongInt').SetInt( 6);
 CL.AddConstantN('tpNormal','LongInt').SetInt( 0);
 CL.AddConstantN('tpHigher','LongInt').SetInt( - 7);
 CL.AddConstantN('tpHighest','LongInt').SetInt( - 13);
 CL.AddConstantN('tpTimeCritical','LongInt').SetInt( - 20);
 CL.AddConstantN('GPathDelim','String').SetString( '\');
 //CL.AddConstantN('GOSType','').SetString('otWindows');
  CL.AddTypeS('THandle', 'LongWord');
  //CL.AddTypeS('TIdThreadPriority', 'TThreadPriority');
  CL.AddTypeS('TIdMaxLineAction', '( maException, maSplit )');
  CL.AddTypeS('TIdReadLnFunction', 'Function  : string');
  CL.AddTypeS('TIdReuseSocket', '( rsOSDependent, rsTrue, rsFalse )');
  SIRegister_TIdLocalEvent(CL);
  SIRegister_TIdMimeTable(CL);
  SIRegister_TIdReadMemoryStream(CL);
  CL.AddTypeS('TIdCharSet', '( csGB2312, csBig5, csIso2022jp, csEucKR, csIso88591 )');
  //CL.AddTypeS('PByte', '^Byte // will not work');
  //CL.AddTypeS('PWord', '^Word // will not work');
  //TIdDateTimeBase = TDateTime;!
   //TIdDateTime = TIdDateTimeBase;
  CL.AddTypeS('TIdIPVersion', '( Id_IPv4, Id_IPv6 )');
  CL.AddTypeS('TIdPID', 'Integer');
  CL.AddTypeS('TIdPID', 'LongWord');
  CL.AddTypeS('TIdWin32Type', '( Win32s, WindowsNT40PreSP6Workstation, WindowsN'
   +'T40PreSP6Server, WindowsNT40PreSP6AdvancedServer, WindowsNT40Workstation, '
   +'WindowsNT40Server, WindowsNT40AdvancedServer, Windows95, Windows95OSR2, Wi'
   +'ndows98, Windows98SE, Windows2000Pro, Windows2000Server, Windows2000Advanc'
   +'edServer, WindowsMe, WindowsXPPro, Windows2003Server, Windows2003AdvancedServer )');
  {CL.AddTypeS('TIdWin32Type', '( Win32s, WindowsNT40, Windows95, Windows95OSR2,'
   +' Windows98, Windows98SE, Windows2000, WindowsMe, WindowsXP )');}
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdFailedToRetreiveTimeZoneInfo');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdCorruptServicesFile');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdExtensionAlreadyExists');
 CL.AddDelphiFunction('Function AnsiMemoryPos( const ASubStr : String; MemBuff : PChar; MemorySize : Integer) : Integer');
 //CL.AddDelphiFunction('Function AnsiPosIdx( const ASubStr, AStr : AnsiString; AStartPos : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function AnsiSameText( const S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function BinStrToInt( const ABinary : String) : Integer');
 CL.AddDelphiFunction('function ABNFToText(const AText : String) : String');
 CL.AddDelphiFunction('Procedure AppendBytes( var VBytes : TIdBytes; AAdd : TIdBytes)');
 CL.AddDelphiFunction('Procedure AppendByte( var VBytes : TIdBytes; AByte : byte)');
 CL.AddDelphiFunction('Procedure AppendString( var VBytes : TIdBytes; const AStr : String; ALength : Integer)');
 CL.AddDelphiFunction('Function BytesToString( ABytes : TIdBytes; AStartIndex : Integer; AMaxCount : Integer) : string;');
 CL.AddDelphiFunction('Function BytesToChar( const AValue : TIdBytes; const AIndex : Integer) : Char');
 CL.AddDelphiFunction('Function BytesToShort( const AValue : TIdBytes; const AIndex : Integer) : Short');
 CL.AddDelphiFunction('Function BytesToInteger( const AValue : TIdBytes; const AIndex : Integer) : Integer');
 CL.AddDelphiFunction('Function BytesToInt64( const AValue : TIdBytes; const AIndex : Integer) : Int64');
 CL.AddDelphiFunction('Function BytesToIPv6( const AValue : TIdBytes; const AIndex : Integer) : TIdIPv6Address');
 CL.AddDelphiFunction('Function BytesToCardinal( const AValue : TIdBytes; const AIndex : Integer) : Cardinal');
 CL.AddDelphiFunction('Function BytesToWord( const AValue : TIdBytes; const AIndex : Integer) : Word');
  CL.AddDelphiFunction('Function CompareDateTime( const ADateTime1, ADateTime2 : TDateTime) : Integer');
  CL.AddDelphiFunction('Procedure CopyBytesToHostLongWord( const ASource : TIdBytes; const ASourceIndex : Integer; var VDest : LongWord)');
 CL.AddDelphiFunction('Procedure CopyBytesToHostWord( const ASource : TIdBytes; const ASourceIndex : Integer; var VDest : Word)');
 CL.AddDelphiFunction('Procedure CopyTIdNetworkLongWord( const ASource : LongWord; var VDest : TIdBytes; const ADestIndex : Integer)');
 CL.AddDelphiFunction('Procedure CopyTIdNetworkWord( const ASource : Word; var VDest : TIdBytes; const ADestIndex : Integer)');
 //CL.AddDelphiFunction('Function CopyFileTo( const Source, Destination : TIdFileName) : Boolean');
 CL.AddDelphiFunction('Procedure CommaSeparatedToStringList( AList : TStrings; const Value : string)');
 CL.AddDelphiFunction('Function CopyFileTo( const Source, Destination : string) : Boolean');
 CL.AddDelphiFunction('Function ByteToHex( const AByte : Byte) : string');
 CL.AddDelphiFunction('Function ByteToOctal( const AByte : Byte) : string');
 CL.AddDelphiFunction('Procedure CopyTIdBytes( const ASource : TIdBytes; const ASourceIndex : Integer; var VDest : TIdBytes; const ADestIndex : Integer; const ALength : Integer)');
 CL.AddDelphiFunction('Procedure CopyTIdByteArray( const ASource : array of Byte; const ASourceIndex : Integer; var VDest : array of Byte; const ADestIndex : Integer; const ALength : Integer)');
 CL.AddDelphiFunction('Procedure CopyTIdWord( const ASource : Word; var VDest : TIdBytes; const ADestIndex : Integer)');
 CL.AddDelphiFunction('Procedure CopyTIdLongWord( const ASource : LongWord; var VDest : TIdBytes; const ADestIndex : Integer)');
 CL.AddDelphiFunction('Procedure CopyTIdCardinal( const ASource : Cardinal; var VDest : TIdBytes; const ADestIndex : Integer)');
 CL.AddDelphiFunction('Procedure CopyTIdInt64( const ASource : Int64; var VDest : TIdBytes; const ADestIndex : Integer)');
 CL.AddDelphiFunction('Procedure CopyTIdIPV6Address( const ASource : TIdIPv6Address; var VDest : TIdBytes; const ADestIndex : Integer)');
 CL.AddDelphiFunction('Procedure CopyTIdString( const ASource : String; var VDest : TIdBytes; const ADestIndex : Integer; ALength : Integer)');

 CL.AddDelphiFunction('Procedure FreeAndNil(var Obj:TObject)');
 CL.AddDelphiFunction('Function GetFileCreationTime( const Filename : string) : TDateTime');
 CL.AddDelphiFunction('Function GetInternetFormattedFileTimeStamp( const AFilename : String) : String');
 CL.AddDelphiFunction('Function BreakApart( BaseString, BreakString : string; StringList : TStrings) : TStrings');
 CL.AddDelphiFunction('Function BinStrToInt( const ABinary : String) : Integer');
 //CL.AddDelphiFunction('Function BreakApart( BaseString, BreakString : string; StringList : TIdStrings) : TIdStrings');
 CL.AddDelphiFunction('Function CardinalToFourChar( ACardinal : LongWord) : string');
 CL.AddDelphiFunction('Function CharRange( const AMin, AMax : Char) : String');
  CL.AddDelphiFunction('Function CharIsInSet( const AString : string; const ACharPos : Integer; const ASet : String) : Boolean');
 CL.AddDelphiFunction('Function CharIsInEOF( const AString : string; ACharPos : Integer) : Boolean');
 CL.AddDelphiFunction('function OrdFourByteToCardinal(AByte1, AByte2, AByte3, AByte4 : Byte): Cardinal');
 CL.AddDelphiFunction('Function LongWordToFourChar( ACardinal : LongWord) : string');
 //CL.AddDelphiFunction('Function CharToHex( const APrefix : String; const c : AnsiChar) : shortstring');
 //CL.AddDelphiFunction('Procedure CommaSeparatedToStringList( AList : TIdStrings; const Value : string)');
  CL.AddDelphiFunction('Procedure FillBytes( var VBytes : TIdBytes; const ACount : Integer; const AValue : Byte)');
 CL.AddDelphiFunction('Function CurrentThreadId : TIdPID');
 //CL.AddDelphiFunction('Function GetThreadHandle( AThread : TIdNativeThread) : THandle');
  CL.AddDelphiFunction('Function CurrentProcessId : TIdPID');
  CL.AddDelphiFunction('Function GetCurrentProcessId : TIdPID');
 CL.AddDelphiFunction('Function GetProcessId : TIdPID');
 CL.AddDelphiFunction('Function GetCurrentThreadHandle : THandle');
 CL.AddDelphiFunction('Function DateTimeToGmtOffSetStr( ADateTime : TDateTime; SubGMT : Boolean) : string');
 CL.AddDelphiFunction('Function DateTimeGMTToHttpStr( const GMTValue : TDateTime) : String');
 CL.AddDelphiFunction('Function DateTimeToInternetStr( const Value : TDateTime; const AIsGMT : Boolean) : String');
 CL.AddDelphiFunction('Procedure DebugOutput( const AText : string)');
 CL.AddDelphiFunction('Function DomainName( const AHost : String) : String');
 CL.AddDelphiFunction('Function EnsureMsgIDBrackets( const AMsgID : String) : String');
 CL.AddDelphiFunction('Function Fetch( var AInput : string; const ADelim : string; const ADelete : Boolean; const ACaseSensitive : Boolean) : string');
 CL.AddDelphiFunction('Function FetchCaseInsensitive( var AInput : string; const ADelim : string; const ADelete : Boolean) : string');
 CL.AddDelphiFunction('Function FileSizeByName( const AFilename : string) : Longint');
 //  const AFile TFileName = type string;
 CL.AddDelphiFunction('Function GetMIMETypeFromFile( const AFile : string) : string');
 CL.AddDelphiFunction('Function GetSystemLocale : TIdCharSet');
 //CL.AddDelphiFunction('Function GetThreadHandle( AThread : TThread) : THandle');
 CL.AddDelphiFunction('Function GetTickCount : Cardinal');
 CL.AddDelphiFunction('Function GetTickDiff( const AOldTickCount, ANewTickCount : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function GmtOffsetStrToDateTime( S : string) : TDateTime');
 CL.AddDelphiFunction('Function GMTToLocalDateTime( S : string) : TDateTime');
 CL.AddDelphiFunction('Function IdPorts2 : TStringList');
 CL.AddDelphiFunction('Function iif1( ATest : Boolean; const ATrue : Integer; const AFalse : Integer) : Integer;');
 CL.AddDelphiFunction('Function iif2( ATest : Boolean; const ATrue : string; const AFalse : string) : string;');
 CL.AddDelphiFunction('Function iif3( ATest : Boolean; const ATrue : Boolean; const AFalse : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function IfThenInt( AValue : Boolean; const ATrue : integer; AFalse : integer): integer;');
 CL.AddDelphiFunction('Function IfThenDouble( AValue : Boolean; const ATrue : double; AFalse : double): double;');
 CL.AddDelphiFunction('Function IfThenBool( AValue : Boolean; const ATrue : boolean; AFalse : boolean): boolean;');

 CL.AddDelphiFunction('Function IncludeTrailingSlash( const APath : string) : string');
 CL.AddDelphiFunction('Function IntToBin( Value : cardinal) : string');
 CL.AddDelphiFunction('Function ByteToBin(Int: Byte): String;'); //from is in IdGlobal 64bit
 CL.AddDelphiFunction('Function BinToByte(Binary: String): Byte;');

 CL.AddDelphiFunction('Function IndyGetHostName : string');
 CL.AddDelphiFunction('Function GetHostName : string');
 CL.AddDelphiFunction('Function GetMIMETypeFromFile( const AFile : TIdFileName) : string');
 CL.AddDelphiFunction('Function GetMIMEDefaultFileExt( const MIMEType : string) : TIdFileName');
 CL.AddDelphiFunction('Function GetGMTDateByName( const AFileName : TIdFileName) : TDateTime');
  CL.AddDelphiFunction('Function GetClockValue : Int64');
 //back to TDateTime from TIdDateTime
 CL.AddDelphiFunction('Function FTPMLSToGMTDateTime( const ATimeStamp : String) : TDateTime');
 CL.AddDelphiFunction('Function FTPMLSToLocalDateTime( const ATimeStamp : String) : TDateTime');
 CL.AddDelphiFunction('Function FTPGMTDateTimeToMLS( const ATimeStamp : TDateTime; const AIncludeMSecs : Boolean) : String');
 CL.AddDelphiFunction('Function FTPLocalDateTimeToMLS( const ATimeStamp : TDateTime; const AIncludeMSecs : Boolean) : String');
 CL.AddDelphiFunction('Function IndyInterlockedIncrement( var I : Integer) : Integer');
 CL.AddDelphiFunction('Function IndyInterlockedDecrement( var I : Integer) : Integer');
 CL.AddDelphiFunction('Function IndyInterlockedExchange( var A : Integer; B : Integer) : Integer');
 CL.AddDelphiFunction('Function IndyInterlockedExchangeAdd( var A : Integer; B : Integer) : Integer');
 CL.AddDelphiFunction('Function IndyStrToBool( const AString : String) : Boolean');
 //CL.AddDelphiFunction('Function IsCurrentThread( AThread : TThread) : boolean');
 CL.AddDelphiFunction('Function IsDomain( const S : String) : Boolean');
 CL.AddDelphiFunction('Function IsFQDN( const S : String) : Boolean');
 CL.AddDelphiFunction('Function IsHostname( const S : String) : Boolean');
 CL.AddDelphiFunction('Function IsNumeric( AChar : Char) : Boolean;');
 CL.AddDelphiFunction('Function IsNumeric2( const AString : string) : Boolean;');
 CL.AddDelphiFunction('Function IsTopDomain( const AStr : string) : Boolean');
 CL.AddDelphiFunction('Function IsValidIP( const S : String) : Boolean');
 CL.AddDelphiFunction('Function InMainThread : boolean');
 CL.AddDelphiFunction('Function IdGetDefaultCharSet : TIdCharSet');
 CL.AddDelphiFunction('Function IsLeadChar( ACh : Char) : Boolean');
  CL.AddDelphiFunction('Function IsASCII( const AByte : Byte) : Boolean;');
 //CL.AddDelphiFunction('Function IsASCII2( const ABytes : TIdBytes) : Boolean;');
 CL.AddDelphiFunction('Function IsASCIILDH( const AByte : Byte) : Boolean;');
 //CL.AddDelphiFunction('Function IsASCIILDH2( const ABytes : TIdBytes) : Boolean;');
 CL.AddDelphiFunction('Function IsHex( AChar : Char) : Boolean;');
 CL.AddDelphiFunction('Function IsHexString(const AString: string): Boolean;');
 CL.AddDelphiFunction('Function IsOctal( AChar : Char) : Boolean;');
 CL.AddDelphiFunction('Function IsOctalString(const AString: string) : Boolean;');
  CL.AddDelphiFunction('Function IsBinary(const AChar : Char) : Boolean');

 //CL.AddDelphiFunction('Function IsOctal2( const AString : string) : Boolean;');
 CL.AddDelphiFunction('Function IPv6AddressToStr(const AValue: TIdIPv6Address): string');
 CL.AddDelphiFunction('Function MakeCanonicalIPv4Address( const AAddr : string) : string');
 CL.AddDelphiFunction('Function MakeCanonicalIPv6Address( const AAddr : string) : string');
 CL.AddDelphiFunction('Function MakeDWordIntoIPv4Address( const ADWord : Cardinal) : string');
 CL.AddDelphiFunction('Function Max( AValueOne, AValueTwo : Integer) : Integer');
  CL.AddDelphiFunction('Function Max64( const AValueOne, AValueTwo : Int64) : Int64');
 CL.AddDelphiFunction('Function MemoryPos( const ASubStr : string; MemBuff : PChar; MemorySize : Integer) : Integer');
 CL.AddDelphiFunction('Function Min64( const AValueOne, AValueTwo : Int64) : Int64');
 //CL.AddDelphiFunction('Function MakeMethod( DataSelf, Code : Pointer) : TMethod');
 CL.AddDelphiFunction('Function MakeTempFilename( const APath : String) : string');
 CL.AddDelphiFunction('Function Min( AValueOne, AValueTwo : Integer) : Integer');
 CL.AddDelphiFunction('Function OffsetFromUTC : TDateTime');
 //CL.AddDelphiFunction('Function PosIdx( const ASubStr, AStr : AnsiString; AStartPos : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Procedure MoveChars( const ASource : String; ASourceStart : integer; var ADest : String; ADestStart, ALen : integer)');
 CL.AddDelphiFunction('Function OrdFourByteToLongWord( AByte1, AByte2, AByte3, AByte4 : Byte) : LongWord');
 CL.AddDelphiFunction('Function PadString( const AString : String; const ALen : Integer; const AChar : Char) : String');
 CL.AddDelphiFunction('Function PosInSmallIntArray( const ASearchInt : SmallInt; AArray : array of SmallInt) : Integer');
 CL.AddDelphiFunction('Function PosInStrArray( const SearchStr : string; Contents : array of string; const CaseSensitive : Boolean) : Integer');
 CL.AddDelphiFunction('Function ProcessPath2( const ABasePath : String; const APath : String; const APathDelim : string) : string');
 CL.AddDelphiFunction('Function RightStr( const AStr : String; Len : Integer) : String');
 CL.AddDelphiFunction('Function ROL( AVal : LongWord; AShift : Byte) : LongWord');
 CL.AddDelphiFunction('Function ROR( AVal : LongWord; AShift : Byte) : LongWord');
 CL.AddDelphiFunction('Function RPos( const ASub, AIn : String; AStart : Integer) : Integer');
 CL.AddDelphiFunction('Function SetLocalTime( Value : TDateTime) : boolean');
 CL.AddDelphiFunction('function ServicesFilePath: string');
 CL.AddDelphiFunction('Function StartsWith( const ANSIStr, APattern : String) : Boolean');
 CL.AddDelphiFunction('Function UnixDateTimeToDelphiDateTime( UnixDateTime : Cardinal) : TDateTime');

 //CL.AddDelphiFunction('Procedure SetThreadPriority( AThread : TThread; const APriority : TIdThreadPriority; const APolicy : IntegerMaxInt)');
 CL.AddDelphiFunction('Procedure Sleep( ATime : cardinal)');
 CL.AddDelphiFunction('Function StrToCard( const AStr : String) : Cardinal');
 CL.AddDelphiFunction('Function StrInternetToDateTime( Value : string) : TDateTime');
 CL.AddDelphiFunction('Function StrToDay( const ADay : string) : Byte');
 CL.AddDelphiFunction('Function StrToMonth( const AMonth : string) : Byte');
 CL.AddDelphiFunction('Function MemoryPos( const ASubStr : String; MemBuff : PChar; MemorySize : Integer) : Integer');
 CL.AddDelphiFunction('Function TimeZoneBias : TDateTime');
 CL.AddDelphiFunction('Function UpCaseFirst( const AStr : string) : string');
 CL.AddDelphiFunction('Function UpCaseFirstWord( const AStr : string) : string');
 CL.AddDelphiFunction('Function GetUniqueFileName( const APath, APrefix, AExt : String) : String');
 CL.AddDelphiFunction('Function RemoveHeaderEntry( AHeader, AEntry : string) : string');
  CL.AddDelphiFunction('Function WordToStr( const Value : Word) : String');
  CL.AddDelphiFunction('Function StrToWord( const Value : String) : Word');
  CL.AddDelphiFunction('Function TwoCharToWord( AChar1, AChar2 : Char) : Word');
  CL.AddDelphiFunction('Procedure WordToTwoBytes( AWord : Word; ByteArray : TIdBytes; Index : integer)');
 CL.AddDelphiFunction('Function Win32Type : TIdWin32Type');
 //from IdStrings
  CL.AddDelphiFunction('Function FindFirstOf( AFind, AText : String) : Integer');
 CL.AddDelphiFunction('Function FindFirstNotOf( AFind, AText : String) : Integer');
 CL.AddDelphiFunction('Function TrimAllOf( ATrim, AText : String) : String');
 CL.AddDelphiFunction('Function IsWhiteString( const AStr : String) : Boolean');
 //CL.AddDelphiFunction('Function BinToHexStr( AData : Pointer; ADataLen : Integer) : String');
 CL.AddDelphiFunction('Function StrHtmlEncode( const AStr : String) : String');
 CL.AddDelphiFunction('Function StrHtmlDecode( const AStr : String) : String');
 CL.AddDelphiFunction('Procedure SplitColumnsNoTrim( const AData : String; AStrings : TStrings; const ADelim : String)');
 CL.AddDelphiFunction('Procedure SplitColumns( const AData : String; AStrings : TStrings; const ADelim : String)');
 CL.AddDelphiFunction('Procedure SplitLines( AData : PChar; ADataSize : Integer; AStrings : TStrings)');
 CL.AddDelphiFunction('Procedure SplitString( const AStr, AToken : String; var VLeft, VRight : String)');
 CL.AddDelphiFunction('Function TwoByteToWord( AByte1, AByte2 : Byte) : Word');
 CL.AddDelphiFunction('Function StartsWithACE( const ABytes : TIdBytes) : Boolean');
 CL.AddDelphiFunction('Function TextIsSame( const A1 : string; const A2 : string) : Boolean');
 CL.AddDelphiFunction('Function TextStartsWith( const S, SubS : string) : Boolean');
 CL.AddDelphiFunction('Function IndyUpperCase( const A1 : string) : string');
 CL.AddDelphiFunction('Function IndyLowerCase( const A1 : string) : string');
 CL.AddDelphiFunction('Function IndyCompareStr( const A1 : string; const A2 : string) : Integer');
 CL.AddDelphiFunction('Function Ticks : Cardinal');
 CL.AddDelphiFunction('Procedure ToDo');
  CL.AddDelphiFunction('Function CommaAdd( const AStr1, AStr2 : String) : string');
 CL.AddDelphiFunction('Function GetClockValue : Int64');
 CL.AddDelphiFunction('Function GetIPHostByName(const AComputerName: String): String;');
 CL.AddDelphiFunction('Function GetHostByName(const AComputerName: String): String;');


 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function IsNumeric2_P( const AString : string) : Boolean;
Begin Result := IdGlobal_max.IsNumeric(AString); END;

(*----------------------------------------------------------------------------*)
Function IsNumeric1_P( AChar : Char) : Boolean;
Begin Result := IdGlobal_max.IsNumeric(AChar); END;

Function iif4_P( ATest : Boolean; const ATrue : double; const AFalse : double) : double;
Begin Result := IdGlobal_max.iif(ATest, ATrue, AFalse); END;

(*----------------------------------------------------------------------------*)
Function iif3_P( ATest : Boolean; const ATrue : Boolean; const AFalse : Boolean) : Boolean;
Begin Result := IdGlobal_max.iif(ATest, ATrue, AFalse); END;

(*----------------------------------------------------------------------------*)
Function iif2_P( ATest : Boolean; const ATrue : string; const AFalse : string) : string;
Begin Result := IdGlobal_max.iif(ATest, ATrue, AFalse); END;

(*----------------------------------------------------------------------------*)
Function iif1_P( ATest : Boolean; const ATrue : Integer; const AFalse : Integer) : Integer;
Begin Result := IdGlobal_max.iif(ATest, ATrue, AFalse); END;

(*----------------------------------------------------------------------------*)
procedure TIdMimeTableOnBuildCache_W(Self: TIdMimeTable; const T: TNotifyEvent);
begin Self.OnBuildCache := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMimeTableOnBuildCache_R(Self: TIdMimeTable; var T: TNotifyEvent);
begin T := Self.OnBuildCache; end;

(*----------------------------------------------------------------------------*)
Function TIdLocalEventWaitFor1_P(Self: TIdLocalEvent) : TWaitResult;
Begin Result := Self.WaitFor; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdGlobal_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AnsiMemoryPos, 'AnsiMemoryPos', cdRegister);
 S.RegisterDelphiFunction(@AnsiPosIdx, 'AnsiPosIdx', cdRegister);
 S.RegisterDelphiFunction(@AnsiSameText, 'AnsiSameText', cdRegister);
 S.RegisterDelphiFunction(@FreeAndNil, 'FreeAndNil', cdRegister);
 S.RegisterDelphiFunction(@GetFileCreationTime, 'GetFileCreationTime', cdRegister);
 S.RegisterDelphiFunction(@GetInternetFormattedFileTimeStamp, 'GetInternetFormattedFileTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@BreakApart, 'BreakApart', cdRegister);
 S.RegisterDelphiFunction(@ABNFToText, 'ABNFToText', cdRegister);
 S.RegisterDelphiFunction(@AppendBytes, 'AppendBytes', cdRegister);
 S.RegisterDelphiFunction(@AppendByte, 'AppendByte', cdRegister);
 S.RegisterDelphiFunction(@AppendString, 'AppendString', cdRegister);
 S.RegisterDelphiFunction(@BinStrToInt, 'BinStrToInt', cdRegister);
 S.RegisterDelphiFunction(@BreakApart, 'BreakApart', cdRegister);
 S.RegisterDelphiFunction(@BytesToString, 'BytesToString1', cdRegister);
 S.RegisterDelphiFunction(@BytesToChar, 'BytesToChar', cdRegister);
 S.RegisterDelphiFunction(@BytesToShort, 'BytesToShort', cdRegister);
 S.RegisterDelphiFunction(@BytesToInteger, 'BytesToInteger', cdRegister);
 S.RegisterDelphiFunction(@BytesToInt64, 'BytesToInt64', cdRegister);
 S.RegisterDelphiFunction(@BytesToIPv6, 'BytesToIPv6', cdRegister);
 S.RegisterDelphiFunction(@BytesToCardinal, 'BytesToCardinal', cdRegister);
 S.RegisterDelphiFunction(@BytesToWord, 'BytesToWord', cdRegister);
  S.RegisterDelphiFunction(@CardinalToFourChar, 'CardinalToFourChar', cdRegister);
 S.RegisterDelphiFunction(@CardinalToFourChar, 'LongWordToFourChar', cdRegister);
 //S.RegisterDelphiFunction(@CopyBytesToHostLongWord, 'CopyBytesToHostLongWord', cdRegister);
 S.RegisterDelphiFunction(@CopyBytesToHostWord, 'CopyBytesToHostWord', cdRegister);
 //S.RegisterDelphiFunction(@CopyTIdNetworkLongWord, 'CopyTIdNetworkLongWord', cdRegister);
 S.RegisterDelphiFunction(@CopyTIdNetworkWord, 'CopyTIdNetworkWord', cdRegister);

 S.RegisterDelphiFunction(@ByteToHex, 'ByteToHex', cdRegister);
 S.RegisterDelphiFunction(@ByteToOctal, 'ByteToOctal', cdRegister);
 S.RegisterDelphiFunction(@CopyTIdBytes, 'CopyTIdBytes', cdRegister);
 S.RegisterDelphiFunction(@CopyTIdByteArray, 'CopyTIdByteArray', cdRegister);
 S.RegisterDelphiFunction(@CopyTIdWord, 'CopyTIdWord', cdRegister);
 S.RegisterDelphiFunction(@CopyTIdLongWord, 'CopyTIdLongWord', cdRegister);
 S.RegisterDelphiFunction(@CopyTIdCardinal, 'CopyTIdCardinal', cdRegister);
 S.RegisterDelphiFunction(@CopyTIdInt64, 'CopyTIdInt64', cdRegister);
 S.RegisterDelphiFunction(@CopyTIdIPV6Address, 'CopyTIdIPV6Address', cdRegister);
 S.RegisterDelphiFunction(@CopyTIdString, 'CopyTIdString', cdRegister);
  //S.RegisterDelphiFunction(@CommaSeparatedToStringList, 'CommaSeparatedToStringList', cdRegister);
 S.RegisterDelphiFunction(@CopyFileTo, 'CopyFileTo', cdRegister);
 S.RegisterDelphiFunction(@CharIsInSet, 'CharIsInSet', cdRegister);
 S.RegisterDelphiFunction(@CharIsInEOF, 'CharIsInEOF', cdRegister);
 S.RegisterDelphiFunction(@CharRange, 'CharRange', cdRegister);
 S.RegisterDelphiFunction(@CharToHex, 'CharToHex', cdRegister);
 S.RegisterDelphiFunction(@CompareDateTime, 'CompareDateTime', cdRegister);
 //S.RegisterDelphiFunction(@LongWordToFourChar, 'LongWordToFourChar', cdRegister);
  S.RegisterDelphiFunction(@FillBytes, 'FillBytes', cdRegister);
 S.RegisterDelphiFunction(@CurrentThreadId, 'CurrentThreadId', cdRegister);
 S.RegisterDelphiFunction(@CurrentProcessId, 'GetCurrentProcessId', cdRegister);
 S.RegisterDelphiFunction(@CurrentProcessId, 'CurrentProcessId', cdRegister);
  S.RegisterDelphiFunction(@CurrentProcessId, 'GetProcessId', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentThreadHandle, 'GetCurrentThreadHandle', cdRegister);
  S.RegisterDelphiFunction(@DateTimeToGmtOffSetStr, 'DateTimeToGmtOffSetStr', cdRegister);
 S.RegisterDelphiFunction(@DateTimeGMTToHttpStr, 'DateTimeGMTToHttpStr', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToInternetStr, 'DateTimeToInternetStr', cdRegister);
 S.RegisterDelphiFunction(@DebugOutput, 'DebugOutput', cdRegister);
 S.RegisterDelphiFunction(@DomainName, 'DomainName', cdRegister);
 S.RegisterDelphiFunction(@EnsureMsgIDBrackets, 'EnsureMsgIDBrackets', cdRegister);
 S.RegisterDelphiFunction(@Fetch, 'Fetch', cdRegister);
 S.RegisterDelphiFunction(@FetchCaseInsensitive, 'FetchCaseInsensitive', cdRegister);
 S.RegisterDelphiFunction(@FileSizeByName, 'FileSizeByName', cdRegister);
   S.RegisterDelphiFunction(@FTPMLSToGMTDateTime, 'FTPMLSToGMTDateTime', cdRegister);
 S.RegisterDelphiFunction(@FTPMLSToLocalDateTime, 'FTPMLSToLocalDateTime', cdRegister);
 S.RegisterDelphiFunction(@FTPGMTDateTimeToMLS, 'FTPGMTDateTimeToMLS', cdRegister);
 S.RegisterDelphiFunction(@FTPLocalDateTimeToMLS, 'FTPLocalDateTimeToMLS', cdRegister);
 S.RegisterDelphiFunction(@GetGMTDateByName, 'GetGMTDateByName', cdRegister);
  S.RegisterDelphiFunction(@GetMIMETypeFromFile, 'GetMIMETypeFromFile', cdRegister);
 S.RegisterDelphiFunction(@GetMIMEDefaultFileExt, 'GetMIMEDefaultFileExt', cdRegister);
 //S.RegisterDelphiFunction(@GetGMTDateByName, 'GetGMTDateByName', cdRegister);
 S.RegisterDelphiFunction(@GetClockValue, 'GetClockValue', cdRegister);
  S.RegisterDelphiFunction(@GetSystemLocale, 'GetSystemLocale', cdRegister);
 S.RegisterDelphiFunction(@GetThreadHandle, 'GetThreadHandle', cdRegister);
 S.RegisterDelphiFunction(@GetTickCount, 'GetTickCount', cdRegister);
 S.RegisterDelphiFunction(@GetTickDiff, 'GetTickDiff', cdRegister);
 S.RegisterDelphiFunction(@GmtOffsetStrToDateTime, 'GmtOffsetStrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@GMTToLocalDateTime, 'GMTToLocalDateTime', cdRegister);
 S.RegisterDelphiFunction(@IdPorts2, 'IdPorts', cdRegister);
 S.RegisterDelphiFunction(@iif1_P, 'iif1', cdRegister);
 S.RegisterDelphiFunction(@iif2_P, 'iif2', cdRegister);
 S.RegisterDelphiFunction(@iif3_P, 'iif3', cdRegister);
 //S.RegisterDelphiFunction(@iif1_P, 'iif1', cdRegister);
 S.RegisterDelphiFunction(@iif1_P, 'ifthenint', cdRegister);
 S.RegisterDelphiFunction(@iif4_P, 'ifthendouble', cdRegister);
 S.RegisterDelphiFunction(@iif3_P, 'ifthenbool', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingSlash, 'IncludeTrailingSlash', cdRegister);
 S.RegisterDelphiFunction(@IntToBin, 'IntToBin', cdRegister);
 S.RegisterDelphiFunction(@ByteToBin, 'ByteToBin', cdRegister); //3.6
 S.RegisterDelphiFunction(@BinToByte, 'BinToByte', cdRegister);

 S.RegisterDelphiFunction(@IndyGetHostName, 'IndyGetHostName', cdRegister);
 S.RegisterDelphiFunction(@IndyGetHostName, 'GetHostName', cdRegister);
 S.RegisterDelphiFunction(@IndyInterlockedIncrement, 'IndyInterlockedIncrement', cdRegister);
 S.RegisterDelphiFunction(@IndyInterlockedDecrement, 'IndyInterlockedDecrement', cdRegister);
 S.RegisterDelphiFunction(@IndyInterlockedExchange, 'IndyInterlockedExchange', cdRegister);
 S.RegisterDelphiFunction(@IndyInterlockedExchangeAdd, 'IndyInterlockedExchangeAdd', cdRegister);
 S.RegisterDelphiFunction(@IndyStrToBool, 'IndyStrToBool', cdRegister);
 S.RegisterDelphiFunction(@IsCurrentThread, 'IsCurrentThread', cdRegister);
 S.RegisterDelphiFunction(@IsDomain, 'IsDomain', cdRegister);
 S.RegisterDelphiFunction(@IsFQDN, 'IsFQDN', cdRegister);
 S.RegisterDelphiFunction(@IsHostname, 'IsHostname', cdRegister);
 S.RegisterDelphiFunction(@IsNumeric1_P, 'IsNumeric', cdRegister);
 S.RegisterDelphiFunction(@IsNumeric2_P, 'IsNumeric2', cdRegister);
 S.RegisterDelphiFunction(@IsTopDomain, 'IsTopDomain', cdRegister);
 S.RegisterDelphiFunction(@IsValidIP, 'IsValidIP', cdRegister);
 //S.RegisterDelphiFunction(@IdGetDefaultCharSet, 'IdGetDefaultCharSet', cdRegister);
  S.RegisterDelphiFunction(@IsLeadChar, 'IsLeadChar', cdRegister);
  S.RegisterDelphiFunction(@IsASCII, 'IsASCII', cdRegister);
 //S.RegisterDelphiFunction(@IsASCII2, 'IsASCII2', cdRegister);
 S.RegisterDelphiFunction(@IsASCIILDH, 'IsASCIILDH', cdRegister);
 //S.RegisterDelphiFunction(@IsASCIILDH2, 'IsASCIILDH2', cdRegister);
 S.RegisterDelphiFunction(@IsHexidecimal, 'IsHex', cdRegister);
 S.RegisterDelphiFunction(@IsHexidecimalString, 'IsHexString', cdRegister);
 S.RegisterDelphiFunction(@IsOctal, 'IsOctal', cdRegister);
 S.RegisterDelphiFunction(@IsOctalString, 'IsOctalString', cdRegister);
  S.RegisterDelphiFunction(@IsBinary, 'IsBinary', cdRegister);
   //raise
 S.RegisterDelphiFunction(@InMainThread, 'InMainThread', cdRegister);
 S.RegisterDelphiFunction(@Max, 'Max', cdRegister);
 S.RegisterDelphiFunction(@MakeMethod, 'MakeMethod', cdRegister);
 S.RegisterDelphiFunction(@MakeTempFilename, 'MakeTempFilename', cdRegister);
 S.RegisterDelphiFunction(@MakeCanonicalIPv4Address, 'MakeCanonicalIPv4Address', cdRegister);
 //S.RegisterDelphiFunction(@MakeCanonicalIPv6Address, 'MakeCanonicalIPv6Address', cdRegister);
 S.RegisterDelphiFunction(@IPv6AddressToStr, 'IPv6AddressToStr', cdRegister);
 S.RegisterDelphiFunction(@MakeDWordIntoIPv4Address, 'MakeDWordIntoIPv4Address', cdRegister);
 S.RegisterDelphiFunction(@Min, 'Min', cdRegister);
 S.RegisterDelphiFunction(@Max64, 'Max64', cdRegister);
 S.RegisterDelphiFunction(@MemoryPos, 'MemoryPos', cdRegister);
 S.RegisterDelphiFunction(@Min64, 'Min64', cdRegister);
 S.RegisterDelphiFunction(@MoveChars, 'MoveChars', cdRegister);
 //S.RegisterDelphiFunction(@OrdFourByteToLongWord, 'OrdFourByteToLongWord', cdRegister);
 //S.RegisterDelphiFunction(@PadString, 'PadString', cdRegister);
 S.RegisterDelphiFunction(@OrdFourByteToCardinal, 'OrdFourByteToCardinal', cdRegister);
 S.RegisterDelphiFunction(@OffsetFromUTC, 'OffsetFromUTC', cdRegister);
 S.RegisterDelphiFunction(@PosIdx, 'PosIdx', cdRegister);
 S.RegisterDelphiFunction(@PosInStrArray, 'PosInStrArray', cdRegister);
 S.RegisterDelphiFunction(@PosInSmallIntArray, 'PosInSmallIntArray', cdRegister);
 S.RegisterDelphiFunction(@IdGlobal_max.ProcessPath2, 'ProcessPath2', cdRegister);
 S.RegisterDelphiFunction(@RightStr, 'RightStr', cdRegister);
 S.RegisterDelphiFunction(@ROL, 'ROL', cdRegister);
 S.RegisterDelphiFunction(@ROR, 'ROR', cdRegister);
 S.RegisterDelphiFunction(@RPos, 'RPos', cdRegister);
 S.RegisterDelphiFunction(@ServicesFilePath, 'ServicesFilePath', cdRegister);
 S.RegisterDelphiFunction(@SetLocalTime, 'SetLocalTime', cdRegister);
 S.RegisterDelphiFunction(@SetThreadPriority, 'SetThreadPriority', cdRegister);
 S.RegisterDelphiFunction(@Sleep, 'Sleep', cdRegister);
 S.RegisterDelphiFunction(@StartsWith, 'StartsWith', cdRegister);
 S.RegisterDelphiFunction(@StrToCard, 'StrToCard', cdRegister);
 S.RegisterDelphiFunction(@StrInternetToDateTime, 'StrInternetToDateTime', cdRegister);
 S.RegisterDelphiFunction(@StrToDay, 'StrToDay', cdRegister);
 S.RegisterDelphiFunction(@StrToMonth, 'StrToMonth', cdRegister);
 S.RegisterDelphiFunction(@MemoryPos, 'MemoryPos', cdRegister);
 S.RegisterDelphiFunction(@TimeZoneBias, 'TimeZoneBias', cdRegister);
 S.RegisterDelphiFunction(@UpCaseFirst, 'UpCaseFirst', cdRegister);
 S.RegisterDelphiFunction(@UnixDateTimeToDelphiDateTime, 'UnixDateTimeToDelphiDateTime', cdRegister);
  //S.RegisterDelphiFunction(@UpCaseFirstWord, 'UpCaseFirstWord', cdRegister);
 S.RegisterDelphiFunction(@GetUniqueFileName, 'GetUniqueFileName', cdRegister);
 //S.RegisterDelphiFunction(@RemoveHeaderEntry, 'RemoveHeaderEntry', cdRegister);
 S.RegisterDelphiFunction(@WordToStr, 'WordToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToWord, 'StrToWord', cdRegister);
  S.RegisterDelphiFunction(@TwoCharToWord, 'TwoCharToWord', cdRegister);
  S.RegisterDelphiFunction(@WordToTwoBytes, 'WordToTwoBytes', cdRegister);
  S.RegisterDelphiFunction(@Win32Type, 'Win32Type', cdRegister);
 S.RegisterDelphiFunction(@FindFirstOf, 'FindFirstOf', cdRegister);
 S.RegisterDelphiFunction(@FindFirstNotOf, 'FindFirstNotOf', cdRegister);
 S.RegisterDelphiFunction(@TrimAllOf, 'TrimAllOf', cdRegister);
 S.RegisterDelphiFunction(@IsWhiteString, 'IsWhiteString', cdRegister);
 S.RegisterDelphiFunction(@BinToHexStr, 'BinToHexStr', cdRegister);
 S.RegisterDelphiFunction(@StrHtmlEncode, 'StrHtmlEncode', cdRegister);
 S.RegisterDelphiFunction(@StrHtmlDecode, 'StrHtmlDecode', cdRegister);
 S.RegisterDelphiFunction(@SplitColumnsNoTrim, 'SplitColumnsNoTrim', cdRegister);
 S.RegisterDelphiFunction(@SplitColumns, 'SplitColumns', cdRegister);
 S.RegisterDelphiFunction(@SplitLines, 'SplitLines', cdRegister);
 S.RegisterDelphiFunction(@SplitString, 'SplitString', cdRegister);
 S.RegisterDelphiFunction(@TwoByteToWord, 'TwoByteToWord', cdRegister);
 S.RegisterDelphiFunction(@StartsWithACE, 'StartsWithACE', cdRegister);
 S.RegisterDelphiFunction(@TextIsSame, 'TextIsSame', cdRegister);
 S.RegisterDelphiFunction(@TextStartsWith, 'TextStartsWith', cdRegister);
 S.RegisterDelphiFunction(@IndyUpperCase, 'IndyUpperCase', cdRegister);
 S.RegisterDelphiFunction(@IndyLowerCase, 'IndyLowerCase', cdRegister);
 S.RegisterDelphiFunction(@IndyCompareStr, 'IndyCompareStr', cdRegister);
 S.RegisterDelphiFunction(@Ticks, 'Ticks', cdRegister);
 S.RegisterDelphiFunction(@ToDo, 'ToDo', cdRegister);
 S.RegisterDelphiFunction(@CommaAdd, 'CommaAdd', cdRegister);
 S.RegisterDelphiFunction(@GetClockValue, 'GetClockValue', cdRegister);
 S.RegisterDelphiFunction(@GetIPHostByName, 'GetIPHostByName', cdRegister);
 S.RegisterDelphiFunction(@GetIPHostByName, 'GetHostByName', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdReadMemoryStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdReadMemoryStream) do begin
    RegisterMethod(@TIdReadMemoryStream.SetPointer, 'SetPointer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMimeTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMimeTable) do begin
    RegisterVirtualMethod(@TIdMimeTable.BuildCache, 'BuildCache');
    RegisterMethod(@TIdMimeTable.AddMimeType, 'AddMimeType');
    RegisterMethod(@TIdMimeTable.GetFileMIMEType, 'GetFileMIMEType');
    RegisterMethod(@TIdMimeTable.GetDefaultFileExt, 'GetDefaultFileExt');
    RegisterMethod(@TIdMimeTable.LoadFromStrings, 'LoadFromStrings');
    RegisterMethod(@TIdMimeTable.SaveToStrings, 'SaveToStrings');
    RegisterVirtualConstructor(@TIdMimeTable.Create, 'Create');
    RegisterMethod(@TIdMimeTable.Destroy, 'Free');
    RegisterPropertyHelper(@TIdMimeTableOnBuildCache_R,@TIdMimeTableOnBuildCache_W,'OnBuildCache');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdLocalEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdLocalEvent) do begin
    RegisterConstructor(@TIdLocalEvent.Create, 'Create');
    RegisterMethod(@TIdLocalEventWaitFor1_P, 'WaitFor1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdGlobal(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdLocalEvent(CL);
  RIRegister_TIdMimeTable(CL);
  RIRegister_TIdReadMemoryStream(CL);
  with CL.Add(EIdFailedToRetreiveTimeZoneInfo) do
  with CL.Add(EIdCorruptServicesFile) do
  with CL.Add(EIdExtensionAlreadyExists) do
end;

 
 
{ TPSImport_IdGlobal }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdGlobal.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdGlobal(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdGlobal.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdGlobal(ri);
  RIRegister_IdGlobal_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
