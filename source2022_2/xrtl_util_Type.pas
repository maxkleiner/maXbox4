unit xrtl_util_Type;

{$INCLUDE xrtl.inc}

interface

uses
  Windows,
  xrtl_util_Compat;

type
  TXRTLNRCInterfacedObject = class(TInterfacedObject)
    function   _AddRef: Integer; stdcall;
    function   _Release: Integer; stdcall;
  end;

  IXRTLImplementationObjectProvider = interface(IInterface)
  ['{8A418EC3-220E-42E7-843B-59216512444F}']
    function   GetImplementationObject: TObject;
  end;

  TXRTLImplementationObjectProvider = class(TInterfacedObject, IXRTLImplementationObjectProvider)
    function   GetImplementationObject: TObject;
  end;

function  XRTLIsAs(const AObject: TObject; const AClass: TClass; out AResult): Boolean;

implementation

uses
  SysUtils;

function XRTLIsAs(const AObject: TObject; const AClass: TClass; out AResult): Boolean;
begin
  TObject(AResult):= nil;
  Result:= AObject is AClass;
  if Result then
    TObject(AResult):= AObject as AClass;
end;

{ TXRTLNRCInterfacedObject }

function TXRTLNRCInterfacedObject._AddRef: Integer;
begin
  Result:= -1;
end;

function TXRTLNRCInterfacedObject._Release: Integer;
begin
  Result:= -1;
end;

{ TXRTLImplementationObjectProvider }

function TXRTLImplementationObjectProvider.GetImplementationObject: TObject;
begin
  Result:= Self;
end;

end.
