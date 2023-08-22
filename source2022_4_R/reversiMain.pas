{$A8,B-,C+,D+,E-,F-,G+,H+,I-,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
//#####################################################################
// ReVersus - A Reversi game using OpenGL for graphics.
// by Vlad PARCALABIOR (vlad@ifrance.com) 10.2000
// visit http://arrowsoft.ifrance.com for other OpenGL Delphi programs.
//
// The Othello(Reversi) AI original by Roman Podobedov (romka@ut.ee)
// enhanced by max loc's = 1170 less graphics, dialogs
// This is freeware!  Feel free to contact me.
// build total = 114178 included jpeg! , 642kb, 113993
//#####################################################################

//{$I 'maxCompilerDefines.inc'}


unit reversiMain;

interface


uses
  Windows, SysUtils, Classes, Controls, Forms,
  OpenGL, Geometry, Textures, Reversi, ExtCtrls, Messages;

type
  TmForm = class(TForm)
    StartTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
  public
  procedure GetMinMax (var MinMaxMessage: TWMGetMinMaxInfo);
                         message wm_GetMinMaxInfo;
  end;

const aspect= 1.3; //window's aspect ratio
      h= 50.5;     //height of the virtual lightsource
      bump:single= 0.015;   //amount of bumpmapping
      CHECK_AND_DO= FALSE;
      CHECK_ONLY= TRUE;

      lst_bord=3; black=2; white=1;
      tex_wood=1; tex_tile=2; tex_disk=3; tex_bk=4;
      tex1=5; tex2=6; tex3=7; tex4=8; tex5=9; tex6=10;
      lmap=11; tex_font=12; tex_pan=14; tex_bump=15; tex_bump_inv=16;

var
  mForm: TmForm;
  DC: HDC; HRC: HGLRC;
  animate: boolean=false;
  bpressed: boolean=false;
  dynalight: boolean=true;
  moving: boolean=false;  //making a move?
  popping:boolean=false;  //popping up a disk?
  rotang: glFloat;                 //rotation angle
  frametime, starttime: cardinal;
  board: tBoard; //ze board
  blackc, whitec: byte; //score counters
  wc1, wc2: byte;  // What to check
  mx,my: integer; // mouse coords for lightmap direction
  base : GLuint;  //font displaylist base

implementation
{$R *.DFM}

procedure tmform.GetMinMax (var MinMaxMessage: TWMGetMinMaxInfo);
begin
 with MinMaxMessage.MinMaxInfo^ do begin
    ptMinTrackSize.x := round(100*aspect)+8;
    ptMinTrackSize.y := 100+27;
    ptMaxTrackSize.x := round((screen.height-27)*aspect);
    ptMaxTrackSize.y := screen.height-27;
  end;
end;

procedure BindTextureAll(tex: TTexture);
      //GL_CLAMP                                   = $2900;
      //GL_REPEAT                                  = $2901;

begin
  glBindTexture(GL_TEXTURE_2D, tex.ID);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_repeat);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_repeat);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_linear);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_Linear_MIPMAP_nearest);
  gluBuild2DMipmaps(GL_TEXTURE_2D, 3, tex.width, tex.height,
                  GL_RGB, GL_UNSIGNED_BYTE, tex.pixels);
end;


procedure initex;
var tex: ttexture;
    vtex: tvoidtexture;
    i,j: integer;

begin
tex:=ttexture.Load(tex_wood,'source\opengldata\wood.jpg');
 BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(tex_tile,'source\opengldata\greenmar.jpg');
 BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(tex_disk,'source\opengldata\disk.jpg');
 BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(tex_bk,'source\opengldata\bk.jpg');
  BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(tex1,'source\opengldata\tex1.jpg');
BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(tex2,'source\opengldata\tex2.jpg');
BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(tex3,'source\opengldata\tex3.jpg');
BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(tex4,'source\opengldata\tex4.jpg');
BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(lmap,'source\opengldata\lmap.jpg');
BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(tex5,'source\opengldata\tex5.jpg');
BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(tex6,'source\opengldata\tex6.jpg');
BindTextureAll(tex);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_decal);
tex.free;
tex:=ttexture.Load(tex_pan,'source\opengldata\pannel.jpg');
BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(tex_font,'source\opengldata\font.jpg');
BindTextureAll(tex);
tex.free;
tex:=ttexture.Load(tex_bump,'source\opengldata\bump.bmp');
BindTextureAll(tex);
vtex:=tvoidtexture.create(tex_bump_inv, tex.width, tex.height);
for j:=0 to vtex.height-1 do //invert bump texture
 for i:=0 to vtex.width-1 do begin
  vtex.pixels[j*tex.width+i].r:=128-tex.pixels[j*tex.width+i].r;
  vtex.pixels[j*tex.width+i].g:=128-tex.pixels[j*tex.width+i].g;
  vtex.pixels[j*tex.width+i].b:=128-tex.pixels[j*tex.width+i].b;
  end;
glBindTexture(GL_TEXTURE_2D, vtex.ID);
//typecasting
  BindTextureAll(TTexture(vtex));
