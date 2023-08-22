unit xrtl_util_StrUtils;

{$INCLUDE xrtl.inc}

interface

type
  TXRTLPosProc = function(SubStr, Str: WideString): Integer;

var
  XRTLPos: TXRTLPosProc = nil;

function XRTLFetch(var AInput: WideString; const ADelim: WideString = ' ';
                   const ADelete: Boolean = True): WideString;
function XRTLRPos(const ASub, AIn: WideString; AStart: Integer = -1): Integer;

implementation

uses
  SysUtils,
  xrtl_util_Type, xrtl_util_Compat;

function XRTLFetch(var AInput: WideString; const ADelim: WideString = ' ';
                   const ADelete: Boolean = True): WideString;
var
  LPos: Integer;
  LResult: WideString;
begin
  if ADelim = #0 then
  begin
    // AnsiPos does not work with #0
    LPos:= Pos(ADelim, AInput);
  end
  else
  begin
    LPos:= XRTLPos(ADelim, AInput);
  end;
  if LPos = 0 then
  begin
    LResult:= AInput;
    if ADelete then
    begin
      AInput:= '';
    end;
  end
  else
  begin
    LResult:= Copy(AInput, 1, LPos - 1);
    if ADelete then
    begin
      Delete(AInput, 1, LPos + Length(ADelim) - 1);
    end;
  end;
  // This is necessary to ensure that Result is written last in cases where AInput and Result are
  // assigned to the same variable. Current compilers seem to handle it ok without this, but
  // we cannot safely predict internal workings or future optimizations
  Result:= LResult;
end;

function XRTLRPos(const ASub, AIn: WideString; AStart: Integer = -1): Integer;
var
  I: Integer;
  LStartPos: Integer;
  LTokenLen: Integer;
begin
  Result:= 0;
  LTokenLen:= Length(ASub);
  // Get starting position
  if AStart = -1 then begin
    AStart:= Length(AIn);
  end;
  if AStart < (Length(AIn) - LTokenLen + 1) then
  begin
    LStartPos:= AStart;
  end
  else
  begin
    LStartPos:= (Length(AIn) - LTokenLen + 1);
  end;
  // Search for the string
  for I:= LStartPos downto 1 do
  begin
    if WideSameStr(Copy(AIn, I, LTokenLen), ASub) then
    begin
      Result:= I;
      Break;
    end;
  end;
end;

function XRTLPosProc(SubStr, Str: WideString): Integer;
begin
  Result:= Pos(SubStr, Str);
end;

function XRTLAnsiPosProc(SubStr, Str: WideString): Integer;
begin
  Result:= AnsiPos(SubStr, Str);
end;

initialization
begin
  if LeadBytes = [] then
    XRTLPos:= XRTLPosProc
  else
    XRTLPos:= XRTLAnsiPosProc;
end;

end.
