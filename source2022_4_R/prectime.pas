(************************************************************************)
(*                                                                      *)
(*       Pr�zisionszeitmessung f�r Windows (32 Bit)                     *)
(*                                                                      *)
(*   (c) 1996-2006 Rainer Reusch & Toolbox                              *)
(*                                                                      *)
(*   Borland Delphi ab 5.0                                              *)
(*                                                                      *)
(****V2.1****************************************************************)

{
Diese Unit stellt Routinen zur Verf�gung, um Laufzeitmessungen und
zeitlich gesteuerte Abl�ufe im Mikrosekundenbereich durchzuf�hren.
Beachten Sie, da� alle Routinen Eigenzeiten haben, die hier naturgem��
nicht kompensiert werden k�nnen. Beispielsweise sind Verz�gerungen
mit PrecDelay nie k�rzer als ihre Eigenzeit.

�nderungen in V2.0:
- nur 32 Bit, f�r Delphi ab V5

�nderungen in V2.1:
- Statt von einer festen Systemfrequenz auszugehen, wird diese nun ermittelt (k).
- Kleine Optimierungen in PrecDelay
- GetDelayMinTime nun �ffentlich zug�nglich
}

unit Prectime;

interface

uses
  Windows;

procedure PrecCount(var t : int64);
{ Erfassen des Z�hlerstandes }

function DeltaPrecCount(var t1, t2 : int64) : longint;
{ Liefert die Differenz t2-t1 aus zwei Z�hlerst�nden
  Hinweis: Das Funktionsergebnis ist "nur" 32 Bit breit }

function DeltaPrecTime(var t1, t2 : int64) : longint;
{ Liefert die Differenz t2-t1 aus zwei Z�hlerst�nden
  als Ergebnis in Mikrosekunden
  Hinweis: Das Funktionsergebnis ist "nur" 32 Bit breit }

procedure PrecDelay(MicroSeconds : longint);
{ Verz�gerungsroutine
  mit einer Aufl�sung in Mikrosekunden
  MicroSeconds darf nicht gr��er als 1799798562
  (eine knappe halbe Stunde) sein!
  Weiterhin kann sie Zeitangaben unterhalb DelayMinTime nicht umsetzen
  (Verz�gerungszeit ist mind. DelayMinTime) }

procedure GetDelayMinTime;
{ Ermittlung der Eigenzeit der PrecDelay-Routine aus 16 Delay-Durchl�ufen
  (wird automatisch ausgef�hrt) }

var
  DelayMinTime : longint;   { Nur lesen! Eigenzeit der Delay-Routine
                              in Mikrosekunden. Verz�gerungen der PrecDelay-
                              Routine unterhalb dieses Wertes sind nicht
                              m�glich. Wert ist rechnerabh�ngig. }

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
{ Ermittlung der Eigenzeit der PrecDelay-Routine aus 16 Delay-Durchl�ufen }
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
