unit uPSI_AfComPortCore;
{
  the core 2 ext
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
  TPSImport_AfComPortCore = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TAfComPortCore(CL: TPSPascalCompiler);
procedure SIRegister_TAfComPortWriteThread(CL: TPSPascalCompiler);
procedure SIRegister_TAfComPortEventThread(CL: TPSPascalCompiler);
procedure SIRegister_TAfComPortCoreThread(CL: TPSPascalCompiler);
procedure SIRegister_AfComPortCore(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AfComPortCore_Routines(S: TPSExec);
procedure RIRegister_TAfComPortCore(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfComPortWriteThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfComPortEventThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfComPortCoreThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_AfComPortCore(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,AfUtils
  ,AfCircularBuffer
  ,AfComPortCore
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AfComPortCore]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfComPortCore(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAfComPortCore') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAfComPortCore') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure CloseComPort');
    RegisterMethod('Function ComError : DWORD');
    RegisterMethod('Function ComStatus : TComStat');
    RegisterMethod('Function EscapeComm( const Func : DWORD) : Boolean');
    RegisterMethod('Function ModemStatus : DWORD');
    RegisterMethod('Function OpenComPort( ComNumber : Integer) : Boolean');
    RegisterMethod('Function OpenExternalHandle( ExternalHandle : THandle) : Boolean');
    RegisterMethod('Function OutBuffFree : Integer');
    RegisterMethod('Function OutBuffUsed : Integer');
    RegisterMethod('Function PurgeRX : Boolean');
    RegisterMethod('Function PurgeTX : Boolean');
    RegisterMethod('Function ReadData( var Data, Count : Integer) : Integer');
    RegisterMethod('Function WriteData( const Data, Size : Integer) : Boolean');
    RegisterMethod('Function ReadDataString( var Data: string; Count : Integer) : Integer');
    RegisterMethod('Function WriteDataString( const Data: string; Size : Integer) : Boolean');
    RegisterProperty('ComNumber', 'Integer', iptr);
    RegisterProperty('DCB', 'TDCB', iptrw);
    RegisterProperty('DirectWrite', 'Boolean', iptrw);
    RegisterProperty('EventMask', 'DWORD', iptrw);
    RegisterProperty('EventThreadPriority', 'TThreadPriority', iptrw);
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('IsOpen', 'Boolean', iptr);
    RegisterProperty('InBuffSize', 'Integer', iptrw);
    RegisterProperty('OutBuffSize', 'Integer', iptrw);
    RegisterProperty('OnPortEvent', 'TAfComPortCoreEvent', iptrw);
    RegisterProperty('WriteThreadPriority', 'TThreadPriority', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfComPortWriteThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfComPortCoreThread', 'TAfComPortWriteThread') do
  with CL.AddClassN(CL.FindClass('TAfComPortCoreThread'),'TAfComPortWriteThread') do
  begin
    RegisterMethod('Constructor Create( AComPortCore : TAfComPortCore)');
    RegisterMethod('Function PurgeTX : Boolean');
    RegisterMethod('Procedure StopThread');
    RegisterMethod('Function WriteData( const Data, Size : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfComPortEventThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfComPortCoreThread', 'TAfComPortEventThread') do
  with CL.AddClassN(CL.FindClass('TAfComPortCoreThread'),'TAfComPortEventThread') do
  begin
    RegisterMethod('Constructor Create( AComPortCore : TAfComPortCore)');
    RegisterMethod('Function ReadData( var Buf, Size : Integer) : DWORD');
    RegisterMethod('Procedure StopThread');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfComPortCoreThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TAfComPortCoreThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TAfComPortCoreThread') do begin
    RegisterMethod('Constructor Create( AComPortCore : TAfComPortCore)');
    RegisterMethod('Procedure StopThread');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AfComPortCore(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('fBinary','LongWord').SetUInt( $00000001);
 CL.AddConstantN('fParity','LongWord').SetUInt( $00000002);
 CL.AddConstantN('fOutxCtsFlow','LongWord').SetUInt( $00000004);
 CL.AddConstantN('fOutxDsrFlow','LongWord').SetUInt( $00000008);
 CL.AddConstantN('fDtrControl','LongWord').SetUInt( $00000030);
 CL.AddConstantN('fDtrControlDisable','LongWord').SetUInt( $00000000);
 CL.AddConstantN('fDtrControlEnable','LongWord').SetUInt( $00000010);
 CL.AddConstantN('fDtrControlHandshake','LongWord').SetUInt( $00000020);
 CL.AddConstantN('fDsrSensitivity','LongWord').SetUInt( $00000040);
 CL.AddConstantN('fTXContinueOnXoff','LongWord').SetUInt( $00000080);
 CL.AddConstantN('fOutX','LongWord').SetUInt( $00000100);
 CL.AddConstantN('fInX','LongWord').SetUInt( $00000200);
 CL.AddConstantN('fErrorChar','LongWord').SetUInt( $00000400);
 CL.AddConstantN('fNull','LongWord').SetUInt( $00000800);
 CL.AddConstantN('fRtsControl','LongWord').SetUInt( $00003000);
 CL.AddConstantN('fRtsControlDisable','LongWord').SetUInt( $00000000);
 CL.AddConstantN('fRtsControlEnable','LongWord').SetUInt( $00001000);
 CL.AddConstantN('fRtsControlHandshake','LongWord').SetUInt( $00002000);
 CL.AddConstantN('fRtsControlToggle','LongWord').SetUInt( $00003000);
 CL.AddConstantN('fAbortOnError','LongWord').SetUInt( $00004000);
 CL.AddConstantN('fDummy2','LongWord').SetUInt( $FFFF8000);

 //CL.AddConstantN('MUTEX_MODIFY_STATE','').SetString( MUTANT_QUERY_STATE);
 //CL.AddConstantN('MUTEX_ALL_ACCESS','').SetString( MUTANT_ALL_ACCESS);
 CL.AddConstantN('SP_SERIALCOMM','LongWord').SetUInt( $00000001);
 CL.AddConstantN('PST_UNSPECIFIED','LongWord').SetUInt( $00000000);
 CL.AddConstantN('PST_RS232','LongWord').SetUInt( $00000001);
 CL.AddConstantN('PST_PARALLELPORT','LongWord').SetUInt( $00000002);
 CL.AddConstantN('PST_RS422','LongWord').SetUInt( $00000003);
 CL.AddConstantN('PST_RS423','LongWord').SetUInt( $00000004);
 CL.AddConstantN('PST_RS449','LongWord').SetUInt( $00000005);
 CL.AddConstantN('PST_MODEM','LongWord').SetUInt( $00000006);
 CL.AddConstantN('PST_FAX','LongWord').SetUInt( $00000021);
 CL.AddConstantN('PST_SCANNER','LongWord').SetUInt( $00000022);
 CL.AddConstantN('PST_NETWORK_BRIDGE','LongWord').SetUInt( $00000100);
 CL.AddConstantN('PST_LAT','LongWord').SetUInt( $00000101);
 CL.AddConstantN('PST_TCPIP_TELNET','LongWord').SetUInt( $00000102);
 CL.AddConstantN('PST_X25','LongWord').SetUInt( $00000103);
 CL.AddConstantN('PCF_DTRDSR','LongWord').SetUInt( $0001);
 CL.AddConstantN('PCF_RTSCTS','LongWord').SetUInt( $0002);
 CL.AddConstantN('PCF_RLSD','LongWord').SetUInt( $0004);
 CL.AddConstantN('PCF_PARITY_CHECK','LongWord').SetUInt( $0008);
 CL.AddConstantN('PCF_XONXOFF','LongWord').SetUInt( $0010);
 CL.AddConstantN('PCF_SETXCHAR','LongWord').SetUInt( $0020);
 CL.AddConstantN('PCF_TOTALTIMEOUTS','LongWord').SetUInt( $0040);
 CL.AddConstantN('PCF_INTTIMEOUTS','LongWord').SetUInt( $0080);
 CL.AddConstantN('PCF_SPECIALCHARS','LongWord').SetUInt( $0100);
 CL.AddConstantN('PCF_16BITMODE','LongWord').SetUInt( $0200);
 CL.AddConstantN('SP_PARITY','LongWord').SetUInt( $0001);
 CL.AddConstantN('SP_BAUD','LongWord').SetUInt( $0002);
 CL.AddConstantN('SP_DATABITS','LongWord').SetUInt( $0004);
 CL.AddConstantN('SP_STOPBITS','LongWord').SetUInt( $0008);
 CL.AddConstantN('SP_HANDSHAKING','LongWord').SetUInt( $0010);
 CL.AddConstantN('SP_PARITY_CHECK','LongWord').SetUInt( $0020);
 CL.AddConstantN('SP_RLSD','LongWord').SetUInt( $0040);
 CL.AddConstantN('BAUD_075','LongWord').SetUInt( $00000001);
 CL.AddConstantN('BAUD_110','LongWord').SetUInt( $00000002);
 CL.AddConstantN('BAUD_134_5','LongWord').SetUInt( $00000004);
 CL.AddConstantN('BAUD_150','LongWord').SetUInt( $00000008);
 CL.AddConstantN('BAUD_300','LongWord').SetUInt( $00000010);
 CL.AddConstantN('BAUD_600','LongWord').SetUInt( $00000020);
 CL.AddConstantN('BAUD_1200','LongWord').SetUInt( $00000040);
 CL.AddConstantN('BAUD_1800','LongWord').SetUInt( $00000080);
 CL.AddConstantN('BAUD_2400','LongWord').SetUInt( $00000100);
 CL.AddConstantN('BAUD_4800','LongWord').SetUInt( $00000200);
 CL.AddConstantN('BAUD_7200','LongWord').SetUInt( $00000400);
 CL.AddConstantN('BAUD_9600','LongWord').SetUInt( $00000800);
 CL.AddConstantN('BAUD_14400','LongWord').SetUInt( $00001000);
 CL.AddConstantN('BAUD_19200','LongWord').SetUInt( $00002000);
 CL.AddConstantN('BAUD_38400','LongWord').SetUInt( $00004000);
 CL.AddConstantN('BAUD_56K','LongWord').SetUInt( $00008000);
 CL.AddConstantN('BAUD_128K','LongWord').SetUInt( $00010000);
 CL.AddConstantN('BAUD_115200','LongWord').SetUInt( $00020000);
 CL.AddConstantN('BAUD_57600','LongWord').SetUInt( $00040000);
 CL.AddConstantN('BAUD_USER','LongWord').SetUInt( $10000000);
 CL.AddConstantN('DATABITS_5','LongWord').SetUInt( $0001);
 CL.AddConstantN('DATABITS_6','LongWord').SetUInt( $0002);
 CL.AddConstantN('DATABITS_7','LongWord').SetUInt( $0004);
 CL.AddConstantN('DATABITS_8','LongWord').SetUInt( $0008);
 CL.AddConstantN('DATABITS_16','LongWord').SetUInt( $0010);
 CL.AddConstantN('DATABITS_16X','LongWord').SetUInt( $0020);
 CL.AddConstantN('STOPBITS_10','LongWord').SetUInt( $0001);
 CL.AddConstantN('STOPBITS_15','LongWord').SetUInt( $0002);
 CL.AddConstantN('STOPBITS_20','LongWord').SetUInt( $0004);
 CL.AddConstantN('PARITY_NONE','LongWord').SetUInt( $0100);
 CL.AddConstantN('PARITY_ODD','LongWord').SetUInt( $0200);
 CL.AddConstantN('PARITY_EVEN','LongWord').SetUInt( $0400);
 CL.AddConstantN('PARITY_MARK','LongWord').SetUInt( $0800);
 CL.AddConstantN('PARITY_SPACE','LongWord').SetUInt( $1000);

 CL.AddConstantN('DTR_CONTROL_DISABLE','LongInt').SetInt( 0);
 CL.AddConstantN('DTR_CONTROL_ENABLE','LongInt').SetInt( 1);
 CL.AddConstantN('DTR_CONTROL_HANDSHAKE','LongInt').SetInt( 2);
 CL.AddConstantN('RTS_CONTROL_DISABLE','LongInt').SetInt( 0);
 CL.AddConstantN('RTS_CONTROL_ENABLE','LongInt').SetInt( 1);
 CL.AddConstantN('RTS_CONTROL_HANDSHAKE','LongInt').SetInt( 2);
 CL.AddConstantN('RTS_CONTROL_TOGGLE','LongInt').SetInt( 3);
  CL.AddTypeS('_DCB', 'record DCBlength : DWORD; BaudRate : DWORD; Flags : Long'
   +'int; wReserved : Word; XonLim : Word; XoffLim : Word; ByteSize : Byte; Par'
   +'ity : Byte; StopBits : Byte; XonChar : CHAR; XoffChar : CHAR; ErrorChar : '
   +'CHAR; EofChar : CHAR; EvtChar : CHAR; wReserved1 : Word; end');
  CL.AddTypeS('TDCB', '_DCB');
  CL.AddTypeS('DCB', '_DCB');

  CL.AddTypeS('_COMMTIMEOUTS', 'record ReadIntervalTimeout : DWORD; ReadTotalTi'
   +'meoutMultiplier : DWORD; ReadTotalTimeoutConstant : DWORD; WriteTotalTimeo'
   +'utMultiplier : DWORD; WriteTotalTimeoutConstant : DWORD; end');
  CL.AddTypeS('TCommTimeouts', '_COMMTIMEOUTS');
  CL.AddTypeS('COMMTIMEOUTS', '_COMMTIMEOUTS');


  // TComStateFlags = set of TComStateFlag;
  CL.AddTypeS('TComStateFlag', '( fCtlHold, fDsrHold, fRlsHold, fXoffHold, fXOffSent, fEof, fTxim )');
  CL.AddTypeS('TComStateFlags', 'set of TComStateFlag');
  //CL.AddTypeS('TComStat', '_COMSTAT');
  //CL.AddTypeS('COMSTAT', '_COMSTAT');

  {_COMSTAT = record
    Flags: TComStateFlags;
    Reserved: array[0..2] of Byte;
    cbInQue: DWORD;
    cbOutQue: DWORD;
  end;}
  CL.AddTypeS('_COMSTAT', 'record Flags: TComStateFlags; Reserved: array[0..2] of Byte; cbInQue: word; cbOutQue: word; end');
  //CL.AddTypeS('TComStat', 'record Flags: TComStateFlags; Reserved: array[0..2] of Byte; cbInQue: word; cbOutQue: word; end');
   //{$EXTERNALSYM _COMSTAT}
  //TComStat = _COMSTAT;
  //COMSTAT = _COMSTAT;
  CL.AddTypeS('TComStat', '_COMSTAT');
  CL.AddTypeS('COMSTAT', '_COMSTAT');

  CL.AddTypeS('TAfCoreEvent', '( ceOutFree, ceLineEvent, ceNeedReadData, ceException )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAfComPortCoreError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAfComPortCore');
  CL.AddTypeS('TAfComPortCoreEvent', 'Procedure ( Sender : TAfComPortCore; Even'
   +'tKind : TAfCoreEvent; Data : DWORD)');
  SIRegister_TAfComPortCoreThread(CL);
  SIRegister_TAfComPortEventThread(CL);
  SIRegister_TAfComPortWriteThread(CL);
  SIRegister_TAfComPortCore(CL);

  CL.AddTypeS('_COMMCONFIG', 'record dwSize : DWORD; wVersion'
   +': WORD; wReserved : WORD; dcb: TDCB; dwProviderSubType: DWORD; dwProviderOffset'
   +': DWORD; dwProviderSize : DWORD; wcProviderData: array[0..0] of CHAR; end');

  CL.AddTypeS('TCommConfig', '_COMMCONFIG');
  CL.AddTypeS('COMMCONFIG', '_COMMCONFIG');


   CL.AddTypeS('_COMMPROP', 'record wPacketLength: word; wPacketVersion : WORD; dwServiceMask : DWORD; dwReserved1: DWORD; dwMaxTxQueue: DWORD; dwMaxRxQueue: DWORD; dwMaxBaud: DWord;'
   +'dwProvSubType : Dword; dwProvCapabilities: Dword; dwSettableParams : Dword; dwSettableBaud : dword; wSettableData : dword;'
   +'wSettableStopParity : dword; dwCurrentTxQueue : DWORD; dwCurrentRxQueue : DWORD;'
   +' dwProvSpec1 : DWORD; dwProvSpec2 : DWORD; wcProvChar : array[0..0] of CHAR; end');


  { _COMMPROP = record
    wPacketLength: Word;
    wPacketVersion: Word;
    dwServiceMask: DWORD;
    dwReserved1: DWORD;
    dwMaxTxQueue: DWORD;
    dwMaxRxQueue: DWORD;
    dwMaxBaud: DWORD;
    dwProvSubType: DWORD;
    dwProvCapabilities: DWORD;
    dwSettableParams: DWORD;
    dwSettableBaud: DWORD;
    wSettableData: Word;
    wSettableStopParity: Word;
    dwCurrentTxQueue: DWORD;
    dwCurrentRxQueue: DWORD;
    dwProvSpec1: DWORD;
    dwProvSpec2: DWORD;
    wcProvChar: array[0..0] of WCHAR;
  end; }

  CL.AddTypeS('TCommProp', '_COMMPROP');
  CL.AddTypeS('COMMPROP', '_COMMPROP');


  {  _COMMCONFIG = record
    dwSize: DWORD;
    wVersion: Word;
    wReserved: Word;
    dcb: TDCB;
    dwProviderSubType: DWORD;
    dwProviderOffset: DWORD;
    dwProviderSize: DWORD;
    wcProviderData: array[0..0] of WCHAR;
  end;
  CL.AddTypeS('TCommConfig', '_COMMCONFIG');
  CL.AddTypeS('COMMCONFIG', '_COMMCONFIG');}

 // TCommConfig = _COMMCONFIG;
  //COMMCONFIG = _COMMCONFIG;

 CL.AddDelphiFunction('Function FormatDeviceName( PortNumber : Integer) : string');
 CL.AddDelphiFunction('Function BuildCommDCB( lpDef : PChar; var lpDCB : TDCB) : BOOL');
  CL.AddDelphiFunction('Function wBuildCommDCB( lpDef : PKOLChar; var lpDCB : TDCB) : BOOL');
 CL.AddDelphiFunction('Function wBuildCommDCBAndTimeouts( lpDef : PKOLChar; var lpDCB : TDCB; var lpCommTimeouts : TCommTimeouts) : BOOL');

  CL.AddDelphiFunction('Function BuildCommDCBAndTimeouts( lpDef : PChar; var lpDCB : TDCB; var lpCommTimeouts : TCommTimeouts) : BOOL');
 CL.AddDelphiFunction('Function CommConfigDialog( lpszName : PChar; hWnd : HWND; var lpCC : TCommConfig) : BOOL');
 CL.AddDelphiFunction('Function GetCommProperties( hFile : THandle; var lpCommProp : TCommProp) : BOOL');
 CL.AddDelphiFunction('Function GetDefaultCommConfig( lpszName : PChar; var lpCC : TCommConfig; var lpdwSize : DWORD) : BOOL');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreWriteThreadPriority_W(Self: TAfComPortCore; const T: TThreadPriority);
begin Self.WriteThreadPriority := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreWriteThreadPriority_R(Self: TAfComPortCore; var T: TThreadPriority);
begin T := Self.WriteThreadPriority; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreOnPortEvent_W(Self: TAfComPortCore; const T: TAfComPortCoreEvent);
begin Self.OnPortEvent := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreOnPortEvent_R(Self: TAfComPortCore; var T: TAfComPortCoreEvent);
begin T := Self.OnPortEvent; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreOutBuffSize_W(Self: TAfComPortCore; const T: Integer);
begin Self.OutBuffSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreOutBuffSize_R(Self: TAfComPortCore; var T: Integer);
begin T := Self.OutBuffSize; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreInBuffSize_W(Self: TAfComPortCore; const T: Integer);
begin Self.InBuffSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreInBuffSize_R(Self: TAfComPortCore; var T: Integer);
begin T := Self.InBuffSize; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreIsOpen_R(Self: TAfComPortCore; var T: Boolean);
begin T := Self.IsOpen; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreHandle_R(Self: TAfComPortCore; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreEventThreadPriority_W(Self: TAfComPortCore; const T: TThreadPriority);
begin Self.EventThreadPriority := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreEventThreadPriority_R(Self: TAfComPortCore; var T: TThreadPriority);
begin T := Self.EventThreadPriority; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreEventMask_W(Self: TAfComPortCore; const T: DWORD);
begin Self.EventMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreEventMask_R(Self: TAfComPortCore; var T: DWORD);
begin T := Self.EventMask; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreDirectWrite_W(Self: TAfComPortCore; const T: Boolean);
begin Self.DirectWrite := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreDirectWrite_R(Self: TAfComPortCore; var T: Boolean);
begin T := Self.DirectWrite; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreDCB_W(Self: TAfComPortCore; const T: TDCB);
begin Self.DCB := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreDCB_R(Self: TAfComPortCore; var T: TDCB);
begin T := Self.DCB; end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCoreComNumber_R(Self: TAfComPortCore; var T: Integer);
begin T := Self.ComNumber; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfComPortCore_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FormatDeviceName, 'FormatDeviceName', cdRegister);
 S.RegisterDelphiFunction(@BuildCommDCB, 'BuildCommDCB', CdStdCall);
 S.RegisterDelphiFunction(@BuildCommDCB, 'wBuildCommDCB', CdStdCall);
 S.RegisterDelphiFunction(@BuildCommDCB, 'wBuildCommDCBAndTimeouts', CdStdCall);

  S.RegisterDelphiFunction(@BuildCommDCBAndTimeouts, 'BuildCommDCBAndTimeouts', CdStdCall);
 S.RegisterDelphiFunction(@CommConfigDialog, 'CommConfigDialog', CdStdCall);
  S.RegisterDelphiFunction(@GetCommProperties, 'GetCommProperties', CdStdCall);
  S.RegisterDelphiFunction(@GetDefaultCommConfig, 'GetDefaultCommConfig', CdStdCall);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfComPortCore(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfComPortCore) do begin
    RegisterConstructor(@TAfComPortCore.Create, 'Create');
    RegisterMethod(@TAfComPortCore.Destroy, 'Free');
    RegisterMethod(@TAfComPortCore.CloseComPort, 'CloseComPort');
    RegisterMethod(@TAfComPortCore.ComError, 'ComError');
    RegisterMethod(@TAfComPortCore.ComStatus, 'ComStatus');
    RegisterMethod(@TAfComPortCore.EscapeComm, 'EscapeComm');
    RegisterMethod(@TAfComPortCore.ModemStatus, 'ModemStatus');
    RegisterMethod(@TAfComPortCore.OpenComPort, 'OpenComPort');
    RegisterMethod(@TAfComPortCore.OpenExternalHandle, 'OpenExternalHandle');
    RegisterMethod(@TAfComPortCore.OutBuffFree, 'OutBuffFree');
    RegisterMethod(@TAfComPortCore.OutBuffUsed, 'OutBuffUsed');
    RegisterMethod(@TAfComPortCore.PurgeRX, 'PurgeRX');
    RegisterMethod(@TAfComPortCore.PurgeTX, 'PurgeTX');
    RegisterMethod(@TAfComPortCore.ReadData, 'ReadData');
    RegisterMethod(@TAfComPortCore.WriteData, 'WriteData');
    RegisterMethod(@TAfComPortCore.ReadData, 'ReadDataString');
    RegisterMethod(@TAfComPortCore.WriteData, 'WriteDataString');
      RegisterPropertyHelper(@TAfComPortCoreComNumber_R,nil,'ComNumber');
    RegisterPropertyHelper(@TAfComPortCoreDCB_R,@TAfComPortCoreDCB_W,'DCB');
    RegisterPropertyHelper(@TAfComPortCoreDirectWrite_R,@TAfComPortCoreDirectWrite_W,'DirectWrite');
    RegisterPropertyHelper(@TAfComPortCoreEventMask_R,@TAfComPortCoreEventMask_W,'EventMask');
    RegisterPropertyHelper(@TAfComPortCoreEventThreadPriority_R,@TAfComPortCoreEventThreadPriority_W,'EventThreadPriority');
    RegisterPropertyHelper(@TAfComPortCoreHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TAfComPortCoreIsOpen_R,nil,'IsOpen');
    RegisterPropertyHelper(@TAfComPortCoreInBuffSize_R,@TAfComPortCoreInBuffSize_W,'InBuffSize');
    RegisterPropertyHelper(@TAfComPortCoreOutBuffSize_R,@TAfComPortCoreOutBuffSize_W,'OutBuffSize');
    RegisterPropertyHelper(@TAfComPortCoreOnPortEvent_R,@TAfComPortCoreOnPortEvent_W,'OnPortEvent');
    RegisterPropertyHelper(@TAfComPortCoreWriteThreadPriority_R,@TAfComPortCoreWriteThreadPriority_W,'WriteThreadPriority');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfComPortWriteThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfComPortWriteThread) do
  begin
    RegisterConstructor(@TAfComPortWriteThread.Create, 'Create');
    RegisterMethod(@TAfComPortWriteThread.PurgeTX, 'PurgeTX');
    RegisterMethod(@TAfComPortWriteThread.StopThread, 'StopThread');
    RegisterMethod(@TAfComPortWriteThread.WriteData, 'WriteData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfComPortEventThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfComPortEventThread) do
  begin
    RegisterConstructor(@TAfComPortEventThread.Create, 'Create');
    RegisterMethod(@TAfComPortEventThread.ReadData, 'ReadData');
    RegisterMethod(@TAfComPortEventThread.StopThread, 'StopThread');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfComPortCoreThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfComPortCoreThread) do
  begin
    RegisterConstructor(@TAfComPortCoreThread.Create, 'Create');
    RegisterVirtualMethod(@TAfComPortCoreThread.StopThread, 'StopThread');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfComPortCore(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EAfComPortCoreError) do
  with CL.Add(TAfComPortCore) do
  RIRegister_TAfComPortCoreThread(CL);
  RIRegister_TAfComPortEventThread(CL);
  RIRegister_TAfComPortWriteThread(CL);
  RIRegister_TAfComPortCore(CL);
end;

 
 
{ TPSImport_AfComPortCore }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfComPortCore.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AfComPortCore(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfComPortCore.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AfComPortCore(ri);
  RIRegister_AfComPortCore_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
