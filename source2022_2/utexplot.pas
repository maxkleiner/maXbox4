{ ******************************************************************
                 Plotting routines for LaTeX/PSTricks
  ****************************************************************** }

unit utexplot;

interface

uses
  utypes, umath, uminmax, uround, ustrings;

function TeX_InitGraphics(FileName          : String;
                          PgWidth, PgHeight : Integer;
                          Header            : Boolean) : Boolean;
{ ------------------------------------------------------------------
  Initializes the LaTeX file

  FileName          = Name of LaTeX file (e. g. 'figure.tex')
  PgWidth, PgHeight = Page width and height in cm
  Header            = True to write the preamble in the file
  ------------------------------------------------------------------ }

procedure TeX_SetWindow(X1, X2, Y1, Y2 : Integer; GraphBorder : Boolean);
{ ------------------------------------------------------------------
  Sets the graphic window

  X1, X2, Y1, Y2 : Window coordinates in % of maximum
  GraphBorder    : Flag for drawing the window border
  ------------------------------------------------------------------ }

procedure TeX_LeaveGraphics(Footer : Boolean);
{ ------------------------------------------------------------------
  Close the LaTeX file

  Footer = Flag for writing the 'end of document' section
  ------------------------------------------------------------------ }

procedure TeX_SetOxScale(Scale : TScale; OxMin, OxMax, OxStep : Float);
{ ------------------------------------------------------------------
  Sets the scale on the Ox axis
  ------------------------------------------------------------------ }

procedure TeX_SetOyScale(Scale : TScale; OyMin, OyMax, OyStep : Float);
{ ------------------------------------------------------------------
  Sets the scale on the Oy axis
  ------------------------------------------------------------------ }

procedure TeX_SetGraphTitle(Title : String);
{ ------------------------------------------------------------------
  Sets the title for the graph
  ------------------------------------------------------------------ }

procedure TeX_SetOxTitle(Title : String);
{ ------------------------------------------------------------------
  Sets the title for the Ox axis
  ------------------------------------------------------------------ }

procedure TeX_SetOyTitle(Title : String);
{ ------------------------------------------------------------------
  Sets the title for the Oy axis
  ------------------------------------------------------------------ }

procedure TeX_PlotOxAxis;
{ ------------------------------------------------------------------
  Plots the horizontal axis
  ------------------------------------------------------------------ }

procedure TeX_PlotOyAxis;
{ ------------------------------------------------------------------
  Plots the vertical axis
  ------------------------------------------------------------------ }

procedure TeX_PlotGrid(Grid : TGrid);
{ ------------------------------------------------------------------
  Plots a grid on the graph
  ------------------------------------------------------------------ }

procedure TeX_WriteGraphTitle;
{ ------------------------------------------------------------------
  Writes the title of the graph
  ------------------------------------------------------------------ }

function TeX_SetMaxCurv(NCurv : Byte) : Boolean;
{ ------------------------------------------------------------------
  Sets the maximum number of curves and re-initializes their
  parameters
  ------------------------------------------------------------------ }

procedure TeX_SetPointParam(CurvIndex, Symbol, Size : Integer);
{ ------------------------------------------------------------------
  Sets the point parameters for curve # CurvIndex
  ------------------------------------------------------------------ }

procedure TeX_SetLineParam(CurvIndex, Style : Integer;
                           Width : Float; Smooth : Boolean);
{ ------------------------------------------------------------------
  Sets the line parameters for curve # CurvIndex
  ------------------------------------------------------------------ }

procedure TeX_SetCurvLegend(CurvIndex : Integer; Legend : String);
{ ------------------------------------------------------------------
  Sets the legend for curve # CurvIndex
  ------------------------------------------------------------------ }

procedure TeX_SetCurvStep(CurvIndex, Step : Integer);
{ ------------------------------------------------------------------
  Sets the step for curve # CurvIndex
  ------------------------------------------------------------------ }

procedure TeX_PlotCurve(X, Y : TVector; Lb, Ub, CurvIndex : Integer);
{ ------------------------------------------------------------------
  Plots a curve
  ------------------------------------------------------------------
  Input parameters : X, Y      = point coordinates
                     Lb, Ub    = indices of first and last points
                     CurvIndex = index of curve parameters
  ------------------------------------------------------------------ }

procedure TeX_PlotCurveWithErrorBars(X, Y, S : TVector;
                                     Ns, Lb, Ub, CurvIndex : Integer);
{ ------------------------------------------------------------------
  Plots a curve with error bars
  ------------------------------------------------------------------
  Input parameters : X, Y      = point coordinates
                     S         = errors
                     Lb, Ub    = indices of first and last points
                     CurvIndex = index of curve parameters
  ------------------------------------------------------------------ }

