unit uPSI_DIUtils;
{
UnitParser. Components of ROPS are used in the construction of UnitParser,

}
interface
 

 
{uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ; }
 
{type 
(*----------------------------------------------------------------------------*)
  TPSImport_DIUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri:TPSRuntimeClassImporter);override;
  end;
 }
 
{ compile-time registration functions }
//procedure SIRegister_TWideStrBuf(CL: TPSPascalCompiler);
//procedure SIRegister_TMT19937(CL: TPSPascalCompiler);
//procedure SIRegister_DIUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
//procedure RIRegister_DIUtils_Routines(S: TPSExec);
//procedure RIRegister_TWideStrBuf(CL: TPSRuntimeClassImporter);
//procedure RIRegister_TMT19937(CL: TPSRuntimeClassImporter);
//procedure RIRegister_DIUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


{uses
   DISystemCompat
  ,Windows
  ,ShlObj
  ,DIUtils
  ; }
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_DIUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
{procedure SIRegister_TWideStrBuf(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TWideStrBuf') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TWideStrBuf') do
  begin
    RegisterMethod('Procedure AddBuf( const Buf : PWideChar; const Count : Cardinal)');
    RegisterMethod('Procedure AddChar( const c : WideChar)');
    RegisterMethod('Procedure AddCrLf');
    RegisterMethod('Procedure AddStr( const s : WideString)');
    RegisterProperty('AsStr', 'WideString', iptr);
    RegisterProperty('AsStrTrimRight', 'WideString', iptr);
    RegisterProperty('Buf', 'PWideChar', iptr);
    RegisterMethod('Procedure Clear');
    RegisterProperty('Count', 'Cardinal', iptr);
    RegisterMethod('Procedure Delete( const Index, Count : Cardinal)');
    RegisterMethod('Function IsEmpty : Boolean');
    RegisterMethod('Function IsNotEmpty : Boolean');
    RegisterMethod('Procedure Reset');
  end;
end; }

(*----------------------------------------------------------------------------*)
{procedure SIRegister_TMT19937(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMT19937') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMT19937') do
  begin
    RegisterMethod('Constructor Create0;');
    RegisterMethod('Constructor Create1( const init_key : Cardinal);');
    RegisterMethod('Constructor Create2( const init_key : array of Cardinal);');
    RegisterMethod('Constructor Create3( const init_key : RawByteString);');
    RegisterMethod('Procedure init_genrand( const init_key : Cardinal)');
    RegisterMethod('Procedure init_by_array( const init_key : array of Cardinal)');
    RegisterMethod('Procedure init_by_StrA( const init_key : RawByteString)');
    RegisterMethod('Function genrand_int32 : Cardinal');
    RegisterMethod('Function genrand_int31 : Cardinal');
    RegisterMethod('Function genrand_int64 : Int64');
    RegisterMethod('Function genrand_int63 : Int64');
    RegisterMethod('Function genrand_real1 : Double');
    RegisterMethod('Function genrand_real2 : Double');
    RegisterMethod('Function genrand_real3 : Double');
    RegisterMethod('Function genrand_res53 : Double');
  end; 
end; }

