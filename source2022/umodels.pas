{ ******************************************************************
  Properties of regression models
  ****************************************************************** }

unit umodels;

interface

uses
  utypes, {uErrors,} {upolynom,} ulinfit, {umulfit,} usvdfit, {upolfit, }
  unlfit, {ufracfit,} {uexpfit,} {uiexpfit, uexlfit, ulogifit,  }
  upowfit, umichfit, umintfit, uhillfit, upkfit, ugamfit,
  uevalfit, uregtest;

type
  TRegType =
  (REG_LIN,    {< Linear }
   REG_MULT,   {< Multiple linear }
   REG_POL,    {< Polynom }
   REG_FRAC,   {< Rational fraction }
   REG_EXPO,   {< Sum of exponentials }
   REG_IEXPO,  {< Increasing exponential }
   REG_EXLIN,  {< Exponential + linear }
   REG_LOGIS,  {< Logistic }
   REG_POWER,  {< Power }
   REG_GAMMA,  {< Gamma distribution }
   REG_MICH,   {< Michaelis equation }
   REG_MINT,   {< Integrated Michaelis equation }
   REG_HILL,   {< Hill equation }
   REG_PK,     {< Acid-base titration curve }
   REG_EVAL);  {< User-defined function }

type
  TModel = record
    case RegType : TRegType of
      REG_MULT   : (Mult_ConsTerm : Boolean; Nvar : Integer);
      REG_POL    : (Deg : Integer);
      REG_FRAC   : (Frac_ConsTerm : Boolean; Deg1, Deg2 : Integer);
      REG_EXPO   : (Expo_ConsTerm : Boolean; Nexp : Integer);
      REG_IEXPO  : (IExpo_ConsTerm : Boolean);
      REG_LOGIS  : (Logis_ConsTerm, Logis_General : Boolean);
      REG_MINT   : (MintVar : TMintVar; Fit_S0 : Boolean);
      REG_Hill   : (Hill_ConsTerm : Boolean);
    end;

  { ------------------------------------------------------------------
    Returns the index of the first regression parameter
    ------------------------------------------------------------------ }
function FirstParam(Model : TModel) : Integer;

{ ------------------------------------------------------------------
  Returns the index of the last regression parameter
  ------------------------------------------------------------------ }
function LastParam(Model : TModel) : Integer;

{ ------------------------------------------------------------------
  Returns the name of the regression function
  ------------------------------------------------------------------ }
function FuncName(Model : TModel) : String;

{ ------------------------------------------------------------------
  Returns the name of the I-th parameter
  ------------------------------------------------------------------ }
function ParamName(Model : TModel; I : Integer) : String;

{ ------------------------------------------------------------------
  Returns the regression function
  ------------------------------------------------------------------ }
function RegFunc(Model : TModel; X : Float; B : TVector) : Float;

{ ------------------------------------------------------------------
  Unweighted fit of model
  ------------------------------------------------------------------ }
procedure FitModel(Model       : TModel;
                   X, Y, Ycalc : TVector;
                   U           : TMatrix;
                   Lb, Ub      : Integer;
                   MaxIter     : Integer;
                   Tol, SVDTol : Float;
                   B           : TVector;
                   V           : TMatrix;
                   var Test    : TRegTest);

{ ------------------------------------------------------------------
  Weighted fit of model
  ------------------------------------------------------------------ }
procedure WFitModel(Model       : TModel;
                    X, Y, S     : TVector; 
                    Ycalc       : TVector;
                    U           : TMatrix;
                    Lb, Ub      : Integer;
                    MaxIter     : Integer;
                    Tol, SVDTol : Float;
                    B           : TVector;
                    V           : TMatrix;
                    var Test    : TRegTest);

implementation

