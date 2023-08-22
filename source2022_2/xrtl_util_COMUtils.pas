unit xrtl_util_COMUtils;

{$INCLUDE xrtl.inc}

interface

uses
  Windows, SysUtils, COMObj, ActiveX, Classes,
  xrtl_util_Value,
  xrtl_util_Container, xrtl_util_Array, xrtl_util_Algorithm;

type
  TXRTLEnumXXXX = class(TInterfacedObject)
  private
  protected
    FNextIndex: LongInt;
    function   GetItem(const ItemIndex: LongInt): Pointer; virtual; abstract;
    function   GetCount: LongInt; virtual; abstract;
  public
    constructor Create;
    function   Next(celt: Longint; out elt; pceltFetched: PLongInt): HResult; stdcall;
    function   Skip(celt: Longint): HResult; stdcall;
    function   Reset: HResult; stdcall;
    property   Count: LongInt read GetCount;
  end;

  TXRTLEnumUnknown = class(TXRTLEnumXXXX, IEnumUnknown)
  private
    procedure  SetItems(const Value: TXRTLArray);
  protected
    FItems: TXRTLArray;
    function   GetItem(const ItemIndex: LongInt): Pointer; override;
    function   GetCount: LongInt; override;
  public
    constructor Create(const AItems: TXRTLArray = nil);
    destructor Destroy; override;
    procedure  Add(const Obj: Pointer);
    property   Items: TXRTLArray read FItems write SetItems;
    function   Clone(out enm: IEnumUnknown): HResult; stdcall;
  end;

  TXRTLEnumString = class(TXRTLEnumXXXX, IEnumString)
  private
  protected
    FStrings: TXRTLArray;
    function   GetItem(const ItemIndex: LongInt): Pointer; override;
    function   GetCount: LongInt; override;
  public
    constructor Create(const AStrings: TStrings = nil);
    destructor Destroy; override;
    property   Strings: TXRTLArray read FStrings;
    function   Clone(out enm: IEnumString): HResult; stdcall;
    procedure  Assign(const AStrings: TStrings); overload;
    procedure  Assign(const AStrings: TXRTLArray); overload;
    procedure  Add(const S: WideString);
  end;

function  XRTLHandleCOMException: HResult;
procedure XRTLCheckArgument(Flag: Boolean);
procedure XRTLCheckOutArgument(out Arg);
procedure XRTLInterfaceConnect(const Source: IUnknown; const IID: TIID;
  const Sink: IUnknown; var Connection: Longint);
procedure XRTLInterfaceDisconnect(const Source: IUnknown; const IID: TIID;
  var Connection: Longint);
function  XRTLRegisterActiveObject(const Unk: IUnknown; ClassID: TCLSID; Flags: DWORD;
  var RegisterCookie: Integer): HResult;
function  XRTLUnRegisterActiveObject(var RegisterCookie: Integer): HResult;
function  XRTLGetActiveObject(ClassID: TCLSID; RIID: TIID; out Obj): HResult;
procedure XRTLEnumActiveObjects(Strings: TStrings);

const
  ole32 = 'ole32.dll';

function CreateClassMoniker(const ClsID: TClsID; out Moniker: IMoniker): HResult; stdcall;

function XRTLAllocOutWideString(const Src: WideString): PWideChar;
procedure XRTLFreeOutWideString(var Src: PWideChar);
function XRTLWideStringToOLEStr(const Src: WideString): POLEStr;

implementation

uses
  xrtl_util_MemoryUtils;

function XRTLHandleCOMException: HResult;
var
  E: TObject;
begin
  E:= ExceptObject;
  if (E is EOleSysError) and Failed(EOleSysError(E).ErrorCode) then
    Result:= EOleSysError(E).ErrorCode
  else
    Result:= E_UNEXPECTED;
end;

procedure XRTLCheckArgument(Flag: Boolean);
begin
  if not Flag then
    OLECheck(E_INVALIDARG);
end;

procedure XRTLCheckOutArgument(out Arg);
begin
  XRTLCheckArgument(Addr(Arg) <> nil);
end;

procedure XRTLInterfaceConnect(const Source: IUnknown; const IID: TIID;
  const Sink: IUnknown; var Connection: Longint);
var
  CPC: IConnectionPointContainer;
  CP: IConnectionPoint;
