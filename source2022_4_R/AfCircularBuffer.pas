{==============================================================================|
| Project : Delphree - AsyncFree                                 | 001.004.000 |
|==============================================================================|
| Content:  Simple implemetation of non thread-safe circular buffer            |
|==============================================================================|
| The contents of this file are subject to the Mozilla Public License Ver. 1.0 |
| (the "License"); you may not use this file except in compliance with the     |
| License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ |
|                                                                              |
| Software distributed under the License is distributed on an "AS IS" basis,   |
| WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for |
| the specific language governing rights and limitations under the License.    |
|==============================================================================|
| The Original Code is AsyncFree Library.                                      |
|==============================================================================|
| The Initial Developer of the Original Code is Petr Vones (Czech Republic).   |
| Portions created by Petr Vones are Copyright (C) 1998, 1999.                 |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| History:                                                                     |
|   see AfRegister.pas                                                         |
|==============================================================================}

unit AfCircularBuffer;

interface

type
  TAfCircularBuffer = class(TObject)
  private
    FData: PChar;
    FSize: Integer;
    FStart, FEnd: Integer;
    Full: Boolean;
    function GetStartPtr: PChar;
    function GetStartBufPtr: PChar;
    function InternalPeek(var Buf; Len: Integer): Boolean;
    function InternalRemove(Len: Integer): Boolean;
    procedure IncPtr(var Ptr: Integer; const Value: Integer);
  public
    constructor Create(ASize: Integer);
    destructor Destroy; override;
    function BufFree: Integer;
    function BufUsed: Integer;
    function BufLinearFree: Integer;
    function BufLinearUsed: Integer;
    procedure Clear;
    function LinearPoke(Len: Integer): Boolean;
    function Peek(var Buf; Len: Integer): Boolean;
    function PeekChar(Index: Integer; var C: Char): Boolean;
    function Read(var Buf; Len: Integer): Boolean;
    function Remove(Len: Integer): Boolean;
    function Write(const Buf; Len: Integer): Boolean;
    property StartPtr: PChar read GetStartPtr;
    property StartBufPtr: PChar read GetStartBufPtr;
  end;

implementation

{ TAfCircularBuffer }

function TAfCircularBuffer.BufFree: Integer;
begin
  Result := FSize - BufUsed;
end;

function TAfCircularBuffer.BufLinearFree: Integer;
begin
  if Full then
    Result := 0
  else if FStart <= FEnd then
    Result := FSize - FEnd
  else
    Result := FStart - FEnd;
end;

function TAfCircularBuffer.BufLinearUsed: Integer;
begin
  if Full then
    Result := FSize - FStart
  else if FStart <= FEnd then
    Result := FEnd - FStart
  else
    Result := FSize - FStart;
end;

function TAfCircularBuffer.BufUsed: Integer;
begin
  if Full then
    Result := FSize
  else if FStart <= FEnd then
    Result := FEnd - FStart
  else
    Result := FEnd + FSize - FStart;
end;

procedure TAfCircularBuffer.Clear;
begin
  FStart := 0;
  FEnd := 0;
  Full := False;
end;

constructor TAfCircularBuffer.Create(ASize: Integer);
begin
  FSize := ASize;
  GetMem(FData, FSize);
  Clear;
end;

destructor TAfCircularBuffer.Destroy;
begin
  if FData <> nil then FreeMem(FData);
  inherited Destroy;
end;

function TAfCircularBuffer.GetStartPtr: PChar;
begin
  Result := @FData[FStart];
end;

function TAfCircularBuffer.GetStartBufPtr: PChar;
begin
  Result := @FData;
end;

procedure TAfCircularBuffer.IncPtr(var Ptr: Integer; const Value: Integer);
begin
  if Ptr + Value < FSize then
    Inc(Ptr, Value)
  else
    Inc(Ptr, Value - FSize);
end;

function TAfCircularBuffer.InternalPeek(var Buf; Len: Integer): Boolean;
var
  SizeToEnd: Integer;
begin
  Result := False;
  if (Len > 0) and (Len <= BufUsed) then
  begin
    if FStart < FEnd then
      Move(FData[FStart], Buf, Len)
    else
    begin
      SizeToEnd := FSize - FStart;
      if Len <= SizeToEnd then
        Move(FData[FStart], Buf, Len)
      else
      begin
        Move(FData[FStart], Buf, SizeToEnd);
        Move(FData[0], PChar(@Buf)[SizeToEnd], Len - SizeToEnd);
      end;
    end;
    Result := True;
  end;
end;

function TAfCircularBuffer.InternalRemove(Len: Integer): Boolean;
begin
  Result := Len <= BufUsed;
  if Result then
  begin
    IncPtr(FStart, Len);
    if Len > 0 then Full := False;
  end;
end;

function TAfCircularBuffer.LinearPoke(Len: Integer): Boolean;
begin
  if (Len = 0) or (BufLinearFree < Len) then
    Result := False
  else
  begin
    IncPtr(FEnd, Len);
    Full := (FStart = FEnd);
    Result := True;
  end;
end;

function TAfCircularBuffer.Peek(var Buf; Len: Integer): Boolean;
begin
  Result := InternalPeek(Buf, Len);
end;

function TAfCircularBuffer.PeekChar(Index: Integer; var C: Char): Boolean;
var
  I: Integer;
begin
  Result := False;
  C := #0;
  if Index > 0 then
  begin
    I := FStart + Index - 1;
    if FStart < FEnd then
    begin
      if I <= FEnd then
      begin
        C := FData[I];
        Result := True;
      end;
    end else
    begin
      if I < FSize then
      begin
        C := FData[I];
        Result := True;
      end else
      begin
        Dec(I, FSize);
        if (I < FEnd) or (Full and (I = FEnd)) then
        begin
          C := FData[I];
          Result := True;
        end;
      end;
    end;
  end;
end;

function TAfCircularBuffer.Read(var Buf; Len: Integer): Boolean;
begin
  Result := InternalPeek(Buf, Len);
  if Result then InternalRemove(Len);
end;

function TAfCircularBuffer.Remove(Len: Integer): Boolean;
begin
  Result := InternalRemove(Len);
end;

function TAfCircularBuffer.Write(const Buf; Len: Integer): Boolean;
var
  SizeToEnd: Integer;
begin
  Result := False;
  if (Len > 0) and (Len <= BufFree) then
  begin
    if FStart <= FEnd then
    begin
      SizeToEnd := FSize - FEnd;
      if Len <= SizeToEnd then
        Move(Buf, FData[FEnd], Len)
      else
      begin
        Move(Buf, FData[FEnd], SizeToEnd);
        Move(PChar(@Buf)[SizeToEnd], FData[0], Len - SizeToEnd);
      end;
    end else
      Move(Buf, FData[FEnd], Len);
    IncPtr(FEnd, Len);
    Full := (FStart = FEnd);
    Result := True;
  end;
end;

end.
