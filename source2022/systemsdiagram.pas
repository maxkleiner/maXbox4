unit SystemsDiagram;

{ CyberUnits }

{ Object Pascal units for computational cybernetics }

{ SystemsDiagram: Classes for drawing block diagrams }

{ Version 1.1.1 (Dendron) }

{ (c) Johannes W. Dietrich, 1994 - 2020 }
{ (c) Ludwig Maximilian University of Munich 1995 - 2002 }
{ (c) University of Ulm Hospitals 2002 - 2004 }
{ (c) Ruhr University of Bochum 2005 - 2020 }

{ Source code released under the BSD License }

{ See the file "license.txt", included in this distribution, }
{ for details about the copyright. }
{ Current versions and additional information are available from }
{ http://cyberunits.sf.net }

{ This program is distributed in the hope that it will be useful, }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. }

//{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Bricks, types, GraphUtil, windows, {ShLwApi,  }
  Dialogs;

type

  tAnchorposition = (leftmiddle, topmiddle, rightmiddle, bottommiddle);
  tSegmentPosition = (topSegment, rightSegment, bottomSegment, leftSegment);

  tAnchorPoint = record
    position: TPoint;
    attached: boolean;
  end;

  tChirality = (cleft, cright);

  TBlockDiagram = class;
  TIPSClass = class;

  { TIPSClass }
  { Generic class for IPS Object }

  TIPSClass = class
  public
    simulationBlock: TBlock; // Representation in Bricks
    blockDiagram: TBlockDiagram;
    Next: TIPSClass;
    boundsRect, objectRect: TRect;
    anchorPoint: array[leftmiddle..bottommiddle] of tAnchorPoint;
    title: string;
    font: TFont;
    procedure Draw; virtual; abstract;
    destructor Destroy; override;
  end;

  { TPClass }
  { Proportional block }

  TPClass = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TPT0Class }
  { Dead-time element }

  TPT0Class = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TPT1Class }
  { First order delay element }

  TPT1Class = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TPT2Class }
  { Second order delay element }

  TPT2Class = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TIntClass }
  { Integrator element }

  TIntClass = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TIT1Class }
  { Integrator with first order delay element }

  TIT1Class = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TDT1Class }
  { Differentiator with first order delay element }

  TDT1Class = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TIT2Class }
  { Integrator with second order delay element }

  TIT2Class = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TASIAClass }
  { Proportional block }

  TASIAClass = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TMiMeClass }
  { Proportional block }

  TMiMeClass = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TNoCoDIClass }
  { Proportional block }

  TNoCoDIClass = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TTerminalClass }
  { Terminal connector-like element for constants }

  TTerminalClass = class(TIPSClass)
  public
    TextMargin: integer;
    TextPosition: tAnchorposition;
    constructor Create;
    procedure Draw; override;
  end;

  { TInvertableClass }

  TInvertableClass = class(TIPSClass)
  public
    invertedSegments:  set of tSegmentPosition;
    constructor Create;
    procedure Draw; override;
  end;

  { TSigmaClass }

  TSigmaClass = class(TInvertableClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TPiClass }

  TPiClass = class(TInvertableClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TConnectionClass }

  TConnectionClass = class(TIPSClass)
  public
    sourceObject, drainObject: TIPSClass;
    sourceAnchor, drainAnchor: tAnchorposition;
    chirality: tChirality;
    TextMargin: integer;
    TextPosition: tAnchorposition;
    constructor Create;
    procedure Draw; override;
  end;

  { TJunctionClass }

  TJunctionClass = class(TIPSClass)
  public
    constructor Create;
    procedure Draw; override;
  end;

  { TBlockDiagram }

  TBlockDiagram = class
  public
    firstIPSObject: TIPSClass;
    canvas: TCanvas;
    constructor Create;
    destructor Destroy; override;
  end;

const
  DEFAULT_MARGIN = 3;

implementation

procedure CenterRect(outerRect: TRect; var innerRect: TRect);
{ centers a rect in another one }
var
  innerWidth, outerWidth, innerHeight, motherHeight: integer;
begin
  innerWidth := innerRect.right - innerRect.left;
  outerWidth := outerRect.right - outerRect.left;
  innerHeight := innerRect.bottom - innerRect.top;
  motherHeight := outerRect.bottom - outerRect.top;
  innerRect.top := (motherHeight - innerHeight) div 2 + outerRect.top;
  innerRect.bottom := innerRect.top + innerHeight;
  innerRect.left := (outerWidth - innerWidth) div 2 + outerRect.left;
  innerRect.right := innerRect.left + innerWidth;
end;

procedure CenterString(const theCanvas: TCanvas; const theString: string;
  myRect: TRect; var Start: TPoint);
{ delivers a starting point for a string that is bo be centered in a rect }
begin
  Start.x := myRect.left + (myRect.right - myRect.left) div 2 -
    theCanvas.TextWidth(theString) div 2;
  Start.y := myRect.top + (myRect.bottom - myRect.top) div 2 -
    (theCanvas.TextHeight(theString)) div 2;
end;

function InsetRect(var ARect: TRect; dx, dy: integer): boolean;
{ reduces the dimension of ARect by the distances dx and dy }
begin
  with ARect do
  begin
    Left := Left + dx;
    Right := Right - dx;
    Top := Top + dy;
    Bottom := Bottom - dy;
  end;
  Result := (ARect.Left >= 0) and (ARect.Top >= 0);
end;

procedure DrawArrowHead(var theCanvas: TCanvas; const x, y: integer; const theLength, alpha, beta: real);
{ draws an arrowhead with a given position, length and angle }
var
  A, B, C, D, r: real;
  gamma, epsilon, zeta, eta: real;
  thePoints: array of TPoint;
  oldStyle: TBrushStyle;
  oldColor: TColor;
