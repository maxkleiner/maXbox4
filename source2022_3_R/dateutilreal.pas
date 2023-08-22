{
    $Id: dateutil.pas,v 1.12 2006/12/07 02:53:38 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere (Optima SC Inc.)

    Date and time utility routines     adapt to maXbox4

    See License.txt for more information on the licensing terms
    for this source code.

 **********************************************************************}
{** @author(Carl Eric Codere)
    @abstract(Date and time utility routines)

    This unit is quite similar to the unit dateutils provided
    with Delphi 6 and Delphi 7. Only a subset of the API found
    in those units is implemented in this unit, furthermore it
    contains a new set of extended API's included in the 
    dateexth.inc file.

    There are subtle differences with the Delphi implementation:
    1. All string related parameters and function results use ISO 8601
    formatted date and time strings. 
    2. The internal format of TDatetime is not the same as on the Delphi
    compilers (Internally TDateTime is stored as a Julian date)
    3. The milliseconds field is only an approximation, and should not
    be considered as accurate.
    4. Becasue everything is coded with floats, the seconds field has
    a precision of +/- 2 seconds.

    All dates are assumed to be in Gregorian calendar date
    format (This is a proleptic Gregorian calendar unit).

}
unit dateutilreal;

interface

//uses
//{$IFDEF VPASCAL}
// use32;
//{$ENDIF}
 {tpautils,
 dpautils,
 fpautils,
 vpautils }
 //;

type
 {** This is the Julian Day number }
 TDatetimeReal = real;
 {** Useful structure that contains additional information on a date and time }
 TDateInfo = record
   {** Actual date and time value }
   DateTime: TDatetimeReal;
   {** Is this value local or according to UTC? }
   UTC: boolean;
 end;

 TYPE
    { The biggest integer type available to this compiler }
    big_integer_t = int64;
    Integer = longint;

 float = real;
 
{$IFDEF VPASCAL}
   platformword = use32.word;
{$ELSE}
   platformword = system.word;
{$ENDIF}

{ Provide symbolic constants for ISO 8601-compliant day of the week values. }
const
  DayMonday = 1;
  DayTuesday = 2;
  DayWednesday = 3;
  DayThursday = 4;
  DayFriday = 5;
  DaySaturday = 6;
  DaySunday = 7;

{** @abstract(Returns the current year) }
function CurrentYear: word;

{** @abstract(Returns the current date, with the time value equal to midnight.) }
function Date: TDatetimeReal;

{** @abstract(Strips the time portion from a TDateTime value.)}
function DateOf(const AValue: TDatetimeReal): TDatetimeReal;

{** @abstract(Converts a TDateTime value to a string in extended ISO 8601 date and time representation.)

    Returns the extended format representation of a date and time as recommended
    by ISO 8601 (Gregorian Calendar). The extended format ISO 8601 representation
    is of the form: YYYY-MM-DDThh:mm:ss
}
function DateTimeToStr(DateTime: TDatetimeReal): string;

{** @abstract(Converts a TDateTime value to a string in extended ISO 8601 date representation.)

    Returns the extended format representation of a date as recommended
    by ISO 8601 (Gregorian Calendar). The extended format ISO 8601 representation
    is of the form: YYYY-MM-DD
}
function DateToStr(date: TDatetimeReal): string;

{** @abstract(Returns the day of the month represented by a TDateTime value.)}
function DayOf(const AValue: TDatetimeReal): Word;

{** @abstract(Returns the number of days between two specified TDateTime values.)}
function DaysBetween(const ANow, AThen: TDatetimeReal): integer;

{** @abstract(Returns Year, Month, and Day values for a TDateTime value.) }
procedure DecodeDate(Date: TDatetimeReal; var Year, Month, Day: Word);

{** @abstract(Returns Year, Month, Day, Hour, Minute, Second, and Millisecond values for a TDateTime.) }
procedure DecodeDateTime(const AValue: TDatetimeReal; var Year, Month, Day, Hour, Minute, Second, MilliSecond: Word);

{** @abstract(Breaks a TDateTime value into hours, minutes, seconds, and milliseconds.)}
procedure DecodeTime(Time: TDatetimeReal; var Hour, Min, Sec, MSec: Word);

{** @abstract(Returns the hour of the day represented by a TDateTime value.)}
function HourOf(const AValue: TDatetimeReal): Word;

{** @abstract(Returns a date shifted by a specified number of days.)}
function IncDay(const AValue: TDatetimeReal; const ANumberOfDays: Integer): TDatetimeReal;

{** @abstract(Returns a date/time value shifted by a specified number of hours.) }
function IncHour(const AValue: TDatetimeReal; const ANumberOfHours: longint): TDatetimeReal;

{** @abstract(Returns a date/time value shifted by a specified number of milliseconds.)}
function IncMilliSecond(const AValue: TDatetimeReal; const ANumberOfMilliSeconds: big_integer_t): TDatetimeReal;

{** @abstract(Returns a date/time value shifted by a specified number of minutes.) }
function IncMinute(const AValue: TDatetimeReal; const ANumberOfMinutes: big_integer_t): TDatetimeReal;

{** @abstract(Returns a date/time value shifted by a specified number of seconds.)}
function IncSecond(const AValue: TDatetimeReal; const ANumberOfSeconds: big_integer_t): TDatetimeReal;

{** @abstract(Returns a date shifted by a specified number of weeks.)}
function IncWeek(const AValue: TDatetimeReal; const ANumberOfWeeks: Integer): TDatetimeReal;

{** @abstract(Indicates whether the time portion of a specified TDateTime value occurs after noon.)}
function IsPM(const AValue: TDatetimeReal): Boolean;

{** @abstract(Indicates whether a specified year, month, and day represent a valid date.) }
function IsValidDate(const AYear, AMonth, ADay: Word): Boolean;

{** @abstract(Indicates whether a specified year, month, day,
     hour, minute, second, and millisecond represent a valid date and time.) }
function IsValidDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;

