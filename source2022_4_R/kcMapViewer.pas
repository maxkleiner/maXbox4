{ Map Viewer

  Copyright (C) 2011 Maciej Kaczkowski / keit.co

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}
unit kcMapViewer;

//{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Controls, Graphics, kcThreadPool, types;

type
  TMapViewer = class;
  TMapSource = (msNone, msGoogleNormal, msGoogleSatellite, msGoogleHybrid,
    msGooglePhysical, msGooglePhysicalHybrid, msOpenStreetMapMapnik,
    msOpenStreetMapOsmarender, msOpenCycleMap, msVirtualEarthBing,
    msVirtualEarthRoad, msVirtualEarthAerial, msVirtualEarthHybrid,
    msYahooNormal, msYahooSatellite, msYahooHybrid,
    msOviNormal, msOviSatellite, msOviHybrid, msOviPhysical);

  { TArea }

  TArea = record
    top, left, bottom, right: Int64;
  end;

  TRealArea = record
    top, left, bottom, right: Extended;
  end;

  TIntPoint = record
    X, Y: Int64;
  end;

  TRealPoint = record
    X, Y: Extended;
  end;

  { TCustomDownloadEngine }

  TOnBeforeDownloadEvent = procedure(Url: string; str: TStream; var CanHandle: Boolean) of object;
  TOnAfterDownloadEvent = procedure(Url: string; str: TStream) of object;

  TCustomDownloadEngine = class(TComponent)
  private
    FOnAfterDownload: TOnAfterDownloadEvent;
    FOnBeforeDownload: TOnBeforeDownloadEvent;
  protected
    procedure DoDownloadFile(const Url: string; str: TStream); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DownloadFile(const Url: string; str: TStream); virtual;
  published
    property OnBeforeDownload: TOnBeforeDownloadEvent read FOnBeforeDownload
      write FOnBeforeDownload;
    property OnAfterDownload: TOnAfterDownloadEvent read FOnAfterDownload
      write FOnAfterDownload;
  end;

  { TCustomGeolocationEngine }

  TCustomGeolocationEngine = class(TComponent)
  protected
    FDownloadEngine: TCustomDownloadEngine;
    function DoSearch: TRealPoint; virtual;
  public
    procedure Search(AParent: TMapViewer);
  end;

  { TMapViewer }

  TMapViewer = class(TCustomControl)
  private
    FAutoZoom: Boolean;
    FCache: TStrings;
    FCacheSize: Word;
    FDoubleBuffering: Boolean;
    FDownloadEngine: TCustomDownloadEngine;
    FGeolocationEngine: TCustomGeolocationEngine;
    FMouseDown: Boolean;
    FUseThreads: Boolean;

    FUpdating: Boolean;

    FX: Int64;
    FY: Int64;
    FOffsetX: Int64;
    FOffsetY: Int64;
    FMaxX: Int64;
    FMaxY: Int64;

    FBitmap: TBitmap;

    FOldArea: TArea;
    FVisibleArea: TArea;
    FZoom: Byte;
    FDebug: Boolean;
    FSource: TMapSource;
    FPool: TThreadPool;
    procedure DownloadFile(const Url: string; str: TStream);
    function GetCacheCount: Word;
    procedure PaintRectangle(AX, AY, X, Y, Z: Int64);
    procedure RepaintMap(X, Y: Integer; Cached: Boolean = False); overload;
    procedure RepaintMap(Cached: Boolean); overload;
    procedure SetAutoZoom(const AValue: Boolean);
    procedure SetCacheSize(const AValue: Word);
    procedure SetCenterLongLat(const AValue: TRealPoint);
    procedure SetDownloadEngine(const AValue: TCustomDownloadEngine);
    procedure SetZoom(const Value: Byte);
    procedure SetDebug(const Value: Boolean);
    procedure DownloadTile(X, Y, Z: Integer; Graphic: TBitmap);
    procedure SetSource(const Value: TMapSource);
    procedure AddToCache(url: string; stream: TStream); overload;
    procedure AddToCache(source: TMapSource; X, Y, Z: Int64; stream: TStream); overload;
    function GetFromCache(url: string; stream: TStream): Boolean; overload;
    function GetFromCache(source: TMapSource; X, Y, Z: Int64; bitmap: TBitmap): Boolean; overload;
    procedure ClearCache;
  protected
    function GetLongLat(X, Y, Z: Integer): TRealArea;
    function GetPixelXY(X, Y, Z: Integer): TArea;
    procedure MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure DblClick; override;
   // procedure DoOnResize; override;
    procedure Paint; override;

    function GetCenterLongLat: TRealPoint;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure BeginUpdate;
    procedure EndUpdate;

    function GetMouseMapTile(X, Y: Integer): TIntPoint;
    function GetMouseMapPixel(X, Y: Integer): TIntPoint;
    function GetMouseMapLongLat(X, Y: Integer): TRealPoint;

    procedure Geolocate;
    procedure Center;

    property CenterLongLat: TRealPoint read GetCenterLongLat write SetCenterLongLat;
    property CacheCount: Word read GetCacheCount;
  published
    property AutoZoom: Boolean read FAutoZoom write SetAutoZoom;
    property Zoom: Byte read FZoom write SetZoom;
    property Debug: Boolean read FDebug write SetDebug;
    property Source: TMapSource read FSource write SetSource default msGoogleNormal;
    property CacheSize: Word read FCacheSize write SetCacheSize default 100;
    property UseThreads: Boolean read FUseThreads write FUseThreads;
    property DownloadEngine: TCustomDownloadEngine read FDownloadEngine write SetDownloadEngine;
    property GeolocationEngine: TCustomGeolocationEngine read FGeolocationEngine write FGeolocationEngine;
    property DoubleBuffering: Boolean read FDoubleBuffering write FDoubleBuffering;
    property Align;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
    property OnDblClick;
  end;

  function IsValidPNG(stream: TStream): Boolean;
  function IsValidJPEG(stream: TStream): Boolean;



