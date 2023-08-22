{ Copyright (C) 2008 Dr. Günther Weißbach & Toolbox, alle Rechte vorbehalten

  Ellipsoid-Kenndaten einer Auswahl häufig gebrauchter Erdellipsoide
     
  Prozeduren und Funktionen zur Berechnung und Wandlung von Eingebe-, Ausgabe- 
  und Hilfsgrößen für geodätische Rechnungen.
}
unit WbGMS;

interface

uses
  Windows, SysUtils, Math;

type
  TEllipsoid = record
    Name: String;
    a, f: Extended;
  end;
  
const
  Ellipsoid: array[0..17] of TEllipsoid = (
    (Name: 'Airy 1830            '; a: 6377563.396; f: 299.3249646  ),
    (Name: 'Bessel 1841          '; a: 6377397.155; f: 299.1528128  ),
    (Name: 'Clarke 1866 (NAD 27) '; a: 6378206.4  ; f: 294.9786982  ),
    (Name: 'Clarke 1880          '; a: 6378249.145; f: 293.465      ),
    (Name: 'Everest 1830         '; a: 6377276.345; f: 300.8017     ),
    (Name: 'Fischer 1960         '; a: 6378166.0  ; f: 298.3        ),
    (Name: 'Fischer 1968         '; a: 6378150.0  ; f: 298.3        ),
    (Name: 'GRS 1967             '; a: 6378160.0  ; f: 298.247167427),
    (Name: 'GRS 1975             '; a: 6378140.0  ; f: 298.257      ),
    (Name: 'GRS 1980 (NAD 83)    '; a: 6378137.0  ; f: 298.257222101),
    (Name: 'Hough 1956           '; a: 6378270.0  ; f: 297.0        ),
    (Name: 'International (ED 50)'; a: 6378388.0  ; f: 297.0        ),
    (Name: 'Krassovsky           '; a: 6378245.0  ; f: 298.3        ),
    (Name: 'South American 1969  '; a: 6378160.0  ; f: 298.25       ),
    (Name: 'WGS 60               '; a: 6378165.0  ; f: 298.3        ),
    (Name: 'WGS 66               '; a: 6378145.0  ; f: 298.25       ),
    (Name: 'WGS 72               '; a: 6378135.0  ; f: 298.26       ),
    (Name: 'WGS 84               '; a: 6378137.0  ; f: 298.257223563));

function NormNum(s: String): String;  
function KillSpace(s: String): String;
function GzB(wig: Extended): Extended;
function BzG(wib: Extended): Extended;
function FormWinkel(wi: Extended; WForm, m, n, k: Integer): String;
function vDegToDMS(wi: Extended; k: Integer): String;
function vDegToDM(wi: Extended; k: Integer): String;
function sDMToDeg(s: String): Extended;
function sDMSToDeg(s: String): Extended;
procedure EingabeGeo(n: Integer; sLa, sLo: String; var La, Lo: Extended); 
procedure GitterKW(bFix: Boolean; n: Integer; var Lo, MM: Extended; 
                                                               var KZ: Integer);

implementation

{==============================================================================}
{ NormNum entfernt alle nichtnumerischen Zeichen aus einem String und tauscht  }
{ den DecimalSeparator ',' gegen '.' aus.                                      }
{==============================================================================}
function NormNum(s: String): String;
var i: Integer;
begin
  result := '';
  while pos(',', s) > 0 do s[pos(',', s)] := '.';
  for i := 1 to Length(s) do
    if Ord(s[i]) in[$2D,$2E,$30..$39] then result := result + s[i];
end;

{==============================================================================}
{ KillSpace entfernt alle Leerzeichen aus einer Zeichenkette                   }
{==============================================================================}
function KillSpace(s: String): String;
begin
  while POS(' ',s) > 0 do delete(s,POS(' ',s),1);
  result := s;
end;

{==============================================================================}
{ GzB (Grad-zu-Bogen) wandelt einen Winkel vom Gradmaß ins Bogenmaß            }
{==============================================================================}
function GzB(wig: Extended): Extended;
begin
  result := wig*pi/180;
