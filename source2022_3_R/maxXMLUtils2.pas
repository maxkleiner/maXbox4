(*:XML helper unit.
       - Created by extracting common utilities from unit GpXML.
*)

unit maxXMLUtils2;

interface


uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils,
  Classes,
  Graphics,
  Variants, xmldom, XMLIntf;

  type
    XmlString = WideString;
  type
    TOutputFormat = (ofNone, ofFlat, ofIndent);
    EmaxXMLUtils = class(Exception);

  {:Delete the specified node.
  }

  {:A family of functions used to convert string to some other value according
    to the conversion rules used in this unit. Used in Get* functions above.
  }
  function XMLStrToReal(nodeValue: XmlString; var value: real): boolean; overload;
  function XMLStrToReal(nodeValue: XmlString): real; overload;
  function XMLStrToRealDef(nodeValue: XmlString; defaultValue: real): real;
  function XMLStrToExtended(nodeValue: XmlString; var value: extended): boolean; overload;
  function XMLStrToExtended(nodeValue: XmlString): extended; overload;
  function XMLStrToExtendedDef(nodeValue: XmlString; defaultValue: extended): extended;
  function XMLStrToCurrency(nodeValue: XmlString; var value: Currency): boolean; overload;
  function XMLStrToCurrency(nodeValue: XmlString): Currency; overload;
  function XMLStrToCurrencyDef(nodeValue: XmlString; defaultValue: Currency): Currency;
  function XMLStrToInt(nodeValue: XmlString; var value: integer): boolean; overload;
  function XMLStrToInt(nodeValue: XmlString): integer; overload;
  function XMLStrToIntDef(nodeValue: XmlString; defaultValue: integer): integer;
  function XMLStrToInt64(nodeValue: XmlString; var value: int64): boolean; overload;
  function XMLStrToInt64(nodeValue: XmlString): int64; overload;
  function XMLStrToInt64Def(nodeValue: XmlString; defaultValue: int64): int64;
  function XMLStrToBool(nodeValue: XmlString; var value: boolean): boolean; overload;
  function XMLStrToBool(nodeValue: XmlString): boolean; overload;
  function XMLStrToBoolDef(nodeValue: XmlString; defaultValue: boolean): boolean;
  function XMLStrToDateTime(nodeValue: XmlString; var value: TDateTime): boolean; overload;
  function XMLStrToDateTime(nodeValue: XmlString): TDateTime; overload;
  function XMLStrToDateTimeDef(nodeValue: XmlString; defaultValue: TDateTime): TDateTime;
  function XMLStrToDate(nodeValue: XmlString; var value: TDateTime): boolean; overload;
  function XMLStrToDate(nodeValue: XmlString): TDateTime; overload;
  function XMLStrToDateDef(nodeValue: XmlString; defaultValue: TDateTime): TDateTime;
  function XMLStrToTime(nodeValue: XmlString; var value: TDateTime): boolean; overload;
  function XMLStrToTime(nodeValue: XmlString): TDateTime; overload;
  function XMLStrToTimeDef(nodeValue: XmlString; defaultValue: TDateTime): TDateTime;
  function XMLStrToBinary(nodeValue: XmlString; const value: TStream): boolean;

  {:Creates the node if it doesn't exist, then sets node CDATA to the specified
    value.
  }

  {:A family of functions used to convert value to string according to the
    conversion rules used in this unit. Used in Set* functions above.
  }
  function XMLRealToStr(value: real; precision: byte = 15): XmlString;
  function XMLExtendedToStr(value: extended): XmlString;
  function XMLCurrencyToStr(value: Currency): XmlString;
  function XMLIntToStr(value: integer): XmlString;
  function XMLInt64ToStr(value: int64): XmlString;
  function XMLBoolToStr(value: boolean; useBoolStrs: boolean = false): XmlString;
  function XMLDateTimeToStr(value: TDateTime): XmlString;
  function XMLDateTimeToStrEx(value: TDateTime): XmlString;
  function XMLDateToStr(value: TDateTime): XmlString;
  function XMLTimeToStr(value: TDateTime): XmlString;
  function XMLBinaryToStr(value: TStream): XmlString;
  function XMLVariantToStr(value: Variant): XmlString;







implementation

{$IFDEF MSWINDOWS}
uses
  Registry;
{$ENDIF}

const
  DEFAULT_DECIMALSEPARATOR  = '.'; // don't change!
  DEFAULT_TRUE              = '1'; // don't change!
  DEFAULT_TRUE_STR          = 'true'; // don't change!
  DEFAULT_FALSE             = '0'; // don't change!
  DEFAULT_FALSE_STR         = 'false'; // don't change!
  DEFAULT_DATETIMESEPARATOR = 'T'; // don't change!
  DEFAULT_DATESEPARATOR     = '-'; // don't change!
  DEFAULT_TIMESEPARATOR     = ':'; // don't change!
  DEFAULT_MSSEPARATOR       = '.'; // don't change!

