unit xrtl_util_TimeZone;

{$INCLUDE xrtl.inc}

interface

uses
  Windows, SysUtils, Classes, Contnrs, Registry;

type
  REGTIMEZONEINFORMATION = packed record
    Bias: LongInt;
    StandardBias: LongInt;
    DaylightBias: LongInt;
    StandardDate: SYSTEMTIME;
    DaylightDate: SYSTEMTIME;
  end;

  TXRTLTimeZone = class
  private
    FIndex: DWORD;
  public
    Display: string;
    Daylight: string;
    Standard: string;
    RTZI: REGTIMEZONEINFORMATION;
    constructor Create;
  end;

  TXRTLTimeZones = class
  private
    FItems: TObjectList;
    function   GetItem(Index: Integer): TXRTLTimeZone;
    function   Add: TXRTLTimeZone;
    function   GetCount: Integer;
    function   GetCurrent: TXRTLTimeZone;
    procedure  Sort;
  public
    constructor Create;
    destructor Destroy; override;
    property   Item[Index: Integer]: TXRTLTimeZone read GetItem;
    property   Count: Integer read GetCount;
    property   Current: TXRTLTimeZone read GetCurrent;
    function   IndexOf(Display: string): Integer;
    procedure  Refresh;
  end;

function XRTLDateTimeToTimeZoneTime(DT: TDateTime; TimeZone: TXRTLTimeZone): TDateTime;
function XRTLGetTimeZones: TXRTLTimeZones;

implementation

uses
  xrtl_util_Lock, xrtl_util_TimeUtils, xrtl_util_Type, xrtl_util_Compat;

var
  FTimeZones: TXRTLTimeZones;
  FTimeZonesLock: IXRTLExclusiveLock; 

function XRTLGetTimeZones: TXRTLTimeZones;
var
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLAcquireExclusiveLock(FTimeZonesLock);
  if not Assigned(FTimeZones) then
    FTimeZones:= TXRTLTimeZones.Create;
  Result:= FTimeZones;
end;

function CompareTimeZones(Item1, Item2: Pointer): Integer;
begin
  if TXRTLTimeZone(Item1).FIndex < TXRTLTimeZone(Item2).FIndex then
    Result:= -1
  else
    if TXRTLTimeZone(Item1).FIndex > TXRTLTimeZone(Item2).FIndex then
      Result:= 1
    else
      Result:= 0;
end;

