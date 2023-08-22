{ ******************************************************************
  Types and constants - Error handling - Dynamic arrays
  ******************************************************************
  The default real type is DOUBLE (8-byte real).
  Other types may be selected by defining the symbols:

       SINGLEREAL   (Single precision, 4 bytes)
       EXTENDEDREAL (Extended precision, 10 bytes)
  ****************************************************************** }

unit utypes;

interface

{$i types.inc}

{ ------------------------------------------------------------------
  Error handling
  ------------------------------------------------------------------ }

procedure SetErrCode(ErrCode : Integer);
{ Sets the error code }

function DefaultVal(ErrCode : Integer; DefVal : Float) : Float;
{ Sets error code and default function value }

function MathErr : Integer;
{ Returns the error code }

{ ------------------------------------------------------------------
  Dynamic arrays
  ------------------------------------------------------------------ }

procedure SetAutoInit(AutoInit : Boolean);
{ Sets the auto-initialization of arrays }

procedure DimVector(var V : TVector; Ub : Integer); 
{ Creates floating point vector V[0..Ub] }

procedure DimIntVector(var V : TIntVector; Ub : Integer); 
{ Creates integer vector V[0..Ub] }

procedure DimCompVector(var V : TCompVector; Ub : Integer); 
{ Creates complex vector V[0..Ub] }

procedure DimBoolVector(var V : TBoolVector; Ub : Integer); 
{ Creates boolean vector V[0..Ub] }

procedure DimStrVector(var V : TStrVector; Ub : Integer); 
{ Creates string vector V[0..Ub] }

procedure DimMatrix(var A : TMatrix; Ub1, Ub2 : Integer); 
{ Creates floating point matrix A[0..Ub1, 0..Ub2] }

procedure DimIntMatrix(var A : TIntMatrix; Ub1, Ub2 : Integer); 
{ Creates integer matrix A[0..Ub1, 0..Ub2] }

procedure DimCompMatrix(var A : TCompMatrix; Ub1, Ub2 : Integer); 
{ Creates complex matrix A[0..Ub1, 0..Ub2] }

procedure DimBoolMatrix(var A : TBoolMatrix; Ub1, Ub2 : Integer); 
{ Creates boolean matrix A[0..Ub1, 0..Ub2] }

procedure DimStrMatrix(var A : TStrMatrix; Ub1, Ub2 : Integer); 
{ Creates string matrix A[0..Ub1, 0..Ub2] }


implementation

var
  gAutoInit : Boolean = False;
  gErrCode  : Integer = 0;

procedure SetErrCode(ErrCode : Integer);
begin
  gErrCode := ErrCode;
end;

function DefaultVal(ErrCode : Integer; DefVal : Float) : Float;
begin
  SetErrCode(ErrCode);
  DefaultVal := DefVal;
end;

function MathErr : Integer;
begin
  MathErr := gErrCode;
end;

procedure SetAutoInit(AutoInit : Boolean);
begin
  gAutoInit := AutoInit;
end;

procedure DimVector(var V : TVector; Ub : Integer); 
var
  I : Integer;
begin
  { Check bounds }
  if (Ub < 0) or (Ub > MaxSize) then
    begin
      V := nil;
      Exit;
    end;

  { Allocate vector }
  SetLength(V, Ub + 1);
  if V = nil then Exit;

  { Initialize vector }
  if gAutoInit then
    for I := 0 to Ub do
      V[I] := 0.0;
end;

procedure DimIntVector(var V : TIntVector; Ub : Integer); 
var
  I : Integer;
begin
  { Check bounds }
  if (Ub < 0) or (Ub > MaxSize) then
    begin
      V := nil;
      Exit;
    end;

  { Allocate vector }
  SetLength(V, Ub + 1);
  if V = nil then Exit;

  { Initialize vector }
  if gAutoInit then
    for I := 0 to Ub do
      V[I] := 0;
end;

procedure DimCompVector(var V : TCompVector; Ub : Integer); 
var
  I : Integer;
begin
  { Check bounds }
  if (Ub < 0) or (Ub > MaxSize) then
    begin
      V := nil;
      Exit;
    end;

  { Allocate vector }
  SetLength(V, Ub + 1);
  if V = nil then Exit;

  { Initialize vector }
  if gAutoInit then
    for I := 0 to Ub do
      begin
        V[I].X := 0.0;
        V[I].Y := 0.0;
      end;
