unit uPSI_IPCThrd;
{
   bitbattle     Tmutex--> tamutex
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
  TPSImport_IPCThrd = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIPCClient(CL: TPSPascalCompiler);
procedure SIRegister_TIPCMonitor(CL: TPSPascalCompiler);
procedure SIRegister_TIPCThread(CL: TPSPascalCompiler);
procedure SIRegister_TClientDirectory(CL: TPSPascalCompiler);
procedure SIRegister_TIPCEvent(CL: TPSPascalCompiler);
procedure SIRegister_TIPCTracer(CL: TPSPascalCompiler);
procedure SIRegister_TSharedMem(CL: TPSPascalCompiler);
procedure SIRegister_TMutex(CL: TPSPascalCompiler);
procedure SIRegister_TEvent(CL: TPSPascalCompiler);
procedure SIRegister_THandledObject(CL: TPSPascalCompiler);
procedure SIRegister_IPCThrd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IPCThrd_Routines(S: TPSExec);
procedure RIRegister_TIPCClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIPCMonitor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIPCThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TClientDirectory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIPCEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIPCTracer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSharedMem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMutex(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_THandledObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_IPCThrd(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,IPCThrd
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IPCThrd]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIPCClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIPCThread', 'TIPCClient') do
  with CL.AddClassN(CL.FindClass('TIPCThread'),'TIPCClient') do begin
    RegisterMethod('Function ClientCount : Integer');
    RegisterMethod('Procedure SignalMonitor( Data : TEventData)');
    RegisterMethod('Procedure MakeCurrent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIPCMonitor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIPCThread', 'TIPCMonitor') do
  with CL.AddClassN(CL.FindClass('TIPCThread'),'TIPCMonitor') do begin
    RegisterMethod('Constructor Create( AID : Integer; const AName : string)');
    RegisterMethod('Procedure SignalClient( const Value : TClientFlags)');
    RegisterMethod('Procedure GetClientNames( List : TStrings)');
    RegisterMethod('Procedure GetDebugInfo( List : TStrings)');
    RegisterMethod('Procedure SaveDebugInfo( const FileName : string)');
    RegisterMethod('Procedure ClearDebugInfo');
    RegisterProperty('AutoSwitch', 'Boolean', iptrw);
    RegisterProperty('ClientName', 'string', iptr);
    RegisterProperty('ClientID', 'Integer', iptrw);
    RegisterProperty('OnDirectoryUpdate', 'TDirUpdateEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIPCThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TIPCThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TIPCThread') do begin
    RegisterMethod('Constructor Create( AID : Integer; const AName : string)');
    RegisterMethod('Procedure Activate');
    RegisterMethod('Procedure DeActivate');
    RegisterMethod('Procedure DbgStr( const S : string)');
    RegisterProperty('State', 'TState', iptr);
    RegisterProperty('OnConnect', 'TConnectEvent', iptrw);
    RegisterProperty('OnSignal', 'TIPCNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TClientDirectory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TClientDirectory') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TClientDirectory') do begin
    RegisterMethod('Constructor Create( MaxClients : Integer)');
    RegisterMethod('Function AddClient( ClientID : Integer; const AName : string) : Integer');
    RegisterMethod('Function Last : Integer');
    RegisterMethod('Function RemoveClient( ClientID : Integer) : Boolean');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('ClientRec', 'TClientDirEntry Integer', iptr);
    RegisterProperty('MonitorID', 'Integer', iptrw);
    RegisterProperty('Name', 'string Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIPCEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEvent', 'TIPCEvent') do
  with CL.AddClassN(CL.FindClass('TAEvent'),'TIPCEvent') do begin
    RegisterMethod('Constructor Create( AOwner : TIPCThread; const Name : string; Manual : Boolean)');
    RegisterMethod('Procedure Signal( Kind : TEventKind)');
    RegisterMethod('Procedure SignalID( Kind : TEventKind; ID : Integer)');
    RegisterMethod('Procedure SignalData( Kind : TEventKind; ID : Integer; Data : TEventData)');
    RegisterMethod('Function WaitFor( TimeOut, ID : Integer; Kind : TEventKind) : Boolean');
    RegisterProperty('ID', 'Integer', iptrw);
    RegisterProperty('Kind', 'TEventKind', iptrw);
    RegisterProperty('Data', 'TEventData', iptrw);
    RegisterProperty('OwnerID', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIPCTracer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIPCTracer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIPCTracer') do begin
    RegisterMethod('Constructor Create( ID : string)');
    RegisterMethod('Procedure Add( AMsg : PChar)');
    RegisterMethod('Procedure GetList( List : TStrings)');
    RegisterMethod('Procedure Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSharedMem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THandledObject', 'TSharedMem') do
  with CL.AddClassN(CL.FindClass('THandledObject'),'TSharedMem') do begin
    RegisterMethod('Constructor Create( const Name : string; Size : Integer)');
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('Size', 'Integer', iptr);
    RegisterProperty('Buffer', 'Pointer', iptr);
    RegisterProperty('Created', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMutex(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THandledObject', 'TMutex') do
  with CL.AddClassN(CL.FindClass('THandledObject'),'TAMutex') do begin
    RegisterMethod('Constructor Create( const Name : string)');
    RegisterMethod('Function Get( TimeOut : Integer) : Boolean');
    RegisterMethod('Function Release : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THandledObject', 'TEvent') do
  with CL.AddClassN(CL.FindClass('THandledObject'),'TAEvent') do begin
    RegisterMethod('Constructor Create( const Name : string; Manual : Boolean)');
    RegisterMethod('Procedure Signal');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Function Wait( TimeOut : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THandledObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'THandledObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'THandledObject') do begin
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterMethod('Procedure Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IPCThrd(CL: TPSPascalCompiler);
begin
  SIRegister_THandledObject(CL);
  SIRegister_TEvent(CL);
  SIRegister_TMutex(CL);
  SIRegister_TSharedMem(CL);
 CL.AddConstantN('TRACE_BUF_SIZE','LongInt').SetInt( 200 * 1024);
 CL.AddConstantN('TRACE_BUFFER','String').SetString( 'TRACE_BUFFER');
 CL.AddConstantN('TRACE_MUTEX','String').SetString( 'TRACE_MUTEX');
  //CL.AddTypeS('PTraceEntry', '^TTraceEntry // will not work');
  SIRegister_TIPCTracer(CL);
 CL.AddConstantN('MAX_CLIENTS','LongInt').SetInt( 6);
 CL.AddConstantN('IPCTIMEOUT','LongInt').SetInt( 2000);
 CL.AddConstantN('IPCBUFFER_NAME','String').SetString( 'BUFFER_NAME');
 CL.AddConstantN('BUFFER_MUTEX_NAME','String').SetString( 'BUFFER_MUTEX');
 CL.AddConstantN('MONITOR_EVENT_NAME','String').SetString( 'MONITOR_EVENT');
 CL.AddConstantN('CLIENT_EVENT_NAME','String').SetString( 'CLIENT_EVENT');
 CL.AddConstantN('CONNECT_EVENT_NAME','String').SetString( 'CONNECT_EVENT');
 CL.AddConstantN('CLIENT_DIR_NAME','String').SetString( 'CLIENT_DIRECTORY');
 CL.AddConstantN('CLIENT_DIR_MUTEX','String').SetString( 'DIRECTORY_MUTEX');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMonitorActive');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIPCThread');
  CL.AddTypeS('TEventKind', '( evMonitorAttach, evMonitorDetach, evMonitorSigna'
   +'l, evMonitorExit, evClientStart, evClientStop, evClientAttach, evClientDet'
   +'ach, evClientSwitch, evClientSignal, evClientExit )');
  CL.AddTypeS('TClientFlag', '( cfError, cfMouseMove, cfMouseDown, cfResize, cfAttach )');
  CL.AddTypeS('TClientFlags', 'set of TClientFlag');
  //CL.AddTypeS('PEventData', '^TEventData // will not work');
  CL.AddTypeS('TEventData', 'record X : SmallInt; Y : SmallInt; Flag : TClientF'
   +'lag; Flags : TClientFlags; end');
  CL.AddTypeS('TConnectEvent', 'Procedure ( Sender : TIPCThread; Connecting : Boolean)');
  CL.AddTypeS('TDirUpdateEvent', 'Procedure ( Sender : TIPCThread)');
  CL.AddTypeS('TIPCNotifyEvent', 'Procedure ( Sender : TIPCThread; Data : TEventData)');
  //CL.AddTypeS('PIPCEventInfo', '^TIPCEventInfo // will not work');
  CL.AddTypeS('TIPCEventInfo', 'record FID : Integer; FKind : TEventKind; FData: TEventData; end');
  SIRegister_TIPCEvent(CL);
  //CL.AddTypeS('PClientDirRecords', '^TClientDirRecords // will not work');
  SIRegister_TClientDirectory(CL);
  CL.AddTypeS('TIPCState', '( stInActive, stDisconnected, stConnected )');
  SIRegister_TIPCThread(CL);
  SIRegister_TIPCMonitor(CL);
  SIRegister_TIPCClient(CL);
 CL.AddDelphiFunction('Function IsMonitorRunning( var Hndl : THandle) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIPCMonitorOnDirectoryUpdate_W(Self: TIPCMonitor; const T: TDirUpdateEvent);
begin Self.OnDirectoryUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPCMonitorOnDirectoryUpdate_R(Self: TIPCMonitor; var T: TDirUpdateEvent);
begin T := Self.OnDirectoryUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TIPCMonitorClientID_W(Self: TIPCMonitor; const T: Integer);
begin Self.ClientID := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPCMonitorClientID_R(Self: TIPCMonitor; var T: Integer);
begin T := Self.ClientID; end;

(*----------------------------------------------------------------------------*)
procedure TIPCMonitorClientName_R(Self: TIPCMonitor; var T: string);
begin T := Self.ClientName; end;

(*----------------------------------------------------------------------------*)
procedure TIPCMonitorAutoSwitch_W(Self: TIPCMonitor; const T: Boolean);
begin Self.AutoSwitch := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPCMonitorAutoSwitch_R(Self: TIPCMonitor; var T: Boolean);
begin T := Self.AutoSwitch; end;

(*----------------------------------------------------------------------------*)
procedure TIPCThreadOnSignal_W(Self: TIPCThread; const T: TIPCNotifyEvent);
begin Self.OnSignal := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPCThreadOnSignal_R(Self: TIPCThread; var T: TIPCNotifyEvent);
begin T := Self.OnSignal; end;

(*----------------------------------------------------------------------------*)
procedure TIPCThreadOnConnect_W(Self: TIPCThread; const T: TConnectEvent);
begin Self.OnConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPCThreadOnConnect_R(Self: TIPCThread; var T: TConnectEvent);
begin T := Self.OnConnect; end;

(*----------------------------------------------------------------------------*)
procedure TIPCThreadState_R(Self: TIPCThread; var T: TState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TClientDirectoryName_R(Self: TClientDirectory; var T: string; const t1: Integer);
begin T := Self.Name[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TClientDirectoryMonitorID_W(Self: TClientDirectory; const T: Integer);
begin Self.MonitorID := T; end;

(*----------------------------------------------------------------------------*)
procedure TClientDirectoryMonitorID_R(Self: TClientDirectory; var T: Integer);
begin T := Self.MonitorID; end;

(*----------------------------------------------------------------------------*)
procedure TClientDirectoryClientRec_R(Self: TClientDirectory; var T: TClientDirEntry; const t1: Integer);
begin T := Self.ClientRec[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TClientDirectoryCount_R(Self: TClientDirectory; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TIPCEventOwnerID_W(Self: TIPCEvent; const T: Integer);
begin Self.OwnerID := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPCEventOwnerID_R(Self: TIPCEvent; var T: Integer);
begin T := Self.OwnerID; end;

(*----------------------------------------------------------------------------*)
procedure TIPCEventData_W(Self: TIPCEvent; const T: TEventData);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPCEventData_R(Self: TIPCEvent; var T: TEventData);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TIPCEventKind_W(Self: TIPCEvent; const T: TEventKind);
begin Self.Kind := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPCEventKind_R(Self: TIPCEvent; var T: TEventKind);
begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TIPCEventID_W(Self: TIPCEvent; const T: Integer);
begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPCEventID_R(Self: TIPCEvent; var T: Integer);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TSharedMemCreated_R(Self: TSharedMem; var T: Boolean);
begin T := Self.Created; end;

(*----------------------------------------------------------------------------*)
procedure TSharedMemBuffer_R(Self: TSharedMem; var T: Pointer);
begin T := Self.Buffer; end;

(*----------------------------------------------------------------------------*)
procedure TSharedMemSize_R(Self: TSharedMem; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TSharedMemName_R(Self: TSharedMem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure THandledObjectHandle_R(Self: THandledObject; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IPCThrd_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsMonitorRunning, 'IsMonitorRunning', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIPCClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIPCClient) do begin
    RegisterMethod(@TIPCClient.ClientCount, 'ClientCount');
    RegisterMethod(@TIPCClient.SignalMonitor, 'SignalMonitor');
    RegisterMethod(@TIPCClient.MakeCurrent, 'MakeCurrent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIPCMonitor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIPCMonitor) do begin
    RegisterConstructor(@TIPCMonitor.Create, 'Create');
    RegisterMethod(@TIPCMonitor.SignalClient, 'SignalClient');
    RegisterMethod(@TIPCMonitor.GetClientNames, 'GetClientNames');
    RegisterMethod(@TIPCMonitor.GetDebugInfo, 'GetDebugInfo');
    RegisterMethod(@TIPCMonitor.SaveDebugInfo, 'SaveDebugInfo');
    RegisterMethod(@TIPCMonitor.ClearDebugInfo, 'ClearDebugInfo');
    RegisterPropertyHelper(@TIPCMonitorAutoSwitch_R,@TIPCMonitorAutoSwitch_W,'AutoSwitch');
    RegisterPropertyHelper(@TIPCMonitorClientName_R,nil,'ClientName');
    RegisterPropertyHelper(@TIPCMonitorClientID_R,@TIPCMonitorClientID_W,'ClientID');
    RegisterPropertyHelper(@TIPCMonitorOnDirectoryUpdate_R,@TIPCMonitorOnDirectoryUpdate_W,'OnDirectoryUpdate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIPCThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIPCThread) do begin
    RegisterConstructor(@TIPCThread.Create, 'Create');
    //RegisterVirtualAbstractMethod(@TIPCThread, @!.Activate, 'Activate');
    //RegisterVirtualAbstractMethod(@TIPCThread, @!.DeActivate, 'DeActivate');
    RegisterMethod(@TIPCThread.DbgStr, 'DbgStr');
    RegisterPropertyHelper(@TIPCThreadState_R,nil,'State');
    RegisterPropertyHelper(@TIPCThreadOnConnect_R,@TIPCThreadOnConnect_W,'OnConnect');
    RegisterPropertyHelper(@TIPCThreadOnSignal_R,@TIPCThreadOnSignal_W,'OnSignal');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TClientDirectory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TClientDirectory) do begin
    RegisterConstructor(@TClientDirectory.Create, 'Create');
    RegisterMethod(@TClientDirectory.AddClient, 'AddClient');
    RegisterMethod(@TClientDirectory.Last, 'Last');
    RegisterMethod(@TClientDirectory.RemoveClient, 'RemoveClient');
    RegisterPropertyHelper(@TClientDirectoryCount_R,nil,'Count');
    RegisterPropertyHelper(@TClientDirectoryClientRec_R,nil,'ClientRec');
    RegisterPropertyHelper(@TClientDirectoryMonitorID_R,@TClientDirectoryMonitorID_W,'MonitorID');
    RegisterPropertyHelper(@TClientDirectoryName_R,nil,'Name');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIPCEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIPCEvent) do begin
    RegisterConstructor(@TIPCEvent.Create, 'Create');
    RegisterMethod(@TIPCEvent.Signal, 'Signal');
    RegisterMethod(@TIPCEvent.SignalID, 'SignalID');
    RegisterMethod(@TIPCEvent.SignalData, 'SignalData');
    RegisterMethod(@TIPCEvent.WaitFor, 'WaitFor');
    RegisterPropertyHelper(@TIPCEventID_R,@TIPCEventID_W,'ID');
    RegisterPropertyHelper(@TIPCEventKind_R,@TIPCEventKind_W,'Kind');
    RegisterPropertyHelper(@TIPCEventData_R,@TIPCEventData_W,'Data');
    RegisterPropertyHelper(@TIPCEventOwnerID_R,@TIPCEventOwnerID_W,'OwnerID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIPCTracer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIPCTracer) do begin
    RegisterConstructor(@TIPCTracer.Create, 'Create');
    RegisterMethod(@TIPCTracer.Add, 'Add');
    RegisterMethod(@TIPCTracer.GetList, 'GetList');
    RegisterMethod(@TIPCTracer.Clear, 'Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSharedMem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSharedMem) do begin
    RegisterConstructor(@TSharedMem.Create, 'Create');
    RegisterPropertyHelper(@TSharedMemName_R,nil,'Name');
    RegisterPropertyHelper(@TSharedMemSize_R,nil,'Size');
    RegisterPropertyHelper(@TSharedMemBuffer_R,nil,'Buffer');
    RegisterPropertyHelper(@TSharedMemCreated_R,nil,'Created');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMutex(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAMutex) do begin
    RegisterConstructor(@TAMutex.Create, 'Create');
    RegisterMethod(@TAMutex.Get, 'Get');
    RegisterMethod(@TAMutex.Release, 'Release');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAEvent) do begin
    RegisterConstructor(@TAEvent.Create, 'Create');
    RegisterMethod(@TAEvent.Signal, 'Signal');
    RegisterMethod(@TAEvent.Reset, 'Reset');
    RegisterMethod(@TAEvent.Wait, 'Wait');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THandledObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THandledObject) do begin
    RegisterPropertyHelper(@THandledObjectHandle_R,nil,'Handle');
    RegisterMethod(@THandledObject.Destroy,'Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IPCThrd(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THandledObject(CL);
  RIRegister_TEvent(CL);
  RIRegister_TMutex(CL);
  RIRegister_TSharedMem(CL);
  RIRegister_TIPCTracer(CL);
  with CL.Add(EMonitorActive) do
  with CL.Add(TIPCThread) do
  RIRegister_TIPCEvent(CL);
  RIRegister_TClientDirectory(CL);
  RIRegister_TIPCThread(CL);
  RIRegister_TIPCMonitor(CL);
  RIRegister_TIPCClient(CL);
end;

 
 
{ TPSImport_IPCThrd }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IPCThrd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IPCThrd(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IPCThrd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IPCThrd(ri);
  RIRegister_IPCThrd_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
