{ Map Viewer Geolocation Engine for geonames.org

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
unit kcMapViewerGLGeoNames;

interface

uses
  SysUtils, Classes, kcMapViewer;

type

  { TMVGLGeoNames }

  TMVGLGeoNames = class(TCustomGeolocationEngine)
  private
    FLocationName: string;
  protected
    function DoSearch: TRealPoint; override;
  published
    property LocationName: string read FLocationName write FLocationName;
  end;

implementation

function CleanLocationName(x: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(x) do
  begin
    if x[i] in ['A'..'Z', 'a'..'z', '0'..'9'] then
      Result := Result + x[i]
    else
      Result := Result + '+'
  end;
end;

{ TMVGLGeoNames }

function TMVGLGeoNames.DoSearch: TRealPoint;
const
  LAT_ID = '<span class="latitude">';
  LONG_ID = '<span class="longitude">';
var
  s: string;

  function gs(id: string): string;
  var
    i: Integer;
    ln: Integer;
  begin
    Result := '';
    ln := Length(s);
    i := Pos(id, s) + Length(id);
    while (s[i] <> '<') and (i < ln) do
    begin
      if s[i] = '.' then
        Result := Result + DecimalSeparator
      else
        Result := Result + s[i];
      Inc(i);
    end;
  end;

var
  m: TMemoryStream;
begin
  //inherited;

  m := TMemoryStream.Create;
  try
    FDownloadEngine.DownloadFile('http://geonames.org/search.html?q='+
      CleanLocationName(FLocationName), m);
    m.Position := 0;
    SetLength(s, m.Size);
    m.Read(s[1], m.Size);
  finally
    m.Free;
  end;

  Result.X := StrToFloatDef(gs(LONG_ID), 0.0);
  Result.Y := StrToFloatDef(gs(LAT_ID), 0.0);
end;

end.
