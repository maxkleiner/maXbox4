program Dist_Bearing_mX4_Bern_BC_Diff_Bearings;
//https://rosettacode.org/wiki/Distance_and_Bearing#Free_Pascal
//https://rosettacode.org/wiki/Angle_difference_between_two_bearings#Pascal
//{$IFDEF FPC} {$Mode DELPHI}{$Optimization ON,ALL} {$ENDIF}
//{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
{uses
  SysUtils,Math;   }
const
  cDegToRad = cpi / 180; cRadToDeg = 180 / cpi;
  //One nautical mile ( 1" of earth circumfence )
  cOneNmInKm = (12742*cpi)/360/60;
  DiaEarth  = 12742/cOneNmInKm;
  AIRDatFile = '1189_airports.dat';
  AIRDatSource =
    'https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat';
//https://sourceforge.net/projects/maxbox/files/Examples/13_General/1189_airports.dat/download
  
type
  tLatLon   = record
                lat,lon:double;
                sinLat,cosLat:double;
                sinLon,cosLon:double;
              end;

  tDist_Dir = record
                distance,bearing:double;
              end;

  tDst_Bear = record
                 Koor1,
                 Koor2 : tLatLon;
                 Dist_Dir : tDist_Dir;
              end;

  tmyName    = String;   //string[63-8] experiment
  tmyCountry = String;   //string[31]
  tmyICAO    = String;   //string[7]
  tSolution = record
                Sol_Name : tmyName;
                Sol_Country :tmyCountry;
                Sol_ICAO : tmyICAO;
                Sol_Koor : tLatLon;
                Sol_dist_dir:tDist_Dir;
              end;

  tIdxDist = record
                Distance: double;
                AirportIdx :Int32;
             end;
  tMinSols = record
               sols : array of tIdxDist;
               maxValue: double;
               actIdx,
               maxidx :Int32;
            end;
            
  tbearings = record
                sub: array[1..12] of real;
                min: array[1..12] of real;
             end;          

var
  Airports: array of tSolution;
  MinSols :tMinSols;
  cntInserts : Cardinal;
  abear: tbearings; 
  
 procedure initAngleFile;
 begin 
    with abear do begin 
        sub[1]:=20                min[1]:=45
        sub[2]:=-45               min[2]:=45
        sub[3]:=-85               min[3]:=90
        sub[4]:=-95               min[4]:=90
        sub[5]:=-45               min[5]:=125
        sub[6]:=-45               min[6]:=145
        sub[7]:=29.4803           min[7]:=-88.6381
        sub[8]:=-78.3251          min[8]:=-159.036
     sub[9]:=-70099.74233810938   min[9]:=29840.67437876723
     sub[10]:=-165313.6666297357  min[10]:=33693.9894517456
     sub[11]:=1174.8380510598456  min[11]:=-154146.66490124757
     sub[12]:= 60175.77306795546  min[12]:=42213.07192354373
   end;
 end; 
 
Type degrees = real;

Var
  subtrahend, minuend: degrees;
  angleFile: text;

function Simplify(angle: degrees): degrees;
{ Returns an number in the range [-180.0, 180.0] }
  begin
    while angle > 180.0 do
      angle := angle - 360.0;
    while angle < -180.0 do
      angle := angle + 360.0;
    result := angle
  end;

function DifferenceA(b1, b2: degrees): degrees;
{ Subtracts b1 from b2 and returns a simplified result }
  begin
    result := Simplify(b2 - b1)
  end;

procedure Subtract(b1, b2: degrees);
{ Subtracts b1 from b2 and shows the whole equation onscreen }
  var
    b3: degrees;
  begin
    b3 := DifferenceA(b1, b2);
    //writeln(b2:20:11, '   - ', b1:20:11, '   = ', b3:20:11)
    writeln(format('%20.11f  - %20.11f  = %20.11f',[b2,b1,b3]));
  end;      

procedure GetSolData(const OneAirport: String;
                         var TestSol :tSolution);
var
  p1,p2,i1,i2,idx,l : integer;