implementation

uses
  Math, LinarBitmap, JPEG, PNGLoader;

const
  TILE_SIZE = 256;
  EARTH_RADIUS = 6378137;
  MIN_LATITUDE = -85.05112878;
  MAX_LATITUDE = 85.05112878;
  MIN_LONGITUDE = -180;
  MAX_LONGITUDE = 180;

type

  { TTileJob }

  TTileJob = class(TJob)
  private
    FAX: Integer;
    FAY: Integer;
    FBitmap: TBitmap;
    FOwner: TMapViewer;
    FX: Integer;
    FY: Integer;
  public
    procedure Execute; override;
    property Bitmap: TBitmap read FBitmap write FBitmap;
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
    property AX: Integer read FAX write FAX;
    property AY: Integer read FAY write FAY;
    property Owner: TMapViewer read FOwner write FOwner;
  end;

procedure CopyArea(_from: TArea; var _to: TArea);
begin
  _to.left := _from.left;
  _to.bottom := _from.bottom;
  _to.top := _from.top;
  _to.right := _from.right;
end;

function QuadKey(X, Y, Z: Integer): string;
var
  i, d, m: Longword;
begin
  {
    Bing Maps Tile System
    http://msdn.microsoft.com/en-us/library/bb259689.aspx
  }
  Result := '';
  for i := Z downto 1 do
  begin
    d := 0;
    m := 1 shl (i - 1);
    if (x and m) <> 0 then
      Inc(d, 1);
    if (y and m) <> 0 then
      Inc(d, 2);
    Result := Result + IntToStr(d);
  end;
end;

function IntPower(X: Int64): Int64; inline;
begin
  Result := 1 shl X;
end;

function IsValidPNG(stream: TStream): Boolean;
var
  s: string;
  y: Int64;
begin
  if Assigned(stream) then
  begin
    SetLength(s, 3);
    y := stream.Position;
    stream.Position := 1;
    stream.Read(s[1], 3);
    stream.Position := y;
    Result := s = 'PNG';
  end
  else
    Result := False;
end;

function IsValidJPEG(stream: TStream): Boolean;
var
  s: string;
  y: Int64;
begin
  if Assigned(stream) then
  begin
    SetLength(s, 4);
    y := stream.Position;
    stream.Position := 6;
    stream.Read(s[1], 4);
    stream.Position := y;
    Result := (s = 'JFIF') or (s = 'Exif');
  end
  else
    Result := False;
end;

{ TCustomGeolocationEngine }

function TCustomGeolocationEngine.DoSearch: TRealPoint;
begin
  Result.X := 0;
  Result.Y := 0;
end;

procedure TCustomGeolocationEngine.Search(AParent: TMapViewer);
var
  r: TRealPoint;
