unit uPSI_StToHTML;
{
  SysTools4  add free
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
  TPSImport_StToHTML = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStFileToHTML(CL: TPSPascalCompiler);
procedure SIRegister_TStStreamToHTML(CL: TPSPascalCompiler);
procedure SIRegister_StToHTML(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStFileToHTML(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStStreamToHTML(CL: TPSRuntimeClassImporter);
procedure RIRegister_StToHTML(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  //,Messages
  //,Graphics
  //,Controls
  //,Forms
  //,Dialogs
  ,StStrms
  ,StBase
  ,StToHTML
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StToHTML]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStFileToHTML(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStFileToHTML') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStFileToHTML') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
        RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Execute');
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
    RegisterProperty('CommentMarkers', 'TStringList', iptrw);
    RegisterProperty('EmbeddedHTML', 'TStringList', iptrw);
    RegisterProperty('InFileName', 'AnsiString', iptrw);
    RegisterProperty('InFixedLineLength', 'integer', iptrw);
    RegisterProperty('InLineTermChar', 'AnsiChar', iptrw);
    RegisterProperty('InLineTerminator', 'TStLineTerminator', iptrw);
    RegisterProperty('Keywords', 'TStringList', iptrw);
    RegisterProperty('OnProgress', 'TStOnProgressEvent', iptrw);
    RegisterProperty('OutFileName', 'AnsiString', iptrw);
    RegisterProperty('PageFooter', 'TStringList', iptrw);
    RegisterProperty('PageHeader', 'TStringList', iptrw);
    RegisterProperty('StringMarkers', 'TStringList', iptrw);
    RegisterProperty('WordDelimiters', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStStreamToHTML(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStStreamToHTML') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStStreamToHTML') do begin
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
    RegisterProperty('CommentMarkers', 'TStringList', iptrw);
    RegisterProperty('EmbeddedHTML', 'TStringList', iptrw);
    RegisterProperty('InFixedLineLength', 'integer', iptrw);
    RegisterProperty('InLineTermChar', 'AnsiChar', iptrw);
    RegisterProperty('InLineTerminator', 'TStLineTerminator', iptrw);
    RegisterProperty('InputStream', 'TStream', iptrw);
    RegisterProperty('Keywords', 'TStringList', iptrw);
    RegisterProperty('OnProgress', 'TStOnProgressEvent', iptrw);
    RegisterProperty('OutputStream', 'TStream', iptrw);
    RegisterProperty('PageFooter', 'TStringList', iptrw);
    RegisterProperty('PageHeader', 'TStringList', iptrw);
    RegisterProperty('StringMarkers', 'TStringList', iptrw);
    RegisterProperty('WordDelimiters', 'AnsiString', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure GenerateHTML');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StToHTML(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStOnProgressEvent', 'Procedure ( Sender : TObject; Percent : Word)');
  SIRegister_TStStreamToHTML(CL);
  SIRegister_TStFileToHTML(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLWordDelimiters_W(Self: TStFileToHTML; const T: AnsiString);
begin Self.WordDelimiters := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLWordDelimiters_R(Self: TStFileToHTML; var T: AnsiString);
begin T := Self.WordDelimiters; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLStringMarkers_W(Self: TStFileToHTML; const T: TStringList);
begin Self.StringMarkers := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLStringMarkers_R(Self: TStFileToHTML; var T: TStringList);
begin T := Self.StringMarkers; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLPageHeader_W(Self: TStFileToHTML; const T: TStringList);
begin Self.PageHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLPageHeader_R(Self: TStFileToHTML; var T: TStringList);
begin T := Self.PageHeader; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLPageFooter_W(Self: TStFileToHTML; const T: TStringList);
begin Self.PageFooter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLPageFooter_R(Self: TStFileToHTML; var T: TStringList);
begin T := Self.PageFooter; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLOutFileName_W(Self: TStFileToHTML; const T: AnsiString);
begin Self.OutFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLOutFileName_R(Self: TStFileToHTML; var T: AnsiString);
begin T := Self.OutFileName; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLOnProgress_W(Self: TStFileToHTML; const T: TStOnProgressEvent);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLOnProgress_R(Self: TStFileToHTML; var T: TStOnProgressEvent);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLKeywords_W(Self: TStFileToHTML; const T: TStringList);
begin Self.Keywords := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLKeywords_R(Self: TStFileToHTML; var T: TStringList);
begin T := Self.Keywords; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLInLineTerminator_W(Self: TStFileToHTML; const T: TStLineTerminator);
begin Self.InLineTerminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLInLineTerminator_R(Self: TStFileToHTML; var T: TStLineTerminator);
begin T := Self.InLineTerminator; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLInLineTermChar_W(Self: TStFileToHTML; const T: AnsiChar);
begin Self.InLineTermChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLInLineTermChar_R(Self: TStFileToHTML; var T: AnsiChar);
begin T := Self.InLineTermChar; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLInFixedLineLength_W(Self: TStFileToHTML; const T: integer);
begin Self.InFixedLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLInFixedLineLength_R(Self: TStFileToHTML; var T: integer);
begin T := Self.InFixedLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLInFileName_W(Self: TStFileToHTML; const T: AnsiString);
begin Self.InFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLInFileName_R(Self: TStFileToHTML; var T: AnsiString);
begin T := Self.InFileName; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLEmbeddedHTML_W(Self: TStFileToHTML; const T: TStringList);
begin Self.EmbeddedHTML := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLEmbeddedHTML_R(Self: TStFileToHTML; var T: TStringList);
begin T := Self.EmbeddedHTML; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLCommentMarkers_W(Self: TStFileToHTML; const T: TStringList);
begin Self.CommentMarkers := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLCommentMarkers_R(Self: TStFileToHTML; var T: TStringList);
begin T := Self.CommentMarkers; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLCaseSensitive_W(Self: TStFileToHTML; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TStFileToHTMLCaseSensitive_R(Self: TStFileToHTML; var T: Boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLWordDelimiters_W(Self: TStStreamToHTML; const T: AnsiString);
begin Self.WordDelimiters := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLWordDelimiters_R(Self: TStStreamToHTML; var T: AnsiString);
begin T := Self.WordDelimiters; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLStringMarkers_W(Self: TStStreamToHTML; const T: TStringList);
begin Self.StringMarkers := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLStringMarkers_R(Self: TStStreamToHTML; var T: TStringList);
begin T := Self.StringMarkers; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLPageHeader_W(Self: TStStreamToHTML; const T: TStringList);
begin Self.PageHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLPageHeader_R(Self: TStStreamToHTML; var T: TStringList);
begin T := Self.PageHeader; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLPageFooter_W(Self: TStStreamToHTML; const T: TStringList);
begin Self.PageFooter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLPageFooter_R(Self: TStStreamToHTML; var T: TStringList);
begin T := Self.PageFooter; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLOutputStream_W(Self: TStStreamToHTML; const T: TStream);
begin Self.OutputStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLOutputStream_R(Self: TStStreamToHTML; var T: TStream);
begin T := Self.OutputStream; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLOnProgress_W(Self: TStStreamToHTML; const T: TStOnProgressEvent);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLOnProgress_R(Self: TStStreamToHTML; var T: TStOnProgressEvent);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLKeywords_W(Self: TStStreamToHTML; const T: TStringList);
begin Self.Keywords := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLKeywords_R(Self: TStStreamToHTML; var T: TStringList);
begin T := Self.Keywords; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLInputStream_W(Self: TStStreamToHTML; const T: TStream);
begin Self.InputStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLInputStream_R(Self: TStStreamToHTML; var T: TStream);
begin T := Self.InputStream; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLInLineTerminator_W(Self: TStStreamToHTML; const T: TStLineTerminator);
begin Self.InLineTerminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLInLineTerminator_R(Self: TStStreamToHTML; var T: TStLineTerminator);
begin T := Self.InLineTerminator; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLInLineTermChar_W(Self: TStStreamToHTML; const T: AnsiChar);
begin Self.InLineTermChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLInLineTermChar_R(Self: TStStreamToHTML; var T: AnsiChar);
begin T := Self.InLineTermChar; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLInFixedLineLength_W(Self: TStStreamToHTML; const T: integer);
begin Self.InFixedLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLInFixedLineLength_R(Self: TStStreamToHTML; var T: integer);
begin T := Self.InFixedLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLEmbeddedHTML_W(Self: TStStreamToHTML; const T: TStringList);
begin Self.EmbeddedHTML := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLEmbeddedHTML_R(Self: TStStreamToHTML; var T: TStringList);
begin T := Self.EmbeddedHTML; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLCommentMarkers_W(Self: TStStreamToHTML; const T: TStringList);
begin Self.CommentMarkers := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLCommentMarkers_R(Self: TStStreamToHTML; var T: TStringList);
begin T := Self.CommentMarkers; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLCaseSensitive_W(Self: TStStreamToHTML; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamToHTMLCaseSensitive_R(Self: TStStreamToHTML; var T: Boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStFileToHTML(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStFileToHTML) do begin
    RegisterConstructor(@TStFileToHTML.Create, 'Create');
      RegisterMethod(@TStFileToHTML.Destroy, 'Free');
      RegisterMethod(@TStFileToHTML.Execute, 'Execute');
    RegisterPropertyHelper(@TStFileToHTMLCaseSensitive_R,@TStFileToHTMLCaseSensitive_W,'CaseSensitive');
    RegisterPropertyHelper(@TStFileToHTMLCommentMarkers_R,@TStFileToHTMLCommentMarkers_W,'CommentMarkers');
    RegisterPropertyHelper(@TStFileToHTMLEmbeddedHTML_R,@TStFileToHTMLEmbeddedHTML_W,'EmbeddedHTML');
    RegisterPropertyHelper(@TStFileToHTMLInFileName_R,@TStFileToHTMLInFileName_W,'InFileName');
    RegisterPropertyHelper(@TStFileToHTMLInFixedLineLength_R,@TStFileToHTMLInFixedLineLength_W,'InFixedLineLength');
    RegisterPropertyHelper(@TStFileToHTMLInLineTermChar_R,@TStFileToHTMLInLineTermChar_W,'InLineTermChar');
    RegisterPropertyHelper(@TStFileToHTMLInLineTerminator_R,@TStFileToHTMLInLineTerminator_W,'InLineTerminator');
    RegisterPropertyHelper(@TStFileToHTMLKeywords_R,@TStFileToHTMLKeywords_W,'Keywords');
    RegisterPropertyHelper(@TStFileToHTMLOnProgress_R,@TStFileToHTMLOnProgress_W,'OnProgress');
    RegisterPropertyHelper(@TStFileToHTMLOutFileName_R,@TStFileToHTMLOutFileName_W,'OutFileName');
    RegisterPropertyHelper(@TStFileToHTMLPageFooter_R,@TStFileToHTMLPageFooter_W,'PageFooter');
    RegisterPropertyHelper(@TStFileToHTMLPageHeader_R,@TStFileToHTMLPageHeader_W,'PageHeader');
    RegisterPropertyHelper(@TStFileToHTMLStringMarkers_R,@TStFileToHTMLStringMarkers_W,'StringMarkers');
    RegisterPropertyHelper(@TStFileToHTMLWordDelimiters_R,@TStFileToHTMLWordDelimiters_W,'WordDelimiters');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStStreamToHTML(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStStreamToHTML) do
  begin
    RegisterPropertyHelper(@TStStreamToHTMLCaseSensitive_R,@TStStreamToHTMLCaseSensitive_W,'CaseSensitive');
    RegisterPropertyHelper(@TStStreamToHTMLCommentMarkers_R,@TStStreamToHTMLCommentMarkers_W,'CommentMarkers');
    RegisterPropertyHelper(@TStStreamToHTMLEmbeddedHTML_R,@TStStreamToHTMLEmbeddedHTML_W,'EmbeddedHTML');
    RegisterPropertyHelper(@TStStreamToHTMLInFixedLineLength_R,@TStStreamToHTMLInFixedLineLength_W,'InFixedLineLength');
    RegisterPropertyHelper(@TStStreamToHTMLInLineTermChar_R,@TStStreamToHTMLInLineTermChar_W,'InLineTermChar');
    RegisterPropertyHelper(@TStStreamToHTMLInLineTerminator_R,@TStStreamToHTMLInLineTerminator_W,'InLineTerminator');
    RegisterPropertyHelper(@TStStreamToHTMLInputStream_R,@TStStreamToHTMLInputStream_W,'InputStream');
    RegisterPropertyHelper(@TStStreamToHTMLKeywords_R,@TStStreamToHTMLKeywords_W,'Keywords');
    RegisterPropertyHelper(@TStStreamToHTMLOnProgress_R,@TStStreamToHTMLOnProgress_W,'OnProgress');
    RegisterPropertyHelper(@TStStreamToHTMLOutputStream_R,@TStStreamToHTMLOutputStream_W,'OutputStream');
    RegisterPropertyHelper(@TStStreamToHTMLPageFooter_R,@TStStreamToHTMLPageFooter_W,'PageFooter');
    RegisterPropertyHelper(@TStStreamToHTMLPageHeader_R,@TStStreamToHTMLPageHeader_W,'PageHeader');
    RegisterPropertyHelper(@TStStreamToHTMLStringMarkers_R,@TStStreamToHTMLStringMarkers_W,'StringMarkers');
    RegisterPropertyHelper(@TStStreamToHTMLWordDelimiters_R,@TStStreamToHTMLWordDelimiters_W,'WordDelimiters');
    RegisterConstructor(@TStStreamToHTML.Create, 'Create');
    RegisterMethod(@TStStreamToHTML.GenerateHTML, 'GenerateHTML');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StToHTML(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStStreamToHTML(CL);
  RIRegister_TStFileToHTML(CL);
end;

 
 
{ TPSImport_StToHTML }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StToHTML.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StToHTML(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StToHTML.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StToHTML(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
