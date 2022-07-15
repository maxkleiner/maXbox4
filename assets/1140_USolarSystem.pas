{: Solar system planetary elements and positions utility unit.<p>

   Based on document by Paul Schlyter (Stockholm, Sweden)<br>
   http://www.stjarnhimlen.se/comp/ppcomp.html<p>

   Coordinates system takes Z as "up", ie. normal to the ecliptic plane,
   "axis" around which the planets turn.<p>

   Eric Grange<br>
   http://glscene.org       - todo for maXbox -> setOrbitalElemens define
   demo: https://github.com/maxkleiner/maXbox4/blob/master/assets/Earth.zip
}
unit USolarSystem_mX4;

interface

//uses VectorGeometry;

type

   TOrbitalElements2 = record
      N : Double;    // longitude of the ascending node
      i : Double;    // inclination to the ecliptic (plane of the Earth's orbit)
      w : Double;    // argument of perihelion
      a : Double;    // semi-major axis, or mean distance from Sun
      e : Double;    // eccentricity (0=circle, 0-1=ellipse, 1=parabola)
      M : Double;    // mean anomaly (0 at perihelion; increases uniformly with time)
   end;

   TOrbitalElementsData2 = record
      NConst, NVar : Double;     // longitude of the ascending node
      iConst, iVar : Double;     // inclination to the ecliptic (plane of the Earth's orbit)
      wConst, wVar : Double;     // argument of perihelion
      aConst, aVar : Double;     // semi-major axis, or mean distance from Sun
      eConst, eVar : Double;     // eccentricity (0=circle, 0-1=ellipse, 1=parabola)
      MConst, MVar : Double;     // mean anomaly (0 at perihelion; increases uniformly with time)
   end;

var

   // geocentric sun elements (?)
   cSunOrbitalElements : TOrbitalElementsData; 
   cMoonOrbitalElements : TOrbitalElementsData;
   cMoonOrbitalElements2 : TOrbitalElementsData2;
   cMercuryOrbitalElements : TOrbitalElementsData;
    cVenusOrbitalElements : TOrbitalElementsData;
    cMarsOrbitalElements : TOrbitalElementsData;
    cJupiterOrbitalElements : TOrbitalElementsData;
    cSaturnOrbitalElements : TOrbitalElementsData;
    cNeptuneOrbitalElements : TOrbitalElementsData;
    
const
   cAUToKilometers2 = 149.6e6; // astronomical units to kilometers
   cEarthRadius2 = 6400; // earth radius in kilometers

{: Converts a TDateTime (GMT+0) into the julian day used for computations. }
function GMTDateTimeToJulianDay(const dt : TDateTime) : Double;
{: Compute orbital elements for given julian day. }
function ComputeOrbitalElements2(const oeData : TOrbitalElementsData2;
                                const d : Double) : TOrbitalElements2;

{: Compute the planet position for given julian day (in AU). }
function ComputePlanetPosition2(const orbitalElements : TOrbitalElements2): TAffineVector; //overload;
function ComputePlanetPosition12(const orbitalElementsData : TOrbitalElementsData;
                               const d : Double) : TAffineVector; //overload;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