function DecimalSeparator: char;
begin
  {$IFDEF CONDITIONALEXPRESSIONS}
    {$IF RTLVersion >= 22.0}  // Delphi XE
    Result := FormatSettings.DecimalSeparator;
    {$ELSE}
    Result := SysUtils.DecimalSeparator;  // Delphi 2010 and below
    {$IFEND}
  {$ELSE}
  Result := SysUtils.DecimalSeparator;
  {$ENDIF}  // CONDITIONALEXPRESSIONS
end; { DecimalSeparator }

{:Convert time from string (ISO format) to TDateTime.
}
function Str2Time(s: string): TDateTime;
var
  hour  : word;
  minute: word;
  msec  : word;
  p     : integer;
  second: word;
begin
  s := Trim(s);
  if s = '' then
    Result := 0
  else begin
    p := Pos(DEFAULT_TIMESEPARATOR,s);
    hour := StrToInt(Copy(s,1,p-1));
    Delete(s,1,p);
    p := Pos(DEFAULT_TIMESEPARATOR,s);
    minute := StrToInt(Copy(s,1,p-1));
    Delete(s,1,p);
    p := Pos(DEFAULT_MSSEPARATOR,s);
    if p > 0 then begin
      msec := StrToInt(Copy(s,p+1,Length(s)-p));
      Delete(s,p,Length(s)-p+1);
    end
    else
      msec := 0;
    second := StrToInt(s);
    Result := EncodeTime(hour,minute,second,msec);
  end;
end; { Str2Time }

{:Convert date/time from string (ISO format) to TDateTime.
}
function ISODateTime2DateTime (const ISODT: String): TDateTime;
var
  day   : word;
  month : word;
  p     : integer;
  sDate : string;
  sTime : string;
  year  : word;
begin
  p := Pos (DEFAULT_DATETIMESEPARATOR,ISODT);
  // detect all known date/time formats
  if (p = 0) and (Pos(DEFAULT_DATESEPARATOR, ISODT) > 0) then
    p := Length(ISODT) + 1;
  sDate := Trim(Copy(ISODT,1,p-1));
  sTime := Trim(Copy(ISODT,p+1,Length(ISODT)-p));
  Result := 0;
  if sDate <> '' then begin
    p := Pos (DEFAULT_DATESEPARATOR,sDate);
    year :=  StrToInt(Copy(sDate,1,p-1));
    Delete(sDate,1,p);
    p := Pos (DEFAULT_DATESEPARATOR,sDate);
    month :=  StrToInt(Copy(sDate,1,p-1));
    day := StrToInt(Copy(sDate,p+1,Length(sDate)-p));
    Result := EncodeDate(year,month,day);
  end;
  Result := Result + Frac(Str2Time(sTime));
end; { ISODateTime2DateTime }


function IsDocument(node: IXMLNode): boolean;
var
  docNode: IXMLDocument;
begin
  Result := Supports(node, IXMLDocument, docNode);
end; { IsDocument }

{:@since   2003-01-13
}
function OwnerDocument(node: IXMLNode): IXMLDocument;
begin
  if not Supports(node, IXMLDocument, Result) then
    Result := node.OwnerDocument;
end; { OwnerDocument }


function XMLStrToReal(nodeValue: XmlString; var value: real): boolean;
begin
  try
    value := XMLStrToReal(nodeValue);
    Result := true;
  except
    on EConvertError do
      Result := false;
  end;
end; { XMLStrToReal }

function XMLStrToReal(nodeValue: XmlString): real;
begin
  Result := StrToFloat(StringReplace(nodeValue, DEFAULT_DECIMALSEPARATOR,
    DecimalSeparator, [rfReplaceAll]));
end; { XMLStrToReal }

function XMLStrToRealDef(nodeValue: XmlString; defaultValue: real): real;
begin
  if not XMLStrToReal(nodeValue,Result) then
    Result := defaultValue;
end; { XMLStrToRealDef }

function XMLStrToExtended(nodeValue: XmlString; var value: extended): boolean;
begin
  try
    value := XMLStrToExtended(nodeValue);
    Result := true;
  except
    on EConvertError do
      Result := false;
  end;
end; { XMLStrToExtended }

function XMLStrToExtended(nodeValue: XmlString): extended;
begin
  try
    Result := StrToFloat(StringReplace(nodeValue, DEFAULT_DECIMALSEPARATOR,
      DecimalSeparator, [rfReplaceAll]));
  except
    on EConvertError do begin
      if (nodeValue = 'INF') or (nodeValue = '+INF') then 
        Result := 1.1e+4932
      else if nodeValue = '-INF' then
        Result := 3.4e-4932
      else
        raise;
    end;
  end;
