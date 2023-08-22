unit uPSI_WDosPlcs;
{
  plc bitbus
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
  TPSImport_WDosPlcs = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TwdxPetriNet(CL: TPSPascalCompiler);
procedure SIRegister_TCustomPetriNet(CL: TPSPascalCompiler);
procedure SIRegister_TCustomInOut(CL: TPSPascalCompiler);
procedure SIRegister_TwdxPlc(CL: TPSPascalCompiler);
procedure SIRegister_WDosPlcs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TwdxPetriNet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomPetriNet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomInOut(CL: TPSRuntimeClassImporter);
procedure RIRegister_TwdxPlc(CL: TPSRuntimeClassImporter);
procedure RIRegister_WDosPlcs(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WDosPlcUtils
  ,WDosPlcs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WDosPlcs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TwdxPetriNet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPetriNet', 'TwdxPetriNet') do
  with CL.AddClassN(CL.FindClass('TCustomPetriNet'),'TwdxPetriNet') do begin
    RegisterProperty('Inp01', 'TBitAddr', iptrw);
    RegisterProperty('Inp02', 'TBitAddr', iptrw);
    RegisterProperty('Inp03', 'TBitAddr', iptrw);
    RegisterProperty('Inp04', 'TBitAddr', iptrw);
    RegisterProperty('Inp05', 'TBitAddr', iptrw);
    RegisterProperty('Inp06', 'TBitAddr', iptrw);
    RegisterProperty('Inp07', 'TBitAddr', iptrw);
    RegisterProperty('Inp08', 'TBitAddr', iptrw);
    RegisterProperty('Inp09', 'TBitAddr', iptrw);
    RegisterProperty('Inp10', 'TBitAddr', iptrw);
    RegisterProperty('Inp11', 'TBitAddr', iptrw);
    RegisterProperty('Inp12', 'TBitAddr', iptrw);
    RegisterProperty('Inp13', 'TBitAddr', iptrw);
    RegisterProperty('Inp14', 'TBitAddr', iptrw);
    RegisterProperty('Inp15', 'TBitAddr', iptrw);
    RegisterProperty('Inp16', 'TBitAddr', iptrw);
    RegisterProperty('OnAtState', 'TPetriNetEvent', iptrw);
    RegisterProperty('OnBeginState', 'TPetriNetEvent', iptrw);
    RegisterProperty('OnEndState', 'TPetriNetEvent', iptrw);
    RegisterProperty('OnClearValues', 'TPetriNetEvent', iptrw);
    RegisterProperty('OnReadInputs', 'TPetriNetEvent', iptrw);
    RegisterProperty('OnWriteOutputs', 'TPetriNetEvent', iptrw);
    RegisterProperty('OnStateCtrl', 'TPetriNetStateCtrl', iptrw);
    RegisterProperty('Out01', 'TBitAddr', iptrw);
    RegisterProperty('Out02', 'TBitAddr', iptrw);
    RegisterProperty('Out03', 'TBitAddr', iptrw);
    RegisterProperty('Out04', 'TBitAddr', iptrw);
    RegisterProperty('Out05', 'TBitAddr', iptrw);
    RegisterProperty('Out06', 'TBitAddr', iptrw);
    RegisterProperty('Out07', 'TBitAddr', iptrw);
    RegisterProperty('Out08', 'TBitAddr', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomPetriNet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomPetriNet') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomPetriNet') do begin
    RegisterProperty('State', 'Integer', iptrw);
    RegisterProperty('Plc', 'TwdxPlc', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomInOut(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomInOut') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomInOut') do begin
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure Open');
    RegisterProperty('ErrorCode', 'TErrorCode', iptr);
    RegisterProperty('State', 'TInOutState', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('AfterClose', 'TNotifyEvent', iptrw);
    RegisterProperty('BeforeOpen', 'TNotifyEvent', iptrw);
    RegisterProperty('InOutNo', 'TInOutNo', iptrw);
    RegisterProperty('OnError', 'TErrorEvent', iptrw);
    RegisterProperty('OnErrorTimer', 'TErrorEvent', iptrw);
    RegisterProperty('OnReset', 'TNotifyEvent', iptrw);
    RegisterProperty('Plc', 'TwdxPlc', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TwdxPlc(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TwdxPlc') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TwdxPlc') do begin
    RegisterMethod('Constructor Create( aOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure ClearInOutData');
    RegisterMethod('Procedure Error( aErrorCode : TErrorCode)');
    RegisterMethod('Procedure Halt');
    RegisterMethod('Procedure Process');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Procedure ResetCycleTimes');
    RegisterMethod('Procedure ResumeTimer( var Timer : TDateTime)');
    RegisterMethod('Procedure Run');
    RegisterMethod('Function StartTimer( Delay : LongInt) : TDateTime');
    RegisterMethod('Function StartTimerDateTime( Delay : TDateTime) : TDateTime');
    RegisterMethod('Procedure StopTimer( var Timer : TDateTime)');
    RegisterMethod('Function TimeOut( Timer : TDateTime) : Boolean');
    RegisterMethod('Procedure TimerProcess');
    RegisterMethod('Function InOutState( InOutNo : TInOutNo) : TInOutState');
    RegisterMethod('Function InOutErrorCode( InOutNo : TInOutNo) : TErrorCode');
    RegisterProperty('Bit', 'Boolean TIo TInOutNo Byte TBitNo', iptrw);
    RegisterProperty('BusBit', 'Boolean TIo TInOutNo TStationNo Byte TBitNo', iptrw);
    RegisterProperty('BusByt', 'Byte TIo TInOutNo TStationNo Byte', iptrw);
    RegisterProperty('Byt', 'Byte TIo TInOutNo Byte', iptrw);
    RegisterProperty('ErrorCode', 'TErrorCode', iptr);
    RegisterProperty('Io', 'Boolean TBitAddr', iptrw);
    SetDefaultPropery('Io');
    RegisterProperty('IoByt', 'Byte TByteAddr', iptrw);
    RegisterProperty('MaxCycleTime', 'TDateTime', iptr);
    RegisterProperty('MinCycleTime', 'TDateTime', iptr);
    RegisterProperty('Mode', 'TPlcMode', iptr);
    RegisterProperty('RBit', 'Boolean TIo TInOutNo Byte TBitNo', iptw);
    RegisterProperty('RBusBit', 'Boolean TIo TInOutNo TStationNo Byte TBitNo', iptw);
    RegisterProperty('SBit', 'Boolean TIo TInOutNo Byte TBitNo', iptw);
    RegisterProperty('SBusBit', 'Boolean TIo TInOutNo TStationNo Byte TBitNo', iptw);
    RegisterProperty('AfterInput', 'TNotifyEvent', iptrw);
    RegisterProperty('BeforeOutput', 'TNotifyEvent', iptrw);
    RegisterProperty('Debug', 'Boolean', iptrw);
    RegisterProperty('OnDebug', 'TNotifyEvent', iptrw);
    RegisterProperty('OnInOutReset', 'TNotifyEvent', iptrw);
    RegisterProperty('OnWatchdog', 'TNotifyEvent', iptrw);
    RegisterProperty('Watchdog', 'Boolean', iptrw);
    RegisterProperty('WatchdogTime', 'LongInt', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_WDosPlcs(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DWatchdogTime','LongInt').SetInt( 100);
  CL.AddTypeS('TPlcMode', '( pmoInit, pmoHalt, pmoRun, pmoError )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomInOut');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomPetriNet');
  CL.AddTypeS('TPetriNetEvent', 'Procedure ( Sender : TObject; aState : Integer)');
  CL.AddTypeS('TPetriNetStateCtrl', 'Procedure (Sender : TObject; var aState :Integer)');
  CL.AddTypeS('TErrorEvent', 'Procedure ( Sender : TObject; aErrorCode : TErrorCode)');
  SIRegister_TwdxPlc(CL);
  SIRegister_TCustomInOut(CL);
  SIRegister_TCustomPetriNet(CL);
  SIRegister_TwdxPetriNet(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut08_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Out08 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut08_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Out08; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut07_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Out07 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut07_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Out07; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut06_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Out06 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut06_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Out06; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut05_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Out05 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut05_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Out05; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut04_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Out04 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut04_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Out04; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut03_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Out03 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut03_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Out03; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut02_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Out02 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut02_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Out02; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut01_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Out01 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOut01_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Out01; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnStateCtrl_W(Self: TwdxPetriNet; const T: TPetriNetStateCtrl);
begin Self.OnStateCtrl := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnStateCtrl_R(Self: TwdxPetriNet; var T: TPetriNetStateCtrl);
begin T := Self.OnStateCtrl; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnWriteOutputs_W(Self: TwdxPetriNet; const T: TPetriNetEvent);
begin Self.OnWriteOutputs := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnWriteOutputs_R(Self: TwdxPetriNet; var T: TPetriNetEvent);
begin T := Self.OnWriteOutputs; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnReadInputs_W(Self: TwdxPetriNet; const T: TPetriNetEvent);
begin Self.OnReadInputs := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnReadInputs_R(Self: TwdxPetriNet; var T: TPetriNetEvent);
begin T := Self.OnReadInputs; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnClearValues_W(Self: TwdxPetriNet; const T: TPetriNetEvent);
begin Self.OnClearValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnClearValues_R(Self: TwdxPetriNet; var T: TPetriNetEvent);
begin T := Self.OnClearValues; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnEndState_W(Self: TwdxPetriNet; const T: TPetriNetEvent);
begin Self.OnEndState := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnEndState_R(Self: TwdxPetriNet; var T: TPetriNetEvent);
begin T := Self.OnEndState; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnBeginState_W(Self: TwdxPetriNet; const T: TPetriNetEvent);
begin Self.OnBeginState := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnBeginState_R(Self: TwdxPetriNet; var T: TPetriNetEvent);
begin T := Self.OnBeginState; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnAtState_W(Self: TwdxPetriNet; const T: TPetriNetEvent);
begin Self.OnAtState := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetOnAtState_R(Self: TwdxPetriNet; var T: TPetriNetEvent);
begin T := Self.OnAtState; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp16_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp16 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp16_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp16; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp15_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp15 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp15_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp15; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp14_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp14 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp14_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp14; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp13_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp13 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp13_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp13; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp12_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp12 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp12_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp12; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp11_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp11_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp11; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp10_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp10 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp10_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp10; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp09_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp09 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp09_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp09; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp08_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp08 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp08_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp08; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp07_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp07 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp07_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp07; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp06_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp06 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp06_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp06; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp05_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp05 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp05_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp05; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp04_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp04 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp04_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp04; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp03_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp03 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp03_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp03; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp02_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp02 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp02_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp02; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp01_W(Self: TwdxPetriNet; const T: TBitAddr);
begin Self.Inp01 := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPetriNetInp01_R(Self: TwdxPetriNet; var T: TBitAddr);
begin T := Self.Inp01; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPetriNetPlc_W(Self: TCustomPetriNet; const T: TwdxPlc);
begin Self.Plc := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPetriNetPlc_R(Self: TCustomPetriNet; var T: TwdxPlc);
begin T := Self.Plc; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPetriNetState_W(Self: TCustomPetriNet; const T: Integer);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPetriNetState_R(Self: TCustomPetriNet; var T: Integer);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutPlc_W(Self: TCustomInOut; const T: TwdxPlc);
begin Self.Plc := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutPlc_R(Self: TCustomInOut; var T: TwdxPlc);
begin T := Self.Plc; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutOnReset_W(Self: TCustomInOut; const T: TNotifyEvent);
begin Self.OnReset := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutOnReset_R(Self: TCustomInOut; var T: TNotifyEvent);
begin T := Self.OnReset; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutOnErrorTimer_W(Self: TCustomInOut; const T: TErrorEvent);
begin Self.OnErrorTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutOnErrorTimer_R(Self: TCustomInOut; var T: TErrorEvent);
begin T := Self.OnErrorTimer; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutOnError_W(Self: TCustomInOut; const T: TErrorEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutOnError_R(Self: TCustomInOut; var T: TErrorEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutInOutNo_W(Self: TCustomInOut; const T: TInOutNo);
begin Self.InOutNo := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutInOutNo_R(Self: TCustomInOut; var T: TInOutNo);
begin T := Self.InOutNo; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutBeforeOpen_W(Self: TCustomInOut; const T: TNotifyEvent);
begin Self.BeforeOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutBeforeOpen_R(Self: TCustomInOut; var T: TNotifyEvent);
begin T := Self.BeforeOpen; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutAfterClose_W(Self: TCustomInOut; const T: TNotifyEvent);
begin Self.AfterClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutAfterClose_R(Self: TCustomInOut; var T: TNotifyEvent);
begin T := Self.AfterClose; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutActive_W(Self: TCustomInOut; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutActive_R(Self: TCustomInOut; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutState_R(Self: TCustomInOut; var T: TInOutState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TCustomInOutErrorCode_R(Self: TCustomInOut; var T: TErrorCode);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcWatchdogTime_W(Self: TwdxPlc; const T: LongInt);
begin Self.WatchdogTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcWatchdogTime_R(Self: TwdxPlc; var T: LongInt);
begin T := Self.WatchdogTime; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcWatchdog_W(Self: TwdxPlc; const T: Boolean);
begin Self.Watchdog := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcWatchdog_R(Self: TwdxPlc; var T: Boolean);
begin T := Self.Watchdog; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcOnWatchdog_W(Self: TwdxPlc; const T: TNotifyEvent);
begin Self.OnWatchdog := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcOnWatchdog_R(Self: TwdxPlc; var T: TNotifyEvent);
begin T := Self.OnWatchdog; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcOnInOutReset_W(Self: TwdxPlc; const T: TNotifyEvent);
begin Self.OnInOutReset := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcOnInOutReset_R(Self: TwdxPlc; var T: TNotifyEvent);
begin T := Self.OnInOutReset; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcOnDebug_W(Self: TwdxPlc; const T: TNotifyEvent);
begin Self.OnDebug := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcOnDebug_R(Self: TwdxPlc; var T: TNotifyEvent);
begin T := Self.OnDebug; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcDebug_W(Self: TwdxPlc; const T: Boolean);
begin Self.Debug := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcDebug_R(Self: TwdxPlc; var T: Boolean);
begin T := Self.Debug; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcBeforeOutput_W(Self: TwdxPlc; const T: TNotifyEvent);
begin Self.BeforeOutput := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcBeforeOutput_R(Self: TwdxPlc; var T: TNotifyEvent);
begin T := Self.BeforeOutput; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcAfterInput_W(Self: TwdxPlc; const T: TNotifyEvent);
begin Self.AfterInput := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcAfterInput_R(Self: TwdxPlc; var T: TNotifyEvent);
begin T := Self.AfterInput; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcSBusBit_W(Self: TwdxPlc; const T: Boolean; const t1: TIo; const t2: TInOutNo; const t3: TStationNo; const t4: Byte; const t5: TBitNo);
begin Self.SBusBit[t1, t2, t3, t4, t5] := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcSBit_W(Self: TwdxPlc; const T: Boolean; const t1: TIo; const t2: TInOutNo; const t3: Byte; const t4: TBitNo);
begin Self.SBit[t1, t2, t3, t4] := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcRBusBit_W(Self: TwdxPlc; const T: Boolean; const t1: TIo; const t2: TInOutNo; const t3: TStationNo; const t4: Byte; const t5: TBitNo);
begin Self.RBusBit[t1, t2, t3, t4, t5] := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcRBit_W(Self: TwdxPlc; const T: Boolean; const t1: TIo; const t2: TInOutNo; const t3: Byte; const t4: TBitNo);
begin Self.RBit[t1, t2, t3, t4] := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcMode_R(Self: TwdxPlc; var T: TPlcMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcMinCycleTime_R(Self: TwdxPlc; var T: TDateTime);
begin T := Self.MinCycleTime; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcMaxCycleTime_R(Self: TwdxPlc; var T: TDateTime);
begin T := Self.MaxCycleTime; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcIoByt_W(Self: TwdxPlc; const T: Byte; const t1: TByteAddr);
begin Self.IoByt[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcIoByt_R(Self: TwdxPlc; var T: Byte; const t1: TByteAddr);
begin T := Self.IoByt[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcIo_W(Self: TwdxPlc; const T: Boolean; const t1: TBitAddr);
begin Self.Io[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcIo_R(Self: TwdxPlc; var T: Boolean; const t1: TBitAddr);
begin T := Self.Io[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcErrorCode_R(Self: TwdxPlc; var T: TErrorCode);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcByt_W(Self: TwdxPlc; const T: Byte; const t1: TIo; const t2: TInOutNo; const t3: Byte);
begin Self.Byt[t1, t2, t3] := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcByt_R(Self: TwdxPlc; var T: Byte; const t1: TIo; const t2: TInOutNo; const t3: Byte);
begin T := Self.Byt[t1, t2, t3]; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcBusByt_W(Self: TwdxPlc; const T: Byte; const t1: TIo; const t2: TInOutNo; const t3: TStationNo; const t4: Byte);
begin Self.BusByt[t1, t2, t3, t4] := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcBusByt_R(Self: TwdxPlc; var T: Byte; const t1: TIo; const t2: TInOutNo; const t3: TStationNo; const t4: Byte);
begin T := Self.BusByt[t1, t2, t3, t4]; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcBusBit_W(Self: TwdxPlc; const T: Boolean; const t1: TIo; const t2: TInOutNo; const t3: TStationNo; const t4: Byte; const t5: TBitNo);
begin Self.BusBit[t1, t2, t3, t4, t5] := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcBusBit_R(Self: TwdxPlc; var T: Boolean; const t1: TIo; const t2: TInOutNo; const t3: TStationNo; const t4: Byte; const t5: TBitNo);
begin T := Self.BusBit[t1, t2, t3, t4, t5]; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcBit_W(Self: TwdxPlc; const T: Boolean; const t1: TIo; const t2: TInOutNo; const t3: Byte; const t4: TBitNo);
begin Self.Bit[t1, t2, t3, t4] := T; end;

(*----------------------------------------------------------------------------*)
procedure TwdxPlcBit_R(Self: TwdxPlc; var T: Boolean; const t1: TIo; const t2: TInOutNo; const t3: Byte; const t4: TBitNo);
begin T := Self.Bit[t1, t2, t3, t4]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TwdxPetriNet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TwdxPetriNet) do begin
    RegisterPropertyHelper(@TwdxPetriNetInp01_R,@TwdxPetriNetInp01_W,'Inp01');
    RegisterPropertyHelper(@TwdxPetriNetInp02_R,@TwdxPetriNetInp02_W,'Inp02');
    RegisterPropertyHelper(@TwdxPetriNetInp03_R,@TwdxPetriNetInp03_W,'Inp03');
    RegisterPropertyHelper(@TwdxPetriNetInp04_R,@TwdxPetriNetInp04_W,'Inp04');
    RegisterPropertyHelper(@TwdxPetriNetInp05_R,@TwdxPetriNetInp05_W,'Inp05');
    RegisterPropertyHelper(@TwdxPetriNetInp06_R,@TwdxPetriNetInp06_W,'Inp06');
    RegisterPropertyHelper(@TwdxPetriNetInp07_R,@TwdxPetriNetInp07_W,'Inp07');
    RegisterPropertyHelper(@TwdxPetriNetInp08_R,@TwdxPetriNetInp08_W,'Inp08');
    RegisterPropertyHelper(@TwdxPetriNetInp09_R,@TwdxPetriNetInp09_W,'Inp09');
    RegisterPropertyHelper(@TwdxPetriNetInp10_R,@TwdxPetriNetInp10_W,'Inp10');
    RegisterPropertyHelper(@TwdxPetriNetInp11_R,@TwdxPetriNetInp11_W,'Inp11');
    RegisterPropertyHelper(@TwdxPetriNetInp12_R,@TwdxPetriNetInp12_W,'Inp12');
    RegisterPropertyHelper(@TwdxPetriNetInp13_R,@TwdxPetriNetInp13_W,'Inp13');
    RegisterPropertyHelper(@TwdxPetriNetInp14_R,@TwdxPetriNetInp14_W,'Inp14');
    RegisterPropertyHelper(@TwdxPetriNetInp15_R,@TwdxPetriNetInp15_W,'Inp15');
    RegisterPropertyHelper(@TwdxPetriNetInp16_R,@TwdxPetriNetInp16_W,'Inp16');
    RegisterPropertyHelper(@TwdxPetriNetOnAtState_R,@TwdxPetriNetOnAtState_W,'OnAtState');
    RegisterPropertyHelper(@TwdxPetriNetOnBeginState_R,@TwdxPetriNetOnBeginState_W,'OnBeginState');
    RegisterPropertyHelper(@TwdxPetriNetOnEndState_R,@TwdxPetriNetOnEndState_W,'OnEndState');
    RegisterPropertyHelper(@TwdxPetriNetOnClearValues_R,@TwdxPetriNetOnClearValues_W,'OnClearValues');
    RegisterPropertyHelper(@TwdxPetriNetOnReadInputs_R,@TwdxPetriNetOnReadInputs_W,'OnReadInputs');
    RegisterPropertyHelper(@TwdxPetriNetOnWriteOutputs_R,@TwdxPetriNetOnWriteOutputs_W,'OnWriteOutputs');
    RegisterPropertyHelper(@TwdxPetriNetOnStateCtrl_R,@TwdxPetriNetOnStateCtrl_W,'OnStateCtrl');
    RegisterPropertyHelper(@TwdxPetriNetOut01_R,@TwdxPetriNetOut01_W,'Out01');
    RegisterPropertyHelper(@TwdxPetriNetOut02_R,@TwdxPetriNetOut02_W,'Out02');
    RegisterPropertyHelper(@TwdxPetriNetOut03_R,@TwdxPetriNetOut03_W,'Out03');
    RegisterPropertyHelper(@TwdxPetriNetOut04_R,@TwdxPetriNetOut04_W,'Out04');
    RegisterPropertyHelper(@TwdxPetriNetOut05_R,@TwdxPetriNetOut05_W,'Out05');
    RegisterPropertyHelper(@TwdxPetriNetOut06_R,@TwdxPetriNetOut06_W,'Out06');
    RegisterPropertyHelper(@TwdxPetriNetOut07_R,@TwdxPetriNetOut07_W,'Out07');
    RegisterPropertyHelper(@TwdxPetriNetOut08_R,@TwdxPetriNetOut08_W,'Out08');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomPetriNet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomPetriNet) do
  begin
    RegisterPropertyHelper(@TCustomPetriNetState_R,@TCustomPetriNetState_W,'State');
    RegisterPropertyHelper(@TCustomPetriNetPlc_R,@TCustomPetriNetPlc_W,'Plc');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomInOut(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomInOut) do begin
    RegisterMethod(@TCustomInOut.Close, 'Close');
    RegisterMethod(@TCustomInOut.Open, 'Open');
    RegisterPropertyHelper(@TCustomInOutErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@TCustomInOutState_R,nil,'State');
    RegisterPropertyHelper(@TCustomInOutActive_R,@TCustomInOutActive_W,'Active');
    RegisterPropertyHelper(@TCustomInOutAfterClose_R,@TCustomInOutAfterClose_W,'AfterClose');
    RegisterPropertyHelper(@TCustomInOutBeforeOpen_R,@TCustomInOutBeforeOpen_W,'BeforeOpen');
    RegisterPropertyHelper(@TCustomInOutInOutNo_R,@TCustomInOutInOutNo_W,'InOutNo');
    RegisterPropertyHelper(@TCustomInOutOnError_R,@TCustomInOutOnError_W,'OnError');
    RegisterPropertyHelper(@TCustomInOutOnErrorTimer_R,@TCustomInOutOnErrorTimer_W,'OnErrorTimer');
    RegisterPropertyHelper(@TCustomInOutOnReset_R,@TCustomInOutOnReset_W,'OnReset');
    RegisterPropertyHelper(@TCustomInOutPlc_R,@TCustomInOutPlc_W,'Plc');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TwdxPlc(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TwdxPlc) do begin
    RegisterConstructor(@TwdxPlc.Create, 'Create');
    RegisterMethod(@TwdxPlc.Destroy, 'Free');
    RegisterMethod(@TwdxPlc.ClearInOutData, 'ClearInOutData');
    RegisterMethod(@TwdxPlc.Error, 'Error');
    RegisterMethod(@TwdxPlc.Halt, 'Halt');
    RegisterMethod(@TwdxPlc.Process, 'Process');
    RegisterMethod(@TwdxPlc.Reset, 'Reset');
    RegisterMethod(@TwdxPlc.ResetCycleTimes, 'ResetCycleTimes');
    RegisterMethod(@TwdxPlc.ResumeTimer, 'ResumeTimer');
    RegisterMethod(@TwdxPlc.Run, 'Run');
    RegisterMethod(@TwdxPlc.StartTimer, 'StartTimer');
    RegisterMethod(@TwdxPlc.StartTimerDateTime, 'StartTimerDateTime');
    RegisterMethod(@TwdxPlc.StopTimer, 'StopTimer');
    RegisterMethod(@TwdxPlc.TimeOut, 'TimeOut');
    RegisterMethod(@TwdxPlc.TimerProcess, 'TimerProcess');
    RegisterMethod(@TwdxPlc.InOutState, 'InOutState');
    RegisterMethod(@TwdxPlc.InOutErrorCode, 'InOutErrorCode');
    RegisterPropertyHelper(@TwdxPlcBit_R,@TwdxPlcBit_W,'Bit');
    RegisterPropertyHelper(@TwdxPlcBusBit_R,@TwdxPlcBusBit_W,'BusBit');
    RegisterPropertyHelper(@TwdxPlcBusByt_R,@TwdxPlcBusByt_W,'BusByt');
    RegisterPropertyHelper(@TwdxPlcByt_R,@TwdxPlcByt_W,'Byt');
    RegisterPropertyHelper(@TwdxPlcErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@TwdxPlcIo_R,@TwdxPlcIo_W,'Io');
    RegisterPropertyHelper(@TwdxPlcIoByt_R,@TwdxPlcIoByt_W,'IoByt');
    RegisterPropertyHelper(@TwdxPlcMaxCycleTime_R,nil,'MaxCycleTime');
    RegisterPropertyHelper(@TwdxPlcMinCycleTime_R,nil,'MinCycleTime');
    RegisterPropertyHelper(@TwdxPlcMode_R,nil,'Mode');
    RegisterPropertyHelper(nil,@TwdxPlcRBit_W,'RBit');
    RegisterPropertyHelper(nil,@TwdxPlcRBusBit_W,'RBusBit');
    RegisterPropertyHelper(nil,@TwdxPlcSBit_W,'SBit');
    RegisterPropertyHelper(nil,@TwdxPlcSBusBit_W,'SBusBit');
    RegisterPropertyHelper(@TwdxPlcAfterInput_R,@TwdxPlcAfterInput_W,'AfterInput');
    RegisterPropertyHelper(@TwdxPlcBeforeOutput_R,@TwdxPlcBeforeOutput_W,'BeforeOutput');
    RegisterPropertyHelper(@TwdxPlcDebug_R,@TwdxPlcDebug_W,'Debug');
    RegisterPropertyHelper(@TwdxPlcOnDebug_R,@TwdxPlcOnDebug_W,'OnDebug');
    RegisterPropertyHelper(@TwdxPlcOnInOutReset_R,@TwdxPlcOnInOutReset_W,'OnInOutReset');
    RegisterPropertyHelper(@TwdxPlcOnWatchdog_R,@TwdxPlcOnWatchdog_W,'OnWatchdog');
    RegisterPropertyHelper(@TwdxPlcWatchdog_R,@TwdxPlcWatchdog_W,'Watchdog');
    RegisterPropertyHelper(@TwdxPlcWatchdogTime_R,@TwdxPlcWatchdogTime_W,'WatchdogTime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WDosPlcs(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomInOut) do
  with CL.Add(TCustomPetriNet) do
  RIRegister_TwdxPlc(CL);
  RIRegister_TCustomInOut(CL);
  RIRegister_TCustomPetriNet(CL);
  RIRegister_TwdxPetriNet(CL);
end;

 
 
{ TPSImport_WDosPlcs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosPlcs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WDosPlcs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosPlcs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WDosPlcs(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
