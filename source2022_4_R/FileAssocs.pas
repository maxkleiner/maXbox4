{
    This file is part of Dev-C++
    Copyright (c) 2004 Bloodshed Software

    Dev-C++ is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Dev-C++ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dev-C++; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit FileAssocs;

interface

uses
{$IFDEF WIN32}
  Windows, SysUtils, Classes, Forms, Registry, ShlObj, Graphics;
{$ENDIF}
{$IFDEF LINUX}
  SysUtils, Classes, QForms;
{$ENDIF}

procedure CheckAssociations;
procedure Associate(Index: integer);
procedure UnAssociate(Index: integer);
function IsAssociated(Index: integer): boolean;
function CheckFiletype(const extension, filetype, description,
  verb, serverapp: string): boolean;

procedure RegisterFiletype(const extension, filetype, description, verb, serverapp, IcoNum: string); 
procedure RegisterDDEServer(const filetype, verb, topic, servername, macro: string); 
procedure RefreshIcons;



function GetShadeColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
function MergColor(Colors: Array of TColor): TColor;
function NewColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
procedure DimBitmap(ABitmap: TBitmap; Value: integer);

function GrayColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
function GetInverseColor(AColor: TColor): TColor;

procedure GrayBitmap(ABitmap: TBitmap; Value: integer);
procedure DrawBitmapShadow(B: TBitmap; ACanvas: TCanvas; X, Y: integer;
  ShadowColor: TColor);
procedure DrawCheckMark(ACanvas: TCanvas; X, Y: integer);

procedure GetSystemMenuFont(Font: TFont);



var
  DDETopic: string;

const
  // if you change anything here, update devcfg.pas, specifically devData...
  // and update MustAssociate(), Associate() and UnAssociate() below
  AssociationsCount = 7;
  // field 1 is the extension (no dot)
  // field 2 is the description
  // field 3 is the icon number
  // field 4 is "" (empty) if you want DDE services for this extension
  // (if not empty, launches a new instance - nice for .dev files ;)
  Associations: array[0..6, 0..3] of string = (
    ('c', 'C Source File', '4', ''),
    ('cpp', 'C++ Source File', '5', ''),
    ('h', 'C Header File', '6', ''),
    ('hpp', 'C++ Header File', '7', ''),
    ('dev', 'Dev-C++ Project File', '3', 'xxx'),
    ('rc', 'Resource Source File', '8', ''),
    ('template', 'Dev-C++ Template File', '1', ''));

implementation

//uses
  //devcfg;


function GetShadeColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
var
  r, g, b: integer;

begin
  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;

  r := (r - value);
  if r < 0 then r := 0;
  if r > 255 then r := 255;

  g := (g - value) + 2;
  if g < 0 then g := 0;
  if g > 255 then g := 255;

  b := (b - value);
  if b < 0 then b := 0;
  if b > 255 then b := 255;

  //Result := Windows.GetNearestColor(ACanvas.Handle, RGB(r, g, b));
  Result := RGB(r, g, b);
end;

function MergColor(Colors: Array of TColor): TColor;
var
  r, g, b, i: integer;
  clr: TColor;
begin
  r := 0; g:= 0; b:= 0;

  for i := 0 to High(Colors) do
  begin

    clr := ColorToRGB(Colors[i]);
    r := r + (Clr and $000000FF) div High(Colors);
    g := g + ((Clr and $0000FF00) shr 8) div High(Colors);
    b := b + ((Clr and $00FF0000) shr 16) div High(Colors);
  end;

  Result := RGB(r, g, b);

end;
function NewColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor;
var
  r, g, b: integer;

begin
  if Value > 100 then Value := 100;
  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;


  r := r + Round((255 - r) * (value / 100));
  g := g + Round((255 - g) * (value / 100));
  b := b + Round((255 - b) * (value / 100));

  //Result := Windows.GetNearestColor(ACanvas.Handle, RGB(r, g, b));
  Result := RGB(r, g, b);

end;



function GetInverseColor(AColor: TColor): TColor;
begin
  Result := ColorToRGB(AColor) xor $FFFFFF;
end;

function GrayColor(ACanvas: TCanvas; Clr: TColor; Value: integer): TColor;
var
  r, g, b, avg: integer;

begin

  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;

  Avg := (r + g + b) div 3;
  Avg := Avg + Value;

  if Avg > 240 then Avg := 240;
  //if ACanvas <> nil then
  //  Result := Windows.GetNearestColor (ACanvas.Handle,RGB(Avg, avg, avg));
   Result := RGB(Avg, avg, avg);
end;

  


  procedure GrayBitmap(ABitmap: TBitmap; Value: integer);
var
  x, y: integer;
  LastColor1, LastColor2, Color: TColor;
begin
  LastColor1 := 0;
  LastColor2 := 0;

  for y := 0 to ABitmap.Height do
    for x := 0 to ABitmap.Width do begin
      Color := ABitmap.Canvas.Pixels[x, y];
      if Color = LastColor1 then
        ABitmap.Canvas.Pixels[x, y] := LastColor2
      else
      begin
        LastColor2 := GrayColor(ABitmap.Canvas , Color, Value);
        ABitmap.Canvas.Pixels[x, y] := LastColor2;
        LastColor1 := Color;
      end;
    end;
end;


procedure DimBitmap(ABitmap: TBitmap; Value: integer);
var
 x, y: integer;
 LastColor1, LastColor2, Color: TColor;
begin
 if Value > 100 then Value := 100;
 LastColor1 := -1;
 LastColor2 := -1;
  for y := 0 to ABitmap.Height - 1 do
   for x := 0 to ABitmap.Width - 1 do
   begin
     Color := ABitmap.Canvas.Pixels[x, y];
     if Color = LastColor1 then
       ABitmap.Canvas.Pixels[x, y] := LastColor2
     else
     begin
       LastColor2 := NewColor(ABitmap.Canvas, Color, Value);
       ABitmap.Canvas.Pixels[x, y] := LastColor2;
       LastColor1 := Color;
     end;
   end;
end;

// LIne 2647
{Modified  by felix@unidreamtech.com}
{works  fine for 24 bit color
procedure DimBitmap(ABitmap: TBitmap; Value: integer);
var
  Pixel: PRGBTriple;
  w, h: Integer;
  x, y, c1, c2: Integer;
begin
  ABitmap.PixelFormat := pf24Bit;
  w := ABitmap.Width;
  h := ABitmap.Height;

  c1 := Value * 255;
  c2 := 100 - Value;
  for y := 0 to h - 1 do
  begin
    Pixel := ABitmap.ScanLine[y];
    for x := 0 to w - 1 do
    begin
      Pixel^.rgbtRed := ((c2 * Pixel^.rgbtRed) + c1) div 100;
      Pixel^.rgbtGreen := ((c2 * Pixel^.rgbtGreen) + c1) div 100;
      Pixel^.rgbtBlue := ((c2 * Pixel^.rgbtBlue) + c1) div 100;
      Inc(Pixel);
    end;
  end;
end;
}
procedure DrawArrow(ACanvas: TCanvas; X, Y: integer);
begin
  ACanvas.MoveTo(X, Y);
  ACanvas.LineTo(X + 5, Y);

  ACanvas.MoveTo(X + 1, Y + 1);
  ACanvas.LineTo(X + 4, Y);

  ACanvas.MoveTo(X + 2, Y + 2);
  ACanvas.LineTo(X + 3, Y);

end;

procedure DrawBitmapShadow(B: TBitmap; ACanvas: TCanvas; X, Y: integer;
 ShadowColor: TColor);
var
 BX, BY: integer;
 TransparentColor: TColor;
begin
 TransparentColor := B.Canvas.Pixels[0, B.Height - 1];
 for BY := 0 to B.Height - 1 do
   for BX := 0 to B.Width - 1 do
   begin
     if B.Canvas.Pixels[BX, BY] <> TransparentColor then
       ACanvas.Pixels[X + BX, Y + BY] := ShadowColor;
   end;
end;

procedure DrawCheckMark(ACanvas: TCanvas; X, Y: integer);
begin
 Inc(X, 2);
 Dec(Y, 3);
 ACanvas.MoveTo(X , Y - 2);
 ACanvas.LineTo(X + 2, Y );
  ACanvas.LineTo(X + 7, Y - 5);

  ACanvas.MoveTo(X , Y - 3);
  ACanvas.LineTo(X + 2, Y - 1);
  ACanvas.LineTo(X + 7, Y - 6);

  ACanvas.MoveTo(X , Y - 4);
  ACanvas.LineTo(X + 2, Y - 2);
  ACanvas.LineTo(X + 7, Y - 7);
end;


procedure GetSystemMenuFont(Font: TFont);
var
  FNonCLientMetrics: TNonCLientMetrics;
begin
  FNonCLientMetrics.cbSize := Sizeof(TNonCLientMetrics);
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @FNonCLientMetrics,0) then
  begin
    Font.Handle := CreateFontIndirect(FNonCLientMetrics.lfMenuFont);
    Font.Color := clMenuText;
  end;
