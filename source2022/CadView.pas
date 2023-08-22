unit CadView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Variants, ExtCtrls, Buttons, ComCtrls, StdCtrls, DBTables, ppTypes, DB,
  kbmMemTable, kbmMemBinaryStreamFormat, ImgList, ToolWin;

type TPointExt=record
  X,Y:Extended;
end;

type TRectExt=record
  xMin,xMax,yMin,yMax:Extended;
end;

type TUnterprogramm=record
  Name:String;
  Offset,Scale:TPointExt;
  Winkel:Extended;
end;

type
  TFormCadView = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    OpenDialog1: TOpenDialog;
    srcCf2Colors: TDataSource;
    ControlBar1: TControlBar;
    ToolBar1: TToolBar;
    BtnOpen: TToolButton;
    ImageListNormal: TImageList;
    BtnSave: TToolButton;
    BtnPrint: TToolButton;
    BtnColors: TToolButton;
    BtnRotateLeft: TToolButton;
    BtnRotateRight: TToolButton;
    BtnFullSize: TToolButton;
    BtnFitToWindowSize: TToolButton;
    BtnZoomPlus: TToolButton;
    BtnZoomMinus: TToolButton;
    Panel1: TPanel;
    CB1: TComboBox;
    LabelBrettgroesse: TLabel;
    procedure BtnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnFitToWindowSizeClick(Sender: TObject);
    procedure BtnFullSizeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnPrintClick(Sender: TObject);
    procedure ReadFile;
    procedure BtnSaveClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BtnColorsClick(Sender: TObject);
    procedure BtnRotateRightClick(Sender: TObject);
    procedure BtnZoomPlusClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    SL:TStringList; // die einzelnen Zeilen der CF2-Datei
    LT:TStringList; // Linientypen mit Metern
    fProgrammname:String;
    iMainStart,iMain,iSub:Longint;
    z:String;
    fUnterprogramm:TUnterprogramm;
    fScale:TPointExt;     // wird hier nicht berücksichtigt
    fBild:TRectExt;       // Min-Max-Koordinaten (aus Linien, Kreise und Texte)
    fBildGroesse:TPoint;  //
    fBrettGroesse:TPoint; // Größe des Holzbretts in mm
    fShift:TPointExt;     // Vektor um das Objekt in den Windows-Ursprung (0/0) zu verschieben
    fDrehpunkt:TPointExt; // Mittelpunkt des ganzen Objektes (in Originalkoordinaten, also nicht nach 0/0 geshiftet)
    fDrehwinkel:integer;  // Winkel, mit dem das Objekt um seinen Mittelpunkt rotiert
    fZoomfaktor:Extended; // Strechfaktor des Objektes
    fPkt1,fPkt2,fPkt3,fPkt4,fGesamtMeter:Extended; // Summe Millimeter für 2-Punkt, 3-Punkt, 4-Punkt-Lasern. Wird in den Auftrag importiert.
    fPerfaHilfstypNr, fResyHilfstypNr:string; // Hilfstyp-Nummer für Perfa-Type und Resy-Zeichen
    fPerfaCount, fResyCount:integer; // Anzahl Perfa- und Resy-Zeichen. Wird in den Auftrag importiert.
    fPath,fFilename,fFullFilename:String;
    fTable:TTable; // entweder AngATB oder AufATB
    fAction:integer;
    fCaption:string;
    fBssMeterAufrunden:Boolean;
    fHilfstypAktiv:Boolean; // der Hilfslinientyp (das is der dritte Parameter)
    FclBackground, FclText, FclSonstiges:TColor; // notwendige Farben
    FDrawPointage, FDrawZeroPointage, FDrawGaps : Boolean;
    FPrinting:Boolean; // Bitmap wird für Druckausgabe erzeugt und nicht für den Bildschirm
    procedure InitMain;
    procedure InitSubroutine;
    procedure CalcSize;
    function GetString:String;
    function GetValue:Extended;
    procedure ShowFile(aBitmap:TBitmap);
    procedure DatenimportAngebot;
    procedure DatenimportAuftrag;
    procedure Nachkalkulation;
    function GetPenWidth(Pointage:integer):Byte;
    function GetTypColor(aMessertyp:integer):TColor;
    function GetTextColor:TColor;
    procedure GetColorSettings;
    procedure SaveColorSettings;
    procedure SetZoomHints;
  public
    constructor Create (AOwner:TComponent; aTable:TTable; aCaption:String; aAction:integer; aBssMeterAufrunden:Boolean);
  end;

var FormCadView: TFormCadView;

implementation uses Registry, Printers, Math, Drucken2, Data, RBuilder, MyRAPFuncs, CadViewOptions;

var MouseStart:TPoint;

{$R *.DFM}

//constructor TFormCadView.Create(AOwner:TComponent; aTable:TTable; aPath:String; aPrintDirect,aPrintPositionen:Boolean);
constructor TFormCadView.Create(AOwner:TComponent; aTable:TTable; aCaption:String; aAction:integer; aBssMeterAufrunden:Boolean);
begin
  // fAction
  // 0 = nur Anzeigen und nichts ändern dürfen
  // 1 = Anzeigen
  // 2 = Daten in das Angebot importieren
  // 3 = Daten in den Auftrag importieren
  // 4 = direkt vom Angebot oder Auftrag drucken
  // 5 = direkt vom Auftrag drucken und Auftragspositionen mit ausgeben (Nachkalkulation)
  fAction:=aAction;
  fBssMeterAufrunden:=aBssMeterAufrunden;
  fTable:=aTable;
  fCaption:=aCaption;
