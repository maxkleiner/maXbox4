{**********************************************************************}
{ These are extensions to the standard Delphi dateutil unit interface  }
{**********************************************************************}

unit dateext4;     //adapt to maXbox4

interface

   uses windows;

type
  {** Win32 FILETIME timestamp }
  tfiletime2 = record
    LowDateTime: longword;
    HighDateTime: longword;
  end;

  TYPE
    { The biggest integer type available to this compiler }
    big_integer_t = int64;



Function DosToWinTime (DTime:longint;Var Wtime : tfiletime):longbool;
Function WinToDosTime (Const Wtime : TFileTime;var DTime:longint):longbool;



{** Returns Year, Month, Day, Hour, Minute, Second, and Millisecond values for a TDateTime.
    This routine uses extended format which permits negative years.
}
{procedure DecodeDateTimeExt(const AValue: TDateTime; var Year, Month, Day, Hour, Minute, Second, MilliSecond: Integer);}

{** Returns Year, Month, and Day values for a TDateTime value. This is
    the same as DecodeDateExt except that it also permits years in
    the negative range.
}
{procedure DecodeDateExt(Date: TDateTime; var Year, Month, Day: integer);}


{** @abstract(Converts a string to a TDateTime value with a Boolean success code.)

    This routine also gives information if the value was successfully
    converted to UTC time or not (if no timezone information was
    available in the string then the utc value will be false).

    Supported formats:
    1) Format of Complete Representation for calendar dates
    (as specified in ISO 8601), which should include the Time
    designator character.
    3) Format: 'YYYY-MM-DD HH:mm:ss [GMT|UTC|UT]'
    4) Openoffice 1.1.x HTML date format: 'YYYYMMDD;HHmmssuu'
    5) Adobe PDF 'D:YYYYMMDDHHMMSSOHH'mm'' format

    The returned value will be according to UTC if timezone
    information is specified.

    In the case where the date does not contain the full representation
    of a date (for examples, YYYY or YYYY-MM), then the missing values
    will be set to 1 to be legal.

}
function TryStrToDateTimeExt(const S: string; var Value: TDateTime; var UTC: boolean) : Boolean;
//function TryStrToDateTimeExt(const S: string; var Value: TDateTime; var UTC: boolean) : Boolean;


{** This routine encodes a complete date and time to its string
    representation. The encoded string conforms to the ISO 8601
    complete representation extended format (YYYY-MM-DDTHH:MM:SS[Z]).
    
    The year value is required, while all other fields are optional.
    The other fields can be set to EMPTY_DATETIME_FIELD to indicate that 
    they are empty. It also adds the UTC marker if required and if it
    is set and time information is present.
}    
function TryEncodeDateAndTimeToStr(const Year, Month, Day, Hour, Minute, Second, MilliSecond: 
  word; UTC: boolean; var AValue: string):boolean;
  
{** This routine encodes a complete date and time to its string
    representation. The encoded string conforms to the ISO 8601
    expanded date representation concatenated with an
    extended time format ([+|-]YYYYYY-MM-DDTHH:MM:SS[Z]).. 

    The year value is required, while all other fields are optional.
    The other fields can be set to EMPTY_DATETIME_FIELD to indicate that
    they are empty. It also adds the UTC marker if required and if it
    is set and time information is present.
}
{function EncodeDateAndTimeToStrExt(const Year, Month, Day, Hour, Minute, Second, MilliSecond:
  integer; UTC: boolean):string;}


{** @abstract(Converts a TDateTime value to a string in extended ISO 8601 date and time representation.)

    Returns the extended format representation of a date and time as recommended
    by ISO 8601 (Gregorian Calendar). The extended format ISO 8601 representation
    is of the form: YYYY-MM-DDThh:mm:ss[Z]. Sets the timezone designator
    if required.
}
function DateTimeToStrExt(DateTime: TDateTime; utc: boolean): string;


{** @abstract(Returns the current date set in the operating system) }
procedure GetCurrentDate(var Year,Month,Day,DayOfWeek: integer);

{** @abstract(Returns the current time set in the operating system) 

   Ranges of the values returned are Hour 0..23, Minute 0..59,
   Second 0..60, Sec100 0..99.
}
procedure GetCurrentTime(var Hour,Minute,Second,Sec100: integer);

