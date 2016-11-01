unit game_astro_mx;

interface

{uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Math, MPlayer;
 }
 
//type
  //TForm1 = class(TForm)
  
  CONST MEDIAPATH = 'C:\maXbox\maxbox3\work2015\Cygwin\space-invader\astroids';
  
  var
    Timer1: TTimer;
    PaintBox1: TPaintBox;
    MediaPlayer1: TMediaPlayer;
    MediaPlayer2: TMediaPlayer;
    MediaPlayer3: TMediaPlayer;
    MediaPlayer4: TMediaPlayer;
       procedure TForm1Timer1Timer(Sender: TObject);
       procedure TForm1tastatur;
       procedure TForm1Malen;
       procedure TForm1Berechne;
       procedure TForm1FormCreate(Sender: TObject);
       procedure astro0;
       procedure astro1;
       procedure astro2;
       procedure astro3;


  //private
    { Private-Deklarationen }
  //public
    { Public-Deklarationen }
  //end;

var
 devmode,dd,zz:TDevMode;
  d:integer;
  dc:hdc;
  scrx,scry,farb:integer;

  Form1: TForm;
  i,kurs,beschl,pos,astpos,e,hit,klar,tzeit,ex,ey,punkte,w: integer;
  x,y,vx,vy,alpha,a,b:extended;
  qc,qs:array[0..35] of extended;
  feuer,anders,schub,au,no,mstart,paus:boolean;
  schirm,exlpo:tBitmap;
  bild:array[0..35] of Tbitmap;
  sx,sy:array[1..200] of integer;
  astx,asty,astvx,astvy:array[1..100] of extended;
  astkurs,asttyp:array[1..75] of integer;
  fvx,fvy,fx,fy:array[1..15] of extended;
  fexist:array[1..15] of boolean;
  fzeit:array[1..15] of integer;
  ast:array[0..3] of tbitmap;
  leben:byte;
  
  

implementation

//{$R *.DFM}

procedure TForm1Timer1Timer(Sender: TObject);
begin
if mstart=true
then
begin
mstart:=false;
Mediaplayer4.Play;
end;

if Mediaplayer4.Position>Mediaplayer4.length-10
then
Mediaplayer4.Play;

      
if getasynckeystate(27)<>0
then
begin
   //changedisplaySettings(Tdevmode(zz),0);
  form1.close;

end;
if getasynckeystate(19)<>0
then
begin
if paus=false
then
paus:=true
else
paus:=false;
end;

 if paus=false
      then

 begin
if no=false
then
TForm1tastatur;
TForm1berechne;
TForm1malen;
   end;


end;


procedure Tform1Tastatur;
begin

if w<9
then
inc(w);


if getasynckeystate(37)<>0
then
dec(kurs);


if getasynckeystate(38)<>0
then
if w=9
then
begin
feuer:=true;
    w:=0;
end;

if getasynckeystate(39)<>0
then
inc(kurs);

if getasynckeystate(40)<>0
then
begin
beschl:=1;
schub:=true;
Mediaplayer1.play;
end;

if kurs<0
then
kurs:=35;

if kurs>35
then
kurs:=0;



end;


Procedure Tform1Malen;
begin
schirm.canvas.brush.color:=clblack;
schirm.canvas.pen.color:=clblack;
schirm.canvas.fillrect(rect(0,0,schirm.width,schirm.height));



For i:=1 to 200 do
schirm.canvas.pixels[sx[i],sy[i]]:=clwhite;

for i:=1 to 15 do
if fexist[i]=true
then
begin
schirm.canvas.pixels[round(fx[i]+1),round(fy[i])]:=Clred;
schirm.canvas.pixels[round(fx[i]),round(fy[i]+1)]:=Clred;
schirm.canvas.pixels[round(fx[i]-1),round(fy[i])]:=Clred;
schirm.canvas.pixels[round(fx[i]),round(fy[i]-1)]:=Clred;
schirm.canvas.pixels[round(fx[i]),round(fy[i])]:=Clred;
end;
       if no=false
then
begin
if schub=true
then
begin   
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clred;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clred;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clred;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clred;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clred;

schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clyellow;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clyellow;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clyellow;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clyellow;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clyellow;

schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clpurple;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clpurple;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clpurple;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clpurple;
schirm.canvas.pixels[round(x-15*qs[kurs])+random(9)-4,round(y+15*qc[kurs])+random(9)-4]:=clpurple;

