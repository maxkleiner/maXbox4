unit uPSI_Hotspot;
{
  warken
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
  TPSImport_Hotspot = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THotspot(CL: TPSPascalCompiler);
procedure SIRegister_Hotspot(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Hotspot_Routines(S: TPSExec);
procedure RIRegister_THotspot(CL: TPSRuntimeClassImporter);
procedure RIRegister_Hotspot(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,WinTypes
  ,Messages
  ,Graphics
  ,Hotspot
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Hotspot]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THotspot(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'THotspot') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'THotspot') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterProperty('OnMouseEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMouseLeave', 'TNotifyEvent', iptrw);
    RegisterPublishedProperties;
     RegisterProperty('BORDERWIDTH', 'Integer', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Hotspot(CL: TPSPascalCompiler);
begin
  SIRegister_THotspot(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THotspotOnMouseLeave_W(Self: THotspot; const T: TNotifyEvent);
begin Self.OnMouseLeave := T; end;

(*----------------------------------------------------------------------------*)
procedure THotspotOnMouseLeave_R(Self: THotspot; var T: TNotifyEvent);
begin T := Self.OnMouseLeave; end;

(*----------------------------------------------------------------------------*)
procedure THotspotOnMouseEnter_W(Self: THotspot; const T: TNotifyEvent);
begin Self.OnMouseEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure THotspotOnMouseEnter_R(Self: THotspot; var T: TNotifyEvent);
begin T := Self.OnMouseEnter; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Hotspot_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THotspot(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THotspot) do begin
    RegisterConstructor(@THotspot.Create, 'Create');
    RegisterMethod(@THotspot.Destroy, 'Free');
     RegisterPropertyHelper(@THotspotOnMouseEnter_R,@THotspotOnMouseEnter_W,'OnMouseEnter');
    RegisterPropertyHelper(@THotspotOnMouseLeave_R,@THotspotOnMouseLeave_W,'OnMouseLeave');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Hotspot(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THotspot(CL);
end;

 
 
{ TPSImport_Hotspot }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Hotspot.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Hotspot(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Hotspot.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Hotspot(ri);
  RIRegister_Hotspot_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
