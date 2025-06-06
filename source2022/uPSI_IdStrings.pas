unit uPSI_IdStrings;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_IdStrings = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IdStrings(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdStrings_Routines(S: TPSExec);

procedure Register;

implementation


uses
   IdStrings
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdStrings]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IdStrings(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function FindFirstOf( AFind, AText : String) : Integer');
 CL.AddDelphiFunction('Function FindFirstNotOf( AFind, AText : String) : Integer');
 CL.AddDelphiFunction('Function TrimAllOf( ATrim, AText : String) : String');
 CL.AddDelphiFunction('Function IsWhiteString( const AStr : String) : Boolean');
 CL.AddDelphiFunction('Function BinToHexStr( AData : Pointer; ADataLen : Integer) : String');
 CL.AddDelphiFunction('Function StrHtmlEncode( const AStr : String) : String');
 CL.AddDelphiFunction('Function StrHtmlDecode( const AStr : String) : String');
 CL.AddDelphiFunction('Procedure SplitColumnsNoTrim( const AData : String; AStrings : TStrings; const ADelim : String)');
 CL.AddDelphiFunction('Procedure SplitColumns( const AData : String; AStrings : TStrings; const ADelim : String)');
 CL.AddDelphiFunction('Procedure SplitLines( AData : PChar; ADataSize : Integer; AStrings : TStrings)');
 CL.AddDelphiFunction('Procedure SplitString( const AStr, AToken : String; var VLeft, VRight : String)');
 CL.AddDelphiFunction('Function CommaAdd( const AStr1, AStr2 : String) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_IdStrings_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FindFirstOf, 'FindFirstOf', cdRegister);
 S.RegisterDelphiFunction(@FindFirstNotOf, 'FindFirstNotOf', cdRegister);
 S.RegisterDelphiFunction(@TrimAllOf, 'TrimAllOf', cdRegister);
 S.RegisterDelphiFunction(@IsWhiteString, 'IsWhiteString', cdRegister);
 S.RegisterDelphiFunction(@BinToHexStr, 'BinToHexStr', cdRegister);
 S.RegisterDelphiFunction(@StrHtmlEncode, 'StrHtmlEncode', cdRegister);
 S.RegisterDelphiFunction(@StrHtmlDecode, 'StrHtmlDecode', cdRegister);
 S.RegisterDelphiFunction(@SplitColumnsNoTrim, 'SplitColumnsNoTrim', cdRegister);
 S.RegisterDelphiFunction(@SplitColumns, 'SplitColumns', cdRegister);
 S.RegisterDelphiFunction(@SplitLines, 'SplitLines', cdRegister);
 S.RegisterDelphiFunction(@SplitString, 'SplitString', cdRegister);
 S.RegisterDelphiFunction(@CommaAdd, 'CommaAdd', cdRegister);
end;

 
 
{ TPSImport_IdStrings }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdStrings.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdStrings(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdStrings.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdStrings(ri);
  RIRegister_IdStrings_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
