unit uPSI_ALfcnString;
{
    a last big bit box
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
  TPSImport_ALfcnString = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALPerlRegExList(CL: TPSPascalCompiler);
procedure SIRegister_TALPerlRegEx(CL: TPSPascalCompiler);
procedure SIRegister_TALMask(CL: TPSPascalCompiler);
procedure SIRegister_TALStringStream(CL: TPSPascalCompiler);
procedure SIRegister_EALException(CL: TPSPascalCompiler);
procedure SIRegister_ALfcnString(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALfcnString_Routines(S: TPSExec);
procedure RIRegister_TALPerlRegExList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALPerlRegEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMask(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALStringStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_EALException(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALfcnString(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ALStringList
  ,ALfcnString
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALfcnString]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALPerlRegExList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TALPerlRegExList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TALPerlRegExList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Add( ARegEx : TALPerlRegEx) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Function IndexOf( ARegEx : TALPerlRegEx) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; ARegEx : TALPerlRegEx)');
    RegisterMethod('Function Match : Boolean');
    RegisterMethod('Function MatchAgain : Boolean');
    RegisterProperty('RegEx', 'TALPerlRegEx Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Subject', 'AnsiString', iptrw);
    RegisterProperty('Start', 'Integer', iptrw);
    RegisterProperty('Stop', 'Integer', iptrw);
    RegisterProperty('MatchedRegEx', 'TALPerlRegEx', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALPerlRegEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TALPerlRegEx') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TALPerlRegEx') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function EscapeRegExChars( const S : AnsiString) : AnsiString');
    RegisterMethod('Procedure Compile');
    RegisterMethod('Procedure Study');
    RegisterMethod('Function Match : Boolean');
    RegisterMethod('Function MatchAgain : Boolean');
    RegisterMethod('Function Replace : AnsiString');
    RegisterMethod('Function ReplaceAll : Boolean');
    RegisterMethod('Function ComputeReplacement : AnsiString');
    RegisterMethod('Procedure StoreGroups');
    RegisterMethod('Function NamedGroup( const Name : AnsiString) : Integer');
    RegisterMethod('Procedure Split( Strings : TALStrings; Limit : Integer)');
    RegisterMethod('Procedure SplitCapture( Strings : TALStrings; Limit : Integer);');
    RegisterMethod('Procedure SplitCapture1( Strings : TALStrings; Limit : Integer; Offset : Integer);');
    RegisterProperty('Compiled', 'Boolean', iptr);
    RegisterProperty('FoundMatch', 'Boolean', iptr);
    RegisterProperty('Studied', 'Boolean', iptr);
    RegisterProperty('MatchedText', 'AnsiString', iptr);
    RegisterProperty('MatchedLength', 'Integer', iptr);
    RegisterProperty('MatchedOffset', 'Integer', iptr);
    RegisterProperty('Start', 'Integer', iptrw);
    RegisterProperty('Stop', 'Integer', iptrw);
    RegisterProperty('State', 'TALPerlRegExState', iptrw);
    RegisterProperty('GroupCount', 'Integer', iptr);
    RegisterProperty('Groups', 'AnsiString Integer', iptr);
    RegisterProperty('GroupLengths', 'Integer Integer', iptr);
    RegisterProperty('GroupOffsets', 'Integer Integer', iptr);
    RegisterProperty('Subject', 'AnsiString', iptrw);
    RegisterProperty('SubjectLeft', 'AnsiString', iptr);
    RegisterProperty('SubjectRight', 'AnsiString', iptr);
    RegisterProperty('Options', 'TALPerlRegExOptions', iptrw);
    RegisterProperty('RegEx', 'AnsiString', iptrw);
    RegisterProperty('Replacement', 'AnsiString', iptrw);
    RegisterProperty('OnMatch', 'TNotifyEvent', iptrw);
    RegisterProperty('OnReplace', 'TALPerlRegExReplaceEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMask(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TALMask') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TALMask') do
  begin
    RegisterMethod('Constructor Create( const MaskValue : AnsiString)');
    RegisterMethod('Function Matches( const Filename : AnsiString) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALStringStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TALStringStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TALStringStream') do
  begin
    RegisterMethod('Constructor Create( const AString : AnsiString)');
    RegisterMethod('Function ReadString( Count : Longint) : AnsiString');
    RegisterMethod('Procedure WriteString( const AString : AnsiString)');
    RegisterProperty('DataString', 'AnsiString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EALException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EALException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EALException') do
  begin
    RegisterMethod('Constructor Create( const Msg : AnsiString)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALfcnString(CL: TPSPascalCompiler);
begin
  SIRegister_EALException(CL);
  SIRegister_TALStringStream(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALMaskException');
  SIRegister_TALMask(CL);
  CL.AddTypeS('TALPerlRegExOptions', 'set of ( preCaseLess, preMultiLine, preSi'
   +'ngleLine, preExtended, preAnchored, preUnGreedy, preNoAutoCapture )');
  CL.AddTypeS('TALPerlRegExState', 'set of (preNotBOL, preNotEOL, preNotEmpty)');
 CL.AddConstantN('cALPerlRegExMAXSUBEXPRESSIONS','LongInt').SetInt( 99);
  CL.AddTypeS('TALPerlRegExReplaceEvent', 'Procedure ( Sender : TObject; var Re'
   +'placeWith : AnsiString)');
  SIRegister_TALPerlRegEx(CL);
  SIRegister_TALPerlRegExList(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ERegularExpressionError');
 CL.AddDelphiFunction('Procedure ALGetLocaleFormatSettings( Locale : LCID; var AFormatSettings : TALFormatSettings)');
 CL.AddDelphiFunction('Function ALGUIDToString( const Guid : TGUID) : Ansistring');
 CL.AddDelphiFunction('Function ALMakeKeyStrByGUID : AnsiString');
 CL.AddDelphiFunction('Function ALMatchesMask( const Filename, Mask : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function ALIfThen( AValue : Boolean; const ATrue : AnsiString; AFalse : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function ALIfThen1( AValue : Boolean; const ATrue : Integer; const AFalse : Integer) : Integer;');
 CL.AddDelphiFunction('Function ALIfThen2( AValue : Boolean; const ATrue : Int64; const AFalse : Int64) : Int64;');
 CL.AddDelphiFunction('Function ALIfThen3( AValue : Boolean; const ATrue : UInt64; const AFalse : UInt64) : UInt64;');
 CL.AddDelphiFunction('Function ALIfThen4( AValue : Boolean; const ATrue : Single; const AFalse : Single) : Single;');
 CL.AddDelphiFunction('Function ALIfThen5( AValue : Boolean; const ATrue : Double; const AFalse : Double) : Double;');
 CL.AddDelphiFunction('Function ALIfThen6( AValue : Boolean; const ATrue : Extended; const AFalse : Extended) : Extended;');
 CL.AddDelphiFunction('Function ALFormat( const Format : AnsiString; const Args : array of const) : AnsiString;');
 CL.AddDelphiFunction('Function ALFormat1( const Format : AnsiString; const Args : array of const; const AFormatSettings : TALFormatSettings) : AnsiString;');
 CL.AddDelphiFunction('Function ALTryStrToBool( const S : Ansistring; out Value : Boolean) : Boolean');
 CL.AddDelphiFunction('Function AlStrToBool( Value : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function ALBoolToStr( B : Boolean) : Ansistring');
 CL.AddDelphiFunction('Function ALDateToStr( const DateTime : TDateTime; const AFormatSettings : TALFormatSettings) : AnsiString');
 CL.AddDelphiFunction('Function ALTimeToStr( const DateTime : TDateTime; const AFormatSettings : TALFormatSettings) : AnsiString');
 CL.AddDelphiFunction('Function ALDateTimeToStr( const DateTime : TDateTime; const AFormatSettings : TALFormatSettings) : AnsiString');
 CL.AddDelphiFunction('Function ALFormatDateTime( const Format : AnsiString; DateTime : TDateTime; const AFormatSettings : TALFormatSettings) : AnsiString');
 CL.AddDelphiFunction('Function ALTryStrToDate( const S : AnsiString; out Value : TDateTime; const AFormatSettings : TALFormatSettings) : Boolean');
 CL.AddDelphiFunction('Function ALStrToDate( const S : AnsiString; const AFormatSettings : TALFormatSettings) : TDateTime');
 CL.AddDelphiFunction('Function ALTryStrToTime( const S : AnsiString; out Value : TDateTime; const AFormatSettings : TALFormatSettings) : Boolean');
 CL.AddDelphiFunction('Function ALStrToTime( const S : AnsiString; const AFormatSettings : TALFormatSettings) : TDateTime');
 CL.AddDelphiFunction('Function ALTryStrToDateTime( const S : AnsiString; out Value : TDateTime; const AFormatSettings : TALFormatSettings) : Boolean');
 CL.AddDelphiFunction('Function ALStrToDateTime( const S : AnsiString; const AFormatSettings : TALFormatSettings) : TDateTime');
 CL.AddDelphiFunction('Function ALTryStrToInt( const S : AnsiString; out Value : Integer) : Boolean');
 CL.AddDelphiFunction('Function ALStrToInt( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ALStrToIntDef( const S : AnsiString; Default : Integer) : Integer');
 CL.AddDelphiFunction('Function ALTryStrToInt64( const S : AnsiString; out Value : Int64) : Boolean');
 CL.AddDelphiFunction('Function ALStrToInt64( const S : AnsiString) : Int64');
 CL.AddDelphiFunction('Function ALStrToInt64Def( const S : AnsiString; const Default : Int64) : Int64');
 CL.AddDelphiFunction('Function ALIntToStr( Value : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function ALIntToStr1( Value : Int64) : AnsiString;');
 CL.AddDelphiFunction('Function ALUIntToStr( Value : Cardinal) : AnsiString;');
 CL.AddDelphiFunction('Function ALUIntToStr1( Value : UInt64) : AnsiString;');
 CL.AddDelphiFunction('Function ALIntToHex( Value : Integer; Digits : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function ALIntToHex1( Value : Int64; Digits : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function ALIntToHex2( Value : UInt64; Digits : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function ALIsInt64( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function ALIsInteger( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function ALIsSmallInt( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function ALFloatToStr( Value : Extended; const AFormatSettings : TALFormatSettings) : AnsiString');
 CL.AddDelphiFunction('Function ALCurrToStr( Value : Currency; const AFormatSettings : TALFormatSettings) : AnsiString');
 CL.AddDelphiFunction('Function ALFormatFloat( const Format : AnsiString; Value : Extended; const AFormatSettings : TALFormatSettings) : AnsiString');
 CL.AddDelphiFunction('Function ALFormatCurr( const Format : AnsiString; Value : Currency; const AFormatSettings : TALFormatSettings) : AnsiString');
 CL.AddDelphiFunction('Function ALStrToFloat( const S : AnsiString; const AFormatSettings : TALFormatSettings) : Extended');
 CL.AddDelphiFunction('Function ALStrToFloatDef( const S : AnsiString; const Default : Extended; const AFormatSettings : TALFormatSettings) : Extended');
 CL.AddDelphiFunction('Function ALTryStrToFloat( const S : AnsiString; out Value : Extended; const AFormatSettings : TALFormatSettings) : Boolean;');
 CL.AddDelphiFunction('Function ALTryStrToFloat1( const S : AnsiString; out Value : Double; const AFormatSettings : TALFormatSettings) : Boolean;');
 CL.AddDelphiFunction('Function ALTryStrToFloat2( const S : AnsiString; out Value : Single; const AFormatSettings : TALFormatSettings) : Boolean;');
 CL.AddDelphiFunction('Function ALStrToCurr( const S : AnsiString; const AFormatSettings : TALFormatSettings) : Currency');
 CL.AddDelphiFunction('Function ALStrToCurrDef( const S : AnsiString; const Default : Currency; const AFormatSettings : TALFormatSettings) : Currency');
 CL.AddDelphiFunction('Function ALTryStrToCurr( const S : AnsiString; out Value : Currency; const AFormatSettings : TALFormatSettings) : Boolean');
 CL.AddDelphiFunction('Function ALPos( const SubStr, Str : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ALPosEx( const SubStr, S : AnsiString; Offset : Integer) : Integer');
 CL.AddDelphiFunction('Function ALPosExIgnoreCase( const SubStr, S : Ansistring; Offset : Integer) : Integer');
 CL.AddDelphiFunction('Function AlUpperCase( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AlLowerCase( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALCompareStr( const S1, S2 : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ALSameStr( const S1, S2 : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function ALCompareText( const S1, S2 : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ALSameText( const S1, S2 : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function ALTrim( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALTrimLeft( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALTrimRight( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALPadLeft( const S : AnsiString; const Width : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ALPadRight( const S : AnsiString; const Width : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ALQuotedStr( const S : AnsiString; const Quote : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function ALDequotedStr( const S : AnsiString; AQuote : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function ALExtractQuotedStr( var Src : PAnsiChar; Quote : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function ALExtractFilePath( const FileName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALExtractFileDir( const FileName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALExtractFileDrive( const FileName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALExtractFileName( const FileName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALExtractFileExt( const FileName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALLastDelimiter( const Delimiters, S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ALIsPathDelimiter( const S : AnsiString; Index : Integer) : Boolean');
 CL.AddDelphiFunction('Function ALIncludeTrailingPathDelimiter( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALExcludeTrailingPathDelimiter( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure ALMove( const Source : string; var Dest, Count : Integer)');
 CL.AddDelphiFunction('Procedure ALStrMove( const Source : PAnsiChar; var Dest : PAnsiChar; Count : NativeIntInteger)');
 CL.AddDelphiFunction('Function ALCopyStr( const aSourceString : AnsiString; aStart, aLength : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ALStringReplace( const S, OldPattern, NewPattern : AnsiString; Flags : TReplaceFlags) : AnsiString');
 //CL.AddDelphiFunction('Function ALFastTagReplace( const SourceString, TagStart, TagEnd : AnsiString; ReplaceProc : TALHandleTagFunct; StripParamQuotes : Boolean; ExtData : Pointer; const flags : TReplaceFlags; const TagReplaceProcResult : Boolean) : AnsiString;');
 //CL.AddDelphiFunction('Function ALFastTagReplace1( const SourceString, TagStart, TagEnd : AnsiString; ReplaceExtendedProc : TALHandleTagExtendedfunct; StripParamQuotes : Boolean; ExtData : Pointer; const flags : TReplaceFlags; const TagReplaceProcResult : Boolean) : AnsiString;');
 //CL.AddDelphiFunction('Function ALFastTagReplace2( const SourceString, TagStart, TagEnd : AnsiString; const ReplaceWith : AnsiString; const Flags : TReplaceFlags) : AnsiString;');
 CL.AddDelphiFunction('Function ALExtractTagParams( const SourceString, TagStart, TagEnd : AnsiString; StripParamQuotes : Boolean; TagParams : TALStrings; IgnoreCase : Boolean) : Boolean');
 CL.AddDelphiFunction('Procedure ALSplitTextAndTag( const SourceString, TagStart, TagEnd : AnsiString; SplitTextAndTagLst : TALStrings; IgnoreCase : Boolean)');
 CL.AddDelphiFunction('Function ALRandomStr( const aLength : Longint; const aCharset : array of ansiChar) : AnsiString;');
 CL.AddDelphiFunction('Function ALRandomStr1( const aLength : Longint) : AnsiString;');
 CL.AddDelphiFunction('Function ALRandomStrU( const aLength : Longint; const aCharset : array of Char) : String;');
 CL.AddDelphiFunction('Function ALRandomStrU1( const aLength : Longint) : String;');
 CL.AddDelphiFunction('Function ALNEVExtractName( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALNEVExtractValue( const s : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALGetStringFromFile( filename : AnsiString; const ShareMode : Word) : AnsiString');
 CL.AddDelphiFunction('Function ALGetStringFromFileWithoutUTF8BOM( filename : AnsiString; const ShareMode : Word) : AnsiString');
 CL.AddDelphiFunction('Procedure ALSaveStringtoFile( Str : AnsiString; filename : AnsiString)');
 CL.AddDelphiFunction('Function ALWideNormalize( const S : Widestring) : Widestring');
 CL.AddDelphiFunction('Function ALWideRemoveDiacritic( const S : Widestring) : Widestring');
 CL.AddDelphiFunction('Function ALWideExpandLigatures( const S : Widestring) : Widestring');
 CL.AddDelphiFunction('Function ALWideUpperCaseNoDiacritic( const S : Widestring) : Widestring');
 CL.AddDelphiFunction('Function ALWideLowerCaseNoDiacritic( const S : Widestring) : Widestring');
 CL.AddDelphiFunction('Function ALUTF8RemoveDiacritic( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8ExpandLigatures( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8UpperCaseNoDiacritic( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8LowerCaseNoDiacritic( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8Normalize( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8UpperCase( const s : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8LowerCase( const s : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AlUTF8Check( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function AlUTF8removeBOM( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AlUTF8DetectBOM( const P : PAnsiChar; const Size : Integer) : Boolean');
 CL.AddDelphiFunction('Function ALUTF8CharSize( Lead : AnsiChar) : Integer');
 CL.AddDelphiFunction('Function ALUTF8CharCount( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ALUTF8ByteTrunc( const s : AnsiString; const Count : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8CharTrunc( const s : AnsiString; const Count : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8UpperFirstChar( const s : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8TitleCase( const s : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8SentenceCase( const s : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALStringToWideString( const S : AnsiString; const aCodePage : Word) : WideString');
 CL.AddDelphiFunction('Function AlWideStringToString( const WS : WideString; const aCodePage : Word) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8Encode( const S : AnsiString; const aCodePage : Word) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8decode( const S : AnsiString; const aCodePage : Word) : AnsiString');
 CL.AddDelphiFunction('Function ALGetCodePageFromCharSetName( Acharset : AnsiString) : Word');
 CL.AddDelphiFunction('Function ALGetCodePageFromLCID( const aLCID : Integer) : Word');
 CL.AddDelphiFunction('Function ALUTF8ISO91995CyrillicToLatin( const aCyrillicText : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8BGNPCGN1947CyrillicToLatin( const aCyrillicText : AnsiString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ALRandomStrU1_P( const aLength : Longint) : String;
Begin Result := ALfcnString.ALRandomStrU(aLength); END;

(*----------------------------------------------------------------------------*)
Function ALRandomStrU_P( const aLength : Longint; const aCharset : array of Char) : String;
Begin Result := ALfcnString.ALRandomStrU(aLength, aCharset); END;

(*----------------------------------------------------------------------------*)
Function ALRandomStr1_P( const aLength : Longint) : AnsiString;
Begin Result := ALfcnString.ALRandomStr(aLength); END;

(*----------------------------------------------------------------------------*)
Function ALRandomStr_P( const aLength : Longint; const aCharset : array of ansiChar) : AnsiString;
Begin Result := ALfcnString.ALRandomStr(aLength, aCharset); END;

(*----------------------------------------------------------------------------*)
//Function ALFastTagReplace2_P( const SourceString, TagStart, TagEnd : AnsiString; const ReplaceWith : AnsiString; const Flags : TReplaceFlags) : AnsiString;
//Begin Result := ALfcnString.ALFastTagReplace(SourceString, TagStart, TagEnd, ReplaceWith, Flags); END;

(*----------------------------------------------------------------------------*)
//7Function ALFastTagReplace1_P( const SourceString, TagStart, TagEnd : AnsiString; ReplaceExtendedProc : TALHandleTagExtendedfunct; StripParamQuotes : Boolean; ExtData : Pointer; const flags : TReplaceFlags; const TagReplaceProcResult : Boolean) : AnsiString;
///Begin Result := ALfcnString.ALFastTagReplace(SourceString, TagStart, TagEnd, ReplaceExtendedProc, StripParamQuotes, ExtData, flags, TagReplaceProcResult); END;

(*----------------------------------------------------------------------------*)
//Function ALFastTagReplace_P( const SourceString, TagStart, TagEnd : AnsiString; ReplaceProc : TALHandleTagFunct; StripParamQuotes : Boolean; ExtData : Pointer; const flags : TReplaceFlags; const TagReplaceProcResult : Boolean) : AnsiString;
//Begin Result := ALfcnString.ALFastTagReplace(SourceString, TagStart, TagEnd, ReplaceProc, StripParamQuotes, ExtData, flags, TagReplaceProcResult); END;

(*----------------------------------------------------------------------------*)
Function ALTryStrToFloat2_P( const S : AnsiString; out Value : Single; const AFormatSettings : TALFormatSettings) : Boolean;
Begin Result := ALfcnString.ALTryStrToFloat(S, Value, AFormatSettings); END;

(*----------------------------------------------------------------------------*)
Function ALTryStrToFloat1_P( const S : AnsiString; out Value : Double; const AFormatSettings : TALFormatSettings) : Boolean;
Begin Result := ALfcnString.ALTryStrToFloat(S, Value, AFormatSettings); END;

(*----------------------------------------------------------------------------*)
Function ALTryStrToFloat_P( const S : AnsiString; out Value : Extended; const AFormatSettings : TALFormatSettings) : Boolean;
Begin Result := ALfcnString.ALTryStrToFloat(S, Value, AFormatSettings); END;

(*----------------------------------------------------------------------------*)
Function ALIntToHex2_P( Value : UInt64; Digits : Integer) : AnsiString;
Begin Result := ALfcnString.ALIntToHex(Value, Digits); END;

(*----------------------------------------------------------------------------*)
Function ALIntToHex1_P( Value : Int64; Digits : Integer) : AnsiString;
Begin Result := ALfcnString.ALIntToHex(Value, Digits); END;

(*----------------------------------------------------------------------------*)
Function ALIntToHex_P( Value : Integer; Digits : Integer) : AnsiString;
Begin Result := ALfcnString.ALIntToHex(Value, Digits); END;

(*----------------------------------------------------------------------------*)
Function ALUIntToStr1_P( Value : UInt64) : AnsiString;
Begin //Result := ALfcnString.ALUIntToStr(Value);
END;

(*----------------------------------------------------------------------------*)
Function ALUIntToStr_P( Value : Cardinal) : AnsiString;
Begin //Result := ALfcnString.ALUIntToStr(Value);
END;

(*----------------------------------------------------------------------------*)
Function ALIntToStr1_P( Value : Int64) : AnsiString;
Begin Result := ALfcnString.ALIntToStr(Value); END;

(*----------------------------------------------------------------------------*)
Function ALIntToStr_P( Value : Integer) : AnsiString;
Begin Result := ALfcnString.ALIntToStr(Value); END;

(*----------------------------------------------------------------------------*)
Function ALFormat1_P( const Format : AnsiString; const Args : array of const; const AFormatSettings : TALFormatSettings) : AnsiString;
Begin Result := ALfcnString.ALFormat(Format, Args, AFormatSettings); END;

(*----------------------------------------------------------------------------*)
Function ALFormat_P( const Format : AnsiString; const Args : array of const) : AnsiString;
Begin Result := ALfcnString.ALFormat(Format, Args); END;

(*----------------------------------------------------------------------------*)
Function ALIfThen6_P( AValue : Boolean; const ATrue : Extended; const AFalse : Extended) : Extended;
Begin Result := ALfcnString.ALIfThen(AValue, ATrue, AFalse); END;

(*----------------------------------------------------------------------------*)
Function ALIfThen5_P( AValue : Boolean; const ATrue : Double; const AFalse : Double) : Double;
Begin Result := ALfcnString.ALIfThen(AValue, ATrue, AFalse); END;

(*----------------------------------------------------------------------------*)
Function ALIfThen4_P( AValue : Boolean; const ATrue : Single; const AFalse : Single) : Single;
Begin Result := ALfcnString.ALIfThen(AValue, ATrue, AFalse); END;

(*----------------------------------------------------------------------------*)
Function ALIfThen3_P( AValue : Boolean; const ATrue : UInt64; const AFalse : UInt64) : UInt64;
Begin Result := ALfcnString.ALIfThen(AValue, ATrue, AFalse); END;

(*----------------------------------------------------------------------------*)
Function ALIfThen2_P( AValue : Boolean; const ATrue : Int64; const AFalse : Int64) : Int64;
Begin Result := ALfcnString.ALIfThen(AValue, ATrue, AFalse); END;

(*----------------------------------------------------------------------------*)
Function ALIfThen1_P( AValue : Boolean; const ATrue : Integer; const AFalse : Integer) : Integer;
Begin Result := ALfcnString.ALIfThen(AValue, ATrue, AFalse); END;

(*----------------------------------------------------------------------------*)
Function ALIfThen_P( AValue : Boolean; const ATrue : AnsiString; AFalse : AnsiString) : AnsiString;
Begin Result := ALfcnString.ALIfThen(AValue, ATrue, AFalse); END;
{
(*----------------------------------------------------------------------------*)
procedure TALPerlRegExListMatchedRegEx_R(Self: TALPerlRegExList; var T: TALPerlRegEx);
begin T := Self.MatchedRegEx; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExListStop_W(Self: TALPerlRegExList; const T: Integer);
begin Self.Stop := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExListStop_R(Self: TALPerlRegExList; var T: Integer);
begin T := Self.Stop; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExListStart_W(Self: TALPerlRegExList; const T: Integer);
begin Self.Start := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExListStart_R(Self: TALPerlRegExList; var T: Integer);
begin T := Self.Start; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExListSubject_W(Self: TALPerlRegExList; const T: AnsiString);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExListSubject_R(Self: TALPerlRegExList; var T: AnsiString);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExListCount_R(Self: TALPerlRegExList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExListRegEx_W(Self: TALPerlRegExList; const T: TALPerlRegEx; const t1: Integer);
begin Self.RegEx[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExListRegEx_R(Self: TALPerlRegExList; var T: TALPerlRegEx; const t1: Integer);
begin T := Self.RegEx[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExOnReplace_W(Self: TALPerlRegEx; const T: TALPerlRegExReplaceEvent);
begin Self.OnReplace := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExOnReplace_R(Self: TALPerlRegEx; var T: TALPerlRegExReplaceEvent);
begin T := Self.OnReplace; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExOnMatch_W(Self: TALPerlRegEx; const T: TNotifyEvent);
begin Self.OnMatch := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExOnMatch_R(Self: TALPerlRegEx; var T: TNotifyEvent);
begin T := Self.OnMatch; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExReplacement_W(Self: TALPerlRegEx; const T: AnsiString);
begin Self.Replacement := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExReplacement_R(Self: TALPerlRegEx; var T: AnsiString);
begin T := Self.Replacement; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExRegEx_W(Self: TALPerlRegEx; const T: AnsiString);
begin Self.RegEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExRegEx_R(Self: TALPerlRegEx; var T: AnsiString);
begin T := Self.RegEx; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExOptions_W(Self: TALPerlRegEx; const T: TALPerlRegExOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExOptions_R(Self: TALPerlRegEx; var T: TALPerlRegExOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExSubjectRight_R(Self: TALPerlRegEx; var T: AnsiString);
begin T := Self.SubjectRight; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExSubjectLeft_R(Self: TALPerlRegEx; var T: AnsiString);
begin T := Self.SubjectLeft; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExSubject_W(Self: TALPerlRegEx; const T: AnsiString);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExSubject_R(Self: TALPerlRegEx; var T: AnsiString);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExGroupOffsets_R(Self: TALPerlRegEx; var T: Integer; const t1: Integer);
begin T := Self.GroupOffsets[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExGroupLengths_R(Self: TALPerlRegEx; var T: Integer; const t1: Integer);
begin T := Self.GroupLengths[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExGroups_R(Self: TALPerlRegEx; var T: AnsiString; const t1: Integer);
begin T := Self.Groups[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExGroupCount_R(Self: TALPerlRegEx; var T: Integer);
begin T := Self.GroupCount; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExState_W(Self: TALPerlRegEx; const T: TALPerlRegExState);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExState_R(Self: TALPerlRegEx; var T: TALPerlRegExState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExStop_W(Self: TALPerlRegEx; const T: Integer);
begin Self.Stop := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExStop_R(Self: TALPerlRegEx; var T: Integer);
begin T := Self.Stop; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExStart_W(Self: TALPerlRegEx; const T: Integer);
begin Self.Start := T; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExStart_R(Self: TALPerlRegEx; var T: Integer);
begin T := Self.Start; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExMatchedOffset_R(Self: TALPerlRegEx; var T: Integer);
begin T := Self.MatchedOffset; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExMatchedLength_R(Self: TALPerlRegEx; var T: Integer);
begin T := Self.MatchedLength; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExMatchedText_R(Self: TALPerlRegEx; var T: AnsiString);
begin T := Self.MatchedText; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExStudied_R(Self: TALPerlRegEx; var T: Boolean);
begin T := Self.Studied; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExFoundMatch_R(Self: TALPerlRegEx; var T: Boolean);
begin T := Self.FoundMatch; end;

(*----------------------------------------------------------------------------*)
procedure TALPerlRegExCompiled_R(Self: TALPerlRegEx; var T: Boolean);
begin T := Self.Compiled; end;

(*----------------------------------------------------------------------------*)
Procedure TALPerlRegExSplitCapture1_P(Self: TALPerlRegEx;  Strings : TALStrings; Limit : Integer; Offset : Integer);
Begin Self.SplitCapture(Strings, Limit, Offset); END;   }


(*----------------------------------------------------------------------------*)
Procedure TALPerlRegExSplitCapture_P(Self: TALPerlRegEx;  Strings : TALStrings; Limit : Integer);
Begin Self.SplitCapture(Strings, Limit); END;


(*----------------------------------------------------------------------------*)
procedure TALStringStreamDataString_R(Self: TALStringStream; var T: AnsiString);
begin T := Self.DataString; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALfcnString_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ALGetLocaleFormatSettings, 'ALGetLocaleFormatSettings', cdRegister);
 S.RegisterDelphiFunction(@ALGUIDToString, 'ALGUIDToString', cdRegister);
 S.RegisterDelphiFunction(@ALMakeKeyStrByGUID, 'ALMakeKeyStrByGUID', cdRegister);
 S.RegisterDelphiFunction(@ALMatchesMask, 'ALMatchesMask', cdRegister);
 S.RegisterDelphiFunction(@ALIfThen, 'ALIfThen', cdRegister);
 S.RegisterDelphiFunction(@ALIfThen1_P, 'ALIfThen1', cdRegister);
 S.RegisterDelphiFunction(@ALIfThen2_P, 'ALIfThen2', cdRegister);
 S.RegisterDelphiFunction(@ALIfThen3_P, 'ALIfThen3', cdRegister);
 S.RegisterDelphiFunction(@ALIfThen4_P, 'ALIfThen4', cdRegister);
 S.RegisterDelphiFunction(@ALIfThen5_P, 'ALIfThen5', cdRegister);
 S.RegisterDelphiFunction(@ALIfThen6_P, 'ALIfThen6', cdRegister);
 S.RegisterDelphiFunction(@ALFormat, 'ALFormat', cdRegister);
 S.RegisterDelphiFunction(@ALFormat1_P, 'ALFormat1', cdRegister);
 S.RegisterDelphiFunction(@ALTryStrToBool, 'ALTryStrToBool', cdRegister);
 S.RegisterDelphiFunction(@AlStrToBool, 'AlStrToBool', cdRegister);
 S.RegisterDelphiFunction(@ALBoolToStr, 'ALBoolToStr', cdRegister);
 S.RegisterDelphiFunction(@ALDateToStr, 'ALDateToStr', cdRegister);
 S.RegisterDelphiFunction(@ALTimeToStr, 'ALTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@ALDateTimeToStr, 'ALDateTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@ALFormatDateTime, 'ALFormatDateTime', cdRegister);
 S.RegisterDelphiFunction(@ALTryStrToDate, 'ALTryStrToDate', cdRegister);
 S.RegisterDelphiFunction(@ALStrToDate, 'ALStrToDate', cdRegister);
 S.RegisterDelphiFunction(@ALTryStrToTime, 'ALTryStrToTime', cdRegister);
 S.RegisterDelphiFunction(@ALStrToTime, 'ALStrToTime', cdRegister);
 S.RegisterDelphiFunction(@ALTryStrToDateTime, 'ALTryStrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@ALStrToDateTime, 'ALStrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@ALTryStrToInt, 'ALTryStrToInt', cdRegister);
 S.RegisterDelphiFunction(@ALStrToInt, 'ALStrToInt', cdRegister);
 S.RegisterDelphiFunction(@ALStrToIntDef, 'ALStrToIntDef', cdRegister);
 S.RegisterDelphiFunction(@ALTryStrToInt64, 'ALTryStrToInt64', cdRegister);
 S.RegisterDelphiFunction(@ALStrToInt64, 'ALStrToInt64', cdRegister);
 S.RegisterDelphiFunction(@ALStrToInt64Def, 'ALStrToInt64Def', cdRegister);
 S.RegisterDelphiFunction(@ALIntToStr, 'ALIntToStr', cdRegister);
 S.RegisterDelphiFunction(@ALIntToStr1, 'ALIntToStr1', cdRegister);
 S.RegisterDelphiFunction(@ALUIntToStr, 'ALUIntToStr', cdRegister);
 S.RegisterDelphiFunction(@ALUIntToStr1, 'ALUIntToStr1', cdRegister);
 S.RegisterDelphiFunction(@ALIntToHex, 'ALIntToHex', cdRegister);
 S.RegisterDelphiFunction(@ALIntToHex1, 'ALIntToHex1', cdRegister);
 S.RegisterDelphiFunction(@ALIntToHex2, 'ALIntToHex2', cdRegister);
 S.RegisterDelphiFunction(@ALIsInt64, 'ALIsInt64', cdRegister);
 S.RegisterDelphiFunction(@ALIsInteger, 'ALIsInteger', cdRegister);
 S.RegisterDelphiFunction(@ALIsSmallInt, 'ALIsSmallInt', cdRegister);
 S.RegisterDelphiFunction(@ALFloatToStr, 'ALFloatToStr', cdRegister);
 S.RegisterDelphiFunction(@ALCurrToStr, 'ALCurrToStr', cdRegister);
 S.RegisterDelphiFunction(@ALFormatFloat, 'ALFormatFloat', cdRegister);
 S.RegisterDelphiFunction(@ALFormatCurr, 'ALFormatCurr', cdRegister);
 S.RegisterDelphiFunction(@ALStrToFloat, 'ALStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@ALStrToFloatDef, 'ALStrToFloatDef', cdRegister);
 S.RegisterDelphiFunction(@ALTryStrToFloat, 'ALTryStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@ALTryStrToFloat1, 'ALTryStrToFloat1', cdRegister);
 S.RegisterDelphiFunction(@ALTryStrToFloat2, 'ALTryStrToFloat2', cdRegister);
 S.RegisterDelphiFunction(@ALStrToCurr, 'ALStrToCurr', cdRegister);
 S.RegisterDelphiFunction(@ALStrToCurrDef, 'ALStrToCurrDef', cdRegister);
 S.RegisterDelphiFunction(@ALTryStrToCurr, 'ALTryStrToCurr', cdRegister);
 S.RegisterDelphiFunction(@ALPos, 'ALPos', cdRegister);
 S.RegisterDelphiFunction(@ALPosEx, 'ALPosEx', cdRegister);
 S.RegisterDelphiFunction(@ALPosExIgnoreCase, 'ALPosExIgnoreCase', cdRegister);
 S.RegisterDelphiFunction(@AlUpperCase, 'AlUpperCase', cdRegister);
 S.RegisterDelphiFunction(@AlLowerCase, 'AlLowerCase', cdRegister);
 S.RegisterDelphiFunction(@ALCompareStr, 'ALCompareStr', cdRegister);
 S.RegisterDelphiFunction(@ALSameStr, 'ALSameStr', cdRegister);
 S.RegisterDelphiFunction(@ALCompareText, 'ALCompareText', cdRegister);
 S.RegisterDelphiFunction(@ALSameText, 'ALSameText', cdRegister);
 S.RegisterDelphiFunction(@ALTrim, 'ALTrim', cdRegister);
 S.RegisterDelphiFunction(@ALTrimLeft, 'ALTrimLeft', cdRegister);
 S.RegisterDelphiFunction(@ALTrimRight, 'ALTrimRight', cdRegister);
 S.RegisterDelphiFunction(@ALPadLeft, 'ALPadLeft', cdRegister);
 S.RegisterDelphiFunction(@ALPadRight, 'ALPadRight', cdRegister);
 S.RegisterDelphiFunction(@ALQuotedStr, 'ALQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@ALDequotedStr, 'ALDequotedStr', cdRegister);
 S.RegisterDelphiFunction(@ALExtractQuotedStr, 'ALExtractQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@ALExtractFilePath, 'ALExtractFilePath', cdRegister);
 S.RegisterDelphiFunction(@ALExtractFileDir, 'ALExtractFileDir', cdRegister);
 S.RegisterDelphiFunction(@ALExtractFileDrive, 'ALExtractFileDrive', cdRegister);
 S.RegisterDelphiFunction(@ALExtractFileName, 'ALExtractFileName', cdRegister);
 S.RegisterDelphiFunction(@ALExtractFileExt, 'ALExtractFileExt', cdRegister);
 S.RegisterDelphiFunction(@ALLastDelimiter, 'ALLastDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ALIsPathDelimiter, 'ALIsPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ALIncludeTrailingPathDelimiter, 'ALIncludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ALExcludeTrailingPathDelimiter, 'ALExcludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ALMove, 'ALMove', cdRegister);
 S.RegisterDelphiFunction(@ALStrMove, 'ALStrMove', cdRegister);
 S.RegisterDelphiFunction(@ALCopyStr, 'ALCopyStr', cdRegister);
 S.RegisterDelphiFunction(@ALStringReplace, 'ALStringReplace', cdRegister);
 //S.RegisterDelphiFunction(@ALFastTagReplace, 'ALFastTagReplace', cdRegister);
 //S.RegisterDelphiFunction(@ALFastTagReplace1, 'ALFastTagReplace1', cdRegister);
 //S.RegisterDelphiFunction(@ALFastTagReplace2, 'ALFastTagReplace2', cdRegister);
 S.RegisterDelphiFunction(@ALExtractTagParams, 'ALExtractTagParams', cdRegister);
 S.RegisterDelphiFunction(@ALSplitTextAndTag, 'ALSplitTextAndTag', cdRegister);
 S.RegisterDelphiFunction(@ALRandomStr, 'ALRandomStr', cdRegister);
 S.RegisterDelphiFunction(@ALRandomStr1, 'ALRandomStr1', cdRegister);
 S.RegisterDelphiFunction(@ALRandomStrU, 'ALRandomStrU', cdRegister);
 S.RegisterDelphiFunction(@ALRandomStrU1, 'ALRandomStrU1', cdRegister);
 S.RegisterDelphiFunction(@ALNEVExtractName, 'ALNEVExtractName', cdRegister);
 S.RegisterDelphiFunction(@ALNEVExtractValue, 'ALNEVExtractValue', cdRegister);
 S.RegisterDelphiFunction(@ALGetStringFromFile, 'ALGetStringFromFile', cdRegister);
 S.RegisterDelphiFunction(@ALGetStringFromFileWithoutUTF8BOM, 'ALGetStringFromFileWithoutUTF8BOM', cdRegister);
 S.RegisterDelphiFunction(@ALSaveStringtoFile, 'ALSaveStringtoFile', cdRegister);
 S.RegisterDelphiFunction(@ALWideNormalize, 'ALWideNormalize', cdRegister);
 S.RegisterDelphiFunction(@ALWideRemoveDiacritic, 'ALWideRemoveDiacritic', cdRegister);
 S.RegisterDelphiFunction(@ALWideExpandLigatures, 'ALWideExpandLigatures', cdRegister);
 S.RegisterDelphiFunction(@ALWideUpperCaseNoDiacritic, 'ALWideUpperCaseNoDiacritic', cdRegister);
 S.RegisterDelphiFunction(@ALWideLowerCaseNoDiacritic, 'ALWideLowerCaseNoDiacritic', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8RemoveDiacritic, 'ALUTF8RemoveDiacritic', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8ExpandLigatures, 'ALUTF8ExpandLigatures', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8UpperCaseNoDiacritic, 'ALUTF8UpperCaseNoDiacritic', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8LowerCaseNoDiacritic, 'ALUTF8LowerCaseNoDiacritic', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8Normalize, 'ALUTF8Normalize', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8UpperCase, 'ALUTF8UpperCase', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8LowerCase, 'ALUTF8LowerCase', cdRegister);
 S.RegisterDelphiFunction(@AlUTF8Check, 'AlUTF8Check', cdRegister);
 S.RegisterDelphiFunction(@AlUTF8removeBOM, 'AlUTF8removeBOM', cdRegister);
 S.RegisterDelphiFunction(@AlUTF8DetectBOM, 'AlUTF8DetectBOM', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8CharSize, 'ALUTF8CharSize', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8CharCount, 'ALUTF8CharCount', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8ByteTrunc, 'ALUTF8ByteTrunc', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8CharTrunc, 'ALUTF8CharTrunc', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8UpperFirstChar, 'ALUTF8UpperFirstChar', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8TitleCase, 'ALUTF8TitleCase', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8SentenceCase, 'ALUTF8SentenceCase', cdRegister);
 S.RegisterDelphiFunction(@ALStringToWideString, 'ALStringToWideString', cdRegister);
 S.RegisterDelphiFunction(@AlWideStringToString, 'AlWideStringToString', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8Encode, 'ALUTF8Encode', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8decode, 'ALUTF8decode', cdRegister);
 S.RegisterDelphiFunction(@ALGetCodePageFromCharSetName, 'ALGetCodePageFromCharSetName', cdRegister);
 S.RegisterDelphiFunction(@ALGetCodePageFromLCID, 'ALGetCodePageFromLCID', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8ISO91995CyrillicToLatin, 'ALUTF8ISO91995CyrillicToLatin', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8BGNPCGN1947CyrillicToLatin, 'ALUTF8BGNPCGN1947CyrillicToLatin', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALPerlRegExList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALPerlRegExList) do
  begin
    RegisterConstructor(@TALPerlRegExList.Create, 'Create');
    RegisterMethod(@TALPerlRegExList.Add, 'Add');
    RegisterMethod(@TALPerlRegExList.Clear, 'Clear');
    RegisterMethod(@TALPerlRegExList.Delete, 'Delete');
    RegisterMethod(@TALPerlRegExList.IndexOf, 'IndexOf');
    RegisterMethod(@TALPerlRegExList.Insert, 'Insert');
    RegisterMethod(@TALPerlRegExList.Match, 'Match');
    RegisterMethod(@TALPerlRegExList.MatchAgain, 'MatchAgain');
    RegisterPropertyHelper(@TALPerlRegExListRegEx_R,@TALPerlRegExListRegEx_W,'RegEx');
    RegisterPropertyHelper(@TALPerlRegExListCount_R,nil,'Count');
    RegisterPropertyHelper(@TALPerlRegExListSubject_R,@TALPerlRegExListSubject_W,'Subject');
    RegisterPropertyHelper(@TALPerlRegExListStart_R,@TALPerlRegExListStart_W,'Start');
    RegisterPropertyHelper(@TALPerlRegExListStop_R,@TALPerlRegExListStop_W,'Stop');
    RegisterPropertyHelper(@TALPerlRegExListMatchedRegEx_R,nil,'MatchedRegEx');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALPerlRegEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALPerlRegEx) do
  begin
    RegisterConstructor(@TALPerlRegEx.Create, 'Create');
    RegisterMethod(@TALPerlRegEx.EscapeRegExChars, 'EscapeRegExChars');
    RegisterMethod(@TALPerlRegEx.Compile, 'Compile');
    RegisterMethod(@TALPerlRegEx.Study, 'Study');
    RegisterMethod(@TALPerlRegEx.Match, 'Match');
    RegisterMethod(@TALPerlRegEx.MatchAgain, 'MatchAgain');
    RegisterMethod(@TALPerlRegEx.Replace, 'Replace');
    RegisterMethod(@TALPerlRegEx.ReplaceAll, 'ReplaceAll');
    RegisterMethod(@TALPerlRegEx.ComputeReplacement, 'ComputeReplacement');
    RegisterMethod(@TALPerlRegEx.StoreGroups, 'StoreGroups');
    RegisterMethod(@TALPerlRegEx.NamedGroup, 'NamedGroup');
    RegisterMethod(@TALPerlRegEx.Split, 'Split');
    RegisterMethod(@TALPerlRegExSplitCapture_P, 'SplitCapture');
    RegisterMethod(@TALPerlRegExSplitCapture1_P, 'SplitCapture1');
    RegisterPropertyHelper(@TALPerlRegExCompiled_R,nil,'Compiled');
    RegisterPropertyHelper(@TALPerlRegExFoundMatch_R,nil,'FoundMatch');
    RegisterPropertyHelper(@TALPerlRegExStudied_R,nil,'Studied');
    RegisterPropertyHelper(@TALPerlRegExMatchedText_R,nil,'MatchedText');
    RegisterPropertyHelper(@TALPerlRegExMatchedLength_R,nil,'MatchedLength');
    RegisterPropertyHelper(@TALPerlRegExMatchedOffset_R,nil,'MatchedOffset');
    RegisterPropertyHelper(@TALPerlRegExStart_R,@TALPerlRegExStart_W,'Start');
    RegisterPropertyHelper(@TALPerlRegExStop_R,@TALPerlRegExStop_W,'Stop');
    RegisterPropertyHelper(@TALPerlRegExState_R,@TALPerlRegExState_W,'State');
    RegisterPropertyHelper(@TALPerlRegExGroupCount_R,nil,'GroupCount');
    RegisterPropertyHelper(@TALPerlRegExGroups_R,nil,'Groups');
    RegisterPropertyHelper(@TALPerlRegExGroupLengths_R,nil,'GroupLengths');
    RegisterPropertyHelper(@TALPerlRegExGroupOffsets_R,nil,'GroupOffsets');
    RegisterPropertyHelper(@TALPerlRegExSubject_R,@TALPerlRegExSubject_W,'Subject');
    RegisterPropertyHelper(@TALPerlRegExSubjectLeft_R,nil,'SubjectLeft');
    RegisterPropertyHelper(@TALPerlRegExSubjectRight_R,nil,'SubjectRight');
    RegisterPropertyHelper(@TALPerlRegExOptions_R,@TALPerlRegExOptions_W,'Options');
    RegisterPropertyHelper(@TALPerlRegExRegEx_R,@TALPerlRegExRegEx_W,'RegEx');
    RegisterPropertyHelper(@TALPerlRegExReplacement_R,@TALPerlRegExReplacement_W,'Replacement');
    RegisterPropertyHelper(@TALPerlRegExOnMatch_R,@TALPerlRegExOnMatch_W,'OnMatch');
    RegisterPropertyHelper(@TALPerlRegExOnReplace_R,@TALPerlRegExOnReplace_W,'OnReplace');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMask(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMask) do
  begin
    RegisterConstructor(@TALMask.Create, 'Create');
    RegisterMethod(@TALMask.Matches, 'Matches');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALStringStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALStringStream) do
  begin
    RegisterConstructor(@TALStringStream.Create, 'Create');
    RegisterMethod(@TALStringStream.ReadString, 'ReadString');
    RegisterMethod(@TALStringStream.WriteString, 'WriteString');
    RegisterPropertyHelper(@TALStringStreamDataString_R,nil,'DataString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EALException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EALException) do
  begin
    RegisterConstructor(@EALException.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALfcnString(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EALException(CL);
  RIRegister_TALStringStream(CL);
  with CL.Add(EALMaskException) do
  RIRegister_TALMask(CL);
  RIRegister_TALPerlRegEx(CL);
  RIRegister_TALPerlRegExList(CL);
  with CL.Add(ERegularExpressionError) do
end;

 
 
{ TPSImport_ALfcnString }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALfcnString.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALfcnString(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALfcnString.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALfcnString(ri);
  RIRegister_ALfcnString_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