begin
  Connection:= 0;
  OLECheck(Source.QueryInterface(IConnectionPointContainer, CPC));
  OLECheck(CPC.FindConnectionPoint(IID, CP));
  OLECheck(CP.Advise(Sink, Connection));
end;

procedure XRTLInterfaceDisconnect(const Source: IUnknown; const IID: TIID;
  var Connection: Longint);
var
  CPC: IConnectionPointContainer;
  CP: IConnectionPoint;
begin
  if Connection = 0 then Exit;
  OLECheck(Source.QueryInterface(IConnectionPointContainer, CPC));
  OLECheck(CPC.FindConnectionPoint(IID, CP));
  OLECheck(CP.Unadvise(Connection));
  Connection:= 0;
end;

function CreateClassMoniker(const ClsID: TClsID; out Moniker: IMoniker): HResult; stdcall; external ole32 name 'CreateClassMoniker';

function  XRTLRegisterActiveObject(const Unk: IUnknown; ClassID: TCLSID; Flags: DWORD;
  var RegisterCookie: Integer): HResult;
var
  ROT: IRunningObjectTable;
  IM: IMoniker;
begin
  RegisterCookie:= 0;
  try
    Result:= S_OK;
    OLECheck(CreateClassMoniker(ClassID, IM));
    OLECheck(GetRunningObjectTable(0, ROT));
    OLECheck(ROT.Register(Flags, Unk, IM, RegisterCookie));
  except
    Result:= XRTLHandleCOMException;
  end;
end;

function XRTLUnRegisterActiveObject(var RegisterCookie: Integer): HResult;
var
  ROT: IRunningObjectTable;
begin
  try
    Result:= S_OK;
    if RegisterCookie <> 0 then
    begin
      OLECheck(GetRunningObjectTable(0, ROT));
      OLECheck(ROT.Revoke(RegisterCookie));
      RegisterCookie:= 0;
    end;
  except
    Result:= XRTLHandleCOMException;
  end;
end;

function XRTLGetActiveObject(ClassID: TCLSID; RIID: TIID; out Obj): HResult;
var
  ROT: IRunningObjectTable;
  IM: IMoniker;
  Unk: IUnknown;
begin
  try
    Result:= S_OK;
    OLECheck(CreateClassMoniker(ClassID, IM));
    OLECheck(GetRunningObjectTable(0, ROT));
    OLECheck(ROT.GetObject(IM, Unk));
    OLECheck(Unk.QueryInterface(RIID, Obj));
  except
    Result:= XRTLHandleCOMException;
  end;
end;

procedure XRTLEnumActiveObjects(Strings: TStrings);
var
  ROT: IRunningObjectTable;
  IM: IMoniker;
  IMEnum: IEnumMoniker;
  IBC: IBindCtx;
  Fetched: Integer;
  szDisplayName: PWideChar;
begin
  OLECheck(CreateBindCtx(0, IBC));
  OLECheck(GetRunningObjectTable(0, ROT));
  OLECheck(ROT.EnumRunning(IMEnum));
  while (IMEnum.Next(1, IM, @Fetched) = S_OK) and (Fetched > 0) do
  begin
    OLECheck(IM.GetDisplayName(IBC, nil, szDisplayName));
    Strings.Add(string(szDisplayName));
    CoTaskMemFree(szDisplayName);
  end;
end;

function XRTLAllocOutWideString(const Src: WideString): PWideChar;
begin
  Result:= CoTaskMemAlloc((Length(Src) + 1) * SizeOf(WideChar));
  XRTLMoveMemory(PWideChar(Src), Result, (Length(Src) + 1) * SizeOf(WideChar));
end;

procedure XRTLFreeOutWideString(var Src: PWideChar);
begin
  if Assigned(Src) then
  begin
    CoTaskMemFree(Src);
    Src:= nil;
  end;
end;

function XRTLWideStringToOLEStr(const Src: WideString): POLEStr;
begin
  Result:= XRTLAllocOutWideString(Src);
end;

{ TXRTLEnumXXXX }

constructor TXRTLEnumXXXX.Create;
begin
  inherited;
  FNextIndex:= 0;
end;

function TXRTLEnumXXXX.Reset: HResult;
begin
  FNextIndex:= 0;
  Result:= S_OK;
end;

