unit uPSI_IdIdent;
{
   to ident server
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
  TPSImport_IdIdent = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdIdent(CL: TPSPascalCompiler);
procedure SIRegister_IdIdent(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdIdent(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdIdent(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdException
  ,IdTCPClient
  ,IdIdent
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdIdent]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIdent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPClient', 'TIdIdent') do
  with CL.AddClassN(CL.FindClass('TIdTCPClient'),'TIdIdent') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Query( APortOnServer, APortOnClient : Word)');
    RegisterProperty('Reply', 'String', iptr);
    RegisterProperty('ReplyCharset', 'String', iptr);
    RegisterProperty('ReplyOS', 'String', iptr);
    RegisterProperty('ReplyOther', 'String', iptr);
    RegisterProperty('ReplyUserName', 'String', iptr);
    RegisterProperty('QueryTimeOut', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdIdent(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IdIdentQryTimeout','LongInt').SetInt( 60000);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdIdentException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdIdentReply');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdIdentInvalidPort');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdIdentNoUser');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdIdentHiddenUser');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdIdentUnknownError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdIdentQueryTimeOut');
  SIRegister_TIdIdent(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdIdentQueryTimeOut_W(Self: TIdIdent; const T: Integer);
begin Self.QueryTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIdentQueryTimeOut_R(Self: TIdIdent; var T: Integer);
begin T := Self.QueryTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TIdIdentReplyUserName_R(Self: TIdIdent; var T: String);
begin T := Self.ReplyUserName; end;

(*----------------------------------------------------------------------------*)
procedure TIdIdentReplyOther_R(Self: TIdIdent; var T: String);
begin T := Self.ReplyOther; end;

(*----------------------------------------------------------------------------*)
procedure TIdIdentReplyOS_R(Self: TIdIdent; var T: String);
begin T := Self.ReplyOS; end;

(*----------------------------------------------------------------------------*)
procedure TIdIdentReplyCharset_R(Self: TIdIdent; var T: String);
begin T := Self.ReplyCharset; end;

(*----------------------------------------------------------------------------*)
procedure TIdIdentReply_R(Self: TIdIdent; var T: String);
begin T := Self.Reply; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIdent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIdent) do begin
    RegisterConstructor(@TIdIdent.Create, 'Create');
    RegisterMethod(@TIdIdent.Query, 'Query');
    RegisterPropertyHelper(@TIdIdentReply_R,nil,'Reply');
    RegisterPropertyHelper(@TIdIdentReplyCharset_R,nil,'ReplyCharset');
    RegisterPropertyHelper(@TIdIdentReplyOS_R,nil,'ReplyOS');
    RegisterPropertyHelper(@TIdIdentReplyOther_R,nil,'ReplyOther');
    RegisterPropertyHelper(@TIdIdentReplyUserName_R,nil,'ReplyUserName');
    RegisterPropertyHelper(@TIdIdentQueryTimeOut_R,@TIdIdentQueryTimeOut_W,'QueryTimeOut');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdIdent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EIdIdentException) do
  with CL.Add(EIdIdentReply) do
  with CL.Add(EIdIdentInvalidPort) do
  with CL.Add(EIdIdentNoUser) do
  with CL.Add(EIdIdentHiddenUser) do
  with CL.Add(EIdIdentUnknownError) do
  with CL.Add(EIdIdentQueryTimeOut) do
  RIRegister_TIdIdent(CL);
end;

 
 
{ TPSImport_IdIdent }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIdent.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdIdent(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIdent.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdIdent(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
