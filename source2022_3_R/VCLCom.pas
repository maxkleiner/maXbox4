{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit VCLCom;

{$H+,X+}

interface

uses ActiveX, ComObj, Classes;

type

{ Component object factory }

  TComponentFactory = class(TAutoObjectFactory, IClassFactory)
  protected
    function CreateInstance(const UnkOuter: IUnknown; const IID: TGUID;
      out Obj): HResult; stdcall;
  public
    constructor Create(ComServer: TComServerObject;
      ComponentClass: TComponentClass; const ClassID: TGUID;
      Instancing: TClassInstancing; ThreadingModel: TThreadingModel = tmSingle);
    function CreateComObject(const Controller: IUnknown): TComObject; override;
    procedure UpdateRegistry(Register: Boolean); override;
  end;
  {$EXTERNALSYM TComponentFactory}

implementation

uses
  Windows, SysUtils;

type

{ TApartmentThread }

  TApartmentThread = class(TThread)
  private
    FFactory: IClassFactory2;
    FUnkOuter: IUnknown;
    FIID: TGuid;
    FSemaphore: THandle;
    FStream: Pointer;
    FCreateResult: HResult;
  protected
    procedure Execute; override;
  public
    constructor Create(Factory: IClassFactory2; UnkOuter: IUnknown; IID: TGuid);
    destructor Destroy; override;
    property Semaphore: THandle read FSemaphore;
    property CreateResult: HResult read FCreateResult;
    property ObjStream: Pointer read FStream;
  end;

{ VCL OLE Automation object }

  TVCLAutoObject = class(TAutoObject, IVCLComObject)
  private
    FComponent: TComponent;
    FOwnsComponent: Boolean;
  protected
    procedure FreeOnRelease;
    function Invoke(DispID: Integer; const IID: TGUID;
      LocaleID: Integer; Flags: Word; var Params;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; override;
  public
    constructor Create(Factory: TComObjectFactory; Component: TComponent);
    destructor Destroy; override;
    procedure Initialize; override;
    function ObjQueryInterface(const IID: TGUID; out Obj): HResult; override;
  end;

{ TApartmentThread }

constructor TApartmentThread.Create(Factory: IClassFactory2;
  UnkOuter: IUnknown; IID: TGuid);
begin
  FFactory := Factory;
  FUnkOuter := UnkOuter;
  FIID := IID;
  FSemaphore := CreateSemaphore(nil, 0, 1, nil);
  FreeOnTerminate := True;
  inherited Create(False);
end;

destructor TApartmentThread.Destroy;
begin
  CloseHandle(FSemaphore);
  inherited Destroy;
end;

procedure TApartmentThread.Execute;
var
  msg: TMsg;
  Unk: IUnknown;
begin
  try
    CoInitialize(nil);
    try
      FCreateResult := FFactory.CreateInstanceLic(FUnkOuter, nil, FIID, '', Unk);
      FUnkOuter := nil;
      FFactory := nil;
      if FCreateResult = S_OK then
        CoMarshalInterThreadInterfaceInStream(FIID, Unk, IStream(FStream));
      ReleaseSemaphore(FSemaphore, 1, nil);
      if FCreateResult = S_OK then
        while GetMessage(msg, 0, 0, 0) do
        begin
          DispatchMessage(msg);
          Unk._AddRef;
          if Unk._Release = 1 then break;
        end;
    finally
      Unk := nil;
      CoUninitialize;
    end;
  except
    { No exceptions should go unhandled }
  end;
end;

{ TVCLAutoObject }

constructor TVCLAutoObject.Create(Factory: TComObjectFactory;
  Component: TComponent);
begin
  FComponent := Component;
  CreateFromFactory(Factory, nil);
end;

destructor TVCLAutoObject.Destroy;
begin
  if FComponent <> nil then
  begin
    FComponent.VCLComObject := nil;
    if FOwnsComponent then FComponent.Free;
  end;
  inherited Destroy;
end;

procedure TVCLAutoObject.FreeOnRelease;
begin
  FOwnsComponent := True;
end;

procedure TVCLAutoObject.Initialize;
begin
  inherited Initialize;
  if FComponent = nil then
  begin
    FComponent := TComponentClass(Factory.ComClass).Create(nil);
    FOwnsComponent := True;
  end;
  FComponent.VCLComObject := Pointer(IVCLComObject(Self));
end;

function TVCLAutoObject.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
begin
  Result := DispInvoke(Pointer(Integer(FComponent) +
    TComponentFactory(Factory).DispIntfEntry^.IOffset),
    TComponentFactory(Factory).DispTypeInfo, DispID, Flags,
    TDispParams(Params), VarResult, ExcepInfo, ArgErr);
end;

function TVCLAutoObject.ObjQueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Result := inherited ObjQueryInterface(IID, Obj);
  if (Result <> 0) and (FComponent <> nil) then
    if FComponent.GetInterface(IID, Obj) then Result := 0;
end;

{ TComponentFactory }

constructor TComponentFactory.Create(ComServer: TComServerObject;
  ComponentClass: TComponentClass; const ClassID: TGUID;
  Instancing: TClassInstancing; ThreadingModel: TThreadingModel);
begin
  inherited Create(ComServer, TAutoClass(ComponentClass),
    ClassID, Instancing, ThreadingModel);
end;

function TComponentFactory.CreateInstance(const UnkOuter: IUnknown;
  const IID: TGUID; out Obj): HResult; stdcall;
begin
  if not IsLibrary and (ThreadingModel = tmApartment) then
  begin
    LockServer(True);
    try
      with TApartmentThread.Create(Self, UnkOuter, IID) do
      begin
        if WaitForSingleObject(Semaphore, INFINITE) = WAIT_OBJECT_0 then
        begin
          Result := CreateResult;
          if Result <> S_OK then Exit;
          Result := CoGetInterfaceAndReleaseStream(IStream(ObjStream), IID, Obj);
        end else
          Result := E_FAIL
      end;
    finally
      LockServer(False);
    end;
  end else
    Result := inherited CreateInstance(UnkOuter, IID, Obj);
end;

type
  TComponentProtectedAccess = class(TComponent);
  TComponentProtectedAccessClass = class of TComponentProtectedAccess;

procedure TComponentFactory.UpdateRegistry(Register: Boolean);
begin
  if Register then inherited UpdateRegistry(Register);
  TComponentProtectedAccessClass(ComClass).UpdateRegistry(Register, GUIDToString(ClassID), ProgID);
  if not Register then inherited UpdateRegistry(Register);
end;

function TComponentFactory.CreateComObject(const Controller: IUnknown): TComObject;
begin
  Result := TVCLAutoObject.CreateFromFactory(Self, Controller);
end;

{ Global routines }

procedure CreateVCLComObject(Component: TComponent);
begin
  TVCLAutoObject.Create(ComClassManager.GetFactoryFromClass(
    Component.ClassType), Component);
end;

initialization
  CreateVCLComObjectProc := CreateVCLComObject;
finalization
  CreateVCLComObjectProc := nil;
end.
