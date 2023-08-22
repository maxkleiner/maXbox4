unit uPSI_TabNotBk;
{
   notebook
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
  TPSImport_TabNotBk = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTabbedNotebook(CL: TPSPascalCompiler);
procedure SIRegister_TTabPage(CL: TPSPascalCompiler);
procedure SIRegister_TabNotBk(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTabbedNotebook(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTabPage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TabNotBk(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StdCtrls
  ,Forms
  ,Messages
  ,Graphics
  ,Controls
  ,ComCtrls
  ,TabNotBk
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TabNotBk]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTabbedNotebook(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTabControl', 'TTabbedNotebook') do
  with CL.AddClassN(CL.FindClass('TCustomTabControl'),'TTabbedNotebook') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function GetIndexForPage( const PageName : string) : Integer');
    RegisterProperty('TopFont', 'TFont', iptr);
    RegisterMethod('Procedure TabFontChanged( Sender : TObject)');
    RegisterProperty('ActivePage', 'string', iptrw);
    RegisterProperty('PageIndex', 'Integer', iptrw);
    RegisterProperty('Pages', 'TStrings', iptrw);
    RegisterProperty('TabsPerRow', 'Integer', iptrw);
    RegisterProperty('TabFont', 'TFont', iptrw);
    RegisterProperty('OnClick', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChange', 'TPageChangeEvent', iptrw);
   RegisterPublishedProperties;
    RegisterProperty('CANCEL', 'BOOLEAN', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('DEFAULT', 'BOOLEAN', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('MODALRESULT', 'LONGINT', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTabPage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TTabPage') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TTabPage') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TabNotBk(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('CM_TABFONTCHANGED','LongInt').SetInt( CM_BASE + 100);
  CL.AddTypeS('TPageChangeEvent', 'Procedure ( Sender : TObject; NewTab : Integ'
   +'er; var AllowChange : Boolean)');
  SIRegister_TTabPage(CL);
  SIRegister_TTabbedNotebook(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookOnChange_W(Self: TTabbedNotebook; const T: TPageChangeEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookOnChange_R(Self: TTabbedNotebook; var T: TPageChangeEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookOnClick_W(Self: TTabbedNotebook; const T: TNotifyEvent);
begin Self.OnClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookOnClick_R(Self: TTabbedNotebook; var T: TNotifyEvent);
begin T := Self.OnClick; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookTabFont_W(Self: TTabbedNotebook; const T: TFont);
begin Self.TabFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookTabFont_R(Self: TTabbedNotebook; var T: TFont);
begin T := Self.TabFont; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookTabsPerRow_W(Self: TTabbedNotebook; const T: Integer);
begin Self.TabsPerRow := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookTabsPerRow_R(Self: TTabbedNotebook; var T: Integer);
begin T := Self.TabsPerRow; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookPages_W(Self: TTabbedNotebook; const T: TStrings);
begin Self.Pages := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookPages_R(Self: TTabbedNotebook; var T: TStrings);
begin T := Self.Pages; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookPageIndex_W(Self: TTabbedNotebook; const T: Integer);
begin Self.PageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookPageIndex_R(Self: TTabbedNotebook; var T: Integer);
begin T := Self.PageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookActivePage_W(Self: TTabbedNotebook; const T: string);
begin Self.ActivePage := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookActivePage_R(Self: TTabbedNotebook; var T: string);
begin T := Self.ActivePage; end;

(*----------------------------------------------------------------------------*)
procedure TTabbedNotebookTopFont_R(Self: TTabbedNotebook; var T: TFont);
begin T := Self.TopFont; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTabbedNotebook(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTabbedNotebook) do begin
    RegisterConstructor(@TTabbedNotebook.Create, 'Create');
       RegisterMethod(@TTabbedNotebook.Free, 'Free');
    RegisterMethod(@TTabbedNotebook.GetIndexForPage, 'GetIndexForPage');
    RegisterPropertyHelper(@TTabbedNotebookTopFont_R,nil,'TopFont');
    RegisterMethod(@TTabbedNotebook.TabFontChanged, 'TabFontChanged');
    RegisterPropertyHelper(@TTabbedNotebookActivePage_R,@TTabbedNotebookActivePage_W,'ActivePage');
    RegisterPropertyHelper(@TTabbedNotebookPageIndex_R,@TTabbedNotebookPageIndex_W,'PageIndex');
    RegisterPropertyHelper(@TTabbedNotebookPages_R,@TTabbedNotebookPages_W,'Pages');
    RegisterPropertyHelper(@TTabbedNotebookTabsPerRow_R,@TTabbedNotebookTabsPerRow_W,'TabsPerRow');
    RegisterPropertyHelper(@TTabbedNotebookTabFont_R,@TTabbedNotebookTabFont_W,'TabFont');
    RegisterPropertyHelper(@TTabbedNotebookOnClick_R,@TTabbedNotebookOnClick_W,'OnClick');
    RegisterPropertyHelper(@TTabbedNotebookOnChange_R,@TTabbedNotebookOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTabPage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTabPage) do
  begin
    RegisterConstructor(@TTabPage.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TabNotBk(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTabPage(CL);
  RIRegister_TTabbedNotebook(CL);
end;

 
 
{ TPSImport_TabNotBk }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TabNotBk.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TabNotBk(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TabNotBk.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TabNotBk(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
