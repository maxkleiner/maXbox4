unit uPSI_ShadowWnd;
{


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
  TPSImport_ShadowWnd = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TShadowWindow(CL: TPSPascalCompiler);
procedure SIRegister_ShadowWnd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TShadowWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_ShadowWnd(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Controls
  ,Forms
  ,Graphics
  ,ShadowWnd
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ShadowWnd]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TShadowWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TShadowWindow') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TShadowWindow') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Constructor CreateShadow( AOwner : TComponent; ControlSide : TControlSide)');
    RegisterProperty('Control', 'TControl', iptrw);
    RegisterProperty('Side', 'TControlSide', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ShadowWnd(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TControlSide', '( csRight, csBottom )');
  SIRegister_TShadowWindow(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TShadowWindowSide_W(Self: TShadowWindow; const T: TControlSide);
begin Self.Side := T; end;

(*----------------------------------------------------------------------------*)
procedure TShadowWindowSide_R(Self: TShadowWindow; var T: TControlSide);
begin T := Self.Side; end;

(*----------------------------------------------------------------------------*)
procedure TShadowWindowControl_W(Self: TShadowWindow; const T: TControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TShadowWindowControl_R(Self: TShadowWindow; var T: TControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShadowWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShadowWindow) do
  begin
    RegisterConstructor(@TShadowWindow.Create, 'Create');
    RegisterVirtualConstructor(@TShadowWindow.CreateShadow, 'CreateShadow');
    RegisterPropertyHelper(@TShadowWindowControl_R,@TShadowWindowControl_W,'Control');
    RegisterPropertyHelper(@TShadowWindowSide_R,@TShadowWindowSide_W,'Side');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ShadowWnd(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TShadowWindow(CL);
end;

 
 
{ TPSImport_ShadowWnd }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ShadowWnd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ShadowWnd(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ShadowWnd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ShadowWnd(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
