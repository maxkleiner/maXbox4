unit bossUnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, ExtCtrls, StdCtrls, Grids, Menus;

type
  TForm1Boss = class(TForm)
    panStatus: TPanel;
    panZug: TPanel;
    panImg1: TPanel;
    panSchritt: TPanel;
    img1: TImage;
    sg: TStringGrid;
    drG: TDrawGrid;
    rgInit: TRadioGroup;
    opDlg: TOpenPictureDialog;
    btnNewGame: TButton;
    btnCancel: TButton;
    btnNewPic: TButton;
    btnClose: TButton;
    btnToggel: TButton;

    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnSG: TButton;
    procedure btnNewPicClick(Sender: TObject);
    procedure drGDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnToggelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewGameClick(Sender: TObject);
    procedure drGClick(Sender: TObject);
    procedure btnSGClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TField = array[0..5,0..5] of String;

var
  Form1Boss: TForm1Boss;
  bArr: Array[1..16] of TBitmap;
  Zug: integer;
  Field, zField: TField;  //Feldbelegung, Zielfeld

  dir: array[1..4,1..2] of integer = (
    ( 0,-1), //N
    ( 1, 0), //O
    ( 0, 1), //S
    (-1, 0)  //W
  );  //Richtungsvektoren im Spielfeld (Spalte, Zeile)

implementation
{$R *.dfm}

// ****************************************************************************
// *****  Routinen zur Bildbearbeitung
// ****************************************************************************

procedure OpenPicture(var img: TImage);
//öffnet ein Bild per Dialog und speichert es in "img"
var p: string; bm: TBitMap; aRect: TRect;
begin
  with Form1Boss do begin
    bm:=TBitMap.Create;
    p:=Application.ExeName;
    p:=ExtractFilePath(p);
    opDlg.InitialDir:=p;
    //bm.LoadFromFile(p+'examples\max_locomotion.bmp');

    if opDlg.Execute then begin
      bm.LoadFromFile(opDlg.FileName);
    end;
    //Skalieren der Bitmap bm auf Größe von img1
    aRect:=Rect(0,0,img1.Width,img1.Height);
    img1.Canvas.StretchDraw(aRect, bm);
    bm.Free;
  end;
end;

procedure MakePuzzlePeaces;
//Erstellen der Teilquadrate aus dem Bild und speichern dieser in bArr
var
  i,bhg,bh: integer;
  z,s,z1,s1,z2,s2: integer;
  r1,r2: TRect;
begin
  with Form1Boss do begin
    //Initialisierungen
    bhg:=img1.Picture.Width;
    bh:=bhg div 4;
    for i:=1 to 16 do begin //Größe der Images einstellen!
      bArr[i].Width:=bh; bArr[i].Height:=bh;
    end;

    //Images erstellen durch Kopieren aus dem Quellbild
    for i:=1 to 16 do begin
      //Zeile/Spalte des Rasters bestimmen
      z:=(i-1) div 4 + 1; s:=(i-1) mod 4 + 1;
      s1:=(s-1)*bh; z1:=(z-1)*bh;
      s2:=s*bh; z2:=z*bh;
      //Quadrate unter Berücksichtigung der Ränder definieren
      r1:=Rect(s1+1,z1+1,s2-1,z2-1); //Quellquadrat
      r2:=Rect(1,1,bh-1,bh-1); //Zielquadrat
      with bArr[i].Canvas do begin
        Pen.Color:=RGB(100,100,100);
        Rectangle(0,0,bh,bh);
        CopyRect(r2,img1.Canvas,r1);
      end;
    end;
    //letztes Quadrat weißen
    bArr[16].Canvas.Brush.Color:=clWhite;
    bArr[16].Canvas.FillRect(Rect(1,1,bh-1,bh-1));
  end;
end;  


// ****************************************************************************
// *****  Routinen zur Spielverwaltung
// ****************************************************************************

procedure HideGridCursor(g: TStringGrid); forward;

function maxSteps: integer;
//liefert die Anzahl der Entfernungs-Schritte zur Zielkonstellation
//mit der größtmöglichen Unordnung auf dem Feld
var z,s,sum: integer;
  function max(x,y: integer):integer;
  begin
    if x>=Y then max:=x else max:=y;
  end;
begin
  sum:=0;
  for z:=1 to 4 do
    for s:=1 to 4 do
      sum:=sum + max(z-1,4-z) + max(s-1,4-s);
  maxSteps:=sum;
end;

function Steps(f: TField): integer;
//liefert die Anzahl der Entfernungs-Schritte zur Zielkonstellation
//aus der aktuellen Belegung von f
var 
  s,z,x,y,w1,sum: integer;
  t: string;
