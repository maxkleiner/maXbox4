{ ******************************************************************
  Compute an appropriate interval for a set of values
  ****************************************************************** }

unit uinterv;

interface

uses
  utypes, umath;

procedure Interval(X1, X2             : Float;
                   MinDiv, MaxDiv     : Integer;
                   var Min, Max, Step : Float);
{ ------------------------------------------------------------------
  Determines an interval [Min, Max] including the values from X1
  to X2, and a subdivision Step of this interval
  ------------------------------------------------------------------
  Input parameters  : X1, X2 = min. & max. values to be included
                      MinDiv = minimum nb of subdivisions
                      MaxDiv = maximum nb of subdivisions
  ------------------------------------------------------------------
  Output parameters : Min, Max, Step
  ------------------------------------------------------------------ }

procedure AutoScale(X                     : TVector;
                    Lb, Ub                : Integer;
                    Scale                 : TScale;
                    var XMin, XMax, XStep : Float);
{ ------------------------------------------------------------------
  Finds an appropriate scale for plotting the data in X[Lb..Ub]
  ------------------------------------------------------------------ }

implementation

procedure Interval(X1, X2             : Float;
                   MinDiv, MaxDiv     : Integer;
                   var Min, Max, Step : Float);

  var
    H, R, K : Float;
  begin
    if X1 >= X2 then Exit;
    H := X2 - X1;
    R := Int(Log10(H));
    if H < 1.0 then R := R - 1.0;
    Step := Exp10(R);

    repeat
      K := Int(H / Step);
      if K < MinDiv then Step := 0.5 * Step;
      if K > MaxDiv then Step := 2.0 * Step;
    until (K >= MinDiv) and (K <= MaxDiv);

    Min := Step * Int(X1 / Step);
    Max := Step * Int(X2 / Step);
    while Min > X1 do Min := Min - Step;
    while Max < X2 do Max := Max + Step;
  end;

procedure AutoScale(X : TVector; Lb, Ub : Integer; Scale : TScale;
                    var XMin, XMax, XStep : Float);
var
  I      : Integer;
  X1, X2 : Float;
begin
  { Minimum and maximum of X }

  X1 := X[Lb];
  X2 := X1;
  for I := Lb to Ub do
    if X[I] < X1 then
      X1 := X[I]
    else if X[I] > X2 then
      X2 := X[I];

  { Linear scale }

  if Scale = LinScale then
    begin
      Interval(X1, X2, 2, 6, XMin, XMax, XStep);
      Exit;
    end;

  { Logarithmic scale }

  XMin := 1.0E-3;
  XMax := 1.0E+3;
  XStep := 10.0;

  if X1 <= 0.0 then Exit;

  XMin := Int(Log10(X1)); if X1 < 1.0 then XMin := XMin - 1.0;
  XMax := Int(Log10(X2)); if X2 > 1.0 then XMax := XMax + 1.0;
  XMin := Exp10(XMin);
  XMax := Exp10(XMax);
end;

end.
