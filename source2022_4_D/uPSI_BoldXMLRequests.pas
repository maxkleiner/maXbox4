unit uPSI_BoldXMLRequests;
{
  maXml
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
  TPSImport_BoldXMLRequests = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBoldXMLRequest(CL: TPSPascalCompiler);
procedure SIRegister_BoldXMLRequests(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBoldXMLRequest(CL: TPSRuntimeClassImporter);
procedure RIRegister_BoldXMLRequests(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   MSXML_TLB
  ,BoldStringList
  ,BoldDefs
  ,BoldXMLRequests
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BoldXMLRequests]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldXMLRequest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBoldXMLRequest') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldXMLRequest') do begin
    RegisterMethod('Constructor CreateFromXML( const XML : WideString)');
    RegisterMethod('Constructor CreateInitialized( const VersionNo : string; const Encoding : string; const StandAlone : Boolean)');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure SetIdentifiedValues( const Values : TStrings; const DomElementTag : string; const AttributeTag : string)');
    RegisterMethod('Procedure SetParams( const Params : TStrings)');
    RegisterMethod('Procedure EnsureRoot( const TagName : string)');
    RegisterMethod('Function SetAction( const ActionName : string; const ActionPath : string) : IXMLDomElement');
    RegisterMethod('Procedure DeleteAction');
    RegisterMethod('Procedure AddParam( const Name : string; const Value : string)');
    RegisterMethod('Procedure AddIdentifiedValue( const IdString : string; const Value : string; const DomElementTag : string; const AttributeTag : string)');
    RegisterMethod('Procedure ReloadIdentifiedValues');
    RegisterProperty('DomDocument', 'IXMLDomDocument', iptr);
    RegisterProperty('Params', 'TBoldStringList', iptr);
    RegisterProperty('IdentifiedValues', 'TBoldStringList', iptr);
    RegisterProperty('ActionElement', 'IXMLDomElement', iptr);
    RegisterProperty('ActionPath', 'string', iptrw);
    RegisterProperty('ActionName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BoldXMLRequests(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DEFAULT_ACTION_PATH','String').SetString( '/SOAP:Envelope/SOAP:Body');
 CL.AddConstantN('DEFAULT_ACTION_NAME','String').SetString( 'BoldAction');
 CL.AddConstantN('DEFAULT_DOCUMENT_ELEMENT_NAME','String').SetString( 'BoldDocument');
 CL.AddConstantN('DEFAULT_IDSTRING_TAG','String').SetString( 'BoldId');
 CL.AddConstantN('DEFAULT_IDENTIFIEDVALUE_TAG','String').SetString( 'BoldObject');
 CL.AddConstantN('DEFAULT_VERSION_NO','String').SetString( '1.0');
 CL.AddConstantN('DEFAULT_ENCODING','String').SetString( 'iso-8859-1');
 //CL.AddConstantN('DEFAULT_STANDALONE','Boolean')BoolToStr( TRUE);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldXMLRequest');
  CL.AddTypeS('TBoldXMLMethodEvent', 'Procedure (const request: TBoldXMLRequest; out response : string)');
  SIRegister_TBoldXMLRequest(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBoldXMLRequestActionName_R(Self: TBoldXMLRequest; var T: string);
begin T := Self.ActionName; end;

(*----------------------------------------------------------------------------*)
procedure TBoldXMLRequestActionPath_W(Self: TBoldXMLRequest; const T: string);
begin Self.ActionPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoldXMLRequestActionPath_R(Self: TBoldXMLRequest; var T: string);
begin T := Self.ActionPath; end;

(*----------------------------------------------------------------------------*)
procedure TBoldXMLRequestActionElement_R(Self: TBoldXMLRequest; var T: IXMLDomElement);
begin T := Self.ActionElement; end;

(*----------------------------------------------------------------------------*)
procedure TBoldXMLRequestIdentifiedValues_R(Self: TBoldXMLRequest; var T: TBoldStringList);
begin T := Self.IdentifiedValues; end;

(*----------------------------------------------------------------------------*)
procedure TBoldXMLRequestParams_R(Self: TBoldXMLRequest; var T: TBoldStringList);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TBoldXMLRequestDomDocument_R(Self: TBoldXMLRequest; var T: IXMLDomDocument);
begin T := Self.DomDocument; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldXMLRequest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldXMLRequest) do
  begin
    RegisterVirtualConstructor(@TBoldXMLRequest.CreateFromXML, 'CreateFromXML');
    RegisterConstructor(@TBoldXMLRequest.CreateInitialized, 'CreateInitialized');
    RegisterConstructor(@TBoldXMLRequest.Create, 'Create');
    RegisterMethod(@TBoldXMLRequest.SetIdentifiedValues, 'SetIdentifiedValues');
    RegisterMethod(@TBoldXMLRequest.SetParams, 'SetParams');
    RegisterMethod(@TBoldXMLRequest.EnsureRoot, 'EnsureRoot');
    RegisterMethod(@TBoldXMLRequest.SetAction, 'SetAction');
    RegisterMethod(@TBoldXMLRequest.DeleteAction, 'DeleteAction');
    RegisterMethod(@TBoldXMLRequest.AddParam, 'AddParam');
    RegisterMethod(@TBoldXMLRequest.AddIdentifiedValue, 'AddIdentifiedValue');
    RegisterMethod(@TBoldXMLRequest.ReloadIdentifiedValues, 'ReloadIdentifiedValues');
    RegisterPropertyHelper(@TBoldXMLRequestDomDocument_R,nil,'DomDocument');
    RegisterPropertyHelper(@TBoldXMLRequestParams_R,nil,'Params');
    RegisterPropertyHelper(@TBoldXMLRequestIdentifiedValues_R,nil,'IdentifiedValues');
    RegisterPropertyHelper(@TBoldXMLRequestActionElement_R,nil,'ActionElement');
    RegisterPropertyHelper(@TBoldXMLRequestActionPath_R,@TBoldXMLRequestActionPath_W,'ActionPath');
    RegisterPropertyHelper(@TBoldXMLRequestActionName_R,nil,'ActionName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldXMLRequests(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldXMLRequest) do
  RIRegister_TBoldXMLRequest(CL);
end;

 
 
{ TPSImport_BoldXMLRequests }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldXMLRequests.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BoldXMLRequests(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldXMLRequests.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BoldXMLRequests(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
