{ ******************************************************************
  Nonlinear regression
  ****************************************************************** }

unit unlfit;

interface

uses
  utypes, ugausjor, umarq, ubfgs, usimplex,
  usimann, ugenalg, umcmc, ustrings;

procedure SetOptAlgo(Algo : TOptAlgo);
{ ------------------------------------------------------------------
  Sets the optimization algorithm according to Algo, which must be
  NL_MARQ, NL_SIMP, NL_BFGS, NL_SA, NL_GA. Default is NL_MARQ
  ------------------------------------------------------------------ }

function GetOptAlgo : TOptAlgo;
{ ------------------------------------------------------------------
  Returns the optimization algorithm
  ------------------------------------------------------------------ }

procedure SetMaxParam(N : Byte);
{ ------------------------------------------------------------------
  Sets the maximum number of regression parameters
  ------------------------------------------------------------------ }

function GetMaxParam : Byte;
{ ------------------------------------------------------------------
  Returns the maximum number of regression parameters
  ------------------------------------------------------------------ }

procedure SetParamBounds(I : Byte; ParamMin, ParamMax : Float);
{ ------------------------------------------------------------------
  Sets the bounds on the I-th regression parameter
  ------------------------------------------------------------------ }

procedure GetParamBounds(I : Byte; var ParamMin, ParamMax : Float);
{ ------------------------------------------------------------------
  Returns the bounds on the I-th regression parameter
  ------------------------------------------------------------------ }

function NullParam(B : TVector; Lb, Ub : Integer) : Boolean;
{ ------------------------------------------------------------------
  Checks if a regression parameter is equal to zero
  ------------------------------------------------------------------ }

procedure NLFit(RegFunc   : TRegFunc;
                DerivProc : TDerivProc;
                X, Y      : TVector;
                Lb, Ub    : Integer;
                MaxIter   : Integer;
                Tol       : Float;
                B         : TVector;
                FirstPar,
                LastPar   : Integer;
                V         : TMatrix);
{ ------------------------------------------------------------------
  Unweighted nonlinear regression
  ------------------------------------------------------------------
  Input parameters:  RegFunc   = regression function
                     DerivProc = procedure to compute derivatives
                     X, Y      = point coordinates
                     Lb, Ub    = array bounds
                     MaxIter   = max. number of iterations
                     Tol       = tolerance on parameters
                     B         = initial parameter values
                     FirstPar  = index of first regression parameter
                     LasttPar  = index of last regression parameter
  Output parameters: B         = fitted regression parameters
                     V         = inverse matrix
  ------------------------------------------------------------------ }

procedure WNLFit(RegFunc   : TRegFunc;
                 DerivProc : TDerivProc;
                 X, Y, S   : TVector;
                 Lb, Ub    : Integer;
                 MaxIter   : Integer;
                 Tol       : Float;
                 B         : TVector;
                 FirstPar,
                 LastPar   : Integer;
                 V         : TMatrix);
{ ------------------------------------------------------------------
  Weighted nonlinear regression
  ------------------------------------------------------------------
  S = standard deviations of observations
  Other parameters as in NLFit
  ------------------------------------------------------------------ }

procedure SetMCFile(FileName : String);
{ ------------------------------------------------------------------
  Set file for saving MCMC simulations
  ------------------------------------------------------------------ }

procedure SimFit(RegFunc   : TRegFunc;
                 X, Y      : TVector;
                 Lb, Ub    : Integer;
                 B         : TVector;
                 FirstPar,
                 LastPar   : Integer;
                 V         : TMatrix);
{ ------------------------------------------------------------------
  Simulation of unweighted nonlinear regression by MCMC
  ------------------------------------------------------------------ }

procedure WSimFit(RegFunc   : TRegFunc;
                  X, Y, S   : TVector;
                  Lb, Ub    : Integer;
                  B         : TVector;
                  FirstPar,
                  LastPar   : Integer;
                  V         : TMatrix);
{ ------------------------------------------------------------------
  Simulation of weighted nonlinear regression by MCMC
  ------------------------------------------------------------------ }


implementation

