unit LatLonDist;

interface

uses   Windows, Messages,  Classes, sysutils,  Controls, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,  Math , mathslib
  ;
  var
  NMIfactors:array[0..2] of extended = (1.51078, 1.852 ,1.0);

  function  EllipticalDistance(llat1, llon1, llat2, llon2:extended; units:integer):extended;

  Procedure VDirectLatLon(DGLAT1, DGLON1, DFAZ, S:EXTENDED; Units:integer;
            VAR DGLAT2, DGLON2, DBAZ:EXTENDED);
 // Procedure VDirectLatLon(DGLAT1, DGLON1, DFAZ, S:EXTENDED; Units:integer;
 //          VAR DGLAT2, DGLON2, DBAZ:EXTENDED{DOUBLE});

  function VInverseDistance(dlat1,dlon1,dlat2,dlon2:extended;
                Var AzimuthInit, AzimuthFinal: extended; units:integer):extended;
  function RhumbDistance(llat1,llon1,llat2,llon2:extended; units:integer;
             var Azimuth:extended):extended;
  Procedure RhumbLatLon(LAT1,LON1, Azimuth1, Dist:EXTENDED; Units:integer; VAR LAT2, LON2:EXTENDED);

  {Old names deprcated kept fot compatibility}
  function ApproxEllipticalDistance(llat1, llon1, llat2, llon2:extended; units:integer):extended;
  function ApproxRhumbDistance(llat1,llon1,llat2,llon2:extended; units:integer;
             var Azimuth:extended):extended;
  Procedure ApproxRhumbLatLon(LAT1,LON1, Azimuth1, Dist:EXTENDED; Units:integer; VAR LAT2, LON2:EXTENDED);
  function convertunits(fromindex, ToIndex:integer;fromvalue:extended):extended;

implementation
type
 TCharset=set of char;
