unit uPSI_Laz_DOM;
{
   of lazarus for DOM intface - must change in case of xml^doc  TXMLDocument--> TXMLDocumentDOM
}
interface

uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler; //,  Laz_DOM;

type
(*----------------------------------------------------------------------------*)
  TPSImport_Laz_DOM = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TDOMProcessingInstruction(CL: TPSPascalCompiler);
procedure SIRegister_TDOMEntityReference(CL: TPSPascalCompiler);
procedure SIRegister_TDOMEntity(CL: TPSPascalCompiler);
procedure SIRegister_TDOMNotation(CL: TPSPascalCompiler);
procedure SIRegister_TDOMDocumentType(CL: TPSPascalCompiler);
procedure SIRegister_TDOMCDATASection(CL: TPSPascalCompiler);
procedure SIRegister_TDOMComment(CL: TPSPascalCompiler);
procedure SIRegister_TDOMText(CL: TPSPascalCompiler);
procedure SIRegister_TDOMElement(CL: TPSPascalCompiler);
procedure SIRegister_TDOMAttr(CL: TPSPascalCompiler);
procedure SIRegister_TXMLDocumentDOM(CL: TPSPascalCompiler);
procedure SIRegister_TDOMDocument(CL: TPSPascalCompiler);
procedure SIRegister_TDOMDocumentFragment(CL: TPSPascalCompiler);
procedure SIRegister_TDOMImplementation(CL: TPSPascalCompiler);
procedure SIRegister_TDOMCharacterData(CL: TPSPascalCompiler);
procedure SIRegister_TDOMNamedNodeMap(CL: TPSPascalCompiler);
procedure SIRegister_TDOMNodeList(CL: TPSPascalCompiler);
procedure SIRegister_TDOMNode_WithChildren(CL: TPSPascalCompiler);
procedure SIRegister_TDOMNode(CL: TPSPascalCompiler);
procedure SIRegister_TRefClass(CL: TPSPascalCompiler);
procedure SIRegister_EDOMInvalidAccess(CL: TPSPascalCompiler);
procedure SIRegister_EDOMNamespace(CL: TPSPascalCompiler);
procedure SIRegister_EDOMInvalidModification(CL: TPSPascalCompiler);
procedure SIRegister_EDOMSyntax(CL: TPSPascalCompiler);
procedure SIRegister_EDOMInvalidState(CL: TPSPascalCompiler);
procedure SIRegister_EDOMInUseAttribute(CL: TPSPascalCompiler);
procedure SIRegister_EDOMNotSupported(CL: TPSPascalCompiler);
procedure SIRegister_EDOMNotFound(CL: TPSPascalCompiler);
procedure SIRegister_EDOMWrongDocument(CL: TPSPascalCompiler);
procedure SIRegister_EDOMHierarchyRequest(CL: TPSPascalCompiler);
procedure SIRegister_EDOMIndexSize(CL: TPSPascalCompiler);
procedure SIRegister_EDOMError(CL: TPSPascalCompiler);
procedure SIRegister_Laz_DOM(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDOMProcessingInstruction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMEntityReference(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMEntity(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMNotation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMDocumentType(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMCDATASection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMComment(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMText(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMElement(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMAttr(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXMLDocumentDOM(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMDocument(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMDocumentFragment(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMImplementation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMCharacterData(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMNamedNodeMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMNodeList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMNode_WithChildren(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDOMNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRefClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMInvalidAccess(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMNamespace(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMInvalidModification(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMSyntax(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMInvalidState(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMInUseAttribute(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMNotSupported(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMNotFound(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMWrongDocument(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMHierarchyRequest(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMIndexSize(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDOMError(CL: TPSRuntimeClassImporter);
procedure RIRegister_Laz_DOM(CL: TPSRuntimeClassImporter);

//procedure WriteXMLFile(doc: TXMLDocumentDOM; const AFileName: String);
//procedure WriteXML(Element: TDOMNode; const AFileName: String);



procedure Register;

implementation


uses
   //MemCheck
  Avl_Tree,  Laz_DOM; //XMLIntf, xmldom, xmldoc;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Laz_DOM]);
end;


//type IDOMPersist = interface;

(*procedure WriteXMLFileStream(ADoc : TXMLDocumentDOM; AStream : TStream);
var adoc2:  TXMLDocument;
begin
    //adoc2.Assign(adoc);
    adoc2.NodeIndentStr:=   Adoc.NodeValue;
 // TXMLDocumentDOM((ADoc as IDOMPersist)).saveToStream(AStream);
  //IDOMPersist(ADoc).saveToStream(AStream);
  //((ADoc as IDOMPersist)).saveToStream(AStream);
  ((ADoc2 as IDOMPersist)).saveToStream(AStream);
 // IDOMPersist.saveToStream(AStream);

end;


procedure WriteXMLFile(doc: TXMLDocumentDOM; const AFileName: String);
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(AFileName, fmCreate);
  try
   // WriteXMLFile(doc, fs);
    WriteXMLFileStream(doc,fs);

  finally
    fs.Free;
  end;
end;


procedure WriteXML(Element: TDOMNode; const AFileName: String);
begin
  WriteXMLFile(TXMLDocumentDOM(Element), AFileName);
end;

function CreateDoc() : TXMLDocument ;
var
  locDoc : IXMLDocument;
begin
  locDoc := XmlDoc.TXMLDocument.Create(nil);
  locDoc.Active := True;
  //Result := locDoc.DOMDocument;
end;


procedure ReadXMLFileStream(out ADoc : TXMLDocument; AStream : TStream);
begin
  ADoc := CreateDoc();
  (ADoc as IDOMPersist).loadFromStream(AStream);
end;

function ReadXMLFileS(AStream : TStream) : TXMLDocument;
begin
  ReadXMLFileStream(Result,AStream);
end;

procedure ReadXMLFile2(out ADoc: TXMLDocument; const AFilename: String);
var
  FileStream: TStream;
begin
  ADoc := nil;
  FileStream := TFileStream.Create(AFilename, fmOpenRead+fmShareDenyWrite);
  try
    ReadXMLFileStream(ADoc, FileStream);
  finally
    FileStream.Free;
  end;
end;

function ReadXMLFile(const AFilename: String) :  TXMLDocument;
begin
  ReadXMLFile2(Result, AFilename);
end;      *)



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMProcessingInstruction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMNode', 'TDOMProcessingInstruction') do
  with CL.AddClassN(CL.FindClass('TDOMNode'),'TDOMProcessingInstruction') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
    RegisterProperty('Target', 'DOMString', iptr);
    RegisterProperty('Data', 'DOMString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMEntityReference(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMNode_WithChildren', 'TDOMEntityReference') do
  with CL.AddClassN(CL.FindClass('TDOMNode_WithChildren'),'TDOMEntityReference') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMEntity(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMNode_WithChildren', 'TDOMEntity') do
  with CL.AddClassN(CL.FindClass('TDOMNode_WithChildren'),'TDOMEntity') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
    RegisterProperty('PublicID', 'DOMString', iptr);
    RegisterProperty('SystemID', 'DOMString', iptr);
    RegisterProperty('NotationName', 'DOMString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMNotation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMNode', 'TDOMNotation') do
  with CL.AddClassN(CL.FindClass('TDOMNode'),'TDOMNotation') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
    RegisterMethod('Function CloneNode( deep : Boolean; ACloneOwner : TDOMDocument) : TDOMNode');
    RegisterProperty('PublicID', 'DOMString', iptr);
    RegisterProperty('SystemID', 'DOMString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMDocumentType(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMNode', 'TDOMDocumentType') do
  with CL.AddClassN(CL.FindClass('TDOMNode'),'TDOMDocumentType') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
    RegisterMethod('Function CloneNode( deep : Boolean; ACloneOwner : TDOMDocument) : TDOMNode');
    RegisterProperty('Name', 'DOMString', iptr);
    RegisterProperty('Entities', 'TDOMNamedNodeMap', iptr);
    RegisterProperty('Notations', 'TDOMNamedNodeMap', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMCDATASection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMText', 'TDOMCDATASection') do
  with CL.AddClassN(CL.FindClass('TDOMText'),'TDOMCDATASection') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
    RegisterMethod('Function CloneNode( deep : Boolean; ACloneOwner : TDOMDocument) : TDOMNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMComment(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMCharacterData', 'TDOMComment') do
  with CL.AddClassN(CL.FindClass('TDOMCharacterData'),'TDOMComment') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
    RegisterMethod('Function CloneNode( deep : Boolean; ACloneOwner : TDOMDocument) : TDOMNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMText(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMCharacterData', 'TDOMText') do
  with CL.AddClassN(CL.FindClass('TDOMCharacterData'),'TDOMText') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
    RegisterMethod('Function CloneNode( deep : Boolean; ACloneOwner : TDOMDocument) : TDOMNode');
    RegisterMethod('Function SplitText( offset : LongWord) : TDOMText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMElement(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMNode_WithChildren', 'TDOMElement') do
  with CL.AddClassN(CL.FindClass('TDOMNode_WithChildren'),'TDOMElement') do begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function CloneNode( deep : Boolean; ACloneOwner : TDOMDocument) : TDOMNode');
    RegisterProperty('TagName', 'DOMString', iptr);
    RegisterMethod('Function GetAttribute( const name : DOMString) : DOMString');
    RegisterMethod('Procedure SetAttribute( const name, value : DOMString)');
    RegisterMethod('Procedure RemoveAttribute( const name : DOMString)');
    RegisterMethod('Function GetAttributeNode( const name : DOMString) : TDOMAttr');
    RegisterMethod('Procedure SetAttributeNode( NewAttr : TDOMAttr)');
    RegisterMethod('Function RemoveAttributeNode( OldAttr : TDOMAttr) : TDOMAttr');
    RegisterMethod('Function GetElementsByTagName( const name : DOMString) : TDOMNodeList');
    RegisterMethod('Function IsEmpty : Boolean');
    RegisterMethod('Procedure Normalize');
    RegisterProperty('AttribStrings', 'DOMString DOMString', iptrw);
    SetDefaultPropery('AttribStrings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMAttr(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMNode_WithChildren', 'TDOMAttr') do
  with CL.AddClassN(CL.FindClass('TDOMNode_WithChildren'),'TDOMAttr') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
    RegisterMethod('Function CloneNode( deep : Boolean; ACloneOwner : TDOMDocument) : TDOMNode');
    RegisterProperty('Name', 'DOMString', iptr);
    RegisterProperty('Specified', 'Boolean', iptr);
    RegisterProperty('Value', 'DOMString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLDocumentDOM(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMDocument', 'TXMLDocument') do
  with CL.AddClassN(CL.FindClass('TDOMDocument'),'TXMLDocumentDOM') do
  begin
    RegisterProperty('XMLVersion', 'DOMString', iptrw);
    RegisterProperty('Encoding', 'DOMString', iptrw);
    RegisterProperty('StylesheetType', 'DOMString', iptrw);
    RegisterProperty('StylesheetHRef', 'DOMString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMDocument(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMNode_WithChildren', 'TDOMDocument') do
  with CL.AddClassN(CL.FindClass('TDOMNode_WithChildren'),'TDOMDocument') do
  begin
    RegisterProperty('DocType', 'TDOMDocumentType', iptr);
    RegisterProperty('Impl', 'TDOMImplementation', iptr);
    RegisterProperty('DocumentElement', 'TDOMElement', iptr);
    RegisterMethod('Function CreateElement( const tagName : DOMString) : TDOMElement');
    RegisterMethod('Function CreateDocumentFragment : TDOMDocumentFragment');
    RegisterMethod('Function CreateTextNode( const data : DOMString) : TDOMText');
    RegisterMethod('Function CreateComment( const data : DOMString) : TDOMComment');
    RegisterMethod('Function CreateCDATASection( const data : DOMString) : TDOMCDATASection');
    RegisterMethod('Function CreateProcessingInstruction( const target, data : DOMString) : TDOMProcessingInstruction');
    RegisterMethod('Function CreateAttribute( const name : DOMString) : TDOMAttr');
    RegisterMethod('Function CreateEntityReference( const name : DOMString) : TDOMEntityReference');
    RegisterMethod('Function GetElementsByTagName( const tagname : DOMString) : TDOMNodeList');
    RegisterMethod('Constructor Create');
    RegisterMethod('Function CreateEntity( const data : DOMString) : TDOMEntity');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMDocumentFragment(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMNode_WithChildren', 'TDOMDocumentFragment') do
  with CL.AddClassN(CL.FindClass('TDOMNode_WithChildren'),'TDOMDocumentFragment') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMImplementation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDOMImplementation') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMImplementation') do
  begin
    RegisterMethod('Function HasFeature( const feature, version : DOMString) : Boolean');
    RegisterMethod('Function CreateDocumentType( const QualifiedName, PublicID, SystemID : DOMString) : TDOMDocumentType');
    RegisterMethod('Function CreateDocument( const NamespaceURI, QualifiedName : DOMString; doctype : TDOMDocumentType) : TDOMDocument');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMCharacterData(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMNode', 'TDOMCharacterData') do
  with CL.AddClassN(CL.FindClass('TDOMNode'),'TDOMCharacterData') do
  begin
    RegisterProperty('Data', 'DOMString', iptr);
    RegisterProperty('Length', 'LongInt', iptr);
    RegisterMethod('Function SubstringData( offset, count : LongWord) : DOMString');
    RegisterMethod('Procedure AppendData( const arg : DOMString)');
    RegisterMethod('Procedure InsertData( offset : LongWord; const arg : DOMString)');
    RegisterMethod('Procedure DeleteData( offset, count : LongWord)');
    RegisterMethod('Procedure ReplaceData( offset, count : LongWord; const arg : DOMString)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMNamedNodeMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFPList', 'TDOMNamedNodeMap') do
  with CL.AddClassN(CL.FindClass('TFPList'),'TDOMNamedNodeMap') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
    RegisterMethod('Function GetNamedItem( const name : DOMString) : TDOMNode');
    RegisterMethod('Function SetNamedItem( arg : TDOMNode) : TDOMNode');
    RegisterMethod('Function RemoveNamedItem( const name : DOMString) : TDOMNode');
    RegisterProperty('Item', 'TDOMNode LongWord', iptrw);
    SetDefaultPropery('Item');
    RegisterProperty('Length', 'LongInt', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMNodeList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRefClass', 'TDOMNodeList') do
  with CL.AddClassN(CL.FindClass('TRefClass'),'TDOMNodeList') do
  begin
    RegisterMethod('Constructor Create( ANode : TDOMNode; const AFilter : DOMString)');
    RegisterProperty('Item', 'TDOMNode LongWord', iptr);
    RegisterProperty('Count', 'LongInt', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMNode_WithChildren(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMNode', 'TDOMNode_WithChildren') do
  with CL.AddClassN(CL.FindClass('TDOMNode'),'TDOMNode_WithChildren') do begin
        RegisterMethod('Procedure Free');
    RegisterMethod('Function InsertBefore( NewChild, RefChild : TDOMNode) : TDOMNode');
    RegisterMethod('Function ReplaceChild( NewChild, OldChild : TDOMNode) : TDOMNode');
    RegisterMethod('Function RemoveChild( OldChild : TDOMNode) : TDOMNode');
    RegisterMethod('Function AppendChild( NewChild : TDOMNode) : TDOMNode');
    RegisterMethod('Function HasChildNodes : Boolean');
    RegisterMethod('Function FindNode( const ANodeName : DOMString) : TDOMNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDOMNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDOMNode') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMNode') do
  begin
    RegisterMethod('Constructor Create( AOwner : TDOMDocument)');
    RegisterMethod('Function GetChildNodes : TDOMNodeList');
    RegisterProperty('NodeName', 'DOMString', iptr);
    RegisterProperty('NodeValue', 'DOMString', iptrw);
    RegisterProperty('NodeType', 'Integer', iptr);
    RegisterProperty('ParentNode', 'TDOMNode', iptr);
    RegisterProperty('FirstChild', 'TDOMNode', iptr);
    RegisterProperty('LastChild', 'TDOMNode', iptr);
    RegisterProperty('ChildNodes', 'TDOMNodeList', iptr);
    RegisterProperty('PreviousSibling', 'TDOMNode', iptr);
    RegisterProperty('NextSibling', 'TDOMNode', iptr);
    RegisterProperty('Attributes', 'TDOMNamedNodeMap', iptr);
    RegisterProperty('OwnerDocument', 'TDOMDocument', iptr);
    RegisterMethod('Function InsertBefore( NewChild, RefChild : TDOMNode) : TDOMNode');
    RegisterMethod('Function ReplaceChild( NewChild, OldChild : TDOMNode) : TDOMNode');
    RegisterMethod('Function RemoveChild( OldChild : TDOMNode) : TDOMNode');
    RegisterMethod('Function AppendChild( NewChild : TDOMNode) : TDOMNode');
    RegisterMethod('Function HasChildNodes : Boolean');
    RegisterMethod('Function CloneNode( deep : Boolean) : TDOMNode;');
    RegisterMethod('Function CloneNode1( deep : Boolean; ACloneOwner : TDOMDocument) : TDOMNode;');
    RegisterMethod('Function FindNode( const ANodeName : DOMString) : TDOMNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRefClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TRefClass') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TRefClass') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function AddRef : LongInt');
    RegisterMethod('Function Release : LongInt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMInvalidAccess(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDOMError', 'EDOMInvalidAccess') do
  with CL.AddClassN(CL.FindClass('EDOMError'),'EDOMInvalidAccess') do
  begin
    RegisterMethod('Constructor Create( const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMNamespace(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDOMError', 'EDOMNamespace') do
  with CL.AddClassN(CL.FindClass('EDOMError'),'EDOMNamespace') do
  begin
    RegisterMethod('Constructor Create( const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMInvalidModification(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDOMError', 'EDOMInvalidModification') do
  with CL.AddClassN(CL.FindClass('EDOMError'),'EDOMInvalidModification') do
  begin
    RegisterMethod('Constructor Create( const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMSyntax(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDOMError', 'EDOMSyntax') do
  with CL.AddClassN(CL.FindClass('EDOMError'),'EDOMSyntax') do
  begin
    RegisterMethod('Constructor Create( const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMInvalidState(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDOMError', 'EDOMInvalidState') do
  with CL.AddClassN(CL.FindClass('EDOMError'),'EDOMInvalidState') do
  begin
    RegisterMethod('Constructor Create( const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMInUseAttribute(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDOMError', 'EDOMInUseAttribute') do
  with CL.AddClassN(CL.FindClass('EDOMError'),'EDOMInUseAttribute') do
  begin
    RegisterMethod('Constructor Create( const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMNotSupported(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDOMError', 'EDOMNotSupported') do
  with CL.AddClassN(CL.FindClass('EDOMError'),'EDOMNotSupported') do
  begin
    RegisterMethod('Constructor Create( const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMNotFound(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDOMError', 'EDOMNotFound') do
  with CL.AddClassN(CL.FindClass('EDOMError'),'EDOMNotFound') do
  begin
    RegisterMethod('Constructor Create( const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMWrongDocument(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDOMError', 'EDOMWrongDocument') do
  with CL.AddClassN(CL.FindClass('EDOMError'),'EDOMWrongDocument') do
  begin
    RegisterMethod('Constructor Create( const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMHierarchyRequest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDOMError', 'EDOMHierarchyRequest') do
  with CL.AddClassN(CL.FindClass('EDOMError'),'EDOMHierarchyRequest') do
  begin
    RegisterMethod('Constructor Create( const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMIndexSize(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDOMError', 'EDOMIndexSize') do
  with CL.AddClassN(CL.FindClass('EDOMError'),'EDOMIndexSize') do
  begin
    RegisterMethod('Constructor Create( const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDOMError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EDOMError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EDOMError') do
  begin
    RegisterMethod('Constructor Create( ACode : Integer; const ASituation : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Laz_DOM(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMImplementation');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMDocumentFragment');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMDocument');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXMLDocumentDOM');

  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMNode');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMNodeList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMNamedNodeMap');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMCharacterData');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMAttr');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMElement');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMText');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMComment');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMCDATASection');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMDocumentType');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMNotation');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMEntity');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMEntityReference');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDOMProcessingInstruction');
  CL.AddTypeS('DOMString', 'String');
  CL.AddTypeS('DOMPChar', 'PChar');
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
  SIRegister_EDOMError(CL);
  SIRegister_EDOMIndexSize(CL);
  SIRegister_EDOMHierarchyRequest(CL);
  SIRegister_EDOMWrongDocument(CL);
  SIRegister_EDOMNotFound(CL);
  SIRegister_EDOMNotSupported(CL);
  SIRegister_EDOMInUseAttribute(CL);
  SIRegister_EDOMInvalidState(CL);
  SIRegister_EDOMSyntax(CL);
  SIRegister_EDOMInvalidModification(CL);
  SIRegister_EDOMNamespace(CL);
  SIRegister_EDOMInvalidAccess(CL);
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
  SIRegister_TRefClass(CL);
  SIRegister_TDOMNode(CL);
  SIRegister_TDOMNode_WithChildren(CL);
  SIRegister_TDOMNodeList(CL);
  SIRegister_TDOMNamedNodeMap(CL);
  SIRegister_TDOMCharacterData(CL);
  SIRegister_TDOMImplementation(CL);
  SIRegister_TDOMDocumentFragment(CL);
  SIRegister_TDOMDocument(CL);
  SIRegister_TXMLDocumentDOM(CL);
  SIRegister_TDOMAttr(CL);
  SIRegister_TDOMElement(CL);
  SIRegister_TDOMText(CL);
  SIRegister_TDOMComment(CL);
  SIRegister_TDOMCDATASection(CL);
  SIRegister_TDOMDocumentType(CL);
  SIRegister_TDOMNotation(CL);
  SIRegister_TDOMEntity(CL);
  SIRegister_TDOMEntityReference(CL);
  SIRegister_TDOMProcessingInstruction(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDOMProcessingInstructionData_R(Self: TDOMProcessingInstruction; var T: DOMString);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TDOMProcessingInstructionTarget_R(Self: TDOMProcessingInstruction; var T: DOMString);
begin T := Self.Target; end;

(*----------------------------------------------------------------------------*)
procedure TDOMEntityNotationName_R(Self: TDOMEntity; var T: DOMString);
begin T := Self.NotationName; end;

(*----------------------------------------------------------------------------*)
procedure TDOMEntitySystemID_R(Self: TDOMEntity; var T: DOMString);
begin T := Self.SystemID; end;

(*----------------------------------------------------------------------------*)
procedure TDOMEntityPublicID_R(Self: TDOMEntity; var T: DOMString);
begin T := Self.PublicID; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNotationSystemID_R(Self: TDOMNotation; var T: DOMString);
begin T := Self.SystemID; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNotationPublicID_R(Self: TDOMNotation; var T: DOMString);
begin T := Self.PublicID; end;

(*----------------------------------------------------------------------------*)
procedure TDOMDocumentTypeNotations_R(Self: TDOMDocumentType; var T: TDOMNamedNodeMap);
begin T := Self.Notations; end;

(*----------------------------------------------------------------------------*)
procedure TDOMDocumentTypeEntities_R(Self: TDOMDocumentType; var T: TDOMNamedNodeMap);
begin T := Self.Entities; end;

(*----------------------------------------------------------------------------*)
procedure TDOMDocumentTypeName_R(Self: TDOMDocumentType; var T: DOMString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TDOMElementAttribStrings_W(Self: TDOMElement; const T: DOMString; const t1: DOMString);
begin Self.AttribStrings[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TDOMElementAttribStrings_R(Self: TDOMElement; var T: DOMString; const t1: DOMString);
begin T := Self.AttribStrings[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TDOMElementTagName_R(Self: TDOMElement; var T: DOMString);
begin T := Self.TagName; end;

(*----------------------------------------------------------------------------*)
procedure TDOMAttrValue_W(Self: TDOMAttr; const T: DOMString);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TDOMAttrValue_R(Self: TDOMAttr; var T: DOMString);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TDOMAttrSpecified_R(Self: TDOMAttr; var T: Boolean);
begin T := Self.Specified; end;

(*----------------------------------------------------------------------------*)
procedure TDOMAttrName_R(Self: TDOMAttr; var T: DOMString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentStylesheetHRef_W(Self: TXMLDocumentDOM; const T: DOMString);
Begin Self.StylesheetHRef := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentStylesheetHRef_R(Self: TXMLDocumentDOM; var T: DOMString);
Begin T := Self.StylesheetHRef; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentStylesheetType_W(Self: TXMLDocumentDOM; const T: DOMString);
Begin Self.StylesheetType := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentStylesheetType_R(Self: TXMLDocumentDOM; var T: DOMString);
Begin T := Self.StylesheetType; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentEncoding_W(Self: TXMLDocumentDOM; const T: DOMString);
Begin Self.Encoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentEncoding_R(Self: TXMLDocumentDOM; var T: DOMString);
Begin T := Self.Encoding; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentXMLVersion_W(Self: TXMLDocumentDOM; const T: DOMString);
Begin Self.XMLVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLDocumentXMLVersion_R(Self: TXMLDocumentDOM; var T: DOMString);
Begin T := Self.XMLVersion; end;

(*----------------------------------------------------------------------------*)
procedure TDOMDocumentDocumentElement_R(Self: TDOMDocument; var T: TDOMElement);
begin T := Self.DocumentElement; end;

(*----------------------------------------------------------------------------*)
procedure TDOMDocumentImpl_R(Self: TDOMDocument; var T: TDOMImplementation);
begin T := Self.Impl; end;

(*----------------------------------------------------------------------------*)
procedure TDOMDocumentDocType_R(Self: TDOMDocument; var T: TDOMDocumentType);
begin T := Self.DocType; end;

(*----------------------------------------------------------------------------*)
procedure TDOMCharacterDataLength_R(Self: TDOMCharacterData; var T: LongInt);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
procedure TDOMCharacterDataData_R(Self: TDOMCharacterData; var T: DOMString);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNamedNodeMapLength_R(Self: TDOMNamedNodeMap; var T: LongInt);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNamedNodeMapItem_W(Self: TDOMNamedNodeMap; const T: TDOMNode; const t1: LongWord);
begin Self.Item[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNamedNodeMapItem_R(Self: TDOMNamedNodeMap; var T: TDOMNode; const t1: LongWord);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeListCount_R(Self: TDOMNodeList; var T: LongInt);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeListItem_R(Self: TDOMNodeList; var T: TDOMNode; const t1: LongWord);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
Function TDOMNodeCloneNode1_P(Self: TDOMNode;  deep : Boolean; ACloneOwner : TDOMDocument) : TDOMNode;
Begin Result := Self.CloneNode(deep, ACloneOwner); END;

(*----------------------------------------------------------------------------*)
Function TDOMNodeCloneNode_P(Self: TDOMNode;  deep : Boolean) : TDOMNode;
Begin Result := Self.CloneNode(deep); END;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeOwnerDocument_R(Self: TDOMNode; var T: TDOMDocument);
begin T := Self.OwnerDocument; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeAttributes_R(Self: TDOMNode; var T: TDOMNamedNodeMap);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeNextSibling_R(Self: TDOMNode; var T: TDOMNode);
begin T := Self.NextSibling; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodePreviousSibling_R(Self: TDOMNode; var T: TDOMNode);
begin T := Self.PreviousSibling; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeChildNodes_R(Self: TDOMNode; var T: TDOMNodeList);
begin T := Self.ChildNodes; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeLastChild_R(Self: TDOMNode; var T: TDOMNode);
begin T := Self.LastChild; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeFirstChild_R(Self: TDOMNode; var T: TDOMNode);
begin T := Self.FirstChild; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeParentNode_R(Self: TDOMNode; var T: TDOMNode);
begin T := Self.ParentNode; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeNodeType_R(Self: TDOMNode; var T: Integer);
begin T := Self.NodeType; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeNodeValue_W(Self: TDOMNode; const T: DOMString);
begin Self.NodeValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeNodeValue_R(Self: TDOMNode; var T: DOMString);
begin T := Self.NodeValue; end;

(*----------------------------------------------------------------------------*)
procedure TDOMNodeNodeName_R(Self: TDOMNode; var T: DOMString);
begin T := Self.NodeName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMProcessingInstruction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMProcessingInstruction) do
  begin
    RegisterConstructor(@TDOMProcessingInstruction.Create, 'Create');
    RegisterPropertyHelper(@TDOMProcessingInstructionTarget_R,nil,'Target');
    RegisterPropertyHelper(@TDOMProcessingInstructionData_R,nil,'Data');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMEntityReference(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMEntityReference) do
  begin
    RegisterConstructor(@TDOMEntityReference.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMEntity(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMEntity) do
  begin
    RegisterConstructor(@TDOMEntity.Create, 'Create');
    RegisterPropertyHelper(@TDOMEntityPublicID_R,nil,'PublicID');
    RegisterPropertyHelper(@TDOMEntitySystemID_R,nil,'SystemID');
    RegisterPropertyHelper(@TDOMEntityNotationName_R,nil,'NotationName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMNotation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMNotation) do
  begin
    RegisterConstructor(@TDOMNotation.Create, 'Create');
    RegisterMethod(@TDOMNotation.CloneNode, 'CloneNode');
    RegisterPropertyHelper(@TDOMNotationPublicID_R,nil,'PublicID');
    RegisterPropertyHelper(@TDOMNotationSystemID_R,nil,'SystemID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMDocumentType(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMDocumentType) do
  begin
    RegisterConstructor(@TDOMDocumentType.Create, 'Create');
    RegisterMethod(@TDOMDocumentType.CloneNode, 'CloneNode');
    RegisterPropertyHelper(@TDOMDocumentTypeName_R,nil,'Name');
    RegisterPropertyHelper(@TDOMDocumentTypeEntities_R,nil,'Entities');
    RegisterPropertyHelper(@TDOMDocumentTypeNotations_R,nil,'Notations');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMCDATASection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMCDATASection) do
  begin
    RegisterConstructor(@TDOMCDATASection.Create, 'Create');
    RegisterMethod(@TDOMCDATASection.CloneNode, 'CloneNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMComment(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMComment) do
  begin
    RegisterConstructor(@TDOMComment.Create, 'Create');
    RegisterMethod(@TDOMComment.CloneNode, 'CloneNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMText(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMText) do
  begin
    RegisterConstructor(@TDOMText.Create, 'Create');
    RegisterMethod(@TDOMText.CloneNode, 'CloneNode');
    RegisterMethod(@TDOMText.SplitText, 'SplitText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMElement(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMElement) do begin
    RegisterConstructor(@TDOMElement.Create, 'Create');
     RegisterMethod(@TDOMElement.Destroy, 'Free');

    RegisterMethod(@TDOMElement.CloneNode, 'CloneNode');
    RegisterPropertyHelper(@TDOMElementTagName_R,nil,'TagName');
    RegisterMethod(@TDOMElement.GetAttribute, 'GetAttribute');
    RegisterMethod(@TDOMElement.SetAttribute, 'SetAttribute');
    RegisterMethod(@TDOMElement.RemoveAttribute, 'RemoveAttribute');
    RegisterMethod(@TDOMElement.GetAttributeNode, 'GetAttributeNode');
    RegisterMethod(@TDOMElement.SetAttributeNode, 'SetAttributeNode');
    RegisterMethod(@TDOMElement.RemoveAttributeNode, 'RemoveAttributeNode');
    RegisterMethod(@TDOMElement.GetElementsByTagName, 'GetElementsByTagName');
    RegisterMethod(@TDOMElement.IsEmpty, 'IsEmpty');
    RegisterMethod(@TDOMElement.Normalize, 'Normalize');
    RegisterPropertyHelper(@TDOMElementAttribStrings_R,@TDOMElementAttribStrings_W,'AttribStrings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMAttr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMAttr) do
  begin
    RegisterConstructor(@TDOMAttr.Create, 'Create');
    RegisterMethod(@TDOMAttr.CloneNode, 'CloneNode');
    RegisterPropertyHelper(@TDOMAttrName_R,nil,'Name');
    RegisterPropertyHelper(@TDOMAttrSpecified_R,nil,'Specified');
    RegisterPropertyHelper(@TDOMAttrValue_R,@TDOMAttrValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLDocumentDOM(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLDocumentDOM) do
  begin
    RegisterPropertyHelper(@TXMLDocumentXMLVersion_R,@TXMLDocumentXMLVersion_W,'XMLVersion');
    RegisterPropertyHelper(@TXMLDocumentEncoding_R,@TXMLDocumentEncoding_W,'Encoding');
    RegisterPropertyHelper(@TXMLDocumentStylesheetType_R,@TXMLDocumentStylesheetType_W,'StylesheetType');
    RegisterPropertyHelper(@TXMLDocumentStylesheetHRef_R,@TXMLDocumentStylesheetHRef_W,'StylesheetHRef');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMDocument(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMDocument) do
  begin
    RegisterPropertyHelper(@TDOMDocumentDocType_R,nil,'DocType');
    RegisterPropertyHelper(@TDOMDocumentImpl_R,nil,'Impl');
    RegisterPropertyHelper(@TDOMDocumentDocumentElement_R,nil,'DocumentElement');
    RegisterVirtualMethod(@TDOMDocument.CreateElement, 'CreateElement');
    RegisterMethod(@TDOMDocument.CreateDocumentFragment, 'CreateDocumentFragment');
    RegisterMethod(@TDOMDocument.CreateTextNode, 'CreateTextNode');
    RegisterMethod(@TDOMDocument.CreateComment, 'CreateComment');
    RegisterVirtualMethod(@TDOMDocument.CreateCDATASection, 'CreateCDATASection');
    RegisterVirtualMethod(@TDOMDocument.CreateProcessingInstruction, 'CreateProcessingInstruction');
    RegisterVirtualMethod(@TDOMDocument.CreateAttribute, 'CreateAttribute');
    RegisterVirtualMethod(@TDOMDocument.CreateEntityReference, 'CreateEntityReference');
    RegisterMethod(@TDOMDocument.GetElementsByTagName, 'GetElementsByTagName');
    RegisterConstructor(@TDOMDocument.Create, 'Create');
    RegisterMethod(@TDOMDocument.CreateEntity, 'CreateEntity');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMDocumentFragment(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMDocumentFragment) do
  begin
    RegisterConstructor(@TDOMDocumentFragment.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMImplementation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMImplementation) do
  begin
    RegisterMethod(@TDOMImplementation.HasFeature, 'HasFeature');
    RegisterMethod(@TDOMImplementation.CreateDocumentType, 'CreateDocumentType');
    RegisterMethod(@TDOMImplementation.CreateDocument, 'CreateDocument');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMCharacterData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMCharacterData) do
  begin
    RegisterPropertyHelper(@TDOMCharacterDataData_R,nil,'Data');
    RegisterPropertyHelper(@TDOMCharacterDataLength_R,nil,'Length');
    RegisterMethod(@TDOMCharacterData.SubstringData, 'SubstringData');
    RegisterMethod(@TDOMCharacterData.AppendData, 'AppendData');
    RegisterMethod(@TDOMCharacterData.InsertData, 'InsertData');
    RegisterMethod(@TDOMCharacterData.DeleteData, 'DeleteData');
    RegisterMethod(@TDOMCharacterData.ReplaceData, 'ReplaceData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMNamedNodeMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMNamedNodeMap) do
  begin
    RegisterConstructor(@TDOMNamedNodeMap.Create, 'Create');
    RegisterMethod(@TDOMNamedNodeMap.GetNamedItem, 'GetNamedItem');
    RegisterMethod(@TDOMNamedNodeMap.SetNamedItem, 'SetNamedItem');
    RegisterMethod(@TDOMNamedNodeMap.RemoveNamedItem, 'RemoveNamedItem');
    RegisterPropertyHelper(@TDOMNamedNodeMapItem_R,@TDOMNamedNodeMapItem_W,'Item');
    RegisterPropertyHelper(@TDOMNamedNodeMapLength_R,nil,'Length');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMNodeList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMNodeList) do
  begin
    RegisterConstructor(@TDOMNodeList.Create, 'Create');
    RegisterPropertyHelper(@TDOMNodeListItem_R,nil,'Item');
    RegisterPropertyHelper(@TDOMNodeListCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMNode_WithChildren(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMNode_WithChildren) do begin
             RegisterMethod(@TDOMNode_WithChildren.Destroy, 'Free');

    RegisterMethod(@TDOMNode_WithChildren.InsertBefore, 'InsertBefore');
    RegisterMethod(@TDOMNode_WithChildren.ReplaceChild, 'ReplaceChild');
    RegisterMethod(@TDOMNode_WithChildren.RemoveChild, 'RemoveChild');
    RegisterMethod(@TDOMNode_WithChildren.AppendChild, 'AppendChild');
    RegisterMethod(@TDOMNode_WithChildren.HasChildNodes, 'HasChildNodes');
    RegisterMethod(@TDOMNode_WithChildren.FindNode, 'FindNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDOMNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMNode) do
  begin
    RegisterConstructor(@TDOMNode.Create, 'Create');
    RegisterVirtualMethod(@TDOMNode.GetChildNodes, 'GetChildNodes');
    RegisterPropertyHelper(@TDOMNodeNodeName_R,nil,'NodeName');
    RegisterPropertyHelper(@TDOMNodeNodeValue_R,@TDOMNodeNodeValue_W,'NodeValue');
    RegisterPropertyHelper(@TDOMNodeNodeType_R,nil,'NodeType');
    RegisterPropertyHelper(@TDOMNodeParentNode_R,nil,'ParentNode');
    RegisterPropertyHelper(@TDOMNodeFirstChild_R,nil,'FirstChild');
    RegisterPropertyHelper(@TDOMNodeLastChild_R,nil,'LastChild');
    RegisterPropertyHelper(@TDOMNodeChildNodes_R,nil,'ChildNodes');
    RegisterPropertyHelper(@TDOMNodePreviousSibling_R,nil,'PreviousSibling');
    RegisterPropertyHelper(@TDOMNodeNextSibling_R,nil,'NextSibling');
    RegisterPropertyHelper(@TDOMNodeAttributes_R,nil,'Attributes');
    RegisterPropertyHelper(@TDOMNodeOwnerDocument_R,nil,'OwnerDocument');
    RegisterVirtualMethod(@TDOMNode.InsertBefore, 'InsertBefore');
    RegisterVirtualMethod(@TDOMNode.ReplaceChild, 'ReplaceChild');
    RegisterVirtualMethod(@TDOMNode.RemoveChild, 'RemoveChild');
    RegisterVirtualMethod(@TDOMNode.AppendChild, 'AppendChild');
    RegisterVirtualMethod(@TDOMNode.HasChildNodes, 'HasChildNodes');
    RegisterMethod(@TDOMNodeCloneNode_P, 'CloneNode');
    RegisterVirtualMethod(@TDOMNodeCloneNode1_P, 'CloneNode1');
    RegisterVirtualMethod(@TDOMNode.FindNode, 'FindNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRefClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRefClass) do
  begin
    RegisterConstructor(@TRefClass.Create, 'Create');
    RegisterVirtualMethod(@TRefClass.AddRef, 'AddRef');
    RegisterVirtualMethod(@TRefClass.Release, 'Release');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMInvalidAccess(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMInvalidAccess) do
  begin
    RegisterConstructor(@EDOMInvalidAccess.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMNamespace(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMNamespace) do
  begin
    RegisterConstructor(@EDOMNamespace.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMInvalidModification(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMInvalidModification) do
  begin
    RegisterConstructor(@EDOMInvalidModification.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMSyntax(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMSyntax) do
  begin
    RegisterConstructor(@EDOMSyntax.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMInvalidState(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMInvalidState) do
  begin
    RegisterConstructor(@EDOMInvalidState.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMInUseAttribute(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMInUseAttribute) do
  begin
    RegisterConstructor(@EDOMInUseAttribute.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMNotSupported(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMNotSupported) do
  begin
    RegisterConstructor(@EDOMNotSupported.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMNotFound(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMNotFound) do
  begin
    RegisterConstructor(@EDOMNotFound.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMWrongDocument(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMWrongDocument) do
  begin
    RegisterConstructor(@EDOMWrongDocument.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMHierarchyRequest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMHierarchyRequest) do
  begin
    RegisterConstructor(@EDOMHierarchyRequest.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMIndexSize(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMIndexSize) do
  begin
    RegisterConstructor(@EDOMIndexSize.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDOMError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDOMError) do
  begin
    RegisterConstructor(@EDOMError.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Laz_DOM(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDOMImplementation) do
  with CL.Add(TDOMDocumentFragment) do
  with CL.Add(TDOMDocument) do
  with CL.Add(TDOMNode) do
  with CL.Add(TDOMNodeList) do
  with CL.Add(TDOMNamedNodeMap) do
  with CL.Add(TDOMCharacterData) do
  with CL.Add(TDOMAttr) do
  with CL.Add(TDOMElement) do
  with CL.Add(TDOMText) do
  with CL.Add(TDOMComment) do
  with CL.Add(TDOMCDATASection) do
  with CL.Add(TDOMDocumentType) do
  with CL.Add(TDOMNotation) do
  with CL.Add(TDOMEntity) do
  with CL.Add(TDOMEntityReference) do
  with CL.Add(TDOMProcessingInstruction) do
  RIRegister_EDOMError(CL);
  RIRegister_EDOMIndexSize(CL);
  RIRegister_EDOMHierarchyRequest(CL);
  RIRegister_EDOMWrongDocument(CL);
  RIRegister_EDOMNotFound(CL);
  RIRegister_EDOMNotSupported(CL);
  RIRegister_EDOMInUseAttribute(CL);
  RIRegister_EDOMInvalidState(CL);
  RIRegister_EDOMSyntax(CL);
  RIRegister_EDOMInvalidModification(CL);
  RIRegister_EDOMNamespace(CL);
  RIRegister_EDOMInvalidAccess(CL);
  RIRegister_TRefClass(CL);
  RIRegister_TDOMNode(CL);
  RIRegister_TDOMNode_WithChildren(CL);
  RIRegister_TDOMNodeList(CL);
  RIRegister_TDOMNamedNodeMap(CL);
  RIRegister_TDOMCharacterData(CL);
  RIRegister_TDOMImplementation(CL);
  RIRegister_TDOMDocumentFragment(CL);
  RIRegister_TDOMDocument(CL);
  RIRegister_TXMLDocumentDOM(CL);
  RIRegister_TDOMAttr(CL);
  RIRegister_TDOMElement(CL);
  RIRegister_TDOMText(CL);
  RIRegister_TDOMComment(CL);
  RIRegister_TDOMCDATASection(CL);
  RIRegister_TDOMDocumentType(CL);
  RIRegister_TDOMNotation(CL);
  RIRegister_TDOMEntity(CL);
  RIRegister_TDOMEntityReference(CL);
  RIRegister_TDOMProcessingInstruction(CL);
end;

 
 
{ TPSImport_Laz_DOM }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Laz_DOM.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Laz_DOM(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Laz_DOM.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Laz_DOM(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
