unit uPSI_sntpsend;
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
  TPSImport_sntpsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSNTPSend(CL: TPSPascalCompiler);
procedure SIRegister_sntpsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSNTPSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_sntpsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   synsock
  ,blcksock
  ,synautil
  ,sntpsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_sntpsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSNTPSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TSNTPSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TSNTPSend') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
      RegisterMethod('Function DecodeTs( Nsec, Nfrac : Longint) : TDateTime');
    RegisterMethod('Procedure EncodeTs( dt : TDateTime; var Nsec, Nfrac : Longint)');
    RegisterMethod('Function GetSNTP : Boolean');
    RegisterMethod('Function GetNTP : Boolean');
    RegisterMethod('Function GetBroadcastNTP : Boolean');
    RegisterProperty('NTPReply', 'TNtp', iptr);
    RegisterProperty('NTPTime', 'TDateTime', iptr);
    RegisterProperty('NTPOffset', 'Double', iptr);
    RegisterProperty('NTPDelay', 'Double', iptr);
    RegisterProperty('MaxSyncDiff', 'double', iptrw);
    RegisterProperty('SyncTime', 'Boolean', iptrw);
    RegisterProperty('Sock', 'TUDPBlockSocket', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_sntpsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cNtpProtocol','String').SetString( '123');
  CL.AddTypeS('TNtp', 'record mode : Byte; stratum : Byte; poll : Byte; Precisi'
   +'on : Byte; RootDelay : Longint; RootDisperson : Longint; RefID : Longint; '
   +'Ref1 : Longint; Ref2 : Longint; Org1 : Longint; Org2 : Longint; Rcv1 : Lon'
   +'gint; Rcv2 : Longint; Xmit1 : Longint; Xmit2 : Longint; end');
  SIRegister_TSNTPSend(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSNTPSendSock_R(Self: TSNTPSend; var T: TUDPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure TSNTPSendSyncTime_W(Self: TSNTPSend; const T: Boolean);
begin Self.SyncTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNTPSendSyncTime_R(Self: TSNTPSend; var T: Boolean);
begin T := Self.SyncTime; end;

(*----------------------------------------------------------------------------*)
procedure TSNTPSendMaxSyncDiff_W(Self: TSNTPSend; const T: double);
begin Self.MaxSyncDiff := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNTPSendMaxSyncDiff_R(Self: TSNTPSend; var T: double);
begin T := Self.MaxSyncDiff; end;

(*----------------------------------------------------------------------------*)
procedure TSNTPSendNTPDelay_R(Self: TSNTPSend; var T: Double);
begin T := Self.NTPDelay; end;

(*----------------------------------------------------------------------------*)
procedure TSNTPSendNTPOffset_R(Self: TSNTPSend; var T: Double);
begin T := Self.NTPOffset; end;

(*----------------------------------------------------------------------------*)
procedure TSNTPSendNTPTime_R(Self: TSNTPSend; var T: TDateTime);
begin T := Self.NTPTime; end;

(*----------------------------------------------------------------------------*)
procedure TSNTPSendNTPReply_R(Self: TSNTPSend; var T: TNtp);
begin T := Self.NTPReply; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSNTPSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSNTPSend) do begin
    RegisterConstructor(@TSNTPSend.Create, 'Create');
      RegisterMethod(@TSNTPSend.Destroy, 'Free');
      RegisterMethod(@TSNTPSend.DecodeTs, 'DecodeTs');
    RegisterMethod(@TSNTPSend.EncodeTs, 'EncodeTs');
    RegisterMethod(@TSNTPSend.GetSNTP, 'GetSNTP');
    RegisterMethod(@TSNTPSend.GetNTP, 'GetNTP');
    RegisterMethod(@TSNTPSend.GetBroadcastNTP, 'GetBroadcastNTP');
    RegisterPropertyHelper(@TSNTPSendNTPReply_R,nil,'NTPReply');
    RegisterPropertyHelper(@TSNTPSendNTPTime_R,nil,'NTPTime');
    RegisterPropertyHelper(@TSNTPSendNTPOffset_R,nil,'NTPOffset');
    RegisterPropertyHelper(@TSNTPSendNTPDelay_R,nil,'NTPDelay');
    RegisterPropertyHelper(@TSNTPSendMaxSyncDiff_R,@TSNTPSendMaxSyncDiff_W,'MaxSyncDiff');
    RegisterPropertyHelper(@TSNTPSendSyncTime_R,@TSNTPSendSyncTime_W,'SyncTime');
    RegisterPropertyHelper(@TSNTPSendSock_R,nil,'Sock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_sntpsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSNTPSend(CL);
end;

 
 
{ TPSImport_sntpsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_sntpsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_sntpsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_sntpsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_sntpsend(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
