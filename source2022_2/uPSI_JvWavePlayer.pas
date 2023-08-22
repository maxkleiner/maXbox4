unit uPSI_JvWavePlayer;
{
   heart beat wavelet
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
  TPSImport_JvWavePlayer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvWavePlayer(CL: TPSPascalCompiler);
procedure SIRegister_JvWavePlayer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvWavePlayer(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvWavePlayer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  MMSystem
  ,JvTypes
  ,JvComponentBase
  ,JvWavePlayer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvWavePlayer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvWavePlayer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvWavePlayer') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvWavePlayer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Play : Boolean');
    RegisterMethod('Procedure Stop');
    RegisterProperty('WavePointer', 'Pointer', iptrw);
    RegisterProperty('Asynchronous', 'Boolean', iptrw);
    RegisterProperty('Loop', 'Boolean', iptrw);
    RegisterProperty('SourceType', 'TJvWaveLocation', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('BeforePlaying', 'TNotifyEvent', iptrw);
    RegisterProperty('AfterPlaying', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvWavePlayer(CL: TPSPascalCompiler);
begin
  SIRegister_TJvWavePlayer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerAfterPlaying_W(Self: TJvWavePlayer; const T: TNotifyEvent);
begin Self.AfterPlaying := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerAfterPlaying_R(Self: TJvWavePlayer; var T: TNotifyEvent);
begin T := Self.AfterPlaying; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerBeforePlaying_W(Self: TJvWavePlayer; const T: TNotifyEvent);
begin Self.BeforePlaying := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerBeforePlaying_R(Self: TJvWavePlayer; var T: TNotifyEvent);
begin T := Self.BeforePlaying; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerFileName_W(Self: TJvWavePlayer; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerFileName_R(Self: TJvWavePlayer; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerSourceType_W(Self: TJvWavePlayer; const T: TJvWaveLocation);
begin Self.SourceType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerSourceType_R(Self: TJvWavePlayer; var T: TJvWaveLocation);
begin T := Self.SourceType; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerLoop_W(Self: TJvWavePlayer; const T: Boolean);
begin Self.Loop := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerLoop_R(Self: TJvWavePlayer; var T: Boolean);
begin T := Self.Loop; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerAsynchronous_W(Self: TJvWavePlayer; const T: Boolean);
begin Self.Asynchronous := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerAsynchronous_R(Self: TJvWavePlayer; var T: Boolean);
begin T := Self.Asynchronous; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerWavePointer_W(Self: TJvWavePlayer; const T: Pointer);
begin Self.WavePointer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWavePlayerWavePointer_R(Self: TJvWavePlayer; var T: Pointer);
begin T := Self.WavePointer; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvWavePlayer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvWavePlayer) do begin
    RegisterConstructor(@TJvWavePlayer.Create, 'Create');
    RegisterMethod(@TJvWavePlayer.Destroy, 'Free');
    RegisterMethod(@TJvWavePlayer.Play, 'Play');
    RegisterMethod(@TJvWavePlayer.Stop, 'Stop');
    RegisterPropertyHelper(@TJvWavePlayerWavePointer_R,@TJvWavePlayerWavePointer_W,'WavePointer');
    RegisterPropertyHelper(@TJvWavePlayerAsynchronous_R,@TJvWavePlayerAsynchronous_W,'Asynchronous');
    RegisterPropertyHelper(@TJvWavePlayerLoop_R,@TJvWavePlayerLoop_W,'Loop');
    RegisterPropertyHelper(@TJvWavePlayerSourceType_R,@TJvWavePlayerSourceType_W,'SourceType');
    RegisterPropertyHelper(@TJvWavePlayerFileName_R,@TJvWavePlayerFileName_W,'FileName');
    RegisterPropertyHelper(@TJvWavePlayerBeforePlaying_R,@TJvWavePlayerBeforePlaying_W,'BeforePlaying');
    RegisterPropertyHelper(@TJvWavePlayerAfterPlaying_R,@TJvWavePlayerAfterPlaying_W,'AfterPlaying');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvWavePlayer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvWavePlayer(CL);
end;

 
 
{ TPSImport_JvWavePlayer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvWavePlayer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvWavePlayer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvWavePlayer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvWavePlayer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
