unit uPSI_IdModBusClient;
{
  the link to modbusserver as the old tcpclient
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
  TPSImport_IdModBusClient = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdModBusClient(CL: TPSPascalCompiler);
procedure SIRegister_IdModBusClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdModBusClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdModBusClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ModBusConsts
  ,ModbusTypes
  ,Types
  ,IdGlobal
  ,IdTCPClient
  ,IdModBusClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdModBusClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdModBusClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPClient', 'TIdModBusClient') do
  with CL.AddClassN(CL.FindClass('TIdTCPClient'),'TIdModBusClient') do begin
    RegisterProperty('LastTransactionID', 'Word', iptr);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    //RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Connect( const ATimeout : Integer)');
    RegisterMethod('Function ReadCoil( const RegNo : Word; out Value : Boolean) : Boolean');
    RegisterMethod('Function ReadCoils( const RegNo : Word; const Blocks : Word; out RegisterData : array of Boolean) : Boolean');
    RegisterMethod('Function ReadDouble( const RegNo : Word; out Value : Double) : Boolean');
    RegisterMethod('Function ReadDWord( const RegNo : Word; out Value : DWord) : Boolean');
    RegisterMethod('Function ReadHoldingRegister( const RegNo : Word; out Value : Word) : Boolean');
    RegisterMethod('Function ReadHoldingRegisters( const RegNo : Word; const Blocks : Word; out RegisterData : array of Word) : Boolean');
    RegisterMethod('Function ReadInputBits( const RegNo : Word; const Blocks : Word; out RegisterData : array of Boolean) : Boolean');
    RegisterMethod('Function ReadInputRegister( const RegNo : Word; out Value : Word) : Boolean');
    RegisterMethod('Function ReadInputRegisters( const RegNo : Word; const Blocks : Word; var RegisterData : array of Word) : Boolean');
    RegisterMethod('Function ReadSingle( const RegNo : Word; out Value : Single) : Boolean');
    RegisterMethod('Function ReadString( const RegNo : Word; const ALength : Word) : String');
    RegisterMethod('Function WriteCoil( const RegNo : Word; const Value : Boolean) : Boolean');
    RegisterMethod('Function WriteCoils( const RegNo : Word; const Blocks : Word; const RegisterData : array of Boolean) : Boolean');
    RegisterMethod('Function WriteRegister( const RegNo : Word; const Value : Word) : Boolean');
    RegisterMethod('Function WriteRegisters( const RegNo : Word; const RegisterData : array of Word) : Boolean');
    RegisterMethod('Function WriteDouble( const RegNo : Word; const Value : Double) : Boolean');
    RegisterMethod('Function WriteDWord( const RegNo : Word; const Value : DWord) : Boolean');
    RegisterMethod('Function WriteSingle( const RegNo : Word; const Value : Single) : Boolean');
    RegisterMethod('Function WriteString( const RegNo : Word; const Text : String) : Boolean');
    RegisterProperty('AutoConnect', 'Boolean', iptrw);
    RegisterProperty('BaseRegister', 'Word', iptrw);
    RegisterProperty('ConnectTimeOut', 'Integer', iptrw);
    RegisterProperty('ReadTimeout', 'Integer', iptrw);
    RegisterProperty('TimeOut', 'Cardinal', iptrw);
    RegisterProperty('UnitID', 'Byte', iptrw);
    RegisterProperty('Version', 'String', iptrw);
    RegisterProperty('OnResponseError', 'TModbusClientErrorEvent', iptrw);
    RegisterProperty('OnResponseMismatch', 'TModBusClientResponseMismatchEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdModBusClient(CL: TPSPascalCompiler);
begin
  CL.AddConstantN('MB_PORT','integer').SetInt(502);
  CL.AddConstantN('MB_IGNORE_UNITID','integer').SetInt(255);
  CL.AddConstantN('MB_PROTOCOL','integer').SetInt(0);
   CL.AddTypeS('TModBusClientErrorEvent', 'Procedure ( const FunctionCode : Byte'
   +'; const ErrorCode : Byte; const ResponseBuffer : TModBusResponseBuffer)');
  CL.AddTypeS('TModBusClientResponseMismatchEvent', 'Procedure ( const RequestF'
   +'unctionCode : Byte; const ResponseFunctionCode : Byte; const ResponseBuffer: TModBusResponseBuffer)');
  SIRegister_TIdModBusClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdModBusClientOnResponseMismatch_W(Self: TIdModBusClient; const T: TModBusClientResponseMismatchEvent);
begin Self.OnResponseMismatch := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientOnResponseMismatch_R(Self: TIdModBusClient; var T: TModBusClientResponseMismatchEvent);
begin T := Self.OnResponseMismatch; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientOnResponseError_W(Self: TIdModBusClient; const T: TModbusClientErrorEvent);
begin Self.OnResponseError := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientOnResponseError_R(Self: TIdModBusClient; var T: TModbusClientErrorEvent);
begin T := Self.OnResponseError; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientVersion_W(Self: TIdModBusClient; const T: String);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientVersion_R(Self: TIdModBusClient; var T: String);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientUnitID_W(Self: TIdModBusClient; const T: Byte);
begin Self.UnitID := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientUnitID_R(Self: TIdModBusClient; var T: Byte);
begin T := Self.UnitID; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientTimeOut_W(Self: TIdModBusClient; const T: Cardinal);
begin Self.TimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientTimeOut_R(Self: TIdModBusClient; var T: Cardinal);
begin T := Self.TimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientReadTimeout_W(Self: TIdModBusClient; const T: Integer);
begin Self.ReadTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientReadTimeout_R(Self: TIdModBusClient; var T: Integer);
begin T := Self.ReadTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientConnectTimeOut_W(Self: TIdModBusClient; const T: Integer);
begin Self.ConnectTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientConnectTimeOut_R(Self: TIdModBusClient; var T: Integer);
begin T := Self.ConnectTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientBaseRegister_W(Self: TIdModBusClient; const T: Word);
begin Self.BaseRegister := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientBaseRegister_R(Self: TIdModBusClient; var T: Word);
begin T := Self.BaseRegister; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientAutoConnect_W(Self: TIdModBusClient; const T: Boolean);
begin Self.AutoConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientAutoConnect_R(Self: TIdModBusClient; var T: Boolean);
begin T := Self.AutoConnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdModBusClientLastTransactionID_R(Self: TIdModBusClient; var T: Word);
begin T := Self.LastTransactionID; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdModBusClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdModBusClient) do begin
    RegisterPropertyHelper(@TIdModBusClientLastTransactionID_R,nil,'LastTransactionID');
    RegisterConstructor(@TIdModBusClient.Create, 'Create');
    RegisterMethod(@TIdModBusClient.Connect, 'Connect');
   // RegisterMethod(@TIdModBusClient.Connect, 'Connect');
    RegisterMethod(@TIdModBusClient.ReadCoil, 'ReadCoil');
    RegisterMethod(@TIdModBusClient.ReadCoils, 'ReadCoils');
    RegisterMethod(@TIdModBusClient.ReadDouble, 'ReadDouble');
    RegisterMethod(@TIdModBusClient.ReadDWord, 'ReadDWord');
    RegisterMethod(@TIdModBusClient.ReadHoldingRegister, 'ReadHoldingRegister');
    RegisterMethod(@TIdModBusClient.ReadHoldingRegisters, 'ReadHoldingRegisters');
    RegisterMethod(@TIdModBusClient.ReadInputBits, 'ReadInputBits');
    RegisterMethod(@TIdModBusClient.ReadInputRegister, 'ReadInputRegister');
    RegisterMethod(@TIdModBusClient.ReadInputRegisters, 'ReadInputRegisters');
    RegisterMethod(@TIdModBusClient.ReadSingle, 'ReadSingle');
    RegisterMethod(@TIdModBusClient.ReadString, 'ReadString');
    RegisterMethod(@TIdModBusClient.WriteCoil, 'WriteCoil');
    RegisterMethod(@TIdModBusClient.WriteCoils, 'WriteCoils');
    RegisterMethod(@TIdModBusClient.WriteRegister, 'WriteRegister');
    RegisterMethod(@TIdModBusClient.WriteRegisters, 'WriteRegisters');
    RegisterMethod(@TIdModBusClient.WriteDouble, 'WriteDouble');
    RegisterMethod(@TIdModBusClient.WriteDWord, 'WriteDWord');
    RegisterMethod(@TIdModBusClient.WriteSingle, 'WriteSingle');
    RegisterMethod(@TIdModBusClient.WriteString, 'WriteString');
    RegisterPropertyHelper(@TIdModBusClientAutoConnect_R,@TIdModBusClientAutoConnect_W,'AutoConnect');
    RegisterPropertyHelper(@TIdModBusClientBaseRegister_R,@TIdModBusClientBaseRegister_W,'BaseRegister');
    RegisterPropertyHelper(@TIdModBusClientConnectTimeOut_R,@TIdModBusClientConnectTimeOut_W,'ConnectTimeOut');
    RegisterPropertyHelper(@TIdModBusClientReadTimeout_R,@TIdModBusClientReadTimeout_W,'ReadTimeout');
    RegisterPropertyHelper(@TIdModBusClientTimeOut_R,@TIdModBusClientTimeOut_W,'TimeOut');
    RegisterPropertyHelper(@TIdModBusClientUnitID_R,@TIdModBusClientUnitID_W,'UnitID');
    RegisterPropertyHelper(@TIdModBusClientVersion_R,@TIdModBusClientVersion_W,'Version');
    RegisterPropertyHelper(@TIdModBusClientOnResponseError_R,@TIdModBusClientOnResponseError_W,'OnResponseError');
    RegisterPropertyHelper(@TIdModBusClientOnResponseMismatch_R,@TIdModBusClientOnResponseMismatch_W,'OnResponseMismatch');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdModBusClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdModBusClient(CL);
end;

 
 
{ TPSImport_IdModBusClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdModBusClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdModBusClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdModBusClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdModBusClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
