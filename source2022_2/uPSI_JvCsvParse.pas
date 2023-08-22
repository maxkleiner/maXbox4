unit uPSI_JvCsvParse;
{
  more functions
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
  TPSImport_JvCsvParse = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvCsvParse(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvCsvParse_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // JclUnitVersioning
  JvCsvParse
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvCsvParse]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvCsvParse(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxInitStrNum','LongInt').SetInt( 9);
 CL.AddDelphiFunction('Function JvAnsiStrSplit( const InString : AnsiString; const SplitChar, QuoteChar :Char; var OutStrings : array of AnsiString; MaxSplit : Integer) : Integer');
 CL.AddDelphiFunction('Function JvStrSplit( const InString : string; const SplitChar, QuoteChar : Char; var OutStrings : array of string; MaxSplit : Integer) : Integer');
 CL.AddDelphiFunction('Function JvAnsiStrSplitStrings( const InString : AnsiString; const SplitChar, QuoteChar :Char; OutStrings : TStrings) : Integer');
 CL.AddDelphiFunction('Function JvAnsiStrStrip( S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function JvStrStrip( S : string) : string');
 CL.AddDelphiFunction('Function GetString( var Source : AnsiString; const Separator : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function JPadString( const S : AnsiString; Len : Integer; PadChar :Char) : AnsiString');
 CL.AddDelphiFunction('Function BuildPathName( const PathName, FileName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrEatWhiteSpace( const S : string) : string');
 CL.AddDelphiFunction('Function HexToAscii( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AsciiToHex( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StripQuotes( const S1 : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ValidNumericLiteral( S1 : Char) : Boolean');
 CL.AddDelphiFunction('Function ValidIntLiteral( S1 : Char) : Boolean');
 CL.AddDelphiFunction('Function ValidHexLiteral( S1 : Char) : Boolean');
 CL.AddDelphiFunction('Function HexPCharToInt( S1 : Char) : Integer');
 CL.AddDelphiFunction('Function ValidStringLiteral( S1 : Char) : Boolean');
 CL.AddDelphiFunction('Function StripPCharQuotes( S1 : Char) : AnsiString');
 CL.AddDelphiFunction('Function JvValidIdentifierAnsi( S1 : Char) : Boolean');
 CL.AddDelphiFunction('Function JvValidIdentifier( S1 : String) : Boolean');
 CL.AddDelphiFunction('Function JvEndChar( X : Char) : Boolean');
 CL.AddDelphiFunction('Procedure JvGetToken( S1, S2 : Char)');
 CL.AddDelphiFunction('Function IsExpressionKeyword( S1 : Char) : Boolean');
 CL.AddDelphiFunction('Function IsKeyword( S1 : Char) : Boolean');
 CL.AddDelphiFunction('Function JvValidVarReference( S1 : Char) : Boolean');
 CL.AddDelphiFunction('Function GetParenthesis( S1, S2 : Char) : Boolean');
 CL.AddDelphiFunction('Procedure JvGetVarReference( S1, S2, SIdx : Char)');
 CL.AddDelphiFunction('Procedure JvEatWhitespaceChars( S1 : Char);');
 CL.AddDelphiFunction('Procedure JvEatWhitespaceChars1( S1 : Char);');
 CL.AddDelphiFunction('Function GetTokenCount : Integer');
 CL.AddDelphiFunction('Procedure ResetTokenCount');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure JvEatWhitespaceChars1_P( S1 : PWideChar);
Begin //JvCsvParse.JvEatWhitespaceChars(S1);
END;

(*----------------------------------------------------------------------------*)
Procedure JvEatWhitespaceChars_P( S1 : PAnsiChar);
Begin //JvCsvParse.JvEatWhitespaceChars(S1);
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvCsvParse_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@JvAnsiStrSplit, 'JvAnsiStrSplit', cdRegister);
 S.RegisterDelphiFunction(@JvStrSplit, 'JvStrSplit', cdRegister);
 S.RegisterDelphiFunction(@JvAnsiStrSplitStrings, 'JvAnsiStrSplitStrings', cdRegister);
 S.RegisterDelphiFunction(@JvAnsiStrStrip, 'JvAnsiStrStrip', cdRegister);
 S.RegisterDelphiFunction(@JvStrStrip, 'JvStrStrip', cdRegister);
 S.RegisterDelphiFunction(@GetString, 'GetString', cdRegister);
 S.RegisterDelphiFunction(@PadString, 'JPadString', cdRegister);
 S.RegisterDelphiFunction(@BuildPathName, 'BuildPathName', cdRegister);
 S.RegisterDelphiFunction(@StrEatWhiteSpace, 'StrEatWhiteSpace', cdRegister);
 S.RegisterDelphiFunction(@HexToAscii, 'HexToAscii', cdRegister);
 S.RegisterDelphiFunction(@AsciiToHex, 'AsciiToHex', cdRegister);
 S.RegisterDelphiFunction(@StripQuotes, 'StripQuotes', cdRegister);
 S.RegisterDelphiFunction(@ValidNumericLiteral, 'ValidNumericLiteral', cdRegister);
 S.RegisterDelphiFunction(@ValidIntLiteral, 'ValidIntLiteral', cdRegister);
 S.RegisterDelphiFunction(@ValidHexLiteral, 'ValidHexLiteral', cdRegister);
 S.RegisterDelphiFunction(@HexPCharToInt, 'HexPCharToInt', cdRegister);
 S.RegisterDelphiFunction(@ValidStringLiteral, 'ValidStringLiteral', cdRegister);
 S.RegisterDelphiFunction(@StripPCharQuotes, 'StripPCharQuotes', cdRegister);
 S.RegisterDelphiFunction(@JvValidIdentifierAnsi, 'JvValidIdentifierAnsi', cdRegister);
 S.RegisterDelphiFunction(@JvValidIdentifier, 'JvValidIdentifier', cdRegister);
 S.RegisterDelphiFunction(@JvEndChar, 'JvEndChar', cdRegister);
 S.RegisterDelphiFunction(@JvGetToken, 'JvGetToken', cdRegister);
 S.RegisterDelphiFunction(@IsExpressionKeyword, 'IsExpressionKeyword', cdRegister);
 S.RegisterDelphiFunction(@IsKeyword, 'IsKeyword', cdRegister);
 S.RegisterDelphiFunction(@JvValidVarReference, 'JvValidVarReference', cdRegister);
 S.RegisterDelphiFunction(@GetParenthesis, 'GetParenthesis', cdRegister);
 S.RegisterDelphiFunction(@JvGetVarReference, 'JvGetVarReference', cdRegister);
 S.RegisterDelphiFunction(@JvEatWhitespaceChars, 'JvEatWhitespaceChars', cdRegister);
 S.RegisterDelphiFunction(@JvEatWhitespaceChars1_P, 'JvEatWhitespaceChars1', cdRegister);
 S.RegisterDelphiFunction(@GetTokenCount, 'GetTokenCount', cdRegister);
 S.RegisterDelphiFunction(@ResetTokenCount, 'ResetTokenCount', cdRegister);
end;

 
 
{ TPSImport_JvCsvParse }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCsvParse.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvCsvParse(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCsvParse.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvCsvParse(ri);
  RIRegister_JvCsvParse_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