begin
  FDownloadEngine := AParent.DownloadEngine;
  r := DoSearch;
  AParent.BeginUpdate;
  AParent.CenterLongLat := r;
  AParent.EndUpdate;
end;

{ TCustomDownloadEngine }

procedure TCustomDownloadEngine.DoDownloadFile(const Url: string; str: TStream
  );
begin

end;

constructor TCustomDownloadEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TCustomDownloadEngine.DownloadFile(const Url: string; str: TStream);
var
  ACanHandle: Boolean;
begin
  if Assigned(FOnBeforeDownload) then
    FOnBeforeDownload(Url, str, ACanHandle)
  else
    ACanHandle := False;

  if not ACanHandle then
    DoDownloadFile(Url, str);

  if Assigned(FOnAfterDownload) then
    FOnAfterDownload(Url, str);

  str.Position := 0;
end;

{ TTileJob }

procedure TTileJob.Execute;
begin
  inherited Execute;
  Owner.PaintRectangle(AX, AY, X, Y, Owner.Zoom);
end;


{ TMapViewer }

procedure TMapViewer.AddToCache(url: string; stream: TStream);
var
  st: TStream;
  o: TObject;
  i: Integer;
begin
  st := TMemoryStream.Create;
  stream.Position := 0;
  st.CopyFrom(stream, stream.Size);
  FCache.InsertObject(0, url, st);
  if FCache.Count - 1 >= FCacheSize then
  begin
    for i := FCache.Count - 1 downto FCacheSize do
    begin
      o := TObject(FCache.Objects[i]);
      o.Free;
      FCache.Delete(i);
    end;
  end;
end;

procedure TMapViewer.DownloadFile(const Url: string; str: TStream);
begin
  if Assigned(FDownloadEngine) then
    FDownloadEngine.DownloadFile(Url, str);
end;

procedure TMapViewer.AddToCache(source: TMapSource; X, Y, Z: Int64;
  stream: TStream);
begin
  AddToCache(Format('/%d-%d-%d-%d', [Integer(Source), X, Y, Z]), stream);
end;

function TMapViewer.GetFromCache(url: string; stream: TStream): Boolean;
var
  i: Integer;
  st: TStream;
begin
  i := FCache.IndexOf(url);
  Result := i > -1;
  if Result then
  begin
    st := TStream(FCache.Objects[i]);
    st.Position := 0;
    stream.CopyFrom(st, st.Size);
    stream.Position := 0;
  end;
end;

function TMapViewer.GetFromCache(source: TMapSource; X, Y, Z: Int64;
  bitmap: TBitmap): Boolean;
var
  s: string;
  st: TStream;
  i: Integer;
begin
  s := Format('/%d-%d-%d-%d', [Integer(source), X, Y, Z]);
  i := FCache.IndexOf(s);
  Result := i > -1;
  if Result then
  begin
    st := TStream(FCache.Objects[i]);
    st.Position := 0;
    bitmap.LoadFromStream(st);
  end;
end;

procedure TMapViewer.ClearCache;
var
  i: Integer;
  x: TObject;
begin
  for i := 0 to FCache.Count - 1 do
  begin
    x := FCache.Objects[i];
    x.Free;
  end;
  FCache.Clear;
end;

function TMapViewer.GetLongLat(X, Y, Z: Integer): TRealArea;
var
  n: Extended;
begin
  {
    http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames

    == lon/lat to tile numbers ==
    n = 2 ^ zoom
    xtile = ((lon_deg + 180) / 360) * n
    ytile = (1 - (log(tan(lat_rad) + sec(lat_rad)) / π)) / 2 * n

    == tile numbers to lon/lat ==
    n = 2 ^ zoom
    lon_deg = xtile / n * 360.0 - 180.0
    lat_rad = arctan(sinh(π * (1 - 2 * ytile / n)))
    lat_deg = lat_rad * 180.0 / π
  }

  n := IntPower(zoom);
  Result.left := x / n * 360.0 - 180.0;
  Result.right := Result.left + (360.0 / n);

  Result.top := radtodeg(arctan(sinh(PI * (1 - 2 * Y / n))));
  Result.bottom := radtodeg(arctan(sinh(PI * (1 - 2 * (Y+1) / n))));
end;

function TMapViewer.GetPixelXY(X, Y, Z: Integer): TArea;
begin
  Result.left := X * TILE_SIZE;
  Result.right := (X + 1) * TILE_SIZE - 1;

  Result.top := Y * TILE_SIZE;
  Result.bottom := (Y + 1) * TILE_SIZE - 1;
