unit uPSI_flcStatistics;
{
statClass       of StatisticClass with  Procedure TestStatisticClass'

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
  TPSImport_flcStatistics = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStatisticClass(CL: TPSPascalCompiler);
procedure SIRegister_flcStatistics(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStatisticClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_flcStatistics_Routines(S: TPSExec);
procedure RIRegister_flcStatistics(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cfundamentUtils       //own Set to prevent overhead
  ,flcMaths
  ,flcStatistics
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcStatistics]);
end;

//type MFloat = double;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStatisticClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStatisticClass') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStatisticClass') do
  begin
    RegisterMethod('Procedure Assign( const S : TStatisticClass)');
    RegisterMethod('Function Duplicate : TStatisticClass');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function IsEqual( const S : TStatisticClASS) : Boolean');
    RegisterMethod('Procedure Add( const V : MFloat);');
    RegisterMethod('Procedure Add1( const V : array of MFloat);');
    RegisterMethod('Procedure Add2( const V : TStatisticClass);');
    RegisterMethod('Procedure AddNegated( const V : TStatisticClass)');
    RegisterMethod('Procedure Negate');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Min', 'MFloat', iptr);
    RegisterProperty('Max', 'MFloat', iptr);
    RegisterProperty('Sum', 'MFloat', iptr);
    RegisterProperty('SumOfSquares', 'MFloat', iptr);
    RegisterProperty('SumOfCubes', 'MFloat', iptr);
    RegisterProperty('SumOfQuads', 'MFloat', iptr);
    RegisterMethod('Function Range : MFloat');
    RegisterMethod('Function Mean : MFloat');
    RegisterMethod('Function PopulationVariance : MFloat');
    RegisterMethod('Function PopulationStdDev : MFloat');
    RegisterMethod('Function Variance : MFloat');
    RegisterMethod('Function StdDev : MFloat');
    RegisterMethod('Function M1 : MFloat');
    RegisterMethod('Function M2 : MFloat');
    RegisterMethod('Function M3 : MFloat');
    RegisterMethod('Function M4 : MFloat');
    RegisterMethod('Function Skew : MFloat');
    RegisterMethod('Function Kurtosis : MFloat');
    RegisterMethod('Function GetAsString : String');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_flcStatistics(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStatistics');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStatisticsInvalidArgument');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStatisticsOverflow');
  //CL.AddTypeS('MFloat', 'double');                                 //check
  CL.AddTypeS('MFloat', 'extended');                                 //check

 CL.AddDelphiFunction('Function flcBinomialCoeff( N, R : Integer) : MFloat');
 CL.AddDelphiFunction('Function flcerf( x : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcerfc( const x : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcCummNormal( const u, s, X : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcCummNormal01( const X : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcInvCummNormal01( Y0 : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcInvCummNormal( const u, s, Y0 : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcCummChiSquare( const Chi, Df : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcCumF( const f, Df1, Df2 : MFloat) : MFloat');
 CL.AddDelphiFunction('Function flcCummPoisson( const X : Integer; const u : MFloat) : MFloat');
  SIRegister_TStatisticClass(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStatistic');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStatisticNoSample');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStatisticDivisionByZero');
 CL.AddDelphiFunction('Procedure TestStatisticClass');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStatisticClassSumOfQuads_R(Self: TStatisticClass; var T: MFloat);
begin T := Self.SumOfQuads; end;

(*----------------------------------------------------------------------------*)
procedure TStatisticClassSumOfCubes_R(Self: TStatisticClass; var T: MFloat);
begin T := Self.SumOfCubes; end;

(*----------------------------------------------------------------------------*)
procedure TStatisticClassSumOfSquares_R(Self: TStatisticClass; var T: MFloat);
begin T := Self.SumOfSquares; end;

(*----------------------------------------------------------------------------*)
procedure TStatisticClassSum_R(Self: TStatisticClass; var T: MFloat);
begin T := Self.Sum; end;

(*----------------------------------------------------------------------------*)
procedure TStatisticClassMax_R(Self: TStatisticClass; var T: MFloat);
begin T := Self.Max; end;

(*----------------------------------------------------------------------------*)
procedure TStatisticClassMin_R(Self: TStatisticClass; var T: MFloat);
begin T := Self.Min; end;

(*----------------------------------------------------------------------------*)
procedure TStatisticClassCount_R(Self: TStatisticClass; var T: Integer);
begin T := Self.Count; end;
//{
(*----------------------------------------------------------------------------*)
Procedure TStatisticClassAdd2_P(Self: TStatisticClass;  const V : TStatisticClass);
Begin
    Self.Add(V);
END;    // }

(*----------------------------------------------------------------------------*)
Procedure TStatisticClassAdd1_P(Self: TStatisticClass;  const V : array of MFloat);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
Procedure TStatisticClassAdd_P(Self: TStatisticClass;  const V : MFloat);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStatisticClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStatisticClass) do begin
    RegisterMethod(@TStatisticClass.Assign, 'Assign');
    RegisterMethod(@TStatisticClass.Duplicate, 'Duplicate');
    RegisterMethod(@TStatisticClass.Clear, 'Clear');
    RegisterMethod(@TStatisticClass.IsEqual, 'IsEqual');
    RegisterMethod(@TStatisticClassAdd_P, 'Add');
    RegisterMethod(@TStatisticClassAdd1_P, 'Add1');
    RegisterMethod(@TStatisticClassAdd2_P, 'Add2');
    RegisterMethod(@TStatisticClass.AddNegated, 'AddNegated');
    RegisterMethod(@TStatisticClass.Negate, 'Negate');
    RegisterPropertyHelper(@TStatisticClassCount_R,nil,'Count');
    RegisterPropertyHelper(@TStatisticClassMin_R,nil,'Min');
    RegisterPropertyHelper(@TStatisticClassMax_R,nil,'Max');
    RegisterPropertyHelper(@TStatisticClassSum_R,nil,'Sum');
    RegisterPropertyHelper(@TStatisticClassSumOfSquares_R,nil,'SumOfSquares');
    RegisterPropertyHelper(@TStatisticClassSumOfCubes_R,nil,'SumOfCubes');
    RegisterPropertyHelper(@TStatisticClassSumOfQuads_R,nil,'SumOfQuads');
    RegisterMethod(@TStatisticClass.Range, 'Range');
    RegisterMethod(@TStatisticClass.Mean, 'Mean');
    RegisterMethod(@TStatisticClass.PopulationVariance, 'PopulationVariance');
    RegisterMethod(@TStatisticClass.PopulationStdDev, 'PopulationStdDev');
    RegisterMethod(@TStatisticClass.Variance, 'Variance');
    RegisterMethod(@TStatisticClass.StdDev, 'StdDev');
    RegisterMethod(@TStatisticClass.M1, 'M1');
    RegisterMethod(@TStatisticClass.M2, 'M2');
    RegisterMethod(@TStatisticClass.M3, 'M3');
    RegisterMethod(@TStatisticClass.M4, 'M4');
    RegisterMethod(@TStatisticClass.Skew, 'Skew');
    RegisterMethod(@TStatisticClass.Kurtosis, 'Kurtosis');
    RegisterMethod(@TStatisticClass.GetAsString, 'GetAsString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcStatistics_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BinomialCoeff, 'flcBinomialCoeff', cdRegister);
 S.RegisterDelphiFunction(@erf, 'flcerf', cdRegister);
 S.RegisterDelphiFunction(@erfc, 'flcerfc', cdRegister);
 S.RegisterDelphiFunction(@CummNormal, 'flcCummNormal', cdRegister);
 S.RegisterDelphiFunction(@CummNormal01, 'flcCummNormal01', cdRegister);
 S.RegisterDelphiFunction(@InvCummNormal01, 'flcInvCummNormal01', cdRegister);
 S.RegisterDelphiFunction(@InvCummNormal, 'flcInvCummNormal', cdRegister);
 S.RegisterDelphiFunction(@CummChiSquare, 'flcCummChiSquare', cdRegister);
 S.RegisterDelphiFunction(@CumF, 'flcCumF', cdRegister);
 S.RegisterDelphiFunction(@CummPoisson, 'flcCummPoisson', cdRegister);
 // RIRegister_TStatisticClass(CL);
  //with CL.Add(EStatistic) do
  //with CL.Add(EStatisticNoSample) do
  //with CL.Add(EStatisticDivisionByZero) do
 S.RegisterDelphiFunction(@Test, 'TestStatisticClass', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcStatistics(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EStatistics) do
  with CL.Add(EStatisticsInvalidArgument) do
  with CL.Add(EStatisticsOverflow) do
  //with CL.Add(EStatistic) do
  with CL.Add(EStatisticNoSample) do
  with CL.Add(EStatisticDivisionByZero) do
  RIRegister_TStatisticClass(CL);
end;

 
 
{ TPSImport_flcStatistics }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcStatistics.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcStatistics(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcStatistics.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcStatistics(ri);
  RIRegister_flcStatistics_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
