unit ESBMaths2;

{:
	ESBMaths 3.2.1 - contains useful Mathematical routines for Delphi 4, 5 & 6.

	Copyright ©1997-2001 ESB Consultancy<p>

	These routines are used by ESB Consultancy within the
	development of their Customised Applications, and have been
	under Development since the early Turbo Pascal days. Many of the
	routines were developed for specific needs.<p>

	ESB Consultancy retains full copyright.<p>

	ESB Consultancy grants users of this code royalty free rights
	to do with this code as they wish.<p>

	ESB Consultancy makes no guarantees nor excepts any liabilities
	due to the use of these routines<p>

	We does ask that if this code helps you in you development
	that you send as an email mailto:glenn@esbconsult.com.au or even
	a local postcard. It would also be nice if you gave us a
	mention in your About Box or Help File.<p>

	ESB Consultancy Home Page: http://www.esbconsult.com.au<p>

	Mail Address: PO Box 2259, Boulder, WA 6449 AUSTRALIA<p>

	Check out our new ESB Professional Computation Suite with
	3000+ Routines and 80+ Components for Delphi 4, 5 & 6.<p>
	http://www.esbconsult.com.au/esbpcs.html<p>

	Also check out Marcel Martin's HIT at:<p>
	http://www.esbconsult.com.au/esbpcs-hit.html<p>
	Marcel has been helping out to optimise and improve routines.<p>

	Rory Daulton has generously donated and helped with many optimised
	routines. Our thanks to him as well.<p>

	Marcel van Brakel has also been very helpful has includes ESBMaths
	into the Jedi Collection. http://www.delphi-jedi.org/

	Any mistakes made are mine rather than Rory's or the Marcels'.<p>

	History: See Whatsnew.txt
}

interface
{$IFDEF VER120}
{$DEFINE D4andAbove}
{$ENDIF}

{$IFDEF VER125}
{$DEFINE D4andAbove}
{$ENDIF}

{$IFDEF VER130}
{$DEFINE D4andAbove}
{$ENDIF}

{$IFDEF VER140}
{$DEFINE D4andAbove}
{$ENDIF}

{$J-} // Constants from here are not assignable

{$IFNDEF D4AndAbove}
//Routines designed for Delphi 4 and Above only!
{$ENDIF}

uses
	ESBMaths;

type
	TDynFloatArray = array of Extended;
	TDynLWordArray = array of LongWord;
	TDynLIntArray = array of LongInt;

type
	TDynFloatMatrix = array of TDynFloatArray;
	TDynLWordMatrix = array of TDynLWordArray;
	TDynLIntMatrix = array of TDynLIntArray;

{--- Vector Operations ---}

{: Returns Vector X with all its elements squared }
function SquareAll (const X: TDynFloatArray): TDynFloatArray;

{: Returns Vector X with all its elements inversed , i.e 1 / X [i].
An exception is raised if any element is zero }
function InverseAll (const X: TDynFloatArray): TDynFloatArray;

{: Returns Vector X with all the Natural Log of all its elements .
An exception is raised if any element is not Positive }
function LnAll (const X: TDynFloatArray): TDynFloatArray;

{: Returns Vector X with all the Log to Base 10 of all its elements .
An exception is raised if any element is not Positive }
function Log10All (const X: TDynFloatArray): TDynFloatArray;

{: Returns Vector X with all elements Linearly transformed.
	NewX [i] = Offset + Scale * X [i] }
function LinearTransform (const X: TDynFloatArray;
	Offset, Scale: Extended): TDynFloatArray;

{: Returns a vector where each element is the corresponding elements
of X and Y added together. The Length of the resultant vector is that
of the smaller of X and Y. }
function AddVectors (const X, Y: TDynFloatArray): TDynFloatArray;

{: Returns a vector where each element is the corresponding elements
of Y subtracted from X added together. The Length of the resultant vector is
that of the smaller of X and Y. }
function SubVectors (const X, Y: TDynFloatArray): TDynFloatArray;

{: Returns a vector where each element is the corresponding elements
of X and Y multiplied together. The Length of the resultant vector is that
of the smaller of X and Y. }
function MultVectors (const X, Y: TDynFloatArray): TDynFloatArray;

{: Returns the Dot Product of the two vectors, i.e. the sum of the pairwise
products of the elements. If Vectors are not of equal length then only
the shorter length is used.}
function DotProduct (const X, Y: TDynFloatArray): Extended;

{: Returns the Norm of a vector, i.e. the square root of the sum of the
squares of the elements. }
function Norm (const X: TDynFloatArray): Extended;

{--- Matrix Operations ---}

{: Returns true if the Matrix is not nil and all the "columns" are
the same length - Delphi allows a 2 Dimensional Dynamic Array with
different length "columns" - this can cause problems in some operations }
function MatrixIsRectangular (const X: TDynFloatMatrix): Boolean;

