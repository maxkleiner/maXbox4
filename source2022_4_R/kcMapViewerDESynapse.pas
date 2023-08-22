{ Map Viewer Download Engine Synapse

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
unit kcMapViewerDESynapse;

//{$mode objfpc}{$H+}

interface

uses
  kcMapViewer, SysUtils, Classes, httpsend;

type

  { TMVDESynapse }

  TMVDESynapse = class(TCustomDownloadEngine)
  private
    FProxyHost: string;
    FProxyPassword: string;
    FProxyPort: Integer;
    FProxyUsername: string;
    FUseProxy: Boolean;
  Public  //change to mX
    procedure DoDownloadFile(const Url: string; str: TStream); override;
  published
    property UseProxy: Boolean read FUseProxy write FUseProxy;
    property ProxyHost: string read FProxyHost write FProxyHost;
    property ProxyPort: Integer read FProxyPort write FProxyPort;
    property ProxyUsername: string read FProxyUsername write FProxyUsername;
    property ProxyPassword: string read FProxyPassword write FProxyPassword;
  end;

implementation

{ TMVDESynapse }

procedure TMVDESynapse.DoDownloadFile(const Url: string; str: TStream);
var
  FHttp: THTTPSend;
begin
  inherited DownloadFile(Url, str);
  FHttp := THTTPSend.Create;
  try
    if FUseProxy then
    begin
      FHTTP.ProxyHost := FProxyHost;
      FHTTP.ProxyPort := IntToStr(FProxyPort);
      FHTTP.ProxyUser := FProxyUsername;
      FHTTP.ProxyPass := FProxyPassword;
    end;

    if FHTTP.HTTPMethod('GET', Url) then
    begin
      str.Seek(0, soFromBeginning);
      str.CopyFrom(FHTTP.Document, 0);
      str.Position := 0;
    end;
  finally
    FHttp.Free;
  end;
end;

end.
