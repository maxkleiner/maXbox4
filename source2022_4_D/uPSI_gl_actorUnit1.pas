unit uPSI_gl_actorUnit1;
{
  robot box
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
  TPSImport_gl_actorUnit1 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TglActorForm1(CL: TPSPascalCompiler);
procedure SIRegister_gl_actorUnit1(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TglActorForm1(CL: TPSRuntimeClassImporter);
procedure RIRegister_gl_actorUnit1(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,ExtCtrls
  ,GLCadencer
  ,GLScene
  ,GLObjects
  ,GLMisc
  ,ComCtrls
  ,Controls
  ,GLWin32Viewer
  ,StdCtrls
  ,GLVectorFileObjects
  ,GLShadowPlane
  ,VectorGeometry
  ,GLTexture
  ,GLParticleFX
  ,JPeg
  ,Dialogs
  ,GLFileMD3
  ,Q3MD3
  ,gl_actorUnit1
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_gl_actorUnit1]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TglActorForm1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TglActorForm1') do
  with CL.AddClassN(CL.FindClass('TForm'),'TglActorForm1') do begin
    RegisterProperty('GLScene1', 'TGLScene', iptrw);
    RegisterProperty('GLCamera1', 'TGLCamera', iptrw);
    RegisterProperty('GLLightSource1', 'TGLLightSource', iptrw);
    RegisterProperty('DummyCube1', 'TGLDummyCube', iptrw);
    RegisterProperty('GLCadencer1', 'TGLCadencer', iptrw);
    RegisterProperty('Timer1', 'TTimer', iptrw);
    RegisterProperty('ModelCube', 'TGLDummyCube', iptrw);
    RegisterProperty('MatLib', 'TGLMaterialLibrary', iptrw);
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('GLSceneViewer1', 'TGLSceneViewer', iptrw);
    RegisterProperty('ComboBox1', 'TComboBox', iptrw);
    RegisterProperty('ComboBox2', 'TComboBox', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('GLShadowPlane1', 'TGLShadowPlane', iptrw);
    RegisterProperty('Legs', 'TGLActor', iptrw);
    RegisterProperty('Torso', 'TGLActor', iptrw);
    RegisterProperty('Head', 'TGLActor', iptrw);
    RegisterProperty('Weapon', 'TGLActor', iptrw);
    RegisterProperty('GunSmoke', 'TGLDummyCube', iptrw);
    RegisterProperty('GLParticleFXRenderer1', 'TGLParticleFXRenderer', iptrw);
    RegisterProperty('GLPointLightPFXManager1', 'TGLPointLightPFXManager', iptrw);
    RegisterProperty('TrackBar1', 'TTrackBar', iptrw);
    RegisterProperty('TrackBar2', 'TTrackBar', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('TrackBar3', 'TTrackBar', iptrw);
    RegisterProperty('TrackBar4', 'TTrackBar', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('ComboSkin', 'TComboBox', iptrw);
    RegisterProperty('Label5', 'TLabel', iptrw);
    RegisterMethod('Procedure GLSceneViewer1MouseDown( Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer)');
    RegisterMethod('Procedure GLSceneViewer1MouseMove( Sender : TObject; Shift : TShiftState; X, Y : Integer)');
    RegisterMethod('Procedure Timer1Timer( Sender : TObject)');
    RegisterMethod('Procedure GLCadencer1Progress( Sender : TObject; const deltaTime, newTime : Double)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure ComboBox1Change( Sender : TObject)');
    RegisterMethod('Procedure ComboBox2Change( Sender : TObject)');
    RegisterMethod('Procedure FormDestroy( Sender : TObject)');
    RegisterMethod('Procedure ComboSkinChange( Sender : TObject)');
    RegisterProperty('LegsTags', 'TMD3TagList', iptrw);
    RegisterProperty('TorsoTags', 'TMD3TagList', iptrw);
    RegisterProperty('WeaponTags', 'TMD3TagList', iptrw);
    RegisterMethod('Procedure BuildModel');
    RegisterMethod('Function InterpolateMatrix( m1, m2 : TMatrix; delta : single) : TMatrix');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_gl_actorUnit1(CL: TPSPascalCompiler);
begin
  SIRegister_TglActorForm1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TglActorForm1WeaponTags_W(Self: TglActorForm1; const T: TMD3TagList);
Begin Self.WeaponTags := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1WeaponTags_R(Self: TglActorForm1; var T: TMD3TagList);
Begin T := Self.WeaponTags; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1TorsoTags_W(Self: TglActorForm1; const T: TMD3TagList);
Begin Self.TorsoTags := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1TorsoTags_R(Self: TglActorForm1; var T: TMD3TagList);
Begin T := Self.TorsoTags; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1LegsTags_W(Self: TglActorForm1; const T: TMD3TagList);
Begin Self.LegsTags := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1LegsTags_R(Self: TglActorForm1; var T: TMD3TagList);
Begin T := Self.LegsTags; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Label5_W(Self: TglActorForm1; const T: TLabel);
Begin Self.Label5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Label5_R(Self: TglActorForm1; var T: TLabel);
Begin T := Self.Label5; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1ComboSkin_W(Self: TglActorForm1; const T: TComboBox);
Begin Self.ComboSkin := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1ComboSkin_R(Self: TglActorForm1; var T: TComboBox);
Begin T := Self.ComboSkin; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Label4_W(Self: TglActorForm1; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Label4_R(Self: TglActorForm1; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1TrackBar4_W(Self: TglActorForm1; const T: TTrackBar);
Begin Self.TrackBar4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1TrackBar4_R(Self: TglActorForm1; var T: TTrackBar);
Begin T := Self.TrackBar4; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1TrackBar3_W(Self: TglActorForm1; const T: TTrackBar);
Begin Self.TrackBar3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1TrackBar3_R(Self: TglActorForm1; var T: TTrackBar);
Begin T := Self.TrackBar3; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Label3_W(Self: TglActorForm1; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Label3_R(Self: TglActorForm1; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1TrackBar2_W(Self: TglActorForm1; const T: TTrackBar);
Begin Self.TrackBar2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1TrackBar2_R(Self: TglActorForm1; var T: TTrackBar);
Begin T := Self.TrackBar2; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1TrackBar1_W(Self: TglActorForm1; const T: TTrackBar);
Begin Self.TrackBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1TrackBar1_R(Self: TglActorForm1; var T: TTrackBar);
Begin T := Self.TrackBar1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLPointLightPFXManager1_W(Self: TglActorForm1; const T: TGLPointLightPFXManager);
Begin Self.GLPointLightPFXManager1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLPointLightPFXManager1_R(Self: TglActorForm1; var T: TGLPointLightPFXManager);
Begin T := Self.GLPointLightPFXManager1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLParticleFXRenderer1_W(Self: TglActorForm1; const T: TGLParticleFXRenderer);
Begin Self.GLParticleFXRenderer1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLParticleFXRenderer1_R(Self: TglActorForm1; var T: TGLParticleFXRenderer);
Begin T := Self.GLParticleFXRenderer1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GunSmoke_W(Self: TglActorForm1; const T: TGLDummyCube);
Begin Self.GunSmoke := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GunSmoke_R(Self: TglActorForm1; var T: TGLDummyCube);
Begin T := Self.GunSmoke; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Weapon_W(Self: TglActorForm1; const T: TGLActor);
Begin Self.Weapon := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Weapon_R(Self: TglActorForm1; var T: TGLActor);
Begin T := Self.Weapon; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Head_W(Self: TglActorForm1; const T: TGLActor);
Begin Self.Head := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Head_R(Self: TglActorForm1; var T: TGLActor);
Begin T := Self.Head; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Torso_W(Self: TglActorForm1; const T: TGLActor);
Begin Self.Torso := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Torso_R(Self: TglActorForm1; var T: TGLActor);
Begin T := Self.Torso; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Legs_W(Self: TglActorForm1; const T: TGLActor);
Begin Self.Legs := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Legs_R(Self: TglActorForm1; var T: TGLActor);
Begin T := Self.Legs; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLShadowPlane1_W(Self: TglActorForm1; const T: TGLShadowPlane);
Begin Self.GLShadowPlane1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLShadowPlane1_R(Self: TglActorForm1; var T: TGLShadowPlane);
Begin T := Self.GLShadowPlane1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Label2_W(Self: TglActorForm1; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Label2_R(Self: TglActorForm1; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Label1_W(Self: TglActorForm1; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Label1_R(Self: TglActorForm1; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1ComboBox2_W(Self: TglActorForm1; const T: TComboBox);
Begin Self.ComboBox2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1ComboBox2_R(Self: TglActorForm1; var T: TComboBox);
Begin T := Self.ComboBox2; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1ComboBox1_W(Self: TglActorForm1; const T: TComboBox);
Begin Self.ComboBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1ComboBox1_R(Self: TglActorForm1; var T: TComboBox);
Begin T := Self.ComboBox1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLSceneViewer1_W(Self: TglActorForm1; const T: TGLSceneViewer);
Begin Self.GLSceneViewer1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLSceneViewer1_R(Self: TglActorForm1; var T: TGLSceneViewer);
Begin T := Self.GLSceneViewer1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Panel1_W(Self: TglActorForm1; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Panel1_R(Self: TglActorForm1; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1MatLib_W(Self: TglActorForm1; const T: TGLMaterialLibrary);
Begin Self.MatLib := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1MatLib_R(Self: TglActorForm1; var T: TGLMaterialLibrary);
Begin T := Self.MatLib; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1ModelCube_W(Self: TglActorForm1; const T: TGLDummyCube);
Begin Self.ModelCube := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1ModelCube_R(Self: TglActorForm1; var T: TGLDummyCube);
Begin T := Self.ModelCube; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Timer1_W(Self: TglActorForm1; const T: TTimer);
Begin Self.Timer1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1Timer1_R(Self: TglActorForm1; var T: TTimer);
Begin T := Self.Timer1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLCadencer1_W(Self: TglActorForm1; const T: TGLCadencer);
Begin Self.GLCadencer1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLCadencer1_R(Self: TglActorForm1; var T: TGLCadencer);
Begin T := Self.GLCadencer1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1DummyCube1_W(Self: TglActorForm1; const T: TGLDummyCube);
Begin Self.DummyCube1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1DummyCube1_R(Self: TglActorForm1; var T: TGLDummyCube);
Begin T := Self.DummyCube1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLLightSource1_W(Self: TglActorForm1; const T: TGLLightSource);
Begin Self.GLLightSource1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLLightSource1_R(Self: TglActorForm1; var T: TGLLightSource);
Begin T := Self.GLLightSource1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLCamera1_W(Self: TglActorForm1; const T: TGLCamera);
Begin Self.GLCamera1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLCamera1_R(Self: TglActorForm1; var T: TGLCamera);
Begin T := Self.GLCamera1; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLScene1_W(Self: TglActorForm1; const T: TGLScene);
Begin Self.GLScene1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TglActorForm1GLScene1_R(Self: TglActorForm1; var T: TGLScene);
Begin T := Self.GLScene1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TglActorForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TglActorForm1) do begin
    RegisterPropertyHelper(@TglActorForm1GLScene1_R,@TglActorForm1GLScene1_W,'GLScene1');
    RegisterPropertyHelper(@TglActorForm1GLCamera1_R,@TglActorForm1GLCamera1_W,'GLCamera1');
    RegisterPropertyHelper(@TglActorForm1GLLightSource1_R,@TglActorForm1GLLightSource1_W,'GLLightSource1');
    RegisterPropertyHelper(@TglActorForm1DummyCube1_R,@TglActorForm1DummyCube1_W,'DummyCube1');
    RegisterPropertyHelper(@TglActorForm1GLCadencer1_R,@TglActorForm1GLCadencer1_W,'GLCadencer1');
    RegisterPropertyHelper(@TglActorForm1Timer1_R,@TglActorForm1Timer1_W,'Timer1');
    RegisterPropertyHelper(@TglActorForm1ModelCube_R,@TglActorForm1ModelCube_W,'ModelCube');
    RegisterPropertyHelper(@TglActorForm1MatLib_R,@TglActorForm1MatLib_W,'MatLib');
    RegisterPropertyHelper(@TglActorForm1Panel1_R,@TglActorForm1Panel1_W,'Panel1');
    RegisterPropertyHelper(@TglActorForm1GLSceneViewer1_R,@TglActorForm1GLSceneViewer1_W,'GLSceneViewer1');
    RegisterPropertyHelper(@TglActorForm1ComboBox1_R,@TglActorForm1ComboBox1_W,'ComboBox1');
    RegisterPropertyHelper(@TglActorForm1ComboBox2_R,@TglActorForm1ComboBox2_W,'ComboBox2');
    RegisterPropertyHelper(@TglActorForm1Label1_R,@TglActorForm1Label1_W,'Label1');
    RegisterPropertyHelper(@TglActorForm1Label2_R,@TglActorForm1Label2_W,'Label2');
    RegisterPropertyHelper(@TglActorForm1GLShadowPlane1_R,@TglActorForm1GLShadowPlane1_W,'GLShadowPlane1');
    RegisterPropertyHelper(@TglActorForm1Legs_R,@TglActorForm1Legs_W,'Legs');
    RegisterPropertyHelper(@TglActorForm1Torso_R,@TglActorForm1Torso_W,'Torso');
    RegisterPropertyHelper(@TglActorForm1Head_R,@TglActorForm1Head_W,'Head');
    RegisterPropertyHelper(@TglActorForm1Weapon_R,@TglActorForm1Weapon_W,'Weapon');
    RegisterPropertyHelper(@TglActorForm1GunSmoke_R,@TglActorForm1GunSmoke_W,'GunSmoke');
    RegisterPropertyHelper(@TglActorForm1GLParticleFXRenderer1_R,@TglActorForm1GLParticleFXRenderer1_W,'GLParticleFXRenderer1');
    RegisterPropertyHelper(@TglActorForm1GLPointLightPFXManager1_R,@TglActorForm1GLPointLightPFXManager1_W,'GLPointLightPFXManager1');
    RegisterPropertyHelper(@TglActorForm1TrackBar1_R,@TglActorForm1TrackBar1_W,'TrackBar1');
    RegisterPropertyHelper(@TglActorForm1TrackBar2_R,@TglActorForm1TrackBar2_W,'TrackBar2');
    RegisterPropertyHelper(@TglActorForm1Label3_R,@TglActorForm1Label3_W,'Label3');
    RegisterPropertyHelper(@TglActorForm1TrackBar3_R,@TglActorForm1TrackBar3_W,'TrackBar3');
    RegisterPropertyHelper(@TglActorForm1TrackBar4_R,@TglActorForm1TrackBar4_W,'TrackBar4');
    RegisterPropertyHelper(@TglActorForm1Label4_R,@TglActorForm1Label4_W,'Label4');
    RegisterPropertyHelper(@TglActorForm1ComboSkin_R,@TglActorForm1ComboSkin_W,'ComboSkin');
    RegisterPropertyHelper(@TglActorForm1Label5_R,@TglActorForm1Label5_W,'Label5');
    RegisterMethod(@TglActorForm1.GLSceneViewer1MouseDown, 'GLSceneViewer1MouseDown');
    RegisterMethod(@TglActorForm1.GLSceneViewer1MouseMove, 'GLSceneViewer1MouseMove');
    RegisterMethod(@TglActorForm1.Timer1Timer, 'Timer1Timer');
    RegisterMethod(@TglActorForm1.GLCadencer1Progress, 'GLCadencer1Progress');
    RegisterMethod(@TglActorForm1.FormCreate, 'FormCreate');
    RegisterMethod(@TglActorForm1.ComboBox1Change, 'ComboBox1Change');
    RegisterMethod(@TglActorForm1.ComboBox2Change, 'ComboBox2Change');
    RegisterMethod(@TglActorForm1.FormDestroy, 'FormDestroy');
    RegisterMethod(@TglActorForm1.ComboSkinChange, 'ComboSkinChange');
    RegisterPropertyHelper(@TglActorForm1LegsTags_R,@TglActorForm1LegsTags_W,'LegsTags');
    RegisterPropertyHelper(@TglActorForm1TorsoTags_R,@TglActorForm1TorsoTags_W,'TorsoTags');
    RegisterPropertyHelper(@TglActorForm1WeaponTags_R,@TglActorForm1WeaponTags_W,'WeaponTags');
    RegisterMethod(@TglActorForm1.BuildModel, 'BuildModel');
    RegisterMethod(@TglActorForm1.InterpolateMatrix, 'InterpolateMatrix');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_gl_actorUnit1(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TglActorForm1(CL);
end;

 
 
{ TPSImport_gl_actorUnit1 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_gl_actorUnit1.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_gl_actorUnit1(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_gl_actorUnit1.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_gl_actorUnit1(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
