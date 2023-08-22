unit Bricks;

{ CyberUnits }

{ Object Pascal units for computational cybernetics }

{ Bricks: Basic blocks for information processing structures }

{ Version 1.1.1 (Dendron) }

{ (c) Johannes W. Dietrich, 1994 - 2020 }
{ (c) Ludwig Maximilian University of Munich 1995 - 2002 }
{ (c) University of Ulm Hospitals 2002 - 2004 }
{ (c) Ruhr University of Bochum 2005 - 2020 }

{ Standard blocks for systems modelling and simulation }

{ Source code released under the BSD License }

{ See the file "license.txt", included in this distribution, }
{ for details about the copyright. }
{ Current versions and additional information are available from }
{ http://cyberunits.sf.net }

{ This program is distributed in the hope that it will be useful, }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. }

// enhanced with complexmulu as operator overloading
// rename TInt to TInt2 = class(TBlock)
// rename TP to TP2 = class(TBlock)
// fefactor complex to complexreal   , cause type conflict complex is from JCLComplex

//{$mode objfpc}
{$H+}
{$ASSERTIONS ON}

interface

uses
  Classes, SysUtils, Math; //, ucomplex;  inline

const
  kError101 = 'Runtime error: Negative parameter(s)';
  kError102 = 'Runtime error: Parameter(s) out of range';
  kError103 = 'Runtime error: min > max';
  kError104 = 'Runtime error: max = 0';
  kError105 = 'Runtime error: Denominator is zero';

type

  TVectorE = array of extended;

  {type Complex = record
    X, Y : double;
  end;  }

  {TComplex = packed record
    R,I: Single;
  end; }

 //https://svn.freepascal.org/cgi-bin/viewvc.cgi/tags/release_3_0_4/packages/rtl-extra/src/inc/ucomplex.pp?view=markup


  type complexreal = record
               re : real;
               im : real;
            end;



  { TFR }
  { frequency response }

  TFR = record
    M, phi: extended; { magnitude and phase }
    F: complexreal;       { complex FR (F = M(omega) * exp(i * phi(omega)) }
  end;

  { TBlock }
  { Abstract base class for IPS blocks }

  TBlock = class
  protected
    Foutput: extended;
    FFr: TFR;
  public
    name: string;
    destructor Destroy; override;
    procedure simulate; virtual; abstract;
    property output: extended read Foutput;
    property fr: TFR read FFR;
  end;

  { TP }
  { Proportional block }

  TP2 = class(TBlock)
  protected
    function SimAndGetOutput: extended;
    function GetFR: TFR;
  public
    input, G, amplitude, omega: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    property fr: TFR read GetFR;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TPT0 }
  { Dead-time element, improved from Neuber 1989 }

  TPT0 = class(TBlock)
  protected
    function GetQueueLength: integer;
    procedure SetQueueLength(AValue: integer);
    function SimAndGetOutput: extended;
    function GetFR: TFR;
  public
    input, G, amplitude, omega, delta: extended;
    xt: TVectorE; //array of extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    property fr: TFR read GetFR;
    property nt: integer read GetQueueLength write SetQueueLength;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TPT1 }
  { First order delay element, changed from Neuber 1989 }

  TPT1 = class(TBlock)
  protected
    function SimAndGetOutput: extended;
    function GetFR: TFR;
  public
    input, G, t1, x1, amplitude, omega, delta: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    property fr: TFR read GetFR;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TPT2 }
  { Second order delay element, changed from Neuber 1989 }

  TPT2 = class(TBlock)
  protected
    function SimAndGetOutput: extended;
    function GetFR: TFR;
  public
    input, G, t2, dmp, x1, x2, amplitude, omega, delta: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    property fr: TFR read GetFR;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TInt }
  { Integrator block, changed from Neuber 1989 }

  TInt2 = class(TBlock)
  protected
    function SimAndGetOutput: extended;
    function GetFR: TFR;
  public
    input, G, amplitude, omega, delta: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    property fr: TFR read GetFR;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TIT1 }
  { IT1 block, changed from Neuber 1989 }

  TIT1 = class(TBlock)
  protected
    function SimAndGetOutput: extended;
    function GetFR: TFR;
  public
    input, G, t1, x1, amplitude, omega, delta: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    property fr: TFR read GetFR;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TDT1 }
  { DT1 block, changed from Neuber 1989 }

  TDT1 = class(TBlock)
  protected
    function SimAndGetOutput: extended;
    function GetFR: TFR;
  public
    input, G, t1, x1, amplitude, omega, delta: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    property fr: TFR read GetFR;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TIT2 }
  { IT2 block, changed from Neuber 1989 }

  TIT2 = class(TBlock)
  protected
    function SimAndGetOutput: extended;
    function GetFR: TFR;
  public
    input, G, t2, dmp, x1, x2, x3, amplitude, omega, delta: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    property fr: TFR read GetFR;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;


  { TPAdd }
  { Summation block }

  TPAdd = class(TBlock)
  protected
    function SimAndGetOutput: extended;
  public
    input1, input2, G: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TPSub }
  { Substraction block, comparator }

  TPSub = class(TBlock)
  protected
    function SimAndGetOutput: extended;
  public
    input1, input2, G: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TPMul }
  { Multiplicator }

  TPMul = class(TBlock)
  protected
    function SimAndGetOutput: extended;
  public
    input1, input2, G: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TPDiv }
  { Divider}

  TPDiv = class(TBlock)
  protected
    function SimAndGetOutput: extended;
  public
    input1, input2, G: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

   function cexp (z : complexreal) : complexreal;       { exponential }


