unit uPSI_JvTimerLst;
{ non visual component
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
  TPSImport_JvTimerLst = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvTimerEvent(CL: TPSPascalCompiler);
procedure SIRegister_TJvTimerList(CL: TPSPascalCompiler);
procedure SIRegister_JvTimerLst(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvTimerEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvTimerList(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvTimerLst(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,WinTypes
  ,WinProcs
  ,Messages
  ,JvTimerLst
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvTimerLst]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTimerEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvTimerEvent') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvTimerEvent') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function HasParent : Boolean');
    RegisterMethod('Function GetParentComponent : TComponent');
    RegisterProperty('AsSeconds', 'Cardinal', iptrw);
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('ExecCount', 'Integer', iptr);
    RegisterProperty('TimerList', 'TJvTimerList', iptr);
    RegisterProperty('Cycled', 'Boolean', iptrw);
    RegisterProperty('RepeatCount', 'Integer', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Interval', 'Longint', iptrw);
    RegisterProperty('OnTimer', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTimerList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvTimerList') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvTimerList') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Add( AOnTimer : TNotifyEvent; AInterval : Longint; ACycled : Boolean) : THandle');
    RegisterMethod('Function AddItem( Item : TJvTimerEvent) : THandle');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( AHandle : THandle)');
    RegisterMethod('Procedure Activate');
    RegisterMethod('Procedure Deactivate');
    RegisterMethod('Function ItemByHandle( AHandle : THandle) : TJvTimerEvent');
    RegisterMethod('Function ItemIndexByHandle( AHandle : THandle) : Integer');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('EnabledCount', 'Integer', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Events', 'TList', iptr);
    RegisterProperty('OnFinish', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTimers', 'TAllTimersEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvTimerLst(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DefaultInterval','LongInt').SetInt( 1000);
  CL.AddTypeS('TAllTimersEvent', 'Procedure (Sender: TObject; Handle: Longint)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvTimerEvent');
  SIRegister_TJvTimerList(CL);
  SIRegister_TJvTimerEvent(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvTimerEventOnTimer_W(Self: TJvTimerEvent; const T: TNotifyEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventOnTimer_R(Self: TJvTimerEvent; var T: TNotifyEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventInterval_W(Self: TJvTimerEvent; const T: Longint);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventInterval_R(Self: TJvTimerEvent; var T: Longint);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventEnabled_W(Self: TJvTimerEvent; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventEnabled_R(Self: TJvTimerEvent; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventRepeatCount_W(Self: TJvTimerEvent; const T: Integer);
begin Self.RepeatCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventRepeatCount_R(Self: TJvTimerEvent; var T: Integer);
begin T := Self.RepeatCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventCycled_W(Self: TJvTimerEvent; const T: Boolean);
begin Self.Cycled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventCycled_R(Self: TJvTimerEvent; var T: Boolean);
begin T := Self.Cycled; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventTimerList_R(Self: TJvTimerEvent; var T: TJvTimerList);
begin T := Self.TimerList; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventExecCount_R(Self: TJvTimerEvent; var T: Integer);
begin T := Self.ExecCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventHandle_R(Self: TJvTimerEvent; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventAsSeconds_W(Self: TJvTimerEvent; const T: Cardinal);
begin Self.AsSeconds := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerEventAsSeconds_R(Self: TJvTimerEvent; var T: Cardinal);
begin T := Self.AsSeconds; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerListOnTimers_W(Self: TJvTimerList; const T: TAllTimersEvent);
begin Self.OnTimers := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerListOnTimers_R(Self: TJvTimerList; var T: TAllTimersEvent);
begin T := Self.OnTimers; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerListOnFinish_W(Self: TJvTimerList; const T: TNotifyEvent);
begin Self.OnFinish := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerListOnFinish_R(Self: TJvTimerList; var T: TNotifyEvent);
begin T := Self.OnFinish; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerListEvents_R(Self: TJvTimerList; var T: TList);
begin T := Self.Events; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerListActive_W(Self: TJvTimerList; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerListActive_R(Self: TJvTimerList; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerListEnabledCount_R(Self: TJvTimerList; var T: Integer);
begin T := Self.EnabledCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvTimerListCount_R(Self: TJvTimerList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTimerEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTimerEvent) do begin
    RegisterConstructor(@TJvTimerEvent.Create, 'Create');
    RegisterMethod(@TJvTimerEvent.Destroy, 'Free');
    RegisterMethod(@TJvTimerEvent.HasParent, 'HasParent');
    RegisterMethod(@TJvTimerEvent.GetParentComponent, 'GetParentComponent');
    RegisterPropertyHelper(@TJvTimerEventAsSeconds_R,@TJvTimerEventAsSeconds_W,'AsSeconds');
    RegisterPropertyHelper(@TJvTimerEventHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TJvTimerEventExecCount_R,nil,'ExecCount');
    RegisterPropertyHelper(@TJvTimerEventTimerList_R,nil,'TimerList');
    RegisterPropertyHelper(@TJvTimerEventCycled_R,@TJvTimerEventCycled_W,'Cycled');
    RegisterPropertyHelper(@TJvTimerEventRepeatCount_R,@TJvTimerEventRepeatCount_W,'RepeatCount');
    RegisterPropertyHelper(@TJvTimerEventEnabled_R,@TJvTimerEventEnabled_W,'Enabled');
    RegisterPropertyHelper(@TJvTimerEventInterval_R,@TJvTimerEventInterval_W,'Interval');
    RegisterPropertyHelper(@TJvTimerEventOnTimer_R,@TJvTimerEventOnTimer_W,'OnTimer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTimerList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTimerList) do begin
    RegisterConstructor(@TJvTimerList.Create, 'Create');
    RegisterMethod(@TJvTimerList.Destroy, 'Free');
    RegisterVirtualMethod(@TJvTimerList.Add, 'Add');
    RegisterMethod(@TJvTimerList.AddItem, 'AddItem');
    RegisterMethod(@TJvTimerList.Clear, 'Clear');
    RegisterVirtualMethod(@TJvTimerList.Delete, 'Delete');
    RegisterMethod(@TJvTimerList.Activate, 'Activate');
    RegisterMethod(@TJvTimerList.Deactivate, 'Deactivate');
    RegisterMethod(@TJvTimerList.ItemByHandle, 'ItemByHandle');
    RegisterMethod(@TJvTimerList.ItemIndexByHandle, 'ItemIndexByHandle');
    RegisterPropertyHelper(@TJvTimerListCount_R,nil,'Count');
    RegisterPropertyHelper(@TJvTimerListEnabledCount_R,nil,'EnabledCount');
    RegisterPropertyHelper(@TJvTimerListActive_R,@TJvTimerListActive_W,'Active');
    RegisterPropertyHelper(@TJvTimerListEvents_R,nil,'Events');
    RegisterPropertyHelper(@TJvTimerListOnFinish_R,@TJvTimerListOnFinish_W,'OnFinish');
    RegisterPropertyHelper(@TJvTimerListOnTimers_R,@TJvTimerListOnTimers_W,'OnTimers');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvTimerLst(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTimerEvent) do
  RIRegister_TJvTimerList(CL);
  RIRegister_TJvTimerEvent(CL);
end;

 
 
{ TPSImport_JvTimerLst }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTimerLst.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvTimerLst(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTimerLst.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvTimerLst(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
