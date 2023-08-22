//------------------------------------------------------------------------------
//
// HSL - RGB colour model conversions
//
// These four functions can be used to convert between the RGB and HSL colour
// models.  RGB values are represented using the 0-255 Windows convention and
// always encapsulated in a TColor 32 bit value.  HSL values are available as
// either 0 to 1 floating point (double) values or as a 0 to a defined integer
// value.  The colour common dialog box uses 0 to 240 by example.
//
// The code is based on that found (in C) on:
//
//   http:/www.r2m.com/win-developer-faq/graphics/8.html
//
// Grahame Marsh 12 October 1997
//
// Freeware - you get it for free, I take nothing, I make no promises!
//
// Please feel free to contact me: grahame.s.marsh@corp.courtaulds.co.uk
//
// Revison History:
//    Version 1.00 - initial release  12-10-1997
//
//------------------------------------------------------------------------------

unit HSLUtils;

interface

uses
  Windows, Graphics;

var
  HSLRange: integer = 240;

function ARGB(a, r, g, b: Byte): Cardinal;

function GetAValue(argb: DWORD): Byte; {$IF CompilerVersion > 20} inline; {$IFEND}

function GetRValue(argb: DWORD): Byte; {$IF CompilerVersion > 20} inline; {$IFEND}

function GetGValue(argb: DWORD): Byte; {$IF CompilerVersion > 20} inline; {$IFEND}

function GetBValue(argb: DWORD): Byte; {$IF CompilerVersion > 20} inline; {$IFEND}

function GetABGRAValue(abgr: DWORD): Byte; {$IF CompilerVersion > 20} inline; {$IFEND}

function GetABGRRValue(abgr: DWORD): Byte; {$IF CompilerVersion > 20} inline; {$IFEND}

function GetABGRGValue(abgr: DWORD): Byte; {$IF CompilerVersion > 20} inline; {$IFEND}

function GetABGRBValue(abgr: DWORD): Byte; {$IF CompilerVersion > 20} inline; {$IFEND}

// convert a HSL value into a RGB in a TColor
// HSL values are 0.0 to 1.0 double
function HSLtoRGB (H, S, L: double): TColor; inline;

function AHSLtoARGB (A, H, S, L: double): Cardinal;

// convert a HSL value into a RGB in a TColor
// SL values are 0 to the HSLRange variable
// H value is to HSLRange-1
function HSLRangeToRGB (H, S, L : integer): TColor;

// convert a RGB value (as TColor) into HSL
// HSL values are 0.0 to 1.0 double
procedure ARGBtoAHSL (ARGB: TColor; var A, H, S, L : double);

procedure ABGRtoAHSL (ABGR: TColor; var A, H, S, L : double);

// convert a RGB value (as TColor) into HSL
// SL values are 0 to the HSLRange variable
// H value is to HSLRange-1
procedure RGBtoHSLRange (RGB: TColor; var H, S, L : integer);

implementation

function ARGB(a, r, g, b: Byte): Cardinal;
var
    _a, _r, _g, _b: Cardinal;
begin
  _a := a shl 24;
  _r := r shl 16;
  _g := g shl 8;
  _b := b;
  Result := _a OR _r OR _g OR _b;
end;

function GetAValue(argb: DWORD): Byte;
begin
  Result := Byte(argb shr 24);
end;

function GetRValue(argb: DWORD): Byte;
begin
  Result := Byte(argb shr 16);
end;

function GetGValue(argb: DWORD): Byte;
begin
  Result := Byte(argb shr 8);
end;

function GetBValue(argb: DWORD): Byte;
begin
  Result := Byte(argb);
end;

function GetABGRAValue(abgr: DWORD): Byte;
begin
  Result := Byte(abgr shr 24);
end;

function GetABGRRValue(abgr: DWORD): Byte;
begin
  Result := Byte(abgr);
end;

function GetABGRGValue(abgr: DWORD): Byte;
begin
  Result := Byte(abgr shr 8);
end;

function GetABGRBValue(abgr: DWORD): Byte;
begin
  Result := Byte(abgr shr 16);
end;

(*
function HSLtoRGB (H, S, L: double): TColor;
var
  M1, M2: double;

  function HueToColourValue (Hue: double) : byte;
  var
    V : double;
  begin
    if Hue < 0 then
      Hue := Hue + 1
    else
      if Hue > 1 then
        Hue := Hue - 1;

    if 6 * Hue < 1 then
      V := M1 + (M2 - M1) * Hue * 6
    else
      if 2 * Hue < 1 then
        V := M2
      else
        if 3 * Hue < 2 then
          V := M1 + (M2 - M1) * (2/3 - Hue) * 6
        else
          V := M1;
    Result := round (255 * V)
  end;

var
  R, G, B: byte;
begin
  if S = 0 then
  begin
    R := round (255 * L);
    G := R;
    B := R
  end else begin
    if L <= 0.5 then
      M2 := L * (1 + S)
    else
      M2 := L + S - L * S;
    M1 := 2 * L - M2;
    R := HueToColourValue (H + 1/3);
    G := HueToColourValue (H);
    B := HueToColourValue (H - 1/3)
  end;

  Result := RGB (R, G, B)
end;
*)

  function HueToColourValue (Hue: double; M1, M2: double) : byte; inline;
  var
    V : double;
  begin
    if Hue < 0 then
      Hue := Hue + 1
    else
      if Hue > 1 then
        Hue := Hue - 1;

    if 6 * Hue < 1 then
      V := M1 + (M2 - M1) * Hue * 6
    else
      if 2 * Hue < 1 then
        V := M2
      else
        if 3 * Hue < 2 then
          V := M1 + (M2 - M1) * (2/3 - Hue) * 6
        else
          V := M1;
    Result := round (255 * V)
  end;

