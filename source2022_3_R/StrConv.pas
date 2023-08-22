unit StrConv;

interface

uses SysUtils, Windows;

type
  TCodepage = type DWord;

const
  CP_INVALID    = TCodepage(-1);
  CP_ASIS       = TCodepage(-2);  // no convertion happens.
  CP_ANSI       = CP_ACP;
  CP_OEM        = CP_OEMCP;
  CP_SHIFTJIS   = 932;
  CP_LATIN1     = 1250;
  CP_UNICODE    = 1200;
  CP_UTF8       = 65001;

function MinStrConvBufSize(SrcCodepage: TCodepage; Str: String): Integer; overload;
function MinStrConvBufSize(DestCodepage: TCodepage; Wide: WideString): Integer; overload;
function ToWideString(SrcCodepage: TCodepage; Str: String; BufSize: Integer = -1): WideString;
// If Fail = False replaces unconvertable symbols with default OS symbol (usually '?').
function FromWideString(DestCodepage: TCodepage; Str: WideString; BufSize: Integer = -1; Fail: Boolean = False): String;

function CharsetToID(Str: String): TCodepage;
function IdToCharset(ID: TCodepage; GetDescription: Boolean = False): String;

implementation

uses Math;

function MinStrConvBufSize(SrcCodepage: TCodepage; Str: String): Integer;
begin
  if SrcCodepage = CP_ASIS then
    Result := Length(Str) div 2 + 1 {null char}
    else
      Result := MultiByteToWideChar(SrcCodepage, 0, PChar(Str), -1, NIL, 0)
end;

function MinStrConvBufSize(DestCodepage: TCodepage; Wide: WideString): Integer;
begin
  if DestCodepage = CP_ASIS then
    Result := Length(Wide) * 2 + 1 {null char}
    else
      Result := WideCharToMultiByte(DestCodepage, 0, PWideChar(Wide), -1, NIL, 0, NIL, NIL)
end;

function ToWideString(SrcCodepage: TCodepage; Str: String; BufSize: Integer = -1): WideString;
begin
  if Str = '' then
  begin
    Result := '';
    Exit;
  end;

  if BufSize = -1 then
    BufSize := MinStrConvBufSize(SrcCodepage, Str);
  SetLength(Result, BufSize);
  if SrcCodepage = CP_ASIS then
    Move(Str[1], Result[1], Min(BufSize * 2 - 2, Length(Str)))
    else
      BufSize := MultiByteToWideChar(SrcCodepage, 0, PChar(Str), -1, PWideChar(Result), BufSize);
  SetLength(Result, BufSize - 1);
end;

function FromWideString(DestCodepage: TCodepage; Str: WideString; BufSize: Integer = -1; Fail: Boolean = False): String;
var
  DefCharUsedPtr: PBool;
begin
  if Str = '' then
  begin
    Result := '';
    Exit;
  end;

  if BufSize = -1 then
    BufSize := MinStrConvBufSize(DestCodepage, Str);
  SetLength(Result, BufSize);

  if DestCodepage = CP_ASIS then
    Move(Str[1], Result[1], Min(BufSize - 1, Length(Str) * 2))
    else
    begin
      if Fail then
        DefCharUsedPtr := @Fail
      else
        DefCharUsedPtr := NIL;
      BufSize := WideCharToMultiByte(DestCodepage, 0, PWideChar(Str), -1, PChar(Result), BufSize, NIL, DefCharUsedPtr);
      if Fail then
        raise EConvertError.CreateFmt('Codepage %d cannot represent all symbols of given string ''%s''.', [DestCodepage, Copy(Str, 1, 50)]);
    end;

  SetLength(Result, BufSize - 1);
end;

function CharsetToID(Str: String): TCodepage;
var
  Key: HKEY;
  ValueType, BufSize: DWord;
begin
  Result := CP_INVALID;

  if RegOpenKeyEx(HKEY_CLASSES_ROOT, PChar('MIME\Database\Charset\' + LowerCase(Str)), 0, KEY_QUERY_VALUE, Key) = ERROR_SUCCESS then
    try
      BufSize := SizeOf(Result);
      ValueType := REG_DWORD;
      if (RegQueryValueEx(Key, 'InternetEncoding', NIL, @ValueType, @Result, @BufSize) <> ERROR_SUCCESS) or
         (BufSize <> SizeOf(Result)) then
      begin
        BufSize := 256;
        SetLength(Str, BufSize);
        ValueType := REG_SZ;
        if RegQueryValueEx(Key, 'AliasForCharset', NIL, @ValueType, @Str[1], @BufSize) = ERROR_SUCCESS then
          Result := CharsetToID(Copy(Str, 1, BufSize - 1 {= last #0}));
      end;
    finally
      RegCloseKey(Key);
    end;
end;

function IdToCharset(ID: TCodepage; GetDescription: Boolean = False): String;
var
  Key: HKEY;
  ValueType, BufSize: DWord;
  Field: PChar;
begin
  Result := '';

  if RegOpenKeyEx(HKEY_CLASSES_ROOT, PChar('MIME\Database\Codepage\' + IntToStr(ID)), 0, KEY_QUERY_VALUE, Key) = ERROR_SUCCESS then
    try
      SetLength(Result, 256);
      BufSize := Length(Result);

      if GetDescription then
        Field := 'Description'
        else
          Field := 'BodyCharset';

      ValueType := REG_SZ;
      if RegQueryValueEx(Key, Field, NIL, @ValueType, @Result[1], @BufSize) = ERROR_SUCCESS then
        SetLength(Result, BufSize - 1)
        else
          Result := '';
    finally
      RegCloseKey(Key);
    end;
end;

end.