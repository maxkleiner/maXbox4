unit uPSI_WavePlay;
{
   led floyd - pink zeppelin
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
  TPSImport_WavePlay = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TWavePlayer(CL: TPSPascalCompiler);
procedure SIRegister_WavePlay(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TWavePlayer(CL: TPSRuntimeClassImporter);
procedure RIRegister_WavePlay(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,WavePlay
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WavePlay]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TWavePlayer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TWavePlayer') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TWavePlayer') do begin
    RegisterProperty('ResType', 'PChar', iptrw);
    RegisterMethod('Constructor Create( aOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Play');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure LoadFromResourceName( Instance : THandle; const ResName : String)');
    RegisterMethod('Procedure LoadFromResourceID( Instance : THandle; const ResID : Integer)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromFile( const FileName : String)');
    RegisterMethod('Procedure SaveToFile( const FileName : String)');
    RegisterProperty('Empty', 'Boolean', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('StopOthers', 'Boolean', iptrw);
    RegisterProperty('WaitToStop', 'Boolean', iptrw);
    RegisterProperty('Loop', 'Boolean', iptrw);
    RegisterProperty('Sound', 'TWave', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_WavePlay(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DefaultResType','String').SetString( 'WAVE');
  CL.AddTypeS('TWave', 'TMemoryStream');
  SIRegister_TWavePlayer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TWavePlayerSound_W(Self: TWavePlayer; const T: TWave);
begin Self.Sound := T; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerSound_R(Self: TWavePlayer; var T: TWave);
begin T := Self.Sound; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerLoop_W(Self: TWavePlayer; const T: Boolean);
begin Self.Loop := T; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerLoop_R(Self: TWavePlayer; var T: Boolean);
begin T := Self.Loop; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerWaitToStop_W(Self: TWavePlayer; const T: Boolean);
begin Self.WaitToStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerWaitToStop_R(Self: TWavePlayer; var T: Boolean);
begin T := Self.WaitToStop; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerStopOthers_W(Self: TWavePlayer; const T: Boolean);
begin Self.StopOthers := T; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerStopOthers_R(Self: TWavePlayer; var T: Boolean);
begin T := Self.StopOthers; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerActive_W(Self: TWavePlayer; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerActive_R(Self: TWavePlayer; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerEmpty_R(Self: TWavePlayer; var T: Boolean);
begin T := Self.Empty; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerResType_W(Self: TWavePlayer; const T: PChar);
Begin Self.ResType := T; end;

(*----------------------------------------------------------------------------*)
procedure TWavePlayerResType_R(Self: TWavePlayer; var T: PChar);
Begin T := Self.ResType; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWavePlayer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWavePlayer) do begin
    RegisterPropertyHelper(@TWavePlayerResType_R,@TWavePlayerResType_W,'ResType');
    RegisterConstructor(@TWavePlayer.Create, 'Create');
    RegisterMethod(@TWavePlayer.Destroy, 'Free');
    RegisterMethod(@TWavePlayer.Clear, 'Clear');
    RegisterMethod(@TWavePlayer.Play, 'Play');
    RegisterMethod(@TWavePlayer.Stop, 'Stop');
    RegisterMethod(@TWavePlayer.LoadFromResourceName, 'LoadFromResourceName');
    RegisterMethod(@TWavePlayer.LoadFromResourceID, 'LoadFromResourceID');
    RegisterMethod(@TWavePlayer.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TWavePlayer.SaveToStream, 'SaveToStream');
    RegisterMethod(@TWavePlayer.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TWavePlayer.SaveToFile, 'SaveToFile');
    RegisterPropertyHelper(@TWavePlayerEmpty_R,nil,'Empty');
    RegisterPropertyHelper(@TWavePlayerActive_R,@TWavePlayerActive_W,'Active');
    RegisterPropertyHelper(@TWavePlayerStopOthers_R,@TWavePlayerStopOthers_W,'StopOthers');
    RegisterPropertyHelper(@TWavePlayerWaitToStop_R,@TWavePlayerWaitToStop_W,'WaitToStop');
    RegisterPropertyHelper(@TWavePlayerLoop_R,@TWavePlayerLoop_W,'Loop');
    RegisterPropertyHelper(@TWavePlayerSound_R,@TWavePlayerSound_W,'Sound');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WavePlay(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TWavePlayer(CL);
end;

 
 
{ TPSImport_WavePlay }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WavePlay.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WavePlay(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WavePlay.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WavePlay(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
