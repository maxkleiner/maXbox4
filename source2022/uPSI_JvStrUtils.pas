unit uPSI_JvStrUtils;
{
  mX3.8.6
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
  TPSImport_JvStrUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvStrUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvStrUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   JvStrUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvStrUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvStrUtils(CL: TPSPascalCompiler);
begin
 // CL.AddTypeS('TSysCharSet', 'set of Char');
  CL.AddTypeS('TCharSet', 'TSysCharSet');
 CL.AddDelphiFunction('Function StrToOem( const AnsiStr : string) : string');
 CL.AddDelphiFunction('Function OemToAnsiStr( const OemStr : string) : string');
 CL.AddDelphiFunction('Function IsEmptyStr( const S : string; const EmptyChars : TCharSet) : Boolean');
 CL.AddDelphiFunction('Function ReplaceStrJ( const S, Srch, Replace : string) : string');
 CL.AddDelphiFunction('Function DelSpaceJ( const S : string) : string');
 CL.AddDelphiFunction('Function DelChars( const S : string; aChr : Char) : string');
 CL.AddDelphiFunction('Function DelBSpace( const S : string) : string');
 CL.AddDelphiFunction('Function DelESpace( const S : string) : string');
 CL.AddDelphiFunction('Function DelRSpace( const S : string) : string');
 CL.AddDelphiFunction('Function DelSpace1( const S : string) : string');
 CL.AddDelphiFunction('Function Tab2Space( const S : string; Numb : Byte) : string');
 CL.AddDelphiFunction('Function NPos( const C : string; S : string; N : Integer) : Integer');
 CL.AddDelphiFunction('Function MakeStr( C : Char; N : Integer) : string');
 CL.AddDelphiFunction('Function MS( C : Char; N : Integer) : string');
 CL.AddDelphiFunction('Function AddChar( C : Char; const S : string; N : Integer) : string');
 CL.AddDelphiFunction('Function AddCharR( C : Char; const S : string; N : Integer) : string');
 CL.AddDelphiFunction('Function LeftStrJ( const S : string; N : Integer) : string');
 CL.AddDelphiFunction('Function RightStrJ( const S : string; N : Integer) : string');
 CL.AddDelphiFunction('Function CenterStr( const S : string; Len : Integer) : string');
 CL.AddDelphiFunction('Function CompStr( const S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function CompText( const S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function Copy2Symb( const S : string; Symb : Char) : string');
 CL.AddDelphiFunction('Function Copy2SymbDel( var S : string; Symb : Char) : string');
 CL.AddDelphiFunction('Function Copy2Space( const S : string) : string');
 CL.AddDelphiFunction('Function Copy2SpaceDel( var S : string) : string');
 CL.AddDelphiFunction('Function AnsiProperCase( const S : string; const WordDelims : TCharSet) : string');
 CL.AddDelphiFunction('Function WordCount( const S : string; const WordDelims : TCharSet) : Integer');
 CL.AddDelphiFunction('Function WordPosition( const N : Integer; const S : string; const WordDelims : TCharSet) : Integer');
 CL.AddDelphiFunction('Function ExtractWord( N : Integer; const S : string; const WordDelims : TCharSet) : string');
 CL.AddDelphiFunction('Function ExtractWordPos( N : Integer; const S : string; const WordDelims : TCharSet; var Pos : Integer) : string');
 CL.AddDelphiFunction('Function ExtractDelimited( N : Integer; const S : string; const Delims : TCharSet) : string');
 CL.AddDelphiFunction('Function ExtractSubstr( const S : string; var Pos : Integer; const Delims : TCharSet) : string');
 CL.AddDelphiFunction('Function IsWordPresent( const W, S : string; const WordDelims : TCharSet) : Boolean');
 CL.AddDelphiFunction('Function QuotedString( const S : string; Quote : Char) : string');
 CL.AddDelphiFunction('Function ExtractQuotedString( const S : string; Quote : Char) : string');
 CL.AddDelphiFunction('Function FindPart( const HelpWilds, InputStr : string) : Integer');
 CL.AddDelphiFunction('Function IsWild( InputStr, Wilds : string; IgnoreCase : Boolean) : Boolean');
 CL.AddDelphiFunction('Function XorString( const Key, Src : ShortString) : ShortString');
 CL.AddDelphiFunction('Function XorEncode( const Key, Source : string) : string');
 CL.AddDelphiFunction('Function XorDecode( const Key, Source : string) : string');
 CL.AddDelphiFunction('Function FindCmdLineSwitchJ( const Switch : string; SwitchChars : TCharSet; IgnoreCase : Boolean) : Boolean');
 CL.AddDelphiFunction('Function GetCmdLineArg( const Switch : string; SwitchChars : TCharSet) : string');
 CL.AddDelphiFunction('Function Numb2USA( const S : string) : string');
 CL.AddDelphiFunction('Function Dec2Hex( N : Longint; A : Byte) : string');
 CL.AddDelphiFunction('Function D2H( N : Longint; A : Byte) : string');
 CL.AddDelphiFunction('Function Hex2Dec( const S : string) : Longint');
 CL.AddDelphiFunction('Function H2D( const S : string) : Longint');
 CL.AddDelphiFunction('Function Dec2Numb( N : Longint; A, B : Byte) : string');
 CL.AddDelphiFunction('Function Numb2Dec( S : string; B : Byte) : Longint');
 CL.AddDelphiFunction('Function IntToBinJ( Value : Longint; Digits, Spaces : Integer) : string');
 CL.AddDelphiFunction('Function IntToRoman( Value : Longint) : string');
 CL.AddDelphiFunction('Function RomanToInt( const S : string) : Longint');
 //CL.AddConstantN('Brackets','String').SetString( '(' or  ')' or  '[' or  ']' or  '{' or  '}');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvStrUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StrToOem, 'StrToOem', cdRegister);
 S.RegisterDelphiFunction(@OemToAnsiStr, 'OemToAnsiStr', cdRegister);
 S.RegisterDelphiFunction(@IsEmptyStr, 'IsEmptyStr', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStr, 'ReplaceStrJ', cdRegister);
 S.RegisterDelphiFunction(@DelSpace, 'DelSpaceJ', cdRegister);
 S.RegisterDelphiFunction(@DelChars, 'DelChars', cdRegister);
 S.RegisterDelphiFunction(@DelBSpace, 'DelBSpace', cdRegister);
 S.RegisterDelphiFunction(@DelESpace, 'DelESpace', cdRegister);
 S.RegisterDelphiFunction(@DelRSpace, 'DelRSpace', cdRegister);
 S.RegisterDelphiFunction(@DelSpace1, 'DelSpace1', cdRegister);
 S.RegisterDelphiFunction(@Tab2Space, 'Tab2Space', cdRegister);
 S.RegisterDelphiFunction(@NPos, 'NPos', cdRegister);
 S.RegisterDelphiFunction(@MakeStr, 'MakeStr', cdRegister);
 S.RegisterDelphiFunction(@MS, 'MS', cdRegister);
 S.RegisterDelphiFunction(@AddChar, 'AddChar', cdRegister);
 S.RegisterDelphiFunction(@AddCharR, 'AddCharR', cdRegister);
 S.RegisterDelphiFunction(@LeftStr, 'LeftStrJ', cdRegister);
 S.RegisterDelphiFunction(@RightStr, 'RightStrJ', cdRegister);
 S.RegisterDelphiFunction(@CenterStr, 'CenterStr', cdRegister);
 S.RegisterDelphiFunction(@CompStr, 'CompStr', cdRegister);
 S.RegisterDelphiFunction(@CompText, 'CompText', cdRegister);
 S.RegisterDelphiFunction(@Copy2Symb, 'Copy2Symb', cdRegister);
 S.RegisterDelphiFunction(@Copy2SymbDel, 'Copy2SymbDel', cdRegister);
 S.RegisterDelphiFunction(@Copy2Space, 'Copy2Space', cdRegister);
 S.RegisterDelphiFunction(@Copy2SpaceDel, 'Copy2SpaceDel', cdRegister);
 S.RegisterDelphiFunction(@AnsiProperCase, 'AnsiProperCase', cdRegister);
 S.RegisterDelphiFunction(@WordCount, 'WordCount', cdRegister);
 S.RegisterDelphiFunction(@WordPosition, 'WordPosition', cdRegister);
 S.RegisterDelphiFunction(@ExtractWord, 'ExtractWord', cdRegister);
 S.RegisterDelphiFunction(@ExtractWordPos, 'ExtractWordPos', cdRegister);
 S.RegisterDelphiFunction(@ExtractDelimited, 'ExtractDelimited', cdRegister);
 S.RegisterDelphiFunction(@ExtractSubstr, 'ExtractSubstr', cdRegister);
 S.RegisterDelphiFunction(@IsWordPresent, 'IsWordPresent', cdRegister);
 S.RegisterDelphiFunction(@QuotedString, 'QuotedString', cdRegister);
 S.RegisterDelphiFunction(@ExtractQuotedString, 'ExtractQuotedString', cdRegister);
 S.RegisterDelphiFunction(@FindPart, 'FindPart', cdRegister);
 S.RegisterDelphiFunction(@IsWild, 'IsWild', cdRegister);
 S.RegisterDelphiFunction(@XorString, 'XorString', cdRegister);
 S.RegisterDelphiFunction(@XorEncode, 'XorEncode', cdRegister);
 S.RegisterDelphiFunction(@XorDecode, 'XorDecode', cdRegister);
 S.RegisterDelphiFunction(@FindCmdLineSwitch, 'FindCmdLineSwitchJ', cdRegister);
 S.RegisterDelphiFunction(@GetCmdLineArg, 'GetCmdLineArg', cdRegister);
 S.RegisterDelphiFunction(@Numb2USA, 'Numb2USA', cdRegister);
 S.RegisterDelphiFunction(@Dec2Hex, 'Dec2Hex', cdRegister);
 S.RegisterDelphiFunction(@D2H, 'D2H', cdRegister);
 S.RegisterDelphiFunction(@Hex2Dec, 'Hex2Dec', cdRegister);
 S.RegisterDelphiFunction(@H2D, 'H2D', cdRegister);
 S.RegisterDelphiFunction(@Dec2Numb, 'Dec2Numb', cdRegister);
 S.RegisterDelphiFunction(@Numb2Dec, 'Numb2Dec', cdRegister);
 S.RegisterDelphiFunction(@IntToBin, 'IntToBinJ', cdRegister);
 S.RegisterDelphiFunction(@IntToRoman, 'IntToRoman', cdRegister);
 S.RegisterDelphiFunction(@RomanToInt, 'RomanToInt', cdRegister);
end;

 
 
{ TPSImport_JvStrUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStrUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvStrUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStrUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvStrUtils(ri);
  RIRegister_JvStrUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
