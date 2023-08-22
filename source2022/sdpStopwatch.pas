// Модуль, реализующий объект-секундомер.
// Версия для Delphi 5 и 32-х разрядных процессоров.
// Автор: Сидоров Д. П.

unit sdpStopwatch;

interface

type
  // Секундомер
  TStopwatch = class
    procedure Start;                                    // Запускает секундомер
    procedure Stop;                                 // Останавливает секундомер
    function GetValueStr: String;             // Замеренное время в виде строки
    function GetTimeString: String;             // to be continue
    function GetTimeStr: String;
    function GetValueMSec: Cardinal;        // Замеренное время в миллисекундах
  private
    StartTime: TDateTime;                          // Время запуска секундомера
    StopTime: TDateTime;                         // Время остановки секундомера
  end;

 

implementation

uses
  SysUtils;

// ****************************************************************************
// **********               Методы объекта TStopwatch                **********
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