{: Returns Rectangular as true if the Matrix is not nil and all the "columns"
are the same length - Delphi allows a 2 Dimensional Dynamic Array with
different length "columns" - this can cause problems in some operations.
Rows and Columns are the dimensions which really only make sense if the Matrix
is Rectangular }
procedure MatrixDimensions (const X: TDynFloatMatrix;
	var Rows, Columns : LongWord; var Rectangular: Boolean);

{: For a Matrix to be Square it must be Rectangular and have the
same number of "rows" and "columns" }
function MatrixIsSquare (const X: TDynFloatMatrix): Boolean;

{: Matrices have the same dimensions if they are both Rectangular and
they have the same number of "rows" and the same number of "columns"}
function MatricesSameDimensions (const X, Y: TDynFloatMatrix): Boolean;

{: Returns a Dynamic Matrix that is the result of Adding the two supplied
Matrices. Both X and Y must be truly Rectangular and must be of the same
dimension otherwise an Exception is raised. }
function AddMatrices (const X, Y: TDynFloatMatrix): TDynFloatMatrix;

{: In place Addition of Matrices. Add one Matrix to another, X := X + Y.
	Both X and Y must be truly Rectangular and must be of the
     same dimension otherwise an Exception is raised. }
procedure AddToMatrix (var X: TDynFloatMatrix; const Y: TDynFloatMatrix);

{: Returns a Dynamic Matrix that is the result of Subtracting the two supplied
Matrices. Both X and Y must be truly Rectangular and must be of the same
dimension otherwise an Exception is raised. }
function SubtractMatrices (const X, Y: TDynFloatMatrix): TDynFloatMatrix;

{: In place Subtraction of Matrices. Subtract one Matrix to another, X := X - Y.
	Both X and Y must be truly Rectangular and must be of the
     same dimension otherwise an Exception is raised. }
procedure SubtractFromMatrix (var X: TDynFloatMatrix; const Y: TDynFloatMatrix);

{: Returns a Dynamic Matrix that is the result of multiplying each element
	of X by the constant K. Will handle non-Rectangular Matrices }
function MultiplyMatrixByConst (const X: TDynFloatMatrix; const K: Extended): TDynFloatMatrix;

{: Does an inplace multiplying each element of X by the constant K.
	Will handle non-Rectangular Matrices }
procedure MultiplyMatrixByConst2 (var X: TDynFloatMatrix; const K: Extended); overload;

{: Multiplies two Rectangular Matrices. The number of columns in X must
	equal the number of rows in Y }
function MultiplyMatrices (const X, Y: TDynFloatMatrix): TDynFloatMatrix; overload;

{: Transposes the Given Matrix. Only works with Rectangular Matrices. }
function TransposeMatrix (const X: TDynFloatMatrix): TDynFloatMatrix; overload;

{: Calculates the Grand Mean of a Matrix: Sum of all the values
	divided by no of values. Will handle non-Rectangular Matrices.
	Also returns N the number of Values since the Matrix may not be Rectangular }
function GrandMean (const X: TDynFloatMatrix; var N: LongWord): Extended;

implementation

uses
	SysUtils;

function SquareAll (const X: TDynFloatArray): TDynFloatArray;
var
	I: LongWord;
begin
	SetLength (Result, High (X) + 1);
	for I := 0 to High (X) do
		Result [I] := Sqr (X [I]);
end;

function InverseAll (const X: TDynFloatArray): TDynFloatArray;
var
	I: LongWord;
begin
	SetLength (Result, High (X) + 1);
	for I := 0 to High (X) do
	begin
		if X [I] = 0 then
			raise EMathError.Create ('Inverse of Zero');
		Result [I] := 1 / (X [I]);
	end;
end;

function LnAll (const X: TDynFloatArray): TDynFloatArray;
var
	I: LongWord;
begin
	SetLength (Result, High (X) + 1);
	for I := 0 to High (X) do
	begin
		if X [I] <= 0 then
			raise EMathError.Create ('Logarithm on non-Positive');
		Result [I] := Ln (X [I]);
	end;
end;

function Log10All (const X: TDynFloatArray): TDynFloatArray;
var
	I: LongWord;
begin
	SetLength (Result, High (X) + 1);
	for I := 0 to High (X) do
	begin
		if X [I] <= 0 then
			raise EMathError.Create ('Logarithm on non-Positive');
		Result [I] := ESBLog10 (X [I]);
	end;
end;

function LinearTransform (const X: TDynFloatArray;
	Offset, Scale: Extended): TDynFloatArray;
var
	I: LongWord;
begin
	SetLength (Result, High (X) + 1);
	for I := 0 to High (X) do
		Result [I] := OffSet + Scale * X [I];
