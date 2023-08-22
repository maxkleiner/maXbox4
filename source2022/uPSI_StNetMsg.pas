unit uPSI_StNetMsg;
{
  Server API
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
  TPSImport_StNetMsg = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStNetMessage(CL: TPSPascalCompiler);
procedure SIRegister_StNetMsg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStNetMessage(CL: TPSRuntimeClassImporter);
procedure RIRegister_StNetMsg(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StBase
  ,StNetMsg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StNetMsg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNetMessage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStNetMessage') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStNetMessage') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure AddAlias( AName : string)');
    RegisterMethod('Function AliasNames : TStringList');
    RegisterMethod('Procedure RemoveAlias( AName : string)');
    RegisterMethod('Procedure Send');
    RegisterProperty('MsgFrom', 'string', iptrw);
    RegisterProperty('MsgText', 'string', iptrw);
    RegisterProperty('MsgTo', 'string', iptrw);
    RegisterProperty('Server', 'string', iptrw);
    RegisterProperty('OnMessageSent', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StNetMsg(CL: TPSPascalCompiler);
begin
  SIRegister_TStNetMessage(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStNetMessageOnMessageSent_W(Self: TStNetMessage; const T: TNotifyEvent);
begin Self.OnMessageSent := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetMessageOnMessageSent_R(Self: TStNetMessage; var T: TNotifyEvent);
begin T := Self.OnMessageSent; end;

(*----------------------------------------------------------------------------*)
procedure TStNetMessageServer_W(Self: TStNetMessage; const T: string);
begin Self.Server := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetMessageServer_R(Self: TStNetMessage; var T: string);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TStNetMessageMsgTo_W(Self: TStNetMessage; const T: string);
begin Self.MsgTo := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetMessageMsgTo_R(Self: TStNetMessage; var T: string);
begin T := Self.MsgTo; end;

(*----------------------------------------------------------------------------*)
procedure TStNetMessageMsgText_W(Self: TStNetMessage; const T: string);
begin Self.MsgText := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetMessageMsgText_R(Self: TStNetMessage; var T: string);
begin T := Self.MsgText; end;

(*----------------------------------------------------------------------------*)
procedure TStNetMessageMsgFrom_W(Self: TStNetMessage; const T: string);
begin Self.MsgFrom := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetMessageMsgFrom_R(Self: TStNetMessage; var T: string);
begin T := Self.MsgFrom; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNetMessage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNetMessage) do
  begin
    RegisterConstructor(@TStNetMessage.Create, 'Create');
    RegisterMethod(@TStNetMessage.AddAlias, 'AddAlias');
    RegisterMethod(@TStNetMessage.AliasNames, 'AliasNames');
    RegisterMethod(@TStNetMessage.RemoveAlias, 'RemoveAlias');
    RegisterMethod(@TStNetMessage.Send, 'Send');
    RegisterPropertyHelper(@TStNetMessageMsgFrom_R,@TStNetMessageMsgFrom_W,'MsgFrom');
    RegisterPropertyHelper(@TStNetMessageMsgText_R,@TStNetMessageMsgText_W,'MsgText');
    RegisterPropertyHelper(@TStNetMessageMsgTo_R,@TStNetMessageMsgTo_W,'MsgTo');
    RegisterPropertyHelper(@TStNetMessageServer_R,@TStNetMessageServer_W,'Server');
    RegisterPropertyHelper(@TStNetMessageOnMessageSent_R,@TStNetMessageOnMessageSent_W,'OnMessageSent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StNetMsg(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStNetMessage(CL);
end;

 
 
{ TPSImport_StNetMsg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StNetMsg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StNetMsg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StNetMsg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StNetMsg(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
