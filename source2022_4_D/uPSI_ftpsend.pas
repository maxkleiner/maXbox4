unit uPSI_ftpsend;
{
   synapse ftp1
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
  TPSImport_ftpsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TFTPSend(CL: TPSPascalCompiler);
procedure SIRegister_TFTPList(CL: TPSPascalCompiler);
procedure SIRegister_TFTPListRec(CL: TPSPascalCompiler);
procedure SIRegister_ftpsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ftpsend_Routines(S: TPSExec);
procedure RIRegister_TFTPSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFTPList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFTPListRec(CL: TPSRuntimeClassImporter);
procedure RIRegister_ftpsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,synaip
  ,synsock
  ,ftpsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ftpsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFTPSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TFTPSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TFTPSend') do begin
    RegisterProperty('CustomLogon', 'TLogonActions', iptrw);
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
      RegisterMethod('Function ReadResult : Integer');
    RegisterMethod('Procedure ParseRemote( Value : string)');
    RegisterMethod('Procedure ParseRemoteEPSV( Value : string)');
    RegisterMethod('Function FTPCommand( const Value : string) : integer');
    RegisterMethod('Function Login : Boolean');
    RegisterMethod('Function Logout : Boolean');
    RegisterMethod('Procedure Abort');
    RegisterMethod('Procedure TelnetAbort');
    RegisterMethod('Function List( Directory : string; NameList : Boolean) : Boolean');
    RegisterMethod('Function RetrieveFile( const FileName : string; Restore : Boolean) : Boolean');
    RegisterMethod('Function StoreFile( const FileName : string; Restore : Boolean) : Boolean');
    RegisterMethod('Function StoreUniqueFile : Boolean');
    RegisterMethod('Function AppendFile( const FileName : string) : Boolean');
    RegisterMethod('Function RenameFile( const OldName, NewName : string) : Boolean');
    RegisterMethod('Function DeleteFile( const FileName : string) : Boolean');
    RegisterMethod('Function FileSize( const FileName : string) : int64');
    RegisterMethod('Function NoOp : Boolean');
    RegisterMethod('Function ChangeWorkingDir( const Directory : string) : Boolean');
    RegisterMethod('Function ChangeToParentDir : Boolean');
    RegisterMethod('Function ChangeToRootDir : Boolean');
    RegisterMethod('Function DeleteDir( const Directory : string) : Boolean');
    RegisterMethod('Function CreateDir( const Directory : string) : Boolean');
    RegisterMethod('Function GetCurrentDir : String');
    RegisterMethod('Function DataRead( const DestStream : TStream) : Boolean');
    RegisterMethod('Function DataWrite( const SourceStream : TStream) : Boolean');
    RegisterProperty('ResultCode', 'Integer', iptr);
    RegisterProperty('ResultString', 'string', iptr);
    RegisterProperty('FullResult', 'TStringList', iptr);
    RegisterProperty('Account', 'string', iptrw);
    RegisterProperty('FWHost', 'string', iptrw);
    RegisterProperty('FWPort', 'string', iptrw);
    RegisterProperty('FWUsername', 'string', iptrw);
    RegisterProperty('FWPassword', 'string', iptrw);
    RegisterProperty('FWMode', 'integer', iptrw);
    RegisterProperty('Sock', 'TTCPBlockSocket', iptr);
    RegisterProperty('DSock', 'TTCPBlockSocket', iptr);
    RegisterProperty('DataStream', 'TMemoryStream', iptr);
    RegisterProperty('DataIP', 'string', iptr);
    RegisterProperty('DataPort', 'string', iptr);
    RegisterProperty('DirectFile', 'Boolean', iptrw);
    RegisterProperty('DirectFileName', 'string', iptrw);
    RegisterProperty('CanResume', 'Boolean', iptr);
    RegisterProperty('PassiveMode', 'Boolean', iptrw);
    RegisterProperty('ForceDefaultPort', 'Boolean', iptrw);
    RegisterProperty('ForceOldPort', 'Boolean', iptrw);
    RegisterProperty('OnStatus', 'TFTPStatus', iptrw);
    RegisterProperty('FtpList', 'TFTPList', iptr);
    RegisterProperty('BinaryMode', 'Boolean', iptrw);
    RegisterProperty('AutoTLS', 'Boolean', iptrw);
    RegisterProperty('FullSSL', 'Boolean', iptrw);
    RegisterProperty('IsTLS', 'Boolean', iptr);
    RegisterProperty('IsDataTLS', 'Boolean', iptr);
    RegisterProperty('TLSonData', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFTPList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TFTPList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TFTPList') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Clear');
    RegisterMethod('Function Count : integer');
    RegisterMethod('Procedure Assign( Value : TFTPList)');
    RegisterMethod('Procedure ParseLines');
    RegisterProperty('List', 'TList', iptr);
    RegisterProperty('Items', 'TFTPListRec Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('Lines', 'TStringList', iptr);
    RegisterProperty('Masks', 'TStringList', iptr);
    RegisterProperty('UnparsedLines', 'TStringList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFTPListRec(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TFTPListRec') do
  with CL.AddClassN(CL.FindClass('TObject'),'TFTPListRec') do begin
    RegisterMethod('Procedure Assign( Value : TFTPListRec)');
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('Directory', 'Boolean', iptrw);
    RegisterProperty('Readable', 'Boolean', iptrw);
    RegisterProperty('FileSize', 'int64', iptrw);
    RegisterProperty('FileTime', 'TDateTime', iptrw);
    RegisterProperty('OriginalLine', 'string', iptrw);
    RegisterProperty('Mask', 'string', iptrw);
    RegisterProperty('Permission', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ftpsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cFtpProtocol','String').SetString( '21');
 CL.AddConstantN('cFtpDataProtocol','String').SetString( '20');
 CL.AddConstantN('FTP_OK','LongInt').SetInt( 255);
 CL.AddConstantN('FTP_ERR','LongInt').SetInt( 254);
  CL.AddTypeS('TFTPStatus', 'Procedure ( Sender : TObject; Response : Boolean; const Value : string)');
  SIRegister_TFTPListRec(CL);
  SIRegister_TFTPList(CL);
  SIRegister_TFTPSend(CL);
 CL.AddDelphiFunction('Function FtpGetFile( const IP, Port, FileName, LocalFile, User, Pass : string) : Boolean');
 CL.AddDelphiFunction('Function FtpPutFile( const IP, Port, FileName, LocalFile, User, Pass : string) : Boolean');
 CL.AddDelphiFunction('Function FtpInterServerTransfer( const FromIP, FromPort, FromFile, FromUser, FromPass : string; const ToIP, ToPort, ToFile, ToUser, ToPass : string) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TFTPSendTLSonData_W(Self: TFTPSend; const T: Boolean);
begin Self.TLSonData := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendTLSonData_R(Self: TFTPSend; var T: Boolean);
begin T := Self.TLSonData; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendIsDataTLS_R(Self: TFTPSend; var T: Boolean);
begin T := Self.IsDataTLS; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendIsTLS_R(Self: TFTPSend; var T: Boolean);
begin T := Self.IsTLS; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFullSSL_W(Self: TFTPSend; const T: Boolean);
begin Self.FullSSL := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFullSSL_R(Self: TFTPSend; var T: Boolean);
begin T := Self.FullSSL; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendAutoTLS_W(Self: TFTPSend; const T: Boolean);
begin Self.AutoTLS := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendAutoTLS_R(Self: TFTPSend; var T: Boolean);
begin T := Self.AutoTLS; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendBinaryMode_W(Self: TFTPSend; const T: Boolean);
begin Self.BinaryMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendBinaryMode_R(Self: TFTPSend; var T: Boolean);
begin T := Self.BinaryMode; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFtpList_R(Self: TFTPSend; var T: TFTPList);
begin T := Self.FtpList; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendOnStatus_W(Self: TFTPSend; const T: TFTPStatus);
begin Self.OnStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendOnStatus_R(Self: TFTPSend; var T: TFTPStatus);
begin T := Self.OnStatus; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendForceOldPort_W(Self: TFTPSend; const T: Boolean);
begin Self.ForceOldPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendForceOldPort_R(Self: TFTPSend; var T: Boolean);
begin T := Self.ForceOldPort; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendForceDefaultPort_W(Self: TFTPSend; const T: Boolean);
begin Self.ForceDefaultPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendForceDefaultPort_R(Self: TFTPSend; var T: Boolean);
begin T := Self.ForceDefaultPort; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendPassiveMode_W(Self: TFTPSend; const T: Boolean);
begin Self.PassiveMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendPassiveMode_R(Self: TFTPSend; var T: Boolean);
begin T := Self.PassiveMode; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendCanResume_R(Self: TFTPSend; var T: Boolean);
begin T := Self.CanResume; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendDirectFileName_W(Self: TFTPSend; const T: string);
begin Self.DirectFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendDirectFileName_R(Self: TFTPSend; var T: string);
begin T := Self.DirectFileName; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendDirectFile_W(Self: TFTPSend; const T: Boolean);
begin Self.DirectFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendDirectFile_R(Self: TFTPSend; var T: Boolean);
begin T := Self.DirectFile; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendDataPort_R(Self: TFTPSend; var T: string);
begin T := Self.DataPort; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendDataIP_R(Self: TFTPSend; var T: string);
begin T := Self.DataIP; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendDataStream_R(Self: TFTPSend; var T: TMemoryStream);
begin T := Self.DataStream; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendDSock_R(Self: TFTPSend; var T: TTCPBlockSocket);
begin T := Self.DSock; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendSock_R(Self: TFTPSend; var T: TTCPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFWMode_W(Self: TFTPSend; const T: integer);
begin Self.FWMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFWMode_R(Self: TFTPSend; var T: integer);
begin T := Self.FWMode; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFWPassword_W(Self: TFTPSend; const T: string);
begin Self.FWPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFWPassword_R(Self: TFTPSend; var T: string);
begin T := Self.FWPassword; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFWUsername_W(Self: TFTPSend; const T: string);
begin Self.FWUsername := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFWUsername_R(Self: TFTPSend; var T: string);
begin T := Self.FWUsername; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFWPort_W(Self: TFTPSend; const T: string);
begin Self.FWPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFWPort_R(Self: TFTPSend; var T: string);
begin T := Self.FWPort; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFWHost_W(Self: TFTPSend; const T: string);
begin Self.FWHost := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFWHost_R(Self: TFTPSend; var T: string);
begin T := Self.FWHost; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendAccount_W(Self: TFTPSend; const T: string);
begin Self.Account := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendAccount_R(Self: TFTPSend; var T: string);
begin T := Self.Account; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendFullResult_R(Self: TFTPSend; var T: TStringList);
begin T := Self.FullResult; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendResultString_R(Self: TFTPSend; var T: string);
begin T := Self.ResultString; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendResultCode_R(Self: TFTPSend; var T: Integer);
begin T := Self.ResultCode; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendCustomLogon_W(Self: TFTPSend; const T: TLogonActions);
Begin Self.CustomLogon := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPSendCustomLogon_R(Self: TFTPSend; var T: TLogonActions);
Begin T := Self.CustomLogon; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListUnparsedLines_R(Self: TFTPList; var T: TStringList);
begin T := Self.UnparsedLines; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListMasks_R(Self: TFTPList; var T: TStringList);
begin T := Self.Masks; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListLines_R(Self: TFTPList; var T: TStringList);
begin T := Self.Lines; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListItems_R(Self: TFTPList; var T: TFTPListRec; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListList_R(Self: TFTPList; var T: TList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecPermission_W(Self: TFTPListRec; const T: string);
begin Self.Permission := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecPermission_R(Self: TFTPListRec; var T: string);
begin T := Self.Permission; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecMask_W(Self: TFTPListRec; const T: string);
begin Self.Mask := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecMask_R(Self: TFTPListRec; var T: string);
begin T := Self.Mask; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecOriginalLine_W(Self: TFTPListRec; const T: string);
begin Self.OriginalLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecOriginalLine_R(Self: TFTPListRec; var T: string);
begin T := Self.OriginalLine; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecFileTime_W(Self: TFTPListRec; const T: TDateTime);
begin Self.FileTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecFileTime_R(Self: TFTPListRec; var T: TDateTime);
begin T := Self.FileTime; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecFileSize_W(Self: TFTPListRec; const T: int64);
begin Self.FileSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecFileSize_R(Self: TFTPListRec; var T: int64);
begin T := Self.FileSize; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecReadable_W(Self: TFTPListRec; const T: Boolean);
begin Self.Readable := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecReadable_R(Self: TFTPListRec; var T: Boolean);
begin T := Self.Readable; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecDirectory_W(Self: TFTPListRec; const T: Boolean);
begin Self.Directory := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecDirectory_R(Self: TFTPListRec; var T: Boolean);
begin T := Self.Directory; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecFileName_W(Self: TFTPListRec; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TFTPListRecFileName_R(Self: TFTPListRec; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ftpsend_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FtpGetFile, 'FtpGetFile', cdRegister);
 S.RegisterDelphiFunction(@FtpPutFile, 'FtpPutFile', cdRegister);
 S.RegisterDelphiFunction(@FtpInterServerTransfer, 'FtpInterServerTransfer', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFTPSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFTPSend) do begin
    RegisterPropertyHelper(@TFTPSendCustomLogon_R,@TFTPSendCustomLogon_W,'CustomLogon');
    RegisterConstructor(@TFTPSend.Create, 'Create');
    RegisterMethod(@TFTPSend.Destroy, 'Free');
    RegisterVirtualMethod(@TFTPSend.ReadResult, 'ReadResult');
    RegisterVirtualMethod(@TFTPSend.ParseRemote, 'ParseRemote');
    RegisterVirtualMethod(@TFTPSend.ParseRemoteEPSV, 'ParseRemoteEPSV');
    RegisterVirtualMethod(@TFTPSend.FTPCommand, 'FTPCommand');
    RegisterVirtualMethod(@TFTPSend.Login, 'Login');
    RegisterVirtualMethod(@TFTPSend.Logout, 'Logout');
    RegisterVirtualMethod(@TFTPSend.Abort, 'Abort');
    RegisterVirtualMethod(@TFTPSend.TelnetAbort, 'TelnetAbort');
    RegisterVirtualMethod(@TFTPSend.List, 'List');
    RegisterVirtualMethod(@TFTPSend.RetrieveFile, 'RetrieveFile');
    RegisterVirtualMethod(@TFTPSend.StoreFile, 'StoreFile');
    RegisterVirtualMethod(@TFTPSend.StoreUniqueFile, 'StoreUniqueFile');
    RegisterVirtualMethod(@TFTPSend.AppendFile, 'AppendFile');
    RegisterVirtualMethod(@TFTPSend.RenameFile, 'RenameFile');
    RegisterVirtualMethod(@TFTPSend.DeleteFile, 'DeleteFile');
    RegisterVirtualMethod(@TFTPSend.FileSize, 'FileSize');
    RegisterVirtualMethod(@TFTPSend.NoOp, 'NoOp');
    RegisterVirtualMethod(@TFTPSend.ChangeWorkingDir, 'ChangeWorkingDir');
    RegisterVirtualMethod(@TFTPSend.ChangeToParentDir, 'ChangeToParentDir');
    RegisterVirtualMethod(@TFTPSend.ChangeToRootDir, 'ChangeToRootDir');
    RegisterVirtualMethod(@TFTPSend.DeleteDir, 'DeleteDir');
    RegisterVirtualMethod(@TFTPSend.CreateDir, 'CreateDir');
    RegisterVirtualMethod(@TFTPSend.GetCurrentDir, 'GetCurrentDir');
    RegisterVirtualMethod(@TFTPSend.DataRead, 'DataRead');
    RegisterVirtualMethod(@TFTPSend.DataWrite, 'DataWrite');
    RegisterPropertyHelper(@TFTPSendResultCode_R,nil,'ResultCode');
    RegisterPropertyHelper(@TFTPSendResultString_R,nil,'ResultString');
    RegisterPropertyHelper(@TFTPSendFullResult_R,nil,'FullResult');
    RegisterPropertyHelper(@TFTPSendAccount_R,@TFTPSendAccount_W,'Account');
    RegisterPropertyHelper(@TFTPSendFWHost_R,@TFTPSendFWHost_W,'FWHost');
    RegisterPropertyHelper(@TFTPSendFWPort_R,@TFTPSendFWPort_W,'FWPort');
    RegisterPropertyHelper(@TFTPSendFWUsername_R,@TFTPSendFWUsername_W,'FWUsername');
    RegisterPropertyHelper(@TFTPSendFWPassword_R,@TFTPSendFWPassword_W,'FWPassword');
    RegisterPropertyHelper(@TFTPSendFWMode_R,@TFTPSendFWMode_W,'FWMode');
    RegisterPropertyHelper(@TFTPSendSock_R,nil,'Sock');
    RegisterPropertyHelper(@TFTPSendDSock_R,nil,'DSock');
    RegisterPropertyHelper(@TFTPSendDataStream_R,nil,'DataStream');
    RegisterPropertyHelper(@TFTPSendDataIP_R,nil,'DataIP');
    RegisterPropertyHelper(@TFTPSendDataPort_R,nil,'DataPort');
    RegisterPropertyHelper(@TFTPSendDirectFile_R,@TFTPSendDirectFile_W,'DirectFile');
    RegisterPropertyHelper(@TFTPSendDirectFileName_R,@TFTPSendDirectFileName_W,'DirectFileName');
    RegisterPropertyHelper(@TFTPSendCanResume_R,nil,'CanResume');
    RegisterPropertyHelper(@TFTPSendPassiveMode_R,@TFTPSendPassiveMode_W,'PassiveMode');
    RegisterPropertyHelper(@TFTPSendForceDefaultPort_R,@TFTPSendForceDefaultPort_W,'ForceDefaultPort');
    RegisterPropertyHelper(@TFTPSendForceOldPort_R,@TFTPSendForceOldPort_W,'ForceOldPort');
    RegisterPropertyHelper(@TFTPSendOnStatus_R,@TFTPSendOnStatus_W,'OnStatus');
    RegisterPropertyHelper(@TFTPSendFtpList_R,nil,'FtpList');
    RegisterPropertyHelper(@TFTPSendBinaryMode_R,@TFTPSendBinaryMode_W,'BinaryMode');
    RegisterPropertyHelper(@TFTPSendAutoTLS_R,@TFTPSendAutoTLS_W,'AutoTLS');
    RegisterPropertyHelper(@TFTPSendFullSSL_R,@TFTPSendFullSSL_W,'FullSSL');
    RegisterPropertyHelper(@TFTPSendIsTLS_R,nil,'IsTLS');
    RegisterPropertyHelper(@TFTPSendIsDataTLS_R,nil,'IsDataTLS');
    RegisterPropertyHelper(@TFTPSendTLSonData_R,@TFTPSendTLSonData_W,'TLSonData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFTPList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFTPList) do begin
    RegisterConstructor(@TFTPList.Create, 'Create');
     RegisterMethod(@TFTPList.Destroy, 'Free');
     RegisterVirtualMethod(@TFTPList.Clear, 'Clear');
    RegisterVirtualMethod(@TFTPList.Count, 'Count');
    RegisterVirtualMethod(@TFTPList.Assign, 'Assign');
    RegisterVirtualMethod(@TFTPList.ParseLines, 'ParseLines');
    RegisterPropertyHelper(@TFTPListList_R,nil,'List');
    RegisterPropertyHelper(@TFTPListItems_R,nil,'Items');
    RegisterPropertyHelper(@TFTPListLines_R,nil,'Lines');
    RegisterPropertyHelper(@TFTPListMasks_R,nil,'Masks');
    RegisterPropertyHelper(@TFTPListUnparsedLines_R,nil,'UnparsedLines');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFTPListRec(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFTPListRec) do begin
    RegisterVirtualMethod(@TFTPListRec.Assign, 'Assign');
    RegisterPropertyHelper(@TFTPListRecFileName_R,@TFTPListRecFileName_W,'FileName');
    RegisterPropertyHelper(@TFTPListRecDirectory_R,@TFTPListRecDirectory_W,'Directory');
    RegisterPropertyHelper(@TFTPListRecReadable_R,@TFTPListRecReadable_W,'Readable');
    RegisterPropertyHelper(@TFTPListRecFileSize_R,@TFTPListRecFileSize_W,'FileSize');
    RegisterPropertyHelper(@TFTPListRecFileTime_R,@TFTPListRecFileTime_W,'FileTime');
    RegisterPropertyHelper(@TFTPListRecOriginalLine_R,@TFTPListRecOriginalLine_W,'OriginalLine');
    RegisterPropertyHelper(@TFTPListRecMask_R,@TFTPListRecMask_W,'Mask');
    RegisterPropertyHelper(@TFTPListRecPermission_R,@TFTPListRecPermission_W,'Permission');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ftpsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFTPListRec(CL);
  RIRegister_TFTPList(CL);
  RIRegister_TFTPSend(CL);
end;

 
 
{ TPSImport_ftpsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ftpsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ftpsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ftpsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ftpsend(ri);
  RIRegister_ftpsend_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
