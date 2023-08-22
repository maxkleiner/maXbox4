unit uPSI_smtpsend;
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
  TPSImport_smtpsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSMTPSend(CL: TPSPascalCompiler);
procedure SIRegister_smtpsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_smtpsend_Routines(S: TPSExec);
procedure RIRegister_TSMTPSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_smtpsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,synacode
  ,smtpsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_smtpsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSMTPSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TSMTPSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TSMTPSend') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
      RegisterMethod('Function Login : Boolean');
    RegisterMethod('Function Logout : Boolean');
    RegisterMethod('Function Reset : Boolean');
    RegisterMethod('Function NoOp : Boolean');
    RegisterMethod('Function MailFrom( const Value : string; Size : Integer) : Boolean');
    RegisterMethod('Function MailTo( const Value : string) : Boolean');
    RegisterMethod('Function MailData( const Value : Tstrings) : Boolean');
    RegisterMethod('Function Etrn( const Value : string) : Boolean');
    RegisterMethod('Function Verify( const Value : string) : Boolean');
    RegisterMethod('Function StartTLS : Boolean');
    RegisterMethod('Function EnhCodeString : string');
    RegisterMethod('Function FindCap( const Value : string) : string');
    RegisterProperty('ResultCode', 'Integer', iptr);
    RegisterProperty('ResultString', 'string', iptr);
    RegisterProperty('FullResult', 'TStringList', iptr);
    RegisterProperty('ESMTPcap', 'TStringList', iptr);
    RegisterProperty('ESMTP', 'Boolean', iptr);
    RegisterProperty('AuthDone', 'Boolean', iptr);
    RegisterProperty('ESMTPSize', 'Boolean', iptr);
    RegisterProperty('MaxSize', 'Integer', iptr);
    RegisterProperty('EnhCode1', 'Integer', iptr);
    RegisterProperty('EnhCode2', 'Integer', iptr);
    RegisterProperty('EnhCode3', 'Integer', iptr);
    RegisterProperty('SystemName', 'string', iptrw);
    RegisterProperty('AutoTLS', 'Boolean', iptrw);
    RegisterProperty('FullSSL', 'Boolean', iptrw);
    RegisterProperty('Sock', 'TTCPBlockSocket', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_smtpsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cSmtpProtocol','String').SetString( '25');
  SIRegister_TSMTPSend(CL);
 CL.AddDelphiFunction('Function SendToRaw( const MailFrom, MailTo, SMTPHost : string; const MailData : TStrings; const Username, Password : string) : Boolean');
 CL.AddDelphiFunction('Function SendTo( const MailFrom, MailTo, Subject, SMTPHost : string; const MailData : TStrings) : Boolean');
 CL.AddDelphiFunction('Function SendToEx( const MailFrom, MailTo, Subject, SMTPHost : string; const MailData : TStrings; const Username, Password : string) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSMTPSendSock_R(Self: TSMTPSend; var T: TTCPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendFullSSL_W(Self: TSMTPSend; const T: Boolean);
begin Self.FullSSL := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendFullSSL_R(Self: TSMTPSend; var T: Boolean);
begin T := Self.FullSSL; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendAutoTLS_W(Self: TSMTPSend; const T: Boolean);
begin Self.AutoTLS := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendAutoTLS_R(Self: TSMTPSend; var T: Boolean);
begin T := Self.AutoTLS; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendSystemName_W(Self: TSMTPSend; const T: string);
begin Self.SystemName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendSystemName_R(Self: TSMTPSend; var T: string);
begin T := Self.SystemName; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendEnhCode3_R(Self: TSMTPSend; var T: Integer);
begin T := Self.EnhCode3; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendEnhCode2_R(Self: TSMTPSend; var T: Integer);
begin T := Self.EnhCode2; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendEnhCode1_R(Self: TSMTPSend; var T: Integer);
begin T := Self.EnhCode1; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendMaxSize_R(Self: TSMTPSend; var T: Integer);
begin T := Self.MaxSize; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendESMTPSize_R(Self: TSMTPSend; var T: Boolean);
begin T := Self.ESMTPSize; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendAuthDone_R(Self: TSMTPSend; var T: Boolean);
begin T := Self.AuthDone; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendESMTP_R(Self: TSMTPSend; var T: Boolean);
begin T := Self.ESMTP; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendESMTPcap_R(Self: TSMTPSend; var T: TStringList);
begin T := Self.ESMTPcap; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendFullResult_R(Self: TSMTPSend; var T: TStringList);
begin T := Self.FullResult; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendResultString_R(Self: TSMTPSend; var T: string);
begin T := Self.ResultString; end;

(*----------------------------------------------------------------------------*)
procedure TSMTPSendResultCode_R(Self: TSMTPSend; var T: Integer);
begin T := Self.ResultCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_smtpsend_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SendToRaw, 'SendToRaw', cdRegister);
 S.RegisterDelphiFunction(@SendTo, 'SendTo', cdRegister);
 S.RegisterDelphiFunction(@SendToEx, 'SendToEx', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSMTPSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSMTPSend) do begin
    RegisterConstructor(@TSMTPSend.Create, 'Create');
      RegisterMethod(@TSMTPSend.Destroy, 'Free');
    RegisterMethod(@TSMTPSend.Login, 'Login');
    RegisterMethod(@TSMTPSend.Logout, 'Logout');
    RegisterMethod(@TSMTPSend.Reset, 'Reset');
    RegisterMethod(@TSMTPSend.NoOp, 'NoOp');
    RegisterMethod(@TSMTPSend.MailFrom, 'MailFrom');
    RegisterMethod(@TSMTPSend.MailTo, 'MailTo');
    RegisterMethod(@TSMTPSend.MailData, 'MailData');
    RegisterMethod(@TSMTPSend.Etrn, 'Etrn');
    RegisterMethod(@TSMTPSend.Verify, 'Verify');
    RegisterMethod(@TSMTPSend.StartTLS, 'StartTLS');
    RegisterMethod(@TSMTPSend.EnhCodeString, 'EnhCodeString');
    RegisterMethod(@TSMTPSend.FindCap, 'FindCap');
    RegisterPropertyHelper(@TSMTPSendResultCode_R,nil,'ResultCode');
    RegisterPropertyHelper(@TSMTPSendResultString_R,nil,'ResultString');
    RegisterPropertyHelper(@TSMTPSendFullResult_R,nil,'FullResult');
    RegisterPropertyHelper(@TSMTPSendESMTPcap_R,nil,'ESMTPcap');
    RegisterPropertyHelper(@TSMTPSendESMTP_R,nil,'ESMTP');
    RegisterPropertyHelper(@TSMTPSendAuthDone_R,nil,'AuthDone');
    RegisterPropertyHelper(@TSMTPSendESMTPSize_R,nil,'ESMTPSize');
    RegisterPropertyHelper(@TSMTPSendMaxSize_R,nil,'MaxSize');
    RegisterPropertyHelper(@TSMTPSendEnhCode1_R,nil,'EnhCode1');
    RegisterPropertyHelper(@TSMTPSendEnhCode2_R,nil,'EnhCode2');
    RegisterPropertyHelper(@TSMTPSendEnhCode3_R,nil,'EnhCode3');
    RegisterPropertyHelper(@TSMTPSendSystemName_R,@TSMTPSendSystemName_W,'SystemName');
    RegisterPropertyHelper(@TSMTPSendAutoTLS_R,@TSMTPSendAutoTLS_W,'AutoTLS');
    RegisterPropertyHelper(@TSMTPSendFullSSL_R,@TSMTPSendFullSSL_W,'FullSSL');
    RegisterPropertyHelper(@TSMTPSendSock_R,nil,'Sock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_smtpsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSMTPSend(CL);
end;

 
 
{ TPSImport_smtpsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_smtpsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_smtpsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_smtpsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_smtpsend(ri);
  RIRegister_smtpsend_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
