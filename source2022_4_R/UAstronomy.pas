unit UAstronomy;
 {Copyright 01-2012, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A fairly complete Astronomy unit based on a conversion of Basic routines
 contained in Peter Duffett-Smith's book "Astronomy With Your Personal Computer",
 Cambridge University Press.
 }

interface

type

{Position coordinate formats}
TCoordType=(ctUnknown, ctAzAlt, ctEclLonLat, ctRADecl, ctHADecl, ctGalLonLat);
{Time formats}
TDTType=(ttLocal, ttUT {Universal}, ttGST {Greenwich sidereal}, ttLST {local sidereal});


TRPoint=record    {coordinate point}
   x,y:extended;
   CoordType:TCoordType;
  end;

TSunrec=record
  TrueEclLon:extended;
  AppEclLon:extended;
  AUDistance:extended;
  TrueHADecl,TrueRADecl,TrueAzAlt:TRPoint;
  AppHADecl,AppRADecl,AppAzAlt:TRpoint;
  SunMeanAnomaly:extended;
end;

TMoonRec=record
  ECLonLat:TRPoint;
  AZAlt:TRPoint;
  RADecl:TRPoint;
  HorizontalParallax:extended;
  AngularDiameter:extended;
  KMtoEarth:extended;
  Phase:extended;
end;

TMoonEclipseAdd=record
  UmbralStartTime, UmbralEndTime:TDatetime;
  TotalStartTime,TotalEndTime:TDateTime;
end;

TEclipseRec=record
  Msg:string;
  Status:integer; {1=no eclipse, 2=occurs but not visible from here}
  FirstContact, LastContact:TDateTime;
  Magnitude:Extended;
  MaxeclipseUTime:TDateTime;
end;

TPlanet=(MERCURY,VENUS,MARS,JUPITER,SATURN,URANUS,NEPTUNE,PLUTO);

  TPlanetRec=record {planetary data}
    AsOf:TDateTime;
    Name:string;
    MeanLon:extended;
    MeanLonMotion:extended;
    LonOfPerihelion:extended;
    Eccentricity:extended;
    Inclination:extended;
    LonAscendingNode:extended;
    SemiMajorAxis:extended;
    AngularDiameter:extended;
    Magnitude:extended;
  end;


  TPlanetLocRec=record
    PlanetBaseData:TPlanetrec;
    HelioCentricLonLat:TRpoint; {H0,S0 in degrees}
    RadiusVector:extended; {P0}
    UncorrectedEarthDistance:extended; {V0 (inAU)}
    GeoEclLonLat:TRpoint; {EP,BP (in degrees)}
    CorrectedEarthDistance:extended; {RH (inAU)}
    ApparentRaDecl:TRPoint;
  end;

TAstronomy = class (TObject)

protected
  {DateTime info }
  FJDate:extended;
  Year:integer;
  FUniversalTime:TDateTime;
  FLocalSiderealTime:TDateTIme;
  FGreenwichSiderealTime:TDateTime;
  FLocalCivilTime:TDateTime;
  FTZHours:integer; {Time Zone hours (West negative)}
  FDLSHours:integer;  {Daylight savings hours to add }

  {Viewing Location}
  FGeoLonLat:TRPoint; {Geographical Longitude & Latitude}
  FHeight:extended;   {Height above sea level (in earth radii)}

  {Celestial Coordinate Systems}
  FAzAlt:TRPoint;  {Azimuth/Altitude system}
  FEcLonLat:TRPoint;  {Ecleptic Long and lat}
  FGalLonLat:TRPoint; {Galactic Long & Lat }
  FHADecl:TRPoint;  {Hour Angle, Declination}
  FRADecl:TRPoint;  {Right Ascension, Declination}

  {Predefined frequently used values}
  Jan1Date:Extended;
  sinlat,sinlong,coslat,coslong:extended;
  sinob, cosob:extended;
  sinLST, cosLST:extended;

  function  getdate:TDateTime;
  procedure setdate(Value:TDateTime);
  procedure setLocalTime(value:TDateTime);
  procedure SetLSTime(value:TDateTime);
  procedure SetuniversalTime(value:TDateTime);
  procedure SetGSTime(value:TDateTime);

  procedure setGeoLonLat(value:TRPoint);

  procedure setEcLonLat(value:TRPoint);
  procedure setGalLonLat(value:TRPoint);
  procedure SetHADecl(value:TRPoint);
  function  GetHADecl:TRPoint;
  procedure setRADecl(value:TRPoint);
  function  GetRADecl:TRPoint;
  procedure setAzAlt(value:TRPoint);
  procedure parallax(TrueToApparent:boolean; HADeclRadIn:TRPoint;
                              HorizontalPlx:extended;
                              Var HaDeclRadOut:TRPoint);
  function GetHeight:Extended;
  procedure Setheight(value:extended);
  procedure Nutate;
  procedure oblique;
  procedure GenCom(opt:integer; inVal:TRPoint; var outval:TRPoint);
  procedure Anomaly(EC,AM:extended; Var AE,AT:extended);
  Procedure HRang(X:extended; var P:extended);
  function PElment(planet:TPlanet; var Info:TPlanetRec):boolean;
public
  NuLong,NuOblique:extended;  {Nutation longitude and obliquity adjustments}
  Obliquity:extended; {Obliquity angle (adjusted for nutation)}
  DecimalFormat:boolean;
  constructor create;
  procedure assign(F:TAstronomy);
  procedure SunPos(var Sunrec:TSunrec);
  Procedure MoonPos(var Moonrec:TMoonRec);
  function  RiseSet(Inval:TRPoint; InDI:extended;
                                var AzUp,AzDn,LSTUp,LSTDn:extended):String;
  function  SunRiseSet(CalcType:integer; var UpTmAz, DNTmAz:TRPoint):String;
  function  MoonRiseSet(var  UpTmAz, DNTmAz:TRPoint):String;  overload;
  function  MoonRiseSet(var  UpTmAz, DNTmAz:TRPoint; var altitude:extended):String;  overload;

  Procedure NewFullMoon(Date:TDateTime;
                        var FULLDATETIME, NEWDATETIME:TDATETIME;
                        var FULLLAT,NEWLAT:EXTENDED);
  procedure ConvertLSTime(Value:TDateTime; var GSTime, LCTime,UTime:TDatetime);
  PROCEDURE ECLIPSE (Etype:char; NearDate:TDatetime;
                        var EclipseRec:TEclipseRec;
                        var MoonAdd:TMoonEclipseAdd);

  Procedure Planets(Planet:TPlanet; var RecOut:TPlanetLocRec);
  function ConvertCoord(FromType,ToType:TCoordType; Input:TRpoint):TRPoint;
  function getprintdatetime(FromType,ToType:TDtType; DT:TDateTime;
                          IncludeDate:Boolean; var convertedDT:TDateTime):string;
  property ADate:TDateTime  Read GetDate Write SetDate;
  property LocalTime:TDateTime Read FLocalCivilTime Write SetLocalTime;
  property LSTime:TDateTime  Read FLocalSiderealTime  Write SetLSTime;
  property UniversalTime:TDateTime  Read FUniversalTime Write SetUniversalTime;
  property GSTime:TDateTime read FGreenwichSiderealTime write SetGSTime;
  property TZHours:integer  read FTZHours  write FTZHours;
  Property DLSHours:Integer read FDLSHours write FDLSHours;
  property LonLat:TRPoint read FGeoLonLat write setGeoLonlat;
  property AzAlt:TRPoint  read FAzAlt  write SetAzAlt;
  property EclonLat:TRPoint read FEcLonLat write setEcLonLat;
  property GalLonLat:TRPoint read FGallonLat write setGalLonLat;
  property HADecl:TRPoint read GetHADecl write setHADecl;
  property RADecl:TRPoint read GetRADecl write setRADecl;
  property Height:Extended read Getheight write Setheight; {above sea level in meters}
end;

  function AngleToStr(angle:extended):string;
  function StrToAngle(s:string; var angle:extended):boolean;
  function HoursToStr24(t:extended):string;
  function RPoint(x,y:extended):TRPoint;
  function getStimename(t:TDTType):string;
   function AngleToStr2(angle:extended; decimal:boolean):string;



var astro:TAstronomy;

implementation

uses sysutils, dialogs, math;

