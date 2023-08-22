unit RTLDateTimeplus;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// This unit cointains a few useful Date/DateTime functions such as Change System Time or testing string for valid Date
// Also a TNullableDateTime

interface

type
  // immutable and nullable TDateTime
  TNullableDateTime = record
  private
    FValue: TDateTime;
    FHasValue: Boolean;
  public
    constructor Create(const AValue: TDateTime);
    function Value: TDateTime;
    function HasValue: Boolean;
  end;

{$REGION 'Date/DateTime Testing'}
function IsValidDate(const Value: string; out ADate: TDatetime): Boolean;
function IsValidTime(const Value: string; out ATime: TDateTime): Boolean;
function IsValidDateTime(const Value: string; out ADateTime: TDateTime): Boolean;
{$ENDREGION}
  
procedure ChangeSystemTime(const Value: TDateTime);
function TryChangeSystemTime(const Value: TDateTime): Boolean;

implementation

uses
  {$IF CompilerVersion > 21}
  System.SysUtils,
  System.DateUtils,
  System.Types,
  Winapi.Windows;
  {$ELSE}
  SysUtils,
  DateUtils,
  Types,
  Windows;
  {$IFEND}
  
type
  TDateUtils = class
  strict private
    class var FSystemTime: TNullableDateTime;
    class procedure SaveOriginalDate(const Value: TDateTime);
    class procedure RestoreOriginalDate;
  public
    destructor Destroy;
    class function IsValidDateTime(const Value: string; out ADateTime: TDateTime): Boolean;
    class function IsValidDate(const Value: string; out ADate: TDatetime): Boolean;
    class function IsValidTime(const Value: string; out ATime: TDateTime): Boolean;
	// will try to change the system time; if succeded when the class is destroyed, it will restore the date
    class function ChangeSystemTime(const Value: TDateTime): Boolean;
  end;
  
{$REGION 'Date/DateTime Testing'}
function IsValidDate(const Value: string; out ADate: TDatetime): Boolean;
begin
  Result := TDateUtils.IsValidDate(Value, ADate);
end;

function IsValidTime(const Value: string; out ATime: TDateTime): Boolean;
begin
  Result := TDateUtils.IsValidTime(Value, ATime);
end;

function IsValidDateTime(const Value: string; out ADateTime: TDateTime): Boolean;
begin
  Result := TDateUtils.IsValidDateTime(Value, ADateTime);
end;
{$ENDREGION}

function TryChangeSystemTime(const Value: TDateTime): Boolean;
begin
  Result := TDateUtils.ChangeSystemTime(Value);
end;

procedure ChangeSystemTime(const Value: TDateTime);
begin
  if not TryChangeSystemTime(Value) then
    RaiseLastOSError;
end;

{$REGION 'TDateUtils class'}

function CheckToday(const ADate: TDateTime): Boolean;
var
  AToday, Value: TDateTime;
begin
  AToday := RecodeTime(Today, 0, 0, 0, 0);
  Value := RecodeTime(ADate, 0, 0, 0, 0);
  Result := CompareDate(Value, AToday) = EqualsValue;
end;

class procedure TDateUtils.RestoreOriginalDate;
var
  LSysTime: TSystemTime;
begin
  if not FSystemTime.HasValue then
    Exit;

  LSysTime.wYear := YearOf(FSystemTime.Value);
  LSysTime.wMonth := MonthOf(FSystemTime.Value);
  LSysTime.wDay := DayOf(FSystemTime.Value);
  LSysTime.wHour := HourOf(Now);
  LSysTime.wMinute := MinuteOf(Now);
  LSysTime.wSecond := SecondOf(Now);
  SetLocalTime(LSysTime);
end;

class procedure TDateUtils.SaveOriginalDate(const Value: TDateTime);
begin
  if not FSystemTime.HasValue then
    FSystemTime := TNullableDateTime.Create(Value);
end;

class function TDateUtils.ChangeSystemTime(const Value: TDateTime): Boolean;
var
  LSysTime: TSystemTime;
  LOriginalDate: TDatetime;
begin
  LOriginalDate := Today;
  if CheckToday(Value) then
    Exit;

  LSysTime.wYear := YearOf(Value);
  LSysTime.wMonth := MonthOf(Value);
  LSysTime.wDay := DayOf(Value);
  LSysTime.wHour := HourOf(Now);
  LSysTime.wMinute := MinuteOf(Now);
  LSysTime.wSecond := SecondOf(Now);
  Result := SetLocalTime(LSysTime);

  if Result then
    SaveOriginalDate(LOriginalDate);
end;

 destructor TDateUtils.Destroy;
begin
  RestoreOriginalDate;
end;

class function TDateUtils.IsValidDate(const Value: string; out ADate: TDatetime): Boolean;
var
  LDateTime: TDateTime;
begin
  Result := TryStrToDate(Value, LDateTime);
  ADate := DateOf(LDateTime);
end;

class function TDateUtils.IsValidTime(const Value: string; out ATime: TDateTime): Boolean;
var
  LDateTime: TDateTime;
begin
  Result := TryStrToTime(Value, LDateTime);
  ATime := TimeOf(LDateTime);
end;

class function TDateUtils.IsValidDateTime(const Value: string; out ADateTime: TDateTime): Boolean;
begin
  Result := TryStrToDate(Value, ADateTime);
end;

{$ENDREGION}

{ TNullableDateTime }

constructor TNullableDateTime.Create(const AValue: TDateTime);
begin
  FValue := AValue;
  FHasValue := True;
end;

function TNullableDateTime.HasValue: Boolean;
begin
  Result := FHasValue;
end;

function TNullableDateTime.Value: TDateTime;
begin
  if not FHasValue then
    raise Exception.Create('TNullableDateTime was not initialized');

  Result := FValue;
end;

end.