schub:=false;
end;


schirm.canvas.draw(round(x-12),round(y-12),bild[kurs]);
end;


if tzeit<25
then
schirm.canvas.stretchdraw(Rect(ex-tzeit,ey-tzeit,ex+tzeit,ey+tzeit),exlpo);

for i:=1 to 75 do
case asttyp[i] of
0:schirm.canvas.draw(round(astx[i]-40),round(asty[i]-40),ast[0]);
1:schirm.canvas.draw(round(astx[i]-20),round(asty[i]-20),ast[1]);
2:schirm.canvas.draw(round(astx[i]-10),round(asty[i]-10),ast[2]);
3:schirm.canvas.draw(round(astx[i]-5),round(asty[i]-5),ast[3]);
end;
schirm.canvas.font.size:=10;
schirm.canvas.font.color:=clred;
schirm.canvas.TextOut(5,5,'LIVES : '+inttostr(leben));
schirm.canvas.TextOut(700,5,'SCORE : '+inttostr(punkte));


if leben=0
then
begin
schirm.canvas.font.size:=25;
schirm.canvas.font.color:=clred;
schirm.canvas.TextOut(300,280,'GAME OVER!');
end;

if punkte=1500
then
begin
schirm.canvas.font.size:=25;
schirm.canvas.font.color:=clred;
schirm.canvas.TextOut(300,280,'YOU HAVE WON!');
end;


Paintbox1.canvas.draw(0,0,schirm);
end;


procedure Tform1Berechne;
begin

if punkte=1225
then
punkte:=1500;

if punkte=1500
then
feuer:=false;

vx:=vx+qs[kurs]*beschl;
vy:=vy-qc[kurs]*beschl;

if vx>0
then
vx:=vx-sqr(vx/20);

if vy>0
then
vy:=vy-sqr(vy/20);

if vx<0
then
vx:=vx+sqr(vx/20);

if vy<0
then
vy:=vy+sqr(vy/20);

beschl:=0;
x:=x+vx;
y:=y+vy;

if x<15
then
begin
x:=15;
vx:=vx*-1;
end;

if y<15
then
begin
y:=15;
vy:=vy*-1;
end;

if x>785
then
begin
x:=785;
vx:=vx*-1;
end;

if y>585
then
begin
y:=585;
vy:=vy*-1;
end;



if feuer=true
then
begin

feuer:=false;
if fexist[pos]=false
then
begin
mediaplayer3.play;
fx[pos]:=x+10*qs[kurs];
fy[pos]:=y-10*qc[kurs];
fvx[pos]:=10*qs[kurs];
fvy[pos]:=-10*qc[kurs];
fzeit[pos]:=1;
fexist[pos]:=true;
inc(pos) ;
if pos=16
then
pos:=1;
end;
end;

for i:=1 to 15 do
if fexist[i]=true
then
begin
fx[i]:=fx[i]+fvx[i];
fy[i]:=fy[i]+fvy[i];
inc(fzeit[i]);




if fx[i]<5
then
begin
fx[i]:=5;
fvx[i]:=fvx[i]*-1;
end;

if fy[i]<5
then
begin
fy[i]:=5;
fvy[i]:=fvy[i]*-1;
end;

if fx[i]>795
then
begin
fx[i]:=795;
fvx[i]:=fvx[i]*-1;
end;

if fy[i]>595
then
begin
fy[i]:=595;
fvy[i]:=fvy[i]*-1;
end;

if sqr(fx[i]-x)+sqr(fy[i]-y)<100
then
begin
au:=true;
fexist[i]:=false;
end;

if fzeit[i]=100
then
fexist[i]:=false;



end;


for i:=1 to 75 do
begin
case asttyp[i] of
0:astro0;
1:astro1;
2:astro2;
3:astro3;
end;

end;




    if au=true
    then
    begin
    au:=false;

   if no=false
   then
   begin
   dec(leben);
   Tzeit:=0;
   ex:=round(x);
   ey:=round(y);
   Mediaplayer2.play;
   end;
   feuer:=false;
   x:=400;
   y:=300;
   vx:=0;
   vy:=0;
   kurs:=0;
   no:=false;
