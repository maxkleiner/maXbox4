unit uPSI_JvNotify;
{
  to note
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
  TPSImport_JvNotify = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvNotifyThread(CL: TPSPascalCompiler);
procedure SIRegister_TJvFolderMonitor(CL: TPSPascalCompiler);
procedure SIRegister_JvNotify(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvNotify_Routines(S: TPSExec);
procedure RIRegister_TJvNotifyThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvFolderMonitor(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvNotify(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ExtCtrls
  ,JvNotify
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvNotify]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvNotifyThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TJvNotifyThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TJvNotifyThread') do begin
    RegisterMethod('Constructor Create( const FolderName : string; WatchSubtree : Boolean; Filter : TFileChangeFilters)');
    RegisterMethod('Procedure Terminate');
    RegisterMethod('Procedure Free');
    RegisterProperty('Finished', 'Boolean', iptr);
    RegisterProperty('LastError', 'DWORD', iptr);
    RegisterProperty('NotifyHandle', 'THandle', iptr);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvFolderMonitor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvFolderMonitor') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvFolderMonitor') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('DelayTime', 'Cardinal', iptrw);
    RegisterProperty('Filter', 'TFileChangeFilters', iptrw);
    RegisterProperty('FolderName', 'string', iptrw);
    RegisterProperty('MonitorSubtree', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvNotify(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TFileChangeFilter', '( fnFileName, fnDirName, fnAttributes, fnSi'
   +'ze, fnLastWrite, fnLastAccess, fnCreation, fnSecurity )');
  CL.AddTypeS('TFileChangeFilters', 'set of TFileChangeFilter');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvNotifyThread');
  SIRegister_TJvFolderMonitor(CL);
  SIRegister_TJvNotifyThread(CL);
 CL.AddDelphiFunction('Function CreateNotifyThread( const FolderName : string; WatchSubtree : Boolean; Filter : TFileChangeFilters) : TJvNotifyThread');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvNotifyThreadOnChange_W(Self: TJvNotifyThread; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvNotifyThreadOnChange_R(Self: TJvNotifyThread; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvNotifyThreadNotifyHandle_R(Self: TJvNotifyThread; var T: THandle);
begin T := Self.NotifyHandle; end;

(*----------------------------------------------------------------------------*)
procedure TJvNotifyThreadLastError_R(Self: TJvNotifyThread; var T: DWORD);
begin T := Self.LastError; end;

(*----------------------------------------------------------------------------*)
procedure TJvNotifyThreadFinished_R(Self: TJvNotifyThread; var T: Boolean);
begin T := Self.Finished; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorOnChange_W(Self: TJvFolderMonitor; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorOnChange_R(Self: TJvFolderMonitor; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorMonitorSubtree_W(Self: TJvFolderMonitor; const T: Boolean);
begin Self.MonitorSubtree := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorMonitorSubtree_R(Self: TJvFolderMonitor; var T: Boolean);
begin T := Self.MonitorSubtree; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorFolderName_W(Self: TJvFolderMonitor; const T: string);
begin Self.FolderName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorFolderName_R(Self: TJvFolderMonitor; var T: string);
begin T := Self.FolderName; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorFilter_W(Self: TJvFolderMonitor; const T: TFileChangeFilters);
begin Self.Filter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorFilter_R(Self: TJvFolderMonitor; var T: TFileChangeFilters);
begin T := Self.Filter; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorDelayTime_W(Self: TJvFolderMonitor; const T: Cardinal);
begin Self.DelayTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorDelayTime_R(Self: TJvFolderMonitor; var T: Cardinal);
begin T := Self.DelayTime; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorActive_W(Self: TJvFolderMonitor; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFolderMonitorActive_R(Self: TJvFolderMonitor; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvNotify_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateNotifyThread, 'CreateNotifyThread', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvNotifyThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvNotifyThread) do begin
    RegisterConstructor(@TJvNotifyThread.Create, 'Create');
      RegisterMethod(@TJvNotifyThread.Destroy, 'Free');
      RegisterMethod(@TJvNotifyThread.Terminate, 'Terminate');
    RegisterPropertyHelper(@TJvNotifyThreadFinished_R,nil,'Finished');
    RegisterPropertyHelper(@TJvNotifyThreadLastError_R,nil,'LastError');
    RegisterPropertyHelper(@TJvNotifyThreadNotifyHandle_R,nil,'NotifyHandle');
    RegisterPropertyHelper(@TJvNotifyThreadOnChange_R,@TJvNotifyThreadOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvFolderMonitor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvFolderMonitor) do begin
    RegisterConstructor(@TJvFolderMonitor.Create, 'Create');
    RegisterMethod(@TJvFolderMonitor.Destroy, 'Free');
      RegisterPropertyHelper(@TJvFolderMonitorActive_R,@TJvFolderMonitorActive_W,'Active');
    RegisterPropertyHelper(@TJvFolderMonitorDelayTime_R,@TJvFolderMonitorDelayTime_W,'DelayTime');
    RegisterPropertyHelper(@TJvFolderMonitorFilter_R,@TJvFolderMonitorFilter_W,'Filter');
    RegisterPropertyHelper(@TJvFolderMonitorFolderName_R,@TJvFolderMonitorFolderName_W,'FolderName');
    RegisterPropertyHelper(@TJvFolderMonitorMonitorSubtree_R,@TJvFolderMonitorMonitorSubtree_W,'MonitorSubtree');
    RegisterPropertyHelper(@TJvFolderMonitorOnChange_R,@TJvFolderMonitorOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvNotify(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvNotifyThread) do
  RIRegister_TJvFolderMonitor(CL);
  RIRegister_TJvNotifyThread(CL);
end;

 
 
{ TPSImport_JvNotify }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvNotify.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvNotify(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvNotify.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvNotify(ri);
  RIRegister_JvNotify_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
