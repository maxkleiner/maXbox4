{ Compile time Date Time library }
unit uPSC_dateutils;

interface
uses
  SysUtils, uPSCompiler, uPSUtils;


procedure RegisterDateTimeLibrary_C(S: TPSPascalCompiler);

implementation


 type _SYSTEMTIME = record
       wYear: Word;
       wMonth: Word;
    wDayOfWeek: Word;
    wDay: Word;
    wHour: Word;
    wMinute: Word;
    wSecond: Word;
    wMilliseconds: Word;
  end;
  TSystemTime = _SYSTEMTIME;


var m: TDatetime;

procedure RegisterDatetimeLibrary_C(S: TPSPascalCompiler);
begin
  s.AddType('TDateTime', btDouble).ExportName := True;
  //s.AddTypeS('TSystemTime', 'TSystemTime');

 // S.AddTypeS('TLongDayNames','array[1..7] of string');
 // S.AddTypeS('TLongMonthNames','array[1..12] of string');
  S.AddTypeS('Comp','Int64');     //mx3 beta
                 //tdatetime
  //type
  //S.AddTypeS('TValueRelationship','(minus,zero,plus)');
  S.AddTypeS('TValueRelationship','array[-1..1] of byte)');

  S.AddTypeS('TTimeStamp', 'record Time: Integer; Date: Integer; end');
  S.AddTypeS('_SYSTEMTIME', 'record wYear : Word; wMonth : Word; wDayOfWeek : '
   +'Word; wDay : Word; wHour : Word; wMinute : Word; wSecond : Word; wMillisec'
   +'onds : Word; end');
  S.AddTypeS('TSystemTime', '_SYSTEMTIME');
   S.AddTypeS('SYSTEMTIME', '_SYSTEMTIME'); //from in sysutils_max*)

  s.AddDelphiFunction('function EncodeDate(Year, Month, Day: Word): TDateTime;');
  s.AddDelphiFunction('function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;');
  s.AddDelphiFunction('function TryEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;');
  s.AddDelphiFunction('function TryEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDateTime): Boolean;');
  s.AddDelphiFunction('procedure DecodeDate(const DateTime: TDateTime; var Year, Month, Day: Word);');
  s.AddDelphiFunction('procedure DecodeTime(const DateTime: TDateTime; var Hour, Min, Sec, MSec: Word);');
  s.AddDelphiFunction('function DayOfWeek(const DateTime: TDateTime): Word;');
  s.AddDelphiFunction('function DayOfTheYear(const AValue: TDateTime): Word;');
  s.AddDelphiFunction('function DayOfTheMonth(const AValue: TDateTime): Word;');

  s.AddDelphiFunction('function Date: TDateTime;');
  s.AddDelphiFunction('function Time: TDateTime;');
  //s.AddDelphiFunction('function Now: TDateTime;');
  s.AddDelphiFunction('function DateTimeToUnix(D: TDateTime): Int64;');
  s.AddDelphiFunction('function UnixToDateTime(U: Int64): TDateTime;');
  s.AddDelphiFunction('function DateToStr(D: TDateTime): string;');
  s.AddDelphiFunction('function StrToDate(const s: string): TDateTime;');
  s.AddDelphiFunction('function FormatDateTime(const fmt: string; D: TDateTime): string;');
  //s.AddDelphiFunction('function StdDev(const Data: array of Double): Extended;');
  s.AddDelphiFunction('function FileDateToDateTime(FileDate: Integer): TDateTime;');
  s.AddDelphiFunction('function DateTimeToFileDate(DateTime: TDateTime): Integer;');
  s.AddDelphiFunction('function Format(const Format: string; const Args: array of const): string;');
  s.AddDelphiFunction('function UpCase(ch : Char ) : Char;');
  //s.AddDelphiFunction('function StrScan(const Str: PansiChar; Chr: Char): PansiChar;');
  s.AddDelphiFunction('function TimeToStr(const DateTime: TDateTime): string;');
  s.AddDelphiFunction('function DateToStr(const DateTime: TDateTime): string;');

  s.AddDelphiFunction('function SystemTimeToDateTime(const SystemTime: TSystemTime): TDateTime;');
  s.AddDelphiFunction('procedure DateTimeToSystemTime(const DateTime: TDateTime; var SystemTime: TSystemTime);');
  s.AddDelphiFunction('procedure DateTimeToString(var Result: string; const Format: string; DateTime: TDateTime)');
  s.AddDelphiFunction('function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp');
  s.AddDelphiFunction('function TimeStampToDateTime(const TimeStamp: TTimeStamp): TDateTime');
  s.AddDelphiFunction('function IncMonth(const DateTime: TDateTime; NumberOfMonths: Integer): TDateTime)');
  s.AddDelphiFunction('function IsLeapYear(Year: Word): Boolean)');
  s.AddDelphiFunction('function MSecsToTimeStamp(MSecs: Comp): TTimeStamp)');
  s.AddDelphiFunction('function TimeStampToMSecs(const TimeStamp: TTimeStamp): Comp)');
  s.AddDelphiFunction('procedure ReplaceDate(var DateTime: TDateTime; const NewDate: TDateTime))');
  s.AddDelphiFunction('procedure ReplaceTime(var DateTime: TDateTime; const NewTime: TDateTime);');
  s.AddDelphiFunction('function StrToDateTime(const S: string): TDateTime)');
  s.AddDelphiFunction('function StrToTime(const S: string): TDateTime)');   //overload
  s.AddDelphiFunction('function IsToday(const AValue: TDateTime): Boolean;');
  s.AddDelphiFunction('function CompareDate(const A, B: TDateTime): TValueRelationship;');
  s.AddDelphiFunction('function CompareTime(const A, B: TDateTime): TValueRelationship;');
  s.AddDelphiFunction('function SameDateTime(const A, B: TDateTime): Boolean;');
  s.AddDelphiFunction('function SameDate(const A, B: TDateTime): Boolean;');
  s.AddDelphiFunction('function SameTime(const A, B: TDateTime): Boolean;');

      //comparedatedatetime
 end;

end.
