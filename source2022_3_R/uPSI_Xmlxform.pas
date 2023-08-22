unit uPSI_Xmlxform;
{
   transformer with 3 publics     ttranslateevent
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
  TPSImport_Xmlxform = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXMLTransformClient(CL: TPSPascalCompiler);
procedure SIRegister_TXMLTransformProvider(CL: TPSPascalCompiler);
procedure SIRegister_TXMLTransform(CL: TPSPascalCompiler);
procedure SIRegister_Xmlxform(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Xmlxform_Routines(S: TPSExec);
procedure RIRegister_TXMLTransformClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXMLTransformProvider(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXMLTransform(CL: TPSRuntimeClassImporter);
procedure RIRegister_Xmlxform(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,Provider
  ,DB
  ,DBClient
  ,DSIntf
  ,xmldom
  ,xmlutil
  ,Xmlxform
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Xmlxform]);
end;

procedure TransformError(const Msg: string);
begin
  raise TranslateException.Create(Msg);
end;

procedure StringToFile(const S, FileName: string);
begin
  with TStringList.Create do
  try
    Text := S;
    SaveToFile(FileName);
  finally
    Free;
  end;
end;

function GetXMLData(DataSet: TClientDataSet): string;
var
  Stream: TStringStream;
begin
  Stream := TStringStream.Create('');
  try
    DataSet.SaveToStream(Stream, dfXML);
    Result := Stream.DataString;
  finally
    Stream.Free;
  end;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLTransformClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TXMLTransformClient') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TXMLTransformClient') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Function GetDataAsXml( const PublishTransformFile : string) : string');
    RegisterMethod('Function ApplyUpdates( const UpdateXML, UpdateTransformFile : string; MaxErrors : Integer) : Integer');
    RegisterMethod('Procedure SetParams( const ParamsXml, ParamsTransformFile : string)');
    RegisterProperty('RemoteServer', 'TCustomRemoteServer', iptrw);
    RegisterProperty('ProviderName', 'string', iptrw);
    RegisterProperty('TransformGetData', 'TXMLTransform', iptr);
    RegisterProperty('TransformApplyUpdates', 'TXMLTransform', iptr);
    RegisterProperty('TransformSetParams', 'TXMLTransform', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLTransformProvider(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomProvider', 'TXMLTransformProvider') do
  with CL.AddClassN(CL.FindClass('TCustomProvider'),'TXMLTransformProvider') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
     RegisterProperty('TransformRead', 'TXMLTransform', iptr);
    RegisterProperty('TransformWrite', 'TXMLTransform', iptr);
    RegisterProperty('XMLDataFile', 'string', iptrw);
    RegisterProperty('CacheData', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLTransform(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TXMLTransform') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TXMLTransform') do begin
    RegisterMethod('Function TransformXML( const SourceXml : string; const ATransformationFile : string) : string');
    RegisterProperty('Data', 'string', iptr);
    RegisterProperty('SourceXmlDocument', 'IDOMDocument', iptrw);
    RegisterProperty('SourceXmlFile', 'string', iptrw);
    RegisterProperty('SourceXml', 'string', iptrw);
    RegisterProperty('TransformationDocument', 'IDOMDocument', iptrw);
    RegisterProperty('EmptyDestinationDocument', 'IDOMDocument', iptrw);
    RegisterProperty('ResultDocument', 'IDOMDocument', iptr);
    RegisterProperty('ResultString', 'string', iptr);
    RegisterProperty('TransformationFile', 'string', iptrw);
    RegisterProperty('OnTranslate', 'TTranslateEvent', iptrw);
    RegisterProperty('BeforeEachRow', 'TRowEvent', iptrw);
    RegisterProperty('AfterEachRow', 'TRowEvent', iptrw);
    RegisterProperty('BeforeEachRowSet', 'TRowEvent', iptrw);
    RegisterProperty('AfterEachRowSet', 'TRowEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Xmlxform(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TranslateException');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMNode, 'IDOMNode');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDOMDocument, 'IDOMDocument');

  CL.AddTypeS('TTranslateEvent', 'Procedure ( Sender : TObject; Id : string; SrcNode: IDOMNode; var Value : string; DestNode : IDOMNode)');
  CL.AddTypeS('TRowEvent', 'Procedure ( Sender : TObject; Id : string; SrcNode: IDOMNode; DestNode : IDOMNode)');
  SIRegister_TXMLTransform(CL);
  SIRegister_TXMLTransformProvider(CL);
  SIRegister_TXMLTransformClient(CL);
 CL.AddDelphiFunction('Procedure TransformError( const Msg : string)');
 CL.AddDelphiFunction('Procedure StringToFile2( const S, FileName : string)');
 CL.AddDelphiFunction('Function GetXMLData( DataSet : TClientDataSet) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXMLTransformClientTransformSetParams_R(Self: TXMLTransformClient; var T: TXMLTransform);
begin T := Self.TransformSetParams; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformClientTransformApplyUpdates_R(Self: TXMLTransformClient; var T: TXMLTransform);
begin T := Self.TransformApplyUpdates; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformClientTransformGetData_R(Self: TXMLTransformClient; var T: TXMLTransform);
begin T := Self.TransformGetData; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformClientProviderName_W(Self: TXMLTransformClient; const T: string);
begin Self.ProviderName := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformClientProviderName_R(Self: TXMLTransformClient; var T: string);
begin T := Self.ProviderName; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformClientRemoteServer_W(Self: TXMLTransformClient; const T: TCustomRemoteServer);
begin Self.RemoteServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformClientRemoteServer_R(Self: TXMLTransformClient; var T: TCustomRemoteServer);
begin T := Self.RemoteServer; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformProviderCacheData_W(Self: TXMLTransformProvider; const T: Boolean);
begin Self.CacheData := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformProviderCacheData_R(Self: TXMLTransformProvider; var T: Boolean);
begin T := Self.CacheData; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformProviderXMLDataFile_W(Self: TXMLTransformProvider; const T: string);
begin Self.XMLDataFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformProviderXMLDataFile_R(Self: TXMLTransformProvider; var T: string);
begin T := Self.XMLDataFile; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformProviderTransformWrite_R(Self: TXMLTransformProvider; var T: TXMLTransform);
begin T := Self.TransformWrite; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformProviderTransformRead_R(Self: TXMLTransformProvider; var T: TXMLTransform);
begin T := Self.TransformRead; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformAfterEachRowSet_W(Self: TXMLTransform; const T: TRowEvent);
begin Self.AfterEachRowSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformAfterEachRowSet_R(Self: TXMLTransform; var T: TRowEvent);
begin T := Self.AfterEachRowSet; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformBeforeEachRowSet_W(Self: TXMLTransform; const T: TRowEvent);
begin Self.BeforeEachRowSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformBeforeEachRowSet_R(Self: TXMLTransform; var T: TRowEvent);
begin T := Self.BeforeEachRowSet; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformAfterEachRow_W(Self: TXMLTransform; const T: TRowEvent);
begin Self.AfterEachRow := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformAfterEachRow_R(Self: TXMLTransform; var T: TRowEvent);
begin T := Self.AfterEachRow; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformBeforeEachRow_W(Self: TXMLTransform; const T: TRowEvent);
begin Self.BeforeEachRow := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformBeforeEachRow_R(Self: TXMLTransform; var T: TRowEvent);
begin T := Self.BeforeEachRow; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformOnTranslate_W(Self: TXMLTransform; const T: TTranslateEvent);
begin Self.OnTranslate := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformOnTranslate_R(Self: TXMLTransform; var T: TTranslateEvent);
begin T := Self.OnTranslate; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformTransformationFile_W(Self: TXMLTransform; const T: string);
begin Self.TransformationFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformTransformationFile_R(Self: TXMLTransform; var T: string);
begin T := Self.TransformationFile; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformResultString_R(Self: TXMLTransform; var T: string);
begin T := Self.ResultString; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformResultDocument_R(Self: TXMLTransform; var T: IDOMDocument);
begin T := Self.ResultDocument; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformEmptyDestinationDocument_W(Self: TXMLTransform; const T: IDOMDocument);
begin Self.EmptyDestinationDocument := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformEmptyDestinationDocument_R(Self: TXMLTransform; var T: IDOMDocument);
begin T := Self.EmptyDestinationDocument; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformTransformationDocument_W(Self: TXMLTransform; const T: IDOMDocument);
begin Self.TransformationDocument := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformTransformationDocument_R(Self: TXMLTransform; var T: IDOMDocument);
begin T := Self.TransformationDocument; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformSourceXml_W(Self: TXMLTransform; const T: string);
begin Self.SourceXml := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformSourceXml_R(Self: TXMLTransform; var T: string);
begin T := Self.SourceXml; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformSourceXmlFile_W(Self: TXMLTransform; const T: string);
begin Self.SourceXmlFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformSourceXmlFile_R(Self: TXMLTransform; var T: string);
begin T := Self.SourceXmlFile; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformSourceXmlDocument_W(Self: TXMLTransform; const T: IDOMDocument);
begin Self.SourceXmlDocument := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformSourceXmlDocument_R(Self: TXMLTransform; var T: IDOMDocument);
begin T := Self.SourceXmlDocument; end;

(*----------------------------------------------------------------------------*)
procedure TXMLTransformData_R(Self: TXMLTransform; var T: string);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Xmlxform_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TransformError, 'TransformError', cdRegister);
 S.RegisterDelphiFunction(@StringToFile, 'StringToFile2', cdRegister);
 S.RegisterDelphiFunction(@GetXMLData, 'GetXMLData', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLTransformClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLTransformClient) do begin
    RegisterConstructor(@TXMLTransformClient.Create, 'Create');
       RegisterMethod(@TXMLTransformClient.Destroy, 'Free');
     RegisterVirtualMethod(@TXMLTransformClient.GetDataAsXml, 'GetDataAsXml');
    RegisterVirtualMethod(@TXMLTransformClient.ApplyUpdates, 'ApplyUpdates');
    RegisterMethod(@TXMLTransformClient.SetParams, 'SetParams');
    RegisterPropertyHelper(@TXMLTransformClientRemoteServer_R,@TXMLTransformClientRemoteServer_W,'RemoteServer');
    RegisterPropertyHelper(@TXMLTransformClientProviderName_R,@TXMLTransformClientProviderName_W,'ProviderName');
    RegisterPropertyHelper(@TXMLTransformClientTransformGetData_R,nil,'TransformGetData');
    RegisterPropertyHelper(@TXMLTransformClientTransformApplyUpdates_R,nil,'TransformApplyUpdates');
    RegisterPropertyHelper(@TXMLTransformClientTransformSetParams_R,nil,'TransformSetParams');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLTransformProvider(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLTransformProvider) do begin
    RegisterConstructor(@TXMLTransformProvider.Create, 'Create');
       RegisterMethod(@TXMLTransformProvider.Destroy, 'Free');
     RegisterPropertyHelper(@TXMLTransformProviderTransformRead_R,nil,'TransformRead');
    RegisterPropertyHelper(@TXMLTransformProviderTransformWrite_R,nil,'TransformWrite');
    RegisterPropertyHelper(@TXMLTransformProviderXMLDataFile_R,@TXMLTransformProviderXMLDataFile_W,'XMLDataFile');
    RegisterPropertyHelper(@TXMLTransformProviderCacheData_R,@TXMLTransformProviderCacheData_W,'CacheData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLTransform(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLTransform) do begin
    RegisterMethod(@TXMLTransform.TransformXML, 'TransformXML');
    RegisterPropertyHelper(@TXMLTransformData_R,nil,'Data');
    RegisterPropertyHelper(@TXMLTransformSourceXmlDocument_R,@TXMLTransformSourceXmlDocument_W,'SourceXmlDocument');
    RegisterPropertyHelper(@TXMLTransformSourceXmlFile_R,@TXMLTransformSourceXmlFile_W,'SourceXmlFile');
    RegisterPropertyHelper(@TXMLTransformSourceXml_R,@TXMLTransformSourceXml_W,'SourceXml');
    RegisterPropertyHelper(@TXMLTransformTransformationDocument_R,@TXMLTransformTransformationDocument_W,'TransformationDocument');
    RegisterPropertyHelper(@TXMLTransformEmptyDestinationDocument_R,@TXMLTransformEmptyDestinationDocument_W,'EmptyDestinationDocument');
    RegisterPropertyHelper(@TXMLTransformResultDocument_R,nil,'ResultDocument');
    RegisterPropertyHelper(@TXMLTransformResultString_R,nil,'ResultString');
    RegisterPropertyHelper(@TXMLTransformTransformationFile_R,@TXMLTransformTransformationFile_W,'TransformationFile');
    RegisterPropertyHelper(@TXMLTransformOnTranslate_R,@TXMLTransformOnTranslate_W,'OnTranslate');
    RegisterPropertyHelper(@TXMLTransformBeforeEachRow_R,@TXMLTransformBeforeEachRow_W,'BeforeEachRow');
    RegisterPropertyHelper(@TXMLTransformAfterEachRow_R,@TXMLTransformAfterEachRow_W,'AfterEachRow');
    RegisterPropertyHelper(@TXMLTransformBeforeEachRowSet_R,@TXMLTransformBeforeEachRowSet_W,'BeforeEachRowSet');
    RegisterPropertyHelper(@TXMLTransformAfterEachRowSet_R,@TXMLTransformAfterEachRowSet_W,'AfterEachRowSet');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Xmlxform(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TranslateException) do
  RIRegister_TXMLTransform(CL);
  RIRegister_TXMLTransformProvider(CL);
  RIRegister_TXMLTransformClient(CL);
end;

 
 
{ TPSImport_Xmlxform }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Xmlxform.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Xmlxform(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Xmlxform.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Xmlxform(ri);
  RIRegister_Xmlxform_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
