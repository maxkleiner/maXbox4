unit uPSI_SimpleXML;
{
   some xML on maXML IXMLNode
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
procedure SIRegister_IXmlDocument(CL: TPSPascalCompiler);
procedure SIRegister_SimpleXML(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SimpleXML_Routines(S: TPSExec);

procedure Register;

implementation


uses
   SimpleXML
  ,Types
  ,Windows
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimpleXML]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IXmlDocument(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('IXMLNode', 'IInterface');

  with CL.AddInterface(CL.FindInterface('IInterface'),IXmlDocument, 'IXmlDocument') do
  begin
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

const
  BinXmlSignatureSize = Length('< binary-xml >');
  BinXmlSignature: AnsiString = '< binary-xml >';

(*----------------------------------------------------------------------------*)
procedure SIRegister_SimpleXML(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('BinXmlSignatureSize','Integer').SetInt(BinXmlSignatureSize);
 CL.AddConstantN('BinXmlSignature','String').SetString(BinXmlSignature);
 CL.AddConstantN('BINXML_USE_WIDE_CHARS','LongInt').SetInt(BINXML_USE_WIDE_CHARS);
 CL.AddConstantN('BINXML_COMPRESSED','LongInt').SetInt(BINXML_COMPRESSED);
 CL.AddConstantN('DefaultHashSize','LongInt').SetInt(DefaultHashSize);
 CL.AddConstantN('AnsiCodepage','Integer').SetInt(AnsiCodepage);
 CL.AddConstantN('XSTR_NULL','String').SetString(XSTR_NULL);
 CL.AddConstantN('SourceBufferSize','LongWord').SetUInt(SourceBufferSize);
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
  //CL.AddTypeS('IXMLNode', 'Interface');

  CL.AddTypeS('TXmlNodeType', '( NODE_INVALID, NODE_ELEMENT, NODE_TEXT, NODE_CD'
   +'ATA_SECTION, NODE_PROCESSING_INSTRUCTION, NODE_COMMENT, NODE_DOCUMENT )');
  //IXmlNameTable = interface(IXmlBase)
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlNameTable, 'IXmlNameTable');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInterface, 'IXmlNode');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlDocument, 'IXmlDocument');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlElement, 'IXmlElement');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlText, 'IXmlText');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlCDATASection, 'IXmlCDATASection');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlComment, 'IXmlComment');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXmlProcessingInstruction, 'IXmlProcessingInstruction');
  SIRegister_IXmlDocument(CL);
 CL.AddDelphiFunction('Function CreateNameTable( aHashTableSize : Integer) : IXmlNameTable');
 CL.AddDelphiFunction('Function CreateXmlDocument( const aRootElementName : String; const aVersion : String; const anEncoding : String; const aNameTable : IXmlNameTable) : IXmlDocument');
 CL.AddDelphiFunction('Function CreateXmlElement( const aName : TXmlString; const aNameTable : IXmlNameTable) : IXmlElement');
 CL.AddDelphiFunction('Function LoadXmlDocumentFromXML( const aXML : RawByteString) : IXmlDocument');
 CL.AddDelphiFunction('Function LoadXmlDocumentFromBinaryXML( const aXML : RawByteString) : IXmlDocument');
 CL.AddDelphiFunction('Function LoadXmlDocument( aStream : TStream) : IXmlDocument;');
 CL.AddDelphiFunction('Function LoadXmlDocument1( const aFileName : String) : IXmlDocument;');
 CL.AddDelphiFunction('Function LoadXmlDocument2( aResType, aResName : PChar) : IXmlDocument;');
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
Function LoadXmlDocument2_P( aResType, aResName : PChar) : IXmlDocument;
Begin Result := SimpleXML.LoadXmlDocument(aResType, aResName); END;

(*----------------------------------------------------------------------------*)
Function LoadXmlDocument1_P( const aFileName : String) : IXmlDocument;
Begin Result := SimpleXML.LoadXmlDocument(aFileName); END;

(*----------------------------------------------------------------------------*)
Function LoadXmlDocument_P( aStream : TStream) : IXmlDocument;
Begin Result := SimpleXML.LoadXmlDocument(aStream); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentSaveBinary1_P(Self: IXmlDocument;  const aFileName : String; anOptions : LongWord);
Begin Self.SaveBinary(aFileName, anOptions); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentSaveBinary_P(Self: IXmlDocument;  aStream : TStream; anOptions : LongWord);
Begin Self.SaveBinary(aStream, anOptions); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentSave1_P(Self: IXmlDocument;  const aFileName : String);
Begin Self.Save(aFileName); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentSave_P(Self: IXmlDocument;  aStream : TStream);
Begin Self.Save(aStream); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentLoad1_P(Self: IXmlDocument;  const aFileName : String);
Begin Self.Load(aFileName); END;

(*----------------------------------------------------------------------------*)
Procedure IXmlDocumentLoad_P(Self: IXmlDocument;  aStream : TStream);
Begin Self.Load(aStream); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentCreateProcessingInstruction1_P(Self: IXmlDocument;  aTargetID : NativeInt; const aData : TXmlString) : IXmlProcessingInstruction;
Begin Result := Self.CreateProcessingInstruction(aTargetID, aData); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentCreateProcessingInstruction_P(Self: IXmlDocument;  const aTarget, aData : TXmlString) : IXmlProcessingInstruction;
Begin Result := Self.CreateProcessingInstruction(aTarget, aData); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentCreateElement1_P(Self: IXmlDocument;  const aName : TXmlString) : IXmlElement;
Begin Result := Self.CreateElement(aName); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentCreateElement_P(Self: IXmlDocument;  aNameID : NativeInt) : IXmlElement;
Begin Result := Self.CreateElement(aNameID); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentNewDocument1_P(Self: IXmlDocument;  const aVersion, anEncoding, aRootElementName : TXmlString) : IXmlElement;
Begin Result := Self.NewDocument(aVersion, anEncoding, aRootElementName); END;

(*----------------------------------------------------------------------------*)
Function IXmlDocumentNewDocument_P(Self: IXmlDocument;  const aVersion, anEncoding : TXmlString; aRootElementNameID : NativeInt) : IXmlElement;
Begin Result := Self.NewDocument(aVersion, anEncoding, aRootElementNameID); END;

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