procedure setOrbitalelements;
begin
  
      cSunOrbitalElements.NConst:= 0.0;        cSunOrbitalElements.NVar:=0.0;
      cSunOrbitalElements.iConst:=0.0;          cSunOrbitalElements.iVar:=0.0;
      cSunOrbitalElements.wConst := 282.9404;   cSunOrbitalElements.wVar := 4.70935E-5;
      cSunOrbitalElements.aConst := 1.000000;   cSunOrbitalElements.aVar := 0.0; // (AU)
      cSunOrbitalElements.eConst := 0.016709;   cSunOrbitalElements.eVar := -1.151E-9;
      cSunOrbitalElements.MConst := 356.0470;   cSunOrbitalElements.MVar := 0.9856002585  ;                            
 
   // geocentric moon elements
   //cMoonOrbitalElements : TOrbitalElementsData = (
      cMoonOrbitalElements.NConst := 125.1228;  cMoonOrbitalElements.NVar := -0.0529538083;
      cMoonOrbitalElements.iConst := 5.1454;    cMoonOrbitalElements.iVar := 0.0;
      cMoonOrbitalElements.wConst := 318.0634;  cMoonOrbitalElements.wVar := 0.1643573223;
      cMoonOrbitalElements.aConst := 60.2666;  cMoonOrbitalElements.aVar := 0.0; // (Earth radii)
      cMoonOrbitalElements.eConst := 0.054900;  cMoonOrbitalElements.eVar := 0.0;
      cMoonOrbitalElements.MConst := 115.3654;  cMoonOrbitalElements.MVar := 13.0649929509  ;
      
      cMoonOrbitalElements2.NConst := 125.1228;  cMoonOrbitalElements2.NVar := -0.0529538083;
      cMoonOrbitalElements2.iConst := 5.1454;    cMoonOrbitalElements2.iVar := 0.0;
      cMoonOrbitalElements2.wConst := 318.0634;  cMoonOrbitalElements2.wVar := 0.1643573223;
      cMoonOrbitalElements2.aConst := 60.2666; cMoonOrbitalElements2.aVar := 0.0; // (Earth radii)
      cMoonOrbitalElements2.eConst := 0.054900;  cMoonOrbitalElements2.eVar := 0.0;
      cMoonOrbitalElements2.MConst := 115.3654;  cMoonOrbitalElements2.MVar := 13.0649929509  ;
  (*
   // heliocentric mercury elements
   cMercuryOrbitalElements : TOrbitalElementsData = (
      NConst : 48.3313;    NVar : 3.24587E-5;
      iConst : 7.0047;     iVar : 5.00E-8;
      wConst : 29.1241;    wVar : 1.01444E-5;
      aConst : 0.387098;   aVar : 0.0; // (AU)
      eConst : 0.205635;   eVar : 5.59E-10;
      MConst : 168.6562;   MVar : 4.0923344368  );

   // heliocentric venus elements
   cVenusOrbitalElements : TOrbitalElementsData = (
      NConst : 76.6799;    NVar : 2.46590E-5;
      iConst : 3.3946;     iVar : 2.75E-8;
      wConst : 54.8910;    wVar : 1.38374E-5;
      aConst : 0.723330;   aVar : 0.0; // (AU)
      eConst : 0.006773;   eVar : -1.302E-9;
      MConst : 48.0052;    MVar : 1.6021302244  );

   // heliocentric mars elements
   cMarsOrbitalElements : TOrbitalElementsData = (
      NConst : 49.5574;    NVar : 2.11081E-5;
      iConst : 1.8497;     iVar : -1.78E-8;
      wConst : 286.5016;   wVar : 2.92961E-5;
      aConst : 1.523688;   aVar : 0.0; // (AU)
      eConst : 0.093405;   eVar : 2.516E-9;
      MConst : 18.6021;    MVar : 0.5240207766  );

   // heliocentric jupiter elements
   cJupiterOrbitalElements : TOrbitalElementsData = (
      NConst : 100.4542;   NVar : 2.76854E-5;
      iConst : 1.3030;     iVar : -1.557E-7;
      wConst : 273.8777;   wVar : 1.64505E-5;
      aConst : 5.20256;    aVar : 0.0; // (AU)
      eConst : 0.048498;   eVar : 4.469E-9;
      MConst : 19.8950;    MVar : 0.0830853001  );

   // heliocentric saturn elements
   cSaturnOrbitalElements : TOrbitalElementsData = (
      NConst : 113.6634;   NVar : 2.38980E-5;
      iConst : 2.4886;     iVar : -1.081E-7;
      wConst : 339.3939;   wVar : 2.97661E-5;
      aConst : 9.55475;    aVar : 0.0; // (AU)
      eConst : 0.055546;   eVar : -9.499E-9;
      MConst : 316.9670;   MVar : 0.0334442282  );

   // heliocentric uranus elements
   cUranusOrbitalElements : TOrbitalElementsData = (
      NConst : 74.0005;    NVar : 1.3978E-5;
      iConst : 0.7733;     iVar : 1.9E-8;
      wConst : 96.6612;    wVar : 3.0565E-5;
      aConst : 19.18171;   aVar : -1.55E-8; // (AU)
      eConst : 0.047318;   eVar : 7.45E-9;
      MConst : 142.5905;   MVar : 0.011725806  );

   // heliocentric neptune elements
   cNeptuneOrbitalElements : TOrbitalElementsData = (
      NConst : 131.7806;   NVar : 3.0173E-5;
      iConst : 1.7700;     iVar : -2.55E-7;
      wConst : 272.8461;   wVar : -6.027E-6;
      aConst : 30.05826;   aVar : 3.313E-8; // (AU)
      eConst : 0.008606;   eVar : 2.15E-9;
      MConst : 260.2471;   MVar : 0.005995147  );
      *)
 end;     


