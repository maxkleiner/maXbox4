unit uPSI_JvXmlTree;
{
  add destructors ,check TList
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
  TPSImport_JvXmlTree = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvXMLTree(CL: TPSPascalCompiler);
procedure SIRegister_TJvXMLNode(CL: TPSPascalCompiler);
procedure SIRegister_TJvXMLAttribute(CL: TPSPascalCompiler);
procedure SIRegister_TJvXMLFilter(CL: TPSPascalCompiler);
procedure SIRegister_TJvXMLFilterAtom(CL: TPSPascalCompiler);
procedure SIRegister_JvXmlTree(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvXmlTree_Routines(S: TPSExec);
procedure RIRegister_TJvXMLTree(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvXMLNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvXMLAttribute(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvXMLFilter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvXMLFilterAtom(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvXmlTree(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Variants
  ,JvStrings
  ,JvXmlTree
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvXmlTree]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXMLTree(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvXMLNode', 'TJvXMLTree') do
  with CL.AddClassN(CL.FindClass('TJvXMLNode'),'TJvXMLTree') do begin
    RegisterMethod('Constructor Create( const AName : string; AValue : Variant; AParent : TJvXMLNode)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ParseXML');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Function AsText : string');
    RegisterProperty('Lines', 'TStrings', iptrw);
    RegisterProperty('NodeCount', 'Integer', iptr);
    RegisterProperty('Text', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXMLNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvXMLNode') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvXMLNode') do begin
    RegisterMethod('Constructor Create( const AName : string; AValue : Variant; AParent : TJvXMLNode)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GetNamePathNode( const APath : string) : TJvXMLNode');
    RegisterMethod('Procedure DeleteNamePathNode( const APath : string)');
    RegisterMethod('Function ForceNamePathNode( const APath : string) : TJvXMLNode');
    RegisterMethod('Function GetNamePathNodeAttribute( const APath, AName : string) : TJvXMLAttribute');
    RegisterMethod('Procedure DeleteNamePathNodeAttribute( const APath, AName : string)');
    RegisterMethod('Function ForceNamePathNodeAttribute( const APath, AName : string; AValue : Variant) : TJvXMLAttribute');
    RegisterMethod('Function AddNode( const AName : string; AValue : Variant) : TJvXMLNode');
    RegisterMethod('Function AddNodeEx( const AName : string; AValue : Variant) : TJvXMLNode');
    RegisterMethod('Procedure DeleteNode( Index : Integer)');
    RegisterMethod('Procedure ClearNodes');
    RegisterMethod('Function AddAttribute( const AName : string; AValue : Variant) : TJvXMLAttribute');
    RegisterMethod('Function GetAttributeValue( const AName : string) : Variant');
    RegisterMethod('Procedure DeleteAttribute( Index : Integer)');
    RegisterMethod('Procedure ClearAttributes');
    RegisterMethod('Function Document( ALevel : Integer) : string');
    RegisterMethod('Function GetNodePath : string');
    RegisterMethod('Function GetNamedNode( const AName : string) : TJvXMLNode');
    RegisterMethod('Function SelectSingleNode( const APattern : string) : TJvXMLNode');
    RegisterMethod('Procedure SelectNodes( APattern : string; AList : TList)');
    RegisterMethod('Function TransformNode( AStyleSheet : TJvXMLNode) : string');
    RegisterMethod('Function Process( ALevel : Integer; ANode : TJvXMLNode) : string');
    RegisterMethod('Function FindNamedNode( const AName : string) : TJvXMLNode');
    RegisterMethod('Procedure FindNamedNodes( const AName : string; AList : TList)');
    RegisterMethod('Procedure GetAllNodes( AList : TList)');
    RegisterMethod('Function GetNamedAttribute( const AName : string) : TJvXMLAttribute');
    RegisterMethod('Procedure FindNamedAttributes( const AName : string; AList : TList)');
    RegisterMethod('Function MatchFilter( AObjFilter : TJvXMLFilter) : Boolean');
    RegisterMethod('Procedure MatchPattern( const APattern : string; AList : TList)');
    RegisterMethod('Procedure GetNodeNames( AList : TStrings)');
    RegisterMethod('Procedure GetAttributeNames( AList : TStrings)');
    RegisterMethod('Function GetNameSpace : string');
    RegisterMethod('Function HasChildNodes : Boolean');
    RegisterMethod('Function CloneNode : TJvXMLNode');
    RegisterMethod('Function FirstChild : TJvXMLNode');
    RegisterMethod('Function LastChild : TJvXMLNode');
    RegisterMethod('Function PreviousSibling : TJvXMLNode');
    RegisterMethod('Function NextSibling : TJvXMLNode');
    RegisterMethod('Function MoveAddNode( Dest : TJvXMLNode) : TJvXMLNode');
    RegisterMethod('Function MoveInsertNode( Dest : TJvXMLNode) : TJvXMLNode');
    RegisterMethod('Function RemoveChildNode( ANode : TJvXMLNode) : TJvXMLNode');
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Value', 'Variant', iptrw);
    RegisterProperty('ValueType', 'TJvXMLValueType', iptrw);
    RegisterProperty('Nodes', 'TList', iptrw);
    RegisterProperty('ParentNode', 'TJvXMLNode', iptrw);
    RegisterProperty('Attributes', 'TList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXMLAttribute(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvXMLAttribute') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvXMLAttribute') do begin
    RegisterMethod('Constructor Create( AParent : TJvXMLNode; const AName : string; AValue : Variant)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Function Document : string');
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Value', 'Variant', iptrw);
    RegisterProperty('Parent', 'TJvXMLNode', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXMLFilter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvXMLFilter') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvXMLFilter') do begin
    RegisterMethod('Constructor Create( const FilterStr : string)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Filters', 'TList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXMLFilterAtom(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvXMLFilterAtom') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvXMLFilterAtom') do begin
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Operator', 'TJvXMLFilterOperator', iptrw);
    RegisterProperty('Value', 'string', iptrw);
    RegisterProperty('AttributeFilter', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvXmlTree(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvXMLValueType', '( xvtString, xvtCDATA )');
  CL.AddTypeS('TJvXMLFilterOperator', '( xfoNOP, xfoEQ, xfoIEQ, xfoNE, xfoINE, '
   +'xfoGE, xfoIGE, xfoLE, xfoILE, xfoGT, xfoIGT, xfoLT, xfoILT )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvXMLTree');
  SIRegister_TJvXMLFilterAtom(CL);
  SIRegister_TJvXMLFilter(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvXMLNode');
  SIRegister_TJvXMLAttribute(CL);
  SIRegister_TJvXMLNode(CL);
  SIRegister_TJvXMLTree(CL);
 CL.AddDelphiFunction('Procedure PreProcessXML( AList : TStrings)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvXMLTreeText_W(Self: TJvXMLTree; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLTreeText_R(Self: TJvXMLTree; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLTreeNodeCount_R(Self: TJvXMLTree; var T: Integer);
begin T := Self.NodeCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLTreeLines_W(Self: TJvXMLTree; const T: TStrings);
begin Self.Lines := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLTreeLines_R(Self: TJvXMLTree; var T: TStrings);
begin T := Self.Lines; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeAttributes_W(Self: TJvXMLNode; const T: TList);
begin Self.Attributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeAttributes_R(Self: TJvXMLNode; var T: TList);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeParentNode_W(Self: TJvXMLNode; const T: TJvXMLNode);
begin Self.ParentNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeParentNode_R(Self: TJvXMLNode; var T: TJvXMLNode);
begin T := Self.ParentNode; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeNodes_W(Self: TJvXMLNode; const T: TList);
begin Self.Nodes := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeNodes_R(Self: TJvXMLNode; var T: TList);
begin T := Self.Nodes; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeValueType_W(Self: TJvXMLNode; const T: TJvXMLValueType);
begin Self.ValueType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeValueType_R(Self: TJvXMLNode; var T: TJvXMLValueType);
begin T := Self.ValueType; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeValue_W(Self: TJvXMLNode; const T: Variant);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeValue_R(Self: TJvXMLNode; var T: Variant);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeName_W(Self: TJvXMLNode; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLNodeName_R(Self: TJvXMLNode; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLAttributeParent_W(Self: TJvXMLAttribute; const T: TJvXMLNode);
begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLAttributeParent_R(Self: TJvXMLAttribute; var T: TJvXMLNode);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLAttributeValue_W(Self: TJvXMLAttribute; const T: Variant);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLAttributeValue_R(Self: TJvXMLAttribute; var T: Variant);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLAttributeName_W(Self: TJvXMLAttribute; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLAttributeName_R(Self: TJvXMLAttribute; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterFilters_W(Self: TJvXMLFilter; const T: TList);
begin Self.Filters := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterFilters_R(Self: TJvXMLFilter; var T: TList);
begin T := Self.Filters; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterName_W(Self: TJvXMLFilter; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterName_R(Self: TJvXMLFilter; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterAtomAttributeFilter_W(Self: TJvXMLFilterAtom; const T: Boolean);
begin Self.AttributeFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterAtomAttributeFilter_R(Self: TJvXMLFilterAtom; var T: Boolean);
begin T := Self.AttributeFilter; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterAtomValue_W(Self: TJvXMLFilterAtom; const T: string);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterAtomValue_R(Self: TJvXMLFilterAtom; var T: string);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterAtomOperator_W(Self: TJvXMLFilterAtom; const T: TJvXMLFilterOperator);
begin Self.Operator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterAtomOperator_R(Self: TJvXMLFilterAtom; var T: TJvXMLFilterOperator);
begin T := Self.Operator; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterAtomName_W(Self: TJvXMLFilterAtom; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXMLFilterAtomName_R(Self: TJvXMLFilterAtom; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvXmlTree_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PreProcessXML, 'PreProcessXML', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXMLTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXMLTree) do begin
    RegisterConstructor(@TJvXMLTree.Create, 'Create');
    RegisterMethod(@TJvXMLTree.Destroy, 'Free');
    RegisterMethod(@TJvXMLTree.ParseXML, 'ParseXML');
    RegisterMethod(@TJvXMLTree.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TJvXMLTree.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJvXMLTree.SaveToFile, 'SaveToFile');
    RegisterMethod(@TJvXMLTree.SaveToStream, 'SaveToStream');
    RegisterMethod(@TJvXMLTree.AsText, 'AsText');
    RegisterPropertyHelper(@TJvXMLTreeLines_R,@TJvXMLTreeLines_W,'Lines');
    RegisterPropertyHelper(@TJvXMLTreeNodeCount_R,nil,'NodeCount');
    RegisterPropertyHelper(@TJvXMLTreeText_R,@TJvXMLTreeText_W,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXMLNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXMLNode) do begin
    RegisterConstructor(@TJvXMLNode.Create, 'Create');
    RegisterMethod(@TJvXMLNode.Destroy, 'Free');
    RegisterMethod(@TJvXMLNode.GetNamePathNode, 'GetNamePathNode');
    RegisterMethod(@TJvXMLNode.DeleteNamePathNode, 'DeleteNamePathNode');
    RegisterMethod(@TJvXMLNode.ForceNamePathNode, 'ForceNamePathNode');
    RegisterMethod(@TJvXMLNode.GetNamePathNodeAttribute, 'GetNamePathNodeAttribute');
    RegisterMethod(@TJvXMLNode.DeleteNamePathNodeAttribute, 'DeleteNamePathNodeAttribute');
    RegisterMethod(@TJvXMLNode.ForceNamePathNodeAttribute, 'ForceNamePathNodeAttribute');
    RegisterMethod(@TJvXMLNode.AddNode, 'AddNode');
    RegisterMethod(@TJvXMLNode.AddNodeEx, 'AddNodeEx');
    RegisterMethod(@TJvXMLNode.DeleteNode, 'DeleteNode');
    RegisterMethod(@TJvXMLNode.ClearNodes, 'ClearNodes');
    RegisterMethod(@TJvXMLNode.AddAttribute, 'AddAttribute');
    RegisterMethod(@TJvXMLNode.GetAttributeValue, 'GetAttributeValue');
    RegisterMethod(@TJvXMLNode.DeleteAttribute, 'DeleteAttribute');
    RegisterMethod(@TJvXMLNode.ClearAttributes, 'ClearAttributes');
    RegisterMethod(@TJvXMLNode.Document, 'Document');
    RegisterMethod(@TJvXMLNode.GetNodePath, 'GetNodePath');
    RegisterMethod(@TJvXMLNode.GetNamedNode, 'GetNamedNode');
    RegisterMethod(@TJvXMLNode.SelectSingleNode, 'SelectSingleNode');
    RegisterMethod(@TJvXMLNode.SelectNodes, 'SelectNodes');
    RegisterMethod(@TJvXMLNode.TransformNode, 'TransformNode');
    RegisterMethod(@TJvXMLNode.Process, 'Process');
    RegisterMethod(@TJvXMLNode.FindNamedNode, 'FindNamedNode');
    RegisterMethod(@TJvXMLNode.FindNamedNodes, 'FindNamedNodes');
    RegisterMethod(@TJvXMLNode.GetAllNodes, 'GetAllNodes');
    RegisterMethod(@TJvXMLNode.GetNamedAttribute, 'GetNamedAttribute');
    RegisterMethod(@TJvXMLNode.FindNamedAttributes, 'FindNamedAttributes');
    RegisterMethod(@TJvXMLNode.MatchFilter, 'MatchFilter');
    RegisterMethod(@TJvXMLNode.MatchPattern, 'MatchPattern');
    RegisterMethod(@TJvXMLNode.GetNodeNames, 'GetNodeNames');
    RegisterMethod(@TJvXMLNode.GetAttributeNames, 'GetAttributeNames');
    RegisterMethod(@TJvXMLNode.GetNameSpace, 'GetNameSpace');
    RegisterMethod(@TJvXMLNode.HasChildNodes, 'HasChildNodes');
    RegisterMethod(@TJvXMLNode.CloneNode, 'CloneNode');
    RegisterMethod(@TJvXMLNode.FirstChild, 'FirstChild');
    RegisterMethod(@TJvXMLNode.LastChild, 'LastChild');
    RegisterMethod(@TJvXMLNode.PreviousSibling, 'PreviousSibling');
    RegisterMethod(@TJvXMLNode.NextSibling, 'NextSibling');
    RegisterMethod(@TJvXMLNode.MoveAddNode, 'MoveAddNode');
    RegisterMethod(@TJvXMLNode.MoveInsertNode, 'MoveInsertNode');
    RegisterMethod(@TJvXMLNode.RemoveChildNode, 'RemoveChildNode');
    RegisterPropertyHelper(@TJvXMLNodeName_R,@TJvXMLNodeName_W,'Name');
    RegisterPropertyHelper(@TJvXMLNodeValue_R,@TJvXMLNodeValue_W,'Value');
    RegisterPropertyHelper(@TJvXMLNodeValueType_R,@TJvXMLNodeValueType_W,'ValueType');
    RegisterPropertyHelper(@TJvXMLNodeNodes_R,@TJvXMLNodeNodes_W,'Nodes');
    RegisterPropertyHelper(@TJvXMLNodeParentNode_R,@TJvXMLNodeParentNode_W,'ParentNode');
    RegisterPropertyHelper(@TJvXMLNodeAttributes_R,@TJvXMLNodeAttributes_W,'Attributes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXMLAttribute(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXMLAttribute) do begin
    RegisterConstructor(@TJvXMLAttribute.Create, 'Create');
    RegisterMethod(@TJvXMLAttribute.Destroy, 'Free');
    RegisterMethod(@TJvXMLAttribute.Document, 'Document');
    RegisterPropertyHelper(@TJvXMLAttributeName_R,@TJvXMLAttributeName_W,'Name');
    RegisterPropertyHelper(@TJvXMLAttributeValue_R,@TJvXMLAttributeValue_W,'Value');
    RegisterPropertyHelper(@TJvXMLAttributeParent_R,@TJvXMLAttributeParent_W,'Parent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXMLFilter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXMLFilter) do begin
    RegisterConstructor(@TJvXMLFilter.Create, 'Create');
    RegisterMethod(@TJvXMLFilter.Destroy, 'Free');
    RegisterPropertyHelper(@TJvXMLFilterName_R,@TJvXMLFilterName_W,'Name');
    RegisterPropertyHelper(@TJvXMLFilterFilters_R,@TJvXMLFilterFilters_W,'Filters');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXMLFilterAtom(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXMLFilterAtom) do
  begin
    RegisterPropertyHelper(@TJvXMLFilterAtomName_R,@TJvXMLFilterAtomName_W,'Name');
    RegisterPropertyHelper(@TJvXMLFilterAtomOperator_R,@TJvXMLFilterAtomOperator_W,'Operator');
    RegisterPropertyHelper(@TJvXMLFilterAtomValue_R,@TJvXMLFilterAtomValue_W,'Value');
    RegisterPropertyHelper(@TJvXMLFilterAtomAttributeFilter_R,@TJvXMLFilterAtomAttributeFilter_W,'AttributeFilter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvXmlTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXMLTree) do
  RIRegister_TJvXMLFilterAtom(CL);
  RIRegister_TJvXMLFilter(CL);
  with CL.Add(TJvXMLNode) do
  RIRegister_TJvXMLAttribute(CL);
  RIRegister_TJvXMLNode(CL);
  RIRegister_TJvXMLTree(CL);
end;

 
 
{ TPSImport_JvXmlTree }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvXmlTree.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvXmlTree(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvXmlTree.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvXmlTree(ri);
  RIRegister_JvXmlTree_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
