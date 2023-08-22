///////////////////////////   Include file   ///////////////////////////////////
//                                                                            //
//                  NMEA Sentence decoders for GPS component                  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


{Separates comma delimited NEMA sentence into a 20 element array with empty
 fields are represented by ''  }

function Parse(S: string): TDataArray;      
var
  n, i: Integer;
begin
  TrimNMEA(S);
  i := 0;
  repeat
    n := Pos( ',', S);
    if (n = 0) then
      Result[i] := S
    else
      Result[i] := Copy(S, 1, n-1);
    Delete(S, 1, n);
    Inc(i);
  until (n = 0);
end;


procedure SoundAlarm;
begin
  Windows.Beep( 750, 500);
  Sleep(25);
  Windows.Beep(1000, 700);
  Sleep(25);
  Windows.Beep( 750, 500);
end;


function StrIsNumber(const S: string): Boolean;
begin
  Result := True;
  try
    StrToFloat(S);
  except
    Result := False;
  end;
end;


function FixQuality(const Idx: Integer): string;
begin
  case Idx of
    0: Result := 'Fix Not Valid';
    1: Result := 'GPS Fix (SPS)';
    2: Result := 'DGPS';
    3: Result := 'PPS Fix';
    6: Result := 'Estimated';
    7: Result := 'Manual Input';
    8: Result := 'Simulation Mode';
  else
    Result:= '--'
  end;
end;


function FixProgress(const Idx: Integer): string;
begin
  case Idx of
    1: Result := 'Fix not available';
    2: Result := '2D Fix';
    3: Result := '3D Fix';
  else
    Result := '--';
  end;
end;


function SelectionMode(const Idx: Char): string;
begin
  if Idx = 'A' then
    Result := 'Automatic';
  if Idx = 'V' then
    Result := 'Manual';
  if not (Idx in ['A', 'V']) then
    Result := 'Not defined';
end;


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//     NMEA  $GPRMC - Recommended Minimum Specific GPS/TRANSIT Data           //
//                                                                            //
//     GPRMC,225446,A,4916.454,N,12311.122,W,000.5,054.7,191194,020.3,E,      //
//       0     1    2     3    4      5    6    7     8     9      0  1 2     //
////////////////////////////////////////////////////////////////////////////////

{The precision for Lat and Lon varies with receivers There is an added field
 after the declination direction for later NMEA}


function TGPS2.RMC: Boolean;
begin
  Result := True;
  try
    fFixValid := (A[2] = 'A');
    if not fFixValid then Exit;

    {Now the Lat, Lon, SOG and COG fields must convert for sentence acceptance}

    fDateTime := DateTimeNMEA(A[9], A[1]);
    fLatInDeg := PosInDeg(A[3]);
    if (A[4] = 'S') then fLatInDeg := -fLatInDeg;
    fLonInDeg := PosInDeg(A[5]);
    if (A[6] = 'W') then fLonInDeg := -fLonInDeg;
    fSOG := StrToFloat(A[7]);
    fCOG := StrToFloat(A[8]);

    {If magnetic data is provided MagVar must also convert}

    if (A[10]  <> '') then
      begin
        fMagVar := StrToFloat(A[10]);
        if (A[11] = 'W') then fMagVar := -fMagVar;
        fHasMagVar := True;
      end;
  except
    fError := 'GPRMC is invalid';
    Result := False;
  end;
end;


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//     NMEA $GPGGA - Global Positioning Fix Data                              //
//                                                                            //
//     GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,          //
//       0      1       2    3      4    5 6 7   8    9   0   1  2 3 4        //
////////////////////////////////////////////////////////////////////////////////

{Some receivers do not provide Geoid information in fields 11 & 12 }


function TGPS2.GGA: Boolean;
begin
  Result := True;
  try
    fFixQalIdx := StrToInt(A[6]);
    fFixValid := (fFixQalIdx <> 0);
    fFixSatCount := 0;
    if not fFixValid then Exit;
    fFixSatCount := StrToInt(A[7]);
    fAltitude := StrToFloat(A[9]);
    fAltUnits := A[10][1];
    if (A[11] <> '') then
      begin
        fGeoidDelta := StrToFloat(A[11]);      // Heigth above WGS84 ellipsoid
        fDeltaUnits := A[12][1];
        fHasGeoidDelta := True;
      end;
     if (A[13] <> '') and (A[14] <> '') then
       begin
         fAgeDGPS := StrToFloat(A[13]);
         fStnDGPS := A[14];
         fIsDGPS := true;
       end;
  except
    fError := 'GPGGA is invalid';
    Result := False;
  end;
end;


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//           NMEA $GPGSA  - GPS DOP and Active Satellites                     //
//                                                                            //
//            GPGSA,A,3,04,05,,09,12,,,24,,,,,2.5,1.3,2.1                     //
//              0   1 2  3  4  .............. 15  16  17                      //
////////////////////////////////////////////////////////////////////////////////


function TGPS2.GSA: Boolean;
var i: Integer;
begin
  Result := True;
  try
    fFixMode := SelectionMode(A[1][1]);
    fFixProgIdx := StrToInt(A[2]);
    fFixValid := fFixProgIdx > 1;
    fFixPrnSet := [];
    fPDOP := 100;
    fHDOP := 100;
    fVDOP := 100;
    if not fFixValid then Exit;
    for i := 3 to 14 do
      if StrIsNumber(A[i]) then
        fFixPrnSet := fFixPrnSet + [StrToInt(A[i])];
    fPDOP := StrToFloat(A[15]);
    fHDOP := StrToFloat(A[16]);
    fVDOP := StrToFloat(A[17]);
  except
    fError := 'GPGSA is invalid';
    Result := False;
  end;
end;   // Include File





{

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//     NMEA $GPGLL - Geographic Position, Latitude/Longitude                  //
//                                                                            //
//     GPGLL,4027.0026,N,00341.8490,W,094209,V*2F                             //
//       0       1     2      3     4    5   6                                //
////////////////////////////////////////////////////////////////////////////////


function TGPS.GLL: Boolean;               // Use for a simple fix
begin
  Result := True;                                                   
  fFixValid := True;
  try
    fLatInDeg := PosInDeg(A[1]);
    if (A[2] = 'S') then fLatInDeg := -fLatInDeg;
    fLonInSec := PosInDeg(A[3]);
    if (A[4] = 'W') then fLonInDeg := -fLonInDeg;
    if A[6] <> '' then fFixValid := (A[6] = 'A');
  except
    fError := 'GPGLL is invalid';
    fFixValid := False;
    Result := False;
  end;
end;

GPGSV,2,1,08,01,40,083,46,02,17,308,41,12,07,344,39,14,22,228,45

fGsvSatCount: Integer;                // Number visible SVs
fGsvMsgCount: Integer;
fGsvMsgSeq: Integer;

function TGPS.GSV: Boolean;
begin
  Result := True;
  try
    fGsvMsgCount := StrToInt(A[1]);
    fGsvMsgSeq := StrToInt(A[2]);
    fGsvSatCount := StrToInt(A[3]);
  except
    fError := 'GPGSV is invalid';
    Result := False;
  end;
end;  }