end;

function AddVectors (const X, Y: TDynFloatArray): TDynFloatArray;
var
	I: LongWord;
begin
	SetLength (Result, MinL (High (X), High (Y)) + 1);
	for I := 0 to High (Result) do
		Result [I] := X [I] + Y [I];
end;

function SubVectors (const X, Y: TDynFloatArray): TDynFloatArray;
var
	I: LongWord;
begin
	SetLength (Result, MinL (High (X), High (Y)) + 1);
	for I := 0 to High (Result) do
		Result [I] := X [I] - Y [I];
end;

function MultVectors (const X, Y: TDynFloatArray): TDynFloatArray;
var
	I: LongWord;
begin
	SetLength (Result, MinL (High (X), High (Y)) + 1);
	for I := 0 to High (Result) do
		Result [I] := X [I] * Y [I];
end;

function DotProduct (const X, Y: TDynFloatArray): Extended;
var
	I, N: Longword;
begin
	Result := 0.0;
	N := MinL (High (X), High (Y));
	for I := 0 to N do
		Result := Result + X [I] * Y [I];
end;

function Norm (const X: TDynFloatArray): Extended;
begin
	Result := Sqrt (DotProduct (X, X));
end;

function GrandMean (const X: TDynFloatMatrix; var N: LongWord): Extended;
var
	I, J: Integer;
begin
	Result := 0;
	if (High (X) < 0) or (High (X [0]) < 0) then
		raise EMathError.Create ('Matrix is Empty!');

	N := 0;
	for I := 0 to High (X) do
	begin
		N := N + Longword (High (X [I])) + 1;
		for J := 0 to High (X [I]) do
			Result := Result + X [I, J];
	end;
	if N > 0 then
		Result := Result / N
	else
		raise EMathError.Create ('Matrix is Empty!');
end;

function AddMatrices (const X, Y: TDynFloatMatrix): TDynFloatMatrix;
var
	I, J, N: Integer;
begin
	Result := nil;
	if (High (X) < 0) or (High (Y) < 0) then
		raise EMathError.Create ('Matrix is Empty!');

	if (High (X) <> High (Y)) then
		raise EMathError.Create ('Matrices must be the same Dimension to Add!');

	N := High (X [0]);
	SetLength (Result, High (X) + 1, N + 1);
	for I := 0 to High (X) do
	begin
		if (High (X [I]) <> N) then
		begin
			Result := nil;
			raise EMathError.Create ('Matrices must be truly rectangular to Add!');
		end;
		if (High (Y [I]) <> N) then
		begin
			Result := nil;
			raise EMathError.Create ('Matrices must be the same Dimension to Add!');
		end;

		for J := 0 to N do
			Result [I, J] := X [I, J] + Y [I, J];
	end;
end;

function SubtractMatrices (const X, Y: TDynFloatMatrix): TDynFloatMatrix;
var
	I, J, N: Integer;
begin
	Result := nil;
	if (High (X) < 0) or (High (Y) < 0) then
		raise EMathError.Create ('Matrix is Empty!');

	if (High (X) <> High (Y)) then
		raise EMathError.Create ('Matrices must be the same Dimension to Subtract!');

	N := High (X [0]);
	SetLength (Result, High (X) + 1, N + 1);
	for I := 0 to High (X) do
	begin
		if (High (X [I]) <> N) then
		begin
			Result := nil;
			raise EMathError.Create ('Matrices must be truly rectangular to Subtract!');
		end;
		if (High (Y [I]) <> N) then
		begin
			Result := nil;
			raise EMathError.Create ('Matrices must be the same Dimension to Subtract!');
		end;

		for J := 0 to N do
			Result [I, J] := X [I, J] - Y [I, J];
	end;
end;

function MultiplyMatrixByConst (const X: TDynFloatMatrix; const K: Extended): TDynFloatMatrix;
var
	I, J: Integer;
begin
	Result := nil;
	if (High (X) < 0) then
		raise EMathError.Create ('Matrix is Empty!');

	SetLength (Result, High (X) + 1);
	for I := 0 to High (X) do
	begin
		SetLength (Result [I], High (X [I]) + 1);
		for J := 0 to High (X [I]) do
			Result [I, J] := X [I, J] * K;
	end;
end;

function MatrixIsRectangular (const X: TDynFloatMatrix): Boolean;
var
	I, N: Integer;
begin
	Result := False;
	if (High (X) < 0) then
		Exit;

	N := High (X [0]);
	for I := 0 to High (X) do
		if (High (X [I]) <> N) then
			Exit;

	Result := True;
end;

procedure MatrixDimensions (const X: TDynFloatMatrix;
	var Rows, Columns: LongWord; var Rectangular: Boolean);