{** @abstract(Converts a UNIX time_t to a TDateTime)

  This routine converts a UNIX time_t format time into a
  TDateTime format. The time_t is always according to UTC,
  so the UTC value shall always return TRUE.
  
  On Turbo Pascal and Virtual Pascal this routine shall fail
  with all values greater that represent years greater than
  2038.
}
function TryUNIXToDateTimeExt(unixtime: big_integer_t; var DateTime: TDateTime; var UTC: boolean): boolean;

{** @abstract(Converts a Win32 FILETIME to a TDateTime)

  This routine converts a 64-bit FILETIME format time into a
  TDateTime format. The value is always according to UTC,
  so the UTC value shall always return TRUE. Because floating
  point values are used, the precision of the returned timestamp
  will be +/- 2 seconds.

}
function TryFileTimeToDateTimeExt(ftime: tfiletime2; var DateTime: TDateTime; var UTC: boolean): boolean;

procedure JulianToGregorian(JulianDN:big_integer_t;var Year,Month,Day:Word);


implementation

uses sysutils, dateutilreal, dateutils;

type
  TLongrec=packed record
    lo,hi : word;
  end;


Function DosToWinTime (DTime:longint;Var Wtime : TFileTime):longbool;
var
  lft : TFileTime;
begin
  DosToWinTime:=DosDateTimeToFileTime(longrec(dtime).hi,longrec(dtime).lo,lft) and
                LocalFileTimeToFileTime(lft,Wtime);
end;


Function WinToDosTime (Const Wtime : TFileTime;var DTime:longint):longbool;
var
  lft : TFileTime;
begin
  WinToDosTime:=FileTimeToLocalFileTime(WTime,lft) and
                FileTimeToDosDateTime(lft,longrec(dtime).hi,longrec(dtime).lo);
end;


{
  $Log: dateexth.inc,v $
  Revision 1.4  2006/08/31 03:08:41  carl
  + Better documentation

  Revision 1.3  2004/11/29 03:50:24  carl
    + UNIX and FILETIME to DateTime conversion

  Revision 1.2  2004/11/23 03:44:53  carl
    * fixes for compilation with Virtual Pascal 2.x

  Revision 1.1  2004/10/31 19:53:07  carl
    + Add support for extended format conversion (Ext routines)

}
{ See documentation in header file }

function TryStrToDateTimeExt(const S: string; var Value: TDateTime; var UTC: boolean) : Boolean;
var
 idx: integer;
 minval,
 secval,
 hourval:word;
 offsetminval,
 offsethourval: integer;
 datestring,timestring: string;
 yearval,monthval,dayval: word;
 MSecVal: word;
 error: boolean;
 outs: string;
 s1: string;
