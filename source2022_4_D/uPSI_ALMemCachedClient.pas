unit uPSI_ALMemCachedClient;
{
   cached db
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
  TPSImport_ALMemCachedClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAlMemCachedConnectionPoolClient(CL: TPSPascalCompiler);
procedure SIRegister_TAlMemCachedConnectionPoolContainer(CL: TPSPascalCompiler);
procedure SIRegister_TAlMemCachedClient(CL: TPSPascalCompiler);
procedure SIRegister_TAlBaseMemCachedClient(CL: TPSPascalCompiler);
procedure SIRegister_EAlMemCachedClientException(CL: TPSPascalCompiler);
procedure SIRegister_ALMemCachedClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAlMemCachedConnectionPoolClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAlMemCachedConnectionPoolContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAlMemCachedClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAlBaseMemCachedClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_EAlMemCachedClientException(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALMemCachedClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // WinSock2
  WinSock
  ,Contnrs
  ,SyncObjs, AlFcnMisc
  //,AlFcnString
  ,ALMemCachedClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALMemCachedClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlMemCachedConnectionPoolClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAlBaseMemCachedClient', 'TAlMemCachedConnectionPoolClient') do
  with CL.AddClassN(CL.FindClass('TAlBaseMemCachedClient'),'TAlMemCachedConnectionPoolClient') do begin
    RegisterMethod('Constructor Create( const aHost : AnsiString; const APort : integer)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ReleaseAllConnections( const WaitWorkingConnections : Boolean)');
    RegisterMethod('Function Get( const key : ansiString; var flags : integer; var data : ansiString) : boolean;');
    RegisterMethod('Function Get1( const key : ansiString) : AnsiString;');
    RegisterMethod('Function Get2( const keys : array of ansiString) : TAlMemCachedClient_StoredItems;');
    RegisterMethod('Function Gets( const key : ansiString; var flags : integer; var cas_id : int64; var data : ansiString) : boolean;');
    RegisterMethod('Function Gets1( const keys : array of ansiString) : TAlMemCachedClient_StoredItems;');
    RegisterMethod('Procedure _Set( const key : ansiString; const flags : integer; const exptime : integer; const data : ansiString)');
    RegisterMethod('Procedure Add( const key : ansiString; const flags : integer; const exptime : integer; const data : ansiString)');
    RegisterMethod('Procedure Replace( const key : ansiString; const flags : integer; const exptime : integer; const data : ansiString)');
    RegisterMethod('Procedure Append( const key : ansiString; const data : ansiString)');
    RegisterMethod('Procedure Prepend( const key : ansiString; const data : ansiString)');
    RegisterMethod('Function Cas( const key : ansiString; const flags : integer; const exptime : integer; const cas_id : int64; const data : ansiString) : boolean');
    RegisterMethod('Function Delete( const key : ansiString) : boolean');
    RegisterMethod('Function Incr( const key : ansiString; const Value : int64) : int64');
    RegisterMethod('Function Decr( const key : ansiString; const Value : int64) : int64');
    RegisterMethod('Procedure Touch( const key : ansiString; const exptime : integer)');
    RegisterMethod('Function Stats( const args : AnsiString) : AnsiString');
    RegisterMethod('Procedure Flush_all( delay : integer)');
    RegisterMethod('Function Version : AnsiString');
    RegisterMethod('Procedure Verbosity( level : integer)');
    RegisterProperty('Host', 'ansiString', iptr);
    RegisterProperty('Port', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlMemCachedConnectionPoolContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAlMemCachedConnectionPoolContainer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAlMemCachedConnectionPoolContainer') do begin
    RegisterProperty('SocketDescriptor', 'TSocket', iptrw);
    RegisterProperty('LastAccessDate', 'int64', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlMemCachedClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAlBaseMemCachedClient', 'TAlMemCachedClient') do
  with CL.AddClassN(CL.FindClass('TAlBaseMemCachedClient'),'TAlMemCachedClient') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Connect( const aHost : AnsiString; const APort : integer)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Function Get( const key : ansiString; var flags : integer; var data : ansiString) : boolean;');
    RegisterMethod('Function Get1( const key : ansiString) : AnsiString;');
    RegisterMethod('Function Get2( const keys : array of ansiString) : TAlMemCachedClient_StoredItems;');
    RegisterMethod('Function Gets( const key : ansiString; var flags : integer; var cas_id : int64; var data : ansiString) : boolean;');
    RegisterMethod('Function Gets1( const keys : array of ansiString) : TAlMemCachedClient_StoredItems;');
    RegisterMethod('Procedure _Set( const key : ansiString; const flags : integer; const exptime : integer; const data : ansiString)');
    RegisterMethod('Procedure Add( const key : ansiString; const flags : integer; const exptime : integer; const data : ansiString)');
    RegisterMethod('Procedure Replace( const key : ansiString; const flags : integer; const exptime : integer; const data : ansiString)');
    RegisterMethod('Procedure Append( const key : ansiString; const data : ansiString)');
    RegisterMethod('Procedure Prepend( const key : ansiString; const data : ansiString)');
    RegisterMethod('Function Cas( const key : ansiString; const flags : integer; const exptime : integer; const cas_id : int64; const data : ansiString) : boolean');
    RegisterMethod('Function Delete( const key : ansiString) : boolean');
    RegisterMethod('Function Incr( const key : ansiString; const Value : int64) : int64');
    RegisterMethod('Function Decr( const key : ansiString; const Value : int64) : int64');
    RegisterMethod('Procedure Touch( const key : ansiString; const exptime : integer)');
    RegisterMethod('Function Stats( const args : AnsiString) : AnsiString');
    RegisterMethod('Procedure Flush_all( delay : integer)');
    RegisterMethod('Function Version : AnsiString');
    RegisterMethod('Procedure Verbosity( level : integer)');
    RegisterMethod('Procedure quit');
    RegisterProperty('Connected', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlBaseMemCachedClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAlBaseMemCachedClient') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAlBaseMemCachedClient') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('SendTimeout', 'Integer', iptrw);
    RegisterProperty('ReceiveTimeout', 'Integer', iptrw);
    RegisterProperty('KeepAlive', 'Boolean', iptrw);
    RegisterProperty('TcpNoDelay', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EAlMemCachedClientException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EALException', 'EAlMemCachedClientException') do
  with CL.AddClassN(CL.FindClass('EALException'),'EAlMemCachedClientException') do
  begin
    RegisterMethod('Constructor Create( const aMsg : AnsiString; const aCloseConnection : Boolean)');
    RegisterProperty('CloseConnection', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALMemCachedClient(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TAlMemCachedClient_responseType', '( rpEND, rpOK, rpCRLF, rpSTOR'
   +'AGE, rpRETRIEVAL, rpRETRIEVALS, rpDELETE, rpINCRDECR, rpTOUCH, rpNONE )');
  CL.AddTypeS('TAlMemCachedClient_StoredItem', 'record key : ansiString; flags '
   +': integer; cas_id : int64; data : ansiString; end');
  CL.AddTypeS('TAlMemCachedClient_StoredItems', 'array of TAlMemCachedClient_StoredItem');
  SIRegister_EAlMemCachedClientException(CL);
  SIRegister_TAlBaseMemCachedClient(CL);
  SIRegister_TAlMemCachedClient(CL);
  SIRegister_TAlMemCachedConnectionPoolContainer(CL);
  SIRegister_TAlMemCachedConnectionPoolClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAlMemCachedConnectionPoolClientPort_R(Self: TAlMemCachedConnectionPoolClient; var T: integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TAlMemCachedConnectionPoolClientHost_R(Self: TAlMemCachedConnectionPoolClient; var T: ansiString);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
Function TAlMemCachedConnectionPoolClientGets1_P(Self: TAlMemCachedConnectionPoolClient;  const keys : array of ansiString) : TAlMemCachedClient_StoredItems;
Begin Result := Self.Gets(keys); END;

(*----------------------------------------------------------------------------*)
Function TAlMemCachedConnectionPoolClientGets_P(Self: TAlMemCachedConnectionPoolClient;  const key : ansiString; var flags : integer; var cas_id : int64; var data : ansiString) : boolean;
Begin Result := Self.Gets(key, flags, cas_id, data); END;

(*----------------------------------------------------------------------------*)
Function TAlMemCachedConnectionPoolClientGet2_P(Self: TAlMemCachedConnectionPoolClient;  const keys : array of ansiString) : TAlMemCachedClient_StoredItems;
Begin Result := Self.Get(keys); END;

(*----------------------------------------------------------------------------*)
Function TAlMemCachedConnectionPoolClientGet1_P(Self: TAlMemCachedConnectionPoolClient;  const key : ansiString) : AnsiString;
Begin Result := Self.Get(key); END;

(*----------------------------------------------------------------------------*)
Function TAlMemCachedConnectionPoolClientGet_P(Self: TAlMemCachedConnectionPoolClient;  const key : ansiString; var flags : integer; var data : ansiString) : boolean;
Begin Result := Self.Get(key, flags, data); END;

(*----------------------------------------------------------------------------*)
procedure TAlMemCachedConnectionPoolContainerLastAccessDate_W(Self: TAlMemCachedConnectionPoolContainer; const T: int64);
Begin Self.LastAccessDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlMemCachedConnectionPoolContainerLastAccessDate_R(Self: TAlMemCachedConnectionPoolContainer; var T: int64);
Begin T := Self.LastAccessDate; end;

(*----------------------------------------------------------------------------*)
procedure TAlMemCachedConnectionPoolContainerSocketDescriptor_W(Self: TAlMemCachedConnectionPoolContainer; const T: TSocket);
Begin Self.SocketDescriptor := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlMemCachedConnectionPoolContainerSocketDescriptor_R(Self: TAlMemCachedConnectionPoolContainer; var T: TSocket);
Begin T := Self.SocketDescriptor; end;

(*----------------------------------------------------------------------------*)
procedure TAlMemCachedClientConnected_R(Self: TAlMemCachedClient; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
Function TAlMemCachedClientGets1_P(Self: TAlMemCachedClient;  const keys : array of ansiString) : TAlMemCachedClient_StoredItems;
Begin Result := Self.Gets(keys); END;

(*----------------------------------------------------------------------------*)
Function TAlMemCachedClientGets_P(Self: TAlMemCachedClient;  const key : ansiString; var flags : integer; var cas_id : int64; var data : ansiString) : boolean;
Begin Result := Self.Gets(key, flags, cas_id, data); END;

(*----------------------------------------------------------------------------*)
Function TAlMemCachedClientGet2_P(Self: TAlMemCachedClient;  const keys : array of ansiString) : TAlMemCachedClient_StoredItems;
Begin Result := Self.Get(keys); END;

(*----------------------------------------------------------------------------*)
Function TAlMemCachedClientGet1_P(Self: TAlMemCachedClient;  const key : ansiString) : AnsiString;
Begin Result := Self.Get(key); END;

(*----------------------------------------------------------------------------*)
Function TAlMemCachedClientGet_P(Self: TAlMemCachedClient;  const key : ansiString; var flags : integer; var data : ansiString) : boolean;
Begin Result := Self.Get(key, flags, data); END;

(*----------------------------------------------------------------------------*)
procedure TAlBaseMemCachedClientTcpNoDelay_W(Self: TAlBaseMemCachedClient; const T: Boolean);
begin Self.TcpNoDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlBaseMemCachedClientTcpNoDelay_R(Self: TAlBaseMemCachedClient; var T: Boolean);
begin T := Self.TcpNoDelay; end;

(*----------------------------------------------------------------------------*)
procedure TAlBaseMemCachedClientKeepAlive_W(Self: TAlBaseMemCachedClient; const T: Boolean);
begin Self.KeepAlive := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlBaseMemCachedClientKeepAlive_R(Self: TAlBaseMemCachedClient; var T: Boolean);
begin T := Self.KeepAlive; end;

(*----------------------------------------------------------------------------*)
procedure TAlBaseMemCachedClientReceiveTimeout_W(Self: TAlBaseMemCachedClient; const T: Integer);
begin Self.ReceiveTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlBaseMemCachedClientReceiveTimeout_R(Self: TAlBaseMemCachedClient; var T: Integer);
begin T := Self.ReceiveTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TAlBaseMemCachedClientSendTimeout_W(Self: TAlBaseMemCachedClient; const T: Integer);
begin Self.SendTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlBaseMemCachedClientSendTimeout_R(Self: TAlBaseMemCachedClient; var T: Integer);
begin T := Self.SendTimeout; end;

(*----------------------------------------------------------------------------*)
Function TAlBaseMemCachedClientDoGets1_P(Self: TAlBaseMemCachedClient;  aSocketDescriptor : TSocket; const keys : array of ansiString) : TAlMemCachedClient_StoredItems;
Begin //Result := Self.DoGets(aSocketDescriptor, keys);
END;

(*----------------------------------------------------------------------------*)
Function TAlBaseMemCachedClientDoGets_P(Self: TAlBaseMemCachedClient;  aSocketDescriptor : TSocket; const key : ansiString; var flags : integer; var cas_id : int64; var data : ansiString) : boolean;
Begin //Result := Self.DoGets(aSocketDescriptor, key, flags, cas_id, data);
END;

(*----------------------------------------------------------------------------*)
Function TAlBaseMemCachedClientDoGet2_P(Self: TAlBaseMemCachedClient;  aSocketDescriptor : TSocket; const keys : array of ansiString) : TAlMemCachedClient_StoredItems;
Begin //Result := Self.DoGet(aSocketDescriptor, keys);
END;

(*----------------------------------------------------------------------------*)
Function TAlBaseMemCachedClientDoGet1_P(Self: TAlBaseMemCachedClient;  aSocketDescriptor : TSocket; const key : ansiString) : AnsiString;
Begin //Result := Self.DoGet(aSocketDescriptor, key);
END;

(*----------------------------------------------------------------------------*)
Function TAlBaseMemCachedClientDoGet_P(Self: TAlBaseMemCachedClient;  aSocketDescriptor : TSocket; const key : ansiString; var flags : integer; var data : ansiString) : boolean;
Begin //Result := Self.DoGet(aSocketDescriptor, key, flags, data);
END;

(*----------------------------------------------------------------------------*)
Function TAlBaseMemCachedClientSendCmd1_P(Self: TAlBaseMemCachedClient;  aSocketDescriptor : TSocket; aCmd : AnsiString; aResponseType : TAlMemCachedClient_responseType) : AnsiString;
Begin //Result := Self.SendCmd(aSocketDescriptor, aCmd, aResponseType);
END;

(*----------------------------------------------------------------------------*)
Function TAlBaseMemCachedClientSendCmd_P(Self: TAlBaseMemCachedClient;  aSocketDescriptor : TSocket; aCmd : AnsiString; aResponseType : TAlMemCachedClient_responseType; var aGETStoredItems : TAlMemCachedClient_StoredItems) : AnsiString;
Begin //Result := Self.SendCmd(aSocketDescriptor, aCmd, aResponseType, aGETStoredItems);
END;

(*----------------------------------------------------------------------------*)
procedure EAlMemCachedClientExceptionCloseConnection_W(Self: EAlMemCachedClientException; const T: Boolean);
begin Self.CloseConnection := T; end;

(*----------------------------------------------------------------------------*)
procedure EAlMemCachedClientExceptionCloseConnection_R(Self: EAlMemCachedClientException; var T: Boolean);
begin T := Self.CloseConnection; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlMemCachedConnectionPoolClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlMemCachedConnectionPoolClient) do
  begin
    RegisterConstructor(@TAlMemCachedConnectionPoolClient.Create, 'Create');
     RegisterMethod(@TAlMemCachedConnectionPoolClient.Destroy, 'Free');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.ReleaseAllConnections, 'ReleaseAllConnections');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClientGet_P, 'Get');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClientGet1_P, 'Get1');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClientGet2_P, 'Get2');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClientGets_P, 'Gets');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClientGets1_P, 'Gets1');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient._Set, '_Set');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Add, 'Add');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Replace, 'Replace');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Append, 'Append');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Prepend, 'Prepend');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Cas, 'Cas');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Delete, 'Delete');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Incr, 'Incr');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Decr, 'Decr');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Touch, 'Touch');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Stats, 'Stats');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Flush_all, 'Flush_all');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Version, 'Version');
    RegisterVirtualMethod(@TAlMemCachedConnectionPoolClient.Verbosity, 'Verbosity');
    RegisterPropertyHelper(@TAlMemCachedConnectionPoolClientHost_R,nil,'Host');
    RegisterPropertyHelper(@TAlMemCachedConnectionPoolClientPort_R,nil,'Port');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlMemCachedConnectionPoolContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlMemCachedConnectionPoolContainer) do
  begin
    RegisterPropertyHelper(@TAlMemCachedConnectionPoolContainerSocketDescriptor_R,@TAlMemCachedConnectionPoolContainerSocketDescriptor_W,'SocketDescriptor');
    RegisterPropertyHelper(@TAlMemCachedConnectionPoolContainerLastAccessDate_R,@TAlMemCachedConnectionPoolContainerLastAccessDate_W,'LastAccessDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlMemCachedClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlMemCachedClient) do
  begin
    RegisterConstructor(@TAlMemCachedClient.Create, 'Create');
     RegisterMethod(@TAlMemCachedClient.Destroy, 'Free');
    RegisterVirtualMethod(@TAlMemCachedClient.Connect, 'Connect');
    RegisterVirtualMethod(@TAlMemCachedClient.Disconnect, 'Disconnect');
    RegisterVirtualMethod(@TAlMemCachedClientGet_P, 'Get');
    RegisterVirtualMethod(@TAlMemCachedClientGet1_P, 'Get1');
    RegisterVirtualMethod(@TAlMemCachedClientGet2_P, 'Get2');
    RegisterVirtualMethod(@TAlMemCachedClientGets_P, 'Gets');
    RegisterVirtualMethod(@TAlMemCachedClientGets1_P, 'Gets1');
    RegisterVirtualMethod(@TAlMemCachedClient._Set, '_Set');
    RegisterVirtualMethod(@TAlMemCachedClient.Add, 'Add');
    RegisterVirtualMethod(@TAlMemCachedClient.Replace, 'Replace');
    RegisterVirtualMethod(@TAlMemCachedClient.Append, 'Append');
    RegisterVirtualMethod(@TAlMemCachedClient.Prepend, 'Prepend');
    RegisterVirtualMethod(@TAlMemCachedClient.Cas, 'Cas');
    RegisterVirtualMethod(@TAlMemCachedClient.Delete, 'Delete');
    RegisterVirtualMethod(@TAlMemCachedClient.Incr, 'Incr');
    RegisterVirtualMethod(@TAlMemCachedClient.Decr, 'Decr');
    RegisterVirtualMethod(@TAlMemCachedClient.Touch, 'Touch');
    RegisterVirtualMethod(@TAlMemCachedClient.Stats, 'Stats');
    RegisterVirtualMethod(@TAlMemCachedClient.Flush_all, 'Flush_all');
    RegisterVirtualMethod(@TAlMemCachedClient.Version, 'Version');
    RegisterVirtualMethod(@TAlMemCachedClient.Verbosity, 'Verbosity');
    RegisterVirtualMethod(@TAlMemCachedClient.quit, 'quit');
    RegisterPropertyHelper(@TAlMemCachedClientConnected_R,nil,'Connected');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlBaseMemCachedClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlBaseMemCachedClient) do begin
    RegisterConstructor(@TAlBaseMemCachedClient.Create, 'Create');
     RegisterMethod(@TAlBaseMemCachedClient.Destroy, 'Free');
    RegisterPropertyHelper(@TAlBaseMemCachedClientSendTimeout_R,@TAlBaseMemCachedClientSendTimeout_W,'SendTimeout');
    RegisterPropertyHelper(@TAlBaseMemCachedClientReceiveTimeout_R,@TAlBaseMemCachedClientReceiveTimeout_W,'ReceiveTimeout');
    RegisterPropertyHelper(@TAlBaseMemCachedClientKeepAlive_R,@TAlBaseMemCachedClientKeepAlive_W,'KeepAlive');
    RegisterPropertyHelper(@TAlBaseMemCachedClientTcpNoDelay_R,@TAlBaseMemCachedClientTcpNoDelay_W,'TcpNoDelay');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EAlMemCachedClientException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EAlMemCachedClientException) do begin
    RegisterConstructor(@EAlMemCachedClientException.Create, 'Create');
    RegisterPropertyHelper(@EAlMemCachedClientExceptionCloseConnection_R,@EAlMemCachedClientExceptionCloseConnection_W,'CloseConnection');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALMemCachedClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EAlMemCachedClientException(CL);
  RIRegister_TAlBaseMemCachedClient(CL);
  RIRegister_TAlMemCachedClient(CL);
  RIRegister_TAlMemCachedConnectionPoolContainer(CL);
  RIRegister_TAlMemCachedConnectionPoolClient(CL);
end;

 
 
{ TPSImport_ALMemCachedClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALMemCachedClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALMemCachedClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALMemCachedClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALMemCachedClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