const
  TP=2.0*Pi;
  D2R=Pi/180.0;
  deg:char=chr(176); {'°'}
  minmark:char=chr(180);
  minmark2:char='''';
  EarthRadiusMeters=6378140.0;
  {Call conversion types for GenCom}
    AZHA=1;
    HAAZ=2;
    HARA=3;
    RAHA=4;
    RAECL=5;
    ECLRA=6;
    RAGal=7;
    GalRa=8;

   shorttimenames:array[ttlocal..ttLST] of string=('Local','UT','GST','LST');
   longtimenames:array[ttlocal..ttLST] of string=
            ('Local Civil Time','Universal Time',
             'Greenwich Sidereal Time','Local Sidereal Time');

       function AngleToStr(angle:extended):string;
       var
         D:integer;
         M,S:extended;
       begin
         d:=Trunc(angle);
         m:=abs(frac(angle)*60);
         s:=frac(M)*60;
         m:=int(M);
         if s>=59.99 then
         begin
           s:=0;
           m:=m+1;
         end;
         if (angle<0) and (d=0) then
         result:=format('-%3d° %2d´ %5.2f´´',[d,trunc(m),s])
         else result:=format('%3d° %2d´ %5.2f´´',[d,trunc(m),s]);
       end;

        {*** AngletoStr (with decimal format test) ***}
       function AngleToStr2(angle:extended; decimal:boolean):string;
       var
         D:integer;
         M,S:extended;
       begin
         if not decimal then result:=Angletostr(angle)
         else
         begin
           result:=format('%.3f',[angle])+deg;
         end;
       end;


       function HoursToStr24(t:extended):string;
       {Hourtime to 24 hr time format}
       var
         D:integer;
         M,S:extended;
       begin
         d:=Trunc(t);
         m:=abs(frac(t)*60);
         s:=frac(M)*60;
         m:=int(M);
         if s>=60-1e-10 then
         begin
           s:=s-60;
           m:=m+1;
         end;
         result:=format('%3d: %2d: %5.2f ',[d,trunc(m),s]);
       end;

       function StrToAngle(s:string; var angle:extended):boolean;
       var
         n,fn, sign:integer;
         w,ds,ms,ss:string;
       begin
         result:=true;
         ds:='0';
         ms:='0';
         ss:='0.0';
         w:=trim(s)+',';  {add a stopper}
         if w[1]='-' then
         begin
           sign:=-1;
           delete(w,1,1);
           while w[1]=' ' do delete(w,1,1);
         end
         else sign:=1;
         n:=0;
         fn:=0;
         while n<length(w) do
         begin
           inc(n);
           if (fn=0) and (w[n] in [' ',',',deg])
           then
           begin
             ds:=copy(w,1,n-1);
             delete(w,1,n);
             n:=0;
             while (length(w)>0) and (w[1] in [' ',deg,minmark,minmark2,','])
             do delete(w,1,1);
             inc(fn);
           end
           else if  w[n] in [' ',minmark,minmark2,','] then
           begin
             if fn=1 then ms:=copy(w,1,n-1)
             else if fn=2 then ss:=copy(w,1,n-1);
             delete(w,1,n);
             n:=0;
             while (length(w)>0) and (w[1] in [' ',deg,minmark,minmark2,','])
             do delete(w,1,1);
             inc(fn);
           end;
         end;
         try
           angle:=sign*(strtoint(ds)+strtoint(ms)/60+strtofloat(ss)/3600);
         except
           result:=false;
           angle:=0;
         end;
       end;


        Function rpoint(x,y:extended):TRPoint;
        begin
          result.x:=x;
          result.y:=y;
        end;

       function adjust24(x:extended; var flag:integer):extended;
       {adjust times to be within 0 to 24 range}
       begin
         result:=x;
         flag:=0;
         while result<0 do begin result:=result+24.0; flag:=-1; end;
         while result>24 do begin result:=result-24.0; flag:=+1; end;
       end;

       function getStimename(t:TDTType):string;
       begin
         result:=shorttimenames[t];
       end;


constructor TAstronomy.create;
begin
  inherited;
  Jan1Date:=encodedate(1900,1,1)-0.5; {Base date - add to Delphi DateTime to get TAstonomy Jdate}
  setdate(date);
  DecimalFormat:=false;
end;

procedure TAstronomy.assign(F:TAstronomy);
begin
  {DateTime info }
  FJDate:=F.FJDate;
  Year:=F.Year;
  FUniversalTime:=F.FUniversaltime;
  FLocalSiderealTime:=F.FLocalSiderealTime;
  FGreenwichSiderealTime:=F.FGreenwichSiderealTime;
  FLocalCivilTime:=F.FLocalCivilTime;
  FTZHours:=F.FTZHours; {Time Zone hours (West negative)}
  FDLSHours:=F.FDLSHours;  {Daylight savings hours to add }

  {Viewing Location}
  FGeoLonLat:=F.FGeoLonLat; {Geographical Longitude & Latitude}
  FHeight:=F.FHeight;   {Height above sea level (in earth radii)}

  {Celestial Coordinate Systems}
  FAzAlt:=FAzAlt;{Azimuth/Altitude system}
  FEcLonLat:=F.FECLonLat;  {Ecleptic Long and lat}
  FGalLonLat:=F.GalLonLat; {Galactic Long & Lat }
  FHADecl:=F.FHADecl;;  {Hour Angle, Declination}
  FRADecl:=F.FRADecl;  {Right Ascension, Declination}

  {Predefined frequently used values}
  Jan1Date:=Jan1Date;
  sinlat:=F.SinLat;
  sinlong:=F.SinLong;
  coslat:=F.CosLat;
  coslong:=F.CosLong;
  sinob:=F.SinOb;
  cosob:=F.CosOb;
  sinLST:=F.SinLst;
  CosLst:=F.cosLST;
end;

procedure Tastronomy.parallax(TrueToApparent:boolean; HADeclRadIn:TRPoint;
                              HorizontalPlx:extended;
                              Var HaDeclRadOut:TRPoint);
 {Input and outputs in radians}
var
  U,C2,S2,RS,RC,RP:extended;
  X1,Y1,P1,Q1,P2,Q2:extended;
  A,B, HADelta:extended;

     procedure GetPx;
     var
       SY,CX,CY,A,P,CP:extended;
     begin
       CX:=Cos(HadeclRadIn.x);
       SY:=Sin(HaDeclRadIn.y);
       Cy:=Cos(HaDeclRadIn.Y);
       A:=(RC*Sin(HADeclRadIn.x))/((RP*Cy)-(RC*CX));
       HADelta:=ArcTan(A);  {Same delta can be subtracted from RA to get apparent}
       P:=HaDeclRadIn.X+HaDelta;
       CP:=COS(P);
       While P>TP do P:=P-TP;
       While P<0 Do P:=P+TP;
       HaDeclRadOut.x:=P;
       HADeclRadOut.Y:=ArcTan(CP*(RP*SY-RS)/(RP*Cy*CX-RC));
     end;
begin
  U:=Arctan(9.96647E-1*SinLat/CosLat);
  c2:=Cos(U); S2:=SIN(U);
  RS:=(9.96647E-1*S2)+(FHeight*SinLat);
  RC:=C2+(FHeight*CosLat);
  RP:=1/Sin(HorizontalPlx);
  If TrueToApparent then
  begin
    GetPx;
    exit;
  end
  else  {iterate on true until apparent coordinates match input}
  begin
    x1:=HadeclRadIn.x;
    y1:=HaDeclRadIn.y;
    P1:=0; Q1:=0;
    Repeat
      GetPx;
      P2:=HadeclRadOut.x-P1; Q2:=HaDeclRadOut.y-Q1;
      A:=Abs(P2-P1); B:=abs(Q2-Q1);
      HadeclRadin.x:=X1-P2; HadeclRadIn.Y:=Y1-Q2;
      P1:=P2; Q1:=Q2;
    until (a<1E-6) and (B<1E-6);
    HaDeclRadOut.x:=HadeclRadIn.X; HADeclRadOut.Y:=HaDeclRadIn.Y;
  end;
end;


procedure TAstronomy.nutate;
{calulates nutation - gravitational effect of Sun and Moon on earth's orbit}
{  called whenever date is changed}
{Outputs NuLong and NuOblique are in degrees}
var
  T,T2,A,B,L1,L2,D1,D2,M1,M2,N1,N2,DP,DOB:extended;
begin
  T:=FJDate/36525.0;
  T2:=T*T;
  A:=1.000021358E2*T;
  B:=360.0*(A-INT(A));
  L1:=2.796967E2+3.03E-4*T2+B;
  L2:=2.0*DegToRad(L1);
  A:=1.336855231E3*T;
  B:=360.0*(A-INT(A));
  D1:=2.704342E2-1.133E-3*T2+B;
  D2:=2.0*DegToRad(D1);
  A:=9.999736056E1*T;
  B:=360.0*(A-INT(A));
  M1:=3.584758E2-1.5E-4*T2+B;
  M1:=DegToRad(M1);
  A:=1.325552359E3*T;
  B:=360.0*(A-INT(A));
  M2:=2.961046E2+9.192E-3*T2+B;
  M2:=DegToRad(M2);
   A:=5.372616667*T;
  B:=360.0*(A-INT(A));
  N1:=2.591833E2+2.078E-3*T2-B;
  N1:=DegToRad(N1);
  N2:=2*N1;

  DP:=(-17.2327-1.737E-2*T)*SIN(N1);
  DP:=DP+(-1.2729-1.3E-4*T)*SIN(L2)+2.088E-1*SIN(N2);
  DP:=DP-2.037E-1*SIN(D2)+(1.261E-1-3.1E-4*T)*SIN(M1);
  DP:=DP+6.75E-2*SIN(M2)-(4.97E-2-1.2E-4*T)*SIN(L2+M1);
  DP:=DP-3.42E-2*SIN(D2-N1)-2.61E-2*SIN(D2+M2);
  DP:=DP+2.14E-2*SIN(L2-M1)-1.49E-2*SIN(L2-D2+M2);
  DP:=DP+1.24E-2*SIN(L2-N1)+1.14E-2*SIN(D2-M2);

  DOB:=(9.21+9.1E-4*T)*CoS(N1);
  DOB:=DOB+(5.522E-1-2.9E-4*T)*COS(L2)-9.04E-2*COS(N2);
  DOB:=DOB+8.84E-2*COS(D2)+2.16E-2* COS(L2+M1);
  DOB:=DOB+1.83E-2*COS(D2-N1)+1.13E-2*COS(D2+M2);
  DOB:=DOB-9.3E-3*COS(L2-M1 )-6.6E-3*COS(L2-N1);
  NuLong:=DP/3600.0;
  NuOblique:=DOB/3600.0;
END;

procedure TAstronomy.oblique;
var
  T,A:extended;
begin
  T:=FJDate/36525.0-1.0;
  a:=(46.815+(0.0006-0.00181*T)*T)*T;
  A:=A/3600.0;
  obliquity:=23.43929167-A+Nuoblique;
  sinob:=sin(degtorad(obliquity));
  CosOb:=Cos(degtorad(obliquity));
  gencom(5,FRADecl,FEcLonLat);
end;

procedure TAstronomy.SetDate(Value:TDateTime);
var
  y,m,d:word;
begin
  FJDate:=Value-Jan1Date;
  decodedate(value,y,m,d);
  year:=y;
  Nutate;  {recalculate nutation and obliquity, which depend on date}
  Oblique;
end;

function TAstronomy.GetDate:TDateTime;
begin  result:=FJDate+Jan1Date;  end;

function TAstronomy.GetHeight:Extended;
begin  result:=FHeight*EarthRadiusMeters;  end;

procedure TAstronomy.Setheight(value:extended);
begin FHeight:=value/EarthRadiusMeters; end;





{******************* Time routines **************}

procedure TAstronomy.SetLocalTime(Value:TdateTime);
{set local civil time}
var
  D,T,R0,R1:Extended;
  SG,TL,t0,UT: Extended;
  Flag:integer;
begin
  value:=FRAC(Value);
  FLocalciviltime:=value;
  D:=Int(FJDate-0.5)+0.5;
  T:=D/36525 -1;
  R0:=T*(5.13366E-02+T*(2.586222E-5-T*1.722E-9));
  R1:=6.697374558+2400.0*(T-(year-2000)/100.0);
  T0:=Adjust24(R0+R1, Flag);
  UT:=adjust24(value*24-FDLSHours-FTZHours, Flag);
  FUniversalTime:=UT/24.0+flag;
  T:=T0;
  If Flag>0 then T:=T+6.57098244E-2
  else if flag<0 then T:=T-6.57098244E-2;
  SG:=adjust24(UT*1.002737908+T, Flag);  {Greenwich Sidereal}
  FGreenwichSiderealTime:=SG/24.0;
  TL:=Adjust24(sg+Fgeolonlat.x/15.0, Flag); {Local Sidereal}
  FLocalSiderealTime:=TL/24.0{+flag};
  SinLst:=sin(degtorad(TL*15));
  CosLST:=cos(degtorad(TL*15));
  gencom(4,FRADecl,FHaDecl);  {reconvert Hour Angle since LST changed}
end;


procedure TAstronomy.SetLSTime(Value:TDateTime);
{set local sidereal time}
begin
  FLocalSiderealtime:=FRAC(Value);
  convertLSTime(FLocalSiderealTime, FGreenwichSiderealTime,
                FLocalCivilTime,FUniversalTime);
  SinLst:=sin(degtorad(FLocalSiderealTime*24*15));
  CosLST:=cos(degtorad(FLocalSiderealTime*24*15));
  gencom(4,FRADecl,FHaDecl);  {reconvert Hour Angle since LST changed}
end;

procedure TAstronomy.ConvertLSTime(Value:TDateTime;
                                   var GSTime, LCTime, UTime:TDatetime );
{set local sidereal time}
var
  D,T,R0,R1,T0,SG,X,TL,UT:Extended;
  Flag:integer;
begin
  {FLocalSiderealtime:=FRAC(Value);}
  D:=Int(FJDate-0.5)+0.5;
  T:=D/36525 -1;
  R0:=T*(5.13366E-02+T*(2.586222E-5-T*1.722E-9));
  R1:=6.697374558+2400.0*(T-(year-2000)/100.0);
  T0:=Adjust24(R0+R1, Flag);
  T:=adjust24(T0-(FDLSHours+FTZHours)*1.002737908, flag);
  SG:=adjust24(fraC(Value)*24-(FGeoLonLat.x/15),flag);
  GSTime:=SG/24.0+flag;
  If SG<T then x:=SG+24 else X:=SG;
  TL:=adjust24((X-T)*0.9972695677, flag);
  LCTime:=Frac(TL/24.0)+flag;
  UT:=adjust24(TL-FDLSHours-FTZHours,flag);
  UTime:=Frac(UT/24.0)+flag;
  (*
  If TL<0.06552 then showmessage('Ambiguous conversion of local sideral time');
  *)
end;

procedure TAstronomy.SetUniversalTime(Value:TDateTime);
{Set universal time}
var
  UT:Extended;
  Flag:integer;
begin
  FUniversalTime:=value;
  UT:=value*24;
  FLocalCivilTime:=adjust24(UT+FDLSHours+FTZHours,flag)/24.0;
  setLocalTime(FLocalCivilTime+flag); {set local civil}
end;


procedure TAstronomy.SetGSTime(Value:TDateTime);
{set Greenwich sidereal time }
var
  SG,TL:Extended;
  Flag:integer;
begin
  FGreenwichSiderealTime:=value;
  SG:=value*24;
  TL:=Adjust24(sg+FgeolonLat.x/15.0, Flag); {Local Sidereal}
  setLSTime(TL/24.0); {set local sidereal}
end;

{****************** Position Routines ***************}

procedure TAstronomy.setgeolonLat(value:TRPoint);
{set geographical longitude and latitude}
var
  f:extended;
begin
  fgeolonLat:=value;
  f:=degtorad(value.x);
  coslong:=cos(f);
  sinlong:=sin(f);
  f:=degtorad(value.y);
  coslat:=cos(f);
  sinlat:=sin(f);
end;

  procedure TAstronomy.setAzAlt(value:TRPoint);
  {set Horizon system aximuth and altitude}
  begin
    FAzAlt:=value;
    gencom(1,FAzAlt,FHaDecl);
    gencom(3,FHADecl,FRaDecl);
    gencom(5,FRADecl,FEcLonLat);
    gencom(7,FRADecl,FgalLonLat);
  end;

  procedure TAstronomy.setEcLonLat(value:TRPoint);
  {set Ecliptic longitude and latitude}
  begin
    FEclonLat:=value;
    gencom(6,FecLonLat,FRaDecl);
    gencom(4,FRADecl,FHaDecl);
    gencom(2,FHADecl,FAzAlt);
    gencom(7,FRADecl,FGalLonLat);
  end;

  procedure TAstronomy.setGalLonLat(value:TRPoint);
  {set Galactic system longitude and latitude}
  begin
    FGalLonLat:=value;
    gencom(8,FGalLonLat,FRaDecl);
    gencom(4,FRADecl,FHaDecl);
    gencom(2,FHADecl,FAzAlt);
    gencom(5,FRADecl,FEcLonLat);
  end;

  procedure TAstronomy.setHADecl(value:TRPoint);
  {set Equatorial system hour angle and declination}
  begin
    FHaDecl:=value;
    FHADecl.x:=FHADECL.x*15;  {Keep hours as degrees internally}
    gencom(2,FHaDecl,FAzAlt);
    gencom(3,FHADecl,FRaDecl);
    gencom(5,FRADecl,FEcLonLat);
    gencom(7,FRADecl,FGalLonLat);
    
  end;

  function TAstronomy.GetHADecl:TRPoint;
  {retrieve Equatorial system hour angle and declination}
  begin
    result:=FHADecl;
    result.x:=result.x/15.0;
  end;

  procedure TAstronomy.SetRADecl(value:TRPoint);
  {set Equatorial system right ascension  and declination}
  begin
    FRADecl:=value;
    FRADecl.x:=FRADecl.x*15.0;
    gencom(4,FRADecl,FHaDecl);

    gencom(2,FHaDecl,FAzAlt);

    gencom(5,FRADecl,FEcLonLat);
    gencom(7,FRADecl,FGalLonLat);
  end;

  function TAstronomy.GetRADecl:TRPoint;
  {retrieve Equatorial system right ascension  and declination}
  begin
    result:=FRADecl;
    result.x:=result.x/15.0; {convert degrees back to hours}
  end;


procedure TAstronomy.GenCom(opt:integer; inVal:TRPoint; var OutVal:TRpoint);
{general coordinate system converter}

{ Opt   1: Az/Alt to Ha/Decl
        2: HA/Decl to Az/Alt
        3: HA/Decl to RA/Decl
        4: RA/Decl to HA/Decl
        5: RA/Decl to Ec Lon/Lat
        6: Ec Lon/Lat to RA/Decl
        7: RA/Decl to Gal Lon/Lat
        8: Gal Lon/Lat to RA/Decl
 }

Var
  CN,P,A,SM:extended;
  cv,HL:array[1..3] of extended;
  MT:array[1..3,1..3] of extended;
  X,Y:extended;
  I,J:integer;
begin
  IF opt=0 THEN exit;

  {REM Convert input into column vector }
  X:=DegToRad(InVal.x);
  Y:=DegToRad(InVal.Y);
  CN:=COS(y);
  CV[1]:=COS(x)*CN;
  CV[2]:=SIN(X)*CN;
  CV[3]:=SIN(Y);


  {REM Construct the matrices   }


    case opt of
      1,2:
        begin   {2325}
          {REM Az/Alt and Ha/Dec}
          FOR J:=1 TO 3 do FOR I:=1 TO 3 do MT[I,J]:=0;
          MT[1,1]:=-sinlat{SF};
          MT[3,1]:=coslat{CF};
          MT[2,2]:=-1.0;
          MT[1,3]:=coslat{CF};
          MT[3,3]:=sinlat{SF};
        end;

      3,4:
        begin
          {2360}
          {REM Ra/Dec and Ha/Dec}
          FOR J:=1 TO 3 do FOR I:=1 TO 3 do MT[I,J]:=0.0;
          MT[1,1]:=CosLST; {load up Local sidereal time trig funcs}
          MT[2,1]:=SinLST;
          MT[1,2]:=SinLST;
          MT[2,2]:=-CosLST;
          MT[3,3]:=1.0;
        end;
      5,6:
        begin  {Ra/Decl and Ecliptic Lon/Lat}
          {2395}  {uses obliquity trig function values}
          FOR J:=1 TO 3 do  FOR I:=1 TO 3 do MT[I,J]:=0.0;
          MT[1,1]:=1.0; MT[2,2]:=CosOb; MT[3,2]:=SinOb;
          MT[2,3]:=-SinOb; MT[3,3]:=CosOb;
          If opt=6 then
          begin
            {2430}
            A:=MT[3,2];
            MT[3,2]:=MT[2,3];
            MT[2,3]:=A;
          end;
        end;
      7:
        begin
          {2445}
          {REM RA/Decl to Galactic coordinates}
          MT[1,1]:=-0.0669887;  MT[2,1]:=-0.8727558;  MT[3,1]:=-0.4835389;
          MT[1,2]:=0.4927285;   MT[2,2]:=-0.450347;   MT[3,2]:=0.7445846;
          MT[1,3]:=-0.8676008;  MT[2,3]:=-0.1883746;  MT[3,3]:=0.4601998;
        end;
      8:
        begin
         {2470}
         {REM RA/Decl to Galactic coordinates}
          MT[1,1]:=-0.0669887; MT[1,2]:=-0.8727558; MT[1,3]:=-0.4835389;
          MT[2,1]:=0.4927285;  MT[2,2]:=-0.450347;  MT[2,3]:=0.7445846;
          MT[3,1]:=-0.8676008; MT[3,2]:=-0.1883746; MT[3,3]:=0.4601998;
        end;
    end;{case}

  {REM Multiply each matrix by the column vector}
  {2275}
  if opt<>0 then
  begin
    FOR J:=1 TO 3 do
    begin
      SM:=0.0;
      FOR I:=1 TO 3 do SM:=SM+MT[I,J]*CV[I];
      HL[J]:=SM;
    end;
    FOR I:=1 TO 3 do CV[I]:=HL[I];
  end;


  {REM Convert column vector into output}

  {2295}
  IF ABS(CV[1])<1E-20 THEN CV[1]:=1E-20;
  P:=ArcTaN(CV[2]/CV[1]);
  IF CV[1]<0 THEN P:=P+PI;
  While P<0 do P:=P+TP;
  While  P>TP do P:=P-TP;
  outval.x:=RadtoDeg(P);
  outval.y:=RadToDeg(arcsin(CV[3]));
end;


procedure TAstronomy.Anomaly(EC,AM:extended; Var AE,AT:extended);
var
  M:Extended;
  A,D,E:extended;
  precision:extended;
begin
  Precision:=1e-6;
  M:=AM-TP*Int(AM/TP);
  AE:=M;
  E:=1;
  while abs(E)>=precision do
  begin
    E:=AE-(EC*Sin(AE))-M;
    If Abs(E)>=precision then
    begin
      D:=E/(1.0-(EC*Cos(AE)));
      AE:=AE-D;
    end;
  end;
  A:=SQRT((1.0+EC)/(1.0-EC))*TAN(AE/2.0);
  AT:=2.0*ArcTan(A);
end;


procedure TAstronomy.SunPos(var Sunrec:TSunrec);
{calculate current sun position}
var
  T,T2:extended;
  AM,AE,AT:extended;
  A,A1,B,L,B1,M1,EC:extended;
  C1,D1,D2,D3,E1,H1:extended;
  SR:extended;
begin
  T:=(FJDate+int(funiversaltime))/36525.0+(Frac(FUniversalTime)*24/8.755e5);
  T2:=T*T;
  A:=1.000021359E2*T;
  B:=360*(FRAC(A));
  L:=2.7969668E2+3.025E-4*T2+B;

  A:=9.999736042E1*T;
  B:=360*(FRAC(A));
  M1:=3.5847583E2-(1.5E-4+3.3E-6*T)*T2+B;

  EC:=1.675104E-2-4.18E-5*T-1.26E-7*T2;

  AM:=DEGTORAD(M1);

  ANOMALY(EC,AM, AE,AT);
  A:=6.255209472e1*T;       B:=360*(Frac(A));
  A1:=DegToRad(153.23+B);

  A:=1.251041894E2*T;       B:=360*(Frac(A));
  B1:=DegToRad(216.57+B);

  A:=9.156766028E1*T;       B:=360*(Frac(A));
  C1:=DegToRad(312.69+B);

  A:=1.236853095E3*T;       B:=360*(Frac(A));
  D1:=DegToRad(350.74-1.44E-3*T2+B);
  E1:=DegToRad(231.19+20.2*T);

  A:=1.831353208E2*T;       B:=360*(Frac(A));
  H1:=DegToRad(353.4+B);

  D2:=1.34E-3*COS(A1)+1.54E-3*COS(B1)+2E-3*COS(C1)
      +1.79E-3*SIN(D1)+1.78E-3*SIN(E1);

  D3:=5.43E-6*SIN(A1)+1.575E-5*SIN(B1)
          +1.672E-5*SIN(C1)+3.076E-5*COS(D1) +9.27E-6*SIN(H1);

  SR:=AT+DEGTORAD(L-M1+D2);
  WHILE SR<0 DO SR:=SR+TP;
  WHILE SR>TP DO SR:=SR-TP;
  with sunrec do
  begin
    AuDistance:=1.0000002*(1.0-EC*COS(AE))+D3;
    TrueEclLon:=RadToDeg(SR);
    gencom(6,RPoint(TrueEclLon,0.0),TrueRADecl);
    gencom(4,TrueRADecl,TrueHADecl);
    gencom(2,TrueHADecl,TrueAzAlt);
    TrueRADecl.x:=TrueRAdecl.x/15;  {convert to hours}
    TrueHADecl.x:=TrueHAdecl.x/15;
    AppEclLon:=TrueEclLon+NuLong-5.69E-3;
    gencom(6,RPoint(AppEclLon,0.0),AppRADecl);
    gencom(4,AppRADecl,AppHADecl);
    gencom(2,AppHADecl,AppAzAlt);
    AppRADecl.x:=AppRAdecl.x/15;  {convert to hours}
    AppHADecl.x:=AppHAdecl.x/15;
    SunMeanAnomaly:=AM;
  end;
END;



function TAstronomy.SunRiseSet(CalcType:integer;
                              var UpTmAz, DNTmAz:TRPoint):string;


       function calcit(DI:extended; var CUpTmaz, CDnTmAz:TRPoint):string;{3710}
       var
         inval,outval:TRPoint;
         AzUp,AzDn,LSTUp,LStDn:extended;
         Sunrec:TSunrec;
       begin
         result:='';
         Sunpos(Sunrec);
         Nutate;
         inval.x:=sunrec.AppEClLon{SunGeoLong+Nulong-5.69E-3};
         inval.y:=0;
         Gencom(6,inval,outval);

         inval:=Sunrec.AppRADecl;
         inval.x:=inval.x*15;
         Riseset(inval, DI, Azup,Azdn,LstUp,LstDn);

         CUpTMAz.x:=LSTUp;
         CUpTmAz.Y:=AzUp;
         CDnTmAz.x:=LSTDn;
         CDnTmAz.y:=AzDn;
      end;


var
  DI:extended;
  saveUT:TDateTime;
  s:string;
  EstTmAz1,EstTmAz2:TRPoint;
  Dummy:TRPoint;
  LA,LB:Extended;
begin
    result:='';
    DI:=1.45441E-2;
    saveUT:=FUniversaltime;
    case Calctype of
     0: DI:=180*1.454441E-2/PI;  {Sunrise, Sunset}
     1: DI:=180*1.047198E-1/pi;  {Civil Twilight}
     2: DI:=180*2.094395E-1/pi;  {Nautical twilight}
     3: DI:=180*3.141593E-1/pi;  {Astronomical Twilight}
    end;

    SetUniversaltime((12.0+FTZHours+FDLSHours)/24.0);
    {Get Local Sidereal rise/set times}
    s:=calcit(DI,EstTmAz1, EstTmAz2);
    LA:=EstTmAz1.X;
    LB:=EstTmAz2.x;
    if s<>'' then
    begin
      result:=s;
      SetUniversaltime(SaveUT);
      exit;
    end;
    setLSTime(LA/24.0);
    S:=Calcit(DI, UpTmAz, Dummy); {GOSUB 3710}
    IF S<>'' then
    begin
      result:=s;
      SetUniversaltime(SaveUT);
      exit;
    end;
    SetLSTime(LB/24.0);
    s:=Calcit(DI,Dummy, DnTmAz);
    IF S<>'' then result:=s;
    SetUniversaltime(SaveUT);
end;
{********************* RiseSet ***************************}
function TAstronomy.RiseSet(Inval:TRPoint; InDI:extended;
                             var AzUp,AzDn, LSTUp,LSTDn:extended):STRING;
{Input Geocentric coordinates,
 {
  Inputs:
           InVal is RaDecl with RA in archours (hrs*15)  and Decl in degrees
           InDI vertical displacement in degrees due to parallax and refraction
  Outputs: AzUP and AzDn in degress,
           LSTUp,LstDn= Local Sideral times in hours
  }
var
  X,Y,DI:extended;
  A,B,SY,CY,SD,CA,CD,H,CH:extended;
begin
  RESULT:='';
  LSTUP:=0; LSTDn:=0;
  AZUp:=0; AZDn:=0;
  x:=DegToRad(Inval.x);
  Y:=DegToRad(Inval.y);
  DI:=DegTorad(InDi);
  SY:=Sin(y);
  CY:=COS(Y);
  SD:=SIN(DI);
  CD:=COS(DI);
  CH:=0;
  If coslat<>0 then
  begin
    CH:=-(SD+(SINLAT*SY))/(COSLAT*CY);
    IF CH<-1 THEN RESULT:='NEVER SETS'
    ELSE iF CH>+1 THEN RESULT:='NEVER RISES';
  END
  else result:='No Latitude entered';
  if result='' then
  begin
    CA:=(SY+(SD*SinLat))/(CD*CosLat);
    H:=arccos(CH);
    AzUp:=arccos(CA);
    B:=RadToDeg(H)/15.0;
    A:=RadToDeg(X)/15.0;
    LstUP:=24.0+A-B;
    LstDN:=A+B;
    AzDn:=TP-AzUp;
    while LSTUp<0 do LSTUp:=LstUp+24.0;
    while LSTUp>24 do LstUp:=LSTUp-24.0;
    while LSTDn<0 do LstDn:=LSTDn+24;
    while LSTDN>24 do LSTDn:=LSTDn-24;
    while AzUp<0 do AzUp:=AzUp+TP;
    While AzUp>TP do AzUp:=AzUp-TP;
    while AzDn<0 do AzDn:=AzDn+TP;
    While AzDn>TP do AzDn:=AzDn-TP;
    AzUp:=RadToDeg(azup);
    AzDn:=RadToDeg(AzDn);
  end;
end;

{******************* MoonPos *************************}
Procedure TAstronomy.MoonPos(var Moonrec:TMoonRec);
VAR
  T,T2,M1,M2,M3,M4,M5,M6:EXTENDED;
  Q,ML,MS,MD,ME,MF,MM,NA,A,B,C,E,E2:EXTENDED;
  S1,S2,S3,S4:EXTENDED;
  L,G,W1,W2,BM,PM:EXTENDED;
  HAPoint, NowAzAlt:TRPoint;
  R,F,TH,I,D,SD,CD,K:extended;
  Sunrec:TSunrec;
begin
    T:=(FJDate/36525.0)+(FUniversalTime/8.766E5);
    T2:=T*T;
    M1:=2.732158213E1;	M2:=3.652596407E2;
    M3:=2.755455094E1;	M4:=2.953058868E1;
    M5:=2.721222039E1;	M6:=6.798363307E3;
    Q:=FJDate+FUniversalTime;
    M1:=Q/M1;
    M2:=Q/M2;
    M3:=Q/M3;	M4:=Q/M4; M5:=Q/M5; M6:=Q/M6;
    M1:=360*FRAC(M1);	M2:=360*FRAC(M2);
    M3:=360*FRAC(M3);	M4:=360*FRAC(M4);
    M5:=360*FRAC(M5);	M6:=360*FRAC(M6);

    ML:=2.70434164E2+M1-(1.133E-3-1.9E-6*T)*T2;
    MS:=3.58475833E2+M2-(1.5E-4+3.3E-6*T)*T2;
    MD:=2.96104608E2+M3+(9.192E-3+1.44E-5*T)*T2;
    ME:=3.50737486E2+M4-(1.436E-3-1.9E-6*T)*T2;
    MF:=11.250889+M5-(3.211E-3+3E-7*T)*T2;

    NA:=2.59183275E2-M6+(2.078E-3+2.2E-6*T)*T2;
    A:=DegToRad(51.2+20.2*T);
    S1:=SIN(A); S2:=SIN(DegToRad(NA));
    B:=346.56+(132.87-9.1731E-3*T)*T;
    S3:=3.964E-3*SIN(DegToRad(B));
    C:=DegToRad(NA+275.05-2.3*T); S4:=SIN(C);
    ML:=ML+2.33E-4*S1+S3+1.964E-3*S2;
    MS:=MS-1.778E-3*S1;
    MD:=MD+8.17E-4*S1+S3+2.541E-3*S2;
    MF:=MF+S3-2.4691E-2*S2-4.328E-3*S4;
    ME:=ME+2.011E-3*S1+S3+1.964E-3*S2;
    E:=1-(2.495E-3+7.52E-6*T)*T; E2:=E*E;
    ML:=DeGToRad(ML);	MS:=DegToRad(MS); NA:=DegToRad(NA);
    ME:=DegToRad(ME); MF:=DegToRad(MF);  MD:=DegToRad(MD);

    L:=6.28875*SIN(MD)+1.274018*SIN(2*ME-MD);
    L:=L+6.58309E-1*SIN(2*ME)+2.13616E-1*SIN(2*MD);
    L:=L-E*1.85596E-1*SIN(MS)-1.14336E-1*SIN(2*MF);
    L:=L+5.8793E-2*SIN(2*(ME-MD));
    L:=L+5.7212E-2*E*SIN(2*ME-MS-MD)+5.332E-2*SIN(2*ME+MD);
    L:=L+4.5874E-2*E*SIN(2*ME-MS)+4.1024E-2*E*SIN(MD-MS);
    L:=L-3.4718E-2*SIN(ME)-E*3.0465E-2*SIN(MS+MD);
    L:=L+1.5326E-2*SIN(2*(ME-MF))-1.2528E-2*SIN(2*MF+MD);
    L:=L-1.098E-2*SIN(2*MF-MD)+1.0674E-2*SIN(4*ME-MD);
    L:=L+1.0034E-2*SIN(3*MD)+8.548E-3*SIN(4*ME-2*MD);
    L:=L-E*7.91E-3*SIN(MS-MD+2*ME)-E*6.783E-3*SIN(2*ME+MS);
    L:=L+5.162E-3*SIN(MD-ME)+E*5E-3*SIN(MS+ME);
    L:=L+3.862E-3*SIN(4*ME)+E*4.049E-3*SIN(MD-MS+2*ME);
    L:=L+3.996E-3*SIN(2*(MD+ME))+3.665E-3*SIN(2*ME-3*MD);
    L:=L+E*2.695E-3*SIN(2*MD-MS)+2.602E-3*SIN(MD-2*(MF+ME));
    L:=L+E*2.396E-3*SIN(2*(ME-MD)-MS)-2.349E-3*SIN(MD+ME);
    L:=L+E2*2.249E-3*SIN(2*(ME-MS))-E*2.125E-3*SIN(2*MD+MS);
    L:=L-E2*2.079E-3*SIN(2*MS)+E2*2.059E-3*SIN(2*(ME-MS)-MD);
    L:=L-1.773E-3*SIN(MD+2*(ME-MF))-1.595E-3*SIN(2*(MF+ME));
    L:=L+E*1.22E-3*SIN(4*ME-MS-MD)-1.11E-3*SIN(2*(MD+MF));
    L:=L+8.92E-4*SIN(MD-3*ME)-E*8.11E-4*SIN(MS+MD+2*ME);
    L:=L+E*7.61E-4*SIN(4*ME-MS-2*MD);
    L:=L+E2*7.04E-4*SIN(MD-2*(MS+ME));
    L:=L+E*6.93E-4*SIN(MS-2*(MD-ME));
    L:=L+E*5.98E-4*SIN(2*(ME-MF)-MS);
    L:=L+5.5E-4*SIN(MD+4*ME)+5.38E-4*SIN(4*MD);
    L:=L+E*5.21E-4*SIN(4*ME-MS)+4.86E-4*SIN(2*MD-ME);

    L:=L+E2*7.17E-4*SIN(MD-2*MS);
    MM:=ML+DegToRad(L);	{TP:=6.283185308}
    While  MM<0 Do MM:=MM+TP;
    While  MM>TP Do MM:=MM-TP;
    {6290}G:=5.128189*SIN(MF)+2.80606E-1*SIN(MD+MF);
    G:=G+2.77693E-1*SIN(MD-MF)+1.73238E-1*SIN(2*ME-MF);
    G:=G+5.5413E-2*SIN(2*ME+MF-MD)+4.6272E-2*SIN(2*ME-MF-MD);
    G:=G+3.2573E-2*SIN(2*ME+MF)+1.7198E-2*SIN(2*MD+MF);
    G:=G+9.267E-3*SIN(2*ME+MD-MF)+8.823E-3*SIN(2*MD-MF);
    G:=G+E*8.247E-3*SIN(2*ME-MS-MF)+4.323E-3*SIN(2*(ME-MD)-MF);
    G:=G+4.2E-3*SIN(2*ME+MF+MD)+E*3.372E-3*SIN(MF-MS-2*ME);
    G:=G+E*2.472E-3*SIN(2*ME+MF-MS-MD);
    G:=G+E*2.222E-3*SIN(2*ME+MF-MS);
    G:=G+E*2.072E-3*SIN(2*ME-MF-MS-MD);
    G:=G+E*1.877E-3*SIN(MF-MS+MD)+1.828E-3*SIN(4*ME-MF-MD);
    G:=G-E*1.803E-3*SIN(MF+MS)-1.75E-3*SIN(3*MF);
    G:=G+E*1.57E-3*SIN(MD-MS-MF)-1.487E-3*SIN(MF+ME);
    G:=G-E*1.481E-3*SIN(MF+MS+MD)+E*1.417E-3*SIN(MF-MS-MD);
    G:=G+E*1.35E-3*SIN(MF-MS)+1.33E-3*SIN(MF-ME);
    G:=G+1.106E-3*SIN(MF+3*MD)+1.02E-3*SIN(4*ME-MF);
    G:=G+8.33E-4*SIN(MF+4*ME-MD)+7.81E-4*SIN(MD-3*MF);
    {6375}G:=G+6.7E-4*SIN(MF+4+ME-2*MD)+6.06E-4*SIN(2*ME-3*MF);
    G:=G+5.97E-4*SIN(2*(ME+MD)-MF);
    G:=G+E*4.92E-4*SIN(2*ME+MD-MS-MF)+4.5E-4*SIN(2*(MD-ME)-MF);
    G:=G+4.39E-4*SIN(3*MD-MF)+4.23E-4*SIN(MF+2*(ME+MD));
    G:=G+4.22E-4*SIN(2*ME-MF-3*MD)-E*3.67E-4*SIN(MS+MF+2*ME--MD);
    G:=G-E*3.53E-4*SIN(MS+MF+2*ME)+3.31E-4*SIN(MF+4*ME);
    G:=G+E*3.17E-4*SIN(2*ME+MS+MD);
    G:=G+E2*3.06E-4*SIN(2*(ME-MS)-MF)-2.83E-4*SIN(MD+3*MF);
    W1:=4.664E-4*COS(NA);  W2:=7.54E-5*COS(C);
    BM:=DegToRad(G)*(1.0-W1-W2);

    PM:=9.50724E-1+5.1818E-2*COS(MD)+9.531E-3*COS(2*ME-MD);
    PM:=PM+7.843E-3*COS(2*ME)+2.824E-3*COS(2*MD);
    PM:=PM+8.57E-4*COS(2*ME+MD)+E*5.33E-4*COS(2*ME-MS);
    PM:=PM+E*4.01E-4*COS(2*ME-MD-MS);
    PM:=PM+E*3.2E-4*COS(MD-MS)-2.71E-4*COS(ME);
    PM:=PM-E*2.64E-4*COS(MS+MD)-1.98E-4*COS(2*MF-MD);
    PM:=PM+1.73E-4*COS(3*MD)+1.67E-4*COS(4*ME-MD);
    PM:=PM-E*1.11E-4*COS(MS)+1.03E-4*COS(4*ME-2*MD);
    PM:=PM-8.4E-5*COS(2*MD-2*ME)-E*8.3E-5*COS(2*ME+MS);
    PM:=PM+7.9E-5*COS(2*ME+2*MD)+7.2E-5*COS(4*ME);
    PM:=PM+E*6.4E-5*COS(2*ME-MS+MD)-E*6.3E-5*COS(2*ME-MS-MD);
    PM:=PM+E*4.1E-5*COS(MS+ME)+E*3.5E-5*COS(2*MD-MS);
    PM:=PM-3.3E-5*COS(3*MD-2*ME)-3E-5*COS(MD+ME);
    PM:=PM-2.9E-5*COS(2*(MF-ME))-E*2.9E-5*cos(2*MD+MS);
    PM:=PM+E2*2.6E-5*COS(2*(ME-MS))-2.3E-5*COS(2*(MF-ME)+MD);
    PM:=PM+E*1.9E-5*COS(4*ME-MS- MD);
    PM:=DegToRad(PM);
    {RETURN }
    with moonrec do
    begin
      ECLonLat.x:=RadToDeg(MM){+NuLong};
      EcLonLat.y:=RadToDeg(BM);
      gencom(6,EcLonLat,RADecl);
      gencom(4,RADecl,HAPoint);
      gencom(2,HAPoint,AZAlt);
      radecl.x:=radecl.x/15; {convert back to HMS}
      HorizontalParallax:=RadToDeg(PM);
      R:=6378.14/sin(PM);
      F:=R/384401.0;
      TH:=5.18E-1/F;
      AngularDiameter:=TH;
      KMtoEarth:=round(R);
      SunPos(Sunrec);
      CD:=COS(MM-Degtorad(Sunrec.TrueEclLon))*COS(BM);
      D:=1.570796327-arcsin(CD);
      SD:=SIN(D);
      I:=1.468E-1*SD*(1.0-5.49E-2*SIN(MD));
      I:=I/(1.0-1.67E-2*SIN(MS));
      I:=PI-D-DegToRad(I);
      K:=(1.0+COS(I))/2;
      Phase:=Round(K*1000)/1000;
    end;
  END;

  function TAstronomy.MoonRiseSet(var UpTmAz, DnTmAz:TRPoint):string;
  var altitude:extended;
  begin
    result:=MoonRiseSet(UpTmAz, DnTmAz,altitude);
  end;


  {************************ MoonRiseSet (altitude) **********************}
  function TAstronomy.MoonRiseSet(var UpTmAz, DnTmAz:TRPoint;
                                 var altitude:extended):string;  
       {local rtn CalcIt}
  var
     DI:extended;
     Moonrec:TMoonrec;


       function calcit(var CUpTmaz, CDnTmAz:TRPoint):string;{3710}
       var
         inval,outval:TRPoint;
         AzUp,AzDn,LSTUp,LStDn:extended;
         TH:Extended;

       begin
         result:='';
         MoonPos(Moonrec);
         Nutate;
         TH:=2.7249E-1*SIN(degtorad(Moonrec.HorizontalParallax));
         DI:=radtodeg(TH+9.8902E-3)-Moonrec.HorizontalParallax;
         inval.x:=MoonRec.EcLonLat.x+Nulong;
         inval.y:=moonrec.EcLonLat.Y;
         Gencom(6,inval,outval); {Ecliptic to RA}
         Riseset(Outval, DI, Azup,Azdn,LstUp,LstDn);
         CUpTMAz.x:=LSTUp;
         CUpTmAz.Y:=AzUp;
         CDnTmAz.x:=LSTDn;
         CDnTmAz.y:=AzDn;
      end;

var
  saveUT:TDateTime;
  s:string;
  EstTmAz1,EstTmAz2:TRPoint;
  Dummy:TRPoint;
  LA,LB,A:Extended;
  GU,GD,G1,G2,DN:TDateTime;
  K:integer;
  begin
    saveut:=FUniversaltime;
    result:='';
    SetUniversaltime((12.0+FTZHours+FDLSHours)/24.0);
    {Get Local Sidereal rise/set times}
    s:=calcit(EstTmAz1, EstTmAz2);
    LA:=EstTmAz1.X;
    LB:=EstTmAz2.x;
    GU:=0;  GD:=0;
    if s='' then
    for k:= 1 to 3 do {loop 3 times to get better rise & set times}
    begin
      G1:=GU;
      setLSTime(LA/24.0);
      GU:=FUniversalTime;
      Dn:=FJDate; {Sane real date}
      A:=FUniversalTime*24+TZHours+DLSHours;
      If A>24 then FJDate:=FJDate-1;
      If A<0  then FJDate:=FJDate+1;
      S:=Calcit(UpTmAz, Dummy); {GOSUB 3710}
      LA:=UpTmAz.X;
      FJDate:=DN; {Restore real date}
      IF S<>'' then break;
      G2:=GD;
      SetLSTime(LB/24.0);
      GD:=FUniversalTime;
      Dn:=FJDate; {Save real date}
      A:=FUniversalTime*24+TZHours+DLSHours;
      If A>24 then FJDate:=FJDate-1;
      If A<0  then FJDate:=FJDate+1;
      s:=Calcit(Dummy, DnTmAz);
      LB:=DnTmAz.x;
      FJDate:=DN; {Restore real date}
      IF S<>'' then break;
    end;

    Setuniversaltime(SaveUT);
    If s<>'' then  result:=s
    else If Abs(GU-G1)>6/24 then
    begin
      result:='Rises on next day';
      {uptmaz.y:=-1; }
    end
    else If abs(GD-G2)>6/24 then
    begin
      result:='Sets on next day';
      {dntmaz.y:=-1;  }
    end;
    altitude:=-DI; {offset from zero to true altitude}
  end;

  FUNCTION FNV(A:EXTENDED):EXTENDED;
  {make sure angle is in range 0-360}
  BEGIN
    RESULT:=A-FLOOR(A/360.0)*360.0;
  END;

 {*********************** NewFullMoon ***********************}
Procedure TAstronomy.NewFullMoon(Date:TDateTime;
                               VAR FULLDATETIME, NEWDATETIME:TDATETIME;
                               VAR FULLLAT,NEWLAT:EXTENDED);

  PROCEDURE LOCAL(T,K:EXTENDED; VAR A:TDATETIME; VAR F:EXTENDED);
  VAR
    T2,C,E,A1,A2,DD,E1,B:EXTENDED;
  BEGIN
    T2:=T*T;
    E:=29.53*K;
    C:=DEGTORAD(166.56+(132.87-9.173E-3*T)*T);
    B:=5.8868E-4*K+(1.178E-4-1.55E-7*T)*T2;
    B:=B+3.3E-4*SIN(C)+7.5933E-1;
    A:=K/1.236886E1;
    A1:=359.2242+360*FRAC(A)-(3.33E-5+3.47E-6*T)*T2;
    A2:=306.0253+360.0*FRAC(K/9.330851E-1);
    A2:=A2+(1.07306E-2+1.236E-5*T)*T2;
    A:=K/9.214926E-1;
    F:=21.2964+360*FRAC(A)-(1.6528E-3+2.39E-6*T)*T2;
    A1:=FNV(A1);  A2:=FNV(A2);	F:=FNV(F);
    A1:=DEGTORAD(A1); A2:=degtorad(A2); F:=degtorad(F);
    dd:=(1.734e-1-3.93e-4*t)*sin(a1)+2.1e-3*sin(2*a1);
    DD:=DD-4.068E-1*SIN(A2)+1.61E-2*SIN(2*A2)-4E-4*SIN(3*A2);
    DD:=DD+1.04E-2*SIN(2*F)-5.1E-3*SIN(A1+A2);
    DD:=DD-7.4E-3*SIN(A1-A2)+4E-4*SIN(2*F+A1);
    DD:=DD-4E-4*SIN(2*F-A1)-6E-4*SIN(2*F+A2)+1E-3*SIN(2*F-A2);
    DD:=DD+5E-4*SIN(A1+2*A2);
    E1:=INT(E);
    B:=B+DD+E-E1;

    {B1:=INT(B); }
    A:=E1+B+1.5{+DLSHours/24.0};
    {B:=B-Bl;}
  END;


FUNCTION GETYEAR(DATE:TDATETIME):INTEGER;
VAR
  M,D,Y:WORD;
BEGIN
  DECODEDATE(DATE,Y,M,D);
  RESULT:=Y;
END;

VAR
  D1,K,TN,TF:EXTENDED;
 // U:TDateTime;
begin {NewFullMoon}

  //D1:=Date-strtodate('1/1/'+inttostr(getyear(Date)))+1;
  D1:=Date-encodedate(getyear(Date),1,1)+1;
  K:=FLOOR(((GETYEAR(DATE)-1900.0+(D1/365))*12.3685)+0.5);
  TN:=K/1236.5;
  TF:=(K+0.5)/1236.85;
  LOCAL(TN,K,NEWDATETIME, NEWLAT);
  K:=K+0.5;
  LOCAL(TF,K,FULLDATETIME,FULLLAT);
END; {NewFullMoon}



Procedure TAstronomy.HRang(X:extended; var P:extended);
begin
  P:=FLocalSiderealTime*24;
  while P>24 do P:=P-24;
  while P<0 do P:=P+24;
  P:=P-X;
  while P>24 do P:=P-24;
  while P<0 do P:=P+24;
end;

PROCEDURE TAstronomy.ECLIPSE (Etype:char; NearDate:TDatetime;
                               var EclipseRec:TEclipseRec;
                               var MoonAdd:TMoonEclipseAdd);


      PROCEDURE LOCALPARALLAX(X,Y,TM,HP:extended; var P,Q:extended);
      {TM - local time in hours}
      Var
        InPt,RAPt:TRPoint;
        HADIN,HADOut,RAOut,ECLOut:TRPoint;
        CN,UT:extended;
        savetime:TDateTime;
      BEGIN
        Savetime:=Localtime;
        Inpt.x:=Radtodeg(x); InPt.y:=radtodeg(Y);
        ut:=Funiversaltime;
        LocalTime:=TM/24.0;
        NUTAte; Oblique;
        GenCom(ECLRA,InPt,RAPt); {Convert ECL to RA}
        Funiversaltime:=Ut;
        rapt.x:=degtorad(rapt.x);
        rapt.y:=degtorad(rapt.y);
        CN:=3.819718634;   {radians to hours}
        HRang(RAPt.X*CN,P); {convert RA to HA}
        HADIn.x:=P/CN; {back to radians}
        HADIn.y:=RAPt.y;
        parallax(true,HADIn,HP, HaDOut); {get parallax both in radians}
        HRang(HADOut.x*CN,P); {HA in hours to to RA}
        RAOut.X:=radtodeg(P/CN); RAOut.Y:=radtodeg(HADOut.Y); {to degrees for gencom}
        Gencom(RAEcl,RAOut,ECLOut);
        p:=degtorad(ECLOut.x); Q:=degtorad(ECLOut.y); {and ECL coords back to radians}
        Localtime:=Savetime;
      END;


Var
  NL,X,UT,X0,X1,LY:Extended;
  My,MY1,MY2,MR,By,BY1,BY2,HD,Hy:extended;
  MZ,MZ1,MZ2,Bz,BZ1,BZ2,Hz:Extended;
  SB,SH,SR,S2,XH,LJ,CN:extended;
  DD,DF,DJ,DM,DP:extended;
  HP:extended;
  PJ,P3,PS,TC:extended;
  ZH,ZB,ZC,ZD,Z0,Z1,Z2,Z6,Z7,Z8,Z9:extended;
  FullDateTime, NewDateTime:TDateTime;
  FullLat,NewLat:extended;
  SunRec:TSunrec;
  Moonrec:TMoonRec;
  Q,H0:extended;
  R,RM,RN,RP,RU:Extended;
  MG:Extended;
  SavedateTime:TDateTime;
  SaveDls,SaveTZ:integer;
  TMsg:string;
BEGIN
  Savedatetime:=Adate+localtime;
  savetz:=TZHours;
  SaveDLS:=DLSHours;
  Adate:=Neardate;

  TZHours:=0;  {force everything to universal time}
  DLSHours:=0;  

  Etype:=upCase(EType);
  eclipserec.msg:='';
  eclipserec.status:=0;
  NewFullMoon(Neardate,FULLDATETIME, NEWDATETIME,FULLLAT,NEWLAT);
  if etype='L' then
  begin
     NL:=Fulllat;
     tmsg:='Lunar';
  end
  else
  begin
    NL:=Newlat;
    TMsg:='Solar';
  end;
  DF:=ABS(NL-Floor(NL/PI)*PI);

  IF DF>0.37 THEN DF:=PI-DF;

  IF DF<0.242600766 THEN Eclipserec.MSG:=tmsg+' eclipse is certain '
  ELSE IF DF<=0.37 THEN  EclipseRec.Msg:= tmsg+' eclipse is possible'
  else with EclipseRec do
  begin
    Msg:=' No '+tmsg +' eclipse ';
    Status:=1;
  End;

  If etype='L' then
  begin
    ADate:=int(FullDateTime);
    X:=Frac(FullDatetime);
  end
  else
  begin
    ADate:=Int(NewDateTime);
    X:=Frac(NewDatetime);
  end;
  DP:=0;
  IF X<0 THEN
  BEGIN
    X:=X+1;
    Adate:=Adate-1;
  END;
  IF EclipseRec.Status<>0 THEN
  begin
    Adate:=Int(Savedatetime);
    Localtime:=Frac(SaveDateTime);
    TZHours:=SaveTZ;
    DLSHours:=SaveDLS;
    Exit;
  end;
  FUniversalTime:=X-1/24; {subtract an hour}
  X1:=X;
  Sunpos(Sunrec);
  LY:=DegToRad(sunrec.trueEClLon);
  MoonPos(Moonrec);
  My:=DegToRad(Moonrec.eclonlat.x);
  BY:=DegToRad(Moonrec.eclonLat.y);
  Hy:=DegtoRad(Moonrec.HorizontalParallax);

  FUniversaltime:=FUniversaltime+2/24; {add an hour}
  SunPos(Sunrec);
  SB:=DegToRad(Sunrec.TrueEClLon)-LY;
  IF SB<0 THEN SB:=SB+TP;
  MoonPos(MoonRec);
  MZ:=Degtorad(Moonrec.eclonlat.x);
  BZ:=DegToRad(Moonrec.eclonlat.y);
  HZ:=DegtoRad(Moonrec.HorizontalParallax);
  XH:=X1*24.0;  {convert to hours}
  Funiversaltime:=X1;
  If etype='S' then
  Begin
    NUTATE;
    Oblique;
    DP:=NULONG;
    LocalParallax(MY,By,XH-1.0,HY, MY1,By1);
    LocalParallax(MZ,BZ,XH+1.0,HZ, MZ1,BZ1);
     My:=My1; By:=BY1; MZ:=MZ1; BZ:=BZ1;
  end;

  X0:=XH+1.0-(2.0*BZ/(BZ-BY));  {time of 0 lunar latitude}
  DM:=MZ-MY;
  IF DM<0 THEN DM:=DM+TP;
  LJ:=(DM-SB)/2.0;
  Q:=0;
  MR:=MY+(DM*(X0-XH+1.0)/2.0) ;  {longitude of moon at 0 lat}
  FUniversalTime:=(X0-1.3851852E-1)/24;
  SunPos(Sunrec);
  SR:=DegToRad(Sunrec.TrueEclLon+DP-5.59E-3);
  If etype='L'  {lunar}
  then  SR:=SR+PI-FLoor((SR+PI)/TP)*TP {LUNAR ONLY}
  else
  begin  {solar}

    HP:=4.263452E-5/Sunrec.AUDistance;
    LocalParallax(Sr,0,FUniversaltime*24,HP,SR,Q);
    BY:=BY-Q;
    BZ:=BZ-Q;

  end;


  P3:=4.263E-5;
  ZH:=(SR-MR)/LJ;
  TC:=X0+ZH;
  SH:=(((BZ-BY)*(TC-XH-1.0)/2.0)+BZ)/LJ;
  S2:=SH*SH;
  Z2:=ZH*ZH;
  PS:=P3/(Sunrec.AUDistance*LJ);
  Z1:=(ZH*Z2/(Z2+S2))+X0; {UT HOUR TIME of max eclipse}
  H0:=(HY+HZ)/(2.0*LJ);
  RM:=2.72446E-1*H0; {radius of the moon in hours}
  RN:=4.65242E-3/(LJ*Sunrec.AuDistance); {radius of the sun in hours}
  HD:=H0*0.99834;
  RU:=(HD-RN+PS)*1.02; {radius of umbra(?) in hours}
  RP:=(HD+RN+PS)*1.02; {radius of penumbra in hours}
  PJ:=ABS(SH*ZH/SQRT(S2+Z2));
  if etype='S' then
  begin  {finish solar}
    R:=RM+RN;
    DD:=Z1-X0;
    DD:=DD*DD-((Z2-(R*R))*DD/ZH);
    IF DD<0 THEN
    with EclipseRec do
    BEGIN
      MSG:=MSG+' but is not seen from this location  ';
      status:=2;
      Adate:=Int(Savedatetime);
      Localtime:=Frac(SaveDateTime);
      TZHours:=SaveTZ;
      DLSHours:=SaveDLS;
      Exit;
    end;
    {add 11/4/03}
    r:=Rm+rp;
    dd:=x1-x0;
    dd:=dd*dd-((z2-(r*r))*dd/zh);
    if  dd<0 then
    with eclipserec do
    begin
      Msg:=msg+' but does not occur';
      status:=3;
      exit;
    end;

    ZD:=SQRT(DD);
    Z6:=Z1-ZD; {Time of first contact}
    Z7:=Z1+ZD-Floor((Z1+ZD)/24.0)*24.0 ; {Time of last contact}
    {IF Z6<0 THEN Z6:=Z6+24.0;}
    with EclipseRec do
    begin
      Magnitude:=(RM+RN-PJ)/(2.0*RN) ;  {eclipse magnitude}
      FirstContact:=Int(adate)+Z6/24;
      LastContact:=Int(Adate)+Z7/24;
      MaxeclipseUTime:=Int(Adate)+Z1/24;
    end;
    Adate:=Int(Savedatetime);
    Localtime:=Frac(SaveDateTime);
    TZHours:=SaveTZ;
    DLSHours:=SaveDLS;
    exit;
  end;
   {Lunar calcs}
   R:=RM+RP;
   DD:=Z1-X0;
   DD:=DD*DD-((Z2-(R*R))*DD/ZH);

   IF DD<0 THEN
   with eclipserec do
   BEGIN
      MSg:=MSG+ ' but does not occur ';
      Status:=3;
      Adate:=Int(Savedatetime);
      Localtime:=Frac(SaveDateTime);
      TZHours:=SaveTZ;
      DLSHours:=SaveDLS;
      EXIT;
   END;
   ZD:=SQRT(DD);
   Z6:=Z1-ZD;
   Z7:=Z1+ZD-Floor((Z1+ZD)/24.0)*24.0;
   {IF Z6<0 THEN Z6:=Z6+24.0;} {probabkly shouldn't do this without also adjusting the date}
   R:=RM+RU;
   DD:=Z1-X0;
   DD:=DD*DD-((Z2-(R*R))*DD/ZH);
   MG:=(RM+RP-PJ)/(2.0*RM);
   IF DD<0 THEN
   with eclipserec do
   BEGIN
     Status:=2;
     Magnitude:=MG;  {penumbral magnitude}
     FirstContact:=int(ADATE)+Z6/24.0;
     LastContact:=int(ADATE)+Z7/24.0;
     MaxeclipseUTime:=int(ADATE)+Z1;
     Adate:=Int(Savedatetime);
     Localtime:=Frac(SaveDateTime);
     TZHours:=SaveTZ;
     DLSHours:=SaveDLS;
     EXIT;
   END;
   ZD:=SQRT(DD);
   Z8:=Z1-ZD; {time of umbral start}
   Z9:=Z1+ZD-Floor((Z1+ZD)/24.0)*24.0; {end of umbral phase}
   {IF Z8<0 THEN Z8:=Z8+24.0;}
   R:=RU-RM;
   DD:=Z1-X0;
   DD:=DD*DD-((Z2-(R*R))*DD/ZH) ;
   MG:= (RM+RU-PJ)/(2.0*RM); {penumbral magnitude}
   IF DD<0 THEN
   with eclipserec, Moonadd do
   BEGIN
     {Status:=1; } {no total phase of lunar eclipse}
     Magnitude:=MG;  {umbral magnitude}
     FirstContact:=Int(ADATE)+Z6/24.0;
     LastContact:=int(ADATE)+Z7/24.0;
     MaxeclipseUTime:=int(ADATE)+Z1/24.0;
     UmbralStartTime:=int(ADATE)+Z8/24.0;
     UmbralEndTime:=int(ADATE)+Z9/24.0;
     Adate:=Int(Savedatetime);
     Localtime:=Frac(SaveDateTime);
     TZHours:=SaveTZ;
     DLSHours:=SaveDLS;
     EXIT;
   END;
   ZD:=SQRT(DD);
   ZC:=Z1-ZD; {ZC=start of total phase}
   ZB:=Z1+ZD-Floor((Z1+ZD)/24.0)*24.0; {ZB=end of total phase}
   {IF ZC<0 THEN ZC:=ZC+24.0;}
   with Eclipserec, MoonAdd do
   begin
     Magnitude:=MG;  {umbral magnitude}
     FirstContact:=int(ADATE)+Z6/24.0;
     LastContact:=int(ADATE)+Z7/24.0;
     MaxeclipseUTime:=int(ADATE)+Z1/24.0;
     UmbralStartTime:=int(ADATE)+Z8/24.0;
     UmbralEndTime:=int(ADATE)+Z9/24.0;
     TotalStartTime:=int(ADATE)+ZC/24.0;
     TotalEndTime:=int(ADATE)+ZB/24.0;
  end;
  TZHours:=SaveTZ;
  DLSHours:=SaveDLS;
  Adate:=Int(Savedatetime);
  Localtime:=Frac(SaveDateTime);

 END;

type
   TPlanetrecIn=record
    Name:string;
    X:array [1..23] of extended;
  end;

var
  PlanetInRec:array[MERCURY..PLUTO] of TPlanetRecIn=
  (
   (NAME:('MERCURY');
      X:(178.179078,415.2057519,3.011E-4,0,
         75.899697,1.5554889,2.947E-4,0,
         2.0561421E-1,2.046E-5,-3E-8,0,
         7.002881,1.8608E-3,-1.83E-5,0,
        47.145944,1.1852083,1.739E-4,0,
        3.870986E-1,6.74,-0.42)),
   (NAME:'VENUS';
     X:(342.767053,162.5533664,3.097E-4,0,
        130.163833,1.4080361,-9.764E-4,0,
          6.82069E-3,-4.774E-5 ,9.1E-8,0,
          3.393631,1.0058E-3,-1E-6,0,
         75.779647,8.9985E-1,4.1E-4,0,
          7.233316E-1,16.92,-4.4)),

   (NAME:'MARS';
     X:( 293.737334,53.17137642,3.107E-4,0,
           3.34218203E2,1.8407584,1.299E-4,-1.19E-6,
           9.33129E-2,9.2064E-5,-7.7E-8,0,
           1.850333,-6.75E-4,1.26E-5,0,
          48.786442,7.709917E-1,1.4E-6,-5.33E-6,
           1.5236883,9.36,-1.52)),
 (NAME:'JUPITER';
     X:(238.049257,8.434172183,3.347E-4,-1.65E-6,
          1.2720972E1,1.6099617,1.05627E-3,-3.43E-6,
          4.833475E-2,1.6418E-4,-4.676E-7,-1.7E-9,
          1.308736,-5.6961E-3,3.9E-6 ,0,
         99.443414,1.01053,3.5222E-4,-8.51E-6,
          5.202561,196.74,-9.4)),
   (NAME:'SATURN';
     X:(266.564377,3.398638567,3.245E-4,-5.8E-6,
          9.1098214E1,1.9584158,8.2636E-4,4.61E-6,
          5.589232E-2,-3.455E-4,-7.28E-7,7.4E-10,
          2.492519,-3.9189E-3,-1.549E-5,4E-8,
        112.790414,8.731951E-1,-1.5218E-4,-5.31E-6,
          9.554747,165.6,-8.88)),
    (NAME:'URANUS';
     X:(244.19747,1.194065406,3.16E-4,-6E-7,
          1.71548692E2,1.4844328,2.372E-4,-6.1E-7,
          4.63444E-2,-2.658E-5,7.7E-8,0,
          7.72464E-1,6.253E-4,3.95E-5,0,
         73.477111,4.986678E-1,1.3117E-3,0,
         19.21814,65.8,-7.19)),

   (NAME:'NEPTUNE';
     X:(84.457994,6.107942056E-1,3.205E-4,-6E-7,
         4.6727364E1,1.4245744,3.9082E-4,-6.05E-7,
         8.99704E-3,6.33E-6,-2E-9,0,
         1.779242,-9.5436E-3,-9.1E-6,0,
       130.681389,1.098935,2.4987E-4,-4.718E-6,
        30.10957,62.2,-6.87)),
   (NAME:'PLUTO';
     X:({osculating 1984 Jan 21}95.3113544,3.980332167E-1,0,0,
                                224.017,0,0,0,
                                2.5515E-1,0,0,0,
                                17.1329,0,0,0,
                                110.191,0,0,0,
                                39.8151,8.2,-1.0))
    );

(*
   X:({Jun  20, 2001}   ?,?,0,0,
                        223.56978,0,0,0
                        .2449688,0,0,0,
                        17.16785,0,0,0,
                        110.25993,0,0,0,
                        39.248116,8.2,-1,9


                        1080.5  .0040084     17.46345

http://space.univ.kiev.ua/ephem/01a/pl0.html

Computer Ephemeris. Elements of osculating planetary orbits. Explanations.

Each row contains at 0h of Time Dynamical Terrestrial of specified date in
system of mean equator and ecliptic J2000.0 the ecliptic osculating elements
of heliocentric orbit:

  (i) inclination of orbital plane (degrees),
  (O) longitude of ascending node (degrees),
  (p) argument of perigelion (degrees),
  (a) semimajor axis (astronomical units),
  (n) mean motion (degrees per day),
  (e) eccentricity (dimensionless),
  (M) mean anomaly (degrees).

                        Elements of osculating planetary orbits 2001
                                        Pluto
  Date    JulDat      i         O        p        a         n          e          M
         2451000+
 Dec  22   900.5  17.16396 110.26367 223.68834 39.230665   .0040111   .2444427   16.68547
 Jan  11   920.5  17.16462 110.26262 223.66845 39.231068   .0040111   .2444781   16.77700
 Jan  31   940.5  17.16524 110.26169 223.64984 39.232338   .0040109   .2445298   16.86710
 Feb  20   960.5  17.16575 110.26105 223.63455 39.234821   .0040105   .2446020   16.95433
 Mar  12   980.5  17.16615 110.26072 223.62224 39.237669   .0040100   .2446778   17.03957
 Apr   1  1000.5  17.16649 110.26055 223.61162 39.240448   .0040096   .2447501   17.12389
 Apr  21  1020.5  17.16682 110.26043 223.60145 39.242833   .0040093   .2448138   17.20826
 May  11  1040.5  17.16715 110.26028 223.59126 39.245044   .0040089   .2448741   17.29276
 May  31  1060.5  17.16748 110.26017 223.58127 39.246871   .0040086   .2449263   17.37745
 Jun  20  1080.5  17.16785 110.25993 223.56978 39.248116   .0040084   .2449688   17.46345
 Jul  10  1100.5  17.16828 110.25956 223.55656 39.249071   .0040083   .2450077   17.55065
 Jul  30  1120.5  17.16877 110.25904 223.54183 39.250242   .0040081   .2450534   17.63849
 Aug  19  1140.5  17.16923 110.25859 223.52809 39.252271   .0040078   .2451154   17.72505
 Sep   8  1160.5  17.16965 110.25825 223.51527 39.254795   .0040074   .2451865   17.81064
 Sep  28  1180.5  17.17003 110.25802 223.50361 39.257877   .0040069   .2452675   17.89509
 Oct  18  1200.5  17.17037 110.25790 223.49316 39.261443   .0040064   .2453569   17.97841
 Nov   7  1220.5  17.17064 110.25795 223.48493 39.265772   .0040057   .2454590   18.05981
 Nov  27  1240.5  17.17082 110.25822 223.47880 39.270215   .0040051   .2455606   18.13990
 Dec  17  1260.5  17.17098 110.25856 223.47310 39.274406   .0040044   .2456564   18.21994
 Jan   6  1280.5  17.17115 110.25889 223.46703 39.278303   .0040038   .2457467   18.30041
 *)



function TAstronomy.PElment(planet:TPlanet; var Info:TPlanetRec):boolean;

   procedure Adjust360(var Val:extended);
   begin
     while val>360.0 do val:=val-360.0;
     while val<0 do val:=val+360.0;
   end;



var
  T,AA,B:extended;


begin
  result:=true;  {?}
 with PlanetInRec[planet], Info do
 begin
   T:=FJDate/36525.0+FUniversalTime/8.766E5;
   AsOf:=T;
   Info.Name:=PlanetInRec[planet].name;
   AA:=X[2]*T;
   B:=360.0*(FRAC(AA));
   MeanLon:=X[1]+B+(X[4]*T+X[3])*T*T;
   Adjust360(MeanLon);
   MeanLonMotion:=(X[2]*9.856263E-3)+(X[3]+X[4])/36525.0;
   LonOfPerihelion:=((X[8]*T+X[7])*t+X[6])*T+X[5];
   Eccentricity:=((X[12]*T+X[11])*t+X[10])*T+X[9];
   Inclination:=((X[16]*T+X[15])*t+X[14])*T+X[13];
   LonAscendingNode:=((X[20]*T+X[19])*t+X[18])*T+X[17];
   SemiMajorAxis:=X[21];
   AngularDiameter:=X[22]/3600;
   Magnitude:=X[23];
 END;
end;

Procedure TAstronomy.Planets(Planet:TPlanet; var RecOut:TPlanetLocRec);

   FUNCTION FNU(W:EXTENDED):EXTENDED;
   begin  {reduce to range 0 to 2Pi}
     result:=W-(Int(W/TP)*TP);
   end;
var
  Elements:array[mercury..pluto] of TPlanetrec;
  i,j,k:integer;
  P:TPlanet;
  QA,QB,QC,QD,QE,QF,QG:Extended;
  J1,J2,J3,J4,J5,J6,J7,J8,J9,JA,JB,JC:EXTENDED;
  U1,U2,U3,U4,U5,U6,U7,U8,U9,UA,UB,UC,UD,UE,UF,UG:EXTENDED;
  UI,UJ,UK,UL,UN,UO,UP,UQ,UR,UU,UV,UW,UX,UY,UZ:Extended;
  VA,VB,VC,VD,VE,VF,VG,VH,VI,VJ, VK:Extended;
  A,CA,SA:EXTENDED;
  MS,RD,RE,RH,AM,EC,AE,AT:Extended;
  PD,PS,PV,LP,OM,LG,LL,L1,L2,CO,INC,Y,SP,CI:EXTENDED;
  LO,hOLDLO,VO,HOLDVO,SO,HOLDSO,PO,HOLDPO:EXTENDED;
  LI,EP,BP:Extended;
  AP:array[Mercury..Pluto] of extended;
   Sunrec:TSunRec;
  T:extended;
  begin
    {get elements for all planets}
    for p:= mercury to pluto do Pelment(p, Elements[p]);
    LI:=0;
    T:=FJDate/36525.0+FUniversalTime/8.766E5; {Julian Century}
    SunPos(sunrec);
    with sunrec do
    begin
      MS:=Sunrec.SunMeanAnomaly;
      RE:=AUDistance{RR};
      LG:=DegToRad(TrueEclLon){SR}+PI;
    end;

    For k:= 1 to 2 do  {2nd pass to adjust for speed of light}
    with Elements[Planet] do
    begin
      for p:=Mercury to Pluto do
      with elements[p] do
      AP[P]:=DegToRad(Meanlon-LonOfPerihelion-LI*MeanLonMotion);

      QA:=0; QB:=0; QC:=0; QD:=0; QE:=0; QF:=0; QG:=0;
      case planet of
        Mercury: {GOSUB 4685}
        begin
          {Perturbations for Mercury}
          QA:=2.04E-3*COS(5*AP[Venus]-2*AP[Mercury]+2.1328E-1);
          QA:=QA+1.03E-3*COS(2*AP[Venus]-AP[Mercury]-2.8046);
          QA:=QA+9.1E-4*COS(2*AP[Jupiter]-AP[Mercury]-6.4582E-1);
          QA:=QA+7.8E-4*COS(5*AP[Venus]-3*AP[Mercury]+1.7692E-1);

          QB:=7.525E-6*COS(2*AP[Jupiter]-AP[Mercury]+9.25251E-1);
          QB:=QB+6.802E-6*Cos(5*AP[Venus]-3*AP[Mercury]-4.53642);
          QB:=QB+5.457E-6*Cos(2*AP[Venus]-2*AP[Mercury]-1.24246);
          QB:=QB+3.569E-6*Cos(5*AP[Venus]-AP[Mercury]-1.35699);
        end;
        Venus: {Gosub 4735}
          begin
            QC:=7.7E-4*SIN(4.1406+T*2.6227);
            QC:=DegToRad(QC);
            QE:=QC;

            QA:=3.13E-3*CoS(2*MS-2*AP[Venus]-2.587);
            QA:=QA+1.98E-3*CoS(3*MS-3*AP[Venus]+4.4768E-2);
            QA:=QA+1.36E-3*COS(MS-AP[Venus]-2.0788);
            QA:=QA+9.6E-4*COS(3*MS-2*AP[Venus]-2.3721);
            QA:=QA+8.2E-4*COS(AP[JUPITER]-AP[Venus]-3.6318);

            QB:=2.2501E-5*COS(2*MS-2*AP[Venus]-1.01592);
            QB:=QB+1.9045E-5*COS(3*MS-3*AP[Venus]+1.61577);
            QB:=QB+6.887E-6*COS(AP[JUPITER]-AP[Venus]-2.06106);
            QB:=QB+5.172E-6*COS(MS-AP[Venus]-5.08065e-1);
            QB:=QB+3.62E-6*COS(5*MS-4*AP[Venus]-1.81877);
            QB:=QB+3.283E-6*COS(4*MS-4*AP[Venus]+1.10851);
            QB:=QB+3.074E-6*COS(2*AP[Jupiter]-2*AP[Venus]-9.62846E-1);
          end;
        Mars:{Gosub 4810}
          begin
            A:=3*AP[Jupiter]-8*AP[MARS]+4*MS;
            SA:=SIN(A);
            CA:=COS(A);
            QC:=-(1.133E-2*SA+9.33E-3*CA);
            QC:=DegToRad(QC);
            QE:=QC;

            QA:=7.05E-3*COS(AP[Jupiter]-AP[MARS]-8.5448E-1);
            QA:=QA+6.07E-3*COS(2*AP[Jupiter]-AP[MARS]-3.2873);
            QA:=QA+4.45E-3*COS(2*AP[JUPITER]-2*AP[MARS]-3.3492);
            QA:=QA+3.88E-3*COS(MS-2*AP[MARS]+3.5771E-1);
            QA:=QA+2.38E-3*COS(MS-AP[MARS]+6.1256E-1);
            QA:=QA+2.04E-3*COS(2*MS-3*AP[MARS]+2.7688);
            QA:=QA+1.77E-3*COS(3*AP[MARS]-AP[Venus]-1.0053);
            QA:=QA+1.36E-3*COS(2*MS-4*AP[MARS]+2.6894);
            QA:=QA+1.04E-3*COS(AP[Jupiter]+3.0749E-1);

            QB:=5.3227E-5*COS(AP[Jupiter]-AP[MARS]+7.17864E-1);
            QB:=QB+5.0989E-5*COS(2*AP[Jupiter]-2*AP[MARS]-1.77997);
            QB:=QB+3.8278E-5*COS(2*AP[Jupiter]-AP[MARS]-1.71617);
            QB:=QB+1.5996E-5*COS(MS-AP[MARS]-9.69618E-1);
            QB:=QB+1.4764E-5*COS(2*MS-3*AP[MARS]+1.19768);
            QB:=QB+8.966E-6*COS(AP[Jupiter]-2*AP[MARS]+7.61225E-1);
            QB:=QB+7.914E-6*COS(3*AP[Jupiter]-2*AP[MARS]-2.43887);
            QB:=QB+7.004E-6*COS(2*AP[Jupiter]-3*AP[MARS]-1.79573);
            QB:=QB+6.62E-6*COS(MS-2*AP[MARS]+1.97575);
            QB:=QB+4.93E-6*COS(3*AP[Jupiter]-3*AP[MARS]-1.33069);
            QB:=QB+4.693E-6*COS(3*MS-5*AP[MARS]+3.32665);
            QB:=QB+4.571E-6*COS(2*MS-4*AP[MARS]+4.27086);
            QB:=QB+4.409E-6*COS(3*AP[Jupiter]-AP[MARS]-2.02158);
          end;
        Jupiter{4}, Saturn{5}, Uranus{6}, Neptune{7}: {Gosub 4945}
          begin
            J1:=T/5.0+0.1;
            J2:=FNU(4.14473+5.29691E1*T);
            J3:=FNU(4.641118+2.132991E1*T);
            J4:=FNU(4.250177+7.478172*T);
            J5:=5.0*J3-2.0*J2;
            J6:=2.0*J2-6.0*J3+3.0*J4;
            (*
            IF PLANE4965 IF IP<5 THEN ON I? GOTO 5190,5190,5190,4980

            4970 IF IP>4 THEN ON IP-4 GOTO 4980,5500,5500,5190
            *)
            IF (PLANET=SATURN) OR (PLANET=JUPITER) THEN
            BEGIN
              J7:=J3-J2;
              U1:=SIN(J3);
              U2:=COS(J3);
              U3:=SIN(2.0*J3);
              U4:=COS(2.0*J3);
              U5:=SIN(J5);
              U6:=COS(J5);
              U7:=SIN(2.0*J5);
              U8:=SIN(J6);
              U9:=SIN(J7);
              UA:=COS(J7);
              UB:=SIN(2.0*J7);
              UC:=COS(2.0*J7);
              UD:=SIN(3.0*J7);
              UE:=COS(3.0*J7);
              UF:=SIN(4.0*J7);
              UG:=COS(4.0*J7);
              VH:=COS(5.0*J7);
              IF PLANET=JUPITER THEN
              BEGIN
       {5020}   QC:=(3.31364E-1-(1.0281E-2+4.692E-3*J1)*J1)*U5;
                QC:=QC+(3.228E-3-(6.4436E-2-2.075E-3*J1)*J1)*U6;
                QC:=QC-(3.083E-3+(2.75E-4-4.89E-4*J1)*J1)*U7;
                QC:=QC+2.472E-3*U8+1.3619E-2*U9+1.8472E-2*UB;
                QC:=QC+6.717E-3*UD+2.775E-3*UF+6.417E-3*UB*U1;
                QC:=QC+(7.275E-3-1.253E-3*J1)*U9*U1+2.439E-3*UD*U1;
                QC:=QC-(3.5681E-2+1.208E-3*J1)*U9*U2-3.767E-3*UC*U1;
                QC:=QC-(3.3839E-2+1.125E-3-J1)*UA*U1*-4.261E-3*UB*U2;
                QC:=QC+(1.161E-3*J1-6.333E-3)*UA*U2+2.178E-3*U2;
                QC:=QC-6.675E-3*UC*U2-2.664E-3*UE*U2-2.572E-3*U9*U3;
                QC:=QC-3.567E-3*UB*U3+2.094E-3*UA*U4+3.342E-3-UC-U4;
                QC:=DEGTORAD(QC);

                QD:=(3606+(130-43*J1)*J1)*U5+(1289-580*J1)*U6;
                QD:=QD-6764*U9*U1-1110*UB*U1-224*UD*U1-204*U1;
                QD:=QD+(1284+116*J1)*UA*U1+188*UC*U1;
                QD:=QD+(1460+130*J1)*U9*U2+224*UB*U2-817*U2;
                QD:=QD+6074*U2*UA+992*UC*U2+508*UE*U2+230*UG*U2;
                QD:=QD+108*VH*U2-(956+73-J1)*U9*U3+448*UB*U3;
                QD:=QD+137*UD*U3+({'}108*J1-997)*UA*U3+480*UC*U3;
                QD:=QD+148*UE*U3+(99*J1-956)*U9*U4+490*UB*U4;
                QD:=QD+158*UD*U4+179*U4+(1024+75*J1)*UA*U4;
                QD:=QD-437*UC*U4-132*UE*U4;
                QD:=QD*1E-7;

                 {5130}
                VK:=(7.192E-3-3.147E-3*J1)*U5-4.344E-3*U1;
                VK:=VK+(J1*(1.97E-4*J1-6.75E-4)-2.0428E-2)*U6;
                VK:=VK+3.4036E-2*UA*U1+(7.269E-3+6.72E-4*J1)*U9*U1;
                VK:=VK+5.614E-3*UC*U1+2.964E-3*UE*U1+3.7761E-2*U9*U2;
                VK:=VK+6.158E-3*UB*U2-6.603E-3*UA*U2-5.356E-3*U9*U3;
                VK:=VK+2.722E-3*UB*U3+4.483E-3*UA*U3;
                VK:=VK-2.642E-3*UC*U3+4.403E-3*U9*U4;
                VK:=VK-2.536E-3*UB*U4+5.547E-3*UA*U4-2.689E-3*UC*U4;
                QE:=QC-(DegToRad(VK)/Eccentricity);

                QF:=205*UA-263*U6+693*UC+312*UE+147*UG+299*U9*U1;
                QF:=QF+181*UC*U1+204*UB*U2+111*UD*U2-337*UA*U2;
                QF:=QF-111*UC*U2;	QF:=QF*1E-6;
              END
              ELSE
              BEGIN
                      {  .... Saturn }
                UI:=SIN(3*J3);	UJ:=COS(3*J3);	UK:=SIN(4*J3);
                UL:=COS(4*J3);	VI:=COS(2*J5);	UN:=SIN(5*J7);
                J8:=J4-J3;	UO:=SIN(2*J8);	UP:=COS(2*J8);
                UQ:=SIN(3*J8);	UR:=COS(3*J8);

                QC:=7.581E-3*U7-7.986E-3*U8-1.48811E-1*U9;
                QC:=QC-(8.14181E-1-(1.815E-2-1.6714E-2*J1)*J1)*U5;
                QC:=QC-(1.0497E-2-(1.60906E-1-4.1E-3*J1)*J1)*U6;
                QC:=QC-1.5208E-2*UD-6.339E-3*UF-6.244E-3*U1;
                QC:=QC-1.65E-2*UB*U1-4.0786E-2*UB;
                QC:=QC+(8.931E-3+2.728E-3*J1)*U9*U1-5.775E-3*UD*U1;
                QC:=QC+(8.1344E-2+3.206E-3*J1)*UA*U1+1.5019E-2*UC*U1;
                QC:=QC+(8.5581E-2+2.494E-3*J1)*U9*U2+1.4394E-2*Uc*U2;
                QC:=QC+(2.5328E-2-3.117E-3*J1)*UA*U2+6.319E-3*UE*U2;
                QC:=QC+6.369E-3*U9*U3+9.156E-3*UB*U3+7.525E-3*UQ*U3;
                QC:=QC-5.236E-3*UA*U4-7.736E-3*UC*U4-7.528E-3*UR*U4;
                QC:=DegToRad(QC);
                {5280}
                QD:=(-7927+(2548+91*J1)*J1)*U5;
                QD:=QD+(13381+(1226-253*J1)*J1)*U6+(248-121*J1)*U7;
                QD:=QD-(305+91*J1)*VI+412*UB+12415*U1 {UL};
                QD:=QD+(390-617*J1)*U9*U1+(165-204*J1)*UB*U1;
                QD:=QD+26599*UA*U1-4687*UC*U1-1870*UE*U1-821*UG*U1 {UL};
                QD:=QD-377*VH*U1+497*UP*U1+(163-611*J1)*U2;
                QD:=QD-12696*U9*U2-4200*UB*U2-1503*UD*U2-619*UF*U2;
                QD:=QD-268*UN*U2-(282+1306*J1)*UA*U2;
                QD:=QD+(-86+230*J1)*UC*U2+461*UO*U2-350*U3;
                QD:=QD+(2211-286*J1)*U9*U3-2208*UB*U3-568*UD*U3;
                QD:=QD-346*UF*U3-(2780+222*J1)*UA*U3;
                QD:=QD+(2022+263*J1)*UC*U3+248*UE*U3+242*UQ*U3;
                QD:=QD+467*UR*U3-490*U4-(2842+279*J1)*U9*U4;
                QD:=QD+(128+226*J1)*UB*U4+224*UD*U4;
                QD:=QD+(-1594+282*J1)*UA*U4+(2162-207*J1)*UC*U4;
                QD:=QD+561*UE*U4+343*UG*U4+469*UQ*U4-242*UR*U4;
                QD:=QD-205*U9*UI+262*UD*UI+208*UA*UJ-271*UE*UJ;
                QD:=QD-382*UE*UK-376*UD*UL;
                QD:=QD*1E-7;

                VK:=(7.7108E-2+(7.186E-3-1.53E-3*J1)*J1)*U5;
                VK:=VK-7.075E-3*U9;
                VK:=VK+(4.580E-2-(1.4766E-2+5.36E-4*J1)*J1)*U6;
                VK:=VK-7.2586E-2*U2-7.5825E-2*U9*U1-2.4839E-2*UB*U1{UL};
                VK:=VK-8.631E-3*UD*U1-1.50383E-1*UA*U2;
                VK:=VK+2.6897E-2*UC*U2+1.0053E-2*UE*U2;
                VK:=VK-(1.3597E-2+1.719E-3*J1)*U9*U3+1.1981E-2*UB*U4;
                VK:=VK-(7.742E-3-1.517E-3*J1)*UA*U3;
                VK:=VK+(1.3586E-2-1.375E-3*J1)*UC*U3;
                VK:=VK-(1.3667E-2-1.239E-3*J1)*U9*U4;
                VK:=VK+(1.4861E-2+1.136E-3*J1)*UA*U4;
                VK:=VK-(1.3064E-2+1.628E-3*J1)*UC*U4;
                QE:=QC-(DegToRad(VK)/eccentricity);
                QF:=572*U5-1590*UB*U2+2933*U6-647*UD*U2;
                QF:=QF+33629*UA-344*UF*U2-3081*UC+2885*UA*U2;
                QF:=QF-1423*UE+(2172+102*J1)*UC*U2-671*UG;
                QF:=QF+296*UE*U2-320*VH-267*UB*U3+1098*U1;
                QF:=QF-778*UA*U3-2812*U9*U1+495*UC*U3+688*UB*U1;
                QF:=QF+250*UE*U3-393*UD*U1-856*U9*U4-228*UF*U1{UL};
                QF:=QF+441*UB*U4+2138*UA*U1+296*UC*U4-999*UC*U1;
                QF:=QF+211*UE*U4-642*UE*U1-427*U9*UI-325*UG*U1;
                QF:=QF+398*UD*UI-890*U2+344*UA*UJ+2206*U9*U2;
                QF:=QF-427*UE*UJ;	QF:=QF*1E-6;

                QG:=7.47E-4*UA*U1+1.069E-3*UA*U2+2.108E-3*UB*U3;
                QG:=QG+1.261E-3*UC*U3+1.236E-3*UB*U4-2.075E-3*UC*U4;
                QG:=DegToRad(QG);
              END;
            END
            ELSE
            BEGIN
               { 5500 REM	... .Uranus, and Neptune  }
              J8:=FNU(1.46205+3.81337*T);	J9:=2*J8-J4;
              VJ:=SIN(J9);  UU:=COS(J9);  UV:=SIN(2*J9);
              uw:=cos(2*J9);
              if planet=Uranus then
              begin
                {5525 REM	... .Uranus}
                JA:=J4-J2; JB:=J4-J3; JC:=J8-J4;
                QC:=(8.64319E-1-1.583E-3*J1)*VJ;
                QC:=QC+(8.2222E-2-6.833E-3*J1)*UU+3.6017E-2*UV;
                QC:=QC-3.019E-3*UW+8.122E-3*SIN(J6);
                QC:=DegToRad(QC);
                
                VK:=1.20303E-1*VJ+6.197E-3*UV;
                VK:=VK+(1.9472E-2-9.47E-4*J1)*UU;
                QE:=QC-(DegToRad(VK)/Eccentricity);
                QD:=(163*J1-3349)*VJ+20981*UU+1311*UW;
                QD:=QD*1E-7;
                QF:=-3.825E-3*UU;

                QA:=(-3.8581E-2+(2.031E-3-1.91E-3*J1)*J1)*COS(J4+JB);
                QA:=QA+(1.0122E-2-9.88E-4*J1)*SIN(J4+JB);
                A:=(3.4964E-2-(1.038E-3-8.68E-4*j1)*J1)*COS(2*J4+JB);
                QA:=A+QA+5.594E-3*SIN(J4+3*JC)-1.4808E-2*SIN(JA);
                QA:=QA-5.794E-3*SIN(JB)+2.347E-3*COS(JB);
                QA:=QA+9.872E-3*SIN(JC)+8.803E-3*SIN(2*JC);
                QA:=QA-4.308E-3*SIN(3*JC);
                UX:=SIN(JB); UY:=COS(JB); UZ:=SIN(J4);
                VA:=COS(J4);  VB:=SIN(2*J4); VC:=COS(2*J4);
                QG:=(4.58E-4*UX-6.42E-4*UY-5.17E-4*COS(4*JC))*UZ;
                QG:=QG-(3.47E-4*UX+8.53E-4*UY+5.17E-4*SIN(4*JB))*VA;
                QG:=QG+4.03E-4*(COS(2*JC)*VB+SIN(2*JC)*VC);
                QG:=DegToRad(QG);

                QB:=-25948+4985*COS(JA)-1230*VA+3354*UY;
                QB:=QB+904*COS(2*JC)+894*(COS(JC)-COS(3*JC));
                QB:=QB+(5795*VA-1165*UZ+1388*VC)*UX;
                QB:=QB+(1351*VA+5702*UZ+1388*VB)*UY;
                QB:=QB*1E-6;
              end
              else
              begin
                  {5670 REM	. ... Neptune}
                JA:=J8-J2; JB:=J8-J3; JC:=J8-J4;
                QC:=(1.089E-3*J1-5.89833E-1)*VJ;
                QC:=QC+(4.658E-3*J1-5.6094E-2)*UU-2.4286E-2*UV;
                QC:=DegToRad(QC);

                VK:=2.4039E-2*VJ-2.5303E-2*UU+6.206E-3*UV;

                VK:=VK-5.992E-3*UW;
                QE:=QC-(DegToRad(VK)/Eccentricity);

                QD:=4389*VJ+1129*UV+4262*UU+1089*UW;

                QD:=QD*1E-7;

                QF:=8189*UU-817*VJ+781*UW; QF:=QF*1E-6;
                VD:=SIN(2*JC); VE:=COS(2*JC);
                VF:=SIN(J8);  VG:=COS(J8);
                QA:=-9.556E-3*SIN(JA)-5.178E-3*SIN(JB);
                QA:=QA+2.572E-3*VD-2.972E-3*VE*VF-2.833E-3*VD*VG;

                QG:=3.36E-4*VE*VF+3.64E-4*VD*VG;
                QG:=DegToRad(QG);

                QB:=-40596+4992*COS(JA)+2744*COS(JB);
                QB:=QB+2044*COS(JC)+1051*VE;
                QB:=QB*1E-6;
              end;
            end;
          end;
        Pluto: {Gosub 5760}
          begin

             { 5760 REM	Pluto... }
            SHOWMESSAGE('Osculating elements for PLUTO accurate only near epoch');
          end; {pluto}
      end; {case}

     EC:=Eccentricity+QD;
     AM:=AP[Planet]+QE;
     Anomaly(EC,AM,AE,AT);
     {4565}
     PV:=(SemiMajorAxis+QF)*(1.0-EC*EC)/(1.0+EC*COS(AT));
     LP:=RadToDeg(AT)+LonOfPerihelion+RadToDeg(QC-QE);
     LP:=DegToRad(LP);
     OM:=DegToRad(LonAscendingNode);
     LO:=LP-OM;
     SO:=SIN(LO);
     CO:=COS(LO);
     INC:=DegToRad(Inclination);
     PV:=PV+QB;
     SP:=SO*SIN(INC);
     Y:=SO*COS(INC);
     PS:=ArcSin(SP)+QG;
     SP:=SIN(PS);
     PD:=ArcTan(Y/CO)+OM+DegtoRad(QA);
     IF CO<0 THEN PD:=PD+PI;
     IF PD>TP THEN PD:=PD-TP;
     CI:=COS(PS);
     RD:=PV*CI;
     LL:=PD-LG;
     RH:=RE*RE+PV*PV-2.0*RE*PV*CI*COS(LL);
     RH:=SQRT(RH);
     LI:=RH*5.775518E-3;
     IF K=1 THEN
     begin
       HOLDLO:=PD;
       HOLDVO:=RH;
       HOLDSO:=PS;
       HOLDPO:=PV;
     end;
   END; {DO k}
   {4640}
   L1:=Sin(LL);
   L2:=COS(LL);
   IF PLANET>=Mars
   THEN EP:=Arctan(RE*L1/(RD-RE*L2))+PD
   Else EP:=ArcTan(-1.0*RD*L1/(RE-RD*L2))+LG+PI;
   while EP<0 do EP:=EP+TP;
   while EP>TP do EP:=EP-TP;
   BP:=ArcTan(RD*SP*SIN(EP-PD)/(CI*RE*L1));
   WITH RecOut do
   Begin
     HelioCentricLonLat.X:=RadToDeg(HOLDLO);
     HelioCentricLonLat.Y:=RadToDeg(HOLDSO);
     RadiusVector:=HOLDPO; {P0}
     UncorrectedEarthDistance:=HOLDVO; {V0 (inAU)}
     GeoEclLonLat.X:=RadToDeg(EP);
     GeoEclLonLat.Y:=RadToDeg(BP);
     CorrectedEarthDistance:=RH; {RH (inAU)}
     NuTate;
     EP:=EP+DegToRad(NuLong);
     A:=LG+Pi-EP;
     EP:=EP-(9.9387E-5*Cos(A)/Cos(BP));
     BP:=BP-(9.9387E-5*Sin(A)*Sin(BP));
     gencom(EclRA,RPoint(RadToDeg(EP),RadToDeg(BP)),ApparentRADecl);
     ApparentRaDecl.x:=ApparentRaDecl.x/15.0;
     with elements[planet] do
     begin
       PlanetBasedata.AsOf:=Asof;
       PlanetBasedata.Name:=name;
       PlanetBasedata.MeanLon:=meanlon;
       PlanetBasedata.MeanLonMotion:=meanlonmotion;
       PlanetBasedata.LonOfPerihelion:=lonofperihelion;
       PlanetBasedata.Eccentricity:=eccentricity;
       PlanetBasedata.Inclination:=inclination;
       PlanetBasedata.LonAscendingNode:=LonascendingNode;
       PlanetBasedata.SemiMajorAxis:=semimajoraxis;
       PlanetBasedata.AngularDiameter:=angulardiameter;
       PlanetBasedata.Magnitude:=magnitude;

     end;
     {Move(Elements[Planet],PlanetBaseData, sizeof(TPlanetRec)); causes Access Violations!}
   end;
 end;

 function TAstronomy.ConvertCoord(Fromtype,ToType:TCoordType;
                                  Input:TRpoint):TRPoint;
 var
   temp1,temp2:TRPoint;
 begin
   if (fromtype=totype) or (fromtype=ctUnknown) or (ToType=ctUnknown)
   then
   begin
     result:=Input;
     result.coordtype:=FromType;
     exit;
   end;

   case fromtype of
     ctAzAlt:
       case Totype of
         ctEclLonLat:
           begin
             gencom(AzHa,Input,temp1);
             gencom(HaRa ,temp1,temp2);
             gencom(RaEcl,temp2,result);
           end;
         ctRADecl:
           begin
             gencom(AzHa,Input, temp1);
             gencom(HaRa,temp1, result);
           end;
         ctHADecl: GenCom(AzHa,Input,result);
         ctGalLonLat:
           begin
             gencom(AzHa,Input,temp1);
             gencom(HaRa ,temp1,temp2);
             gencom(RaGal,temp2,result);
           end;

       end; {case}

    ctEclLonLat:
      case Totype of
         ctAzAlt:
           begin
             gencom(EclRa,Input,temp1);
             gencom(RaHa ,temp1,temp2);
             gencom(HaAz,temp2,result);
           end;
         ctRADecl:  gencom(EclRa,Input,result);
         ctHADecl:
           begin
             gencom(EclRa,Input,temp1);
             gencom(RaHa ,temp1,result);
           end;
         ctGalLonLat:
           begin
             gencom(RaHa ,Input,temp1);
             gencom(RAGal,temp1,result);
           end;
        end;
    ctRaDecl:
      case Totype of
         ctAzAlt:
           begin
             gencom(RaHa,Input,temp1);
             gencom(HaAz,temp1,result);
           end;
         ctEclLonLat:gencom(RaECL,Input,result);
         ctHADecl: gencom(RaHa,Input,result);
         ctGalLonLat: gencom(RaGal,Input,result);
       end; {case}
    ctHADecl:
      case Totype of
         ctAzAlt:
           begin
             gencom(HaRa,Input,temp1);
             gencom(RaEcl ,temp1,result);
           end;
         ctEclLonLat:
           begin
             gencom(RaHa,Input,temp1);
             gencom(RaHa ,temp1,temp2);
             gencom(HaAz,temp2,result);
           end;
         ctRADecl: gencom(HaRa,Input,result);
         ctGalLonLat:
           begin
             gencom(HaRa,Input,temp1);
             gencom(RaGal ,temp1,result);
           end;
       end;
    ctGalLonLat:
      case Totype of
         ctAzAlt:
           begin
             gencom(GalRa,Input,temp1);
             gencom(RAHa,temp1,temp2);
             gencom(HaAz ,temp2,result);
           end;
         ctEclLonLat:
           begin
             gencom(GalRa,Input,temp1);
             gencom(RAEcl,temp1,result);
           end;
         ctRADecl:
           begin
             gencom(GalRa,Input,temp1);
             gencom(RAEcl,temp1,result);
           end;
         ctHADecl:
           begin
             gencom(GalRa,Input,temp1);
             gencom(RAHa,temp1,result);
           end;
       end;
     end;
     result.coordtype:=ToType;
   end;


function TAstronomy.getprintdatetime(FromType,ToType:TDtType;
           DT:TDateTime; Includedate:boolean; var convertedDT:TDateTime):string;
{uses options to control format of date and time as requested}
var
  tempAstro:TAstronomy;
  T:TDatetime;
begin
  Tempastro:=TAstronomy.create; {make a temp component to hold converted times}

  with tempastro do
  begin
    assign(self);  {copy location info to temp astro}
    if includedate then adate:=int(DT); {Otherwise assume time only was passed
                                   and use Astro's date}
    case fromtype of
      ttlocal: localtime:=frac(DT);
      ttUT:    universaltime:=frac(DT);
      ttGST:   GSTime:=frac(DT);
      ttLST:   LSTime:=frac(DT);
    end;
    case Totype of
      ttlocal: T:=localtime;
      ttUT:    T:=universaltime;
      ttGST:   T:=GSTime;
      ttLST:   T:=LSTime;
    end;
    if includedate then
    begin
      result:=DateTimeToStr(Adate+T);
      convertedDT:=Adate+T;
    end
    else
    begin
      result:=TimeToStr(T);
      convertedDT:=T;
    end;
  end;

  tempastro.free;
end;

initialization
  astro:=TAstronomy.create;
finalization
  astro.free;

end.