end;

procedure TMapViewer.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  FMouseDown := True;
  FOffsetX := X;
  FOffsetY := Y;
end;

constructor TMapViewer.Create(AOwner: TComponent);
begin
  inherited;
  FUseThreads := False;

  FPool := TThreadPool.Create;
  FBitmap := TBitmap.Create;

  FCache := TStringList.Create;
  FSource := msGoogleNormal;

  Height := TILE_SIZE;
  Width := TILE_SIZE;

  FCacheSize := 100;
  FX := 0;
  FY := 0;
  FZoom := 0;
  FAutoZoom := True;
end;

destructor TMapViewer.Destroy;
begin
  FPool.Terminate;
  ClearCache;
  FBitmap.Free;
  FCache.Free;
  FPool.Free;
  inherited;
end;

procedure TMapViewer.BeginUpdate;
begin
  FUpdating := True;
end;

procedure TMapViewer.EndUpdate;
begin
  FUpdating := False;
  RepaintMap(False);
end;

function TMapViewer.GetMouseMapTile(X, Y: Integer): TIntPoint;
var
  z: Int64;
begin
  z := IntPower(FZoom) - 1;
  Result := GetMouseMapPixel(X, Y);
  Result.X := Result.X div TILE_SIZE;
  Result.Y := Result.Y div TILE_SIZE;

  if Result.X > z then
    Result.X := z
  else
  if Result.X < 0 then
    Result.X := 0;

  if Result.Y > z then
    Result.Y := z
  else
  if Result.Y < 0 then
    Result.Y := 0;
end;

function TMapViewer.GetMouseMapPixel(X, Y: Integer): TIntPoint;
var
  i: Int64;
begin
  i := IntPower(FZoom) * TILE_SIZE;
  Result.X := X - FX;
  Result.Y := Y - FY;

  if Result.X < 0 then
    Result.X := 0
  else
  if Result.X > i then
    Result.X := i;

  if Result.Y < 0 then
    Result.Y := 0
  else
  if Result.Y > i then
    Result.Y := i;
end;

function TMapViewer.GetMouseMapLongLat(X, Y: Integer): TRealPoint;
var
  i: TIntPoint;
  tiles: Int64;
  circumference: Int64;
  lat: Extended;
  shift: Extended;
  res: Extended;
begin
  i := GetMouseMapPixel(X, Y);

  tiles := IntPower(FZoom);
  circumference := tiles * TILE_SIZE;
  Result.X := ((i.X * 360.0) / circumference) - 180.0;

  res := (2 * pi * EARTH_RADIUS) / circumference;
  shift := 2 * pi * EARTH_RADIUS / 2.0;
  lat := ((i.Y * res - shift) / shift) * 180.0;

  lat := radtodeg (2 * arctan( exp( lat * pi / 180.0)) - pi / 2.0);
  Result.Y := -lat;

  if Result.Y > MAX_LATITUDE then
    Result.Y := MAX_LATITUDE
  else
  if Result.Y < MIN_LATITUDE then
    Result.Y := MIN_LATITUDE;

  if Result.X > MAX_LONGITUDE then
    Result.X := MAX_LONGITUDE
  else
  if Result.X < MIN_LONGITUDE then
    Result.X := MIN_LONGITUDE;
end;

procedure TMapViewer.Geolocate;
begin
  if Assigned(FGeolocationEngine) then
    FGeolocationEngine.Search(Self);
end;

procedure TMapViewer.Center;
var
  i: TRealPoint;
begin
  i.X := 0;
  i.Y := 0;
  SetCenterLongLat(i);
  RepaintMap(0, 0, False);
end;

procedure TMapViewer.PaintRectangle(AX, AY, X, Y, Z: Int64);
var
  XD, YD: Int64;
  XB, YB: Int64;
  maxOfZ: Int64;
  areaR: TRealArea;
  areaP: TArea;
  textheight: Integer;
  image: TBitmap;
  s: string;
  //rect: Trect;
