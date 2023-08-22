unit uPSI_SOAPHTTPClient;
{
for webservice by max as a cgi
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
  TPSImport_SOAPHTTPClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THTTPRIO(CL: TPSPascalCompiler);
procedure SIRegister_SOAPHTTPClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_THTTPRIO(CL: TPSRuntimeClassImporter);
procedure RIRegister_SOAPHTTPClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Rio
  ,WSDLNode
  ,WSDLItems
  ,OPConvert
  ,OPToSOAPDomConv
  ,SOAPHTTPTrans
  //,WebNode      3.5
  //,XMLIntf
  ,SOAPHTTPClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SOAPHTTPClient]);
end;

// CL.AddTypeS('TGUID', 'record D1: LongWord; D2: word; D3: word; D4: array[0..7] of Byte; end');


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THTTPRIO(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRIO', 'THTTPRIO') do
  with CL.AddClassN(CL.FindClass('TRIO'),'THTTPRIO') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function QueryInterface(const IID: TGUID; out Obj): HResult, CdStdCall');
    //RegisterMethod('Function PostData( const UserData : WideString; const CheckSum : DWORD) : Boolean', CdStdCall);

    RegisterProperty('WSDLItems', 'TWSDLItems', iptr);
    RegisterProperty('WSDLLocation', 'string', iptrw);
    RegisterProperty('Service', 'string', iptrw);
    RegisterProperty('Port', 'string', iptrw);
    RegisterProperty('URL', 'string', iptrw);
    RegisterProperty('HTTPWebNode', 'THTTPReqResp', iptrw);
    RegisterProperty('Converter', 'TOPToSoapDomConvert', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SOAPHTTPClient(CL: TPSPascalCompiler);
begin
  SIRegister_THTTPRIO(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THTTPRIOConverter_W(Self: THTTPRIO; const T: TOPToSoapDomConvert);
begin Self.Converter := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOConverter_R(Self: THTTPRIO; var T: TOPToSoapDomConvert);
begin T := Self.Converter; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOHTTPWebNode_W(Self: THTTPRIO; const T: THTTPReqResp);
begin Self.HTTPWebNode := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOHTTPWebNode_R(Self: THTTPRIO; var T: THTTPReqResp);
begin T := Self.HTTPWebNode; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOURL_W(Self: THTTPRIO; const T: string);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOURL_R(Self: THTTPRIO; var T: string);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOPort_W(Self: THTTPRIO; const T: string);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOPort_R(Self: THTTPRIO; var T: string);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOService_W(Self: THTTPRIO; const T: string);
begin Self.Service := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOService_R(Self: THTTPRIO; var T: string);
begin T := Self.Service; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOWSDLLocation_W(Self: THTTPRIO; const T: string);
begin Self.WSDLLocation := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOWSDLLocation_R(Self: THTTPRIO; var T: string);
begin T := Self.WSDLLocation; end;

(*----------------------------------------------------------------------------*)
procedure THTTPRIOWSDLItems_R(Self: THTTPRIO; var T: TWSDLItems);
begin T := Self.WSDLItems; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTTPRIO(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTTPRIO) do begin
    RegisterConstructor(@THTTPRIO.Create, 'Create');
    RegisterMethod(@THTTPRIO.Destroy, 'Free');
    RegisterMethod(@THTTPRIO.QueryInterface, 'QueryInterface');

    RegisterPropertyHelper(@THTTPRIOWSDLItems_R,nil,'WSDLItems');
    RegisterPropertyHelper(@THTTPRIOWSDLLocation_R,@THTTPRIOWSDLLocation_W,'WSDLLocation');
    RegisterPropertyHelper(@THTTPRIOService_R,@THTTPRIOService_W,'Service');
    RegisterPropertyHelper(@THTTPRIOPort_R,@THTTPRIOPort_W,'Port');
    RegisterPropertyHelper(@THTTPRIOURL_R,@THTTPRIOURL_W,'URL');
    RegisterPropertyHelper(@THTTPRIOHTTPWebNode_R,@THTTPRIOHTTPWebNode_W,'HTTPWebNode');
    RegisterPropertyHelper(@THTTPRIOConverter_R,@THTTPRIOConverter_W,'Converter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SOAPHTTPClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THTTPRIO(CL);
end;

 
 
{ TPSImport_SOAPHTTPClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SOAPHTTPClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SOAPHTTPClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SOAPHTTPClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SOAPHTTPClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
