unit uPSI_SynURIOpener;
{
  at least
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
  TPSImport_SynURIOpener = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynURIOpener(CL: TPSPascalCompiler);
procedure SIRegister_SynURIOpener(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynURIOpener(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynURIOpener(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //Xlib
  Windows
  ,Types
  //,Qt
  //,QControls
  //,QSynEditTypes
  //,QSynEdit
  //,QSynHighlighterURI
  ,Controls
  ,SynEditTypes
  ,SynEdit
  ,SynHighlighterURI
  ,SynURIOpener
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynURIOpener]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynURIOpener(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSynURIOpener') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSynURIOpener') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function VisitedURI( URI : string) : Boolean');
    RegisterProperty('CtrlActivatesLinks', 'Boolean', iptrw);
    RegisterProperty('Editor', 'TCustomSynEdit', iptrw);
    RegisterProperty('URIHighlighter', 'TSynURISyn', iptrw);
    RegisterProperty('FtpClientCmd', 'string', iptrw);
    RegisterProperty('GopherClientCmd', 'string', iptrw);
    RegisterProperty('MailClientCmd', 'string', iptrw);
    RegisterProperty('NewsClientCmd', 'string', iptrw);
    RegisterProperty('NntpClientCmd', 'string', iptrw);
    RegisterProperty('ProsperoClientCmd', 'string', iptrw);
    RegisterProperty('TelnetClientCmd', 'string', iptrw);
    RegisterProperty('WaisClientCmd', 'string', iptrw);
    RegisterProperty('WebBrowserCmd', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynURIOpener(CL: TPSPascalCompiler);
begin
  SIRegister_TSynURIOpener(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
(*procedure TSynURIOpenerWebBrowserCmd_W(Self: TSynURIOpener; const T: string);
begin Self.WebBrowserCmd := T; end;

procedure TSynURIOpenerWebBrowserCmd_R(Self: TSynURIOpener; var T: string);
begin T := Self.WebBrowserCmd; end;

procedure TSynURIOpenerWaisClientCmd_W(Self: TSynURIOpener; const T: string);
begin Self.WaisClientCmd := T; end;

procedure TSynURIOpenerWaisClientCmd_R(Self: TSynURIOpener; var T: string);
begin T := Self.WaisClientCmd; end;

procedure TSynURIOpenerTelnetClientCmd_W(Self: TSynURIOpener; const T: string);
begin Self.TelnetClientCmd := T; end;

procedure TSynURIOpenerTelnetClientCmd_R(Self: TSynURIOpener; var T: string);
begin T := Self.TelnetClientCmd; end;

procedure TSynURIOpenerProsperoClientCmd_W(Self: TSynURIOpener; const T: string);
begin Self.ProsperoClientCmd := T; end;

procedure TSynURIOpenerProsperoClientCmd_R(Self: TSynURIOpener; var T: string);
begin T := Self.ProsperoClientCmd; end;

procedure TSynURIOpenerNntpClientCmd_W(Self: TSynURIOpener; const T: string);
begin Self.NntpClientCmd := T; end;

procedure TSynURIOpenerNntpClientCmd_R(Self: TSynURIOpener; var T: string);
begin T := Self.NntpClientCmd; end;

procedure TSynURIOpenerNewsClientCmd_W(Self: TSynURIOpener; const T: string);
begin Self.NewsClientCmd := T; end;

procedure TSynURIOpenerNewsClientCmd_R(Self: TSynURIOpener; var T: string);
begin T := Self.NewsClientCmd; end;

procedure TSynURIOpenerMailClientCmd_W(Self: TSynURIOpener; const T: string);
begin Self.MailClientCmd := T; end;

procedure TSynURIOpenerMailClientCmd_R(Self: TSynURIOpener; var T: string);
begin T := Self.MailClientCmd; end;

procedure TSynURIOpenerGopherClientCmd_W(Self: TSynURIOpener; const T: string);
begin Self.GopherClientCmd := T; end;

procedure TSynURIOpenerGopherClientCmd_R(Self: TSynURIOpener; var T: string);
begin T := Self.GopherClientCmd; end;

procedure TSynURIOpenerFtpClientCmd_W(Self: TSynURIOpener; const T: string);
begin Self.FtpClientCmd := T; end;

procedure TSynURIOpenerFtpClientCmd_R(Self: TSynURIOpener; var T: string);
begin T := Self.FtpClientCmd; end; *)

procedure TSynURIOpenerURIHighlighter_W(Self: TSynURIOpener; const T: TSynURISyn);
begin Self.URIHighlighter := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynURIOpenerURIHighlighter_R(Self: TSynURIOpener; var T: TSynURISyn);
begin T := Self.URIHighlighter; end;

(*----------------------------------------------------------------------------*)
procedure TSynURIOpenerEditor_W(Self: TSynURIOpener; const T: TCustomSynEdit);
begin Self.Editor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynURIOpenerEditor_R(Self: TSynURIOpener; var T: TCustomSynEdit);
begin T := Self.Editor; end;

(*----------------------------------------------------------------------------*)
procedure TSynURIOpenerCtrlActivatesLinks_W(Self: TSynURIOpener; const T: Boolean);
begin Self.CtrlActivatesLinks := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynURIOpenerCtrlActivatesLinks_R(Self: TSynURIOpener; var T: Boolean);
begin T := Self.CtrlActivatesLinks; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynURIOpener(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynURIOpener) do
  begin
    RegisterConstructor(@TSynURIOpener.Create, 'Create');
    RegisterMethod(@TSynURIOpener.VisitedURI, 'VisitedURI');
    RegisterPropertyHelper(@TSynURIOpenerCtrlActivatesLinks_R,@TSynURIOpenerCtrlActivatesLinks_W,'CtrlActivatesLinks');
    RegisterPropertyHelper(@TSynURIOpenerEditor_R,@TSynURIOpenerEditor_W,'Editor');
    RegisterPropertyHelper(@TSynURIOpenerURIHighlighter_R,@TSynURIOpenerURIHighlighter_W,'URIHighlighter');
    //RegisterPropertyHelper(@TSynURIOpenerFtpClientCmd_R,@TSynURIOpenerFtpClientCmd_W,'FtpClientCmd');
    //RegisterPropertyHelper(@TSynURIOpenerGopherClientCmd_R,@TSynURIOpenerGopherClientCmd_W,'GopherClientCmd');
    //RegisterPropertyHelper(@TSynURIOpenerMailClientCmd_R,@TSynURIOpenerMailClientCmd_W,'MailClientCmd');
    //RegisterPropertyHelper(@TSynURIOpenerNewsClientCmd_R,@TSynURIOpenerNewsClientCmd_W,'NewsClientCmd');
    //RegisterPropertyHelper(@TSynURIOpenerNntpClientCmd_R,@TSynURIOpenerNntpClientCmd_W,'NntpClientCmd');
    //RegisterPropertyHelper(@TSynURIOpenerProsperoClientCmd_R,@TSynURIOpenerProsperoClientCmd_W,'ProsperoClientCmd');
    //RegisterPropertyHelper(@TSynURIOpenerTelnetClientCmd_R,@TSynURIOpenerTelnetClientCmd_W,'TelnetClientCmd');
    //RegisterPropertyHelper(@TSynURIOpenerWaisClientCmd_R,@TSynURIOpenerWaisClientCmd_W,'WaisClientCmd');
    //RegisterPropertyHelper(@TSynURIOpenerWebBrowserCmd_R,@TSynURIOpenerWebBrowserCmd_W,'WebBrowserCmd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynURIOpener(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynURIOpener(CL);
end;

 
 
{ TPSImport_SynURIOpener }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynURIOpener.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynURIOpener(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynURIOpener.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynURIOpener(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
