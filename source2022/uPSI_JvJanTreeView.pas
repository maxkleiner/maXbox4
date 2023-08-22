unit uPSI_JvJanTreeView;
{
   including a math parser
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
  TPSImport_JvJanTreeView = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvJanTreeView(CL: TPSPascalCompiler);
procedure SIRegister_TTreeKeyMappings(CL: TPSPascalCompiler);
procedure SIRegister_TJvMathParser2(CL: TPSPascalCompiler);
procedure SIRegister_JvJanTreeView(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvJanTreeView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTreeKeyMappings(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvMathParser2(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvJanTreeView(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  //,ShellAPI
  //,Messages
  Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ComCtrls
  ,Menus
  ,JvJanTreeView
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvJanTreeView]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvJanTreeView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTreeView', 'TJvJanTreeView') do
  with CL.AddClassN(CL.FindClass('TTreeView'),'TJvJanTreeView') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure DuplicateNode');
    RegisterMethod('Procedure DragDrop( Source : TObject; X, Y : Integer)');
    RegisterMethod('Procedure DoAddNode');
    RegisterMethod('Procedure DoAddChildNode');
    RegisterMethod('Procedure DoDeleteNode');
    RegisterMethod('Procedure DoInsertNode');
    RegisterMethod('Procedure DoEditNode');
    RegisterMethod('Procedure DoFindNode');
    RegisterMethod('Procedure DoLoadTree');
    RegisterMethod('Procedure DoSaveTree');
    RegisterMethod('Procedure DoSaveTreeAs');
    RegisterMethod('Procedure DoCloseTree');
    RegisterMethod('Procedure Recalculate');
    RegisterProperty('KeyMappings', 'TTreeKeyMappings', iptrw);
    RegisterProperty('KeyMappingsEnabled', 'Boolean', iptrw);
    RegisterProperty('ColorFormulas', 'Boolean', iptrw);
    RegisterProperty('FormuleColor', 'TColor', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('DefaultExt', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTreeKeyMappings(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTreeKeyMappings') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTreeKeyMappings') do begin
    RegisterProperty('AddNode', 'TShortCut', iptrw);
    RegisterProperty('DeleteNode', 'TShortCut', iptrw);
    RegisterProperty('InsertNode', 'TShortCut', iptrw);
    RegisterProperty('AddChildNode', 'TShortCut', iptrw);
    RegisterProperty('DuplicateNode', 'TShortCut', iptrw);
    RegisterProperty('EditNode', 'TShortCut', iptrw);
    RegisterProperty('FindNode', 'TShortCut', iptrw);
    RegisterProperty('LoadTree', 'TShortCut', iptrw);
    RegisterProperty('SaveTree', 'TShortCut', iptrw);
    RegisterProperty('SaveTreeAs', 'TShortCut', iptrw);
    RegisterProperty('CloseTree', 'TShortCut', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMathParser2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvMathParser2') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvMathParser2') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Parse');
    RegisterProperty('Position', 'Word', iptrw);
    RegisterProperty('ParseError', 'Boolean', iptrw);
    RegisterProperty('ParseValue', 'Extended', iptrw);
    RegisterProperty('OnGetVar', 'TGetVarEvent', iptrw);
    RegisterProperty('OnParseError', 'TParseErrorEvent', iptrw);
    RegisterProperty('ParseString', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvJanTreeView(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TGetVarEvent', 'Procedure ( Sender : TObject; VarName : string; '
   +'var Value : Extended; var Found : Boolean)');
  CL.AddTypeS('TParseErrorEvent', 'Procedure ( Sender : TObject; ParseError : Integer)');
 CL.AddConstantN('ParserStackSize','LongInt').SetInt( 15);
 CL.AddConstantN('MaxFuncNameLen','LongInt').SetInt( 5);
 CL.AddConstantN('ExpLimit','LongInt').SetInt( 11356);
 CL.AddConstantN('SqrLimit','Extended').setExtended( 1E2466);
 CL.AddConstantN('MaxExpLen','LongInt').SetInt( 4);
 CL.AddConstantN('TotalErrors','LongInt').SetInt( 7);
 CL.AddConstantN('ErrParserStack','LongInt').SetInt( 1);
 CL.AddConstantN('ErrBadRange','LongInt').SetInt( 2);
 CL.AddConstantN('ErrExpression','LongInt').SetInt( 3);
 CL.AddConstantN('ErrOperator','LongInt').SetInt( 4);
 CL.AddConstantN('ErrOpenParen','LongInt').SetInt( 5);
 CL.AddConstantN('ErrOpCloseParen','LongInt').SetInt( 6);
 CL.AddConstantN('ErrInvalidNum','LongInt').SetInt( 7);
  CL.AddTypeS('ErrorRange', 'Integer');
  CL.AddTypeS('TokenTypes', '( ttPlus, ttMinus, ttTimes, ttDivide, ttExpo, ttOP'
   +'aren, ttCParen, ttNum, ttFunc, ttEol, ttBad, ttErr, ttModu )');
  CL.AddTypeS('TokenRec', 'record State : Byte; Value : Extended; end');
  CL.AddTypeS('TStackTop', 'Integer');
  SIRegister_TJvMathParser2(CL);
  SIRegister_TTreeKeyMappings(CL);
  SIRegister_TJvJanTreeView(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewDefaultExt_W(Self: TJvJanTreeView; const T: string);
begin Self.DefaultExt := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewDefaultExt_R(Self: TJvJanTreeView; var T: string);
begin T := Self.DefaultExt; end;

(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewFileName_W(Self: TJvJanTreeView; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewFileName_R(Self: TJvJanTreeView; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewFormuleColor_W(Self: TJvJanTreeView; const T: TColor);
begin Self.FormuleColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewFormuleColor_R(Self: TJvJanTreeView; var T: TColor);
begin T := Self.FormuleColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewColorFormulas_W(Self: TJvJanTreeView; const T: Boolean);
begin Self.ColorFormulas := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewColorFormulas_R(Self: TJvJanTreeView; var T: Boolean);
begin T := Self.ColorFormulas; end;

(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewKeyMappingsEnabled_W(Self: TJvJanTreeView; const T: Boolean);
begin Self.KeyMappingsEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewKeyMappingsEnabled_R(Self: TJvJanTreeView; var T: Boolean);
begin T := Self.KeyMappingsEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewKeyMappings_W(Self: TJvJanTreeView; const T: TTreeKeyMappings);
begin Self.KeyMappings := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJanTreeViewKeyMappings_R(Self: TJvJanTreeView; var T: TTreeKeyMappings);
begin T := Self.KeyMappings; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsCloseTree_W(Self: TTreeKeyMappings; const T: TShortCut);
begin Self.CloseTree := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsCloseTree_R(Self: TTreeKeyMappings; var T: TShortCut);
begin T := Self.CloseTree; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsSaveTreeAs_W(Self: TTreeKeyMappings; const T: TShortCut);
begin Self.SaveTreeAs := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsSaveTreeAs_R(Self: TTreeKeyMappings; var T: TShortCut);
begin T := Self.SaveTreeAs; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsSaveTree_W(Self: TTreeKeyMappings; const T: TShortCut);
begin Self.SaveTree := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsSaveTree_R(Self: TTreeKeyMappings; var T: TShortCut);
begin T := Self.SaveTree; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsLoadTree_W(Self: TTreeKeyMappings; const T: TShortCut);
begin Self.LoadTree := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsLoadTree_R(Self: TTreeKeyMappings; var T: TShortCut);
begin T := Self.LoadTree; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsFindNode_W(Self: TTreeKeyMappings; const T: TShortCut);
begin Self.FindNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsFindNode_R(Self: TTreeKeyMappings; var T: TShortCut);
begin T := Self.FindNode; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsEditNode_W(Self: TTreeKeyMappings; const T: TShortCut);
begin Self.EditNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsEditNode_R(Self: TTreeKeyMappings; var T: TShortCut);
begin T := Self.EditNode; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsDuplicateNode_W(Self: TTreeKeyMappings; const T: TShortCut);
begin Self.DuplicateNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsDuplicateNode_R(Self: TTreeKeyMappings; var T: TShortCut);
begin T := Self.DuplicateNode; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsAddChildNode_W(Self: TTreeKeyMappings; const T: TShortCut);
begin Self.AddChildNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsAddChildNode_R(Self: TTreeKeyMappings; var T: TShortCut);
begin T := Self.AddChildNode; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsInsertNode_W(Self: TTreeKeyMappings; const T: TShortCut);
begin Self.InsertNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsInsertNode_R(Self: TTreeKeyMappings; var T: TShortCut);
begin T := Self.InsertNode; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsDeleteNode_W(Self: TTreeKeyMappings; const T: TShortCut);
begin Self.DeleteNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsDeleteNode_R(Self: TTreeKeyMappings; var T: TShortCut);
begin T := Self.DeleteNode; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsAddNode_W(Self: TTreeKeyMappings; const T: TShortCut);
begin Self.AddNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TTreeKeyMappingsAddNode_R(Self: TTreeKeyMappings; var T: TShortCut);
begin T := Self.AddNode; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2ParseString_W(Self: TJvMathParser2; const T: string);
begin Self.ParseString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2ParseString_R(Self: TJvMathParser2; var T: string);
begin T := Self.ParseString; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2OnParseError_W(Self: TJvMathParser2; const T: TParseErrorEvent);
begin Self.OnParseError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2OnParseError_R(Self: TJvMathParser2; var T: TParseErrorEvent);
begin T := Self.OnParseError; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2OnGetVar_W(Self: TJvMathParser2; const T: TGetVarEvent);
begin Self.OnGetVar := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2OnGetVar_R(Self: TJvMathParser2; var T: TGetVarEvent);
begin T := Self.OnGetVar; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2ParseValue_W(Self: TJvMathParser2; const T: Extended);
begin Self.ParseValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2ParseValue_R(Self: TJvMathParser2; var T: Extended);
begin T := Self.ParseValue; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2ParseError_W(Self: TJvMathParser2; const T: Boolean);
begin Self.ParseError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2ParseError_R(Self: TJvMathParser2; var T: Boolean);
begin T := Self.ParseError; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2Position_W(Self: TJvMathParser2; const T: Word);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMathParser2Position_R(Self: TJvMathParser2; var T: Word);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvJanTreeView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvJanTreeView) do begin
    RegisterConstructor(@TJvJanTreeView.Create, 'Create');
    RegisterMethod(@TJvJanTreeView.DuplicateNode, 'DuplicateNode');
    RegisterMethod(@TJvJanTreeView.DragDrop, 'DragDrop');
    RegisterMethod(@TJvJanTreeView.DoAddNode, 'DoAddNode');
    RegisterMethod(@TJvJanTreeView.DoAddChildNode, 'DoAddChildNode');
    RegisterMethod(@TJvJanTreeView.DoDeleteNode, 'DoDeleteNode');
    RegisterMethod(@TJvJanTreeView.DoInsertNode, 'DoInsertNode');
    RegisterMethod(@TJvJanTreeView.DoEditNode, 'DoEditNode');
    RegisterMethod(@TJvJanTreeView.DoFindNode, 'DoFindNode');
    RegisterMethod(@TJvJanTreeView.DoLoadTree, 'DoLoadTree');
    RegisterMethod(@TJvJanTreeView.DoSaveTree, 'DoSaveTree');
    RegisterMethod(@TJvJanTreeView.DoSaveTreeAs, 'DoSaveTreeAs');
    RegisterMethod(@TJvJanTreeView.DoCloseTree, 'DoCloseTree');
    RegisterMethod(@TJvJanTreeView.Recalculate, 'Recalculate');
    RegisterPropertyHelper(@TJvJanTreeViewKeyMappings_R,@TJvJanTreeViewKeyMappings_W,'KeyMappings');
    RegisterPropertyHelper(@TJvJanTreeViewKeyMappingsEnabled_R,@TJvJanTreeViewKeyMappingsEnabled_W,'KeyMappingsEnabled');
    RegisterPropertyHelper(@TJvJanTreeViewColorFormulas_R,@TJvJanTreeViewColorFormulas_W,'ColorFormulas');
    RegisterPropertyHelper(@TJvJanTreeViewFormuleColor_R,@TJvJanTreeViewFormuleColor_W,'FormuleColor');
    RegisterPropertyHelper(@TJvJanTreeViewFileName_R,@TJvJanTreeViewFileName_W,'FileName');
    RegisterPropertyHelper(@TJvJanTreeViewDefaultExt_R,@TJvJanTreeViewDefaultExt_W,'DefaultExt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTreeKeyMappings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTreeKeyMappings) do begin
    RegisterPropertyHelper(@TTreeKeyMappingsAddNode_R,@TTreeKeyMappingsAddNode_W,'AddNode');
    RegisterPropertyHelper(@TTreeKeyMappingsDeleteNode_R,@TTreeKeyMappingsDeleteNode_W,'DeleteNode');
    RegisterPropertyHelper(@TTreeKeyMappingsInsertNode_R,@TTreeKeyMappingsInsertNode_W,'InsertNode');
    RegisterPropertyHelper(@TTreeKeyMappingsAddChildNode_R,@TTreeKeyMappingsAddChildNode_W,'AddChildNode');
    RegisterPropertyHelper(@TTreeKeyMappingsDuplicateNode_R,@TTreeKeyMappingsDuplicateNode_W,'DuplicateNode');
    RegisterPropertyHelper(@TTreeKeyMappingsEditNode_R,@TTreeKeyMappingsEditNode_W,'EditNode');
    RegisterPropertyHelper(@TTreeKeyMappingsFindNode_R,@TTreeKeyMappingsFindNode_W,'FindNode');
    RegisterPropertyHelper(@TTreeKeyMappingsLoadTree_R,@TTreeKeyMappingsLoadTree_W,'LoadTree');
    RegisterPropertyHelper(@TTreeKeyMappingsSaveTree_R,@TTreeKeyMappingsSaveTree_W,'SaveTree');
    RegisterPropertyHelper(@TTreeKeyMappingsSaveTreeAs_R,@TTreeKeyMappingsSaveTreeAs_W,'SaveTreeAs');
    RegisterPropertyHelper(@TTreeKeyMappingsCloseTree_R,@TTreeKeyMappingsCloseTree_W,'CloseTree');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMathParser2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMathParser2) do begin
    RegisterConstructor(@TJvMathParser2.Create, 'Create');
    RegisterMethod(@TJvMathParser2.Parse, 'Parse');
    RegisterPropertyHelper(@TJvMathParser2Position_R,@TJvMathParser2Position_W,'Position');
    RegisterPropertyHelper(@TJvMathParser2ParseError_R,@TJvMathParser2ParseError_W,'ParseError');
    RegisterPropertyHelper(@TJvMathParser2ParseValue_R,@TJvMathParser2ParseValue_W,'ParseValue');
    RegisterPropertyHelper(@TJvMathParser2OnGetVar_R,@TJvMathParser2OnGetVar_W,'OnGetVar');
    RegisterPropertyHelper(@TJvMathParser2OnParseError_R,@TJvMathParser2OnParseError_W,'OnParseError');
    RegisterPropertyHelper(@TJvMathParser2ParseString_R,@TJvMathParser2ParseString_W,'ParseString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvJanTreeView(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvMathParser2(CL);
  RIRegister_TTreeKeyMappings(CL);
  RIRegister_TJvJanTreeView(CL);
end;

 
 
{ TPSImport_JvJanTreeView }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvJanTreeView.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvJanTreeView(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvJanTreeView.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvJanTreeView(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
