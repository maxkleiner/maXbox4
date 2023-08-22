{ ******************************************************************
  Unit DMATH - Interface for DMATH.DLL
  ****************************************************************** }

unit dmath;

interface

{$IFDEF DELPHI}
uses
  StdCtrls, Graphics;
{$ENDIF}

{ ------------------------------------------------------------------
  Types and constants
  ------------------------------------------------------------------ }

{$i types.inc}

{ ------------------------------------------------------------------
  Error handling
  ------------------------------------------------------------------ }

procedure SetErrCode(ErrCode : Integer); external 'dmath';
{ Sets the error code }

function DefaultVal(ErrCode : Integer; DefVal : Float) : Float; external 'dmath';
{ Sets error code and default function value }

function MathErr : Integer; external 'dmath';
{ Returns the error code }

{ ------------------------------------------------------------------
  Dynamic arrays
  ------------------------------------------------------------------ }

procedure SetAutoInit(AutoInit : Boolean); external 'dmath';
{ Sets the auto-initialization of arrays }

procedure DimVector(var V : TVector; Ub : Integer); external 'dmath';
{ Creates floating point vector V[0..Ub] }

procedure DimIntVector(var V : TIntVector; Ub : Integer); external 'dmath';
{ Creates integer vector V[0..Ub] }

procedure DimCompVector(var V : TCompVector; Ub : Integer); external 'dmath';
{ Creates complex vector V[0..Ub] }

procedure DimBoolVector(var V : TBoolVector; Ub : Integer); external 'dmath';
{ Creates boolean vector V[0..Ub] }

procedure DimStrVector(var V : TStrVector; Ub : Integer); external 'dmath';
{ Creates string vector V[0..Ub] }

procedure DimMatrix(var A : TMatrix; Ub1, Ub2 : Integer); external 'dmath';
{ Creates floating point matrix A[0..Ub1, 0..Ub2] }

procedure DimIntMatrix(var A : TIntMatrix; Ub1, Ub2 : Integer); external 'dmath';
{ Creates integer matrix A[0..Ub1, 0..Ub2] }

procedure DimCompMatrix(var A : TCompMatrix; Ub1, Ub2 : Integer); external 'dmath';
{ Creates complex matrix A[0..Ub1, 0..Ub2] }

procedure DimBoolMatrix(var A : TBoolMatrix; Ub1, Ub2 : Integer); external 'dmath';
{ Creates boolean matrix A[0..Ub1, 0..Ub2] }

procedure DimStrMatrix(var A : TStrMatrix; Ub1, Ub2 : Integer); external 'dmath';
{ Creates string matrix A[0..Ub1, 0..Ub2] }

{ ------------------------------------------------------------------
  Minimum, maximum, sign and exchange
  ------------------------------------------------------------------ }

function FMin(X, Y : Float) : Float; external 'dmath';
{ Minimum of 2 reals }

function FMax(X, Y : Float) : Float; external 'dmath';
{ Maximum of 2 reals }

function IMin(X, Y : Integer) : Integer; external 'dmath';
{ Minimum of 2 integers }

function IMax(X, Y : Integer) : Integer; external 'dmath';
{ Maximum of 2 integers }

function Sgn(X : Float) : Integer; external 'dmath';
{ Sign (returns 1 if X = 0) }

function Sgn0(X : Float) : Integer; external 'dmath';
{ Sign (returns 0 if X = 0) }

function DSgn(A, B : Float) : Float; external 'dmath';
{ Sgn(B) * |A| }

procedure FSwap(var X, Y : Float); external 'dmath';
{ Exchange 2 reals }

procedure ISwap(var X, Y : Integer); external 'dmath';
{ Exchange 2 integers }

{ ------------------------------------------------------------------
  Rounding functions
  ------------------------------------------------------------------ }

function RoundN(X : Float; N : Integer) : Float; external 'dmath';
{ Rounds X to N decimal places }

function Ceil(X : Float) : Integer; external 'dmath';
{ Ceiling function }

function Floor(X : Float) : Integer; external 'dmath';
{ Floor function }

{ ------------------------------------------------------------------
  Logarithms, exponentials and power
  ------------------------------------------------------------------ }

function Expo(X : Float) : Float; external 'dmath';
{ Exponential }

function Exp2(X : Float) : Float; external 'dmath';
{ 2^X }

function Exp10(X : Float) : Float; external 'dmath';
{ 10^X }

function Log(X : Float) : Float; external 'dmath';
{ Natural log }

function Log2(X : Float) : Float; external 'dmath';
{ Log, base 2 }

function Log10(X : Float) : Float; external 'dmath';
{ Decimal log }

function LogA(X, A : Float) : Float; external 'dmath';
{ Log, base A }

function IntPower(X : Float; N : Integer) : Float; external 'dmath';
{ X^N }

function Power(X, Y : Float) : Float; external 'dmath';
{ X^Y, X >= 0 }

{ ------------------------------------------------------------------
  Trigonometric functions
  ------------------------------------------------------------------ }

function Pythag(X, Y : Float) : Float; external 'dmath';
{ Sqrt(X^2 + Y^2) }

function FixAngle(Theta : Float) : Float; external 'dmath';
{ Set Theta in -Pi..Pi }

function Tan(X : Float) : Float; external 'dmath';
{ Tangent }

function ArcSin(X : Float) : Float; external 'dmath';
{ Arc sinus }

function ArcCos(X : Float) : Float; external 'dmath';
{ Arc cosinus }

function ArcTan2(Y, X : Float) : Float; external 'dmath';
{ Angle (Ox, OM) with M(X,Y) }

{ ------------------------------------------------------------------
  Hyperbolic functions
  ------------------------------------------------------------------ }

function Sinh(X : Float) : Float; external 'dmath';
{ Hyperbolic sine }

function Cosh(X : Float) : Float; external 'dmath';
{ Hyperbolic cosine }

function Tanh(X : Float) : Float; external 'dmath';
{ Hyperbolic tangent }

function ArcSinh(X : Float) : Float; external 'dmath';
{ Inverse hyperbolic sine }

function ArcCosh(X : Float) : Float; external 'dmath';
{ Inverse hyperbolic cosine }

function ArcTanh(X : Float) : Float; external 'dmath';
{ Inverse hyperbolic tangent }

procedure SinhCosh(X : Float; var SinhX, CoshX : Float); external 'dmath';
{ Sinh & Cosh }

{ ------------------------------------------------------------------
  Gamma function and related functions
  ------------------------------------------------------------------ }

function Fact(N : Integer) : Float; external 'dmath';
{ Factorial }

function SgnGamma(X : Float) : Integer; external 'dmath';
{ Sign of Gamma function }

function Gamma(X : Float) : Float; external 'dmath';
{ Gamma function }

function LnGamma(X : Float) : Float; external 'dmath';
{ Logarithm of Gamma function }