//uses SysUtils;

// GMTDateTimeToJulianDay
//
function GMTDateTimeToJulianDay(const dt : TDateTime) : Double;
begin
   Result:=dt-EncodeDate(2000, 1, 1);
end;

// ComputeOrbitalElements
//
function ComputeOrbitalElements2(const oeData : TOrbitalElementsData2;
                                     const d : Double) : TOrbitalElements2;
begin
   with Result, oeData do begin
      N:=NConst+NVar*d;
      i:=iConst+iVar*d;
      w:=wConst+wVar*d;
      a:=aConst+aVar*d;
      e:=eConst+eVar*d;
      M:=MConst+MVar*d;
   end;
end;

// ComputeSunPosition (prepared elements)
//
function ComputePlanetPosition2(const orbitalElements : TOrbitalElements2) : TAffineVector;
var
   eccentricAnomaly, eA0 : Double;
   sm, cm, se, ce, si, ci, cn, sn, cvw, svw : extended;
   xv, yv, v, r : Double;
   nn : Integer; // numerical instability bailout
begin
   with orbitalElements do begin
      // E = M + e*(180/pi) * sin(M) * ( 1.0 + e * cos(M) )
      SinCosE(M*cPIdiv180, sm, cm);
      //xv:= (M*cPIdiv180);
    
      eccentricAnomaly:=M+e*c180divPI*sm*(1.0+e*cm);

      nn:=0;
      repeat
         eA0:=eccentricAnomaly;
         // E1 = E0 - ( E0 - e*(180/pi) * sin(E0) - M ) / ( 1 - e * cos(E0) )
         SinCos(eA0*cPIdiv180, se, ce);
         eccentricAnomaly:=eA0-(eA0-e*c180divPI*se-M)/(1-e*ce);
         Inc(nn);
      until (nn>10) or (Abs(eccentricAnomaly-eA0)<1e-4);

      sincos(eccentricAnomaly*cPIdiv180, se, ce);
      xv:=a*(ce-e);
      yv:=a*(Sqrt(1.0-e*e)*se);

      v:=ArcTan2Gl(yv, xv)*c180divPI;          //or arctan2 from math
      r:=Sqrt(xv*xv+yv*yv);
      
      //FixAngle  or convert rad/grD

      sincos(i*cPIdiv180, si, ci);
      sincos(N*cPIdiv180, sn, cn);
      //glSinCos11((v+w)*cPIdiv180, svw, cvw);
      SinCos((v+w)*cPIdiv180, svw, cvw);
   end;

   // xh = r * ( cos(N) * cos(v+w) - sin(N) * sin(v+w) * cos(i) )
   Result[0]:=r*(cn*cvw-sn*svw*ci);
   // yh = r * ( sin(N) * cos(v+w) + cos(N) * sin(v+w) * cos(i) )
   Result[1]:=r*(sn*cvw+cn*svw*ci);
   // zh = r * ( sin(v+w) * sin(i) )
   Result[2]:=r*(svw*si);
end;

// ComputePlanetPosition (data)
//
function ComputePlanetPosition12(const orbitalElementsData : TOrbitalElementsData;
                               const d : Double) : TAffineVector;
var oe : TOrbitalElements;
begin
   oe:=ComputeOrbitalElements(orbitalElementsData, d);        
   Result:=ComputePlanetPosition(oe);
end;

function  ArcTan2math(Y, X : double): extended;
   external 'ArcTan2@dmath.dll stdcall';
   
   
var oeDatamoon : TOrbitalElementsData; 
     affvect: TAffineVector;
     oeDatamoon2 : TOrbitalElementsData2;  
     aout1, aout2: extended;


