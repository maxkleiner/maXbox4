unit uPSI_JvAlarms;
{

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
  TPSImport_JvAlarms = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvAlarms(CL: TPSPascalCompiler);
procedure SIRegister_TJvAlarmItems(CL: TPSPascalCompiler);
procedure SIRegister_TJvAlarmItem(CL: TPSPascalCompiler);
procedure SIRegister_JvAlarms(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvAlarms(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvAlarmItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvAlarmItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvAlarms(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Dialogs
  ,Controls
  ,ExtCtrls
  ,JvComponent
  ,JvAlarms
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvAlarms]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAlarms(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvAlarms') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvAlarms') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Add( const AName : string; const ATime : TDateTime; const AKind : TJvTriggerKind)');
    RegisterMethod('Procedure Delete( const Idx : Cardinal)');
    RegisterProperty('Running', 'Boolean', iptr);
    RegisterProperty('Alarms', 'TJvAlarmItems', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('OnAlarm', 'TJvOnAlarm', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAlarmItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TJvAlarmItems') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TJvAlarmItems') do begin
    RegisterMethod('Constructor Create( AOwner : TPersistent)');
    RegisterMethod('Function Add : TJvAlarmItem');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Items', 'TJVAlarmItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAlarmItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TJvAlarmItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TJvAlarmItem') do begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Time', 'TDateTime', iptrw);
    RegisterProperty('Kind', 'TJvTriggerKind', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvAlarms(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvTriggerKind', '( tkOneShot, tkEachSecond, tkEachMinute, tkEac'
   +'hHour, tkEachDay, tkEachMonth, tkEachYear )');
  SIRegister_TJvAlarmItem(CL);
  CL.AddTypeS('TJvOnAlarm', 'Procedure ( Sender : TObject; const Alarm : TJvAla'
   +'rmItem; const TriggerTime : TDateTime)');
  SIRegister_TJvAlarmItems(CL);
  SIRegister_TJvAlarms(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvAlarmsOnAlarm_W(Self: TJvAlarms; const T: TJvOnAlarm);
begin Self.OnAlarm := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmsOnAlarm_R(Self: TJvAlarms; var T: TJvOnAlarm);
begin T := Self.OnAlarm; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmsActive_W(Self: TJvAlarms; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmsActive_R(Self: TJvAlarms; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmsAlarms_W(Self: TJvAlarms; const T: TJvAlarmItems);
begin Self.Alarms := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmsAlarms_R(Self: TJvAlarms; var T: TJvAlarmItems);
begin T := Self.Alarms; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmsRunning_R(Self: TJvAlarms; var T: Boolean);
begin T := Self.Running; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmItemsItems_W(Self: TJvAlarmItems; const T: TJVAlarmItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmItemsItems_R(Self: TJvAlarmItems; var T: TJVAlarmItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmItemKind_W(Self: TJvAlarmItem; const T: TJvTriggerKind);
begin Self.Kind := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmItemKind_R(Self: TJvAlarmItem; var T: TJvTriggerKind);
begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmItemTime_W(Self: TJvAlarmItem; const T: TDateTime);
begin Self.Time := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmItemTime_R(Self: TJvAlarmItem; var T: TDateTime);
begin T := Self.Time; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmItemName_W(Self: TJvAlarmItem; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAlarmItemName_R(Self: TJvAlarmItem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAlarms(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAlarms) do begin
    RegisterConstructor(@TJvAlarms.Create, 'Create');
    RegisterMethod(@TJvAlarms.Destroy, 'Free');
   RegisterMethod(@TJvAlarms.Add, 'Add');
    RegisterMethod(@TJvAlarms.Delete, 'Delete');
    RegisterPropertyHelper(@TJvAlarmsRunning_R,nil,'Running');
    RegisterPropertyHelper(@TJvAlarmsAlarms_R,@TJvAlarmsAlarms_W,'Alarms');
    RegisterPropertyHelper(@TJvAlarmsActive_R,@TJvAlarmsActive_W,'Active');
    RegisterPropertyHelper(@TJvAlarmsOnAlarm_R,@TJvAlarmsOnAlarm_W,'OnAlarm');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAlarmItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAlarmItems) do begin
    RegisterConstructor(@TJvAlarmItems.Create, 'Create');
    RegisterMethod(@TJvAlarmItems.Add, 'Add');
    RegisterMethod(@TJvAlarmItems.Assign, 'Assign');
    RegisterPropertyHelper(@TJvAlarmItemsItems_R,@TJvAlarmItemsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAlarmItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAlarmItem) do begin
    RegisterMethod(@TJvAlarmItem.Assign, 'Assign');
    RegisterPropertyHelper(@TJvAlarmItemName_R,@TJvAlarmItemName_W,'Name');
    RegisterPropertyHelper(@TJvAlarmItemTime_R,@TJvAlarmItemTime_W,'Time');
    RegisterPropertyHelper(@TJvAlarmItemKind_R,@TJvAlarmItemKind_W,'Kind');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvAlarms(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvAlarmItem(CL);
  RIRegister_TJvAlarmItems(CL);
  RIRegister_TJvAlarms(CL);
end;

 
 
{ TPSImport_JvAlarms }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAlarms.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvAlarms(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAlarms.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvAlarms(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