end;

{==============================================================================}
{ BzG (Bogen-zu-Grad) wandelt einen Winkel vom Bogenmaß ins Gradmaß            }
{==============================================================================}
function BzG(wib: Extended): Extended;
begin
  result := wib*180/pi;
end;

{==============================================================================}
{ Die Funktion FormWinkel wandelt einen dezimalen Winkelwert in einen String   }
{ verschiedener Ausgabeformate um.                                             }
{ Die Art der Umwandlung wird durch den Integerwert WForm (0..2) gesteuert.    }
{   Wform = 0: dd.dddddd,                                                      }
{   Wform = 1: dd mm.mmmm oder                                                 }
{   Wform = 2: dd mm ss.s                                                      }
{ m (2, 3) steuert die Anzahl der Stellen (ggf. führenden Nullen) des          }
{ Grad-Wertes (2: Breite, 3: Länge).                                                                 }
{   m = 2: 3 --> 03                                                            }
{   m = 3: 3 --> 003 und 13 --> 013                                            }
{ Durch n werden ggf. Bezeichner eingefügt                                     }
{   n = 0: Zahlenwerte DMS werden einfach aneinandner gefügt.                  }
{   n = 1: In den Ausgangsstring werden die Zeichen °, ', und " eingefügt.     }
{ Mit k kann die Zahl der Dezimalstellen des zuletzt stehenden Wertes (Grad,   }
{ Minute oder Sekunde festgelegt werden.                                       }
{ Mit k = -1 wird die Zahl der Dezimalstellen für Grad konstant auf 6, für     }
{ Minuten konstant 4 und für Sekunden konstant auf 1 gesetzt                   }
{==============================================================================}
function FormWinkel(wi: Extended; WForm, m, n, k: Integer): String;
var
  iDeg, iMin: Integer;
  fMin, fSec: Extended;
  s, sf: String;
begin
  wi := ABS(wi);
  sf := Format('%s%1.0dn',['%.1',k]);
  case WForm of
    0:  begin                                                     // dd.dddddd
          if k = -1 then k := 6;
          sf := Format('%s%1.0dn',['%.',k]);
          if n = 0 then result := Format(sf,[wi])
                   else result := Format(sf + '°',[wi]);
          if wi < 10 then s := '0' + s;
        end;
    1:  begin                                                     // ddmm.mmmm
          if k = -1 then k := 4;
          sf := Format('%s%1.0dn',['%.',k]);
          fMin := Abs(60*wi);                         // Winkel in Minuten ...
          fMin := RoundTo(fMin,-k);                     // ... werden gerundet
          iDeg := Trunc(fMin/60);                           // Grad als min/60
          fMin := fMin - 60*iDeg;                    // Minuten ableiben übrig
          s := Format(sf,[fMin]);
          if fMin < 10 then s := '0' + s;
          if n = 0 then result := Format('%*.*d %s',[m,m,iDeg,s])
                   else result := Format('%*.*d° %s''',[m,m,iDeg,s]);
        end ;
    2:  begin                                                      // ddmmss.s
          if k = -1 then k := 2;
          sf := Format('%s%1.0dn',['%.',k]);
          fSec := ABS(3600*wi);                     // Winkel in Sekunden, ...
          fSec := RoundTo(fSec,-k);                     // ... werden gerundet
          iDeg := Trunc(fSec/3600);                  // Grad als Sekunden/3600
          fSec := fSec - 3600*iDeg;    // Minutenwert in Sekunden bleibt übrig
          iMin := Trunc(fSec/60);           // ganze Minuten werden abgetrennt
          fSec := fSec - 60*iMin;                    // Sekunden bleiben übrig
          s := Format(sf,[fSec]);
          if fSec < 10 then s := '0' + s;
          if n = 0 then result := Format('%*.*d%2.2d%s',[m,m,iDeg,iMin,s])
                   else result := Format('%*.*d° %2.2d'' %s"',[m,m,iDeg,iMin,s]);
        end ;
  end;
end;

{==============================================================================}
{ vDegToDMS wandelt einen dezimalen Winkelwert in die Form (+/-)ddmmss.s mit   }
{ k Dezimalstellen des Sekundenwerts.                                          }
{ Das Vorzeichen des Winkelwerts wird mit übertragen.                          }
{ Parameter: wi: dezimaler Winkelwert, k: Dezimalstellen der Sekunden          }
{ Der Rückgabewert ist ein String der Form ddmmss.s                            }
{==============================================================================}
function vDegToDMS(wi: Extended; k: Integer): String;
var
  sec: Extended;
  deg, min: Integer;
  s, vz, sForm: String;
begin
  if wi < 0 then vz := '-' else vz := '+';
  // Winkelwert zur Rechnung positiv:
  sec := ABS(3600*wi);                              // Winkel in Sekunden, ...
  sec := RoundTo(sec,-k);                               // ... werden gerundet
  deg := Trunc(sec/3600);                            // Grad als Sekunden/3600
  sec := sec - 3600*deg;               // Minutenwert in Sekunden bleibt übrig
  min := Trunc(sec/60);                     // ganze Minuten werden abgetrennt
  sec := sec - 60*min;                               // Sekunden bleiben übrig
  sForm := Format('%s%dn',['%.',k]);
  s := Format(sForm,[sec]);
  // s := FloatToStr(sec);             // weniger schön, aber evtl. sicherer
  if sec < 10 then s := '0' + s;
  // Vorzeichen zufügen:
  result := Format('%s%3.3d%2.2d%s',[vz,deg,min,s]);
end;

{==============================================================================}
{ vDegToDM wandelt einen dezimalen Winkelwert in die Form (+/-)ddmm.mmmm mit   }
{ k Dezimalstellen. Das Vorzeichen des Winkelwerts wird mit Übertragen.        }
{ Parameter: wi: dezimaler Winkelwert, k: Dezimalstellen der Sekunden          }
{ Der Rückgabewert ist ein String der Form ddmm.mmmm                           }
{==============================================================================}
function vDegToDM(wi: Extended; k: Integer): String;
var
  min: Extended;
  deg: Integer;
  s, vz, sForm: String;
begin
  if wi < 0 then vz := '-' else vz := '+';
  // Winkelwert zur Rechnung positiv:
  min := Abs(60*wi);                                  // Winkel in Minuten ...
  min := RoundTo(min,-k);                               // ... werden gerundet
  deg := Trunc(min/60);                                     // Grad als min/60
  min := min - 60*deg;                               // Minuten ableiben übrig
  sForm := Format('%s%dn',['%.',k]);
  s := Format(sForm,[min]);
  // s := FloatToStr(min);               // weniger schön, aber evtl. sicherer
  if min < 10 then s := '0' + s;
  // Vorzeichen zufügen:
  result := Format('%s%3.3d%s',[vz,deg,s]);
end;

{==============================================================================}
{ sDMSToDeg berechnet aus einem String der Form (+/-)ddmmss.s dessen dezimalen }
{ Winkelwert unter Beachtung des Vorzeichens                                   }
{==============================================================================}
function sDMSToDeg(s: String): Extended;
var
  s1, s2: String;
  iPos: Integer;
  Flag: Boolean;
begin
  if Pos('.',s) = 0 then s := s + '.0';
  s := KillSpace(s);
  if Length(s) > 0 then begin
    if s[1] = '-' then begin
      Flag := True;
      delete(s,1,1);
    end else Flag := False;
    if POS('.',s) = 0 then 
      result := 0
    else begin
      iPos := POS('.',s);
      s1 := copy(s,1,iPos - 5);
      s2 := copy(s,iPos - 4,2);
      delete(s,1,iPos - 3);
      result := StrToFloat(s1) + StrToFloat(s2)/60 + StrToFloat(s)/3600;
      if Flag then result := -result;
    end;
  end else result := 0;
end;

{==============================================================================}
{ sDMToDeg berechnet aus einem String der Form (+/-)ddmm.mmmm dessen dezimalen }
{ Winkelwert unter Beachtung des Vorzeichens                                   }
{==============================================================================}
function sDMToDeg(s: String): Extended;
var
  s1: String;
  iPos: Integer;
  Flag: Boolean;
begin
  if Pos('.',s) = 0 then s := s + '.0';
  s := KillSpace(s);
  if Length(s) > 0 then begin
    if s[1] = '-' then begin
      Flag := True;
      delete(s,1,1);
    end else Flag := False;
    if POS('.',s) = 0 then 
      result := 0
    else begin  
      iPos := POS('.',s);
      s1 := copy(s,1,iPos - 3);
      delete(s,1,iPos - 3);
      result := StrToFloat(s1) + StrToFloat(s)/60;
      if Flag then result := -result;
    end;
  end else result := 0;
end;

{==============================================================================}
{ EingabeGeo wandelt die Zeichenketten zweier Winkelwerte sLa, sLo (aus Ein-   }
{ gabefenstern abhängig vom vorgegebenen Winkelformat n in dezimale Gradwerte. }
{ n = 0: dd.dddddd, n = 1: ddmm.mmmm, n = 2: ddmmss.s                          }
{==============================================================================}
procedure EingabeGeo(n: Integer; sLa, sLo: String; var La, Lo: Extended);     
begin                                                              // EingabeGeo
  case n of
    0 : begin
          La := StrToFloat(NormNum(sLa));                            // Breite
          Lo := StrToFloat(NormNum(sLo));                             // Länge
        end;                                     
    1 : begin                                     
          La := sDMToDeg(NormNum(sLa));                              // Breite
          Lo := sDMToDeg(NormNum(sLo));                               // Länge
        end;
    2 : begin
          La := sDMSToDeg(NormNum(sLa));                             // Breite
          Lo := sDMSToDeg(NormNum(sLo));                              // Länge
        end;
  end;
end;                                                          // Ende ReadLatLon

{==============================================================================}
{ GitterKW legt die Gitterkennwerte für die Familie der Gauß-Krüger-Projektio- }
{ nen fest.                                                                    }
{ Abhängig von bFix erfolgt die Festlegung durch den Nutzer oder nach den vor- }
{ gegebenen Regeln.                                                            }
{ n gibt das aktuelle Systeme GK, S42/83 oder UTM an.                          }
{ Ausgabegrößen sind der Mittelmeridian MM und die Kennzahl KZ in Abhängigkeit }             
{ von der geographischen Länge Lo.                                             }
{==============================================================================}
procedure GitterKW(bFix: Boolean; n: Integer; var Lo, MM: Extended; 
                                                               var KZ: Integer);
begin
  Lo := (Lo + 180) - FLOOR((Lo + 180)/360)*360 - 180; // -180.00 .. 179.9;
  if bFix then begin          // Mittelmeridian aus vorgegebener Kennziffer  KZ
    case n of
      0 : MM := 3*KZ;                        // Gauß-Krüger
      1 : MM := 6*KZ - 3;                    // S42/83
      2 : MM := 6*(KZ - 30) - 3;             // UTM
    end;  
  end else begin   // Mittelmeridian und Kennziffer systemgerecht aus Länge Lo
    case n of                    
      0 : begin                              // Gauß-Krüger
            KZ := ROUND(Lo/3);
            MM := 3*KZ;
            if KZ < 0 then KZ := KZ + 120;
          end;
      1 : begin                              // S42/83
            KZ := FLOOR(Lo/6) + 1;
            MM := 6*KZ - 3;
            if KZ <= 0 then KZ := KZ + 60;
          end;
      2 : begin                              // UTM
            KZ := FLOOR((Lo + 180)/6) + 1;
            MM := (6*KZ - 3) - 180;
          end;
    end;
  end;
end;
                    
end.
