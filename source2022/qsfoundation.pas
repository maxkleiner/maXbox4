unit qsFoundation;

{ QUANTUM SALIS }

{ Statistical algorithms for life sciences }

{ This unit provides fundamental types and basic operations on them }

{ Version 1.0.0 }

{ (c) J. W. Dietrich, 1994 - 2018 }
{ (c) Ludwig Maximilian University of Munich 1995 - 2002 }
{ (c) University of Ulm Hospitals 2002-2004 }
{ (c) Ruhr University of Bochum 2005 - 2018 }

{ Source code released under the BSD License }

{ See the file "license.txt", included in this distribution, }
{ for details about the copyright. }
{ Current versions and additional information are available from }
{ http://quantum-salis.sf.net }

{ This program is distributed in the hope that it will be useful, }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. }

//{$mode objfpc}
{$H+}
{$ASSERTIONS ON}

interface

uses
  Classes, SysUtils, Math;

const

  QS_major   = 1;
  QS_minor   = 0;
  QS_release = 0;
  QS_patch = 0;
  QS_fullversion = ((QS_major * 100 + QS_minor) *
    100 + QS_release) * 100 + QS_patch;
  QS_version = '1.0.0.0';
  QS_internalversion = '';

type

  TLogicvector_data = array of boolean;
  TIntvector_data = array of integer;
  TLongintvector_data = array of longint;
  TRealvector_data = array of real;
  TExtvector_data = array of extended;

  TLogicmatrix_data = array of Tlogicvector_data;
  TIntmatrix_data = array of Tintvector_data;
  TLongintmatrix_data = array of Tlongintvector_data;
  TRealmatrix_data = array of Trealvector_data;
  TExtmatrix_data = array of Textvector_data;

  { TLogicVector }

  TLogicVector = class
    data: TLogicVector_data;
    constructor Create;
    destructor Destroy; override;
    procedure InitFalse(length: longint);
    procedure InitTrue(length: longint);
    function getlength: longint;
  end;

  { TIntVector }

  TIntVector = class
    data: TIntVector_data;
    constructor Create;
    destructor Destroy; override;
    procedure InitZero(length: longint);
    procedure InitOne(length: longint);
    function getlength: longint;
  end;

  { TLongintVector }

  TLongintVector = class
    data: TLongintvector_data;
    constructor Create;
    destructor Destroy; override;
    procedure InitZero(length: longint);
    procedure InitOne(length: longint);
    function getlength: longint;
  end;

  { TRealVector }

  TRealVector = class
    data: TRealvector_data;
    constructor Create;
    destructor Destroy; override;
    procedure InitZero(length: longint);
    procedure InitOne(length: longint);
    function getlength: longint;
  end;

  { TExtVector }

  TExtVector = class
    data: TExtVector_data;
    constructor Create;
    destructor Destroy; override;
    procedure InitZero(length: longint);
    procedure InitOne(length: longint);
    function getlength: longint;
  end;

function add(const vec1: TIntVector; const vec2: TIntVector): TIntVector;
function add(const vec1: TLongintVector; const vec2: TLongintVector): TLongintVector;
function add(const vec1: TRealVector; const vec2: TRealVector): TRealVector;
function add(const vec1: TExtVector; const vec2: TExtVector): TExtVector;

operator + (const vec1: TIntVector; const vec2: TIntVector): TIntVector;
operator + (const vec1: TLongintVector; const vec2: TLongintVector): TLongintVector;
operator + (const vec1: TRealVector; const vec2: TRealVector): TRealVector;
operator + (const vec1: TExtVector; const vec2: TExtVector): TExtVector;

implementation

function add(const vec1: TIntVector; const vec2: TIntVector): TIntVector;
var
  i, k, l: longint;
begin
  k := vec1.getlength;
  l := vec2.getlength;
  if (k > 0) or (l > 0) then
  begin
    result := TIntVector.Create;
    if k = l then
    begin
      setlength(result.data, k);
      for i := 0 to k - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
    end
    else if k < l then
    begin
      setlength(result.data, l);
      for i := 0 to k - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
      for i := k to l - 1 do
        result.data[i] := vec2.data[i];
    end
    else
    begin
      setlength(result.data, k);
      for i := 0 to l - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
      for i := l to k - 1 do
        result.data[i] := vec1.data[i];
    end;
  end
  else
    result := nil;
end;

function add(const vec1: TLongintVector; const vec2: TLongintVector
  ): TLongintVector;
var
  i, k, l: longint;
begin
  k := vec1.getlength;
  l := vec2.getlength;
  if (k > 0) or (l > 0) then
  begin
    result := TLongintVector.Create;
    if k = l then
    begin
      setlength(result.data, k);
      for i := 0 to k - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
    end
    else if k < l then
    begin
      setlength(result.data, l);
      for i := 0 to k - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
      for i := k to l - 1 do
        result.data[i] := vec2.data[i];
    end
    else
    begin
      setlength(result.data, k);
      for i := 0 to l - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
      for i := l to k - 1 do
        result.data[i] := vec1.data[i];
    end;
  end
  else
    result := nil;
end;

function add(const vec1: TRealVector; const vec2: TRealVector): TRealVector;
var
  i, k, l: longint;