{** @abstract(Indicates whether a specified hour, minute, second, and millisecond represent a valid date and time.) }
function IsValidTime(const AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;


{** @abstract(Returns the minute of the hour represented by a TDateTime value.)}
function MinuteOf(const AValue: TDatetimeReal): Word;

{** @abstract(Returns the month of the year represented by a TDateTime value.)}
function MonthOf(const AValue: TDatetimeReal): Word;

{** @abstract(Returns the current date and time.)}
function Now: TDatetimeReal;


{** @abstract(Indicates whether two TDateTime values represent the same year, month, and day.)}
function SameDate(const A, B: TDatetimeReal): Boolean;

{** @abstract(Indicates whether two TDateTime values represent the same year, month, day, 
    hour, minute, second, and millisecond.)}
function SameDateTime(const A, B: TDatetimeReal): Boolean;

{** @abstract(Indicates whether two TDateTime values represent the same time of day, ignoring the date portion.)}
function SameTime(const A, B: TDatetimeReal): Boolean;

{** @abstract(Returns the second of the minute represented by a TDateTime value.)}
function SecondOf(const AValue: TDatetimeReal): Word;

{** @abstract(Returns the current time.)}
function Time: TDatetimeReal;
{** @abstract(Returns the current time.)}
function GetTime: TDatetimeReal;

{** @abstract(Strips the date portion from a TDatetime value) }
function TimeOf(const AValue: TDatetimeReal): TDatetimeReal;

{** @abstract(Converts a TDateTime value to a string in extended ISO 8601 time representation.)

    Returns the extended format representation of a time as recommended
    by ISO 8601 (Gregorian Calendar). The extended format ISO 8601 representation
    is of the form: hh:mm:ss.
}
function TimeToStr(Time: TDatetimeReal): string;

{** @abstract(Returns a TDateTime value that represents the current date.) }
function Today: TDatetimeReal;

{** @abstract(Returns a TDateTime value that represents a specified Year, Month, and Day.)}
function TryEncodeDate(Year, Month, Day: Word; var Date: TDatetimeReal): Boolean;

{** @abstract(Returns a TDateTime value for a specified Hour, Min, Sec, and MSec.) }
function TryEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDatetimeReal): Boolean;

{** @abstract(Returns a TDateTime that represents a specified year, month, day, hour, minute, second, and millisecond.) }
function TryEncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
   var AValue: TDatetimeReal): Boolean;

{** @abstract(Converts a string of date in ISO 8601 to a TDateTime value, with a Boolean success code.)

    In the case where the date does not contain the full representation
    of a date (for examples, YYYY or YYYY-MM), then the missing values
    will be set to 1 to be legal. 
    
    Most legal dates for Dates of ISO 8601 are supported by this routine.
}
function TryStrToDate(const S: string; var Value: TDatetimeReal): Boolean;

{** @abstract(Converts a string date-time representation to a TDateTime value with a Boolean success code.)

    Supported formats:
    1) Format of Complete Representation for calendar dates
    (as specified in ISO 8601), which should include the Time
    designator character.
    2) Format: 'YYYY-MM-DD HH:mm:ss [GMT|UTC|UT]'
    3) Openoffice 1.1.x HTML date format: 'YYYYMMDD;HHmmssuu'
    4) Adobe PDF 'D:YYYYMMDDHHMMSSOHH'mm'' format

    The returned value will be according to UTC if timezone
    information is uncluded, otherwise, it will be left as is.
    To determine if the value was actually converted to UTC,
    use TryStrToDateTimeExt.

    In the case where the date does not contain the full representation
    of a date (for examples, YYYY or YYYY-MM), then the missing values
    will be set to 1 to be legal.

}
function TryStrToDateTime(const S: string; var Value: TDatetime): Boolean;

{** @abstract(Converts a string time to a TDateTime value with an error default)

    Supported formats:
    1) ISO 8601 time format (complete representation) with
       optional timezone designators.
    2) Format: 'HH:mm:ss [GMT|UTC|UT]'
    3) Openoffice 1.1.x HTML time format: 'HHmmssuu'
    4) Adobe PDF 'D:YYYYMMDDHHMMSSOHH'mm'' format

    The returned value will be according to UTC
    if timezone information is specified. The Date field is
    truncated and is equal to zero upon return.
}
function TryStrToTime(const S: string; var Value: TDatetimeReal): Boolean;

{** @abstract(Returns the year represented by a TDateTime value.)}
function YearOf(const AValue: TDatetimeReal): Word;

function parsetimeISO(timestr: string; var hourval,minval, secval: word;
  var offsethourval,offsetminval:integer; var UTC: boolean): boolean;

function parsedateISO(datestr:string; var yearval,
 monthval,dayval: word): boolean;

 function datetojd(year,month,day,hour,minute,second,millisecond: word): float;

 procedure jdtodate (jday : float; var
  year,month,day,hour,minute,second,msec: word);

 function converttoisotime(timestr: string): string;
 
   function AdobeDateToISODate(s: string): string;

    function RFC822ToISODateTime(s:string): string;

    procedure getdatedos(var year,month,mday,wday : word);
    procedure gettimedos(var hour,minute,second,sec100 : word);




//{$i dateexth.inc}

implementation

uses {locale,dos,} xutils, sysutils, windows, dateext4;

{**************************************************************************}
{                          Local  routines                                 }
{**************************************************************************}

function isdigits(s: string):boolean;
var
 i: integer;
begin
 isdigits:=false;
 for I:=1 to length(s) do
   begin
     if not (s[i] in ['0'..'9']) then
        exit;
   end;
 isdigits:=true;
end;


{** Convert a Gregorian calendar date to a Julian Day (JD) }

function datetojd(year,month,day,hour,minute,second,millisecond: word): float;
var
 a: float;
 rjd:float;
 j1: float;
 h: float;
 s: float;
begin
    h := hour + (minute / 60.0) + (second / 3600.0) + (millisecond / (3600.0*1000));
    rjd:= -1 * trunc(7 * (trunc((month + 9.0) / 12.0) + year) / 4.0);
    s:=1;
    if month - 9.0 < 0 then
      s:=-1;
    a:=abs(month -9.0);
    j1:= trunc((year + S * trunc(a / 7.0)));
    J1 := -1 * trunc((trunc(J1 / 100) + 1) * 3.0 / 4.0);
    rjd := rjd + trunc(275 * month / 9.0) + day + (1 * J1);
    rjd := rjd + 1721027.0 + 2.0 + 367.0 * year - 0.5;
    rjd := rjd + (h / 24.0);
    datetojd:=rjd;
