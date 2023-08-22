unit uPSI_AfComPort;
{
   com frome
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
  TPSImport_AfComPort = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAfComPort(CL: TPSPascalCompiler);
procedure SIRegister_TAfCustomComPort(CL: TPSPascalCompiler);
procedure SIRegister_TAfCustomSerialPort(CL: TPSPascalCompiler);
procedure SIRegister_AfComPort(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAfComPort(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfCustomComPort(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfCustomSerialPort(CL: TPSRuntimeClassImporter);
procedure RIRegister_AfComPort(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,AfComPortCore
  ,AfSafeSync
  ,AfDataDispatcher
  ,AfComPort
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AfComPort]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfComPort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomComPort', 'TAfComPort') do
  with CL.AddClassN(CL.FindClass('TAfCustomComPort'),'TAfComPort') do begin
   RegisterProperty('Core', 'TAfComPortCore', iptrw);
  // property Core;
  RegisterPublishedProperties;
  RegisterProperty('BaudRate', 'TAfBaudrate', iptrW);
  RegisterProperty('ComNumber', 'Word', iptrw);
  RegisterProperty('AutoOpen', 'boolean', iptrw);
  RegisterProperty('Databits', 'TAfDatabits', iptrw);
  RegisterProperty('DTR', 'boolean', iptrw);
  RegisterProperty('RTS', 'boolean', iptrw);
  RegisterProperty('FlowControl', 'TAfFlowControl', iptrw);
  RegisterProperty('InBufSize', 'integer', iptrw);
  RegisterProperty('OutBufSize', 'integer', iptrw);
  RegisterProperty('Options', 'TAfComOptions', iptrw);
  RegisterProperty('Stopbits', 'TAfStopbits', iptrw);
  RegisterProperty('Parity', 'TAfParity', iptrw);
  
  //  property Parity;
    RegisterProperty('FEventThreadPriority', 'TThreadPriority', iptrw);
  RegisterProperty('OnCTSChanged', 'TNotifyEvent', iptrw);
  RegisterProperty('OnDataRecived', 'TAfCPTDataReceivedEvent', iptrw);
  RegisterProperty('OnDSRChanged', 'TNotifyEvent', iptrw);
  RegisterProperty('OnLineError', 'TNotifyEvent', iptrw);
  RegisterProperty('OnNonSyncEvent', 'TNotifyEvent', iptrw);
  RegisterProperty('OnOutBufFree', 'TAfCPTErrorEvent', iptrw);
  RegisterProperty('OnPortClose', 'TNotifyEvent', iptrw);
  RegisterProperty('OnPortOpen', 'TNotifyEvent', iptrw);
  RegisterProperty('OnRINGDetected', 'TNotifyEvent', iptrw);
  RegisterProperty('OnRLSDChanged', 'TNotifyEvent', iptrw);
  RegisterProperty('OnSyncEvent', 'TAfCPTCoreEvent', iptrw);

  {  property OnPortClose;
    property OnPortOpen;
    property OnRINGDetected;
    property OnRLSDChanged;
    property OnSyncEvent;
    FOnNonSyncEvent: TAfCPTCoreEvent;
    FOnPortClose: TNotifyEvent;
    FOnPortOpen: TNotifyEvent;
    FOnSyncEvent: TAfCPTCoreEvent;
    Sync_Event: TAfComPortEventKind;
    Sync_Data: TAfComPortEventData;
    FWriteThreadPriority: TThreadPriority;  }

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfCustomComPort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomSerialPort', 'TAfCustomComPort') do
  with CL.AddClassN(CL.FindClass('TAfCustomSerialPort'),'TAfCustomComPort') do begin
    RegisterMethod('Function ExecuteConfigDialog : Boolean');
    RegisterMethod('Function ExecuteCOMDialog : Boolean');
    RegisterMethod('Procedure SetDefaultParameters');
    RegisterMethod('Function SettingsStr : String');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfCustomSerialPort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfDataDispConnComponent', 'TAfCustomSerialPort') do
  with CL.AddClassN(CL.FindClass('TAfDataDispConnComponent'),'TAfCustomSerialPort') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
      RegisterMethod('Function ExecuteConfigDialog : Boolean');
      RegisterMethod('Function ExecuteCOMDialog : Boolean');

     RegisterMethod('Procedure Open');
     RegisterMethod('Procedure Close');
     RegisterMethod('Procedure CloseCOM');  //alias

    RegisterMethod('Function InBufUsed : Integer');
    RegisterMethod('Function OutBufFree : Integer');
    RegisterMethod('Function OutBufUsed : Integer');
    RegisterMethod('Procedure PurgeRX');
    RegisterMethod('Procedure PurgeTX');
    RegisterMethod('Function ReadChar : Char');
    RegisterMethod('Function GetChar : Char');
    RegisterMethod('Procedure WriteData(const Data; Size: Integer)');
    RegisterMethod('Procedure ReadData( var Buf, Size : Integer)');
    RegisterMethod('Procedure ReadDataString( var Buf: string; Size : Integer)');
    RegisterMethod('Procedure WriteDataString(const data: string; Size : Integer)');
    RegisterMethod('Function ReadString : String');
    RegisterMethod('Function SynchronizeEvent( EventKind : TAfComPortEventKind; Data : TAfComPortEventData; Timeout : Integer) : Boolean');
    RegisterMethod('Procedure WriteChar( C : Char)');
    RegisterMethod('Procedure PutChar( C : Char)');

    RegisterMethod('Procedure WriteString( const S : String)');
    RegisterPublishedProperties;
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('DCB', 'TDCB', iptrw);
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('CTSHold', 'Boolean', iptr);
    RegisterProperty('DSRHold', 'Boolean', iptr);
    RegisterProperty('RLSDHold', 'Boolean', iptr);
    RegisterProperty('XOffHold', 'Boolean', iptr);
    RegisterProperty('XOffSent', 'Boolean', iptr);
    RegisterProperty('CTS', 'Boolean', iptr);
    RegisterProperty('DSR', 'Boolean', iptr);
    RegisterProperty('RING', 'Boolean', iptr);
    RegisterProperty('RLSD', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AfComPort(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TAfBaudrate', '( br110, br300, br600, br1200, br2400, br4800, br'
   +'9600, br14400, br19200, br38400, br56000, br57600, br115200, br128000, br256000, brUser )');
  CL.AddTypeS('TAfParity', '( paNone, paOdd, paEven, paMark, paSpace )');
  CL.AddTypeS('TAfDatabits', '( db4, db5, db6, db7, db8 )');
  CL.AddTypeS('TAfStopbits', '( sbOne, sbOneAndHalf, sbTwo )');
  CL.AddTypeS('TAfFlowControl', '( fwNone, fwXOnXOff, fwRtsCts, fwDtrDsr )');
  CL.AddTypeS('TAfComOption', '( coParityCheck, coDsrSensitivity, coIgnoreXOff, coErrorChar, coStripNull )');
  CL.AddTypeS('TAfComOptions', 'set of TAfComOption');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAfComPortError');
  CL.AddTypeS('TAfComPortEventKind', 'TAfCoreEvent');
  CL.AddTypeS('TAfComPortEventData', 'DWORD');
  CL.AddTypeS('TAfCPTCoreEvent', 'Procedure ( Sender : TObject; EventKind : TAf'
   +'ComPortEventKind; Data : TAfComPortEventData)');
  CL.AddTypeS('TAfCPTDataReceivedEvent', 'Procedure (Sender : TObject; Count: integer)');
  CL.AddTypeS('TAfCPTErrorEvent', 'Procedure (Sender : TObject; Errors: DWORD)');

  // TAfCPTErrorEvent = procedure(Sender: TObject; Errors: DWORD) of object;
  // TAfCPTDataReceivedEvent = procedure(Sender: TObject; Count: Integer) of object;

  //CL.AddTypeS('TAfCPTErrorEvent', 'Procedure ( Sender : TObject; Errors : DWORD');
  //CL.AddTypeS('TAfCPTDataReceivedEvent', 'Procedure (Sender: TObject; Count: Integer)');
  SIRegister_TAfCustomSerialPort(CL);
  SIRegister_TAfCustomComPort(CL);
  SIRegister_TAfComPort(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortRLSD_R(Self: TAfCustomSerialPort; var T: Boolean);
begin T := Self.RLSD; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortRING_R(Self: TAfCustomSerialPort; var T: Boolean);
begin T := Self.RING; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortDSR_R(Self: TAfCustomSerialPort; var T: Boolean);
begin T := Self.DSR; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortCTS_R(Self: TAfCustomSerialPort; var T: Boolean);
begin T := Self.CTS; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortXOffSent_R(Self: TAfCustomSerialPort; var T: Boolean);
begin T := Self.XOffSent; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortXOffHold_R(Self: TAfCustomSerialPort; var T: Boolean);
begin T := Self.XOffHold; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortRLSDHold_R(Self: TAfCustomSerialPort; var T: Boolean);
begin T := Self.RLSDHold; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortDSRHold_R(Self: TAfCustomSerialPort; var T: Boolean);
begin T := Self.DSRHold; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortCTSHold_R(Self: TAfCustomSerialPort; var T: Boolean);
begin T := Self.CTSHold; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortHandle_R(Self: TAfCustomSerialPort; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortDCB_W(Self: TAfCustomSerialPort; const T: TDCB);
begin Self.DCB := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortDCB_R(Self: TAfCustomSerialPort; var T: TDCB);
begin T := Self.DCB; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortActive_W(Self: TAfCustomSerialPort; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomSerialPortActive_R(Self: TAfCustomSerialPort; var T: Boolean);
begin T := Self.Active; end;


(*----------------------------------------------------------------------------*)
procedure TAfComPortCore_W(Self: TAfComPort; const T: TAfComPortCore);
begin //Self.Core:= T;
end;

(*----------------------------------------------------------------------------*)
procedure TAfComPortCore_R(Self: TAfComPort; var T: TAfComPortCore);
begin T:= Self.Core; end;

//RegisterPropertyHelper(@TAfCustomSerialPortDCB_R,@TAfCustomSerialPortDCB_W,'DCB');


(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfComPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfComPort) do begin
    RegisterPropertyHelper(@TAfComPortCore_R,@TAfComPortCore_W,'Core');
     //RegisterProperty('Core', 'TAfComPortCore', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfCustomComPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfCustomComPort) do begin
    RegisterMethod(@TAfCustomComPort.ExecuteConfigDialog, 'ExecuteConfigDialog');
    RegisterMethod(@TAfCustomComPort.ExecuteConfigDialog, 'ExecuteCOMDialog');
    RegisterMethod(@TAfCustomComPort.SetDefaultParameters, 'SetDefaultParameters');
    RegisterMethod(@TAfCustomComPort.SettingsStr, 'SettingsStr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfCustomSerialPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfCustomSerialPort) do begin
    RegisterConstructor(@TAfCustomSerialPort.Create, 'Create');
     RegisterMethod(@TAfCustomSerialPort.Destroy, 'Free');
     RegisterMethod(@TAfCustomSerialPort.Open, 'Open');
    RegisterMethod(@TAfCustomSerialPort.Close, 'Close');
    RegisterMethod(@TAfCustomSerialPort.Close, 'CloseCOM');
      //RegisterVirtualAbstractMethod(@TAfCustomSerialPort, @!.ExecuteConfigDialog, 'ExecuteConfigDialog');
    RegisterMethod(@TAfCustomSerialPort.InBufUsed, 'InBufUsed');
    RegisterMethod(@TAfCustomSerialPort.OutBufFree, 'OutBufFree');
    RegisterMethod(@TAfCustomSerialPort.OutBufUsed, 'OutBufUsed');
    RegisterMethod(@TAfCustomSerialPort.PurgeRX, 'PurgeRX');
    RegisterMethod(@TAfCustomSerialPort.PurgeTX, 'PurgeTX');
    RegisterMethod(@TAfCustomSerialPort.ReadChar, 'ReadChar');
    RegisterMethod(@TAfCustomSerialPort.ReadChar, 'GetChar');
    RegisterMethod(@TAfCustomSerialPort.ReadData, 'ReadData');
    RegisterMethod(@TAfCustomSerialPort.ReadString, 'ReadString');
    RegisterMethod(@TAfCustomSerialPort.SynchronizeEvent, 'SynchronizeEvent');
    RegisterMethod(@TAfCustomSerialPort.WriteChar, 'WriteChar');
    RegisterMethod(@TAfCustomSerialPort.WriteChar, 'PutChar');
    RegisterMethod(@TAfCustomSerialPort.WriteString, 'WriteString');
    RegisterMethod(@TAfCustomSerialPort.ReadData, 'ReadDataString');
    RegisterMethod(@TAfCustomSerialPort.WriteData, 'WriteDataString');
      RegisterPropertyHelper(@TAfCustomSerialPortActive_R,@TAfCustomSerialPortActive_W,'Active');
    RegisterPropertyHelper(@TAfCustomSerialPortDCB_R,@TAfCustomSerialPortDCB_W,'DCB');
    RegisterPropertyHelper(@TAfCustomSerialPortHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TAfCustomSerialPortCTSHold_R,nil,'CTSHold');
    RegisterPropertyHelper(@TAfCustomSerialPortDSRHold_R,nil,'DSRHold');
    RegisterPropertyHelper(@TAfCustomSerialPortRLSDHold_R,nil,'RLSDHold');
    RegisterPropertyHelper(@TAfCustomSerialPortXOffHold_R,nil,'XOffHold');
    RegisterPropertyHelper(@TAfCustomSerialPortXOffSent_R,nil,'XOffSent');
    RegisterPropertyHelper(@TAfCustomSerialPortCTS_R,nil,'CTS');
    RegisterPropertyHelper(@TAfCustomSerialPortDSR_R,nil,'DSR');
    RegisterPropertyHelper(@TAfCustomSerialPortRING_R,nil,'RING');
    RegisterPropertyHelper(@TAfCustomSerialPortRLSD_R,nil,'RLSD');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfComPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EAfComPortError) do
  RIRegister_TAfCustomSerialPort(CL);
  RIRegister_TAfCustomComPort(CL);
  RIRegister_TAfComPort(CL);
end;

 
 
{ TPSImport_AfComPort }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfComPort.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AfComPort(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfComPort.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AfComPort(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