procedure TeX_PlotFunc(Func : TFunc; X1, X2 : Float;
                       Npt : Integer; CurvIndex : Integer);
{ ------------------------------------------------------------------
  Plots a function
  ------------------------------------------------------------------
  Input parameters:
    Func      = function to be plotted
    X1, X2    = abscissae of 1st and last point to plot
    Npt       = number of points
    CurvIndex = index of curve parameters (Width, Style, Smooth)
  ------------------------------------------------------------------
  The function must be programmed as :
  function Func(X : Float) : Float;
  ------------------------------------------------------------------ }

procedure TeX_WriteLegend(NCurv : Integer; ShowPoints, ShowLines : Boolean);
{ ------------------------------------------------------------------
  Writes the legends for the plotted curves
  ------------------------------------------------------------------
  NCurv      : number of curves (1 to MaxCurv)
  ShowPoints : for displaying points
  ShowLines  : for displaying lines
  ------------------------------------------------------------------ }

procedure TeX_ConRec(Nx, Ny, Nc : Integer;
                     X, Y, Z    : TVector;
                     F          : TMatrix);
{ ------------------------------------------------------------------
  Contour plot
  Adapted from Paul Bourke, Byte, June 1987
  http://astronomy.swin.edu.au/~pbourke/projection/conrec/
  ------------------------------------------------------------------
  Input parameters:
  Nx, Ny             = number of steps on Ox and Oy
  Nc                 = number of contour levels
  X[0..Nx], Y[0..Ny] = point coordinates
  Z[0..(Nc - 1)]     = contour levels in increasing order
  F[0..Nx, 0..Ny]    = function values, such that F[I,J] is the
                       function value at (X[I], Y[I])
  ------------------------------------------------------------------ }

function Xcm(X : Float) : Float;
{ ------------------------------------------------------------------
  Converts user coordinate X to cm
  ------------------------------------------------------------------ }

function Ycm(Y : Float) : Float;
{ ------------------------------------------------------------------
  Converts user coordinate Y to cm
  ------------------------------------------------------------------ }

implementation

const
  MaxWidth  = 20;       { Max. width in cm  }
  MaxHeight = 20;       { Max. height in cm }
  MaxSymbol = 9;        { Max. number of symbols for plotting curves }
  Eps       = 1.0E-10;  { Lower limit for an axis label }

var
  MaxCurv : Byte = 0;

type
  TAxis = record        { Coordinate axis }
    Scale : TScale;
    Min   : Float;
    Max   : Float;
    Step  : Float;
  end;

  TPointParam = record  { Point parameters                            }
    Symbol : Integer;   { Symbol: 0: point (.)                        }
    Size   : Integer;   {         1: solid circle    2: open circle   }
  end;                  {         3: solid square    4: open square   }
                        {         5: solid triangle  6: open triangle }
                        {         7: plus (+)        8: multiply (x)  }
                        {         9: star (* )                        }

  TLineParam = record   { Line parameters }
    Style  : Integer;   { 0: none, 1: solid, 2: dotted, 3: dashed }
    Width  : Float;     { Width in tenth of millimeter (0 = default) }
    Smooth : Boolean;   { Smoothed curve }
  end;

  TCurvParam = record          { Curve parameters }
    PointParam : TPointParam;
    LineParam  : TLineParam;
    Legend     : Str30;        { Legend of curve }
    Step       : Integer;      { Plot 1 point every Step points }
  end;

var
  F              : Text;     { LaTeX file }
  PageWidth,
  PageHeight     : Integer;  { Page width and height in cm }
  XminCm, YminCm : Float;    { Coord. of lower left corner in cm }
  XmaxCm, YmaxCm : Float;    { Coord. of upper right corner in cm }
  FactX, FactY   : Float;    { Scaling factors }
  XAxis, YAxis   : TAxis;
  XTitle, YTitle : String;
  GraphTitle     : String;
  CurvParam      : array[1..255] of ^TCurvParam;

procedure InitCurve(I : Byte);
{ Initializes curve I }
begin
  { Allocate array element }
  GetMem(CurvParam[I], SizeOf(TCurvParam));
  if CurvParam[I] = nil then Exit;

  { Initialize curve parameters }
  with CurvParam[I]^ do
    begin
        PointParam.Symbol := (I - 1) mod MaxSymbol + 1;
        PointParam.Size := 2;
        LineParam.Width := 2;      { default width }
        LineParam.Style := 1;      { solid }
        LineParam.Smooth := False;
        Legend := 'Y' + LTrim(IntStr(I));
        Step := 1;
    end;
end;

procedure DelCurve(I : Byte);
{ Deletes curve I }
begin
  if CurvParam[I] <> nil then
    begin
      FreeMem(CurvParam[I], SizeOf(TCurvParam));
      CurvParam[I] := nil;
    end;
end;

