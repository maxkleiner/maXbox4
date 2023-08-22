{ ******************************************************************
  Multiple linear regression (Singular Value Decomposition)
  ****************************************************************** }

unit usvdfit;

interface

uses
  utypes, usvd;

procedure SVDFit(X            : TMatrix;
                 Y            : TVector;
                 Lb, Ub, Nvar : Integer;
                 ConsTerm     : Boolean;
                 SVDTol       : Float;
                 B            : TVector;
                 V            : TMatrix);
{ ------------------------------------------------------------------
  Multiple linear regression: Y = B(0) + B(1) * X + B(2) * X2 + ...
  ------------------------------------------------------------------
  Input parameters:  X        = matrix of independent variables
                     Y        = vector of dependent variable
                     Lb, Ub   = array bounds
                     Nvar     = number of independent variables
                     ConsTerm = presence of constant term B(0)
                     SVDTol   = tolerance on singular values
  Output parameters: B        = regression parameters
                     V        = inverse matrix
  ------------------------------------------------------------------ }

procedure WSVDFit(X            : TMatrix;
                  Y, S         : TVector;
                  Lb, Ub, Nvar : Integer;
                  ConsTerm     : Boolean;
                  SVDTol       : Float;
                  B            : TVector;
                  V            : TMatrix);
{ ------------------------------------------------------------------
  Weighted multiple linear regression
  ------------------------------------------------------------------
  S = standard deviations of observations
  Other parameters as in SVDFit
  ------------------------------------------------------------------ }

implementation

procedure GenSVDFit(Mode         : TRegMode;
                    X            : TMatrix;
                    Y, S         : TVector;
                    Lb, Ub, Nvar : Integer;
                    ConsTerm     : Boolean;
                    SVDTol       : Float;
                    B            : TVector;
                    V            : TMatrix);
{ ------------------------------------------------------------------
  General multiple linear regression routine (SVD algorithm)
  ------------------------------------------------------------------ }
  var
    U       : TMatrix;  { Matrix of independent variables for SVD }
    Z       : TVector;  { Vector of dependent variables for SVD }
    S1      : TVector;  { Singular values }
    S2inv   : TVector;  { Inverses of squared singular values }
    V1      : TMatrix;  { Orthogonal matrix from SVD }
    LbU     : Integer;  { Lower bound of U matrix in both dim. }
    UbU     : Integer;  { Upper bound of U matrix in 1st dim. }
    I, J, K : Integer;  { Loop variables }
    Sigma   : Float;    { Square root of weight }
    Sum     : Float;    { Element of variance-covariance matrix }

  begin
    if Ub - Lb < Nvar then
      begin
        SetErrCode(MatErrDim);
        Exit;
      end;

    if Mode = WLS then
      for K := Lb to Ub do
        if S[K] <= 0.0 then
          begin
            SetErrCode(MatSing);
            Exit;
          end;

  { ----------------------------------------------------------
    Prepare arrays for SVD :
    If constant term, use U[0..(N - Lb), 0..Nvar]
                      and Z[0..(N - Lb)]
    else              use U[1..(N - Lb + 1), 1..Nvar]
                      and Z[1..(N - Lb + 1)]
    since the lower bounds of U for the SVD routine must be
    the same in both dimensions
    ---------------------------------------------------------- }

    if ConsTerm then
      begin
        LbU := 0;
        UbU := Ub - Lb;
      end
    else
      begin
        LbU := 1;
        UbU := Ub - Lb + 1;
      end;

    { Dimension arrays }
    DimMatrix(U, UbU, Nvar);
    DimVector(Z, UbU);
    DimVector(S1, Nvar);
    DimVector(S2inv, Nvar);
    DimMatrix(V1, Nvar, Nvar);

    if Mode = OLS then
      for I := LbU to UbU do
        begin
          K := I - LbU + Lb;
          Z[I] := Y[K];
          if ConsTerm then
            U[I,0] := 1.0;
          for J := 1 to Nvar do
            U[I,J] := X[K,J];
        end
    else
      for I := LbU to UbU do
        begin
          K := I - LbU + Lb;
          Sigma := 1.0 / S[K];
          Z[I] := Y[K] * Sigma;
          if ConsTerm then
            U[I,0] := Sigma;
          for J := 1 to Nvar do
            U[I,J] := X[K,J] * Sigma;
        end;

    { Perform singular value decomposition }
    SV_Decomp(U, LbU, UbU, Nvar, S1, V1);

    if MathErr = MatOk then
      begin
        { Set the lowest singular values to zero }
        SV_SetZero(S1, LbU, Nvar, SVDTol);

        { Solve the system }
        SV_Solve(U, S1, V1, Z, LbU, UbU, Nvar, B);

        { Compute variance-covariance matrix }
        for I := LbU to Nvar do
          if S1[I] > 0.0 then
            S2inv[I] := 1.0 / Sqr(S1[I])
          else
            S2inv[I] := 0.0;
        for I := LbU to Nvar do
          for J := LbU to I do
            begin
              Sum := 0.0;
              for K := LbU to Nvar do
                Sum := Sum + V1[I,K] * V1[J,K] * S2inv[K];
              V[I,J] := Sum;
              V[J,I] := Sum;
            end;
      end;

  end;

procedure SVDFit(X            : TMatrix;
                 Y            : TVector;
                 Lb, Ub, Nvar : Integer;
                 ConsTerm     : Boolean;
                 SVDTol       : Float;
                 B            : TVector;
                 V            : TMatrix);

  begin
    GenSVDFit(OLS, X, Y, nil, Lb, Ub, Nvar, ConsTerm, SVDTol, B, V);
  end;

procedure WSVDFit(X            : TMatrix;
                  Y, S         : TVector;
                  Lb, Ub, Nvar : Integer;
                  ConsTerm     : Boolean;
                  SVDTol       : Float;
                  B            : TVector;
                  V            : TMatrix);

  begin
    GenSVDFit(WLS, X, Y, S, Lb, Ub, Nvar, ConsTerm, SVDTol, B, V);
  end;

end.