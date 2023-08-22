
{**********************************************************************
 Package pl_GaiaGIS.pkg
 This unit is part of CodeTyphon Studio (http://www.pilotlogic.com/)
***********************************************************************}


unit GIS_SysUtils;

{$MODE Delphi}
{$DEFINE PUREPASCAL}

interface

Uses
    LCLIntf, LCLType, LMessages,
    Classes, Graphics, SysUtils,ExtCtrls,Dialogs,GR32, FileUtil,
    XGR32_Color, XGR32_Bmp32Func, math, GIS_Resource;

const
  TG_FILEVERSION3000 = $1003;  //from GaiaCAD 3.000
  TG_FILEVERSION1002 = $1002;  //from GaiaCAD 2.001
  TG_FILEVERSION1001 = $1001;  //from GaiaCAD 1.941
  TG_FILEVERSION405  = $0405;
  TG_FILEVERSION400  = $0400;
  TG_FILEVERSION300  = $0300;
  TG_FILEVERSION301  = $0301;

  TG_FILEVERSION = TG_FILEVERSION3000;
  TG_METADATA_VERSION = TG_FILEVERSION3000;

  LocalPI = 3.14159265358979323846;
  DoublePI = (LocalPi * 2.0);
  HalfPI = (LocalPI / 2.0);
  QuarterPi = (LocalPI / 4.0);
  
  // Maximum number of points in an object
  GMAXPOINTS = (1024 * 128);
  GMINALTITUDE=0.001;
  GMAXALTITUDE=10000000000.0;     //1000000;
  GMAXSCALEFACTOR = 1000.0;//3.0;
  GMINSCALEFACTOR = 0.00000003;    //0.00000003;

  Earth_RESOLUTION_Max=1500.0;
  Earth_RESOLUTION = (360 * 60 * 60 * Earth_RESOLUTION_Max);//(360 * 60 * 60 * 1500);
  
  GU_DEGREE = (Earth_RESOLUTION/360);
  GU_MINUTE = (GU_DEGREE/60);
  GU_MINUTE_THOUSANTH = (GU_DEGREE/60000);

  GU_NAUTICALMILE = GU_MINUTE;
  GU_KILOMETER = (GU_MINUTE / 1.852);
  GU_MILE = (GU_MINUTE / 1.15151515);
  GU_SECOND = (GU_DEGREE/3600);
  GU_THIRD = (GU_DEGREE/21600);
  GU_HUNDRETH = (GU_DEGREE/360000);
  GU_THOUSANTH = (GU_DEGREE/3600000);
  GU_METER = (GU_MINUTE / 1852.0);
  GU_CENTIMETER = (GU_MINUTE / 185200.0);
  GU_YARD = (GU_MILE / 1760);
  GU_FATHOM = (GU_YARD * 2);
  GU_FOOT = (GU_YARD / 3);
  GU_INCH = (GU_FOOT / 12);



  GU_Conversions: array[0..16] of Extended = (
    GU_DEGREE, GU_MINUTE, GU_NAUTICALMILE, GU_KILOMETER, GU_MILE,
    GU_SECOND, GU_THIRD, GU_HUNDRETH, GU_THOUSANTH,
    GU_METER, GU_CENTIMETER, GU_FATHOM, GU_YARD, GU_FOOT, GU_INCH, 1, 0);

  GU_HeightConversions: array[0..9] of Extended = (1,GU_NAUTICALMILE, GU_KILOMETER, GU_MILE,
                        GU_METER, GU_CENTIMETER, GU_FATHOM, GU_YARD, GU_FOOT, GU_INCH);



  // Nautcal miles * resolution
  EARTHRADIUS = (3437.747 * GU_NAUTICALMILE);

  GU_10_DEGREE = (10 * GU_DEGREE);
  GU_15_DEGREE = (15 * GU_DEGREE);
  GU_30_DEGREE = (30 * GU_DEGREE);
  GU_90_DEGREE = (90 * GU_DEGREE);
  GU_180_DEGREE = (180 * GU_DEGREE);
  GU_360_DEGREE = (360 * GU_DEGREE);


  GU_TORADIANS = (LocalPI / GU_180_DEGREE);
  DEG_TORADIANS = (LocalPI / 180.0);

  GU_FROMRADIANS = (GU_180_DEGREE / LocalPI);
  DEG_FROMRADIANS = (180.0 / LocalPI);

  EarthUnitStrings: array[0..16] of string[2] = ('D', 'MN', 'NM', 'KM', 'MI',
                                                 'S', 'T', 'H', 'T', 'M', 'CM',
                                                 'F', 'YD', 'FT', 'IN', 'GU', 'PI');

  HeightUnitStrings: array[0..9] of string[2] = ('GU','NM','KM','MI','M','CM','F','YD','FT','IN');


  GFOV_ANGLE = 1.0; // used to calculate altitude property
  GEPSILON = 1E-10; // used by floating point math routines
  GMaxDouble=10000000000000000000000000000000.0;

  Const FixText='../';

type
  TSpheroidData = record
    a: Double; // a = EquitorialRadius in EarthUnits
    f: Double;  // f = Flattening 
  end;

  TSpheroid = (Airy1830, Australian1965, Bessel1841,
               Clarke1866, Clarke1880, Everest1830, GRS1967, GRS1980,
               Helmert1906, Hough, International1920, Krassovsky1940,
               SouthAmerican1969, WGS60, WGS66, WGS72, WGS84);

const
  SpheroidData: array[0..16] of TSpheroidData = (
    (a: ((6377563.396 * GU_MINUTE) / 1852.0);  f: 1 / 299.3249646), {Airy 1830}
    (a: ((6378160.0   * GU_MINUTE) / 1852.0);  f: 1 / 298.25),      {Australian National 1965}
    (a: ((6377397.155 * GU_MINUTE) / 1852.0);  f: 1 / 299.1528128), {Bessel 1841}
    (a: ((6378206.4   * GU_MINUTE) / 1852.0);  f: 1 / 294.9786982), {Clarke 1866}
    (a: ((6378249.145 * GU_MINUTE) / 1852.0);  f: 1 / 293.465),     {Clarke 1880}
    (a: ((6377276.345 * GU_MINUTE) / 1852.0);  f: 1 / 300.8017),    {Everest 1830}
    (a: ((6378160.0   * GU_MINUTE) / 1852.0);  f: 1 / 298.247167427), {GRS 1967}
    (a: ((6378137.0   * GU_MINUTE) / 1852.0);  f: 1 / 298.257222101), {GRS 1980}
    (a: ((6378200.0   * GU_MINUTE) / 1852.0);  f: 1 / 298.3),       {Helmert 1906}
    (a: ((6378270.0   * GU_MINUTE) / 1852.0);  f: 1 / 297.0),      {Hough}
    (a: ((6378388.0   * GU_MINUTE) / 1852.0);  f: 1 / 297.0),      {International 1920}
    (a: ((6378245.0   * GU_MINUTE) / 1852.0);  f: 1 / 298.3),      {Krassovsky 1940}
    (a: ((6378160.0   * GU_MINUTE) / 1852.0);  f: 1 / 298.25),    {South American 1969}
    (a: ((6378165.0   * GU_MINUTE) / 1852.0);  f: 1 / 298.3),     {WGS-60}
    (a: ((6378145.0   * GU_MINUTE) / 1852.0);  f: 1 / 298.25),    {WGS-66}
    (a: ((6378135.0   * GU_MINUTE) / 1852.0);  f: 1 / 298.26),    {WGS-72}
    (a: ((6378137.0   * GU_MINUTE) / 1852.0);  f: 1 / 298.257223563) {WGS-84}
    );

type
  EEarthException = class(Exception);

  TEarthDegree = Extended;

  TPointDouble = record
    X, Y: Double;
  end;
  PTPointDouble = ^TPointDouble;

  TPointLL = record
    iLongX, iLatY, iHeightZ: Double;
  end;
  PTPointLL = ^TPointLL;

  TPointDD = record
    LongX, LatY, HeightZ: TEarthDegree;
  end;

  TPoint3D = record
    iWorldX, iWorldY, iWorldZ: Double;
  end;
  PTPoint3D = ^TPoint3D;

  TMER = record
    iLongX, iLatY: Double;
    iWidthX, iHeightY: Double;
  end;
  PTMER = ^TMER;

  TV3D = record
    X, Y, Z: Extended;
  end;

  TQuaternion = record
    X, Y, Z, W: Extended;
  end;

  TGRectFloat = packed record
    case Integer of
      0: (Left, Top, Right, Bottom: Double);
      1: (TopLeft, BottomRight: TPointDouble);
  end;


  TPointArray = array[0..GMAXPOINTS] of TPoint;
  PTPointArray = ^TPointArray;

  TPointDoubleArray = array[0..GMAXPOINTS] of TPointDouble;
  PTPointDoubleArray = ^TPointDoubleArray;

  TGMatrix = array[0..8] of Extended;
  TTriangleLL = array[0..2] of TPointLL;
  TTriangle = array[0..2] of TPoint;

  TEarthUnitTypes = (euDegree, euMinute, euNauticalMile, euKilometer, euMile,
                     euSecond, euThird, euHundreth, euThousanth, euMeter,
                     euCentiMeter, euFathom, euYard, euFoot,
                     euInch, euEarthUnit, euPixel);

  THeightUnitTypes = ( huEarthUnit,huNauticalMile, huKilometer, huMile,
                       huMeter, huCentiMeter, huFathom, huYard, huFoot,
                       huInch);

  TGISProgressMessage = (pmMessage, pmStart, pmEnd, pmPercent, pmError);


  TEarthPOZ = record
    eSF: Extended;
    CenterXY: TPointDouble;
    iRotX, iRotY, iRotZ: Double;
  end;

 
  TEarthBrushStyle = (gbsSolid, gbsClear, gbsHorizontal, gbsVertical, gbsFDiagonal,
    gbsBDiagonal, gbsCross, gbsDiagCross,
    gbsPattern1,  gbsPattern2,  gbsPattern3,  gbsPattern4,  gbsPattern5,  gbsPattern6,
    gbsPattern7,  gbsPattern8,  gbsPattern9,  gbsPattern10, gbsPattern11, gbsPattern12,
    gbsPattern13, gbsPattern14, gbsPattern15, gbsPattern16, gbsPattern17, gbsPattern18,
    gbsPattern19, gbsPattern20, gbsPattern21, gbsPattern22, gbsPattern23, gbsPattern24,
    gbsPattern25, gbsPattern26, gbsPattern27, gbsPattern28, gbsPattern29, gbsPattern30,
    gbsPattern31, gbsPattern32, gbsPattern33, gbsPattern34, gbsPattern35, gbsPattern36,
    gbsPattern37, gbsPattern38, gbsPattern39, gbsPattern40, gbsPattern41, gbsPattern42,
    gbsPattern43, gbsPattern44, gbsPattern45, gbsPattern46, gbsPattern47, gbsPattern48,
    gbsPattern49, gbsPattern50);

  
  TEarthObjectState = (osNew, osClosed, osHidden, osDiscardable,
                       osBackFace, osFace, osSelected, osValidMER, osRedraw, osDeleted,
                       osClipLeft, osClipTop, osClipRight, osClipBottom, osTiny, osVisible);
  TEarthObjectStateSet = set of TEarthObjectState;



  //---------------------------- TEarthRoot ------------------------------------
  //
TEarthRoot = class(TPersistent)
  protected
    FIsUpdating:boolean;
  public
    class function PrintableClassName : string; virtual;
    procedure RedrawObject; virtual;
    Procedure BeginUpdate;
    Procedure EndUpdate;
  end;
TEarthRootClass = class of TEarthRoot;

  
  TDynArrayRecord = record    // 9999
    Count : PtrInt;
    Itemsize : integer;
    RefCount : PtrInt;
  end;
  DynArray = ^TDynArrayRecord;
  PDynArray = ^DynArray;

 
  TPointStoreType = (ptLL, ptLLH);
  TPointStoreFlags = (psLongCount, ps16Bit, psCompressed, psHeight );
  TPointStoreFlagsSet = set of TPointStoreFlags;
  PTPointStore = ^TPointStore;

  TUnitsformat=(UF_DDMMSS,UF_DDMM,UF_DD,UF_DDMMSSTT);

TGroupsStore = class;
  //---------------------------- TPointStore -----------------------------------
  // object that manages an Array of TPoint records
TPointStore = class(TEarthRoot)
  protected
    FPoints : DynArray;
    FPoint3DArray : DynArray;
    function  Get3D(iIndex : integer) : TPoint3D;
    function  GetLL(iIndex : integer) : TPointLL;
    function  GetDD(iIndex : integer) : TPointDD;
    procedure PutDD(iIndex : integer; const pt : TPointDD);
    procedure PutLL(iIndex : integer; const pt : TPointLL);
    procedure SetCount(iNewCount : Integer);
    function  GetCount : integer;
    function  GetHeightFlag : Boolean;
    procedure SetHeightFlag( Value : Boolean );
  public
    Flags : TPointStoreFlagsSet;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function  ObjectInstanceSize : integer;
    procedure Insert(iIndex : Integer; ptLL : TPointLL);
    procedure Delete(iIndex : Integer);
    Procedure Clear;
    function  Add( ptLL : TPointLL ) : integer;
    function  PointStoreMER : TMER;
    function  Clone : TPointStore;
    procedure Move( iFrom, iTo : integer );
    function  PointInPolygon( iLong, iLat : Double ) : Boolean;
    function  PointOnPolyline( iLong, iLat, iTolerance : Double ) : Boolean;
    function  Centroid : TPointLL;
    procedure Translate( dx, dy, dz : Double );
    procedure Refresh;
    function  Point3DArray( CacheArray : Boolean ) : DynArray;
    property  AsDD[iIndex : Integer] : TPointDD read GetDD write PutDD;
    property  AsLL[iIndex : Integer] : TPointLL read GetLL write PutLL; default;
    property  As3D[iIndex : integer] : TPoint3D read Get3D;
  published
    property Count : Integer read GetCount write SetCount;
    property StoreHeight : Boolean read GetHeightFlag write SetHeightFlag;
  end;
TPointStoreClass = class of TPointStore;


  //---------------------------- TGroupsStore -----------------------------------
  //
TGroupsStore = class(TEarthRoot)
  private
    FGroups : DynArray;
    FStoreHeight : Boolean;
    function  GetGroup( iIndex : integer ) : TPointStore;
    function  GetCount : integer;
    procedure SetCount( iNewCount : integer );
    procedure SetGroup( iIndex : integer; Value : TPointStore );
    procedure SetStoreHeight(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Insert(iIndex : Integer; PointStore : TPointStore );
    procedure Delete(iIndex : Integer);
    procedure Add(PointStore : TPointStore);
    function  AddNew:TPointStore;
    Procedure Clear;
    procedure Move( iFrom, iTo : integer );
    function  Clone : TGroupsStore;
    function  Centroid : TPointLL;
    function  GroupStoreMER : TMER;
    property  Group[iIndex : integer] : TPointStore read GetGroup write SetGroup; default;
  published
    property Count : Integer read GetCount write SetCount;
    property StoreHeight : Boolean read FStoreHeight write SetStoreHeight;
  end;
TGroupsStoreClass = class of TGroupsStore;

//---------------------------- TTextureData ----------------------------------
//
TTextureData = class(TEarthRoot)
  private
    WorldPoints : TPointStore;
    TextureFilename : TFilename;
    fTextureStream : TBitmap32;
    fTransparentColor:TColor;
    function GetTextureWidth : integer;
    function GetTextureHeight: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromStream(aStream : TStream);
    procedure LoadFromFile(const sFilename : TFilename);
    procedure MapPoint( iLong, iLat, TexX, TexY : Double );
    Procedure Delete;
    function  IsTextureOK : Boolean;
    function  LLToTextureXY( ptLL : TPointLL ) : TPoint;
    function  TextureXYToLL( ptXY : TPoint ) : TPointLL;
    property  TextureStream : TBitmap32 read fTextureStream;
    property  TransparentColor:TColor read fTransparentColor write fTransparentColor;
    property  Width : integer read GetTextureWidth;
    property  Height : integer read GetTextureHeight;
 end;

// Dynamic Array management routines
//
function  DynArrayCreate(const iItemSize, iCount: integer): DynArray;
function  DynArrayClone(const aDynArray: DynArray): DynArray;
procedure DynArrayInsert(var aDynArray: DynArray; iIndex: integer);
procedure DynArrayDelete(var aDynArray: DynArray; iIndex: integer);
procedure DynArrayMove(var aDynArray: DynArray; iFrom, iTo: integer);
procedure DynArrayFree(var aDynArray: DynArray);
procedure DynArraySetLength(var aDynArray: DynArray; iCount: integer);
function  DynArrayPtr(const aDynArray: DynArray; iIndex: integer): Pointer;
function  DynArrayCount(const aDynArray: DynArray): integer;
function  DynArrayAsObject(const aDynArray: DynArray; iIndex: integer): TObject;
function  DynArrayAsInteger(const aDynArray: DynArray; iIndex: integer): integer;
function  DynArrayIndexOfObject(const aDynArray: DynArray; Obj: TObject): integer;
function  DynArraySetAsObject(const aDynArray: DynArray; iIndex: integer; Obj: TObject): TObject;
function  DynArraySetAsInteger(const aDynArray: DynArray; iIndex: integer; Value: integer): integer;
procedure DynArrayIncReference(const aDynArray: DynArray);
procedure DynArrayDecReference(const aDynArray: DynArray);

// Point functions
//
Function PointDouble(const X,Y:integer):TPointDouble;  overload;
Function PointDouble(const X,Y:Double):TPointDouble;  overload;
Function PointDouble(const p:TPoint):TPointDouble; overload;

Function PointD(const p:TPointDouble):TPoint;  overload;
Function PointD(const X,Y:Double):TPoint; overload;


Function RectD(const aLeft,aTop,aRight,aBottom:Double):TRect;
Function GRectFloat(const aLeft,aTop,aRight,aBottom:Double):TGRectFloat;

function PointLLInit: TPointLL;
function PointLL(const iLongX, iLatY: integer): TPointLL; overload;
function PointLL(const iLongX, iLatY: Double): TPointLL; overload;
function PointLL2(const iLongX, iLatY, iHeight: integer): TPointLL;
function PointLLGetLong(const ptLL: TPointLL): Double;
function PointLLGetLat(const ptLL: TPointLL): Double;
function PointLLGetHeight(const ptLL: TPointLL): Double;

function PointLLAsText(const iLong, iLat: Double): string;
function PointLLAsText2(const ptLL:TPointLL): string;
function PointLLAsTextU(const iLong, iLat: Double; aUnitsformat:TUnitsformat): string;
function PointLLAsTextU2(const ptLL:TPointLL; aUnitsformat:TUnitsformat): string;
function PointLLAsTextFm(const iLong, iLat: Double; sFmt:string): string;
function PointLLAsTextFm2(const ptLL:TPointLL; sFmt:string): string;


function PointLLH(iLongX, iLatY, iHeightZ: Double): TPointLL;
function PointDD(LongX, LatY: TEarthDegree): TPointDD;
function PointDDH(LongX, LatY, HeightZ: TEarthDegree): TPointDD;
function Point3D(Long, Lat, Height: Double): TPoint3D;
function MER(iLong, iLat, iWidth, iHeight: Double): TMER;

function sIFE(bCond: Boolean; const sLeft, sRight: string): string;
function StrToExtended(const Text: string): Extended;
function StrToExtendedDef(const Text: string; Default: Extended): Extended;

function PointOnLine(iLong, iLat, ax, ay, bx, by, iTolerance: Double): Boolean;
function PointLLinMER(const ptLL: TPointLL; const MER: TMER): Boolean;
function MERinMER(const innerMER, outerMER: TMER): Boolean;
function UnionMER(const MER1, MER2: TMER): TMER;
function IsEmptyMER(const aMER: TMER): Boolean;
function PointsToMER(ptLLArray: array of TPointLL): TMER;
function PointsToRect(ptArray: array of TPoint): TRect; overload;
function PointsDoubleToRect(ptArray: array of TPointDouble): TRect;overload;

// Earth units Functions
//
function EarthUnitsToStr(Const aValue: Double; const sFmt: string): string;
function StrToEarthUnits(Const aText: string; const sFmt: string): Double;
function LLAsString(iLong, iLat: Double): string;
function LLAsString2(ptLL:TPointLL): string;
function DecimalToEarthUnits(const Value: Extended): Extended;
function DecimalToPointLL(const Longitude, Latitude: Extended): TPointLL;
function EarthUnitsToDecimal(iValue: Extended): Extended;
function EarthUnitsTo(iValue: Extended; Units: TEarthUnitTypes): Extended;
function EarthUnitsFrom(const eValue: Extended; Units: TEarthUnitTypes): Double;
function UnitsToStr(Units: TEarthUnitTypes): string;
function StrToUnits(const sUnits: string): TEarthUnitTypes;
Function GetUnitsformatForLong(const Unitsformat:TUnitsformat):string;
Function GetUnitsformatForLat(const Unitsformat:TUnitsformat):string;
Function GetUnitsformatMaskForLong(const Unitsformat:TUnitsformat):string ;
Function GetUnitsformatMaskForLat(const Unitsformat:TUnitsformat):string;

// Height units functions
//
function HeightUnitsTo(iValue: Double; Units: THeightUnitTypes): Extended;
function HeightUnitsFrom(const eValue: Extended; Units: THeightUnitTypes): Double;
function StrToHUnits(const sUnits: string): THeightUnitTypes;
function HUnitsToStr(Units: THeightUnitTypes): string;

// Vector routines
//
function  PointLLToV3D(const ptLL: TPointLL): TV3D;
function  V3DtoPointLL(const vec: TV3D): TPointLL;
function  V3D(eX, eY, eZ: Extended): TV3D;
procedure V3DNormalize(var vec: TV3D);
function  V3DCross(const a, b: TV3D): TV3D;
function  V3DDot(const a, b: TV3D): Extended;
function  V3DAdd(const a, b: TV3D): TV3D;
function  V3DSub(const a, b: TV3D): TV3D;
function  V3DMul(const a, b: TV3D): TV3D;
function  V3DLerp(const lo, hi: TV3D; alpha: Extended): TV3D;
function  V3DMatrixMul(const mat: TGMatrix; const vec: TV3D): TV3D;
function  PointLLMatrixMul(const mat: TGMatrix; const ptLL: TPointLL): TPointLL;

// Quaternion routines
//
function  Quat(X, Y, Z, W: Extended): TQuaternion;
procedure QuatNormalize(var Quat: TQuaternion);
function  AxisAngleToQuat(const axis: TV3D; angle: Extended): TQuaternion;
function  EulerToQuat(iRotX, iRotY, iRotZ: Extended): TQuaternion;
function  QuatDot(const q1, q2: TQuaternion): Extended;
function  QuatMul(const q1, q2: TQuaternion): TQuaternion;
function  VectorsToQuat(const vec1, vec2: TV3D): TQuaternion;
function  QuatSlerp(const qLo, qHi: TQuaternion; alpha: Extended): TQuaternion;
procedure QuatToAxisAngle(const Quat: TQuaternion; var Axis: TV3D; var Angle: Extended);
procedure QuatToMatrix(const Quat: TQuaternion; var mat: TGMatrix);

// Matrix Routines
//
procedure TransposeMatrix(var FromMat, ToMat: TGMatrix);
procedure ScaleMatrix(var mat: TGMatrix; eSF: Extended);

// Geometry and General Routines
//

function  SphericalMod(X: Extended): Extended;
function  Sign(Value: Extended): Extended;
function  LimitFloat(const eValue, eMin, eMax: Extended): Extended;
//function  MinFloat(const eLeft, eRight: Extended): Extended;
//function  MaxFloat(const eLeft, eRight: Extended): Extended;
//function  MinVal(iLeft, iRight: integer): Integer; 
//function  MaxVal(iLeft, iRight: integer): Integer;
function  AngleToRadians(iAngle: Extended): Extended;
function  RadiansToAngle(eRad: Extended): Extended;
function  Cross180(iLong: Double): Boolean;
function  Mod180(Value: integer): Integer;
function  Mod180Float(Value: Extended): Extended;
Function  MulDivFloat(a,b,d:Extended):Extended;
function  LongDiff(iLong1, iLong2: Double): Double;

//....Bmp Procedures ..... 
//   
Procedure Bmp_AssignFromPersistent(Source:TPersistent;Bmp:TbitMap);
Function  Bmp_CreateFromPersistent(Source:TPersistent):TbitMap;


Function FixFilePath(Const Inpath,CheckPath:string):string;
Function UnFixFilePath(Const Inpath,CheckPath:string):string;
Procedure FillStringList(sl:TStringList;const aText:string);

var
  giFileVersion:Word=(TG_FILEVERSION);

implementation

Const
 ss_DDMMSSTT='%d°%m’%s’’%t’’’,%x';
 ss_DDMMSS='%d°%m’%s’’,%x';
 ss_DDMM='%d°%m’,%x';
 ss_DD='%d°,%x';

//..................................................
Function GetUnitsformatGen(Unitsformat:TUnitsformat):string ;
 begin
  result:=ss_DDMMSS;
   case Unitsformat of
    UF_DDMMSSTT:result:=ss_DDMMSSTT;
    UF_DDMMSS:result:=ss_DDMMSS;
    UF_DDMM:result:=ss_DDMM;
    UF_DD:result:=ss_DD;
   end;
 end;

Function GetUnitsformatForLong(const Unitsformat:TUnitsformat):string ;
 begin
   result:=GetUnitsformatGen(Unitsformat)+' %E';
 end;

Function GetUnitsformatForLat(const Unitsformat:TUnitsformat):string;
 begin
  result:=GetUnitsformatGen(Unitsformat)+' %N';
 end;

Function GetUnitsformatMaskForLong(const Unitsformat:TUnitsformat):string ;
 begin
 result:='';
 case Unitsformat of
    UF_DDMMSSTT:result:='!990\°00\’00\’’\0’’’\,00000\ >C';
    UF_DDMMSS:result:='!990\°00\’00\’’\,00000\ >C';
    UF_DDMM:result:='!990\°00\’\,00000\ >C';
    UF_DD:result:='!990\°\,0000000000\ >C';
   end;
 end;
Function GetUnitsformatMaskForLat(const Unitsformat:TUnitsformat):string;
 begin
 result:='';
 case Unitsformat of
    UF_DDMMSSTT:result:='!90\°00\’00\’’\0’’’\,00000\ >C';
    UF_DDMMSS:result:='!90\°00\’00\’’\,00000\ >C';
    UF_DDMM:result:='!90\°00\’\,00000\ >C';
    UF_DD:result:='!90\°\,0000000000\ >C';
   end;
 end; 

Function FindFmtType(aStr:String):TUnitsformat;
  begin
      Result:=UF_DD;
      if pos('M',Uppercase(aStr))>0 then Result:=UF_DDMM;
      if pos('S',Uppercase(aStr))>0 then Result:=UF_DDMMSS;
      if pos('T',Uppercase(aStr))>0 then Result:=UF_DDMMSSTT;
   end;


function StrToEarthUnits(Const aText: string; const sFmt: string): Double;
var
  iDeg, iMin, iMinTh, iSec, iThird, iUnits: Integer;
  idx, jdx, iHund: Integer;
  iFmtType:TUnitsformat;
  iXDec,XVal: Extended;
  iXDecSS:String;
  sValue: string;
  bSign: Boolean;
  L,P:integer;
begin
  sValue:=Trim(aText);
  Result:=0;
  iDeg := 0;
  iMin := 0;
  iMinTh := 0;
  iSec := 0;
  iThird := 0;
  iHund := 0;
  iUnits := 0;
  iXDec:=0;
  iXDecSS:='';
  bSign := True;

  idx := 1;
  jdx := 1;

 iFmtType:=FindFmtType(sFmt);

 P:=Pos(',',sValue);
 L:=Length(sValue);
 if l>0 then iXDecSS:='0'+System.copy(sValue,p,L);

 while (jdx <= Length(sValue)) and (idx <= Length(sFmt)) do
  begin
    if jdx > 1 then sValue := Copy(sValue, jdx, 255);
    jdx := 2;
    if sFmt[idx] = '%' then
     begin
      Inc(idx);
      case UpCase(sFmt[idx]) of
        'D': system.Val(sValue, iDeg, jdx);
        'M': system.Val(sValue, iMin, jdx);
        'I': system.Val(sValue, iMinTh, jdx);
        'S': system.Val(sValue, iSec, jdx);
        'T': system.Val(sValue, iThird, jdx);
        'U': system.Val(sValue, iUnits, jdx);
        'X': iXDecSS:=iXDecSS;
        'E': bSign := UpCase(sValue[1]) = 'E';
        'N': bSign := UpCase(sValue[1]) = 'N';
      else
        raise EConvertError.Create(rsStrToLLMsg);
      end;
    end
    else
      if sValue[1] <> sFmt[idx] then break;
      Inc(idx);
  end;

  if iXDecSS<>'' then
   begin
    L:=Length(iXDecSS);
    iXDecSS:=System.copy(iXDecSS,1,L-2);
    iXDec:=StrToFloat(iXDecSS);

     case iFmtType of
       UF_DDMMSSTT:result:=Trunc(iXDec*GU_THIRD);
       UF_DDMMSS  :result:=Trunc(iXDec*GU_SECOND);
       UF_DDMM    :result:=Trunc(iXDec*GU_MINUTE);
       UF_DD      :result:=Trunc(iXDec*GU_DEGREE);
     end;
   end;    

  Result:=Result+iDeg*GU_DEGREE+iMin*GU_MINUTE+iMinTh*GU_MINUTE_THOUSANTH+iSec*GU_SECOND+iThird*GU_THIRD+iUnits;
  
  if not bSign then Result := -Result;
end;


function EarthUnitsToStr(const aValue:Double; const sFmt: string): string;
var
  iDeg,iMin, iSec, iThird,iHund:integer;
  idx: Integer;
  bNegative, bSign: Boolean;
  iMinTh: integer;
  iFmtType:TUnitsformat;
  iXDec,iUnits: Extended;
  iXDecSS:String;
  iDNum:Integer; //number of didits
  iValue:Integer;
  idec:Extended;
begin
  iValue:=Round(aValue);
  idec:=aValue-iValue;

  bNegative := iValue < 0;
  iValue := Abs(iValue);
  idec:=Abs(idec);

  bSign := bNegative and (Pos('%N', Uppercase(sFmt)) = 0) and (Pos('%E', Uppercase(sFmt)) = 0);

  iFmtType:=FindFmtType(sFmt);
  iDNum:=5;        //Number of Digits

  iDeg := iValue div round(GU_DEGREE);
  Dec(iValue, iDeg * round(GU_DEGREE));
  iMin := iValue div round(GU_MINUTE);
  Dec(iValue, iMin * round(GU_MINUTE));
  iMinTh := iValue div round(GU_MINUTE_THOUSANTH);
  iSec := iValue div round(GU_SECOND);
  Dec(iValue, iSec * round(GU_SECOND));
  iThird := iValue div round(GU_THIRD);
  Dec(iValue, iThird * round(GU_THIRD));
  iUnits := iValue+idec;

  case iFmtType of
    UF_DDMMSSTT:iXDec:=(iUnits)/GU_THIRD;
    UF_DDMMSS:iXDec:=(iThird*GU_THIRD+iUnits)/GU_SECOND;
    UF_DDMM:iXDec:=(iSec*GU_SECOND+iThird*GU_THIRD+iUnits)/GU_MINUTE;
    UF_DD:begin
           iXDec:=(iMin*GU_MINUTE+iSec*GU_SECOND+iThird*GU_THIRD+iUnits)/GU_DEGREE;
           iDNum:=10;   //Number of Digits
          end;
   end;

  iXDecSS:=FloatToStrF(iXDec,ffNumber,8,iDNum);
  System.Delete(iXDecSS,1,2);
  
  Result := '';
  idx := 1;
  while idx <= Length(sFmt) do
  begin
    if sFmt[idx] = '%' then
    begin
      if bSign then Result := Result + '-';
      bSign := False;
      Inc(idx);
      case UpCase(sFmt[idx]) of
        'D':Result := Result + intToStr(iDeg);
        'M':Result := Result + Format('%2.2d', [iMin]);
        'I':Result := Result + Format('%3.3d', [iMinTh]);
        'S':Result := Result + Format('%2.2d', [iSec]);
        'T':Result := Result + Format('%2.1d', [iThird]);
        'U':Result := Result + Format('%2.2d', [iUnits]);
        'X':Result := Result + iXDecSS;
        'E':Result := Result + sIFE(bNegative, 'W', 'E');
        'N':Result := Result + sIFE(bNegative, 'S', 'N');
      else
        Result := Result + sFmt[idx];
      end;
    end
    else
      Result := Result + sFmt[idx];
    Inc(idx);
  end;
end;

function LLAsString(iLong, iLat: Double): string;
begin
  Result := EarthUnitsToStr(iLong, GetUnitsformatForLong(UF_DDMMSS) +' '+
            EarthUnitsToStr(iLat, GetUnitsformatForLat(UF_DDMMSS)));
end;

function LLAsString2(ptLL:TPointLL): string;
 begin
  Result:=LLAsString(ptLL.iLongX,ptLL.iLatY);
end;

function PointLLAsText(const iLong, iLat: Double): string;
begin
  Result:=LLAsString(iLong, iLat);
end;

function PointLLAsText2(const ptLL:TPointLL): string;
 begin
  Result:=LLAsString(ptLL.iLongX,ptLL.iLatY)
end;

function PointLLAsTextU(const iLong, iLat: Double; aUnitsformat:TUnitsformat): string;
begin
  Result := EarthUnitsToStr(iLong, GetUnitsformatForLong(aUnitsformat)) +' '+
            EarthUnitsToStr(iLat,  GetUnitsformatForLat(aUnitsformat));
end;

function PointLLAsTextU2(const ptLL:TPointLL; aUnitsformat:TUnitsformat): string;
begin
  Result := PointLLAsTextU(ptLL.iLongX,ptLL.iLatY,aUnitsformat);
end;

function PointLLAsTextFm(const iLong, iLat: Double; sFmt:string): string;
begin
  Result := EarthUnitsToStr(iLong, sFmt) +' '+
            EarthUnitsToStr(iLat,  sFmt);
end;
//............................
function PointLLAsTextFm2(const ptLL:TPointLL; sFmt:string): string;
begin
  Result := PointLLAsTextFm(ptLL.iLongX,ptLL.iLatY,sFmt);
end;

Function PointDouble(const X,Y:integer):TPointDouble;
 begin
   result.x:=X;
   result.y:=y;
 end;

Function PointDouble(const X,Y:Double):TPointDouble;
begin
   result.x:=X;
   result.y:=y;
 end;

Function PointDouble(const p:TPoint):TPointDouble;
 begin
   result.x:=p.X;
   result.y:=p.Y;
 end;

Function PointD(const p:TPointDouble):TPoint;
begin
   result.x:=Round(p.X);
   result.y:=Round(p.Y);
 end;

Function PointD(const X,Y:Double):TPoint;
begin
   result.x:=Round(X);
   result.y:=Round(Y);
 end;


Function RectD(const aLeft,aTop,aRight,aBottom:double):TRect;
  begin
   result.Left:=Round(aLeft);
   result.Top:=Round(atop);
   result.Right:=Round(aright);
   result.Bottom:=Round(abottom);
 end;

 Function GRectFloat(const aLeft,aTop,aRight,aBottom:Double):TGRectFloat;
 begin
   result.Left:=aLeft;
   result.Top:=atop;
   result.Right:=aright;
   result.Bottom:=abottom;
 end;
//...................BMP Procedures..............................
Function  Bmp_CreateFromPersistent(Source:TPersistent):TbitMap;
 var bmp:TbitMap;
 begin
    bmp:=TbitMap.Create;
    Bmp_AssignFromPersistent(Source,bmp);
    result:=Bmp;
 end;

Procedure Bmp_AssignFromPersistent(Source:TPersistent;Bmp:TbitMap);

procedure AssignFromTBitmap(Val:TBitmap);
 begin
 Bmp.Assign(Source);
end;

procedure AssignFromTGraphic(Val:TGraphic);
 begin
    Bmp.PixelFormat:=pf32bit;
    Bmp.Width :=Val.Width;
    Bmp.Height :=Val.Height;
    Bmp.Canvas.Draw(0,0,Val);
    Bmp.PixelFormat:=pf16bit;

end;

begin

if Source is TBitmap then
  begin
   AssignFromTBitmap(TBitmap(Source));
   exit;
  end;

if Source is Timage then
  begin
   if Timage(Source).Picture.Graphic<>nil then
    begin
      AssignFromTGraphic(Timage(Source).Picture.Graphic);
      exit;
     end;
  end;
if Source is TGraphic then
  begin
   AssignFromTGraphic(TGraphic(Source));
   exit;
  end;
if Source is Ticon then
  begin
   AssignFromTGraphic(Ticon(Source));
   exit;
  end;
{if Source is TJpegImage then
  begin
   AssignFromTGraphic(TJpegImage(Source));
   exit;
  end; }


end; 

{-------------------------------------------------------------------------------
  DirectoryExists
-------------------------------------------------------------------------------}
{**
  Test to see if a directory exists.

  @Param Name Directory name to check.
  @Return True if the Directory exists
}


function PointLL(const iLongX, iLatY: integer): TPointLL;
begin
  Result.iLongX := Mod180(iLongX);
  Result.iLatY := iLatY;
  Result.iHeightZ := 0;
end;

function PointLL(const iLongX, iLatY: Double): TPointLL;
 begin
  Result.iLongX := Mod180Float(iLongX);
  Result.iLatY := iLatY;
  Result.iHeightZ := 0;
end;
function PointLLInit: TPointLL;
begin
  Result:=PointLL(0,0);
end;

function PointLL2(const iLongX, iLatY, iHeight: integer): TPointLL;
  begin
  Result.iLongX := Mod180(iLongX);
  Result.iLatY := iLatY;
  Result.iHeightZ := iHeight;
end;

function PointLLGetLong(const ptLL: TPointLL): Double;
 begin
   result:=ptLL.iLongX;
 end;

function PointLLGetLat(const ptLL: TPointLL): Double;
  begin
   result:=ptLL.iLatY;
 end;

function PointLLGetHeight(const ptLL: TPointLL): Double;
  begin
   result:=ptLL.iHeightZ;
 end;
{------------------------------------------------------------------------------
  PointLLH
------------------------------------------------------------------------------}
{**
  Creates a TPointLL object including a Z value from the parameters.

  @Param iLongX Longitude in EarthUnits.
  @Param iLatY Latitude in EarthUnits.
  @Param iHeightZ Height from surface in EarthUnits.
  @Return PointLL object including height value.
}
function PointLLH(iLongX, iLatY, iHeightZ: Double): TPointLL;
begin
  Result.iLongX := Mod180Float(iLongX);
  Result.iLatY := iLatY;
  Result.iHeightZ := iHeightZ;
end;

{-------------------------------------------------------------------------------
  PointDD
-------------------------------------------------------------------------------}
{**
  Creates a point in decimal degrees from the parameters.

  @Param LongX Longitude in Decimal Degrees.
  @Param LatY Latitude in Decimal Degrees.
  @Return PointDD object
}
function PointDD(LongX, LatY: TEarthDegree): TPointDD;
begin
  Result.LongX := LongX;
  Result.LatY := LatY;
  Result.HeightZ := 0;
end;

{-------------------------------------------------------------------------------
  PointDDH
-------------------------------------------------------------------------------}
{**
  Creates a point in decimal degrees including a height from the parameters.

  @Param LongX Longitude in Decimal Degrees.
  @Param LatY Latitude in Decimal Degrees.
  @Param HeightZ Height from surface in Decimal Degrees.
  @Return PointDD object
}
function PointDDH(LongX, LatY, HeightZ: TEarthDegree): TPointDD;
begin
  Result.LongX := LongX;
  Result.LatY := LatY;
  Result.HeightZ := HeightZ;
end;

{------------------------------------------------------------------------------
  Point3D
------------------------------------------------------------------------------}
{**
  Creates a 3D point from the parameters.

  @Param Long Longitude in EarthUnits.
  @Param Lat Latitude in EarthUnits.
  @Param Height Height in EarthUnits.
  @Return 3D point represention of Longitude, Latitude and Height.
}
function Point3D(Long, Lat, Height: Double): TPoint3D;
var
  eTmp, eHeight, eSLong, eClong, eSLat, eCLat: Extended;
begin
  with Result do
  begin
    { Convert to World }
    SinCos(Long * GU_TORADIANS, eSLong, eClong);
    SinCos(Lat * GU_TORADIANS, eSLat, eCLat);
    eHeight := EARTHRADIUS + Height;
    eTmp := eHeight * eCLat;
    iWorldX := (eTmp * eSlong);
    iWorldZ := (eTmp * eCLong);
    iWorldY := (eHeight * eSLat);
  end;
end;

{------------------------------------------------------------------------------
  MER
------------------------------------------------------------------------------}
{**
  Creates a Minimum Enclosing Rectangle from the parameters.

  @Param iLong Starting Longitude in EarthUnits for the MER.
  @Param iLat Starting Latitude in EarthUnits for the MER.
  @Param iWidth Width of MER in EarthUnits.
  @Param iHeight Height of MER in EarthUnits.
  @Return MER Object.
}
function MER(iLong, iLat, iWidth, iHeight: Double): TMER;
begin
  with Result do
  begin
    iLongX := iLong;
    iLatY := iLat;
    iWidthX := iWidth;
    iHeightY := iHeight;
  end;
end;

{------------------------------------------------------------------------------
  sIFE
------------------------------------------------------------------------------}
{**
  @Param bCond Flag to control the return value
  @Param sLeft if bCond is True this is returned
  @Param sLeft if bCond is False this is returned
  @Return sLeft or sRight depending on the value of bCond
}
function sIFE(bCond: Boolean; const sLeft, sRight: string): string;
begin
  if bCond then
    Result := sLeft else
    Result := sRight;
end;

{------------------------------------------------------------------------------
 PointOnLine
------------------------------------------------------------------------------}
{**
  @Param iLong Longitude in EarthUnits of the point.
  @Param iLat Latitude in EarthUnits of the point.
  @Param ax Longitude in EarthUnits of the Start of the line.
  @Param ay Latitude in EarthUnits of the start of the line.
  @Param bx Longitude in EarthUnits of the end of the line.
  @Param by Latitude in EarthUnits of the end of the line.
  @Param iTolerance  How close in EarthUnits that the point mus be to the line to be considered on the line.
  @Return True is the Point is on the line within the specified Tollerance.
}
function PointOnLine(iLong, iLat, ax, ay, bx, by, iTolerance: Double): Boolean;
var
  u, s, A, B, C, D, L: Extended;
begin
  Result := False;

  A := bx - ax;
  B := by - ay;
  L := (A * A + B * B);
  C := ay;
  D := ax;

  if L = 0 then  Exit;

  u := ((C - iLat) * (C - by) - (D - iLong) * A) / L;
  if (u >= 0) and (u <= 1.0) then
  begin
    s := abs((C - iLat) * A - (D - iLong) * B) / L;
    Result := s * sqrt(L) < iTolerance;
  end;
end;

{------------------------------------------------------------------------------
 PointLLinMER
------------------------------------------------------------------------------}
{**
  @Param ptLL Point to test.
  @Param MER Minimum Enclosing Rectangle to test if it contains the point.
  @Return True if the point is in the MER.
}
function PointLLinMER(const ptLL: TPointLL; const MER: TMER): Boolean;
begin
  with MER do
  begin
    Result := (ptLL.iLatY > iLatY) and (ptLL.iLatY < iLatY + iHeightY);
    if Result then
    begin
      Result := (ptLL.iLongX > iLongX) and (ptLL.iLongX < iLongX + iWidthX);
      // check for crossing of 180 meridan
      if not Result and (iLongX + iWidthX > GU_180_DEGREE) then
        Result := (ptLL.iLongX + GU_360_DEGREE > iLongX) and (ptLL.iLongX + GU_360_DEGREE < iLongX + iWidthX);
    end;
  end;
end;

{------------------------------------------------------------------------------
 MERinMER
------------------------------------------------------------------------------}
{**
  @Param innerMER Minimum Enclosing Rectangle.
  @Param outerMER Minimum Enclosing Rectangle.
  @Return True if innerMER is inside of outerMER
}
function MERinMER(const innerMER, outerMER: TMER): Boolean;
begin
  with innerMER do
    Result := PointLLinMER(PointLL(iLongX, iLatY), outerMER)
      and PointLLinMER(PointLL(iLongX + iWidthX, iLatY + iHeightY), outerMER);
end;

{------------------------------------------------------------------------------
  IsEmptyMER
------------------------------------------------------------------------------}
{**
  @Param aMER Minimum Enclosing Rectangle.
  @Result True if the MER is empty
}
function IsEmptyMER(const aMER: TMER): Boolean;
begin
  Result := (aMER.iWidthX = 0) and (aMER.iHeightY = 0);
end;

{------------------------------------------------------------------------------
 UnionMER
------------------------------------------------------------------------------}
{**
  @Param MER1 Minimum Enclosing Rectangle.
  @Param MER2 Minimum Enclosing Rectangle.
  @Return Union of MER1 and MER2.
}
function UnionMER(const MER1, MER2: TMER): TMER;
var
  x1, x2, w1, w2: Double;
  x, w, xb, wb: Double;
begin
  // Check to see if either MER is empty
  if IsEmptyMER(MER1) then
    Result := MER2
  else
    if IsEmptyMER(MER2) then
      Result := MER1
    else
    begin
      with MER1 do
      begin
        if iLongx >= MER2.iLongX then
        begin
          x1 := iLongX;
          w1 := iWidthX;
          x2 := MER2.iLongX;
          w2 := MER2.iWidthX;
        end
        else
        begin
          x1 := MER2.iLongX;
          w1 := MER2.iWidthX;
          x2 := iLongX;
          w2 := iWidthX;
        end;
      end;
      if (x2 >= 0) or (x1 <= 0) then //x1 and x2 have the same sign
      begin
        x := x2;
        w := Max(x1 - x2 + w1, w2);
      end
      else
      begin
        // x1 >= 0 and x2 <= 0
        if x2 + w2 >= x1 + w1 then
        begin
          x := x2;
          w := w2
        end
        else
        begin
          if (x2 + GU_360_DEGREE - x1 <= w1 - w2) then
          begin
            x := x1;
            w := w1;
          end
          else
          begin //we have two candidates
            x := x1;
            w := x2 + GU_360_DEGREE - x1 + w2;
            if w < 0 then  w := GMaxDouble;
            xb := x2;
            wb := x1 - x2 + w1;
            if wb < 0 then wb := GMaxDouble;
            if wb < w then
            begin
              x := xb;
              w := wb;
            end;
            if w >= GU_360_DEGREE then
              w := GU_360_DEGREE;
          end;
        end;
      end;
      with Result do
      begin
        iLongX := x;
        iWidthX := w;
        iLatY := Min(MER1.iLatY, MER2.iLatY);
        iHeightY := Max(MER1.iLatY + MER1.iHeightY - iLatY, MER2.iLatY + MER2.iHeightY - iLatY);
      end;
    end;
end;

{------------------------------------------------------------------------------
  PointsToMER
------------------------------------------------------------------------------}
{**
  @Param Array of TPointLL objects.
  @Return MER of all the supplied points.
}
function PointsToMER(ptLLArray: array of TPointLL): TMER;
var
  idx: integer;
begin
  Assert(High(ptLLArray) >= 0, 'PointsToMER called with zero points');

  Result := MER(ptLLArray[0].iLongX, ptLLArray[0].iLatY, 0, 0);
  for idx := 1 to High(ptLLArray) do
    with ptLLArray[idx] do
    begin
      if iLongX < Result.iLongX then
      begin
        Result.iWidthX := Result.iWidthX + (Result.iLongX - iLongX);
        Result.iLongX := iLongX;
      end;

      if iLongX > Result.iLongX + Result.iWidthX then
        Result.iWidthX := iLongX - Result.iLongX;

      if iLatY < Result.iLatY then
      begin
        Result.iHeightY := Result.iHeightY + (Result.iLatY - iLatY);
        Result.iLatY := iLatY;
      end;
      if iLatY > Result.iLatY + Result.iHeightY then
        Result.iHeightY := iLatY - Result.iLatY;
    end;
end;

{------------------------------------------------------------------------------
  PointsToRect
------------------------------------------------------------------------------}
{**
  @Param ptArray Array of Points.
  @Return Rect encompassing the points.
}
function PointsToRect(ptArray: array of TPoint): TRect;
var
  idx: integer;
begin
  Result.TopLeft := ptArray[0];
  Result.BottomRight := ptArray[0];

  for idx := 1 to High(ptArray) do
    with ptArray[idx] do
    begin
      if X < Result.Left then    Result.Left := X;
      if X > Result.Right then   Result.Right := X;
      if Y < Result.Top then     Result.Top := Y;
      if Y > Result.Bottom then  Result.Bottom := Y;
    end;
end;

function PointsDoubleToRect(ptArray: array of TPointDouble): TRect;
 var
  idx: integer;
begin
  Result.TopLeft := PointD(ptArray[0]);
  Result.BottomRight := PointD(ptArray[0]);

  for idx := 1 to High(ptArray) do
    with ptArray[idx] do
    begin
      if X < Result.Left then   Result.Left := round(X);
      if X > Result.Right then  Result.Right :=round( X);
      if Y < Result.Top then    Result.Top := round(Y);
      if Y > Result.Bottom then Result.Bottom := round(Y);
    end;
end;

{------------------------------------------------------------------------------
  DecimalToEarthUnits
------------------------------------------------------------------------------}
{**
  @Param Value Value to convert in Decimal Degrees.
  @Return Value converted to EarthUnits.
}
function DecimalToEarthUnits(const Value: Extended): Extended;
var
  iDeg, iMin, iSec, iThou: Extended;
  Val: Extended;
begin
  iDeg := Trunc(Value) mod 360;
  Val := Frac(Value) * 60;
  iMin := Trunc(Val);
  Val := Frac(Val) * 60;

  iSec := Trunc(Val);
  iThou := (Frac(Val) * Earth_RESOLUTION_Max);

  Result := iDeg * GU_DEGREE + iMin * GU_MINUTE + iSec * GU_SECOND + iThou;
end;

{------------------------------------------------------------------------------
  DecimalToPointLL
------------------------------------------------------------------------------}
{**
  @Param Longitude Longitude to convert in Decimal Degrees.
  @Param Latitude Latitude to convert in Decimal Degrees.
  @Return PointLL object created from Longitude and Latitude.
}
function DecimalToPointLL(const Longitude, Latitude: Extended): TPointLL;
begin
  Result := PointLL(DecimalToEarthUnits(Longitude), DecimalToEarthUnits(Latitude));
end;

{------------------------------------------------------------------------------
  EarthUnitsToDecimal
------------------------------------------------------------------------------}
{**
  @Param iValue Value in EarthUnits to convert.
  @Return Value converted to Decimal Degrees.
}
function EarthUnitsToDecimal(iValue: Extended): Extended;
begin
  Result := iValue * (1 / GU_DEGREE);
end;


function EarthUnitsTo(iValue: Extended; Units: TEarthUnitTypes): Extended;
 var D:Extended;
begin
  try
    d:=GU_Conversions[Ord(Units)];
     if  d=0 then
       Result := iValue  else
       Result := iValue/d;
  except
    Result := iValue;
  end;
end;

function HeightUnitsTo(iValue: Double; Units: THeightUnitTypes): Extended;
 var D:Extended;
begin
  try
    d:=GU_HeightConversions[Ord(Units)];
     if  d=0 then
       Result := iValue  else
       Result := iValue/d;
  except
    Result := iValue;
  end;
end;

function EarthUnitsFrom(const eValue: Extended; Units: TEarthUnitTypes): Double;
begin
  Result :=(eValue * GU_Conversions[Ord(Units)]);
end;

function HeightUnitsFrom(const eValue: Extended; Units: THeightUnitTypes): Double;
begin
  Result := eValue * GU_HeightConversions[Ord(Units)];
end;


function StrToUnits(const sUnits: string): TEarthUnitTypes;
var
  idx: integer;
begin
  for idx := 0 to High(EarthUnitStrings) do
    if CompareText(sUnits, EarthUnitStrings[idx]) = 0 then
    begin
      Result := TEarthUnitTypes(idx);
      Exit;
    end;
  raise EEarthException.CreateFmt(rsEStrToUnitsMsg, [sUnits]);
end;

function StrToHUnits(const sUnits: string): THeightUnitTypes;
var
  idx: integer;
begin
  for idx := 0 to High(HeightUnitStrings) do
    if CompareText(sUnits, HeightUnitStrings[idx]) = 0 then
    begin
      Result := THeightUnitTypes(idx);
      Exit;
    end;
  raise EEarthException.CreateFmt(rsEStrToUnitsMsg, [sUnits]);
end;


function UnitsToStr(Units: TEarthUnitTypes): string;
begin
  Result := EarthUnitStrings[Ord(Units)];
end;

function HUnitsToStr(Units: THeightUnitTypes): string;
begin
  Result := HeightUnitStrings[Ord(Units)];
end;

{------------------------------------------------------------------------------
 Mod180
------------------------------------------------------------------------------}
{**
  @Param Value Value in EarthUnits to modulus
  @Return Value modified to be in the range -180 .. +180
}

function Mod180(Value: integer): Integer;
begin
  if Value > Round(GU_180_DEGREE) + 1 then
    Value := Value - Round(GU_360_DEGREE)
  else
    if Value < -Round(GU_180_DEGREE + 1) then
      Value := Value + Round(GU_360_DEGREE);
  Result := Value;
end;

function Mod180Float(Value: Extended): Extended;
begin
  if Value > GU_180_DEGREE then
    Value := Value - GU_360_DEGREE
  else
    if Value < -GU_180_DEGREE then
      Value := Value + GU_360_DEGREE;
  Result := Value;
end;

Function  MulDivFloat(a,b,d:Extended):Extended;
 begin
  // result:=MulDiv(Round(a),Round(b),Round(d));
   result:= a * b / d;
 end;
{------------------------------------------------------------------------------
  LimitFloat
------------------------------------------------------------------------------}
{**
  @Param eValue Extended value to Limit.
  @Param eMin Minimum Extended value of Limit.
  @Param eMax Minimum Extended value of Limit.
  @Return Smaller Extended value of eLeft and eRight.
}
function LimitFloat(const eValue, eMin, eMax: Extended): Extended;
begin
  Result := eValue;
  if Result < eMin then Result := eMin
  else
  if Result > eMax then Result := eMax;
end;

{------------------------------------------------------------------------------
  LongDiff
------------------------------------------------------------------------------}
{**
  @Param iLong1 First Longitude in Earth Units.
  @Param iLong2 Second Longitude in Earth Units.
  @Return Distance in Earth Units between the two Longitudes.
}
function LongDiff(iLong1, iLong2: Double): Double;
begin
  Result := abs(iLong2 - iLong1);

  if Result >= GU_180_DEGREE then Result := GU_360_DEGREE - Result;

  if Result = 0 then Result:=GMaxDouble; { avoid divide by zero }
end;

{------------------------------------------------------------------------------
  StrToExtendedDef
------------------------------------------------------------------------------}
{**
  @Param Text String to convert.
  @Param Default Value to use if the conversion fails.
  @Return Extended representation of string.
}
function StrToExtendedDef(const Text: string; Default: Extended): Extended;
var
  Code: integer;
begin
  Val(Text, Result, Code);
  if Code <> 0 then  Result := Default;
end;

{------------------------------------------------------------------------------
  StrToExtended
------------------------------------------------------------------------------}
{**
  @Param Text String to convert.
  @Return Extended representation of string.
}
function StrToExtended(const Text: string): Extended;
var
  Code: integer;
begin
  Val(Text, Result, Code);
  if Code <> 0 then
    raise EEarthException.CreateFmt(rsEConversionError, [Text]);
end;

{-------------------------------------------------------------------------
 AngleToRadians
-------------------------------------------------------------------------}
{**
  @Param iAngle Angle in radians to convert to EarthUnits.
  @Return Angle in EarthUnits.
}
function AngleToRadians(iAngle: Extended): Extended;
begin
  Result := iAngle * GU_TORADIANS;
end;

{-------------------------------------------------------------------------
 RadiansToAngle
-------------------------------------------------------------------------}
{**
  @Param iAngle Angle in EarthUnits to convert to radians.
  @Return Angle in Radians.
}

function RadiansToAngle(eRad: Extended): Extended;
begin
  Result := (eRad * GU_FROMRADIANS);
end;

{------------------------------------------------------------------------------
 Cross180
------------------------------------------------------------------------------}
{**
  @Param iLong Longitude coordinate in EarthUnits
  @Return True if this point has crossed the 180 meridian since the last call to this routine.
}
function Cross180(iLong:Double): Boolean;
var
  iZone,iLastZone: Double;
begin
  iLastZone:=0;
  iZone := iLong / GU_90_DEGREE;
  Result := ((iZone < 0) and (iLastZone > 0)) or ((iZone > 0) and (iLastZone < 0));
  iLastZone := iZone;
end;
     {
function Cross180(iLong:Double): Boolean;
var  iZone,iLastZone: integer;
begin
  iLastZone:=0;
  iZone := Round(iLong / GU_90_DEGREE);
  Result := ((iZone < 0) and (iLastZone > 0)) or ((iZone > 0) and (iLastZone < 0));
  iLastZone := iZone;
end;
      }
{-------------------------------------------------------------------------
 Sign
-------------------------------------------------------------------------}
{**
  @Param Value to test the sign of.
  @Return -1 if Value is < 0 or 1 if >= 0.
}
function Sign(Value: Extended): Extended;
begin
  Result := 1.0;
  if Value < 0.0 then  Result := -1.0;
end;

{------------------------------------------------------------------------------
 SphericalMod
------------------------------------------------------------------------------}
{**
  @Param X Value in radians to modulus.
  @Return X in the range -LocalPi to +LocalPi
}
function SphericalMod(X: Extended): Extended;
begin
  Result := X;
  if X < -LocalPi then
    Result := X + DoublePi
  else
    if X > LocalPi then
      Result := X - DoublePi;
end;


{------------------------------------------------------------------------------
 V3D
------------------------------------------------------------------------------}
{**
  @Param eX X element of Vector.
  @Param eY Y element of Vector.
  @Param eZ Z element of Vector.
  @Return Normalised Vector.
}
function V3D(eX, eY, eZ: Extended): TV3D;
begin
  Result.X := eX;
  Result.Y := eY;
  Result.Z := eZ;
  V3DNormalize(Result);
end;

{------------------------------------------------------------------------------
 PointLLToV3D
 Creates a normalised Vector from a TPointLL
------------------------------------------------------------------------------}
{**
  @Param pt Point to convert.
  @Return PointLL converted to a 3D Vector.
}
function PointLLToV3D(const ptLL: TPointLL): TV3D;
begin
  with Point3D(ptLL.iLongX, ptLL.iLatY, ptLL.iHeightZ) do
    Result := V3D(iWorldX, iWorldY, iWorldZ);
end;

{------------------------------------------------------------------------------
 V3DtoPointLL
 Converts a Vector back to a TPointLL
------------------------------------------------------------------------------}
{**
  @Param vec Vector to convert.
  @Return 3D vector converted to a PointLL
}
function V3DtoPointLL(const vec: TV3D): TPointLL;
begin
  if vec.z <> 0 then
    Result.iLongX := (ArcTan2(vec.x, vec.z) * GU_FROMRADIANS);
  Result.iLatY := (ArcSin(vec.y) * GU_FROMRADIANS);
  Result.iHeightZ := 0;
end;

{------------------------------------------------------------------------------
 V3DNormalize
------------------------------------------------------------------------------}
{**
  @Param vec Vector to Normalise.
  @Return Normalised a Vector.
}
procedure V3DNormalize(var vec: TV3D);
var
  eLen: Extended;
begin
  with vec do
  begin
    eLen := x * x + y * y + z * z;

    if eLen < GEPSILON then Exit;

    eLen := 1 / sqrt(eLen);
    x := x * eLen;
    y := y * eLen;
    z := z * eLen;
  end;
end;

{------------------------------------------------------------------------------
 V3DAdd
 Adds 2 vectors and normalises the result
------------------------------------------------------------------------------}
{**
  @Param a Vector to add.
  @Param b Vector to add.
  @Return Sum of vectors.
}
function V3DAdd(const a, b: TV3D): TV3D;
begin
  Result.x := a.x + b.x;
  Result.y := a.y + b.y;
  Result.z := a.z + b.z;
  V3DNormalize(Result);
end;

{------------------------------------------------------------------------------
 V3DSub
 Subtracts 2 vectors and normalises the result
------------------------------------------------------------------------------}
{**
  @Param a Vector to subtract from.
  @Param b Vector to subtract.
  @Return Resultant Vector.
}
function V3DSub(const a, b: TV3D): TV3D;
begin
  Result.x := a.x - b.x;
  Result.y := a.y - b.y;
  Result.z := a.z - b.z;
  V3DNormalize(Result);
end;

{------------------------------------------------------------------------------
 V3DMul
 Multiplys 2 vectors and normalises the result
------------------------------------------------------------------------------}
{**
  @Param a Normalised Vector.
  @Param b Normalised Vector.
  @Return Normalised Product Vector.
}
function V3DMul(const a, b: TV3D): TV3D;
begin
  Result.x := a.x * b.x;
  Result.y := a.y * b.y;
  Result.z := a.z * b.z;
  V3DNormalize(Result);
end;

{------------------------------------------------------------------------------
 V3DDot
------------------------------------------------------------------------------}
{**
  @Param a Normalised Vector.
  @Param b Normalised Vector.
  @Return Angle between the Vectors
}
function V3DDot(const a, b: TV3D): Extended;
begin
  Result := a.x * b.x + a.y * b.y + a.z * b.z;
end;

{------------------------------------------------------------------------------
 V3DCross
------------------------------------------------------------------------------}
{**
  @Param a Normalised Vector.
  @Param b Normalised Vector.
  @Return Normalised Vector representing the normal to the plane that the 2 vectors share.
}
function V3DCross(const a, b: TV3D): TV3D;
begin
  Result.x := a.y * b.z - a.z * b.y;
  Result.y := a.z * b.x - a.x * b.z;
  Result.z := a.x * b.y - a.y * b.x;
  V3DNormalize(Result);
end;

{------------------------------------------------------------------------------
 V3DLerp

 Linearly interpolate between vectors by an amount alpha and return the
 Resulting vector.
 When alpha=0, Result=lo.  When alpha=1, Result=hi.
 Untested.
------------------------------------------------------------------------------}
{**
  @Param lo Starting Vector.
  @Param hi Ending Vector.
  @param alpha Angle to rotate through.
  @Return New resultant vector.
}
function V3DLerp(const lo, hi: TV3D; alpha: Extended): TV3D;
  function LERP(a, l, h: Extended): Extended;
  begin
    Result := l + ((h - l) * a);
  end;
begin
  Result.x := LERP(alpha, lo.x, hi.x);
  Result.y := LERP(alpha, lo.y, hi.y);
  Result.z := LERP(alpha, lo.z, hi.z);
  { V3DNormalize( Result );}
end;

{------------------------------------------------------------------------------
 V3DMatrixMul
 Multiplys a vector by the matrix
------------------------------------------------------------------------------}
{**
  @Param mat Matrix to transform point with.
  @Param vec Vector to transform.
  @Return New Vector after transformation.
}
function V3DMatrixMul(const mat: TGMatrix; const vec: TV3D): TV3D;
begin
  with vec do
  begin
    Result.X := mat[0] * X + mat[1] * Y + mat[2] * Z;
    Result.Y := mat[3] * X + mat[4] * Y + mat[5] * Z;
    Result.Z := mat[6] * X + mat[7] * Y + mat[8] * Z;
  end;
  V3DNormalize(Result);
end;

{------------------------------------------------------------------------------
 PointLLMatrixMul
------------------------------------------------------------------------------}
{**
  @Param mat Matrix to transform point with.
  @param pt Point to transform
  @Return New Point after transformation with the matrix.
}
function PointLLMatrixMul(const mat: TGMatrix; const ptLL: TPointLL): TPointLL;
begin
  Result := V3DToPointLL(V3DMatrixMul(mat, PointLLToV3D(ptLL)));
end;

{------------------------------------------------------------------------------
 Quaternion
------------------------------------------------------------------------------}
{**
  @Param X X element of the Quaternion.
  @Param Y Yelement of the Quaternion.
  @Param Z Z element of the Quaternion.
  @Param W W element of the Quaternion.
  @Return A Normalised Quaternion.
}
function Quat(X, Y, Z, W: Extended): TQuaternion;
begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
  Result.W := W;
  QuatNormalize(Result);
end;

{------------------------------------------------------------------------------
 AxisAngleToQuat
------------------------------------------------------------------------------}
{**
  @Param axis Normalised Vector to represent the Axis.
  @Param angle Angle in radians to set the Quaternion to.
  @Return Converted Vector and angle of rotation to Quaternion.
}
function AxisAngleToQuat(const axis: TV3D; angle: Extended): TQuaternion;
var
  eCos, eSin: Extended;
begin
  SinCos(angle * 0.5, eSin, eCos);
  with Result do
  begin
    x := axis.x * eSin;
    y := axis.y * eSin;
    z := axis.z * eSin;
    w := eCos;
  end;
end;

{------------------------------------------------------------------------------
 QuatToAxisAngle
------------------------------------------------------------------------------}
{**
  @Param Quat Quaternion to convert to Axis Angle representation.
  @Param Axis Resultant Axis.
  @Param Angle Resultant Angle.
}
procedure QuatToAxisAngle(const Quat: TQuaternion; var Axis: TV3D; var Angle: Extended);
var
  eLen: Extended;
begin
  with Quat do
  begin
    eLen := x * x + y * y + z * z;

    if eLen > GEPSILON then
    begin
      eLen := 1 / eLen;
      Axis := V3D(x * eLen, y * eLen, z * eLen);
      Angle := 2.0 * ArcCos(w);
    end
    else
    begin
      Axis := V3D(0, 0, 1);
      Angle := 0.0;
    end;
  end;
end;

{------------------------------------------------------------------------------
 QuatNormalize
------------------------------------------------------------------------------}
{**
  @Param Quat Quaternion to Normalise.
  @Return Normalised Quaternion.
}
procedure QuatNormalize(var Quat: TQuaternion);
var
  eLen: Extended;
begin
  with Quat do
  begin
    eLen := x * x + y * y + z * z + w * w;
    if eLen > 0.0 then
      eLen := 1.0 / Sqrt(eLen)
    else
      eLen := 1;

    x := x * eLen;
    y := y * eLen;
    z := z * eLen;
    w := w * eLen;
  end;
end;

{------------------------------------------------------------------------------
 QuatMul
------------------------------------------------------------------------------}
{**
  @Param q1 First Quaternion.
  @Param q2 Second Quaternion.
  @Return Product of the Quaternions.
}
function QuatMul(const q1, q2: TQuaternion): TQuaternion;
begin
  Result.X := q2.W * q1.X + q2.X * q1.W + q2.Y * q1.Z - q2.Z * q1.Y;
  Result.Y := q2.W * q1.Y + q2.Y * q1.W + q2.Z * q1.X - q2.X * q1.Z;
  Result.Z := q2.W * q1.Z + q2.Z * q1.W + q2.X * q1.Y - q2.Y * q1.X;
  Result.W := q2.W * q1.W - q2.X * q1.X - q2.Y * q1.Y - q2.Z * q1.Z;
end;

{------------------------------------------------------------------------------
 QuatDot
------------------------------------------------------------------------------}
{**
  @Param q1 First Quaternion.
  @Param q2 Second Quaternion.
  @Return dot product of 2 Quaternions.
}
function QuatDot(const q1, q2: TQuaternion): Extended;
begin
  Result := q1.X * q2.X + q1.Y * q2.Y + q1.Z * q2.Z + q1.W * q2.W;
end;

{------------------------------------------------------------------------------
 EulerToQuat
 Converts Euler angles to a Quaternion
------------------------------------------------------------------------------}
{**
  @Param iRotX X rotation angle.
  @Param iRotY Y rotation angle.
  @Param iRotZ Z rotation angle.
  @Return Quaternion built from the Euler angles.
}
function EulerToQuat(iRotX, iRotY, iRotZ: Extended): TQuaternion;
var
  eSX, eCX, eSY, eCY, eSZ, eCZ: Extended;
begin
  SinCos((LocalPI - iRotX * DEG_TORADIANS) * 0.5, eSX, eCX);
  SinCos(iRotY * DEG_TORADIANS * 0.5, eSY, eCY);
  SinCos(iRotZ * DEG_TORADIANS * 0.5, eSZ, eCZ);

  Result.X := (eCY * eSX * eCZ) - (eSY * eCX * eSZ);
  Result.Y := (eCY * eSX * eSZ) + (eSY * eCX * eCZ);
  Result.Z := (eCY * eCX * eSZ) - (eSY * eSX * eCZ);
  Result.W := (eCY * eCX * eCZ) + (eSY * eSX * eSZ);
end;

{------------------------------------------------------------------------------
 QuatToMatrix
 Converts a Quaternion to a Matrix
------------------------------------------------------------------------------}
{**
  @Param Quat Input Quaternion.
  @Param mat Matrix to set to represent the Quaternion.
}
procedure QuatToMatrix(const Quat: TQuaternion; var mat: TGMatrix);
var
  x2, y2, z2, xx, xy, xz, yy, yz, zz, wx, wy, wz: Extended;
begin
  with Quat do
  begin
    x2 := x + x;
    y2 := y + y;
    z2 := z + z;
    xx := x * x2;
    xy := x * y2;
    xz := x * z2;
    yy := y * y2;
    yz := y * z2;
    zz := z * z2;
    wx := w * x2;
    wy := w * y2;
    wz := w * z2;
  end;

  mat[0] := 1.0 - (yy + zz);
  mat[1] := xy + wz;
  mat[2] := xz - wy;
  mat[3] := xy - wz;
  mat[4] := 1.0 - (xx + zz);
  mat[5] := yz + wx;
  mat[6] := xz + wy;
  mat[7] := yz - wx;
  mat[8] := 1.0 - (xx + yy);
end;

{------------------------------------------------------------------------------
 QuatSlerp
 Spherically Interpolats a Quaternion
 When alpha=0, Result=qLo.  When alpha=1, Result=qHi.
 Untested.
------------------------------------------------------------------------------}
{**
  @Param qLo Starting Quaternion.
  @Param qHi Ending Quaternion.
  @Param Alpha Angle to move through.
  @Return Quaternion representing the change.
}
function QuatSlerp(const qLo, qHi: TQuaternion; Alpha: Extended): TQuaternion;
var
  hiX, hiY, hiZ, hiW: Extended;
  CosAngle, t, Sint, ScaleLo, ScaleHi: Extended;
begin
  CosAngle := QuatDot(qLo, qHi);

  { adjust signs (if necessary) }
  with qHi do
    if CosAngle < 0.0 then
    begin
      CosAngle := -CosAngle;
      hiX := -x;
      hiY := -y;
      hiZ := -z;
      hiW := -w;
    end
    else
    begin
      hiX := x;
      hiY := y;
      hiZ := z;
      hiW := w;
    end;

  { quaternions are very close so do a linear interpolation }
  ScaleLo := 1.0 - Alpha;
  ScaleHi := Alpha;

  { calculate coefficients }
  if ScaleLo > GEPSILON then
  begin
    { standard case (slerp)}
    t := ArcCos(CosAngle);
    Sint := Sin(t);
    ScaleLo := Sin(ScaleLo * t) / Sint;
    ScaleHi := Sin(ScaleHi * t) / Sint;
  end;

  with qLo do
    Result := Quat(
      ScaleLo * X + ScaleHi * hiX, ScaleLo * Y + ScaleHi * hiY,
      ScaleLo * Z + ScaleHi * hiZ, ScaleLo * W + ScaleHi * hiW);
end;

{------------------------------------------------------------------------------
 VectorsToQuat
 Creates a Quaternion that represents the Rotation of one vector to the other.
 Untested.
------------------------------------------------------------------------------}
{**
  @Param vec1 Normalised Vector.
  @param vec2 Normalised Vector.
  @Return Quaternion representing the change from vec1 to vec2.
}
function VectorsToQuat(const vec1, vec2: TV3D): TQuaternion;
var
  vec: TV3D;
  CosAngle, eTmp: Extended;
begin
  CosAngle := V3DDot(vec1, vec2);

  { check if parallel }
  if CosAngle > 0.99999 then
    Result := Quat(0, 0, 0, 1)
  else
    if CosAngle < -0.99999 then { check if opposite }
    begin
      { check if we can use cross product of from vector with [1, 0, 0] }
      vec := V3D(0, vec1.x, -vec1.y);
      with vec do
        eTmp := sqrt(y * y + z * z); { get length of vector }

      if eTmp < GEPSILON then { we need cross product of from vector with [0, 1, 0] }
        vec := V3D(-vec1.z, 0, vec1.x);

      with vec do
        Result := Quat(X, Y, Z, 0);
    end
    else
    begin
      eTmp := Sqrt(0.5 * (1.0 - CosAngle));
      with V3DCross(vec1, vec2) do
        Result := Quat(X * eTmp, Y * eTmp, Z * eTmp, sqrt(0.5 * (1.0 + CosAngle)));
    end;
end;

{------------------------------------------------------------------------------
 ScaleMatrix
------------------------------------------------------------------------------}
{**
  @Param mat Matrix to Scale.
  @Param eSF Scale factor to apply.
}
procedure ScaleMatrix(var mat: TGMatrix; eSF: Extended);
var
  idx: Integer;
begin
  for idx := 0 to 8 do
    mat[idx] := mat[idx] * eSF;
end;

{------------------------------------------------------------------------------
 TransposeMatrix
------------------------------------------------------------------------------}
{**
  @Param FromMat Source Matrix.
  @Param ToMat Transposed version of FromMat.
}
procedure TransposeMatrix(var FromMat, ToMat: TGMatrix);
begin
  ToMat[0] := FromMat[0];
  ToMat[3] := FromMat[1];
  ToMat[6] := FromMat[2];
  ToMat[1] := FromMat[3];
  ToMat[4] := FromMat[4];
  ToMat[7] := FromMat[5];
  ToMat[2] := FromMat[6];
  ToMat[5] := FromMat[7];
  ToMat[8] := FromMat[8];
end;

//============================================================================
//==========================TGroupsStore =====================================
//============================================================================

constructor TGroupsStore.Create;
begin
  inherited Create;
  FGroups := DynArrayCreate( SizeOf( TPointStore ), 0 );
end;

destructor TGroupsStore.Destroy;
var
  idx : integer;
begin
  for idx := 0 to FGroups.Count - 1 do
    Group[idx].Free;

  DynArrayFree( FGroups );

  inherited Destroy;
end;

procedure TGroupsStore.SetStoreHeight(const Value: Boolean);
var
  idx : integer;
begin
  if Value <> FStoreHeight then
  begin
    FStoreHeight := Value;

    for idx := 0 to Count - 1 do
      Group[idx].StoreHeight := Value;
  end;
end;

procedure TGroupsStore.SetCount( iNewCount : integer);
var
  idx : integer;
begin
  // free up the chains if reducing the count
  idx := FGroups.Count;
  while idx > iNewCount do
  begin
    Dec( idx );
    DynArrayAsObject( FGroups, idx ).Free;
  end;

  DynArraySetLength( FGroups, iNewCount );

  while idx < iNewCount do
  begin
    DynArraySetAsObject( FGroups, idx, nil );
    Inc( idx );
  end;
end;

function TGroupsStore.GetGroup( iIndex : integer ) : TPointStore;
begin
  if iIndex >= Count then
    Count := iIndex + 1;
  Result := TPointStore( DynArrayAsObject( FGroups, iIndex ));

  if Result = nil then
  begin
    Result := TPointStore.Create;
    Result.StoreHeight := FStoreHeight; // Set the default storeheight
    DynArraySetAsObject( FGroups, iIndex, Result );
  end;
end;

function TGroupsStore.GetCount : integer;
begin
  Result := FGroups.Count;
end;

procedure TGroupsStore.SetGroup( iIndex : integer; Value : TPointStore );
var
  Tmp : DynArray;
begin
  Tmp := PDynArray(DynArrayPtr( FGroups, iIndex ))^;
  DynArrayFree( Tmp );
  PTPointStore( DynArrayPtr( FGroups, iIndex ))^ := Value;
end;

procedure TGroupsStore.Insert(iIndex : Integer; PointStore : TPointStore);
begin
if (iIndex<0) or (iIndex>=count) or (count=0) then
   begin
     add(PointStore);
     exit;
   end;

  DynArrayInsert( FGroups, iIndex );
  PTPointStore( DynArrayPtr( FGroups, iIndex ))^ := PointStore;
end;

procedure TGroupsStore.Delete(iIndex : Integer);
begin
  SetGroup( iIndex, nil );
  DynArrayDelete( FGroups, iIndex );
end;

Procedure TGroupsStore.Clear;
var i:integer;
 begin
  for i:=count-1 downto  0 do
   delete(i);
 end;

procedure TGroupsStore.Add( PointStore : TPointStore );
begin
  SetCount( Count + 1 );
  PTPointStore( DynArrayPtr( FGroups, Count - 1 ))^ := PointStore;
end;

function  TGroupsStore.AddNew:TPointStore;
var 
  Chec: TpointStore;
begin
  Chec := TpointStore.Create;
  Add(Chec);
  result:=Chec;
 end;

procedure TGroupsStore.Move( iFrom, iTo : integer );
begin
if (iTo<0) or (iFrom>=count) or (count<1) or (iFrom=iTo) then exit;
  DynArrayMove( FGroups, iFrom, iTo );
end;


function TGroupsStore.Clone : TGroupsStore;
begin
  Result := TGroupsStoreClass(Self.ClassType).Create;
  Result.FGroups := DynArrayClone( FGroups );
end;

function TGroupsStore.Centroid : TPointLL;
var
  idx, iCount : Integer;
  eSumX, eSumY, eSumZ : Extended;
begin
  eSumX := 0;
  eSumY := 0;
  eSumZ := 0;
  iCount := Count;
  for idx := 0 to iCount - 1 do
    with Group[idx].Centroid do
    begin
      eSumX := eSumX + iLongX;
      eSumY := eSumY + iLatY;
      eSumZ := eSumZ + iHeightZ;
    end;
  if iCount = 0 then
    iCount := 1;
  Result := PointLLH( ( eSumX / iCount ),( eSumY / iCount ),( eSumZ / iCount ));
end;

function TGroupsStore.GroupStoreMER: TMER;
var
  idx : integer;
begin
  if Count > 0 then
  begin
    Result := Group[0].PointStoreMER;
    for idx := 1 to Count - 1 do
      if Group[idx].Count > 0 then
        Result := UnionMER(Result, Group[idx].PointStoreMER);
  end
  else
    Result := MER( 0, 0, 0, 0 );
end;

//==============================================================================
//==============================================================================
//==============================================================================

destructor TPointStore.Destroy;
begin
  DynArrayFree( FPoints );
  DynArrayFree( FPoint3DArray );
  inherited Destroy;
end;

function TPointStore.ObjectInstanceSize : integer;
begin
  Result := InstanceSize;
  if FPoints <> nil then
    Inc( Result, FPoints.Count * SizeOf( Double ) * (2 + Ord(psHeight in Flags)));
  if FPoint3DArray <> nil then
    Inc( Result, SizeOf( TPoint3D ) * FPoint3DArray.Count );
end;

function TPointStore.Clone : TPointStore;
begin
  Result := TPointStoreClass(Self.ClassType).Create;
  Result.Flags := Flags;
  Result.FPoints := DynArrayClone( FPoints );
end;

procedure TPointStore.Assign(Source: TPersistent);
 begin
  if Source is TPointStore then
   begin
     clear;
     Flags:=TPointStore(Source).Flags;
     FPoints:=DynArrayClone(TPointStore(Source).FPoints);
   end else
   begin
    inherited Assign(Source);
   end;
 end;


function TPointStore.Point3DArray( CacheArray : Boolean ) : DynArray;
var
  idx : integer;
  p : PTPoint3D;
  eSLong, eClong, eSLat, eCLat, eHeight, eTmp : Extended;
begin
  if not CacheArray then Refresh;

  Result := FPoint3DArray;
  if Result = nil then
  begin
    Result := DynArrayCreate( SizeOf( TPoint3D ), Count );

   // iPtr := DynArrayPtr( Result, 0);
    for idx := 0 to Count - 1 do
      with GetLL( idx ) do
      begin

        SinCos(iLongX * GU_TORADIANS, eSLong, eClong);
        SinCos(iLatY * GU_TORADIANS, eSLat, eCLat);
        eHeight := EARTHRADIUS + iHeightZ;
        eTmp := eHeight * eCLat;

        p:=DynArrayPtr( Result, idx);
        p^.iWorldX := (eTmp * eSlong);
        p^.iWorldY := (eHeight * eSLat);
        p^.iWorldZ := (eTmp * eCLong);

      end;

    if CacheArray then FPoint3DArray := Result;
  end;

  if CacheArray then DynArrayIncReference( Result );
end;

procedure TPointStore.SetCount(iNewCount : Integer);
begin
  DynArrayFree( FPoint3DArray );

  if FPoints = nil then
  begin
    if psHeight in Flags then
      FPoints := DynArrayCreate( SizeOf( TPointLL ), iNewCount ) else
      FPoints := DynArrayCreate( SizeOf( TPointDouble ), iNewCount );
  end;

  DynArraySetLength( FPoints, iNewCount );
end;


function TPointStore.GetCount : Integer;
begin
  if FPoints <> nil then
    Result := FPoints.Count
  else
    Result := 0;
end;

function TPointStore.GetHeightFlag : Boolean;
begin
  Result := ( psHeight in Flags );
end;


procedure TPointStore.SetHeightFlag( Value : Boolean );
var
  tmpStore : TPointStore;
  idx : integer;
begin
  if Value <> ( psHeight in Flags ) then
  begin
    tmpStore := Clone;  // Save the points then copy them all back in with the new Height state

    if Value then
      Include( Flags, psHeight )  else
      Exclude( Flags, psHeight );

    DynArrayFree( FPoints ); // Delete all existing point in the PointStore
    Count := tmpStore.Count;
    for idx := 0 to Count - 1 do
      asLL[idx] := tmpStore.asLL[idx];
    tmpStore.Free;
  end;
end;

function TPointStore.GetLL(iIndex : integer) : TPointLL;
var   //iPtr : PDouble;
      p2:PTPointDouble;
      p3:PTPointLL;
begin
 { iPtr := PDouble( DynArrayPtr( FPoints, iIndex));

  Result.iLongX := iPtr^;
  Inc( iPtr );
  Result.iLatY := iPtr^;

  if psHeight in Flags then
  begin
    Inc( iPtr );
    Result.iHeightZ := iPtr^;
  end
  else
    Result.iHeightZ := 0;  }
  //...............................
  Result.iHeightZ := 0;

  if psHeight in Flags then
  begin
    p3 := PTPointLL( DynArrayPtr( FPoints, iIndex));
    Result.iLongX  := P3^.iLongX;
    Result.iLatY   := P3^.iLatY;
    Result.iHeightZ := P3^.iHeightZ;
  end else
  begin
    p2 := PTPointDouble( DynArrayPtr( FPoints, iIndex));
    Result.iLongX  := P2^.X;
    Result.iLatY   := P2^.Y;
  end;

end;

procedure TPointStore.PutLL(iIndex : integer; const pt : TPointLL);
var //iPtr : PDouble;
    p2:PTPointDouble;
    p3:PTPointLL;
begin
 { Refresh;

  iPtr := PDouble( DynArrayPtr( FPoints, iIndex));

  iPtr^ := pt.iLongX;
  Inc( iPtr );
  iPtr^ := pt.iLatY;

  if psHeight in Flags then
  begin
    Inc( iPtr );
    iPtr^ := pt.iHeightZ;
  end;    }
  //.................................
  Refresh;
  if psHeight in Flags then
  begin
    p3 := PTPointLL( DynArrayPtr( FPoints, iIndex));
    P3^.iLongX  := pt.iLongX;
    P3^.iLatY   := pt.iLatY;
    P3^.iHeightZ := pt.iHeightZ;
  end else
  begin
    p2 := PTPointDouble( DynArrayPtr( FPoints, iIndex));
    P2^.X  := pt.iLongX;
    P2^.Y  := pt.iLatY;
  end;

end;


function TPointStore.GetDD(iIndex : integer) : TPointDD;
begin
  with AsLL[iIndex] do
    Result := PointDDH(
                        iLongX * (1 / GU_DEGREE),
                        iLatY * (1 / GU_DEGREE),
                        iHeightZ * (1 / GU_DEGREE));
end;

procedure TPointStore.PutDD(iIndex : integer; const pt : TPointDD);
begin
  Refresh;

  AsLL[iIndex] := PointLLH(
                       DecimalToEarthUnits( pt.LongX ),
                       DecimalToEarthUnits( pt.LatY ),
                       DecimalToEarthUnits( pt.HeightZ ));
end;


function TPointStore.Get3D(iIndex : integer) : TPoint3D;
begin
  with GetLL( iIndex ) do
    Result := Point3D(iLongX, iLatY, iHeightZ)
end;

procedure TPointStore.Insert(iIndex : Integer; ptLL : TPointLL);
begin
if (iIndex<0) or (iIndex>=count) or (count=0) then
   begin
     add(ptLL);
     exit;
   end;
  Refresh;
  DynArrayInsert( FPoints, iIndex );
  PutLL( iIndex, ptLL );
end;

procedure TPointStore.Move( iFrom, iTo : integer );
begin
if (iTo<0) or (iFrom>=count) or (count<1) or (iFrom=iTo) then exit;
  DynArrayMove( FPoints, iFrom, iTo );
end;

procedure TPointStore.Delete(iIndex : Integer);
begin
  Refresh;
  DynArrayDelete( FPoints, iIndex );
end;

Procedure TPointStore.Clear;
var i:integer;
 begin
  for i:=count-1 downto  0 do
   delete(i);
 end;

function TPointStore.Add( ptLL : TPointLL ) : integer;
begin
  Refresh;
  Result := Count;
  SetCount( Result + 1 );
  PutLL( Result, ptLL );
end;

function TPointStore.Centroid : TPointLL;
var
  idx, iCount : Integer;
  eSumX, eSumY, eSumZ : Extended;
begin
  eSumX := 0;
  eSumY := 0;
  eSumZ := 0;
  iCount := Count;
  for idx := 0 to iCount - 1 do
    with AsLL[idx] do
    begin
      eSumX := eSumX + iLongX;
      eSumY := eSumY + iLatY;
      eSumZ := eSumZ + iHeightZ;
    end;

  if iCount = 0 then iCount := 1;

  Result := PointLLH( ( eSumX / iCount ), ( eSumY / iCount ), ( eSumZ / iCount ));
end;

procedure TPointStore.Refresh;
begin
  if FPoint3DArray <> nil then
    DynArrayFree( FPoint3DArray );
end;

procedure TPointStore.Translate( dx, dy, dz : Double );
var
  idx : integer;
 // iPtr : PDouble;
  p2:PTPointDouble;
  p3:PTPointLL;
begin
 { Refresh;

  iPtr := PDouble( DynArrayPtr( FPoints, 0));

  if psHeight in Flags then
  begin
    for idx := 0 to Count - 1 do
    begin
      iPtr^ := iPtr^ + dx;
      Inc( iPtr );
      iPtr^ := iPtr^ + dy;
      Inc( iPtr );
      iPtr^ := iPtr^ + dz;
      Inc( iPtr );
    end;
  end
  else
    for idx := 0 to Count - 1 do
    begin
      iPtr^ := iPtr^ + dx;
      Inc( iPtr );
      iPtr^ := iPtr^ + dy;
      Inc( iPtr );
    end;   }
 //...................................
  Refresh;
  if psHeight in Flags then
  begin
    for idx := 0 to Count - 1 do
    begin
      p3 := PTPointLL( DynArrayPtr( FPoints,idx));
      P3^.iLongX  := P3^.iLongX   + dx;
      P3^.iLatY   := P3^.iLatY    + dy;
      P3^.iHeightZ := P3^.iHeightZ+ dz;
    end;
  end else
    for idx := 0 to Count - 1 do
    begin
      p2 := PTPointDouble( DynArrayPtr( FPoints,idx));
      P2^.X  := P2^.X+ dx;
      P2^.Y  := P2^.Y+ dy;
    end;  

end;

function TPointStore.PointStoreMER : TMER;
var
  iMaxX, iMinX, iMaxY, iMinY, iMinPlus, iMinMinus : Double;
  idx, iCross180Count : Integer;
  iLongX, iLatY : Double;
  iPtr : PTPointDouble;
  iLastZone : integer;

  procedure Cross180( iLong : Double );
  var iZone : integer;
  begin
    iZone := Round(iLong / GU_90_DEGREE);
    if ( ( iZone < 0 ) and ( iLastZone > 0 ) ) or ( ( iZone > 0 ) and ( iLastZone < 0 )) then
      Inc( iCross180Count );
    iLastZone := iZone;
  end;
begin
  if Count = 0 then
  begin
    Result := MER( 0, 0, 0, 0 );
    Exit;
  end;

  iMinX :=  GMaxDouble;
  iMaxX := -GMaxDouble;
  iMinY :=  GMaxDouble;
  iMaxY := -GMaxDouble;
  iMinPlus := GMaxDouble;
  iMinMinus := -GMaxDouble;

  Cross180( AsLL[Count - 1].iLongX ); { initialise Cross180 }
  iCross180Count := 0;

  for idx := 0 to Count - 1 do
  begin
    iPtr := PTPointDouble( DynArrayPtr( FPoints, idx));
    iLongX := iPtr^.X;
    iLatY :=  iPtr^.Y;

    Cross180( iLongX );

    if ( iLongX >= 0 ) and ( iLongX < iMinPlus ) then iMinPlus := iLongX;
    if ( iLongX < 0 ) and ( iLongX > iMinMinus ) then iMinMinus := iLongX;

    if iLongX < iMinX then iMinX := iLongX;
    if iLongX > iMaxX then iMaxX := iLongX;

    if iLatY < iMinY then iMinY := iLatY;
    if iLatY > iMaxY then iMaxY := iLatY;
  end;

  if ( iCross180Count mod 2 ) <> 0 then
    Result := MER( -GU_180_DEGREE + 1, iMinY, GU_360_DEGREE - 2, iMaxY - iMinY )
  else
    if iCross180Count > 0 then
      Result := MER( iMinPlus, iMinY, ( GU_180_DEGREE - iMinPlus ) + ( iMinMinus + GU_180_DEGREE ), iMaxY - iMinY ) else
      Result := MER( iMinX, iMinY, iMaxX - iMinX, iMaxY - iMinY );
end;

function TPointStore.PointOnPolyline( iLong, iLat, iTolerance : Double) : Boolean;
var
  ptLast, ptNew : TPointLL;
  idx : integer;
begin
  if Count > 0 then
  begin
    Result := True;
    ptLast := AsLL[0];
    
    for idx := 0 to Count - 1 do
    begin
      ptNew := AsLL[idx];
      if PointOnLine( iLong, iLat, ptLast.iLongX, ptLast.iLatY, ptNew.iLongX, ptNew.iLatY, iTolerance ) then
        Exit;
      ptLast := ptNew;
    end;
  end;
  Result := False;
end;

function TPointStore.PointInPolygon( iLong, iLat : Double ) : Boolean;
var
  iZone, idx : integer;
  iX1, iX2, iY1, iY2 : Double;
  iPtr : PTPointDouble;
begin
  Result := False;

  if iLong >= 0 then
    iZone := 2 else
    iZone := 1;

  iX2 := 0;
  iY2 := 0;
  for idx:=0 to Count - 1 do
  begin
    iPtr := PTPointDouble( DynArrayPtr( FPoints, idx));
    iX2 := iPtr^.X;
    iY2 := iPtr^.Y;

    if ( iZone = 1 ) and ( iX2 >= 0 ) then continue;
    if ( iZone = 2 ) and ( iX2 <= 0 ) then continue;
    Break;
  end;

  idx := 0;
  while idx < Count do
  begin
    iPtr := PTPointDouble( DynArrayPtr( FPoints, idx));
    iX1 := iPtr^.X;
    iY1 := iPtr^.Y;

    Inc( idx );

    if iZone <> 3 then
    begin
      if ( iZone = 1 ) and ( iX1 > 0 ) then continue;
      if ( iZone = 2 ) and ( iX1 < 0 ) then continue;
    end;

    if ( ( ( ( iY1 <= iLat ) and ( iLat < iY2 ) )
      or ( ( iY2 <= iLat ) and ( iLat < iY1 ) ) )
      and ( iLong < MulDivFloat( ( iX2 - iX1 ), ( iLat - iY1 ), ( iY2 - iY1 ) ) + iX1 ) ) then
      Result := not Result;

    iX2 := iX1;
    iY2 := iY1;
  end;
end;

 //=============================================================================
 //==================== TTextureData        ====================================
 //=============================================================================

constructor TTextureData.Create;
begin
  WorldPoints := TPointStore.Create;

  // Default to covering the whole of the earths surface
  WorldPoints.Count := 2;
  WorldPoints.AsLL[0] := PointLL( -GU_180_DEGREE, GU_90_DEGREE );
  WorldPoints.AsLL[1] := PointLL( GU_180_DEGREE, -GU_90_DEGREE );
  
  fTextureStream := Tbitmap32.Create;
  fTextureStream.DrawMode:=dmBlend;
  fTransparentColor := XClearColor;
end;



destructor TTextureData.Destroy;
begin
  WorldPoints.Free;
  WorldPoints := nil;

  fTextureStream.Free;
  fTextureStream := nil;

  inherited Destroy;
end;

Procedure TTextureData.Delete;
 begin
  WorldPoints.Clear;
  fTextureStream.Delete;
 end;

function TTextureData.LLToTextureXY( ptLL : TPointLL ) : TPoint;
var
  TL, BR : TPointLL;
begin
  TL := WorldPoints.AsLL[0];
  BR := WorldPoints.AsLL[1];

  // Bitmaps are stored upside down so Y is height - Y
  Result := Point(
    MulDiv( Round(ptLL.iLongX - TL.iLongX), Width - 1, Round(BR.iLongX - TL.iLongX) ),
    Height - 1 - MulDiv( Round(ptLL.iLatY - TL.iLatY), Height, Round(BR.iLatY - TL.iLatY) ));
end;

function TTextureData.TextureXYToLL( ptXY : TPoint ) : TPointLL;
var TL, BR : TPointLL;
begin
  TL := WorldPoints.AsLL[0];
  BR := WorldPoints.AsLL[1];

  Result := PointLL(
                    TL.iLongX + MulDivFloat( ptXY.X, (BR.iLongX - TL.iLongX), Width ),
                    TL.iLatY + MulDivFloat( ptXY.Y, (BR.iLatY - TL.iLatY), Height ));
end;


procedure TTextureData.MapPoint( iLong, iLat, TexX, TexY : Double );
begin
  // Currently this only allows the Top Left and Bottom Right coordinates to be specified.
  if ( TexX = 0 ) and ( TexY = 0 ) then
    WorldPoints.AsLL[0] := PointLL( iLong, iLat ) else
    WorldPoints.AsLL[1] := PointLL( iLong, iLat );
end;

function TTextureData.IsTextureOK : Boolean;
begin
  Result:=(TextureStream<>nil) and ( TextureStream.Width>0) and (TextureStream.Height>0) and (not TextureStream.Empty);
end;

function TTextureData.GetTextureWidth : integer;
begin
  result:=TextureStream.Width;
end;

function TTextureData.GetTextureHeight: integer;
begin
  result:=TextureStream.Height;
end;

procedure TTextureData.LoadFromStream(aStream : TStream);
begin
  try
    TextureStream.LoadFromStream(aStream);
   except
    TextureStream.Clear(XClearColor);
  end;
end;

procedure TTextureData.LoadFromFile( const sFilename : TFilename );
begin
  TextureStream.Clear(XClearColor);
  if FileExistsUTF8(sFilename ) { *Converted from FileExists* } then
  try
    Bmp32_LoadFromFile(TextureStream,sFilename);
    TextureFilename := '';
    TextureFilename := sFileName;
  finally

  end;
end;

procedure TTextureData.Assign(Source: TPersistent);
 var pic:TPicture;

 begin
if Source=nil then exit;

if Source is Tbitmap32 then
  begin
   TextureStream.Assign(Tbitmap32(Source));
   exit;
  end;

if Source is TPicture then
  begin
   TextureStream.Assign(TGraphic(Source));
   exit;
  end;

if Source is TTextureData then
  begin
    TextureStream.Assign(TTextureData(Source).TextureStream);
    Exit;
  end;

if (Source is TBitmap) or
   (Source is Ticon) or
 //  (Source is TMetafile) or
   (Source is TGraphic)  then
  begin
   pic:=TPicture.Create;
   try
    pic.Assign(Source);
    TextureStream.Assign(pic);
    finally
     pic.Free;
    end;

   exit;
  end;

 inherited Assign(Source);

end;

//================================================================================
//================= TEarthRoot ===================================================
//================================================================================

class function TEarthRoot.PrintableClassName: string;
begin
  Result := ClassName;
end;

procedure TEarthRoot.RedrawObject;
 begin
  //Nothing
 end;

Procedure TEarthRoot.BeginUpdate;
 begin
  FIsUpdating:=true;
 end;

Procedure TEarthRoot.EndUpdate;
 begin
  FIsUpdating:=false;
  RedrawObject;
 end;


 //=======================================================================

Function FixFilePath(Const Inpath,CheckPath:string):string;
var   i,si: Integer;
      sl1,sl2 : TStringList;
      s1,s2:string;
begin
 Result:='';
 if inPath='' then exit;
 Result:=inPath;
 if CheckPath='' then exit;

 if SameText(ExtractFiledrive(Inpath),ExtractFiledrive(CheckPath))=false then exit;

 sl1:=TStringList.Create;
 sl2:=TStringList.Create;

 try
  FillStringList(sl1,EXtractFilePath(Inpath));
  FillStringList(sl2,EXtractFilePath(CheckPath));

  //........... Find Common ..................
  si:=0;
  for i:=0 to Min(sl1.Count-1,sl2.Count-1) do
      if (sl1[i]<>'') and (sl2[i]<>'') and sameText(sl1[i],sl2[i]) then
        inc(si) else
        Break;

  //.......................................
  if si>0 then
  begin

    s1:='';
    if si<(sl2.Count) then
      For i:=0 to (sl2.Count-si) do s1:=FixText+s1;


    s2:='';
    if si<sl1.Count then
      For i:=(sl1.Count-1) downto si do s2:=sl1[i]+s2;



     result:=s1+s2+ExtractFileName(Inpath);
  end else
  begin
     result:=Inpath;
  end;

   finally
      sl1.Free;
      sl2.Free;
   end;

end;

Function UnFixFilePath(Const Inpath,CheckPath:string):string;
  var i,si : Integer;
      sl1,sl2 : TStringList;
      s1,s2:string;
begin
 Result:='';
 if inPath='' then exit;
 Result:=inPath;
 if CheckPath='' then exit;

if ExtractFiledrive(Inpath)<>'' then exit;

  sl1:=TStringList.Create;
  sl2:=TStringList.Create;

try
  FillStringList(sl1,EXtractFilePath(Inpath));
  FillStringList(sl2,EXtractFilePath(CheckPath));

  //.............................
  si:=0;

  for i:=0 to sl1.Count-1 do
    if sameText(sl1[i],'..\') then
        inc(si) else
        Break;

  if  si>0 then
  begin

      s1:='';
      if si<sl2.Count then
        For i:=0 to (sl2.Count-si) do s1:=s1+sl2[i];

      s2:='';
      if si<sl1.Count then
        For i:=sl1.Count-1 downto si do s2:=sl1[i]+s2;

      result:=s1+s2+ExtractFileName(Inpath);
  end else
  begin
     result:=CheckPath+Inpath;
  end;

   finally
      sl1.Free;
      sl2.Free;
   end;
  end;


//==========================================
Procedure FillStringList(sl:TStringList;const aText:string);
 var p1,p2,l1:integer;
     ss:string;
     ex:boolean;
 begin
 if sl=nil then exit;
 if aText='' then exit;

 l1:=Length(aText);
 //...............
 p1:=1;
 p2:=0;

 repeat
   ex:=true;

   p2:=Pos('\',aText);

   if (p1<p2) and (p2>0) then
     begin
      ss:=copy(aText,p1,p2-p1+1);
      sl.Add(ss);
      p1:=p2+1;
      ex:=false;
     end;

 if p1>=l1 then exit;

 until ex=true;

 end;


//============================================================================
//========================= DynArray==========================================
//============================================================================

function DynArrayPtr(const aDynArray: DynArray; iIndex: integer): Pointer;
begin
  result:= @aDynArray^ +Sizeof(TDynArrayRecord) + iIndex * aDynArray^.ItemSize;
end;

function DynArrayAsObject(const aDynArray: DynArray; iIndex: integer): TObject;
 var objp:pointer;
begin
  objp:=DynArrayPtr(aDynArray,iIndex);
  result:=TObject(objp^);
end;

function DynArraySetAsObject(const aDynArray: DynArray; iIndex: integer; Obj: TObject): TObject;
 var objp:pointer;
begin
  objp:=DynArrayPtr(aDynArray,iIndex);
  TObject(objp^):=Obj ;
  result:=TObject(objp^);
end;

function DynArrayAsInteger(const aDynArray: DynArray; iIndex: integer): integer;
begin
  result:=integer(DynArrayPtr(aDynArray,iIndex));
end;

function DynArraySetAsInteger(const aDynArray: DynArray; iIndex: integer; Value: integer): integer;
 var i:Pointer;
begin
  i:=DynArrayPtr(aDynArray,iIndex);
  i:=Pointer(Value);
  result:=value;
end;

procedure DynArrayIncReference(const aDynArray: DynArray);
begin
  Inc(aDynArray^.RefCount);
end;

procedure DynArrayDecReference(const aDynArray: DynArray);
begin
  Dec(aDynArray^.RefCount);
end;

function DynArrayCount(const aDynArray: DynArray): integer;
begin
  Result := aDynArray^.Count;
end;

function DynArrayIndexOfObject(const aDynArray: DynArray; Obj: TObject): integer;
begin
  if aDynArray^.Itemsize = SizeOf(TObject) then
    for Result := 0 to aDynArray^.Count - 1 do
      if DynArrayAsObject(aDynArray, Result) = Obj then
        Exit;
  Result := -1;
end;

procedure DynArrayMove(var aDynArray: DynArray; iFrom, iTo: integer);
var
  tmpPtr: Pointer;
begin
  if aDynArray = nil then
    raise EEarthException.Create('DynArrayMove: Invalid Parameter');

  with aDynArray^ do
    if (iFrom <> iTo) and (iFrom < Count) and (iTo < Count) then
    begin
      tmpPtr := AllocMem(ItemSize);

      move(tmpPtr, DynArrayPtr(aDynArray, iFrom)^, ItemSize);

      DynArrayDelete(aDynArray, iFrom);
      DynArrayInsert(aDynArray, iTo);
      move(DynArrayPtr(aDynArray, iTo), tmpPtr, ItemSize);

      FreeMem(tmpPtr);
    end;
end;

procedure DynArrayInsert(var aDynArray: DynArray; iIndex: integer);
begin
  DynArraySetLength(aDynArray, aDynArray^.Count + 1);
  with aDynArray^ do
    if iIndex < Count then
      Move(DynArrayPtr(aDynArray, iIndex + 1), DynArrayPtr(aDynArray, iIndex)^, (Count - 1 - iIndex) * ItemSize);

end;

procedure DynArrayDelete(var aDynArray: DynArray; iIndex: integer);
begin
  with aDynArray^ do
    if (iIndex < Count) and (iIndex >= 0) then
    begin
      if iIndex <> Count-1 then
        Move(DynArrayPtr(aDynArray, iIndex), DynArrayPtr(aDynArray, iIndex + 1)^, (Count - iIndex - 1) * ItemSize);

      Dec(Count);
    end;
end;

function DynArrayCreate(const iItemSize, iCount: integer): DynArray;
begin
  Result := AllocMem(Sizeof(TDynArrayRecord) + iCount * iItemSize);
  Result^.ItemSize := iItemSize;
  Result^.Count := iCount;
end;

function DynArrayClone(const aDynArray: DynArray): DynArray;
var
  iSize: integer;
begin
  if aDynArray <> nil then
  begin
    iSize := Sizeof(TDynArrayRecord) + aDynArray^.ItemSize * aDynArray^.Count;
    Result := AllocMem(iSize);
    Move(aDynArray^, Result^, iSize);
    Result^.RefCount := 0;
  end
  else
    Result := nil;
end;

procedure DynArrayFree(var aDynArray: DynArray);
begin
  if aDynArray <> nil then
  begin
    if aDynArray^.RefCount = 0 then
      ReallocMem(aDynArray, 0)
    else
    begin
      DynArrayDecReference(aDynArray);
      aDynArray := nil;
    end;
  end;
end;

procedure DynArraySetLength(var aDynArray: DynArray; iCount: integer);
var
  CharPtr: PChar;
begin
  if aDynArray = nil then
    raise EEarthException.Create('DynArraySetLength: Invalid Parameter');

  if iCount <> aDynArray^.Count then
  begin
    ReallocMem(aDynArray, Sizeof(TDynArrayRecord) + aDynArray^.ItemSize * iCount);
    if iCount > aDynArray^.Count then
    begin
      CharPtr := DynArrayPtr(aDynArray, aDynArray^.Count);
      FillChar(CharPtr^, aDynArray^.ItemSize * (iCount - aDynArray^.Count), 0);
    end;
    aDynArray^.Count := iCount;
  end;
end;


end.
