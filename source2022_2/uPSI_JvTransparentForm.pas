unit uPSI_JvTransparentForm;
{
  some android tester
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
  TPSImport_JvTransparentForm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvTransparentForm(CL: TPSPascalCompiler);
procedure SIRegister_JvTransparentForm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvTransparentForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvTransparentForm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Controls
  ,Forms
  ,JvComponent
  ,JvTransparentForm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvTransparentForm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTransparentForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvTransparentForm') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvTransparentForm') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Mask', 'TBitmap', iptrw);
    RegisterProperty('AutoSize', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvTransparentForm(CL: TPSPascalCompiler);
begin
  SIRegister_TJvTransparentForm(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvTransparentFormAutoSize_W(Self: TJvTransparentForm; const T: Boolean);
begin Self.AutoSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTransparentFormAutoSize_R(Self: TJvTransparentForm; var T: Boolean);
begin T := Self.AutoSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvTransparentFormMask_W(Self: TJvTransparentForm; const T: TBitmap);
begin Self.Mask := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTransparentFormMask_R(Self: TJvTransparentForm; var T: TBitmap);
begin T := Self.Mask; end;

(*----------------------------------------------------------------------------*)
procedure TJvTransparentFormActive_W(Self: TJvTransparentForm; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTransparentFormActive_R(Self: TJvTransparentForm; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTransparentForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTransparentForm) do begin
    RegisterConstructor(@TJvTransparentForm.Create, 'Create');
    RegisterPropertyHelper(@TJvTransparentFormActive_R,@TJvTransparentFormActive_W,'Active');
    RegisterPropertyHelper(@TJvTransparentFormMask_R,@TJvTransparentFormMask_W,'Mask');
    RegisterPropertyHelper(@TJvTransparentFormAutoSize_R,@TJvTransparentFormAutoSize_W,'AutoSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvTransparentForm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvTransparentForm(CL);
end;



{ TPSImport_JvTransparentForm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTransparentForm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvTransparentForm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTransparentForm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvTransparentForm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