function TeX_SetMaxCurv(NCurv : Byte) : Boolean;
var
  I  : Byte;
  Ok : Boolean;
begin
  if NCurv = MaxCurv then
    begin
      TeX_SetMaxCurv := True;
      Exit;
    end;

  if NCurv < MaxCurv then
    begin
      for I := Succ(NCurv) to MaxCurv do
        DelCurve(I);
      MaxCurv := NCurv;
      TeX_SetMaxCurv := True;
      Exit;
    end;

  I := Succ(MaxCurv);
  repeat
    InitCurve(I);
    Ok := (CurvParam[I] <> nil);
    Inc(I);
  until (I > NCurv) or (not Ok);

  if Ok then
    MaxCurv := NCurv;

  TeX_SetMaxCurv := Ok;
end;

function TeX_InitGraphics(FileName          : String;
                          PgWidth, PgHeight : Integer;
                          Header            : Boolean) : Boolean;
begin
  Assign(F, FileName);

  if Header then
    begin
      Rewrite(F);
      WriteLn(F, '\documentclass[12pt,a4paper]{article}');
      WriteLn(F, '\usepackage{pst-plot}');
      WriteLn(F, '\pagestyle{empty}');
      WriteLn(F, '\begin{document}');
      WriteLn(F);
    end
  else
    Append(F);

  if (PgWidth > 0) and (PgWidth <= MaxWidth) then
    PageWidth := PgWidth;

  if (PgHeight > 0) and (PgHeight <= MaxHeight) then
    PageHeight := PgHeight;

  WriteLn(F, '\begin{pspicture}(', PageWidth, ',', PageHeight, ')');

  { Allocate memory for curve parameters }
  TeX_InitGraphics := TeX_SetMaxCurv(MaxSymbol);
end;

procedure WriteCoord(X, Y : Float);
{ Writes the coordinates (in cm) of a point }
begin
  Write(F, '(', X:5:2, ',', Y:5:2, ')');
end;

procedure TeX_SetWindow(X1, X2, Y1, Y2 : Integer; GraphBorder : Boolean);
var
  R : Float;
begin
  XminCm := 0;
  XmaxCm := PageWidth;
  YminCm := 0;
  YmaxCm := PageHeight;

  if (X1 >= 0) and (X2 <= 100) and (X1 < X2) then
    begin
      R := 0.01 * XmaxCm;
      XminCm := Round(X1 * R);
      XmaxCm := Round(X2 * R);
    end;

  if (Y1 >= 0) and (Y2 <= 100) and (Y1 < Y2) then
    begin
      R := 0.01 * YmaxCm;
      YminCm := Round(Y1 * R);
      YmaxCm := Round(Y2 * R);
    end;

  XAxis.Scale := LinScale;
  XAxis.Min   := 0.0;
  XAxis.Max   := 1.0;
  XAxis.Step  := 0.2;

  YAxis.Scale := LinScale;
  YAxis.Min   := 0.0;
  YAxis.Max   := 1.0;
  YAxis.Step  := 0.2;

  FactX := (XmaxCm - XminCm) / (XAxis.Max - XAxis.Min);
  FactY := (YmaxCm - YminCm) / (YAxis.Max - YAxis.Min);

  XTitle := 'X';
  YTitle := 'Y';

  GraphTitle := '';

  if GraphBorder then
    begin
      Write(F, '\pspolygon');
      WriteCoord(XminCm, YminCm);
      WriteCoord(XmaxCm, YminCm);
      WriteCoord(XmaxCm, YmaxCm);
      WriteCoord(XminCm, YmaxCm);
      WriteLn(F);
    end;
end;

procedure TeX_LeaveGraphics(Footer : Boolean);
begin
  WriteLn(F, '\end{pspicture}');

  if Footer then
    begin
      WriteLn(F);
      WriteLn(F, '\end{document}');
    end;

  WriteLn(F);
  Close(F);

  TeX_SetMaxCurv(0);
end;

procedure TeX_SetOxScale(Scale : TScale; OxMin, OxMax, OxStep : Float);
begin
  XAxis.Scale := Scale;
  case Scale of
    LinScale :
      begin
        if OxMin < OxMax then
          begin
            XAxis.Min := OxMin;
            XAxis.Max := OxMax;
          end;
        if OxStep > 0.0 then XAxis.Step := OxStep;
      end;
    LogScale :
      begin
        if (OxMin > 0.0) and (OxMin < OxMax) then
          begin
            XAxis.Min := Floor(Log10(OxMin));
            XAxis.Max := Ceil(Log10(OxMax));
          end;
        XAxis.Step := 1.0;
      end;
  end;
  FactX := (XmaxCm - XminCm) / (XAxis.Max - XAxis.Min);
end;

