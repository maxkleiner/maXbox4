unit uPSI_pop3send;
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
  TPSImport_pop3send = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPOP3Send(CL: TPSPascalCompiler);
procedure SIRegister_pop3send(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPOP3Send(CL: TPSRuntimeClassImporter);
procedure RIRegister_pop3send(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,synacode
  ,pop3send
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_pop3send]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPOP3Send(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TPOP3Send') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TPOP3Send') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function CustomCommand( const Command : string; MultiLine : Boolean) : boolean');
    RegisterMethod('Function Capability : Boolean');
    RegisterMethod('Function Login : Boolean');
    RegisterMethod('Function Logout : Boolean');
    RegisterMethod('Function Reset : Boolean');
    RegisterMethod('Function NoOp : Boolean');
    RegisterMethod('Function Stat : Boolean');
    RegisterMethod('Function List( Value : Integer) : Boolean');
    RegisterMethod('Function Retr( Value : Integer) : Boolean');
    RegisterMethod('Function RetrStream( Value : Integer; Stream : TStream) : Boolean');
    RegisterMethod('Function Dele( Value : Integer) : Boolean');
    RegisterMethod('Function Top( Value, Maxlines : Integer) : Boolean');
    RegisterMethod('Function Uidl( Value : Integer) : Boolean');
    RegisterMethod('Function StartTLS : Boolean');
    RegisterMethod('Function FindCap( const Value : string) : string');
    RegisterProperty('ResultCode', 'Integer', iptr);
    RegisterProperty('ResultString', 'string', iptr);
    RegisterProperty('FullResult', 'TStringList', iptr);
    RegisterProperty('StatCount', 'Integer', iptr);
    RegisterProperty('StatSize', 'Integer', iptr);
    RegisterProperty('ListSize', 'Integer', iptr);
    RegisterProperty('TimeStamp', 'string', iptr);
    RegisterProperty('AuthType', 'TPOP3AuthType', iptrw);
    RegisterProperty('AutoTLS', 'Boolean', iptrw);
    RegisterProperty('FullSSL', 'Boolean', iptrw);
    RegisterProperty('Sock', 'TTCPBlockSocket', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_pop3send(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cPop3Protocol','String').SetString( '110');
  CL.AddTypeS('TPOP3AuthType', '( POP3AuthAll, POP3AuthLogin, POP3AuthAPOP )');
  SIRegister_TPOP3Send(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPOP3SendSock_R(Self: TPOP3Send; var T: TTCPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendFullSSL_W(Self: TPOP3Send; const T: Boolean);
begin Self.FullSSL := T; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendFullSSL_R(Self: TPOP3Send; var T: Boolean);
begin T := Self.FullSSL; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendAutoTLS_W(Self: TPOP3Send; const T: Boolean);
begin Self.AutoTLS := T; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendAutoTLS_R(Self: TPOP3Send; var T: Boolean);
begin T := Self.AutoTLS; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendAuthType_W(Self: TPOP3Send; const T: TPOP3AuthType);
begin Self.AuthType := T; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendAuthType_R(Self: TPOP3Send; var T: TPOP3AuthType);
begin T := Self.AuthType; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendTimeStamp_R(Self: TPOP3Send; var T: string);
begin T := Self.TimeStamp; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendListSize_R(Self: TPOP3Send; var T: Integer);
begin T := Self.ListSize; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendStatSize_R(Self: TPOP3Send; var T: Integer);
begin T := Self.StatSize; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendStatCount_R(Self: TPOP3Send; var T: Integer);
begin T := Self.StatCount; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendFullResult_R(Self: TPOP3Send; var T: TStringList);
begin T := Self.FullResult; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendResultString_R(Self: TPOP3Send; var T: string);
begin T := Self.ResultString; end;

(*----------------------------------------------------------------------------*)
procedure TPOP3SendResultCode_R(Self: TPOP3Send; var T: Integer);
begin T := Self.ResultCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPOP3Send(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPOP3Send) do begin
    RegisterConstructor(@TPOP3Send.Create, 'Create');
       RegisterMethod(@TPOP3Send.Destroy, 'Free');
       RegisterMethod(@TPOP3Send.CustomCommand, 'CustomCommand');
    RegisterMethod(@TPOP3Send.Capability, 'Capability');
    RegisterMethod(@TPOP3Send.Login, 'Login');
    RegisterMethod(@TPOP3Send.Logout, 'Logout');
    RegisterMethod(@TPOP3Send.Reset, 'Reset');
    RegisterMethod(@TPOP3Send.NoOp, 'NoOp');
    RegisterMethod(@TPOP3Send.Stat, 'Stat');
    RegisterMethod(@TPOP3Send.List, 'List');
    RegisterMethod(@TPOP3Send.Retr, 'Retr');
    RegisterMethod(@TPOP3Send.RetrStream, 'RetrStream');
    RegisterMethod(@TPOP3Send.Dele, 'Dele');
    RegisterMethod(@TPOP3Send.Top, 'Top');
    RegisterMethod(@TPOP3Send.Uidl, 'Uidl');
    RegisterMethod(@TPOP3Send.StartTLS, 'StartTLS');
    RegisterMethod(@TPOP3Send.FindCap, 'FindCap');
    RegisterPropertyHelper(@TPOP3SendResultCode_R,nil,'ResultCode');
    RegisterPropertyHelper(@TPOP3SendResultString_R,nil,'ResultString');
    RegisterPropertyHelper(@TPOP3SendFullResult_R,nil,'FullResult');
    RegisterPropertyHelper(@TPOP3SendStatCount_R,nil,'StatCount');
    RegisterPropertyHelper(@TPOP3SendStatSize_R,nil,'StatSize');
    RegisterPropertyHelper(@TPOP3SendListSize_R,nil,'ListSize');
    RegisterPropertyHelper(@TPOP3SendTimeStamp_R,nil,'TimeStamp');
    RegisterPropertyHelper(@TPOP3SendAuthType_R,@TPOP3SendAuthType_W,'AuthType');
    RegisterPropertyHelper(@TPOP3SendAutoTLS_R,@TPOP3SendAutoTLS_W,'AutoTLS');
    RegisterPropertyHelper(@TPOP3SendFullSSL_R,@TPOP3SendFullSSL_W,'FullSSL');
    RegisterPropertyHelper(@TPOP3SendSock_R,nil,'Sock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_pop3send(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPOP3Send(CL);
end;

 
 
{ TPSImport_pop3send }
(*----------------------------------------------------------------------------*)
procedure TPSImport_pop3send.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_pop3send(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_pop3send.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_pop3send(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
