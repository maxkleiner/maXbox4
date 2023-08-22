unit uPSI_JvAppInst;
{
  now what
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
  TPSImport_JvAppInst = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvAppInstances(CL: TPSPascalCompiler);
procedure SIRegister_JvAppInst(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvAppInstances(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvAppInst(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  Messages
  ,Forms
  ,JclAppInst
  ,JvAppInst
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvAppInst]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAppInstances(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvAppInstances') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvAppInstances') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Check');
    RegisterMethod('Procedure UserNotify( Param : Integer)');
    RegisterMethod('Function SendData( DataKind : TJclAppInstDataKind; Data : Pointer; Size : Integer) : Boolean');
    RegisterProperty('AppInstances', 'TJclAppInstances', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('AutoActivate', 'Boolean', iptrw);
    RegisterProperty('MaxInstances', 'Integer', iptrw);
    RegisterProperty('SendCmdLine', 'Boolean', iptrw);
    RegisterProperty('OnInstanceCreated', 'TInstanceChangeEvent', iptrw);
    RegisterProperty('OnInstanceDestroyed', 'TInstanceChangeEvent', iptrw);
    RegisterProperty('OnUserNotify', 'TUserNotifyEvent', iptrw);
    RegisterProperty('OnDataAvailable', 'TDataAvailableEvent', iptrw);
    RegisterProperty('OnCmdLineReceived', 'TCmdLineReceivedEvent', iptrw);
    RegisterProperty('OnRejected', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvAppInst(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvAppInstDataKind', 'TJclAppInstDataKind');
  CL.AddTypeS('TInstanceChangeEvent', 'Procedure ( Sender : TObject; ProcessId: Cardinal)');
  CL.AddTypeS('TUserNotifyEvent', 'Procedure ( Sender : TObject; Param : Integer)');
  //CL.AddTypeS('TDataAvailableEvent', 'Procedure ( Sender : TObject; Kind : TJvA'
  // +'ppInstDataKind; Data : Pointer; Size : Integer)');
  CL.AddTypeS('TCmdLineReceivedEvent', 'Procedure ( Sender : TObject; CmdLine: TStrings)');
  SIRegister_TJvAppInstances(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnRejected_W(Self: TJvAppInstances; const T: TNotifyEvent);
begin Self.OnRejected := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnRejected_R(Self: TJvAppInstances; var T: TNotifyEvent);
begin T := Self.OnRejected; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnCmdLineReceived_W(Self: TJvAppInstances; const T: TCmdLineReceivedEvent);
begin Self.OnCmdLineReceived := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnCmdLineReceived_R(Self: TJvAppInstances; var T: TCmdLineReceivedEvent);
begin T := Self.OnCmdLineReceived; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnDataAvailable_W(Self: TJvAppInstances; const T: TDataAvailableEvent);
begin Self.OnDataAvailable := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnDataAvailable_R(Self: TJvAppInstances; var T: TDataAvailableEvent);
begin T := Self.OnDataAvailable; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnUserNotify_W(Self: TJvAppInstances; const T: TUserNotifyEvent);
begin Self.OnUserNotify := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnUserNotify_R(Self: TJvAppInstances; var T: TUserNotifyEvent);
begin T := Self.OnUserNotify; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnInstanceDestroyed_W(Self: TJvAppInstances; const T: TInstanceChangeEvent);
begin Self.OnInstanceDestroyed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnInstanceDestroyed_R(Self: TJvAppInstances; var T: TInstanceChangeEvent);
begin T := Self.OnInstanceDestroyed; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnInstanceCreated_W(Self: TJvAppInstances; const T: TInstanceChangeEvent);
begin Self.OnInstanceCreated := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesOnInstanceCreated_R(Self: TJvAppInstances; var T: TInstanceChangeEvent);
begin T := Self.OnInstanceCreated; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesSendCmdLine_W(Self: TJvAppInstances; const T: Boolean);
begin Self.SendCmdLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesSendCmdLine_R(Self: TJvAppInstances; var T: Boolean);
begin T := Self.SendCmdLine; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesMaxInstances_W(Self: TJvAppInstances; const T: Integer);
begin Self.MaxInstances := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesMaxInstances_R(Self: TJvAppInstances; var T: Integer);
begin T := Self.MaxInstances; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesAutoActivate_W(Self: TJvAppInstances; const T: Boolean);
begin Self.AutoActivate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesAutoActivate_R(Self: TJvAppInstances; var T: Boolean);
begin T := Self.AutoActivate; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesActive_W(Self: TJvAppInstances; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesActive_R(Self: TJvAppInstances; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppInstancesAppInstances_R(Self: TJvAppInstances; var T: TJclAppInstances);
begin T := Self.AppInstances; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAppInstances(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAppInstances) do begin
    RegisterConstructor(@TJvAppInstances.Create, 'Create');
    RegisterMethod(@TJvAppInstances.Destroy, 'Free');

    RegisterMethod(@TJvAppInstances.Check, 'Check');
    RegisterMethod(@TJvAppInstances.UserNotify, 'UserNotify');
    RegisterMethod(@TJvAppInstances.SendData, 'SendData');
    RegisterPropertyHelper(@TJvAppInstancesAppInstances_R,nil,'AppInstances');
    RegisterPropertyHelper(@TJvAppInstancesActive_R,@TJvAppInstancesActive_W,'Active');
    RegisterPropertyHelper(@TJvAppInstancesAutoActivate_R,@TJvAppInstancesAutoActivate_W,'AutoActivate');
    RegisterPropertyHelper(@TJvAppInstancesMaxInstances_R,@TJvAppInstancesMaxInstances_W,'MaxInstances');
    RegisterPropertyHelper(@TJvAppInstancesSendCmdLine_R,@TJvAppInstancesSendCmdLine_W,'SendCmdLine');
    RegisterPropertyHelper(@TJvAppInstancesOnInstanceCreated_R,@TJvAppInstancesOnInstanceCreated_W,'OnInstanceCreated');
    RegisterPropertyHelper(@TJvAppInstancesOnInstanceDestroyed_R,@TJvAppInstancesOnInstanceDestroyed_W,'OnInstanceDestroyed');
    RegisterPropertyHelper(@TJvAppInstancesOnUserNotify_R,@TJvAppInstancesOnUserNotify_W,'OnUserNotify');
    RegisterPropertyHelper(@TJvAppInstancesOnDataAvailable_R,@TJvAppInstancesOnDataAvailable_W,'OnDataAvailable');
    RegisterPropertyHelper(@TJvAppInstancesOnCmdLineReceived_R,@TJvAppInstancesOnCmdLineReceived_W,'OnCmdLineReceived');
    RegisterPropertyHelper(@TJvAppInstancesOnRejected_R,@TJvAppInstancesOnRejected_W,'OnRejected');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvAppInst(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvAppInstances(CL);
end;

 
 
{ TPSImport_JvAppInst }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAppInst.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvAppInst(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAppInst.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvAppInst(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
