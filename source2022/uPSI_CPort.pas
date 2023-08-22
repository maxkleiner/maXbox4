unit uPSI_CPort;
{
  for arduino
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
  TPSImport_CPort = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_EComPort(CL: TPSPascalCompiler);
procedure SIRegister_TComStream(CL: TPSPascalCompiler);
procedure SIRegister_TComDataPacket(CL: TPSPascalCompiler);
procedure SIRegister_TComPort(CL: TPSPascalCompiler);
procedure SIRegister_TCustomComPort(CL: TPSPascalCompiler);
procedure SIRegister_TComBuffer(CL: TPSPascalCompiler);
procedure SIRegister_TComParity(CL: TPSPascalCompiler);
procedure SIRegister_TComFlowControl(CL: TPSPascalCompiler);
procedure SIRegister_TComTimeouts(CL: TPSPascalCompiler);
procedure SIRegister_TComThread(CL: TPSPascalCompiler);
procedure SIRegister_TComLink(CL: TPSPascalCompiler);
procedure SIRegister_CPort(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CPort_Routines(S: TPSExec);
procedure RIRegister_EComPort(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComDataPacket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComPort(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomComPort(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComParity(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComFlowControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComTimeouts(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_CPort(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //Windows
  //,Messages
  IniFiles
  ,Registry
  ,CPort
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CPort]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EComPort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EComPort') do
  with CL.AddClassN(CL.FindClass('Exception'),'EComPort') do begin
    RegisterMethod('Constructor Create( ACode : Integer; AWinCode : Integer)');
    RegisterMethod('Constructor CreateNoWinCode( ACode : Integer)');
    RegisterProperty('WinCode', 'Integer', iptrw);
    RegisterProperty('Code', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TComStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TComStream') do begin
    RegisterMethod('Constructor Create( AComPort : TCustomComPort)');
    RegisterMethod('Function Read( var Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Write( const Buffer, Count : Longint) : Longint');
    RegisterMethod('Function Seek( Offset : Longint; Origin : Word) : Longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComDataPacket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TComDataPacket') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TComDataPacket') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AddData( const Str : string)');
    RegisterMethod('Procedure ResetBuffer');
    RegisterProperty('ComPort', 'TCustomComPort', iptrw);
    RegisterProperty('CaseInsensitive', 'Boolean', iptrw);
    RegisterProperty('IncludeStrings', 'Boolean', iptrw);
    RegisterProperty('MaxBufferSize', 'Integer', iptrw);
    RegisterProperty('StartString', 'string', iptrw);
    RegisterProperty('StopString', 'string', iptrw);
    RegisterProperty('Size', 'Integer', iptrw);
    RegisterProperty('OnDiscard', 'TComStrEvent', iptrw);
    RegisterProperty('OnPacket', 'TComStrEvent', iptrw);
    RegisterProperty('OnCustomStart', 'TCustPacketEvent', iptrw);
    RegisterProperty('OnCustomStop', 'TCustPacketEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComPort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomComPort', 'TComPort') do
  with CL.AddClassN(CL.FindClass('TCustomComPort'),'TComPort') do begin
      RegisterPublishedProperties;

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomComPort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomComPort') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomComPort') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Procedure StoreSettings( StoreType : TStoreType; StoreTo : string)');
    RegisterMethod('Procedure LoadSettings( StoreType : TStoreType; LoadFrom : string)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure ShowSetupDialog');
    RegisterMethod('Function InputCount : Integer');
    RegisterMethod('Function OutputCount : Integer');
    RegisterMethod('Function Signals : TComSignals');
    RegisterMethod('Function StateFlags : TComStateFlags');
    RegisterMethod('Procedure SetDTR( OnOff : Boolean)');
    RegisterMethod('Procedure SetRTS( OnOff : Boolean)');
    RegisterMethod('Procedure SetXonXoff( OnOff : Boolean)');
    RegisterMethod('Procedure SetBreak( OnOff : Boolean)');
    RegisterMethod('Procedure ClearBuffer( Input, Output : Boolean)');
    RegisterMethod('Function LastErrors : TComErrors');
    RegisterMethod('Function Write( const Buffer, Count : Integer) : Integer');
    RegisterMethod('Function WriteStr( Str : string) : Integer');
    RegisterMethod('Function Read( var Buffer, Count : Integer) : Integer');
    RegisterMethod('Function ReadStr( var Str : string; Count : Integer) : Integer');
    RegisterMethod('Function WriteAsync( const Buffer, Count : Integer; var AsyncPtr : PAsync) : Integer');
    RegisterMethod('Function WriteStrAsync( var Str : string; var AsyncPtr : PAsync) : Integer');
    RegisterMethod('Function ReadAsync( var Buffer, Count : Integer; var AsyncPtr : PAsync) : Integer');
    RegisterMethod('Function ReadStrAsync( var Str : Ansistring; Count : Integer; var AsyncPtr : PAsync) : Integer');
    RegisterMethod('Function WriteUnicodeString( const Str : Unicodestring) : Integer');
    RegisterMethod('Function ReadUnicodeString( var Str : UnicodeString; Count : Integer) : Integer');
    RegisterMethod('Function WaitForAsync( var AsyncPtr : PAsync) : Integer');
    RegisterMethod('Function IsAsyncCompleted( AsyncPtr : PAsync) : Boolean');
    RegisterMethod('Procedure WaitForEvent( var Events : TComEvents; StopEvent : THandle; Timeout : Integer)');
    RegisterMethod('Procedure AbortAllAsync');
    RegisterMethod('Procedure TransmitChar( Ch : Char)');
    RegisterMethod('Procedure RegisterLink( AComLink : TComLink)');
    RegisterMethod('Procedure UnRegisterLink( AComLink : TComLink)');
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('TriggersOnRxChar', 'Boolean', iptrw);
    RegisterProperty('EventThreadPriority', 'TThreadPriority', iptrw);
    RegisterProperty('StoredProps', 'TStoredProps', iptrw);
    RegisterProperty('Connected', 'Boolean', iptrw);
    RegisterProperty('BaudRate', 'TBaudRate', iptrw);
    RegisterProperty('CustomBaudRate', 'Integer', iptrw);
    RegisterProperty('Port', 'TPort', iptrw);
    RegisterProperty('Parity', 'TComParity', iptrw);
    RegisterProperty('StopBits', 'TStopBits', iptrw);
    RegisterProperty('DataBits', 'TDataBits', iptrw);
    RegisterProperty('DiscardNull', 'Boolean', iptrw);
    RegisterProperty('EventChar', 'Char', iptrw);
    RegisterProperty('Events', 'TComEvents', iptrw);
    RegisterProperty('Buffer', 'TComBuffer', iptrw);
    RegisterProperty('FlowControl', 'TComFlowControl', iptrw);
    RegisterProperty('Timeouts', 'TComTimeouts', iptrw);
    RegisterProperty('SyncMethod', 'TSyncMethod', iptrw);
    RegisterProperty('OnAfterOpen', 'TNotifyEvent', iptrw);
    RegisterProperty('OnAfterClose', 'TNotifyEvent', iptrw);
    RegisterProperty('OnBeforeOpen', 'TNotifyEvent', iptrw);
    RegisterProperty('OnBeforeClose', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRxChar', 'TRxCharEvent', iptrw);
    RegisterProperty('OnRxBuf', 'TRxBufEvent', iptrw);
    RegisterProperty('OnTxEmpty', 'TNotifyEvent', iptrw);
    RegisterProperty('OnBreak', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRing', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCTSChange', 'TComSignalEvent', iptrw);
    RegisterProperty('OnDSRChange', 'TComSignalEvent', iptrw);
    RegisterProperty('OnRLSDChange', 'TComSignalEvent', iptrw);
    RegisterProperty('OnRxFlag', 'TNotifyEvent', iptrw);
    RegisterProperty('OnError', 'TComErrorEvent', iptrw);
    RegisterProperty('OnRx80Full', 'TNotifyEvent', iptrw);
    RegisterProperty('OnException', 'TComExceptionEvent', iptrw);
    RegisterProperty('CodePage', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TComBuffer') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TComBuffer') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('ComPort', 'TCustomComPort', iptr);
    RegisterProperty('InputSize', 'Integer', iptrw);
    RegisterProperty('OutputSize', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComParity(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TComParity') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TComParity') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('ComPort', 'TCustomComPort', iptr);
    RegisterProperty('Bits', 'TParityBits', iptrw);
    RegisterProperty('Check', 'Boolean', iptrw);
    RegisterProperty('Replace', 'Boolean', iptrw);
    RegisterProperty('ReplaceChar', 'Char', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComFlowControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TComFlowControl') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TComFlowControl') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('ComPort', 'TCustomComPort', iptr);
    RegisterProperty('FlowControl', 'TFlowControl', iptrw);
    RegisterProperty('OutCTSFlow', 'Boolean', iptrw);
    RegisterProperty('OutDSRFlow', 'Boolean', iptrw);
    RegisterProperty('ControlDTR', 'TDTRFlowControl', iptrw);
    RegisterProperty('ControlRTS', 'TRTSFlowControl', iptrw);
    RegisterProperty('XonXoffOut', 'Boolean', iptrw);
    RegisterProperty('XonXoffIn', 'Boolean', iptrw);
    RegisterProperty('DSRSensitivity', 'Boolean', iptrw);
    RegisterProperty('TxContinueOnXoff', 'Boolean', iptrw);
    RegisterProperty('XonChar', 'Char', iptrw);
    RegisterProperty('XoffChar', 'Char', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComTimeouts(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TComTimeouts') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TComTimeouts') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('ComPort', 'TCustomComPort', iptr);
    RegisterProperty('ReadInterval', 'Integer', iptrw);
    RegisterProperty('ReadTotalMultiplier', 'Integer', iptrw);
    RegisterProperty('ReadTotalConstant', 'Integer', iptrw);
    RegisterProperty('WriteTotalMultiplier', 'Integer', iptrw);
    RegisterProperty('WriteTotalConstant', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TComThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TComThread') do begin
    RegisterMethod('Constructor Create( AComPort : TCustomComPort)');
  RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TComLink') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TComLink') do begin
    RegisterProperty('OnConn', 'TComSignalEvent', iptrw);
    RegisterProperty('OnRxBuf', 'TRxBufEvent', iptrw);
    RegisterProperty('OnTxBuf', 'TRxBufEvent', iptrw);
    RegisterProperty('OnTxEmpty', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRxFlag', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCTSChange', 'TComSignalEvent', iptrw);
    RegisterProperty('OnDSRChange', 'TComSignalEvent', iptrw);
    RegisterProperty('OnRLSDChange', 'TComSignalEvent', iptrw);
    RegisterProperty('OnRing', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTx', 'TComSignalEvent', iptrw);
    RegisterProperty('OnRx', 'TComSignalEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CPort(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TComExceptions', '( CE_OpenFailed, CE_WriteFailed, CE_ReadFailed'
   +', CE_InvalidAsync, CE_PurgeFailed, CE_AsyncCheck, CE_SetStateFailed, CE_Ti'
   +'meoutsFailed, CE_SetupComFailed, CE_ClearComFailed, CE_ModemStatFailed, CE'
   +'_EscapeComFailed, CE_TransmitFailed, CE_ConnChangeProp, CE_EnumPortsFailed'
   +', CE_StoreFailed, CE_LoadFailed, CE_RegFailed, CE_LedStateFailed, CE_Threa'
   +'dCreated, CE_WaitFailed, CE_HasLink, CE_RegError, CEPortNotOpen )');
  CL.AddTypeS('TPort', 'string');
  CL.AddTypeS('TBaudRate', '( brCustom, br110, br300, br600, br1200, br2400, br'
   +'4800, br9600, br14400, br19200, br38400, br56000, br57600, br115200, br128000, br256000 )');
  CL.AddTypeS('TStopBits', '( sbOneStopBit, sbOne5StopBits, sbTwoStopBits )');
  CL.AddTypeS('TDataBits', '( dbFive, dbSix, dbSeven, dbEight )');
  CL.AddTypeS('TParityBits', '( prNone, prOdd, prEven, prMark, prSpace )');
  CL.AddTypeS('TDTRFlowControl', '( dtrDisable, dtrEnable, dtrHandshake )');
  CL.AddTypeS('TRTSFlowControl', '( rtsDisable, rtsEnable, rtsHandshake, rtsToggle )');
  CL.AddTypeS('TFlowControl', '( fcHardware, fcSoftware, fcNone, fcCustom )');
  CL.AddTypeS('TComEvent', '( evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, e'
   +'vCTS, evDSR, evError, evRLSD, evRx80Full )');
  CL.AddTypeS('TComEvents', 'set of TComEvent');
  CL.AddTypeS('TComSignal', '( csCTS, csDSR, csRing, csRLSD )');
  CL.AddTypeS('TComSignals', 'set of TComSignal');
  CL.AddTypeS('TComError', '( ceFrame, ceRxParity, ceOverrun, ceBreak, ceIO, ce'
   +'Mode, ceRxOver, ceTxFull )');
  CL.AddTypeS('TComErrors', 'set of TComError');
  CL.AddTypeS('TSyncMethod', '( smThreadSync, smWindowSync, smNone )');
  CL.AddTypeS('TStoreType', '( stRegistry, stIniFile )');
  CL.AddTypeS('TStoredProp', '( spBasic, spFlowControl, spBuffer, spTimeouts, s'
   +'pParity, spOthers )');
  CL.AddTypeS('TStoredProps', 'set of TStoredProp');
  CL.AddTypeS('TComLinkEvent', '( leConn, leCTS, leDSR, leRLSD, leRing, leRx, l'
   +'eTx, leTxEmpty, leRxFlag )');
  CL.AddTypeS('TRxCharEvent', 'Procedure ( Sender : TObject; Count : Integer)');
  CL.AddTypeS('TRxBufEvent', 'Procedure ( Sender : TObject; const Buffer, Count: Integer)');
  CL.AddTypeS('TComErrorEvent', 'Procedure ( Sender : TObject; Errors : TComErrors)');
  CL.AddTypeS('TComSignalEvent', 'Procedure ( Sender : TObject; OnOff : Boolean)');
  CL.AddTypeS('TComExceptionEvent', 'Procedure ( Sender : TObject; TComExceptio'
   +'n : TComExceptions; ComportMessage : String; WinError : Int64; WinMessage: String)');
  CL.AddTypeS('TOperationKind', '( okWrite, okRead )');
  CL.AddTypeS('_OVERLAPPED', 'record Internal : DWORD; InternalHigh : DWORD; Of'
   +'fset : DWORD; OffsetHigh : DWORD; hEvent : THandle; end');
  CL.AddTypeS('TOverlapped', '_OVERLAPPED');
  CL.AddTypeS('TAsync', 'record Overlapped : TOverlapped; Kind : TOperationKind'
   +'; Data : ___Pointer; Size : Integer; end');
  //CL.AddTypeS('PAsync', '^TAsync // will not work');
  //CL.AddTypeS('UnicodeString', 'Widestring');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomComPort');
  SIRegister_TComLink(CL);
  SIRegister_TComThread(CL);
  SIRegister_TComTimeouts(CL);
  SIRegister_TComFlowControl(CL);
  SIRegister_TComParity(CL);
  SIRegister_TComBuffer(CL);
  SIRegister_TCustomComPort(CL);
  SIRegister_TComPort(CL);
  CL.AddTypeS('TComStrEvent', 'Procedure ( Sender : TObject; const Str : string)');
  CL.AddTypeS('TCustPacketEvent', 'Procedure (Sender: TObject; const Str: string; var Pos : Integer)');
  SIRegister_TComDataPacket(CL);
  SIRegister_TComStream(CL);
  SIRegister_EComPort(CL);
 //CL.AddDelphiFunction('Procedure InitAsync( var AsyncPtr : PAsync)');
 //CL.AddDelphiFunction('Procedure DoneAsync( var AsyncPtr : PAsync)');
 CL.AddDelphiFunction('Procedure EnumComPorts( Ports : TStrings)');
 CL.AddDelphiFunction('Procedure ListComPorts( Ports : TStrings)');
 CL.AddDelphiFunction('Procedure ComPorts( Ports : TStrings)');
 CL.AddDelphiFunction('Function GetComPorts: TStringlist');

 CL.AddDelphiFunction('Function StrToBaudRate( Str : string) : TBaudRate');
 CL.AddDelphiFunction('Function StrToStopBits( Str : string) : TStopBits');
 CL.AddDelphiFunction('Function StrToDataBits( Str : string) : TDataBits');
 CL.AddDelphiFunction('Function StrToParity( Str : string) : TParityBits');
 CL.AddDelphiFunction('Function StrToFlowControl( Str : string) : TFlowControl');
 CL.AddDelphiFunction('Function BaudRateToStr( BaudRate : TBaudRate) : string');
 CL.AddDelphiFunction('Function StopBitsToStr( StopBits : TStopBits) : string');
 CL.AddDelphiFunction('Function DataBitsToStr( DataBits : TDataBits) : string');
 CL.AddDelphiFunction('Function ParityToStr( Parity : TParityBits) : string');
 CL.AddDelphiFunction('Function FlowControlToStr( FlowControl : TFlowControl) : string');
 CL.AddDelphiFunction('Function ComErrorsToStr( Errors : TComErrors) : String');
 CL.AddConstantN('CError_OpenFailed','LongInt').SetInt( 1);
 CL.AddConstantN('CError_WriteFailed','LongInt').SetInt( 2);
 CL.AddConstantN('CError_ReadFailed','LongInt').SetInt( 3);
 CL.AddConstantN('CError_InvalidAsync','LongInt').SetInt( 4);
 CL.AddConstantN('CError_PurgeFailed','LongInt').SetInt( 5);
 CL.AddConstantN('CError_AsyncCheck','LongInt').SetInt( 6);
 CL.AddConstantN('CError_SetStateFailed','LongInt').SetInt( 7);
 CL.AddConstantN('CError_TimeoutsFailed','LongInt').SetInt( 8);
 CL.AddConstantN('CError_SetupComFailed','LongInt').SetInt( 9);
 CL.AddConstantN('CError_ClearComFailed','LongInt').SetInt( 10);
 CL.AddConstantN('CError_ModemStatFailed','LongInt').SetInt( 11);
 CL.AddConstantN('CError_EscapeComFailed','LongInt').SetInt( 12);
 CL.AddConstantN('CError_TransmitFailed','LongInt').SetInt( 13);
 CL.AddConstantN('CError_ConnChangeProp','LongInt').SetInt( 14);
 CL.AddConstantN('CError_EnumPortsFailed','LongInt').SetInt( 15);
 CL.AddConstantN('CError_StoreFailed','LongInt').SetInt( 16);
 CL.AddConstantN('CError_LoadFailed','LongInt').SetInt( 17);
 CL.AddConstantN('CError_RegFailed','LongInt').SetInt( 18);
 CL.AddConstantN('CError_LedStateFailed','LongInt').SetInt( 19);
 CL.AddConstantN('CError_ThreadCreated','LongInt').SetInt( 20);
 CL.AddConstantN('CError_WaitFailed','LongInt').SetInt( 21);
 CL.AddConstantN('CError_HasLink','LongInt').SetInt( 22);
 CL.AddConstantN('CError_RegError','LongInt').SetInt( 23);
 CL.AddConstantN('CError_PortNotOpen','LongInt').SetInt( 24);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure EComPortCode_W(Self: EComPort; const T: Integer);
begin Self.Code := T; end;

(*----------------------------------------------------------------------------*)
procedure EComPortCode_R(Self: EComPort; var T: Integer);
begin T := Self.Code; end;

(*----------------------------------------------------------------------------*)
procedure EComPortWinCode_W(Self: EComPort; const T: Integer);
begin Self.WinCode := T; end;

(*----------------------------------------------------------------------------*)
procedure EComPortWinCode_R(Self: EComPort; var T: Integer);
begin T := Self.WinCode; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketOnCustomStop_W(Self: TComDataPacket; const T: TCustPacketEvent);
begin Self.OnCustomStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketOnCustomStop_R(Self: TComDataPacket; var T: TCustPacketEvent);
begin T := Self.OnCustomStop; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketOnCustomStart_W(Self: TComDataPacket; const T: TCustPacketEvent);
begin Self.OnCustomStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketOnCustomStart_R(Self: TComDataPacket; var T: TCustPacketEvent);
begin T := Self.OnCustomStart; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketOnPacket_W(Self: TComDataPacket; const T: TComStrEvent);
begin Self.OnPacket := T; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketOnPacket_R(Self: TComDataPacket; var T: TComStrEvent);
begin T := Self.OnPacket; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketOnDiscard_W(Self: TComDataPacket; const T: TComStrEvent);
begin Self.OnDiscard := T; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketOnDiscard_R(Self: TComDataPacket; var T: TComStrEvent);
begin T := Self.OnDiscard; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketSize_W(Self: TComDataPacket; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketSize_R(Self: TComDataPacket; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketStopString_W(Self: TComDataPacket; const T: string);
begin Self.StopString := T; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketStopString_R(Self: TComDataPacket; var T: string);
begin T := Self.StopString; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketStartString_W(Self: TComDataPacket; const T: string);
begin Self.StartString := T; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketStartString_R(Self: TComDataPacket; var T: string);
begin T := Self.StartString; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketMaxBufferSize_W(Self: TComDataPacket; const T: Integer);
begin Self.MaxBufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketMaxBufferSize_R(Self: TComDataPacket; var T: Integer);
begin T := Self.MaxBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketIncludeStrings_W(Self: TComDataPacket; const T: Boolean);
begin Self.IncludeStrings := T; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketIncludeStrings_R(Self: TComDataPacket; var T: Boolean);
begin T := Self.IncludeStrings; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketCaseInsensitive_W(Self: TComDataPacket; const T: Boolean);
begin Self.CaseInsensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketCaseInsensitive_R(Self: TComDataPacket; var T: Boolean);
begin T := Self.CaseInsensitive; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketComPort_W(Self: TComDataPacket; const T: TCustomComPort);
begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TComDataPacketComPort_R(Self: TComDataPacket; var T: TCustomComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortCodePage_W(Self: TCustomComPort; const T: Cardinal);
begin Self.CodePage := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortCodePage_R(Self: TCustomComPort; var T: Cardinal);
begin T := Self.CodePage; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnException_W(Self: TCustomComPort; const T: TComExceptionEvent);
begin Self.OnException := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnException_R(Self: TCustomComPort; var T: TComExceptionEvent);
begin T := Self.OnException; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRx80Full_W(Self: TCustomComPort; const T: TNotifyEvent);
begin Self.OnRx80Full := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRx80Full_R(Self: TCustomComPort; var T: TNotifyEvent);
begin T := Self.OnRx80Full; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnError_W(Self: TCustomComPort; const T: TComErrorEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnError_R(Self: TCustomComPort; var T: TComErrorEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRxFlag_W(Self: TCustomComPort; const T: TNotifyEvent);
begin Self.OnRxFlag := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRxFlag_R(Self: TCustomComPort; var T: TNotifyEvent);
begin T := Self.OnRxFlag; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRLSDChange_W(Self: TCustomComPort; const T: TComSignalEvent);
begin Self.OnRLSDChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRLSDChange_R(Self: TCustomComPort; var T: TComSignalEvent);
begin T := Self.OnRLSDChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnDSRChange_W(Self: TCustomComPort; const T: TComSignalEvent);
begin Self.OnDSRChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnDSRChange_R(Self: TCustomComPort; var T: TComSignalEvent);
begin T := Self.OnDSRChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnCTSChange_W(Self: TCustomComPort; const T: TComSignalEvent);
begin Self.OnCTSChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnCTSChange_R(Self: TCustomComPort; var T: TComSignalEvent);
begin T := Self.OnCTSChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRing_W(Self: TCustomComPort; const T: TNotifyEvent);
begin Self.OnRing := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRing_R(Self: TCustomComPort; var T: TNotifyEvent);
begin T := Self.OnRing; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnBreak_W(Self: TCustomComPort; const T: TNotifyEvent);
begin Self.OnBreak := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnBreak_R(Self: TCustomComPort; var T: TNotifyEvent);
begin T := Self.OnBreak; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnTxEmpty_W(Self: TCustomComPort; const T: TNotifyEvent);
begin Self.OnTxEmpty := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnTxEmpty_R(Self: TCustomComPort; var T: TNotifyEvent);
begin T := Self.OnTxEmpty; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRxBuf_W(Self: TCustomComPort; const T: TRxBufEvent);
begin Self.OnRxBuf := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRxBuf_R(Self: TCustomComPort; var T: TRxBufEvent);
begin T := Self.OnRxBuf; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRxChar_W(Self: TCustomComPort; const T: TRxCharEvent);
begin Self.OnRxChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnRxChar_R(Self: TCustomComPort; var T: TRxCharEvent);
begin T := Self.OnRxChar; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnBeforeClose_W(Self: TCustomComPort; const T: TNotifyEvent);
begin Self.OnBeforeClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnBeforeClose_R(Self: TCustomComPort; var T: TNotifyEvent);
begin T := Self.OnBeforeClose; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnBeforeOpen_W(Self: TCustomComPort; const T: TNotifyEvent);
begin Self.OnBeforeOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnBeforeOpen_R(Self: TCustomComPort; var T: TNotifyEvent);
begin T := Self.OnBeforeOpen; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnAfterClose_W(Self: TCustomComPort; const T: TNotifyEvent);
begin Self.OnAfterClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnAfterClose_R(Self: TCustomComPort; var T: TNotifyEvent);
begin T := Self.OnAfterClose; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnAfterOpen_W(Self: TCustomComPort; const T: TNotifyEvent);
begin Self.OnAfterOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortOnAfterOpen_R(Self: TCustomComPort; var T: TNotifyEvent);
begin T := Self.OnAfterOpen; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortSyncMethod_W(Self: TCustomComPort; const T: TSyncMethod);
begin Self.SyncMethod := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortSyncMethod_R(Self: TCustomComPort; var T: TSyncMethod);
begin T := Self.SyncMethod; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortTimeouts_W(Self: TCustomComPort; const T: TComTimeouts);
begin Self.Timeouts := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortTimeouts_R(Self: TCustomComPort; var T: TComTimeouts);
begin T := Self.Timeouts; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortFlowControl_W(Self: TCustomComPort; const T: TComFlowControl);
begin Self.FlowControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortFlowControl_R(Self: TCustomComPort; var T: TComFlowControl);
begin T := Self.FlowControl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortBuffer_W(Self: TCustomComPort; const T: TComBuffer);
begin Self.Buffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortBuffer_R(Self: TCustomComPort; var T: TComBuffer);
begin T := Self.Buffer; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortEvents_W(Self: TCustomComPort; const T: TComEvents);
begin Self.Events := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortEvents_R(Self: TCustomComPort; var T: TComEvents);
begin T := Self.Events; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortEventChar_W(Self: TCustomComPort; const T: Char);
begin Self.EventChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortEventChar_R(Self: TCustomComPort; var T: Char);
begin T := Self.EventChar; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortDiscardNull_W(Self: TCustomComPort; const T: Boolean);
begin Self.DiscardNull := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortDiscardNull_R(Self: TCustomComPort; var T: Boolean);
begin T := Self.DiscardNull; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortDataBits_W(Self: TCustomComPort; const T: TDataBits);
begin Self.DataBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortDataBits_R(Self: TCustomComPort; var T: TDataBits);
begin T := Self.DataBits; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortStopBits_W(Self: TCustomComPort; const T: TStopBits);
begin Self.StopBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortStopBits_R(Self: TCustomComPort; var T: TStopBits);
begin T := Self.StopBits; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortParity_W(Self: TCustomComPort; const T: TComParity);
begin Self.Parity := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortParity_R(Self: TCustomComPort; var T: TComParity);
begin T := Self.Parity; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortPort_W(Self: TCustomComPort; const T: TPort);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortPort_R(Self: TCustomComPort; var T: TPort);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortCustomBaudRate_W(Self: TCustomComPort; const T: Integer);
begin Self.CustomBaudRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortCustomBaudRate_R(Self: TCustomComPort; var T: Integer);
begin T := Self.CustomBaudRate; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortBaudRate_W(Self: TCustomComPort; const T: TBaudRate);
begin Self.BaudRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortBaudRate_R(Self: TCustomComPort; var T: TBaudRate);
begin T := Self.BaudRate; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortConnected_W(Self: TCustomComPort; const T: Boolean);
begin Self.Connected := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortConnected_R(Self: TCustomComPort; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortStoredProps_W(Self: TCustomComPort; const T: TStoredProps);
begin Self.StoredProps := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortStoredProps_R(Self: TCustomComPort; var T: TStoredProps);
begin T := Self.StoredProps; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortEventThreadPriority_W(Self: TCustomComPort; const T: TThreadPriority);
begin Self.EventThreadPriority := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortEventThreadPriority_R(Self: TCustomComPort; var T: TThreadPriority);
begin T := Self.EventThreadPriority; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortTriggersOnRxChar_W(Self: TCustomComPort; const T: Boolean);
begin Self.TriggersOnRxChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortTriggersOnRxChar_R(Self: TCustomComPort; var T: Boolean);
begin T := Self.TriggersOnRxChar; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComPortHandle_R(Self: TCustomComPort; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TComBufferOutputSize_W(Self: TComBuffer; const T: Integer);
begin Self.OutputSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TComBufferOutputSize_R(Self: TComBuffer; var T: Integer);
begin T := Self.OutputSize; end;

(*----------------------------------------------------------------------------*)
procedure TComBufferInputSize_W(Self: TComBuffer; const T: Integer);
begin Self.InputSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TComBufferInputSize_R(Self: TComBuffer; var T: Integer);
begin T := Self.InputSize; end;

(*----------------------------------------------------------------------------*)
procedure TComBufferComPort_R(Self: TComBuffer; var T: TCustomComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TComParityReplaceChar_W(Self: TComParity; const T: Char);
begin Self.ReplaceChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TComParityReplaceChar_R(Self: TComParity; var T: Char);
begin T := Self.ReplaceChar; end;

(*----------------------------------------------------------------------------*)
procedure TComParityReplace_W(Self: TComParity; const T: Boolean);
begin Self.Replace := T; end;

(*----------------------------------------------------------------------------*)
procedure TComParityReplace_R(Self: TComParity; var T: Boolean);
begin T := Self.Replace; end;

(*----------------------------------------------------------------------------*)
procedure TComParityCheck_W(Self: TComParity; const T: Boolean);
begin Self.Check := T; end;

(*----------------------------------------------------------------------------*)
procedure TComParityCheck_R(Self: TComParity; var T: Boolean);
begin T := Self.Check; end;

(*----------------------------------------------------------------------------*)
procedure TComParityBits_W(Self: TComParity; const T: TParityBits);
begin Self.Bits := T; end;

(*----------------------------------------------------------------------------*)
procedure TComParityBits_R(Self: TComParity; var T: TParityBits);
begin T := Self.Bits; end;

(*----------------------------------------------------------------------------*)
procedure TComParityComPort_R(Self: TComParity; var T: TCustomComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlXoffChar_W(Self: TComFlowControl; const T: Char);
begin Self.XoffChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlXoffChar_R(Self: TComFlowControl; var T: Char);
begin T := Self.XoffChar; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlXonChar_W(Self: TComFlowControl; const T: Char);
begin Self.XonChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlXonChar_R(Self: TComFlowControl; var T: Char);
begin T := Self.XonChar; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlTxContinueOnXoff_W(Self: TComFlowControl; const T: Boolean);
begin Self.TxContinueOnXoff := T; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlTxContinueOnXoff_R(Self: TComFlowControl; var T: Boolean);
begin T := Self.TxContinueOnXoff; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlDSRSensitivity_W(Self: TComFlowControl; const T: Boolean);
begin Self.DSRSensitivity := T; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlDSRSensitivity_R(Self: TComFlowControl; var T: Boolean);
begin T := Self.DSRSensitivity; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlXonXoffIn_W(Self: TComFlowControl; const T: Boolean);
begin Self.XonXoffIn := T; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlXonXoffIn_R(Self: TComFlowControl; var T: Boolean);
begin T := Self.XonXoffIn; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlXonXoffOut_W(Self: TComFlowControl; const T: Boolean);
begin Self.XonXoffOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlXonXoffOut_R(Self: TComFlowControl; var T: Boolean);
begin T := Self.XonXoffOut; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlControlRTS_W(Self: TComFlowControl; const T: TRTSFlowControl);
begin Self.ControlRTS := T; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlControlRTS_R(Self: TComFlowControl; var T: TRTSFlowControl);
begin T := Self.ControlRTS; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlControlDTR_W(Self: TComFlowControl; const T: TDTRFlowControl);
begin Self.ControlDTR := T; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlControlDTR_R(Self: TComFlowControl; var T: TDTRFlowControl);
begin T := Self.ControlDTR; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlOutDSRFlow_W(Self: TComFlowControl; const T: Boolean);
begin Self.OutDSRFlow := T; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlOutDSRFlow_R(Self: TComFlowControl; var T: Boolean);
begin T := Self.OutDSRFlow; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlOutCTSFlow_W(Self: TComFlowControl; const T: Boolean);
begin Self.OutCTSFlow := T; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlOutCTSFlow_R(Self: TComFlowControl; var T: Boolean);
begin T := Self.OutCTSFlow; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlFlowControl_W(Self: TComFlowControl; const T: TFlowControl);
begin Self.FlowControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlFlowControl_R(Self: TComFlowControl; var T: TFlowControl);
begin T := Self.FlowControl; end;

(*----------------------------------------------------------------------------*)
procedure TComFlowControlComPort_R(Self: TComFlowControl; var T: TCustomComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TComTimeoutsWriteTotalConstant_W(Self: TComTimeouts; const T: Integer);
begin Self.WriteTotalConstant := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTimeoutsWriteTotalConstant_R(Self: TComTimeouts; var T: Integer);
begin T := Self.WriteTotalConstant; end;

(*----------------------------------------------------------------------------*)
procedure TComTimeoutsWriteTotalMultiplier_W(Self: TComTimeouts; const T: Integer);
begin Self.WriteTotalMultiplier := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTimeoutsWriteTotalMultiplier_R(Self: TComTimeouts; var T: Integer);
begin T := Self.WriteTotalMultiplier; end;

(*----------------------------------------------------------------------------*)
procedure TComTimeoutsReadTotalConstant_W(Self: TComTimeouts; const T: Integer);
begin Self.ReadTotalConstant := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTimeoutsReadTotalConstant_R(Self: TComTimeouts; var T: Integer);
begin T := Self.ReadTotalConstant; end;

(*----------------------------------------------------------------------------*)
procedure TComTimeoutsReadTotalMultiplier_W(Self: TComTimeouts; const T: Integer);
begin Self.ReadTotalMultiplier := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTimeoutsReadTotalMultiplier_R(Self: TComTimeouts; var T: Integer);
begin T := Self.ReadTotalMultiplier; end;

(*----------------------------------------------------------------------------*)
procedure TComTimeoutsReadInterval_W(Self: TComTimeouts; const T: Integer);
begin Self.ReadInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TComTimeoutsReadInterval_R(Self: TComTimeouts; var T: Integer);
begin T := Self.ReadInterval; end;

(*----------------------------------------------------------------------------*)
procedure TComTimeoutsComPort_R(Self: TComTimeouts; var T: TCustomComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnRx_W(Self: TComLink; const T: TComSignalEvent);
begin Self.OnRx := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnRx_R(Self: TComLink; var T: TComSignalEvent);
begin T := Self.OnRx; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnTx_W(Self: TComLink; const T: TComSignalEvent);
begin Self.OnTx := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnTx_R(Self: TComLink; var T: TComSignalEvent);
begin T := Self.OnTx; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnRing_W(Self: TComLink; const T: TNotifyEvent);
begin Self.OnRing := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnRing_R(Self: TComLink; var T: TNotifyEvent);
begin T := Self.OnRing; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnRLSDChange_W(Self: TComLink; const T: TComSignalEvent);
begin Self.OnRLSDChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnRLSDChange_R(Self: TComLink; var T: TComSignalEvent);
begin T := Self.OnRLSDChange; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnDSRChange_W(Self: TComLink; const T: TComSignalEvent);
begin Self.OnDSRChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnDSRChange_R(Self: TComLink; var T: TComSignalEvent);
begin T := Self.OnDSRChange; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnCTSChange_W(Self: TComLink; const T: TComSignalEvent);
begin Self.OnCTSChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnCTSChange_R(Self: TComLink; var T: TComSignalEvent);
begin T := Self.OnCTSChange; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnRxFlag_W(Self: TComLink; const T: TNotifyEvent);
begin Self.OnRxFlag := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnRxFlag_R(Self: TComLink; var T: TNotifyEvent);
begin T := Self.OnRxFlag; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnTxEmpty_W(Self: TComLink; const T: TNotifyEvent);
begin Self.OnTxEmpty := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnTxEmpty_R(Self: TComLink; var T: TNotifyEvent);
begin T := Self.OnTxEmpty; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnTxBuf_W(Self: TComLink; const T: TRxBufEvent);
begin Self.OnTxBuf := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnTxBuf_R(Self: TComLink; var T: TRxBufEvent);
begin T := Self.OnTxBuf; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnRxBuf_W(Self: TComLink; const T: TRxBufEvent);
begin Self.OnRxBuf := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnRxBuf_R(Self: TComLink; var T: TRxBufEvent);
begin T := Self.OnRxBuf; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnConn_W(Self: TComLink; const T: TComSignalEvent);
begin Self.OnConn := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLinkOnConn_R(Self: TComLink; var T: TComSignalEvent);
begin T := Self.OnConn; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CPort_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitAsync, 'InitAsync', cdRegister);
 S.RegisterDelphiFunction(@DoneAsync, 'DoneAsync', cdRegister);
 S.RegisterDelphiFunction(@EnumComPorts, 'EnumComPorts', cdRegister);
 S.RegisterDelphiFunction(@EnumComPorts, 'ListComPorts', cdRegister);
 S.RegisterDelphiFunction(@EnumComPorts, 'ComPorts', cdRegister);
 S.RegisterDelphiFunction(@StrToBaudRate, 'StrToBaudRate', cdRegister);
 S.RegisterDelphiFunction(@GetComPorts, 'GetComPorts', cdRegister);

 S.RegisterDelphiFunction(@StrToStopBits, 'StrToStopBits', cdRegister);
 S.RegisterDelphiFunction(@StrToDataBits, 'StrToDataBits', cdRegister);
 S.RegisterDelphiFunction(@StrToParity, 'StrToParity', cdRegister);
 S.RegisterDelphiFunction(@StrToFlowControl, 'StrToFlowControl', cdRegister);
 S.RegisterDelphiFunction(@BaudRateToStr, 'BaudRateToStr', cdRegister);
 S.RegisterDelphiFunction(@StopBitsToStr, 'StopBitsToStr', cdRegister);
 S.RegisterDelphiFunction(@DataBitsToStr, 'DataBitsToStr', cdRegister);
 S.RegisterDelphiFunction(@ParityToStr, 'ParityToStr', cdRegister);
 S.RegisterDelphiFunction(@FlowControlToStr, 'FlowControlToStr', cdRegister);
 S.RegisterDelphiFunction(@ComErrorsToStr, 'ComErrorsToStr', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EComPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EComPort) do begin
    RegisterConstructor(@EComPort.Create, 'Create');
    RegisterConstructor(@EComPort.CreateNoWinCode, 'CreateNoWinCode');
    RegisterPropertyHelper(@EComPortWinCode_R,@EComPortWinCode_W,'WinCode');
    RegisterPropertyHelper(@EComPortCode_R,@EComPortCode_W,'Code');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComStream) do begin
    RegisterConstructor(@TComStream.Create, 'Create');
    RegisterMethod(@TComStream.Read, 'Read');
    RegisterMethod(@TComStream.Write, 'Write');
    RegisterMethod(@TComStream.Seek, 'Seek');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComDataPacket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComDataPacket) do begin
    RegisterConstructor(@TComDataPacket.Create, 'Create');
   RegisterMethod(@TComDataPacket.Destroy, 'Free');
    RegisterMethod(@TComDataPacket.AddData, 'AddData');
    RegisterMethod(@TComDataPacket.ResetBuffer, 'ResetBuffer');
    RegisterPropertyHelper(@TComDataPacketComPort_R,@TComDataPacketComPort_W,'ComPort');
    RegisterPropertyHelper(@TComDataPacketCaseInsensitive_R,@TComDataPacketCaseInsensitive_W,'CaseInsensitive');
    RegisterPropertyHelper(@TComDataPacketIncludeStrings_R,@TComDataPacketIncludeStrings_W,'IncludeStrings');
    RegisterPropertyHelper(@TComDataPacketMaxBufferSize_R,@TComDataPacketMaxBufferSize_W,'MaxBufferSize');
    RegisterPropertyHelper(@TComDataPacketStartString_R,@TComDataPacketStartString_W,'StartString');
    RegisterPropertyHelper(@TComDataPacketStopString_R,@TComDataPacketStopString_W,'StopString');
    RegisterPropertyHelper(@TComDataPacketSize_R,@TComDataPacketSize_W,'Size');
    RegisterPropertyHelper(@TComDataPacketOnDiscard_R,@TComDataPacketOnDiscard_W,'OnDiscard');
    RegisterPropertyHelper(@TComDataPacketOnPacket_R,@TComDataPacketOnPacket_W,'OnPacket');
    RegisterPropertyHelper(@TComDataPacketOnCustomStart_R,@TComDataPacketOnCustomStart_W,'OnCustomStart');
    RegisterPropertyHelper(@TComDataPacketOnCustomStop_R,@TComDataPacketOnCustomStop_W,'OnCustomStop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComPort) do begin
    //RegisterPublishedProperties;
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomComPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomComPort) do begin
    RegisterConstructor(@TCustomComPort.Create, 'Create');
    RegisterMethod(@TCustomComPort.Destroy, 'Free');
    RegisterMethod(@TCustomComPort.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TCustomComPort.EndUpdate, 'EndUpdate');
    RegisterMethod(@TCustomComPort.StoreSettings, 'StoreSettings');
    RegisterMethod(@TCustomComPort.LoadSettings, 'LoadSettings');
    RegisterMethod(@TCustomComPort.Open, 'Open');
    RegisterMethod(@TCustomComPort.Close, 'Close');
    RegisterMethod(@TCustomComPort.ShowSetupDialog, 'ShowSetupDialog');
    RegisterMethod(@TCustomComPort.InputCount, 'InputCount');
    RegisterMethod(@TCustomComPort.OutputCount, 'OutputCount');
    RegisterMethod(@TCustomComPort.Signals, 'Signals');
    RegisterMethod(@TCustomComPort.StateFlags, 'StateFlags');
    RegisterMethod(@TCustomComPort.SetDTR, 'SetDTR');
    RegisterMethod(@TCustomComPort.SetRTS, 'SetRTS');
    RegisterMethod(@TCustomComPort.SetXonXoff, 'SetXonXoff');
    RegisterMethod(@TCustomComPort.SetBreak, 'SetBreak');
    RegisterMethod(@TCustomComPort.ClearBuffer, 'ClearBuffer');
    RegisterMethod(@TCustomComPort.LastErrors, 'LastErrors');
    RegisterMethod(@TCustomComPort.Write, 'Write');
    RegisterMethod(@TCustomComPort.WriteStr, 'WriteStr');
    RegisterMethod(@TCustomComPort.Read, 'Read');
    RegisterMethod(@TCustomComPort.ReadStr, 'ReadStr');
    RegisterMethod(@TCustomComPort.WriteAsync, 'WriteAsync');
    RegisterMethod(@TCustomComPort.WriteStrAsync, 'WriteStrAsync');
    RegisterMethod(@TCustomComPort.ReadAsync, 'ReadAsync');
    RegisterMethod(@TCustomComPort.ReadStrAsync, 'ReadStrAsync');
    RegisterMethod(@TCustomComPort.WriteUnicodeString, 'WriteUnicodeString');
    RegisterMethod(@TCustomComPort.ReadUnicodeString, 'ReadUnicodeString');
    RegisterMethod(@TCustomComPort.WaitForAsync, 'WaitForAsync');
    RegisterMethod(@TCustomComPort.IsAsyncCompleted, 'IsAsyncCompleted');
    RegisterMethod(@TCustomComPort.WaitForEvent, 'WaitForEvent');
    RegisterMethod(@TCustomComPort.AbortAllAsync, 'AbortAllAsync');
    RegisterMethod(@TCustomComPort.TransmitChar, 'TransmitChar');
    RegisterMethod(@TCustomComPort.RegisterLink, 'RegisterLink');
    RegisterMethod(@TCustomComPort.UnRegisterLink, 'UnRegisterLink');
    RegisterPropertyHelper(@TCustomComPortHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TCustomComPortTriggersOnRxChar_R,@TCustomComPortTriggersOnRxChar_W,'TriggersOnRxChar');
    RegisterPropertyHelper(@TCustomComPortEventThreadPriority_R,@TCustomComPortEventThreadPriority_W,'EventThreadPriority');
    RegisterPropertyHelper(@TCustomComPortStoredProps_R,@TCustomComPortStoredProps_W,'StoredProps');
    RegisterPropertyHelper(@TCustomComPortConnected_R,@TCustomComPortConnected_W,'Connected');
    RegisterPropertyHelper(@TCustomComPortBaudRate_R,@TCustomComPortBaudRate_W,'BaudRate');
    RegisterPropertyHelper(@TCustomComPortCustomBaudRate_R,@TCustomComPortCustomBaudRate_W,'CustomBaudRate');
    RegisterPropertyHelper(@TCustomComPortPort_R,@TCustomComPortPort_W,'Port');
    RegisterPropertyHelper(@TCustomComPortParity_R,@TCustomComPortParity_W,'Parity');
    RegisterPropertyHelper(@TCustomComPortStopBits_R,@TCustomComPortStopBits_W,'StopBits');
    RegisterPropertyHelper(@TCustomComPortDataBits_R,@TCustomComPortDataBits_W,'DataBits');
    RegisterPropertyHelper(@TCustomComPortDiscardNull_R,@TCustomComPortDiscardNull_W,'DiscardNull');
    RegisterPropertyHelper(@TCustomComPortEventChar_R,@TCustomComPortEventChar_W,'EventChar');
    RegisterPropertyHelper(@TCustomComPortEvents_R,@TCustomComPortEvents_W,'Events');
    RegisterPropertyHelper(@TCustomComPortBuffer_R,@TCustomComPortBuffer_W,'Buffer');
    RegisterPropertyHelper(@TCustomComPortFlowControl_R,@TCustomComPortFlowControl_W,'FlowControl');
    RegisterPropertyHelper(@TCustomComPortTimeouts_R,@TCustomComPortTimeouts_W,'Timeouts');
    RegisterPropertyHelper(@TCustomComPortSyncMethod_R,@TCustomComPortSyncMethod_W,'SyncMethod');
    RegisterPropertyHelper(@TCustomComPortOnAfterOpen_R,@TCustomComPortOnAfterOpen_W,'OnAfterOpen');
    RegisterPropertyHelper(@TCustomComPortOnAfterClose_R,@TCustomComPortOnAfterClose_W,'OnAfterClose');
    RegisterPropertyHelper(@TCustomComPortOnBeforeOpen_R,@TCustomComPortOnBeforeOpen_W,'OnBeforeOpen');
    RegisterPropertyHelper(@TCustomComPortOnBeforeClose_R,@TCustomComPortOnBeforeClose_W,'OnBeforeClose');
    RegisterPropertyHelper(@TCustomComPortOnRxChar_R,@TCustomComPortOnRxChar_W,'OnRxChar');
    RegisterPropertyHelper(@TCustomComPortOnRxBuf_R,@TCustomComPortOnRxBuf_W,'OnRxBuf');
    RegisterPropertyHelper(@TCustomComPortOnTxEmpty_R,@TCustomComPortOnTxEmpty_W,'OnTxEmpty');
    RegisterPropertyHelper(@TCustomComPortOnBreak_R,@TCustomComPortOnBreak_W,'OnBreak');
    RegisterPropertyHelper(@TCustomComPortOnRing_R,@TCustomComPortOnRing_W,'OnRing');
    RegisterPropertyHelper(@TCustomComPortOnCTSChange_R,@TCustomComPortOnCTSChange_W,'OnCTSChange');
    RegisterPropertyHelper(@TCustomComPortOnDSRChange_R,@TCustomComPortOnDSRChange_W,'OnDSRChange');
    RegisterPropertyHelper(@TCustomComPortOnRLSDChange_R,@TCustomComPortOnRLSDChange_W,'OnRLSDChange');
    RegisterPropertyHelper(@TCustomComPortOnRxFlag_R,@TCustomComPortOnRxFlag_W,'OnRxFlag');
    RegisterPropertyHelper(@TCustomComPortOnError_R,@TCustomComPortOnError_W,'OnError');
    RegisterPropertyHelper(@TCustomComPortOnRx80Full_R,@TCustomComPortOnRx80Full_W,'OnRx80Full');
    RegisterPropertyHelper(@TCustomComPortOnException_R,@TCustomComPortOnException_W,'OnException');
    RegisterPropertyHelper(@TCustomComPortCodePage_R,@TCustomComPortCodePage_W,'CodePage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComBuffer) do
  begin
    RegisterConstructor(@TComBuffer.Create, 'Create');
    RegisterPropertyHelper(@TComBufferComPort_R,nil,'ComPort');
    RegisterPropertyHelper(@TComBufferInputSize_R,@TComBufferInputSize_W,'InputSize');
    RegisterPropertyHelper(@TComBufferOutputSize_R,@TComBufferOutputSize_W,'OutputSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComParity(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComParity) do begin
    RegisterConstructor(@TComParity.Create, 'Create');
    RegisterPropertyHelper(@TComParityComPort_R,nil,'ComPort');
    RegisterPropertyHelper(@TComParityBits_R,@TComParityBits_W,'Bits');
    RegisterPropertyHelper(@TComParityCheck_R,@TComParityCheck_W,'Check');
    RegisterPropertyHelper(@TComParityReplace_R,@TComParityReplace_W,'Replace');
    RegisterPropertyHelper(@TComParityReplaceChar_R,@TComParityReplaceChar_W,'ReplaceChar');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComFlowControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComFlowControl) do begin
    RegisterConstructor(@TComFlowControl.Create, 'Create');
    RegisterPropertyHelper(@TComFlowControlComPort_R,nil,'ComPort');
    RegisterPropertyHelper(@TComFlowControlFlowControl_R,@TComFlowControlFlowControl_W,'FlowControl');
    RegisterPropertyHelper(@TComFlowControlOutCTSFlow_R,@TComFlowControlOutCTSFlow_W,'OutCTSFlow');
    RegisterPropertyHelper(@TComFlowControlOutDSRFlow_R,@TComFlowControlOutDSRFlow_W,'OutDSRFlow');
    RegisterPropertyHelper(@TComFlowControlControlDTR_R,@TComFlowControlControlDTR_W,'ControlDTR');
    RegisterPropertyHelper(@TComFlowControlControlRTS_R,@TComFlowControlControlRTS_W,'ControlRTS');
    RegisterPropertyHelper(@TComFlowControlXonXoffOut_R,@TComFlowControlXonXoffOut_W,'XonXoffOut');
    RegisterPropertyHelper(@TComFlowControlXonXoffIn_R,@TComFlowControlXonXoffIn_W,'XonXoffIn');
    RegisterPropertyHelper(@TComFlowControlDSRSensitivity_R,@TComFlowControlDSRSensitivity_W,'DSRSensitivity');
    RegisterPropertyHelper(@TComFlowControlTxContinueOnXoff_R,@TComFlowControlTxContinueOnXoff_W,'TxContinueOnXoff');
    RegisterPropertyHelper(@TComFlowControlXonChar_R,@TComFlowControlXonChar_W,'XonChar');
    RegisterPropertyHelper(@TComFlowControlXoffChar_R,@TComFlowControlXoffChar_W,'XoffChar');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComTimeouts(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComTimeouts) do begin
    RegisterConstructor(@TComTimeouts.Create, 'Create');
    RegisterPropertyHelper(@TComTimeoutsComPort_R,nil,'ComPort');
    RegisterPropertyHelper(@TComTimeoutsReadInterval_R,@TComTimeoutsReadInterval_W,'ReadInterval');
    RegisterPropertyHelper(@TComTimeoutsReadTotalMultiplier_R,@TComTimeoutsReadTotalMultiplier_W,'ReadTotalMultiplier');
    RegisterPropertyHelper(@TComTimeoutsReadTotalConstant_R,@TComTimeoutsReadTotalConstant_W,'ReadTotalConstant');
    RegisterPropertyHelper(@TComTimeoutsWriteTotalMultiplier_R,@TComTimeoutsWriteTotalMultiplier_W,'WriteTotalMultiplier');
    RegisterPropertyHelper(@TComTimeoutsWriteTotalConstant_R,@TComTimeoutsWriteTotalConstant_W,'WriteTotalConstant');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComThread) do begin
    RegisterConstructor(@TComThread.Create, 'Create');
   RegisterMethod(@TComThread.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComLink) do begin
    RegisterPropertyHelper(@TComLinkOnConn_R,@TComLinkOnConn_W,'OnConn');
    RegisterPropertyHelper(@TComLinkOnRxBuf_R,@TComLinkOnRxBuf_W,'OnRxBuf');
    RegisterPropertyHelper(@TComLinkOnTxBuf_R,@TComLinkOnTxBuf_W,'OnTxBuf');
    RegisterPropertyHelper(@TComLinkOnTxEmpty_R,@TComLinkOnTxEmpty_W,'OnTxEmpty');
    RegisterPropertyHelper(@TComLinkOnRxFlag_R,@TComLinkOnRxFlag_W,'OnRxFlag');
    RegisterPropertyHelper(@TComLinkOnCTSChange_R,@TComLinkOnCTSChange_W,'OnCTSChange');
    RegisterPropertyHelper(@TComLinkOnDSRChange_R,@TComLinkOnDSRChange_W,'OnDSRChange');
    RegisterPropertyHelper(@TComLinkOnRLSDChange_R,@TComLinkOnRLSDChange_W,'OnRLSDChange');
    RegisterPropertyHelper(@TComLinkOnRing_R,@TComLinkOnRing_W,'OnRing');
    RegisterPropertyHelper(@TComLinkOnTx_R,@TComLinkOnTx_W,'OnTx');
    RegisterPropertyHelper(@TComLinkOnRx_R,@TComLinkOnRx_W,'OnRx');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomComPort) do
  RIRegister_TComLink(CL);
  RIRegister_TComThread(CL);
  RIRegister_TComTimeouts(CL);
  RIRegister_TComFlowControl(CL);
  RIRegister_TComParity(CL);
  RIRegister_TComBuffer(CL);
  RIRegister_TCustomComPort(CL);
  RIRegister_TComPort(CL);
  RIRegister_TComDataPacket(CL);
  RIRegister_TComStream(CL);
  RIRegister_EComPort(CL);
end;

 
 
{ TPSImport_CPort }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CPort.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CPort(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CPort.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CPort(ri);
  RIRegister_CPort_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
