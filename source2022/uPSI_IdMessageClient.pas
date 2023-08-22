unit uPSI_IdMessageClient;
{
  fix constrructor
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
  TPSImport_IdMessageClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdMessageClient(CL: TPSPascalCompiler);
procedure SIRegister_TIdIOHandlerStreamMsg(CL: TPSPascalCompiler);
procedure SIRegister_IdMessageClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdMessageClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdIOHandlerStreamMsg(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdMessageClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdGlobal
  ,IdIOHandlerStream
  ,IdMessage
  ,IdTCPClient
  ,IdHeaderList
  ,IdMessageClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdMessageClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPClient', 'TIdMessageClient') do
  with CL.AddClassN(CL.FindClass('TIdTCPClient'),'TIdMessageClient') do  begin
       RegisterMethod('Constructor Create(AOwner: TComponent)');
   RegisterMethod('Procedure ProcessMessage( AMsg : TIdMessage; AHeaderOnly : Boolean);');
    RegisterMethod('Procedure ProcessMessage1( AMsg : TIdMessage; const AStream : TStream; AHeaderOnly : Boolean);');
    RegisterMethod('Procedure ProcessMessage2( AMsg : TIdMessage; const AFilename : string; AHeaderOnly : Boolean);');
    RegisterMethod('Procedure SendMsg( AMsg : TIdMessage; const AHeadersOnly : Boolean)');
    RegisterProperty('MsgLineLength', 'integer', iptrw);
    RegisterProperty('MsgLineFold', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIOHandlerStreamMsg(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdIOHandlerStream', 'TIdIOHandlerStreamMsg') do
  with CL.AddClassN(CL.FindClass('TIdIOHandlerStream'),'TIdIOHandlerStreamMsg') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdMessageClient(CL: TPSPascalCompiler);
begin
  SIRegister_TIdIOHandlerStreamMsg(CL);
  SIRegister_TIdMessageClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdMessageClientMsgLineFold_W(Self: TIdMessageClient; const T: string);
begin Self.MsgLineFold := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageClientMsgLineFold_R(Self: TIdMessageClient; var T: string);
begin T := Self.MsgLineFold; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageClientMsgLineLength_W(Self: TIdMessageClient; const T: integer);
begin Self.MsgLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageClientMsgLineLength_R(Self: TIdMessageClient; var T: integer);
begin T := Self.MsgLineLength; end;

(*----------------------------------------------------------------------------*)
Procedure TIdMessageClientProcessMessage2_P(Self: TIdMessageClient;  AMsg : TIdMessage; const AFilename : string; AHeaderOnly : Boolean);
Begin Self.ProcessMessage(AMsg, AFilename, AHeaderOnly); END;

(*----------------------------------------------------------------------------*)
Procedure TIdMessageClientProcessMessage1_P(Self: TIdMessageClient;  AMsg : TIdMessage; const AStream : TStream; AHeaderOnly : Boolean);
Begin Self.ProcessMessage(AMsg, AStream, AHeaderOnly); END;

(*----------------------------------------------------------------------------*)
Procedure TIdMessageClientProcessMessage_P(Self: TIdMessageClient;  AMsg : TIdMessage; AHeaderOnly : Boolean);
Begin Self.ProcessMessage(AMsg, AHeaderOnly); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageClient) do begin
    RegisterConstructor(@TIdMessageClient.Create, 'Create');
    RegisterMethod(@TIdMessageClientProcessMessage_P, 'ProcessMessage');
    RegisterMethod(@TIdMessageClientProcessMessage1_P, 'ProcessMessage1');
    RegisterMethod(@TIdMessageClientProcessMessage2_P, 'ProcessMessage2');
    RegisterVirtualMethod(@TIdMessageClient.SendMsg, 'SendMsg');
    RegisterPropertyHelper(@TIdMessageClientMsgLineLength_R,@TIdMessageClientMsgLineLength_W,'MsgLineLength');
    RegisterPropertyHelper(@TIdMessageClientMsgLineFold_R,@TIdMessageClientMsgLineFold_W,'MsgLineFold');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIOHandlerStreamMsg(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIOHandlerStreamMsg) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdMessageClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdIOHandlerStreamMsg(CL);
  RIRegister_TIdMessageClient(CL);
end;

 
 
{ TPSImport_IdMessageClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMessageClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdMessageClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMessageClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdMessageClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
