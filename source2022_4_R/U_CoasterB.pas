{$DEFINE SOUNDS}

unit U_CoasterB;

{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses sysutils, Forms, windows, controls, classes, graphics, extctrls, stdctrls,
     mmsystem,  menus, contnrs, U_splines;

type
  float=single;
  tcoasterRealPoint= record
    x:float;
    y:float;
   end;

  TTrackPoint=record  {record used in Rpoints array to describe track}
    x: float;
    y: float;
    angleright: float;
    sinangleright: float;
    cosangleright:float;
    quadrantright:integer;
    lengthright:float;
    radiusright:float;
  end;

  TTrackRec=record {describes current cart location}
     x:float;
     y:float;
     index:integer; {index of current rec in Rpoints track array}
     distToend:float;
     quadrant:integer;
     radius:float;
     angle: float;
     sinangle: float;
     cosangle:float;
   end;

  TCartLocRec=record {Contains current corner coordinates for a cart}
    {Carts array contains and array of these records describing the entire cart train}
    p1:tpoint;
    p2:tpoint;
    p3:tpoint;
    p4:tpoint;
    wr:integer;
  end;

  TLoopType=(Insideloop, Outsideloop, none);


  TTemplateMode=(normal, makeline1, makeline2,
                makecircle1, makecircle2,
                movecircle);


  TcoasterLine=class(TObject)
    L1,L2:TPoint;
    NewL2:TPoint;
    pbox:TPaintBox;
    constructor create(newPBox:TPaintBox);
    procedure draw;
    procedure savetostream(st:Tstream);
    procedure loadfromstream(st:Tstream);
  end;

  TcoasterCircle=class(TObject)   {circle template class}
    Center:TPoint;
    Radius:integer;
    NewRadius:integer;
    Newcenter:TPoint;
    pbox:TPaintBox;
    constructor create(newPBox:TPaintBox);
    procedure draw;
    procedure savetostream(st:Tstream);
    procedure loadfromstream(st:Tstream);
  end;

  type ARRsoundstr = array [0..5] of string;

  TCoaster=class(TPaintbox)
    private
     FXval:float;
     FYVal:float;
     Fcartx:integer;
     Fcarty:integer;
     FNbrCarts:integer;
     FVZero: float;
     FGravity:float;
     Fv:float;
     FDistance:float;
     Fa:float;    {acceleration tangential to track}
     FSkyline:integer;
     FXmin,FXMax,FYMin,FYMax:float;{largest & smallest x, y pixel track values}

     dragpt:integer;
     dragoffset:TPoint;
     Popup1:TPopUpMenu;
     DeleteControlPoint:TMenuItem;
     AddControlPoint:TMenuItem;
     AddCircleTemplate:TMenuItem;
     AddLineTemplate:TMenuItem;

     DeleteTemplate:TMenuItem ;
     LockTemplates:TMenuItem;
     PopupDeletePoint:integer;
     Version:string;
     Looptype:TLoopType;

     TemplateList:TObjectList;
     curobj:TObject;
     templatemode:TTemplatemode;

     procedure MouseDown1(Sender: TObject; Button: TMouseButton;
                               Shift: TShiftState; X, Y: Integer);
     procedure MouseMove1(Sender: TObject; Shift: TShiftState; X,
                              Y: Integer);
     procedure MouseUp1(Sender: TObject; Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer);
     procedure PopupMenuPopup(Sender: TObject);
     procedure AddcontrolpointClick(Sender: TObject);
     procedure DeletecontrolpointClick(Sender: TObject);
     procedure makeCircle(sender:TObject); {template}
     procedure makeLine(sender:TObject); {template}
     procedure deleteTemplateClick(sender:Tobject);
     procedure LocktemplatesClick(sender:TObject);
     procedure SetSigDiffFloat(var prop:float; newval:float);
     procedure SetSigDiffInt(var prop:integer; newval:integer);
     procedure makelbl(x,y:integer); overload; {label when moving around screen on design mode}
     procedure makelbl(c:TObject); overload; {label when a template object is selected}
    public
      bspline:TBSpline;
      cxmin,cxmax,cymin,cymax:float; {largest & smallest x,y virtual unit values}
      rpoints:array of TTrackPoint;
      nbrpoints:integer; {nbr of points in Rpoints track array}
      chainto:float;  {chain drive to this x value}
      brakefrom:float; {apply brakes from this x value top end}
      chainpoint:integer;  {last segment number on chain}
      scale:float; {pixels per foot/ meter, etc}
      time:float;
      designmode:boolean;

      modified:boolean; {coaster has been modified and needs saving}
      cartready:boolean;
      mass:float;
      friction:float;
      theta :float;
      vx, vy:float; {unscaled vx and vy}
      an:float; {unscaled acceleration normal to track}
      timescale:float;
      timestep:float;
      Savebg,imagecopy:TBitmap;
      saverect,moverect:TRect;
      rec:TTrackrec;
      msdelay:integer;
      offtrack:boolean; {cart has fallen off the track}
      constrained:boolean; {cart tied to track}
      flyheight:float;  {fly height car off of track}
      onchain:boolean;  {cart is on the inital chain drive}
      brakepoint:float; {control point number to start braking}
      maxfly:integer; {max fly height before offtrack}
      g:float; {G force}
      fward:boolean;
      ouchresources: ARRsoundstr; //array [0..5] of string; {crash sounds}
      nbrOuchfiles:integer;
      playRunsounds, PlayFallSounds:boolean; {sound control switches}
      carts:array of TCartLocRec; {info to redraw carts}
      Poslbl:TLabel;   {position  label}

      function GetXVal:float;
      procedure SetXVal(Value:float);
      function GetYVal:float;
      procedure SetYVal(Value:float);
      function GetV:float;
      procedure SetV(Value:float);
      function GetDistance:float;
      procedure SetDistance(Value:float);
      function GetA:float;
      procedure SetA(Value:float);
      function GetCartx:float;
      procedure SetCartX(value:float);
      function GetCarty:float;
      procedure SetCarty(value:float);
      procedure SetNbrCarts(value:integer);
      function GetVZero:float;
      procedure SetVZero(value:float);
      function GetGravity:float;
      procedure SetGravity(value:float);
      procedure SetSkyline(value:integer);

      procedure settimestep(timeinc:float);
      procedure setTimeScale(newtimescale:float);
      procedure setfriction(newfriction:float);
      procedure setMass(newMass:float);
      procedure setConstrained(newConstrained:boolean);
      procedure SetXMax(value:float);
      procedure SetXMin(value:float);
      procedure SetYMax(value:float);
      procedure SetYMin(value:float);

      property xval:float    read GetXVal    write SetXVal;
      property yval:float    read GetYVal    write SetYVal;
      property Cartx:float   read GetCartx   write SetCartx;
      property Carty:float   read GetCarty   write SetCarty;
      property NbrCarts:integer read FNbrCarts  write SetNbrCarts;
      property VZero:float   read GetVZero   write SetVZero;
      property Gravity:float read GetGravity write SetGravity;
      property V:float read GetV write SetV;
      property Distance:float read GetDistance write SetDistance;
      property A:float reaD GetA write SetA;
      property Yskyline:integer read FSkyline  write SetSkyline;
      {largest & smallest x, y track pixel values}
      property xmin:float read FXmin write SetXMin;
      property ymin:float read FYMin write SetYMin;
      property xmax:float read FXmax write SetXmax;
      property ymax:float read FYMax write SetYMax;

      constructor create(newImage:TPaintbox); reintroduce;
      destructor destroy;    override;
      procedure paintAll(sender:TObject);
      procedure Addpoint(newx,newy:integer);
      procedure finalize;
      function getNextPosition(var rec:TTrackRec; dist:float):boolean;
      {function getPrevPosition(var rec:TTrackRec; distance:float):boolean;}

      {procedure clear;}
      procedure SaveToStream(st:TStream);
      procedure LoadFromStream(st:TStream);

      procedure init(newmaxfly:integer);
      function  steptime:boolean;

      function PixelToVirtual(x,y:float):TcoasterRealpoint;
      function VirtualToPixel(x,y:float):TcoasterRealpoint;
      procedure Drawpoints(nbrsegs:integer);
      procedure drawfield;
      procedure drawcart;
      Procedure rescale(newcxmin, newcxmax, newcymin, newcymax,
                       newxmin, newxmax, newymin, newymax :float);
   end;

implementation

{$IFDEF SOUNDS}
    {$R coastersounds.res}
{$ENDIF}

uses math;

const
  NewVersion:string[4]='V6.0';
  screamangle:float=40*pi/180; {play scream sounds when cart angle exceeds this value}
  segs:integer=100;  {numberof line segments in normal track}

{************** GetRadius (Local procedure) *********************}
function getradius(p1,p2,p3:TTrackPoint):float;
{Return the radius of the circle defined by 3 points on it's circumference}
var
  s,d:float;
  a,b,c:float;
begin
  a:=sqrt(sqr(p1.x-p2.x)+sqr(p1.y-p2.y));
  b:=sqrt(sqr(p2.x-p3.x)+sqr(p2.y-p3.y));
  c:=sqrt(sqr(p3.x-p1.x)+sqr(p3.y-p1.y));
  s:=(a+b+c)/2;
  d:=(4*sqrt(s*(s-a)*(s-b)*(s-c)));
  if d<>0 then result:=(a*b*c)/d
  else result:=1e6;
end;

 function dist(p1,p2:TPoint):integer;
begin
  result:=round(Sqrt((P1.X-P2.X)*(P1.X-P2.X)+(P1.Y-P2.Y)*(P1.Y-P2.Y)));
end;

{TLine template methods}
constructor TcoasterLine.create(newPBox:TPaintBox);
begin
  inherited create;
  PBox:=newPBox;
  l1:=point(0,0);
  l2:=point(50,50); newl2:=l2;
end;

procedure TcoasterLine.draw;
var savecolor:Tcolor;
    savewidth:integer;
begin
  with pbox,canvas do
  begin
    savecolor:=pen.color;
    savewidth:=pen.width;
    pen.color:=clred;
    pen.width:=1;
    l2:=newl2;
    moveto(l1.X,l1.Y);
    lineto(l2.x,l2.y);
    pen.color:=savecolor;
    pen.width:=savewidth;
  end;
end;

procedure TcoasterLine.savetostream(st:Tstream);
begin
  with st do
  begin
    writebuffer(L1.x,sizeof(l1.x));
    writebuffer(L1.y,sizeof(l1.y));
    writebuffer(L2.x,sizeof(l2.x));
    writebuffer(L2.y,sizeof(l2.y));
    writebuffer(NewL2.x,sizeof(Newl2.x));
    writebuffer(NewL2.y,sizeof(Newl2.y));
  end;
end;

procedure TcoasterLine.loadfromstream(st:Tstream);
begin
  with st do
  begin
    readbuffer(l1.x,sizeof(l1.x));
    readbuffer(l1.y,sizeof(l1.y));
    readbuffer(l2.x,sizeof(l2.x));
    readbuffer(l2.y,sizeof(l2.y));
    readbuffer( Newl2.x,sizeof(newl2.x));
    readbuffer(Newl2.y,sizeof(newl2.y));
  end;
end;


{TCircle template methods}
constructor TcoasterCircle.create(newPBox:TPaintBox);
begin
  inherited create;
  PBox:=newPBox;
  center:=mouse.cursorpos {point(0,0)};
  radius:=50;
  newradius:=radius;
  newcenter:=center;
end;

procedure TcoasterCircle.draw;
var savecolor, savecolorb:Tcolor;
    savestyle:TBrushstyle;
begin

  with pbox,canvas do
  begin
    savecolor:=pen.color;
    savecolorb:=brush.color;
    savestyle:=brush.style;
    pen.color:=clred {clblack};
    brush.style:=bsClear;
    radius:=newradius;
    center:=newcenter;
    ellipse(center.x-2, center.Y-2,center.x+2,center.y+2);
    ellipse(center.x-radius, center.Y-radius,center.x+radius,center.y+radius);
    pen.color:=savecolor;
    brush.style:=savestyle;
    brush.color:=savecolorb;
  end;
end;

procedure TcoasterCircle.savetostream(st:Tstream);
begin
  with st do
  begin
    writebuffer(center.x,sizeof(center.x));
    writebuffer(center.y,sizeof(center.y));
    writebuffer(radius,sizeof(radius));
    writebuffer(newcenter.x,sizeof(newcenter.x));
    writebuffer(newcenter.y,sizeof(newcenter.y));
    writebuffer(newradius,sizeof(newradius));
  end;
end;
procedure TcoasterCircle.loadfromstream(st:Tstream);
begin
  with st do
  begin
    readbuffer( center.x,sizeof(center.x));
    readbuffer(center.y,sizeof(center.y));
    readbuffer(radius,sizeof(radius));
    readbuffer(Newcenter.x,sizeof(newcenter.x));
    readbuffer(Newcenter.y,sizeof(newcenter.y));
    readbuffer( newradius,sizeof(newradius));
  end;
end;

{TCoaster methods}

{***************** Create ********************}
constructor TCoaster.create(newImage:Tpaintbox);
{Create a new coaster object}
var
  path:string;
  i:integer;
  vertex:TVertex;
  xscale,yscale:float;
  p:TcoasterRealPoint;
begin
  inherited create(newimage.owner);
  controlstyle:=controlstyle+[csopaque];
  OnPaint:=PaintAll;

  OnMouseDown:=MouseDown1;
  OnMouseMove:=MouseMove1;
  OnMouseUp:=MouseUp1;
  bspline:=TBSpline.create;
  setlength(rpoints,segs);
  left:=newimage.left;
  top:=newimage.top;
  width:=newImage.width;
  height:=newImage.height;
  parent:=newimage.parent;
  Popup1:=TPopupMenu.create(self);
  Popupmenu:=Popup1;
  with popup1 do
  begin
   items.clear;
   onPopup:=PopupMenuPopUp;
   AddControlPoint:=TMenuItem.create(self);
   with addControlPoint do
   begin
     caption:='Add Control Point';
     OnClick:=AddControlPointClick;
   end;
   items.add(AddControlPoint);
   DeleteControlPoint:=TMenuItem.create(self);
   with deletecontrolpoint do
   begin
     caption:='Delete Control Point';
     OnClick:=DeleteControlPointClick;
   end;
   items.add(DeleteControlPoint);

   AddCircleTemplate:=TMenuItem.create(self);
   with AddCircleTemplate do
   begin
     caption:='Add Circle template';
     OnClick:=Makecircle;
   end;
   items.add(AddCircleTemplate);

   AddLineTemplate:=TMenuItem.create(self);
   with AddLineTemplate do
   begin
     caption:='Add Line template';
     OnClick:=MakeLine;
   end;
   items.add(AddLineTemplate);

   DeleteTemplate:=TMenuItem.create(self);
   with DeleteTemplate do
   begin
     caption:='Delete this template';
     OnClick:=DeleteTemplateClick;
     enabled:=false;
   end;
   items.add(DeleteTemplate);

   LockTemplates:=TMenuItem.create(self);
   with LockTemplates do
   begin
     caption:='Lock templates';
     OnClick:=LocktemplatesClick;
     enabled:=true;
   end;
   items.add(LockTemplates);

  end;

  PosLbl:=TLabel.create(self);
  with Poslbl do
  begin
    autosize:=false;
    wordwrap:=true;
    parent:=self.parent;
    width:=100;
    height:=41;
    top:=self.top+self.height+50;
    left:=self.left+self.width-100;
    visible:=false;
  end;

  nbrpoints:=0;
  chainpoint:=-1;
  {set default "coaster box' pixel range to use for track displays}
  fxmin:=5 * width div 100;
  fxmax:=95* width div 100;
  fymin:=20 * height div 100;
  fymax:=80 * height div 100;
  fSkyline:=33*height div 100;
  fnbrcarts:=2;
  cxmin:=0;
  cxmax:=1000;
  cymin:=0;
  cymax:=200;
  vertex.y:=0;
  for i:=0 to 15 do
  begin
    vertex.x:=i/16*(cxmax-cxmin);
    if i mod 2 = 1 then vertex.y:=(16-i)*10
    else vertex.y:=0;
    bspline.AddVertex(vertex);
  end;
  if (cxmax<>cxmin)and(cymax<>cymin) then
  begin
    xscale:=(fxmax-fxmin)/(cxmax-cxmin);
    yscale:=(fymax-fymin)/(cymax-cymin);
    scale:=min(xscale,yscale); {pixels per unit scaling factor}
  end
  else
  begin
    scale:=1.0;
  end;
  {Scale vertex data from units to pixels}
  for i:=1 to bspline.numberofvertices do
  begin
    vertex:=bspline.vertexnr(i);
    p:=virtualtoPixel(vertex.x,vertex.y);
    bspline.changevertex(i,p.x,p.y);
  end;
  timestep:=0.07;
  timescale:=3.0;
  Cartx:=10;
  carty:=4;
  nbrcarts:=3;
  VZero:=10;
  gravity:=32.0;
  mass:=1000;
  friction:=0.05;
  savebg:=TBitmap.create;
  imagecopy:=TBitmap.create;
  path:=extractfilepath(application.exename);
  for i:=0 to 5 do ouchresources[i]:='OUCH'+inttostr(i);;
  nbrouchfiles:=6;
  modified:=false;
  dragpt:=-1;
  Version:=newversion;
  Looptype:=none;
  playrunsounds:=false;
  playfallsounds:=true;
  {$IFNDEF SOUNDS}
    playfallsounds:=false;
  {$ENDIF}

end;

{**************** Destroy ***********}
destructor TCoaster.destroy;
{Called to free this  Coaster object}
begin
  savebg.free;
  imagecopy.free;
  popup1.free;
  bspline.free;
  inherited;
end;

{**************** PopupMenuPopUp *******************}
procedure TCoaster.PopupMenuPopup(Sender: TObject);
{Popup during design mode to add/delete control point}
var
  p:tpoint;
  v:TVertex;
  pt,i:integer;

begin
  pt:=-1;
  p:=screentoclient(mouse.cursorpos);
  for i:= 1 to Bspline.numberofvertices do
  with bSpline do
  begin
    v:=Bspline.value((i-1)/(Bspline.numberofvertices-1));
    if (abs(v.x-p.x)<5) and (abs(v.y-p.y)<5) then
    begin
      pt:=i;
      break
    end;
  end;
  if pt>0 then
  begin
    deletecontrolpoint.enabled:=true;
    PopupDeletePoint:=pt;
  end
  else deletecontrolpoint.enabled:=false;

end;

procedure TCoaster.Makelbl(x,y:integer);
var p:TcoasterRealPoint;
begin
  if poslbl.visible then
  begin
    p:=pixeltovirtual(x,y);
    poslbl.caption:=(format('X:%6.1f'+#13+'Y:%6.1f',
                             [p.x,p.y]));
  end;
end;

procedure TCoaster.Makelbl(c:Tobject);
var
  p1,p2:TcoasterRealPoint;
begin
  if poslbl.visible then
  begin

    if c is Tcoasterline then
    with c as TcoasterLine do
    begin
      p1:=pixeltovirtual(l1.x,l1.y);
      p2:=pixeltovirtual(l2.x,l2.y);
      poslbl.caption:=format('P1:(%6.1f,%6.1f)'+#13+
                             'P2:(%6.1f,%6.1f)'+#13+
                             'Len: %6.1f',[p1.x,p1.y,p2.x,p2.y,
                         Sqrt((P1.X-P2.X)*(P1.X-P2.X)+(P1.Y-P2.Y)*(P1.Y-P2.Y))]);

    end
    else if c is TcoasterCircle then
    with c as TcoasterCircle do
    begin
      p1:=pixeltovirtual(center.x, center.y);
      p2:=pixeltovirtual(center.x+radius, center.y);
      poslbl.caption:=format('Center:(%6.1f,%6.1f)'+#13+
                           'Radius: %6.1f',[p1.x,p1.y,p2.x-p1.x]);
    end;
  end;
end;

{********************* AddControlPoint *******************}
procedure TCoaster.AddcontrolpointClick(Sender: TObject);
var
  i:integer;
  pt:integer;
  p:tpoint;
  v:TVertex;
  distsqr,mindist:float;
  mini:integer;
begin
  p:=screentoclient(mouse.cursorpos);
  (*
  {Old way - insert before 1st vertex with x>clicked point x}
  for i:= 1 to Bspline.numberofvertices do
  with bSpline do
  begin
    v:=Bspline.value((i-1)/(Bspline.numberofvertices-1));
    if (v.x>p.x) then
    begin
      pt:=i;
      break
    end;
  end;
  *)
  {Revised method - select closest interpolated point}
  mindist:=1e6;
  mini:=0;
  for i:= 1 to 1000 do
  with bSpline do
  begin
    v:=Bspline.value((i/1000));
    distsqr:=(v.x-p.x)*(v.x-p.x)+ (v.y-p.y)*(v.y-p.y);
    if distsqr<mindist then
    begin
      mindist:=distsqr;
      mini:=i;
    end;
  end;
  pt:=round(mini*bspline.numberofvertices/1000)+1;
  If pt>=0 then
  begin
    v.x:=p.x;
    v.y:=p.y;
    bspline.insertvertex(pt,v);
    drawpoints(segs); {redraw from control points}
    modified:=true;
  end;
end;

{******************** DeleteControlPoint **************}
procedure TCoaster.DeletecontrolpointClick(Sender: TObject);
begin
  if PopUpDeletePoint>0 then
  begin
    bspline.DeleteVertex(PopupDeletePoint);
    paintall(sender);
    modified:=true;
  end;
end;

procedure TCoaster.MakeCircle(sender:TObject);
begin
  templatelist.add(Tcoastercircle.create(self));
  curobj:=templatelist.items[templatelist.count-1];
  templatemode:=makecircle1;
  cursor:=crCross;
end;

procedure TCoaster.MakeLine(sender:TObject);
begin
  templatelist.add(TcoasterLine.create(self));
  curobj:=templatelist.items[templatelist.count-1];
  templatemode:=makeline1;
  cursor:=crCross;
end;

procedure TCoaster.DeleteTemplateClick(sender:TObject);
begin
  if curobj<>nil then
  begin
     (*
    {final draw without erase should erase the image}
    if curobj is tline then tline(curobj).draw(false)
    else if curobj is tcircle then tcircle(curobj).draw(false);
    *)
    TemplateList.Remove(curobj);
    templatemode:=normal;
    cursor:=crdefault;
    curobj:=nil;
    deletetemplate.enabled:=false;
    invalidate;
  end;
end;


procedure TCoaster.LocktemplatesClick(sender:TObject);
begin
  with locktemplates do
  begin
    checked:=not checked;
    if checked then caption:='Templates locked, click to unlock'
    else caption:='Lock templates';
  end;
end;

{**************** AddPoint *****************}
procedure TCoaster.Addpoint(newx,newy:integer);
begin
  if nbrpoints>=high(rpoints) then setlength(rpoints,length(rpoints)+50);
  if newx>width then newx:=width-10;
  if newy>height then newy:=height-10;
  with rpoints[nbrpoints] do
  begin
    x:=newx;
    y:=newy;
  end;
  if nbrpoints>0
  then
  with  rpoints[nbrpoints-1] do
  begin
    angleright:=arctan2(rpoints[nbrpoints].y-y, (rpoints[nbrpoints].x-x));
    sinangleright:=sin(angleright);
    cosangleright:=cos(angleright);
    if angleright<-pi/2 then quadrantright:=4
    else if angleright<0 then quadrantright:=1
    else if angleright<pi/2 then quadrantright:=2
    else quadrantright:=3;
    lengthRight:=sqrt(sqr(rpoints[nbrpoints].x-x)+sqr(rpoints[nbrpoints].y-y));
  end;
  inc(nbrpoints);
end;

{******************* Finalize *****************}
procedure TCoaster.finalize;
{Finalize coaster after changes}
var
  i:integer;
begin
  chainpoint:=-1;
  for i:=0 to nbrpoints do
  with rpoints[i] do
  begin
    if (angleright>0.2) and (chainpoint<0)
    then chainpoint:=i+1{-1};
    If (i>=2) and (i<=nbrpoints-2) then
    begin
      radiusright:=getradius(rpoints[i-2],rpoints[i],rpoints[i+2]);
      {assign hill tops a negative radius}
      if rpoints[i+2].angleright>rpoints[i-2].angleright then radiusright:=-radiusright;
    end
    else radiusright:=0;
  end;
  (*
  {recalculate pixel range of coaster}
  vertex:=bspline.vertexnr(1);
  newxmin:=vertex.x; newxmax:=vertex.x;
  newymin:=vertex.y; newymax:=vertex.y;

  for i:=2 to bspline.numberofvertices{-1} do
  begin
    vertex:=bspline.vertexnr(i);
    if vertex.x<newxmin then newxmin:=vertex.x;
    if vertex.x>newxmax then newxmax:=vertex.x;
    if vertex.y<newymin then newymin:=vertex.y;
    if vertex.y>newymax then newymax:=vertex.y;
  end;
  If fxmax<>newxmax then fxmax:=newxmax;
  If fxmin<>newxmin then fxmin:=newxmin;
  If fymax<>newymax then fymax:=newymax;
  If fymin<>newymin then fymin:=newymin;
  *)
end;

{******************* TRamp.GetNextPosition ****************}
function TCoaster.getNextPosition(var rec:TTrackRec; dist:float):boolean;
var
  prevrec:TTrackrec;
  startindex:integer;
  d,dd:float;
begin
  result:=false;
  move(rec,prevrec,sizeof(prevrec));
  startindex:=prevrec.index;
  d:=prevrec.disttoend; {distance from current point to end of current segment}
  if dist>0 then
  begin
    if dist>=d then  {distance to move > distance left in this segment}
    while (startindex<nbrpoints) and (dist>d) do
    begin
      dist:=dist-d; {subtract rest of this segment}
      inc(startindex);  {get next segment}
      d:=rpoints[startindex].lengthright;  {set distance to end of next segment}
    end;
    if startindex<=nbrpoints then
    with rec do
    begin
      index:=startindex;
      disttoend:=d-dist;
      dd:=rpoints[index].lengthright-disttoend;
      with rpoints[index] do
      begin
        rec.x:=x+dd*cosangleright;
        rec.y:=y+dd*sinangleright;
        quadrant:=quadrantright;
        angle:=angleright;
        sinangle:=sinangleright;
        cosangle:=cosangleright;
        radius:=radiusright;
      end;
      result:=true;
    end;
  end
  else
  if dist<0 then
  begin
    dist:=-dist;
    d:=rpoints[startindex].lengthright-d; {make it distance to left end}
    if dist>=(d) then  {distance to move > distance left in this segment}
    while (startindex>0) and (dist>d) do
    begin
      dist:=dist-d; {subtract rest of this segment}
      dec(startindex);  {get next segment}
      d:=rpoints[startindex].lengthright;  {set distance to end of next segment}
    end;
    if startindex>=0 then
    with rec do
    begin
      index:=startindex;
      disttoend:=rpoints[index].lengthright-(d-dist);
      dd:=d-dist;
      with rpoints[index] do
      begin
        rec.x:=x+dd*cosangleright;
        rec.y:=y+dd*sinangleright;
        quadrant:=quadrantright;
        angle:=angleright;
        sinangle:=sinangleright;
        cosangle:=cosangleright;
        radius:=radiusright;
      end;
      result:=true;
    end;
  end
  else
  with rec do
  begin
    index:=0;
    with rpoints[index] do
    begin
      rec.x:=x;
      rec.y:=y;
      quadrant:=quadrantright;
      angle:=angleright;
      sinangle:=sinangleright;
      cosangle:=cosangleright;
      radius:=radiusright;
    end;
    result:=true;
  end;
end;


{**************** DrawField ****************}
procedure tCoaster.drawfield;
var i:integer;

{draw the background}
   begin
     with canvas do
     if cliprect.right>0 then
     begin
       brush.color:=clgreen;
       fillrect(rect(0,height-YSkyline,width,height));
       brush.color:=$FF8060; {light blue (value = bbggrr)}
       fillrect(rect(0,0,width,height - yskyline));
       brush.color:=clred;
       {now draw the ramp}
       pen.width:=3;
       pen.color:=clblack;
       with rpoints[0] do moveto(trunc(x),trunc(y));
       for i:=1 to nbrpoints-1 do
       with rpoints[i] do lineto(trunc(x),trunc(y));
       pen.width:=1;
     end;
   end;

{******************* Drawpoints ***************}
procedure TCoaster.Drawpoints(nbrsegs:integer);
{Redraw the track}
var J       : Integer;
    V       : TVertex;
begin
  with  canvas do
  begin
    drawfield; {redraw the field}
    if cliprect.right>cliprect.left then 
    begin
      if BSpline<>nil then
      begin
        For J:=0 to nbrsegs do     {Draw the spline in nbrsteps steps}
        begin
           V:=BSpline.Value(J/nbrsegs);
           if J=0 then
           begin
              Pen.Color:=clblack;
              MoveTo(Round(V.X),Round(V.Y));
           end else LineTo(Round(V.X),Round(V.Y));
        end;

        if designmode then
        begin
          if assigned(templatelist) then
          with templatelist do {redraw any templates}
          for j:=0 to count-1 do
          begin
            if tobject(list[j]) is tcoasterline then TcoasterLine(list[j]).draw
            else if tobject(list[j]) is tcoastercircle then TcoasterCircle(list[j]).draw;
          end;
          For J:=1 to BSpline.NumberOfVertices do     {Draw the vertices}
          begin
            v:=Bspline.value((J-1)/(Bspline.numberofvertices-1));
            Pen.Color:=clRed;
            Ellipse(Round(V.X)-3,Round(V.Y)-3,Round(V.X)+3,Round(V.Y)+3);
          end;
        end;
      end;
    end;
  end;
end;


{***************** TCart.drawcart ***************}
procedure TCoaster.drawcart;

     procedure rotate(var p:Tpoint; a:real);
     {rotate point "p" by "a" radians about the origin (0,0)}
     var
       t:TPoint;
     Begin
       t:=P;
       p.x:=trunc(t.x*cos(a)-t.y*sin(a));
       p.y:=trunc(t.x*sin(a)+t.y*cos(a));
     end;

     procedure translate(var p:TPoint; toX,ToY:integer);
     {move point "p" by x & y amounts specified in "t"}
     Begin
       p.x:=p.x+Tox {trunc(Fxval)};
       p.y:=p.y+ToY {trunc(Fyval)};
     end;

var
  w,w2:integer;
  prevrect:Trect;
  temprec:TTrackrec;
  x,y,i:integer;
  minx,miny,maxx,maxy:integer;
  oldcart1:TCartLocRec;

  function mymin(n:array of integer):integer;
  {get min of an array of integers}
  var  i:integer;
  begin
    result:=n[low(n)];
    for i:= low(n)+1 to high(n) do
    if n[i]<result then result:=n[i];
  end;

  function mymax(n:array of integer):integer;
  {get max of an array of integers}
  var i:integer;
  begin
    result:=n[low(n)];
    for i:= low(n)+1 to high(n) do
    if n[i]>result then result:=n[i];
  end;

  procedure setrange(i:integer);
  begin
    with carts[i] do
    begin
      if i=1 then
      begin
        minx:=p1.x-wr;
        maxx:=p1.x+wr;
        miny:=p1.y-wr;
        maxy:=p1.y+wr;
      end;
      minx:=mymin([minx,p1.x-wr,p2.x-wr,p3.x,p4.x]);
      maxx:=mymax([maxx,p1.x+w2,p2.x+wr,p3.x,p4.x]);
      miny:=mymin([miny,p1.y-wr,p2.y-wr,p3.y,p4.y]);
      maxy:=mymax([maxy,p1.y+wr,p2.y+wr,p3.y,p4.y]);
    end;
  end;

begin
  setlength(carts,nbrcarts+1);
  w2:=trunc(Fcartx);
  w:=w2 div 2 ; {center cart at FCartx, Fcarty}
  {get the corners of the car @ 0 deg angle}
  {then rotate it and translate it to the real origin}
  x:=trunc(fxval);
  y:=trunc(Fyval);
  oldcart1:=carts[1]; {if offtrack, use this to help relocate 2nd, 3rd, 4th carts}
  with carts[1] do
  begin
    wr:=trunc(Fcarty/2) ;  {radius of wheels}
    p1:=point(-w,-wr);   rotate(p1,theta);   translate(p1,x,y);
    p2:=point(+w,-wr);   rotate(p2,theta);   translate(p2,x,y);
    p3:=point(+w,-trunc(Fcarty)-wr);   rotate(p3,theta);   translate(p3,x,y);
    p4:=point(-w,-trunc(Fcarty)-wr);   rotate(p4,theta);   translate(p4,x,y);
  end;
  setrange(1);
  temprec:=rec;
  for i:=2 to nbrcarts do
  begin
    if offtrack then
    with carts[i] do
    begin
      p1.x:=p1.x+carts[1].p1.x-oldcart1.p1.x;
      p1.y:=p1.y+carts[1].p1.y-oldcart1.p1.y;
      p2.x:=p2.x+carts[1].p2.x-oldcart1.p2.x;
      p2.y:=p2.y+carts[1].p2.y-oldcart1.p2.y;
      p3.x:=p3.x+carts[1].p3.x-oldcart1.p3.x;
      p3.y:=p3.y+carts[1].p3.y-oldcart1.p3.y;
      p4.x:=p4.x+carts[1].p4.x-oldcart1.p4.x;
      p4.y:=p4.y+carts[1].p4.y-oldcart1.p4.y;
      setrange(i);
    end
    else
    begin {ontrack}
     {back up a cart length + wheel space for next cart,
      we need this because angle is probably different  }
      getnextposition(temprec,-fcartx-w);
      x:=trunc(temprec.x);
      y:=trunc(temprec.y);
      with carts[i] do
      begin
        wr:=trunc(Fcarty/2) ;  {radius of wheels}
        p1:=point(-w,-wr);   rotate(p1,temprec.angle);   translate(p1,x,y);
        p2:=point(+w,-wr);   rotate(p2,temprec.angle);   translate(p2,x,y);
        p3:=point(+w,-trunc(Fcarty)-wr);   rotate(p3,temprec.angle);   translate(p3,x,y);
        p4:=point(-w,-trunc(Fcarty)-wr);   rotate(p4,temprec.angle);   translate(p4,x,y);
        setrange(i);
      end;
    end;
  end;

  prevrect:=saverect; {prevrect=previous cart image rectangle}
  with saverect do
  begin
    {saverect = rectangle large enough to hold new cart images}
    topleft:=point(minx-4,miny-4);
    bottomright:=point(maxx+4,maxy+4);
    if prevrect.left<0 then prevrect:=saverect;
    {make movrect big enough to include prevrect and saverect}
    moverect.left:=min(prevrect.left,left);
    moverect.top:=min(prevrect.top,top);
    moverect.right:=max(prevrect.right,right);
    moverect.bottom:=max(prevrect.Bottom,bottom);
  end;

  with imagecopy.canvas do
  begin
    {draw the new cart onto the imagecopy image}
    copyrect(prevrect,savebg.canvas,prevrect);
    {draw the new cart onto the imagecopy image}
    for i:= 1 to nbrcarts do
    with carts[i] do
    begin
      brush.color:=clred;
      polygon([p1,p2,p3,p4]);
      brush.color:=clblack;
      ellipse(p1.x-wr,p1.y-wr,p1.x+wr,p1.y+wr);
      ellipse(p2.x-wr,p2.y-wr,p2.x+wr,p2.y+wr);
    end;
    {and copy the whole thing (cart & background) to the visible screen}
     self.canvas.copyrect(moverect,imagecopy.canvas,moverect);
  end;
  cartready:=true;
end;


procedure TCoaster.PaintAll(Sender: TObject);
begin
  if designmode then drawpoints(segs)
  else
  begin
    drawfield;
    drawcart;
  end;
end;


procedure TCoaster.MouseDown1(Sender: TObject; Button: TMouseButton;
                             Shift: TShiftState; X, Y: Integer);
var
  i:integer;
  v,vv:TVertex;
begin
  if not designmode then
  begin
    tag:=1;
    cartready:=false;
    designmode:=true;
    poslbl.visible:=true;
    templatemode:=normal;
    invalidate;
    {modified:=true; }{commented - wait until second click}
    exit;
  end;
  modified:=true;
  case templatemode of
  normal: {pick up a control point to drag if cursor is near one}
    begin
      makelbl(x,y);
      dragpt:=-1;
      for i:= 1 to Bspline.numberofvertices do
      with bSpline do
      begin
        v:=Bspline.value((i-1)/(Bspline.numberofvertices-1));
        if (abs(v.x-x)<5) and (abs(v.y-y)<5) then
        begin
          dragpt:=i;
          vv:=Vertexnr(dragpt);
          dragoffset:=point(round(vv.x-v.x),round(vv.y-v.y));
          break
        end;
      end;
    end;
  end; {case}
end;

{********************* MouseMove1 ******************}
procedure TCoaster.MouseMove1(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var  newx,newy:integer;
begin
  if not designmode then exit;
  case templatemode of
  normal:
    begin
      makelbl(x,y);
      if dragpt>=0 then
      with bspline do
      begin
        newx:=x+dragoffset.x;
        newy:=y+dragoffset.y;
        changevertex(dragpt,newx,newy);
        if newx<fxmin then fxmin:=newx
        else if newx>fxmax then fxmax:=newx;
        if newy<fymin then fymin:=newy
        else if newy>fymax then fymax:=newy;
        drawpoints(50);
      end;
    end;
  makeline1:
    begin
      with TcoasterLine(curobj) do
      {if (l1.x>0) or (l1.y>0) then}
      begin
        newl2.x:=l2.x + x - l1.x;
        newl2.y:=l2.y + y - l1.y;
        l1.x:=x;  l1.y:=y;
        invalidate;
        makelbl(curobj);
      end;
     end;
  makeline2:
    begin
      with TcoasterLine(curobj) do
      if (l1.x>0) or (l1.y>0) then
      begin
        newl2.x:=x;
        newl2.y:=y;
        invalidate;
        makelbl(curobj);
      end;
    end;

  makecircle2:
    begin
      with TcoasterCircle(curobj) do
      if (center.x>0) or (center.y>0) then
      begin
        newradius:=dist(center, point(x,y));
        invalidate;
        makelbl(curobj);
      end;
    end;
    makecircle1:
      with TcoasterCircle(curobj) do
      begin
        newcenter:=point(x,y);
        invalidate;
        makelbl(curobj);
      end;
    end; {case}

end;


{******************** MouseUp1 *******************}
procedure TCoaster.MouseUp1(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p,temp:TPoint;
  i,d1,d2:integer;
begin
  dragpt:=-1;
  if (not designmode) or (button=mbright) then exit;
   case templatemode of
   normal:
     begin
       finalize;
       If not locktemplates.checked then {template selection allowed}
       begin
         {in case the user clicked on a template item to move or resize
          it}
         p:=point(x,y);
         for i:=0 to templatelist.count-1 do
         begin
           if Tobject(templatelist[i]) is tcoasterline then
           with TcoasterLine(templatelist[i]) do
           begin
             d1:=dist(l1,p);
             d2:=dist(l2,p);
             if (d1<d2) and (d1<6) then
             {clicked on 1st point, exchange points so we always move the 2nd point}
             begin
               temp:=l1;
               l1:=l2;
               l2:=temp;
               newL2:=l2;
               templatemode:=makeline2;
             end
             else if (d2<d1) and (d2<6) then templatemode:=makeline2;
           end
           else
           if Tobject(templatelist[i]) is tcoastercircle then
           with TcoasterCircle(templatelist[i]) do
           begin
             d1:=dist(center,p);
             if d1<6 then templatemode:=makecircle1
             else if abs(d1-radius)<6 then templatemode:=makecircle2;
           end;
           if templatemode<>normal then
           begin
             curobj:=templatelist[i];
             cursor:=crcross;
             deletetemplate.enabled:=true;
             break;
           end;
         end;
       end;
     end;

   makeline1:
     begin
       if curobj<>nil then
       with TcoasterLine(curobj) do
       begin
        newl2.x:=l2.x + x - l1.x;
        newl2.y:=l2.y + y - l1.y;
        l1.x:=x;
        l1.y:=y;
         (*
         newl2.x:=x; newl2.y:=y;
         l1.x:=x; l1.Y:=y; l2:=l1;
         *)
         makelbl(curobj);
         templatemode:=normal;
       end;
     end;
   makeline2:
     begin
       if curobj<>nil then
       with TcoasterLine(curobj) do
       begin
         newl2.x:=x;
         newl2.y:=y;
         makelbl(curobj);
       end;
       templatemode:=normal;
     end;

   makecircle1:
     begin
       if curobj<>nil then
       with TcoasterCircle(curobj) do
       begin
         newcenter:=point(x,y);
         templatemode:=normal;
       end;
     end;
   makecircle2:
     begin
       if curobj<>nil then
       with TcoasterCircle(curobj) do
       begin
         {newradius:=dist(center,point(x,y));}
         {draw;}
         {makelbl(center,radius);}
       end;
       templatemode:=normal
     end;
   end; {case}

   if templatemode=normal then
   begin
     curobj:=nil;
     cursor:=crdefault;
     deletetemplate.enabled:=false;
   end
   else deletetemplate.enabled:=true;
   invalidate
end;

{******************* SaveToStream ***************}
procedure TCoaster.SavetoStream(st:TStream);
var
  dummy:float;
  n:float;
  i:integer;
  vertex:TVertex;
  p:TcoasterRealPoint;
  pct:integer;
  c:Tobject;
  ch:char;
begin

  with st do
  begin
    write(newversion,sizeof(newversion));
   {track}
   {undo scaling}
    for i:= 1 to bspline.numberofvertices do
    begin
      vertex:=bspline.vertexnr(i);
      p:=pixeltovirtual(vertex.x,vertex.y);
      (*
      p.y:=p.y-cymin; {make all saved coaster points zero based}
      p.x:=p.x-cxmin;
      *)
      bspline.changevertex(i,p.x,p.y);
    end;

    try
      bspline.savetostream(st);
    finally;
      {cart}
      i:=round(cartx);  writebuffer(i,sizeof(i));
      i:=round(carty); writebuffer(i,sizeof(i));
      n:=mass; writebuffer(n,sizeof(n));
      n:=gravity; writebuffer(n,sizeof(n));
      n:=friction; writebuffer(n,sizeof(n));
      writebuffer(timescale,sizeof(timescale));
      writebuffer(dummy,sizeof(dummy));
      writebuffer(msdelay,sizeof(msdelay));
      writebuffer(maxfly,sizeof(maxfly));
      writebuffer(constrained,sizeof(constrained));
      writebuffer(timestep,sizeof(timestep));
      n:=vzero; writebuffer(n,sizeof(n));
      {V2.0, added - }
      writebuffer(Fnbrcarts,sizeof(Fnbrcarts));

      {'V3.0' added -}
      pct:=round(100*fxmin/width);
      writebuffer(pct,sizeof(pct));

      pct:=round(100*fxmax/width);
      writebuffer(pct,sizeof(pct));

      pct:=round(100*fymin/height);
      writebuffer(pct,sizeof(pct));

      pct:=round(100*fymax/height);
      writebuffer(pct,sizeof(pct));



      {'V6.0 added -}
      with st, templatelist do
      begin
        writebuffer(count,sizeof(count));
        for i:= 0 to count-1 do
        begin
          c:=items[i];
          if c is TcoasterLine then
          begin
            ch:='L';
            writebuffer(ch,sizeof(ch));
            TcoasterLine(c).savetostream(st);
          end
          else if c is TcoasterCircle then
          begin
            ch:='C';
            writebuffer(ch,sizeof(ch));
            TcoasterCircle(c).savetostream(st);
          end;
        end;
      end;
    end;
  end;
  modified:=false;
end;

{******************** LoadFromStreeam ************}
procedure TCoaster.LoadFromStream(st:TStream);
var
  i:integer;
  dummy:float;
  xscale,yscale:float;
  vertex:TVertex;
  p:TcoasterrealPoint;
  testVer:string[4];
  v:integer;
  loc:longint;
  pct:integer;
  newxmax,newxmin,newymax,newymin:float;
  c:TObject;
  ch:char;
  n:integer;
begin
  if assigned(templatelist) then templatelist.clear
  else templatelist:=TObjectlist.create;  {free any old templates}
  loc:=st.position;
  st.readbuffer(testver,sizeof(Testver));
  If testver[1]='V' then  version:=testver
  else
  begin  {no version, call it version 1.0 and put stream back where it was}
    version:='V1.0';
    st.seek(soFrombeginning,loc);
  end;
  {make numeric version number}
  if version[2] in ['1'..'9'] then v:=strtoint(version[2]) else v:=1;
  {track info}
  bspline.loadfromStream(st);
  {get range of control points and set scale appropriately}
  vertex:=bspline.vertexnr(bspline.numberofvertices);
  {get min  }
  cxmin:=vertex.x;
  cxmax:=vertex.x;
  cymin:=vertex.y;
  cymax:=vertex.y;
  {set default "coaster box' pixel range to use for track displays,
   applies before version V3.0}
  fxmin:=5 * width div 100;
  fxmax:=95* width div 100;
  fymin:=20 * height div 100;
  fymax:=80 * height div 100;
   for i:=1 to bspline.numberofvertices-1 do
  begin
    vertex:=bspline.vertexnr(i);
    if vertex.x<cxmin then cxmin:=vertex.x;
    if vertex.x>cxmax then cxmax:=vertex.x;
    if vertex.y<cymin then cymin:=vertex.y;
    if vertex.y>cymax then cymax:=vertex.y;
  end;

  {cart info}
  with st do
  begin
    readbuffer(FCartx, sizeof(FCartX)); {unscaled - will scale below}
    readbuffer(FCartY,sizeof(FCartY));
    readbuffer(mass,sizeof(mass));
    readbuffer(FGRavity,sizeof(FGravity));
    readbuffer(friction,sizeof(friction));
    readbuffer(timescale,sizeof(timescale));
    readbuffer(dummy,sizeof(dummy));
    readbuffer(msdelay,sizeof(msdelay));
    readbuffer(maxfly,sizeof(maxfly));
    readbuffer(constrained,sizeof(constrained));
    readbuffer(timestep,sizeof(timestep));
    readbuffer(FVZero,sizeof(FVZero));
    if v>=2 then
    begin
      readbuffer(Fnbrcarts,sizeof(fnbrcarts));
      if Fnbrcarts>4 then Fnbrcarts:=4;
      If v>=3 then
      begin
        readbuffer(pct,sizeof(pct));
        if pct<0 then pct:=0;
        fxmin:=pct * width div 100;
        readbuffer(pct,sizeof(pct));
        if pct<0 then pct:=0;
        fxmax:=pct* width div 100;
        readbuffer(pct,sizeof(pct));
        if pct<0 then pct:=0;
        fymin:=pct * height div 100;
        readbuffer(pct,sizeof(pct));
        if pct<0 then pct:=0;
        fymax:=pct * height div 100;
      end;
    end;
    if v>=6 then  {Version 6 added template save}
    with st, templatelist do
    begin
      readbuffer(n,sizeof(n));
      for i:= 0 to n-1 do
      begin
        readbuffer(ch,1);
        if ch='L' then
        begin
          c:=tcoasterLine.create(self);
          Tcoasterline(c).loadfromstream(st);
          templatelist.add(c);
        end
        else if ch='C' then
        begin
          c:=tcoasterCircle.create(self);
          TcoasterCircle(c).loadfromstream(st);
          templatelist.add(c);
        end;
      end;
    end;
  end;

  {set new scaling factor}
  if (cxmax<>cxmin)and(cymax<>cymin) then
  begin
    xscale:=(fxmax-fxmin)/(cxmax-cxmin);
    yscale:=(fymax-fymin)/(cymax-cymin);
    scale:=min(xscale,yscale); {pixels per unit scaling factor}
  end
  else
  begin
    scale:=1.0;
  end;

  {Scale values which must be scaled but were read before scale was set}
   Fcartx:=round(FCartx*scale);
   Fcarty:=round(FCartY*scale);
   Fgravity:=FGravity*scale;
   FVZero:=FVZero*scale;
  {Scale vertex data from units to pixels}
  newxmin:=width; newxmax:=0;
  newymin:=height; newymax:=0;

  for i:=1 to bspline.numberofvertices do
  begin
    vertex:=bspline.vertexnr(i);
    p:=virtualtoPixel(vertex.x,vertex.y);
    bspline.changevertex(i,p.x,p.y);
    if p.x<newxmin then newxmin:=p.x;
    if p.x>newxmax then newxMax:=p.x;
    if p.y<newymin then newymin:=p.y;
    if p.y>newymax then newyMax:=p.y;

  end;
  Fxmax:=newxmax; Fxmin:=newxmin; Fymax:=newymax; Fymin:=newymin;
  modified:=false;
  {designmode:=false; }
end;

{********************* Rescale *******************}
Procedure TCoaster.rescale(newcxmin, newcxmax, newcymin, newcymax,
                           newxmin,newxmax,newymin,newymax:float);
{***************** has problems? *********************}
var
  xscale,yscale:float;
  i:integer;
  vertex:TVertex;
  newscale:float;
  p:TcoasterRealpoint;
  rx,ry:float;
begin
  if (newcxmin<>newcxmax) and (newcymin<>newcymax) then
  begin
    xscale:=(newxmax-newxmin)/(newcxmax-newcxmin);
    yscale:=(newymax-newymin)/(newcymax-newcymin);
    newscale:=min(xscale,yscale);
  end
  else newscale:=1.0;
  {compute ratios used to rescale coaster track control points
   to reflect dimension change}
  rx:=(newcxmax-newcxmin)/(cxmax-cxmin);
  ry:=(newcymax-newcymin)/(cymax-cymin);

  for i:=1 to bspline.numberofvertices do
  begin
   vertex:=bspline.vertexnr(i);
   p:=pixeltovirtual(vertex.x, vertex.y); {convert point back in units}
   p.x:=p.x*rx;     {scale it}
   p.y:=p.y*ry;
   p.x:=newxmin+(p.x-newcxmin)*newscale; {convert it back to pixels}
   p.y:=newymax-(p.y-newcymin)*newscale;
   bspline.changevertex(i,p.x,p.y); {and update bspline to reflect the change}
  end;
  {set new range values}
  cxmin:=newcxmin;
  cxmax:=newcxmax;
  cymin:=newcymin;
  cymax:=newcymax;
  fxmin:=newxmin;
  fxmax:=newxmax;
  fymin:=newymin;
  fymax:=newymax;
  scale:=newscale;
end;


{******************** PixelToVirtual ****************}
function TCoaster.PixelToVirtual(x,y:float):TcoasterRealPoint;
begin
  result.x:=cxmin+(x-fxmin)/scale;
  result.y:=cymin+(fymax-y)/scale;
end;

{******************** VirtualToPixel *****************}
function TCoaster.VirtualToPixel(x,y:float):TcoasterRealPoint;
begin
  result.x:=fxmin+(x-cxmin)*scale;
  result.y:=fymax-(y-cymin)*scale;
end;

{*************************************************}
{***************** Property routines *************}
{*************************************************}

procedure TCoaster.SetSigDiffFloat(var prop:float; newval:float);
{Common routine to change saved floating pt property and set modified flag
 only if change is > 0}
begin
  if abs(prop-newval)>1e-3 then
  begin
    prop:=newval;
    modified:=true;
  end;
end;

procedure TCoaster.SetSigDiffInt(var prop:Integer; newval:Integer);
{Common routine to change saved integer property and set modified flag
 only if change is > 0}
begin
  if abs(prop-newval)>0 then
  begin
    prop:=newval;
    modified:=true;
  end;
end;

 function TCoaster.GetXVal:float;
 begin
    {result:=FXVal/scale;}
    result:=cxmin+(fxval-fxmin)/scale;
 end;

 procedure Tcoaster.SetXVal(value:float);
 begin
   {SetsigDiffFloat(FXval,value*scale);}
   setsigdiffFloat(Fxval,fxmin+(value-cxmin)*scale);
 end;

 function TCoaster.GetYVal:float;
 begin
   {result:=(ymax-FYVal)/scale;}
   result:=cymin+(fymax-fyval)/scale;
 end;

 procedure TCoaster.SetYVal(value:float);
 begin
   {SetsigDiffFloat(FYVal,ymax-value*scale);}
   setsigdiffFloat(FYVal,fymax-(value-cymin)*scale);
 end;

 function TCoaster.GetV:float;
 begin   result:=FV/scale;  end;

 procedure TCoaster.SetV(value:float);
 begin  FV:=value*scale; end;

 function TCoaster.GetDistance:float;
 begin   result:=FDistance/scale;  end;

 procedure TCoaster.SetDistance(value:float);
 begin  FDistance:=value*scale; end;



 function TCoaster.GetA:float;
 begin   result:=FA/scale;  end;

 procedure TCoaster.SetA(value:float);
 begin  Fa:=value*scale; end;

 function TCoaster.GetCartx:float;
 begin   result:=FCartx/scale;  end;

 procedure TCoaster.SetCartx(value:float);
 begin  SetsigDiffInt(FCartx,round(value*scale)); end;

 function TCoaster.GetCarty:float;
 begin   result:=FCarty/scale;  end;

 procedure TCoaster.SetCarty(value:float);
 begin     SetsigDiffInt(Fcarty,round(value*scale)); end;

 procedure TCoaster.SetNbrCarts(value:integer);
 begin  FNbrCarts:=value; modified:=true; end;

 function TCoaster.GetVZero:float;
 begin   result:=FVZero/scale;  end;

 procedure TCoaster.SetVZero(value:float);
 begin   SetsigDiffFloat(FVZero,value*scale);  end;

 function TCoaster.GetGravity:float;
 begin   result:=FGravity/scale;  end;

 procedure TCoaster.SetGravity(value:float);
 begin  SetsigDiffFloat(FGravity,value*scale); end;

procedure TCoaster.settimestep(timeinc:float);
begin  SetsigDiffFloat(timestep,timeinc); end;

procedure TCoaster.setfriction(newfriction:float);
begin SetsigDiffFloat(friction,newfriction); end;

procedure Tcoaster.setMass(newMass:float);
begin  SetsigDiffFloat(mass,newMass); end;

procedure TCoaster.setConstrained(newConstrained:boolean);
begin  If constrained<>newconstrained then
  begin
    constrained:=newconstrained;
    modified:=true;
  end;
end;

procedure TCoaster.SetSkyline(value:integer);
begin FSkyline:=value; modified:=true; end;

procedure TCoaster.setTimeScale(newTimeScale:float);
begin
  setsigdiffFloat(timescale,newtimescale);
  msdelay:=trunc(timestep*1000/timescale);
end;

procedure TCoaster.SetXMax(value:float);
begin   FXmax:=value;   modified:=true; end;

procedure TCoaster.SetXMin(value:float);
begin   FXmin:=value;   modified:=true; end;

procedure TCoaster.SetYMax(value:float);
begin   FYmax:=value;   modified:=true; end;

procedure TCoaster.SetYMin(value:float);
begin   FYmin:=value;   modified:=true; end;


{***************TCart.init ********************}
procedure TCoaster.init(newmaxfly:integer);
var
  i:integer;
  vertex:TVertex;
begin
  designmode:=false;
  poslbl.visible:=false;
  if not assigned(templatelist) then templatelist:=Tobjectlist.create;
  {templatelist.clear;}{maybe we want to keep templates & let user manage them?}
  nbrpoints:=0;
  chainpoint:=-1;
  if BSpline<>nil then
  For i:=0 to segs do {rebuild the ramp segments}
  with bspline do
  begin
    Vertex:=Value(i/segs);
    AddPoint(trunc(vertex.x) , trunc(vertex.y));
  end;
  finalize;
  drawfield;
  savebg.width:=Width;
  savebg.height:=height;
  imagecopy.width:=width;
  imagecopy.height:=height;
  {copy entire background image to savebg}
  savebg.canvas.copyrect(clientrect,canvas,clientrect);
  imagecopy.canvas.copyrect(clientrect,canvas,clientrect);

  saverect.left:=-1;
  time:=0;
  Fxval:=0; Fyval:=0;
  rec.index:=0;
  maxfly:=newmaxfly;
  offtrack:=false;
  Fv:=Fvzero;
  FDistance:=0;
  vx:=0; vy:=0;
  Looptype:=none;

  rec.index:=0;
  rec.disttoend:=rpoints[0].lengthright;
  getNextPosition(rec,0);
  theta:=rec.angle;
  vx:=Fv*abs(rec.cosangle);  {make sure initial velocities are positive}
  vy:=Fv*abs(rec.sinangle);
  Fxval:=rec.x;
  Fyval:=rec.y;
  time:=0;
  fward:=true;
  If rec.index<chainpoint then
  begin
   onchain:=true;
   If playRunsounds
   then playsound(pchar('CHAIN'),0,Snd_Resource+Snd_Async+Snd_Loop);
  end
  else
  begin
    onchain:=false;
    playsound(nil,0,Snd_Async+Snd_Loop);
  end;
  vertex:=bspline.vertexnr(bspline.numberofvertices-1);
  brakepoint:=vertex.x;
  invalidate; {force painting}
end;

 function sign(x:float):integer;
 begin
   if x<0 then result:=-1
   else result:=+1;
 end;

{************* Steptime **************}
function TCoaster.steptime:boolean;
{Key cart movement procedure - incrmement time by one timestep and
 move cart as laws of motion and current constraints dictate}
var
  vyf,vxf,vf,dy,FreefallYval:float;
  dist:float; 
  steps,d:float;
  r:boolean;
  starttime:TDatetime;
  waitms:integer;
  trackyval:float;
  prevquadrant:integer;

  function rightsideup:boolean;
  begin
    with rec do
    result:=(quadrant=1) or (quadrant=2);
  end;

begin
  starttime:=sysutils.time;
  time:=time+timestep;
  {dist= 1/2(Vstart+Vend)*t}
  dist:=(Fv+Fv+Fgravity*timestep)/2*timestep;
  Fdistance:=Fdistance+dist;
  {calculate freefall y values (i.e. where would the cart be if no track)}
    vyf:=vy+Fgravity*timestep;
    dy:=0.5*timestep*(vy+vyf);
    freefallyVal:=fyval+dy;
  prevquadrant:=rec.quadrant;
  r:=getnextposition (rec, dist); {Get location values for next timestep}

  If offtrack then {just keep on falling}
  begin  {gravity doesn't affect x values}
    fyval:=FreefallYval;
    vy:=vyf;
    Fxval:=Fxval+vx*timestep;
    g:=0
  end
  else
  if r then
  begin
    if playRunsounds then
    if (theta<screamangle) and (rec.angle>screamangle) {start screaming}
         then playsound(pchar('SCREAM2'),0,SND_RESOURCE+SND_ASYNC+SND_LOOP)
         else if (theta>screamangle) and (rec.angle<screamangle)
          then {flattened out - stop screaming}
               playsound(pchar('COASTER'),0,SND_RESOURCE+SND_ASYNC+SND_LOOP);
    with rec do  {detect inside or outsideloops}
    begin
      if (quadrant=3) or (quadrant=4) then
      begin
        if (quadrant=3) and (prevquadrant=2) then looptype:=outsideloop
        else if (quadrant=4) and (prevquadrant=1) then looptype:=insideloop;
      end
      else looptype:=none;
  end;
    if rec.radius<>0 then
    if Fgravity>0 then
    begin
      case rec.quadrant of
        1,2: g:=Fv*Fv/(Fgravity*rec.radius)+abs(cos(theta));
        3,4: if looptype=outsideloop
             then g:=-abs(Fv*Fv/(Fgravity*rec.radius))-abs(cos(theta))
             else g:=abs(Fv*Fv/(Fgravity*rec.radius))-abs(cos(theta))
      end;
    end
    else g:=0;
    if not constrained and rightsideup and (g<0)
    then g:=0; {can't really experience negative g's unless constrained to track}
    trackyval:=rec.y;
    if (rec.index<chainpoint) {still on chain}
    then
    begin
      fyval:=trackyval;
      Fxval:=rec.x;
      theta:=rec.angle;
    end
    else {rolling free}
    begin
      if onchain then {come off the chain}
      begin
        onchain:=false;
        If playRunsounds then
        playsound(Pchar('COASTER'),0,SND_RESOURCE+SND_ASYNC+SND_LOOP);
      end;
      flyheight:=trackyval-freefallyval;
      If (not constrained) and
         ((rightsideup and (flyheight>0))
         or ((not rightsideup) and (g<0)))
      then  {we're flying at least a little way off of the track}
      {most "flying" is not real but caused by linear segment approximating
       curved track}
      begin
        Fyval:=freefallyval;
        Fxval:=Fxval+Fv*timestep;
        vy:=vyf;

        if (rightsideup and  (flyheight>maxfly)) {check if too far off of track}
           or ((not rightsideup) and (flyheight<0))
        then
        begin
          offtrack:=true; {oh, oh - really jumped the track}
          If playFallSounds
          then  playsound(pchar('SCREAM1'),0,SND_RESOURCE+SND_ASYNC+SND_LOOP);
        end
        else
        begin
          theta:=rec.angle;
          Fxval:=rec.x;
        end;
      end
      else
      begin  {ontrack}
        theta:=rec.angle;
        Fxval:=rec.x;
        Fyval:=rec.y;

        {these are values for next timestep}
        if rec.x<brakepoint
        then
        begin
           Fa:=Fgravity*(rec.sinangle-sign(vx)*friction*abs(rec.cosangle));
           If (rec.radius<>0) and (rec.radius<1e6) then an:=Fv*Fv/rec.radius
           else an:=0;  {added 8/8/03 for debuggrid listings}
           vf:=Fv+Fa*timestep;
        end
        else
        begin
          {apply brakes (increase friction) strongly enough to stop cart by end of track}
          d:=rpoints[nbrpoints-1].x-rec.x;
          if Fv<>0 then steps:=d/Fv/timestep else steps:=0;
          if steps>=1 then Fv:=(steps-1)/steps*Fv;
          vf:=Fv;
        end;
        vxf:=vf*rec.cosangle; {velocity at end of time period}
        if ((vx*vxf<0) or (vxf=0)) and ((rec.quadrant=1) or (rec.quadrant=2))
        then fward:= not fward;  {reversed direction}
        {set initial velocities for next interval}
        vx:=vxf;
        vy:=vf*rec.sinangle;
        Fv:=vf;
      end;
    end;
  end;
  drawcart;  {draws cart quickly - paint exit will repaint all when necessary}
  waitms:=msdelay-trunc((sysutils.time-starttime)*secsperday*1000);
  if (waitms<0) or (waitms>1000) then waitms:=1;
  sleep(waitms);
  {keep going test: result=false ==> at end}
  if not offtrack then
  begin
    result:= (Fxval<fxmax-1) and (Fxval>=fxmin-1)
        and ((abs(rec.sinangle)>0.2) or (abs(vx)>0.5));
    if result=false
    then playsound(nil,0,SND_ASYNC);
  end
  else
  begin
    result:= (Fxval<xmax) and (Fyval<=ymax);
    if (result=false) and (playfallsounds)
    then playsound(PCHAR(ouchresources[random(nbrouchfiles)]),0,
                                   SND_RESOURCE+SND_ASYNC);
  end;
end;

end.