begin
  oldColor := theCanvas.Brush.Color;
  oldStyle := theCanvas.Brush.Style;
  theCanvas.Brush.Color := theCanvas.Pen.Color;
  theCanvas.Brush.Style := bsSolid;
  SetLength(thePoints, 3);         { array for corners of arrow head }
  thePoints[0] := Point(x, y);     { position of arrow head }
  gamma := alpha + beta / 2;       { angle of right edge }
  zeta := alpha - beta / 2;        { angle of left edge }
  epsilon := pi / 2 - gamma;       { angle between vertical and right edge }
  eta := pi / 2 - zeta;            { angle between vertical and left edge }
  r := theLength * cos(beta / 2);  { length of both edges }
  A := r * cos(epsilon);           { distance to vertical position of right basal corner }
  B := r * sin(epsilon);           { distance to horizontal position of right basal corner }
  thePoints[1].x := round(x - B);  { horizontal position of right basal corner }
  thePoints[1].y := round(y + A);  { vertical position of right basal corner }
  C := r * cos(eta);               { distance to vertical position of left basal corner }
  D := r * sin(eta);               { distance to horizontal position of left basal corner }
  thePoints[2].x := round(x - D);  { horizontal position of left basal corner }
  thePoints[2].y := round(y + C);  { vertical position of left basal corner }

  theCanvas.Polygon(thePoints);    { dras arrow head with these points }
  theCanvas.Brush.Style := oldStyle;
  theCanvas.Brush.Color := oldColor;
end;

procedure pathTo(theCanvas: TCanvas; x, y: integer; chirality: tChirality);
{ draws rounded connection lines }
const
  STDDiam = 20;
  BETA = 26 * pi / 180;
  ARROW_LENGTH = 13;
var
  SourcePoint, overlap, arcDiam, delta: TPoint;
  arcRect: TRect;
  oldStyle: TBrushStyle;
  oldColor: TColor;
  alpha: real;               { angle between horizontal and finishing strait }
  diffX, diffY: integer;     { difference between current position and x / y }
begin
  oldColor := theCanvas.Brush.Color;
  oldStyle := theCanvas.Brush.Style;
  SourcePoint := TheCanvas.PenPos;
  delta.x := x - SourcePoint.x;
  delta.y := y - SourcePoint.y;
  arcDiam.x := STDDiam;
  arcDiam.y := STDDiam;
  if (delta.x <> 0) and (delta.y <> 0) then
  begin { draw rounded path, if difference in x or y }
    if abs(delta.x) < STDDiam then // draw smaller curvature if delta small
      arcDiam.x := abs(delta.x);
    if abs(delta.y) < STDDiam then
      arcDiam.y := abs(delta.y);
    overlap.x := arcDiam.x div 2 + 1;
    overlap.y := arcDiam.y div 2 + 1;
    if (overlap.x <> 0) and (overlap.y <> 0) then // still enough room?
    begin
      if delta.y > 0 then
      begin
        if delta.x > 0 then
        begin
          if chirality = cright then
          begin
            SetRect(arcRect, x - arcDiam.x, SourcePoint.y, x, SourcePoint.y + arcDiam.y);
            TheCanvas.LineTo(arcRect.left + overlap.x, arcRect.Top);
            TheCanvas.MoveTo(arcRect.Right, arcRect.bottom - overlap.y);
            TheCanvas.Arc(arcRect.Left, arcRect.Top, arcRect.Right,
              arcRect.Bottom, 0, 90 * 16);
          end
          else
          begin
            SetRect(arcRect, SourcePoint.x, y - arcDiam.y, SourcePoint.x + arcDiam.x, y);
            TheCanvas.LineTo(arcRect.left, arcRect.Top + overlap.y);
            TheCanvas.MoveTo(arcRect.Right - overlap.x, arcRect.bottom);
            TheCanvas.Arc(arcRect.Left, arcRect.Top, arcRect.Right,
              arcRect.Bottom, 180 * 16, 90 * 16);
          end;
        end
        else
        begin
          if chirality = cright then
          begin
            SetRect(arcRect, SourcePoint.x - arcDiam.x, y - arcDiam.y, SourcePoint.x, y);
            TheCanvas.LineTo(arcRect.right, arcRect.Top + overlap.y);
            TheCanvas.MoveTo(arcRect.Left + overlap.x, arcRect.bottom);
            TheCanvas.Arc(arcRect.Left, arcRect.Top, arcRect.Right,
              arcRect.Bottom, 270 * 16, 90 * 16);
          end
          else
          begin
            SetRect(arcRect, x, SourcePoint.y, x + arcDiam.x, SourcePoint.y + arcDiam.y);
            TheCanvas.LineTo(arcRect.right - overlap.x, arcRect.Top);
            TheCanvas.MoveTo(arcRect.Left, arcRect.bottom - overlap.y);
            TheCanvas.Arc(arcRect.Left, arcRect.Top, arcRect.Right,
              arcRect.Bottom, 90 * 16, 90 * 16);
          end;
        end;
      end
      else
      begin
        if delta.x > 0 then
        begin
          if chirality = cright then
          begin
            SetRect(arcRect, SourcePoint.x, y, SourcePoint.x + arcDiam.x, y + arcDiam.y);
            TheCanvas.LineTo(arcRect.left, arcRect.bottom - overlap.y);
            TheCanvas.MoveTo(arcRect.Right - overlap.x, arcRect.top);
            TheCanvas.Arc(arcRect.Left, arcRect.Top, arcRect.Right,
              arcRect.Bottom, 90 * 16, 90 * 16);
          end
          else
          begin
            SetRect(arcRect, x - arcDiam.x, SourcePoint.y - arcDiam.y, x, SourcePoint.y);
            TheCanvas.LineTo(arcRect.left + overlap.x, arcRect.bottom);
            TheCanvas.MoveTo(arcRect.Right, arcRect.top + overlap.y);
            TheCanvas.Arc(arcRect.Left, arcRect.Top, arcRect.Right,
              arcRect.Bottom, 270 * 16, 90 * 16);
          end;
        end
        else
        begin
          if chirality = cright then
          begin
            SetRect(arcRect, x, SourcePoint.y - arcDiam.y, x + arcDiam.x, SourcePoint.y);
            TheCanvas.LineTo(arcRect.right - overlap.x, arcRect.Bottom);
            TheCanvas.MoveTo(arcRect.Left, arcRect.top + overlap.y);
            TheCanvas.Arc(arcRect.Left, arcRect.Top, arcRect.Right,
              arcRect.Bottom, 180 * 16, 90 * 16);
          end
          else
          begin
            SetRect(arcRect, SourcePoint.x - arcDiam.x, y, SourcePoint.x, y + arcDiam.y);
            TheCanvas.LineTo(arcRect.right, arcRect.Bottom - overlap.y);
            TheCanvas.MoveTo(arcRect.Left + overlap.x, arcRect.top);
            TheCanvas.Arc(arcRect.Left, arcRect.Top, arcRect.Right,
              arcRect.Bottom, 0, 90 * 16);
          end;
        end;
      end;
    end;
  end;
    SourcePoint := TheCanvas.PenPos;
    TheCanvas.LineTo(x, y);  { finishing strait }
    diffX := x - SourcePoint.x;
    diffY := SourcePoint.y - y;
    if diffX = 0 then
      if diffY > 0 then
        alpha := pi / 2
      else
        alpha := 3 * pi / 2
    else
      alpha := arctan(diffY / diffX); { angle of finishing strait }
    if (alpha = 0) and (SourcePoint.x > x) then
      alpha := pi;           { arctan is ambiguous }
    DrawArrowHead(theCanvas, x, y, ARROW_LENGTH, alpha, BETA);
    theCanvas.Brush.Style := oldStyle;
    theCanvas.Brush.Color := oldColor;
