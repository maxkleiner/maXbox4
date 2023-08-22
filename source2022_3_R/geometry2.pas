unit geometry2;

interface

uses Windows;

type
  PPointF2 = ^TPointF2;
  TPointF2 = packed record
    X: Double;
    Y: Double;
  end;

  PPoint3 = ^TPoint3;
  TPoint3 = packed record
    X, Y, Z: Integer;
  end;

  PPointF3 = ^TPointF3;
  TPointF3 = packed record
    X, Y, Z: Double;
  end;

function AreLinesParallel( p1, p2, p3, p4: TPoint ): Boolean; overload;
function AreLinesParallel( p1, p2, p3, p4: TPointF2; e: Double = 0.00000001 ): Boolean; overload;
function AreLinesParallel( p1, p2, p3, p4, p5, p6: TPoint3 ): Boolean; overload;
function AreLinesParallel( p1, p2, p3, p4, p5, p6: TPointF3; e: Double = 0.00000001 ): Boolean; overload;
function IntersectLines( p1, p2, p3, p4: TPoint ): TPoint; overload;
function IntersectLines( p1, p2, p3, p4: TPointF2; e: Double = 0.00000001 ): TPointF2; overload;

function AngleDifference( alpha, beta: Double ): Double;

implementation

function AreLinesParallel( p1, p2, p3, p4: TPoint ): Boolean; overload;
var a1, b1: Integer;
    a2, b2: Integer;
begin
  a1 := p2.y - p1.y;
  b1 := p1.x - p2.x;
  a2 := p4.y - p3.y;
  b2 := p3.x - p4.x;
  Result := a1 * b2 = a2 * b1;
  //c1 := a1 * x1 + b1 * y1;
  //c2 := a2 * x3 + b2 * y3;
end;

function AreLinesParallel( p1, p2, p3, p4: TPointF2; e: Double = 0.00000001 ): Boolean; overload;
var a1, b1: Double;
    a2, b2: Double;
begin
  a1 := p2.y - p1.y;
  b1 := p1.x - p2.x;
  a2 := p4.y - p3.y;
  b2 := p3.x - p4.x;
  Result := Abs( a1 * b2 - a2 * b1 ) <= e;
end;

function AreLinesParallel( p1, p2, p3, p4, p5, p6: TPoint3 ): Boolean; overload;
var a2, b1, a1, c2: Integer;
begin
  a1 := p2.y - p1.y;
  b1 := p1.x - p2.x;
  a2 := p6.z - p5.z;
  c2 := p5.x - p6.x;
  Result := (a2 * b1 = 0) and (a1 * c2 = 0);
end;

function AreLinesParallel( p1, p2, p3, p4, p5, p6: TPointF3; e: Double = 0.00000001 ): Boolean; overload;
var a2, b1, a1, c2: Double;
begin
  a1 := p2.y - p1.y;
  b1 := p1.x - p2.x;
  a2 := p6.z - p5.z;
  c2 := p5.x - p6.x;
  Result := (Abs(a2 * b1) <= e) and (Abs(a1 * c2) <= e);
end;

function IntersectLines( p1, p2, p3, p4: TPoint ): TPoint; overload;
var a1, b1, c1: Integer;
    a2, b2, c2: Integer;
    d: Integer;
begin
  a1 := p2.y - p1.y;
  b1 := p1.x - p2.x;
  a2 := p4.y - p3.y;
  b2 := p3.x - p4.x;
  d := a1 * b2 - a2 * b1;
  if d <> 0 then
  begin
    c1 := a1 * p1.x + b1 * p1.y;
    c2 := a2 * p3.x + b2 * p3.y;
    Result.X := (c1 * b2 - c2 * b1) div d;
    Result.Y := (a1 * c2 - a2 * c1) div d;
  end
    else
  begin
    {Result.X := 0;
    Result.Y := 0;}
  end;
end;

function IntersectLines( p1, p2, p3, p4: TPointF2; e: Double = 0.00000001 ): TPointF2; overload;
var a1, b1, c1: Double;
    a2, b2, c2: Double;
    d: Double;
begin
  a1 := p2.y - p1.y;
  b1 := p1.x - p2.x;
  a2 := p4.y - p3.y;
  b2 := p3.x - p4.x;
  d := a1 * b2 - a2 * b1;
  if Abs(d) > e  then
  begin
    c1 := a1 * p1.x + b1 * p1.y;
    c2 := a2 * p3.x + b2 * p3.y;
    Result.X := (c1 * b2 - c2 * b1) / d;
    Result.Y := (a1 * c2 - a2 * c1) / d;
  end
    else
  begin
    {Result.X := 0;
    Result.Y := 0;}
  end;
end;

function AngleDifference( alpha, beta: Double ): Double;
var n: Integer;
begin
  Result := Abs( alpha - beta );
  if Result >= 2 * PI then
  begin
    n := Trunc( Result / (2 * PI) );
    Result := Result - n * 2 * PI;
  end;
  if Result > PI then
    Result := PI - Result;
end;

end.
