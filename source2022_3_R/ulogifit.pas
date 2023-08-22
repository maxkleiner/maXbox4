{ ******************************************************************
  This unit fits the logistic function :

                                      B - A
                        y = A + -----------------
                                1 + exp(-a.x + b)

  and the generalized logistic function :

                                        B - A
                        y = A + ---------------------
                                [1 + exp(-a.x + b)]^n
  ****************************************************************** }

unit ulogifit;

interface

uses
  utypes, umath, ulinfit, unlfit;

procedure LogiFit(X, Y     : TVector;
                  Lb, Ub   : Integer;
                  ConsTerm : Boolean;
                  General  : Boolean;
                  MaxIter  : Integer;
                  Tol      : Float;
                  B        : TVector;
                  V        : TMatrix);
{ ------------------------------------------------------------------
  Unweighted fit of logistic function
  ------------------------------------------------------------------
  Input parameters:  X, Y     = point coordinates
                     Lb, Ub   = array bounds
                     ConsTerm = presence of constant term A
                     General  = generalized logistic
                     MaxIter  = max. number of iterations
                     Tol      = tolerance on parameters
  Output parameters: B        = regression parameters
                     V        = inverse matrix
  ------------------------------------------------------------------ }

procedure WLogiFit(X, Y, S  : TVector;
                   Lb, Ub   : Integer;
                   ConsTerm : Boolean;
                   General  : Boolean;
                   MaxIter  : Integer;
                   Tol      : Float;
                   B        : TVector;
                   V        : TMatrix);
{ ------------------------------------------------------------------
  Weighted fit of logistic function
  ------------------------------------------------------------------
  Additional input parameter:
  S = standard deviations of observations
  ------------------------------------------------------------------ }

function LogiFit_Func(X : Float; B : TVector) : Float;
{ ------------------------------------------------------------------
  Computes the regression function at point X.
  B is the vector of parameters, such that :
  B[0] = A     B[1] = B     B[2] = a     B[3] = b     B[4] = n
  ------------------------------------------------------------------ }

implementation

var
  gConsTerm : Boolean = False;  { Flags the presence of a constant term A }
  gGeneral  : Boolean = False;  { Selects the generalized function }

function FirstParam : Integer;
{ ------------------------------------------------------------------
  Returns the index of the first parameter to be fitted
  (0 if there is a constant term A, 1 otherwise)
  ------------------------------------------------------------------ }
begin
  if gConsTerm then
    FirstParam := 0
  else
    FirstParam := 1;
end;

function LastParam : Integer;
{ ------------------------------------------------------------------
  Returns the index of the last parameter to be fitted
  ------------------------------------------------------------------ }
begin
  if gGeneral then
    LastParam := 4
  else
    LastParam := 3;
end;

function LogiFit_Func(X : Float; B : TVector) : Float;
{ ------------------------------------------------------------------
  Computes the regression function at point X.
  B is the vector of parameters, such that :
  B[0] = A     B[1] = B     B[2] = a     B[3] = b     B[4] = n
  ------------------------------------------------------------------ }

var
  D : Float;
begin
  D := 1.0 + Expo(- B[2] * X + B[3]);
  if gGeneral then D := Power(D, B[4]);
  if gConsTerm then
    LogiFit_Func := B[0] + (B[1] - B[0]) / D
  else
    LogiFit_Func := B[1] / D;
end;

procedure LogiFit_Deriv(X, Y : Float; B, D : TVector);
{ ------------------------------------------------------------------
  Computes the derivatives of the regression function at point X
  with respect to the parameters B. The results are returned in D.
  D[I] contains the derivative with respect to the I-th parameter
  ------------------------------------------------------------------ }
var
  C, Q, R, S : Float;
begin
  C := B[0] - B[1];              { A - B }
  Q := Expo(- B[2] * X + B[3]);  { exp(-ax+b) }
  R := 1.0 / (1.0 + Q);            { 1 / [1 + exp(-ax+b)] }
  if gGeneral then
    S := Power(R, B[4])           { 1 / [1 + exp(-ax+b)]^n }
  else
    S := R;

  D[0] := 1.0 - S;  { dy/dA = 1 - 1 / [1 + exp(-ax+b)]^n }
  D[1] := S;        { dy/dB = 1 / [1 + exp(-ax+b)]^n }

  { dy/db = n.(A-B).exp(-ax+b) / [1 + exp(-ax+b)]^(n+1) }
  D[3] := C * Q * R * S;
  if gGeneral then D[3] := B[4] * D[3];

  { dy/da = n.(B-A).x.exp(-ax+b) / [1 + exp(-ax+b)]^(n+1) }
  D[2] := - X * D[3];

  { dy/dn = (A-B).Ln[1+exp(-ax+b)] / [1 + exp(-ax+b)]^n }
  if gGeneral then
    D[4] := - C * Log(R) * S;
