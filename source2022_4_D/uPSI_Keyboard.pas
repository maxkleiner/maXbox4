unit uPSI_Keyboard;
{
   keys to key
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
  TPSImport_Keyboard = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Keyboard(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Keyboard_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Keyboard
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Keyboard]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Keyboard(CL: TPSPascalCompiler);
begin
//VK_F23 = 134;
  //{$EXTERNALSYM VK_F24}
  //VK_F24 = 135;

  CL.AddTypeS('TVirtualKeyCode', 'Integer');
 CL.AddConstantN('VK_MOUSEWHEELUP','integer').SetInt(134);
 CL.AddConstantN('VK_MOUSEWHEELDOWN','integer').SetInt(135);
 CL.AddDelphiFunction('Function glIsKeyDown( c : Char) : Boolean;');
 CL.AddDelphiFunction('Function glIsKeyDown1( vk : TVirtualKeyCode) : Boolean;');
 CL.AddDelphiFunction('Function glKeyPressed( minVkCode : TVirtualKeyCode) : TVirtualKeyCode');
 CL.AddDelphiFunction('Function glVirtualKeyCodeToKeyName( vk : TVirtualKeyCode) : String');
 CL.AddDelphiFunction('Function glKeyNameToVirtualKeyCode( const keyName : String) : TVirtualKeyCode');
 CL.AddDelphiFunction('Function glCharToVirtualKeyCode( c : Char) : TVirtualKeyCode');
 CL.AddDelphiFunction('Procedure glKeyboardNotifyWheelMoved( wheelDelta : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function IsKeyDown1_P( vk : TVirtualKeyCode) : Boolean;
Begin Result := Keyboard.IsKeyDown(vk); END;

(*----------------------------------------------------------------------------*)
Function IsKeyDown_P( c : Char) : Boolean;
Begin Result := Keyboard.IsKeyDown(c); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Keyboard_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsKeyDown_P, 'glIsKeyDown', cdRegister);
 S.RegisterDelphiFunction(@IsKeyDown1_P, 'glIsKeyDown1', cdRegister);
 S.RegisterDelphiFunction(@KeyPressed, 'glKeyPressed', cdRegister);
 S.RegisterDelphiFunction(@VirtualKeyCodeToKeyName, 'glVirtualKeyCodeToKeyName', cdRegister);
 S.RegisterDelphiFunction(@KeyNameToVirtualKeyCode, 'glKeyNameToVirtualKeyCode', cdRegister);
 S.RegisterDelphiFunction(@CharToVirtualKeyCode, 'glCharToVirtualKeyCode', cdRegister);
 S.RegisterDelphiFunction(@KeyboardNotifyWheelMoved, 'glKeyboardNotifyWheelMoved', cdRegister);
end;

 
 
{ TPSImport_Keyboard }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Keyboard.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Keyboard(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Keyboard.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_Keyboard(ri);
  RIRegister_Keyboard_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
