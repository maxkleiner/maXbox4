{ ******************************************************************
  Multinormal distribution
  ****************************************************************** }

unit uranmult;

interface

uses
  utypes, urangaus;

procedure RanMult(M      : TVector;
                  L      : TMatrix;
                  Lb, Ub : Integer;
                  X      : TVector);
{ ------------------------------------------------------------------
  Generates a random vector X from a multinormal distribution.
  M is the mean vector, L is the Cholesky factor (lower triangular)
  of the variance-covariance matrix.
  ------------------------------------------------------------------ }

procedure RanMultIndep(M, S   : TVector;
                       Lb, Ub : Integer;
                       X      : TVector);
{ ------------------------------------------------------------------
  Generates a random vector X from a multinormal distribution with
  uncorrelated variables. M is the mean vector, S is the vector
  of standard deviations.
  ------------------------------------------------------------------ }

implementation

procedure RanMult(M      : TVector;
                  L      : TMatrix;
                  Lb, Ub : Integer;
                  X      : TVector);
var
  I, J : Integer;
  U    : TVector;
begin
  { Form a vector U of independent standard normal variates }
  DimVector(U, Ub);
  for I := Lb to Ub do
    U[I] := RanGaussStd;

  { Form X = M + L * U, which follows the multinormal distribution }
  for I := Lb to Ub do
    begin
      X[I] := M[I];
      for J := Lb to I do
        X[I] := X[I] + L[I,J] * U[J]
    end;

end;

procedure RanMultIndep(M, S   : TVector;
                       Lb, Ub : Integer;
                       X      : TVector);
var
  I : Integer;
begin
  for I := Lb to Ub do
    X[I] := RanGauss(M[I], S[I])
end;

end.