function TXRTLEnumXXXX.Next(celt: Integer; out elt; pceltFetched: PLongInt): HResult;
var
  Index: Integer;
begin
  try
    if celt < 1 then
    begin
      Result:= RPC_X_ENUM_VALUE_OUT_OF_RANGE;
      Exit;
    end;
    if pceltFetched = nil then
    begin
      Result:= E_INVALIDARG;
      Exit;
    end;
    Index:= 0;
    while (Index < celt) do
    begin
      if (FNextIndex < Count) then
      begin
        TPointerList(elt)[Index]:= GetItem(FNextIndex);
        Inc(Index);
        Inc(FNextIndex);
      end
      else
        Break;
    end;
    pceltFetched^:= Index;
    if Index = celt then
      Result:= S_OK
    else
      Result:= S_FALSE;
  except
    Result:= E_FAIL;
  end;
end;

function TXRTLEnumXXXX.Skip(celt: Integer): HResult;
begin
  try
    if (FNextIndex + celt) <= Count then
    begin
      FNextIndex:= FNextIndex + celt;
      Result:= S_OK;
    end
    else
    begin
      FNextIndex:= Count;
      Result:= S_FALSE;
    end;
  except
    Result:= E_FAIL;
  end;
end;

{ TXRTLEnumUnknown }

constructor TXRTLEnumUnknown.Create(const AItems: TXRTLArray = nil);
begin
  inherited Create;
  FItems:= TXRTLArray.Create;
  if Assigned(AItems) then
    SetItems(AItems);
end;

destructor TXRTLEnumUnknown.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TXRTLEnumUnknown.Add(const Obj: Pointer);
begin
  FItems.Add(XRTLValue(Obj));
end;

procedure TXRTLEnumUnknown.SetItems(const Value: TXRTLArray);
begin
  FItems.Clear;
  XRTLCopy(Value, FItems);
end;

function TXRTLEnumUnknown.GetCount: LongInt;
begin
  Result:= FItems.GetSize;
end;

function TXRTLEnumUnknown.GetItem(const ItemIndex: Integer): Pointer;
begin
  Result:= XRTLGetAsPointer(FItems.GetValue(ItemIndex));
end;

function TXRTLEnumUnknown.Clone(out enm: IEnumUnknown): HResult;
begin
  try
    if Addr(enm) = nil then
    begin
      Result:= E_INVALIDARG;
      Exit;
    end;
    enm:= TXRTLEnumUnknown.Create(FItems);
    Result:= S_OK;
  except
    Result:= E_UNEXPECTED;
  end;
end;

{ TXRTLEnumString }

constructor TXRTLEnumString.Create(const AStrings: TStrings = nil);
begin
  inherited Create;
  FStrings:= TXRTLArray.Create;
  if Assigned(AStrings) then
    Assign(AStrings);
end;

destructor TXRTLEnumString.Destroy;
begin
  FreeAndNil(FStrings);
  inherited;
end;

procedure TXRTLEnumString.Add(const S: WideString);
begin
  FStrings.Add(XRTLValue(S));
end;

procedure TXRTLEnumString.Assign(const AStrings: TStrings);
var
  I: Integer;
  WS: WideString;
begin
  FStrings.Clear;
  for I:= 0 to AStrings.Count - 1 do
  begin
    WS:= AStrings[I];
    Add(WS);
  end;
end;

procedure TXRTLEnumString.Assign(const AStrings: TXRTLArray);
begin
  FStrings.Clear;
  XRTLCopy(AStrings, FStrings);
end;

function TXRTLEnumString.GetCount: LongInt;
begin
  Result:= FStrings.GetSize;
end;

function TXRTLEnumString.GetItem(const ItemIndex: Integer): Pointer;
begin
  Result:= XRTLAllocOutWideString(XRTLGetAsWideString(FStrings.GetValue(ItemIndex)));
end;

function TXRTLEnumString.Clone(out enm: IEnumString): HResult;
var
  EnumString: TXRTLEnumString;
begin
  enm:= nil;
  try
    EnumString:= TXRTLEnumString.Create;
    EnumString.Assign(FStrings);
    enm:= EnumString;
    Result:= S_OK;
  except
    FreeAndNil(EnumString);
    Result:= E_UNEXPECTED;
  end;
end;

end.
