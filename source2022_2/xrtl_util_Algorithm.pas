unit xrtl_util_Algorithm;

{$INCLUDE xrtl.inc}

interface

uses
  xrtl_util_Compare, xrtl_util_Value, xrtl_util_Container;

type
  IXRTLIfFunctor = interface
  ['{268CFEF0-3CD1-4F31-9663-9B7BCC5FD9B2}']
    function   IfValue(const IValue: IXRTLValue): Boolean;
  end;

  TXRTLTrueIfFunctor = class(TInterfacedObject, IXRTLIfFunctor)
    function   IfValue(const IValue: IXRTLValue): Boolean;
  end;

  TXRTLFalseIfFunctor = class(TInterfacedObject, IXRTLIfFunctor)
    function   IfValue(const IValue: IXRTLValue): Boolean;
  end;

function XRTLCopy(const Src: TXRTLSequentialContainer; const Dst: TXRTLSequentialContainer;
  const SrcStartPosition: IXRTLIterator = nil; const SrcEndPosition: IXRTLIterator = nil;
  const DstStartPosition: IXRTLIterator = nil): Cardinal; overload;

function XRTLCopyIf(const Src: TXRTLSequentialContainer; const Dst: TXRTLSequentialContainer;
  const IfFunctor: IXRTLIfFunctor; const SrcStartPosition: IXRTLIterator = nil;
  const SrcEndPosition: IXRTLIterator = nil; const DstStartPosition: IXRTLIterator = nil): Cardinal; overload;

function XRTLCopy(const Src: TXRTLValueArray; const Dst: TXRTLSequentialContainer;
  const SrcStartPosition: Integer = -1; const SrcEndPosition: Integer = -1;
  const DstStartPosition: IXRTLIterator = nil): Cardinal; overload;

function XRTLCopyIf(const Src: TXRTLValueArray; const Dst: TXRTLSequentialContainer;
  const IfFunctor: IXRTLIfFunctor; const SrcStartPosition: Integer = -1;
  const SrcEndPosition: Integer = -1; const DstStartPosition: IXRTLIterator = nil): Cardinal; overload;

function XRTLCopy(const Src: TXRTLValueArray; const Dst: TXRTLSetContainer;
  const SrcStartPosition: Integer = -1; const SrcEndPosition: Integer = -1): Cardinal; overload;

function XRTLCopyIf(const Src: TXRTLValueArray; const Dst: TXRTLSetContainer;
  const IfFunctor: IXRTLIfFunctor; const SrcStartPosition: Integer = -1;
  const SrcEndPosition: Integer = -1): Cardinal; overload;

function XRTLRemoveIf(const Container: TXRTLSequentialContainer; const IfFunctor: IXRTLIfFunctor;
  const StartPosition: IXRTLIterator = nil; const EndPosition: IXRTLIterator = nil): Cardinal;

function XRTLSplitIf(const Src, Dst: TXRTLSequentialContainer;
  const IfFunctor: IXRTLIfFunctor; const SrcStartPosition: IXRTLIterator = nil;
  const SrcEndPosition: IXRTLIterator = nil; const DstStartPosition: IXRTLIterator = nil): Cardinal;

implementation

function XRTLCopy(const Src: TXRTLSequentialContainer; const Dst: TXRTLSequentialContainer;
  const SrcStartPosition: IXRTLIterator = nil; const SrcEndPosition: IXRTLIterator = nil;
  const DstStartPosition: IXRTLIterator = nil): Cardinal;
begin
  Result:= XRTLCopyIf(Src, Dst, TXRTLTrueIfFunctor.Create, SrcStartPosition, SrcEndPosition, DstStartPosition);
end;

function XRTLCopyIf(const Src: TXRTLSequentialContainer; const Dst: TXRTLSequentialContainer;
  const IfFunctor: IXRTLIfFunctor; const SrcStartPosition: IXRTLIterator = nil;
  const SrcEndPosition: IXRTLIterator = nil; const DstStartPosition: IXRTLIterator = nil): Cardinal;
var
  LSrcStartPosition, LSrcEndPosition, LDstStartPosition: IXRTLIterator;
begin
  Result:= 0;
  LSrcStartPosition:= SrcStartPosition;
  if not Assigned(LSrcStartPosition) then
    LSrcStartPosition:= Src.AtBegin;
  LSrcEndPosition:= SrcEndPosition;
  if not Assigned(LSrcEndPosition) then
    LSrcEndPosition:= Src.AtEnd;
  LDstStartPosition:= DstStartPosition;
  if not Assigned(LDstStartPosition) then
    LDstStartPosition:= Dst.AtEnd;
  while LSrcStartPosition.Compare(LSrcEndPosition) <> XRTLEqualsValue do
  begin
    if IfFunctor.IfValue(Src.GetValue(LSrcStartPosition)) then
    begin
      Dst.Insert(Src.GetValue(LSrcStartPosition), LDstStartPosition);
      Inc(Result);
    end;
    LSrcStartPosition.Next;
  end;
end;

function XRTLCopy(const Src: TXRTLValueArray; const Dst: TXRTLSequentialContainer;
  const SrcStartPosition: Integer = -1; const SrcEndPosition: Integer = -1;
  const DstStartPosition: IXRTLIterator = nil): Cardinal; overload;
