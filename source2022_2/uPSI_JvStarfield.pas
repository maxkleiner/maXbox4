unit uPSI_JvStarfield;
{
  timetunnel
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
  TPSImport_JvStarfield = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvStarfield(CL: TPSPascalCompiler);
procedure SIRegister_JvStarfield(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvStarfield(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvStarfield(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Controls
  ,JvTypes
  ,JvImageDrawThread
  ,JVCLVer
  ,JvStarfield
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvStarfield]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvStarfield(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TJvStarfield') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TJvStarfield') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Resize');
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('Delay', 'Cardinal', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Stars', 'Word', iptrw);
    RegisterProperty('MaxSpeed', 'Byte', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvStarfield(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvStars', 'record X : Integer; Y : Integer; Color : TColor; Spe'
   +'ed : Integer; end');
  SIRegister_TJvStarfield(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvStarfieldMaxSpeed_W(Self: TJvStarfield; const T: Byte);
begin Self.MaxSpeed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStarfieldMaxSpeed_R(Self: TJvStarfield; var T: Byte);
begin T := Self.MaxSpeed; end;

(*----------------------------------------------------------------------------*)
procedure TJvStarfieldStars_W(Self: TJvStarfield; const T: Word);
begin Self.Stars := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStarfieldStars_R(Self: TJvStarfield; var T: Word);
begin T := Self.Stars; end;

(*----------------------------------------------------------------------------*)
procedure TJvStarfieldActive_W(Self: TJvStarfield; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStarfieldActive_R(Self: TJvStarfield; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TJvStarfieldDelay_W(Self: TJvStarfield; const T: Cardinal);
begin Self.Delay := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStarfieldDelay_R(Self: TJvStarfield; var T: Cardinal);
begin T := Self.Delay; end;

(*----------------------------------------------------------------------------*)
procedure TJvStarfieldAboutJVCL_W(Self: TJvStarfield; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStarfieldAboutJVCL_R(Self: TJvStarfield; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvStarfield(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvStarfield) do begin
    RegisterConstructor(@TJvStarfield.Create, 'Create');
   RegisterMethod(@TJvStarfield.Destroy, 'Free');
    RegisterMethod(@TJvStarfield.Resize, 'Resize');
    RegisterPropertyHelper(@TJvStarfieldAboutJVCL_R,@TJvStarfieldAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvStarfieldDelay_R,@TJvStarfieldDelay_W,'Delay');
    RegisterPropertyHelper(@TJvStarfieldActive_R,@TJvStarfieldActive_W,'Active');
    RegisterPropertyHelper(@TJvStarfieldStars_R,@TJvStarfieldStars_W,'Stars');
    RegisterPropertyHelper(@TJvStarfieldMaxSpeed_R,@TJvStarfieldMaxSpeed_W,'MaxSpeed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvStarfield(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvStarfield(CL);
end;

 
 
{ TPSImport_JvStarfield }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStarfield.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvStarfield(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStarfield.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvStarfield(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