procedure TeX_SetOyScale(Scale : TScale; OyMin, OyMax, OyStep : Float);
begin
  YAxis.Scale := Scale;
  case Scale of
    LinScale :
      begin
        if OyMin < OyMax then
          begin
            YAxis.Min := OyMin;
            YAxis.Max := OyMax;
          end;
        if OyStep > 0.0 then YAxis.Step := OyStep;
      end;
    LogScale :
      begin
        if (OyMin > 0.0) and (OyMin < OyMax) then
          begin
            YAxis.Min := Floor(Log10(OyMin));
            YAxis.Max := Ceil(Log10(OyMax));
          end;
        YAxis.Step := 1.0;
      end;
  end;
  FactY := (YmaxCm - YminCm) / (YAxis.Max - YAxis.Min);
end;

procedure TeX_SetGraphTitle(Title : String);
begin
  GraphTitle := Title;
end;

procedure TeX_SetOxTitle(Title : String);
begin
  XTitle := Title;
end;

procedure TeX_SetOyTitle(Title : String);
begin
  YTitle := Title;
end;

function Xcm(X : Float) : Float;
begin
  Xcm := XminCm + FactX * (X - XAxis.Min);
end;

function Ycm(Y : Float) : Float;
begin
  Ycm := YminCm + FactY * (Y - YAxis.Min);
end;

procedure WriteLine(X1, Y1, X2, Y2, Width : Float; Style : String);
{ ------------------------------------------------------------------
  Writes a line between two points

  X1, Y1 : coordinates of first point
  X2, Y2 : coordinates of second point
  Width  : width in units of 0.01 cm (ignored if <= 0)
  Style  : line style (must be 'solid', 'dotted' or 'dashed')
  ------------------------------------------------------------------ }

begin
  Write(F, '\psline');

  if (Width > 0.0) or (Style <> '') then
    begin
      Write(F, '[');

      if Width > 0.0 then
        begin
          Write(F, 'linewidth=', Width:5:2);
          if Style <> '' then Write(F, ', ');
        end;

      if Style <> '' then
        Write(F, 'linestyle=', Style);

      Write(F, ']');
    end;

  WriteCoord(X1, Y1);
  WriteCoord(X2, Y2);
  WriteLn(F);
end;

procedure WriteText(Place : String; X, Y : Float; S : String);
{ ------------------------------------------------------------------
  Writes a text

  Place : defines the position of point (X,Y) with respect
          to the box enclosing the text

          the possible values are
          'tl', 't', 'tr', 'l', 'r', 'Bl', 'B', 'Br', 'bl', 'b', 'br'
          according to the following scheme:

                             t
               tl +---------------------+ tr
                  |                     |
                  |                     |
                l |                     | r
                  |                     |
               Bl |----------B----------| Br
               bl +---------------------+ br
                             b

  X, Y  : position of text

  S     : text to be written
  ------------------------------------------------------------------ }

begin
  Write(F, '\rput[', Place, ']');
  WriteCoord(X, Y);
  WriteLn(F, '{', S, '}');
end;

procedure WriteNumber(Place : String; X, Y, Z : Float);
{ Writes number Z at position (X, Y) }
begin
  Write(F, '\rput[', Place, ']');
  WriteCoord(X, Y);
  WriteLn(F, '{', Trim(FloatStr(Z)), '}');
end;

procedure TeX_PlotOxAxis;
var
  W, X, Xc, Z : Float;
  N, I, J     : Integer;
begin
  WriteLine(XminCm, YminCm, XmaxCm, YminCm, 0.0, '');

  N := Round((XAxis.Max - XAxis.Min) / XAxis.Step);  { Nb of intervals }
  X := XAxis.Min;                                    { Tick mark position }

  for I := 0 to N do  { Label axis }
    begin
      if (XAxis.Scale = LinScale) and (Abs(X) < Eps) then X := 0.0;

      Xc := Xcm(X);
      WriteLine(Xc, YminCm, Xc, YminCm - 0.25, 0.0, '');  { Tick mark }

      if XAxis.Scale = LinScale then Z := X else Z := Exp10(X);

      WriteNumber('t', Xc, YminCm - 0.35, Z);        { Label }

      if (XAxis.Scale = LogScale) and (I < N) then
        for J := 2 to 9 do                           { Plot minor divisions }
          begin                                      { on logarithmic scale }
            W := X + Log10(J);
            Xc := Xcm(W);
            WriteLine(Xc, YminCm, Xc, YminCm - 0.15, 0.0, '');
          end;

      X := X + XAxis.Step;
    end;

  { Write axis title }
  if XTitle <> '' then
    WriteText('t', 0.5 * (XminCm + XmaxCm), YminCm - 1.0, XTitle);
end;

procedure TeX_PlotOyAxis;
var
  W, Y, Yc, Z : Float;
  N, I, J     : Integer;