begin
  p1:=1;
  idx := 0;
  l := length(OneAirport);

  repeat
    p2 := p1;
    i1 := p1;
    IF OneAirport[p1] <>'"' then Begin
      repeat
        //p2 +=1;
        inc(p2);
      until (p2>l) OR (OneAirport[p2]=',');
      i2 := p2;
    end else begin
      repeat
        //p2 +=1;
        inc(p2)
      until (p2>l) OR (OneAirport[p2]='"');
      i2 := p2;
      //i1 +=1;
      inc(i1);
      while (p2<l) do begin
        //p2 +=1;
        inc(p2);
        IF (OneAirport[p2]=',')then
          break;
      end;
    end;
    //idx += 1;
    inc(idx);

    with TestSol do
    case idx of
      2: Sol_Name := copy(OneAirport,i1,i2-i1);
      4: Sol_Country := copy(OneAirport,i1,i2-i1);
      6: Sol_ICAO := copy(OneAirport,i1,i2-i1);
      7: Begin
           With Sol_Koor do begin
             lat := StrtoFloat(copy(OneAirport,i1,i2-i1))*cDegToRad;
             glsincos11(lat,sinLat,cosLat);   //double instead of extende
           end;
         end;
      8: Begin
           With Sol_Koor do begin
             lon := StrtoFloat(copy(OneAirport,i1,i2-i1))*cDegToRad;
             glsincos11(lon,sinLon,cosLon);
           end;
         end;
    end;
    p1:= p2+1;
  until (idx>7) OR (p1>l);
end;

function ReadAirports(afileName:String):boolean;
var
  TF_Buffer : array[0..1 shl 14 -1] of byte;
  //AirportsFile: TextFile;
  AirportsFile: TStringlist;
  OneAirport : String;
  l,cnt, cnt2, n,i : UInt32;
  ds: char;
begin
 ds:= GetFormatSettings2.DecimalSeparator;
  writeln('DecimalSeparato '+ds)
  AirportsFile:= TStringList.Create;
  AirportsFile.Delimiter:= ',';//#32; //#9;
  AirportsFile.StrictDelimiter:= true;
  try
    AirportsFile.LoadFromFile(AFileName);
    n := AirportsFile.Count;
    //SetLength(AData, n-1);
    writeln('dat recordes len: '+itoa(n));
    for i:=1 to n-1 do begin
       if pos('Switzerland',AirportsFile[i]) > 0 then begin 
          inc(cnt2)
          writeln(itoa(i)+'  '+utf8tostr(AirportsFile[i]));
       end;   
    end; 
    writeln('cnt tot: '+itoa(cnt2)); 
    result:= true;
    cnt := 0;
    l := 100;
    setlength(Airports,l);  
    for i:=0 to n-1 do begin
      GetSolData(AirportsFile[i],Airports[cnt]);
      inc(cnt);
      if cnt >= l then Begin
        l := l*13 div 8;
       setlength(Airports,l);
      end;
    end; 
    setlength(Airports,cnt); 
    setdecimalseparator('.');
  finally
    //FormatSettings.DecimalSeparator:= ds;
    setdecimalseparator(ds);
    AirportsFile.Free;
  end;
(*
  Assign(AirportsFile,fileName);
  settextbuf(AirportsFile,TF_Buffer);
 //{$I-}
  reset(AirportsFile);
 // {$I+}
  IF ioResult <> 0 then Begin
    Close(AirportsFile);
    EXIT(false);
  end;
  cnt := 0; l := 100;
  setlength(Airports,l);
  while Not(EOF(AirportsFile)) do Begin
    Readln(AirportsFile,OneAirport);
    GetSolData(OneAirport,Airports[cnt]);
    inc(cnt);
    if cnt >= l then Begin
      l := l*13 div 8;
      setlength(Airports,l);
    end;
  end;
  setlength(Airports,cnt);
  Close(AirportsFile);
  exit(true);  *)
end;

procedure Out_MinSol;
var
  i: integer;
begin
writeln(' ICAO Distance Bearing Country        Airport');
writeln(' ---- -------- ------- -------------- -----------------------------------');
  For i := 0 to minSols.actidx do
    with AirPorts[minSols.sols[i].AirportIdx] do
      writeln(Format(' %4s %8.1f %7.0f %-14s  %-35s',
                     [Sol_ICAO,
                      Sol_dist_dir.distance*DiaEarth,
                      Sol_dist_dir.bearing*cRadToDeg,
                      Sol_Country,Sol_Name]));
  writeln('');
  writeln(itoa(cntInserts)+' inserts to find them');
end;

procedure Init_MinSol(MaxSolCount:Int32);
begin
  setlength(MinSols.sols,MaxSolCount+1);
  MinSols.actIdx := -1;
  MinSols.maxIdx := MaxSolCount-1;
  MinSols.MaxValue := maxdouble;
  cntInserts := 0;
