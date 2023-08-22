unit uPSI_IdFTPServer;
{
  just another server service   with list now!
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
  TPSImport_IdFTPServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdFTPServer(CL: TPSPascalCompiler);
procedure SIRegister_TIdFTPServerThread(CL: TPSPascalCompiler);
procedure SIRegister_TIdDataChannelThread(CL: TPSPascalCompiler);
procedure SIRegister_IdFTPServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdFTPServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdFTPServerThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdDataChannelThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdFTPServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdException
  ,IdFTPList
  ,IdTCPServer
  ,IdTCPConnection
  ,IdUserAccounts
  ,IdFTPCommon
  ,IdThread
  ,IdRFCReply
  ,IdFTPServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdFTPServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdFTPServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdFTPServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdFTPServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterProperty('AllowAnonymousLogin', 'Boolean', iptrw);
    RegisterProperty('AnonymousAccounts', 'TStringList', iptrw);
    RegisterProperty('AnonymousPassStrictCheck', 'Boolean', iptrw);
    RegisterProperty('DefaultDataPort', 'Integer', iptrw);
    RegisterProperty('EmulateSystem', 'TIdFTPSystems', iptrw);
    RegisterProperty('HelpReply', 'Tstrings', iptrw);
    RegisterProperty('UserAccounts', 'TIdUserManager', iptrw);
    RegisterProperty('SystemType', 'string', iptrw);
    RegisterProperty('OnAfterUserLogin', 'TOnAfterUserLoginEvent', iptrw);
    RegisterProperty('OnChangeDirectory', 'TOnDirectoryEvent', iptrw);
    RegisterProperty('OnGetCustomListFormat', 'TIdOnGetCustomListFormat', iptrw);
    RegisterProperty('OnGetFileSize', 'TOnGetFileSizeEvent', iptrw);
    RegisterProperty('OnUserLogin', 'TOnUserLoginEvent', iptrw);
    RegisterProperty('OnListDirectory', 'TOnListDirectoryEvent', iptrw);
    RegisterProperty('OnRenameFile', 'TOnRenameFileEvent', iptrw);
    RegisterProperty('OnDeleteFile', 'TOnFileEvent', iptrw);
    RegisterProperty('OnRetrieveFile', 'TOnRetrieveFileEvent', iptrw);
    RegisterProperty('OnStoreFile', 'TOnStoreFileEvent', iptrw);
    RegisterProperty('OnMakeDirectory', 'TOnDirectoryEvent', iptrw);
    RegisterProperty('OnRemoveDirectory', 'TOnDirectoryEvent', iptrw);
    RegisterProperty('OnPASV', 'TOnPASVEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdFTPServerThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdPeerThread', 'TIdFTPServerThread') do
  with CL.AddClassN(CL.FindClass('TIdPeerThread'),'TIdFTPServerThread') do begin
    RegisterMethod('Constructor Create( ACreateSuspended : Boolean)');
     RegisterMethod('Procedure Free;');
    RegisterProperty('Authenticated', 'Boolean', iptrw);
    RegisterProperty('ALLOSize', 'Integer', iptrw);
    RegisterProperty('CurrentDir', 'string', iptrw);
    RegisterProperty('DataChannelThread', 'TIdDataChannelThread', iptrw);
    RegisterProperty('DataType', 'TIdFTPTransferType', iptrw);
    RegisterProperty('DataMode', 'TIdFTPTransferMode', iptrw);
    RegisterProperty('DataPort', 'Integer', iptr);
    RegisterProperty('DataStruct', 'TIdFTPDataStructure', iptrw);
    RegisterProperty('HomeDir', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('PASV', 'Boolean', iptrw);
    RegisterProperty('RESTPos', 'Integer', iptrw);
    RegisterProperty('Username', 'string', iptrw);
    RegisterProperty('UserType', 'TIdFTPUserType', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdDataChannelThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdThread', 'TIdDataChannelThread') do
  with CL.AddClassN(CL.FindClass('TIdThread'),'TIdDataChannelThread') do begin
    RegisterMethod('Constructor Create( APASV : Boolean; AControlConnection : TIdTCPServerConnection)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure StartThread( AOperation : TIdFTPOperation)');
    RegisterMethod('Procedure SetupDataChannel( const AIP : string; APort : Integer)');
    RegisterProperty('OKReply', 'TIdRFCReply', iptrw);
    RegisterProperty('ErrorReply', 'TIdRFCReply', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdFTPServer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdFTPUserType', '( utNone, utAnonymousUser, utNormalUser )');
  CL.AddTypeS('TIdFTPSystems', '( ftpsOther, ftpsDOS, ftpsUNIX, ftpsVAX )');
  CL.AddTypeS('TIdFTPOperation', '( ftpRetr, ftpStor )');
 //CL.AddConstantN('Id_DEF_AllowAnon','Boolean')BoolToStr( False);
 //CL.AddConstantN('Id_DEF_PassStrictCheck','Boolean')BoolToStr( False);
 //CL.AddConstantN('Id_DEF_SystemType','').SetString( ftpsDOS);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdFTPServerThread');
  CL.AddTypeS('TOnUserLoginEvent', 'Procedure ( ASender : TIdFTPServerThread; c'
   +'onst AUsername, APassword : string; var AAuthenticated : Boolean)');
  CL.AddTypeS('TOnAfterUserLoginEvent', 'Procedure ( ASender : TIdFTPServerThread)');
  CL.AddTypeS('TOnDirectoryEvent', 'Procedure ( ASender : TIdFTPServerThread; v'
   +'ar VDirectory : string)');
  CL.AddTypeS('TOnGetFileSizeEvent', 'Procedure ( ASender : TIdFTPServerThread;'
   +' const AFilename : string; var VFileSize : Int64)');
  CL.AddTypeS('TOnListDirectoryEvent', 'Procedure ( ASender : TIdFTPServerThrea'
   +'d; const APath : string; ADirectoryListing : TIdFTPListItems)');
  CL.AddTypeS('TOnFileEvent', 'Procedure ( ASender : TIdFTPServerThread; const '
   +'APathName : string)');
  CL.AddTypeS('TOnRenameFileEvent', 'Procedure ( ASender : TIdFTPServerThread; '
   +'const ARenameFromFile, ARenameToFile : string)');
  CL.AddTypeS('TOnRetrieveFileEvent', 'Procedure ( ASender : TIdFTPServerThread'
   +'; const AFileName : string; var VStream : TStream)');
  CL.AddTypeS('TOnStoreFileEvent', 'Procedure ( ASender : TIdFTPServerThread; c'
   +'onst AFileName : string; AAppend : Boolean; var VStream : TStream)');
  CL.AddTypeS('TOnPASVEvent', 'Procedure ( ASender : TIdFTPServerThread; var VI'
   +'P : String; var VPort : Word)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdFTPServerException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdFTPServerNoOnListDirectory');
  SIRegister_TIdDataChannelThread(CL);
  SIRegister_TIdFTPServerThread(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdFTPServer');
  CL.AddTypeS('TIdOnGetCustomListFormat', 'Procedure ( ASender : TIdFTPServer; '
   +'AItem : TIdFTPListItem; var VText : string)');
  SIRegister_TIdFTPServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnPASV_W(Self: TIdFTPServer; const T: TOnPASVEvent);
begin Self.OnPASV := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnPASV_R(Self: TIdFTPServer; var T: TOnPASVEvent);
begin T := Self.OnPASV; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnRemoveDirectory_W(Self: TIdFTPServer; const T: TOnDirectoryEvent);
begin Self.OnRemoveDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnRemoveDirectory_R(Self: TIdFTPServer; var T: TOnDirectoryEvent);
begin T := Self.OnRemoveDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnMakeDirectory_W(Self: TIdFTPServer; const T: TOnDirectoryEvent);
begin Self.OnMakeDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnMakeDirectory_R(Self: TIdFTPServer; var T: TOnDirectoryEvent);
begin T := Self.OnMakeDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnStoreFile_W(Self: TIdFTPServer; const T: TOnStoreFileEvent);
begin Self.OnStoreFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnStoreFile_R(Self: TIdFTPServer; var T: TOnStoreFileEvent);
begin T := Self.OnStoreFile; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnRetrieveFile_W(Self: TIdFTPServer; const T: TOnRetrieveFileEvent);
begin Self.OnRetrieveFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnRetrieveFile_R(Self: TIdFTPServer; var T: TOnRetrieveFileEvent);
begin T := Self.OnRetrieveFile; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnDeleteFile_W(Self: TIdFTPServer; const T: TOnFileEvent);
begin Self.OnDeleteFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnDeleteFile_R(Self: TIdFTPServer; var T: TOnFileEvent);
begin T := Self.OnDeleteFile; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnRenameFile_W(Self: TIdFTPServer; const T: TOnRenameFileEvent);
begin Self.OnRenameFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnRenameFile_R(Self: TIdFTPServer; var T: TOnRenameFileEvent);
begin T := Self.OnRenameFile; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnListDirectory_W(Self: TIdFTPServer; const T: TOnListDirectoryEvent);
begin Self.OnListDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnListDirectory_R(Self: TIdFTPServer; var T: TOnListDirectoryEvent);
begin T := Self.OnListDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnUserLogin_W(Self: TIdFTPServer; const T: TOnUserLoginEvent);
begin Self.OnUserLogin := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnUserLogin_R(Self: TIdFTPServer; var T: TOnUserLoginEvent);
begin T := Self.OnUserLogin; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnGetFileSize_W(Self: TIdFTPServer; const T: TOnGetFileSizeEvent);
begin Self.OnGetFileSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnGetFileSize_R(Self: TIdFTPServer; var T: TOnGetFileSizeEvent);
begin T := Self.OnGetFileSize; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnGetCustomListFormat_W(Self: TIdFTPServer; const T: TIdOnGetCustomListFormat);
begin Self.OnGetCustomListFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnGetCustomListFormat_R(Self: TIdFTPServer; var T: TIdOnGetCustomListFormat);
begin T := Self.OnGetCustomListFormat; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnChangeDirectory_W(Self: TIdFTPServer; const T: TOnDirectoryEvent);
begin Self.OnChangeDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnChangeDirectory_R(Self: TIdFTPServer; var T: TOnDirectoryEvent);
begin T := Self.OnChangeDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnAfterUserLogin_W(Self: TIdFTPServer; const T: TOnAfterUserLoginEvent);
begin Self.OnAfterUserLogin := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerOnAfterUserLogin_R(Self: TIdFTPServer; var T: TOnAfterUserLoginEvent);
begin T := Self.OnAfterUserLogin; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerSystemType_W(Self: TIdFTPServer; const T: string);
begin Self.SystemType := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerSystemType_R(Self: TIdFTPServer; var T: string);
begin T := Self.SystemType; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerUserAccounts_W(Self: TIdFTPServer; const T: TIdUserManager);
begin Self.UserAccounts := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerUserAccounts_R(Self: TIdFTPServer; var T: TIdUserManager);
begin T := Self.UserAccounts; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerHelpReply_W(Self: TIdFTPServer; const T: Tstrings);
begin Self.HelpReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerHelpReply_R(Self: TIdFTPServer; var T: Tstrings);
begin T := Self.HelpReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerEmulateSystem_W(Self: TIdFTPServer; const T: TIdFTPSystems);
begin Self.EmulateSystem := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerEmulateSystem_R(Self: TIdFTPServer; var T: TIdFTPSystems);
begin T := Self.EmulateSystem; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerDefaultDataPort_W(Self: TIdFTPServer; const T: Integer);
begin Self.DefaultDataPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerDefaultDataPort_R(Self: TIdFTPServer; var T: Integer);
begin T := Self.DefaultDataPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerAnonymousPassStrictCheck_W(Self: TIdFTPServer; const T: Boolean);
begin Self.AnonymousPassStrictCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerAnonymousPassStrictCheck_R(Self: TIdFTPServer; var T: Boolean);
begin T := Self.AnonymousPassStrictCheck; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerAnonymousAccounts_W(Self: TIdFTPServer; const T: TStringList);
begin Self.AnonymousAccounts := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerAnonymousAccounts_R(Self: TIdFTPServer; var T: TStringList);
begin T := Self.AnonymousAccounts; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerAllowAnonymousLogin_W(Self: TIdFTPServer; const T: Boolean);
begin Self.AllowAnonymousLogin := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerAllowAnonymousLogin_R(Self: TIdFTPServer; var T: Boolean);
begin T := Self.AllowAnonymousLogin; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadUserType_W(Self: TIdFTPServerThread; const T: TIdFTPUserType);
begin Self.UserType := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadUserType_R(Self: TIdFTPServerThread; var T: TIdFTPUserType);
begin T := Self.UserType; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadUsername_W(Self: TIdFTPServerThread; const T: string);
begin Self.Username := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadUsername_R(Self: TIdFTPServerThread; var T: string);
begin T := Self.Username; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadRESTPos_W(Self: TIdFTPServerThread; const T: Integer);
begin Self.RESTPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadRESTPos_R(Self: TIdFTPServerThread; var T: Integer);
begin T := Self.RESTPos; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadPASV_W(Self: TIdFTPServerThread; const T: Boolean);
begin Self.PASV := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadPASV_R(Self: TIdFTPServerThread; var T: Boolean);
begin T := Self.PASV; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadPassword_W(Self: TIdFTPServerThread; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadPassword_R(Self: TIdFTPServerThread; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadHomeDir_W(Self: TIdFTPServerThread; const T: string);
begin Self.HomeDir := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadHomeDir_R(Self: TIdFTPServerThread; var T: string);
begin T := Self.HomeDir; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadDataStruct_W(Self: TIdFTPServerThread; const T: TIdFTPDataStructure);
begin Self.DataStruct := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadDataStruct_R(Self: TIdFTPServerThread; var T: TIdFTPDataStructure);
begin T := Self.DataStruct; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadDataPort_R(Self: TIdFTPServerThread; var T: Integer);
begin T := Self.DataPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadDataMode_W(Self: TIdFTPServerThread; const T: TIdFTPTransferMode);
begin Self.DataMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadDataMode_R(Self: TIdFTPServerThread; var T: TIdFTPTransferMode);
begin T := Self.DataMode; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadDataType_W(Self: TIdFTPServerThread; const T: TIdFTPTransferType);
begin Self.DataType := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadDataType_R(Self: TIdFTPServerThread; var T: TIdFTPTransferType);
begin T := Self.DataType; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadDataChannelThread_W(Self: TIdFTPServerThread; const T: TIdDataChannelThread);
begin Self.DataChannelThread := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadDataChannelThread_R(Self: TIdFTPServerThread; var T: TIdDataChannelThread);
begin T := Self.DataChannelThread; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadCurrentDir_W(Self: TIdFTPServerThread; const T: string);
begin Self.CurrentDir := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadCurrentDir_R(Self: TIdFTPServerThread; var T: string);
begin T := Self.CurrentDir; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadALLOSize_W(Self: TIdFTPServerThread; const T: Integer);
begin Self.ALLOSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadALLOSize_R(Self: TIdFTPServerThread; var T: Integer);
begin T := Self.ALLOSize; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadAuthenticated_W(Self: TIdFTPServerThread; const T: Boolean);
begin Self.Authenticated := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPServerThreadAuthenticated_R(Self: TIdFTPServerThread; var T: Boolean);
begin T := Self.Authenticated; end;

(*----------------------------------------------------------------------------*)
procedure TIdDataChannelThreadErrorReply_W(Self: TIdDataChannelThread; const T: TIdRFCReply);
begin Self.ErrorReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDataChannelThreadErrorReply_R(Self: TIdDataChannelThread; var T: TIdRFCReply);
begin T := Self.ErrorReply; end;

(*----------------------------------------------------------------------------*)
procedure TIdDataChannelThreadOKReply_W(Self: TIdDataChannelThread; const T: TIdRFCReply);
begin Self.OKReply := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDataChannelThreadOKReply_R(Self: TIdDataChannelThread; var T: TIdRFCReply);
begin T := Self.OKReply; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdFTPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdFTPServer) do begin
    RegisterConstructor(@TIdFTPServer.Create, 'Create');
     RegisterMethod(@TIdFTPServer.Destroy, 'Free');
       RegisterPropertyHelper(@TIdFTPServerAllowAnonymousLogin_R,@TIdFTPServerAllowAnonymousLogin_W,'AllowAnonymousLogin');
    RegisterPropertyHelper(@TIdFTPServerAnonymousAccounts_R,@TIdFTPServerAnonymousAccounts_W,'AnonymousAccounts');
    RegisterPropertyHelper(@TIdFTPServerAnonymousPassStrictCheck_R,@TIdFTPServerAnonymousPassStrictCheck_W,'AnonymousPassStrictCheck');
    RegisterPropertyHelper(@TIdFTPServerDefaultDataPort_R,@TIdFTPServerDefaultDataPort_W,'DefaultDataPort');
    RegisterPropertyHelper(@TIdFTPServerEmulateSystem_R,@TIdFTPServerEmulateSystem_W,'EmulateSystem');
    RegisterPropertyHelper(@TIdFTPServerHelpReply_R,@TIdFTPServerHelpReply_W,'HelpReply');
    RegisterPropertyHelper(@TIdFTPServerUserAccounts_R,@TIdFTPServerUserAccounts_W,'UserAccounts');
    RegisterPropertyHelper(@TIdFTPServerSystemType_R,@TIdFTPServerSystemType_W,'SystemType');
    RegisterPropertyHelper(@TIdFTPServerOnAfterUserLogin_R,@TIdFTPServerOnAfterUserLogin_W,'OnAfterUserLogin');
    RegisterPropertyHelper(@TIdFTPServerOnChangeDirectory_R,@TIdFTPServerOnChangeDirectory_W,'OnChangeDirectory');
    RegisterPropertyHelper(@TIdFTPServerOnGetCustomListFormat_R,@TIdFTPServerOnGetCustomListFormat_W,'OnGetCustomListFormat');
    RegisterPropertyHelper(@TIdFTPServerOnGetFileSize_R,@TIdFTPServerOnGetFileSize_W,'OnGetFileSize');
    RegisterPropertyHelper(@TIdFTPServerOnUserLogin_R,@TIdFTPServerOnUserLogin_W,'OnUserLogin');
    RegisterPropertyHelper(@TIdFTPServerOnListDirectory_R,@TIdFTPServerOnListDirectory_W,'OnListDirectory');
    RegisterPropertyHelper(@TIdFTPServerOnRenameFile_R,@TIdFTPServerOnRenameFile_W,'OnRenameFile');
    RegisterPropertyHelper(@TIdFTPServerOnDeleteFile_R,@TIdFTPServerOnDeleteFile_W,'OnDeleteFile');
    RegisterPropertyHelper(@TIdFTPServerOnRetrieveFile_R,@TIdFTPServerOnRetrieveFile_W,'OnRetrieveFile');
    RegisterPropertyHelper(@TIdFTPServerOnStoreFile_R,@TIdFTPServerOnStoreFile_W,'OnStoreFile');
    RegisterPropertyHelper(@TIdFTPServerOnMakeDirectory_R,@TIdFTPServerOnMakeDirectory_W,'OnMakeDirectory');
    RegisterPropertyHelper(@TIdFTPServerOnRemoveDirectory_R,@TIdFTPServerOnRemoveDirectory_W,'OnRemoveDirectory');
    RegisterPropertyHelper(@TIdFTPServerOnPASV_R,@TIdFTPServerOnPASV_W,'OnPASV');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdFTPServerThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdFTPServerThread) do begin
    RegisterConstructor(@TIdFTPServerThread.Create, 'Create');
     RegisterMethod(@TIdFTPServerThread.Destroy, 'Free');
       RegisterPropertyHelper(@TIdFTPServerThreadAuthenticated_R,@TIdFTPServerThreadAuthenticated_W,'Authenticated');
    RegisterPropertyHelper(@TIdFTPServerThreadALLOSize_R,@TIdFTPServerThreadALLOSize_W,'ALLOSize');
    RegisterPropertyHelper(@TIdFTPServerThreadCurrentDir_R,@TIdFTPServerThreadCurrentDir_W,'CurrentDir');
    RegisterPropertyHelper(@TIdFTPServerThreadDataChannelThread_R,@TIdFTPServerThreadDataChannelThread_W,'DataChannelThread');
    RegisterPropertyHelper(@TIdFTPServerThreadDataType_R,@TIdFTPServerThreadDataType_W,'DataType');
    RegisterPropertyHelper(@TIdFTPServerThreadDataMode_R,@TIdFTPServerThreadDataMode_W,'DataMode');
    RegisterPropertyHelper(@TIdFTPServerThreadDataPort_R,nil,'DataPort');
    RegisterPropertyHelper(@TIdFTPServerThreadDataStruct_R,@TIdFTPServerThreadDataStruct_W,'DataStruct');
    RegisterPropertyHelper(@TIdFTPServerThreadHomeDir_R,@TIdFTPServerThreadHomeDir_W,'HomeDir');
    RegisterPropertyHelper(@TIdFTPServerThreadPassword_R,@TIdFTPServerThreadPassword_W,'Password');
    RegisterPropertyHelper(@TIdFTPServerThreadPASV_R,@TIdFTPServerThreadPASV_W,'PASV');
    RegisterPropertyHelper(@TIdFTPServerThreadRESTPos_R,@TIdFTPServerThreadRESTPos_W,'RESTPos');
    RegisterPropertyHelper(@TIdFTPServerThreadUsername_R,@TIdFTPServerThreadUsername_W,'Username');
    RegisterPropertyHelper(@TIdFTPServerThreadUserType_R,@TIdFTPServerThreadUserType_W,'UserType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdDataChannelThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdDataChannelThread) do begin
    RegisterConstructor(@TIdDataChannelThread.Create, 'Create');
     RegisterMethod(@TIdDataChannelThread.Destroy, 'Free');
       RegisterMethod(@TIdDataChannelThread.StartThread, 'StartThread');
    RegisterMethod(@TIdDataChannelThread.SetupDataChannel, 'SetupDataChannel');
    RegisterPropertyHelper(@TIdDataChannelThreadOKReply_R,@TIdDataChannelThreadOKReply_W,'OKReply');
    RegisterPropertyHelper(@TIdDataChannelThreadErrorReply_R,@TIdDataChannelThreadErrorReply_W,'ErrorReply');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdFTPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdFTPServerThread) do
  with CL.Add(EIdFTPServerException) do
  with CL.Add(EIdFTPServerNoOnListDirectory) do
  RIRegister_TIdDataChannelThread(CL);
  RIRegister_TIdFTPServerThread(CL);
  with CL.Add(TIdFTPServer) do
  RIRegister_TIdFTPServer(CL);
end;

 
 
{ TPSImport_IdFTPServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdFTPServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdFTPServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdFTPServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdFTPServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
