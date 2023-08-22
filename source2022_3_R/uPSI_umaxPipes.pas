unit uPSI_umaxPipes;
{
maxpipe = coolcode

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
  TPSImport_umaxPipes = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPipeClientmax(CL: TPSPascalCompiler);
procedure SIRegister_TPipeServermax(CL: TPSPascalCompiler);
procedure SIRegister_umaxPipes(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPipeClientmax(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPipeServermax(CL: TPSRuntimeClassImporter);
procedure RIRegister_umaxPipes(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,umaxPipes
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_umaxPipes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPipeClientmax(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPipeClientmax') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPipeClientmax') do
  begin
    RegisterMethod('Constructor Create( aServer, aPipe : String)');
    RegisterMethod('Function SendString( aStr : String) : String');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPipeServermax(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TPipeServermax') do
  with CL.AddClassN(CL.FindClass('TThread'),'TPipeServermax') do
  begin
    RegisterMethod('Constructor CreatePipeServer( aServer, aPipe : String; StartServer : Boolean)');
    RegisterMethod('Procedure StartUpServer');
    RegisterMethod('Procedure ShutDownServer');
    RegisterMethod('Procedure Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_umaxPipes(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cShutDownMsg','String').SetString( 'shutdown pipe ');
 CL.AddConstantN('cPipeFormat','String').SetString( '\\%s\pipe\%s');
  SIRegister_TPipeServermax(CL);
  SIRegister_TPipeClientmax(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TPipeClientmax(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPipeClientmax) do
  begin
    RegisterConstructor(@TPipeClientmax.Create, 'Create');
    RegisterMethod(@TPipeClientmax.SendString, 'SendString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPipeServermax(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPipeServermax) do
  begin
    RegisterConstructor(@TPipeServermax.CreatePipeServer, 'CreatePipeServer');
    RegisterMethod(@TPipeServermax.StartUpServer, 'StartUpServer');
    RegisterMethod(@TPipeServermax.ShutDownServer, 'ShutDownServer');
    RegisterMethod(@TPipeServermax.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_umaxPipes(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPipeServermax(CL);
  RIRegister_TPipeClientmax(CL);
end;

 
 
{ TPSImport_umaxPipes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_umaxPipes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_umaxPipes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_umaxPipes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_umaxPipes(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
