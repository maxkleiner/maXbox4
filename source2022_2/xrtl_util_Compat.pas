unit xrtl_util_Compat;

{$INCLUDE xrtl.inc}

interface

uses
  Windows;

{$IFNDEF COMPILER6_UP}
type
  IInterface = System.IUnknown;
  PWordBool = ^WordBool;
  PCardinal = ^Cardinal;
  PWord = ^Word;
  IntegerArray  = array[0..$EFFFFFF] of Integer;
  PIntegerArray = ^IntegerArray;
  UTF8String = string;
{$ENDIF}
  
{$IFNDEF COMPILER6_UP}
function WideCompareStr(const S1, S2: WideString): Integer;
function WideSameStr(const S1, S2: WideString): Boolean;
function GUIDToString(const ClassID: TGUID): string;
function StringToGUID(const S: string): TGUID;
function GetModuleName(Module: HMODULE): string;
function AcquireExceptionObject: TObject;
function IfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer = 0): Integer; overload;

function InterlockedExchangeAdd(var Addend: Longint; Value: Longint): Longint; external kernel32 name 'InterlockedExchangeAdd';

{PENDING: need actual implementation for Delphi 5}
function Utf8Encode(const WS: WideString): UTF8String;
{PENDING: need actual implementation for Delphi 5}
function Utf8Decode(const S: UTF8String): WideString;
{$ENDIF}

function ExcludeTrailingPathDelimiter(const S: string): string;
function IncludeTrailingPathDelimiter(const S: string): string;

implementation

uses
  {$IFNDEF COMPILER6_UP}ComObj,{$ENDIF} SysUtils;

{$IFNDEF COMPILER6_UP}
function WideCompareStr(const S1, S2: WideString): Integer;
begin
  Result:= CompareStringW(LOCALE_USER_DEFAULT, 0,
                          PWideChar(S1), Length(S1),
                          PWideChar(S2), Length(S2)) - 2;
end;

function WideSameStr(const S1, S2: WideString): Boolean;
begin
  Result:= WideCompareStr(S1, S2) = 0;
end;

function GUIDToString(const ClassID: TGUID): string;
begin
  Result:= ComObj.GUIDToString(ClassID);
end;

function StringToGUID(const S: string): TGUID;
begin
  Result:= ComObj.StringToGUID(S);
end;

function GetModuleName(Module: HMODULE): string;
var
  ModName: array[0..10240] of Char;
begin
  SetString(Result, ModName, GetModuleFileName(Module, ModName, SizeOf(ModName)));
end;

function AcquireExceptionObject: TObject;
begin
  Result:= ExceptObject;
end;

function IfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer = 0): Integer;
begin
  if AValue then
    Result:= ATrue
  else
    Result:= AFalse;
end;

function Utf8Encode(const WS: WideString): UTF8String;
begin
  Result:= WS;
end;

function Utf8Decode(const S: UTF8String): WideString;
begin
  Result:= S;
end;
{$ENDIF}

function ExcludeTrailingPathDelimiter(const S: string): string;
begin
  {$IFDEF COMPILER6_UP}
  Result:= SysUtils.ExcludeTrailingPathDelimiter(S);
  {$ELSE}
  Result:= ExcludeTrailingBackslash(S);
  {$ENDIF}
end;

function IncludeTrailingPathDelimiter(const S: string): string;
begin
  {$IFDEF COMPILER6_UP}
  Result:= SysUtils.IncludeTrailingPathDelimiter(S);
  {$ELSE}
  Result:= IncludeTrailingBackslash(S);
  {$ENDIF}
end;

end.
 