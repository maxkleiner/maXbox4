unit uPSI_ALWinInetFTPClient;
{
  ftp tp 
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
  TPSImport_ALWinInetFTPClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALWinInetFTPClient(CL: TPSPascalCompiler);
procedure SIRegister_ALWinInetFTPClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALWinInetFTPClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALWinInetFTPClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ALFTPClient
  ,WinInet
  ,ALWinInetFTPClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALWinInetFTPClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALWinInetFTPClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALFTPClient', 'TALWinInetFTPClient') do
  with CL.AddClassN(CL.FindClass('TALFTPClient'),'TALWinInetFTPClient') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure CreateDirectory( const Directory : AnsiString)');
    RegisterMethod('Procedure DeleteFile( const FileName : AnsiString)');
    RegisterMethod('Function FindFirst( const Path : AnsiString; const Attr : Integer; var F : TALFtpclientSearchRec) : Integer');
    RegisterMethod('Function FindNext( var F : TALFtpclientSearchRec) : Integer');
    RegisterMethod('Procedure FindClose( var F : TALFtpclientSearchRec)');
    RegisterMethod('Function GetCurrentDirectory : AnsiString');
    RegisterMethod('Procedure GetFile( const RemoteFile : AnsiString; const LocalFile : AnsiString; FailIfExists : Boolean);');
    RegisterMethod('Function GetFileSize( const filename : AnsiString) : Longword');
    RegisterMethod('Procedure RemoveDirectory( const Directory : AnsiString)');
    RegisterMethod('Procedure RenameFile( const ExistingFile : AnsiString; const NewFile : AnsiString)');
    RegisterMethod('Procedure SetCurrentDirectory( const Directory : AnsiString)');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');
    RegisterProperty('TransferType', 'TALWinInetFtpTransferType', iptrw);
    RegisterProperty('AccessType', 'TALWinInetFtpInternetOpenAccessType', iptrw);
    RegisterProperty('InternetOptions', 'TAlWininetFtpClientInternetOptionSet', iptrw);
    RegisterProperty('OnStatusChange', 'TAlWinInetFtpClientStatusChangeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALWinInetFTPClient(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('DWORD_PTR', 'DWORD');
  CL.AddTypeS('TALWinInetFTPInternetOpenAccessType', '( wFtpAt_Direct, wFtpAt_P'
   +'reconfig, wFtpAt_Preconfig_with_no_autoproxy, wFtpAt_Proxy )');
  CL.AddTypeS('TAlWinInetFTPClientInternetOption', '( wFtpIo_Async, wFtpIo_From'
   +'_Cache, wFtpIo_Offline, wFtpIo_Passive, wFtpIo_Hyperlink, wFtpIo_Need_file'
   +', wftpIo_No_cache_write, wftpIo_Reload, wftpIo_Resynchronize )');
  CL.AddTypeS('TALWinInetFtpTransferType', '( wFtpTt_ASCII, wFtpTt_BINARY )');
  CL.AddTypeS('TALWinInetFTPClientInternetOptionSet', 'set of TAlWinInetFTPClientInternetOption');
  //CL.AddTypeS('TAlWinInetFTPClientStatusChangeEvent', 'Procedure ( sender : Tob'
  // +'ject; InternetStatus : DWord; StatusInformation : Pointer; StatusInformationLength : DWord)');
  SIRegister_TALWinInetFTPClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALWinInetFTPClientOnStatusChange_W(Self: TALWinInetFTPClient; const T: TAlWinInetFtpClientStatusChangeEvent);
begin Self.OnStatusChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetFTPClientOnStatusChange_R(Self: TALWinInetFTPClient; var T: TAlWinInetFtpClientStatusChangeEvent);
begin T := Self.OnStatusChange; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetFTPClientInternetOptions_W(Self: TALWinInetFTPClient; const T: TAlWininetFtpClientInternetOptionSet);
begin Self.InternetOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetFTPClientInternetOptions_R(Self: TALWinInetFTPClient; var T: TAlWininetFtpClientInternetOptionSet);
begin T := Self.InternetOptions; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetFTPClientAccessType_W(Self: TALWinInetFTPClient; const T: TALWinInetFtpInternetOpenAccessType);
begin Self.AccessType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetFTPClientAccessType_R(Self: TALWinInetFTPClient; var T: TALWinInetFtpInternetOpenAccessType);
begin T := Self.AccessType; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetFTPClientTransferType_W(Self: TALWinInetFTPClient; const T: TALWinInetFtpTransferType);
begin Self.TransferType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetFTPClientTransferType_R(Self: TALWinInetFTPClient; var T: TALWinInetFtpTransferType);
begin T := Self.TransferType; end;

(*----------------------------------------------------------------------------*)
Procedure TALWinInetFTPClientPutFile1_P(Self: TALWinInetFTPClient;  DataStream : TStream; const Remotefile : AnsiString);
Begin Self.PutFile(DataStream, Remotefile); END;

(*----------------------------------------------------------------------------*)
Procedure TALWinInetFTPClientPutFile_P(Self: TALWinInetFTPClient;  const LocalFile : AnsiString; const Remotefile : AnsiString);
Begin Self.PutFile(LocalFile, Remotefile); END;

(*----------------------------------------------------------------------------*)
Procedure TALWinInetFTPClientGetFile1_P(Self: TALWinInetFTPClient;  const RemoteFile : AnsiString; DataStream : Tstream);
Begin Self.GetFile(RemoteFile, DataStream); END;

(*----------------------------------------------------------------------------*)
Procedure TALWinInetFTPClientGetFile_P(Self: TALWinInetFTPClient;  const RemoteFile : AnsiString; const LocalFile : AnsiString; FailIfExists : Boolean);
Begin Self.GetFile(RemoteFile, LocalFile, FailIfExists); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALWinInetFTPClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALWinInetFTPClient) do begin
    RegisterConstructor(@TALWinInetFTPClient.Create, 'Create');
    RegisterMethod(@TALWinInetFTPClient.CreateDirectory, 'CreateDirectory');
    RegisterMethod(@TALWinInetFTPClient.DeleteFile, 'DeleteFile');
    RegisterMethod(@TALWinInetFTPClient.FindFirst, 'FindFirst');
    RegisterMethod(@TALWinInetFTPClient.FindNext, 'FindNext');
    RegisterMethod(@TALWinInetFTPClient.FindClose, 'FindClose');
    RegisterMethod(@TALWinInetFTPClient.GetCurrentDirectory, 'GetCurrentDirectory');
    RegisterMethod(@TALWinInetFTPClientGetFile_P, 'GetFile');
    RegisterMethod(@TALWinInetFTPClient.GetFileSize, 'GetFileSize');
    RegisterMethod(@TALWinInetFTPClient.RemoveDirectory, 'RemoveDirectory');
    RegisterMethod(@TALWinInetFTPClient.RenameFile, 'RenameFile');
    RegisterMethod(@TALWinInetFTPClient.SetCurrentDirectory, 'SetCurrentDirectory');
    RegisterMethod(@TALWinInetFTPClient.Connect, 'Connect');
    RegisterMethod(@TALWinInetFTPClient.Disconnect, 'Disconnect');
    RegisterPropertyHelper(@TALWinInetFTPClientTransferType_R,@TALWinInetFTPClientTransferType_W,'TransferType');
    RegisterPropertyHelper(@TALWinInetFTPClientAccessType_R,@TALWinInetFTPClientAccessType_W,'AccessType');
    RegisterPropertyHelper(@TALWinInetFTPClientInternetOptions_R,@TALWinInetFTPClientInternetOptions_W,'InternetOptions');
    RegisterPropertyHelper(@TALWinInetFTPClientOnStatusChange_R,@TALWinInetFTPClientOnStatusChange_W,'OnStatusChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALWinInetFTPClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALWinInetFTPClient(CL);
end;

 
 
{ TPSImport_ALWinInetFTPClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALWinInetFTPClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALWinInetFTPClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALWinInetFTPClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALWinInetFTPClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