end; { XMLStrToExtended }

function XMLStrToExtendedDef(nodeValue: XmlString; defaultValue: extended): extended;
begin
  if not XMLStrToExtended(nodeValue, Result) then
    Result := defaultValue;
end; { XMLStrToExtendedDef }

function StrToCurr(const S: string): Currency;
begin
  TextToFloat(PChar(S), Result, fvCurrency);
end; { StrToCurr }

function XMLStrToCurrency(nodeValue: XmlString; var value: Currency): boolean;
begin
  try
    value := XMLStrToCurrency(nodeValue);
    Result := true;
  except
    on EConvertError do
      Result := false;
  end;
end; { XMLStrToCurrency }

function XMLStrToCurrency(nodeValue: XmlString): Currency;
begin
  Result := StrToCurr(StringReplace(nodeValue, DEFAULT_DECIMALSEPARATOR,
    DecimalSeparator, [rfReplaceAll]));
end; { XMLStrToCurrency }

function XMLStrToCurrencyDef(nodeValue: XmlString; defaultValue: Currency): Currency;
begin
  if not XMLStrToCurrency(nodeValue, Result) then
    Result := defaultValue;
end; { XMLStrToCurrencyDef }

function XMLStrToInt(nodeValue: XmlString; var value: integer): boolean;
begin
  try
    value := XMLStrToInt(nodeValue);
    Result := true;
  except
    on EConvertError do
      Result := false;
  end;
end; { XMLStrToInt }

function XMLStrToInt(nodeValue: XmlString): integer;
begin
  Result := StrToInt(nodeValue);
end; { XMLStrToInt }

function XMLStrToIntDef(nodeValue: XmlString; defaultValue: integer): integer;
begin
  if not XMLStrToInt(nodeValue,Result) then
    Result := defaultValue;
end; { XMLStrToIntDef }

function XMLStrToInt64(nodeValue: XmlString; var value: int64): boolean;
begin
  try
    value := XMLStrToInt64(nodeValue);
    Result := true;
  except
    on EConvertError do
      Result := false;
  end;
end; { XMLStrToInt64 }

function XMLStrToInt64(nodeValue: XmlString): int64;
begin
  Result := StrToInt64(nodeValue);
end; { XMLStrToInt64 }

function XMLStrToInt64Def(nodeValue: XmlString; defaultValue: int64): int64;
begin
  if not XMLStrToInt64(nodeValue,Result) then
    Result := defaultValue;
end; { XMLStrToInt64Def }

function XMLStrToBool(nodeValue: XmlString; var value: boolean): boolean;
begin
  if (nodeValue = DEFAULT_TRUE) or (nodeValue = DEFAULT_TRUE_STR) then begin
    value := true;
    Result := true;
  end
  else if (nodeValue = DEFAULT_FALSE) or (nodeValue = DEFAULT_FALSE_STR) then begin
    value := false;
    Result := true;
  end
  else
    Result := false;
end; { XMLStrToBool }

function XMLStrToBool(nodeValue: XmlString): boolean; overload;
begin
  if not XMLStrToBool(nodeValue, Result) then
    raise EmaxXMLUtils.CreateFmt('%s is not a boolean value', [nodeValue]);
end; { XMLStrToBool }

function XMLStrToBoolDef(nodeValue: XmlString; defaultValue: boolean): boolean;
begin
  if not XMLStrToBool(nodeValue,Result) then
    Result := defaultValue;
end; { XMLStrToBoolDef }

function XMLStrToDateTime(nodeValue: XmlString; var value: TDateTime): boolean;
begin
  try
    value := ISODateTime2DateTime(nodeValue);
    Result := true;
  except
    Result := false;
  end;
end; { XMLStrToDateTime }

function XMLStrToDateTime(nodeValue: XmlString): TDateTime;
begin
  if not XMLStrToDateTime(nodeValue, Result) then
    raise EmaxXMLUtils.CreateFmt('%s is not an ISO datetime value', [nodeValue]);
end; { XMLStrToDateTime }

function XMLStrToDateTimeDef(nodeValue: XmlString; defaultValue: TDateTime): TDateTime;
begin
  if not XMLStrToDateTime(nodeValue,Result) then
    Result := defaultValue;
end; { XMLStrToDateTimeDef }

function XMLStrToDate(nodeValue: XmlString; var value: TDateTime): boolean;
begin
  try
    value := Int(ISODateTime2DateTime(nodeValue));
    Result := true;
  except
    Result := false;
  end;
end; { XMLStrToDate }

function XMLStrToDate(nodeValue: XmlString): TDateTime;
begin
  if not XMLStrToDate(nodeValue, Result) then
    raise EmaxXMLUtils.CreateFmt('%s is not an ISO date value', [nodeValue]);
