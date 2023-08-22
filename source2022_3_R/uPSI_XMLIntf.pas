unit uPSI_XMLIntf;
{
to the XMLDocX

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
  TPSImport_XMLIntf = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IXMLDocument(CL: TPSPascalCompiler);
procedure SIRegister_IXMLNodeCollection(CL: TPSPascalCompiler);
procedure SIRegister_IXMLNodeList(CL: TPSPascalCompiler);
procedure SIRegister_IXMLNode(CL: TPSPascalCompiler);
procedure SIRegister_EXMLDocError(CL: TPSPascalCompiler);
procedure SIRegister_XMLIntf(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_EXMLDocError(CL: TPSRuntimeClassImporter);
procedure RIRegister_XMLIntf(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   xmldom
  ,XMLIntf
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XMLIntf]);
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IXMLDocument(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInterface', 'IXMLDocument') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IXMLDocument, 'IXMLDocument') do
  begin
    RegisterMethod('Function GetActive : Boolean', cdRegister);
    RegisterMethod('Function GetAsyncLoadState : Integer', cdRegister);
    RegisterMethod('Function GetChildNodes : IXMLNodeList', cdRegister);
    RegisterMethod('Function GetDocumentElement : IXMLNode', cdRegister);
    RegisterMethod('Function GetDocumentNode : IXMLNode', cdRegister);
    RegisterMethod('Function GetDOMDocument : IDOMDocument', cdRegister);
    RegisterMethod('Function GetEncoding : DOMString', cdRegister);
    RegisterMethod('Function GetFileName : DOMString', cdRegister);
    RegisterMethod('Function GetModified : Boolean', cdRegister);
    RegisterMethod('Function GetNodeIndentStr : DOMString', cdRegister);
    RegisterMethod('Function GetOptions : TXMLDocOptions', cdRegister);
    RegisterMethod('Function GetParseOptions : TParseOptions', cdRegister);
    RegisterMethod('Function GetSchemaRef : DOMString', cdRegister);
    RegisterMethod('Function GetStandAlone : DOMString', cdRegister);
    RegisterMethod('Function GetVersion : DOMString', cdRegister);
    RegisterMethod('Function GetXML : TStrings', cdRegister);
    RegisterMethod('Procedure SetActive( const Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SetDocumentElement( const Value : IXMLNode)', cdRegister);
    RegisterMethod('Procedure SetDOMDocument( const Value : IDOMDocument)', cdRegister);
    RegisterMethod('Procedure SetEncoding( const Value : DOMString)', cdRegister);
    RegisterMethod('Procedure SetFileName( const Value : DOMString)', cdRegister);
    RegisterMethod('Procedure SetNodeIndentStr( const Value : DOMString)', cdRegister);
    RegisterMethod('Procedure SetOptions( const Value : TXMLDocOptions)', cdRegister);
    RegisterMethod('Procedure SetParseOptions( const Value : TParseOptions)', cdRegister);
    RegisterMethod('Procedure SetStandAlone( const Value : DOMString)', cdRegister);
    RegisterMethod('Procedure SetVersion( const Value : DOMString)', cdRegister);
    RegisterMethod('Procedure SetXML( const Value : TStrings)', cdRegister);
    RegisterMethod('Function AddChild( const TagName : DOMString) : IXMLNode;', cdRegister);
    RegisterMethod('Function AddChild2( const TagName, NamespaceURI : DOMString) : IXMLNode;', cdRegister);
    RegisterMethod('Function CreateElement( const TagOrData, NamespaceURI : DOMString) : IXMLNode', cdRegister);
    RegisterMethod('Function CreateNode( const NameOrData : DOMString; NodeType : TNodeType; const AddlData : DOMString) : IXMLNode', cdRegister);
    RegisterMethod('Function GeneratePrefix( const Node : IXMLNode) : DOMString', cdRegister);
    RegisterMethod('Function GetDocBinding( const TagName : DOMString; DocNodeClass : TClass; NamespaceURI : DOMString) : IXMLNode', cdRegister);
    RegisterMethod('Function IsEmptyDoc : Boolean', cdRegister);
    RegisterMethod('Procedure LoadFromFile( const AFileName : DOMString)', cdRegister);
    RegisterMethod('Procedure LoadFromStream( const Stream : TStream; EncodingType : TXMLEncodingType)', cdRegister);
    RegisterMethod('Procedure LoadFromXML( const XML : string);', cdRegister);
    RegisterMethod('Procedure LoadFromXML2( const XML : DOMString);', cdRegister);
    RegisterMethod('Procedure Refresh', cdRegister);
    RegisterMethod('Procedure RegisterDocBinding( const TagName : DOMString; DocNodeClass : TClass; NamespaceURI : DOMString)', cdRegister);
    RegisterMethod('Procedure Resync', cdRegister);
    RegisterMethod('Procedure SaveToFile( const AFileName : DOMString)', cdRegister);
    RegisterMethod('Procedure SaveToStream( const Stream : TStream)', cdRegister);
    RegisterMethod('Procedure SaveToXML( var XML : DOMString);', cdRegister);
    RegisterMethod('Procedure SaveToXML2( var XML : string);', cdRegister);
    RegisterMethod('Procedure SetOnAsyncLoad( const Value : TAsyncEventHandler)', cdRegister);
   { RegisterMethod('StreamCipher', 'IStreamCipher', iptrw);

    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('AsyncLoadState', 'Integer', iptr);
    RegisterProperty('ChildNodes', 'IXMLNodeList', iptr);
    RegisterProperty('DocumentElement', 'IXMLNode', iptrw);
    RegisterProperty('DOMDocument', 'IDOMDocument', iptrw);
    RegisterProperty('Encoding', 'DOMString', iptrw);
    RegisterProperty('FileName', 'DOMString', iptrw);
    RegisterProperty('Modified', 'Boolean', iptr);
    RegisterProperty('Node', 'IXMLNode', iptr);
    RegisterProperty('NodeIndentStr', 'DOMString', iptrw);
    RegisterProperty('Options', 'TXMLDocOptions', iptrw);
    RegisterProperty('ParseOptions', 'TParseOptions', iptrw);
    RegisterProperty('SchemaRef', 'DOMString', iptr);
    RegisterProperty('StandAlone', 'DOMString', iptrw);
    RegisterProperty('Version', 'DOMString', iptrw);
    RegisterProperty('XML', 'TStrings', iptrw);    }
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXMLNodeCollection(CL: TPSPascalCompiler);   //!!
begin
  //with CL.a RegInterfaceS(CL,'IXMLNode', 'IXMLNodeCollection') do
  //CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLNode, 'IXMLNode');

 //  with CL.AddInterface(CL.FindInterface('Recordset20'),_Recordset, '_Recordset') do begin


  with CL.AddInterface(CL.FindInterface('IInterface'),IXMLNodeCollection, 'IXMLNodeCollection') do
  begin
    RegisterMethod('Function GetCount : Integer', cdRegister);
    RegisterMethod('Function GetNode( Index : Integer) : IXMLNode', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Procedure Delete( Index : Integer)', cdRegister);
    RegisterMethod('Function Remove( const Node : IXMLNode) : Integer', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXMLNodeList(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IXMLNodeList') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLNodeList, 'IXMLNodeList') do
  begin
    RegisterMethod('Function GetCount : Integer', cdRegister);
    RegisterMethod('Function GetNode( const IndexOrName : OleVariant) : IXMLNode', cdRegister);
    RegisterMethod('Function GetUpdateCount : Integer', cdRegister);
    RegisterMethod('Function Add( const Node : IXMLNode) : Integer', cdRegister);
    RegisterMethod('Procedure BeginUpdate', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Function Delete( const Index : Integer) : Integer;', cdRegister);
    RegisterMethod('Function Delete2( const Name : DOMString) : Integer;', cdRegister);
    RegisterMethod('Function Delete3( const Name, NamespaceURI : DOMString) : Integer;', cdRegister);
    RegisterMethod('Procedure EndUpdate', cdRegister);
    RegisterMethod('Function First : IXMLNode', cdRegister);
    RegisterMethod('Function FindNode( NodeName : DOMString) : IXMLNode;', cdRegister);
    RegisterMethod('Function FindNode2( NodeName, NamespaceURI : DOMString) : IXMLNode;', cdRegister);
    RegisterMethod('Function FindNode3( ChildNodeType : TGuid) : IXMLNode;', cdRegister);
    RegisterMethod('Function FindSibling( const Node : IXMLNode; Delta : Integer) : IXMLNode', cdRegister);
    RegisterMethod('Function Get( Index : Integer) : IXMLNode', cdRegister);
    RegisterMethod('Function IndexOf( const Node : IXMLNode) : Integer;', cdRegister);
    RegisterMethod('Function IndexOf2( const Name : DOMString) : Integer;', cdRegister);
    RegisterMethod('Function IndexOf3( const Name, NamespaceURI : DOMString) : Integer;', cdRegister);
    RegisterMethod('Procedure Insert( Index : Integer; const Node : IXMLNode)', cdRegister);
    RegisterMethod('Function Last : IXMLNode', cdRegister);
    RegisterMethod('Function Remove( const Node : IXMLNode) : Integer', cdRegister);
    RegisterMethod('Function ReplaceNode( const OldNode, NewNode : IXMLNode) : IXMLNode', cdRegister);

    //RegisterProperty('Items', 'integer Integer', iptrw);
    //[const IndexOrName: OleVariant]
   //  RegisterProperty('Node', 'OleVariant IXMLNode', iptr);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXMLNode(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IXMLNode') do
   //CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLNode, 'IXMLNode');

  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLNode, 'IXMLNode') do
  begin
    RegisterMethod('Function GetAttribute( const AttrName : DOMString) : OleVariant', cdRegister);
    RegisterMethod('Function GetAttributeNodes : IXMLNodeList', cdRegister);
    RegisterMethod('Function GetChildNodes : IXMLNodeList', cdRegister);
    RegisterMethod('Function GetChildValue( const IndexOrName : OleVariant) : OleVariant', cdRegister);
    RegisterMethod('Function GetCollection : IXMLNodeCollection', cdRegister);
    RegisterMethod('Function GetDOMNode : IDOMNode', cdRegister);
    RegisterMethod('Function GetHasChildNodes : Boolean', cdRegister);
    RegisterMethod('Function GetIsTextElement : Boolean', cdRegister);
    RegisterMethod('Function GetLocalName : DOMString', cdRegister);
    RegisterMethod('Function GetNamespaceURI : DOMString', cdRegister);
    RegisterMethod('Function GetNodeName : DOMString', cdRegister);
    RegisterMethod('Function GetNodeType : TNodeType', cdRegister);
    RegisterMethod('Function GetNodeValue : OleVariant', cdRegister);
    RegisterMethod('Function GetOwnerDocument : IXMLDocument', cdRegister);
    RegisterMethod('Function GetParentNode : IXMLNode', cdRegister);
    RegisterMethod('Function GetPrefix : DOMString', cdRegister);
    RegisterMethod('Function GetReadOnly : Boolean', cdRegister);
    RegisterMethod('Function GetText : DOMString', cdRegister);
    RegisterMethod('Function GetXML : DOMString', cdRegister);
    RegisterMethod('Procedure SetAttribute( const AttrName : DOMString; const Value : OleVariant)', cdRegister);
    RegisterMethod('Procedure SetChildValue( const IndexOrName : OleVariant; const Value : OleVariant)', cdRegister);
    RegisterMethod('Procedure SetNodeValue( const Value : OleVariant)', cdRegister);
    RegisterMethod('Procedure SetReadOnly( const Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SetText( const Value : DOMString)', cdRegister);
    RegisterMethod('Function AddChild( const TagName : DOMString; Index : Integer) : IXMLNode;', cdRegister);
    RegisterMethod('Function AddChild1( const TagName, NamespaceURI : DOMString; GenPrefix : Boolean; Index : Integer) : IXMLNode;', cdRegister);
    RegisterMethod('Function CloneNode( Deep : Boolean) : IXMLNode', cdRegister);
    RegisterMethod('Procedure DeclareNamespace( const Prefix, URI : DOMString)', cdRegister);
    RegisterMethod('Function FindNamespaceURI( const TagOrPrefix : DOMString) : DOMString', cdRegister);
    RegisterMethod('Function FindNamespaceDecl( const NamespaceURI : DOMString) : IXMLNode', cdRegister);
    RegisterMethod('Function GetAttributeNS( const AttrName, NamespaceURI : DOMString) : OleVariant', cdRegister);
    RegisterMethod('Function HasAttribute( const Name : DOMString) : Boolean;', cdRegister);
    RegisterMethod('Function HasAttribute2( const Name, NamespaceURI : DOMString) : Boolean;', cdRegister);
    RegisterMethod('Function NextSibling : IXMLNode', cdRegister);
    RegisterMethod('Procedure Normalize', cdRegister);
    RegisterMethod('Function PreviousSibling : IXMLNode', cdRegister);
    RegisterMethod('Procedure Resync', cdRegister);
    RegisterMethod('Procedure SetAttributeNS( const AttrName, NamespaceURI : DOMString; const Value : OleVariant)', cdRegister);
    RegisterMethod('Procedure TransformNode( const stylesheet : IXMLNode; var output : WideString);', cdRegister);
    RegisterMethod('Procedure TransformNode2( const stylesheet : IXMLNode; const output : IXMLDocument);', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EXMLDocError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EXMLDocError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EXMLDocError') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XMLIntf(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TNodeType', '( ntReserved, ntElement, ntAttribute, ntText, ntCDa'
   +'ta, ntEntityRef, ntEntity, ntProcessingInstr, ntComment, ntDocument, ntDocType, ntDocFragment, ntNotation )');

  CL.AddTypeS('DOMString', 'DOMStringW');

  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLNode, 'IXMLNode');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLNodeList, 'IXMLNodeList');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLNodeCollection, 'IXMLNodeCollection');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLDocument, 'IXMLDocument');
  //  CL.AddInterface(CL.FindInterface('Recordset15'),Recordset20, 'Recordset20');

//  CL.AddTypeS('DOMString', 'DOMStringW');


  SIRegister_EXMLDocError(CL);
  SIRegister_IXMLNode(CL);
  SIRegister_IXMLNodeList(CL);
  SIRegister_IXMLNodeCollection(CL);
  CL.AddTypeS('TXMLDocOption', '( doNodeAutoCreate, doNodeAutoIndent, doAttrNull, doAutoPrefix, doNamespaceDecl, doAutoSave )');
  CL.AddTypeS('TXMLDocOptions', 'set of TXMLDocOption');
  CL.AddTypeS('TParseOption', '( poResolveExternals, poValidateOnParse, poPreserveWhiteSpace, poAsyncLoad )');
  CL.AddTypeS('TParseOptions', 'set of TParseOption');
  CL.AddTypeS('TXMLEncodingType', '( xetUnknown, xetUCS_4BE, xetUCS_4LE, xetUCS'
   +'_4Order2134, xetUCS_4Order3412, xetUTF_16BE, xetUTF_16LE, xetUTF_8, xetUCS'
   +'_4Like, xetUTF_16BELike, xetUTF_16LELike, xetUTF_8Like, xetEBCDICLike )');
  SIRegister_IXMLDocument(CL);  //}
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure IXMLDocumentSaveToXML2_P(Self: IXMLDocument;  var XML : string);
Begin Self.SaveToXML(XML); END;

(*----------------------------------------------------------------------------*)
Procedure IXMLDocumentSaveToXML_P(Self: IXMLDocument;  var XML : DOMString);
Begin Self.SaveToXML(XML); END;

(*----------------------------------------------------------------------------*)
Procedure IXMLDocumentLoadFromXML2_P(Self: IXMLDocument;  const XML : DOMString);
Begin Self.LoadFromXML(XML); END;

(*----------------------------------------------------------------------------*)
Procedure IXMLDocumentLoadFromXML_P(Self: IXMLDocument;  const XML : string);
Begin Self.LoadFromXML(XML); END;

(*----------------------------------------------------------------------------*)
Function IXMLDocumentAddChild2_P(Self: IXMLDocument;  const TagName, NamespaceURI : DOMString) : IXMLNode;
Begin Result := Self.AddChild(TagName, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function IXMLDocumentAddChild_P(Self: IXMLDocument;  const TagName : DOMString) : IXMLNode;
Begin Result := Self.AddChild(TagName); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeListIndexOf3_P(Self: IXMLNodeList;  const Name, NamespaceURI : DOMString) : Integer;
Begin Result := Self.IndexOf(Name, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeListIndexOf2_P(Self: IXMLNodeList;  const Name : DOMString) : Integer;
Begin Result := Self.IndexOf(Name); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeListIndexOf_P(Self: IXMLNodeList;  const Node : IXMLNode) : Integer;
Begin Result := Self.IndexOf(Node); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeListFindNode3_P(Self: IXMLNodeList;  ChildNodeType : TGuid) : IXMLNode;
Begin Result := Self.FindNode(ChildNodeType); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeListFindNode2_P(Self: IXMLNodeList;  NodeName, NamespaceURI : DOMString) : IXMLNode;
Begin Result := Self.FindNode(NodeName, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeListFindNode_P(Self: IXMLNodeList;  NodeName : DOMString) : IXMLNode;
Begin Result := Self.FindNode(NodeName); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeListDelete3_P(Self: IXMLNodeList;  const Name, NamespaceURI : DOMString) : Integer;
Begin Result := Self.Delete(Name, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeListDelete2_P(Self: IXMLNodeList;  const Name : DOMString) : Integer;
Begin Result := Self.Delete(Name); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeListDelete_P(Self: IXMLNodeList;  const Index : Integer) : Integer;
Begin Result := Self.Delete(Index); END;

(*----------------------------------------------------------------------------*)
Procedure IXMLNodeTransformNode2_P(Self: IXMLNode;  const stylesheet : IXMLNode; const output : IXMLDocument);
Begin Self.TransformNode(stylesheet, output); END;

(*----------------------------------------------------------------------------*)
Procedure IXMLNodeTransformNode_P(Self: IXMLNode;  const stylesheet : IXMLNode; var output : WideString);
Begin Self.TransformNode(stylesheet, output); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeHasAttribute2_P(Self: IXMLNode;  const Name, NamespaceURI : DOMString) : Boolean;
Begin Result := Self.HasAttribute(Name, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeHasAttribute_P(Self: IXMLNode;  const Name : DOMString) : Boolean;
Begin Result := Self.HasAttribute(Name); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeAddChild1_P(Self: IXMLNode;  const TagName, NamespaceURI : DOMString; GenPrefix : Boolean; Index : Integer) : IXMLNode;
Begin Result := Self.AddChild(TagName, NamespaceURI, GenPrefix, Index); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeAddChild_P(Self: IXMLNode;  const TagName : DOMString; Index : Integer) : IXMLNode;
Begin Result := Self.AddChild(TagName, Index); END;

procedure IXMLDocumentNode_R(Self: IXMLDocument; var T: IXMLNode);
begin T := Self.Node; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_EXMLDocError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EXMLDocError) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XMLIntf(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EXMLDocError(CL);
end;

 
 
{ TPSImport_XMLIntf }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XMLIntf.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XMLIntf(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XMLIntf.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XMLIntf(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
