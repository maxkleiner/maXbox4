unit uPSI_GLParticles;
{
   glpart
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
  TPSImport_GLParticles = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGLParticles(CL: TPSPascalCompiler);
procedure SIRegister_GLParticles(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TGLParticles(CL: TPSRuntimeClassImporter);
procedure RIRegister_GLParticles(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   GLScene
  ,VectorGeometry
  ,OpenGL1x
  ,GLTexture
  ,GLMisc
  ,GLParticles
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GLParticles]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLParticles(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGLImmaterialSceneObject', 'TGLParticles') do
  with CL.AddClassN(CL.FindClass('TGLImmaterialSceneObject'),'TGLParticles') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure BuildList( var rci : TRenderContextInfo)');
    RegisterMethod('Procedure DoRender( var rci : TRenderContextInfo; renderSelf, renderChildren : Boolean)');
    RegisterMethod('Procedure DoProgress( const progressTime : TProgressTimes)');
    RegisterMethod('Function CreateParticle : TGLBaseSceneObject');
    RegisterMethod('Procedure KillParticle( aParticle : TGLBaseSceneObject)');
    RegisterMethod('Procedure KillParticles');
    RegisterProperty('CubeSize', 'TGLFloat', iptrw);
    RegisterProperty('EdgeColor', 'TGLColor', iptrw);
    RegisterProperty('VisibleAtRunTime', 'Boolean', iptrw);
    RegisterProperty('ParticlePoolSize', 'Integer', iptrw);
    RegisterProperty('OnCreateParticle', 'TGLParticleEvent', iptrw);
    RegisterProperty('OnActivateParticle', 'TGLParticleEvent', iptrw);
    RegisterProperty('OnKillParticle', 'TGLParticleEvent', iptrw);
    RegisterProperty('OnDestroyParticle', 'TGLParticleEvent', iptrw);
    RegisterProperty('OnBeforeRenderParticles', 'TDirectRenderEvent', iptrw);
    RegisterProperty('OnAfterRenderParticles', 'TDirectRenderEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GLParticles(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TGLParticleEvent', 'Procedure ( Sender : TObject; particle : TGLBaseSceneObject)');
  SIRegister_TGLParticles(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnAfterRenderParticles_W(Self: TGLParticles; const T: TDirectRenderEvent);
begin Self.OnAfterRenderParticles := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnAfterRenderParticles_R(Self: TGLParticles; var T: TDirectRenderEvent);
begin T := Self.OnAfterRenderParticles; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnBeforeRenderParticles_W(Self: TGLParticles; const T: TDirectRenderEvent);
begin Self.OnBeforeRenderParticles := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnBeforeRenderParticles_R(Self: TGLParticles; var T: TDirectRenderEvent);
begin T := Self.OnBeforeRenderParticles; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnDestroyParticle_W(Self: TGLParticles; const T: TGLParticleEvent);
begin Self.OnDestroyParticle := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnDestroyParticle_R(Self: TGLParticles; var T: TGLParticleEvent);
begin T := Self.OnDestroyParticle; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnKillParticle_W(Self: TGLParticles; const T: TGLParticleEvent);
begin Self.OnKillParticle := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnKillParticle_R(Self: TGLParticles; var T: TGLParticleEvent);
begin T := Self.OnKillParticle; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnActivateParticle_W(Self: TGLParticles; const T: TGLParticleEvent);
begin Self.OnActivateParticle := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnActivateParticle_R(Self: TGLParticles; var T: TGLParticleEvent);
begin T := Self.OnActivateParticle; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnCreateParticle_W(Self: TGLParticles; const T: TGLParticleEvent);
begin Self.OnCreateParticle := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesOnCreateParticle_R(Self: TGLParticles; var T: TGLParticleEvent);
begin T := Self.OnCreateParticle; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesParticlePoolSize_W(Self: TGLParticles; const T: Integer);
begin Self.ParticlePoolSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesParticlePoolSize_R(Self: TGLParticles; var T: Integer);
begin T := Self.ParticlePoolSize; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesVisibleAtRunTime_W(Self: TGLParticles; const T: Boolean);
begin Self.VisibleAtRunTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesVisibleAtRunTime_R(Self: TGLParticles; var T: Boolean);
begin T := Self.VisibleAtRunTime; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesEdgeColor_W(Self: TGLParticles; const T: TGLColor);
begin Self.EdgeColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesEdgeColor_R(Self: TGLParticles; var T: TGLColor);
begin T := Self.EdgeColor; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesCubeSize_W(Self: TGLParticles; const T: TGLFloat);
begin Self.CubeSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLParticlesCubeSize_R(Self: TGLParticles; var T: TGLFloat);
begin T := Self.CubeSize; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLParticles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLParticles) do begin
    RegisterConstructor(@TGLParticles.Create, 'Create');
         RegisterMethod(@TGLParticles.Destroy, 'Free');
    RegisterMethod(@TGLParticles.CreateParticle, 'CreateParticle');
    RegisterMethod(@TGLParticles.KillParticle, 'KillParticle');
    RegisterMethod(@TGLParticles.KillParticles, 'KillParticles');
     RegisterMethod(@TGLParticles.Assign, 'Assign');
    RegisterMethod(@TGLParticles.BuildList, 'BuildList');
    RegisterMethod(@TGLParticles.DoRender, 'DoRender');
    RegisterMethod(@TGLParticles.DoProgress, 'DoProgress');
    RegisterPropertyHelper(@TGLParticlesCubeSize_R,@TGLParticlesCubeSize_W,'CubeSize');
    RegisterPropertyHelper(@TGLParticlesEdgeColor_R,@TGLParticlesEdgeColor_W,'EdgeColor');
    RegisterPropertyHelper(@TGLParticlesVisibleAtRunTime_R,@TGLParticlesVisibleAtRunTime_W,'VisibleAtRunTime');
    RegisterPropertyHelper(@TGLParticlesParticlePoolSize_R,@TGLParticlesParticlePoolSize_W,'ParticlePoolSize');
    RegisterPropertyHelper(@TGLParticlesOnCreateParticle_R,@TGLParticlesOnCreateParticle_W,'OnCreateParticle');
    RegisterPropertyHelper(@TGLParticlesOnActivateParticle_R,@TGLParticlesOnActivateParticle_W,'OnActivateParticle');
    RegisterPropertyHelper(@TGLParticlesOnKillParticle_R,@TGLParticlesOnKillParticle_W,'OnKillParticle');
    RegisterPropertyHelper(@TGLParticlesOnDestroyParticle_R,@TGLParticlesOnDestroyParticle_W,'OnDestroyParticle');
    RegisterPropertyHelper(@TGLParticlesOnBeforeRenderParticles_R,@TGLParticlesOnBeforeRenderParticles_W,'OnBeforeRenderParticles');
    RegisterPropertyHelper(@TGLParticlesOnAfterRenderParticles_R,@TGLParticlesOnAfterRenderParticles_W,'OnAfterRenderParticles');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GLParticles(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TGLParticles(CL);
end;

 
 
{ TPSImport_GLParticles }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLParticles.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GLParticles(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLParticles.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GLParticles(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
