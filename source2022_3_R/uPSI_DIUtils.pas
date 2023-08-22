unit uPSI_DIUtils;
{
  a last big function bix box
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
  TPSImport_DIUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
//procedure SIRegister_TWideStrBuf(CL: TPSPascalCompiler);
procedure SIRegister_TMT19937(CL: TPSPascalCompiler);
procedure SIRegister_DIUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DIUtils_Routines(S: TPSExec);
//procedure RIRegister_TWideStrBuf(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMT19937(CL: TPSRuntimeClassImporter);
procedure RIRegister_DIUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //DISystemCompat
  Windows
  ,ShlObj
  ,DIUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DIUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TWideStrBuf(CL: TPSPascalCompiler);
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
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMT19937(CL: TPSPascalCompiler);
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
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DIUtils(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('CRLF','String').SetString( #$0D#$0A);
 CL.AddConstantN('DOS_PATH_DELIMITER','String').SetString( '\');
 CL.AddConstantN('UNIX_PATH_DELIMITER','String').SetString( '/');
 CL.AddConstantN('PATH_DELIMITER','string').SetString( DOS_PATH_DELIMITER);
 CL.AddConstantN('CHAR_NULL','Char').SetString( #$00);
 CL.AddConstantN('CHAR_TAB','Char').SetString( #$09);
 CL.AddConstantN('CHAR_LF','Char').SetString( #$0A);
 CL.AddConstantN('CHAR_CR','Char').SetString( #$0D);
 CL.AddConstantN('CHAR_SPACE','Char').SetString( #$20);
 CL.AddConstantN('CHAR_ASTERISK','Char').SetString( #$2A);
 CL.AddConstantN('CHAR_FULL_STOP','Char').SetString( #$2E);
 CL.AddConstantN('CHAR_EQUALS_SIGN','Char').SetString( #$3D);
 CL.AddConstantN('CHAR_QUESTION_MARK','Char').SetString( #$3F);
 CL.AddConstantN('AC_NULL','Char').SetString( AnsiChar ( #$00 ));
 CL.AddConstantN('AC_TAB','Char').SetString( AnsiChar ( #$09 ));
 CL.AddConstantN('AC_LF','Char').SetString( AnsiChar ( #$000A ));
 CL.AddConstantN('AC_CR','Char').SetString( AnsiChar ( #$000D ));
 CL.AddConstantN('AC_SPACE','Char').SetString( AnsiChar ( #$20 ));
 CL.AddConstantN('AC_EXCLAMATION_MARK','Char').SetString( AnsiChar ( #$21 ));
 CL.AddConstantN('AC_QUOTATION_MARK','Char').SetString( AnsiChar ( #$22 ));
 CL.AddConstantN('AC_NUMBER_SIGN','Char').SetString( AnsiChar ( #$23 ));
 CL.AddConstantN('AC_DOLLAR_SIGN','Char').SetString( AnsiChar ( #$24 ));
 CL.AddConstantN('AC_PERCENT_SIGN','Char').SetString( AnsiChar ( #$25 ));
 CL.AddConstantN('AC_AMPERSAND','Char').SetString( AnsiChar ( #$26 ));
 CL.AddConstantN('AC_APOSTROPHE','Char').SetString( AnsiChar ( #$27 ));
 CL.AddConstantN('AC_LEFT_PARENTHESIS','Char').SetString( AnsiChar ( #$28 ));
 CL.AddConstantN('AC_RIGHT_PARENTHESIS','Char').SetString( AnsiChar ( #$29 ));
 CL.AddConstantN('AC_ASTERISK','Char').SetString( AnsiChar ( #$2A ));
 CL.AddConstantN('AC_PLUS_SIGN','Char').SetString( AnsiChar ( #$2B ));
 CL.AddConstantN('AC_COMMA','Char').SetString( AnsiChar ( #$2C ));
 CL.AddConstantN('AC_HYPHEN_MINUS','Char').SetString( AnsiChar ( #$2D ));
 CL.AddConstantN('AC_FULL_STOP','Char').SetString( AnsiChar ( #$2E ));
 CL.AddConstantN('AC_SOLIDUS','Char').SetString( AnsiChar ( #$2F ));
 CL.AddConstantN('AC_DIGIT_ZERO','Char').SetString( AnsiChar ( #$30 ));
 CL.AddConstantN('AC_DIGIT_ONE','Char').SetString( AnsiChar ( #$31 ));
 CL.AddConstantN('AC_DIGIT_TWO','Char').SetString( AnsiChar ( #$32 ));
 CL.AddConstantN('AC_DIGIT_THREE','Char').SetString( AnsiChar ( #$33 ));
 CL.AddConstantN('AC_DIGIT_FOUR','Char').SetString( AnsiChar ( #$34 ));
 CL.AddConstantN('AC_DIGIT_FIVE','Char').SetString( AnsiChar ( #$35 ));
 CL.AddConstantN('AC_DIGIT_SIX','Char').SetString( AnsiChar ( #$36 ));
 CL.AddConstantN('AC_DIGIT_SEVEN','Char').SetString( AnsiChar ( #$37 ));
 CL.AddConstantN('AC_DIGIT_EIGHT','Char').SetString( AnsiChar ( #$38 ));
 CL.AddConstantN('AC_DIGIT_NINE','Char').SetString( AnsiChar ( #$39 ));
 CL.AddConstantN('AC_COLON','Char').SetString( AnsiChar ( #$3A ));
 CL.AddConstantN('AC_SEMICOLON','Char').SetString( AnsiChar ( #$3B ));
 CL.AddConstantN('AC_LESS_THAN_SIGN','Char').SetString( AnsiChar ( #$3C ));
 CL.AddConstantN('AC_EQUALS_SIGN','Char').SetString( AnsiChar ( #$3D ));
 CL.AddConstantN('AC_GREATER_THAN_SIGN','Char').SetString( AnsiChar ( #$3E ));
 CL.AddConstantN('AC_QUESTION_MARK','Char').SetString( AnsiChar ( #$3F ));
 CL.AddConstantN('AC_COMMERCIAL_AT','Char').SetString( AnsiChar ( #$40 ));
 CL.AddConstantN('AC_REVERSE_SOLIDUS','Char').SetString( AnsiChar ( #$5C ));
 CL.AddConstantN('AC_LOW_LINE','Char').SetString( AnsiChar ( #$5F ));
 CL.AddConstantN('AC_SOFT_HYPHEN','Char').SetString( AnsiChar ( #$AD ));
 CL.AddConstantN('AC_CAPITAL_A','Char').SetString( AnsiChar ( #$41 ));
 CL.AddConstantN('AC_CAPITAL_B','Char').SetString( AnsiChar ( #$42 ));
 CL.AddConstantN('AC_CAPITAL_C','Char').SetString( AnsiChar ( #$43 ));
 CL.AddConstantN('AC_CAPITAL_D','Char').SetString( AnsiChar ( #$44 ));
 CL.AddConstantN('AC_CAPITAL_E','Char').SetString( AnsiChar ( #$45 ));
 CL.AddConstantN('AC_CAPITAL_F','Char').SetString( AnsiChar ( #$46 ));
 CL.AddConstantN('AC_CAPITAL_G','Char').SetString( AnsiChar ( #$47 ));
 CL.AddConstantN('AC_CAPITAL_H','Char').SetString( AnsiChar ( #$48 ));
 CL.AddConstantN('AC_CAPITAL_I','Char').SetString( AnsiChar ( #$49 ));
 CL.AddConstantN('AC_CAPITAL_J','Char').SetString( AnsiChar ( #$4A ));
 CL.AddConstantN('AC_CAPITAL_K','Char').SetString( AnsiChar ( #$4B ));
 CL.AddConstantN('AC_CAPITAL_L','Char').SetString( AnsiChar ( #$4C ));
 CL.AddConstantN('AC_CAPITAL_M','Char').SetString( AnsiChar ( #$4D ));
 CL.AddConstantN('AC_CAPITAL_N','Char').SetString( AnsiChar ( #$4E ));
 CL.AddConstantN('AC_CAPITAL_O','Char').SetString( AnsiChar ( #$4F ));
 CL.AddConstantN('AC_CAPITAL_P','Char').SetString( AnsiChar ( #$50 ));
 CL.AddConstantN('AC_CAPITAL_Q','Char').SetString( AnsiChar ( #$51 ));
 CL.AddConstantN('AC_CAPITAL_R','Char').SetString( AnsiChar ( #$52 ));
 CL.AddConstantN('AC_CAPITAL_S','Char').SetString( AnsiChar ( #$53 ));
 CL.AddConstantN('AC_CAPITAL_T','Char').SetString( AnsiChar ( #$54 ));
 CL.AddConstantN('AC_CAPITAL_U','Char').SetString( AnsiChar ( #$55 ));
 CL.AddConstantN('AC_CAPITAL_V','Char').SetString( AnsiChar ( #$56 ));
 CL.AddConstantN('AC_CAPITAL_W','Char').SetString( AnsiChar ( #$57 ));
 CL.AddConstantN('AC_CAPITAL_X','Char').SetString( AnsiChar ( #$58 ));
 CL.AddConstantN('AC_CAPITAL_Y','Char').SetString( AnsiChar ( #$59 ));
 CL.AddConstantN('AC_CAPITAL_Z','Char').SetString( AnsiChar ( #$5A ));
 CL.AddConstantN('AC_GRAVE_ACCENT','Char').SetString( AnsiChar ( #$60 ));
 CL.AddConstantN('AC_SMALL_A','Char').SetString( AnsiChar ( #$61 ));
 CL.AddConstantN('AC_SMALL_B','Char').SetString( AnsiChar ( #$62 ));
 CL.AddConstantN('AC_SMALL_C','Char').SetString( AnsiChar ( #$63 ));
 CL.AddConstantN('AC_SMALL_D','Char').SetString( AnsiChar ( #$64 ));
 CL.AddConstantN('AC_SMALL_E','Char').SetString( AnsiChar ( #$65 ));
 CL.AddConstantN('AC_SMALL_F','Char').SetString( AnsiChar ( #$66 ));
 CL.AddConstantN('AC_SMALL_G','Char').SetString( AnsiChar ( #$67 ));
 CL.AddConstantN('AC_SMALL_H','Char').SetString( AnsiChar ( #$68 ));
 CL.AddConstantN('AC_SMALL_I','Char').SetString( AnsiChar ( #$69 ));
 CL.AddConstantN('AC_SMALL_J','Char').SetString( AnsiChar ( #$6A ));
 CL.AddConstantN('AC_SMALL_K','Char').SetString( AnsiChar ( #$6B ));
 CL.AddConstantN('AC_SMALL_L','Char').SetString( AnsiChar ( #$6C ));
 CL.AddConstantN('AC_SMALL_M','Char').SetString( AnsiChar ( #$6D ));
 CL.AddConstantN('AC_SMALL_N','Char').SetString( AnsiChar ( #$6E ));
 CL.AddConstantN('AC_SMALL_O','Char').SetString( AnsiChar ( #$6F ));
 CL.AddConstantN('AC_SMALL_P','Char').SetString( AnsiChar ( #$70 ));
 CL.AddConstantN('AC_SMALL_Q','Char').SetString( AnsiChar ( #$71 ));
 CL.AddConstantN('AC_SMALL_R','Char').SetString( AnsiChar ( #$72 ));
 CL.AddConstantN('AC_SMALL_S','Char').SetString( AnsiChar ( #$73 ));
 CL.AddConstantN('AC_SMALL_T','Char').SetString( AnsiChar ( #$74 ));
 CL.AddConstantN('AC_SMALL_U','Char').SetString( AnsiChar ( #$75 ));
 CL.AddConstantN('AC_SMALL_V','Char').SetString( AnsiChar ( #$76 ));
 CL.AddConstantN('AC_SMALL_W','Char').SetString( AnsiChar ( #$77 ));
 CL.AddConstantN('AC_SMALL_X','Char').SetString( AnsiChar ( #$78 ));
 CL.AddConstantN('AC_SMALL_Y','Char').SetString( AnsiChar ( #$79 ));
 CL.AddConstantN('AC_SMALL_Z','Char').SetString( AnsiChar ( #$7A ));
 CL.AddConstantN('AC_NO_BREAK_SPACE','Char').SetString( AnsiChar ( #$A0 ));
 CL.AddConstantN('AC_DRIVE_DELIMITER','string').SetString( AC_COLON);
 CL.AddConstantN('AC_DOS_PATH_DELIMITER','string').SetString( AC_REVERSE_SOLIDUS);
 CL.AddConstantN('AC_UNIX_PATH_DELIMITER','string').SetString( AC_SOLIDUS);
 CL.AddConstantN('AS_CRLF','String').SetString( AnsiString ( #$0D#$0A ));

 {CL.AddConstantN('WC_NULL','Char').SetString( WideChar ( #$0000 ));
 CL.AddConstantN('WC_0001','Char').SetString( WideChar ( #$0001 ));
 CL.AddConstantN('WC_0008','Char').SetString( WideChar ( #$0008 ));
 CL.AddConstantN('WC_TAB','Char').SetString( WideChar ( #$0009 ));
 CL.AddConstantN('WC_LF','Char').SetString( WideChar ( #$000A ));
 CL.AddConstantN('WC_000B','Char').SetString( WideChar ( #$000B ));
 CL.AddConstantN('WC_000C','Char').SetString( WideChar ( #$000C ));
 CL.AddConstantN('WC_CR','Char').SetString( WideChar ( #$000D ));
 CL.AddConstantN('WC_000E','Char').SetString( WideChar ( #$000E ));
 CL.AddConstantN('WC_SPACE','Char').SetString( WideChar ( #$0020 ));
 CL.AddConstantN('WC_EXCLAMATION_MARK','Char').SetString( WideChar ( #$0021 ));
 CL.AddConstantN('WC_QUOTATION_MARK','Char').SetString( WideChar ( #$0022 ));
 CL.AddConstantN('WC_NUMBER_SIGN','Char').SetString( WideChar ( #$0023 ));
 CL.AddConstantN('WC_DOLLAR_SIGN','Char').SetString( WideChar ( #$0024 ));
 CL.AddConstantN('WC_PERCENT_SIGN','Char').SetString( WideChar ( #$0025 ));
 CL.AddConstantN('WC_AMPERSAND','Char').SetString( WideChar ( #$0026 ));
 CL.AddConstantN('WC_APOSTROPHE','Char').SetString( WideChar ( #$0027 ));
 CL.AddConstantN('WC_LEFT_PARENTHESIS','Char').SetString( WideChar ( #$0028 ));
 CL.AddConstantN('WC_RIGHT_PARENTHESIS','Char').SetString( WideChar ( #$0029 ));
 CL.AddConstantN('WC_ASTERISK','Char').SetString( WideChar ( #$002A ));
 CL.AddConstantN('WC_PLUS_SIGN','Char').SetString( WideChar ( #$002B ));
 CL.AddConstantN('WC_COMMA','Char').SetString( WideChar ( #$002C ));
 CL.AddConstantN('WC_HYPHEN_MINUS','Char').SetString( WideChar ( #$002D ));
 CL.AddConstantN('WC_FULL_STOP','Char').SetString( WideChar ( #$002E ));
 CL.AddConstantN('WC_SOLIDUS','Char').SetString( WideChar ( #$002F ));
 CL.AddConstantN('WC_DIGIT_ZERO','Char').SetString( WideChar ( #$0030 ));
 CL.AddConstantN('WC_DIGIT_ONE','Char').SetString( WideChar ( #$0031 ));
 CL.AddConstantN('WC_DIGIT_TWO','Char').SetString( WideChar ( #$0032 ));
 CL.AddConstantN('WC_DIGIT_THREE','Char').SetString( WideChar ( #$0033 ));
 CL.AddConstantN('WC_DIGIT_FOUR','Char').SetString( WideChar ( #$0034 ));
 CL.AddConstantN('WC_DIGIT_FIVE','Char').SetString( WideChar ( #$0035 ));
 CL.AddConstantN('WC_DIGIT_SIX','Char').SetString( WideChar ( #$0036 ));
 CL.AddConstantN('WC_DIGIT_SEVEN','Char').SetString( WideChar ( #$0037 ));
 CL.AddConstantN('WC_DIGIT_EIGHT','Char').SetString( WideChar ( #$0038 ));
 CL.AddConstantN('WC_DIGIT_NINE','Char').SetString( WideChar ( #$0039 ));
 CL.AddConstantN('WC_COLON','Char').SetString( WideChar ( #$003A ));
 CL.AddConstantN('WC_SEMICOLON','Char').SetString( WideChar ( #$003B ));
 CL.AddConstantN('WC_LESS_THAN_SIGN','Char').SetString( WideChar ( #$003C ));
 CL.AddConstantN('WC_EQUALS_SIGN','Char').SetString( WideChar ( #$003D ));
 CL.AddConstantN('WC_COMMERCIAL_AT','Char').SetString( WideChar ( #$0040 ));
 CL.AddConstantN('WC_GREATER_THAN_SIGN','Char').SetString( WideChar ( #$003E ));
 CL.AddConstantN('WC_QUESTION_MARK','Char').SetString( WideChar ( #$003F ));
 CL.AddConstantN('WC_CAPITAL_A','Char').SetString( WideChar ( #$0041 ));
 CL.AddConstantN('WC_CAPITAL_B','Char').SetString( WideChar ( #$0042 ));
 CL.AddConstantN('WC_CAPITAL_C','Char').SetString( WideChar ( #$0043 ));
 CL.AddConstantN('WC_CAPITAL_D','Char').SetString( WideChar ( #$0044 ));
 CL.AddConstantN('WC_CAPITAL_E','Char').SetString( WideChar ( #$0045 ));
 CL.AddConstantN('WC_CAPITAL_F','Char').SetString( WideChar ( #$0046 ));
 CL.AddConstantN('WC_CAPITAL_G','Char').SetString( WideChar ( #$0047 ));
 CL.AddConstantN('WC_CAPITAL_H','Char').SetString( WideChar ( #$0048 ));
 CL.AddConstantN('WC_CAPITAL_I','Char').SetString( WideChar ( #$0049 ));
 CL.AddConstantN('WC_CAPITAL_J','Char').SetString( WideChar ( #$004A ));
 CL.AddConstantN('WC_CAPITAL_K','Char').SetString( WideChar ( #$004B ));
 CL.AddConstantN('WC_CAPITAL_L','Char').SetString( WideChar ( #$004C ));
 CL.AddConstantN('WC_CAPITAL_M','Char').SetString( WideChar ( #$004D ));
 CL.AddConstantN('WC_CAPITAL_N','Char').SetString( WideChar ( #$004E ));
 CL.AddConstantN('WC_CAPITAL_O','Char').SetString( WideChar ( #$004F ));
 CL.AddConstantN('WC_CAPITAL_P','Char').SetString( WideChar ( #$0050 ));
 CL.AddConstantN('WC_CAPITAL_Q','Char').SetString( WideChar ( #$0051 ));
 CL.AddConstantN('WC_CAPITAL_R','Char').SetString( WideChar ( #$0052 ));
 CL.AddConstantN('WC_CAPITAL_S','Char').SetString( WideChar ( #$0053 ));
 CL.AddConstantN('WC_CAPITAL_T','Char').SetString( WideChar ( #$0054 ));
 CL.AddConstantN('WC_CAPITAL_U','Char').SetString( WideChar ( #$0055 ));
 CL.AddConstantN('WC_CAPITAL_V','Char').SetString( WideChar ( #$0056 ));
 CL.AddConstantN('WC_CAPITAL_W','Char').SetString( WideChar ( #$0057 ));
 CL.AddConstantN('WC_CAPITAL_X','Char').SetString( WideChar ( #$0058 ));
 CL.AddConstantN('WC_CAPITAL_Y','Char').SetString( WideChar ( #$0059 ));
 CL.AddConstantN('WC_CAPITAL_Z','Char').SetString( WideChar ( #$005A ));
 CL.AddConstantN('WC_LEFT_SQUARE_BRACKET','Char').SetString( WideChar ( #$005B ));
 CL.AddConstantN('WC_REVERSE_SOLIDUS','Char').SetString( WideChar ( #$005C ));
 CL.AddConstantN('WC_RIGHT_SQUARE_BRACKET','Char').SetString( WideChar ( #$005D ));
 CL.AddConstantN('WC_CIRCUMFLEX_ACCENT','Char').SetString( WideChar ( #$005E ));
 CL.AddConstantN('WC_LOW_LINE','Char').SetString( WideChar ( #$005F ));
 CL.AddConstantN('WC_GRAVE_ACCENT','Char').SetString( WideChar ( #$0060 ));
 CL.AddConstantN('WC_SMALL_A','Char').SetString( WideChar ( #$0061 ));
 CL.AddConstantN('WC_SMALL_B','Char').SetString( WideChar ( #$0062 ));
 CL.AddConstantN('WC_SMALL_C','Char').SetString( WideChar ( #$0063 ));
 CL.AddConstantN('WC_SMALL_D','Char').SetString( WideChar ( #$0064 ));
 CL.AddConstantN('WC_SMALL_E','Char').SetString( WideChar ( #$0065 ));
 CL.AddConstantN('WC_SMALL_F','Char').SetString( WideChar ( #$0066 ));
 CL.AddConstantN('WC_SMALL_G','Char').SetString( WideChar ( #$0067 ));
 CL.AddConstantN('WC_SMALL_H','Char').SetString( WideChar ( #$0068 ));
 CL.AddConstantN('WC_SMALL_I','Char').SetString( WideChar ( #$0069 ));
 CL.AddConstantN('WC_SMALL_J','Char').SetString( WideChar ( #$006A ));
 CL.AddConstantN('WC_SMALL_K','Char').SetString( WideChar ( #$006B ));
 CL.AddConstantN('WC_SMALL_L','Char').SetString( WideChar ( #$006C ));
 CL.AddConstantN('WC_SMALL_M','Char').SetString( WideChar ( #$006D ));
 CL.AddConstantN('WC_SMALL_N','Char').SetString( WideChar ( #$006E ));
 CL.AddConstantN('WC_SMALL_O','Char').SetString( WideChar ( #$006F ));
 CL.AddConstantN('WC_SMALL_P','Char').SetString( WideChar ( #$0070 ));
 CL.AddConstantN('WC_SMALL_Q','Char').SetString( WideChar ( #$0071 ));
 CL.AddConstantN('WC_SMALL_R','Char').SetString( WideChar ( #$0072 ));
 CL.AddConstantN('WC_SMALL_S','Char').SetString( WideChar ( #$0073 ));
 CL.AddConstantN('WC_SMALL_T','Char').SetString( WideChar ( #$0074 ));
 CL.AddConstantN('WC_SMALL_U','Char').SetString( WideChar ( #$0075 ));
 CL.AddConstantN('WC_SMALL_V','Char').SetString( WideChar ( #$0076 ));
 CL.AddConstantN('WC_SMALL_W','Char').SetString( WideChar ( #$0077 ));
 CL.AddConstantN('WC_SMALL_X','Char').SetString( WideChar ( #$0078 ));
 CL.AddConstantN('WC_SMALL_Y','Char').SetString( WideChar ( #$0079 ));
 CL.AddConstantN('WC_SMALL_Z','Char').SetString( WideChar ( #$007A ));
 CL.AddConstantN('WC_LEFT_CURLY_BRACKET','Char').SetString( WideChar ( #$007B ));
 CL.AddConstantN('WC_VERTICAL_LINE','Char').SetString( WideChar ( #$007C ));
 CL.AddConstantN('WC_RIGHT_CURLY_BRACKET','Char').SetString( WideChar ( #$007D ));
 CL.AddConstantN('WC_TILDE','Char').SetString( WideChar ( #$007E ));
 CL.AddConstantN('WC_NO_BREAK_SPACE','Char').SetString( WideChar ( #$00A0 ));
 CL.AddConstantN('WC_SOFT_HYPHEN','Char').SetString( WideChar ( #$00AD ));
 CL.AddConstantN('WC_EN_DASH','Char').SetString( WideChar ( #$2013 ));
 CL.AddConstantN('WC_LINE_SEPARATOR','LongWord').SetUInt( WideChar ( $2028 ));
 CL.AddConstantN('WC_REPLACEMENT_CHARACTER','Char').SetString( WideChar ( #$FFFD ));
 CL.AddConstantN('WC_DOS_PATH_DELIMITER','').SetString( WC_REVERSE_SOLIDUS);
 CL.AddConstantN('WC_UNIX_PATH_DELIMITER','').SetString( WC_SOLIDUS);
 CL.AddConstantN('WS_CRLF','String').SetString( WideString ( #$000D#$000A ));}
 CL.AddConstantN('REPLACEMENT_CHARACTER','LongWord').SetUInt( $FFFD);
 CL.AddConstantN('HANGUL_SBase','LongWord').SetUInt( $AC00);
 CL.AddConstantN('HANGUL_LBase','LongWord').SetUInt( $1100);
 CL.AddConstantN('HANGUL_VBase','LongWord').SetUInt( $1161);
 CL.AddConstantN('HANGUL_TBase','LongWord').SetUInt( $11A7);
 CL.AddConstantN('HANGUL_LCount','LongInt').SetInt( 19);
 CL.AddConstantN('HANGUL_VCount','LongInt').SetInt( 21);
 CL.AddConstantN('HANGUL_TCount','LongInt').SetInt( 28);
 CL.AddConstantN('KEY_WOW64_32KEY','LongWord').SetUInt( $0200);
 CL.AddConstantN('KEY_WOW64_64KEY','LongWord').SetUInt( $0100);
 CL.AddConstantN('KEY_WOW64_RES','LongWord').SetUInt( $0300);
  CL.AddTypeS('TAnsiCharSet', 'set of AnsiChar');
  CL.AddTypeS('TIsoDate', 'Cardinal');
  CL.AddTypeS('TJulianDate', 'Integer');
  //CL.AddTypeS('PJulianDate', '^TJulianDate // will not work');
  CL.AddTypeS('TValidateCharFunc', 'function(const c: Char): Boolean;');

  // TValidateCharFunc = function(  const c: Char): Boolean;

  CL.AddTypeS('TProcedureEvent', 'Procedure');
 CL.AddConstantN('MT19937_N','LongInt').SetInt( 624);
 CL.AddConstantN('MT19937_M','LongInt').SetInt( 397);
  SIRegister_TMT19937(CL);
  //SIRegister_TWideStrBuf(CL);
  CL.AddTypeS('TDITextLineBreakStyle', '( tlbsLF, tlbsCRLF, tlbsCR )');
 CL.AddDelphiFunction('Function AdjustLineBreaksW( const s : UnicodeString; const Style : TDITextLineBreakStyle) : UnicodeString');
 CL.AddDelphiFunction('Function BrightenColor( const Color : Integer; const amount : Byte) : Integer');
 CL.AddDelphiFunction('Function BSwap4( const Value : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function BSwap5( const Value : Integer) : Integer;');
 //CL.AddDelphiFunction('Function BufCompNumIW( p1 : PWideChar; l1 : Integer; p2 : PWideChar; l2 : Integer) : Integer');
 {CL.AddDelphiFunction('Function BufCountUtf8Chars(p: PUtf8Char; l: Cardinal): Cardinal');
 CL.AddDelphiFunction('Function BufDecodeUtf8( const p : PUtf8Char; const l : NativeUInt) : UnicodeString');
 CL.AddDelphiFunction('Function BufEncodeUtf8( const p : PWideChar; const l : NativeUInt) : Utf8String');
 CL.AddDelphiFunction('Function BufIsCharsW6( const p : PWideChar; const l : NativeUInt; const Validate : TValidateCharFuncW) : Boolean;');
 CL.AddDelphiFunction('Function BufIsCharsW7( const p : PWideChar; const l : NativeUInt; const Validate : TValidateCharFuncW; const c : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function BufHasCharsW( const Buf : PWideChar; const BufCharCount : NativeUInt; const Validate : TValidateCharFuncW) : Boolean');
 }
 //CL.AddDelphiFunction('Function BufPosA( const ASearch : RawByteString; const ABuf : PChar; const ABufCharCount : Cardinal; const AStartPos : Cardinal) : Pointer');
 //CL.AddDelphiFunction('Function BufPosW( const ASearch : UnicodeString; const ABuf : PWideChar; const ABufCharCount : Cardinal; const AStartPos : Cardinal) : PWideChar');
 //CL.AddDelphiFunction('Function BufPosIA( const ASearch : RawByteString; const ABuf : PAnsiChar; const ABufCharCount : Cardinal; const AStartPos : Cardinal) : Pointer');
 //CL.AddDelphiFunction('Function BufPosIW( const ASearch : UnicodeString; const ABuffer : PWideChar; const ABufferCharCount : Cardinal; const AStartPos : Cardinal) : PWideChar');
 CL.AddDelphiFunction('Function BufSameA( p1, p2 : PChar; l : Cardinal) : Boolean');
// CL.AddDelphiFunction('Function BufSameW( p1, p2 : PWideChar; l : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function BufSameIA( p1, p2 : PChar; l : Cardinal) : Boolean');
 //CL.AddDelphiFunction('Function BufSameIW( p1, p2 : PWideChar; l : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function BufPosCharA( const Buf : PChar; l : Cardinal; const c : AnsiChar; const Start : Cardinal) : Integer');
 CL.AddDelphiFunction('Function BufPosCharsA( const Buf : PChar; l : Cardinal; const Search : TAnsiCharSet; const Start : Cardinal) : Integer');
 //CL.AddDelphiFunction('Function BufPosCharsW( const Buf : PWideChar; l : Cardinal; const Validate : TValidateCharFuncW; const Start : Cardinal) : Integer');
 CL.AddDelphiFunction('Function BufStrSame( const Buf : PChar; const BufCharCount : Cardinal; const s : string) : Boolean');
 CL.AddDelphiFunction('Function BufStrSameA( const Buf : PChar; const BufCharCount : Cardinal; const s : RawByteString) : Boolean');
 //CL.AddDelphiFunction('Function BufStrSameW( const Buf : PWideChar; const BufCharCount : Cardinal; const s : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function BufStrSameI( const Buf : PChar; const BufCharCount : Cardinal; const s : string) : Boolean');
 CL.AddDelphiFunction('Function BufStrSameIA( const Buf : PChar; const BufCharCount : Cardinal; const s : RawByteString) : Boolean');
 //CL.AddDelphiFunction('Function BufStrSameIW( const Buffer : PWideChar; const WideCharCount : Cardinal; const w : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function diChangeFileExt(const FileName,Extension: string): string');
 CL.AddDelphiFunction('Function ChangeFileExtA( const FileName, Extension : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ChangeFileExtW( const FileName, Extension : UnicodeString) : UnicodeString');
 //CL.AddDelphiFunction('Function CharDecomposeCanonicalW( const c : WideChar) : PCharDecompositionW');
 CL.AddDelphiFunction('Function CharDecomposeCanonicalStrW( const c : WideChar) : UnicodeString');
 //CL.AddDelphiFunction('Function CharDecomposeCompatibleW( const c : WideChar) : PCharDecompositionW');
 CL.AddDelphiFunction('Function CharDecomposeCompatibleStrW( const c : WideChar) : UnicodeString');
 CL.AddDelphiFunction('Function CharIn8( const c, t1, t2 : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function CharIn9( const c, t1, t2, t3 : WideChar) : Boolean;');
 CL.AddDelphiFunction('Procedure ConCatBuf( const Buffer : PChar; const CharCount : Cardinal; var d : string; var InUse : Cardinal)');
 CL.AddDelphiFunction('Procedure ConCatBufA( const Buffer : PChar; const AnsiCharCount : Cardinal; var d : RawByteString; var InUse : Cardinal)');
 //CL.AddDelphiFunction('Procedure ConCatBufW( const Buffer : PWideChar; const WideCharCount : Cardinal; var d : UnicodeString; var InUse : Cardinal)');
 CL.AddDelphiFunction('Procedure ConCatChar( const c : Char; var d : string; var InUse : Cardinal)');
 CL.AddDelphiFunction('Procedure ConCatCharA( const c : AnsiChar; var d : RawByteString; var InUse : Cardinal)');
// CL.AddDelphiFunction('Procedure ConCatCharW( const c : WideChar; var d : UnicodeString; var InUse : Cardinal)');
 CL.AddDelphiFunction('Procedure ConCatStr( const s : string; var d : string; var InUse : Cardinal)');
 CL.AddDelphiFunction('Procedure ConCatStrA( const s : RawByteString; var d : RawByteString; var InUse : Cardinal)');
 //CL.AddDelphiFunction('Procedure ConCatStrW( const w : UnicodeString; var d : UnicodeString; var InUse : Cardinal)');
 CL.AddDelphiFunction('Function diCountBitsSet( const Value : Integer) : Byte');
 //CL.AddDelphiFunction('Function Crc32OfStrA( const s : RawByteString) : TCrc32');
 //CL.AddDelphiFunction('Function Crc32OfStrW( const s : UnicodeString) : TCrc32');
 CL.AddDelphiFunction('Function CurrentDay : Word');
 CL.AddDelphiFunction('Function CurrentJulianDate : TJulianDate');
 CL.AddDelphiFunction('Function CurrentMonth : Word');
 CL.AddDelphiFunction('Function CurrentQuarter : Word');
 CL.AddDelphiFunction('Function diCurrentYear : Integer');
 CL.AddDelphiFunction('Function DarkenColor( const Color : Integer; const amount : Byte) : Integer');
 CL.AddDelphiFunction('Function diDeleteFile( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function DeleteFileA( const FileName : AnsiString) : Boolean');
 //CL.AddDelphiFunction('Function DeleteFileW( const FileName : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function diDirectoryExists( const Dir : string) : Boolean');
 CL.AddDelphiFunction('Function DirectoryExistsA( const Dir : AnsiString) : Boolean');
 //CL.AddDelphiFunction('Function DirectoryExistsW( const Dir : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function diDiskFree( const Dir : string) : Int64');
 CL.AddDelphiFunction('Function DiskFreeA( const Dir : AnsiString) : Int64');
 //CL.AddDelphiFunction('Function DiskFreeW( const Dir : UnicodeString) : Int64');
 CL.AddDelphiFunction('Function diExpandFileName( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExpandFileNameA(const FileName: AnsiString): AnsiString');
 //CL.AddDelphiFunction('Function ExpandFileNameW( const FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Procedure diExcludeTrailingPathDelimiter( var s : string)');
 CL.AddDelphiFunction('Procedure ExcludeTrailingPathDelimiterA( var s : RawByteString)');
 //CL.AddDelphiFunction('Procedure ExcludeTrailingPathDelimiterW( var s : UnicodeString)');
 CL.AddDelphiFunction('Function diExtractFileDrive( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileDriveA( const FileName : RawByteString) : RawByteString');
 //CL.AddDelphiFunction('Function ExtractFileDriveW( const FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function diExtractFileExt( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileExtA( const FileName : RawByteString) : RawByteString');
 //CL.AddDelphiFunction('Function ExtractFileExtW( const FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function diExtractFileName( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileNameA(const FileName: AnsiString): AnsiString');
 //CL.AddDelphiFunction('Function ExtractFileNameW( const FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function diExtractFilePath( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFilePathA( const FileName : RawByteString) : RawByteString');
 //CL.AddDelphiFunction('Function ExtractFilePathW( const FileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function ExtractNextWord10( const s : string; const ADelimiter : Char; var AStartIndex : Integer) : string;');
 CL.AddDelphiFunction('Function ExtractNextWordA11( const s : RawByteString; const ADelimiter : AnsiChar; var AStartIndex : Integer) : RawByteString;');
 CL.AddDelphiFunction('Function ExtractNextWordW12( const s : UnicodeString; const ADelimiter : WideChar; var AStartIndex : Integer) : UnicodeString;');
 CL.AddDelphiFunction('Function ExtractNextWord13( const s : string; const ADelimiters : TAnsiCharSet; var AStartIndex : Integer) : string;');
 CL.AddDelphiFunction('Function ExtractNextWordA14( const s : RawByteString; const ADelimiters : TAnsiCharSet; var AStartIndex : Integer) : RawByteString;');
 //CL.AddDelphiFunction('Function ExtractNextWordW15( const s : UnicodeString; const ADelimiters : TValidateCharFuncW; var AStartIndex : Integer) : UnicodeString;');
 CL.AddDelphiFunction('Function diExtractWord( const Number : Cardinal; const s : RawByteString; const Delimiters : TAnsiCharSet) : RawByteString');
 CL.AddDelphiFunction('Function ExtractWordA( const Number : Cardinal; const s : RawByteString; const Delimiters : TAnsiCharSet) : RawByteString');
 CL.AddDelphiFunction('Function ExtractWordStartsA( const s : RawByteString; const MaxCharCount : Cardinal; const WordSeparators : TAnsiCharSet) : RawByteString');
 //CL.AddDelphiFunction('Function ExtractWordStartsW( const s : UnicodeString; const MaxCharCount : Cardinal; const IsWordSep : TValidateCharFuncW) : UnicodeString');
 CL.AddDelphiFunction('Function diFileExists( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function FileExistsA( const FileName : AnsiString) : Boolean');
 //CL.AddDelphiFunction('Function FileExistsW( const FileName : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function diGCD( x, y : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function diGetTempFolder : string');
 CL.AddDelphiFunction('Function GetTempFolderA : AnsiString');
 //CL.AddDelphiFunction('Function GetTempFolderW : UnicodeString');
 CL.AddDelphiFunction('Function diGetUserName( out UserName : string) : Boolean');
 CL.AddDelphiFunction('Function GetUserNameA( out UserName : AnsiString) : Boolean');
 //CL.AddDelphiFunction('Function GetUserNameW( out UserName : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function HexCodePointToInt( const c : Cardinal) : Integer');
 CL.AddDelphiFunction('Function diHexToInt( const s : string) : Integer');
 CL.AddDelphiFunction('Function HexToIntA( const s : RawByteString) : Integer');
 //CL.AddDelphiFunction('Function HexToIntW( const s : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function BufHexToInt( p : PChar; l : Cardinal) : Integer');
 CL.AddDelphiFunction('Function BufHexToIntA( p : PChar; l : Cardinal) : Integer');
 //CL.AddDelphiFunction('Function BufHexToIntW( p : PWideChar; l : Cardinal) : Integer');
 CL.AddDelphiFunction('Procedure IncludeTrailingPathDelimiterByRef( var s : string)');
 CL.AddDelphiFunction('Procedure IncludeTrailingPathDelimiterByRefA(var s:RawByteString)');
 //CL.AddDelphiFunction('Procedure IncludeTrailingPathDelimiterByRefW(var w:UnicodeString)');
 CL.AddDelphiFunction('Function IntToHex16( const Value : Integer; const Digits : NativeInt) : string;');
 CL.AddDelphiFunction('Function IntToHex17( const Value : Int64; const Digits : NativeInt) : string;');
 CL.AddDelphiFunction('Function IntToHex18( const Value : UInt64; const Digits : NativeInt) : string;');
 CL.AddDelphiFunction('Function IntToHexA( Value : UInt64; const Digits : NativeInt) : RawByteString');
 //CL.AddDelphiFunction('Function IntToHexW( Value : UInt64; const Digits : NativeInt) : UnicodeString');
 CL.AddDelphiFunction('Function IntToStrA19( const i : Integer) : RawByteString;');
 CL.AddDelphiFunction('Function IntToStrW20( const i : Integer) : UnicodeString;');
 CL.AddDelphiFunction('Function IntToStrA21( const i : Int64) : RawByteString;');
 CL.AddDelphiFunction('Function IntToStrW22( const i : Int64) : UnicodeString;');
 CL.AddDelphiFunction('Function CharDecomposeHangulW(const c: WideChar) : UnicodeString');
 CL.AddDelphiFunction('Function diIsPathDelimiter( const s : string; const Index : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function IsPathDelimiterA( const s : RawByteString; const Index : Cardinal) : Boolean');
 //CL.AddDelphiFunction('Function IsPathDelimiterW( const s : UnicodeString; const Index : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function IsPointInRect( const Point : TPoint; const Rect : TRect) : Boolean');
 CL.AddDelphiFunction('Function JulianDateToIsoDateStr(const Julian: TJulianDate):string');
 CL.AddDelphiFunction('Function JulianDateToIsoDateStrA( const Julian : TJulianDate) : RawByteString');
 //CL.AddDelphiFunction('Function JulianDateToIsoDateStrW( const Julian : TJulianDate) : UnicodeString');
 CL.AddDelphiFunction('Function LeftMostBit( Value : Cardinal) : ShortInt;');
 CL.AddDelphiFunction('Function LeftMostBit2( Value : UInt64) : ShortInt;');
 //CL.AddDelphiFunction('Function MakeMethod( const AData, ACode : Pointer) : TMethod');
 CL.AddDelphiFunction('Function StrIsEmpty( const s : string) : Boolean');
 CL.AddDelphiFunction('Function StrIsEmptyA( const s : RawByteString) : Boolean');
 //CL.AddDelphiFunction('Function StrIsEmptyW( const s : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function PadLeftA( const Source : RawByteString; const Count : Cardinal; const c : AnsiChar) : RawByteString');
 //CL.AddDelphiFunction('Function PadLeftW( const Source : UnicodeString; const Count : Cardinal; const c : WideChar) : UnicodeString');
 CL.AddDelphiFunction('Function PadRightA( const Source : RawByteString; const Count : Cardinal; const c : AnsiChar) : RawByteString');
 //CL.AddDelphiFunction('Function PadRightW( const Source : UnicodeString; const Count : Cardinal; const c : WideChar) : UnicodeString');
 CL.AddDelphiFunction('Function ProperCase( const s : string) : string');
 CL.AddDelphiFunction('Function ProperCaseA( const s : RawByteString) : RawByteString');
 //CL.AddDelphiFunction('Function ProperCaseW( const s : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Procedure ProperCaseByRefA( var s : RawByteString)');
 //CL.AddDelphiFunction('Procedure ProperCaseByRefW( var s : UnicodeString)');
 CL.AddDelphiFunction('Function RegReadRegisteredOrganization( const Access : REGSAM) : string');
 CL.AddDelphiFunction('Function RegReadRegisteredOrganizationA( const Access : REGSAM) : AnsiString');
 //CL.AddDelphiFunction('Function RegReadRegisteredOrganizationW( const Access : REGSAM) : UnicodeString');
 CL.AddDelphiFunction('Function RegReadRegisteredOwner( const Access : REGSAM) : string');
 CL.AddDelphiFunction('Function RegReadRegisteredOwnerA( const Access : REGSAM) : AnsiString');
 //CL.AddDelphiFunction('Function RegReadRegisteredOwnerW( const Access : REGSAM) : UnicodeString');
 CL.AddDelphiFunction('Function RegReadStrDef( const Key : HKEY; const SubKey : string; const ValueName : string; const Default : string; const Access : REGSAM) : string');
 CL.AddDelphiFunction('Function RegReadStrDefA( const Key : HKEY; const SubKey : AnsiString; const ValueName : AnsiString; const Default : AnsiString; const Access : REGSAM) : AnsiString');
 //CL.AddDelphiFunction('Function RegReadStrDefW( const Key : HKEY; const SubKey : UnicodeString; const ValueName : UnicodeString; const Default : UnicodeString; const Access : REGSAM) : UnicodeString');
 CL.AddDelphiFunction('Function StrDecodeUrlA( const Value : RawByteString) : RawByteString');
 CL.AddDelphiFunction('Function StrEncodeUrlA( const Value : RawByteString) : RawByteString');
 CL.AddDelphiFunction('Function diStrEnd( const s : PChar) : PChar');
 CL.AddDelphiFunction('Function StrEndA( const s : PChar) : PChar');
 //CL.AddDelphiFunction('Function StrEndW( const s : PWideChar) : PWideChar');
 CL.AddDelphiFunction('Procedure StrIncludeTrailingChar( var s : string; const c : Char)');
 CL.AddDelphiFunction('Procedure StrIncludeTrailingCharA( var s : RawByteString; const c : AnsiChar)');
 //CL.AddDelphiFunction('Procedure StrIncludeTrailingCharW( var s : UnicodeString; const c : WideChar)');
 CL.AddDelphiFunction('Function diStrLen( const s : PChar) : NativeUInt');
 CL.AddDelphiFunction('Function StrLenA( const s : PChar) : NativeUInt');
 //CL.AddDelphiFunction('Function StrLenW( const s : PWideChar) : NativeUInt');
 CL.AddDelphiFunction('Function StrRandom( const ASeed : RawByteString; const ACharacters : string; const ALength : Cardinal) : string');
 CL.AddDelphiFunction('Function StrRandomA( const ASeed : RawByteString; const ACharacters : RawByteString; const ALength : Cardinal) : RawByteString');
 //CL.AddDelphiFunction('Function StrRandomW( const ASeed : RawByteString; const ACharacters : UnicodeString; const ALength : Cardinal) : UnicodeString');
 CL.AddDelphiFunction('Procedure StrRemoveFromToIA( var Source : RawByteString; const FromString, ToString : RawByteString)');
 //CL.AddDelphiFunction('Procedure StrRemoveFromToIW( var Source : UnicodeString; const FromString, ToString : UnicodeString)');
 CL.AddDelphiFunction('Procedure StrRemoveSpacingA( var s : RawByteString; const SpaceChars : TAnsiCharSet; const ReplaceChar : AnsiChar)');
 //CL.AddDelphiFunction('Procedure StrRemoveSpacingW( var w : UnicodeString; IsSpaceChar : TValidateCharFuncW; const ReplaceChar : WideChar)');
 CL.AddDelphiFunction('Procedure diStrReplaceChar( var Source : string; const SearchChar, ReplaceChar : Char)');
 CL.AddDelphiFunction('Procedure StrReplaceChar8( var s : Utf8String; const SearchChar, ReplaceChar : AnsiChar)');
 CL.AddDelphiFunction('Procedure StrReplaceCharA( var s : RawByteString; const SearchChar, ReplaceChar : AnsiChar)');
 //CL.AddDelphiFunction('Procedure StrReplaceCharW( var s : UnicodeString; const SearchChar, ReplaceChar : WideChar)');
 CL.AddDelphiFunction('Function diStrReplace( const Source, Search, Replace : string) : string');
 CL.AddDelphiFunction('Function StrReplaceA( const Source, Search, Replace : RawByteString) : RawByteString');
 //CL.AddDelphiFunction('Function StrReplaceW( const Source, Search, Replace : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function StrReplaceI( const Source, Search, Replace : string) : string');
 CL.AddDelphiFunction('Function StrReplaceIA( const Source, Search, Replace : RawByteString) : RawByteString');
 //CL.AddDelphiFunction('Function StrReplaceIW( const Source, Search, Replace : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function StrReplaceLoopA( const Source, Search, Replace : RawByteString) : RawByteString');
 //7CL.AddDelphiFunction('Function StrReplaceLoopW( const Source, Search, Replace : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function StrReplaceLoopIA( const Source, Search, Replace : RawByteString) : RawByteString');
 //CL.AddDelphiFunction('Function StrReplaceLoopIW( const Source, Search, Replace : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function RightMostBit( const Value : Cardinal) : ShortInt;');
 CL.AddDelphiFunction('Function RightMostBit2( const Value : UInt64) : ShortInt;');
 CL.AddDelphiFunction('Function LoadStrFromFile( const FileName : string; var s : RawByteString) : Boolean;');
 CL.AddDelphiFunction('Function FileToStr( const FileName : string; var s : String) : Boolean;');
 CL.AddDelphiFunction('Function LoadStrAFromFileA( const FileName : AnsiString; var s : RawByteString) : Boolean');
 //CL.AddDelphiFunction('Function LoadStrAFromFileW( const FileName : UnicodeString; var s : RawByteString) : Boolean');
 CL.AddDelphiFunction('Function LoadStrWFromFile28( const FileName : string; var s : UnicodeString) : Boolean;');
 CL.AddDelphiFunction('Function LoadStrWFromFileA( const FileName : AnsiString; var s : UnicodeString) : Boolean');
 //CL.AddDelphiFunction('Function LoadStrWFromFileW( const FileName : UnicodeString; var s : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function QuotedStrW( const s : UnicodeString; const Quote : WideChar) : UnicodeString');
 CL.AddDelphiFunction('Function SaveStrToFile( const s : string; const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function StrToFile( const s : string; const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function SaveStrAToFile( const s : RawByteString; const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function SaveStrAToFileA( const s : RawByteString; const FileName : AnsiString) : Boolean');
 //CL.AddDelphiFunction('Function SaveStrAToFileW( const s : RawByteString; const FileName : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function SaveStrWToFile( const s : UnicodeString; const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function SaveStrWToFileA( const s : UnicodeString; const FileName : AnsiString) : Boolean');
 //CL.AddDelphiFunction('Function SaveStrWToFileW( const s : UnicodeString; const FileName : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function StrPosChar( const Source : string; const c : Char; const Start : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosCharA( const Source : RawByteString; const c : AnsiChar; const Start : Cardinal) : Cardinal');
 //CL.AddDelphiFunction('Function StrPosCharW( const Source : UnicodeString; const c : WideChar; const Start : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosCharBack( const Source : string; const c : Char; const Start : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosCharBackA( const Source : RawByteString; const c : AnsiChar; const Start : Cardinal) : Cardinal');
 //CL.AddDelphiFunction('Function StrPosCharBackW( const Source : UnicodeString; const c : WideChar; const Start : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosCharsA( const Source : RawByteString; const Search : TAnsiCharSet; const Start : Cardinal) : Cardinal');
 //CL.AddDelphiFunction('Function StrPosCharsW( const Source : UnicodeString; const Validate : TValidateCharFuncW; const Start : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosCharsBackA( const Source : RawByteString; const Search : TAnsiCharSet; const Start : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosNotCharsA( const Source : RawByteString; const Search : TAnsiCharSet; const Start : Cardinal) : Cardinal');
 //CL.AddDelphiFunction('Function StrPosNotCharsW( const Source : UnicodeString; const Validate : TValidateCharFuncW; const Start : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosNotCharsBackA( const Source : RawByteString; const Search : TAnsiCharSet; const Start : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function SetFileDate( const FileHandle : THandle; const Year : Integer; const Month, Day : Word) : Boolean;');
 CL.AddDelphiFunction('Function SetFileDate2( const FileName : string; const JulianDate : TJulianDate) : Boolean;');
 CL.AddDelphiFunction('Function SetFileDateA( const FileName : AnsiString; const JulianDate : TJulianDate) : Boolean');
 //CL.AddDelphiFunction('Function SetFileDateW( const FileName : UnicodeString; const JulianDate : TJulianDate) : Boolean');
 CL.AddDelphiFunction('Function SetFileDateYmd( const FileName : string; const Year : Integer; const Month, Day : Word) : Boolean');
 CL.AddDelphiFunction('Function SetFileDateYmdA( const FileName : AnsiString; const Year : Integer; const Month, Day : Word) : Boolean');
 CL.AddDelphiFunction('Function SetFileDateYmdW( const FileName : UnicodeString; const Year : Integer; const Month, Day : Word) : Boolean');
 CL.AddDelphiFunction('Function StrContainsChar( const s : string; const c : Char; const Start : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrContainsCharA( const s : RawByteString; const c : AnsiChar; const Start : Cardinal) : Boolean');
 //CL.AddDelphiFunction('Function StrContainsCharW( const s : UnicodeString; const c : WideChar; const Start : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrContainsCharsA( const s : RawByteString; const Chars : TAnsiCharSet; const Start : Cardinal) : Boolean');
 //CL.AddDelphiFunction('Function StrHasCharsW( const w : UnicodeString; const Validate : TValidateCharFuncW; const Start : NativeUInt) : Boolean');
 //CL.AddDelphiFunction('Function StrConsistsOfW( const w : UnicodeString; const Validate : TValidateCharFuncW; const Start : NativeUInt) : Boolean');
 CL.AddDelphiFunction('Function diStrSame( const s1, s2 : string) : Boolean');
 CL.AddDelphiFunction('Function StrSameA( const s1, s2 : RawByteString) : Boolean');
 //CL.AddDelphiFunction('Function StrSameW( const s1, s2 : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function StrSameI( const s1, s2 : string) : Boolean');
 CL.AddDelphiFunction('Function StrSameIA( const s1, s2 : RawByteString) : Boolean');
 //CL.AddDelphiFunction('Function StrSameIW( const s1, s2 : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function StrSameStart( const s1, s2 : string) : Boolean');
 CL.AddDelphiFunction('Function StrSameStartA( const s1, s2 : RawByteString) : Boolean');
 //CL.AddDelphiFunction('Function StrSameStartW( const s1, s2 : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function StrSameStartI( const s1, s2 : string) : Boolean');
 CL.AddDelphiFunction('Function StrSameStartIA( const s1, s2 : RawByteString) : Boolean');
 //CL.AddDelphiFunction('Function StrSameStartIW( const s1, s2 : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function diStrComp( const s1, s2 : string) : Integer');
 CL.AddDelphiFunction('Function StrCompA( const s1, s2 : RawByteString) : Integer');
 //CL.AddDelphiFunction('Function StrCompW( const s1, s2 : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function StrCompI( const s1, s2 : string) : Integer');
 CL.AddDelphiFunction('Function StrCompIA( const s1, s2 : RawByteString) : Integer');
 //CL.AddDelphiFunction('Function StrCompIW( const s1, s2 : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function StrCompNum( const s1, s2 : string) : Integer');
 CL.AddDelphiFunction('Function StrCompNumA( const s1, s2 : RawByteString) : Integer');
// CL.AddDelphiFunction('Function StrCompNumW( const s1, s2 : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function StrCompNumI( const s1, s2 : string) : Integer');
 CL.AddDelphiFunction('Function StrCompNumIA( const s1, s2 : RawByteString) : Integer');
// CL.AddDelphiFunction('Function StrCompNumIW( const s1, s2 : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function StrContains( const Search, Source : string; const Start : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrContainsA( const Search, Source : RawByteString; const Start : Cardinal) : Boolean');
 //CL.AddDelphiFunction('Function StrContainsW( const ASearch, ASource : UnicodeString; const AStartPos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrContainsI( const Search, Source : string; const Start : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrContainsIA( const Search, Source : RawByteString; const Start : Cardinal) : Boolean');
 //CL.AddDelphiFunction('Function StrContainsIW( const ASearch, ASource : UnicodeString; const AStartPos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrCountChar( const ASource : string; const c : Char; const AStartIdx : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrCountCharA( const ASource : RawByteString; const c : AnsiChar; const AStartIdx : Cardinal) : Cardinal');
 //CL.AddDelphiFunction('Function StrCountCharW( const ASource : UnicodeString; const c : WideChar; const AStartIdx : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrMatchesA( const Search, Source : RawByteString; const AStartIdx : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrMatchesIA( const Search, Source : RawByteString; const AStartIdx : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrMatchWild( const Source, Mask : string; const WildChar : Char; const MaskChar : Char) : Boolean');
 CL.AddDelphiFunction('Function StrMatchWildA( const Source, Mask : RawByteString; const WildChar : AnsiChar; const MaskChar : AnsiChar) : Boolean');
 //CL.AddDelphiFunction('Function StrMatchWildW( const Source, Mask : UnicodeString; const WildChar : WideChar; const MaskChar : WideChar) : Boolean');
 CL.AddDelphiFunction('Function StrMatchWildI( const Source, Mask : string; const WildChar : Char; const MaskChar : Char) : Boolean');
 CL.AddDelphiFunction('Function StrMatchWildIA( const Source, Mask : RawByteString; const WildChar : AnsiChar; const MaskChar : AnsiChar) : Boolean');
 //CL.AddDelphiFunction('Function StrMatchWildIW( const Source, Mask : UnicodeString; const WildChar : WideChar; const MaskChar : WideChar) : Boolean');
 CL.AddDelphiFunction('Function diStrPos( const ASearch, ASource : string; const AStartPos : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosA( const ASearch, ASource : RawByteString; const AStartPos : Cardinal) : Cardinal');
 //CL.AddDelphiFunction('Function StrPosW( const ASearch, ASource : UnicodeString; const AStartPos : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosI( const ASearch, ASource : string; const AStartPos : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosIA( const ASearch, ASource : RawByteString; const AStartPos : Cardinal) : Cardinal');
 //CL.AddDelphiFunction('Function StrPosIW( const ASearch, ASource : UnicodeString; const AStartPos : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosBackA( const ASearch, ASource : RawByteString; AStart : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function StrPosBackIA( const ASearch, ASource : RawByteString; AStart : Cardinal) : Cardinal');
 //CL.AddDelphiFunction('Function StrToIntDefW( const w : UnicodeString; const Default : Integer) : Integer');
 CL.AddDelphiFunction('Function StrToInt64DefW( const w : UnicodeString; const Default : Int64) : Int64');
 CL.AddDelphiFunction('Function StrToUpper( const s : string) : string');
 CL.AddDelphiFunction('Function StrToUpperA( const s : RawByteString) : RawByteString');
 //CL.AddDelphiFunction('Function StrToUpperW( const s : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Procedure StrToUpperInPlace( var s : string)');
 CL.AddDelphiFunction('Procedure StrToUpperInPlaceA( var s : AnsiString)');
 //CL.AddDelphiFunction('Procedure StrToUpperInPlaceW31( var s : WideString);');
 //CL.AddDelphiFunction('Procedure StrToUpperInPlaceW32( var s : UnicodeString);');
 CL.AddDelphiFunction('Function StrToLower( const s : string) : string');
 CL.AddDelphiFunction('Function StrToLowerA( const s : RawByteString) : RawByteString');
 //CL.AddDelphiFunction('Function StrToLowerW( const s : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Procedure StrToLowerInPlace( var s : string)');
 CL.AddDelphiFunction('Procedure StrToLowerInPlaceA( var s : AnsiString)');
 //CL.AddDelphiFunction('Procedure StrToLowerInPlaceW33( var s : WideString);');
 //CL.AddDelphiFunction('Procedure StrToLowerInPlaceW34( var s : UnicodeString);');
 CL.AddDelphiFunction('Procedure StrTimUriFragmentA( var Value : RawByteString)');
 //CL.AddDelphiFunction('Procedure StrTrimUriFragmentW( var Value : UnicodeString)');
 //CL.AddDelphiFunction('Function StrExtractUriFragmentW( var Value : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function StrCountUtf8Chars(const AValue: Utf8String) : Cardinal');
 CL.AddDelphiFunction('Function StrDecodeUtf8( const AValue: Utf8String): UnicodeString');
 CL.AddDelphiFunction('Function StrEncodeUtf8( const AValue: UnicodeString): Utf8String');
 CL.AddDelphiFunction('Function diSysErrorMessage( const MessageID : Cardinal) : string');
 CL.AddDelphiFunction('Function SysErrorMessageA(const MessageID: Cardinal): AnsiString');
 //CL.AddDelphiFunction('Function SysErrorMessageW( const MessageID : Cardinal) : UnicodeString');
 CL.AddDelphiFunction('Function TextExtentW( const DC : HDC; const Text : UnicodeString) : TSize');
 CL.AddDelphiFunction('Function TextHeightW( const DC : HDC; const Text : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function TextWidthW( const DC : HDC; const Text : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function diStrTrim( const Source : string) : string');
 CL.AddDelphiFunction('Function StrTrimA( const Source : RawByteString) : RawByteString');
 //CL.AddDelphiFunction('Function StrTrimW( const w : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function StrTrimCharA( const Source : RawByteString; const CharToTrim : AnsiChar) : RawByteString');
 CL.AddDelphiFunction('Function StrTrimCharsA( const Source : RawByteString; const CharsToTrim : TAnsiCharSet) : RawByteString');
 //CL.AddDelphiFunction('Function StrTrimCharsW( const s : UnicodeString; const IsCharToTrim : TValidateCharFuncW) : UnicodeString');
 CL.AddDelphiFunction('Procedure TrimLeftByRefA( var s : RawByteString; const Chars : TAnsiCharSet)');
 CL.AddDelphiFunction('Function TrimRightA( const Source : RawByteString; const s : TAnsiCharSet) : RawByteString');
 CL.AddDelphiFunction('Procedure TrimRightByRefA( var Source : RawByteString; const s : TAnsiCharSet)');
 CL.AddDelphiFunction('Procedure StrTrimCompressA( var s : RawByteString; const TrimCompressChars : TAnsiCharSet; const ReplaceChar : AnsiChar)');
 //CL.AddDelphiFunction('Procedure StrTrimCompressW( var w : UnicodeString; Validate : TValidateCharFuncW; const ReplaceChar : WideChar)');
 //CL.AddDelphiFunction('Procedure TrimRightByRefW( var w : UnicodeString; Validate : TValidateCharFuncW)');
 CL.AddDelphiFunction('Function TryStrToIntW( const w : UnicodeString; out Value : Integer) : Boolean');
 CL.AddDelphiFunction('Function TryStrToInt64W( const w : UnicodeString; out Value : Int64) : Boolean');
 CL.AddDelphiFunction('Function ValInt( const p : PChar; const l : Integer; out Code : Integer) : Integer;');
 CL.AddDelphiFunction('Function ValIntA36( p : PChar; l : Integer; out Code : Integer) : Integer;');
 //CL.AddDelphiFunction('Function ValIntW37( p : PWideChar; l : Integer; out Code : Integer) : Integer;');
 CL.AddDelphiFunction('Function ValInt2(const s: string; out Code : Integer): Integer;');
 CL.AddDelphiFunction('Function ValIntA39( const s : RawByteString; out Code : Integer) : Integer;');
 CL.AddDelphiFunction('Function ValIntW40( const s : UnicodeString; out Code : Integer) : Integer;');
 CL.AddDelphiFunction('Function ValInt64A41( p : PChar; l : Integer; out Code : Integer) : Int64;');
 //CL.AddDelphiFunction('Function ValInt64W42( p : PWideChar; l : Integer; out Code : Integer) : Int64;');
 CL.AddDelphiFunction('Function ValInt64A43( const s : RawByteString; out Code : Integer) : Int64;');
 CL.AddDelphiFunction('Function ValInt64W44( const s : UnicodeString; out Code : Integer) : Int64;');
 CL.AddDelphiFunction('Function YmdToIsoDateStr( const Year : Integer; const Month : Word; const Day : Word) : string');
 CL.AddDelphiFunction('Function YmdToIsoDateStrA( const Year : Integer; const Month : Word; const Day : Word) : RawByteString');
 CL.AddDelphiFunction('Function YmdToIsoDateStrW( const Year : Integer; const Month : Word; const Day : Word) : UnicodeString');
 CL.AddDelphiFunction('Function CharIsLetterW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsLetterCommonW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsLetterUpperCaseW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsLetterLowerCaseW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsLetterTitleCaseW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsLetterModifierW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsLetterOtherW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsMarkW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsMarkNon_SpacingW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsMarkSpacing_CombinedW(const c: WideChar): Boolean');
 CL.AddDelphiFunction('Function CharIsMarkEnclosingW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsNumberW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsNumber_DecimalW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsNumber_LetterW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsNumber_OtherW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsPunctuationW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsPunctuation_ConnectorW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsPunctuation_DashW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsPunctuation_OpenW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsPunctuation_CloseW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsPunctuation_InitialQuoteW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsPunctuation_FinalQuoteW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsPunctuation_OtherW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsSymbolW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsSymbolMathW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsSymbolCurrencyW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsSymbolModifierW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsSymbolOtherW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsSeparatorW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsSeparatorSpaceW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsSeparatorLineW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsSeparatorParagraphW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsOtherW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsOtherControlW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsOtherFormatW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsOtherSurrogateW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsOtherPrivateUseW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function BitClear( const Bits, BitNo : Integer) : Integer');
 CL.AddDelphiFunction('Function BitSet( const Bits, BitIndex : Integer) : Integer');
 CL.AddDelphiFunction('Function BitSetTo( const Bits, BitIndex : Integer; const Value : Boolean) : Integer');
 CL.AddDelphiFunction('Function BitTest( const Bits, BitIndex : Integer) : Boolean');
 CL.AddDelphiFunction('Function CharCanonicalCombiningClassW( const Char : WideChar) : Cardinal');
 CL.AddDelphiFunction('Function CharIsAlphaW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsAlphaNumW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsCrLf( const c : Char) : Boolean');
 CL.AddDelphiFunction('Function CharIsCrLfA( const c : AnsiChar) : Boolean');
 //CL.AddDelphiFunction('Function CharIsCrLfW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function diCharIsDigit( const c : Char) : Boolean');
 CL.AddDelphiFunction('Function CharIsDigitA( const c : AnsiChar) : Boolean');
 //CL.AddDelphiFunction('Function CharIsDigitW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsHangulW( const Char : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsHexDigitW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsWhiteSpaceW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharToCaseFoldW( const Char : WideChar) : WideChar');
 CL.AddDelphiFunction('Function CharToLowerW( const Char : WideChar) : WideChar');
 CL.AddDelphiFunction('Function CharToUpperW( const Char : WideChar) : WideChar');
 CL.AddDelphiFunction('Function CharToTitleW( const Char : WideChar) : WideChar');
 CL.AddDelphiFunction('Function DayOfJulianDate( const JulianDate : TJulianDate) : Word');
 CL.AddDelphiFunction('Function diDayOfWeek( const JulianDate : TJulianDate) : Word');
 CL.AddDelphiFunction('Function DayOfWeekYmd( const Year : Integer; const Month, Day : Word) : Word');
 CL.AddDelphiFunction('Function diDaysInMonth( const JulianDate : TJulianDate) : Word');
 CL.AddDelphiFunction('Function DaysInMonthYm( const Year : Integer; const Month : Word) : Word');
 CL.AddDelphiFunction('Procedure DecDay( var Year : Integer; var Month, Day : Word)');
 CL.AddDelphiFunction('Procedure DecDays( var Year : Integer; var Month, Day : Word; const Days : Integer)');
 CL.AddDelphiFunction('Function diDeleteDirectory( const Dir : string; const DeleteItself : Boolean) : Boolean');
 CL.AddDelphiFunction('Function DeleteDirectoryA( Dir : AnsiString; const DeleteItself : Boolean) : Boolean');
 //CL.AddDelphiFunction('Function DeleteDirectoryW( Dir : UnicodeString; const DeleteItself : Boolean) : Boolean');
 CL.AddDelphiFunction('Function diEasterSunday( const Year : Integer) : TJulianDate');
 CL.AddDelphiFunction('Procedure EasterSundayYmd( const Year : Integer; out Month, Day : Word)');
 CL.AddDelphiFunction('Function diFirstDayOfWeek( const JulianDate : TJulianDate) : TJulianDate');
 CL.AddDelphiFunction('Procedure FirstDayOfWeekYmd( var Year : Integer; var Month, Day : Word)');
 CL.AddDelphiFunction('Function diFirstDayOfMonth( const Julian : TJulianDate) : TJulianDate');
 CL.AddDelphiFunction('Procedure FirstDayOfMonthYmd( const Year : Integer; const Month : Word; out Day : Word)');
 CL.AddDelphiFunction('Function diForceDirectories( const Dir : string) : Boolean');
 CL.AddDelphiFunction('Function ForceDirectoriesA( Dir : AnsiString) : Boolean');
 //CL.AddDelphiFunction('Function ForceDirectoriesW( Dir : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Procedure FreeMemAndNil( var Ptr: TObject)');
 CL.AddDelphiFunction('Function diGetCurrentFolder : string');
 CL.AddDelphiFunction('Function GetCurrentFolderA : AnsiString');
 //CL.AddDelphiFunction('Function GetCurrentFolderW : UnicodeString');
 CL.AddDelphiFunction('Procedure SetCurrentFolder( const NewFolder : string)');
 CL.AddDelphiFunction('Procedure SetCurrentFolderA( const NewFolder : AnsiString)');
 //CL.AddDelphiFunction('Procedure SetCurrentFolderW( const NewFolder : UnicodeString)');
 CL.AddDelphiFunction('Function diGetDesktopFolder : string');
 CL.AddDelphiFunction('Function GetDesktopFolderA : AnsiString');
 //CL.AddDelphiFunction('Function GetDesktopFolderW : UnicodeString');
 CL.AddDelphiFunction('Function diGetFileSize( const AFileName : string) : Int64');
 CL.AddDelphiFunction('Function GetFileSizeA( const AFileName : AnsiString) : Int64');
 //CL.AddDelphiFunction('Function GetFileSizeW( const AFileName : UnicodeString) : Int64');
 CL.AddDelphiFunction('Function diGetDesktopDirectoryFolder : string');
 CL.AddDelphiFunction('Function GetDesktopDirectoryFolderA : AnsiString');
 //CL.AddDelphiFunction('Function GetDesktopDirectoryFolderW : UnicodeString');
 CL.AddDelphiFunction('Function GetFileLastWriteTime( const FileName : string; out FileTime : TFileTime) : Boolean');
 CL.AddDelphiFunction('Function GetFileLastWriteTimeA( const FileName : AnsiString; out FileTime : TFileTime) : Boolean');
 //CL.AddDelphiFunction('Function GetFileLastWriteTimeW( const FileName : UnicodeString; out FileTime : TFileTime) : Boolean');
 CL.AddDelphiFunction('Function diGetPersonalFolder( const PersonalFolder : Integer) : string');
 CL.AddDelphiFunction('Function GetPersonalFolderA : AnsiString');
 //CL.AddDelphiFunction('Function GetPersonalFolderW : UnicodeString');
 CL.AddDelphiFunction('Function GetSpecialFolder( const SpecialFolder : Integer) : string');
 CL.AddDelphiFunction('Function GetSpecialFolderA( const SpecialFolder : Integer) : AnsiString');
 //CL.AddDelphiFunction('Function GetSpecialFolderW( const SpecialFolder : Integer) : UnicodeString');
 CL.AddDelphiFunction('Procedure diIncMonth( var Year : Integer; var Month, Day : Word)');
 CL.AddDelphiFunction('Procedure diIncMonths( var Year : Integer; var Month, Day : Word; const NumberOfMonths : Integer)');
 CL.AddDelphiFunction('Procedure diIncDay( var Year : Integer; var Month, Day : Word)');
 CL.AddDelphiFunction('Procedure IncDays( var Year : Integer; var Month, Day : Word; const Days : Integer)');
 CL.AddDelphiFunction('Function IsDateValid( const Year : Integer; const Month, Day : Word) : Boolean');
 CL.AddDelphiFunction('Function IsHolidayInGermany( const Julian : TJulianDate) : Boolean');
 CL.AddDelphiFunction('Function IsHolidayInGermanyYmd( const Year : Integer; const Month, Day : Word) : Boolean');
 CL.AddDelphiFunction('Function diIsLeapYear( const Year : Integer) : Boolean');
 CL.AddDelphiFunction('Function ISODateToJulianDate( const ISODate : TIsoDate) : TJulianDate');
 CL.AddDelphiFunction('Procedure ISODateToYmd( const ISODate : TIsoDate; out Year : Integer; out Month, Day : Word)');
 CL.AddDelphiFunction('Function IsCharLowLineW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function IsCharQuoteW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function IsShiftKeyDown : Boolean');
 CL.AddDelphiFunction('Function IsCharWhiteSpaceOrAmpersandW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function IsCharWhiteSpaceOrNoBreakSpaceW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function IsCharWhiteSpaceOrColonW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsWhiteSpaceGtW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsWhiteSpaceLtW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsWhiteSpaceHyphenW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function CharIsWhiteSpaceHyphenGtW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function IsCharWordSeparatorW( const c : WideChar) : Boolean');
 CL.AddDelphiFunction('Function diISOWeekNumber( const JulianDate : TJulianDate) : Word');
 CL.AddDelphiFunction('Function ISOWeekNumberYmd( const Year : Integer; const Month, Day : Word) : Word');
 CL.AddDelphiFunction('Function ISOWeekToJulianDate( const Year : Integer; const WeekOfYear : Word; const DayOfWeek : Word) : TJulianDate');
 CL.AddDelphiFunction('Function JulianDateIsWeekDay( const JulianDate : TJulianDate) : Boolean');
 CL.AddDelphiFunction('Function JulianDateToIsoDate( const Julian : TJulianDate) : TIsoDate');
 CL.AddDelphiFunction('Procedure JulianDateToYmd( const JulianDate : TJulianDate; out Year : Integer; out Month, Day : Word)');
 CL.AddDelphiFunction('Function LastDayOfMonth( const JulianDate : TJulianDate) : TJulianDate');
 CL.AddDelphiFunction('Procedure LastDayOfMonthYmd( const Year : Integer; const Month : Word; out Day : Word)');
 CL.AddDelphiFunction('Function LastDayOfWeek( const JulianDate : TJulianDate) : TJulianDate');
 CL.AddDelphiFunction('Procedure LastDayOfWeekYmd( var Year : Integer; var Month, Day : Word)');
 CL.AddDelphiFunction('Function LastSysErrorMessage : string');
 CL.AddDelphiFunction('Function LastSysErrorMessageA : AnsiString');
 CL.AddDelphiFunction('Function LastSysErrorMessageW : UnicodeString');
 CL.AddDelphiFunction('Function diMax( const a : Integer; const b : Integer) : Integer;');
 CL.AddDelphiFunction('Function diMax3( const a, b, c : Integer) : Integer');
 CL.AddDelphiFunction('Function MaxCard( const a : Cardinal; const b : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function MaxCard3( const a : Cardinal; const b : Cardinal; const c : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function diMaxint64( const a : Int64; const b : Int64) : Int64;');
 CL.AddDelphiFunction('Function dimaxint643( const a : Int64; const b : Int64; const c : Int64) : Int64;');
 CL.AddDelphiFunction('Function diMin( const a, b : Integer) : Integer;');
 CL.AddDelphiFunction('Function diMin3( const a, b, c : Integer) : Integer');
 CL.AddDelphiFunction('Function MinCard( const a, b : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function Mincard3( const a, b, c : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function diMinint64( const a, b : Int64) : Int64;');
 CL.AddDelphiFunction('Function diMinint643( const a, b, c : Int64) : Int64;');
 CL.AddDelphiFunction('Function diMinint64U( const a, b : UInt64) : UInt64;');
 CL.AddDelphiFunction('Function diMinint643U( const a, b, c : UInt64) : UInt64;');
 CL.AddDelphiFunction('Function MonthOfJulianDate( const JulianDate : TJulianDate) : Word');
 CL.AddDelphiFunction('Function YearOfJuilanDate( const JulianDate : TJulianDate) : Integer');
 CL.AddDelphiFunction('Function YmdToIsoDate( const Year : Integer; const Month, Day : Word) : TIsoDate');
 CL.AddDelphiFunction('Function YmdToJulianDate( const Year : Integer; const Month, Day : Word) : TJulianDate');
  //CL.AddTypeS('PDIDayTable', '^TDIDayTable // will not work');
  //CL.AddTypeS('PDIMonthTable', '^TDIMonthTable // will not work');
  //CL.AddTypeS('PDIQuarterTable', '^TDIQuarterTable // will not work');
 CL.AddConstantN('ISO_MONDAY','LongInt').SetInt( 0);
 CL.AddConstantN('ISO_TUESDAY','LongInt').SetInt( 1);
 CL.AddConstantN('ISO_WEDNESDAY','LongInt').SetInt( 2);
 CL.AddConstantN('ISO_THURSDAY','LongInt').SetInt( 3);
 CL.AddConstantN('ISO_FRIDAY','LongInt').SetInt( 4);
 CL.AddConstantN('ISO_SATURDAY','LongInt').SetInt( 5);
 CL.AddConstantN('ISO_SUNDAY','LongInt').SetInt( 6);
 CL.AddConstantN('CRC_32_INIT','LongWord').SetUInt( $FFFFFFFF);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function Min56_P( const a, b, c : UInt64) : UInt64;
Begin Result := DIUtils.Min(a, b, c);
END;

(*----------------------------------------------------------------------------*)
Function Min55_P( const a, b : UInt64) : UInt64;
Begin Result := DIUtils.Min(a, b); END;

(*----------------------------------------------------------------------------*)
Function Min54_P( const a, b, c : Int64) : Int64;
Begin Result := DIUtils.Min(a, b, c);
END;

(*----------------------------------------------------------------------------*)
Function Min53_P( const a, b : Int64) : Int64;
Begin Result := DIUtils.Min(a, b); END;

(*----------------------------------------------------------------------------*)
Function Min52_P( const a, b, c : Cardinal) : Cardinal;
Begin Result := DIUtils.Min(a, b, c);
END;

(*----------------------------------------------------------------------------*)
Function Min51_P( const a, b : Cardinal) : Cardinal;
Begin Result := DIUtils.Min(a, b); END;

(*----------------------------------------------------------------------------*)
Function Min50_P( const a, b : Integer) : Integer;
Begin Result := DIUtils.Min(a, b); END;

(*----------------------------------------------------------------------------*)
Function Max49_P( const a : Int64; const b : Int64; const c : Int64) : Int64;
Begin Result := DIUtils.Max(a, b, c);
END;

(*----------------------------------------------------------------------------*)
Function Max48_P( const a : Int64; const b : Int64) : Int64;
Begin Result := DIUtils.Max(a, b); END;

(*----------------------------------------------------------------------------*)
Function Max47_P( const a : Cardinal; const b : Cardinal; const c : Cardinal) : Cardinal;
Begin Result := DIUtils.Max(a, b, c);
END;

(*----------------------------------------------------------------------------*)
Function Max46_P( const a : Cardinal; const b : Cardinal) : Cardinal;
Begin Result := DIUtils.Max(a, b); END;

(*----------------------------------------------------------------------------*)
Function Max45_P( const a : Integer; const b : Integer) : Integer;
Begin Result := DIUtils.Max(a, b); END;

(*----------------------------------------------------------------------------*)
Function ValInt64W44_P( const s : UnicodeString; out Code : Integer) : Int64;
Begin Result := DIUtils.ValInt64W(s, Code);
END;

(*----------------------------------------------------------------------------*)
Function ValInt64A43_P( const s : RawByteString; out Code : Integer) : Int64;
Begin Result := DIUtils.ValInt64A(s, Code);
END;

(*----------------------------------------------------------------------------*)
Function ValInt64W42_P( p : PWideChar; l : Integer; out Code : Integer) : Int64;
Begin Result := DIUtils.ValInt64W(p, l, Code);
END;

(*----------------------------------------------------------------------------*)
Function ValInt64A41_P( p : PAnsiChar; l : Integer; out Code : Integer) : Int64;
Begin Result := DIUtils.ValInt64A(p, l, Code);
END;

(*----------------------------------------------------------------------------*)
Function ValIntW40_P( const s : UnicodeString; out Code : Integer) : Integer;
Begin Result := DIUtils.ValIntW(s, Code);
END;

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
 S.RegisterDelphiFunction(@BSwap4_P, 'BSwap4', cdRegister);
 S.RegisterDelphiFunction(@BSwap5_P, 'BSwap5', cdRegister);
 {S.RegisterDelphiFunction(@BufCompNumIW, 'BufCompNumIW', cdRegister);
 S.RegisterDelphiFunction(@BufCountUtf8Chars, 'BufCountUtf8Chars', cdRegister);
 S.RegisterDelphiFunction(@BufDecodeUtf8, 'BufDecodeUtf8', cdRegister);
 S.RegisterDelphiFunction(@BufEncodeUtf8, 'BufEncodeUtf8', cdRegister);
 S.RegisterDelphiFunction(@BufIsCharsW6_P, 'BufIsCharsW6', cdRegister);
 S.RegisterDelphiFunction(@BufIsCharsW7_P, 'BufIsCharsW7', cdRegister);}
 //S.RegisterDelphiFunction(@BufHasCharsW, 'BufHasCharsW', cdRegister);
 //S.RegisterDelphiFunction(@BufPosA, 'BufPosA', cdRegister);
 //S.RegisterDelphiFunction(@BufPosW, 'BufPosW', cdRegister);
 //S.RegisterDelphiFunction(@BufPosIA, 'BufPosIA', cdRegister);
 //S.RegisterDelphiFunction(@BufPosIW, 'BufPosIW', cdRegister);
 S.RegisterDelphiFunction(@BufSameA, 'BufSameA', cdRegister);
 //S.RegisterDelphiFunction(@BufSameW, 'BufSameW', cdRegister);
 S.RegisterDelphiFunction(@BufSameIA, 'BufSameIA', cdRegister);
 //S.RegisterDelphiFunction(@BufSameIW, 'BufSameIW', cdRegister);
 S.RegisterDelphiFunction(@BufPosCharA, 'BufPosCharA', cdRegister);
 S.RegisterDelphiFunction(@BufPosCharsA, 'BufPosCharsA', cdRegister);
 //S.RegisterDelphiFunction(@BufPosCharsW, 'BufPosCharsW', cdRegister);
 S.RegisterDelphiFunction(@BufStrSame, 'BufStrSame', cdRegister);
 S.RegisterDelphiFunction(@BufStrSameA, 'BufStrSameA', cdRegister);
 //S.RegisterDelphiFunction(@BufStrSameW, 'BufStrSameW', cdRegister);
 S.RegisterDelphiFunction(@BufStrSameI, 'BufStrSameI', cdRegister);
 S.RegisterDelphiFunction(@BufStrSameIA, 'BufStrSameIA', cdRegister);
 S.RegisterDelphiFunction(@BufStrSameIW, 'BufStrSameIW', cdRegister);
 S.RegisterDelphiFunction(@ChangeFileExt, 'diChangeFileExt', cdRegister);
 S.RegisterDelphiFunction(@ChangeFileExtA, 'ChangeFileExtA', cdRegister);
 //S.RegisterDelphiFunction(@ChangeFileExtW, 'ChangeFileExtW', cdRegister);
 //S.RegisterDelphiFunction(@CharDecomposeCanonicalW, 'CharDecomposeCanonicalW', cdRegister);
 S.RegisterDelphiFunction(@CharDecomposeCanonicalStrW, 'CharDecomposeCanonicalStrW', cdRegister);
 //S.RegisterDelphiFunction(@CharDecomposeCompatibleW,'CharDecomposeCompatibleW',cdRegister);
 S.RegisterDelphiFunction(@CharDecomposeCompatibleStrW, 'CharDecomposeCompatibleStrW', cdRegister);
 S.RegisterDelphiFunction(@CharIn8_P, 'CharIn8', cdRegister);
 S.RegisterDelphiFunction(@CharIn9_P, 'CharIn9', cdRegister);
 S.RegisterDelphiFunction(@ConCatBuf, 'ConCatBuf', cdRegister);
 S.RegisterDelphiFunction(@ConCatBufA, 'ConCatBufA', cdRegister);
 //S.RegisterDelphiFunction(@ConCatBufW, 'ConCatBufW', cdRegister);
 S.RegisterDelphiFunction(@ConCatChar, 'ConCatChar', cdRegister);
 S.RegisterDelphiFunction(@ConCatCharA, 'ConCatCharA', cdRegister);
 //S.RegisterDelphiFunction(@ConCatCharW, 'ConCatCharW', cdRegister);
 S.RegisterDelphiFunction(@ConCatStr, 'ConCatStr', cdRegister);
 S.RegisterDelphiFunction(@ConCatStrA, 'ConCatStrA', cdRegister);
 //S.RegisterDelphiFunction(@ConCatStrW, 'ConCatStrW', cdRegister);
 S.RegisterDelphiFunction(@CountBitsSet, 'diCountBitsSet', cdRegister);
 //S.RegisterDelphiFunction(@Crc32OfStrA, 'Crc32OfStrA', cdRegister);
 //S.RegisterDelphiFunction(@Crc32OfStrW, 'Crc32OfStrW', cdRegister);
 S.RegisterDelphiFunction(@CurrentDay, 'CurrentDay', cdRegister);
 S.RegisterDelphiFunction(@CurrentJulianDate, 'CurrentJulianDate', cdRegister);
 S.RegisterDelphiFunction(@CurrentMonth, 'CurrentMonth', cdRegister);
 S.RegisterDelphiFunction(@CurrentQuarter, 'CurrentQuarter', cdRegister);
 S.RegisterDelphiFunction(@CurrentYear, 'diCurrentYear', cdRegister);
 S.RegisterDelphiFunction(@DarkenColor, 'DarkenColor', cdRegister);
 S.RegisterDelphiFunction(@DeleteFile, 'diDeleteFile', cdRegister);
 S.RegisterDelphiFunction(@DeleteFileA, 'DeleteFileA', cdRegister);
 //S.RegisterDelphiFunction(@DeleteFileW, 'DeleteFileW', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'diDirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExistsA, 'DirectoryExistsA', cdRegister);
 //S.RegisterDelphiFunction(@DirectoryExistsW, 'DirectoryExistsW', cdRegister);
 S.RegisterDelphiFunction(@DiskFree, 'diDiskFree', cdRegister);
 //S.RegisterDelphiFunction(@DiskFreeA_P, 'DiskFreeA', cdRegister);
 //S.RegisterDelphiFunction(@DiskFreeW, 'DiskFreeW', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileName, 'diExpandFileName', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileNameA, 'ExpandFileNameA', cdRegister);
 //S.RegisterDelphiFunction(@ExpandFileNameW, 'ExpandFileNameW', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiter, 'diExcludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiterA, 'ExcludeTrailingPathDelimiterA', cdRegister);
 //S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiterW, 'ExcludeTrailingPathDelimiterW', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDrive, 'diExtractFileDrive', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDriveA, 'ExtractFileDriveA', cdRegister);
 //S.RegisterDelphiFunction(@ExtractFileDriveW, 'ExtractFileDriveW', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExt, 'diExtractFileExt', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExtA, 'ExtractFileExtA', cdRegister);
 //S.RegisterDelphiFunction(@ExtractFileExtW, 'ExtractFileExtW', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileName, 'diExtractFileName', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileNameA, 'ExtractFileNameA', cdRegister);
 //S.RegisterDelphiFunction(@ExtractFileNameW, 'ExtractFileNameW', cdRegister);
 S.RegisterDelphiFunction(@ExtractFilePath, 'diExtractFilePath', cdRegister);
 S.RegisterDelphiFunction(@ExtractFilePathA, 'ExtractFilePathA', cdRegister);
 //S.RegisterDelphiFunction(@ExtractFilePathW, 'ExtractFilePathW', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWord10_P, 'ExtractNextWord10', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWordA11_P, 'ExtractNextWordA11', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWordW12_P, 'ExtractNextWordW12', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWord13_P, 'ExtractNextWord13', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWordA14_P, 'ExtractNextWordA14', cdRegister);
 S.RegisterDelphiFunction(@ExtractNextWordW15_P, 'ExtractNextWordW15', cdRegister);
 S.RegisterDelphiFunction(@ExtractWordA, 'ExtractWordA', cdRegister);
 S.RegisterDelphiFunction(@ExtractWordA, 'diExtractWord', cdRegister);
 S.RegisterDelphiFunction(@ExtractWordStartsA, 'ExtractWordStartsA', cdRegister);
 //S.RegisterDelphiFunction(@ExtractWordStartsW, 'ExtractWordStartsW', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'diFileExists', cdRegister);
 S.RegisterDelphiFunction(@FileExistsA, 'FileExistsA', cdRegister);
 //S.RegisterDelphiFunction(@FileExistsW, 'FileExistsW', cdRegister);
 S.RegisterDelphiFunction(@GCD, 'GCD', cdRegister);
 S.RegisterDelphiFunction(@GetTempFolder, 'diGetTempFolder', cdRegister);
 S.RegisterDelphiFunction(@GetTempFolderA, 'GetTempFolderA', cdRegister);
 //S.RegisterDelphiFunction(@GetTempFolderW, 'GetTempFolderW', cdRegister);
 S.RegisterDelphiFunction(@GetUserName, 'diGetUserName', cdRegister);
 S.RegisterDelphiFunction(@GetUserNameA, 'GetUserNameA', cdRegister);
 S.RegisterDelphiFunction(@GetUserNameW, 'GetUserNameW', cdRegister);
 S.RegisterDelphiFunction(@HexCodePointToInt, 'HexCodePointToInt', cdRegister);
 S.RegisterDelphiFunction(@HexToInt, 'diHexToInt', cdRegister);
 S.RegisterDelphiFunction(@HexToIntA, 'HexToIntA', cdRegister);
 //S.RegisterDelphiFunction(@HexToIntW, 'HexToIntW', cdRegister);
 S.RegisterDelphiFunction(@BufHexToInt, 'BufHexToInt', cdRegister);
 S.RegisterDelphiFunction(@BufHexToIntA, 'BufHexToIntA', cdRegister);
 //S.RegisterDelphiFunction(@BufHexToIntW, 'BufHexToIntW', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiterByRef, 'IncludeTrailingPathDelimiterByRef', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiterByRefA, 'IncludeTrailingPathDelimiterByRefA', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiterByRefW, 'IncludeTrailingPathDelimiterByRefW', cdRegister);
 S.RegisterDelphiFunction(@IntToHex16_P, 'IntToHex16', cdRegister);
 S.RegisterDelphiFunction(@IntToHex17_P, 'IntToHex17', cdRegister);
 S.RegisterDelphiFunction(@IntToHex18_P, 'IntToHex18', cdRegister);
 S.RegisterDelphiFunction(@IntToHexA, 'IntToHexA', cdRegister);
 //S.RegisterDelphiFunction(@IntToHexW, 'IntToHexW', cdRegister);
 S.RegisterDelphiFunction(@IntToStrA19_P, 'IntToStrA19', cdRegister);
 S.RegisterDelphiFunction(@IntToStrW20_P, 'IntToStrW20', cdRegister);
 S.RegisterDelphiFunction(@IntToStrA21_P, 'IntToStrA21', cdRegister);
 S.RegisterDelphiFunction(@IntToStrW22_P, 'IntToStrW22', cdRegister);
 //S.RegisterDelphiFunction(@CharDecomposeHangulW, 'CharDecomposeHangulW', cdRegister);
 S.RegisterDelphiFunction(@IsPathDelimiter, 'diIsPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IsPathDelimiterA, 'IsPathDelimiterA', cdRegister);
 //S.RegisterDelphiFunction(@IsPathDelimiterW, 'IsPathDelimiterW', cdRegister);
 S.RegisterDelphiFunction(@IsPointInRect, 'IsPointInRect', cdRegister);
 S.RegisterDelphiFunction(@JulianDateToIsoDateStr, 'JulianDateToIsoDateStr', cdRegister);
 S.RegisterDelphiFunction(@JulianDateToIsoDateStrA, 'JulianDateToIsoDateStrA', cdRegister);
 //S.RegisterDelphiFunction(@JulianDateToIsoDateStrW, 'JulianDateToIsoDateStrW', cdRegister);
 S.RegisterDelphiFunction(@LeftMostBit23_P, 'LeftMostBit', cdRegister);
 S.RegisterDelphiFunction(@LeftMostBit24_P, 'LeftMostBit2', cdRegister);
 //S.RegisterDelphiFunction(@MakeMethod, 'MakeMethod', cdRegister);
 S.RegisterDelphiFunction(@StrIsEmpty, 'StrIsEmpty', cdRegister);
 S.RegisterDelphiFunction(@StrIsEmptyA, 'StrIsEmptyA', cdRegister);
 //S.RegisterDelphiFunction(@StrIsEmptyW, 'StrIsEmptyW', cdRegister);
 S.RegisterDelphiFunction(@PadLeftA, 'PadLeftA', cdRegister);
 //S.RegisterDelphiFunction(@PadLeftW, 'PadLeftW', cdRegister);
 S.RegisterDelphiFunction(@PadRightA, 'PadRightA', cdRegister);
 //S.RegisterDelphiFunction(@PadRightW, 'PadRightW', cdRegister);
 S.RegisterDelphiFunction(@ProperCase, 'ProperCase', cdRegister);
 S.RegisterDelphiFunction(@ProperCaseA, 'ProperCaseA', cdRegister);
 //S.RegisterDelphiFunction(@ProperCaseW, 'ProperCaseW', cdRegister);
 S.RegisterDelphiFunction(@ProperCaseByRefA, 'ProperCaseByRefA', cdRegister);
 //S.RegisterDelphiFunction(@ProperCaseByRefW, 'ProperCaseByRefW', cdRegister);
 S.RegisterDelphiFunction(@RegReadRegisteredOrganization, 'RegReadRegisteredOrganization', cdRegister);
 S.RegisterDelphiFunction(@RegReadRegisteredOrganizationA, 'RegReadRegisteredOrganizationA', cdRegister);
 //S.RegisterDelphiFunction(@RegReadRegisteredOrganizationW, 'RegReadRegisteredOrganizationW', cdRegister);
 S.RegisterDelphiFunction(@RegReadRegisteredOwner, 'RegReadRegisteredOwner', cdRegister);
 S.RegisterDelphiFunction(@RegReadRegisteredOwnerA, 'RegReadRegisteredOwnerA', cdRegister);
 //S.RegisterDelphiFunction(@RegReadRegisteredOwnerW, 'RegReadRegisteredOwnerW', cdRegister);
 S.RegisterDelphiFunction(@RegReadStrDef, 'RegReadStrDef', cdRegister);
 S.RegisterDelphiFunction(@RegReadStrDefA, 'RegReadStrDefA', cdRegister);
 //S.RegisterDelphiFunction(@RegReadStrDefW, 'RegReadStrDefW', cdRegister);
 S.RegisterDelphiFunction(@StrDecodeUrlA, 'StrDecodeUrlA', cdRegister);
 S.RegisterDelphiFunction(@StrEncodeUrlA, 'StrEncodeUrlA', cdRegister);
 S.RegisterDelphiFunction(@StrEnd, 'diStrEnd', cdRegister);
 S.RegisterDelphiFunction(@StrEndA, 'StrEndA', cdRegister);
 //S.RegisterDelphiFunction(@StrEndW, 'StrEndW', cdRegister);
 S.RegisterDelphiFunction(@StrIncludeTrailingChar, 'StrIncludeTrailingChar', cdRegister);
 S.RegisterDelphiFunction(@StrIncludeTrailingCharA, 'StrIncludeTrailingCharA', cdRegister);
 //S.RegisterDelphiFunction(@StrIncludeTrailingCharW, 'StrIncludeTrailingCharW', cdRegister);
 S.RegisterDelphiFunction(@StrLen, 'diStrLen', cdRegister);
 S.RegisterDelphiFunction(@StrLenA, 'StrLenA', cdRegister);
 //S.RegisterDelphiFunction(@StrLenW, 'StrLenW', cdRegister);
 S.RegisterDelphiFunction(@StrRandom, 'StrRandom', cdRegister);
 S.RegisterDelphiFunction(@StrRandomA, 'StrRandomA', cdRegister);
 //S.RegisterDelphiFunction(@StrRandomW, 'StrRandomW', cdRegister);
 S.RegisterDelphiFunction(@StrRemoveFromToIA, 'StrRemoveFromToIA', cdRegister);
 //S.RegisterDelphiFunction(@StrRemoveFromToIW, 'StrRemoveFromToIW', cdRegister);
 S.RegisterDelphiFunction(@StrRemoveSpacingA, 'StrRemoveSpacingA', cdRegister);
 //S.RegisterDelphiFunction(@StrRemoveSpacingW, 'StrRemoveSpacingW', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceChar, 'diStrReplaceChar', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceChar8, 'StrReplaceChar8', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceCharA, 'StrReplaceCharA', cdRegister);
 //S.RegisterDelphiFunction(@StrReplaceCharW, 'StrReplaceCharW', cdRegister);
 S.RegisterDelphiFunction(@StrReplace, 'diStrReplace', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceA, 'StrReplaceA', cdRegister);
 //S.RegisterDelphiFunction(@StrReplaceW, 'StrReplaceW', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceI, 'StrReplaceI', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceIA, 'StrReplaceIA', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceIW, 'StrReplaceIW', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceLoopA, 'StrReplaceLoopA', cdRegister);
 //S.RegisterDelphiFunction(@StrReplaceLoopW, 'StrReplaceLoopW', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceLoopIA, 'StrReplaceLoopIA', cdRegister);
 //S.RegisterDelphiFunction(@StrReplaceLoopIW, 'StrReplaceLoopIW', cdRegister);
 S.RegisterDelphiFunction(@RightMostBit25_P, 'RightMostBit', cdRegister);
 S.RegisterDelphiFunction(@RightMostBit26_P, 'RightMostBit2', cdRegister);
 S.RegisterDelphiFunction(@LoadStrAFromFile27_P, 'LoadStrFromFile', cdRegister);
 S.RegisterDelphiFunction(@LoadStrAFromFile27_P, 'FileToStr', cdRegister);
 S.RegisterDelphiFunction(@LoadStrAFromFileA, 'LoadStrAFromFileA', cdRegister);

 //S.RegisterDelphiFunction(@LoadStrAFromFileW, 'LoadStrAFromFileW', cdRegister);
 S.RegisterDelphiFunction(@LoadStrWFromFile28_P, 'LoadStrWFromFile28', cdRegister);
 S.RegisterDelphiFunction(@LoadStrWFromFileA, 'LoadStrWFromFileA', cdRegister);
 //S.RegisterDelphiFunction(@LoadStrWFromFileW, 'LoadStrWFromFileW', cdRegister);
 S.RegisterDelphiFunction(@QuotedStrW, 'QuotedStrW', cdRegister);
 S.RegisterDelphiFunction(@SaveStrToFile, 'SaveStrToFile', cdRegister);
 S.RegisterDelphiFunction(@SaveStrToFile, 'StrToFile', cdRegister);     //alias
 S.RegisterDelphiFunction(@SaveStrAToFile, 'SaveStrAToFile', cdRegister);
 S.RegisterDelphiFunction(@SaveStrAToFileA, 'SaveStrAToFileA', cdRegister);
 //S.RegisterDelphiFunction(@SaveStrAToFileW, 'SaveStrAToFileW', cdRegister);
 S.RegisterDelphiFunction(@SaveStrWToFile, 'SaveStrWToFile', cdRegister);
 S.RegisterDelphiFunction(@SaveStrWToFileA, 'SaveStrWToFileA', cdRegister);
 //S.RegisterDelphiFunction(@SaveStrWToFileW, 'SaveStrWToFileW', cdRegister);
 S.RegisterDelphiFunction(@StrPosChar, 'StrPosChar', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharA, 'StrPosCharA', cdRegister);
 //S.RegisterDelphiFunction(@StrPosCharW, 'StrPosCharW', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharBack, 'StrPosCharBack', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharBackA, 'StrPosCharBackA', cdRegister);
 //S.RegisterDelphiFunction(@StrPosCharBackW, 'StrPosCharBackW', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharsA, 'StrPosCharsA', cdRegister);
 //S.RegisterDelphiFunction(@StrPosCharsW, 'StrPosCharsW', cdRegister);
 S.RegisterDelphiFunction(@StrPosCharsBackA, 'StrPosCharsBackA', cdRegister);
 S.RegisterDelphiFunction(@StrPosNotCharsA, 'StrPosNotCharsA', cdRegister);
 //S.RegisterDelphiFunction(@StrPosNotCharsW, 'StrPosNotCharsW', cdRegister);
 S.RegisterDelphiFunction(@StrPosNotCharsBackA, 'StrPosNotCharsBackA', cdRegister);
 S.RegisterDelphiFunction(@SetFileDate29_P, 'SetFileDate', cdRegister);
 S.RegisterDelphiFunction(@SetFileDate30_P, 'SetFileDate2', cdRegister);
 S.RegisterDelphiFunction(@SetFileDateA, 'SetFileDateA', cdRegister);
 //S.RegisterDelphiFunction(@SetFileDateW, 'SetFileDateW', cdRegister);
 S.RegisterDelphiFunction(@SetFileDateYmd, 'SetFileDateYmd', cdRegister);
 S.RegisterDelphiFunction(@SetFileDateYmdA, 'SetFileDateYmdA', cdRegister);
 S.RegisterDelphiFunction(@SetFileDateYmdW, 'SetFileDateYmdW', cdRegister);
 S.RegisterDelphiFunction(@StrContainsChar, 'StrContainsChar', cdRegister);
 S.RegisterDelphiFunction(@StrContainsCharA, 'StrContainsCharA', cdRegister);
 //S.RegisterDelphiFunction(@StrContainsCharW, 'StrContainsCharW', cdRegister);
 S.RegisterDelphiFunction(@StrContainsCharsA, 'StrContainsCharsA', cdRegister);
 //S.RegisterDelphiFunction(@StrHasCharsW, 'StrHasCharsW', cdRegister);
 //S.RegisterDelphiFunction(@StrConsistsOfW, 'StrConsistsOfW', cdRegister);
 S.RegisterDelphiFunction(@StrSame, 'diStrSame', cdRegister);
 S.RegisterDelphiFunction(@StrSameA, 'StrSameA', cdRegister);
 //S.RegisterDelphiFunction(@StrSameW, 'StrSameW', cdRegister);
 S.RegisterDelphiFunction(@StrSameI, 'StrSameI', cdRegister);
 S.RegisterDelphiFunction(@StrSameIA, 'StrSameIA', cdRegister);
 //S.RegisterDelphiFunction(@StrSameIW, 'StrSameIW', cdRegister);
 S.RegisterDelphiFunction(@StrSameStart, 'StrSameStart', cdRegister);
 S.RegisterDelphiFunction(@StrSameStartA, 'StrSameStartA', cdRegister);
 //S.RegisterDelphiFunction(@StrSameStartW, 'StrSameStartW', cdRegister);
 S.RegisterDelphiFunction(@StrSameStartI, 'StrSameStartI', cdRegister);
 S.RegisterDelphiFunction(@StrSameStartIA, 'StrSameStartIA', cdRegister);
 //S.RegisterDelphiFunction(@StrSameStartIW, 'StrSameStartIW', cdRegister);
 S.RegisterDelphiFunction(@StrComp, 'diStrComp', cdRegister);
 S.RegisterDelphiFunction(@StrCompA, 'StrCompA', cdRegister);
 //S.RegisterDelphiFunction(@StrCompW, 'StrCompW', cdRegister);
 S.RegisterDelphiFunction(@StrCompI, 'StrCompI', cdRegister);
 S.RegisterDelphiFunction(@StrCompIA, 'StrCompIA', cdRegister);
 //S.RegisterDelphiFunction(@StrCompIW, 'StrCompIW', cdRegister);
 S.RegisterDelphiFunction(@StrCompNum, 'StrCompNum', cdRegister);
 S.RegisterDelphiFunction(@StrCompNumA, 'StrCompNumA', cdRegister);
 //S.RegisterDelphiFunction(@StrCompNumW, 'StrCompNumW', cdRegister);
 S.RegisterDelphiFunction(@StrCompNumI, 'StrCompNumI', cdRegister);
 S.RegisterDelphiFunction(@StrCompNumIA, 'StrCompNumIA', cdRegister);
 //S.RegisterDelphiFunction(@StrCompNumIW, 'StrCompNumIW', cdRegister);
 S.RegisterDelphiFunction(@StrContains, 'StrContains', cdRegister);
 S.RegisterDelphiFunction(@StrContainsA, 'StrContainsA', cdRegister);
 //S.RegisterDelphiFunction(@StrContainsW, 'StrContainsW', cdRegister);
 S.RegisterDelphiFunction(@StrContainsI, 'StrContainsI', cdRegister);
 S.RegisterDelphiFunction(@StrContainsIA, 'StrContainsIA', cdRegister);
 //S.RegisterDelphiFunction(@StrContainsIW, 'StrContainsIW', cdRegister);
 S.RegisterDelphiFunction(@StrCountChar, 'StrCountChar', cdRegister);
 S.RegisterDelphiFunction(@StrCountCharA, 'StrCountCharA', cdRegister);
 //S.RegisterDelphiFunction(@StrCountCharW, 'StrCountCharW', cdRegister);
 S.RegisterDelphiFunction(@StrMatchesA, 'StrMatchesA', cdRegister);
 S.RegisterDelphiFunction(@StrMatchesIA, 'StrMatchesIA', cdRegister);
 S.RegisterDelphiFunction(@StrMatchWild, 'StrMatchWild', cdRegister);
 S.RegisterDelphiFunction(@StrMatchWildA, 'StrMatchWildA', cdRegister);
 //S.RegisterDelphiFunction(@StrMatchWildW, 'StrMatchWildW', cdRegister);
 S.RegisterDelphiFunction(@StrMatchWildI, 'StrMatchWildI', cdRegister);
 S.RegisterDelphiFunction(@StrMatchWildIA, 'StrMatchWildIA', cdRegister);
 //S.RegisterDelphiFunction(@StrMatchWildIW, 'StrMatchWildIW', cdRegister);
 S.RegisterDelphiFunction(@StrPos, 'diStrPos', cdRegister);
 S.RegisterDelphiFunction(@StrPosA, 'StrPosA', cdRegister);
 //S.RegisterDelphiFunction(@StrPosW, 'StrPosW', cdRegister);
 S.RegisterDelphiFunction(@StrPosI, 'StrPosI', cdRegister);
 S.RegisterDelphiFunction(@StrPosIA, 'StrPosIA', cdRegister);
 //S.RegisterDelphiFunction(@StrPosIW, 'StrPosIW', cdRegister);
 S.RegisterDelphiFunction(@StrPosBackA, 'StrPosBackA', cdRegister);
 S.RegisterDelphiFunction(@StrPosBackIA, 'StrPosBackIA', cdRegister);
 //S.RegisterDelphiFunction(@StrToIntDefW, 'StrToIntDefW', cdRegister);
 S.RegisterDelphiFunction(@StrToInt64DefW, 'StrToInt64DefW', cdRegister);
 S.RegisterDelphiFunction(@StrToUpper, 'StrToUpper', cdRegister);
 S.RegisterDelphiFunction(@StrToUpperA, 'StrToUpperA', cdRegister);
 //S.RegisterDelphiFunction(@StrToUpperW, 'StrToUpperW', cdRegister);
 S.RegisterDelphiFunction(@StrToUpperInPlace, 'StrToUpperInPlace', cdRegister);
 S.RegisterDelphiFunction(@StrToUpperInPlaceA, 'StrToUpperInPlaceA', cdRegister);
 //S.RegisterDelphiFunction(@StrToUpperInPlaceW31_P, 'StrToUpperInPlaceW31', cdRegister);
 //S.RegisterDelphiFunction(@StrToUpperInPlaceW32_P, 'StrToUpperInPlaceW32', cdRegister);
 S.RegisterDelphiFunction(@StrToLower, 'StrToLower', cdRegister);
 S.RegisterDelphiFunction(@StrToLowerA, 'StrToLowerA', cdRegister);
 //S.RegisterDelphiFunction(@StrToLowerW, 'StrToLowerW', cdRegister);
 S.RegisterDelphiFunction(@StrToLowerInPlace, 'StrToLowerInPlace', cdRegister);
 S.RegisterDelphiFunction(@StrToLowerInPlaceA, 'StrToLowerInPlaceA', cdRegister);
 //S.RegisterDelphiFunction(@StrToLowerInPlaceW33_P, 'StrToLowerInPlaceW33', cdRegister);
 //S.RegisterDelphiFunction(@StrToLowerInPlaceW34_P, 'StrToLowerInPlaceW34', cdRegister);
 S.RegisterDelphiFunction(@StrTimUriFragmentA, 'StrTimUriFragmentA', cdRegister);
 //S.RegisterDelphiFunction(@StrTrimUriFragmentW, 'StrTrimUriFragmentW', cdRegister);
 //S.RegisterDelphiFunction(@StrExtractUriFragmentW, 'StrExtractUriFragmentW', cdRegister);
 S.RegisterDelphiFunction(@StrCountUtf8Chars, 'StrCountUtf8Chars', cdRegister);
 S.RegisterDelphiFunction(@StrDecodeUtf8, 'StrDecodeUtf8', cdRegister);
 S.RegisterDelphiFunction(@StrEncodeUtf8, 'StrEncodeUtf8', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessage, 'diSysErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessageA, 'SysErrorMessageA', cdRegister);
 //S.RegisterDelphiFunction(@SysErrorMessageW, 'SysErrorMessageW', cdRegister);
 S.RegisterDelphiFunction(@TextExtentW, 'TextExtentW', cdRegister);
 S.RegisterDelphiFunction(@TextHeightW, 'TextHeightW', cdRegister);
 S.RegisterDelphiFunction(@TextWidthW, 'TextWidthW', cdRegister);
 S.RegisterDelphiFunction(@StrTrim, 'diStrTrim', cdRegister);
 S.RegisterDelphiFunction(@StrTrimA, 'StrTrimA', cdRegister);
 //S.RegisterDelphiFunction(@StrTrimW, 'StrTrimW', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCharA, 'StrTrimCharA', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCharsA, 'StrTrimCharsA', cdRegister);
 //S.RegisterDelphiFunction(@StrTrimCharsW, 'StrTrimCharsW', cdRegister);
 S.RegisterDelphiFunction(@TrimLeftByRefA, 'TrimLeftByRefA', cdRegister);
 S.RegisterDelphiFunction(@TrimRightA, 'TrimRightA', cdRegister);
 S.RegisterDelphiFunction(@TrimRightByRefA, 'TrimRightByRefA', cdRegister);
 S.RegisterDelphiFunction(@StrTrimCompressA, 'StrTrimCompressA', cdRegister);
 //S.RegisterDelphiFunction(@StrTrimCompressW, 'StrTrimCompressW', cdRegister);
 //S.RegisterDelphiFunction(@TrimRightByRefW, 'TrimRightByRefW', cdRegister);
 S.RegisterDelphiFunction(@TryStrToIntW, 'TryStrToIntW', cdRegister);
 S.RegisterDelphiFunction(@TryStrToInt64W, 'TryStrToInt64W', cdRegister);
 S.RegisterDelphiFunction(@ValInt35_P, 'ValInt', cdRegister);
 S.RegisterDelphiFunction(@ValIntA36_P, 'ValIntA36', cdRegister);
 //S.RegisterDelphiFunction(@ValIntW37_P, 'ValIntW37', cdRegister);
 S.RegisterDelphiFunction(@ValInt38_P, 'ValInt2', cdRegister);
 S.RegisterDelphiFunction(@ValIntA39_P, 'ValIntA39', cdRegister);
 S.RegisterDelphiFunction(@ValIntW40_P, 'ValIntW40', cdRegister);
 S.RegisterDelphiFunction(@ValInt64A41_P, 'ValInt64A41', cdRegister);
 //S.RegisterDelphiFunction(@ValInt64W42_P, 'ValInt64W42', cdRegister);
 S.RegisterDelphiFunction(@ValInt64A43_P, 'ValInt64A43', cdRegister);
 S.RegisterDelphiFunction(@ValInt64W44_P, 'ValInt64W44', cdRegister);
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
 //S.RegisterDelphiFunction(@CharIsCrLfW, 'CharIsCrLfW', cdRegister);
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
 S.RegisterDelphiFunction(@DayOfWeek, 'diDayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@DayOfWeekYmd, 'DayOfWeekYmd', cdRegister);
 S.RegisterDelphiFunction(@DaysInMonth, 'diDaysInMonth', cdRegister);
 S.RegisterDelphiFunction(@DaysInMonthYm, 'DaysInMonthYm', cdRegister);
 S.RegisterDelphiFunction(@DecDay, 'DecDay', cdRegister);
 S.RegisterDelphiFunction(@DecDays, 'DecDays', cdRegister);
 S.RegisterDelphiFunction(@DeleteDirectory, 'diDeleteDirectory', cdRegister);
 S.RegisterDelphiFunction(@DeleteDirectoryA, 'DeleteDirectoryA', cdRegister);
 S.RegisterDelphiFunction(@DeleteDirectoryW, 'DeleteDirectoryW', cdRegister);
 S.RegisterDelphiFunction(@EasterSunday, 'diEasterSunday', cdRegister);
 S.RegisterDelphiFunction(@EasterSundayYmd, 'EasterSundayYmd', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfWeek, 'diFirstDayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfWeekYmd, 'FirstDayOfWeekYmd', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfMonth, 'diFirstDayOfMonth', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfMonthYmd, 'FirstDayOfMonthYmd', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'diForceDirectories', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectoriesA, 'ForceDirectoriesA', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectoriesW, 'ForceDirectoriesW', cdRegister);
 S.RegisterDelphiFunction(@FreeMemAndNil, 'FreeMemAndNil', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentFolder, 'diGetCurrentFolder', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentFolderA, 'GetCurrentFolderA', cdRegister);
 //S.RegisterDelphiFunction(@GetCurrentFolderW, 'GetCurrentFolderW', cdRegister);
 S.RegisterDelphiFunction(@SetCurrentFolder, 'SetCurrentFolder', cdRegister);
 S.RegisterDelphiFunction(@SetCurrentFolderA, 'SetCurrentFolderA', cdRegister);
 //S.RegisterDelphiFunction(@SetCurrentFolderW, 'SetCurrentFolderW', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopFolder, 'diGetDesktopFolder', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopFolderA, 'GetDesktopFolderA', cdRegister);
 //S.RegisterDelphiFunction(@GetDesktopFolderW, 'GetDesktopFolderW', cdRegister);
 S.RegisterDelphiFunction(@GetFileSize, 'diGetFileSize', cdRegister);
 S.RegisterDelphiFunction(@GetFileSizeA, 'GetFileSizeA', cdRegister);
 S.RegisterDelphiFunction(@GetFileSizeW, 'GetFileSizeW', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopDirectoryFolder, 'diGetDesktopDirectoryFolder', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopDirectoryFolderA, 'GetDesktopDirectoryFolderA', cdRegister);
 //S.RegisterDelphiFunction(@GetDesktopDirectoryFolderW, 'GetDesktopDirectoryFolderW', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastWriteTime, 'GetFileLastWriteTime', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastWriteTimeA, 'GetFileLastWriteTimeA', cdRegister);
 //S.RegisterDelphiFunction(@GetFileLastWriteTimeW, 'GetFileLastWriteTimeW', cdRegister);
 S.RegisterDelphiFunction(@GetPersonalFolder, 'diGetPersonalFolder', cdRegister);
 S.RegisterDelphiFunction(@GetPersonalFolderA, 'GetPersonalFolderA', cdRegister);
 //S.RegisterDelphiFunction(@GetPersonalFolderW, 'GetPersonalFolderW', cdRegister);
 S.RegisterDelphiFunction(@GetSpecialFolder, 'GetSpecialFolder', cdRegister);
 S.RegisterDelphiFunction(@GetSpecialFolderA, 'GetSpecialFolderA', cdRegister);
 //S.RegisterDelphiFunction(@GetSpecialFolderW, 'GetSpecialFolderW', cdRegister);
 S.RegisterDelphiFunction(@IncMonth, 'diIncMonth', cdRegister);
 S.RegisterDelphiFunction(@IncMonths, 'diIncMonths', cdRegister);
 S.RegisterDelphiFunction(@IncDay, 'diIncDay', cdRegister);
 S.RegisterDelphiFunction(@IncDays, 'IncDays', cdRegister);
 S.RegisterDelphiFunction(@IsDateValid, 'IsDateValid', cdRegister);
 S.RegisterDelphiFunction(@IsHolidayInGermany, 'IsHolidayInGermany', cdRegister);
 S.RegisterDelphiFunction(@IsHolidayInGermanyYmd, 'IsHolidayInGermanyYmd', cdRegister);
 S.RegisterDelphiFunction(@IsLeapYear, 'diIsLeapYear', cdRegister);
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
 S.RegisterDelphiFunction(@ISOWeekNumber, 'diISOWeekNumber', cdRegister);
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
 S.RegisterDelphiFunction(@Max45_P, 'diMax', cdRegister);
 S.RegisterDelphiFunction(@Max3, 'diMax3', cdRegister);
 S.RegisterDelphiFunction(@Max46_P, 'MaxCard', cdRegister);
 S.RegisterDelphiFunction(@Max47_P, 'MaxCard3', cdRegister);
 S.RegisterDelphiFunction(@Max48_P, 'diMaxInt64', cdRegister);
 S.RegisterDelphiFunction(@Max49_P, 'dimaxint643', cdRegister);
 S.RegisterDelphiFunction(@Min50_P, 'diMin', cdRegister);
 S.RegisterDelphiFunction(@Min51_P, 'MinCard', cdRegister);
 S.RegisterDelphiFunction(@Min52_P, 'MinCard3', cdRegister);
 //S.RegisterDelphiFunction(@Min53_P, 'diMin3', cdRegister);
 S.RegisterDelphiFunction(@Min53_P, 'diMinint64', cdRegister);
 S.RegisterDelphiFunction(@Min54_P, 'diMinint643', cdRegister);
 S.RegisterDelphiFunction(@Min55_P, 'diMinint64U', cdRegister);
 S.RegisterDelphiFunction(@Min56_P, 'diMinint643U', cdRegister);
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
  //RIRegister_TWideStrBuf(CL);
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