end;

procedure DimBoolVector(var V : TBoolVector; Ub : Integer); 
var
  I : Integer;
begin
  { Check bounds }
  if (Ub < 0) or (Ub > MaxSize) then
    begin
      V := nil;
      Exit;
    end;

  { Allocate vector }
  SetLength(V, Ub + 1);
  if V = nil then Exit;

  { Initialize vector }
  if gAutoInit then
    for I := 0 to Ub do
      V[I] := False;
end;

procedure DimStrVector(var V : TStrVector; Ub : Integer); 
var
  I : Integer;
begin
  { Check bounds }
  if (Ub < 0) or (Ub > MaxSize) then
    begin
      V := nil;
      Exit;
    end;

  { Allocate vector }
  SetLength(V, Ub + 1);
  if V = nil then Exit;

  { Initialize vector }
  if gAutoInit then
    for I := 0 to Ub do
      V[I] := '';
end;

procedure DimMatrix(var A : TMatrix; Ub1, Ub2 : Integer); 
var
  I, J : Integer;
begin
  if (Ub1 < 0) or (Ub2 < 0) or (Ub1 > MaxSize) or (Ub2 > MaxSize) then
    begin
      A := nil;
      Exit;
    end;

  { Allocate matrix }
  SetLength(A, Ub1 + 1, Ub2 + 1);
  if A = nil then Exit;

  { Initialize matrix }
  if gAutoInit then
    for I := 0 to Ub1 do
      for J := 0 to Ub2 do
        A[I,J] := 0.0;
end;

procedure DimIntMatrix(var A : TIntMatrix; Ub1, Ub2 : Integer); 
var
  I, J : Integer;
begin
  { Check bounds }
  if (Ub1 < 0) or (Ub2 < 0) or (Ub1 > MaxSize) or (Ub2 > MaxSize) then
    begin
      A := nil;
      Exit;
    end;

  { Allocate matrix }
  SetLength(A, Ub1 + 1, Ub2 + 1);
  if A = nil then Exit;

  { Initialize matrix }
  if gAutoInit then
    for I := 0 to Ub1 do
      for J := 0 to Ub2 do
        A[I,J] := 0;
end;

procedure DimCompMatrix(var A : TCompMatrix; Ub1, Ub2 : Integer); 
var
  I, J : Integer;
begin
  { Check bounds }
  if (Ub1 < 0) or (Ub2 < 0) or (Ub1 > MaxSize) or (Ub2 > MaxSize) then
     begin
       A := nil;
       Exit;
     end;

  { Allocate matrix }
  SetLength(A, Ub1 + 1, Ub2 + 1);
  if A = nil then Exit;

  { Initialize matrix }
  if gAutoInit then
    for I := 0 to Ub1 do
      for J := 0 to Ub2 do
        begin      
          A[I,J].X := 0.0;
          A[I,J].Y := 0.0;
        end;              
end;

procedure DimBoolMatrix(var A : TBoolMatrix; Ub1, Ub2 : Integer); 
var
  I, J : Integer;
begin
  { Check bounds }
  if (Ub1 < 0) or (Ub2 < 0) or (Ub1 > MaxSize) or (Ub2 > MaxSize) then
    begin
      A := nil;
      Exit;
    end;

  { Allocate matrix }
  SetLength(A, Ub1 + 1, Ub2 + 1);
  if A = nil then Exit;

  { Initialize matrix }
  if gAutoInit then
    for I := 0 to Ub1 do
      for J := 0 to Ub2 do
        A[I,J] := False;
end;

procedure DimStrMatrix(var A : TStrMatrix; Ub1, Ub2 : Integer); 
var
  I, J : Integer;
begin
  { Check bounds }
  if (Ub1 < 0) or (Ub2 < 0) or (Ub1 > MaxSize) or (Ub2 > MaxSize) then
    begin
      A := nil;
      Exit;
    end;

  { Allocate matrix }
  SetLength(A, Ub1 + 1, Ub2 + 1);
  if A = nil then Exit;

  { Initialize matrix }
  if gAutoInit then
    for I := 0 to Ub1 do
      for J := 0 to Ub2 do
        A[I,J] := '';
end;

end.