end;
(*
begin

   extra := 100.0*year + month - 190002.5;
   rjd := 367.0*year;
   rjd := rjd - trunc(7.0*(year+trunc((month+9.0)/12.0))/4.0);
   rjd := rjd + trunc(275.0*month/9.0) ;
   rjd := rjd +  day;

   { add hours }
   rjd := rjd + hour / 24.0;
   { add minutes }
   rjd := rjd + minute/(60*24.0);
   { add seconds }
   rjd := rjd + second/(60*60*24.0);
   { add milliseconds }
   rjd := rjd + millisecond/(60*60*24.0*1000);

   rjd := rjd + 1721013.5;
   rjd := rjd - 0.5*extra/abs(extra);
   rjd := rjd + 0.5;


   datetojd:=rjd;
end;*)


{** Convert a Julian Day (JD) to a Gregorial calendar date }
procedure jdtodate (jday : float; var
  year,month,day,hour,minute,second,msec: word);
{takes a Julian Day "jday" and converts to local date & time according
to the time zone "tzone" specified.  "jday" can have values from 0 up to
several million, and a fractional part, so it has to be Extended type.
"tzone" is NOT an Integer because some of us are afflicted with strange
time zones!  The use of "Trunc" may occasionally cause an error of one
minute in the returned time.

A test value : JD 2450450.0000 = 1997 Jan 01 12:00 UT }
var
 Z,F,A,B,D,I,RJ,RH: float;
 C,T: big_integer_t;
 Y: integer;
begin
   Z := trunc(JDay+0.5);
   F := JDay+0.5 - Z;
{   if (Z < 2299161) then
      A := Z
   else}
   begin
     I := trunc((Z - 1867216.25)/36524.25);
     A := Z + 1 + I - trunc(I/4);
   end;
   B := A + 1524;
   C := trunc((B - 122.1)/365.25);
   D := trunc(365.25 * C);
   T := trunc((B - D)/ 30.600);
   RJ := B - D - trunc(30.6001 * T) + F;
   Day := trunc(RJ);
   RH := (RJ - trunc(RJ)) * 24;
   Hour:=trunc(RH);
   Minute := trunc((RH - Hour )*60);
   Second := round(((RH - Hour )*60.0 - Minute )*60.0);
   Msec:=0;
   if (T < 14) then
      Month := T - 1
   else
     begin
      if ((T = 14) or (T = 15)) then
        Month := T - 13;
     end;
   if (Month > 2) then
      Y := longint(C) - 4716
   else
      Y := longint(C) - 4715;
   if Y < 0 then
     Year:=0
   else
     Year:=Y;
end;
(*
var
    jd,alpha,a,b,c,d,e      : longint;
    tzone: float;
    jdf: float;

    { The value can be negative! }
    ayear: integer;
begin
  tzone:=0;
  if jday > 0 then       {Julian Day <= 0 is meaningless}
    begin
      {add the time zone to the Julian Day, and reset to UT midnight}
      jday:=jday+0.5+tzone/24;
      {cut out the whole and fractional parts}
      jd:=trunc(jday);
      jdf:=frac(jday);

      alpha:=trunc((jd-1867216.25)/36524.25);
      a:=jd+1+alpha-trunc(alpha/4);  {leap year correction}
      b:=a+1524;
      c:=trunc((b-122.1)/365.25);
      d:=trunc(365.25*c);
      e:=trunc((b-d)/30.6001);

      {extract the year month & day}
      day:=b-d-trunc(30.6001*e);
      if e<14 then month:=e-1 else month:=e-13;
      if month>2 then
        ayear:=c-4716
      else
        ayear:=c-4715;

      {extract hours and minutes from the julian day fraction}
      hour:=trunc(24*jdf);
      minute:=trunc(frac(24*jdf)*60);
      second:=trunc(frac(1440.0*jdf)*60);
      { we must round, since we seem to loose some precision here! }
      msec:=trunc(frac(24*jdf*60*60)*1000);
      if msec > 500 then
      begin
        msec:=0;
        inc(second);
      end;

      { The dateutil API only supports years AD }
      if ayear < 0 then
        year:=0
      else
        year:=ayear;
  end;
end;*)

{ Tries converting a time string to an ISO time string
  returns converted string if conversion had success,
  otherwise returns an unmodified string.
}
function converttoisotime(timestr: string): string;
const
  MAX_TIMEZONES = 3;
  gmt_tz_str: array[1..MAX_TIMEZONES] of string[3] =
  (
   { Always use the biggest strings at the start }
   'UTC',
   'GMT',
   'UT'
  );
  digits = ['0'..'9'];
var
 i,idx: integer;
 outstr: string;
 alldigits: boolean;
begin
  timestr:=upstring(trim(timestr));
  outstr:=timestr;
  for i:=1 to MAX_TIMEZONES do
   begin
     idx:=pos(gmt_tz_str[i],timestr);
     if idx > 1 then
       begin
          { Don't copy the characters found, this should separate the time
            from the timezone }
          outstr:=copy(timestr,1,idx-1);
          outstr:=trim(outstr);
          outstr:=outstr+'Z';
          converttoisotime:=outstr;
          exit;
       end;
   end;
  alldigits:=true;
  { Is the string entirely composed of digits ? }
  for i:=1 to length(outstr) do
    begin
      if not (outstr[i] in digits) then
        begin
          alldigits:=false;
          break;
        end;
    end;
  { If the string is entirely composed of digits,
    remove the extra digits to have a HHmmss string
  }
  if alldigits then
    begin
      if length(outstr) > length('HHmmss') then
       begin
         delete(outstr,length('HHmmss')+1,length(outstr));
       end;
    end;
  converttoisotime:=outstr;
end;

{ Parse an ISO 8601 time string }
function parsetimeISO(timestr: string; var hourval,minval, secval: word;
  var offsethourval,offsetminval:integer; var UTC: boolean): boolean;
const
 TIME_SEPARATOR = ':';
var
 hourstr: string[2];
 secstr: string[2];
 minstr: string[2];
 offsetminstr: string[2];
 offsethourstr: string[2];
 code: integer;
 negative: boolean;