(*----------------------------------------------------------------------------*)
procedure SIRegister_DIUtils(CL: TObjectlist); // {TPSPascalCompiler});   
var mcx: ansichar;
begin
 //CL.AddConstantN('CRLF','String').SetString( #$0D#$0A);
 {DOS_PATH_DELIMITER','String').SetString( '\');
 UNIX_PATH_DELIMITER','String').SetString( '/');
 PATH_DELIMITER','').SetString( DOS_PATH_DELIMITER);
 CHAR_NULL','Char').SetString( #$00);
 CHAR_TAB','Char').SetString( #$09);
 CHAR_LF','Char').SetString( #$0A);
 CHAR_CR','Char').SetString( #$0D);
 CHAR_SPACE','Char').SetString( #$20);
 CHAR_ASTERISK','Char').SetString( #$2A);
 CHAR_FULL_STOP','Char').SetString( #$2E);
 CHAR_EQUALS_SIGN','Char').SetString( #$3D);
 CHAR_QUESTION_MARK','Char').SetString( #$3F);
 AC_NULL','Char').SetString( AnsiChar ( #$00 ));
 AC_TAB','Char').SetString( AnsiChar ( #$09 ));
 AC_LF','Char').SetString( AnsiChar ( #$000A ));
 AC_CR','Char').SetString( AnsiChar ( #$000D ));  }
 
 {AC_SPACE','Char').SetString( AnsiChar ( #$20 ));
 AC_EXCLAMATION_MARK','Char').SetString( AnsiChar ( #$21 ));
 AC_QUOTATION_MARK','Char').SetString( AnsiChar ( #$22 ));
 AC_NUMBER_SIGN','Char').SetString( AnsiChar ( #$23 ));
 AC_DOLLAR_SIGN','Char').SetString( AnsiChar ( #$24 ));
 AC_PERCENT_SIGN','Char').SetString( AnsiChar ( #$25 ));
 AC_AMPERSAND','Char').SetString( AnsiChar ( #$26 ));
 AC_APOSTROPHE','Char').SetString( AnsiChar ( #$27 ));
 AC_LEFT_PARENTHESIS','Char').SetString( AnsiChar ( #$28 ));
 AC_RIGHT_PARENTHESIS','Char').SetString( AnsiChar ( #$29 ));
 AC_ASTERISK','Char').SetString( AnsiChar ( #$2A ));
 AC_PLUS_SIGN','Char').SetString( AnsiChar ( #$2B ));
 AC_COMMA','Char').SetString( AnsiChar ( #$2C ));
 AC_HYPHEN_MINUS','Char').SetString( AnsiChar ( #$2D ));
 AC_FULL_STOP','Char').SetString( AnsiChar ( #$2E ));
 AC_SOLIDUS','Char').SetString( AnsiChar ( #$2F ));
 AC_DIGIT_ZERO','Char').SetString( AnsiChar ( #$30 ));
 AC_DIGIT_ONE','Char').SetString( AnsiChar ( #$31 ));
 AC_DIGIT_TWO','Char').SetString( AnsiChar ( #$32 ));
 AC_DIGIT_THREE','Char').SetString( AnsiChar ( #$33 ));
 AC_DIGIT_FOUR','Char').SetString( AnsiChar ( #$34 ));
 AC_DIGIT_FIVE','Char').SetString( AnsiChar ( #$35 ));
 AC_DIGIT_SIX','Char').SetString( AnsiChar ( #$36 ));
 AC_DIGIT_SEVEN','Char').SetString( AnsiChar ( #$37 ));
 AC_DIGIT_EIGHT','Char').SetString( AnsiChar ( #$38 ));
 AC_DIGIT_NINE','Char').SetString( AnsiChar ( #$39 ));
 AC_COLON','Char').SetString( AnsiChar ( #$3A ));
 AC_SEMICOLON','Char').SetString( AnsiChar ( #$3B ));
 AC_LESS_THAN_SIGN','Char').SetString( AnsiChar ( #$3C ));
 AC_EQUALS_SIGN','Char').SetString( AnsiChar ( #$3D ));
 AC_GREATER_THAN_SIGN','Char').SetString( AnsiChar ( #$3E ));
 AC_QUESTION_MARK','Char').SetString( AnsiChar ( #$3F ));
 AC_COMMERCIAL_AT','Char').SetString( AnsiChar ( #$40 ));
 AC_REVERSE_SOLIDUS','Char').SetString( AnsiChar ( #$5C ));
 AC_LOW_LINE','Char').SetString( AnsiChar ( #$5F ));
 AC_SOFT_HYPHEN','Char').SetString( AnsiChar ( #$AD ));
 AC_CAPITAL_A','Char').SetString( AnsiChar ( #$41 ));
 AC_CAPITAL_B','Char').SetString( AnsiChar ( #$42 ));
 AC_CAPITAL_C','Char').SetString( AnsiChar ( #$43 ));
 AC_CAPITAL_D','Char').SetString( AnsiChar ( #$44 ));
 AC_CAPITAL_E','Char').SetString( AnsiChar ( #$45 ));
 AC_CAPITAL_F','Char').SetString( AnsiChar ( #$46 ));
 AC_CAPITAL_G','Char').SetString( AnsiChar ( #$47 ));
 AC_CAPITAL_H','Char').SetString( AnsiChar ( #$48 ));
 AC_CAPITAL_I','Char').SetString( AnsiChar ( #$49 ));
 AC_CAPITAL_J','Char').SetString( AnsiChar ( #$4A ));
 AC_CAPITAL_K','Char').SetString( AnsiChar ( #$4B ));
 AC_CAPITAL_L','Char').SetString( AnsiChar ( #$4C ));
 AC_CAPITAL_M','Char').SetString( AnsiChar ( #$4D ));
 AC_CAPITAL_N','Char').SetString( AnsiChar ( #$4E ));
 AC_CAPITAL_O','Char').SetString( AnsiChar ( #$4F ));
 AC_CAPITAL_P','Char').SetString( AnsiChar ( #$50 ));
 AC_CAPITAL_Q','Char').SetString( AnsiChar ( #$51 ));
 AC_CAPITAL_R','Char').SetString( AnsiChar ( #$52 ));
 AC_CAPITAL_S','Char').SetString( AnsiChar ( #$53 ));
 AC_CAPITAL_T','Char').SetString( AnsiChar ( #$54 ));
 AC_CAPITAL_U','Char').SetString( AnsiChar ( #$55 ));
 AC_CAPITAL_V','Char').SetString( AnsiChar ( #$56 ));
 AC_CAPITAL_W','Char').SetString( AnsiChar ( #$57 ));
 AC_CAPITAL_X','Char').SetString( AnsiChar ( #$58 ));
 AC_CAPITAL_Y','Char').SetString( AnsiChar ( #$59 ));
 AC_CAPITAL_Z','Char').SetString( AnsiChar ( #$5A ));
 AC_GRAVE_ACCENT','Char').SetString( AnsiChar ( #$60 ));
 AC_SMALL_A','Char').SetString( AnsiChar ( #$61 ));
 AC_SMALL_B','Char').SetString( AnsiChar ( #$62 ));
 AC_SMALL_C','Char').SetString( AnsiChar ( #$63 ));
 AC_SMALL_D','Char').SetString( AnsiChar ( #$64 ));
 AC_SMALL_E','Char').SetString( AnsiChar ( #$65 ));
 AC_SMALL_F','Char').SetString( AnsiChar ( #$66 ));
 AC_SMALL_G','Char').SetString( AnsiChar ( #$67 ));
 AC_SMALL_H','Char').SetString( AnsiChar ( #$68 ));
 AC_SMALL_I','Char').SetString( AnsiChar ( #$69 ));
 AC_SMALL_J','Char').SetString( AnsiChar ( #$6A ));
 AC_SMALL_K','Char').SetString( AnsiChar ( #$6B ));
 AC_SMALL_L','Char').SetString( AnsiChar ( #$6C ));
 AC_SMALL_M','Char').SetString( AnsiChar ( #$6D ));
 AC_SMALL_N','Char').SetString( AnsiChar ( #$6E ));
 AC_SMALL_O','Char').SetString( AnsiChar ( #$6F ));
 AC_SMALL_P','Char').SetString( AnsiChar ( #$70 ));
 AC_SMALL_Q','Char').SetString( AnsiChar ( #$71 ));
 AC_SMALL_R','Char').SetString( AnsiChar ( #$72 ));
 AC_SMALL_S','Char').SetString( AnsiChar ( #$73 ));
 AC_SMALL_T','Char').SetString( AnsiChar ( #$74 ));
 AC_SMALL_U','Char').SetString( AnsiChar ( #$75 ));
 AC_SMALL_V','Char').SetString( AnsiChar ( #$76 ));
 AC_SMALL_W','Char').SetString( AnsiChar ( #$77 ));
 AC_SMALL_X','Char').SetString( AnsiChar ( #$78 ));
 AC_SMALL_Y','Char').SetString( AnsiChar ( #$79 ));
 AC_SMALL_Z','Char').SetString( AnsiChar ( #$7A ));
 AC_NO_BREAK_SPACE','Char').SetString( AnsiChar ( #$A0 ));
 AC_DRIVE_DELIMITER','').SetString( AC_COLON);
 AC_DOS_PATH_DELIMITER','').SetString( AC_REVERSE_SOLIDUS);
 AC_UNIX_PATH_DELIMITER','').SetString( AC_SOLIDUS);
 AS_CRLF','String').SetString( AnsiString ( #$0D#$0A ));}

 //REPLACEMENT_CHARACTER','LongWord').SetUInt( $FFFD);
 {HANGUL_SBase','LongWord').SetUInt( $AC00);
 HANGUL_LBase','LongWord').SetUInt( $1100);
 HANGUL_VBase','LongWord').SetUInt( $1161);
 HANGUL_TBase','LongWord').SetUInt( $11A7);
 HANGUL_LCount','LongInt').SetInt( 19);
 HANGUL_VCount','LongInt').SetInt( 21);
 HANGUL_TCount','LongInt').SetInt( 28); }
  //TAnsiCharSet', 'set of AnsiChar');
  //TIsoDate', 'Cardinal');
  //TJulianDate', 'Integer');
  //TProcedureEvent', 'Procedure');
 //77MT19937_N','LongInt').SetInt( 624);
 //MT19937_M','LongInt').SetInt( 397);
  //SIRegister_TMT19937(CL);
  //SIRegister_TWideStrBuf(CL);
  //atlbsLF
  //TDITextLineBreakStyle', '( atlbsLF, atlbsCRLF, atlbsCR )');
 //AdjustLineBreaksW( const s : UnicodeString; const Style : TDITextLineBreakStyle) : UnicodeString');
  //BrightenColor( const Color : Integer; const amount : Byte) : Integer');
  //BSwap4( const Value : Cardinal) : Cardinal;');
  //BSwap5( const Value : Integer) : Integer;');
  //BufCompNumIW( p1 : PWideChar; l1 : Integer; p2 : PWideChar; l2 : Integer) : Integer');
  //BufCountUtf8Chars(p: PUtf8Char; l: Cardinal): Cardinal');
  //72BufDecodeUtf8( const p : PUtf8Char; const l : NativeUInt) : UnicodeString');
  //ABufferCharCount : Cardinal; const AStartPos : Cardinal) : PWideChar');
  //BufSameA( p1, p2 : PAnsiChar; l : Cardinal) : Boolean');
  //BufSameIA( p1, p2 : PAnsiChar; l : Cardinal) : Boolean');
  //BufPosCharA( const Buf : PAnsiChar; l : Cardinal; const c : AnsiChar; const Start : Cardinal) : Integer');
  //BufPosCharsA( const Buf : PAnsiChar; l : Cardinal; const Search : TAnsiCharSet; const Start : Cardinal) : Integer');
  //BufStrSame( const Buf : PChar; const BufCharCount : Cardinal; const s : string) : Boolean');
  //BufStrSameA( const Buf : PAnsiChar; const BufCharCount : Cardinal; const s : RawByteString) : Boolean');
  //BufStrSameI( const Buf : PChar; const BufCharCount : Cardinal; const s : string) : Boolean');
  //BufStrSameIA( const Buf : PAnsiChar; const BufCharCount : Cardinal; const s : RawByteString) : Boolean');
  //BufStrSameIW( const Buffer : PWideChar; const WideCharCount : Cardinal; const w : UnicodeString) : Boolean');
  //change DIChangeFileExt(const FileName,Extension: string): string');
  //ChangeFileExtA( const FileName, Extension : AnsiString) : AnsiString');
  //CharDecomposeCanonicalW( const c : WideChar) : PCharDecompositionW');
  //CharDecomposeCanonicalStrW( const c : WideChar) : UnicodeString');
  //CharDecomposeCompatibleW( const c : WideChar) : PCharDecompositionW');
  //CharDecomposeCompatibleStrW( const c : WideChar) : UnicodeString');
  //7CharIn8( const c, t1, t2 : WideChar) : Boolean;');
  //CharIn9( const c, t1, t2, t3 : WideChar) : Boolean;');
 //ConCatBuf( const Buffer : PChar; const CharCount : Cardinal; var d : string; var InUse : Cardinal)');
  //ConCatBufA( const Buffer : PAnsiChar; const AnsiCharCount : Cardinal; var d : RawByteString; var InUse : Cardinal)');
  {ConCatChar( const c : Char; var d : string; var InUse : Cardinal)');
  ConCatCharA( const c : AnsiChar; var d : RawByteString; var InUse : Cardinal)');
  ConCatCharW( const c : WideChar; var d : UnicodeString; var InUse : Cardinal)');
  ConCatStr( const s : string; var d : string; var InUse : Cardinal)');
  ConCatStrA( const s : RawByteString; var d : RawByteString; var InUse : Cardinal)');
  ConCatStrW( const w : UnicodeString; var d : UnicodeString; var InUse : Cardinal)');
  }
  // change DICountBitsSet( const Value : Integer) : Byte');
  //Crc32OfStrA( const s : RawByteString) : TCrc32');
  //Crc32OfStrW( const s : UnicodeString) : TCrc32');
  //CurrentDay : Word');
  //CurrentJulianDate : TJulianDate');
  //CurrentMonth : Word');
  //CurrentQuarter : Word');
  //change DICurrentYear : Integer');
  //DarkenColor( const Color : Integer; const amount : Byte) : Integer');
  // change diDeleteFile( const FileName : string) : Boolean');
  // diDirectoryExists( const Dir : string) : Boolean');
  // diDiskFree( const Dir : string) : Int64');
  //diExpandFileName( const FileName : string) : string');
  //diExcludeTrailingPathDelimiter( var s : string)');
  //diExtractFileDrive( const FileName : string) : string');
  //diExtractFileExt( const FileName : string) : string');
  //diExtractFileName( const FileName : string) : string');
  //diExtractFilePath( const FileName : string) : string');
  //ExtractNextWord( const s : string; const ADelimiter : Char; var AStartIndex : Integer) : string;');
  //ExtractNextWordT( const s : string; const ADelimiters : TAnsiCharSet; var AStartIndex : Integer) : string;');
  //diExtractWord( const Number : Cardinal; const s : RawByteString; const Delimiters : TAnsiCharSet) : RawByteString');
  //ExtractWordStartsA( const s : RawByteString; const MaxCharCount : Cardinal; const WordSeparators : TAnsiCharSet) : RawByteString');
  //diFileExists( const FileName : string) : Boolean');
  //diGCD( x, y : Cardinal) : Cardinal');
  //diGetTempFolder : string');
  //diGetUserName( out UserName : string) : Boolean');
  //HexCodePointToInt( const c : Cardinal) : Integer');
  //diHexToInt( const s : string) : Integer');
  //BufHexToInt( p : PChar; l : Cardinal) : Integer');
  //IncludeTrailingPathDelimiterByRef( var s : string)');
  //IntToHex16( const Value : Integer; const Digits : NativeInt) : string;');
  //IntToHex17( const Value : Int64; const Digits : NativeInt) : string;');
  //IntToHex18( const Value : UInt64; const Digits : NativeInt) : string;');
  //IntToHexA( Value : UInt64; const Digits : NativeInt) : RawByteString');
  //IntToStrA19( const i : Integer) : RawByteString;');
  //IntToStrA21( const i : Int64) : RawByteString;');
  //diIsPathDelimiter( const s : string; const Index : Cardinal) : Boolean');
  //IsPointInRect( const Point : TPoint; const Rect : TRect) : Boolean');
  //JulianDateToIsoDateStr(const Julian: TJulianDate):string');
  //LeftMostBit( Value : Cardinal) : ShortInt;');
  //LeftMostBit2( Value : UInt64) : ShortInt;');
  //StrIsEmpty( const s : string) : Boolean');
  //PadLeftA( const Source : RawByteString; const Count : Cardinal; const c : AnsiChar) : RawByteString');
  //PadRightA( const Source : RawByteString; const Count : Cardinal; const c : AnsiChar) : RawByteString');
  //ProperCase( const s : string) : string');
  //ProperCaseByRefA( var s : RawByteString)');
  //RegReadRegisteredOrganization( const Access : REGSAM) : string');
  //RegReadRegisteredOwner( const Access : REGSAM) : string');
  //RegReadStrDef( const Key : HKEY; const SubKey : string; const ValueName : string; const Default : string; const Access : REGSAM) : string');
  //StrDecodeUrlA( const Value : RawByteString) : RawByteString');
  //diStrEnd( const s : PChar) : PChar');
  //StrEndA( const s : PAnsiChar) : PAnsiChar');
  //StrIncludeTrailingChar( var s : string; const c : Char)');
  //diStrLen( const s : PChar) : NativeUInt');
  //StrRandom( const ASeed : RawByteString; const ACharacters : string; const ALength : Cardinal) : string');
  //StrRemoveFromToIA( var Source : RawByteString; const FromString, ToString : RawByteString)');
  //diStrReplaceChar( var Source : string; const SearchChar, ReplaceChar : Char)');
  //diStrReplace( const Source, Search, Replace : string) : string');
  //StrReplaceI( const Source, Search, Replace : string) : string');
  //StrReplaceLoopA( const Source, Search, Replace : RawByteString) : RawByteString');
  //StrReplaceLoopIA( const Source, Search, Replace : RawByteString) : RawByteString');
  //RightMostBit( const Value : Cardinal) : ShortInt;');
  //RightMostBit2( const Value : UInt64) : ShortInt;');
  //LoadStrFromFile( const FileName : string; var s : RawByteString) : Boolean;');
    //new FileToStr( const FileName : string; var s : String) : Boolean;');

  //LoadStrAFromFileA( const FileName : AnsiString; var s : RawByteString) : Boolean');
  //QuotedStrW( const s : UnicodeString; const Quote : WideChar) : UnicodeString');
  //SaveStrToFile( const s : string; const FileName : string) : Boolean');
  //new StrToFile( const s : string; const FileName : string) : Boolean');
  
  //StrPosChar( const Source : string; const c : Char; const Start : Cardinal) : Cardinal');
  //StrPosCharBack( const Source : string; const c : Char; const Start : Cardinal) : Cardinal');
  //StrPosCharsA( const Source : RawByteString; const Search : TAnsiCharSet; const Start : Cardinal) : Cardinal');
  //StrPosCharsBackA( const Source : RawByteString; const Search : TAnsiCharSet; const Start : Cardinal) : Cardinal');
  //StrPosNotCharsBackA( const Source : RawByteString; const Search : TAnsiCharSet; const Start : Cardinal) : Cardinal');
 
  //SetFileDate( const FileHandle : THandle; const Year : Integer; const Month, Day : Word) : Boolean;');
  //SetFileDate2( const FileName : string; const JulianDate : TJulianDate) : Boolean;');
  //SetFileDateYmd( const FileName : string; const Year : Integer; const Month, Day : Word) : Boolean');
  //SetFileDateYmdA( const FileName : AnsiString; const Year : Integer; const Month, Day : Word) : Boolean');
  //StrContainsChar( const s : string; const c : Char; const Start : Cardinal) : Boolean');
  //StrContainsCharsA( const s : RawByteString; const Chars : TAnsiCharSet; const Start : Cardinal) : Boolean');
  //StrConsistsOfW( const w : UnicodeString; const Validate : TValidateCharFuncW; const Start : NativeUInt) : Boolean');
  //diStrSame( const s1, s2 : string) : Boolean');
  //StrSameStart( const s1, s2 : string) : Boolean');
  //diStrComp( const s1, s2 : string) : Integer');
  //StrCompI( const s1, s2 : string) : Integer');
  //StrCompNum( const s1, s2 : string) : Integer');
  //StrCompNumI( const s1, s2 : string) : Integer');
  //StrContains( const Search, Source : string; const Start : Cardinal) : Boolean');
  //StrContainsI( const Search, Source : string; const Start : Cardinal) : Boolean');
  //StrCountChar( const ASource : string; const c : Char; const AStartIdx : Cardinal) : Cardinal');
  //StrMatchesA( const Search, Source : RawByteString; const AStartIdx : Cardinal) : Boolean');
  //StrMatchesIA( const Search, Source : RawByteString; const AStartIdx : Cardinal) : Boolean');
  //StrMatchWild( const Source, Mask : string; const WildChar : Char; const MaskChar : Char) : Boolean');
  //StrMatchWildA( const Source, Mask : RawByteString; const WildChar : AnsiChar; const MaskChar : AnsiChar) : Boolean');
//  StrMatchWildI( const Source, Mask : string; const WildChar : Char; const MaskChar : Char) : Boolean');
  //StrMatchWildIA( const Source, Mask : RawByteString; const WildChar : AnsiChar; const MaskChar : AnsiChar) : Boolean');
  //diStrPos( const ASearch, ASource : string; const AStartPos : Cardinal) : Cardinal');
  //StrPosI( const ASearch, ASource : string; const AStartPos : Cardinal) : Cardinal');
  //StrPosBackA( const ASearch, ASource : RawByteString; AStart : Cardinal) : Cardinal');
  //StrPosBackIA( const ASearch, ASource : RawByteString; AStart : Cardinal) : Cardinal');
  //StrToUpper( const s : string) : string');
  //StrToUpperInPlace( var s : string)');
  //StrToUpperInPlaceA( var s : AnsiString)');
  //StrToLower( const s : string) : string');
  //StrToLowerInPlace( var s : string)');
  //StrToLowerInPlaceA( var s : AnsiString)');
  //StrTimUriFragmentA( var Value : RawByteString)');
  //diSysErrorMessage( const MessageID : Cardinal) : string');
  //TextExtentW( const DC : HDC; const Text : UnicodeString) : TSize');
  //TextHeightW( const DC : HDC; const Text : UnicodeString) : Integer');
  //TextWidthW( const DC : HDC; const Text : UnicodeString) : Integer');
  //diStrTrim( const Source : string) : string');
  //StrTrimA( const Source : RawByteString) : RawByteString');
  //StrTrimCharA( const Source : RawByteString; const CharToTrim : AnsiChar) : RawByteString');
  //StrTrimCharsA( const Source : RawByteString; const CharsToTrim : TAnsiCharSet) : RawByteString');
  //TrimLeftByRefA( var s : RawByteString; const Chars : TAnsiCharSet)');
  //TrimRightA( const Source : RawByteString; const s : TAnsiCharSet) : RawByteString');
  //TrimRightByRefA( var Source : RawByteString; const s : TAnsiCharSet)');
  //StrTrimCompressA( var s : RawByteString; const TrimCompressChars : TAnsiCharSet; const ReplaceChar : AnsiChar)');
  //ValInt( const p : PChar; const l : Integer; out Code : Integer) : Integer;');
  //ValInt2(const s: string; out Code : Integer): Integer;');
  //YmdToIsoDateStr( const Year : Integer; const Month : Word; const Day : Word) : string');
  //YmdToIsoDateStrA( const Year : Integer; const Month : Word; const Day : Word) : RawByteString');
  //CharIsLetterW( const c : WideChar) : Boolean');
  //CharIsLetterCommonW( const c : WideChar) : Boolean');
  //CharIsLetterUpperCaseW( const c : WideChar) : Boolean');
  //CharIsLetterLowerCaseW( const c : WideChar) : Boolean');
  //CharIsLetterTitleCaseW( const c : WideChar) : Boolean');
  {CharIsLetterModifierW( const c : WideChar) : Boolean');
  CharIsLetterOtherW( const c : WideChar) : Boolean');
  CharIsMarkW( const c : WideChar) : Boolean');
  CharIsMarkNon_SpacingW( const c : WideChar) : Boolean');
  CharIsMarkSpacing_CombinedW(const c: WideChar): Boolean');
  CharIsMarkEnclosingW( const c : WideChar) : Boolean');
  CharIsNumberW( const c : WideChar) : Boolean');
  CharIsNumber_DecimalW( const c : WideChar) : Boolean');
  CharIsNumber_LetterW( const c : WideChar) : Boolean');
  CharIsNumber_OtherW( const c : WideChar) : Boolean');
  CharIsPunctuationW( const c : WideChar) : Boolean');
  CharIsPunctuation_ConnectorW( const c : WideChar) : Boolean');
  CharIsPunctuation_DashW( const c : WideChar) : Boolean');
  CharIsPunctuation_OpenW( const c : WideChar) : Boolean');
  CharIsPunctuation_CloseW( const c : WideChar) : Boolean');
  CharIsPunctuation_InitialQuoteW( const c : WideChar) : Boolean');
  CharIsPunctuation_FinalQuoteW( const c : WideChar) : Boolean');
  CharIsPunctuation_OtherW( const c : WideChar) : Boolean');
  CharIsSymbolW( const c : WideChar) : Boolean');
  CharIsSymbolMathW( const c : WideChar) : Boolean');
  CharIsSymbolCurrencyW( const c : WideChar) : Boolean');
  CharIsSymbolModifierW( const c : WideChar) : Boolean');
  CharIsSymbolOtherW( const c : WideChar) : Boolean');
  CharIsSeparatorW( const c : WideChar) : Boolean');
  CharIsSeparatorSpaceW( const c : WideChar) : Boolean');
  CharIsSeparatorLineW( const c : WideChar) : Boolean');
  CharIsSeparatorParagraphW( const c : WideChar) : Boolean');
  CharIsOtherW( const c : WideChar) : Boolean');
  CharIsOtherControlW( const c : WideChar) : Boolean');
  CharIsOtherFormatW( const c : WideChar) : Boolean');
  CharIsOtherSurrogateW( const c : WideChar) : Boolean');
  CharIsOtherPrivateUseW( const c : WideChar) : Boolean'); }
  //BitClear( const Bits, BitNo : Integer) : Integer');
  //BitSet( const Bits, BitIndex : Integer) : Integer');
  //BitSetTo( const Bits, BitIndex : Integer; const Value : Boolean) : Integer');
  //BitTest( const Bits, BitIndex : Integer) : Boolean');
  //CharCanonicalCombiningClassW( const Char : WideChar) : Cardinal');
  //CharIsAlphaW( const c : WideChar) : Boolean');
  //CharIsAlphaNumW( const c : WideChar) : Boolean');
  //CharIsCrLf( const c : Char) : Boolean');
  //7/CharIsCrLfA( const c : AnsiChar) : Boolean');
  //diCharIsDigit( const c : Char) : Boolean');
  //CharIsDigitA( const c : AnsiChar) : Boolean');
  {CharIsDigitW( const c : WideChar) : Boolean');
  CharIsHangulW( const Char : WideChar) : Boolean');
  CharIsHexDigitW( const c : WideChar) : Boolean');
  CharIsWhiteSpaceW( const c : WideChar) : Boolean');
  CharToCaseFoldW( const Char : WideChar) : WideChar');
  CharToLowerW( const Char : WideChar) : WideChar');
  CharToUpperW( const Char : WideChar) : WideChar');
  CharToTitleW( const Char : WideChar) : WideChar');}
  
  //DayOfJulianDate( const JulianDate : TJulianDate) : Word');
  //diDayOfWeek( const JulianDate : TJulianDate) : Word');
  //DayOfWeekYmd( const Year : Integer; const Month, Day : Word) : Word');
  //diDaysInMonth( const JulianDate : TJulianDate) : Word');
  //DaysInMonthYm( const Year : Integer; const Month : Word) : Word');
  //DecDay( var Year : Integer; var Month, Day : Word)');
  //DecDays( var Year : Integer; var Month, Day : Word; const Days : Integer)');
  //diDeleteDirectory( const Dir : string; const DeleteItself : Boolean) : Boolean');
  //DeleteDirectoryA( Dir : AnsiString; const DeleteItself : Boolean) : Boolean');
  //diEasterSunday( const Year : Integer) : TJulianDate');
  //EasterSundayYmd( const Year : Integer; out Month, Day : Word)');
  //diFirstDayOfWeek( const JulianDate : TJulianDate) : TJulianDate');
  //FirstDayOfWeekYmd( var Year : Integer; var Month, Day : Word)');
  //diFirstDayOfMonth( const Julian : TJulianDate) : TJulianDate');
  //FirstDayOfMonthYmd( const Year : Integer; const Month : Word; out Day : Word)');
  //diForceDirectories( const Dir : string) : Boolean');
  //ForceDirectoriesA( Dir : AnsiString) : Boolean');
  // change diFreeMemAndNil( var Ptr: TObject)');
  //diGetCurrentFolder : string');
  //GetCurrentFolderA : AnsiString');
  //SetCurrentFolder( const NewFolder : string)');
  //SetCurrentFolderA( const NewFolder : AnsiString)');
  //diGetDesktopFolder : string');
  //GetDesktopFolderA : AnsiString');
  //diGetFileSize( const AFileName : string) : Int64');
  //GetFileSizeA( const AFileName : AnsiString) : Int64');
  //diGetDesktopDirectoryFolder : string');
  //GetDesktopDirectoryFolderA : AnsiString');
  //GetFileLastWriteTime( const FileName : string; out FileTime : TFileTime) : Boolean');
  //GetFileLastWriteTimeA( const FileName : AnsiString; out FileTime : TFileTime) : Boolean');
  //diGetPersonalFolder( const PersonalFolder : Integer) : string');
  //GetPersonalFolderA : AnsiString');
  //GetSpecialFolder( const SpecialFolder : Integer) : string');
  //GetSpecialFolderA( const SpecialFolder : Integer) : AnsiString');
  //diIncMonth( var Year : Integer; var Month, Day : Word)');
  //diIncMonths( var Year : Integer; var Month, Day : Word; const NumberOfMonths : Integer)');
  //diIncDay( var Year : Integer; var Month, Day : Word)');
  //IncDays( var Year : Integer; var Month, Day : Word; const Days : Integer)');
  //IsDateValid( const Year : Integer; const Month, Day : Word) : Boolean');
  //IsHolidayInGermany( const Julian : TJulianDate) : Boolean');
  //IsHolidayInGermanyYmd( const Year : Integer; const Month, Day : Word) : Boolean');
  //diIsLeapYear( const Year : Integer) : Boolean');
  //ISODateToJulianDate( const ISODate : TIsoDate) : TJulianDate');
  //ISODateToYmd( const ISODate : TIsoDate; out Year : Integer; out Month, Day : Word)');
  {IsCharLowLineW( const c : WideChar) : Boolean');
  IsCharQuoteW( const c : WideChar) : Boolean');
  IsShiftKeyDown : Boolean');
  IsCharWhiteSpaceOrAmpersandW( const c : WideChar) : Boolean');
  IsCharWhiteSpaceOrNoBreakSpaceW( const c : WideChar) : Boolean');
  IsCharWhiteSpaceOrColonW( const c : WideChar) : Boolean');
  CharIsWhiteSpaceGtW( const c : WideChar) : Boolean');
  CharIsWhiteSpaceLtW( const c : WideChar) : Boolean');
  CharIsWhiteSpaceHyphenW( const c : WideChar) : Boolean');
  CharIsWhiteSpaceHyphenGtW( const c : WideChar) : Boolean');
  IsCharWordSeparatorW( const c : WideChar) : Boolean');}
  //diISOWeekNumber( const JulianDate : TJulianDate) : Word');
  //ISOWeekNumberYmd( const Year : Integer; const Month, Day : Word) : Word');
  //ISOWeekToJulianDate( const Year : Integer; const WeekOfYear : Word; const DayOfWeek : Word) : TJulianDate');
  //JulianDateIsWeekDay( const JulianDate : TJulianDate) : Boolean');
  //JulianDateToIsoDate( const Julian : TJulianDate) : TIsoDate');
  //JulianDateToYmd( const JulianDate : TJulianDate; out Year : Integer; out Month, Day : Word)');
  //diLastDayOfMonth( const JulianDate : TJulianDate) : TJulianDate');
  //LastDayOfMonthYmd( const Year : Integer; const Month : Word; out Day : Word)');
  //diLastDayOfWeek( const JulianDate : TJulianDate) : TJulianDate');
  //LastDayOfWeekYmd( var Year : Integer; var Month, Day : Word)');
  //LastSysErrorMessage : string');
  //LastSysErrorMessageA : AnsiString');
  //diMax( const a : Integer; const b : Integer) : Integer;');
  //diMax3( const a, b, c : Integer) : Integer');
  //MaxCard( const a : Cardinal; const b : Cardinal) : Cardinal;');
  //MaxCard3( const a : Cardinal; const b : Cardinal; const c : Cardinal) : Cardinal;');
  //diMaxInt64( const a : Int64; const b : Int64) : Int64;');
  //diMaxInt643( const a : Int64; const b : Int64; const c : Int64) : Int64;');
  //diMin( const a, b : Integer) : Integer;');
  //diMin3( const a, b, c : Integer) : Integer');
  //MinCard( const a, b : Cardinal) : Cardinal;');
  //MinCard3( const a, b, c : Cardinal) : Cardinal;');
  //diMinInt64( const a, b : Int64) : Int64;');
  //diMinInt643( const a, b, c : Int64) : Int64;');
  //MonthOfJulianDate( const JulianDate : TJulianDate) : Word');
  //YearOfJuilanDate( const JulianDate : TJulianDate) : Integer');
  //YmdToIsoDate( const Year : Integer; const Month, Day : Word) : TIsoDate');
  //YmdToJulianDate( const Year : Integer; const Month, Day : Word) : TJulianDate');
 {ISO_MONDAY','LongInt').SetInt( 0);
 ISO_TUESDAY','LongInt').SetInt( 1);
 ISO_WEDNESDAY','LongInt').SetInt( 2);
 ISO_THURSDAY','LongInt').SetInt( 3);
 ISO_FRIDAY','LongInt').SetInt( 4);
 ISO_SATURDAY','LongInt').SetInt( 5);
 ISO_SUNDAY','LongInt').SetInt( 6);}
 //CRC_32_INIT','LongWord').SetUInt( $FFFFFFFF);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function Min56_P( const a, b, c : UInt64) : UInt64;
Begin Result := DIUtils.Min(a, b, c); END;

(*----------------------------------------------------------------------------*)
Function Min55_P( const a, b : UInt64) : UInt64;
Begin Result := DIUtils.Min(a, b); END;

(*----------------------------------------------------------------------------*)
Function Min54_P( const a, b, c : Int64) : Int64;
Begin Result := DIUtils.Min(a, b, c); END;

(*----------------------------------------------------------------------------*)
Function Min53_P( const a, b : Int64) : Int64;
Begin Result := DIUtils.Min(a, b); END;

(*----------------------------------------------------------------------------*)
Function Min52_P( const a, b, c : Cardinal) : Cardinal;
Begin Result := DIUtils.Min(a, b, c); END;

(*----------------------------------------------------------------------------*)
Function Min51_P( const a, b : Cardinal) : Cardinal;
Begin Result := DIUtils.Min(a, b); END;

(*----------------------------------------------------------------------------*)
Function Min50_P( const a, b : Integer) : Integer;
Begin Result := DIUtils.Min(a, b); END;

(*----------------------------------------------------------------------------*)
Function Max49_P( const a : Int64; const b : Int64; const c : Int64) : Int64;
Begin Result := DIUtils.Max(a, b, c); END;

(*----------------------------------------------------------------------------*)
Function Max48_P( const a : Int64; const b : Int64) : Int64;
Begin Result := DIUtils.Max(a, b); END;

(*----------------------------------------------------------------------------*)
Function Max47_P( const a : Cardinal; const b : Cardinal; const c : Cardinal) : Cardinal;
Begin Result := DIUtils.Max(a, b, c); END;

(*----------------------------------------------------------------------------*)
Function Max46_P( const a : Cardinal; const b : Cardinal) : Cardinal;
Begin Result := DIUtils.Max(a, b); END;

(*----------------------------------------------------------------------------*)
Function Max45_P( const a : Integer; const b : Integer) : Integer;
Begin Result := DIUtils.Max(a, b); END;

(*----------------------------------------------------------------------------*)
Function ValInt64W44_P( const s : UnicodeString; out Code : Integer) : Int64;
Begin Result := DIUtils.ValInt64W(s, Code); END;

(*----------------------------------------------------------------------------*)
Function ValInt64A43_P( const s : RawByteString; out Code : Integer) : Int64;
Begin Result := DIUtils.ValInt64A(s, Code); END;

(*----------------------------------------------------------------------------*)
Function ValInt64W42_P( p : PWideChar; l : Integer; out Code : Integer) : Int64;
Begin Result := DIUtils.ValInt64W(p, l, Code); END;

(*----------------------------------------------------------------------------*)
Function ValInt64A41_P( p : PAnsiChar; l : Integer; out Code : Integer) : Int64;
Begin Result := DIUtils.ValInt64A(p, l, Code); END;

(*----------------------------------------------------------------------------*)
Function ValIntW40_P( const s : UnicodeString; out Code : Integer) : Integer;
Begin Result := DIUtils.ValIntW(s, Code); END;

(*----------------------------------------------------------------------------*)
Function ValIntA39_P( const s : RawByteString; out Code : Integer) : Integer;
Begin Result := DIUtils.ValIntA(s, Code); END;

(*----------------------------------------------------------------------------*)
Function ValInt38_P( const s : string; out Code : Integer) : Integer;
Begin Result := DIUtils.ValInt(s, Code); END;

(*----------------------------------------------------------------------------*)
Function ValIntW37_P( p : PWideChar; l : Integer; out Code : Integer) : Integer;
Begin Result := DIUtils.ValIntW(p, l, Code); END;

(*----------------------------------------------------------------------------*)
Function ValIntA36_P( p : PAnsiChar; l : Integer; out Code : Integer) : Integer;
Begin Result := DIUtils.ValIntA(p, l, Code); END;

(*----------------------------------------------------------------------------*)
Function ValInt35_P( const p : PChar; const l : Integer; out Code : Integer) : Integer;
Begin Result := DIUtils.ValInt(p, l, Code); END;

(*----------------------------------------------------------------------------*)
Procedure StrToLowerInPlaceW34_P( var s : UnicodeString);
Begin DIUtils.StrToLowerInPlaceW(s); END;

(*----------------------------------------------------------------------------*)
Procedure StrToLowerInPlaceW33_P( var s : WideString);
Begin DIUtils.StrToLowerInPlaceW(s); END;

(*----------------------------------------------------------------------------*)
Procedure StrToUpperInPlaceW32_P( var s : UnicodeString);
Begin DIUtils.StrToUpperInPlaceW(s); END;

(*----------------------------------------------------------------------------*)
Procedure StrToUpperInPlaceW31_P( var s : WideString);
Begin DIUtils.StrToUpperInPlaceW(s); END;

(*----------------------------------------------------------------------------*)
Function SetFileDate30_P( const FileName : string; const JulianDate : TJulianDate) : Boolean;
Begin Result := DIUtils.SetFileDate(FileName, JulianDate); END;

(*----------------------------------------------------------------------------*)
Function SetFileDate29_P( const FileHandle : THandle; const Year : Integer; const Month, Day : Word) : Boolean;
Begin Result := DIUtils.SetFileDate(FileHandle, Year, Month, Day); END;

(*----------------------------------------------------------------------------*)
Function LoadStrWFromFile28_P( const FileName : string; var s : UnicodeString) : Boolean;
Begin Result := DIUtils.LoadStrWFromFile(FileName, s); END;

(*----------------------------------------------------------------------------*)
Function LoadStrAFromFile27_P( const FileName : string; var s : RawByteString) : Boolean;
Begin Result := DIUtils.LoadStrAFromFile(FileName, s); END;

(*----------------------------------------------------------------------------*)
Function RightMostBit26_P( const Value : UInt64) : ShortInt;
Begin Result := DIUtils.RightMostBit(Value); END;

(*----------------------------------------------------------------------------*)
Function RightMostBit25_P( const Value : Cardinal) : ShortInt;
Begin Result := DIUtils.RightMostBit(Value); END;

(*----------------------------------------------------------------------------*)
Function LeftMostBit24_P( Value : UInt64) : ShortInt;
Begin Result := DIUtils.LeftMostBit(Value); END;

(*----------------------------------------------------------------------------*)
Function LeftMostBit23_P( Value : Cardinal) : ShortInt;
Begin Result := DIUtils.LeftMostBit(Value); END;

(*----------------------------------------------------------------------------*)
Function IntToStrW22_P( const i : Int64) : UnicodeString;
Begin Result := DIUtils.IntToStrW(i); END;

(*----------------------------------------------------------------------------*)
Function IntToStrA21_P( const i : Int64) : RawByteString;
Begin Result := DIUtils.IntToStrA(i); END;

(*----------------------------------------------------------------------------*)
Function IntToStrW20_P( const i : Integer) : UnicodeString;
Begin Result := DIUtils.IntToStrW(i); END;

(*----------------------------------------------------------------------------*)
Function IntToStrA19_P( const i : Integer) : RawByteString;
Begin Result := DIUtils.IntToStrA(i); END;

(*----------------------------------------------------------------------------*)
Function IntToHex18_P( const Value : UInt64; const Digits : NativeInt) : string;
Begin Result := DIUtils.IntToHex(Value, Digits); END;

(*----------------------------------------------------------------------------*)
Function IntToHex17_P( const Value : Int64; const Digits : NativeInt) : string;
Begin Result := DIUtils.IntToHex(Value, Digits); END;

(*----------------------------------------------------------------------------*)
Function IntToHex16_P( const Value : Integer; const Digits : NativeInt) : string;
Begin Result := DIUtils.IntToHex(Value, Digits); END;

(*----------------------------------------------------------------------------*)
Function ExtractNextWordW15_P( const s : UnicodeString; const ADelimiters : TValidateCharFuncW; var AStartIndex : Integer) : UnicodeString;
Begin Result := DIUtils.ExtractNextWordW(s, ADelimiters, AStartIndex); END;

(*----------------------------------------------------------------------------*)
Function ExtractNextWordA14_P( const s : RawByteString; const ADelimiters : TAnsiCharSet; var AStartIndex : Integer) : RawByteString;
Begin Result := DIUtils.ExtractNextWordA(s, ADelimiters, AStartIndex); END;

(*----------------------------------------------------------------------------*)
Function ExtractNextWord13_P( const s : string; const ADelimiters : TAnsiCharSet; var AStartIndex : Integer) : string;
Begin Result := DIUtils.ExtractNextWord(s, ADelimiters, AStartIndex); END;

(*----------------------------------------------------------------------------*)
Function ExtractNextWordW12_P( const s : UnicodeString; const ADelimiter : WideChar; var AStartIndex : Integer) : UnicodeString;
Begin Result := DIUtils.ExtractNextWordW(s, ADelimiter, AStartIndex); END;

(*----------------------------------------------------------------------------*)
Function ExtractNextWordA11_P( const s : RawByteString; const ADelimiter : AnsiChar; var AStartIndex : Integer) : RawByteString;
Begin Result := DIUtils.ExtractNextWordA(s, ADelimiter, AStartIndex); END;

(*----------------------------------------------------------------------------*)
Function ExtractNextWord10_P( const s : string; const ADelimiter : Char; var AStartIndex : Integer) : string;
Begin Result := DIUtils.ExtractNextWord(s, ADelimiter, AStartIndex); END;

(*----------------------------------------------------------------------------*)
Function CharIn9_P( const c, t1, t2, t3 : WideChar) : Boolean;
Begin Result := DIUtils.CharIn(c, t1, t2, t3); END;

(*----------------------------------------------------------------------------*)
Function CharIn8_P( const c, t1, t2 : WideChar) : Boolean;
Begin Result := DIUtils.CharIn(c, t1, t2); END;

(*----------------------------------------------------------------------------*)
Function BufIsCharsW7_P( const p : PWideChar; const l : NativeUInt; const Validate : TValidateCharFuncW; const c : WideChar) : Boolean;
Begin Result := DIUtils.BufIsCharsW(p, l, Validate, c); END;

(*----------------------------------------------------------------------------*)
Function BufIsCharsW6_P( const p : PWideChar; const l : NativeUInt; const Validate : TValidateCharFuncW) : Boolean;
Begin Result := DIUtils.BufIsCharsW(p, l, Validate); END;

(*----------------------------------------------------------------------------*)
Function BSwap5_P( const Value : Integer) : Integer;
Begin Result := DIUtils.BSwap(Value); END;

(*----------------------------------------------------------------------------*)
Function BSwap4_P( const Value : Cardinal) : Cardinal;
Begin Result := DIUtils.BSwap(Value); END;

(*----------------------------------------------------------------------------*)
procedure TWideStrBufCount_R(Self: TWideStrBuf; var T: Cardinal);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TWideStrBufBuf_R(Self: TWideStrBuf; var T: PWideChar);
begin T := Self.Buf; end;

(*----------------------------------------------------------------------------*)
procedure TWideStrBufAsStrTrimRight_R(Self: TWideStrBuf; var T: WideString);
begin T := Self.AsStrTrimRight; end;

(*----------------------------------------------------------------------------*)
procedure TWideStrBufAsStr_R(Self: TWideStrBuf; var T: WideString);
begin T := Self.AsStr; end;

(*----------------------------------------------------------------------------*)
Function TMT19937Create3_P(Self: TClass; CreateNewInstance: Boolean;  const init_key : RawByteString):TObject;
Begin Result := TMT19937.Create(init_key); END;

(*----------------------------------------------------------------------------*)
Function TMT19937Create2_P(Self: TClass; CreateNewInstance: Boolean;  const init_key : array of Cardinal):TObject;
Begin Result := TMT19937.Create(init_key); END;

(*----------------------------------------------------------------------------*)
Function TMT19937Create1_P(Self: TClass; CreateNewInstance: Boolean;  const init_key : Cardinal):TObject;
Begin Result := TMT19937.Create(init_key); END;

(*----------------------------------------------------------------------------*)
Function TMT19937Create0_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TMT19937.Create; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DIUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AdjustLineBreaksW, 'AdjustLineBreaksW', cdRegister);
 S.RegisterDelphiFunction(@BrightenColor, 'BrightenColor', cdRegister);
 S.RegisterDelphiFunction(@BSwap4, 'BSwap4', cdRegister);
 S.RegisterDelphiFunction(@BSwap5, 'BSwap5', cdRegister);
 S.RegisterDelphiFunction(@BufCompNumIW, 'BufCompNumIW', cdRegister);
 S.RegisterDelphiFunction(@BufCountUtf8Chars, 'BufCountUtf8Chars', cdRegister);
 S.RegisterDelphiFunction(@BufDecodeUtf8, 'BufDecodeUtf8', cdRegister);
 S.RegisterDelphiFunction(@BufEncodeUtf8, 'BufEncodeUtf8', cdRegister);
 S.RegisterDelphiFunction(@BufIsCharsW6, 'BufIsCharsW6', cdRegister);
 S.RegisterDelphiFunction(@BufIsCharsW7, 'BufIsCharsW7', cdRegister);
 S.RegisterDelphiFunction(@BufHasCharsW, 'BufHasCharsW', cdRegister);
 S.RegisterDelphiFunction(@BufPosA, 'BufPosA', cdRegister);
 S.RegisterDelphiFunction(@BufPosW, 'BufPosW', cdRegister);
 S.RegisterDelphiFunction(@BufPosIA, 'BufPosIA', cdRegister);
 S.RegisterDelphiFunction(@BufPosIW, 'BufPosIW', cdRegister);
 S.RegisterDelphiFunction(@BufSameA, 'BufSameA', cdRegister);
 S.RegisterDelphiFunction(@BufSameW, 'BufSameW', cdRegister);
 S.RegisterDelphiFunction(@BufSameIA, 'BufSameIA', cdRegister);
 S.RegisterDelphiFunction(@BufSameIW, 'BufSameIW', cdRegister);
 S.RegisterDelphiFunction(@BufPosCharA, 'BufPosCharA', cdRegister);
 S.RegisterDelphiFunction(@BufPosCharsA, 'BufPosCharsA', cdRegister);
 S.RegisterDelphiFunction(@BufPosCharsW, 'BufPosCharsW', cdRegister);
 S.RegisterDelphiFunction(@BufStrSame, 'BufStrSame', cdRegister);
 S.RegisterDelphiFunction(@BufStrSameA, 'BufStrSameA', cdRegister);
 S.RegisterDelphiFunction(@BufStrSameW, 'BufStrSameW', cdRegister);
 S.RegisterDelphiFunction(@BufStrSameI, 'BufStrSameI', cdRegister);
 S.RegisterDelphiFunction(@BufStrSameIA, 'BufStrSameIA', cdRegister);
 S.RegisterDelphiFunction(@BufStrSameIW, 'BufStrSameIW', cdRegister);
 S.RegisterDelphiFunction(@ChangeFileExt, 'ChangeFileExt', cdRegister);
 S.RegisterDelphiFunction(@ChangeFileExtA, 'ChangeFileExtA', cdRegister);
 S.RegisterDelphiFunction(@ChangeFileExtW, 'ChangeFileExtW', cdRegister);
 S.RegisterDelphiFunction(@CharDecomposeCanonicalW, 'CharDecomposeCanonicalW', cdRegister);
 S.RegisterDelphiFunction(@CharDecomposeCanonicalStrW, 'CharDecomposeCanonicalStrW', cdRegister);
 S.RegisterDelphiFunction(@CharDecomposeCompatibleW,'CharDecomposeCompatibleW',cdRegister);
 S.RegisterDelphiFunction(@CharDecomposeCompatibleStrW, 'CharDecomposeCompatibleStrW', cdRegister);
 S.RegisterDelphiFunction(@CharIn8, 'CharIn8', cdRegister);
 S.RegisterDelphiFunction(@CharIn9, 'CharIn9', cdRegister);
 S.RegisterDelphiFunction(@ConCatBuf, 'ConCatBuf', cdRegister);
 S.RegisterDelphiFunction(@ConCatBufA, 'ConCatBufA', cdRegister);
 S.RegisterDelphiFunction(@ConCatBufW, 'ConCatBufW', cdRegister);
 S.RegisterDelphiFunction(@ConCatChar, 'ConCatChar', cdRegister);
 S.RegisterDelphiFunction(@ConCatCharA, 'ConCatCharA', cdRegister);
 S.RegisterDelphiFunction(@ConCatCharW, 'ConCatCharW', cdRegister);
 S.RegisterDelphiFunction(@ConCatStr, 'ConCatStr', cdRegister);
 S.RegisterDelphiFunction(@ConCatStrA, 'ConCatStrA', cdRegister);
 S.RegisterDelphiFunction(@ConCatStrW, 'ConCatStrW', cdRegister);
 S.RegisterDelphiFunction(@CountBitsSet, 'CountBitsSet', cdRegister);
 S.RegisterDelphiFunction(@Crc32OfStrA, 'Crc32OfStrA', cdRegister);
 S.RegisterDelphiFunction(@Crc32OfStrW, 'Crc32OfStrW', cdRegister);
 S.RegisterDelphiFunction(@CurrentDay, 'CurrentDay', cdRegister);
 S.RegisterDelphiFunction(@CurrentJulianDate, 'CurrentJulianDate', cdRegister);
 S.RegisterDelphiFunction(@CurrentMonth, 'CurrentMonth', cdRegister);
 S.RegisterDelphiFunction(@CurrentQuarter, 'CurrentQuarter', cdRegister);
 S.RegisterDelphiFunction(@CurrentYear, 'CurrentYear', cdRegister);
 S.RegisterDelphiFunction(@DarkenColor, 'DarkenColor', cdRegister);
 S.RegisterDelphiFunction(@DeleteFile, 'DeleteFile', cdRegister);
 S.RegisterDelphiFunction(@DeleteFileA, 'DeleteFileA', cdRegister);
 S.RegisterDelphiFunction(@DeleteFileW, 'DeleteFileW', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'DirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExistsA, 'DirectoryExistsA', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExistsW, 'DirectoryExistsW', cdRegister);
 S.RegisterDelphiFunction(@DiskFree, 'DiskFree', cdRegister);
 S.RegisterDelphiFunction(@DiskFreeA, 'DiskFreeA', cdRegister);
 S.RegisterDelphiFunction(@DiskFreeW, 'DiskFreeW', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileName, 'ExpandFileName', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileNameA, 'ExpandFileNameA', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileNameW, 'ExpandFileNameW', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiter, 'ExcludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiterA, 'ExcludeTrailingPathDelimiterA', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiterW, 'ExcludeTrailingPathDelimiterW', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDrive, 'ExtractFileDrive', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDriveA, 'ExtractFileDriveA', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDriveW, 'ExtractFileDriveW', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExt, 'ExtractFileExt', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExtA, 'ExtractFileExtA', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExtW, 'ExtractFileExtW', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileName, 'ExtractFileName', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileNameA, 'ExtractFileNameA', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileNameW, 'ExtractFileNameW', cdRegister);
 S.RegisterDelphiFunction(@ExtractFilePath, 'ExtractFilePath', cdRegister);
 S.RegisterDelphiFunction(@ExtractFilePathA, 'ExtractFilePathA', cdRegister);
 S.RegisterDelphiFunction(@ExtractFilePathW, 'ExtractFilePathW', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWord10, 'ExtractNextWord10', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWordA11, 'ExtractNextWordA11', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWordW12, 'ExtractNextWordW12', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWord13, 'ExtractNextWord13', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWordA14, 'ExtractNextWordA14', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWordW15, 'ExtractNextWordW15', cdRegister);
 S.RegisterDelphiFunction(@ExtractWordA, 'ExtractWordA', cdRegister);
 S.RegisterDelphiFunction(@ExtractWordStartsA, 'ExtractWordStartsA', cdRegister);
 S.RegisterDelphiFunction(@ExtractWordStartsW, 'ExtractWordStartsW', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'FileExists', cdRegister);
 S.RegisterDelphiFunction(@FileExistsA, 'FileExistsA', cdRegister);
 S.RegisterDelphiFunction(@FileExistsW, 'FileExistsW', cdRegister);
 S.RegisterDelphiFunction(@GCD, 'GCD', cdRegister);
 S.RegisterDelphiFunction(@GetTempFolder, 'GetTempFolder', cdRegister);
 S.RegisterDelphiFunction(@GetTempFolderA, 'GetTempFolderA', cdRegister);
 S.RegisterDelphiFunction(@GetTempFolderW, 'GetTempFolderW', cdRegister);
 S.RegisterDelphiFunction(@GetUserName, 'GetUserName', cdRegister);
 S.RegisterDelphiFunction(@GetUserNameA, 'GetUserNameA', cdRegister);
 S.RegisterDelphiFunction(@GetUserNameW, 'GetUserNameW', cdRegister);
 S.RegisterDelphiFunction(@HexCodePointToInt, 'HexCodePointToInt', cdRegister);
 S.RegisterDelphiFunction(@HexToInt, 'HexToInt', cdRegister);
 S.RegisterDelphiFunction(@HexToIntA, 'HexToIntA', cdRegister);
 S.RegisterDelphiFunction(@HexToIntW, 'HexToIntW', cdRegister);
 S.RegisterDelphiFunction(@BufHexToInt, 'BufHexToInt', cdRegister);
 S.RegisterDelphiFunction(@BufHexToIntA, 'BufHexToIntA', cdRegister);
 S.RegisterDelphiFunction(@BufHexToIntW, 'BufHexToIntW', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiterByRef, 'IncludeTrailingPathDelimiterByRef', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiterByRefA, 'IncludeTrailingPathDelimiterByRefA', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiterByRefW, 'IncludeTrailingPathDelimiterByRefW', cdRegister);
 S.RegisterDelphiFunction(@IntToHex16, 'IntToHex16', cdRegister);
 S.RegisterDelphiFunction(@IntToHex17, 'IntToHex17', cdRegister);
 S.RegisterDelphiFunction(@IntToHex18, 'IntToHex18', cdRegister);
 S.RegisterDelphiFunction(@IntToHexA, 'IntToHexA', cdRegister);
 S.RegisterDelphiFunction(@IntToHexW, 'IntToHexW', cdRegister);
 S.RegisterDelphiFunction(@IntToStrA19, 'IntToStrA19', cdRegister);
 S.RegisterDelphiFunction(@IntToStrW20, 'IntToStrW20', cdRegister);
 S.RegisterDelphiFunction(@IntToStrA21, 'IntToStrA21', cdRegister);
 S.RegisterDelphiFunction(@IntToStrW22, 'IntToStrW22', cdRegister);
 S.RegisterDelphiFunction(@CharDecomposeHangulW, 'CharDecomposeHangulW', cdRegister);
 S.RegisterDelphiFunction(@IsPathDelimiter, 'IsPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IsPathDelimiterA, 'IsPathDelimiterA', cdRegister);
 S.RegisterDelphiFunction(@IsPathDelimiterW, 'IsPathDelimiterW', cdRegister);
 S.RegisterDelphiFunction(@IsPointInRect, 'IsPointInRect', cdRegister);
 S.RegisterDelphiFunction(@JulianDateToIsoDateStr, 'JulianDateToIsoDateStr', cdRegister);
 S.RegisterDelphiFunction(@JulianDateToIsoDateStrA, 'JulianDateToIsoDateStrA', cdRegister);
 S.RegisterDelphiFunction(@JulianDateToIsoDateStrW, 'JulianDateToIsoDateStrW', cdRegister);
 S.RegisterDelphiFunction(@LeftMostBit23, 'LeftMostBit23', cdRegister);
 S.RegisterDelphiFunction(@LeftMostBit24, 'LeftMostBit24', cdRegister);
 S.RegisterDelphiFunction(@MakeMethod, 'MakeMethod', cdRegister);
 S.RegisterDelphiFunction(@StrIsEmpty, 'StrIsEmpty', cdRegister);
 S.RegisterDelphiFunction(@StrIsEmptyA, 'StrIsEmptyA', cdRegister);
 S.RegisterDelphiFunction(@StrIsEmptyW, 'StrIsEmptyW', cdRegister);
 S.RegisterDelphiFunction(@PadLeftA, 'PadLeftA', cdRegister);
 S.RegisterDelphiFunction(@PadLeftW, 'PadLeftW', cdRegister);
 S.RegisterDelphiFunction(@PadRightA, 'PadRightA', cdRegister);
 S.RegisterDelphiFunction(@PadRightW, 'PadRightW', cdRegister);
 S.RegisterDelphiFunction(@ProperCase, 'ProperCase', cdRegister);
 S.RegisterDelphiFunction(@ProperCaseA, 'ProperCaseA', cdRegister);
 S.RegisterDelphiFunction(@ProperCaseW, 'ProperCaseW', cdRegister);
 S.RegisterDelphiFunction(@ProperCaseByRefA, 'ProperCaseByRefA', cdRegister);
 S.RegisterDelphiFunction(@ProperCaseByRefW, 'ProperCaseByRefW', cdRegister);
 S.RegisterDelphiFunction(@RegReadRegisteredOrganization, 'RegReadRegisteredOrganization', cdRegister);
 S.RegisterDelphiFunction(@RegReadRegisteredOrganizationA, 'RegReadRegisteredOrganizationA', cdRegister);
 S.RegisterDelphiFunction(@RegReadRegisteredOrganizationW, 'RegReadRegisteredOrganizationW', cdRegister);
 S.RegisterDelphiFunction(@RegReadRegisteredOwner, 'RegReadRegisteredOwner', cdRegister);
 S.RegisterDelphiFunction(@RegReadRegisteredOwnerA, 'RegReadRegisteredOwnerA', cdRegister);
 S.RegisterDelphiFunction(@RegReadRegisteredOwnerW, 'RegReadRegisteredOwnerW', cdRegister);
 S.RegisterDelphiFunction(@RegReadStrDef, 'RegReadStrDef', cdRegister);
 S.RegisterDelphiFunction(@RegReadStrDefA, 'RegReadStrDefA', cdRegister);
 S.RegisterDelphiFunction(@RegReadStrDefW, 'RegReadStrDefW', cdRegister);
 S.RegisterDelphiFunction(@StrDecodeUrlA, 'StrDecodeUrlA', cdRegister);
 S.RegisterDelphiFunction(@StrEncodeUrlA, 'StrEncodeUrlA', cdRegister);
 S.RegisterDelphiFunction(@StrEnd, 'StrEnd', cdRegister);
 S.RegisterDelphiFunction(@StrEndA, 'StrEndA', cdRegister);
 S.RegisterDelphiFunction(@StrEndW, 'StrEndW', cdRegister);
 S.RegisterDelphiFunction(@StrIncludeTrailingChar, 'StrIncludeTrailingChar', cdRegister);
 S.RegisterDelphiFunction(@StrIncludeTrailingCharA, 'StrIncludeTrailingCharA', cdRegister);
 S.RegisterDelphiFunction(@StrIncludeTrailingCharW, 'StrIncludeTrailingCharW', cdRegister);
 S.RegisterDelphiFunction(@StrLen, 'StrLen', cdRegister);
 S.RegisterDelphiFunction(@StrLenA, 'StrLenA', cdRegister);
 S.RegisterDelphiFunction(@StrLenW, 'StrLenW', cdRegister);
 S.RegisterDelphiFunction(@StrRandom, 'StrRandom', cdRegister);
 S.RegisterDelphiFunction(@StrRandomA, 'StrRandomA', cdRegister);
 S.RegisterDelphiFunction(@StrRandomW, 'StrRandomW', cdRegister);
 S.RegisterDelphiFunction(@StrRemoveFromToIA, 'StrRemoveFromToIA', cdRegister);
 S.RegisterDelphiFunction(@StrRemoveFromToIW, 'StrRemoveFromToIW', cdRegister);
 S.RegisterDelphiFunction(@StrRemoveSpacingA, 'StrRemoveSpacingA', cdRegister);
 S.RegisterDelphiFunction(@StrRemoveSpacingW, 'StrRemoveSpacingW', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceChar, 'StrReplaceChar', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceChar8, 'StrReplaceChar8', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceCharA, 'StrReplaceCharA', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceCharW, 'StrReplaceCharW', cdRegister);
 S.RegisterDelphiFunction(@StrReplace, 'StrReplace', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceA, 'StrReplaceA', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceW, 'StrReplaceW', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceI, 'StrReplaceI', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceIA, 'StrReplaceIA', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceIW, 'StrReplaceIW', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceLoopA, 'StrReplaceLoopA', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceLoopW, 'StrReplaceLoopW', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceLoopIA, 'StrReplaceLoopIA', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceLoopIW, 'StrReplaceLoopIW', cdRegister);
 S.RegisterDelphiFunction(@RightMostBit25, 'RightMostBit25', cdRegister);
 S.RegisterDelphiFunction(@RightMostBit26, 'RightMostBit26', cdRegister);
 S.RegisterDelphiFunction(@LoadStrAFromFile27, 'LoadStrAFromFile27', cdRegister);
 S.RegisterDelphiFunction(@LoadStrAFromFileA, 'LoadStrAFromFileA', cdRegister);
 S.RegisterDelphiFunction(@LoadStrAFromFileW, 'LoadStrAFromFileW', cdRegister);
 S.RegisterDelphiFunction(@LoadStrWFromFile28, 'LoadStrWFromFile28', cdRegister);
 S.RegisterDelphiFunction(@LoadStrWFromFileA, 'LoadStrWFromFileA', cdRegister);
 S.RegisterDelphiFunction(@LoadStrWFromFileW, 'LoadStrWFromFileW', cdRegister);
 S.RegisterDelphiFunction(@QuotedStrW, 'QuotedStrW', cdRegister);
 S.RegisterDelphiFunction(@SaveStrToFile, 'SaveStrToFile', cdRegister);
 S.RegisterDelphiFunction(@SaveStrAToFile, 'SaveStrAToFile', cdRegister);
 S.RegisterDelphiFunction(@SaveStrAToFileA, 'SaveStrAToFileA', cdRegister);
 S.RegisterDelphiFunction(@SaveStrAToFileW, 'SaveStrAToFileW', cdRegister);
 S.RegisterDelphiFunction(@SaveStrWToFile, 'SaveStrWToFile', cdRegister);
 S.RegisterDelphiFunction(@SaveStrWToFileA, 'SaveStrWToFileA', cdRegister);
 S.RegisterDelphiFunction(@SaveStrWToFileW, 'SaveStrWToFileW', cdRegister);
 S.RegisterDelphiFunction(@StrPosChar, 'StrPosChar', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharA, 'StrPosCharA', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharW, 'StrPosCharW', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharBack, 'StrPosCharBack', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharBackA, 'StrPosCharBackA', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharBackW, 'StrPosCharBackW', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharsA, 'StrPosCharsA', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharsW, 'StrPosCharsW', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharsBackA, 'StrPosCharsBackA', cdRegister);
 S.RegisterDelphiFunction(@StrPosNotCharsA, 'StrPosNotCharsA', cdRegister);
 S.RegisterDelphiFunction(@StrPosNotCharsW, 'StrPosNotCharsW', cdRegister);
 S.RegisterDelphiFunction(@StrPosNotCharsBackA, 'StrPosNotCharsBackA', cdRegister);
 S.RegisterDelphiFunction(@SetFileDate29, 'SetFileDate29', cdRegister);
 S.RegisterDelphiFunction(@SetFileDate30, 'SetFileDate30', cdRegister);
 S.RegisterDelphiFunction(@SetFileDateA, 'SetFileDateA', cdRegister);
 S.RegisterDelphiFunction(@SetFileDateW, 'SetFileDateW', cdRegister);
 S.RegisterDelphiFunction(@SetFileDateYmd, 'SetFileDateYmd', cdRegister);
 S.RegisterDelphiFunction(@SetFileDateYmdA, 'SetFileDateYmdA', cdRegister);
 S.RegisterDelphiFunction(@SetFileDateYmdW, 'SetFileDateYmdW', cdRegister);
 S.RegisterDelphiFunction(@StrContainsChar, 'StrContainsChar', cdRegister);
 S.RegisterDelphiFunction(@StrContainsCharA, 'StrContainsCharA', cdRegister);
 S.RegisterDelphiFunction(@StrContainsCharW, 'StrContainsCharW', cdRegister);
 S.RegisterDelphiFunction(@StrContainsCharsA, 'StrContainsCharsA', cdRegister);
 S.RegisterDelphiFunction(@StrHasCharsW, 'StrHasCharsW', cdRegister);
 S.RegisterDelphiFunction(@StrConsistsOfW, 'StrConsistsOfW', cdRegister);
 S.RegisterDelphiFunction(@StrSame, 'StrSame', cdRegister);
 S.RegisterDelphiFunction(@StrSameA, 'StrSameA', cdRegister);
 S.RegisterDelphiFunction(@StrSameW, 'StrSameW', cdRegister);
 S.RegisterDelphiFunction(@StrSameI, 'StrSameI', cdRegister);
 S.RegisterDelphiFunction(@StrSameIA, 'StrSameIA', cdRegister);
 S.RegisterDelphiFunction(@StrSameIW, 'StrSameIW', cdRegister);
 S.RegisterDelphiFunction(@StrSameStart, 'StrSameStart', cdRegister);
 S.RegisterDelphiFunction(@StrSameStartA, 'StrSameStartA', cdRegister);
 S.RegisterDelphiFunction(@StrSameStartW, 'StrSameStartW', cdRegister);
 S.RegisterDelphiFunction(@StrSameStartI, 'StrSameStartI', cdRegister);
 S.RegisterDelphiFunction(@StrSameStartIA, 'StrSameStartIA', cdRegister);
 S.RegisterDelphiFunction(@StrSameStartIW, 'StrSameStartIW', cdRegister);
 S.RegisterDelphiFunction(@StrComp, 'StrComp', cdRegister);
 S.RegisterDelphiFunction(@StrCompA, 'StrCompA', cdRegister);
 S.RegisterDelphiFunction(@StrCompW, 'StrCompW', cdRegister);
 S.RegisterDelphiFunction(@StrCompI, 'StrCompI', cdRegister);
 S.RegisterDelphiFunction(@StrCompIA, 'StrCompIA', cdRegister);
 S.RegisterDelphiFunction(@StrCompIW, 'StrCompIW', cdRegister);
 S.RegisterDelphiFunction(@StrCompNum, 'StrCompNum', cdRegister);
 S.RegisterDelphiFunction(@StrCompNumA, 'StrCompNumA', cdRegister);
 S.RegisterDelphiFunction(@StrCompNumW, 'StrCompNumW', cdRegister);
 S.RegisterDelphiFunction(@StrCompNumI, 'StrCompNumI', cdRegister);
 S.RegisterDelphiFunction(@StrCompNumIA, 'StrCompNumIA', cdRegister);
 S.RegisterDelphiFunction(@StrCompNumIW, 'StrCompNumIW', cdRegister);
 S.RegisterDelphiFunction(@StrContains, 'StrContains', cdRegister);
 S.RegisterDelphiFunction(@StrContainsA, 'StrContainsA', cdRegister);
 S.RegisterDelphiFunction(@StrContainsW, 'StrContainsW', cdRegister);
 S.RegisterDelphiFunction(@StrContainsI, 'StrContainsI', cdRegister);
 S.RegisterDelphiFunction(@StrContainsIA, 'StrContainsIA', cdRegister);
 S.RegisterDelphiFunction(@StrContainsIW, 'StrContainsIW', cdRegister);
 S.RegisterDelphiFunction(@StrCountChar, 'StrCountChar', cdRegister);
 S.RegisterDelphiFunction(@StrCountCharA, 'StrCountCharA', cdRegister);
 S.RegisterDelphiFunction(@StrCountCharW, 'StrCountCharW', cdRegister);
 S.RegisterDelphiFunction(@StrMatchesA, 'StrMatchesA', cdRegister);
 S.RegisterDelphiFunction(@StrMatchesIA, 'StrMatchesIA', cdRegister);
 S.RegisterDelphiFunction(@StrMatchWild, 'StrMatchWild', cdRegister);
 S.RegisterDelphiFunction(@StrMatchWildA, 'StrMatchWildA', cdRegister);
 S.RegisterDelphiFunction(@StrMatchWildW, 'StrMatchWildW', cdRegister);
 S.RegisterDelphiFunction(@StrMatchWildI, 'StrMatchWildI', cdRegister);
 S.RegisterDelphiFunction(@StrMatchWildIA, 'StrMatchWildIA', cdRegister);
 S.RegisterDelphiFunction(@StrMatchWildIW, 'StrMatchWildIW', cdRegister);
 S.RegisterDelphiFunction(@StrPos, 'StrPos', cdRegister);
 S.RegisterDelphiFunction(@StrPosA, 'StrPosA', cdRegister);
 S.RegisterDelphiFunction(@StrPosW, 'StrPosW', cdRegister);
 S.RegisterDelphiFunction(@StrPosI, 'StrPosI', cdRegister);
 S.RegisterDelphiFunction(@StrPosIA, 'StrPosIA', cdRegister);
 S.RegisterDelphiFunction(@StrPosIW, 'StrPosIW', cdRegister);
 S.RegisterDelphiFunction(@StrPosBackA, 'StrPosBackA', cdRegister);
 S.RegisterDelphiFunction(@StrPosBackIA, 'StrPosBackIA', cdRegister);
 S.RegisterDelphiFunction(@StrToIntDefW, 'StrToIntDefW', cdRegister);
 S.RegisterDelphiFunction(@StrToInt64DefW, 'StrToInt64DefW', cdRegister);
 S.RegisterDelphiFunction(@StrToUpper, 'StrToUpper', cdRegister);
 S.RegisterDelphiFunction(@StrToUpperA, 'StrToUpperA', cdRegister);
 S.RegisterDelphiFunction(@StrToUpperW, 'StrToUpperW', cdRegister);
 S.RegisterDelphiFunction(@StrToUpperInPlace, 'StrToUpperInPlace', cdRegister);
 S.RegisterDelphiFunction(@StrToUpperInPlaceA, 'StrToUpperInPlaceA', cdRegister);
 S.RegisterDelphiFunction(@StrToUpperInPlaceW31, 'StrToUpperInPlaceW31', cdRegister);
 S.RegisterDelphiFunction(@StrToUpperInPlaceW32, 'StrToUpperInPlaceW32', cdRegister);
 S.RegisterDelphiFunction(@StrToLower, 'StrToLower', cdRegister);
 S.RegisterDelphiFunction(@StrToLowerA, 'StrToLowerA', cdRegister);
 S.RegisterDelphiFunction(@StrToLowerW, 'StrToLowerW', cdRegister);
 S.RegisterDelphiFunction(@StrToLowerInPlace, 'StrToLowerInPlace', cdRegister);
 S.RegisterDelphiFunction(@StrToLowerInPlaceA, 'StrToLowerInPlaceA', cdRegister);
 S.RegisterDelphiFunction(@StrToLowerInPlaceW33, 'StrToLowerInPlaceW33', cdRegister);
 S.RegisterDelphiFunction(@StrToLowerInPlaceW34, 'StrToLowerInPlaceW34', cdRegister);
 S.RegisterDelphiFunction(@StrTimUriFragmentA, 'StrTimUriFragmentA', cdRegister);
 S.RegisterDelphiFunction(@StrTrimUriFragmentW, 'StrTrimUriFragmentW', cdRegister);
 S.RegisterDelphiFunction(@StrExtractUriFragmentW, 'StrExtractUriFragmentW', cdRegister);
 S.RegisterDelphiFunction(@StrCountUtf8Chars, 'StrCountUtf8Chars', cdRegister);
 S.RegisterDelphiFunction(@StrDecodeUtf8, 'StrDecodeUtf8', cdRegister);
 S.RegisterDelphiFunction(@StrEncodeUtf8, 'StrEncodeUtf8', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessage, 'SysErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessageA, 'SysErrorMessageA', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessageW, 'SysErrorMessageW', cdRegister);
 S.RegisterDelphiFunction(@TextExtentW, 'TextExtentW', cdRegister);
 S.RegisterDelphiFunction(@TextHeightW, 'TextHeightW', cdRegister);
 S.RegisterDelphiFunction(@TextWidthW, 'TextWidthW', cdRegister);
 S.RegisterDelphiFunction(@StrTrim, 'StrTrim', cdRegister);
 S.RegisterDelphiFunction(@StrTrimA, 'StrTrimA', cdRegister);
 S.RegisterDelphiFunction(@StrTrimW, 'StrTrimW', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCharA, 'StrTrimCharA', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCharsA, 'StrTrimCharsA', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCharsW, 'StrTrimCharsW', cdRegister);
 S.RegisterDelphiFunction(@TrimLeftByRefA, 'TrimLeftByRefA', cdRegister);
 S.RegisterDelphiFunction(@TrimRightA, 'TrimRightA', cdRegister);
 S.RegisterDelphiFunction(@TrimRightByRefA, 'TrimRightByRefA', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCompressA, 'StrTrimCompressA', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCompressW, 'StrTrimCompressW', cdRegister);
 S.RegisterDelphiFunction(@TrimRightByRefW, 'TrimRightByRefW', cdRegister);
 S.RegisterDelphiFunction(@TryStrToIntW, 'TryStrToIntW', cdRegister);
 S.RegisterDelphiFunction(@TryStrToInt64W, 'TryStrToInt64W', cdRegister);
 S.RegisterDelphiFunction(@ValInt35, 'ValInt35', cdRegister);
 S.RegisterDelphiFunction(@ValIntA36, 'ValIntA36', cdRegister);
 S.RegisterDelphiFunction(@ValIntW37, 'ValIntW37', cdRegister);
 S.RegisterDelphiFunction(@ValInt38, 'ValInt38', cdRegister);
 S.RegisterDelphiFunction(@ValIntA39, 'ValIntA39', cdRegister);
 S.RegisterDelphiFunction(@ValIntW40, 'ValIntW40', cdRegister);
 S.RegisterDelphiFunction(@ValInt64A41, 'ValInt64A41', cdRegister);
 S.RegisterDelphiFunction(@ValInt64W42, 'ValInt64W42', cdRegister);
 S.RegisterDelphiFunction(@ValInt64A43, 'ValInt64A43', cdRegister);
 S.RegisterDelphiFunction(@ValInt64W44, 'ValInt64W44', cdRegister);
 S.RegisterDelphiFunction(@YmdToIsoDateStr, 'YmdToIsoDateStr', cdRegister);
 S.RegisterDelphiFunction(@YmdToIsoDateStrA, 'YmdToIsoDateStrA', cdRegister);
 S.RegisterDelphiFunction(@YmdToIsoDateStrW, 'YmdToIsoDateStrW', cdRegister);
 S.RegisterDelphiFunction(@CharIsLetterW, 'CharIsLetterW', cdRegister);
 S.RegisterDelphiFunction(@CharIsLetterCommonW, 'CharIsLetterCommonW', cdRegister);
 S.RegisterDelphiFunction(@CharIsLetterUpperCaseW, 'CharIsLetterUpperCaseW', cdRegister);
 S.RegisterDelphiFunction(@CharIsLetterLowerCaseW, 'CharIsLetterLowerCaseW', cdRegister);
 S.RegisterDelphiFunction(@CharIsLetterTitleCaseW, 'CharIsLetterTitleCaseW', cdRegister);
 S.RegisterDelphiFunction(@CharIsLetterModifierW, 'CharIsLetterModifierW', cdRegister);
 S.RegisterDelphiFunction(@CharIsLetterOtherW, 'CharIsLetterOtherW', cdRegister);
 S.RegisterDelphiFunction(@CharIsMarkW, 'CharIsMarkW', cdRegister);
 S.RegisterDelphiFunction(@CharIsMarkNon_SpacingW, 'CharIsMarkNon_SpacingW', cdRegister);
 S.RegisterDelphiFunction(@CharIsMarkSpacing_CombinedW, 'CharIsMarkSpacing_CombinedW', cdRegister);
 S.RegisterDelphiFunction(@CharIsMarkEnclosingW, 'CharIsMarkEnclosingW', cdRegister);
 S.RegisterDelphiFunction(@CharIsNumberW, 'CharIsNumberW', cdRegister);
 S.RegisterDelphiFunction(@CharIsNumber_DecimalW, 'CharIsNumber_DecimalW', cdRegister);
 S.RegisterDelphiFunction(@CharIsNumber_LetterW, 'CharIsNumber_LetterW', cdRegister);
 S.RegisterDelphiFunction(@CharIsNumber_OtherW, 'CharIsNumber_OtherW', cdRegister);
 S.RegisterDelphiFunction(@CharIsPunctuationW, 'CharIsPunctuationW', cdRegister);
 S.RegisterDelphiFunction(@CharIsPunctuation_ConnectorW, 'CharIsPunctuation_ConnectorW', cdRegister);
 S.RegisterDelphiFunction(@CharIsPunctuation_DashW, 'CharIsPunctuation_DashW', cdRegister);
 S.RegisterDelphiFunction(@CharIsPunctuation_OpenW, 'CharIsPunctuation_OpenW', cdRegister);
 S.RegisterDelphiFunction(@CharIsPunctuation_CloseW,'CharIsPunctuation_CloseW',cdRegister);
 S.RegisterDelphiFunction(@CharIsPunctuation_InitialQuoteW, 'CharIsPunctuation_InitialQuoteW', cdRegister);
 S.RegisterDelphiFunction(@CharIsPunctuation_FinalQuoteW, 'CharIsPunctuation_FinalQuoteW', cdRegister);
 S.RegisterDelphiFunction(@CharIsPunctuation_OtherW,'CharIsPunctuation_OtherW',cdRegister);
 S.RegisterDelphiFunction(@CharIsSymbolW, 'CharIsSymbolW', cdRegister);
 S.RegisterDelphiFunction(@CharIsSymbolMathW, 'CharIsSymbolMathW', cdRegister);
 S.RegisterDelphiFunction(@CharIsSymbolCurrencyW, 'CharIsSymbolCurrencyW', cdRegister);
 S.RegisterDelphiFunction(@CharIsSymbolModifierW, 'CharIsSymbolModifierW', cdRegister);
 S.RegisterDelphiFunction(@CharIsSymbolOtherW, 'CharIsSymbolOtherW', cdRegister);
 S.RegisterDelphiFunction(@CharIsSeparatorW, 'CharIsSeparatorW', cdRegister);
 S.RegisterDelphiFunction(@CharIsSeparatorSpaceW, 'CharIsSeparatorSpaceW', cdRegister);
 S.RegisterDelphiFunction(@CharIsSeparatorLineW, 'CharIsSeparatorLineW', cdRegister);
 S.RegisterDelphiFunction(@CharIsSeparatorParagraphW, 'CharIsSeparatorParagraphW', cdRegister);
 S.RegisterDelphiFunction(@CharIsOtherW, 'CharIsOtherW', cdRegister);
 S.RegisterDelphiFunction(@CharIsOtherControlW, 'CharIsOtherControlW', cdRegister);
 S.RegisterDelphiFunction(@CharIsOtherFormatW, 'CharIsOtherFormatW', cdRegister);
 S.RegisterDelphiFunction(@CharIsOtherSurrogateW, 'CharIsOtherSurrogateW', cdRegister);
 S.RegisterDelphiFunction(@CharIsOtherPrivateUseW, 'CharIsOtherPrivateUseW', cdRegister);
 S.RegisterDelphiFunction(@BitClear, 'BitClear', cdRegister);
 S.RegisterDelphiFunction(@BitSet, 'BitSet', cdRegister);
 S.RegisterDelphiFunction(@BitSetTo, 'BitSetTo', cdRegister);
 S.RegisterDelphiFunction(@BitTest, 'BitTest', cdRegister);
 S.RegisterDelphiFunction(@CharCanonicalCombiningClassW, 'CharCanonicalCombiningClassW', cdRegister);
 S.RegisterDelphiFunction(@CharIsAlphaW, 'CharIsAlphaW', cdRegister);
 S.RegisterDelphiFunction(@CharIsAlphaNumW, 'CharIsAlphaNumW', cdRegister);
 S.RegisterDelphiFunction(@CharIsCrLf, 'CharIsCrLf', cdRegister);
 S.RegisterDelphiFunction(@CharIsCrLfA, 'CharIsCrLfA', cdRegister);
 S.RegisterDelphiFunction(@CharIsCrLfW, 'CharIsCrLfW', cdRegister);
 S.RegisterDelphiFunction(@CharIsDigit, 'CharIsDigit', cdRegister);
 S.RegisterDelphiFunction(@CharIsDigitA, 'CharIsDigitA', cdRegister);
 S.RegisterDelphiFunction(@CharIsDigitW, 'CharIsDigitW', cdRegister);
 S.RegisterDelphiFunction(@CharIsHangulW, 'CharIsHangulW', cdRegister);
 S.RegisterDelphiFunction(@CharIsHexDigitW, 'CharIsHexDigitW', cdRegister);
 S.RegisterDelphiFunction(@CharIsWhiteSpaceW, 'CharIsWhiteSpaceW', cdRegister);
 S.RegisterDelphiFunction(@CharToCaseFoldW, 'CharToCaseFoldW', cdRegister);
 S.RegisterDelphiFunction(@CharToLowerW, 'CharToLowerW', cdRegister);
 S.RegisterDelphiFunction(@CharToUpperW, 'CharToUpperW', cdRegister);
 S.RegisterDelphiFunction(@CharToTitleW, 'CharToTitleW', cdRegister);
 S.RegisterDelphiFunction(@DayOfJulianDate, 'DayOfJulianDate', cdRegister);
 S.RegisterDelphiFunction(@DayOfWeek, 'DayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@DayOfWeekYmd, 'DayOfWeekYmd', cdRegister);
 S.RegisterDelphiFunction(@DaysInMonth, 'DaysInMonth', cdRegister);
 S.RegisterDelphiFunction(@DaysInMonthYm, 'DaysInMonthYm', cdRegister);
 S.RegisterDelphiFunction(@DecDay, 'DecDay', cdRegister);
 S.RegisterDelphiFunction(@DecDays, 'DecDays', cdRegister);
 S.RegisterDelphiFunction(@DeleteDirectory, 'DeleteDirectory', cdRegister);
 S.RegisterDelphiFunction(@DeleteDirectoryA, 'DeleteDirectoryA', cdRegister);
 S.RegisterDelphiFunction(@DeleteDirectoryW, 'DeleteDirectoryW', cdRegister);
 S.RegisterDelphiFunction(@EasterSunday, 'EasterSunday', cdRegister);
 S.RegisterDelphiFunction(@EasterSundayYmd, 'EasterSundayYmd', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfWeek, 'FirstDayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfWeekYmd, 'FirstDayOfWeekYmd', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfMonth, 'FirstDayOfMonth', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfMonthYmd, 'FirstDayOfMonthYmd', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'ForceDirectories', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectoriesA, 'ForceDirectoriesA', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectoriesW, 'ForceDirectoriesW', cdRegister);
 S.RegisterDelphiFunction(@FreeMemAndNil, 'FreeMemAndNil', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentFolder, 'GetCurrentFolder', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentFolderA, 'GetCurrentFolderA', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentFolderW, 'GetCurrentFolderW', cdRegister);
 S.RegisterDelphiFunction(@SetCurrentFolder, 'SetCurrentFolder', cdRegister);
 S.RegisterDelphiFunction(@SetCurrentFolderA, 'SetCurrentFolderA', cdRegister);
 S.RegisterDelphiFunction(@SetCurrentFolderW, 'SetCurrentFolderW', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopFolder, 'GetDesktopFolder', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopFolderA, 'GetDesktopFolderA', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopFolderW, 'GetDesktopFolderW', cdRegister);
 S.RegisterDelphiFunction(@GetFileSize, 'GetFileSize', cdRegister);
 S.RegisterDelphiFunction(@GetFileSizeA, 'GetFileSizeA', cdRegister);
 S.RegisterDelphiFunction(@GetFileSizeW, 'GetFileSizeW', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopDirectoryFolder, 'GetDesktopDirectoryFolder', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopDirectoryFolderA, 'GetDesktopDirectoryFolderA', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopDirectoryFolderW, 'GetDesktopDirectoryFolderW', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastWriteTime, 'GetFileLastWriteTime', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastWriteTimeA, 'GetFileLastWriteTimeA', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastWriteTimeW, 'GetFileLastWriteTimeW', cdRegister);
 S.RegisterDelphiFunction(@GetPersonalFolder, 'GetPersonalFolder', cdRegister);
 S.RegisterDelphiFunction(@GetPersonalFolderA, 'GetPersonalFolderA', cdRegister);
 S.RegisterDelphiFunction(@GetPersonalFolderW, 'GetPersonalFolderW', cdRegister);
 S.RegisterDelphiFunction(@GetSpecialFolder, 'GetSpecialFolder', cdRegister);
 S.RegisterDelphiFunction(@GetSpecialFolderA, 'GetSpecialFolderA', cdRegister);
 S.RegisterDelphiFunction(@GetSpecialFolderW, 'GetSpecialFolderW', cdRegister);
 S.RegisterDelphiFunction(@IncMonth, 'IncMonth', cdRegister);
 S.RegisterDelphiFunction(@IncMonths, 'IncMonths', cdRegister);
 S.RegisterDelphiFunction(@IncDay, 'IncDay', cdRegister);
 S.RegisterDelphiFunction(@IncDays, 'IncDays', cdRegister);
 S.RegisterDelphiFunction(@IsDateValid, 'IsDateValid', cdRegister);
 S.RegisterDelphiFunction(@IsHolidayInGermany, 'IsHolidayInGermany', cdRegister);
 S.RegisterDelphiFunction(@IsHolidayInGermanyYmd, 'IsHolidayInGermanyYmd', cdRegister);
 S.RegisterDelphiFunction(@IsLeapYear, 'IsLeapYear', cdRegister);
 S.RegisterDelphiFunction(@ISODateToJulianDate, 'ISODateToJulianDate', cdRegister);
 S.RegisterDelphiFunction(@ISODateToYmd, 'ISODateToYmd', cdRegister);
 S.RegisterDelphiFunction(@IsCharLowLineW, 'IsCharLowLineW', cdRegister);
 S.RegisterDelphiFunction(@IsCharQuoteW, 'IsCharQuoteW', cdRegister);
 S.RegisterDelphiFunction(@IsShiftKeyDown, 'IsShiftKeyDown', cdRegister);
 S.RegisterDelphiFunction(@IsCharWhiteSpaceOrAmpersandW, 'IsCharWhiteSpaceOrAmpersandW', cdRegister);
 S.RegisterDelphiFunction(@IsCharWhiteSpaceOrNoBreakSpaceW, 'IsCharWhiteSpaceOrNoBreakSpaceW', cdRegister);
 S.RegisterDelphiFunction(@IsCharWhiteSpaceOrColonW,'IsCharWhiteSpaceOrColonW',cdRegister);
 S.RegisterDelphiFunction(@CharIsWhiteSpaceGtW, 'CharIsWhiteSpaceGtW', cdRegister);
 S.RegisterDelphiFunction(@CharIsWhiteSpaceLtW, 'CharIsWhiteSpaceLtW', cdRegister);
 S.RegisterDelphiFunction(@CharIsWhiteSpaceHyphenW, 'CharIsWhiteSpaceHyphenW', cdRegister);
 S.RegisterDelphiFunction(@CharIsWhiteSpaceHyphenGtW, 'CharIsWhiteSpaceHyphenGtW', cdRegister);
 S.RegisterDelphiFunction(@IsCharWordSeparatorW, 'IsCharWordSeparatorW', cdRegister);
 S.RegisterDelphiFunction(@ISOWeekNumber, 'ISOWeekNumber', cdRegister);
 S.RegisterDelphiFunction(@ISOWeekNumberYmd, 'ISOWeekNumberYmd', cdRegister);
 S.RegisterDelphiFunction(@ISOWeekToJulianDate, 'ISOWeekToJulianDate', cdRegister);
 S.RegisterDelphiFunction(@JulianDateIsWeekDay, 'JulianDateIsWeekDay', cdRegister);
 S.RegisterDelphiFunction(@JulianDateToIsoDate, 'JulianDateToIsoDate', cdRegister);
 S.RegisterDelphiFunction(@JulianDateToYmd, 'JulianDateToYmd', cdRegister);
 S.RegisterDelphiFunction(@LastDayOfMonth, 'LastDayOfMonth', cdRegister);
 S.RegisterDelphiFunction(@LastDayOfMonthYmd, 'LastDayOfMonthYmd', cdRegister);
 S.RegisterDelphiFunction(@LastDayOfWeek, 'LastDayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@LastDayOfWeekYmd, 'LastDayOfWeekYmd', cdRegister);
 S.RegisterDelphiFunction(@LastSysErrorMessage, 'LastSysErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@LastSysErrorMessageA, 'LastSysErrorMessageA', cdRegister);
 S.RegisterDelphiFunction(@LastSysErrorMessageW, 'LastSysErrorMessageW', cdRegister);
 S.RegisterDelphiFunction(@Max45, 'Max45', cdRegister);
 S.RegisterDelphiFunction(@Max3, 'Max3', cdRegister);
 S.RegisterDelphiFunction(@Max46, 'Max46', cdRegister);
 S.RegisterDelphiFunction(@Max47, 'Max47', cdRegister);
 S.RegisterDelphiFunction(@Max48, 'Max48', cdRegister);
 S.RegisterDelphiFunction(@Max49, 'Max49', cdRegister);
 S.RegisterDelphiFunction(@Min50, 'Min50', cdRegister);
 S.RegisterDelphiFunction(@Min3, 'Min3', cdRegister);
 S.RegisterDelphiFunction(@Min51, 'Min51', cdRegister);
 S.RegisterDelphiFunction(@Min52, 'Min52', cdRegister);
 S.RegisterDelphiFunction(@Min53, 'Min53', cdRegister);
 S.RegisterDelphiFunction(@Min54, 'Min54', cdRegister);
 S.RegisterDelphiFunction(@Min55, 'Min55', cdRegister);
 S.RegisterDelphiFunction(@Min56, 'Min56', cdRegister);
 S.RegisterDelphiFunction(@MonthOfJulianDate, 'MonthOfJulianDate', cdRegister);
 S.RegisterDelphiFunction(@YearOfJuilanDate, 'YearOfJuilanDate', cdRegister);
 S.RegisterDelphiFunction(@YmdToIsoDate, 'YmdToIsoDate', cdRegister);
 S.RegisterDelphiFunction(@YmdToJulianDate, 'YmdToJulianDate', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWideStrBuf(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWideStrBuf) do
  begin
    RegisterMethod(@TWideStrBuf.AddBuf, 'AddBuf');
    RegisterMethod(@TWideStrBuf.AddChar, 'AddChar');
    RegisterMethod(@TWideStrBuf.AddCrLf, 'AddCrLf');
    RegisterMethod(@TWideStrBuf.AddStr, 'AddStr');
    RegisterPropertyHelper(@TWideStrBufAsStr_R,nil,'AsStr');
    RegisterPropertyHelper(@TWideStrBufAsStrTrimRight_R,nil,'AsStrTrimRight');
    RegisterPropertyHelper(@TWideStrBufBuf_R,nil,'Buf');
    RegisterMethod(@TWideStrBuf.Clear, 'Clear');
    RegisterPropertyHelper(@TWideStrBufCount_R,nil,'Count');
    RegisterMethod(@TWideStrBuf.Delete, 'Delete');
    RegisterMethod(@TWideStrBuf.IsEmpty, 'IsEmpty');
    RegisterMethod(@TWideStrBuf.IsNotEmpty, 'IsNotEmpty');
    RegisterMethod(@TWideStrBuf.Reset, 'Reset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMT19937(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMT19937) do
  begin
    RegisterConstructor(@TMT19937Create0_P, 'Create0');
    RegisterConstructor(@TMT19937Create1_P, 'Create1');
    RegisterConstructor(@TMT19937Create2_P, 'Create2');
    RegisterConstructor(@TMT19937Create3_P, 'Create3');
    RegisterMethod(@TMT19937.init_genrand, 'init_genrand');
    RegisterMethod(@TMT19937.init_by_array, 'init_by_array');
    RegisterMethod(@TMT19937.init_by_StrA, 'init_by_StrA');
    RegisterMethod(@TMT19937.genrand_int32, 'genrand_int32');
    RegisterMethod(@TMT19937.genrand_int31, 'genrand_int31');
    RegisterMethod(@TMT19937.genrand_int64, 'genrand_int64');
    RegisterMethod(@TMT19937.genrand_int63, 'genrand_int63');
    RegisterMethod(@TMT19937.genrand_real1, 'genrand_real1');
    RegisterMethod(@TMT19937.genrand_real2, 'genrand_real2');
    RegisterMethod(@TMT19937.genrand_real3, 'genrand_real3');
    RegisterMethod(@TMT19937.genrand_res53, 'genrand_res53');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DIUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMT19937(CL);
  RIRegister_TWideStrBuf(CL);
end;

 
 
{ TPSImport_DIUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DIUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DIUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DIUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DIUtils(ri);
  RIRegister_DIUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