function XRTLDateTimeToTimeZoneTime(DT: TDateTime; TimeZone: TXRTLTimeZone): TDateTime;
  function ValidSystemTime(ST: SYSTEMTIME): boolean;
  begin
    Result:= (ST.wYear > 0) or
              (ST.wMonth > 0) or
              (ST.wDay > 0) or
              (ST.wHour > 0) or
              (ST.wMinute > 0) or
              (ST.wSecond > 0) or
              (ST.wMilliseconds > 0);
  end;

  function TimeZoneIDDateTime(Year: word; ST: SYSTEMTIME): TDateTime;
  begin
    if ST.wDay = 5 then
    begin
      {last DAYOFWEEK of MONTH}
      if ST.wMonth = 12 then
        Result:= EncodeDate(Year + 1, 1, 1) - 1
      else
        Result:= EncodeDate(Year, ST.wMonth + 1, 1) - 1;
      while DayOfWeek(Result) <> ST.wDayOfWeek + 1 do
        Result:= Result - 1;
    end
    else
    begin
      {DAY'th DAYOFWEEK of MONTH}
      Result:= EncodeDate(Year, ST.wMonth, 1);
      while DayOfWeek(Result) <> ST.wDayOfWeek + 1 do
        Result:= Result + 1;
      Result:= Result + (ST.wDay - 1) * 7;
    end;
    Result:= Result + EncodeTime(ST.wHour, ST.wMinute, ST.wSecond, ST.wMilliSeconds)
  end;

var
  Year, Month, Day: word;
  DaylightDT: TDateTime;
  StandardDT: TDateTime;
begin
  Result:= DT - TimeZone.RTZI.Bias / MinsPerDay;

  if not (ValidSystemTime(TimeZone.RTZI.StandardDate) and
          ValidSystemTime(TimeZone.RTZI.DaylightDate)) then Exit;

  DecodeDate(DT, Year, Month, Day);

  DaylightDT:= TimeZoneIDDateTime(Year, TimeZone.RTZI.DaylightDate) +
    (TimeZone.RTZI.Bias + TimeZone.RTZI.DaylightBias) / MinsPerDay;

  StandardDT:= TimeZoneIDDateTime(Year, TimeZone.RTZI.StandardDate) +
    (TimeZone.RTZI.Bias + TimeZone.RTZI.StandardBias) / MinsPerDay;

  if (DT > DaylightDT) and (DT < StandardDT) then
    Result:= Result - TimeZone.RTZI.DaylightBias / MinsPerDay
  else
    Result:= Result - TimeZone.RTZI.StandardBias / MinsPerDay;
end;

{ TXRTLTimeZone }

constructor TXRTLTimeZone.Create;
begin
  inherited;
  Display:= '';
  Daylight:= '';
  Standard:= '';
  ZeroMemory(@RTZI, SizeOf(RTZI));
end;

{ TXRTLTimeZones }

constructor TXRTLTimeZones.Create;
begin
  inherited;
  FItems:= TObjectList.Create(True);
  Refresh;
end;

destructor TXRTLTimeZones.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

function TXRTLTimeZones.Add: TXRTLTimeZone;
begin
  Result:= TXRTLTimeZone.Create;
  FItems.Add(Result);
end;

function TXRTLTimeZones.GetCount: Integer;
begin
  Result:= FItems.Count;
end;

function TXRTLTimeZones.GetCurrent: TXRTLTimeZone;
var
  TZI: TIME_ZONE_INFORMATION;
  i: Integer;
begin
  Result:= nil;
  ZeroMemory(@TZI, SizeOf(TZI));
  GetTimeZoneInformation(TZI);
  for i:= 0 to Count - 1 do
  begin
    if (Item[i].RTZI.Bias = TZI.Bias) and
       (Item[i].Daylight = string(TZI.DaylightName)) and
       (Item[i].Standard = string(TZI.StandardName)) then
    begin
      Result:= Item[i];
      Exit;
    end;
  end;
end;

function TXRTLTimeZones.GetItem(Index: Integer): TXRTLTimeZone;
begin
  Result:= TXRTLTimeZone(FItems[Index]);
end;

function TXRTLTimeZones.IndexOf(Display: string): Integer;
begin
  for Result:= 0 to Count - 1 do
    if Item[Result].Display = Display then
      Exit;
  Result:= -1;
end;

procedure TXRTLTimeZones.Refresh;
const
  SKEY_NT = '\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\';
  SKEY_9X = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Time Zones\';
var
  osV: OSVERSIONINFO;
  TimeZonesKey: string;
  KeyNames: TStringList;
  Registry: TRegistry;
  i: Integer;
begin
  FItems.Clear;

  osV.dwOSVersionInfoSize:= SizeOf(osV);
  GetVersionEx(osV);
  if osV.dwPlatformId = VER_PLATFORM_WIN32_NT then
    TimeZonesKey:= SKEY_NT
  else
    TimeZonesKey:= SKEY_9X;

  Registry:= nil;
  KeyNames:= nil;
  try
    Registry:= TRegistry.Create;

    Registry.RootKey:= HKEY_LOCAL_MACHINE;

    if not Registry.OpenKeyReadOnly(TimeZonesKey) then Exit;

    KeyNames:= TStringList.Create;

    Registry.GetKeyNames(KeyNames);

    for i:= 0 to KeyNames.Count - 1 do
    begin
      if not Registry.OpenKeyReadOnly(TimeZonesKey + KeyNames[i]) then
        Continue;
      with Add do
      begin
        Registry.ReadBinaryData('TZI', RTZI, SizeOf(RTZI));
        Display:= Registry.ReadString('Display');
        Daylight:= Registry.ReadString('Dlt');
        Standard:= Registry.ReadString('Std');
        if TimeZonesKey = SKEY_NT then
          FIndex:= Registry.ReadInteger('Index')
        else
          FIndex:= Count - 1;
      end;
    end;

    Sort;

  finally
    Registry.CloseKey;
    FreeAndNil(Registry);
    FreeAndNil(KeyNames);
  end;
end;


procedure TXRTLTimeZones.Sort;
begin
  FItems.Sort(CompareTimeZones);
end;

initialization
begin
  FTimeZones:= nil;
  FTimeZonesLock:= XRTLCreateExclusiveLock;
end;

finalization
begin
  FreeAndNil(FTimeZones);
end;

end.
