unit uPSI_Joystick;
{
  also jjoystick
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
  TPSImport_Joystick = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJoystick(CL: TPSPascalCompiler);
procedure SIRegister_Joystick(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Joystick_Routines(S: TPSExec);
procedure RIRegister_TJoystick(CL: TPSRuntimeClassImporter);
procedure RIRegister_Joystick(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,Controls
  ,Messages
  ,Joystick
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Joystick]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJoystick(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJoystick') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJoystick') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('JoyButtons', 'TJoystickButtons', iptr);
    RegisterProperty('XPosition', 'Integer', iptr);
    RegisterProperty('YPosition', 'Integer', iptr);
    RegisterProperty('Capture', 'Boolean', iptrw);
    RegisterProperty('NoCaptureErrors', 'Boolean', iptrw);
    RegisterProperty('Interval', 'Cardinal', iptrw);
    RegisterProperty('JoystickID', 'TJoystickID', iptrw);
    RegisterProperty('Threshold', 'Cardinal', iptrw);
    RegisterProperty('OnJoystickButtonChange', 'TJoystickEvent', iptrw);
    RegisterProperty('OnJoystickMove', 'TJoystickEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Joystick(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJoystickButton', '( jbButton1, jbButton2, jbButton3, jbButton4)');
  CL.AddTypeS('TJoystickButtons', 'set of TJoystickButton');
  CL.AddTypeS('TJoystickID', '( jidNoJoystick, jidJoystick1, jidJoystick2 )');
  CL.AddTypeS('TJoystickDesignMode', '( jdmInactive, jdmActive )');
  CL.AddTypeS('TJoyPos', '( jpMin, jpCenter, jpMax )');
  CL.AddTypeS('TJoyAxis', '( jaX, jaY, jaZ, jaR, jaU, jaV )');
  CL.AddTypeS('TJoystickEvent', 'Procedure ( Sender : TObject; JoyID : TJoystic'
   +'kID; Buttons : TJoystickButtons; XDeflection, YDeflection : Integer)');
  SIRegister_TJoystick(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJoystickOnJoystickMove_W(Self: TJoystick; const T: TJoystickEvent);
begin Self.OnJoystickMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickOnJoystickMove_R(Self: TJoystick; var T: TJoystickEvent);
begin T := Self.OnJoystickMove; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickOnJoystickButtonChange_W(Self: TJoystick; const T: TJoystickEvent);
begin Self.OnJoystickButtonChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickOnJoystickButtonChange_R(Self: TJoystick; var T: TJoystickEvent);
begin T := Self.OnJoystickButtonChange; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickThreshold_W(Self: TJoystick; const T: Cardinal);
begin Self.Threshold := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickThreshold_R(Self: TJoystick; var T: Cardinal);
begin T := Self.Threshold; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickJoystickID_W(Self: TJoystick; const T: TJoystickID);
begin Self.JoystickID := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickJoystickID_R(Self: TJoystick; var T: TJoystickID);
begin T := Self.JoystickID; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickInterval_W(Self: TJoystick; const T: Cardinal);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickInterval_R(Self: TJoystick; var T: Cardinal);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickNoCaptureErrors_W(Self: TJoystick; const T: Boolean);
begin Self.NoCaptureErrors := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickNoCaptureErrors_R(Self: TJoystick; var T: Boolean);
begin T := Self.NoCaptureErrors; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickCapture_W(Self: TJoystick; const T: Boolean);
begin Self.Capture := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickCapture_R(Self: TJoystick; var T: Boolean);
begin T := Self.Capture; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickYPosition_R(Self: TJoystick; var T: Integer);
begin T := Self.YPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickXPosition_R(Self: TJoystick; var T: Integer);
begin T := Self.XPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickJoyButtons_R(Self: TJoystick; var T: TJoystickButtons);
begin T := Self.JoyButtons; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Joystick_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJoystick(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJoystick) do begin
    RegisterConstructor(@TJoystick.Create, 'Create');
    RegisterMethod(@TJoystick.Assign, 'Assign');
    RegisterMethod(@TJoystick.Destroy, 'Free');
      RegisterPropertyHelper(@TJoystickJoyButtons_R,nil,'JoyButtons');
    RegisterPropertyHelper(@TJoystickXPosition_R,nil,'XPosition');
    RegisterPropertyHelper(@TJoystickYPosition_R,nil,'YPosition');
    RegisterPropertyHelper(@TJoystickCapture_R,@TJoystickCapture_W,'Capture');
    RegisterPropertyHelper(@TJoystickNoCaptureErrors_R,@TJoystickNoCaptureErrors_W,'NoCaptureErrors');
    RegisterPropertyHelper(@TJoystickInterval_R,@TJoystickInterval_W,'Interval');
    RegisterPropertyHelper(@TJoystickJoystickID_R,@TJoystickJoystickID_W,'JoystickID');
    RegisterPropertyHelper(@TJoystickThreshold_R,@TJoystickThreshold_W,'Threshold');
    RegisterPropertyHelper(@TJoystickOnJoystickButtonChange_R,@TJoystickOnJoystickButtonChange_W,'OnJoystickButtonChange');
    RegisterPropertyHelper(@TJoystickOnJoystickMove_R,@TJoystickOnJoystickMove_W,'OnJoystickMove');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Joystick(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJoystick(CL);
end;

 
 
{ TPSImport_Joystick }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Joystick.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Joystick(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Joystick.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Joystick(ri);
  //RIRegister_Joystick_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
