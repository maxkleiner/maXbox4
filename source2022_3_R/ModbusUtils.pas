{===============================================================================

The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above. If you wish to
allow use of your version of this file only under the terms of the GPL and not
to allow others to use your version of this file under the MPL, indicate your
decision by deleting the provisions above and replace them with the notice and
other provisions required by the GPL. If you do not delete the provisions
above, a recipient may use your version of this file under either the MPL or
the GPL.

$Id: ModbusUtils.pas,v 1.9 2011/11/18 08:34:23 plpolak Exp $

===============================================================================}

{$I ModBusCompiler.inc}

unit ModbusUtils;

interface

function BufferToHex(const Buffer: array of Byte): String;
function CalculateCRC16(const Buffer: array of Byte): Word;
function CalculateLRC(const Buffer: array of Byte): Byte;

function Swap16(const DataToSwap: Word): Word;

procedure GetCoilsFromBuffer(const Buffer: PByte; const Count: Word; var Data: array of Word);
procedure PutCoilsIntoBuffer(const Buffer: PByte; const Count: Word; const Data: array of Word);

procedure GetRegistersFromBuffer(const Buffer: PWord; const Count: Word; var Data: array of Word);
procedure PutRegistersIntoBuffer(const Buffer: PWord; const Count: Word; const Data: array of Word);

implementation

uses
  SysUtils;

const
  CRC16Table: array[0..255] of Word = (
    $0000, $C0C1, $C181, $0140, $C301, $03C0, $0280, $C241,
    $C601, $06C0, $0780, $C741, $0500, $C5C1, $C481, $0440,
    $CC01, $0CC0, $0D80, $CD41, $0F00, $CFC1, $CE81, $0E40,
    $0A00, $CAC1, $CB81, $0B40, $C901, $09C0, $0880, $C841,
    $D801, $18C0, $1980, $D941, $1B00, $DBC1, $DA81, $1A40,
    $1E00, $DEC1, $DF81, $1F40, $DD01, $1DC0, $1C80, $DC41,
    $1400, $D4C1, $D581, $1540, $D701, $17C0, $1680, $D641,
    $D201, $12C0, $1380, $D341, $1100, $D1C1, $D081, $1040,
    $F001, $30C0, $3180, $F141, $3300, $F3C1, $F281, $3240,
    $3600, $F6C1, $F781, $3740, $F501, $35C0, $3480, $F441,
    $3C00, $FCC1, $FD81, $3D40, $FF01, $3FC0, $3E80, $FE41,
    $FA01, $3AC0, $3B80, $FB41, $3900, $F9C1, $F881, $3840,
    $2800, $E8C1, $E981, $2940, $EB01, $2BC0, $2A80, $EA41,
    $EE01, $2EC0, $2F80, $EF41, $2D00, $EDC1, $EC81, $2C40,
    $E401, $24C0, $2580, $E541, $2700, $E7C1, $E681, $2640,
    $2200, $E2C1, $E381, $2340, $E101, $21C0, $2080, $E041,
    $A001, $60C0, $6180, $A141, $6300, $A3C1, $A281, $6240,
    $6600, $A6C1, $A781, $6740, $A501, $65C0, $6480, $A441,
    $6C00, $ACC1, $AD81, $6D40, $AF01, $6FC0, $6E80, $AE41,
    $AA01, $6AC0, $6B80, $AB41, $6900, $A9C1, $A881, $6840,
    $7800, $B8C1, $B981, $7940, $BB01, $7BC0, $7A80, $BA41,
    $BE01, $7EC0, $7F80, $BF41, $7D00, $BDC1, $BC81, $7C40,
    $B401, $74C0, $7580, $B541, $7700, $B7C1, $B681, $7640,
    $7200, $B2C1, $B381, $7340, $B101, $71C0, $7080, $B041,
    $5000, $90C1, $9181, $5140, $9301, $53C0, $5280, $9241,
    $9601, $56C0, $5780, $9741, $5500, $95C1, $9481, $5440,
    $9C01, $5CC0, $5D80, $9D41, $5F00, $9FC1, $9E81, $5E40,
    $5A00, $9AC1, $9B81, $5B40, $9901, $59C0, $5880, $9841,
    $8801, $48C0, $4980, $8941, $4B00, $8BC1, $8A81, $4A40,
    $4E00, $8EC1, $8F81, $4F40, $8D01, $4DC0, $4C80, $8C41,
    $4400, $84C1, $8581, $4540, $8701, $47C0, $4680, $8641,
    $8201, $42C0, $4380, $8341, $4100, $81C1, $8081, $4040
  );