end;



var
  Associated: array[0..AssociationsCount - 1] of boolean;

// forward decls
//procedure RegisterFiletype(const extension, filetype, description, verb, serverapp, IcoNum: string); forward;
//procedure RegisterDDEServer(const filetype, verb, topic, servername, macro: string); forward;

procedure RefreshIcons;
begin
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
end;

function IsAssociated(Index: integer): boolean;
begin
  Result := Associated[Index];
end;

function MustAssociate(Index: integer): boolean;
begin
  //case Index of
    {0: Result := devData.AssociateC;
    1: Result := devData.AssociateCpp;
    2: Result := devData.AssociateH;
    3: Result := devData.AssociateHpp;
    4: Result := devData.AssociateDev;
    5: Result := devData.AssociateRc;
    6: Result := devData.AssociateTemplate;}
  //else
    Result := False;
  //end;
end;

procedure UnAssociate(Index: integer);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.Rootkey := HKEY_CLASSES_ROOT;
    if reg.KeyExists('DevCpp.' + Associations[Index, 0]) then begin
      reg.DeleteKey('.' + Associations[Index, 0]);
      reg.DeleteKey('DevCpp.' + Associations[Index, 0]);
    end;
  finally
    reg.free;
  end;
  Associated[Index] := False;
  {case Index of
    0: devData.AssociateC := False;
    1: devData.AssociateCpp := False;
    2: devData.AssociateH := False;
    3: devData.AssociateHpp := False;
    4: devData.AssociateDev := False;
    5: devData.AssociateRc := False;
    6: devData.AssociateTemplate := False;
  end;}
  RefreshIcons;
