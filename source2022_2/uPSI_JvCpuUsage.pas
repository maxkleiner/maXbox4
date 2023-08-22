unit uPSI_JvCpuUsage;
{
  control the realtime
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
  TPSImport_JvCpuUsage = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvCpuUsage(CL: TPSPascalCompiler);
procedure SIRegister_JvCpuUsage(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvCpuUsage(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvCpuUsage(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Registry
  ,JvComponent
  ,JvCpuUsage
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvCpuUsage]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCpuUsage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvCpuUsage') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvCpuUsage') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Usage', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvCpuUsage(CL: TPSPascalCompiler);
begin
  SIRegister_TJvCpuUsage(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvCpuUsageUsage_W(Self: TJvCpuUsage; const T: string);
begin Self.Usage := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCpuUsageUsage_R(Self: TJvCpuUsage; var T: string);
begin T := Self.Usage; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCpuUsage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCpuUsage) do begin
    RegisterConstructor(@TJvCpuUsage.Create, 'Create');
   RegisterMethod(@TJvCpuUsage.Free, 'Free');
    RegisterPropertyHelper(@TJvCpuUsageUsage_R,@TJvCpuUsageUsage_W,'Usage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvCpuUsage(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvCpuUsage(CL);
end;

 
 
{ TPSImport_JvCpuUsage }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCpuUsage.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvCpuUsage(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCpuUsage.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvCpuUsage(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