implementation

{ TIT2 }

//https://svn.freepascal.org/cgi-bin/viewvc.cgi/tags/release_3_0_4/packages/rtl-extra/src/inc/ucomplex.pp?view=markup

 const i : complexreal = (re : 0.0; im : 1.0);
      _0 : complexreal = (re : 0.0; im : 0.0);

 function complexmulu(z1 : complexreal; r : real): complexreal;
 	  //{$ifdef TEST_INLINE}
 	  //inline;
 	  //{$endif TEST_INLINE}
 	    { multiplication : z := z1 * r }
 	    begin
 	       result.re := z1.re * r;
 	       result.im := z1.im * r;
 	    end;

{ fonctions elementaires }

 	  function cexp (z : complexreal) : complexreal;
 	    { exponantial : r := exp(z) }
 	    { exp(x + iy) = exp(x).exp(iy) = exp(x).[cos(y) + i sin(y)] }
 	    var expz : real;
 	    begin
 	       expz := exp(z.re);
 	       cexp.re := expz * cos(z.im);
 	       cexp.im := expz * sin(z.im);
 	    end;

{function CExp(a: extended): complex;
  var
  ResCoord: TFR;
begin
  //ResCoord := CoreExp(RectCoord(FCoord.X, FCoord.Y));
  //FCoord.X := ResCoord.X;
  //FCoord.Y := ResCoord.Y;
  //Result := Self;
  result:= ResCoord.F;
end; }

 //var i: extended;



function TIT2.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

function TIT2.GetFR: TFR;
var
  frT2, frInt: TFR;
  //complextemp: complex;
begin
  assert(G >= 0, kError101);
  assert(t2 >= 0, kError101);
  assert(dmp >= 0, kError101);
  assert(omega >= 0, kError101);
  frT2.M := amplitude * G /
    sqrt(sqr(1 - sqr(omega * t2)) + sqr(2 * dmp * omega * t2)); ;
  if omega = 0 then
    frInt.M := infinity
  else
    frInt.M := amplitude * G / omega;
  if omega < 1 / t2 then
    frT2.phi := -arctan(2 * dmp * omega * t2 / (1 - sqr(omega * t2)))
  else
    frT2.phi := -pi - arctan(2 * dmp * omega * t2 / (1 - sqr(omega * t2)));
  frInt.phi := -90 * pi / 180;
  FFr.M := frT2.M * frInt.M;
  FFr.phi := frT2.phi + frInt.phi;
  if omega < 1 / t2 then
    FFr.phi := -90 * pi / 180 - arctan(2 * dmp * omega * t2 / (1 - sqr(omega * t2)))
  else
    FFr.phi := -90 * pi / 180 - pi - arctan(2 * dmp * omega * t2 / (1 - sqr(omega * t2)));
  //FFr.F := FFr.M * cexp(i * FFr.phi); { M and phi encoded in polar coordinates }
  //complextemp:= complexmulu(i,FFr.phi);
  FFr.F := complexmulu(cexp(complexmulu(i,FFr.phi)), FFr.M); { M and phi encoded in polar coordinates }

  result := FFR;
end;

constructor TIT2.Create;
begin
  inherited Create;
  G := 1;
  x1 := 0;
  x2 := 0;
  x3 := 0;
  fOutput := 0;
end;

destructor TIT2.Destroy;
begin
  inherited Destroy;
end;

procedure TIT2.simulate;
var
  a, b, c, d, e, f, k, omg: extended;
  xn1, xn2, xn3, a1, a2, w, tau1, tau2, b1, b2, x1n, x2n: extended;
