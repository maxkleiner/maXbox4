unit uPSI_JvFormToHtml;
{
JVCL
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
  TPSImport_JvFormToHtml = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvFormToHtml(CL: TPSPascalCompiler);
procedure SIRegister_JvFormToHtml(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvFormToHtml(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvFormToHtml(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Graphics
  ,Controls
  ,Forms
  ,StdCtrls
  ,JvComponent
  ,JvFormToHtml
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvFormToHtml]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvFormToHtml(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvFormToHtml') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvFormToHtml') do begin
     //after correction by max
   RegisterMethod('Constructor Create(AOwner: TComponent);');
   RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure FormToHtml( Form : TForm; Path : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvFormToHtml(CL: TPSPascalCompiler);
begin
  SIRegister_TJvFormToHtml(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvFormToHtml(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvFormToHtml) do begin
   RegisterVirtualConstructor(@TJvFormToHtml.Create, 'Create');
    RegisterMethod(@TJvFormToHtml.Destroy, 'Free');

    RegisterMethod(@TJvFormToHtml.FormToHtml, 'FormToHtml');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvFormToHtml(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvFormToHtml(CL);
end;

 
 
{ TPSImport_JvFormToHtml }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFormToHtml.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvFormToHtml(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFormToHtml.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvFormToHtml(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
