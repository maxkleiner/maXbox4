
                             UNIT NavUtils;

                               INTERFACE


type
  TPos = (tLat, tLon);
  TShowFmt = (sfNautical, sfStatute, sfMetric);

const
  OneEighty  = 180*3600;                         // Sec of arc
  ThreeSixty = 360*3600;                         //

function CoordinateStr(Idx: Integer; PosInSec: Double; PosLn: TPos): string;
function UserUnits(Val: Double; sUnit: Char; ShowFmt: TShowFmt): string;
function MagCourse(TC, MV: Double): Double;



                             IMPLEMENTATION

uses
  SysUtils;


{Formats Position in sec into lat or lon string per Idx selection}

function CoordinateStr(Idx: Integer; PosInSec: Double; PosLn: TPos): string;

const
  FmtStrArray: array[tLat..tLon, 0..3] of string =

 { Lat }  (('%s %d %.2d %.2d',  '%s %d %.2d.%4:.2d',     '%s %5:.4f',
               // D M S               D M.m                 D.d

                      '%1:.2d%2:.2d.%4:.2d,%0:s'),
                        //  Waypoint per NMEA

 { Lon }   ('%s %d %.2d %.2d',  '%s %d %.2d.%4:.2d',     '%s %5:.4f',

                      '%1:.3d%2:.2d.%4:.2d,%0:s'));

var
  Pos, Deg, Min, Sec, Dec: Integer;
  Dd: Double;
  C: Char;
begin
  if (PosInSec > OneEighty) then
    PosInSec := PosInSec - ThreeSixty;

  case PosLn of
    tLat: if (PosInSec <= 0) then C := 'S' else C := 'N';
    tLon: if (PosInSec <= 0) then C := 'W' else C := 'E';
  end; {case}

  PosInSec := Abs(PosInSec);
  Dd  := PosInSec/3600;                          // DDD.ddd..
  Pos := Round(PosInSec);
  Deg := (Pos div 3600);                         // DDD
  Min := (Pos mod 3600) div 60;                  // MM
  Sec := (Pos mod 60) mod 60;                    // SS
  Dec := Round(1.667*Sec);                       // mm
  Result := Format(FmtStrArray[PosLN, Idx], [C, Deg, Min, Sec, Dec, Dd]);
end;


{Magnetic course fom true course TC and magnetic variation MV}

function MagCourse(TC, MV: Double): Double;
begin
  Result := TC-MV;
  if (Result >= 360) then
    Result := Result-360;
  if (Result < 0) then
    Result := Result+360;
end;


function UserUnits(Val: Double; sUnit: Char; ShowFmt: TShowFmt): string;
begin
  try
    if (UpperCase(sUnit) = 'M') then
      case ShowFmt of
        sfNautical: Result := Format('%.0f ft', [3.28*Val]);
        sfStatute : Result := Format('%.0f ft', [3.28*Val]);
        sfMetric  : Result := Format('%.0f M',  [Val]);
      end;
    if (UpperCase(sUnit) = 'K') then
      case ShowFmt of
        sfNautical: Result := Format('%.1f', [Val]);
        sfStatute : Result := Format('%.1f', [1.150779*Val]);
        sfMetric  : Result := Format('%.1f', [1.852000*Val]);
      end;
  except
    Result := '--';
  end;
end;

end.  // NavUtils
