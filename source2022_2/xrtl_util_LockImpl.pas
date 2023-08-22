unit xrtl_util_LockImpl;

{$INCLUDE xrtl.inc}

interface

uses
  Windows,
  SysUtils,
  xrtl_util_Lock;

type
  TXRTLCriticalSectionExclusiveLock = class(TInterfacedObject, IXRTLExclusiveLock)
  private
    FCriticalSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure  Acquire;
    function   TryAcquire: Boolean;
    procedure  Release;
  end;

  TXRTLNullExclusiveLock = class(TInterfacedObject, IXRTLExclusiveLock)
  private
  public
    constructor Create;
    destructor Destroy; override;
    procedure  Acquire;
    function   TryAcquire: Boolean;
    procedure  Release;
  end;

  TXRTLReadWriteLock = class(TInterfacedObject, IXRTLReadWriteLock)
  private
    FLock: TMultiReadExclusiveWriteSynchronizer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure  BeginRead;
    procedure  EndRead;
    function   BeginWrite: Boolean;
    procedure  EndWrite;
  end;
  
  TXRTLNullReadWriteLock = class(TInterfacedObject, IXRTLReadWriteLock)
  private
  public
    constructor Create;
    destructor Destroy; override;
    procedure  BeginRead;
    procedure  EndRead;
    function   BeginWrite: Boolean;
    procedure  EndWrite;
  end;

  TXRTLReadWriteExclusiveLockAdapter = class(TInterfacedObject, IXRTLReadWriteLock)
  private
    FLock: IXRTLExclusiveLock;
  public
    constructor Create(const ALock: IXRTLExclusiveLock);
    destructor Destroy; override;
    procedure  BeginRead;
    procedure  EndRead;
    function   BeginWrite: Boolean;
    procedure  EndWrite;
  end;

  TXRTLExclusiveAutoLock = class(TInterfacedObject)
  private
    FLock: IXRTLExclusiveLock;
  public
    constructor Create(const ALock: IXRTLExclusiveLock);
    destructor Destroy; override;
  end;

  TXRTLReadAutoLock = class(TInterfacedObject)
  private
    FLock: IXRTLReadWriteLock;
  public
    constructor Create(const ALock: IXRTLReadWriteLock);
    destructor Destroy; override;
  end;

  TXRTLWriteAutoLock = class(TInterfacedObject)
  private
    FLock: IXRTLReadWriteLock;
  public
    constructor Create(const ALock: IXRTLReadWriteLock);
    destructor Destroy; override;
  end;

implementation

{ TXRTLCriticalSectionExclusiveLock }

constructor TXRTLCriticalSectionExclusiveLock.Create;
begin
  inherited;
  InitializeCriticalSection(FCriticalSection);
end;

destructor TXRTLCriticalSectionExclusiveLock.Destroy;
begin
  DeleteCriticalSection(FCriticalSection);
  inherited;
end;

procedure TXRTLCriticalSectionExclusiveLock.Acquire;
begin
  EnterCriticalSection(FCriticalSection);
end;

function TXRTLCriticalSectionExclusiveLock.TryAcquire: Boolean;
begin
  Result:= TryEnterCriticalSection(FCriticalSection);
end;

procedure TXRTLCriticalSectionExclusiveLock.Release;
begin
  LeaveCriticalSection(FCriticalSection);
end;

{ TXRTLNullExclusiveLock }

constructor TXRTLNullExclusiveLock.Create;
begin
  inherited;
end;

destructor TXRTLNullExclusiveLock.Destroy;
begin
  inherited;
end;

procedure TXRTLNullExclusiveLock.Acquire;
begin
end;

function TXRTLNullExclusiveLock.TryAcquire: Boolean;
begin
  Result:= True;
end;

procedure TXRTLNullExclusiveLock.Release;
begin
end;

{ TXRTLExclusiveAutoLock }

constructor TXRTLExclusiveAutoLock.Create(const ALock: IXRTLExclusiveLock);
begin
  inherited Create;
  FLock:= ALock;
  FLock.Acquire;
end;

destructor TXRTLExclusiveAutoLock.Destroy;
begin
  FLock.Release;
  inherited;
end;

{ TXRTLReadWriteLock }

constructor TXRTLReadWriteLock.Create;
begin
  inherited;
  FLock:= TMultiReadExclusiveWriteSynchronizer.Create;
end;

destructor TXRTLReadWriteLock.Destroy;
begin
  FreeAndNil(FLock);
  inherited;
end;

procedure TXRTLReadWriteLock.BeginRead;
begin
  FLock.BeginRead;
end;

procedure TXRTLReadWriteLock.EndRead;
begin
  FLock.EndRead;
end;

function TXRTLReadWriteLock.BeginWrite: Boolean;
begin
  {$IFDEF COMPILER6_UP}
  Result:= FLock.BeginWrite;
  {$ELSE}
  Result:= False;
  FLock.BeginWrite;
  {$ENDIF}
end;

procedure TXRTLReadWriteLock.EndWrite;
begin
  FLock.EndWrite;
end;

{ TXRTLNullReadWriteLock }

constructor TXRTLNullReadWriteLock.Create;
begin
  inherited;
end;

destructor TXRTLNullReadWriteLock.Destroy;
begin
  inherited;
end;

procedure TXRTLNullReadWriteLock.BeginRead;
begin
end;

procedure TXRTLNullReadWriteLock.EndRead;
begin
end;

function TXRTLNullReadWriteLock.BeginWrite: Boolean;
begin
  Result:= False;
end;

procedure TXRTLNullReadWriteLock.EndWrite;
begin
end;

{ TXRTLReadWriteExclusiveLockAdapter }

constructor TXRTLReadWriteExclusiveLockAdapter.Create(const ALock: IXRTLExclusiveLock);
begin
  inherited Create;
  FLock:= ALock;
end;

destructor TXRTLReadWriteExclusiveLockAdapter.Destroy;
begin
  inherited;
end;

procedure TXRTLReadWriteExclusiveLockAdapter.BeginRead;
begin
  FLock.Acquire;
end;

procedure TXRTLReadWriteExclusiveLockAdapter.EndRead;
begin
  FLock.Release;
end;

function TXRTLReadWriteExclusiveLockAdapter.BeginWrite: Boolean;
begin
  FLock.Acquire;
  Result:= False;
end;

procedure TXRTLReadWriteExclusiveLockAdapter.EndWrite;
begin
  FLock.Release;
end;

{ TXRTLReadAutoLock }

constructor TXRTLReadAutoLock.Create(const ALock: IXRTLReadWriteLock);
begin
  inherited Create;
  FLock:= ALock;
  FLock.BeginRead;
end;

destructor TXRTLReadAutoLock.Destroy;
begin
  FLock.EndRead;
  inherited;
end;

{ TXRTLWriteAutoLock }

constructor TXRTLWriteAutoLock.Create(const ALock: IXRTLReadWriteLock);
begin
  inherited Create;
  FLock:= ALock;
  FLock.BeginWrite;
end;

destructor TXRTLWriteAutoLock.Destroy;
begin
  FLock.EndWrite;
  inherited;
end;

end.
