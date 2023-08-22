{ jcontrolutils

  Copyright (C) 2011 Julio Jiménez Borreguero
  Contact: jujibo at gmail dot com

  This library is free software; you can redistribute it and/or modify it
  under the same terms as the Lazarus Component Library (LCL)

  See the file license-jujiboutils.txt and COPYING.LGPL, included in this distribution,
  for details about the license.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

}

unit jcontrolutils;

//{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

function CountChar(const s: string; ch: char): integer;
procedure Split(const Delimiter: char; Input: string; Strings: TStrings);
function NormalizeDate(const Value: string; theValue: TDateTime;
  const theFormat: string = ''): string;
function NormalizeTime(const Value: string; theValue: TDateTime;
  const theFormat: string = ''): string;
function NormalizeDateTime(const Value: string; theValue: TDateTime;
  const theFormat: string = ''): string;
function NormalizeDateSeparator(const s: string): string;
function IsValidDateString(const Value: string): boolean;
function IsValidTimeString(const Value: string): boolean;
function IsValidDateTimeString(const Value: string): boolean;

implementation

{$R JCalendarIcon.res}  //==== 9999 ====
{$R sensors.res}  //==== png rcdata====
{$R ledbuttons.res}  //==== png 9999 ====
{$R moonimages.res}  //==== png rcdata====




function CountChar(const s: string; ch: char): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 1 to length(s) do
    if s[i] = ch then
      Inc(Result);
end;

procedure Split(const Delimiter: char; Input: string; Strings: TStrings);
begin
  Assert(Assigned(Strings));
  Strings.Clear;
  Strings.Delimiter := Delimiter;
  Strings.DelimitedText := Input;
end;

function NormalizeDate(const Value: string; theValue: TDateTime;
  const theFormat: string): string;
var
  texto: string;
  d, m, y: word;
  ds, ms, ys: string;
  aDate: TDateTime;
  tokens: TStringList;
  aDateFormat: string;
  aChar: char;

  procedure LittleEndianForm;
  begin
    // Note: only numeric input allowed (months names not implemented)
    if tokens[0] <> '' then
      ds := tokens[0];
    if (tokens.Count > 1) and (tokens[1] <> '') then
      ms := tokens[1];
    if (tokens.Count > 2) and (tokens[2] <> '') then
      ys := tokens[2];
    texto := ds + DateSeparator + ms + DateSeparator + ys;
  end;

  procedure MiddleEndianForm;
  begin
    if tokens[0] <> '' then
      ms := tokens[0];
    if (tokens.Count > 1) and (tokens[1] <> '') then
      ds := tokens[1];
    if (tokens.Count > 2) and (tokens[2] <> '') then
      ys := tokens[2];
    texto := ms + DateSeparator + ds + DateSeparator + ys;
  end;

  procedure BigEndianForm;
  begin
    if tokens[0] <> '' then
      ys := tokens[0];
    if (tokens.Count > 1) and (tokens[1] <> '') then
      ms := tokens[1];
    if (tokens.Count > 2) and (tokens[2] <> '') then
      ds := tokens[2];
    texto := ys + DateSeparator + ms + DateSeparator + ds;
  end;

begin
  if theFormat = '' then
    aDateFormat := ShortDateFormat
  else
    aDateFormat := theFormat;
  if theValue = 0 then
    DecodeDate(Now, y, m, d)
  else
    decodedate(theValue, y, m, d);
  ds := IntToStr(d);
  ms := IntToStr(m);
  ys := IntToStr(y);
  texto := Value;
  texto := NormalizeDateSeparator(texto);
  Result := texto;   // default value
  tokens := TStringList.Create;
  Split(DateSeparator, texto, tokens);
  if tokens.Count > 0 then
  begin
    aChar := aDateFormat[1];
    case aChar of
      'd', 'D': LittleEndianForm;
      'm', 'M': MiddleEndianForm;
      'y', 'Y': BigEndianForm;
    end;

    if IsValidDateString(texto) then
    begin
      aDate := StrToDate(texto);
      Result := FormatDateTime(aDateFormat, aDate);
    end;
  end;
  tokens.Free;
end;

function NormalizeTime(const Value: string; theValue: TDateTime;
  const theFormat: string): string;
var
  hh, mm, ss, ms: word;
  hhs, mms, sss, mss: string;
  texto: string;
  aTimeFormat: string;
  aTime: TDateTime;
  tokens: TStringList;

  function TimeString: string;
  begin
    Result := hhs + TimeSeparator + mms + TimeSeparator + sss;// + TimeSeparator + mss;
  end;

  procedure TimeForm;
  begin
    if tokens[0] <> '' then
      hhs := tokens[0];
    if (tokens.Count > 1) and (tokens[1] <> '') then
      mms := tokens[1];
    if (tokens.Count > 2) and (tokens[2] <> '') then
      sss := tokens[2];
    if (tokens.Count > 3) and (tokens[3] <> '') then
      mss := tokens[3];
    texto := TimeString;
  end;

begin
  if theFormat = '' then
    aTimeFormat := ShortTimeFormat
  else
    aTimeFormat := theFormat;
  if theValue = 0 then
  begin
    DecodeTime(Now, hh, mm, ss, ms);
  end
  else
  begin
    DecodeTime(theValue, hh, mm, ss, ms);
  end;

  hhs := IntToStr(hh);
  mms := IntToStr(mm);
  sss := IntToStr(ss);
  mss := IntToStr(ms);
  texto := Value;
  Result := texto; // default value
  tokens := TStringList.Create;
  Split(TimeSeparator, texto, tokens);
  if tokens.Count > 0 then
  begin
    TimeForm;
    if IsValidTimeString(texto) then
    begin
      aTime := StrToTime(texto);
      Result := TimeString;// FormatDateTime(aTimeFormat, aTime);
    end
  end;
  tokens.Free;
  //ShowMessage('Hora normalizada: ' + Result);
end;

function NormalizeDateTime(const Value: string; theValue: TDateTime;
  const theFormat: string): string;
var
  tokens: TStringList;
  theDateTime: TDateTime;
  dateString, timeString: string;
begin
  if theValue = 0 then
    theDateTime := Now
  else
    theDateTime := theValue;
  Result := '';
  tokens := TStringList.Create;
  Split(' ', Value, tokens);
  if tokens.Count > 1 then
  begin
    if tokens[0] <> '' then
      dateString := tokens[0];
    if tokens[1] <> '' then
      timeString := tokens[1];
    dateString := NormalizeDate(dateString, theDateTime);
    timeString := NormalizeTime(timeString, theDateTime);
    if IsValidDateString(dateString) and IsValidTimeString(timeString) then
      Result := dateString + ' ' + timeString;
  end;
  tokens.Free;
end;

function NormalizeDateSeparator(const s: string): string;
var
  i: integer;
begin
  Result := s;
  for i := 1 to length(Result) do
    if Result[i] in ['.', ',', '/', '-'] then  // valid date separators
      Result[i] := DateSeparator;
end;

function IsValidDateString(const Value: string): boolean;
var
  bTime: TDateTime;
begin
  Result:= TryStrToDate(Value, bTime);
end;

function IsValidTimeString(const Value: string): boolean;
var
  bTime: TDateTime;
begin
  Result := TryStrToTime(Value, bTime);
end;

function IsValidDateTimeString(const Value: string): boolean;
var
  bTime: TDateTime;
begin
  Result := TryStrToDateTime(Value, bTime);
end;

end.