//  Vorgaben.Refresh;
  fPath:=Daten.VorgabenCADPath.AsString;
  fFilename:=fTable.FieldByName('CF2Datei').AsString;
  fFullFilename:=concat(fPath,'\',fFilename);
  fHilfstypAktiv:=Daten.VorgabenCadMitHilfslinientyp.AsBoolean;
  fPerfaHilfstypNr:=Daten.VorgabenHilfstypNrPerfa.AsString;
  fResyHilfstypNr:=Daten.VorgabenHilfstypNrResy.AsString;

//  fPerfaHilfstypNr:='42'; // nur zum Testen

  inherited Create(AOwner);
end;

procedure TFormCadView.FormCreate(Sender: TObject);
begin
  RestoreFormSize(self, 'CF2Viewer');

  GetColorSettings;

  SL:=TStringList.Create;
  LT:=TStringList.Create;
  // Bitmap auf Monochrom setzten, sonst ist max. nur eine Breite+Höhe von 2000x2000 Pixel möglich
//  Image1.Picture.Bitmap.Monochrome:=true;
//  Image1.Picture.Bitmap.Pixelformat:=pf4bit; // 16 Farben
  Image1.Picture.Bitmap.Pixelformat:=pf8bit;   // 256 Farben
//  Image1.Picture.Bitmap.Pixelformat:=pf24bit;

  if fAction = 4 then begin
     if FileExists(fFullFilename)
     then ReadFile
     else fFilename:='';
  end;
{
  BtnOpen.Enabled:=fAction=1;
  BtnPrint.Enabled:=(fFileName<>'') and (fAction<=1);
  BtnZoom.Enabled:=BtnPrint.Enabled;
  BtnFullSize.Enabled:=BtnPrint.Enabled;
}
  Case fAction of
    2: DatenimportAngebot;
    3: DatenimportAuftrag;
    4: BtnPrintClick(nil);
    5: Nachkalkulation;
  end;
end;

procedure TFormCadView.FormActivate(Sender: TObject);
begin
  if fAction in [0,1] then begin
     if FileExists(fFullFilename)
     then ReadFile
     else fFilename:='';

     if fFilename=''
     then Caption:=fCaption
     else Caption:=format('%s   [%s]',[fCaption,fFilename]);
  end;
end;

procedure TFormCadView.FormDestroy(Sender: TObject);
begin
  SaveFormSize(self, 'CF2Viewer');

  tblCF2Colors.Close;
  SL.Free;
  LT.Free;
end;

procedure TFormCadView.FormResize(Sender: TObject);
begin
//
end;

procedure TFormCadView.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
   '+': BtnZoomPlusClick(BtnZoomPlus);
   '-': BtnZoomPlusClick(BtnZoomMinus);
  end;
end;

procedure TFormCadView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case key of
    vk_Prior: with ScrollBox1.VertScrollBar do Position:=0;
    vk_Next: with ScrollBox1.VertScrollBar do Position:=Range;
    vk_up: with ScrollBox1.VertScrollBar do if Shift=[ssCtrl] then Position:=0 else Position:=Position-10;
    vk_down: with ScrollBox1.VertScrollBar do if Shift=[ssCtrl] then Position:=Range else Position:=Position+10;
//    vk_left: with ScrollBox1.HorzScrollBar do if Shift=[ssCtrl] then Position:=0 else Position:=Position-10;
//    vk_right: with ScrollBox1.HorzScrollBar do if Shift=[ssCtrl] then Position:=Range else Position:=Position+10;
    vk_left: BtnRotateRightClick(BtnRotateLeft);
    vk_right: BtnRotateRightClick(BtnRotateRight);
  end;
end;

procedure TFormCadView.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var r:TRect;
begin
  if ssLeft in Shift then begin
     Screen.Cursor:=crHandPoint;
     MouseStart.X:=x; MouseStart.Y:=y;
  end;
end;

procedure TFormCadView.Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor:=crDefault;
end;

procedure TFormCadView.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var h,v:integer;
begin
  if ssLeft in Shift then begin
     with ScrollBox1 do begin
          h:=HorzScrollBar.Position+((x-MouseStart.x)); // div HorzScrollBar.Increment);
          v:=VertScrollBar.Position+((y-MouseStart.y)); // div VertScrollBar.Increment);
          HorzScrollBar.Position:=h;
          VertScrollBar.Position:=v;

          MouseStart.x:=x;
          MouseStart.y:=y;

//          ScrollBox1.Perform(wm_HScroll, SB_THUMBPOSITION, h);
//          ScrollBox1.Perform(wm_VScroll, SB_THUMBPOSITION, v);
     end;
  end;
end;

// *********************************************************************************************************************
// *********************************************************************************************************************
// *********************************************************************************************************************
procedure TFormCadView.BtnSaveClick(Sender: TObject);
begin
  fTable.Edit;
  fTable.FieldByName('CF2Datei').AsString:=fFilename;
  fTable.Post;
end;

procedure TFormCadView.BtnOpenClick(Sender: TObject);
begin
  Application.ProcessMessages;
  OpenDialog1.InitialDir:=fPath;
  if OpenDialog1.Execute then begin
     Application.ProcessMessages;

     fPath:=ExtractFilePath(OpenDialog1.FileName);
     fFilename:=ExtractFileName(OpenDialog1.Filename);
     fFullFilename:=concat(OpenDialog1.FileName);
{
     BtnPrint.Enabled:=fAction<=1;
     BtnZoom.Enabled:=BtnPrint.Enabled;
     BtnFullSize.Enabled:=BtnPrint.Enabled;
     BtnSave.Enabled:=fAction=1;
}
     Caption:=format('%s   [%s]',[fCaption,fFilename]);

     ReadFile;
  end;
end;

procedure TFormCadView.ReadFile;
var f:Textfile;
begin
  try
      LabelBrettgroesse.Visible:=false;
      AssignFile(f,fFullFilename);
      Reset(f);
      SL.Clear;
      readln(f,z);
      z:=AdjustLineBreaks(z);
      SL.Text:=z;
      while not eof(f) do begin
            readln(f,z);
            z:=AdjustLineBreaks(z);
            SL.Add(z);
      end;
      if SL[SL.Count-1]<>'$EOF' then SL.Add('END'); // zur Sicherheit prüfen

      InitMain;
      CalcSize;

      if fAction<=1 then BtnFitToWindowSizeClick(nil);
  finally
      CloseFile(f);
  end;
end;

procedure TFormCadView.InitMain;
begin
// Achtung: Bei den CF2-Dateien ist der Nullpunkt unten links, wie beim normalen Koordinatensystem
// bei TCanvas jedoch oben links

// in den Dateien steht LL (= LowerLeft=XMin/YMin) und UR (= UpperRight=XMax/YMax)
// Meistens sind die Werte aber nicht berechnet, oder als (0/0) und (1000/1000) angegeben. Deswegen selbst berechnen

  fProgrammname:='';
  iMain:=-1; iMainStart:=-1;
  repeat
        inc(iMain);
        z:=SL[iMain]+',';
        if pos('MAIN,',z)=1 then begin
           Delete(z,1,5); // MAIN,,
           fProgrammname:=GetString;
        end
        else if pos('SCALE,',z)=1 then begin
           Delete(z,1,6); // SCALE,
           fScale.X:=GetValue;
           fScale.Y:=GetValue;
           iMainStart:=iMain;
           break;
        end;
  until false;
  fZoomfaktor:=1;
end;

procedure TFormCadView.InitSubroutine;
begin
  iSub:=-1;
  fUnterprogramm.Name:='';
  fUnterprogramm.Offset.X:=0;
  fUnterprogramm.Offset.Y:=0;
  fUnterprogramm.Scale.X:=1;
  fUnterprogramm.Scale.Y:=1;
  fUnterprogramm.Winkel:=0;
end;

{* Zeilen einlesen ********************************************************************************}
function TFormCadView.GetValue:Extended;
var i:integer;
    z1:String;
begin
  i:=pos(',',z);
  z1:=copy(z,1,i-1);
  Delete(z,1,i);
//  i:=pos('.',z1); if i>0 then z1[i]:=',';
  i:=pos('.',z1); if i>0 then z1[i]:=DecimalSeparator;
  try result:=StrToFloat(z1); except result:=0; end;
end;

function TFormCadView.GetString:String;
var i:integer;
    z1:String;
begin
  i:=pos(',',z);
  z1:=copy(z,1,i-1);
  Delete(z,1,i);
  result:=z1;
end;

// *** Hilfsfunktionen zur Berechnung **********************************************************************************
function RoundToInt (value:Extended):Int64;
// auf- oder abrunden
begin
  if value<0
  then Result := Trunc(Value - 0.5)
  else Result := Trunc(Value + 0.5);
end;

function RoundUpToInt (value:Extended):Int64;
// Zahlen mit Nachkommastellen immer ganzzahlig aufrunden
begin
{
  result:=trunc(value);
  if result>=0
  then result:=result+1
  else result:=result-1;
}
  result:=trunc(value);
  if result>=0
  then begin if frac(value)>0 then inc(result); end
  else if frac(value)<0 then dec(result);
end;

function GetAngle(x,y:Extended):Double;
// Steigungswinkel der Geraden durch die Punkte (0,0) und (x,y). Gleichbedeutend mit Bogenwinkel.
var rad:Extended;
begin
  rad:=arctan2(y,x); // Winkel in Rad. Ergebnis: -Pi..0..+Pi
  if rad<0 then rad:= 2*PI + rad; // falls negativ umwandeln, so dass Ergebnis: 0..2Pi
  result:=RadToDeg(rad); // umwandeln in Degrees (d.h. 0 bis 359 Grad)
end;

function AddAngle(a1,a2:Double):Double;
// 2 Winkel addieren, aber so das das Ergebnis zwischen 0 und 360 Grad bleibt
var s:Extended;
    r:integer;
begin
  s:=a1+a2;
  r:=trunc(s / 360);
  result:=s - (r*360);
end;

function CheckAngle(value:integer):integer;
// Der ganzzahlige Winkel, egal ob negativ oder über 360 Grad soll immer zwischen 0 und 359 Grad liegen
begin
  result:=value mod 360;
  if result < 0 then result:=result+360;
end;

procedure MovePoint(var x,y:Extended; const angle:Extended);
// ausgehend vom Ursprung 0/0
var winkel:Double;
    radius:Extended;
begin
  radius:=Sqrt(sqr(x) + sqr(y));
  winkel:=GetAngle(x,y);
  winkel:=AddAngle(winkel,angle);
  winkel:=DegToRad(winkel);
  x:=radius * cos(winkel);
  y:=radius * sin(winkel);
end;

procedure RotatePoint(var x,y:Extended; const dx,dy, winkel:Extended);
// Der Punkt x/y wird um den Drehpunkt dx/dy mit einem Winkel (in Grad) gedreht
var rad,xTemp:extended;
begin
  rad := winkel * (PI / 180); // Grad-Winkel als Bogenmaß (Radiant)
  xTemp := cos(rad)*(x-dx) - sin(rad)*(y-dy) + dx;
  y     := sin(rad)*(x-dx) + cos(rad)*(y-dy) + dy;
  x:=xTemp;
end;

// *********************************************************************************************************************
// *** Berechnung ******************************************************************************************************
// *********************************************************************************************************************
procedure TFormCadView.CalcSize;
var Brett:TRectExt; // Min-Max-Koordinaten nur von den Linien und Kreisen. Wird dann als Brettgröße ausgegeben.
    i:integer;
    z0,z1:String;

  procedure CalcObject;
  var x1,y1,x2,y2,mx,my:Extended; // Startpunkt, Zielpunkt, Kreismittelpunkt
      b:integer; // Linienbreite, pointage 1Punkt=1/72 inches
      t:integer; // Linientyp
      ht:integer; // Hilfslinientyp
      d:integer; // Drehrichtung
      r:Extended; // Kreisradius
      s:Extended; // Sehnenlänge
      laenge,     // Linienlänge
      BogenlaengeKlein,
      BogenlaengeGross,
      help:Extended;
      zText:string; // Ausgabetext

      procedure SetMinMax(LineOrCircle:boolean);
      begin
        with fBild do begin // alle Objekte (Linie, Kreis, Text)
             if x1<xMin then xMin:=x1; if x1>xMax then xMax:=x1;
             if y1<yMin then yMin:=y1; if y1>yMax then yMax:=y1;
             if LineOrCircle then begin // Textobjekt hat keine x2/y2-Koordinaten
                if x2<xMin then xMin:=x2; if x2>xMax then xMax:=x2;
                if y2<yMin then yMin:=y2; if y2>yMax then yMax:=y2;
             end;
        end;

        if LineOrCircle then begin // nicht für Texte, da diese manchmal auch ausserhalb des Brettes zu Infozwecken stehen
           with Brett do begin
                if x1<xMin then xMin:=x1; if x1>xMax then xMax:=x1;
                if y1<yMin then yMin:=y1; if y1>yMax then yMax:=y1;
                if x2<xMin then xMin:=x2; if x2>xMax then xMax:=x2;
                if y2<yMin then yMin:=y2; if y2>yMax then yMax:=y2;
           end;
        end;
      end;

      procedure SummiereLaenge;
      var z0,z1:string;
      begin
        if b>0 then begin // Breite=0-Punkt bedeutet: Zeichnen aber nicht brennen, daher nicht summieren
           Case b of
             1: fPkt1:=fPkt1+laenge;
             2: fPkt2:=fPkt2+laenge;
             3: fPkt3:=fPkt3+laenge;
             4: fPkt4:=fPkt4+laenge;
           end;
           fGesamtMeter:=fGesamtMeter+laenge;

           if fHilfstypAktiv
           then z0:=format('%d-%d-%d',[b,t,ht])
           else z0:=format('%d-%d',[b,t]);
           z1:=LT.Values[z0];
           if z1=''
           then LT.Add(format('%s=%.2f',[z0,laenge]))
           else LT.Values[z0]:=format('%.2f',[laenge+StrToFloat(z1)]);
        end;
      end;

      procedure CountPerfaOrResy;
      var z0:string;
      begin
        if (fPerfaHilfstypNr<>'') and (IntToStr(ht)=fPerfaHilfstypNr) then inc(fPerfaCount,length(zText))
        else if (fResyHilfstypNr<>'') and (IntToStr(ht)=fResyHilfstypNr) then inc(fResyCount);
{
        z0:=StringReplace(zText,' ','',[rfReplaceAll]); // Leerzeichen entfernen
        if AnsiUpperCase(z0)='RESY'
        then inc(fResyCount)
        else if (fPerfaHilfstypNr<>'') and (IntToStr(ht)=fPerfaHilfstypNr) then inc(fPerfaCount);
}
      end;

  begin
    if pos('L,',z)=1 then begin // Linie
       Delete(z,1,2); // L,
       b:=round(GetValue);
       t:=round(GetValue);
       ht:=round(GetValue);

       x1:=GetValue; y1:=GetValue;
       x2:=GetValue; y2:=GetValue;
       if fUnterprogramm.Winkel<>0 then begin
          MovePoint(x1,y1,fUnterprogramm.Winkel);
          MovePoint(x2,y2,fUnterprogramm.Winkel);
       end;
       x1:=x1 + fUnterprogramm.Offset.X; y1:=y1 + fUnterprogramm.Offset.Y;
       x2:=x2 + fUnterprogramm.Offset.X; y2:=y2 + fUnterprogramm.Offset.Y;

       SetMinMax(true);
       laenge:=sqrt(sqr(x1-x2)+sqr(y1-y2));
       SummiereLaenge;
    end

    else if pos('A,',z)=1 then begin // Kreis
       Delete(z,1,2); // A,
       b:=round(GetValue);
       t:=round(GetValue);
       ht:=round(GetValue);

       x1:=GetValue; y1:=GetValue;
       x2:=GetValue; y2:=GetValue;
       mx:=GetValue; my:=GetValue;
       if fUnterprogramm.Winkel<>0 then begin
          MovePoint(x1,y1,fUnterprogramm.Winkel);
          MovePoint(x2,y2,fUnterprogramm.Winkel);
          MovePoint(mx,my,fUnterprogramm.Winkel);
       end;
       x1:=x1 + fUnterprogramm.Offset.X; y1:=y1 + fUnterprogramm.Offset.Y;
       x2:=x2 + fUnterprogramm.Offset.X; y2:=y2 + fUnterprogramm.Offset.Y;
       mx:=mx + fUnterprogramm.Offset.X; my:=my + fUnterprogramm.Offset.Y;

       SetMinMax(true);
       help:=GetValue; // Drehrichtung (-1 = im Uhrzeigersinn, +1 = gegen den Uhrzeigersinn)
       if help<0 then d:=-1 else d:=1;
       // Berechnung
       r:=sqrt(sqr(x1-mx)+sqr(y1-my)); // Radius
       s:=sqrt(sqr(x1-x2)+sqr(y1-y2)); // Sehnenlänge
       if s=0
       then laenge:=2*pi*r // = voller Kreis
       else begin
              help:=1 - sqr(s)/(2*sqr(r)); // aus Kosinussatz hergeleitet
              // falls |help|>1 ==> EExternalException mit Blue-Screen. try-except hilt nicht!
              if help>1 then help:=1;
              if help<-1 then help:=-1;
              try laenge:=arccos(help); except laenge:=0; end ;
              laenge:=laenge*r;

              BogenlaengeKlein:=laenge; // die kürzere Bogenlänge
              BogenlaengeGross:=(2*pi*r) - BogenlaengeKlein; // die längere Bogenlänge

              if ((x1-mx)*(y2-my)) - ((x2-mx)*(y1-my)) > 0 // Kreuzprodukt
              then if d=-1 // -1 = im Uhrzeigersinn, mathematisch nennt man das negativer Drehsinn
                   then laenge:=BogenlaengeGross
                   else laenge:=BogenlaengeKlein
              else if d=-1
                   then laenge:=BogenlaengeKlein
                   else laenge:=BogenlaengeGross;
       end;
       SummiereLaenge;
    end

    else if pos('T,',z)=1 then begin // Text
       Delete(z,1,2); // T,
       b:=round(GetValue);
       t:=round(GetValue);
       ht:=round(GetValue);

       x1:=GetValue; y1:=GetValue;
       if fUnterprogramm.Winkel<>0 then begin
          MovePoint(x1,y1,fUnterprogramm.Winkel);
       end;
       x1:=x1 + fUnterprogramm.Offset.X; y1:=y1 + fUnterprogramm.Offset.Y;

       SetMinMax(false);
       GetValue;
       GetValue;
       GetValue;

       if iSub=-1 // der Text
       then begin inc(iMain); zText:=SL[iMain]; end
       else begin inc(iSub); zText:=SL[iSub]; end;

       CountPerfaOrResy;
    end;
  end;

BEGIN // CalcSize
  LT.Clear; CB1.Items.Clear;
  fGesamtMeter:=0; fPkt1:=0; fPkt2:=0; fPkt3:=0; fPkt4:=0;
  fPerfaCount:=0; fResyCount:=0;

  with fBild do begin xMin:=MaxInt; xMax:=-MaxInt; yMin:=MaxInt; yMax:=-MaxInt; end;
  Brett:=fBild;

  InitSubroutine;
  iMain:=iMainStart;
  if iMain>=0 then begin
     repeat
           inc(iMain);
           z:=SL[iMain]+',';
           if pos('END',z)=1 then break
           else if pos('C,',z)=1 then begin
              Delete(z,1,2); // C,
              fUnterprogramm.Name:=GetString;
              fUnterprogramm.Offset.X:=GetValue;
              fUnterprogramm.Offset.Y:=GetValue;
              fUnterprogramm.Winkel:=GetValue;
              fUnterprogramm.Scale.X:=GetValue;
              fUnterprogramm.Scale.Y:=GetValue;
              iSub:=SL.IndexOf('SUB,'+fUnterprogramm.Name);
              if iSub>=0 then
              repeat
                    inc(iSub);
                    z:=SL[iSub]+',';
                    if pos('END',z)=1 then break;
                    CalcObject;
              until false;
              InitSubroutine;
           end
           else CalcObject;
     until false;

     fBrettgroesse.X:=RoundUpToInt(Brett.xMax - Brett.xMin);
     fBrettgroesse.Y:=RoundUpToInt(Brett.yMax - Brett.yMin);

     i:=20; // zusätzlicher Rand an allen Seiten
     fBild.xMax:=fBild.xMax + i;
     fBild.xMin:=fBild.xMin - i;
     fBild.yMax:=fBild.yMax + i;
     fBild.yMin:=fBild.yMin - i;

     fBildgroesse.X:=RoundUpToInt(fBild.xMax - fBild.xMin);
     fBildgroesse.Y:=RoundUpToInt(fBild.yMax - fBild.yMin);

     FDrehpunkt.X:=fBild.xMin + ((fBild.xMax - fBild.xMin) / 2);
     FDrehpunkt.Y:=fBild.yMin + ((fBild.yMax - fBild.yMin) / 2);
     FDrehwinkel:=0;
     fShift.x:=fBild.xMin;
     fShift.y:=fBild.yMax;

     LabelBrettgroesse.Caption:=format('%s: %d x %d mm',[fProgrammname, fBrettgroesse.X, fBrettgroesse.Y]);
     LabelBrettgroesse.Visible:=true;

     LT.Sort;
     for i:=0 to LT.Count-1 do begin
         z0:=LT.Names[i];
         z1:=LT.ValueFromIndex[i]; // LT.Values[z0];
         CB1.Items.Add(format('%-6s = %6.2f',[z0,StrToFloat(z1)/1000])); // mm in Meter umrechnen
     end;

     if fPerfaCount>0 then CB1.Items.Add(format('Perfa = %d Stück',[fPerfaCount]));
     if fResyCount>0 then CB1.Items.Add(format('Resy = %d Stück',[fResyCount]));

     CB1.Items.Add(format('Gesamt = %6.2f',[fGesamtMeter/1000]));
     CB1.ItemIndex:=CB1.Items.Count-1;
  end;
END; // CalcSize

// *********************************************************************************************************************
// *** Zeichnen ********************************************************************************************************
// *********************************************************************************************************************
procedure TFormCadView.ShowFile(aBitmap:TBitmap);


  procedure DrawObject;
  var x1,y1,x2,y2,mx,my:Extended;
      b:integer;  // Linienbreite, 1 Punkt (pointage) ist 1/72 inches
      t:integer;  // Linientyp
      ht:integer; // Hilfslinientyp
      d:integer;  // Drehrichtung
      z1:string;  // Ausgabetext
      help:Extended;
      winkel:integer;
      CharHeight:Double; // Zeichenhöhe bei Texten in mm
      CharWidth:Double;  // Zeichenbreite bei Texten in mm
      Bruecken:integer;        // Anzahl Brücken
      Brueckenlaenge:Extended; // Brückenweite in mm

      procedure DrawLine;
      // Problem mit Datei Bi2727.cf2 oder ROT41299.cf2 noch ungelöst (es werden kleine Kreise gezeichnet, die keine sind)
      // wahrscheinlich liegt das am ganzahligen Runden nah beiananderliegender Dezimalwerte
      var p1,p2:TPoint;
          b1,b2:TPoint;
          Laenge:Extended; // Länge von P1 zu P2
          Steigungswinkel:Extended; // Winkel der Geraden durch die Punkte P1 und P2 (im Bogenmaß)
          SinWinkel,CosWinkel:Extended;
          Abschnitt:Extended;
          Strecke:Extended;
          i:integer;
      begin
        with aBitmap.Canvas do begin
             Pen.Color:=GetTypColor(t);
             Pen.Width:=GetPenWidth(b);
             if FDrawZeroPointage and (b=0)
             then Pen.Style:=psDot // 0-Punkt-Linie
             else Pen.Style:=psSolid;

             p1.X:=RoundToInt(x1); p1.Y:=RoundToInt(y1);
             p2.X:=RoundToInt(x2); p2.Y:=RoundToInt(y2);

             Bruecken:=abs(Bruecken);
             Brueckenlaenge:=abs(Brueckenlaenge)*fZoomfaktor;

             if FDrawGaps and (Bruecken>0) and (Brueckenlaenge>0)
             then begin
                    Laenge:=sqrt(sqr(x1-x2)+sqr(y1-y2));
                    Abschnitt:=(Laenge-(Bruecken*Brueckenlaenge)) / (Bruecken+1);

                    if p1.X = p2.X
                    then if p2.Y > p1.Y
                         then Steigungswinkel:=0.5*PI  //  90 Grad
                         else Steigungswinkel:=1.5*PI  // 270 Grad
                    else if p1.Y = p2.Y
                         then if p2.X > p1.X
                              then Steigungswinkel:=0  //   0 Grad
                              else Steigungswinkel:=PI // 180 Grad
                         else begin
                                Steigungswinkel:=arctan2( (y2-y1), (x2-x1) );
                                if Steigungswinkel<0 then Steigungswinkel:=Steigungswinkel + 2*PI; // Ergebnis soll zwischen 0 und 2*PI liegen und nicht zwischen -PI und +PI
                         end;
                    SinCos(Steigungswinkel,SinWinkel,CosWinkel);

                    Strecke:=0;
                    for i:=0 to Bruecken do begin
                        b1.X:=p1.X + RoundToInt(Strecke * CosWinkel);
                        b1.Y:=p1.Y + RoundToInt(Strecke * SinWinkel);
                        Strecke:=Strecke + Abschnitt;
                        b2.X:=p1.X + RoundToInt(Strecke * CosWinkel);
                        b2.Y:=p1.Y + RoundToInt(Strecke * SinWinkel);
                        Polyline([b1,b2]);
                        Strecke:=Strecke + Brueckenlaenge; // Lücke
                    end;
             end
             else Polyline([p1,p2]); // durchgezogene Linie
         end;
      end;

      procedure DrawCircle;
      var r:Extended; // Kreisradius
          rM:TRect;
          pStart,pEnde,pTemp:TPoint; // Startpunkt, Zielpunkt
      begin
        // Radius
        r:=sqrt(sqr(x1-mx)+sqr(y1-my));

        // Viereck um den Kreismittelpunkt. Kreise müssen ein Quadrat um den Mittelpunkt haben.
        // Durch Runden kann auch ein Rechteck entstehen. Dann Ellipse
        rM.Left:=RoundToInt(mx-r);
        rM.Right:=RoundToInt(mx+r);
        rm.Top:=RoundToInt(my-r);
        rM.Bottom:=RoundToInt(my+r);

        pStart.X:=RoundToInt(x1); pStart.Y:=RoundToInt(y1);
        pEnde.X :=RoundToInt(x2); pEnde.Y :=RoundToInt(y2);

        // Der Radius ist zu klein, kein Vireck möglich.
        if (rM.Left=rm.Right) or (rm.Top=rm.Bottom) then begin
           aBitmap.Canvas.Pixels[pStart.X, pStart.Y]:=GetTypColor(t);;
           aBitmap.Canvas.Pixels[pEnde.X, pEnde.Y]:=GetTypColor(t);;
           exit;
        end;

        // Start- und Zielpunkt sind verschieden, werden aber auf den gleichen Punkt gerundet, weil sie so nahe beieinander liegen.
        if ((pStart.X=pEnde.X) and (pStart.Y=pEnde.Y)) AND
           ((x1<>x2) or (y1<>y2)) then begin
           aBitmap.Canvas.Pixels[pStart.X, pStart.Y]:=GetTypColor(t);;
           exit;
        end;

        // Drehsinn = -1 bedeutet im Uhrzeigersinn, engl.= clockwise.
        // Da Windows immer gegen den Uhrzeigersinn = +1 (engl. CounterClockwise) zeichnet, Start- und Zielpunkt vertauschen.
        // Mit SetArcDirection könnte man aber die Drehrichtung angeben
        if d=-1 then begin
           pTemp:=pStart;
           pStart:=pEnde;
           pEnde:=pTemp;
        end;

        with aBitmap.Canvas do begin
             Pen.Color:=GetTypColor(t);
             Pen.Width:=GetPenWidth(b);
             if FDrawZeroPointage and (b=0)
             then Pen.Style:=psDot // 0-Punkt-Linie
             else Pen.Style:=psSolid;
             Arc(rm.Left,rm.Top,rm.Right,rm.Bottom,  pStart.X,pStart.Y,  pEnde.X,pEnde.Y);
        end;
      end;

      procedure MirrorBitmap(aBitmap:TBitmap; aRect:TRect; Horizontal:Boolean);
      var b:TBitmap;
          r:TRect;
          i:integer;
      begin
        r:=aRect;
        // um 1 erhöhen, sonst wird die Right/Bottom-Boundgrenze ausgespart
        r.Right:=r.Right+1;
        r.Bottom:=r.Bottom+1;

        if r.Left>r.Right then begin
           i:=r.Left;
           r.Left:=r.Right;
           r.Right:=i;
        end;
        if r.Top>r.Bottom then begin
           i:=r.Top;
           r.Top:=r.Bottom;
           r.Bottom:=i;
        end;
        if (r.Left<0) or (r.Left>aBitmap.Width) then exit;
        if r.Right>aBitmap.Width then r.Right:=aBitmap.Width;
        if (r.Top<0) or (r.Top>aBitmap.Height) then exit;
        if r.Bottom>aBitmap.Height then r.Bottom:=aBitmap.Height;

        b:=TBitmap.Create;
        try
           b.Width:=r.Right-r.Left;
           b.Height:=r.Bottom-r.Top;
           b.Canvas.Brush:=aBitmap.Canvas.Brush;
           b.Canvas.Pen:=aBitmap.Canvas.Pen;

           if Horizontal
           then StretchBlt(b.Canvas.Handle, // Destination
                           b.Width-1, 0, -b.Width, b.Height,
                           aBitmap.Canvas.Handle, // Source
                           r.Left, r.Top, b.Width, b.Height,
                           SRCCOPY)
           else StretchBlt(b.Canvas.Handle, // Destination
                           0, b.Height-1, b.Width, -b.Height,
                           aBitmap.Canvas.Handle, // Source
                           r.Left, r.Top, b.Width, b.Height,
                           SRCCOPY);

           StretchBlt(aBitmap.Canvas.Handle, // Destination
                      r.Left, r.Top, b.Width, b.Height,
                      b.Canvas.Handle, // Source
                      0, 0, b.Width, b.Height,
                      SRCCOPY);
        finally
           b.Free;
        end;
      end;

      procedure DrawText(aBitmap:TBitmap; x,y:double; angle:word; FontHoehe, FontBreite: double; aText:string);
      // Text mit einem Winkel ausgeben funktioniert nur mit True-Type Schriften
      // Manche Schriften können 90 Grad, nicht aber 270 Grad. Nie negative Winkel angeben.
      // Negative FontBreite bedeutet Text spiegeln
      var aLogFont:TLogFont;
          OldFontHandle, NewFontHandle:HFont;
          iX, iY:integer;
          ts:TSize;
      begin
        aBitmap.Canvas.Font.Color:=GetTextColor; // Fonthandle wird angefordert, falls noch nicht geschehen
        GetObject(aBitmap.Canvas.Font.Handle, Sizeof(aLogFont), Addr(aLogFont));
        with aLogFont do begin
             lfEscapement:=angle*10;
             lfOrientation:=angle*10;
             lfUnderline:=0;
             lfItalic:=0;
             lfStrikeOut:=0;
             lfHeight:= - RoundToInt(abs(FontHoehe)); // positiver Wert=Punktgröße (1 Punkt=1/72 Inch), negativer Wert=Pixelhöhe
             lfWidth:=MulDiv(abs(RoundToInt(FontBreite)),2,3); // Windows braucht die durchschnittliche Zeichenbreite (in Pixel), nicht den Zeichenabstand z.B. 6
             lfWeight:=300; // FW_THIN=100; FW_EXTRALIGHT=200; FW_LIGHT=300; FW_NORMAL=400; FW_BOLD=700;
             lfOutPrecision:=OUT_TT_PRECIS;
             lfFaceName:='Arial';
//             lfPitchAndFamily:=Variable_Pitch or FF_Swiss;
//             lfCharSet: Byte;
//             lfClipPrecision: Byte;
//             lfQuality: Byte;
        end;

        NewFontHandle:=CreateFontIndirect(aLogFont);
        OldFontHandle:=SelectObject(aBitmap.Canvas.Handle, NewFontHandle);

        aBitmap.Canvas.Brush.Style:=bsClear;
        aBitmap.Canvas.Brush.Color:=FclBackground;
        aBitmap.Canvas.Font.Color:=GetTextColor;

        SetBkMode(aBitmap.Canvas.Handle,Transparent); // vorher gezeichnete Linien nicht durch den Text übermalen
        SetTextAlign(aBitmap.Canvas.handle, ta_Left or ta_Bottom or ta_NOUPDATECP); // In der CF2-Datei gibt x,y die Bottom/Left-Position an
        iX:=RoundToInt(x);
        iY:=RoundToInt(y);
        aBitmap.Canvas.TextOut(iX, iY, aText);
        if FontBreite<0 then ts:=aBitmap.Canvas.TextExtent(aText);

        aBitmap.Canvas.Brush.Style:=bsSolid;
        SelectObject(aBitmap.Canvas.Handle, OldFontHandle);
        DeleteObject(NewFontHandle);

        if FontBreite<0 then begin // Spiegelschrift
           case angle of
              0: MirrorBitmap(aBitmap, Rect(iX, iY-ts.cy, iX+ts.cx, iY), true);
             90: MirrorBitmap(aBitmap, Rect(iX-ts.cy, iY-ts.cx, iX, iY), false);
            180: MirrorBitmap(aBitmap, Rect(iX-ts.cx, iY, iX, iY+ts.cy), true);
            270: MirrorBitmap(aBitmap, Rect(iX, iY, iX+ts.cy, iY+ts.cx), false);
           end;
        end;
      end;

  BEGIN // DrawObject
    if pos('L,',z)=1 then begin // Linie
       Delete(z,1,2); // L,
       b:=round(GetValue);
       t:=round(GetValue);
       ht:=round(GetValue); // Hilfslinientyp
       x1:=GetValue; y1:=GetValue;
       x2:=GetValue; y2:=GetValue;
       Bruecken:=round(GetValue); // Anzahl der Brücken, positiv und ganzzahlig
       Brueckenlaenge:=GetValue;  // Brückenweite in mm

       if fUnterprogramm.Winkel<>0 then begin
          MovePoint(x1,y1,fUnterprogramm.Winkel);
          MovePoint(x2,y2,fUnterprogramm.Winkel);
       end;

       x1:=x1 + fUnterprogramm.Offset.X;
       y1:=y1 + fUnterprogramm.Offset.Y;
       x2:=x2 + fUnterprogramm.Offset.X;
       y2:=y2 + fUnterprogramm.Offset.Y;

       if fDrehwinkel<>0 then begin
          RotatePoint(x1,y1, fDrehpunkt.X,fDrehpunkt.Y, fDrehwinkel);
          RotatePoint(x2,y2, fDrehpunkt.X,fDrehpunkt.Y, fDrehwinkel);
       end;

       // in den Windowsursprung (0/0) verschieben
       x1:=x1 - fShift.X; y1:=fShift.Y - y1;
       x2:=x2 - fShift.X; y2:=fShift.Y - y2;

       x1:=fZoomfaktor*x1; y1:=fZoomfaktor*y1;
       x2:=fZoomfaktor*x2; y2:=fZoomfaktor*y2;

       DrawLine;
    end

    else if pos('A,',z)=1 then begin // Kreisbogen
       Delete(z,1,2); // A,
       b:=round(GetValue);
       t:=round(GetValue);
       ht:=round(GetValue); // Hilfslinientyp

       x1:=GetValue; y1:=GetValue; // Startpunkt des Kreisbogens
       x2:=GetValue; y2:=GetValue; // Endpunkt des Kreisbogens
       mx:=GetValue; my:=GetValue; // Mittelpunkt des Kreisbogens
       help:=GetValue; if help<0 then d:=-1 else d:=1; // Drehrichtung

       if fUnterprogramm.Winkel<>0 then begin
          MovePoint(x1,y1,fUnterprogramm.Winkel);
          MovePoint(x2,y2,fUnterprogramm.Winkel);
          MovePoint(mx,my,fUnterprogramm.Winkel);
       end;

       x1:=x1 + fUnterprogramm.Offset.X;
       y1:=y1 + fUnterprogramm.Offset.Y;
       x2:=x2 + fUnterprogramm.Offset.X;
       y2:=y2 + fUnterprogramm.Offset.Y;
       mx:=mx + fUnterprogramm.Offset.X;
       my:=my + fUnterprogramm.Offset.Y;

       if fDrehwinkel<>0 then begin
          RotatePoint(x1,y1, fDrehpunkt.X,fDrehpunkt.Y, fDrehwinkel);
          RotatePoint(x2,y2, fDrehpunkt.X,fDrehpunkt.Y, fDrehwinkel);
          RotatePoint(mx,my, fDrehpunkt.X,fDrehpunkt.Y, fDrehwinkel);
       end;

       // in den Windowsursprung (0/0) verschieben
       x1:=x1 - fShift.X; y1:=fShift.Y - y1;
       x2:=x2 - fShift.X; y2:=fShift.Y - y2;
       mx:=mx - fShift.X; my:=fShift.Y - my; // der Mittelpunkt kann auch ausserhalb des Zeichnenbereiches liegen

       // Zoomen
       x1:=fZoomfaktor*x1; y1:=fZoomfaktor*y1;
       x2:=fZoomfaktor*x2; y2:=fZoomfaktor*y2;
       mx:=fZoomfaktor*mx; my:=fZoomfaktor*my;

       DrawCircle;
    end

    else if pos('T,',z)=1 then begin // Text
       Delete(z,1,2); // T,
       b:=round(GetValue);
       t:=round(GetValue);
       GetValue;

       x1:=GetValue; y1:=GetValue;
       winkel:=round(GetValue); // Winkel
       winkel:=CheckAngle(winkel);
       CharHeight:=GetValue;  // Höhe in mm
       CharWidth :=GetValue;  // Zeichenbreite mit Abstand zum nächsten Zeichen in mm; negativer Wert bedeutet Spiegelschrift.
                              // Umrechnen, da Windows die durchschnittliche Zeichenbreite braucht.

       if fUnterprogramm.Winkel<>0 then begin
          winkel:=RoundToInt(AddAngle(winkel,fUnterprogramm.Winkel));
          MovePoint(x1,y1,fUnterprogramm.Winkel);
       end;

       x1:=x1 + fUnterprogramm.Offset.X;
       y1:=y1 + fUnterprogramm.Offset.Y;

       if fDrehwinkel<>0 then begin
          winkel:=CheckAngle(winkel+fDrehwinkel);
          RotatePoint(x1,y1, fDrehpunkt.X,fDrehpunkt.Y, fDrehwinkel);
       end;

       x1:=x1 - fShift.X; y1:=fShift.Y - y1;

       x1:=fZoomfaktor*x1; y1:=fZoomfaktor*y1;

       CharHeight:=fZoomfaktor*CharHeight;
       CharWidth :=fZoomfaktor*CharWidth;

       if iSub=-1 // der Text
       then begin inc(iMain); z1:=SL[iMain]; end
       else begin inc(iSub); z1:=SL[iSub]; end;

       DrawText(aBitmap, x1,y1, winkel, CharHeight, CharWidth, z1);
    end;
  end; // DrawObject

BEGIN // ShowFile
// Achtung: nicht SetViewPortOrgEx benutzen!
// Mit SetViewPortOrgEx klappt der Druck auf Windows 2000 nicht. Die Draw-Prozeduren verhalten sich ebenso merkwürdig.
//  SetMapMode(aBitmap.Canvas.Handle, MM_HiMetric);
  with aBitmap do begin
//       Width:=trunc(fZoomfaktor*fBildgroesse.X)+2;
//       Height:=trunc(fZoomfaktor*fBildgroesse.Y)+2;
       Width:=RoundUpToInt(fZoomfaktor*fBildgroesse.X);
       Height:=RoundUpToInt(fZoomfaktor*fBildgroesse.Y);
       Canvas.Font.Name:='arial';
       Canvas.Font.Size:=8;
       Canvas.Font.Color:=GetTextColor;
       SetTextAlign(Canvas.handle,ta_Left or ta_Bottom or ta_NOUPDATECP);
       Canvas.Brush.Color:=FclBackground;
       Canvas.FillRect(rect(0,0,width,height));
  end;

  case fDrehwinkel of
     0: begin
          fShift.x:=fBild.xMin;
          fShift.y:=fBild.yMax;
        end;
    90: begin
          fShift.x:=fBild.xMax;
          fShift.y:=fBild.yMax;
          RotatePoint(fShift.X,fShift.Y, fDrehpunkt.X, fDrehpunkt.Y, fDrehwinkel);
        end;
   180: begin
          fShift.x:=fBild.xMax;
          fShift.y:=fBild.yMin;
          RotatePoint(fShift.X,fShift.Y, fDrehpunkt.X, fDrehpunkt.Y, fDrehwinkel);
        end;
   270: begin
          fShift.x:=fBild.xMin;
          fShift.y:=fBild.yMin;
          RotatePoint(fShift.X,fShift.Y, fDrehpunkt.X, fDrehpunkt.Y, fDrehwinkel);
        end;
  end;

  InitSubroutine;
  iMain:=iMainStart;
  if iMain>=0 then begin
     repeat
           inc(iMain);
           z:=SL[iMain]+',';
           if pos('END',z)=1 then break
           else if pos('C,',z)=1 then begin
              Delete(z,1,2); // C,
              fUnterprogramm.Name:=GetString;
              fUnterprogramm.Offset.X:=GetValue;
              fUnterprogramm.Offset.Y:=GetValue;
              fUnterprogramm.Winkel:=GetValue;
              fUnterprogramm.Scale.X:=GetValue;
              fUnterprogramm.Scale.Y:=GetValue;
              iSub:=SL.IndexOf('SUB,'+fUnterprogramm.Name);
              if iSub>=0 then
              repeat
                    inc(iSub);
                    z:=SL[iSub]+',';
                    if pos('END',z)=1 then break;
                    DrawObject;
              until false;
              InitSubroutine;
           end
           else DrawObject;
     until false;
  end;
END; // ShowFile

function TFormCadView.GetPenWidth(Pointage:integer):Byte;
begin
  if FDrawPointage
  then case Pointage of
        3: result:=2;
        4: result:=3;
        else result:=1;
       end
  else result:=1;
  if FPrinting then result:=result+2; // sonst sind die Linien zu dünn
end;


// *********************************************************************************************************************
// *** Farben **********************************************************************************************************
// *********************************************************************************************************************
function TFormCadView.GetTypColor(aMessertyp:integer):TColor;
var i:integer;
begin
  if (tblCF2Colors.Active) and (tblCf2Colors.Locate('TypNr',aMessertyp,[]))
  then result:=tblCf2ColorsFarbe.AsInteger
  else result:=FclSonstiges;

  if result=FclBackground then begin
     if FclBackground=clWhite
     then result:=clBlack
     else Result:=clWhite;
  end;
end;

function TFormCadView.GetTextColor:TColor;
begin
  result:=FclText;
  if result=FclBackground then begin
     if FclBackground=clWhite
     then result:=clBlack
     else Result:=clWhite;
  end;
end;

procedure TFormCadView.GetColorSettings;

  procedure GetDefaultColors;
  var i:integer;
  begin
    FDrawPointage:=true;
    FDrawZeroPointage:=true;
    FDrawGaps:=true;

    with tblCf2Colors do begin
         Close;
         Open;
         AppendRecord([1,Null,Null,TColor(clBlack),'Hintergrund',Null]);
         AppendRecord([2,Null,Null,TColor(clLime),'Text',Null]);
         AppendRecord([3,Null,Null,TColor(clWhite),'Sonstiges',Null]);
         AppendRecord([10,Null,Null,Null,'Messer',Null]);
         AppendRecord([11,Null,Null,Null,'Riller',Null]);
         AppendRecord([12,Null,Null,Null,'Perforation',Null]);
         AppendRecord([13,Null,Null,Null,'Kombi',Null]);
         AppendRecord([14,Null,Null,Null,'Ritzer',Null]);
         for i:=15 to 29 do AppendRecord([i,Null,Null,Null,Null,Null]);
    end;
  end;

var r:TRegistry;
    aStream:TMemoryStream;
    RegData: TRegDataType;
    Info: TRegDataInfo;
    nBytes:Integer;
begin
  r:=TRegistry.Create;
  r.RootKey:=HKey_Current_User;

  try
     if (r.KeyExists(RegistryKeyProgram + '\CF2')) and (r.OpenKeyReadOnly(RegistryKeyProgram + '\CF2'))
     then begin
            try FDrawPointage:=r.ReadBool('DrawPointage'); except FDrawPointage:=true; end;
            try FDrawZeroPointage:=r.ReadBool('DrawZeroPointage'); except FDrawZeroPointage:=true; end;
            try FDrawGaps:=r.ReadBool('DrawGaps'); except FDrawGaps:=true; end;

            // Farben
            if (r.ValueExists('Colors')) and (r.GetDataInfo('Colors', Info))
            then begin
                nBytes := Info.DataSize;
                RegData := Info.RegData;
                if (nBytes>0) and ((RegData = rdBinary) or (RegData = rdUnknown))
                then begin
                       aStream:=TMemoryStream.Create;
                       try
                          aStream.Size := aStream.Position + nBytes;
                          nBytes:=r.ReadBinaryData('Colors', Pointer(Integer(aStream.Memory) + aStream.Position)^, aStream.Size);
                          if nBytes>0 then
                          try
                             tblCf2Colors.Close;
                             tblCf2Colors.Open;
                             tblCf2Colors.LoadFromStream(aStream);
                          except
                             GetDefaultColors;
                          end;
                       finally
                          aStream.Free;
                       end;
                end
                else GetDefaultColors;
            end
            else GetDefaultColors;

     end
     else GetDefaultColors;
  finally
     r.CloseKey;
     r.Free;
  end;

  with tblCf2Colors do begin
       First; FclBackground:=tblCf2ColorsFarbe.AsInteger;
       Next;  FclText:=tblCf2ColorsFarbe.AsInteger;
       Next;  FclSonstiges:=tblCf2ColorsFarbe.AsInteger;
  end;
  ScrollBox1.Color:=FclBackground;
end;

procedure TFormCadView.SaveColorSettings;
var r:TRegistry;
    aStream:TMemoryStream;
begin
  if not tblCf2Colors.Active then exit;

  r:=TRegistry.Create;
  try
     r.RootKey:=HKey_Current_User;
     if r.OpenKey(RegistryKeyProgram + '\CF2',true) then begin
        r.WriteBool('DrawPointage', FDrawPointage);
        r.WriteBool('DrawZeroPointage', FDrawZeroPointage);
        r.WriteBool('DrawGaps', FDrawGaps);
        aStream:=TMemoryStream.Create;
        try
           tblCf2Colors.SaveToStream(aStream);
           aStream.Position:=0;
           r.WriteBinaryData('Colors', Pointer(Integer(aStream.Memory) + aStream.Position)^, aStream.Size - aStream.Position);
        finally
           aStream.Free;
        end;
     end;
  finally
     r.CloseKey;
     r.Free;
  end;
end;

procedure TFormCadView.BtnColorsClick(Sender: TObject);
var i:integer;
begin
  FormCadViewOptions:=TFormCadViewOptions.Create(self);
  try
     FormCadViewOptions.CBPointage.Checked:=FDrawPointage;
     FormCadViewOptions.CBZeroPointage.Checked:=FDrawZeroPointage;
     FormCadViewOptions.CBGaps.Checked:=FDrawGaps;

     i:=FormCadViewOptions.ShowModal;
     Application.ProcessMessages;
     if i=mrOk
     then begin
            FDrawPointage:=FormCadViewOptions.CBPointage.Checked;
            FDrawZeroPointage:=FormCadViewOptions.CBZeroPointage.Checked;
            FDrawGaps:=FormCadViewOptions.CBGaps.Checked;
            with tblCf2Colors do begin
                 First; FclBackground:=tblCf2ColorsFarbe.AsInteger;
                 Next;  FclText:=tblCf2ColorsFarbe.AsInteger;
                 Next;  FclSonstiges:=tblCf2ColorsFarbe.AsInteger;
            end;
            SaveColorSettings;
            Scrollbox1.Color:=FclBackground;
     end
     else GetColorSettings;
  finally
     FormCadViewOptions.Free;
  end;

  if (i=mrOk) and (fFileName<>'') then ShowFile(Image1.Picture.Bitmap);
end;

// *********************************************************************************************************************
// *** Zoomen, Rotieren ************************************************************************************************
// *********************************************************************************************************************
procedure TFormCadView.BtnFitToWindowSizeClick(Sender: TObject);
var Sx,Sy:Extended;
begin
  if fFilename='' then exit;

  ScrollBox1.HorzScrollBar.Position:=0;
  ScrollBox1.VertScrollBar.Position:=0;
  try Sx:=(ScrollBox1.Width-Image1.Left-8)/fBildgroesse.x; except exit; end;
  try Sy:=(ScrollBox1.Height-Image1.Top-8)/fBildgroesse.y; except exit; end;
  if Sy<Sx
  then fZoomfaktor:=Sy
  else fZoomfaktor:=Sx;

  SetZoomHints;

  ShowFile(Image1.Picture.Bitmap);
end;

procedure TFormCadView.BtnFullSizeClick(Sender: TObject);
begin
  if fFilename='' then exit;

  ScrollBox1.HorzScrollBar.Position:=0;
  ScrollBox1.VertScrollBar.Position:=0;
  fZoomfaktor:=1;

  SetZoomHints;

  ShowFile(Image1.Picture.Bitmap);
end;

procedure TFormCadView.BtnZoomPlusClick(Sender: TObject);
begin
  if fFilename='' then exit;

  case TComponent(sender).Tag of
    1: begin
         fZoomfaktor:=fZoomfaktor+0.1;
       end;
    2: begin
         fZoomfaktor:=fZoomfaktor-0.1;
         if fZoomfaktor<0.1 then fZoomfaktor:=0.1;
       end;
  end;

  SetZoomHints;

  ShowFile(Image1.Picture.Bitmap);
end;

procedure TFormCadView.SetZoomHints;
var i:integer;
begin
  BtnZoomPlus.Hint:=format('Vergrößern auf %d%s',[RoundToInt(fZoomfaktor*100) + 10,'%']);
  i:=RoundToInt(fZoomfaktor*100) - 10; if i<10 then i:=10;
  BtnZoomMinus.Hint:=format('Verkleinern auf %d%s',[i,'%']);
end;

procedure TFormCadView.BtnRotateRightClick(Sender: TObject);
var help:integer;
begin
  if fFilename='' then exit;

  case TComponent(sender).Tag of
    1: fDrehwinkel:=CheckAngle(fDrehwinkel-90); // im Uhrzeigersinn drehen
    2: fDrehwinkel:=CheckAngle(fDrehwinkel+90);
  end;

  fBildgroesse.X:=RoundUpToInt(fBild.xMax-fBild.xMin);
  fBildgroesse.Y:=RoundUpToInt(fBild.yMax-fBild.yMin);

  if (fDrehwinkel=90) or (fDrehwinkel=270) then begin
     help:=fBildgroesse.X;
     fBildgroesse.X:=fBildgroesse.Y;
     fBildgroesse.Y:=help;
  end;

  if fZoomfaktor=1
  then BtnFullSizeClick(sender)
  else BtnFitToWindowSizeClick(sender);
end;

// *********************************************************************************************************************
// *** Drucken *********************************************************************************************************
// *********************************************************************************************************************
procedure TFormCadView.BtnPrintClick(Sender: TObject);
var z:String;
    BM:TBitmap;  // Druck-Bitmap
    MerkeBkColor:TColor;
    MerkeZoomfaktor:Extended;
begin
  if fFilename='' then exit;

  MerkeZoomfaktor:=FZoomfaktor;
  MerkeBkColor:=FclBackground;

  Application.ProcessMessages;
  try
      Druck2:=TDruck2.Create;
      if fAction=5 // 5=Nachkalkulation
      then fZoomfaktor:=Drucken2.PrintCadInit(fBildgroesse,10.0)
      else fZoomfaktor:=Drucken2.PrintCadInit(fBildgroesse,20.0);
      z:='';
      if fFilename=''
      then Drucken2.PrintCAD(fTable,nil,z,fAction>=4,fAction=5)
      else try
              BM:=TBitmap.Create;
//              BM.Monochrome:=true;
              BM.Pixelformat:=pf8bit;
              FPrinting:=true;
              FclBackground:=clWhite; // Hintergrund beim Drucken immer Weiss
              ShowFile(BM);
              z:=format('Datei: %s     %s     Gesamtlänge: %.2f m',[fFilename,LabelBrettgroesse.Caption,fGesamtMeter/1000]);
              Drucken2.PrintCAD(fTable,BM,z,fAction>=4,fAction=5);
           finally
              FPrinting:=false;
              BM.Free;
           end;
  finally
      Druck2.Free;
  end;

  FclBackground:=MerkeBkColor;
  FZoomfaktor:=MerkeZoomfaktor;
end;

procedure TFormCadView.SpeedButton1Click(Sender: TObject);
var fCaption:String;
//    BM:TBitmap;  // Druck-Bitmap
    aPicture:TPicture;
    MerkeBkColor:TColor;
    MerkeZoomfaktor:Extended;
    dpi:TPoint;
    Sx,Sy:Extended;
begin
{
 Was ist noch zu tun:
 - Die Mitarbeiter fehlen noch zu den Positionen
 - Auftragsart fehlt
 - auch für Angebot drucken
 - den Zommfaktor für den Drucker berechnen
}
(*
  MerkeZoomfaktor:=FZoomfaktor;
  MerkeBkColor:=FclBackground;

  with Daten, FormRBuilder do
  try
//      Druck2:=TDruck2.Create;
//      if fAction=5 // 5=Nachkalkulation
//      fZoomfaktor:=Drucken2.PrintCadInit(fBildgroesse,10.0);
//      else fZoomfaktor:=Drucken2.PrintCadInit(fBildgroesse,20.0);
             try
                aPicture:=TPicture.Create;
                aPicture.Bitmap.Pixelformat:=pf8bit;
                FPrinting:=true;
                FclBackground:=clWhite; // Hintergrund beim Drucken immer Weiss
                if fFilename=''
                then fCaption:=''
                else begin
                       ShowFile(aPicture.Bitmap);
                       fCaption:=format('Datei: %s     %s     Stahl gesamt: %.2f m',[fFilename,LabelBrettgroesse.Caption,fGesamtMeter/1000]);
                end;
//                Drucken2.PrintCAD(fTable,BM,z,fAction>=4,fAction=5);
                InitReportList(AuftragSrc, nil, 'Nachkalk.rtm', 'Nachkalkulation');
                plListe.RangeBegin:=rbCurrentRecord;
                plListe.RangeEnd:=reCurrentRecord;
                MyRapFuncs.fPrintPicture:=aPicture; // Bild übergeben
                ppDBPipelineListe2.DataSource:=AufAtbSrc;
                ppDBPipelineListe3.DataSource:=AufPosSrc;
                repListe.Parameters.Items['pTitle'].value:=fCaption;
                repListe.Print;
             finally
                aPicture.Free;
             end;
  finally
//      Druck2.Free;
     FclBackground:=MerkeBkColor;
     FZoomfaktor:=MerkeZoomfaktor;
  end;

*)

  MerkeZoomfaktor:=FZoomfaktor;
  MerkeBkColor:=FclBackground;

  try
     FPrinting:=true;
     FclBackground:=clWhite; // Hintergrund beim Drucken immer Weiss

     aPicture:=TPicture.Create;
     aPicture.Bitmap.Pixelformat:=pf8bit;

     with FormRBuilder do begin
          InitReportList(Daten.AuftragSrc, nil, 'Nachkalk.rtm', 'Nachkalkulation');

          repListe.PrinterSetup.PrinterName:='Default';
          repListe.PrinterSetup.BinName:='Default';
          if fDrehwinkel mod 180 = 0
          then repListe.PrinterSetup.Orientation:=poPortrait
          else repListe.PrinterSetup.Orientation:=poLandscape;

          dpi:=repListe.Printer.PixelsPerInch;

//          try Sx:=((repListe.PrinterSetup.PaperWidth - 2*15)  * dpi.X/25.4) / fBildgroesse.x; except Sx:=1; end;
//          try Sy:=((repListe.PrinterSetup.PaperHeight - 2*15) * dpi.Y/25.4) / fBildgroesse.y; except Sy:=1; end;
          try Sx:=((80 - 2*15)  * dpi.X/25.4) / fBildgroesse.x; except Sx:=1; end;
          try Sy:=((80 - 2*15) * dpi.Y/25.4) / fBildgroesse.y; except Sy:=1; end;
          if Sy<Sx
          then fZoomfaktor:=Sy
          else fZoomfaktor:=Sx;

          Showmessage(format('DPI= %d x %d   Breite=%.2f   Höhe=%.2f  ',[dpi.X,dpi.y, repListe.PrinterSetup.PaperWidth,repListe.PrinterSetup.PaperHeight]));

          ShowFile(aPicture.Bitmap);

          MyRapFuncs.fPrintPicture:=aPicture; // Bild übergeben
          plListe.RangeBegin:=rbCurrentRecord;
          plListe.RangeEnd:=reCurrentRecord;
          ppDBPipelineListe2.DataSource:=Daten.AufAtbSrc;
          ppDBPipelineListe3.DataSource:=Daten.AufPosSrc;
          repListe.Parameters.Items['pTitle'].value:=format('Datei: %s     %s     Gesamtlänge: %.2f m',[fFilename,LabelBrettgroesse.Caption,fGesamtMeter/1000]);

          repListe.DeviceType:=dtScreen;
          repListe.Print;
     end;
  finally
     aPicture.Free;

     FPrinting:=false;
     FclBackground:=MerkeBkColor;
     FZoomfaktor:=MerkeZoomfaktor;
  end;
end;

// *********************************************************************************************************************
// *** Datenimport *****************************************************************************************************
// *********************************************************************************************************************
procedure TFormCadView.DatenimportAuftrag;

  procedure WriteBssMeter;
  var i,p:integer;
      z,zJoker:string;
      bEinArtikelGefunden:Boolean;
  begin
    if tblCF2Artikel.Active then begin // d.h. mindestens ein Artikel ist in temporären Tabelle tblCF2Artikel
       bEinArtikelGefunden:=false;
       // Meterwerte aus der LT-Liste den temp. Artikeln zuordnen
       for i:=0 to LT.Count-1 do begin
           z:=LT.Names[i];  // "Breite-Typ-Hilfstyp" oder nur "Breite-Typ". 0-Punkt-Artikel sind in LT nicht enthalten, können also *-Artikeln nicht zugeordnet werden.
           zJoker:=z;
           p:=Pos('-',zJoker);
           if p>0 then zJoker:='*' + copy(zJoker, p, 100);
           if (tblCF2Artikel.Locate('CF2Params', z, [])) or // erst versuchen einen Artikel mit der angegebenen Breite zu finden
              (tblCF2Artikel.Locate('CF2Params', zJoker, [])) then begin // wenn erfolglos, dann einen mit der Wildcard-Breite
              tblCF2Artikel.Edit;
              tblCF2ArtikelMeter.AsFloat:=tblCF2ArtikelMeter.AsFloat + StrToFloat(LT.ValueFromIndex[i]);
              tblCF2Artikel.Post;
              bEinArtikelGefunden:=true;
           end;
       end;

       // AufPos nur dann durchgehen, wenn mindestens einem temp. Artikel ein Meterwert zugeordnet wurde
       if bEinArtikelGefunden then begin
          with daten do begin
               AufPos.First;
               while not AufPos.eof do begin
                     if (AufPosTyp.AsString='A') and // A=Artikel
                        (AnsiUpperCase(AufPosEinheit.AsString)='M') and // M=Meter
                        (tblCF2Artikel.Locate('Pos', AufPosPos.AsInteger, [])) and // den identischen Artikel finden
                        (not tblCF2ArtikelMeter.IsNull) then begin // d.h. dem Artikel wurde ein Meterwert zugeordnet
                        AufPos.Edit;
                        if fBssMeterAufrunden
                        then AufPosSollmenge.AsFloat:=Ceil(tblCF2ArtikelMeter.AsFloat / 1000) // auf volle Meter aufrunden
                        else AufPosSollmenge.AsFloat:=Round2Dec(tblCF2ArtikelMeter.AsFloat / 1000); // mm in Meter umrechnen
                     end;
                     AufPos.Next;
               end;
          end;
       end;
       tblCF2Artikel.Close;
    end;
  end;


var z:string;
//    z0,z1:string;
//    i:integer;
    b1,b2:TBookmark;
    bBrettGroesseGeschrieben, bPerfaGeschrieben, bResyGeschrieben:Boolean;
    fRandLasern:Extended; // die Holzgröße in Meter
begin
  with Daten do
  try
       AufAtb.Refresh;
       Artikel.Refresh;

       b1:=AufATB.Bookmark;
       b2:=AufPos.Bookmark;
       AufPos.DisableControls;
       Artikel.DisableControls;

       AufATB.First;
       while not AufATB.eof do begin // alle Produkte durchgehen
             if not AufAtbCf2Datei.IsNull then begin
                if FileExists(concat(VorgabenCadPath.AsString,'\',AufAtbCf2Datei.AsString)) then begin
                   fFilename:=AufAtbCF2Datei.AsString;
                   fFullFilename:=concat(fPath,'\',fFilename);

                   ReadFile;

                   AufPos.Refresh;
                   AufPos.First;

                   tblCF2Artikel.Close;

                   bBrettGroesseGeschrieben:=false;
                   bPerfaGeschrieben:=false;
                   bResyGeschrieben:=false;
                   fRandLasern:=2*fBrettgroesse.X + 2*fBrettgroesse.Y;
                   while not AufPos.eof do begin
                         if AufPosTyp.AsString='A' then begin // A=Artikel
                            // Brettgröße
                            if AnsiUpperCase(AufPosEinheit.AsString)='QM'
                            then begin
                                   if not bBrettGroesseGeschrieben then begin
                                      AufPos.Edit;
                                      try AufPosSollmengeDim1.AsInteger:=fBrettgroesse.X; except AufPosSollmengeDim1.Clear; end;
                                      try AufPosSollmengeDim2.AsInteger:=fBrettgroesse.Y; except AufPosSollmengeDim2.Clear; end;
                                      AufPosSollmengeDim3.Clear;
                                      AufPosSollmenge.AsFloat:=fBrettgroesse.X/1000 * fBrettgroesse.Y/1000;
                                      bBrettGroesseGeschrieben:=true;
                                   end;
                            end
{
                            // Schneidmeter
                            else if (AnsiUpperCase(AufPosEinheit.AsString)='M') and
                                    (Artikel.Locate('ArtikelNr',AufPosNr.AsString,[])) and
                                    (ArtikelBreite.AsString<>'') then begin
                                    z0:=ArtikelBreite.AsString+'-'+ArtikelLinientyp.AsString;
                                    if fHilfstypAktiv then begin
                                       if ArtikelHilfstyp.AsString=''
                                       then z0:=z0+'-0'
                                       else z0:=z0+'-'+ArtikelHilfstyp.AsString;
                                    end;
                                    z1:=LT.Values[z0];
                                    if z1<>'' then begin
                                       i:=LT.IndexOfName(z0); if i>-1 then LT.Delete(i);
                                       AufPos.Edit;
                                       if fBssMeterAufrunden
                                       then AufPosSollmenge.AsFloat:=Ceil(StrToFloat(z1)/1000) // mm auf volle Meter aufrunden
                                       else AufPosSollmenge.AsFloat:=StrToFloat(z1)/1000; // mm in Meter umrechnen
                                    end;
                            end
}
                            // Schneidmeter (geändert: 14.12.2009)
                            else if (AnsiUpperCase(AufPosEinheit.AsString)='M') and
                                    (Artikel.Locate('ArtikelNr',AufPosNr.AsString,[])) and
                                    (ArtikelBreite.AsString<>'') and
                                    (ArtikelLinientyp.AsString<>'') then begin
                                    z:=ArtikelBreite.AsString+'-'+ArtikelLinientyp.AsString;
                                    if fHilfstypAktiv then begin
                                       if ArtikelHilfstyp.AsString=''
                                       then z:=z+'-0'
                                       else z:=z+'-'+ArtikelHilfstyp.AsString;
                                    end;
                                    with tblCF2Artikel do begin
                                         if not Active then Open;
                                         Append; // Artikel in die temp. Tabelle tblCF2Artikel eintragen
                                         tblCF2ArtikelPos.Assign(AufPosPos);
                                         tblCF2ArtikelCF2Params.AsString:=z;
                                         Post;
                                    end;
                            end
                            // Perfa- und Resy-Stückzahlen
                            else if (pos('ST', AnsiUpperCase(AufPosEinheit.AsString))=1) and // ST=Stück oder Stk oder Stck
                                    (Artikel.Locate('ArtikelNr',AufPosNr.AsString,[])) then begin
                                    z:=ArtikelHilfstyp.AsString;
                                    if z<>'' then begin
                                       if fPerfaHilfstypNr=z then begin
                                          if not bPerfaGeschrieben then begin
                                             AufPos.Edit;
                                             AufPosSollmenge.AsFloat:=fPerfaCount;
                                             bPerfaGeschrieben:=true;
                                          end;
                                       end
                                       else if fResyHilfstypNr=z then begin
                                               if not bResyGeschrieben then begin
                                                  AufPos.Edit;
                                                  AufPosSollmenge.AsFloat:=fResyCount;
                                                  bResyGeschrieben:=true;
                                               end;
                                       end;
                                    end;
                            end;
                         end

                         else if AufPosTyp.AsString='M' then begin // Lasermeter bei maschineller Leistung eintragen
                                 z:=AufPosNr.AsString;
                                 if z<>'' then begin
                                    if z=VorgabenNrPkt1.AsString then begin
                                       AufPos.Edit;
                                       AufPosSollmenge.AsFloat:=Round2Dec(fPkt1/1000);
                                       fPkt1:=0;
                                    end
                                    else if z=VorgabenNrPkt2.AsString then begin
                                            AufPos.Edit;
                                            AufPosSollmenge.AsFloat:=Round2Dec(fPkt2/1000);
                                            fPkt2:=0;
                                         end
                                    else if z=VorgabenNrPkt3.AsString then begin
                                            AufPos.Edit;
                                            AufPosSollmenge.AsFloat:=Round2Dec(fPkt3/1000);
                                            fPkt3:=0;
                                    end
                                    else if z=VorgabenNrPkt4.AsString then begin
                                            AufPos.Edit;
                                            AufPosSollmenge.AsFloat:=Round2Dec(fPkt4/1000);
                                            fPkt4:=0;
                                    end
                                    else if z=VorgabenNrRandLasern.AsString then begin
                                            AufPos.Edit;
                                            AufPosSollmenge.AsFloat:=Round2Dec(fRandLasern/1000);
                                            fRandLasern:=0;
                                    end;
                                 end;
                         end;

                         AufPos.Next;
                   end; // while not AufPos.eof

                   WriteBssMeter;

                end; // FileExists
             end;
             AufATB.Next;
       end;
  finally
       try AufATB.Bookmark:=b1; except end;
       try AufPos.Bookmark:=b2; except end;
       with Artikel do while ControlsDisabled do EnableControls;
       with AufPos do while ControlsDisabled do EnableControls;
  end;
end;


procedure TFormCadView.DatenimportAngebot;

  procedure WriteBssMeter;
  var i,p:integer;
      z,zJoker:string;
      bEinArtikelGefunden:Boolean;
  begin
    if tblCF2Artikel.Active then begin // d.h. mindestens ein Artikel ist in temporären Tabelle tblCF2Artikel
       bEinArtikelGefunden:=false;
       // Meterwerte aus der LT-Liste den temp. Artikeln zuordnen
       for i:=0 to LT.Count-1 do begin
           z:=LT.Names[i];  // "Breite-Typ-Hilfstyp" oder nur "Breite-Typ". 0-Punkt-Artikel sind in LT nicht enthalten, können also *-Artikeln nicht zugeordnet werden.
           zJoker:=z;
           p:=Pos('-',zJoker);
           if p>0 then zJoker:='*' + copy(zJoker, p, 100);
           if (tblCF2Artikel.Locate('CF2Params', z, [])) or // erst versuchen einen Artikel mit der angegebenen Breite zu finden
              (tblCF2Artikel.Locate('CF2Params', zJoker, [])) then begin // wenn erfolglos, dann einen mit der Wildcard-Breite
              tblCF2Artikel.Edit;
              tblCF2ArtikelMeter.AsFloat:=tblCF2ArtikelMeter.AsFloat + StrToFloat(LT.ValueFromIndex[i]);
              tblCF2Artikel.Post;
              bEinArtikelGefunden:=true;
           end;
       end;

       // AngPos nur dann durchgehen, wenn mindestens einem temp. Artikel ein Meterwert zugeordnet wurde
       if bEinArtikelGefunden then begin
          with Daten do begin
               AngPos.First;
               while not AngPos.eof do begin
                     if (AngPosTyp.AsString='A') and // A=Artikel
                        (AnsiUpperCase(AngPosEinheit.AsString)='M') and // M=Meter
                        (tblCF2Artikel.Locate('Pos', AngPosPos.AsInteger, [])) and // den identischen Artikel finden
                        (not tblCF2ArtikelMeter.IsNull) then begin // d.h. dem Artikel wurde ein Meterwert zugeordnet
                        AngPos.Edit;
                        if fBssMeterAufrunden
                        then AngPosSollmenge.AsFloat:=Ceil(tblCF2ArtikelMeter.AsFloat / 1000) // auf volle Meter aufrunden
                        else AngPosSollmenge.AsFloat:=Round2Dec(tblCF2ArtikelMeter.AsFloat / 1000);  // mm in Meter umrechnen
                     end;
                     AngPos.Next;
               end;
          end;
       end;
       tblCF2Artikel.Close;
    end;
  end;


var z:string;
//    z0,z1:string;
//    i:integer;
    b1,b2:TBookmark;
    bBrettGroesseGeschrieben, bPerfaGeschrieben, bResyGeschrieben:Boolean;
    fRandLasern:Extended; // die Holzgröße
begin
  with Daten do
  try
       AngAtb.Refresh;
       Artikel.Refresh;

       b1:=AngATB.Bookmark;
       b2:=AngPos.Bookmark;
       AngPos.DisableControls;
       Artikel.DisableControls;

       AngATB.First;
       while not AngATB.eof do begin
             if not AngAtbCf2Datei.IsNull then begin
                if FileExists(concat(VorgabenCadPath.AsString,'\',AngAtbCf2Datei.AsString)) then begin
                   fFilename:=AngAtbCf2Datei.AsString;
                   fFullFilename:=concat(fPath,'\',fFilename);

                   ReadFile;

                   AngPos.Refresh;
                   AngPos.First;

                   tblCF2Artikel.Close;

                   bBrettGroesseGeschrieben:=false;
                   bPerfaGeschrieben:=false;
                   bResyGeschrieben:=false;
                   fRandLasern:=2*fBrettgroesse.X + 2*fBrettgroesse.Y;
                   while not AngPos.eof do begin
                         if AngPosTyp.AsString='A' then begin
                            // Brettgröße
                            if AnsiUpperCase(AngPosEinheit.AsString)='QM'
                            then begin
                                   if not bBrettGroesseGeschrieben then begin
                                      AngPos.Edit;
                                      try AngPosSollmengeDim1.AsInteger:=fBrettgroesse.X; except AngPosSollmengeDim1.Clear; end;
                                      try AngPosSollmengeDim2.AsInteger:=fBrettgroesse.Y; except AngPosSollmengeDim2.Clear; end;
                                      AngPosSollmengeDim3.Clear;
                                      AngPosSollmenge.AsFloat:=fBrettgroesse.X/1000 * fBrettgroesse.Y/1000;
                                      bBrettGroesseGeschrieben:=true;
                                   end;
                            end
{
                            // Schneidmeter
                            else if (AnsiUpperCase(AngPosEinheit.AsString)='M') and
                                    (Artikel.Locate('ArtikelNr',AngPosNr.AsString,[])) and
                                    (ArtikelBreite.AsString<>'') then begin
                                    z0:=ArtikelBreite.AsString+'-'+ArtikelLinientyp.AsString;
                                    if fHilfstypAktiv then begin
                                       if ArtikelHilfstyp.AsString=''
                                       then z0:=z0+'-0'
                                       else z0:=z0+'-'+ArtikelHilfstyp.AsString;
                                    end;
                                    z1:=LT.Values[z0];
                                    if z1<>'' then begin
                                       i:=LT.IndexOfName(z0); if i>-1 then LT.Delete(i);
                                       AngPos.Edit;
                                       if fBssMeterAufrunden
                                       then AngPosSollmenge.AsFloat:=Ceil(StrToFloat(z1)/1000) // mm auf volle Meter aufrunden
                                       else AngPosSollmenge.AsFloat:=StrToFloat(z1)/1000; // mm in Meter umrechnen
                                    end;
                            end
}
                            // Schneidmeter (geändert: 14.12.2009)
                            else if (AnsiUpperCase(AngPosEinheit.AsString)='M') and
                                    (Artikel.Locate('ArtikelNr',AngPosNr.AsString,[])) and
                                    (ArtikelBreite.AsString<>'') and
                                    (ArtikelLinientyp.AsString<>'') then begin
                                    z:=ArtikelBreite.AsString+'-'+ArtikelLinientyp.AsString;
                                    if fHilfstypAktiv then begin
                                       if ArtikelHilfstyp.AsString=''
                                       then z:=z+'-0'
                                       else z:=z+'-'+ArtikelHilfstyp.AsString;
                                    end;
                                    with tblCF2Artikel do begin
                                         if not Active then Open;
                                         Append; // Artikel in die temp. Tabelle tblCF2Artikel eintragen
                                         tblCF2ArtikelPos.Assign(AngPosPos);
                                         tblCF2ArtikelCF2Params.AsString:=z;
                                         Post;
                                    end;
                            end

                            // Perfa- und Resy-Stückzahlen
                            else if (pos('ST', AnsiUpperCase(AngPosEinheit.AsString))=1) and // ST=Stück oder Stk oder Stck
                                    (Artikel.Locate('ArtikelNr',AngPosNr.AsString,[])) then begin
                                    z:=ArtikelHilfstyp.AsString;
                                    if z<>'' then begin
                                       if fPerfaHilfstypNr=z then begin
                                          if not bPerfaGeschrieben then begin
                                             AngPos.Edit;
                                             AngPosSollmenge.AsFloat:=fPerfaCount;
                                             bPerfaGeschrieben:=true;
                                          end;
                                       end
                                       else if fResyHilfstypNr=z then begin
                                               if not bResyGeschrieben then begin
                                                  AngPos.Edit;
                                                  AngPosSollmenge.AsFloat:=fResyCount;
                                                  bResyGeschrieben:=true;
                                               end;
                                       end;
                                    end;
                            end;
                         end

                         else if AngPosTyp.AsString='M' then begin // Lasermeter bei maschineller Leistung eintragen
                                 z:=AngPosNr.AsString;
                                 if z<>'' then begin
                                    if z=VorgabenNrPkt1.AsString then begin
                                       AngPos.Edit;
                                       AngPosSollmenge.AsFloat:=Round2Dec(fPkt1/1000);
                                       fPkt1:=0;
                                    end
                                    else if z=VorgabenNrPkt2.AsString then begin
                                            AngPos.Edit;
                                            AngPosSollmenge.AsFloat:=Round2Dec(fPkt2/1000);
                                            fPkt2:=0;
                                         end
                                    else if z=VorgabenNrPkt3.AsString then begin
                                            AngPos.Edit;
                                            AngPosSollmenge.AsFloat:=Round2Dec(fPkt3/1000);
                                            fPkt3:=0;
                                    end
                                    else if z=VorgabenNrPkt4.AsString then begin
                                            AngPos.Edit;
                                            AngPosSollmenge.AsFloat:=Round2Dec(fPkt4/1000);
                                            fPkt4:=0;
                                    end
                                    else if z=VorgabenNrRandLasern.AsString then begin
                                            AngPos.Edit;
                                            AngPosSollmenge.AsFloat:=Round2Dec(fRandLasern/1000);
                                            fRandLasern:=0;
                                    end;
                                 end;
                         end;
                         AngPos.Next;
                   end; // while not AngPos.eof

                   WriteBssMeter;

                end; // FileExists
             end;
             AngATB.Next;
       end;
  finally
       try AngATB.Bookmark:=b1; except end;
       try AngPos.Bookmark:=b2; except end;
       with Artikel do while ControlsDisabled do EnableControls;
       with AngPos do while ControlsDisabled do EnableControls;
  end;
end;


procedure TFormCadView.Nachkalkulation;
var fGefunden:Boolean;
    b1,b2:TBookmark;
begin
  fGefunden:=false;
  fFilename:='';
  fFullFilename:='';
  with daten, AufAtb do
  try
      Refresh;
      b1:=AufATB.Bookmark;
      b2:=AufPos.Bookmark;
      AufATB.DisableControls;
      try
          first;
          while not eof do begin // die erste gültige CF2-Datei finden
                if (not AufAtbCf2Datei.IsNull) and
                   (FileExists(concat(VorgabenCadPath.AsString,'\',AufAtbCf2Datei.AsString))) then begin
                   fFilename:=AufAtbCF2Datei.AsString;
                   fFullFilename:=concat(fPath,'\',fFilename);
                   fGefunden:=true;
                   break;
                end;
                next;
          end;
      finally
          AufATB.First;
          with AufATB do while ControlsDisabled do EnableControls;
          AufPos.DisableControls;
          if fGefunden then ReadFile;
          BtnPrintClick(nil);
      end;
  finally
      try AufATB.Bookmark:=b1; except end;
      try AufPos.Bookmark:=b2; except end;
      with AufPos do while ControlsDisabled do EnableControls;
  end;
end;

{
Verbesserungen:
30.12.2009
- für AufPosSollmenge.AsFloat die Meterzahlen auf 2 Dezimalstellen runden

14.12.2009:
- im Artikelstamm kann bei CF2-Breite das Wildcard-Zeichen * statt (1,2,3,4 Punkt) eingegeben werden.
  Fehlt im Auftrag ein Artikel mit der genauen Pointage, ist aber ein Joker-Artikel (gleicher Typ vorausgesetzt: Messer, Riller, Ritzer etc.) enthalten,
  dann werden beim Datenimport diesem die Meter zugeschrieben.

07.02.2009:
- Bug behoben: Kreisbogenlänge war für Winkel zwischen 181 und 359 Grad zu klein
- zu große Brettgröße, wenn Text ausßerhalb des Brettes stand
- neu: Farben für Messertypen selbst festlegen
- neu: Rotieren, auch mit Links/Rechts-Tasten
- neu: Zoomen, auch mit Plus/Minus-Tasten
- Optional: Brücken werden gezeichnet (nur bei Linien. Kreise sind mir zu schwierig)
- Optional: Pen.Width der Messerbreite angepasst
- Textausgabe verbessert (Winkel stimmen jetzt, Textposition von BottomLine und nicht mehr von TopLine)
- Text genauer skaliert (Schrifthöhe und Zeichenbreite). Zoomfaktor berücksichtigt.
- Text in Spiegelschrift.
- Text beim Drucken nicht mehr zu klein
- Drucken: Hintergrundfarbe immer auf Weiss setzen. Weisse Linien automatisch mit Schwarz zeichnen.
- Wenn das Fenster als Vollbild startet, war die Imagegröße und damit dann die Zeichnung noch auf der Große des Normalfensters
- Kreise besser malen. Manchmal erscheinen merkwürdige Kringel, die beim Größer-Zoomen teilweise verschwinden. Erledigt.


noch zu verbessern:
- Drucken mit ReportBuilder. Damit dann Druckvorschau und PDF-Ausgabe. Unit Drucken2 dann entfernen.
- Skalierung (fScale) wird bisher garnicht berücksichtigt
- Lineale oben und links
}

end.
