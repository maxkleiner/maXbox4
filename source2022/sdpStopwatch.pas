// ������, ����������� ������-����������.
// ������ ��� Delphi 5 � 32-� ��������� �����������.
// �����: ������� �. �.

unit sdpStopwatch;

interface

type
  // ����������
  TStopwatch = class
    procedure Start;                                    // ��������� ����������
    procedure Stop;                                 // ������������� ����������
    function GetValueStr: String;             // ���������� ����� � ���� ������
    function GetTimeString: String;             // to be continue
    function GetTimeStr: String;
    function GetValueMSec: Cardinal;        // ���������� ����� � �������������
  private
    StartTime: TDateTime;                          // ����� ������� �����������
    StopTime: TDateTime;                         // ����� ��������� �����������
  end;

 

implementation

uses
  SysUtils;

// ****************************************************************************
// **********               ������ ������� TStopwatch                **********
// ****************************************************************************

procedure TStopwatch.Start;
begin
  StartTime := Time;
end;

procedure TStopwatch.Stop;
begin
  StopTime := Time;
end;

function TStopwatch.GetValueStr: String;
var
  Value: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  Value := StopTime - StartTime;
  DecodeTime(Value, Hour, Min, Sec, MSec);
  Result := IntToStr(Hour) + ':' + IntToStr(Min) + ':' + IntToStr(Sec) + '.' +
    IntToStr(MSec);
end;

function TStopwatch.GetTimeString: String;
begin
  result:= getValueStr;
end;

function TStopwatch.GetTimeStr: String;
begin
  result:= getValueStr;
end;

function TStopWatch.GetValueMSec: Cardinal;
var
  Value: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  Value := StopTime - StartTime;
  DecodeTime(Value, Hour, Min, Sec, MSec);
  Result := 3600*1000*Hour + 60*1000*Min + 1000*Sec + MSec;
end;

end.
