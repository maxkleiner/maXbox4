unit uPSI_HyperLabel;
{
  from mX4
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
  TPSImport_HyperLabel = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THyperLabel(CL: TPSPascalCompiler);
procedure SIRegister_HyperLabel(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_HyperLabel_Routines(S: TPSExec);
procedure RIRegister_THyperLabel(CL: TPSRuntimeClassImporter);
procedure RIRegister_HyperLabel(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  //,Controls
  //,StdCtrls
  ,HyperLabel
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HyperLabel]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THyperLabel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomLabel', 'THyperLabel') do
  with CL.AddClassN(CL.FindClass('TCustomLabel'),'THyperLabel') do begin
  RegisterPublishedProperties;
    RegisterMethod('Constructor create( aOwner : TComponent)');
    RegisterProperty('HyperlinkColor', 'TColor', iptrw);
    RegisterProperty('HyperlinkStyle', 'TFontStyles', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    //RegisterProperty('Caption', 'TCaption', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('PARENTShowhint', 'Boolean', iptrw);
    RegisterProperty('Showhint', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
    //RegisterProperty('SCROLLBARS', 'TScrollStyle', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HyperLabel(CL: TPSPascalCompiler);
begin
  SIRegister_THyperLabel(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THyperLabelHyperlinkStyle_W(Self: THyperLabel; const T: TFontStyles);
begin Self.HyperlinkStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure THyperLabelHyperlinkStyle_R(Self: THyperLabel; var T: TFontStyles);
begin T := Self.HyperlinkStyle; end;

(*----------------------------------------------------------------------------*)
procedure THyperLabelHyperlinkColor_W(Self: THyperLabel; const T: TColor);
begin Self.HyperlinkColor := T; end;

(*----------------------------------------------------------------------------*)
procedure THyperLabelHyperlinkColor_R(Self: THyperLabel; var T: TColor);
begin T := Self.HyperlinkColor; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HyperLabel_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THyperLabel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THyperLabel) do
  begin
    RegisterConstructor(@THyperLabel.create, 'create');
    RegisterPropertyHelper(@THyperLabelHyperlinkColor_R,@THyperLabelHyperlinkColor_W,'HyperlinkColor');
    RegisterPropertyHelper(@THyperLabelHyperlinkStyle_R,@THyperLabelHyperlinkStyle_W,'HyperlinkStyle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HyperLabel(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THyperLabel(CL);
end;

 
 
{ TPSImport_HyperLabel }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HyperLabel.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HyperLabel(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HyperLabel.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_HyperLabel(ri);
  RIRegister_HyperLabel_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