for i:=1 to 75 do
if asttyp[i]<>-1
then
if sqr(astx[i]-400)+sqr(asty[i]-300)<5000
then
no:=true;

    end;


     if no=true
     then
     begin

      klar:=0;
      for i:=1 to 75 do
      begin
      if asttyp[i]<>-1
      then
      begin
      if sqr(astx[i]-400)+sqr(asty[i]-300)>5000
      then
      inc(klar)
      end
      else
      inc(klar);
       end;


            if klar=75
            then
            no:=false;
        end;

if tzeit<25
then
begin
inc(tzeit);
no:=true;
end;

        if leben=0
        then
        begin
        no:=true;
        end;

end;


procedure TForm1FormCreate(Sender: TObject);
begin

dc:=getdc(0);
farb:=1 shl getdevicecaps(dc, Bitspixel);
releaseDC(0,dc);
scrx:=screen.width;
scry:=screen.height;


devmode.dmsize:=Sizeof(Devmode);
devmode.dmdriverextra:=0;
d:=0;


while EnumDisplaySettings('nil',d,devmode)  do begin

inc(d);
if (devmode.dmpelswidth=800) and (devmode.dmpelsheight=600) and ((1 shl devmode.dmbitsperpel)=65536)
then
begin
dd:=devmode;
end;

if (devmode.dmpelswidth=scrx) and (devmode.dmpelsheight=scry) and ((1 shl devmode.dmbitsperpel)=farb)
then
begin
zz:=devmode;
end;

end;

  //changedisplaySettings(Tdevmode(dd),0);



 MediaPlayer1.FileName :=MEDIAPATH+'\sounds\engine.wav';
 MediaPlayer1.DeviceType:=dtWaveAudio;
 Mediaplayer1.Open;

  MediaPlayer2.FileName :=MEDIAPATH+'\sounds\explosion.wav';
 MediaPlayer2.DeviceType:=dtWaveAudio;
 Mediaplayer2.Open;

  MediaPlayer3.FileName :=MEDIAPATH+'\sounds\fire.wav';
 MediaPlayer3.DeviceType:=dtWaveAudio;
 Mediaplayer3.Open;

   MediaPlayer4.FileName :=MEDIAPATH+'\sounds\music.wav';
 MediaPlayer4.DeviceType:=dtWaveAudio;
 Mediaplayer4.Open;   
               mstart:=true;

punkte:=0;
tzeit:=30;
no:=false;
leben:=5;
au:=false;
randomize;
       schub:=false;
x:=400;
y:=300;
kurs:=0;
vx:=0;
vy:=0;
beschl:=0;
feuer:=false;

for i:=0 to 35 do begin
qs[i]:=sin(i*PI/18);
qc[i]:=cos(i*PI/18);

bild[i]:=Tbitmap.create;
bild[i].loadfromfile(MEDIAPATH+'\images\ship'+inttostr(i*10)+'.bmp');
bild[i].Transparent:=true;
bild[i].TransParentColor:= bild[i].canvas.pixels[0,0];
bild[i].TransparentMode := tmAuto;
     end;
               paus:=false;
     exlpo:=tbitmap.create;
     exlpo.loadfromfile(MEDIAPATH+'\images\explosion.bmp');
exlpo.Transparent:=true;
exlpo.TransParentColor:= clBlack;
exlpo.TransparentMode := tmAuto;

 for i:=0 to 3 do
 begin
ast[i]:=Tbitmap.create;
ast[i].loadfromfile(MEDIAPATH+'\images\ast'+inttostr(i)+'.bmp');
ast[i].Transparent:=true;
ast[i].TransParentColor:= ast[i].canvas.pixels[0,0];
ast[i].TransparentMode := tmAuto;
 end;

For i:=1 to 200 do begin
sx[i]:=random(800);
sy[i]:=random(600);
end;


for i:=0 to 255 do
if getasynckeystate(i)<>0
then
pos:=0;


i:=1;
repeat
asttyp[i]:=-1;
astkurs[i]:=-1;
astx[i]:=random(700)+50;
asty[i]:=random(500)+50;
astvx[i]:=random(11)-5;
astvy[i]:=random(11)-5;

if sqr(astx[i]-400)+sqr(asty[i]-300)>10000
then
inc(i);
until i=76;



for i:=1 to 5 do
begin
asttyp[i]:=0;
end;
astpos:=6;


for i:=1 to 10 do begin
fx[i]:=0;
fy[i]:=0;
fvx[i]:=0;
fvy[i]:=0;
fzeit[i]:=0;
fexist[i]:=false;
end;
              w:=0;