var deg:char=chr(176); {'°'}
    minmark:char=chr(180);
    ERAD:extended = 6378.135; {Earth's radius in km at equator}
    FLATTENING:extended = 1.0/298.257223563; {Fractional reduction of radius to poles}
    unitslbl:array[0..2] of string=('Miles','Kilometers','Nautical miles');
    {delimiter used in lat/long input}
    degdelim,minsecdelim,delDextra:TCharset;


function convertunits(FromIndex,ToIndex:integer;fromValue:extended):extended;
begin
  result:=fromvalue*nmiFactors[toindex]/nmifactors[fromindex];
end;


{************* EllipticalDistance ************}
function EllipticalDistance(llat1, llon1, llat2, llon2:extended; units:integer):extended;
{"Units" values: 0 = miles, 1 = kilometers, 2 = nautical miles}
  var
    lat1,lat2,lon1,lon2:extended;
    F,G,L:extended;
    sinG,cosL,cosF,sinL,sinF,cosG:extended;
    S,C,W,R,H1,H2,D:extended;
  begin
   lat1 := DEg2RAd(llat1);
   lon1 := -DEg2RAd(llon1);
   lat2 := DEg2RAd(llat2);
   lon2 := -DEg2RAd(llon2);

   F := (lat1 + lat2) / 2.0;
   G := (lat1 - lat2) / 2.0;
   L := (lon1 - lon2) / 2.0;

   sing := sin(G);
   cosl := cos(L);
   cosf := cos(F);
   sinl := sin(L);
   sinf := sin(F);
   cosg := cos(G);

   S  := sing*sing*cosl*cosl + cosf*cosf*sinl*sinl;
   C  := cosg*cosg*cosl*cosl + sinf*sinf*sinl*sinl;
   W  := arctan2(sqrt(S),sqrt(C));
   R  := sqrt((S*C))/W;
   H1 := (3 * R - 1.0) / (2.0 * C);
   H2 := (3 * R + 1.0) / (2.0 * S);
   D  := 2 * W * ERAD;
   result:=(D * (1 + FLATTENING * H1 * sinf*sinf*cosg*cosg -
                 FLATTENING*H2*cosf*cosf*sing*sing))/1.609344;

   case units of
     1:result := result * 1.609344; {miles back to kilometers}
     2:result := result * 0.8689724; {miles to nautical miles}
   end;
end;

{*************** ApproxEllipticalDistance (deprecated)************}
function ApproxEllipticalDistance(llat1, llon1, llat2, llon2:extended; units:integer):extended;
 {"Units" values: 0 = miles, 1 = kilometers, 2 = nautical miles}
begin
   result:=EllipticalDistance(llat1, llon1, llat2, llon2,units);
end;



{*************** RhumbDistance **************}
function RhumbDistance(llat1,llon1,llat2,llon2:extended; units:integer;
             var Azimuth:extended):extended;
{"Units" values: 0 = miles, 1 = kilometers, 2 = nautical miles}
(*

Bearing

A rhumb line is a straight line on a Mercator projection, with an angle on the projection equal to the compass bearing.

Formula:  ?? = ln( tan(p/4 + f2/2) / tan(p/4 + f1/2) ) (‘projected’ latitude difference)
 ? = atan2(??, ??)
where f is latitude, ? is longitude, ?? is taking shortest route (<180°), R is the earth’s radius, ln is natural log
JavaScript:
(all angles
in radians)
var ?? = Math.log(Math.tan(Math.PI/4+f2/2)/Math.tan(Math.PI/4+f1/2));

// if dLon over 180° take shorter rhumb line across the anti-meridian:
if (Math.abs(??) > Math.PI) ?? = ??>0 ? -(2*Math.PI-??) : (2*Math.PI+??);

var brng = Math.atan2(??, ??).toDegrees();
*)

  var
    lat1,lat2,lon1,lon2,dist:extended;
    DLon, DLat, ProjDLat:extended;
    Q,R:extended;
  Begin
   (*
   case Units of  {convert distance to meters}
      0:{miles} dist:=dist*1609.344;
      1:{kilometers} dist:=dist*1000;
      2:{nautical miles} dist:=dist*1852;
   end;
   *)
   R:=ERad*1000;  {earth radiusin memter}
   lat1 := DEg2RAd(llat1);
   lon1 := DEg2RAd(llon1);
   lat2 := DEg2RAd(llat2);
   lon2 := DEg2RAd(llon2);
   DLat:=Lat2-Lat1;
   Dlon:=Lon2-Lon1;
   ProjDLat:=Ln(tan(Pi/4+Lat2/2)/tan(Pi/4+Lat1/2));
   If abs(ProjDlat)>1e-12 then Q:=DLat/ProjDLat else Q:=cos(Lat1);
   if abs( DLon)>Pi/2 then if DLon>0 then Dlon:=-(2*Pi-Dlon) else DLon:=Dlon+2*Pi;
   dist:=sqrt(sqr(Dlat)+sqr(q*DLon))*R;
   Azimuth:=(arctan2(DLon,ProjDLat))/Pi*180;      {in degrees}

   case units of {convert meters back to input units}
     0:{miles} result:=dist*0.00062137;
     1:{kilometers} result:=dist*0.001;
     2:{nautical miles} result:=dist*0.00053996;
   end;
end;


{*************** ApproxRhumbDistance(Deprected)  **************}
function ApproxRhumbDistance(llat1,llon1,llat2,llon2:extended; units:integer;
             var Azimuth:extended):extended;
{"Units" values: 0 = miles, 1 = kilometers, 2 = nautical miles}
begin
   result:=RhumbDistance(llat1,llon1, llat2, llon2, units, azimuth);
end;

{************** RhumbLatLon ***************}
Procedure RhumbLatLon(LAT1,LON1, Azimuth1, Dist:EXTENDED; Units:integer; VAR LAT2, LON2:EXTENDED);
{"Units" values: 0 = miles, 1 = kilometers, 2 = nautical miles}
 var
   sig, DLat, PDLat, q, DLon:extended;
 begin
    case Units of  {convert distance to meters}
      0:{miles} dist:=dist*1609.344;
      1:{kilometers} dist:=dist*1000;
      2:{nautical miles} dist:=dist*1852;
    end;
   lat1 := DEg2RAd(lat1);
   lon1 := DEg2RAd(lon1);
   azimuth1:=Deg2Rad(Azimuth1);
   sig:=Dist/(1000*ERad);
   DLat:=sig*cos(azimuth1);
   Lat2:=Lat1+DLat;
   PDLat:=ln( tan(Pi/4+Lat2/2)/tan(Pi/4+Lat1/2));
   if PDLat>1e-12 then Q:=DLat /PDLat else Q:=cos(lat1);
   DLon:=sig*sin(Azimuth1)/Q;
   Lon2:=Lon1+DLon;
   {Convert output radians back to degrees}
   Lat2:=rad2deg(Lat2);
   Lon2:=rad2deg(Lon2);
 end;

{*************** ApproxLatLon (Derecated) ***********}
Procedure ApproxRhumbLatLon(LAT1,LON1, Azimuth1, Dist:EXTENDED; Units:integer; VAR LAT2, LON2:EXTENDED);
{"Units" values: 0 = miles, 1 = kilometers, 2 = nautical miles}
begin
   RhumbLatLon(Lat1,Lon1,Azimuth1,Dist, Units, Lat2, Lon2);
end;


{************** VDirectLatLon ***************}
Procedure VDirectLatLon(DGLAT1, DGLON1, DFAZ, S:EXTENDED; Units:integer;
           VAR DGLAT2, DGLON2, DBAZ:EXTENDED{DOUBLE});
{
       SUBROUTINE DIRCT1(GLAT1,GLON1,GLAT2,GLON2,FAZ,BAZ,S)
C
C *** SOLUTION OF THE GEODETIC DIRECT PROBLEM AFTER T.VINCENTY
C *** MODIFIED RAINSFORD'S METHOD WITH HELMERT'S ELLIPTICAL TERMS
C *** EFFECTIVE IN ANY AZIMUTH AND AT ANY DISTANCE SHORT OF ANTIPODAL
C
C *** A IS THE SEMI-MAJOR AXIS OF THE REFERENCE ELLIPSOID
C *** F IS THE FLATTENING OF THE REFERENCE ELLIPSOID
C *** LATITUDES AND LONGITUDES IN RADIANS POSITIVE NORTH AND EAST
C *** AZIMUTHS IN RADIANS CLOCKWISE FROM NORTH
C *** GEODESIC DISTANCE S ASSUMED IN UNITS OF SEMI-MAJOR AXIS A
C
C *** PROGRAMMED FOR CDC-6600 BY LCDR L.PFEIFER NGS ROCKVILLE MD 20FEB75
C *** MODIFIED FOR SYSTEM 360 BY JOHN G GERGEN NGS ROCKVILLE MD 750608
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/CONST/PI,RAD
      COMMON/ELIPSOID/A,F
}

{NGIS Fortran version convert to Delphi by G Darby, 2016}
VAR
  A,B,C,D,E,F:DOUBLE;
  C2A,CF,CU,CY,CZ,R,SA,SF,SU,SY,TU,X,Y, EPS:DOUBLE;

  GLat1, GLon1, Faz, Glat2, GLon2, Baz:extended;
BEGIN
  EPS:=0.5E-13; //DATA EPS/0.5D-13;
  a:=6378137.0;  {earth major axis meters}
  b:=6356752.314; {minor axis}
  //b:=6378137.0;  {minor axis, SPHERICAL WORLD}
    {convert distance to meters}
  case Units of  {convert distance to meters}
    0:{miles} S:=S*1609.344;
    1:{kilometers} S:=S*1000;
    2:{nautical miles} S:=S*1852;
  end;
  GLat1:=Deg2Rad(DGLat1);
  GLon1:=Deg2Rad(DGlon1);
  Faz:=Deg2Rad(DFaz);
  f:=(a-b)/a; {flattening}
  R:=1-F; //R=1.-F
  TU:=R*SIN(GLAT1)/COS(GLAT1);   //TU=R*DSIN(GLAT1)/DCOS(GLAT1)
  SF:=SIN(FAZ);  //SF=DSIN(FAZ)
  CF:=COS(FAZ);    //CF=DCOS(FAZ)
  BAZ:=0.0;   //BAZ=0.
  //IF(CF.NE.0.) BAZ=DATAN2(TU,CF)*2.
  IF(CF<>0.0) THEN  BAZ:=ARCTAN2(TU,CF)*2.0;

  CU:=1.0/SQRT(TU*TU+1);  //CU=1./DSQRT(TU*TU+1.)
  SU:=TU*CU;  //SU=TU*CU
  SA:=CU*SF;  //SA=CU*SF
  C2A:=-SA*SA+1;   //C2A=-SA*SA+1.
  X:=SQRT((1/R/R-1)*C2A+1)+1;   //X=DSQRT((1./R/R-1.)*C2A+1.)+1.
  X:=(X-2)/X;   //X=(X-2.)/X
  C:=1-X;    //C=1.-X
  C:=(X*X/4+1)/C;  //C=(X*X/4.+1)/C
  D:=(0.375E0*X*X-1)*X;  //(0.375D0*X*X-1.)*X
  TU:=S/R/A/C;  //TU=S/R/A/C
  Y:=TU;  //Y=TU
  (*
  100 SY=DSIN(Y)
      CY=DCOS(Y)
      CZ=DCOS(BAZ+Y)
      E=CZ*CZ*2.-1.
      C=Y
      X=E*CY
      Y=E+E-1.
      Y=(((SY*SY*4.-3.)*Y*CZ*D/6.+X)*D/4.-CZ)*SY*D+TU
      IF(DABS(Y-C).GT.EPS)GO TO 100
   *)
   REPEAT
     SY:=SIN(Y);
     CY:=COS(Y);
     CZ:=COS(BAZ+Y);
     E:=CZ*CZ*2-1;
     C:=Y;
     X:=E*CY;
     Y:=E+E-1;
     Y:=(((SY*SY*4-3)*Y*CZ*D/6+X)*D/4-CZ)*SY*D+TU;
   UNTIL ABS(Y-C)<=EPS;

   BAZ:=CU*CY*CF-SU*SY;    //BAZ=CU*CY*CF-SU*SY
   C:=R*SQRT(SA*SA+BAZ*BAZ);  //C=R*DSQRT(SA*SA+BAZ*BAZ)
   D:=SU*CY+CU*SY*CF;   //D=SU*CY+CU*SY*CF
   GLAT2:=ARCTAN2(D,C);     //GLAT2=DATAN2(D,C)
   C:=CU*CY-SU*SY*CF;;      //C=CU*CY-SU*SY*CF
   X:=ARCTAN2(SY*SF,C);    //X=DATAN2(SY*SF,C)
   C:=((-3*C2A+4)*F+4)*C2A*F/16;  //C=((-3.*C2A+4.)*F+4.)*C2A*F/16.
   D:=((E*CY*C+CZ)*SY*C+Y)*SA;  //D=((E*CY*C+CZ)*SY*C+Y)*SA
   GLON2:=GLON1+X-(1-C)*D*F;   //GLON2=GLON1+X-(1.-C)*D*F
   BAZ:=ARCTAN2(SA,BAZ)+PI;   //BAZ=DATAN2(SA,BAZ)+PI <-- BAZ - Back AZ?
      //RETURN
   DGlat2:=rad2deg(GLat2);
   DGLon2:=rad2deg(GLon2);
   DBaz:=rad2deg(Baz);
  END;    //END

(*
Procedure VDirectLatLon(GLAT1, GLON1, FAZ, S:EXTENDED; Units:integer;
            VAR GLAT2, GLON2, BAZ:EXTENDED);

{"Units" values: 0 = miles, 1 = kilometers, 2 = nautical miles}
{
       SUBROUTINE DIRCT1(GLAT1,GLON1,GLAT2,GLON2,FAZ,BAZ,S)
C
C *** SOLUTION OF THE GEODETIC DIRECT PROBLEM AFTER T.VINCENTY
C *** MODIFIED RAINSFORD'S METHOD WITH HELMERT'S ELLIPTICAL TERMS
C *** EFFECTIVE IN ANY AZIMUTH AND AT ANY DISTANCE SHORT OF ANTIPODAL
C
C *** A IS THE SEMI-MAJOR AXIS OF THE REFERENCE ELLIPSOID
C *** F IS THE FLATTENING OF THE REFERENCE ELLIPSOID
C *** LATITUDES AND LONGITUDES IN RADIANS POSITIVE NORTH AND EAST
C *** AZIMUTHS IN RADIANS CLOCKWISE FROM NORTH
C *** GEODESIC DISTANCE S ASSUMED IN UNITS OF SEMI-MAJOR AXIS A
C
C *** PROGRAMMED FOR CDC-6600 BY LCDR L.PFEIFER NGS ROCKVILLE MD 20FEB75
C *** MODIFIED FOR SYSTEM 360 BY JOHN G GERGEN NGS ROCKVILLE MD 750608
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/CONST/PI,RAD
      COMMON/ELIPSOID/A,F
}

{NGIS Fortran version converted to Delphi by G Darby, 2016}
VAR
  A,B,C,D,E,F:DOUBLE;
  C2A,CF,CU,CY,CZ,R,SA,SF,SU,SY,TU,X,Y, EPS:DOUBLE;


BEGIN
  GLat1:=degtorad(GLat1);
  GLon1:=degtorad(GLon1);
  Faz:=degtorad(Faz);
  s:=convertUnits(units,1,S); {Convert distance to metric for calcs}
  EPS:=0.5E-13; //DATA EPS/0.5D-13;
  a:=6378137.0;  {earth major axis meters}
  b:=6356752.314; {minor axis}
  //b:=6378137.0;  {minor axis, SPHERICAL WORLD}
    {convert distance to meters}
  case Units of  {convert distance to meters}
    0:{miles} S:=S*1609.344;
    1:{kilometers} S:=S*1000;
    2:{nautical miles} S:=S*1852;
  end;
  f:=(a-b)/a; {flattening}
  R:=1-F; //R=1.-F
  TU:=R*SIN(GLAT1)/COS(GLAT1);   //TU=R*DSIN(GLAT1)/DCOS(GLAT1)
  SF:=SIN(FAZ);  //SF=DSIN(FAZ)
  CF:=COS(FAZ);    //CF=DCOS(FAZ)
  BAZ:=0.0;   //BAZ=0.
  //IF(CF.NE.0.) BAZ=DATAN2(TU,CF)*2.
  IF(CF<>0.0) THEN  BAZ:=ARCTAN2(TU,CF)*2.0;

  CU:=1.0/SQRT(TU*TU+1);  //CU=1./DSQRT(TU*TU+1.)
  SU:=TU*CU;  //SU=TU*CU
  SA:=CU*SF;  //SA=CU*SF
  C2A:=-SA*SA+1;   //C2A=-SA*SA+1.
  X:=SQRT((1/R/R-1)*C2A+1)+1;   //X=DSQRT((1./R/R-1.)*C2A+1.)+1.
  X:=(X-2)/X;   //X=(X-2.)/X
  C:=1-X;    //C=1.-X
  C:=(X*X/4+1)/C;  //C=(X*X/4.+1)/C
  D:=(0.375E0*X*X-1)*X;  //(0.375D0*X*X-1.)*X
  TU:=S/R/A/C;  //TU=S/R/A/C
  Y:=TU;  //Y=TU
  REPEAT
    SY:=SIN(Y);
    CY:=COS(Y);
    CZ:=COS(BAZ+Y);
    E:=CZ*CZ*2-1;
    C:=Y;
    X:=E*CY;
    Y:=E+E-1;
    Y:=(((SY*SY*4-3)*Y*CZ*D/6+X)*D/4-CZ)*SY*D+TU;
  UNTIL ABS(Y-C)<=EPS;

  BAZ:=CU*CY*CF-SU*SY;    //BAZ=CU*CY*CF-SU*SY
  C:=R*SQRT(SA*SA+BAZ*BAZ);  //C=R*DSQRT(SA*SA+BAZ*BAZ)
  D:=SU*CY+CU*SY*CF;   //D=SU*CY+CU*SY*CF
  GLAT2:=ARCTAN2(D,C);     //GLAT2=DATAN2(D,C)
  C:=CU*CY-SU*SY*CF;;      //C=CU*CY-SU*SY*CF
  X:=ARCTAN2(SY*SF,C);    //X=DATAN2(SY*SF,C)
  C:=((-3*C2A+4)*F+4)*C2A*F/16;  //C=((-3.*C2A+4.)*F+4.)*C2A*F/16.
  D:=((E*CY*C+CZ)*SY*C+Y)*SA;  //D=((E*CY*C+CZ)*SY*C+Y)*SA
  GLON2:=GLON1+X-(1-C)*D*F;   //GLON2=GLON1+X-(1.-C)*D*F
  BAZ:=ARCTAN2(SA,BAZ)+PI;   //BAZ=DATAN2(SA,BAZ)+PI <-- BAZ - Back AZ?
  {Convert output radians to degrees}
  GLat2:=rad2deg(GLat2);
  GLon2:=rad2deg(GLon2);
  Baz:=rad2Deg(Baz);
END;
*)

{***************** VinverseDistance ***************}
function VInverseDistance(dlat1,dlon1,dlat2,dlon2:extended;
         Var AzimuthInit, AzimuthFinal: extended; units:integer):extended;
{"Units" values: 0 = miles, 1 = kilometers, 2 = nautical miles}
var
  lat1,lat2,Lon1,lon2:extended;
  f,OldLambda,Lambda:extended;
  a,b,TanU1,U1,tanU2,U2, Usq:extended;
  count:integer;
  sigma,sinSigma,cosSigma,TanSigma:extended;
  cos2sigmam:extended;
  sinAlpha, cosalpha, cosSqAlpha,C:extended;
  AA,BB,L,L1,L2:extended;
  dsigma,dist,azimuthreverse:extended;
begin
  a:=6378137.0;
  b:=6356752.314;
  f:=(a-b)/a;
  lat1:=deg2rad(dlat1);
  lat2:=deg2rad(dlat2);
  lon1:=deg2rad(dlon1);
  lon2:=deg2rad(dlon2);
  //AzimuthInit:=deg2Rad(Azimuthinit);
  TanU1:=(1-f)*tan(Lat1);
  U1:=arctan(Tanu1);
  tanu2 :=(1-f)*Tan(lat2);
  U2:=arctan(TanU2);
  L:=lon2-lon1;
  Lambda:=L; {first approximation of distance}
  count:=0;
  repeat  {iterate}
    inc(count);
    sinSigma:=sqrt(sqr(cos(U2)*sin(Lambda))+sqr(cos(u1)*sin(u2)-cos(U2)*sin(U1)*cos(Lambda)));
    CosSigma:=sin(U1)*sin(u2)+cos(u1)*cos(u2)*cos(Lambda);
    sigma := ArcTan(sinSigma/cosSigma);
    SinAlpha:=cos(u1)*cos(u2)*sin(lambda)/sinSigma;

    cosalpha:=cos(arcsin(sinAlpha));
    cossqalpha:=sqr(cosAlpha);
    cosSqalpha:=1-sqr(sinalpha);
    if (Lat1=0) and (Lat2=0) then cos2Sigmam:=0
    else  cos2sigmam:=cosSigma-(2*sin(U1)*sin(u2)/cosSqalpha);
    C:=(f/16)*cosSqalpha*(4+f*(4-3*cosSqalpha));
    oldlambda:=lambda;
    Lambda:=L+(1-c)*f*sinalpha*(sigma+C*sinsigma*(cos2Sigmam+c*cosSigma*(2*sqr(Cos2Sigmam)-1)));
  until (abs(lambda-oldlambda)<10e-12) or (count>1000);
  if count>1000 then showmessage('No convergence')
  else
  begin
    uSq := cosSqAlpha *  (Sqr(a) - Sqr(b)) / Sqr(b);

    AA :=  1.0+(uSq/16384.0)*(4096.0+uSq*(-768.0+uSq*(320.0-175.0*uSq)));

    BB := (uSq/1024.0)*(256.0+uSq*(-128.0+uSq*(74.0-47.0*uSq)));

    dsigma := BB*sinSigma*(cos2sigmam+(BB/4.0)*(-1+cosSigma*(2*Sqr(cos2Sigmam)) -
              (BB/6)*cos2Sigmam*(-3+4*Sqr(sinSigma))*(-3+4*Sqr(cos2sigmam))));

    Dist:=b*AA*(sigma-dsigma);
    AzimuthInit:=ArcTan2(cos(u2)*Sin(lambda),cos(u1)*sin(u2)-sin(u1)*cos(u2)*Cos(lambda)); {initial azimuth}
    while AzimuthInit<0 do AzimuthInit:=AzimuthInit+2*Pi;
    AzimuthReverse := ArcTan2(cos(u1)*Sin(lambda),-sin(u1)*cos(u2)+cos(u1)*sin(u2)*Cos(lambda))-Pi; {reverse azimuth}
    Azimuthfinal:=AzimuthReverse-Pi;
    while azimuthfinal<0 do azimuthfinal:=azimuthfinal+2*pi;
    while AzimuthReverse<0 do AzimuthReverse:=AzimuthReverse+2*pi;
    {Convert meters back to user preferred distance units}
    case units of
      0:{miles} result:=dist*0.0006212;
      1:{kilometers} result:=dist*0.001;
      2:{nautical miles} result:=dist*0.0005398;
    end;
    AzimuthInit:=rad2Deg(AzimuthInit);
    AzimuthFinal:=rad2Deg(AzimuthFinal);
  end;
end;


end.

