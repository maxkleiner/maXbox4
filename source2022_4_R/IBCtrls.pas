{**********************************************************}
{                                                          }
{       Borland Deplphi                                    }
{       InterBase EventAlerter components                  }
{       Copyright (c) 1995,1999-2002 Borland Corporation   }
{                                                          }
{       Written by:                                        }
{         James Thorpe                                     }
{         CSA Australasia                                  }
{         Compuserve: 100035,2064                          }
{         Internet:   csa@csaa.com.au                      }
{                                                          }
{**********************************************************}

unit IBCtrls;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, IBProc32, BDE;

const
  MaxEvents = 15;
  EventLength = 64;

type

  TIBComponent = class( TComponent)
  private
    FDatabase: TDatabase;
    procedure SetDatabase( value: TDatabase);
    procedure ValidateDatabase( Database: TDatabase);
  protected
    function  GetNativeHandle: isc_db_handle;
    procedure HandleIBErrors( status: pstatus_vector);
    function  IsInterbaseDatabase( Database: TDatabase): Boolean;
  published
    property  Database: TDatabase read FDatabase write SetDatabase;
  end;

  TEventAlert = procedure( Sender: TObject; EventName: string; EventCount: longint;
                           var CancelAlerts: Boolean) of object;

  TEventBuffer = array[ 0..MaxEvents-1, 0..EventLength-1] of char;

  TIBEventAlerter = class(TIBComponent)
  private
    LibHandle: THandle;
    FEvents: TStrings;
    FOnEventAlert: TEventAlert;
    FQueued: Boolean;
    FRegistered: Boolean;
    Buffer: TEventBuffer;
    Changing: Boolean;
    CS: TRTLCriticalSection;
    EventBuffer: PChar;
    EventBufferLen: integer;
    EventID: isc_long;
    ProcessingEvents: Boolean;
    RegisteredState: Boolean;
    ResultBuffer: PChar;
    procedure DoQueueEvents;
    procedure EventChange( sender: TObject);
    procedure UpdateResultBuffer( length: short; updated: PChar);
  protected
    procedure HandleEvent;
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation); override;
    procedure SetEvents( value: TStrings);
    procedure SetDatabase( value: TDatabase);
    procedure SetRegistered( value: boolean);
  public
    constructor Create( AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CancelEvents;
    procedure QueueEvents;
    procedure RegisterEvents;
    procedure UnRegisterEvents;
    property  Queued: Boolean read FQueued;
  published
    property Events: TStrings read FEvents write SetEvents;
    property Registered: Boolean read FRegistered write SetRegistered;
    property OnEventAlert: TEventAlert read FOnEventAlert write FOnEventAlert;
  end;

  EIBError = class( Exception);

implementation

uses IBConst;

var
  // Dynamically Loaded InterBase API functions (gds32.dll)
  IscQueEvents: TIscQueEvents;
  IscFree: TIscfree;
  IscEventBlock: TIscEventBlock;
  IscEventCounts: TIscEventCounts;
  IscCancelEvents: TIscCancelEvents;
  IscInterprete: TIscInterprete;

resourcestring
  SInterbaseNotInstalled = 'You must have Interbase installed to use this component';
  SFailedQueEvents = 'Failed to lookup isc_que_events';
  SFailedInterprete = 'Failed to lookup isc_interprete';
  SFailedFree = 'Failed to lookup isc_free';
  SFailedEventBlock = 'Failed to lookup isc_event_block';
  SFailedEventCounts = 'Failed to lookup isc_event_counts';
  SFailedCancelEvents = 'Failed to lookup isc_cancel_events';

// TIBComponent

function TIBComponent.GetNativeHandle: isc_db_handle;
var
  length: word;
begin
  if assigned( FDatabase) and FDatabase.Connected then
    Check( DbiGetProp( HDBIOBJ(FDatabase.Handle), dbNATIVEHNDL,
                       @result, sizeof( isc_db_handle), length))
  else result := nil;
end;

procedure TIBComponent.HandleIBErrors( status: pstatus_vector);
var
  buffer: array[0..255] of char;
  errMsg, lastMsg: string;
  errCode: isc_status;
begin
  errMsg := '';
  repeat
    errCode := IscInterprete( @buffer, @status);
    if lastMsg <> strPas( Buffer) then
    begin
      lastMsg := strPas( buffer);
      if length( errMsg) <> 0 then errMsg := errMsg+#13#10;
      errMsg := errMsg+lastMsg;
    end;
  until errCode = 0;
  raise EIBError.Create( errMsg);
end;

function TIBComponent.IsInterbaseDatabase( Database: TDatabase): Boolean;
var
  Length: Word;
  Buffer: array[0..63] of Char;
begin
  Result := False;
  if Database.Handle <> nil then
  begin
    Check(DbiGetProp(HDBIOBJ(Database.Handle), dbDATABASETYPE, @Buffer,
      SizeOf(Buffer), Length));
    Result := StrIComp(Buffer, 'INTRBASE') = 0;
  end;
end;

procedure TIBComponent.SetDatabase( value: TDatabase);
begin
  if value <> FDatabase then
  begin
    if assigned( value) and value.Connected then ValidateDatabase( value);
    FDatabase := value;
  end;
end;

procedure TIBComponent.ValidateDatabase( Database: TDatabase);
begin
  if not assigned( Database) or not Database.Connected then
    raise EIBError.CreateRes(@SInvalidDBConnection)
  else if not IsInterbaseDatabase( Database) then
    raise EIBError.CreateResFmt(@SInvalidDatabase, [Database.Name]);
end;

// TIBEventAlerter

procedure HandleEvent( param: integer); stdcall;
begin
  // don't let exceptions propogate out of thread
  try
    TIBEventAlerter( param).HandleEvent;
  except
    Application.HandleException( nil);
  end;
end;

procedure IBEventCallback( ptr: pointer; length: short; updated: PChar); cdecl;
var
  ThreadID: DWORD;
begin
  // Handle events asynchronously in second thread
  EnterCriticalSection( TIBEventAlerter( ptr).CS);
  TIBEventAlerter( ptr).UpdateResultBuffer( length, updated);
  if TIBEventAlerter( ptr).Queued then
    CloseHandle( CreateThread( nil, 8192, @HandleEvent, ptr, 0, ThreadID));
  LeaveCriticalSection( TIBEventAlerter( ptr).CS);
end;

constructor TIBEventAlerter.Create( AOwner: TComponent);
begin
  inherited Create( AOwner);
  InitializeCriticalSection( CS);
  FEvents := TStringList.Create;
  with TStringList( FEvents) do
  begin
    OnChange := EventChange;
    Duplicates := dupIgnore;
  end;
  // Attempt to load GDS32.DLL.  If this fails then raise an exception.
  // This will cause the component not to be created
  LibHandle := LoadLibrary('gds32.dll');
  if LibHandle < 32 then
    raise EDLLLoadError.CreateRes(@sInterbaseNotInstalled);

  @IscQueEvents := GetProcAddress(LibHandle, 'isc_que_events');
  if @IscQueEvents = nil then
    raise EDLLLoadError.CreateRes(@SFailedQueEvents);

  @IscInterprete := GetProcAddress(LibHandle, 'isc_interprete');
  if @IscInterprete = nil then
    raise EDLLLoadError.CreateRes(@SFailedInterprete);

  @IscFree := GetProcAddress(LibHandle, 'isc_free');
  if @IscFree = nil then
    raise EDLLLoadError.CreateRes(@SFailedFree);

  @IscEventBlock := GetProcAddress(LibHandle, 'isc_event_block');
  if @IscEventBlock = nil then
    raise EDLLLoadError.CreateRes(@SFailedEventBlock);

  @IscEventCounts := GetProcAddress(LibHandle, 'isc_event_counts');
  if @IscEventCounts = nil then
    raise EDLLLoadError.CreateRes(@SFailedEventCounts);

  @IscCancelEvents := GetProcAddress(LibHandle, 'isc_cancel_events');
  if @IscCancelEvents = nil then
    raise EDLLLoadError.CreateRes(@SFailedCancelEvents);

end;

destructor TIBEventAlerter.Destroy;
begin
  UnregisterEvents;
  SetDatabase( nil);
  TStringList(FEvents).OnChange := nil;
  FEvents.Free;
  DeleteCriticalSection( CS);
  inherited Destroy;
  if LibHandle >= 32 then
    FreeLibrary(LibHandle);

end;

procedure TIBEventAlerter.CancelEvents;
var
  status: status_vector;
  errCode: isc_status;
  dbHandle: isc_db_handle;
begin
  if ProcessingEvents then
    raise EIBError.CreateRes(@SInvalidCancellation);
  if FQueued then
  begin
    try
      // wait for event handler to finish before cancelling events
      EnterCriticalSection( CS);
      ValidateDatabase( Database);
      FQueued := false;
      Changing := true;
      dbHandle := GetNativeHandle;
      errCode := IscCancelEvents( @status, @dbHandle, @EventID);
      if errCode <> 0 then HandleIBErrors( @status)
    finally
      LeaveCriticalSection( CS);
    end;
  end;
end;

procedure TIBEventAlerter.DoQueueEvents;
var
  status: status_vector;
  errCode: isc_status;
  callback: pointer;
  dbHandle: isc_db_handle;
begin
  ValidateDatabase( DataBase);
  callback := @IBEventCallback;
  dbHandle := GetNativeHandle;
  errCode := IscQueEvents( @status, @dbHandle, @EventID, EventBufferLen,
                               EventBuffer, isc_callback(callback), self);
  if errCode <> 0 then HandleIBErrors( @status);
  FQueued := true;
end;

procedure TIBEventAlerter.EventChange( sender: TObject);
begin
  // check for blank event
  if TStringList(Events).IndexOf( '') <> -1 then
    raise EIBError.CreateRes(@SInvalidEvent);
  // check for too many events
  if Events.Count > MaxEvents then
  begin
    TStringList(Events).OnChange := nil;
    Events.Delete( MaxEvents);
    TStringList(Events).OnChange := EventChange;
    raise EIBError.CreateRes(@SMaximumEvents);
  end;
  if Registered then RegisterEvents;
end;

procedure TIBEventAlerter.HandleEvent;
var
  CancelAlerts: Boolean;
  i: integer;
  status: status_vector;
begin
  try
    // prevent modification of vital data structures while handling events
    EnterCriticalSection( CS);
    ProcessingEvents := true;
    IscEventCounts( @status, EventBufferLen, EventBuffer, ResultBuffer);
    CancelAlerts := false;
    if assigned(FOnEventAlert) and not Changing then
    begin
      for i := 0 to Events.Count-1 do
      begin
        try
          if (status[i] <> 0) and not CancelAlerts then
            FOnEventAlert( self, Events[Events.Count-i-1], status[i], CancelAlerts);
        except
          Application.HandleException( nil);
        end;
      end;
    end;
    Changing := false;
    if not CancelAlerts and FQueued then DoQueueEvents;
  finally
    ProcessingEvents := false;
    LeaveCriticalSection( CS);
  end;
end;

procedure TIBEventAlerter.Loaded;
begin
  inherited Loaded;
  try
    if RegisteredState then RegisterEvents;
  except
    if csDesigning in ComponentState then
      Application.HandleException( self)
    else raise;
  end;
end;

procedure TIBEventAlerter.Notification( AComponent: TComponent;
                                        Operation: TOperation);
begin
  inherited Notification( AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDatabase) then
  begin
    UnregisterEvents;
    FDatabase := nil;
  end;
end;

procedure TIBEventAlerter.QueueEvents;
begin
  if not FRegistered then
    raise EIBError.CreateRes(@SNoEventsRegistered);
  if ProcessingEvents then
    raise EIBError.CreateRes(@SInvalidQueueing);
  if not FQueued then
  begin
    try
      // wait until current event handler is finished before queuing events
      EnterCriticalSection( CS);
      DoQueueEvents;
      Changing := true;
    finally
      LeaveCriticalSection( CS);
    end;
  end;
end;

procedure TIBEventAlerter.RegisterEvents;
var
  i: integer;
  bufptr: pointer;
  eventbufptr: pointer;
  resultbufptr: pointer;
  buflen: integer;
begin
  ValidateDatabase( Database);
  if csDesigning in ComponentState then FRegistered := true
  else begin
    UnregisterEvents;
    if Events.Count = 0 then exit;
    for i := 0 to Events.Count-1 do
      StrPCopy( @Buffer[i][0], Events[i]);
    i := Events.Count;
    bufptr := @buffer[0];
    eventbufptr :=  @EventBuffer;
    resultBufPtr := @ResultBuffer;
    asm
      mov ecx, dword ptr [i]
      mov eax, dword ptr [bufptr]
      @@1:
      push eax
      add  eax, EventLength
      loop @@1
      push dword ptr [i]
      push dword ptr [resultBufPtr]
      push dword ptr [eventBufPtr]
      call [IscEventBlock]
      mov  dword ptr [bufLen], eax
      mov eax, dword ptr [i]
      shl eax, 2
      add eax, 12
      add esp, eax
    end;
    EventBufferlen := Buflen;
    FRegistered := true;
    QueueEvents;
  end;
end;

procedure TIBEventAlerter.SetEvents( value: TStrings);
begin
  FEvents.Assign( value);
end;

procedure TIBEventAlerter.SetDatabase( value: TDatabase);
begin
  if value <> FDatabase then
  begin
    UnregisterEvents;
    if assigned( value) and value.Connected then ValidateDatabase( value);
    FDatabase := value;
  end;
end;

procedure TIBEventAlerter.SetRegistered( value: Boolean);
begin
  if (csReading in ComponentState) then
    RegisteredState := value
  else if FRegistered <> value then
    if value then RegisterEvents else UnregisterEvents;
end;

procedure TIBEventAlerter.UnregisterEvents;
begin
  if ProcessingEvents then
    raise EIBError.CreateRes(@SInvalidRegistration);
  if csDesigning in ComponentState then
    FRegistered := false
  else if not (csLoading in ComponentState) then
  begin
    CancelEvents;
    if FRegistered then
    begin
      IscFree( EventBuffer);
      EventBuffer := nil;
      IscFree( ResultBuffer);
      ResultBuffer := nil;
    end;
    FRegistered := false;
  end;
end;

procedure TIBEventAlerter.UpdateResultBuffer( length: short; updated: PChar);
var
  i: integer;
begin
  for i := 0 to length-1 do
    ResultBuffer[i] := updated[i];
end;

end.