begin
  WriteLine(XminCm, YminCm, XminCm, YmaxCm, 0.0, '');

  N := Round((YAxis.Max - YAxis.Min) / YAxis.Step);
  Y := YAxis.Min;

  for I := 0 to N do
    begin
      if (YAxis.Scale = LinScale) and (Abs(Y) < Eps) then Y := 0.0;

      Yc := Ycm(Y);
      WriteLine(XminCm, Yc, XminCm - 0.25, Yc, 0.0, '');

      if YAxis.Scale = LinScale then Z := Y else Z := Exp10(Y);
      WriteNumber('r', XminCm - 0.35, Yc, Z);

      if (YAxis.Scale = LogScale) and (I < N) then
        for J := 2 to 9 do
          begin
            W := Y + Log10(J);
            Yc := Ycm(W);
            WriteLine(XminCm, Yc, XminCm - 0.15, Yc, 0.0, '');
          end;

      Y := Y + YAxis.Step;
    end;

  { Write axis title }
  if YTitle <> '' then
    WriteText('l', XminCm, YmaxCm + 0.5, YTitle);
end;

procedure TeX_PlotGrid(Grid : TGrid);
var
  X, Y, Xc, Yc : Float;
  I, N         : Integer;
begin
  { Horizontal lines }
  if Grid in [HorizGrid, BothGrid] then
    begin
      N := Round((YAxis.Max - YAxis.Min) / YAxis.Step);  { Nb of intervals }
      for I := 1 to Pred(N) do
        begin
          Y := YAxis.Min + I * YAxis.Step;               { Origin of line }
          Yc := Ycm(Y);
          WriteLine(XminCm, Yc, XmaxCm, Yc, 0.0, 'dotted');
        end;
    end;

  { Vertical lines }
  if Grid in [VertiGrid, BothGrid] then
    begin
      N := Round((XAxis.Max - XAxis.Min) / XAxis.Step);
      for I := 1 to Pred(N) do
        begin
          X := XAxis.Min + I * XAxis.Step;
          Xc := Xcm(X);
          WriteLine(Xc, YminCm, Xc, YmaxCm, 0.0, 'dotted');
        end;
    end;
end;

procedure TeX_WriteGraphTitle;
begin
  if GraphTitle <> '' then
    WriteText('t', 0.5 * (XminCm + XmaxCm), YmaxCm + 1.0, GraphTitle);
end;

procedure TeX_SetPointParam(CurvIndex, Symbol, Size : Integer);
begin
  if (CurvIndex < 1) or (CurvIndex > MaxCurv) then Exit;

  if (Symbol >= 0) and (Symbol <= MaxSymbol) then
    CurvParam[CurvIndex]^.PointParam.Symbol := Symbol;

  if Size > 0 then
    CurvParam[CurvIndex]^.PointParam.Size := Size;
end;

procedure TeX_SetLineParam(CurvIndex, Style : Integer;
                           Width : Float; Smooth : Boolean);
begin
  if (CurvIndex < 1) or (CurvIndex > MaxCurv) then Exit;

  if (Style >= 0) and (Style <= 3) then
    CurvParam[CurvIndex]^.LineParam.Style := Style;

  CurvParam[CurvIndex]^.LineParam.Width := Width;
  CurvParam[CurvIndex]^.LineParam.Smooth := Smooth;
end;

procedure TeX_SetCurvLegend(CurvIndex : Integer; Legend : String);
begin
  if (CurvIndex >= 1) and (CurvIndex <= MaxCurv) then
    CurvParam[CurvIndex]^.Legend := Legend;
end;

procedure TeX_SetCurvStep(CurvIndex, Step : Integer);
begin
  if (CurvIndex >= 1) and (CurvIndex <= MaxCurv) and (Step > 0) then
    CurvParam[CurvIndex]^.Step := Step;
end;

procedure WritePointCoord(X, Y : Float);
var
  Xc, Yc : Float;
begin
  if XAxis.Scale = LogScale then X := Log10(X);
  if YAxis.Scale = LogScale then Y := Log10(Y);

  Xc := Xcm(X);
  Yc := Ycm(Y);

  if (Xc >= XminCm) and (Xc <= XmaxCm) and
     (Yc >= YminCm) and (Yc <= YmaxCm) then
       WriteCoord(Xc, Yc);
end;

procedure WriteErrorBar(X, Y, S : Float; Ns : Integer);
var
  Delta, Y1, Y2, Xc, Yc1, Yc2 : Float;