begin
  maxOfZ := IntPower(Z);
  if not ((Z = 0) and (X = 0) and (Y = 0)) then
    if (X < 0) or (Y < 0) or (X > maxOfZ - 1) or (Y > maxOfZ - 1) then
      Exit;

  XD := X * TILE_SIZE;
  YD := Y * TILE_SIZE;
  XB := FX + AX + XD; // begin of X
  YB := FY + AY + YD; // begin of Y

  image := TBitmap.Create;
  try
    if (FSource <> msNone) and (not (csDesigning in ComponentState)) then
    begin
      DownloadTile(X, Y, Z, image);
    end;

    if FDebug or (csDesigning in ComponentState) then
    begin
      //image.BeginUpdate(True);
      try
        if (image.Height = 0) or (image.Width = 0) then
        begin
          image.Height := TILE_SIZE;
          image.Width := TILE_SIZE;
          image.Canvas.Brush.Color := clWhite;
          image.Canvas.FillRect(rect(0,0, TILE_SIZE, TILE_SIZE));
        end;

        image.Canvas.Brush.Color := clGray;
        image.Canvas.Brush.Style := bsSolid;
        image.Canvas.FrameRect(rect(0, 0, TILE_SIZE, TILE_SIZE));
        image.Canvas.Brush.Style := bsClear;
        areaR := GetLongLat(X, Y, Z);
        areaP := GetPixelXY(X, Y, Z);
        textheight := image.Canvas.TextHeight('yA');

        // x, y, z
        s := Format('X: %d Y: %d Z: %d', [X, Y, Z]);
        image.Canvas.TextOut(((TILE_SIZE - image.Canvas.TextWidth(s)) div 2), 3+textheight*4, s);
        s := 'QuadKey: ' + QuadKey(X, Y, Z);
        image.Canvas.TextOut(((TILE_SIZE - image.Canvas.TextWidth(s)) div 2), 3+textheight*5, s);

        // long
        s := Format('long: %g', [areaR.left]);
        image.Canvas.TextOut(3, TILE_SIZE div 2, s);
        s := Format('long: %g', [areaR.right]);
        image.Canvas.TextOut(TILE_SIZE-image.Canvas.TextWidth(s) - 3, TILE_SIZE div 2, s);

        // lat
        s := Format('lat: %g', [areaR.top]);
        image.Canvas.TextOut(((TILE_SIZE - image.Canvas.TextWidth(s)) div 2) + 3, 3, s);
        s := Format('lat: %g', [areaR.bottom]);
        image.Canvas.TextOut(((TILE_SIZE - image.Canvas.TextWidth(s)) div 2) + 3, TILE_SIZE - textheight - 3, s);

        // pixX
        s := Format('X = %d', [areaP.left]);
        image.Canvas.TextOut(3, textheight + TILE_SIZE div 2, s);
        s := Format('X = %d', [areaP.right]);
        image.Canvas.TextOut(TILE_SIZE-image.Canvas.TextWidth(s) - 3, textheight + TILE_SIZE div 2, s);

        // pixY
        s := Format('Y = %d', [areaP.top]);
        image.Canvas.TextOut(((TILE_SIZE - image.Canvas.TextWidth(s)) div 2) + 3, textheight + 3, s);
        s := Format('Y = %d', [areaP.bottom]);
        image.Canvas.TextOut(((TILE_SIZE - image.Canvas.TextWidth(s)) div 2) + 3, TILE_SIZE - 2 * textheight - 3, s);

        image.Canvas.Brush.Color := clWhite;
      finally
        //image.EndUpdate;
      end;
    end;

    if FUseThreads then
    begin
      FPool.CriticalSection.Enter;
      //FBitmap.BeginUpdate(True);
      try
        FBitmap.Canvas.Draw(XB, YB, image);
      finally
        //FBitmap.EndUpdate;
        FPool.CriticalSection.Leave;
      end;
    end
    else
    begin
      //FBitmap.BeginUpdate(True);
      try
        FBitmap.Canvas.Draw(XB, YB, image);
      finally
        //FBitmap.EndUpdate;
      end;
    end;
  finally
    image.Free;
  end;
end;

function TMapViewer.GetCacheCount: Word;
begin
  Result := FCache.Count;
end;

procedure TMapViewer.DownloadTile(X, Y, Z: Integer; Graphic: TBitmap);

  function CalcPixels(img: TBitmap{TPNGGraphic}{TPortableNetworkGraphic}): Integer;
  // fix bug when drawing completly transparent png
  var
    i, j: Integer;
  begin
    Result := 0;
    for i := 0 to img.Width - 1 do
      for j := 0 to img.Height - 1 do
        if img.canvas.Pixels[i, j] <> 0 then
        begin
          Inc(Result);
          Break;
        end;
  end;

  function YahooY(Y: Integer): Integer;
  begin
    Result := - (Y - IntPower(Z) div 2) - 1;
  end;

