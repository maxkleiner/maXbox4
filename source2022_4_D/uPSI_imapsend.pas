unit uPSI_imapsend;
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
  TPSImport_imapsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIMAPSend(CL: TPSPascalCompiler);
procedure SIRegister_imapsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIMAPSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_imapsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,imapsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_imapsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIMAPSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TIMAPSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TIMAPSend') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
      RegisterMethod('Function IMAPcommand( Value : string) : string');
    RegisterMethod('Function IMAPuploadCommand( Value : string; const Data : TStrings) : string');
    RegisterMethod('Function Capability : Boolean');
    RegisterMethod('Function Login : Boolean');
    RegisterMethod('Function Logout : Boolean');
    RegisterMethod('Function NoOp : Boolean');
    RegisterMethod('Function List( FromFolder : string; const FolderList : TStrings) : Boolean');
    RegisterMethod('Function ListSearch( FromFolder, Search : string; const FolderList : TStrings) : Boolean');
    RegisterMethod('Function ListSubscribed( FromFolder : string; const FolderList : TStrings) : Boolean');
    RegisterMethod('Function ListSearchSubscribed( FromFolder, Search : string; const FolderList : TStrings) : Boolean');
    RegisterMethod('Function CreateFolder( FolderName : string) : Boolean');
    RegisterMethod('Function DeleteFolder( FolderName : string) : Boolean');
    RegisterMethod('Function RenameFolder( FolderName, NewFolderName : string) : Boolean');
    RegisterMethod('Function SubscribeFolder( FolderName : string) : Boolean');
    RegisterMethod('Function UnsubscribeFolder( FolderName : string) : Boolean');
    RegisterMethod('Function SelectFolder( FolderName : string) : Boolean');
    RegisterMethod('Function SelectROFolder( FolderName : string) : Boolean');
    RegisterMethod('Function CloseFolder : Boolean');
    RegisterMethod('Function StatusFolder( FolderName, Value : string) : integer');
    RegisterMethod('Function ExpungeFolder : Boolean');
    RegisterMethod('Function CheckFolder : Boolean');
    RegisterMethod('Function AppendMess( ToFolder : string; const Mess : TStrings) : Boolean');
    RegisterMethod('Function DeleteMess( MessID : integer) : boolean');
    RegisterMethod('Function FetchMess( MessID : integer; const Mess : TStrings) : Boolean');
    RegisterMethod('Function FetchHeader( MessID : integer; const Headers : TStrings) : Boolean');
    RegisterMethod('Function MessageSize( MessID : integer) : integer');
    RegisterMethod('Function CopyMess( MessID : integer; ToFolder : string) : Boolean');
    RegisterMethod('Function SearchMess( Criteria : string; const FoundMess : TStrings) : Boolean');
    RegisterMethod('Function SetFlagsMess( MessID : integer; Flags : string) : Boolean');
    RegisterMethod('Function GetFlagsMess( MessID : integer; var Flags : string) : Boolean');
    RegisterMethod('Function AddFlagsMess( MessID : integer; Flags : string) : Boolean');
    RegisterMethod('Function DelFlagsMess( MessID : integer; Flags : string) : Boolean');
    RegisterMethod('Function StartTLS : Boolean');
    RegisterMethod('Function GetUID( MessID : integer; var UID : Integer) : Boolean');
    RegisterMethod('Function FindCap( const Value : string) : string');
    RegisterProperty('ResultString', 'string', iptr);
    RegisterProperty('FullResult', 'TStringList', iptr);
    RegisterProperty('IMAPcap', 'TStringList', iptr);
    RegisterProperty('AuthDone', 'Boolean', iptr);
    RegisterProperty('UID', 'Boolean', iptrw);
    RegisterProperty('SelectedFolder', 'string', iptr);
    RegisterProperty('SelectedCount', 'integer', iptr);
    RegisterProperty('SelectedRecent', 'integer', iptr);
    RegisterProperty('SelectedUIDvalidity', 'integer', iptr);
    RegisterProperty('AutoTLS', 'Boolean', iptrw);
    RegisterProperty('FullSSL', 'Boolean', iptrw);
    RegisterProperty('Sock', 'TTCPBlockSocket', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_imapsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cIMAPProtocol','String').SetString( '143');
  SIRegister_TIMAPSend(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIMAPSendSock_R(Self: TIMAPSend; var T: TTCPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendFullSSL_W(Self: TIMAPSend; const T: Boolean);
begin Self.FullSSL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendFullSSL_R(Self: TIMAPSend; var T: Boolean);
begin T := Self.FullSSL; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendAutoTLS_W(Self: TIMAPSend; const T: Boolean);
begin Self.AutoTLS := T; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendAutoTLS_R(Self: TIMAPSend; var T: Boolean);
begin T := Self.AutoTLS; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendSelectedUIDvalidity_R(Self: TIMAPSend; var T: integer);
begin T := Self.SelectedUIDvalidity; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendSelectedRecent_R(Self: TIMAPSend; var T: integer);
begin T := Self.SelectedRecent; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendSelectedCount_R(Self: TIMAPSend; var T: integer);
begin T := Self.SelectedCount; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendSelectedFolder_R(Self: TIMAPSend; var T: string);
begin T := Self.SelectedFolder; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendUID_W(Self: TIMAPSend; const T: Boolean);
begin Self.UID := T; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendUID_R(Self: TIMAPSend; var T: Boolean);
begin T := Self.UID; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendAuthDone_R(Self: TIMAPSend; var T: Boolean);
begin T := Self.AuthDone; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendIMAPcap_R(Self: TIMAPSend; var T: TStringList);
begin T := Self.IMAPcap; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendFullResult_R(Self: TIMAPSend; var T: TStringList);
begin T := Self.FullResult; end;

(*----------------------------------------------------------------------------*)
procedure TIMAPSendResultString_R(Self: TIMAPSend; var T: string);
begin T := Self.ResultString; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIMAPSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIMAPSend) do begin
    RegisterConstructor(@TIMAPSend.Create, 'Create');
       RegisterMethod(@TIMAPSend.Destroy, 'Free');
       RegisterMethod(@TIMAPSend.IMAPcommand, 'IMAPcommand');
    RegisterMethod(@TIMAPSend.IMAPuploadCommand, 'IMAPuploadCommand');
    RegisterMethod(@TIMAPSend.Capability, 'Capability');
    RegisterMethod(@TIMAPSend.Login, 'Login');
    RegisterMethod(@TIMAPSend.Logout, 'Logout');
    RegisterMethod(@TIMAPSend.NoOp, 'NoOp');
    RegisterMethod(@TIMAPSend.List, 'List');
    RegisterMethod(@TIMAPSend.ListSearch, 'ListSearch');
    RegisterMethod(@TIMAPSend.ListSubscribed, 'ListSubscribed');
    RegisterMethod(@TIMAPSend.ListSearchSubscribed, 'ListSearchSubscribed');
    RegisterMethod(@TIMAPSend.CreateFolder, 'CreateFolder');
    RegisterMethod(@TIMAPSend.DeleteFolder, 'DeleteFolder');
    RegisterMethod(@TIMAPSend.RenameFolder, 'RenameFolder');
    RegisterMethod(@TIMAPSend.SubscribeFolder, 'SubscribeFolder');
    RegisterMethod(@TIMAPSend.UnsubscribeFolder, 'UnsubscribeFolder');
    RegisterMethod(@TIMAPSend.SelectFolder, 'SelectFolder');
    RegisterMethod(@TIMAPSend.SelectROFolder, 'SelectROFolder');
    RegisterMethod(@TIMAPSend.CloseFolder, 'CloseFolder');
    RegisterMethod(@TIMAPSend.StatusFolder, 'StatusFolder');
    RegisterMethod(@TIMAPSend.ExpungeFolder, 'ExpungeFolder');
    RegisterMethod(@TIMAPSend.CheckFolder, 'CheckFolder');
    RegisterMethod(@TIMAPSend.AppendMess, 'AppendMess');
    RegisterMethod(@TIMAPSend.DeleteMess, 'DeleteMess');
    RegisterMethod(@TIMAPSend.FetchMess, 'FetchMess');
    RegisterMethod(@TIMAPSend.FetchHeader, 'FetchHeader');
    RegisterMethod(@TIMAPSend.MessageSize, 'MessageSize');
    RegisterMethod(@TIMAPSend.CopyMess, 'CopyMess');
    RegisterMethod(@TIMAPSend.SearchMess, 'SearchMess');
    RegisterMethod(@TIMAPSend.SetFlagsMess, 'SetFlagsMess');
    RegisterMethod(@TIMAPSend.GetFlagsMess, 'GetFlagsMess');
    RegisterMethod(@TIMAPSend.AddFlagsMess, 'AddFlagsMess');
    RegisterMethod(@TIMAPSend.DelFlagsMess, 'DelFlagsMess');
    RegisterMethod(@TIMAPSend.StartTLS, 'StartTLS');
    RegisterMethod(@TIMAPSend.GetUID, 'GetUID');
    RegisterMethod(@TIMAPSend.FindCap, 'FindCap');
    RegisterPropertyHelper(@TIMAPSendResultString_R,nil,'ResultString');
    RegisterPropertyHelper(@TIMAPSendFullResult_R,nil,'FullResult');
    RegisterPropertyHelper(@TIMAPSendIMAPcap_R,nil,'IMAPcap');
    RegisterPropertyHelper(@TIMAPSendAuthDone_R,nil,'AuthDone');
    RegisterPropertyHelper(@TIMAPSendUID_R,@TIMAPSendUID_W,'UID');
    RegisterPropertyHelper(@TIMAPSendSelectedFolder_R,nil,'SelectedFolder');
    RegisterPropertyHelper(@TIMAPSendSelectedCount_R,nil,'SelectedCount');
    RegisterPropertyHelper(@TIMAPSendSelectedRecent_R,nil,'SelectedRecent');
    RegisterPropertyHelper(@TIMAPSendSelectedUIDvalidity_R,nil,'SelectedUIDvalidity');
    RegisterPropertyHelper(@TIMAPSendAutoTLS_R,@TIMAPSendAutoTLS_W,'AutoTLS');
    RegisterPropertyHelper(@TIMAPSendFullSSL_R,@TIMAPSendFullSSL_W,'FullSSL');
    RegisterPropertyHelper(@TIMAPSendSock_R,nil,'Sock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_imapsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIMAPSend(CL);
end;

 
 
{ TPSImport_imapsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_imapsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_imapsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_imapsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_imapsend(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