begin
  k := vec1.getlength;
  l := vec2.getlength;
  if (k > 0) or (l > 0) then
  begin
    result := TRealVector.Create;
    if k = l then
    begin
      setlength(result.data, k);
      for i := 0 to k - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
    end
    else if k < l then
    begin
      setlength(result.data, l);
      for i := 0 to k - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
      for i := k to l - 1 do
        result.data[i] := vec2.data[i];
    end
    else
    begin
      setlength(result.data, k);
      for i := 0 to l - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
      for i := l to k - 1 do
        result.data[i] := vec1.data[i];
    end;
  end
  else
    result := nil;
end;

function add(const vec1: TExtVector; const vec2: TExtVector): TExtVector;
var
  i, k, l: longint;
begin
  k := vec1.getlength;
  l := vec2.getlength;
  if (k > 0) or (l > 0) then
  begin
    result := TExtVector.Create;
    if k = l then
    begin
      setlength(result.data, k);
      for i := 0 to k - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
    end
    else if k < l then
    begin
      setlength(result.data, l);
      for i := 0 to k - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
      for i := k to l - 1 do
        result.data[i] := vec2.data[i];
    end
    else
    begin
      setlength(result.data, k);
      for i := 0 to l - 1 do
        result.data[i] := vec1.data[i] + vec2.data[i];
      for i := l to k - 1 do
        result.data[i] := vec1.data[i];
    end;
  end
  else
    result := nil;
end;

operator + (const vec1: TIntVector; const vec2: TIntVector): TIntVector;
begin
  result := add(vec1, vec2);
end;

operator + (const vec1: TLongintVector; const vec2: TLongintVector
  ): TLongintVector;
begin
  result := add(vec1, vec2);
end;

operator + (const vec1: TRealVector; const vec2: TRealVector): TRealVector;
begin
  result := add(vec1, vec2);
end;

operator + (const vec1: TExtVector; const vec2: TExtVector): TExtVector;
begin
  result := add(vec1, vec2);
end;

{ TIntVector }

constructor TIntVector.Create;
begin
  inherited Create;
  SetLength(data, 0);
end;

destructor TIntVector.Destroy;
begin
  inherited Destroy;
end;

procedure TIntVector.InitZero(length: longint);
var
  i: longint;
begin
  SetLength(data, length);
  for i := 0 to length - 1 do
    data[i] := 0;
end;

procedure TIntVector.InitOne(length: longint);
var
  i: longint;
begin
  SetLength(data, length);
  for i := 0 to length - 1 do
    data[i] := 1;
end;

function TIntVector.getlength: longint;
begin
  result := length(data);
end;

{ TLongintVector }

constructor TLongintVector.Create;
begin
  inherited Create;
  SetLength(data, 0);
end;

destructor TLongintVector.Destroy;
begin
  inherited Destroy;
end;

procedure TLongintVector.InitZero(length: longint);
var
  i: longint;
begin
  SetLength(data, length);
  for i := 0 to length - 1 do
    data[i] := 0;
end;

procedure TLongintVector.InitOne(length: longint);
var
  i: longint;
begin
  SetLength(data, length);
  for i := 0 to length - 1 do
    data[i] := 1;
end;

function TLongintVector.getlength: longint;
begin
  result := length(data);
end;

{ TRealVector }

constructor TRealVector.Create;
begin
  inherited Create;
  SetLength(data, 0);
end;

destructor TRealVector.Destroy;
begin
  inherited Destroy;
end;

procedure TRealVector.InitZero(length: longint);
var
  i: longint;
begin
  SetLength(data, length);
  for i := 0 to length - 1 do
    data[i] := 0;
end;
procedure TRealVector.InitOne(length: longint);
var
  i: longint;
begin
  SetLength(data, length);
  for i := 0 to length - 1 do
    data[i] := 1;
end;
function TRealVector.getlength: longint;
begin
  result := length(data);
end;

{ TExtVector }

constructor TExtVector.Create;
begin
  inherited Create;
  SetLength(data, 0);
end;

destructor TExtVector.Destroy;
begin
  inherited Destroy;
end;

procedure TExtVector.InitZero(length: longint);
var
  i: longint;
begin
  SetLength(data, length);
  for i := 0 to length - 1 do
    data[i] := 0;
end;

procedure TExtVector.InitOne(length: longint);
var
  i: longint;
begin
  SetLength(data, length);
  for i := 0 to length - 1 do
    data[i] := 1;
end;

function TExtVector.getlength: longint;
begin
  result := length(data);
end;

{ TLogicVector }

constructor TLogicVector.Create;
begin
  inherited Create;
  SetLength(data, 0);
end;

destructor TLogicVector.Destroy;
begin
  inherited Destroy;
end;

procedure TLogicVector.InitFalse(length: longint);
var
  i: longint;
begin
  SetLength(data, length);
  for i := 0 to length - 1 do
    data[i] := false;
end;

procedure TLogicVector.InitTrue(length: longint);
var
  i: longint;
begin
  SetLength(data, length);
  for i := 0 to length - 1 do
    data[i] := true;
end;

function TLogicVector.getlength: longint;
begin
  result := length(data);
end;

end.