var
  stream: TMemoryStream;
  img: TGraphic;
  url: TStrings;
  i: Integer;
  ValidCount: Integer;
begin
  if not GetFromCache(FSource, X, Y, Z, Graphic) then
  begin
    url := TStringList.Create;
    try
      url.Clear;

      {$region 'create url list'}
      case FSource of
        msNone: ;
        msGoogleNormal:
          url.Add(Format('http://mt%d.google.com/vt/lyrs=m@145&v=w2.104&x=%d&y=%d&z=%d', [Random(4), X, Y, Z]));
        msGoogleSatellite:
          url.Add(Format('http://khm%d.google.com/kh/v=82&x=%d&y=%d&z=%d&s=Ga', [Random(4), X, Y, Z]));
        msGoogleHybrid:
          begin
            url.Add(Format('http://khm%d.google.com/kh/v=82&x=%d&y=%d&z=%d&s=Ga', [Random(4), X, Y, Z]));
            url.Add(Format('http://mt%d.google.com/vt/lyrs=h@145&v=w2.104&x=%d&y=%d&z=%d', [Random(4), X, Y, Z]));
          end;
        msGooglePhysical:
          url.Add(Format('http://mt%d.google.com/vt/lyrs=t@145&v=w2.104&x=%d&y=%d&z=%d', [Random(4), X, Y, Z]));
        msGooglePhysicalHybrid:
          begin
            url.Add(Format('http://mt%d.google.com/vt/lyrs=t@145&v=w2.104&x=%d&y=%d&z=%d', [Random(4), X, Y, Z]));
            url.Add(Format('http://mt%d.google.com/vt/lyrs=h@145&v=w2.104&x=%d&y=%d&z=%d', [Random(4), X, Y, Z]));
          end;
        msOpenStreetMapMapnik:
          url.Add(Format('http://%s.tile.openstreetmap.org/%d/%d/%d.png', [Char(Ord('a')+Random(3)), Z, X, Y]));
        msOpenStreetMapOsmarender:
          url.Add(Format('http://%s.tah.openstreetmap.org/Tiles/tile/%d/%d/%d.png', [Char(Ord('a')+Random(3)), Z, X, Y]));
        msOpenCycleMap:
          url.Add(Format('http://%s.tile.opencyclemap.org/cycle/%d/%d/%d.png', [Char(Ord('a')+Random(3)), Z, X, Y]));
        msVirtualEarthBing:
          url.Add(Format('http://ecn.t%d.tiles.virtualearth.net/tiles/r%s?g=671&mkt=en-us&lbl=l1&stl=h&shading=hill', [Random(8), QuadKey(X, Y, Z)]));
        msVirtualEarthRoad:
          url.Add(Format('http://r%d.ortho.tiles.virtualearth.net/tiles/r%s.png?g=72&shading=hill', [Random(4), QuadKey(X, Y, Z)]));
        msVirtualEarthAerial:
          url.Add(Format('http://a%d.ortho.tiles.virtualearth.net/tiles/a%s.jpg?g=72&shading=hill', [Random(4), QuadKey(X, Y, Z)]));
        msVirtualEarthHybrid:
          url.Add(Format('http://h%d.ortho.tiles.virtualearth.net/tiles/h%s.jpg?g=72&shading=hill', [Random(4), QuadKey(X, Y, Z)]));
        msYahooNormal:
          url.Add(Format('http://maps%d.yimg.com/hx/tl?b=1&v=4.3&.intl=en&x=%d&y=%d&z=%d&r=1', [Random(3)+1, X, YahooY(Y), Z+1]));
        msYahooSatellite:
          url.Add(Format('http://maps%d.yimg.com/ae/ximg?v=1.9&t=a&s=256&.intl=en&x=%d&y=%d&z=%d&r=1', [Random(3)+1, X, YahooY(Y), Z+1]));
        msYahooHybrid:
          begin
            url.Add(Format('http://maps%d.yimg.com/ae/ximg?v=1.9&t=a&s=256&.intl=en&x=%d&y=%d&z=%d&r=1', [Random(3)+1, X, YahooY(Y), Z+1]));
            url.Add(Format('http://maps%d.yimg.com/hx/tl?b=1&v=4.3&t=h&.intl=en&x=%d&y=%d&z=%d&r=1', [Random(3)+1, X, YahooY(Y), Z+1]));
          end;
        msOviNormal:
          url.Add(Format('http://%s.maptile.maps.svc.ovi.com/maptiler/v2/maptile/newest/normal.day/%d/%d/%d/256/png8', [Char(Ord('a')+Random(5)), Z, X, Y]));
        msOviSatellite:
          url.Add(Format('http://%s.maptile.maps.svc.ovi.com/maptiler/v2/maptile/newest/satellite.day/%d/%d/%d/256/png8', [Char(Ord('a')+Random(5)), Z, X, Y]));
        msOviHybrid:
          url.Add(Format('http://%s.maptile.maps.svc.ovi.com/maptiler/v2/maptile/newest/hybrid.day/%d/%d/%d/256/png8', [Char(Ord('a')+Random(5)), Z, X, Y]));
        msOviPhysical:
          url.Add(Format('http://%s.maptile.maps.svc.ovi.com/maptiler/v2/maptile/newest/terrain.day/%d/%d/%d/256/png8', [Char(Ord('a')+Random(5)), Z, X, Y]));
      end;
      {$endregion}

      if (X = 0) and (Y = 0) and (Z = 0) and (FSource in [msYahooHybrid, msYahooSatellite]) then
        url.Clear;

      Graphic.Height := TILE_SIZE;
      Graphic.Width := TILE_SIZE;

      ValidCount := 0;

      stream := TMemoryStream.Create;
      try
        for i := 0 to url.Count - 1 do
        begin
          DownloadFile(url[i], stream);

          if IsValidJPEG(stream) then
          begin
            img := TJPEGImage.Create;
            img.LoadFromStream(stream);
          end
          else
          if IsValidPNG(stream) then
          begin
            img := TPNGGraphic{TLinearGraphic}{TPortableNetworkGraphic}.Create;
            img.LoadFromStream(stream);
          end
          else
            img := nil;

          if Assigned(img) then
          begin
            Inc(ValidCount);
            Graphic.Canvas.Brush.Style := bsClear;
            if (img is TPNGGraphic{TLinearGraphic}{TPortableNetworkGraphic}) and (FSource in [msGoogleHybrid, msGooglePhysicalHybrid, msYahooHybrid]) then
            begin // fix bug when drawing completly transparent png
              if CalcPixels(TBitmap{TPortableNetworkGraphic}(img)) > 0 then
                Graphic.Canvas.Draw(0, 0, img);
            end
            else
              Graphic.Canvas.Draw(0, 0, img);
            img.Free;
          end;
        end;

        stream.Clear;
        Graphic.SaveToStream(stream);
        stream.Position := 0;

        if ValidCount > 0 then
          AddToCache(FSource, X, Y, Z, stream);
      finally
        stream.Free;
      end;

    finally
      url.Free;
    end;
  end;