function BufferToHex(const Buffer: array of Byte): String;
var
  i: Integer;
begin
  Result := '';
  for i := Low(Buffer) to High(Buffer) do
    Result := Result + IntToHex(Buffer[i], 2);
end;


function CalculateCRC16(const Buffer: array of Byte): Word;
var
  i: Integer;
  bTemp: Byte;
begin
  Result := 0;
  for i := Low(Buffer) to High(Buffer) do
  begin
    bTemp := Buffer[i] xor Result;
    Result := Result shr 8;
    Result := Result xor CRC16Table[bTemp];
  end;
end;


function CalculateLRC(const Buffer: array of Byte): Byte;
var
  i: Integer;
  CheckSum: Word;
begin
  CheckSum := 0;
  for i := Low(Buffer) to High(Buffer) do
    CheckSum := WordRec(CheckSum).Lo + Buffer[i];
  Result := - WordRec(CheckSum).Lo;
end;


function Swap16(const DataToSwap: Word): Word;
begin
  Result := (DataToSwap div 256) + ((DataToSwap mod 256)*256);
end;


procedure GetCoilsFromBuffer(const Buffer: PByte; const Count: Word; var Data: array of Word);
var
  BytePtr: PByte;
  BitMask: Byte;
  i: Integer;
begin
  BytePtr := Buffer;
  BitMask := 1;

  for i := 0 to (Count - 1) do
  begin
    if (i < Length(Data)) then
    begin
      if ((BytePtr^ and BitMask) <> 0) then
        Data[i] := 1
      else
        Data[i] := 0;
      if (BitMask = $80) then
      begin
        BitMask := 1;
        Inc(BytePtr);
      end
      else
        BitMask := (Bitmask shl 1);
    end;
  end;
end;


procedure PutCoilsIntoBuffer(const Buffer: PByte; const Count: Word; const Data: array of Word);
var
  BytePtr: PByte;
  BitMask: Byte;
  i: Word;
begin
  BytePtr := Buffer;
  BitMask := 1;
  for i := 0 to (Count - 1) do
  begin
    if (i < Length(Data)) then
    begin
      if (BitMask = 1) then
        BytePtr^ := 0;
      if (Data[i] <> 0) then
        BytePtr^ := BytePtr^ or BitMask;
      if (BitMask = $80) then
      begin
        BitMask := 1;
        Inc(BytePtr);
      end
      else
        BitMask := (Bitmask shl 1);
    end;
  end;
end;


procedure GetRegistersFromBuffer(const Buffer: PWord; const Count: Word; var Data: array of Word);
var
  WPtr: PWord;
  i: Word;
begin
  WPtr := Buffer;

  for i := 0 to (Count - 1) do
  begin
    Data[i] := Swap16(WPtr^);
    Inc(WPtr);
  end;
end;


procedure PutRegistersIntoBuffer(const Buffer: PWord; const Count: Word; const Data: array of Word);
var
  WordPtr: PWord;
  i: Word;
begin
  WordPtr := Buffer;
  for i := 0 to (Count - 1) do
  begin
    WordPtr^ := Swap16(Data[i]);
    Inc(WordPtr);
  end;
end;


end.
