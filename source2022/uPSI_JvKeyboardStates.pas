unit uPSI_JvKeyboardStates;
{
      midimax
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
  TPSImport_JvKeyboardStates = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TJvKeyboardStates(CL: TPSPascalCompiler);
procedure SIRegister_JvKeyboardStates(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvKeyboardStates(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvKeyboardStates(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ExtCtrls
  ,JvTypes
  ,JvComponent
  ,JvKeyboardStates
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvKeyboardStates]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvKeyboardStates(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvKeyboardStates') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvKeyboardStates') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Interval', 'Cardinal', iptrw);
    RegisterProperty('Animation', 'TJvAnimations', iptrw);
    RegisterProperty('NumLock', 'Boolean', iptrw);
    RegisterProperty('ScrollLock', 'Boolean', iptrw);
    RegisterProperty('CapsLock', 'Boolean', iptrw);
    RegisterProperty('SystemKeysEnabled', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvKeyboardStates(CL: TPSPascalCompiler);
begin
  SIRegister_TJvKeyboardStates(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesSystemKeysEnabled_W(Self: TJvKeyboardStates; const T: Boolean);
begin Self.SystemKeysEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesSystemKeysEnabled_R(Self: TJvKeyboardStates; var T: Boolean);
begin T := Self.SystemKeysEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesCapsLock_W(Self: TJvKeyboardStates; const T: Boolean);
begin Self.CapsLock := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesCapsLock_R(Self: TJvKeyboardStates; var T: Boolean);
begin T := Self.CapsLock; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesScrollLock_W(Self: TJvKeyboardStates; const T: Boolean);
begin Self.ScrollLock := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesScrollLock_R(Self: TJvKeyboardStates; var T: Boolean);
begin T := Self.ScrollLock; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesNumLock_W(Self: TJvKeyboardStates; const T: Boolean);
begin Self.NumLock := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesNumLock_R(Self: TJvKeyboardStates; var T: Boolean);
begin T := Self.NumLock; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesAnimation_W(Self: TJvKeyboardStates; const T: TJvAnimations);
begin Self.Animation := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesAnimation_R(Self: TJvKeyboardStates; var T: TJvAnimations);
begin T := Self.Animation; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesInterval_W(Self: TJvKeyboardStates; const T: Cardinal);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesInterval_R(Self: TJvKeyboardStates; var T: Cardinal);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesEnabled_W(Self: TJvKeyboardStates; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvKeyboardStatesEnabled_R(Self: TJvKeyboardStates; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvKeyboardStates(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvKeyboardStates) do begin
    RegisterConstructor(@TJvKeyboardStates.Create, 'Create');
    RegisterMethod(@TJvKeyboardStates.Destroy, 'Free');
    RegisterPropertyHelper(@TJvKeyboardStatesEnabled_R,@TJvKeyboardStatesEnabled_W,'Enabled');
    RegisterPropertyHelper(@TJvKeyboardStatesInterval_R,@TJvKeyboardStatesInterval_W,'Interval');
    RegisterPropertyHelper(@TJvKeyboardStatesAnimation_R,@TJvKeyboardStatesAnimation_W,'Animation');
    RegisterPropertyHelper(@TJvKeyboardStatesNumLock_R,@TJvKeyboardStatesNumLock_W,'NumLock');
    RegisterPropertyHelper(@TJvKeyboardStatesScrollLock_R,@TJvKeyboardStatesScrollLock_W,'ScrollLock');
    RegisterPropertyHelper(@TJvKeyboardStatesCapsLock_R,@TJvKeyboardStatesCapsLock_W,'CapsLock');
    RegisterPropertyHelper(@TJvKeyboardStatesSystemKeysEnabled_R,@TJvKeyboardStatesSystemKeysEnabled_W,'SystemKeysEnabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvKeyboardStates(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvKeyboardStates(CL);
end;

 
 
{ TPSImport_JvKeyboardStates }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvKeyboardStates.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvKeyboardStates(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvKeyboardStates.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvKeyboardStates(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
