unit uPSI_StMime;
{
  stream&sockets
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
  TPSImport_StMime = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStMimeConverter(CL: TPSPascalCompiler);
procedure SIRegister_TStAttachment(CL: TPSPascalCompiler);
procedure SIRegister_TStBase64Stream(CL: TPSPascalCompiler);
procedure SIRegister_TStUUStream(CL: TPSPascalCompiler);
procedure SIRegister_TStQuotedStream(CL: TPSPascalCompiler);
procedure SIRegister_TStRawStream(CL: TPSPascalCompiler);
procedure SIRegister_TStConvertStream(CL: TPSPascalCompiler);
procedure SIRegister_StMime(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStMimeConverter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStAttachment(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStBase64Stream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStUUStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStQuotedStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStRawStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStConvertStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_StMime(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StConst
  ,StBase
  ,StStrZ
  ,StStrL
  ,StOStr
  ,StMime
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StMime]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStMimeConverter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStMimeConverter') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStMimeConverter') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor CreateInit( AStream : TStream)');
    RegisterMethod('Procedure AddFileAttachment( const AFileName : string)');
    RegisterMethod('Procedure AddStreamAttachment( AStream : TStream; const AFileName : string)');
    RegisterMethod('Procedure ExtractAttachment( const Attachment : string)');
    RegisterMethod('Procedure ExtractAttachmentIndex( Index : Integer)');
    RegisterMethod('Procedure ExtractToStream( Index : Integer; AStream : TStream)');
    RegisterMethod('Procedure ExtractAttachments');
    RegisterMethod('Procedure FillConverterList( List : TStrings)');
    RegisterMethod('Function GetTag( const Description : string) : string');
    RegisterMethod('Procedure RegisterConverter( const ATag, ADesc : string; AClass : TStConverterClass)');
    RegisterMethod('Procedure UnRegisterConverterClass( AClass : TStConverterClass)');
    RegisterProperty('Attachments', 'TStringList', iptr);
    RegisterProperty('Boundary', 'string', iptrw);
    RegisterProperty('Encoding', 'string', iptrw);
    RegisterProperty('ContentDescription', 'string', iptrw);
    RegisterProperty('ContentDisposition', 'string', iptrw);
    RegisterProperty('ContentType', 'string', iptrw);
    RegisterProperty('Converter', 'TStConvertStream', iptrw);
    RegisterProperty('Directory', 'string', iptrw);
    RegisterProperty('MimeHeaders', 'Boolean', iptrw);
    RegisterProperty('Stream', 'TStream', iptrw);
    RegisterProperty('OnProgress', 'TStProgressEvent', iptrw);
    RegisterProperty('OnSaveAs', 'TStSaveAsEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStAttachment(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStAttachment') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStAttachment') do begin
    RegisterProperty('atContentDescription', 'string', iptrw);
    RegisterProperty('atContentDisposition', 'string', iptrw);
    RegisterProperty('atContentType', 'string', iptrw);
    RegisterProperty('atEncoding', 'string', iptrw);
    RegisterProperty('atFilename', 'string', iptrw);
    RegisterProperty('atOldStyle', 'Boolean', iptrw);
    RegisterProperty('atSize', 'LongInt', iptrw);
    RegisterProperty('atStreamOffset', 'LongInt', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStBase64Stream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStConvertStream', 'TStBase64Stream') do
  with CL.AddClassN(CL.FindClass('TStConvertStream'),'TStBase64Stream') do begin
    RegisterMethod('Constructor Create( Owner : TStMimeConverter)');
    RegisterMethod('Procedure DecodeToStream( InStream, OutStream : TStream)');
    RegisterMethod('Procedure EncodeToStream( InStream, OutStream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStUUStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStConvertStream', 'TStUUStream') do
  with CL.AddClassN(CL.FindClass('TStConvertStream'),'TStUUStream') do begin
    RegisterMethod('Constructor Create( Owner : TStMimeConverter)');
    RegisterMethod('Procedure DecodeToStream( InStream, OutStream : TStream)');
    RegisterMethod('Procedure EncodeToStream( InStream, OutStream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStQuotedStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStConvertStream', 'TStQuotedStream') do
  with CL.AddClassN(CL.FindClass('TStConvertStream'),'TStQuotedStream') do begin
    RegisterMethod('Constructor Create( Owner : TStMimeConverter)');
    RegisterMethod('Procedure DecodeToStream( InStream, OutStream : TStream)');
    RegisterMethod('Procedure EncodeToStream( InStream, OutStream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStRawStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStConvertStream', 'TStRawStream') do
  with CL.AddClassN(CL.FindClass('TStConvertStream'),'TStRawStream') do begin
    RegisterMethod('Constructor Create( Owner : TStMimeConverter)');
    RegisterMethod('Procedure DecodeToStream( InStream, OutStream : TStream)');
    RegisterMethod('Procedure EncodeToStream( InStream, OutStream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStConvertStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStConvertStream') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStConvertStream') do begin
    RegisterMethod('Constructor Create( Owner : TStMimeConverter)');
    RegisterMethod('Procedure DecodeToStream( InStream, OutStream : TStream)');
    RegisterMethod('Procedure EncodeToStream( InStream, OutStream : TStream)');
    RegisterMethod('Procedure Progress( Status : TStConvertState; PercentDone : Byte)');
    RegisterProperty('CurrentFile', 'string', iptrw);
    RegisterProperty('OnProgress', 'TStProgressEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StMime(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxMimeLine','LongInt').SetInt( 78);
  CL.AddTypeS('TStConvertState', '( csStarted, csProgressing, csFinished )');
  CL.AddTypeS('TStProgressEvent', 'Procedure ( Sender : TObject; Status : TStCo'
   +'nvertState; PercentDone : Byte)');
  CL.AddTypeS('TStSaveAsEvent', 'Procedure ( Sender : TObject; var FileName : string)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStMimeConverter');
  SIRegister_TStConvertStream(CL);
  SIRegister_TStRawStream(CL);
  SIRegister_TStQuotedStream(CL);
  SIRegister_TStUUStream(CL);
  SIRegister_TStBase64Stream(CL);
  //CL.AddTypeS('TStConverterClass', 'class of TStConvertStream');
  SIRegister_TStAttachment(CL);
  SIRegister_TStMimeConverter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStMimeConverterOnSaveAs_W(Self: TStMimeConverter; const T: TStSaveAsEvent);
begin Self.OnSaveAs := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterOnSaveAs_R(Self: TStMimeConverter; var T: TStSaveAsEvent);
begin T := Self.OnSaveAs; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterOnProgress_W(Self: TStMimeConverter; const T: TStProgressEvent);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterOnProgress_R(Self: TStMimeConverter; var T: TStProgressEvent);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterStream_W(Self: TStMimeConverter; const T: TStream);
begin Self.Stream := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterStream_R(Self: TStMimeConverter; var T: TStream);
begin T := Self.Stream; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterMimeHeaders_W(Self: TStMimeConverter; const T: Boolean);
begin Self.MimeHeaders := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterMimeHeaders_R(Self: TStMimeConverter; var T: Boolean);
begin T := Self.MimeHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterDirectory_W(Self: TStMimeConverter; const T: string);
begin Self.Directory := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterDirectory_R(Self: TStMimeConverter; var T: string);
begin T := Self.Directory; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterConverter_W(Self: TStMimeConverter; const T: TStConvertStream);
begin Self.Converter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterConverter_R(Self: TStMimeConverter; var T: TStConvertStream);
begin T := Self.Converter; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterContentType_W(Self: TStMimeConverter; const T: string);
begin Self.ContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterContentType_R(Self: TStMimeConverter; var T: string);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterContentDisposition_W(Self: TStMimeConverter; const T: string);
begin Self.ContentDisposition := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterContentDisposition_R(Self: TStMimeConverter; var T: string);
begin T := Self.ContentDisposition; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterContentDescription_W(Self: TStMimeConverter; const T: string);
begin Self.ContentDescription := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterContentDescription_R(Self: TStMimeConverter; var T: string);
begin T := Self.ContentDescription; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterEncoding_W(Self: TStMimeConverter; const T: string);
begin Self.Encoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterEncoding_R(Self: TStMimeConverter; var T: string);
begin T := Self.Encoding; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterBoundary_W(Self: TStMimeConverter; const T: string);
begin Self.Boundary := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterBoundary_R(Self: TStMimeConverter; var T: string);
begin T := Self.Boundary; end;

(*----------------------------------------------------------------------------*)
procedure TStMimeConverterAttachments_R(Self: TStMimeConverter; var T: TStringList);
begin T := Self.Attachments; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatStreamOffset_W(Self: TStAttachment; const T: LongInt);
begin Self.atStreamOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatStreamOffset_R(Self: TStAttachment; var T: LongInt);
begin T := Self.atStreamOffset; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatSize_W(Self: TStAttachment; const T: LongInt);
begin Self.atSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatSize_R(Self: TStAttachment; var T: LongInt);
begin T := Self.atSize; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatOldStyle_W(Self: TStAttachment; const T: Boolean);
begin Self.atOldStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatOldStyle_R(Self: TStAttachment; var T: Boolean);
begin T := Self.atOldStyle; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatFilename_W(Self: TStAttachment; const T: string);
begin Self.atFilename := T; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatFilename_R(Self: TStAttachment; var T: string);
begin T := Self.atFilename; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatEncoding_W(Self: TStAttachment; const T: string);
begin Self.atEncoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatEncoding_R(Self: TStAttachment; var T: string);
begin T := Self.atEncoding; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatContentType_W(Self: TStAttachment; const T: string);
begin Self.atContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatContentType_R(Self: TStAttachment; var T: string);
begin T := Self.atContentType; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatContentDisposition_W(Self: TStAttachment; const T: string);
begin Self.atContentDisposition := T; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatContentDisposition_R(Self: TStAttachment; var T: string);
begin T := Self.atContentDisposition; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatContentDescription_W(Self: TStAttachment; const T: string);
begin Self.atContentDescription := T; end;

(*----------------------------------------------------------------------------*)
procedure TStAttachmentatContentDescription_R(Self: TStAttachment; var T: string);
begin T := Self.atContentDescription; end;

(*----------------------------------------------------------------------------*)
procedure TStConvertStreamOnProgress_W(Self: TStConvertStream; const T: TStProgressEvent);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TStConvertStreamOnProgress_R(Self: TStConvertStream; var T: TStProgressEvent);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TStConvertStreamCurrentFile_W(Self: TStConvertStream; const T: string);
begin Self.CurrentFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TStConvertStreamCurrentFile_R(Self: TStConvertStream; var T: string);
begin T := Self.CurrentFile; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStMimeConverter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStMimeConverter) do begin
    RegisterConstructor(@TStMimeConverter.Create, 'Create');
    RegisterMethod(@TStMimeConverter.Destroy, 'Free');
    RegisterConstructor(@TStMimeConverter.CreateInit, 'CreateInit');
    RegisterMethod(@TStMimeConverter.AddFileAttachment, 'AddFileAttachment');
    RegisterVirtualMethod(@TStMimeConverter.AddStreamAttachment, 'AddStreamAttachment');
    RegisterVirtualMethod(@TStMimeConverter.ExtractAttachment, 'ExtractAttachment');
    RegisterVirtualMethod(@TStMimeConverter.ExtractAttachmentIndex, 'ExtractAttachmentIndex');
    RegisterVirtualMethod(@TStMimeConverter.ExtractToStream, 'ExtractToStream');
    RegisterMethod(@TStMimeConverter.ExtractAttachments, 'ExtractAttachments');
    RegisterMethod(@TStMimeConverter.FillConverterList, 'FillConverterList');
    RegisterMethod(@TStMimeConverter.GetTag, 'GetTag');
    RegisterMethod(@TStMimeConverter.RegisterConverter, 'RegisterConverter');
    RegisterMethod(@TStMimeConverter.UnRegisterConverterClass, 'UnRegisterConverterClass');
    RegisterPropertyHelper(@TStMimeConverterAttachments_R,nil,'Attachments');
    RegisterPropertyHelper(@TStMimeConverterBoundary_R,@TStMimeConverterBoundary_W,'Boundary');
    RegisterPropertyHelper(@TStMimeConverterEncoding_R,@TStMimeConverterEncoding_W,'Encoding');
    RegisterPropertyHelper(@TStMimeConverterContentDescription_R,@TStMimeConverterContentDescription_W,'ContentDescription');
    RegisterPropertyHelper(@TStMimeConverterContentDisposition_R,@TStMimeConverterContentDisposition_W,'ContentDisposition');
    RegisterPropertyHelper(@TStMimeConverterContentType_R,@TStMimeConverterContentType_W,'ContentType');
    RegisterPropertyHelper(@TStMimeConverterConverter_R,@TStMimeConverterConverter_W,'Converter');
    RegisterPropertyHelper(@TStMimeConverterDirectory_R,@TStMimeConverterDirectory_W,'Directory');
    RegisterPropertyHelper(@TStMimeConverterMimeHeaders_R,@TStMimeConverterMimeHeaders_W,'MimeHeaders');
    RegisterPropertyHelper(@TStMimeConverterStream_R,@TStMimeConverterStream_W,'Stream');
    RegisterPropertyHelper(@TStMimeConverterOnProgress_R,@TStMimeConverterOnProgress_W,'OnProgress');
    RegisterPropertyHelper(@TStMimeConverterOnSaveAs_R,@TStMimeConverterOnSaveAs_W,'OnSaveAs');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStAttachment(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStAttachment) do
  begin
    RegisterPropertyHelper(@TStAttachmentatContentDescription_R,@TStAttachmentatContentDescription_W,'atContentDescription');
    RegisterPropertyHelper(@TStAttachmentatContentDisposition_R,@TStAttachmentatContentDisposition_W,'atContentDisposition');
    RegisterPropertyHelper(@TStAttachmentatContentType_R,@TStAttachmentatContentType_W,'atContentType');
    RegisterPropertyHelper(@TStAttachmentatEncoding_R,@TStAttachmentatEncoding_W,'atEncoding');
    RegisterPropertyHelper(@TStAttachmentatFilename_R,@TStAttachmentatFilename_W,'atFilename');
    RegisterPropertyHelper(@TStAttachmentatOldStyle_R,@TStAttachmentatOldStyle_W,'atOldStyle');
    RegisterPropertyHelper(@TStAttachmentatSize_R,@TStAttachmentatSize_W,'atSize');
    RegisterPropertyHelper(@TStAttachmentatStreamOffset_R,@TStAttachmentatStreamOffset_W,'atStreamOffset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStBase64Stream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStBase64Stream) do
  begin
    RegisterConstructor(@TStBase64Stream.Create, 'Create');
    RegisterMethod(@TStBase64Stream.DecodeToStream, 'DecodeToStream');
    RegisterMethod(@TStBase64Stream.EncodeToStream, 'EncodeToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStUUStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStUUStream) do
  begin
    RegisterConstructor(@TStUUStream.Create, 'Create');
    RegisterMethod(@TStUUStream.DecodeToStream, 'DecodeToStream');
    RegisterMethod(@TStUUStream.EncodeToStream, 'EncodeToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStQuotedStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStQuotedStream) do
  begin
    RegisterConstructor(@TStQuotedStream.Create, 'Create');
    RegisterMethod(@TStQuotedStream.DecodeToStream, 'DecodeToStream');
    RegisterMethod(@TStQuotedStream.EncodeToStream, 'EncodeToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStRawStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStRawStream) do
  begin
    RegisterConstructor(@TStRawStream.Create, 'Create');
    RegisterMethod(@TStRawStream.DecodeToStream, 'DecodeToStream');
    RegisterMethod(@TStRawStream.EncodeToStream, 'EncodeToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStConvertStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStConvertStream) do begin
    RegisterVirtualConstructor(@TStConvertStream.Create, 'Create');
    //RegisterVirtualAbstractMethod(@TStConvertStream, @!.DecodeToStream, 'DecodeToStream');
    //RegisterVirtualAbstractMethod(@TStConvertStream, @!.EncodeToStream, 'EncodeToStream');
    RegisterVirtualMethod(@TStConvertStream.Progress, 'Progress');
    RegisterPropertyHelper(@TStConvertStreamCurrentFile_R,@TStConvertStreamCurrentFile_W,'CurrentFile');
    RegisterPropertyHelper(@TStConvertStreamOnProgress_R,@TStConvertStreamOnProgress_W,'OnProgress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StMime(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStMimeConverter) do
  RIRegister_TStConvertStream(CL);
  RIRegister_TStRawStream(CL);
  RIRegister_TStQuotedStream(CL);
  RIRegister_TStUUStream(CL);
  RIRegister_TStBase64Stream(CL);
  RIRegister_TStAttachment(CL);
  RIRegister_TStMimeConverter(CL);
end;

 
 
{ TPSImport_StMime }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StMime.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StMime(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StMime.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StMime(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