begin
  if XAxis.Scale = LogScale then X := Log10(X);

  Delta := Ns * S;

  Y1 := Y - Delta; if YAxis.Scale = LogScale then Y1 := Log10(Y1);
  Y2 := Y + Delta; if YAxis.Scale = LogScale then Y2 := Log10(Y2);

  Xc  := Xcm(X);
  Yc1 := Ycm(Y1);
  Yc2 := Ycm(Y2);

  if (Xc  < XminCm) or (Xc  > XmaxCm) or
     (Yc1 < YminCm) or (Yc1 > YmaxCm) or
     (Yc2 < YminCm) or (Yc2 > YmaxCm) then Exit;

  WriteLine(Xc, Yc1, Xc, Yc2, 0.0, 'solid');
  WriteLine(Xc - 0.125, Yc1, Xc + 0.125, Yc1, 0.0, 'solid');
  WriteLine(Xc - 0.125, Yc2, Xc + 0.125, Yc2, 0.0, 'solid');
end;

function DotStyle(Symbol : Integer) : String;
begin
  if (Symbol >= 0) and (Symbol <= MaxSymbol) then
    case Symbol of
      1 : DotStyle := '*';
      2 : DotStyle := 'o';
      3 : DotStyle := 'square*';
      4 : DotStyle := 'square';
      5 : DotStyle := 'triangle*';
      6 : DotStyle := 'triangle';
      7 : DotStyle := '+';
      8 : DotStyle := 'x';
      9 : DotStyle := 'asterisk';
    end;
end;

function LineStyle(Style : Integer) : String;
begin
  if (Style >= 0) and (Style <= 3) then
    case Style of
      0 : LineStyle := 'none';
      1 : LineStyle := 'solid';
      2 : LineStyle := 'dotted';
      3 : LineStyle := 'dashed';
    end;
end;

procedure WritePoints(X, Y       : TVector;
                      Lb, Ub     : Integer;
                      PointParam : TPointParam);
var
  I : Integer;
begin
  WriteLn(F, '\psdots[dotscale=', PointParam.Size,
           ', dotstyle=', DotStyle(PointParam.Symbol), ']%');

  I := Lb;
  repeat
    WritePointCoord(X[I], Y[I]);
    if (I > 0) and (I < Ub) and (I mod 5 = 0) then WriteLn(F, '%');
    Inc(I);
  until I > Ub;

  WriteLn(F);
end;

procedure WriteCurve(X, Y      : TVector;
                     Lb, Ub    : Integer;
                     LineParam : TLineParam);
var
  I  : Integer;
  W  : Float;
  Ws : String;
begin
  if LineParam.Smooth then Write(F, '\pscurve') else Write(F, '\psline');

  W := 0.01 * LineParam.Width;
  Str(W:5:2, Ws);
  Ws := Trim(Ws);

  WriteLn(F, '[linewidth=', Ws,
             ', linestyle=', LineStyle(LineParam.Style), ']%');

  I := Lb;
  repeat
    WritePointCoord(X[I], Y[I]);
    if (I > Lb) and (I < Ub) and (I mod 5 = 0) then WriteLn(F, '%');
    Inc(I);
  until I > Ub;

  WriteLn(F);
end;

procedure TeX_PlotCurve(X, Y : TVector; Lb, Ub, CurvIndex : Integer);
begin
  with CurvParam[CurvIndex]^ do
    begin
      WritePoints(X, Y, Lb, Ub, PointParam);
      if LineParam.Style > 0 then
        WriteCurve(X, Y, Lb, Ub, LineParam);
    end;
end;

procedure TeX_PlotCurveWithErrorBars(X, Y, S : TVector;
                                     Ns, Lb, Ub, CurvIndex : Integer);
var
  I : Integer;
begin
  TeX_PlotCurve(X, Y, Lb, Ub, CurvIndex);
  for I := Lb to Ub do
    if S[I] > 0.0 then
      WriteErrorBar(X[I], Y[I], S[I], Ns);
end;

procedure TeX_PlotFunc(Func : TFunc; X1, X2 : Float;
                       Npt : Integer; CurvIndex : Integer);
var
  X, Y : TVector;
  H    : Float;
  I    : Integer;
begin
  DimVector(X, Npt);
  DimVector(Y, Npt);

  H := (X2 - X1) / Npt;

  for I := 0 to Npt do
    begin
      X[I] := X1 + I * H;
      Y[I] := Func(X[I])
    end;

  WriteCurve(X, Y, 0, Npt, CurvParam[CurvIndex]^.LineParam);
end;

procedure TeX_WriteLegend(NCurv : Integer; ShowPoints, ShowLines : Boolean);

const
  CharHeight = 0.5;  { Character height in cm }

var
  I, N, Nmax            : Integer;
  L, X1, Y1, Xp, Yp, Xt : Float;