begin
  sum:=0;
  for z:=1 to 4 do begin
    for s:=1 to 4 do begin
      t:=f[s,z];
      if t=' ' then t:='16';
      w1:=StrToInt(t); //Zahl auf dem Feld
      x:=abs((((w1-1) mod 4)+1)-s);
      y:=abs((((w1-1) div 4)+1)-z); //Zielposition
      sum:=sum+x+y;
    end;
  end;
  Steps:=sum;
end;

procedure FinishedField;
//erzeugt die Zielbelegung auf zField
var w,z,s: integer;
begin
  for z:=0 to 5 do //Spielfeld löschen
    for s:=0 to 5 do
      zField[s,z]:='#'; //Randbelegung
  w:=0;
  for z:=1 to 4 do
    for s:=1 to 4 do begin
      inc(w);
      zField[s,z]:=IntToStr(w);
    end;
  zField[4,4]:=' ';
end;

function RandomField:TField;
//neue Zufallsbelegung für Field
var
  f0: TField;
  f,f1: Array[1..16] of string;
  free: Array[1..16] of boolean;
  i,z,s,w: integer;
begin
  randomize;
  for i:=1 to 15 do f[i]:= IntToStr(i);
  f[16]:=' ';
  for i:=1 to 16 do free[i]:= true;
  w:=0;
  repeat //Zufallsbelegung in Linearfeld
    repeat
      z:=random(16)+1;
    until free[z];
    inc(w);
    f1[w]:=f[z];
    free[z]:=false;
  until w=16;
  w:=0;
  for z:=1 to 4 do //Belegung übernehmen
    for s:=1 to 4 do begin
      inc(w);
      f0[s,z]:=f1[w];
    end;
  RandomField:=f0;
end;

function ShuffleField(zf: TField; steps: integer):TField;
//Durchmischen des Spielfeldes per Zufallsschieben mit steps Schritten
type
  TPos = record s,z: integer; end;
var
  st: integer; pf,p1,p2: TPos;
  f: TField;
  
  function GetFreeCell: TPos;
  //gibt Koordinaten der freien Nachbarzelle zufück
  var
    p: TPos; s,z: integer;
  begin
	for z:=1 to 4 do
	  for s:=1 to 4 do
	    if f[s,z]=' ' then begin
		  p.s:=s; p.z:=z;
		end;
	GetFreeCell:=p;
  end;

  function IsCell(p: TPos; d: integer):boolean;
  //ermittelt, ob es sich um eine gültige Zelle handelt
  var dx,dy: integer; isFree: boolean;
  begin
    isFree:=false;
    dx:=p.s+dir[d,1]; dy:=p.z+dir[d,2];
    if (dx>0) and (dx<5) and (dy>0) and (dy<5) then isFree:=true;
    IsCell:=isFree;
  end;

  function RandomStep(p: TPos; n: integer):TPos;
  //zählt das n-te Feld ab im Uhrzeigersinn
  //unter Beachtung der Freiheit der Zellen
  //gibt die Position des Zielfeldes zurück
  var di: integer; tp: TPos;
  begin
    di:=3;
    repeat
      di:=(di+1) mod 4;
      if IsCell(p,di+1) then dec(n);
    until n=0;
    tp.s:=p.s+dir[di+1,1]; tp.z:=p.z+dir[di+1,2];
    RandomStep:=tp;
  end;

begin
  randomize;
  f:=zf;
  pf:=GetFreeCell;
  for st:=1 to steps do begin
    p1:=RandomStep(pf,random(4)+1);
    f[pf.s,pf.z]:=f[p1.s,p1.z];
    f[p1.s,p1.z]:=' ';
    p2:=pf; pf:=p1; p2:=p2; //Feldertausch
  end;
  ShuffleField:=f;
end;

procedure DrawField(f: TField);
//Ausgabe von Field im StringGrid
var
  z,s: integer;
begin
  for z:=1 to 4 do
    for s:=1 to 4 do begin
      Form1boss.sg.Cells[s-1,z-1]:=f[s,z];
    end;
  Form1boss.panZug.Caption:=IntToStr(Zug);
  HideGridCursor(Form1boss.sg);
end;

function GetFreeDir(x,y: integer): integer;
//ermittelt die freie Richtung und gibt zurück:
//0...kein Nachbar frei; 1-4 für N/O/S/W
var
 d,fd: integer;
begin
  fd:=0;
  for d:=1 to 4 do begin //alle Richtungen kontrollieren
    if Field[x+dir[d,1],y+dir[d,2]]=' ' then fd:=d;
  end;
  GetFreeDir:=fd;
end;

