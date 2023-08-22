unit uPSI_SimpleParserRSS;
{
third rss

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
  TPSImport_SimpleParserRSS = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSimpleParserRSS(CL: TPSPascalCompiler);
procedure SIRegister_SimpleParserRSS(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSimpleParserRSS(CL: TPSRuntimeClassImporter);
procedure RIRegister_SimpleParserRSS(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SimpleParserBase
  ,Variants
  ,SimpleParserRSS
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimpleParserRSS]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpleParserRSS(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSimpleParserBase', 'TSimpleParserRSS') do
  with CL.AddClassN(CL.FindClass('TSimpleParserBase'),'TSimpleParserRSS') do
  begin
    RegisterMethod('Procedure Parse');
    RegisterMethod('Procedure Generate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SimpleParserRSS(CL: TPSPascalCompiler);
begin
  SIRegister_TSimpleParserRSS(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpleParserRSS(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleParserRSS) do
  begin
    RegisterMethod(@TSimpleParserRSS.Parse, 'Parse');
    RegisterMethod(@TSimpleParserRSS.Generate, 'Generate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleParserRSS(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSimpleParserRSS(CL);
end;

 
 
{ TPSImport_SimpleParserRSS }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleParserRSS.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SimpleParserRSS(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleParserRSS.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SimpleParserRSS(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