begin
  if dmp < 1 then
    begin
      omg := 1 / t2;
      a := exp(-dmp * omg * delta);
      b := sqrt(1 - dmp * dmp) * omg;
      c := arctan(dmp * omg / b);
      d := omg * omg;
      e := d * omg / b * a * cos(b * delta + c);
      f := d / b * a * sin(b * delta);
      k := f * 2 * dmp / omg;
      xn1 := x1 * e / d - x2 * f + f * g * input;
      xn2 := x1 * f / d + x2 * e / d + x2 * k - (e / d - 1 + k) * G * input;
      xn3 := x3 + g * delta * xn2;
      x1 := xn1;
      x2 := xn2;
      x3 := xn3;
      fOutput := x3;
    end
  else if dmp = 1 then
    begin
      a := exp(-delta / t2);
      a1 := a - 1;
      a2 := a1 * t2;
      c := g * input;
      e := g * t2;
      x1n := a * x1 - a1 * c;
      x2n := e * x1 + a * x2 + c * g;
      fOutput := e * x1 + a2 * x2 + x3 + delta * c * g;
      x1 := x1n;
      x2 := x2n;
      x3 := fOutput;
    end
  else
  begin
    w := sqrt(dmp * dmp - 1) * t2;
    tau1 := dmp * t2 + w;
    tau2 := dmp * t2 - w;
    a := exp(-delta / tau1);
    a1 := a - 1;
    a2 := tau1 * a1;
    b := exp(-delta / tau2);
    b1 := b - 1;
    b2 := tau2 * b1;
    c := g * input;
    d := tau1 - tau2;
    e := g * tau1;
    x1n := a * x1 - a1 * c;
    x2n := (b - a) * e * x1 / d + b * x2 + (a2 - b2) * c * g / d;
    fOutput := (1 + (tau2 * b - tau1 * a) / d) * e * x1 + b2 * x2 + x3 +
      (delta + (tau1 * a2 - tau2 * b2) / d) * c * g;
    x1 := x1n;
    x2 := x2n;
    x3 := fOutput;
  end;
end;

{ TDT1 }

function TDT1.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

function TDT1.GetFR: TFR;
begin
  assert(G >= 0, kError101);
  assert(omega >= 0, kError101);
  FFr.M := amplitude * G * omega / sqrt(1 + sqr(omega) * sqr(t1));
  FFr.phi := arctan(1 / (omega * t1));
  //FFr.F := FFr.M * cexp(i * FFr.phi); { M and phi encoded in polar coordinates }
  FFr.F:= complexmulu(cexp(complexmulu(i,FFr.phi)), FFr.M); { M and phi encoded in polar coordinates }

  result := FFR;
end;

constructor TDT1.Create;
begin
  inherited Create;
  G := 1;
  x1 := 0;
  fOutput := 0;
end;

destructor TDT1.Destroy;
begin
  inherited Destroy;
end;

procedure TDT1.simulate;
var
  a: extended;
begin
  assert((G >= 0) and (t1 >=0), kError101);
  a := exp(-delta / t1);
  fOutput := x1 + G * input;
  x1 := a * x1 + G * input * (a - 1);
end;

{ TIT1 }

function TIT1.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

function TIT1.GetFR: TFR;
begin
  assert(G >= 0, kError101);
  assert(omega >= 0, kError101);
  FFr.M := amplitude * G / (omega * sqrt(1 + sqr(omega) * sqr(t1)));
  FFr.phi := -90 * pi / 180 - arctan(omega * t1);
  //FFr.F := FFr.M * cexp(i * FFr.phi); { M and phi encoded in polar coordinates }
  FFr.F := complexmulu(cexp(complexmulu(i,FFr.phi)), FFr.M); { M and phi encoded in polar coordinates }

  result := FFR;
end;

constructor TIT1.Create;
begin
  inherited Create;
  G := 1;
  x1 := 0;
  fOutput := 0;
end;

destructor TIT1.Destroy;
begin
  inherited Destroy;
end;

procedure TIT1.simulate;
var
  a, x1n: extended;
begin
  assert((G >= 0) and (t1 >=0), kError101);
  a := 1 - exp(-delta / t1);
  x1n := exp(-delta / t1) * x1 + G * a * input;
  fOutput := fOutput + delta * a * x1 + G * (delta - a * t1) * input;
  x1 := x1n;
end;

{ TInt }

function TInt2.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

