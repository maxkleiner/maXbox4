unit UGeometry;
{Copyright  © 2005-2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved  }

{General usage Computational Geometry procedures and functions} 

interface

uses Windows, Sysutils, Dialogs;
type
  Tline=record
    p1,p2:TPoint; {starting and ending points of a line segment}
  end;

 TrealPoint=record
   x,y:extended;
 end;

  PPResult=(PPoutside, PPInside, PPVertex, PPEdge, PPError);

  {integer distance bertween two points}
  function intdist(const p1,p2:TPoint):integer;

  {Make a line from two points}
  function Line(const p1,p2:TPoint):Tline;

  {Do two line segments intersect?}
  function Linesintersect(line1,line2:TLine):boolean;

  {Another version which will optionally extend line if necessasry to determine
   point of intersection.  Also returns the point  of intersection if it exists}
  function ExtendedLinesIntersect(Const Line1,Line2:TLine;
                                  Const extendlines:boolean;
                                  var IP:TPoint):boolean;  overload;
  function ExtendedLinesIntersect(Const Line1,Line2:TLine;
                                  Const extendlines:boolean;
                                  var IP:TRealPoint):boolean; overload;

  {A more complex (and probably slower) version which identifies the intersection
  point and whether either end of either line falls exaclty on the other line}


  function Intersect(L1,L2:TLine; var pointonborder:boolean; var IP:TPoint):boolean;


  

  {Find the line from a given point which is perpendicular to a given line}
  {p1 of the returned line is the given point, p2 is the intersection point of the
   given line and the reutrned line}
  function PointPerpendicularLine(L:TLine; P:TPoint):TLine;

  {Return the perpendicular distance from a point to given line}
  function PerpDistance(L:TLine; P:TPoint):Integer;

  {Define the line through a given point intersecting a given line at a given angle}
  function AngledLineFromLine(L:TLine; P:TPoint; Dist:extended; alpha:extended):TLine;

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

implementation

Uses math;

{********** Line ***********8}
function Line(const p1,p2:TPoint):Tline;
{Make a line from two points}
begin
  result.p1:=p1;
  result.p2:=p2;
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
function ExtendedLinesIntersect(Const Line1,Line2:TLine;
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

{**************** AngledLineFromLine **********}
 function AngledLineFromLine(L:TLine; P:TPoint; Dist:extended; alpha:extended):TLine;
{compute a line from point, P, on line, L, for a specified distance, dist
 at angle, alpha.  }
var theta, newangle:extended;
begin
  with L do
  begin
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
      lt.p2.y:=0;  lt.p2.x:=1000;
      loopcount:=0; {safety stop, to prevent infinite loops}
      repeat
        OK:=true;
        inc(loopcount);
        lt.p2.y:=lt.p2.y+10;  {we'll change the angle of the line from th point
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
      until OK or (loopcount>200);
          If loopcount>200 then result:=PPError
      else
      if result = PPError then
      begin
        if (count mod 2)=1 then result:=PPInside
        else result:=PPOutside;
      end;
    end;
  end;





end.