end; { XMLStrToDate }

function XMLStrToDateDef(nodeValue: XmlString; defaultValue: TDateTime): TDateTime;
begin
  if not XMLStrToDate(nodeValue,Result) then
    Result := defaultValue;
end; { XMLStrToDateDef }

function XMLStrToTime(nodeValue: XmlString; var value: TDateTime): boolean;
begin
  try
    value := Str2Time(nodeValue);
    Result := true;
  except
    Result := false;
  end;
end; { XMLStrToTime }

function XMLStrToTime(nodeValue: XmlString): TDateTime;
begin
  if not XMLStrToTime(nodeValue, Result) then
    raise EmaxXMLUtils.CreateFmt('%s is not a time value', [nodeValue]);
end; { XMLStrToTime }

function XMLStrToTimeDef(nodeValue: XmlString; defaultValue: TDateTime): TDateTime;
begin
  if not XMLStrToTime(nodeValue,Result) then
    Result := defaultValue;
end; { XMLStrToTimeDef }

function XMLStrToBinary(nodeValue: XmlString; const value: TStream): boolean;
var
  nodeStream: TStringStream;
begin
  value.Size := 0;
  nodeStream := TStringStream.Create(nodeValue);
  try
    //Result := Base64Decode(nodeStream, value);
  finally FreeAndNil(nodeStream); end;
end; { XMLStrToBinary }

{:@since   2003-12-12
}        


function XMLRealToStr(value: real; precision: byte = 15): XmlString;
begin
  Result := StringReplace(FloatToStrF(value, ffGeneral, precision, 0),
    DecimalSeparator, DEFAULT_DECIMALSEPARATOR, [rfReplaceAll]);
end; { XMLRealToStr }

function XMLExtendedToStr(value: extended): XmlString;
begin
  Result := StringReplace(FloatToStr(value),
    DecimalSeparator, DEFAULT_DECIMALSEPARATOR, [rfReplaceAll]);
end; { XMLExtendedToStr }

function XMLCurrencyToStr(value: Currency): XmlString;
begin
  Result := StringReplace(CurrToStr(value),
    DecimalSeparator, DEFAULT_DECIMALSEPARATOR, [rfReplaceAll]);
end; { XMLExtendedToStr }

function XMLIntToStr(value: integer): XmlString;
begin
  Result := IntToStr(value);
end; { XMLIntToStr }

function XMLInt64ToStr(value: int64): XmlString;
begin
  Result := IntToStr(value)
end; { XMLInt64ToStr }

function XMLBoolToStr(value: boolean; useBoolStrs: boolean = false): XmlString;
begin
  if value then
    if useBoolStrs then
      Result := DEFAULT_TRUE_STR
    else
      Result := DEFAULT_TRUE
  else
    if useBoolStrs then
      Result := DEFAULT_FALSE_STR
    else
      Result := DEFAULT_FALSE;
end; { XMLBoolToStr }

function XMLDateTimeToStr(value: TDateTime): XmlString;
begin
  if Trunc(value) = 0 then
    Result := FormatDateTime('"'+DEFAULT_DATETIMESEPARATOR+'"hh":"mm":"ss.zzz',value)
  else
    Result := FormatDateTime('yyyy-mm-dd"'+
      DEFAULT_DATETIMESEPARATOR+'"hh":"mm":"ss.zzz',value);
end; { XMLDateTimeToStr }

function XMLDateTimeToStrEx(value: TDateTime): XmlString;
begin
  if Trunc(value) = 0 then
    Result := XMLTimeToStr(value)
  else if Frac(Value) = 0 then
    Result := XMLDateToStr(value)
  else
    Result := XMLDateTimeToStr(value);
end; { XMLDateTimeToStrEx }

function XMLDateToStr(value: TDateTime): XmlString;
begin
  Result := FormatDateTime('yyyy-mm-dd',value);
end; { XMLDateToStr }

function XMLTimeToStr(value: TDateTime): XmlString;
begin
  Result := FormatDateTime('hh":"mm":"ss.zzz',value);
end; { XMLTimeToStr }

function XMLBinaryToStr(value: TStream): XmlString;
var
  nodeStream: TStringStream;
begin
  value.Position := 0;
  nodeStream := TStringStream.Create('');
  try
    //Base64Encode(value, nodeStream);
    Result := nodeStream.DataString;
  finally FreeAndNil(nodeStream); end;
end; { XMLBinaryToStr }

function XMLVariantToStr(value: Variant): XmlString;
begin
  case VarType(value) of
    varSingle, varDouble, varCurrency:
      Result := XMLExtendedToStr(value);
    varDate:
      Result := XMLDateTimeToStrEx(value);
    varBoolean:
      Result := XMLBoolToStr(value);
    else
      Result := value;
  end; //case
end; { XMLVariantToStr }




end.
