unit xrtl_util_TimeStamp;

{$INCLUDE xrtl.inc}

interface

uses
  Windows, SysUtils, Classes,
  xrtl_util_Compare;

type
  TXRTLTimeStamp = class(TPersistent)
  private
    FUTCFileTime: TFileTime;
    function   GetUTCSystemTime: TSystemTime;
    procedure  SetUTCSystemTime(const Value: TSystemTime);
    function   GetLocalSystemTime: TSystemTime;
    procedure  SetLocalSystemTime(const Value: TSystemTime);
    function   GetUTCFileTime: TFileTime;
    procedure  SetUTCFileTime(const Value: TFileTime);
    function   GetLocalFileTime: TFileTime;
    procedure  SetLocalFileTime(const Value: TFileTime);
    function   GetUTCDateTime: TDateTime;
    procedure  SetUTCDateTime(const Value: TDateTime);
    function   GetLocalDateTime: TDateTime;
    procedure  SetLocalDateTime(const Value: TDateTime);
    function   GetUTCAge: Integer;
    procedure  SetUTCAge(const Value: Integer);
    function   GetLocalAge: Integer;
    procedure  SetLocalAge(const Value: Integer);
    function   GetUTCTimeStamp: TTimeStamp;
    procedure  SetUTCTimeStamp(const Value: TTimeStamp);
    function   GetLocalTimeStamp: TTimeStamp;
    procedure  SetLocalTimeStamp(const Value: TTimeStamp);
  public
    constructor Create;
    procedure  Assign(APersistent: TPersistent); override;
    procedure  SetCurrentTime;
    function   Compare(const ATimeStamp: TXRTLTimeStamp): TXRTLValueRelationship;
    property   UTCSystemTime: TSystemTime read GetUTCSystemTime write SetUTCSystemTime;
    property   LocalSystemTime: TSystemTime read GetLocalSystemTime write SetLocalSystemTime;
    property   UTCFileTime: TFileTime read GetUTCFileTime write SetUTCFileTime;
    property   LocalFileTime: TFileTime read GetLocalFileTime write SetLocalFileTime;
    property   UTCDateTime: TDateTime read GetUTCDateTime write SetUTCDateTime;
    property   LocalDateTime: TDateTime read GetLocalDateTime write SetLocalDateTime;
    property   UTCAge: Integer read GetUTCAge write SetUTCAge;
    property   LocalAge: Integer read GetLocalAge write SetLocalAge;
    property   UTCTimeStamp: TTimeStamp read GetUTCTimeStamp write SetUTCTimeStamp;
    property   LocalTimeStamp: TTimeStamp read GetLocalTimeStamp write SetLocalTimeStamp;
  end;

implementation

{ TXRTLTimeStamp }

constructor TXRTLTimeStamp.Create;
begin
  inherited Create;
  SetCurrentTime;
end;

procedure TXRTLTimeStamp.Assign(APersistent: TPersistent);
var
  ATimeStamp: TXRTLTimeStamp;
begin
  if APersistent is TXRTLTimeStamp then
  begin
    ATimeStamp:= APersistent as TXRTLTimeStamp;
    FUTCFileTime:= ATimeStamp.FUTCFileTime;
  end
  else
    inherited;
end;

procedure TXRTLTimeStamp.SetCurrentTime;
begin
  GetSystemTimeAsFileTime(FUTCFileTime);
end;

function TXRTLTimeStamp.Compare(const ATimeStamp: TXRTLTimeStamp): TXRTLValueRelationship;
const
  CompareFileTimeToTXRTLValueRelationshipMap: array[-1 .. 1] of TXRTLValueRelationship = (
    XRTLLessThanValue, XRTLEqualsValue, XRTLGreaterThanValue
  );
begin
  Result:= CompareFileTimeToTXRTLValueRelationshipMap[CompareFileTime(FUTCFileTime, ATimeStamp.FUTCFileTime)];
end;

function TXRTLTimeStamp.GetUTCSystemTime: TSystemTime;
begin
  FileTimeToSystemTime(FUTCFileTime, Result);
end;

procedure TXRTLTimeStamp.SetUTCSystemTime(const Value: TSystemTime);
begin
  SystemTimeToFileTime(Value, FUTCFileTime);
end;

function TXRTLTimeStamp.GetLocalSystemTime: TSystemTime;
var
  LFT: TFileTime;
begin
  FileTimeToLocalFileTime(FUTCFileTime, LFT);
  FileTimeToSystemTime(LFT, Result);
end;

procedure TXRTLTimeStamp.SetLocalSystemTime(const Value: TSystemTime);
var
  LFT: TFileTime;
begin
  SystemTimeToFileTime(Value, LFT);
  LocalFileTime:= LFT;
end;

function TXRTLTimeStamp.GetUTCFileTime: TFileTime;
begin
  Result:= FUTCFileTime;
end;

procedure TXRTLTimeStamp.SetUTCFileTime(const Value: TFileTime);
begin
  FUTCFileTime:= Value;
end;

function TXRTLTimeStamp.GetLocalFileTime: TFileTime;
begin
  FileTimeToLocalFileTime(FUTCFileTime, Result);
end;

procedure TXRTLTimeStamp.SetLocalFileTime(const Value: TFileTime);
begin
  LocalFileTimeToFileTime(Value, FUTCFileTime);
end;

function TXRTLTimeStamp.GetUTCDateTime: TDateTime;
begin
  Result:= SystemTimeToDateTime(UTCSystemTime);
end;

procedure TXRTLTimeStamp.SetUTCDateTime(const Value: TDateTime);
var
  UST: TSystemTime;
begin
  DateTimeToSystemTime(Value, UST);
  UTCSystemTime:= UST;
end;

function TXRTLTimeStamp.GetLocalDateTime: TDateTime;
begin
  Result:= SystemTimeToDateTime(LocalSystemTime);
end;

procedure TXRTLTimeStamp.SetLocalDateTime(const Value: TDateTime);
var
  LST: TSystemTime;
begin
  DateTimeToSystemTime(Value, LST);
  LocalSystemTime:= LST;
end;

function TXRTLTimeStamp.GetUTCAge: Integer;
begin
  FileTimeToDosDateTime(UTCFileTime, LongRec(Result).Hi, LongRec(Result).Lo);
end;

procedure TXRTLTimeStamp.SetUTCAge(const Value: Integer);
var
  UFT: TFileTime;
begin
  DosDateTimeToFileTime(LongRec(Value).Hi, LongRec(Value).Lo, UFT);
  UTCFileTime:= UFT;
end;

function TXRTLTimeStamp.GetLocalAge: Integer;
begin
  FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi, LongRec(Result).Lo);
end;

procedure TXRTLTimeStamp.SetLocalAge(const Value: Integer);
var
  LFT: TFileTime;
begin
  DosDateTimeToFileTime(LongRec(Value).Hi, LongRec(Value).Lo, LFT);
  LocalFileTime:= LFT;
end;

function TXRTLTimeStamp.GetUTCTimeStamp: TTimeStamp;
begin
  Result:= DateTimeToTimeStamp(UTCDateTime);
end;

procedure TXRTLTimeStamp.SetUTCTimeStamp(const Value: TTimeStamp);
begin
  UTCDateTime:= TimeStampToDateTime(Value);
end;

function TXRTLTimeStamp.GetLocalTimeStamp: TTimeStamp;
begin
  Result:= DateTimeToTimeStamp(LocalDateTime);
end;

procedure TXRTLTimeStamp.SetLocalTimeStamp(const Value: TTimeStamp);
begin
  LocalDateTime:= TimeStampToDateTime(Value);
end;

end.

