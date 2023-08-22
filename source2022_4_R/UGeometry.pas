unit UGeometry;
{Copyright  © 2005-2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved  }

{General usage Computational Geometry procedures and functions}

interface

uses Windows, Sysutils, Dialogs, Types;
type

  TrealPoint=record
   x,y:extended;
 end;

  Tline=record
    p1,p2:TPoint; {starting and ending points of a line segment}
  end;

  TRealLine=record
    p1,p2:TRealPoint; {starting and ending points of a line segment}
  end;

  TCircle=record
    cx,cy,r:integer;
  end;

  TRealCircle=record
    cx,cy,r:extended;
  end;

  PPResult=(PPoutside, PPInside, PPVertex, PPEdge, PPError);

  function realpoint(x,y:extended):TRealPoint;

  function dist(const p1,p2:TrealPoint):extended;


  {integer distance bertween two points}
  function intdist(const p1,p2:TPoint):integer;

  {Make a line from two points}
  function Line(const p1,p2:TPoint):Tline;   overload;
  function Line(const p1,p2:TRealPoint):TRealline; overload;

  {Make a circle from center and radius}
  function Circle(const cx,cy,R:integer):TCircle;    overload;
  function Circle(const cx,cy,R:extended):TRealCircle;overload;

  {Get the angle from p1 to p2 of a line segment}
  function GetTheta(const L:TLine):extended;    overload;
  function GetTheta(const p1,p2:TPoint):extended; overload;
  function GetTheta(const p1,p2:TRealPoint):extended; overload;

  {Extend line L by distance "dist" for point L.p2}
  procedure Extendline(var L:TLine; dist:integer); overload;
  procedure Extendline(var L:TRealLine; dist:extended); overload;

  {Do two line segments intersect?}
  function Linesintersect(line1,line2:TLine):boolean;

  {Another version which will optionally extend line if necessasry to determine
   point of intersection.  Also returns the point  of intersection if it exists}
  function ExtendedLinesIntersect({Const} Line1,Line2:TLine;
                                  Const extendlines:boolean;
                                  var IP:TPoint):boolean;  overload;
  function ExtendedLinesIntersect(Const Line1,Line2:TLine;
                                  Const extendlines:boolean;
                                  var IP:TRealPoint):boolean; overload;

  {A more complex (and probably slower) version which identifies the intersection
  point and whether either end of either line falls exactly on the other line}
  function Intersect(L1,L2:TLine; var pointonborder:boolean; var IP:TPoint):boolean;
  {Find the line from a given point which is perpendicular to a given line}
  {p1 of the returned line is the given point, p2 is the intersection point of the
   given line and the reutrned line}
  function PointPerpendicularLine(L:TLine; P:TPoint):TLine;

  {Return the perpendicular distance from a point to given line}
  function PerpDistance(L:TLine; P:TPoint):Integer;

  {Define the line through a given point intersecting a given line at a given angle}
  function AngledLineFromLine(L:TLine; P:TPoint; Dist:extended; alpha:extended):TLine; overload;

   function AngledLineFromLine(L:TLine; P:TPoint; Dist:extended; alpha:extended;
                 useScreenCoordinates:boolean):TLine;  overload;

  {Is a given point internal to a given polygon?}
  {Result is of type PPResult}
  {Possible result values are: PPoutside, PPInside, PPVertex, PPEdge, PPError}
  function PointInPoly(const p:TPoint; Points:array of TPoint):PPResult;

  {PolygonArea calculates the area of a polygon -
     Input Points, array of points which define the polygon, initial point does not
     need to be repeated at the end of the array.   Input boolean value
     "ScreenCoordinate" indicating whether Y values increase downward. PolygonArea
     sets the value of parameter "Clockwise" to true if polygon was created in a
     clockwise direction.  The function result is the area of the polygon.}
function PolygonArea(const points:array of TPoint;
                     const screencoordinates:boolean; {true ==> y increases downward}
                     var Clockwise:boolean):integer;



{InflatePolygon changes the size of a given polygon, "Points", by the given "inflateby" value.
 "Inflateby" is the perpendicular distance from the original polygo to the new
  polygion returned in the point array "Points2".  It is necessary for the
  procedured to calculate "Area" in determining which direction to expand, so it
  is returned as a freebie.  Set the  "ScreenCoordinates" to true before calling
  InflatePolygon if your Y values increase from top to bottom, false otherwise.}
procedure InflatePolygon(const points:array of Tpoint;
                        var points2: array of TPoint;
                        var area:integer;
                        const screenCoordinates:boolean;
                        const inflateby:integer);

{PolyBuiltClockwise reurns true if passed polygon was built in a clockwise direction}
function PolyBuiltClockwise(const points:array of TPoint;
                              const screencoordinates:boolean):boolean;



function DegtoRad(d:extended):extended;  {Degrees to radians}
function RadtoDeg(r:extended):extended;  {Radians to degrees}

{Move left end of line L, (L.P1) to "NewEnd"}
procedure TranslateLeftTo(var L:TLine; newend:TPoint); overload;
procedure TranslateLeftTo(var L:TrealLine; newend:TrealPoint); overload;

{Rotate Right end of line L, (L.P2) by alpha radians}
procedure RotateRightEndBy(var L:TLine; alpha:extended);

