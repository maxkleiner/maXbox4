unit uPSI_AdPort;
{
    another rs232 COM
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
  TPSImport_AdPort = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TApdComPort(CL: TPSPascalCompiler);
procedure SIRegister_TApdCustomComPort(CL: TPSPascalCompiler);
procedure SIRegister_AdPort(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AdPort_Routines(S: TPSExec);
procedure RIRegister_TApdComPort(CL: TPSRuntimeClassImporter);
procedure RIRegister_TApdCustomComPort(CL: TPSRuntimeClassImporter);
procedure RIRegister_AdPort(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinTypes
  ,WinProcs
  ,Messages
  ,Controls
  ,Forms
  ,OoMisc
  ,AwUser
  ,AwWin32
  ,AdExcept
  ,AdSelCom
  ,AdPort
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AdPort]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TApdComPort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TApdCustomComPort', 'TApdComPort') do
  with CL.AddClassN(CL.FindClass('TApdCustomComPort'),'TApdComPort') do
  begin
    RegisterpublishedProperties;
    RegisterProperty('Tag', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TApdCustomComPort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TApdBaseComponent', 'TApdCustomComPort') do
  with CL.AddClassN(CL.FindClass('TApdBaseComponent'),'TApdCustomComPort') do begin
    RegisterProperty('OverrideLine', 'Boolean', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
        RegisterMethod('Procedure Free');
     RegisterMethod('Procedure InitPort');
    RegisterMethod('Procedure DonePort');
    RegisterMethod('Procedure ForcePortOpen');
    RegisterMethod('Procedure SendBreak( Ticks : Word; Yield : Boolean)');
    RegisterMethod('Procedure SetBreak( BreakOn : Boolean)');
    RegisterMethod('Procedure RegisterUser( const H : THandle)');
    RegisterMethod('Procedure RegisterUserEx( const H : THandle)');
    RegisterMethod('Procedure RegisterUserCallback( CallBack : TPortCallback)');
    RegisterMethod('Procedure RegisterUserCallbackEx( CallBackEx : TPortCallbackEx)');
    RegisterMethod('Procedure DeregisterUser( const H : THandle)');
    RegisterMethod('Procedure DeregisterUserCallback( CallBack : TPortCallback)');
    RegisterMethod('Procedure DeregisterUserCallbackEx( CallBackEx : TPortCallbackEx)');
    RegisterMethod('Procedure ProcessCommunications');
    RegisterMethod('Procedure FlushInBuffer');
    RegisterMethod('Procedure FlushOutBuffer');
    RegisterMethod('Function AddDataTrigger( const Data : ShortString; const IgnoreCase : Boolean) : Word');
    RegisterMethod('Function AddTimerTrigger : Word');
    RegisterMethod('Function AddStatusTrigger( const SType : Word) : Word');
    RegisterMethod('Procedure RemoveTrigger( const Handle : Word)');
    RegisterMethod('Procedure RemoveAllTriggers');
    RegisterMethod('Procedure SetTimerTrigger( const Handle : Word; const Ticks : LongInt; const Activate : Boolean)');
    RegisterMethod('Procedure SetStatusTrigger( const Handle : Word; const Value : Word; const Activate : Boolean)');
    RegisterMethod('Function CharReady : Boolean');
    RegisterMethod('Function PeekChar( const Count : Word) : Char');
    RegisterMethod('Function GetChar : Char');
    RegisterMethod('Procedure PutChar( const C : Char)');
    RegisterMethod('Procedure PutString( const S : String)');
    RegisterMethod('Function CheckForString( var Index : Byte; C : Char; const S : String; IgnoreCase : Boolean) : Boolean');
    RegisterMethod('Function WaitForString( const S : String; const Timeout : LongInt; const Yield, IgnoreCase : Boolean) : Boolean');
    RegisterMethod('Function WaitForMultiString( const S : String; const Timeout : LongInt; const Yield, IgnoreCase : Boolean; const SepChar : Char) : Integer');
    RegisterMethod('Procedure PrepareWait');
    RegisterProperty('ComNumber', 'Word', iptrw);
    RegisterProperty('CustomDispatcher', 'TActivationProcedure', iptrw);
    RegisterProperty('DeviceLayer', 'TDeviceLayer', iptrw);
    RegisterProperty('ComWindow', 'THandle', iptr);
    RegisterProperty('Baud', 'LongInt', iptrw);
    RegisterProperty('Parity', 'TParity', iptrw);
    RegisterProperty('PromptForPort', 'Boolean', iptrw);
    RegisterProperty('DataBits', 'Word', iptrw);
    RegisterProperty('StopBits', 'Word', iptrw);
    RegisterProperty('InSize', 'Word', iptrw);
    RegisterProperty('OutSize', 'Word', iptrw);
    RegisterProperty('Open', 'Boolean', iptrw);
    RegisterProperty('AutoOpen', 'Boolean', iptrw);
    RegisterProperty('CommNotificationLevel', 'Word', iptrw);
    RegisterProperty('TapiMode', 'TTapiMode', iptrw);
    RegisterProperty('TapiCid', 'Word', iptrw);
    RegisterProperty('RS485Mode', 'Boolean', iptrw);
    RegisterProperty('BaseAddress', 'Word', iptrw);
    RegisterProperty('ThreadBoost', 'TApThreadBoost', iptrw);
    RegisterProperty('MasterTerminal', 'TWinControl', iptrw);
    RegisterProperty('DTR', 'Boolean', iptrw);
    RegisterProperty('RTS', 'Boolean', iptrw);
    RegisterProperty('HWFlowOptions', 'THWFlowOptionSet', iptrw);
    RegisterProperty('FlowState', 'TFlowControlState', iptr);
    RegisterProperty('SWFlowOptions', 'TSWFlowOptions', iptrw);
    RegisterProperty('XOnChar', 'Char', iptrw);
    RegisterProperty('XOffChar', 'Char', iptrw);
    RegisterProperty('BufferFull', 'Word', iptrw);
    RegisterProperty('BufferResume', 'Word', iptrw);
    RegisterProperty('Tracing', 'TTraceLogState', iptrw);
    RegisterProperty('TraceSize', 'Cardinal', iptrw);
    RegisterProperty('TraceName', 'TPassString', iptrw);
    RegisterProperty('TraceHex', 'Boolean', iptrw);
    RegisterProperty('TraceAllHex', 'Boolean', iptrw);
    RegisterProperty('Logging', 'TTraceLogState', iptrw);
    RegisterProperty('LogSize', 'Cardinal', iptrw);
    RegisterProperty('LogName', 'TPassString', iptrw);
    RegisterProperty('LogHex', 'Boolean', iptrw);
    RegisterProperty('LogAllHex', 'Boolean', iptrw);
    RegisterProperty('UseMSRShadow', 'Boolean', iptrw);
    RegisterProperty('UseEventWord', 'Boolean', iptrw);
    RegisterMethod('Procedure AddTraceEntry( const CurEntry, CurCh : Char)');
    RegisterMethod('Procedure AddStringToLog( S : string)');
    RegisterProperty('TriggerLength', 'Word', iptrw);
    RegisterProperty('OnTrigger', 'TTriggerEvent', iptrw);
    RegisterProperty('OnTriggerAvail', 'TTriggerAvailEvent', iptrw);
    RegisterProperty('OnTriggerData', 'TTriggerDataEvent', iptrw);
    RegisterProperty('OnTriggerStatus', 'TTriggerStatusEvent', iptrw);
    RegisterProperty('OnTriggerTimer', 'TTriggerTimerEvent', iptrw);
    RegisterProperty('OnPortOpen', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPortClose', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTriggerLineError', 'TTriggerLineErrorEvent', iptrw);
    RegisterProperty('OnTriggerModemStatus', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTriggerOutbuffFree', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTriggerOutbuffUsed', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTriggerOutSent', 'TNotifyEvent', iptrw);
    RegisterProperty('OnWaitChar', 'TWaitCharEvent', iptrw);
    RegisterProperty('Output', 'String', iptw);
    RegisterProperty('Dispatcher', 'TApdBaseDispatcher', iptr);
    RegisterMethod('Function ValidDispatcher : TApdBaseDispatcher');
    RegisterProperty('ModemStatus', 'Byte', iptr);
    RegisterProperty('DSR', 'Boolean', iptr);
    RegisterProperty('CTS', 'Boolean', iptr);
    RegisterProperty('RI', 'Boolean', iptr);
    RegisterProperty('DCD', 'Boolean', iptr);
    RegisterProperty('DeltaDSR', 'Boolean', iptr);
    RegisterProperty('DeltaCTS', 'Boolean', iptr);
    RegisterProperty('DeltaRI', 'Boolean', iptr);
    RegisterProperty('DeltaDCD', 'Boolean', iptr);
    RegisterProperty('LineError', 'Word', iptr);
    RegisterProperty('LineBreak', 'Boolean', iptr);
    RegisterProperty('InBuffUsed', 'Word', iptr);
    RegisterProperty('InBuffFree', 'Word', iptr);
    RegisterProperty('OutBuffUsed', 'Word', iptr);
    RegisterProperty('OutBuffFree', 'Word', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AdPort(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TParity', '( pNone, pOdd, pEven, pMark, pSpace )');
  CL.AddTypeS('TDeviceLayer', '( dlWin32, dlWinsock )');
  CL.AddTypeS('TDeviceLayers', 'set of TDeviceLayer');
  CL.AddTypeS('TAdBaudRate', 'LongInt');
  CL.AddTypeS('TTapiMode', '( tmNone, tmAuto, tmOn, tmOff )');
  CL.AddTypeS('TPortState', '( psClosed, psShuttingDown, psOpen )');
  CL.AddTypeS('THWFlowOptions', '( hwfUseDTR, hwfUseRTS, hwfRequireDSR, hwfRequireCTS )');
  CL.AddTypeS('THWFlowOptionSet', 'set of THWFlowOptions');
  CL.AddTypeS('TSWFlowOptions', '( swfNone, swfReceive, swfTransmit, swfBoth )');
  CL.AddTypeS('TFlowControlState', '( fcOff, fcOn, fcDsrHold, fcCtsHold, fcDcdH'
   +'old, fcXOutHold, fcXInHold, fcXBothHold )');
  CL.AddTypeS('TTraceLogState', '( tlOff, tlOn, tlDump, tlAppend, tlClear, tlPause )');
  CL.AddTypeS('TAdTriggerEvent', 'Procedure ( CP : TObject; Msg, TriggerHandle, Data : Word)');
  CL.AddTypeS('TTriggerAvailEvent', 'Procedure ( CP : TObject; Count : Word)');
  CL.AddTypeS('TTriggerDataEvent', 'Procedure ( CP : TObject; TriggerHandle : Word)');
  CL.AddTypeS('TTriggerStatusEvent', 'Procedure ( CP : TObject; TriggerHandle : Word)');
  CL.AddTypeS('TTriggerTimerEvent', 'Procedure ( CP : TObject; TriggerHandle : Word)');
  CL.AddTypeS('TTriggerLineErrorEvent', 'Procedure ( CP : TObject; Error : Word; LineBreak : Boolean)');
  CL.AddTypeS('TWaitCharEvent', 'Procedure ( CP : TObject; C : Char)');
  CL.AddTypeS('TPortCallback', 'Procedure ( CP : TObject; Opening : Boolean)');
  CL.AddTypeS('TApdCallbackType', '( ctOpen, ctClosing, ctClosed )');
  CL.AddTypeS('TPortCallbackEx', 'Procedure ( CP : TObject; CallbackType : TApdCallbackType)');
  //CL.AddTypeS('PUserListEntry', '^TUserListEntry // will not work');
  CL.AddTypeS('TUserListEntry', 'record Handle : THandle; OpenClose : TPortCall'
   +'back; OpenCloseEx : TPortCallbackEx; IsEx : Boolean; end');
  CL.AddTypeS('TApThreadBoost', '( tbNone, tbPlusOne, tbPlusTwo )');
 CL.AddConstantN('adpoDefDeviceLayer','string').SetString('dlWin32');
 CL.AddConstantN('adpoDefPromptForPort','Boolean');
 CL.AddConstantN('adpoDefComNumber','LongInt').SetInt( 0);
 CL.AddConstantN('adpoDefBaudRt','LongInt').SetInt( 19200);
 //CL.AddConstantN('adpoDefParity','integer').SetSet(pNone);
 CL.AddConstantN('adpoDefDatabits','LongInt').SetInt( 8);
 CL.AddConstantN('adpoDefStopbits','LongInt').SetInt( 1);
 CL.AddConstantN('adpoDefInSize','LongInt').SetInt( 4096);
 CL.AddConstantN('adpoDefOutSize','LongInt').SetInt( 4096);
 //CL.AddConstantN('adpoDefOpen','Boolean').SetInt( 4096);
 //CL.AddConstantN('adpoDefAutoOpen','Boolean').SetInt( 4096);
 CL.AddConstantN('adpoDefBaseAddress','LongInt').SetInt( 0);
 {CL.AddConstantN('adpoDefTapiMode','').SetString( tmAuto);
 CL.AddConstantN('adpoDefDTR','Boolean').SetString( tmAuto);
 CL.AddConstantN('adpoDefRTS','Boolean').SetString( tmAuto);
 CL.AddConstantN('adpoDefTracing','').SetString( tlOff);}
 CL.AddConstantN('adpoDefTraceSize','LongInt').SetInt( 10000);
 CL.AddConstantN('adpoDefTraceName','String').SetString( 'APRO.TRC');
 CL.AddConstantN('adpoDefTraceHex','string').SetString( 'APRO.TRC');
 CL.AddConstantN('adpoDefTraceAllHex','string').SetString( 'APRO.TRC');
 //CL.AddConstantN('adpoDefLogging','').SetString( tlOff);
 CL.AddConstantN('adpoDefLogSize','LongInt').SetInt( 10000);
 CL.AddConstantN('adpoDefLogName','String').SetString( 'APRO.LOG');
 CL.AddConstantN('adpoDefLogHex','string').SetString( 'APRO.LOG');
 CL.AddConstantN('adpoDefLogAllHex','string').SetString( 'APRO.LOG');
 CL.AddConstantN('adpoDefUseMSRShadow','string').SetString( 'APRO.LOG');
 CL.AddConstantN('adpoDefUseEventWord','string').SetString( 'APRO.LOG');
 CL.AddConstantN('adpoDefSWFlowOptions','string').SetString(' swfNone');
 CL.AddConstantN('adpoDefXonChar','Char').SetString( #17);
 CL.AddConstantN('adpoDefXoffChar','Char').SetString( #19);
 CL.AddConstantN('adpoDefBufferFull','LongInt').SetInt( 0);
 CL.AddConstantN('adpoDefBufferResume','LongInt').SetInt( 0);
 CL.AddConstantN('adpoDefTriggerLength','LongInt').SetInt( 1);
 CL.AddConstantN('adpoDefCommNotificationLevel','LongInt').SetInt( 10);
 CL.AddConstantN('adpoDefRS485Mode','Boolean').SetInt( 10);
  SIRegister_TApdCustomComPort(CL);
  SIRegister_TApdComPort(CL);
 CL.AddDelphiFunction('Function ComName( const ComNumber : Word) : ShortString');
 CL.AddDelphiFunction('Function SearchComPort( const C : TComponent) : TApdCustomComPort');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOutBuffFree_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.OutBuffFree; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOutBuffUsed_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.OutBuffUsed; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortInBuffFree_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.InBuffFree; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortInBuffUsed_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.InBuffUsed; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLineBreak_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.LineBreak; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLineError_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.LineError; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDeltaDCD_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.DeltaDCD; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDeltaRI_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.DeltaRI; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDeltaCTS_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.DeltaCTS; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDeltaDSR_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.DeltaDSR; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDCD_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.DCD; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortRI_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.RI; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortCTS_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.CTS; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDSR_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.DSR; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortModemStatus_R(Self: TApdCustomComPort; var T: Byte);
begin T := Self.ModemStatus; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDispatcher_R(Self: TApdCustomComPort; var T: TApdBaseDispatcher);
begin T := Self.Dispatcher; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOutput_W(Self: TApdCustomComPort; const T: String);
begin Self.Output := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnWaitChar_W(Self: TApdCustomComPort; const T: TWaitCharEvent);
begin Self.OnWaitChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnWaitChar_R(Self: TApdCustomComPort; var T: TWaitCharEvent);
begin T := Self.OnWaitChar; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerOutSent_W(Self: TApdCustomComPort; const T: TNotifyEvent);
begin Self.OnTriggerOutSent := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerOutSent_R(Self: TApdCustomComPort; var T: TNotifyEvent);
begin T := Self.OnTriggerOutSent; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerOutbuffUsed_W(Self: TApdCustomComPort; const T: TNotifyEvent);
begin Self.OnTriggerOutbuffUsed := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerOutbuffUsed_R(Self: TApdCustomComPort; var T: TNotifyEvent);
begin T := Self.OnTriggerOutbuffUsed; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerOutbuffFree_W(Self: TApdCustomComPort; const T: TNotifyEvent);
begin Self.OnTriggerOutbuffFree := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerOutbuffFree_R(Self: TApdCustomComPort; var T: TNotifyEvent);
begin T := Self.OnTriggerOutbuffFree; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerModemStatus_W(Self: TApdCustomComPort; const T: TNotifyEvent);
begin Self.OnTriggerModemStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerModemStatus_R(Self: TApdCustomComPort; var T: TNotifyEvent);
begin T := Self.OnTriggerModemStatus; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerLineError_W(Self: TApdCustomComPort; const T: TTriggerLineErrorEvent);
begin Self.OnTriggerLineError := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerLineError_R(Self: TApdCustomComPort; var T: TTriggerLineErrorEvent);
begin T := Self.OnTriggerLineError; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnPortClose_W(Self: TApdCustomComPort; const T: TNotifyEvent);
begin Self.OnPortClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnPortClose_R(Self: TApdCustomComPort; var T: TNotifyEvent);
begin T := Self.OnPortClose; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnPortOpen_W(Self: TApdCustomComPort; const T: TNotifyEvent);
begin Self.OnPortOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnPortOpen_R(Self: TApdCustomComPort; var T: TNotifyEvent);
begin T := Self.OnPortOpen; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerTimer_W(Self: TApdCustomComPort; const T: TTriggerTimerEvent);
begin Self.OnTriggerTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerTimer_R(Self: TApdCustomComPort; var T: TTriggerTimerEvent);
begin T := Self.OnTriggerTimer; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerStatus_W(Self: TApdCustomComPort; const T: TTriggerStatusEvent);
begin Self.OnTriggerStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerStatus_R(Self: TApdCustomComPort; var T: TTriggerStatusEvent);
begin T := Self.OnTriggerStatus; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerData_W(Self: TApdCustomComPort; const T: TTriggerDataEvent);
begin Self.OnTriggerData := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerData_R(Self: TApdCustomComPort; var T: TTriggerDataEvent);
begin T := Self.OnTriggerData; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerAvail_W(Self: TApdCustomComPort; const T: TTriggerAvailEvent);
begin Self.OnTriggerAvail := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTriggerAvail_R(Self: TApdCustomComPort; var T: TTriggerAvailEvent);
begin T := Self.OnTriggerAvail; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTrigger_W(Self: TApdCustomComPort; const T: TTriggerEvent);
begin Self.OnTrigger := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOnTrigger_R(Self: TApdCustomComPort; var T: TTriggerEvent);
begin T := Self.OnTrigger; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTriggerLength_W(Self: TApdCustomComPort; const T: Word);
begin Self.TriggerLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTriggerLength_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.TriggerLength; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortUseEventWord_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.UseEventWord := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortUseEventWord_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.UseEventWord; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortUseMSRShadow_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.UseMSRShadow := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortUseMSRShadow_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.UseMSRShadow; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLogAllHex_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.LogAllHex := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLogAllHex_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.LogAllHex; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLogHex_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.LogHex := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLogHex_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.LogHex; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLogName_W(Self: TApdCustomComPort; const T: TPassString);
begin Self.LogName := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLogName_R(Self: TApdCustomComPort; var T: TPassString);
begin T := Self.LogName; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLogSize_W(Self: TApdCustomComPort; const T: Cardinal);
begin Self.LogSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLogSize_R(Self: TApdCustomComPort; var T: Cardinal);
begin T := Self.LogSize; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLogging_W(Self: TApdCustomComPort; const T: TTraceLogState);
begin Self.Logging := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortLogging_R(Self: TApdCustomComPort; var T: TTraceLogState);
begin T := Self.Logging; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTraceAllHex_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.TraceAllHex := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTraceAllHex_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.TraceAllHex; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTraceHex_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.TraceHex := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTraceHex_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.TraceHex; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTraceName_W(Self: TApdCustomComPort; const T: TPassString);
begin Self.TraceName := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTraceName_R(Self: TApdCustomComPort; var T: TPassString);
begin T := Self.TraceName; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTraceSize_W(Self: TApdCustomComPort; const T: Cardinal);
begin Self.TraceSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTraceSize_R(Self: TApdCustomComPort; var T: Cardinal);
begin T := Self.TraceSize; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTracing_W(Self: TApdCustomComPort; const T: TTraceLogState);
begin Self.Tracing := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTracing_R(Self: TApdCustomComPort; var T: TTraceLogState);
begin T := Self.Tracing; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortBufferResume_W(Self: TApdCustomComPort; const T: Word);
begin Self.BufferResume := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortBufferResume_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.BufferResume; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortBufferFull_W(Self: TApdCustomComPort; const T: Word);
begin Self.BufferFull := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortBufferFull_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.BufferFull; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortXOffChar_W(Self: TApdCustomComPort; const T: Char);
begin Self.XOffChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortXOffChar_R(Self: TApdCustomComPort; var T: Char);
begin T := Self.XOffChar; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortXOnChar_W(Self: TApdCustomComPort; const T: Char);
begin Self.XOnChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortXOnChar_R(Self: TApdCustomComPort; var T: Char);
begin T := Self.XOnChar; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortSWFlowOptions_W(Self: TApdCustomComPort; const T: TSWFlowOptions);
begin Self.SWFlowOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortSWFlowOptions_R(Self: TApdCustomComPort; var T: TSWFlowOptions);
begin T := Self.SWFlowOptions; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortFlowState_R(Self: TApdCustomComPort; var T: TFlowControlState);
begin T := Self.FlowState; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortHWFlowOptions_W(Self: TApdCustomComPort; const T: THWFlowOptionSet);
begin Self.HWFlowOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortHWFlowOptions_R(Self: TApdCustomComPort; var T: THWFlowOptionSet);
begin T := Self.HWFlowOptions; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortRTS_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.RTS := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortRTS_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.RTS; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDTR_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.DTR := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDTR_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.DTR; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortMasterTerminal_W(Self: TApdCustomComPort; const T: TWinControl);
begin Self.MasterTerminal := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortMasterTerminal_R(Self: TApdCustomComPort; var T: TWinControl);
begin T := Self.MasterTerminal; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortThreadBoost_W(Self: TApdCustomComPort; const T: TApThreadBoost);
begin Self.ThreadBoost := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortThreadBoost_R(Self: TApdCustomComPort; var T: TApThreadBoost);
begin T := Self.ThreadBoost; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortBaseAddress_W(Self: TApdCustomComPort; const T: Word);
begin Self.BaseAddress := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortBaseAddress_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.BaseAddress; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortRS485Mode_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.RS485Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortRS485Mode_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.RS485Mode; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTapiCid_W(Self: TApdCustomComPort; const T: Word);
begin Self.TapiCid := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTapiCid_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.TapiCid; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTapiMode_W(Self: TApdCustomComPort; const T: TTapiMode);
begin Self.TapiMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortTapiMode_R(Self: TApdCustomComPort; var T: TTapiMode);
begin T := Self.TapiMode; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortCommNotificationLevel_W(Self: TApdCustomComPort; const T: Word);
begin Self.CommNotificationLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortCommNotificationLevel_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.CommNotificationLevel; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortAutoOpen_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.AutoOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortAutoOpen_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.AutoOpen; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOpen_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.Open := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOpen_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.Open; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOutSize_W(Self: TApdCustomComPort; const T: Word);
begin Self.OutSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOutSize_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.OutSize; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortInSize_W(Self: TApdCustomComPort; const T: Word);
begin Self.InSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortInSize_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.InSize; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortStopBits_W(Self: TApdCustomComPort; const T: Word);
begin Self.StopBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortStopBits_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.StopBits; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDataBits_W(Self: TApdCustomComPort; const T: Word);
begin Self.DataBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDataBits_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.DataBits; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortPromptForPort_W(Self: TApdCustomComPort; const T: Boolean);
begin Self.PromptForPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortPromptForPort_R(Self: TApdCustomComPort; var T: Boolean);
begin T := Self.PromptForPort; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortParity_W(Self: TApdCustomComPort; const T: TParity);
begin Self.Parity := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortParity_R(Self: TApdCustomComPort; var T: TParity);
begin T := Self.Parity; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortBaud_W(Self: TApdCustomComPort; const T: LongInt);
begin Self.Baud := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortBaud_R(Self: TApdCustomComPort; var T: LongInt);
begin T := Self.Baud; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortComWindow_R(Self: TApdCustomComPort; var T: THandle);
begin T := Self.ComWindow; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDeviceLayer_W(Self: TApdCustomComPort; const T: TDeviceLayer);
begin Self.DeviceLayer := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortDeviceLayer_R(Self: TApdCustomComPort; var T: TDeviceLayer);
begin T := Self.DeviceLayer; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortCustomDispatcher_W(Self: TApdCustomComPort; const T: TActivationProcedure);
begin Self.CustomDispatcher := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortCustomDispatcher_R(Self: TApdCustomComPort; var T: TActivationProcedure);
begin T := Self.CustomDispatcher; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortComNumber_W(Self: TApdCustomComPort; const T: Word);
begin Self.ComNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortComNumber_R(Self: TApdCustomComPort; var T: Word);
begin T := Self.ComNumber; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOverrideLine_W(Self: TApdCustomComPort; const T: Boolean);
Begin Self.OverrideLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdCustomComPortOverrideLine_R(Self: TApdCustomComPort; var T: Boolean);
Begin T := Self.OverrideLine; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AdPort_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ComName, 'ComName', cdRegister);
 S.RegisterDelphiFunction(@SearchComPort, 'SearchComPort', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TApdComPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TApdComPort) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TApdCustomComPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TApdCustomComPort) do begin
    RegisterPropertyHelper(@TApdCustomComPortOverrideLine_R,@TApdCustomComPortOverrideLine_W,'OverrideLine');
    RegisterConstructor(@TApdCustomComPort.Create, 'Create');
       RegisterMethod(@TApdCustomComPort.Destroy, 'Free');
     RegisterVirtualMethod(@TApdCustomComPort.InitPort, 'InitPort');
    RegisterVirtualMethod(@TApdCustomComPort.DonePort, 'DonePort');
    RegisterMethod(@TApdCustomComPort.ForcePortOpen, 'ForcePortOpen');
    RegisterMethod(@TApdCustomComPort.SendBreak, 'SendBreak');
    RegisterMethod(@TApdCustomComPort.SetBreak, 'SetBreak');
    RegisterMethod(@TApdCustomComPort.RegisterUser, 'RegisterUser');
    RegisterMethod(@TApdCustomComPort.RegisterUserEx, 'RegisterUserEx');
    RegisterMethod(@TApdCustomComPort.RegisterUserCallback, 'RegisterUserCallback');
    RegisterMethod(@TApdCustomComPort.RegisterUserCallbackEx, 'RegisterUserCallbackEx');
    RegisterMethod(@TApdCustomComPort.DeregisterUser, 'DeregisterUser');
    RegisterMethod(@TApdCustomComPort.DeregisterUserCallback, 'DeregisterUserCallback');
    RegisterMethod(@TApdCustomComPort.DeregisterUserCallbackEx, 'DeregisterUserCallbackEx');
    RegisterVirtualMethod(@TApdCustomComPort.ProcessCommunications, 'ProcessCommunications');
    RegisterMethod(@TApdCustomComPort.FlushInBuffer, 'FlushInBuffer');
    RegisterMethod(@TApdCustomComPort.FlushOutBuffer, 'FlushOutBuffer');
    RegisterMethod(@TApdCustomComPort.AddDataTrigger, 'AddDataTrigger');
    RegisterMethod(@TApdCustomComPort.AddTimerTrigger, 'AddTimerTrigger');
    RegisterMethod(@TApdCustomComPort.AddStatusTrigger, 'AddStatusTrigger');
    RegisterMethod(@TApdCustomComPort.RemoveTrigger, 'RemoveTrigger');
    RegisterMethod(@TApdCustomComPort.RemoveAllTriggers, 'RemoveAllTriggers');
    RegisterMethod(@TApdCustomComPort.SetTimerTrigger, 'SetTimerTrigger');
    RegisterMethod(@TApdCustomComPort.SetStatusTrigger, 'SetStatusTrigger');
    RegisterMethod(@TApdCustomComPort.CharReady, 'CharReady');
    RegisterMethod(@TApdCustomComPort.PeekChar, 'PeekChar');
    RegisterMethod(@TApdCustomComPort.GetChar, 'GetChar');
    RegisterMethod(@TApdCustomComPort.PutChar, 'PutChar');
    RegisterMethod(@TApdCustomComPort.PutString, 'PutString');
    RegisterMethod(@TApdCustomComPort.CheckForString, 'CheckForString');
    RegisterMethod(@TApdCustomComPort.WaitForString, 'WaitForString');
    RegisterMethod(@TApdCustomComPort.WaitForMultiString, 'WaitForMultiString');
    RegisterMethod(@TApdCustomComPort.PrepareWait, 'PrepareWait');
    RegisterPropertyHelper(@TApdCustomComPortComNumber_R,@TApdCustomComPortComNumber_W,'ComNumber');
    RegisterPropertyHelper(@TApdCustomComPortCustomDispatcher_R,@TApdCustomComPortCustomDispatcher_W,'CustomDispatcher');
    RegisterPropertyHelper(@TApdCustomComPortDeviceLayer_R,@TApdCustomComPortDeviceLayer_W,'DeviceLayer');
    RegisterPropertyHelper(@TApdCustomComPortComWindow_R,nil,'ComWindow');
    RegisterPropertyHelper(@TApdCustomComPortBaud_R,@TApdCustomComPortBaud_W,'Baud');
    RegisterPropertyHelper(@TApdCustomComPortParity_R,@TApdCustomComPortParity_W,'Parity');
    RegisterPropertyHelper(@TApdCustomComPortPromptForPort_R,@TApdCustomComPortPromptForPort_W,'PromptForPort');
    RegisterPropertyHelper(@TApdCustomComPortDataBits_R,@TApdCustomComPortDataBits_W,'DataBits');
    RegisterPropertyHelper(@TApdCustomComPortStopBits_R,@TApdCustomComPortStopBits_W,'StopBits');
    RegisterPropertyHelper(@TApdCustomComPortInSize_R,@TApdCustomComPortInSize_W,'InSize');
    RegisterPropertyHelper(@TApdCustomComPortOutSize_R,@TApdCustomComPortOutSize_W,'OutSize');
    RegisterPropertyHelper(@TApdCustomComPortOpen_R,@TApdCustomComPortOpen_W,'Open');
    RegisterPropertyHelper(@TApdCustomComPortAutoOpen_R,@TApdCustomComPortAutoOpen_W,'AutoOpen');
    RegisterPropertyHelper(@TApdCustomComPortCommNotificationLevel_R,@TApdCustomComPortCommNotificationLevel_W,'CommNotificationLevel');
    RegisterPropertyHelper(@TApdCustomComPortTapiMode_R,@TApdCustomComPortTapiMode_W,'TapiMode');
    RegisterPropertyHelper(@TApdCustomComPortTapiCid_R,@TApdCustomComPortTapiCid_W,'TapiCid');
    RegisterPropertyHelper(@TApdCustomComPortRS485Mode_R,@TApdCustomComPortRS485Mode_W,'RS485Mode');
    RegisterPropertyHelper(@TApdCustomComPortBaseAddress_R,@TApdCustomComPortBaseAddress_W,'BaseAddress');
    RegisterPropertyHelper(@TApdCustomComPortThreadBoost_R,@TApdCustomComPortThreadBoost_W,'ThreadBoost');
    RegisterPropertyHelper(@TApdCustomComPortMasterTerminal_R,@TApdCustomComPortMasterTerminal_W,'MasterTerminal');
    RegisterPropertyHelper(@TApdCustomComPortDTR_R,@TApdCustomComPortDTR_W,'DTR');
    RegisterPropertyHelper(@TApdCustomComPortRTS_R,@TApdCustomComPortRTS_W,'RTS');
    RegisterPropertyHelper(@TApdCustomComPortHWFlowOptions_R,@TApdCustomComPortHWFlowOptions_W,'HWFlowOptions');
    RegisterPropertyHelper(@TApdCustomComPortFlowState_R,nil,'FlowState');
    RegisterPropertyHelper(@TApdCustomComPortSWFlowOptions_R,@TApdCustomComPortSWFlowOptions_W,'SWFlowOptions');
    RegisterPropertyHelper(@TApdCustomComPortXOnChar_R,@TApdCustomComPortXOnChar_W,'XOnChar');
    RegisterPropertyHelper(@TApdCustomComPortXOffChar_R,@TApdCustomComPortXOffChar_W,'XOffChar');
    RegisterPropertyHelper(@TApdCustomComPortBufferFull_R,@TApdCustomComPortBufferFull_W,'BufferFull');
    RegisterPropertyHelper(@TApdCustomComPortBufferResume_R,@TApdCustomComPortBufferResume_W,'BufferResume');
    RegisterPropertyHelper(@TApdCustomComPortTracing_R,@TApdCustomComPortTracing_W,'Tracing');
    RegisterPropertyHelper(@TApdCustomComPortTraceSize_R,@TApdCustomComPortTraceSize_W,'TraceSize');
    RegisterPropertyHelper(@TApdCustomComPortTraceName_R,@TApdCustomComPortTraceName_W,'TraceName');
    RegisterPropertyHelper(@TApdCustomComPortTraceHex_R,@TApdCustomComPortTraceHex_W,'TraceHex');
    RegisterPropertyHelper(@TApdCustomComPortTraceAllHex_R,@TApdCustomComPortTraceAllHex_W,'TraceAllHex');
    RegisterPropertyHelper(@TApdCustomComPortLogging_R,@TApdCustomComPortLogging_W,'Logging');
    RegisterPropertyHelper(@TApdCustomComPortLogSize_R,@TApdCustomComPortLogSize_W,'LogSize');
    RegisterPropertyHelper(@TApdCustomComPortLogName_R,@TApdCustomComPortLogName_W,'LogName');
    RegisterPropertyHelper(@TApdCustomComPortLogHex_R,@TApdCustomComPortLogHex_W,'LogHex');
    RegisterPropertyHelper(@TApdCustomComPortLogAllHex_R,@TApdCustomComPortLogAllHex_W,'LogAllHex');
    RegisterPropertyHelper(@TApdCustomComPortUseMSRShadow_R,@TApdCustomComPortUseMSRShadow_W,'UseMSRShadow');
    RegisterPropertyHelper(@TApdCustomComPortUseEventWord_R,@TApdCustomComPortUseEventWord_W,'UseEventWord');
    RegisterMethod(@TApdCustomComPort.AddTraceEntry, 'AddTraceEntry');
    RegisterMethod(@TApdCustomComPort.AddStringToLog, 'AddStringToLog');
    RegisterPropertyHelper(@TApdCustomComPortTriggerLength_R,@TApdCustomComPortTriggerLength_W,'TriggerLength');
    RegisterPropertyHelper(@TApdCustomComPortOnTrigger_R,@TApdCustomComPortOnTrigger_W,'OnTrigger');
    RegisterPropertyHelper(@TApdCustomComPortOnTriggerAvail_R,@TApdCustomComPortOnTriggerAvail_W,'OnTriggerAvail');
    RegisterPropertyHelper(@TApdCustomComPortOnTriggerData_R,@TApdCustomComPortOnTriggerData_W,'OnTriggerData');
    RegisterPropertyHelper(@TApdCustomComPortOnTriggerStatus_R,@TApdCustomComPortOnTriggerStatus_W,'OnTriggerStatus');
    RegisterPropertyHelper(@TApdCustomComPortOnTriggerTimer_R,@TApdCustomComPortOnTriggerTimer_W,'OnTriggerTimer');
    RegisterPropertyHelper(@TApdCustomComPortOnPortOpen_R,@TApdCustomComPortOnPortOpen_W,'OnPortOpen');
    RegisterPropertyHelper(@TApdCustomComPortOnPortClose_R,@TApdCustomComPortOnPortClose_W,'OnPortClose');
    RegisterPropertyHelper(@TApdCustomComPortOnTriggerLineError_R,@TApdCustomComPortOnTriggerLineError_W,'OnTriggerLineError');
    RegisterPropertyHelper(@TApdCustomComPortOnTriggerModemStatus_R,@TApdCustomComPortOnTriggerModemStatus_W,'OnTriggerModemStatus');
    RegisterPropertyHelper(@TApdCustomComPortOnTriggerOutbuffFree_R,@TApdCustomComPortOnTriggerOutbuffFree_W,'OnTriggerOutbuffFree');
    RegisterPropertyHelper(@TApdCustomComPortOnTriggerOutbuffUsed_R,@TApdCustomComPortOnTriggerOutbuffUsed_W,'OnTriggerOutbuffUsed');
    RegisterPropertyHelper(@TApdCustomComPortOnTriggerOutSent_R,@TApdCustomComPortOnTriggerOutSent_W,'OnTriggerOutSent');
    RegisterPropertyHelper(@TApdCustomComPortOnWaitChar_R,@TApdCustomComPortOnWaitChar_W,'OnWaitChar');
    RegisterPropertyHelper(nil,@TApdCustomComPortOutput_W,'Output');
    RegisterPropertyHelper(@TApdCustomComPortDispatcher_R,nil,'Dispatcher');
    RegisterMethod(@TApdCustomComPort.ValidDispatcher, 'ValidDispatcher');
    RegisterPropertyHelper(@TApdCustomComPortModemStatus_R,nil,'ModemStatus');
    RegisterPropertyHelper(@TApdCustomComPortDSR_R,nil,'DSR');
    RegisterPropertyHelper(@TApdCustomComPortCTS_R,nil,'CTS');
    RegisterPropertyHelper(@TApdCustomComPortRI_R,nil,'RI');
    RegisterPropertyHelper(@TApdCustomComPortDCD_R,nil,'DCD');
    RegisterPropertyHelper(@TApdCustomComPortDeltaDSR_R,nil,'DeltaDSR');
    RegisterPropertyHelper(@TApdCustomComPortDeltaCTS_R,nil,'DeltaCTS');
    RegisterPropertyHelper(@TApdCustomComPortDeltaRI_R,nil,'DeltaRI');
    RegisterPropertyHelper(@TApdCustomComPortDeltaDCD_R,nil,'DeltaDCD');
    RegisterPropertyHelper(@TApdCustomComPortLineError_R,nil,'LineError');
    RegisterPropertyHelper(@TApdCustomComPortLineBreak_R,nil,'LineBreak');
    RegisterPropertyHelper(@TApdCustomComPortInBuffUsed_R,nil,'InBuffUsed');
    RegisterPropertyHelper(@TApdCustomComPortInBuffFree_R,nil,'InBuffFree');
    RegisterPropertyHelper(@TApdCustomComPortOutBuffUsed_R,nil,'OutBuffUsed');
    RegisterPropertyHelper(@TApdCustomComPortOutBuffFree_R,nil,'OutBuffFree');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AdPort(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TApdCustomComPort(CL);
  RIRegister_TApdComPort(CL);
end;

 
 
{ TPSImport_AdPort }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AdPort.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AdPort(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AdPort.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AdPort(ri);
  RIRegister_AdPort_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
