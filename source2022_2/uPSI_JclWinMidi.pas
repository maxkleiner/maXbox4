unit uPSI_JclWinMidi;
{
  midi with atari - 1985!
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
  TPSImport_JclWinMidi = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IJclWinMidiOut(CL: TPSPascalCompiler);
procedure SIRegister_JclWinMidi(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclWinMidi_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,MMSystem
  ,JclBase
  ,JclMIDI
  ,JclWinMidi
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclWinMidi]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclWinMidiOut(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IJclMidiOut', 'IJclWinMidiOut') do
  with CL.AddInterface(CL.FindInterface('IJclMidiOut'),IJclWinMidiOut, 'IJclWinMidiOut') do begin
    RegisterMethod('Function GetChannelVolume( Channel : TStereoChannel) : Word', cdRegister);
    RegisterMethod('Procedure SetChannelVolume( Channel : TStereoChannel; const Value : Word)', cdRegister);
    RegisterMethod('Function GetVolume : Word', cdRegister);
    RegisterMethod('Procedure SetVolume( const Value : Word)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclWinMidi(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStereoChannel', '( scLeft, scRight )');
  SIRegister_IJclWinMidiOut(CL);
 CL.AddDelphiFunction('Function WinMidiOut( DeviceID : Cardinal) : IJclWinMidiOut');
 CL.AddDelphiFunction('Procedure GetMidiOutputs( const List : TStrings)');
 CL.AddDelphiFunction('Procedure MidiOutCheck( Code : MMResult)');
 CL.AddDelphiFunction('Procedure MidiInCheck( Code : MMResult)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JclWinMidi_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MidiOut, 'WinMidiOut', cdRegister);
 S.RegisterDelphiFunction(@GetMidiOutputs, 'GetMidiOutputs', cdRegister);
 S.RegisterDelphiFunction(@MidiOutCheck, 'MidiOutCheck', cdRegister);
 S.RegisterDelphiFunction(@MidiInCheck, 'MidiInCheck', cdRegister);
end;

 
 
{ TPSImport_JclWinMidi }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclWinMidi.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclWinMidi(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclWinMidi.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclWinMidi_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
