unit uPSI_JvStringListToHtml;
{
   to html
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
  TPSImport_JvStringListToHtml = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvStringListToHtml(CL: TPSPascalCompiler);
procedure SIRegister_JvStringListToHtml(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvStringListToHtml(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvStringListToHtml(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  JvComponentBase
  ,JvStringListToHtml
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvStringListToHtml]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvStringListToHtml(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvStringListToHtml') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvStringListToHtml') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ConvertToHTML( Source : TStrings; const FileName : string)');
    RegisterMethod('Procedure ConvertToHTMLStrings( Source, Destination : TStrings)');
    RegisterProperty('HTML', 'TStrings', iptrw);
    RegisterProperty('Strings', 'TStrings', iptrw);
    RegisterProperty('HTMLLineBreak', 'string', iptrw);
    RegisterProperty('HTMLTitle', 'string', iptrw);
    RegisterProperty('IncludeHeader', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvStringListToHtml(CL: TPSPascalCompiler);
begin
  SIRegister_TJvStringListToHtml(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvStringListToHtmlIncludeHeader_W(Self: TJvStringListToHtml; const T: Boolean);
begin Self.IncludeHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStringListToHtmlIncludeHeader_R(Self: TJvStringListToHtml; var T: Boolean);
begin T := Self.IncludeHeader; end;

(*----------------------------------------------------------------------------*)
procedure TJvStringListToHtmlHTMLTitle_W(Self: TJvStringListToHtml; const T: string);
begin Self.HTMLTitle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStringListToHtmlHTMLTitle_R(Self: TJvStringListToHtml; var T: string);
begin T := Self.HTMLTitle; end;

(*----------------------------------------------------------------------------*)
procedure TJvStringListToHtmlHTMLLineBreak_W(Self: TJvStringListToHtml; const T: string);
begin Self.HTMLLineBreak := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStringListToHtmlHTMLLineBreak_R(Self: TJvStringListToHtml; var T: string);
begin T := Self.HTMLLineBreak; end;

(*----------------------------------------------------------------------------*)
procedure TJvStringListToHtmlStrings_W(Self: TJvStringListToHtml; const T: TStrings);
begin Self.Strings := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStringListToHtmlStrings_R(Self: TJvStringListToHtml; var T: TStrings);
begin T := Self.Strings; end;

(*----------------------------------------------------------------------------*)
procedure TJvStringListToHtmlHTML_W(Self: TJvStringListToHtml; const T: TStrings);
begin Self.HTML := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStringListToHtmlHTML_R(Self: TJvStringListToHtml; var T: TStrings);
begin T := Self.HTML; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvStringListToHtml(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvStringListToHtml) do begin
    RegisterConstructor(@TJvStringListToHtml.Create, 'Create');
    RegisterMethod(@TJvStringListToHtml.Destroy, 'Free');
    RegisterMethod(@TJvStringListToHtml.ConvertToHTML, 'ConvertToHTML');
    RegisterMethod(@TJvStringListToHtml.ConvertToHTMLStrings, 'ConvertToHTMLStrings');
    RegisterPropertyHelper(@TJvStringListToHtmlHTML_R,@TJvStringListToHtmlHTML_W,'HTML');
    RegisterPropertyHelper(@TJvStringListToHtmlStrings_R,@TJvStringListToHtmlStrings_W,'Strings');
    RegisterPropertyHelper(@TJvStringListToHtmlHTMLLineBreak_R,@TJvStringListToHtmlHTMLLineBreak_W,'HTMLLineBreak');
    RegisterPropertyHelper(@TJvStringListToHtmlHTMLTitle_R,@TJvStringListToHtmlHTMLTitle_W,'HTMLTitle');
    RegisterPropertyHelper(@TJvStringListToHtmlIncludeHeader_R,@TJvStringListToHtmlIncludeHeader_W,'IncludeHeader');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvStringListToHtml(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvStringListToHtml(CL);
end;

 
 
{ TPSImport_JvStringListToHtml }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStringListToHtml.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvStringListToHtml(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStringListToHtml.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvStringListToHtml(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
