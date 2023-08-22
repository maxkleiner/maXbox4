unit uPSI_LibFusion;
{
  with kind request of inno and rem objects
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
  TPSImport_LibFusion = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAssemblyCacheInfo(CL: TPSPascalCompiler);
procedure SIRegister_LibFusion(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_LibFusion_Routines(S: TPSExec);
procedure RIRegister_TAssemblyCacheInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_LibFusion(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Ole2
  ,Windows
  ,CmnFunc2
  ,LibFusion
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_LibFusion]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAssemblyCacheInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TAssemblyCacheInfo') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TAssemblyCacheInfo') do begin
    RegisterMethod('Constructor Create( RegView : TRegView)');
     RegisterMethod('Procedure Free');
     RegisterProperty('Cache', 'IAssemblyCache', iptr);
    RegisterMethod('Procedure InstallAssembly( const FileName : string)');
    RegisterMethod('Procedure UninstallAssembly( const StrongAssemblyName : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_LibFusion(CL: TPSPascalCompiler);
begin
  SIRegister_TAssemblyCacheInfo(CL);
  CL.AddTypeS('TDotNetVersion', '( dt11, dt20, dt40, dtHighestKnown )');
 CL.AddDelphiFunction('Function GetDotNetRoot( RegView : TRegView) : String');
 CL.AddDelphiFunction('Function GetDotNetVersionRoot( RegView : TRegView; Version : TDotNetVersion) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAssemblyCacheInfoCache_R(Self: TAssemblyCacheInfo; var T: IAssemblyCache);
begin T := Self.Cache; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_LibFusion_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetDotNetRoot, 'GetDotNetRoot', cdRegister);
 S.RegisterDelphiFunction(@GetDotNetVersionRoot, 'GetDotNetVersionRoot', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAssemblyCacheInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAssemblyCacheInfo) do begin
    RegisterConstructor(@TAssemblyCacheInfo.Create, 'Create');
      RegisterMethod(@TAssemblyCacheInfo.Destroy, 'Free');
      RegisterPropertyHelper(@TAssemblyCacheInfoCache_R,nil,'Cache');
    RegisterMethod(@TAssemblyCacheInfo.InstallAssembly, 'InstallAssembly');
    RegisterMethod(@TAssemblyCacheInfo.UninstallAssembly, 'UninstallAssembly');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_LibFusion(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAssemblyCacheInfo(CL);
end;

 
 
{ TPSImport_LibFusion }
(*----------------------------------------------------------------------------*)
procedure TPSImport_LibFusion.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_LibFusion(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_LibFusion.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_LibFusion(ri);
  RIRegister_LibFusion_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
