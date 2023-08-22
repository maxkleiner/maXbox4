unit uPSI_JvDice;
{
  for simulation
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
  TPSImport_JvDice = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDice(CL: TPSPascalCompiler);
procedure SIRegister_JvDice(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvDice(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDice(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,WinTypes
  ,WinProcs
  ,Graphics
  ,Messages
  ,Controls
  ,Forms
  ,Menus
  ,JvTimer
  ,JvDice
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDice]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDice(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TJvDice') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TJvDice') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure RandomValue');
    RegisterPublishedProperties;
    RegisterProperty('AutoSize', 'Boolean', iptrw);
    RegisterProperty('AutoStopInterval', 'Cardinal', iptrw);
    RegisterProperty('Interval', 'Cardinal', iptrw);
    RegisterProperty('Rotate', 'Boolean', iptrw);
    RegisterProperty('ShowFocus', 'Boolean', iptrw);
    RegisterProperty('Value', 'TJvDiceValue', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStart', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStop', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDice(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvDiceValue', 'Integer');
  SIRegister_TJvDice(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDiceOnStop_W(Self: TJvDice; const T: TNotifyEvent);
begin Self.OnStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceOnStop_R(Self: TJvDice; var T: TNotifyEvent);
begin T := Self.OnStop; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceOnStart_W(Self: TJvDice; const T: TNotifyEvent);
begin Self.OnStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceOnStart_R(Self: TJvDice; var T: TNotifyEvent);
begin T := Self.OnStart; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceOnChange_W(Self: TJvDice; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceOnChange_R(Self: TJvDice; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceValue_W(Self: TJvDice; const T: TJvDiceValue);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceValue_R(Self: TJvDice; var T: TJvDiceValue);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceShowFocus_W(Self: TJvDice; const T: Boolean);
begin Self.ShowFocus := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceShowFocus_R(Self: TJvDice; var T: Boolean);
begin T := Self.ShowFocus; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceRotate_W(Self: TJvDice; const T: Boolean);
begin Self.Rotate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceRotate_R(Self: TJvDice; var T: Boolean);
begin T := Self.Rotate; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceInterval_W(Self: TJvDice; const T: Cardinal);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceInterval_R(Self: TJvDice; var T: Cardinal);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceAutoStopInterval_W(Self: TJvDice; const T: Cardinal);
begin Self.AutoStopInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceAutoStopInterval_R(Self: TJvDice; var T: Cardinal);
begin T := Self.AutoStopInterval; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceAutoSize_W(Self: TJvDice; const T: Boolean);
begin Self.AutoSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiceAutoSize_R(Self: TJvDice; var T: Boolean);
begin T := Self.AutoSize; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDice(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDice) do begin
    RegisterConstructor(@TJvDice.Create, 'Create');
    RegisterMethod(@TJvDice.Destroy, 'Free');
    RegisterMethod(@TJvDice.RandomValue, 'RandomValue');
    RegisterPropertyHelper(@TJvDiceAutoSize_R,@TJvDiceAutoSize_W,'AutoSize');
    RegisterPropertyHelper(@TJvDiceAutoStopInterval_R,@TJvDiceAutoStopInterval_W,'AutoStopInterval');
    RegisterPropertyHelper(@TJvDiceInterval_R,@TJvDiceInterval_W,'Interval');
    RegisterPropertyHelper(@TJvDiceRotate_R,@TJvDiceRotate_W,'Rotate');
    RegisterPropertyHelper(@TJvDiceShowFocus_R,@TJvDiceShowFocus_W,'ShowFocus');
    RegisterPropertyHelper(@TJvDiceValue_R,@TJvDiceValue_W,'Value');
    RegisterPropertyHelper(@TJvDiceOnChange_R,@TJvDiceOnChange_W,'OnChange');
    RegisterPropertyHelper(@TJvDiceOnStart_R,@TJvDiceOnStart_W,'OnStart');
    RegisterPropertyHelper(@TJvDiceOnStop_R,@TJvDiceOnStop_W,'OnStop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDice(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDice(CL);
end;

 
 
{ TPSImport_JvDice }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDice.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDice(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDice.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDice(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
