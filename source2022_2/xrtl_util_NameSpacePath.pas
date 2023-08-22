unit xrtl_util_NameSpacePath;

{$INCLUDE xrtl.inc}

interface

uses
  {$IFDEF HAS_UNIT_VARIANTS}Variants,{$ENDIF}
  Classes;

type
  TXRTLNameSpacePathElement = WideString;
  TXRTLNameSpacePath = array of TXRTLNameSpacePathElement;

function  XRTLNameSpacePathCreate(const Elements: array of WideString): TXRTLNameSpacePath; overload;
function  XRTLNameSpacePathCreateA(const Elements: array of string): TXRTLNameSpacePath; overload;
function  XRTLNameSpacePathCreate(const Elements: TStrings): TXRTLNameSpacePath; overload;
function  XRTLNameSpacePathCreate(const Elements: Variant{array of WideString}): TXRTLNameSpacePath; overload;
function  XRTLNameSpacePathConcat(const Path1, Path2: TXRTLNameSpacePath): TXRTLNameSpacePath;
function  XRTLNameSpacePathGetLength(const Path: TXRTLNameSpacePath): Integer;
procedure XRTLNameSpacePathSetLength(var Path: TXRTLNameSpacePath; NewLength: Integer);

implementation

function XRTLNameSpacePathCreate(const Elements: array of WideString): TXRTLNameSpacePath;
var
  LowIndex, I: Integer;
begin
  LowIndex:= Low(Elements);
  XRTLNameSpacePathSetLength(Result, High(Elements) - LowIndex + 1);
  for I:= LowIndex to High(Elements) do
    Result[I - LowIndex]:= Elements[I];
end;

function XRTLNameSpacePathCreateA(const Elements: array of string): TXRTLNameSpacePath; overload;
var
  LowIndex, I: Integer;
begin
  LowIndex:= Low(Elements);
  XRTLNameSpacePathSetLength(Result, High(Elements) - LowIndex + 1);
  for I:= LowIndex to High(Elements) do
    Result[I - LowIndex]:= Elements[I];
end;

function XRTLNameSpacePathCreate(const Elements: TStrings): TXRTLNameSpacePath;
var
  I: Integer;
begin
  XRTLNameSpacePathSetLength(Result, Elements.Count);
  for I:= 0 to Elements.Count - 1 do
    Result[I]:= Elements[I];
end;

function XRTLNameSpacePathCreate(const Elements: Variant{array of WideString}): TXRTLNameSpacePath; overload;
var
  I, LowIndex, Len: Integer;
begin
  if not VarIsArray(Elements) then
  begin
    XRTLNameSpacePathSetLength(Result, 1);
    Result[0]:= WideString(Elements);
  end
  else
  begin
    LowIndex:= VarArrayLowBound(Elements, 1);
    Len:= VarArrayHighBound(Elements, 1) - LowIndex + 1;
    XRTLNameSpacePathSetLength(Result, Len);
    for I:= 0 to Len - 1 do
      Result[I]:= Elements[I + LowIndex];
  end;
end;

function XRTLNameSpacePathConcat(const Path1, Path2: TXRTLNameSpacePath): TXRTLNameSpacePath;
var
  Path1Len, Path2Len, I: Integer;
begin
  Path1Len:= XRTLNameSpacePathGetLength(Path1);
  Path2Len:= XRTLNameSpacePathGetLength(Path2);
  XRTLNameSpacePathSetLength(Result, Path1Len + Path2Len);
  for I:= 0 to Path1Len - 1 do
    Result[I]:= Path1[I];
  for I:= 0 to Path2Len - 1 do
    Result[I + Path1Len]:= Path2[I];
end;

function XRTLNameSpacePathGetLength(const Path: TXRTLNameSpacePath): Integer;
begin
  Result:= High(Path) - Low(Path) + 1;
end;

procedure XRTLNameSpacePathSetLength(var Path: TXRTLNameSpacePath; NewLength: Integer);
begin
  SetLength(Path, NewLength);
end;

end.