begin
  error:=false;
  TryStrToDateTimeExt:=false;
  MSecVal:=0;
  utc:=false;
  Value:=0;
  { Check for complete ISO 8601 string }
  idx:=pos('T',s);
  if idx <> 0 then
    begin
      datestring:=copy(s,1,idx-1);
      timestring:=copy(s,idx+1,length(s));
      if not parsetimeISO(timestring,hourval,minval,secval,offsethourval,offsetminval,UTC) then
         error:=true;
      if not parsedateISO(datestring,yearval,monthval,dayval) then
         error:=true;
      if IsValidDateTime(YearVal,MonthVal,DayVal,HourVal,Minval,SecVal,MSecVal) then
        begin
          Value:=datetojd(Yearval,Monthval,Dayval,HourVal,MinVal,SecVal,MSecval);

         { Convert to UTC if required }
         if (offsethourval <> 0) or (offsetminval <> 0) then
           utc:=true;
         Value:=IncHour(Value,offsethourval);
         Value:=IncMinute(Value,offsetminval);
        end;
         if not error then
           begin
             TryStrToDatetimeExt:=true;
             exit;
        end;
    end;
  { Check for non-standard string with space that separates the date
    and time.
  }
  { Reset error, we are trying a new parsing method }
  utc:=false;
  error:=false;
  outs:=trim(s);
  idx:=pos(' ',outs);
  if idx <> 0 then
    begin
      datestring:=copy(outs,1,idx-1);
      timestring:=copy(outs,idx+1,length(outs));
      timestring:=converttoisotime(timestring);
      if not parsetimeISO(timestring,hourval,minval,secval,offsethourval,offsetminval,utc) then
         error:=true;
      if not parsedateISO(datestring,yearval,monthval,dayval) then
         error:=true;
      if IsValidDateTime(YearVal,MonthVal,DayVal,HourVal,Minval,SecVal,MSecVal) then
        begin

          Value:=datetojd(Yearval,Monthval,Dayval,HourVal,MinVal,SecVal,MSecval);
          { Convert to UTC if required }
          if (offsethourval <> 0) or (offsetminval <> 0) then
             utc:=true;
          Value:=IncHour(Value,offsethourval);
          Value:=IncMinute(Value,offsetminval);
          if not error then
            begin
             TryStrToDatetimeExt:=true;
             exit;
            end;
        end;
    end;
  { Openoffice HTML output date/time format }
  utc:=false;
  error:=false;
  idx:=pos(';',outs);
  if idx <> 0 then
    begin
      datestring:=copy(outs,1,idx-1);
      timestring:=copy(outs,idx+1,length(outs));
      timestring:=converttoisotime(timestring);
      if not parsetimeISO(timestring,hourval,minval,secval,offsethourval,offsetminval,utc) then
         error:=true;
      if not parsedateISO(datestring,yearval,monthval,dayval) then
         error:=true;
      if IsValidDateTime(YearVal,MonthVal,DayVal,HourVal,Minval,SecVal,MSecVal) then
        begin
          Value:=datetojd(Yearval,Monthval,Dayval,HourVal,MinVal,SecVal,MSecval);
          { Convert to UTC if required }
          if (offsethourval <> 0) or (offsetminval <> 0) then
             utc:=true;
          Value:=IncHour(Value,offsethourval);
          Value:=IncMinute(Value,offsetminval);
          if not error then
            begin
              TryStrToDatetimeExt:=true;
              exit;
            end;
        end;
    end;
  { PDF date/time format }
  utc:=false;
  error:=false;
  idx:=pos('D:',outs);
  if idx = 1 then
    begin
      { Convert to an ISO date }
      outs:=AdobeDateToISODate(outs);
      if TryStrToDateTimeExt(outs,value,utc) then
        begin
          TryStrToDatetimeExt:=true;
          exit;
        end;
    end;
  { RFC 822/RFC 1123 Date/Time format}
  utc:=false;
  error:=false;
  { Convert to an ISO date }
  if length(outs) <> 0 then
    begin
     s1:=RFC822ToISODateTime(outs);
     if s1 <> '' then
       begin
         if TryStrToDateTimeExt(s1,value,utc) then
           begin
              TryStrToDatetimeExt:=true;
              exit;
           end;
       end;
    end;
  { ISO 8601 date only }
  datestring:=outs;
  utc:=false;
  error:=false;
  { use default values }
  monthval:=1;
  dayval:=1;
  yearval:=0;
  if not parsedateISO(datestring,yearval,monthval,dayval) then
     error:=true;
  HourVal:=0;
  MinVal:=0;
  SecVal:=0;
  MSecVal:=0;
  Value:=datetojd(Yearval,Monthval,Dayval,HourVal,MinVal,SecVal,MSecval);
  { NO time conversion here since we assume it is a date only string }
  if not error then
    begin
      TryStrToDatetimeExt:=true;
      exit;
    end;
end;


{  See documentation in header file }
function TryEncodeDateAndTimeToStr(const Year, Month, Day, Hour, Minute, Second, MilliSecond: 
  word; UTC: boolean; var AValue: string):boolean;
 var
  ADateTime: TDateTime;
  finalstring: string;
 begin
   FinalString:='' ;
   TryEncodeDateAndTimeToStr:=false;
   if TryEncodeDateTime(Year,Month,Day,Hour,Minute,Second,Millisecond,ADateTime) then
     begin
       TryEncodeDateAndTimeToStr:=true;
       FinalString:=DateTimeToStr(ADateTime);
       { Add the UTC modifier signature if this is an UTC string }
       if UTC then
         FinalString:=FinalString+'Z';
     end;
   AValue:=FinalString;
 end;

function DateTimeToStrExt(DateTime: TDateTime; utc: boolean): string;
var
 tzstr: string;
begin
  if utc then
    tzstr:='Z'
  else
    tzstr:='';
  result:=DateTimeToStr(DateTime)+tzstr;
end;

procedure GetCurrentDate(var Year,Month,Day,DayOfWeek: integer);
var
 aYear,aMonth,aDay,aDayOfWeek: platformword;