end;

procedure Insert_Sol(var sol:tDst_Bear;nrAirport:Int32);
var
  dist : double;
  idx : Int32;
begin
  with MinSols do begin
    idx := actIdx;
    dist := sol.Dist_Dir.distance;
    if Idx >= maxIdx then
      IF MaxValue < dist then
        Exit;

    if idx >= 0 then begin
      inc(idx);
      inc(cntInserts);
      while sols[idx-1].Distance >dist do begin
        sols[idx]:= sols[idx-1];
        dec(idx);
        If idx<=0 then
          BREAK;
      end;
      with sols[idx] do begin
        AirportIdx := nrAirport;
        Distance := dist;
      end;
      //update AirPorts[nrAirport] with right distance/bearing
      AirPorts[nrAirport].Sol_dist_dir := sol.Dist_Dir;
      if actIdx < maxIdx then
         //actIdx +=1;
         inc(actidx);
    end else begin
      with sols[0] do begin
        AirportIdx := nrAirport;
        Distance := dist;
      end;
      AirPorts[nrAirport].Sol_dist_dir := sol.Dist_Dir;
      MinSols.actIdx := 0;
    end;
    MaxValue := sols[actIdx].Distance;
  end;
end;

procedure Calc_Dist_bear(var Dst_Bear:tDst_Bear);
var  dLonSin,dLonCos,x,y : double;
begin
  with Dst_Bear do Begin
    If (Koor1.Lat = Koor2.Lat) AND (Koor1.Lon = Koor2.Lon) then Begin
      Dist_Dir.distance := 0;
      Dist_Dir.bearing  := 0;
      Exit;
    end;
    //glSinCos11( const Theta : Double; var Sin, Cos : Double);
    //glSinCos2( const theta, radius : Double; var Sin, Cos : Double);
    glsincos11(Koor1.lon - Koor2.lon,dLonSin,dLonCos);
    //distance
    Dist_Dir.distance := arcsin(sqrt(sqr(dLonCos * Koor1.Coslat
              - Koor2.Coslat) + sqr(dLonSin* Koor1.Coslat)
              + sqr(Koor1.sinlat - Koor2.sinlat)) / 2);

    x := dLonSin*Koor2.Coslat;
    y := Koor1.Coslat*Koor2.sinlat - Koor1.sinlat*Koor2.Coslat*dLonCos;
    //bearing dLonSin as tmp
    dLonSin := ArcTan2(x,y);
    if dLonSin < 0 then
      dLonSin := -dLonSin
    else
      dLonSin := 2*pi-dLonSin;
    Dist_Dir.bearing  := dLonSin;
  end;
end;

procedure FindNearest(var testKoors: tDst_Bear;cntAirports,cntNearest:Integer);
var i : Int32;
begin
  Init_MinSol(cntNearest);
  For i := 0 to cntAirports-1 do Begin
    testKoors.Koor2 := AirPorts[i].Sol_Koor;
    Calc_Dist_bear(testKoors);
    Insert_Sol(testKoors,i);
  end;
end;

const
  rounds = 100;
  cntNearest = 20;//128;//8000;
var
  T1,T0: Int64;
  testKoors: tDst_Bear;
  myKoor: tLatLon;
  i,cntAirports: integer;
  
