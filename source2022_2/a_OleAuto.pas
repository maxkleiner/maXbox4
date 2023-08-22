{*******************************************************}
{                                                       }
{       CodeGear Delphi Visual Component Library        }
{                                                       }
{           Copyright (c) 1995-2007 CodeGear            }
{                                                       }
{*******************************************************}

unit OleAuto deprecated;

{$DENYPACKAGEUNIT}

{ OleAuto cannot be used in a package DLL.  To implement
  an OLE automation server in a package, use the new
  OLE automation support in comobj and comserv.
}

{$R-,T-,H+,X+}

// For CBuilder v1.0 backward compatiblity, OLEAUTO.HPP must include comobj.hpp
(*$HPPEMIT '#include <comobj.hpp>'*)

interface

uses Windows, Ole2, OleCtl, SysUtils;

const

{ Maximum number of dispatch arguments }

  MaxDispArgs = 32;

type

{ Forward declarations }

  TAutoObject = class;

{ Dispatch interface for TAutoObject }

  {$EXTERNALSYM TAutoDispatch }
  { NOTE: TAutoDispatch is not really an External Symbol. However, it derives from IDispatch
    which is. However, in the C++ world, a DELPHICLASS cannot derive from a non-Delphi
    Class. }
  TAutoDispatch = class(IDispatch)
  private
    FAutoObject: TAutoObject;
  public
    constructor Create(AutoObject: TAutoObject);
    function QueryInterface(const iid: TIID; var obj): HResult; override;
    function AddRef: Longint; override;
    function Release: Longint; override;
    function GetTypeInfoCount(var ctinfo: Integer): HResult; override;
    function GetTypeInfo(itinfo: Integer; lcid: TLCID;
      var tinfo: ITypeInfo): HResult; override;
    function GetIDsOfNames(const iid: TIID; rgszNames: POleStrList;
      cNames: Integer; lcid: TLCID; rgdispid: PDispIDList): HResult; override;
    function Invoke(dispIDMember: TDispID; const iid: TIID; lcid: TLCID;
      flags: Word; var dispParams: TDispParams; varResult: PVariant;
      excepInfo: PExcepInfo; argErr: PInteger): HResult; override;
    function GetAutoObject: TAutoObject; virtual; stdcall;
    property AutoObject: TAutoObject read FAutoObject;
  end;

{ TAutoObject - Automation object base class. An automation class is
  implemented by deriving a new class from TAutoObject, and declaring methods
  and properties in an "automated" section in the new class. To expose an
  automation class to external OLE Automation Controllers, the unit that
  implements the automation class must call Automation.RegisterClass in its
  initialization section, passing in a TAutoClassInfo structure. Once a
  class has been registered in this way, the global Automation object
  automatically manages all aspects of interfacing with the OLE Automation
  APIs.

  When an external OLE Automation Controller requests an instance of an
  automation class, the Create constructor is called to create the object,
  and when all external references to the object disappear, the Destroy
  destructor is called to destroy the object. As is the case with all OLE
  objects, automation objects are reference counted. }

  {$EXTERNALSYM TAutoObject}

  TAutoObject = class(TObject)
  private
    FRefCount: Integer;
    FAutoDispatch: TAutoDispatch;
    function GetIDsOfNames(Names: POleStrList; Count: Integer;
      DispIDs: PDispIDList): HResult;
    function GetOleObject: Variant;
    function Invoke(DispID: TDispID; Flags: Integer; var Params: TDispParams;
      VarResult: PVariant; ExcepInfo: PExcepInfo; ArgErr: PInteger): HResult;
    procedure InvokeMethod(AutoEntry, Args, Result: Pointer);
    function QueryInterface(const iid: TIID; var obj): HResult;
  protected
    function CreateAutoDispatch: TAutoDispatch; virtual;
    procedure GetExceptionInfo(ExceptObject: TObject;
      var ExcepInfo: TExcepInfo); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function AddRef: Integer;
    function Release: Integer;
    property AutoDispatch: TAutoDispatch read FAutoDispatch;
    property OleObject: Variant read GetOleObject;
    property RefCount: Integer read FRefCount;
  end;

{ Automation object class reference }

  TAutoClass = class of TAutoObject;

{ Instancing mode for local server automation classes }

  TAutoClassInstancing = (acInternal, acSingleInstance, acMultiInstance);

{ Automation class registration info }

  TAutoClassInfo = record
    AutoClass: TAutoClass;
    ProgID: string;
    ClassID: string;
    Description: string;
    Instancing: TAutoClassInstancing;
  end;

{ Class registry entry }

  TRegistryClass = class
  private
    FNext: TRegistryClass;
    FAutoClass: TAutoClass;
    FProgID: string;
    FClassID: TCLSID;
    FDescription: string;
    FInstancing: TAutoClassInstancing;
    FRegister: Longint;
  public
    constructor Create(const AutoClassInfo: TAutoClassInfo);
    destructor Destroy; override;
    procedure UpdateRegistry(Register: Boolean);
  end;

{ Application start mode }

  TStartMode = (smStandalone, smAutomation, smRegServer, smUnregServer);

{ Automation manager event types }

  TLastReleaseEvent = procedure(var Shutdown: Boolean) of object;

{ Automation manager object }

  TAutomation = class
  private
    FRegistryList: TRegistryClass;
    FAutoObjectCount: Integer;
    FClassFactoryCount: Integer;
    FIsInprocServer: Boolean;
    FStartMode: TStartMode;
    FOnLastRelease: TLastReleaseEvent;
    procedure CountAutoObject(Created: Boolean);
    procedure Initialize;
    procedure LastReleased;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterClass(const AutoClassInfo: TAutoClassInfo);
    procedure UpdateRegistry(Register: Boolean);
    property AutoObjectCount: Integer read FAutoObjectCount;
    property IsInprocServer: Boolean read FIsInprocServer write FIsInprocServer;
    property StartMode: TStartMode read FStartMode;
    property OnLastRelease: TLastReleaseEvent read FOnLastRelease write FOnLastRelease;
  end;