function HasFinished: boolean;
//gibt wahr zurück, wenn Spielende erreicht ist
var
  finished: boolean;
  z,s: integer;
begin
  finished:=true;
  for z:=1 to 4 do
    for s:=1 to 4 do
      if Field[s,z]<>zField[s,z] then finished:=false;
  HasFinished:=finished;
end;


// ****************************************************************************
// *****  Routinen zur Programmverwaltung
// ****************************************************************************

procedure HideGridCursor(g: TStringGrid);
//Cursor aus dem StringGrid entfernen
var gr: TGridRect;
begin
  with gr do begin
    Top:=-1; Left:=-1; Right:=-1; Bottom:=-1
  end;
  g.Selection:=gr;
end;

procedure TForm1Boss.FormCreate(Sender: TObject);
//Images initialisieren
var i: integer;
begin
  for i:=1 to 16 do bArr[i]:=TBitMap.Create;
  HideGridCursor(sg);
  panImg1.DoubleBuffered := true;
end;

procedure TForm1Boss.btnNewPicClick(Sender: TObject);
//Bild öffnen
begin
  OpenPicture(img1);
  drG.Visible:=false;
  MakePuzzlePeaces;
  FinishedField;
  Field:=zField;
  DrawField(zField);
  drG.Visible:=True;
  btnNewGame.Enabled:=True;
  btnCancel.Enabled:=True;
  btnToggel.Enabled:=True;
end;

procedure TForm1Boss.btnNewGameClick(Sender: TObject);
//Neues Spiel initialisieren
var p: real;
begin
  Field:=zField;
  if rgInit.ItemIndex=0
    then Field:=RandomField
    else Field:=ShuffleField(ZField,350);
  Zug:=1;
  p:=100-Steps(Field)/MaxSteps*100;
  panSchritt.Caption:=formatfloat('0',p)+' %';
  drG.Repaint;
  DrawField(Field);
  HideGridCursor(sg);
  panStatus.Caption:='Game is running ...';
  panStatus.Color:=$00804000;
  btnNewPic.Enabled:=false;
end;

procedure TForm1Boss.drGClick(Sender: TObject);
//nächster Spielzug bei Klick auf eine Zelle
var
  x,y,x1,y1,d: integer;
  p: real;
  w: String;
begin
  panStatus.Color:=$00804000;
  x:=drG.Col+1; y:=drG.Row+1;
  d:=GetFreeDir(x,y);
  if d>0 then begin //es gibt eine freie Nachbarzelle
    x1:=x+dir[d,1]; y1:=y+dir[d,2];
    w:=Field[x,y]; Field[x,y]:=Field[x1,y1]; Field[x1,y1]:=w;
    inc(Zug);
    p:=100-Steps(Field)/MaxSteps*100;
    panSchritt.Caption:=formatfloat('0',p)+' %';
    DrawField(Field);
    drG.Repaint;
  end;
  if HasFinished then begin
    panStatus.Caption:='End of Game!!!';
    panStatus.Color:=clGreen;
  end;
end;

procedure TForm1Boss.drGDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
//Zeichenroutine für das DrawGrid
var nr: integer; t: string;
begin
  with Sender as TDrawGrid do begin
    t:=Field[ACol+1,ARow+1];
    if t=' ' then nr:=16 else nr:=StrToInt(t);
    Canvas.Draw(Rect.Left, Rect.Top, bArr[nr]);
  end;
end;

procedure TForm1Boss.btnCancelClick(Sender: TObject);
//Spielabbruch, Zielbelegung anzeigen
begin
  FinishedField;
  Zug:=1;
  Field:=zField;
  DrawField(Field);
  drG.Repaint;
  panStatus.Caption:='Game Situation';
  panSchritt.Caption:='0';
  btnNewPic.Enabled:=true;
end;

procedure TForm1Boss.btnToggelClick(Sender: TObject);
//Umschaltung Spiel - Bild (Vorschau)
begin
  if btnToggel.Caption='to Picture' then begin
    drG.Visible:=false;
    btnToggel.Caption:='to Game';
  end else begin
    drG.Visible:=true;
    drG.Repaint;
    btnToggel.Caption:='to Picture';
  end;
  HideGridCursor(sg);
end;

procedure TForm1Boss.btnSGClick(Sender: TObject);
//Ein-/Ausblenden des StrinGrids
begin
  if sg.Visible=true
    then sg.Visible:=false else sg.Visible:=true;
end;

procedure TForm1Boss.btnCloseClick(Sender: TObject);
//Programmende
begin
  Close;
end;

procedure TForm1Boss.FormDestroy(Sender: TObject);
var i: integer;
begin
  //Images freigeben
  for i:=1 to 16 do bArr[i].Free;
end;

end.