begin
  N := 0;  { Nb of legends to be plotted  }

  for I := 1 to NCurv do
    if CurvParam[I]^.Legend <> '' then
      Inc(N);

  if N = 0 then Exit;

  { Max. number of legends which may be plotted }
  Nmax := Round((YmaxCm - YminCm) / CharHeight) - 1;
  if N > Nmax then N := Nmax;

  { Draw rectangle around the legends }
  X1 := XmaxCm + 0.02 * PageWidth;
  Y1 := YmaxCm - (N + 1) * CharHeight;

  Write(F, '\pspolygon');
  WriteCoord(X1, Y1);
  WriteCoord(PageWidth, Y1);
  WriteCoord(PageWidth, YmaxCm);
  WriteCoord(X1, YmaxCm);
  WriteLn(F);

  L := 0.02 * PageWidth;  { Half-length of line }
  Xp := XmaxCm + 3 * L;   { Position of point   }
  Xt := XmaxCm + 5 * L;   { Position of text    }

  for I := 1 to IMin(NCurv, Nmax) do
    begin
      Yp := YmaxCm - I * CharHeight;

      { Plot point }
      if ShowPoints then
        begin
          with CurvParam[I]^.PointParam do
            Write(F, '\psdots[dotscale=', Size,
                     ', dotstyle=', DotStyle(Symbol), ']');
          WriteCoord(Xp, Yp);
          Writeln(F);
        end;

        { Plot line }
        if ShowLines then
          with CurvParam[I]^.LineParam do
            WriteLine(Xp - L, Yp, Xp + L, Yp, 0.01 * Width, LineStyle(Style));

        { Write legend }
        WriteText('l', Xt, Yp, CurvParam[I]^.Legend);
      end;
end;

procedure TeX_ConRec(Nx, Ny, Nc : Integer;
                     X, Y, Z    : TVector;
                     F          : TMatrix);

const
  { Mapping from vertex numbers to X offsets }
  Im : array[0..3] of Integer = (0, 1, 1, 0);

  { Mapping from vertex numbers to Y offsets }
  Jm : array[0..3] of Integer = (0, 0, 1, 1);

  { Case switch table }
  CasTab : array[0..2, 0..2, 0..2] of Integer =
  (((0,0,8), (0,2,5), (7,6,9)),
   ((0,3,4), (1,3,1), (4,3,0)),
   ((9,6,7), (5,2,0), (8,0,0)));

var
  I, J, K, M, M1, M2, M3 : Integer;
  X1, X2, Y1, Y2         : Float;
  Fmin, Fmax             : Float;
  Xc, Yc                 : TVector;
  PrmErr                 : Boolean;

var
  H   : array[0..4] of Float;    { Relative heights of the box above contour }
  Ish : array[0..4] of Integer;  { Sign of H() }
  Xh  : array[0..4] of Float;    { X coordinates of box }
  Yh  : array[0..4] of Float;    { Y coordinates of box }

label
  Case0, NoneInTri, NoneInBox;

