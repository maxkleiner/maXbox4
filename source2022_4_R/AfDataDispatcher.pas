{==============================================================================|
| Project : Delphree - AsyncFree                                 | 001.004.000 |
|==============================================================================|
| Content:  Data dispatcher component                                          |
|==============================================================================|
| The contents of this file are subject to the Mozilla Public License Ver. 1.0 |
| (the "License"); you may not use this file except in compliance with the     |
| License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ |
|                                                                              |
| Software distributed under the License is distributed on an "AS IS" basis,   |
| WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for |
| the specific language governing rights and limitations under the License.    |
|==============================================================================|
| The Original Code is AsyncFree Library.                                      |
|==============================================================================|
| The Initial Developer of the Original Code is Petr Vones (Czech Republic).   |
| Portions created by Petr Vones are Copyright (C) 1998, 1999.                 |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| History:                                                                     |
|   see AfRegister.pas                                                         |
|==============================================================================}

unit AfDataDispatcher;

{$I PVDEFINE.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AfCircularBuffer, AfSafeSync;

type
  EAfDispatcherError = class(Exception);

  TAfDispEventKind = (deData, deWriteBufFree, deClear);
  TAfDispEventKinds = set of TAfDispEventKind;

  TAfDispLineEvent = procedure(Sender: TObject; const TextLine: String) of object;
  TAfDispLinkEvent = procedure(Sender: TObject; EventKind: TAfDispEventKind) of object;
  TAfDispStreamEvent = procedure(Sender: TObject; const Position, Size: Integer) of object;
  TAfDispWriteToEvent = procedure(Sender: TObject; const Data; Size: Integer) of object;

  TAfCustomDataDispatcher = class;

  TAfDataDispConnComponent = class(TComponent)
  protected
    FDispatcher: TAfCustomDataDispatcher;
  public
    procedure Close; dynamic;
    destructor Destroy; override;
    procedure Open; dynamic; 
    procedure WriteData(const Data; Size: Integer); virtual; abstract;
    property Dispatcher: TAfCustomDataDispatcher read FDispatcher;
  end;

  TAfDataDispatcherLink = class(TPersistent)
  private
    FDispatcher: TAfCustomDataDispatcher;
    FOnNotify: TAfDispLinkEvent;
    procedure SetDispatcher(const Value: TAfCustomDataDispatcher);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Notify(EventKind: TAfDispEventKind);
    property Dispatcher: TAfCustomDataDispatcher read FDispatcher write SetDispatcher;
    property OnNotify: TAfDispLinkEvent read FOnNotify write FOnNotify;
  end;

  TAfCustomDataDispatcher = class(TComponent)
  private
    FBufferSize: Integer;
    FDataProviderActive: Boolean;
    FDataProvider: TAfDataDispConnComponent;
    FDispatchBuffer: TAfCircularBuffer;
    FDispEvents: TAfDispEventKinds;
    FLinksList: TList;
    FLinkListChanged: Boolean;
    FMaxReadBytes: Integer;
    FNotifying: Boolean;
    FReceivedBytes: Integer;
    FSentBytes: Integer;
    FStream: TStream;
    FStreamBlockSize: Integer;
    FStreamWriting: Boolean;
    FStreamFreeAfterWrite: Boolean;
    FSyncID: TAfSyncSlotID;
    CritSect: TRTLCriticalSection;
    Sync_Event: TAfDispEventKind;
    Sync_ListIndex: Integer;
    FOnDataReceived: TNotifyEvent;
    FOnWriteBufFree: TNotifyEvent;
    FOnWriteStreamBlock: TAfDispStreamEvent;
    FOnWriteStreamDone: TNotifyEvent;
    FOnWriteToDevice: TAfDispWriteToEvent;
    FOnLineReceived: TAfDispLineEvent;
    FOnProviderOpen: TNotifyEvent;
    FOnProviderClose: TNotifyEvent;
    procedure SetDataProvider(const Value: TAfDataDispConnComponent);
  protected
    procedure AddLink(Link: TAfDataDispatcherLink);
    procedure CheckNewLines;
    procedure DataProviderClose;
    procedure DataProviderOpen;
    procedure DoEvents(EventKind: TAfDispEventKind);
    procedure DoWriteStreamBlock;
    procedure DoWriteStreamDone;
    procedure InternalAbortWriteStream;
    procedure InternalWriteData(const Data; Size: Integer);
    procedure Loaded; override;
    procedure NotifyLinks;
    procedure RemoveLink(Link: TAfDataDispatcherLink);
    procedure SafeSyncEvent(ID: TAfSyncSlotID);
    procedure SignalEvent(EventKind: TAfDispEventKind);
    procedure WriteStreamBlock;
    property BufferSize: Integer read FBufferSize write FBufferSize default 16384;
    property DataProvider: TAfDataDispConnComponent read FDataProvider write SetDataProvider;
    property StreamBlockSize: Integer read FStreamBlockSize write FStreamBlockSize default 1024;
    property OnDataReceived: TNotifyEvent read FOnDataReceived write FOnDataReceived;
    property OnLineReceived: TAfDispLineEvent read FOnLineReceived write FOnLineReceived;
    property OnProviderClose: TNotifyEvent read FOnProviderClose write FOnProviderClose;
    property OnProviderOpen: TNotifyEvent read FOnProviderOpen write FOnProviderOpen;
    property OnWriteBufFree: TNotifyEvent read FOnWriteBufFree write FOnWriteBufFree;
    property OnWriteStreamBlock: TAfDispStreamEvent read FOnWriteStreamBlock write FOnWriteStreamBlock;
    property OnWriteStreamDone: TNotifyEvent read FOnWriteStreamDone write FOnWriteStreamDone;
    property OnWriteToDevice: TAfDispWriteToEvent read FOnWriteToDevice write FOnWriteToDevice;
  public
    procedure AbortWriteStream;
    function BufFree: Integer;
    function BufUsed: Integer;
    procedure Clear;
    procedure ClearBuffer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Dispatcher_WriteBufFree;
    procedure Dispatcher_WriteTo(const Data; Size: Integer);
    function ReadChar: Char;
    procedure ReadData(var Buf; Size: Integer);
    function ReadString: String;
    procedure WriteChar(C: Char);
    procedure WriteData(const Data; Size: Integer);
    procedure WriteString(const S: String);
    procedure WriteStream(Stream: TStream; FreeAtferWrite: Boolean);
    property LinksList: TList read FLinksList;
    property ReceivedBytes: Integer read FReceivedBytes;
    property SentBytes: Integer read FSentBytes;
    property StreamWriting: Boolean read FStreamWriting;
  end;

  TAfDataDispatcher = class(TAfCustomDataDispatcher)
  public
    property OnWriteToDevice;
  published
    property BufferSize;
    property DataProvider;
    property StreamBlockSize;
    property OnDataReceived;
    property OnLineReceived;
    property OnProviderClose;
    property OnProviderOpen;
    property OnWriteStreamBlock;
    property OnWriteStreamDone;
    property OnWriteBufFree;
  end;

implementation

resourcestring
  sDispWriteError = 'Dispatcher Write Error';
  sNotifying = 'Can''t perform this operation when dispatcher is notifying links';
  sReadError = 'Error reading from dispatcher buffer';
  sWriteError = 'Error writing to dispatcher buffer';
  sWriteIsNotAllowed = 'Write is not allowed when writing Stream is in progress';
  sWriteStreamInProgress = 'Write stream operation isn''t completed yet';

{ TAfDataDispConnComponent }

procedure TAfDataDispConnComponent.Close;
begin
  if Assigned(FDispatcher) then FDispatcher.DataProviderClose;
end;

destructor TAfDataDispConnComponent.Destroy;
begin
  if Assigned(FDispatcher) then FDispatcher.SetDataProvider(nil);
  inherited Destroy;
end;

procedure TAfDataDispConnComponent.Open;
begin
  if Assigned(FDispatcher) then FDispatcher.DataProviderOpen;
end;

{ TAfDataDispatcherLink }

constructor TAfDataDispatcherLink.Create;
begin
  inherited Create;
end;

destructor TAfDataDispatcherLink.Destroy;
begin
  SetDispatcher(nil);
  inherited Destroy;
end;

procedure TAfDataDispatcherLink.Notify(EventKind: TAfDispEventKind);
begin
  if Assigned(FOnNotify) then FOnNotify(FDispatcher, EventKind);
end;

procedure TAfDataDispatcherLink.SetDispatcher(const Value: TAfCustomDataDispatcher);
begin
  if FDispatcher <> Value then
  begin
    if (FDispatcher <> nil) then FDispatcher.RemoveLink(Self);
    if (Value <> nil) then Value.AddLink(Self);
    FDispatcher := Value;
  end;
end;

{ TAfCustomDataDispatcher }

procedure TAfCustomDataDispatcher.AbortWriteStream;
begin
  InternalAbortWriteStream;
  DoWriteStreamDone;
end;

procedure TAfCustomDataDispatcher.AddLink(Link: TAfDataDispatcherLink);
begin
  if FLinksList <> nil then FLinksList.Add(Link);
end;

function TAfCustomDataDispatcher.BufFree: Integer;
begin
  Result := FDispatchBuffer.BufFree;
end;

function TAfCustomDataDispatcher.BufUsed: Integer;
begin
  Result := FDispatchBuffer.BufUsed;
end;

procedure TAfCustomDataDispatcher.CheckNewLines;
begin

end;

procedure TAfCustomDataDispatcher.Clear;
begin
  SignalEvent(deClear);
end;

procedure TAfCustomDataDispatcher.ClearBuffer;
begin
  if FNotifying then
    raise EAfDispatcherError.Create(sNotifying);
  FDispatchBuffer.Clear;
  FReceivedBytes := 0;
  FSentBytes := 0;
end;

constructor TAfCustomDataDispatcher.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBufferSize := 16384;
  FDispEvents := [];
  FStreamBlockSize := 1024;
  FLinksList := TList.Create;
  if not (csDesigning in ComponentState) then
  begin
    ZeroMemory(@CritSect, Sizeof(CritSect));
    InitializeCriticalSection(CritSect);
    FSyncID := AfNewSyncSlot(SafeSyncEvent);
  end;
end;

procedure TAfCustomDataDispatcher.DataProviderClose;
begin
  FDataProviderActive := False;
  InternalAbortWriteStream;
  if Assigned(FOnProviderClose) then FOnProviderClose(Self);
end;

procedure TAfCustomDataDispatcher.DataProviderOpen;
begin
  if Assigned(FOnProviderOpen) then FOnProviderOpen(Self);
end;

destructor TAfCustomDataDispatcher.Destroy;
begin
  FDispEvents := [];
  SetDataProvider(nil);
  if not (csDesigning in ComponentState) then
  begin
    InternalAbortWriteStream;
    AfReleaseSyncSlot(FSyncID);
    DeleteCriticalSection(CritSect);
  end;
  FDispatchBuffer.Free;
  FLinksList.Free;
  inherited Destroy;
end;

procedure TAfCustomDataDispatcher.Dispatcher_WriteBufFree;
begin
  EnterCriticalSection(CritSect);
  try
    SignalEvent(deWriteBufFree);
  finally
    LeaveCriticalSection(CritSect);
  end;
end;

procedure TAfCustomDataDispatcher.Dispatcher_WriteTo(const Data; Size: Integer);
var
  Res: Boolean;
begin
  if Size > 0 then
  begin
    EnterCriticalSection(CritSect);
    Res := FDispatchBuffer.Write(Data, Size);
    if Res then Inc(FReceivedBytes, Size);
    LeaveCriticalSection(CritSect);
    if Res then
      SignalEvent(deData)
    else
      raise EAfDispatcherError.Create(sWriteError);
  end;
end;

procedure TAfCustomDataDispatcher.DoEvents(EventKind: TAfDispEventKind);
begin
  case EventKind of
    deData:
      if Assigned(FOnDataReceived) then FOnDataReceived(Self);
    deWriteBufFree:
      if FStreamWriting then
        WriteStreamBlock
      else
        if Assigned(FOnWriteBufFree) then FOnWriteBufFree(Self);
  end;
end;

procedure TAfCustomDataDispatcher.DoWriteStreamBlock;
begin
  if Assigned(FOnWriteStreamBlock) then
    with FStream do FOnWriteStreamBlock(Self, Position, Size);
end;

procedure TAfCustomDataDispatcher.DoWriteStreamDone;
begin
  if Assigned(FOnWriteStreamDone) then FOnWriteStreamDone(Self);
end;

procedure TAfCustomDataDispatcher.InternalAbortWriteStream;
begin
  if FStreamWriting then
  begin
    if FStreamFreeAfterWrite then FStream.Free;
    FStreamWriting := False;
  end;
end;

procedure TAfCustomDataDispatcher.InternalWriteData(const Data; Size: Integer);
begin
  if Assigned(FDataProvider) then
    FDataProvider.WriteData(Data, Size)
  else
    if Assigned(FOnWriteToDevice) then FOnWriteToDevice(Self, Data, Size);
  Inc(FSentBytes, Size);
end;

procedure TAfCustomDataDispatcher.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
  begin
    FDispatchBuffer := TAfCircularBuffer.Create(FBufferSize);
    AfEnableSyncSlot(FSyncID, True);
  end;
end;

procedure TAfCustomDataDispatcher.NotifyLinks;
var
  I: Integer;
  CurrentDispEvents: TAfDispEventKinds;
  CurrentEvent: TAfDispEventKind;
begin
  if FNotifying then Exit;
  FNotifying := True;
  FLinkListChanged := False;
  FDataProviderActive := True;
  EnterCriticalSection(CritSect);
  CurrentDispEvents := FDispEvents;
  LeaveCriticalSection(CritSect);
  while CurrentDispEvents <> [] do
  begin
    for CurrentEvent := Low(CurrentEvent) to High(CurrentEvent) do
      if CurrentEvent in CurrentDispEvents then
      begin
        FMaxReadBytes := 0;
        Sync_Event := CurrentEvent;
        with FLinksList do
          for I := -1 to Count - 1 do
          begin
            if I = -1 then case CurrentEvent of // skip non used OnXXX sync events
              deData:
                if not Assigned(FOnDataReceived) then Continue;
              deWriteBufFree:
                if not Assigned(FOnWriteBufFree) and not FStreamWriting then Continue;
              deClear:
                Continue;
            end;
            Sync_ListIndex := I;
            if not AfSyncEvent(FSyncID, AfSynchronizeTimeout) then
              Abort; // object was destroyed during sync event, get out from here
            if not FDataProviderActive then
            begin
              FNotifying := False;
              Exit;
            end;
          end;
        FDispatchBuffer.Remove(FMaxReadBytes);
      end;
    EnterCriticalSection(CritSect);
    FDispEvents := FDispEvents - CurrentDispEvents;
    CurrentDispEvents := FDispEvents;
    LeaveCriticalSection(CritSect);
  end;
  if FLinkListChanged then FLinksList.Pack;
  FNotifying := False;
  FLinkListChanged := False;
end;

function TAfCustomDataDispatcher.ReadChar: Char;
begin
  ReadData(Result, 1);
end;

procedure TAfCustomDataDispatcher.ReadData(var Buf; Size: Integer);
var
  Res: Boolean;
begin
  EnterCriticalSection(CritSect);
  if FNotifying then
  begin
    Res := FDispatchBuffer.Peek(Buf, Size);
    if Res and (Size > FMaxReadBytes) then FMaxReadBytes := Size;
  end else
    Res := FDispatchBuffer.Read(Buf, Size);
  LeaveCriticalSection(CritSect);
  if not Res then raise EAfDispatcherError.Create(sReadError);
end;

function TAfCustomDataDispatcher.ReadString: String;
var
  Size: Integer;
begin
  Size := FDispatchBuffer.BufUsed;
  SetLength(Result, Size);
  ReadData(Pointer(Result)^, Size);
end;

procedure TAfCustomDataDispatcher.RemoveLink(Link: TAfDataDispatcherLink);
var
  I: Integer;
begin
  if FLinksList <> nil then
    with FLinksList do
      if FNotifying then
      begin
        I := IndexOf(Link);
        if I >=0 then Items[I] := nil;
        FLinkListChanged := True;
      end else
        Remove(Link);
end;

procedure TAfCustomDataDispatcher.SafeSyncEvent(ID: TAfSyncSlotID);
begin
  if csDestroying in ComponentState then Exit;
  if Sync_ListIndex = -1 then
    DoEvents(Sync_Event)
  else if FLinksList[Sync_ListIndex] <> nil then
    TAfDataDispatcherLink(FLinksList[Sync_ListIndex]).Notify(Sync_Event);
end;

procedure TAfCustomDataDispatcher.SetDataProvider(const Value: TAfDataDispConnComponent);
begin
  if FDataProvider <> Value then
  begin
    DataProviderClose;
    if FDataProvider <> nil then FDataProvider.FDispatcher := nil;
    if Value <> nil then Value.FDispatcher := Self;
    FDataProvider := Value;
  end;
end;

procedure TAfCustomDataDispatcher.SignalEvent(EventKind: TAfDispEventKind);
begin
  EnterCriticalSection(CritSect);
  Include(FDispEvents, EventKind);
  LeaveCriticalSection(CritSect);
  NotifyLinks;
end;

procedure TAfCustomDataDispatcher.WriteChar(C: Char);
begin
  WriteData(C, 1);
end;

procedure TAfCustomDataDispatcher.WriteData(const Data; Size: Integer);
begin
  if FStreamWriting then raise EAfDispatcherError.Create(sWriteIsNotAllowed);
  InternalWriteData(Data, Size);
end;

procedure TAfCustomDataDispatcher.WriteStream(Stream: TStream; FreeAtferWrite: Boolean);
begin
  if FStreamWriting then
    raise EAfDispatcherError.Create(sWriteStreamInProgress);
  FStream := Stream;
  FStreamFreeAfterWrite := FreeAtferWrite;
  FStream.Position := 0;
  FStreamWriting := True;
  WriteStreamBlock;
end;

procedure TAfCustomDataDispatcher.WriteStreamBlock;
var
  SendSize: Integer;
  P: Pointer;
begin
  SendSize := FStream.Size - FStream.Position;
  if SendSize > FStreamBlockSize then SendSize := FStreamBlockSize;
  if SendSize = 0 then
  begin
    InternalAbortWriteStream;
    DoWriteStreamDone;
  end else
  begin
    GetMem(P, SendSize);
    try
      try
        FStream.ReadBuffer(P^, SendSize);
        InternalWriteData(P^, SendSize);
        DoWriteStreamBlock;
      except
        InternalAbortWriteStream;
        raise;
      end;
    finally
      FreeMem(P);
    end;
  end;
end;

procedure TAfCustomDataDispatcher.WriteString(const S: String);
begin
  if Length(S) > 0 then WriteData(Pointer(S)^, Length(S));
end;

end.
