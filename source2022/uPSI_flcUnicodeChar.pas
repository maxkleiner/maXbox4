unit uPSI_flcUnicodeChar;
{
this preparation is a testframework for unicode surrogates gates

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
  TPSImport_flcUnicodeChar = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_flcUnicodeChar(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcUnicodeChar_Routines(S: TPSExec);

procedure Register;

implementation


uses
   flcStdTypes
  ,flcUnicodeChar
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcUnicodeChar]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_flcUnicodeChar(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('WideSingleQuote','String').SetString( WideChar ( '''' ));
 CL.AddConstantN('WideDoubleQuote','String').SetString( WideChar ( '"' ));
 CL.AddConstantN('WideNoBreakSpace','Char').SetString( WideChar ( #$00A0 ));
 CL.AddConstantN('WideLineSeparator','Char').SetString( WideChar ( #$2028 ));
 CL.AddConstantN('WideParagraphSeparator','Char').SetString( WideChar ( #$2029 ));
 CL.AddConstantN('WideBOM_MSB_First','Char').SetString( WideChar ( #$FFFE ));
 CL.AddConstantN('WideBOM_LSB_First','Char').SetString( WideChar ( #$FEFF ));
 CL.AddConstantN('WideObjectReplacement','Char').SetString( WideChar ( #$FFFC ));
 CL.AddConstantN('WideCharReplacement','Char').SetString( WideChar ( #$FFFD ));
 CL.AddConstantN('WideInvalid','Char').SetString( WideChar ( #$FFFF ));
 CL.AddConstantN('WideCopyrightSign','Char').SetString( WideChar ( #$00A9 ));
 CL.AddConstantN('WideRegisteredSign','Char').SetString( WideChar ( #$00AE ));
 CL.AddConstantN('WideHighSurrogateFirst','Char').SetString( WideChar ( #$D800 ));
 CL.AddConstantN('WideHighSurrogateLast','Char').SetString( WideChar ( #$DB7F ));
 CL.AddConstantN('WideLowSurrogateFirst','Char').SetString( WideChar ( #$DC00 ));
 CL.AddConstantN('WideLowSurrogateLast','Char').SetString( WideChar ( #$DFFF ));
 CL.AddConstantN('WidePrivateHighSurrogateFirst','Char').SetString( WideChar ( #$DB80 ));
 CL.AddConstantN('WidePrivateHighSurrogateLast','Char').SetString( WideChar ( #$DBFF ));
 CL.AddConstantN('flcWideNULL','Char').SetString( WideChar ( #0 ));
 CL.AddConstantN('flcWideBS','Char').SetString( WideChar ( #8 ));
 CL.AddConstantN('flcWideHT','Char').SetString( WideChar ( #9 ));
 CL.AddConstantN('flcWideLF','Char').SetString( WideChar ( #10 ));
 CL.AddConstantN('flcWideVT','Char').SetString( WideChar ( #11 ));
 CL.AddConstantN('flcWideFF','Char').SetString( WideChar ( #12 ));
 CL.AddConstantN('flcWideCR','Char').SetString( WideChar ( #13 ));
 CL.AddConstantN('flcWideEOF','Char').SetString( WideChar ( #26 ));
 CL.AddConstantN('flcWideSP','Char').SetString( WideChar ( #32 ));
 CL.AddConstantN('UCS4_STRING_TERMINATOR','LongWord').SetUInt( $9C);
 CL.AddConstantN('UCS4_LF','LongWord').SetUInt( $0A);
 CL.AddConstantN('UCS4_CR','LongWord').SetUInt( $0D);
 CL.AddDelphiFunction('Function UnicodeIsAsciiChar( const Ch : WideChar) : Boolean');
  CL.AddTypeS('TUnicodeSpaceWidth', '( uswNone, uswZero, uswAdjustableEmOneOver'
   +'Four, uswEmOneOverTwo, uswEmOneOverThree, uswEmOneOverFour, uswEmFourOverE'
   +'ighteen, uswEmOneOverFive, uswEmOneOverSix, uswEmOne, uswWidthDigit, uswWidthPeriod, uswWidthIdeographic )');
 CL.AddDelphiFunction('Function UnicodeSpaceWidth( const Ch : WideChar) : TUnicodeSpaceWidth');
 CL.AddDelphiFunction('Function UnicodeIsNoBreakSpace( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsSpaceFixedWidth( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsSpaceAdjustableWidth( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsSpace( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsLineBreak( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsWhiteSpace( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsControl( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsControlOrWhiteSpace( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsIgnorable( const Ch : UCS4Char) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsDash( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsHyphen( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsDashOrHyphen( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsFullStop0( const Ch : UCS4Char) : Boolean;');
 CL.AddDelphiFunction('Function UnicodeIsFullStop1( const Ch : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function UnicodeIsComma( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsExclamationMark( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsQuestionMark( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsLeftParenthesis( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsLeftBracket( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeGetRightParenthesis( const LeftParenthesis : WideChar) : WideChar');
 CL.AddDelphiFunction('Function UnicodeGetRightBracket( const LeftBracket : WideChar) : WideChar');
 CL.AddDelphiFunction('Function UnicodeIsSingularQuotationMark( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsOpeningQuotationMark( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsClosingQuotationMark( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeGetClosingQuotationMark( const OpeningQuote : WideChar) : WideChar');
 CL.AddDelphiFunction('Function UnicodeGetOpeningQuotationMark( const ClosingQuote : WideChar) : WideChar');
 CL.AddDelphiFunction('Function UnicodeIsPunctuation( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsDecimalDigit2( const Ch : UCS4Char) : Boolean;');
 CL.AddDelphiFunction('Function UnicodeIsDecimalDigit3( const Ch : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function UnicodeIsAsciiDecimalDigit( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeDecimalDigitValue4( const Ch : UCS4Char) : Integer;');
 CL.AddDelphiFunction('Function UnicodeDecimalDigitValue5( const Ch : WideChar) : Integer;');
 CL.AddDelphiFunction('Function UnicodeFractionCharacterValue( const Ch : WideChar; var A, B : Integer) : Boolean');
 CL.AddDelphiFunction('Function UnicodeRomanNumeralValue( const Ch : WideChar) : Integer');
 CL.AddDelphiFunction('Function UnicodeIsAsciiHexDigit( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsHexDigit6( const Ch : UCS4Char) : Boolean;');
 CL.AddDelphiFunction('Function UnicodeIsHexDigit7( const Ch : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function UnicodeHexDigitValue8( const Ch : UCS4Char) : Integer;');
 CL.AddDelphiFunction('Function UnicodeHexDigitValue9( const Ch : WideChar) : Integer;');
 CL.AddDelphiFunction('Function UnicodeIsUpperCase( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsLowerCase( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsTitleCase( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsLetter( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeIsAlphabetic( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeUpCase( const Ch : WideChar) : WideChar');
 CL.AddDelphiFunction('Function UnicodeLowCase( const Ch : WideChar) : WideChar');
 CL.AddDelphiFunction('Function UnicodeCharIsEqualNoCase( const A, B : WideChar) : Boolean');
 CL.AddDelphiFunction('Function UnicodeGetCombiningClass( const Ch : WideChar) : Byte');
 CL.AddDelphiFunction('Function UnicodeLocateFoldingUpperCase( const Ch : WideChar) : UnicodeString');
 CL.AddDelphiFunction('Function UnicodeLocateFoldingTitleCase( const Ch : WideChar) : UnicodeString');
 CL.AddDelphiFunction('Function UnicodeUpCaseFoldingU( const Ch : WideChar) : UnicodeString');
 CL.AddDelphiFunction('Function UnicodeLowCaseFoldingU( const Ch : WideChar) : UnicodeString');
 CL.AddDelphiFunction('Function UnicodeTitleCaseFoldingU( const Ch : WideChar) : UnicodeString');
 CL.AddDelphiFunction('Function UnicodeGetCharacterDecompositionU10( const Ch : WideChar) : UnicodeString;');
 CL.AddDelphiFunction('Function UnicodeGetCharacterDecompositionU11( const Ch : UCS4Char) : UnicodeString;');
 CL.AddDelphiFunction('Function UnicodeUpperCaseFoldingU( const S : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function UnicodeLowerCaseFoldingU( const S : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Procedure TestUnicodeChar');
  CL.AddDelphiFunction('function HexToBits(C: Char): Byte;');
  CL.AddDelphiFunction('function Utf8ToStr(const Source : string) : string;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function UnicodeGetCharacterDecompositionU11_P( const Ch : UCS4Char) : UnicodeString;
Begin Result := flcUnicodeChar.UnicodeGetCharacterDecompositionU(Ch); END;

(*----------------------------------------------------------------------------*)
Function UnicodeGetCharacterDecompositionU10_P( const Ch : WideChar) : UnicodeString;
Begin Result := flcUnicodeChar.UnicodeGetCharacterDecompositionU(Ch); END;

(*----------------------------------------------------------------------------*)
Function UnicodeHexDigitValue9_P( const Ch : WideChar) : Integer;
Begin Result := flcUnicodeChar.UnicodeHexDigitValue(Ch); END;

(*----------------------------------------------------------------------------*)
Function UnicodeHexDigitValue8_P( const Ch : UCS4Char) : Integer;
Begin Result := flcUnicodeChar.UnicodeHexDigitValue(Ch); END;

(*----------------------------------------------------------------------------*)
Function UnicodeIsHexDigit7_P( const Ch : WideChar) : Boolean;
Begin Result := flcUnicodeChar.UnicodeIsHexDigit(Ch); END;

(*----------------------------------------------------------------------------*)
Function UnicodeIsHexDigit6_P( const Ch : UCS4Char) : Boolean;
Begin Result := flcUnicodeChar.UnicodeIsHexDigit(Ch); END;

(*----------------------------------------------------------------------------*)
Function UnicodeDecimalDigitValue5_P( const Ch : WideChar) : Integer;
Begin Result := flcUnicodeChar.UnicodeDecimalDigitValue(Ch); END;

(*----------------------------------------------------------------------------*)
Function UnicodeDecimalDigitValue4_P( const Ch : UCS4Char) : Integer;
Begin Result := flcUnicodeChar.UnicodeDecimalDigitValue(Ch); END;

(*----------------------------------------------------------------------------*)
Function UnicodeIsDecimalDigit3_P( const Ch : WideChar) : Boolean;
Begin Result := flcUnicodeChar.UnicodeIsDecimalDigit(Ch); END;

(*----------------------------------------------------------------------------*)
Function UnicodeIsDecimalDigit2_P( const Ch : UCS4Char) : Boolean;
Begin Result := flcUnicodeChar.UnicodeIsDecimalDigit(Ch); END;

(*----------------------------------------------------------------------------*)
Function UnicodeIsFullStop1_P( const Ch : WideChar) : Boolean;
Begin Result := flcUnicodeChar.UnicodeIsFullStop(Ch); END;

(*----------------------------------------------------------------------------*)
Function UnicodeIsFullStop0_P( const Ch : UCS4Char) : Boolean;
Begin Result := flcUnicodeChar.UnicodeIsFullStop(Ch); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcUnicodeChar_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@UnicodeIsAsciiChar, 'UnicodeIsAsciiChar', cdRegister);
 S.RegisterDelphiFunction(@UnicodeSpaceWidth, 'UnicodeSpaceWidth', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsNoBreakSpace, 'UnicodeIsNoBreakSpace', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsSpaceFixedWidth, 'UnicodeIsSpaceFixedWidth', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsSpaceAdjustableWidth, 'UnicodeIsSpaceAdjustableWidth', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsSpace, 'UnicodeIsSpace', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsLineBreak, 'UnicodeIsLineBreak', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsWhiteSpace, 'UnicodeIsWhiteSpace', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsControl, 'UnicodeIsControl', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsControlOrWhiteSpace, 'UnicodeIsControlOrWhiteSpace', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsIgnorable, 'UnicodeIsIgnorable', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsDash, 'UnicodeIsDash', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsHyphen, 'UnicodeIsHyphen', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsDashOrHyphen, 'UnicodeIsDashOrHyphen', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsFullStop0_P, 'UnicodeIsFullStop0', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsFullStop1_P, 'UnicodeIsFullStop1', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsComma, 'UnicodeIsComma', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsExclamationMark, 'UnicodeIsExclamationMark', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsQuestionMark, 'UnicodeIsQuestionMark', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsLeftParenthesis, 'UnicodeIsLeftParenthesis', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsLeftBracket, 'UnicodeIsLeftBracket', cdRegister);
 S.RegisterDelphiFunction(@UnicodeGetRightParenthesis, 'UnicodeGetRightParenthesis', cdRegister);
 S.RegisterDelphiFunction(@UnicodeGetRightBracket, 'UnicodeGetRightBracket', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsSingularQuotationMark, 'UnicodeIsSingularQuotationMark', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsOpeningQuotationMark, 'UnicodeIsOpeningQuotationMark', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsClosingQuotationMark, 'UnicodeIsClosingQuotationMark', cdRegister);
 S.RegisterDelphiFunction(@UnicodeGetClosingQuotationMark, 'UnicodeGetClosingQuotationMark', cdRegister);
 S.RegisterDelphiFunction(@UnicodeGetOpeningQuotationMark, 'UnicodeGetOpeningQuotationMark', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsPunctuation, 'UnicodeIsPunctuation', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsDecimalDigit2_P, 'UnicodeIsDecimalDigit2', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsDecimalDigit3_P, 'UnicodeIsDecimalDigit3', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsAsciiDecimalDigit, 'UnicodeIsAsciiDecimalDigit', cdRegister);
 S.RegisterDelphiFunction(@UnicodeDecimalDigitValue4_P, 'UnicodeDecimalDigitValue4', cdRegister);
 S.RegisterDelphiFunction(@UnicodeDecimalDigitValue5_P, 'UnicodeDecimalDigitValue5', cdRegister);
 S.RegisterDelphiFunction(@UnicodeFractionCharacterValue, 'UnicodeFractionCharacterValue', cdRegister);
 S.RegisterDelphiFunction(@UnicodeRomanNumeralValue, 'UnicodeRomanNumeralValue', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsAsciiHexDigit, 'UnicodeIsAsciiHexDigit', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsHexDigit6_P, 'UnicodeIsHexDigit6', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsHexDigit7_P, 'UnicodeIsHexDigit7', cdRegister);
 S.RegisterDelphiFunction(@UnicodeHexDigitValue8_P, 'UnicodeHexDigitValue8', cdRegister);
 S.RegisterDelphiFunction(@UnicodeHexDigitValue9_P, 'UnicodeHexDigitValue9', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsUpperCase, 'UnicodeIsUpperCase', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsLowerCase, 'UnicodeIsLowerCase', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsTitleCase, 'UnicodeIsTitleCase', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsLetter, 'UnicodeIsLetter', cdRegister);
 S.RegisterDelphiFunction(@UnicodeIsAlphabetic, 'UnicodeIsAlphabetic', cdRegister);
 S.RegisterDelphiFunction(@UnicodeUpCase, 'UnicodeUpCase', cdRegister);
 S.RegisterDelphiFunction(@UnicodeLowCase, 'UnicodeLowCase', cdRegister);
 S.RegisterDelphiFunction(@UnicodeCharIsEqualNoCase, 'UnicodeCharIsEqualNoCase', cdRegister);
 S.RegisterDelphiFunction(@UnicodeGetCombiningClass, 'UnicodeGetCombiningClass', cdRegister);
 S.RegisterDelphiFunction(@UnicodeLocateFoldingUpperCase, 'UnicodeLocateFoldingUpperCase', cdRegister);
 S.RegisterDelphiFunction(@UnicodeLocateFoldingTitleCase, 'UnicodeLocateFoldingTitleCase', cdRegister);
 S.RegisterDelphiFunction(@UnicodeUpCaseFoldingU, 'UnicodeUpCaseFoldingU', cdRegister);
 S.RegisterDelphiFunction(@UnicodeLowCaseFoldingU, 'UnicodeLowCaseFoldingU', cdRegister);
 S.RegisterDelphiFunction(@UnicodeTitleCaseFoldingU, 'UnicodeTitleCaseFoldingU', cdRegister);
 S.RegisterDelphiFunction(@UnicodeGetCharacterDecompositionU10_P, 'UnicodeGetCharacterDecompositionU10', cdRegister);
 S.RegisterDelphiFunction(@UnicodeGetCharacterDecompositionU11_P, 'UnicodeGetCharacterDecompositionU11', cdRegister);
 S.RegisterDelphiFunction(@UnicodeUpperCaseFoldingU, 'UnicodeUpperCaseFoldingU', cdRegister);
 S.RegisterDelphiFunction(@UnicodeLowerCaseFoldingU, 'UnicodeLowerCaseFoldingU', cdRegister);
 S.RegisterDelphiFunction(@TestUnicode, 'TestUnicodeChar', cdRegister);
 S.RegisterDelphiFunction(@HexToBits, 'HexToBits', cdRegister);
 S.RegisterDelphiFunction(@Utf8ToStr, 'Utf8ToStr', cdRegister);

end;

 
 
{ TPSImport_flcUnicodeChar }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcUnicodeChar.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcUnicodeChar(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcUnicodeChar.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcUnicodeChar_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
