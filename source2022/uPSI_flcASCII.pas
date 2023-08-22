unit uPSI_flcASCII;
{
after dynarrays and vectors ^thies:   more for ASCII Talk

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
  TPSImport_flcASCII = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_flcASCII(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcASCII_Routines(S: TPSExec);

procedure Register;

implementation


uses
   flcStdTypes
  ,flcASCII
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcASCII]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_flcASCII(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('AsciiNULL','Char').SetString( ByteChar ( #0 ));
 CL.AddConstantN('AsciiSOH','Char').SetString( ByteChar ( #1 ));
 CL.AddConstantN('AsciiSTX','Char').SetString( ByteChar ( #2 ));
 CL.AddConstantN('AsciiETX','Char').SetString( ByteChar ( #3 ));
 CL.AddConstantN('AsciiEOT','Char').SetString( ByteChar ( #4 ));
 CL.AddConstantN('AsciiENQ','Char').SetString( ByteChar ( #5 ));
 CL.AddConstantN('AsciiACK','Char').SetString( ByteChar ( #6 ));
 CL.AddConstantN('AsciiBEL','Char').SetString( ByteChar ( #7 ));
 CL.AddConstantN('AsciiBS','Char').SetString( ByteChar ( #8 ));
 CL.AddConstantN('AsciiHT','Char').SetString( ByteChar ( #9 ));
 CL.AddConstantN('AsciiLF','Char').SetString( ByteChar ( #10 ));
 CL.AddConstantN('AsciiVT','Char').SetString( ByteChar ( #11 ));
 CL.AddConstantN('AsciiFF','Char').SetString( ByteChar ( #12 ));
 CL.AddConstantN('AsciiCR','Char').SetString( ByteChar ( #13 ));
 CL.AddConstantN('AsciiSO','Char').SetString( ByteChar ( #14 ));
 CL.AddConstantN('AsciiSI','Char').SetString( ByteChar ( #15 ));
 CL.AddConstantN('AsciiDLE','Char').SetString( ByteChar ( #16 ));
 CL.AddConstantN('AsciiDC1','Char').SetString( ByteChar ( #17 ));
 CL.AddConstantN('AsciiDC2','Char').SetString( ByteChar ( #18 ));
 CL.AddConstantN('AsciiDC3','Char').SetString( ByteChar ( #19 ));
 CL.AddConstantN('AsciiDC4','Char').SetString( ByteChar ( #20 ));
 CL.AddConstantN('AsciiNAK','Char').SetString( ByteChar ( #21 ));
 CL.AddConstantN('AsciiSYN','Char').SetString( ByteChar ( #22 ));
 CL.AddConstantN('AsciiETB','Char').SetString( ByteChar ( #23 ));
 CL.AddConstantN('AsciiCAN','Char').SetString( ByteChar ( #24 ));
 CL.AddConstantN('AsciiEM','Char').SetString( ByteChar ( #25 ));
 CL.AddConstantN('AsciiEOF','Char').SetString( ByteChar ( #26 ));
 CL.AddConstantN('AsciiESC','Char').SetString( ByteChar ( #27 ));
 CL.AddConstantN('AsciiFS','Char').SetString( ByteChar ( #28 ));
 CL.AddConstantN('AsciiGS','Char').SetString( ByteChar ( #29 ));
 CL.AddConstantN('AsciiRS','Char').SetString( ByteChar ( #30 ));
 CL.AddConstantN('AsciiUS','Char').SetString( ByteChar ( #31 ));
 CL.AddConstantN('AsciiSP','Char').SetString( ByteChar ( #32 ));
 CL.AddConstantN('AsciiDEL','Char').SetString( ByteChar ( #127 ));
 CL.AddConstantN('AsciiXON','char').SetString( AsciiDC1);
 CL.AddConstantN('AsciiXOFF','char').SetString( AsciiDC3);
 CL.AddConstantN('AsciiDecimalPoint','Char').SetString( ByteChar ( #46 ));
 CL.AddConstantN('AsciiComma','Char').SetString( ByteChar ( #44 ));
 CL.AddConstantN('AsciiBackSlash','Char').SetString( ByteChar ( #92 ));
 CL.AddConstantN('AsciiForwardSlash','Char').SetString( ByteChar ( #47 ));
 CL.AddConstantN('AsciiPercent','Char').SetString( ByteChar ( #37 ));
 CL.AddConstantN('AsciiAmpersand','Char').SetString( ByteChar ( #38 ));
 CL.AddConstantN('AsciiPlus','Char').SetString( ByteChar ( #43 ));
 CL.AddConstantN('AsciiMinus','Char').SetString( ByteChar ( #45 ));
 CL.AddConstantN('AsciiEqualSign','Char').SetString( ByteChar ( #61 ));
 CL.AddConstantN('AsciiSingleQuote','Char').SetString( ByteChar ( #39 ));
 CL.AddConstantN('AsciiDoubleQuote','Char').SetString( ByteChar ( #34 ));
 CL.AddConstantN('AsciiDigit0','Char').SetString( ByteChar ( #48 ));
 CL.AddConstantN('AsciiDigit9','Char').SetString( ByteChar ( #57 ));
 CL.AddConstantN('AsciiUpperA','Char').SetString( ByteChar ( #65 ));
 CL.AddConstantN('AsciiUpperZ','Char').SetString( ByteChar ( #90 ));
 CL.AddConstantN('AsciiLowerA','Char').SetString( ByteChar ( #97 ));
 CL.AddConstantN('AsciiLowerZ','Char').SetString( ByteChar ( #122 ));
 CL.AddConstantN('WideNULL','Char').SetString( WideChar ( #0 ));
 CL.AddConstantN('WideSOH','Char').SetString( WideChar ( #1 ));
 CL.AddConstantN('WideSTX','Char').SetString( WideChar ( #2 ));
 CL.AddConstantN('WideETX','Char').SetString( WideChar ( #3 ));
 CL.AddConstantN('WideEOT','Char').SetString( WideChar ( #4 ));
 CL.AddConstantN('WideENQ','Char').SetString( WideChar ( #5 ));
 CL.AddConstantN('WideACK','Char').SetString( WideChar ( #6 ));
 CL.AddConstantN('WideBEL','Char').SetString( WideChar ( #7 ));
 CL.AddConstantN('WideBS','Char').SetString( WideChar ( #8 ));
 CL.AddConstantN('WideHT','Char').SetString( WideChar ( #9 ));
 CL.AddConstantN('WideLF','Char').SetString( WideChar ( #10 ));
 CL.AddConstantN('WideVT','Char').SetString( WideChar ( #11 ));
 CL.AddConstantN('WideFF','Char').SetString( WideChar ( #12 ));
 CL.AddConstantN('WideCR','Char').SetString( WideChar ( #13 ));
 CL.AddConstantN('WideSO','Char').SetString( WideChar ( #14 ));
 CL.AddConstantN('WideSI','Char').SetString( WideChar ( #15 ));
 CL.AddConstantN('WideDLE','Char').SetString( WideChar ( #16 ));
 CL.AddConstantN('WideDC1','Char').SetString( WideChar ( #17 ));
 CL.AddConstantN('WideDC2','Char').SetString( WideChar ( #18 ));
 CL.AddConstantN('WideDC3','Char').SetString( WideChar ( #19 ));
 CL.AddConstantN('WideDC4','Char').SetString( WideChar ( #20 ));
 CL.AddConstantN('WideNAK','Char').SetString( WideChar ( #21 ));
 CL.AddConstantN('WideSYN','Char').SetString( WideChar ( #22 ));
 CL.AddConstantN('WideETB','Char').SetString( WideChar ( #23 ));
 CL.AddConstantN('WideCAN','Char').SetString( WideChar ( #24 ));
 CL.AddConstantN('WideEM','Char').SetString( WideChar ( #25 ));
 CL.AddConstantN('WideEOF','Char').SetString( WideChar ( #26 ));
 CL.AddConstantN('WideESC','Char').SetString( WideChar ( #27 ));
 CL.AddConstantN('WideFS','Char').SetString( WideChar ( #28 ));
 CL.AddConstantN('WideGS','Char').SetString( WideChar ( #29 ));
 CL.AddConstantN('WideRS','Char').SetString( WideChar ( #30 ));
 CL.AddConstantN('WideUS','Char').SetString( WideChar ( #31 ));
 CL.AddConstantN('WideSP','Char').SetString( WideChar ( #32 ));
 CL.AddConstantN('WideDEL','Char').SetString( WideChar ( #127 ));
 CL.AddConstantN('WideXON','char').SetString( WideDC1);
 CL.AddConstantN('WideXOFF','char').SetString( WideDC3);
 CL.AddConstantN('WideCRLF','String').SetString( WideString ( #13#10 ));
 CL.AddDelphiFunction('Function IsAsciiCharB( const C : Char) : Boolean');
 CL.AddDelphiFunction('Function IsAsciiCharW( const C : WideChar) : Boolean');
 CL.AddDelphiFunction('Function IsAsciiChar( const C : Char) : Boolean');
 //CL.AddDelphiFunction('Function IsAsciiBufB( const Buf : Pointer; const Len : NativeInt) : Boolean');
 //CL.AddDelphiFunction('Function IsAsciiBufW( const Buf : Pointer; const Len : NativeInt) : Boolean');
 CL.AddDelphiFunction('Function IsAsciiStringB( const S : String) : Boolean');
 CL.AddDelphiFunction('Function IsAsciiStringU( const S : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function IsAsciiString( const S : String) : Boolean');
 CL.AddDelphiFunction('Function AsciiHexCharValueB( const C : Char) : Integer');
 CL.AddDelphiFunction('Function AsciiHexCharValueW( const C : WideChar) : Integer');
 CL.AddDelphiFunction('Function AsciiIsHexCharB( const C : Char) : Boolean');
 CL.AddDelphiFunction('Function AsciiIsHexCharW( const C : WideChar) : Boolean');
 CL.AddDelphiFunction('Function AsciiDecimalCharValueB( const C : Char) : Integer');
 CL.AddDelphiFunction('Function AsciiDecimalCharValueW( const C : WideChar) : Integer');
 CL.AddDelphiFunction('Function AsciiIsDecimalCharB( const C : Char) : Boolean');
 CL.AddDelphiFunction('Function AsciiIsDecimalCharW( const C : WideChar) : Boolean');
 CL.AddDelphiFunction('Function AsciiOctalCharValueB( const C : Char) : Integer');
 CL.AddDelphiFunction('Function AsciiOctalCharValueW( const C : WideChar) : Integer');
 CL.AddDelphiFunction('Function AsciiIsOctalCharB( const C : Char) : Boolean');
 CL.AddDelphiFunction('Function AsciiIsOctalCharW( const C : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharCompareNoAsciiCaseB( const A, B : Char) : Integer');
 CL.AddDelphiFunction('Function CharCompareNoAsciiCaseW( const A, B : WideChar) : Integer');
 CL.AddDelphiFunction('Function CharCompareNoAsciiCase( const A, B : Char) : Integer');
 CL.AddDelphiFunction('Function CharEqualNoAsciiCaseB( const A, B : Char) : Boolean');
 CL.AddDelphiFunction('Function CharEqualNoAsciiCaseW( const A, B : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharEqualNoAsciiCase( const A, B : Char) : Boolean');
 //CL.AddDelphiFunction('Function StrPCompareNoAsciiCaseB( const A, B : PByteChar; const Len : NativeInt) : Integer');
 //7CL.AddDelphiFunction('Function StrPCompareNoAsciiCaseW( const A, B : PWideChar; const Len : NativeInt) : Integer');
 CL.AddDelphiFunction('Function StrPCompareNoAsciiCase( const A, B : PChar; const Len : NativeInt) : Integer');
 CL.AddDelphiFunction('Function StrCompareNoAsciiCaseA( const A, B : AnsiString) : Integer');
 CL.AddDelphiFunction('Function StrCompareNoAsciiCaseB( const A, B : String) : Integer');
 CL.AddDelphiFunction('Function StrCompareNoAsciiCaseU( const A, B : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function StrCompareNoAsciiCase( const A, B : String) : Integer');
 CL.AddDelphiFunction('Function AsciiLowCaseB( const C : Char) : Char');
 CL.AddDelphiFunction('Function AsciiLowCaseW( const C : WideChar) : WideChar');
 CL.AddDelphiFunction('Function AsciiLowCase( const C : Char) : Char');
 CL.AddDelphiFunction('Function AsciiUpCaseB( const C : Char) : Char ');
 CL.AddDelphiFunction('Function AsciiUpCaseW( const C : WideChar) : WideChar');
 CL.AddDelphiFunction('Function AsciiUpCase( const C : Char) : Char');
 CL.AddDelphiFunction('Procedure AsciiConvertUpperB( var S : String)');
 CL.AddDelphiFunction('Procedure AsciiConvertUpperU( var S : UnicodeString)');
 CL.AddDelphiFunction('Procedure AsciiConvertUpper( var S : String)');
 CL.AddDelphiFunction('Procedure AsciiConvertLowerB( var S : String)');
 CL.AddDelphiFunction('Procedure AsciiConvertLowerU( var S : UnicodeString)');
 CL.AddDelphiFunction('Procedure AsciiConvertLower( var S : String)');
 CL.AddDelphiFunction('Function AsciiUpperCaseB( const A : String) : String');
 CL.AddDelphiFunction('Function AsciiUpperCaseU( const A : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function AsciiUpperCase( const A : String) : String');
 CL.AddDelphiFunction('Function AsciiLowerCaseB( const A : String) : String');
 CL.AddDelphiFunction('Function AsciiLowerCaseU( const A : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function AsciiLowerCase( const A : String) : String');
 CL.AddDelphiFunction('Procedure AsciiConvertFirstUpB( var S : RawByteString)');
 CL.AddDelphiFunction('Procedure AsciiConvertFirstUpU( var S : UnicodeString)');
 CL.AddDelphiFunction('Procedure AsciiConvertFirstUp( var S : String)');
 CL.AddDelphiFunction('Function AsciiFirstUpB( const S : RawByteString) : RawByteString');
 CL.AddDelphiFunction('Function AsciiFirstUpU( const S : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function AsciiFirstUp( const S : String) : String');
 CL.AddDelphiFunction('Procedure AsciiConvertArrayUpper( var S : TStringArray)');
 CL.AddDelphiFunction('Procedure AsciiConvertArrayLower( var S : TStringArray)');
 CL.AddDelphiFunction('Procedure TestAscii');
 CL.AddDelphiFunction('Procedure TestAsciiRoutines');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_flcASCII_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsAsciiCharB, 'IsAsciiCharB', cdRegister);
 S.RegisterDelphiFunction(@IsAsciiCharW, 'IsAsciiCharW', cdRegister);
 S.RegisterDelphiFunction(@IsAsciiChar, 'IsAsciiChar', cdRegister);
 S.RegisterDelphiFunction(@IsAsciiBufB, 'IsAsciiBufB', cdRegister);
 S.RegisterDelphiFunction(@IsAsciiBufW, 'IsAsciiBufW', cdRegister);
 S.RegisterDelphiFunction(@IsAsciiStringB, 'IsAsciiStringB', cdRegister);
 S.RegisterDelphiFunction(@IsAsciiStringU, 'IsAsciiStringU', cdRegister);
 S.RegisterDelphiFunction(@IsAsciiString, 'IsAsciiString', cdRegister);
 S.RegisterDelphiFunction(@AsciiHexCharValueB, 'AsciiHexCharValueB', cdRegister);
 S.RegisterDelphiFunction(@AsciiHexCharValueW, 'AsciiHexCharValueW', cdRegister);
 S.RegisterDelphiFunction(@AsciiIsHexCharB, 'AsciiIsHexCharB', cdRegister);
 S.RegisterDelphiFunction(@AsciiIsHexCharW, 'AsciiIsHexCharW', cdRegister);
 S.RegisterDelphiFunction(@AsciiDecimalCharValueB, 'AsciiDecimalCharValueB', cdRegister);
 S.RegisterDelphiFunction(@AsciiDecimalCharValueW, 'AsciiDecimalCharValueW', cdRegister);
 S.RegisterDelphiFunction(@AsciiIsDecimalCharB, 'AsciiIsDecimalCharB', cdRegister);
 S.RegisterDelphiFunction(@AsciiIsDecimalCharW, 'AsciiIsDecimalCharW', cdRegister);
 S.RegisterDelphiFunction(@AsciiOctalCharValueB, 'AsciiOctalCharValueB', cdRegister);
 S.RegisterDelphiFunction(@AsciiOctalCharValueW, 'AsciiOctalCharValueW', cdRegister);
 S.RegisterDelphiFunction(@AsciiIsOctalCharB, 'AsciiIsOctalCharB', cdRegister);
 S.RegisterDelphiFunction(@AsciiIsOctalCharW, 'AsciiIsOctalCharW', cdRegister);
 S.RegisterDelphiFunction(@CharCompareNoAsciiCaseB, 'CharCompareNoAsciiCaseB', cdRegister);
 S.RegisterDelphiFunction(@CharCompareNoAsciiCaseW, 'CharCompareNoAsciiCaseW', cdRegister);
 S.RegisterDelphiFunction(@CharCompareNoAsciiCase, 'CharCompareNoAsciiCase', cdRegister);
 S.RegisterDelphiFunction(@CharEqualNoAsciiCaseB, 'CharEqualNoAsciiCaseB', cdRegister);
 S.RegisterDelphiFunction(@CharEqualNoAsciiCaseW, 'CharEqualNoAsciiCaseW', cdRegister);
 S.RegisterDelphiFunction(@CharEqualNoAsciiCase, 'CharEqualNoAsciiCase', cdRegister);
 S.RegisterDelphiFunction(@StrPCompareNoAsciiCaseB, 'StrPCompareNoAsciiCaseB', cdRegister);
 S.RegisterDelphiFunction(@StrPCompareNoAsciiCaseW, 'StrPCompareNoAsciiCaseW', cdRegister);
 S.RegisterDelphiFunction(@StrPCompareNoAsciiCase, 'StrPCompareNoAsciiCase', cdRegister);
 S.RegisterDelphiFunction(@StrCompareNoAsciiCaseA, 'StrCompareNoAsciiCaseA', cdRegister);
 S.RegisterDelphiFunction(@StrCompareNoAsciiCaseB, 'StrCompareNoAsciiCaseB', cdRegister);
 S.RegisterDelphiFunction(@StrCompareNoAsciiCaseU, 'StrCompareNoAsciiCaseU', cdRegister);
 S.RegisterDelphiFunction(@StrCompareNoAsciiCase, 'StrCompareNoAsciiCase', cdRegister);
 S.RegisterDelphiFunction(@AsciiLowCaseB, 'AsciiLowCaseB', cdRegister);
 S.RegisterDelphiFunction(@AsciiLowCaseW, 'AsciiLowCaseW', cdRegister);
 S.RegisterDelphiFunction(@AsciiLowCase, 'AsciiLowCase', cdRegister);
 S.RegisterDelphiFunction(@AsciiUpCaseB, 'AsciiUpCaseB', cdRegister);
 S.RegisterDelphiFunction(@AsciiUpCaseW, 'AsciiUpCaseW', cdRegister);
 S.RegisterDelphiFunction(@AsciiUpCase, 'AsciiUpCase', cdRegister);
 S.RegisterDelphiFunction(@AsciiConvertUpperB, 'AsciiConvertUpperB', cdRegister);
 S.RegisterDelphiFunction(@AsciiConvertUpperU, 'AsciiConvertUpperU', cdRegister);
 S.RegisterDelphiFunction(@AsciiConvertUpper, 'AsciiConvertUpper', cdRegister);
 S.RegisterDelphiFunction(@AsciiConvertLowerB, 'AsciiConvertLowerB', cdRegister);
 S.RegisterDelphiFunction(@AsciiConvertLowerU, 'AsciiConvertLowerU', cdRegister);
 S.RegisterDelphiFunction(@AsciiConvertLower, 'AsciiConvertLower', cdRegister);
 S.RegisterDelphiFunction(@AsciiUpperCaseB, 'AsciiUpperCaseB', cdRegister);
 S.RegisterDelphiFunction(@AsciiUpperCaseU, 'AsciiUpperCaseU', cdRegister);
 S.RegisterDelphiFunction(@AsciiUpperCase, 'AsciiUpperCase', cdRegister);
 S.RegisterDelphiFunction(@AsciiLowerCaseB, 'AsciiLowerCaseB', cdRegister);
 S.RegisterDelphiFunction(@AsciiLowerCaseU, 'AsciiLowerCaseU', cdRegister);
 S.RegisterDelphiFunction(@AsciiLowerCase, 'AsciiLowerCase', cdRegister);
 S.RegisterDelphiFunction(@AsciiConvertFirstUpB, 'AsciiConvertFirstUpB', cdRegister);
 S.RegisterDelphiFunction(@AsciiConvertFirstUpU, 'AsciiConvertFirstUpU', cdRegister);
 S.RegisterDelphiFunction(@AsciiConvertFirstUp, 'AsciiConvertFirstUp', cdRegister);
 S.RegisterDelphiFunction(@AsciiFirstUpB, 'AsciiFirstUpB', cdRegister);
 S.RegisterDelphiFunction(@AsciiFirstUpU, 'AsciiFirstUpU', cdRegister);
 S.RegisterDelphiFunction(@AsciiFirstUp, 'AsciiFirstUp', cdRegister);
 S.RegisterDelphiFunction(@AsciiConvertArrayUpper, 'AsciiConvertArrayUpper', cdRegister);
 S.RegisterDelphiFunction(@AsciiConvertArrayLower, 'AsciiConvertArrayLower', cdRegister);
 S.RegisterDelphiFunction(@TestAscii, 'TestAscii', cdRegister);
 S.RegisterDelphiFunction(@TestAscii, 'TestAsciiRoutines', cdRegister);
end;

 
 
{ TPSImport_flcASCII }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcASCII.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcASCII(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcASCII.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcASCII_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
