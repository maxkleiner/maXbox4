Unit U_Splines;
{------------------------------------------------------------------------------}
{                                                                              }
{ This unit was generated on 22-05-97 11:50:12 by                              }
{    the RTE Software Component Generator.                                     }
{                                                                              }
{                                                                              }
{ This code was written by : M. v. Engeland                                    }
{                                                                              }
{ This code is copyright 1997 by                                               }
{       M. v. Engeland                                                         }
{                                                                              }
{                                                                              }
{   This is a freeware component for handling B-splines. You may use this      }
{   component in any way you want to, as long as you don't sell it or use      }
{   it for commercial applications. But I would appreciate it if you would     }
{   send me an e-mail (martijn@dutw38.wbmt.tudelft.nl) to tell me why you use  }
{   it, what program you use it for or if you appreciate it. Also all comments }
{   and/or remarks are welcome. Currently I'm working on a component for       }
{   handling and displaying NURBS and NURB surfaces. Both components are       }
{   developed to be part of a 3D-CAD program for designing ship hulls at the   }
{   Delft Technical University in the Netherlands. See the demo program        }
{   for handling the component. Special attention is payed on the possibility  }
{   of interpolating the vertices. As you may know B-Splines do not            }
{   interpolate the used vertices. Thanks to matrix calculation it is possible }
{   interpolate the by means of calculating a number of knew vertices in such  }
{   a way that the spline interpolates the original ones.                      }
{------------------------------------------------------------------------------}

{Modified by Gary Darby - Sept 2001
{  . Converted from component to unit
   . Replaced point logic for Vertexlist and Matrix with dynamic arrays
   . Added LoadFromStream and SaveToStream procedures
}


interface

uses windows,
     sysutils,
     classes,
     dialogs{,}
     {dsgnintf};

const MaxNoVertices = 100; {Maximum number of vertices in a spline. Could be more though..'}

type
  TVertex = record {All vertices are 3D. Simply remove the Z-variable if you want to work 2D}
              X,Y : Single;
            end;
  TSplineRow = array of TVertex; {Dynamic array to keep memory use minimal and speed maximal !}
  TBSpline   = class         {B-Spline object}
  private
    NoPoints      : Integer;
    VertexList    : TSplineRow;
    FInterpolated : boolean;
  public
    constructor Create;
    procedure   Free;
    procedure   Clear;
    procedure   PhantomPoints; {B-Splines use phantompoints to interpolate begin and end points}
    procedure   Interpolate;   {B-Splines can interpolate vertices if you want them to !}
    function    Value(Parameter:Single):TVertex; {Value of a spline. Valid for parameter 0 (Start of spline
                                                  through 1 (end of line)}
    procedure   AddVertex(Vertex:TVertex);
    procedure   InsertVertex(Pos:Integer;Vertex:TVertex);
    procedure   DeleteVertex(VertexNr:word);
    procedure   ChangeVertex(VertexNr:word;X,Y:Single);
    function    NumberOfVertices:word;
    Function    VertexIsKnuckle(var Nr:integer):boolean; {A knuckle is obtained y inserting a vertex 3 times}
    procedure   KnuckleOn(Nr:integer);
    procedure   KnuckleOff(Nr:integer);
    Function    VertexNr(Nr:integer):TVertex;
    procedure   SaveToStream(st:TStream);
    procedure   LoadFromStream(st:TStream);
 published
    property Interpolated:boolean read FInterpolated;
end;    
TSplines = class(TObject {TComponent}) {Component to store all B-Splines in}
   private    { Private Declarations }
      FSplineRow       : TList;
      function GetNumberOfSplines: word;
      protected  { Protected Declarations }
   public     { Public Declarations }
      constructor Create{(AOwner: TComponent)}; {override;}
      destructor  Destroy; override;
      procedure   AddSpline(BSpline:TBSpline);
      procedure   Clear;
      procedure   InsertSpline(Pos:Integer;BSpline:TBSpline);
      procedure   DeleteSpline(BSpline:TBSpline);
      function    GetSplineNr(Nr:Word): TBSpline;
   published
      property NumberOfSplines: word read GetNumberOfSplines;
end;

procedure Register;

implementation
  uses fmain;

constructor TBSpline.Create;
begin
   inherited create;
   FInterpolated:=true;
   NoPoints:=0;
   Setlength(VertexList,MaxNoVertices+2)
   {GetMem(VertexList,(MaxNoVertices+2)*SizeOf(TVertex));}
end;{TBSpline.Create}

procedure TBSpline.Free;
begin
   setlength(vertexlist,0);
   {if VertexList<>nil then FreeMem(VertexList,(MaxNoVertices+2)*SizeOf(TVertex));}
   maxForm1.memo2.lines.Add('debug tbspline free');
   inherited free;
end;{TBSpline.Free}

procedure TBSpline.Clear;
begin
   FInterpolated:=false;
   NoPoints:=0;
end;{TBSpline.Clear}

procedure TBSpline.PhantomPoints;
{force "phantom" start and end points}
begin
   if NoPoints>1 then
   begin
      VertexList[0].x:=2*VertexList[1].x-VertexList[2].x;
      VertexList[0].y:=2*VertexList[1].y-VertexList[2].y;
      VertexList[NoPoints+1].x:=2*VertexList[NoPoints].x-VertexList[NoPoints-1].x;
      VertexList[NoPoints+1].y:=2*VertexList[NoPoints].y-VertexList[NoPoints-1].y;
   end;
end;{TBSpline.PhantomPoints}

procedure TBSpline.Interpolate;
const MaxError    = 1e-6;
      MatrixSize  = MaxNoVertices+2;
type  TMatrix     = array of array of single;
      {PMatrix     = ^TMatrix;}
var Matrix  : TMatrix;
    a,b,c   : integer;
    Factor  : single;
    Tmp     : TSplinerow;
begin
   if NoPoints<3 then exit;
   Setlength(Matrix,NoPoints+2,NoPoints+2);
   {GetMem(Tmp,(NoPoints+2)*SizeOf(TVertex));
   Size:=SizeOf(TMatrix);
   GetMem(Matrix,Size);
   }
   FillChar(matrix,(NoPoints+2)*(nopoints+2)*sizeof(single),0);

   for a:=2 to NoPoints-1 do
   begin
      matrix[a,a-1]:=1/6;
      matrix[a,a]:=2/3;
      matrix[a,a+1]:=1/6;
   end;
   Matrix[1,1]:=1;
   Matrix[NoPoints,NoPoints]:=1;
   for a:=2 to NoPoints-1 do
      if (abs(VertexList[a].x-VertexList[a-1].x)<1e-5) and (abs(VertexList[a].x-VertexList[a+1].x)<1e-5)
     and (abs(VertexList[a].y-VertexList[a-1].y)<1e-5) and (abs(VertexList[a].y-VertexList[a+1].y)<1e-5)
     then for b:= a-1 to a+1 do
     begin
        matrix[b,b-1]:=0;
        matrix[b,b]:=1;
        matrix[b,b+1]:=0;
     end;

   for a:=1 to NoPoints do if abs(Matrix[a,a])<MaxError then exit;
   setlength(tmp,Nopoints+2);
   for a:=1 to NoPoints do
   for b:=a+1 to NoPoints do
   begin
     factor:=Matrix[b,a]/Matrix[a,a];
     for c:=1 to NoPoints do Matrix[b,c]:=matrix[b,c]-factor*matrix[a,c];
     VertexList[b].x:=VertexList[b].x-factor*VertexList[b-1].x;
     VertexList[b].y:=VertexList[b].y-factor*VertexList[b-1].y;
   end;
   Tmp[NoPoints].x:=VertexList[NoPoints].x/Matrix[NoPoints,NoPoints];
   Tmp[NoPoints].y:=VertexList[NoPoints].y/Matrix[NoPoints,NoPoints];
   for a:=NoPoints-1 DOWNTO 1 do
   begin
      Tmp[a].x:=(1/Matrix[a,a])*(VertexList[a].x-Matrix[a,a+1]*Tmp[a+1].x);
      Tmp[a].y:=(1/Matrix[a,a])*(VertexList[a].y-Matrix[a,a+1]*Tmp[a+1].y);
   end;
   move(tmp,VertexList,sizeof(Tmp));
   PhantomPoints;
   FInterpolated:=true;
end;{TBSpline.Interpolate}

function TBSpline.Value(Parameter:Single):TVertex;
var b,c   : integer;
    Dist  : extended;
    Mix  : extended;
begin
   Result.X:=0;
   Result.Y:=0;
   b:=trunc((NoPoints-1)*Parameter);
   FOR c:=b-2 TO b+3 DO
   BEGIN
      dist:=abs((NoPoints-1)*parameter-(c-1));
      IF dist<2 THEN
      BEGIN
         IF dist<1 THEN mix:=4/6-dist*dist+0.5*dist*dist*dist ELSE
                        mix:=(2-dist)*(2-dist)*(2-dist)/6;
         result.x:=result.x+VertexList[c].x*mix;
         result.y:=result.y+VertexList[c].y*mix;
      END;
   eND;
end;{TBSpline.Value}

Function TBSpline.VertexIsKnuckle(var Nr:integer):boolean;
var V1,V2,V3 : TVertex;
begin
   Result:=false;
   if (Nr>1) and (Nr<NoPoints-1) then
   begin
      V1:=VertexNr(Nr-2);
      V2:=VertexNr(Nr-1);
      V3:=VertexNr(Nr);
      if (abs(V1.X-V2.X)<1e-5) and (abs(V2.X-V3.X)<1e-5) and (abs(V1.Y-V2.Y)<1e-5) and (abs(V2.Y-V3.Y)<1e-5) then
      begin
         Result:=true;
         Nr:=Nr-1;
         exit;
      end;
      V1:=VertexNr(Nr-1);
      V2:=VertexNr(Nr);
      V3:=VertexNr(Nr+1);
      if (abs(V1.X-V2.X)<1e-5) and (abs(V2.X-V3.X)<1e-5) and (abs(V1.Y-V2.Y)<1e-5) and (abs(V2.Y-V3.Y)<1e-5) then
      begin
         Result:=true;
         exit;
      end;
      V1:=VertexNr(Nr);
      V2:=VertexNr(Nr+1);
      V3:=VertexNr(Nr+2);
      if (abs(V1.X-V2.X)<1e-5) and (abs(V2.X-V3.X)<1e-5) and (abs(V1.Y-V2.Y)<1e-5) and (abs(V2.Y-V3.Y)<1e-5) then
      begin
         Result:=true;
         Nr:=Nr+1;
         exit;
      end;
   end;
end;{TBSpline.VertexIsKnuckle}

procedure TBSpline.KnuckleOn(Nr:integer);
var I : integer;
begin
   if NoPoints<MaxNoVertices-2 then
   begin
      Inc(NoPoints,2);
      For I:=NoPoints downto Nr+2 do VertexList[I]:=VertexList[I-2];
      VertexList[Nr+1]:=VertexList[Nr];
      VertexList[Nr+2]:=VertexList[Nr];
      PhantomPoints;
   end else MessageDlg('Maximum number of vertices reached.',mtError,[mbOk],0);
end;{TBSpline.KnuckleOn}

procedure TBSpline.KnuckleOff(Nr:integer);
begin
   if NoPoints>2 then
   begin
      if VertexIsKnuckle(Nr) then
      begin
         DeleteVertex(Nr+1);
         DeleteVertex(Nr-1);
      end;
   end;
end;{TBSpline.KnuckleOff}

procedure TBSpline.InsertVertex(Pos:Integer;Vertex:TVertex);
{insert new vertex after vertex # "Pos"}
var I : integer;
begin
   if NoPoints<MaxNoVertices then
   begin
      inc(NoPoints);
      for I:=NoPoints-1 downto Pos do VertexList[I+1]:=VertexList[I];
      VertexList[Pos]:=Vertex;
      PhantomPoints;
   end else MessageDlg('Maximum number of vertices reached.',mtError,[mbOk],0);
end;{TBSpline.InsertVertex}

procedure TBSpline.AddVertex(Vertex:TVertex);
begin
   if NoPoints<MaxNoVertices then
   begin
      inc(NoPoints);
      VertexList[NoPoints]:=Vertex;
      PhantomPoints;
   end else MessageDlg('Maximum number of vertices reached.',mtError,[mbOk],0);
end;{TBSpline.AddVertex}

procedure TBSpline.ChangeVertex(VertexNr:word;X,Y:Single);
begin
   if (VertexNr>0) and (VertexNr<=NoPoints) then
   begin
      VertexList[VertexNr].X:=X;
      VertexList[VertexNr].Y:=Y;
      PhantomPoints;
   end;
end;{TBSpline.ChangeVertex}

procedure TBSpline.DeleteVertex(VertexNr:word);
var I : integer;
begin
   if (VertexNr>0) and (VertexNr<=NoPoints) then
   begin
      for I:=VertexNr to NoPoints-1 do VertexList[i]:=VertexList[I+1];
      PhantomPoints;
      dec(nopoints);  {GDD 9/13/01}
   end;
end;{TBSpline.DeleteVertex}

Function TBSpline.VertexNr(Nr:integer):TVertex;
begin
   Result:=VertexList[Nr];
end;{TBSpline.VertexNr}

function TBSpline.NumberOfVertices:word;
begin
   Result:=NoPoints;
end;{TBSpline.NumberOfVertices}


procedure   TBSpline.SaveToStream(st:TStream);
var
  i:integer;
begin
  with st do
  begin
    writebuffer(FInterpolated,sizeof(FInterpolated));
    writebuffer(nopoints, sizeof(nopoints));
    for i:= 0 to nopoints+1 do writebuffer(Vertexlist[i],sizeof(TVertex));
  end;
end;

procedure   TBSpline.LoadFromStream(st:TStream);
var
  i:integer;
begin
  with st do
  begin
    readbuffer(FInterpolated,sizeof(FInterpolated));
    readbuffer(nopoints, sizeof(nopoints));
    for i:= 0 to nopoints+1 do readbuffer(Vertexlist[i],sizeof(TVertex));
  end;
end;

{------------------------------------------------------------------------------}
{ TSplines.Create                                                              }
{------------------------------------------------------------------------------}
constructor TSplines.Create{(AOwner: TComponent)};
begin
   inherited Create{(AOwner)};
   FSplineRow:=TList.Create;
   FSplineRow.Capacity:=6000;
end;{TSplines.Create}

{------------------------------------------------------------------------------}
{ TSplines.Destroy                                                             }
{------------------------------------------------------------------------------}
destructor TSplines.Destroy;
begin
   FSplineRow.Free;
   inherited Destroy;
end;{TSplines.Destroy}

{------------------------------------------------------------------------------}
{ TSplines.AddSpline                                                           }
{------------------------------------------------------------------------------}
procedure TSplines.AddSpline(BSpline:TBSpline);
begin
   if NumberOfSplines<FSplineRow.Capacity then
   begin
      FSplineRow.Add(BSpline);
   end else MessageDlg('Maximum number of splines reached. ('+IntToStr(FSplineRow.Count)+')',mtError,[mbOk],0);
end;{TSplines.AddSpline}

{------------------------------------------------------------------------------}
{ TSplines.Clear                                                               }
{------------------------------------------------------------------------------}
procedure TSplines.Clear;
begin
   while FSplineRow.Count>0 do FSplineRow.Delete(FSplineRow.Count-1);
   FSplineRow.Pack;
end;{TSplines.Clear}

{------------------------------------------------------------------------------}
{ TSplines.InsertSpline                                                        }
{------------------------------------------------------------------------------}
procedure TSplines.InsertSpline(Pos:Integer;BSpline:TBSpline);
begin
   if NumberOfSplines<FSplineRow.Capacity then
   begin
      FSplineRow.Insert(Pos,BSpline);
   end else MessageDlg('Maximum number of splines reached. ('+IntToStr(FSplineRow.Count)+')',mtError,[mbOk],0);
end;{TSplines.InsertSpline}

{------------------------------------------------------------------------------}
{ TSplines.DeleteSpline                                                        }
{------------------------------------------------------------------------------}
procedure TSplines.DeleteSpline(BSpline:TBSpline);
var I : integer;
begin
   I:=FSplineRow.IndexOf(BSpline);
   if I<>-1 then
   begin
      FSplineRow.Delete(I);
      FSplineRow.Pack;
   end;
end;{TSplines.DeleteSpline}

{------------------------------------------------------------------------------}
{ TSplines.GetSplineNr                                                         }
{------------------------------------------------------------------------------}
function TSplines.GetSplineNr(Nr:Word): TBSpline;
begin
   if (Nr>=1) and (Nr<=FSplineRow.Count) then Result:=FSplineRow.Items[Nr-1]
                                         else Result:=nil;
end;{TSplines.GetSplineNr}

{------------------------------------------------------------------------------}
{ TSplines.GetNumberOfSplines                                                  }
{------------------------------------------------------------------------------}
function TSplines.GetNumberOfSplines: word;
begin
   Result:=FSplineRow.Count;
end;{TSplines.GetNumberOfSplines}

{------------------------------------------------------------------------------}
{ Register                                                                     }
{------------------------------------------------------------------------------}
procedure Register;
begin
  { RegisterComponents('Martijn', [TSplines]);}
end;{Register}

end.
