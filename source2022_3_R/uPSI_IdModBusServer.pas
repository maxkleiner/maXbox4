unit uPSI_IdModBusServer;
{
   as an expand to tcpclient
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
  TPSImport_IdModBusServer = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdModBusServer(CL: TPSPascalCompiler);
procedure SIRegister_IdModBusServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdModBusServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdModBusServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // IdContext
  //IdCustomTCPServer
  IdGlobal
  ,IdTCPClient
  ,IdTCPServer
  ,ModBusConsts
  ,ModbusTypes
  ,ModbusUtils
  ,SyncObjs
  ,IdModBusServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdModBusServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdModBusServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdModBusServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdModBusServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Pause', 'Boolean', iptrw);
    RegisterProperty('BaseRegister', 'Word', iptrw);
    RegisterProperty('LogEnabled', 'Boolean', iptrw);
    RegisterProperty('LogFile', 'String', iptrw);
    RegisterProperty('LogTimeFormat', 'String', iptrw);
    RegisterProperty('OneShotConnection', 'Boolean', iptrw);
    RegisterProperty('MaxRegister', 'Word', iptrw);
    RegisterProperty('MinRegister', 'Word', iptrw);
    RegisterProperty('UnitID', 'Byte', iptrw);
    RegisterProperty('Version', 'String', iptrw);
    RegisterProperty('OnError', 'TModBusErrorEvent', iptrw);
    RegisterProperty('OnInvalidFunction', 'TModBusInvalidFunctionEvent', iptrw);
    RegisterProperty('OnReadCoils', 'TModBusCoilReadEvent', iptrw);
    RegisterProperty('OnReadHoldingRegisters', 'TModBusRegisterReadEvent', iptrw);
    RegisterProperty('OnReadInputBits', 'TModBusCoilReadEvent', iptrw);
    RegisterProperty('OnReadInputRegisters', 'TModBusRegisterReadEvent', iptrw);
    RegisterProperty('OnWriteCoils', 'TModBusCoilWriteEvent', iptrw);
    RegisterProperty('OnWriteRegisters', 'TModBusRegisterWriteEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdModBusServer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TModRegisterData', 'array[0..125] of Word;');
  CL.AddTypeS('TModCoilData', 'array[0..2000] of ByteBool;');
  CL.AddTypeS('TModBusDataBuffer', 'array[0..260] of Byte;');

{  type
  TModBusDataBuffer = array[0..260] of Byte;
  TModRegisterData = array[0..MaxBlockLength] of Word;
  TModCoilData = array[0..MaxCoils] of ByteBool;}

  CL.AddTypeS('TModBusFunction', 'Byte');
  CL.AddTypeS('TModBusHeader', 'record TransactionID : Word; ProtocolID : Word;'
   +' RecLength : Word; UnitID : Byte; end');
  CL.AddTypeS('TModBusRequestBuffer', 'record Header : TModBusHeader; FunctionC'
   +'ode : TModBusFunction; MBPData : TModBusDataBuffer; end');
  CL.AddTypeS('TModBusResponseBuffer', 'record Header : TModBusHeader; Function'
   +'Code : TModBusFunction; MBPData : TModBusDataBuffer; end');
  CL.AddTypeS('TModBusExceptionBuffer', 'record Header : TModBusHeader; Excepti'
   +'onFunction : TModBusFunction; ExceptionCode : Byte; end');

  CL.AddTypeS('TModBusCoilReadEvent', 'Procedure ( const Sender : TIdPeerThread'
   +'; const RegNr, Count : Integer; var Data : TModCoilData; const RequestBuff'
   +'er : TModBusRequestBuffer; var ErrorCode : Byte)');
  CL.AddTypeS('TModBusRegisterReadEvent', 'Procedure ( const Sender : TIdPeerTh'
   +'read; const RegNr, Count : Integer; var Data : TModRegisterData; const Req'
   +'uestBuffer : TModBusRequestBuffer; var ErrorCode : Byte)');
  CL.AddTypeS('TModBusCoilWriteEvent', 'Procedure ( const Sender : TIdPeerThrea'
   +'d; const RegNr, Count : Integer; const Data : TModCoilData; const RequestB'
   +'uffer : TModBusRequestBuffer; var ErrorCode : Byte)');
  CL.AddTypeS('TModBusRegisterWriteEvent', 'Procedure ( const Sender : TIdPeerT'
   +'hread; const RegNr, Count : Integer; const Data : TModRegisterData; const '
   +'RequestBuffer : TModBusRequestBuffer; var ErrorCode : Byte)');
  CL.AddTypeS('TModBusErrorEvent', 'Procedure ( const Sender : TIdPeerThread; c'
   +'onst FunctionCode : Byte; const ErrorCode : Byte; const RequestBuffer : TM'
   +'odBusRequestBuffer)');
  CL.AddTypeS('TModBusInvalidFunctionEvent', 'Procedure ( const Sender : TIdPee'
   +'rThread; const FunctionCode : TModBusFunction; const RequestBuffer : TModB'
   +'usRequestBuffer)');
  SIRegister_TIdModBusServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnWriteRegisters_W(Self: TIdModBusServer; const T: TModBusRegisterWriteEvent);
begin Self.OnWriteRegisters := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnWriteRegisters_R(Self: TIdModBusServer; var T: TModBusRegisterWriteEvent);
begin T := Self.OnWriteRegisters; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnWriteCoils_W(Self: TIdModBusServer; const T: TModBusCoilWriteEvent);
begin Self.OnWriteCoils := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnWriteCoils_R(Self: TIdModBusServer; var T: TModBusCoilWriteEvent);
begin T := Self.OnWriteCoils; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnReadInputRegisters_W(Self: TIdModBusServer; const T: TModBusRegisterReadEvent);
begin Self.OnReadInputRegisters := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnReadInputRegisters_R(Self: TIdModBusServer; var T: TModBusRegisterReadEvent);
begin T := Self.OnReadInputRegisters; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnReadInputBits_W(Self: TIdModBusServer; const T: TModBusCoilReadEvent);
begin Self.OnReadInputBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnReadInputBits_R(Self: TIdModBusServer; var T: TModBusCoilReadEvent);
begin T := Self.OnReadInputBits; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnReadHoldingRegisters_W(Self: TIdModBusServer; const T: TModBusRegisterReadEvent);
begin Self.OnReadHoldingRegisters := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnReadHoldingRegisters_R(Self: TIdModBusServer; var T: TModBusRegisterReadEvent);
begin T := Self.OnReadHoldingRegisters; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnReadCoils_W(Self: TIdModBusServer; const T: TModBusCoilReadEvent);
begin Self.OnReadCoils := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnReadCoils_R(Self: TIdModBusServer; var T: TModBusCoilReadEvent);
begin T := Self.OnReadCoils; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnInvalidFunction_W(Self: TIdModBusServer; const T: TModBusInvalidFunctionEvent);
begin Self.OnInvalidFunction := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnInvalidFunction_R(Self: TIdModBusServer; var T: TModBusInvalidFunctionEvent);
begin T := Self.OnInvalidFunction; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnError_W(Self: TIdModBusServer; const T: TModBusErrorEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOnError_R(Self: TIdModBusServer; var T: TModBusErrorEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerVersion_W(Self: TIdModBusServer; const T: String);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerVersion_R(Self: TIdModBusServer; var T: String);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerUnitID_W(Self: TIdModBusServer; const T: Byte);
begin Self.UnitID := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerUnitID_R(Self: TIdModBusServer; var T: Byte);
begin T := Self.UnitID; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerMinRegister_W(Self: TIdModBusServer; const T: Word);
begin Self.MinRegister := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerMinRegister_R(Self: TIdModBusServer; var T: Word);
begin T := Self.MinRegister; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerMaxRegister_W(Self: TIdModBusServer; const T: Word);
begin Self.MaxRegister := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerMaxRegister_R(Self: TIdModBusServer; var T: Word);
begin T := Self.MaxRegister; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOneShotConnection_W(Self: TIdModBusServer; const T: Boolean);
begin Self.OneShotConnection := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerOneShotConnection_R(Self: TIdModBusServer; var T: Boolean);
begin T := Self.OneShotConnection; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerLogTimeFormat_W(Self: TIdModBusServer; const T: String);
begin Self.LogTimeFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerLogTimeFormat_R(Self: TIdModBusServer; var T: String);
begin T := Self.LogTimeFormat; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerLogFile_W(Self: TIdModBusServer; const T: String);
begin Self.LogFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerLogFile_R(Self: TIdModBusServer; var T: String);
begin T := Self.LogFile; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerLogEnabled_W(Self: TIdModBusServer; const T: Boolean);
begin Self.LogEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerLogEnabled_R(Self: TIdModBusServer; var T: Boolean);
begin T := Self.LogEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerBaseRegister_W(Self: TIdModBusServer; const T: Word);
begin Self.BaseRegister := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerBaseRegister_R(Self: TIdModBusServer; var T: Word);
begin T := Self.BaseRegister; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerPause_W(Self: TIdModBusServer; const T: Boolean);
begin Self.Pause := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusServerPause_R(Self: TIdModBusServer; var T: Boolean);
begin T := Self.Pause; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdModBusServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdModBusServer) do begin
    RegisterConstructor(@TIdModBusServer.Create, 'Create');
    RegisterPropertyHelper(@TIdModBusServerPause_R,@TIdModBusServerPause_W,'Pause');
    RegisterPropertyHelper(@TIdModBusServerBaseRegister_R,@TIdModBusServerBaseRegister_W,'BaseRegister');
    RegisterPropertyHelper(@TIdModBusServerLogEnabled_R,@TIdModBusServerLogEnabled_W,'LogEnabled');
    RegisterPropertyHelper(@TIdModBusServerLogFile_R,@TIdModBusServerLogFile_W,'LogFile');
    RegisterPropertyHelper(@TIdModBusServerLogTimeFormat_R,@TIdModBusServerLogTimeFormat_W,'LogTimeFormat');
    RegisterPropertyHelper(@TIdModBusServerOneShotConnection_R,@TIdModBusServerOneShotConnection_W,'OneShotConnection');
    RegisterPropertyHelper(@TIdModBusServerMaxRegister_R,@TIdModBusServerMaxRegister_W,'MaxRegister');
    RegisterPropertyHelper(@TIdModBusServerMinRegister_R,@TIdModBusServerMinRegister_W,'MinRegister');
    RegisterPropertyHelper(@TIdModBusServerUnitID_R,@TIdModBusServerUnitID_W,'UnitID');
    RegisterPropertyHelper(@TIdModBusServerVersion_R,@TIdModBusServerVersion_W,'Version');
    RegisterPropertyHelper(@TIdModBusServerOnError_R,@TIdModBusServerOnError_W,'OnError');
    RegisterPropertyHelper(@TIdModBusServerOnInvalidFunction_R,@TIdModBusServerOnInvalidFunction_W,'OnInvalidFunction');
    RegisterPropertyHelper(@TIdModBusServerOnReadCoils_R,@TIdModBusServerOnReadCoils_W,'OnReadCoils');
    RegisterPropertyHelper(@TIdModBusServerOnReadHoldingRegisters_R,@TIdModBusServerOnReadHoldingRegisters_W,'OnReadHoldingRegisters');
    RegisterPropertyHelper(@TIdModBusServerOnReadInputBits_R,@TIdModBusServerOnReadInputBits_W,'OnReadInputBits');
    RegisterPropertyHelper(@TIdModBusServerOnReadInputRegisters_R,@TIdModBusServerOnReadInputRegisters_W,'OnReadInputRegisters');
    RegisterPropertyHelper(@TIdModBusServerOnWriteCoils_R,@TIdModBusServerOnWriteCoils_W,'OnWriteCoils');
    RegisterPropertyHelper(@TIdModBusServerOnWriteRegisters_R,@TIdModBusServerOnWriteRegisters_W,'OnWriteRegisters');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdModBusServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdModBusServer(CL);
end;

 
 
{ TPSImport_IdModBusServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdModBusServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdModBusServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdModBusServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdModBusServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
