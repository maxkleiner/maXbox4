unit uPSI_SynEditTextBuffer;
{
  the very last past

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
  TPSImport_SynEditTextBuffer = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynEditUndoList(CL: TPSPascalCompiler);
procedure SIRegister_TSynEditUndoItem(CL: TPSPascalCompiler);
procedure SIRegister_TSynEditStringList(CL: TPSPascalCompiler);
procedure SIRegister_SynEditTextBuffer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynEditUndoList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynEditUndoItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynEditStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynEditTextBuffer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // kTextDrawer
  Types
  //,QSynEditTypes
  //,QSynEditMiscProcs
  ,Windows
  ,SynEditTypes
  ,SynEditMiscProcs
  ,SynEditTextBuffer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEditTextBuffer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditUndoList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSynEditUndoList') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSynEditUndoList') do
  begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure AddChange( AReason : TSynChangeReason; const AStart, AEnd : TBufferCoord; const ChangeText : string; SelMode : TSynSelectionMode)');
    RegisterMethod('Procedure BeginBlock');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure EndBlock');
    RegisterMethod('Procedure Lock');
    RegisterMethod('Function PeekItem : TSynEditUndoItem');
    RegisterMethod('Function PopItem : TSynEditUndoItem');
    RegisterMethod('Procedure PushItem( Item : TSynEditUndoItem)');
    RegisterMethod('Procedure Unlock');
    RegisterMethod('Function LastChangeReason : TSynChangeReason');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure AddGroupBreak');
    RegisterMethod('Procedure DeleteItem( AIndex : Integer)');
    RegisterProperty('BlockChangeNumber', 'integer', iptrw);
    RegisterProperty('CanUndo', 'boolean', iptr);
    RegisterProperty('FullUndoImpossible', 'boolean', iptr);
    RegisterProperty('InitialState', 'boolean', iptrw);
    RegisterProperty('Items', 'TSynEditUndoItem Integer', iptrw);
    RegisterProperty('ItemCount', 'integer', iptr);
    RegisterProperty('BlockCount', 'integer', iptr);
    RegisterProperty('MaxUndoActions', 'integer', iptrw);
    RegisterProperty('InsideRedo', 'boolean', iptrw);
    RegisterProperty('OnAddedUndo', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditUndoItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSynEditUndoItem') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSynEditUndoItem') do
  begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('ChangeReason', 'TSynChangeReason', iptr);
    RegisterProperty('ChangeSelMode', 'TSynSelectionMode', iptr);
    RegisterProperty('ChangeStartPos', 'TBufferCoord', iptr);
    RegisterProperty('ChangeEndPos', 'TBufferCoord', iptr);
    RegisterProperty('ChangeStr', 'string', iptr);
    RegisterProperty('ChangeNumber', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStrings', 'TSynEditStringList') do
  with CL.AddClassN(CL.FindClass('TStrings'),'TSynEditStringList') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Function Add( const S : string) : integer');
    RegisterMethod('Procedure AddStrings( Strings : TStrings)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : integer)');
    RegisterMethod('Procedure DeleteLines( Index, NumLines : integer)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : integer)');
    RegisterMethod('Procedure Insert( Index : integer; const S : string)');
    RegisterMethod('Procedure InsertLines( Index, NumLines : integer)');
    RegisterMethod('Procedure InsertStrings( Index : integer; NewStrings : TStrings)');
    RegisterMethod('Procedure InsertText( Index : integer; NewText : String)');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterProperty('AppendNewLineAtEOF', 'Boolean', iptrw);
    RegisterProperty('FileFormat', 'TSynEditFileFormat', iptrw);
    RegisterProperty('ExpandedStrings', 'string integer', iptr);
    RegisterProperty('ExpandedStringLengths', 'integer integer', iptr);
    RegisterProperty('LengthOfLongestLine', 'integer', iptr);
    RegisterProperty('Ranges', 'TSynEditRange integer', iptrw);
    RegisterProperty('TabWidth', 'integer', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChanging', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCleared', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDeleted', 'TStringListChangeEvent', iptrw);
    RegisterProperty('OnInserted', 'TStringListChangeEvent', iptrw);
    RegisterProperty('OnPutted', 'TStringListChangeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEditTextBuffer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TSynEditRange', '___pointer');
  CL.AddTypeS('TSynEditStringFlag', '( sfHasTabs, sfHasNoTabs, sfExpandedLengthUnknown )');
  CL.AddTypeS('TSynEditStringFlags', 'set of TSynEditStringFlag');
  //CL.AddTypeS('PSynEditStringRec', '^TSynEditStringRec // will not work');
  CL.AddTypeS('TSynEditStringRec', 'record fString : string; fObject : TObject;'
   +' fRange : TSynEditRange; fExpandedLength : integer; fFlags : TSynEditStrin'
   +'gFlags; end');
 //CL.AddConstantN('NullRange','LongInt').SetInt( TSynEditRange ( - 1 ));
  //CL.AddTypeS('PSynEditStringRecList', '^TSynEditStringRecList // will not work');
  CL.AddTypeS('TStringListChangeEvent', 'Procedure ( Sender : TObject; Index : '
   +'Integer; Count : integer)');
  CL.AddTypeS('TSynEditFileFormat', '( sffDos, sffUnix, sffMac )');
  SIRegister_TSynEditStringList(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ESynEditStringList');
  CL.AddTypeS('TSynChangeReason', '( crInsert, crPaste, crDragDropInsert, crDel'
   +'eteAfterCursor, crDelete, crLineBreak, crIndent, crUnindent, crSilentDelet'
   +'e, crSilentDeleteAfterCursor, crAutoCompleteBegin, crAutoCompleteEnd, crPa'
   +'steBegin, crPasteEnd, crSpecial1Begin, crSpecial1End, crSpecial2Begin, crS'
   +'pecial2End, crCaret, crSelection, crNothing, crGroupBreak, crDeleteAll )');
  SIRegister_TSynEditUndoItem(CL);
  SIRegister_TSynEditUndoList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListOnAddedUndo_W(Self: TSynEditUndoList; const T: TNotifyEvent);
begin Self.OnAddedUndo := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListOnAddedUndo_R(Self: TSynEditUndoList; var T: TNotifyEvent);
begin T := Self.OnAddedUndo; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListInsideRedo_W(Self: TSynEditUndoList; const T: boolean);
begin Self.InsideRedo := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListInsideRedo_R(Self: TSynEditUndoList; var T: boolean);
begin T := Self.InsideRedo; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListMaxUndoActions_W(Self: TSynEditUndoList; const T: integer);
begin Self.MaxUndoActions := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListMaxUndoActions_R(Self: TSynEditUndoList; var T: integer);
begin T := Self.MaxUndoActions; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListBlockCount_R(Self: TSynEditUndoList; var T: integer);
begin T := Self.BlockCount; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListItemCount_R(Self: TSynEditUndoList; var T: integer);
begin T := Self.ItemCount; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListItems_W(Self: TSynEditUndoList; const T: TSynEditUndoItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListItems_R(Self: TSynEditUndoList; var T: TSynEditUndoItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListInitialState_W(Self: TSynEditUndoList; const T: boolean);
begin Self.InitialState := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListInitialState_R(Self: TSynEditUndoList; var T: boolean);
begin T := Self.InitialState; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListFullUndoImpossible_R(Self: TSynEditUndoList; var T: boolean);
begin T := Self.FullUndoImpossible; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListCanUndo_R(Self: TSynEditUndoList; var T: boolean);
begin T := Self.CanUndo; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListBlockChangeNumber_W(Self: TSynEditUndoList; const T: integer);
begin Self.BlockChangeNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoListBlockChangeNumber_R(Self: TSynEditUndoList; var T: integer);
begin T := Self.BlockChangeNumber; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoItemChangeNumber_R(Self: TSynEditUndoItem; var T: integer);
begin T := Self.ChangeNumber; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoItemChangeStr_R(Self: TSynEditUndoItem; var T: string);
begin T := Self.ChangeStr; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoItemChangeEndPos_R(Self: TSynEditUndoItem; var T: TBufferCoord);
begin T := Self.ChangeEndPos; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoItemChangeStartPos_R(Self: TSynEditUndoItem; var T: TBufferCoord);
begin T := Self.ChangeStartPos; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoItemChangeSelMode_R(Self: TSynEditUndoItem; var T: TSynSelectionMode);
begin T := Self.ChangeSelMode; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditUndoItemChangeReason_R(Self: TSynEditUndoItem; var T: TSynChangeReason);
begin T := Self.ChangeReason; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnPutted_W(Self: TSynEditStringList; const T: TStringListChangeEvent);
begin Self.OnPutted := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnPutted_R(Self: TSynEditStringList; var T: TStringListChangeEvent);
begin T := Self.OnPutted; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnInserted_W(Self: TSynEditStringList; const T: TStringListChangeEvent);
begin Self.OnInserted := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnInserted_R(Self: TSynEditStringList; var T: TStringListChangeEvent);
begin T := Self.OnInserted; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnDeleted_W(Self: TSynEditStringList; const T: TStringListChangeEvent);
begin Self.OnDeleted := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnDeleted_R(Self: TSynEditStringList; var T: TStringListChangeEvent);
begin T := Self.OnDeleted; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnCleared_W(Self: TSynEditStringList; const T: TNotifyEvent);
begin Self.OnCleared := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnCleared_R(Self: TSynEditStringList; var T: TNotifyEvent);
begin T := Self.OnCleared; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnChanging_W(Self: TSynEditStringList; const T: TNotifyEvent);
begin Self.OnChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnChanging_R(Self: TSynEditStringList; var T: TNotifyEvent);
begin T := Self.OnChanging; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnChange_W(Self: TSynEditStringList; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListOnChange_R(Self: TSynEditStringList; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListTabWidth_W(Self: TSynEditStringList; const T: integer);
begin Self.TabWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListTabWidth_R(Self: TSynEditStringList; var T: integer);
begin T := Self.TabWidth; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListRanges_W(Self: TSynEditStringList; const T: TSynEditRange; const t1: integer);
begin Self.Ranges[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListRanges_R(Self: TSynEditStringList; var T: TSynEditRange; const t1: integer);
begin T := Self.Ranges[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListLengthOfLongestLine_R(Self: TSynEditStringList; var T: integer);
begin T := Self.LengthOfLongestLine; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListExpandedStringLengths_R(Self: TSynEditStringList; var T: integer; const t1: integer);
begin T := Self.ExpandedStringLengths[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListExpandedStrings_R(Self: TSynEditStringList; var T: string; const t1: integer);
begin T := Self.ExpandedStrings[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListFileFormat_W(Self: TSynEditStringList; const T: TSynEditFileFormat);
begin Self.FileFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListFileFormat_R(Self: TSynEditStringList; var T: TSynEditFileFormat);
begin T := Self.FileFormat; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListAppendNewLineAtEOF_W(Self: TSynEditStringList; const T: Boolean);
begin Self.AppendNewLineAtEOF := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditStringListAppendNewLineAtEOF_R(Self: TSynEditStringList; var T: Boolean);
begin T := Self.AppendNewLineAtEOF; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditUndoList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditUndoList) do begin
    RegisterConstructor(@TSynEditUndoList.Create, 'Create');
    RegisterMethod(@TSynEditUndoList.Destroy, 'Free');

    RegisterMethod(@TSynEditUndoList.AddChange, 'AddChange');
    RegisterMethod(@TSynEditUndoList.BeginBlock, 'BeginBlock');
    RegisterMethod(@TSynEditUndoList.Clear, 'Clear');
    RegisterMethod(@TSynEditUndoList.EndBlock, 'EndBlock');
    RegisterMethod(@TSynEditUndoList.Lock, 'Lock');
    RegisterMethod(@TSynEditUndoList.PeekItem, 'PeekItem');
    RegisterMethod(@TSynEditUndoList.PopItem, 'PopItem');
    RegisterMethod(@TSynEditUndoList.PushItem, 'PushItem');
    RegisterMethod(@TSynEditUndoList.Unlock, 'Unlock');
    RegisterMethod(@TSynEditUndoList.LastChangeReason, 'LastChangeReason');
    RegisterMethod(@TSynEditUndoList.Assign, 'Assign');
    RegisterMethod(@TSynEditUndoList.AddGroupBreak, 'AddGroupBreak');
    RegisterMethod(@TSynEditUndoList.DeleteItem, 'DeleteItem');
    RegisterPropertyHelper(@TSynEditUndoListBlockChangeNumber_R,@TSynEditUndoListBlockChangeNumber_W,'BlockChangeNumber');
    RegisterPropertyHelper(@TSynEditUndoListCanUndo_R,nil,'CanUndo');
    RegisterPropertyHelper(@TSynEditUndoListFullUndoImpossible_R,nil,'FullUndoImpossible');
    RegisterPropertyHelper(@TSynEditUndoListInitialState_R,@TSynEditUndoListInitialState_W,'InitialState');
    RegisterPropertyHelper(@TSynEditUndoListItems_R,@TSynEditUndoListItems_W,'Items');
    RegisterPropertyHelper(@TSynEditUndoListItemCount_R,nil,'ItemCount');
    RegisterPropertyHelper(@TSynEditUndoListBlockCount_R,nil,'BlockCount');
    RegisterPropertyHelper(@TSynEditUndoListMaxUndoActions_R,@TSynEditUndoListMaxUndoActions_W,'MaxUndoActions');
    RegisterPropertyHelper(@TSynEditUndoListInsideRedo_R,@TSynEditUndoListInsideRedo_W,'InsideRedo');
    RegisterPropertyHelper(@TSynEditUndoListOnAddedUndo_R,@TSynEditUndoListOnAddedUndo_W,'OnAddedUndo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditUndoItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditUndoItem) do
  begin
    RegisterMethod(@TSynEditUndoItem.Assign, 'Assign');
    RegisterPropertyHelper(@TSynEditUndoItemChangeReason_R,nil,'ChangeReason');
    RegisterPropertyHelper(@TSynEditUndoItemChangeSelMode_R,nil,'ChangeSelMode');
    RegisterPropertyHelper(@TSynEditUndoItemChangeStartPos_R,nil,'ChangeStartPos');
    RegisterPropertyHelper(@TSynEditUndoItemChangeEndPos_R,nil,'ChangeEndPos');
    RegisterPropertyHelper(@TSynEditUndoItemChangeStr_R,nil,'ChangeStr');
    RegisterPropertyHelper(@TSynEditUndoItemChangeNumber_R,nil,'ChangeNumber');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditStringList) do begin
    RegisterConstructor(@TSynEditStringList.Create, 'Create');
     RegisterMethod(@TSynEditStringList.Destroy, 'Free');

    RegisterMethod(@TSynEditStringList.Add, 'Add');
    RegisterMethod(@TSynEditStringList.AddStrings, 'AddStrings');
    RegisterMethod(@TSynEditStringList.Clear, 'Clear');
    RegisterMethod(@TSynEditStringList.Delete, 'Delete');
    RegisterMethod(@TSynEditStringList.DeleteLines, 'DeleteLines');
    RegisterMethod(@TSynEditStringList.Exchange, 'Exchange');
    RegisterMethod(@TSynEditStringList.Insert, 'Insert');
    RegisterMethod(@TSynEditStringList.InsertLines, 'InsertLines');
    RegisterMethod(@TSynEditStringList.InsertStrings, 'InsertStrings');
    RegisterMethod(@TSynEditStringList.InsertText, 'InsertText');
    RegisterMethod(@TSynEditStringList.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TSynEditStringList.SaveToFile, 'SaveToFile');
    RegisterMethod(@TSynEditStringList.SaveToStream, 'SaveToStream');
    RegisterMethod(@TSynEditStringList.LoadFromStream, 'LoadFromStream');
    RegisterPropertyHelper(@TSynEditStringListAppendNewLineAtEOF_R,@TSynEditStringListAppendNewLineAtEOF_W,'AppendNewLineAtEOF');
    RegisterPropertyHelper(@TSynEditStringListFileFormat_R,@TSynEditStringListFileFormat_W,'FileFormat');
    RegisterPropertyHelper(@TSynEditStringListExpandedStrings_R,nil,'ExpandedStrings');
    RegisterPropertyHelper(@TSynEditStringListExpandedStringLengths_R,nil,'ExpandedStringLengths');
    RegisterPropertyHelper(@TSynEditStringListLengthOfLongestLine_R,nil,'LengthOfLongestLine');
    RegisterPropertyHelper(@TSynEditStringListRanges_R,@TSynEditStringListRanges_W,'Ranges');
    RegisterPropertyHelper(@TSynEditStringListTabWidth_R,@TSynEditStringListTabWidth_W,'TabWidth');
    RegisterPropertyHelper(@TSynEditStringListOnChange_R,@TSynEditStringListOnChange_W,'OnChange');
    RegisterPropertyHelper(@TSynEditStringListOnChanging_R,@TSynEditStringListOnChanging_W,'OnChanging');
    RegisterPropertyHelper(@TSynEditStringListOnCleared_R,@TSynEditStringListOnCleared_W,'OnCleared');
    RegisterPropertyHelper(@TSynEditStringListOnDeleted_R,@TSynEditStringListOnDeleted_W,'OnDeleted');
    RegisterPropertyHelper(@TSynEditStringListOnInserted_R,@TSynEditStringListOnInserted_W,'OnInserted');
    RegisterPropertyHelper(@TSynEditStringListOnPutted_R,@TSynEditStringListOnPutted_W,'OnPutted');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditTextBuffer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynEditStringList(CL);
  with CL.Add(ESynEditStringList) do
  RIRegister_TSynEditUndoItem(CL);
  RIRegister_TSynEditUndoList(CL);
end;

 
 
{ TPSImport_SynEditTextBuffer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditTextBuffer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEditTextBuffer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditTextBuffer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynEditTextBuffer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
