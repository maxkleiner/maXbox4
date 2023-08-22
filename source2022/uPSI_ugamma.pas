unit uPSI_ugamma;
{
   FPlot or maXplot
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
  TPSImport_ugamma = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ugamma(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ugamma_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,upolev
  ,ugamma
  ,udigamma
  ,uigamma
  ,uinvgam
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ugamma]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ugamma(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function SgnGamma( X : Float) : Integer');
 CL.AddDelphiFunction('Function Stirling( X : Float) : Float');
 CL.AddDelphiFunction('Function StirLog( X : Float) : Float');
 CL.AddDelphiFunction('Function Gamma( X : Float) : Float');
 CL.AddDelphiFunction('Function LnGamma( X : Float) : Float');
 CL.AddDelphiFunction('Function DiGamma( X : Float) : Float');
 CL.AddDelphiFunction('Function TriGamma( X : Float) : Float');
 CL.AddDelphiFunction('Function IGamma( X : Float) : Float');
 CL.AddDelphiFunction('Function JGamma( X : Float) : Float');
 CL.AddDelphiFunction('Function InvGamma( X : Float) : Float');
 CL.AddDelphiFunction('Function Erf( X : Float) : Float');
 CL.AddDelphiFunction('Function Erfc( X : Float) : Float');

(* function Erf(X : Float) : Float;
{ Error function }

function Erfc(X : Float) : Float;
{ Complement of error function }*)

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ugamma_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SgnGamma, 'SgnGamma', cdRegister);
 S.RegisterDelphiFunction(@Stirling, 'Stirling', cdRegister);
 S.RegisterDelphiFunction(@StirLog, 'StirLog', cdRegister);
 S.RegisterDelphiFunction(@Gamma, 'Gamma', cdRegister);
 S.RegisterDelphiFunction(@LnGamma, 'LnGamma', cdRegister);
 S.RegisterDelphiFunction(@DiGamma, 'DiGamma', cdRegister);
 S.RegisterDelphiFunction(@TriGamma, 'TriGamma', cdRegister);
 S.RegisterDelphiFunction(@IGamma, 'IGamma', cdRegister);
 S.RegisterDelphiFunction(@JGamma, 'JGamma', cdRegister);
 S.RegisterDelphiFunction(@InvGamma, 'InvGamma', cdRegister);
 S.RegisterDelphiFunction(@Erf, 'Erf', cdRegister);
 S.RegisterDelphiFunction(@Erfc, 'Erfc', cdRegister);

end;

 
 
{ TPSImport_ugamma }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ugamma.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ugamma(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ugamma.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ugamma(ri);
  RIRegister_ugamma_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
