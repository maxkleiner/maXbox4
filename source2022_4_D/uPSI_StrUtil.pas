unit uPSI_StrUtil;
{
with a prefix of _ like python

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
  TPSImport_StrUtil = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TFastStringStream(CL: TPSPascalCompiler);
procedure SIRegister_StrUtil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StrUtil_Routines(S: TPSExec);
procedure RIRegister_TFastStringStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_StrUtil(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StrUtil
  ;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StrUtil]);
end;

function StrToDateFS(const S: string; const AFormatSettings: TFormatSettings): TDateTime;

begin
  result:= strtodate( S, AFormatSettings);
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFastStringStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TFastStringStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TFastStringStream') do
  begin
    RegisterMethod('Constructor Create( const AString : string)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function Read( var Buffer : string; Count : Longint) : Longint');
    RegisterMethod('Function ReadString( Count : Longint) : string');
    RegisterMethod('Function Seek( Offset : Longint; Origin : Word) : Longint');
    RegisterMethod('Procedure PackData');
    RegisterMethod('Function Write( const Buffer : string; Count : Longint) : Longint');
    RegisterMethod('Procedure WriteString( const AString : string)');
    RegisterProperty('DataString', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StrUtil(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('_TPosition', 'record X : Longint; Y : Longint; end');
  CL.AddTypeS('TFastStringStream', 'TStringStream');
  SIRegister_TFastStringStream(CL);
  CL.AddTypeS('_TCharSet', 'set of AnsiChar');
 CL.AddDelphiFunction('Function _Position( AX, AY : Integer) : _TPosition');
 CL.AddDelphiFunction('Function _MakeStr( C : Char; N : Integer) : String');
 CL.AddDelphiFunction('Function _StrAsFloat( S : String) : double');
 CL.AddDelphiFunction('Function _ToClientDateFmt( D : String; caseFmt : byte) : String');
 CL.AddDelphiFunction('Function _ExtractWord( Num : integer; const Str : String; const WordDelims : TCharSet) : String');
 CL.AddDelphiFunction('Function _WordCount( const S : String; const WordDelims : TCharSet) : Integer');
 CL.AddDelphiFunction('Function _AnsiUpperCaseA( const s : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function _CompareStrWA( const S1 : string; const S2 : AnsiString) : Integer');
 CL.AddDelphiFunction('Function _AnsiCompareTextAA( const S1, S2 : AnsiString) : Integer');
 CL.AddDelphiFunction('Function _WildStringCompare( FirstString, SecondString : String) : boolean');
 CL.AddDelphiFunction('Function _MaskCompare( const aString, Mask : String) : boolean');
 CL.AddDelphiFunction('Function _SQLMaskCompare( const aString, Mask : String) : boolean;');
 CL.AddDelphiFunction('Function _SQLMaskCompareAW( const aString : AnsiString; const Mask : String) : boolean');
 CL.AddDelphiFunction('Function _SQLMaskCompareAA( const aString, Mask : AnsiString) : boolean');
 CL.AddDelphiFunction('Function _SQLMaskCompare1( const aString, Mask : Widestring) : boolean;');
 CL.AddDelphiFunction('Function _TrimCLRF( const s : String) : String');
 CL.AddDelphiFunction('Function _ReplaceStr( const S, Srch, Replace : String) : String');
 CL.AddDelphiFunction('Function _ReplaceStrInSubstr( const Source : String; const Srch, Replace : String; BeginPos, EndPos : integer) : String');
 CL.AddDelphiFunction('Function _ReplaceCIStr( const S, Srch, Replace : String; Ansi : boolean) : String');
 CL.AddDelphiFunction('Function _ReplaceStrCIInSubstr( const Source : String; const Srch, Replace : String; BeginPos, EndPos : integer) : String');
 CL.AddDelphiFunction('Function _FastUpperCase( const S : string) : string');
 CL.AddDelphiFunction('Procedure _DoUpperCase( var S : string; FirstPos : integer; LastPos : integer)');
 CL.AddDelphiFunction('Procedure _DoAnsiUpperCase( var S : Ansistring);');
 CL.AddDelphiFunction('Procedure _DoAnsiUpperCase1( var S : string);');
 CL.AddDelphiFunction('Procedure _DoWideUpperCase( var S : WideString)');
 CL.AddDelphiFunction('Procedure _DoUtf8Decode( const s : AnsiChar; StrLen : integer; var ws : WideString);');
 CL.AddDelphiFunction('Procedure _DoUtf8Decode1( const s : Ansistring; var ws : WideString);');
 CL.AddDelphiFunction('Procedure _DoUtf8Decode2( const s : variant; var ws : WideString);');
 CL.AddDelphiFunction('Function _EquelStrings( const s, s1 : string; CaseSensitive : boolean) : boolean');
 CL.AddDelphiFunction('Function _iifStr( Condition : boolean; const Str1, Str2 : string) : string');
 CL.AddDelphiFunction('Function _iifVariant( Condition : boolean; const Var1, Var2 : Variant) : Variant');
 CL.AddDelphiFunction('Function _StrOnMask( const StrIn, MaskIn, MaskOut : String) : String');
 CL.AddDelphiFunction('Function _StrIsInteger( const Str : string) : boolean');
 CL.AddDelphiFunction('Function _FormatIdentifierValue( Dialect : Integer; const Value : string) : string');
 CL.AddDelphiFunction('Function _FormatIdentifier( Dialect : Integer; const Value : String) : String');
 CL.AddDelphiFunction('Function _NormalizeName( Dialect : Integer; const Name : String) : String');
 CL.AddDelphiFunction('Function _EasyFormatIdentifier( Dialect : Integer; const Value : String; DoEasy : boolean) : String');
 CL.AddDelphiFunction('Function _EquelNames( CI : boolean; const Value, Value1 : String) : boolean');
 CL.AddDelphiFunction('Function _NeedQuote( const Name : String) : boolean');
 CL.AddDelphiFunction('Function _EasyNeedQuote( const Name : String) : boolean');
 CL.AddDelphiFunction('Function _PosCh( aCh : Char; const s : String) : integer');
 CL.AddDelphiFunction('Function _PosCh1( aCh : Char; const s : string; StartPos : integer) : integer;');
 CL.AddDelphiFunction('Function _PosCh2( aCh : AnsiChar; const s : Ansistring; StartPos : integer) : integer;');
 CL.AddDelphiFunction('Function _PosCI( const Substr, Str : string) : integer');
 CL.AddDelphiFunction('Function _PosExt( const Substr, Str : String; BegSub, EndSub : TCharSet) : integer');
 CL.AddDelphiFunction('Function _PosExtCI( const Substr, Str : String; BegSub, EndSub : TCharSet; AnsiUpper : boolean) : integer');
 CL.AddDelphiFunction('Function _PosInSubstr( const substr, Str : String; BeginPos, EndPos : integer) : integer');
 CL.AddDelphiFunction('Function _PosInRight( const substr, Str : String; BeginPos : integer) : integer');
 CL.AddDelphiFunction('Function _PosInSubstrCI( const SearchStr, Str : String; BeginPos, EndPos : integer) : integer');
 CL.AddDelphiFunction('Function _PosInSubstrExt( const SearchStr : String; Str : String; BeginPos, EndPos : integer; BegSub, EndSub : TCharSet) : integer');
 CL.AddDelphiFunction('Function _PosInSubstrCIExt( const SearchStr, Str : String; BeginPos, EndPos : integer; BegSub, EndSub : TCharSet) : integer');
 CL.AddDelphiFunction('Function _FirstPos( Search : array of Char; const InString : String) : integer;');
 CL.AddDelphiFunction('Function _FirstPos1( Search : array of AnsiChar; const InString : AnsiString) : integer;');
 CL.AddDelphiFunction('Function _LastChar( const Str : string) : Char');
 CL.AddDelphiFunction('Function _QuotedStr( const S : string) : string');
 CL.AddDelphiFunction('Function _CutQuote( const S : String) : String');
 CL.AddDelphiFunction('Function _StringInArray( const s : String; const a : array of String) : boolean');
 CL.AddDelphiFunction('Function _IsBlank( const Str : String) : boolean');
 CL.AddDelphiFunction('Function _IsBeginPartStr11( const PartStr, TargetStr : Ansistring) : boolean;');
 CL.AddDelphiFunction('Function _IsBeginPartStrWA( const PartStr : string; const TargetStr : Ansistring) : boolean');
 CL.AddDelphiFunction('Function _IsBeginPartStrVarA( const PartStr : Variant; const TargetStr : Ansistring) : boolean');
 CL.AddDelphiFunction('Function _IsBeginPartStr12( const PartStr, TargetStr : Widestring) : boolean;');
 CL.AddDelphiFunction('Procedure _DoLowerCase13( var Str : string);');
 CL.AddDelphiFunction('Procedure _DoLowerCase14( var Str : Ansistring);');
 CL.AddDelphiFunction('Procedure _DoTrim( var Str : string)');
 CL.AddDelphiFunction('Function _VarTrimRight( const str : Variant) : Variant');
 CL.AddDelphiFunction('Procedure _DoTrimRight15( var Str : string);');
 CL.AddDelphiFunction('Procedure _DoTrimRight16( var Str : Widestring);');
 CL.AddDelphiFunction('Procedure _DoTrimRight17( var Str : Ansistring);');
 CL.AddDelphiFunction('Procedure _DoCopy18( const Source : string; var Dest : string; Index, Count : Integer);');
 CL.AddDelphiFunction('Procedure _DoCopy19( const Source : Ansistring; var Dest : Ansistring; Index, Count : Integer);');
 CL.AddDelphiFunction('Function _FastTrim( const S : string) : string');
 CL.AddDelphiFunction('Function _FastCopy20( const S : String; Index : integer; Count : Integer) : String;');
 CL.AddDelphiFunction('Function _FastCopy21( const S : AnsiString; Index : integer; Count : Integer) : AnsiString;');
 CL.AddDelphiFunction('Procedure _SLDifference( ASL, BSL : TStringList; ResultSL : TStrings)');
 CL.AddDelphiFunction('Function _EmptyStrings( SL : TStrings) : boolean');
 CL.AddDelphiFunction('Procedure _DeleteEmptyStr( Src : TStrings)');
 CL.AddDelphiFunction('Function _NonAnsiSortCompareStrings( SL : TStringList; Index1, Index2 : Integer) : Integer');
 CL.AddDelphiFunction('Function _FindInDiapazon( SL : TStringList; const S : String; const StartIndex, EndIndex : integer; AnsiCompare : boolean; var Index : Integer) : boolean');
 CL.AddDelphiFunction('Function _NonAnsiIndexOf( SL : TStringList; const S : string) : integer');
 CL.AddDelphiFunction('Procedure _GetNameAndValue( const s : String; var Name, Value : AnsiString)');
 CL.AddDelphiFunction('Function _StrToDateFmt( const ADate, Fmt : String) : TDateTime');
 CL.AddDelphiFunction('Function StrToDateFS(const S: string; const AFormatSettings: TFormatSettings) : TDateTime');
 CL.AddDelphiFunction('Function _DateToSQLStr( const ADate : TDateTime) : String');
 CL.AddDelphiFunction('Function _ValueFromStr( const Str : String) : String');
 CL.AddDelphiFunction('Function _WideUpperCase( const S : WideString) : WideString');
 CL.AddDelphiFunction('Function _Q_StrLen( P : AnsiChar) : Cardinal');
 CL.AddDelphiFunction('Function _IsOldParamName( const ParamName : string) : boolean');
 CL.AddDelphiFunction('Function _IsNewParamName( const ParamName : string) : boolean');
 CL.AddDelphiFunction('Function _IsMasParamName( const ParamName : string) : boolean');
 CL.AddDelphiFunction('Function _GUIDAsString( const AGUID : TGUID) : Ansistring');
 CL.AddDelphiFunction('Procedure _GUIDAsStringToPChar( const AGUID : TGUID; Dest : AnsiChar)');
 CL.AddDelphiFunction('Function _StringAsGUID( const AStr : Ansistring) : TGUID');
 CL.AddDelphiFunction('Function _CompareStrAndGuid( GUID : TGUID; const Str : AnsiString) : integer');
 CL.AddDelphiFunction('Function _CompareStrAndGuidP( GUID : TGUID; const Str : AnsiString) : integer');
 CL.AddDelphiFunction('Function _IsEqualGUIDs( const guid1, guid2 : TGUID) : Boolean');
 CL.AddDelphiFunction('Function _IsNumericStr( const Str : string) : boolean');
 CL.AddDelphiFunction('Function _IsEmptyStr( const Str : string) : boolean');
 CL.AddDelphiFunction('Function _CompareStrTrimmed( const Str1, Str2 : PChar; Len : integer) : integer');
 CL.AddDelphiFunction('Function _CharInSet( C : AnsiChar; const CharSet : TSysCharSet) : Boolean');
 CL.AddDelphiFunction('function DecodeBase58(const Input: string): TByteArray;');
 CL.AddDelphiFunction('function StreamToByteArray(Stream: TStream): TBytes;');
 CL.AddDelphiFunction('function InterpolateRGB(AColor1, AColor2: Integer; ACoeff: Double): Integer;');
CL.AddDelphiFunction('procedure SetPropDefaults(AObject: TPersistent; APropNames: array of String);');
CL.AddDelphiFunction('procedure ValidateBitcoinAddress(const Address: string; DHashSHA256: TByteArray);');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function FastCopy21_P( const S : AnsiString; Index : integer; Count : Integer) : AnsiString;
Begin Result := StrUtil.FastCopy(S, Index, Count); END;

(*----------------------------------------------------------------------------*)
Function FastCopy20_P( const S : String; Index : integer; Count : Integer) : String;
Begin Result := StrUtil.FastCopy(S, Index, Count); END;

(*----------------------------------------------------------------------------*)
Procedure DoCopy19_P( const Source : Ansistring; var Dest : Ansistring; Index, Count : Integer);
Begin StrUtil.DoCopy(Source, Dest, Index, Count); END;

(*----------------------------------------------------------------------------*)
Procedure DoCopy18_P( const Source : string; var Dest : string; Index, Count : Integer);
Begin StrUtil.DoCopy(Source, Dest, Index, Count); END;

(*----------------------------------------------------------------------------*)
Procedure DoTrimRight17_P( var Str : Ansistring);
Begin StrUtil.DoTrimRight(Str); END;

(*----------------------------------------------------------------------------*)
Procedure DoTrimRight16_P( var Str : Widestring);
Begin StrUtil.DoTrimRight(Str); END;

(*----------------------------------------------------------------------------*)
Procedure DoTrimRight15_P( var Str : string);
Begin StrUtil.DoTrimRight(Str); END;

(*----------------------------------------------------------------------------*)
Procedure DoLowerCase14_P( var Str : Ansistring);
Begin StrUtil.DoLowerCase(Str); END;

(*----------------------------------------------------------------------------*)
Procedure DoLowerCase13_P( var Str : string);
Begin StrUtil.DoLowerCase(Str); END;

(*----------------------------------------------------------------------------*)
Function IsBeginPartStr12_P( const PartStr, TargetStr : Widestring) : boolean;
Begin Result := StrUtil.IsBeginPartStr(PartStr, TargetStr); END;

(*----------------------------------------------------------------------------*)
Function IsBeginPartStr11_P( const PartStr, TargetStr : Ansistring) : boolean;
Begin Result := StrUtil.IsBeginPartStr(PartStr, TargetStr); END;

(*----------------------------------------------------------------------------*)
Function FirstPos1_P( Search : array of AnsiChar; const InString : AnsiString) : integer;
Begin Result := StrUtil.FirstPos(Search, InString); END;

(*----------------------------------------------------------------------------*)
Function FirstPos_P( Search : array of Char; const InString : String) : integer;
Begin Result := StrUtil.FirstPos(Search, InString); END;

(*----------------------------------------------------------------------------*)
Function PosCh1_P( aCh : AnsiChar; const s : Ansistring; StartPos : integer) : integer;
Begin Result := StrUtil.PosCh1(aCh, s, StartPos); END;

(*----------------------------------------------------------------------------*)
Function PosCh_P( aCh : Char; const s : string; StartPos : integer) : integer;
Begin Result := StrUtil.PosCh1(aCh, s, StartPos); END;

(*----------------------------------------------------------------------------*)
Procedure DoUtf8Decode2_P( const s : variant; var ws : WideString);
Begin StrUtil.DoUtf8Decode(s, ws); END;

(*----------------------------------------------------------------------------*)
Procedure DoUtf8Decode1_P( const s : Ansistring; var ws : WideString);
Begin StrUtil.DoUtf8Decode(s, ws); END;

(*----------------------------------------------------------------------------*)
Procedure DoUtf8Decode_P( const s : PAnsiChar; StrLen : integer; var ws : WideString);
Begin StrUtil.DoUtf8Decode(s, StrLen, ws); END;

(*----------------------------------------------------------------------------*)
Procedure DoAnsiUpperCase1_P( var S : string);
Begin StrUtil.DoAnsiUpperCase(S); END;

(*----------------------------------------------------------------------------*)
Procedure DoAnsiUpperCase_P( var S : Ansistring);
Begin StrUtil.DoAnsiUpperCase(S); END;

(*----------------------------------------------------------------------------*)
Function SQLMaskCompare1_P( const aString, Mask : Widestring) : boolean;
Begin Result := StrUtil.SQLMaskCompare(aString, Mask); END;

(*----------------------------------------------------------------------------*)
Function SQLMaskCompare_P( const aString, Mask : String) : boolean;
Begin Result := StrUtil.SQLMaskCompare(aString, Mask); END;

(*----------------------------------------------------------------------------*)
procedure TFastStringStreamDataString_R(Self: TFastStringStream; var T: string);
begin T := Self.DataString; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StrUtil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Position, '_Position', cdRegister);
 S.RegisterDelphiFunction(@MakeStr, '_MakeStr', cdRegister);
 S.RegisterDelphiFunction(@StrAsFloat, '_StrAsFloat', cdRegister);
 S.RegisterDelphiFunction(@ToClientDateFmt, '_ToClientDateFmt', cdRegister);
 S.RegisterDelphiFunction(@ExtractWord, '_ExtractWord', cdRegister);
 S.RegisterDelphiFunction(@WordCount, '_WordCount', cdRegister);
 S.RegisterDelphiFunction(@AnsiUpperCaseA, '_AnsiUpperCaseA', cdRegister);
 S.RegisterDelphiFunction(@CompareStrWA, '_CompareStrWA', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareTextAA, '_AnsiCompareTextAA', cdRegister);
 S.RegisterDelphiFunction(@WildStringCompare, '_WildStringCompare', cdRegister);
 S.RegisterDelphiFunction(@MaskCompare, '_MaskCompare', cdRegister);
 S.RegisterDelphiFunction(@SQLMaskCompare, '_SQLMaskCompare', cdRegister);
 S.RegisterDelphiFunction(@SQLMaskCompareAW, '_SQLMaskCompareAW', cdRegister);
 S.RegisterDelphiFunction(@SQLMaskCompareAA, '_SQLMaskCompareAA', cdRegister);
 S.RegisterDelphiFunction(@SQLMaskCompare1_P, '_SQLMaskCompare1', cdRegister);
 S.RegisterDelphiFunction(@TrimCLRF, '_TrimCLRF', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStr, '_ReplaceStr', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStrInSubstr, '_ReplaceStrInSubstr', cdRegister);
 S.RegisterDelphiFunction(@ReplaceCIStr, '_ReplaceCIStr', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStrCIInSubstr, '_ReplaceStrCIInSubstr', cdRegister);
 S.RegisterDelphiFunction(@FastUpperCase, '_FastUpperCase', cdRegister);
 S.RegisterDelphiFunction(@DoUpperCase, '_DoUpperCase', cdRegister);
 S.RegisterDelphiFunction(@DoAnsiUpperCase, '_DoAnsiUpperCase', cdRegister);
 S.RegisterDelphiFunction(@DoAnsiUpperCase1_P, '_DoAnsiUpperCase1', cdRegister);
 S.RegisterDelphiFunction(@DoWideUpperCase, '_DoWideUpperCase', cdRegister);
 S.RegisterDelphiFunction(@DoUtf8Decode, '_DoUtf8Decode', cdRegister);
 S.RegisterDelphiFunction(@DoUtf8Decode1_P, '_DoUtf8Decode1', cdRegister);
 S.RegisterDelphiFunction(@DoUtf8Decode2_P, '_DoUtf8Decode2', cdRegister);
 S.RegisterDelphiFunction(@EquelStrings, '_EquelStrings', cdRegister);
 S.RegisterDelphiFunction(@iifStr, '_iifStr', cdRegister);
 S.RegisterDelphiFunction(@iifVariant, '_iifVariant', cdRegister);
 S.RegisterDelphiFunction(@StrOnMask, '_StrOnMask', cdRegister);
 S.RegisterDelphiFunction(@StrIsInteger, '_StrIsInteger', cdRegister);
 S.RegisterDelphiFunction(@FormatIdentifierValue, '_FormatIdentifierValue', cdRegister);
 S.RegisterDelphiFunction(@FormatIdentifier, '_FormatIdentifier', cdRegister);
 S.RegisterDelphiFunction(@NormalizeName, '_NormalizeName', cdRegister);
 S.RegisterDelphiFunction(@EasyFormatIdentifier, '_EasyFormatIdentifier', cdRegister);
 S.RegisterDelphiFunction(@EquelNames, '_EquelNames', cdRegister);
 S.RegisterDelphiFunction(@NeedQuote, '_NeedQuote', cdRegister);
 S.RegisterDelphiFunction(@EasyNeedQuote, '_EasyNeedQuote', cdRegister);
 S.RegisterDelphiFunction(@PosCh, '_PosCh', cdRegister);
 S.RegisterDelphiFunction(@PosCh, '_PosCh1', cdRegister);
 S.RegisterDelphiFunction(@PosCh1_P, '_PosCh2', cdRegister);
 S.RegisterDelphiFunction(@PosCI, '_PosCI', cdRegister);
 S.RegisterDelphiFunction(@PosExt, '_PosExt', cdRegister);
 S.RegisterDelphiFunction(@PosExtCI, '_PosExtCI', cdRegister);
 S.RegisterDelphiFunction(@PosInSubstr, '_PosInSubstr', cdRegister);
 S.RegisterDelphiFunction(@PosInRight, '_PosInRight', cdRegister);
 S.RegisterDelphiFunction(@PosInSubstrCI, '_PosInSubstrCI', cdRegister);
 S.RegisterDelphiFunction(@PosInSubstrExt, '_PosInSubstrExt', cdRegister);
 S.RegisterDelphiFunction(@PosInSubstrCIExt, '_PosInSubstrCIExt', cdRegister);
 S.RegisterDelphiFunction(@FirstPos, '_FirstPos', cdRegister);
 S.RegisterDelphiFunction(@FirstPos1_P, '_FirstPos1', cdRegister);
 S.RegisterDelphiFunction(@LastChar, '_LastChar', cdRegister);
 S.RegisterDelphiFunction(@QuotedStr, '_QuotedStr', cdRegister);
 S.RegisterDelphiFunction(@CutQuote, '_CutQuote', cdRegister);
 S.RegisterDelphiFunction(@StringInArray, '_StringInArray', cdRegister);
 S.RegisterDelphiFunction(@IsBlank, '_IsBlank', cdRegister);
 S.RegisterDelphiFunction(@IsBeginPartStr11_P, '_IsBeginPartStr11', cdRegister);
 //S.RegisterDelphiFunction(@IsBeginPartStrWA_P, 'IsBeginPartStrWA', cdRegister);
 S.RegisterDelphiFunction(@IsBeginPartStrVarA, '_IsBeginPartStrVarA', cdRegister);
 S.RegisterDelphiFunction(@IsBeginPartStr12_P, '_IsBeginPartStr12', cdRegister);
 S.RegisterDelphiFunction(@DoLowerCase13_P, '_DoLowerCase13', cdRegister);
 S.RegisterDelphiFunction(@DoLowerCase14_P, '_DoLowerCase14', cdRegister);
 S.RegisterDelphiFunction(@DoTrim, '_DoTrim', cdRegister);
 S.RegisterDelphiFunction(@VarTrimRight, '_VarTrimRight', cdRegister);
 S.RegisterDelphiFunction(@DoTrimRight15_P, '_DoTrimRight15', cdRegister);
 S.RegisterDelphiFunction(@DoTrimRight16_P, '_DoTrimRight16', cdRegister);
 S.RegisterDelphiFunction(@DoTrimRight17_P, '_DoTrimRight17', cdRegister);
 S.RegisterDelphiFunction(@DoCopy18_P, '_DoCopy18', cdRegister);
 S.RegisterDelphiFunction(@DoCopy19_P, '_DoCopy19', cdRegister);
 S.RegisterDelphiFunction(@FastTrim, '_FastTrim', cdRegister);
 S.RegisterDelphiFunction(@FastCopy20_P, '_FastCopy20', cdRegister);
 S.RegisterDelphiFunction(@FastCopy21_P, '_FastCopy21', cdRegister);
 S.RegisterDelphiFunction(@SLDifference, '_SLDifference', cdRegister);
 S.RegisterDelphiFunction(@EmptyStrings, '_EmptyStrings', cdRegister);
 S.RegisterDelphiFunction(@DeleteEmptyStr, '_DeleteEmptyStr', cdRegister);
 S.RegisterDelphiFunction(@NonAnsiSortCompareStrings, '_NonAnsiSortCompareStrings', cdRegister);
 S.RegisterDelphiFunction(@FindInDiapazon, '_FindInDiapazon', cdRegister);
 S.RegisterDelphiFunction(@NonAnsiIndexOf, '_NonAnsiIndexOf', cdRegister);
 S.RegisterDelphiFunction(@GetNameAndValue, '_GetNameAndValue', cdRegister);
 S.RegisterDelphiFunction(@StrToDateFmt, '_StrToDateFmt', cdRegister);
 S.RegisterDelphiFunction(@StrToDateFS, 'StrToDateFS', cdRegister);
 S.RegisterDelphiFunction(@DateToSQLStr, '_DateToSQLStr', cdRegister);
 S.RegisterDelphiFunction(@ValueFromStr, '_ValueFromStr', cdRegister);
 S.RegisterDelphiFunction(@WideUpperCase, '_WideUpperCase', cdRegister);
 S.RegisterDelphiFunction(@Q_StrLen, '_Q_StrLen', cdRegister);
 S.RegisterDelphiFunction(@IsOldParamName, '_IsOldParamName', cdRegister);
 S.RegisterDelphiFunction(@IsNewParamName, '_IsNewParamName', cdRegister);
 S.RegisterDelphiFunction(@IsMasParamName, '_IsMasParamName', cdRegister);
 S.RegisterDelphiFunction(@GUIDAsString, '_GUIDAsString', cdRegister);
 S.RegisterDelphiFunction(@GUIDAsStringToPChar, '_GUIDAsStringToPChar', cdRegister);
 S.RegisterDelphiFunction(@StringAsGUID, '_StringAsGUID', cdRegister);
 S.RegisterDelphiFunction(@CompareStrAndGuid, '_CompareStrAndGuid', cdRegister);
 S.RegisterDelphiFunction(@CompareStrAndGuidP, '_CompareStrAndGuidP', cdRegister);
 S.RegisterDelphiFunction(@IsEqualGUIDs, '_IsEqualGUIDs', cdRegister);
 S.RegisterDelphiFunction(@IsNumericStr, '_IsNumericStr', cdRegister);
 S.RegisterDelphiFunction(@IsEmptyStr, '_IsEmptyStr', cdRegister);
 S.RegisterDelphiFunction(@CompareStrTrimmed, '_CompareStrTrimmed', cdRegister);
 S.RegisterDelphiFunction(@CharInSet, '_CharInSet', cdRegister);
 S.RegisterDelphiFunction(@DecodeBase58, 'DecodeBase58', cdRegister);
 S.RegisterDelphiFunction(@StreamToByteArray, 'StreamToByteArray', cdRegister);
 S.RegisterDelphiFunction(@InterpolateRGB, 'InterpolateRGB', cdRegister);
 S.RegisterDelphiFunction(@SetPropDefaults, 'SetPropDefaults', cdRegister);
 S.RegisterDelphiFunction(@ValidateBitcoinAddress, 'ValidateBitcoinAddress', cdRegister);
  //function StreamToByteArray(Stream: TStream): TBytes;

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFastStringStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFastStringStream) do begin
    RegisterConstructor(@TFastStringStream.Create, 'Create');
    RegisterMethod(@TFastStringStream.Destroy, 'Free');
    RegisterMethod(@TFastStringStream.Read, 'Read');
    RegisterMethod(@TFastStringStream.ReadString, 'ReadString');
    RegisterMethod(@TFastStringStream.Seek, 'Seek');
    RegisterMethod(@TFastStringStream.PackData, 'PackData');
    RegisterMethod(@TFastStringStream.Write, 'Write');
    RegisterMethod(@TFastStringStream.WriteString, 'WriteString');
    RegisterPropertyHelper(@TFastStringStreamDataString_R,nil,'DataString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StrUtil(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFastStringStream(CL);
end;

 
 
{ TPSImport_StrUtil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StrUtil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StrUtil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StrUtil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StrUtil(ri);
  RIRegister_StrUtil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
