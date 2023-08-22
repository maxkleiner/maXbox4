{-------------------------------------------------------------------------------
 
 Copyright (c) 1999-2015 Ralf Junker, Yunqa
 Internet: http://www.yunqa.de
 E-Mail:   delphi@yunqa.de

-------------------------------------------------------------------------------}

unit YuUtf;

{$I DICompilers.inc}

interface

uses
  DISystemCompat;

function Utf8Bytes(
  p: PUtf8Char;
  l: NativeInt): NativeInt;

function ReadUCS4_utf8(
  p: PUtf8Char;
  l: NativeInt;
  out c: UCS4Char): NativeInt;

implementation

const
  UTF8_ACCEPT = 0;
  UTF8_REJECT = 12;

  utf8d: array[0..363] of Byte = (

    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
    7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
    8, 8, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    10, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 11, 6, 6, 6, 5, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,

    0, 12, 24, 36, 60, 96, 84, 12, 12, 12, 48, 72, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
    12, 0, 12, 12, 12, 12, 12, 0, 12, 0, 12, 12, 12, 24, 12, 12, 12, 12, 12, 24, 12, 24, 12, 12,
    12, 12, 12, 12, 12, 12, 12, 24, 12, 12, 12, 12, 12, 24, 12, 12, 12, 12, 12, 12, 12, 24, 12, 12,
    12, 12, 12, 12, 12, 12, 12, 36, 12, 36, 12, 12, 12, 36, 12, 12, 12, 12, 12, 36, 12, 36, 12, 12,
    12, 36, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12);

function Utf8Bytes(p: PUtf8Char; l: NativeInt): NativeInt;
var
  s: NativeInt;
begin
  Assert(Assigned(p) and (l > 0));

  Result := 1;
  s := 0;
  repeat
    s := utf8d[256 + s + utf8d[Ord(p^)]];
    case s of
      UTF8_ACCEPT: Exit;
      UTF8_REJECT: Break;
    end;
    Inc(Result); Inc(p); Dec(l);
  until l = 0;
  Result := -Result;
end;

function ReadUCS4_utf8(p: PUtf8Char; l: NativeInt; out c: UCS4Char): NativeInt;
var
  s, t: NativeInt;
begin
  Assert(Assigned(p) and (l > 0));

  Result := 1;
  c := 0;
  s := 0;
  repeat
    t := utf8d[Ord(p^)];
    if s <> UTF8_ACCEPT then
      c := (Ord(p^) and $3F) or (c shl 6)
    else
      c := ($FF shr t) and Ord(p^);
    s := utf8d[256 + s + t];
    case s of
      UTF8_ACCEPT: Exit;
      UTF8_REJECT: Break;
    end;
    Inc(Result); Inc(p); Dec(l);
  until l = 0;
  Result := -Result;
end;

end.