begin //@main

  writeln(flots(ArcTan2Gl(Pi, 12535.788)*c180divPI));  
  writeln(flots(ArcTan2(Pi, 12535.788)*c180divPI));  
    
  writeln(flots(glArcTan21(Pi, 12535.788)*c180divPI));   //single prec.
  writeln(flots(fArcTan2(Pi, 12535.788)*c180divPI)); 
  writeln(flots(ArcTan2math(Pi, 12535.788)*c180divPI));  
  writeln(flots(ESBArcTan(Pi, 12535.788)*c180divPI));   
  
  writeln(flots((ESBArcTan(RadToDegGL(Pi), RadToDegGL(12535.788))*c180divPI))); 
  //writeln(flots((ESBArcTan(Pi, 12535.788)*cPIdiv180)/2)); 
  //writeln(flots(DegToRadGL(ESBArcTan(Pi, 12535.788)*c180divPI))); 
  //RadToDegGL
  SinCos(cPIdiv180, aout1, aout2);
  
  setOrbitalelements();
  oeDatamoon:=  cMoonOrbitalElements;
   oeDatamoon2:=  cMoonOrbitalElements2;
  
   writeln('ComputeOrbitalElements(oeDataMoon: internal->');
  writeln(flots(ComputeOrbitalElements(oeDataMoon, c180divPI).N));
  writeln(flots(ComputeOrbitalElements(oeDataMoon, c180divPI).M));
  // Func ComputePlanetPosition( const orbitalElements : TOrbitalElements) : TAffineVector;');
  affvect:= ComputePlanetPosition(ComputeOrbitalElements(oeDataMoon, c180divPI))
   writeln(flots(affvect[0]));
   affvect:= ComputePlanetPosition1(oeDataMoon, c180divPI)
   writeln(flots(affvect[0]));
   writeln(flots(affvect[1]));
   writeln(flots(affvect[2]));
   
   writeln('ComputeOrbitalElements(oeDataMoon: script->');
  writeln(flots(ComputeOrbitalElements2(oeDataMoon2, c180divPI).N));
  writeln(flots(ComputeOrbitalElements2(oeDataMoon2, c180divPI).M));
  affvect:= ComputePlanetPosition2(ComputeOrbitalElements2(oeDataMoon2, c180divPI));
   writeln(flots(affvect[0]));
   affvect:= ComputePlanetPosition12(oeDataMoon, c180divPI)
   writeln(flots(affvect[0]));
   writeln(flots(affvect[1]));
   writeln(flots(affvect[2]));
end.
End.

demo: https://github.com/maxkleiner/maXbox4/blob/master/assets/Earth.zip

