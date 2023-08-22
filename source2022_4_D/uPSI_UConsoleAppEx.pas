unit uPSI_UConsoleAppEx;
{
   example class
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
  TPSImport_UConsoleAppEx = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TConsoleAppEx(CL: TPSPascalCompiler);
procedure SIRegister_UConsoleAppEx(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TConsoleAppEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_UConsoleAppEx(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   PJConsoleApp
  ,PJPipe
  ,UConsoleAppEx
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UConsoleAppEx]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TConsoleAppEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPJCustomConsoleApp', 'TConsoleAppEx') do
  with CL.AddClassN(CL.FindClass('TPJCustomConsoleApp'),'TConsoleAppEx') do
  begin
    RegisterMethod('Function Execute( const CmdLine : string; const InStream, OutStream : TStream) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UConsoleAppEx(CL: TPSPascalCompiler);
begin
  SIRegister_TConsoleAppEx(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TConsoleAppEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConsoleAppEx) do
  begin
    RegisterMethod(@TConsoleAppEx.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UConsoleAppEx(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TConsoleAppEx(CL);
end;

 
 
{ TPSImport_UConsoleAppEx }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UConsoleAppEx.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UConsoleAppEx(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UConsoleAppEx.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UConsoleAppEx(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