var
	I: LongWord;
begin
	Rows := Length (X);
     if Rows > 0 then
		Columns := Length (X [0])
     else
     	Columns := 0;

	Rectangular := False;
	if (Rows = 0) or (Columns = 0) then
		Exit;

	for I := 0 to Rows - 1 do
		if (LongWord (Length (X [I])) <> Columns) then
		begin
			Columns := 0;
			Exit;
		end;

	Rectangular := True;
end;

function MatrixIsSquare (const X: TDynFloatMatrix): Boolean;
var
	M, N: LongWord;
	Rectangular: Boolean;
begin
	MatrixDimensions (X, M, N, Rectangular);
	Result := Rectangular and (M = N);
end;

function MatricesSameDimensions (const X, Y: TDynFloatMatrix): Boolean;
var
	M1, N1: LongWord;
	Rectangular1: Boolean;
	M2, N2: LongWord;
	Rectangular2: Boolean;
begin
	MatrixDimensions (X, M1, N1, Rectangular1);
	MatrixDimensions (Y, M2, N2, Rectangular2);
	Result := Rectangular1 and Rectangular2 and (M1 = M2) and (N1 = N2);
end;

procedure AddToMatrix (var X: TDynFloatMatrix; const Y: TDYnFloatMatrix);
var
	I, J: LongWord;
     Rows, Columns: LongWord;
begin
	Rows := Length (X);
	Columns := Length (X [0]);
	if (Rows = 0) or (Columns = 0) then
		raise EMathError.Create ('Matrix is Empty!');

	if not MatricesSameDimensions (X, Y) then
		raise EMathError.Create ('Matrices must be the same Dimension to Add!');

	for I := 0 to Rows - 1 do
		for J := 0 to Columns - 1 do
			X [I, J] := X [I, J] + Y [I, J];
end;

procedure SubtractFromMatrix (var X: TDynFloatMatrix; const Y: TDynFloatMatrix);
var
	I, J: LongWord;
     Rows, Columns: LongWord;
begin
	Rows := Length (X);
	Columns := Length (X [0]);
	if (Rows = 0) or (Columns = 0) then
		raise EMathError.Create ('Matrix is Empty!');

	if not MatricesSameDimensions (X, Y) then
		raise EMathError.Create ('Matrices must be the same Dimension to Add!');

	for I := 0 to Rows - 1 do
	begin
		for J := 0 to Columns - 1 do
			X [I, J] := X [I, J] - Y [I, J];
	end;
end;

procedure MultiplyMatrixByConst2 (var X: TDynFloatMatrix; const K: Extended); overload;
var
	I, J: LongWord;
     Rows, Columns: LongWord;
begin
	Rows := Length (X);
	if (Rows = 0) then
		raise EMathError.Create ('Matrix is Empty!');

	for I := 0 to Rows - 1 do
	begin
		Columns := Length (X [0]);
		for J := 0 to Columns - 1 do
			X [I, J] := X [I, J] * K;
	end;
end;

function MultiplyMatrices (const X, Y: TDynFloatMatrix): TDynFloatMatrix;
var
	I, J, K: LongWord;
     XRows, XColumns: LongWord;
     YRows, YColumns: LongWord;
     XRectangular, YRectangular: Boolean;
begin
	Result := nil;
	MatrixDimensions (X, XRows, XColumns, XRectangular);
	MatrixDimensions (Y, YRows, YColumns, YRectangular);

	if not XRectangular or not YRectangular then
		raise EMathError.Create ('Matrices must both be Rectangular');
	if (XRows = 0) or (YRows = 0) then
		raise EMathError.Create ('Matrix is Empty!');
     if XColumns <> YRows then
		raise EMathError.Create ('Number of Columns in X does not equal'
          	+ #13 + 'the Number of Rows in Y');

	SetLength (Result, XRows, YColumns);

	for I := 0 to XRows - 1 do
		for J := 0 to YColumns - 1 do
          begin
          	Result [I, J] := 0;
               for K := 0 to XColumns - 1 do
				Result [I, J] := Result [I, J] + X [I, K] * Y [K, J];
          end;
end;

function TransposeMatrix (const X: TDynFloatMatrix): TDynFloatMatrix; overload;
var
	I, J: LongWord;
     XRows, XColumns: LongWord;
     XRectangular: Boolean;
begin
	Result := nil;
	MatrixDimensions (X, XRows, XColumns, XRectangular);
	if not XRectangular then
		raise EMathError.Create ('Matrix must be Rectangular');
	if (XRows = 0) or (XColumns = 0) then
		Exit;

	SetLength (Result, XColumns, XRows);
     for I := 0 to XRows - 1 do
     	for J := 0 to XColumns - 1 do
			Result [J, I] := X [I, J];
end;

end.
