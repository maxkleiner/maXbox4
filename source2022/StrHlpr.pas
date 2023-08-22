{ *********************************************************************** }
{                                                                         }
{ Delphi/C++Builder Runtime Library                                       }
{ Helpers for C++ AnsiString and WideString binding.                      }
{                                                                         }
{ Copyright (c) 2002 Borland Software Corporation                         }
{                                                                         }
{ *********************************************************************** }

unit StrHlpr;

interface

function AnsiCat(const x, y: AnsiString): AnsiString;
function AnsiCopy(const src: AnsiString; index, count: Integer): AnsiString;
function AnsiPos(const src, sub: AnsiString): Integer;
procedure AnsiAppend(var dst: AnsiString; const src: AnsiString);
procedure AnsiDelete(var dst: AnsiString; index, count: Integer);
procedure AnsiFromPWideChar(var dst: AnsiString; src: PWideChar);
procedure AnsiFromWide(var dst: AnsiString; const src: WideString);
procedure AnsiInsert(var dst: AnsiString; const src: AnsiString; index: Integer);
procedure AnsiSetLength(var dst: AnsiString; len: Integer);
procedure AnsiFree(var s: AnsiString);

{ AnsiAssign is called from the C++ AnsiString's copy constructor, so it
  must use pass-by-reference to avoid infinite recursion.  This will
  require ugly const_cast<>'s in the C++ caller } 
procedure AnsiAssign(var dst: AnsiString; var src: AnsiString);


procedure WideAppend(var dst: WideString; const src: WideString);
function WideCat(const x, y: WideString): WideString;
function WideCopy(const src: WideString; index, count: Integer): WideString;
function WideEqual(const x, y: WideString): Boolean;
function WideGreater(const x, y: WideString): Boolean;
function WideLength(const src: WideString): Integer;
function WideLess(const x, y: WideString): Boolean;
function WidePos(const src, sub: WideString): Integer;
procedure WideDelete(var dst: WideString; index, count: Integer);
procedure WideFree(var s: WideString);
procedure WideFromAnsi(var dst: WideString; const src: AnsiString);
procedure WideFromPChar(var dst: WideString; src: PChar);
procedure WideInsert(var dst: WideString; const src: WideString; index: Integer);
procedure WideSetLength(var dst: WideString; len: Integer);

{ WideAssign is called from the C++ AnsiString's copy constructor, so it
  must use pass-by-reference to avoid infinite recursion.  This will
  require ugly const_cast<>'s in the C++ caller } 
procedure WideAssign(var dst: WideString; var src: WideString);


implementation

procedure AnsiFromWide(var dst: AnsiString; const src: WideString);
begin
  dst := src;
end;

procedure AnsiFromPWideChar(var dst: AnsiString; src: PWideChar);
begin
  dst := src;
end;

procedure AnsiAppend(var dst: AnsiString; const src: AnsiString);
begin
  dst := dst + src;
end;

function AnsiCat(const x, y: AnsiString): AnsiString;
begin
  Result := x + y;
end;

procedure AnsiDelete(var dst: AnsiString; index, count: Integer);
begin
  Delete(dst, index, count);
end;

procedure AnsiSetLength(var dst: AnsiString; len: Integer);
begin
  SetLength(dst, len);
end;

function AnsiPos(const src, sub: AnsiString): Integer;
begin
  Result := Pos(sub, src);
end;

function AnsiCopy(const src: AnsiString; index, count: Integer): AnsiString;
begin
  Result := Copy(src, index, count);
end;

procedure AnsiInsert(var dst: AnsiString; const src: AnsiString; index: Integer);
begin
  Insert(src, dst, index);
end;

procedure AnsiAssign(var dst: AnsiString; var src: AnsiString);
begin
  dst := src;
end;

procedure AnsiFree(var s: AnsiString);
begin
  s := '';
end;

procedure WideAssign(var dst: WideString; var src: WideString);
begin
  dst := src;
end;

procedure WideFree(var s: WideString);
begin
  s := '';
end;

procedure WideFromAnsi(var dst: WideString; const src: AnsiString);
begin
  dst := src;
end;

procedure WideFromPChar(var dst: WideString; src: PChar);
begin
  dst := src;
end;

function WideEqual(const x, y: WideString): Boolean;
begin
  Result := x = y;
end;

function WideLess(const x, y: WideString): Boolean;
begin
  Result := x < y;
end;

function WideGreater(const x, y: WideString): Boolean;
begin
  Result := x > y;
end;

function WideCat(const x, y: WideString): WideString;
begin
  Result := x + y;
end;

function WideLength(const src: WideString): Integer;
begin
  Result := Length(src);
end;

function WidePos(const src, sub: WideString): Integer;
begin
  Result := Pos(sub, src);
end;

procedure WideSetLength(var dst: WideString; len: Integer);
begin
  SetLength(dst, len);
end;

procedure WideDelete(var dst: WideString; index, count: Integer);
begin
  Delete(dst, index, count);
end;

procedure WideInsert(var dst: WideString; const src: WideString; index: Integer);
begin
  Insert(src, dst, index);
end;

function WideCopy(const src: WideString; index, count: Integer): WideString;
begin
  Result := Copy(src, index, count);
end;

procedure WideAppend(var dst: WideString; const src: WideString);
begin
  dst := dst + src;
end;


end.
