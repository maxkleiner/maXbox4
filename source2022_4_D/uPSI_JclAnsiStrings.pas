unit uPSI_JclAnsiStrings;
{
   proper and prepare for jclwidestring and unicode
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
  TPSImport_JclAnsiStrings = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclAnsiStrings(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclAnsiStrings_Routines(S: TPSExec);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,JclWideStrings
  ,JclBase
  ,JclAnsiStrings
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclAnsiStrings]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclAnsiStrings(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('AnsiNull','Char').SetString( AnsiChar ( #0 ));
 CL.AddConstantN('AnsiSoh','Char').SetString( AnsiChar ( #1 ));
 CL.AddConstantN('AnsiStx','Char').SetString( AnsiChar ( #2 ));
 CL.AddConstantN('AnsiEtx','Char').SetString( AnsiChar ( #3 ));
 CL.AddConstantN('AnsiEot','Char').SetString( AnsiChar ( #4 ));
 CL.AddConstantN('AnsiEnq','Char').SetString( AnsiChar ( #5 ));
 CL.AddConstantN('AnsiAck','Char').SetString( AnsiChar ( #6 ));
 CL.AddConstantN('AnsiBell','Char').SetString( AnsiChar ( #7 ));
 CL.AddConstantN('AnsiBackspace','Char').SetString( AnsiChar ( #8 ));
 CL.AddConstantN('AnsiTab','Char').SetString( AnsiChar ( #9 ));
 CL.AddConstantN('AnsiVerticalTab','Char').SetString( AnsiChar ( #11 ));
 CL.AddConstantN('AnsiFormFeed','Char').SetString( AnsiChar ( #12 ));
 CL.AddConstantN('AnsiSo','Char').SetString( AnsiChar ( #14 ));
 CL.AddConstantN('AnsiSi','Char').SetString( AnsiChar ( #15 ));
 CL.AddConstantN('AnsiDle','Char').SetString( AnsiChar ( #16 ));
 CL.AddConstantN('AnsiDc1','Char').SetString( AnsiChar ( #17 ));
 CL.AddConstantN('AnsiDc2','Char').SetString( AnsiChar ( #18 ));
 CL.AddConstantN('AnsiDc3','Char').SetString( AnsiChar ( #19 ));
 CL.AddConstantN('AnsiDc4','Char').SetString( AnsiChar ( #20 ));
 CL.AddConstantN('AnsiNak','Char').SetString( AnsiChar ( #21 ));
 CL.AddConstantN('AnsiSyn','Char').SetString( AnsiChar ( #22 ));
 CL.AddConstantN('AnsiEtb','Char').SetString( AnsiChar ( #23 ));
 CL.AddConstantN('AnsiCan','Char').SetString( AnsiChar ( #24 ));
 CL.AddConstantN('AnsiEm','Char').SetString( AnsiChar ( #25 ));
 CL.AddConstantN('AnsiEndOfFile','Char').SetString( AnsiChar ( #26 ));
 CL.AddConstantN('AnsiEscape','Char').SetString( AnsiChar ( #27 ));
 CL.AddConstantN('AnsiFs','Char').SetString( AnsiChar ( #28 ));
 CL.AddConstantN('AnsiGs','Char').SetString( AnsiChar ( #29 ));
 CL.AddConstantN('AnsiRs','Char').SetString( AnsiChar ( #30 ));
 CL.AddConstantN('AnsiUs','Char').SetString( AnsiChar ( #31 ));
 CL.AddConstantN('AnsiSpace','String').SetString( AnsiChar ( ' ' ));
 CL.AddConstantN('AnsiComma','String').SetString( AnsiChar ( ',' ));
 CL.AddConstantN('AnsiBackslash','String').SetString( AnsiChar ( '\' ));
 CL.AddConstantN('AnsiForwardSlash','String').SetString( AnsiChar ( '/' ));
 CL.AddConstantN('AnsiDoubleQuote','String').SetString( AnsiChar ( '"' ));
 CL.AddConstantN('AnsiSingleQuote','String').SetString( AnsiChar ( '''' ));
 CL.AddConstantN('AnsiWhiteSpace','LongInt').Value.ts32 := ord(AnsiTab) or ord(AnsiLineFeed) or ord(AnsiVerticalTab) or ord(AnsiFormFeed) or ord(AnsiCarriageReturn) or ord(AnsiSpace);
 //CL.AddConstantN('AnsiSigns','Set').SetSet(['-', '+']);
 CL.AddConstantN('C1_UPPER','LongWord').SetUInt( $0001);
 CL.AddConstantN('C1_LOWER','LongWord').SetUInt( $0002);
 CL.AddConstantN('C1_DIGIT','LongWord').SetUInt( $0004);
 CL.AddConstantN('C1_SPACE','LongWord').SetUInt( $0008);
 CL.AddConstantN('C1_PUNCT','LongWord').SetUInt( $0010);
 CL.AddConstantN('C1_CNTRL','LongWord').SetUInt( $0020);
 CL.AddConstantN('C1_BLANK','LongWord').SetUInt( $0040);
 CL.AddConstantN('C1_XDIGIT','LongWord').SetUInt( $0080);
 CL.AddConstantN('C1_ALPHA','LongWord').SetUInt( $0100);
  CL.AddTypeS('AnsiChar', 'Char');
  CL.AddClassN(CL.FindClass('EJclError'),'EJclConversionError');

  //CL.AddTypeS('EJclConversionError', 'EJclError');
   //type
  //EJclConversionError = class(EJclError);
 
 CL.AddDelphiFunction('Function StrIsAlpha( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function StrIsAlphaNum( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function StrIsAlphaNumUnderscore( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function StrContainsChars( const S : AnsiString; Chars : TSysCharSet; CheckAll : Boolean) : Boolean');
 CL.AddDelphiFunction('Function StrConsistsOfNumberChars( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function StrIsDigit( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function StrIsSubset( const S : AnsiString; const ValidChars : TSysCharSet) : Boolean');
 CL.AddDelphiFunction('Function StrSame( const S1, S2 : AnsiString) : Boolean');
 //CL.AddDelphiFunction('Function StrCenter( const S : AnsiString; L : Integer; C : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function StrCharPosLower( const S : AnsiString; CharPos : Integer) : AnsiString');
 CL.AddDelphiFunction('Function StrCharPosUpper( const S : AnsiString; CharPos : Integer) : AnsiString');
 CL.AddDelphiFunction('Function StrDoubleQuote( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrEnsureNoPrefix( const Prefix, Text : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrEnsureNoSuffix( const Suffix, Text : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrEnsurePrefix( const Prefix, Text : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrEnsureSuffix( const Suffix, Text : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrEscapedToString( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function JStrLower( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure StrLowerInPlace( var S : AnsiString)');
 ///CL.AddDelphiFunction('Procedure StrLowerBuff( S : PAnsiChar)');
 CL.AddDelphiFunction('Procedure JStrMove( var Dest : AnsiString; const Source : AnsiString; const ToIndex, FromIndex, Count : Integer)');
 CL.AddDelphiFunction('Function StrPadLeft( const S : AnsiString; Len : Integer; C : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function StrPadRight( const S : AnsiString; Len : Integer; C : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function StrProper( const S : AnsiString) : AnsiString');
 //CL.AddDelphiFunction('Procedure StrProperBuff( S : PAnsiChar)');
 CL.AddDelphiFunction('Function StrQuote( const S : AnsiString; C : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function StrRemoveChars( const S : AnsiString; const Chars : TSysCharSet) : AnsiString');
 CL.AddDelphiFunction('Function StrKeepChars( const S : AnsiString; const Chars : TSysCharSet) : AnsiString');
 CL.AddDelphiFunction('Procedure JStrReplace( var S : AnsiString; const Search, Replace : AnsiString; Flags : TReplaceFlags)');
 CL.AddDelphiFunction('Function StrReplaceChar( const S : AnsiString; const Source, Replace : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function StrReplaceChars( const S : AnsiString; const Chars : TSysCharSet; Replace : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function StrReplaceButChars( const S : AnsiString; const Chars : TSysCharSet; Replace : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function StrRepeat( const S : AnsiString; Count : Integer) : AnsiString');
 CL.AddDelphiFunction('Function StrRepeatLength( const S : AnsiString; const L : Integer) : AnsiString');
 CL.AddDelphiFunction('Function StrReverse( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure StrReverseInPlace( var S : AnsiString)');
 CL.AddDelphiFunction('Function StrSingleQuote( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrSmartCase( const S : AnsiString; Delimiters : TSysCharSet) : AnsiString');
 CL.AddDelphiFunction('Function StrStringToEscaped( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrStripNonNumberChars( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrToHex( const Source : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrTrimCharLeft( const S : AnsiString; C : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function StrTrimCharsLeft( const S : AnsiString; const Chars : TSysCharSet) : AnsiString');
 CL.AddDelphiFunction('Function StrTrimCharRight( const S : AnsiString; C : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function StrTrimCharsRight( const S : AnsiString; const Chars : TSysCharSet) : AnsiString');
 CL.AddDelphiFunction('Function StrTrimQuotes( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function JStrUpper( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure StrUpperInPlace( var S : AnsiString)');
 //CL.AddDelphiFunction('Procedure StrUpperBuff( S : PAnsiChar)');
 CL.AddDelphiFunction('Function StrOemToAnsi( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrAnsiToOem( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure StrAddRef( var S : AnsiString)');
 CL.AddDelphiFunction('Function StrAllocSize( const S : AnsiString) : Longint');
 CL.AddDelphiFunction('Procedure StrDecRef( var S : AnsiString)');
 //CL.AddDelphiFunction('Function StrLen( S : PAnsiChar) : Integer');
 CL.AddDelphiFunction('Function StrLength( const S : AnsiString) : Longint');
 CL.AddDelphiFunction('Function StrRefCount( const S : AnsiString) : Longint');
 CL.AddDelphiFunction('Procedure StrResetLength( var S : AnsiString)');
 CL.AddDelphiFunction('Function StrCharCount( const S : AnsiString; C : AnsiChar) : Integer');
 CL.AddDelphiFunction('Function StrCharsCount( const S : AnsiString; Chars : TSysCharSet) : Integer');
 CL.AddDelphiFunction('Function StrStrCount( const S, SubS : AnsiString) : Integer');
 CL.AddDelphiFunction('Function StrCompare( const S1, S2 : AnsiString) : Integer');
 CL.AddDelphiFunction('Function StrCompareRange( const S1, S2 : AnsiString; const Index, Count : Integer) : Integer');
 //CL.AddDelphiFunction('Function StrFillChar( const C : AnsiChar; Count : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function StrFillChar1( const C : Char; Count : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function StrFind( const Substr, S : AnsiString; const Index : Integer) : Integer');
 //CL.AddDelphiFunction('Function StrHasPrefix( const S : AnsiString; const Prefixes : array of AnsiString) : Boolean');
 CL.AddDelphiFunction('Function StrIndex( const S : AnsiString; const List : array of AnsiString) : Integer');
 CL.AddDelphiFunction('Function StrILastPos( const SubStr, S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function StrIPos( const SubStr, S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function StrIsOneOf( const S : AnsiString; const List : array of AnsiString) : Boolean');
 CL.AddDelphiFunction('Function StrLastPos( const SubStr, S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function StrMatch( const Substr, S : AnsiString; const Index : Integer) : Integer');
 CL.AddDelphiFunction('Function StrMatches( const Substr, S : AnsiString; const Index : Integer) : Boolean');
 CL.AddDelphiFunction('Function StrNIPos( const S, SubStr : AnsiString; N : Integer) : Integer');
 CL.AddDelphiFunction('Function StrNPos( const S, SubStr : AnsiString; N : Integer) : Integer');
 CL.AddDelphiFunction('Function StrPrefixIndex( const S : AnsiString; const Prefixes : array of AnsiString) : Integer');
 CL.AddDelphiFunction('Function StrSearch( const Substr, S : AnsiString; const Index : Integer) : Integer');
 //CL.AddDelphiFunction('Function StrAfter( const SubStr, S : AnsiString) : AnsiString');
 //CL.AddDelphiFunction('Function StrBefore( const SubStr, S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrBetween( const S : AnsiString; const Start, Stop : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function StrChopRight( const S : AnsiString; N : Integer) : AnsiString');
 CL.AddDelphiFunction('Function StrLeft( const S : AnsiString; Count : Integer) : AnsiString');
 CL.AddDelphiFunction('Function StrMid( const S : AnsiString; Start, Count : Integer) : AnsiString');
 CL.AddDelphiFunction('Function StrRestOf( const S : AnsiString; N : Integer) : AnsiString');
 CL.AddDelphiFunction('Function StrRight( const S : AnsiString; Count : Integer) : AnsiString');
 CL.AddDelphiFunction('Function CharEqualNoCase( const C1, C2 : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsAlpha( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsAlphaNum( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsBlank( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsControl( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsDelete( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsDigit( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsLower( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsNumberChar( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsPrintable( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsPunctuation( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsReturn( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsSpace( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsUpper( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsWhiteSpace( const C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharType( const C : AnsiChar) : Word');
 CL.AddDelphiFunction('Function CharHex( const C : AnsiChar) : Byte');
 CL.AddDelphiFunction('Function CharLower( const C : AnsiChar) : AnsiChar');
 CL.AddDelphiFunction('Function CharUpper( const C : AnsiChar) : AnsiChar');
 CL.AddDelphiFunction('Function CharToggleCase( const C : AnsiChar) : AnsiChar');
 CL.AddDelphiFunction('Function CharPos( const S : AnsiString; const C : AnsiChar; const Index : Integer) : Integer');
 CL.AddDelphiFunction('Function CharLastPos( const S : AnsiString; const C : AnsiChar; const Index : Integer) : Integer');
 CL.AddDelphiFunction('Function CharIPos( const S : AnsiString; C : AnsiChar; const Index : Integer) : Integer');
 CL.AddDelphiFunction('Function CharReplace( var S : AnsiString; const Search, Replace : AnsiChar) : Integer');
 // CL.AddTypeS('PCharVector', '^PAnsiChar // will not work');
 //CL.AddDelphiFunction('Function StringsToPCharVector( var Dest : PCharVector; const Source : TStrings) : PCharVector');
 //CL.AddDelphiFunction('Function PCharVectorCount( Source : PCharVector) : Integer');
 //CL.AddDelphiFunction('Procedure PCharVectorToStrings( const Dest : TStrings; Source : PCharVector)');
 //CL.AddDelphiFunction('Procedure FreePCharVector( var Dest : PCharVector)');
  //CL.AddTypeS('PMultiSz', 'PAnsiChar');
  //CL.AddTypeS('PWideMultiSz', 'PWideChar');
 {CL.AddDelphiFunction('Function StringsToMultiSz( var Dest : PMultiSz; const Source : TStrings) : PMultiSz');
 CL.AddDelphiFunction('Procedure MultiSzToStrings( const Dest : TStrings; const Source : PMultiSz)');
 CL.AddDelphiFunction('Function MultiSzLength( const Source : PMultiSz) : Integer');
 CL.AddDelphiFunction('Procedure AllocateMultiSz( var Dest : PMultiSz; Len : Integer)');
 CL.AddDelphiFunction('Procedure FreeMultiSz( var Dest : PMultiSz)');
 CL.AddDelphiFunction('Function MultiSzDup( const Source : PMultiSz) : PMultiSz');
 CL.AddDelphiFunction('Function WideStringsToWideMultiSz( var Dest : PWideMultiSz; const Source : TWideStrings) : PWideMultiSz');
 CL.AddDelphiFunction('Procedure WideMultiSzToWideStrings( const Dest : TWideStrings; const Source : PWideMultiSz)');
 CL.AddDelphiFunction('Function WideMultiSzLength( const Source : PWideMultiSz) : Integer');
 CL.AddDelphiFunction('Procedure AllocateWideMultiSz( var Dest : PWideMultiSz; Len : Integer)');
 CL.AddDelphiFunction('Procedure FreeWideMultiSz( var Dest : PWideMultiSz)');
 CL.AddDelphiFunction('Function WideMultiSzDup( const Source : PWideMultiSz) : PWideMultiSz'); }
 CL.AddDelphiFunction('Procedure StrIToStrings( S, Sep : AnsiString; const List : TStrings; const AllowEmptyString : Boolean)');
 CL.AddDelphiFunction('Procedure StrToStrings( S, Sep : AnsiString; const List : TStrings; const AllowEmptyString : Boolean)');
 CL.AddDelphiFunction('Function StringsToStr( const List : TStrings; const Sep : AnsiString; const AllowEmptyString : Boolean) : AnsiString');
 CL.AddDelphiFunction('Procedure TrimStrings( const List : TStrings; DeleteIfEmpty : Boolean)');
 CL.AddDelphiFunction('Procedure TrimStringsRight( const List : TStrings; DeleteIfEmpty : Boolean)');
 CL.AddDelphiFunction('Procedure TrimStringsLeft( const List : TStrings; DeleteIfEmpty : Boolean)');
 CL.AddDelphiFunction('Function AddStringToStrings( const S : AnsiString; Strings : TStrings; const Unique : Boolean) : Boolean');
 CL.AddDelphiFunction('Function BooleanToStr( B : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function FileToString( const FileName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function LoadFromFile( const FileName : AnsiString) : AnsiString');

 CL.AddDelphiFunction('Procedure StringToFile( const FileName, Contents : AnsiString; Append : Boolean)');
 CL.AddDelphiFunction('Procedure SaveFile(const Contents, FileName: AnsiString; Append : Boolean)');
 CL.AddDelphiFunction('Procedure SaveToFile(const Contents, FileName: AnsiString; Append : Boolean)');

 CL.AddDelphiFunction('Function StrToken( var S : AnsiString; Separator : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Procedure StrTokens( const S : AnsiString; const List : TStrings)');
 CL.AddDelphiFunction('Procedure StrTokenToStrings( S : AnsiString; Separator : AnsiChar; const List : TStrings)');
 //CL.AddDelphiFunction('Function StrWord( var S : PAnsiChar; out Word : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function StrToFloatSafe( const S : AnsiString) : Float');
 CL.AddDelphiFunction('Function StrToIntSafe( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Procedure StrNormIndex( const StrLen : Integer; var Index : Integer; var Count : Integer);');
 CL.AddDelphiFunction('Function ArrayOf( List : TStrings) : TDynStringArray;');
  CL.AddTypeS('EJclStringError', 'EJclError');
 CL.AddDelphiFunction('function IsClass(Address: TObject): Boolean;');
 CL.AddDelphiFunction('function IsObject(Address: TObject): Boolean;');
 CL.AddDelphiFunction('function IntToStrZeroPad(Value, Count: Integer): AnsiString;');
 CL.AddDelphiFunction('function JclGUIDToString(const GUID: TGUID): string;');
 CL.AddDelphiFunction('function JclStringToGUID(const S: string): TGUID;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ArrayOf_P( List : TStrings) : TDynStringArray;
Begin //Result := JclAnsiStrings.ArrayOf(List);
END;

(*----------------------------------------------------------------------------*)
Procedure StrNormIndex_P( const StrLen : Integer; var Index : Integer; var Count : Integer);
Begin JclAnsiStrings.StrNormIndex(StrLen, Index, Count); END;

(*----------------------------------------------------------------------------*)
Function StrFillChar1_P( const C : Char; Count : Integer) : AnsiString;
Begin Result := JclAnsiStrings.StrFillChar(C, Count); END;

(*----------------------------------------------------------------------------*)
Function StrFillChar_P( const C : AnsiChar; Count : Integer) : AnsiString;
Begin Result := JclAnsiStrings.StrFillChar(C, Count); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclAnsiStrings_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StrIsAlpha, 'StrIsAlpha', cdRegister);
 S.RegisterDelphiFunction(@StrIsAlphaNum, 'StrIsAlphaNum', cdRegister);
 S.RegisterDelphiFunction(@StrIsAlphaNumUnderscore, 'StrIsAlphaNumUnderscore', cdRegister);
 S.RegisterDelphiFunction(@StrContainsChars, 'StrContainsChars', cdRegister);
 S.RegisterDelphiFunction(@StrConsistsOfNumberChars, 'StrConsistsOfNumberChars', cdRegister);
 S.RegisterDelphiFunction(@StrIsDigit, 'StrIsDigit', cdRegister);
 S.RegisterDelphiFunction(@StrIsSubset, 'StrIsSubset', cdRegister);
 S.RegisterDelphiFunction(@StrSame, 'StrSame', cdRegister);
 S.RegisterDelphiFunction(@StrCenter, 'StrCenter', cdRegister);
 S.RegisterDelphiFunction(@StrCharPosLower, 'StrCharPosLower', cdRegister);
 S.RegisterDelphiFunction(@StrCharPosUpper, 'StrCharPosUpper', cdRegister);
 S.RegisterDelphiFunction(@StrDoubleQuote, 'StrDoubleQuote', cdRegister);
 S.RegisterDelphiFunction(@StrEnsureNoPrefix, 'StrEnsureNoPrefix', cdRegister);
 S.RegisterDelphiFunction(@StrEnsureNoSuffix, 'StrEnsureNoSuffix', cdRegister);
 S.RegisterDelphiFunction(@StrEnsurePrefix, 'StrEnsurePrefix', cdRegister);
 S.RegisterDelphiFunction(@StrEnsureSuffix, 'StrEnsureSuffix', cdRegister);
 S.RegisterDelphiFunction(@StrEscapedToString, 'StrEscapedToString', cdRegister);
 S.RegisterDelphiFunction(@StrLower, 'JStrLower', cdRegister);
 S.RegisterDelphiFunction(@StrLowerInPlace, 'StrLowerInPlace', cdRegister);
 S.RegisterDelphiFunction(@StrLowerBuff, 'StrLowerBuff', cdRegister);
 S.RegisterDelphiFunction(@StrMove, 'JStrMove', cdRegister);
 S.RegisterDelphiFunction(@StrPadLeft, 'StrPadLeft', cdRegister);
 S.RegisterDelphiFunction(@StrPadRight, 'StrPadRight', cdRegister);
 S.RegisterDelphiFunction(@StrProper, 'StrProper', cdRegister);
 S.RegisterDelphiFunction(@StrProperBuff, 'StrProperBuff', cdRegister);
 S.RegisterDelphiFunction(@StrQuote, 'StrQuote', cdRegister);
 S.RegisterDelphiFunction(@StrRemoveChars, 'StrRemoveChars', cdRegister);
 S.RegisterDelphiFunction(@StrKeepChars, 'StrKeepChars', cdRegister);
 S.RegisterDelphiFunction(@StrReplace, 'JStrReplace', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceChar, 'StrReplaceChar', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceChars, 'StrReplaceChars', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceButChars, 'StrReplaceButChars', cdRegister);
 S.RegisterDelphiFunction(@StrRepeat, 'StrRepeat', cdRegister);
 S.RegisterDelphiFunction(@StrRepeatLength, 'StrRepeatLength', cdRegister);
 S.RegisterDelphiFunction(@StrReverse, 'StrReverse', cdRegister);
 S.RegisterDelphiFunction(@StrReverseInPlace, 'StrReverseInPlace', cdRegister);
 S.RegisterDelphiFunction(@StrSingleQuote, 'StrSingleQuote', cdRegister);
 S.RegisterDelphiFunction(@StrSmartCase, 'StrSmartCase', cdRegister);
 S.RegisterDelphiFunction(@StrStringToEscaped, 'StrStringToEscaped', cdRegister);
 S.RegisterDelphiFunction(@StrStripNonNumberChars, 'StrStripNonNumberChars', cdRegister);
 S.RegisterDelphiFunction(@StrToHex, 'StrToHex', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCharLeft, 'StrTrimCharLeft', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCharsLeft, 'StrTrimCharsLeft', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCharRight, 'StrTrimCharRight', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCharsRight, 'StrTrimCharsRight', cdRegister);
 S.RegisterDelphiFunction(@StrTrimQuotes, 'StrTrimQuotes', cdRegister);
 S.RegisterDelphiFunction(@StrUpper, 'JStrUpper', cdRegister);
 S.RegisterDelphiFunction(@StrUpperInPlace, 'StrUpperInPlace', cdRegister);
 S.RegisterDelphiFunction(@StrUpperBuff, 'StrUpperBuff', cdRegister);
 S.RegisterDelphiFunction(@StrOemToAnsi, 'StrOemToAnsi', cdRegister);
 S.RegisterDelphiFunction(@StrAnsiToOem, 'StrAnsiToOem', cdRegister);
 S.RegisterDelphiFunction(@StrAddRef, 'StrAddRef', cdRegister);
 S.RegisterDelphiFunction(@StrAllocSize, 'StrAllocSize', cdRegister);
 S.RegisterDelphiFunction(@StrDecRef, 'StrDecRef', cdRegister);
 //S.RegisterDelphiFunction(@StrLen, 'StrLen', cdRegister);
 S.RegisterDelphiFunction(@StrLength, 'StrLength', cdRegister);
 S.RegisterDelphiFunction(@StrRefCount, 'StrRefCount', cdRegister);
 S.RegisterDelphiFunction(@StrResetLength, 'StrResetLength', cdRegister);
 S.RegisterDelphiFunction(@StrCharCount, 'StrCharCount', cdRegister);
 S.RegisterDelphiFunction(@StrCharsCount, 'StrCharsCount', cdRegister);
 S.RegisterDelphiFunction(@StrStrCount, 'StrStrCount', cdRegister);
 S.RegisterDelphiFunction(@StrCompare, 'StrCompare', cdRegister);
 S.RegisterDelphiFunction(@StrCompareRange, 'StrCompareRange', cdRegister);
 //S.RegisterDelphiFunction(@StrFillChar, 'StrFillChar', cdRegister);
 S.RegisterDelphiFunction(@StrFillChar1_P, 'StrFillChar1', cdRegister);
 S.RegisterDelphiFunction(@StrFind, 'StrFind', cdRegister);
 //S.RegisterDelphiFunction(@StrHasPrefix, 'StrHasPrefix', cdRegister);
 S.RegisterDelphiFunction(@StrIndex, 'StrIndex', cdRegister);
 S.RegisterDelphiFunction(@StrILastPos, 'StrILastPos', cdRegister);
 S.RegisterDelphiFunction(@StrIPos, 'StrIPos', cdRegister);
 S.RegisterDelphiFunction(@StrIsOneOf, 'StrIsOneOf', cdRegister);
 S.RegisterDelphiFunction(@StrLastPos, 'StrLastPos', cdRegister);
 S.RegisterDelphiFunction(@StrMatch, 'StrMatch', cdRegister);
 S.RegisterDelphiFunction(@StrMatches, 'StrMatches', cdRegister);
 S.RegisterDelphiFunction(@StrNIPos, 'StrNIPos', cdRegister);
 S.RegisterDelphiFunction(@StrNPos, 'StrNPos', cdRegister);
 S.RegisterDelphiFunction(@StrPrefixIndex, 'StrPrefixIndex', cdRegister);
 S.RegisterDelphiFunction(@StrSearch, 'StrSearch', cdRegister);
 //S.RegisterDelphiFunction(@StrAfter, 'StrAfter', cdRegister);
 //S.RegisterDelphiFunction(@StrBefore, 'StrBefore', cdRegister);
 S.RegisterDelphiFunction(@StrBetween, 'StrBetween', cdRegister);
 S.RegisterDelphiFunction(@StrChopRight, 'StrChopRight', cdRegister);
 S.RegisterDelphiFunction(@StrLeft, 'StrLeft', cdRegister);
 S.RegisterDelphiFunction(@StrMid, 'StrMid', cdRegister);
 S.RegisterDelphiFunction(@StrRestOf, 'StrRestOf', cdRegister);
 S.RegisterDelphiFunction(@StrRight, 'StrRight', cdRegister);
 S.RegisterDelphiFunction(@CharEqualNoCase, 'CharEqualNoCase', cdRegister);
 S.RegisterDelphiFunction(@CharIsAlpha, 'CharIsAlpha', cdRegister);
 S.RegisterDelphiFunction(@CharIsAlphaNum, 'CharIsAlphaNum', cdRegister);
 S.RegisterDelphiFunction(@CharIsBlank, 'CharIsBlank', cdRegister);
 S.RegisterDelphiFunction(@CharIsControl, 'CharIsControl', cdRegister);
 S.RegisterDelphiFunction(@CharIsDelete, 'CharIsDelete', cdRegister);
 S.RegisterDelphiFunction(@CharIsDigit, 'CharIsDigit', cdRegister);
 S.RegisterDelphiFunction(@CharIsLower, 'CharIsLower', cdRegister);
 S.RegisterDelphiFunction(@CharIsNumberChar, 'CharIsNumberChar', cdRegister);
 S.RegisterDelphiFunction(@CharIsPrintable, 'CharIsPrintable', cdRegister);
 S.RegisterDelphiFunction(@CharIsPunctuation, 'CharIsPunctuation', cdRegister);
 S.RegisterDelphiFunction(@CharIsReturn, 'CharIsReturn', cdRegister);
 S.RegisterDelphiFunction(@CharIsSpace, 'CharIsSpace', cdRegister);
 S.RegisterDelphiFunction(@CharIsUpper, 'CharIsUpper', cdRegister);
 S.RegisterDelphiFunction(@CharIsWhiteSpace, 'CharIsWhiteSpace', cdRegister);
 S.RegisterDelphiFunction(@CharType, 'CharType', cdRegister);
 S.RegisterDelphiFunction(@CharHex, 'CharHex', cdRegister);
 S.RegisterDelphiFunction(@CharLower, 'CharLower', cdRegister);
 S.RegisterDelphiFunction(@CharUpper, 'CharUpper', cdRegister);
 S.RegisterDelphiFunction(@CharToggleCase, 'CharToggleCase', cdRegister);
 S.RegisterDelphiFunction(@CharPos, 'CharPos', cdRegister);
 S.RegisterDelphiFunction(@CharLastPos, 'CharLastPos', cdRegister);
 S.RegisterDelphiFunction(@CharIPos, 'CharIPos', cdRegister);
 S.RegisterDelphiFunction(@CharReplace, 'CharReplace', cdRegister);
 {S.RegisterDelphiFunction(@StringsToPCharVector, 'StringsToPCharVector', cdRegister);
 S.RegisterDelphiFunction(@PCharVectorCount, 'PCharVectorCount', cdRegister);
 S.RegisterDelphiFunction(@PCharVectorToStrings, 'PCharVectorToStrings', cdRegister);
 S.RegisterDelphiFunction(@FreePCharVector, 'FreePCharVector', cdRegister);
 S.RegisterDelphiFunction(@StringsToMultiSz, 'StringsToMultiSz', cdRegister);
 S.RegisterDelphiFunction(@MultiSzToStrings, 'MultiSzToStrings', cdRegister);
 S.RegisterDelphiFunction(@MultiSzLength, 'MultiSzLength', cdRegister);
 S.RegisterDelphiFunction(@AllocateMultiSz, 'AllocateMultiSz', cdRegister);
 S.RegisterDelphiFunction(@FreeMultiSz, 'FreeMultiSz', cdRegister);
 S.RegisterDelphiFunction(@MultiSzDup, 'MultiSzDup', cdRegister);
 S.RegisterDelphiFunction(@WideStringsToWideMultiSz, 'WideStringsToWideMultiSz', cdRegister);
 S.RegisterDelphiFunction(@WideMultiSzToWideStrings, 'WideMultiSzToWideStrings', cdRegister);
 S.RegisterDelphiFunction(@WideMultiSzLength, 'WideMultiSzLength', cdRegister);
 S.RegisterDelphiFunction(@AllocateWideMultiSz, 'AllocateWideMultiSz', cdRegister);
 S.RegisterDelphiFunction(@FreeWideMultiSz, 'FreeWideMultiSz', cdRegister);
 S.RegisterDelphiFunction(@WideMultiSzDup, 'WideMultiSzDup', cdRegister); }
 S.RegisterDelphiFunction(@StrIToStrings, 'StrIToStrings', cdRegister);
 S.RegisterDelphiFunction(@StrToStrings, 'StrToStrings', cdRegister);
 S.RegisterDelphiFunction(@StringsToStr, 'StringsToStr', cdRegister);
 S.RegisterDelphiFunction(@TrimStrings, 'TrimStrings', cdRegister);
 S.RegisterDelphiFunction(@TrimStringsRight, 'TrimStringsRight', cdRegister);
 S.RegisterDelphiFunction(@TrimStringsLeft, 'TrimStringsLeft', cdRegister);
 S.RegisterDelphiFunction(@AddStringToStrings, 'AddStringToStrings', cdRegister);
 S.RegisterDelphiFunction(@BooleanToStr, 'BooleanToStr', cdRegister);
 S.RegisterDelphiFunction(@FileToString, 'FileToString', cdRegister);
 S.RegisterDelphiFunction(@SaveFile, 'Savefile', cdRegister);
 S.RegisterDelphiFunction(@SaveFile, 'SaveTofile', cdRegister);

 S.RegisterDelphiFunction(@StringToFile, 'StringToFile', cdRegister);
 S.RegisterDelphiFunction(@FileToString, 'LoadfromFile', cdRegister);

 S.RegisterDelphiFunction(@StrToken, 'StrToken', cdRegister);
 S.RegisterDelphiFunction(@StrTokens, 'StrTokens', cdRegister);
 S.RegisterDelphiFunction(@StrTokenToStrings, 'StrTokenToStrings', cdRegister);
 S.RegisterDelphiFunction(@StrWord, 'StrWord', cdRegister);
 S.RegisterDelphiFunction(@StrToFloatSafe, 'StrToFloatSafe', cdRegister);
 S.RegisterDelphiFunction(@StrToIntSafe, 'StrToIntSafe', cdRegister);
 S.RegisterDelphiFunction(@StrNormIndex, 'StrNormIndex', cdRegister);
 //S.RegisterDelphiFunction(@ArrayOf, 'ArrayOf', cdRegister);
 S.RegisterDelphiFunction(@IsClass, 'IsClass', cdRegister);
 S.RegisterDelphiFunction(@IsObject, 'IsObject', cdRegister);
 S.RegisterDelphiFunction(@IntToStrZeroPad, 'IntToStrZeroPad', cdRegister);
 S.RegisterDelphiFunction(@JclGUIDToString, 'JclGUIDToString', cdRegister);
 S.RegisterDelphiFunction(@JclStringToGUID, 'JclStringToGUID', cdRegister);


end;

 
 
{ TPSImport_JclAnsiStrings }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclAnsiStrings.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclAnsiStrings(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclAnsiStrings.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclAnsiStrings(ri);
  RIRegister_JclAnsiStrings_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
