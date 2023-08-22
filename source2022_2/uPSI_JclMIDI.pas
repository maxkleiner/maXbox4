unit uPSI_JclMIDI;
{
  midi in the Box
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
  TPSImport_JclMIDI = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclMIDIOut(CL: TPSPascalCompiler);
procedure SIRegister_IJclMIDIOut(CL: TPSPascalCompiler);
procedure SIRegister_JclMIDI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclMIDI_Routines(S: TPSExec);
procedure RIRegister_TJclMIDIOut(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclMIDI(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   JclBase
  ,JclMIDI
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclMIDI]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMIDIOut(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TJclMIDIOut') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TJclMIDIOut') do begin
    RegisterMethod('Procedure SendNoteOff( Channel : TMIDIChannel; Key : TMIDINote; Velocity : TMIDIDataByte)');
    RegisterMethod('Procedure SendNoteOn( Channel : TMIDIChannel; Key : TMIDINote; Velocity : TMIDIDataByte)');
    RegisterMethod('Procedure SendPolyphonicKeyPressure( Channel : TMIDIChannel; Key : TMIDINote; Value : TMIDIDataByte)');
    RegisterMethod('Procedure SendControlChange( Channel : TMIDIChannel; ControllerNum, Value : TMIDIDataByte)');
    RegisterMethod('Procedure SendControlChangeHR( Channel : TMIDIChannel; ControllerNum : TMIDIDataByte; Value : TMIDIDataWord)');
    RegisterMethod('Procedure SendSwitchChange( Channel : TMIDIChannel; ControllerNum : TMIDIDataByte; Value : Boolean)');
    RegisterMethod('Procedure SendProgramChange( Channel : TMIDIChannel; ProgramNum : TMIDIDataByte)');
    RegisterMethod('Procedure SendChannelPressure( Channel : TMIDIChannel; Value : TMIDIDataByte)');
    RegisterMethod('Procedure SendPitchWheelChange( Channel : TMIDIChannel; Value : TMIDIDataWord)');
    RegisterMethod('Procedure SendPitchWheelPos( Channel : TMIDIChannel; Value : Single)');
    RegisterMethod('Procedure SelectProgram( Channel : TMIDIChannel; BankNum : TMIDIDataWord; ProgramNum : TMIDIDataByte)');
    RegisterMethod('Procedure SendModulationWheelChange( Channel : TMIDIChannel; Value : TMidiDataByte)');
    RegisterMethod('Procedure SendBreathControlChange( Channel : TMIDIChannel; Value : TMidiDataByte)');
    RegisterMethod('Procedure SendFootControllerChange( Channel : TMIDIChannel; Value : TMidiDataByte)');
    RegisterMethod('Procedure SendPortamentoTimeChange( Channel : TMIDIChannel; Value : TMidiDataByte)');
    RegisterMethod('Procedure SendDataEntry( Channel : TMIDIChannel; Value : TMidiDataByte)');
    RegisterMethod('Procedure SendChannelVolumeChange( Channel : TMIDIChannel; Value : TMidiDataByte)');
    RegisterMethod('Procedure SendBalanceChange( Channel : TMIDIChannel; Value : TMidiDataByte)');
    RegisterMethod('Procedure SendPanChange( Channel : TMIDIChannel; Value : TMidiDataByte)');
    RegisterMethod('Procedure SendExpressionChange( Channel : TMIDIChannel; Value : TMidiDataByte)');
    RegisterMethod('Procedure SendModulationWheelChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)');
    RegisterMethod('Procedure SendBreathControlChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)');
    RegisterMethod('Procedure SendFootControllerChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)');
    RegisterMethod('Procedure SendPortamentoTimeChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)');
    RegisterMethod('Procedure SendDataEntryHR( Channel : TMIDIChannel; Value : TMidiDataWord)');
    RegisterMethod('Procedure SendChannelVolumeChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)');
    RegisterMethod('Procedure SendBalanceChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)');
    RegisterMethod('Procedure SendPanChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)');
    RegisterMethod('Procedure SendExpressionChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)');
    RegisterMethod('Procedure SwitchSustain( Channel : TMIDIChannel; Value : Boolean)');
    RegisterMethod('Procedure SwitchPortamento( Channel : TMIDIChannel; Value : Boolean)');
    RegisterMethod('Procedure SwitchSostenuto( Channel : TMIDIChannel; Value : Boolean)');
    RegisterMethod('Procedure SwitchSoftPedal( Channel : TMIDIChannel; Value : Boolean)');
    RegisterMethod('Procedure SwitchLegato( Channel : TMIDIChannel; Value : Boolean)');
    RegisterMethod('Procedure SwitchHold2( Channel : TMIDIChannel; Value : Boolean)');
    RegisterMethod('Procedure SwitchAllSoundOff( Channel : TMIDIChannel)');
    RegisterMethod('Procedure ResetAllControllers( Channel : TMIDIChannel)');
    RegisterMethod('Procedure SwitchLocalControl( Channel : TMIDIChannel; Value : Boolean)');
    RegisterMethod('Procedure SwitchAllNotesOff( Channel : TMIDIChannel)');
    RegisterMethod('Procedure SwitchOmniModeOff( Channel : TMIDIChannel)');
    RegisterMethod('Procedure SwitchOmniModeOn( Channel : TMIDIChannel)');
    RegisterMethod('Procedure SwitchMonoModeOn( Channel : TMIDIChannel; ChannelCount : Integer)');
    RegisterMethod('Procedure SwitchPolyModeOn( Channel : TMIDIChannel)');
    RegisterMethod('Procedure SendSingleNoteTuningChange( const TargetDeviceID, TuningProgramNum : TMidiDataByte; const TuningData : array of TSingleNoteTuningData)');
    RegisterMethod('Function NoteIsOn( Channel : TMIDIChannel; Key : TMIDINote) : Boolean');
    RegisterMethod('Procedure SwitchActiveNotesOff2( Channel : TMIDIChannel);');
    RegisterMethod('Procedure SwitchActiveNotesOff3;');
    RegisterProperty('ActiveNotes', 'TMIDINotes TMIDIChannel', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('RunningStatusEnabled', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclMIDIOut(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IJclMIDIOut') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclMIDIOut, 'IJclMIDIOut') do begin
    RegisterMethod('Function GetActiveNotes( Channel : TMIDIChannel) : TMIDINotes', cdRegister);
    RegisterMethod('Function GetName : string', cdRegister);
    RegisterMethod('Function GetMIDIStatus : TMIDIStatusByte', cdRegister);
    RegisterMethod('Function GetRunningStatusEnabled : Boolean', cdRegister);
    RegisterMethod('Procedure SetRunningStatusEnabled( const Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SendMessage( const Data : array of Byte)', cdRegister);
    RegisterMethod('Procedure SendNoteOff( Channel : TMIDIChannel; Key : TMIDINote; Velocity : TMIDIDataByte)', cdRegister);
    RegisterMethod('Procedure SendNoteOn( Channel : TMIDIChannel; Key : TMIDINote; Velocity : TMIDIDataByte)', cdRegister);
    RegisterMethod('Procedure SendPolyphonicKeyPressure( Channel : TMIDIChannel; Key : TMIDINote; Value : TMIDIDataByte)', cdRegister);
    RegisterMethod('Procedure SendControlChange( Channel : TMIDIChannel; ControllerNum, Value : TMIDIDataByte)', cdRegister);
    RegisterMethod('Procedure SendControlChangeHR( Channel : TMIDIChannel; ControllerNum : TMIDIDataByte; Value : TMIDIDataWord)', cdRegister);
    RegisterMethod('Procedure SendSwitchChange( Channel : TMIDIChannel; ControllerNum : TMIDIDataByte; Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SendProgramChange( Channel : TMIDIChannel; ProgramNum : TMIDIDataByte)', cdRegister);
    RegisterMethod('Procedure SendChannelPressure( Channel : TMIDIChannel; Value : TMIDIDataByte)', cdRegister);
    RegisterMethod('Procedure SendPitchWheelChange( Channel : TMIDIChannel; Value : TMIDIDataWord)', cdRegister);
    RegisterMethod('Procedure SendPitchWheelPos( Channel : TMIDIChannel; Value : Single)', cdRegister);
    RegisterMethod('Procedure SelectProgram( Channel : TMIDIChannel; BankNum : TMIDIDataWord; ProgramNum : TMIDIDataByte)', cdRegister);
    RegisterMethod('Procedure SendModulationWheelChange( Channel : TMIDIChannel; Value : TMidiDataByte)', cdRegister);
    RegisterMethod('Procedure SendBreathControlChange( Channel : TMIDIChannel; Value : TMidiDataByte)', cdRegister);
    RegisterMethod('Procedure SendFootControllerChange( Channel : TMIDIChannel; Value : TMidiDataByte)', cdRegister);
    RegisterMethod('Procedure SendPortamentoTimeChange( Channel : TMIDIChannel; Value : TMidiDataByte)', cdRegister);
    RegisterMethod('Procedure SendDataEntry( Channel : TMIDIChannel; Value : TMidiDataByte)', cdRegister);
    RegisterMethod('Procedure SendChannelVolumeChange( Channel : TMIDIChannel; Value : TMidiDataByte)', cdRegister);
    RegisterMethod('Procedure SendBalanceChange( Channel : TMIDIChannel; Value : TMidiDataByte)', cdRegister);
    RegisterMethod('Procedure SendPanChange( Channel : TMIDIChannel; Value : TMidiDataByte)', cdRegister);
    RegisterMethod('Procedure SendExpressionChange( Channel : TMIDIChannel; Value : TMidiDataByte)', cdRegister);
    RegisterMethod('Procedure SendModulationWheelChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)', cdRegister);
    RegisterMethod('Procedure SendBreathControlChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)', cdRegister);
    RegisterMethod('Procedure SendFootControllerChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)', cdRegister);
    RegisterMethod('Procedure SendPortamentoTimeChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)', cdRegister);
    RegisterMethod('Procedure SendDataEntryHR( Channel : TMIDIChannel; Value : TMidiDataWord)', cdRegister);
    RegisterMethod('Procedure SendChannelVolumeChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)', cdRegister);
    RegisterMethod('Procedure SendBalanceChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)', cdRegister);
    RegisterMethod('Procedure SendPanChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)', cdRegister);
    RegisterMethod('Procedure SendExpressionChangeHR( Channel : TMIDIChannel; Value : TMidiDataWord)', cdRegister);
    RegisterMethod('Procedure SwitchSustain( Channel : TMIDIChannel; Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SwitchPortamento( Channel : TMIDIChannel; Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SwitchSostenuto( Channel : TMIDIChannel; Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SwitchSoftPedal( Channel : TMIDIChannel; Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SwitchLegato( Channel : TMIDIChannel; Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SwitchHold2( Channel : TMIDIChannel; Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SwitchAllSoundOff( Channel : TMIDIChannel)', cdRegister);
    RegisterMethod('Procedure ResetAllControllers( Channel : TMIDIChannel)', cdRegister);
    RegisterMethod('Procedure SwitchLocalControl( Channel : TMIDIChannel; Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SwitchAllNotesOff( Channel : TMIDIChannel)', cdRegister);
    RegisterMethod('Procedure SwitchOmniModeOff( Channel : TMIDIChannel)', cdRegister);
    RegisterMethod('Procedure SwitchOmniModeOn( Channel : TMIDIChannel)', cdRegister);
    RegisterMethod('Procedure SwitchMonoModeOn( Channel : TMIDIChannel; ChannelCount : Integer)', cdRegister);
    RegisterMethod('Procedure SwitchPolyModeOn( Channel : TMIDIChannel)', cdRegister);
    RegisterMethod('Procedure SendSingleNoteTuningChange( const TargetDeviceID, TuningProgramNum : TMidiDataByte; const TuningData : array of TSingleNoteTuningData)', cdRegister);
    RegisterMethod('Function NoteIsOn( Channel : TMIDIChannel; Key : TMIDINote) : Boolean', cdRegister);
    RegisterMethod('Procedure SwitchActiveNotesOff( Channel : TMIDIChannel);', cdRegister);
    RegisterMethod('Procedure SwitchActiveNotesOff1;', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclMIDI(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MIDIMsgNoteOff','LongWord').SetUInt( $80);
 CL.AddConstantN('MIDIMsgNoteOn','LongWord').SetUInt( $90);
 CL.AddConstantN('MIDIMsgPolyKeyPressure','LongWord').SetUInt( $A0);
 CL.AddConstantN('MIDIMsgControlChange','LongWord').SetUInt( $B0);
 CL.AddConstantN('MIDIMsgProgramChange','LongWord').SetUInt( $C0);
 CL.AddConstantN('MIDIMsgChannelKeyPressure','LongWord').SetUInt( $D0);
 CL.AddConstantN('MIDIMsgAftertouch','LongWord').SetUInt(MIDIMsgChannelKeyPressure);
 CL.AddConstantN('MIDIMsgPitchWheelChange','LongWord').SetUInt( $E0);
 CL.AddConstantN('MIDIMsgSysEx','LongWord').SetUInt( $F0);
 CL.AddConstantN('MIDIMsgMTCQtrFrame','LongWord').SetUInt( $F1);
 CL.AddConstantN('MIDIMsgSongPositionPtr','LongWord').SetUInt( $F2);
 CL.AddConstantN('MIDIMsgSongSelect','LongWord').SetUInt( $F3);
 CL.AddConstantN('MIDIMsgTuneRequest','LongWord').SetUInt( $F6);
 CL.AddConstantN('MIDIMsgEOX','LongWord').SetUInt( $F7);
 CL.AddConstantN('MIDIMsgTimingClock','LongWord').SetUInt( $F8);
 CL.AddConstantN('MIDIMsgStartSequence','LongWord').SetUInt( $FA);
 CL.AddConstantN('MIDIMsgContinueSequence','LongWord').SetUInt( $FB);
 CL.AddConstantN('MIDIMsgStopSequence','LongWord').SetUInt( $FC);
 CL.AddConstantN('MIDIMsgActiveSensing','LongWord').SetUInt( $FE);
 CL.AddConstantN('MIDIMsgSystemReset','LongWord').SetUInt( $FF);
 CL.AddConstantN('MIDICCBankSelect','LongWord').SetUInt( $00);
 CL.AddConstantN('MIDICCModulationWheel','LongWord').SetUInt( $01);
 CL.AddConstantN('MIDICCBreathControl','LongWord').SetUInt( $02);
 CL.AddConstantN('MIDICCFootController','LongWord').SetUInt( $04);
 CL.AddConstantN('MIDICCPortamentoTime','LongWord').SetUInt( $05);
 CL.AddConstantN('MIDICCDataEntry','LongWord').SetUInt( $06);
 CL.AddConstantN('MIDICCChannelVolume','LongWord').SetUInt( $07);
 CL.AddConstantN('MIDICCMainVolume','LongWord').SetUInt( MIDICCChannelVolume);
 CL.AddConstantN('MIDICCBalance','LongWord').SetUInt( $08);
 CL.AddConstantN('MIDICCPan','LongWord').SetUInt( $0A);
 CL.AddConstantN('MIDICCExpression','LongWord').SetUInt( $0B);
 CL.AddConstantN('MIDICCEffectControl','LongWord').SetUInt( $0C);
 CL.AddConstantN('MIDICCEffectControl2','LongWord').SetUInt( $0D);
 CL.AddConstantN('MIDICCGeneralPurpose1','LongWord').SetUInt( $10);
 CL.AddConstantN('MIDICCGeneralPurpose2','LongWord').SetUInt( $11);
 CL.AddConstantN('MIDICCGeneralPurpose3','LongWord').SetUInt( $12);
 CL.AddConstantN('MIDICCGeneralPurpose4','LongWord').SetUInt( $13);
 CL.AddConstantN('MIDICCBankSelectLSB','LongWord').SetUInt( $20);
 CL.AddConstantN('MIDICCModulationWheelLSB','LongWord').SetUInt( $21);
 CL.AddConstantN('MIDICCBreathControlLSB','LongWord').SetUInt( $22);
 CL.AddConstantN('MIDICCFootControllerLSB','LongWord').SetUInt( $24);
 CL.AddConstantN('MIDICCPortamentoTimeLSB','LongWord').SetUInt( $25);
 CL.AddConstantN('MIDICCDataEntryLSB','LongWord').SetUInt( $26);
 CL.AddConstantN('MIDICCChannelVolumeLSB','LongWord').SetUInt( $27);
 CL.AddConstantN('MIDICCMainVolumeLSB','LongWord').SetUint( MIDICCChannelVolumeLSB);
 CL.AddConstantN('MIDICCBalanceLSB','LongWord').SetUInt( $28);
 CL.AddConstantN('MIDICCPanLSB','LongWord').SetUInt( $2A);
 CL.AddConstantN('MIDICCExpressionLSB','LongWord').SetUInt( $2B);
 CL.AddConstantN('MIDICCEffectControlLSB','LongWord').SetUInt( $2C);
 CL.AddConstantN('MIDICCEffectControl2LSB','LongWord').SetUInt( $2D);
 CL.AddConstantN('MIDICCGeneralPurpose1LSB','LongWord').SetUInt( $30);
 CL.AddConstantN('MIDICCGeneralPurpose2LSB','LongWord').SetUInt( $31);
 CL.AddConstantN('MIDICCGeneralPurpose3LSB','LongWord').SetUInt( $32);
 CL.AddConstantN('MIDICCGeneralPurpose4LSB','LongWord').SetUInt( $33);
 CL.AddConstantN('MIDICCSustain','LongWord').SetUInt( $40);
 CL.AddConstantN('MIDICCPortamento','LongWord').SetUInt( $41);
 CL.AddConstantN('MIDICCSustenuto','LongWord').SetUInt( $42);
 CL.AddConstantN('MIDICCSoftPedal','LongWord').SetUInt( $43);
 CL.AddConstantN('MIDICCLegato','LongWord').SetUInt( $44);
 CL.AddConstantN('MIDICCHold2','LongWord').SetUInt( $45);
 CL.AddConstantN('MIDICCSound1','LongWord').SetUInt( $46);
 CL.AddConstantN('MIDICCSound2','LongWord').SetUInt( $47);
 CL.AddConstantN('MIDICCSound3','LongWord').SetUInt( $48);
 CL.AddConstantN('MIDICCSound4','LongWord').SetUInt( $49);
 CL.AddConstantN('MIDICCSound5','LongWord').SetUInt( $4A);
 CL.AddConstantN('MIDICCSound6','LongWord').SetUInt( $4B);
 CL.AddConstantN('MIDICCSound7','LongWord').SetUInt( $4C);
 CL.AddConstantN('MIDICCSound8','LongWord').SetUInt( $4D);
 CL.AddConstantN('MIDICCSound9','LongWord').SetUInt( $4E);
 CL.AddConstantN('MIDICCSound10','LongWord').SetUInt( $4F);
 CL.AddConstantN('MIDICCGeneralPurpose5','LongWord').SetUInt( $50);
 CL.AddConstantN('MIDICCGeneralPurpose6','LongWord').SetUInt( $51);
 CL.AddConstantN('MIDICCGeneralPurpose7','LongWord').SetUInt( $52);
 CL.AddConstantN('MIDICCGeneralPurpose8','LongWord').SetUInt( $53);
 CL.AddConstantN('MIDICCPortamentoControl','LongWord').SetUInt( $54);
 CL.AddConstantN('MIDICCReverbSendLevel','LongWord').SetUInt( $5B);
 CL.AddConstantN('MIDICCEffects2Depth','LongWord').SetUInt( $5C);
 CL.AddConstantN('MIDICCTremoloDepth','LongWord').SetUint( MIDICCEffects2Depth);
 CL.AddConstantN('MIDICCChorusSendLevel','LongWord').SetUInt( $5D);
 CL.AddConstantN('MIDICCEffects4Depth','LongWord').SetUInt( $5E);
 CL.AddConstantN('MIDICCCelesteDepth','Longword').SetUint( MIDICCEffects4Depth);
 CL.AddConstantN('MIDICCEffects5Depth','LongWord').SetUInt( $5F);
 CL.AddConstantN('MIDICCPhaserDepth','longword').SetUInt( MIDICCEffects5Depth);
 CL.AddConstantN('MIDICCDataEntryInc','LongWord').SetUInt( $60);
 CL.AddConstantN('MIDICCDataEntryDec','LongWord').SetUInt( $61);
 CL.AddConstantN('MIDICCNonRegParamNumLSB','LongWord').SetUInt( $62);
 CL.AddConstantN('MIDICCNonRegParamNumMSB','LongWord').SetUInt( $63);
 CL.AddConstantN('MIDICCRegParamNumLSB','LongWord').SetUInt( $64);
 CL.AddConstantN('MIDICCRegParamNumMSB','LongWord').SetUInt( $65);
 CL.AddConstantN('MIDICCAllSoundOff','LongWord').SetUInt( $78);
 CL.AddConstantN('MIDICCResetAllControllers','LongWord').SetUInt( $79);
 CL.AddConstantN('MIDICCLocalControl','LongWord').SetUInt( $7A);
 CL.AddConstantN('MIDICCAllNotesOff','LongWord').SetUInt( $7B);
 CL.AddConstantN('MIDICCOmniModeOff','LongWord').SetUInt( $7C);
 CL.AddConstantN('MIDICCOmniModeOn','LongWord').SetUInt( $7D);
 CL.AddConstantN('MIDICCMonoModeOn','LongWord').SetUInt( $7E);
 CL.AddConstantN('MIDICCPolyModeOn','LongWord').SetUInt( $7F);
  CL.AddTypeS('TMIDIChannel', 'Integer');
  CL.AddTypeS('TMIDIDataByte', 'Integer');
  CL.AddTypeS('TMIDIDataWord', 'Integer');
  CL.AddTypeS('TMIDIVelocity', 'TMIDIDataByte');
  CL.AddTypeS('TMIDIKey', 'TMIDIDataByte');
  CL.AddTypeS('TMIDINote', 'TMIDIKey');
 CL.AddConstantN('MIDIDataMask','LongWord').SetUInt( $7F);
 CL.AddConstantN('MIDIDataWordMask','LongWord').SetUInt( $3FFF);
 CL.AddConstantN('MIDIChannelMsgMask','LongWord').SetUInt( $F0);
 CL.AddConstantN('MIDIInvalidStatus','LongInt').SetInt( TMIDIStatusByte ( 0 ));
 CL.AddConstantN('BitsPerMIDIDataByte','LongInt').SetInt( 7);
 CL.AddConstantN('BitsPerMIDIDataWord','LongInt').SetInt( BitsPerMIDIDataByte * 2);
  //CL.AddTypeS('TMIDINotes', 'set of integer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclMIDIError');
  SIRegister_IJclMIDIOut(CL);
  SIRegister_TJclMIDIOut(CL);
 CL.AddDelphiFunction('Function MIDIOut( DeviceID : Cardinal) : IJclMIDIOut');
 CL.AddDelphiFunction('Procedure GetMidiOutputs( const List : TStrings)');
 //CL.AddDelphiFunction('Function MIDISingleNoteTuningData( Key : TMIDINote; Frequency : Single) : TSingleNoteTuningData');
 CL.AddDelphiFunction('Function MIDINoteToStr( Note : TMIDINote) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclMIDIOutRunningStatusEnabled_W(Self: TJclMIDIOut; const T: Boolean);
begin Self.RunningStatusEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMIDIOutRunningStatusEnabled_R(Self: TJclMIDIOut; var T: Boolean);
begin T := Self.RunningStatusEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TJclMIDIOutName_R(Self: TJclMIDIOut; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclMIDIOutActiveNotes_R(Self: TJclMIDIOut; var T: TMIDINotes; const t1: TMIDIChannel);
begin T := Self.ActiveNotes[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TJclMIDIOutSwitchActiveNotesOff3_P(Self: TJclMIDIOut);
Begin Self.SwitchActiveNotesOff; END;

(*----------------------------------------------------------------------------*)
Procedure TJclMIDIOutSwitchActiveNotesOff2_P(Self: TJclMIDIOut;  Channel : TMIDIChannel);
Begin Self.SwitchActiveNotesOff(Channel); END;

(*----------------------------------------------------------------------------*)
Procedure IJclMIDIOutSwitchActiveNotesOff1_P(Self: IJclMIDIOut);
Begin Self.SwitchActiveNotesOff; END;

(*----------------------------------------------------------------------------*)
Procedure IJclMIDIOutSwitchActiveNotesOff_P(Self: IJclMIDIOut;  Channel : TMIDIChannel);
Begin Self.SwitchActiveNotesOff(Channel); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclMIDI_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MIDIOut, 'MIDIOut', cdRegister);
 S.RegisterDelphiFunction(@GetMidiOutputs, 'GetMidiOutputs', cdRegister);
 S.RegisterDelphiFunction(@MIDISingleNoteTuningData, 'MIDISingleNoteTuningData', cdRegister);
 S.RegisterDelphiFunction(@MIDINoteToStr, 'MIDINoteToStr', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMIDIOut(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMIDIOut) do begin
    RegisterMethod(@TJclMIDIOut.SendNoteOff, 'SendNoteOff');
    RegisterMethod(@TJclMIDIOut.SendNoteOn, 'SendNoteOn');
    RegisterMethod(@TJclMIDIOut.SendPolyphonicKeyPressure, 'SendPolyphonicKeyPressure');
    RegisterMethod(@TJclMIDIOut.SendControlChange, 'SendControlChange');
    RegisterMethod(@TJclMIDIOut.SendControlChangeHR, 'SendControlChangeHR');
    RegisterMethod(@TJclMIDIOut.SendSwitchChange, 'SendSwitchChange');
    RegisterMethod(@TJclMIDIOut.SendProgramChange, 'SendProgramChange');
    RegisterMethod(@TJclMIDIOut.SendChannelPressure, 'SendChannelPressure');
    RegisterMethod(@TJclMIDIOut.SendPitchWheelChange, 'SendPitchWheelChange');
    RegisterMethod(@TJclMIDIOut.SendPitchWheelPos, 'SendPitchWheelPos');
    RegisterMethod(@TJclMIDIOut.SelectProgram, 'SelectProgram');
    RegisterMethod(@TJclMIDIOut.SendModulationWheelChange, 'SendModulationWheelChange');
    RegisterMethod(@TJclMIDIOut.SendBreathControlChange, 'SendBreathControlChange');
    RegisterMethod(@TJclMIDIOut.SendFootControllerChange, 'SendFootControllerChange');
    RegisterMethod(@TJclMIDIOut.SendPortamentoTimeChange, 'SendPortamentoTimeChange');
    RegisterMethod(@TJclMIDIOut.SendDataEntry, 'SendDataEntry');
    RegisterMethod(@TJclMIDIOut.SendChannelVolumeChange, 'SendChannelVolumeChange');
    RegisterMethod(@TJclMIDIOut.SendBalanceChange, 'SendBalanceChange');
    RegisterMethod(@TJclMIDIOut.SendPanChange, 'SendPanChange');
    RegisterMethod(@TJclMIDIOut.SendExpressionChange, 'SendExpressionChange');
    RegisterMethod(@TJclMIDIOut.SendModulationWheelChangeHR, 'SendModulationWheelChangeHR');
    RegisterMethod(@TJclMIDIOut.SendBreathControlChangeHR, 'SendBreathControlChangeHR');
    RegisterMethod(@TJclMIDIOut.SendFootControllerChangeHR, 'SendFootControllerChangeHR');
    RegisterMethod(@TJclMIDIOut.SendPortamentoTimeChangeHR, 'SendPortamentoTimeChangeHR');
    RegisterMethod(@TJclMIDIOut.SendDataEntryHR, 'SendDataEntryHR');
    RegisterMethod(@TJclMIDIOut.SendChannelVolumeChangeHR, 'SendChannelVolumeChangeHR');
    RegisterMethod(@TJclMIDIOut.SendBalanceChangeHR, 'SendBalanceChangeHR');
    RegisterMethod(@TJclMIDIOut.SendPanChangeHR, 'SendPanChangeHR');
    RegisterMethod(@TJclMIDIOut.SendExpressionChangeHR, 'SendExpressionChangeHR');
    RegisterMethod(@TJclMIDIOut.SwitchSustain, 'SwitchSustain');
    RegisterMethod(@TJclMIDIOut.SwitchPortamento, 'SwitchPortamento');
    RegisterMethod(@TJclMIDIOut.SwitchSostenuto, 'SwitchSostenuto');
    RegisterMethod(@TJclMIDIOut.SwitchSoftPedal, 'SwitchSoftPedal');
    RegisterMethod(@TJclMIDIOut.SwitchLegato, 'SwitchLegato');
    RegisterMethod(@TJclMIDIOut.SwitchHold2, 'SwitchHold2');
    RegisterMethod(@TJclMIDIOut.SwitchAllSoundOff, 'SwitchAllSoundOff');
    RegisterMethod(@TJclMIDIOut.ResetAllControllers, 'ResetAllControllers');
    RegisterMethod(@TJclMIDIOut.SwitchLocalControl, 'SwitchLocalControl');
    RegisterMethod(@TJclMIDIOut.SwitchAllNotesOff, 'SwitchAllNotesOff');
    RegisterMethod(@TJclMIDIOut.SwitchOmniModeOff, 'SwitchOmniModeOff');
    RegisterMethod(@TJclMIDIOut.SwitchOmniModeOn, 'SwitchOmniModeOn');
    RegisterMethod(@TJclMIDIOut.SwitchMonoModeOn, 'SwitchMonoModeOn');
    RegisterMethod(@TJclMIDIOut.SwitchPolyModeOn, 'SwitchPolyModeOn');
    RegisterMethod(@TJclMIDIOut.SendSingleNoteTuningChange, 'SendSingleNoteTuningChange');
    RegisterMethod(@TJclMIDIOut.NoteIsOn, 'NoteIsOn');
    RegisterMethod(@TJclMIDIOutSwitchActiveNotesOff2_P, 'SwitchActiveNotesOff2');
    RegisterMethod(@TJclMIDIOutSwitchActiveNotesOff3_P, 'SwitchActiveNotesOff3');
    RegisterPropertyHelper(@TJclMIDIOutActiveNotes_R,nil,'ActiveNotes');
    RegisterPropertyHelper(@TJclMIDIOutName_R,nil,'Name');
    RegisterPropertyHelper(@TJclMIDIOutRunningStatusEnabled_R,@TJclMIDIOutRunningStatusEnabled_W,'RunningStatusEnabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclMIDI(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclMIDIError) do
  RIRegister_TJclMIDIOut(CL);
end;

 
 
{ TPSImport_JclMIDI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMIDI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclMIDI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMIDI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclMIDI_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