function FirstParam(Model : TModel) : Integer;
begin
  with Model do
    case RegType of
      REG_MULT  : if Mult_ConsTerm  then FirstParam := 0 else FirstParam := 1;
      REG_FRAC  : if Frac_ConsTerm  then FirstParam := 0 else FirstParam := 1;
      REG_EXPO  : if Expo_ConsTerm  then FirstParam := 0 else FirstParam := 1;
      REG_IEXPO : if IExpo_ConsTerm then FirstParam := 0 else FirstParam := 1;
      REG_LOGIS : if Logis_ConsTerm then FirstParam := 0 else FirstParam := 1;
      REG_GAMMA : FirstParam := 1;
      REG_MINT  : if Fit_S0 then FirstParam := 0 else FirstParam := 1;
      REG_HILL  : if Hill_ConsTerm then FirstParam := 0 else FirstParam := 1;
      REG_EVAL  : FirstParam := 1;
    else
      FirstParam := 0;
  end;
end;

function LastParam(Model : TModel) : Integer;
begin
  with Model do
    case RegType of
      REG_LIN   : LastParam := 1;
      REG_MULT  : LastParam := Nvar;
      REG_POL   : LastParam := Deg;
      REG_FRAC  : LastParam := Deg1 + Deg2;
      REG_EXPO  : LastParam := 2 * Nexp;
      REG_IEXPO : LastParam := 2;
      REG_EXLIN : LastParam := 2;
      REG_LOGIS : if Logis_General then LastParam := 4 else LastParam := 3;
      REG_POWER : LastParam := 1;
      REG_GAMMA : LastParam := 4;
      REG_MICH  : LastParam := 1;
      REG_MINT  : LastParam := 2;
      REG_HILL  : LastParam := 3;
      REG_PK    : LastParam := 2;
      REG_EVAL  : LastParam := uevalfit.LastParam;
    end;
end;

function FuncName(Model : TModel) : String;
var
  I       : Integer;
  Name, S : String;

begin
  with Model do
    case RegType of
      REG_LIN : Name := 'y = a + b.x';

      REG_MULT : begin
                   Name := 'y = ';
                   if Mult_ConsTerm then
                     Name := Name + 'b0 + ';
                   Name := Name + 'b1.x1';
                   for I := 2 to Nvar do
                     begin
                       Str(I, S);
                       Name := Name + ' + b' + S + '.x' + S;
                     end;
                 end;

      REG_POL : begin
                  Name := 'y = b0 + b1.x';
                  for I := 2 to Deg do
                    begin
                      Str(I, S);
                      Name := Name + ' + b' + S + '.x^' + S;
                    end;
                end;

      REG_FRAC : begin
                   Name := 'y = (';
                   if Frac_ConsTerm then
                     Name := Name + 'p0 + ';
                   Name := Name + 'p1.x';
                   for I := 2 to Deg1 do
                     begin
                       Str(I, S);
                       Name := Name + ' + p' + S + '.x^' + S;
                     end;
                   Name := Name + ') / (1 + q1.x';
                   for I := (Deg1 + 2) to (Deg1 + Deg2) do
                     begin
                       Str(I - Deg1, S);
                       Name := Name + ' + q' + S + '.x^' + S;
                     end;
                   Name := Name + ')';
                 end;

      REG_EXPO : begin
                   Name := 'y = ';
                   if Expo_ConsTerm then
                     Name := Name + 'Y0 + ';
    	           Name := Name + 'A1.exp(-a1.x)';
                   for I := 2 to Nexp do
                     begin
                       Str(I, S);
                       Name := Name + ' + A' + S + '.exp(-a' + S + '.x)';
                     end;
                 end;

      REG_IEXPO : begin
                    Name := 'y = ';
                    if IExpo_ConsTerm then
                      Name := Name + 'Ymin + ';
                    Name := Name + 'A[1 - exp(-k.x)]';
                  end;

      REG_EXLIN : Name := 'y = A.[1 - exp(-k.x)] + B.x';

      REG_LOGIS : begin
                    if Logis_ConsTerm then
                      Name := 'y = A + (B - A)'
                    else
                      Name := 'y = B' ;
                    Name := Name + ' / [1 + exp(-a.x + b)]';
                    if Logis_General then
                      Name := Name + '^n';
                  end;

      REG_POWER : Name := 'y = A.x^n';

      REG_GAMMA : Name := 'y = a (x - b)^c exp[- (x - b) / d]';

      REG_MICH  : Name := 'y = Ymax x / (Km + x)';

      REG_MINT  : case MintVar of
                    Var_T,
                    Var_S : Name := 'y = s0 - Km W[(s0 / Km) exp((s0 - Vmax * t) / Km)]';
                    Var_E : Name := 'y = s0 - Km W[(s0 / Km) exp((s0 - kcat * t * e0) / Km)]';
                  end;
                    
      REG_HILL  : begin
                    if Hill_ConsTerm then
                      Name := 'y = A + (B - A)'
                    else
                      Name := 'y = B';
                    Name := Name + ' / [1 + (K / x)^n]';
                  end;

      REG_PK    : Name := 'y = A + (B - A) / [1 + 10^(pKa - x)]';

      REG_EVAL  : Name := 'y = ' + uevalfit.FuncName;
    end;

  FuncName := Name;
