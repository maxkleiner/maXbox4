{ Map Viewer Download Engine Win32

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
unit kcMapViewerDEWin32;

{$mode objfpc}{$H+}

interface

uses
  kcMapViewer, Classes, wininet;

type

  { TMVDEWind32 }

  TMVDEWin32 = class(TCustomDownloadEngine)
  private
    FNetHandle: Pointer;
  protected
    procedure DoDownloadFile(const Url: string; str: TStream); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

constructor TMVDEWin32.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNetHandle := InternetOpen('kcMapViewer', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
end;

destructor TMVDEWin32.Destroy;
begin
  if Assigned(FNetHandle) then
    InternetCloseHandle(FNetHandle);
  inherited Destroy;
end;

procedure TMVDEWin32.DoDownloadFile(const Url: string; str: TStream);
var
  UrlHandle: HINTERNET;
  Buffer: array[0..8192] of Char;
  BytesRead: dWord;
begin
  inherited;

  BytesRead := 0;
  str.Position := 0;
  str.Size := 0;

  if Assigned(FNetHandle) then
  begin
    UrlHandle := InternetOpenUrl(FNetHandle, {$IFDEF WINCE}PWideChar{$ELSE}PChar{$ENDIF}(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);

    if Assigned(UrlHandle) then
    begin
      FillChar(Buffer, SizeOf(Buffer), 0);
      repeat
        FillChar(Buffer, SizeOf(Buffer), 0);
        {$IFDEF WINCE}
        InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), @BytesRead);
        {$ELSE}
        InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
        {$ENDIF}
        if BytesRead > 0 then
          str.Write(Buffer, BytesRead);
      until BytesRead = 0;
      InternetCloseHandle(UrlHandle);
    end;
  end;

  str.Position := 0;
end;          

end.