function TInt2.GetFR: TFR;
begin
  assert(G >= 0, kError101);
  assert(omega >= 0, kError101);
  if omega = 0 then
    FFr.M := infinity
  else
    FFr.M := amplitude * G / omega;
  FFr.phi := -90 * pi / 180;
  //FFr.F := FFr.M * cexp(i * FFr.phi); { M and phi encoded in polar coordinates }
  FFr.F:= complexmulu(cexp(complexmulu(i,FFr.phi)), FFr.M); { M and phi encoded in polar coordinates }

  result := FFR;
end;

constructor TInt2.Create;
begin
  inherited Create;
  G := 1;
  fOutput := 0;
end;

destructor TInt2.Destroy;
begin
  inherited Destroy;
end;

procedure TInt2.simulate;
begin
  assert(G >= 0, kError101);
  fOutput := fOutput + G * delta * input;
end;

{ TPSub }

procedure TPSub.simulate;
begin
  assert(G >= 0, kError101);
  fOutput := G * (input1 - input2);
end;

function TPSub.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

constructor TPSub.Create;
begin
  inherited Create;
  G := 1;
  fOutput := 0;
end;

destructor TPSub.Destroy;
begin
  inherited Destroy;
end;

{ TPAdd }

procedure TPAdd.simulate;
begin
  assert(G >= 0, kError101);
  fOutput := G * (input1 + input2);
end;

function TPAdd.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

constructor TPAdd.Create;
begin
  inherited Create;
  G := 1;
  fOutput := 0;
end;

destructor TPAdd.Destroy;
begin
  inherited Destroy;
end;

{ TPMul }

procedure TPMul.simulate;
begin
  assert(G >= 0, kError101);
  fOutput := G * input1 * input2;
end;

function TPMul.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

constructor TPMul.Create;
begin
  inherited Create;
  G := 1;
  fOutput := 0;
end;

destructor TPMul.Destroy;
begin
  inherited Destroy;
end;

{ TPDiv }

procedure TPDiv.simulate;
begin
  assert(G >= 0, kError101);
  assert(input2 <> 0, kError105);
  fOutput := G * input1 / input2;
end;

function TPDiv.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

constructor TPDiv.Create;
begin
  inherited Create;
  G := 1;
  fOutput := 0;
end;

destructor TPDiv.Destroy;
begin
  inherited Destroy;
end;

{ TPT0 }

function TPT0.GetQueueLength: integer;
begin
  result := Length(xt)
end;

procedure TPT0.SetQueueLength(AValue: integer);
begin
  SetLength(xt, AValue);
end;

procedure TPT0.simulate;
var
  i: integer;
begin
  assert(nt >= 0, kError101);
  if nt = 0 then
    fOutput := input
  else
  begin
    for i := nt - 1 downto 1 do
      xt[i] := xt[i - 1];
    fOutput := G * xt[nt - 1];
    xt[0] := input;
  end;
end;

function TPT0.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

function TPT0.GetFR: TFR;
begin
  assert(G >= 0, kError101);
  assert(omega >= 0, kError101);
  FFr.M := amplitude * G;
  FFr.phi := -omega * nt * delta;
  //FFr.F := FFr.M * cexp(i * FFr.phi); { M and phi encoded in polar coordinates }
  FFr.F:= complexmulu(cexp(complexmulu(i,FFr.phi)), FFr.M); { M and phi encoded in polar coordinates }

  result := FFR;
end;

constructor TPT0.Create;
begin
  inherited Create;
  G := 1;
  fOutput := 0;
end;

destructor TPT0.Destroy;
begin
  inherited Destroy;
end;

{ TPT1 }

function TPT1.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

function TPT1.GetFR: TFR;
begin
  assert(G >= 0, kError101);
  assert(t1 >= 0, kError101);
  assert(omega >= 0, kError101);
  FFr.M := amplitude * G / sqrt(1 + sqr(omega) * sqr(t1));
  FFr.phi := -arctan(omega * t1);
  //FFr.F := FFr.M * cexp(i * FFr.phi); { M and phi encoded in polar coordinates }
  FFr.F:= complexmulu(cexp(complexmulu(i,FFr.phi)), FFr.M); { M and phi encoded in polar coordinates }

  result := FFR;
end;

procedure TPT1.simulate;
var
  f: extended;
begin
  assert((G >= 0) and (t1 >=0), kError101);
  f := exp(-delta / t1);
  fOutput := f * x1 + G * (1 - f) * input;
  x1 := fOutput;
end;

constructor TPT1.Create;
begin
  inherited Create;
  G := 1;
  x1 := 0;
  fOutput := 0;