function HSLtoRGB (H, S, L: double): TColor;

var
  R, G, B: byte;
  M1, M2: double;
begin
  if S = 0 then
  begin
    R := round (255 * L);
    G := R;
    B := R
  end else begin
    if L <= 0.5 then
      M2 := L * (1 + S)
    else
      M2 := L + S - L * S;
    M1 := 2 * L - M2;
    R := HueToColourValue (H + 1/3, M1, M2);
    G := HueToColourValue (H, M1, M2);
    B := HueToColourValue (H - 1/3, M1, M2);
  end;

  Result := RGB (R, G, B)
end;

function AHSLtoARGB (A, H, S, L: double): Cardinal;
var
  M1, M2: double;

  function HueToColourValue (Hue: double) : byte;
  var
    V : double;
  begin
    if Hue < 0 then
      Hue := Hue + 1
    else
      if Hue > 1 then
        Hue := Hue - 1;

    if 6 * Hue < 1 then
      V := M1 + (M2 - M1) * Hue * 6
    else
      if 2 * Hue < 1 then
        V := M2
      else
        if 3 * Hue < 2 then
          V := M1 + (M2 - M1) * (2/3 - Hue) * 6
        else
          V := M1;
    Result := round (255 * V)
  end;

var
  _A, R, G, B: byte;
begin
  if S = 0 then
  begin
    R := round (255 * L);
    G := R;
    B := R
  end else begin
    if L <= 0.5 then
      M2 := L * (1 + S)
    else
      M2 := L + S - L * S;
    M1 := 2 * L - M2;
    R := HueToColourValue (H + 1/3);
    G := HueToColourValue (H);
    B := HueToColourValue (H - 1/3)
  end;

  _A := Byte(Trunc(A * 255));

  Result := ARGB (_A, R, G, B);
end;

function HSLRangeToRGB (H, S, L : integer): TColor;
begin
  Result := HSLToRGB (H / (HSLRange-1), S / HSLRange, L / HSLRange)
end;

// Convert RGB value (0-255 range) into HSL value (0-1 values)

procedure ABGRtoAHSL (ABGR: TColor; var A, H, S, L : double);

  function Max (a, b : double): double;
  begin
    if a > b then
      Result := a
    else
      Result := b
  end;

  function Min (a, b : double): double;
  begin
    if a < b then
      Result := a
    else
      Result := b
  end;

var
  AHSL, R, G, B, D, Cmax, Cmin: double;
begin
  AHSL := GetABGRAValue(ABGR) / 255;
  R := GetABGRRValue (ABGR) / 255;
  G := GetABGRGValue (ABGR) / 255;
  B := GetABGRBValue (ABGR) / 255;
  Cmax := Max (R, Max (G, B));
  Cmin := Min (R, Min (G, B));

  A := AHSL;

// calculate luminosity
  L := (Cmax + Cmin) / 2;

  if Cmax = Cmin then  // it's grey
  begin
    H := 0; // it's actually undefined
    S := 0
  end else begin
    D := Cmax - Cmin;

// calculate Saturation
    if L < 0.5 then
      S := D / (Cmax + Cmin)
    else
      S := D / (2 - Cmax - Cmin);

// calculate Hue
    if R = Cmax then
      H := (G - B) / D
    else
      if G = Cmax then
        H  := 2 + (B - R) /D
      else
        H := 4 + (R - G) / D;

    H := H / 6;
    if H < 0 then
      H := H + 1
  end
end;

procedure ARGBtoAHSL (ARGB: TColor; var A, H, S, L : double);

  function Max (a, b : double): double;
  begin
    if a > b then
      Result := a
    else
      Result := b
  end;

  function Min (a, b : double): double;
  begin
    if a < b then
      Result := a
    else
      Result := b
  end;

var
  AHSL, R, G, B, D, Cmax, Cmin: double;
begin
  AHSL := GetAValue(ARGB) / 255;
  R := GetRValue (ARGB) / 255;
  G := GetGValue (ARGB) / 255;
  B := GetBValue (ARGB) / 255;
  Cmax := Max (R, Max (G, B));
  Cmin := Min (R, Min (G, B));

  A := AHSL;

// calculate luminosity
  L := (Cmax + Cmin) / 2;

  if Cmax = Cmin then  // it's grey
  begin
    H := 0; // it's actually undefined
    S := 0
  end else begin
    D := Cmax - Cmin;

// calculate Saturation
    if L < 0.5 then
      S := D / (Cmax + Cmin)
    else
      S := D / (2 - Cmax - Cmin);

// calculate Hue
    if R = Cmax then
      H := (G - B) / D
    else
      if G = Cmax then
        H  := 2 + (B - R) /D
      else
        H := 4 + (R - G) / D;

    H := H / 6;
    if H < 0 then
      H := H + 1
  end
end;

procedure RGBtoHSLRange (RGB: TColor; var H, S, L : integer);
var
  Ad, Hd, Sd, Ld: double;
begin
  ARGBtoAHSL (RGB, Ad, Hd, Sd, Ld);
  H := round (Hd * (HSLRange-1));
  S := round (Sd * HSLRange);
  L := round (Ld * HSLRange);
end;

end.



