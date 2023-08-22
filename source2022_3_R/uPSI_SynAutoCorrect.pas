unit uPSI_SynAutoCorrect;
{
with auto indent
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
  TPSImport_SynAutoCorrect = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynAutoCorrect(CL: TPSPascalCompiler);
procedure SIRegister_TCustomSynAutoCorrect(CL: TPSPascalCompiler);
procedure SIRegister_SynAutoCorrect(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynAutoCorrect(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomSynAutoCorrect(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynAutoCorrect(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
 { ,Libc
  ,QGraphics
  ,QControls
  ,QForms
  ,QDialogs
  ,Types
  ,QSynEditMiscProcs
  ,QSynEditTypes
  ,QSynEditKeyCmds
  ,QSynEdit   }
  ,Registry
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,SynEditMiscProcs
  ,SynEditTypes
  ,SynEditKeyCmds
  ,SynEdit
  ,SynEditMiscClasses
  ,IniFiles
  ,SynAutoCorrect
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynAutoCorrect]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynAutoCorrect(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSynAutoCorrect', 'TSynAutoCorrect') do
  with CL.AddClassN(CL.FindClass('TCustomSynAutoCorrect'),'TSynAutoCorrect') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomSynAutoCorrect(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomSynAutoCorrect') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomSynAutoCorrect') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Add( AOriginal, ACorrection : string)');
    RegisterMethod('Function AutoCorrectAll : Boolean');
    RegisterMethod('Procedure Delete( AIndex : Integer)');
    RegisterMethod('Procedure Edit( AIndex : Integer; ANewOriginal, ANewCorrection : string)');
    RegisterMethod('Procedure LoadFromINI( AFileName, ASection : string)');
    RegisterMethod('Procedure SaveToINI( AFileName, ASection : string)');
    RegisterMethod('Procedure LoadFromRegistry( ARoot : DWORD; AKey : string)');
    RegisterMethod('Procedure SaveToRegistry( ARoot : DWORD; AKey : string)');
    RegisterMethod('Function LoadFromList( AFileName : string) : Boolean');
    RegisterMethod('Procedure SaveToList( AFileName : string)');
    RegisterMethod('Function HalfString( Str : string; GetFirstHalf : Boolean) : string');
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Editor', 'TCustomSynEdit', iptrw);
    RegisterProperty('Items', 'TStrings', iptrw);
    RegisterProperty('ItemSepChar', 'Char', iptrw);
    RegisterProperty('Options', 'TAsSynAutoCorrectOptions', iptrw);
    RegisterProperty('OnAutoCorrect', 'TAutoCorrectEvent', iptrw);
    RegisterProperty('OnCorrected', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynAutoCorrect(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TAsSynAutoCorrectOption', '( ascoCorrectOnMouseDown, ascoIgnoreC'
   +'ase, ascoMaintainCase )');
  CL.AddTypeS('TAsSynAutoCorrectOptions', 'set of TAsSynAutoCorrectOption');
  CL.AddTypeS('TAutoCorrectAction', '( aaCorrect, aaAbort )');
  CL.AddTypeS('TAutoCorrectEvent', 'Procedure ( Sender : TObject; const AOrigin'
   +'al, ACorrection : string; Line, Column : Integer; var Action : TAutoCorrectAction)');
  SIRegister_TCustomSynAutoCorrect(CL);
  SIRegister_TSynAutoCorrect(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectOnCorrected_W(Self: TCustomSynAutoCorrect; const T: TNotifyEvent);
begin Self.OnCorrected := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectOnCorrected_R(Self: TCustomSynAutoCorrect; var T: TNotifyEvent);
begin T := Self.OnCorrected; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectOnAutoCorrect_W(Self: TCustomSynAutoCorrect; const T: TAutoCorrectEvent);
begin Self.OnAutoCorrect := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectOnAutoCorrect_R(Self: TCustomSynAutoCorrect; var T: TAutoCorrectEvent);
begin T := Self.OnAutoCorrect; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectOptions_W(Self: TCustomSynAutoCorrect; const T: TAsSynAutoCorrectOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectOptions_R(Self: TCustomSynAutoCorrect; var T: TAsSynAutoCorrectOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectItemSepChar_W(Self: TCustomSynAutoCorrect; const T: Char);
begin Self.ItemSepChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectItemSepChar_R(Self: TCustomSynAutoCorrect; var T: Char);
begin T := Self.ItemSepChar; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectItems_W(Self: TCustomSynAutoCorrect; const T: TStrings);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectItems_R(Self: TCustomSynAutoCorrect; var T: TStrings);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectEditor_W(Self: TCustomSynAutoCorrect; const T: TCustomSynEdit);
begin Self.Editor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectEditor_R(Self: TCustomSynAutoCorrect; var T: TCustomSynEdit);
begin T := Self.Editor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectEnabled_W(Self: TCustomSynAutoCorrect; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCorrectEnabled_R(Self: TCustomSynAutoCorrect; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynAutoCorrect(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynAutoCorrect) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomSynAutoCorrect(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomSynAutoCorrect) do begin
    RegisterConstructor(@TCustomSynAutoCorrect.Create, 'Create');
       RegisterMethod(@TCustomSynAutoCorrect.Destroy, 'Free');
     RegisterMethod(@TCustomSynAutoCorrect.Add, 'Add');
    RegisterMethod(@TCustomSynAutoCorrect.AutoCorrectAll, 'AutoCorrectAll');
    RegisterMethod(@TCustomSynAutoCorrect.Delete, 'Delete');
    RegisterMethod(@TCustomSynAutoCorrect.Edit, 'Edit');
    RegisterMethod(@TCustomSynAutoCorrect.LoadFromINI, 'LoadFromINI');
    RegisterMethod(@TCustomSynAutoCorrect.SaveToINI, 'SaveToINI');
    RegisterMethod(@TCustomSynAutoCorrect.LoadFromRegistry, 'LoadFromRegistry');
    RegisterMethod(@TCustomSynAutoCorrect.SaveToRegistry, 'SaveToRegistry');
    RegisterMethod(@TCustomSynAutoCorrect.LoadFromList, 'LoadFromList');
    RegisterMethod(@TCustomSynAutoCorrect.SaveToList, 'SaveToList');
    RegisterMethod(@TCustomSynAutoCorrect.HalfString, 'HalfString');
    RegisterPropertyHelper(@TCustomSynAutoCorrectEnabled_R,@TCustomSynAutoCorrectEnabled_W,'Enabled');
    RegisterPropertyHelper(@TCustomSynAutoCorrectEditor_R,@TCustomSynAutoCorrectEditor_W,'Editor');
    RegisterPropertyHelper(@TCustomSynAutoCorrectItems_R,@TCustomSynAutoCorrectItems_W,'Items');
    RegisterPropertyHelper(@TCustomSynAutoCorrectItemSepChar_R,@TCustomSynAutoCorrectItemSepChar_W,'ItemSepChar');
    RegisterPropertyHelper(@TCustomSynAutoCorrectOptions_R,@TCustomSynAutoCorrectOptions_W,'Options');
    RegisterPropertyHelper(@TCustomSynAutoCorrectOnAutoCorrect_R,@TCustomSynAutoCorrectOnAutoCorrect_W,'OnAutoCorrect');
    RegisterPropertyHelper(@TCustomSynAutoCorrectOnCorrected_R,@TCustomSynAutoCorrectOnCorrected_W,'OnCorrected');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynAutoCorrect(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomSynAutoCorrect(CL);
  RIRegister_TSynAutoCorrect(CL);
end;

 
 
{ TPSImport_SynAutoCorrect }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynAutoCorrect.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynAutoCorrect(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynAutoCorrect.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynAutoCorrect(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
