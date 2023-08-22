unit xrtl_util_TimeUtils;

{$INCLUDE xrtl.inc}

interface

uses
  Windows, SysUtils;

function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
function DateTimeToFileTime(DateTime: TDateTime): TFileTime;
function GMTNow: TDateTime;
function GMTToLocalTime(GMT: TDateTime): TDateTime;
function LocalTimeToGMT(LocalTime: TDateTime): TDateTime;

const
  HoursPerDay = 24;
  MinsPerDay = HoursPerDay * 60;

var
  TimeZoneInfoTimeout: Integer = 30; // seconds

implementation

function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
  SystemTime: TSystemTime;
begin
  ZeroMemory(@SystemTime, SizeOf(SystemTime));
  FileTimeToSystemTime(FileTime, SystemTime);
  Result:= SystemTimeToDateTime(SystemTime);
end;

function DateTimeToFileTime(DateTime: TDateTime): TFileTime;
var
  SystemTime: TSystemTime;
begin
  ZeroMemory(@SystemTime, SizeOf(SystemTime));
  DateTimeToSystemTime(DateTime, SystemTime);
  SystemTimeToFileTime(SystemTime, Result);
end;

var
  TZBias: TDateTime = 0;
  TimeZoneInfoTimestamp: TDateTime = 0;

function MinutesToDateTime(Minutes: Single): Single;
begin
  Result:= Minutes / MinsPerDay;
end;

procedure InitTimeZoneInfo;
var
  TZI: TTimeZoneInformation;
  R: Cardinal;
begin
  R:= GetTimeZoneInformation(TZI);
  case R of
    TIME_ZONE_ID_STANDARD: TZBias:= MinutesToDateTime(TZI.Bias + TZI.StandardBias);
    TIME_ZONE_ID_DAYLIGHT: TZBias:= MinutesToDateTime(TZI.Bias + TZI.DaylightBias);
  else
  end;
  TimeZoneInfoTimestamp:= Now;
end;

procedure CheckTimeZoneInfo;
begin
  if Abs(Now - TimeZoneInfoTimestamp) * SecsPerDay > TimeZoneInfoTimeOut then
    InitTimeZoneInfo; 
end;

function LocalTimeToGMT(LocalTime: TDateTime): TDateTime;
begin
  CheckTimeZoneInfo;
  Result:= LocalTime + TZBias;
end;

function GMTToLocalTime(GMT: TDateTime): TDateTime;
begin
  CheckTimeZoneInfo;
  Result:= GMT - TZBias;
end;

function GMTNow: TDateTime;
begin
  Result:= LocalTimeToGMT(Now);
end;

initialization
begin
  TZBias:= 0;
  InitTimeZoneInfo;
end;

end.