end;

procedure pathTo(theCanvas: TCanvas; thePoint: TPoint; chirality: tChirality);
{ polymorphic variant of pathTo }
begin
  pathTo(theCanvas, thePoint.x, thePoint.y, chirality);
end;

procedure GetAnchorPoints(theIPSObject: TIPSClass; const theRect: TRect);
{ delivers anchor points for TIPSClass }
begin
  with theIPSObject.anchorPoint[leftmiddle] do
  begin
    position.x := theRect.left;
    position.y := theRect.top + (theRect.bottom - theRect.top) div 2;
  end;
  with theIPSObject.anchorPoint[topmiddle] do
  begin
    position.x := theRect.left + (theRect.right - theRect.left) div 2;
    position.y := theRect.top;
  end;
  with theIPSObject.anchorPoint[rightmiddle] do
  begin
    position.x := theRect.right;
    position.y := theRect.top + (theRect.bottom - theRect.top) div 2;
  end;
  with theIPSObject.anchorPoint[bottommiddle] do
  begin
    position.x := theRect.left + (theRect.right - theRect.left) div 2;
    position.y := theRect.bottom;
  end;
end;

{ TConnectionClass }

constructor TConnectionClass.Create;
begin
  inherited Create;
  TextMargin := DEFAULT_MARGIN;
  TextPosition := topmiddle;
  Font := TFont.Create;
end;

procedure TConnectionClass.Draw;
var
  StartingPoint, GoalPoint: TPoint;
  outerRect, innerRect, stringRect: TRect;
  theString: string;
  oldFont: TFont;
  tempPos: longint;
begin
  StartingPoint := sourceObject.anchorPoint[sourceAnchor].position;
  GoalPoint := drainObject.anchorPoint[drainAnchor].position;
  BlockDiagram.canvas.MoveTo(StartingPoint);
  PathTo(BlockDiagram.canvas, GoalPoint.X, GoalPoint.y, chirality);
  Font.Color := blockDiagram.canvas.Pen.Color;
  oldFont := blockDiagram.canvas.Font;
  blockDiagram.canvas.Font := Font;
  theString := title;
  SetRect(boundsRect, StartingPoint.x, StartingPoint.y, GoalPoint.x, GoalPoint.y);
  objectRect := boundsRect;
  if objectRect.Right < objectRect.Left then
  begin
    tempPos := objectRect.Left;
    objectRect.Left := objectRect.Right;
    objectRect.Right := tempPos;
  end;
  if objectRect.Bottom < objectRect.Top then
  begin
    tempPos := objectRect.Top;
    objectRect.Top := objectRect.Bottom;
    objectRect.Bottom := tempPos;
  end;
  StringRect := objectRect;
  case TextPosition of
  leftmiddle:
    MoveRect(StringRect, objectRect.Left - blockDiagram.canvas.TextWidth(theString) - TextMargin, objectRect.Top - blockDiagram.canvas.TextHeight(theString) div 2 + 1);
  rightmiddle:
    MoveRect(StringRect, objectRect.right + TextMargin, objectRect.Top - blockDiagram.canvas.TextHeight(theString) div 2 + 1);
  topmiddle:
    MoveRect(StringRect, objectRect.left + (objectRect.right - objectRect.Left) div 2 - blockDiagram.canvas.TextWidth(theString) div 2, objectRect.Top - blockDiagram.canvas.TextHeight(theString) - TextMargin);
  bottommiddle:
    MoveRect(StringRect, objectRect.left + (objectRect.right - objectRect.Left) div 2 - blockDiagram.canvas.TextWidth(theString) div 2, objectRect.Bottom + TextMargin);
  end;
  blockDiagram.canvas.TextOut(StringRect.Left, StringRect.top, theString);
  blockDiagram.canvas.Font := oldFont;
end;

{ TJunctionClass }

constructor TJunctionClass.Create;
begin
  inherited Create;
end;