end;

function ParamName(Model : TModel; I : Integer) : String;
var
  S : String;
begin
  with Model do
    case RegType of
      REG_LIN   : case I of
                    0 : ParamName := 'a';
                    1 : ParamName := 'b';
                  end;

      REG_MULT,
      REG_POL   : begin
                    Str(I, S);
                    ParamName := 'b' + S;
                  end;

      REG_FRAC  : if I <= Deg1 then
                    begin
                      Str(I, S);
                      ParamName := 'p' + S;
                    end
                  else
                    begin
                      Str(I - Deg1, S);
                      ParamName := 'q' + S;
                    end;

      REG_EXPO  : if I = 0 then
                    ParamName := 'Y0'
                  else if Odd(I) then
                    begin
                      Str(Succ(I) div 2, S);
                      ParamName := 'A' + S;
                    end
                  else
                    begin
                      Str(I div 2, S);
                      ParamName := 'a' + S;
                    end;

      REG_IEXPO : case I of
                    0 : ParamName := 'Ymin';
                    1 : ParamName := 'A';
                    2 : ParamName := 'k';
                  end;

      REG_EXLIN : case I of
                    0 : ParamName := 'A';
                    1 : ParamName := 'k';
                    2 : ParamName := 'B';
                  end;

      REG_LOGIS : case I of
                    0 : ParamName := 'A';
                    1 : ParamName := 'B';
                    2 : ParamName := 'a';
                    3 : ParamName := 'b';
                    4 : ParamName := 'n';
                  end;

      REG_POWER : case I of
                    0 : ParamName := 'A';
                    1 : ParamName := 'n';
                  end;

      REG_GAMMA : case I of
                    1 : ParamName := 'a';
                    2 : ParamName := 'b';
                    3 : ParamName := 'c';
                    4 : ParamName := 'd';
                  end;

      REG_MICH  : case I of
                    0 : ParamName := 'Ymax';
                    1 : ParamName := 'Km';
                  end;

      REG_MINT  : case I of
                    0 : ParamName := 's0';
                    1 : ParamName := 'Km';
                    2 : case MintVar of
                          Var_T : ParamName := 'Vmax';
                          Var_S : ParamName := 'Vmax * t';
                          Var_E : ParamName := 'kcat * t';
                        end;
                  end;

      REG_HILL  : case I of
                    0 : ParamName := 'A';
                    1 : ParamName := 'B';
                    2 : ParamName := 'K';
                    3 : ParamName := 'n';
                  end;

      REG_PK    : case I of
                    0 : ParamName := 'A';
                    1 : ParamName := 'B';
                    2 : ParamName := 'pKa';
                  end;
                  
      REG_EVAL  : ParamName := uevalfit.ParamName(I);
    end;
end;

