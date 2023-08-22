(************************************************************************)
(*                                                                      *)
(*       Präzisionszeitmessung für Windows (32 Bit)                     *)
(*                                                                      *)
(*   (c) 1996-2006 Rainer Reusch & Toolbox                              *)
(*                                                                      *)
(*   Borland Delphi ab 5.0                                              *)
(*                                                                      *)
(****V2.1****************************************************************)

{
Diese Unit stellt Routinen zur Verfügung, um Laufzeitmessungen und
zeitlich gesteuerte Abläufe im Mikrosekundenbereich durchzuführen.
Beachten Sie, daß alle Routinen Eigenzeiten haben, die hier naturgemäß
nicht kompensiert werden können. Beispielsweise sind Verzögerungen
mit PrecDelay nie kürzer als ihre Eigenzeit.

Änderungen in V2.0:
- nur 32 Bit, für Delphi ab V5

Änderungen in V2.1:
- Statt von einer festen Systemfrequenz auszugehen, wird diese nun ermittelt (k).
- Kleine Optimierungen in PrecDelay
- GetDelayMinTime nun öffentlich zugänglich
}

unit Prectime;

interface

uses
  Windows;

procedure PrecCount(var t : int64);
{ Erfassen des Zählerstandes }

function DeltaPrecCount(var t1, t2 : int64) : longint;
{ Liefert die Differenz t2-t1 aus zwei Zählerständen
  Hinweis: Das Funktionsergebnis ist "nur" 32 Bit breit }

function DeltaPrecTime(var t1, t2 : int64) : longint;
{ Liefert die Differenz t2-t1 aus zwei Zählerständen
  als Ergebnis in Mikrosekunden
  Hinweis: Das Funktionsergebnis ist "nur" 32 Bit breit }

procedure PrecDelay(MicroSeconds : longint);
{ Verzögerungsroutine
  mit einer Auflösung in Mikrosekunden
  MicroSeconds darf nicht größer als 1799798562
  (eine knappe halbe Stunde) sein!
  Weiterhin kann sie Zeitangaben unterhalb DelayMinTime nicht umsetzen
  (Verzögerungszeit ist mind. DelayMinTime) }

procedure GetDelayMinTime;
{ Ermittlung der Eigenzeit der PrecDelay-Routine aus 16 Delay-Durchläufen
  (wird automatisch ausgeführt) }

var
  DelayMinTime : longint;   { Nur lesen! Eigenzeit der Delay-Routine
                              in Mikrosekunden. Verzögerungen der PrecDelay-
                              Routine unterhalb dieses Wertes sind nicht
                              möglich. Wert ist rechnerabhängig. }

implementation

var
  k : int64;  // Quarzfrequenz des Timers (1193180Hz)

procedure PrecCount(var t : int64);
begin
  QueryPerformanceCounter(t);
end;

function DeltaPrecCount(var t1, t2 : int64) : longint;
begin
  DeltaPrecCount:=t2-t1;
end;

function DeltaPrecTime(var t1, t2 : int64) : longint;
var
  D : extended;
begin
  D:=t2-t1;
  DeltaPrecTime:=round(1000000*D/k);
end;

procedure PrecDelay(MicroSeconds : longint);
var
  n, t1, t2 : int64;
begin
  if MicroSeconds>DelayMinTime then MicroSeconds:=MicroSeconds-DelayMinTime
                               else MicroSeconds:=0;
  if MicroSeconds>0 then
  begin
    n:=round((k/1000000)*MicroSeconds);
    PrecCount(t1);
    repeat
      PrecCount(t2);
    until (t2-t1)>=n;
  end;
end;

procedure GetDelayMinTime;
{ Ermittlung der Eigenzeit der PrecDelay-Routine aus 16 Delay-Durchläufen }
var
  i : word;
  t : longint;
  TP1, TP2 : int64;
begin
  DelayMinTime:=0;
  PrecDelay(2);
  t:=0;
  for i:=0 to 15 do
  begin
    PrecCount(TP1);
    PrecDelay(2);
    PrecCount(TP2);
    t:=t+DeltaPrecTime(TP1,TP2);
  end;
  DelayMinTime:=(t div 16)-2;
end;

begin
  QueryPerformanceFrequency(k);
  GetDelayMinTime;
end.
