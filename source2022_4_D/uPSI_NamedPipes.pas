unit uPSI_NamedPipes;
{
   com com  and proc info
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
  TPSImport_NamedPipes = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TClientPipe(CL: TPSPascalCompiler);
procedure SIRegister_TServerPipe(CL: TPSPascalCompiler);
procedure SIRegister_TNamedPipe(CL: TPSPascalCompiler);
procedure SIRegister_NamedPipes(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_NamedPipes_Routines(S: TPSExec);
procedure RIRegister_TClientPipe(CL: TPSRuntimeClassImporter);
procedure RIRegister_TServerPipe(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNamedPipe(CL: TPSRuntimeClassImporter);
procedure RIRegister_NamedPipes(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Math
  ,SyncObjs
  ,NamedPipes
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_NamedPipes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TClientPipe(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNamedPipe', 'TClientPipe') do
  with CL.AddClassN(CL.FindClass('TNamedPipe'),'TClientPipe') do begin
    RegisterMethod('Constructor Create( const aName : string; const aServer : string)');
    RegisterMethod('Function Open( evAbort : TEvent) : Boolean');
    RegisterMethod('Function Transact( const aInput : string; var aOutput : string; evAbort : TEvent) : Boolean;');
    RegisterMethod('Function Transact1( aInput, aOutput : TStream; evAbort : TEvent) : Boolean;');
    RegisterProperty('ReadMessages', 'Boolean', iptrw);
    RegisterProperty('Timeout', 'DWORD', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TServerPipe(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNamedPipe', 'TServerPipe') do
  with CL.AddClassN(CL.FindClass('TNamedPipe'),'TServerPipe') do begin
    RegisterMethod('Constructor Create( const aName : string; aDir : TPipeDirection)');
        RegisterMethod('Procedure Free');
     RegisterMethod('Function Open : Boolean');
    RegisterMethod('Procedure DisconnectClient');
    RegisterMethod('Function WaitForClientConnect : Boolean');
    RegisterMethod('Function ReadInputData( aStream : TStream) : Boolean');
    RegisterMethod('Function WriteOutputData( aStream : TStream) : Boolean');
    RegisterProperty('Direction', 'TPipeDirection', iptrw);
    RegisterProperty('PipeType', 'TPipeType', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNamedPipe(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TNamedPipe') do
  with CL.AddClassN(CL.FindClass('TObject'),'TNamedPipe') do begin
    RegisterMethod('Constructor Create( const aName : string)');
          RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Close');
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterMethod('Function CancelIO : Boolean');
    RegisterMethod('Function IsIoComplete( var dwBytesDone : DWORD) : Boolean');
    RegisterProperty('WriteThrough', 'Boolean', iptrw);
    RegisterProperty('Overlapped', 'Boolean', iptrw);
    RegisterProperty('Event', 'TEvent', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_NamedPipes(CL: TPSPascalCompiler);
begin

 CL.AddConstantN('DEFAULT_PIPE_BUFFER_SIZE','LongInt').SetInt( 4096);
 CL.AddConstantN('DEFAULT_PIPE_TIMEOUT','LongInt').SetInt( 5000);
 CL.AddConstantN('PIPE_NAMING_SCHEME','String').SetString( '\\%s\pipe\%s');
 CL.AddConstantN('WAIT_ERROR','LongWord').SetUInt( DWORD ( $FFFFFFFF ));
 CL.AddConstantN('WAIT_OBJECT_1','LongInt').SetInt( WAIT_OBJECT_0 + 1);
 CL.AddConstantN('STATUS_SUCCESS','LongWord').SetUInt( $00000000);
 CL.AddConstantN('STATUS_BUFFER_OVERFLOW','LongWord').SetUInt( $80000005);
  CL.AddTypeS('TPipeDirection', '( pdir_Duplex, pdir_ClientToServer, pdir_ServerToClient )');
  CL.AddTypeS('TPipeType', '( ptyp_ByteByte, ptyp_MsgByte, ptyp_MsgMsg )');
  CL.AddTypeS('TOverlappedResult', '( ov_Failed, ov_Pending, ov_MoreData, ov_Complete )');
 CL.AddTypeS('_OVERLAPPED', 'record Internal : DWORD; InternalHigh : DWORD; Of'
   +'fset : DWORD; OffsetHigh : DWORD; hEvent : THandle; end');
  CL.AddTypeS('TOverlapped', '_OVERLAPPED');
  CL.AddTypeS('OVERLAPPED', '_OVERLAPPED');
  CL.AddTypeS('_PROCESS_INFORMATION', 'record hProcess : THandle; hThread : THa'
   +'ndle; dwProcessId : DWORD; dwThreadId : DWORD; end');
  CL.AddTypeS('TProcessInformation', '_PROCESS_INFORMATION');
  CL.AddTypeS('PROCESS_INFORMATION', '_PROCESS_INFORMATION');

  SIRegister_TNamedPipe(CL);
  SIRegister_TServerPipe(CL);
  SIRegister_TClientPipe(CL);
 CL.AddDelphiFunction('Function CalculateTimeout( aBasis : DWORD) : DWORD');
 CL.AddDelphiFunction('Function HasOverlappedIoCompleted( const ov : OVERLAPPED) : Boolean');
 CL.AddDelphiFunction('Function GetOverlappedPipeResult( aHandle : THandle; const ov : OVERLAPPED; var dwBytes : DWORD; bWait : Boolean) : TOverlappedResult');
 CL.AddDelphiFunction('Function GetStreamAsText( stm : TStream) : string');
 CL.AddDelphiFunction('Procedure SetStreamAsText( const aTxt : string; stm : TStream)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TClientPipeTimeout_W(Self: TClientPipe; const T: DWORD);
begin Self.Timeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TClientPipeTimeout_R(Self: TClientPipe; var T: DWORD);
begin T := Self.Timeout; end;

(*----------------------------------------------------------------------------*)
procedure TClientPipeReadMessages_W(Self: TClientPipe; const T: Boolean);
begin Self.ReadMessages := T; end;

(*----------------------------------------------------------------------------*)
procedure TClientPipeReadMessages_R(Self: TClientPipe; var T: Boolean);
begin T := Self.ReadMessages; end;

(*----------------------------------------------------------------------------*)
Function TClientPipeTransact1_P(Self: TClientPipe;  aInput, aOutput : TStream; evAbort : TEvent) : Boolean;
Begin Result := Self.Transact(aInput, aOutput, evAbort); END;

(*----------------------------------------------------------------------------*)
Function TClientPipeTransact_P(Self: TClientPipe;  const aInput : string; var aOutput : string; evAbort : TEvent) : Boolean;
Begin Result := Self.Transact(aInput, aOutput, evAbort); END;

(*----------------------------------------------------------------------------*)
procedure TServerPipePipeType_W(Self: TServerPipe; const T: TPipeType);
begin Self.PipeType := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerPipePipeType_R(Self: TServerPipe; var T: TPipeType);
begin T := Self.PipeType; end;

(*----------------------------------------------------------------------------*)
procedure TServerPipeDirection_W(Self: TServerPipe; const T: TPipeDirection);
begin Self.Direction := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerPipeDirection_R(Self: TServerPipe; var T: TPipeDirection);
begin T := Self.Direction; end;

(*----------------------------------------------------------------------------*)
procedure TNamedPipeEvent_R(Self: TNamedPipe; var T: TEvent);
begin T := Self.Event; end;

(*----------------------------------------------------------------------------*)
procedure TNamedPipeOverlapped_W(Self: TNamedPipe; const T: Boolean);
begin Self.Overlapped := T; end;

(*----------------------------------------------------------------------------*)
procedure TNamedPipeOverlapped_R(Self: TNamedPipe; var T: Boolean);
begin T := Self.Overlapped; end;

(*----------------------------------------------------------------------------*)
procedure TNamedPipeWriteThrough_W(Self: TNamedPipe; const T: Boolean);
begin Self.WriteThrough := T; end;

(*----------------------------------------------------------------------------*)
procedure TNamedPipeWriteThrough_R(Self: TNamedPipe; var T: Boolean);
begin T := Self.WriteThrough; end;

(*----------------------------------------------------------------------------*)
procedure TNamedPipeHandle_R(Self: TNamedPipe; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NamedPipes_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CalculateTimeout, 'CalculateTimeout', cdRegister);
 S.RegisterDelphiFunction(@HasOverlappedIoCompleted, 'HasOverlappedIoCompleted', cdRegister);
 S.RegisterDelphiFunction(@GetOverlappedPipeResult, 'GetOverlappedPipeResult', cdRegister);
 S.RegisterDelphiFunction(@GetStreamAsText, 'GetStreamAsText', cdRegister);
 S.RegisterDelphiFunction(@SetStreamAsText, 'SetStreamAsText', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TClientPipe(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TClientPipe) do begin
    RegisterConstructor(@TClientPipe.Create, 'Create');

    RegisterMethod(@TClientPipe.Open, 'Open');
    RegisterMethod(@TClientPipeTransact_P, 'Transact');
    RegisterMethod(@TClientPipeTransact1_P, 'Transact1');
    RegisterPropertyHelper(@TClientPipeReadMessages_R,@TClientPipeReadMessages_W,'ReadMessages');
    RegisterPropertyHelper(@TClientPipeTimeout_R,@TClientPipeTimeout_W,'Timeout');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServerPipe(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServerPipe) do begin
    RegisterConstructor(@TServerPipe.Create, 'Create');
    RegisterMethod(@TServerPipe.Destroy, 'Free');
    RegisterMethod(@TServerPipe.Open, 'Open');
    RegisterMethod(@TServerPipe.DisconnectClient, 'DisconnectClient');
    RegisterMethod(@TServerPipe.WaitForClientConnect, 'WaitForClientConnect');
    RegisterMethod(@TServerPipe.ReadInputData, 'ReadInputData');
    RegisterMethod(@TServerPipe.WriteOutputData, 'WriteOutputData');
    RegisterPropertyHelper(@TServerPipeDirection_R,@TServerPipeDirection_W,'Direction');
    RegisterPropertyHelper(@TServerPipePipeType_R,@TServerPipePipeType_W,'PipeType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNamedPipe(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNamedPipe) do begin
    RegisterConstructor(@TNamedPipe.Create, 'Create');
    RegisterMethod(@TNamedPipe.Destroy, 'Free');
    RegisterMethod(@TNamedPipe.Close, 'Close');
    RegisterPropertyHelper(@TNamedPipeHandle_R,nil,'Handle');
    RegisterMethod(@TNamedPipe.CancelIO, 'CancelIO');
    RegisterMethod(@TNamedPipe.IsIoComplete, 'IsIoComplete');
    RegisterPropertyHelper(@TNamedPipeWriteThrough_R,@TNamedPipeWriteThrough_W,'WriteThrough');
    RegisterPropertyHelper(@TNamedPipeOverlapped_R,@TNamedPipeOverlapped_W,'Overlapped');
    RegisterPropertyHelper(@TNamedPipeEvent_R,nil,'Event');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NamedPipes(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNamedPipe(CL);
  RIRegister_TServerPipe(CL);
  RIRegister_TClientPipe(CL);
end;

 
 
{ TPSImport_NamedPipes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_NamedPipes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_NamedPipes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_NamedPipes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_NamedPipes(ri);
  RIRegister_NamedPipes_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
