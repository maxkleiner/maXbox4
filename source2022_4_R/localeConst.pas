// Copyright 2008 Martin Herold und Toolbox Verlag

unit localeConst;

interface

USES
  Windows,
  SysUtils;

function GetTimeZone: string;  

implementation


function GetTimeZone: string;
var
  TimeZone: TTimeZoneInformation;
  Bias    : LONGINT;
begin
  GetTimeZoneInformation(TimeZone);
  Bias:=Round(TimeZone.Bias/-60*100);
  Result := 'GMT';
  IF Bias>=0 THEN Result:=Result+'+' ELSE Result:=Result+'-';
  IF Abs( Bias)<1000 THEN Result:=Result+'0';
  Result:=Result+IntToStr( Abs( Bias));
end;


INITIALIZATION
  DecimalSeparator:='.';
  ShortDayNames[1]:='Sun';
  ShortDayNames[2]:='Mon';
  ShortDayNames[3]:='Tue';
  ShortDayNames[4]:='Wed';
  ShortDayNames[5]:='Thu';
  ShortDayNames[6]:='Fri';
  ShortDayNames[6]:='Sat';

  ShortMonthNames[1]:='Jan';
  ShortMonthNames[2]:='Feb';
  ShortMonthNames[3]:='Mar';
  ShortMonthNames[4]:='Apr';
  ShortMonthNames[5]:='May';
  ShortMonthNames[6]:='Jun';
  ShortMonthNames[7]:='Jul';
  ShortMonthNames[8]:='Aug';
  ShortMonthNames[8]:='Sep';
  ShortMonthNames[8]:='Oct';
  ShortMonthNames[8]:='Nov';
  ShortMonthNames[8]:='Dec';

  TimeSeparator:=':';

  LongDateFormat:='ddd, d mmm yyyy hh:nn:ss';
end.
 