begin   //@main
  T0 := icsGettickcount64;
  processmessagesOFF;
  if not fileExists(exepath+'1189_airports.dat')  then begin
    wGetX2(AIRDatSource,  exepath+'1189_airports.dat');
       ShowmessageBig('airports.dat download starts..., please confirm!')
   end;    
  IF NOT(ReadAirports(AirDatFile)) then
    writeln('1189_airports.dat not found HALT(129)');
  T1 := icsGettickcount64;
  Writeln(itoa(T1-T0)+' ms for reading airports.dat');
  cntAirports := length(AirPorts);
  with myKoor do begin
    lat := 46.947975*cDegToRad; //46.947975 46.914100647*cDegToRad;  //lat := 51.514669*cDegToRad;
    lon := 7.447447*cDegToRad; //07.447447  7.497149944*cDegToRad;  //lon :=  2.198581*cDegToRad;
    glsincos11(lat,sinLat,cosLat);
    glsincos11(lon,sinLon,cosLon);
  end;
  randomize;
  T0 := icsGettickcount64;
  For i := rounds-2 downto 0 do Begin
    testKoors.Koor1 := AirPorts[random(cntAirports)].Sol_Koor;
    FindNearest(testKoors,cntAirports,cntNearest);
  end;
  testKoors.Koor1 := myKoor;
  FindNearest(testKoors,cntAirports,cntNearest);
  T1 := icsGettickcount64;
  Writeln(itoa(T1-T0)+' ms for searching '+itoa(rounds)+' times of '+
                    itoa(cntNearest)+' nearest out of '+itoa(cntAirports)+' airports');
  writeln(itoa(cntInserts)+' inserts to find them');
  writeln('');
  FindNearest(testKoors,cntAirports,20);
  processmessagesON;
  with myKoor do
    writeln(Format('Nearest to latitude %7.5f,longitude %7.5f degrees',
                   [cRadToDeg*lat,cRadToDeg*lon]));
  writeln('');
  Out_MinSol;
  OpenWeb('https://www.latlong.net/c/?lat='+flots(myKoor.lat/cDegToRad)+
                                         '&long='+flots(myKoor.lon/cDegToRad));
                          //*)  
                          
  InitAngleFile;
    for it:= 1 to length(abear.sub) do begin
      //readln(angleFile, subtrahend, minuend);
      Subtract(abear.sub[it], abear.min[it])
    end;
 end.
end.

ref: https://rosettacode.org/wiki/Distance_and_Bearing#Free_Pascal
https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat
https://rosettacode.org/wiki/Angle_difference_between_two_bearings#Pascal

      45.00000000000  -       20.00000000000  =       25.00000000000
      45.00000000000  -      -45.00000000000  =       90.00000000000
      90.00000000000  -      -85.00000000000  =      175.00000000000
      90.00000000000  -      -95.00000000000  =     -175.00000000000
     125.00000000000  -      -45.00000000000  =      170.00000000000
     145.00000000000  -      -45.00000000000  =     -170.00000000000
     -88.63810000000  -       29.48030000000  =     -118.11840000000
    -159.03600000000  -      -78.32510000000  =      -80.71090000000
   29840.67437876723  -   -70099.74233810938  =     -139.58328312339
   33693.98945174560  -  -165313.66662973570  =      -72.34391851869
 -154146.66490124757  -     1174.83805105985  =     -161.50295230740
   42213.07192354373  -    60175.77306795546  =       37.29885558827

202 inserts to find them
IFPS
 mX4 byte code executed: 23/02/2023 13:05:31  Runtime: 0:0:22.283  Memload: 41% use
ByteCode Success Message of: C:\maXbox\maxbox3\maxbox3\maXbox3\examples\1189_Distance_and_Bearing_Bordcomputer.psb 

202 inserts to find them

Nearest to latitude 46.94797,longitude 7.44745 degrees

 ICAO Distance Bearing Country        Airport
 ---- -------- ------- -------------- -----------------------------------
 LSZB      2.9     135 Switzerland     Bern Belp Airport 
 //46.914100647,7.497149944309999                 
 LSZP     10.6     323 Switzerland     Biel-Kappelen Airport              
 LSZW     13.1     151 Switzerland     Thun Airport                       
 LSZG     14.1     355 Switzerland     Grenchen Airport  
 //"ZHI","LSZG",47.181599,7.41719,1411,1,"E","Europe/Zurich",ts                 
 LSGE     19.1     233 Switzerland     Ecuvillens Airport                 
 LSZJ     20.3     314 Switzerland     Courtelary Airport                 
 LSGR     22.2     155 Switzerland     Reichenbach Air Base               
 LSMP     22.7     254 Switzerland     Payerne Air Base                   
 LSGN     23.9     272 Switzerland     Neuchatel Airport                  
 LSMI     24.1     132 Switzerland     Interlaken Air Base                
 LSTS     27.1     183 Switzerland     St Stephan Airport                 
 LSGC     28.0     287 Switzerland     Les Eplatures Airport              
 LSGK     28.8     196 Switzerland     Saanen Airport                     
 LSMM     29.8     114 Switzerland     Meiringen Airport                  
 LSPO     29.9      37 Switzerland     Olten Airport                      
 LSPN     30.7      57 Switzerland     Triengen Airport                   
 LSZQ     31.7     328 Switzerland     Bressaucourt Airport               
 LSZO     34.2      65 Switzerland     Luzern-Beromunster Airport         
 LSMA     34.3      90 Switzerland     Alpnach Air Base  
 //LSMA",46.943901,8.28417,1                 
 LSGY     36.0     252 Switzerland     Yverdon-les-Bains Airport          

