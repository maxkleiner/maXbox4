unit uPSI_XMLDoc;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_XMLDoc = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXMLDocument(CL: TPSPascalCompiler);
procedure SIRegister_IXMLDocumentAccess(CL: TPSPascalCompiler);
procedure SIRegister_TXMLNodeCollection(CL: TPSPascalCompiler);
procedure SIRegister_TXMLNode(CL: TPSPascalCompiler);
procedure SIRegister_IXMLNodeAccess(CL: TPSPascalCompiler);
procedure SIRegister_TXMLNodeList(CL: TPSPascalCompiler);
procedure SIRegister_XMLDoc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_XMLDoc_Routines(S: TPSExec);
procedure RIRegister_TXMLDocument(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXMLNodeCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXMLNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXMLNodeList(CL: TPSRuntimeClassImporter);
procedure RIRegister_XMLDoc(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ActiveX
  ,Types
  ,Variants
  ,xmldom
  ,XMLIntf
  ,XMLDoc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XMLDoc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLDocument(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TXMLDocument') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TXMLDocument') do
  begin
    RegisterMethod('Constructor Create21( AOwner : TComponent);');
    RegisterMethod('Constructor Create22( const AFileName : DOMString);');
    RegisterMethod('Function NewInstance : TObject');
    RegisterMethod('Procedure AfterConstruction');
    RegisterMethod('Function AddChild23( const TagName : DOMString) : IXMLNode;');
    RegisterMethod('Function AddChild24( const TagName, NamespaceURI : DOMString) : IXMLNode;');
    RegisterMethod('Function CreateElement( const TagOrData, NamespaceURI : DOMString) : IXMLNode');
    RegisterMethod('Function CreateNode( const NameOrData : DOMString; NodeType : TNodeType; const AddlData : DOMString) : IXMLNode');
    RegisterMethod('Function GetDocBinding( const TagName : DOMString; DocNodeClass : TClass; NamespaceURI : DOMString) : IXMLNode');
    RegisterMethod('Function IsEmptyDoc : Boolean');
    RegisterMethod('Procedure LoadFromFile( const AFileName : DOMString)');
    RegisterMethod('Procedure LoadFromStream( const Stream : TStream; EncodingType : TXMLEncodingType)');
    RegisterMethod('Procedure LoadFromXML25( const XML : AnsiString);');
    RegisterMethod('Procedure LoadFromXML26( const XML : DOMString);');
    RegisterMethod('Procedure Refresh');
    RegisterMethod('Procedure RegisterDocBinding( const TagName : DOMString; DocNodeClass : TClass; NamespaceURI : DOMString)');
    RegisterMethod('Procedure Resync');
    RegisterMethod('Procedure SaveToFile( const AFileName : DOMString)');
    RegisterMethod('Procedure SaveToStream( const Stream : TStream)');
    RegisterMethod('Procedure SaveToXML27( var XML : DOMString);');
    RegisterMethod('Procedure SaveToXML28( var XML : WideString);');
    RegisterMethod('Procedure SaveToXML29( var XML : UTF8String);');
    RegisterProperty('AsyncLoadState', 'Integer', iptr);
    RegisterProperty('ChildNodes', 'IXMLNodeList', iptr);
    RegisterProperty('DOMDocument', 'IDOMDocument', iptrw);
    RegisterProperty('DOMImplementation', 'IDOMImplementation', iptrw);
    RegisterProperty('DocumentElement', 'IXMLNode', iptrw);
    RegisterProperty('Encoding', 'DOMString', iptrw);
    RegisterMethod('Function GeneratePrefix( const Node : IXMLNode) : DOMString');
    RegisterProperty('Modified', 'Boolean', iptr);
    RegisterProperty('Node', 'IXMLNode', iptr);
    RegisterProperty('NSPrefixBase', 'DOMString', iptrw);
    RegisterProperty('SchemaRef', 'DOMString', iptr);
    RegisterProperty('StandAlone', 'DOMString', iptrw);
    RegisterProperty('Version', 'DOMString', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('FileName', 'DOMString', iptrw);
    RegisterProperty('DOMVendor', 'TDOMVendor', iptrw);
    RegisterProperty('NodeIndentStr', 'DOMString', iptrw);
    RegisterProperty('Options', 'TXMLDocOptions', iptrw);
    RegisterProperty('ParseOptions', 'TParseOptions', iptrw);
    RegisterProperty('XML', 'TStrings', iptrw);
    RegisterProperty('BeforeOpen', 'TNotifyEvent', iptrw);
    RegisterProperty('AfterOpen', 'TNotifyEvent', iptrw);
    RegisterProperty('BeforeClose', 'TNotifyEvent', iptrw);
    RegisterProperty('AfterClose', 'TNotifyEvent', iptrw);
    RegisterProperty('BeforeNodeChange', 'TNodeChangeEvent', iptrw);
    RegisterProperty('AfterNodeChange', 'TNodeChangeEvent', iptrw);
    RegisterProperty('OnAsyncLoad', 'TAsyncEventHandler', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXMLDocumentAccess(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IXMLDocumentAccess') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLDocumentAccess, 'IXMLDocumentAccess') do
  begin
    RegisterMethod('Function GetDocumentObject : TXMLDocument', cdRegister);
    RegisterMethod('Function GetDOMPersist : IDOMPersist', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLNodeCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXMLNode', 'TXMLNodeCollection') do
  with CL.AddClassN(CL.FindClass('TXMLNode'),'TXMLNodeCollection') do
  begin
    RegisterMethod('Procedure AfterConstruction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TXMLNode') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TXMLNode') do
  begin
    RegisterMethod('Constructor Create( const ADOMNode : IDOMNode; const AParentNode : TXMLNode; const OwnerDoc : TXMLDocument)');
    RegisterMethod('Constructor CreateHosted( HostNode : TXMLNode)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXMLNodeAccess(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXMLNode', 'IXMLNodeAccess') do
  with CL.AddInterface(CL.FindInterface('IXMLNode'),IXMLNodeAccess, 'IXMLNodeAccess') do
  begin
    RegisterMethod('Function AddChild9( const TagName, NamespaceURI : DOMString; NodeClass : TXMLNodeClass; Index : Integer) : IXMLNode;', cdRegister);
    RegisterMethod('Procedure CheckTextNode', cdRegister);
    RegisterMethod('Procedure ClearDocumentRef', cdRegister);
    RegisterMethod('Function CreateAttributeNode( const ADOMNode : IDOMNode) : IXMLNode', cdRegister);
    RegisterMethod('Function CreateChildNode( const ADOMNode : IDOMNode) : IXMLNode', cdRegister);
    RegisterMethod('Function CreateCollection( const CollectionClass : TXMLNodeCollectionClass; const ItemIterface : TGuid; const ItemTag : DOMString; ItemNS : DOMString) : TXMLNodeCollection', cdRegister);
    RegisterMethod('Function DOMElement : IDOMElement', cdRegister);
    RegisterMethod('Function FindHostedNode( const NodeClass : TXMLNodeClass) : IXMLNode', cdRegister);
    RegisterMethod('Function GetChildNodeClasses : TNodeClassArray', cdRegister);
    RegisterMethod('Function GetHostNode : TXMLNode', cdRegister);
    RegisterMethod('Function GetNodeObject : TXMLNode', cdRegister);
    RegisterMethod('Function HasChildNode10( const ChildTag : DOMString) : Boolean;', cdRegister);
    RegisterMethod('Function HasChildNode11( const ChildTag, NamespaceURI : DOMString) : Boolean;', cdRegister);
    RegisterMethod('Function InternalAddChild( NodeClass : TXMLNodeClass; const NodeName, NamespaceURI : DOMString; Index : Integer) : IXMLNode', cdRegister);
    RegisterMethod('Function NestingLevel : Integer', cdRegister);
    RegisterMethod('Procedure RegisterChildNode( const TagName : DOMString; ChildNodeClass : TXMLNodeClass; NamespaceURI : DOMString)', cdRegister);
    RegisterMethod('Procedure RegisterChildNodes( const TagNames : array of DOMString; const NodeClasses : array of TXMLNodeClass)', cdRegister);
    RegisterMethod('Procedure SetCollection( const Value : TXMLNodeCollection)', cdRegister);
    RegisterMethod('Procedure SetParentNode( const Value : TXMLNode)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLNodeList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TXMLNodeList') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TXMLNodeList') do
  begin
    RegisterMethod('Constructor Create( Owner : TXMLNode; const DefaultNamespaceURI : DOMString; NotificationProc : TNodeListNotification)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XMLDoc(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXMLNode');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXMLNodeList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXMLNodeCollection');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXMLDocument');
  CL.AddTypeS('TNodeListOperation', '( nlInsert, nlRemove, nlCreateNode )');
  CL.AddTypeS('TNodeListNotification', 'Procedure ( Operation : TNodeListOperat'
   +'ion; var Node : IXMLNode; const IndexOrName : OleVariant; BeforeOperation '
   +': Boolean)');
  SIRegister_TXMLNodeList(CL);
  //CL.AddTypeS('TXMLNodeClass', 'class of TXMLNode');
  CL.AddTypeS('TXMLNodeArray', 'array of TXMLNode');
  CL.AddTypeS('TNodeClassInfo', 'record NodeName : DOMString; NamespaceURI : DO'
   +'MString; NodeClass : TXMLNodeClass; end');
  CL.AddTypeS('TNodeClassArray', 'array of TNodeClassInfo');
  //CL.AddTypeS('TXMLNodeCollectionClass', 'class of TXMLNodeCollection');
  CL.AddTypeS('TNodeChange', '( ncUpdateValue, ncInsertChild, ncRemoveChild, nc'
   +'AddAttribute, ncRemoveAttribute )');
  SIRegister_IXMLNodeAccess(CL);
  SIRegister_TXMLNode(CL);
  SIRegister_TXMLNodeCollection(CL);
  CL.AddTypeS('TNodeChangeEvent', 'Procedure ( const Node : IXMLNode; ChangeTyp'
   +'e : TNodeChange)');
  CL.AddTypeS('TXMLPrologItem', '( xpVersion, xpEncoding, xpStandalone )');
  CL.AddTypeS('TXMLDocumentSource', '( xdsNone, xdsXMLProperty, xdsXMLData, xds'
   +'File, xdsStream )');
  SIRegister_IXMLDocumentAccess(CL);
  SIRegister_TXMLDocument(CL);
 CL.AddDelphiFunction('Function CreateDOMNode( Doc : IDOMDocument; const NameOrData : DOMString; NodeType : TNodeType; const AddlData : DOMString) : IDOMNode');
 CL.AddDelphiFunction('Function DetectCharEncoding( S : TStream) : TXmlEncodingType');
 CL.AddDelphiFunction('Procedure CheckEncoding( var XMLData : DOMString; const ValidEncodings : array of string)');
 CL.AddDelphiFunction('Function XMLStringToUnicodeString( const XMLString : AnsiString) : UnicodeString');
 CL.AddDelphiFunction('Function XMLStringToWideString( const XMLString : AnsiString) : WideString');
 CL.AddDelphiFunction('Function FormatXMLData( const XMLData : DOMString) : DOMString');
 CL.AddDelphiFunction('Function LoadXMLDocument( const FileName : DOMString) : IXMLDocument');
 CL.AddDelphiFunction('Function LoadXMLData30( const XMLData : DOMString) : IXMLDocument;');
 CL.AddDelphiFunction('Function LoadXMLData31( const XMLData : AnsiString) : IXMLDocument;');
 CL.AddDelphiFunction('Function NewXMLDocument( Version : DOMString) : IXMLDocument');
 CL.AddDelphiFunction('Procedure XMLDocError32( const Msg : string);');
 CL.AddDelphiFunction('Procedure XMLDocError33( const Msg : string; const Args : array of const);');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure XMLDocError33_P( const Msg : string; const Args : array of const);
Begin XMLDoc.XMLDocError(Msg, Args); END;

(*----------------------------------------------------------------------------*)
Procedure XMLDocError32_P( const Msg : string);
Begin XMLDoc.XMLDocError(Msg); END;

(*----------------------------------------------------------------------------*)
Function LoadXMLData31_P( const XMLData : AnsiString) : IXMLDocument;
Begin Result := XMLDoc.LoadXMLData(XMLData); END;

(*----------------------------------------------------------------------------*)
Function LoadXMLData30_P( const XMLData : DOMString) : IXMLDocument;
Begin Result := XMLDoc.LoadXMLData(XMLData); END;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentOnAsyncLoad_W(Self: TXMLDocument; const T: TAsyncEventHandler);
begin Self.OnAsyncLoad := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentOnAsyncLoad_R(Self: TXMLDocument; var T: TAsyncEventHandler);
begin T := Self.OnAsyncLoad; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentAfterNodeChange_W(Self: TXMLDocument; const T: TNodeChangeEvent);
begin Self.AfterNodeChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentAfterNodeChange_R(Self: TXMLDocument; var T: TNodeChangeEvent);
begin T := Self.AfterNodeChange; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentBeforeNodeChange_W(Self: TXMLDocument; const T: TNodeChangeEvent);
begin Self.BeforeNodeChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentBeforeNodeChange_R(Self: TXMLDocument; var T: TNodeChangeEvent);
begin T := Self.BeforeNodeChange; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentAfterClose_W(Self: TXMLDocument; const T: TNotifyEvent);
begin Self.AfterClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentAfterClose_R(Self: TXMLDocument; var T: TNotifyEvent);
begin T := Self.AfterClose; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentBeforeClose_W(Self: TXMLDocument; const T: TNotifyEvent);
begin Self.BeforeClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentBeforeClose_R(Self: TXMLDocument; var T: TNotifyEvent);
begin T := Self.BeforeClose; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentAfterOpen_W(Self: TXMLDocument; const T: TNotifyEvent);
begin Self.AfterOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentAfterOpen_R(Self: TXMLDocument; var T: TNotifyEvent);
begin T := Self.AfterOpen; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentBeforeOpen_W(Self: TXMLDocument; const T: TNotifyEvent);
begin Self.BeforeOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentBeforeOpen_R(Self: TXMLDocument; var T: TNotifyEvent);
begin T := Self.BeforeOpen; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentXML_W(Self: TXMLDocument; const T: TStrings);
begin Self.XML := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentXML_R(Self: TXMLDocument; var T: TStrings);
begin T := Self.XML; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentParseOptions_W(Self: TXMLDocument; const T: TParseOptions);
begin Self.ParseOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentParseOptions_R(Self: TXMLDocument; var T: TParseOptions);
begin T := Self.ParseOptions; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentOptions_W(Self: TXMLDocument; const T: TXMLDocOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentOptions_R(Self: TXMLDocument; var T: TXMLDocOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentNodeIndentStr_W(Self: TXMLDocument; const T: DOMString);
begin Self.NodeIndentStr := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentNodeIndentStr_R(Self: TXMLDocument; var T: DOMString);
begin T := Self.NodeIndentStr; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentDOMVendor_W(Self: TXMLDocument; const T: TDOMVendor);
begin Self.DOMVendor := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentDOMVendor_R(Self: TXMLDocument; var T: TDOMVendor);
begin T := Self.DOMVendor; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentFileName_W(Self: TXMLDocument; const T: DOMString);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentFileName_R(Self: TXMLDocument; var T: DOMString);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentActive_W(Self: TXMLDocument; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentActive_R(Self: TXMLDocument; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentVersion_W(Self: TXMLDocument; const T: DOMString);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentVersion_R(Self: TXMLDocument; var T: DOMString);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentStandAlone_W(Self: TXMLDocument; const T: DOMString);
begin Self.StandAlone := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentStandAlone_R(Self: TXMLDocument; var T: DOMString);
begin T := Self.StandAlone; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentSchemaRef_R(Self: TXMLDocument; var T: DOMString);
begin T := Self.SchemaRef; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentNSPrefixBase_W(Self: TXMLDocument; const T: DOMString);
begin Self.NSPrefixBase := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentNSPrefixBase_R(Self: TXMLDocument; var T: DOMString);
begin T := Self.NSPrefixBase; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentNode_R(Self: TXMLDocument; var T: IXMLNode);
begin T := Self.Node; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentModified_R(Self: TXMLDocument; var T: Boolean);
begin T := Self.Modified; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentEncoding_W(Self: TXMLDocument; const T: DOMString);
begin Self.Encoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentEncoding_R(Self: TXMLDocument; var T: DOMString);
begin T := Self.Encoding; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentDocumentElement_W(Self: TXMLDocument; const T: IXMLNode);
begin Self.DocumentElement := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentDocumentElement_R(Self: TXMLDocument; var T: IXMLNode);
begin T := Self.DocumentElement; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentDOMImplementation_W(Self: TXMLDocument; const T: IDOMImplementation);
begin Self.DOMImplementation := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentDOMImplementation_R(Self: TXMLDocument; var T: IDOMImplementation);
begin T := Self.DOMImplementation; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentDOMDocument_W(Self: TXMLDocument; const T: IDOMDocument);
begin Self.DOMDocument := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentDOMDocument_R(Self: TXMLDocument; var T: IDOMDocument);
begin T := Self.DOMDocument; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentChildNodes_R(Self: TXMLDocument; var T: IXMLNodeList);
begin T := Self.ChildNodes; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentAsyncLoadState_R(Self: TXMLDocument; var T: Integer);
begin T := Self.AsyncLoadState; end;

(*----------------------------------------------------------------------------*)
Procedure TXMLDocumentSaveToXML29_P(Self: TXMLDocument;  var XML : UTF8String);
Begin Self.SaveToXML(XML); END;

(*----------------------------------------------------------------------------*)
Procedure TXMLDocumentSaveToXML28_P(Self: TXMLDocument;  var XML : WideString);
Begin Self.SaveToXML(XML); END;

(*----------------------------------------------------------------------------*)
Procedure TXMLDocumentSaveToXML27_P(Self: TXMLDocument;  var XML : DOMString);
Begin Self.SaveToXML(XML); END;

(*----------------------------------------------------------------------------*)
Procedure TXMLDocumentLoadFromXML26_P(Self: TXMLDocument;  const XML : DOMString);
Begin Self.LoadFromXML(XML); END;

(*----------------------------------------------------------------------------*)
Procedure TXMLDocumentLoadFromXML25_P(Self: TXMLDocument;  const XML : AnsiString);
Begin Self.LoadFromXML(XML); END;

(*----------------------------------------------------------------------------*)
Function TXMLDocumentAddChild24_P(Self: TXMLDocument;  const TagName, NamespaceURI : DOMString) : IXMLNode;
Begin Result := Self.AddChild(TagName, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function TXMLDocumentAddChild23_P(Self: TXMLDocument;  const TagName : DOMString) : IXMLNode;
Begin Result := Self.AddChild(TagName); END;

(*----------------------------------------------------------------------------*)
Function TXMLDocumentCreate22_P(Self: TClass; CreateNewInstance: Boolean;  const AFileName : DOMString):TObject;
Begin Result := TXMLDocument.Create(AFileName); END;

(*----------------------------------------------------------------------------*)
Function TXMLDocumentCreate21_P(Self: TClass; CreateNewInstance: Boolean;  AOwner : TComponent):TObject;
Begin Result := TXMLDocument.Create(AOwner); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeHasChildNode20_P(Self: TXMLNode;  const ChildTag, NamespaceURI : DOMString) : Boolean;
Begin Result := Self.HasChildNode(ChildTag, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeHasChildNode19_P(Self: TXMLNode;  const ChildTag : DOMString) : Boolean;
Begin Result := Self.HasChildNode(ChildTag); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeAddChild18_P(Self: TXMLNode;  const TagName, NamespaceURI : DOMString; NodeClass : TXMLNodeClass; Index : Integer) : IXMLNode;
Begin Result := Self.AddChild(TagName, NamespaceURI, NodeClass, Index); END;

(*----------------------------------------------------------------------------*)
Procedure TXMLNodeTransformNode17_P(Self: TXMLNode;  const stylesheet : IXMLNode; const output : IXMLDocument);
Begin Self.TransformNode(stylesheet, output); END;

(*----------------------------------------------------------------------------*)
Procedure TXMLNodeTransformNode16_P(Self: TXMLNode;  const stylesheet : IXMLNode; var output : WideString);
Begin Self.TransformNode(stylesheet, output); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeHasAttribute15_P(Self: TXMLNode;  const Name, NamespaceURI : DOMString) : Boolean;
Begin Result := Self.HasAttribute(Name, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeHasAttribute14_P(Self: TXMLNode;  const Name : DOMString) : Boolean;
Begin Result := Self.HasAttribute(Name); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeAddChild13_P(Self: TXMLNode;  const TagName, NamespaceURI : DOMString; GenPrefix : Boolean; Index : Integer) : IXMLNode;
Begin Result := Self.AddChild(TagName, NamespaceURI, GenPrefix, Index); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeAddChild12_P(Self: TXMLNode;  const TagName : DOMString; Index : Integer) : IXMLNode;
Begin Result := Self.AddChild(TagName, Index); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeAccessHasChildNode11_P(Self: IXMLNodeAccess;  const ChildTag, NamespaceURI : DOMString) : Boolean;
Begin Result := Self.HasChildNode(ChildTag, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeAccessHasChildNode10_P(Self: IXMLNodeAccess;  const ChildTag : DOMString) : Boolean;
Begin Result := Self.HasChildNode(ChildTag); END;

(*----------------------------------------------------------------------------*)
Function IXMLNodeAccessAddChild9_P(Self: IXMLNodeAccess;  const TagName, NamespaceURI : DOMString; NodeClass : TXMLNodeClass; Index : Integer) : IXMLNode;
Begin Result := Self.AddChild(TagName, NamespaceURI, NodeClass, Index); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListIndexOf8_P(Self: TXMLNodeList;  const Name, NamespaceURI : DOMString) : Integer;
Begin Result := Self.IndexOf(Name, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListIndexOf7_P(Self: TXMLNodeList;  const Name : DOMString) : Integer;
Begin Result := Self.IndexOf(Name); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListIndexOf6_P(Self: TXMLNodeList;  const Node : IXMLNode) : Integer;
Begin Result := Self.IndexOf(Node); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListFindNode5_P(Self: TXMLNodeList;  ChildNodeType : TGuid) : IXMLNode;
Begin Result := Self.FindNode(ChildNodeType); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListFindNode4_P(Self: TXMLNodeList;  NodeName, NamespaceURI : DOMString) : IXMLNode;
Begin Result := Self.FindNode(NodeName, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListFindNode3_P(Self: TXMLNodeList;  NodeName : DOMString) : IXMLNode;
Begin Result := Self.FindNode(NodeName); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListDelete2_P(Self: TXMLNodeList;  const Name, NamespaceURI : DOMString) : Integer;
Begin Result := Self.Delete(Name, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListDelete1_P(Self: TXMLNodeList;  const Name : DOMString) : Integer;
Begin Result := Self.Delete(Name); END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListDelete0_P(Self: TXMLNodeList;  const Index : Integer) : Integer;
Begin Result := Self.Delete(Index); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XMLDoc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateDOMNode, 'CreateDOMNode', cdRegister);
 S.RegisterDelphiFunction(@DetectCharEncoding, 'DetectCharEncoding', cdRegister);
 S.RegisterDelphiFunction(@CheckEncoding, 'CheckEncoding', cdRegister);
 S.RegisterDelphiFunction(@XMLStringToUnicodeString, 'XMLStringToUnicodeString', cdRegister);
 S.RegisterDelphiFunction(@XMLStringToWideString, 'XMLStringToWideString', cdRegister);
 S.RegisterDelphiFunction(@FormatXMLData, 'FormatXMLData', cdRegister);
 S.RegisterDelphiFunction(@LoadXMLDocument, 'LoadXMLDocument', cdRegister);
 S.RegisterDelphiFunction(@LoadXMLData30, 'LoadXMLData30', cdRegister);
 S.RegisterDelphiFunction(@LoadXMLData31, 'LoadXMLData31', cdRegister);
 S.RegisterDelphiFunction(@NewXMLDocument, 'NewXMLDocument', cdRegister);
 S.RegisterDelphiFunction(@XMLDocError32, 'XMLDocError32', cdRegister);
 S.RegisterDelphiFunction(@XMLDocError33, 'XMLDocError33', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLDocument(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLDocument) do
  begin
    RegisterConstructor(@TXMLDocumentCreate21_P, 'Create21');
    RegisterConstructor(@TXMLDocumentCreate22_P, 'Create22');
    RegisterMethod(@TXMLDocument.NewInstance, 'NewInstance');
    RegisterMethod(@TXMLDocument.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TXMLDocumentAddChild23_P, 'AddChild23');
    RegisterMethod(@TXMLDocumentAddChild24_P, 'AddChild24');
    RegisterMethod(@TXMLDocument.CreateElement, 'CreateElement');
    RegisterMethod(@TXMLDocument.CreateNode, 'CreateNode');
    RegisterMethod(@TXMLDocument.GetDocBinding, 'GetDocBinding');
    RegisterMethod(@TXMLDocument.IsEmptyDoc, 'IsEmptyDoc');
    RegisterMethod(@TXMLDocument.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TXMLDocument.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TXMLDocumentLoadFromXML25_P, 'LoadFromXML25');
    RegisterMethod(@TXMLDocumentLoadFromXML26_P, 'LoadFromXML26');
    RegisterMethod(@TXMLDocument.Refresh, 'Refresh');
    RegisterMethod(@TXMLDocument.RegisterDocBinding, 'RegisterDocBinding');
    RegisterMethod(@TXMLDocument.Resync, 'Resync');
    RegisterVirtualMethod(@TXMLDocument.SaveToFile, 'SaveToFile');
    RegisterMethod(@TXMLDocument.SaveToStream, 'SaveToStream');
    RegisterMethod(@TXMLDocumentSaveToXML27_P, 'SaveToXML27');
    RegisterMethod(@TXMLDocumentSaveToXML28_P, 'SaveToXML28');
    RegisterMethod(@TXMLDocumentSaveToXML29_P, 'SaveToXML29');
    RegisterPropertyHelper(@TXMLDocumentAsyncLoadState_R,nil,'AsyncLoadState');
    RegisterPropertyHelper(@TXMLDocumentChildNodes_R,nil,'ChildNodes');
    RegisterPropertyHelper(@TXMLDocumentDOMDocument_R,@TXMLDocumentDOMDocument_W,'DOMDocument');
    RegisterPropertyHelper(@TXMLDocumentDOMImplementation_R,@TXMLDocumentDOMImplementation_W,'DOMImplementation');
    RegisterPropertyHelper(@TXMLDocumentDocumentElement_R,@TXMLDocumentDocumentElement_W,'DocumentElement');
    RegisterPropertyHelper(@TXMLDocumentEncoding_R,@TXMLDocumentEncoding_W,'Encoding');
    RegisterMethod(@TXMLDocument.GeneratePrefix, 'GeneratePrefix');
    RegisterPropertyHelper(@TXMLDocumentModified_R,nil,'Modified');
    RegisterPropertyHelper(@TXMLDocumentNode_R,nil,'Node');
    RegisterPropertyHelper(@TXMLDocumentNSPrefixBase_R,@TXMLDocumentNSPrefixBase_W,'NSPrefixBase');
    RegisterPropertyHelper(@TXMLDocumentSchemaRef_R,nil,'SchemaRef');
    RegisterPropertyHelper(@TXMLDocumentStandAlone_R,@TXMLDocumentStandAlone_W,'StandAlone');
    RegisterPropertyHelper(@TXMLDocumentVersion_R,@TXMLDocumentVersion_W,'Version');
    RegisterPropertyHelper(@TXMLDocumentActive_R,@TXMLDocumentActive_W,'Active');
    RegisterPropertyHelper(@TXMLDocumentFileName_R,@TXMLDocumentFileName_W,'FileName');
    RegisterPropertyHelper(@TXMLDocumentDOMVendor_R,@TXMLDocumentDOMVendor_W,'DOMVendor');
    RegisterPropertyHelper(@TXMLDocumentNodeIndentStr_R,@TXMLDocumentNodeIndentStr_W,'NodeIndentStr');
    RegisterPropertyHelper(@TXMLDocumentOptions_R,@TXMLDocumentOptions_W,'Options');
    RegisterPropertyHelper(@TXMLDocumentParseOptions_R,@TXMLDocumentParseOptions_W,'ParseOptions');
    RegisterPropertyHelper(@TXMLDocumentXML_R,@TXMLDocumentXML_W,'XML');
    RegisterPropertyHelper(@TXMLDocumentBeforeOpen_R,@TXMLDocumentBeforeOpen_W,'BeforeOpen');
    RegisterPropertyHelper(@TXMLDocumentAfterOpen_R,@TXMLDocumentAfterOpen_W,'AfterOpen');
    RegisterPropertyHelper(@TXMLDocumentBeforeClose_R,@TXMLDocumentBeforeClose_W,'BeforeClose');
    RegisterPropertyHelper(@TXMLDocumentAfterClose_R,@TXMLDocumentAfterClose_W,'AfterClose');
    RegisterPropertyHelper(@TXMLDocumentBeforeNodeChange_R,@TXMLDocumentBeforeNodeChange_W,'BeforeNodeChange');
    RegisterPropertyHelper(@TXMLDocumentAfterNodeChange_R,@TXMLDocumentAfterNodeChange_W,'AfterNodeChange');
    RegisterPropertyHelper(@TXMLDocumentOnAsyncLoad_R,@TXMLDocumentOnAsyncLoad_W,'OnAsyncLoad');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLNodeCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLNodeCollection) do
  begin
    RegisterMethod(@TXMLNodeCollection.AfterConstruction, 'AfterConstruction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLNode) do
  begin
    RegisterConstructor(@TXMLNode.Create, 'Create');
    RegisterConstructor(@TXMLNode.CreateHosted, 'CreateHosted');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLNodeList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLNodeList) do
  begin
    RegisterConstructor(@TXMLNodeList.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XMLDoc(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLNode) do
  with CL.Add(TXMLNodeList) do
  with CL.Add(TXMLNodeCollection) do
  with CL.Add(TXMLDocument) do
  RIRegister_TXMLNodeList(CL);
  RIRegister_TXMLNode(CL);
  RIRegister_TXMLNodeCollection(CL);
  RIRegister_TXMLDocument(CL);
end;

 
 
{ TPSImport_XMLDoc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XMLDoc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XMLDoc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XMLDoc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XMLDoc(ri);
  RIRegister_XMLDoc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
