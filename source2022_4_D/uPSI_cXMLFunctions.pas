unit uPSI_cXMLFunctions;
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
  TPSImport_cXMLFunctions = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cXMLFunctions(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cXMLFunctions_Routines(S: TPSExec);
procedure RIRegister_cXMLFunctions(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cUtils
  //,cUnicodeCodecs
  ,cXMLFunctions
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cXMLFunctions]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cXMLFunctions(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('xmlVersion','String').SetString( '1.0');
  CL.AddClassN(CL.FindClass('TOBJECT'),'Exml');
 //CL.AddDelphiFunction('Function xmlValidChar( const Ch : AnsiChar) : Boolean;');
 CL.AddDelphiFunction('Function xmlValidChar1( const Ch : UCS4Char) : Boolean;');
 CL.AddDelphiFunction('Function xmlValidChar2( const Ch : WideChar) : Boolean;');
 CL.AddDelphiFunction('Function xmlIsSpaceChar( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function xmlIsLetter( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function xmlIsDigit( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function xmlIsNameStartChar( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function xmlIsNameChar( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function xmlIsPubidChar( const Ch : WideChar) : Boolean');
 CL.AddDelphiFunction('Function xmlValidName( const Text : UnicodeString) : Boolean');
 //CL.AddConstantN('xmlSpace','Char').SetString( #$20 or  #$9 or  #$D or  #$A);
 //CL.AddDelphiFunction('Function xmlSkipSpace( var P : PWideChar) : Boolean');
 //CL.AddDelphiFunction('Function xmlSkipEq( var P : PWideChar) : Boolean');
 //CL.AddDelphiFunction('Function xmlExtractQuotedText( var P : PWideChar; var S : UnicodeString) : Boolean');
 //CL.AddDelphiFunction('Function xmlGetEntityEncoding( const Buf : Pointer; const BufSize : Integer; out HeaderSize : Integer) : TUnicodeCodecClass');
 CL.AddDelphiFunction('Function xmlResolveEntityReference( const RefName : UnicodeString) : WideChar');
 CL.AddDelphiFunction('Function xmlTag( const Tag : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function xmlEndTag( const Tag : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function xmlAttrTag( const Tag : UnicodeString; const Attr : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function xmlEmptyTag( const Tag, Attr : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Procedure xmlSafeTextInPlace( var Txt : UnicodeString)');
 CL.AddDelphiFunction('Function xmlSafeText( const Txt : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function xmlSpaceIndent( const IndentLength : Integer; const IndentLevel : Integer) : UnicodeString');
 CL.AddDelphiFunction('Function xmlTabIndent( const IndentLevel : Integer) : UnicodeString');
 CL.AddDelphiFunction('Function xmlComment( const Comment : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Procedure SelfTestcXMLFunctions');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function xmlValidChar2_P( const Ch : WideChar) : Boolean;
Begin Result := cXMLFunctions.xmlValidChar(Ch); END;

(*----------------------------------------------------------------------------*)
Function xmlValidChar1_P( const Ch : UCS4Char) : Boolean;
Begin Result := cXMLFunctions.xmlValidChar(Ch); END;

(*----------------------------------------------------------------------------*)
Function xmlValidChar_P( const Ch : AnsiChar) : Boolean;
Begin Result := cXMLFunctions.xmlValidChar(Ch); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cXMLFunctions_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@xmlValidChar, 'xmlValidChar', cdRegister);
 S.RegisterDelphiFunction(@xmlValidChar1_P, 'xmlValidChar1', cdRegister);
 S.RegisterDelphiFunction(@xmlValidChar2_P, 'xmlValidChar2', cdRegister);
 S.RegisterDelphiFunction(@xmlIsSpaceChar, 'xmlIsSpaceChar', cdRegister);
 S.RegisterDelphiFunction(@xmlIsLetter, 'xmlIsLetter', cdRegister);
 S.RegisterDelphiFunction(@xmlIsDigit, 'xmlIsDigit', cdRegister);
 S.RegisterDelphiFunction(@xmlIsNameStartChar, 'xmlIsNameStartChar', cdRegister);
 S.RegisterDelphiFunction(@xmlIsNameChar, 'xmlIsNameChar', cdRegister);
 S.RegisterDelphiFunction(@xmlIsPubidChar, 'xmlIsPubidChar', cdRegister);
 S.RegisterDelphiFunction(@xmlValidName, 'xmlValidName', cdRegister);
 S.RegisterDelphiFunction(@xmlSkipSpace, 'xmlSkipSpace', cdRegister);
 S.RegisterDelphiFunction(@xmlSkipEq, 'xmlSkipEq', cdRegister);
 S.RegisterDelphiFunction(@xmlExtractQuotedText, 'xmlExtractQuotedText', cdRegister);
 //S.RegisterDelphiFunction(@xmlGetEntityEncoding, 'xmlGetEntityEncoding', cdRegister);
 //S.RegisterDelphiFunction(@xmlResolveEntityReference, 'xmlResolveEntityReference', cdRegister);
 S.RegisterDelphiFunction(@xmlTag, 'xmlTag', cdRegister);
 S.RegisterDelphiFunction(@xmlEndTag, 'xmlEndTag', cdRegister);
 S.RegisterDelphiFunction(@xmlAttrTag, 'xmlAttrTag', cdRegister);
 S.RegisterDelphiFunction(@xmlEmptyTag, 'xmlEmptyTag', cdRegister);
 S.RegisterDelphiFunction(@xmlSafeTextInPlace, 'xmlSafeTextInPlace', cdRegister);
 S.RegisterDelphiFunction(@xmlSafeText, 'xmlSafeText', cdRegister);
 S.RegisterDelphiFunction(@xmlSpaceIndent, 'xmlSpaceIndent', cdRegister);
 S.RegisterDelphiFunction(@xmlTabIndent, 'xmlTabIndent', cdRegister);
 S.RegisterDelphiFunction(@xmlComment, 'xmlComment', cdRegister);
 S.RegisterDelphiFunction(@SelfTestcXMLFunctions, 'SelfTestcXMLFunctions', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cXMLFunctions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(Exml) do
end;

 
 
{ TPSImport_cXMLFunctions }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cXMLFunctions.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cXMLFunctions(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cXMLFunctions.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cXMLFunctions(ri);
  RIRegister_cXMLFunctions_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.