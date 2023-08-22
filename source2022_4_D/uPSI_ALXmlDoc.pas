unit uPSI_ALXmlDoc;
{
   for the well known tutorial     - 10 constructors
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
  TPSImport_ALXmlDoc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALXMLDocument(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlNotationNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlDocFragmentNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlDocTypeNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlEntityNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlEntityRefNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlCDataNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlProcessingInstrNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlCommentNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlDocumentNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlTextNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlAttributeNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXmlElementNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXMLNode(CL: TPSPascalCompiler);
procedure SIRegister_TALXMLNodeList(CL: TPSPascalCompiler);
procedure SIRegister_EALXMLDocError(CL: TPSPascalCompiler);
procedure SIRegister_ALXmlDoc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALXmlDoc_Routines(S: TPSExec);
procedure RIRegister_TALXMLDocument(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlNotationNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlDocFragmentNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlDocTypeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlEntityNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlEntityRefNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlCDataNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlProcessingInstrNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlCommentNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlDocumentNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlTextNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlAttributeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXmlElementNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXMLNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALXMLNodeList(CL: TPSRuntimeClassImporter);
procedure RIRegister_EALXMLDocError(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALXmlDoc(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   AlStringList
  ,ALXmlDoc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALXmlDoc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXMLDocument(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALXMLDocument') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALXMLDocument') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function AddChild( const TagName : AnsiString) : TALXMLNode');
    RegisterMethod('Function CreateElement( const TagOrData : AnsiString) : TALXMLNode');
    RegisterMethod('Function CreateNode( const NameOrData : AnsiString; NodeType : TALXMLNodeType; const AddlData : AnsiString) : TALXMLNode');
    RegisterMethod('Function IsEmptyDoc : Boolean');
    RegisterMethod('Procedure LoadFromFile( const AFileName : AnsiString; const saxMode : Boolean)');
    RegisterMethod('Procedure LoadFromStream( const Stream : TStream; const saxMode : Boolean)');
    RegisterMethod('Procedure LoadFromXML( const XML : AnsiString; const saxMode : Boolean)');
    RegisterMethod('Procedure SaveToFile( const AFileName : AnsiString)');
    RegisterMethod('Procedure SaveToStream( const Stream : TStream)');
    RegisterMethod('Procedure SaveToXML( var XML : AnsiString)');
    RegisterProperty('ChildNodes', 'TALXMLNodeList', iptr);
    RegisterProperty('DocumentElement', 'TALXMLNode', iptrw);
    RegisterProperty('Encoding', 'AnsiString', iptrw);
    RegisterProperty('Node', 'TALXMLNode', iptr);
    RegisterProperty('StandAlone', 'AnsiString', iptrw);
    RegisterProperty('Filename', 'AnsiString', iptrw);
    RegisterProperty('Version', 'AnsiString', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('NodeIndentStr', 'AnsiString', iptrw);
    RegisterProperty('Options', 'TALXMLDocOptions', iptrw);
    RegisterProperty('ParseOptions', 'TALXMLParseOptions', iptrw);
    RegisterProperty('XML', 'AnsiString', iptrw);
    RegisterProperty('OnParseProcessingInstruction', 'TAlXMLParseProcessingInstructionEvent', iptrw);
    RegisterProperty('OnParseStartDocument', 'TNotifyEvent', iptrw);
    RegisterProperty('OnParseEndDocument', 'TNotifyEvent', iptrw);
    RegisterProperty('OnParseStartElement', 'TAlXMLParseStartElementEvent', iptrw);
    RegisterProperty('OnParseEndElement', 'TAlXMLParseEndElementEVent', iptrw);
    RegisterProperty('OnParseText', 'TAlXMLParseTextEvent', iptrw);
    RegisterProperty('OnParseComment', 'TAlXMLParseTextEvent', iptrw);
    RegisterProperty('OnParseCData', 'TAlXMLParseTextEvent', iptrw);
    RegisterProperty('Tag', 'NativeInt', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlNotationNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXMLNode', 'TALXmlNotationNode') do
  with CL.AddClassN(CL.FindClass('TALXMLNode'),'TALXmlNotationNode') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlDocFragmentNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXMLNode', 'TALXmlDocFragmentNode') do
  with CL.AddClassN(CL.FindClass('TALXMLNode'),'TALXmlDocFragmentNode') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlDocTypeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXMLNode', 'TALXmlDocTypeNode') do
  with CL.AddClassN(CL.FindClass('TALXMLNode'),'TALXmlDocTypeNode') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlEntityNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXMLNode', 'TALXmlEntityNode') do
  with CL.AddClassN(CL.FindClass('TALXMLNode'),'TALXmlEntityNode') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlEntityRefNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXMLNode', 'TALXmlEntityRefNode') do
  with CL.AddClassN(CL.FindClass('TALXMLNode'),'TALXmlEntityRefNode') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlCDataNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXMLNode', 'TALXmlCDataNode') do
  with CL.AddClassN(CL.FindClass('TALXMLNode'),'TALXmlCDataNode') do begin
    RegisterMethod('Constructor Create( const NameOrData : AnsiString)');
      RegisterMethod('Procedure Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlProcessingInstrNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXMLNode', 'TALXmlProcessingInstrNode') do
  with CL.AddClassN(CL.FindClass('TALXMLNode'),'TALXmlProcessingInstrNode') do begin
    RegisterMethod('Constructor Create( const NameOrData : AnsiString; const AddlData : AnsiString)');
    RegisterMethod('Procedure Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlCommentNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXMLNode', 'TALXmlCommentNode') do
  with CL.AddClassN(CL.FindClass('TALXMLNode'),'TALXmlCommentNode') do begin
    RegisterMethod('Constructor Create( const NameOrData : AnsiString)');
      RegisterMethod('Procedure Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlDocumentNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXmlNode', 'TALXmlDocumentNode') do
  with CL.AddClassN(CL.FindClass('TALXmlNode'),'TALXmlDocumentNode') do begin
    RegisterMethod('Constructor Create( const OwnerDoc : TALXMLDocument)');
      RegisterMethod('Procedure Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlTextNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXMLNode', 'TALXmlTextNode') do
  with CL.AddClassN(CL.FindClass('TALXMLNode'),'TALXmlTextNode') do begin
    RegisterMethod('Constructor Create( const NameOrData : AnsiString)');
      RegisterMethod('Procedure Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlAttributeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXMLNode', 'TALXmlAttributeNode') do
  with CL.AddClassN(CL.FindClass('TALXMLNode'),'TALXmlAttributeNode') do begin
    RegisterMethod('Constructor Create( const NameOrData : AnsiString)');
      RegisterMethod('Procedure Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXmlElementNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALXMLNode', 'TALXmlElementNode') do
  with CL.AddClassN(CL.FindClass('TALXMLNode'),'TALXmlElementNode') do begin
    RegisterMethod('Constructor Create( const NameOrData : AnsiString)');
      RegisterMethod('Procedure Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXMLNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALXMLNode') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALXMLNode') do begin
    RegisterMethod('Constructor Create( const NameOrData : AnsiString; const AddlData : AnsiString)');
       RegisterMethod('Procedure Free');
    RegisterMethod('Function CloneNode( Deep : Boolean) : TALXMLNode');
    RegisterMethod('Function AddChild( const TagName : AnsiString; Index : Integer) : TALXMLNode;');
    RegisterMethod('Function HasAttribute( const Name : AnsiString) : Boolean;');
    RegisterMethod('Function NextSibling : TALXMLNode');
    RegisterMethod('Function PreviousSibling : TALXMLNode');
    RegisterProperty('AttributeNodes', 'TALXMLNodeList', iptr);
    RegisterProperty('Attributes', 'AnsiString AnsiString', iptrw);
    RegisterProperty('ChildNodes', 'TALXMLNodeList', iptrw);
    RegisterProperty('HasChildNodes', 'Boolean', iptr);
    RegisterProperty('IsTextElement', 'Boolean', iptr);
    RegisterProperty('LocalName', 'AnsiString', iptr);
    RegisterProperty('NodeName', 'AnsiString', iptrw);
    RegisterProperty('NodeType', 'TALXMLNodeType', iptr);
    RegisterProperty('NodeValue', 'AnsiString', iptrw);
    RegisterProperty('OwnerDocument', 'TALXMLDocument', iptrw);
    RegisterProperty('ParentNode', 'TALXMLNode', iptr);
    RegisterProperty('Prefix', 'AnsiString', iptr);
    RegisterProperty('Text', 'AnsiString', iptrw);
    RegisterProperty('XML', 'AnsiString', iptrw);
    RegisterMethod('Procedure SaveToStream( const Stream : TStream; const SaveOnlyChildNode : Boolean)');
    RegisterMethod('Procedure SaveToFile( const AFileName : AnsiString; const SaveOnlyChildNode : Boolean)');
    RegisterMethod('Procedure LoadFromFile( const AFileName : AnsiString; const FileContainOnlyChildNode : Boolean)');
    RegisterMethod('Procedure LoadFromStream( const Stream : TStream; const StreamContainOnlyChildNode : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALXMLNodeList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TALXMLNodeList') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TALXMLNodeList') do begin
    RegisterMethod('Constructor Create( Owner : TALXMLNode)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure CustomSort( Compare : TALXMLNodeListSortCompare)');
    RegisterMethod('Function Add( const Node : TALXMLNode) : Integer');
    RegisterMethod('Function Delete( const Index : Integer) : Integer;');
    RegisterMethod('Function Delete1( const Name : AnsiString) : Integer;');
    RegisterMethod('Function Extract( const index : integer) : TALXMLNode;');
    RegisterMethod('Function Extract1( const Node : TALXMLNode) : TALXMLNode;');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function FindNode( NodeName : AnsiString) : TALXMLNode;');
    RegisterMethod('Function FindNode1( NodeName : AnsiString; NodeAttributes : array of ansiString) : TALXMLNode;');
    RegisterMethod('Function FindSibling( const Node : TALXMLNode; Delta : Integer) : TALXMLNode');
    RegisterMethod('Function First : TALXMLNode');
    RegisterMethod('Function IndexOf( const Name : AnsiString) : Integer;');
    RegisterMethod('Function IndexOf1( const Node : TALXMLNode) : Integer;');
    RegisterMethod('Function Last : TALXMLNode');
    RegisterMethod('Function Remove( const Node : TALXMLNode) : Integer');
    RegisterMethod('Function ReplaceNode( const OldNode, NewNode : TALXMLNode) : TALXMLNode');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Insert( Index : Integer; const Node : TALXMLNode)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Nodes', 'TALXMLNode OleVariant', iptr);
    SetDefaultPropery('Nodes');
    RegisterProperty('Nodes1', 'TALXMLNode AnsiString', iptr);
    SetDefaultPropery('Nodes1');
    RegisterProperty('Nodes2', 'TALXMLNode integer', iptr);
    SetDefaultPropery('Nodes2');
  end;
end;
  (*{$IF CompilerVersion < 18.5}
    property Nodes[const IndexOrName: OleVariant]: TALXMLNode read GetNode; default;
    {$ELSE}
    property Nodes[const Name: AnsiString]: TALXMLNode read GetNodeByName; default;
    property Nodes[const Index: integer]: TALXMLNode read GetNodeByIndex; default;
    {$IFEND}  *)


(*----------------------------------------------------------------------------*)
procedure SIRegister_EALXMLDocError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EALXMLDocError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EALXMLDocError') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALXmlDoc(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cALXMLNodeMaxListSize','LongInt').SetInt( Maxint div 16);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TALXMLNode');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TALXMLNodeList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TALXMLDocument');
  CL.AddTypeS('TAlXMLParseProcessingInstructionEvent', 'Procedure ( Sender : TObject; const Target, Data : AnsiString)');
  CL.AddTypeS('TAlXMLParseTextEvent', 'Procedure ( Sender : TObject; const str: AnsiString)');
  CL.AddTypeS('TAlXMLParseStartElementEvent', 'Procedure ( Sender : TObject; const Name : AnsiString; const Attributes : TALStrings)');
  CL.AddTypeS('TAlXMLParseEndElementEvent', 'Procedure ( Sender : TObject; const Name : AnsiString)');
  CL.AddTypeS('TALXmlNodeType', '( ntReserved, ntElement, ntAttribute, ntText, '
   +'ntCData, ntEntityRef, ntEntity, ntProcessingInstr, ntComment, ntDocument, ntDocType, ntDocFragment, ntNotation )');
  CL.AddTypeS('TALXMLDocOption', '( doNodeAutoCreate, doNodeAutoIndent )');
  CL.AddTypeS('TALXMLDocOptions', 'set of TALXMLDocOption');
  CL.AddTypeS('TALXMLParseOption', '( poPreserveWhiteSpace, poIgnoreXMLReferences )');
  CL.AddTypeS('TALXMLParseOptions', 'set of TALXMLParseOption');
  CL.AddTypeS('TALXMLPrologItem', '( xpVersion, xpEncoding, xpStandalone )');
  //CL.AddTypeS('PALPointerXMLNodeList', '^TALPointerXMLNodeList // will not work');
  SIRegister_EALXMLDocError(CL);
  SIRegister_TALXMLNodeList(CL);
  SIRegister_TALXMLNode(CL);
  SIRegister_TALXmlElementNode(CL);
  SIRegister_TALXmlAttributeNode(CL);
  SIRegister_TALXmlTextNode(CL);
  SIRegister_TALXmlDocumentNode(CL);
  SIRegister_TALXmlCommentNode(CL);
  SIRegister_TALXmlProcessingInstrNode(CL);
  SIRegister_TALXmlCDataNode(CL);
  SIRegister_TALXmlEntityRefNode(CL);
  SIRegister_TALXmlEntityNode(CL);
  SIRegister_TALXmlDocTypeNode(CL);
  SIRegister_TALXmlDocFragmentNode(CL);
  SIRegister_TALXmlNotationNode(CL);
  SIRegister_TALXMLDocument(CL);
 CL.AddConstantN('cAlXMLUTF8EncodingStr','String').SetString( 'UTF-8');
 CL.AddConstantN('cALXmlUTF8HeaderStr','String').SetString( '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+ #13#10);
 CL.AddConstantN('CALNSDelim','String').SetString( ':');
 CL.AddConstantN('CALXML','String').SetString( 'xml');
 CL.AddConstantN('CALVersion','String').SetString( 'version');
 CL.AddConstantN('CALEncoding','String').SetString( 'encoding');
 CL.AddConstantN('CALStandalone','String').SetString( 'standalone');
 CL.AddConstantN('CALDefaultNodeIndent','String').SetString( '  ');
 CL.AddConstantN('CALXmlDocument','String').SetString( 'DOCUMENT');
 CL.AddConstantN('cAlUTF8Bom','String').SetString(#$EF+#$BB+#$BF);

 //Const cAlUTF8Bom = ansiString(#$EF) + ansiString(#$BB) + ansiString(#$BF);

 CL.AddDelphiFunction('Function ALCreateEmptyXMLDocument( const Rootname : AnsiString) : TalXMLDocument');
 CL.AddDelphiFunction('Procedure ALClearXMLDocument( const rootname : AnsiString; xmldoc : TalXMLDocument; const EncodingStr : AnsiString)');
 CL.AddDelphiFunction('Function ALFindXmlNodeByChildNodeValue( xmlrec : TalxmlNode; const ChildNodeName, ChildNodeValue : AnsiString; const Recurse : Boolean) : TalxmlNode');
 CL.AddDelphiFunction('Function ALFindXmlNodeByNameAndChildNodeValue( xmlrec : TalxmlNode; const NodeName : ansiString; const ChildNodeName, ChildNodeValue : AnsiString; const Recurse : Boolean) : TalxmlNode');
 CL.AddDelphiFunction('Function ALFindXmlNodeByAttribute( xmlrec : TalxmlNode; const AttributeName, AttributeValue : AnsiString; const Recurse : Boolean) : TalxmlNode');
 CL.AddDelphiFunction('Function ALFindXmlNodeByNameAndAttribute( xmlrec : TalxmlNode; const NodeName : ansiString; const AttributeName, AttributeValue : AnsiString; const Recurse : Boolean) : TalxmlNode');
 CL.AddDelphiFunction('Function ALExtractAttrValue( const AttrName, AttrLine : AnsiString; const Default : AnsiString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentTag_W(Self: TALXMLDocument; const T: NativeInt);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentTag_R(Self: TALXMLDocument; var T: NativeInt);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseCData_W(Self: TALXMLDocument; const T: TAlXMLParseTextEvent);
begin Self.OnParseCData := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseCData_R(Self: TALXMLDocument; var T: TAlXMLParseTextEvent);
begin T := Self.OnParseCData; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseComment_W(Self: TALXMLDocument; const T: TAlXMLParseTextEvent);
begin Self.OnParseComment := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseComment_R(Self: TALXMLDocument; var T: TAlXMLParseTextEvent);
begin T := Self.OnParseComment; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseText_W(Self: TALXMLDocument; const T: TAlXMLParseTextEvent);
begin Self.OnParseText := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseText_R(Self: TALXMLDocument; var T: TAlXMLParseTextEvent);
begin T := Self.OnParseText; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseEndElement_W(Self: TALXMLDocument; const T: TAlXMLParseEndElementEVent);
begin Self.OnParseEndElement := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseEndElement_R(Self: TALXMLDocument; var T: TAlXMLParseEndElementEVent);
begin T := Self.OnParseEndElement; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseStartElement_W(Self: TALXMLDocument; const T: TAlXMLParseStartElementEvent);
begin Self.OnParseStartElement := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseStartElement_R(Self: TALXMLDocument; var T: TAlXMLParseStartElementEvent);
begin T := Self.OnParseStartElement; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseEndDocument_W(Self: TALXMLDocument; const T: TNotifyEvent);
begin Self.OnParseEndDocument := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseEndDocument_R(Self: TALXMLDocument; var T: TNotifyEvent);
begin T := Self.OnParseEndDocument; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseStartDocument_W(Self: TALXMLDocument; const T: TNotifyEvent);
begin Self.OnParseStartDocument := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseStartDocument_R(Self: TALXMLDocument; var T: TNotifyEvent);
begin T := Self.OnParseStartDocument; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseProcessingInstruction_W(Self: TALXMLDocument; const T: TAlXMLParseProcessingInstructionEvent);
begin Self.OnParseProcessingInstruction := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOnParseProcessingInstruction_R(Self: TALXMLDocument; var T: TAlXMLParseProcessingInstructionEvent);
begin T := Self.OnParseProcessingInstruction; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentXML_W(Self: TALXMLDocument; const T: AnsiString);
begin Self.XML := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentXML_R(Self: TALXMLDocument; var T: AnsiString);
begin T := Self.XML; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentParseOptions_W(Self: TALXMLDocument; const T: TALXMLParseOptions);
begin Self.ParseOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentParseOptions_R(Self: TALXMLDocument; var T: TALXMLParseOptions);
begin T := Self.ParseOptions; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOptions_W(Self: TALXMLDocument; const T: TALXMLDocOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentOptions_R(Self: TALXMLDocument; var T: TALXMLDocOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentNodeIndentStr_W(Self: TALXMLDocument; const T: AnsiString);
begin Self.NodeIndentStr := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentNodeIndentStr_R(Self: TALXMLDocument; var T: AnsiString);
begin T := Self.NodeIndentStr; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentActive_W(Self: TALXMLDocument; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentActive_R(Self: TALXMLDocument; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentVersion_W(Self: TALXMLDocument; const T: AnsiString);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentVersion_R(Self: TALXMLDocument; var T: AnsiString);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentStandAlone_W(Self: TALXMLDocument; const T: AnsiString);
begin Self.StandAlone := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentStandAlone_R(Self: TALXMLDocument; var T: AnsiString);
begin T := Self.StandAlone; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentfname_W(Self: TALXMLDocument; const T: AnsiString);
begin Self.Filename:= T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentfname_R(Self: TALXMLDocument; var T: AnsiString);
begin T := Self.Filename; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentNode_R(Self: TALXMLDocument; var T: TALXMLNode);
begin T := Self.Node; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentEncoding_W(Self: TALXMLDocument; const T: AnsiString);
begin Self.Encoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentEncoding_R(Self: TALXMLDocument; var T: AnsiString);
begin T := Self.Encoding; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentDocumentElement_W(Self: TALXMLDocument; const T: TALXMLNode);
begin Self.DocumentElement := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentDocumentElement_R(Self: TALXMLDocument; var T: TALXMLNode);
begin T := Self.DocumentElement; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLDocumentChildNodes_R(Self: TALXMLDocument; var T: TALXMLNodeList);
begin T := Self.ChildNodes; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeXML_W(Self: TALXMLNode; const T: AnsiString);
begin Self.XML := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeXML_R(Self: TALXMLNode; var T: AnsiString);
begin T := Self.XML; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeText_W(Self: TALXMLNode; const T: AnsiString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeText_R(Self: TALXMLNode; var T: AnsiString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodePrefix_R(Self: TALXMLNode; var T: AnsiString);
begin T := Self.Prefix; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeParentNode_R(Self: TALXMLNode; var T: TALXMLNode);
begin T := Self.ParentNode; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeOwnerDocument_W(Self: TALXMLNode; const T: TALXMLDocument);
begin Self.OwnerDocument := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeOwnerDocument_R(Self: TALXMLNode; var T: TALXMLDocument);
begin T := Self.OwnerDocument; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeNodeValue_W(Self: TALXMLNode; const T: AnsiString);
begin Self.NodeValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeNodeValue_R(Self: TALXMLNode; var T: AnsiString);
begin T := Self.NodeValue; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeNodeType_R(Self: TALXMLNode; var T: TALXMLNodeType);
begin T := Self.NodeType; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeNodeName_W(Self: TALXMLNode; const T: AnsiString);
begin Self.NodeName := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeNodeName_R(Self: TALXMLNode; var T: AnsiString);
begin T := Self.NodeName; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeLocalName_R(Self: TALXMLNode; var T: AnsiString);
begin T := Self.LocalName; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeIsTextElement_R(Self: TALXMLNode; var T: Boolean);
begin T := Self.IsTextElement; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeHasChildNodes_R(Self: TALXMLNode; var T: Boolean);
begin T := Self.HasChildNodes; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeChildNodes_W(Self: TALXMLNode; const T: TALXMLNodeList);
begin Self.ChildNodes := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeChildNodes_R(Self: TALXMLNode; var T: TALXMLNodeList);
begin T := Self.ChildNodes; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeAttributes_W(Self: TALXMLNode; const T: AnsiString; const t1: AnsiString);
begin Self.Attributes[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeAttributes_R(Self: TALXMLNode; var T: AnsiString; const t1: AnsiString);
begin T := Self.Attributes[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeAttributeNodes_R(Self: TALXMLNode; var T: TALXMLNodeList);
begin T := Self.AttributeNodes; end;

(*----------------------------------------------------------------------------*)
Function TALXMLNodeHasAttribute_P(Self: TALXMLNode;  const Name : AnsiString) : Boolean;
Begin Result := Self.HasAttribute(Name); END;

(*----------------------------------------------------------------------------*)
Function TALXMLNodeAddChild_P(Self: TALXMLNode;  const TagName : AnsiString; Index : Integer) : TALXMLNode;
Begin Result := Self.AddChild(TagName, Index); END;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeListNodes_R2(Self: TALXMLNodeList; var T: TALXMLNode; const t1: integer);
begin T := Self.Nodes[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeListNodes_R1(Self: TALXMLNodeList; var T: TALXMLNode; const t1: AnsiString);
begin T := Self.Nodes[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeListNodes_R(Self: TALXMLNodeList; var T: TALXMLNode; const t1: OleVariant);
begin T := Self.Nodes[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALXMLNodeListCount_R(Self: TALXMLNodeList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
Function TALXMLNodeListIndexOf1_P(Self: TALXMLNodeList;  const Node : TALXMLNode) : Integer;
Begin Result := Self.IndexOf(Node); END;

(*----------------------------------------------------------------------------*)
Function TALXMLNodeListIndexOf_P(Self: TALXMLNodeList;  const Name : AnsiString) : Integer;
Begin Result := Self.IndexOf(Name); END;

(*----------------------------------------------------------------------------*)
Function TALXMLNodeListFindNode1_P(Self: TALXMLNodeList;  NodeName : AnsiString; NodeAttributes : array of ansiString) : TALXMLNode;
Begin Result := Self.FindNode(NodeName, NodeAttributes); END;

(*----------------------------------------------------------------------------*)
Function TALXMLNodeListFindNode_P(Self: TALXMLNodeList;  NodeName : AnsiString) : TALXMLNode;
Begin Result := Self.FindNode(NodeName); END;

(*----------------------------------------------------------------------------*)
Function TALXMLNodeListExtract1_P(Self: TALXMLNodeList;  const Node : TALXMLNode) : TALXMLNode;
Begin Result := Self.Extract(Node); END;

(*----------------------------------------------------------------------------*)
Function TALXMLNodeListExtract_P(Self: TALXMLNodeList;  const index : integer) : TALXMLNode;
Begin Result := Self.Extract(index); END;

(*----------------------------------------------------------------------------*)
Function TALXMLNodeListDelete1_P(Self: TALXMLNodeList;  const Name : AnsiString) : Integer;
Begin Result := Self.Delete(Name); END;

(*----------------------------------------------------------------------------*)
Function TALXMLNodeListDelete_P(Self: TALXMLNodeList;  const Index : Integer) : Integer;
Begin Result := Self.Delete(Index); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALXmlDoc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ALCreateEmptyXMLDocument, 'ALCreateEmptyXMLDocument', cdRegister);
 S.RegisterDelphiFunction(@ALClearXMLDocument, 'ALClearXMLDocument', cdRegister);
 S.RegisterDelphiFunction(@ALFindXmlNodeByChildNodeValue, 'ALFindXmlNodeByChildNodeValue', cdRegister);
 S.RegisterDelphiFunction(@ALFindXmlNodeByNameAndChildNodeValue, 'ALFindXmlNodeByNameAndChildNodeValue', cdRegister);
 S.RegisterDelphiFunction(@ALFindXmlNodeByAttribute, 'ALFindXmlNodeByAttribute', cdRegister);
 S.RegisterDelphiFunction(@ALFindXmlNodeByNameAndAttribute, 'ALFindXmlNodeByNameAndAttribute', cdRegister);
 S.RegisterDelphiFunction(@ALExtractAttrValue, 'ALExtractAttrValue', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXMLDocument(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXMLDocument) do begin
    RegisterConstructor(@TALXMLDocument.Create, 'Create');
       RegisterMethod(@TALXMLDocument.Destroy, 'Free');
       RegisterMethod(@TALXMLDocument.AddChild, 'AddChild');
    RegisterMethod(@TALXMLDocument.CreateElement, 'CreateElement');
    RegisterMethod(@TALXMLDocument.CreateNode, 'CreateNode');
    RegisterMethod(@TALXMLDocument.IsEmptyDoc, 'IsEmptyDoc');
    RegisterMethod(@TALXMLDocument.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TALXMLDocument.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TALXMLDocument.LoadFromXML, 'LoadFromXML');
    RegisterMethod(@TALXMLDocument.SaveToFile, 'SaveToFile');
    RegisterMethod(@TALXMLDocument.SaveToStream, 'SaveToStream');
    RegisterMethod(@TALXMLDocument.SaveToXML, 'SaveToXML');
    RegisterPropertyHelper(@TALXMLDocumentChildNodes_R,nil,'ChildNodes');
    RegisterPropertyHelper(@TALXMLDocumentDocumentElement_R,@TALXMLDocumentDocumentElement_W,'DocumentElement');
    RegisterPropertyHelper(@TALXMLDocumentEncoding_R,@TALXMLDocumentEncoding_W,'Encoding');
    RegisterPropertyHelper(@TALXMLDocumentNode_R,nil,'Node');
    RegisterPropertyHelper(@TALXMLDocumentStandAlone_R,@TALXMLDocumentStandAlone_W,'StandAlone');
    RegisterPropertyHelper(@TALXMLDocumentfname_R,@TALXMLDocumentfname_W,'Filename');

    RegisterPropertyHelper(@TALXMLDocumentVersion_R,@TALXMLDocumentVersion_W,'Version');
    RegisterPropertyHelper(@TALXMLDocumentActive_R,@TALXMLDocumentActive_W,'Active');
    RegisterPropertyHelper(@TALXMLDocumentNodeIndentStr_R,@TALXMLDocumentNodeIndentStr_W,'NodeIndentStr');
    RegisterPropertyHelper(@TALXMLDocumentOptions_R,@TALXMLDocumentOptions_W,'Options');
    RegisterPropertyHelper(@TALXMLDocumentParseOptions_R,@TALXMLDocumentParseOptions_W,'ParseOptions');
    RegisterPropertyHelper(@TALXMLDocumentXML_R,@TALXMLDocumentXML_W,'XML');
    RegisterPropertyHelper(@TALXMLDocumentOnParseProcessingInstruction_R,@TALXMLDocumentOnParseProcessingInstruction_W,'OnParseProcessingInstruction');
    RegisterPropertyHelper(@TALXMLDocumentOnParseStartDocument_R,@TALXMLDocumentOnParseStartDocument_W,'OnParseStartDocument');
    RegisterPropertyHelper(@TALXMLDocumentOnParseEndDocument_R,@TALXMLDocumentOnParseEndDocument_W,'OnParseEndDocument');
    RegisterPropertyHelper(@TALXMLDocumentOnParseStartElement_R,@TALXMLDocumentOnParseStartElement_W,'OnParseStartElement');
    RegisterPropertyHelper(@TALXMLDocumentOnParseEndElement_R,@TALXMLDocumentOnParseEndElement_W,'OnParseEndElement');
    RegisterPropertyHelper(@TALXMLDocumentOnParseText_R,@TALXMLDocumentOnParseText_W,'OnParseText');
    RegisterPropertyHelper(@TALXMLDocumentOnParseComment_R,@TALXMLDocumentOnParseComment_W,'OnParseComment');
    RegisterPropertyHelper(@TALXMLDocumentOnParseCData_R,@TALXMLDocumentOnParseCData_W,'OnParseCData');
    RegisterPropertyHelper(@TALXMLDocumentTag_R,@TALXMLDocumentTag_W,'Tag');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlNotationNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlNotationNode) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlDocFragmentNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlDocFragmentNode) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlDocTypeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlDocTypeNode) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlEntityNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlEntityNode) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlEntityRefNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlEntityRefNode) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlCDataNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlCDataNode) do begin
    RegisterConstructor(@TALXmlCDataNode.Create, 'Create');
         RegisterMethod(@TALXMLCDataNode.Destroy, 'Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlProcessingInstrNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlProcessingInstrNode) do begin
    RegisterConstructor(@TALXmlProcessingInstrNode.Create, 'Create');
         RegisterMethod(@TALXmlProcessingInstrNode.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlCommentNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlCommentNode) do begin
    RegisterConstructor(@TALXmlCommentNode.Create, 'Create');
        RegisterMethod(@TALXmlCommentNode.Destroy, 'Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlDocumentNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlDocumentNode) do begin
    RegisterConstructor(@TALXmlDocumentNode.Create, 'Create');
    RegisterMethod(@TALXmlDocumentNode.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlTextNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlTextNode) do begin
    RegisterConstructor(@TALXmlTextNode.Create, 'Create');
         RegisterMethod(@TALXmlTextNode.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlAttributeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlAttributeNode) do begin
    RegisterConstructor(@TALXmlAttributeNode.Create, 'Create');
         RegisterMethod(@TALXmlAttributeNode.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXmlElementNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXmlElementNode) do begin
    RegisterConstructor(@TALXmlElementNode.Create, 'Create');
         RegisterMethod(@TALXmlElementNode.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXMLNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXMLNode) do begin
    RegisterConstructor(@TALXMLNode.Create, 'Create');
    RegisterMethod(@TALXMLNode.Destroy, 'Free');
    RegisterMethod(@TALXMLNode.CloneNode, 'CloneNode');
    RegisterMethod(@TALXMLNodeAddChild_P, 'AddChild');
    RegisterMethod(@TALXMLNodeHasAttribute_P, 'HasAttribute');
    RegisterMethod(@TALXMLNode.NextSibling, 'NextSibling');
    RegisterMethod(@TALXMLNode.PreviousSibling, 'PreviousSibling');
    RegisterPropertyHelper(@TALXMLNodeAttributeNodes_R,nil,'AttributeNodes');
    RegisterPropertyHelper(@TALXMLNodeAttributes_R,@TALXMLNodeAttributes_W,'Attributes');
    RegisterPropertyHelper(@TALXMLNodeChildNodes_R,@TALXMLNodeChildNodes_W,'ChildNodes');
    RegisterPropertyHelper(@TALXMLNodeHasChildNodes_R,nil,'HasChildNodes');
    RegisterPropertyHelper(@TALXMLNodeIsTextElement_R,nil,'IsTextElement');
    RegisterPropertyHelper(@TALXMLNodeLocalName_R,nil,'LocalName');
    RegisterPropertyHelper(@TALXMLNodeNodeName_R,@TALXMLNodeNodeName_W,'NodeName');
    RegisterPropertyHelper(@TALXMLNodeNodeType_R,nil,'NodeType');
    RegisterPropertyHelper(@TALXMLNodeNodeValue_R,@TALXMLNodeNodeValue_W,'NodeValue');
    RegisterPropertyHelper(@TALXMLNodeOwnerDocument_R,@TALXMLNodeOwnerDocument_W,'OwnerDocument');
    RegisterPropertyHelper(@TALXMLNodeParentNode_R,nil,'ParentNode');
    RegisterPropertyHelper(@TALXMLNodePrefix_R,nil,'Prefix');
    RegisterPropertyHelper(@TALXMLNodeText_R,@TALXMLNodeText_W,'Text');
    RegisterPropertyHelper(@TALXMLNodeXML_R,@TALXMLNodeXML_W,'XML');
    RegisterMethod(@TALXMLNode.SaveToStream, 'SaveToStream');
    RegisterMethod(@TALXMLNode.SaveToFile, 'SaveToFile');
    RegisterMethod(@TALXMLNode.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TALXMLNode.LoadFromStream, 'LoadFromStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALXMLNodeList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXMLNodeList) do begin
    RegisterConstructor(@TALXMLNodeList.Create, 'Create');
    RegisterMethod(@TALXMLNodeList.CustomSort, 'CustomSort');
     RegisterMethod(@TALXMLNodeList.Destroy, 'Free');
      RegisterMethod(@TALXMLNodeList.Add, 'Add');
    RegisterMethod(@TALXMLNodeListDelete_P, 'Delete');
    RegisterMethod(@TALXMLNodeListDelete1_P, 'Delete1');
    RegisterMethod(@TALXMLNodeListExtract_P, 'Extract');
    RegisterMethod(@TALXMLNodeListExtract1_P, 'Extract1');
    RegisterMethod(@TALXMLNodeList.Exchange, 'Exchange');
    RegisterMethod(@TALXMLNodeListFindNode_P, 'FindNode');
    RegisterMethod(@TALXMLNodeListFindNode1_P, 'FindNode1');
    RegisterMethod(@TALXMLNodeList.FindSibling, 'FindSibling');
    RegisterMethod(@TALXMLNodeList.First, 'First');
    RegisterMethod(@TALXMLNodeListIndexOf_P, 'IndexOf');
    RegisterMethod(@TALXMLNodeListIndexOf1_P, 'IndexOf1');
    RegisterMethod(@TALXMLNodeList.Last, 'Last');
    RegisterMethod(@TALXMLNodeList.Remove, 'Remove');
    RegisterMethod(@TALXMLNodeList.ReplaceNode, 'ReplaceNode');
    RegisterMethod(@TALXMLNodeList.Clear, 'Clear');
    RegisterMethod(@TALXMLNodeList.Insert, 'Insert');
    RegisterPropertyHelper(@TALXMLNodeListCount_R,nil,'Count');
    RegisterPropertyHelper(@TALXMLNodeListNodes_R,nil,'Nodes');
    RegisterPropertyHelper(@TALXMLNodeListNodes_R1,nil,'Nodes1');
    RegisterPropertyHelper(@TALXMLNodeListNodes_R2,nil,'Nodes2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EALXMLDocError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EALXMLDocError) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALXmlDoc(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALXMLNode) do
  with CL.Add(TALXMLNodeList) do
  with CL.Add(TALXMLDocument) do
  RIRegister_EALXMLDocError(CL);
  RIRegister_TALXMLNodeList(CL);
  RIRegister_TALXMLNode(CL);
  RIRegister_TALXmlElementNode(CL);
  RIRegister_TALXmlAttributeNode(CL);
  RIRegister_TALXmlTextNode(CL);
  RIRegister_TALXmlDocumentNode(CL);
  RIRegister_TALXmlCommentNode(CL);
  RIRegister_TALXmlProcessingInstrNode(CL);
  RIRegister_TALXmlCDataNode(CL);
  RIRegister_TALXmlEntityRefNode(CL);
  RIRegister_TALXmlEntityNode(CL);
  RIRegister_TALXmlDocTypeNode(CL);
  RIRegister_TALXmlDocFragmentNode(CL);
  RIRegister_TALXmlNotationNode(CL);
  RIRegister_TALXMLDocument(CL);
end;

 
 
{ TPSImport_ALXmlDoc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALXmlDoc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALXmlDoc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALXmlDoc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALXmlDoc(ri);
  RIRegister_ALXmlDoc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
