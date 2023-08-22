unit xrtl_util_VariantUtils;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils, Variants, Classes;

function XRTLGetVariantAsString(const Value: Variant): string;

implementation

const
  BStr: array[False .. True] of string = ('False', 'True');

function XRTLGetVariantAsString(const Value: Variant): string;
var
  I, K, LowBound, HighBound: Integer;
  S: string;
begin
  Result:= '';
  if VarIsArray(Value) then
  begin
    for I:= 1 to VarArrayDimCount(Value) do
    begin
      LowBound:= VarArrayLowBound(Value, I);
      HighBound:= VarArrayHighBound(Value, I);
      for K:= LowBound to HighBound do
      begin
        S:= XRTLGetVariantAsString(Value[K]);
        if Result <> '' then Result:= Result + ',';
        Result:= Result + S;
      end;
    end;
    Result:= Format('[%s]', [Result]);
  end
  else
  begin
    case VarType(Value) of
      varBoolean: Result:= BStr[Value <> 0];
      varError:
      begin
        Result:= Format('%s (0x%.8x)', [SysErrorMessage(TVarData(Value).VInteger),
                                        TVarData(Value).VInteger]);
      end;
    else
      Result:= VarToStr(Value);
    end;
  end;
end;

end.