Ref:
(*----------------------------------------------------------------------------*)
Proc SIRegister_USolarSystem(CL: TPSPascalCompiler);
begin
 CL.AddTypeS('TOrbitalElements',record N:Double;i:Double;w:Double;a:Double;e:Double;M:Double; end;
  TOrbitalElementsData', 'record NConst : Double; NVar : Double; i'
   +Const : Double; iVar : Double; wConst : Double; wVar : Double; aConst : Do'
   +uble; aVar : Double; eConst : Double; eVar : Double; MConst : Double; MVar:Double; end');
 CL.AddConstantN('cAUToKilometers','Extended').setExtended( 149.6e6);
 CL.AddConstantN('cEarthRadius','LongInt').SetInt( 6400);
 Func GMTDateTimeToJulianDay( const dt : TDateTime) : Double');
 Func ComputeOrbitalElements(const oeData:TOrbitalElementsData;const d:Double): TOrbitalElements;
 Func ComputePlanetPosition( const orbitalElements : TOrbitalElements) : TAffineVector;');
 Func ComputePlanetPosition1(const orbitalElementsData:TOrbitalElementsData;const d:Double):TAffineVector;;
end;

 TVector3f = array[0..2] of single;
  CL.AddTypeS('TAffineVector', 'TVector3f');

Proc glSinCos( const Theta : Extended; var Sin, Cos : Extended);
 Proc glSinCos11( const Theta : Double; var Sin, Cos : Double);
 Proc glSinCos0( const Theta : Single; var Sin, Cos : Single);
 Proc glSinCos1( const theta, radius : Double; var Sin, Cos : Extended);
 Proc glSinCos2( const theta, radius : Double; var Sin, Cos : Double);
 Proc glSinCos3( const theta, radius : Single; var Sin, Cos : Single);
 Proc glPrepareSinCosCache(var s,c: array of Single; startAngle,stopAngle : Single)
 Func glArcCos( const X : Extended) : Extended;
 Func glArcCos1( const x : Single) : Single;
 Func glArcSin( const X : Extended) : Extended;
 Func glArcSin1( const X : Single) : Single;
 Func glArcTan21( const Y, X : Extended) : Extended;
 Func glArcTan21( const Y, X : Single) : Single;
 Func glFastArcTan2( y, x : Single) : Single
 Func glTan( const X : Extended) : Extended;
 Func glTan1( const X : Single) : Single;
 Func glCoTan( const X : Extended) : Extended;
 Func glCoTan1( const X : Single) : Single;
 Func glSinh( const x : Single) : Single;
 Func glSinh1( const x : Double) : Double;
 Func glCosh( const x : Single) : Single;
 Func glCosh1( const x : Double) : Double;

15/11/2019  11:41             8,325 GLBaseMeshSilhouette.dcu
15/11/2019  11:41            15,068 GLCadencer.dcu
15/11/2019  11:41            43,625 GLContext.dcu
15/11/2019  11:41            21,388 GLGraphics.dcu
15/11/2019  11:41            20,583 GLMesh.dcu
15/11/2019  11:41            36,843 GLMisc.dcu
15/11/2019  11:41            14,500 GLNavigator.dcu
15/11/2019  11:41            85,116 GLObjects.dcu
15/11/2019  11:41            78,897 GLParticleFX.dcu
15/11/2019  11:41            10,288 GLParticles.dcu
15/11/2019  11:41             3,190 GLPolyhedron.dcu
15/11/2019  11:41           191,938 GLScene.dcu
15/11/2019  11:41             9,885 GLShadowPlane.dcu
15/11/2019  11:41             8,686 GLState.dcu
15/11/2019  11:41             3,175 GLStrings.dcu
15/11/2019  11:41           152,068 GLTexture.dcu
15/11/2019  11:41             6,517 GLUtils.dcu
15/11/2019  11:41           173,466 GLVectorFileObjects.dcu
15/11/2019  11:41            13,015 BumpMapping.dcu
15/11/2019  11:41             6,990 CurvesAndSurfaces.dcu
15/11/2019  11:41            17,938 GeometryBB.dcu
15/11/2019  11:41            10,372 GeometryCoordinates.dcu
15/11/2019  11:41            13,065 GLCanvas.dcu
15/11/2019  11:41             8,033 GLTextureCombiners.dcu
15/11/2019  11:40             3,969 Keyboard.dcu
15/11/2019  11:41            26,706 Octree.dcu
15/11/2019  11:41           178,266 OpenGL1x.dcu
15/11/2019  11:41             5,276 PerlinNoise.dcu
15/11/2019  11:41             2,063 PictureRegisteredFormats.dcu
15/11/2019  11:41            11,586 Spline.dcu
15/11/2019  11:41            97,166 VectorGeometry.dcu
15/11/2019  11:41            17,291 XOpenGL.dcu
15/11/2019  11:41             4,884 FileMD3.dcu
15/11/2019  11:41             5,169 GLFileMD3.dcu
15/11/2019  11:41            15,795 GLFileVRML.dcu
15/11/2019  11:41             1,870 GLStarRecord.dcu
15/11/2019  11:41             8,838 Q3MD3.dcu
15/11/2019  11:41             6,744 TGA.dcu
15/11/2019  11:41            25,152 VRMLParser.dcu
15/11/2019  11:41            12,873 GLCrossPlatform.dcu
15/11/2019  11:41            18,610 GLWin32Context.dcu
15/11/2019  11:41            16,969 GLWin32Viewer.dcu
15/11/2019  11:39             1,795 Adler32.dcu
15/11/2019  11:40             6,074 AnalyzerPlugins.dcu
15/11/2019  11:39            11,646 BitmapConversion.dcu
15/11/2019  11:39             3,255 BitStream.dcu
15/11/2019  11:39             6,140 BMPLoader.dcu
15/11/2019  11:39             5,416 BufStream.dcu
15/11/2019  11:39            20,100 ColorMapper.dcu
15/11/2019  11:39             3,677 CRC32Stream.dcu
15/11/2019  11:39            18,560 Deflate.dcu
15/11/2019  11:39             6,573 DelphiStream.dcu
15/11/2019  11:39            10,694 DIBTools.dcu
15/11/2019  11:40            15,898 DynamicLists.dcu
15/11/2019  11:39             4,866 GIFLoader.dcu
15/11/2019  11:39             9,294 HIPSLoader.dcu
15/11/2019  11:39            12,251 Huffman.dcu
15/11/2019  11:39            12,395 ICOLoader.dcu
15/11/2019  11:39            12,767 IconList.dcu
15/11/2019  11:40             9,743 ImageDLLLoader.dcu
15/11/2019  11:39             6,689 JPEGLoader.dcu
15/11/2019  11:39            10,198 MemStream.dcu
15/11/2019  11:39             4,021 MemUtils.dcu
15/11/2019  11:39               675 Monitor.dcu
15/11/2019  11:39            13,408 PanelFrame.dcu
15/11/2019  11:39             8,706 PCXLoader.dcu
