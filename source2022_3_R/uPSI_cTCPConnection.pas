unit uPSI_cTCPConnection;
{
Tanother direct connection

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
  TPSImport_cTCPConnection = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTCPConnection(CL: TPSPascalCompiler);
procedure SIRegister_TTCPConnectionProxyList(CL: TPSPascalCompiler);
procedure SIRegister_TTCPConnectionProxy(CL: TPSPascalCompiler);
procedure SIRegister_cTCPConnection(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cTCPConnection_Routines(S: TPSExec);
procedure RIRegister_TTCPConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTCPConnectionProxyList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTCPConnectionProxy(CL: TPSRuntimeClassImporter);
procedure RIRegister_cTCPConnection(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,SyncObjs
  //,cSocket
  ,cTCPBuffer
  //,cTCPConnection
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cTCPConnection]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTCPConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTCPConnection') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTCPConnection') do begin
    RegisterMethod('Constructor Create( const Socket : TSysSocket)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Socket', 'TSysSocket', iptr);
    RegisterProperty('OnLog', 'TTCPConnectionLogEvent', iptrw);
    RegisterProperty('OnStateChange', 'TTCPConnectionStateChangeEvent', iptrw);
    RegisterProperty('OnRead', 'TTCPConnectionNotifyEvent', iptrw);
    RegisterProperty('OnWrite', 'TTCPConnectionNotifyEvent', iptrw);
    RegisterProperty('OnClose', 'TTCPConnectionNotifyEvent', iptrw);
    RegisterProperty('OnReadBufferFull', 'TTCPConnectionNotifyEvent', iptrw);
    RegisterProperty('OnWriteBufferEmpty', 'TTCPConnectionNotifyEvent', iptrw);
    RegisterMethod('Procedure AddProxy( const Proxy : TTCPConnectionProxy)');
    RegisterProperty('State', 'TTCPConnectionState', iptr);
    RegisterProperty('StateStr', 'AnsiString', iptr);
    RegisterMethod('Procedure Start');
    RegisterProperty('ReadBufferMaxSize', 'Integer', iptrw);
    RegisterProperty('WriteBufferMaxSize', 'Integer', iptrw);
    RegisterProperty('ReadThrottle', 'Boolean', iptrw);
    RegisterProperty('ReadThrottleRate', 'Integer', iptrw);
    RegisterProperty('WriteThrottle', 'Boolean', iptrw);
    RegisterProperty('WriteThrottleRate', 'Integer', iptrw);
    RegisterProperty('ReadRate', 'Integer', iptr);
    RegisterProperty('WriteRate', 'Integer', iptr);
    RegisterProperty('ReadBufferSize', 'Integer', iptr);
    RegisterProperty('WriteBufferSize', 'Integer', iptr);
    RegisterMethod('Procedure PollSocket( var Idle, Terminated : Boolean)');
    RegisterMethod('Function Read( var Buf : string; const BufSize : Integer) : Integer');
    RegisterMethod('Function ReadStr( const StrLen : Integer) : AnsiString');
    RegisterMethod('Function Discard( const Size : Integer) : Integer');
    RegisterMethod('Function Peek( var Buf : string; const BufSize : Integer) : Integer');
    RegisterMethod('Function PeekStr( const StrLen : Integer) : AnsiString');
    RegisterMethod('Function PeekDelimited( var Buf : string; const BufSize : Integer; const Delimiter : AnsiString; const MaxSize : Integer) : Integer;');
    RegisterMethod('Function PeekDelimited1( var Buf : string; const BufSize : Integer; const Delimiter : TAnsiCharSet; const MaxSize : Integer) : Integer;');
    RegisterMethod('Function ReadLine( var Line : AnsiString; const Delimiter : AnsiString; const MaxLineLength : Integer) : Boolean');
    RegisterMethod('Function Write( const Buf : string; const BufSize : Integer) : Integer');
    RegisterMethod('Function WriteAnsiStr( const Str : AnsiString) : Integer');
    RegisterMethod('Function WriteWideStr( const Str : WideString) : Integer');
    RegisterMethod('Function WriteStr( const Str : String) : Integer');
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure Shutdown');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTCPConnectionProxyList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTCPConnectionProxyList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTCPConnectionProxyList') do begin
    RegisterMethod('Procedure Free');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Item', 'TTCPConnectionProxy Integer', iptr);
    SetDefaultPropery('Item');
    RegisterMethod('Procedure Add( const Proxy : TTCPConnectionProxy)');
    RegisterProperty('LastItem', 'TTCPConnectionProxy', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTCPConnectionProxy(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTCPConnectionProxy') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTCPConnectionProxy') do begin
    RegisterMethod('Function ProxyName : String');
    RegisterMethod('Constructor Create( const Connection : TTCPConnection)');
    RegisterProperty('State', 'TTCPConnectionProxyState', iptr);
    RegisterProperty('StateStr', 'AnsiString', iptr);
    RegisterMethod('Procedure Start');
    RegisterMethod('Procedure ProcessReadData( const Buf : string; const BufSize : Integer)');
    RegisterMethod('Procedure ProcessWriteData( const Buf : string; const BufSize : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cTCPConnection(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'ETCPConnection');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTCPConnection');
  CL.AddTypeS('TTCPLogType', '( tlDebug, tlInfo, tlError )');
  CL.AddTypeS('TTCPConnectionProxyState', '( prsInit, prsNegotiating, prsFiltering, prsFinished, prsError, prsClosed )');
  SIRegister_TTCPConnectionProxy(CL);
  SIRegister_TTCPConnectionProxyList(CL);
  CL.AddTypeS('TTCPConnectionState', '( cnsInit, cnsProxyNegotiation, cnsConnected, cnsClosed )');
  CL.AddTypeS('TTCPConnectionTransferState', 'record LastUpdate : LongWord; Byt'
   +'eCount : Int64; TransferRate : LongWord; end');
  CL.AddTypeS('TAnsiCharSet', 'set of AnsiChar');
  CL.AddTypeS('TTCPConnectionNotifyEvent', 'Procedure ( Sender : TTCPConnection)');
  CL.AddTypeS('TTCPConnectionStateChangeEvent', 'Procedure ( Sender : TTCPConne'
   +'ction; State : TTCPConnectionState)');
  CL.AddTypeS('TTCPConnectionLogEvent', 'Procedure ( Sender : TTCPConnection; L'
   +'ogType : TTCPLogType; LogMsg : String; LogLevel : Integer)');
  SIRegister_TTCPConnection(CL);
  //CL.AddTypeS('TTCPConnectionClass', 'class of TTCPConnection');
 CL.AddDelphiFunction('Function TCPGetTick : LongWord');
 CL.AddDelphiFunction('Function TCPTickDelta( const D1, D2 : LongWord) : Integer');
 CL.AddDelphiFunction('Function TCPTickDeltaW( const D1, D2 : LongWord) : LongWord');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TTCPConnectionPeekDelimited1_P(Self: TTCPConnection;  var Buf : string; const BufSize : Integer; const Delimiter : TAnsiCharSet; const MaxSize : Integer) : Integer;
Begin Result := Self.PeekDelimited(Buf, BufSize, Delimiter, MaxSize); END;

(*----------------------------------------------------------------------------*)
Function TTCPConnectionPeekDelimited_P(Self: TTCPConnection;  var Buf : string; const BufSize : Integer; const Delimiter : AnsiString; const MaxSize : Integer) : Integer;
Begin Result := Self.PeekDelimited(Buf, BufSize, Delimiter, MaxSize); END;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionWriteBufferSize_R(Self: TTCPConnection; var T: Integer);
begin T := Self.WriteBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionReadBufferSize_R(Self: TTCPConnection; var T: Integer);
begin T := Self.ReadBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionWriteRate_R(Self: TTCPConnection; var T: Integer);
begin T := Self.WriteRate; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionReadRate_R(Self: TTCPConnection; var T: Integer);
begin T := Self.ReadRate; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionWriteThrottleRate_W(Self: TTCPConnection; const T: Integer);
begin Self.WriteThrottleRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionWriteThrottleRate_R(Self: TTCPConnection; var T: Integer);
begin T := Self.WriteThrottleRate; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionWriteThrottle_W(Self: TTCPConnection; const T: Boolean);
begin Self.WriteThrottle := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionWriteThrottle_R(Self: TTCPConnection; var T: Boolean);
begin T := Self.WriteThrottle; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionReadThrottleRate_W(Self: TTCPConnection; const T: Integer);
begin Self.ReadThrottleRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionReadThrottleRate_R(Self: TTCPConnection; var T: Integer);
begin T := Self.ReadThrottleRate; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionReadThrottle_W(Self: TTCPConnection; const T: Boolean);
begin Self.ReadThrottle := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionReadThrottle_R(Self: TTCPConnection; var T: Boolean);
begin T := Self.ReadThrottle; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionWriteBufferMaxSize_W(Self: TTCPConnection; const T: Integer);
begin Self.WriteBufferMaxSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionWriteBufferMaxSize_R(Self: TTCPConnection; var T: Integer);
begin T := Self.WriteBufferMaxSize; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionReadBufferMaxSize_W(Self: TTCPConnection; const T: Integer);
begin Self.ReadBufferMaxSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionReadBufferMaxSize_R(Self: TTCPConnection; var T: Integer);
begin T := Self.ReadBufferMaxSize; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionStateStr_R(Self: TTCPConnection; var T: AnsiString);
begin T := Self.StateStr; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionState_R(Self: TTCPConnection; var T: TTCPConnectionState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnWriteBufferEmpty_W(Self: TTCPConnection; const T: TTCPConnectionNotifyEvent);
begin Self.OnWriteBufferEmpty := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnWriteBufferEmpty_R(Self: TTCPConnection; var T: TTCPConnectionNotifyEvent);
begin T := Self.OnWriteBufferEmpty; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnReadBufferFull_W(Self: TTCPConnection; const T: TTCPConnectionNotifyEvent);
begin Self.OnReadBufferFull := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnReadBufferFull_R(Self: TTCPConnection; var T: TTCPConnectionNotifyEvent);
begin T := Self.OnReadBufferFull; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnClose_W(Self: TTCPConnection; const T: TTCPConnectionNotifyEvent);
begin Self.OnClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnClose_R(Self: TTCPConnection; var T: TTCPConnectionNotifyEvent);
begin T := Self.OnClose; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnWrite_W(Self: TTCPConnection; const T: TTCPConnectionNotifyEvent);
begin Self.OnWrite := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnWrite_R(Self: TTCPConnection; var T: TTCPConnectionNotifyEvent);
begin T := Self.OnWrite; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnRead_W(Self: TTCPConnection; const T: TTCPConnectionNotifyEvent);
begin Self.OnRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnRead_R(Self: TTCPConnection; var T: TTCPConnectionNotifyEvent);
begin T := Self.OnRead; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnStateChange_W(Self: TTCPConnection; const T: TTCPConnectionStateChangeEvent);
begin Self.OnStateChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnStateChange_R(Self: TTCPConnection; var T: TTCPConnectionStateChangeEvent);
begin T := Self.OnStateChange; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnLog_W(Self: TTCPConnection; const T: TTCPConnectionLogEvent);
begin Self.OnLog := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionOnLog_R(Self: TTCPConnection; var T: TTCPConnectionLogEvent);
begin T := Self.OnLog; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionSocket_R(Self: TTCPConnection; var T: TSysSocket);
begin T := Self.Socket; end;

(*----------------------------------------------------------------------------*)
Procedure TTCPConnectionLog3_P(Self: TTCPConnection;  const LogType : TTCPLogType; const LogMsg : String; const LogArgs : array of const; const LogLevel : Integer);
Begin Self.Log(LogType, LogMsg, LogArgs, LogLevel); END;

(*----------------------------------------------------------------------------*)
Procedure TTCPConnectionLog2_P(Self: TTCPConnection;  const LogType : TTCPLogType; const LogMsg : String; const LogLevel : Integer);
Begin Self.Log(LogType, LogMsg, LogLevel); END;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionProxyListLastItem_R(Self: TTCPConnectionProxyList; var T: TTCPConnectionProxy);
begin T := Self.LastItem; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionProxyListItem_R(Self: TTCPConnectionProxyList; var T: TTCPConnectionProxy; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionProxyListCount_R(Self: TTCPConnectionProxyList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionProxyStateStr_R(Self: TTCPConnectionProxy; var T: AnsiString);
begin T := Self.StateStr; end;

(*----------------------------------------------------------------------------*)
procedure TTCPConnectionProxyState_R(Self: TTCPConnectionProxy; var T: TTCPConnectionProxyState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
Procedure TTCPConnectionProxyLog1_P(Self: TTCPConnectionProxy;  const LogType : TTCPLogType; const LogMsg : String; const LogArgs : array of const; const LogLevel : Integer);
Begin Self.Log(LogType, LogMsg, LogArgs, LogLevel); END;

(*----------------------------------------------------------------------------*)
Procedure TTCPConnectionProxyLog_P(Self: TTCPConnectionProxy;  const LogType : TTCPLogType; const LogMsg : String; const LogLevel : Integer);
Begin Self.Log(LogType, LogMsg, LogLevel); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cTCPConnection_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TCPGetTick, 'TCPGetTick', cdRegister);
 S.RegisterDelphiFunction(@TCPTickDelta, 'TCPTickDelta', cdRegister);
 S.RegisterDelphiFunction(@TCPTickDeltaW, 'TCPTickDeltaW', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTCPConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTCPConnection) do begin
    RegisterConstructor(@TTCPConnection.Create, 'Create');
    RegisterMethod(@TTCPConnection.Destroy, 'Free');
    RegisterPropertyHelper(@TTCPConnectionSocket_R,nil,'Socket');
    RegisterPropertyHelper(@TTCPConnectionOnLog_R,@TTCPConnectionOnLog_W,'OnLog');
    RegisterPropertyHelper(@TTCPConnectionOnStateChange_R,@TTCPConnectionOnStateChange_W,'OnStateChange');
    RegisterPropertyHelper(@TTCPConnectionOnRead_R,@TTCPConnectionOnRead_W,'OnRead');
    RegisterPropertyHelper(@TTCPConnectionOnWrite_R,@TTCPConnectionOnWrite_W,'OnWrite');
    RegisterPropertyHelper(@TTCPConnectionOnClose_R,@TTCPConnectionOnClose_W,'OnClose');
    RegisterPropertyHelper(@TTCPConnectionOnReadBufferFull_R,@TTCPConnectionOnReadBufferFull_W,'OnReadBufferFull');
    RegisterPropertyHelper(@TTCPConnectionOnWriteBufferEmpty_R,@TTCPConnectionOnWriteBufferEmpty_W,'OnWriteBufferEmpty');
    RegisterMethod(@TTCPConnection.AddProxy, 'AddProxy');
    RegisterPropertyHelper(@TTCPConnectionState_R,nil,'State');
    RegisterPropertyHelper(@TTCPConnectionStateStr_R,nil,'StateStr');
    RegisterMethod(@TTCPConnection.Start, 'Start');
    RegisterPropertyHelper(@TTCPConnectionReadBufferMaxSize_R,@TTCPConnectionReadBufferMaxSize_W,'ReadBufferMaxSize');
    RegisterPropertyHelper(@TTCPConnectionWriteBufferMaxSize_R,@TTCPConnectionWriteBufferMaxSize_W,'WriteBufferMaxSize');
    RegisterPropertyHelper(@TTCPConnectionReadThrottle_R,@TTCPConnectionReadThrottle_W,'ReadThrottle');
    RegisterPropertyHelper(@TTCPConnectionReadThrottleRate_R,@TTCPConnectionReadThrottleRate_W,'ReadThrottleRate');
    RegisterPropertyHelper(@TTCPConnectionWriteThrottle_R,@TTCPConnectionWriteThrottle_W,'WriteThrottle');
    RegisterPropertyHelper(@TTCPConnectionWriteThrottleRate_R,@TTCPConnectionWriteThrottleRate_W,'WriteThrottleRate');
    RegisterPropertyHelper(@TTCPConnectionReadRate_R,nil,'ReadRate');
    RegisterPropertyHelper(@TTCPConnectionWriteRate_R,nil,'WriteRate');
    RegisterPropertyHelper(@TTCPConnectionReadBufferSize_R,nil,'ReadBufferSize');
    RegisterPropertyHelper(@TTCPConnectionWriteBufferSize_R,nil,'WriteBufferSize');
    RegisterMethod(@TTCPConnection.PollSocket, 'PollSocket');
    RegisterMethod(@TTCPConnection.Read, 'Read');
    RegisterMethod(@TTCPConnection.ReadStr, 'ReadStr');
    RegisterMethod(@TTCPConnection.Discard, 'Discard');
    RegisterMethod(@TTCPConnection.Peek, 'Peek');
    RegisterMethod(@TTCPConnection.PeekStr, 'PeekStr');
    RegisterMethod(@TTCPConnectionPeekDelimited_P, 'PeekDelimited');
    RegisterMethod(@TTCPConnectionPeekDelimited1_P, 'PeekDelimited1');
    RegisterMethod(@TTCPConnection.ReadLine, 'ReadLine');
    RegisterMethod(@TTCPConnection.Write, 'Write');
    RegisterMethod(@TTCPConnection.WriteAnsiStr, 'WriteAnsiStr');
    RegisterMethod(@TTCPConnection.WriteWideStr, 'WriteWideStr');
    RegisterMethod(@TTCPConnection.WriteStr, 'WriteStr');
    RegisterMethod(@TTCPConnection.Close, 'Close');
    RegisterMethod(@TTCPConnection.Shutdown, 'Shutdown');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTCPConnectionProxyList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTCPConnectionProxyList) do begin
    RegisterPropertyHelper(@TTCPConnectionProxyListCount_R,nil,'Count');
    RegisterMethod(@TTCPConnectionProxyList.Destroy, 'Free');
    RegisterPropertyHelper(@TTCPConnectionProxyListItem_R,nil,'Item');
    RegisterMethod(@TTCPConnectionProxyList.Add, 'Add');
    RegisterPropertyHelper(@TTCPConnectionProxyListLastItem_R,nil,'LastItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTCPConnectionProxy(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTCPConnectionProxy) do
  begin
    RegisterVirtualMethod(@TTCPConnectionProxy.ProxyName, 'ProxyName');
    RegisterConstructor(@TTCPConnectionProxy.Create, 'Create');
    RegisterPropertyHelper(@TTCPConnectionProxyState_R,nil,'State');
    RegisterPropertyHelper(@TTCPConnectionProxyStateStr_R,nil,'StateStr');
    RegisterMethod(@TTCPConnectionProxy.Start, 'Start');
    RegisterVirtualAbstractMethod(@TTCPConnectionProxy, @!.ProcessReadData, 'ProcessReadData');
    RegisterVirtualAbstractMethod(@TTCPConnectionProxy, @!.ProcessWriteData, 'ProcessWriteData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cTCPConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ETCPConnection) do
  with CL.Add(TTCPConnection) do
  RIRegister_TTCPConnectionProxy(CL);
  RIRegister_TTCPConnectionProxyList(CL);
  RIRegister_TTCPConnection(CL);
end;

 
 
{ TPSImport_cTCPConnection }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cTCPConnection.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cTCPConnection(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cTCPConnection.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cTCPConnection(ri);
  RIRegister_cTCPConnection_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