procedure TJunctionClass.Draw;
var
  outerRect, innerRect: TRect;
  oldStyle: TFPBrushStyle;
  oldColor: TColor;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    oldColor := blockDiagram.canvas.Brush.Color;
    oldStyle := blockDiagram.canvas.Brush.Style;
    blockDiagram.canvas.Brush.Color := blockDiagram.canvas.Pen.Color;
    blockDiagram.canvas.Brush.Style := bsSolid;
    outerRect := boundsRect;
    SetRect(innerRect, 0, 0, 5, 5);
    CenterRect(outerRect, innerRect);
    blockDiagram.canvas.Ellipse(innerRect);
    GetAnchorPoints(self, innerRect);
    blockDiagram.canvas.Brush.Style := oldStyle;
    blockDiagram.canvas.Brush.Color := oldColor;
  end;
end;

{ TPiClass }

constructor TPiClass.Create;
begin
  inherited Create;
end;

procedure TPiClass.Draw;
var
  theRect: TRect;
  rw, rh, tw, th: integer;
  oldStyle: TFPBrushStyle;
  oldColor: TColor;
begin
  inherited Draw;
  oldColor := blockDiagram.canvas.Brush.Color;
  oldStyle := blockDiagram.canvas.Brush.Style;
  theRect := objectRect;
  rw := theRect.Right - theRect.Left;
  rh := theRect.Bottom - theRect.Top;
  InsetRect(theRect, rw div 2 - 2, rh div 2 - 2);
  blockDiagram.canvas.Brush.Color := blockDiagram.canvas.Pen.Color;
  blockDiagram.canvas.Brush.Style := bsSolid;
  blockDiagram.canvas.Ellipse(theRect);
  blockDiagram.canvas.Brush.Style := oldStyle;
  blockDiagram.canvas.Brush.Color := oldColor;
end;

{ TSigmaClass }

constructor TSigmaClass.Create;
begin
  inherited Create;
end;

procedure TSigmaClass.Draw;
var
  theRect: TRect;
  theString: char;
  rw, rh, tw, th: integer;
  oldColor: TColor;
  oldStyle: TFPBrushStyle;
begin
  inherited Draw;
  oldColor := blockDiagram.canvas.Brush.Color;
  oldStyle := blockDiagram.canvas.Brush.Style;
  theRect := objectRect;
  theString := '+';
  rw := theRect.Right - theRect.Left;
  rh := theRect.Bottom - theRect.Top;
  blockDiagram.canvas.GetTextSize(theString, tw, th);
  blockDiagram.canvas.Brush.Style := bsClear;
  blockDiagram.canvas.TextRect(theRect, theRect.Left + (rw - tw) div
    2, theRect.Top + (rh - th) div 2 - 1, theString);
  blockDiagram.canvas.Brush.Style := oldStyle;
  blockDiagram.canvas.Brush.Color := oldColor;
end;

{ TInvertableClass }

constructor TInvertableClass.Create;
begin
  inherited Create;
  invertedSegments := [];
  Font := TFont.Create;
end;

procedure TInvertableClass.Draw;
var
  theRect: TRect;
  theWidth, theHeight: integer;
  theCenter, intersection1, intersection2, intersection3, intersection4: TPoint;
  connectionRingWidth: integer;
  oldColor: TColor;
  oldStyle: TFPBrushStyle;
  oldFont: TFont;
begin
  theRect := boundsRect;
  theHeight := theRect.bottom - theRect.top;
  theWidth := theRect.right - theRect.left;
  if theHeight <> theWidth then
  begin
    { compensates for non-quadratic boundsRect }
    theRect.left := theRect.left + (theWidth - theHeight) div 2;
    theRect.right := theRect.left + theHeight;
    theWidth := theRect.right - theRect.left;
  end;
  Font.Color := blockDiagram.canvas.Pen.Color;
  oldColor := blockDiagram.canvas.Brush.Color;
  oldStyle := blockDiagram.canvas.Brush.Style;
  oldFont := blockDiagram.canvas.Font;
  blockDiagram.canvas.Font := Font;
  objectRect := theRect;
  theCenter.x := theRect.left + theWidth div 2;
  theCenter.y := theRect.top + theHeight div 2;
  intersection1 := point(theCenter.x + trunc(0.71 * theHeight / 2),
    theCenter.y - trunc(0.71 * theHeight / 2));
  intersection2 := point(theCenter.x + trunc(0.71 * theHeight / 2),
    theCenter.y + trunc(0.71 * theHeight / 2));
  intersection3 := point(theCenter.x - trunc(0.71 * theHeight / 2),
    theCenter.y + trunc(0.71 * theHeight / 2));
  intersection4 := point(theCenter.x - trunc(0.71 * theHeight / 2),
    theCenter.y - trunc(0.71 * theHeight / 2));
  blockDiagram.canvas.Ellipse(theRect);
  blockDiagram.canvas.MoveTo(intersection4);
  blockDiagram.canvas.LineTo(intersection2);
  blockDiagram.canvas.MoveTo(intersection1);
  blockDiagram.canvas.LineTo(intersection3);
  GetAnchorPoints(self, theRect);
  blockDiagram.canvas.Brush.Style := bsSolid;
  blockDiagram.canvas.Brush.Color := blockDiagram.canvas.Pen.Color;
  if topSegment in invertedSegments then
    blockDiagram.canvas.Pie(theRect.Left, theRect.Top, theRect.Right, theRect.Bottom,
    intersection1.x, intersection1.y, intersection4.x, intersection4.y);
  if rightSegment in invertedSegments then
    blockDiagram.canvas.Pie(theRect.Left, theRect.Top, theRect.Right, theRect.Bottom,
    intersection2.x, intersection2.y, intersection1.x, intersection1.y);
  if bottomSegment in invertedSegments then
    blockDiagram.canvas.Pie(theRect.Left, theRect.Top, theRect.Right, theRect.Bottom,
    intersection3.x, intersection3.y, intersection2.x, intersection2.y);
  if leftSegment in invertedSegments then
    blockDiagram.canvas.Pie(theRect.Left, theRect.Top, theRect.Right, theRect.Bottom,
    intersection4.x, intersection4.y, intersection3.x, intersection3.y);
  blockDiagram.canvas.Brush.Color := oldColor;
  connectionRingWidth := theHeight div 5;
  InsetRect(theRect, connectionRingWidth, connectionRingWidth);
  blockDiagram.canvas.Ellipse(theRect);
  objectRect := theRect;
  blockDiagram.canvas.Brush.Style := oldStyle;
  blockDiagram.canvas.Brush.Color := oldColor;
  blockDiagram.canvas.Font := oldFont;