begin
  UTC:=false;
  ParseTimeISO:=false;
  negative:=false;
  minstr:='';
  secstr:='';
  hourstr:='';
  offsethourstr:='00';
  offsetminstr:='00';
  timestr:=trim(timestr);
  { search the possible cases }
  case length(timestr) of  
  { preferred format: hh:mm:ss }
  8,9,11,14:
      begin
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,4,2);
        secstr:=copy(timestr,7,2);
        if timestr[3] <> TIME_SEPARATOR then
           exit;
        if timestr[6] <> TIME_SEPARATOR then
           exit;
        { With Z TZD }   
        if length(timestr) = 9 then
          begin
            if timestr[length(timestr)] <> 'Z' then
              exit
            else
              UTC:=true;
          end
        else
        if length(timestr) = 14 then
          begin
            if (timestr[9] in ['+','-']) then
              begin
                negative:=(timestr[9] = '-');
                offsethourstr:=copy(timestr,10,2);
                offsetminstr:=copy(timestr,13,2);
              end
            else
              exit;
          end;
        if length(timestr) = 11 then
          begin
            if (timestr[9] in ['+','-'])  then
              begin
                negative:=(timestr[9] = '-');
                offsethourstr:=copy(timestr,10,2);
                offsetminstr:='00';
              end
            else
              exit;
          end;

      end;
  { compact format: hhmmss     }
   6,7:
      begin
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,3,2);
        secstr:=copy(timestr,5,2);
        { With Z TZD }   
        if length(timestr) = 7 then
          begin
            if timestr[length(timestr)] <> 'Z' then
              exit
            else
              UTC:=true;
          end
      end;
  { hour/min format: hh:mm }
   5: 
      begin
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,4,2);
        if timestr[3] <> TIME_SEPARATOR then
           exit;
      end;
  { compact hour:min format hhmm }
   4:
      begin
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,3,2);
      end;
  else
     begin
        exit;
     end;
  end;
  if hourstr = '' then
    exit;
  { verify the validity of the time }
  if minstr <> '' then
    begin
      if not isdigits(minstr) then
         exit;
      val(minstr,minval,code);
      if code <> 0 then
        exit;
    end;
  { verify the validity of the year }
  if offsetminstr <> '' then
    begin
      if not isdigits(offsetminstr) then
         exit;
      val(offsetminstr,offsetminval,code);
      if code <> 0 then
        exit;
      if (offsetminval < 0) or (offsetminval > 59) then
        exit;
    end;
  if offsethourstr <> '' then
    begin
      if not isdigits(offsethourstr) then
         exit;
      val(offsethourstr,offsethourval,code);
      if code <> 0 then
        exit;
      if (offsethourval < 0) or (offsethourval > 23) then
        exit;
    end;

  { verify the validity of the year }
  if secstr <> '' then
    begin
      if not isdigits(secstr) then
         exit;
      val(secstr,secval,code);
      if code <> 0 then
        exit;
    end;
  if hourstr <> '' then
    begin
      if not isdigits(hourstr) then
         exit;
      val(hourstr,hourval,code);
      if code <> 0 then
        exit;
    end;
  { Now add any timezone offset }
  if negative then
    begin
      offsethourval:=-offsethourval;
      offsetminval:=-offsetminval;
    end;
  { Now check the validity of the time value }
  if Not IsValidTime(hourval,minval,secval,0) then
     exit;
  ParseTimeISO:=true;
end;

{ Parse an ISO 8601 string date }
function parsedateISO(datestr:string; var yearval,
 monthval,dayval: word): boolean;
const
 DATE_SEPARATOR = '-';
var
 monthstr: string[2];
 yearstr: string[4];
 daystr: string[2];
 code: integer;
begin
  ParseDateISO:=false;
  monthstr:='';
  yearstr:='';
  daystr:='';
  datestr:=trim(datestr);
  { search the possible cases }
  case length(datestr) of
  { preferred format: YYYY-MM-DD }
  10:
      begin
        yearstr:=copy(datestr,1,4);
        monthstr:=copy(datestr,6,2);
        daystr:=copy(datestr,9,2);
        if datestr[5] <> DATE_SEPARATOR then
           exit;
        if datestr[8] <> DATE_SEPARATOR then
           exit;
      end;
  { compact format: YYYYMMDD     }
   8:
      begin
        yearstr:=copy(datestr,1,4);
        monthstr:=copy(datestr,5,2);
        daystr:=copy(datestr,7,2);
      end;
  { month format: YYYY-MM }
   7:
      begin
        yearstr:=copy(datestr,1,4);
        monthstr:=copy(datestr,6,2);
        if datestr[5] <> DATE_SEPARATOR then
           exit;
      end;
  { year format : YYYY }
   4:
      begin
        yearstr:=copy(datestr,1,4);
      end;
  else
     begin
        exit;
     end;
  end;
  if yearstr = '' then
    exit;
  { verify the validity of the year }
  if yearstr <> '' then
    begin
      if not isdigits(yearstr) then
         exit;
      val(yearstr,yearval,code);
      if code <> 0 then
        exit;
    end;
  { verify the validity of the year }
  if monthstr <> '' then
    begin
      if not isdigits(monthstr) then
         exit;
      val(monthstr,monthval,code);
      if code <> 0 then
        exit;
    end;
  { verify the validity of the year }
  if daystr <> '' then
    begin
      if not isdigits(daystr) then
         exit;
      val(daystr,dayval,code);
      if code <> 0 then
        exit;
    end;
  { Now check if the values are valid }
  if not IsValidDate(YearVal,MonthVal,DayVal) then
    { nope, exit }
    exit;
  ParseDateISO:=true;