gluBuild2DMipmaps(GL_TEXTURE_2D, 3, vtex.width, vtex.height,
                  GL_RGB, GL_UNSIGNED_BYTE, vtex.pixels);
tex.Free;
vtex.Free;
end;

//////////////////////////////////////////////////////////////
// The font code is written by Jeff Molofee
// and modified By Giuseppe D'Agata (waveform@tiscalinet.it)
//note: Modified for this program by me (vlad@ifrance.com).
//////////////////////////////////////////////////////////////

procedure BuildFont;						// Build Our Font Display List
var cx,cy : single;
    loop : word;    							// Holds Our X Character Coord
begin
  base := glGenLists(256);					// Creating 256 Display Lists
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_modulate);
  glBindTexture(GL_TEXTURE_2D, tex_font);			// Select Our Font Texture

  for loop := 0 to 255 do begin					// Loop Through All 256 Lists
    cx := (loop mod 16) / 16;					// X Position Of Current Character
    cy := (loop div 16) / 16;					// Y Position Of Current Character
    glNewList(base+loop,GL_COMPILE);				// Start Building A List
    glBegin(GL_QUADS);						// Use A Quad For Each Character
 //note: CW front face (for culling)
            glTexCoord2f(cx,cy+0.0625);	        		// Texture Coord (Bottom Left)
            glVertex2i(0,0);					// Vertex Coord (Bottom Left)
            glTexCoord2f(cx,cy);				// Texture Coord (Top Left)
            glVertex2i(0,30);					// Vertex Coord (Top Left)
            glTexCoord2f(cx+0.0625,cy);			        // Texture Coord (Top Right)
            glVertex2i(30,30);					// Vertex Coord (Top Right)
            glTexCoord2f(cx+0.0625,cy+0.0625);	                // Texture Coord (Bottom Right)
            glVertex2i(30,0);					// Vertex Coord (Bottom Right)
    glEnd();
    glTranslated(18,0,0);					// Move To The Right Of The Character
    glEndList();						// Done Building The Display List
  end;								// Loop Until All 256 Are Built
end;

procedure KillFont;         // Delete The Font From Memory
begin
  glDeleteLists(base,256);  // Delete All 256 Display Lists
end;

procedure glPrint(x, y : GLint; scale:GLfloat; text : pchar; fontset : byte);// Where The Printing Happens
var pbase: integer;
begin
  if (fontset>1) then fontset :=1;
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_modulate);
  glBindTexture(GL_TEXTURE_2D, tex_font);
  glDisable(GL_DEPTH_TEST);					// Disables Depth Testing
  glEnable(GL_BLEND);
  glPushMatrix;	               					// Store The Modelview Matrix
  glLoadIdentity;						// Reset The Modelview Matrix
  glTranslated(x,y,10);    					// Position The Text (0,0 - Bottom Left)
  glScalef(scale,scale,1);
  glPushAttrib(GL_LIST_BIT);
  // overflow floating point ---------------------------------------
  {$Q-}
  glListBase(base-32+(128*fontset));
  glGetIntegerv(GL_LIST_BASE, @pbase);
  glCallLists(strlen(text),GL_BYTE,text);
  glPopAttrib;
  glPopMatrix;				          		// Restore The Old Projection Matrix
  glEnable(GL_DEPTH_TEST);					// Enables Depth Testing
  glDisable(GL_BLEND);
end;

procedure printscore;
var s:string;
begin
glEnable(GL_BLEND);
s:=inttostr(whitec);
if length(s)=1 then s:='0'+s;
glColor4ub(216,179,47,255);
glPrint(486, 122, 1, pchar(s), 1);
glColor4ub(60,10,0,255);
glPrint(484, 120, 1, pchar(s), 1);
s:=inttostr(blackc);
if length(s)=1 then s:='0'+s;
glColor4ub(216,179,47,255);
glPrint(486, 22, 1, pchar(s), 1);
glColor4ub(60,10,0,255);
glPrint(484, 20, 1, pchar(s), 1);
glColor4f(1.0,1.0,1.0,1.0);
glDisable(GL_BLEND);
end;

procedure initdisks;
var sphere:pGLUquadric;
begin
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_decal);
glNewList(black,GL_COMPILE);
 glrotatef(-90,0,1,0);
 glscalef(0.3,1,1);
 glBindTexture(GL_TEXTURE_2D, tex_disk);
 glFrontFace(GL_CCW);
 sphere:=gluNewQuadric();
 gluQuadricDrawStyle(sphere, GLU_FILL);
 gluQuadricNormals(sphere, GLU_SMOOTH);
 gluQuadricOrientation(sphere, GLU_OUTSIDE);
 gluQuadricTexture(sphere, GL_TRUE);
 gluSphere(sphere,22,20,20);
 glFrontFace(GL_CW);
 gluDeleteQuadric(sphere);
glEndList;