end;

procedure TMapViewer.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
begin
  inherited;
  if FMouseDown then
  begin
    // refresh when dragging
    if (FOldArea.left <> FVisibleArea.left) or
       (FOldArea.top <> FVisibleArea.top) then
    begin
      MouseUp(mbLeft, Shift, X, Y);
      CopyArea(FVisibleArea, FOldArea);
      MouseDown(mbLeft, Shift, X, Y);
    end
    else
      RepaintMap(X, Y, True);
  end;
end;

procedure TMapViewer.DblClick;
var
  r: TRealPoint;
begin
  inherited DblClick;
  if FAutoZoom then
  begin
    r := GetMouseMapLongLat(FOffsetX, FOffsetY);
    FZoom := FZoom + 1;
    SetCenterLongLat(r);
  end;
end;

{procedure TMapViewer.DoOnResize;
begin
  inherited DoOnResize;

  FBitmap.Width := Width;
  FBitmap.Height := Height;
  //FCacheBitmap.Width := Width;
  //FCacheBitmap.Height := Height;

  FMaxX := (Width div TILE_SIZE) + 1;
  FMaxY := (Height div TILE_SIZE) + 1;

  if Parent <> nil then
    RepaintMap(False);
end;}

procedure TMapViewer.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
  Y: Integer);
begin
  inherited;
  RepaintMap(X, Y);
  FX := FX + (X - FOffsetX);
  FY := FY + (Y - FOffsetY);
  CopyArea(FVisibleArea, FOldArea);
  FMouseDown := False;
