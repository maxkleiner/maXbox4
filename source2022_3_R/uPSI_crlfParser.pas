unit uPSI_crlfParser;
{
another last to machine learning
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
  TPSImport_crlfParser = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcrlfParser(CL: TPSPascalCompiler);
procedure SIRegister_crlfParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcrlfParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_crlfParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   crlfLexer
  ,crlfParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_crlfParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcrlfParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TcrlfParser') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TcrlfParser') do begin
  RegisterMethod('Constructor Create( AStream : TStream; aFlow : TcrlfFlow)');
    RegisterMethod('Procedure Free');
 //    RegisterMethod(@TStateMachine.Destroy, 'Free');
    RegisterMethod('Function Parse : String');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_crlfParser(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPppParserError');
  CL.AddTypeS('TcrlfFlow', '( flAuto, flCRLFtoLF, flLFtoCRLF )');
  SIRegister_TcrlfParser(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TcrlfParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcrlfParser) do
  begin
    RegisterConstructor(@TcrlfParser.Create, 'Create');
     RegisterMethod(@TcrlfParser.Destroy, 'Free');
    RegisterMethod(@TcrlfParser.Parse, 'Parse');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_crlfParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EPppParserError) do
  RIRegister_TcrlfParser(CL);
end;

 
 
{ TPSImport_crlfParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_crlfParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_crlfParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_crlfParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_crlfParser(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