schirm:=Tbitmap.create;
schirm.width:= form1.clientwidth;
schirm.height:= form1.clientHeight;
schirm.canvas.brush.color:=clblack;
schirm.canvas.pen.color:=clblack;
schirm.canvas.fillrect(rect(0,0,schirm.width,schirm.height));
                   pos:=1;
end;




    procedure astro0;
    begin
astx[i]:=astx[i]+astvx[i];
asty[i]:=asty[i]+astvy[i];

anders:=false;
for e:=1 to 15 do
if fexist[e]=true
then
if sqr(astx[i]-fx[e])+sqr(asty[i]-fy[e])<1600
then
begin
anders:=true;
fexist[e]:=false;
fzeit[e]:=100;
hit:=e;
end;

if anders=true
then
begin
asttyp[i]:=-1;
b:=(fy[hit]-asty[i]);
a:=(fx[hit]-astx[i]);
alpha:=ArcTan2(b,a);
alpha:=(alpha*18/PI)-9;
punkte:=punkte+5;
Mediaplayer2.play;
if alpha<0
then
alpha:=alpha+36;
if alpha>35
then
alpha:=alpha-36;
if alpha<0
then
alpha:=alpha+36;
if alpha>35
then
alpha:=alpha-36;


asttyp[astpos]:=1;
astx[astpos]:=astx[i]-qc[round(alpha)]*21;
asty[astpos]:=asty[i]+qs[round(alpha)]*21;
astvx[astpos]:=astvx[i]-qc[round(alpha)];
astvy[astpos]:=astvy[i]+qs[round(alpha)];


inc(astpos);
asttyp[astpos]:=1;
astx[astpos]:=astx[i]+qc[round(alpha)]*21;
asty[astpos]:=asty[i]-qs[round(alpha)]*21;
astvx[astpos]:=astvx[i]+qc[round(alpha)];
astvy[astpos]:=astvy[i]-qs[round(alpha)];


inc(astpos);
end;


if astx[i]<45
then
begin
astx[i]:=45;
astvx[i]:=astvx[i]*-1;
end;

if asty[i]<45
then
begin
asty[i]:=45;
astvy[i]:=astvy[i]*-1;
end;

if astx[i]>755
then
begin
astx[i]:=755;
astvx[i]:=astvx[i]*-1;
end;

if asty[i]>555
then
begin
asty[i]:=555;
astvy[i]:=astvy[i]*-1;
end;


if sqr(astx[i]-x)+sqr(asty[i]-y)<2500
then
au:=true;




    end;

    procedure astro1;
      begin

astx[i]:=astx[i]+astvx[i];
asty[i]:=asty[i]+astvy[i];




anders:=false;
for e:=1 to 15 do
if fexist[e]=true
then
if sqr(astx[i]-fx[e])+sqr(asty[i]-fy[e])<400
then
begin
anders:=true;
fexist[e]:=false;
fzeit[e]:=100;
hit:=e;
end;

if anders=true
then
begin
asttyp[i]:=-1;
b:=(fy[hit]-asty[i]);
a:=(fx[hit]-astx[i]);
alpha:=ArcTan2(b,a);
alpha:=(alpha*18/PI)-9;
punkte:=punkte+10;
Mediaplayer2.play;
if alpha<0
then
alpha:=alpha+36;
if alpha>35
then
alpha:=alpha-36;
if alpha<0
then
alpha:=alpha+36;
if alpha>35
then
alpha:=alpha-36;


asttyp[astpos]:=2;
astx[astpos]:=astx[i]-qc[round(alpha)]*11;
asty[astpos]:=asty[i]+qs[round(alpha)]*11;
astvx[astpos]:=astvx[i]-qc[round(alpha)];
astvy[astpos]:=astvy[i]+qs[round(alpha)];


inc(astpos);
asttyp[astpos]:=2;
astx[astpos]:=astx[i]+qc[round(alpha)]*11;
asty[astpos]:=asty[i]-qs[round(alpha)]*11;
astvx[astpos]:=astvx[i]+qc[round(alpha)];
astvy[astpos]:=astvy[i]-qs[round(alpha)];


inc(astpos);
end;




if astx[i]<25
then
begin
astx[i]:=25;
astvx[i]:=astvx[i]*-1;
end;

