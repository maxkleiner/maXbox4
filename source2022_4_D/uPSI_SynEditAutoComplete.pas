unit uPSI_SynEditAutoComplete;
{
  put around a rext  clash with syncompletion proposal

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
  TPSImport_SynEditAutoComplete = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynAutoComplete(CL: TPSPascalCompiler);
procedure SIRegister_TCustomSynAutoComplete(CL: TPSPascalCompiler);
procedure SIRegister_SynEditAutoComplete(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynAutoComplete(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomSynAutoComplete(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynEditAutoComplete(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   {Qt
  ,QMenus
  ,Types
  ,QSynEdit
  ,QSynEditKeyCmds}
  Windows
  ,Menus
  ,SynEdit
  ,SynEditKeyCmds
  ,SynEditAutoComplete
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEditAutoComplete]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynAutoComplete(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSynAutoComplete', 'TSynAutoComplete') do
  with CL.AddClassN(CL.FindClass('TCustomSynAutoComplete'),'TSynAutoComplete') do begin
   registerpublishedproperties;
    RegisterProperty('AutoCompleteList', 'TStrings', iptrw);
    RegisterProperty('CaseSensitive', 'boolean', iptrw);
      RegisterProperty('Editor', 'TCustomSynEdit', iptrw);
    RegisterProperty('EndOfTokenChr', 'string', iptrw);
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomSynAutoComplete(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomSynAutoComplete') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomSynAutoComplete') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Function AddEditor( AEditor : TCustomSynEdit) : boolean');
    RegisterMethod('Function RemoveEditor( AEditor : TCustomSynEdit) : boolean');
    RegisterMethod('Procedure AddCompletion( const AToken, AValue, AComment : string)');
    RegisterMethod('Procedure Execute( AEditor : TCustomSynEdit)');
    RegisterMethod('Procedure ExecuteCompletion( const AToken : string; AEditor : TCustomSynEdit)');
    RegisterMethod('Procedure ParseCompletionList');
    RegisterProperty('AutoCompleteList', 'TStrings', iptrw);
    RegisterProperty('CaseSensitive', 'boolean', iptrw);
    RegisterProperty('Completions', 'TStrings', iptr);
    RegisterProperty('CompletionComments', 'TStrings', iptr);
    RegisterProperty('CompletionValues', 'TStrings', iptr);
    RegisterProperty('Editor', 'TCustomSynEdit', iptrw);
    RegisterProperty('EditorCount', 'integer', iptr);
    RegisterProperty('Editors', 'TCustomSynEdit integer', iptr);
    RegisterProperty('EndOfTokenChr', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEditAutoComplete(CL: TPSPascalCompiler);
begin
  SIRegister_TCustomSynAutoComplete(CL);
  //SIRegister_TSynAutoComplete(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteEndOfTokenChr_W(Self: TCustomSynAutoComplete; const T: string);
begin Self.EndOfTokenChr := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteEndOfTokenChr_R(Self: TCustomSynAutoComplete; var T: string);
begin T := Self.EndOfTokenChr; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteEditors_R(Self: TCustomSynAutoComplete; var T: TCustomSynEdit; const t1: integer);
begin T := Self.Editors[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteEditorCount_R(Self: TCustomSynAutoComplete; var T: integer);
begin T := Self.EditorCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteEditor_W(Self: TCustomSynAutoComplete; const T: TCustomSynEdit);
begin Self.Editor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteEditor_R(Self: TCustomSynAutoComplete; var T: TCustomSynEdit);
begin T := Self.Editor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteCompletionValues_R(Self: TCustomSynAutoComplete; var T: TStrings);
begin T := Self.CompletionValues; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteCompletionComments_R(Self: TCustomSynAutoComplete; var T: TStrings);
begin T := Self.CompletionComments; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteCompletions_R(Self: TCustomSynAutoComplete; var T: TStrings);
begin T := Self.Completions; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteCaseSensitive_W(Self: TCustomSynAutoComplete; const T: boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteCaseSensitive_R(Self: TCustomSynAutoComplete; var T: boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteAutoCompleteList_W(Self: TCustomSynAutoComplete; const T: TStrings);
begin Self.AutoCompleteList := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynAutoCompleteAutoCompleteList_R(Self: TCustomSynAutoComplete; var T: TStrings);
begin T := Self.AutoCompleteList; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynAutoComplete(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynAutoComplete) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomSynAutoComplete(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomSynAutoComplete) do begin
    RegisterConstructor(@TCustomSynAutoComplete.Create, 'Create');
       RegisterMethod(@TCustomSynAutoComplete.Destroy, 'Free');
       RegisterMethod(@TCustomSynAutoComplete.AddEditor, 'AddEditor');
    RegisterMethod(@TCustomSynAutoComplete.RemoveEditor, 'RemoveEditor');
    RegisterMethod(@TCustomSynAutoComplete.AddCompletion, 'AddCompletion');
    RegisterVirtualMethod(@TCustomSynAutoComplete.Execute, 'Execute');
    RegisterVirtualMethod(@TCustomSynAutoComplete.ExecuteCompletion, 'ExecuteCompletion');
    RegisterVirtualMethod(@TCustomSynAutoComplete.ParseCompletionList, 'ParseCompletionList');
    RegisterPropertyHelper(@TCustomSynAutoCompleteAutoCompleteList_R,@TCustomSynAutoCompleteAutoCompleteList_W,'AutoCompleteList');
    RegisterPropertyHelper(@TCustomSynAutoCompleteCaseSensitive_R,@TCustomSynAutoCompleteCaseSensitive_W,'CaseSensitive');
    RegisterPropertyHelper(@TCustomSynAutoCompleteCompletions_R,nil,'Completions');
    RegisterPropertyHelper(@TCustomSynAutoCompleteCompletionComments_R,nil,'CompletionComments');
    RegisterPropertyHelper(@TCustomSynAutoCompleteCompletionValues_R,nil,'CompletionValues');
    RegisterPropertyHelper(@TCustomSynAutoCompleteEditor_R,@TCustomSynAutoCompleteEditor_W,'Editor');
    RegisterPropertyHelper(@TCustomSynAutoCompleteEditorCount_R,nil,'EditorCount');
    RegisterPropertyHelper(@TCustomSynAutoCompleteEditors_R,nil,'Editors');
    RegisterPropertyHelper(@TCustomSynAutoCompleteEndOfTokenChr_R,@TCustomSynAutoCompleteEndOfTokenChr_W,'EndOfTokenChr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditAutoComplete(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomSynAutoComplete(CL);
  //RIRegister_TSynAutoComplete(CL);
end;



{ TPSImport_SynEditAutoComplete }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditAutoComplete.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEditAutoComplete(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditAutoComplete.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynEditAutoComplete(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