glNewList(white,GL_COMPILE);
 glrotatef(90,0,1,0);
 glscalef(0.3,1,1);
 glBindTexture(GL_TEXTURE_2D, tex_disk);
 glFrontFace(GL_CCW);
 sphere:=gluNewQuadric();
 gluQuadricDrawStyle(sphere, GLU_FILL);
 gluQuadricNormals(sphere, GLU_SMOOTH);
 gluQuadricOrientation(sphere, GLU_OUTSIDE);
 gluQuadricTexture(sphere, GL_TRUE);
 gluSphere(sphere,22,20,20);
 glFrontFace(GL_CW);
 gluDeleteQuadric(sphere);
glEndList;

glNewList(lst_bord,GL_COMPILE);
glBindTexture(GL_TEXTURE_2D, tex_wood); //the board's wooden border.
glBegin(GL_TRIANGLES);
glTexCoord2f(1.00, 0.67); glVertex3i(-25, -25, 0);
glTexCoord2f(0.75, 0.67); glVertex3i(-25, 0, 0);
glTexCoord2f(0.75, 1.00); glVertex3i(0, 0, 0);
glTexCoord2f(0.75, 0.67); glVertex3i(-25, -25, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(0, 0, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(0, -25, 0);
glEnd;
glBegin(GL_QUADS);
glTexCoord2f(0.00, 0.67); glVertex3i(0, -25, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(0, 0, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(100, 0, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(100, -25, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(100, -25, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(100, 0, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(200, 0, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(200, -25, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(200, -25, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(200, 0, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(300, 0, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(300, -25, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(300, -25, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(300, 0, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(400, 0, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(400, -25, 0);
glEnd;
glBegin(GL_TRIANGLES);
glTexCoord2f(0.00, 0.67); glVertex3i(400, -25, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(400, 0, 0);
glTexCoord2f(0.25, 0.67); glVertex3i(425, -25, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(425, -25, 0);
glTexCoord2f(0.25, 1.00); glVertex3i(400, 0, 0);
glTexCoord2f(0.25, 0.67); glVertex3i(425, 0, 0);
glEnd;
glBegin(GL_QUADS);
glTexCoord2f(0.00, 1.00); glVertex3i(400, 0, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(400, 100, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(425, 100, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(425, 0, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(400, 100, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(400, 200, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(425, 200, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(425, 100, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(400, 200, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(400, 300, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(425, 300, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(425, 200, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(400, 300, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(400, 400, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(425, 400, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(425, 300, 0);
glEnd;
glBegin(GL_TRIANGLES);
glTexCoord2f(0.00, 1.00); glVertex3i(400, 400, 0);
glTexCoord2f(0.25, 0.67); glVertex3i(425, 425, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(425, 400, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(400, 400, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(400, 425, 0);
glTexCoord2f(0.75, 0.67); glVertex3i(425, 425, 0);
glEnd;
glBegin(GL_QUADS);
glTexCoord2f(1.00, 1.00); glVertex3i(300, 400, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(300, 425, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(400, 425, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(400, 400, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(200, 400, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(200, 425, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(300, 425, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(300, 400, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(100, 400, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(100, 425, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(200, 425, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(200, 400, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(0, 400, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(0, 425, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(100, 425, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(100, 400, 0);
glEnd;
glBegin(GL_TRIANGLES);
glTexCoord2f(0.25, 0.67); glVertex3i(-25, 425, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(0, 425, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(0, 400, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(-25, 400, 0);
glTexCoord2f(0.75, 0.67); glVertex3i(-25, 425, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(0, 400, 0);
glEnd;
glBegin(GL_QUADS);
glTexCoord2f(1.00, 0.67); glVertex3i(-25, 300, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(-25, 400, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(0, 400, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(0, 300, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(-25, 200, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(-25, 300, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(0, 300, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(0, 200, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(-25, 100, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(-25, 200, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(0, 200, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(0, 100, 0);
glTexCoord2f(1.00, 0.67); glVertex3i(-25, 0, 0);
glTexCoord2f(0.00, 0.67); glVertex3i(-25, 100, 0);
glTexCoord2f(0.00, 1.00); glVertex3i(0, 100, 0);
glTexCoord2f(1.00, 1.00); glVertex3i(0, 0, 0);
glEnd; // very tesselated, wasn't it.
glEndList;
end;

procedure setdisk(x,y,color:byte; ang: single);
var lx,ly,lz: glfloat; //world coords
    dx, dy: glfloat; //displacements for the lightmap quad
    px, py:integer;  //window coords of 'piece'
begin
lx:=25+x*50;
ly:=25+(7-y)*50;
lz:=-0.12;
glpushmatrix;
 gltranslatef(lx,ly,lz);
 glpushmatrix;
 if color=white then begin
  glrotatef(ang,0,1,0);
  glCallList(white);
  end else begin
  glrotatef(-ang,0,1,0);
  glCallList(black);
  end;
 glpopmatrix;

 if dynalight then begin    //dynamic lightmap coming from mouse pointer
  px:=round((lx+50)*mform.ClientWidth/(500*aspect));
  py:=round((ly-450)*(mform.ClientHeight-1)/-500);
  if mx>=px then
   dx:=5/(h/(mx-px)+0.3)
  else
   dx:=-5/(h/(px-mx)+0.3);
  if my>=py then
   dy:=-5/(h/(my-py)+0.3)
  else
   dy:=5/(h/(py-my)+0.3);
  end
 else begin          //fixed lightmap
  dx:=6;
   dy:=7;
 end;
 gldisable(GL_DEPTH_TEST);
 glenable(GL_BLEND);
 glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_modulate);
 glBindTexture(GL_TEXTURE_2D, lmap);
 glColor4f(1.0,1.0,1.0,0.1);
 glBegin(GL_QUADS);
 glTexCoord2f(0, 1); glVertex3f(-22+dx,-22+dy,10);
 glTexCoord2f(0, 0); glVertex3f(-22+dx,22+dy,10);
 glTexCoord2f(1, 0); glVertex3f(22+dx,22+dy,10);
 glTexCoord2f(1, 1); glVertex3f(22+dx,-22+dy,10);
 glEnd;
 gldisable(GL_BLEND);
 glenable(GL_DEPTH_TEST);
glpopmatrix;
end;

procedure drawdisk;
var x,y:byte;
begin
for y:=0 to 7 do
 for x:=0 to 7 do
  case board[y,x] of
   black: setdisk(x,y,black,0);
   white: setdisk(x,y,white,0);
   3: if popping then setdisk(x,y,wc1,0);
  end;
end;

procedure putboard;
  var i,j: integer;
    wx, wy, vx, vy: glfloat;
    vvertex, vlight, vbump: tAffineVector;

  //subroutine
  procedure checkDynalight;
  begin
  if dynalight then begin
   vvertex:=makeaffinevector([vx,vy,0]);
   vlight:=makeaffinevector([wx,wy,0]);
   vbump:=VectorAffineSubtract(vlight, vvertex);
   VectorNormalize(vbump);
   VectorScale(vbump, BUMP);
   end
  else begin           //fixed light
   vbump[0]:=0;
    vbump[1]:=0;
   end;
  end;

begin
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_decal);
glBindTexture(GL_TEXTURE_2D, tex_bk); //background
glBegin(GL_QUADS);
glTexCoord2f(0, 0); glVertex3i(-50,-50,-50);
glTexCoord2f(0, 4); glVertex3i(-50,450,-50);
glTexCoord2f(5, 4); glVertex3i(600,450,-50);
glTexCoord2f(5, 0); glVertex3i(600,-50,-50);
glEnd;
glCallList(lst_bord);

//the bump mapped board
//first pass: the bump texture
glDisable(GL_BLEND);
glBindTexture(GL_TEXTURE_2D, tex_bump);
glBegin(GL_QUADS);
glTexCoord2f(0, 8); glVertex3i(0,0,0);
glTexCoord2f(0, 0); glVertex3f(0,400,0);
glTexCoord2f(8, 0); glVertex3f(400,400,0);
glTexCoord2f(8, 8); glVertex3f(400,0,0);  //could be a problem
glEnd;

//second pass: inverted bump+shift+blend
// Thanks to Tom Nuydens
glEnable(GL_BLEND);
glBlendFunc(GL_ONE, GL_ONE);    //additive blend
glBindTexture(GL_TEXTURE_2D, tex_bump_inv);
glMatrixMode(GL_TEXTURE);
glPushMatrix;    // my textures all upside down. :( Must be a bug somewhere.
glrotatef(180,0,0,1); // ..so I flip this one.
glrotatef(180,0,1,0);
wx:= round(mx*(500*aspect-50+50)/mform.clientwidth -50); //screen->world transform
wy:= round(my*(-500/(mform.clientheight-1)) +450);

//draw the board
for i:= 0 to 7 do
 for j := 0 to 7 do begin
  glBegin(GL_quads);
//NW
  vx := j*50;
  vy := i*50+50;
  CheckDynalight;
  glTexCoord2f(j+vbump[0], (i+1)+vbump[1]); glVertex3f(vx, vy, 0);
//NE
  vx := j*50+50;
  CheckDynalight;
  glTexCoord2f((j+1)+vbump[0], (i+1)+vbump[1]); glVertex3f(vx, vy, 0);
//SE
  vx := j*50+50;
  vy := i*50;
  CheckDynalight;
  glTexCoord2f((j+1)+vbump[0], i+vbump[1]); glVertex3f(vx, vy, 0);
//SW
  vx := j*50;
  CheckDynalight;
  glTexCoord2f(j+vbump[0], i+vbump[1]); glVertex3f(vx, vy, 0);
  glEnd;

  end; //for j:?
  glpopmatrix;
  glmatrixmode(gl_modelview);
// 3rd pass
//multiplicative 2x blend
glBlendFunc(GL_DST_COLOR, GL_SRC_COLOR);
glBindTexture(GL_TEXTURE_2D, tex_tile);
glBegin(GL_QUADS);
glTexCoord2f(0, 8); glVertex3i(0,0,0);
glTexCoord2f(0, 0); glVertex3f(0,400,0);
glTexCoord2f(8, 0); glVertex3f(400,400,0);
glTexCoord2f(8, 8); glVertex3f(400,0,0);
glEnd;

glBlendFunc(GL_SRC_ALPHA, GL_ONE);
glDisable(GL_BLEND);
glBindTexture(GL_TEXTURE_2D, tex1);
glBegin(GL_QUADS);
glTexCoord2f(0, 1); glVertex3i(450,312,0);
glTexCoord2f(0, 0); glVertex3f(450,425,0);
glTexCoord2f(1, 0); glVertex3f(575,425,0);
glTexCoord2f(1, 1); glVertex3f(575,312,0);
glEnd;
if not bpressed then
 glBindTexture(GL_TEXTURE_2D, tex2)
else
 glBindTexture(GL_TEXTURE_2D, tex3);
glBegin(GL_QUADS);
glTexCoord2f(0, 1); glVertex3f(450,255,0);
glTexCoord2f(0, 0); glVertex3f(450,313,0);
glTexCoord2f(1, 0); glVertex3f(575,313,0);
glTexCoord2f(1, 1); glVertex3f(575,255,0);
glEnd;

if dynalight then
 glBindTexture(GL_TEXTURE_2D, tex5)
else
 glBindTexture(GL_TEXTURE_2D, tex6);
glBegin(GL_QUADS);
glTexCoord2f(0, 1); glVertex3f(450,199,0);
glTexCoord2f(0, 0); glVertex3f(450,257,0);
glTexCoord2f(1, 0); glVertex3f(575,257,0);
glTexCoord2f(1, 1); glVertex3f(575,199,0);
glEnd;

glBindTexture(GL_TEXTURE_2D, tex4);
glBegin(GL_QUADS);
glTexCoord2f(0, 1); glVertex3f(450,-25,0);
glTexCoord2f(0, 0); glVertex3f(450,200,0);
glTexCoord2f(1, 0); glVertex3f(575,200,0);
glTexCoord2f(1, 1); glVertex3f(575,-25,0);
glEnd;
end;

procedure drawpannel;
begin
glDisable(GL_DEPTH_TEST);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_decal);
glBindTexture(GL_TEXTURE_2D, tex_pan);
glBegin(GL_QUADS);
glTexCoord2f(0, 0); glVertex3i(50,237,-50);
glTexCoord2f(1, 0); glVertex3i(349,237,-50);
glTexCoord2f(1, 1); glVertex3i(349,163,-50);
glTexCoord2f(0, 1); glVertex3i(50,163,-50);
glEnd;
glEnable(GL_DEPTH_TEST);
end;

procedure drawboard;
var vx,vy: glfloat; //coords for pointer light
begin
glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
putboard;
drawdisk;
printscore;

if blackc=0 then begin
 drawpannel;
 glColor4ub(216,179,47,255);
 glPrint(90, 191, 0.64, 'HA HA HA! You lost!', 0);
 glColor4ub(60,10,0,255);
 glPrint(89, 190, 0.64, 'HA HA HA! You lost!', 0);
 glColor4ub(255,255,255,255);
 end;
if whitec=0 then begin
 drawpannel;
 glColor4ub(216,179,47,255);
 glPrint(79, 191, 0.61, 'How did you do that?!', 0);
 glColor4ub(60,10,0,255);
 glPrint(78, 190, 0.61, 'How did you do that?!', 0);
 glColor4ub(255,255,255,255);
 end;
if whitec+blackc=64 then
 if blackc>whitec then begin
  drawpannel;
  glColor4ub(216,179,47,255);
  glPrint(66, 191, 0.585, 'Congratulations! You won!', 0);
  glColor4ub(60,10,0,255);
  glPrint(65, 190, 0.585, 'Congratulations! You won!', 0);
  glColor4ub(255,255,255,255);
  end
 else
  if whitec>blackc then begin
   drawpannel;
   glColor4ub(216,179,47,255);
   glPrint(85, 191, 0.64, 'You lost! Try again.', 0);
   glColor4ub(60,10,0,255);
   glPrint(84, 190, 0.64, 'You lost! Try again.', 0);
   glColor4ub(255,255,255,255);
   end
  else
   begin
   drawpannel;
   glColor4ub(216,179,47,255);
   glPrint(130, 191, 0.64, 'It''s a tie.', 0);
   glColor4ub(60,10,0,255);
   glPrint(130, 191, 0.64, 'It''s a tie.', 0);
   glColor4ub(255,255,255,255);
   end;

if dynalight  and (not animate) then begin
 vx:= mx*(500*aspect-50+50)/mform.clientwidth -50;
 vy:= my*(-500/(mform.clientheight-1)) +450;

 gldisable(GL_DEPTH_TEST);
 glenable(GL_BLEND);
 glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_modulate);
 glBindTexture(GL_TEXTURE_2D, lmap);
 glColor4f(1.0,1.0,1.0,0.05);
 glBegin(GL_QUADS);
 glTexCoord2f(0, 1); glVertex3f(-100+vx,-100+vy,10);
 glTexCoord2f(0, 0); glVertex3f(-100+vx,100+vy,10);
 glTexCoord2f(1, 0); glVertex3f(100+vx,100+vy,10);
 glTexCoord2f(1, 1); glVertex3f(100+vx,-100+vy,10);
 glEnd;
 glenable(GL_DEPTH_TEST);
 end;

glDisable(GL_BLEND);
glFinish;
SwapBuffers(DC);
end;

procedure ResizeViewport(width,height:longint);
var left, right, bottom, top: single;
begin
glViewport(0, 0, width, height);
glMatrixMode(GL_PROJECTION);
glLoadIdentity();
top:= 450;
bottom:= -50;
left:=-50;
right:= (top-bottom) * aspect + left;
glortho(left, right, bottom, top, -100, 100);
glMatrixMode(GL_MODELVIEW);
end;

procedure TmForm.FormResize(Sender: TObject);
begin
clientheight:=round(clientwidth/aspect);
glViewport(0, 0, clientwidth, clientheight);
drawboard;
end;

Procedure SetupGL(width,height:longint);
begin
glClearColor(0.0, 0.0, 0.0, 0.0);
glClearDepth(1.0);
glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
glShadeModel(GL_SMOOTH);
glDepthFunc(GL_LEQUAL);
glFrontFace(GL_CW);
glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
glBlendFunc(GL_src_alpha, GL_ONE);
glAlphaFunc(GL_GEQUAL, 0.05);

//glenable(GL_COLOR_MATERIAL);
glenable(GL_DEPTH_TEST);
glEnable(GL_CULL_FACE); ///////////
gldisable(GL_BLEND);
glenable(GL_ALPHA_TEST);
//gldisable(GL_LIGHTING);
glEnable(GL_TEXTURE_2D);

glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
//glPolygonOffset(-0.9, 0.0025);
ResizeViewport(width, height);
end;

procedure Rotation;
var i, j: integer;
    vx,vy: glfloat; //coords for pointer light
begin
animate:=true;
rotang:=0;
repeat
 starttime:=gettickcount;
 glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
 putboard;
 drawdisk;
 printscore;
 for i:=0 to 7 do
  for j:=0 to 7 do
   if board[j,i]=3 then
    setdisk(i,j, wc1, rotang);
 if dynalight then begin
 vx:= mx*(500*aspect-50+50)/mform.clientwidth -50;
 vy:= my*(-500/(mform.clientheight-1)) +450;

 gldisable(GL_DEPTH_TEST);
 glenable(GL_BLEND);
 glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_modulate);
 glBindTexture(GL_TEXTURE_2D, lmap);
 glColor4f(1.0,1.0,1.0,0.05);
 glBegin(GL_QUADS);
 glTexCoord2f(0, 1); glVertex3f(-100+vx,-100+vy,10);
 glTexCoord2f(0, 0); glVertex3f(-100+vx,100+vy,10);
 glTexCoord2f(1, 0); glVertex3f(100+vx,100+vy,10);
 glTexCoord2f(1, 1); glVertex3f(100+vx,-100+vy,10);
 glEnd;
 gldisable(GL_BLEND);
 glenable(GL_DEPTH_TEST);
 end;

 glFinish;
 SwapBuffers(DC);
 frametime:=gettickcount-starttime;
 rotang:=rotang+(frametime/1000)*380;
 Application.ProcessMessages;
until (not animate) or (rotang>180);

animate:= false;
end;

procedure popup(x,y,color:byte);
var lx,ly,lz: glfloat; //world coords
    dx, dy: glfloat; //displacements for the lightmap quad
    px, py:integer;  //window coords of 'piece'
    vx,vy: glfloat; //coords for pointer light
begin
lx:=25+x*50;
ly:=25+(7-y)*50;
lz:=-6.9;
rotang:=0;
popping:=true;
animate:=true;
glEnable(GL_DEPTH_TEST);
repeat
 starttime:=gettickcount;
 glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
 putboard;
 drawdisk;
 printscore;
 glPushMatrix;
 glTranslatef(lx, ly, lz);
  glpushmatrix;
  if color=white then glCallList(white)
  else glCallList(black);
  glpopmatrix;

  if lz>-4 then begin  //if disk is big enough to have a light on it
   if dynalight then  begin  //dynamic lightmap coming from mouse pointer
    px:=round((lx+50)*mform.ClientWidth/(500*aspect));
    py:=round((ly-450)*(mform.ClientHeight-1)/-500);
    if mx>=px then
     dx:=5/(h/(mx-px)+0.3)
    else
     dx:=-5/(h/(px-mx)+0.3);
    if my>=py then
     dy:=-5/(h/(my-py)+0.3)
    else
     dy:=5/(h/(py-my)+0.3);
    end
   else            //fixed lightmap
    begin
    dx:=6; dy:=7;
    end;

   glDisable(GL_DEPTH_TEST);
   glEnable(GL_BLEND);
   glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_modulate);
   glBindTexture(GL_TEXTURE_2D, lmap);
   glColor4f(1.0,1.0,1.0,0.1);
   glBegin(GL_QUADS);
   glTexCoord2f(0, 1); glVertex3f(-22+dx,-22+dy,10);
   glTexCoord2f(0, 0); glVertex3f(-22+dx,22+dy,10);
   glTexCoord2f(1, 0); glVertex3f(22+dx,22+dy,10);
   glTexCoord2f(1, 1); glVertex3f(22+dx,-22+dy,10);
   glEnd;
   glDisable(GL_BLEND);
   glEnable(GL_DEPTH_TEST);
   end;
 glpopmatrix;

 if dynalight then begin
 vx:= mx*(500*aspect-50+50)/mform.clientwidth -50;
 vy:= my*(-500/(mform.clientheight-1)) +450;

 gldisable(GL_DEPTH_TEST);
 glenable(GL_BLEND);
 glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_modulate);
 glBindTexture(GL_TEXTURE_2D, lmap);
 glColor4f(1.0,1.0,1.0,0.05);
 glBegin(GL_QUADS);
 glTexCoord2f(0, 1); glVertex3f(-100+vx,-100+vy,10);
 glTexCoord2f(0, 0); glVertex3f(-100+vx,100+vy,10);
 glTexCoord2f(1, 0); glVertex3f(100+vx,100+vy,10);
 glTexCoord2f(1, 1); glVertex3f(100+vx,-100+vy,10);
 glEnd;
 gldisable(GL_BLEND);
 glenable(GL_DEPTH_TEST);
 end;

 glFinish;
 SwapBuffers(DC);
 frametime:=gettickcount-starttime;
 rotang:=rotang+(frametime/1000)*10; //10 units per second
 lz:=lz+rotang;
 if lz>-0.12 then lz:=-0.11;
 Application.ProcessMessages;
until (not animate) or (lz>=-0.12);
animate:=false;
board[y, x]:= color;
drawboard;
popping:=false;
end;

procedure initgame;
var x,y:byte;
begin
blackc:=2; whitec:=2;
for y:=0 to 7 do
 for x:=0 to 7 do
  board[x,y]:=0;
popup(3,3,white);
popup(4,4,white);
popup(4,3,black);
popup(3,4,black);
end;


procedure TmForm.FormCreate(Sender: TObject);
begin
if not InitOpenGL then halt(1);
DC:= GetDC(handle);
HRC:= CreateRenderingContext(DC,[opDoubleBuffered],32,0);
ActivateRenderingContext(DC,HRC);
SetupGL(clientWidth, clientHeight);

blackc:=2; whitec:=2;
mx:=clientwidth div 2;
my:=clientheight div 2;
initex;
initdisks;
BuildFont;
glulookat(0,0,10.1,0,0,-100.01,0,1,0);
StartTimer.Enabled:=true;
end;

procedure TmForm.FormDestroy(Sender: TObject);
begin
DestroyRenderingContext(hrc);
CloseOpenGL;
end;

procedure TmForm.StartTimerTimer(Sender: TObject);
begin
StartTimer.Enabled:=false;
initgame;
end;

procedure TmForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
animate:=false;
KillFont;
Action:=caFree;
end;


procedure TmForm.FormPaint(Sender: TObject);
begin
 drawboard;
end;

procedure CalcScore;
var i,j: integer;
begin
blackc:= 0;
whitec:= 0;
for i:=0 to 7 do
 for j:=0 to 7 do begin
  if (board[j,i] = 1) then inc(whitec);
  if (board[j,i] = 2) then inc(blackc);
  end;
end;

function DoMove(cc:byte; cx, cy: integer; check: boolean): integer;
//------------------------------------------------------------------
// Author: Roman Podobedov
// Email: romka@ut.ee
// http://romka.demonews.com
//
// Delphi translation by vlad@ifrance.com       10.2000
// http://arrowsoft.ifrance.com
//------------------------------------------------------------------
// Does a move
// Parameters: cx, cy - move coordinates
//             cc - who moves
//             if (cc == 0) white moves
//             if (cc == 1) black moves
//	       check - TRUE if only check for move
//		     - FALSE check this move and do it
// Return: 0 - if move impossible
//         1..? - if move possible and do this move

var	test, passed: boolean;
	i, j: integer;

begin
if cc= 0 then begin  //white
 wc1:= 2;
 wc2:= 1;
 end
else begin
 wc1:= 1;
 wc2:= 2;
 end;

if (board[cy, cx] <> 0) then result:= 0
else begin
passed:= FALSE;
test:= FALSE;
for i:=cx-1 downto 0 do // Check left
 begin
 if (board[cy, i]= wc1) then test:= TRUE
 else
  if ((board[cy, i]= wc2) and (test)) then begin
   passed:= TRUE;
   if not check then
    for j:=cx-1 downto i+1 do board[cy, j]:= 3;
   break;
   end
  else break;
 end;

test:= FALSE;
for i:=cx+1 to 7 do // Check Right
 begin
 if (board[cy, i]= wc1) then test:= TRUE
 else
  if ((board[cy, i]= wc2) and (test)) then begin
   passed:= TRUE;
   if not check then
    for j:=cx+1 to i-1 do board[cy, j]:= 3;
   break;
   end
  else break;
 end;

test:= FALSE;
for i:=cy-1 downto 0 do begin// Check Up
 if (board[i, cx]= wc1) then test:= TRUE
 else
  if ((board[i, cx]= wc2) and (test)) then begin
   passed:= TRUE;
   if not check then
    for j:=cy-1 downto i+1 do board[j, cx]:= 3;
   break;
   end
  else break;
 end;

test:= FALSE;
for i:=cy+1 to 7 do begin// Check Down
 if (board[i, cx]= wc1) then test:= TRUE
 else
  if ((board[i, cx]= wc2) and (test)) then begin
   passed:= TRUE;
   if not check then
    for j:=cy+1 to i-1 do board[j, cx]:= 3;
   break;
   end
  else break;
 end;

test:= FALSE;
for i:=1 to 7 do begin// Check Left-Up
 if (((cy-i) >= 0) and ((cx-i) >= 0)) then
  if (board[cy-i, cx-i]= wc1) then test:= TRUE
  else
   if ((board[cy-i, cx-i]= wc2) and (test)) then begin
    passed:= TRUE;
    if not check then
     for j:=1 to i-1 do board[cy-j, cx-j]:= 3;
    break;
    end
   else break
 else break;
 end;

test:= FALSE;
for i:=1 to 7 do begin// Check Left-Down
 if (((cy+i) < 8) and ((cx-i) >= 0)) then
  if (board[cy+i, cx-i]= wc1) then test:= TRUE
  else
   if ((board[cy+i, cx-i]= wc2) and (test)) then begin
    passed:= TRUE;
    if not check then
     for j:=1 to i-1 do board[cy+j, cx-j]:= 3;
    break;
    end
   else break
 else break;
 end;

test:= FALSE;
for i:=1 to 7 do begin// Check Right-Up
 if (((cy-i) >= 0) and ((cx+i) < 8)) then
  if (board[cy-i, cx+i]= wc1) then test:= TRUE
  else
   if ((board[cy-i, cx+i]= wc2) and (test)) then begin
    passed:= TRUE;
    if not check then
     for j:=1 to i-1 do board[cy-j, cx+j]:= 3;
    break;
    end
   else break
 else break;
 end;

test:= FALSE;
for i:=1 to 7 do begin// Check Right-Down
 if (((cy+i) < 8) and ((cx+i) < 8)) then
  if (board[cy+i, cx+i]= wc1) then test:= TRUE
  else
   if ((board[cy+i, cx+i]= wc2) and (test)) then begin
    passed:= TRUE;
    if not check then
     for j:=1 to i-1 do board[cy+j, cx+j]:= 3;
    break;
    end
   else break
 else break;
 end;

if passed and (not check) then begin         //popup
 popup(cx, cy, wc2);
 rotation;
 end;

if not check then
 for i:=0 to 7 do
  for j:=0 to 7 do
   if (board[i, j]> 2) then board[i, j]:= wc2;

if not check then begin
 CalcScore;
 drawboard;
 end;

if passed then result:= 1
else result:= 0;
end;
end;

procedure TmForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var vx, vy:integer;
    cx, cy, i, j:integer;
    temp: word;
    CanMove: boolean;

begin
if not animate then begin
vx:= round(x*(500*aspect-50+50)/clientwidth -50);
vy:= round(y*(-500/(clientheight-1)) +450);
//caption:=inttostr(vx)+'   '+inttostr(vy);//

if (vx>=460) and (vx<=563) and (vy<=307) and (vy>=269) then begin
 bpressed:=true;
 initgame;
 end;

if (vx>=466) and (vx<=558) and (vy<=249) and (vy>=228) then begin
 dynalight:=not dynalight;
 drawboard;
 end;

if (vx>=0) and (vx<400) and (vy>=0) and (vy<400) and not moving then //clicked on board..
 begin
 moving:= TRUE;
 cx:=vx div 50; //coords on board (0..7)
 cy:=7- vy div 50;

 if DoMove(1, cx, cy, CHECK_AND_DO) <> 0 then    //player made move
  repeat
  temp:= DoStep(@board);                     // and now computer's turn
  if temp <> 65535 then begin
   DoMove(0, temp and 255, temp shr 8, CHECK_AND_DO);
   CanMove:= FALSE;                      //player can move?
   for i:=0 to 7 do begin
    for j:=0 to 7 do
     if DoMove(1, j, i, CHECK_ONLY) <> 0 then begin
      CanMove:= TRUE;
      break;
      end;
    if CanMove then break;
    end;
   end
  else CanMove:=TRUE;
  until CanMove;

 moving:= FALSE;
 end;
end;
end;

procedure TmForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
begin
if bpressed then begin
  bpressed:= false;
  drawboard;
 end;
end;


procedure TmForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key=#27 then close;
end;

procedure TmForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
mx:=x; my:=y;
if (not animate) and dynalight then drawboard;
end;

end.
