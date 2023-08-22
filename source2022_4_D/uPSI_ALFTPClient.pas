unit uPSI_ALFTPClient;
{
   back to indy
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
  TPSImport_ALFTPClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALFTPClient(CL: TPSPascalCompiler);
procedure SIRegister_TALFTPClientProxyParams(CL: TPSPascalCompiler);
procedure SIRegister_EALFTPClientException(CL: TPSPascalCompiler);
procedure SIRegister_ALFTPClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALFTPClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFTPClientProxyParams(CL: TPSRuntimeClassImporter);
procedure RIRegister_EALFTPClientException(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALFTPClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ALFTPClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFTPClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFTPClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALFTPClient') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALFTPClient') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure CreateDirectory( const Directory : AnsiString)');
    RegisterMethod('Procedure DeleteFile( const FileName : AnsiString)');
    RegisterMethod('Function FindFirst( const Path : AnsiString; const Attr : Integer; var F : TALFtpclientSearchRec) : Integer');
    RegisterMethod('Function FindNext( var F : TALFtpclientSearchRec) : Integer');
    RegisterMethod('Procedure FindClose( var F : TALFtpclientSearchRec)');
    RegisterMethod('Function GetCurrentDirectory : AnsiString');
    RegisterMethod('Procedure GetFile( const RemoteFile : AnsiString; const LocalFile : AnsiString; FailIfExists : Boolean);');
    RegisterMethod('Procedure GetFile1( const RemoteFile : AnsiString; DataStream : Tstream);');
    RegisterMethod('Function GetFileSize( const filename : AnsiString) : Longword');
    RegisterMethod('Procedure PutFile( const LocalFile : AnsiString; const Remotefile : AnsiString);');
    RegisterMethod('Procedure PutFile1( DataStream : TStream; const Remotefile : AnsiString);');
    RegisterMethod('Procedure RemoveDirectory( const Directory : AnsiString)');
    RegisterMethod('Procedure RenameFile( const ExistingFile : AnsiString; const NewFile : AnsiString)');
    RegisterMethod('Procedure SetCurrentDirectory( const Directory : AnsiString)');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');
    RegisterProperty('connected', 'Boolean', iptrw);
    RegisterProperty('ServerName', 'AnsiString', iptrw);
    RegisterProperty('ServerPort', 'integer', iptrw);
    RegisterProperty('UserName', 'AnsiString', iptrw);
    RegisterProperty('Password', 'AnsiString', iptrw);
    RegisterProperty('ConnectTimeout', 'Integer', iptrw);
    RegisterProperty('SendTimeout', 'Integer', iptrw);
    RegisterProperty('ReceiveTimeout', 'Integer', iptrw);
    RegisterProperty('UploadBufferSize', 'Integer', iptrw);
    RegisterProperty('ProxyParams', 'TALFTPClientProxyParams', iptr);
    RegisterProperty('OnUploadProgress', 'TALFTPClientUploadProgressEvent', iptrw);
    RegisterProperty('OnDownloadProgress', 'TALFTPClientDownloadProgressEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFTPClientProxyParams(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALFTPClientProxyParams') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALFTPClientProxyParams') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
    RegisterProperty('ProxyBypass', 'AnsiString', iptrw);
    RegisterProperty('ProxyServer', 'AnsiString', iptrw);
    RegisterProperty('ProxyPort', 'integer', iptrw);
    RegisterProperty('ProxyUserName', 'AnsiString', iptrw);
    RegisterProperty('ProxyPassword', 'AnsiString', iptrw);
    RegisterProperty('OnChange', 'TALFTPPropertyChangeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EALFTPClientException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EALFTPClientException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EALFTPClientException') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFTPClient(CL: TPSPascalCompiler);
begin
  SIRegister_EALFTPClientException(CL);
  CL.AddTypeS('TALFTPPropertyChangeEvent', 'Procedure ( sender : Tobject; const PropertyIndex : Integer)');
  SIRegister_TALFTPClientProxyParams(CL);
  CL.AddTypeS('TALFTPClientUploadProgressEvent', 'Procedure ( sender : Tobject; Sent : Integer; Total : Integer)');
  CL.AddTypeS('TALFTPClientDownloadProgressEvent', 'Procedure ( sender : Tobject; Read : Integer; Total : Integer)');
  //CL.AddTypeS('TALFtpclientSearchRec', 'record Time : Integer; Size : Integer; '
   //+'Attr : Integer; Name : AnsiString; ExcludeAttr : Integer; FindHandle : Integer; FindData : TWin32FindDataA; end');
  SIRegister_TALFTPClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALFTPClientOnDownloadProgress_W(Self: TALFTPClient; const T: TALFTPClientDownloadProgressEvent);
begin Self.OnDownloadProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientOnDownloadProgress_R(Self: TALFTPClient; var T: TALFTPClientDownloadProgressEvent);
begin T := Self.OnDownloadProgress; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientOnUploadProgress_W(Self: TALFTPClient; const T: TALFTPClientUploadProgressEvent);
begin Self.OnUploadProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientOnUploadProgress_R(Self: TALFTPClient; var T: TALFTPClientUploadProgressEvent);
begin T := Self.OnUploadProgress; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParams_R(Self: TALFTPClient; var T: TALFTPClientProxyParams);
begin T := Self.ProxyParams; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientUploadBufferSize_W(Self: TALFTPClient; const T: Integer);
begin Self.UploadBufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientUploadBufferSize_R(Self: TALFTPClient; var T: Integer);
begin T := Self.UploadBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientReceiveTimeout_W(Self: TALFTPClient; const T: Integer);
begin Self.ReceiveTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientReceiveTimeout_R(Self: TALFTPClient; var T: Integer);
begin T := Self.ReceiveTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientSendTimeout_W(Self: TALFTPClient; const T: Integer);
begin Self.SendTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientSendTimeout_R(Self: TALFTPClient; var T: Integer);
begin T := Self.SendTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientConnectTimeout_W(Self: TALFTPClient; const T: Integer);
begin Self.ConnectTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientConnectTimeout_R(Self: TALFTPClient; var T: Integer);
begin T := Self.ConnectTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientPassword_W(Self: TALFTPClient; const T: AnsiString);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientPassword_R(Self: TALFTPClient; var T: AnsiString);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientUserName_W(Self: TALFTPClient; const T: AnsiString);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientUserName_R(Self: TALFTPClient; var T: AnsiString);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientServerPort_W(Self: TALFTPClient; const T: integer);
begin Self.ServerPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientServerPort_R(Self: TALFTPClient; var T: integer);
begin T := Self.ServerPort; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientServerName_W(Self: TALFTPClient; const T: AnsiString);
begin Self.ServerName := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientServerName_R(Self: TALFTPClient; var T: AnsiString);
begin T := Self.ServerName; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientconnected_W(Self: TALFTPClient; const T: Boolean);
begin Self.connected := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientconnected_R(Self: TALFTPClient; var T: Boolean);
begin T := Self.connected; end;

(*----------------------------------------------------------------------------*)
Procedure TALFTPClientPutFile1_P(Self: TALFTPClient;  DataStream : TStream; const Remotefile : AnsiString);
Begin Self.PutFile(DataStream, Remotefile); END;

(*----------------------------------------------------------------------------*)
Procedure TALFTPClientPutFile_P(Self: TALFTPClient;  const LocalFile : AnsiString; const Remotefile : AnsiString);
Begin Self.PutFile(LocalFile, Remotefile); END;

(*----------------------------------------------------------------------------*)
Procedure TALFTPClientGetFile1_P(Self: TALFTPClient;  const RemoteFile : AnsiString; DataStream : Tstream);
Begin Self.GetFile(RemoteFile, DataStream); END;

(*----------------------------------------------------------------------------*)
Procedure TALFTPClientGetFile_P(Self: TALFTPClient;  const RemoteFile : AnsiString; const LocalFile : AnsiString; FailIfExists : Boolean);
Begin Self.GetFile(RemoteFile, LocalFile, FailIfExists); END;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsOnChange_W(Self: TALFTPClientProxyParams; const T: TALFTPPropertyChangeEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsOnChange_R(Self: TALFTPClientProxyParams; var T: TALFTPPropertyChangeEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsProxyPassword_W(Self: TALFTPClientProxyParams; const T: AnsiString);
begin Self.ProxyPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsProxyPassword_R(Self: TALFTPClientProxyParams; var T: AnsiString);
begin T := Self.ProxyPassword; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsProxyUserName_W(Self: TALFTPClientProxyParams; const T: AnsiString);
begin Self.ProxyUserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsProxyUserName_R(Self: TALFTPClientProxyParams; var T: AnsiString);
begin T := Self.ProxyUserName; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsProxyPort_W(Self: TALFTPClientProxyParams; const T: integer);
begin Self.ProxyPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsProxyPort_R(Self: TALFTPClientProxyParams; var T: integer);
begin T := Self.ProxyPort; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsProxyServer_W(Self: TALFTPClientProxyParams; const T: AnsiString);
begin Self.ProxyServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsProxyServer_R(Self: TALFTPClientProxyParams; var T: AnsiString);
begin T := Self.ProxyServer; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsProxyBypass_W(Self: TALFTPClientProxyParams; const T: AnsiString);
begin Self.ProxyBypass := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFTPClientProxyParamsProxyBypass_R(Self: TALFTPClientProxyParams; var T: AnsiString);
begin T := Self.ProxyBypass; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFTPClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFTPClient) do begin
    RegisterVirtualConstructor(@TALFTPClient.Create, 'Create');
    RegisterMethod(@TALFTPClient.Destroy,'Free');
    RegisterVirtualMethod(@TALFTPClient.CreateDirectory, 'CreateDirectory');
    RegisterVirtualMethod(@TALFTPClient.DeleteFile, 'DeleteFile');
    RegisterVirtualMethod(@TALFTPClient.FindFirst, 'FindFirst');
    RegisterVirtualMethod(@TALFTPClient.FindNext, 'FindNext');
    RegisterVirtualMethod(@TALFTPClient.FindClose, 'FindClose');
    RegisterVirtualMethod(@TALFTPClient.GetCurrentDirectory, 'GetCurrentDirectory');
    RegisterVirtualMethod(@TALFTPClientGetFile_P, 'GetFile');
    RegisterVirtualMethod(@TALFTPClientGetFile1_P, 'GetFile1');
    RegisterVirtualMethod(@TALFTPClient.GetFileSize, 'GetFileSize');
    RegisterVirtualMethod(@TALFTPClientPutFile_P, 'PutFile');
    RegisterVirtualMethod(@TALFTPClientPutFile1_P, 'PutFile1');
    RegisterVirtualMethod(@TALFTPClient.RemoveDirectory, 'RemoveDirectory');
    RegisterVirtualMethod(@TALFTPClient.RenameFile, 'RenameFile');
    RegisterVirtualMethod(@TALFTPClient.SetCurrentDirectory, 'SetCurrentDirectory');
    RegisterVirtualMethod(@TALFTPClient.Connect, 'Connect');
    RegisterVirtualMethod(@TALFTPClient.Disconnect, 'Disconnect');
    RegisterPropertyHelper(@TALFTPClientconnected_R,@TALFTPClientconnected_W,'connected');
    RegisterPropertyHelper(@TALFTPClientServerName_R,@TALFTPClientServerName_W,'ServerName');
    RegisterPropertyHelper(@TALFTPClientServerPort_R,@TALFTPClientServerPort_W,'ServerPort');
    RegisterPropertyHelper(@TALFTPClientUserName_R,@TALFTPClientUserName_W,'UserName');
    RegisterPropertyHelper(@TALFTPClientPassword_R,@TALFTPClientPassword_W,'Password');
    RegisterPropertyHelper(@TALFTPClientConnectTimeout_R,@TALFTPClientConnectTimeout_W,'ConnectTimeout');
    RegisterPropertyHelper(@TALFTPClientSendTimeout_R,@TALFTPClientSendTimeout_W,'SendTimeout');
    RegisterPropertyHelper(@TALFTPClientReceiveTimeout_R,@TALFTPClientReceiveTimeout_W,'ReceiveTimeout');
    RegisterPropertyHelper(@TALFTPClientUploadBufferSize_R,@TALFTPClientUploadBufferSize_W,'UploadBufferSize');
    RegisterPropertyHelper(@TALFTPClientProxyParams_R,nil,'ProxyParams');
    RegisterPropertyHelper(@TALFTPClientOnUploadProgress_R,@TALFTPClientOnUploadProgress_W,'OnUploadProgress');
    RegisterPropertyHelper(@TALFTPClientOnDownloadProgress_R,@TALFTPClientOnDownloadProgress_W,'OnDownloadProgress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFTPClientProxyParams(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFTPClientProxyParams) do
  begin
    RegisterVirtualConstructor(@TALFTPClientProxyParams.Create, 'Create');
    RegisterMethod(@TALFTPClientProxyParams.Clear, 'Clear');
    RegisterPropertyHelper(@TALFTPClientProxyParamsProxyBypass_R,@TALFTPClientProxyParamsProxyBypass_W,'ProxyBypass');
    RegisterPropertyHelper(@TALFTPClientProxyParamsProxyServer_R,@TALFTPClientProxyParamsProxyServer_W,'ProxyServer');
    RegisterPropertyHelper(@TALFTPClientProxyParamsProxyPort_R,@TALFTPClientProxyParamsProxyPort_W,'ProxyPort');
    RegisterPropertyHelper(@TALFTPClientProxyParamsProxyUserName_R,@TALFTPClientProxyParamsProxyUserName_W,'ProxyUserName');
    RegisterPropertyHelper(@TALFTPClientProxyParamsProxyPassword_R,@TALFTPClientProxyParamsProxyPassword_W,'ProxyPassword');
    RegisterPropertyHelper(@TALFTPClientProxyParamsOnChange_R,@TALFTPClientProxyParamsOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EALFTPClientException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EALFTPClientException) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFTPClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EALFTPClientException(CL);
  RIRegister_TALFTPClientProxyParams(CL);
  RIRegister_TALFTPClient(CL);
end;

 
 
{ TPSImport_ALFTPClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFTPClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFTPClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFTPClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALFTPClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
