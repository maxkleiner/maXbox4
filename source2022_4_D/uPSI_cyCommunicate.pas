unit uPSI_cyCommunicate;
{
   set the controls 
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
  TPSImport_cyCommunicate = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyCommunicate(CL: TPSPascalCompiler);
procedure SIRegister_cyCommunicate(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyCommunicate(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyCommunicate(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cyBaseComm
  ,cyBaseCommRoomConnector
  ,cyCommunicate
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyCommunicate]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyCommunicate(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TcyBaseComm', 'TcyCommunicate') do
  with CL.AddClassN(CL.FindClass('TcyBaseComm'),'TcyCommunicate') do
  begin
    RegisterProperty('OnReceiveCommand', 'TProcOnReceiveCommand', iptrw);
    RegisterProperty('OnReceiveString', 'TProcOnReceiveString', iptrw);
    RegisterProperty('OnReceiveStream', 'TProcOnReceiveMemoryStream', iptrw);
    RegisterProperty('OnRoomSomeoneEnter', 'TProcOnRoomCommand', iptrw);
    RegisterProperty('OnRoomSomeoneExit', 'TProcOnRoomCommand', iptrw);
    RegisterProperty('OnRoomSomeoneUpdate', 'TProcOnRoomCommand', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyCommunicate(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TProcOnRoomCommand', 'Procedure ( Sender : TObject; BaseComHandle : THandle)');
  SIRegister_TcyCommunicate(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnRoomSomeoneUpdate_W(Self: TcyCommunicate; const T: TProcOnRoomCommand);
begin Self.OnRoomSomeoneUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnRoomSomeoneUpdate_R(Self: TcyCommunicate; var T: TProcOnRoomCommand);
begin T := Self.OnRoomSomeoneUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnRoomSomeoneExit_W(Self: TcyCommunicate; const T: TProcOnRoomCommand);
begin Self.OnRoomSomeoneExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnRoomSomeoneExit_R(Self: TcyCommunicate; var T: TProcOnRoomCommand);
begin T := Self.OnRoomSomeoneExit; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnRoomSomeoneEnter_W(Self: TcyCommunicate; const T: TProcOnRoomCommand);
begin Self.OnRoomSomeoneEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnRoomSomeoneEnter_R(Self: TcyCommunicate; var T: TProcOnRoomCommand);
begin T := Self.OnRoomSomeoneEnter; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnReceiveStream_W(Self: TcyCommunicate; const T: TProcOnReceiveMemoryStream);
begin Self.OnReceiveStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnReceiveStream_R(Self: TcyCommunicate; var T: TProcOnReceiveMemoryStream);
begin T := Self.OnReceiveStream; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnReceiveString_W(Self: TcyCommunicate; const T: TProcOnReceiveString);
begin Self.OnReceiveString := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnReceiveString_R(Self: TcyCommunicate; var T: TProcOnReceiveString);
begin T := Self.OnReceiveString; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnReceiveCommand_W(Self: TcyCommunicate; const T: TProcOnReceiveCommand);
begin Self.OnReceiveCommand := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommunicateOnReceiveCommand_R(Self: TcyCommunicate; var T: TProcOnReceiveCommand);
begin T := Self.OnReceiveCommand; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyCommunicate(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyCommunicate) do
  begin
    RegisterPropertyHelper(@TcyCommunicateOnReceiveCommand_R,@TcyCommunicateOnReceiveCommand_W,'OnReceiveCommand');
    RegisterPropertyHelper(@TcyCommunicateOnReceiveString_R,@TcyCommunicateOnReceiveString_W,'OnReceiveString');
    RegisterPropertyHelper(@TcyCommunicateOnReceiveStream_R,@TcyCommunicateOnReceiveStream_W,'OnReceiveStream');
    RegisterPropertyHelper(@TcyCommunicateOnRoomSomeoneEnter_R,@TcyCommunicateOnRoomSomeoneEnter_W,'OnRoomSomeoneEnter');
    RegisterPropertyHelper(@TcyCommunicateOnRoomSomeoneExit_R,@TcyCommunicateOnRoomSomeoneExit_W,'OnRoomSomeoneExit');
    RegisterPropertyHelper(@TcyCommunicateOnRoomSomeoneUpdate_R,@TcyCommunicateOnRoomSomeoneUpdate_W,'OnRoomSomeoneUpdate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyCommunicate(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyCommunicate(CL);
end;

 
 
{ TPSImport_cyCommunicate }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyCommunicate.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyCommunicate(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyCommunicate.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyCommunicate(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
