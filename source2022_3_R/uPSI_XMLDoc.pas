unit uPSI_XMLDoc;
{
Tafter all decide to TALXML another XML stand - 4.2.8.10    IXMLNodeAccess bug!
  needs XMLDoc4maX    - create bug
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
  ,XMLDoc4maX
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XMLDoc]);
end;


function LoadXMLData2(const XMLData: string): IXMLDocument; overload;
begin
  Result := TXMLDocument.Create(nil);
  Result.LoadFromXML(XMLData);
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLDocument(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TXMLDocument') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TXMLDocument') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent);');
    RegisterMethod('Constructor Create2( const AFileName : DOMString)');
       RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AfterConstruction');
    RegisterMethod('Function AddChild( const TagName : DOMString) : IXMLNode;');
    RegisterMethod('Function AddChild2( const TagName, NamespaceURI : DOMString) : IXMLNode;');
    RegisterMethod('Function CreateElement( const TagOrData, NamespaceURI : DOMString) : IXMLNode');
    RegisterMethod('Function CreateNode( const NameOrData : DOMString; NodeType : TNodeType; const AddlData : DOMString) : IXMLNode');
    RegisterMethod('Function GetDocBinding( const TagName : DOMString; DocNodeClass : TClass; NamespaceURI : DOMString) : IXMLNode');
    RegisterMethod('Function IsEmptyDoc : Boolean');
    RegisterMethod('Procedure LoadFromFile( const AFileName : DOMString)');
    RegisterMethod('Procedure LoadFromStream( const Stream : TStream; EncodingType : TXMLEncodingType)');
    RegisterMethod('Procedure LoadFromXML( const XML : string);');
    RegisterMethod('Procedure LoadFromXML2( const XML : DOMString);');
    RegisterMethod('Procedure Refresh');
    RegisterMethod('Procedure RegisterDocBinding( const TagName : DOMString; DocNodeClass : TClass; NamespaceURI : DOMString)');
    RegisterMethod('Procedure Resync');
    RegisterMethod('Procedure SaveToFile( const AFileName : DOMString)');
    RegisterMethod('Procedure SaveToStream( const Stream : TStream)');
    RegisterMethod('Procedure SaveToXML( var XML : DOMString);');
    RegisterMethod('Procedure SaveToXML2( var XML : string);');
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
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TXMLNode') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TXMLNode') do begin
    RegisterMethod('Constructor Create( const ADOMNode : IDOMNode; const AParentNode : TXMLNode; const OwnerDoc : TXMLDocument)');
    RegisterMethod('Constructor CreateHosted( HostNode : TXMLNode)');
     //RegisterProperty('Node', 'OleVariant IXMLNode', iptr);
      // SetDefaultPropery('Node');

     RegisterMethod('Function AddChild( const TagName : DOMString; Index : Integer) : IXMLNode;');
    RegisterMethod('Function AddChild13( const TagName, NamespaceURI : DOMString; GenPrefix : Boolean; Index : Integer) : IXMLNode;');
    RegisterMethod('Function CloneNode( Deep : Boolean) : IXMLNode');
    RegisterMethod('Procedure DeclareNamespace( const Prefix, URI : DOMString)');
    RegisterMethod('Function FindNamespaceDecl( const NamespaceURI : DOMString) : IXMLNode');
    RegisterMethod('Function FindNamespaceURI( const TagOrPrefix : DOMString) : DOMString');
    RegisterMethod('Function HasAttribute( const Name : DOMString) : Boolean;');
    RegisterMethod('Function HasAttribute15( const Name, NamespaceURI : DOMString) : Boolean;');
    RegisterMethod('Function NextSibling : IXMLNode');
    RegisterMethod('Procedure Normalize');
    RegisterMethod('Function PreviousSibling : IXMLNode');
    RegisterMethod('Procedure Resync');
    RegisterMethod('Procedure SetAttributeNS( const AttrName, NamespaceURI : DOMString; const Value : OleVariant)');
    RegisterMethod('Procedure TransformNode16( const stylesheet : IXMLNode; var output : WideString);');
    RegisterMethod('Procedure TransformNode17( const stylesheet : IXMLNode; const output : IXMLDocument);');
    RegisterMethod('Function AddChild18( const TagName, NamespaceURI : DOMString; NodeClass : TXMLNodeClass; Index : Integer) : IXMLNode;');
    RegisterMethod('Procedure CheckTextNode');
    RegisterMethod('Procedure ClearDocumentRef');
    RegisterMethod('Function CreateAttributeNode( const ADOMNode : IDOMNode) : IXMLNode');
    RegisterMethod('Function CreateChildNode( const ADOMNode : IDOMNode) : IXMLNode');
    RegisterMethod('Function CreateCollection( const CollectionClass : TXMLNodeCollectionClass; const ItemInterface : TGuid; const ItemTag : DOMString; ItemNS : DOMString) : TXMLNodeCollection');
    RegisterMethod('Function DOMElement : IDOMElement');
    RegisterMethod('Function FindHostedNode( const NodeClass : TXMLNodeClass) : IXMLNode');
    RegisterMethod('Function GetChildNodeClasses : TNodeClassArray');
    RegisterMethod('Function GetHostedNodes : TXMLNodeArray');
    RegisterMethod('Function GetHostNode : TXMLNode');
    RegisterMethod('Function GetNodeObject : TXMLNode');
    RegisterMethod('Function HasChildNode( const ChildTag : DOMString) : Boolean;');
    RegisterMethod('Function HasChildNode20( const ChildTag, NamespaceURI : DOMString) : Boolean;');
    RegisterMethod('Function InternalAddChild( NodeClass : TXMLNodeClass; const NodeName, NamespaceURI : DOMString; Index : Integer) : IXMLNode');
    RegisterMethod('Function NestingLevel : Integer');
    RegisterMethod('Procedure RegisterChildNode( const TagName : DOMString; ChildNodeClass : TXMLNodeClass; NamespaceURI : DOMString)');
    RegisterMethod('Procedure RegisterChildNodes( const TagNames : array of DOMString; const NodeClasses : array of TXMLNodeClass)');
    RegisterMethod('Procedure SetCollection( const Value : TXMLNodeCollection)');
    RegisterMethod('Procedure SetParentNode( const Value : TXMLNode)');
    RegisterProperty('OnHostChildNotify', 'TNodeListNotification', iptrw);
    RegisterProperty('OnHostAttrNotify', 'TNodeListNotification', iptrw);
    RegisterMethod('Procedure AddHostedNode( Node : TXMLNode)');
    RegisterMethod('Procedure AttributeListNotify( Operation : TNodeListOperation; var Node : IXMLNode; const IndexOrName : OleVariant; BeforeOperation : Boolean)');
    RegisterMethod('Procedure CheckReadOnly');
    RegisterMethod('Procedure ChildListNotify( Operation : TNodeListOperation; var Node : IXMLNode; const IndexOrName : OleVariant; BeforeOperation : Boolean)');
    RegisterMethod('Procedure CheckNotHosted');
    RegisterMethod('Function CreateAttributeList : IXMLNodeList');
    RegisterMethod('Function CreateChildList : IXMLNodeList');
    RegisterMethod('Procedure DoNodeChange( ChangeType : TNodeChange; BeforeOperation : Boolean)');
    RegisterMethod('Function GetPrefixedName( const Name, NamespaceURI : DOMString) : DOMString');
    RegisterMethod('Procedure RemoveHostedNode( Node : TXMLNode)');
    RegisterMethod('Procedure SetAttributeNodes( const Value : IXMLNodeList)');
    RegisterMethod('Procedure SetChildNodes( const Value : IXMLNodeList)');
    RegisterProperty('AttributeNodes', 'IXMLNodeList', iptr);
    RegisterProperty('ChildNodes', 'IXMLNodeList', iptrw);
    RegisterProperty('ChildNodeClasses', 'TNodeClassArray', iptr);
    RegisterProperty('Collection', 'TXMLNodeCollection', iptrw);
    RegisterProperty('DOMNode', 'IDOMNode', iptr);
    RegisterProperty('HostedNodes', 'TXMLNodeArray', iptr);
    RegisterProperty('HostNode', 'TXMLNode', iptrw);
    RegisterProperty('OwnerDocument', 'TXMLDocument', iptr);
    RegisterProperty('ParentNode', 'TXMLNode', iptr);
    RegisterMethod('Procedure Free;');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXMLNodeAccess(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXMLNode', 'IXMLNodeAccess') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLNodeAccess, 'IXMLNodeAccess') do begin
    RegisterMethod('Function AddChild( const TagName, NamespaceURI : DOMString; NodeClass : TXMLNodeClass; Index : Integer) : IXMLNode;', cdRegister);
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
    RegisterMethod('Function HasChildNode( const ChildTag : DOMString) : Boolean;', cdRegister);
    RegisterMethod('Function HasChildNode2( const ChildTag, NamespaceURI : DOMString) : Boolean;', cdRegister);
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
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TXMLNodeList') do begin
    RegisterMethod('Constructor Create( Owner : TXMLNode; const DefaultNamespaceURI : DOMString; NotificationProc : TNodeListNotification)');
    RegisterProperty('Nodes', 'OleVariant IXMLNode', iptr);
      SetDefaultPropery('Nodes');
    RegisterMethod('Procedure Free;');
     RegisterMethod('Function Add( const Node : IXMLNode) : Integer');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Delete( const Index : Integer) : Integer;');
    RegisterMethod('Function Delete1( const Name : DOMString) : Integer;');
    RegisterMethod('Function Delete2( const Name, NamespaceURI : DOMString) : Integer;');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Function First : IXMLNode');
    RegisterMethod('Function FindNode( NodeName : DOMString) : IXMLNode;');
    RegisterMethod('Function FindNode4( NodeName, NamespaceURI : DOMString) : IXMLNode;');
    RegisterMethod('Function FindNode5( ChildNodeType : TGuid) : IXMLNode;');
    RegisterMethod('Function FindSibling( const Node : IXMLNode; Delta : Integer) : IXMLNode');
    RegisterMethod('Function Get( Index : Integer) : IXMLNode');
    RegisterMethod('Function GetCount : Integer');
    RegisterMethod('Function GetNode( const IndexOrName : OleVariant) : IXMLNode');
    RegisterMethod('Function GetUpdateCount : Integer');
    RegisterMethod('Function IndexOf( const Node : IXMLNode) : Integer;');
    RegisterMethod('Function IndexOf7( const Name : DOMString) : Integer;');
    RegisterMethod('Function IndexOf8( const Name, NamespaceURI : DOMString) : Integer;');
    RegisterMethod('Procedure Insert( Index : Integer; const Node : IXMLNode)');
    RegisterMethod('Function Last : IXMLNode');
    RegisterMethod('Function Remove( const Node : IXMLNode) : Integer');
    RegisterMethod('Function ReplaceNode( const OldNode, NewNode : IXMLNode) : IXMLNode');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('UpdateCount', 'Integer', iptr);
 //   RegisterMethod('Constructor Create( Owner : TXMLNode; const DefaultNamespaceURI : DOMString; NotificationProc : TNodeListNotification)');


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XMLDoc(CL: TPSPascalCompiler);
begin
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLNode, 'IXMLNode');
   CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLNodeList, 'IXMLNodeList');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLNodeCollection, 'IXMLNodeCollection');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXMLDocument, 'IXMLDocument');

  CL.AddClassN(CL.FindClass('TOBJECT'),'TXMLNode');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXMLNodeList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXMLNodeCollection');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXMLDocument');
  CL.AddTypeS('TNodeListOperation', '( nlInsert, nlRemove, nlCreateNode )');
  CL.AddTypeS('TNodeListNotification', 'Procedure ( Operation : TNodeListOperat'
   +'ion; var Node : IXMLNode; const IndexOrName : OleVariant; BeforeOperation : Boolean)');
  SIRegister_TXMLNodeList(CL);

   CL.AddTypeS('TAsyncEventHandler', 'procedure(Sender: TObject; AsyncLoadState: Integer) of Object)');

  //CL.AddTypeS('TXMLNodeClass', 'class of TXMLNode');
  CL.AddTypeS('TXMLNodeArray', 'array of TXMLNode');
  CL.AddTypeS('TNodeClassInfo', 'record NodeName : DOMString; NamespaceURI : DOMString; NodeClass : TXMLNode; end');
  CL.AddTypeS('TNodeClassArray', 'array of TNodeClassInfo');
  //CL.AddTypeS('TXMLNodeCollectionClass', 'class of TXMLNodeCollection');
  CL.AddTypeS('TNodeChange', '( ncUpdateValue, ncInsertChild, ncRemoveChild, nc'
   +'AddAttribute, ncRemoveAttribute )');
  SIRegister_IXMLNodeAccess(CL);
  SIRegister_TXMLNode(CL);
  SIRegister_TXMLNodeCollection(CL);
  CL.AddTypeS('TNodeChangeEvent', 'Procedure ( const Node : IXMLNode; ChangeType : TNodeChange)');
  CL.AddTypeS('TXMLPrologItem', '( xmlpVersion, xmlpEncoding, xmlpStandalone )');
  CL.AddTypeS('TXMLDocumentSource', '( xdsNone, xdsXMLProperty, xdsXMLData, xdsFile, xdsStream )');
  SIRegister_IXMLDocumentAccess(CL);
  SIRegister_TXMLDocument(CL);
 CL.AddDelphiFunction('Function CreateDOMNode( Doc : IDOMDocument; const NameOrData : DOMString; NodeType : TNodeType; const AddlData : DOMString) : IDOMNode');
 CL.AddDelphiFunction('Function DetectCharEncoding( S : TStream) : TXmlEncodingType');
 CL.AddDelphiFunction('Procedure CheckEncoding( var XMLData : DOMString; const ValidEncodings : array of string)');
 CL.AddDelphiFunction('Function XMLStringToWideString( const XMLString : string) : WideString');
 CL.AddDelphiFunction('Function FormatXMLData( const XMLData : DOMString) : DOMString');
 CL.AddDelphiFunction('Function LoadXMLDocument3( const FileName : DOMString) : IXMLDocument');
 CL.AddDelphiFunction('Function LoadXMLData( const XMLData : DOMString) : IXMLDocument;');
 CL.AddDelphiFunction('Function LoadXMLData2( const XMLData : string) : IXMLDocument;');
 CL.AddDelphiFunction('Function NewXMLDocument( Version : DOMString) : IXMLDocument');
 CL.AddDelphiFunction('Procedure XMLDocError( const Msg : string);');
 CL.AddDelphiFunction('Procedure XMLDocError2( const Msg : string; const Args : array of const);');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure XMLDocError31_P( const Msg : string; const Args : array of const);
