unit uPSI_JvJoystick;
{
  xbox maxbox
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
  TPSImport_JvJoystick = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvJoystick(CL: TPSPascalCompiler);
procedure SIRegister_TJoystick(CL: TPSPascalCompiler);
procedure SIRegister_JvJoystick(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvJoystick(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJoystick(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvJoystick(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  //,Messages
  ,MMSystem
  //,Forms
  //,JvTypes
  //,JvComponentBase
  ,JvJoystick
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvJoystick]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvJoystick(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvJoystick') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvJoystick') do begin
    RegisterMethod('Procedure WndProc( var Msg : TMessage)');
    RegisterProperty('Joy1Threshold', 'MMRESULT', iptrw);
    RegisterProperty('Joy2Threshold', 'MMRESULT', iptrw);
    RegisterProperty('HasJoystick1', 'Boolean', iptrw);
    RegisterProperty('HasJoystick2', 'Boolean', iptrw);
    RegisterProperty('PollTime', 'Cardinal', iptrw);
    RegisterProperty('CaptureJoystick1', 'Boolean', iptrw);
    RegisterProperty('CaptureJoystick2', 'Boolean', iptrw);
    RegisterProperty('JoyStick1', 'TJoystick', iptr);
    RegisterProperty('JoyStick2', 'TJoystick', iptr);
    RegisterProperty('Joy1ButtonDown', 'TJoyButtonDown', iptrw);
    RegisterProperty('Joy2ButtonDown', 'TJoyButtonDown', iptrw);
    RegisterProperty('Joy1ButtonUp', 'TJoyButtonDown', iptrw);
    RegisterProperty('Joy2ButtonUp', 'TJoyButtonDown', iptrw);
    RegisterProperty('Joy1Move', 'TJoyMove', iptrw);
    RegisterProperty('Joy2Move', 'TJoyMove', iptrw);
    RegisterProperty('Joy1ZMove', 'TJoyZMove', iptrw);
    RegisterProperty('Joy2ZMove', 'TJoyZMove', iptrw);
    RegisterProperty('OnError', 'TJoyErrorMsg', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJoystick(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJoystick') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJoystick') do begin
    RegisterMethod('Constructor CreateJoy( AOwner : TComponent; Joy : Integer)');
    RegisterProperty('XPosition', 'Integer', iptrw);
    RegisterProperty('YPosition', 'Integer', iptrw);
    RegisterProperty('ZPosition', 'Integer', iptrw);
    RegisterProperty('Button1Pressed', 'Boolean', iptrw);
    RegisterProperty('Button2Pressed', 'Boolean', iptrw);
    RegisterProperty('Button3Pressed', 'Boolean', iptrw);
    RegisterProperty('Button4Pressed', 'Boolean', iptrw);
    RegisterProperty('Manufacturer', 'Word', iptrw);
    RegisterProperty('ProductIdentifier', 'Word', iptrw);
    RegisterProperty('ProductName', 'string', iptrw);
    RegisterProperty('XMin', 'Cardinal', iptrw);
    RegisterProperty('XMax', 'Cardinal', iptrw);
    RegisterProperty('YMin', 'Cardinal', iptrw);
    RegisterProperty('YMax', 'Cardinal', iptrw);
    RegisterProperty('ZMin', 'Cardinal', iptrw);
    RegisterProperty('ZMax', 'Cardinal', iptrw);
    RegisterProperty('NumButtons', 'Cardinal', iptrw);
    RegisterProperty('PeriodMin', 'Cardinal', iptrw);
    RegisterProperty('PeriodMax', 'Cardinal', iptrw);
    RegisterProperty('RudderMin', 'Cardinal', iptrw);
    RegisterProperty('RudderMax', 'Cardinal', iptrw);
    RegisterProperty('UMin', 'Cardinal', iptrw);
    RegisterProperty('UMax', 'Cardinal', iptrw);
    RegisterProperty('VMin', 'Cardinal', iptrw);
    RegisterProperty('VMax', 'Cardinal', iptrw);
    RegisterProperty('Capabilities', 'TJoyCaps', iptrw);
    RegisterProperty('MaxAxis', 'Cardinal', iptrw);
    RegisterProperty('NumAxis', 'Cardinal', iptrw);
    RegisterProperty('MaxButtons', 'Cardinal', iptrw);
    RegisterProperty('RegKey', 'string', iptrw);
    RegisterProperty('OemVxD', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvJoystick(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJoyCap', '( joHasZCoordinate, joHasRudder, joHasUCoordinate, jo'
   +'HasVCoordinate, joHasPointOfVue, joHasPointOfVDiscrete, joHasPointOfVContinuous )');
  CL.AddTypeS('TJoyCaps', 'set of TJoyCap');
  CL.AddTypeS('TJoyButtonDown', 'Procedure ( Sender : TObject; X, Y : Integer; '
   +'ButtonChanged : Integer; But1Pressed, But2Pressed, But3Pressed, But4Pressed: Boolean)');
  CL.AddTypeS('TJoyMove', 'Procedure ( Sender : TObject; X, Y : Integer; But1Pr'
   +'essed, But2Pressed, But3Pressed, But4Pressed : Boolean)');
  CL.AddTypeS('TJoyZMove', 'Procedure ( Sender : TObject; Z : Integer; But1Pres'
   +'sed, But2Pressed, But3Pressed, But4Pressed : Boolean)');
  CL.AddTypeS('TJoyErrorMsg', 'Procedure ( Sender : TObject; code : Integer; Msg: string)');
  SIRegister_TJoystick(CL);
  SIRegister_TJvJoystick(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvJoystickOnError_W(Self: TJvJoystick; const T: TJoyErrorMsg);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickOnError_R(Self: TJvJoystick; var T: TJoyErrorMsg);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy2ZMove_W(Self: TJvJoystick; const T: TJoyZMove);
begin Self.Joy2ZMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy2ZMove_R(Self: TJvJoystick; var T: TJoyZMove);
begin T := Self.Joy2ZMove; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy1ZMove_W(Self: TJvJoystick; const T: TJoyZMove);
begin Self.Joy1ZMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy1ZMove_R(Self: TJvJoystick; var T: TJoyZMove);
begin T := Self.Joy1ZMove; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy2Move_W(Self: TJvJoystick; const T: TJoyMove);
begin Self.Joy2Move := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy2Move_R(Self: TJvJoystick; var T: TJoyMove);
begin T := Self.Joy2Move; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy1Move_W(Self: TJvJoystick; const T: TJoyMove);
begin Self.Joy1Move := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy1Move_R(Self: TJvJoystick; var T: TJoyMove);
begin T := Self.Joy1Move; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy2ButtonUp_W(Self: TJvJoystick; const T: TJoyButtonDown);
begin Self.Joy2ButtonUp := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy2ButtonUp_R(Self: TJvJoystick; var T: TJoyButtonDown);
begin T := Self.Joy2ButtonUp; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy1ButtonUp_W(Self: TJvJoystick; const T: TJoyButtonDown);
begin Self.Joy1ButtonUp := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy1ButtonUp_R(Self: TJvJoystick; var T: TJoyButtonDown);
begin T := Self.Joy1ButtonUp; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy2ButtonDown_W(Self: TJvJoystick; const T: TJoyButtonDown);
begin Self.Joy2ButtonDown := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy2ButtonDown_R(Self: TJvJoystick; var T: TJoyButtonDown);
begin T := Self.Joy2ButtonDown; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy1ButtonDown_W(Self: TJvJoystick; const T: TJoyButtonDown);
begin Self.Joy1ButtonDown := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy1ButtonDown_R(Self: TJvJoystick; var T: TJoyButtonDown);
begin T := Self.Joy1ButtonDown; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoyStick2_R(Self: TJvJoystick; var T: TJoystick);
begin T := Self.JoyStick2; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoyStick1_R(Self: TJvJoystick; var T: TJoystick);
begin T := Self.JoyStick1; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickCaptureJoystick2_W(Self: TJvJoystick; const T: Boolean);
begin Self.CaptureJoystick2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickCaptureJoystick2_R(Self: TJvJoystick; var T: Boolean);
begin T := Self.CaptureJoystick2; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickCaptureJoystick1_W(Self: TJvJoystick; const T: Boolean);
begin Self.CaptureJoystick1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickCaptureJoystick1_R(Self: TJvJoystick; var T: Boolean);
begin T := Self.CaptureJoystick1; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickPollTime_W(Self: TJvJoystick; const T: Cardinal);
begin Self.PollTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickPollTime_R(Self: TJvJoystick; var T: Cardinal);
begin T := Self.PollTime; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickHasJoystick2_W(Self: TJvJoystick; const T: Boolean);
begin Self.HasJoystick2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickHasJoystick2_R(Self: TJvJoystick; var T: Boolean);
begin T := Self.HasJoystick2; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickHasJoystick1_W(Self: TJvJoystick; const T: Boolean);
begin Self.HasJoystick1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickHasJoystick1_R(Self: TJvJoystick; var T: Boolean);
begin T := Self.HasJoystick1; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy2Threshold_W(Self: TJvJoystick; const T: MMRESULT);
begin Self.Joy2Threshold := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy2Threshold_R(Self: TJvJoystick; var T: MMRESULT);
begin T := Self.Joy2Threshold; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy1Threshold_W(Self: TJvJoystick; const T: MMRESULT);
begin Self.Joy1Threshold := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvJoystickJoy1Threshold_R(Self: TJvJoystick; var T: MMRESULT);
begin T := Self.Joy1Threshold; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickOemVxD_W(Self: TJoystick; const T: string);
begin Self.OemVxD := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickOemVxD_R(Self: TJoystick; var T: string);
begin T := Self.OemVxD; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickRegKey_W(Self: TJoystick; const T: string);
begin Self.RegKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickRegKey_R(Self: TJoystick; var T: string);
begin T := Self.RegKey; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickMaxButtons_W(Self: TJoystick; const T: Cardinal);
begin Self.MaxButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickMaxButtons_R(Self: TJoystick; var T: Cardinal);
begin T := Self.MaxButtons; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickNumAxis_W(Self: TJoystick; const T: Cardinal);
begin Self.NumAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickNumAxis_R(Self: TJoystick; var T: Cardinal);
begin T := Self.NumAxis; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickMaxAxis_W(Self: TJoystick; const T: Cardinal);
begin Self.MaxAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickMaxAxis_R(Self: TJoystick; var T: Cardinal);
begin T := Self.MaxAxis; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickCapabilities_W(Self: TJoystick; const T: TJoyCaps);
begin Self.Capabilities := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickCapabilities_R(Self: TJoystick; var T: TJoyCaps);
begin T := Self.Capabilities; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickVMax_W(Self: TJoystick; const T: Cardinal);
begin Self.VMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickVMax_R(Self: TJoystick; var T: Cardinal);
begin T := Self.VMax; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickVMin_W(Self: TJoystick; const T: Cardinal);
begin Self.VMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickVMin_R(Self: TJoystick; var T: Cardinal);
begin T := Self.VMin; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickUMax_W(Self: TJoystick; const T: Cardinal);
begin Self.UMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickUMax_R(Self: TJoystick; var T: Cardinal);
begin T := Self.UMax; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickUMin_W(Self: TJoystick; const T: Cardinal);
begin Self.UMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickUMin_R(Self: TJoystick; var T: Cardinal);
begin T := Self.UMin; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickRudderMax_W(Self: TJoystick; const T: Cardinal);
begin Self.RudderMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickRudderMax_R(Self: TJoystick; var T: Cardinal);
begin T := Self.RudderMax; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickRudderMin_W(Self: TJoystick; const T: Cardinal);
begin Self.RudderMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickRudderMin_R(Self: TJoystick; var T: Cardinal);
begin T := Self.RudderMin; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickPeriodMax_W(Self: TJoystick; const T: Cardinal);
begin Self.PeriodMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickPeriodMax_R(Self: TJoystick; var T: Cardinal);
begin T := Self.PeriodMax; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickPeriodMin_W(Self: TJoystick; const T: Cardinal);
begin Self.PeriodMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickPeriodMin_R(Self: TJoystick; var T: Cardinal);
begin T := Self.PeriodMin; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickNumButtons_W(Self: TJoystick; const T: Cardinal);
begin Self.NumButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickNumButtons_R(Self: TJoystick; var T: Cardinal);
begin T := Self.NumButtons; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickZMax_W(Self: TJoystick; const T: Cardinal);
begin Self.ZMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickZMax_R(Self: TJoystick; var T: Cardinal);
begin T := Self.ZMax; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickZMin_W(Self: TJoystick; const T: Cardinal);
begin Self.ZMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickZMin_R(Self: TJoystick; var T: Cardinal);
begin T := Self.ZMin; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickYMax_W(Self: TJoystick; const T: Cardinal);
begin Self.YMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickYMax_R(Self: TJoystick; var T: Cardinal);
begin T := Self.YMax; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickYMin_W(Self: TJoystick; const T: Cardinal);
begin Self.YMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickYMin_R(Self: TJoystick; var T: Cardinal);
begin T := Self.YMin; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickXMax_W(Self: TJoystick; const T: Cardinal);
begin Self.XMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickXMax_R(Self: TJoystick; var T: Cardinal);
begin T := Self.XMax; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickXMin_W(Self: TJoystick; const T: Cardinal);
begin Self.XMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickXMin_R(Self: TJoystick; var T: Cardinal);
begin T := Self.XMin; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickProductName_W(Self: TJoystick; const T: string);
begin Self.ProductName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickProductName_R(Self: TJoystick; var T: string);
begin T := Self.ProductName; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickProductIdentifier_W(Self: TJoystick; const T: Word);
begin Self.ProductIdentifier := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickProductIdentifier_R(Self: TJoystick; var T: Word);
begin T := Self.ProductIdentifier; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickManufacturer_W(Self: TJoystick; const T: Word);
begin Self.Manufacturer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickManufacturer_R(Self: TJoystick; var T: Word);
begin T := Self.Manufacturer; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickButton4Pressed_W(Self: TJoystick; const T: Boolean);
begin Self.Button4Pressed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickButton4Pressed_R(Self: TJoystick; var T: Boolean);
begin T := Self.Button4Pressed; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickButton3Pressed_W(Self: TJoystick; const T: Boolean);
begin Self.Button3Pressed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickButton3Pressed_R(Self: TJoystick; var T: Boolean);
begin T := Self.Button3Pressed; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickButton2Pressed_W(Self: TJoystick; const T: Boolean);
begin Self.Button2Pressed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickButton2Pressed_R(Self: TJoystick; var T: Boolean);
begin T := Self.Button2Pressed; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickButton1Pressed_W(Self: TJoystick; const T: Boolean);
begin Self.Button1Pressed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickButton1Pressed_R(Self: TJoystick; var T: Boolean);
begin T := Self.Button1Pressed; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickZPosition_W(Self: TJoystick; const T: Integer);
begin Self.ZPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickZPosition_R(Self: TJoystick; var T: Integer);
begin T := Self.ZPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickYPosition_W(Self: TJoystick; const T: Integer);
begin Self.YPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickYPosition_R(Self: TJoystick; var T: Integer);
begin T := Self.YPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickXPosition_W(Self: TJoystick; const T: Integer);
begin Self.XPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TJoystickXPosition_R(Self: TJoystick; var T: Integer);
begin T := Self.XPosition; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvJoystick(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvJoystick) do
  begin
    RegisterMethod(@TJvJoystick.WndProc, 'WndProc');
    RegisterPropertyHelper(@TJvJoystickJoy1Threshold_R,@TJvJoystickJoy1Threshold_W,'Joy1Threshold');
    RegisterPropertyHelper(@TJvJoystickJoy2Threshold_R,@TJvJoystickJoy2Threshold_W,'Joy2Threshold');
    RegisterPropertyHelper(@TJvJoystickHasJoystick1_R,@TJvJoystickHasJoystick1_W,'HasJoystick1');
    RegisterPropertyHelper(@TJvJoystickHasJoystick2_R,@TJvJoystickHasJoystick2_W,'HasJoystick2');
    RegisterPropertyHelper(@TJvJoystickPollTime_R,@TJvJoystickPollTime_W,'PollTime');
    RegisterPropertyHelper(@TJvJoystickCaptureJoystick1_R,@TJvJoystickCaptureJoystick1_W,'CaptureJoystick1');
    RegisterPropertyHelper(@TJvJoystickCaptureJoystick2_R,@TJvJoystickCaptureJoystick2_W,'CaptureJoystick2');
    RegisterPropertyHelper(@TJvJoystickJoyStick1_R,nil,'JoyStick1');
    RegisterPropertyHelper(@TJvJoystickJoyStick2_R,nil,'JoyStick2');
    RegisterPropertyHelper(@TJvJoystickJoy1ButtonDown_R,@TJvJoystickJoy1ButtonDown_W,'Joy1ButtonDown');
    RegisterPropertyHelper(@TJvJoystickJoy2ButtonDown_R,@TJvJoystickJoy2ButtonDown_W,'Joy2ButtonDown');
    RegisterPropertyHelper(@TJvJoystickJoy1ButtonUp_R,@TJvJoystickJoy1ButtonUp_W,'Joy1ButtonUp');
    RegisterPropertyHelper(@TJvJoystickJoy2ButtonUp_R,@TJvJoystickJoy2ButtonUp_W,'Joy2ButtonUp');
    RegisterPropertyHelper(@TJvJoystickJoy1Move_R,@TJvJoystickJoy1Move_W,'Joy1Move');
    RegisterPropertyHelper(@TJvJoystickJoy2Move_R,@TJvJoystickJoy2Move_W,'Joy2Move');
    RegisterPropertyHelper(@TJvJoystickJoy1ZMove_R,@TJvJoystickJoy1ZMove_W,'Joy1ZMove');
    RegisterPropertyHelper(@TJvJoystickJoy2ZMove_R,@TJvJoystickJoy2ZMove_W,'Joy2ZMove');
    RegisterPropertyHelper(@TJvJoystickOnError_R,@TJvJoystickOnError_W,'OnError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJoystick(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJoystick) do
  begin
    RegisterConstructor(@TJoystick.CreateJoy, 'CreateJoy');
    RegisterPropertyHelper(@TJoystickXPosition_R,@TJoystickXPosition_W,'XPosition');
    RegisterPropertyHelper(@TJoystickYPosition_R,@TJoystickYPosition_W,'YPosition');
    RegisterPropertyHelper(@TJoystickZPosition_R,@TJoystickZPosition_W,'ZPosition');
    RegisterPropertyHelper(@TJoystickButton1Pressed_R,@TJoystickButton1Pressed_W,'Button1Pressed');
    RegisterPropertyHelper(@TJoystickButton2Pressed_R,@TJoystickButton2Pressed_W,'Button2Pressed');
    RegisterPropertyHelper(@TJoystickButton3Pressed_R,@TJoystickButton3Pressed_W,'Button3Pressed');
    RegisterPropertyHelper(@TJoystickButton4Pressed_R,@TJoystickButton4Pressed_W,'Button4Pressed');
    RegisterPropertyHelper(@TJoystickManufacturer_R,@TJoystickManufacturer_W,'Manufacturer');
    RegisterPropertyHelper(@TJoystickProductIdentifier_R,@TJoystickProductIdentifier_W,'ProductIdentifier');
    RegisterPropertyHelper(@TJoystickProductName_R,@TJoystickProductName_W,'ProductName');
    RegisterPropertyHelper(@TJoystickXMin_R,@TJoystickXMin_W,'XMin');
    RegisterPropertyHelper(@TJoystickXMax_R,@TJoystickXMax_W,'XMax');
    RegisterPropertyHelper(@TJoystickYMin_R,@TJoystickYMin_W,'YMin');
    RegisterPropertyHelper(@TJoystickYMax_R,@TJoystickYMax_W,'YMax');
    RegisterPropertyHelper(@TJoystickZMin_R,@TJoystickZMin_W,'ZMin');
    RegisterPropertyHelper(@TJoystickZMax_R,@TJoystickZMax_W,'ZMax');
    RegisterPropertyHelper(@TJoystickNumButtons_R,@TJoystickNumButtons_W,'NumButtons');
    RegisterPropertyHelper(@TJoystickPeriodMin_R,@TJoystickPeriodMin_W,'PeriodMin');
    RegisterPropertyHelper(@TJoystickPeriodMax_R,@TJoystickPeriodMax_W,'PeriodMax');
    RegisterPropertyHelper(@TJoystickRudderMin_R,@TJoystickRudderMin_W,'RudderMin');
    RegisterPropertyHelper(@TJoystickRudderMax_R,@TJoystickRudderMax_W,'RudderMax');
    RegisterPropertyHelper(@TJoystickUMin_R,@TJoystickUMin_W,'UMin');
    RegisterPropertyHelper(@TJoystickUMax_R,@TJoystickUMax_W,'UMax');
    RegisterPropertyHelper(@TJoystickVMin_R,@TJoystickVMin_W,'VMin');
    RegisterPropertyHelper(@TJoystickVMax_R,@TJoystickVMax_W,'VMax');
    RegisterPropertyHelper(@TJoystickCapabilities_R,@TJoystickCapabilities_W,'Capabilities');
    RegisterPropertyHelper(@TJoystickMaxAxis_R,@TJoystickMaxAxis_W,'MaxAxis');
    RegisterPropertyHelper(@TJoystickNumAxis_R,@TJoystickNumAxis_W,'NumAxis');
    RegisterPropertyHelper(@TJoystickMaxButtons_R,@TJoystickMaxButtons_W,'MaxButtons');
    RegisterPropertyHelper(@TJoystickRegKey_R,@TJoystickRegKey_W,'RegKey');
    RegisterPropertyHelper(@TJoystickOemVxD_R,@TJoystickOemVxD_W,'OemVxD');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvJoystick(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJoystick(CL);
  RIRegister_TJvJoystick(CL);
end;

 
 
{ TPSImport_JvJoystick }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvJoystick.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvJoystick(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvJoystick.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvJoystick(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