202 inserts to find them
 mX4 executed: 23/02/2023 10:10:57  Runtime: 0:0:35.968  Memload: 46% use

Nearest to latitude 46.91410,longitude 7.49715 degrees   //Bern, Switzerland

 ICAO Distance Bearing Country        Airport
 ---- -------- ------- -------------- -----------------------------------
 LSZB      0.0      90 Switzerland     Bern Belp Airport                  
 LSZW     10.4     156 Switzerland     Thun Airport                       
 LSZP     13.5     321 Switzerland     Biel-Kappelen Airport              
 LSZG     16.4     349 Switzerland     Grenchen Airport                   
 LSGR     19.5     158 Switzerland     Reichenbach Air Base               
 LSGE     19.7     241 Switzerland     Ecuvillens Airport                 
 LSMI     21.2     132 Switzerland     Interlaken Air Base                
 LSZJ     23.2     314 Switzerland     Courtelary Airport                 
 LSMP     24.2     260 Switzerland     Payerne Air Base                   
 LSTS     25.2     188 Switzerland     St Stephan Airport                 
 LSGN     26.0     276 Switzerland     Neuchatel Airport                  
 LSMM     27.2     112 Switzerland     Meiringen Airport                  
 LSGK     27.5     202 Switzerland     Saanen Airport                     
 LSPN     30.3      51 Switzerland     Triengen Airport                   
 LSPO     30.4      32 Switzerland     Olten Airport                      
 LSGC     30.6     290 Switzerland     Les Eplatures Airport              
 LSMA     32.3      87 Switzerland     Alpnach Air Base                   
 LSZO     33.3      60 Switzerland     Luzern-Beromunster Airport         
 LSZQ     34.5     327 Switzerland     Bressaucourt Airport               
 LSME     34.8      72 Switzerland     Emmen Air Base                     

19437 ms for reading airports.dat
224125 ms for searching 100 times of 20 nearest out of 7698 airports
144 inserts to find them

Nearest to latitude 51.51467,longitude 2.19858 degrees

 ICAO Distance Bearing Country        Airport
 ---- -------- ------- -------------- -----------------------------------
 EBFN     30.6     146 Belgium         Koksijde Air Base                  
 EBOS     31.3     127 Belgium         Ostend-Bruges International Airport
 EGMH     33.5     252 United Kingdom  Kent International Airport         
 LFAC     34.4     196 France          Calais-Dunkerque Airport           
 EBKW     42.5     105 Belgium         Westkapelle heliport               
 EGMK     51.6     240 United Kingdom  Lympne Airport                     
 EBUL     52.8     114 Belgium         Ursel Air Base                     
 EGMC     56.2     274 United Kingdom  Southend Airport                   
 LFQT     56.3     163 France          Merville-Calonne Airport           
 EBKT     56.4     137 Belgium         Wevelgem Airport                   
 EHMZ     57.2      90 Netherlands     Midden-Zeeland Airport             
 EGMD     58.0     235 United Kingdom  Lydd Airport                       
 EGUW     58.9     309 United Kingdom  RAF Wattisham                      
 EGSM     59.3     339 United Kingdom  Beccles Airport                    
 LFQO     59.6     146 France          Lille/Marcq-en-Baroeul Airport     
 EGKH     62.2     250 United Kingdom  Lashenden (Headcorn) Airfield      
 LFAT     63.7     200 France          Le Touquet-Côte d'Opale Airport   
 EGTO     64.2     262 United Kingdom  Rochester Airport                  
 LFQQ     66.2     149 France          Lille-Lesquin Airport              
 EGMT     68.4     272 United Kingdom  Thurrock Airfield                  

144 inserts to find them
 mX4 executed: 22/02/2023 17:17:55  Runtime: 0:4:7.397  Memload: 42% use
PascalScript maXbox4 - RemObjects & SynEdit

144 inserts to find them
IFPS
 mX4 byte code executed: 22/02/2023 17:36:53  Runtime: 0:4:2.797  Memload: 41% use
ByteCode Success Message of: C:\maXbox\maxbox3\maxbox3\maXbox3\examples\1189_Distance_and_Bearing.psb 


String2PascalStrExpr(filetostring(exepath+''formatdemo2.txt



'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
'abcdefg    1.22'+#13+#10+'abcde      3.12'+#13+#10+'abcd       6.23'+#13+#10