Begin XMLDoc4max.XMLDocError(Msg, Args); END;

(*----------------------------------------------------------------------------*)
Procedure XMLDocError30_P( const Msg : string);
Begin XMLDoc4max.XMLDocError(Msg); END;

(*----------------------------------------------------------------------------*)
Function LoadXMLData29_P( const XMLData : string) : IXMLDocument;
Begin Result := XMLDoc4max.LoadXMLData(XMLData); END;

(*----------------------------------------------------------------------------*)
Function LoadXMLData28_P( const XMLData : DOMString) : IXMLDocument;
Begin Result := XMLDoc4max.LoadXMLData(XMLData); END;

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
Procedure TXMLDocumentSaveToXML27_P(Self: TXMLDocument;  var XML : string);
Begin Self.SaveToXML(XML); END;

(*----------------------------------------------------------------------------*)
Procedure TXMLDocumentSaveToXML26_P(Self: TXMLDocument;  var XML : DOMString);
Begin Self.SaveToXML(XML); END;

(*----------------------------------------------------------------------------*)
Procedure TXMLDocumentLoadFromXML25_P(Self: TXMLDocument;  const XML : DOMString);
Begin Self.LoadFromXML(XML); END;

(*----------------------------------------------------------------------------*)
Procedure TXMLDocumentLoadFromXML24_P(Self: TXMLDocument;  const XML : string);
Begin Self.LoadFromXML(XML); END;