if asty[i]<25
then
begin
asty[i]:=25;
astvy[i]:=astvy[i]*-1;
end;

if astx[i]>775
then
begin
astx[i]:=775;
astvx[i]:=astvx[i]*-1;
end;

if asty[i]>575
then
begin
asty[i]:=575;
astvy[i]:=astvy[i]*-1;
    end;


if sqr(astx[i]-x)+sqr(asty[i]-y)<900
then
au:=true;

    end;

    procedure astro2;
      begin
 
astx[i]:=astx[i]+astvx[i];
asty[i]:=asty[i]+astvy[i];



anders:=false;
for e:=1 to 15 do
if fexist[e]=true
then
if sqr(astx[i]-fx[e])+sqr(asty[i]-fy[e])<100
then
begin
anders:=true;
fexist[e]:=false;
fzeit[e]:=100;
hit:=e;
end;

if anders=true
then
begin
asttyp[i]:=-1;
Mediaplayer2.play;
b:=(fy[hit]-asty[i]);
a:=(fx[hit]-astx[i]);
alpha:=ArcTan2(b,a);
alpha:=(alpha*18/PI)-9;
punkte:=punkte+15;
if alpha<0
then
alpha:=alpha+36;
if alpha>35
then
alpha:=alpha-36;
if alpha<0
then
alpha:=alpha+36;
if alpha>35
then
alpha:=alpha-36;


asttyp[astpos]:=3;
astx[astpos]:=astx[i]-qc[round(alpha)]*6;
asty[astpos]:=asty[i]+qs[round(alpha)]*6;
astvx[astpos]:=astvx[i]-qc[round(alpha)];
astvy[astpos]:=astvy[i]+qs[round(alpha)];


inc(astpos);
asttyp[astpos]:=3;
astx[astpos]:=astx[i]+qc[round(alpha)]*6;
asty[astpos]:=asty[i]-qs[round(alpha)]*6;
astvx[astpos]:=astvx[i]+qc[round(alpha)];
astvy[astpos]:=astvy[i]-qs[round(alpha)];


inc(astpos);
end;



if astx[i]<15
then
begin
astx[i]:=15;
astvx[i]:=astvx[i]*-1;
end;

if asty[i]<15
then
begin
asty[i]:=15;
astvy[i]:=astvy[i]*-1;
end;

if astx[i]>785
then
begin
astx[i]:=785;
astvx[i]:=astvx[i]*-1;
end;

if asty[i]>585
then
begin
asty[i]:=585;
astvy[i]:=astvy[i]*-1;
    end;


    if sqr(astx[i]-x)+sqr(asty[i]-y)<400
then
au:=true;
    end;

    procedure astro3;
      begin

astx[i]:=astx[i]+astvx[i];
asty[i]:=asty[i]+astvy[i];



anders:=false;
for e:=1 to 15 do
if fexist[e]=true
then
if sqr(astx[i]-fx[e])+sqr(asty[i]-fy[e])<25
then begin
anders:=true;
fexist[e]:=false;
fzeit[e]:=100;
hit:=e;
end;

if anders=true
then begin
punkte:=punkte+20;
asttyp[i]:=-1;
Mediaplayer2.play;
end;



if astx[i]<10
then begin
astx[i]:=25;
astvx[i]:=astvx[i]*-1;
end;

if asty[i]<10
then begin
asty[i]:=25;
astvy[i]:=astvy[i]*-1;
end;

if astx[i]>790
then begin
astx[i]:=790;
astvx[i]:=astvx[i]*-1;
end;

if asty[i]>590
then begin
asty[i]:=590;
astvy[i]:=astvy[i]*-1;
end;


 if sqr(astx[i]-x)+sqr(asty[i]-y)<225
then
au:=true;
end;

procedure CloseClick(Sender: TObject; var action: TCloseAction);
var i: integer;
begin
   //if MessageDlg('Wanna Leave?',mtConfirmation,[mbYes, mbNo],0)= mrYes then begin
   //form1.Free; //bmp.Free;
   //for i:= 1 to QB+1 do bArr[i].Free;
   action:= caFree;
   if assigned(timer1) then begin
  timer1.enabled:= false;
  //timer2.enabled:= false;
  timer1.free;
  //timer2.free;
  Mediaplayer1.free;
  Mediaplayer2.free;
  Mediaplayer3.free;
  Mediaplayer4.free;
  
  end;
   writeln('Astro Free and destroy finished');
 //  TForm1_Destroy(self)
   //writeln('Free and Closer test finished');
   //end else
     //Action:= caNone;
