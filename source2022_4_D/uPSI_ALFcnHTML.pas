unit uPSI_ALFcnHTML;
{
   funct to http   - execute java script
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
  TPSImport_ALFcnHTML = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ALFcnHTML(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALFcnHTML_Routines(S: TPSExec);

procedure Register;

implementation


uses
   AlStringList
  ,ALFcnHTML
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFcnHTML]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFcnHTML(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure ALUTF8ExtractHTMLText( HtmlContent : AnsiString; LstExtractedResourceText : TALStrings; const DecodeHTMLText : Boolean);');
 CL.AddDelphiFunction('Function ALUTF8ExtractHTMLText1( HtmlContent : AnsiString; const DecodeHTMLText : Boolean) : AnsiString;');
 CL.AddDelphiFunction('Function ALXMLCDataElementEncode( Src : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALXMLTextElementEncode( Src : AnsiString; const useNumericReference : boolean) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8XMLTextElementDecode( const Src : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8HTMLEncode( const Src : AnsiString; const EncodeASCIIHtmlEntities : Boolean; const useNumericReference : boolean) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8HTMLDecode( const Src : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALJavascriptEncode( const Src : AnsiString; const useNumericReference : boolean) : AnsiString');
 CL.AddDelphiFunction('Function ALUTF8JavascriptDecode( const Src : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure ALHideHtmlUnwantedTagForHTMLHandleTagfunct( var HtmlContent : AnsiString; const DeleteBodyOfUnwantedTag : Boolean; const ReplaceUnwantedTagCharBy : Char)');
 CL.AddDelphiFunction('Procedure ALCompactHtmlTagParams( TagParams : TALStrings)');
 //CL.AddDelphiFunction('Function ALJavascriptEncode( const Src : AnsiString; const useNumericReference : boolean) : AnsiString');
 CL.AddDelphiFunction('Procedure ALUTF8JavascriptDecodeV( var Str : AnsiString)');
 //CL.AddDelphiFunction('Function ALUTF8JavascriptDecode( const Src : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALRunJavascript( const aCode : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function RunJavascript( const aCode : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALRunJavascript2( const aCode : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function RunJavascript2( const aCode : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function RunJS( const aCode : AnsiString) : AnsiString');
 //CL.AddDelphiFunction('Procedure ALHideHtmlUnwantedTagForHTMLHandleTagfunct( var HtmlContent : AnsiString; const DeleteBodyOfUnwantedTag : Boolean; const ReplaceUnwantedTagCharBy : AnsiChar)');
 //CL.AddDelphiFunction('Procedure ALCompactHtmlTagParams( TagParams : TALStrings)');
 CL.AddDelphiFunction('Function ALJavascriptEncodeU( const Src : String; const useNumericReference : boolean) : String');
 CL.AddDelphiFunction('Procedure ALJavascriptDecodeVU( var Str : String)');
 CL.AddDelphiFunction('Function ALJavascriptDecodeU( const Src : String) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ALUTF8ExtractHTMLText1_P( HtmlContent : AnsiString; const DecodeHTMLText : Boolean) : AnsiString;
Begin Result := ALFcnHTML.ALUTF8ExtractHTMLText(HtmlContent, DecodeHTMLText); END;

(*----------------------------------------------------------------------------*)
Procedure ALUTF8ExtractHTMLText_P( HtmlContent : AnsiString; LstExtractedResourceText : TALStrings; const DecodeHTMLText : Boolean);
Begin ALFcnHTML.ALUTF8ExtractHTMLText(HtmlContent, LstExtractedResourceText, DecodeHTMLText); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFcnHTML_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ALUTF8ExtractHTMLText, 'ALUTF8ExtractHTMLText', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8ExtractHTMLText1_P, 'ALUTF8ExtractHTMLText1', cdRegister);
 S.RegisterDelphiFunction(@ALXMLCDataElementEncode, 'ALXMLCDataElementEncode', cdRegister);
 S.RegisterDelphiFunction(@ALXMLTextElementEncode, 'ALXMLTextElementEncode', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8XMLTextElementDecode, 'ALUTF8XMLTextElementDecode', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8HTMLEncode, 'ALUTF8HTMLEncode', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8HTMLDecode, 'ALUTF8HTMLDecode', cdRegister);
 S.RegisterDelphiFunction(@ALJavascriptEncode, 'ALJavascriptEncode', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8JavascriptDecode, 'ALUTF8JavascriptDecode', cdRegister);
 S.RegisterDelphiFunction(@ALHideHtmlUnwantedTagForHTMLHandleTagfunct, 'ALHideHtmlUnwantedTagForHTMLHandleTagfunct', cdRegister);
 S.RegisterDelphiFunction(@ALCompactHtmlTagParams, 'ALCompactHtmlTagParams', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8JavascriptDecodeV, 'ALUTF8JavascriptDecodeV', cdRegister);
//S.RegisterDelphiFunction(@ALUTF8JavascriptDecode, 'ALUTF8JavascriptDecode', cdRegister);
 S.RegisterDelphiFunction(@ALRunJavascript, 'ALRunJavascript', cdRegister);
 S.RegisterDelphiFunction(@ALRunJavascript2, 'ALRunJavascript2', cdRegister);
 S.RegisterDelphiFunction(@ALRunJavascript, 'RunJavascript', cdRegister);
 S.RegisterDelphiFunction(@ALRunJavascript2, 'RunJavascript2', cdRegister);
 S.RegisterDelphiFunction(@ALRunJavascript2, 'RunJS', cdRegister);
 //S.RegisterDelphiFunction(@ALHideHtmlUnwantedTagForHTMLHandleTagfunct, 'ALHideHtmlUnwantedTagForHTMLHandleTagfunct', cdRegister);
 //S.RegisterDelphiFunction(@ALCompactHtmlTagParams, 'ALCompactHtmlTagParams', cdRegister);
 S.RegisterDelphiFunction(@ALJavascriptEncodeU, 'ALJavascriptEncodeU', cdRegister);
 S.RegisterDelphiFunction(@ALJavascriptDecodeVU, 'ALJavascriptDecodeVU', cdRegister);
 S.RegisterDelphiFunction(@ALJavascriptDecodeU, 'ALJavascriptDecodeU', cdRegister);
end;

 
 
{ TPSImport_ALFcnHTML }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnHTML.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFcnHTML(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnHTML.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ALFcnHTML(ri);
  RIRegister_ALFcnHTML_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
