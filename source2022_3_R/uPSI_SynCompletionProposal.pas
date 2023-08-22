unit uPSI_SynCompletionProposal;
{
chek    SIRegister_TSynAutoComplete   with tcodecompletion

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
  TPSImport_SynCompletionProposal = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TProposalColumns(CL: TPSPascalCompiler);
procedure SIRegister_TProposalColumn(CL: TPSPascalCompiler);
procedure SIRegister_TSynAutoComplete(CL: TPSPascalCompiler);
procedure SIRegister_TSynCompletionProposal(CL: TPSPascalCompiler);
procedure SIRegister_TSynBaseCompletionProposal(CL: TPSPascalCompiler);
procedure SIRegister_TSynBaseCompletionProposalForm(CL: TPSPascalCompiler);
procedure SIRegister_SynCompletionProposal(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SynCompletionProposal_Routines(S: TPSExec);
procedure RIRegister_TProposalColumns(CL: TPSRuntimeClassImporter);
procedure RIRegister_TProposalColumn(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynAutoComplete(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynCompletionProposal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynBaseCompletionProposal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynBaseCompletionProposalForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynCompletionProposal(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  { Qt
  ,Types
  ,QControls
  ,QGraphics
  ,QForms
  ,QStdCtrls
  ,QExtCtrls
  ,QMenus
  ,QImgList
  ,QDialogs
  ,QSynEditTypes
  ,QSynEditKeyCmds
  ,QSynEditHighlighter
  ,QSynEditKbdHandler
  ,QSynEdit   }
  Windows
  ,Messages
  ,Graphics
  ,Forms
  ,Controls
  ,StdCtrls
  ,ExtCtrls
  ,Menus
  ,Dialogs
  ,SynEditTypes
  ,SynEditKeyCmds
  ,SynEditHighlighter
  ,SynEditKbdHandler
  ,SynEdit
  ,SynCompletionProposal
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynCompletionProposal]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TProposalColumns(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TProposalColumns') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TProposalColumns') do begin
    RegisterMethod('Constructor Create( AOwner : TPersistent; ItemClass : TCollectionItemClass)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Function Add : TProposalColumn');
    RegisterMethod('Function FindItemID( ID : Integer) : TProposalColumn');
    RegisterMethod('Function Insert( Index : Integer) : TProposalColumn');
    RegisterProperty('Items', 'TProposalColumn Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TProposalColumn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TProposalColumn') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TProposalColumn') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('BiggestWord', 'string', iptrw);
    RegisterProperty('DefaultFontStyle', 'TFontStyles', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynAutoComplete(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSynAutoComplete') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSynAutoComplete') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Execute( token : string; Editor : TCustomSynEdit)');
    RegisterMethod('Procedure ExecuteEx( token : String; Editor : TCustomSynEdit; LookupIfNotExact : Boolean)');
    RegisterMethod('Function GetTokenList : string');
    RegisterMethod('Function GetTokenValue( Token : string) : string');
    RegisterMethod('Procedure CancelCompletion');
    RegisterProperty('Executing', 'Boolean', iptr);
    RegisterProperty('AutoCompleteList', 'TStrings', iptrw);
    RegisterProperty('EndOfTokenChr', 'string', iptrw);
    RegisterProperty('Editor', 'TCustomSynEdit', iptrw);
    RegisterProperty('ShortCut', 'TShortCut', iptrw);
    RegisterProperty('OnBeforeExecute', 'TNotifyEvent', iptrw);
    RegisterProperty('OnAfterExecute', 'TNotifyEvent', iptrw);
    RegisterProperty('DoLookupWhenNotExact', 'Boolean', iptrw);
    RegisterProperty('Options', 'TSynCompletionOptions', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynCompletionProposal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynBaseCompletionProposal', 'TSynCompletionProposal') do
  with CL.AddClassN(CL.FindClass('TSynBaseCompletionProposal'),'TSynCompletionProposal') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure AddEditor( AEditor : TCustomSynEdit)');
    RegisterMethod('Function RemoveEditor( AEditor : TCustomSynEdit) : boolean');
    RegisterMethod('Function EditorsCount : integer');
    RegisterMethod('Procedure ExecuteEx( s : string; x, y : integer; Kind : SynCompletionType)');
    RegisterMethod('Procedure ActivateCompletion');
    RegisterMethod('Procedure CancelCompletion');
    RegisterMethod('Procedure ActivateTimer( ACurrentEditor : TCustomSynEdit)');
    RegisterMethod('Procedure DeactivateTimer');
    RegisterProperty('Editors', 'TCustomSynEdit Integer', iptr);
    RegisterProperty('CompletionStart', 'Integer', iptrw);
    RegisterProperty('ShortCut', 'TShortCut', iptrw);
    RegisterProperty('Editor', 'TCustomSynEdit', iptrw);
    RegisterProperty('TimerInterval', 'Integer', iptrw);
    RegisterProperty('OnAfterCodeCompletion', 'TAfterCodeCompletionEvent', iptrw);
    RegisterProperty('OnCancelled', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCodeCompletion', 'TCodeCompletionEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynBaseCompletionProposal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSynBaseCompletionProposal') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSynBaseCompletionProposal') do begin
    RegisterMethod('Constructor Create( Aowner : TComponent)');
       RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Execute( s : string; x, y : integer)');
    RegisterMethod('Procedure ExecuteEx( s : string; x, y : integer; Kind : SynCompletionType)');
    RegisterMethod('Procedure Activate');
    RegisterMethod('Procedure Deactivate');
    RegisterMethod('Procedure ClearList');
    RegisterMethod('Function DisplayItem( AIndex : Integer) : string');
    RegisterMethod('Function InsertItem( AIndex : Integer) : string');
    RegisterMethod('Procedure AddItemAt( Where : Integer; ADisplayText, AInsertText : string)');
    RegisterMethod('Procedure AddItem( ADisplayText, AInsertText : string)');
    RegisterMethod('Procedure ResetAssignedList');
    RegisterProperty('OnKeyPress', 'TKeyPressEvent', iptrw);
    RegisterProperty('OnValidate', 'TValidateEvent', iptrw);
    RegisterProperty('OnCancel', 'TNotifyEvent', iptrw);
    RegisterProperty('CurrentString', 'string', iptrw);
    RegisterProperty('DotOffset', 'Integer', iptrw);
    RegisterProperty('DisplayType', 'SynCompletionType', iptrw);
    RegisterProperty('Form', 'TSynBaseCompletionProposalForm', iptr);
    RegisterProperty('PreviousToken', 'string', iptr);
    RegisterProperty('Position', 'Integer', iptrw);
    RegisterProperty('DefaultType', 'SynCompletionType', iptrw);
    RegisterProperty('Options', 'TSynCompletionOptions', iptrw);
    RegisterProperty('ItemList', 'TStrings', iptrw);
    RegisterProperty('InsertList', 'TStrings', iptrw);
    RegisterProperty('NbLinesInWindow', 'Integer', iptrw);
    RegisterProperty('ClSelect', 'TColor', iptrw);
    RegisterProperty('ClSelectedText', 'TColor', iptrw);
    RegisterProperty('ClBackground', 'TColor', iptrw);
    RegisterProperty('ClTitleBackground', 'TColor', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('EndOfTokenChr', 'string', iptrw);
    RegisterProperty('TriggerChars', 'String', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('TitleFont', 'TFont', iptrw);
    RegisterProperty('Columns', 'TProposalColumns', iptrw);
    RegisterProperty('Resizeable', 'Boolean', iptrw);
    RegisterProperty('ItemHeight', 'Integer', iptrw);
    RegisterProperty('Images', 'TImageList', iptrw);
    RegisterProperty('Margin', 'Integer', iptrw);
    RegisterProperty('OnChange', 'TCompletionChange', iptrw);
    RegisterProperty('OnClose', 'TNotifyEvent', iptrw);
    RegisterProperty('OnExecute', 'TCompletionExecute', iptrw);
    RegisterProperty('OnMeasureItem', 'TSynBaseCompletionProposalMeasureItem', iptrw);
    RegisterProperty('OnPaintItem', 'TSynBaseCompletionProposalPaintItem', iptrw);
    RegisterProperty('OnParameterToken', 'TCompletionParameter', iptrw);
    RegisterProperty('OnShow', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynBaseCompletionProposalForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynForm', 'TSynBaseCompletionProposalForm') do
  with CL.AddClassN(CL.FindClass('TSynForm'),'TSynBaseCompletionProposalForm') do
  begin
    RegisterMethod('Function LogicalToPhysicalIndex( Index : Integer) : Integer');
    RegisterMethod('Function PhysicalToLogicalIndex( Index : Integer) : Integer');
    RegisterProperty('DisplayType', 'SynCompletionType', iptrw);
    RegisterProperty('DefaultType', 'SynCompletionType', iptrw);
    RegisterProperty('CurrentString', 'string', iptrw);
    RegisterProperty('CurrentIndex', 'Integer', iptrw);
    RegisterProperty('CurrentLevel', 'Integer', iptrw);
    RegisterProperty('OnParameterToken', 'TCompletionParameter', iptrw);
    RegisterProperty('OnKeyPress', 'TKeyPressEvent', iptrw);
    RegisterProperty('OnPaintItem', 'TSynBaseCompletionProposalPaintItem', iptrw);
    RegisterProperty('OnMeasureItem', 'TSynBaseCompletionProposalMeasureItem', iptrw);
    RegisterProperty('OnValidate', 'TValidateEvent', iptrw);
    RegisterProperty('OnCancel', 'TNotifyEvent', iptrw);
    RegisterProperty('ItemList', 'TStrings', iptrw);
    RegisterProperty('InsertList', 'TStrings', iptrw);
    RegisterProperty('AssignedList', 'TStrings', iptrw);
    RegisterProperty('Position', 'Integer', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('ClSelect', 'TColor', iptrw);
    RegisterProperty('ClSelectedText', 'TColor', iptrw);
    RegisterProperty('ClBackground', 'TColor', iptrw);
    RegisterProperty('ClTitleBackground', 'TColor', iptrw);
    RegisterProperty('ItemHeight', 'Integer', iptrw);
    RegisterProperty('Margin', 'Integer', iptrw);
    RegisterProperty('UsePrettyText', 'boolean', iptrw);
    RegisterProperty('UseInsertList', 'boolean', iptrw);
    RegisterProperty('CenterTitle', 'boolean', iptrw);
    RegisterProperty('AnsiStrings', 'boolean', iptrw);
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
    RegisterProperty('CurrentEditor', 'TCustomSynEdit', iptrw);
    RegisterProperty('MatchText', 'Boolean', iptrw);
    RegisterProperty('EndOfTokenChr', 'String', iptrw);
    RegisterProperty('TriggerChars', 'String', iptrw);
    RegisterProperty('CompleteWithTab', 'Boolean', iptrw);
    RegisterProperty('CompleteWithEnter', 'Boolean', iptrw);
    RegisterProperty('TitleFont', 'TFont', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('Columns', 'TProposalColumns', iptrw);
    RegisterProperty('Resizeable', 'Boolean', iptrw);
    RegisterProperty('Images', 'TImageList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynCompletionProposal(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TSynCompletionType', '( ctCode, ctHint, ctParams )');
  CL.AddTypeS('SynCompletionType', 'TSynCompletionType');
  CL.AddTypeS('TSynBaseCompletionProposalPaintItem', 'Procedure ( Sender : TObj'
   +'ect; Index : Integer; TargetCanvas : TCanvas; ItemRect : TRect; var CustomDraw : Boolean)');
  CL.AddTypeS('TSynBaseCompletionProposalMeasureItem', 'Procedure ( Sender : TO'
   +'bject; Index : Integer; TargetCanvas : TCanvas; var ItemWidth : Integer)');
  CL.AddTypeS('TCodeCompletionEvent', 'Procedure ( Sender : TObject; var Value '
   +': string; Shift : TShiftState; Index : Integer; EndToken : Char)');
  CL.AddTypeS('TAfterCodeCompletionEvent', 'Procedure ( Sender : TObject; const'
   +' Value : string; Shift : TShiftState; Index : Integer; EndToken : Char)');
  CL.AddTypeS('TValidateEvent', 'Procedure ( Sender : TObject; Shift : TShiftSt'
   +'ate; EndToken : Char)');
  CL.AddTypeS('TCompletionParameter', 'Procedure ( Sender : TObject; CurrentInd'
   +'ex : Integer; var Level, IndexToDisplay : Integer; var Key : Char; var DisplayString : string)');
  CL.AddTypeS('TCompletionExecute', 'Procedure ( Kind : SynCompletionType; Send'
   +'er : TObject; var CurrentInput : string; var x, y : Integer; var CanExecute : Boolean)');
  CL.AddTypeS('TCompletionChange', 'Procedure ( Sender : TObject; AIndex : Integer)');
  CL.AddTypeS('TSynCompletionOption', '( scoAnsiStrings, scoCaseSensitive, scoL'
   +'imitToMatchedText, scoTitleIsCentered, scoUseInsertList, scoUsePrettyText,'
   +' scoUseBuiltInTimer, scoEndCharCompletion, scoConsiderWordBreakChars, scoC'
   +'ompleteWithTab, scoCompleteWithEnter )');
  CL.AddTypeS('TSynCompletionOptions', 'set of TSynCompletionOption');
 CL.AddConstantN('DefaultProposalOptions','LongInt').Value.ts32 := ord(scoLimitToMatchedText) or ord(scoEndCharCompletion) or ord(scoCompleteWithTab) or ord(scoCompleteWithEnter);
 CL.AddConstantN('DefaultEndOfTokenChr','String').SetString( '()[]. ');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TProposalColumns');
  SIRegister_TSynBaseCompletionProposalForm(CL);
  SIRegister_TSynBaseCompletionProposal(CL);
  SIRegister_TSynCompletionProposal(CL);
  SIRegister_TSynAutoComplete(CL);
  SIRegister_TProposalColumn(CL);
  SIRegister_TProposalColumns(CL);
 CL.AddDelphiFunction('Procedure FormattedTextOut( TargetCanvas : TCanvas; const Rect : TRect; const Text : string; Selected : Boolean; Columns : TProposalColumns; Images : TImageList)');
 CL.AddDelphiFunction('Function FormattedTextWidth( TargetCanvas : TCanvas; const Text : string; Columns : TProposalColumns; Images : TImageList) : Integer');
 CL.AddDelphiFunction('Function PrettyTextToFormattedString( const APrettyText : string; AlternateBoldStyle : Boolean) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TProposalColumnsItems_W(Self: TProposalColumns; const T: TProposalColumn; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TProposalColumnsItems_R(Self: TProposalColumns; var T: TProposalColumn; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TProposalColumnDefaultFontStyle_W(Self: TProposalColumn; const T: TFontStyles);
begin Self.DefaultFontStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TProposalColumnDefaultFontStyle_R(Self: TProposalColumn; var T: TFontStyles);
begin T := Self.DefaultFontStyle; end;

(*----------------------------------------------------------------------------*)
procedure TProposalColumnBiggestWord_W(Self: TProposalColumn; const T: string);
begin Self.BiggestWord := T; end;

(*----------------------------------------------------------------------------*)
procedure TProposalColumnBiggestWord_R(Self: TProposalColumn; var T: string);
begin T := Self.BiggestWord; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteOptions_W(Self: TSynAutoComplete; const T: TSynCompletionOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteOptions_R(Self: TSynAutoComplete; var T: TSynCompletionOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteDoLookupWhenNotExact_W(Self: TSynAutoComplete; const T: Boolean);
begin Self.DoLookupWhenNotExact := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteDoLookupWhenNotExact_R(Self: TSynAutoComplete; var T: Boolean);
begin T := Self.DoLookupWhenNotExact; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteOnAfterExecute_W(Self: TSynAutoComplete; const T: TNotifyEvent);
begin Self.OnAfterExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteOnAfterExecute_R(Self: TSynAutoComplete; var T: TNotifyEvent);
begin T := Self.OnAfterExecute; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteOnBeforeExecute_W(Self: TSynAutoComplete; const T: TNotifyEvent);
begin Self.OnBeforeExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteOnBeforeExecute_R(Self: TSynAutoComplete; var T: TNotifyEvent);
begin T := Self.OnBeforeExecute; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteShortCut_W(Self: TSynAutoComplete; const T: TShortCut);
begin Self.ShortCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteShortCut_R(Self: TSynAutoComplete; var T: TShortCut);
begin T := Self.ShortCut; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteEditor_W(Self: TSynAutoComplete; const T: TCustomSynEdit);
begin Self.Editor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteEditor_R(Self: TSynAutoComplete; var T: TCustomSynEdit);
begin T := Self.Editor; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteEndOfTokenChr_W(Self: TSynAutoComplete; const T: string);
begin Self.EndOfTokenChr := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteEndOfTokenChr_R(Self: TSynAutoComplete; var T: string);
begin T := Self.EndOfTokenChr; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteAutoCompleteList_W(Self: TSynAutoComplete; const T: TStrings);
begin Self.AutoCompleteList := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteAutoCompleteList_R(Self: TSynAutoComplete; var T: TStrings);
begin T := Self.AutoCompleteList; end;

(*----------------------------------------------------------------------------*)
procedure TSynAutoCompleteExecuting_R(Self: TSynAutoComplete; var T: Boolean);
begin T := Self.Executing; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalOnCodeCompletion_W(Self: TSynCompletionProposal; const T: TCodeCompletionEvent);
begin Self.OnCodeCompletion := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalOnCodeCompletion_R(Self: TSynCompletionProposal; var T: TCodeCompletionEvent);
begin T := Self.OnCodeCompletion; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalOnCancelled_W(Self: TSynCompletionProposal; const T: TNotifyEvent);
begin Self.OnCancelled := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalOnCancelled_R(Self: TSynCompletionProposal; var T: TNotifyEvent);
begin T := Self.OnCancelled; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalOnAfterCodeCompletion_W(Self: TSynCompletionProposal; const T: TAfterCodeCompletionEvent);
begin Self.OnAfterCodeCompletion := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalOnAfterCodeCompletion_R(Self: TSynCompletionProposal; var T: TAfterCodeCompletionEvent);
begin T := Self.OnAfterCodeCompletion; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalTimerInterval_W(Self: TSynCompletionProposal; const T: Integer);
begin Self.TimerInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalTimerInterval_R(Self: TSynCompletionProposal; var T: Integer);
begin T := Self.TimerInterval; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalEditor_W(Self: TSynCompletionProposal; const T: TCustomSynEdit);
begin Self.Editor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalEditor_R(Self: TSynCompletionProposal; var T: TCustomSynEdit);
begin T := Self.Editor; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalShortCut_W(Self: TSynCompletionProposal; const T: TShortCut);
begin Self.ShortCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalShortCut_R(Self: TSynCompletionProposal; var T: TShortCut);
begin T := Self.ShortCut; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalCompletionStart_W(Self: TSynCompletionProposal; const T: Integer);
begin Self.CompletionStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalCompletionStart_R(Self: TSynCompletionProposal; var T: Integer);
begin T := Self.CompletionStart; end;

(*----------------------------------------------------------------------------*)
procedure TSynCompletionProposalEditors_R(Self: TSynCompletionProposal; var T: TCustomSynEdit; const t1: Integer);
begin T := Self.Editors[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnShow_W(Self: TSynBaseCompletionProposal; const T: TNotifyEvent);
begin Self.OnShow := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnShow_R(Self: TSynBaseCompletionProposal; var T: TNotifyEvent);
begin T := Self.OnShow; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnParameterToken_W(Self: TSynBaseCompletionProposal; const T: TCompletionParameter);
begin Self.OnParameterToken := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnParameterToken_R(Self: TSynBaseCompletionProposal; var T: TCompletionParameter);
begin T := Self.OnParameterToken; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnPaintItem_W(Self: TSynBaseCompletionProposal; const T: TSynBaseCompletionProposalPaintItem);
begin Self.OnPaintItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnPaintItem_R(Self: TSynBaseCompletionProposal; var T: TSynBaseCompletionProposalPaintItem);
begin T := Self.OnPaintItem; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnMeasureItem_W(Self: TSynBaseCompletionProposal; const T: TSynBaseCompletionProposalMeasureItem);
begin Self.OnMeasureItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnMeasureItem_R(Self: TSynBaseCompletionProposal; var T: TSynBaseCompletionProposalMeasureItem);
begin T := Self.OnMeasureItem; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnExecute_W(Self: TSynBaseCompletionProposal; const T: TCompletionExecute);
begin Self.OnExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnExecute_R(Self: TSynBaseCompletionProposal; var T: TCompletionExecute);
begin T := Self.OnExecute; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnClose_W(Self: TSynBaseCompletionProposal; const T: TNotifyEvent);
begin Self.OnClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnClose_R(Self: TSynBaseCompletionProposal; var T: TNotifyEvent);
begin T := Self.OnClose; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnChange_W(Self: TSynBaseCompletionProposal; const T: TCompletionChange);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnChange_R(Self: TSynBaseCompletionProposal; var T: TCompletionChange);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalMargin_W(Self: TSynBaseCompletionProposal; const T: Integer);
begin Self.Margin := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalMargin_R(Self: TSynBaseCompletionProposal; var T: Integer);
begin T := Self.Margin; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalImages_W(Self: TSynBaseCompletionProposal; const T: TImageList);
begin Self.Images := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalImages_R(Self: TSynBaseCompletionProposal; var T: TImageList);
begin T := Self.Images; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalItemHeight_W(Self: TSynBaseCompletionProposal; const T: Integer);
begin Self.ItemHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalItemHeight_R(Self: TSynBaseCompletionProposal; var T: Integer);
begin T := Self.ItemHeight; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalResizeable_W(Self: TSynBaseCompletionProposal; const T: Boolean);
begin Self.Resizeable := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalResizeable_R(Self: TSynBaseCompletionProposal; var T: Boolean);
begin T := Self.Resizeable; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalColumns_W(Self: TSynBaseCompletionProposal; const T: TProposalColumns);
begin Self.Columns := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalColumns_R(Self: TSynBaseCompletionProposal; var T: TProposalColumns);
begin T := Self.Columns; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalTitleFont_W(Self: TSynBaseCompletionProposal; const T: TFont);
begin Self.TitleFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalTitleFont_R(Self: TSynBaseCompletionProposal; var T: TFont);
begin T := Self.TitleFont; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFont_W(Self: TSynBaseCompletionProposal; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFont_R(Self: TSynBaseCompletionProposal; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalTitle_W(Self: TSynBaseCompletionProposal; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalTitle_R(Self: TSynBaseCompletionProposal; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalTriggerChars_W(Self: TSynBaseCompletionProposal; const T: String);
begin Self.TriggerChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalTriggerChars_R(Self: TSynBaseCompletionProposal; var T: String);
begin T := Self.TriggerChars; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalEndOfTokenChr_W(Self: TSynBaseCompletionProposal; const T: string);
begin Self.EndOfTokenChr := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalEndOfTokenChr_R(Self: TSynBaseCompletionProposal; var T: string);
begin T := Self.EndOfTokenChr; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalWidth_W(Self: TSynBaseCompletionProposal; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalWidth_R(Self: TSynBaseCompletionProposal; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalClTitleBackground_W(Self: TSynBaseCompletionProposal; const T: TColor);
begin Self.ClTitleBackground := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalClTitleBackground_R(Self: TSynBaseCompletionProposal; var T: TColor);
begin T := Self.ClTitleBackground; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalClBackground_W(Self: TSynBaseCompletionProposal; const T: TColor);
begin Self.ClBackground := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalClBackground_R(Self: TSynBaseCompletionProposal; var T: TColor);
begin T := Self.ClBackground; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalClSelectedText_W(Self: TSynBaseCompletionProposal; const T: TColor);
begin Self.ClSelectedText := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalClSelectedText_R(Self: TSynBaseCompletionProposal; var T: TColor);
begin T := Self.ClSelectedText; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalClSelect_W(Self: TSynBaseCompletionProposal; const T: TColor);
begin Self.ClSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalClSelect_R(Self: TSynBaseCompletionProposal; var T: TColor);
begin T := Self.ClSelect; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalNbLinesInWindow_W(Self: TSynBaseCompletionProposal; const T: Integer);
begin Self.NbLinesInWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalNbLinesInWindow_R(Self: TSynBaseCompletionProposal; var T: Integer);
begin T := Self.NbLinesInWindow; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalInsertList_W(Self: TSynBaseCompletionProposal; const T: TStrings);
begin Self.InsertList := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalInsertList_R(Self: TSynBaseCompletionProposal; var T: TStrings);
begin T := Self.InsertList; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalItemList_W(Self: TSynBaseCompletionProposal; const T: TStrings);
begin Self.ItemList := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalItemList_R(Self: TSynBaseCompletionProposal; var T: TStrings);
begin T := Self.ItemList; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOptions_W(Self: TSynBaseCompletionProposal; const T: TSynCompletionOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOptions_R(Self: TSynBaseCompletionProposal; var T: TSynCompletionOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalDefaultType_W(Self: TSynBaseCompletionProposal; const T: SynCompletionType);
begin Self.DefaultType := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalDefaultType_R(Self: TSynBaseCompletionProposal; var T: SynCompletionType);
begin T := Self.DefaultType; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalPosition_W(Self: TSynBaseCompletionProposal; const T: Integer);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalPosition_R(Self: TSynBaseCompletionProposal; var T: Integer);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalPreviousToken_R(Self: TSynBaseCompletionProposal; var T: string);
begin T := Self.PreviousToken; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalForm_R(Self: TSynBaseCompletionProposal; var T: TSynBaseCompletionProposalForm);
begin T := Self.Form; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalDisplayType_W(Self: TSynBaseCompletionProposal; const T: SynCompletionType);
begin Self.DisplayType := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalDisplayType_R(Self: TSynBaseCompletionProposal; var T: SynCompletionType);
begin T := Self.DisplayType; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalDotOffset_W(Self: TSynBaseCompletionProposal; const T: Integer);
begin Self.DotOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalDotOffset_R(Self: TSynBaseCompletionProposal; var T: Integer);
begin T := Self.DotOffset; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalCurrentString_W(Self: TSynBaseCompletionProposal; const T: string);
begin Self.CurrentString := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalCurrentString_R(Self: TSynBaseCompletionProposal; var T: string);
begin T := Self.CurrentString; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnCancel_W(Self: TSynBaseCompletionProposal; const T: TNotifyEvent);
begin Self.OnCancel := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnCancel_R(Self: TSynBaseCompletionProposal; var T: TNotifyEvent);
begin T := Self.OnCancel; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnValidate_W(Self: TSynBaseCompletionProposal; const T: TValidateEvent);
begin Self.OnValidate := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnValidate_R(Self: TSynBaseCompletionProposal; var T: TValidateEvent);
begin T := Self.OnValidate; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnKeyPress_W(Self: TSynBaseCompletionProposal; const T: TKeyPressEvent);
begin Self.OnKeyPress := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalOnKeyPress_R(Self: TSynBaseCompletionProposal; var T: TKeyPressEvent);
begin T := Self.OnKeyPress; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormImages_W(Self: TSynBaseCompletionProposalForm; const T: TImageList);
begin Self.Images := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormImages_R(Self: TSynBaseCompletionProposalForm; var T: TImageList);
begin T := Self.Images; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormResizeable_W(Self: TSynBaseCompletionProposalForm; const T: Boolean);
begin Self.Resizeable := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormResizeable_R(Self: TSynBaseCompletionProposalForm; var T: Boolean);
begin T := Self.Resizeable; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormColumns_W(Self: TSynBaseCompletionProposalForm; const T: TProposalColumns);
begin Self.Columns := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormColumns_R(Self: TSynBaseCompletionProposalForm; var T: TProposalColumns);
begin T := Self.Columns; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormFont_W(Self: TSynBaseCompletionProposalForm; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormFont_R(Self: TSynBaseCompletionProposalForm; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormTitleFont_W(Self: TSynBaseCompletionProposalForm; const T: TFont);
begin Self.TitleFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormTitleFont_R(Self: TSynBaseCompletionProposalForm; var T: TFont);
begin T := Self.TitleFont; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCompleteWithEnter_W(Self: TSynBaseCompletionProposalForm; const T: Boolean);
begin Self.CompleteWithEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCompleteWithEnter_R(Self: TSynBaseCompletionProposalForm; var T: Boolean);
begin T := Self.CompleteWithEnter; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCompleteWithTab_W(Self: TSynBaseCompletionProposalForm; const T: Boolean);
begin Self.CompleteWithTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCompleteWithTab_R(Self: TSynBaseCompletionProposalForm; var T: Boolean);
begin T := Self.CompleteWithTab; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormTriggerChars_W(Self: TSynBaseCompletionProposalForm; const T: String);
begin Self.TriggerChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormTriggerChars_R(Self: TSynBaseCompletionProposalForm; var T: String);
begin T := Self.TriggerChars; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormEndOfTokenChr_W(Self: TSynBaseCompletionProposalForm; const T: String);
begin Self.EndOfTokenChr := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormEndOfTokenChr_R(Self: TSynBaseCompletionProposalForm; var T: String);
begin T := Self.EndOfTokenChr; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormMatchText_W(Self: TSynBaseCompletionProposalForm; const T: Boolean);
begin Self.MatchText := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormMatchText_R(Self: TSynBaseCompletionProposalForm; var T: Boolean);
begin T := Self.MatchText; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCurrentEditor_W(Self: TSynBaseCompletionProposalForm; const T: TCustomSynEdit);
begin Self.CurrentEditor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCurrentEditor_R(Self: TSynBaseCompletionProposalForm; var T: TCustomSynEdit);
begin T := Self.CurrentEditor; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCaseSensitive_W(Self: TSynBaseCompletionProposalForm; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCaseSensitive_R(Self: TSynBaseCompletionProposalForm; var T: Boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormAnsiStrings_W(Self: TSynBaseCompletionProposalForm; const T: boolean);
begin Self.AnsiStrings := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormAnsiStrings_R(Self: TSynBaseCompletionProposalForm; var T: boolean);
begin T := Self.AnsiStrings; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCenterTitle_W(Self: TSynBaseCompletionProposalForm; const T: boolean);
begin Self.CenterTitle := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCenterTitle_R(Self: TSynBaseCompletionProposalForm; var T: boolean);
begin T := Self.CenterTitle; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormUseInsertList_W(Self: TSynBaseCompletionProposalForm; const T: boolean);
begin Self.UseInsertList := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormUseInsertList_R(Self: TSynBaseCompletionProposalForm; var T: boolean);
begin T := Self.UseInsertList; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormUsePrettyText_W(Self: TSynBaseCompletionProposalForm; const T: boolean);
begin Self.UsePrettyText := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormUsePrettyText_R(Self: TSynBaseCompletionProposalForm; var T: boolean);
begin T := Self.UsePrettyText; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormMargin_W(Self: TSynBaseCompletionProposalForm; const T: Integer);
begin Self.Margin := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormMargin_R(Self: TSynBaseCompletionProposalForm; var T: Integer);
begin T := Self.Margin; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormItemHeight_W(Self: TSynBaseCompletionProposalForm; const T: Integer);
begin Self.ItemHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormItemHeight_R(Self: TSynBaseCompletionProposalForm; var T: Integer);
begin T := Self.ItemHeight; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormClTitleBackground_W(Self: TSynBaseCompletionProposalForm; const T: TColor);
begin Self.ClTitleBackground := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormClTitleBackground_R(Self: TSynBaseCompletionProposalForm; var T: TColor);
begin T := Self.ClTitleBackground; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormClBackground_W(Self: TSynBaseCompletionProposalForm; const T: TColor);
begin Self.ClBackground := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormClBackground_R(Self: TSynBaseCompletionProposalForm; var T: TColor);
begin T := Self.ClBackground; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormClSelectedText_W(Self: TSynBaseCompletionProposalForm; const T: TColor);
begin Self.ClSelectedText := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormClSelectedText_R(Self: TSynBaseCompletionProposalForm; var T: TColor);
begin T := Self.ClSelectedText; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormClSelect_W(Self: TSynBaseCompletionProposalForm; const T: TColor);
begin Self.ClSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormClSelect_R(Self: TSynBaseCompletionProposalForm; var T: TColor);
begin T := Self.ClSelect; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormTitle_W(Self: TSynBaseCompletionProposalForm; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormTitle_R(Self: TSynBaseCompletionProposalForm; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormPosition_W(Self: TSynBaseCompletionProposalForm; const T: Integer);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormPosition_R(Self: TSynBaseCompletionProposalForm; var T: Integer);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormAssignedList_W(Self: TSynBaseCompletionProposalForm; const T: TStrings);
begin Self.AssignedList := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormAssignedList_R(Self: TSynBaseCompletionProposalForm; var T: TStrings);
begin T := Self.AssignedList; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormInsertList_W(Self: TSynBaseCompletionProposalForm; const T: TStrings);
begin Self.InsertList := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormInsertList_R(Self: TSynBaseCompletionProposalForm; var T: TStrings);
begin T := Self.InsertList; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormItemList_W(Self: TSynBaseCompletionProposalForm; const T: TStrings);
begin Self.ItemList := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormItemList_R(Self: TSynBaseCompletionProposalForm; var T: TStrings);
begin T := Self.ItemList; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnCancel_W(Self: TSynBaseCompletionProposalForm; const T: TNotifyEvent);
begin Self.OnCancel := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnCancel_R(Self: TSynBaseCompletionProposalForm; var T: TNotifyEvent);
begin T := Self.OnCancel; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnValidate_W(Self: TSynBaseCompletionProposalForm; const T: TValidateEvent);
begin Self.OnValidate := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnValidate_R(Self: TSynBaseCompletionProposalForm; var T: TValidateEvent);
begin T := Self.OnValidate; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnMeasureItem_W(Self: TSynBaseCompletionProposalForm; const T: TSynBaseCompletionProposalMeasureItem);
begin Self.OnMeasureItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnMeasureItem_R(Self: TSynBaseCompletionProposalForm; var T: TSynBaseCompletionProposalMeasureItem);
begin T := Self.OnMeasureItem; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnPaintItem_W(Self: TSynBaseCompletionProposalForm; const T: TSynBaseCompletionProposalPaintItem);
begin Self.OnPaintItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnPaintItem_R(Self: TSynBaseCompletionProposalForm; var T: TSynBaseCompletionProposalPaintItem);
begin T := Self.OnPaintItem; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnKeyPress_W(Self: TSynBaseCompletionProposalForm; const T: TKeyPressEvent);
begin Self.OnKeyPress := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnKeyPress_R(Self: TSynBaseCompletionProposalForm; var T: TKeyPressEvent);
begin T := Self.OnKeyPress; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnParameterToken_W(Self: TSynBaseCompletionProposalForm; const T: TCompletionParameter);
begin Self.OnParameterToken := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormOnParameterToken_R(Self: TSynBaseCompletionProposalForm; var T: TCompletionParameter);
begin T := Self.OnParameterToken; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCurrentLevel_W(Self: TSynBaseCompletionProposalForm; const T: Integer);
begin Self.CurrentLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCurrentLevel_R(Self: TSynBaseCompletionProposalForm; var T: Integer);
begin T := Self.CurrentLevel; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCurrentIndex_W(Self: TSynBaseCompletionProposalForm; const T: Integer);
begin Self.CurrentIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCurrentIndex_R(Self: TSynBaseCompletionProposalForm; var T: Integer);
begin T := Self.CurrentIndex; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCurrentString_W(Self: TSynBaseCompletionProposalForm; const T: string);
begin Self.CurrentString := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormCurrentString_R(Self: TSynBaseCompletionProposalForm; var T: string);
begin T := Self.CurrentString; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormDefaultType_W(Self: TSynBaseCompletionProposalForm; const T: SynCompletionType);
begin Self.DefaultType := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormDefaultType_R(Self: TSynBaseCompletionProposalForm; var T: SynCompletionType);
begin T := Self.DefaultType; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormDisplayType_W(Self: TSynBaseCompletionProposalForm; const T: SynCompletionType);
begin Self.DisplayType := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBaseCompletionProposalFormDisplayType_R(Self: TSynBaseCompletionProposalForm; var T: SynCompletionType);
begin T := Self.DisplayType; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynCompletionProposal_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FormattedTextOut, 'FormattedTextOut', cdRegister);
 S.RegisterDelphiFunction(@FormattedTextWidth, 'FormattedTextWidth', cdRegister);
 S.RegisterDelphiFunction(@PrettyTextToFormattedString, 'PrettyTextToFormattedString', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProposalColumns(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProposalColumns) do begin
    RegisterConstructor(@TProposalColumns.Create, 'Create');
      RegisterMethod(@TProposalColumns.Destroy, 'Free');
  RegisterMethod(@TProposalColumns.Add, 'Add');
    RegisterMethod(@TProposalColumns.FindItemID, 'FindItemID');
    RegisterMethod(@TProposalColumns.Insert, 'Insert');
    RegisterPropertyHelper(@TProposalColumnsItems_R,@TProposalColumnsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProposalColumn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProposalColumn) do
  begin
    RegisterConstructor(@TProposalColumn.Create, 'Create');
      RegisterMethod(@TProposalColumn.Destroy, 'Free');
       RegisterMethod(@TProposalColumn.Assign, 'Assign');
    RegisterPropertyHelper(@TProposalColumnBiggestWord_R,@TProposalColumnBiggestWord_W,'BiggestWord');
    RegisterPropertyHelper(@TProposalColumnDefaultFontStyle_R,@TProposalColumnDefaultFontStyle_W,'DefaultFontStyle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynAutoComplete(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynAutoComplete) do begin
    RegisterConstructor(@TSynAutoComplete.Create, 'Create');
      RegisterMethod(@TSynAutoComplete.Destroy, 'Free');

    RegisterMethod(@TSynAutoComplete.Execute, 'Execute');
    RegisterMethod(@TSynAutoComplete.ExecuteEx, 'ExecuteEx');
    RegisterMethod(@TSynAutoComplete.GetTokenList, 'GetTokenList');
    RegisterMethod(@TSynAutoComplete.GetTokenValue, 'GetTokenValue');
    RegisterMethod(@TSynAutoComplete.CancelCompletion, 'CancelCompletion');
    RegisterPropertyHelper(@TSynAutoCompleteExecuting_R,nil,'Executing');
    RegisterPropertyHelper(@TSynAutoCompleteAutoCompleteList_R,@TSynAutoCompleteAutoCompleteList_W,'AutoCompleteList');
    RegisterPropertyHelper(@TSynAutoCompleteEndOfTokenChr_R,@TSynAutoCompleteEndOfTokenChr_W,'EndOfTokenChr');
    RegisterPropertyHelper(@TSynAutoCompleteEditor_R,@TSynAutoCompleteEditor_W,'Editor');
    RegisterPropertyHelper(@TSynAutoCompleteShortCut_R,@TSynAutoCompleteShortCut_W,'ShortCut');
    RegisterPropertyHelper(@TSynAutoCompleteOnBeforeExecute_R,@TSynAutoCompleteOnBeforeExecute_W,'OnBeforeExecute');
    RegisterPropertyHelper(@TSynAutoCompleteOnAfterExecute_R,@TSynAutoCompleteOnAfterExecute_W,'OnAfterExecute');
    RegisterPropertyHelper(@TSynAutoCompleteDoLookupWhenNotExact_R,@TSynAutoCompleteDoLookupWhenNotExact_W,'DoLookupWhenNotExact');
    RegisterPropertyHelper(@TSynAutoCompleteOptions_R,@TSynAutoCompleteOptions_W,'Options');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynCompletionProposal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynCompletionProposal) do begin
    RegisterConstructor(@TSynCompletionProposal.Create, 'Create');
      RegisterMethod(@TSynCompletionProposal.Destroy, 'Free');
  RegisterMethod(@TSynCompletionProposal.AddEditor, 'AddEditor');
    RegisterMethod(@TSynCompletionProposal.RemoveEditor, 'RemoveEditor');
    RegisterMethod(@TSynCompletionProposal.EditorsCount, 'EditorsCount');
    RegisterMethod(@TSynCompletionProposal.ExecuteEx, 'ExecuteEx');
    RegisterMethod(@TSynCompletionProposal.ActivateCompletion, 'ActivateCompletion');
    RegisterMethod(@TSynCompletionProposal.CancelCompletion, 'CancelCompletion');
    RegisterMethod(@TSynCompletionProposal.ActivateTimer, 'ActivateTimer');
    RegisterMethod(@TSynCompletionProposal.DeactivateTimer, 'DeactivateTimer');
    RegisterPropertyHelper(@TSynCompletionProposalEditors_R,nil,'Editors');
    RegisterPropertyHelper(@TSynCompletionProposalCompletionStart_R,@TSynCompletionProposalCompletionStart_W,'CompletionStart');
    RegisterPropertyHelper(@TSynCompletionProposalShortCut_R,@TSynCompletionProposalShortCut_W,'ShortCut');
    RegisterPropertyHelper(@TSynCompletionProposalEditor_R,@TSynCompletionProposalEditor_W,'Editor');
    RegisterPropertyHelper(@TSynCompletionProposalTimerInterval_R,@TSynCompletionProposalTimerInterval_W,'TimerInterval');
    RegisterPropertyHelper(@TSynCompletionProposalOnAfterCodeCompletion_R,@TSynCompletionProposalOnAfterCodeCompletion_W,'OnAfterCodeCompletion');
    RegisterPropertyHelper(@TSynCompletionProposalOnCancelled_R,@TSynCompletionProposalOnCancelled_W,'OnCancelled');
    RegisterPropertyHelper(@TSynCompletionProposalOnCodeCompletion_R,@TSynCompletionProposalOnCodeCompletion_W,'OnCodeCompletion');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynBaseCompletionProposal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynBaseCompletionProposal) do begin
    RegisterConstructor(@TSynBaseCompletionProposal.Create, 'Create');
      RegisterMethod(@TSynBaseCompletionProposal.Destroy, 'Free');

    RegisterMethod(@TSynBaseCompletionProposal.Execute, 'Execute');
    RegisterVirtualMethod(@TSynBaseCompletionProposal.ExecuteEx, 'ExecuteEx');
    RegisterMethod(@TSynBaseCompletionProposal.Activate, 'Activate');
    RegisterMethod(@TSynBaseCompletionProposal.Deactivate, 'Deactivate');
    RegisterMethod(@TSynBaseCompletionProposal.ClearList, 'ClearList');
    RegisterMethod(@TSynBaseCompletionProposal.DisplayItem, 'DisplayItem');
    RegisterMethod(@TSynBaseCompletionProposal.InsertItem, 'InsertItem');
    RegisterMethod(@TSynBaseCompletionProposal.AddItemAt, 'AddItemAt');
    RegisterMethod(@TSynBaseCompletionProposal.AddItem, 'AddItem');
    RegisterMethod(@TSynBaseCompletionProposal.ResetAssignedList, 'ResetAssignedList');
    RegisterPropertyHelper(@TSynBaseCompletionProposalOnKeyPress_R,@TSynBaseCompletionProposalOnKeyPress_W,'OnKeyPress');
    RegisterPropertyHelper(@TSynBaseCompletionProposalOnValidate_R,@TSynBaseCompletionProposalOnValidate_W,'OnValidate');
    RegisterPropertyHelper(@TSynBaseCompletionProposalOnCancel_R,@TSynBaseCompletionProposalOnCancel_W,'OnCancel');
    RegisterPropertyHelper(@TSynBaseCompletionProposalCurrentString_R,@TSynBaseCompletionProposalCurrentString_W,'CurrentString');
    RegisterPropertyHelper(@TSynBaseCompletionProposalDotOffset_R,@TSynBaseCompletionProposalDotOffset_W,'DotOffset');
    RegisterPropertyHelper(@TSynBaseCompletionProposalDisplayType_R,@TSynBaseCompletionProposalDisplayType_W,'DisplayType');
    RegisterPropertyHelper(@TSynBaseCompletionProposalForm_R,nil,'Form');
    RegisterPropertyHelper(@TSynBaseCompletionProposalPreviousToken_R,nil,'PreviousToken');
    RegisterPropertyHelper(@TSynBaseCompletionProposalPosition_R,@TSynBaseCompletionProposalPosition_W,'Position');
    RegisterPropertyHelper(@TSynBaseCompletionProposalDefaultType_R,@TSynBaseCompletionProposalDefaultType_W,'DefaultType');
    RegisterPropertyHelper(@TSynBaseCompletionProposalOptions_R,@TSynBaseCompletionProposalOptions_W,'Options');
    RegisterPropertyHelper(@TSynBaseCompletionProposalItemList_R,@TSynBaseCompletionProposalItemList_W,'ItemList');
    RegisterPropertyHelper(@TSynBaseCompletionProposalInsertList_R,@TSynBaseCompletionProposalInsertList_W,'InsertList');
    RegisterPropertyHelper(@TSynBaseCompletionProposalNbLinesInWindow_R,@TSynBaseCompletionProposalNbLinesInWindow_W,'NbLinesInWindow');
    RegisterPropertyHelper(@TSynBaseCompletionProposalClSelect_R,@TSynBaseCompletionProposalClSelect_W,'ClSelect');
    RegisterPropertyHelper(@TSynBaseCompletionProposalClSelectedText_R,@TSynBaseCompletionProposalClSelectedText_W,'ClSelectedText');
    RegisterPropertyHelper(@TSynBaseCompletionProposalClBackground_R,@TSynBaseCompletionProposalClBackground_W,'ClBackground');
    RegisterPropertyHelper(@TSynBaseCompletionProposalClTitleBackground_R,@TSynBaseCompletionProposalClTitleBackground_W,'ClTitleBackground');
    RegisterPropertyHelper(@TSynBaseCompletionProposalWidth_R,@TSynBaseCompletionProposalWidth_W,'Width');
    RegisterPropertyHelper(@TSynBaseCompletionProposalEndOfTokenChr_R,@TSynBaseCompletionProposalEndOfTokenChr_W,'EndOfTokenChr');
    RegisterPropertyHelper(@TSynBaseCompletionProposalTriggerChars_R,@TSynBaseCompletionProposalTriggerChars_W,'TriggerChars');
    RegisterPropertyHelper(@TSynBaseCompletionProposalTitle_R,@TSynBaseCompletionProposalTitle_W,'Title');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFont_R,@TSynBaseCompletionProposalFont_W,'Font');
    RegisterPropertyHelper(@TSynBaseCompletionProposalTitleFont_R,@TSynBaseCompletionProposalTitleFont_W,'TitleFont');
    RegisterPropertyHelper(@TSynBaseCompletionProposalColumns_R,@TSynBaseCompletionProposalColumns_W,'Columns');
    RegisterPropertyHelper(@TSynBaseCompletionProposalResizeable_R,@TSynBaseCompletionProposalResizeable_W,'Resizeable');
    RegisterPropertyHelper(@TSynBaseCompletionProposalItemHeight_R,@TSynBaseCompletionProposalItemHeight_W,'ItemHeight');
    RegisterPropertyHelper(@TSynBaseCompletionProposalImages_R,@TSynBaseCompletionProposalImages_W,'Images');
    RegisterPropertyHelper(@TSynBaseCompletionProposalMargin_R,@TSynBaseCompletionProposalMargin_W,'Margin');
    RegisterPropertyHelper(@TSynBaseCompletionProposalOnChange_R,@TSynBaseCompletionProposalOnChange_W,'OnChange');
    RegisterPropertyHelper(@TSynBaseCompletionProposalOnClose_R,@TSynBaseCompletionProposalOnClose_W,'OnClose');
    RegisterPropertyHelper(@TSynBaseCompletionProposalOnExecute_R,@TSynBaseCompletionProposalOnExecute_W,'OnExecute');
    RegisterPropertyHelper(@TSynBaseCompletionProposalOnMeasureItem_R,@TSynBaseCompletionProposalOnMeasureItem_W,'OnMeasureItem');
    RegisterPropertyHelper(@TSynBaseCompletionProposalOnPaintItem_R,@TSynBaseCompletionProposalOnPaintItem_W,'OnPaintItem');
    RegisterPropertyHelper(@TSynBaseCompletionProposalOnParameterToken_R,@TSynBaseCompletionProposalOnParameterToken_W,'OnParameterToken');
    RegisterPropertyHelper(@TSynBaseCompletionProposalOnShow_R,@TSynBaseCompletionProposalOnShow_W,'OnShow');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynBaseCompletionProposalForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynBaseCompletionProposalForm) do
  begin
    RegisterMethod(@TSynBaseCompletionProposalForm.LogicalToPhysicalIndex, 'LogicalToPhysicalIndex');
    RegisterMethod(@TSynBaseCompletionProposalForm.PhysicalToLogicalIndex, 'PhysicalToLogicalIndex');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormDisplayType_R,@TSynBaseCompletionProposalFormDisplayType_W,'DisplayType');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormDefaultType_R,@TSynBaseCompletionProposalFormDefaultType_W,'DefaultType');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormCurrentString_R,@TSynBaseCompletionProposalFormCurrentString_W,'CurrentString');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormCurrentIndex_R,@TSynBaseCompletionProposalFormCurrentIndex_W,'CurrentIndex');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormCurrentLevel_R,@TSynBaseCompletionProposalFormCurrentLevel_W,'CurrentLevel');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormOnParameterToken_R,@TSynBaseCompletionProposalFormOnParameterToken_W,'OnParameterToken');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormOnKeyPress_R,@TSynBaseCompletionProposalFormOnKeyPress_W,'OnKeyPress');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormOnPaintItem_R,@TSynBaseCompletionProposalFormOnPaintItem_W,'OnPaintItem');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormOnMeasureItem_R,@TSynBaseCompletionProposalFormOnMeasureItem_W,'OnMeasureItem');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormOnValidate_R,@TSynBaseCompletionProposalFormOnValidate_W,'OnValidate');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormOnCancel_R,@TSynBaseCompletionProposalFormOnCancel_W,'OnCancel');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormItemList_R,@TSynBaseCompletionProposalFormItemList_W,'ItemList');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormInsertList_R,@TSynBaseCompletionProposalFormInsertList_W,'InsertList');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormAssignedList_R,@TSynBaseCompletionProposalFormAssignedList_W,'AssignedList');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormPosition_R,@TSynBaseCompletionProposalFormPosition_W,'Position');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormTitle_R,@TSynBaseCompletionProposalFormTitle_W,'Title');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormClSelect_R,@TSynBaseCompletionProposalFormClSelect_W,'ClSelect');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormClSelectedText_R,@TSynBaseCompletionProposalFormClSelectedText_W,'ClSelectedText');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormClBackground_R,@TSynBaseCompletionProposalFormClBackground_W,'ClBackground');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormClTitleBackground_R,@TSynBaseCompletionProposalFormClTitleBackground_W,'ClTitleBackground');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormItemHeight_R,@TSynBaseCompletionProposalFormItemHeight_W,'ItemHeight');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormMargin_R,@TSynBaseCompletionProposalFormMargin_W,'Margin');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormUsePrettyText_R,@TSynBaseCompletionProposalFormUsePrettyText_W,'UsePrettyText');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormUseInsertList_R,@TSynBaseCompletionProposalFormUseInsertList_W,'UseInsertList');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormCenterTitle_R,@TSynBaseCompletionProposalFormCenterTitle_W,'CenterTitle');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormAnsiStrings_R,@TSynBaseCompletionProposalFormAnsiStrings_W,'AnsiStrings');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormCaseSensitive_R,@TSynBaseCompletionProposalFormCaseSensitive_W,'CaseSensitive');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormCurrentEditor_R,@TSynBaseCompletionProposalFormCurrentEditor_W,'CurrentEditor');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormMatchText_R,@TSynBaseCompletionProposalFormMatchText_W,'MatchText');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormEndOfTokenChr_R,@TSynBaseCompletionProposalFormEndOfTokenChr_W,'EndOfTokenChr');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormTriggerChars_R,@TSynBaseCompletionProposalFormTriggerChars_W,'TriggerChars');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormCompleteWithTab_R,@TSynBaseCompletionProposalFormCompleteWithTab_W,'CompleteWithTab');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormCompleteWithEnter_R,@TSynBaseCompletionProposalFormCompleteWithEnter_W,'CompleteWithEnter');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormTitleFont_R,@TSynBaseCompletionProposalFormTitleFont_W,'TitleFont');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormFont_R,@TSynBaseCompletionProposalFormFont_W,'Font');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormColumns_R,@TSynBaseCompletionProposalFormColumns_W,'Columns');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormResizeable_R,@TSynBaseCompletionProposalFormResizeable_W,'Resizeable');
    RegisterPropertyHelper(@TSynBaseCompletionProposalFormImages_R,@TSynBaseCompletionProposalFormImages_W,'Images');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynCompletionProposal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProposalColumns) do
  RIRegister_TSynBaseCompletionProposalForm(CL);
  RIRegister_TSynBaseCompletionProposal(CL);
  RIRegister_TSynCompletionProposal(CL);
  RIRegister_TSynAutoComplete(CL);
  RIRegister_TProposalColumn(CL);
  RIRegister_TProposalColumns(CL);
end;

 
 
{ TPSImport_SynCompletionProposal }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynCompletionProposal.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynCompletionProposal(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynCompletionProposal.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynCompletionProposal(ri);
  RIRegister_SynCompletionProposal_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