function RegFunc(Model : TModel; X : Float; B : TVector) : Float;
begin
  with Model do
    case RegType of
      REG_LIN   : RegFunc := B[0] + B[1] * X;
      REG_POL   : RegFunc := Poly(X, B, Deg);
      REG_FRAC  : RegFunc := FracFit_Func(X, B);
      REG_EXPO  : RegFunc := ExpFit_Func(X, B);
      REG_IEXPO : RegFunc := IncExpFit_Func(X, B);
      REG_EXLIN : RegFunc := ExpLinFit_Func(X, B);
      REG_LOGIS : RegFunc := LogiFit_Func(X, B);
      REG_POWER : RegFunc := PowFit_Func(X, B);
      REG_MICH  : RegFunc := MichFit_Func(X, B);
      REG_MINT  : RegFunc := MintFit_Func(X, B);
      REG_HILL  : RegFunc := HillFit_Func(X, B);
      REG_PK    : RegFunc := PKFit_Func(X, B);
      REG_GAMMA : RegFunc := GammaFit_Func(X, B);
      REG_EVAL  : RegFunc := EvalFit_Func(X, B);
    end;
end;

procedure Calc_Y(Model    : TModel;
                 X, Ycalc : TVector;
                 U        : TMatrix;
                 Lb, Ub   : Integer;
                 B        : TVector);
{ Compute predicted Y values }
var
  I, J : Integer;
begin
  if Model.RegType = REG_MULT then
    for I := Lb to Ub do
      begin
        if Model.Mult_ConsTerm then Ycalc[I] := B[0] else Ycalc[I] := 0.0;
        for J := 1 to Model.Nvar do
          Ycalc[I] := Ycalc[I] + B[J] * U[I,J];
      end
  else
    for I := Lb to Ub do
      Ycalc[I] := RegFunc(Model, X[I], B);
end;

procedure FitModel(Model       : TModel;
                   X, Y, Ycalc : TVector;
                   U           : TMatrix;
                   Lb, Ub      : Integer;
                   MaxIter     : Integer;
                   Tol, SVDTol : Float;
                   B           : TVector;
                   V           : TMatrix;
                   var Test    : TRegTest);
begin
  with Model do
    case RegType of
      REG_LIN   : if SVDTol > 0.0 then
                    SVDLinFit(X, Y, Lb, Ub, SVDTol, B, V)
                  else
                    LinFit(X, Y, Lb, Ub, B, V);
      REG_MULT  : if SVDTol > 0.0 then
                    SVDFit(U, Y, Lb, Ub, Nvar, Mult_ConsTerm, SVDTol, B, V)
                  else
                    MulFit(U, Y, Lb, Ub, Nvar, Mult_ConsTerm, B, V);
      REG_POL   : if SVDTol > 0.0 then
                    SVDPolFit(X, Y, Lb, Ub, Deg, SVDTol, B, V)
                  else
                    PolFit(X, Y, Lb, Ub, Deg, B, V);
      REG_FRAC  : FracFit(X, Y, Lb, Ub, Deg1, Deg2, Frac_ConsTerm, MaxIter, Tol, B, V);
      REG_EXPO  : ExpFit(X, Y, Lb, Ub, Nexp, Expo_ConsTerm, MaxIter, Tol, B, V);
      REG_IEXPO : IncExpFit(X, Y, Lb, Ub, IExpo_ConsTerm, MaxIter, Tol, B, V);
      REG_EXLIN : ExpLinFit(X, Y, Lb, Ub, MaxIter, Tol, B, V);
      REG_LOGIS : LogiFit(X, Y, Lb, Ub, Logis_ConsTerm, Logis_General, MaxIter, Tol, B, V);
      REG_POWER : PowFit(X, Y, Lb, Ub, MaxIter, Tol, B, V);
      REG_GAMMA : GammaFit(X, Y, Lb, Ub, MaxIter, Tol, B, V);
      REG_MICH  : MichFit(X, Y, Lb, Ub, MaxIter, Tol, B, V);
      REG_MINT  : MintFit(X, Y, Lb, Ub, MintVar, Fit_S0, MaxIter, Tol, B, V);
      REG_HILL  : HillFit(X, Y, Lb, Ub, Hill_ConsTerm, MaxIter, Tol, B, V);
      REG_PK    : PKFit(X, Y, Lb, Ub, MaxIter, Tol, B, V);
      REG_EVAL  : EvalFit(X, Y, Lb, Ub, MaxIter, Tol, B, V);
    end;
    if MathErr <> MathOK then
      Exit;
  { Compute predicted Y values }
  Calc_Y(Model, X, Ycalc, U, Lb, Ub, B);
  { Update var-cov. matrix and compute statistical tests }
  RegTest(Y, Ycalc, Lb, Ub, V, FirstParam(Model), LastParam(Model), Test);