end;

destructor TPT1.Destroy;
begin
  inherited Destroy;
end;

{ TPT2 }

function TPT2.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

function TPT2.GetFR: TFR;
begin
  assert(G >= 0, kError101);
  assert(t2 >= 0, kError101);
  assert(dmp >= 0, kError101);
  assert(omega >= 0, kError101);
  FFr.M := amplitude * G / sqrt(sqr(1 - sqr(omega * t2)) + sqr(2 * dmp * omega * t2));
  if omega < 1 / t2 then
    FFr.phi := -arctan(2 * dmp * omega * t2 / (1 - sqr(omega * t2)))
  else
    FFr.phi := -pi - arctan(2 * dmp * omega * t2 / (1 - sqr(omega * t2)));
  //FFr.F := FFr.M * cexp(i * FFr.phi); { M and phi encoded in polar coordinates }
  FFr.F:= complexmulu(cexp(complexmulu(i,FFr.phi)), FFr.M); { M and phi encoded in polar coordinates }

  result := FFR;
end;

constructor TPT2.Create;
begin
  inherited Create;
  G := 1;
  x1 := 0;
  x2 := 0;
  fOutput := 0;
end;

destructor TPT2.Destroy;
begin
  inherited Destroy;
end;

procedure TPT2.simulate;
var
  a, b, c, d, e, f, h, o, k, omg: extended;
  xn1, xn2, x1n, x2n, tau1, tau2: extended;
begin
  assert(G >= 0, kError101);
  assert(t2 >= 0, kError101);
  assert(dmp >= 0, kError101);
  if dmp < 1 then
    begin
      omg := 1 / t2;
      a := exp(-delta * delta * omg);
      b := sqrt(1 - dmp * dmp) * omg;
      c := arctan(dmp * omg / b);
      d := omg * omg;
      e := d * omg / b * a * cos(b * delta + c);
      f := d / b * a * sin(b * delta);
      k := f * 2 * dmp / omg;
      xn1 := x1 * e / d - x2 * f + f * g * input;
      xn2 := x1 * f / d + x2 * e / d + x2 * k - (e / d - 1 + k) * G * input;
      x1 := xn1;
      x2 := xn2;
      fOutput := x2;
    end
  else if dmp = 1 then
    begin
      a := exp(-delta / t2);
      x1n := a * x1 + G * (1 - a) * input;
      x2n := a * x2 + (1 - a) * x1n;
      x1 := x1n;
      x2 := x2n;
      fOutput := x2;
    end
  else
    begin
      omg := 1 / t2;
      a := sqrt(dmp * dmp - 1);
      tau1 := (dmp + a) / omg;
      tau2 := (dmp - a) / omg;
      b := exp(-delta / tau1);
      c := exp(-delta / tau2);
      d := b - c;
      e := tau1 - tau2;
      f := x2 - G * input;
      k := 2 * dmp * omg;
      h := tau1 * c - tau2 * b;
      o := omg * omg;
      xn1 := (h * x1 - d * f) / e;
      xn2 := (d * (x1 + g * f) + h * f * o) / (o * e) + G * input;
      x1 := xn1;
      x2 := xn2;
      fOutput := x2;
    end;
end;

  { TP }

function TP2.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

function TP2.GetFR: TFR;
begin
  assert(G >= 0, kError101);
  FFr.M := amplitude * G;
  FFr.phi := 0;
  //FFr.F := FFr.M * cexp(i * FFr.phi); { M and phi encoded in polar coordinates }
  FFr.F:= complexmulu(cexp(complexmulu(i,FFr.phi)), FFr.M); { M and phi encoded in polar coordinates }

  result := FFR;
end;

procedure TP2.simulate;
begin
  assert(G >= 0, kError101);
  fOutput := input * G;
end;

constructor TP2.Create;
begin
  inherited Create;
  G := 1;
  fOutput := 0;
end;

destructor TP2.Destroy;
begin
  inherited Destroy;
end;

  { TBlock }

destructor TBlock.Destroy;
begin
  inherited Destroy;
end;

end.

{References:  }

{1. Röhler, R., "Biologische Kybernetik", B. G. Teubner, Stuttgart 1973 }

{2. Neuber, H., "Simulation von Regelkreisen auf Personal Computern  }
{   in Pascal und Fortran 77", IWT, Vaterstetten 1989 }

{3. Lutz H. and Wendt, W., "Taschenbuch der Regelungstechnik" }
{   Verlag Harri Deutsch, Frankfurt am Main 2005 }