(*----------------------------------------------------------------------------*)
Function TXMLDocumentAddChild23_P(Self: TXMLDocument;  const TagName, NamespaceURI : DOMString) : IXMLNode;
Begin Result := Self.AddChild(TagName, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function TXMLDocumentAddChild22_P(Self: TXMLDocument;  const TagName : DOMString) : IXMLNode;
Begin Result := Self.AddChild(TagName); END;

(*----------------------------------------------------------------------------*)
Function TXMLDocumentCreate21_P(Self: TClass; CreateNewInstance: Boolean;  AOwner : TComponent):TObject;
Begin Result := TXMLDocument.Create(AOwner); END;

Function TXMLDocumentCreate2File(Self: TClass; CreateNewInstance: Boolean;  const AFileName: DOMString):TObject;
Begin Result := TXMLDocument.Create(AFileName); END;

{constructor TXMLDocument.CreateFile(const AFileName: DOMString);
begin
  inherited Create(nil);
  FFileName := AFileName;
end;     }

{*
(*----------------------------------------------------------------------------*)
Function TXMLNodeHasChildNode20_P(Self: TXMLNode;  const ChildTag, NamespaceURI : DOMString) : Boolean;
Begin //Result := Self.HasChildNode(ChildTag, NamespaceURI);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeHasChildNode19_P(Self: TXMLNode;  const ChildTag : DOMString) : Boolean;
Begin //Result := Self.HasChildNode(ChildTag);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeAddChild18_P(Self: TXMLNode;  const TagName, NamespaceURI : DOMString; NodeClass : TXMLNodeClass; Index : Integer) : IXMLNode;
Begin //Result := Self.AddChild(TagName, NamespaceURI, NodeClass, Index);
END;

(*----------------------------------------------------------------------------*)
Procedure TXMLNodeTransformNode17_P(Self: TXMLNode;  const stylesheet : IXMLNode; const output : IXMLDocument);
Begin //Self.TransformNode(stylesheet, output);
END;

(*----------------------------------------------------------------------------*)
Procedure TXMLNodeTransformNode16_P(Self: TXMLNode;  const stylesheet : IXMLNode; var output : WideString);
Begin //Self.TransformNode(stylesheet, output);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeHasAttribute15_P(Self: TXMLNode;  const Name, NamespaceURI : DOMString) : Boolean;
Begin //Result := Self.HasAttribute(Name, NamespaceURI);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeHasAttribute14_P(Self: TXMLNode;  const Name : DOMString) : Boolean;
Begin //Result := Self.HasAttribute(Name);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeAddChild13_P(Self: TXMLNode;  const TagName, NamespaceURI : DOMString; GenPrefix : Boolean; Index : Integer) : IXMLNode;
Begin //Result := Self.AddChild(TagName, NamespaceURI, GenPrefix, Index);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeAddChild12_P(Self: TXMLNode;  const TagName : DOMString; Index : Integer) : IXMLNode;
Begin //Result := Self.AddChild(TagName, Index);
END;

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
Begin //Result := Self.IndexOf(Name, NamespaceURI);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListIndexOf7_P(Self: TXMLNodeList;  const Name : DOMString) : Integer;
Begin //Result := Self.IndexOf(Name);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListIndexOf6_P(Self: TXMLNodeList;  const Node : IXMLNode) : Integer;
Begin //Result := Self.IndexOf(Node);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListFindNode5_P(Self: TXMLNodeList;  ChildNodeType : TGuid) : IXMLNode;
Begin //Result := Self.FindNode(ChildNodeType);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListFindNode4_P(Self: TXMLNodeList;  NodeName, NamespaceURI : DOMString) : IXMLNode;
Begin //Result := Self.FindNode(NodeName, NamespaceURI);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListFindNode3_P(Self: TXMLNodeList;  NodeName : DOMString) : IXMLNode;
Begin //Result := Self.FindNode(NodeName);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListDelete2_P(Self: TXMLNodeList;  const Name, NamespaceURI : DOMString) : Integer;
Begin //Result := Self.Delete(Name, NamespaceURI);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListDelete1_P(Self: TXMLNodeList;  const Name : DOMString) : Integer;
Begin //Result := Self.Delete(Name);
END;

(*----------------------------------------------------------------------------*)
Function TXMLNodeListDelete0_P(Self: TXMLNodeList;  const Index : Integer) : Integer;
Begin //Result := Self.Delete(Index);
END;   *}

procedure XMLDocError2(const Msg: string; const Args: array of const); overload;
begin
  raise EXMLDocError.CreateFmt(Msg, Args);
end;

procedure XMLDocError1(const Msg: string); overload;
begin
  raise EXMLDocError.Create(Msg);
end;


function LoadXMLData1(const XMLData: DOMString): IXMLDocument; overload;
begin
  Result := TXMLDocument.Create(nil);
  Result.LoadFromXML(XMLData);
end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_XMLDoc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateDOMNode, 'CreateDOMNode', cdRegister);
 S.RegisterDelphiFunction(@DetectCharEncoding, 'DetectCharEncoding', cdRegister);
 S.RegisterDelphiFunction(@CheckEncoding, 'CheckEncoding', cdRegister);
 S.RegisterDelphiFunction(@XMLStringToWideString, 'XMLStringToWideString', cdRegister);
 S.RegisterDelphiFunction(@FormatXMLData, 'FormatXMLData', cdRegister);
 S.RegisterDelphiFunction(@LoadXMLDocument, 'LoadXMLDocument3', cdRegister);
 S.RegisterDelphiFunction(@LoadXMLData1, 'LoadXMLData', cdRegister);
 S.RegisterDelphiFunction(@LoadXMLData2, 'LoadXMLData2', cdRegister);
 S.RegisterDelphiFunction(@NewXMLDocument, 'NewXMLDocument', cdRegister);
 S.RegisterDelphiFunction(@XMLDocError1, 'XMLDocError', cdRegister);
 S.RegisterDelphiFunction(@XMLDocError2, 'XMLDocError2', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLDocument(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLDocument) do begin
    RegisterConstructor(@TXMLDocumentCreate21_P, 'Create');
    RegisterConstructor(@TXMLDocumentCreate2File, 'Create2');
      RegisterMethod(@TXMLDocument.Destroy, 'Free');
    RegisterMethod(@TXMLDocument.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TXMLDocumentAddChild22_P, 'AddChild');
    RegisterMethod(@TXMLDocumentAddChild23_P, 'AddChild2');
    RegisterMethod(@TXMLDocument.CreateElement, 'CreateElement');
    RegisterMethod(@TXMLDocument.CreateNode, 'CreateNode');
    RegisterMethod(@TXMLDocument.GetDocBinding, 'GetDocBinding');
    RegisterMethod(@TXMLDocument.IsEmptyDoc, 'IsEmptyDoc');
    RegisterMethod(@TXMLDocument.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TXMLDocument.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TXMLDocumentLoadFromXML24_P, 'LoadFromXML');
    RegisterMethod(@TXMLDocumentLoadFromXML25_P, 'LoadFromXML2');
    RegisterMethod(@TXMLDocument.Refresh, 'Refresh');
    RegisterMethod(@TXMLDocument.RegisterDocBinding, 'RegisterDocBinding');
    RegisterMethod(@TXMLDocument.Resync, 'Resync');
    RegisterMethod(@TXMLDocument.SaveToFile, 'SaveToFile');
    RegisterMethod(@TXMLDocument.SaveToStream, 'SaveToStream');
    RegisterMethod(@TXMLDocumentSaveToXML26_P, 'SaveToXML');
    RegisterMethod(@TXMLDocumentSaveToXML27_P, 'SaveToXML2');
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
  end;
end;

procedure TXMLNodelist_R(Self: IXMLNodelist; var T: IXMLNode; const t1: OleVariant);
begin T := Self.Nodes[t1]; end;


(*----------------------------------------------------------------------------*)
procedure TXMLNodeParentNode_R(Self: TXMLNode; var T: TXMLNode);
begin T := Self.ParentNode; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeOwnerDocument_R(Self: TXMLNode; var T: TXMLDocument);
begin T := Self.OwnerDocument; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeHostNode_W(Self: TXMLNode; const T: TXMLNode);
begin Self.HostNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeHostNode_R(Self: TXMLNode; var T: TXMLNode);
begin T := Self.HostNode; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeHostedNodes_R(Self: TXMLNode; var T: TXMLNodeArray);
begin T := Self.HostedNodes; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeDOMNode_R(Self: TXMLNode; var T: IDOMNode);
begin T := Self.DOMNode; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeCollection_W(Self: TXMLNode; const T: TXMLNodeCollection);
begin Self.Collection := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeCollection_R(Self: TXMLNode; var T: TXMLNodeCollection);
begin T := Self.Collection; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeChildNodeClasses_R(Self: TXMLNode; var T: TNodeClassArray);
begin T := Self.ChildNodeClasses; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeChildNodes_W(Self: TXMLNode; const T: IXMLNodeList);
begin Self.ChildNodes := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeChildNodes_R(Self: TXMLNode; var T: IXMLNodeList);
begin T := Self.ChildNodes; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeAttributeNodes_R(Self: TXMLNode; var T: IXMLNodeList);
begin T := Self.AttributeNodes; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeOnHostAttrNotify_W(Self: TXMLNode; const T: TNodeListNotification);
begin Self.OnHostAttrNotify := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeOnHostAttrNotify_R(Self: TXMLNode; var T: TNodeListNotification);
begin T := Self.OnHostAttrNotify; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeOnHostChildNotify_W(Self: TXMLNode; const T: TNodeListNotification);
begin Self.OnHostChildNotify := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeOnHostChildNotify_R(Self: TXMLNode; var T: TNodeListNotification);
begin T := Self.OnHostChildNotify; end;

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
procedure RIRegister_TXMLNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLNode) do  begin
    RegisterConstructor(@TXMLNode.Create, 'Create');
    RegisterConstructor(@TXMLNode.CreateHosted, 'CreateHosted');
     // RegisterPropertyHelper(@TXMLNode_R,nil,'Node');
      RegisterMethod(@TXMLNode.Destroy, 'Free');

       RegisterMethod(@TXMLNodeAddChild12_P, 'AddChild');
    RegisterMethod(@TXMLNodeAddChild13_P, 'AddChild13');
    RegisterMethod(@TXMLNode.CloneNode, 'CloneNode');
    RegisterMethod(@TXMLNode.DeclareNamespace, 'DeclareNamespace');
    RegisterMethod(@TXMLNode.FindNamespaceDecl, 'FindNamespaceDecl');
    RegisterMethod(@TXMLNode.FindNamespaceURI, 'FindNamespaceURI');
    RegisterMethod(@TXMLNodeHasAttribute14_P, 'HasAttribute');
    RegisterMethod(@TXMLNodeHasAttribute15_P, 'HasAttribute15');
    RegisterMethod(@TXMLNode.NextSibling, 'NextSibling');
    RegisterMethod(@TXMLNode.Normalize, 'Normalize');
    RegisterMethod(@TXMLNode.PreviousSibling, 'PreviousSibling');
    RegisterMethod(@TXMLNode.Resync, 'Resync');
    RegisterMethod(@TXMLNode.SetAttributeNS, 'SetAttributeNS');
    RegisterMethod(@TXMLNodeTransformNode16_P, 'TransformNode16');
    RegisterMethod(@TXMLNodeTransformNode17_P, 'TransformNode17');
    RegisterMethod(@TXMLNodeAddChild18_P, 'AddChild18');
    RegisterMethod(@TXMLNode.CheckTextNode, 'CheckTextNode');
    RegisterMethod(@TXMLNode.ClearDocumentRef, 'ClearDocumentRef');
    RegisterVirtualMethod(@TXMLNode.CreateAttributeNode, 'CreateAttributeNode');
    RegisterVirtualMethod(@TXMLNode.CreateChildNode, 'CreateChildNode');
    RegisterMethod(@TXMLNode.CreateCollection, 'CreateCollection');
    RegisterMethod(@TXMLNode.DOMElement, 'DOMElement');
    RegisterMethod(@TXMLNode.FindHostedNode, 'FindHostedNode');
    RegisterMethod(@TXMLNode.GetChildNodeClasses, 'GetChildNodeClasses');
    RegisterMethod(@TXMLNode.GetHostedNodes, 'GetHostedNodes');
    RegisterMethod(@TXMLNode.GetHostNode, 'GetHostNode');
    RegisterMethod(@TXMLNode.GetNodeObject, 'GetNodeObject');
    RegisterMethod(@TXMLNodeHasChildNode19_P, 'HasChildNode');
    RegisterMethod(@TXMLNodeHasChildNode20_P, 'HasChildNode20');
    RegisterMethod(@TXMLNode.InternalAddChild, 'InternalAddChild');
    RegisterMethod(@TXMLNode.NestingLevel, 'NestingLevel');
    RegisterMethod(@TXMLNode.RegisterChildNode, 'RegisterChildNode');
    RegisterMethod(@TXMLNode.RegisterChildNodes, 'RegisterChildNodes');
    RegisterMethod(@TXMLNode.SetCollection, 'SetCollection');
    RegisterVirtualMethod(@TXMLNode.SetParentNode, 'SetParentNode');
    RegisterPropertyHelper(@TXMLNodeOnHostChildNotify_R,@TXMLNodeOnHostChildNotify_W,'OnHostChildNotify');
    RegisterPropertyHelper(@TXMLNodeOnHostAttrNotify_R,@TXMLNodeOnHostAttrNotify_W,'OnHostAttrNotify');
    {RegisterMethod(@TXMLNode.AddHostedNode, 'AddHostedNode');
    RegisterMethod(@TXMLNode.AttributeListNotify, 'AttributeListNotify');
    RegisterMethod(@TXMLNode.CheckReadOnly, 'CheckReadOnly');
    RegisterVirtualMethod(@TXMLNode.ChildListNotify, 'ChildListNotify');
    RegisterMethod(@TXMLNode.CheckNotHosted, 'CheckNotHosted');
    RegisterVirtualMethod(@TXMLNode.CreateAttributeList, 'CreateAttributeList');}
    {RegisterVirtualMethod(@TXMLNode.CreateChildList, 'CreateChildList');
    RegisterVirtualMethod(@TXMLNode.DoNodeChange, 'DoNodeChange');
    RegisterMethod(@TXMLNode.GetPrefixedName, 'GetPrefixedName');
    RegisterMethod(@TXMLNode.RemoveHostedNode, 'RemoveHostedNode');
    RegisterVirtualMethod(@TXMLNode.SetAttributeNodes, 'SetAttributeNodes');
    RegisterVirtualMethod(@TXMLNode.SetChildNodes, 'SetChildNodes'); }
    RegisterPropertyHelper(@TXMLNodeAttributeNodes_R,nil,'AttributeNodes');
    RegisterPropertyHelper(@TXMLNodeChildNodes_R,@TXMLNodeChildNodes_W,'ChildNodes');
    RegisterPropertyHelper(@TXMLNodeChildNodeClasses_R,nil,'ChildNodeClasses');
    RegisterPropertyHelper(@TXMLNodeCollection_R,@TXMLNodeCollection_W,'Collection');
    RegisterPropertyHelper(@TXMLNodeDOMNode_R,nil,'DOMNode');
    RegisterPropertyHelper(@TXMLNodeHostedNodes_R,nil,'HostedNodes');
    RegisterPropertyHelper(@TXMLNodeHostNode_R,@TXMLNodeHostNode_W,'HostNode');
    RegisterPropertyHelper(@TXMLNodeOwnerDocument_R,nil,'OwnerDocument');
    RegisterPropertyHelper(@TXMLNodeParentNode_R,nil,'ParentNode');
    //RegisterConstructor(@TXMLNode.Create, 'Create');
    //RegisterConstructor(@TXMLNode.CreateHosted, 'CreateHosted');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure TXMLNodeListUpdateCount_R(Self: TXMLNodeList; var T: Integer);