begin
  Result:= XRTLCopyIf(Src, Dst, TXRTLTrueIfFunctor.Create, SrcStartPosition, SrcEndPosition, DstStartPosition);
end;

function XRTLCopyIf(const Src: TXRTLValueArray; const Dst: TXRTLSequentialContainer;
  const IfFunctor: IXRTLIfFunctor; const SrcStartPosition: Integer = -1;
  const SrcEndPosition: Integer = -1; const DstStartPosition: IXRTLIterator = nil): Cardinal; overload;
var
  LSrcStartPosition, LSrcEndPosition: Integer;
  LDstStartPosition: IXRTLIterator;
begin
  Result:= 0;
  LSrcStartPosition:= SrcStartPosition;
  if LSrcStartPosition < 0 then
    LSrcStartPosition:= 0;
  LSrcEndPosition:= SrcEndPosition;
  if LSrcEndPosition < 0 then
    LSrcEndPosition:= Length(Src);
  LDstStartPosition:= DstStartPosition;
  if not Assigned(LDstStartPosition) then
    LDstStartPosition:= Dst.AtEnd;
  while LSrcStartPosition < LSrcEndPosition do
  begin
    if IfFunctor.IfValue(Src[LSrcStartPosition]) then
    begin
      Dst.Insert(Src[LSrcStartPosition], LDstStartPosition);
      Inc(Result);
    end;
    Inc(LSrcStartPosition);
  end;
end;

function XRTLCopy(const Src: TXRTLValueArray; const Dst: TXRTLSetContainer;
  const SrcStartPosition: Integer = -1; const SrcEndPosition: Integer = -1): Cardinal; overload;
begin
  Result:= XRTLCopyIf(Src, Dst, TXRTLTrueIfFunctor.Create, SrcStartPosition, SrcEndPosition);
end;

function XRTLCopyIf(const Src: TXRTLValueArray; const Dst: TXRTLSetContainer;
  const IfFunctor: IXRTLIfFunctor; const SrcStartPosition: Integer = -1;
  const SrcEndPosition: Integer = -1): Cardinal; overload;
var
  LSrcStartPosition, LSrcEndPosition: Integer;
begin
  Result:= 0;
  LSrcStartPosition:= SrcStartPosition;
  if LSrcStartPosition < 0 then
    LSrcStartPosition:= 0;
  LSrcEndPosition:= SrcEndPosition;
  if LSrcEndPosition < 0 then
    LSrcEndPosition:= Length(Src);
  while LSrcStartPosition < LSrcEndPosition do
  begin
    if IfFunctor.IfValue(Src[LSrcStartPosition]) then
    begin
      if Dst.Add(Src[LSrcStartPosition]) then
        Inc(Result);
    end;
    Inc(LSrcStartPosition);
  end;
end;

function XRTLRemoveIf(const Container: TXRTLSequentialContainer; const IfFunctor: IXRTLIfFunctor;
  const StartPosition: IXRTLIterator = nil; const EndPosition: IXRTLIterator = nil): Cardinal;
var
  LStartPosition, LEndPosition: IXRTLIterator;
begin
  Result:= 0;
  LStartPosition:= StartPosition;
  if not Assigned(LStartPosition) then
    LStartPosition:= Container.AtBegin;
  LEndPosition:= EndPosition;
  if not Assigned(LEndPosition) then
    LEndPosition:= Container.AtEnd;
  while LStartPosition.Compare(LEndPosition) <> XRTLEqualsValue do
  begin
    if IfFunctor.IfValue(Container.GetValue(LStartPosition)) then
    begin
      Container.Remove(LStartPosition);
      Inc(Result);
    end
    else
      LStartPosition.Next;
  end;
end;

function XRTLSplitIf(const Src, Dst: TXRTLSequentialContainer;
  const IfFunctor: IXRTLIfFunctor; const SrcStartPosition: IXRTLIterator = nil;
  const SrcEndPosition: IXRTLIterator = nil; const DstStartPosition: IXRTLIterator = nil): Cardinal;
var
  LSrcStartPosition, LSrcEndPosition, LDstStartPosition: IXRTLIterator;
begin
  Result:= 0;
  LSrcStartPosition:= SrcStartPosition;
  if not Assigned(LSrcStartPosition) then
    LSrcStartPosition:= Src.AtBegin;
  LSrcEndPosition:= SrcEndPosition;
  if not Assigned(LSrcEndPosition) then
    LSrcEndPosition:= Src.AtEnd;
  LDstStartPosition:= DstStartPosition;
  if not Assigned(LDstStartPosition) then
    LDstStartPosition:= Dst.AtEnd;
  while LSrcStartPosition.Compare(LSrcEndPosition) <> XRTLEqualsValue do
  begin
    if IfFunctor.IfValue(Src.GetValue(LSrcStartPosition)) then
    begin
      Dst.Insert(Src.GetValue(LSrcStartPosition), LDstStartPosition);
      Src.Remove(LSrcStartPosition);
      Inc(Result);
    end
    else
      LSrcStartPosition.Next;
  end;
end;

{ TXRTLTrueIfFunctor }

function TXRTLTrueIfFunctor.IfValue(const IValue: IXRTLValue): Boolean;
begin
  Result:= True;
end;

{ TXRTLFalseIfFunctor }

function TXRTLFalseIfFunctor.IfValue(const IValue: IXRTLValue): Boolean;
begin
  Result:= False;
end;

end.