end;

{ TTerminalClass }

constructor TTerminalClass.Create;
begin
  inherited Create;
  TextMargin := DEFAULT_MARGIN;
  TextPosition := leftmiddle;
  Font := TFont.Create;
end;

procedure TTerminalClass.Draw;
var
  outerRect, innerRect, stringRect: TRect;
  theString: string;
  oldFont: TFont;
begin
  Font.Color := blockDiagram.canvas.Pen.Color;
  oldFont := blockDiagram.canvas.Font;
  blockDiagram.canvas.Font := Font;
  outerRect := boundsRect;
  theString := title;
  SetRect(innerRect, 0, 0, 5, 5);
  CenterRect(outerRect, innerRect);
  blockDiagram.canvas.Ellipse(innerRect);
  objectRect := innerRect;
  StringRect := innerRect;
  case TextPosition of
  leftmiddle:
    MoveRect(StringRect, objectRect.Left - blockDiagram.canvas.TextWidth(theString) - TextMargin, objectRect.Top - blockDiagram.canvas.TextHeight(theString) div 2 + 1);
  rightmiddle:
    MoveRect(StringRect, objectRect.right + TextMargin, objectRect.Top - blockDiagram.canvas.TextHeight(theString) div 2 + 1);
  topmiddle:
    MoveRect(StringRect, objectRect.left + (objectRect.right - objectRect.Left) div 2 - blockDiagram.canvas.TextWidth(theString) div 2, objectRect.Top - blockDiagram.canvas.TextHeight(theString) - TextMargin);
  bottommiddle:
    MoveRect(StringRect, objectRect.left + (objectRect.right - objectRect.Left) div 2 - blockDiagram.canvas.TextWidth(theString) div 2, objectRect.Bottom + TextMargin);
  end;
  blockDiagram.canvas.TextOut(StringRect.Left, StringRect.top, theString);
  GetAnchorPoints(self, innerRect);
  blockDiagram.canvas.Font := oldFont;
end;

{ TPClass }

constructor TPClass.Create;
begin
  inherited Create;
  Font := TFont.Create;
end;

procedure TPClass.Draw;
var
  theRect: TRect;
  theString: string;
  rw, rh, tw, th: integer;
  oldFont: TFont;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    theRect := boundsRect;
    theString := title;
    Font.Color := blockDiagram.canvas.Pen.Color;
    oldFont := blockDiagram.canvas.Font;
    blockDiagram.canvas.Font := Font;
    blockDiagram.canvas.Rectangle(theRect);
    rw := theRect.Right - theRect.Left;
    rh := theRect.Bottom - theRect.Top;
    blockDiagram.canvas.GetTextSize(theString, tw, th);
    blockDiagram.canvas.Brush.Style := bsClear;
    blockDiagram.canvas.TextRect(theRect, theRect.Left + (rw - tw) div
      2, theRect.Top + (rh - th) div 2, theString);
    GetAnchorPoints(self, theRect);
    blockDiagram.canvas.Font := oldFont;
  end;
end;

{ TPT0Class }

constructor TPT0Class.Create;
begin
  inherited Create;
  Font := TFont.Create;
end;

procedure TPT0Class.Draw;
var
  theRect: TRect;
  theString: string;
  rw, rh, tw, th: integer;
  oldFont: TFont;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    theRect := boundsRect;
    rw := theRect.Right - theRect.Left;
    rh := theRect.Bottom - theRect.Top;
    blockDiagram.canvas.Rectangle(theRect);
    Font.Color := blockDiagram.canvas.Pen.Color;
    oldFont := blockDiagram.canvas.Font;
    blockDiagram.canvas.Font := Font;
    theString := title;
    if theString = '' then
    begin
      blockDiagram.canvas.MoveTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.15 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.85 * rw),
        theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.MoveTo(theRect.Left + trunc(0.3 * rw),
        theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.3 * rw),
        theRect.Top + trunc(0.3 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.85 * rw),
        theRect.Top + trunc(0.3 * rh));
    end
    else
    begin
      blockDiagram.canvas.GetTextSize(theString, tw, th);
      blockDiagram.canvas.Brush.Style := bsClear;
      blockDiagram.canvas.TextRect(theRect, theRect.Left + (rw - tw) div
        2, theRect.Top + (rh - th) div 2, theString);
    end;
    GetAnchorPoints(self, theRect);
    blockDiagram.canvas.Font := oldFont;
  end;
end;

{ TPT1Class }

constructor TPT1Class.Create;
begin
  inherited Create;
  Font := TFont.Create;
end;

procedure TPT1Class.Draw;
var
  theRect: TRect;
  theString: string;
  rw, rh, tw, th: integer;
  oldFont: TFont;
  bezierPoints: array of TPoint;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    theRect := boundsRect;
    rw := theRect.Right - theRect.Left;
    rh := theRect.Bottom - theRect.Top;
    blockDiagram.canvas.Rectangle(theRect);
    Font.Color := blockDiagram.canvas.Pen.Color;
    oldFont := blockDiagram.canvas.Font;
    blockDiagram.canvas.Font := Font;
    theString := title;
    if theString = '' then
    begin
      blockDiagram.canvas.MoveTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.15 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.85 * rw),
        theRect.Top + trunc(0.85 * rh));
      SetLength(bezierPoints, 4);
      bezierPoints[0] := Point(theRect.Left + trunc(0.15 * rw), theRect.Top + trunc(0.85 * rh));
      bezierPoints[1] := Point(theRect.Left + trunc(0.2 * rw), theRect.Top + trunc(0.3 * rh));
      bezierPoints[2] := Point(theRect.Left + trunc(0.6 * rw), theRect.Top + trunc(0.2 * rh));
      bezierPoints[3] := Point(theRect.Left + trunc(0.85 * rw), theRect.Top + trunc(0.2 * rh));
      blockDiagram.canvas.PolyBezier(bezierPoints, false, true);
    end
    else
    begin
      blockDiagram.canvas.GetTextSize(theString, tw, th);
      blockDiagram.canvas.Brush.Style := bsClear;
      blockDiagram.canvas.TextRect(theRect, theRect.Left + (rw - tw) div
        2, theRect.Top + (rh - th) div 2, theString);
    end;
    GetAnchorPoints(self, theRect);
    blockDiagram.canvas.Font := oldFont;
  end;
