unit uPSI_IdMultipartFormData;
{
   idhttp post need it!     - free add
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
  TPSImport_IdMultipartFormData = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdMultiPartFormDataStream(CL: TPSPascalCompiler);
procedure SIRegister_TIdFormDataFields(CL: TPSPascalCompiler);
procedure SIRegister_TIdFormDataField(CL: TPSPascalCompiler);
procedure SIRegister_IdMultipartFormData(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdMultiPartFormDataStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdFormDataFields(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdFormDataField(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdMultipartFormData(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdGlobal
  ,IdException
  ,IdResourceStrings
  ,IdMultipartFormData
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdMultipartFormData]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMultiPartFormDataStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TIdMultiPartFormDataStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TIdMultiPartFormDataStream') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure AddFormField( const AFieldName, AFieldValue : string)');
    RegisterMethod('Procedure AddObject( const AFieldName, AContentType : string; AFileData : TObject; const AFileName : string)');
    RegisterMethod('Procedure AddFile( const AFieldName, AFileName, AContentType : string)');
    RegisterProperty('Boundary', 'string', iptr);
    RegisterProperty('RequestContentType', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdFormDataFields(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TIdFormDataFields') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TIdFormDataFields') do begin
    RegisterMethod('Constructor Create( AMPStream : TIdMultiPartFormDataStream)');
    RegisterMethod('Function Add : TIdFormDataField');
    RegisterProperty('MultipartFormDataStream', 'TIdMultiPartFormDataStream', iptr);
    RegisterProperty('Items', 'TIdFormDataField Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdFormDataField(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TIdFormDataField') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TIdFormDataField') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Function FormatField : string');
    RegisterProperty('ContentType', 'string', iptrw);
    RegisterProperty('FieldName', 'string', iptrw);
    RegisterProperty('FieldStream', 'TStream', iptrw);
    RegisterProperty('FieldStrings', 'TStrings', iptrw);
    RegisterProperty('FieldObject', 'TObject', iptrw);
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('FieldValue', 'string', iptrw);
    RegisterProperty('FieldSize', 'LongInt', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdMultipartFormData(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('sContentTypeFormData','String').SetString( 'multipart/form-data; boundary=');
 CL.AddConstantN('sContentTypeOctetStream','String').SetString( 'application/octet-stream');
 //CL.AddConstantN('crlf','String').SetString( #13#10);
 CL.AddConstantN('sContentDisposition','String').SetString( 'Content-Disposition: form-data; name="%s"');
 CL.AddConstantN('sFileNamePlaceHolder','String').SetString( '; filename="%s"');
 CL.AddConstantN('sContentTypePlaceHolder','String').SetString( 'Content-Type: %s');
 CL.AddConstantN('sContentTransferEncoding','String').SetString( 'Content-Transfer-Encoding: binary');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdMultiPartFormDataStream');
  SIRegister_TIdFormDataField(CL);
  SIRegister_TIdFormDataFields(CL);
  SIRegister_TIdMultiPartFormDataStream(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdInvalidObjectType');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdMultiPartFormDataStreamRequestContentType_R(Self: TIdMultiPartFormDataStream; var T: string);
begin T := Self.RequestContentType; end;

(*----------------------------------------------------------------------------*)
procedure TIdMultiPartFormDataStreamBoundary_R(Self: TIdMultiPartFormDataStream; var T: string);
begin T := Self.Boundary; end;

(*----------------------------------------------------------------------------*)
Function TIdMultiPartFormDataStreamSeek_P(Self: TIdMultiPartFormDataStream;  Offset : Longint; Origin : Word) : Longint;
Begin Result := Self.Seek(Offset, Origin); END;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldsItems_R(Self: TIdFormDataFields; var T: TIdFormDataField; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldsMultipartFormDataStream_R(Self: TIdFormDataFields; var T: TIdMultiPartFormDataStream);
begin T := Self.MultipartFormDataStream; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFieldSize_R(Self: TIdFormDataField; var T: LongInt);
begin T := Self.FieldSize; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFieldValue_W(Self: TIdFormDataField; const T: string);
begin Self.FieldValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFieldValue_R(Self: TIdFormDataField; var T: string);
begin T := Self.FieldValue; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFileName_W(Self: TIdFormDataField; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFileName_R(Self: TIdFormDataField; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFieldObject_W(Self: TIdFormDataField; const T: TObject);
begin Self.FieldObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFieldObject_R(Self: TIdFormDataField; var T: TObject);
begin T := Self.FieldObject; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFieldStrings_W(Self: TIdFormDataField; const T: TStrings);
begin Self.FieldStrings := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFieldStrings_R(Self: TIdFormDataField; var T: TStrings);
begin T := Self.FieldStrings; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFieldStream_W(Self: TIdFormDataField; const T: TStream);
begin Self.FieldStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFieldStream_R(Self: TIdFormDataField; var T: TStream);
begin T := Self.FieldStream; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFieldName_W(Self: TIdFormDataField; const T: string);
begin Self.FieldName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldFieldName_R(Self: TIdFormDataField; var T: string);
begin T := Self.FieldName; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldContentType_W(Self: TIdFormDataField; const T: string);
begin Self.ContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFormDataFieldContentType_R(Self: TIdFormDataField; var T: string);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMultiPartFormDataStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMultiPartFormDataStream) do begin
    RegisterConstructor(@TIdMultiPartFormDataStream.Create, 'Create');
     RegisterMethod(@TIdMultiPartFormDataStream.Destroy, 'Free');
    RegisterMethod(@TIdMultiPartFormDataStream.AddFormField, 'AddFormField');
    RegisterMethod(@TIdMultiPartFormDataStream.AddObject, 'AddObject');
    RegisterMethod(@TIdMultiPartFormDataStream.AddFile, 'AddFile');
    RegisterPropertyHelper(@TIdMultiPartFormDataStreamBoundary_R,nil,'Boundary');
    RegisterPropertyHelper(@TIdMultiPartFormDataStreamRequestContentType_R,nil,'RequestContentType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdFormDataFields(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdFormDataFields) do
  begin
    RegisterConstructor(@TIdFormDataFields.Create, 'Create');
    RegisterMethod(@TIdFormDataFields.Add, 'Add');
    RegisterPropertyHelper(@TIdFormDataFieldsMultipartFormDataStream_R,nil,'MultipartFormDataStream');
    RegisterPropertyHelper(@TIdFormDataFieldsItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdFormDataField(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdFormDataField) do
  begin
    RegisterConstructor(@TIdFormDataField.Create, 'Create');
    RegisterMethod(@TIdFormDataField.FormatField, 'FormatField');
    RegisterPropertyHelper(@TIdFormDataFieldContentType_R,@TIdFormDataFieldContentType_W,'ContentType');
    RegisterPropertyHelper(@TIdFormDataFieldFieldName_R,@TIdFormDataFieldFieldName_W,'FieldName');
    RegisterPropertyHelper(@TIdFormDataFieldFieldStream_R,@TIdFormDataFieldFieldStream_W,'FieldStream');
    RegisterPropertyHelper(@TIdFormDataFieldFieldStrings_R,@TIdFormDataFieldFieldStrings_W,'FieldStrings');
    RegisterPropertyHelper(@TIdFormDataFieldFieldObject_R,@TIdFormDataFieldFieldObject_W,'FieldObject');
    RegisterPropertyHelper(@TIdFormDataFieldFileName_R,@TIdFormDataFieldFileName_W,'FileName');
    RegisterPropertyHelper(@TIdFormDataFieldFieldValue_R,@TIdFormDataFieldFieldValue_W,'FieldValue');
    RegisterPropertyHelper(@TIdFormDataFieldFieldSize_R,nil,'FieldSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdMultipartFormData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMultiPartFormDataStream) do
  RIRegister_TIdFormDataField(CL);
  RIRegister_TIdFormDataFields(CL);
  RIRegister_TIdMultiPartFormDataStream(CL);
  with CL.Add(EIdInvalidObjectType) do
end;

 
 
{ TPSImport_IdMultipartFormData }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMultipartFormData.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdMultipartFormData(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMultipartFormData.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdMultipartFormData(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