end;

procedure SetAForm;
 begin
  form1:= TForm.Create(self);
  with form1 do begin
    Caption:= '********** Astroids Template ***********';  
    height:= 550;
    width:= 636;
    Position:= poScreenCenter;
    FormStyle:= fsStayonTop;
     Left:= 0
  Top:= 0
  Cursor:= crCross
  BorderStyle := bsDialog
  ClientHeight := 600
  ClientWidth := 800
  Color := clBlack
  Font.Charset := DEFAULT_CHARSET
  Font.Color := clWindowText
  Font.Height := -11
  Font.Name := 'MS Sans Serif'
  Font.Style := []
  //Position := poDefaultPosOnly
  //OnCreate = FormCreate
  PixelsPerInch := 96
  //TextHeight = 13
  onclose:= @CloseClick;
  Show;
  end;
    //Color:= clwebGold;
    //keypreview:= true;
    //SetDesignVisible(true);
    //onClose:= @TFrm_closeClick;
    //onPaint:= @TFrm_FormPaint;
    //Canvas.Pen.color:= clBlue;
    //GetControlsAlignment;
    //EnableAutoRange;
    //formstate;
    //ScreenSnap;
    //SnapBuffer;
   PaintBox1:= TPaintBox.create(form1)
   with paintbox1 do begin
   parent:= form1;
    Left := 0
    Top := 0
    Width := 800
    Height := 600
    Align := alClient
  end;
  MediaPlayer1:= TMediaPlayer.create(form1)
  with mediaplayer1 do begin
   parent:= form1;
    Left := 336
    Top := 96
    Width := 253
    Height := 30
    Visible := False
    TabOrder := 0
  end;
  MediaPlayer2:= TMediaPlayer.create(form1)
  with mediaplayer2 do begin
   parent:= form1;
    Left := 352
    Top := 200
    Width := 253
    Height := 30
    Visible := False
    TabOrder := 1
  end;
  MediaPlayer3:= TMediaPlayer.create(form1)
  with mediaplayer3 do begin
   parent:= form1;
    Left := 360
    Top := 160
    Width := 253
    Height := 30
    Visible := False
    TabOrder := 2
  end;
  MediaPlayer4:= TMediaPlayer.create(form1)
  with mediaplayer4 do begin
   parent:= form1;
    Left := 368
    Top := 248
    Width := 253
    Height := 41
    Visible := False
    TabOrder := 3
  end;
  
   TForm1FormCreate(self);
 
  Timer1:= TTimer.create(form1)
  with timer1 do begin
   //parent:= form1;
    Interval := 50
    OnTimer := @Tform1Timer1Timer;
    //Left := 24
    //Top := 24
  end;
 end; 




 var srlist2: TStrings;
   tb: boolean;
    
begin
    
  writeln(itoa(random(20)))
  //LoadDFMFile2Strings(const AFile:string; AStrings:TStrings; var WasText:boolean):integer
  tb:= false;
  srlist2:= TStringlist.create;
  LoadDFMFile2Strings('C:\maXbox\maxbox3\work2015\Cygwin\space-invader\astroids\game.dfm', srlist2, tb);
  writeln(srlist2.text)
  srlist2.free;
  
  SetAForm;
  //TForm1FormCreate(self);
  
  
end.


{object Form1: TForm1
  Left = 0
  Top = 0
  Cursor = crCross
  BorderStyle = bsNone
  Caption = 'Astroids'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poDefaultPosOnly
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 800
    Height = 600
    Align = alClient
  end
  object MediaPlayer1: TMediaPlayer
    Left = 336
    Top = 96
    Width = 253
    Height = 30
    Visible = False
    TabOrder = 0
  end
  object MediaPlayer2: TMediaPlayer
    Left = 352
    Top = 200
    Width = 253
    Height = 30
    Visible = False
    TabOrder = 1
  end
  object MediaPlayer3: TMediaPlayer
    Left = 360
    Top = 160
    Width = 253
    Height = 30
    Visible = False
    TabOrder = 2
  end
  object MediaPlayer4: TMediaPlayer
    Left = 368
    Top = 248
    Width = 253
    Height = 41
    Visible = False
    TabOrder = 3
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 24
    Top = 24
  end
end
}



