unit uPSI_IMouse;
{
  pan
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
  TPSImport_IMouse = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPanningWindow(CL: TPSPascalCompiler);
procedure SIRegister_IMouse(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IMouse_Routines(S: TPSExec);
procedure RIRegister_TPanningWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_IMouse(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,ExtCtrls
  ,Graphics
  ,Messages
  ,Forms
  ,Windows
  ,IMouse
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IMouse]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPanningWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPanningWindow', 'TPanningWindow') do
  with CL.AddClassN(CL.FindClass('TCustomPanningWindow'),'TPanningWindow') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('IsPanning', 'Boolean', iptr);
    RegisterProperty('PanControl', 'TControl', iptr);
    RegisterProperty('PanInterval', 'Integer', iptrw);
    RegisterProperty('PanOptions', 'TPanOptions', iptr);
    RegisterProperty('OnUpdate', 'TUpdateEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IMouse(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('crPanAll','LongInt').SetInt( TCursor ( - 50 ));
 CL.AddConstantN('crPanDown','LongInt').SetInt( TCursor ( - 51 ));
 CL.AddConstantN('crPanDownLeft','LongInt').SetInt( TCursor ( - 52 ));
 CL.AddConstantN('crPanDownRight','LongInt').SetInt( TCursor ( - 53 ));
 CL.AddConstantN('crPanLeft','LongInt').SetInt( TCursor ( - 54 ));
 CL.AddConstantN('crPanLeftRight','LongInt').SetInt( TCursor ( - 55 ));
 CL.AddConstantN('crPanRight','LongInt').SetInt( TCursor ( - 56 ));
 CL.AddConstantN('crPanUp','LongInt').SetInt( TCursor ( - 57 ));
 CL.AddConstantN('crPanUpDown','LongInt').SetInt( TCursor ( - 58 ));
 CL.AddConstantN('crPanUpLeft','LongInt').SetInt( TCursor ( - 59 ));
 CL.AddConstantN('crPanUpRight','LongInt').SetInt( TCursor ( - 60 ));
  CL.AddTypeS('TPanDirection', '( pdUp, pdDown, pdLeft, pdRight )');
  CL.AddTypeS('TPanDirections', 'set of TPanDirection');
  CL.AddTypeS('TPanOption', '( poVertical, poHorizontal )');
  CL.AddTypeS('TPanOptions', 'set of TPanOption');
  CL.AddTypeS('TUpdateEvent', 'Procedure ( Sender : TObject; var Delta : TPoint'
   +'; var CursorDirection : TPanDirections)');
  SIRegister_TPanningWindow(CL);
 CL.AddDelphiFunction('Function StartPan( WndHandle : THandle; AControl : TControl) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPanningWindowOnUpdate_W(Self: TPanningWindow; const T: TUpdateEvent);
begin Self.OnUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanningWindowOnUpdate_R(Self: TPanningWindow; var T: TUpdateEvent);
begin T := Self.OnUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TPanningWindowPanOptions_R(Self: TPanningWindow; var T: TPanOptions);
begin T := Self.PanOptions; end;

(*----------------------------------------------------------------------------*)
procedure TPanningWindowPanInterval_W(Self: TPanningWindow; const T: Integer);
begin Self.PanInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TPanningWindowPanInterval_R(Self: TPanningWindow; var T: Integer);
begin T := Self.PanInterval; end;

(*----------------------------------------------------------------------------*)
procedure TPanningWindowPanControl_R(Self: TPanningWindow; var T: TControl);
begin T := Self.PanControl; end;

(*----------------------------------------------------------------------------*)
procedure TPanningWindowIsPanning_R(Self: TPanningWindow; var T: Boolean);
begin T := Self.IsPanning; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IMouse_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StartPan, 'StartPan', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPanningWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPanningWindow) do
  begin
    RegisterConstructor(@TPanningWindow.Create, 'Create');
    RegisterPropertyHelper(@TPanningWindowIsPanning_R,nil,'IsPanning');
    RegisterPropertyHelper(@TPanningWindowPanControl_R,nil,'PanControl');
    RegisterPropertyHelper(@TPanningWindowPanInterval_R,@TPanningWindowPanInterval_W,'PanInterval');
    RegisterPropertyHelper(@TPanningWindowPanOptions_R,nil,'PanOptions');
    RegisterPropertyHelper(@TPanningWindowOnUpdate_R,@TPanningWindowOnUpdate_W,'OnUpdate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IMouse(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPanningWindow(CL);
end;

 
 
{ TPSImport_IMouse }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IMouse.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IMouse(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IMouse.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IMouse(ri);
  RIRegister_IMouse_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
