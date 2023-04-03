{ ******************************************************************
  Correlation and principal component analysis
  ******************************************************************
  Example taken from:
  P. DAGNELIE, Analyse statistique a plusieurs variables,
  Presses Agronomiques de Gembloux, Belgique, 1982
  ****************************************************************** }
  // maxbox_starter58.pdf

program pcatest_mX4;

//uses
  //dmath;
  
  function DMathFact(N: Integer): float;
  external 'Fact@dmath.dll';

  function DPower(X, Y : Float): Float;
  external 'Power@dmath.dll';
  
  procedure VecMean(X            : TMatrix;
                  Lb, Ub, Nvar : Integer;
                  M            : TVector); external 'VecMean@dmath.dll';
{ Computes the mean vector M from matrix X }

  procedure MatVarCov(X            : TMatrix;
                    Lb, Ub, Nvar : Integer;
                    M            : TVector;
                    V            : TMatrix); external 'MatVarCov@dmath.dll';
 { Computes the variance-covariance matrix V from matrix X }
 
  procedure MatCorrel(V    : TMatrix;
                    Nvar : Integer;
                    R    : TMatrix); external 'MatCorrel@dmath.dll';
{ Computes the correlation matrix R from the var-cov matrix V }

  procedure VecSD(X            : TMatrix;
                Lb, Ub, Nvar : Integer;
                M, S         : TVector); external 'VecSD@dmath.dll';
{ Computes the vector of standard deviations S from matrix X }

 

   procedure ScaleVar(X            : TMatrix;
                   Lb, Ub, Nvar : Integer;
                   M, S         : TVector;
                   Z            : TMatrix); external 'ScaleVar@dmath.dll';
{ Scales a set of variables by subtracting means and dividing by SD's }

   procedure PCA(R      : TMatrix;
              Nvar   : Integer;
              Lambda : TVector;
              C, Rc  : TMatrix); external 'PCA@dmath.dll';
{ Performs a principal component analysis of the correlation matrix R }

   procedure PrinFac(Z            : TMatrix;
                  Lb, Ub, Nvar : Integer;
                  C, F         : TMatrix); external 'PrinFac@dmath.dll';
{ Computes principal factors }


Const
  N    = 11;  { Number of observations }
  Nvar = 4;   { Number of variables }

{ Data }
var X : array[1..N] of array[1..Nvar] of Float;
{ =
(( 87.9, 19.6,   1  , 1661),
 ( 89.9, 15.2,  90.1,  968),
 (153  , 19.7,  56.6, 1353),
 (132.1, 17  ,  91  , 1293),
 ( 88.8, 18.3,  93.7, 1153),
 (220.9, 17.8, 106.9, 1286),
 (117.7, 17.8,  65.5, 1104),
 (109  , 18.3,  41.8, 1574),
 (156.1, 17.8,  57.4, 1222),
 (181.5, 16.8, 140.6,  902),
 (181.4, 17  ,  74.3, 1150)); }

var
  XX     : TMatrix;  { Data }
  M      : TVector;  { Mean vector }
  V      : TMatrix;  { Variance-covariance matrix }
  R      : TMatrix;  { Correlation matrix }
  S      : TVector;  { Standard deviations }
  Lambda : TVector;  { Eigenvalues of correlation matrix }
  C      : TMatrix;  { Eigenvectors of correlation matrix }
  Rc     : TMatrix;  { Correlation factors/variables }
  Z      : TMatrix;  { Scaled variables }
  F      : TMatrix;  { Principal factors }
  I, J   : Integer;  { Loop variables }
  
procedure setupMData;
begin
  X[1][1]:=87.9;     X[1] [2]:=19.6   X[1] [3]:=1     X[1] [4]:=1661;
  X[2][1]:=89.9;     X[2] [2]:=15.2   X[2] [3]:=90.1  X[2] [4]:=968;
  X[3][1]:=153 ;     X[3] [2]:=19.7   X[3] [3]:=56.6  X[3] [4]:=1353;
  X[4][1]:=132.1;    X[4] [2]:=17     X[4] [3]:=91    X[4] [4]:=1293;
  X[5][1]:=88.8;     X[5] [2]:=18.3   X[5] [3]:=93.7  X[5] [4]:=1153;
  X[6][1]:=220.9;    X[6] [2]:=17.8   X[6] [3]:=106.9 X[6] [4]:=1286;
  X[7][1]:=117.7;    X[7] [2]:=17.8   X[7] [3]:=65.5  X[7] [4]:=1104;
  X[8][1]:=109;      X[8] [2]:=18.3   X[8] [3]:=41.8  X[8] [4]:=1574;
  X[9][1]:=156.1;    X[9] [2]:=17.8   X[9] [3]:=57.4  X[9] [4]:=1222;
  X[10][1]:=181.5;   X[10][2]:=16.8   X[10][3]:=140.6 X[10][4]:=902;
  X[11][1]:=181.4;   X[11][2]:=17     X[11][3]:=74.3  X[11][4]:=1150;
end;  
  

procedure PrintMatrix(Title : String; A : TMatrix; Ub1, Ub2 : Integer);
{ ------------------------------------------------------------------
  Print matrix A[1..Ub1, 1..Ub2]
  ------------------------------------------------------------------ }
var
  I, J : Integer;
begin
  Writeln(''); Writeln(Title); Writeln('');

  for I := 1 to Ub1 do
    begin
      for J := 1 to Ub2 do
        //Write(A[I,J]:12:4);
        //Write(floattostr(A[I][J])+#9#9);
        Write(Format('%12.4f ',[A[I][J]]));
      Writeln('');
    end;
end;

procedure PrintVector(Title : String; B : TVector; Ub : Integer);
{ ------------------------------------------------------------------
  Print vector B[1..Ub]
  ------------------------------------------------------------------ }
var
  I : Integer;
begin
  Writeln(''); Writeln(Title); Writeln('');
  for I := 1 to Ub do
    Writeln(floattostr(B[I]));
end;

begin

  setupMData();
  
  DimMatrix(XX, N, Nvar);
  DimVector(M, Nvar);
  DimMatrix(V, Nvar, Nvar);
  DimMatrix(R, Nvar, Nvar);
  DimVector(S, Nvar);
  DimVector(Lambda, Nvar);
  DimMatrix(C, Nvar, Nvar);
  DimMatrix(Rc, Nvar, Nvar);
  DimMatrix(Z, N, Nvar);
  DimMatrix(F, N, Nvar);

  { Read data }
  for I := 1 to N do
    for J := 1 to Nvar do
      XX[I][J] := X[I][J];

  { Compute mean vector }
  VecMean(XX, 1, N, Nvar, M);

  { Compute variance-covariance matrix }
  MatVarCov(XX, 1, N, Nvar, M, V);

  { Compute correlation matrix }
  MatCorrel(V, Nvar, R);

  { Display results }
  Writeln('');
  PrintVector('Mean vector', M, Nvar);
  PrintMatrix('Variance-covariance matrix', V, Nvar, Nvar);
  PrintMatrix('Correlation matrix', R, Nvar, Nvar);

  { Compute standard deviations }
  VecSD(XX, 1, N, Nvar, M, S);

  { Scale variables }
  ScaleVar(XX, 1, N, Nvar, M, S, Z);

  { Perform principal component analysis
    The original matrix R is destroyed }
  PCA(R, Nvar, Lambda, C, Rc);

  if MathErr = MatNonConv then
    begin
      Writeln('Non-convergence of eigenvalue computation');
      Exit;
    end;

  { Compute principal factors }
  PrinFac(Z, 1, N, Nvar, C, F);

  { Display results }
  Writeln('');
  PrintVector('Eigenvalues of correlation matrix:', Lambda, Nvar);
  PrintMatrix('Eigenvectors (columns) of correlation matrix:', C, Nvar, Nvar);
  PrintMatrix('Correlations between factors (columns) and variables (lines):',
                      Rc, Nvar, Nvar);
  PrintMatrix('Principal factors:', F, N, Nvar);
  Writeln('')
  if DMathFact(10) > 10 then begin writeln('dmath.dll loaded') 
      writeln(floattostr(DMathFact(10)))
  end
  else
     showmessageBig('please copy dmath.dll at root');
  
  
 (* voice('(( 87.9, 19.6,   1  , 1661),'+
 '( 89.9, 15.2,  90.1,  968),'+
 '(153  , 19.7,  56.6, 1353),'+
 '(132.1, 17  ,  91  , 1293),'+
 '( 88.8, 18.3,  93.7, 1153),'+
 '(220.9, 17.8, 106.9, 1286),'+
 '(117.7, 17.8,  65.5, 1104),'+
 '(109  , 18.3,  41.8, 1574),'+
 '(156.1, 17.8,  57.4, 1222),'+
 '(181.5, 16.8, 140.6,  902),'+
 '(181.4, 17,  74.3, 1150)); }'); *)
 
  print(itoa(ord('')))
  print((chr(15)))
  
  
End.

Doc:

15.2 Principal component analysis
15.2.1 Theory 

The goal of Principal Component Analysis (PCA) is to replace a set of m
variables x1; x2;    xm, which may be correlated, by another set f1; f2;    fm,
called the principal components or principal factors. These factors are inde-
pendent (uncorrelated) variables.
Usually, the algorithm starts with the correlation matrix R which is a
mm symmetric matrix such that Rij is the correlation coecient between
variable xi and variable xj .
The eigenvalues 1; 2;    m (in decreasing order) of matrix R are the
variances of the principal factors. Their sum
Pp
i=1 i is equal to m. So, the
percentage of variance associated with the i-th factor is equal to i=m.


15.2.2 Programming
The following subroutines are available:
 VecMean(X, Lb, Ub, Nvar, M) computes the mean vector M[1..Nvar]
from matrix X[Lb..Ub, 1..Nvar].
 VecSD(X, Lb, Ub, Nvar, M, S) computes the standard deviations S[1..Nvar]
from matrix X and mean vector M.
 ScaleVar(X, Lb, Ub, Nvar, M, S, Z) computes the scaled variables
Z[Lb..Ub, 1..Nvar] from the original variables X, the means M and
the standard deviations S.
 MatVarCov(X, Lb, Ub, Nvar, M, V) computes the variance-covariance
matrix V[1..Nvar, 1..Nvar] from matrix X and mean vector M.
 MatCorrel(V, Nvar, R) computes the correlation matrix R[1..Nvar,
1..Nvar] from the variance-covariance matrix V.
 PCA(R, Nvar, MaxIter, Tol, Lambda, C, Rc) performs the princi-
pal component analysis of the correlation matrix R, which is destroyed.
MaxIter and Tol are the maximum number of iterations and the re-
quested tolerance for the Jacobi method (see paragraph 6.9.2). The
eigenvalues are returned in vector Lambda[1..Nvar], the eigenvec-
tors in the columns of matrix C[1..Nvar, 1..Nvar]. The matrix
Rc[1..Nvar, 1..Nvar] contains the correlation coecients (loadings)
between the original variables (rows) and the principal factors (columns).
 PrinFac(Z, Lb, Ub, Nvar, C, F) computes the principal factors (scores)
F[Lb..Ub, 1..Nvar] from the scaled variables Z and the matrix of
eigenvectors C.
After a call to these procedures, function MathErr returns one of the
following error codes:
 MatOk if no error occurred
 MatErrDim if the array dimensions do not match
 MatNonConv if the iterative procedure (Jacobi method) did not converge
in subroutine PCA 126
