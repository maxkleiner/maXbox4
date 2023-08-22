unit U_FFT;



{----------------------------------------------------------------------------}
{-                                                                          -}
{-     Turbo Pascal Numerical Methods Toolbox                               -}
{-     Copyright (c) 1986, 87 by Borland International, Inc.                -}
{-                                                                          -}
{-  This unit provides procedures for performing real and complex fast      -}
{-  fourier transforms. Radix-2 8087 version                                -}
{-                                                                          -}
{-  Adapted to use dynamic arrays by Gary Darby, http://delphiforfun.org    -}
{-                                                                          -}
{----------------------------------------------------------------------------}


interface

(*
const
  TNArraySize = 1023;
*)

type
  Float       = double;
  TNvector2    = array {[0..TNArraySize] }of double;

  TNvectorPtr2 = ^TNvector2;




procedure RealFFT2(NumPoints : integer;
                  Inverse   : boolean;
              var XReal     : TNVectorPtr2;
              var XImag     : TNVectorPtr2;
              var Error     : byte);


{---------------------------------------------------------------------------}
{-                                                                         -}
{-    Input: NumPoints, Inverse, XReal, XImag,                             -}
{-    Output: XReal, XImag, Error                                          -}
{-                                                                         -}
{-    Purpose:  This procedure uses the complex Fourier transform          -}
{-              routine (FFT) to transform real data.  The real data       -}
{-              is in the vector XReal.  Appropriate shuffling of indices  -}
{-              changes the real vector into two vectors (representing     -}
{-              complex data) which are only half the size of the original -}
{-              vector.  Appropriate unshuffling at the end produces the   -}
{-              transform of the real data.                                -}
{-                                                                         -}
{-  User Defined Types:                                                    -}
{-         TNVector2 = array[0..TNArraySize] of real                        -}
{-      TNVectorPtr2 = ^TNVector2                                            -}
{-                                                                         -}
{- Global Variables:  NumPoints   : integer     Number of data             -}
{-                                              points in X                -}
{-                    Inverse     : boolean     False => forward transform -}
{-                                              True ==> inverse transform -}
{-                    XReal,XImag : TNVectorPtr2 Data points                -}
{-                    Error       : byte        Indicates an error         -}
{-                                                                         -}
{-             Errors:  0: No Errors                                       -}
{-                      1: NumPoints < 2                                   -}
{-                      2: NumPoints not a power of two                    -}
{-                         (or 4 for radix-4 transforms)                   -}
{-                                                                         -}
{---------------------------------------------------------------------------}



{************** ComplexFFT **************}
procedure ComplexFFT2(NumPoints : integer;
                     Inverse   : boolean;
                 var XReal     : TNVectorPtr2;
                 var XImag     : TNVectorPtr2;
                 var Error     : byte);

{-------------------------------------------------------------------}
{-                                                                 -}
{-   Input: NumPoints, Inverse, XReal, XImag                       -}
{-   Output: XReal, XImag, Error                                   -}
{-                                                                 -}
{-   Purpose: This procedure performs a fast Fourier transform     -}
{-            of the complex data XReal, XImag. The vectors XReal  -}
{-            and XImag are transformed in place.                  -}
{-                                                                 -}
{- User Defined Types:                                             -}
{-         TNvector = array[0..TNArraySize] of real                -}
{-         TNVectorPtr2 = ^TNvector                                 -}
{-                                                                 -}
{- Global Variables:  NumPoints : integer      Number of data      -}
{-                                             points in X         -}
{-                    Inverse   : BOOLEAN      FALSE => Forward    -}
{-                                                      Transform  -}
{-                                             TRUE => Inverse     -}
{-                                                     Transform   -}
{-                    XReal,                                       -}
{-                    XImag     : TNVectorPtr2  Data points         -}
{-                    Error     : byte         Indicates an error  -}
{-                                                                 -}
{-             Errors:  0: No Errors                               -}
{-                      1: NumPoints < 2                           -}
{-                      2: NumPoints not a power of two            -}
{-                                                                 -}
{-------------------------------------------------------------------}




implementation

{************** TestInput *****************}
procedure TestInput(NumPoints    : integer;
                var NumberOfBits : byte;
                var Error        : byte);

{-------------------------------------------------------------}
{- Input: NumPoints                                          -}
{- Output: NumberOfBits, Error                               -}
{-                                                           -}
{- This procedure checks the input.  If the number of points -}
{- (NumPoints) is less than two or is not a multiple of two  -}
{- then an error is returned.  NumberOfBits is the number of -}
{- bits necessary to represent NumPoints in binary (e.g. if  -}
{- NumPoints = 16, NumberOfBits = 4).                        -}
{-------------------------------------------------------------}

type
  ShortArray = array[1..13] of integer;

var
  Term : integer;

const
  PowersOfTwo : ShortArray = (2, 4, 8, 16, 32, 64, 128, 256,
                              512, 1024, 2048, 4096, 8192);

begin
  Error := 2;            { Assume NumPoints not a power of two  }
  if NumPoints < 2 then
    Error := 1;     { NumPoints < 2  }
  Term := 1;
  while (Term <= 13) and (Error = 2) do
  begin
    if NumPoints = PowersOfTwo[Term] then
    begin
      NumberOfBits := Term;
      Error := 0;  { NumPoints is a power of two  }
    end;
    Term := Succ(Term);
  end;
end; { procedure TestInput }

{************* MakeSinCosTable *************}
procedure MakeSinCosTable(NumPoints : integer;
                      var SinTable  : TNVectorPtr2;
                      var CosTable  : TNVectorPtr2);

{--------------------------------------------------------}
{- Input: NumPoints                                     -}
{- Output: SinTable, CosTable                           -}
{-                                                      -}
{- This procedure fills in a table with sin and cosine  -}
{- values.  It is faster to pull data out of this       -}
{- table than it is to calculate the sines and cosines. -}
{--------------------------------------------------------}

var
  RealFactor, ImagFactor : double;
  Term : integer;
  TermMinus1 : integer;
  UpperLimit : integer;

begin
  RealFactor :=  Cos(2 * Pi / NumPoints);
  ImagFactor := -Sqrt(1 - Sqr(RealFactor));
  CosTable^[0] := 1;
  SinTable^[0] := 0;
  CosTable^[1] := RealFactor;
  SinTable^[1] := ImagFactor;
  UpperLimit := NumPoints shr 1 - 1;
  for Term := 2 to UpperLimit do
  begin
    TermMinus1 := Term - 1;
    CosTable^[Term] :=  CosTable^[TermMinus1] * RealFactor -
                        SinTable^[TermMinus1] * ImagFactor;
    SinTable^[Term] :=  CosTable^[TermMinus1] * ImagFactor +
                        SinTable^[TermMinus1] * RealFactor;
  end;
end; { procedure MakeSinCosTable }

{**************** FFT ******************}
procedure FFT(NumberOfBits : byte;
              NumPoints    : integer;
              Inverse      : boolean;
          var XReal        : TNVectorPtr2;
          var XImag        : TNVectorPtr2;
          var SinTable     : TNVectorPtr2;
          var CosTable     : TNVectorPtr2);

{-----------------------------------------------------}
{- Input: NumberOfBits, NumPoints, Inverse, XReal,   -}
{-        XImag, SinTable, CosTable                  -}
{- Output: XReal, XImag                              -}
{-                                                   -}
{- This procedure implements the actual fast Fourier -}
{- transform routine.  The vector X, which must be   -}
{- entered in bit-inverted order, is transformed in  -}
{- place.  The transformation uses the Cooley-Tukey  -}
{- algorithm.                                        -}
{-----------------------------------------------------}

{ Called by RealFFT2and ComplexFFT2 to perform the guts of the calculations}

const
  RootTwoOverTwo = 0.707106781186548;

var
  Term : byte;
  CellSeparation : integer;
  NumberOfCells : integer;
  NumElementsInCell : integer;
  NumElInCellLess1 : integer;
  NumElInCellSHR1 : integer;
  NumElInCellSHR2 : integer;
  RealRootOfUnity, ImagRootOfUnity : double;
  Element : integer;
  CellElements : integer;
  ElementInNextCell : integer;
  Index : integer;
  RealDummy, ImagDummy : double;

    procedure BitInvert(NumberOfBits : byte;
                        NumPoints    : integer;
                    var XReal        : TNVectorPtr2;
                    var XImag        : TNVectorPtr2);

    {-----------------------------------------------------------}
    {- Input: NumberOfBits, NumPoints                          -}
    {- Output: XReal, XImag                                    -}
    {-                                                         -}
    {- This procedure bit inverts the order of data in the     -}
    {- vector X.  Bit inversion reverses the order of the      -}
    {- binary representation of the indices; thus 2 indices    -}
    {- will be switched.  For example, if there are 16 points, -}
    {- Index 7 (binary 0111) would be switched with Index 14   -}
    {- (binary 1110).  It is necessary to bit invert the order -}
    {- of the data so that the transformation comes out in the -}
    {- correct order.                                          -}
    {-----------------------------------------------------------}

    var
      Term : integer;
      Invert : integer;
      Hold : double;
      NumPointsDiv2, K : integer;

    begin
      NumPointsDiv2 := NumPoints shr 1;
      Invert := 0;
      for Term := 0 to NumPoints - 2 do
      begin
        if Term < Invert then   { Switch these two indices  }
        begin
          Hold := XReal^[Invert];
          XReal^[Invert] := XReal^[Term];
          XReal^[Term] := Hold;
          Hold := XImag^[Invert];
          XImag^[Invert] := XImag^[Term];
          XImag^[Term] := Hold;
        end;
        K := NumPointsDiv2;
        while K <= Invert do
        begin
          Invert := Invert - K;
          K := K shr 1;
        end;
        Invert := Invert + K;
      end;
    end; { procedure BitInvert }

begin { procedure FFT }
  { The data must be entered in bit inverted order }
  { for the transform to come out in proper order  }
  BitInvert(NumberOfBits, NumPoints, XReal, XImag);

  if Inverse then
    { Conjugate the input  }
    for Element := 0 to NumPoints - 1 do
      XImag^[Element] := -XImag^[Element];

  NumberOfCells := NumPoints;
  CellSeparation := 1;
  for Term := 1 to NumberOfBits do
  begin
    { NumberOfCells halves; equals 2^(NumberOfBits - Term)  }
    NumberOfCells := NumberOfCells shr 1;
    { NumElementsInCell doubles; equals 2^(Term-1)  }
    NumElementsInCell := CellSeparation;
    { CellSeparation doubles; equals 2^Term  }
    CellSeparation := CellSeparation SHL 1;
    NumElInCellLess1 := NumElementsInCell - 1;
    NumElInCellSHR1 := NumElementsInCell shr 1;
    NumElInCellSHR2 := NumElInCellSHR1 shr 1;

    { Special case: RootOfUnity = EXP(-i 0)  }
    Element := 0;
    while Element < NumPoints do
    begin
      { Combine the X[Element] with the element in  }
      { the identical location in the next cell     }
      ElementInNextCell := Element + NumElementsInCell;
      RealDummy := XReal^[ElementInNextCell];
      ImagDummy := XImag^[ElementInNextCell];
      XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
      XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
      XReal^[Element] := XReal^[Element] + RealDummy;
      XImag^[Element] := XImag^[Element] + ImagDummy;
      Element := Element + CellSeparation;
    end;

    for CellElements := 1 to NumElInCellSHR2 - 1 do
    begin
      Index := CellElements * NumberOfCells;
      RealRootOfUnity := CosTable^[Index];
      ImagRootOfUnity := SinTable^[Index];
      Element := CellElements;

      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := XReal^[ElementInNextCell] * RealRootOfUnity -
                     XImag^[ElementInNextCell] * ImagRootOfUnity;
        ImagDummy := XReal^[ElementInNextCell] * ImagRootOfUnity +
                     XImag^[ElementInNextCell] * RealRootOfUnity;
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    { Special case: RootOfUnity = EXP(-i PI/4)  }
    if Term > 2 then
    begin
      Element := NumElInCellSHR2;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := RootTwoOverTwo * (XReal^[ElementInNextCell] +
                     XImag^[ElementInNextCell]);
        ImagDummy := RootTwoOverTwo * (XImag^[ElementInNextCell] -
                     XReal^[ElementInNextCell]);
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    for CellElements := NumElInCellSHR2 + 1 to NumElInCellSHR1 - 1 do
    begin
      Index := CellElements * NumberOfCells;
      RealRootOfUnity := CosTable^[Index];
      ImagRootOfUnity := SinTable^[Index];
      Element := CellElements;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := XReal^[ElementInNextCell] * RealRootOfUnity -
                     XImag^[ElementInNextCell] * ImagRootOfUnity;
        ImagDummy := XReal^[ElementInNextCell] * ImagRootOfUnity +
                     XImag^[ElementInNextCell] * RealRootOfUnity;
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    { Special case: RootOfUnity = EXP(-i PI/2)  }
    if Term > 1 then
    begin
      Element := NumElInCellSHR1;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy :=  XImag^[ElementInNextCell];
        ImagDummy := -XReal^[ElementInNextCell];
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    for CellElements := NumElInCellSHR1 + 1 to
                        NumElementsInCell - NumElInCellSHR2 - 1 do
    begin
      Index := CellElements * NumberOfCells;
      RealRootOfUnity := CosTable^[Index];
      ImagRootOfUnity := SinTable^[Index];
      Element := CellElements;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := XReal^[ElementInNextCell] * RealRootOfUnity -
                     XImag^[ElementInNextCell] * ImagRootOfUnity;
        ImagDummy := XReal^[ElementInNextCell] * ImagRootOfUnity +
                     XImag^[ElementInNextCell] * RealRootOfUnity;
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    { Special case: RootOfUnity = EXP(-i 3PI/4)  }
    if Term > 2 then
    begin
      Element := NumElementsInCell - NumElInCellSHR2;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := -RootTwoOverTwo * (XReal^[ElementInNextCell] -
                                        XImag^[ElementInNextCell]);
        ImagDummy := -RootTwoOverTwo * (XReal^[ElementInNextCell] +
                                        XImag^[ElementInNextCell]);
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    for CellElements := NumElementsInCell - NumElInCellSHR2 + 1 to
                                            NumElInCellLess1 do
    begin
      Index := CellElements * NumberOfCells;
      RealRootOfUnity := CosTable^[Index];
      ImagRootOfUnity := SinTable^[Index];
      Element := CellElements;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := XReal^[ElementInNextCell] * RealRootOfUnity -
                     XImag^[ElementInNextCell] * ImagRootOfUnity;
        ImagDummy := XReal^[ElementInNextCell] * ImagRootOfUnity +
                     XImag^[ElementInNextCell] * RealRootOfUnity;
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;
  end;

  {----------------------------------------------------}
  {-  Divide all the values of the transformation     -}
  {-  by the square root of NumPoints. If taking the  -}
  {-  inverse, conjugate the output.                  -}
  {----------------------------------------------------}

  if Inverse then
    ImagDummy := -1/Sqrt(NumPoints)
  else
    ImagDummy :=  1/Sqrt(NumPoints);
  RealDummy := ABS(ImagDummy);
  for Element := 0 to NumPoints - 1 do
  begin
    XReal^[Element] := XReal^[Element] * RealDummy;
    XImag^[Element] := XImag^[Element] * ImagDummy;
  end;
end; { procedure FFT }

{----------------------------------------------------------------------------}
{-                                                                          -}
{-     Turbo Pascal Numerical Methods Toolbox                               -}
{-     Copyright (c) 1986, 87 by Borland International, Inc.                -}
{-                                                                          -}
{----------------------------------------------------------------------------}

{************** RealFFT2 ****************}
procedure RealFFT2(NumPoints : integer;
                   Inverse   : boolean;
               var XReal     : TNVectorPtr2;
               var XImag     : TNVectorPtr2;
               var Error     : byte);
var
  SinTable, CosTable : TNVectorPtr2;   { Tables of sine and cosine values  }
  Sindata,CosData:TNVector2;
  NumberOfBits : byte;                { Number of bits necessary to     }
                                      { represent the number of points  }

    procedure MakeRealDataComplex(NumPoints : integer;
                              var XReal     : TNVectorPtr2;
                              var XImag     : TNVectorPtr2);

    {-----------------------------------------------------------}
    {- Input: NumPoints, XReal                                 -}
    {- Output: XReal, XImag                                    -}
    {-                                                         -}
    {- This procedure shuffles the real data.  There are       -}
    {- 2*NumPoints real data points in the vector XReal.  The  -}
    {- data is shuffled so that there are NumPoints complex    -}
    {- data points.  The real part of the complex data is      -}
    {- made up of those points whose original array Index was  -}
    {- even; the imaginary part of the complex data is made    -}
    {- up of those points whose original array Index was odd.  -}
    {-----------------------------------------------------------}

    var
      Index, NewIndex : integer;
      DummyReal, DummyImag : TNVectorPtr2;
      Dummyr,DummyI:TNVector2;
    begin
      Setlength(Dummyr,length(Xreal^));
      Setlength(DummyI,length(XImag^));
      Dummyreal:=@DummyR;
      DummyImag:=@DummyI;
      for Index := 0 to NumPoints - 1 do
      begin
        NewIndex := Index shl 1;
        DummyReal^[Index] := XReal^[NewIndex];
        DummyImag^[Index] := XReal^[NewIndex + 1];
      end;

      for Index := 0 to NumPoints - 1 do
      begin
         XReal^[Index]:=DummyReal^[Index];
         XImag^[Index]:=DummyImag^[Index];
      end;
    end; { procedure MakeRealDataComplex }

    procedure UnscrambleComplexOutput(NumPoints : integer;
                                  var SinTable  : TNVectorPtr2;
                                  var CosTable  : TNVectorPtr2;
                                  var XReal     : TNVectorPtr2;
                                  var XImag     : TNVectorPtr2);

    {----------------------------------------------------------}
    {- Input: NumPoints, SinTable, CosTable, XReal, XImag     -}
    {- Output: XReal, XImag                                   -}
    {-                                                        -}
    {- This procedure unshuffles the complex transform.       -}
    {- The transform has NumPoints elements.  This procedure  -}
    {- unshuffles the transform so that it is 2*NumPoints     -}
    {- elements long.  The resulting vector is symmetric      -}
    {- about the element NumPoints.                           -}
    {- Both the forward and inverse transforms are defined    -}
    {- with a 1/Sqrt(NumPoints) factor.  Since the real FFT   -}
    {- algorithm operates on vectors of length NumPoints/2,   -}
    {- the unscrambled vectors must be divided by Sqrt(2).    -}
    {----------------------------------------------------------}

    var
      PiOverNumPoints : Float;
      Index : integer;
      indexSHR1 : integer;
      NumPointsMinusIndex : integer;
      SymmetricIndex : integer;
      Multiplier : Float;
      Factor : Float;
      CosFactor, SinFactor : Float;
      RealSum, ImagSum, RealDif, ImagDif : Float;
      RealDummy, ImagDummy : TNVectorPtr2;
      NumPointsSHL1 : integer;
      Dummyr,DummyI:TNVector2;
    begin
      Setlength(Dummyr,length(Xreal^));
      Setlength(DummyI,length(XImag^));
      RealDummy:=@DummyR;
      ImagDummy:=@DummyI;

      PiOverNumPoints := Pi / NumPoints;
      NumPointsSHL1 := NumPoints shl 1;
      RealDummy^[0] := (XReal^[0] + XImag^[0]) / Sqrt(2);
      ImagDummy^[0] := 0;
      RealDummy^[NumPoints] := (XReal^[0] - XImag^[0]) / Sqrt(2);
      ImagDummy^[NumPoints] := 0;
      for Index := 1 to NumPoints - 1 do
      begin
        Multiplier := 0.5 / Sqrt(2);
        Factor := PiOverNumPoints * Index;
        NumPointsMinusIndex := NumPoints - Index;
        SymmetricIndex := NumPointsSHL1 - Index;
        if Odd(Index) then
          begin
            CosFactor :=  Cos(Factor);
            SinFactor := -Sin(Factor);
          end
        else
          begin
            indexSHR1 := Index shr 1;
            CosFactor := CosTable^[indexSHR1];
            SinFactor := SinTable^[indexSHR1];
          end;

        RealSum := XReal^[Index] + XReal^[NumPointsMinusIndex];
        ImagSum := XImag^[Index] + XImag^[NumPointsMinusIndex];
        RealDif := XReal^[Index] - XReal^[NumPointsMinusIndex];
        ImagDif := XImag^[Index] - XImag^[NumPointsMinusIndex];

        RealDummy^[Index] := Multiplier * (RealSum + CosFactor * ImagSum
                             + SinFactor * RealDif);
        ImagDummy^[Index] := Multiplier * (ImagDif + SinFactor * ImagSum
                             - CosFactor * RealDif);
        RealDummy^[SymmetricIndex] :=  RealDummy^[Index];
        ImagDummy^[SymmetricIndex] := -ImagDummy^[Index];
      end;  { for }

      for Index := 0 to NumPoints - 1 do
      begin
         XReal^[Index]:=RealDummy^[Index];
         XImag^[Index]:=ImagDummy^[Index];
      end;

      //XReal^ := RealDummy^;
      //XImag^ := ImagDummy^;
      //Dispose(RealDummy);
      //Dispose(ImagDummy);
    end; { procedure UnscrambleComplexOutput }

begin { procedure RealFFT2 }

  { The number of complex data points will  }
  { be half the number of real data points  }
  NumPoints := NumPoints shr 1;

  TestInput(NumPoints, NumberOfBits, Error);

  if Error = 0 then
  begin
    Setlength(SinData,numpoints);
    Setlength(CosData,numpoints);
    SinTable:=@SinData;
    CosTable:=@CosData;
    MakeRealDataComplex(NumPoints, XReal, XImag);
    MakeSinCosTable(NumPoints, SinTable, CosTable);
    FFT(NumberOfBits, NumPoints, Inverse, XReal, XImag, SinTable, CosTable);
    UnscrambleComplexOutput(NumPoints, SinTable, CosTable, XReal, XImag);
    //NumPoints := NumPoints shl 1;    { The number of complex points  }
                                     { in the transform will be the  }
                                     { same as the number of real    }

  end;
end; { procedure RealFFT2 }

{*************** ComplexFFT2 **********}
procedure ComplexFFT2{(NumPoints : integer;
                      Inverse   : boolean;
                  var XReal     : TNVectorPtr2;
                  var XImag     : TNVectorPtr2;
                  var Error     : byte)};

var
  SinTable, CosTable : TNVectorPtr2;      { Tables of sin and cosine values  }
  NumberOfBits : byte;                   { Number of bits to represent the  }
                                         { number of data points.           }

begin { procedure ComplexFFT }

  TestInput(NumPoints, NumberOfBits, Error);

  if Error = 0 then
  begin
    New(SinTable);
    New(CosTable);

    MakeSinCosTable(NumPoints, SinTable, CosTable);
    FFT(NumberOfBits, NumPoints, Inverse, XReal, XImag, SinTable, CosTable);

    Dispose(SinTable);
    Dispose(CosTable);
  end;
end; { procedure ComplexFFT2 }


end. { U_FFT}
