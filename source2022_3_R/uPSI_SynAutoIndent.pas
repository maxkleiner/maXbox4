unit uPSI_SynAutoIndent;
{
   syn and sys pup
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
  TPSImport_SynAutoIndent = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynAutoIndent(CL: TPSPascalCompiler);
procedure SIRegister_TSynCustomAutoIndent(CL: TPSPascalCompiler);
procedure SIRegister_SynAutoIndent(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SynAutoIndent_Routines(S: TPSExec);
procedure RIRegister_TSynAutoIndent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynCustomAutoIndent(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynAutoIndent(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  { Qt
  ,QGraphics
  ,QControls
  ,QForms
  ,QDialogs
  ,QSynEdit
  ,QSynEditKeyCmds}
  Messages
  ,SynEdit
  ,SynEditKeyCmds
  ,SynAutoIndent
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynAutoIndent]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynAutoIndent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynCustomAutoIndent', 'TSynAutoIndent') do
  with CL.AddClassN(CL.FindClass('TSynCustomAutoIndent'),'TSynAutoIndent') do begin
  registerpublishedproperties;
       RegisterProperty('Editor', 'TSynEdit', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('IndentChars', 'string', iptrw);
    RegisterProperty('UnIndentChars', 'string', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynCustomAutoIndent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSynCustomAutoIndent') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSynCustomAutoIndent') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Editor', 'TSynEdit', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('IndentChars', 'string', iptrw);
    RegisterProperty('UnIndentChars', 'string', iptrw);
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Tag', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynAutoIndent(CL: TPSPascalCompiler);
begin
  SIRegister_TSynCustomAutoIndent(CL);
  SIRegister_TSynAutoIndent(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynCustomAutoIndentUnIndentChars_W(Self: TSynCustomAutoIndent; const T: string);
begin Self.UnIndentChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomAutoIndentUnIndentChars_R(Self: TSynCustomAutoIndent; var T: string);
begin T := Self.UnIndentChars; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomAutoIndentIndentChars_W(Self: TSynCustomAutoIndent; const T: string);
begin Self.IndentChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomAutoIndentIndentChars_R(Self: TSynCustomAutoIndent; var T: string);
begin T := Self.IndentChars; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomAutoIndentEnabled_W(Self: TSynCustomAutoIndent; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomAutoIndentEnabled_R(Self: TSynCustomAutoIndent; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomAutoIndentEditor_W(Self: TSynCustomAutoIndent; const T: TSynEdit);
begin Self.Editor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomAutoIndentEditor_R(Self: TSynCustomAutoIndent; var T: TSynEdit);
begin T := Self.Editor; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynAutoIndent_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynAutoIndent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynAutoIndent) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynCustomAutoIndent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynCustomAutoIndent) do
  begin
    RegisterConstructor(@TSynCustomAutoIndent.Create, 'Create');
    RegisterPropertyHelper(@TSynCustomAutoIndentEditor_R,@TSynCustomAutoIndentEditor_W,'Editor');
    RegisterPropertyHelper(@TSynCustomAutoIndentEnabled_R,@TSynCustomAutoIndentEnabled_W,'Enabled');
    RegisterPropertyHelper(@TSynCustomAutoIndentIndentChars_R,@TSynCustomAutoIndentIndentChars_W,'IndentChars');
    RegisterPropertyHelper(@TSynCustomAutoIndentUnIndentChars_R,@TSynCustomAutoIndentUnIndentChars_W,'UnIndentChars');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynAutoIndent(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynCustomAutoIndent(CL);
  RIRegister_TSynAutoIndent(CL);
end;

 
 
{ TPSImport_SynAutoIndent }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynAutoIndent.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynAutoIndent(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynAutoIndent.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynAutoIndent(ri);
  //RIRegister_SynAutoIndent_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