function Stirling(X : Float) : Float; external 'dmath';
{ Stirling's formula for the Gamma function }

function StirLog(X : Float) : Float; external 'dmath';
{ Approximate Ln(Gamma) by Stirling's formula, for X >= 13 }

function DiGamma(X : Float ) : Float; external 'dmath';
{ Digamma function }

function TriGamma(X : Float ) : Float; external 'dmath';
{ Trigamma function }

function IGamma(A, X : Float) : Float; external 'dmath';
{ Incomplete Gamma function}

function JGamma(A, X : Float) : Float; external 'dmath';
{ Complement of incomplete Gamma function }

function InvGamma(A, P : Float) : Float; external 'dmath';
{ Inverse of incomplete Gamma function }

function Erf(X : Float) : Float; external 'dmath';
{ Error function }

function Erfc(X : Float) : Float; external 'dmath';
{ Complement of error function }

{ ------------------------------------------------------------------
  Beta function and related functions
  ------------------------------------------------------------------ }

function Beta(X, Y : Float) : Float; external 'dmath';
{ Beta function }

function IBeta(A, B, X : Float) : Float; external 'dmath';
{ Incomplete Beta function }

function InvBeta(A, B, Y : Float) : Float; external 'dmath';
{ Inverse of incomplete Beta function }

{ ------------------------------------------------------------------
  Lambert's function
  ------------------------------------------------------------------ }

function LambertW(X : Float; UBranch, Offset : Boolean) : Float; external 'dmath';

{ ------------------------------------------------------------------
  Binomial distribution
  ------------------------------------------------------------------ }

function Binomial(N, K : Integer) : Float; external 'dmath';
{ Binomial coefficient C(N,K) }

function PBinom(N : Integer; P : Float; K : Integer) : Float; external 'dmath';
{ Probability of binomial distribution }

function FBinom(N : Integer; P : Float; K : Integer) : Float; external 'dmath';
{ Cumulative probability for binomial distrib. }

{ ------------------------------------------------------------------
  Poisson distribution
  ------------------------------------------------------------------ }

function PPoisson(Mu : Float; K : Integer) : Float; external 'dmath';
{ Probability of Poisson distribution }

function FPoisson(Mu : Float; K : Integer) : Float; external 'dmath';
{ Cumulative probability for Poisson distrib. }

{ ------------------------------------------------------------------
  Exponential distribution
  ------------------------------------------------------------------ }

function DExpo(A, X : Float) : Float; external 'dmath';
{ Density of exponential distribution with parameter A }

function FExpo(A, X : Float) : Float; external 'dmath';
{ Cumulative probability function for exponential dist. with parameter A }

{ ------------------------------------------------------------------
  Standard normal distribution
  ------------------------------------------------------------------ }

function DNorm(X : Float) : Float; external 'dmath';
{ Density of standard normal distribution }

function FNorm(X : Float) : Float; external 'dmath';
{ Cumulative probability for standard normal distrib. }

function PNorm(X : Float) : Float; external 'dmath';
{ Prob(|U| > X) for standard normal distrib. }

function InvNorm(P : Float) : Float; external 'dmath';
{ Inverse of standard normal distribution }

{ ------------------------------------------------------------------
  Student's distribution
  ------------------------------------------------------------------ }

function DStudent(Nu : Integer; X : Float) : Float; external 'dmath';
{ Density of Student distribution with Nu d.o.f. }

function FStudent(Nu : Integer; X : Float) : Float; external 'dmath';
{ Cumulative probability for Student distrib. with Nu d.o.f. }

function PStudent(Nu : Integer; X : Float) : Float; external 'dmath';
{ Prob(|t| > X) for Student distrib. with Nu d.o.f. }

function InvStudent(Nu : Integer; P : Float) : Float; external 'dmath';
{ Inverse of Student's t-distribution function }

{ ------------------------------------------------------------------
  Khi-2 distribution
  ------------------------------------------------------------------ }

function DKhi2(Nu : Integer; X : Float) : Float; external 'dmath';
{ Density of Khi-2 distribution with Nu d.o.f. }

function FKhi2(Nu : Integer; X : Float) : Float; external 'dmath';
{ Cumulative prob. for Khi-2 distrib. with Nu d.o.f. }

function PKhi2(Nu : Integer; X : Float) : Float; external 'dmath';
{ Prob(Khi2 > X) for Khi-2 distrib. with Nu d.o.f. }

function InvKhi2(Nu : Integer; P : Float) : Float; external 'dmath';
{ Inverse of Khi-2 distribution function }

{ ------------------------------------------------------------------
  Fisher-Snedecor distribution
  ------------------------------------------------------------------ }

function DSnedecor(Nu1, Nu2 : Integer; X : Float) : Float; external 'dmath';
{ Density of Fisher-Snedecor distribution with Nu1 and Nu2 d.o.f. }

function FSnedecor(Nu1, Nu2 : Integer; X : Float) : Float; external 'dmath';
{ Cumulative prob. for Fisher-Snedecor distrib. with Nu1 and Nu2 d.o.f. }

function PSnedecor(Nu1, Nu2 : Integer; X : Float) : Float; external 'dmath';
{ Prob(F > X) for Fisher-Snedecor distrib. with Nu1 and Nu2 d.o.f. }

function InvSnedecor(Nu1, Nu2 : Integer; P : Float) : Float; external 'dmath';
{ Inverse of Snedecor's F-distribution function }

{ ------------------------------------------------------------------
  Beta distribution
  ------------------------------------------------------------------ }

function DBeta(A, B, X : Float) : Float; external 'dmath';
{ Density of Beta distribution with parameters A and B }

function FBeta(A, B, X : Float) : Float; external 'dmath';
{ Cumulative probability for Beta distrib. with param. A and B }

{ ------------------------------------------------------------------
  Gamma distribution
  ------------------------------------------------------------------ }

function DGamma(A, B, X : Float) : Float; external 'dmath';
{ Density of Gamma distribution with parameters A and B }

function FGamma(A, B, X : Float) : Float; external 'dmath';
{ Cumulative probability for Gamma distrib. with param. A and B }

{ ------------------------------------------------------------------
  Expression evaluation
  ------------------------------------------------------------------ }

function InitEval : Integer; external 'dmath';
{ Initializes built-in functions and returns their number }

function Eval(ExpressionString : String) : Float; external 'dmath';
{ Evaluates an expression at run-time }

procedure SetVariable(VarName : Char; Value : Float); external 'dmath';
{ Assigns a value to a variable }

procedure SetFunction(FuncName : String; Wrapper : TWrapper); external 'dmath';
{ Adds a function to the parser }

{ ------------------------------------------------------------------
  Matrices and linear equations
  ------------------------------------------------------------------ }

procedure GaussJordan(A            : TMatrix;
                      Lb, Ub1, Ub2 : Integer;
                      var Det      : Float); external 'dmath';
{ Transforms a matrix according to the Gauss-Jordan method }

procedure LinEq(A       : TMatrix;
                B       : TVector;
                Lb, Ub  : Integer;
                var Det : Float); external 'dmath';
{ Solves a linear system according to the Gauss-Jordan method }

procedure Cholesky(A, L : TMatrix; Lb, Ub : Integer); external 'dmath';
{ Cholesky factorization of a positive definite symmetric matrix }

procedure LU_Decomp(A : TMatrix; Lb, Ub : Integer); external 'dmath';
{ LU decomposition }

procedure LU_Solve(A      : TMatrix;
                   B      : TVector;
                   Lb, Ub : Integer;
                   X      : TVector); external 'dmath';
{ Solution of linear system from LU decomposition }

procedure QR_Decomp(A            : TMatrix;
                    Lb, Ub1, Ub2 : Integer;
                    R            : TMatrix); external 'dmath';
{ QR decomposition }

procedure QR_Solve(Q, R         : TMatrix;
                   B            : TVector;
                   Lb, Ub1, Ub2 : Integer;
                   X            : TVector); external 'dmath';
{ Solution of linear system from QR decomposition }

procedure SV_Decomp(A            : TMatrix;
                    Lb, Ub1, Ub2 : Integer;
                    S            : TVector;
                    V            : TMatrix); external 'dmath';
{ Singular value decomposition }

procedure SV_SetZero(S      : TVector;
                     Lb, Ub : Integer;
                     Tol    : Float); external 'dmath';
{ Set lowest singular values to zero }

procedure SV_Solve(U            : TMatrix;
                   S            : TVector;
                   V            : TMatrix;
                   B            : TVector;
                   Lb, Ub1, Ub2 : Integer;
                   X            : TVector); external 'dmath';
{ Solution of linear system from SVD }

procedure SV_Approx(U            : TMatrix;
                    S            : TVector;
                    V            : TMatrix;
                    Lb, Ub1, Ub2 : Integer;
                    A            : TMatrix); external 'dmath';
{ Matrix approximation from SVD }

procedure EigenVals(A      : TMatrix;
                    Lb, Ub : Integer;
                    Lambda : TCompVector); external 'dmath';
{ Eigenvalues of a general square matrix }

procedure EigenVect(A      : TMatrix;
                    Lb, Ub : Integer;
                    Lambda : TCompVector;
                    V      : TMatrix); external 'dmath';
{ Eigenvalues and eigenvectors of a general square matrix }

procedure EigenSym(A      : TMatrix;
                   Lb, Ub : Integer;
                   Lambda : TVector;
                   V      : TMatrix); external 'dmath';
{ Eigenvalues and eigenvectors of a symmetric matrix (SVD method) }

procedure Jacobi(A               : TMatrix;
                 Lb, Ub, MaxIter : Integer;
                 Tol             : Float;
                 Lambda          : TVector;
                 V               : TMatrix); external 'dmath';
{ Eigenvalues and eigenvectors of a symmetric matrix (Jacobi method) }

{ ------------------------------------------------------------------
  Optimization
  ------------------------------------------------------------------ }

procedure MinBrack(Func                    : TFunc;
                   var A, B, C, Fa, Fb, Fc : Float); external 'dmath';
{ Brackets a minimum of a function }

procedure GoldSearch(Func           : TFunc;
                     A, B           : Float;
                     MaxIter        : Integer;
                     Tol            : Float;
                     var Xmin, Ymin : Float); external 'dmath';
{ Minimization of a function of one variable (golden search) }

procedure LinMin(Func      : TFuncNVar;
                 X, DeltaX : TVector;
                 Lb, Ub    : Integer;
                 var R     : Float;
                 MaxIter   : Integer;
                 Tol       : Float;
                 var F_min : Float); external 'dmath';
{ Minimization of a function of several variables along a line }

procedure Newton(Func      : TFuncNVar;
                 HessGrad  : THessGrad;
                 X         : TVector;
                 Lb, Ub    : Integer;
                 MaxIter   : Integer;
                 Tol       : Float;
                 var F_min : Float;
                 G         : TVector;
                 H_inv     : TMatrix;
                 var Det   : Float); external 'dmath';
{ Minimization of a function of several variables (Newton's method) }

procedure SaveNewton(FileName : string); external 'dmath';
{ Save Newton iterations in a file }

procedure Marquardt(Func      : TFuncNVar;
                    HessGrad  : THessGrad;
                    X         : TVector;
                    Lb, Ub    : Integer;
                    MaxIter   : Integer;
                    Tol       : Float;
                    var F_min : Float;
                    G         : TVector;
                    H_inv     : TMatrix;
                    var Det   : Float); external 'dmath';
{ Minimization of a function of several variables (Marquardt's method) }

procedure SaveMarquardt(FileName : string); external 'dmath';
{ Save Marquardt iterations in a file }

procedure BFGS(Func      : TFuncNVar;
               Gradient  : TGradient;
               X         : TVector;
               Lb, Ub    : Integer;
               MaxIter   : Integer;
               Tol       : Float;
               var F_min : Float;
               G         : TVector;
               H_inv     : TMatrix); external 'dmath';
{ Minimization of a function of several variables (BFGS method) }

procedure SaveBFGS(FileName : string); external 'dmath';
{ Save BFGS iterations in a file }

procedure Simplex(Func      : TFuncNVar;
                  X         : TVector;
                  Lb, Ub    : Integer;
                  MaxIter   : Integer;
                  Tol       : Float;
                  var F_min : Float); external 'dmath';
{ Minimization of a function of several variables (Simplex) }

procedure SaveSimplex(FileName : string); external 'dmath';
{ Save Simplex iterations in a file }

{ ------------------------------------------------------------------
  Nonlinear equations
  ------------------------------------------------------------------ }

procedure RootBrack(Func             : TFunc;
                    var X, Y, FX, FY : Float); external 'dmath';
{ Brackets a root of function Func between X and Y }

procedure Bisect(Func     : TFunc;
                 var X, Y : Float;
                 MaxIter  : Integer;
                 Tol      : Float;
                 var F    : Float); external 'dmath';
{ Bisection method }

procedure Secant(Func     : TFunc;
                 var X, Y : Float;
                 MaxIter  : Integer;
                 Tol      : Float;
                 var F    : Float); external 'dmath';
{ Secant method }

procedure NewtEq(Func, Deriv : TFunc;
                 var X       : Float;
                 MaxIter     : Integer;
                 Tol         : Float;
                 var F       : Float); external 'dmath';
{ Newton-Raphson method for a single nonlinear equation }

procedure NewtEqs(Equations : TEquations;
                  Jacobian  : TJacobian;
                  X, F      : TVector;
                  Lb, Ub    : Integer;
                  MaxIter   : Integer;
                  Tol       : Float); external 'dmath';
{ Newton-Raphson method for a system of nonlinear equations }

procedure Broyden(Equations : TEquations;
                  X, F      : TVector;
                  Lb, Ub    : Integer;
                  MaxIter   : Integer;
                  Tol       : Float); external 'dmath';
{ Broyden's method for a system of nonlinear equations }

{ ------------------------------------------------------------------
  Polynomials and rational fractions
  ------------------------------------------------------------------ }

function Poly(X    : Float;
              Coef : TVector;
              Deg  : Integer) : Float; external 'dmath';
{ Evaluates a polynomial }

function RFrac(X          : Float;
               Coef       : TVector;
               Deg1, Deg2 : Integer) : Float; external 'dmath';
{ Evaluates a rational fraction }

function RootPol1(A, B  : Float;
                  var X : Float) : Integer; external 'dmath';
{ Solves the linear equation A + B * X = 0 }

function RootPol2(Coef : TVector;
                  Z    : TCompVector) : Integer; external 'dmath';
{ Solves a quadratic equation }

function RootPol3(Coef : TVector;
                  Z    : TCompVector) : Integer; external 'dmath';
{ Solves a cubic equation }

function RootPol4(Coef : TVector;
                  Z    : TCompVector) : Integer; external 'dmath';
{ Solves a quartic equation }

function RootPol(Coef : TVector;
                 Deg  : Integer;
                 Z    : TCompVector) : Integer; external 'dmath';
{ Solves a polynomial equation }

function SetRealRoots(Deg : Integer;
                      Z   : TCompVector;
                      Tol : Float) : Integer; external 'dmath';
{ Set the imaginary part of a root to zero }

procedure SortRoots(Deg : Integer;
                    Z   : TCompVector); external 'dmath';
{ Sorts the roots of a polynomial }

{ ------------------------------------------------------------------
  Numerical integration and differential equations
  ------------------------------------------------------------------ }

function TrapInt(X, Y : TVector; N : Integer) : Float; external 'dmath';
{ Integration by trapezoidal rule }

function GausLeg(Func : TFunc; A, B : Float) : Float; external 'dmath';
{ Integral from A to B }

function GausLeg0(Func : TFunc; B : Float) : Float; external 'dmath';
{ Integral from 0 to B }

function Convol(Func1, Func2 : TFunc; T : Float) : Float; external 'dmath';
{ Convolution product at time T }

procedure ConvTrap(Func1, Func2 : TFunc; T, Y : TVector; N : Integer); external 'dmath';
{ Convolution by trapezoidal rule }

procedure RKF45(F                    : TDiffEqs;
                Neqn                 : Integer;
                Y, Yp                : TVector;
                var T                : Float;
                Tout, RelErr, AbsErr : Float;
                var Flag             : Integer); external 'dmath';
{ Integration of a system of differential equations }

{ ------------------------------------------------------------------
  Fast Fourier Transform
  ------------------------------------------------------------------ }

procedure FFT(NumSamples        : Integer;
              InArray, OutArray : TCompVector); external 'dmath';
{ Fast Fourier Transform }

procedure IFFT(NumSamples        : Integer;
               InArray, OutArray : TCompVector); external 'dmath';
{ Inverse Fast Fourier Transform }

procedure FFT_Integer(NumSamples     : Integer;
                      RealIn, ImagIn : TIntVector;
                      OutArray       : TCompVector); external 'dmath';
{ Fast Fourier Transform for integer data }

procedure FFT_Integer_Cleanup; external 'dmath';
{ Clear memory after a call to FFT_Integer }

procedure CalcFrequency(NumSamples,
                        FrequencyIndex : Integer;
                        InArray        : TCompVector;
                        var FFT        : Complex); external 'dmath';
{ Direct computation of Fourier transform }

{ ------------------------------------------------------------------
  Random numbers
  ------------------------------------------------------------------ }

procedure SetRNG(RNG : RNG_Type); external 'dmath';
{ Select generator }

procedure InitGen(Seed : RNG_IntType); external 'dmath';
{ Initialize generator }

function IRanGen : RNG_IntType; external 'dmath';
{ 32-bit random integer in [-2^31 .. 2^31 - 1] }

function IRanGen31 : RNG_IntType; external 'dmath';
{ 31-bit random integer in [0 .. 2^31 - 1] }

function RanGen1 : Float; external 'dmath';
{ 32-bit random real in [0,1] }

function RanGen2 : Float; external 'dmath';
{ 32-bit random real in [0,1) }

function RanGen3 : Float; external 'dmath';
{ 32-bit random real in (0,1) }

function RanGen53 : Float; external 'dmath';
{ 53-bit random real in [0,1) }

procedure InitMWC(Seed : RNG_IntType); external 'dmath';
{ Initializes the 'Multiply with carry' random number generator }

function IRanMWC : RNG_IntType; external 'dmath';
{ Returns a 32 bit random number in [-2^31 ; 2^31-1] }

procedure InitMT(Seed : RNG_IntType); external 'dmath';
{ Initializes Mersenne Twister generator with a seed }

procedure InitMTbyArray(InitKey   : array of RNG_LongType;
                        KeyLength : Word); external 'dmath';
{ Initialize MT generator with an array InitKey[0..(KeyLength - 1)] }

function IRanMT : RNG_IntType; external 'dmath';
{ Random integer from MT generator }

procedure InitUVAGbyString(KeyPhrase : string); external 'dmath';
{ Initializes the UVAG generator with a string }

procedure InitUVAG(Seed : RNG_IntType); external 'dmath';
{ Initializes the UVAG generator with an integer }

function IRanUVAG : RNG_IntType; external 'dmath';
{ Random integer from UVAG generator }

function RanGaussStd : Float; external 'dmath';
{ Random number from standard normal distribution }

function RanGauss(Mu, Sigma : Float) : Float; external 'dmath';
{ Random number from normal distrib. with mean Mu and S. D. Sigma }

procedure RanMult(M      : TVector;
                  L      : TMatrix;
                  Lb, Ub : Integer;
                  X      : TVector); external 'dmath';
{ Random vector from multinormal distribution (correlated) }

procedure RanMultIndep(M, S   : TVector;
                       Lb, Ub : Integer;
                       X      : TVector); external 'dmath';
{ Random vector from multinormal distribution (uncorrelated) }

procedure InitMHParams(NCycles, MaxSim, SavedSim : Integer); external 'dmath';
{ Initializes Metropolis-Hastings parameters }

procedure GetMHParams(var NCycles, MaxSim, SavedSim : Integer); external 'dmath';
{ Returns Metropolis-Hastings parameters }

procedure Hastings(Func      : TFuncNVar;
                   T         : Float;
                   X         : TVector;
                   V         : TMatrix;
                   Lb, Ub    : Integer;
                   Xmat      : TMatrix;
                   X_min     : TVector;
                   var F_min : Float); external 'dmath';
{ Simulation of a probability density function by Metropolis-Hastings }

procedure InitSAParams(NT, NS, NCycles : Integer; RT : Float); external 'dmath';
{ Initializes Simulated Annealing parameters }

procedure SA_CreateLogFile(FileName : String); external 'dmath';
{ Initializes log file }

procedure SimAnn(Func          : TFuncNVar;
                 X, Xmin, Xmax : TVector;
                 Lb, Ub        : Integer;
                 var F_min     : Float); external 'dmath';
{ Minimization of a function of several var. by simulated annealing }

procedure InitGAParams(NP, NG : Integer; SR, MR, HR : Float); external 'dmath';
{ Initializes Genetic Algorithm parameters }

procedure GA_CreateLogFile(FileName : String); external 'dmath';
{ Initializes log file }

procedure GenAlg(Func          : TFuncNVar;
                 X, Xmin, Xmax : TVector;
                 Lb, Ub        : Integer;
                 var F_min     : Float); external 'dmath';
{ Minimization of a function of several var. by genetic algorithm }

{ ------------------------------------------------------------------
  Statistics
  ------------------------------------------------------------------ }

function Mean(X : TVector; Lb, Ub : Integer) : Float; external 'dmath';
{ Mean of sample X }

function Min(X : TVector; Lb, Ub : Integer) : Float; external 'dmath';
{ Minimum of sample X }

function Max(X : TVector; Lb, Ub : Integer) : Float; external 'dmath';
{ Maximum of sample X }

function Median(X : TVector; Lb, Ub : Integer; Sorted : Boolean) : Float; external 'dmath';
{ Median of sample X }

function StDev(X : TVector; Lb, Ub : Integer; M : Float) : Float; external 'dmath';
{ Standard deviation estimated from sample X }

function StDevP(X : TVector; Lb, Ub : Integer; M : Float) : Float; external 'dmath';
{ Standard deviation of population }

function Correl(X, Y : TVector; Lb, Ub : Integer) : Float; external 'dmath';
{ Correlation coefficient }

function Skewness(X : TVector; Lb, Ub : Integer; M, Sigma : Float) : Float; external 'dmath';
{ Skewness of sample X }

function Kurtosis(X : TVector; Lb, Ub : Integer; M, Sigma : Float) : Float; external 'dmath';
{ Kurtosis of sample X }

procedure QSort(X : TVector; Lb, Ub : Integer); external 'dmath';
{ Quick sort (ascending order) }

procedure DQSort(X : TVector; Lb, Ub : Integer); external 'dmath';
{ Quick sort (descending order) }

procedure Interval(X1, X2             : Float;
                   MinDiv, MaxDiv     : Integer;
                   var Min, Max, Step : Float); external 'dmath';
{ Determines an interval for a set of values }

procedure AutoScale(X : TVector; Lb, Ub : Integer; Scale : TScale;
                    var XMin, XMax, XStep : Float); external 'dmath';
{ Finds an appropriate scale for plotting the data in X[Lb..Ub] }

procedure StudIndep(N1, N2         : Integer;
                    M1, M2, S1, S2 : Float;
                    var T          : Float;
                    var DoF        : Integer); external 'dmath';
{ Student t-test for independent samples }

procedure StudPaired(X, Y    : TVector;
                     Lb, Ub  : Integer;
                     var T   : Float;
                     var DoF : Integer); external 'dmath';
{ Student t-test for paired samples }

procedure AnOVa1(Ns               : Integer;
                 N                : TIntVector;
                 M, S             : TVector;
                 var V_f, V_r, F  : Float;
                 var DoF_f, DoF_r : Integer); external 'dmath';
{ One-way analysis of variance }

procedure AnOVa2(NA, NB, Nobs : Integer;
                 M, S         : TMatrix;
                 V, F         : TVector;
                 DoF          : TIntVector); external 'dmath';
{ Two-way analysis of variance }

procedure Snedecor(N1, N2         : Integer;
                   S1, S2         : Float;
                   var F          : Float;
                   var DoF1, DoF2 : Integer); external 'dmath';
{ Snedecor's F-test (comparison of two variances) }

procedure Bartlett(Ns       : Integer;
                   N        : TIntVector;
                   S        : TVector;
                   var Khi2 : Float;
                   var DoF  : Integer); external 'dmath';
{ Bartlett's test (comparison of several variances) }

procedure Mann_Whitney(N1, N2     : Integer;
                       X1, X2     : TVector;
                       var U, Eps : Float); external 'dmath';
{ Mann-Whitney test}

procedure Wilcoxon(X, Y       : TVector;
                   Lb, Ub     : Integer;
                   var Ndiff  : Integer;
                   var T, Eps : Float); external 'dmath';
{ Wilcoxon test }

procedure Kruskal_Wallis(Ns      : Integer;
                         N       : TIntVector;
                         X       : TMatrix;
                         var H   : Float;
                         var DoF : Integer); external 'dmath';
{ Kruskal-Wallis test }

procedure Khi2_Conform(N_cls    : Integer;
                       N_estim  : Integer;
                       Obs      : TIntVector;
                       Calc     : TVector;
                       var Khi2 : Float;
                       var DoF  : Integer); external 'dmath';
{ Khi-2 test for conformity }

procedure Khi2_Indep(N_lin    : Integer;
                     N_col    : Integer;
                     Obs      : TIntMatrix;
                     var Khi2 : Float;
                     var DoF  : Integer); external 'dmath';
{ Khi-2 test for independence }

procedure Woolf_Conform(N_cls   : Integer;
                        N_estim : Integer;
                        Obs     : TIntVector;
                        Calc    : TVector;
                        var G   : Float;
                        var DoF : Integer); external 'dmath';
{ Woolf's test for conformity }

procedure Woolf_Indep(N_lin   : Integer;
                      N_col   : Integer;
                      Obs     : TIntMatrix;
                      var G   : Float;
                      var DoF : Integer); external 'dmath';
{ Woolf's test for independence }

procedure DimStatClassVector(var C : TStatClassVector; 
                             Ub    : Integer); external 'dmath'; 
{ Allocates an array of statistical classes: C[0..Ub] }

procedure Distrib(X       : TVector;
                  Lb, Ub  : Integer;
                  A, B, H : Float;
                  C       : TStatClassVector); external 'dmath';
{ Distributes an array X[Lb..Ub] into statistical classes }

{ ------------------------------------------------------------------
  Linear / polynomial regression
  ------------------------------------------------------------------ }

procedure LinFit(X, Y   : TVector;
                 Lb, Ub : Integer;
                 B      : TVector;
                 V      : TMatrix); external 'dmath';
{ Linear regression : Y = B(0) + B(1) * X }

procedure WLinFit(X, Y, S : TVector;
                  Lb, Ub  : Integer;
                  B       : TVector;
                  V       : TMatrix); external 'dmath';
{ Weighted linear regression : Y = B(0) + B(1) * X }

procedure SVDLinFit(X, Y   : TVector;
                    Lb, Ub : Integer;
                    SVDTol : Float;
                    B      : TVector;
                    V      : TMatrix); external 'dmath';
{ Unweighted linear regression by singular value decomposition }

procedure WSVDLinFit(X, Y, S : TVector;
                     Lb, Ub  : Integer;
                     SVDTol  : Float;
                     B       : TVector;
                     V       : TMatrix); external 'dmath';
{ Weighted linear regression by singular value decomposition }

procedure MulFit(X            : TMatrix;
                 Y            : TVector;
                 Lb, Ub, Nvar : Integer;
                 ConsTerm     : Boolean;
                 B            : TVector;
                 V            : TMatrix); external 'dmath';
{ Multiple linear regression by Gauss-Jordan method }

procedure WMulFit(X            : TMatrix;
                  Y, S         : TVector;
                  Lb, Ub, Nvar : Integer;
                  ConsTerm     : Boolean;
                  B            : TVector;
                  V            : TMatrix); external 'dmath';
{ Weighted multiple linear regression by Gauss-Jordan method }

procedure SVDFit(X            : TMatrix;
                 Y            : TVector;
                 Lb, Ub, Nvar : Integer;
                 ConsTerm     : Boolean;
                 SVDTol       : Float;
                 B            : TVector;
                 V            : TMatrix); external 'dmath';
{ Multiple linear regression by singular value decomposition }

procedure WSVDFit(X            : TMatrix;
                  Y, S         : TVector;
                  Lb, Ub, Nvar : Integer;
                  ConsTerm     : Boolean;
                  SVDTol       : Float;
                  B            : TVector;
                  V            : TMatrix); external 'dmath';
{ Weighted multiple linear regression by singular value decomposition }

procedure PolFit(X, Y        : TVector;
                 Lb, Ub, Deg : Integer;
                 B           : TVector;
                 V           : TMatrix); external 'dmath';
{ Polynomial regression by Gauss-Jordan method }

procedure WPolFit(X, Y, S     : TVector;
                  Lb, Ub, Deg : Integer;
                  B           : TVector;
                  V           : TMatrix); external 'dmath';
{ Weighted polynomial regression by Gauss-Jordan method }

procedure SVDPolFit(X, Y        : TVector;
                    Lb, Ub, Deg : Integer;
                    SVDTol      : Float;
                    B           : TVector;
                    V           : TMatrix); external 'dmath';
{ Unweighted polynomial regression by singular value decomposition }

procedure WSVDPolFit(X, Y, S     : TVector;
                     Lb, Ub, Deg : Integer;
                     SVDTol      : Float;
                     B           : TVector;
                     V           : TMatrix); external 'dmath';
{ Weighted polynomial regression by singular value decomposition }

procedure RegTest(Y, Ycalc : TVector;
                  LbY, UbY : Integer;
                  V        : TMatrix;
                  LbV, UbV : Integer;
                  var Test : TRegTest); external 'dmath';
{ Test of unweighted regression }

procedure WRegTest(Y, Ycalc, S : TVector;
                   LbY, UbY    : Integer;
                   V           : TMatrix;
                   LbV, UbV    : Integer;
                   var Test    : TRegTest); external 'dmath';
{ Test of weighted regression }

{ ------------------------------------------------------------------
  Nonlinear regression
  ------------------------------------------------------------------ }

procedure SetOptAlgo(Algo : TOptAlgo); external 'dmath';
{ Sets the optimization algorithm for nonlinear regression }

function GetOptAlgo : TOptAlgo; external 'dmath';
{ Returns the optimization algorithm }

procedure SetMaxParam(N : Byte); external 'dmath';
{ Sets the maximum number of regression parameters for nonlinear regression }

function GetMaxParam : Byte; external 'dmath';
{ Returns the maximum number of regression parameters for nonlinear regression }

procedure SetParamBounds(I : Byte; ParamMin, ParamMax : Float); external 'dmath';
{ Sets the bounds on the I-th regression parameter }

procedure GetParamBounds(I : Byte; var ParamMin, ParamMax : Float); external 'dmath';
{ Returns the bounds on the I-th regression parameter }

procedure NLFit(RegFunc   : TRegFunc;
                DerivProc : TDerivProc;
                X, Y      : TVector;
                Lb, Ub    : Integer;
                MaxIter   : Integer;
                Tol       : Float;
                B         : TVector;
                FirstPar,
                LastPar   : Integer;
                V         : TMatrix); external 'dmath';
{ Unweighted nonlinear regression }

procedure WNLFit(RegFunc   : TRegFunc;
                 DerivProc : TDerivProc;
                 X, Y, S   : TVector;
                 Lb, Ub    : Integer;
                 MaxIter   : Integer;
                 Tol       : Float;
                 B         : TVector;
                 FirstPar,
                 LastPar   : Integer;
                 V         : TMatrix); external 'dmath';
{ Weighted nonlinear regression }

procedure SetMCFile(FileName : String); external 'dmath';
{ Set file for saving MCMC simulations }

procedure SimFit(RegFunc   : TRegFunc;
                 X, Y      : TVector;
                 Lb, Ub    : Integer;
                 B         : TVector;
                 FirstPar,
                 LastPar   : Integer;
                 V         : TMatrix); external 'dmath';
{ Simulation of unweighted nonlinear regression by MCMC }

procedure WSimFit(RegFunc   : TRegFunc;
                  X, Y, S   : TVector;
                  Lb, Ub    : Integer;
                  B         : TVector;
                  FirstPar,
                  LastPar   : Integer;
                  V         : TMatrix); external 'dmath';
{ Simulation of weighted nonlinear regression by MCMC }

{ ------------------------------------------------------------------
  Nonlinear regression models
  ------------------------------------------------------------------ }

procedure FracFit(X, Y       : TVector;
                  Lb, Ub     : Integer;
                  Deg1, Deg2 : Integer;
                  ConsTerm   : Boolean;
                  MaxIter    : Integer;
                  Tol        : Float;
                  B          : TVector;
                  V          : TMatrix); external 'dmath';
{ Unweighted fit of rational fraction }

procedure WFracFit(X, Y, S    : TVector;
                   Lb, Ub     : Integer;
                   Deg1, Deg2 : Integer;
                   ConsTerm   : Boolean;
                   MaxIter    : Integer;
                   Tol        : Float;
                   B          : TVector;
                   V          : TMatrix); external 'dmath';
{ Weighted fit of rational fraction }

function FracFit_Func(X : Float; B : TVector) : Float; external 'dmath';
{ Returns the value of the rational fraction at point X }

procedure ExpFit(X, Y         : TVector;
                 Lb, Ub, Nexp : Integer;
                 ConsTerm     : Boolean;
                 MaxIter      : Integer;
                 Tol          : Float;
                 B            : TVector;
                 V            : TMatrix); external 'dmath';
{ Unweighted fit of sum of exponentials }

procedure WExpFit(X, Y, S      : TVector;
                  Lb, Ub, Nexp : Integer;
                  ConsTerm     : Boolean;
                  MaxIter      : Integer;
                  Tol          : Float;
                  B            : TVector;
                  V            : TMatrix); external 'dmath';
{ Weighted fit of sum of exponentials }

function ExpFit_Func(X : Float; B : TVector) : Float; external 'dmath';
{ Returns the value of the regression function at point X }

procedure IncExpFit(X, Y     : TVector;
                    Lb, Ub   : Integer;
                    ConsTerm : Boolean;
                    MaxIter  : Integer;
                    Tol      : Float;
                    B        : TVector;
                    V        : TMatrix); external 'dmath';
{ Unweighted fit of model of increasing exponential }

procedure WIncExpFit(X, Y, S  : TVector;
                     Lb, Ub   : Integer;
                     ConsTerm : Boolean;
                     MaxIter  : Integer;
                     Tol      : Float;
                     B        : TVector;
                     V        : TMatrix); external 'dmath';
{ Weighted fit of increasing exponential }

function IncExpFit_Func(X : Float; B : TVector) : Float; external 'dmath';
{ Returns the value of the regression function at point X }

procedure ExpLinFit(X, Y    : TVector;
                    Lb, Ub  : Integer;
                    MaxIter : Integer;
                    Tol     : Float;
                    B       : TVector;
                    V       : TMatrix); external 'dmath';
{ Unweighted fit of the "exponential + linear" model }

procedure WExpLinFit(X, Y, S : TVector;
                     Lb, Ub  : Integer;
                     MaxIter : Integer;
                     Tol     : Float;
                     B       : TVector;
                     V       : TMatrix); external 'dmath';
{ Weighted fit of the "exponential + linear" model }

function ExpLinFit_Func(X : Float; B : TVector) : Float; external 'dmath';
{ Returns the value of the regression function at point X }

procedure MichFit(X, Y    : TVector;
                  Lb, Ub  : Integer;
                  MaxIter : Integer;
                  Tol     : Float;
                  B       : TVector;
                  V       : TMatrix); external 'dmath';
{ Unweighted fit of Michaelis equation }

procedure WMichFit(X, Y, S : TVector;
                   Lb, Ub  : Integer;
                   MaxIter : Integer;
                   Tol     : Float;
                   B       : TVector;
                   V       : TMatrix); external 'dmath';
{ Weighted fit of Michaelis equation }

function MichFit_Func(X : Float; B : TVector) : Float; external 'dmath';
{ Returns the value of the Michaelis equation at point X }

procedure MintFit(X, Y    : TVector;
                  Lb, Ub  : Integer;
                  MintVar : TMintVar;
                  Fit_S0  : Boolean;
                  MaxIter : Integer;
                  Tol     : Float;
                  B       : TVector;
                  V       : TMatrix); external 'dmath';
{ Unweighted fit of the integrated Michaelis equation }

procedure WMintFit(X, Y, S : TVector;
                   Lb, Ub  : Integer;
                   MintVar : TMintVar;
                   Fit_S0  : Boolean;
                   MaxIter : Integer;
                   Tol     : Float;
                   B       : TVector;
                   V       : TMatrix); external 'dmath';
{ Weighted fit of the integrated Michaelis equation }

function MintFit_Func(X : Float; B : TVector) : Float; external 'dmath';
{ Returns the value of the integrated Michaelis equation at point X }

procedure HillFit(X, Y    : TVector;
                  Lb, Ub  : Integer;
                  MaxIter : Integer;
                  Tol     : Float;
                  B       : TVector;
                  V       : TMatrix); external 'dmath';
{ Unweighted fit of Hill equation }

procedure WHillFit(X, Y, S : TVector;
                   Lb, Ub  : Integer;
                   MaxIter : Integer;
                   Tol     : Float;
                   B       : TVector;
                   V       : TMatrix); external 'dmath';
{ Weighted fit of Hill equation }

function HillFit_Func(X : Float; B : TVector) : Float; external 'dmath';
{ Returns the value of the Hill equation at point X }

procedure LogiFit(X, Y     : TVector;
                  Lb, Ub   : Integer;
                  ConsTerm : Boolean;
                  General  : Boolean;
                  MaxIter  : Integer;
                  Tol      : Float;
                  B        : TVector;
                  V        : TMatrix); external 'dmath';
{ Unweighted fit of logistic function }

procedure WLogiFit(X, Y, S  : TVector;
                   Lb, Ub   : Integer;
                   ConsTerm : Boolean;
                   General  : Boolean;
                   MaxIter  : Integer;
                   Tol      : Float;
                   B        : TVector;
                   V        : TMatrix); external 'dmath';
{ Weighted fit of logistic function }

function LogiFit_Func(X : Float; B : TVector) : Float; external 'dmath';
{ Returns the value of the logistic function at point X }

procedure PKFit(X, Y    : TVector;
                Lb, Ub  : Integer;
                MaxIter : Integer;
                Tol     : Float;
                B       : TVector;
                V       : TMatrix); external 'dmath';
{ Unweighted fit of the acid-base titration curve }

procedure WPKFit(X, Y, S : TVector;
                 Lb, Ub  : Integer;
                 MaxIter : Integer;
                 Tol     : Float;
                 B       : TVector;
                 V       : TMatrix); external 'dmath';
{ Weighted fit of the acid-base titration curve }

function PKFit_Func(X : Float; B : TVector) : Float; external 'dmath';
{ Returns the value of the acid-base titration function at point X }

procedure PowFit(X, Y    : TVector;
                 Lb, Ub  : Integer;
                 MaxIter : Integer;
                 Tol     : Float;
                 B       : TVector;
                 V       : TMatrix); external 'dmath';
{ Unweighted fit of power function }

procedure WPowFit(X, Y, S : TVector;
                  Lb, Ub  : Integer;
                  MaxIter : Integer;
                  Tol     : Float;
                  B       : TVector;
                  V       : TMatrix); external 'dmath';
{ Weighted fit of power function }

function PowFit_Func(X : Float; B : TVector) : Float; external 'dmath';
{ Returns the value of the power function at point X }

procedure GammaFit(X, Y    : TVector;
                   Lb, Ub  : Integer;
                   MaxIter : Integer;
                   Tol     : Float;
                   B       : TVector;
                   V       : TMatrix); external 'dmath';
{ Unweighted fit of gamma distribution function }

procedure WGammaFit(X, Y, S : TVector;
                    Lb, Ub  : Integer;
                    MaxIter : Integer;
                    Tol     : Float;
                    B       : TVector;
                    V       : TMatrix); external 'dmath';
{ Weighted fit of gamma distribution function }

function GammaFit_Func(X : Float; B : TVector) : Float; external 'dmath';
{ Returns the value of the gamma distribution function at point X }

{ ------------------------------------------------------------------
  Principal component analysis
  ------------------------------------------------------------------ }

procedure VecMean(X            : TMatrix;
                  Lb, Ub, Nvar : Integer;
                  M            : TVector); external 'dmath';
{ Computes the mean vector M from matrix X }

procedure VecSD(X            : TMatrix;
                Lb, Ub, Nvar : Integer;
                M, S         : TVector); external 'dmath';
{ Computes the vector of standard deviations S from matrix X }

procedure MatVarCov(X            : TMatrix;
                    Lb, Ub, Nvar : Integer;
                    M            : TVector;
                    V            : TMatrix); external 'dmath';
{ Computes the variance-covariance matrix V from matrix X }

procedure MatCorrel(V    : TMatrix;
                    Nvar : Integer;
                    R    : TMatrix); external 'dmath';
{ Computes the correlation matrix R from the var-cov matrix V }

procedure PCA(R      : TMatrix;
              Nvar   : Integer;
              Lambda : TVector;
              C, Rc  : TMatrix); external 'dmath';
{ Performs a principal component analysis of the correlation matrix R }

procedure ScaleVar(X            : TMatrix;
                   Lb, Ub, Nvar : Integer;
                   M, S         : TVector;
                   Z            : TMatrix); external 'dmath';
{ Scales a set of variables by subtracting means and dividing by SD's }

procedure PrinFac(Z            : TMatrix;
                  Lb, Ub, Nvar : Integer;
                  C, F         : TMatrix); external 'dmath';
{ Computes principal factors }

{ ------------------------------------------------------------------
  Strings
  ------------------------------------------------------------------ }

function LTrim(S : String) : String; external 'dmath';
{ Removes leading blanks }

function RTrim(S : String) : String; external 'dmath';
{ Removes trailing blanks }

function Trim(S : String) : String; external 'dmath';
{ Removes leading and trailing blanks }

function StrChar(N : Byte; C : Char) : String; external 'dmath';
{ Returns a string made of character C repeated N times }

function RFill(S : String; L : Byte) : String; external 'dmath';
{ Completes string S with trailing blanks for a total length L }

function LFill(S : String; L : Byte) : String; external 'dmath';
{ Completes string S with leading blanks for a total length L }

function CFill(S : String; L : Byte) : String; external 'dmath';
{ Centers string S on a total length L }

function Replace(S : String; C1, C2 : Char) : String; external 'dmath';
{ Replaces in string S all the occurences of C1 by C2 }

function Extract(S : String; var Index : Byte; Delim : Char) : String; external 'dmath';
{ Extracts a field from a string }

procedure Parse(S : String; Delim : Char; Field : TStrVector; var N : Byte); external 'dmath';
{ Parses a string into its constitutive fields }

procedure SetFormat(NumLength, MaxDec : Integer;
                    FloatPoint, NSZero : Boolean); external 'dmath';
{ Sets the numeric format }

function FloatStr(X : Float) : String; external 'dmath';
{ Converts a real to a string according to the numeric format }

function IntStr(N : LongInt) : String; external 'dmath';
{ Converts an integer to a string }

function CompStr(Z : Complex) : String; external 'dmath';
{ Converts a complex number to a string }

{$IFDEF DELPHI}

function StrDec(S : String) : String; external 'dmath';
{ Set decimal separator to the symbol defined in SysUtils }

function IsNumeric(var S : String; var X : Float) : Boolean; external 'dmath';
{ Test if a string represents a number and returns it in X }

function ReadNumFromEdit(Edit : TEdit) : Float; external 'dmath';
{ Reads a floating point number from an Edit control }

procedure WriteNumToFile(var F : Text; X : Float); external 'dmath';
{ Writes a floating point number in a text file }

{$ENDIF}

{ ------------------------------------------------------------------
  BGI / Delphi graphics
  ------------------------------------------------------------------ }

function InitGraphics
{$IFDEF DELPHI}
(Width, Height : Integer) : Boolean;
{$ELSE}
(Pilot, Mode : Integer; BGIPath : String) : Boolean;
{$ENDIF}
external 'dmath';
{ Enters graphic mode }

procedure SetWindow({$IFDEF DELPHI}Canvas : TCanvas;{$ENDIF}
                    X1, X2, Y1, Y2 : Integer; GraphBorder : Boolean);
external 'dmath';
{ Sets the graphic window }

procedure SetOxScale(Scale                : TScale;
                     OxMin, OxMax, OxStep : Float);
external 'dmath';
{ Sets the scale on the Ox axis }

procedure SetOyScale(Scale                : TScale;
                     OyMin, OyMax, OyStep : Float);
external 'dmath';
{ Sets the scale on the Oy axis }

procedure GetOxScale(var Scale                : TScale;
                     var OxMin, OxMax, OxStep : Float);
external 'dmath';
{ Returns the scale on the Ox axis }

procedure GetOyScale(var Scale                : TScale;
                     var OyMin, OyMax, OyStep : Float);
external 'dmath';
{ Returns the scale on the Oy axis }

procedure SetGraphTitle(Title : String); external 'dmath';
{ Sets the title for the graph }

procedure SetOxTitle(Title : String); external 'dmath';
{ Sets the title for the Ox axis }

procedure SetOyTitle(Title : String); external 'dmath';
{ Sets the title for the Oy axis }

function GetGraphTitle : String; external 'dmath';
{ Returns the title for the graph }

function GetOxTitle : String; external 'dmath';
{ Returns the title for the Ox axis }

function GetOyTitle : String; external 'dmath';
{ Returns the title for the Oy axis }

{$IFNDEF DELPHI}

procedure SetTitleFont(FontIndex, Width, Height : Integer);
external 'dmath';
{ Sets the font for the main graph title }

procedure SetOxFont(FontIndex, Width, Height : Integer);
external 'dmath';
{ Sets the font for the Ox axis (title and labels) }

procedure SetOyFont(FontIndex, Width, Height : Integer);
external 'dmath';
{ Sets the font for the Oy axis (title and labels) }

procedure SetLgdFont(FontIndex, Width, Height : Integer);
external 'dmath';
{ Sets the font for the legends }

procedure SetClipping(Clip : Boolean);
external 'dmath';
{ Determines whether drawings are clipped at the current viewport
  boundaries, according to the value of the Boolean parameter Clip }

{$ENDIF}

procedure PlotOxAxis{$IFDEF DELPHI}(Canvas : TCanvas){$ENDIF};
external 'dmath';
{ Plots the horizontal axis }

procedure PlotOyAxis{$IFDEF DELPHI}(Canvas : TCanvas){$ENDIF};
external 'dmath';
{ Plots the vertical axis }

procedure PlotGrid({$IFDEF DELPHI}Canvas : TCanvas;{$ENDIF} Grid : TGrid);
external 'dmath';
{ Plots a grid on the graph }

procedure WriteGraphTitle{$IFDEF DELPHI}(Canvas : TCanvas){$ENDIF};
external 'dmath';
{ Writes the title of the graph }

procedure SetMaxCurv(NCurv : Byte); external 'dmath';
{ Sets the maximum number of curves and re-initializes their parameters }

procedure SetPointParam
{$IFDEF DELPHI}
(CurvIndex, Symbol, Size : Integer; Color : TColor);
{$ELSE}
(CurvIndex, Symbol, Size, Color : Integer);
{$ENDIF}
external 'dmath';
{ Sets the point parameters for curve # CurvIndex }

procedure SetLineParam
{$IFDEF DELPHI}
(CurvIndex : Integer; Style : TPenStyle; Width : Integer; Color : TColor);
{$ELSE}
(CurvIndex, Style, Width, Color : Integer);
{$ENDIF}
external 'dmath';
{ Sets the line parameters for curve # CurvIndex }

procedure SetCurvLegend(CurvIndex : Integer; Legend : String);
external 'dmath';
{ Sets the legend for curve # CurvIndex }

procedure SetCurvStep(CurvIndex, Step : Integer);
external 'dmath';
{ Sets the step for curve # CurvIndex }

function GetMaxCurv : Byte; external 'dmath';
{ Returns the maximum number of curves }

procedure GetPointParam
{$IFDEF DELPHI}
(CurvIndex : Integer; var Symbol, Size : Integer; var Color : TColor);
{$ELSE}
(CurvIndex : Integer; var Symbol, Size, Color : Integer);
{$ENDIF}
external 'dmath';
{ Returns the point parameters for curve # CurvIndex }

procedure GetLineParam
{$IFDEF DELPHI}
(CurvIndex : Integer; var Style : TPenStyle; var Width : Integer; var Color : TColor);
{$ELSE}
(CurvIndex : Integer; var Style, Width, Color : Integer);
{$ENDIF}
external 'dmath';
{ Returns the line parameters for curve # CurvIndex }

function GetCurvLegend(CurvIndex : Integer) : String; external 'dmath';
{ Returns the legend for curve # CurvIndex }

function GetCurvStep(CurvIndex : Integer) : Integer; external 'dmath';
{ Returns the step for curve # CurvIndex }

{$IFDEF DELPHI}
procedure PlotPoint(Canvas    : TCanvas;
                    X, Y      : Float;
                    CurvIndex : Integer); external 'dmath';
{$ELSE}
procedure PlotPoint(Xp, Yp, CurvIndex : Integer); external 'dmath';
{$ENDIF}
{ Plots a point on the screen }

procedure PlotCurve({$IFDEF DELPHI}Canvas : TCanvas;{$ENDIF}
                    X, Y                  : TVector;
                    Lb, Ub, CurvIndex     : Integer);
external 'dmath';
{ Plots a curve }

procedure PlotCurveWithErrorBars({$IFDEF DELPHI}Canvas : TCanvas;{$ENDIF}
                                 X, Y, S               : TVector;
                                 Ns, Lb, Ub, CurvIndex : Integer);
external 'dmath';
{ Plots a curve with error bars }

procedure PlotFunc({$IFDEF DELPHI}Canvas : TCanvas;{$ENDIF}
                   Func                  : TFunc;
                   Xmin, Xmax            : Float;
                   {$IFDEF DELPHI}Npt    : Integer;{$ENDIF}
                   CurvIndex             : Integer);
external 'dmath';
{ Plots a function }

procedure WriteLegend({$IFDEF DELPHI}Canvas : TCanvas;{$ENDIF}
                      NCurv                 : Integer;
                      ShowPoints, ShowLines : Boolean);
external 'dmath';
{ Writes the legends for the plotted curves }

procedure ConRec({$IFDEF DELPHI}Canvas : TCanvas;{$ENDIF}
                 Nx, Ny, Nc            : Integer;
                 X, Y, Z               : TVector;
                 F                     : TMatrix);
external 'dmath';
{ Contour plot }

function Xpixel(X : Float) : Integer; external 'dmath';
{ Converts user abscissa X to screen coordinate }

function Ypixel(Y : Float) : Integer; external 'dmath';
{ Converts user ordinate Y to screen coordinate }

function Xuser(X : Integer) : Float; external 'dmath';
{ Converts screen coordinate X to user abscissa }

function Yuser(Y : Integer) : Float; external 'dmath';
{ Converts screen coordinate Y to user ordinate }

{$IFNDEF DELPHI}
procedure LeaveGraphics; external 'dmath';
{ Quits graphic mode }
{$ENDIF}

{ ------------------------------------------------------------------
  LaTeX graphics
  ------------------------------------------------------------------ }

function TeX_InitGraphics(FileName          : String;
                          PgWidth, PgHeight : Integer;
                          Header            : Boolean) : Boolean; external 'dmath';
{ Initializes the LaTeX file }

procedure TeX_SetWindow(X1, X2, Y1, Y2 : Integer; GraphBorder : Boolean); external 'dmath';
{ Sets the graphic window }

procedure TeX_LeaveGraphics(Footer : Boolean); external 'dmath';
{ Close the LaTeX file }

procedure TeX_SetOxScale(Scale : TScale; OxMin, OxMax, OxStep : Float); external 'dmath';
{ Sets the scale on the Ox axis }

procedure TeX_SetOyScale(Scale : TScale; OyMin, OyMax, OyStep : Float); external 'dmath';
{ Sets the scale on the Oy axis }

procedure TeX_SetGraphTitle(Title : String); external 'dmath';
{ Sets the title for the graph }

procedure TeX_SetOxTitle(Title : String); external 'dmath';
{ Sets the title for the Ox axis }

procedure TeX_SetOyTitle(Title : String); external 'dmath';
{ Sets the title for the Oy axis }

procedure TeX_PlotOxAxis; external 'dmath';
{ Plots the horizontal axis }

procedure TeX_PlotOyAxis; external 'dmath';
{ Plots the vertical axis }

procedure TeX_PlotGrid(Grid : TGrid); external 'dmath';
{ Plots a grid on the graph }

procedure TeX_WriteGraphTitle; external 'dmath';
{ Writes the title of the graph }

procedure TeX_SetMaxCurv(NCurv : Byte); external 'dmath';
{ Sets the maximum number of curves and re-initializes their parameters }

procedure TeX_SetPointParam(CurvIndex, Symbol, Size : Integer); external 'dmath';
{ Sets the point parameters for curve # CurvIndex }

procedure TeX_SetLineParam(CurvIndex, Style : Integer;
                           Width : Float; Smooth : Boolean); external 'dmath';
{ Sets the line parameters for curve # CurvIndex }

procedure TeX_SetCurvLegend(CurvIndex : Integer; Legend : String); external 'dmath';
{ Sets the legend for curve # CurvIndex }

procedure TeX_SetCurvStep(CurvIndex, Step : Integer); external 'dmath';
{ Sets the step for curve # CurvIndex }

procedure TeX_PlotCurve(X, Y : TVector; Lb, Ub, CurvIndex : Integer); external 'dmath';
{ Plots a curve }

procedure TeX_PlotCurveWithErrorBars(X, Y, S : TVector;
                                     Ns, Lb, Ub, CurvIndex : Integer); external 'dmath';
{ Plots a curve with error bars }

procedure TeX_PlotFunc(Func : TFunc; X1, X2 : Float;
                       Npt : Integer; CurvIndex : Integer); external 'dmath';
{ Plots a function }

procedure TeX_WriteLegend(NCurv : Integer; ShowPoints, ShowLines : Boolean); external 'dmath';
{ Writes the legends for the plotted curves }

procedure TeX_ConRec(Nx, Ny, Nc : Integer;
                     X, Y, Z    : TVector;
                     F          : TMatrix); external 'dmath';
{ Contour plot }

function Xcm(X : Float) : Float; external 'dmath';
{ Converts user coordinate X to cm }

function Ycm(Y : Float) : Float; external 'dmath';
{ Converts user coordinate Y to cm }


implementation

end.

