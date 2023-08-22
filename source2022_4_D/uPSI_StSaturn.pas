unit uPSI_StSaturn;
{
  with pluto and venus
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
  TPSImport_StSaturn = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StSaturn(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StSaturn_Routines(S: TPSExec);

procedure Register;

implementation


uses
   StAstroP
  ,StSaturn
  ,StPluto
  ,StVenus
  ,StMars
  ,StMerc
  ,StJup
  ,StUranus
  ,stNeptun
  ,stJupSat
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StSaturn]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StSaturn(CL: TPSPascalCompiler);
begin

{TStJupSatPos = packed record
    X : Double;
    Y : Double;
  end;
  TStJupSats = packed record
    Io       : TStJupSatPos;
    Europa   : TStJupSatPos;
    Ganymede : TStJupSatPos;
    Callisto : TStJupSatPos;
  end;}

  CL.AddTypeS('TStJupSatPos', 'record X: double; Y: Double; end');
  CL.AddTypeS('TStJupSats', 'record Io: TStJupSatPos; Europa: TStJupSatPos; Ganymede: TStJupSatPos; Callisto: TStJupSatPos; end');

 CL.AddDelphiFunction('Function ComputeSaturn( JD : Double) : TStEclipticalCord');
 CL.AddDelphiFunction('Function ComputePluto( JD : Double) : TStEclipticalCord');
 CL.AddDelphiFunction('Function ComputeVenus( JD : Double) : TStEclipticalCord');
 CL.AddDelphiFunction('Function ComputeMars( JD : Double) : TStEclipticalCord');
 CL.AddDelphiFunction('Function ComputeMercury( JD : Double) : TStEclipticalCord');
 CL.AddDelphiFunction('Function ComputeJupiter( JD : Double) : TStEclipticalCord');
 CL.AddDelphiFunction('Function ComputeUranus( JD : Double) : TStEclipticalCord');
 CL.AddDelphiFunction('Function ComputeNeptune( JD : Double) : TStEclipticalCord');
 CL.AddDelphiFunction('function GetJupSats(JD : TDateTime; HighPrecision, Shadows : Boolean) : TStJupSats;');



 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StSaturn_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ComputeSaturn, 'ComputeSaturn', cdRegister);
 S.RegisterDelphiFunction(@ComputeVenus, 'ComputeVenus', cdRegister);
 S.RegisterDelphiFunction(@ComputePluto, 'ComputePluto', cdRegister);
 S.RegisterDelphiFunction(@ComputeMars, 'ComputeMars', cdRegister);
 S.RegisterDelphiFunction(@ComputeMercury, 'ComputeMercury', cdRegister);
 S.RegisterDelphiFunction(@ComputeJupiter, 'ComputeJupier', cdRegister);
 S.RegisterDelphiFunction(@ComputeUranus, 'ComputeUranus', cdRegister);
 S.RegisterDelphiFunction(@ComputeNeptune, 'ComputeNeptune', cdRegister);
 S.RegisterDelphiFunction(@GetJupSats, 'GetJupSats', cdRegister);

 end;



{ TPSImport_StSaturn }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StSaturn.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StSaturn(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StSaturn.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StSaturn(ri);
  RIRegister_StSaturn_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
