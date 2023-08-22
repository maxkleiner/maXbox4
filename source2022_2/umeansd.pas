{ ******************************************************************
  Mean and standard deviations
  ****************************************************************** }

unit umeansd;

interface

uses
  utypes;

function Min(X : TVector; Lb, Ub : Integer) : Float;
{ Minimum of sample X }

function Max(X : TVector; Lb, Ub : Integer) : Float;
{ Maximum of sample X }

function Mean(X : TVector; Lb, Ub : Integer) : Float;
{ Mean of sample X }

function StDev(X : TVector; Lb, Ub : Integer; M : Float) : Float;
{ Standard deviation estimated from sample X }

function StDevP(X : TVector; Lb, Ub : Integer; M : Float) : Float;
{ Standard deviation of population }

implementation

function Min(X : TVector; Lb, Ub : Integer) : Float;
var
  Xmin : Float;
  I    : Integer;
begin
  Xmin := X[Lb];

  for I := Succ(Lb) to Ub do
    if X[I] < Xmin then Xmin := X[I];

  Min := Xmin;
end;

function Max(X : TVector; Lb, Ub : Integer) : Float;
var
  Xmax : Float;
  I    : Integer;
begin
  Xmax := X[Lb];

  for I := Succ(Lb) to Ub do
    if X[I] > Xmax then Xmax := X[I];

  Max := Xmax;
end;

function Mean(X : TVector; Lb, Ub : Integer) : Float;
var
  SX : Float;
  I  : Integer;
begin
  SX := 0.0;

  for I := Lb to Ub do
    SX := SX + X[I];

  Mean := SX / (Ub - Lb + 1);
end;

function StDev(X : TVector; Lb, Ub : Integer; M : Float) : Float;
var
  D, SD, SD2, V : Float;
  I, N          : Integer;
begin
  N := Ub - Lb + 1;

  SD  := 0.0;  { Sum of deviations (used to reduce roundoff error) }
  SD2 := 0.0;  { Sum of squared deviations }

  for I := Lb to Ub do
  begin
    D := X[I] - M;
    SD := SD + D;
    SD2 := SD2 + Sqr(D)
  end;

  V := (SD2 - Sqr(SD) / N) / (N - 1);  { Variance }
  StDev := Sqrt(V);
end;

function StDevP(X : TVector; Lb, Ub : Integer; M : Float) : Float;
var
  D, SD, SD2, V : Float;
  I, N          : Integer;
begin
  N := Ub - Lb + 1;

  SD  := 0.0;  { Sum of deviations (used to reduce roundoff error) }
  SD2 := 0.0;  { Sum of squared deviations }

  for I := Lb to Ub do
  begin
    D := X[I] - M;
    SD := SD + D;
    SD2 := SD2 + Sqr(D)
  end;

  V := (SD2 - Sqr(SD) / N) / N;  { Variance }
  StDevP := Sqrt(V);
end;

end.
