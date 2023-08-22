unit uPSI_JvEasterEgg;
{
   to easter 2014
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
  TPSImport_JvEasterEgg = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvEasterEgg(CL: TPSPascalCompiler);
procedure SIRegister_JvEasterEgg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvEasterEgg(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvEasterEgg(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Messages
  ,Controls
  ,Forms
  ,JvComponentBase
  ,JvEasterEgg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvEasterEgg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvEasterEgg(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvEasterEgg') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvEasterEgg') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Egg', 'string', iptrw);
    RegisterProperty('ControlKeys', 'TShiftState', iptrw);
    RegisterProperty('OnEggFound', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvEasterEgg(CL: TPSPascalCompiler);
begin
  SIRegister_TJvEasterEgg(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvEasterEggOnEggFound_W(Self: TJvEasterEgg; const T: TNotifyEvent);
begin Self.OnEggFound := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvEasterEggOnEggFound_R(Self: TJvEasterEgg; var T: TNotifyEvent);
begin T := Self.OnEggFound; end;

(*----------------------------------------------------------------------------*)
procedure TJvEasterEggControlKeys_W(Self: TJvEasterEgg; const T: TShiftState);
begin Self.ControlKeys := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvEasterEggControlKeys_R(Self: TJvEasterEgg; var T: TShiftState);
begin T := Self.ControlKeys; end;

(*----------------------------------------------------------------------------*)
procedure TJvEasterEggEgg_W(Self: TJvEasterEgg; const T: string);
begin Self.Egg := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvEasterEggEgg_R(Self: TJvEasterEgg; var T: string);
begin T := Self.Egg; end;

(*----------------------------------------------------------------------------*)
procedure TJvEasterEggActive_W(Self: TJvEasterEgg; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvEasterEggActive_R(Self: TJvEasterEgg; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvEasterEgg(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvEasterEgg) do begin
    RegisterConstructor(@TJvEasterEgg.Create, 'Create');
     RegisterMethod(@TJvEasterEgg.Destroy, 'Free');
      RegisterPropertyHelper(@TJvEasterEggActive_R,@TJvEasterEggActive_W,'Active');
    RegisterPropertyHelper(@TJvEasterEggEgg_R,@TJvEasterEggEgg_W,'Egg');
    RegisterPropertyHelper(@TJvEasterEggControlKeys_R,@TJvEasterEggControlKeys_W,'ControlKeys');
    RegisterPropertyHelper(@TJvEasterEggOnEggFound_R,@TJvEasterEggOnEggFound_W,'OnEggFound');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvEasterEgg(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvEasterEgg(CL);
end;

 
 
{ TPSImport_JvEasterEgg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvEasterEgg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvEasterEgg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvEasterEgg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvEasterEgg(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
