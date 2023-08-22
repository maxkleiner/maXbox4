unit uPSI_xmldom;
{
    to ease access to dom   XML DOM 2.0 Interfaces                          }
{       Translated from dom.idl 

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
  TPSImport_xmldom = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;



 
{ compile-time registration functions }
procedure SIRegister_TDOMVendorList(CL: TPSPascalCompiler);
procedure SIRegister_TDOMVendor(CL: TPSPascalCompiler);
procedure SIRegister_IDOMXMLProlog(CL: TPSPascalCompiler);
procedure SIRegister_IDOMParseOptions(CL: TPSPascalCompiler);
procedure SIRegister_IDOMParseError(CL: TPSPascalCompiler);
procedure SIRegister_IDOMPersist(CL: TPSPascalCompiler);
procedure SIRegister_IDOMXSLProcessor(CL: TPSPascalCompiler);
procedure SIRegister_IDOMNodeSelect(CL: TPSPascalCompiler);
procedure SIRegister_IDOMNodeEx(CL: TPSPascalCompiler);
procedure SIRegister_IDOMDocument(CL: TPSPascalCompiler);
procedure SIRegister_IDOMDocumentFragment(CL: TPSPascalCompiler);
procedure SIRegister_IDOMProcessingInstruction(CL: TPSPascalCompiler);
procedure SIRegister_IDOMEntityReference(CL: TPSPascalCompiler);
procedure SIRegister_IDOMEntity(CL: TPSPascalCompiler);
procedure SIRegister_IDOMNotation(CL: TPSPascalCompiler);
procedure SIRegister_IDOMDocumentType(CL: TPSPascalCompiler);
procedure SIRegister_IDOMCDATASection(CL: TPSPascalCompiler);
procedure SIRegister_IDOMComment(CL: TPSPascalCompiler);
procedure SIRegister_IDOMText(CL: TPSPascalCompiler);
procedure SIRegister_IDOMElement(CL: TPSPascalCompiler);
procedure SIRegister_IDOMAttr(CL: TPSPascalCompiler);
procedure SIRegister_IDOMCharacterData(CL: TPSPascalCompiler);
procedure SIRegister_IDOMNamedNodeMap(CL: TPSPascalCompiler);
procedure SIRegister_IDOMNodeList(CL: TPSPascalCompiler);
procedure SIRegister_IDOMNode(CL: TPSPascalCompiler);
procedure SIRegister_IDOMImplementation(CL: TPSPascalCompiler);
procedure SIRegister_EDOMParseError(CL: TPSPascalCompiler);
procedure SIRegister_DOMException(CL: TPSPascalCompiler);
procedure SIRegister_xmldom(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xmldom_Routines(S: TPSExec);
procedure RIRegister_TDOMVendorList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMVendor(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMParseError(CL: TPSRuntimeClassImporter);
procedure RIRegister_DOMException(CL: TPSRuntimeClassImporter);
procedure RIRegister_xmldom(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ActiveX
  ,Types
  ,Variants
  ,XMLConst
  ,xmldom
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xmldom]);
end;


function SameNamespace2(const URI1, URI2: WideString): Boolean;
  begin
     result:= SameNamespace(URI1, URI2);
  end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMVendorList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDOMVendorList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMVendorList') do
  begin
    RegisterMethod('Procedure Add( const Vendor : TDOMVendor)');
    RegisterMethod('Function Count : Integer');
    RegisterMethod('Function Find( const VendorDesc : string) : TDOMVendor');
    RegisterMethod('Procedure Remove( const Vendor : TDOMVendor)');
    RegisterProperty('Vendors', 'TDOMVendor Integer', iptr);
    SetDefaultPropery('Vendors');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMVendor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDOMVendor') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMVendor') do
  begin
    RegisterMethod('Function Description : string');
    RegisterMethod('Function DOMImplementation : IDOMImplementation');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMXMLProlog(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDOMXMLProlog') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMXMLProlog, 'IDOMXMLProlog') do
  begin
    RegisterMethod('Function get_Encoding : DOMString', CdStdCall);
    RegisterMethod('Function get_Standalone : DOMString', CdStdCall);
    RegisterMethod('Function get_Version : DOMString', CdStdCall);
    RegisterMethod('Procedure set_Encoding( const Value : DOMString)', CdStdCall);
    RegisterMethod('Procedure set_Standalone( const Value : DOMString)', CdStdCall);
    RegisterMethod('Procedure set_Version( const Value : DOMString)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMParseOptions(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDOMParseOptions') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMParseOptions, 'IDOMParseOptions') do
  begin
    RegisterMethod('Function get_async : Boolean', CdStdCall);
    RegisterMethod('Function get_preserveWhiteSpace : Boolean', CdStdCall);
    RegisterMethod('Function get_resolveExternals : Boolean', CdStdCall);
    RegisterMethod('Function get_validate : Boolean', CdStdCall);
    RegisterMethod('Procedure set_async( Value : Boolean)', CdStdCall);
    RegisterMethod('Procedure set_preserveWhiteSpace( Value : Boolean)', CdStdCall);
    RegisterMethod('Procedure set_resolveExternals( Value : Boolean)', CdStdCall);
    RegisterMethod('Procedure set_validate( Value : Boolean)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMParseError(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDOMParseError') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMParseError, 'IDOMParseError') do
  begin
    RegisterMethod('Function get_errorCode : Integer', CdStdCall);
    RegisterMethod('Function get_url : DOMString', CdStdCall);
    RegisterMethod('Function get_reason : DOMString', CdStdCall);
    RegisterMethod('Function get_srcText : DOMString', CdStdCall);
    RegisterMethod('Function get_line : Integer', CdStdCall);
    RegisterMethod('Function get_linepos : Integer', CdStdCall);
    RegisterMethod('Function get_filepos : Integer', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMPersist(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDOMPersist') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMPersist, 'IDOMPersist') do
  begin
    RegisterMethod('Function get_xml : DOMString', CdStdCall);
    RegisterMethod('Function asyncLoadState : Integer', CdStdCall);
    RegisterMethod('Function load( source : OleVariant) : WordBool', CdStdCall);
    RegisterMethod('Function loadFromStream2( const stream : TStream) : WordBool;', CdStdCall);
    RegisterMethod('Function loadxml( const Value : DOMString) : WordBool', CdStdCall);
    RegisterMethod('Procedure save( destination : OleVariant)', CdStdCall);
    RegisterMethod('Procedure saveToStream3( const stream : TStream);', CdStdCall);
    RegisterMethod('Procedure set_OnAsyncLoad( const Sender : TObject; EventHandler : TAsyncEventHandler)', CdStdCall);
    RegisterMethod('Function loadFromStream4( const stream : IStream) : WordBool;', CdStdCall);
    RegisterMethod('Procedure saveToStream5( const stream : IStream);', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMXSLProcessor(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInterface', 'IDOMXSLProcessor') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IDOMXSLProcessor, 'IDOMXSLProcessor') do
  begin
    RegisterMethod('Function Get_input : OleVariant', CdStdCall);
    RegisterMethod('Function Get_output : OleVariant', CdStdCall);
    RegisterMethod('Function Get_stylesheet : IDOMNode', CdStdCall);
    RegisterMethod('Procedure Set_input( const value : OleVariant)', CdStdCall);
    RegisterMethod('Procedure Set_output( const value : OleVariant)', CdStdCall);
    RegisterMethod('Procedure setParameter( const Name : DOMString; Value : OleVariant; const namespaceURI : DOMString)', CdStdCall);
    RegisterMethod('Procedure reset', CdStdCall);
    RegisterMethod('Function transform : WordBool', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMNodeSelect(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInterface', 'IDOMNodeSelect') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IDOMNodeSelect, 'IDOMNodeSelect') do
  begin
    RegisterMethod('Function selectNode( const nodePath : WideString) : IDOMNode', CdStdCall);
    RegisterMethod('Function selectNodes( const nodePath : WideString) : IDOMNodeList', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMNodeEx(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMNode', 'IDOMNodeEx') do
  with CL.AddInterface(CL.FindInterface('IDOMNode'),IDOMNodeEx, 'IDOMNodeEx') do
  begin
    RegisterMethod('Function get_text : DOMString', CdStdCall);
    RegisterMethod('Function get_xml : DOMString', CdStdCall);
    RegisterMethod('Procedure set_text( const Value : DOMString)', CdStdCall);
    RegisterMethod('Procedure transformNode0( const stylesheet : IDOMNode; var output : WideString);', CdStdCall);
    RegisterMethod('Procedure transformNode1( const stylesheet : IDOMNode; const output : IDOMDocument);', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMDocument(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMNode', 'IDOMDocument') do
  with CL.AddInterface(CL.FindInterface('IDOMNode'),IDOMDocument, 'IDOMDocument') do
  begin
    RegisterMethod('Function get_doctype : IDOMDocumentType', CdStdCall);
    RegisterMethod('Function get_domImplementation : IDOMImplementation', CdStdCall);
    RegisterMethod('Function get_documentElement : IDOMElement', CdStdCall);
    RegisterMethod('Procedure set_documentElement( const Element : IDOMElement)', CdStdCall);
    RegisterMethod('Function createElement( const tagName : DOMString) : IDOMElement', CdStdCall);
    RegisterMethod('Function createDocumentFragment : IDOMDocumentFragment', CdStdCall);
    RegisterMethod('Function createTextNode( const data : DOMString) : IDOMText', CdStdCall);
    RegisterMethod('Function createComment( const data : DOMString) : IDOMComment', CdStdCall);
    RegisterMethod('Function createCDATASection( const data : DOMString) : IDOMCDATASection', CdStdCall);
    RegisterMethod('Function createProcessingInstruction( const target, data : DOMString) : IDOMProcessingInstruction', CdStdCall);
    RegisterMethod('Function createAttribute( const name : DOMString) : IDOMAttr', CdStdCall);
    RegisterMethod('Function createEntityReference( const name : DOMString) : IDOMEntityReference', CdStdCall);
    RegisterMethod('Function getElementsByTagName( const tagName : DOMString) : IDOMNodeList', CdStdCall);
    RegisterMethod('Function importNode( importedNode : IDOMNode; deep : WordBool) : IDOMNode', CdStdCall);
    RegisterMethod('Function createElementNS( const namespaceURI, qualifiedName : DOMString) : IDOMElement', CdStdCall);
    RegisterMethod('Function createAttributeNS( const namespaceURI, qualifiedName : DOMString) : IDOMAttr', CdStdCall);
    RegisterMethod('Function getElementsByTagNameNS( const namespaceURI, localName : DOMString) : IDOMNodeList', CdStdCall);
    RegisterMethod('Function getElementById( const elementId : DOMString) : IDOMElement', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMDocumentFragment(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMNode', 'IDOMDocumentFragment') do
  with CL.AddInterface(CL.FindInterface('IDOMNode'),IDOMDocumentFragment, 'IDOMDocumentFragment') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMProcessingInstruction(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMNode', 'IDOMProcessingInstruction') do
  with CL.AddInterface(CL.FindInterface('IDOMNode'),IDOMProcessingInstruction, 'IDOMProcessingInstruction') do
  begin
    RegisterMethod('Function get_target : DOMString', CdStdCall);
    RegisterMethod('Function get_data : DOMString', CdStdCall);
    RegisterMethod('Procedure set_data( const value : DOMString)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMEntityReference(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMNode', 'IDOMEntityReference') do
  with CL.AddInterface(CL.FindInterface('IDOMNode'),IDOMEntityReference, 'IDOMEntityReference') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMEntity(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMNode', 'IDOMEntity') do
  with CL.AddInterface(CL.FindInterface('IDOMNode'),IDOMEntity, 'IDOMEntity') do
  begin
    RegisterMethod('Function get_publicId : DOMString', CdStdCall);
    RegisterMethod('Function get_systemId : DOMString', CdStdCall);
    RegisterMethod('Function get_notationName : DOMString', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMNotation(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMNode', 'IDOMNotation') do
  with CL.AddInterface(CL.FindInterface('IDOMNode'),IDOMNotation, 'IDOMNotation') do
  begin
    RegisterMethod('Function get_publicId : DOMString', CdStdCall);
    RegisterMethod('Function get_systemId : DOMString', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMDocumentType(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMNode', 'IDOMDocumentType') do
  with CL.AddInterface(CL.FindInterface('IDOMNode'),IDOMDocumentType, 'IDOMDocumentType') do
  begin
    RegisterMethod('Function get_name : DOMString', CdStdCall);
    RegisterMethod('Function get_entities : IDOMNamedNodeMap', CdStdCall);
    RegisterMethod('Function get_notations : IDOMNamedNodeMap', CdStdCall);
    RegisterMethod('Function get_publicId : DOMString', CdStdCall);
    RegisterMethod('Function get_systemId : DOMString', CdStdCall);
    RegisterMethod('Function get_internalSubset : DOMString', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMCDATASection(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMText', 'IDOMCDATASection') do
  with CL.AddInterface(CL.FindInterface('IDOMText'),IDOMCDATASection, 'IDOMCDATASection') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMComment(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMCharacterData', 'IDOMComment') do
  with CL.AddInterface(CL.FindInterface('IDOMCharacterData'),IDOMComment, 'IDOMComment') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMText(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMCharacterData', 'IDOMText') do
  with CL.AddInterface(CL.FindInterface('IDOMCharacterData'),IDOMText, 'IDOMText') do
  begin
    RegisterMethod('Function splitText( offset : Integer) : IDOMText', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMElement(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMNode', 'IDOMElement') do
  with CL.AddInterface(CL.FindInterface('IDOMNode'),IDOMElement, 'IDOMElement') do
  begin
    RegisterMethod('Function get_tagName : DOMString', CdStdCall);
    RegisterMethod('Function getAttribute( const name : DOMString) : DOMString', CdStdCall);
    RegisterMethod('Procedure setAttribute( const name, value : DOMString)', CdStdCall);
    RegisterMethod('Procedure removeAttribute( const name : DOMString)', CdStdCall);
    RegisterMethod('Function getAttributeNode( const name : DOMString) : IDOMAttr', CdStdCall);
    RegisterMethod('Function setAttributeNode( const newAttr : IDOMAttr) : IDOMAttr', CdStdCall);
    RegisterMethod('Function removeAttributeNode( const oldAttr : IDOMAttr) : IDOMAttr', CdStdCall);
    RegisterMethod('Function getElementsByTagName( const name : DOMString) : IDOMNodeList', CdStdCall);
    RegisterMethod('Function getAttributeNS( const namespaceURI, localName : DOMString) : DOMString', CdStdCall);
    RegisterMethod('Procedure setAttributeNS( const namespaceURI, qulifiedName, value : DOMString)', CdStdCall);
    RegisterMethod('Procedure removeAttributeNS( const namespaceURI, localName : DOMString)', CdStdCall);
    RegisterMethod('Function getAttributeNodeNS( const namespaceURI, localName : DOMString) : IDOMAttr', CdStdCall);
    RegisterMethod('Function setAttributeNodeNS( const newAttr : IDOMAttr) : IDOMAttr', CdStdCall);
    RegisterMethod('Function getElementsByTagNameNS( const namespaceURI, localName : DOMString) : IDOMNodeList', CdStdCall);
    RegisterMethod('Function hasAttribute( const name : DOMString) : WordBool', CdStdCall);
    RegisterMethod('Function hasAttributeNS( const namespaceURI, localName : DOMString) : WordBool', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMAttr(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMNode', 'IDOMAttr') do
  with CL.AddInterface(CL.FindInterface('IDOMNode'),IDOMAttr, 'IDOMAttr') do
  begin
    RegisterMethod('Function get_name : DOMString', CdStdCall);
    RegisterMethod('Function get_specified : WordBool', CdStdCall);
    RegisterMethod('Function get_value : DOMString', CdStdCall);
    RegisterMethod('Procedure set_value( const attributeValue : DOMString)', CdStdCall);
    RegisterMethod('Function get_ownerElement : IDOMElement', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMCharacterData(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDOMNode', 'IDOMCharacterData') do
  with CL.AddInterface(CL.FindInterface('IDOMNode'),IDOMCharacterData, 'IDOMCharacterData') do
  begin
    RegisterMethod('Function get_data : DOMString', CdStdCall);
    RegisterMethod('Procedure set_data( const data : DOMString)', CdStdCall);
    RegisterMethod('Function get_length : Integer', CdStdCall);
    RegisterMethod('Function substringData( offset, count : Integer) : DOMString', CdStdCall);
    RegisterMethod('Procedure appendData( const data : DOMString)', CdStdCall);
    RegisterMethod('Procedure insertData( offset : Integer; const data : DOMString)', CdStdCall);
    RegisterMethod('Procedure deleteData( offset, count : Integer)', CdStdCall);
    RegisterMethod('Procedure replaceData( offset, count : Integer; const data : DOMString)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMNamedNodeMap(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDOMNamedNodeMap') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMNamedNodeMap, 'IDOMNamedNodeMap') do
  begin
    RegisterMethod('Function get_item( index : Integer) : IDOMNode', CdStdCall);
    RegisterMethod('Function get_length : Integer', CdStdCall);
    RegisterMethod('Function getNamedItem( const name : DOMString) : IDOMNode', CdStdCall);
    RegisterMethod('Function setNamedItem( const arg : IDOMNode) : IDOMNode', CdStdCall);
    RegisterMethod('Function removeNamedItem( const name : DOMString) : IDOMNode', CdStdCall);
    RegisterMethod('Function getNamedItemNS( const namespaceURI, localName : DOMString) : IDOMNode', CdStdCall);
    RegisterMethod('Function setNamedItemNS( const arg : IDOMNode) : IDOMNode', CdStdCall);
    RegisterMethod('Function removeNamedItemNS( const namespaceURI, localName : DOMString) : IDOMNode', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMNodeList(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDOMNodeList') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMNodeList, 'IDOMNodeList') do
  begin
    RegisterMethod('Function get_item( index : Integer) : IDOMNode', CdStdCall);
    RegisterMethod('Function get_length : Integer', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMNode(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInterface', 'IDOMNode') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IDOMNode, 'IDOMNode') do
  begin
    RegisterMethod('Function get_nodeName : DOMString', CdStdCall);
    RegisterMethod('Function get_nodeValue : DOMString', CdStdCall);
    RegisterMethod('Procedure set_nodeValue( value : DOMString)', CdStdCall);
    RegisterMethod('Function get_nodeType : DOMNodeType', CdStdCall);
    RegisterMethod('Function get_parentNode : IDOMNode', CdStdCall);
    RegisterMethod('Function get_childNodes : IDOMNodeList', CdStdCall);
    RegisterMethod('Function get_firstChild : IDOMNode', CdStdCall);
    RegisterMethod('Function get_lastChild : IDOMNode', CdStdCall);
    RegisterMethod('Function get_previousSibling : IDOMNode', CdStdCall);
    RegisterMethod('Function get_nextSibling : IDOMNode', CdStdCall);
    RegisterMethod('Function get_attributes : IDOMNamedNodeMap', CdStdCall);
    RegisterMethod('Function get_ownerDocument : IDOMDocument', CdStdCall);
    RegisterMethod('Function get_namespaceURI : DOMString', CdStdCall);
    RegisterMethod('Function get_prefix : DOMString', CdStdCall);
    RegisterMethod('Function get_localName : DOMString', CdStdCall);
    RegisterMethod('Function insertBefore( const newChild, refChild : IDOMNode) : IDOMNode', CdStdCall);
    RegisterMethod('Function replaceChild( const newChild, oldChild : IDOMNode) : IDOMNode', CdStdCall);
    RegisterMethod('Function removeChild( const childNode : IDOMNode) : IDOMNode', CdStdCall);
    RegisterMethod('Function appendChild( const newChild : IDOMNode) : IDOMNode', CdStdCall);
    RegisterMethod('Function hasChildNodes : WordBool', CdStdCall);
    RegisterMethod('Function cloneNode( deep : WordBool) : IDOMNode', CdStdCall);
    RegisterMethod('Procedure normalize', CdStdCall);
    RegisterMethod('Function supports( const feature, version : DOMString) : WordBool', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDOMImplementation(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDOMImplementation') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMImplementation, 'IDOMImplementation') do
  begin
    RegisterMethod('Function hasFeature( const feature, version : DOMString) : WordBool', cdRegister);
    RegisterMethod('Function createDocumentType( const qualifiedName, publicId, systemId : DOMString) : IDOMDocumentType', CdStdCall);
    RegisterMethod('Function createDocument( const namespaceURI, qualifiedName : DOMString; doctype : IDOMDocumentType) : IDOMDocument', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMParseError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EDOMParseError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EDOMParseError') do
  begin
    RegisterMethod('Constructor Create( const ParseError : IDOMParseError; const Msg : string)');
    RegisterProperty('ErrorCode', 'Integer', iptr);
    RegisterProperty('URL', 'DOMString', iptr);
    RegisterProperty('Reason', 'DOMString', iptr);
    RegisterProperty('SrcText', 'DOMString', iptr);
    RegisterProperty('Line', 'Integer', iptr);
    RegisterProperty('LinePos', 'Integer', iptr);
    RegisterProperty('FilePos', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DOMException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'DOMException') do
  with CL.AddClassN(CL.FindClass('Exception'),'DOMException') do
  begin
    RegisterProperty('code', 'Word', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xmldom(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DOMWrapperVersion','Extended').setExtended( 1.2);
 CL.AddConstantN('ELEMENT_NODE','LongInt').SetInt( 1);
 CL.AddConstantN('ATTRIBUTE_NODE','LongInt').SetInt( 2);
 CL.AddConstantN('TEXT_NODE','LongInt').SetInt( 3);
 CL.AddConstantN('CDATA_SECTION_NODE','LongInt').SetInt( 4);
 CL.AddConstantN('ENTITY_REFERENCE_NODE','LongInt').SetInt( 5);
 CL.AddConstantN('ENTITY_NODE','LongInt').SetInt( 6);
 CL.AddConstantN('PROCESSING_INSTRUCTION_NODE','LongInt').SetInt( 7);
 CL.AddConstantN('COMMENT_NODE','LongInt').SetInt( 8);
 CL.AddConstantN('DOCUMENT_NODE','LongInt').SetInt( 9);
 CL.AddConstantN('DOCUMENT_TYPE_NODE','LongInt').SetInt( 10);
 CL.AddConstantN('DOCUMENT_FRAGMENT_NODE','LongInt').SetInt( 11);
 CL.AddConstantN('NOTATION_NODE','LongInt').SetInt( 12);
 CL.AddConstantN('INDEX_SIZE_ERR','LongInt').SetInt( 1);
 CL.AddConstantN('DOMSTRING_SIZE_ERR','LongInt').SetInt( 2);
 CL.AddConstantN('HIERARCHY_REQUEST_ERR','LongInt').SetInt( 3);
 CL.AddConstantN('WRONG_DOCUMENT_ERR','LongInt').SetInt( 4);
 CL.AddConstantN('INVALID_CHARACTER_ERR','LongInt').SetInt( 5);
 CL.AddConstantN('NO_DATA_ALLOWED_ERR','LongInt').SetInt( 6);
 CL.AddConstantN('NO_MODIFICATION_ALLOWED_ERR','LongInt').SetInt( 7);
 CL.AddConstantN('NOT_FOUND_ERR','LongInt').SetInt( 8);
 CL.AddConstantN('NOT_SUPPORTED_ERR','LongInt').SetInt( 9);
 CL.AddConstantN('INUSE_ATTRIBUTE_ERR','LongInt').SetInt( 10);
 CL.AddConstantN('INVALID_STATE_ERR','LongInt').SetInt( 11);
 CL.AddConstantN('SYNTAX_ERR','LongInt').SetInt( 12);
 CL.AddConstantN('INVALID_MODIFICATION_ERR','LongInt').SetInt( 13);
 CL.AddConstantN('NAMESPACE_ERR','LongInt').SetInt( 14);
 CL.AddConstantN('INVALID_ACCESS_ERR','LongInt').SetInt( 15);
 CL.AddConstantN('NSDelim','String').SetString( ':');
 CL.AddConstantN('SXML','String').SetString( 'xml');
 CL.AddConstantN('SVersion','String').SetString( 'version');
 CL.AddConstantN('SEncoding','String').SetString( 'encoding');
 CL.AddConstantN('SStandalone','String').SetString( 'standalone');
 CL.AddConstantN('SXMLNS','String').SetString( 'xmlns');
 CL.AddConstantN('SHttp','String').SetString( 'http:/');
 CL.AddConstantN('SXMLNamespaceURI','String').SetString( SHttp + '/www.w3.org/2000/xmlns/');
 CL.AddConstantN('SXMLPrefixNamespaceURI','String').SetString( SHttp + '/www.w3.org/XML/1998/namespace');
  CL.AddTypeS('DOMNodeType', 'Word');
  CL.AddTypeS('DOMStringW', 'WideString');
  CL.AddTypeS('DOMTimeStamp', 'Int64');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMImplementation, 'IDOMImplementation');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMNode, 'IDOMNode');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMNodeList, 'IDOMNodeList');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMNamedNodeMap, 'IDOMNamedNodeMap');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMCharacterData, 'IDOMCharacterData');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMAttr, 'IDOMAttr');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMElement, 'IDOMElement');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMText, 'IDOMText');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMComment, 'IDOMComment');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMCDATASection, 'IDOMCDATASection');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMDocumentType, 'IDOMDocumentType');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMNotation, 'IDOMNotation');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMEntity, 'IDOMEntity');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMEntityReference, 'IDOMEntityReference');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMProcessingInstruction, 'IDOMProcessingInstruction');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMDocumentFragment, 'IDOMDocumentFragment');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMDocument, 'IDOMDocument');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMNodeEx, 'IDOMNodeEx');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMPersist, 'IDOMPersist');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMParseError, 'IDOMParseError');
  SIRegister_DOMException(CL);
  SIRegister_EDOMParseError(CL);
  SIRegister_IDOMImplementation(CL);
  SIRegister_IDOMNode(CL);
  SIRegister_IDOMNodeList(CL);
  SIRegister_IDOMNamedNodeMap(CL);
  SIRegister_IDOMCharacterData(CL);
  SIRegister_IDOMAttr(CL);
  SIRegister_IDOMElement(CL);
  SIRegister_IDOMText(CL);
  SIRegister_IDOMComment(CL);
  SIRegister_IDOMCDATASection(CL);
  SIRegister_IDOMDocumentType(CL);
  SIRegister_IDOMNotation(CL);
  SIRegister_IDOMEntity(CL);
  SIRegister_IDOMEntityReference(CL);
  SIRegister_IDOMProcessingInstruction(CL);
  SIRegister_IDOMDocumentFragment(CL);
  SIRegister_IDOMDocument(CL);
  SIRegister_IDOMNodeEx(CL);
  SIRegister_IDOMNodeSelect(CL);
  SIRegister_IDOMXSLProcessor(CL);
  CL.AddTypeS('TAsyncEventHandler', 'Procedure ( Sender : TObject; AsyncLoadState : Integer)');
  SIRegister_IDOMPersist(CL);
  SIRegister_IDOMParseError(CL);
  SIRegister_IDOMParseOptions(CL);
  SIRegister_IDOMXMLProlog(CL);
  SIRegister_TDOMVendor(CL);
  CL.AddTypeS('TDOMVendorArray', 'array of TDOMVendor');
  SIRegister_TDOMVendorList(CL);
 CL.AddDelphiFunction('Function IsPrefixed( const AName : DOMString) : Boolean');
 CL.AddDelphiFunction('Function IsPrefixedW( const AName : DOMStringW) : Boolean');

 CL.AddDelphiFunction('Function ExtractLocalName( const AName : DOMString) : DOMString');
 CL.AddDelphiFunction('Function ExtractLocalNameW( const AName : DOMStringW) : DOMStringW');
 CL.AddDelphiFunction('Function ExtractPrefixW( const AName : DOMStringW) : DOMStringW');
 CL.AddDelphiFunction('Function MakeNodeNameW( const Prefix, LocalName : DOMStringW) : DOMStringW');
 CL.AddDelphiFunction('Function ExtractPrefix( const AName : DOMString) : DOMString');
 CL.AddDelphiFunction('Function MakeNodeName( const Prefix, LocalName : DOMString) : DOMString');
 CL.AddDelphiFunction('Function SameNamespace( const Node : IDOMNode; const namespaceURI : WideString) : Boolean;');
 CL.AddDelphiFunction('Function SameNamespace2( const URI1, URI2 : WideString) : Boolean;');
 CL.AddDelphiFunction('Function NodeMatches( const Node : IDOMNode; const TagName, NamespaceURI : DOMString) : Boolean;');
 CL.AddDelphiFunction('Function GetDOMNodeEx( const Node : IDOMNode) : IDOMNodeEx');
 CL.AddDelphiFunction('Procedure RegisterDOMVendor( const Vendor : TDOMVendor)');
 CL.AddDelphiFunction('Procedure UnRegisterDOMVendor( const Vendor : TDOMVendor)');
 CL.AddDelphiFunction('Function GetDOMVendor( VendorDesc : string) : TDOMVendor');
 CL.AddDelphiFunction('Function GetDOM( const VendorDesc : string) : IDOMImplementation');
 CL.AddDelphiFunction('Procedure DOMVendorNotSupported( const PropOrMethod, VendorName : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function NodeMatches8_P( const Node : IDOMNode; const TagName, NamespaceURI : DOMString) : Boolean;
Begin Result := xmldom.NodeMatches(Node, TagName, NamespaceURI); END;

(*----------------------------------------------------------------------------*)
Function SameNamespace7_P( const URI1, URI2 : WideString) : Boolean;
Begin Result := xmldom.SameNamespace(URI1, URI2); END;

(*----------------------------------------------------------------------------*)
Function SameNamespace6_P( const Node : IDOMNode; const namespaceURI : WideString) : Boolean;
Begin Result := xmldom.SameNamespace(Node, namespaceURI); END;

(*----------------------------------------------------------------------------*)
procedure TDOMVendorListVendors_R(Self: TDOMVendorList; var T: TDOMVendor; const t1: Integer);
begin T := Self.Vendors[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure IDOMPersistsaveToStream5_P(Self: IDOMPersist;  const stream : IStream);
Begin Self.saveToStream(stream); END;

(*----------------------------------------------------------------------------*)
Function IDOMPersistloadFromStream4_P(Self: IDOMPersist;  const stream : IStream) : WordBool;
Begin Result := Self.loadFromStream(stream); END;

(*----------------------------------------------------------------------------*)
Procedure IDOMPersistsaveToStream3_P(Self: IDOMPersist;  const stream : TStream);
Begin Self.saveToStream(stream); END;

(*----------------------------------------------------------------------------*)
Function IDOMPersistloadFromStream2_P(Self: IDOMPersist;  const stream : TStream) : WordBool;
Begin Result := Self.loadFromStream(stream); END;

(*----------------------------------------------------------------------------*)
Procedure IDOMNodeExtransformNode1_P(Self: IDOMNodeEx;  const stylesheet : IDOMNode; const output : IDOMDocument);
Begin Self.transformNode(stylesheet, output); END;

(*----------------------------------------------------------------------------*)
Procedure IDOMNodeExtransformNode0_P(Self: IDOMNodeEx;  const stylesheet : IDOMNode; var output : WideString);
Begin Self.transformNode(stylesheet, output); END;

(*----------------------------------------------------------------------------*)
procedure EDOMParseErrorFilePos_R(Self: EDOMParseError; var T: Integer);
begin T := Self.FilePos; end;

(*----------------------------------------------------------------------------*)
procedure EDOMParseErrorLinePos_R(Self: EDOMParseError; var T: Integer);
begin T := Self.LinePos; end;

(*----------------------------------------------------------------------------*)
procedure EDOMParseErrorLine_R(Self: EDOMParseError; var T: Integer);
begin T := Self.Line; end;

(*----------------------------------------------------------------------------*)
procedure EDOMParseErrorSrcText_R(Self: EDOMParseError; var T: DOMString);
begin T := Self.SrcText; end;

(*----------------------------------------------------------------------------*)
procedure EDOMParseErrorReason_R(Self: EDOMParseError; var T: DOMString);
begin T := Self.Reason; end;

(*----------------------------------------------------------------------------*)
procedure EDOMParseErrorURL_R(Self: EDOMParseError; var T: DOMString);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure EDOMParseErrorErrorCode_R(Self: EDOMParseError; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure DOMExceptioncode_W(Self: DOMException; const T: Word);
Begin Self.code := T; end;

(*----------------------------------------------------------------------------*)
procedure DOMExceptioncode_R(Self: DOMException; var T: Word);
Begin T := Self.code; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xmldom_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsPrefixed, 'IsPrefixed', cdRegister);
 S.RegisterDelphiFunction(@ExtractLocalName, 'ExtractLocalName', cdRegister);
 S.RegisterDelphiFunction(@ExtractPrefix, 'ExtractPrefix', cdRegister);
 S.RegisterDelphiFunction(@MakeNodeName, 'MakeNodeName', cdRegister);
 S.RegisterDelphiFunction(@IsPrefixed, 'IsPrefixedW', cdRegister);
 S.RegisterDelphiFunction(@ExtractLocalName, 'ExtractLocalNameW', cdRegister);
 S.RegisterDelphiFunction(@ExtractPrefix, 'ExtractPrefixW', cdRegister);
 S.RegisterDelphiFunction(@MakeNodeName, 'MakeNodeNameW', cdRegister);

 S.RegisterDelphiFunction(@SameNamespace, 'SameNamespace', cdRegister);
 S.RegisterDelphiFunction(@SameNamespace2, 'SameNamespace2', cdRegister);
 S.RegisterDelphiFunction(@NodeMatches, 'NodeMatches', cdRegister);
 S.RegisterDelphiFunction(@GetDOMNodeEx, 'GetDOMNodeEx', cdRegister);
 S.RegisterDelphiFunction(@RegisterDOMVendor, 'RegisterDOMVendor', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterDOMVendor, 'UnRegisterDOMVendor', cdRegister);
 S.RegisterDelphiFunction(@GetDOMVendor, 'GetDOMVendor', cdRegister);
 S.RegisterDelphiFunction(@GetDOM, 'GetDOM', cdRegister);
 S.RegisterDelphiFunction(@DOMVendorNotSupported, 'DOMVendorNotSupported', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMVendorList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMVendorList) do
  begin
    RegisterMethod(@TDOMVendorList.Add, 'Add');
    RegisterMethod(@TDOMVendorList.Count, 'Count');
    RegisterMethod(@TDOMVendorList.Find, 'Find');
    RegisterMethod(@TDOMVendorList.Remove, 'Remove');
    RegisterPropertyHelper(@TDOMVendorListVendors_R,nil,'Vendors');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMVendor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMVendor) do
  begin
    //RegisterVirtualAbstractMethod(@TDOMVendor, @!.Description, 'Description');
    //RegisterVirtualAbstractMethod(@TDOMVendor, @!.DOMImplementation, 'DOMImplementation');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMParseError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMParseError) do
  begin
    RegisterConstructor(@EDOMParseError.Create, 'Create');
    RegisterPropertyHelper(@EDOMParseErrorErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@EDOMParseErrorURL_R,nil,'URL');
    RegisterPropertyHelper(@EDOMParseErrorReason_R,nil,'Reason');
    RegisterPropertyHelper(@EDOMParseErrorSrcText_R,nil,'SrcText');
    RegisterPropertyHelper(@EDOMParseErrorLine_R,nil,'Line');
    RegisterPropertyHelper(@EDOMParseErrorLinePos_R,nil,'LinePos');
    RegisterPropertyHelper(@EDOMParseErrorFilePos_R,nil,'FilePos');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DOMException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(DOMException) do
  begin
    RegisterPropertyHelper(@DOMExceptioncode_R,@DOMExceptioncode_W,'code');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xmldom(CL: TPSRuntimeClassImporter);
begin
  RIRegister_DOMException(CL);
  RIRegister_EDOMParseError(CL);
  RIRegister_TDOMVendor(CL);
  RIRegister_TDOMVendorList(CL);
end;

 
 
{ TPSImport_xmldom }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xmldom.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xmldom(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xmldom.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xmldom(ri);
  RIRegister_xmldom_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
