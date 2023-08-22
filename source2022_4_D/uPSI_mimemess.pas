unit uPSI_mimemess;
{
   synapse
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
  TPSImport_mimemess = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMimeMess(CL: TPSPascalCompiler);
procedure SIRegister_TMessHeader(CL: TPSPascalCompiler);
procedure SIRegister_mimemess(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMimeMess(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMessHeader(CL: TPSRuntimeClassImporter);
procedure RIRegister_mimemess(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   mimepart
  ,synachar
  ,synautil
  ,mimeinln
  ,mimemess
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_mimemess]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMimeMess(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMimeMess') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMimeMess') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Constructor CreateAltHeaders( HeadClass : TMessHeaderClass)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function AddPart( const PartParent : TMimePart) : TMimePart');
    RegisterMethod('Function AddPartMultipart( const MultipartType : String; const PartParent : TMimePart) : TMimePart');
    RegisterMethod('Function AddPartText( const Value : TStrings; const PartParent : TMimePart) : TMimepart');
    RegisterMethod('Function AddPartTextEx( const Value : TStrings; const PartParent : TMimePart; PartCharset : TMimeChar; Raw : Boolean; PartEncoding : TMimeEncoding) : TMimepart');
    RegisterMethod('Function AddPartHTML( const Value : TStrings; const PartParent : TMimePart) : TMimepart');
    RegisterMethod('Function AddPartTextFromFile( const FileName : String; const PartParent : TMimePart) : TMimepart');
    RegisterMethod('Function AddPartHTMLFromFile( const FileName : String; const PartParent : TMimePart) : TMimepart');
    RegisterMethod('Function AddPartBinary( const Stream : TStream; const FileName : string; const PartParent : TMimePart) : TMimepart');
    RegisterMethod('Function AddPartBinaryFromFile( const FileName : string; const PartParent : TMimePart) : TMimepart');
    RegisterMethod('Function AddPartHTMLBinary( const Stream : TStream; const FileName, Cid : string; const PartParent : TMimePart) : TMimepart');
    RegisterMethod('Function AddPartHTMLBinaryFromFile( const FileName, Cid : string; const PartParent : TMimePart) : TMimepart');
    RegisterMethod('Function AddPartMess( const Value : TStrings; const PartParent : TMimePart) : TMimepart');
    RegisterMethod('Function AddPartMessFromFile( const FileName : string; const PartParent : TMimePart) : TMimepart');
    RegisterMethod('Procedure EncodeMessage');
    RegisterMethod('Procedure DecodeMessage');
    RegisterMethod('Procedure DecodeMessageBinary( AHeader : TStrings; AData : TMemoryStream)');
    RegisterProperty('MessagePart', 'TMimePart', iptr);
    RegisterProperty('Lines', 'TStringList', iptr);
    RegisterProperty('Header', 'TMessHeader', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMessHeader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMessHeader') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMessHeader') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure EncodeHeaders( const Value : TStrings)');
    RegisterMethod('Procedure DecodeHeaders( const Value : TStrings)');
    RegisterMethod('Function FindHeader( Value : string) : string');
    RegisterMethod('Procedure FindHeaderList( Value : string; const HeaderList : TStrings)');
    RegisterProperty('From', 'string', iptrw);
    RegisterProperty('ToList', 'TStringList', iptr);
    RegisterProperty('CCList', 'TStringList', iptr);
    RegisterProperty('Subject', 'string', iptrw);
    RegisterProperty('Organization', 'string', iptrw);
    RegisterProperty('CustomHeaders', 'TStringList', iptr);
    RegisterProperty('Date', 'TDateTime', iptrw);
    RegisterProperty('XMailer', 'string', iptrw);
    RegisterProperty('ReplyTo', 'string', iptrw);
    RegisterProperty('MessageID', 'string', iptrw);
    RegisterProperty('Priority', 'TMessPriority', iptrw);
    RegisterProperty('CharsetCode', 'TMimeChar', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_mimemess(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMessPriority', '( MP_unknown, MP_low, MP_normal, MP_high )');
  SIRegister_TMessHeader(CL);
  //CL.AddTypeS('TMessHeaderClass', 'class of TMessHeader');
  SIRegister_TMimeMess(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMimeMessHeader_R(Self: TMimeMess; var T: TMessHeader);
begin T := Self.Header; end;

(*----------------------------------------------------------------------------*)
procedure TMimeMessLines_R(Self: TMimeMess; var T: TStringList);
begin T := Self.Lines; end;

(*----------------------------------------------------------------------------*)
procedure TMimeMessMessagePart_R(Self: TMimeMess; var T: TMimePart);
begin T := Self.MessagePart; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderCharsetCode_W(Self: TMessHeader; const T: TMimeChar);
begin Self.CharsetCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderCharsetCode_R(Self: TMessHeader; var T: TMimeChar);
begin T := Self.CharsetCode; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderPriority_W(Self: TMessHeader; const T: TMessPriority);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderPriority_R(Self: TMessHeader; var T: TMessPriority);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderMessageID_W(Self: TMessHeader; const T: string);
begin Self.MessageID := T; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderMessageID_R(Self: TMessHeader; var T: string);
begin T := Self.MessageID; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderReplyTo_W(Self: TMessHeader; const T: string);
begin Self.ReplyTo := T; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderReplyTo_R(Self: TMessHeader; var T: string);
begin T := Self.ReplyTo; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderXMailer_W(Self: TMessHeader; const T: string);
begin Self.XMailer := T; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderXMailer_R(Self: TMessHeader; var T: string);
begin T := Self.XMailer; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderDate_W(Self: TMessHeader; const T: TDateTime);
begin Self.Date := T; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderDate_R(Self: TMessHeader; var T: TDateTime);
begin T := Self.Date; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderCustomHeaders_R(Self: TMessHeader; var T: TStringList);
begin T := Self.CustomHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderOrganization_W(Self: TMessHeader; const T: string);
begin Self.Organization := T; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderOrganization_R(Self: TMessHeader; var T: string);
begin T := Self.Organization; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderSubject_W(Self: TMessHeader; const T: string);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderSubject_R(Self: TMessHeader; var T: string);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderCCList_R(Self: TMessHeader; var T: TStringList);
begin T := Self.CCList; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderToList_R(Self: TMessHeader; var T: TStringList);
begin T := Self.ToList; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderFrom_W(Self: TMessHeader; const T: string);
begin Self.From := T; end;

(*----------------------------------------------------------------------------*)
procedure TMessHeaderFrom_R(Self: TMessHeader; var T: string);
begin T := Self.From; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMimeMess(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMimeMess) do begin
    RegisterConstructor(@TMimeMess.Create, 'Create');
    RegisterConstructor(@TMimeMess.CreateAltHeaders, 'CreateAltHeaders');
    RegisterVirtualMethod(@TMimeMess.Clear, 'Clear');
    RegisterMethod(@TMimeMess.Destroy, 'Free');
    RegisterMethod(@TMimeMess.AddPart, 'AddPart');
    RegisterMethod(@TMimeMess.AddPartMultipart, 'AddPartMultipart');
    RegisterMethod(@TMimeMess.AddPartText, 'AddPartText');
    RegisterMethod(@TMimeMess.AddPartTextEx, 'AddPartTextEx');
    RegisterMethod(@TMimeMess.AddPartHTML, 'AddPartHTML');
    RegisterMethod(@TMimeMess.AddPartTextFromFile, 'AddPartTextFromFile');
    RegisterMethod(@TMimeMess.AddPartHTMLFromFile, 'AddPartHTMLFromFile');
    RegisterMethod(@TMimeMess.AddPartBinary, 'AddPartBinary');
    RegisterMethod(@TMimeMess.AddPartBinaryFromFile, 'AddPartBinaryFromFile');
    RegisterMethod(@TMimeMess.AddPartHTMLBinary, 'AddPartHTMLBinary');
    RegisterMethod(@TMimeMess.AddPartHTMLBinaryFromFile, 'AddPartHTMLBinaryFromFile');
    RegisterMethod(@TMimeMess.AddPartMess, 'AddPartMess');
    RegisterMethod(@TMimeMess.AddPartMessFromFile, 'AddPartMessFromFile');
    RegisterMethod(@TMimeMess.EncodeMessage, 'EncodeMessage');
    RegisterMethod(@TMimeMess.DecodeMessage, 'DecodeMessage');
    RegisterMethod(@TMimeMess.DecodeMessageBinary, 'DecodeMessageBinary');
    RegisterPropertyHelper(@TMimeMessMessagePart_R,nil,'MessagePart');
    RegisterPropertyHelper(@TMimeMessLines_R,nil,'Lines');
    RegisterPropertyHelper(@TMimeMessHeader_R,nil,'Header');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMessHeader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMessHeader) do begin
    RegisterVirtualConstructor(@TMessHeader.Create, 'Create');
    RegisterMethod(@TMessHeader.Destroy, 'Free');
    RegisterVirtualMethod(@TMessHeader.Clear, 'Clear');
    RegisterVirtualMethod(@TMessHeader.EncodeHeaders, 'EncodeHeaders');
    RegisterMethod(@TMessHeader.DecodeHeaders, 'DecodeHeaders');
    RegisterMethod(@TMessHeader.FindHeader, 'FindHeader');
    RegisterMethod(@TMessHeader.FindHeaderList, 'FindHeaderList');
    RegisterPropertyHelper(@TMessHeaderFrom_R,@TMessHeaderFrom_W,'From');
    RegisterPropertyHelper(@TMessHeaderToList_R,nil,'ToList');
    RegisterPropertyHelper(@TMessHeaderCCList_R,nil,'CCList');
    RegisterPropertyHelper(@TMessHeaderSubject_R,@TMessHeaderSubject_W,'Subject');
    RegisterPropertyHelper(@TMessHeaderOrganization_R,@TMessHeaderOrganization_W,'Organization');
    RegisterPropertyHelper(@TMessHeaderCustomHeaders_R,nil,'CustomHeaders');
    RegisterPropertyHelper(@TMessHeaderDate_R,@TMessHeaderDate_W,'Date');
    RegisterPropertyHelper(@TMessHeaderXMailer_R,@TMessHeaderXMailer_W,'XMailer');
    RegisterPropertyHelper(@TMessHeaderReplyTo_R,@TMessHeaderReplyTo_W,'ReplyTo');
    RegisterPropertyHelper(@TMessHeaderMessageID_R,@TMessHeaderMessageID_W,'MessageID');
    RegisterPropertyHelper(@TMessHeaderPriority_R,@TMessHeaderPriority_W,'Priority');
    RegisterPropertyHelper(@TMessHeaderCharsetCode_R,@TMessHeaderCharsetCode_W,'CharsetCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_mimemess(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMessHeader(CL);
  RIRegister_TMimeMess(CL);
end;

 
 
{ TPSImport_mimemess }
(*----------------------------------------------------------------------------*)
procedure TPSImport_mimemess.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_mimemess(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_mimemess.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_mimemess(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