{Rotate Right end of line L (L.P2) to alpha radians}
procedure RotateRightEndTo(var L:TLine; alpha:extended); overload;

{Rotate Right end of line L (L.P2) to alpha radians}
procedure RotateRightEndTo(var p1,p2:Trealpoint; alpha:extended); overload;

{Find the intersection points of two circles if they exist, return false if
 no intersection}
function CircleCircleIntersect(c1,c2:TCircle;
                                  var IP1, Ip2: TPoint):boolean;  overload;
function CircleCircleIntersect(c1,c2:TRealCircle;
                                  var IP1, Ip2: TRealPoint):boolean; overload;

{Find the tangent lines L1 and L2 from point P to circle C.  Return false if no
 such lines exist (i.e. point is within the circle)}
function PointCircleTangentLines(const C:TCircle; const P:TPoint; var L1,L2:TLine):boolean;


{Calculate the two external tangents to the passed circles, C1 and C2}
{If the tangents exist, the function returns true ans returned values are:
  C3 - the circle within the larger circle to which initial tangents (L1,L2) from
       the center of the smaller signal are defined.
  L1,L2:  The intial intermediate tangnt lines.
  PL1,PL2L  Lines perpendicular to L1 and L2 along which the L1 and L2 will be
          translated.
  TL1,TL2: The final exterior lines tangent to C1 an C2.   }
function CircleCircleExtTangentLines(C1,C2:TCircle; var C3:TCircle;
                                var L1,L2,PL1,PL2,TL1,Tl2:TLine):Boolean;



implementation

Uses math ;

{********** Line ***********8}

function degtorad(d:extended):extended;
begin
 result:=d*Pi/180;
end;

function radtoDeg(r:extended):extended;
begin
 result:=r*180/pi;
end;


function realpoint(x,y:extended):TRealPoint;
begin
  result.x:=x;
  result.y:=y;
end;


function Line(const p1,p2:TPoint):Tline;
{Make a Tline record from two points}
begin
  result.p1:=p1;
  result.p2:=p2;
end;

function Line(const p1,p2:TRealPoint):TRealline;
{Make a Tline record from two points}
begin
  result.p1:=p1;
  result.p2:=p2;
end;

function Circle(const cx,cy,R:integer):TCircle;
{Make a TCircle record using passed center and radius}
  begin
    result.cx:=cx;
    result.cy:=cy;
    result.r:=r;
  end;

function Circle(const cx,cy,R:extended):TRealCircle;
{Make a TCircle record using passed center and radius}
  begin
    result.cx:=cx;
    result.cy:=cy;
    result.r:=r;
  end;

{************* GetTheta **************}
function GetTheta(const L:TLine):extended;
{return the angle of a line from p1 to p2}
begin
  with L do
  begin
     if p1.x<>p2.x then {make sure slope is not infinite}
     result:=arctan2((p2.y-p1.y),(p2.x-p1.x))
     else {vertical line}
     if p2.y<p1.y then result:=-pi/2 else result:=pi/2;
  end;
end;

{************* GetTheta **************}
function GetTheta(const p1,p2:TPoint):extended;
{return the angle of a line from p1 to p2}
begin
  begin
     if p1.x<>p2.x then {make sure slope is not infinite}
     result:=arctan2((p2.y-p1.y),(p2.x-p1.x))
     else {vertical line}
     if p2.y<p1.y then result:=-pi/2 else result:=pi/2;
  end;
end;

{************* GetTheta **************}
function GetTheta(const p1,p2:TRealPoint):extended;
{return the angle of a line from p1 to p2}
begin
  begin
     if p1.x<>p2.x then {make sure slope is not infinite}
     result:=arctan2((p2.y-p1.y),(p2.x-p1.x))
     else {vertical line}
     if p2.y<p1.y then result:=-pi/2 else result:=pi/2;
  end;
end;

{************** ExtendLine *************8}
procedure Extendline(var L:TLine; dist:integer);
{Extend a line segment by "dist" units}
var
  theta:extended;
begin
  theta:=gettheta(L);
  with l do
  begin
    p2.x:=p2.x+trunc(dist*cos(theta));
    p2.y:=p2.y+trunc(dist*sin(theta));
  end;
end;

{************** ExtendLine *************8}
procedure Extendline(var L:TRealLine; dist:extended);
{Extend a line segment by "dist" units}
var
  theta:extended;
begin
  theta:=gettheta(L.p1,L.p2);
  with l do
  begin
    p2.x:=p2.x+(dist*cos(theta));
    p2.y:=p2.y+(dist*sin(theta));
  end;
end;

{************ Dist *********}
function dist(const p1,p2:TRealPoint):extended;
{Extended distance }
begin
  result:=sqrt((sqr(p1.x-p2.x)+sqr(p1.y-p2.y)));
end;

{************ IntDist *********}
function intdist(const p1,p2:TPoint):integer;
{Integer distance }
begin
  result:=round(sqrt((sqr(p1.x-p2.x)+sqr(p1.y-p2.y))));
end;


{******************* LinesIntersect ****************}
function Linesintersect(line1,line2:TLine):boolean;
var
  IP:TrealPoint;
begin
   Result:=ExtendedLinesIntersect(line1,line2, false, IP);
end;


