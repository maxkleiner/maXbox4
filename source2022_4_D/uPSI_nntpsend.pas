unit uPSI_nntpsend;
{
   synapse v40
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
  TPSImport_nntpsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNNTPSend(CL: TPSPascalCompiler);
procedure SIRegister_nntpsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TNNTPSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_nntpsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,nntpsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_nntpsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNTPSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TNNTPSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TNNTPSend') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
      RegisterMethod('Function Login : Boolean');
    RegisterMethod('Function Logout : Boolean');
    RegisterMethod('Function DoCommand( const Command : string) : boolean');
    RegisterMethod('Function DoCommandRead( const Command : string) : boolean');
    RegisterMethod('Function DoCommandWrite( const Command : string) : boolean');
    RegisterMethod('Function GetArticle( const Value : string) : Boolean');
    RegisterMethod('Function GetBody( const Value : string) : Boolean');
    RegisterMethod('Function GetHead( const Value : string) : Boolean');
    RegisterMethod('Function GetStat( const Value : string) : Boolean');
    RegisterMethod('Function SelectGroup( const Value : string) : Boolean');
    RegisterMethod('Function IHave( const MessID : string) : Boolean');
    RegisterMethod('Function GotoLast : Boolean');
    RegisterMethod('Function GotoNext : Boolean');
    RegisterMethod('Function ListGroups : Boolean');
    RegisterMethod('Function ListNewGroups( Since : TDateTime) : Boolean');
    RegisterMethod('Function NewArticles( const Group : string; Since : TDateTime) : Boolean');
    RegisterMethod('Function PostArticle : Boolean');
    RegisterMethod('Function SwitchToSlave : Boolean');
    RegisterMethod('Function Xover( xoStart, xoEnd : string) : boolean');
    RegisterMethod('Function StartTLS : Boolean');
    RegisterMethod('Function FindCap( const Value : string) : string');
    RegisterMethod('Function ListExtensions : Boolean');
    RegisterProperty('ResultCode', 'Integer', iptr);
    RegisterProperty('ResultString', 'string', iptr);
    RegisterProperty('Data', 'TStringList', iptr);
    RegisterProperty('AutoTLS', 'Boolean', iptrw);
    RegisterProperty('FullSSL', 'Boolean', iptrw);
    RegisterProperty('Sock', 'TTCPBlockSocket', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_nntpsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cNNTPProtocol','String').SetString( '119');
  SIRegister_TNNTPSend(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TNNTPSendSock_R(Self: TNNTPSend; var T: TTCPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure TNNTPSendFullSSL_W(Self: TNNTPSend; const T: Boolean);
begin Self.FullSSL := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNTPSendFullSSL_R(Self: TNNTPSend; var T: Boolean);
begin T := Self.FullSSL; end;

(*----------------------------------------------------------------------------*)
procedure TNNTPSendAutoTLS_W(Self: TNNTPSend; const T: Boolean);
begin Self.AutoTLS := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNTPSendAutoTLS_R(Self: TNNTPSend; var T: Boolean);
begin T := Self.AutoTLS; end;

(*----------------------------------------------------------------------------*)
procedure TNNTPSendData_R(Self: TNNTPSend; var T: TStringList);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TNNTPSendResultString_R(Self: TNNTPSend; var T: string);
begin T := Self.ResultString; end;

(*----------------------------------------------------------------------------*)
procedure TNNTPSendResultCode_R(Self: TNNTPSend; var T: Integer);
begin T := Self.ResultCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNTPSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNTPSend) do begin
    RegisterConstructor(@TNNTPSend.Create, 'Create');
          RegisterMethod(@TNNTPSend.Destroy, 'Free');
   RegisterMethod(@TNNTPSend.Login, 'Login');
    RegisterMethod(@TNNTPSend.Logout, 'Logout');
    RegisterMethod(@TNNTPSend.DoCommand, 'DoCommand');
    RegisterMethod(@TNNTPSend.DoCommandRead, 'DoCommandRead');
    RegisterMethod(@TNNTPSend.DoCommandWrite, 'DoCommandWrite');
    RegisterMethod(@TNNTPSend.GetArticle, 'GetArticle');
    RegisterMethod(@TNNTPSend.GetBody, 'GetBody');
    RegisterMethod(@TNNTPSend.GetHead, 'GetHead');
    RegisterMethod(@TNNTPSend.GetStat, 'GetStat');
    RegisterMethod(@TNNTPSend.SelectGroup, 'SelectGroup');
    RegisterMethod(@TNNTPSend.IHave, 'IHave');
    RegisterMethod(@TNNTPSend.GotoLast, 'GotoLast');
    RegisterMethod(@TNNTPSend.GotoNext, 'GotoNext');
    RegisterMethod(@TNNTPSend.ListGroups, 'ListGroups');
    RegisterMethod(@TNNTPSend.ListNewGroups, 'ListNewGroups');
    RegisterMethod(@TNNTPSend.NewArticles, 'NewArticles');
    RegisterMethod(@TNNTPSend.PostArticle, 'PostArticle');
    RegisterMethod(@TNNTPSend.SwitchToSlave, 'SwitchToSlave');
    RegisterMethod(@TNNTPSend.Xover, 'Xover');
    RegisterMethod(@TNNTPSend.StartTLS, 'StartTLS');
    RegisterMethod(@TNNTPSend.FindCap, 'FindCap');
    RegisterMethod(@TNNTPSend.ListExtensions, 'ListExtensions');
    RegisterPropertyHelper(@TNNTPSendResultCode_R,nil,'ResultCode');
    RegisterPropertyHelper(@TNNTPSendResultString_R,nil,'ResultString');
    RegisterPropertyHelper(@TNNTPSendData_R,nil,'Data');
    RegisterPropertyHelper(@TNNTPSendAutoTLS_R,@TNNTPSendAutoTLS_W,'AutoTLS');
    RegisterPropertyHelper(@TNNTPSendFullSSL_R,@TNNTPSendFullSSL_W,'FullSSL');
    RegisterPropertyHelper(@TNNTPSendSock_R,nil,'Sock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_nntpsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNNTPSend(CL);
end;

 
 
{ TPSImport_nntpsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_nntpsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_nntpsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_nntpsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_nntpsend(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
