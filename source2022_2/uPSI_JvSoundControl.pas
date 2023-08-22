unit uPSI_JvSoundControl;
{
   also midi
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
  TPSImport_JvSoundControl = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvSoundControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvSoundValue(CL: TPSPascalCompiler);
procedure SIRegister_JvSoundControl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvSoundControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvSoundValue(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvSoundControl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,MMSystem
  ,JvTypes
  ,JvComponentBase
  ,JvSoundControl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvSoundControl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSoundControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvSoundControl') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvSoundControl') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('LastError', 'Integer', iptr);
    RegisterProperty('Wave', 'TJvSoundValue', iptrw);
    RegisterProperty('Midi', 'TJvSoundValue', iptrw);
    RegisterProperty('Cd', 'TJvSoundValue', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSoundValue(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvSoundValue') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvSoundValue') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Volume', 'Byte', iptrw);
    RegisterProperty('Balance', 'TBalance', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvSoundControl(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TBalance', 'Integer');
  SIRegister_TJvSoundValue(CL);
  SIRegister_TJvSoundControl(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvSoundControlCd_W(Self: TJvSoundControl; const T: TJvSoundValue);
begin Self.Cd := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSoundControlCd_R(Self: TJvSoundControl; var T: TJvSoundValue);
begin T := Self.Cd; end;

(*----------------------------------------------------------------------------*)
procedure TJvSoundControlMidi_W(Self: TJvSoundControl; const T: TJvSoundValue);
begin Self.Midi := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSoundControlMidi_R(Self: TJvSoundControl; var T: TJvSoundValue);
begin T := Self.Midi; end;

(*----------------------------------------------------------------------------*)
procedure TJvSoundControlWave_W(Self: TJvSoundControl; const T: TJvSoundValue);
begin Self.Wave := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSoundControlWave_R(Self: TJvSoundControl; var T: TJvSoundValue);
begin T := Self.Wave; end;

(*----------------------------------------------------------------------------*)
procedure TJvSoundControlLastError_R(Self: TJvSoundControl; var T: Integer);
begin T := Self.LastError; end;

(*----------------------------------------------------------------------------*)
procedure TJvSoundValueBalance_W(Self: TJvSoundValue; const T: TBalance);
begin Self.Balance := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSoundValueBalance_R(Self: TJvSoundValue; var T: TBalance);
begin T := Self.Balance; end;

(*----------------------------------------------------------------------------*)
procedure TJvSoundValueVolume_W(Self: TJvSoundValue; const T: Byte);
begin Self.Volume := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSoundValueVolume_R(Self: TJvSoundValue; var T: Byte);
begin T := Self.Volume; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSoundControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSoundControl) do
  begin
    RegisterConstructor(@TJvSoundControl.Create, 'Create');
    RegisterPropertyHelper(@TJvSoundControlLastError_R,nil,'LastError');
    RegisterPropertyHelper(@TJvSoundControlWave_R,@TJvSoundControlWave_W,'Wave');
    RegisterPropertyHelper(@TJvSoundControlMidi_R,@TJvSoundControlMidi_W,'Midi');
    RegisterPropertyHelper(@TJvSoundControlCd_R,@TJvSoundControlCd_W,'Cd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSoundValue(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSoundValue) do
  begin
    RegisterConstructor(@TJvSoundValue.Create, 'Create');
    RegisterPropertyHelper(@TJvSoundValueVolume_R,@TJvSoundValueVolume_W,'Volume');
    RegisterPropertyHelper(@TJvSoundValueBalance_R,@TJvSoundValueBalance_W,'Balance');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvSoundControl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvSoundValue(CL);
  RIRegister_TJvSoundControl(CL);
end;

 
 
{ TPSImport_JvSoundControl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSoundControl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvSoundControl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSoundControl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvSoundControl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
