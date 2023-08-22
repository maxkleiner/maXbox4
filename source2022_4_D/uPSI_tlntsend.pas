unit uPSI_tlntsend;
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
  TPSImport_tlntsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TTelnetSend(CL: TPSPascalCompiler);
procedure SIRegister_tlntsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTelnetSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_tlntsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,tlntsend
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_tlntsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTelnetSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TTelnetSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TTelnetSend') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function Login : Boolean');
    RegisterMethod('Function SSHLogin : Boolean');
    RegisterMethod('Procedure Logout');
    RegisterMethod('Procedure Send( const Value : string)');
    RegisterMethod('Function WaitFor( const Value : string) : Boolean');
    RegisterMethod('Function RecvTerminated( const Terminator : string) : string');
    RegisterMethod('Function RecvString : string');
    RegisterProperty('Sock', 'TTCPBlockSocket', iptr);
    RegisterProperty('SessionLog', 'Ansistring', iptrw);
    RegisterProperty('TermType', 'Ansistring', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_tlntsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cTelnetProtocol','String').SetString( '23');
 CL.AddConstantN('cSSHProtocol','String').SetString( '22');
 CL.AddConstantN('TLNT_EOR','Char').SetString( #239);
 CL.AddConstantN('TLNT_SE','Char').SetString( #240);
 CL.AddConstantN('TLNT_NOP','Char').SetString( #241);
 CL.AddConstantN('TLNT_DATA_MARK','Char').SetString( #242);
 CL.AddConstantN('TLNT_BREAK','Char').SetString( #243);
 CL.AddConstantN('TLNT_IP','Char').SetString( #244);
 CL.AddConstantN('TLNT_AO','Char').SetString( #245);
 CL.AddConstantN('TLNT_AYT','Char').SetString( #246);
 CL.AddConstantN('TLNT_EC','Char').SetString( #247);
 CL.AddConstantN('TLNT_EL','Char').SetString( #248);
 CL.AddConstantN('TLNT_GA','Char').SetString( #249);
 CL.AddConstantN('TLNT_SB','Char').SetString( #250);
 CL.AddConstantN('TLNT_WILL','Char').SetString( #251);
 CL.AddConstantN('TLNT_WONT','Char').SetString( #252);
 CL.AddConstantN('TLNT_DO','Char').SetString( #253);
 CL.AddConstantN('TLNT_DONT','Char').SetString( #254);
 CL.AddConstantN('TLNT_IAC','Char').SetString( #255);
  CL.AddTypeS('TTelnetState', '( tsDATA, tsIAC, tsIAC_SB, tsIAC_WILL, tsIAC_DO,'
   +' tsIAC_WONT, tsIAC_DONT, tsIAC_SBIAC, tsIAC_SBDATA, tsSBDATA_IAC )');
  SIRegister_TTelnetSend(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTelnetSendTermType_W(Self: TTelnetSend; const T: Ansistring);
begin Self.TermType := T; end;

(*----------------------------------------------------------------------------*)
procedure TTelnetSendTermType_R(Self: TTelnetSend; var T: Ansistring);
begin T := Self.TermType; end;

(*----------------------------------------------------------------------------*)
procedure TTelnetSendSessionLog_W(Self: TTelnetSend; const T: Ansistring);
begin Self.SessionLog := T; end;

(*----------------------------------------------------------------------------*)
procedure TTelnetSendSessionLog_R(Self: TTelnetSend; var T: Ansistring);
begin T := Self.SessionLog; end;

(*----------------------------------------------------------------------------*)
procedure TTelnetSendSock_R(Self: TTelnetSend; var T: TTCPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTelnetSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTelnetSend) do begin
    RegisterConstructor(@TTelnetSend.Create, 'Create');
      RegisterMethod(@TTelnetSend.Destroy, 'Free');
      RegisterMethod(@TTelnetSend.Login, 'Login');
    RegisterMethod(@TTelnetSend.SSHLogin, 'SSHLogin');
    RegisterMethod(@TTelnetSend.Logout, 'Logout');
    RegisterMethod(@TTelnetSend.Send, 'Send');
    RegisterMethod(@TTelnetSend.WaitFor, 'WaitFor');
    RegisterMethod(@TTelnetSend.RecvTerminated, 'RecvTerminated');
    RegisterMethod(@TTelnetSend.RecvString, 'RecvString');
    RegisterPropertyHelper(@TTelnetSendSock_R,nil,'Sock');
    RegisterPropertyHelper(@TTelnetSendSessionLog_R,@TTelnetSendSessionLog_W,'SessionLog');
    RegisterPropertyHelper(@TTelnetSendTermType_R,@TTelnetSendTermType_W,'TermType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_tlntsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTelnetSend(CL);
end;

 
 
{ TPSImport_tlntsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_tlntsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_tlntsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_tlntsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_tlntsend(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