{*************** ExtendedLinesIntersect *************8}
function ExtendedLinesIntersect({Const} Line1,Line2:TLine;
                                Const extendlines:boolean;
                                var IP:TPoint):boolean; Overload;
{Find the intersection point of 2 lines, extended if necessary}
{Return true in IP if a single intersection point exists, false if parallel
 or collinear}
   {local procedure: getequation}
   procedure getequation(line:TLine;var slope,intercept:extended);
   begin
      If line.p1.x<>line.p2.x
      then slope:=(line.p2.y-line.p1.y)/ (line.p2.x-line.p1.x)
      else slope:=1E100;
      intercept:=line.p1.y-slope*line.p1.x;
   end;

  function overlap(const x,y:extended; const line:TLine):boolean;
  {return true if passed x and y are within the range of the endpoints of the
   passed line}
  begin
    If (x>=min(line.p1.x,line.p2.x))
        and (x<=max(line.p1.x,line.p2.x))
        and (y>=min(line.p1.y,line.p2.y))
        and (y<=max(line.p1.y,line.p2.y))
    then result:=true
    else result:=false;
  end;


var
  m1,m2,b1,b2:extended;

begin
  {Method -
     a. find the equations of the lines,
     b. find where they intersect
     c. if the point is between the line segment end points for both lines,
        then they do intersect, otherwise not.
  }
  result:=false;
  {general equation of line: y=mx+b}
  getequation(line1,m1,b1);
  getequation(line2,m2,b2);

  {intersection condition
     any point (x,y) on line1 satisfies y=m1*x+b1, the intersection
     point also satisfies the line2 equation y=m2*x+b2,
     so y=m1*x+b1=m2*x+b2

     solve for X -
       m1*x+b1=m2*x+b2
       x=(b2-b1)/(m1-m2)
  }
  if m1<>m2 then
  with IP do
  begin
    x:=round((b2-b1)/(m1-m2));
    if abs(m1) < abs(m2) then
    y:=round(m1*x+b1) {try to get y intercept from smallest slope}
    else y:=round(m2*x+b2); {but try the other equation}
    if extendlines then result:=true
    else
    begin
      {for intersection without extending lines,
        x,y "intersection point" must lie between the endpoints of both lines}
      {add 0.0 to force calculations to be in floating pt to avoid overflow
       when almost parallel lines with large intercepts are multiplied}
      if   ( (line1.p1.x-x+0.0)*(x-line1.p2.x+0.0) >= 0 )
        and ( (line1.p1.y-y+0.0)*(y-line1.p2.y+0.0) >= 0 )
        and ( (line2.p1.x-x+0.0)*(x-line2.p2.x+0.0) >= 0 )
        and ( (line2.p1.y-y+0.0)*(y-line2.p2.y+0.0) >= 0 )
      then result:=true;
    end
  end
  else if b1=b2 then  {slopes and intercepts are equal}
  begin  {lines are colinear }
    if extendlines then result:=true {if lines can be extended, we'll call them intersecting}
    else
    begin
      {if either end of line 1 is within the x and y range of line2, or
       either end of line2 is with the x,y range of line1, then
       then the lines a collinear. For simplicity, we'll just call it an intersection}

      with line1.p1 do result:=overlap(x,y, line2);
      If not result then  with line1.p2 do result:=overlap(x,y,Line2);
      if not result then with line2.p1 do result:=overlap(x,y,line1);
      if not result then with line2.p2 do result:=overlap(x,y,line1);
    end;
  end;
  {otherwise, slopes are equal and intercepts unequal
     ==> parallel lines ==> no intersection}
end;

{*************** ExtendedLinesIntersect *************8}
function ExtendedLinesIntersect(Const Line1,Line2:TLine;
                                Const extendlines:boolean;
                                var IP:TRealPoint):boolean; Overload;
{Find the intersection point of 2 lines, extended if necessary}
{Return true in IP if a single intersection point exists, false if parallel
 or collinear}
   {local procedure: getequation}
   procedure getequation(line:TLine;var slope,intercept:extended);
   begin
      If line.p1.x<>line.p2.x
      then slope:=(line.p2.y-line.p1.y)/ (line.p2.x-line.p1.x)
      else slope:=1E100;
      intercept:=line.p1.y-slope*line.p1.x;
   end;

  function overlap(const x,y:extended; const line:TLine):boolean;
  {return true if passed x and y are within the range of the endpoints of the
   passed line}
  begin
    If (x>=min(line.p1.x,line.p2.x))
        and (x<=max(line.p1.x,line.p2.x))
        and (y>=min(line.p1.y,line.p2.y))
        and (y<=max(line.p1.y,line.p2.y))
    then result:=true
    else result:=false;
  end;


var
  m1,m2,b1,b2:extended;

begin
  {Method -
     a. find the equations of the lines,
     b. find where they intersect
     c. if the point is between the line segment end points for both lines,
        then they do intersect, otherwise not.
  }
  result:=false;
  {general equation of line: y=mx+b}
  getequation(line1,m1,b1);
  getequation(line2,m2,b2);

  {intersection condition
     any point (x,y) on line1 satisfies y=m1*x+b1, the intersection
     point also satisfies the line2 equation y=m2*x+b2,
     so y=m1*x+b1=m2*x+b2

     solve for X -
       m1*x+b1=m2*x+b2
       x=(b2-b1)/(m1-m2)
  }
  if m1<>m2 then
  with IP do
  begin
    x:={round}((b2-b1)/(m1-m2));
    if abs(m1) < abs(m2) then
    y:={round}(m1*x+b1) {try to get y intercept from smallest slope}
    else y:={round}(m2*x+b2); {but try the other equation}
    if extendlines then result:=true
    else
    begin
      {for intersection without extending lines,
        x,y "intersection point" must lie between the endpoints of both lines}
      {add 0.0 to force calculations to be in floating pt to avoid overflow
       when almost parallel lines with large intercepts are multiplied}
      if   ( (line1.p1.x-x+0.0)*(x-line1.p2.x+0.0) >= -1e-5 )
        and ( (line1.p1.y-y+0.0)*(y-line1.p2.y+0.0) >= -1e-5 )
        and ( (line2.p1.x-x+0.0)*(x-line2.p2.x+0.0) >= -1e-5 )
        and ( (line2.p1.y-y+0.0)*(y-line2.p2.y+0.0) >= -1e-5 )
      then result:=true;
    end
  end
  else if b1=b2 then  {slopes and intercepts are equal}
  begin  {lines are colinear }
    if extendlines then result:=true {if lines can be extended, we'll call then intersecting}
    else
    begin
      {if either end of line 1 is within the x and y range of line2, or
       either end of line2 is with the x,y range of line1, then
       then the lines a collinear. For simplicity, we'll just call it an intersection}

      with line1.p1 do result:=overlap(x,y, line2);
      If not result then  with line1.p2 do result:=overlap(x,y,Line2);
      if not result then with line2.p1 do result:=overlap(x,y,line1);
      if not result then with line2.p2 do result:=overlap(x,y,line1);
    end;
  end;
  {otherwise, slopes are equal and intercepts unequal
     ==> parallel lines ==> no intersection}
end;


{******** FastGeoIntersect **********}
  {FastGeoIntersect adapted  from FastGeo }
(*************************************************************************)
(*                                                                       *)
(*                             FASTGEO                                   *)
(*                                                                       *)
(*                2D/3D Computational Geometry Algorithms                *)
(*                        Release Version 5.0.1                          *)
(*                                                                       *)
(* Author: Arash Partow 1997-2007                                        *)
(* URL: http://fastgeo.partow.net                                        *)
(*      http://www.partow.net/projects/fastgeo/index.html                *)
(*                                                                       *)
(* Copyright notice:                                                     *)
(* Free use of the FastGEO computational geometry library is permitted   *)
(* under the guidelines and in accordance with the most current version  *)
(* of the Common Public License.                                         *)
(* http://www.opensource.org/licenses/cpl.php                            *)
(*                                                                       *)
(*************************************************************************)

Type TFloat=extended;


var epsilon:TFloat= 1E-12;


function NotEqual(const a,b:extended):boolean;
begin
  result:=abs(a-b)>epsilon;
end;


function IsEqual(a,b:TFloat):boolean;
begin
  result:=abs(a-b)<=epsilon;
end;


var
  zero:TFloat=0.0;

function FastGeoIntersect(const x1,y1,x2,y2,x3,y3,x4,y4:extended;
                             var ix,iy:extended):Boolean;


var
  Ax        : TFloat;
  Bx        : TFloat;
  Cx        : TFloat;
  Ay        : TFloat;
  By        : TFloat;
  Cy        : TFloat;
  D         : TFloat;
  F         : TFloat;
  E         : TFloat;
  Ratio     : TFloat;
  UpperX    : TFloat;
  UpperY    : TFloat;
  LowerX    : TFloat;
  LowerY    : TFloat;

begin
  Result := false;

  Ax := x2 - x1;
  Bx := x3 - x4;

  if Ax < Zero then
  begin
    LowerX := x2;
    UpperX := x1;
  end
  else
  begin
    UpperX := x2;
    LowerX := x1;
  end;

  if Bx > Zero then
  begin
    if (UpperX < x4) or (x3 < LowerX) then
      Exit;
  end
  else if (Upperx < x3) or (x4 < LowerX) then
    Exit;

  Ay := y2 - y1;
  By := y3 - y4;

  if Ay < Zero then
  begin
    LowerY := y2;
    UpperY := y1;
  end
  else
  begin
    UpperY := y2;
    LowerY := y1;
  end;

  if By > Zero then
  begin
  if (UpperY < y4) or (y3 < LowerY) then
    Exit;
  end
  else if (UpperY < y3) or (y4 < LowerY) then
    Exit;

  Cx := x1 - x3;
  Cy := y1 - y3;
  d  := (By * Cx) - (Bx * Cy);
  f  := (Ay * Bx) - (Ax * By);

  if f > Zero then
  begin
    if (d < Zero) or (d > f) then
      Exit;
  end
  else if (d > Zero) or  (d < f) then
    Exit;

  e := (Ax * Cy) - (Ay * Cx);

  if f > Zero then
  begin
    if (e < Zero) or (e > f) then
      Exit;
  end
  else if (e > Zero) or (e < f) then
    Exit;

  Result := true;

  (*

    From IntersectionPoint Routine

    dx1 := x2 - x1; ->  Ax
    dx2 := x4 - x3; -> -Bx
    dx3 := x1 - x3; ->  Cx

    dy1 := y2 - y1; ->  Ay
    dy2 := y1 - y3; ->  Cy
    dy3 := y4 - y3; -> -By

  *)

  Ratio := (Ax * -By) - (Ay * -Bx);

  if NotEqual(Ratio,Zero) then
  begin
    Ratio := ((Cy * -Bx) - (Cx * -By)) / Ratio;
    ix    := x1 + (Ratio * Ax);
    iy    := y1 + (Ratio * Ay);
  end
  else
  begin
    //if Collinear(x1,y1,x2,y2,x3,y3) then
    if IsEqual((Ax * -Cy),(-Cx * Ay)) then
    begin
      ix := x3;
      iy := y3;
    end
    else
    begin
      ix := x4;
      iy := y4;
    end;
  end;
end;
(* End of SegmentIntersect *)




{This version  of Intersect converted to call FastGeoIntersect August 2008}

{*************** Intersect ***************}
function  intersect(L1,L2:TLine; var pointonborder:boolean; var IP:TPoint):boolean;
{Return true if line segments L1 and L2 intersect,
 also indicate if just touching and return the intersection point coordinates}
 var
   IPReal:TrealPoint;
 begin
   result:= FastGeointersect(L1.p1.x,L1.p1.y, L1.p2.x, L1.p2.y,
                        L2.p1.x,L2.p1.y, L2.p2.x, L2.p2.y,
                        ipreal.x,ipreal.y);
   if result then
   begin
     ip.x:=round(ipreal.x);
     ip.y:=round(ipreal.y);
     with ip do
     if ((x=L1.p1.x) and (y=L1.p1.y))
     or ((x=L1.p2.x) and (y=L1.p2.y))
     or ((x=L2.p1.x) and (y=L2.p1.y))
     or ((x=L2.p2.x) and (y=L2.p2.y))
     then PointOnBorder:=true
     else PointOnBorder:=false;
   end
   else
   begin
     PointOnBorder:=false;
     ip.x:=0;
     ip.y:=0;
   end;
 end;


{**************** PointPerpendicularLine **********}
function PointPerpendicularLine(L:TLine; P:TPoint):TLine;
{Define the line through point P and perpendicular to Line L}
var
  m1,m2,b1,b2:extended;
  rx:extended;
begin
  with L do   {get slope and intercept for Line L}
  begin
     if p1.x<>p2.x then {make sure slope is not infinite}
     m1:=(p2.y-p1.y)/(p2.x-p1.x)  else m1:=1e20;
     b1:=p1.y-m1*p1.x;
  end;
  with result do
  begin
    p1:=p;
    if m1<>0 then
    begin
      m2:=-1/m1; {slope of perpendicular line}
      b2:=p.y-m2*p.x; {intercept of perpendicular line}
      rx:=(b2-b1)/(m1-m2);
      p2.x:=round(rx); {intersection point of the two lines}
      p2.y:=round(m2*rx+b2);
    end
    else
    begin  {line 1 was horizontal so this one must be vertical}
      p2.x:=p1.x;
      p2.y:=L.p2.y;
    end;
  end;
end;

{************ PerpDistance ************}
function PerpDistance(L:TLine; P:TPoint):Integer;
{Define the line through point P and perpendicular to Line L}
var
  m1,m2,b1,b2:extended;
  rx:extended;
  line2:TLine;
begin
  with L do   {get slope and intercept for Line L}
  begin
     if p1.x<>p2.x then {make sure slope is not infinite}
     m1:=(p2.y-p1.y)/(p2.x-p1.x)  else m1:=1e20;
     b1:=p1.y-m1*p1.x;
  end;
  with line2 do
  begin
    p1:=p;
    if m1<>0 then
     begin
        m2:=-1/m1; {slope of perpendicular line}
        b2:=p.y-m2*p.x; {intercept of perpendicular line}
        rx:=(b2-b1)/(m1-m2);
        p2.x:=round(rx); {intersection point of the two lines}
        p2.y:=round(m2*rx+b2);
    end
    else
    begin  {line 1 was horizontal so this one must be vertical}
      p2.x:=p1.x;
      p2.y:=L.p2.y;
    end;
    if (p1.x=p2.x) and (p1.y=p2.y) then result:=0
    {make sure that p2 of line2 is actually on the line}
    else if not Linesintersect(L,Line2) then result:=1000000
    else result:=round(intdist(p1,p2));
  end;
end;

 function AngledLineFromLine(L:TLine; P:TPoint; Dist:extended; alpha:extended):TLine;
 begin
   result:=AngledLineFromLine(L,P,Dist,alpha,true);
 end;
{**************** AngledLineFromLine **********}
 function AngledLineFromLine(L:TLine; P:TPoint; Dist:extended; alpha:extended;
                 useScreenCoordinates:boolean):TLine;
{compute a line from point, P, on line, L, for a specified distance, dist
 at angle, alpha (in radians) }
var theta, newangle:extended;
begin


  with L do
  begin
     if not usescreencoordinates then
     begin
       p1.y:=-p1.y;
       p2.y:=-p2.y;
     end;
     if p1.x<>p2.x then {make sure slope is not infinite}
     theta:=arctan2((p1.y-p2.y),(p2.x-p1.x))
     else {vertical line}
     if p2.y<p1.y then theta:=pi/2 else theta:=-pi/2;
  end;
  with result do
  begin
    p1:=p;
    newangle:=theta+alpha;
    p2.x:=p.x+round(dist*cos(newangle));
    p2.y:=p.y-round(dist*sin(newangle));
  end;
end;



{********** PolygonArea ***************}
function PolygonArea(const points:array of TPoint;
                     const screencoordinates:boolean; {true ==> y increases downward}
                     var Clockwise:boolean):integer;
{Area solution}
var
  i,index,a:integer;
  x1,x2,y1,y2:integer;
  points2:array of TPoint;
  maxy:integer;
begin
  A:=0;
  setlength(points2,length(points));
  maxy:=0;
  if screencoordinates then
  begin
    for i:=0 to high(points) do  if points[i].y>maxy then maxy:=points[i].y;
    for i:=0 to high(points) do
    begin
      points2[i].x:=points[i].x;
      points2[i].y:=maxy-points[i].y;
    end;
  end
  else for i:=0 to high(points) do points2[i]:=points[i];

  for i:= 0 to high(points2) do
  begin
    x1:= points2[i].x;
    y1:= points2[i].Y;
    if i=high(points2) then index:=0
    else index:=i+1;
    x2:= points2[index].x;
    y2:= points2[index].y;
    A:= A+x1*y2 - y1*x2;
  end;
  clockwise:=a<0;
  result:=abs(round(0.5*A));
end;


{************** Polybuiltclockwise **************}
function PolyBuiltClockwise(const points:array of TPoint;
                            const screencoordinates:boolean):boolean;
var clockwise:boolean;
begin
  PolygonArea(points,Screencoordinates,clockwise);
  result:=clockwise;
end;

{************ InflatePolygon ***********}
procedure InflatePolygon(const Points:array of Tpoint;
                        var Points2: array of TPoint;
                        var area:integer;
                        const screenCoordinates:boolean;
                        const inflateby:integer);
   var
     i:integer;
     clockwise:boolean;
     v:integer;
     IP:TPoint;
     L,L2,Ltemp,L0,PrevL:TLine;
   begin
        for i:= 0 to high(Points) do Points2[i]:=Points[i];
        Area:=PolygonArea(Points, Screencoordinates, clockwise);
        if clockwise then v:=-inflateby else v:=inflateby;
        for  i:=0 to high(Points) do
        begin
          {Find the point perpendicular to each edge at given inflate
           distance, V, for each end of the edge}
          if i>0 then L2.p1:=Points[i-1]
          else l2.p1:=Points[high(Points2)];
          L2.p2:=Points[i];
          Ltemp:=AngledLineFromLine(L2,L2.p1,V,-Pi/2);
          L.p1:=Ltemp.p2; {we only need the far end of the perpendicular line}
          Ltemp:=AngledLineFromLine(L2,L2.p2,V,-Pi/2);
          L.p2:=Ltemp.p2; {here is the perp point for the other end of the edge}

          if (i>0)
          then
            if ExtendedLinesIntersect(L,PrevL,true,IP)
            then  Points2[i-1]:=IP
          else showmessage('expand failed for line ' +inttostr(i));
          prevL:=L;
          if i=0 then L0:=L; {save first line to use at end of loop}
        end;
        {check last line}
        if ExtendedLinesintersect(L,L0,true,IP) then Points2[high(Points2)]:=IP
        else showmessage('expand failed for closing line');
    end;

{************* PointInPoly *************}
function PointInPoly(const p:TPoint; Points:array of Tpoint):PPResult;
{determine where point P lines in relation to the polygon defined by
 arrray "points". }

 var
  i,count:integer;
  lt,lp:TLine;
  IP:TPoint;
  ob:boolean;
  OK:Boolean;
  loopcount:integer;
  pyinc:integer;

      function between(p1,p2,p3:TPoint):boolean;
      {Is p1 within the rectangle formed by p2 and p3?}
      begin
        if     (p1.x<=max(p2.x,p3.x)) and (p1.x>=min(p2.x,p3.x))
           and (p1.y<=max(p2.y,p3.y)) and (p1.y>=min(p2.y,p3.y))
        then result:=true
        else result:=false;
      end;


  begin
    count:=0;
    result:=PPError;
    for i:=0 to high(Points){nbrpoints} do
    begin
      if (p.x=points[i].x) and (p.y=points[i].y) then
      begin
        result:=PPVertex;
        break;
      end;
    end;
    if result<> PPVertex then
    begin

      {Lt = extension of line from point to infinity" in the X direction}
      lt.p1:=p;
      lt.p2.y:=0;  lt.p2.x:=10000;//{100000?}
      pyinc:=10;
      loopcount:=0; {safety stop,  prevent infinite loops}
      repeat
        OK:=true;
        inc(loopcount);
        lt.p2.y:=lt.p2.y+pyinc{10};  {we'll change the angle of the line from the point
                                 to infinity until, we get one that does not intersect
                                 any vertices of the polygon}
        //drawline(lt);
        for i:=0 to high(Points){nbrpoints} do
        begin
          {Set line Lp equal to each edge of the polygon}
          lp.p1:=points[i];
          If i<high(Points){nbrpoints} then lp.p2:=points[i+1] else lp.p2:=points[0];

          {See if the edge and the line intersect}
          if Intersect(lt,lp,ob,IP) then
          begin
            if  not ob then inc(count)
            else
            begin  {could be confusion here - the point may really be on the border,
                or the polygon vertex could be on the extension of our line running
                east from the given point}
              {If our extension line goes througn a vertex, we'll change the
               direction until we find one that does not intersect a vertex}
              if (lp.p1.y=Ip.y) and (lp.p1.x=Ip.x) then
              begin
                ok:=false;
                break;
              end
              else if (Ip.x=p.x) and (ip.y=p.y) then
              begin  {point is neither inside nor outside - it's on an edge}
                result:=PPEdge;
                break;
              end;
            end;
          end;
        end;
      until OK or (loopcount>2000);
      If loopcount>2000 then result:=PPError
      else
      begin
        if (count mod 2)=1 then result:=PPInside
        else result:=PPOutside;
      end;
    end;
 end;



{********** TranslateLeftTo ***********}
procedure TranslateLeftTo(var L:TLine; newend:TPoint);
{Translate line so left end (P1)  is moved to "newend"}
var
  dx,dy:integer;
begin
  with L do
  begin
    dx:=newend.x-p1.x;
    dy:=newend.Y-p1.Y;
    inc(p2.x,dx);
    inc(p2.Y,dy);
    inc(p1.X,dx);
    inc(p1.Y,dy);
  end;
end;

{********** TranslateLeftTo ***********}
procedure TranslateLeftTo(var L:TRealLine; newend:TRealPoint);
{Translate line so left end (P1)  is moved to "newend"}
var
  dx,dy:extended;
begin
  with L do
  begin
    dx:=newend.x-p1.x;
    dy:=newend.Y-p1.Y;
    p2.x:=p2.x+dx;
    p2.Y:=p2.Y+dy;
    p1.x:=p1.X+dx;
    p1.Y:=p1.Y+dy;
  end;
end;

(*
procedure msg(s:string);
begin {for debugging}
  form1.memo7.lines.add(s);
end;
*)


{************* RotatRightEndTo **************}
procedure RotateRightEndTo(var L:TLine; alpha:extended);
var
  p1,p2:TRealpoint;
begin
  with p1 do begin x:=L.p1.x;  y:=L.p1.y;  end;
  with p2 do begin x:=L.p2.x;  y:=L.p2.y;  end;
  RotateRightEndTo(p1,p2,alpha);
  with p1 do begin L.p1.x:=round(x);  L.p1.y:=round(y);  end;
  with p2 do begin L.p2.x:=round(x);  L.p2.y:=round(y);  end;
end;



{************* RotatRightEndTo **************}
procedure RotateRightEndTo(var p1,p2:TRealPoint; alpha:extended);
var
  t:TrealPoint;
  d, sinalpha, cosalpha:extended;
  //tempLine:TLine;
  savep1:TRealpoint;
begin
  //templine:=L;
  //with Templine do
  begin
    {translate Left end to (0,0)}
    saveP1:=p1;
    p2.x:=p2.x-p1.x;
    p2.Y:=p2.y-p1.Y;
    p1.X:=0;
    p1.Y:=0;
  end;
    //msg(format('After translate (%d,%d)(%d,%d)',[p1.x,p1.y,p2.x,p2.y]));
    t:=p2;
    d:=dist(p1,p2);
    sinalpha:=sin(alpha);
    cosalpha:=cos(alpha);
    //msg(format('Angle Alpha %d, Cos: %5.2f, sin %5.2f',[trunc(radtodeg(alpha)),cosalpha,sinalpha]));
    p2.x:={round}(d*cosalpha);
    p2.y:={round}(d*sinalpha);
  //translateleftto(templine,L.p1); {Move the line back to it's original start loc}
  p2.x:=p2.x+savep1.x;
  p2.y:=p2.y+saveP1.y;
  p1:= savep1;
  //L:=templine;
end;

{************* RotatRightEndBy **************}
procedure RotateRightEndBy(var L:TLine; alpha:extended);
var
  t:TPoint;
  sinalpha, cosalpha:extended;

  tempLine:TLine;
begin
  templine:=L;
  with Templine do
  begin
    translateLeftTo(templine,point(0,0));
    //msg(format('After translate (%d,%d)(%d,%d)',[p1.x,p1.y,p2.x,p2.y]));
    t:=p2;
    sinalpha:=sin(alpha);
    cosalpha:=cos(alpha);
    //msg(format('Angle Alpha %d, Cos: %5.2f, sin %5.2f',[trunc(radtodeg(alpha)),cosalpha,sinalpha]));
    p2.x:=trunc(t.x*cosalpha-t.y*sinalpha);
    p2.y:=trunc(t.x*sinalpha+t.y*cosalpha);
  end;
  translateleftto(templine,L.p1); {Move the line back to it's original start loc}
  L:=templine;
end;

{*************** CircleCircleIntersect **********8}
function CircleCircleIntersect(c1,c2:TCircle; var IP1, Ip2: TPoint):boolean;
var
 L, IL1, IL2:TLine;
 theta,d:extended;
 xr:extended;
 cosalpha,alpha:extended;
begin
  L:=Line(point(c1.cx,c1.cy),point(c2.cx,c2.cy));
  d:=intdist(L.p1,L.p2);
  if (d<c1.r+c2.r) and (d+min(c1.r,c2.r)>max(c1.r,c2.r)) then {the circles intersect}
  with L do
  begin
    theta:=gettheta(L);
    TranslateLeftTo(L,point(0,0));
    xr:=(sqr(d)-sqr(c2.r)+sqr(c1.r))/(2*d); {x coordinate of intersection}
    cosalpha:=xr/c1.r;
    alpha:=arccos(cosalpha);
    IL1:=line(L.p1,point(c1.r,0));
    IL2:=line(L.p1,point(c1.r,0));
    RotateRightEndto(IL1,-alpha+theta);
    TranslateleftTo(IL1,point(c1.cx,c1.cy));
    RotateRightEndto(IL2,alpha+theta);
    TranslateleftTo(IL2,point(c1.cx,c1.cy));
    IP1:=IL1.p2;  {the intersection ppoints of the two circles}
    IP2:=IL2.p2;
    result:=true;
  end
  else result:=false;
end;

{*************** CircleCircleIntersect **********8}
function CircleCircleIntersect(c1,c2:TRealCircle; var IP1, Ip2: TRealPoint):boolean;
var
 L, IL1, IL2:TRealLine;
 theta,d:extended;
 xr:extended;
 cosalpha,alpha:extended;
begin
  L:=Line(realpoint(c1.cx,c1.cy),realpoint(c2.cx,c2.cy));
  d:=dist(L.p1,L.p2);
  if (d<=c1.r+c2.r) and (d+min(c1.r,c2.r)>=max(c1.r,c2.r)) then {the circles intersect}
  with L do
  begin
    theta:=gettheta(L.p1,l.p2);
    TranslateLeftTo(L,realpoint(0,0));
    xr:=(sqr(d)-sqr(c2.r)+sqr(c1.r))/(2*d); {x coordinate of intersection}
    if c1.r=0 then cosalpha:=1 else cosalpha:=xr/c1.r;
    alpha:=arccos(cosalpha);
    IL1:=line(L.p1,realpoint(c1.r,0));
    IL2:=line(L.p1,realpoint(c1.r,0));
    RotateRightEndto(IL1.p1,IL1.p2,-alpha+theta);
    TranslateleftTo(IL1,realpoint(c1.cx,c1.cy));
    RotateRightEndto(IL2.p1,il2.p2,alpha+theta);
    TranslateleftTo(IL2,realpoint(c1.cx,c1.cy));
    IP1:=IL1.p2;  {the intersection ppoints of the two circles}
    IP2:=IL2.p2;
    result:=true;
  end
  else result:=false;
end;

function PointCircleTangentLines(const C:TCircle; const P:TPoint; var L1,L2:TLine):boolean;
{To find the points of tangency:}
    {1. find the midpoint,M, of line L}
    {2. define the circle, C1, centered on M through the endpoints of L}
    {3  define the circle, C2, centerd on the original circlem Circle[1]}
    {4. Find the intersection point of C1 and C2, call them IP1 and IP2}
    {5. Define the tangent lines, L1, L2, from the point P through IP1 and IP2}
 var
  d:integer;
  pc, m, Ip1, Ip2:TPoint;
  L:TLine;
  C1,C2:TCircle;
begin
  result:=true;
  with C do
  begin
    d:=intdist(point(c.cx,c.cy),P);
    pc:=point(cx,cy);
    L:=line(pc,p);
    M:=point((cx+p.x) div 2, (cy+p.Y) div 2);
    C1:=Circle(m.x, m.y, d div 2);
    C2:=C;
    if circleCircleIntersect(C1,C2,Ip1,Ip2) then
    begin
      L1:=line(P,Ip1);
      L2:=Line(P,Ip2);
    end
    else result:=false;
  end;
end;

{****************** CircleCircleExtTangentLines *****************}
function CircleCircleExtTangentLines(C1,C2:TCircle; var C3:TCircle; var L1,L2,PL1,PL2,TL1,Tl2:TLine):Boolean;
{Calculate the two external tangents to the passed circles, C1 and C2}
{If the tangents exist, the function returns true ans returned values are:
  C3 - the circle within the larger circle to which initial tangents (L1,L2) from
       the center of the smaller signal are defined.
  L1,L2:  The intial intermediate tangnt lines.
  PL1,PL2L  Lines perpendicular to L1 and L2 along which the L1 and L2 will be
          translated.
  TL1,TL2: The final exterior lines tangent to C1 an C2.
}
var
  pc:TPoint;
  TempC:TCircle;
begin
  result:=true;
  if c1.r<c2.r then {make sure that c1 is not smaller than C2}
  begin {swap them}
    TempC:=c1;
    c1:=c2;
    c2:=TempC;
  end;
  pc:=point(c1.cx,c1.cy);
  c3:=circle(pc.x,pc.y, c1.r-c2.r);
  If PointCircleTangentLines(C3,point(c2.cx,c2.cy),L1,L2) then
  begin
    {calculate perpendicular line to L1 point-circle tangent}
    PL1:=AngledLineFromLine(L1, point(c2.cx,c2.cy), c2.r,Pi/2);
    {Move L1 tangent line out from C2 center to C2 boundary}
    TL1:=L1;
    TranslateLeftTo(TL1, PL1.P2);
    {calculate perpendicular line to L2 point-circle tangent}
    PL2:=AngledLineFromLine(L2, point(c2.cx,c2.cy), c2.r, -Pi/2);
    {Move L2 tangent line out from C2 center to C2 boundary}
    TL2:=L2;
    TranslateLeftTo(TL2, PL2.P2);
  end
  else result:=false;
end;

end.


