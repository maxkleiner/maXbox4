unit uPSI_ALMultiPartBaseParser;
{
   base of race
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
  TPSImport_ALMultiPartBaseParser = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALMultipartBaseDecoder(CL: TPSPascalCompiler);
procedure SIRegister_TALMultipartBaseEncoder(CL: TPSPascalCompiler);
procedure SIRegister_TAlMultiPartBaseStream(CL: TPSPascalCompiler);
procedure SIRegister_TALMultiPartBaseContents(CL: TPSPascalCompiler);
procedure SIRegister_TALMultiPartBaseContent(CL: TPSPascalCompiler);
procedure SIRegister_ALMultiPartBaseParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALMultiPartBaseParser_Routines(S: TPSExec);
procedure RIRegister_TALMultipartBaseDecoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultipartBaseEncoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAlMultiPartBaseStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultiPartBaseContents(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultiPartBaseContent(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALMultiPartBaseParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,ALStringList
  ,ALMultiPartBaseParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALMultiPartBaseParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultipartBaseDecoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALMultipartBaseDecoder') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALMultipartBaseDecoder') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Decode( aDataStream : Tstream; aboundary : AnsiString);');
    RegisterMethod('Procedure Decode1( aDataStr : AnsiString; aboundary : AnsiString);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultipartBaseEncoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALMultipartBaseEncoder') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALMultipartBaseEncoder') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Encode( acontents : TALMultiPartBaseContents);');
    RegisterProperty('DataStream', 'TAlMultiPartBaseStream', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlMultiPartBaseStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMemoryStream', 'TAlMultiPartBaseStream') do
  with CL.AddClassN(CL.FindClass('TMemoryStream'),'TAlMultiPartBaseStream') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure AddContent( aContent : TALMultiPartBaseContent)');
    RegisterMethod('Procedure CloseBoundary');
    RegisterProperty('Boundary', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultiPartBaseContents(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TALMultiPartBaseContents') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TALMultiPartBaseContents') do
  begin
    RegisterMethod('Function Add : TALMultiPartBaseContent;');
    RegisterMethod('Function Add1( AObject : TALMultiPartBaseContent) : Integer;');
    RegisterMethod('Function Remove( AObject : TALMultiPartBaseContent) : Integer');
    RegisterMethod('Function IndexOf( AObject : TALMultiPartBaseContent) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; AObject : TALMultiPartBaseContent)');
    RegisterProperty('Items', 'TALMultiPartBasecontent Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultiPartBaseContent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALMultiPartBaseContent') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALMultiPartBaseContent') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure LoadDataFromFile( aFileName : AnsiString)');
    RegisterMethod('Procedure LoadDataFromStream( aStream : TStream)');
    RegisterMethod('Procedure LoadDataFromFileBase64Encode( aFileName : AnsiString)');
    RegisterMethod('Procedure LoadDataFromStreamBase64Encode( aStream : TStream)');
    RegisterMethod('Procedure SaveDataToFile( aFileName : AnsiString)');
    RegisterMethod('Procedure SaveDataToStream( aStream : TStream)');
    RegisterMethod('Procedure SaveDataToFileBase64Decode( aFileName : AnsiString)');
    RegisterMethod('Procedure SaveDataToStreamBase64Decode( aStream : TStream)');
    RegisterProperty('ContentType', 'AnsiString', iptrw);
    RegisterProperty('ContentTransferEncoding', 'AnsiString', iptrw);
    RegisterProperty('ContentDisposition', 'AnsiString', iptrw);
    RegisterProperty('ContentID', 'AnsiString', iptrw);
    RegisterProperty('ContentDescription', 'AnsiString', iptrw);
    RegisterProperty('DataStream', 'TStream', iptr);
    RegisterProperty('DataString', 'AnsiString', iptrw);
    RegisterProperty('CustomHeaders', 'TALStrings', iptr);
    RegisterProperty('RawHeaderText', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALMultiPartBaseParser(CL: TPSPascalCompiler);
begin
  SIRegister_TALMultiPartBaseContent(CL);
  SIRegister_TALMultiPartBaseContents(CL);
  SIRegister_TAlMultiPartBaseStream(CL);
  SIRegister_TALMultipartBaseEncoder(CL);
  SIRegister_TALMultipartBaseDecoder(CL);
 CL.AddDelphiFunction('Function ALMultipartExtractBoundaryFromContentType( aContentType : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALMultipartExtractSubValueFromHeaderLine( aHeaderLine : AnsiString; aName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALMultipartSetSubValueInHeaderLine( aHeaderLine : AnsiString; aName, AValue : AnsiString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TALMultipartBaseDecoderDecode1_P(Self: TALMultipartBaseDecoder;  aDataStr : AnsiString; aboundary : AnsiString);
Begin Self.Decode(aDataStr, aboundary); END;

(*----------------------------------------------------------------------------*)
Procedure TALMultipartBaseDecoderDecode_P(Self: TALMultipartBaseDecoder;  aDataStream : Tstream; aboundary : AnsiString);
Begin Self.Decode(aDataStream, aboundary); END;

(*----------------------------------------------------------------------------*)
procedure TALMultipartBaseEncoderDataStream_R(Self: TALMultipartBaseEncoder; var T: TAlMultiPartBaseStream);
begin T := Self.DataStream; end;

(*----------------------------------------------------------------------------*)
Procedure TALMultipartBaseEncoderEncode_P(Self: TALMultipartBaseEncoder;  acontents : TALMultiPartBaseContents);
Begin Self.Encode(acontents); END;

(*----------------------------------------------------------------------------*)
procedure TAlMultiPartBaseStreamBoundary_W(Self: TAlMultiPartBaseStream; const T: AnsiString);
begin Self.Boundary := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlMultiPartBaseStreamBoundary_R(Self: TAlMultiPartBaseStream; var T: AnsiString);
begin T := Self.Boundary; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentsItems_W(Self: TALMultiPartBaseContents; const T: TALMultiPartBasecontent; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentsItems_R(Self: TALMultiPartBaseContents; var T: TALMultiPartBasecontent; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TALMultiPartBaseContentsAdd1_P(Self: TALMultiPartBaseContents;  AObject : TALMultiPartBaseContent) : Integer;
Begin Result := Self.Add(AObject); END;

(*----------------------------------------------------------------------------*)
Function TALMultiPartBaseContentsAdd_P(Self: TALMultiPartBaseContents) : TALMultiPartBaseContent;
Begin Result := Self.Add; END;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentRawHeaderText_W(Self: TALMultiPartBaseContent; const T: AnsiString);
begin Self.RawHeaderText := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentRawHeaderText_R(Self: TALMultiPartBaseContent; var T: AnsiString);
begin T := Self.RawHeaderText; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentCustomHeaders_R(Self: TALMultiPartBaseContent; var T: TALStrings);
begin T := Self.CustomHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentDataString_W(Self: TALMultiPartBaseContent; const T: AnsiString);
begin Self.DataString := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentDataString_R(Self: TALMultiPartBaseContent; var T: AnsiString);
begin T := Self.DataString; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentDataStream_R(Self: TALMultiPartBaseContent; var T: TStream);
begin T := Self.DataStream; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentContentDescription_W(Self: TALMultiPartBaseContent; const T: AnsiString);
begin Self.ContentDescription := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentContentDescription_R(Self: TALMultiPartBaseContent; var T: AnsiString);
begin T := Self.ContentDescription; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentContentID_W(Self: TALMultiPartBaseContent; const T: AnsiString);
begin Self.ContentID := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentContentID_R(Self: TALMultiPartBaseContent; var T: AnsiString);
begin T := Self.ContentID; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentContentDisposition_W(Self: TALMultiPartBaseContent; const T: AnsiString);
begin Self.ContentDisposition := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentContentDisposition_R(Self: TALMultiPartBaseContent; var T: AnsiString);
begin T := Self.ContentDisposition; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentContentTransferEncoding_W(Self: TALMultiPartBaseContent; const T: AnsiString);
begin Self.ContentTransferEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentContentTransferEncoding_R(Self: TALMultiPartBaseContent; var T: AnsiString);
begin T := Self.ContentTransferEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentContentType_W(Self: TALMultiPartBaseContent; const T: AnsiString);
begin Self.ContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartBaseContentContentType_R(Self: TALMultiPartBaseContent; var T: AnsiString);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALMultiPartBaseParser_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ALMultipartExtractBoundaryFromContentType, 'ALMultipartExtractBoundaryFromContentType', cdRegister);
 S.RegisterDelphiFunction(@ALMultipartExtractSubValueFromHeaderLine, 'ALMultipartExtractSubValueFromHeaderLine', cdRegister);
 S.RegisterDelphiFunction(@ALMultipartSetSubValueInHeaderLine, 'ALMultipartSetSubValueInHeaderLine', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultipartBaseDecoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultipartBaseDecoder) do
  begin
    RegisterConstructor(@TALMultipartBaseDecoder.Create, 'Create');
    RegisterVirtualMethod(@TALMultipartBaseDecoderDecode_P, 'Decode');
    RegisterVirtualMethod(@TALMultipartBaseDecoderDecode1_P, 'Decode1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultipartBaseEncoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultipartBaseEncoder) do
  begin
    RegisterConstructor(@TALMultipartBaseEncoder.Create, 'Create');
    RegisterMethod(@TALMultipartBaseEncoderEncode_P, 'Encode');
    RegisterPropertyHelper(@TALMultipartBaseEncoderDataStream_R,nil,'DataStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlMultiPartBaseStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlMultiPartBaseStream) do
  begin
    RegisterConstructor(@TAlMultiPartBaseStream.Create, 'Create');
    RegisterVirtualMethod(@TAlMultiPartBaseStream.AddContent, 'AddContent');
    RegisterVirtualMethod(@TAlMultiPartBaseStream.CloseBoundary, 'CloseBoundary');
    RegisterPropertyHelper(@TAlMultiPartBaseStreamBoundary_R,@TAlMultiPartBaseStreamBoundary_W,'Boundary');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultiPartBaseContents(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultiPartBaseContents) do
  begin
    RegisterMethod(@TALMultiPartBaseContentsAdd_P, 'Add');
    RegisterMethod(@TALMultiPartBaseContentsAdd1_P, 'Add1');
    RegisterMethod(@TALMultiPartBaseContents.Remove, 'Remove');
    RegisterMethod(@TALMultiPartBaseContents.IndexOf, 'IndexOf');
    RegisterMethod(@TALMultiPartBaseContents.Insert, 'Insert');
    RegisterPropertyHelper(@TALMultiPartBaseContentsItems_R,@TALMultiPartBaseContentsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultiPartBaseContent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultiPartBaseContent) do begin
    RegisterConstructor(@TALMultiPartBaseContent.Create, 'Create');
    RegisterMethod(@TALMultiPartBaseContent.Clear, 'Clear');
     RegisterMethod(@TALMultiPartBaseContent.Destroy,'Free');
    RegisterMethod(@TALMultiPartBaseContent.LoadDataFromFile, 'LoadDataFromFile');
    RegisterMethod(@TALMultiPartBaseContent.LoadDataFromStream, 'LoadDataFromStream');
    RegisterMethod(@TALMultiPartBaseContent.LoadDataFromFileBase64Encode, 'LoadDataFromFileBase64Encode');
    RegisterMethod(@TALMultiPartBaseContent.LoadDataFromStreamBase64Encode, 'LoadDataFromStreamBase64Encode');
    RegisterMethod(@TALMultiPartBaseContent.SaveDataToFile, 'SaveDataToFile');
    RegisterMethod(@TALMultiPartBaseContent.SaveDataToStream, 'SaveDataToStream');
    RegisterMethod(@TALMultiPartBaseContent.SaveDataToFileBase64Decode, 'SaveDataToFileBase64Decode');
    RegisterMethod(@TALMultiPartBaseContent.SaveDataToStreamBase64Decode, 'SaveDataToStreamBase64Decode');
    RegisterPropertyHelper(@TALMultiPartBaseContentContentType_R,@TALMultiPartBaseContentContentType_W,'ContentType');
    RegisterPropertyHelper(@TALMultiPartBaseContentContentTransferEncoding_R,@TALMultiPartBaseContentContentTransferEncoding_W,'ContentTransferEncoding');
    RegisterPropertyHelper(@TALMultiPartBaseContentContentDisposition_R,@TALMultiPartBaseContentContentDisposition_W,'ContentDisposition');
    RegisterPropertyHelper(@TALMultiPartBaseContentContentID_R,@TALMultiPartBaseContentContentID_W,'ContentID');
    RegisterPropertyHelper(@TALMultiPartBaseContentContentDescription_R,@TALMultiPartBaseContentContentDescription_W,'ContentDescription');
    RegisterPropertyHelper(@TALMultiPartBaseContentDataStream_R,nil,'DataStream');
    RegisterPropertyHelper(@TALMultiPartBaseContentDataString_R,@TALMultiPartBaseContentDataString_W,'DataString');
    RegisterPropertyHelper(@TALMultiPartBaseContentCustomHeaders_R,nil,'CustomHeaders');
    RegisterPropertyHelper(@TALMultiPartBaseContentRawHeaderText_R,@TALMultiPartBaseContentRawHeaderText_W,'RawHeaderText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALMultiPartBaseParser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALMultiPartBaseContent(CL);
  RIRegister_TALMultiPartBaseContents(CL);
  RIRegister_TAlMultiPartBaseStream(CL);
  RIRegister_TALMultipartBaseEncoder(CL);
  RIRegister_TALMultipartBaseDecoder(CL);
end;

 
 
{ TPSImport_ALMultiPartBaseParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALMultiPartBaseParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALMultiPartBaseParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALMultiPartBaseParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALMultiPartBaseParser(ri);
  RIRegister_ALMultiPartBaseParser_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