end;

{ TPT2Class }

constructor TPT2Class.Create;
begin
  inherited Create;
  Font := TFont.Create;
end;

procedure TPT2Class.Draw;
var
  theRect: TRect;
  theString: string;
  rw, rh, tw, th: integer;
  oldFont: TFont;
  bezierPoints: array of TPoint;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    theRect := boundsRect;
    rw := theRect.Right - theRect.Left;
    rh := theRect.Bottom - theRect.Top;
    blockDiagram.canvas.Rectangle(theRect);
    Font.Color := blockDiagram.canvas.Pen.Color;
    oldFont := blockDiagram.canvas.Font;
    blockDiagram.canvas.Font := Font;
    theString := title;
    if theString = '' then
    begin
      blockDiagram.canvas.MoveTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.15 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.85 * rw),
        theRect.Top + trunc(0.85 * rh));
      SetLength(bezierPoints, 12);
      bezierPoints[0] := Point(theRect.Left + trunc(0.15 * rw), theRect.Top + trunc(0.85 * rh));
      bezierPoints[1] := Point(theRect.Left + trunc(0.20 * rw), theRect.Top + trunc(0.7 * rh));
      bezierPoints[2] := Point(theRect.Left + trunc(0.25 * rw), theRect.Top + trunc(0.3 * rh));
      bezierPoints[3] := Point(theRect.Left + trunc(0.3 * rw), theRect.Top + trunc(0.2 * rh));
      bezierPoints[4] := Point(theRect.Left + trunc(0.35 * rw), theRect.Top + trunc(0.2 * rh));
      bezierPoints[5] := Point(theRect.Left + trunc(0.4 * rw), theRect.Top + trunc(0.2 * rh));
      bezierPoints[6] := Point(theRect.Left + trunc(0.45 * rw), theRect.Top + trunc(0.3 * rh));
      bezierPoints[7] := Point(theRect.Left + trunc(0.5 * rw), theRect.Top + trunc(0.4 * rh));
      bezierPoints[8] := Point(theRect.Left + trunc(0.55 * rw), theRect.Top + trunc(0.5 * rh));
      bezierPoints[9] := Point(theRect.Left + trunc(0.65 * rw), theRect.Top + trunc(0.5 * rh));
      bezierPoints[10] := Point(theRect.Left + trunc(0.75 * rw), theRect.Top + trunc(0.4 * rh));
      bezierPoints[11] := Point(theRect.Left + trunc(0.80 * rw), theRect.Top + trunc(0.4 * rh));
      blockDiagram.canvas.Polyline(bezierPoints);
    end
    else
    begin
      blockDiagram.canvas.GetTextSize(theString, tw, th);
      blockDiagram.canvas.Brush.Style := bsClear;
      blockDiagram.canvas.TextRect(theRect, theRect.Left + (rw - tw) div
        2, theRect.Top + (rh - th) div 2, theString);
    end;
    GetAnchorPoints(self, theRect);
    blockDiagram.canvas.Font := oldFont;
  end;
end;

{ TIntClass }

constructor TIntClass.Create;
begin
  inherited Create;
  Font := TFont.Create;
end;

procedure TIntClass.Draw;
var
  theRect: TRect;
  theString: string;
  rw, rh, tw, th: integer;
  oldFont: TFont;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    theRect := boundsRect;
    rw := theRect.Right - theRect.Left;
    rh := theRect.Bottom - theRect.Top;
    blockDiagram.canvas.Rectangle(theRect);
    Font.Color := blockDiagram.canvas.Pen.Color;
    oldFont := blockDiagram.canvas.Font;
    blockDiagram.canvas.Font := Font;
    theString := title;
    if theString = '' then
    begin
      blockDiagram.canvas.MoveTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.15 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.85 * rw),
        theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.MoveTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.8 * rw),
        theRect.Top + trunc(0.15 * rh));
    end
    else
    begin
      blockDiagram.canvas.GetTextSize(theString, tw, th);
      blockDiagram.canvas.Brush.Style := bsClear;
      blockDiagram.canvas.TextRect(theRect, theRect.Left + (rw - tw) div
        2, theRect.Top + (rh - th) div 2, theString);
    end;
    GetAnchorPoints(self, theRect);
    blockDiagram.canvas.Font := oldFont;
  end;
end;

{ TIT1Class }

constructor TIT1Class.Create;
begin
  inherited Create;
  Font := TFont.Create;
end;

procedure TIT1Class.Draw;
var
  theRect: TRect;
  theString: string;
  rw, rh, tw, th: integer;
  oldFont: TFont;
  bezierPoints: array of TPoint;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    theRect := boundsRect;
    rw := theRect.Right - theRect.Left;
    rh := theRect.Bottom - theRect.Top;
    blockDiagram.canvas.Rectangle(theRect);
    Font.Color := blockDiagram.canvas.Pen.Color;
    oldFont := blockDiagram.canvas.Font;
    blockDiagram.canvas.Font := Font;
    theString := title;
    if theString = '' then
    begin
      blockDiagram.canvas.MoveTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.15 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.85 * rw),
        theRect.Top + trunc(0.85 * rh));
      SetLength(bezierPoints, 4);
      bezierPoints[0] := Point(theRect.Left + trunc(0.15 * rw), theRect.Top + trunc(0.85 * rh));
      bezierPoints[1] := Point(theRect.Left + trunc(0.6 * rw), theRect.Top + trunc(0.7 * rh));
      bezierPoints[2] := Point(theRect.Left + trunc(0.7 * rw), theRect.Top + trunc(0.5 * rh));
      bezierPoints[3] := Point(theRect.Left + trunc(0.85 * rw), theRect.Top + trunc(0.2 * rh));
      blockDiagram.canvas.PolyBezier(bezierPoints, false, true);
    end
    else
    begin
      blockDiagram.canvas.GetTextSize(theString, tw, th);
      blockDiagram.canvas.Brush.Style := bsClear;
      blockDiagram.canvas.TextRect(theRect, theRect.Left + (rw - tw) div
        2, theRect.Top + (rh - th) div 2, theString);
    end;
    GetAnchorPoints(self, theRect);
    blockDiagram.canvas.Font := oldFont;
  end;
