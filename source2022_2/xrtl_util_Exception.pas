unit xrtl_util_Exception;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils;

type
  EXRTLException        = class(Exception);
  EXRTLNotImplemented   = class(EXRTLException);
  EXRTLInvalidOperation = class(EXRTLException);

procedure XRTLNotImplemented;
procedure XRTLRaiseError(E: Exception = nil);
procedure XRTLInvalidOperation(ClassName: string; OperationName: string = '';
                               Description: string = '');
implementation

uses
  xrtl_util_ResourceStrings;

procedure XRTLNotImplemented;
begin
  raise EXRTLNotImplemented.Create(SXRTLNotImplemented);
end;

procedure XRTLRaiseError(E: Exception = nil);
begin
  if Assigned(E) then
    raise E
  else
  begin
{$IFDEF COMPILER6_UP}
    RaiseLastOSError;
{$ELSE}
    RaiseLastWin32Error;
{$ENDIF}
  end;
end;

procedure XRTLInvalidOperation(ClassName: string; OperationName: string = '';
  Description: string = '');
var
  ExceptionMsg: string;
begin
  ExceptionMsg:= Format(SXRTLInvalidOperation1, [ClassName]);
  if Trim(OperationName) <> '' then
    ExceptionMsg:= ExceptionMsg + Format(SXRTLInvalidOperation2, [OperationName]);
  if Trim(Description) <> '' then
    ExceptionMsg:= ExceptionMsg + Format(SXRTLInvalidOperation3, [Description]);
  raise EXRTLInvalidOperation.Create(ExceptionMsg);
end;

end.
