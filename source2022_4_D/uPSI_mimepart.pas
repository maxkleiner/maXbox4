unit uPSI_mimepart;
{
   for synapse thirdlife camera
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
  TPSImport_mimepart = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMimePart(CL: TPSPascalCompiler);
procedure SIRegister_mimepart(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_mimepart_Routines(S: TPSExec);
procedure RIRegister_TMimePart(CL: TPSRuntimeClassImporter);
procedure RIRegister_mimepart(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   synafpc
  ,synachar
  ,synacode
  ,synautil
  ,mimeinln
  ,mimepart
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_mimepart]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMimePart(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMimePart') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMimePart') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Assign( Value : TMimePart)');
    RegisterMethod('Procedure AssignSubParts( Value : TMimePart)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure DecodePart');
    RegisterMethod('Procedure DecodePartHeader');
    RegisterMethod('Procedure EncodePart');
    RegisterMethod('Procedure EncodePartHeader');
    RegisterMethod('Procedure MimeTypeFromExt( Value : string)');
    RegisterMethod('Function GetSubPartCount : integer');
    RegisterMethod('Function GetSubPart( index : integer) : TMimePart');
    RegisterMethod('Procedure DeleteSubPart( index : integer)');
    RegisterMethod('Procedure ClearSubParts');
    RegisterMethod('Function AddSubPart : TMimePart');
    RegisterMethod('Procedure DecomposeParts');
    RegisterMethod('Procedure DecomposePartsBinary( AHeader : TStrings; AStx, AEtx : PANSIChar)');
    RegisterMethod('Procedure ComposeParts');
    RegisterMethod('Procedure WalkPart');
    RegisterMethod('Function CanSubPart : boolean');
    RegisterProperty('Primary', 'string', iptrw);
    RegisterProperty('Encoding', 'string', iptrw);
    RegisterProperty('Charset', 'string', iptrw);
    RegisterProperty('DefaultCharset', 'string', iptrw);
    RegisterProperty('PrimaryCode', 'TMimePrimary', iptrw);
    RegisterProperty('EncodingCode', 'TMimeEncoding', iptrw);
    RegisterProperty('CharsetCode', 'TMimeChar', iptrw);
    RegisterProperty('TargetCharset', 'TMimeChar', iptrw);
    RegisterProperty('ConvertCharset', 'Boolean', iptrw);
    RegisterProperty('ForcedHTMLConvert', 'Boolean', iptrw);
    RegisterProperty('Secondary', 'string', iptrw);
    RegisterProperty('Description', 'string', iptrw);
    RegisterProperty('Disposition', 'string', iptrw);
    RegisterProperty('ContentID', 'string', iptrw);
    RegisterProperty('Boundary', 'string', iptrw);
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('Lines', 'TStringList', iptr);
    RegisterProperty('PartBody', 'TStringList', iptr);
    RegisterProperty('Headers', 'TStringList', iptr);
    RegisterProperty('PrePart', 'TStringList', iptr);
    RegisterProperty('PostPart', 'TStringList', iptr);
    RegisterProperty('DecodedLines', 'TMemoryStream', iptr);
    RegisterProperty('SubLevel', 'integer', iptrw);
    RegisterProperty('MaxSubLevel', 'integer', iptrw);
    RegisterProperty('AttachInside', 'boolean', iptr);
    RegisterProperty('OnWalkPart', 'THookWalkPart', iptrw);
    RegisterProperty('MaxLineLength', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_mimepart(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMimePart');
  CL.AddTypeS('THookWalkPart', 'Procedure ( const Sender : TMimePart)');
  CL.AddTypeS('TMimePrimary', '( MP_TEXT, MP_MULTIPART, MP_MESSAGE, MP_BINARY )');
  CL.AddTypeS('TMimeEncoding', '( ME_7BIT, ME_8BIT, ME_QUOTED_PRINTABLE, ME_BASE64, ME_UU, ME_XX )');
  SIRegister_TMimePart(CL);
 CL.AddConstantN('MaxMimeType','LongInt').SetInt( 25);
 CL.AddDelphiFunction('Function GenerateBoundary : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMimePartMaxLineLength_W(Self: TMimePart; const T: integer);
begin Self.MaxLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartMaxLineLength_R(Self: TMimePart; var T: integer);
begin T := Self.MaxLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartOnWalkPart_W(Self: TMimePart; const T: THookWalkPart);
begin Self.OnWalkPart := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartOnWalkPart_R(Self: TMimePart; var T: THookWalkPart);
begin T := Self.OnWalkPart; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartAttachInside_R(Self: TMimePart; var T: boolean);
begin T := Self.AttachInside; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartMaxSubLevel_W(Self: TMimePart; const T: integer);
begin Self.MaxSubLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartMaxSubLevel_R(Self: TMimePart; var T: integer);
begin T := Self.MaxSubLevel; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartSubLevel_W(Self: TMimePart; const T: integer);
begin Self.SubLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartSubLevel_R(Self: TMimePart; var T: integer);
begin T := Self.SubLevel; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartDecodedLines_R(Self: TMimePart; var T: TMemoryStream);
begin T := Self.DecodedLines; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartPostPart_R(Self: TMimePart; var T: TStringList);
begin T := Self.PostPart; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartPrePart_R(Self: TMimePart; var T: TStringList);
begin T := Self.PrePart; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartHeaders_R(Self: TMimePart; var T: TStringList);
begin T := Self.Headers; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartPartBody_R(Self: TMimePart; var T: TStringList);
begin T := Self.PartBody; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartLines_R(Self: TMimePart; var T: TStringList);
begin T := Self.Lines; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartFileName_W(Self: TMimePart; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartFileName_R(Self: TMimePart; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartBoundary_W(Self: TMimePart; const T: string);
begin Self.Boundary := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartBoundary_R(Self: TMimePart; var T: string);
begin T := Self.Boundary; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartContentID_W(Self: TMimePart; const T: string);
begin Self.ContentID := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartContentID_R(Self: TMimePart; var T: string);
begin T := Self.ContentID; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartDisposition_W(Self: TMimePart; const T: string);
begin Self.Disposition := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartDisposition_R(Self: TMimePart; var T: string);
begin T := Self.Disposition; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartDescription_W(Self: TMimePart; const T: string);
begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartDescription_R(Self: TMimePart; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartSecondary_W(Self: TMimePart; const T: string);
begin Self.Secondary := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartSecondary_R(Self: TMimePart; var T: string);
begin T := Self.Secondary; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartForcedHTMLConvert_W(Self: TMimePart; const T: Boolean);
begin Self.ForcedHTMLConvert := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartForcedHTMLConvert_R(Self: TMimePart; var T: Boolean);
begin T := Self.ForcedHTMLConvert; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartConvertCharset_W(Self: TMimePart; const T: Boolean);
begin Self.ConvertCharset := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartConvertCharset_R(Self: TMimePart; var T: Boolean);
begin T := Self.ConvertCharset; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartTargetCharset_W(Self: TMimePart; const T: TMimeChar);
begin Self.TargetCharset := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartTargetCharset_R(Self: TMimePart; var T: TMimeChar);
begin T := Self.TargetCharset; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartCharsetCode_W(Self: TMimePart; const T: TMimeChar);
begin Self.CharsetCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartCharsetCode_R(Self: TMimePart; var T: TMimeChar);
begin T := Self.CharsetCode; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartEncodingCode_W(Self: TMimePart; const T: TMimeEncoding);
begin Self.EncodingCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartEncodingCode_R(Self: TMimePart; var T: TMimeEncoding);
begin T := Self.EncodingCode; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartPrimaryCode_W(Self: TMimePart; const T: TMimePrimary);
begin Self.PrimaryCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartPrimaryCode_R(Self: TMimePart; var T: TMimePrimary);
begin T := Self.PrimaryCode; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartDefaultCharset_W(Self: TMimePart; const T: string);
begin Self.DefaultCharset := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartDefaultCharset_R(Self: TMimePart; var T: string);
begin T := Self.DefaultCharset; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartCharset_W(Self: TMimePart; const T: string);
begin Self.Charset := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartCharset_R(Self: TMimePart; var T: string);
begin T := Self.Charset; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartEncoding_W(Self: TMimePart; const T: string);
begin Self.Encoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartEncoding_R(Self: TMimePart; var T: string);
begin T := Self.Encoding; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartPrimary_W(Self: TMimePart; const T: string);
begin Self.Primary := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimePartPrimary_R(Self: TMimePart; var T: string);
begin T := Self.Primary; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_mimepart_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GenerateBoundary, 'GenerateBoundary', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMimePart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMimePart) do begin
    RegisterConstructor(@TMimePart.Create, 'Create');
      RegisterMethod(@TMimePart.Destroy, 'Free');
      RegisterMethod(@TMimePart.Assign, 'Assign');
    RegisterMethod(@TMimePart.AssignSubParts, 'AssignSubParts');
    RegisterMethod(@TMimePart.Clear, 'Clear');
    RegisterMethod(@TMimePart.DecodePart, 'DecodePart');
    RegisterMethod(@TMimePart.DecodePartHeader, 'DecodePartHeader');
    RegisterMethod(@TMimePart.EncodePart, 'EncodePart');
    RegisterMethod(@TMimePart.EncodePartHeader, 'EncodePartHeader');
    RegisterMethod(@TMimePart.MimeTypeFromExt, 'MimeTypeFromExt');
    RegisterMethod(@TMimePart.GetSubPartCount, 'GetSubPartCount');
    RegisterMethod(@TMimePart.GetSubPart, 'GetSubPart');
    RegisterMethod(@TMimePart.DeleteSubPart, 'DeleteSubPart');
    RegisterMethod(@TMimePart.ClearSubParts, 'ClearSubParts');
    RegisterMethod(@TMimePart.AddSubPart, 'AddSubPart');
    RegisterMethod(@TMimePart.DecomposeParts, 'DecomposeParts');
    RegisterMethod(@TMimePart.DecomposePartsBinary, 'DecomposePartsBinary');
    RegisterMethod(@TMimePart.ComposeParts, 'ComposeParts');
    RegisterMethod(@TMimePart.WalkPart, 'WalkPart');
    RegisterMethod(@TMimePart.CanSubPart, 'CanSubPart');
    RegisterPropertyHelper(@TMimePartPrimary_R,@TMimePartPrimary_W,'Primary');
    RegisterPropertyHelper(@TMimePartEncoding_R,@TMimePartEncoding_W,'Encoding');
    RegisterPropertyHelper(@TMimePartCharset_R,@TMimePartCharset_W,'Charset');
    RegisterPropertyHelper(@TMimePartDefaultCharset_R,@TMimePartDefaultCharset_W,'DefaultCharset');
    RegisterPropertyHelper(@TMimePartPrimaryCode_R,@TMimePartPrimaryCode_W,'PrimaryCode');
    RegisterPropertyHelper(@TMimePartEncodingCode_R,@TMimePartEncodingCode_W,'EncodingCode');
    RegisterPropertyHelper(@TMimePartCharsetCode_R,@TMimePartCharsetCode_W,'CharsetCode');
    RegisterPropertyHelper(@TMimePartTargetCharset_R,@TMimePartTargetCharset_W,'TargetCharset');
    RegisterPropertyHelper(@TMimePartConvertCharset_R,@TMimePartConvertCharset_W,'ConvertCharset');
    RegisterPropertyHelper(@TMimePartForcedHTMLConvert_R,@TMimePartForcedHTMLConvert_W,'ForcedHTMLConvert');
    RegisterPropertyHelper(@TMimePartSecondary_R,@TMimePartSecondary_W,'Secondary');
    RegisterPropertyHelper(@TMimePartDescription_R,@TMimePartDescription_W,'Description');
    RegisterPropertyHelper(@TMimePartDisposition_R,@TMimePartDisposition_W,'Disposition');
    RegisterPropertyHelper(@TMimePartContentID_R,@TMimePartContentID_W,'ContentID');
    RegisterPropertyHelper(@TMimePartBoundary_R,@TMimePartBoundary_W,'Boundary');
    RegisterPropertyHelper(@TMimePartFileName_R,@TMimePartFileName_W,'FileName');
    RegisterPropertyHelper(@TMimePartLines_R,nil,'Lines');
    RegisterPropertyHelper(@TMimePartPartBody_R,nil,'PartBody');
    RegisterPropertyHelper(@TMimePartHeaders_R,nil,'Headers');
    RegisterPropertyHelper(@TMimePartPrePart_R,nil,'PrePart');
    RegisterPropertyHelper(@TMimePartPostPart_R,nil,'PostPart');
    RegisterPropertyHelper(@TMimePartDecodedLines_R,nil,'DecodedLines');
    RegisterPropertyHelper(@TMimePartSubLevel_R,@TMimePartSubLevel_W,'SubLevel');
    RegisterPropertyHelper(@TMimePartMaxSubLevel_R,@TMimePartMaxSubLevel_W,'MaxSubLevel');
    RegisterPropertyHelper(@TMimePartAttachInside_R,nil,'AttachInside');
    RegisterPropertyHelper(@TMimePartOnWalkPart_R,@TMimePartOnWalkPart_W,'OnWalkPart');
    RegisterPropertyHelper(@TMimePartMaxLineLength_R,@TMimePartMaxLineLength_W,'MaxLineLength');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_mimepart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMimePart) do
  RIRegister_TMimePart(CL);
end;

 
 
{ TPSImport_mimepart }
(*----------------------------------------------------------------------------*)
procedure TPSImport_mimepart.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_mimepart(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_mimepart.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_mimepart(ri);
  RIRegister_mimepart_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