begin T := Self.UpdateCount; end;

(*----------------------------------------------------------------------------*)
procedure TXMLNodeListCount_R(Self: TXMLNodeList; var T: Integer);
begin T := Self.Count; end;

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
procedure RIRegister_TXMLNodeList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLNodeList) do begin
    RegisterConstructor(@TXMLNodeList.Create, 'Create');
      RegisterPropertyHelper(@TXMLNodeList_R,nil,'Nodes');

     RegisterMethod(@TXMLNodeList.Destroy, 'Free');
         RegisterMethod(@TXMLNodeList.Add, 'Add');
    RegisterMethod(@TXMLNodeList.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TXMLNodeList.Clear, 'Clear');
    RegisterMethod(@TXMLNodeListDelete0_P, 'Delete');
    RegisterMethod(@TXMLNodeListDelete1_P, 'Delete1');
    RegisterMethod(@TXMLNodeListDelete2_P, 'Delete2');
    RegisterMethod(@TXMLNodeList.EndUpdate, 'EndUpdate');
    RegisterMethod(@TXMLNodeList.First, 'First');
    RegisterMethod(@TXMLNodeListFindNode3_P, 'FindNode');
    RegisterMethod(@TXMLNodeListFindNode4_P, 'FindNode4');
    RegisterMethod(@TXMLNodeListFindNode5_P, 'FindNode5');
    RegisterMethod(@TXMLNodeList.FindSibling, 'FindSibling');
    RegisterMethod(@TXMLNodeList.Get, 'Get');
    RegisterMethod(@TXMLNodeList.GetCount, 'GetCount');
    RegisterMethod(@TXMLNodeList.GetNode, 'GetNode');
    RegisterMethod(@TXMLNodeList.GetUpdateCount, 'GetUpdateCount');
    RegisterMethod(@TXMLNodeListIndexOf6_P, 'IndexOf');
    RegisterMethod(@TXMLNodeListIndexOf7_P, 'IndexOf7');
    RegisterMethod(@TXMLNodeListIndexOf8_P, 'IndexOf8');
    RegisterMethod(@TXMLNodeList.Insert, 'Insert');
    RegisterMethod(@TXMLNodeList.Last, 'Last');
    RegisterMethod(@TXMLNodeList.Remove, 'Remove');
    RegisterMethod(@TXMLNodeList.ReplaceNode, 'ReplaceNode');
    RegisterPropertyHelper(@TXMLNodeListCount_R,nil,'Count');
    RegisterPropertyHelper(@TXMLNodeListUpdateCount_R,nil,'UpdateCount');
   // RegisterConstructor(@TXMLNodeList.Create, 'Create');


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