end;

procedure Associate(Index: integer);
begin
  RegisterFiletype(
    '.' + Associations[Index, 0],
    'DevCpp.' + Associations[Index, 0],
    Associations[Index, 1],
    'open',
    Application.Exename + ' "%1"',
    Associations[Index, 2]);
  if Associations[Index, 3] = '' then
    RegisterDDEServer(
      'DevCpp.' + Associations[Index, 0],
      'open',
      DDETopic,
      Uppercase(ChangeFileExt(ExtractFilename(Application.Exename), EmptyStr)),
      '[Open("%1")]');
  Associated[Index] := True;
  {case Index of
    0: devData.AssociateC := True;
    1: devData.AssociateCpp := True;
    2: devData.AssociateH := True;
    3: devData.AssociateHpp := True;
    4: devData.AssociateDev := True;
    5: devData.AssociateRc := True;
    6: devData.AssociateTemplate := True;
  end;}
  RefreshIcons;
end;

function CheckFiletype(const extension, filetype, description,
  verb, serverapp: string): boolean;
var
  reg: TRegistry;
  keystring: string;
  regdfile: string;
begin
  reg := TRegistry.Create;
  try
    Result := False;
    reg.Rootkey := HKEY_CLASSES_ROOT;
    if not reg.OpenKey(extension, False) then
      Exit;
    reg.CloseKey;
    if not reg.OpenKey(filetype, False) then
      Exit;
    reg.closekey;
    keystring := Format('%s\shell\%s\command', [filetype, verb]);
    if not reg.OpenKey(keystring, False) then
      Exit;
    regdfile := reg.ReadString('');
    reg.CloseKey;
    if CompareText(regdfile, serverapp) <> 0 then
      Exit;
    Result := True;
  finally
    reg.free;
  end;
