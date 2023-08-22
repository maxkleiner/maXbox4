unit uPSI_ovcurl;
{
   url hot
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
  TPSImport_ovcurl = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcURL(CL: TPSPascalCompiler);
procedure SIRegister_ovcurl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcURL(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcurl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Dialogs
  ,ExtCtrls
  ,Graphics
  ,Menus
  ,ShellAPI
  ,Messages
  ,StdCtrls
  ,OvcVer
  ,ovcurl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcurl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcURL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomLabel', 'TOvcURL') do
  with CL.AddClassN(CL.FindClass('TCustomLabel'),'TOvcURL') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
   RegisterProperty('About', 'string', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('HighlightColor', 'TColor', iptrw);
    RegisterProperty('UnderlineURL', 'Boolean', iptrw);
    RegisterProperty('URL', 'string', iptrw);
    RegisterProperty('UseVisitedColor', 'Boolean', iptrw);
    RegisterProperty('VisitedColor', 'TColor', iptrw);
       REgisterPublishedProperties;
     RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     RegisterProperty('ParentColor', 'TColor', iptrw);
    RegisterProperty('BevelWidth','TBevelWidth',iptrw);
    //RegisterProperty('Parent','TWinControl',iptrw);
    // property Parent: TWinControl read FParent write SetParent;
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
    //  RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
     RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcurl(CL: TPSPascalCompiler);
begin
  SIRegister_TOvcURL(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcURLVisitedColor_W(Self: TOvcURL; const T: TColor);
begin Self.VisitedColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLVisitedColor_R(Self: TOvcURL; var T: TColor);
begin T := Self.VisitedColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLUseVisitedColor_W(Self: TOvcURL; const T: Boolean);
begin Self.UseVisitedColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLUseVisitedColor_R(Self: TOvcURL; var T: Boolean);
begin T := Self.UseVisitedColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLURL_W(Self: TOvcURL; const T: string);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLURL_R(Self: TOvcURL; var T: string);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLUnderlineURL_W(Self: TOvcURL; const T: Boolean);
begin Self.UnderlineURL := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLUnderlineURL_R(Self: TOvcURL; var T: Boolean);
begin T := Self.UnderlineURL; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLHighlightColor_W(Self: TOvcURL; const T: TColor);
begin Self.HighlightColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLHighlightColor_R(Self: TOvcURL; var T: TColor);
begin T := Self.HighlightColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLCaption_W(Self: TOvcURL; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLCaption_R(Self: TOvcURL; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLAbout_W(Self: TOvcURL; const T: string);
begin Self.About := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcURLAbout_R(Self: TOvcURL; var T: string);
begin T := Self.About; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcURL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcURL) do begin
    RegisterConstructor(@TOvcURL.Create, 'Create');
    RegisterMethod(@TOvcURL.Destroy, 'Free');
    RegisterPropertyHelper(@TOvcURLAbout_R,@TOvcURLAbout_W,'About');
    RegisterPropertyHelper(@TOvcURLCaption_R,@TOvcURLCaption_W,'Caption');
    RegisterPropertyHelper(@TOvcURLHighlightColor_R,@TOvcURLHighlightColor_W,'HighlightColor');
    RegisterPropertyHelper(@TOvcURLUnderlineURL_R,@TOvcURLUnderlineURL_W,'UnderlineURL');
    RegisterPropertyHelper(@TOvcURLURL_R,@TOvcURLURL_W,'URL');
    RegisterPropertyHelper(@TOvcURLUseVisitedColor_R,@TOvcURLUseVisitedColor_W,'UseVisitedColor');
    RegisterPropertyHelper(@TOvcURLVisitedColor_R,@TOvcURLVisitedColor_W,'VisitedColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcurl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcURL(CL);
end;

 
 
{ TPSImport_ovcurl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcurl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcurl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcurl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcurl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
