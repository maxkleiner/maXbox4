unit lifeblocks;

{ CyberUnits }

{ Object Pascal units for computational cybernetics }

{ LifeBlocks: Metabricks for information processing structures in organisms }

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

//{$mode objfpc}
{$H+}
{$ASSERTIONS ON}

interface

uses
  Classes, SysUtils, bricks;

type

  { TASIA }
  { ASIA element (analog signal memory with intrincis adjustment) }

  TASIA = class(TBlock)
  protected
    PT1Analog: TPT1;
    FAlpha, FBeta: extended;
    function SimAndGetOutput: extended;
    procedure SetAlpha(AValue: extended);
    procedure SetBeta(AValue: extended);
    procedure SetDelta(AValue: extended);
    procedure SetX1(AValue: extended);
    function GetX1: extended;
  public
    input: extended;
    constructor Create;
    destructor Destroy; override;
    property alpha: extended read FAlpha write SetAlpha;
    property beta: extended read FBeta write SetBeta;
    property delta: extended write SetDelta;
    property x1: extended read GetX1 write SetX1;
    property output: extended read Foutput;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TMiMe }
  { Michaelis-Menten element }

  TMiMe = class(TBlock)
  protected
    function SimAndGetOutput: extended;
  public
    input: extended;
    G, D: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

  { TNoCoDI }
  { Non-competitive divisive inhibition }

  TNoCoDI = class(TBlock)
  protected
    function SimAndGetOutput: extended;
  public
    input1, input2: extended;
    constructor Create;
    destructor Destroy; override;
    property output: extended read Foutput;
    procedure simulate; override;
    property simOutput: extended read SimAndGetOutput;
  end;

implementation

{ TNoCoDI }

function TNoCoDI.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

constructor TNoCoDI.Create;
begin
  inherited create;
end;

destructor TNoCoDI.Destroy;
begin
  inherited Destroy;
end;

procedure TNoCoDI.simulate;
begin
  assert(input2 <> -1, kError102);
  fOutput := input1 / (1 + input2);
end;

{ TMiMe }

function TMiMe.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

constructor TMiMe.Create;
begin
  inherited Create;
  D := 1;
end;

destructor TMiMe.Destroy;
begin
  inherited Destroy;
end;

procedure TMiMe.simulate;
begin
  assert(input <> -D, kError102);
  fOutput := G * input / (D + input);
end;

{ TASIA }

procedure TASIA.SetAlpha(AValue: extended);
begin
  FAlpha := AValue;
  PT1Analog.G := FAlpha / FBeta;
end;

procedure TASIA.SetBeta(AValue: extended);
begin
  FBeta := AValue;
  PT1Analog.G := FAlpha / FBeta;
  PT1Analog.t1 := 1 / FBeta;
end;

procedure TASIA.SetDelta(AValue: extended);
begin
  PT1Analog.delta := AValue;
end;

procedure TASIA.SetX1(AValue: extended);
begin
  PT1Analog.x1 := AValue;
end;

function TASIA.GetX1: extended;
begin
  Result := PT1Analog.x1;
end;

function TASIA.SimAndGetOutput: extended;
begin
  simulate;
  result := fOutput;
end;

constructor TASIA.Create;
begin
  inherited create;
  PT1Analog := TPT1.Create;
  FAlpha := 1;
  SetBeta(1);
end;

destructor TASIA.Destroy;
begin
  PT1Analog.Destroy;
  inherited Destroy;
end;

procedure TASIA.simulate;
begin
  assert(FBeta <> 0, kError102);
  PT1Analog.input := input;
  fOutput := PT1Analog.simOutput;
end;

end.

{References:  }

{1. Dietrich JW 2000 Signal Storage in Metabolic Pathways: The ASIA Element. }
{    kybernetiknet 1:1-9  }

{2. Dietrich JW, Tesche A, Pickardt CR, Mitzdorf U 2004 Thyrotropic Feedback }
{   Control: Evidence for an Additional Ultrashort Feedback Loop from Fractal }
{   Analysis. Cybernetics and Systems 35:315-331.}

{3. Dietrich, J. W. und B. O. Boehm (2006). Equilibrium behaviour of }
{   feedback-coupled physiological saturation kinetics. In: Cybernetics and }
{   Systems 2006. R. Trappl (Hrsg). Vienna, Austrian Society for Cybernetic }
{   Studies. 1: 269-74. }
