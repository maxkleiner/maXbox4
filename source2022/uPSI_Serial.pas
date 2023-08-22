unit uPSI_Serial;
{
from ToolBox
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
  TPSImport_Serial = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSerStdDlg(CL: TPSPascalCompiler);
procedure SIRegister_TSerPort(CL: TPSPascalCompiler);
procedure SIRegister_TSerial(CL: TPSPascalCompiler);
procedure SIRegister_TCustomSerial(CL: TPSPascalCompiler);
procedure SIRegister_TSerPortThread(CL: TPSPascalCompiler);
procedure SIRegister_TSerThread(CL: TPSPascalCompiler);
procedure SIRegister_TCOMManager(CL: TPSPascalCompiler);
procedure SIRegister_TMsgWindow(CL: TPSPascalCompiler);
procedure SIRegister_Serial(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Serial_Routines(S: TPSExec);
procedure RIRegister_TSerStdDlg(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSerPort(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSerial(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomSerial(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSerPortThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSerThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCOMManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMsgWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_Serial(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Serial
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Serial]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSerStdDlg(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSerStdDlg') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSerStdDlg') do begin
    RegisterMethod('Function Execute : boolean');
    RegisterProperty('Serial', 'TSerial', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSerPort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSerial', 'TSerPort') do
  with CL.AddClassN(CL.FindClass('TCustomSerial'),'TSerPort') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Function OpenComm : boolean');
    RegisterMethod('Procedure CloseComm');
    RegisterProperty('Active', 'boolean', iptrw);
    RegisterProperty('Out_DTR', 'boolean', iptrw);
    RegisterProperty('Out_RTS', 'boolean', iptrw);
    RegisterProperty('Out_TxD', 'boolean', iptrw);
    RegisterProperty('In_DCD', 'boolean', iptr);
    RegisterProperty('In_DSR', 'boolean', iptr);
    RegisterProperty('In_CTS', 'boolean', iptr);
    RegisterProperty('In_RI', 'boolean', iptr);
    RegisterProperty('PollingMode', 'boolean', iptrw);
    RegisterProperty('OnCts', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDsr', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRing', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDcd', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSerial(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSerial', 'TSerial') do
  with CL.AddClassN(CL.FindClass('TCustomSerial'),'TSerial') do begin
    RegisterProperty('TransmittData', 'TTData', iptrw);
    RegisterProperty('ReceiveData', 'TRData', iptrw);
    RegisterProperty('TransmittText', 'TTText', iptrw);
    RegisterProperty('ReceiveText', 'TRText', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Function OpenComm : boolean');
    RegisterMethod('Procedure CloseComm');
    RegisterMethod('Function Purge( TxAbort, RxAbort, TxClear, RxClear : boolean) : boolean');
    RegisterMethod('Procedure SetConfig( SerialConfig : TSerialConfig)');
    RegisterMethod('Function GetConfig : TSerialConfig');
    RegisterMethod('Function ConfigToStr( SerialConfig : TSerialConfig) : string');
    RegisterMethod('Function StrToConfig( CfgStr : string) : TSerialConfig');
    RegisterMethod('Function SendSerialData(Data: TByteArray; DataSize: cardinal): cardinal');
    RegisterMethod('Function ReceiveSerialData(var Data: TByteArray; DataSize: cardinal): cardinal');
    RegisterMethod('Function SendSerialText(Data: String): cardinal');
    RegisterMethod('Function ReceiveSerialText: string');

    RegisterProperty('BufTrm', 'integer', iptr);
    RegisterProperty('BufRec', 'integer', iptr);
    RegisterProperty('CanTransmitt', 'boolean', iptr);
    RegisterProperty('Active', 'boolean', iptrw);
    RegisterProperty('Baudrate', 'integer', iptrw);
    RegisterProperty('DataBits', 'TDataBits', iptrw);
    RegisterProperty('ParityBit', 'TParityBit', iptrw);
    RegisterProperty('StopBits', 'TStopBits', iptrw);
    RegisterProperty('BufSizeTrm', 'integer', iptrw);
    RegisterProperty('BufSizeRec', 'integer', iptrw);
    RegisterProperty('HandshakeRtsCts', 'boolean', iptrw);
    RegisterProperty('HandshakeDtrDsr', 'boolean', iptrw);
    RegisterProperty('HandshakeXOnXOff', 'boolean', iptrw);
    RegisterProperty('RTSActive', 'boolean', iptrw);
    RegisterProperty('DTRActive', 'boolean', iptrw);
    RegisterProperty('XOnChar', 'char', iptrw);
    RegisterProperty('XOffChar', 'char', iptrw);
    RegisterProperty('XOffLimit', 'integer', iptrw);
    RegisterProperty('XOnLimit', 'integer', iptrw);
    RegisterProperty('ErrorChar', 'char', iptrw);
    RegisterProperty('EofChar', 'char', iptrw);
    RegisterProperty('EventChar', 'char', iptrw);
    RegisterProperty('DataSize', 'integer', iptrw);
    RegisterProperty('ParityCheck', 'boolean', iptr);
    RegisterProperty('ContinueOnXOff', 'boolean', iptrw);
    RegisterProperty('UseErrorChar', 'boolean', iptrw);
    RegisterProperty('EliminateNullChar', 'boolean', iptrw);
    RegisterProperty('AbortOnError', 'boolean', iptrw);
    RegisterProperty('RecTimeOut', 'integer', iptrw);
    RegisterProperty('TrmTimeOut', 'integer', iptrw);
    RegisterProperty('SyncEventHandling', 'boolean', iptrw);
    RegisterProperty('EnableEvents', 'boolean', iptrw);
    RegisterProperty('SyncWait', 'boolean', iptrw);
    RegisterProperty('OnBreak', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCts', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDsr', 'TNotifyEvent', iptrw);
    RegisterProperty('OnError', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRing', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDcd', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRxChar', 'TNotifyEvent', iptrw);
    RegisterProperty('OnEventChar', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTxEmpty', 'TNotifyEvent', iptrw);
    RegisterProperty('OnData', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomSerial(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomSerial') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomSerial') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure PortByIndex( Index : integer)');
    RegisterProperty('SerHandle', 'THandle', iptr);
    RegisterProperty('COMPort', 'integer', iptrw);
    RegisterProperty('ThreadPriority', 'TThreadPriority', iptrw);
    RegisterProperty('OnCOMRemoved', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSerPortThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TSerPortThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TSerPortThread') do
  begin
    RegisterMethod('Constructor Create( SerComp : TSerPort)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSerThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TSerThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TSerThread') do
  begin
    RegisterMethod('Constructor Create( SerComp : TSerial)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCOMManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCOMManager') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCOMManager') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure CheckPorts( ToPort : integer)');
    RegisterMethod('Function RecheckPorts : boolean');
    RegisterMethod('Function PortExists( Port : integer) : boolean');
    RegisterMethod('Function Port2Index( Port : integer) : integer');
    RegisterMethod('Procedure RegisterFeedback( Proc : TFeedbackProc)');
    RegisterMethod('Procedure UnregisterFeedback( Proc : TFeedbackProc)');
    RegisterMethod('Procedure AssignCOM( Instance : TCustomSerial)');
    RegisterProperty('CheckedPorts', 'integer', iptr);
    RegisterProperty('Ports', 'TStringList', iptr);
    RegisterProperty('OnPortAdded', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPortRemoved', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMsgWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMsgWindow') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMsgWindow') do begin
    RegisterProperty('CName', '', iptrw);
    RegisterProperty('Handle', 'THandle', iptrw);
    RegisterProperty('TheObjProc', 'TObjProc', iptrw);
    RegisterMethod('Constructor Create( Name : string; MsgProc : TObjProc)');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Serial(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomSerial');
  CL.AddTypeS('TCOMInfo', 'record Number : integer; Instance : TCustomSerial; e'
   +'nd');
  //CL.AddTypeS('PCOMInfo', '^TCOMInfo // will not work');
  CL.AddTypeS('TFeedbackProc', 'Procedure');
  //CL.AddTypeS('PFeedback', '^TFeedback // will not work');
  //CL.AddTypeS('TFeedback', 'record Proc : TFeedbackProc; Next : PFeedback; end');
  CL.AddTypeS('TObjProc', 'Procedure ( Message, wParam, lParam : longint)');
  SIRegister_TMsgWindow(CL);
  SIRegister_TCOMManager(CL);
  CL.AddTypeS('TDataBits', '( db_4, db_5, db_6, db_7, db_8 )');
  CL.AddTypeS('TParityBit', '( none, odd, even, mark, space )');
  CL.AddTypeS('TStopBits', '( sb_1, sb_15, sb_2 )');
  CL.AddTypeS('TSerialConfig', 'record Valid : boolean; COMPort : integer; Baud'
   +'rate : integer; DataBits : TDataBits; ParityBit : TParityBit; StopBits : T'
   +'StopBits; BufSizeTrm : integer; BufSizeRec : integer; HandshakeRtsCts : bo'
   +'olean; HandshakeDtrDsr : boolean; HandshakeXOnXOff : boolean; RTSActive : '
   +'boolean; DTRActive : boolean; XOnChar : char; XOffChar : char; XOffLimit :'
   +' integer; XOnLimit : integer; ErrorChar : char; EofChar : char; EventChar '
   +': char; ContinueOnXOff : boolean; UseErrorChar : boolean; EliminateNullChar'
   +' : boolean; AbortOnError : boolean; RecTimeOut : integer; TrmTimeOut : in'
   +'teger; end');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSerial');
  SIRegister_TSerThread(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSerPort');
  SIRegister_TSerPortThread(CL);
  SIRegister_TCustomSerial(CL);
  CL.AddTypeS('TRText', 'Function  : string');
  CL.AddTypeS('TTData', 'Function ( var Data, DataSize : integer) : integer');
  CL.AddTypeS('TRData', 'Function ( var Buf, BufSize : integer) : integer');
  CL.AddTypeS('TTText', 'Function ( s : string) : integer');
  CL.AddTypeS('TTData', 'Function ( var Data, DataSize : cardinal) : cardinal');
  CL.AddTypeS('TRData', 'Function ( var Buf, BufSize : cardinal) : cardinal');
  CL.AddTypeS('TTText', 'Function ( s : string) : cardinal');
  SIRegister_TSerial(CL);
  SIRegister_TSerPort(CL);
  SIRegister_TSerStdDlg(CL);
 CL.AddDelphiFunction('Procedure Register');
 CL.AddConstantN('MaxPort','LongInt').SetInt( 4);
 CL.AddConstantN('MaxSupported','LongInt').SetInt( 99);
 CL.AddConstantN('br_000050','LongInt').SetInt( 50);
 CL.AddConstantN('br_000110','LongInt').SetInt( 110);
 CL.AddConstantN('br_000150','LongInt').SetInt( 150);
 CL.AddConstantN('br_000300','LongInt').SetInt( 300);
 CL.AddConstantN('br_000600','LongInt').SetInt( 600);
 CL.AddConstantN('br_001200','LongInt').SetInt( 1200);
 CL.AddConstantN('br_002400','LongInt').SetInt( 2400);
 CL.AddConstantN('br_004800','LongInt').SetInt( 4800);
 CL.AddConstantN('br_009600','LongInt').SetInt( 9600);
 CL.AddConstantN('br_014400','LongInt').SetInt( 14400);
 CL.AddConstantN('br_019200','LongInt').SetInt( 19200);
 CL.AddConstantN('br_028800','LongInt').SetInt( 28800);
 CL.AddConstantN('br_038400','LongInt').SetInt( 38400);
 CL.AddConstantN('br_056000','LongInt').SetInt( 56000);
 CL.AddConstantN('br_057600','LongInt').SetInt( 57600);
 CL.AddConstantN('br_115200','LongInt').SetInt( 115200);
 CL.AddConstantN('br_128000','LongInt').SetInt( 128000);
 CL.AddConstantN('br_230400','LongInt').SetInt( 230400);
 CL.AddConstantN('br_256000','LongInt').SetInt( 256000);
 CL.AddConstantN('br_460800','LongInt').SetInt( 460800);
 CL.AddConstantN('br_921600','LongInt').SetInt( 921600);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSerStdDlgSerial_W(Self: TSerStdDlg; const T: TSerial);
begin Self.Serial := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerStdDlgSerial_R(Self: TSerStdDlg; var T: TSerial);
begin T := Self.Serial; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOnDcd_W(Self: TSerPort; const T: TNotifyEvent);
begin Self.OnDcd := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOnDcd_R(Self: TSerPort; var T: TNotifyEvent);
begin T := Self.OnDcd; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOnRing_W(Self: TSerPort; const T: TNotifyEvent);
begin Self.OnRing := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOnRing_R(Self: TSerPort; var T: TNotifyEvent);
begin T := Self.OnRing; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOnDsr_W(Self: TSerPort; const T: TNotifyEvent);
begin Self.OnDsr := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOnDsr_R(Self: TSerPort; var T: TNotifyEvent);
begin T := Self.OnDsr; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOnCts_W(Self: TSerPort; const T: TNotifyEvent);
begin Self.OnCts := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOnCts_R(Self: TSerPort; var T: TNotifyEvent);
begin T := Self.OnCts; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortPollingMode_W(Self: TSerPort; const T: boolean);
begin Self.PollingMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortPollingMode_R(Self: TSerPort; var T: boolean);
begin T := Self.PollingMode; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortIn_RI_R(Self: TSerPort; var T: boolean);
begin T := Self.In_RI; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortIn_CTS_R(Self: TSerPort; var T: boolean);
begin T := Self.In_CTS; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortIn_DSR_R(Self: TSerPort; var T: boolean);
begin T := Self.In_DSR; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortIn_DCD_R(Self: TSerPort; var T: boolean);
begin T := Self.In_DCD; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOut_TxD_W(Self: TSerPort; const T: boolean);
begin Self.Out_TxD := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOut_TxD_R(Self: TSerPort; var T: boolean);
begin T := Self.Out_TxD; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOut_RTS_W(Self: TSerPort; const T: boolean);
begin Self.Out_RTS := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOut_RTS_R(Self: TSerPort; var T: boolean);
begin T := Self.Out_RTS; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOut_DTR_W(Self: TSerPort; const T: boolean);
begin Self.Out_DTR := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortOut_DTR_R(Self: TSerPort; var T: boolean);
begin T := Self.Out_DTR; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortActive_W(Self: TSerPort; const T: boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerPortActive_R(Self: TSerPort; var T: boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnData_W(Self: TSerial; const T: TNotifyEvent);
begin Self.OnData := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnData_R(Self: TSerial; var T: TNotifyEvent);
begin T := Self.OnData; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnTxEmpty_W(Self: TSerial; const T: TNotifyEvent);
begin Self.OnTxEmpty := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnTxEmpty_R(Self: TSerial; var T: TNotifyEvent);
begin T := Self.OnTxEmpty; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnEventChar_W(Self: TSerial; const T: TNotifyEvent);
begin Self.OnEventChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnEventChar_R(Self: TSerial; var T: TNotifyEvent);
begin T := Self.OnEventChar; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnRxChar_W(Self: TSerial; const T: TNotifyEvent);
begin Self.OnRxChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnRxChar_R(Self: TSerial; var T: TNotifyEvent);
begin T := Self.OnRxChar; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnDcd_W(Self: TSerial; const T: TNotifyEvent);
begin Self.OnDcd := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnDcd_R(Self: TSerial; var T: TNotifyEvent);
begin T := Self.OnDcd; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnRing_W(Self: TSerial; const T: TNotifyEvent);
begin Self.OnRing := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnRing_R(Self: TSerial; var T: TNotifyEvent);
begin T := Self.OnRing; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnError_W(Self: TSerial; const T: TNotifyEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnError_R(Self: TSerial; var T: TNotifyEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnDsr_W(Self: TSerial; const T: TNotifyEvent);
begin Self.OnDsr := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnDsr_R(Self: TSerial; var T: TNotifyEvent);
begin T := Self.OnDsr; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnCts_W(Self: TSerial; const T: TNotifyEvent);
begin Self.OnCts := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnCts_R(Self: TSerial; var T: TNotifyEvent);
begin T := Self.OnCts; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnBreak_W(Self: TSerial; const T: TNotifyEvent);
begin Self.OnBreak := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialOnBreak_R(Self: TSerial; var T: TNotifyEvent);
begin T := Self.OnBreak; end;

(*----------------------------------------------------------------------------*)
procedure TSerialSyncWait_W(Self: TSerial; const T: boolean);
begin Self.SyncWait := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialSyncWait_R(Self: TSerial; var T: boolean);
begin T := Self.SyncWait; end;

(*----------------------------------------------------------------------------*)
procedure TSerialEnableEvents_W(Self: TSerial; const T: boolean);
begin Self.EnableEvents := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialEnableEvents_R(Self: TSerial; var T: boolean);
begin T := Self.EnableEvents; end;

(*----------------------------------------------------------------------------*)
procedure TSerialSyncEventHandling_W(Self: TSerial; const T: boolean);
begin Self.SyncEventHandling := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialSyncEventHandling_R(Self: TSerial; var T: boolean);
begin T := Self.SyncEventHandling; end;

(*----------------------------------------------------------------------------*)
procedure TSerialTrmTimeOut_W(Self: TSerial; const T: integer);
begin Self.TrmTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialTrmTimeOut_R(Self: TSerial; var T: integer);
begin T := Self.TrmTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TSerialRecTimeOut_W(Self: TSerial; const T: integer);
begin Self.RecTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialRecTimeOut_R(Self: TSerial; var T: integer);
begin T := Self.RecTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TSerialAbortOnError_W(Self: TSerial; const T: boolean);
begin Self.AbortOnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialAbortOnError_R(Self: TSerial; var T: boolean);
begin T := Self.AbortOnError; end;

(*----------------------------------------------------------------------------*)
procedure TSerialEliminateNullChar_W(Self: TSerial; const T: boolean);
begin Self.EliminateNullChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialEliminateNullChar_R(Self: TSerial; var T: boolean);
begin T := Self.EliminateNullChar; end;

(*----------------------------------------------------------------------------*)
procedure TSerialUseErrorChar_W(Self: TSerial; const T: boolean);
begin Self.UseErrorChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialUseErrorChar_R(Self: TSerial; var T: boolean);
begin T := Self.UseErrorChar; end;

(*----------------------------------------------------------------------------*)
procedure TSerialContinueOnXOff_W(Self: TSerial; const T: boolean);
begin Self.ContinueOnXOff := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialContinueOnXOff_R(Self: TSerial; var T: boolean);
begin T := Self.ContinueOnXOff; end;

(*----------------------------------------------------------------------------*)
procedure TSerialParityCheck_R(Self: TSerial; var T: boolean);
begin T := Self.ParityCheck; end;

(*----------------------------------------------------------------------------*)
procedure TSerialDataSize_W(Self: TSerial; const T: integer);
begin Self.DataSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialDataSize_R(Self: TSerial; var T: integer);
begin T := Self.DataSize; end;

(*----------------------------------------------------------------------------*)
procedure TSerialEventChar_W(Self: TSerial; const T: char);
begin Self.EventChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialEventChar_R(Self: TSerial; var T: char);
begin T := Self.EventChar; end;

(*----------------------------------------------------------------------------*)
procedure TSerialEofChar_W(Self: TSerial; const T: char);
begin Self.EofChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialEofChar_R(Self: TSerial; var T: char);
begin T := Self.EofChar; end;

(*----------------------------------------------------------------------------*)
procedure TSerialErrorChar_W(Self: TSerial; const T: char);
begin Self.ErrorChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialErrorChar_R(Self: TSerial; var T: char);
begin T := Self.ErrorChar; end;

(*----------------------------------------------------------------------------*)
procedure TSerialXOnLimit_W(Self: TSerial; const T: integer);
begin Self.XOnLimit := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialXOnLimit_R(Self: TSerial; var T: integer);
begin T := Self.XOnLimit; end;

(*----------------------------------------------------------------------------*)
procedure TSerialXOffLimit_W(Self: TSerial; const T: integer);
begin Self.XOffLimit := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialXOffLimit_R(Self: TSerial; var T: integer);
begin T := Self.XOffLimit; end;

(*----------------------------------------------------------------------------*)
procedure TSerialXOffChar_W(Self: TSerial; const T: char);
begin Self.XOffChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialXOffChar_R(Self: TSerial; var T: char);
begin T := Self.XOffChar; end;

(*----------------------------------------------------------------------------*)
procedure TSerialXOnChar_W(Self: TSerial; const T: char);
begin Self.XOnChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialXOnChar_R(Self: TSerial; var T: char);
begin T := Self.XOnChar; end;

(*----------------------------------------------------------------------------*)
procedure TSerialDTRActive_W(Self: TSerial; const T: boolean);
begin Self.DTRActive := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialDTRActive_R(Self: TSerial; var T: boolean);
begin T := Self.DTRActive; end;

(*----------------------------------------------------------------------------*)
procedure TSerialRTSActive_W(Self: TSerial; const T: boolean);
begin Self.RTSActive := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialRTSActive_R(Self: TSerial; var T: boolean);
begin T := Self.RTSActive; end;

(*----------------------------------------------------------------------------*)
procedure TSerialHandshakeXOnXOff_W(Self: TSerial; const T: boolean);
begin Self.HandshakeXOnXOff := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialHandshakeXOnXOff_R(Self: TSerial; var T: boolean);
begin T := Self.HandshakeXOnXOff; end;

(*----------------------------------------------------------------------------*)
procedure TSerialHandshakeDtrDsr_W(Self: TSerial; const T: boolean);
begin Self.HandshakeDtrDsr := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialHandshakeDtrDsr_R(Self: TSerial; var T: boolean);
begin T := Self.HandshakeDtrDsr; end;

(*----------------------------------------------------------------------------*)
procedure TSerialHandshakeRtsCts_W(Self: TSerial; const T: boolean);
begin Self.HandshakeRtsCts := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialHandshakeRtsCts_R(Self: TSerial; var T: boolean);
begin T := Self.HandshakeRtsCts; end;

(*----------------------------------------------------------------------------*)
procedure TSerialBufSizeRec_W(Self: TSerial; const T: integer);
begin Self.BufSizeRec := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialBufSizeRec_R(Self: TSerial; var T: integer);
begin T := Self.BufSizeRec; end;

(*----------------------------------------------------------------------------*)
procedure TSerialBufSizeTrm_W(Self: TSerial; const T: integer);
begin Self.BufSizeTrm := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialBufSizeTrm_R(Self: TSerial; var T: integer);
begin T := Self.BufSizeTrm; end;

(*----------------------------------------------------------------------------*)
procedure TSerialStopBits_W(Self: TSerial; const T: TStopBits);
begin Self.StopBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialStopBits_R(Self: TSerial; var T: TStopBits);
begin T := Self.StopBits; end;

(*----------------------------------------------------------------------------*)
procedure TSerialParityBit_W(Self: TSerial; const T: TParityBit);
begin Self.ParityBit := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialParityBit_R(Self: TSerial; var T: TParityBit);
begin T := Self.ParityBit; end;

(*----------------------------------------------------------------------------*)
procedure TSerialDataBits_W(Self: TSerial; const T: TDataBits);
begin Self.DataBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialDataBits_R(Self: TSerial; var T: TDataBits);
begin T := Self.DataBits; end;

(*----------------------------------------------------------------------------*)
procedure TSerialBaudrate_W(Self: TSerial; const T: integer);
begin Self.Baudrate := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialBaudrate_R(Self: TSerial; var T: integer);
begin T := Self.Baudrate; end;

(*----------------------------------------------------------------------------*)
procedure TSerialActive_W(Self: TSerial; const T: boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialActive_R(Self: TSerial; var T: boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TSerialCanTransmitt_R(Self: TSerial; var T: boolean);
begin T := Self.CanTransmitt; end;

(*----------------------------------------------------------------------------*)
procedure TSerialBufRec_R(Self: TSerial; var T: integer);
begin T := Self.BufRec; end;

(*----------------------------------------------------------------------------*)
procedure TSerialBufTrm_R(Self: TSerial; var T: integer);
begin T := Self.BufTrm; end;

(*----------------------------------------------------------------------------*)
procedure TSerialReceiveText_W(Self: TSerial; const T: TRText);
Begin Self.ReceiveText := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialReceiveText_R(Self: TSerial; var T: TRText);
Begin T := Self.ReceiveText; end;

(*----------------------------------------------------------------------------*)
procedure TSerialTransmittText_W(Self: TSerial; const T: TTText);
Begin Self.TransmittText := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialTransmittText_R(Self: TSerial; var T: TTText);
Begin T := Self.TransmittText; end;

(*----------------------------------------------------------------------------*)
procedure TSerialReceiveData_W(Self: TSerial; const T: TRData);
Begin Self.ReceiveData := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialReceiveData_R(Self: TSerial; var T: TRData);
Begin T := Self.ReceiveData; end;

(*----------------------------------------------------------------------------*)
procedure TSerialTransmittData_W(Self: TSerial; const T: TTData);
Begin Self.TransmittData := T; end;

(*----------------------------------------------------------------------------*)
procedure TSerialTransmittData_R(Self: TSerial; var T: TTData);
Begin T := Self.TransmittData; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSerialOnCOMRemoved_W(Self: TCustomSerial; const T: TNotifyEvent);
begin Self.OnCOMRemoved := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSerialOnCOMRemoved_R(Self: TCustomSerial; var T: TNotifyEvent);
begin T := Self.OnCOMRemoved; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSerialThreadPriority_W(Self: TCustomSerial; const T: TThreadPriority);
begin Self.ThreadPriority := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSerialThreadPriority_R(Self: TCustomSerial; var T: TThreadPriority);
begin T := Self.ThreadPriority; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSerialCOMPort_W(Self: TCustomSerial; const T: integer);
begin Self.COMPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSerialCOMPort_R(Self: TCustomSerial; var T: integer);
begin T := Self.COMPort; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSerialSerHandle_R(Self: TCustomSerial; var T: THandle);
begin T := Self.SerHandle; end;

(*----------------------------------------------------------------------------*)
procedure TCOMManagerOnPortRemoved_W(Self: TCOMManager; const T: TNotifyEvent);
begin Self.OnPortRemoved := T; end;

(*----------------------------------------------------------------------------*)
procedure TCOMManagerOnPortRemoved_R(Self: TCOMManager; var T: TNotifyEvent);
begin T := Self.OnPortRemoved; end;

(*----------------------------------------------------------------------------*)
procedure TCOMManagerOnPortAdded_W(Self: TCOMManager; const T: TNotifyEvent);
begin Self.OnPortAdded := T; end;

(*----------------------------------------------------------------------------*)
procedure TCOMManagerOnPortAdded_R(Self: TCOMManager; var T: TNotifyEvent);
begin T := Self.OnPortAdded; end;

(*----------------------------------------------------------------------------*)
procedure TCOMManagerPorts_R(Self: TCOMManager; var T: TStringList);
begin T := Self.Ports; end;

(*----------------------------------------------------------------------------*)
procedure TCOMManagerCheckedPorts_R(Self: TCOMManager; var T: integer);
begin T := Self.CheckedPorts; end;

(*----------------------------------------------------------------------------*)
procedure TMsgWindowTheObjProc_W(Self: TMsgWindow; const T: TObjProc);
Begin Self.TheObjProc := T; end;

(*----------------------------------------------------------------------------*)
procedure TMsgWindowTheObjProc_R(Self: TMsgWindow; var T: TObjProc);
Begin T := Self.TheObjProc; end;

(*----------------------------------------------------------------------------*)
procedure TMsgWindowHandle_W(Self: TMsgWindow; const T: THandle);
Begin Self.Handle := T; end;

(*----------------------------------------------------------------------------*)
procedure TMsgWindowHandle_R(Self: TMsgWindow; var T: THandle);
Begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
{procedure TMsgWindowCName_W(Self: TMsgWindow; const T: integer);
Begin Self.CName := T; end;

(*----------------------------------------------------------------------------*)
procedure TMsgWindowCName_R(Self: TMsgWindow; var T: );
Begin T := Self.CName; end;}

(*----------------------------------------------------------------------------*)
procedure RIRegister_Serial_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSerStdDlg(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSerStdDlg) do begin
    RegisterMethod(@TSerStdDlg.Execute, 'Execute');
    RegisterPropertyHelper(@TSerStdDlgSerial_R,@TSerStdDlgSerial_W,'Serial');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSerPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSerPort) do begin
    RegisterConstructor(@TSerPort.Create, 'Create');
    RegisterMethod(@TSerPort.Destroy, 'Free');
    RegisterVirtualMethod(@TSerPort.OpenComm, 'OpenComm');
    RegisterVirtualMethod(@TSerPort.CloseComm, 'CloseComm');
    RegisterPropertyHelper(@TSerPortActive_R,@TSerPortActive_W,'Active');
    RegisterPropertyHelper(@TSerPortOut_DTR_R,@TSerPortOut_DTR_W,'Out_DTR');
    RegisterPropertyHelper(@TSerPortOut_RTS_R,@TSerPortOut_RTS_W,'Out_RTS');
    RegisterPropertyHelper(@TSerPortOut_TxD_R,@TSerPortOut_TxD_W,'Out_TxD');
    RegisterPropertyHelper(@TSerPortIn_DCD_R,nil,'In_DCD');
    RegisterPropertyHelper(@TSerPortIn_DSR_R,nil,'In_DSR');
    RegisterPropertyHelper(@TSerPortIn_CTS_R,nil,'In_CTS');
    RegisterPropertyHelper(@TSerPortIn_RI_R,nil,'In_RI');
    RegisterPropertyHelper(@TSerPortPollingMode_R,@TSerPortPollingMode_W,'PollingMode');
    RegisterPropertyHelper(@TSerPortOnCts_R,@TSerPortOnCts_W,'OnCts');
    RegisterPropertyHelper(@TSerPortOnDsr_R,@TSerPortOnDsr_W,'OnDsr');
    RegisterPropertyHelper(@TSerPortOnRing_R,@TSerPortOnRing_W,'OnRing');
    RegisterPropertyHelper(@TSerPortOnDcd_R,@TSerPortOnDcd_W,'OnDcd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSerial(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSerial) do begin
    RegisterPropertyHelper(@TSerialTransmittData_R,@TSerialTransmittData_W,'TransmittData');
    RegisterPropertyHelper(@TSerialReceiveData_R,@TSerialReceiveData_W,'ReceiveData');
    RegisterPropertyHelper(@TSerialTransmittText_R,@TSerialTransmittText_W,'TransmittText');
    RegisterPropertyHelper(@TSerialReceiveText_R,@TSerialReceiveText_W,'ReceiveText');
    RegisterConstructor(@TSerial.Create, 'Create');
    RegisterMethod(@TSerial.Destroy, 'Free');
    RegisterVirtualMethod(@TSerial.OpenComm, 'OpenComm');
    RegisterVirtualMethod(@TSerial.CloseComm, 'CloseComm');
    RegisterMethod(@TSerial.Purge, 'Purge');
    RegisterVirtualMethod(@TSerial.SetConfig, 'SetConfig');
    RegisterVirtualMethod(@TSerial.GetConfig, 'GetConfig');
    RegisterVirtualMethod(@TSerial.ConfigToStr, 'ConfigToStr');
    RegisterVirtualMethod(@TSerial.StrToConfig, 'StrToConfig');

    RegisterMethod(@TSerial.SendSerialData, 'SendSerialData');
    RegisterMethod(@TSerial.ReceiveSerialData, 'ReceiveSerialData');
    RegisterMethod(@TSerial.SendSerialText, 'SendSerialText');
    RegisterMethod(@TSerial.ReceiveSerialText, 'ReceiveSerialText');

    RegisterPropertyHelper(@TSerialBufTrm_R,nil,'BufTrm');
    RegisterPropertyHelper(@TSerialBufRec_R,nil,'BufRec');
    RegisterPropertyHelper(@TSerialCanTransmitt_R,nil,'CanTransmitt');
    RegisterPropertyHelper(@TSerialActive_R,@TSerialActive_W,'Active');
    RegisterPropertyHelper(@TSerialBaudrate_R,@TSerialBaudrate_W,'Baudrate');
    RegisterPropertyHelper(@TSerialDataBits_R,@TSerialDataBits_W,'DataBits');
    RegisterPropertyHelper(@TSerialParityBit_R,@TSerialParityBit_W,'ParityBit');
    RegisterPropertyHelper(@TSerialStopBits_R,@TSerialStopBits_W,'StopBits');
    RegisterPropertyHelper(@TSerialBufSizeTrm_R,@TSerialBufSizeTrm_W,'BufSizeTrm');
    RegisterPropertyHelper(@TSerialBufSizeRec_R,@TSerialBufSizeRec_W,'BufSizeRec');
    RegisterPropertyHelper(@TSerialHandshakeRtsCts_R,@TSerialHandshakeRtsCts_W,'HandshakeRtsCts');
    RegisterPropertyHelper(@TSerialHandshakeDtrDsr_R,@TSerialHandshakeDtrDsr_W,'HandshakeDtrDsr');
    RegisterPropertyHelper(@TSerialHandshakeXOnXOff_R,@TSerialHandshakeXOnXOff_W,'HandshakeXOnXOff');
    RegisterPropertyHelper(@TSerialRTSActive_R,@TSerialRTSActive_W,'RTSActive');
    RegisterPropertyHelper(@TSerialDTRActive_R,@TSerialDTRActive_W,'DTRActive');
    RegisterPropertyHelper(@TSerialXOnChar_R,@TSerialXOnChar_W,'XOnChar');
    RegisterPropertyHelper(@TSerialXOffChar_R,@TSerialXOffChar_W,'XOffChar');
    RegisterPropertyHelper(@TSerialXOffLimit_R,@TSerialXOffLimit_W,'XOffLimit');
    RegisterPropertyHelper(@TSerialXOnLimit_R,@TSerialXOnLimit_W,'XOnLimit');
    RegisterPropertyHelper(@TSerialErrorChar_R,@TSerialErrorChar_W,'ErrorChar');
    RegisterPropertyHelper(@TSerialEofChar_R,@TSerialEofChar_W,'EofChar');
    RegisterPropertyHelper(@TSerialEventChar_R,@TSerialEventChar_W,'EventChar');
    RegisterPropertyHelper(@TSerialDataSize_R,@TSerialDataSize_W,'DataSize');
    RegisterPropertyHelper(@TSerialParityCheck_R,nil,'ParityCheck');
    RegisterPropertyHelper(@TSerialContinueOnXOff_R,@TSerialContinueOnXOff_W,'ContinueOnXOff');
    RegisterPropertyHelper(@TSerialUseErrorChar_R,@TSerialUseErrorChar_W,'UseErrorChar');
    RegisterPropertyHelper(@TSerialEliminateNullChar_R,@TSerialEliminateNullChar_W,'EliminateNullChar');
    RegisterPropertyHelper(@TSerialAbortOnError_R,@TSerialAbortOnError_W,'AbortOnError');
    RegisterPropertyHelper(@TSerialRecTimeOut_R,@TSerialRecTimeOut_W,'RecTimeOut');
    RegisterPropertyHelper(@TSerialTrmTimeOut_R,@TSerialTrmTimeOut_W,'TrmTimeOut');
    RegisterPropertyHelper(@TSerialSyncEventHandling_R,@TSerialSyncEventHandling_W,'SyncEventHandling');
    RegisterPropertyHelper(@TSerialEnableEvents_R,@TSerialEnableEvents_W,'EnableEvents');
    RegisterPropertyHelper(@TSerialSyncWait_R,@TSerialSyncWait_W,'SyncWait');
    RegisterPropertyHelper(@TSerialOnBreak_R,@TSerialOnBreak_W,'OnBreak');
    RegisterPropertyHelper(@TSerialOnCts_R,@TSerialOnCts_W,'OnCts');
    RegisterPropertyHelper(@TSerialOnDsr_R,@TSerialOnDsr_W,'OnDsr');
    RegisterPropertyHelper(@TSerialOnError_R,@TSerialOnError_W,'OnError');
    RegisterPropertyHelper(@TSerialOnRing_R,@TSerialOnRing_W,'OnRing');
    RegisterPropertyHelper(@TSerialOnDcd_R,@TSerialOnDcd_W,'OnDcd');
    RegisterPropertyHelper(@TSerialOnRxChar_R,@TSerialOnRxChar_W,'OnRxChar');
    RegisterPropertyHelper(@TSerialOnEventChar_R,@TSerialOnEventChar_W,'OnEventChar');
    RegisterPropertyHelper(@TSerialOnTxEmpty_R,@TSerialOnTxEmpty_W,'OnTxEmpty');
    RegisterPropertyHelper(@TSerialOnData_R,@TSerialOnData_W,'OnData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomSerial(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomSerial) do begin
    RegisterConstructor(@TCustomSerial.Create, 'Create');
   RegisterMethod(@TCustomSerial.Destroy, 'Free');
    RegisterMethod(@TCustomSerial.PortByIndex, 'PortByIndex');
    RegisterPropertyHelper(@TCustomSerialSerHandle_R,nil,'SerHandle');
    RegisterPropertyHelper(@TCustomSerialCOMPort_R,@TCustomSerialCOMPort_W,'COMPort');
    RegisterPropertyHelper(@TCustomSerialThreadPriority_R,@TCustomSerialThreadPriority_W,'ThreadPriority');
    RegisterPropertyHelper(@TCustomSerialOnCOMRemoved_R,@TCustomSerialOnCOMRemoved_W,'OnCOMRemoved');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSerPortThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSerPortThread) do
  begin
    RegisterConstructor(@TSerPortThread.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSerThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSerThread) do
  begin
    RegisterConstructor(@TSerThread.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCOMManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCOMManager) do begin
    RegisterConstructor(@TCOMManager.Create, 'Create');
    RegisterMethod(@TCOMManager.Destroy, 'Free');
    RegisterMethod(@TCOMManager.CheckPorts, 'CheckPorts');
    RegisterMethod(@TCOMManager.RecheckPorts, 'RecheckPorts');
    RegisterMethod(@TCOMManager.PortExists, 'PortExists');
    RegisterMethod(@TCOMManager.Port2Index, 'Port2Index');
    RegisterMethod(@TCOMManager.RegisterFeedback, 'RegisterFeedback');
    RegisterMethod(@TCOMManager.UnregisterFeedback, 'UnregisterFeedback');
    RegisterMethod(@TCOMManager.AssignCOM, 'AssignCOM');
    RegisterPropertyHelper(@TCOMManagerCheckedPorts_R,nil,'CheckedPorts');
    RegisterPropertyHelper(@TCOMManagerPorts_R,nil,'Ports');
    RegisterPropertyHelper(@TCOMManagerOnPortAdded_R,@TCOMManagerOnPortAdded_W,'OnPortAdded');
    RegisterPropertyHelper(@TCOMManagerOnPortRemoved_R,@TCOMManagerOnPortRemoved_W,'OnPortRemoved');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMsgWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMsgWindow) do begin
    //RegisterPropertyHelper(@TMsgWindowCName_R,@TMsgWindowCName_W,'CName');
    RegisterPropertyHelper(@TMsgWindowHandle_R,@TMsgWindowHandle_W,'Handle');
    RegisterPropertyHelper(@TMsgWindowTheObjProc_R,@TMsgWindowTheObjProc_W,'TheObjProc');
    RegisterConstructor(@TMsgWindow.Create, 'Create');
    RegisterMethod(@TMsgWindow.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Serial(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomSerial) do
  RIRegister_TMsgWindow(CL);
  RIRegister_TCOMManager(CL);
  with CL.Add(TSerial) do
  RIRegister_TSerThread(CL);
  with CL.Add(TSerPort) do
  RIRegister_TSerPortThread(CL);
  RIRegister_TCustomSerial(CL);
  RIRegister_TSerial(CL);
  RIRegister_TSerPort(CL);
  RIRegister_TSerStdDlg(CL);
end;

 
 
{ TPSImport_Serial }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Serial.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Serial(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Serial.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Serial(ri);
  RIRegister_Serial_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