end;

  { This converts and cleans up a date format
    to the ISO 8601 format.
  }
  function AdobeDateToISODate(s: string): string;
  const
   ADOBE_DATE_FORMAT_ID = 'D:';
  var
   s1: string;
   timezonestr: string;
   index: integer;
   finalstr: string;
  begin
    s1:='';
    s:=Upstring(s);
    s:=TrimLeft(s);
    s:=TrimRight(s);
    { Now verify if the D: delimiter is present }
    if pos(ADOBE_DATE_FORMAT_ID,s)=1 then
      begin
        delete(s,1,length(ADOBE_DATE_FORMAT_ID));
        case length(s) of
        { YYYY }
        4: begin
             { add MMDDHHMMSS }
             s:=s+'0101000000';
           end;
        { YYYYMM }
        6: begin
             s:=s+'01000000';
           end;
        { YYYYMMDD }
        8: begin
             s:=s+'000000';
           end;
        { YYYYMMDDHH }
        10: begin
             s:=s+'0000';
            end;
        { YYYYMMDDHHMM }
        12: begin
            end;
        { YYYYMMDD HHMMSS }
        14: begin
            end;
        { YYYYMMDDHHMMSSZ }
        15: begin
            end;
        { YYYYMMDDHHMMSS+HH }
        17: begin
            end;
        { YYYYMMDDHHSS+HH'MM' }
        21: begin
            end;
        end;
        { Now try copying only the YYYYMMDDHHMMSS parts }
        index:=pos('-',s);
        timezonestr:='';
        s1:=s;
        finalstr:=s1;
        if index <> 0 then
        begin
          s1:=copy(s,1,index-1);
          timezonestr:=copy(s,index,length(s));
        end;
        index:=pos('+',s);
        if index <> 0 then
        begin
          s1:=copy(s,1,index-1);
          timezonestr:=copy(s,index,length(s));
        end;
        index:=pos('Z',s);
        if index <> 0 then
        begin
          s1:=copy(s,1,index-1);
          timezonestr:=copy(s,index,length(s));
        end;
        { Now convert the timezone information  }
        if length(timezonestr) > 0 then
          begin
            index:=pos('''',timezonestr);
            { minutes! }
            if index > 0 then
              begin
                timezonestr:=copy(timezonestr,1,index-1)+':'+
                   copy(timezonestr,index+1,length(timezonestr));
                { delete end minute marker }
                index:=pos('''',timezonestr);
                if index > 0 then
                   delete(timezonestr,index,1);
              end;
          end;

        { Separate Time from Date, only if there are any time components }
        if length(s1) >= length('YYYYMMDD') then
          begin                  { HH }             { MM }
            finalstr:=copy(s1,1,8);
            s:=copy(s1,9,2);
            if length(s) > 0 then
              finalstr:=finalstr+'T'+s;
            s:=copy(s1,11,2);
            if length(s) > 0 then
              finalstr:=finalstr+':'+s;
            s:=copy(s1,13,2);
            if length(s) > 0 then
              finalstr:=finalstr+':'+s;
            finalstr:=finalstr+timezonestr;
          end;
      end;
    AdobeDateToISODate:=finalSTR;
  end;


function RFC822ToISODateTime(s:string): string;
type
 TRFC822ZoneInfo = record
   name: string[3];
   offsetstr: string[6];
 end;

const
 RFC822DayString: array[1..7] of string[3] =
  ('Mon','Tue','Wed','Thu','Fri','Sat','Sun');
 RFC822MonthString: array[1..12] of string[3] =
 ('Jan','Feb','Mar','Apr','May','Jun','Jul',
  'Aug','Sep','Oct','Nov','Dec');
 RFC822_TIME_SEPARATOR = ':';
 MAX_RFC822_ZONE_INFO = 15;
 RFC822ZoneInfo: array[1..MAX_RFC822_ZONE_INFO] of TRFC822ZoneInfo =
 (
   { The wrong values are kept as stated in RFC 1123 for backward
     compatibility, even if the decoded date and time will be
     invalid
   }
   (name:  'UT';offsetstr:'+00:00'),
   (name: 'GMT';offsetstr:'+00:00'),
   (name: 'EST';offsetstr:'-05:00'),
   (name: 'EDT';offsetstr:'-04:00'),
   (name: 'CST';offsetstr:'-06:00'),
   (name: 'CDT';offsetstr:'-05:00'),
   (name: 'MST';offsetstr:'-07:00'),
   (name: 'MDT';offsetstr:'-06:00'),
   (name: 'PST';offsetstr:'-08:00'),
   (name: 'PDT';offsetstr:'-07:00'),
   (name:   'Z';offsetstr:'+00:00'),
   (name:   'A';offsetstr:'-01:00'),  { RFC 1123 states that this value is wrong }
   (name:   'M';offsetstr:'-12:00'),  { RFC 1123 states that this value is wrong }
   (name:   'N';offsetstr:'+01:00'),  { RFC 1123 states that this value is wrong }
   (name:   'Y';offsetstr:'+12:00')   { RFC 1123 states that this value is wrong }
 );

var
 i: integer;
 index:integer;
 found: boolean;
 DayDigits,YearDigits: string[4];
 HourDigits,MinuteDigits: string[4];
 SecondDigits: string[4];
 MonthStr: string[4];
 OffsetStr: string[12];
 Day,Month,Hours,Minutes,Seconds,Year: integer;
 code: integer;
 ISODateString,ISOTimeString: string[16];
begin
 RFC822ToISODateTime:='';
 { Check if [ Day ","] is present }
 index:=pos(',',s);
 { Remove all these parts as we do not need them }
 if index <> 0 then
   delete(s,1,index);
 s:=trim(s);
 if length(s) = 0 then
   exit;
 {************************ DATE ***************************}
 { 1*2 DIGIT DAY VALUE }
 i:=1;
 DayDigits:='';
 while s[i] in ['0'..'9'] do
   begin
     DayDigits:=DayDigits+s[i];
     inc(i);
     { Hmm.. invalid date/time format }
     if i > length(s) then exit;
   end;
 { Maximum 2 digits for the day, as defined in RFC 822 }
 if (length(DayDigits) > 2) or (length(DayDigits) = 0) then
   exit;
 { Now delete those digits }
 delete(s,1,i-1);
 { Now we should have the 'month' string }
 s:=trim(s);
 found:=false;
 for i:=1 to 12 do
  begin
    index:=pos(RFC822MonthString[i],s);
    if index = 1 then
      begin
        found:=true;
        month:=i;
        break;
      end;
  end;
 { No month string, so this is not a valid RFC822 date }
 if not found then
   exit;
 { Now remove the month string }
 delete(s,1,3);
 s:=trim(s);
 i:=1;
 YearDigits:='';
 while s[i] in ['0'..'9'] do
   begin
     YearDigits:=YearDigits+s[i];
     inc(i);
     { Hmm.. invalid date/time format }
     if i > length(s) then exit;
   end;
 { Maximum 4 digits for the year, as defined in RFC 1123 }
 if (length(YearDigits) > 4) or (length(YearDigits) = 0) then
   exit;
 { If the length is on two digits, we are in the 20th century }
 if length(YearDigits) = 2 then
   YearDigits:='19'+YearDigits;
 { Delete the year digits }
 delete(s,1,i-1);
 {************************ TIME ***************************}
 s:=trim(s);
 i:=1;
 HourDigits:='';
 while s[i] in ['0'..'9'] do
   begin
     { Hmm.. invalid date/time format }
     if i > length(s) then exit;
     HourDigits:=HourDigits+s[i];
     inc(i);
   end;
 if length(HourDigits) <> 2 then
   exit;
 delete(s,1,i-1);
 if s[1] <> RFC822_TIME_SEPARATOR then
   exit;
 delete(s,1,1);
 { The minutes are present here }
 i:=1;
 MinuteDigits:='';
 while (i <= length(s)) and (s[i] in ['0'..'9']) do
   begin
     { Hmm.. invalid date/time format }
     if i > length(s) then exit;
     MinuteDigits:=MinuteDigits+s[i];
     inc(i);
   end;
 if length(MinuteDigits) <> 2 then
   exit;
 { Check if the seconds are present here }
 SecondDigits:='';
 delete(s,1,i-1);
 if (length(s) > 0) and (s[1] = RFC822_TIME_SEPARATOR) then
   begin
      delete(s,1,1);
      i:=1;
      while s[i] in ['0'..'9'] do
        begin
         { Hmm.. invalid date/time format }
         if i > length(s) then exit;
         SecondDigits:=SecondDigits+s[i];
         inc(i);
       end;
     if length(SecondDigits)<>2 then exit;
     delete(s,1,i);
   end;
 {************************ TZ INFO ***************************}
 s:=trim(s);
 { Check if we have timezone information as a string }
 found:=false;
 OffsetStr:='';
 { Check if we have a form +/- HHMM }
 if (length(s) > 0) and (s[1] in ['+','-']) then
   begin
      offsetstr:=s[1];
      found:=true;
      i:=2;
      while s[i] in ['0'..'9'] do
        begin
         offsetstr:=offsetstr+s[i];
         inc(i);
         { Hmm.. invalid date/time format }
         if i > length(s) then break;
       end;
      { The string must be of the form +/-HHMM }
      if length(offsetstr) <> 5 then
        exit;
      { Add the separators to this string }
      insert(':',offsetstr,4);
   end;
 { Check for string timezone information }
 if not found then
   begin
     for i:=1 to MAX_RFC822_ZONE_INFO do
       begin
         if s = RFC822ZoneInfo[i].name then
           begin
            found:=true;
            offsetstr:=RFC822ZoneInfo[i].offsetstr;
            break;
           end;
       end;
  end;
  if not found then exit;
  {********************** Everything should be setup here ******************}
  { Convert the month information }
  MonthStr:=decstr(Month,2);
  Day:=ValDecimal(DayDigits,code) and $ff;
  if code <> 0 then
    exit;
  Year:=ValDecimal(YearDigits,code) and $ffff;
  if code <> 0 then
    exit;
  Hours:=ValDecimal(HourDigits,code) and $ff;
  if code <> 0 then
    exit;
  Minutes:=ValDecimal(MinuteDigits,code) and $ff;
  if code <> 0 then
    exit;
  Seconds:=ValDecimal(SecondDigits,code) and $ff;
  if code <> 0 then
    exit;
  { Create the ISO 8601 string }
  ISODateString:=DecStr(Year,4)+'-'+DecStr(Month,2)+'-'+DecStr(Day,2);
  ISOTimeString:='T'+DecStr(Hours,2)+':'+DecStr(Minutes,2)+':'+DecStr(Seconds,2)+offsetstr;

  RFC822ToISODateTime:=ISODateString+ISOTimeString;
end;


{**************************************************************************}

//{$i dateext.inc}

procedure getdatedos(var year,month,mday,wday : word);
var
  t : TSystemTime;
begin
  GetLocalTime(t);
  year:=t.wYear;
  month:=t.wMonth;
  mday:=t.wDay;
  wday:=t.wDayOfWeek;
end;


procedure setdatedos(year,month,day : word);
var
  t : TSystemTime;
begin
  { we need the time set privilege   }
  { so this function crash currently }
  {!!!!!}
  GetLocalTime(t);
  t.wYear:=year;
  t.wMonth:=month;
  t.wDay:=day;
  { only a quite good solution, we can loose some ms }
  SetLocalTime(t);
end;


function fillwithzeros(s: shortstring; newlength: Integer): shortstring;
begin
  while length(s) < newlength do s:='0'+s;
  fillwithzeros:=s;
end;


function GetISODateString(Year,Month,Day:Word): shortstring;
var
  yearstr:string[4];
  monthstr: string[2];
  daystr: string[2];
begin
  GetISODateString := '';
  if year > 9999 then exit;
  if Month > 12 then exit;
  if day > 31 then exit;
  str(year,yearstr);
  str(month,monthstr);
  str(day,daystr);
  GetIsoDateString := fillwithzeros(yearstr,4)+'-'+ fillwithzeros(monthstr,2)+
    '-'+ fillwithzeros(daystr,2);
end;

function GetISODateStringBasic(Year,Month,Day:Word): shortstring;
var
  yearstr:string[4];
  monthstr: string[2];
  daystr: string[2];
begin
  GetISODateStringBasic := '';
  if year > 9999 then exit;
  if Month > 12 then exit;
  if day > 31 then exit;
  str(year,yearstr);
  str(month,monthstr);
  str(day,daystr);
  GetIsoDateStringBasic := fillwithzeros(yearstr,4)+ fillwithzeros(monthstr,2)
    + fillwithzeros(daystr,2);
end;

function GetISOTimeString(Hour,Minute,Second: Word; UTC: Boolean):
  shortstring;
var
  hourstr: string[2];
  minutestr: string[2];
  secstr: string[2];
  s: shortstring;
begin
  GetISOTimeString := '';
  if Hour > 23 then exit;
  if Minute > 59 then exit;
  { Don't  forget leap seconds! }
  if Second > 60 then exit;
  str(hour,hourstr);
  str(minute,minutestr);
  str(second,secstr);
  s := fillwithzeros(HourStr,2)+':'+ fillwithzeros(MinuteStr,2)+':'+
    fillwithzeros(SecStr,2);
  if UTC then s:=s+'Z';
  GetISOTimeString := s;
end;

function GetISOTimeStringBasic(Hour,Minute,Second: Word; UTC: Boolean):
  shortstring;
var
  hourstr: string[2];
  minutestr: string[2];
  secstr: string[2];
  s: shortstring;
begin
  GetISOTimeStringBasic := '';
  if Hour > 23 then exit;
  if Minute > 59 then exit;
  { Don't  forget leap seconds! }
  if Second > 60 then exit;
  str(hour,hourstr);
  str(minute,minutestr);
  str(second,secstr);
  s := fillwithzeros(HourStr,2)+ fillwithzeros(MinuteStr,2)+
    fillwithzeros(SecStr,2);
  if UTC then s:=s+'Z';
  GetISOTimeStringBasic := s;
end;


function GetISODateTimeString(Year,Month,Day,Hour,Minute,Second: Word; UTC:
  Boolean): shortstring;
var
  s1,s2: shortstring;
begin
  GetISODateTimeString:='';
  s1:=GetISODateString(year,month,day);
  if s1 = '' then exit;
  s2:=GetISOTimeString(Hour,Minute,Second,UTC);
  if s2 = '' then exit;
  GetISODatetimeString := s1 + 'T' + s2;
end;





function CurrentYear: word;
var
 Year,Month,Day,DayOfWeek: platformword;
begin
  GetDatedos(Year,Month,Day,DayOfWeek);
  CurrentYear:=Year;
end;

function Date: TDatetimeReal;
var
 Year,Month,Day,DayOfWeek: platformword;
begin
  GetDatedos(Year,Month,Day,DayOfWeek);
  Date:=datetojd(Year,Month,Day,0,0,0,0);
end;

function DateOf(const AValue: TDatetimeReal): TDatetimeReal;
begin
  DateOf:=Round(AValue);
end;


function DateTimeToStr(DateTime: TDatetimeReal): string;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (DateTime,year,month,day,hour,minute,second,msec);
  DateTimeToStr:=GetISODateTimeString(Year, Month, Day, Hour,
    Minute, Second, false);
end;

function DateToStr(date: TDatetimeReal): string;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (Date,year,month,day,hour,minute,second,msec);
  DateToStr:=GetISODateString(Year, Month, Day);
end;

function DayOf(const AValue: TDatetimeReal): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  DayOf:=Day;
end;

function DaysBetween(const ANow, AThen: TDatetimeReal): integer;
begin
  DaysBetween:=abs(Trunc(Anow)-Trunc(AThen));
end;

procedure DecodeDate(Date: TDatetimeReal; var Year, Month, Day: Word);
var
 hour,minute,second,msec: word;
begin
  jdtodate (Date,year,month,day,hour,minute,second,msec);
end;

procedure DecodeDateTime(const AValue: TDatetimeReal; var Year, Month, Day, Hour, Minute, Second, MilliSecond: Word);
begin
  jdtodate (AValue,year,month,day,hour,minute,second,millisecond);
end;

procedure DecodeTime(Time: TDatetimeReal; var Hour, Min, Sec, MSec: Word);
var
 year,month,day: word;
begin
  msec:=0;
  jdtodate (Time,year,month,day,hour,min,sec,msec);
end;

function HourOf(const AValue: TDatetimeReal): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  HourOf:=Hour;
end;


function IncDay(const AValue: TDatetimeReal; const ANumberOfDays: Integer): TDatetimeReal;
begin
  IncDay:=AValue + ANumberOfDays;
end;

function IncHour(const AValue: TDatetimeReal; const ANumberOfHours: longint): TDatetimeReal;
begin
  IncHour:=AValue + (ANumberOfHours / 24.0);
end;

function IncMilliSecond(const AValue: TDatetimeReal; const ANumberOfMilliSeconds: big_integer_t): TDatetimeReal;
begin
  IncMillisecond:= AValue+(ANumberOfMilliSeconds / 24.0) / (60.0*60.0*1000.0);
end;

function IncMinute(const AValue: TDatetimeReal; const ANumberOfMinutes: big_integer_t): TDatetimeReal;
begin
 IncMinute:= AValue + (ANumberOfMinutes / 24.0) / 60.0;
end;


function IncSecond(const AValue: TDatetimeReal; const ANumberOfSeconds: big_integer_t): TDatetimeReal;
begin
  IncSecond:= AValue + (ANumberOfSeconds / 24.0) / (60.0*60.0);
end;

function IncWeek(const AValue: TDatetimeReal; const ANumberOfWeeks: Integer): TDatetimeReal;
begin
  IncWeek:= AValue + ANumberOfWeeks*7;
end;

function IsPM(const AValue: TDatetimeReal): Boolean;
var
 d: TDatetimeReal;
begin
 d:=frac(Avalue);
 if d >= 0.5 then
   IsPM:=false
 else
   IsPM:=true;
end;

function IsValidDate(const AYear, AMonth, ADay: Word): Boolean;
begin
  IsValidDate:=false;
  if (Amonth > 12) or (Amonth = 0) then
     exit;
  if (ADay > 31) or (ADay = 0) then
     exit;
  { We don't check the AYear value because we assume
    the user knows that this value is in the Gregorian calendar
  }
  IsValidDate:=true;
end;

function IsValidDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;
begin
  IsValidDatetime:=true;
  if IsValidDate(AYear,Amonth,ADay) and
     IsValidTime(AHour,AMinute,ASecond,Amillisecond) then
    begin
      exit;
    end;
  IsValidDateTime:=false;
end;

function IsValidTime(const AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;
begin
  IsValidTime:=false;
  if (AHour > 24) then
    exit;
  if (AMinute > 59) then
    exit;
  { 60 is possible with leap seconds! }
  if (ASecond > 60) then
    exit;
  If (AMillisecond > 999) then
    exit;
  IsValidTime:=true;
end;

function MinuteOf(const AValue: TDatetimeReal): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  MinuteOf:=Minute;
end;

function MonthOf(const AValue: TDatetimeReal): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  MonthOf:=Month;
end;

procedure gettimedos(var hour,minute,second,sec100 : word);
var
  t : TSystemTime;
begin
   GetLocalTime(t);
   hour:=t.wHour;
   minute:=t.wMinute;
   second:=t.wSecond;
   sec100:=t.wMilliSeconds div 10;
end;



function Now: TDatetimeReal;
var
 Year,Month,Day,DayOfWeek: platformword;
 Hour,Minute,Sec,Sec100: platformword;
begin
  GetDatedos(Year,Month,Day,DayOfWeek);
  GetTimedos(Hour,Minute,Sec,Sec100);
  Now:=datetojd(Year,Month,Day,Hour,Minute,Sec,Sec100);
end;

function SameDate(const A, B: TDatetimeReal): Boolean;
begin
  if trunc(A) = trunc(B) then
    SameDate:=true
  else
    SameDate:=false;
end;

function SameDateTime(const A, B: TDatetimeReal): Boolean;
begin
  SameDateTime:=true;
  if A-B=0 then
    exit;
  SameDateTime:=false;
end;


function SameTime(const A, B: TDatetimeReal): Boolean;
begin
  if (abs(frac(A))-abs(frac(B))) = 0 then
    SameTime:=true
  else
    SameTime:=false;
end;

function SecondOf(const AValue: TDatetimeReal): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  SecondOf:=Second;
end;

function Time: TDatetimeReal;
var
  Hour,Minute,Second,Sec100: platformword;
begin
  GetTimedos(Hour,Minute,Second,Sec100);
  Time:=datetojd(0,0,0,Hour,Minute,Second,Sec100);
end;

function GetTime: TDatetimeReal;
begin
  GetTime:=Time;
end;

function TimeOf(const AValue: TDatetimeReal): TDatetimeReal;
begin
  TimeOf:=frac(AValue);
end;


function TimeToStr(Time: TDatetimeReal): string;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (Time,year,month,day,hour,minute,second,msec);
  TimeToStr:=GetISOTimeString(Hour,Minute, Second, false);
end;

function Today: TDatetimeReal;
var
 Year,Month,Day,DayOfWeek: platformword;
 Hour,Minute,Sec,Sec100: platformword;
begin
  GetDatedos(Year,Month,Day,DayOfWeek);
  GetTimedos(Hour,Minute,Sec,Sec100);
  Today:=trunc(datetojd(Year,Month,Day,Hour,Minute,Sec,Sec100));
end;


function TryEncodeDate(Year, Month, Day: Word; var Date: TDatetimeReal): Boolean;
begin
  TryEncodeDate:=false;
  if IsValidDate(Year,Month,Day) then
    begin
      Date:=datetojd(year,month,day,0,0,0,0);
      TryEncodeDate:=true;
      exit;
    end;
end;

function TryEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDatetimeReal): Boolean;
begin
  TryEncodeTime:=false;
  if IsValidTime(Hour,Min,Sec,Msec) then
    begin
      Time:=datetojd(0,0,0,Hour,Min,Sec,MSec);
      TryEncodeTime:=true;
      exit;
    end;
end;

function TryEncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
   var AValue: TDatetimeReal): Boolean;
begin
  TryEncodeDateTime:=false;
  if IsValidTime(AHour,AMinute,ASecond,AMillisecond) and IsValidDate(AYear,AMonth,ADay) then
    begin
      AValue:=datetojd(AYear,AMonth,ADay,AHour,AMinute,ASecond,AMillisecond);
      TryEncodeDateTime:=true;
      exit;
    end;
end;


function TryStrToDate(const S: string; var Value: TDatetimeReal): Boolean;
var
  yearval,monthval,dayval: word;
begin
  TryStrToDate:=false;
  yearval:=0;
  monthval:=1;
  dayval:=1;
  if not parsedateISO(s,yearval,monthval,dayval) then
    exit;
  { Now convert to a Julian Day }
  Value:=datetojd(Yearval,Monthval,Dayval,0,0,0,0);
  trystrtodate:=true;
end;




function TryStrToDateTime(const S: string; var Value: TDatetime): Boolean;
  var
   utc: boolean;
  begin
    TryStrToDateTime:=TryStrToDateTimeExt(s,Value,utc);
  end;


function TryStrToTime(const S: string; var Value: TDatetimeReal): Boolean;
var
    minval,
    secval,
    hourval:word;
    msecval:word;
    offsetminval,
    offsethourval: integer;
    timestr: string;
    utc: boolean;
begin
  TryStrToTime:=false;
  MSecVal:=0;
  timestr:=converttoisotime(s);
  if not ParseTimeISO(timestr,hourval,minval,secval,offsethourval,offsetminval,utc) then
    exit;
  { Now convert it }
  Value:=datetojd(0,0,0,HourVal,MinVal,SecVal,MSecVal);
  Value:=IncHour(Value,offsethourval);
  Value:=IncMinute(Value,offsetminval);
  { Now strip the Date value, if it has increased }
  Value:=frac(Value);
  TryStrToTime:=true;
end;



function YearOf(const AValue: TDatetimeReal): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  YearOf:=Year;
end;


end.
{
  $Log: dateutil.pas,v $
  Revision 1.12  2006/12/07 02:53:38  carl
    * Avoid range check errors when validating RFC 822 invalid dates.

  Revision 1.11  2006/10/17 01:03:28  carl
   * Bugfix for compilation with BP (line too long error)

  Revision 1.10  2006/08/31 03:08:05  carl
  + Better documentation

  Revision 1.9  2005/11/21 00:18:12  carl
    - remove some compilation warnings/hints
    + speed optimizations
    + recreated case.inc file from latest unicode casefolding standard

  Revision 1.8  2004/12/26 23:31:01  carl
    * Today would return a truncated date

  Revision 1.7  2004/12/08 04:24:42  carl
    * range check error bugfixes

  Revision 1.6  2004/11/29 03:50:24  carl
    + UNIX and FILETIME to DateTime conversion

  Revision 1.5  2004/11/23 03:44:53  carl
    * fixes for compilation with Virtual Pascal 2.x

  Revision 1.4  2004/10/31 19:52:50  carl
    * TryStrToDateTime would not accept Dates only
    + Add support fore PDF, Openoffice HTML date parsing
      in TryStrToDateTime
    + Add supported for extended format conversion (Ext routines)

  Revision 1.3  2004/10/27 01:57:45  carl
   - avoid range check error warning

  Revision 1.2  2004/10/13 23:23:50  carl
    * change TDatetime type from extended to real.

  Revision 1.1  2004/09/29 00:57:46  carl
    + added dateutil unit
    + added more support for parsing different ISO time/date strings

}
