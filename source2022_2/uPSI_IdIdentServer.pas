unit uPSI_IdIdentServer;
{
   ident proto
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
  TPSImport_IdIdentServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TIdIdentServer(CL: TPSPascalCompiler);
procedure SIRegister_IdIdentServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdIdentServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdIdentServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPServer
  ,IdIdentServer
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdIdentServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIdentServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdIdentServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdIdentServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure ReplyError( AThread : TIdPeerThread; AServerPort, AClientPort : Integer; AErr : TIdIdentErrorType)');
    RegisterMethod('Procedure ReplyIdent( AThread : TIdPeerThread; AServerPort, AClientPort : Integer; AOS, AUserName : String; const ACharset : String)');
    RegisterMethod('Procedure ReplyOther( AThread : TIdPeerThread; AServerPort, AClientPort : Integer; AOther : String)');
    RegisterProperty('QueryTimeOut', 'Integer', iptrw);
    RegisterProperty('OnIdentQuery', 'TIdIdentQueryEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdIdentServer(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IdDefIdentQueryTimeOut','LongInt').SetInt( 60000);
  CL.AddTypeS('TIdIdentQueryEvent', 'Procedure ( AThread : TIdPeerThread; AServ'
   +'erPort, AClientPort : Integer)');
  CL.AddTypeS('TIdIdentErrorType', '( ieInvalidPort, ieNoUser, ieHiddenUser, ieUnknownError )');
  SIRegister_TIdIdentServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdIdentServerOnIdentQuery_W(Self: TIdIdentServer; const T: TIdIdentQueryEvent);
begin Self.OnIdentQuery := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIdentServerOnIdentQuery_R(Self: TIdIdentServer; var T: TIdIdentQueryEvent);
begin T := Self.OnIdentQuery; end;

(*----------------------------------------------------------------------------*)
procedure TIdIdentServerQueryTimeOut_W(Self: TIdIdentServer; const T: Integer);
begin Self.QueryTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIdentServerQueryTimeOut_R(Self: TIdIdentServer; var T: Integer);
begin T := Self.QueryTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIdentServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIdentServer) do begin
    RegisterConstructor(@TIdIdentServer.Create, 'Create');
    RegisterMethod(@TIdIdentServer.ReplyError, 'ReplyError');
    RegisterMethod(@TIdIdentServer.ReplyIdent, 'ReplyIdent');
    RegisterMethod(@TIdIdentServer.ReplyOther, 'ReplyOther');
    RegisterPropertyHelper(@TIdIdentServerQueryTimeOut_R,@TIdIdentServerQueryTimeOut_W,'QueryTimeOut');
    RegisterPropertyHelper(@TIdIdentServerOnIdentQuery_R,@TIdIdentServerOnIdentQuery_W,'OnIdentQuery');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdIdentServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdIdentServer(CL);
end;

 
 
{ TPSImport_IdIdentServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIdentServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdIdentServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIdentServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdIdentServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