{ OLE exception classes }

  EOleError = class(Exception);

  EOleSysError = class(EOleError)
  private
    FErrorCode: Integer;
  public
    constructor Create(ErrorCode: Integer);
    property ErrorCode: Integer read FErrorCode;
  end;

  EOleException = class(EOleError)
  private
    FErrorCode: Integer;
    FSource: string;
    FHelpFile: string;
  public
    constructor Create(const ExcepInfo: TExcepInfo);
    property ErrorCode: Integer read FErrorCode;
    property HelpFile: string read FHelpFile;
    property Source: string read FSource;
  end;

var
  Automation: TAutomation;

{ CreateOleObject creates an OLE automation object of the given class. }

function CreateOleObject(const ClassName: string): Variant;

{ GetActiveOleObject returns the active object for the given class. }

function GetActiveOleObject(const ClassName: string): Variant;

{ The DllXXXX routines implement the required entry points of an in-process
  automation server DLL. These routines must be exported by the DLL using
  an "exports" clause in the library's main module. }

function DllGetClassObject(const CLSID: TCLSID; const IID: TIID;
  var Obj): HResult; stdcall;
function DllCanUnloadNow: HResult; stdcall;
function DllRegisterServer: HResult; stdcall;
function DllUnregisterServer: HResult; stdcall;

{ VarFromInterface returns a variant that contains the a reference to the
  IDispatch interface of the given IUnknown interface. If the Unknown
  parameter is NIL, the resulting variant is set to Unassigned. }

function VarFromInterface(Unknown: IUnknown): Variant;

{ VarToInterface returns the IDispatch interface reference stored in the
  given variant. An exception is raised if the variant does not contain
  an IDispatch interface. VarToInterface does not affect the reference
  count of the returned IDispatch. The caller of VarToInterface must
  manually call AddRef and Release on the returned interface. }

function VarToInterface(const V: Variant): IDispatch;

{ VarToAutoObject returns the TAutoObject instance corresponding to the
  IDispatch interface reference stored in the given variant. An exception
  is raised if the variant does not contain an IDispatch interface, or if
  the IDispatch interface is not that of a TAutoObject instance. }

{$EXTERNALSYM VarToAutoObject}
function VarToAutoObject(const V: Variant): TAutoObject;

procedure DispInvoke(Dispatch: IDispatch; CallDesc: PCallDesc;
  DispIDs: PDispIDList; Params: Pointer; Result: PVariant);
procedure DispInvokeError(Status: HResult; const ExcepInfo: TExcepInfo);

procedure OleError(ErrorCode: HResult);
procedure OleCheck(Result: HResult);

function StringToClassID(const S: string): TCLSID;
function ClassIDToString(const ClassID: TCLSID): string;

function ProgIDToClassID(const ProgID: string): TCLSID;
function ClassIDToProgID(const ClassID: TCLSID): string;

implementation

uses OleConst, ComObj;

const

{ Special variant type codes }

  varStrArg = $0048;

{ Parameter type masks }

  atVarMask  = $3F;
  atTypeMask = $7F;
  atByRef    = $80;

{ Automation entry flags }

  afMethod  = $00000001;
  afPropGet = $00000002;
  afPropSet = $00000004;
  afVirtual = $00000008;

type

{ Automation entry parameter list }

  PParamList = ^TParamList;
  TParamList = record
    ResType: Byte;
    ParamCount: Byte;
    ParamTypes: array[0..255] of Byte;
  end;

{ Automation table entry }

  PAutoEntry = ^TAutoEntry;
  TAutoEntry = record
    DispID: Integer;
    Name: PShortString;
    Flags: Integer;
    Params: PParamList;
    Address: Pointer;
  end;

{ Automation table layout }

  PAutoTable = ^TAutoTable;
  TAutoTable = record
    EntryCount: Integer;
    Entries: array[0..4095] of TAutoEntry;
  end;

{ Class factory }

  TClassFactory = class(IClassFactory)
  private
    FRefCount: Integer;
    FAutoClass: TAutoClass;
  public
    constructor Create(AutoClass: TAutoClass);
    destructor Destroy; override;
    function QueryInterface(const iid: TIID; var obj): HResult; override;
    function AddRef: Longint; override;
    function Release: Longint; override;
    function CreateInstance(unkOuter: IUnknown; const iid: TIID;
      var obj): HResult; override;
    function LockServer(fLock: BOOL): HResult; override;
  end;

{ IAutoDispatch interface ID }

const
  IID_IAutoDispatch: TGUID = ( {F5B2B8E0-1627-11CF-BD2F-0020AF0E5B81}
    D1:$F5B2B8E0;D2:$1627;D3:$11CF;D4:($BD,$2F,$00,$20,$AF,$0E,$5B,$81));

{ Raise EOleSysError exception from an error code }

procedure OleError(ErrorCode: HResult);
begin
  raise EOleSysError.Create(ErrorCode);
end;

{ Raise EOleSysError exception if result code indicates an error }

procedure OleCheck(Result: HResult);
begin
  if Failed(Result) then OleError(Result);
end;

{ Convert a string to a class ID }

function StringToClassID(const S: string): TCLSID;
var
  Buffer: array[0..127] of WideChar;
begin
  OleCheck(CLSIDFromString(StringToWideChar(S, Buffer,
    SizeOf(Buffer) div 2), Result));
end;

{ Convert a class ID to a string }

function ClassIDToString(const ClassID: TCLSID): string;
var
  P: PWideChar;
begin
  OleCheck(StringFromCLSID(ClassID, P));
  Result := WideCharToString(P);
  CoTaskMemFree(P);
end;

{ Convert a programmatic ID to a class ID }

function ProgIDToClassID(const ProgID: string): TCLSID;
var
  Buffer: array[0..127] of WideChar;
begin
  OleCheck(CLSIDFromProgID(StringToWideChar(ProgID, Buffer,
    SizeOf(Buffer) div 2), Result));
end;

{ Convert a class ID to a programmatic ID }

function ClassIDToProgID(const ClassID: TCLSID): string;
var
  P: PWideChar;
begin
  OleCheck(ProgIDFromCLSID(ClassID, P));
  Result := WideCharToString(P);
  CoTaskMemFree(P);
end;

{ Create registry key }

procedure CreateRegKey(const Key, Value: string);
begin
  RegSetValue(HKEY_CLASSES_ROOT, PChar(Key), REG_SZ, PChar(Value),
    Length(Value));
end;

{ Delete registry key }

procedure DeleteRegKey(const Key: string);
begin
  RegDeleteKey(HKEY_CLASSES_ROOT, PChar(Key));
end;

{ Get server key name }

function GetServerKey: string;
begin
  if Automation.IsInprocServer then
    Result := 'InprocServer32' else
    Result := 'LocalServer32';
end;

{ Find command-line switch }

function FindCmdLineSwitch(const Switch: string): Boolean;
var
  I: Integer;
  S: string;
begin
  for I := 1 to ParamCount do
  begin
    S := ParamStr(I);
    if (S[1] in ['-', '/']) and
      (CompareText(Copy(S, 2, Maxint), Switch) = 0) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

{ Convert wide character string to ShortString }

procedure WideCharToShortString(P: PWideChar; var S: ShortString);
var
  I: Integer;
  W: WideChar;
begin
  I := 0;
  repeat
    W := P[I];
    if W = #0 then Break;
    if W >= #256 then W := #0;
    Inc(I);
    S[I] := Char(W);
  until I = 255;
  S[0] := Char(I);
end;

{ Compare two symbols }

function SameSymbol(const Ident1, Ident2: ShortString): Boolean;
asm
        PUSH    EBX
        XOR     EBX,EBX
        XOR     ECX,ECX
        MOV     CL,[EAX]
        CMP     CL,[EDX]
        JNE     @@2
@@1:    MOV     BH,[EAX+ECX]
        XOR     BH,[EDX+ECX]
        TEST    BH,0DFH
        JNE     @@2
        DEC     ECX
        JNE     @@1
        INC     EBX
@@2:    XOR     EAX,EAX
        MOV     AL,BL
        POP     EBX
end;

{ Return automation table of the given class }

function GetAutoTable(ClassRef: TClass): PAutoTable;
asm
        MOV     EAX,[EAX].vmtAutoTable
end;

{ Return dispatch ID of the given name in the given class }

function GetDispIDOfName(ClassRef: TClass; const Name: ShortString): Integer;
var
  AutoTable: PAutoTable;
  NameStart: Word;
  I: Integer;
  P: PAutoEntry;
begin
  NameStart := Word((@Name)^);
  repeat
    AutoTable := GetAutoTable(ClassRef);
    if AutoTable <> nil then
    begin
      I := AutoTable^.EntryCount;
      P := @AutoTable^.Entries;
      repeat
        if ((NameStart xor Word(Pointer(P^.Name)^)) and $DFFF = 0) and
          SameSymbol(Name, P^.Name^) then
        begin
          Result := P^.DispID;
          Exit;
        end;
        Inc(Integer(P), SizeOf(TAutoEntry));
        Dec(I);
      until I = 0;
    end;
    ClassRef := ClassRef.ClassParent;
  until ClassRef = nil;
  Result := -1;
end;

{ Return automation table entry for the given dispatch ID and dispatch
  flags in the given class }

function GetAutoEntry(ClassRef: TClass; DispID, Flags: Integer): PAutoEntry;
var
  AutoTable: PAutoTable;
  I: Integer;
begin
  repeat
    AutoTable := GetAutoTable(ClassRef);
    if AutoTable <> nil then
    begin
      I := AutoTable^.EntryCount;
      Result := @AutoTable^.Entries;
      repeat
        if (Result^.DispID = DispID) and
          (Result^.Flags and Flags <> 0) then Exit;
        Inc(Integer(Result), SizeOf(TAutoEntry));
        Dec(I);
      until I = 0;
    end;
    ClassRef := ClassRef.ClassParent;
  until ClassRef = nil;
  Result := nil;
end;

{ Create an OLE object variant given an IDispatch }

function VarFromInterface(Unknown: IUnknown): Variant;
var
  Dispatch: IDispatch;
begin
  VarClear(Result);
  if Unknown <> nil then
  begin
    OleCheck(Unknown.QueryInterface(IID_IDispatch, Dispatch));
    TVarData(Result).VType := varDispatch;
    TVarData(Result).VDispatch := Dispatch;
  end;
end;

{ Return OLE object stored in a variant }

function VarToInterface(const V: Variant): IDispatch;
begin
  Result := nil;
  if TVarData(V).VType = varDispatch then
    Result := TVarData(V).VDispatch
  else if TVarData(V).VType = (varDispatch or varByRef) then
    Result := Pointer(TVarData(V).VPointer^);
  if Result = nil then raise EOleError.CreateRes(@SVarNotObject);
end;

{ Return TAutoObject referenced by the given variant }

function VarToAutoObject(const V: Variant): TAutoObject;
var
  Dispatch: IDispatch;
  AutoDispatch: TAutoDispatch;
begin
  Dispatch := VarToInterface(V);
  if Dispatch.QueryInterface(IID_IAutoDispatch, AutoDispatch) <> S_OK then
    raise EOleError.CreateRes(@SVarNotAutoObject);
  Result := AutoDispatch.GetAutoObject;
  AutoDispatch.Release;
end;

{ Create an OLE object variant given a class name }

function CreateOleObject(const ClassName: string): Variant;
var
  Unknown: IUnknown;
  ClassID: TCLSID;
  WideCharBuf: array[0..127] of WideChar;
begin
  StringToWideChar(ClassName, WideCharBuf, SizeOf(WideCharBuf) div 2);
  OleCheck(CLSIDFromProgID(WideCharBuf, ClassID));
  OleCheck(CoCreateInstance(ClassID, nil, CLSCTX_INPROC_SERVER or
    CLSCTX_LOCAL_SERVER, IID_IUnknown, Unknown));
  try
    Result := VarFromInterface(Unknown);
  finally;
    Unknown.Release;
  end;
end;

{ Get active OLE object for a given class name }

function GetActiveOleObject(const ClassName: string): Variant;
var
  Unknown: IUnknown;
  ClassID: TCLSID;
  WideCharBuf: array[0..127] of WideChar;
begin
  StringToWideChar(ClassName, WideCharBuf, SizeOf(WideCharBuf) div 2);
  OleCheck(CLSIDFromProgID(WideCharBuf, ClassID));
  OleCheck(GetActiveObject(ClassID, nil, Unknown));
  try
    Result := VarFromInterface(Unknown);
  finally;
    Unknown.Release;
  end;
end;

{ Call Invoke method on the given IDispatch interface using the given
  call descriptor, dispatch IDs, parameters, and result }

procedure DispInvoke(Dispatch: IDispatch; CallDesc: PCallDesc;
  DispIDs: PDispIDList; Params: Pointer; Result: PVariant);
type
  PVarArg = ^TVarArg;
  TVarArg = array[0..3] of DWORD;
  TStringDesc = record
    BStr: PWideChar;
    PStr: PString;
  end;
var
  I, J, K, ArgType, ArgCount, StrCount, DispID, InvKind, Status: Integer;
  VarFlag: Byte;
  ParamPtr: ^Integer;
  ArgPtr, VarPtr: PVarArg;
  DispParams: TDispParams;
  ExcepInfo: TExcepInfo;
  Strings: array[0..MaxDispArgs - 1] of TStringDesc;
  Args: array[0..MaxDispArgs - 1] of TVarArg;
begin
  StrCount := 0;
  try
    ArgCount := CallDesc^.ArgCount;
    if ArgCount <> 0 then
    begin
      ParamPtr := Params;
      ArgPtr := @Args[ArgCount];
      I := 0;
      repeat
        Dec(Integer(ArgPtr), SizeOf(TVarData));
        ArgType := CallDesc^.ArgTypes[I] and atTypeMask;
        VarFlag := CallDesc^.ArgTypes[I] and atByRef;
        if ArgType = varError then
        begin
          ArgPtr^[0] := varError;
          ArgPtr^[2] := DWORD(DISP_E_PARAMNOTFOUND);
        end else
        begin
          if ArgType = varStrArg then
          begin
            with Strings[StrCount] do
              if VarFlag <> 0 then
              begin
                BStr := StringToOleStr(PString(ParamPtr^)^);
                PStr := PString(ParamPtr^);
                ArgPtr^[0] := varOleStr or varByRef;
                ArgPtr^[2] := Integer(@BStr);
              end else
              begin
                BStr := StringToOleStr(PString(ParamPtr)^);
                PStr := nil;
                ArgPtr^[0] := varOleStr;
                ArgPtr^[2] := Integer(BStr);
              end;
            Inc(StrCount);
          end else
          if VarFlag <> 0 then
          begin
            if (ArgType = varVariant) and
              (PVarData(ParamPtr^)^.VType = varString) then
              VarCast(PVariant(ParamPtr^)^, PVariant(ParamPtr^)^, varOleStr);
            ArgPtr^[0] := ArgType or varByRef;
            ArgPtr^[2] := ParamPtr^;
          end else
          if ArgType = varVariant then
          begin
            if PVarData(ParamPtr^)^.VType = varString then
            begin
              with Strings[StrCount] do
              begin
                BStr := StringToOleStr(string(PVarData(ParamPtr^)^.VString));
                PStr := nil;
                ArgPtr^[0] := varOleStr;
                ArgPtr^[2] := Integer(BStr);
              end;
              Inc(StrCount);
            end else
            begin
              VarPtr := PVarArg(ParamPtr^);
              ArgPtr^[0] := VarPtr^[0];
              ArgPtr^[1] := VarPtr^[1];
              ArgPtr^[2] := VarPtr^[2];
              ArgPtr^[3] := VarPtr^[3];
            end;
          end else
          begin
            ArgPtr^[0] := ArgType;
            ArgPtr^[2] := ParamPtr^;
            if (ArgType >= varDouble) and (ArgType <= varDate) then
            begin
              Inc(Integer(ParamPtr), 4);
              ArgPtr^[3] := ParamPtr^;
            end;
          end;
          Inc(Integer(ParamPtr), 4);
        end;
        Inc(I);
      until I = ArgCount;
    end;
    DispParams.rgvarg := @Args;
    DispParams.rgdispidNamedArgs := @DispIDs[1];
    DispParams.cArgs := ArgCount;
    DispParams.cNamedArgs := CallDesc^.NamedArgCount;
    DispID := DispIDs[0];
    InvKind := CallDesc^.CallType;
    if InvKind = DISPATCH_PROPERTYPUT then
    begin
      if Args[0][0] and varTypeMask = varDispatch then
        InvKind := DISPATCH_PROPERTYPUTREF;
      DispIDs[0] := DISPID_PROPERTYPUT;
      Dec(Integer(DispParams.rgdispidNamedArgs), SizeOf(Integer));
      Inc(DispParams.cNamedArgs);
    end else
      if (InvKind = DISPATCH_METHOD) and (ArgCount = 0) and (Result <> nil) then
        InvKind := DISPATCH_METHOD or DISPATCH_PROPERTYGET;
    Status := Dispatch.Invoke(DispID, GUID_NULL, LOCALE_SYSTEM_DEFAULT,
      InvKind, DispParams, Result, @ExcepInfo, nil);
    if Status <> 0 then DispInvokeError(Status, ExcepInfo);
    J := StrCount;
    while J <> 0 do
    begin
      Dec(J);
      with Strings[J] do
        if PStr <> nil then OleStrToStrVar(BStr, PStr^);
    end;
  finally
    K := StrCount;
    while K <> 0 do
    begin
      Dec(K);
      SysFreeString(Strings[K].BStr);
    end;
  end;
end;

{ Raise exception given an OLE return code and TExcepInfo structure }

procedure DispInvokeError(Status: HResult; const ExcepInfo: TExcepInfo);
var
  E: EOleException;
begin
  if Status <> DISP_E_EXCEPTION then OleError(Status);
  E := EOleException.Create(ExcepInfo);
  with ExcepInfo do
  begin
    if bstrSource <> nil then SysFreeString(bstrSource);
    if bstrDescription <> nil then SysFreeString(bstrDescription);
    if bstrHelpFile <> nil then SysFreeString(bstrHelpFile);
  end;
  raise E;
end;

{ Call GetIDsOfNames method on the given IDispatch interface }

procedure GetIDsOfNames(Dispatch: IDispatch; Names: PChar;
  NameCount: Integer; DispIDs: PDispIDList);
var
  I, N: Integer;
  Ch: WideChar;
  P: PWideChar;
  NameRefs: array[0..MaxDispArgs - 1] of PWideChar;
  WideNames: array[0..1023] of WideChar;
begin
  I := 0;
  N := 0;
  repeat
    P := @WideNames[I];
    if N = 0 then NameRefs[0] := P else NameRefs[NameCount - N] := P;
    repeat
      Ch := WideChar(Names[I]);
      WideNames[I] := Ch;
      Inc(I);
    until Char(Ch) = #0;
    Inc(N);
  until N = NameCount;
  if Dispatch.GetIDsOfNames(GUID_NULL, @NameRefs, NameCount,
    LOCALE_SYSTEM_DEFAULT, DispIDs) <> 0 then
    raise EOleError.CreateResFmt(@SNoMethod, [Names]);
end;

{ Central call dispatcher }

procedure VarDispInvoke(Result: PVariant; const Instance: Variant;
  CallDesc: PCallDesc; Params: Pointer); cdecl;
var
  Dispatch: IDispatch;
  DispIDs: array[0..MaxDispArgs - 1] of Integer;
begin
  Dispatch := VarToInterface(Instance);
  GetIDsOfNames(Dispatch, @CallDesc^.ArgTypes[CallDesc^.ArgCount],
    CallDesc^.NamedArgCount + 1, @DispIDs);
  if Result <> nil then VarClear(Result^);
  DispInvoke(Dispatch, CallDesc, @DispIDs, @Params, Result);
end;

function DllGetClassObject(const CLSID: TCLSID; const IID: TIID;
  var Obj): HResult;
var
  RegistryClass: TRegistryClass;
  ClassFactory: TClassFactory;
begin
  RegistryClass := Automation.FRegistryList;
  ClassFactory := nil;
  while RegistryClass <> nil do
  begin
    if IsEqualCLSID(RegistryClass.FClassID, CLSID) then
    begin
      try
        ClassFactory := TClassFactory.Create(RegistryClass.FAutoClass);
      except
        Result := E_UNEXPECTED;
        Exit;
      end;
      Result := ClassFactory.QueryInterface(IID, Obj);
      ClassFactory.Release;
      Exit;
    end;
    RegistryClass := RegistryClass.FNext;
  end;
  Pointer(Obj) := nil;
  Result := CLASS_E_CLASSNOTAVAILABLE;
end;

function DllCanUnloadNow: HResult;
begin
  Result := S_FALSE;
  if (Automation.FAutoObjectCount = 0) and
    (Automation.FClassFactoryCount = 0) then Result := S_OK;
end;

function DllRegisterServer: HResult;
begin
  Automation.UpdateRegistry(True);
  Result := S_OK;
end;

function DllUnregisterServer: HResult;
begin
  Automation.UpdateRegistry(False);
  Result := S_OK;
end;

{ EOleSysError }

constructor EOleSysError.Create(ErrorCode: Integer);
var
  Message: string;
begin
  Message := SysErrorMessage(ErrorCode);
  if Message = '' then FmtStr(Message, SOleError, [ErrorCode]);
  inherited Create(Message);
  FErrorCode := ErrorCode;
end;

{ EOleException }

constructor EOleException.Create(const ExcepInfo: TExcepInfo);
var
  Message: string;
  Len: Integer;
begin
  with ExcepInfo do
  begin
    if bstrDescription <> nil then
    begin
      WideCharToStrVar(bstrDescription, Message);
      Len := Length(Message);
      while (Len > 0) and (Message[Len] in [#0..#32, '.']) do Dec(Len);
      SetLength(Message, Len);
    end;
    inherited CreateHelp(Message, dwHelpContext);
    if scode <> 0 then FErrorCode := scode else FErrorCode := wCode;
    if bstrSource <> nil then WideCharToStrVar(bstrSource, FSource);
    if bstrHelpFile <> nil then WideCharToStrVar(bstrHelpFile, FHelpFile);
  end;
end;

{ TAutoDispatch }

constructor TAutoDispatch.Create(AutoObject: TAutoObject);
begin
  FAutoObject := AutoObject;
end;

function TAutoDispatch.QueryInterface(const iid: TIID; var obj): HResult;
begin
  Result := FAutoObject.QueryInterface(iid, obj);
end;

function TAutoDispatch.AddRef: Longint;
begin
  Result := FAutoObject.AddRef;
end;

function TAutoDispatch.Release: Longint;
begin
  Result := FAutoObject.Release;
end;

function TAutoDispatch.GetTypeInfoCount(var ctinfo: Integer): HResult;
begin
  ctinfo := 0;
  Result := S_OK;
end;

function TAutoDispatch.GetTypeInfo(itinfo: Integer; lcid: TLCID;
  var tinfo: ITypeInfo): HResult;
begin
  tinfo := nil;
  Result := E_NOTIMPL;
end;

function TAutoDispatch.GetIDsOfNames(const iid: TIID; rgszNames: POleStrList;
  cNames: Integer; lcid: TLCID; rgdispid: PDispIDList): HResult;
begin
  Result := FAutoObject.GetIDsOfNames(rgszNames, cNames, rgdispid);
end;

function TAutoDispatch.Invoke(dispIDMember: TDispID; const iid: TIID;
  lcid: TLCID; flags: Word; var dispParams: TDispParams; varResult: PVariant;
  excepInfo: PExcepInfo; argErr: PInteger): HResult;
begin
  Result := FAutoObject.Invoke(dispIDMember, flags, dispParams,
    varResult, excepInfo, argErr);
end;

function TAutoDispatch.GetAutoObject: TAutoObject;
begin
  Result := FAutoObject;
end;

{ TAutoObject }

constructor TAutoObject.Create;
begin
  Automation.CountAutoObject(True);
  FRefCount := 1;
  FAutoDispatch := CreateAutoDispatch;
end;

destructor TAutoObject.Destroy;
begin
  FAutoDispatch.Free;
  Automation.CountAutoObject(False);
end;

function TAutoObject.AddRef: Integer;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TAutoObject.CreateAutoDispatch: TAutoDispatch;
begin
  Result := TAutoDispatch.Create(Self);
end;

procedure TAutoObject.GetExceptionInfo(ExceptObject: TObject;
  var ExcepInfo: TExcepInfo);
begin
  with ExcepInfo do
  begin
    bstrSource := StringToOleStr(ClassName);
    if ExceptObject is Exception then
      bstrDescription := StringToOleStr(Exception(ExceptObject).Message);
    scode := E_FAIL;
  end;
end;

function TAutoObject.GetIDsOfNames(Names: POleStrList;
  Count: Integer; DispIDs: PDispIDList): HResult;
var
  I, DispID: Integer;
  Name: ShortString;
begin
  WideCharToShortString(Names^[0], Name);
  DispID := GetDispIDOfName(ClassType, Name);
  DispIDs^[0] := DispID;
  if Count > 1 then
    for I := 1 to Count - 1 do DispIDs^[I] := -1;
  if (DispID = -1) or (Count > 1) then
    Result := DISP_E_UNKNOWNNAME else
    Result := S_OK;
end;

function TAutoObject.GetOleObject: Variant;
begin
  VarClear(Result);
  TVarData(Result).VType := varDispatch;
  TVarData(Result).VDispatch := FAutoDispatch;
  AddRef;
end;

function TAutoObject.Invoke(DispID: TDispID; Flags: Integer;
  var Params: TDispParams; VarResult: PVariant; ExcepInfo: PExcepInfo;
  ArgErr: PInteger): HResult;
type
  TVarStrDesc = record
    PStr: Pointer;
    BStr: PBStr;
  end;
var
  AutoEntry: PAutoEntry;
  ArgCount, NamedArgCount, ArgIndex, StrCount, I, J, K: Integer;
  ParamPtr, ArgPtr: PVarData;
  ArgType, VarFlag: Byte;
  StringPtr: Pointer;
  OleStr: TBStr;
  ResVar: TVarData;
  Strings: array[0..MaxDispArgs - 1] of TVarStrDesc;
  Args: array[0..MaxDispArgs - 1] of TVarData;
begin
  if Flags = DISPATCH_PROPERTYPUTREF then Flags := DISPATCH_PROPERTYPUT;
  AutoEntry := GetAutoEntry(ClassType, DispID, Flags);
  if (AutoEntry = nil) or (AutoEntry^.Params^.ResType = 0) and
    (VarResult <> nil) then
  begin
    Result := DISP_E_MEMBERNOTFOUND;
    Exit;
  end;
  NamedArgCount := Params.cNamedArgs;
  if Flags = DISPATCH_PROPERTYPUT then Dec(NamedArgCount);
  if NamedArgCount <> 0 then
  begin
    Result := DISP_E_NONAMEDARGS;
    Exit;
  end;
  ArgCount := Params.cArgs;
  if ArgCount <> AutoEntry^.Params^.ParamCount then
  begin
    Result := DISP_E_BADPARAMCOUNT;
    Exit;
  end;
  Result := S_OK;
  StrCount := 0;
  for I := 0 to ArgCount - 1 do Args[I].VType := varEmpty;
  FillChar(ResVar, sizeof(ResVar), 0);
  ResVar.VType := varEmpty;
  try
    try
      if ArgCount <> 0 then
      begin
        ParamPtr := @Params.rgvarg^[ArgCount];
        ArgPtr := @Args;
        ArgIndex := 0;
        repeat
          Dec(Integer(ParamPtr), SizeOf(Variant));
          ArgType := AutoEntry^.Params^.ParamTypes[ArgIndex] and atTypeMask;
          VarFlag := AutoEntry^.Params^.ParamTypes[ArgIndex] and atByRef;
          if (ParamPtr^.VType = varError) and ((ArgType <> varVariant) or
            (VarFlag <> 0)) then
          begin
            Result := DISP_E_PARAMNOTOPTIONAL;
            Break;
          end;
          if VarFlag <> 0 then
          begin
            if ParamPtr^.VType <> (ArgType and atVarMask or varByRef) then
            begin
              Result := DISP_E_TYPEMISMATCH;
              Break;
            end;
            if ArgType = varStrArg then
            begin
              with Strings[StrCount] do
              begin
                PStr := nil;
                BStr := ParamPtr^.VPointer;
                OleStrToStrVar(BStr^, string(PStr));
                ArgPtr^.VType := varString or varByRef;
                ArgPtr^.VPointer := @PStr;
              end;
              Inc(StrCount);
            end else
            begin
              ArgPtr^.VType := ParamPtr^.VType;
              ArgPtr^.VPointer := ParamPtr^.VPointer;
            end;
          end else
          if ArgType = varVariant then
          begin
            ArgPtr^.VType := varVariant or varByRef;
            ArgPtr^.VPointer := ParamPtr;
          end else
          begin
            Result := VariantChangeTypeEx(PVariant(ArgPtr)^,
              PVariant(ParamPtr)^, LOCALE_USER_DEFAULT, 0,
              ArgType and atVarMask);
            if Result <> S_OK then Break;
            if ArgType = varStrArg then
            begin
              StringPtr := nil;
              OleStrToStrVar(ArgPtr^.VOleStr, string(StringPtr));
              VariantClear(PVariant(ArgPtr)^);
              ArgPtr^.VType := varString;
              ArgPtr^.VString := StringPtr;
            end;
          end;
          Inc(Integer(ArgPtr), SizeOf(Variant));
          Inc(ArgIndex);
        until ArgIndex = ArgCount;
        if Result <> S_OK then
        begin
          if ArgErr <> nil then ArgErr^ := ArgCount - ArgIndex - 1;
          Exit;
        end;
      end;
      InvokeMethod(AutoEntry, @Args, @ResVar);
      for J := 0 to StrCount - 1 do
        with Strings[J] do
        begin
          OleStr := StringToOleStr(string(PStr));
          SysFreeString(BStr^);
          BStr^ := OleStr;
        end;
      if VarResult <> nil then
        if ResVar.VType = varString then
        begin
          OleStr := StringToOleStr(string(ResVar.VString));
          VariantClear(VarResult^);
          PVarData(VarResult)^.VType := varOleStr;
          PVarData(VarResult)^.VOleStr := OleStr;
        end else
        begin
          VariantClear(VarResult^);
          Move(ResVar, VarResult^, SizeOf(Variant));
          ResVar.VType := varEmpty;
        end;
    finally
      for K := 0 to StrCount - 1 do string(Strings[K].PStr) := '';
      for K := 0 to ArgCount - 1 do VarClear(Variant(Args[K]));
      VarClear(Variant(ResVar));
    end;
  except
    if ExcepInfo <> nil then
    begin
      FillChar(ExcepInfo^, SizeOf(TExcepInfo), 0);
      GetExceptionInfo(ExceptObject, ExcepInfo^);
    end;
    Result := DISP_E_EXCEPTION;
  end;
end;

procedure TAutoObject.InvokeMethod(AutoEntry, Args, Result: Pointer);
var
  Instance, AutoData: Pointer;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     Instance,EAX
        MOV     EBX,EDX
        MOV     ESI,[EBX].TAutoEntry.Params
        MOV     EDI,-2
        MOVZX   EAX,[ESI].TParamList.ParamCount
        OR      EAX,EAX
        JE      @CheckResult
        MOV     AutoData,EBX
        MOV     EBX,EAX
        MOV     ESI,ECX

@PushLoop:
        MOV     AX,[ESI].Word[0]
        CMP     EAX,varSingle
        JE      @Push4
        CMP     EAX,varDouble
        JE      @Push8
        CMP     EAX,varCurrency
        JE      @Push8
        CMP     EAX,varDate
        JE      @Push8
        INC     EDI
        JG      @Push4
        JE      @LoadECX

@LoadEDX:
        MOV     EDX,[ESI].Integer[8]
        JMP     @PushNext

@LoadECX:
        MOV     ECX,[ESI].Integer[8]
        JMP     @PushNext

@Push8:
        PUSH    [ESI].Integer[12]

@Push4:
        PUSH    [ESI].Integer[8]

@PushNext:
        ADD     ESI,16
        DEC     EBX
        JNE     @PushLoop
        MOV     EBX,AutoData
        MOV     ESI,[EBX].TAutoEntry.Params

@CheckResult:
        MOV     AL,[ESI].TParamList.ResType
        CMP     AL,varOleStr
        JE      @PassOleStrRes
        CMP     AL,varStrArg
        JE      @PassStringRes
        CMP     AL,varVariant
        JNE     @Invoke

@PassVarRes:
        MOV     EAX,Result
        JMP     @PassResult

@PassOleStrRes:
        MOV     EAX,Result
        MOV     [EAX].Word,varOleStr
        JMP     @PassStrRes

@PassStringRes:
        MOV     EAX,Result
        MOV     [EAX].Word,varString

@PassStrRes:
        ADD     EAX,8
        MOV     [EAX].Integer,0

@PassResult:
        INC     EDI
        JG      @ResultPush
        JE      @ResultECX

@ResultEDX:
        MOV     EDX,EAX
        JMP     @Invoke

@ResultECX:
        MOV     ECX,EAX
        JMP     @Invoke

@ResultPush:
        PUSH    EAX

@Invoke:
        MOV     EAX,Instance
        LEA     EDI,[EBX].TAutoEntry.Address
        TEST    [EBX].TAutoEntry.Flags,afVirtual
        JE      @CallMethod
        MOV     EDI,[EAX]
        ADD     EDI,[EBX].TAutoEntry.Address

@CallMethod:
        CALL    [EDI].Pointer
        MOV     EDX,Result
        MOV     CL,[ESI].TParamList.ResType
        AND     ECX,atVarMask
        JMP     @ResultTable.Pointer[ECX*4]

@ResultTable:
        DD      @ResNone
        DD      @ResNone
        DD      @ResInteger
        DD      @ResInteger
        DD      @ResSingle
        DD      @ResDouble
        DD      @ResCurrency
        DD      @ResDouble
        DD      @ResNone
        DD      @ResNone
        DD      @ResNone
        DD      @ResInteger
        DD      @ResNone

@ResSingle:
        FSTP    [EDX].Single[8]
        FWAIT
        JMP     @ResSetType

@ResDouble:
        FSTP    [EDX].Double[8]
        FWAIT
        JMP     @ResSetType

@ResCurrency:
        FISTP   [EDX].Currency[8]
        FWAIT
        JMP     @ResSetType

@ResInteger:
        MOV     [EDX].Integer[8],EAX

@ResSetType:
        MOV     [EDX].Word,CX

@ResNone:
        POP     EDI
        POP     ESI
        POP     EBX
end;

function TAutoObject.QueryInterface(const iid: TIID; var obj): HResult;
begin
  if IsEqualIID(iid, IID_IUnknown) or IsEqualIID(iid, IID_IDispatch) or
    IsEqualIID(iid, IID_IAutoDispatch) then
  begin
    Pointer(obj) := FAutoDispatch;
    AddRef;
    Result := S_OK;
  end else
  begin
    Pointer(obj) := nil;
    Result := E_NOINTERFACE;
  end;
end;

function TAutoObject.Release: Integer;
begin
  Dec(FRefCount);
  Result := FRefCount;
  if FRefCount = 0 then Free;
end;

{ TClassFactory }

constructor TClassFactory.Create(AutoClass: TAutoClass);
begin
  Inc(Automation.FClassFactoryCount);
  FRefCount := 1;
  FAutoClass := AutoClass;
end;

destructor TClassFactory.Destroy;
begin
  Dec(Automation.FClassFactoryCount);
end;

function TClassFactory.QueryInterface(const iid: TIID; var obj): HResult;
begin
  if IsEqualIID(iid, IID_IUnknown) or IsEqualIID(iid, IID_IClassFactory) then
  begin
    Pointer(obj) := Self;
    AddRef;
    Result := S_OK;
  end else
  begin
    Pointer(obj) := nil;
    Result := E_NOINTERFACE;
  end;
end;

function TClassFactory.AddRef: Longint;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TClassFactory.Release: Longint;
begin
  Dec(FRefCount);
  Result := FRefCount;
  if FRefCount = 0 then Free;
end;

function TClassFactory.CreateInstance(unkOuter: IUnknown; const iid: TIID;
  var obj): HResult;
var
  AutoObject: TAutoObject;
begin
  Pointer(obj) := nil;
  if unkOuter <> nil then
  begin
    Result := CLASS_E_NOAGGREGATION;
    Exit;
  end;
  try
    AutoObject := FAutoClass.Create;
  except
    Result := E_UNEXPECTED;
    Exit;
  end;
  Result := AutoObject.QueryInterface(iid, obj);
  AutoObject.Release;
end;

function TClassFactory.LockServer(fLock: BOOL): HResult;
begin
  Automation.CountAutoObject(fLock);
  Result := S_OK;
end;

{ TRegistryClass }

constructor TRegistryClass.Create(const AutoClassInfo: TAutoClassInfo);
const
  RegFlags: array[acSingleInstance..acMultiInstance] of Integer = (
    REGCLS_SINGLEUSE, REGCLS_MULTIPLEUSE);
var
  ClassFactory: TClassFactory;
begin
  FAutoClass := AutoClassInfo.AutoClass;
  FProgID := AutoClassInfo.ProgID;
  FClassID := StringToClassID(AutoClassInfo.ClassID);
  FDescription := AutoClassInfo.Description;
  FInstancing := AutoClassInfo.Instancing;
  if not Automation.IsInprocServer and (FInstancing <> acInternal) then
  begin
    ClassFactory := TClassFactory.Create(FAutoClass);
    CoRegisterClassObject(FClassID, ClassFactory, CLSCTX_LOCAL_SERVER,
      RegFlags[FInstancing], FRegister);
    ClassFactory.Release;
  end;
end;

destructor TRegistryClass.Destroy;
begin
  if FRegister <> 0 then CoRevokeClassObject(FRegister);
end;

procedure TRegistryClass.UpdateRegistry(Register: Boolean);
var
  ClassID, FileName: string;
  Buffer: array[0..261] of Char;
begin
  if FInstancing <> acInternal then
  begin
    ClassID := ClassIDToString(FClassID);
    SetString(FileName, Buffer, GetModuleFileName(HInstance, Buffer,
      SizeOf(Buffer)));
    if Register then
    begin
      CreateRegKey(FProgID, FDescription);
      CreateRegKey(FProgID + '\Clsid', ClassID);
      CreateRegKey('CLSID\' + ClassID, FDescription);
      CreateRegKey('CLSID\' + ClassID + '\ProgID', FProgID);
      CreateRegKey('CLSID\' + ClassID + '\' + GetServerKey, FileName);
    end else
    begin
      DeleteRegKey('CLSID\' + ClassID + '\' + GetServerKey);
      DeleteRegKey('CLSID\' + ClassID + '\ProgID');
      DeleteRegKey('CLSID\' + ClassID);
      DeleteRegKey(FProgID + '\Clsid');
      DeleteRegKey(FProgID);
    end;
  end;
end;

{ TAutomation }

var
  SaveInitProc: Pointer;

procedure InitAutomation;
begin
  if SaveInitProc <> nil then TProcedure(SaveInitProc);
  Automation.Initialize;
end;

constructor TAutomation.Create;
begin
  FIsInprocServer := IsLibrary;
  if FindCmdLineSwitch('AUTOMATION') or FindCmdLineSwitch('EMBEDDING') then
    FStartMode := smAutomation
  else if FindCmdLineSwitch('REGSERVER') then
    FStartMode := smRegServer
  else if FindCmdLineSwitch('UNREGSERVER') then
    FStartMode := smUnregServer;
end;

destructor TAutomation.Destroy;
var
  RegistryClass: TRegistryClass;
begin
  while FRegistryList <> nil do
  begin
    RegistryClass := FRegistryList;
    FRegistryList := RegistryClass.FNext;
    RegistryClass.Free;
  end;
end;

procedure TAutomation.CountAutoObject(Created: Boolean);
begin
  if Created then Inc(FAutoObjectCount) else
  begin
    Dec(FAutoObjectCount);
    if FAutoObjectCount = 0 then LastReleased;
  end;
end;

procedure TAutomation.Initialize;
begin
  UpdateRegistry(FStartMode <> smUnregServer);
  if FStartMode in [smRegServer, smUnregServer] then Halt;
end;

procedure TAutomation.LastReleased;
var
  Shutdown: Boolean;
begin
  if not FIsInprocServer then
  begin
    Shutdown := FStartMode = smAutomation;
    if Assigned(FOnLastRelease) then FOnLastRelease(Shutdown);
    if Shutdown then PostQuitMessage(0);
  end;
end;

procedure TAutomation.RegisterClass(const AutoClassInfo: TAutoClassInfo);
var
  RegistryClass: TRegistryClass;
begin
  RegistryClass := TRegistryClass.Create(AutoClassInfo);
  RegistryClass.FNext := FRegistryList;
  FRegistryList := RegistryClass;
end;

procedure TAutomation.UpdateRegistry(Register: Boolean);
var
  RegistryClass: TRegistryClass;
begin
  RegistryClass := FRegistryList;
  while RegistryClass <> nil do
  begin
    RegistryClass.UpdateRegistry(Register);
    RegistryClass := RegistryClass.FNext;
  end;
end;

initialization
begin
  OleInitialize(nil);
  Automation := TAutomation.Create;
  SaveInitProc := InitProc;
  InitProc := @InitAutomation;
end;

finalization
begin
  Automation.Free;
  OleUninitialize;
end;

end.
