unit uPSI_JvCommStatus;
{
  for Arduino
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
  TPSImport_JvCommStatus = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvCommStatus(CL: TPSPascalCompiler);
procedure SIRegister_TJvCommWatcher(CL: TPSPascalCompiler);
procedure SIRegister_JvCommStatus(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvCommStatus(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCommWatcher(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvCommStatus(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,JvComponentBase
  //,JvThread
  ,JvCommStatus
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvCommStatus]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCommStatus(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvCommStatus') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvCommStatus') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterProperty('ClearToSend', 'Boolean', iptrw);
    RegisterProperty('DataSetReady', 'Boolean', iptrw);
    RegisterProperty('Ring', 'Boolean', iptrw);
    RegisterProperty('ReceiveLine', 'Boolean', iptrw);
    RegisterProperty('Comm', 'TJvCommPort', iptrw);
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCommWatcher(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvPausableThread', 'TJvCommWatcher') do
  with CL.AddClassN(CL.FindClass('TJvPausableThread'),'TJvCommWatcher') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvCommStatus(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvCommPort', 'Integer');
  SIRegister_TJvCommWatcher(CL);
  SIRegister_TJvCommStatus(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvCommStatusOnChanged_W(Self: TJvCommStatus; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCommStatusOnChanged_R(Self: TJvCommStatus; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvCommStatusComm_W(Self: TJvCommStatus; const T: TJvCommPort);
begin Self.Comm := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCommStatusComm_R(Self: TJvCommStatus; var T: TJvCommPort);
begin T := Self.Comm; end;

(*----------------------------------------------------------------------------*)
procedure TJvCommStatusReceiveLine_W(Self: TJvCommStatus; const T: Boolean);
begin Self.ReceiveLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCommStatusReceiveLine_R(Self: TJvCommStatus; var T: Boolean);
begin T := Self.ReceiveLine; end;

(*----------------------------------------------------------------------------*)
procedure TJvCommStatusRing_W(Self: TJvCommStatus; const T: Boolean);
begin Self.Ring := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCommStatusRing_R(Self: TJvCommStatus; var T: Boolean);
begin T := Self.Ring; end;

(*----------------------------------------------------------------------------*)
procedure TJvCommStatusDataSetReady_W(Self: TJvCommStatus; const T: Boolean);
begin Self.DataSetReady := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCommStatusDataSetReady_R(Self: TJvCommStatus; var T: Boolean);
begin T := Self.DataSetReady; end;

(*----------------------------------------------------------------------------*)
procedure TJvCommStatusClearToSend_W(Self: TJvCommStatus; const T: Boolean);
begin Self.ClearToSend := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCommStatusClearToSend_R(Self: TJvCommStatus; var T: Boolean);
begin T := Self.ClearToSend; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCommStatus(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCommStatus) do begin
    RegisterConstructor(@TJvCommStatus.Create, 'Create');
    RegisterMethod(@TJvCommStatus.Destroy, 'Free');
    RegisterPropertyHelper(@TJvCommStatusClearToSend_R,@TJvCommStatusClearToSend_W,'ClearToSend');
    RegisterPropertyHelper(@TJvCommStatusDataSetReady_R,@TJvCommStatusDataSetReady_W,'DataSetReady');
    RegisterPropertyHelper(@TJvCommStatusRing_R,@TJvCommStatusRing_W,'Ring');
    RegisterPropertyHelper(@TJvCommStatusReceiveLine_R,@TJvCommStatusReceiveLine_W,'ReceiveLine');
    RegisterPropertyHelper(@TJvCommStatusComm_R,@TJvCommStatusComm_W,'Comm');
    RegisterPropertyHelper(@TJvCommStatusOnChanged_R,@TJvCommStatusOnChanged_W,'OnChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCommWatcher(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCommWatcher) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvCommStatus(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvCommWatcher(CL);
  RIRegister_TJvCommStatus(CL);
end;

 
 
{ TPSImport_JvCommStatus }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCommStatus.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvCommStatus(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCommStatus.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvCommStatus(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
