unit uPSI_ALMultiPartFormDataParser;
{
    parse
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
  TPSImport_ALMultiPartFormDataParser = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALMultipartFormDataDecoder(CL: TPSPascalCompiler);
procedure SIRegister_TALMultipartFormDataEncoder(CL: TPSPascalCompiler);
procedure SIRegister_TAlMultiPartFormDataStream(CL: TPSPascalCompiler);
procedure SIRegister_TALMultiPartFormDataContents(CL: TPSPascalCompiler);
procedure SIRegister_TALMultiPartFormDataContent(CL: TPSPascalCompiler);
procedure SIRegister_ALMultiPartFormDataParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALMultipartFormDataDecoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultipartFormDataEncoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAlMultiPartFormDataStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultiPartFormDataContents(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultiPartFormDataContent(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALMultiPartFormDataParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   AlStringList
  ,AlMultiPartBaseParser
  ,ALMultiPartFormDataParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALMultiPartFormDataParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultipartFormDataDecoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultipartBaseDecoder', 'TALMultipartFormDataDecoder') do
  with CL.AddClassN(CL.FindClass('TALMultipartBaseDecoder'),'TALMultipartFormDataDecoder') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Decode( aDataStr, aboundary : AnsiString);');
    RegisterMethod('Procedure Decode1( aDataStr, aboundary : AnsiString; aContentFields : TALStrings; aContentFiles : TALMultiPartFormDataContents);');
    RegisterProperty('ContentFiles', 'TALMultiPartFormDataContents', iptr);
    RegisterProperty('ContentFields', 'TALStrings', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultipartFormDataEncoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultipartBaseEncoder', 'TALMultipartFormDataEncoder') do
  with CL.AddClassN(CL.FindClass('TALMultipartBaseEncoder'),'TALMultipartFormDataEncoder') do
  begin
    RegisterMethod('Procedure Encode( aContentFields : TALStrings; aContentFiles : TALMultiPartFormDataContents)');
    RegisterProperty('DataStream', 'TAlMultiPartFormDataStream', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlMultiPartFormDataStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAlMultiPartBaseStream', 'TAlMultiPartFormDataStream') do
  with CL.AddClassN(CL.FindClass('TAlMultiPartBaseStream'),'TAlMultiPartFormDataStream') do
  begin
    RegisterMethod('Procedure AddField( const aFieldName, aFieldValue : AnsiString)');
    RegisterMethod('Procedure AddFile( const aFieldName, aFileName, aContentType : AnsiString; aFileData : TStream);');
    RegisterMethod('Procedure AddFile1( const aFieldName, aFileName : AnsiString);');
    RegisterMethod('Procedure AddContent( aContent : TALMultiPartFormDataContent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultiPartFormDataContents(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultiPartBaseContents', 'TALMultiPartFormDataContents') do
  with CL.AddClassN(CL.FindClass('TALMultiPartBaseContents'),'TALMultiPartFormDataContents') do
  begin
    RegisterMethod('Function Add : TALMultiPartFormDataContent;');
    RegisterMethod('Function Add1( AObject : TALMultiPartFormDataContent) : Integer;');
    RegisterMethod('Function Remove( AObject : TALMultiPartFormDataContent) : Integer');
    RegisterMethod('Function IndexOf( AObject : TALMultiPartFormDataContent) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; AObject : TALMultiPartFormDataContent)');
    RegisterProperty('Items', 'TALMultiPartFormDatacontent Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultiPartFormDataContent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultiPartBaseContent', 'TALMultiPartFormDataContent') do
  with CL.AddClassN(CL.FindClass('TALMultiPartBaseContent'),'TALMultiPartFormDataContent') do
  begin
    RegisterMethod('Procedure LoadDataFromFile( aFileName : AnsiString)');
    RegisterMethod('Procedure LoadDataFromStream( aStream : TStream)');
    RegisterProperty('FieldName', 'AnsiString', iptrw);
    RegisterProperty('FileName', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALMultiPartFormDataParser(CL: TPSPascalCompiler);
begin
  SIRegister_TALMultiPartFormDataContent(CL);
  SIRegister_TALMultiPartFormDataContents(CL);
  SIRegister_TAlMultiPartFormDataStream(CL);
  SIRegister_TALMultipartFormDataEncoder(CL);
  SIRegister_TALMultipartFormDataDecoder(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALMultipartFormDataDecoderContentFields_R(Self: TALMultipartFormDataDecoder; var T: TALStrings);
begin T := Self.ContentFields; end;

(*----------------------------------------------------------------------------*)
procedure TALMultipartFormDataDecoderContentFiles_R(Self: TALMultipartFormDataDecoder; var T: TALMultiPartFormDataContents);
begin T := Self.ContentFiles; end;

(*----------------------------------------------------------------------------*)
Procedure TALMultipartFormDataDecoderDecode1_P(Self: TALMultipartFormDataDecoder;  aDataStr, aboundary : AnsiString; aContentFields : TALStrings; aContentFiles : TALMultiPartFormDataContents);
Begin Self.Decode(aDataStr, aboundary, aContentFields, aContentFiles); END;

(*----------------------------------------------------------------------------*)
Procedure TALMultipartFormDataDecoderDecode_P(Self: TALMultipartFormDataDecoder;  aDataStr, aboundary : AnsiString);
Begin Self.Decode(aDataStr, aboundary); END;

(*----------------------------------------------------------------------------*)
procedure TALMultipartFormDataEncoderDataStream_R(Self: TALMultipartFormDataEncoder; var T: TAlMultiPartFormDataStream);
begin T := Self.DataStream; end;

(*----------------------------------------------------------------------------*)
Procedure TAlMultiPartFormDataStreamAddFile1_P(Self: TAlMultiPartFormDataStream;  const aFieldName, aFileName : AnsiString);
Begin Self.AddFile(aFieldName, aFileName); END;

(*----------------------------------------------------------------------------*)
Procedure TAlMultiPartFormDataStreamAddFile_P(Self: TAlMultiPartFormDataStream;  const aFieldName, aFileName, aContentType : AnsiString; aFileData : TStream);
Begin Self.AddFile(aFieldName, aFileName, aContentType, aFileData); END;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartFormDataContentsItems_W(Self: TALMultiPartFormDataContents; const T: TALMultiPartFormDatacontent; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartFormDataContentsItems_R(Self: TALMultiPartFormDataContents; var T: TALMultiPartFormDatacontent; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TALMultiPartFormDataContentsAdd1_P(Self: TALMultiPartFormDataContents;  AObject : TALMultiPartFormDataContent) : Integer;
Begin Result := Self.Add(AObject); END;

(*----------------------------------------------------------------------------*)
Function TALMultiPartFormDataContentsAdd_P(Self: TALMultiPartFormDataContents) : TALMultiPartFormDataContent;
Begin Result := Self.Add; END;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartFormDataContentFileName_W(Self: TALMultiPartFormDataContent; const T: AnsiString);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartFormDataContentFileName_R(Self: TALMultiPartFormDataContent; var T: AnsiString);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartFormDataContentFieldName_W(Self: TALMultiPartFormDataContent; const T: AnsiString);
begin Self.FieldName := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartFormDataContentFieldName_R(Self: TALMultiPartFormDataContent; var T: AnsiString);
begin T := Self.FieldName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultipartFormDataDecoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultipartFormDataDecoder) do begin
    RegisterConstructor(@TALMultipartFormDataDecoder.Create, 'Create');
     RegisterMethod(@TALMultipartFormDataDecoder.Destroy, 'Free');
    RegisterMethod(@TALMultipartFormDataDecoderDecode_P, 'Decode');
    RegisterMethod(@TALMultipartFormDataDecoderDecode1_P, 'Decode1');
    RegisterPropertyHelper(@TALMultipartFormDataDecoderContentFiles_R,nil,'ContentFiles');
    RegisterPropertyHelper(@TALMultipartFormDataDecoderContentFields_R,nil,'ContentFields');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultipartFormDataEncoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultipartFormDataEncoder) do
  begin
    RegisterMethod(@TALMultipartFormDataEncoder.Encode, 'Encode');
    RegisterPropertyHelper(@TALMultipartFormDataEncoderDataStream_R,nil,'DataStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlMultiPartFormDataStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlMultiPartFormDataStream) do
  begin
    RegisterMethod(@TAlMultiPartFormDataStream.AddField, 'AddField');
    RegisterMethod(@TAlMultiPartFormDataStreamAddFile_P, 'AddFile');
    RegisterMethod(@TAlMultiPartFormDataStreamAddFile1_P, 'AddFile1');
    RegisterMethod(@TAlMultiPartFormDataStream.AddContent, 'AddContent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultiPartFormDataContents(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultiPartFormDataContents) do
  begin
    RegisterMethod(@TALMultiPartFormDataContentsAdd_P, 'Add');
    RegisterMethod(@TALMultiPartFormDataContentsAdd1_P, 'Add1');
    RegisterMethod(@TALMultiPartFormDataContents.Remove, 'Remove');
    RegisterMethod(@TALMultiPartFormDataContents.IndexOf, 'IndexOf');
    RegisterMethod(@TALMultiPartFormDataContents.Insert, 'Insert');
    RegisterPropertyHelper(@TALMultiPartFormDataContentsItems_R,@TALMultiPartFormDataContentsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultiPartFormDataContent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultiPartFormDataContent) do
  begin
    RegisterMethod(@TALMultiPartFormDataContent.LoadDataFromFile, 'LoadDataFromFile');
    RegisterMethod(@TALMultiPartFormDataContent.LoadDataFromStream, 'LoadDataFromStream');
    RegisterPropertyHelper(@TALMultiPartFormDataContentFieldName_R,@TALMultiPartFormDataContentFieldName_W,'FieldName');
    RegisterPropertyHelper(@TALMultiPartFormDataContentFileName_R,@TALMultiPartFormDataContentFileName_W,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALMultiPartFormDataParser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALMultiPartFormDataContent(CL);
  RIRegister_TALMultiPartFormDataContents(CL);
  RIRegister_TAlMultiPartFormDataStream(CL);
  RIRegister_TALMultipartFormDataEncoder(CL);
  RIRegister_TALMultipartFormDataDecoder(CL);
end;

 
 
{ TPSImport_ALMultiPartFormDataParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALMultiPartFormDataParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALMultiPartFormDataParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALMultiPartFormDataParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALMultiPartFormDataParser(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
