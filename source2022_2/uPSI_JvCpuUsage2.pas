unit uPSI_JvCpuUsage2;
{
  will need kernel access  , ntdll.dll
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
  TPSImport_JvCpuUsage2 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvCpuUsage2(CL: TPSPascalCompiler);
procedure SIRegister_JvCpuUsage2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvCpuUsage2(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvCpuUsage2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  Registry
  ,JvComponentBase
  ,JvCpuUsage2
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvCpuUsage2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCpuUsage2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvCpuUsage2') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvCpuUsage2') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Usage', 'Double', iptr);    //alias
    RegisterProperty('CPUUsage', 'Double', iptr);    //alias
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvCpuUsage2(CL: TPSPascalCompiler);
begin
  SIRegister_TJvCpuUsage2(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvCpuUsage2Usage_R(Self: TJvCpuUsage2; var T: Double);
begin T := Self.Usage; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCpuUsage2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCpuUsage2) do begin
    RegisterConstructor(@TJvCpuUsage2.Create, 'Create');
    RegisterPropertyHelper(@TJvCpuUsage2Usage_R,nil,'Usage');
    RegisterPropertyHelper(@TJvCpuUsage2Usage_R,nil,'CPUUsage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvCpuUsage2(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvCpuUsage2(CL);
end;

 
 
{ TPSImport_JvCpuUsage2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCpuUsage2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvCpuUsage2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCpuUsage2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvCpuUsage2(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
