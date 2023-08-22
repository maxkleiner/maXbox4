unit uPSI_synaser;
{
   another serial for arduino
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
  TPSImport_synaser = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TBlockSerial(CL: TPSPascalCompiler);
procedure SIRegister_ESynaSerError(CL: TPSPascalCompiler);
procedure SIRegister_synaser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_synaser_Routines(S: TPSExec);
procedure RIRegister_TBlockSerial(CL: TPSRuntimeClassImporter);
procedure RIRegister_ESynaSerError(CL: TPSRuntimeClassImporter);
procedure RIRegister_synaser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
 {  Libc
  ,KernelIoctl
  ,termio
  ,baseunix
  ,unix }
  Types
  ,Windows
  ,registry
  //,winver
  ,synafpc
  ,synautil
  ,synaser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_synaser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlockSerial(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TBlockSerial') do
  with CL.AddClassN(CL.FindClass('TObject'),'TBlockSerial') do begin
    RegisterProperty('DCB', 'Tdcb', iptrw);
    RegisterProperty('TermiosStruc', 'termios', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GetVersion : string');
    RegisterMethod('Procedure CloseSocket');
    RegisterMethod('Procedure Config( baud, bits : integer; parity : char; stop : integer; softflow, hardflow : boolean)');
    RegisterMethod('Procedure Connect( comport : string)');
    RegisterMethod('Procedure SetCommState');
    RegisterMethod('Procedure GetCommState');
    RegisterMethod('Function SendBuffer( buffer : pointer; length : integer) : integer');
    RegisterMethod('Procedure SendByte( data : byte)');
    RegisterMethod('Procedure SendString( data : AnsiString)');
    RegisterMethod('Procedure SendInteger( Data : integer)');
    RegisterMethod('Procedure SendBlock( const Data : AnsiString)');
    RegisterMethod('Procedure SendStreamRaw( const Stream : TStream)');
    RegisterMethod('Procedure SendStream( const Stream : TStream)');
    RegisterMethod('Procedure SendStreamIndy( const Stream : TStream)');
    RegisterMethod('Function RecvBuffer( buffer : pointer; length : integer) : integer');
    RegisterMethod('Function RecvBufferEx( buffer : pointer; length : integer; timeout : integer) : integer');
    RegisterMethod('Function RecvBufferStr( Length : Integer; Timeout : Integer) : AnsiString');
    RegisterMethod('Function RecvPacket( Timeout : Integer) : AnsiString');
    RegisterMethod('Function RecvByte( timeout : integer) : byte');
    RegisterMethod('Function RecvTerminated( Timeout : Integer; const Terminator : AnsiString) : AnsiString');
    RegisterMethod('Function Recvstring( timeout : integer) : AnsiString');
    RegisterMethod('Function RecvInteger( Timeout : Integer) : Integer');
    RegisterMethod('Function RecvBlock( Timeout : Integer) : AnsiString');
    RegisterMethod('Procedure RecvStreamRaw( const Stream : TStream; Timeout : Integer)');
    RegisterMethod('Procedure RecvStreamSize( const Stream : TStream; Timeout : Integer; Size : Integer)');
    RegisterMethod('Procedure RecvStream( const Stream : TStream; Timeout : Integer)');
    RegisterMethod('Procedure RecvStreamIndy( const Stream : TStream; Timeout : Integer)');
    RegisterMethod('Function WaitingData : integer');
    RegisterMethod('Function WaitingDataEx : integer');
    RegisterMethod('Function SendingData : integer');
    RegisterMethod('Procedure EnableRTSToggle( value : boolean)');
    RegisterMethod('Procedure Flush');
    RegisterMethod('Procedure Purge');
    RegisterMethod('Function CanRead( Timeout : integer) : boolean');
    RegisterMethod('Function CanWrite( Timeout : integer) : boolean');
    RegisterMethod('Function CanReadEx( Timeout : integer) : boolean');
    RegisterMethod('Function ModemStatus : integer');
    RegisterMethod('Procedure SetBreak( Duration : integer)');
    RegisterMethod('Function ATCommand( value : AnsiString) : AnsiString');
    RegisterMethod('Function ATConnect( value : AnsiString) : AnsiString');
    RegisterMethod('Function SerialCheck( SerialResult : integer) : integer');
    RegisterMethod('Procedure ExceptCheck');
    RegisterMethod('Procedure SetSynaError( ErrNumber : integer)');
    RegisterMethod('Procedure RaiseSynaError( ErrNumber : integer)');
    RegisterMethod('Function cpomComportAccessible : boolean');
    RegisterMethod('Procedure cpomReleaseComport');
    RegisterProperty('Device', 'string', iptr);
    RegisterProperty('LastError', 'integer', iptr);
    RegisterProperty('LastErrorDesc', 'string', iptr);
    RegisterProperty('ATResult', 'Boolean', iptr);
    RegisterProperty('RTS', 'Boolean', iptw);
    RegisterProperty('CTS', 'boolean', iptr);
    RegisterProperty('DTR', 'Boolean', iptw);
    RegisterProperty('DSR', 'boolean', iptr);
    RegisterProperty('Carrier', 'boolean', iptr);
    RegisterProperty('Ring', 'boolean', iptr);
    RegisterProperty('InstanceActive', 'boolean', iptr);
    RegisterProperty('MaxSendBandwidth', 'Integer', iptrw);
    RegisterProperty('MaxRecvBandwidth', 'Integer', iptrw);
    RegisterProperty('MaxBandwidth', 'Integer', iptw);
    RegisterProperty('SizeRecvBuffer', 'integer', iptrw);
    RegisterMethod('Function GetErrorDesc( ErrorCode : integer) : string');
    RegisterProperty('Tag', 'integer', iptrw);
    RegisterProperty('Handle', 'THandle', iptrw);
    RegisterProperty('LineBuffer', 'AnsiString', iptrw);
    RegisterProperty('RaiseExcept', 'boolean', iptrw);
    RegisterProperty('OnStatus', 'THookSerialStatus', iptrw);
    RegisterProperty('TestDSR', 'boolean', iptrw);
    RegisterProperty('TestCTS', 'boolean', iptrw);
    RegisterProperty('MaxLineLength', 'Integer', iptrw);
    RegisterProperty('DeadlockTimeout', 'Integer', iptrw);
    RegisterProperty('LinuxLock', 'Boolean', iptrw);
    RegisterProperty('ConvertLineEnd', 'Boolean', iptrw);
    RegisterProperty('AtTimeout', 'integer', iptrw);
    RegisterProperty('InterPacketTimeout', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ESynaSerError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ESynaSerError') do
  with CL.AddClassN(CL.FindClass('Exception'),'ESynaSerError') do begin
    RegisterProperty('ErrorCode', 'integer', iptrw);
    RegisterProperty('ErrorMessage', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_synaser(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('synCR','Char').SetString( #$0d);
 CL.AddConstantN('synLF','Char').SetString( #$0a);
 CL.AddConstantN('cSerialChunk','LongInt').SetInt( 8192);
 CL.AddConstantN('LockfileDirectory','String').SetString( '/var/lock');
 CL.AddConstantN('PortIsClosed','LongInt').SetInt( - 1);
 CL.AddConstantN('ErrAlreadyOwned','LongInt').SetInt( 9991);
 CL.AddConstantN('ErrAlreadyInUse','LongInt').SetInt( 9992);
 CL.AddConstantN('ErrWrongParameter','LongInt').SetInt( 9993);
 CL.AddConstantN('ErrPortNotOpen','LongInt').SetInt( 9994);
 CL.AddConstantN('ErrNoDeviceAnswer','LongInt').SetInt( 9995);
 CL.AddConstantN('ErrMaxBuffer','LongInt').SetInt( 9996);
 CL.AddConstantN('ErrTimeout','LongInt').SetInt( 9997);
 CL.AddConstantN('ErrNotRead','LongInt').SetInt( 9998);
 CL.AddConstantN('ErrFrame','LongInt').SetInt( 9999);
 CL.AddConstantN('ErrOverrun','LongInt').SetInt( 10000);
 CL.AddConstantN('ErrRxOver','LongInt').SetInt( 10001);
 CL.AddConstantN('ErrRxParity','LongInt').SetInt( 10002);
 CL.AddConstantN('ErrTxFull','LongInt').SetInt( 10003);
 CL.AddConstantN('dcb_Binary','LongWord').SetUInt( $00000001);
 CL.AddConstantN('dcb_ParityCheck','LongWord').SetUInt( $00000002);
 CL.AddConstantN('dcb_OutxCtsFlow','LongWord').SetUInt( $00000004);
 CL.AddConstantN('dcb_OutxDsrFlow','LongWord').SetUInt( $00000008);
 CL.AddConstantN('dcb_DtrControlMask','LongWord').SetUInt( $00000030);
 CL.AddConstantN('dcb_DtrControlDisable','LongWord').SetUInt( $00000000);
 CL.AddConstantN('dcb_DtrControlEnable','LongWord').SetUInt( $00000010);
 CL.AddConstantN('dcb_DtrControlHandshake','LongWord').SetUInt( $00000020);
 CL.AddConstantN('dcb_DsrSensivity','LongWord').SetUInt( $00000040);
 CL.AddConstantN('dcb_TXContinueOnXoff','LongWord').SetUInt( $00000080);
 CL.AddConstantN('dcb_OutX','LongWord').SetUInt( $00000100);
 CL.AddConstantN('dcb_InX','LongWord').SetUInt( $00000200);
 CL.AddConstantN('dcb_ErrorChar','LongWord').SetUInt( $00000400);
 CL.AddConstantN('dcb_NullStrip','LongWord').SetUInt( $00000800);
 CL.AddConstantN('dcb_RtsControlMask','LongWord').SetUInt( $00003000);
 CL.AddConstantN('dcb_RtsControlDisable','LongWord').SetUInt( $00000000);
 CL.AddConstantN('dcb_RtsControlEnable','LongWord').SetUInt( $00001000);
 CL.AddConstantN('dcb_RtsControlHandshake','LongWord').SetUInt( $00002000);
 CL.AddConstantN('dcb_RtsControlToggle','LongWord').SetUInt( $00003000);
 CL.AddConstantN('dcb_AbortOnError','LongWord').SetUInt( $00004000);
 CL.AddConstantN('dcb_Reserveds','LongWord').SetUInt( $FFFF8000);
 CL.AddConstantN('synSB1','LongInt').SetInt( 0);
 CL.AddConstantN('SB1andHalf','LongInt').SetInt( 1);
 CL.AddConstantN('synSB2','LongInt').SetInt( 2);
 CL.AddConstantN('synINVALID_HANDLE_VALUE','LongInt').SetInt( THandle ( - 1 ));
 CL.AddConstantN('CS7fix','LongWord').SetUInt( $0000020);
  CL.AddTypeS('synTDCB', 'record DCBlength : DWORD; BaudRate : DWORD; Flags : Long'
   +'int; wReserved : Word; XonLim : Word; XoffLim : Word; ByteSize : Byte; Par'
   +'ity : Byte; StopBits : Byte; XonChar : CHAR; XoffChar : CHAR; ErrorChar : '
   +'CHAR; EofChar : CHAR; EvtChar : CHAR; wReserved1 : Word; end');
  //CL.AddTypeS('PDCB', '^TDCB // will not work');
 //CL.AddConstantN('MaxRates','LongInt').SetInt( 18);
 //CL.AddConstantN('MaxRates','LongInt').SetInt( 30);
 //CL.AddConstantN('MaxRates','LongInt').SetInt( 19);
 CL.AddConstantN('O_SYNC','LongWord').SetUInt( $0080);
 CL.AddConstantN('synOK','LongInt').SetInt( 0);
 CL.AddConstantN('synErr','LongInt').SetInt( integer ( - 1 ));
  CL.AddTypeS('THookSerialReason', '( HR_SerialClose, HR_Connect, HR_CanRead, HR_CanWrite, HR_ReadCount, HR_WriteCount, HR_Wait )');
  CL.AddTypeS('THookSerialStatus', 'Procedure ( Sender : TObject; Reason : THookSerialReason; const Value : string)');
  SIRegister_ESynaSerError(CL);
  SIRegister_TBlockSerial(CL);
 CL.AddDelphiFunction('Function GetSerialPortNames : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBlockSerialInterPacketTimeout_W(Self: TBlockSerial; const T: Boolean);
begin Self.InterPacketTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialInterPacketTimeout_R(Self: TBlockSerial; var T: Boolean);
begin T := Self.InterPacketTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialAtTimeout_W(Self: TBlockSerial; const T: integer);
begin Self.AtTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialAtTimeout_R(Self: TBlockSerial; var T: integer);
begin T := Self.AtTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialConvertLineEnd_W(Self: TBlockSerial; const T: Boolean);
begin Self.ConvertLineEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialConvertLineEnd_R(Self: TBlockSerial; var T: Boolean);
begin T := Self.ConvertLineEnd; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialLinuxLock_W(Self: TBlockSerial; const T: Boolean);
begin Self.LinuxLock := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialLinuxLock_R(Self: TBlockSerial; var T: Boolean);
begin T := Self.LinuxLock; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialDeadlockTimeout_W(Self: TBlockSerial; const T: Integer);
begin Self.DeadlockTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialDeadlockTimeout_R(Self: TBlockSerial; var T: Integer);
begin T := Self.DeadlockTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialMaxLineLength_W(Self: TBlockSerial; const T: Integer);
begin Self.MaxLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialMaxLineLength_R(Self: TBlockSerial; var T: Integer);
begin T := Self.MaxLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialTestCTS_W(Self: TBlockSerial; const T: boolean);
begin Self.TestCTS := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialTestCTS_R(Self: TBlockSerial; var T: boolean);
begin T := Self.TestCTS; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialTestDSR_W(Self: TBlockSerial; const T: boolean);
begin Self.TestDSR := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialTestDSR_R(Self: TBlockSerial; var T: boolean);
begin T := Self.TestDSR; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialOnStatus_W(Self: TBlockSerial; const T: THookSerialStatus);
begin Self.OnStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialOnStatus_R(Self: TBlockSerial; var T: THookSerialStatus);
begin T := Self.OnStatus; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialRaiseExcept_W(Self: TBlockSerial; const T: boolean);
begin Self.RaiseExcept := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialRaiseExcept_R(Self: TBlockSerial; var T: boolean);
begin T := Self.RaiseExcept; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialLineBuffer_W(Self: TBlockSerial; const T: AnsiString);
begin Self.LineBuffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialLineBuffer_R(Self: TBlockSerial; var T: AnsiString);
begin T := Self.LineBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialHandle_W(Self: TBlockSerial; const T: THandle);
begin Self.Handle := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialHandle_R(Self: TBlockSerial; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialTag_W(Self: TBlockSerial; const T: integer);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialTag_R(Self: TBlockSerial; var T: integer);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialSizeRecvBuffer_W(Self: TBlockSerial; const T: integer);
begin Self.SizeRecvBuffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialSizeRecvBuffer_R(Self: TBlockSerial; var T: integer);
begin T := Self.SizeRecvBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialMaxBandwidth_W(Self: TBlockSerial; const T: Integer);
begin Self.MaxBandwidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialMaxRecvBandwidth_W(Self: TBlockSerial; const T: Integer);
begin Self.MaxRecvBandwidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialMaxRecvBandwidth_R(Self: TBlockSerial; var T: Integer);
begin T := Self.MaxRecvBandwidth; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialMaxSendBandwidth_W(Self: TBlockSerial; const T: Integer);
begin Self.MaxSendBandwidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialMaxSendBandwidth_R(Self: TBlockSerial; var T: Integer);
begin T := Self.MaxSendBandwidth; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialInstanceActive_R(Self: TBlockSerial; var T: boolean);
begin T := Self.InstanceActive; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialRing_R(Self: TBlockSerial; var T: boolean);
begin T := Self.Ring; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialCarrier_R(Self: TBlockSerial; var T: boolean);
begin T := Self.Carrier; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialDSR_R(Self: TBlockSerial; var T: boolean);
begin T := Self.DSR; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialDTR_W(Self: TBlockSerial; const T: Boolean);
begin Self.DTR := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialCTS_R(Self: TBlockSerial; var T: boolean);
begin T := Self.CTS; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialRTS_W(Self: TBlockSerial; const T: Boolean);
begin Self.RTS := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialATResult_R(Self: TBlockSerial; var T: Boolean);
begin T := Self.ATResult; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialLastErrorDesc_R(Self: TBlockSerial; var T: string);
begin T := Self.LastErrorDesc; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialLastError_R(Self: TBlockSerial; var T: integer);
begin T := Self.LastError; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialDevice_R(Self: TBlockSerial; var T: string);
begin T := Self.Device; end;

(*----------------------------------------------------------------------------*)
{procedure TBlockSerialTermiosStruc_W(Self: TBlockSerial; const T: termios);
Begin Self.TermiosStruc := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialTermiosStruc_R(Self: TBlockSerial; var T: termios);
Begin T := Self.TermiosStruc; end;}

(*----------------------------------------------------------------------------*)
procedure TBlockSerialDCB_W(Self: TBlockSerial; const T: Tdcb);
Begin Self.DCB := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSerialDCB_R(Self: TBlockSerial; var T: Tdcb);
Begin T := Self.DCB; end;

(*----------------------------------------------------------------------------*)
procedure ESynaSerErrorErrorMessage_W(Self: ESynaSerError; const T: string);
Begin Self.ErrorMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure ESynaSerErrorErrorMessage_R(Self: ESynaSerError; var T: string);
Begin T := Self.ErrorMessage; end;

(*----------------------------------------------------------------------------*)
procedure ESynaSerErrorErrorCode_W(Self: ESynaSerError; const T: integer);
Begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure ESynaSerErrorErrorCode_R(Self: ESynaSerError; var T: integer);
Begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_synaser_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetSerialPortNames, 'GetSerialPortNames', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlockSerial(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlockSerial) do begin
    RegisterPropertyHelper(@TBlockSerialDCB_R,@TBlockSerialDCB_W,'DCB');
    //RegisterPropertyHelper(@TBlockSerialTermiosStruc_R,@TBlockSerialTermiosStruc_W,'TermiosStruc');
    RegisterConstructor(@TBlockSerial.Create, 'Create');
    RegisterMethod(@TBlockSerial.Destroy, 'Free');
    RegisterVirtualMethod(@TBlockSerial.GetVersion, 'GetVersion');
    RegisterVirtualMethod(@TBlockSerial.CloseSocket, 'CloseSocket');
    RegisterVirtualMethod(@TBlockSerial.Config, 'Config');
    RegisterVirtualMethod(@TBlockSerial.Connect, 'Connect');
    RegisterVirtualMethod(@TBlockSerial.SetCommState, 'SetCommState');
    RegisterVirtualMethod(@TBlockSerial.GetCommState, 'GetCommState');
    RegisterVirtualMethod(@TBlockSerial.SendBuffer, 'SendBuffer');
    RegisterVirtualMethod(@TBlockSerial.SendByte, 'SendByte');
    RegisterVirtualMethod(@TBlockSerial.SendString, 'SendString');
    RegisterVirtualMethod(@TBlockSerial.SendInteger, 'SendInteger');
    RegisterVirtualMethod(@TBlockSerial.SendBlock, 'SendBlock');
    RegisterVirtualMethod(@TBlockSerial.SendStreamRaw, 'SendStreamRaw');
    RegisterVirtualMethod(@TBlockSerial.SendStream, 'SendStream');
    RegisterVirtualMethod(@TBlockSerial.SendStreamIndy, 'SendStreamIndy');
    RegisterVirtualMethod(@TBlockSerial.RecvBuffer, 'RecvBuffer');
    RegisterVirtualMethod(@TBlockSerial.RecvBufferEx, 'RecvBufferEx');
    RegisterVirtualMethod(@TBlockSerial.RecvBufferStr, 'RecvBufferStr');
    RegisterVirtualMethod(@TBlockSerial.RecvPacket, 'RecvPacket');
    RegisterVirtualMethod(@TBlockSerial.RecvByte, 'RecvByte');
    RegisterVirtualMethod(@TBlockSerial.RecvTerminated, 'RecvTerminated');
    RegisterVirtualMethod(@TBlockSerial.Recvstring, 'Recvstring');
    RegisterVirtualMethod(@TBlockSerial.RecvInteger, 'RecvInteger');
    RegisterVirtualMethod(@TBlockSerial.RecvBlock, 'RecvBlock');
    RegisterVirtualMethod(@TBlockSerial.RecvStreamRaw, 'RecvStreamRaw');
    RegisterVirtualMethod(@TBlockSerial.RecvStreamSize, 'RecvStreamSize');
    RegisterVirtualMethod(@TBlockSerial.RecvStream, 'RecvStream');
    RegisterVirtualMethod(@TBlockSerial.RecvStreamIndy, 'RecvStreamIndy');
    RegisterVirtualMethod(@TBlockSerial.WaitingData, 'WaitingData');
    RegisterVirtualMethod(@TBlockSerial.WaitingDataEx, 'WaitingDataEx');
    RegisterVirtualMethod(@TBlockSerial.SendingData, 'SendingData');
    RegisterVirtualMethod(@TBlockSerial.EnableRTSToggle, 'EnableRTSToggle');
    RegisterVirtualMethod(@TBlockSerial.Flush, 'Flush');
    RegisterVirtualMethod(@TBlockSerial.Purge, 'Purge');
    RegisterVirtualMethod(@TBlockSerial.CanRead, 'CanRead');
    RegisterVirtualMethod(@TBlockSerial.CanWrite, 'CanWrite');
    RegisterVirtualMethod(@TBlockSerial.CanReadEx, 'CanReadEx');
    RegisterVirtualMethod(@TBlockSerial.ModemStatus, 'ModemStatus');
    RegisterVirtualMethod(@TBlockSerial.SetBreak, 'SetBreak');
    RegisterVirtualMethod(@TBlockSerial.ATCommand, 'ATCommand');
    RegisterVirtualMethod(@TBlockSerial.ATConnect, 'ATConnect');
    RegisterVirtualMethod(@TBlockSerial.SerialCheck, 'SerialCheck');
    RegisterVirtualMethod(@TBlockSerial.ExceptCheck, 'ExceptCheck');
    RegisterVirtualMethod(@TBlockSerial.SetSynaError, 'SetSynaError');
    RegisterVirtualMethod(@TBlockSerial.RaiseSynaError, 'RaiseSynaError');
    //RegisterVirtualMethod(@TBlockSerial.cpomComportAccessible, 'cpomComportAccessible');
    //RegisterVirtualMethod(@TBlockSerial.cpomReleaseComport, 'cpomReleaseComport');
    RegisterPropertyHelper(@TBlockSerialDevice_R,nil,'Device');
    RegisterPropertyHelper(@TBlockSerialLastError_R,nil,'LastError');
    RegisterPropertyHelper(@TBlockSerialLastErrorDesc_R,nil,'LastErrorDesc');
    RegisterPropertyHelper(@TBlockSerialATResult_R,nil,'ATResult');
    RegisterPropertyHelper(nil,@TBlockSerialRTS_W,'RTS');
    RegisterPropertyHelper(@TBlockSerialCTS_R,nil,'CTS');
    RegisterPropertyHelper(nil,@TBlockSerialDTR_W,'DTR');
    RegisterPropertyHelper(@TBlockSerialDSR_R,nil,'DSR');
    RegisterPropertyHelper(@TBlockSerialCarrier_R,nil,'Carrier');
    RegisterPropertyHelper(@TBlockSerialRing_R,nil,'Ring');
    RegisterPropertyHelper(@TBlockSerialInstanceActive_R,nil,'InstanceActive');
    RegisterPropertyHelper(@TBlockSerialMaxSendBandwidth_R,@TBlockSerialMaxSendBandwidth_W,'MaxSendBandwidth');
    RegisterPropertyHelper(@TBlockSerialMaxRecvBandwidth_R,@TBlockSerialMaxRecvBandwidth_W,'MaxRecvBandwidth');
    RegisterPropertyHelper(nil,@TBlockSerialMaxBandwidth_W,'MaxBandwidth');
    RegisterPropertyHelper(@TBlockSerialSizeRecvBuffer_R,@TBlockSerialSizeRecvBuffer_W,'SizeRecvBuffer');
    RegisterMethod(@TBlockSerial.GetErrorDesc, 'GetErrorDesc');
    RegisterPropertyHelper(@TBlockSerialTag_R,@TBlockSerialTag_W,'Tag');
    RegisterPropertyHelper(@TBlockSerialHandle_R,@TBlockSerialHandle_W,'Handle');
    RegisterPropertyHelper(@TBlockSerialLineBuffer_R,@TBlockSerialLineBuffer_W,'LineBuffer');
    RegisterPropertyHelper(@TBlockSerialRaiseExcept_R,@TBlockSerialRaiseExcept_W,'RaiseExcept');
    RegisterPropertyHelper(@TBlockSerialOnStatus_R,@TBlockSerialOnStatus_W,'OnStatus');
    RegisterPropertyHelper(@TBlockSerialTestDSR_R,@TBlockSerialTestDSR_W,'TestDSR');
    RegisterPropertyHelper(@TBlockSerialTestCTS_R,@TBlockSerialTestCTS_W,'TestCTS');
    RegisterPropertyHelper(@TBlockSerialMaxLineLength_R,@TBlockSerialMaxLineLength_W,'MaxLineLength');
    RegisterPropertyHelper(@TBlockSerialDeadlockTimeout_R,@TBlockSerialDeadlockTimeout_W,'DeadlockTimeout');
    RegisterPropertyHelper(@TBlockSerialLinuxLock_R,@TBlockSerialLinuxLock_W,'LinuxLock');
    RegisterPropertyHelper(@TBlockSerialConvertLineEnd_R,@TBlockSerialConvertLineEnd_W,'ConvertLineEnd');
    RegisterPropertyHelper(@TBlockSerialAtTimeout_R,@TBlockSerialAtTimeout_W,'AtTimeout');
    RegisterPropertyHelper(@TBlockSerialInterPacketTimeout_R,@TBlockSerialInterPacketTimeout_W,'InterPacketTimeout');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ESynaSerError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ESynaSerError) do
  begin
    RegisterPropertyHelper(@ESynaSerErrorErrorCode_R,@ESynaSerErrorErrorCode_W,'ErrorCode');
    RegisterPropertyHelper(@ESynaSerErrorErrorMessage_R,@ESynaSerErrorErrorMessage_W,'ErrorMessage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_synaser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_ESynaSerError(CL);
  RIRegister_TBlockSerial(CL);
end;

 
 
{ TPSImport_synaser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_synaser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_synaser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_synaser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_synaser(ri);
  RIRegister_synaser_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