const
  MAX_BOUND = 1.0E+6;   { Default parameter bound }
  MAX_FUNC  = 1.0E+30;  { Max. value for objective function
                          (used to prevent overflow) }

var
  MaxParam : Byte     = 10;          { Max. index of fitted parameter }
  OptAlgo  : TOptAlgo = NL_MARQ;     { Optimization algorithm }
  MCFile   : String   = 'mcmc.txt';  { File for saving MCMC simulations }

{ Global variables used by the nonlinear regression routines }
  gLb       : Integer = 0;    { Index of first point }
  gUb       : Integer = 0;    { Index of last point }
  gX        : TVector = nil;  { X coordinates }
  gY        : TVector = nil;  { Y coordinates }
  gW        : TVector = nil;  { Weights }
  gYcalc    : TVector = nil;  { Estimated Y values }
  gR        : TVector = nil;  { Residuals (Y - Ycalc) }
  gFirstPar : Integer = 0;    { Index of first fitted parameter }
  gLastPar  : Integer = 0;    { Index of last fitted parameter }
  gBmin     : TVector = nil;  { Lower bounds on parameters }
  gBmax     : TVector = nil;  { Higher bounds on parameters }
  gD        : TVector = nil;  { Derivatives of regression function }

var
  gRegFunc   : TRegFunc;    { Regression function }
  gDerivProc : TDerivProc;  { Derivation procedure }

  procedure SetOptAlgo(Algo : TOptAlgo);
  begin
    OptAlgo := Algo;
  end;

  function GetOptAlgo : TOptAlgo;
  begin
    GetOptAlgo := OptAlgo;
  end;

  procedure SetMaxParam(N : Byte);
  begin
    if N < MaxParam then Exit;

    DimVector(gBmin, N);
    DimVector(gBmax, N);

    MaxParam := N;
  end;

  function GetMaxParam : Byte;
  begin
    GetMaxParam := MaxParam;
  end;

  procedure SetParamBounds(I : Byte; ParamMin, ParamMax : Float);
  begin
    if gBmin = nil then
      DimVector(gBmin, MaxParam);

    if gBmax = nil then
      DimVector(gBmax, MaxParam);

    if (I > MaxParam) or (ParamMin >= ParamMax) then Exit;

    gBmin[I] := ParamMin;
    gBmax[I] := ParamMax;
  end;

  procedure GetParamBounds(I : Byte; var ParamMin, ParamMax : Float);
  begin
    if I > MaxParam then Exit;

    ParamMin := gBmin[I];
    ParamMax := gBmax[I];
  end;

  function NullParam(B : TVector; Lb, Ub : Integer) : Boolean;
  var
    NP : Boolean;
    I  : Integer;
  begin
    I := Lb;
    repeat
      NP := (B[I] = 0.0);
      Inc(I);
    until NP or (I > Ub);
    NullParam := NP;
  end;

  procedure SetGlobalVar(Mode      : TRegMode;
                         RegFunc   : TRegFunc;
                         DerivProc : TDerivProc;
                         X, Y, S   : TVector;
                         Lb, Ub    : Integer;
                         FirstPar,
                         LastPar   : Integer);

  { Checks the data and sets the global variables }

  var
    I, Npar, Npts : Integer;

  begin
    if LastPar > MaxParam then
      begin
        SetErrCode(NLMaxPar);
        Exit;
      end;

    Npts := Ub - Lb + 1;             { Number of points }
    Npar := LastPar - FirstPar + 1;  { Number of parameters }

    if Npts <= Npar then
      begin
        SetErrCode(MatErrDim);
        Exit;
      end;

    if Mode = WLS then
      for I := Lb to Ub do
        if S[I] <= 0.0 then
          begin
            SetErrCode(MatSing);
            Exit;
          end;
          
    gX := X;
    gY := Y;
    
    DimVector(gW, Ub);
    DimVector(gYcalc, Ub);
    DimVector(gR, Ub);

    if Mode = WLS then
      for I := Lb to Ub do
        gW[I] := 1.0 / Sqr(S[I]);

    if gBmin = nil then
      DimVector(gBmin, MaxParam);

    if gBmax = nil then
      DimVector(gBmax, MaxParam);

    for I := FirstPar to LastPar do
      if gBmin[I] >= gBmax[I] then
        begin
          gBmin[I] := - MAX_BOUND;
          gBmax[I] :=   MAX_BOUND;
        end;

    DimVector(gD, LastPar);

    gLb := Lb;
    gUb := Ub;

    gFirstPar := FirstPar;
    gLastPar := LastPar;

    gRegFunc := RegFunc;
    gDerivProc := DerivProc;

    SetErrCode(MatOk);
  end;

  function OutOfBounds(B : TVector) : Boolean;
  { Check if the parameters are inside the bounds }
  var
    I   : Integer;
    OoB : Boolean;
  begin
    I := gFirstPar;
    repeat
      OoB := (B[I] < gBmin[I]) or (B[I] > gBmax[I]);
      Inc(I);
    until OoB or (I > gLastPar);
    OutOfBounds := OoB;
  end;

  function OLS_ObjFunc(B : TVector) : Float;
  { Objective function for unweighted nonlinear regression }
  var
    K : Integer;
    S : Float;
  begin
    if OutOfBounds(B) then
      begin
        OLS_ObjFunc := MAX_FUNC;
        Exit;
      end;

    S := 0.0;
    K := gLb;

    repeat
      gYcalc[K] := gRegFunc(gX[K], B);
      gR[K] := gY[K] - gYcalc[K];
      S := S + Sqr(gR[K]);
      Inc(K);
    until (K > gUb) or (S > MAX_FUNC);

    if S > MAX_FUNC then S := MAX_FUNC;
    OLS_ObjFunc := S;
  end;

  procedure OLS_Gradient(B, G : TVector);
  { Gradient for unweighted nonlinear regression }
  var
    I, K : Integer;  { Loop variables }
  begin
    { Initialization }
    for I := gFirstPar to gLastPar do
      G[I] := 0.0;

    { Compute Gradient }
    for K := gLb to gUb do
      begin
        gDerivProc(gX[K], gYcalc[K], B, gD);
        for I := gFirstPar to gLastPar do
          G[I] := G[I] - gD[I] * gR[K];
      end;

    for I := gFirstPar to gLastPar do
      G[I] := 2.0 * G[I];
  end;

  procedure OLS_HessGrad(B, G : TVector; H : TMatrix);
  { Gradient and Hessian for unweighted nonlinear regression }
  var
    I, J, K : Integer;  { Loop variables }
  begin
    { Initializations }
    for I := gFirstPar to gLastPar do
      begin
        G[I] := 0.0;
        for J := I to gLastPar do
          H[I,J] := 0.0;
      end;

    { Compute Gradient & Hessian }
    for K := gLb to gUb do
      begin
        gDerivProc(gX[K], gYcalc[K], B, gD);
        for I := gFirstPar to gLastPar do
          begin
            G[I] := G[I] - gD[I] * gR[K];
            for J := I to gLastPar do
              H[I,J] := H[I,J] + gD[I] * gD[J];
          end;
      end;

    { Fill in symmetric matrix }
    for I := Succ(gFirstPar) to gLastPar do
      for J := gFirstPar to Pred(I) do
        H[I,J] := H[J,I];
  end;

  function WLS_ObjFunc(B : TVector) : Float;
  { Objective function for weighted nonlinear regression }
  var
    K : Integer;
    S : Float;
  begin
    if OutOfBounds(B) then
      begin
        WLS_ObjFunc := MAX_FUNC;
        Exit;
      end;

    S := 0.0;
    K := gLb;

    repeat
      gYcalc[K] := gRegFunc(gX[K], B);
      gR[K] := gY[K] - gYcalc[K];
      S := S + gW[K] * Sqr(gR[K]);
      Inc(K);
    until (K > gUb) or (S > MAX_FUNC);

    if S > MAX_FUNC then S := MAX_FUNC;
    WLS_ObjFunc := S;
  end;

  procedure WLS_Gradient(B, G : TVector);
  { Gradient for weighted nonlinear regression }
  var
    I, K : Integer;  { Loop variables }
    WR   : Float;    { Weighted residual }
  begin
    { Initialization }
    for I := gFirstPar to gLastPar do
      G[I] := 0.0;

    { Compute Gradient }
    for K := gLb to gUb do
      begin
        WR := gW[K] * gR[K];
        gDerivProc(gX[K], gYcalc[K], B, gD);
        for I := gFirstPar to gLastPar do
          G[I] := G[I] - gD[I] * WR;
      end;

    for I := gFirstPar to gLastPar do
      G[I] := 2.0 * G[I];
  end;

  procedure WLS_HessGrad(B, G : TVector; H : TMatrix);
  { Gradient and Hessian for weighted nonlinear regression }
  var
    I, J, K : Integer;  { Loop variables }
    WR, WD  : Float;    { Weighted residual and derivative }
  begin
    { Initializations }
    for I := gFirstPar to gLastPar do
      begin
        G[I] := 0.0;
        for J := I to gLastPar do
          H[I,J] := 0.0;
      end;

    { Compute Gradient & Hessian }
    for K := gLb to gUb do
      begin
        WR := gW[K] * gR[K];
        gDerivProc(gX[K], gYcalc[K], B, gD);
        for I := gFirstPar to gLastPar do
          begin
            G[I] := G[I] - gD[I] * WR;
            WD := gW[K] * gD[I];
            for J := I to gLastPar do
              H[I,J] := H[I,J] + WD * gD[J];
          end;
      end;

    { Fill in symmetric matrix }
    for I := Succ(gFirstPar) to gLastPar do
      for J := gFirstPar to Pred(I) do
        H[I,J] := H[J,I];
  end;

  procedure GenNLFit(Mode      : TRegMode;
                     RegFunc   : TRegFunc;
                     DerivProc : TDerivProc;
                     X, Y, S   : TVector;
                     Lb, Ub    : Integer;
                     MaxIter   : Integer;
                     Tol       : Float;
                     B         : TVector;
                     FirstPar,
                     LastPar   : Integer;
                     V         : TMatrix);
  { --------------------------------------------------------------------
    General nonlinear regression routine
    -------------------------------------------------------------------- }
  var
    F_min    : Float;      { Value of objective function at minimum }
    G        : TVector;    { Gradient vector }
    Det      : Float;      { Determinant of Hessian matrix }
    ObjFunc  : TFuncNVar;  { Objective function }
    GradProc : TGradient;  { Procedure to compute gradient }
    HessProc : THessGrad;  { Procedure to compute gradient and hessian }

  begin
    SetGlobalVar(Mode, RegFunc, DerivProc, X, Y, S,
                 Lb, Ub, FirstPar, LastPar);

    if MathErr <> MatOk then Exit;

    if (GetOptAlgo in [NL_MARQ, NL_BFGS, NL_SIMP]) and
        NullParam(B, FirstPar, LastPar) then
          begin
            SetErrCode(NLNullPar);
            Exit;
          end;

    if Mode = OLS then
      begin
        ObjFunc  := OLS_ObjFunc;
        GradProc := OLS_Gradient;
        HessProc := OLS_HessGrad;
      end
    else
      begin
        ObjFunc  := WLS_ObjFunc;
        GradProc := WLS_Gradient;
        HessProc := WLS_HessGrad;
      end;

    DimVector(G, LastPar);

    case OptAlgo of
      NL_MARQ : Marquardt(ObjFunc, HessProc, B, FirstPar, LastPar,
                          MaxIter, Tol, F_min, G, V, Det);
      NL_SIMP : Simplex(ObjFunc, B, FirstPar, LastPar,
                        MaxIter, Tol, F_min);
      NL_BFGS : BFGS(ObjFunc, GradProc, B, FirstPar, LastPar,
                     MaxIter, Tol, F_min, G, V);
      NL_SA   : SimAnn(ObjFunc, B, gBmin, gBmax, FirstPar, LastPar, F_min);
      NL_GA   : GenAlg(ObjFunc, B, gBmin, gBmax, FirstPar, LastPar, F_min);
    end;

    if (OptAlgo <> NL_MARQ) and (MathErr = MatOk) then
      begin
        { Compute the Hessian matrix and its inverse }
        HessProc(B, G, V);
        GaussJordan(V, FirstPar, LastPar, LastPar, Det);
      end;

  end;

  procedure NLFit(RegFunc   : TRegFunc;
                  DerivProc : TDerivProc;
                  X, Y      : TVector;
                  Lb, Ub    : Integer;
                  MaxIter   : Integer;
                  Tol       : Float;
                  B         : TVector;
                  FirstPar,
                  LastPar   : Integer;
                  V         : TMatrix);
  begin
    GenNLFit(OLS, RegFunc, DerivProc, X, Y, nil, Lb, Ub,
             MaxIter, Tol, B, FirstPar, LastPar, V);
  end;

  procedure WNLFit(RegFunc   : TRegFunc;
                   DerivProc : TDerivProc;
                   X, Y, S   : TVector;
                   Lb, Ub    : Integer;
                   MaxIter   : Integer;
                   Tol       : Float;
                   B         : TVector;
                   FirstPar,
                   LastPar   : Integer;
                   V         : TMatrix);
  begin
    GenNLFit(WLS, RegFunc, DerivProc, X, Y, S, Lb, Ub,
             MaxIter, Tol, B, FirstPar, LastPar, V);
  end;

  procedure SetMCFile(FileName : String);
  begin
    MCFile := FileName;
  end;

  procedure GenSimFit(Mode      : TRegMode;
                      RegFunc   : TRegFunc;
                      X, Y, S   : TVector;
                      Lb, Ub    : Integer;
                      B         : TVector;
                      FirstPar,
                      LastPar   : Integer;
                      V         : TMatrix);
  var
    ObjFunc  : TFuncNVar;  { Objective function }
    NCycles,
    MaxSim,
    SavedSim : Integer;    { Metropolis-Hastings parameters }
    Xmat     : TMatrix;    { Matrix of simulated parameters }
    F_min    : Float;      { Value of objective function at minimum }
    B_min    : TVector;    { Parameter values at minimum }
    R        : Float;      { Range of parameter values }
    I, J     : Integer;    { Loop variables }
    F        : Text;       { File for storing MCMC simulations }

  begin
    SetGlobalVar(Mode, RegFunc, nil, X, Y, S,
                 Lb, Ub, FirstPar, LastPar);

    if MathErr <> MatOk then Exit;

    { Initialize variance-covariance matrix }
    for I := FirstPar to LastPar do
      begin
        R := gBmax[I] - gBmin[I];
        B[I] := gBmin[I] + 0.5 * R;
        for J := FirstPar to LastPar do
          if I = J then
            { The parameter range is assumed to cover 6 SD's }
            V[I,J] := R * R / 36.0
          else
            V[I,J] := 0.0;
      end;

    if Mode = OLS then
      ObjFunc := OLS_ObjFunc
    else
      ObjFunc := WLS_ObjFunc;

    GetMHParams(NCycles, MaxSim, SavedSim);

    DimMatrix(Xmat, SavedSim, LastPar);
    DimVector(B_min, LastPar);

    Hastings(ObjFunc, 2.0, B, V, FirstPar, LastPar, Xmat, B_min, F_min);

    if MathErr = MatOk then  { Save simulations }
      begin
        Assign(F, MCFile);
        Rewrite(F);
        for I := 1 to SavedSim do
          begin
            Write(F, IntStr(I));
            for J := FirstPar to LastPar do
              Write(F, FloatStr(Xmat[I,J]));
            Writeln(F);
          end;
        Close(F);
      end;

  end;

  procedure SimFit(RegFunc   : TRegFunc;
                   X, Y      : TVector;
                   Lb, Ub    : Integer;
                   B         : TVector;
                   FirstPar,
                   LastPar   : Integer;
                   V         : TMatrix);
  begin
    GenSimFit(OLS, RegFunc, X, Y, nil, Lb, Ub, B, FirstPar, LastPar, V);
  end;

  procedure WSimFit(RegFunc   : TRegFunc;
                    X, Y, S   : TVector;
                    Lb, Ub    : Integer;
                    B         : TVector;
                    FirstPar,
                    LastPar   : Integer;
                    V         : TMatrix);
  begin
    GenSimFit(WLS, RegFunc, X, Y, S, Lb, Ub, B, FirstPar, LastPar, V);
  end;

end.