end;

{ TDT1Class }

constructor TDT1Class.Create;
begin
  inherited Create;
  Font := TFont.Create;
end;

procedure TDT1Class.Draw;
var
  theRect: TRect;
  theString: string;
  rw, rh, tw, th: integer;
  oldFont: TFont;
  bezierPoints: array of TPoint;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    theRect := boundsRect;
    rw := theRect.Right - theRect.Left;
    rh := theRect.Bottom - theRect.Top;
    blockDiagram.canvas.Rectangle(theRect);
    Font.Color := blockDiagram.canvas.Pen.Color;
    oldFont := blockDiagram.canvas.Font;
    blockDiagram.canvas.Font := Font;
    theString := title;
    if theString = '' then
    begin
      blockDiagram.canvas.MoveTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.15 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.85 * rw),
        theRect.Top + trunc(0.85 * rh));
      SetLength(bezierPoints, 4);
      bezierPoints[0] := Point(theRect.Left + trunc(0.15 * rw), theRect.Top + trunc(0.2 * rh));
      bezierPoints[1] := Point(theRect.Left + trunc(0.2 * rw), theRect.Top + trunc(0.7 * rh));
      bezierPoints[2] := Point(theRect.Left + trunc(0.4 * rw), theRect.Top + trunc(0.8 * rh));
      bezierPoints[3] := Point(theRect.Left + trunc(0.85 * rw), theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.PolyBezier(bezierPoints, false, true);
    end
    else
    begin
      blockDiagram.canvas.GetTextSize(theString, tw, th);
      blockDiagram.canvas.Brush.Style := bsClear;
      blockDiagram.canvas.TextRect(theRect, theRect.Left + (rw - tw) div
        2, theRect.Top + (rh - th) div 2, theString);
    end;
    GetAnchorPoints(self, theRect);
    blockDiagram.canvas.Font := oldFont;
  end;
end;

{ TIT2Class }

constructor TIT2Class.Create;
begin
  inherited Create;
  Font := TFont.Create;
end;

procedure TIT2Class.Draw;
var
  theRect: TRect;
  theString: string;
  rw, rh, tw, th: integer;
  oldFont: TFont;
  bezierPoints: array of TPoint;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    theRect := boundsRect;
    rw := theRect.Right - theRect.Left;
    rh := theRect.Bottom - theRect.Top;
    blockDiagram.canvas.Rectangle(theRect);
    Font.Color := blockDiagram.canvas.Pen.Color;
    oldFont := blockDiagram.canvas.Font;
    blockDiagram.canvas.Font := Font;
    theString := title;
    if theString = '' then
    begin
      blockDiagram.canvas.MoveTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.15 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.15 * rw),
        theRect.Top + trunc(0.85 * rh));
      blockDiagram.canvas.LineTo(theRect.Left + trunc(0.85 * rw),
        theRect.Top + trunc(0.85 * rh));
      SetLength(bezierPoints, 12);
      bezierPoints[0] := Point(theRect.Left + trunc(0.15 * rw), theRect.Top + trunc(0.85 * rh));
      bezierPoints[1] := Point(theRect.Left + trunc(0.21 * rw), theRect.Top + trunc(0.7 * rh));
      bezierPoints[2] := Point(theRect.Left + trunc(0.27 * rw), theRect.Top + trunc(0.5 * rh));
      bezierPoints[3] := Point(theRect.Left + trunc(0.33 * rw), theRect.Top + trunc(0.5 * rh));
      bezierPoints[4] := Point(theRect.Left + trunc(0.39 * rw), theRect.Top + trunc(0.6 * rh));
      bezierPoints[5] := Point(theRect.Left + trunc(0.45 * rw), theRect.Top + trunc(0.7 * rh));
      bezierPoints[6] := Point(theRect.Left + trunc(0.52 * rw), theRect.Top + trunc(0.7 * rh));
      bezierPoints[7] := Point(theRect.Left + trunc(0.59 * rw), theRect.Top + trunc(0.6 * rh));
      bezierPoints[8] := Point(theRect.Left + trunc(0.66 * rw), theRect.Top + trunc(0.5 * rh));
      bezierPoints[9] := Point(theRect.Left + trunc(0.72 * rw), theRect.Top + trunc(0.4 * rh));
      bezierPoints[10] := Point(theRect.Left + trunc(0.80 * rw), theRect.Top + trunc(0.3 * rh));
      bezierPoints[11] := Point(theRect.Left + trunc(0.85 * rw), theRect.Top + trunc(0.25 * rh));
      blockDiagram.canvas.Polyline(bezierPoints);
    end
    else
    begin
      blockDiagram.canvas.GetTextSize(theString, tw, th);
      blockDiagram.canvas.Brush.Style := bsClear;
      blockDiagram.canvas.TextRect(theRect, theRect.Left + (rw - tw) div
        2, theRect.Top + (rh - th) div 2, theString);
    end;
    GetAnchorPoints(self, theRect);
    blockDiagram.canvas.Font := oldFont;
  end;
end;


{ TASIAClass }

constructor TASIAClass.Create;
begin
  inherited Create;
  Font := TFont.Create;
