unit uPSI_ALMultiPartMixedParser;
{
    for xml
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
  TPSImport_ALMultiPartMixedParser = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALMultipartMixedDecoder(CL: TPSPascalCompiler);
procedure SIRegister_TALMultipartMixedEncoder(CL: TPSPascalCompiler);
procedure SIRegister_TAlMultiPartMixedStream(CL: TPSPascalCompiler);
procedure SIRegister_TALMultiPartMixedContents(CL: TPSPascalCompiler);
procedure SIRegister_TALMultiPartMixedContent(CL: TPSPascalCompiler);
procedure SIRegister_ALMultiPartMixedParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALMultipartMixedDecoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultipartMixedEncoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAlMultiPartMixedStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultiPartMixedContents(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALMultiPartMixedContent(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALMultiPartMixedParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ALMultiPartBaseParser
  ,ALMultiPartMixedParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALMultiPartMixedParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultipartMixedDecoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultipartBaseDecoder', 'TALMultipartMixedDecoder') do
  with CL.AddClassN(CL.FindClass('TALMultipartBaseDecoder'),'TALMultipartMixedDecoder') do
  begin
    RegisterProperty('Contents', 'TALMultiPartMixedContents', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultipartMixedEncoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultipartBaseEncoder', 'TALMultipartMixedEncoder') do
  with CL.AddClassN(CL.FindClass('TALMultipartBaseEncoder'),'TALMultipartMixedEncoder') do
  begin
    RegisterMethod('Procedure Encode( aInlineText, aInlineTextContentType : AnsiString; aAttachments : TALMultiPartMixedContents);');
    RegisterProperty('DataStream', 'TAlMultiPartMixedStream', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlMultiPartMixedStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAlMultiPartBaseStream', 'TAlMultiPartMixedStream') do
  with CL.AddClassN(CL.FindClass('TAlMultiPartBaseStream'),'TAlMultiPartMixedStream') do
  begin
    RegisterMethod('Procedure AddInlineTextBase64Encode( aContentType, aText : AnsiString)');
    RegisterMethod('Procedure AddAttachmentBase64Encode( aFileName, aContentType : AnsiString; aFileData : TStream);');
    RegisterMethod('Procedure AddAttachmentBase64Encode1( aFileName : AnsiString);');
    RegisterMethod('Procedure AddContent( aContent : TALMultiPartMixedContent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultiPartMixedContents(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultiPartBaseContents', 'TALMultiPartMixedContents') do
  with CL.AddClassN(CL.FindClass('TALMultiPartBaseContents'),'TALMultiPartMixedContents') do
  begin
    RegisterMethod('Function Add : TALMultiPartMixedContent;');
    RegisterMethod('Function Add1( AObject : TALMultiPartMixedContent) : Integer;');
    RegisterMethod('Function Remove( AObject : TALMultiPartMixedContent) : Integer');
    RegisterMethod('Function IndexOf( AObject : TALMultiPartMixedContent) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; AObject : TALMultiPartMixedContent)');
    RegisterProperty('Items', 'TALMultiPartMixedcontent Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALMultiPartMixedContent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALMultiPartBaseContent', 'TALMultiPartMixedContent') do
  with CL.AddClassN(CL.FindClass('TALMultiPartBaseContent'),'TALMultiPartMixedContent') do
  begin
    RegisterMethod('Procedure LoadDataFromFileAsAttachmentBase64Encode( aFileName : AnsiString)');
    RegisterProperty('IsAttachment', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALMultiPartMixedParser(CL: TPSPascalCompiler);
begin
  SIRegister_TALMultiPartMixedContent(CL);
  SIRegister_TALMultiPartMixedContents(CL);
  SIRegister_TAlMultiPartMixedStream(CL);
  SIRegister_TALMultipartMixedEncoder(CL);
  SIRegister_TALMultipartMixedDecoder(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALMultipartMixedDecoderContents_R(Self: TALMultipartMixedDecoder; var T: TALMultiPartMixedContents);
begin T := Self.Contents; end;

(*----------------------------------------------------------------------------*)
procedure TALMultipartMixedEncoderDataStream_R(Self: TALMultipartMixedEncoder; var T: TAlMultiPartMixedStream);
begin T := Self.DataStream; end;

(*----------------------------------------------------------------------------*)
Procedure TALMultipartMixedEncoderEncode_P(Self: TALMultipartMixedEncoder;  aInlineText, aInlineTextContentType : AnsiString; aAttachments : TALMultiPartMixedContents);
Begin Self.Encode(aInlineText, aInlineTextContentType, aAttachments); END;

(*----------------------------------------------------------------------------*)
Procedure TAlMultiPartMixedStreamAddAttachmentBase64Encode1_P(Self: TAlMultiPartMixedStream;  aFileName : AnsiString);
Begin Self.AddAttachmentBase64Encode(aFileName); END;

(*----------------------------------------------------------------------------*)
Procedure TAlMultiPartMixedStreamAddAttachmentBase64Encode_P(Self: TAlMultiPartMixedStream;  aFileName, aContentType : AnsiString; aFileData : TStream);
Begin Self.AddAttachmentBase64Encode(aFileName, aContentType, aFileData); END;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartMixedContentsItems_W(Self: TALMultiPartMixedContents; const T: TALMultiPartMixedcontent; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartMixedContentsItems_R(Self: TALMultiPartMixedContents; var T: TALMultiPartMixedcontent; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TALMultiPartMixedContentsAdd1_P(Self: TALMultiPartMixedContents;  AObject : TALMultiPartMixedContent) : Integer;
Begin Result := Self.Add(AObject); END;

(*----------------------------------------------------------------------------*)
Function TALMultiPartMixedContentsAdd_P(Self: TALMultiPartMixedContents) : TALMultiPartMixedContent;
Begin Result := Self.Add; END;

(*----------------------------------------------------------------------------*)
procedure TALMultiPartMixedContentIsAttachment_R(Self: TALMultiPartMixedContent; var T: Boolean);
begin T := Self.IsAttachment; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultipartMixedDecoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultipartMixedDecoder) do
  begin
    RegisterPropertyHelper(@TALMultipartMixedDecoderContents_R,nil,'Contents');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultipartMixedEncoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultipartMixedEncoder) do
  begin
    RegisterMethod(@TALMultipartMixedEncoderEncode_P, 'Encode');
    RegisterPropertyHelper(@TALMultipartMixedEncoderDataStream_R,nil,'DataStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlMultiPartMixedStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlMultiPartMixedStream) do
  begin
    RegisterMethod(@TAlMultiPartMixedStream.AddInlineTextBase64Encode, 'AddInlineTextBase64Encode');
    RegisterMethod(@TAlMultiPartMixedStreamAddAttachmentBase64Encode_P, 'AddAttachmentBase64Encode');
    RegisterMethod(@TAlMultiPartMixedStreamAddAttachmentBase64Encode1_P, 'AddAttachmentBase64Encode1');
    RegisterMethod(@TAlMultiPartMixedStream.AddContent, 'AddContent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultiPartMixedContents(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultiPartMixedContents) do
  begin
    RegisterMethod(@TALMultiPartMixedContentsAdd_P, 'Add');
    RegisterMethod(@TALMultiPartMixedContentsAdd1_P, 'Add1');
    RegisterMethod(@TALMultiPartMixedContents.Remove, 'Remove');
    RegisterMethod(@TALMultiPartMixedContents.IndexOf, 'IndexOf');
    RegisterMethod(@TALMultiPartMixedContents.Insert, 'Insert');
    RegisterPropertyHelper(@TALMultiPartMixedContentsItems_R,@TALMultiPartMixedContentsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALMultiPartMixedContent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALMultiPartMixedContent) do
  begin
    RegisterVirtualMethod(@TALMultiPartMixedContent.LoadDataFromFileAsAttachmentBase64Encode, 'LoadDataFromFileAsAttachmentBase64Encode');
    RegisterPropertyHelper(@TALMultiPartMixedContentIsAttachment_R,nil,'IsAttachment');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALMultiPartMixedParser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALMultiPartMixedContent(CL);
  RIRegister_TALMultiPartMixedContents(CL);
  RIRegister_TAlMultiPartMixedStream(CL);
  RIRegister_TALMultipartMixedEncoder(CL);
  RIRegister_TALMultipartMixedDecoder(CL);
end;

 
 
{ TPSImport_ALMultiPartMixedParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALMultiPartMixedParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALMultiPartMixedParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALMultiPartMixedParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALMultiPartMixedParser(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
