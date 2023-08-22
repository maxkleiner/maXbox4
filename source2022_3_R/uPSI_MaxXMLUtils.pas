unit uPSI_MaxXMLUtils;
{
T max dom xml x509

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
  TPSImport_MaxXMLUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_MaxXMLUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_MaxXMLUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   MaxDOM
  ,MaxXMLUtils, XMLIntf, XMLDom, XMLDoc, DB
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MaxXMLUtils]);
end;

function selectXMLNode(xnRoot: IXmlNode; const nodePath: WideString): IXmlNode;
var
  intfSelect : IDomNodeSelect;
  dnResult : IDomNode;
  intfDocAccess : IXmlDocumentAccess;
  doc: TXmlDocument;
begin
  Result := nil;
  if not Assigned(xnRoot) or not Supports(xnRoot.DOMNode, IDomNodeSelect, intfSelect) then
    Exit;
  dnResult := intfSelect.selectNode(nodePath);
  if Assigned(dnResult) then
  begin
    if Supports(xnRoot.OwnerDocument, IXmlDocumentAccess, intfDocAccess) then
      doc := intfDocAccess.DocumentObject
    else
      doc := nil;
    Result := TXmlNode.Create(dnResult, nil, doc);
  end;
end;


function RecordToXML(const ADataSet: TDataSet; const ARootPath: string = ''): string;
var
  LField: TField;
begin
  if not Assigned(ADataSet) then
    raise Exception.Create('DataSet not assigned');
  if not ADataSet.Active then
    raise Exception.Create('DataSet is not active');
  if ADataSet.IsEmpty then
    raise Exception.Create('DataSet is empty');

  Result := '';
  for LField in ADataSet.Fields do
  begin
    Result := Result
      + Format('<%s>%s</%s>', [LField.FieldName, LField.AsString, LField.FieldName]);
  end;
end;


function DataSetToXML(const ADataSet: TDataSet): string;
var
  LBookmark: TBookmarkstr;
begin
  Result := '';
  if not Assigned(ADataSet) then
    Exit;

  if not ADataSet.Active then
    ADataSet.Open;

  ADataSet.DisableControls;
  try
    LBookmark := ADataSet.Bookmark;
    try
      ADataSet.First;
      while not ADataSet.Eof do
      try
        //if (not Assigned(AAcceptFunc)) or (AAcceptFunc()) then
          Result := Result + '<row>' + RecordToXML(ADataSet) + '</row>';
      finally
        ADataSet.Next;
      end;
    finally
      ADataSet.GotoBookmark(pointer(LBookmark));
    end;
  finally
    ADataSet.EnableControls;
  end;
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MaxXMLUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function ValidXmlName( AName : PChar; ASize : Integer) : Boolean;');
 CL.AddDelphiFunction('Function ValidXmlName1( const AName : String) : Boolean;');
 CL.AddDelphiFunction('Function EncodeXmlAttrValue( const AStr : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Procedure EncodeXmlAttrValue3( ABuff : PChar; ABuffSize : Integer; var AStr : AnsiString; var ALen, AOffset : Integer);');
 CL.AddDelphiFunction('Procedure EncodeXmlAttrValue4( const ASource : String; var ADest : String; var ALen, AOffset : Integer);');
 CL.AddDelphiFunction('Function EncodeXmlString( const AStr : String) : String;');
 CL.AddDelphiFunction('Procedure EncodeXmlString2( ABuff : PChar; ABuffSize : Integer; var AStr : AnsiString; var ALen, AOffset : Integer);');
 CL.AddDelphiFunction('Procedure EncodeXmlComment( const ASource : AnsiString; var ADest : AnsiString; var ALen, AOffset : Integer);');
 CL.AddDelphiFunction('Function HasEncoding( const AStr : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function DecodeXmlAttrValue( const AStr : String) : String');
 CL.AddDelphiFunction('Procedure ReallocateString( var AString : AnsiString; var ALen : Integer; AReqLen : Integer)');
 CL.AddDelphiFunction('Procedure AttrFillXMLString( AnAttr : IAttribute; var aString : AnsiString; var aOffset, aLen : Integer)');
 CL.AddDelphiFunction('Procedure FillXMLString( ANode : INode; var AString : String; var AOffset, ALen : Integer; ASibling : INode; ALevel : Integer)');
 CL.AddDelphiFunction('Function NodeToXML( ANode : INode) : String');
 CL.AddDelphiFunction('Procedure XMLSaveToFile( ANode : INode; const AFileName : String)');
 CL.AddDelphiFunction('Function XMLLoadFromFile( const AFileName : String) : INode');
 CL.AddDelphiFunction('Function Hashmax( const ASource : AnsiString) : Cardinal');
 CL.AddDelphiFunction('function selectXMLNode(xnRoot: IXmlNode; const nodePath: WideString): IXmlNode;');
 CL.AddDelphiFunction('function DataSetToXML(const ADataSet: TDataSet): string;');


  CL.AddConstantN('GXMLIndentSpaces','Integer').SetInt( 2);
 //CL.AddConstantN('GXMLMultiLineAttributes','Boolean')BoolToStr( True);
 CL.AddConstantN('GXMLMultiLineAttributeThreshold','Integer').SetInt( 7);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure EncodeXmlComment7_P( const ASource : AnsiString; var ADest : AnsiString; var ALen, AOffset : Integer);
