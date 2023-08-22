unit uPSI_SimpleXML;
{
check agaings the XMLDoc      IXMLNode --> IXMLnode2
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
  TPSImport_SimpleXML = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IXmlDocument2(CL: TPSPascalCompiler);
procedure SIRegister_IXmlProcessingInstruction(CL: TPSPascalCompiler);
procedure SIRegister_IXmlComment(CL: TPSPascalCompiler);
procedure SIRegister_IXmlCDATASection(CL: TPSPascalCompiler);
procedure SIRegister_IXmlText(CL: TPSPascalCompiler);
procedure SIRegister_IXmlCharacterData(CL: TPSPascalCompiler);
procedure SIRegister_IXmlElement(CL: TPSPascalCompiler);
procedure SIRegister_IXmlNode2(CL: TPSPascalCompiler);
procedure SIRegister_IXmlNodeList2(CL: TPSPascalCompiler);
procedure SIRegister_IXmlNameTable(CL: TPSPascalCompiler);
procedure SIRegister_IXmlBase(CL: TPSPascalCompiler);
procedure SIRegister_SimpleXML(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SimpleXML_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Types
  ,Windows
  ,SimpleXML
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimpleXML]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlDocument2(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXmlNode', 'IXmlDocument') do
  with CL.AddInterface(CL.FindInterface('IXmlBase'),IXmlNode2, 'IXmlDocument2') do begin
    RegisterMethod('Function Get_DocumentElement : IXmlElement', cdRegister);
    RegisterMethod('Function Get_BinaryXML : RawByteString', cdRegister);
    RegisterMethod('Function Get_PreserveWhiteSpace : Boolean', cdRegister);
    RegisterMethod('Procedure Set_PreserveWhiteSpace( aValue : Boolean)', cdRegister);
    RegisterMethod('Function Get_OnTagEnd : THookTag', cdRegister);
    RegisterMethod('Procedure Set_OnTagEnd( aValue : THookTag)', cdRegister);
    RegisterMethod('Function Get_OnTagBegin : THookTag', cdRegister);
    RegisterMethod('Procedure Set_OnTagBegin( aValue : THookTag)', cdRegister);
    RegisterMethod('Function NewDocument( const aVersion, anEncoding : TXmlString; aRootElementNameID : NativeInt) : IXmlElement;', cdRegister);
    RegisterMethod('Function NewDocument1( const aVersion, anEncoding, aRootElementName : TXmlString) : IXmlElement;', cdRegister);
    RegisterMethod('Function CreateElement( aNameID : NativeInt) : IXmlElement;', cdRegister);
    RegisterMethod('Function CreateElement1( const aName : TXmlString) : IXmlElement;', cdRegister);
    RegisterMethod('Function CreateText( const aData : TXmlString) : IXmlText', cdRegister);
    RegisterMethod('Function CreateCDATASection( const aData : TXmlString) : IXmlCDATASection', cdRegister);
    RegisterMethod('Function CreateComment( const aData : TXmlString) : IXmlComment', cdRegister);
    RegisterMethod('Function CreateProcessingInstruction( const aTarget, aData : TXmlString) : IXmlProcessingInstruction;', cdRegister);
    RegisterMethod('Function CreateProcessingInstruction1( aTargetID : NativeInt; const aData : TXmlString) : IXmlProcessingInstruction;', cdRegister);
    RegisterMethod('Procedure LoadXML( const aXML : RawByteString)', cdRegister);
    RegisterMethod('Procedure LoadBinaryXML( const aXML : RawByteString)', cdRegister);
    RegisterMethod('Procedure Load( aStream : TStream);', cdRegister);
    RegisterMethod('Procedure Load1( const aFileName : String);', cdRegister);
    RegisterMethod('Procedure LoadResource( aType, aName : PChar)', cdRegister);
    RegisterMethod('Procedure Save( aStream : TStream);', cdRegister);
    RegisterMethod('Procedure Save1( const aFileName : String);', cdRegister);
    RegisterMethod('Procedure SaveBinary( aStream : TStream; anOptions : LongWord);', cdRegister);
    RegisterMethod('Procedure SaveBinary1( const aFileName : String; anOptions : LongWord);', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlProcessingInstruction(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXmlNode2', 'IXmlProcessingInstruction') do
  with CL.AddInterface(CL.FindInterface('IXmlNode2'),IXmlProcessingInstruction, 'IXmlProcessingInstruction') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlComment(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXmlCharacterData', 'IXmlComment') do
  with CL.AddInterface(CL.FindInterface('IXmlCharacterData'),IXmlComment, 'IXmlComment') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlCDATASection(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXmlCharacterData', 'IXmlCDATASection') do
  with CL.AddInterface(CL.FindInterface('IXmlCharacterData'),IXmlCDATASection, 'IXmlCDATASection') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlText(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXmlCharacterData', 'IXmlText') do
  with CL.AddInterface(CL.FindInterface('IXmlCharacterData'),IXmlText, 'IXmlText') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlCharacterData(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXmlNode2', 'IXmlCharacterData') do
  with CL.AddInterface(CL.FindInterface('IXmlNode2'),IXmlCharacterData, 'IXmlCharacterData') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlElement(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXmlNode2', 'IXmlElement') do
  with CL.AddInterface(CL.FindInterface('IXmlNode2'),IXmlElement, 'IXmlElement') do begin
    RegisterMethod('Procedure ReplaceTextByCDATASection( const aText : TXmlString)', cdRegister);
    RegisterMethod('Procedure ReplaceTextByBinaryData( const aData, aSize : Integer; aMaxLineLength : Integer)', cdRegister);
    RegisterMethod('Function GetTextAsBinaryData : TBytes', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlNode2(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXmlBase', 'IXmlNode') do
  with CL.AddInterface(CL.FindInterface('IXmlBase'),IXmlNode2, 'IXmlNode2') do begin
    RegisterMethod('Function Get_NameTable : IXmlNameTable', cdRegister);
    RegisterMethod('Function Get_NodeName : TXmlString', cdRegister);
    RegisterMethod('Function Get_NodeNameID : NativeInt', cdRegister);
    RegisterMethod('Function Get_NodeType : TXmlNodeType', cdRegister);
    RegisterMethod('Function Get_Text : TXmlString', cdRegister);
    RegisterMethod('Procedure Set_Text( const aValue : TXmlString)', cdRegister);
    RegisterMethod('Function Get_DataType : Integer', cdRegister);
    RegisterMethod('Function Get_TypedValue : Variant', cdRegister);
    RegisterMethod('Procedure Set_TypedValue( const aValue : Variant)', cdRegister);
    RegisterMethod('Function Get_XML : TXmlString', cdRegister);
    RegisterMethod('Function CloneNode( aDeep : Boolean) : IXmlNode2', cdRegister);
    RegisterMethod('Function Get_ParentNode : IXmlNode2', cdRegister);
    RegisterMethod('Function Get_OwnerDocument : IXmlDocument2', cdRegister);
    RegisterMethod('Function Get_ChildNodes : IXmlNodeList2', cdRegister);
    RegisterMethod('Procedure AppendChild( const aChild : IXmlNode2)', cdRegister);
    RegisterMethod('Procedure InsertBefore( const aChild, aBefore : IXmlNode2)', cdRegister);
    RegisterMethod('Procedure ReplaceChild( const aNewChild, anOldChild : IXmlNode2)', cdRegister);
    RegisterMethod('Procedure RemoveChild( const aChild : IXmlNode2)', cdRegister);
    RegisterMethod('Procedure ExchangeChilds( const aChild1, aChild2 : IXmlNode2)', cdRegister);
    RegisterMethod('Function AppendElement( aNameID : NativeInt) : IXmlElement;', cdRegister);
    RegisterMethod('Function AppendElement1( const aName : TxmlString) : IXmlElement;', cdRegister);
    RegisterMethod('Function AppendText( const aData : TXmlString) : IXmlText', cdRegister);
    RegisterMethod('Function AppendCDATA( const aData : TXmlString) : IXmlCDATASection', cdRegister);
    RegisterMethod('Function AppendComment( const aData : TXmlString) : IXmlComment', cdRegister);
    RegisterMethod('Function AppendProcessingInstruction( aTargetID : NativeInt; const aData : TXmlString) : IXmlProcessingInstruction;', cdRegister);
    RegisterMethod('Function AppendProcessingInstruction1( const aTarget : TXmlString; const aData : TXmlString) : IXmlProcessingInstruction;', cdRegister);
    RegisterMethod('Function GetChildText( const aName : TXmlString; const aDefault : TXmlString) : TXmlString;', cdRegister);
    RegisterMethod('Function GetChildText1( aNameID : NativeInt; const aDefault : TXmlString) : TXmlString;', cdRegister);
    RegisterMethod('Procedure SetChildText( const aName, aValue : TXmlString);', cdRegister);
    RegisterMethod('Procedure SetChildText1( aNameID : NativeInt; const aValue : TXmlString);', cdRegister);
    RegisterMethod('Function NeedChild( aNameID : NativeInt) : IXmlNode2;', cdRegister);
    RegisterMethod('Function NeedChild1( const aName : TXmlString) : IXmlNode2;', cdRegister);
    RegisterMethod('Function EnsureChild( aNameID : NativeInt) : IXmlNode2;', cdRegister);
    RegisterMethod('Function EnsureChild1( const aName : TXmlString) : IXmlNode2;', cdRegister);
    RegisterMethod('Procedure RemoveAllChilds', cdRegister);
    RegisterMethod('Function SelectNodes( const anExpression : TXmlString) : IXmlNodeList2', cdRegister);
    RegisterMethod('Function SelectSingleNode( const anExpression : TXmlString) : IXmlNode2', cdRegister);
    RegisterMethod('Function FullPath : TXmlString', cdRegister);
    RegisterMethod('Function FindElement( const anElementName, anAttrName : String; const anAttrValue : Variant) : IXmlElement', cdRegister);
    RegisterMethod('Function Get_AttrCount : Integer', cdRegister);
    RegisterMethod('Function Get_AttrNameID( anIndex : Integer) : NativeInt', cdRegister);
    RegisterMethod('Function Get_AttrName( anIndex : Integer) : TXmlString', cdRegister);
    RegisterMethod('Procedure RemoveAttr( const aName : TXmlString);', cdRegister);
    RegisterMethod('Procedure RemoveAttr1( aNameID : NativeInt);', cdRegister);
    RegisterMethod('Procedure RemoveAllAttrs', cdRegister);
    RegisterMethod('Function AttrExists( aNameID : NativeInt) : Boolean;', cdRegister);
    RegisterMethod('Function AttrExists1( const aName : TXmlString) : Boolean;', cdRegister);
    RegisterMethod('Function GetAttrType( aNameID : NativeInt) : Integer;', cdRegister);
    RegisterMethod('Function GetAttrType1( const aName : TXmlString) : Integer;', cdRegister);
    RegisterMethod('Function GetVarAttr( aNameID : NativeInt; const aDefault : Variant) : Variant;', cdRegister);
    RegisterMethod('Function GetVarAttr1( const aName : TXmlString; const aDefault : Variant) : Variant;', cdRegister);
    RegisterMethod('Procedure SetVarAttr( aNameID : NativeInt; const aValue : Variant);', cdRegister);
    RegisterMethod('Procedure SetVarAttr1( const aName : TXmlString; aValue : Variant);', cdRegister);
    RegisterMethod('Function NeedAttr( aNameID : NativeInt) : TXmlString;', cdRegister);
    RegisterMethod('Function NeedAttr1( const aName : TXmlString) : TXmlString;', cdRegister);
    RegisterMethod('Function GetAttr( aNameID : NativeInt; const aDefault : TXmlString) : TXmlString;', cdRegister);
    RegisterMethod('Function GetAttr1( const aName : TXmlString; const aDefault : TXmlString) : TXmlString;', cdRegister);
    RegisterMethod('Procedure SetAttr( aNameID : NativeInt; const aValue : TXmlString);', cdRegister);
    RegisterMethod('Procedure SetAttr1( const aName, aValue : TXmlString);', cdRegister);
    RegisterMethod('Function GetBytesAttr( aNameID : NativeInt; const aDefault : TBytes) : TBytes;', cdRegister);
    RegisterMethod('Function GetBytesAttr1( const aName : TXmlString; const aDefault : TBytes) : TBytes;', cdRegister);
    RegisterMethod('Function GetBoolAttr( aNameID : NativeInt; aDefault : Boolean) : Boolean;', cdRegister);
    RegisterMethod('Function GetBoolAttr1( const aName : TXmlString; aDefault : Boolean) : Boolean;', cdRegister);
    RegisterMethod('Procedure SetBoolAttr( aNameID : NativeInt; aValue : Boolean);', cdRegister);
    RegisterMethod('Procedure SetBoolAttr1( const aName : TXmlString; aValue : Boolean);', cdRegister);
    RegisterMethod('Function GetIntAttr( aNameID : NativeInt; aDefault : Integer) : Integer;', cdRegister);
    RegisterMethod('Function GetIntAttr1( const aName : TXmlString; aDefault : Integer) : Integer;', cdRegister);
    RegisterMethod('Procedure SetIntAttr( aNameID : NativeInt; aValue : Integer);', cdRegister);
    RegisterMethod('Procedure SetIntAttr1( const aName : TXmlString; aValue : Integer);', cdRegister);
    RegisterMethod('Function GetDateTimeAttr( aNameID : NativeInt; aDefault : TDateTime) : TDateTime;', cdRegister);
    RegisterMethod('Function GetDateTimeAttr1( const aName : TXmlString; aDefault : TDateTime) : TDateTime;', cdRegister);
    RegisterMethod('Procedure SetDateTimeAttr( aNameID : NativeInt; aValue : TDateTime);', cdRegister);
    RegisterMethod('Procedure SetDateTimeAttr1( const aName : TXmlString; aValue : TDateTime);', cdRegister);
    RegisterMethod('Function GetFloatAttr( aNameID : NativeInt; aDefault : Double) : Double;', cdRegister);
    RegisterMethod('Function GetFloatAttr1( const aName : TXmlString; aDefault : Double) : Double;', cdRegister);
    RegisterMethod('Procedure SetFloatAttr( aNameID : NativeInt; aValue : Double);', cdRegister);
    RegisterMethod('Procedure SetFloatAttr1( const aName : TXmlString; aValue : Double);', cdRegister);
    RegisterMethod('Function GetHexAttr( const aName : TXmlString; aDefault : Integer) : Integer;', cdRegister);
    RegisterMethod('Function GetHexAttr1( aNameID : NativeInt; aDefault : Integer) : Integer;', cdRegister);
    RegisterMethod('Procedure SetHexAttr( const aName : TXmlString; aValue : Integer; aDigits : Integer);', cdRegister);
    RegisterMethod('Procedure SetHexAttr1( aNameID : NativeInt; aValue : Integer; aDigits : Integer);', cdRegister);
    RegisterMethod('Function GetEnumAttr( const aName : TXmlString; const aValues : array of TXmlString; aDefault : Integer) : Integer;', cdRegister);
    RegisterMethod('Function GetEnumAttr1( aNameID : NativeInt; const aValues : array of TXmlString; aDefault : Integer) : Integer;', cdRegister);
    RegisterMethod('Function NeedEnumAttr( const aName : TXmlString; const aValues : array of TXmlString) : Integer;', cdRegister);
    RegisterMethod('Function NeedEnumAttr1( aNameID : NativeInt; const aValues : array of TXmlString) : Integer;', cdRegister);
    RegisterMethod('Function Get_Values( const aName : String) : Variant', cdRegister);
    RegisterMethod('Procedure Set_Values( const aName : String; const aValue : Variant)', cdRegister);
    RegisterMethod('Function AsElement : IXmlElement', cdRegister);
    RegisterMethod('Function AsText : IXmlText', cdRegister);
    RegisterMethod('Function AsCDATASection : IXmlCDATASection', cdRegister);
    RegisterMethod('Function AsComment : IXmlComment', cdRegister);
    RegisterMethod('Function AsProcessingInstruction : IXmlProcessingInstruction', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlNodeList2(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXmlBase', 'IXmlNodeList') do
  with CL.AddInterface(CL.FindInterface('IXmlBase'),IXmlNodeList2, 'IXmlNodeList2') do
  begin
    RegisterMethod('Function Get_Count : Integer', cdRegister);
    RegisterMethod('Function Get_Item( anIndex : Integer) : IXmlNode2', cdRegister);
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)', cdRegister);
    RegisterMethod('Function Get_XML : TXmlString', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlNameTable(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXmlBase', 'IXmlNameTable') do
  with CL.AddInterface(CL.FindInterface('IXmlBase'),IXmlNameTable, 'IXmlNameTable') do
  begin
    RegisterMethod('Function GetID( const aName : TXmlString) : NativeInt', cdRegister);
    RegisterMethod('Function GetName( anID : NativeInt) : TXmlString', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlBase(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IXmlBase') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlBase, 'IXmlBase') do begin
    RegisterMethod('Function GetObject : TObject', cdRegister);
  end;
end;

const
  BinXmlSignatureSize = Length('< binary-xml >');
  BinXmlSignature: AnsiString = '< binary-xml >';

(*----------------------------------------------------------------------------*)
procedure SIRegister_SimpleXML(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('BinXmlSignatureSize','Integer').SetInt(BinXmlSignatureSize);
 CL.AddConstantN('BinXmlSignature','String').SetString(BinXmlSignature);

 //&&CL.AddConstantN('BinXmlSignatureSize','String').SetString( Length ( '< binary-xml >' ));
 //CL.AddConstantN('BinXmlSignature','AnsiString').SetString( '< binary-xml >');
 CL.AddConstantN('BINXML_USE_WIDE_CHARS','LongInt').SetInt( 1);
 CL.AddConstantN('BINXML_COMPRESSED','LongInt').SetInt( 2);
 CL.AddConstantN('DefaultHashSize','LongInt').SetInt( 499);
 CL.AddConstantN('AnsiCodepage','Integer').SetInt( CP_ACP);
 CL.AddConstantN('XSTR_NULL','String').SetString( '{{null}}');
 CL.AddConstantN('SourceBufferSize','LongWord').SetUInt( $4000);
  //CL.AddTypeS('PXmlChar', 'PWideChar');
  //CL.AddTypeS('TXmlChar', 'WideChar');
  //CL.AddTypeS('TXmlString', 'WideString');
  CL.AddTypeS('PXmlChar', 'PChar');
  CL.AddTypeS('TXmlChar', 'Char');
  CL.AddTypeS('TXmlString', 'String');
  //CL.AddTypeS('PXmlChar', 'PChar');
  //CL.AddTypeS('TXmlChar', 'Char');
  //CL.AddTypeS('TXmlString', 'String');
  CL.AddTypeS('RawByteString', 'AnsiString');
  //CL.AddTypeS('TBytes', 'TByteDynArray');
  CL.AddTypeS('NativeInt', 'Integer');
  //CL.AddTypeS('IXMLNode', 'IInterface');

  CL.AddTypeS('TXmlNodeType', '( NODE_INVALID, NODE_ELEMENT, NODE_TEXT, NODE_CD'
   +'ATA_SECTION, NODE_PROCESSING_INSTRUCTION, NODE_COMMENT, NODE_DOCUMENT )');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlNode2, 'IXmlNode2');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlDocument2, 'IXmlDocument2');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlElement, 'IXmlElement');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlText, 'IXmlText');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlCDATASection, 'IXmlCDATASection');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlComment, 'IXmlComment');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlProcessingInstruction, 'IXmlProcessingInstruction');
  //CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlNode2, 'IXmlNode2');
  SIRegister_IXmlBase(CL);
  SIRegister_IXmlNameTable(CL);
  //CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlNode, 'IXmlNode');
  //CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInterface, 'IXmlNode');

  SIRegister_IXmlNodeList2(CL);
  SIRegister_IXmlNode2(CL);

  SIRegister_IXmlElement(CL);
  SIRegister_IXmlCharacterData(CL);
  SIRegister_IXmlText(CL);
  SIRegister_IXmlCDATASection(CL);
  SIRegister_IXmlComment(CL);
  SIRegister_IXmlProcessingInstruction(CL);//}
  CL.AddTypeS('THookTag', 'Procedure ( Sender : TObject; aNode : IXmlNode2)');
  SIRegister_IXmlDocument2(CL);
 CL.AddDelphiFunction('Function CreateNameTable( aHashTableSize : Integer) : IXmlNameTable');
 CL.AddDelphiFunction('Function CreateXmlDocument( const aRootElementName : String; const aVersion : String; const anEncoding : String; const aNameTable : IXmlNameTable) : IXmlDocument2');
 CL.AddDelphiFunction('Function CreateXmlElement( const aName : TXmlString; const aNameTable : IXmlNameTable) : IXmlElement');
 CL.AddDelphiFunction('Function LoadXmlDocumentFromXML( const aXML : RawByteString) : IXmlDocument2');
 CL.AddDelphiFunction('Function LoadXmlDocumentFromBinaryXML( const aXML : RawByteString) : IXmlDocument2');
 CL.AddDelphiFunction('Function LoadXmlDocument( aStream : TStream) : IXmlDocument2;');
 CL.AddDelphiFunction('Function LoadXmlDocument1( const aFileName : String) : IXmlDocument2;');
 CL.AddDelphiFunction('Function LoadXmlDocument2( aResType, aResName : PChar) : IXmlDocument2;');
 CL.AddDelphiFunction('Function XSTRToFloat( const s : TXmlString) : Double');
 CL.AddDelphiFunction('Function FloatToXSTR( v : Double) : TXmlString');
 CL.AddDelphiFunction('Function DateTimeToXSTR( v : TDateTime) : TXmlString');
 CL.AddDelphiFunction('Function XSTRToDateTime( const s : String) : TDateTime');
 CL.AddDelphiFunction('Function VarToXSTR( const v : TVarData) : TXmlString');
 CL.AddDelphiFunction('Function TextToXML( const aText : TXmlString) : TXmlString');
 CL.AddDelphiFunction('Function BinToBase64( const aBin, aSize : Integer; aMaxLineLength : Integer) : TXmlString');
 CL.AddDelphiFunction('Function Base64ToBin( const aBase64 : TXmlString) : TBytes');
 CL.AddDelphiFunction('Function IsXmlDataString( const aData : RawByteString) : Boolean');
 CL.AddDelphiFunction('Function XmlIsInBinaryFormat( const aData : RawByteString) : Boolean');
 CL.AddDelphiFunction('Procedure PrepareToSaveXml( var anElem : IXmlElement; const aChildName : String)');
 CL.AddDelphiFunction('Function PrepareToLoadXml( var anElem : IXmlElement; const aChildName : String) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function LoadXmlDocument2_P( aResType, aResName : PChar) : IXmlDocument2;
Begin Result := SimpleXML.LoadXmlDocument(aResType, aResName); END;

(*----------------------------------------------------------------------------*)
Function LoadXmlDocument1_P( const aFileName : String) : IXmlDocument2;
Begin Result := SimpleXML.LoadXmlDocument(aFileName); END;

(*----------------------------------------------------------------------------*)
Function LoadXmlDocument_P( aStream : TStream) : IXmlDocument2;
Begin Result := SimpleXML.LoadXmlDocument(aStream); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentSaveBinary1_P(Self: IXmlDocument2;  const aFileName : String; anOptions : LongWord);
Begin Self.SaveBinary(aFileName, anOptions); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentSaveBinary_P(Self: IXmlDocument2;  aStream : TStream; anOptions : LongWord);
Begin Self.SaveBinary(aStream, anOptions); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentSave1_P(Self: IXmlDocument2;  const aFileName : String);
Begin Self.Save(aFileName); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentSave_P(Self: IXmlDocument2;  aStream : TStream);
Begin Self.Save(aStream); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentLoad1_P(Self: IXmlDocument2;  const aFileName : String);
Begin Self.Load(aFileName); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentLoad_P(Self: IXmlDocument2;  aStream : TStream);
Begin Self.Load(aStream); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentCreateProcessingInstruction1_P(Self: IXmlDocument2;  aTargetID : NativeInt; const aData : TXmlString) : IXmlProcessingInstruction;
Begin Result := Self.CreateProcessingInstruction(aTargetID, aData); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentCreateProcessingInstruction_P(Self: IXmlDocument2;  const aTarget, aData : TXmlString) : IXmlProcessingInstruction;
Begin Result := Self.CreateProcessingInstruction(aTarget, aData); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentCreateElement1_P(Self: IXmlDocument2;  const aName : TXmlString) : IXmlElement;
Begin Result := Self.CreateElement(aName); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentCreateElement_P(Self: IXmlDocument2;  aNameID : NativeInt) : IXmlElement;
Begin Result := Self.CreateElement(aNameID); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentNewDocument1_P(Self: IXmlDocument2;  const aVersion, anEncoding, aRootElementName : TXmlString) : IXmlElement;
Begin Result := Self.NewDocument(aVersion, anEncoding, aRootElementName); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentNewDocument_P(Self: IXmlDocument2;  const aVersion, anEncoding : TXmlString; aRootElementNameID : NativeInt) : IXmlElement;
Begin Result := Self.NewDocument(aVersion, anEncoding, aRootElementNameID); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeNeedEnumAttr1_P(Self: IXmlNode2;  aNameID : NativeInt; const aValues : array of TXmlString) : Integer;
Begin Result := Self.NeedEnumAttr(aNameID, aValues); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeNeedEnumAttr_P(Self: IXmlNode2;  const aName : TXmlString; const aValues : array of TXmlString) : Integer;
Begin Result := Self.NeedEnumAttr(aName, aValues); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetEnumAttr1_P(Self: IXmlNode2;  aNameID : NativeInt; const aValues : array of TXmlString; aDefault : Integer) : Integer;
Begin Result := Self.GetEnumAttr(aNameID, aValues, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetEnumAttr_P(Self: IXmlNode2;  const aName : TXmlString; const aValues : array of TXmlString; aDefault : Integer) : Integer;
Begin Result := Self.GetEnumAttr(aName, aValues, aDefault); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetHexAttr1_P(Self: IXmlNode2;  aNameID : NativeInt; aValue : Integer; aDigits : Integer);
Begin Self.SetHexAttr(aNameID, aValue, aDigits); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetHexAttr_P(Self: IXmlNode2;  const aName : TXmlString; aValue : Integer; aDigits : Integer);
Begin Self.SetHexAttr(aName, aValue, aDigits); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetHexAttr1_P(Self: IXmlNode2;  aNameID : NativeInt; aDefault : Integer) : Integer;
Begin Result := Self.GetHexAttr(aNameID, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetHexAttr_P(Self: IXmlNode2;  const aName : TXmlString; aDefault : Integer) : Integer;
Begin Result := Self.GetHexAttr(aName, aDefault); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetFloatAttr1_P(Self: IXmlNode2;  const aName : TXmlString; aValue : Double);
Begin Self.SetFloatAttr(aName, aValue); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetFloatAttr_P(Self: IXmlNode2;  aNameID : NativeInt; aValue : Double);
Begin Self.SetFloatAttr(aNameID, aValue); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetFloatAttr1_P(Self: IXmlNode2;  const aName : TXmlString; aDefault : Double) : Double;
Begin Result := Self.GetFloatAttr(aName, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetFloatAttr_P(Self: IXmlNode2;  aNameID : NativeInt; aDefault : Double) : Double;
Begin Result := Self.GetFloatAttr(aNameID, aDefault); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetDateTimeAttr1_P(Self: IXmlNode2;  const aName : TXmlString; aValue : TDateTime);
Begin Self.SetDateTimeAttr(aName, aValue); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetDateTimeAttr_P(Self: IXmlNode2;  aNameID : NativeInt; aValue : TDateTime);
Begin Self.SetDateTimeAttr(aNameID, aValue); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetDateTimeAttr1_P(Self: IXmlNode2;  const aName : TXmlString; aDefault : TDateTime) : TDateTime;
Begin Result := Self.GetDateTimeAttr(aName, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetDateTimeAttr_P(Self: IXmlNode2;  aNameID : NativeInt; aDefault : TDateTime) : TDateTime;
Begin Result := Self.GetDateTimeAttr(aNameID, aDefault); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetIntAttr1_P(Self: IXmlNode2;  const aName : TXmlString; aValue : Integer);
Begin Self.SetIntAttr(aName, aValue); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetIntAttr_P(Self: IXmlNode2;  aNameID : NativeInt; aValue : Integer);
Begin Self.SetIntAttr(aNameID, aValue); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetIntAttr1_P(Self: IXmlNode2;  const aName : TXmlString; aDefault : Integer) : Integer;
Begin Result := Self.GetIntAttr(aName, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetIntAttr_P(Self: IXmlNode2;  aNameID : NativeInt; aDefault : Integer) : Integer;
Begin Result := Self.GetIntAttr(aNameID, aDefault); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetBoolAttr1_P(Self: IXmlNode2;  const aName : TXmlString; aValue : Boolean);
Begin Self.SetBoolAttr(aName, aValue); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetBoolAttr_P(Self: IXmlNode2;  aNameID : NativeInt; aValue : Boolean);
Begin Self.SetBoolAttr(aNameID, aValue); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetBoolAttr1_P(Self: IXmlNode2;  const aName : TXmlString; aDefault : Boolean) : Boolean;
Begin Result := Self.GetBoolAttr(aName, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetBoolAttr_P(Self: IXmlNode2;  aNameID : NativeInt; aDefault : Boolean) : Boolean;
Begin Result := Self.GetBoolAttr(aNameID, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetBytesAttr1_P(Self: IXmlNode2;  const aName : TXmlString; const aDefault : TBytes) : TBytes;
Begin Result := Self.GetBytesAttr(aName, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetBytesAttr_P(Self: IXmlNode2;  aNameID : NativeInt; const aDefault : TBytes) : TBytes;
Begin Result := Self.GetBytesAttr(aNameID, aDefault); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetAttr1_P(Self: IXmlNode2;  const aName, aValue : TXmlString);
Begin Self.SetAttr(aName, aValue); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetAttr_P(Self: IXmlNode2;  aNameID : NativeInt; const aValue : TXmlString);
Begin Self.SetAttr(aNameID, aValue); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetAttr1_P(Self: IXmlNode2;  const aName : TXmlString; const aDefault : TXmlString) : TXmlString;
Begin Result := Self.GetAttr(aName, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetAttr_P(Self: IXmlNode2;  aNameID : NativeInt; const aDefault : TXmlString) : TXmlString;
Begin Result := Self.GetAttr(aNameID, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeNeedAttr1_P(Self: IXmlNode2;  const aName : TXmlString) : TXmlString;
Begin Result := Self.NeedAttr(aName); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeNeedAttr_P(Self: IXmlNode2;  aNameID : NativeInt) : TXmlString;
Begin Result := Self.NeedAttr(aNameID); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetVarAttr1_P(Self: IXmlNode2;  const aName : TXmlString; aValue : Variant);
Begin Self.SetVarAttr(aName, aValue); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetVarAttr_P(Self: IXmlNode2;  aNameID : NativeInt; const aValue : Variant);
Begin Self.SetVarAttr(aNameID, aValue); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetVarAttr1_P(Self: IXmlNode2;  const aName : TXmlString; const aDefault : Variant) : Variant;
Begin Result := Self.GetVarAttr(aName, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetVarAttr_P(Self: IXmlNode2;  aNameID : NativeInt; const aDefault : Variant) : Variant;
Begin Result := Self.GetVarAttr(aNameID, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetAttrType1_P(Self: IXmlNode2;  const aName : TXmlString) : Integer;
Begin Result := Self.GetAttrType(aName); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetAttrType_P(Self: IXmlNode2;  aNameID : NativeInt) : Integer;
Begin Result := Self.GetAttrType(aNameID); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeAttrExists1_P(Self: IXmlNode2;  const aName : TXmlString) : Boolean;
Begin Result := Self.AttrExists(aName); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeAttrExists_P(Self: IXmlNode2;  aNameID : NativeInt) : Boolean;
Begin Result := Self.AttrExists(aNameID); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeRemoveAttr1_P(Self: IXmlNode2;  aNameID : NativeInt);
Begin Self.RemoveAttr(aNameID); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeRemoveAttr_P(Self: IXmlNode2;  const aName : TXmlString);
Begin Self.RemoveAttr(aName); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeEnsureChild1_P(Self: IXmlNode2;  const aName : TXmlString) : IXmlNode2;
Begin Result := Self.EnsureChild(aName); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeEnsureChild_P(Self: IXmlNode2;  aNameID : NativeInt) : IXmlNode2;
Begin Result := Self.EnsureChild(aNameID); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeNeedChild1_P(Self: IXmlNode2;  const aName : TXmlString) : IXmlNode2;
Begin Result := Self.NeedChild(aName); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeNeedChild_P(Self: IXmlNode2;  aNameID : NativeInt) : IXmlNode2;
Begin Result := Self.NeedChild(aNameID); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetChildText1_P(Self: IXmlNode2;  aNameID : NativeInt; const aValue : TXmlString);
Begin Self.SetChildText(aNameID, aValue); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlNodeSetChildText_P(Self: IXmlNode2;  const aName, aValue : TXmlString);
Begin Self.SetChildText(aName, aValue); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetChildText1_P(Self: IXmlNode2;  aNameID : NativeInt; const aDefault : TXmlString) : TXmlString;
Begin Result := Self.GetChildText(aNameID, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeGetChildText_P(Self: IXmlNode2;  const aName : TXmlString; const aDefault : TXmlString) : TXmlString;
Begin Result := Self.GetChildText(aName, aDefault); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeAppendProcessingInstruction1_P(Self: IXmlNode2;  const aTarget : TXmlString; const aData : TXmlString) : IXmlProcessingInstruction;
Begin Result := Self.AppendProcessingInstruction(aTarget, aData); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeAppendProcessingInstruction_P(Self: IXmlNode2;  aTargetID : NativeInt; const aData : TXmlString) : IXmlProcessingInstruction;
Begin Result := Self.AppendProcessingInstruction(aTargetID, aData); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeAppendElement1_P(Self: IXmlNode2;  const aName : TxmlString) : IXmlElement;
Begin Result := Self.AppendElement(aName); END;

(*----------------------------------------------------------------------------*)
Function IXmlNodeAppendElement_P(Self: IXmlNode2;  aNameID : NativeInt) : IXmlElement;
Begin Result := Self.AppendElement(aNameID); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleXML_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateNameTable, 'CreateNameTable', cdRegister);
 S.RegisterDelphiFunction(@CreateXmlDocument, 'CreateXmlDocument', cdRegister);
 S.RegisterDelphiFunction(@CreateXmlElement, 'CreateXmlElement', cdRegister);
 S.RegisterDelphiFunction(@LoadXmlDocumentFromXML, 'LoadXmlDocumentFromXML', cdRegister);
 S.RegisterDelphiFunction(@LoadXmlDocumentFromBinaryXML, 'LoadXmlDocumentFromBinaryXML', cdRegister);
 S.RegisterDelphiFunction(@LoadXmlDocument, 'LoadXmlDocument', cdRegister);
 S.RegisterDelphiFunction(@LoadXmlDocument1_P, 'LoadXmlDocument1', cdRegister);
 S.RegisterDelphiFunction(@LoadXmlDocument2_P, 'LoadXmlDocument2', cdRegister);
 S.RegisterDelphiFunction(@XSTRToFloat, 'XSTRToFloat', cdRegister);
 S.RegisterDelphiFunction(@FloatToXSTR, 'FloatToXSTR', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToXSTR, 'DateTimeToXSTR', cdRegister);
 S.RegisterDelphiFunction(@XSTRToDateTime, 'XSTRToDateTime', cdRegister);
 S.RegisterDelphiFunction(@VarToXSTR, 'VarToXSTR', cdRegister);
 S.RegisterDelphiFunction(@TextToXML, 'TextToXML', cdRegister);
 S.RegisterDelphiFunction(@BinToBase64, 'BinToBase64', cdRegister);
 S.RegisterDelphiFunction(@Base64ToBin, 'Base64ToBin', cdRegister);
 S.RegisterDelphiFunction(@IsXmlDataString, 'IsXmlDataString', cdRegister);
 S.RegisterDelphiFunction(@XmlIsInBinaryFormat, 'XmlIsInBinaryFormat', cdRegister);
 S.RegisterDelphiFunction(@PrepareToSaveXml, 'PrepareToSaveXml', cdRegister);
 S.RegisterDelphiFunction(@PrepareToLoadXml, 'PrepareToLoadXml', cdRegister);
end;

 
 
{ TPSImport_SimpleXML }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleXML.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SimpleXML(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleXML.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SimpleXML_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
