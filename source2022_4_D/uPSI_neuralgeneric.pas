unit uPSI_neuralgeneric;
{
Tfor trandom dom
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
  TPSImport_neuralgeneric = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRandom(CL: TPSPascalCompiler);
procedure SIRegister_TIncDec(CL: TPSPascalCompiler);
procedure SIRegister_neuralgeneric(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_neuralgeneric_Routines(S: TPSExec);
procedure RIRegister_TRandom(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIncDec(CL: TPSRuntimeClassImporter);
procedure RIRegister_neuralgeneric(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   neuralgeneric
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuralgeneric]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRandom(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TRandom') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TRandom') do
  begin
    RegisterMethod('Procedure Save');
    RegisterMethod('Procedure Restore');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIncDec(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIncDec') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIncDec') do
  begin
    RegisterMethod('Constructor Init( PMin, PMax, PStep, Start : longint)');
    RegisterMethod('Procedure Done;');
    RegisterMethod('Procedure Inc');
    RegisterMethod('Procedure Dec');
    RegisterMethod('Function Read : longint');
    RegisterMethod('Procedure Define( PX : longint)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_neuralgeneric(CL: TPSPascalCompiler);
begin
  SIRegister_TIncDec(CL);
  SIRegister_TRandom(CL);
 CL.AddDelphiFunction('Function MaxSingle2( x, y : single) : single');
 CL.AddDelphiFunction('Function GetMaxDivisor( x, acceptableMax : integer) : integer');
 CL.AddDelphiFunction('Function GetMaxAcceptableCommonDivisor( a, b : integer; max_acceptable : integer) : integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralgeneric_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MaxSingle, 'MaxSingle2', cdRegister);
 S.RegisterDelphiFunction(@GetMaxDivisor, 'GetMaxDivisor', cdRegister);
 S.RegisterDelphiFunction(@GetMaxAcceptableCommonDivisor, 'GetMaxAcceptableCommonDivisor', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRandom(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRandom) do
  begin
    RegisterMethod(@TRandom.Save, 'Save');
    RegisterMethod(@TRandom.Restore, 'Restore');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIncDec(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIncDec) do
  begin
    RegisterConstructor(@TIncDec.Init, 'Init');
    RegisterMethod(@TIncDec.Done, 'Done');
    RegisterMethod(@TIncDec.Inc, 'Inc');
    RegisterMethod(@TIncDec.Dec, 'Dec');
    RegisterMethod(@TIncDec.Read, 'Read');
    RegisterMethod(@TIncDec.Define, 'Define');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralgeneric(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIncDec(CL);
  RIRegister_TRandom(CL);
end;

 
 
{ TPSImport_neuralgeneric }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralgeneric.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuralgeneric(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralgeneric.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuralgeneric(ri);
  RIRegister_neuralgeneric_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
