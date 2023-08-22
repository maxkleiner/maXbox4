unit xrtl_util_ThreadUtils;

{$INCLUDE xrtl.inc}

interface

function XRTLIsInMainThread: Boolean;

implementation

uses
  Windows;

function XRTLIsInMainThread: Boolean;
begin
  Result:= GetCurrentThreadID = MainThreadID;
end;

end.
