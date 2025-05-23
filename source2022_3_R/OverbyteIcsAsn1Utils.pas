{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Fran�ois PIETTE
Description:  ASN1 utilities (Intended for TSnmpClient component)
Creation:     March 2011
Version:      1.01
EMail:        francois.piette@overbyte.be  http://www.overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 2011 by Fran�ois PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium.
              <francois.piette@overbyte.be>
              The Initial Developer of the Original Code is Lukas Gebauer.
              Portions created by Lukas Gebauer are Copyright (c) 1999-2003                |
              Portions created by Hernan Sanchez are Copyright (c) 2000.                   |

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:
May 11, 2012 V1.01 Arno - Unit did not compile with Ansi Delphi

|==============================================================================|
| Copyright (c)1999-2007, Lukas Gebauer                                        |
| All rights reserved.                                                         |
|                                                                              |
| Redistribution and use in source and binary forms, with or without           |
| modification, are permitted provided that the following conditions are met:  |
|                                                                              |
| Redistributions of source code must retain the above copyright notice, this  |
| list of conditions and the following disclaimer.                             |
|                                                                              |
| Redistributions in binary form must reproduce the above copyright notice,    |
| this list of conditions and the following disclaimer in the documentation    |
| and/or other materials provided with the distribution.                       |
|                                                                              |
| Neither the name of Lukas Gebauer nor the names of its contributors may      |
| be used to endorse or promote products derived from this software without    |
| specific prior written permission.                                           |
|                                                                              |
| THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"  |
| AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE    |
| IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   |
| ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR  |
| ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL       |
| DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR   |
| SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER   |
| CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT           |
| LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY    |
| OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH  |
| DAMAGE.                                                                      |
|==============================================================================|

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
//{$I Include\OverbyteIcsDefs.inc}
{$Q-}
{$H+}
{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

unit OverbyteIcsAsn1Utils;

interface

uses
  {$IFDEF RTL_NAMESPACES}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  {$IFDEF RTL_NAMESPACES}System.Classes{$ELSE}Classes{$ENDIF};

const
  ASN1UtilsVersion       = 101;
  CopyRight    : String  = ' ASN1Utils (c) 2011 Francois Piette V1.01 ';

const
  ASN1_BOOL      = $01;
  ASN1_INT       = $02;
  ASN1_OCTSTR    = $04;
  ASN1_NULL      = $05;
  ASN1_OBJID     = $06;
  ASN1_ENUM      = $0a;
  ASN1_SEQ       = $30;
  ASN1_SETOF     = $31;
  ASN1_IPADDR    = $40;
  ASN1_COUNTER   = $41;
  ASN1_GAUGE     = $42;
  ASN1_TIMETICKS = $43;
  ASN1_OPAQUE    = $44;

{:Encodes OID item to binary form.}
function ASNEncOIDItem(Value: Integer): AnsiString;

{:Decodes an OID item of the next element in the "Buffer" from the "Start"
 position.}
function ASNDecOIDItem(var Start: Integer; const Buffer: AnsiString): Integer;

{:Encodes the length of ASN.1 element to binary.}
function ASNEncLen(Len: Integer): AnsiString;

{:Decodes length of next element in "Buffer" from the "Start" position.}
function ASNDecLen(var Start: Integer; const Buffer: AnsiString): Integer;

{:Encodes a signed integer to ASN.1 binary}
function ASNEncInt(Value: Integer): AnsiString;

{:Encodes unsigned integer into ASN.1 binary}
function ASNEncUInt(Value: Integer): AnsiString;

{:Encodes ASN.1 object to binary form.}
function ASNObject(const Data: AnsiString; ASNType: Integer): AnsiString;

{:Beginning with the "Start" position, decode the ASN.1 item of the next element
 in "Buffer". Type of item is stored in "ValueType."}
function ASNItem(var Start: Integer; const Buffer: AnsiString;
  var ValueType: Integer): AnsiString;

{:Encodes an MIB OID string to binary form.}
function MibToId(Mib: String): AnsiString;
    {$IFDEF UNICODE} overload; {$ENDIF}
{$IFDEF UNICODE}
function MibToId(Mib: AnsiString): AnsiString; overload;
{$ENDIF}

{:Decodes MIB OID from binary form to string form.}
function IdToMib(const Id: AnsiString): String;

{:Encodes an one number from MIB OID to binary form. (used internally from
@link(MibToId))}
function IntMibToStr(const Value: AnsiString): AnsiString;

{:Convert ASN.1 BER encoded buffer to human readable form for debugging.}
function ASNdump(const Value: AnsiString): String;

implementation

{==============================================================================}
function ASNEncOIDItem(Value: Integer): AnsiString;
var
  x, xm: Integer;
  b: Boolean;
begin
  x := Value;
  b := False;
  Result := '';
  repeat
    xm := x mod 128;
    x := x div 128;
    if b then
      xm := xm or $80;
    if x > 0 then
      b := True;
    Result := AnsiChar(xm) + Result;
  until x = 0;
end;

{==============================================================================}
function ASNDecOIDItem(var Start: Integer; const Buffer: AnsiString): Integer;
var
  x: Integer;
  b: Boolean;
begin
  Result := 0;
  repeat
    Result := Result * 128;
    x := Ord(Buffer[Start]);
    Inc(Start);
    b := x > $7F;
    x := x and $7F;
    Result := Result + x;
  until not b;
end;

{==============================================================================}
function ASNEncLen(Len: Integer): AnsiString;
var
  x, y: Integer;
begin
  if Len < $80 then
    Result := AnsiChar(Len)
  else
  begin
    x := Len;
    Result := '';
    repeat
      y := x mod 256;
      x := x div 256;
      Result := AnsiChar(y) + Result;
    until x = 0;
    y := Length(Result);
    y := y or $80;
    Result := AnsiChar(y) + Result;
  end;
end;

{==============================================================================}
function ASNDecLen(var Start: Integer; const Buffer: AnsiString): Integer;
var
  x, n: Integer;
begin
  x := Ord(Buffer[Start]);
  Inc(Start);
  if x < $80 then
    Result := x
  else
  begin
    Result := 0;
    x := x and $7F;
    for n := 1 to x do
    begin
      Result := Result * 256;
      x := Ord(Buffer[Start]);
      Inc(Start);
      Result := Result + x;
    end;
  end;
end;

{==============================================================================}
function ASNEncInt(Value: Integer): AnsiString;
var
  x, y: Cardinal;
  neg: Boolean;
begin
  neg := Value < 0;
  x := Abs(Value);
  if neg then
    x := not (x - 1);
  Result := '';
  repeat
    y := x mod 256;
    x := x div 256;
    Result := AnsiChar(y) + Result;
  until x = 0;
  if (not neg) and (Result[1] > #$7F) then
    Result := #0 + Result;
end;

{==============================================================================}
function ASNEncUInt(Value: Integer): AnsiString;
var
  x, y: Integer;
  neg: Boolean;
begin
  neg := Value < 0;
  x := Value;
  if neg then
    x := x and $7FFFFFFF;
  Result := '';
  repeat
    y := x mod 256;
    x := x div 256;
    Result := AnsiChar(y) + Result;
  until x = 0;
  if neg then
    Result[1] := AnsiChar(Ord(Result[1]) or $80);
end;

{==============================================================================}
function ASNObject(const Data: AnsiString; ASNType: Integer): AnsiString;
begin
  Result := AnsiChar(ASNType) + ASNEncLen(Length(Data)) + Data;
end;

{==============================================================================}
function ASNItem(var Start: Integer; const Buffer: AnsiString;
  var ValueType: Integer): AnsiString;
var
  ASNType: Integer;
  ASNSize: Integer;
  y, n: Integer;
  x: byte;
  s: AnsiString;
  c: AnsiChar;
  neg: Boolean;
  l: Integer;
begin
  Result := '';
  ValueType := ASN1_NULL;
  l := Length(Buffer);
  if l < (Start + 1) then
    Exit;
  ASNType := Ord(Buffer[Start]);
  ValueType := ASNType;
  Inc(Start);
  ASNSize := ASNDecLen(Start, Buffer);
  if (Start + ASNSize - 1) > l then
    Exit;
  if (ASNType and $20) > 0 then
//    Result := '$' + IntToHex(ASNType, 2)
    Result := Copy(Buffer, Start, ASNSize)
  else
    case ASNType of
      ASN1_INT, ASN1_ENUM, ASN1_BOOL:
        begin
          y := 0;
          neg := False;
          for n := 1 to ASNSize do
          begin
            x := Ord(Buffer[Start]);
            if (n = 1) and (x > $7F) then
              neg := True;
            if neg then
              x := not x;
            y := y * 256 + x;
            Inc(Start);
          end;
          if neg then
            y := -(y + 1);
          Result := AnsiString(IntToStr(y));
        end;
      ASN1_COUNTER, ASN1_GAUGE, ASN1_TIMETICKS:
        begin
          y := 0;
          for n := 1 to ASNSize do
          begin
            y := y * 256 + Ord(Buffer[Start]);
            Inc(Start);
          end;
          Result := AnsiString(IntToStr(y));
        end;
      ASN1_OCTSTR, ASN1_OPAQUE:
        begin
          for n := 1 to ASNSize do
          begin
            c := AnsiChar(Buffer[Start]);
            Inc(Start);
            s := s + c;
          end;
          Result := s;
        end;
      ASN1_OBJID:
        begin
          for n := 1 to ASNSize do
          begin
            c := AnsiChar(Buffer[Start]);
            Inc(Start);
            s := s + c;
          end;
          Result := AnsiString(IdToMib(s));
        end;
      ASN1_IPADDR:
        begin
          s := '';
          for n := 1 to ASNSize do
          begin
            if (n <> 1) then
              s := s + '.';
            y := Ord(Buffer[Start]);
            Inc(Start);
            s := s + AnsiString(IntToStr(y));
          end;
          Result := s;
        end;
      ASN1_NULL:
        begin
          Result := '';
          Start := Start + ASNSize;
        end;
    else // unknown
      begin
        for n := 1 to ASNSize do
        begin
          c := AnsiChar(Buffer[Start]);
          Inc(Start);
          s := s + c;
        end;
        Result := s;
      end;
    end;
end;

{==============================================================================}
{$IFDEF UNICODE}
function MibToId(Mib: AnsiString): AnsiString;
begin
    Result := MibToId(String(Mib));
end;
{$ENDIF}

function MibToId(Mib: String): AnsiString;
var
  x: Integer;

  function WalkInt(var s: String): Integer;
  var
    x: Integer;
    t: String;
  begin
    x := Pos('.', s);
    if x < 1 then
    begin
      t := s;
      s := '';
    end
    else
    begin
      t := Copy(s, 1, x - 1);
      s := Copy(s, x + 1, Length(s) - x);
    end;
    Result := StrToIntDef(t, 0);
  end;

begin
  Result := '';
  x := WalkInt(Mib);
  x := x * 40 + WalkInt(Mib);
  Result := ASNEncOIDItem(x);
  while Mib <> '' do
  begin
    x := WalkInt(Mib);
    Result := Result + ASNEncOIDItem(x);
  end;
end;

{==============================================================================}
function IdToMib(const Id: AnsiString): String;
var
  x, y, n: Integer;
begin
  Result := '';
  n := 1;
  while Length(Id) + 1 > n do
  begin
    x := ASNDecOIDItem(n, Id);
    if (n - 1) = 1 then
    begin
      y := x div 40;
      x := x mod 40;
      Result := IntToStr(y);
    end;
    Result := Result + '.' + IntToStr(x);
  end;
end;

{==============================================================================}
function IntMibToStr(const Value: AnsiString): AnsiString;
var
  n, y: Integer;
begin
  y := 0;
  for n := 1 to Length(Value) - 1 do
    y := y * 256 + Ord(Value[n]);
  Result := AnsiString(IntToStr(y));
end;

{==============================================================================}
// Extracted from synautil
function IsBinaryString(const Value: string): Boolean;
var
  n: integer;
begin
  Result := False;
  for n := 1 to Length(Value) do
  {$IFDEF UNICODE}
    if CharInSet(Value[n], [#0..#8, #10..#31]) then
  {$ELSE}
    if Value[n] in [#0..#8, #10..#31] then
  {$ENDIF}
      //ignore null-terminated strings
      if not ((n = Length(value)) and (Value[n] = #0)) then
      begin
        Result := True;
        Break;
      end;
end;

{==============================================================================}
// Extracted from synautil
function DumpExStr(const Buffer: String): string;
var
  n: Integer;
  x: Byte;
begin
  Result := '';
  for n := 1 to Length(Buffer) do
  begin
    x := Ord(Buffer[n]);
    if x in [65..90, 97..122] then
      Result := Result + ' +''' + char(x) + ''''
    else
      Result := Result + ' +#$' + IntToHex(Ord(Buffer[n]), 2);
  end;
end;

{==============================================================================}
function ASNdump(const Value: AnsiString): String;
var
  i, at, x, n: integer;
  s: String;
  indent: String;
  il: TStringList;
begin
  il := TStringList.Create;
  try
    Result := '';
    i := 1;
    indent := '';
    while i < Length(Value) do
    begin
      for n := il.Count - 1 downto 0 do
      begin
        x := StrToIntDef(il[n], 0);
        if x <= i then
        begin
          il.Delete(n);
          Delete(indent, 1, 2);
        end;
      end;
      s := String(ASNItem(i, Value, at));
      Result := Result + indent + '$' + IntToHex(at, 2);
      if (at and $20) > 0 then
      begin
        x := Length(s);
        Result := Result + ' constructed: length ' + IntToStr(x);
        indent := indent + '  ';
        il.Add(IntToStr(x + i - 1));
      end
      else
      begin
        case at of
          ASN1_BOOL:
            Result := Result + ' BOOL: ';
          ASN1_INT:
            Result := Result + ' INT: ';
          ASN1_ENUM:
            Result := Result + ' ENUM: ';
          ASN1_COUNTER:
            Result := Result + ' COUNTER: ';
          ASN1_GAUGE:
            Result := Result + ' GAUGE: ';
          ASN1_TIMETICKS:
            Result := Result + ' TIMETICKS: ';
          ASN1_OCTSTR:
            Result := Result + ' OCTSTR: ';
          ASN1_OPAQUE:
            Result := Result + ' OPAQUE: ';
          ASN1_OBJID:
            Result := Result + ' OBJID: ';
          ASN1_IPADDR:
            Result := Result + ' IPADDR: ';
          ASN1_NULL:
            Result := Result + ' NULL: ';
        else // other
          Result := Result + ' unknown: ';
        end;
        if IsBinaryString(s) then
          s := DumpExStr(s);
        Result := Result + s;
      end;
      Result := Result + #$0d + #$0a;
    end;
  finally
    il.Free;
  end;
end;

{==============================================================================}

end.
