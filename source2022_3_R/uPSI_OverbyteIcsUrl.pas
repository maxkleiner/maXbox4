unit uPSI_OverbyteIcsUrl;
{
The last of a line - design , guideline, implement    - ics prefix
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
  TPSImport_OverbyteIcsUrl = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_OverbyteIcsUrl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_OverbyteIcsUrl_Routines(S: TPSExec);

procedure Register;

implementation


uses
   OverbyteIcsUtils
  ,OverbyteIcsUrl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OverbyteIcsUrl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_OverbyteIcsUrl(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IcsUrlVersion','LongInt').SetInt( 800);
 CL.AddConstantN('uriCopyRight','String').SetString( ' TIcsURL (c) 1997-2012 F. Piette V8.00 ');
 CL.AddDelphiFunction('Procedure icsParseURL( const URL : String; var Proto, User, Pass, Host, Port, Path : String)');
 CL.AddDelphiFunction('Function icsPosn( const s, t : String; count : Integer) : Integer');
 CL.AddDelphiFunction('Function icsUrlEncode( const S : String; DstCodePage : LongWord) : String');
 CL.AddDelphiFunction('Function icsUrlDecode0( const S : String; SrcCodePage : LongWord; DetectUtf8 : Boolean) : String;');
 CL.AddDelphiFunction('Function icsUrlDecode1( const S : RawByteString; SrcCodePage : LongWord; DetectUtf8 : Boolean) : UnicodeString;');
 CL.AddDelphiFunction('Function icsUrlEncodeToA( const S : String; DstCodePage : LongWord) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function UrlDecode1_P( const S : String; SrcCodePage : LongWord; DetectUtf8 : Boolean) : String;
Begin Result := OverbyteIcsUrl.UrlDecode(S, SrcCodePage, DetectUtf8); END;

(*----------------------------------------------------------------------------*)
Function UrlDecode0_P( const S : String; SrcCodePage : LongWord; DetectUtf8 : Boolean) : String;
Begin Result := OverbyteIcsUrl.UrlDecode(S, SrcCodePage, DetectUtf8); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_OverbyteIcsUrl_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ParseURL, 'icsParseURL', cdRegister);
 S.RegisterDelphiFunction(@Posn, 'icsPosn', cdRegister);
 S.RegisterDelphiFunction(@UrlEncode, 'icsUrlEncode', cdRegister);
 S.RegisterDelphiFunction(@UrlDecode0_P, 'icsUrlDecode0', cdRegister);
 S.RegisterDelphiFunction(@UrlDecode1_P, 'icsUrlDecode1', cdRegister);
 S.RegisterDelphiFunction(@UrlEncodeToA, 'icsUrlEncodeToA', cdRegister);
end;

 
 
{ TPSImport_OverbyteIcsUrl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsUrl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OverbyteIcsUrl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsUrl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OverbyteIcsUrl_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
