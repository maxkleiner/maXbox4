unit uPSI_MaxDOM;
{
   for XMLDOMMAX

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
  TPSImport_MaxDOM = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNode(CL: TPSPascalCompiler);
procedure SIRegister_TAttribute(CL: TPSPascalCompiler);
procedure SIRegister_INodeCollection(CL: TPSPascalCompiler);
procedure SIRegister_IAttributeCollection(CL: TPSPascalCompiler);
procedure SIRegister_IAttribute(CL: TPSPascalCompiler);
procedure SIRegister_INode(CL: TPSPascalCompiler);
procedure SIRegister_MaxDOM(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAttribute(CL: TPSRuntimeClassImporter);
procedure RIRegister_MaxDOM_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,MaxDOM //, msxml, xmldom, XMLDoc, XmlIntf
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MaxDOM]);
end;

(*function XPathQuery(aNode: IXMLNode; aQuery: string): IXMLNodeList; overload;
var
  XmlNodeAccess: IXmlNodeAccess;
  XmlDocAccess: IXmlDocumentAccess;
  XmlDomNodeSelect: IDomNodeSelect;
  DomNodeList: IDomNodeList;
  Document: TXMLDocument;
  i: integer;
  OwnerDoc: TXMLDocument;
  DomDoc2: IXMLDOMDocument;

  function CreateWithParentNode(const aDomNode: IDOMNode; const aOwnerDoc: TXMLDocument): TXmlNode;
  begin
    if assigned(aDomNode) then
      Result := TXMLNode.Create(aDomNode, CreateWithParentNode(aDomNode.parentNode, aOwnerDoc), aOwnerDoc)
    else
      Result := nil;
  end;

begin
  Result := nil;
  if not assigned(aNode) then
    Exit;
  if not Supports(aNode, IXmlNodeAccess, XmlNodeAccess) then
    raise Exception.Create('Interface IXmlNodeAccess not found.');
  if not Supports(aNode.DOMNode, IDomNodeSelect, XmlDomNodeSelect) then
    raise Exception.Create('Interface IDomNodeSelect not found.');
  if Supports(aNode.OwnerDocument, IXmlDocumentAccess, XmlDocAccess) then
    OwnerDoc := XmlDocAccess.DocumentObject
  else
    OwnerDoc := nil; // if Owner is nil this is a possble Memory Leak!

  //>>> if XPath is not enabled
  if assigned(OwnerDoc) then
    if Supports(OwnerDoc.DOMDocument, IXMLDOMDocument, DomDoc2) then
      //DomDoc2.pr  Property('SelectionLanguage', 'XPath');
  //<<< if XPath is not enabled


  DomNodeList := XmlDomNodeSelect.selectNodes(aQuery);
  if assigned(DomNodeList) then
  begin
    Result := TXMLNodeList.Create(XmlNodeAccess.GetNodeObject, '', nil);
    Document := OwnerDoc;
    for i := 0 to pred(DomNodeList.length) do
    begin
      Result.Add(CreateWithParentNode(DomNodeList.item[i], Document));
    end;
  end
end;      *)



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TNode') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TNode') do
  begin
    RegisterProperty('FNodeType', 'TNodeType', iptrw);
    RegisterProperty('FNodeName', 'String', iptrw);
    RegisterProperty('FText', 'String', iptrw);
    RegisterProperty('FAttributes', 'TAttributes', iptrw);
    RegisterProperty('FAttrHashTable', 'TAttrHashTable', iptrw);
    RegisterProperty('FAttrHashSize', 'Cardinal', iptrw);
    RegisterProperty('FAttrCapacity', 'Integer', iptrw);
    RegisterProperty('FAttrCount', 'Integer', iptrw);
    RegisterProperty('FChildren', 'TNodes', iptrw);
    RegisterProperty('FChildCapacity', 'Integer', iptrw);
    RegisterProperty('FChildCount', 'Integer', iptrw);
    RegisterProperty('FData', 'Pointer', iptrw);
    RegisterMethod('Constructor Create( const AName : String; aNodeType : TNodeType)');
    RegisterMethod('Function Instance : TObject');
    RegisterProperty('AttrValue', 'String String', iptrw);
    SetDefaultPropery('AttrValue');
    RegisterProperty('ChildCount', 'Integer', iptr);
    RegisterProperty('ChildNodes', 'TNodes', iptr);
    RegisterProperty('NodeName', 'String', iptrw);
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('ID', 'String', iptrw);
    RegisterProperty('Children', 'INodeCollection', iptr);
    RegisterProperty('Attributes', 'IAttributeCollection', iptr);
    RegisterProperty('XML', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAttribute(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TAttribute') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TAttribute') do
  begin
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('Value', 'String', iptrw);
    RegisterProperty('Data', 'Pointer', iptrw);
    RegisterProperty('AsString', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_INodeCollection(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'INodeCollection') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),INodeCollection, 'INodeCollection') do
  begin
    RegisterMethod('Function GetItem( AIndex : Integer) : INode', cdRegister);
    RegisterMethod('Function GetCount : Integer', cdRegister);
    RegisterMethod('Procedure SetItem( AItend : Integer; AValue : INode)', cdRegister);
    RegisterMethod('Function AddNew( const AName : String; AType : TNodeType) : INode', cdRegister);
    RegisterMethod('Function InsertNew( AIndex : Integer; const AName : String; AType : TNodeType) : INode', cdRegister);
    RegisterMethod('Function EnsureElement( AName : String; ANodeClass : TClass) : INode', cdRegister);
    RegisterMethod('Function Add( ANode : INode) : Integer', cdRegister);
    RegisterMethod('Function ReplaceWith( ANode : INode) : Integer', cdRegister);
    RegisterMethod('Function AddSafe( ANode : INode) : Integer', cdRegister);
    RegisterMethod('Procedure Insert( AIndex : Integer; ANode : INode)', cdRegister);
    RegisterMethod('Procedure AppendChildren( ANode : INode; ACloneChildren : Boolean)', cdRegister);
    RegisterMethod('Procedure Delete( AIndex : Integer)', cdRegister);
    RegisterMethod('Procedure Remove( ANode : INode)', cdRegister);
    RegisterMethod('Function Extract( AIndex : Integer) : INode', cdRegister);
    RegisterMethod('Procedure Move( AIndex, ANewIndex : Integer)', cdRegister);
    RegisterMethod('Procedure Swap( AIndex, ANewIndex : Integer)', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Procedure Sort( ACompareFn : TSortCompareFn)', cdRegister);
    RegisterMethod('Function IndexOf( const AName : String) : Integer', cdRegister);
    RegisterMethod('Function IndexOfByAttr( const AAttrName, AAttrValue : String; CaseSensitive : Boolean) : Integer', cdRegister);
    RegisterMethod('Function FindByAttr( const AAttrName, AAttrValue : String; CaseSensitive : Boolean) : INode', cdRegister);
    RegisterMethod('Function GetFirstChild : INode', cdRegister);
    RegisterMethod('Function GetSecondChild : INode', cdRegister);
    RegisterMethod('Function GetLastChild : INode', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IAttributeCollection(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IAttributeCollection') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IAttributeCollection, 'IAttributeCollection') do
  begin
    RegisterMethod('Function GetValue( AName : String) : String', cdRegister);
    RegisterMethod('Function GetCount : Integer', cdRegister);
    RegisterMethod('Procedure SetValue( AName : String; const AValue : String)', cdRegister);
    RegisterMethod('Function GetItem( AnIndex : Integer) : IAttribute', cdRegister);
    RegisterMethod('Function AddNew( const AName, AValue : String) : IAttribute', cdRegister);
    RegisterMethod('Function Add( AnAttr : IAttribute) : Integer', cdRegister);
    RegisterMethod('Procedure Insert( AnIndex : Integer; AnAttr : IAttribute)', cdRegister);
    RegisterMethod('Function InsertNew( AnIndex : Integer; const AName, AValue : String) : IAttribute', cdRegister);
    RegisterMethod('Function AddSafe( AnAttr : IAttribute) : Integer', cdRegister);
    RegisterMethod('Procedure Delete( const AName : String)', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Function Rename( const OldName, NewName : String) : Boolean', cdRegister);
    RegisterMethod('Function Find( const AName : String) : IAttribute', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IAttribute(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IAttribute') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IAttribute, 'IAttribute') do
  begin
    RegisterMethod('Procedure SetName( const AValue : String)', cdRegister);
    RegisterMethod('Function GetName : String', cdRegister);
    RegisterMethod('Procedure SetValue( const AValue : String)', cdRegister);
    RegisterMethod('Function GetValue : String', cdRegister);
    RegisterMethod('Procedure SetData( AData : Pointer)', cdRegister);
    RegisterMethod('Function GetData : Pointer', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_INode(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'INode') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),INode, 'INode') do
  begin
    RegisterMethod('Function GetNodeType : TNodeType', cdRegister);
    RegisterMethod('Function GetNodeName : String', cdRegister);
    RegisterMethod('Procedure SetNodeName( const AValue : String)', cdRegister);
    RegisterMethod('Function GetName : String', cdRegister);
    RegisterMethod('Procedure SetName( const AValue : String)', cdRegister);
    RegisterMethod('Function GetID : String', cdRegister);
    RegisterMethod('Procedure SetID( const AValue : String)', cdRegister);
    RegisterMethod('Function GetText : String', cdRegister);
    RegisterMethod('Procedure SetText( const AValue : String)', cdRegister);
    RegisterMethod('Function GetAttrValue( AName : String) : String', cdRegister);
    RegisterMethod('Procedure SetAttrValue( AName : String; const Value : String)', cdRegister);
    RegisterMethod('Function GetAttributes : IAttributeCollection', cdRegister);
    RegisterMethod('Function GetChildren : INodeCollection', cdRegister);
    RegisterMethod('Function GetData : Pointer', cdRegister);
    RegisterMethod('Function GetXML : String', cdRegister);
    RegisterMethod('Procedure SetData( AValue : Pointer)', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Function HasAttribute( const AName : String) : Boolean', cdRegister);
    RegisterMethod('Function HasNode( const AName : String) : Boolean', cdRegister);
    RegisterMethod('Procedure Assign( ANode : INode; ADeep : Boolean)', cdRegister);
    RegisterMethod('Function Clone( ADeep : Boolean) : INode', cdRegister);
    RegisterMethod('Procedure MergeAttrs( ANode : INode; AReplaceExisting : Boolean)', cdRegister);
    RegisterMethod('Function FindAttribute( AName : String) : IAttribute', cdRegister);
    RegisterMethod('Function FindNode( const AName : String) : INode', cdRegister);
    RegisterMethod('Function Instance : TObject', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MaxDOM(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TNodeType', '( ntElement, ntText, ntCDATA, ntComment )');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),INode, 'INode');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IAttribute, 'IAttribute');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IAttributeCollection, 'IAttributeCollection');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),INodeCollection, 'INodeCollection');
  SIRegister_INode(CL);
  SIRegister_IAttribute(CL);
  SIRegister_IAttributeCollection(CL);
  SIRegister_INodeCollection(CL);
 CL.AddDelphiFunction('Function NodeCreate( const ANodeName : String; ANodeType : TNodeType) : INode');
  SIRegister_TAttribute(CL);
  CL.AddTypeS('TNodes', 'array of INode');
  CL.AddTypeS('TAttributes', 'array of IAttribute');
  CL.AddTypeS('THashedAttributes', 'record Attributes : TAttributes; AttrCount '
   +': Integer; AttrCapacity : Integer; end');
  CL.AddTypeS('TAttrHashTable', 'array of THashedAttributes');
  SIRegister_TNode(CL);
  //CL.AddTypeS('TNodeClass', 'class of TNode');
  //CL.AddTypeS('TAttributeClass', 'class of TAttribute');
 CL.AddDelphiFunction('Function PointerToStr( P : TObject) : String');
 CL.AddDelphiFunction('Function StrToPointer( const S : String) : TObject');
 CL.AddDelphiFunction('Function StrToPointer2( const S : String) : ___Pointer');
 CL.AddDelphiFunction('Function PointerToStr2( P : ___Pointer) : String');

 CL.AddDelphiFunction('Function INodeToStr( ANode : INode) : String');
 CL.AddDelphiFunction('Function StrToINode( const S : String) : INode');
 CL.AddDelphiFunction('Function CompareByNodeName( N1, N2 : INode) : Integer');
 CL.AddDelphiFunction('Function CompareByNameAttr( N1, N2 : INode) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TNodeXML_R(Self: TNode; var T: String);
begin T := Self.XML; end;

(*----------------------------------------------------------------------------*)
procedure TNodeAttributes_R(Self: TNode; var T: IAttributeCollection);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure TNodeChildren_R(Self: TNode; var T: INodeCollection);
begin T := Self.Children; end;

(*----------------------------------------------------------------------------*)
procedure TNodeID_W(Self: TNode; const T: String);
begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeID_R(Self: TNode; var T: String);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TNodeName_W(Self: TNode; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeName_R(Self: TNode; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TNodeNodeName_W(Self: TNode; const T: String);
begin Self.NodeName := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeNodeName_R(Self: TNode; var T: String);
begin T := Self.NodeName; end;

(*----------------------------------------------------------------------------*)
procedure TNodeChildNodes_R(Self: TNode; var T: TNodes);
begin T := Self.ChildNodes; end;

(*----------------------------------------------------------------------------*)
procedure TNodeChildCount_R(Self: TNode; var T: Integer);
begin T := Self.ChildCount; end;

(*----------------------------------------------------------------------------*)
procedure TNodeAttrValue_W(Self: TNode; const T: String; const t1: String);
begin Self.AttrValue[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeAttrValue_R(Self: TNode; var T: String; const t1: String);
begin T := Self.AttrValue[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFData_W(Self: TNode; const T: Pointer);
Begin Self.FData := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFData_R(Self: TNode; var T: Pointer);
Begin T := Self.FData; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFChildCount_W(Self: TNode; const T: Integer);
Begin Self.FChildCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFChildCount_R(Self: TNode; var T: Integer);
Begin T := Self.FChildCount; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFChildCapacity_W(Self: TNode; const T: Integer);
Begin Self.FChildCapacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFChildCapacity_R(Self: TNode; var T: Integer);
Begin T := Self.FChildCapacity; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFChildren_W(Self: TNode; const T: TNodes);
Begin Self.FChildren := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFChildren_R(Self: TNode; var T: TNodes);
Begin T := Self.FChildren; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFAttrCount_W(Self: TNode; const T: Integer);
Begin Self.FAttrCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFAttrCount_R(Self: TNode; var T: Integer);
Begin T := Self.FAttrCount; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFAttrCapacity_W(Self: TNode; const T: Integer);
Begin Self.FAttrCapacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFAttrCapacity_R(Self: TNode; var T: Integer);
Begin T := Self.FAttrCapacity; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFAttrHashSize_W(Self: TNode; const T: Cardinal);
Begin Self.FAttrHashSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFAttrHashSize_R(Self: TNode; var T: Cardinal);
Begin T := Self.FAttrHashSize; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFAttrHashTable_W(Self: TNode; const T: TAttrHashTable);
Begin Self.FAttrHashTable := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFAttrHashTable_R(Self: TNode; var T: TAttrHashTable);
Begin T := Self.FAttrHashTable; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFAttributes_W(Self: TNode; const T: TAttributes);
Begin Self.FAttributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFAttributes_R(Self: TNode; var T: TAttributes);
Begin T := Self.FAttributes; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFText_W(Self: TNode; const T: String);
Begin Self.FText := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFText_R(Self: TNode; var T: String);
Begin T := Self.FText; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFNodeName_W(Self: TNode; const T: String);
Begin Self.FNodeName := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFNodeName_R(Self: TNode; var T: String);
Begin T := Self.FNodeName; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFNodeType_W(Self: TNode; const T: TNodeType);
Begin Self.FNodeType := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeFNodeType_R(Self: TNode; var T: TNodeType);
Begin T := Self.FNodeType; end;

(*----------------------------------------------------------------------------*)
procedure TAttributeAsString_R(Self: TAttribute; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TAttributeData_W(Self: TAttribute; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TAttributeData_R(Self: TAttribute; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TAttributeValue_W(Self: TAttribute; const T: String);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TAttributeValue_R(Self: TAttribute; var T: String);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TAttributeName_W(Self: TAttribute; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TAttributeName_R(Self: TAttribute; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNode) do
  begin
    RegisterPropertyHelper(@TNodeFNodeType_R,@TNodeFNodeType_W,'FNodeType');
    RegisterPropertyHelper(@TNodeFNodeName_R,@TNodeFNodeName_W,'FNodeName');
    RegisterPropertyHelper(@TNodeFText_R,@TNodeFText_W,'FText');
    RegisterPropertyHelper(@TNodeFAttributes_R,@TNodeFAttributes_W,'FAttributes');
    RegisterPropertyHelper(@TNodeFAttrHashTable_R,@TNodeFAttrHashTable_W,'FAttrHashTable');
    RegisterPropertyHelper(@TNodeFAttrHashSize_R,@TNodeFAttrHashSize_W,'FAttrHashSize');
    RegisterPropertyHelper(@TNodeFAttrCapacity_R,@TNodeFAttrCapacity_W,'FAttrCapacity');
    RegisterPropertyHelper(@TNodeFAttrCount_R,@TNodeFAttrCount_W,'FAttrCount');
    RegisterPropertyHelper(@TNodeFChildren_R,@TNodeFChildren_W,'FChildren');
    RegisterPropertyHelper(@TNodeFChildCapacity_R,@TNodeFChildCapacity_W,'FChildCapacity');
    RegisterPropertyHelper(@TNodeFChildCount_R,@TNodeFChildCount_W,'FChildCount');
    RegisterPropertyHelper(@TNodeFData_R,@TNodeFData_W,'FData');
    RegisterVirtualConstructor(@TNode.Create, 'Create');
    RegisterVirtualMethod(@TNode.Instance, 'Instance');
    RegisterPropertyHelper(@TNodeAttrValue_R,@TNodeAttrValue_W,'AttrValue');
    RegisterPropertyHelper(@TNodeChildCount_R,nil,'ChildCount');
    RegisterPropertyHelper(@TNodeChildNodes_R,nil,'ChildNodes');
    RegisterPropertyHelper(@TNodeNodeName_R,@TNodeNodeName_W,'NodeName');
    RegisterPropertyHelper(@TNodeName_R,@TNodeName_W,'Name');
    RegisterPropertyHelper(@TNodeID_R,@TNodeID_W,'ID');
    RegisterPropertyHelper(@TNodeChildren_R,nil,'Children');
    RegisterPropertyHelper(@TNodeAttributes_R,nil,'Attributes');
    RegisterPropertyHelper(@TNodeXML_R,nil,'XML');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAttribute(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAttribute) do
  begin
    RegisterPropertyHelper(@TAttributeName_R,@TAttributeName_W,'Name');
    RegisterPropertyHelper(@TAttributeValue_R,@TAttributeValue_W,'Value');
    RegisterPropertyHelper(@TAttributeData_R,@TAttributeData_W,'Data');
    RegisterPropertyHelper(@TAttributeAsString_R,nil,'AsString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MaxDOM_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@NodeCreate, 'NodeCreate', cdRegister);
  //RIRegister_TAttribute(CL);
  //RIRegister_TNode(CL);
 S.RegisterDelphiFunction(@PointerToStr, 'PointerToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToPointer, 'StrToPointer', cdRegister);
 S.RegisterDelphiFunction(@PointerToStr, 'PointerToStr2', cdRegister);
 S.RegisterDelphiFunction(@StrToPointer, 'StrToPointer2', cdRegister);

 S.RegisterDelphiFunction(@INodeToStr, 'INodeToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToINode, 'StrToINode', cdRegister);
 S.RegisterDelphiFunction(@CompareByNodeName, 'CompareByNodeName', cdRegister);
 S.RegisterDelphiFunction(@CompareByNameAttr, 'CompareByNameAttr', cdRegister);
end;

 
 
{ TPSImport_MaxDOM }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxDOM.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MaxDOM(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxDOM.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MaxDOM_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
