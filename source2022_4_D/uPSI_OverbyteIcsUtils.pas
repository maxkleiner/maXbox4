unit uPSI_OverbyteIcsUtils;
{
Texperimental use metadata

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
  TPSImport_OverbyteIcsUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIcsCriticalSection(CL: TPSPascalCompiler);
procedure SIRegister_TIcsIntegerList(CL: TPSPascalCompiler);
procedure SIRegister_TIcsFileStreamW(CL: TPSPascalCompiler);
procedure SIRegister_OverbyteIcsUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIcsCriticalSection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIcsIntegerList(CL: TPSRuntimeClassImporter);
procedure RIRegister_OverbyteIcsUtils_Routines(S: TPSExec);
procedure RIRegister_TIcsFileStreamW(CL: TPSRuntimeClassImporter);
procedure RIRegister_OverbyteIcsUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   OverbyteIcsUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OverbyteIcsUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIcsCriticalSection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIcsCriticalSection') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIcsCriticalSection') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Enter');
    RegisterMethod('Procedure Leave');
    RegisterMethod('Function TryEnter : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIcsIntegerList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIcsIntegerList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIcsIntegerList') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterMethod('Function IndexOf( Item : Integer) : Integer');
    RegisterMethod('Function Add( Item : Integer) : Integer');
    RegisterMethod('Procedure Assign( Source : TIcsIntegerList)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('First', 'Integer', iptr);
    RegisterProperty('Last', 'Integer', iptr);
    RegisterProperty('Items', 'Integer Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIcsFileStreamW(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFileStream', 'TIcsFileStreamW') do
  with CL.AddClassN(CL.FindClass('TFileStream'),'TIcsFileStreamW') do
  begin
    RegisterMethod('Constructor Create( const FileName : UnicodeString; Mode : Word);');
    RegisterMethod('Constructor Create1( const FileName : UnicodeString; Mode : Word; Rights : Cardinal);');
    RegisterMethod('Constructor Create2( const Utf8FileName : UTF8String; Mode : Word);');
    RegisterMethod('Constructor Create3( const Utf8FileName : UTF8String; Mode : Word; Rights : Cardinal);');
    RegisterProperty('FileName', 'UnicodeString', iptr);
     RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_OverbyteIcsUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIcsDbcsLeadBytes', 'TSysCharset');
 CL.AddConstantN('MB_ERR_INVALID_CHARS','LongWord').SetUInt( $00000008);
 CL.AddConstantN('WC_ERR_INVALID_CHARS','LongWord').SetUInt( $80);
 CL.AddConstantN('CP_UTF16','LongInt').SetInt( 1200);
 CL.AddConstantN('CP_UTF16Be','LongInt').SetInt( 1201);
 CL.AddConstantN('CP_UTF32','LongInt').SetInt( 12000);
 CL.AddConstantN('CP_UTF32Be','LongInt').SetInt( 12001);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIcsStringConvertError');
  CL.AddTypeS('TCharsetDetectResult', '( cdrAscii, cdrUtf8, cdrUnknown )');
  CL.AddTypeS('TIcsNormForm', '( icsNormalizationOther, icsNormalizationC, icsNormalizationD, icsNormalizationKD )');
  CL.AddTypeS('TIcsSearchRecW', 'record Time : Integer; Size : Integer; Attr : '
   +'Integer; Name : String; ExcludeAttr : Integer; FindHandle : THandle; FindData : TWin32FindData; end');
  CL.AddTypeS('TUnicode_String', 'record Length : Word; MaximumLength : Word; Buffer : WideChar; end');
  CL.AddTypeS('TThreadID', 'LongWord;');


 // CL.AddTypeS('PUnicode_String', '^TUnicode_String // will not work');
  SIRegister_TIcsFileStreamW(CL);
 CL.AddConstantN('ICONV_UNICODE','String').SetString( 'UTF-16LE');
 CL.AddDelphiFunction('Function IcsIconvNameFromCodePage( CodePage : LongWord) : AnsiString');
 CL.AddDelphiFunction('Function IcsIsValidAnsiCodePage( const CP : LongWord) : Boolean');
 CL.AddDelphiFunction('Procedure IcsCharLowerA( var ACh : AnsiChar)');
 CL.AddDelphiFunction('Function IcsGetCurrentThreadID : TThreadID');
 CL.AddDelphiFunction('Function IcsGetFreeDiskSpace( const APath : String) : Int64');
 CL.AddDelphiFunction('Function IcsGetLocalTimeZoneBias : LongInt');
 CL.AddDelphiFunction('Function IcsDateTimeToUTC( dtDT : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function IcsUTCToDateTime( dtDT : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function IcsGetTickCount : LongWord');
 //CL.AddDelphiFunction('Function IcsWcToMb( CodePage : LongWord; Flags : Cardinal; WStr : PWideChar; WStrLen : Integer; MbStr : PAnsiChar; MbStrLen : Integer; DefaultChar : PAnsiChar; UsedDefaultChar : PLongBool) : Integer');
 //CL.AddDelphiFunction('Function IcsMbToWc( CodePage : LongWord; Flags : Cardinal; MbStr : PAnsiChar; MbStrLen : Integer; WStr : PWideChar; WStrLen : Integer) : Integer');
 CL.AddDelphiFunction('Function IcsGetDefaultWindowsUnicodeChar( CodePage : LongWord) : WideChar');
 CL.AddDelphiFunction('Function IcsGetDefaultWindowsAnsiChar( CodePage : LongWord) : AnsiChar');
 CL.AddDelphiFunction('Procedure IcsGetAcp( var CodePage : LongWord)');
 CL.AddDelphiFunction('Function IcsIsDBCSCodePage( CodePage : LongWord) : Boolean');
 CL.AddDelphiFunction('Function IcsIsDBCSLeadByte( Ch : AnsiChar; CodePage : LongWord) : Boolean');
 CL.AddDelphiFunction('Function IcsIsMBCSCodePage( CodePage : LongWord) : Boolean');
 CL.AddDelphiFunction('Function IcsIsSBCSCodePage( CodePage : LongWord) : Boolean');
 CL.AddDelphiFunction('Function IcsGetLeadBytes( CodePage : LongWord) : TIcsDbcsLeadBytes');
 CL.AddDelphiFunction('Function icsUnicodeToUsAscii4( const Str : UnicodeString; FailCh : AnsiChar) : AnsiString;');
 CL.AddDelphiFunction('Function icsUnicodeToUsAscii5( const Str : UnicodeString) : AnsiString;');
 CL.AddDelphiFunction('Function icsUsAsciiToUnicode6( const Str : RawByteString; FailCh : AnsiChar) : UnicodeString;');
 CL.AddDelphiFunction('Function icsUsAsciiToUnicode7( const Str : RawByteString) : UnicodeString;');
 CL.AddDelphiFunction('Function icsUnicodeToAnsi8( const Str : WideChar; ACodePage : LongWord; SetCodePage : Boolean) : RawByteString;');
 CL.AddDelphiFunction('Function icsUnicodeToAnsi9( const Str : UnicodeString; ACodePage : LongWord; SetCodePage : Boolean) : RawByteString;');
 CL.AddDelphiFunction('Function icsUnicodeToAnsi10( const Str : UnicodeString) : RawByteString;');
 CL.AddDelphiFunction('Function icsAnsiToUnicode11( const Str : AnsiChar; ACodePage : LongWord) : UnicodeString;');
 CL.AddDelphiFunction('Function icsAnsiToUnicode12( const Str : RawByteString; ACodePage : LongWord) : UnicodeString;');
 CL.AddDelphiFunction('Function icsAnsiToUnicode13( const Str : RawByteString) : UnicodeString;');
 CL.AddDelphiFunction('Function IcsBufferToUnicode14( const Buffer, BufferSize : Integer; BufferCodePage : LongWord; out FailedByteCount : Integer) : UnicodeString;');
 CL.AddDelphiFunction('Function IcsBufferToUnicode15( const Buffer, BufferSize : Integer; BufferCodePage : LongWord; RaiseFailedBytes : Boolean) : UnicodeString;');
 CL.AddDelphiFunction('Function IcsGetWideCharCount( const Buffer, BufferSize : Integer; BufferCodePage : LongWord; out InvalidEndByteCount : Integer) : Integer');
 CL.AddDelphiFunction('Function IcsGetWideChars( const Buffer, BufferSize : Integer; BufferCodePage : LongWord; Chars : WideChar; CharCount : Integer) : Integer');
 CL.AddDelphiFunction('Function icsStreamWriteString16( AStream : TStream; Str : WideChar; cLen : Integer; ACodePage : LongWord; WriteBOM : Boolean) : Integer;');
 CL.AddDelphiFunction('Function icsStreamWriteString17( AStream : TStream; Str : WideChar; cLen : Integer; ACodePage : LongWord) : Integer;');
 CL.AddDelphiFunction('Function icsStreamWriteString18( AStream : TStream; const Str : UnicodeString; ACodePage : LongWord; WriteBOM : Boolean) : Integer;');
 CL.AddDelphiFunction('Function icsStreamWriteString19( AStream : TStream; const Str : UnicodeString; ACodePage : LongWord) : Integer;');
 CL.AddDelphiFunction('Function icsStreamWriteString20( AStream : TStream; const Str : UnicodeString) : Integer;');
 CL.AddDelphiFunction('Function icsIsUsAscii21( const Str : RawByteString) : Boolean;');
 CL.AddDelphiFunction('Function icsIsUsAscii22( const Str : UnicodeString) : Boolean;');
 CL.AddDelphiFunction('Procedure IcsAppendStr( var Dest : RawByteString; const Src : RawByteString)');
 CL.AddDelphiFunction('Function icsatoi23( const Str : RawByteString) : Integer;');
 CL.AddDelphiFunction('Function icsatoi24( const Str : UnicodeString) : Integer;');
 CL.AddDelphiFunction('Function icsatoi6425( const Str : RawByteString) : Int64;');
 CL.AddDelphiFunction('Function icsatoi6426( const Str : UnicodeString) : Int64;');
 CL.AddDelphiFunction('Function IcsCalcTickDiff( const StartTick, EndTick : LongWord) : LongWord');
 CL.AddDelphiFunction('Function icsStringToUtf827( const Str : UnicodeString) : RawByteString;');
 CL.AddDelphiFunction('Function icsStringToUtf828( const Str : RawByteString; ACodePage : LongWord) : RawByteString;');
 CL.AddDelphiFunction('Function icsUtf8ToStringW( const Str : RawByteString) : UnicodeString');
 CL.AddDelphiFunction('Function icsUtf8ToStringA( const Str : RawByteString; ACodePage : LongWord) : AnsiString');
 CL.AddDelphiFunction('Function icsCheckUnicodeToAnsi( const Str : UnicodeString; ACodePage : LongWord) : Boolean');
 CL.AddDelphiFunction('Function icsIsUtf8TrailByte( const B : Byte) : Boolean');
 CL.AddDelphiFunction('Function icsIsUtf8LeadByte( const B : Byte) : Boolean');
 CL.AddDelphiFunction('Function IcsUtf8Size( const LeadByte : Byte) : Integer');
 CL.AddDelphiFunction('Function icsIsLeadChar( Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function icsIsUtf8Valid29( const Str : RawByteString) : Boolean;');
 //CL.AddDelphiFunction('Function IsUtf8Valid30( const Buf : Pointer; Len : Integer) : Boolean;');
 //CL.AddDelphiFunction('Function CharsetDetect31( const Buf : Pointer; Len : Integer) : TCharsetDetectResult;');
 CL.AddDelphiFunction('Function icsCharsetDetect32( const Str : RawByteString) : TCharsetDetectResult;');
 CL.AddDelphiFunction('Function IcsCharNextUtf8( const Str : AnsiChar) : AnsiChar');
 CL.AddDelphiFunction('Function IcsCharPrevUtf8( const Start, Current : AnsiChar) : AnsiChar');
 CL.AddDelphiFunction('Function icsConvertCodepage( const Str : RawByteString; SrcCodePage : LongWord; DstCodePage : LongWord) : RawByteString');
 CL.AddDelphiFunction('Function icshtoin33( Value : WideChar; Len : Integer) : Integer;');
 CL.AddDelphiFunction('Function icshtoin34( Value : AnsiChar; Len : Integer) : Integer;');
 CL.AddDelphiFunction('Function icshtoi235( value : WideChar) : Integer;');
 CL.AddDelphiFunction('Function icshtoi236( value : AnsiChar) : Integer;');
 CL.AddDelphiFunction('Function IcsBufferToHex37( const Buf, Size : Integer) : String;');
 CL.AddDelphiFunction('Function IcsBufferToHex38( const Buf, Size : Integer; Separator : Char) : String;');
 CL.AddDelphiFunction('Function icsIsXDigit39( Ch : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function icsIsXDigit40( Ch : AnsiChar) : Boolean;');
 CL.AddDelphiFunction('Function icsXDigit41( Ch : WideChar) : Integer;');
 CL.AddDelphiFunction('Function icsXDigit42( Ch : AnsiChar) : Integer;');
 CL.AddDelphiFunction('Function icsIsCharInSysCharSet43( Ch : WideChar; const ASet : TSysCharSet) : Boolean;');
 CL.AddDelphiFunction('Function icsIsCharInSysCharSet44( Ch : AnsiChar; const ASet : TSysCharSet) : Boolean;');
 CL.AddDelphiFunction('Function icsIsDigit45( Ch : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function icsIsDigit46( Ch : AnsiChar) : Boolean;');
 CL.AddDelphiFunction('Function icsIsSpace47( Ch : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function icsIsSpace48( Ch : AnsiChar) : Boolean;');
 CL.AddDelphiFunction('Function icsIsCRLF49( Ch : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function icsIsCRLF50( Ch : AnsiChar) : Boolean;');
 CL.AddDelphiFunction('Function icsIsSpaceOrCRLF51( Ch : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function icsIsSpaceOrCRLF52( Ch : AnsiChar) : Boolean;');
 CL.AddDelphiFunction('Function icsXDigit2( S : PChar) : Integer');
 CL.AddDelphiFunction('Function icsstpblk53( PValue : WideChar) : WideChar;');
 CL.AddDelphiFunction('Function icsstpblk54( PValue : AnsiChar) : AnsiChar;');
 CL.AddDelphiFunction('Function IcsStrNextChar( const Str : AnsiChar; ACodePage : LongWord) : AnsiChar');
 CL.AddDelphiFunction('Function IcsStrPrevChar( const Start, Current : AnsiChar; ACodePage : LongWord) : AnsiChar');
 CL.AddDelphiFunction('Function IcsStrCharLength55( const Str : AnsiChar; ACodePage : LongWord) : Integer;');
 CL.AddDelphiFunction('Function IcsNextCharIndex56( const S : RawByteString; Index : Integer; ACodePage : LongWord) : Integer;');
 CL.AddDelphiFunction('Function IcsGetBomBytes( ACodePage : LongWord) : TBytes');
 CL.AddDelphiFunction('Function IcsGetBufferCodepage57( Buf : AnsiChar; ByteCount : Integer) : LongWord;');
 CL.AddDelphiFunction('Function IcsGetBufferCodepage58( Buf : AnsiChar; ByteCount : Integer; out BOMSize : Integer) : LongWord;');
 CL.AddDelphiFunction('Function IcsSwap16( Value : Word) : Word');
 CL.AddDelphiFunction('Procedure IcsSwap16Buf( Src, Dst : Word; WordCount : Integer)');
 CL.AddDelphiFunction('Function IcsSwap32( Value : LongWord) : LongWord');
 CL.AddDelphiFunction('Procedure IcsSwap32Buf( Src, Dst : LongWord; LongWordCount : Integer)');
 CL.AddDelphiFunction('Function IcsSwap64( Value : Int64) : Int64');
 CL.AddDelphiFunction('Procedure IcsSwap64Buf( Src, Dst : Int64; QuadWordCount : Integer)');
 CL.AddDelphiFunction('Procedure IcsNameThreadForDebugging( AThreadName : AnsiString; AThreadID : TThreadID)');
 CL.AddDelphiFunction('Function IcsNormalizeString( const S : UnicodeString; NormForm : TIcsNormForm) : UnicodeString');
 CL.AddDelphiFunction('Function IcsCryptGenRandom( var Buf, BufSize : Integer) : Boolean');
 CL.AddDelphiFunction('Function IcsRandomInt( const ARange : Integer) : Integer');
 CL.AddDelphiFunction('Function IcsFileUtcModified( const FileName : String) : TDateTime');
 //CL.AddDelphiFunction('Function IcsInterlockedCompareExchange( var Destination : Pointer; Exchange : Pointer; Comperand : Pointer) : Pointer');
 CL.AddDelphiFunction('Function IcsExtractFilePathW( const FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsExtractFileDirW( const FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsExtractFileDriveW( const FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsExtractFileNameW( const FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsExtractFileExtW( const FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsExpandFileNameW( const FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsExtractNameOnlyW( FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsChangeFileExtW( const FileName, Extension : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsStrAllocW( Len : Cardinal) : WideChar');
 CL.AddDelphiFunction('Function IcsStrLenW( Str : WideChar) : Cardinal');
 CL.AddDelphiFunction('Function IcsAnsiCompareFileNameW59( const S1, S2 : UnicodeString) : Integer;');
 CL.AddDelphiFunction('Function IcsAnsiCompareFileNameW60( const Utf8S1, Utf8S2 : UTF8String) : Integer;');
 CL.AddDelphiFunction('Function IcsDirExistsW61( const FileName : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function IcsDirExistsW62( const FileName : UnicodeString) : Boolean;');
 CL.AddDelphiFunction('Function IcsDirExistsW63( const Utf8FileName : UTF8String) : Boolean;');
 CL.AddDelphiFunction('Function IcsFindFirstW64( const Path : UnicodeString; Attr : Integer; var F : TIcsSearchRecW) : Integer;');
 CL.AddDelphiFunction('Function IcsFindFirstW65( const Utf8Path : UTF8String; Attr : Integer; var F : TIcsSearchRecW) : Integer;');
 CL.AddDelphiFunction('Procedure IcsFindCloseW( var F : TIcsSearchRecW)');
 CL.AddDelphiFunction('Function IcsFindNextW( var F : TIcsSearchRecW) : Integer');
 CL.AddDelphiFunction('Function IcsIncludeTrailingPathDelimiterW( const S : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsExcludeTrailingPathDelimiterW( const S : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsExtractLastDir66( const Path : RawByteString) : RawByteString;');
 CL.AddDelphiFunction('Function IcsExtractLastDir67( const Path : UnicodeString) : UnicodeString;');
 CL.AddDelphiFunction('Function IcsFileGetAttrW68( const FileName : UnicodeString) : Integer;');
 CL.AddDelphiFunction('Function IcsFileGetAttrW69( const Utf8FileName : UTF8String) : Integer;');
 CL.AddDelphiFunction('Function IcsFileSetAttrW70( const FileName : UnicodeString; Attr : Integer) : Integer;');
 CL.AddDelphiFunction('Function IcsFileSetAttrW71( const Utf8FileName : UTF8String; Attr : Integer) : Integer;');
 CL.AddDelphiFunction('Function IcsDeleteFileW72( const FileName : UnicodeString) : Boolean;');
 CL.AddDelphiFunction('Function IcsDeleteFileW73( const Utf8FileName : UTF8String) : Boolean;');
 CL.AddDelphiFunction('Function IcsRenameFileW74( const OldName, NewName : UnicodeString) : Boolean;');
 CL.AddDelphiFunction('Function IcsRenameFileW75( const Utf8OldName, Utf8NewName : UTF8String) : Boolean;');
 CL.AddDelphiFunction('Function IcsForceDirectoriesW76( Dir : UnicodeString) : Boolean;');
 CL.AddDelphiFunction('Function IcsForceDirectoriesW77( Utf8Dir : UTF8String) : Boolean;');
 CL.AddDelphiFunction('Function IcsCreateDirW78( const Dir : UnicodeString) : Boolean;');
 CL.AddDelphiFunction('Function IcsCreateDirW79( const Utf8Dir : UTF8String) : Boolean;');
 CL.AddDelphiFunction('Function IcsRemoveDirW80( const Dir : UnicodeString) : Boolean;');
 CL.AddDelphiFunction('Function IcsRemoveDirW81( const Utf8Dir : UTF8String) : Boolean;');
 CL.AddDelphiFunction('Function IcsFileAgeW82( const FileName : UnicodeString) : Integer;');
 CL.AddDelphiFunction('Function IcsFileAgeW83( const Utf8FileName : UTF8String) : Integer;');
 CL.AddDelphiFunction('Function IcsFileExistsW84( const FileName : UnicodeString) : Boolean;');
 CL.AddDelphiFunction('Function IcsFileExistsW85( const Utf8FileName : UTF8String) : Boolean;');
 CL.AddDelphiFunction('Function IcsAnsiLowerCaseW( const S : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsAnsiUpperCaseW( const S : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function IcsMakeWord( L, H : Byte) : Word');
 CL.AddDelphiFunction('Function IcsMakeLong( L, H : Word) : Longint');
 CL.AddDelphiFunction('Function IcsHiWord( LW : LongWord) : Word');
 CL.AddDelphiFunction('Function IcsHiByte( W : Word) : Byte');
 CL.AddDelphiFunction('Function IcsLoByte( W : Word) : Byte');
 CL.AddDelphiFunction('Function IcsLoWord( LW : LongWord) : Word');
 CL.AddDelphiFunction('Procedure IcsCheckOSError( ALastError : Integer)');
 CL.AddDelphiFunction('Function IcsIntToStrA( N : Integer) : AnsiString');
 CL.AddDelphiFunction('Function IcsIntToHexA( N : Integer; Digits : Byte) : AnsiString');
 CL.AddDelphiFunction('Function IcsTrim86( const Str : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function IcsTrim87( const Str : UnicodeString) : UnicodeString;');
 CL.AddDelphiFunction('Function IcsLowerCase88( const S : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function IcsLowerCase89( const S : UnicodeString) : UnicodeString;');
 CL.AddDelphiFunction('Function IcsUpperCase90( const S : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function IcsUpperCase91( const S : UnicodeString) : UnicodeString;');
 CL.AddDelphiFunction('Function IcsUpperCaseA( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function IcsLowerCaseA( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function IcsCompareTextA( const S1, S2 : AnsiString) : Integer');
 CL.AddDelphiFunction('Function IcsTrimA( const Str : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function IcsSameTextA( const S1, S2 : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function IcsCompareStr92( const S1, S2 : AnsiString) : Integer;');
 CL.AddDelphiFunction('Function IcsCompareStr93( const S1, S2 : UnicodeString) : Integer;');
 CL.AddDelphiFunction('Function IcsCompareText94( const S1, S2 : AnsiString) : Integer;');
 CL.AddDelphiFunction('Function IcsCompareText95( const S1, S2 : UnicodeString) : Integer;');
 CL.AddDelphiFunction('Function IcsStrLen96( const Str : AnsiChar) : Cardinal;');
 CL.AddDelphiFunction('Function IcsStrLen97( const Str : WideChar) : Cardinal;');
 CL.AddDelphiFunction('Function IcsStrPas98( const Str : AnsiChar) : AnsiString;');
 CL.AddDelphiFunction('Function IcsStrPas99( const Str : WideChar) : string;');
 CL.AddDelphiFunction('Function IcsStrCopy100( Dest : AnsiChar; const Source : AnsiChar) : AnsiChar;');
 CL.AddDelphiFunction('Function IcsStrCopy101( Dest : WideChar; const Source : WideChar) : WideChar;');
 CL.AddDelphiFunction('Function IcsStrPCopy102( Dest : PChar; const Source : string) : PChar;');
 CL.AddDelphiFunction('Function IcsStrPCopy103( Dest : AnsiChar; const Source : AnsiString) : AnsiChar;');
 CL.AddDelphiFunction('Function IcsStrPLCopy104( Dest : PChar; const Source : String; MaxLen : Cardinal) : PChar;');
 CL.AddDelphiFunction('Function IcsStrPLCopy105( Dest : AnsiChar; const Source : AnsiString; MaxLen : Cardinal) : AnsiChar;');
 CL.AddDelphiFunction('Function IcsStrCompOrdinalW( Str1 : WideChar; Str1Length : Integer; Str2 : WideChar; Str2Length : Integer; IgnoreCase : Boolean) : Integer');
 //CL.AddDelphiFunction('Function RtlCompareUnicodeString( String1 : PUNICODE_STRING; String2 : PUNICODE_STRING; CaseInsensitive : BOOLEAN) : LongInt');
 CL.AddDelphiFunction('Function icsIsDebuggerPresent : BOOL');
  SIRegister_TIcsIntegerList(CL);
  SIRegister_TIcsCriticalSection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIcsIntegerListItems_W(Self: TIcsIntegerList; const T: Integer; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIcsIntegerListItems_R(Self: TIcsIntegerList; var T: Integer; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIcsIntegerListLast_R(Self: TIcsIntegerList; var T: Integer);
begin T := Self.Last; end;

(*----------------------------------------------------------------------------*)
procedure TIcsIntegerListFirst_R(Self: TIcsIntegerList; var T: Integer);
begin T := Self.First; end;

(*----------------------------------------------------------------------------*)
procedure TIcsIntegerListCount_R(Self: TIcsIntegerList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
Function IcsStrPLCopy105_P( Dest : PAnsiChar; const Source : AnsiString; MaxLen : Cardinal) : PAnsiChar;
Begin Result := OverbyteIcsUtils.IcsStrPLCopy(Dest, Source, MaxLen); END;

(*----------------------------------------------------------------------------*)
Function IcsStrPLCopy104_P( Dest : PChar; const Source : String; MaxLen : Cardinal) : PChar;
Begin Result := OverbyteIcsUtils.IcsStrPLCopy(Dest, Source, MaxLen); END;

(*----------------------------------------------------------------------------*)
Function IcsStrPCopy103_P( Dest : PAnsiChar; const Source : AnsiString) : PAnsiChar;
Begin Result := OverbyteIcsUtils.IcsStrPCopy(Dest, Source); END;

(*----------------------------------------------------------------------------*)
Function IcsStrPCopy102_P( Dest : PChar; const Source : string) : PChar;
Begin Result := OverbyteIcsUtils.IcsStrPCopy(Dest, Source); END;


(*----------------------------------------------------------------------------*)
//Function IcsStrCopy101_P( Dest : WideChar; const Source : WideChar) : WideChar;
//Begin Result := OverbyteIcsUtils.IcsStrCopy(Dest, Source); END;

(*----------------------------------------------------------------------------*)
Function IcsStrCopy100_P( Dest : PAnsiChar; const Source : PAnsiChar) : PAnsiChar;
Begin Result := OverbyteIcsUtils.IcsStrCopy(Dest, Source); END;

(*----------------------------------------------------------------------------*)
//Function IcsStrPas99_P( const Str : WideChar) : string;
//Begin Result := OverbyteIcsUtils.IcsStrPas(Str); END;

(*----------------------------------------------------------------------------*)
Function IcsStrPas98_P( const Str : PAnsiChar) : AnsiString;
Begin Result := OverbyteIcsUtils.IcsStrPas(Str); END;

(*----------------------------------------------------------------------------*)
//unction IcsStrLen97_P( const Str : WideChar) : Cardinal;
//Begin Result := OverbyteIcsUtils.IcsStrLen(Str); END;

(*----------------------------------------------------------------------------*)
Function IcsStrLen96_P( const Str : PAnsiChar) : Cardinal;
Begin Result := OverbyteIcsUtils.IcsStrLen(Str); END;

type unicodestring = string;

(*----------------------------------------------------------------------------*)
Function IcsCompareText95_P( const S1, S2 : UnicodeString) : Integer;
Begin Result := OverbyteIcsUtils.IcsCompareText(S1, S2); END;

(*----------------------------------------------------------------------------*)
Function IcsCompareText94_P( const S1, S2 : AnsiString) : Integer;
Begin Result := OverbyteIcsUtils.IcsCompareText(S1, S2); END;



(*----------------------------------------------------------------------------*)
Function IcsCompareStr93_P( const S1, S2 : UnicodeString) : Integer;
Begin Result := OverbyteIcsUtils.IcsCompareStr(S1, S2); END;

(*----------------------------------------------------------------------------*)
Function IcsCompareStr92_P( const S1, S2 : AnsiString) : Integer;
Begin Result := OverbyteIcsUtils.IcsCompareStr(S1, S2); END;

(*----------------------------------------------------------------------------*)
Function IcsUpperCase91_P( const S : UnicodeString) : UnicodeString;
Begin Result := OverbyteIcsUtils.IcsUpperCase(S); END;

(*----------------------------------------------------------------------------*)
Function IcsUpperCase90_P( const S : AnsiString) : AnsiString;
Begin Result := OverbyteIcsUtils.IcsUpperCase(S); END;

(*----------------------------------------------------------------------------*)
Function IcsLowerCase89_P( const S : UnicodeString) : UnicodeString;
Begin Result := OverbyteIcsUtils.IcsLowerCase(S); END;

(*----------------------------------------------------------------------------*)
Function IcsLowerCase88_P( const S : AnsiString) : AnsiString;
Begin Result := OverbyteIcsUtils.IcsLowerCase(S); END;

(*----------------------------------------------------------------------------*)
Function IcsTrim87_P( const Str : UnicodeString) : UnicodeString;
Begin Result := OverbyteIcsUtils.IcsTrim(Str); END;

(*----------------------------------------------------------------------------*)
Function IcsTrim86_P( const Str : AnsiString) : AnsiString;
Begin Result := OverbyteIcsUtils.IcsTrim(Str); END;

(*----------------------------------------------------------------------------*)
Function IcsFileExistsW85_P( const Utf8FileName : UTF8String) : Boolean;
Begin Result := OverbyteIcsUtils.IcsFileExistsW(Utf8FileName); END;

(*----------------------------------------------------------------------------*)
Function IcsFileExistsW84_P( const FileName : UnicodeString) : Boolean;
Begin Result := OverbyteIcsUtils.IcsFileExistsW(FileName); END;

(*----------------------------------------------------------------------------*)
Function IcsFileAgeW83_P( const Utf8FileName : UTF8String) : Integer;
Begin Result := OverbyteIcsUtils.IcsFileAgeW(Utf8FileName); END;

(*----------------------------------------------------------------------------*)
Function IcsFileAgeW82_P( const FileName : UnicodeString) : Integer;
Begin Result := OverbyteIcsUtils.IcsFileAgeW(FileName); END;

(*----------------------------------------------------------------------------*)
Function IcsRemoveDirW81_P( const Utf8Dir : UTF8String) : Boolean;
Begin Result := OverbyteIcsUtils.IcsRemoveDirW(Utf8Dir); END;

(*----------------------------------------------------------------------------*)
Function IcsRemoveDirW80_P( const Dir : UnicodeString) : Boolean;
Begin Result := OverbyteIcsUtils.IcsRemoveDirW(Dir); END;

(*----------------------------------------------------------------------------*)
Function IcsCreateDirW79_P( const Utf8Dir : UTF8String) : Boolean;
Begin Result := OverbyteIcsUtils.IcsCreateDirW(Utf8Dir); END;

(*----------------------------------------------------------------------------*)
Function IcsCreateDirW78_P( const Dir : UnicodeString) : Boolean;
Begin Result := OverbyteIcsUtils.IcsCreateDirW(Dir); END;

(*----------------------------------------------------------------------------*)
Function IcsForceDirectoriesW77_P( Utf8Dir : UTF8String) : Boolean;
Begin Result := OverbyteIcsUtils.IcsForceDirectoriesW(Utf8Dir); END;

(*----------------------------------------------------------------------------*)
Function IcsForceDirectoriesW76_P( Dir : UnicodeString) : Boolean;
Begin Result := OverbyteIcsUtils.IcsForceDirectoriesW(Dir); END;

(*----------------------------------------------------------------------------*)
Function IcsRenameFileW75_P( const Utf8OldName, Utf8NewName : UTF8String) : Boolean;
Begin Result := OverbyteIcsUtils.IcsRenameFileW(Utf8OldName, Utf8NewName); END;

(*----------------------------------------------------------------------------*)
Function IcsRenameFileW74_P( const OldName, NewName : UnicodeString) : Boolean;
Begin Result := OverbyteIcsUtils.IcsRenameFileW(OldName, NewName); END;

(*----------------------------------------------------------------------------*)
Function IcsDeleteFileW73_P( const Utf8FileName : UTF8String) : Boolean;
Begin Result := OverbyteIcsUtils.IcsDeleteFileW(Utf8FileName); END;

(*----------------------------------------------------------------------------*)
Function IcsDeleteFileW72_P( const FileName : UnicodeString) : Boolean;
Begin Result := OverbyteIcsUtils.IcsDeleteFileW(FileName); END;

(*----------------------------------------------------------------------------*)
Function IcsFileSetAttrW71_P( const Utf8FileName : UTF8String; Attr : Integer) : Integer;
Begin Result := OverbyteIcsUtils.IcsFileSetAttrW(Utf8FileName, Attr); END;

(*----------------------------------------------------------------------------*)
Function IcsFileSetAttrW70_P( const FileName : UnicodeString; Attr : Integer) : Integer;
Begin Result := OverbyteIcsUtils.IcsFileSetAttrW(FileName, Attr); END;

(*----------------------------------------------------------------------------*)
Function IcsFileGetAttrW69_P( const Utf8FileName : UTF8String) : Integer;
Begin Result := OverbyteIcsUtils.IcsFileGetAttrW(Utf8FileName); END;

(*----------------------------------------------------------------------------*)
Function IcsFileGetAttrW68_P( const FileName : UnicodeString) : Integer;
Begin Result := OverbyteIcsUtils.IcsFileGetAttrW(FileName); END;

(*----------------------------------------------------------------------------*)
Function IcsExtractLastDir67_P( const Path : UnicodeString) : UnicodeString;
Begin Result := OverbyteIcsUtils.IcsExtractLastDir(Path); END;

type rawbytestring = string;

(*----------------------------------------------------------------------------*)
Function IcsExtractLastDir66_P( const Path : RawByteString) : RawByteString;
Begin Result := OverbyteIcsUtils.IcsExtractLastDir(Path); END;

(*----------------------------------------------------------------------------*)
Function IcsFindFirstW65_P( const Utf8Path : UTF8String; Attr : Integer; var F : TIcsSearchRecW) : Integer;
Begin Result := OverbyteIcsUtils.IcsFindFirstW(Utf8Path, Attr, F); END;

(*----------------------------------------------------------------------------*)
Function IcsFindFirstW64_P( const Path : UnicodeString; Attr : Integer; var F : TIcsSearchRecW) : Integer;
Begin Result := OverbyteIcsUtils.IcsFindFirstW(Path, Attr, F); END;

(*----------------------------------------------------------------------------*)
Function IcsDirExistsW63_P( const Utf8FileName : UTF8String) : Boolean;
Begin Result := OverbyteIcsUtils.IcsDirExistsW(Utf8FileName); END;

(*----------------------------------------------------------------------------*)
Function IcsDirExistsW62_P( const FileName : UnicodeString) : Boolean;
Begin Result := OverbyteIcsUtils.IcsDirExistsW(FileName); END;

(*----------------------------------------------------------------------------*)
Function IcsDirExistsW61_P( const FileName : WideChar) : Boolean;
Begin Result := OverbyteIcsUtils.IcsDirExistsW(FileName); END;

(*----------------------------------------------------------------------------*)
Function IcsAnsiCompareFileNameW60_P( const Utf8S1, Utf8S2 : UTF8String) : Integer;
Begin Result := OverbyteIcsUtils.IcsAnsiCompareFileNameW(Utf8S1, Utf8S2); END;

(*----------------------------------------------------------------------------*)
Function IcsAnsiCompareFileNameW59_P( const S1, S2 : UnicodeString) : Integer;
Begin Result := OverbyteIcsUtils.IcsAnsiCompareFileNameW(S1, S2); END;

(*----------------------------------------------------------------------------*)
Function IcsGetBufferCodepage58_P( Buf : PAnsiChar; ByteCount : Integer; out BOMSize : Integer) : LongWord;
Begin Result := OverbyteIcsUtils.IcsGetBufferCodepage(Buf, ByteCount, BOMSize); END;

(*----------------------------------------------------------------------------*)
Function IcsGetBufferCodepage57_P( Buf : PAnsiChar; ByteCount : Integer) : LongWord;
Begin Result := OverbyteIcsUtils.IcsGetBufferCodepage(Buf, ByteCount); END;

(*----------------------------------------------------------------------------*)
Function IcsNextCharIndex56_P( const S : RawByteString; Index : Integer; ACodePage : LongWord) : Integer;
Begin Result := OverbyteIcsUtils.IcsNextCharIndex(S, Index, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function IcsStrCharLength55_P( const Str : PAnsiChar; ACodePage : LongWord) : Integer;
Begin Result := OverbyteIcsUtils.IcsStrCharLength(Str, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function stpblk54_P( PValue : PAnsiChar) : PAnsiChar;
Begin Result := OverbyteIcsUtils.stpblk(PValue); END;

(*----------------------------------------------------------------------------*)
Function stpblk53_P( PValue : PWideChar) : PWideChar;
Begin Result := OverbyteIcsUtils.stpblk(PValue); END;

(*----------------------------------------------------------------------------*)
Function IsSpaceOrCRLF52_P( Ch : AnsiChar) : Boolean;
Begin Result := OverbyteIcsUtils.IsSpaceOrCRLF(Ch); END;

(*----------------------------------------------------------------------------*)
Function IsSpaceOrCRLF51_P( Ch : WideChar) : Boolean;
Begin Result := OverbyteIcsUtils.IsSpaceOrCRLF(Ch); END;

(*----------------------------------------------------------------------------*)
Function IsCRLF50_P( Ch : AnsiChar) : Boolean;
Begin Result := OverbyteIcsUtils.IsCRLF(Ch); END;

(*----------------------------------------------------------------------------*)
Function IsCRLF49_P( Ch : WideChar) : Boolean;
Begin Result := OverbyteIcsUtils.IsCRLF(Ch); END;

(*----------------------------------------------------------------------------*)
Function IsSpace48_P( Ch : AnsiChar) : Boolean;
Begin Result := OverbyteIcsUtils.IsSpace(Ch); END;

(*----------------------------------------------------------------------------*)
Function IsSpace47_P( Ch : WideChar) : Boolean;
Begin Result := OverbyteIcsUtils.IsSpace(Ch); END;

(*----------------------------------------------------------------------------*)
Function IsDigit46_P( Ch : AnsiChar) : Boolean;
Begin Result := OverbyteIcsUtils.IsDigit(Ch); END;

(*----------------------------------------------------------------------------*)
Function IsDigit45_P( Ch : WideChar) : Boolean;
Begin Result := OverbyteIcsUtils.IsDigit(Ch); END;

(*----------------------------------------------------------------------------*)
Function IsCharInSysCharSet44_P( Ch : AnsiChar; const ASet : TSysCharSet) : Boolean;
Begin Result := OverbyteIcsUtils.IsCharInSysCharSet(Ch, ASet); END;

(*----------------------------------------------------------------------------*)
Function IsCharInSysCharSet43_P( Ch : WideChar; const ASet : TSysCharSet) : Boolean;
Begin Result := OverbyteIcsUtils.IsCharInSysCharSet(Ch, ASet); END;

(*----------------------------------------------------------------------------*)
Function XDigit42_P( Ch : AnsiChar) : Integer;
Begin Result := OverbyteIcsUtils.XDigit(Ch); END;

(*----------------------------------------------------------------------------*)
Function XDigit41_P( Ch : WideChar) : Integer;
Begin Result := OverbyteIcsUtils.XDigit(Ch); END;

(*----------------------------------------------------------------------------*)
Function IsXDigit40_P( Ch : AnsiChar) : Boolean;
Begin Result := OverbyteIcsUtils.IsXDigit(Ch); END;

(*----------------------------------------------------------------------------*)
Function IsXDigit39_P( Ch : WideChar) : Boolean;
Begin Result := OverbyteIcsUtils.IsXDigit(Ch); END;

(*----------------------------------------------------------------------------*)
Function IcsBufferToHex38_P( const Buf, Size : Integer; Separator : Char) : String;
Begin Result := OverbyteIcsUtils.IcsBufferToHex(Buf, Size, Separator); END;

(*----------------------------------------------------------------------------*)
Function IcsBufferToHex37_P( const Buf, Size : Integer) : String;
Begin Result := OverbyteIcsUtils.IcsBufferToHex(Buf, Size); END;

(*----------------------------------------------------------------------------*)
Function htoi236_P( value : PAnsiChar) : Integer;
Begin Result := OverbyteIcsUtils.htoi2(value); END;

(*----------------------------------------------------------------------------*)
Function htoi235_P( value : PWideChar) : Integer;
Begin Result := OverbyteIcsUtils.htoi2(value); END;

(*----------------------------------------------------------------------------*)
Function htoin34_P( Value : PAnsiChar; Len : Integer) : Integer;
Begin Result := OverbyteIcsUtils.htoin(Value, Len); END;

(*----------------------------------------------------------------------------*)
Function htoin33_P( Value : PWideChar; Len : Integer) : Integer;
Begin Result := OverbyteIcsUtils.htoin(Value, Len); END;

(*----------------------------------------------------------------------------*)
Function CharsetDetect32_P( const Str : RawByteString) : TCharsetDetectResult;
Begin Result := OverbyteIcsUtils.CharsetDetect(Str); END;

(*----------------------------------------------------------------------------*)
Function CharsetDetect31_P( const Buf : Pointer; Len : Integer) : TCharsetDetectResult;
Begin Result := OverbyteIcsUtils.CharsetDetect(Buf, Len); END;

(*----------------------------------------------------------------------------*)
Function IsUtf8Valid30_P( const Buf : Pointer; Len : Integer) : Boolean;
Begin Result := OverbyteIcsUtils.IsUtf8Valid(Buf, Len); END;

(*----------------------------------------------------------------------------*)
Function IsUtf8Valid29_P( const Str : RawByteString) : Boolean;
Begin Result := OverbyteIcsUtils.IsUtf8Valid(Str); END;

(*----------------------------------------------------------------------------*)
Function StringToUtf828_P( const Str : RawByteString; ACodePage : LongWord) : RawByteString;
Begin Result := OverbyteIcsUtils.StringToUtf8(Str, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function StringToUtf827_P( const Str : UnicodeString) : RawByteString;
Begin Result := OverbyteIcsUtils.StringToUtf8(Str); END;

(*----------------------------------------------------------------------------*)
Function atoi6426_P( const Str : UnicodeString) : Int64;
Begin Result := OverbyteIcsUtils.atoi64(Str); END;

(*----------------------------------------------------------------------------*)
Function atoi6425_P( const Str : RawByteString) : Int64;
Begin Result := OverbyteIcsUtils.atoi64(Str); END;

(*----------------------------------------------------------------------------*)
Function atoi24_P( const Str : UnicodeString) : Integer;
Begin Result := OverbyteIcsUtils.atoi(Str); END;

(*----------------------------------------------------------------------------*)
Function atoi23_P( const Str : RawByteString) : Integer;
Begin Result := OverbyteIcsUtils.atoi(Str); END;

(*----------------------------------------------------------------------------*)
Function IsUsAscii22_P( const Str : UnicodeString) : Boolean;
Begin Result := OverbyteIcsUtils.IsUsAscii(Str); END;

(*----------------------------------------------------------------------------*)
Function IsUsAscii21_P( const Str : RawByteString) : Boolean;
Begin Result := OverbyteIcsUtils.IsUsAscii(Str); END;

(*----------------------------------------------------------------------------*)
Function StreamWriteString20_P( AStream : TStream; const Str : UnicodeString) : Integer;
Begin Result := OverbyteIcsUtils.StreamWriteString(AStream, Str); END;

(*----------------------------------------------------------------------------*)
Function StreamWriteString19_P( AStream : TStream; const Str : UnicodeString; ACodePage : LongWord) : Integer;
Begin Result := OverbyteIcsUtils.StreamWriteString(AStream, Str, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function StreamWriteString18_P( AStream : TStream; const Str : UnicodeString; ACodePage : LongWord; WriteBOM : Boolean) : Integer;
Begin Result := OverbyteIcsUtils.StreamWriteString(AStream, Str, ACodePage, WriteBOM); END;

(*----------------------------------------------------------------------------*)
Function StreamWriteString17_P( AStream : TStream; Str : PWideChar; cLen : Integer; ACodePage : LongWord) : Integer;
Begin Result := OverbyteIcsUtils.StreamWriteString(AStream, Str, cLen, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function StreamWriteString16_P( AStream : TStream; Str : PWideChar; cLen : Integer; ACodePage : LongWord; WriteBOM : Boolean) : Integer;
Begin Result := OverbyteIcsUtils.StreamWriteString(AStream, Str, cLen, ACodePage, WriteBOM); END;

(*----------------------------------------------------------------------------*)
Function IcsBufferToUnicode15_P( const Buffer, BufferSize : Integer; BufferCodePage : LongWord; RaiseFailedBytes : Boolean) : UnicodeString;
Begin Result := OverbyteIcsUtils.IcsBufferToUnicode(Buffer, BufferSize, BufferCodePage, RaiseFailedBytes); END;

(*----------------------------------------------------------------------------*)
Function IcsBufferToUnicode14_P( const Buffer, BufferSize : Integer; BufferCodePage : LongWord; out FailedByteCount : Integer) : UnicodeString;
Begin Result := OverbyteIcsUtils.IcsBufferToUnicode(Buffer, BufferSize, BufferCodePage, FailedByteCount); END;

(*----------------------------------------------------------------------------*)
Function AnsiToUnicode13_P( const Str : RawByteString) : UnicodeString;
Begin Result := OverbyteIcsUtils.AnsiToUnicode(Str); END;

(*----------------------------------------------------------------------------*)
Function AnsiToUnicode12_P( const Str : RawByteString; ACodePage : LongWord) : UnicodeString;
Begin Result := OverbyteIcsUtils.AnsiToUnicode(Str, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function AnsiToUnicode11_P( const Str : PAnsiChar; ACodePage : LongWord) : UnicodeString;
Begin Result := OverbyteIcsUtils.AnsiToUnicode(Str, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function UnicodeToAnsi10_P( const Str : UnicodeString) : RawByteString;
Begin Result := OverbyteIcsUtils.UnicodeToAnsi(Str); END;

(*----------------------------------------------------------------------------*)
Function UnicodeToAnsi9_P( const Str : UnicodeString; ACodePage : LongWord; SetCodePage : Boolean) : RawByteString;
Begin Result := OverbyteIcsUtils.UnicodeToAnsi(Str, ACodePage, SetCodePage); END;

(*----------------------------------------------------------------------------*)
Function UnicodeToAnsi8_P( const Str : WideChar; ACodePage : LongWord; SetCodePage : Boolean) : RawByteString;
Begin Result := OverbyteIcsUtils.UnicodeToAnsi(Str, ACodePage, SetCodePage); END;

(*----------------------------------------------------------------------------*)
Function UsAsciiToUnicode7_P( const Str : RawByteString) : UnicodeString;
Begin Result := OverbyteIcsUtils.UsAsciiToUnicode(Str); END;

(*----------------------------------------------------------------------------*)
Function UsAsciiToUnicode6_P( const Str : RawByteString; FailCh : AnsiChar) : UnicodeString;
Begin Result := OverbyteIcsUtils.UsAsciiToUnicode(Str, FailCh); END;

(*----------------------------------------------------------------------------*)
Function UnicodeToUsAscii5_P( const Str : UnicodeString) : AnsiString;
Begin Result := OverbyteIcsUtils.UnicodeToUsAscii(Str); END;

(*----------------------------------------------------------------------------*)
Function UnicodeToUsAscii4_P( const Str : UnicodeString; FailCh : AnsiChar) : AnsiString;
Begin Result := OverbyteIcsUtils.UnicodeToUsAscii(Str, FailCh); END;

(*----------------------------------------------------------------------------*)
procedure TIcsFileStreamWFileName_R(Self: TIcsFileStreamW; var T: UnicodeString);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
Function TIcsFileStreamWCreate3_P(Self: TClass; CreateNewInstance: Boolean;  const Utf8FileName : UTF8String; Mode : Word; Rights : Cardinal):TObject;
Begin Result := TIcsFileStreamW.Create(Utf8FileName, Mode, Rights); END;

(*----------------------------------------------------------------------------*)
Function TIcsFileStreamWCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const Utf8FileName : UTF8String; Mode : Word):TObject;
Begin Result := TIcsFileStreamW.Create(Utf8FileName, Mode); END;

(*----------------------------------------------------------------------------*)
Function TIcsFileStreamWCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const FileName : UnicodeString; Mode : Word; Rights : Cardinal):TObject;
Begin Result := TIcsFileStreamW.Create(FileName, Mode, Rights); END;

(*----------------------------------------------------------------------------*)
Function TIcsFileStreamWCreate_P(Self: TClass; CreateNewInstance: Boolean;  const FileName : UnicodeString; Mode : Word):TObject;
Begin Result := TIcsFileStreamW.Create(FileName, Mode); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIcsCriticalSection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIcsCriticalSection) do begin
    RegisterConstructor(@TIcsCriticalSection.Create, 'Create');
    RegisterMethod(@TIcsCriticalSection.Destroy, 'Free');
    RegisterMethod(@TIcsCriticalSection.Enter, 'Enter');
    RegisterMethod(@TIcsCriticalSection.Leave, 'Leave');
    RegisterMethod(@TIcsCriticalSection.TryEnter, 'TryEnter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIcsIntegerList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIcsIntegerList) do begin
    //RegisterVirtualConstructor(@TIcsIntegerList.Create, 'Create');
     RegisterConstructor(@TIcsIntegerList.Create, 'Create');
    RegisterMethod(@TIcsIntegerList.Destroy, 'Free');
    RegisterMethod(@TIcsIntegerList.IndexOf, 'IndexOf');
    RegisterVirtualMethod(@TIcsIntegerList.Add, 'Add');
    RegisterVirtualMethod(@TIcsIntegerList.Assign, 'Assign');
    RegisterVirtualMethod(@TIcsIntegerList.Clear, 'Clear');
    RegisterVirtualMethod(@TIcsIntegerList.Delete, 'Delete');
    RegisterPropertyHelper(@TIcsIntegerListCount_R,nil,'Count');
    RegisterPropertyHelper(@TIcsIntegerListFirst_R,nil,'First');
    RegisterPropertyHelper(@TIcsIntegerListLast_R,nil,'Last');
    RegisterPropertyHelper(@TIcsIntegerListItems_R,@TIcsIntegerListItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_OverbyteIcsUtils_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@IcsIconvNameFromCodePage, 'IcsIconvNameFromCodePage', cdRegister);
 S.RegisterDelphiFunction(@IcsIsValidAnsiCodePage, 'IcsIsValidAnsiCodePage', cdRegister);
 S.RegisterDelphiFunction(@IcsCharLowerA, 'IcsCharLowerA', cdRegister);
 S.RegisterDelphiFunction(@IcsGetCurrentThreadID, 'IcsGetCurrentThreadID', cdRegister);
 S.RegisterDelphiFunction(@IcsGetFreeDiskSpace, 'IcsGetFreeDiskSpace', cdRegister);
 S.RegisterDelphiFunction(@IcsGetLocalTimeZoneBias, 'IcsGetLocalTimeZoneBias', cdRegister);
 S.RegisterDelphiFunction(@IcsDateTimeToUTC, 'IcsDateTimeToUTC', cdRegister);
 S.RegisterDelphiFunction(@IcsUTCToDateTime, 'IcsUTCToDateTime', cdRegister);
 S.RegisterDelphiFunction(@IcsGetTickCount, 'IcsGetTickCount', cdRegister);
 S.RegisterDelphiFunction(@IcsWcToMb, 'IcsWcToMb', cdRegister);
 S.RegisterDelphiFunction(@IcsMbToWc, 'IcsMbToWc', cdRegister);
 S.RegisterDelphiFunction(@IcsGetDefaultWindowsUnicodeChar, 'IcsGetDefaultWindowsUnicodeChar', cdRegister);
 S.RegisterDelphiFunction(@IcsGetDefaultWindowsAnsiChar, 'IcsGetDefaultWindowsAnsiChar', cdRegister);
 S.RegisterDelphiFunction(@IcsGetAcp, 'IcsGetAcp', cdRegister);
 S.RegisterDelphiFunction(@IcsIsDBCSCodePage, 'IcsIsDBCSCodePage', cdRegister);
 S.RegisterDelphiFunction(@IcsIsDBCSLeadByte, 'IcsIsDBCSLeadByte', cdRegister);
 S.RegisterDelphiFunction(@IcsIsMBCSCodePage, 'IcsIsMBCSCodePage', cdRegister);
 S.RegisterDelphiFunction(@IcsIsSBCSCodePage, 'IcsIsSBCSCodePage', cdRegister);
 S.RegisterDelphiFunction(@IcsGetLeadBytes, 'IcsGetLeadBytes', cdRegister);
 S.RegisterDelphiFunction(@UnicodeToUsAscii4_P, 'icsUnicodeToUsAscii4', cdRegister);
 S.RegisterDelphiFunction(@UnicodeToUsAscii5_P, 'icsUnicodeToUsAscii5', cdRegister);
 S.RegisterDelphiFunction(@UsAsciiToUnicode6_P, 'icsUsAsciiToUnicode6', cdRegister);
 S.RegisterDelphiFunction(@UsAsciiToUnicode7_P, 'icsUsAsciiToUnicode7', cdRegister);
 S.RegisterDelphiFunction(@UnicodeToAnsi8_P, 'icsUnicodeToAnsi8', cdRegister);
 S.RegisterDelphiFunction(@UnicodeToAnsi9_P, 'icsUnicodeToAnsi9', cdRegister);
 S.RegisterDelphiFunction(@UnicodeToAnsi10_P, 'icsUnicodeToAnsi10', cdRegister);
 S.RegisterDelphiFunction(@AnsiToUnicode11_P, 'icsAnsiToUnicode11', cdRegister);
 S.RegisterDelphiFunction(@AnsiToUnicode12_P, 'icsAnsiToUnicode12', cdRegister);
 S.RegisterDelphiFunction(@AnsiToUnicode13_P, 'icsAnsiToUnicode13', cdRegister);
 S.RegisterDelphiFunction(@IcsBufferToUnicode14_P, 'IcsBufferToUnicode14', cdRegister);
 S.RegisterDelphiFunction(@IcsBufferToUnicode15_P, 'IcsBufferToUnicode15', cdRegister);
 S.RegisterDelphiFunction(@IcsGetWideCharCount, 'IcsGetWideCharCount', cdRegister);
 S.RegisterDelphiFunction(@IcsGetWideChars, 'IcsGetWideChars', cdRegister);
 S.RegisterDelphiFunction(@StreamWriteString16_P, 'icsStreamWriteString16', cdRegister);
 S.RegisterDelphiFunction(@StreamWriteString17_P, 'icsStreamWriteString17', cdRegister);
 S.RegisterDelphiFunction(@StreamWriteString18_P, 'icsStreamWriteString18', cdRegister);
 S.RegisterDelphiFunction(@StreamWriteString19_P, 'icsStreamWriteString19', cdRegister);
 S.RegisterDelphiFunction(@StreamWriteString20_P, 'icsStreamWriteString20', cdRegister);
 S.RegisterDelphiFunction(@IsUsAscii21_P, 'icsIsUsAscii21', cdRegister);
 S.RegisterDelphiFunction(@IsUsAscii22_P, 'icsIsUsAscii22', cdRegister);
 S.RegisterDelphiFunction(@IcsAppendStr, 'IcsAppendStr', cdRegister);
 S.RegisterDelphiFunction(@atoi23_P, 'icsatoi23', cdRegister);
 S.RegisterDelphiFunction(@atoi24_P, 'icsatoi24', cdRegister);
 S.RegisterDelphiFunction(@atoi6425_P, 'icsatoi6425', cdRegister);
 S.RegisterDelphiFunction(@atoi6426_P, 'icsatoi6426', cdRegister);
 S.RegisterDelphiFunction(@IcsCalcTickDiff, 'IcsCalcTickDiff', cdRegister);
 S.RegisterDelphiFunction(@StringToUtf827_P, 'icsStringToUtf827', cdRegister);
 S.RegisterDelphiFunction(@StringToUtf828_P, 'icsStringToUtf828', cdRegister);
 S.RegisterDelphiFunction(@Utf8ToStringW, 'icsUtf8ToStringW', cdRegister);
 S.RegisterDelphiFunction(@Utf8ToStringA, 'icsUtf8ToStringA', cdRegister);
 S.RegisterDelphiFunction(@CheckUnicodeToAnsi, 'icsCheckUnicodeToAnsi', cdRegister);
 S.RegisterDelphiFunction(@IsUtf8TrailByte, 'icsIsUtf8TrailByte', cdRegister);
 S.RegisterDelphiFunction(@IsUtf8LeadByte, 'icsIsUtf8LeadByte', cdRegister);
 S.RegisterDelphiFunction(@IcsUtf8Size, 'IcsUtf8Size', cdRegister);
 S.RegisterDelphiFunction(@IsLeadChar, 'icsIsLeadChar', cdRegister);
 S.RegisterDelphiFunction(@IsUtf8Valid29_P, 'icsIsUtf8Valid29', cdRegister);
 S.RegisterDelphiFunction(@IsUtf8Valid30_P, 'icsIsUtf8Valid30', cdRegister);
 S.RegisterDelphiFunction(@CharsetDetect31_P, 'icsCharsetDetect31', cdRegister);
 S.RegisterDelphiFunction(@CharsetDetect32_P, 'icsCharsetDetect32', cdRegister);
 S.RegisterDelphiFunction(@IcsCharNextUtf8, 'IcsCharNextUtf8', cdRegister);
 S.RegisterDelphiFunction(@IcsCharPrevUtf8, 'IcsCharPrevUtf8', cdRegister);
 S.RegisterDelphiFunction(@ConvertCodepage, 'icsConvertCodepage', cdRegister);
 S.RegisterDelphiFunction(@htoin33_P, 'icshtoin33', cdRegister);
 S.RegisterDelphiFunction(@htoin34_P, 'icshtoin34', cdRegister);
 S.RegisterDelphiFunction(@htoi235_P, 'icshtoi235', cdRegister);
 S.RegisterDelphiFunction(@htoi236_P, 'icshtoi236', cdRegister);
 S.RegisterDelphiFunction(@IcsBufferToHex37_P, 'IcsBufferToHex37', cdRegister);
 S.RegisterDelphiFunction(@IcsBufferToHex38_P, 'IcsBufferToHex38', cdRegister);
 S.RegisterDelphiFunction(@IsXDigit39_P, 'icsIsXDigit39', cdRegister);
 S.RegisterDelphiFunction(@IsXDigit40_P, 'icsIsXDigit40', cdRegister);
 S.RegisterDelphiFunction(@XDigit41_P, 'icsXDigit41', cdRegister);
 S.RegisterDelphiFunction(@XDigit42_P, 'icsXDigit42', cdRegister);
 S.RegisterDelphiFunction(@IsCharInSysCharSet43_P, 'icsIsCharInSysCharSet43', cdRegister);
 S.RegisterDelphiFunction(@IsCharInSysCharSet44_P, 'icsIsCharInSysCharSet44', cdRegister);
 S.RegisterDelphiFunction(@IsDigit45_P, 'icsIsDigit45', cdRegister);
 S.RegisterDelphiFunction(@IsDigit46_P, 'icsIsDigit46', cdRegister);
 S.RegisterDelphiFunction(@IsSpace47_P, 'icsIsSpace47', cdRegister);
 S.RegisterDelphiFunction(@IsSpace48_P, 'icsIsSpace48', cdRegister);
 S.RegisterDelphiFunction(@IsCRLF49_P, 'icsIsCRLF49', cdRegister);
 S.RegisterDelphiFunction(@IsCRLF50_P, 'icsIsCRLF50', cdRegister);
 S.RegisterDelphiFunction(@IsSpaceOrCRLF51_P, 'icsIsSpaceOrCRLF51', cdRegister);
 S.RegisterDelphiFunction(@IsSpaceOrCRLF52_P, 'icsIsSpaceOrCRLF52', cdRegister);
 S.RegisterDelphiFunction(@XDigit2, 'icsXDigit2', cdRegister);
 S.RegisterDelphiFunction(@stpblk53_P, 'icsstpblk53', cdRegister);
 S.RegisterDelphiFunction(@stpblk54_P, 'icsstpblk54', cdRegister);
 S.RegisterDelphiFunction(@IcsStrNextChar, 'IcsStrNextChar', cdRegister);
 S.RegisterDelphiFunction(@IcsStrPrevChar, 'IcsStrPrevChar', cdRegister);
 S.RegisterDelphiFunction(@IcsStrCharLength55_P, 'IcsStrCharLength55', cdRegister);
 S.RegisterDelphiFunction(@IcsNextCharIndex56_P, 'IcsNextCharIndex56', cdRegister);
 S.RegisterDelphiFunction(@IcsGetBomBytes, 'IcsGetBomBytes', cdRegister);
 S.RegisterDelphiFunction(@IcsGetBufferCodepage57_P, 'IcsGetBufferCodepage57', cdRegister);
 S.RegisterDelphiFunction(@IcsGetBufferCodepage58_P, 'IcsGetBufferCodepage58', cdRegister);
 S.RegisterDelphiFunction(@IcsSwap16, 'IcsSwap16', cdRegister);
 S.RegisterDelphiFunction(@IcsSwap16Buf, 'IcsSwap16Buf', cdRegister);
 S.RegisterDelphiFunction(@IcsSwap32, 'IcsSwap32', cdRegister);
 S.RegisterDelphiFunction(@IcsSwap32Buf, 'IcsSwap32Buf', cdRegister);
 S.RegisterDelphiFunction(@IcsSwap64, 'IcsSwap64', cdRegister);
 S.RegisterDelphiFunction(@IcsSwap64Buf, 'IcsSwap64Buf', cdRegister);
 S.RegisterDelphiFunction(@IcsNameThreadForDebugging, 'IcsNameThreadForDebugging', cdRegister);
 S.RegisterDelphiFunction(@IcsNormalizeString, 'IcsNormalizeString', cdRegister);
 S.RegisterDelphiFunction(@IcsCryptGenRandom, 'IcsCryptGenRandom', cdRegister);
 S.RegisterDelphiFunction(@IcsRandomInt, 'IcsRandomInt', cdRegister);
 S.RegisterDelphiFunction(@IcsFileUtcModified, 'IcsFileUtcModified', cdRegister);
 S.RegisterDelphiFunction(@IcsInterlockedCompareExchange, 'IcsInterlockedCompareExchange', cdRegister);
 S.RegisterDelphiFunction(@IcsExtractFilePathW, 'IcsExtractFilePathW', cdRegister);
 S.RegisterDelphiFunction(@IcsExtractFileDirW, 'IcsExtractFileDirW', cdRegister);
 S.RegisterDelphiFunction(@IcsExtractFileDriveW, 'IcsExtractFileDriveW', cdRegister);
 S.RegisterDelphiFunction(@IcsExtractFileNameW, 'IcsExtractFileNameW', cdRegister);
 S.RegisterDelphiFunction(@IcsExtractFileExtW, 'IcsExtractFileExtW', cdRegister);
 S.RegisterDelphiFunction(@IcsExpandFileNameW, 'IcsExpandFileNameW', cdRegister);
 S.RegisterDelphiFunction(@IcsExtractNameOnlyW, 'IcsExtractNameOnlyW', cdRegister);
 S.RegisterDelphiFunction(@IcsChangeFileExtW, 'IcsChangeFileExtW', cdRegister);
 S.RegisterDelphiFunction(@IcsStrAllocW, 'IcsStrAllocW', cdRegister);
 S.RegisterDelphiFunction(@IcsStrLenW, 'IcsStrLenW', cdRegister);
 S.RegisterDelphiFunction(@IcsAnsiCompareFileNameW59_P, 'IcsAnsiCompareFileNameW59', cdRegister);
 S.RegisterDelphiFunction(@IcsAnsiCompareFileNameW60_P, 'IcsAnsiCompareFileNameW60', cdRegister);
 S.RegisterDelphiFunction(@IcsDirExistsW61_P, 'IcsDirExistsW61', cdRegister);
 S.RegisterDelphiFunction(@IcsDirExistsW62_P, 'IcsDirExistsW62', cdRegister);
 S.RegisterDelphiFunction(@IcsDirExistsW63_P, 'IcsDirExistsW63', cdRegister);
 S.RegisterDelphiFunction(@IcsFindFirstW64_P, 'IcsFindFirstW64', cdRegister);
 S.RegisterDelphiFunction(@IcsFindFirstW65_P, 'IcsFindFirstW65', cdRegister);
 S.RegisterDelphiFunction(@IcsFindCloseW, 'IcsFindCloseW', cdRegister);
 S.RegisterDelphiFunction(@IcsFindNextW, 'IcsFindNextW', cdRegister);
 S.RegisterDelphiFunction(@IcsIncludeTrailingPathDelimiterW, 'IcsIncludeTrailingPathDelimiterW', cdRegister);
 S.RegisterDelphiFunction(@IcsExcludeTrailingPathDelimiterW, 'IcsExcludeTrailingPathDelimiterW', cdRegister);
 S.RegisterDelphiFunction(@IcsExtractLastDir66_P, 'IcsExtractLastDir66', cdRegister);
 S.RegisterDelphiFunction(@IcsExtractLastDir67_P, 'IcsExtractLastDir67', cdRegister);
 S.RegisterDelphiFunction(@IcsFileGetAttrW68_P, 'IcsFileGetAttrW68', cdRegister);
 S.RegisterDelphiFunction(@IcsFileGetAttrW69_P, 'IcsFileGetAttrW69', cdRegister);
 S.RegisterDelphiFunction(@IcsFileSetAttrW70_P, 'IcsFileSetAttrW70', cdRegister);
 S.RegisterDelphiFunction(@IcsFileSetAttrW71_P, 'IcsFileSetAttrW71', cdRegister);
 S.RegisterDelphiFunction(@IcsDeleteFileW72_P, 'IcsDeleteFileW72', cdRegister);
 S.RegisterDelphiFunction(@IcsDeleteFileW73_P, 'IcsDeleteFileW73', cdRegister);
 S.RegisterDelphiFunction(@IcsRenameFileW74_P, 'IcsRenameFileW74', cdRegister);
 S.RegisterDelphiFunction(@IcsRenameFileW75_P, 'IcsRenameFileW75', cdRegister);
 S.RegisterDelphiFunction(@IcsForceDirectoriesW76_P, 'IcsForceDirectoriesW76', cdRegister);
 S.RegisterDelphiFunction(@IcsForceDirectoriesW77_P, 'IcsForceDirectoriesW77', cdRegister);
 S.RegisterDelphiFunction(@IcsCreateDirW78_P, 'IcsCreateDirW78', cdRegister);
 S.RegisterDelphiFunction(@IcsCreateDirW79_P, 'IcsCreateDirW79', cdRegister);
 S.RegisterDelphiFunction(@IcsRemoveDirW80_P, 'IcsRemoveDirW80', cdRegister);
 S.RegisterDelphiFunction(@IcsRemoveDirW81_P, 'IcsRemoveDirW81', cdRegister);
 S.RegisterDelphiFunction(@IcsFileAgeW82_P, 'IcsFileAgeW82', cdRegister);
 S.RegisterDelphiFunction(@IcsFileAgeW83_P, 'IcsFileAgeW83', cdRegister);
 S.RegisterDelphiFunction(@IcsFileExistsW84_P, 'IcsFileExistsW84', cdRegister);
 S.RegisterDelphiFunction(@IcsFileExistsW85_P, 'IcsFileExistsW85', cdRegister);
 S.RegisterDelphiFunction(@IcsAnsiLowerCaseW, 'IcsAnsiLowerCaseW', cdRegister);
 S.RegisterDelphiFunction(@IcsAnsiUpperCaseW, 'IcsAnsiUpperCaseW', cdRegister);
 S.RegisterDelphiFunction(@IcsMakeWord, 'IcsMakeWord', cdRegister);
 S.RegisterDelphiFunction(@IcsMakeLong, 'IcsMakeLong', cdRegister);
 S.RegisterDelphiFunction(@IcsHiWord, 'IcsHiWord', cdRegister);
 S.RegisterDelphiFunction(@IcsHiByte, 'IcsHiByte', cdRegister);
 S.RegisterDelphiFunction(@IcsLoByte, 'IcsLoByte', cdRegister);
 S.RegisterDelphiFunction(@IcsLoWord, 'IcsLoWord', cdRegister);
 S.RegisterDelphiFunction(@IcsCheckOSError, 'IcsCheckOSError', cdRegister);
 S.RegisterDelphiFunction(@IcsIntToStrA, 'IcsIntToStrA', cdRegister);
 S.RegisterDelphiFunction(@IcsIntToHexA, 'IcsIntToHexA', cdRegister);
 S.RegisterDelphiFunction(@IcsTrim86_P, 'IcsTrim86', cdRegister);
 S.RegisterDelphiFunction(@IcsTrim87_P, 'IcsTrim87', cdRegister);
 S.RegisterDelphiFunction(@IcsLowerCase88_P, 'IcsLowerCase88', cdRegister);
 S.RegisterDelphiFunction(@IcsLowerCase89_P, 'IcsLowerCase89', cdRegister);
 S.RegisterDelphiFunction(@IcsUpperCase90_P, 'IcsUpperCase90', cdRegister);
 S.RegisterDelphiFunction(@IcsUpperCase91_P, 'IcsUpperCase91', cdRegister);
 S.RegisterDelphiFunction(@IcsUpperCaseA, 'IcsUpperCaseA', cdRegister);
 S.RegisterDelphiFunction(@IcsLowerCaseA, 'IcsLowerCaseA', cdRegister);
 S.RegisterDelphiFunction(@IcsCompareTextA, 'IcsCompareTextA', cdRegister);
 S.RegisterDelphiFunction(@IcsTrimA, 'IcsTrimA', cdRegister);
 S.RegisterDelphiFunction(@IcsSameTextA, 'IcsSameTextA', cdRegister);
 S.RegisterDelphiFunction(@IcsCompareStr92_P, 'IcsCompareStr92', cdRegister);
 S.RegisterDelphiFunction(@IcsCompareStr93_P, 'IcsCompareStr93', cdRegister);
 S.RegisterDelphiFunction(@IcsCompareText94_P, 'IcsCompareText94', cdRegister);
 S.RegisterDelphiFunction(@IcsCompareText95_P, 'IcsCompareText95', cdRegister);
 S.RegisterDelphiFunction(@IcsStrLen96_P, 'IcsStrLen96', cdRegister);
 //S.RegisterDelphiFunction(@IcsStrLen97_P, 'IcsStrLen97', cdRegister);
 S.RegisterDelphiFunction(@IcsStrPas98_P, 'IcsStrPas98', cdRegister);
 //S.RegisterDelphiFunction(@IcsStrPas99_P, 'IcsStrPas99', cdRegister);
 S.RegisterDelphiFunction(@IcsStrCopy100_P, 'IcsStrCopy100', cdRegister);
 //S.RegisterDelphiFunction(@IcsStrCopy101_P, 'IcsStrCopy101', cdRegister);
 S.RegisterDelphiFunction(@IcsStrPCopy102_P, 'IcsStrPCopy102', cdRegister);
 S.RegisterDelphiFunction(@IcsStrPCopy103_P, 'IcsStrPCopy103', cdRegister);
 S.RegisterDelphiFunction(@IcsStrPLCopy104_P, 'IcsStrPLCopy104', cdRegister);
 S.RegisterDelphiFunction(@IcsStrPLCopy105_P, 'IcsStrPLCopy105', cdRegister);
 S.RegisterDelphiFunction(@IcsStrCompOrdinalW, 'IcsStrCompOrdinalW', cdRegister);
 S.RegisterDelphiFunction(@RtlCompareUnicodeString, 'icsRtlCompareUnicodeString', CdStdCall);
 S.RegisterDelphiFunction(@IsDebuggerPresent, 'icsIsDebuggerPresent', CdStdCall);
  //RIRegister_TIcsIntegerList(CL);
  //RIRegister_TIcsCriticalSection(CL);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIcsFileStreamW(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIcsFileStreamW) do begin
    RegisterConstructor(@TIcsFileStreamWCreate_P, 'Create');
    RegisterConstructor(@TIcsFileStreamWCreate1_P, 'Create1');
    RegisterConstructor(@TIcsFileStreamWCreate2_P, 'Create2');
    RegisterConstructor(@TIcsFileStreamWCreate3_P, 'Create3');
    RegisterMethod(@TIcsFileStreamW.Destroy, 'Free');
    RegisterPropertyHelper(@TIcsFileStreamWFileName_R,nil,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_OverbyteIcsUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EIcsStringConvertError) do
  RIRegister_TIcsFileStreamW(CL);
  RIRegister_TIcsIntegerList(CL);
  RIRegister_TIcsCriticalSection(CL);
end;

 
 
{ TPSImport_OverbyteIcsUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OverbyteIcsUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OverbyteIcsUtils(ri);
  RIRegister_OverbyteIcsUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
