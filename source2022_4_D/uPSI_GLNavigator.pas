unit uPSI_GLNavigator;
{
   gl navi
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
  TPSImport_GLNavigator = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGLUserInterface(CL: TPSPascalCompiler);
procedure SIRegister_TGLNavigator(CL: TPSPascalCompiler);
procedure SIRegister_GLNavigator(CL: TPSPascalCompiler);

{ run-time registration functions }
//procedure RIRegister_GLNavigator_Routines(S: TPSExec);
procedure RIRegister_TGLUserInterface(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGLNavigator(CL: TPSRuntimeClassImporter);
procedure RIRegister_GLNavigator(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   VectorGeometry
  ,GLScene
  ,GLMisc
  ,GLCrossPlatform
  ,GLNavigator
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GLNavigator]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLUserInterface(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TGLUserInterface') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TGLUserInterface') do begin
    RegisterMethod('Procedure MouseUpdate');
    RegisterMethod('Function MouseLook : Boolean');
    RegisterMethod('Procedure MouseLookActiveToggle');
    RegisterMethod('Procedure MouseLookActivate');
    RegisterMethod('Procedure MouseLookDeactivate');
    RegisterMethod('Function IsMouseLookOn : Boolean');
    RegisterMethod('Procedure TurnHorizontal( Angle : Double)');
    RegisterMethod('Procedure TurnVertical( Angle : Double)');
    RegisterProperty('MouseLookActive', 'Boolean', iptrw);
    RegisterProperty('InvertMouse', 'boolean', iptrw);
    RegisterProperty('MouseSpeed', 'single', iptrw);
    RegisterProperty('GLNavigator', 'TGLNavigator', iptrw);
    RegisterProperty('GLVertNavigator', 'TGLNavigator', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLNavigator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TGLNavigator') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TGLNavigator') do begin
    RegisterMethod('Procedure SetObject( NewObject : TGLBaseSceneObject)');
    RegisterMethod('Procedure SetUseVirtualUp( UseIt : boolean)');
    RegisterMethod('Procedure SetVirtualUp( Up : TGLCoordinates)');
    RegisterMethod('Function CalcRight : TVector');
    RegisterMethod('Procedure TurnHorizontal( Angle : single)');
    RegisterMethod('Procedure TurnVertical( Angle : single)');
    RegisterMethod('Procedure MoveForward( Distance : single)');
    RegisterMethod('Procedure StrafeHorizontal( Distance : single)');
    RegisterMethod('Procedure StrafeVertical( Distance : single)');
    RegisterMethod('Procedure Straighten');
    RegisterMethod('Procedure FlyForward( Distance : single)');
    RegisterMethod('Procedure LoadState( Stream : TStream)');
    RegisterMethod('Procedure SaveState( Stream : TStream)');
    RegisterProperty('CurrentVAngle', 'single', iptr);
    RegisterProperty('CurrentHAngle', 'single', iptr);
    RegisterProperty('MoveUpWhenMovingForward', 'boolean', iptrw);
    RegisterProperty('InvertHorizontalSteeringWhenUpsideDown', 'boolean', iptrw);
    RegisterProperty('VirtualUp', 'TGLCoordinates', iptrw);
    RegisterProperty('MovingObject', 'TGLBaseSceneObject', iptrw);
    RegisterProperty('UseVirtualUp', 'boolean', iptrw);
    RegisterProperty('AutoUpdateObject', 'boolean', iptrw);
    RegisterProperty('MaxAngle', 'single', iptrw);
    RegisterProperty('MinAngle', 'single', iptrw);
    RegisterProperty('AngleLock', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GLNavigator(CL: TPSPascalCompiler);
begin
  SIRegister_TGLNavigator(CL);
  SIRegister_TGLUserInterface(CL);
 //.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TGLUserInterfaceGLVertNavigator_W(Self: TGLUserInterface; const T: TGLNavigator);
begin Self.GLVertNavigator := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLUserInterfaceGLVertNavigator_R(Self: TGLUserInterface; var T: TGLNavigator);
begin T := Self.GLVertNavigator; end;

(*----------------------------------------------------------------------------*)
procedure TGLUserInterfaceGLNavigator_W(Self: TGLUserInterface; const T: TGLNavigator);
begin Self.GLNavigator := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLUserInterfaceGLNavigator_R(Self: TGLUserInterface; var T: TGLNavigator);
begin T := Self.GLNavigator; end;

(*----------------------------------------------------------------------------*)
procedure TGLUserInterfaceMouseSpeed_W(Self: TGLUserInterface; const T: single);
begin Self.MouseSpeed := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLUserInterfaceMouseSpeed_R(Self: TGLUserInterface; var T: single);
begin T := Self.MouseSpeed; end;

(*----------------------------------------------------------------------------*)
procedure TGLUserInterfaceInvertMouse_W(Self: TGLUserInterface; const T: boolean);
begin Self.InvertMouse := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLUserInterfaceInvertMouse_R(Self: TGLUserInterface; var T: boolean);
begin T := Self.InvertMouse; end;

(*----------------------------------------------------------------------------*)
procedure TGLUserInterfaceMouseLookActive_W(Self: TGLUserInterface; const T: Boolean);
begin Self.MouseLookActive := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLUserInterfaceMouseLookActive_R(Self: TGLUserInterface; var T: Boolean);
begin T := Self.MouseLookActive; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorAngleLock_W(Self: TGLNavigator; const T: boolean);
begin Self.AngleLock := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorAngleLock_R(Self: TGLNavigator; var T: boolean);
begin T := Self.AngleLock; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorMinAngle_W(Self: TGLNavigator; const T: single);
begin Self.MinAngle := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorMinAngle_R(Self: TGLNavigator; var T: single);
begin T := Self.MinAngle; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorMaxAngle_W(Self: TGLNavigator; const T: single);
begin Self.MaxAngle := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorMaxAngle_R(Self: TGLNavigator; var T: single);
begin T := Self.MaxAngle; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorAutoUpdateObject_W(Self: TGLNavigator; const T: boolean);
begin Self.AutoUpdateObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorAutoUpdateObject_R(Self: TGLNavigator; var T: boolean);
begin T := Self.AutoUpdateObject; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorUseVirtualUp_W(Self: TGLNavigator; const T: boolean);
begin Self.UseVirtualUp := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorUseVirtualUp_R(Self: TGLNavigator; var T: boolean);
begin T := Self.UseVirtualUp; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorMovingObject_W(Self: TGLNavigator; const T: TGLBaseSceneObject);
begin Self.MovingObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorMovingObject_R(Self: TGLNavigator; var T: TGLBaseSceneObject);
begin T := Self.MovingObject; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorVirtualUp_W(Self: TGLNavigator; const T: TGLCoordinates);
begin Self.VirtualUp := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorVirtualUp_R(Self: TGLNavigator; var T: TGLCoordinates);
begin T := Self.VirtualUp; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorInvertHorizontalSteeringWhenUpsideDown_W(Self: TGLNavigator; const T: boolean);
begin Self.InvertHorizontalSteeringWhenUpsideDown := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorInvertHorizontalSteeringWhenUpsideDown_R(Self: TGLNavigator; var T: boolean);
begin T := Self.InvertHorizontalSteeringWhenUpsideDown; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorMoveUpWhenMovingForward_W(Self: TGLNavigator; const T: boolean);
begin Self.MoveUpWhenMovingForward := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorMoveUpWhenMovingForward_R(Self: TGLNavigator; var T: boolean);
begin T := Self.MoveUpWhenMovingForward; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorCurrentHAngle_R(Self: TGLNavigator; var T: single);
begin T := Self.CurrentHAngle; end;

(*----------------------------------------------------------------------------*)
procedure TGLNavigatorCurrentVAngle_R(Self: TGLNavigator; var T: single);
begin T := Self.CurrentVAngle; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GLNavigator_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLUserInterface(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLUserInterface) do
  begin
    RegisterMethod(@TGLUserInterface.MouseUpdate, 'MouseUpdate');
    RegisterMethod(@TGLUserInterface.MouseLook, 'MouseLook');
    RegisterMethod(@TGLUserInterface.MouseLookActiveToggle, 'MouseLookActiveToggle');
    RegisterMethod(@TGLUserInterface.MouseLookActivate, 'MouseLookActivate');
    RegisterMethod(@TGLUserInterface.MouseLookDeactivate, 'MouseLookDeactivate');
    RegisterMethod(@TGLUserInterface.IsMouseLookOn, 'IsMouseLookOn');
    RegisterMethod(@TGLUserInterface.TurnHorizontal, 'TurnHorizontal');
    RegisterMethod(@TGLUserInterface.TurnVertical, 'TurnVertical');
    RegisterPropertyHelper(@TGLUserInterfaceMouseLookActive_R,@TGLUserInterfaceMouseLookActive_W,'MouseLookActive');
    RegisterPropertyHelper(@TGLUserInterfaceInvertMouse_R,@TGLUserInterfaceInvertMouse_W,'InvertMouse');
    RegisterPropertyHelper(@TGLUserInterfaceMouseSpeed_R,@TGLUserInterfaceMouseSpeed_W,'MouseSpeed');
    RegisterPropertyHelper(@TGLUserInterfaceGLNavigator_R,@TGLUserInterfaceGLNavigator_W,'GLNavigator');
    RegisterPropertyHelper(@TGLUserInterfaceGLVertNavigator_R,@TGLUserInterfaceGLVertNavigator_W,'GLVertNavigator');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLNavigator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLNavigator) do
  begin
    RegisterMethod(@TGLNavigator.SetObject, 'SetObject');
    RegisterMethod(@TGLNavigator.SetUseVirtualUp, 'SetUseVirtualUp');
    RegisterMethod(@TGLNavigator.SetVirtualUp, 'SetVirtualUp');
    RegisterMethod(@TGLNavigator.CalcRight, 'CalcRight');
    RegisterMethod(@TGLNavigator.TurnHorizontal, 'TurnHorizontal');
    RegisterMethod(@TGLNavigator.TurnVertical, 'TurnVertical');
    RegisterMethod(@TGLNavigator.MoveForward, 'MoveForward');
    RegisterMethod(@TGLNavigator.StrafeHorizontal, 'StrafeHorizontal');
    RegisterMethod(@TGLNavigator.StrafeVertical, 'StrafeVertical');
    RegisterMethod(@TGLNavigator.Straighten, 'Straighten');
    RegisterMethod(@TGLNavigator.FlyForward, 'FlyForward');
    RegisterMethod(@TGLNavigator.LoadState, 'LoadState');
    RegisterMethod(@TGLNavigator.SaveState, 'SaveState');
    RegisterPropertyHelper(@TGLNavigatorCurrentVAngle_R,nil,'CurrentVAngle');
    RegisterPropertyHelper(@TGLNavigatorCurrentHAngle_R,nil,'CurrentHAngle');
    RegisterPropertyHelper(@TGLNavigatorMoveUpWhenMovingForward_R,@TGLNavigatorMoveUpWhenMovingForward_W,'MoveUpWhenMovingForward');
    RegisterPropertyHelper(@TGLNavigatorInvertHorizontalSteeringWhenUpsideDown_R,@TGLNavigatorInvertHorizontalSteeringWhenUpsideDown_W,'InvertHorizontalSteeringWhenUpsideDown');
    RegisterPropertyHelper(@TGLNavigatorVirtualUp_R,@TGLNavigatorVirtualUp_W,'VirtualUp');
    RegisterPropertyHelper(@TGLNavigatorMovingObject_R,@TGLNavigatorMovingObject_W,'MovingObject');
    RegisterPropertyHelper(@TGLNavigatorUseVirtualUp_R,@TGLNavigatorUseVirtualUp_W,'UseVirtualUp');
    RegisterPropertyHelper(@TGLNavigatorAutoUpdateObject_R,@TGLNavigatorAutoUpdateObject_W,'AutoUpdateObject');
    RegisterPropertyHelper(@TGLNavigatorMaxAngle_R,@TGLNavigatorMaxAngle_W,'MaxAngle');
    RegisterPropertyHelper(@TGLNavigatorMinAngle_R,@TGLNavigatorMinAngle_W,'MinAngle');
    RegisterPropertyHelper(@TGLNavigatorAngleLock_R,@TGLNavigatorAngleLock_W,'AngleLock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GLNavigator(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TGLNavigator(CL);
  RIRegister_TGLUserInterface(CL);
end;

 
 
{ TPSImport_GLNavigator }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLNavigator.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GLNavigator(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLNavigator.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GLNavigator(ri);
  //RIRegister_GLNavigator_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
