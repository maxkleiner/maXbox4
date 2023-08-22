
unit uPSR_dateutils;
{$I PascalScript.inc}
interface
uses
  SysUtils, uPSRuntime, math, dateutils;



procedure RegisterDateTimeLibrary_R(S: TPSExec);

implementation

function TryEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;
begin
  try
    Date := EncodeDate(Year, Month, Day);
    Result := true;
  except
    Result := false;
  end;
end;

function TryEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDateTime): Boolean;
begin
  try
    Time := EncodeTime(hour, Min, Sec, MSec);
    Result := true;
  except
    Result := false;
  end;
end;

function DateTimeToUnix(D: TDateTime): Int64;
begin
  Result := Round((D - 25569) * 86400);
end;

function UnixToDateTime(U: Int64): TDateTime;
begin
  Result := U / 86400 + 25569;
end;


procedure RegisterDateTimeLibrary_R(S: TPSExec);
begin
  S.RegisterDelphiFunction(@EncodeDate, 'ENCODEDATE', cdRegister);
  S.RegisterDelphiFunction(@EncodeTime, 'ENCODETIME', cdRegister);
  S.RegisterDelphiFunction(@TryEncodeDate, 'TRYENCODEDATE', cdRegister);
  S.RegisterDelphiFunction(@TryEncodeTime, 'TRYENCODETIME', cdRegister);
  S.RegisterDelphiFunction(@DecodeDate, 'DECODEDATE', cdRegister);
  S.RegisterDelphiFunction(@DecodeTime, 'DECODETIME', cdRegister);
  S.RegisterDelphiFunction(@DayOfWeek, 'DAYOFWEEK', cdRegister);
  S.RegisterDelphiFunction(@DayOfTheYear, 'DayOfTheYear', cdRegister);
  S.RegisterDelphiFunction(@DayOfTheMonth, 'DayOftheMonth', cdRegister);

  S.RegisterDelphiFunction(@Date, 'DATE', cdRegister);
  S.RegisterDelphiFunction(@Time, 'TIME', cdRegister);
  //S.RegisterDelphiFunction(@Now, 'NOW', cdRegister);
  S.RegisterDelphiFunction(@DateTimeToUnix, 'DATETIMETOUNIX', cdRegister);
  S.RegisterDelphiFunction(@UnixToDateTime, 'UNIXTODATETIME', cdRegister);
  S.RegisterDelphiFunction(@DateToStr, 'DATETOSTR', cdRegister);
  S.RegisterDelphiFunction(@FormatDateTime, 'FORMATDATETIME', cdRegister);
  S.RegisterDelphiFunction(@StrToDate, 'STRTODATE', cdRegister);
  //S.RegisterDelphiFunction(@StdDev, 'STDDEV', cdRegister);
  S.RegisterDelphiFunction(@FileDateToDateTime, 'FILEDATETODATETIME', cdRegister);
  S.RegisterDelphiFunction(@DateTimeToFileDate, 'DATETIMETOFILEDATE', cdRegister);
  S.RegisterDelphiFunction(@Format, 'FORMAT', cdRegister);
  S.RegisterDelphiFunction(@Upcase, 'UPCASE', cdRegister);
  //s.RegisterDelphiFunction(@StrScan, 'STRSCAN', cdRegister);
  S.RegisterDelphiFunction(@Upcase, 'UPCASE', cdRegister);
  S.RegisterDelphiFunction(@TimeToStr, 'TIMETOSTR', cdRegister);
  S.RegisterDelphiFunction(@DateToStr, 'DATETOSTR', cdRegister);
  S.RegisterDelphiFunction(@SystemTimeToDateTime, 'SystemTimeToDateTime', cdRegister);
  S.RegisterDelphiFunction(@DateTimeToSystemTime, 'DateTimeToSystemTime', cdRegister);
  S.RegisterDelphiFunction(@DateTimeToString, 'DateTimeToString', cdRegister);
  S.RegisterDelphiFunction(@DateTimeToTimeStamp, 'DateTimeToTimeStamp', cdRegister);
  S.RegisterDelphiFunction(@TimeStampToDateTime, 'TimeStampToDateTime', cdRegister);
  //S.RegisterDelphiFunction(@DateTimeToTimeStamp, 'DateTimeToTimeStamp', cdRegister);
  //S.RegisterDelphiFunction(@TimeStampToDateTime, 'TimeStampToDateTime', cdRegister);
  S.RegisterDelphiFunction(@IncMonth, 'IncMonth', cdRegister);
  S.RegisterDelphiFunction(@IsLeapYear, 'IsLeapYear', cdRegister);
  S.RegisterDelphiFunction(@MSecsToTimeStamp, 'MSecsToTimeStamp', cdRegister);
  S.RegisterDelphiFunction(@TimeStampToMSecs, 'TimeStampToMSecs', cdRegister);
  S.RegisterDelphiFunction(@ReplaceDate, 'ReplaceDate', cdRegister);
  S.RegisterDelphiFunction(@ReplaceTime, 'ReplaceTime', cdRegister);
  S.RegisterDelphiFunction(@StrToDateTime, 'StrToDateTime', cdRegister);
  S.RegisterDelphiFunction(@StrToTime, 'StrToTime', cdRegister);
  S.RegisterDelphiFunction(@IsToday, 'IsToday', cdRegister);
  S.RegisterDelphiFunction(@CompareDate, 'CompareDate', cdRegister);
  S.RegisterDelphiFunction(@CompareTime, 'CompareTime', cdRegister);
  S.RegisterDelphiFunction(@SameDateTime, 'SameDateTime', cdRegister);
  S.RegisterDelphiFunction(@SameDate, 'SameDate', cdRegister);
  S.RegisterDelphiFunction(@SameTime, 'SameTime', cdRegister);


  //comparedate


 end;

end.
