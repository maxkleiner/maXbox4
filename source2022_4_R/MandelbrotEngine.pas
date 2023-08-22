unit MandelbrotEngine;

interface

//uses w3system, GpW3;

type
  TIterationArray = array of integer;

  type float = double;

  TMandelbrotEngine = class
  private
    FMaxIterations: integer;
  protected
    function  GetIterationFor(x, y: double): integer;
  public
    function  GetLine(xStart, xEnd, y: double; numSamples: integer): TIterationArray;
    property MaxIterations: integer read FMaxIterations write FMaxIterations;
  end;


implementation

{ TMandelbrotEngine }

function  TMandelbrotEngine.GetIterationFor(x, y: double): integer;
var
  u, u2, v, v2, z: float;
begin
  { Check whether point lies in the period-2 bulb }
  u := Sqr(y);
  if Sqr(x - 1) + u < 0.0625 then begin
    Result := FMaxIterations;
    exit;
  end;
  { Check whether point lies in the cardioid }
  v := Sqr(x + 0.25) + u;
  if v * (v - x - 0.25) < 0.25 * u then begin
    Result := FMaxIterations;
    exit;
  end;
  Result := 0;
  u := 0; u2 := 0;
  v := 0; v2 := 0;
  repeat
    z := u2 - v2 - x;
    v := 2 * u * v - y;
    u := z;
    Inc(Result);
    u2 := Sqr(u);
    v2 := Sqr(v);
  until (u2 + v2 > 4) or (Result = FMaxIterations);
end;

function TMandelbrotEngine.GetLine(xStart, xEnd, y: float; numSamples: integer): TIterationArray;
var
  x: integer;
  xWidth: float;
  at: TIterationArray;
begin
  setlength(at,numsamples);
  //Result := at[1];
  xWidth := xEnd - xStart;
  for x := 0 to numSamples do
    Result[x] := GetIterationFor(xStart + xWidth * x / numSamples, y);
end;

end.
