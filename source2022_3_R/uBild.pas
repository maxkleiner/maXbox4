UNIT uBild;
(* ******************************************************************** *)
(* K L A S S E : TBild                                                  *)
(* -------------------------------------------------------------------- *)
(* Version     : 1.0                                                    *)
(* Autor       : (c) S. Spolwig (OSZ-Handel I)  10997 Berlin            *)
(* Beschreibung: Die Klasse ernmoeglicht Bearbeitung von Bitmap-Bildern *) 
(* Compiler    : Delphi 4.0                                             *)
(* Aenderungen : V. 1.0 - 09-JUL-00                                     *)
(* ******************************************************************** *)

INTERFACE
(* ==================================================================== *)
USES
  graphics,
  classes,
  sysutils;

type
   TBild = class (TBitmap)
            private
             AktuelleZeile  : PByteArray;
             AktZeilenNr,
             AktPos         : Word; // in der Zeile
             BitNum         : 1..8; // von rechts nach links, 1 ist Low

            public
             procedure Init;                 virtual;
             procedure FirstZeile;           virtual;
             procedure NextZeile;            virtual;
             procedure SetAktZeile;          virtual;
             procedure First;                virtual;
             procedure Next;                 virtual;

             function  GetBreite : integer;  virtual;
             function  GetHoehe  : integer;  virtual;
             function  GetZeilenEnde : integer; virtual; // Bildzeile
             function  GetAktPos : integer;  virtual;
             function  IsLastZeile : boolean;virtual;

             procedure SetBitNum (bn : integer);virtual;
             function  GetBitNum : integer;    virtual;
             procedure PutByte (b : byte);     virtual; // aktuelles
             function  GetByte : byte;

             procedure Load (Dateiname : string); virtual;
             procedure Store (Dateiname : string);virtual;
           end;

(* -------------------- B e s c h r e i b u n g -------------------------

Oberklasse    : TBitmap
Bezugsklassen : Classes   import: TFileStream
                Sysutils

Methoden
--------

Set...    : Schreib/Lese-Zugriffe auf Attribute
Get...

Init
   Aufgabe: Positionen zur Bearbeitung init.
   vorher : -
   nachher: AktZeilenNr u. AktPos sind 0

FirstZeile
  Auftrag: Zeilenmarke auf 1. Zeile setzen
  vorher :
  nachher:

NextZeile
  Auftrag: Zeilenmarke auf naechste Zeile setzen
  vorher :
  nachher: AktZeilenNr um 1 erhoeht

SetAktZeile
  Auftrag: aktuelle Zeile aus der Bitmap holen und an AktuelleZeile zuweisen
  vorher :
  nachher:

First
  Auftrag: AktuellePos der AktZeile auf 1. Byte setzen
  vorher :
  nachher:

Next
  Auftrag: AktuellePos um 1 erhoehen
  vorher :
  nachher:

PutByte (b : byte)
  Auftrag: b an der AktuellePos zurueckschreiben
  vorher :
  nachher:
----------------------------------------------------------------------- *)

IMPLEMENTATION
(* ==================================================================== *)
procedure TBild.Init;
(* -------------------------------------------------------------------- *)
begin
  AktZeilenNr := 0;
  AktPos      := 0;
end;

procedure TBild.FirstZeile;
(* -------------------------------------------------------------------- *)
begin
  AktZeilenNr := 0;
end;

procedure TBild.NextZeile;
(* -------------------------------------------------------------------- *)
begin
  if AktZeilenNr < GetHoehe
  then inc(AktZeilenNr);
end;


procedure TBild.SetAktZeile;
(* -------------------------------------------------------------------- *)
begin
   Aktuellezeile := ScanLine[AktZeilenNr];
   First;
end;


procedure TBild.First;
(* -------------------------------------------------------------------- *)
begin
  AktPos := 1;
end;

procedure TBild.Next;
(* -------------------------------------------------------------------- *)
begin
 if AktPos < Width
 then inc(AktPos);
end;

function  TBild.GetAktPos : integer;
(* -------------------------------------------------------------------- *)
begin
  Result := AktPos;
end;


function  TBild.GetBreite : integer;
(* -------------------------------------------------------------------- *)
begin
  Result := width;
end;

function  TBild.GetHoehe : integer;
(* -------------------------------------------------------------------- *)
begin
  Result := Height;
end;

function  TBild.GetZeilenEnde : integer;
(* -------------------------------------------------------------------- *)
begin
  Result := Width - 1;
end;

function  TBild.IsLastZeile : boolean;
(* -------------------------------------------------------------------- *)
begin
  Result := false;
  if AktZeilenNr = Height - 2
  then Result := true;
end;


procedure TBild.PutByte (b : byte);
(* -------------------------------------------------------------------- *)
begin
  AktuelleZeile[AktPos] := b;
end;


function  TBild.GetByte : byte;
(* -------------------------------------------------------------------- *)
begin
  Result  := AktuelleZeile[AktPos];
end;


procedure TBild.SetBitNum (bn : integer);
(* -------------------------------------------------------------------- *)
begin
  BitNum := bn;
end;


function  TBild.GetBitNum : integer;
(* -------------------------------------------------------------------- *)
begin
  Result := BitNum;
end;


procedure TBild.Load (Dateiname : string);
(* -------------------------------------------------------------------- *)
begin
  LoadFromFile( Dateiname);
end;


procedure TBild.Store(Dateiname : string);
(* -------------------------------------------------------------------- *)
begin
  SaveToFile(Dateiname);
end;


END.
