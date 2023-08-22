unit uPSI_ALAVLBinaryTree;
{
   begin of AL
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
  TPSImport_ALAVLBinaryTree = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALStringKeyAVLBinaryTree(CL: TPSPascalCompiler);
procedure SIRegister_TALStringKeyAVLBinaryTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_TALInt64KeyAVLBinaryTree(CL: TPSPascalCompiler);
procedure SIRegister_TALInt64KeyAVLBinaryTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_TALCardinalKeyAVLBinaryTree(CL: TPSPascalCompiler);
procedure SIRegister_TALCardinalKeyAVLBinaryTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_TALIntegerKeyAVLBinaryTree(CL: TPSPascalCompiler);
procedure SIRegister_TALIntegerKeyAVLBinaryTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_TALBaseAVLBinaryTree(CL: TPSPascalCompiler);
procedure SIRegister_TALBaseAVLBinaryTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_ALAVLBinaryTree(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALStringKeyAVLBinaryTree(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALStringKeyAVLBinaryTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALInt64KeyAVLBinaryTree(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALInt64KeyAVLBinaryTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALCardinalKeyAVLBinaryTree(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALCardinalKeyAVLBinaryTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALIntegerKeyAVLBinaryTree(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALIntegerKeyAVLBinaryTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALBaseAVLBinaryTree(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALBaseAVLBinaryTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALAVLBinaryTree(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ALAVLBinaryTree
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALAVLBinaryTree]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALStringKeyAVLBinaryTree(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseAVLBinaryTree', 'TALStringKeyAVLBinaryTree') do
  with CL.AddClassN(CL.FindClass('TALBaseAVLBinaryTree'),'TALStringKeyAVLBinaryTree') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function AddNode( aNode : TALStringKeyAVLBinaryTreeNode) : Boolean');
    RegisterMethod('Function ExtractNode( IdVal : AnsiString) : TALStringKeyAVLBinaryTreeNode');
    RegisterMethod('Function DeleteNode( idVal : AnsiString) : boolean');
    RegisterMethod('Function Head : TALStringKeyAVLBinaryTreeNode');
    RegisterMethod('Function FindNode( idVal : AnsiString) : TALStringKeyAVLBinaryTreeNode');
    RegisterMethod('Function First : TALStringKeyAVLBinaryTreeNode');
    RegisterMethod('Function Last : TALStringKeyAVLBinaryTreeNode');
    RegisterMethod('Function Next( aNode : TALStringKeyAVLBinaryTreeNode) : TALStringKeyAVLBinaryTreeNode');
    RegisterMethod('Function Prev( aNode : TALStringKeyAVLBinaryTreeNode) : TALStringKeyAVLBinaryTreeNode');
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALStringKeyAVLBinaryTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseAVLBinaryTreeNode', 'TALStringKeyAVLBinaryTreeNode') do
  //TALStringKeyAVLBinaryTreeNode
  with CL.AddClassN(CL.FindClass('TALBaseAVLBinaryTreeNode'),'TALStringKeyAVLBinaryTreeNode') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('ID', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALInt64KeyAVLBinaryTree(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseAVLBinaryTree', 'TALInt64KeyAVLBinaryTree') do
  with CL.AddClassN(CL.FindClass('TALBaseAVLBinaryTree'),'TALInt64KeyAVLBinaryTree') do
  begin
    RegisterMethod('Function AddNode( aNode : TALInt64KeyAVLBinaryTreeNode) : Boolean');
    RegisterMethod('Function ExtractNode( IdVal : Int64) : TALInt64KeyAVLBinaryTreeNode');
    RegisterMethod('Function DeleteNode( idVal : Int64) : boolean');
    RegisterMethod('Function Head : TALInt64KeyAVLBinaryTreeNode');
    RegisterMethod('Function FindNode( idVal : int64) : TALInt64KeyAVLBinaryTreeNode');
    RegisterMethod('Function First : TALInt64KeyAVLBinaryTreeNode');
    RegisterMethod('Function Last : TALInt64KeyAVLBinaryTreeNode');
    RegisterMethod('Function Next( aNode : TALInt64KeyAVLBinaryTreeNode) : TALInt64KeyAVLBinaryTreeNode');
    RegisterMethod('Function Prev( aNode : TALInt64KeyAVLBinaryTreeNode) : TALInt64KeyAVLBinaryTreeNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALInt64KeyAVLBinaryTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseAVLBinaryTreeNode', 'TALInt64KeyAVLBinaryTreeNode') do
  with CL.AddClassN(CL.FindClass('TALBaseAVLBinaryTreeNode'),'TALInt64KeyAVLBinaryTreeNode') do
  begin
    RegisterProperty('ID', 'Int64', iptrw);
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALCardinalKeyAVLBinaryTree(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseAVLBinaryTree', 'TALCardinalKeyAVLBinaryTree') do
  with CL.AddClassN(CL.FindClass('TALBaseAVLBinaryTree'),'TALCardinalKeyAVLBinaryTree') do
  begin
    RegisterMethod('Function AddNode( aNode : TALCardinalKeyAVLBinaryTreeNode) : Boolean');
    RegisterMethod('Function ExtractNode( IdVal : Cardinal) : TALCardinalKeyAVLBinaryTreeNode');
    RegisterMethod('Function DeleteNode( idVal : Cardinal) : boolean');
    RegisterMethod('Function Head : TALCardinalKeyAVLBinaryTreeNode');
    RegisterMethod('Function FindNode( idVal : Cardinal) : TALCardinalKeyAVLBinaryTreeNode');
    RegisterMethod('Function First : TALCardinalKeyAVLBinaryTreeNode');
    RegisterMethod('Function Last : TALCardinalKeyAVLBinaryTreeNode');
    RegisterMethod('Function Next( aNode : TALCardinalKeyAVLBinaryTreeNode) : TALCardinalKeyAVLBinaryTreeNode');
    RegisterMethod('Function Prev( aNode : TALCardinalKeyAVLBinaryTreeNode) : TALCardinalKeyAVLBinaryTreeNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALCardinalKeyAVLBinaryTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseAVLBinaryTreeNode', 'TALCardinalKeyAVLBinaryTreeNode') do
  with CL.AddClassN(CL.FindClass('TALBaseAVLBinaryTreeNode'),'TALCardinalKeyAVLBinaryTreeNode') do
  begin
    RegisterProperty('ID', 'Cardinal', iptrw);
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALIntegerKeyAVLBinaryTree(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseAVLBinaryTree', 'TALIntegerKeyAVLBinaryTree') do
  with CL.AddClassN(CL.FindClass('TALBaseAVLBinaryTree'),'TALIntegerKeyAVLBinaryTree') do
  begin
    RegisterMethod('Function AddNode( aNode : TALIntegerKeyAVLBinaryTreeNode) : Boolean');
    RegisterMethod('Function ExtractNode( IdVal : Integer) : TALIntegerKeyAVLBinaryTreeNode');
    RegisterMethod('Function DeleteNode( idVal : Integer) : boolean');
    RegisterMethod('Function Head : TALIntegerKeyAVLBinaryTreeNode');
    RegisterMethod('Function FindNode( idVal : Integer) : TALIntegerKeyAVLBinaryTreeNode');
    RegisterMethod('Function First : TALIntegerKeyAVLBinaryTreeNode');
    RegisterMethod('Function Last : TALIntegerKeyAVLBinaryTreeNode');
    RegisterMethod('Function Next( aNode : TALIntegerKeyAVLBinaryTreeNode) : TALIntegerKeyAVLBinaryTreeNode');
    RegisterMethod('Function Prev( aNode : TALIntegerKeyAVLBinaryTreeNode) : TALIntegerKeyAVLBinaryTreeNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALIntegerKeyAVLBinaryTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseAVLBinaryTreeNode', 'TALIntegerKeyAVLBinaryTreeNode') do
  with CL.AddClassN(CL.FindClass('TALBaseAVLBinaryTreeNode'),'TALIntegerKeyAVLBinaryTreeNode') do
  begin
    RegisterProperty('ID', 'Integer', iptrw);
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALBaseAVLBinaryTree(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALBaseAVLBinaryTree') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALBaseAVLBinaryTree') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Iterate( Action : TALAVLBinaryTreeIterateFunc; Up : Boolean; ExtData : Pointer)');
    RegisterMethod('Function AddNode( aNode : TALBaseAVLBinaryTreeNode) : Boolean');
    RegisterMethod('Function ExtractNode( IdVal : Pointer) : TALBaseAVLBinaryTreeNode');
    RegisterMethod('Function DeleteNode( IdVal : Pointer) : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Head : TALBaseAVLBinaryTreeNode');
    RegisterMethod('Procedure SaveToStream( Astream : Tstream)');
    RegisterMethod('Procedure LoadFromStream( Astream : Tstream)');
    RegisterMethod('Procedure SaveToFile( AFilename : AnsiString)');
    RegisterMethod('Procedure LoadFromFile( AFilename : AnsiString)');
    RegisterMethod('Function FindNode( idVal : pointer) : TALBaseAVLBinaryTreeNode');
    RegisterMethod('Function First : TALBaseAVLBinaryTreeNode');
    RegisterMethod('Function Last : TALBaseAVLBinaryTreeNode');
    RegisterMethod('Function Next( aNode : TALBaseAVLBinaryTreeNode) : TALBaseAVLBinaryTreeNode');
    RegisterMethod('Function Prev( aNode : TALBaseAVLBinaryTreeNode) : TALBaseAVLBinaryTreeNode');
    RegisterMethod('Function NodeCount : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALBaseAVLBinaryTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TALBaseAVLBinaryTreeNode') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TALBaseAVLBinaryTreeNode') do
  begin
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALAVLBinaryTree(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TALBaseAVLBinaryTreeNode');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TALBaseAVLBinaryTree');
  SIRegister_TALBaseAVLBinaryTreeNode(CL);
  SIRegister_TALBaseAVLBinaryTree(CL);
  SIRegister_TALIntegerKeyAVLBinaryTreeNode(CL);
  SIRegister_TALIntegerKeyAVLBinaryTree(CL);
  SIRegister_TALCardinalKeyAVLBinaryTreeNode(CL);
  SIRegister_TALCardinalKeyAVLBinaryTree(CL);
  SIRegister_TALInt64KeyAVLBinaryTreeNode(CL);
  SIRegister_TALInt64KeyAVLBinaryTree(CL);
  SIRegister_TALStringKeyAVLBinaryTreeNode(CL);
  CL.AddTypeS('TALStringKeyAVLBinaryTreeCompareKeyFunct', 'Function ( const aKe'
   +'y1, aKey2 : AnsiString) : Integer');
  SIRegister_TALStringKeyAVLBinaryTree(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALStringKeyAVLBinaryTreeCaseSensitive_W(Self: TALStringKeyAVLBinaryTree; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringKeyAVLBinaryTreeCaseSensitive_R(Self: TALStringKeyAVLBinaryTree; var T: Boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TALStringKeyAVLBinaryTreeNodeID_W(Self: TALStringKeyAVLBinaryTreeNode; const T: AnsiString);
Begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringKeyAVLBinaryTreeNodeID_R(Self: TALStringKeyAVLBinaryTreeNode; var T: AnsiString);
Begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TALInt64KeyAVLBinaryTreeNodeID_W(Self: TALInt64KeyAVLBinaryTreeNode; const T: Int64);
Begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TALInt64KeyAVLBinaryTreeNodeID_R(Self: TALInt64KeyAVLBinaryTreeNode; var T: Int64);
Begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TALCardinalKeyAVLBinaryTreeNodeID_W(Self: TALCardinalKeyAVLBinaryTreeNode; const T: Cardinal);
Begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TALCardinalKeyAVLBinaryTreeNodeID_R(Self: TALCardinalKeyAVLBinaryTreeNode; var T: Cardinal);
Begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TALIntegerKeyAVLBinaryTreeNodeID_W(Self: TALIntegerKeyAVLBinaryTreeNode; const T: Integer);
Begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TALIntegerKeyAVLBinaryTreeNodeID_R(Self: TALIntegerKeyAVLBinaryTreeNode; var T: Integer);
Begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
Function TALBaseAVLBinaryTreeCompareNode1_P(Self: TALBaseAVLBinaryTree;  aNode1, ANode2 : TALBaseAVLBinaryTreeNode) : Integer;
Begin //Result := Self.CompareNode(aNode1, ANode2);
END;

(*----------------------------------------------------------------------------*)
Function TALBaseAVLBinaryTreeCompareNode_P(Self: TALBaseAVLBinaryTree;  IdVal : pointer; ANode : TALBaseAVLBinaryTreeNode) : Integer;
Begin //Result := Self.CompareNode(IdVal, ANode);
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALStringKeyAVLBinaryTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALStringKeyAVLBinaryTree) do begin
    RegisterConstructor(@TALStringKeyAVLBinaryTree.Create, 'Create');
    RegisterVirtualMethod(@TALStringKeyAVLBinaryTree.AddNode, 'AddNode');
    RegisterVirtualMethod(@TALStringKeyAVLBinaryTree.ExtractNode, 'ExtractNode');
    RegisterVirtualMethod(@TALStringKeyAVLBinaryTree.DeleteNode, 'DeleteNode');
    RegisterVirtualMethod(@TALStringKeyAVLBinaryTree.Head, 'Head');
    RegisterVirtualMethod(@TALStringKeyAVLBinaryTree.FindNode, 'FindNode');
    RegisterVirtualMethod(@TALStringKeyAVLBinaryTree.First, 'First');
    RegisterVirtualMethod(@TALStringKeyAVLBinaryTree.Last, 'Last');
    RegisterVirtualMethod(@TALStringKeyAVLBinaryTree.Next, 'Next');
    RegisterVirtualMethod(@TALStringKeyAVLBinaryTree.Prev, 'Prev');
    RegisterPropertyHelper(@TALStringKeyAVLBinaryTreeCaseSensitive_R,@TALStringKeyAVLBinaryTreeCaseSensitive_W,'CaseSensitive');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALStringKeyAVLBinaryTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALStringKeyAVLBinaryTreeNode) do begin
   //RegisterMethod(@TALStringKeyAVLBinaryTreeNode.Destroy, 'Free');
   RegisterConstructor(@TALStringKeyAVLBinaryTreeNode.Create, 'Create');
    RegisterPropertyHelper(@TALStringKeyAVLBinaryTreeNodeID_R,@TALStringKeyAVLBinaryTreeNodeID_W,'ID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALInt64KeyAVLBinaryTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALInt64KeyAVLBinaryTree) do
  begin
    RegisterVirtualMethod(@TALInt64KeyAVLBinaryTree.AddNode, 'AddNode');
    RegisterVirtualMethod(@TALInt64KeyAVLBinaryTree.ExtractNode, 'ExtractNode');
    RegisterVirtualMethod(@TALInt64KeyAVLBinaryTree.DeleteNode, 'DeleteNode');
    RegisterVirtualMethod(@TALInt64KeyAVLBinaryTree.Head, 'Head');
    RegisterVirtualMethod(@TALInt64KeyAVLBinaryTree.FindNode, 'FindNode');
    RegisterVirtualMethod(@TALInt64KeyAVLBinaryTree.First, 'First');
    RegisterVirtualMethod(@TALInt64KeyAVLBinaryTree.Last, 'Last');
    RegisterVirtualMethod(@TALInt64KeyAVLBinaryTree.Next, 'Next');
    RegisterVirtualMethod(@TALInt64KeyAVLBinaryTree.Prev, 'Prev');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALInt64KeyAVLBinaryTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALInt64KeyAVLBinaryTreeNode) do
  begin
    RegisterPropertyHelper(@TALInt64KeyAVLBinaryTreeNodeID_R,@TALInt64KeyAVLBinaryTreeNodeID_W,'ID');
    RegisterConstructor(@TALInt64KeyAVLBinaryTreeNode.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALCardinalKeyAVLBinaryTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALCardinalKeyAVLBinaryTree) do
  begin
    RegisterVirtualMethod(@TALCardinalKeyAVLBinaryTree.AddNode, 'AddNode');
    RegisterVirtualMethod(@TALCardinalKeyAVLBinaryTree.ExtractNode, 'ExtractNode');
    RegisterVirtualMethod(@TALCardinalKeyAVLBinaryTree.DeleteNode, 'DeleteNode');
    RegisterVirtualMethod(@TALCardinalKeyAVLBinaryTree.Head, 'Head');
    RegisterVirtualMethod(@TALCardinalKeyAVLBinaryTree.FindNode, 'FindNode');
    RegisterVirtualMethod(@TALCardinalKeyAVLBinaryTree.First, 'First');
    RegisterVirtualMethod(@TALCardinalKeyAVLBinaryTree.Last, 'Last');
    RegisterVirtualMethod(@TALCardinalKeyAVLBinaryTree.Next, 'Next');
    RegisterVirtualMethod(@TALCardinalKeyAVLBinaryTree.Prev, 'Prev');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALCardinalKeyAVLBinaryTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALCardinalKeyAVLBinaryTreeNode) do
  begin
    RegisterPropertyHelper(@TALCardinalKeyAVLBinaryTreeNodeID_R,@TALCardinalKeyAVLBinaryTreeNodeID_W,'ID');
    RegisterConstructor(@TALCardinalKeyAVLBinaryTreeNode.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALIntegerKeyAVLBinaryTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALIntegerKeyAVLBinaryTree) do
  begin
    RegisterVirtualMethod(@TALIntegerKeyAVLBinaryTree.AddNode, 'AddNode');
    RegisterVirtualMethod(@TALIntegerKeyAVLBinaryTree.ExtractNode, 'ExtractNode');
    RegisterVirtualMethod(@TALIntegerKeyAVLBinaryTree.DeleteNode, 'DeleteNode');
    RegisterVirtualMethod(@TALIntegerKeyAVLBinaryTree.Head, 'Head');
    RegisterVirtualMethod(@TALIntegerKeyAVLBinaryTree.FindNode, 'FindNode');
    RegisterVirtualMethod(@TALIntegerKeyAVLBinaryTree.First, 'First');
    RegisterVirtualMethod(@TALIntegerKeyAVLBinaryTree.Last, 'Last');
    RegisterVirtualMethod(@TALIntegerKeyAVLBinaryTree.Next, 'Next');
    RegisterVirtualMethod(@TALIntegerKeyAVLBinaryTree.Prev, 'Prev');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALIntegerKeyAVLBinaryTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALIntegerKeyAVLBinaryTreeNode) do
  begin
    RegisterPropertyHelper(@TALIntegerKeyAVLBinaryTreeNodeID_R,@TALIntegerKeyAVLBinaryTreeNodeID_W,'ID');
    RegisterConstructor(@TALIntegerKeyAVLBinaryTreeNode.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALBaseAVLBinaryTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALBaseAVLBinaryTree) do begin
    RegisterVirtualConstructor(@TALBaseAVLBinaryTree.Create, 'Create');
    RegisterMethod(@TALBaseAVLBinaryTree.Destroy, 'Free');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.Iterate, 'Iterate');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.AddNode, 'AddNode');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.ExtractNode, 'ExtractNode');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.DeleteNode, 'DeleteNode');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.Clear, 'Clear');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.Head, 'Head');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.SaveToFile, 'SaveToFile');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.FindNode, 'FindNode');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.First, 'First');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.Last, 'Last');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.Next, 'Next');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.Prev, 'Prev');
    RegisterVirtualMethod(@TALBaseAVLBinaryTree.NodeCount, 'NodeCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALBaseAVLBinaryTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALBaseAVLBinaryTreeNode) do
  begin
    RegisterVirtualConstructor(@TALBaseAVLBinaryTreeNode.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALAVLBinaryTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALBaseAVLBinaryTreeNode) do
  with CL.Add(TALBaseAVLBinaryTree) do
  RIRegister_TALBaseAVLBinaryTreeNode(CL);
  RIRegister_TALBaseAVLBinaryTree(CL);
  RIRegister_TALIntegerKeyAVLBinaryTreeNode(CL);
  RIRegister_TALIntegerKeyAVLBinaryTree(CL);
  RIRegister_TALCardinalKeyAVLBinaryTreeNode(CL);
  RIRegister_TALCardinalKeyAVLBinaryTree(CL);
  RIRegister_TALInt64KeyAVLBinaryTreeNode(CL);
  RIRegister_TALInt64KeyAVLBinaryTree(CL);
  RIRegister_TALStringKeyAVLBinaryTreeNode(CL);
  RIRegister_TALStringKeyAVLBinaryTree(CL);
end;

 
 
{ TPSImport_ALAVLBinaryTree }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALAVLBinaryTree.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALAVLBinaryTree(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALAVLBinaryTree.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALAVLBinaryTree(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