end;

procedure ApproxFit(Mode : TRegMode; X, Y, S : TVector;
                    Lb, Ub : Integer; B : TVector);
{ ------------------------------------------------------------------
  Approximate fit of a logistic function by linear regression:
  Ln[(B - A)/(y - A) - 1] = -ax + b
  ------------------------------------------------------------------
  Input :  Mode   = OLS for unweighted regression, WLS for weighted
           X, Y   = point coordinates
           S      = standard deviations
           Lb, Ub = array bounds
  Output : B      = estimated regression parameters
  ------------------------------------------------------------------ }
var
  XX   : TVector;  { Transformed X coordinates }
  YY   : TVector;  { Transformed Y coordinates }
  SS   : TVector;  { Weights }
  A    : TVector;  { Linear regression parameters }
  V    : TMatrix;  { Variance-covariance matrix }
  P    : Integer;  { Number of points for linear regression }
  K    : Integer;  { Loop variable }
  Xmin : Float;    { Minimal X coordinate }
  Xmax : Float;    { Maximal X coordinate }
  Imin : Integer;  { Index of Xmin, such that A ~ Y[Imin] }
  Imax : Integer;  { Index of Xmax, such that B ~ Y[Imax] }
  DB   : Float;    { B - A }
  DY   : Float;    { Y - A }
  Z    : Float;    { Transformed Y coordinate }
begin
  DimVector(XX, Ub);
  DimVector(YY, Ub);
  DimVector(SS, Ub);
  DimVector(A, 1);
  DimMatrix(V, 1, 1);

  Xmin := X[Lb]; Imin := Lb;
  Xmax := X[Ub]; Imax := Ub;

  for K := Lb to Ub do
    if X[K] < Xmin then
      begin
        Xmin := X[K];
        Imin := K;
      end
    else if X[K] > Xmax then
      begin
        Xmax := X[K];
        Imax := K;
      end;

  if gConsTerm then
    B[0] := Y[Imin]
  else
    B[0] := 0.0;

  B[1] := Y[Imax];
  DB := B[1] - B[0];

  P := Pred(Lb);
  for K := Lb to Ub do
    if Y[K] <> B[0] then
      begin
        DY := Y[K] - B[0];
        Z := DB / DY - 1.0;
        if Z > 0.0 then
          begin
            Inc(P);
            XX[P] := X[K];
            YY[P] := Ln(Z);
            SS[P] := Abs(DB / (Z * Sqr(DY)));
            if Mode = WLS then SS[P] := SS[P] * S[K];
          end;
      end;

  WLinFit(XX, YY, SS, Lb, P, A, V);

  if MathErr = MatOk then
    begin
      B[2] := - A[1];
      B[3] := A[0];
    end;

  if gGeneral then B[4] := 1.0;
end;

procedure GenLogiFit(Mode     : TRegMode;
                     X, Y, S  : TVector;
                     Lb, Ub   : Integer;
                     ConsTerm : Boolean;
                     General  : Boolean;
                     MaxIter  : Integer;
                     Tol      : Float;
                     B        : TVector;
                     V        : TMatrix);
begin
  gConsTerm := ConsTerm;
  gGeneral := General;

  if (GetOptAlgo in [NL_MARQ, NL_BFGS, NL_SIMP])
     and NullParam(B, FirstParam, LastParam) then
       ApproxFit(Mode, X, Y, S, Lb, Ub, B);

  if MaxIter = 0 then Exit;

  case Mode of
    OLS : NLFit(LogiFit_Func, LogiFit_Deriv, X, Y, Lb, Ub,
                       MaxIter, Tol, B, FirstParam, LastParam, V);
    WLS : WNLFit(LogiFit_Func, LogiFit_Deriv, X, Y, S, Lb, Ub,
                        MaxIter, Tol, B, FirstParam, LastParam, V);
  end;
end;

procedure LogiFit(X, Y     : TVector;
                  Lb, Ub   : Integer;
                  ConsTerm : Boolean;
                  General  : Boolean;
                  MaxIter  : Integer;
                  Tol      : Float;
                  B        : TVector;
                  V        : TMatrix);
begin
  GenLogiFit(OLS, X, Y, nil, Lb, Ub, ConsTerm, General, MaxIter, Tol, B, V);
end;

procedure WLogiFit(X, Y, S  : TVector;
                   Lb, Ub   : Integer;
                   ConsTerm : Boolean;
                   General  : Boolean;
                   MaxIter  : Integer;
                   Tol      : Float;
                   B        : TVector;
                   V        : TMatrix);
begin
  GenLogiFit(WLS, X, Y, S, Lb, Ub, ConsTerm, General, MaxIter, Tol, B, V);
end;

end.