end;

procedure RegisterFiletype(const extension, filetype, description,
  verb, serverapp, IcoNum: string);
var
  reg: TRegistry;
  keystring: string;
begin
  reg := TRegistry.Create;
  try
    reg.Rootkey := HKEY_CLASSES_ROOT;
    if not reg.OpenKey(extension, True) then
      Exit;
    reg.WriteString('', filetype);
    reg.CloseKey;
    if not reg.OpenKey(filetype, True) then
      Exit;
    reg.WriteString('', description);
    reg.closekey;
    keystring := Format('%s\shell\%s\command', [filetype, verb]);
    if not reg.OpenKey(keystring, True) then
      Exit;
    reg.WriteString('', serverapp);
    reg.CloseKey;
    if not reg.OpenKey(filetype + '\DefaultIcon', True) then
      Exit;
    reg.WriteString('', Application.ExeName + ',' + IcoNum);
    reg.CloseKey;
    RefreshIcons;
  finally
    reg.free;
  end;
end;

function CheckDDEServer(const filetype, verb, topic, servername:
  string): boolean;
var
  reg: TRegistry;
  keystring: string;
begin
  reg := TRegistry.Create;
  try
    Result := False;
    reg.Rootkey := HKEY_CLASSES_ROOT;
    keystring := Format('%s\shell\%s\ddeexec', [filetype, verb]);
    if not reg.OpenKey(keystring, False) then
      Exit;
    reg.CloseKey;
    if not reg.OpenKey(keystring + '\Application', False) then
      Exit;
    reg.CloseKey;
    if not reg.OpenKey(keystring + '\topic', False) then
      Exit;
    reg.CloseKey;
    Result := True;
  finally
    reg.free;
  end;
end;

procedure RegisterDDEServer(const filetype, verb, topic, servername, macro:
  string);
var
  reg: TRegistry;
  keystring: string;
begin
  reg := TRegistry.Create;
  try
    reg.Rootkey := HKEY_CLASSES_ROOT;
    keystring := Format('%s\shell\%s\ddeexec', [filetype, verb]);
    if not reg.OpenKey(keystring, True) then
      Exit;
    reg.WriteString('', macro);
    reg.CloseKey;
    if not reg.OpenKey(keystring + '\Application', True) then
      Exit;
    reg.WriteString('', servername);
    reg.CloseKey;
    if not reg.OpenKey(keystring + '\topic', True) then
      Exit;
    reg.WriteString('', topic);
    reg.CloseKey;
  finally
    reg.free;
  end;
end;

procedure CheckAssociations;
var
  I: integer;
  DdeOK: array[0..AssociationsCount - 1] of boolean;
begin
  for I := 0 to AssociationsCount - 1 do
    Associated[I] := CheckFiletype('.' + Associations[I, 0],
      'DevCpp.' + Associations[I, 0],
      Associations[I, 1],
      'open',
      Application.Exename + ' "%1"');

  for I := 0 to AssociationsCount - 1 do
    if (not Associated[I]) and MustAssociate(I) then begin
      Associate(I);
    end;

  for I := 0 to AssociationsCount - 1 do
    DdeOK[I] := (Associations[I, 3] <> '') or CheckDDEServer('DevCpp.' + Associations[I, 0],
      'open',
      DDETopic,
      Uppercase(ChangeFileExt(ExtractFilename(Application.Exename), EmptyStr)));

  for I := 0 to AssociationsCount - 1 do
    if (not DdeOK[I]) and MustAssociate(I) then
      RegisterDDEServer(
        'DevCpp.' + Associations[I, 0],
        'open',
        DDETopic,
        Uppercase(ChangeFileExt(ExtractFilename(Application.Exename), EmptyStr)),
        '[Open("%1")]');
end;

end.

