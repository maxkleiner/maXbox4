unit xrtl_util_Compare;

{$INCLUDE xrtl.inc}

interface

uses
  xrtl_util_Type, xrtl_util_Compat;

const
  XRTLLessThanValue    = -1;
  XRTLEqualsValue      =  0;
  XRTLGreaterThanValue =  1;

type
  TXRTLValueRelationship = XRTLLessThanValue .. XRTLGreaterThanValue;

  IXRTLComparable = interface
  ['{5D7FAFA1-36C5-4687-8BED-9AF79912C3A9}']
    function   Compare(const IValue: IInterface): TXRTLValueRelationship;
  end;

  IXRTLComparator = interface
  ['{B22C688A-D24B-429F-9CA3-CE6C7EB29DD8}']
    function   Compare(const LValue, RValue: IInterface): TXRTLValueRelationship;
  end;

function  XRTLInvertNonEqualRelationship(const AValue: TXRTLValueRelationship): TXRTLValueRelationship;

implementation

function XRTLInvertNonEqualRelationship(const AValue: TXRTLValueRelationship): TXRTLValueRelationship;
begin
  Result:= - AValue;
end;

end.