end;

procedure TASIAClass.Draw;
var
  theRect: TRect;
  theString: string;
  rw, rh, tw, th: integer;
  oldFont: TFont;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    theRect := boundsRect;
    theString := 'ASIA';
    Font.Color := blockDiagram.canvas.Pen.Color;
    oldFont := blockDiagram.canvas.Font;
    blockDiagram.canvas.Font := Font;
    blockDiagram.canvas.Rectangle(theRect);
    rw := theRect.Right - theRect.Left;
    rh := theRect.Bottom - theRect.Top;
    blockDiagram.canvas.GetTextSize(theString, tw, th);
    blockDiagram.canvas.Brush.Style := bsClear;
    blockDiagram.canvas.TextRect(theRect, theRect.Left + (rw - tw) div
      2, theRect.Top + (rh - th) div 2, theString);
    GetAnchorPoints(self, theRect);
    blockDiagram.canvas.Font := oldFont;
  end;
end;

{ TMiMeClass }

constructor TMiMeClass.Create;
begin
  inherited Create;
  Font := TFont.Create;
end;

procedure TMiMeClass.Draw;
var
  theString: string;
  rw, rh, tw, th: integer;
  oldFont: TFont;
  bezierPoints: array of TPoint;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    objectRect := boundsRect;
    rw := boundsRect.Right - boundsRect.Left;
    rh := boundsRect.Bottom - boundsRect.Top;
    th := rh;
    tw := rw;
    if th < tw then
    begin
      objectRect.Left := boundsRect.Left + (tw - th) div 2;
      objectRect.Right := objectRect.Left + th;
    end
    else if tw < th then
    begin
      objectRect.Top := boundsRect.Top + (th - tw) div 2;
      objectRect.Bottom := objectRect.Top + tw;
    end;
    InsetRect(objectRect, th div 10, th div 10);
    tw := objectRect.Right - objectRect.Left;
    th := objectRect.Bottom - objectRect.Top;
    theString := 'MiMe';
    Font.Color := blockDiagram.canvas.Pen.Color;
    oldFont := blockDiagram.canvas.Font;
    blockDiagram.canvas.Font := Font;
    blockDiagram.canvas.Rectangle(boundsRect);
    blockDiagram.canvas.Ellipse(objectRect);
    blockDiagram.canvas.MoveTo(objectRect.Left + trunc(0.2 * tw),
      objectRect.Top + trunc(0.15 * th));
    blockDiagram.canvas.LineTo(objectRect.Left + trunc(0.2 * tw),
      objectRect.Top + trunc(0.85 * th));
    blockDiagram.canvas.MoveTo(objectRect.Left + trunc(0.15 * tw),
      objectRect.Top + trunc(0.7 * th));
    blockDiagram.canvas.LineTo(objectRect.Left + trunc(0.95 * tw),
      objectRect.Top + trunc(0.7 * th));
    SetLength(bezierPoints, 4);
    bezierPoints[0] := Point(objectRect.Left + trunc(0.2 * tw), objectRect.Top + trunc(0.7 * th));
    bezierPoints[1] := Point(objectRect.Left + trunc(0.3 * tw), objectRect.Top + trunc(0.31 * th));
    bezierPoints[2] := Point(objectRect.Left + trunc(0.7 * tw), objectRect.Top + trunc(0.3 * th));
    bezierPoints[3] := Point(objectRect.Left + trunc(0.8 * tw), objectRect.Top + trunc(0.3 * th));
    blockDiagram.canvas.PolyBezier(bezierPoints, false, true);
    GetAnchorPoints(self, boundsRect);
    blockDiagram.canvas.Font := oldFont;
  end;
end;

{ TNoCoDIClass }

constructor TNoCoDIClass.Create;
begin
  inherited Create;
  Font := TFont.Create;
end;

procedure TNoCoDIClass.Draw;
var
  theRect: TRect;
  theString: string;
  rw, rh, tw, th: integer;
  oldFont: TFont;
begin
  if (assigned(blockDiagram) and assigned(blockDiagram.canvas)) then
  begin
    theRect := boundsRect;
    theString := 'NoCoDI';
    Font.Color := blockDiagram.canvas.Pen.Color;
    oldFont := blockDiagram.canvas.Font;
    blockDiagram.canvas.Font := Font;
    blockDiagram.canvas.Rectangle(theRect);
    rw := theRect.Right - theRect.Left;
    rh := theRect.Bottom - theRect.Top;
    blockDiagram.canvas.GetTextSize(theString, tw, th);
    blockDiagram.canvas.Brush.Style := bsClear;
    blockDiagram.canvas.TextRect(theRect, theRect.Left + (rw - tw) div
      2, theRect.Top + (rh - th) div 2, theString);
    GetAnchorPoints(self, theRect);
    blockDiagram.canvas.Font := oldFont;
  end;
end;

{ TIPSClass }

destructor TIPSClass.Destroy;
begin
  if assigned(Font) then
    font.Destroy;
  inherited Destroy;
end;

{ TBlockDiagram }

constructor TBlockDiagram.Create;
begin
  inherited Create;
end;

destructor TBlockDiagram.Destroy;
var
  curIPSObject, nextIPSObject: TIPSClass;
begin
  curIPSObject := firstIPSObject;
  while assigned(curIPSObject) do
  begin
    nextIPSObject := curIPSObject.Next;
    curIPSObject.Destroy;
    curIPSObject := nextIPSObject;
  end;
  inherited Destroy;
end;

end.

{References:  }

{1. Röhler, R., "Biologische Kybernetik", B. G. Teubner, Stuttgart 1973 }

{2. Neuber, H., "Simulation von Regelkreisen auf Personal Computern  }
{   in Pascal und Fortran 77", IWT, Vaterstetten 1989 }

{3. Lutz H. and Wendt, W., "Taschenbuch der Regelungstechnik" }
{   Verlag Harri Deutsch, Frankfurt am Main 2005 }

