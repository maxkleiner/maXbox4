unit uPSI_WideStrUtils;
{
all PWideChar are not set    also set of ansiChar
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
  TPSImport_WideStrUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_WideStrUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_WideStrUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,WideStrUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WideStrUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_WideStrUtils(CL: TPSPascalCompiler);
begin
 {CL.AddDelphiFunction('Function WStrAlloc( Size : Cardinal) : PWideChar');
 CL.AddDelphiFunction('Function WStrBufSize( const Str : PWideChar) : Cardinal');
 CL.AddDelphiFunction('Function WStrMove( Dest : PWideChar; const Source : PWideChar; Count : Cardinal) : PWideChar');
 CL.AddDelphiFunction('Function WStrNew( const Str : PWideChar) : PWideChar');
 CL.AddDelphiFunction('Procedure WStrDispose( Str : PWideChar)');
 CL.AddDelphiFunction('Function WStrLen( const Str : PWideChar) : Cardinal');
 CL.AddDelphiFunction('Function WStrEnd( const Str : PWideChar) : PWideChar');
 CL.AddDelphiFunction('Function WStrCat( Dest : PWideChar; const Source : PWideChar) : PWideChar');
 CL.AddDelphiFunction('Function WStrCopy( Dest : PWideChar; const Source : PWideChar) : PWideChar');
 CL.AddDelphiFunction('Function WStrLCopy( Dest : PWideChar; const Source : PWideChar; MaxLen : Cardinal) : PWideChar');
 CL.AddDelphiFunction('Function WStrPCopy( Dest : PWideChar; const Source : WideString) : PWideChar');
 CL.AddDelphiFunction('Function WStrPLCopy( Dest : PWideChar; const Source : WideString; MaxLen : Cardinal) : PWideChar');
 CL.AddDelphiFunction('Function WStrScan( Str : PWideChar; Chaar : WideChar) : PWideChar');
 CL.AddDelphiFunction('Function WStrComp( const Str1, Str2 : PWideChar) : Integer');
 CL.AddDelphiFunction('Function WStrPos( const Str1, Str2 : PWideChar) : PWideChar');}
 CL.AddDelphiFunction('Function UTF8LowerCase( const S : UTF8string) : UTF8string');
 CL.AddDelphiFunction('Function UTF8UpperCase( const S : UTF8string) : UTF8string');
 CL.AddDelphiFunction('Function AnsiToUtf8Ex( const S : string; const cp : integer) : UTF8String');
 CL.AddDelphiFunction('Function Utf8ToAnsiEx( const S : UTF8String; const cp : integer) : string');
  CL.AddTypeS('TEncodeType', '( etUSASCII, etUTF8, etANSI )');
 CL.AddDelphiFunction('Function DetectUTF8Encoding( const s : UTF8String) : TEncodeType');
 CL.AddDelphiFunction('Function IsUTF8String( const s : UTF8String) : Boolean');
 CL.AddDelphiFunction('Function HasExtendCharacter( const s : UTF8String) : Boolean');
 CL.AddDelphiFunction('Function HasUTF8BOM( S : TStream) : boolean;');
 CL.AddDelphiFunction('Function HasUTF8BOM1( S : AnsiString) : boolean;');
 CL.AddDelphiFunction('Procedure ConvertStreamFromAnsiToUTF8( Src, Dst : TStream; cp : integer)');
 CL.AddDelphiFunction('Procedure ConvertStreamFromUTF8ToAnsi( Src, Dst : TStream; cp : integer)');
 //CL.AddDelphiFunction('Function WideLastChar( const S : WideString) : PWideChar');
 CL.AddDelphiFunction('Function WideQuotedStr( const S : WideString; Quote : WideChar) : WideString');
 //CL.AddDelphiFunction('Function WideExtractQuotedStr( var Src : PWideChar; Quote : WideChar) : WideString');
 CL.AddDelphiFunction('Function WideDequotedStr( const S : WideString; AQuote : WideChar) : WideString');
 CL.AddDelphiFunction('Function WideAdjustLineBreaks( const S : WideString; Style : TTextLineBreakStyle) : WideString');
 CL.AddDelphiFunction('Function WideStringReplace( const S, OldPattern, NewPattern : Widestring; Flags : TReplaceFlags) : Widestring');
 CL.AddDelphiFunction('Function WideReplaceStr( const AText, AFromText, AToText : WideString) : WideString');
 CL.AddDelphiFunction('Function WideReplaceText( const AText, AFromText, AToText : WideString) : WideString');
 CL.AddDelphiFunction('Function LoadWideStr( Ident : Integer) : WideString');
 //CL.AddDelphiFunction('Function LoadResWideString( ResStringRec : PResStringRec) : WideString');
 // CL.AddTypeS('CharSet', 'set of ansichar');
 //CL.AddDelphiFunction('Function inOpSet( W : WideChar; sets : CharSet) : boolean');
 CL.AddDelphiFunction('Function inOpArray( W : WideChar; sets : array of WideChar) : boolean');
 CL.AddDelphiFunction('Function IsUTF8LeadByte( Lead : Char) : Boolean');
 CL.AddDelphiFunction('Function IsUTF8TrailByte( Lead : Char) : Boolean');
 CL.AddDelphiFunction('Function UTF8CharSize( Lead : Char) : Integer');
 CL.AddDelphiFunction('Function UTF8CharLength( Lead : Char) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function HasUTF8BOM1_P( S : AnsiString) : boolean;
Begin Result := WideStrUtils.HasUTF8BOM(S); END;

(*----------------------------------------------------------------------------*)
Function HasUTF8BOM_P( S : TStream) : boolean;
Begin Result := WideStrUtils.HasUTF8BOM(S); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WideStrUtils_Routines(S: TPSExec);
begin
 {S.RegisterDelphiFunction(@WStrAlloc, 'WStrAlloc', cdRegister);
 S.RegisterDelphiFunction(@WStrBufSize, 'WStrBufSize', cdRegister);
 S.RegisterDelphiFunction(@WStrMove, 'WStrMove', cdRegister);
 S.RegisterDelphiFunction(@WStrNew, 'WStrNew', cdRegister);
 S.RegisterDelphiFunction(@WStrDispose, 'WStrDispose', cdRegister);
 S.RegisterDelphiFunction(@WStrLen, 'WStrLen', cdRegister);
 S.RegisterDelphiFunction(@WStrEnd, 'WStrEnd', cdRegister);
 S.RegisterDelphiFunction(@WStrCat, 'WStrCat', cdRegister);
 S.RegisterDelphiFunction(@WStrCopy, 'WStrCopy', cdRegister);
 S.RegisterDelphiFunction(@WStrLCopy, 'WStrLCopy', cdRegister);
 S.RegisterDelphiFunction(@WStrPCopy, 'WStrPCopy', cdRegister);
 S.RegisterDelphiFunction(@WStrPLCopy, 'WStrPLCopy', cdRegister);
 S.RegisterDelphiFunction(@WStrScan, 'WStrScan', cdRegister);
 S.RegisterDelphiFunction(@WStrComp, 'WStrComp', cdRegister);
 S.RegisterDelphiFunction(@WStrPos, 'WStrPos', cdRegister);}
 S.RegisterDelphiFunction(@UTF8LowerCase, 'UTF8LowerCase', cdRegister);
 S.RegisterDelphiFunction(@UTF8UpperCase, 'UTF8UpperCase', cdRegister);
 S.RegisterDelphiFunction(@AnsiToUtf8Ex, 'AnsiToUtf8Ex', cdRegister);
 S.RegisterDelphiFunction(@Utf8ToAnsiEx, 'Utf8ToAnsiEx', cdRegister);
 S.RegisterDelphiFunction(@DetectUTF8Encoding, 'DetectUTF8Encoding', cdRegister);
 S.RegisterDelphiFunction(@IsUTF8String, 'IsUTF8String', cdRegister);
 S.RegisterDelphiFunction(@HasExtendCharacter, 'HasExtendCharacter', cdRegister);
 S.RegisterDelphiFunction(@HasUTF8BOM_P, 'HasUTF8BOM', cdRegister);
 S.RegisterDelphiFunction(@HasUTF8BOM1_P, 'HasUTF8BOM1', cdRegister);
 S.RegisterDelphiFunction(@ConvertStreamFromAnsiToUTF8, 'ConvertStreamFromAnsiToUTF8', cdRegister);
 S.RegisterDelphiFunction(@ConvertStreamFromUTF8ToAnsi, 'ConvertStreamFromUTF8ToAnsi', cdRegister);
 S.RegisterDelphiFunction(@WideLastChar, 'WideLastChar', cdRegister);
 S.RegisterDelphiFunction(@WideQuotedStr, 'WideQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@WideExtractQuotedStr, 'WideExtractQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@WideDequotedStr, 'WideDequotedStr', cdRegister);
 S.RegisterDelphiFunction(@WideAdjustLineBreaks, 'WideAdjustLineBreaks', cdRegister);
 S.RegisterDelphiFunction(@WideStringReplace, 'WideStringReplace', cdRegister);
 S.RegisterDelphiFunction(@WideReplaceStr, 'WideReplaceStr', cdRegister);
 S.RegisterDelphiFunction(@WideReplaceText, 'WideReplaceText', cdRegister);
 S.RegisterDelphiFunction(@LoadWideStr, 'LoadWideStr', cdRegister);
 S.RegisterDelphiFunction(@LoadResWideString, 'LoadResWideString', cdRegister);
 S.RegisterDelphiFunction(@inOpSet, 'inOpSet', cdRegister);
 S.RegisterDelphiFunction(@inOpArray, 'inOpArray', cdRegister);
 S.RegisterDelphiFunction(@IsUTF8LeadByte, 'IsUTF8LeadByte', cdRegister);
 S.RegisterDelphiFunction(@IsUTF8TrailByte, 'IsUTF8TrailByte', cdRegister);
 S.RegisterDelphiFunction(@UTF8CharSize, 'UTF8CharSize', cdRegister);
 S.RegisterDelphiFunction(@UTF8CharLength, 'UTF8CharLength', cdRegister);
end;

 
 
{ TPSImport_WideStrUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WideStrUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WideStrUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WideStrUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_WideStrUtils(ri);
  RIRegister_WideStrUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