begin
  { Check the input parameters for validity }

  PrmErr := False;
  SetErrCode(MatOk);

  if (Nx <= 0) or (Ny <= 0) or (Nc <= 0) then PrmErr := True;

  for K := 1 to Nc - 1 do
    if Z[K] <= Z[K - 1] then PrmErr := True;

  if PrmErr then
    begin
      SetErrCode(MatErrDim);
      Exit;
    end;

  { Convert user coordinates to cm }

  DimVector(Xc, Nx);
  DimVector(Yc, Ny);

  for I := 0 to Nx do
    Xc[I] := Xcm(X[I]);

  for J := 0 to Ny do
    Yc[J] := Ycm(Y[J]);

  { Scan the array, top down, left to right }

  for J := Ny - 1 downto 0 do
  begin
    for I := 0 to Nx - 1 do
    begin
      { Find the lowest vertex }
      if F[I, J] < F[I, J + 1] then
        Fmin := F[I, J]
      else
        Fmin := F[I, J + 1];

      if F[I + 1, J] < Fmin then
        Fmin := F[I + 1, J];

      if F[I + 1, J + 1] < Fmin then
        Fmin := F[I + 1, J + 1];

      { Find the highest vertex }
      if F[I, J] > F[I, J + 1] then
        Fmax := F[I, J]
      else
        Fmax := F[I, J + 1];

      if F[I + 1, J] > Fmax then
        Fmax := F[I + 1, J];

      if F[I + 1, J + 1] > Fmax then
        Fmax := F[I + 1, J + 1];

      if (Fmax < Z[0]) or (Fmin > Z[Nc - 1]) then
        goto NoneInBox;

      { Draw each contour within this box }
      for K := 0 to Nc - 1 do
      begin
        if (Z[K] < Fmin) or (Z[K] > Fmax) then
          goto NoneInTri;

        for M := 4 downto 0 do
        begin
          if M > 0 then
          begin
            H[M] := F[I + Im[M - 1], J + Jm[M - 1]] - Z[K];
            Xh[M] := Xc[I + Im[M - 1]];
            Yh[M] := Yc[J + Jm[M - 1]];
          end;

          if M = 0 then
          begin
            H[0] := 0.25 * (H[1] + H[2] + H[3] + H[4]);
            Xh[0] := 0.5 * (Xc[I] + Xc[I + 1]);
            Yh[0] := 0.5 * (Yc[J] + Yc[J + 1]);
          end;

          if H[M] > 0 then Ish[M] := 2;
          if H[M] < 0 then Ish[M] := 0;
          if H[M] = 0 then Ish[M] := 1;
        end; { next M }

        { Scan each triangle in the box }
        for M := 1 to 4 do
        begin
          M1 := M; M2 := 0; M3 := M + 1;
          if M3 = 5 then M3 := 1;

          case CasTab[Ish[M1], Ish[M2], Ish[M3]] of
            0 :
              goto Case0;

            { Line between vertices M1 and M2 }
            1 : begin
              X1 := Xh[M1];
              Y1 := Yh[M1];
              X2 := Xh[M2];
              Y2 := Yh[M2];
            end;

            { Line between vertices M2 and M3 }
            2 : begin
              X1 := Xh[M2];
              Y1 := Yh[M2];
              X2 := Xh[M3];
              Y2 := Yh[M3];
            end;

            { Line between vertices M3 and M1 }
            3 : begin
              X1 := Xh[M3];
              Y1 := Yh[M3];
              X2 := Xh[M1];
              Y2 := Yh[M1];
            end;

            { Line between vertex M1 and side M2-M3 }
            4 : begin
              X1 := Xh[M1];
              Y1 := Yh[M1];
              X2 := (H[M3] * Xh[M2] - H[M2] * Xh[M3]) / (H[M3] - H[M2]);
              Y2 := (H[M3] * Yh[M2] - H[M2] * Yh[M3]) / (H[M3] - H[M2]);
            end;

            { Line between vertex M2 and side M3-M1 }
            5 : begin
              X1 := Xh[M2];
              Y1 := Yh[M2];
              X2 := (H[M1] * Xh[M3] - H[M3] * Xh[M1]) / (H[M1] - H[M3]);
              Y2 := (H[M1] * Yh[M3] - H[M3] * Yh[M1]) / (H[M1] - H[M3]);
            end;

            { Line between vertex M3 and side M1-M2 }
            6 : begin
              X1 := Xh[M3];
              Y1 := Yh[M3];
              X2 := (H[M2] * Xh[M1] - H[M1] * Xh[M2]) / (H[M2] - H[M1]);
              Y2 := (H[M2] * Yh[M1] - H[M1] * Yh[M2]) / (H[M2] - H[M1]);
            end;

            { Line between sides M1-M2 and M2-M3 }
            7 : begin
              X1 := (H[M2] * Xh[M1] - H[M1] * Xh[M2]) / (H[M2] - H[M1]);
              Y1 := (H[M2] * Yh[M1] - H[M1] * Yh[M2]) / (H[M2] - H[M1]);
              X2 := (H[M3] * Xh[M2] - H[M2] * Xh[M3]) / (H[M3] - H[M2]);
              Y2 := (H[M3] * Yh[M2] - H[M2] * Yh[M3]) / (H[M3] - H[M2]);
            end;

            { Line between sides M2-M3 and M3-M1 }
            8 : begin
              X1 := (H[M3] * Xh[M2] - H[M2] * Xh[M3]) / (H[M3] - H[M2]);
              Y1 := (H[M3] * Yh[M2] - H[M2] * Yh[M3]) / (H[M3] - H[M2]);
              X2 := (H[M1] * Xh[M3] - H[M3] * Xh[M1]) / (H[M1] - H[M3]);
              Y2 := (H[M1] * Yh[M3] - H[M3] * Yh[M1]) / (H[M1] - H[M3]);
            end;

            { Line between sides M3-M1 and M1-M2 }
            9 : begin
              X1 := (H[M1] * Xh[M3] - H[M3] * Xh[M1]) / (H[M1] - H[M3]);
              Y1 := (H[M1] * Yh[M3] - H[M3] * Yh[M1]) / (H[M1] - H[M3]);
              X2 := (H[M2] * Xh[M1] - H[M1] * Xh[M2]) / (H[M2] - H[M1]);
              Y2 := (H[M2] * Yh[M1] - H[M1] * Yh[M2]) / (H[M2] - H[M1]);
            end;
          end;  { case }

          with CurvParam[K mod MaxCurv + 1]^.LineParam do
            WriteLine(X1, Y1, X2, Y2, 0.01 * Width, LineStyle(Style));
Case0:
        end;  { next M }
NoneInTri:
      end;  { next K }
NoneInBox:
    end;  { next I }
  end;  { next J }
end;

end.