end;

procedure WFitModel(Model       : TModel;
                    X, Y, S     : TVector; 
                    Ycalc       : TVector;
                    U           : TMatrix;
                    Lb, Ub      : Integer;
                    MaxIter     : Integer;
                    Tol, SVDTol : Float;
                    B           : TVector;
                    V           : TMatrix;
                    var Test    : TRegTest);
begin
  with Model do
    case RegType of
      REG_LIN   : if SVDTol > 0.0 then
                    WSVDLinFit(X, Y, S, Lb, Ub, SVDTol, B, V)
                  else
                    WLinFit(X, Y, S, Lb, Ub, B, V);
      REG_MULT  : if SVDTol > 0.0 then
                    WSVDFit(U, Y, S, Lb, Ub, Nvar, Mult_ConsTerm, SVDTol, B, V)
                  else
                    WMulFit(U, Y, S, Lb, Ub, Nvar, Mult_ConsTerm, B, V);
      REG_POL   : if SVDTol > 0.0 then
                    WSVDPolFit(X, Y, S, Lb, Ub, Deg, SVDTol, B, V)
                  else
                    WPolFit(X, Y, S, Lb, Ub, Deg, B, V);
      REG_FRAC  : WFracFit(X, Y, S, Lb, Ub, Deg1, Deg2, Frac_ConsTerm, MaxIter, Tol, B, V);
      REG_EXPO  : WExpFit(X, Y, S, Lb, Ub, Nexp, Expo_ConsTerm, MaxIter, Tol, B, V);
      REG_IEXPO : WIncExpFit(X, Y, S, Lb, Ub, IExpo_ConsTerm, MaxIter, Tol, B, V);
      REG_EXLIN : WExpLinFit(X, Y, S, Lb, Ub, MaxIter, Tol, B, V);
      REG_LOGIS : WLogiFit(X, Y, S, Lb, Ub, Logis_ConsTerm, Logis_General, MaxIter, Tol, B, V);
      REG_POWER : WPowFit(X, Y, S, Lb, Ub, MaxIter, Tol, B, V);
      REG_GAMMA : WGammaFit(X, Y, S, Lb, Ub, MaxIter, Tol, B, V);
      REG_MICH  : WMichFit(X, Y, S, Lb, Ub, MaxIter, Tol, B, V);
      REG_MINT  : WMintFit(X, Y, S, Lb, Ub, MintVar, Fit_S0, MaxIter, Tol, B, V);
      REG_HILL  : WHillFit(X, Y, S, Lb, Ub, Hill_ConsTerm, MaxIter, Tol, B, V);
      REG_PK    : WPKFit(X, Y, S, Lb, Ub, MaxIter, Tol, B, V);
      REG_EVAL  : WEvalFit(X, Y, S, Lb, Ub, MaxIter, Tol, B, V);
    end;

  { Compute predicted Y values }
  Calc_Y(Model, X, Ycalc, U, Lb, Ub, B);

  { Update var-cov. matrix and compute statistical tests }
  WRegTest(Y, Ycalc, S, Lb, Ub, V, FirstParam(Model), LastParam(Model), Test);
end;

end.
