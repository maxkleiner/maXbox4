unit uPSI_panUnit1;
{
  form template
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
  TPSImport_panUnit1 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPanForm1(CL: TPSPascalCompiler);
procedure SIRegister_panUnit1(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPanForm1(CL: TPSRuntimeClassImporter);
procedure RIRegister_panUnit1(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,jpeg
  ,ComCtrls
  ,StdCtrls
  ,GLScene
  ,GLObjects
  ,ExtCtrls
  ,GLMisc
  ,ExtDlgs
  ,GLTexture
  ,KeyBoard
  ,GLCadencer
  ,GLWin32Viewer
  ,panUnit1
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_panUnit1]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPanForm1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TPanForm1') do
  with CL.AddClassN(CL.FindClass('TForm'),'TPanForm1') do
  begin
    RegisterProperty('GLSceneViewer1', 'TGLSceneViewer', iptrw);
    RegisterProperty('GLScene1', 'TGLScene', iptrw);
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('GLCamera1', 'TGLCamera', iptrw);
    RegisterProperty('BtnLoad', 'TButton', iptrw);
    RegisterProperty('TrackBar1', 'TTrackBar', iptrw);
    RegisterProperty('LabelYaw', 'TLabel', iptrw);
    RegisterProperty('LabelPitch', 'TLabel', iptrw);
    RegisterProperty('OpenPictureDialog1', 'TOpenPictureDialog', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Sphere1', 'TGLSphere', iptrw);
    RegisterProperty('GLMaterialLibrary1', 'TGLMaterialLibrary', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('GLCadencer1', 'TGLCadencer', iptrw);
    RegisterMethod('Procedure GLSceneViewer1MouseDown( Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer)');
    RegisterMethod('Procedure GLSceneViewer1MouseMove( Sender : TObject; Shift : TShiftState; X, Y : Integer)');
    RegisterMethod('Procedure BtnLoadClick( Sender : TObject)');
    RegisterMethod('Procedure TrackBar1Change( Sender : TObject)');
    RegisterMethod('Procedure FormMouseWheel( Sender : TObject; Shift : TShiftState; WheelDelta : Integer; MousePos : TPoint; var Handled : Boolean)');
    RegisterMethod('Procedure FormKeyDown( Sender : TObject; var Key : Word; Shift : TShiftState)');
    RegisterMethod('Procedure GLCadencer1Progress( Sender : TObject; const deltaTime, newTime : Double)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_panUnit1(CL: TPSPascalCompiler);
begin
  SIRegister_TPanForm1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPanForm1GLCadencer1_W(Self: TPanForm1; const T: TGLCadencer);
Begin Self.GLCadencer1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1GLCadencer1_R(Self: TPanForm1; var T: TGLCadencer);
Begin T := Self.GLCadencer1; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1Label2_W(Self: TPanForm1; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1Label2_R(Self: TPanForm1; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1GLMaterialLibrary1_W(Self: TPanForm1; const T: TGLMaterialLibrary);
Begin Self.GLMaterialLibrary1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1GLMaterialLibrary1_R(Self: TPanForm1; var T: TGLMaterialLibrary);
Begin T := Self.GLMaterialLibrary1; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1Sphere1_W(Self: TPanForm1; const T: TGLSphere);
Begin Self.Sphere1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1Sphere1_R(Self: TPanForm1; var T: TGLSphere);
Begin T := Self.Sphere1; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1Label1_W(Self: TPanForm1; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1Label1_R(Self: TPanForm1; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1OpenPictureDialog1_W(Self: TPanForm1; const T: TOpenPictureDialog);
Begin Self.OpenPictureDialog1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1OpenPictureDialog1_R(Self: TPanForm1; var T: TOpenPictureDialog);
Begin T := Self.OpenPictureDialog1; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1LabelPitch_W(Self: TPanForm1; const T: TLabel);
Begin Self.LabelPitch := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1LabelPitch_R(Self: TPanForm1; var T: TLabel);
Begin T := Self.LabelPitch; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1LabelYaw_W(Self: TPanForm1; const T: TLabel);
Begin Self.LabelYaw := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1LabelYaw_R(Self: TPanForm1; var T: TLabel);
Begin T := Self.LabelYaw; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1TrackBar1_W(Self: TPanForm1; const T: TTrackBar);
Begin Self.TrackBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1TrackBar1_R(Self: TPanForm1; var T: TTrackBar);
Begin T := Self.TrackBar1; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1BtnLoad_W(Self: TPanForm1; const T: TButton);
Begin Self.BtnLoad := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1BtnLoad_R(Self: TPanForm1; var T: TButton);
Begin T := Self.BtnLoad; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1GLCamera1_W(Self: TPanForm1; const T: TGLCamera);
Begin Self.GLCamera1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1GLCamera1_R(Self: TPanForm1; var T: TGLCamera);
Begin T := Self.GLCamera1; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1Panel1_W(Self: TPanForm1; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1Panel1_R(Self: TPanForm1; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1GLScene1_W(Self: TPanForm1; const T: TGLScene);
Begin Self.GLScene1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1GLScene1_R(Self: TPanForm1; var T: TGLScene);
Begin T := Self.GLScene1; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1GLSceneViewer1_W(Self: TPanForm1; const T: TGLSceneViewer);
Begin Self.GLSceneViewer1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanForm1GLSceneViewer1_R(Self: TPanForm1; var T: TGLSceneViewer);
Begin T := Self.GLSceneViewer1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPanForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPanForm1) do
  begin
    RegisterPropertyHelper(@TPanForm1GLSceneViewer1_R,@TPanForm1GLSceneViewer1_W,'GLSceneViewer1');
    RegisterPropertyHelper(@TPanForm1GLScene1_R,@TPanForm1GLScene1_W,'GLScene1');
    RegisterPropertyHelper(@TPanForm1Panel1_R,@TPanForm1Panel1_W,'Panel1');
    RegisterPropertyHelper(@TPanForm1GLCamera1_R,@TPanForm1GLCamera1_W,'GLCamera1');
    RegisterPropertyHelper(@TPanForm1BtnLoad_R,@TPanForm1BtnLoad_W,'BtnLoad');
    RegisterPropertyHelper(@TPanForm1TrackBar1_R,@TPanForm1TrackBar1_W,'TrackBar1');
    RegisterPropertyHelper(@TPanForm1LabelYaw_R,@TPanForm1LabelYaw_W,'LabelYaw');
    RegisterPropertyHelper(@TPanForm1LabelPitch_R,@TPanForm1LabelPitch_W,'LabelPitch');
    RegisterPropertyHelper(@TPanForm1OpenPictureDialog1_R,@TPanForm1OpenPictureDialog1_W,'OpenPictureDialog1');
    RegisterPropertyHelper(@TPanForm1Label1_R,@TPanForm1Label1_W,'Label1');
    RegisterPropertyHelper(@TPanForm1Sphere1_R,@TPanForm1Sphere1_W,'Sphere1');
    RegisterPropertyHelper(@TPanForm1GLMaterialLibrary1_R,@TPanForm1GLMaterialLibrary1_W,'GLMaterialLibrary1');
    RegisterPropertyHelper(@TPanForm1Label2_R,@TPanForm1Label2_W,'Label2');
    RegisterPropertyHelper(@TPanForm1GLCadencer1_R,@TPanForm1GLCadencer1_W,'GLCadencer1');
    RegisterMethod(@TPanForm1.GLSceneViewer1MouseDown, 'GLSceneViewer1MouseDown');
    RegisterMethod(@TPanForm1.GLSceneViewer1MouseMove, 'GLSceneViewer1MouseMove');
    RegisterMethod(@TPanForm1.BtnLoadClick, 'BtnLoadClick');
    RegisterMethod(@TPanForm1.TrackBar1Change, 'TrackBar1Change');
    RegisterMethod(@TPanForm1.FormMouseWheel, 'FormMouseWheel');
    RegisterMethod(@TPanForm1.FormKeyDown, 'FormKeyDown');
    RegisterMethod(@TPanForm1.GLCadencer1Progress, 'GLCadencer1Progress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_panUnit1(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPanForm1(CL);
end;

 
 
{ TPSImport_panUnit1 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_panUnit1.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_panUnit1(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_panUnit1.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_panUnit1(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
