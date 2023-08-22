unit uPSI_neuralcache;
{
neurolab tester   TBytes

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
  TPSImport_neuralcache = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCacheMem(CL: TPSPascalCompiler);
procedure SIRegister_neuralcache(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCacheMem(CL: TPSRuntimeClassImporter);
procedure RIRegister_neuralcache(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   neuralcache
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuralcache]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCacheMem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCacheMem') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCacheMem') do
  begin
    RegisterMethod('Procedure Init( StateLength, DataLength : longint)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Include( var ST, DTA : TBytes)');
    RegisterMethod('Function Read( var ST, DTA : TBytes) : longint');
    RegisterMethod('Function ValidEntry( var ST : TBytes) : boolean');
    RegisterMethod('Function Used : extended');
    RegisterMethod('Function HitsOverAll : extended');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_neuralcache(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('NeuralMaxStates','LongInt').SetInt( 400000);
  CL.AddTypeS('TNeuralState', 'TBytes');
  CL.AddTypeS('TProcPred', 'Procedure ( var ST : TBytes; Acao : byte)');
  SIRegister_TCacheMem(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TCacheMem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCacheMem) do
  begin
    RegisterMethod(@TCacheMem.Init, 'Init');
    RegisterMethod(@TCacheMem.Clear, 'Clear');
    RegisterMethod(@TCacheMem.Include, 'Include');
    RegisterMethod(@TCacheMem.Read, 'Read');
    RegisterMethod(@TCacheMem.ValidEntry, 'ValidEntry');
    RegisterMethod(@TCacheMem.Used, 'Used');
    RegisterMethod(@TCacheMem.HitsOverAll, 'HitsOverAll');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralcache(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCacheMem(CL);
end;

 
 
{ TPSImport_neuralcache }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralcache.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuralcache(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralcache.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuralcache(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