begin
  GetDateDos(aYear,aMonth,aDay,aDayOfWeek);
  Year:=integer(aYear);
  Month:=integer(aMonth);
  Day:=integer(aDay);
  DayOfWeek:=integer(aDayOfWeek);
end;

procedure GetCurrentTime(var Hour,Minute,Second,Sec100: integer);
var
 aHour,aMinute,aSecond,aSec100: platformword;
begin
  GetTimeDos(aHour,aMinute,aSecond,aSec100);
  Hour:=integer(aHour);
  Minute:=integer(aMinute);
  Second:=integer(aSecond);
  Sec100:=integer(aSec100);
end;


const
{Date Calculation}
  C1970 = 2440588;
  D0 = 1461;
  D1 = 146097;
  D2 = 1721119;


procedure JulianToGregorian(JulianDN:big_integer_t;var Year,Month,Day:Word);
var
  YYear,XYear,Temp,TempMonth : longint;
begin
  Temp:=((JulianDN-D2) shl 2)-1;
  JulianDN:=Temp div D1;
  XYear:=(Temp mod D1) or 3;
  YYear:=(XYear div D0);
  Temp:=((((XYear mod D0)+4) shr 2)*5)-3;
  Day:=((Temp mod 153)+5) div 5;
  TempMonth:=Temp div 153;
  if TempMonth>=10 then
  begin
    inc(YYear);
    dec(TempMonth,12);
  end;
  inc(TempMonth,3);
  Month := TempMonth;
  Year:=YYear+(JulianDN*100);
end;


procedure UNIXToDateTimeLoc(epoch:big_integer_t;var year,month,day,hour,minute,second:
  Word);
{
  Transforms Epoch time into local time (hour, minute,seconds)
}
var
  DateNum: big_integer_t;
begin
  Datenum:=(Epoch div 86400) + c1970;
  JulianToGregorian(DateNum,Year,Month,day);
  Epoch:=longword(Abs(Epoch mod 86400));
  Hour:=Epoch div 3600;
  Epoch:=Epoch mod 3600;
  Minute:=Epoch div 60;
  Second:=Epoch mod 60;
end;


function TryUNIXToDateTimeExt(unixtime: big_integer_t; var DateTime: TDateTime; var UTC: boolean): boolean;
var
  year,month,day,minute,hour,second: word;
begin
  utc:=true;
  UNIXToDateTimeloc(unixtime, year,month,day,minute,hour,second);
  TryUNIXToDateTimeExt:= dateutils.TryEncodeDateTime(Year, Month, Day, Hour, Minute, Second, 0,
   DateTime);
end;

function TryFileTimeToDateTimeExt(ftime: tfiletime2; var DateTime: TDateTime; var UTC: boolean): boolean;
var
  julianday: float;
  d: float;
  fracvalue:float;
  HighDateTime: float;
begin
  utc:=true;
  TryFileTimeToDateTimeExt:=false;
  { Check if the format of the data is actually encoded as signed value }
  if (Low(ftime.LowDateTime)<0) and (ftime.LowDateTime < 0) then
    begin
      exit;
    end
  else
  julianday:=ftime.LowDateTime;
  if (Low(ftime.HighDateTime)<0) and (ftime.HighDateTime < 0) then
    begin
      exit;
    end
  else
    HighDateTime:=ftime.HighDateTime;

  julianday:=julianday+(HighDateTime*4294967295.0);
  d:=julianday / 864000000000.0 + 2305813.5;
  { Now do some adjustements so that the seconds are valid.
    How do we do this? Well simple, we only keep two digits
    for the hour, minute and seconds parts. }
  fracvalue:=frac(d);
  fracvalue:=fracvalue*10000.0;
  { Round up or down the .00X digit }
  fracvalue:=round(fracvalue);
  d:=int(d);
  { Re-add these digits to the resulting floating point value }
  d:=d+(fracvalue / 10000.0);
  DateTime:=d;
  TryFileTimeToDateTimeExt:=true;
end;

{
  $Log: dateext.inc,v $
  Revision 1.3  2004/11/29 03:50:23  carl
    + UNIX and FILETIME to DateTime conversion

  Revision 1.2  2004/11/23 03:44:51  carl
    * fixes for compilation with Virtual Pascal 2.x

  Revision 1.1  2004/10/31 19:53:06  carl
    + Add support for extended format conversion (Ext routines)

}

End. //6 hours