Begin MaxXMLUtils.EncodeXmlComment(ASource, ADest, ALen, AOffset); END;

(*----------------------------------------------------------------------------*)
Procedure EncodeXmlString6_P( ABuff : PChar; ABuffSize : Integer; var AStr : AnsiString; var ALen, AOffset : Integer);
Begin MaxXMLUtils.EncodeXmlString(ABuff, ABuffSize, AStr, ALen, AOffset); END;

(*----------------------------------------------------------------------------*)
Function EncodeXmlString5_P( const AStr : String) : String;
Begin Result := MaxXMLUtils.EncodeXmlString(AStr); END;

(*----------------------------------------------------------------------------*)
Procedure EncodeXmlAttrValue4_P( const ASource : String; var ADest : String; var ALen, AOffset : Integer);
Begin MaxXMLUtils.EncodeXmlAttrValue(ASource, ADest, ALen, AOffset); END;

(*----------------------------------------------------------------------------*)
Procedure EncodeXmlAttrValue3_P( ABuff : PChar; ABuffSize : Integer; var AStr : AnsiString; var ALen, AOffset : Integer);
Begin MaxXMLUtils.EncodeXmlAttrValue(ABuff, ABuffSize, AStr, ALen, AOffset); END;

(*----------------------------------------------------------------------------*)
Function EncodeXmlAttrValue2_P( const AStr : AnsiString) : AnsiString;
Begin Result := MaxXMLUtils.EncodeXmlAttrValue(AStr); END;

(*----------------------------------------------------------------------------*)
Function ValidXmlName1_P( const AName : String) : Boolean;
Begin Result := MaxXMLUtils.ValidXmlName(AName); END;

(*----------------------------------------------------------------------------*)
Function ValidXmlName0_P( AName : PChar; ASize : Integer) : Boolean;
Begin Result := MaxXMLUtils.ValidXmlName(AName, ASize); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MaxXMLUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ValidXmlName0_P, 'ValidXmlName', cdRegister);
 S.RegisterDelphiFunction(@ValidXmlName1_P, 'ValidXmlName1', cdRegister);
 S.RegisterDelphiFunction(@EncodeXmlAttrValue2_P, 'EncodeXmlAttrValue', cdRegister);
 S.RegisterDelphiFunction(@EncodeXmlAttrValue3_P, 'EncodeXmlAttrValue3', cdRegister);
 S.RegisterDelphiFunction(@EncodeXmlAttrValue4_P, 'EncodeXmlAttrValue4', cdRegister);
 S.RegisterDelphiFunction(@EncodeXmlString5_P, 'EncodeXmlString', cdRegister);
 S.RegisterDelphiFunction(@EncodeXmlString6_P, 'EncodeXmlString2', cdRegister);
 S.RegisterDelphiFunction(@EncodeXmlComment7_P, 'EncodeXmlComment', cdRegister);
 S.RegisterDelphiFunction(@HasEncoding, 'HasEncoding', cdRegister);
 S.RegisterDelphiFunction(@DecodeXmlAttrValue, 'DecodeXmlAttrValue', cdRegister);
 S.RegisterDelphiFunction(@ReallocateString, 'ReallocateString', cdRegister);
 S.RegisterDelphiFunction(@AttrFillXMLString, 'AttrFillXMLString', cdRegister);
 S.RegisterDelphiFunction(@FillXMLString, 'FillXMLString', cdRegister);
 S.RegisterDelphiFunction(@NodeToXML, 'NodeToXML', cdRegister);
 S.RegisterDelphiFunction(@XMLSaveToFile, 'XMLSaveToFile', cdRegister);
 S.RegisterDelphiFunction(@XMLLoadFromFile, 'XMLLoadFromFile', cdRegister);
 S.RegisterDelphiFunction(@Hash, 'Hashmax', cdRegister);
 S.RegisterDelphiFunction(@selectXMLNode, 'selectXMLNode', cdRegister);
 S.RegisterDelphiFunction(@DataSetToXML, 'DataSetToXML', cdRegister);

 
end;



{ TPSImport_MaxXMLUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxXMLUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MaxXMLUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxXMLUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MaxXMLUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