end;

procedure TMapViewer.RepaintMap(X, Y: Integer; Cached: Boolean);
var
  AX, AY: Integer;
  startX, startY: Integer;
  i, j: Integer;
  job: TTileJob;
  FCacheBitmap: TBitmap;
begin
  if FUpdating then
    Exit;

  AX := X - FOffsetX;
  AY := Y - FOffsetY;

  startX := (-(FX+AX)) div TILE_SIZE;
  startY := (-(FY+AY)) div TILE_SIZE;

  FVisibleArea.left := startX;
  FVisibleArea.right := startX + FMaxX;
  FVisibleArea.top := startY;
  FVisibleArea.bottom := startY + FMaxY;

  if not Cached then
  begin
    FBitmap.Canvas.Brush.Style := bsSolid;
    FBitmap.Canvas.FillRect(ClientRect);

    for i := FVisibleArea.left to FVisibleArea.right do
      for j := FVisibleArea.top to FVisibleArea.bottom do
        if FUseThreads then
        begin
          job := TTileJob.Create;
          job.Owner := Self;
          job.AX := AX;
          job.AY := AY;
          job.X := i;
          job.Y := j;
          FPool.Add(job);
        end
        else
          PaintRectangle(AX, AY, i, j, FZoom);

    if FUseThreads then
      FPool.Execute;

    Canvas.Draw(0, 0, FBitmap);
  end
  else
  begin
    if FDoubleBuffering then
    begin
      FCacheBitmap := TBitmap.Create;
      try
        FCacheBitmap.Width := Width;
        FCacheBitmap.Height := Height;
        FCacheBitmap.Canvas.Brush.Style := bsSolid;
        FCacheBitmap.Canvas.FillRect(ClientRect);
        FCacheBitmap.Canvas.Draw(AX, AY, FBitmap);
        Canvas.Draw(0, 0, FCacheBitmap);
      finally
        FCacheBitmap.Free;
      end;
    end
    else
      Canvas.CopyRect(Rect(AX, AY, AX+Width, AY+Height), FBitmap.Canvas, Rect(0, 0, Width, Height));
  end;
end;

procedure TMapViewer.RepaintMap(Cached: Boolean);
begin
  FOffsetX := 0;
  FOffsetY := 0;
  RepaintMap(0, 0, Cached);
end;

procedure TMapViewer.SetAutoZoom(const AValue: Boolean);
begin
  if FAutoZoom = AValue then
    Exit;

  FAutoZoom := AValue;
end;

procedure TMapViewer.SetCacheSize(const AValue: Word);
begin
  if FCacheSize = AValue then
    Exit;

  FCacheSize := AValue;
end;

procedure TMapViewer.SetCenterLongLat(const AValue: TRealPoint);
var
  shift: Extended;
  mx, my: Extended;
  res: Extended;
  px, py: Int64;
begin
  shift := 2 * pi * EARTH_RADIUS / 2.0;
  mx := AValue.X * shift / 180.0;
  my := ln( tan((90 - AValue.Y) * pi / 360.0 )) / (pi / 180.0);

  my := my * shift / 180.0;

  res := (2 * pi * EARTH_RADIUS) / (TILE_SIZE * IntPower(FZoom));
  px := Round((mx + shift) / res);
  py := Round((my + shift) / res);

  FX := Width div 2 - px;
  FY := Height div 2 - py;
end;

procedure TMapViewer.SetDownloadEngine(const AValue: TCustomDownloadEngine);
begin
  if FDownloadEngine <> AValue then
    FDownloadEngine := AValue;
end;

procedure TMapViewer.Paint;
begin
  inherited Paint;
  RepaintMap(True);
end;

function TMapViewer.GetCenterLongLat: TRealPoint;
begin
  Result := GetMouseMapLongLat(Width div 2, Height div 2);
end;

procedure TMapViewer.SetDebug(const Value: Boolean);
begin
  FDebug := Value;
  RepaintMap(False);
end;

procedure TMapViewer.SetSource(const Value: TMapSource);
begin
  FSource := Value;
  RepaintMap(False);
end;

procedure TMapViewer.SetZoom(const Value: Byte);
var
  c: TRealPoint;
begin
  c := CenterLongLat;
  FZoom := Value;
  SetCenterLongLat(c);
  RepaintMap(False);
end;

end.
