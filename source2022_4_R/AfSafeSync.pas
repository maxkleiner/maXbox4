{==============================================================================|
| Project : Delphree - AsyncFree                                 | 001.004.000 |
|==============================================================================|
| Content:  Safe synchronization with main VCL thread                          |
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

unit AfSafeSync;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms;

const
  AfMaxSyncSlots = 64;
  AfSynchronizeTimeout = 2000;

type
  TAfSyncSlotID = DWORD;

  TAfSyncStatistics = record
    MessagesCount: Integer;
    TimeoutMessages: Integer;
    DisabledMessages: Integer;
  end;

  TAfSafeSyncEvent = procedure(ID: TAfSyncSlotID) of object;
  TAfSafeDirectSyncEvent = procedure of object;

function AfNewSyncSlot(const AEvent: TAfSafeSyncEvent): TAfSyncSlotID;
 // Allocates new synchronize handler and returns its unique ID

function AfReleaseSyncSlot(const ID: TAfSyncSlotID): Boolean;
 // Releases specified synchronize handler

function AfEnableSyncSlot(const ID: TAfSyncSlotID; Enable: Boolean): Boolean;
 // Enables specified (existing) synchronize handler

function AfValidateSyncSlot(const ID: TAfSyncSlotID): Boolean;
 // Validates specified synchronize handler ID

function AfSyncEvent(const ID: TAfSyncSlotID; Timeout: DWORD): Boolean;
 // Causes specified synchronized event

function AfDirectSyncEvent(Event: TAfSafeDirectSyncEvent; Timeout: DWORD): Boolean;
 // Do not use in applications

function AfIsSyncMethod: Boolean;
 // Indicates whether synchronized method is being processed

function AfSyncWnd: HWnd;
 // Returns HWND of synchronize window

function AfSyncStatistics: TAfSyncStatistics;
 // Returns statistics

procedure AfClearSyncStatistics;
 // Clears statistics

implementation

const
  UM_DIRECTSYNCMESSAGE = WM_USER + $100;
  UM_SYNCMESSAGE = WM_USER + $101;
  UM_RELEASEWINDOW = WM_USER + $102;

type
  TAfSafeSyncRec = packed record
    Enabled: Boolean;
    Sending: Boolean;
    Event: TAfSafeSyncEvent;
    UniqueID: TAfSyncSlotID;
  end;

  PAfSafeSyncSlots = ^TAfSafeSyncSlots;
  TAfSafeSyncSlots = array[1..AfMaxSyncSlots] of TAfSafeSyncRec;

var
  SyncMutex: THandle;
  HandlerAllocated: Boolean = False;
  SyncSlotCount: Integer = 0;
  SyncWnd: HWND = 0;
  SyncSlots: PAfSafeSyncSlots = nil;
  SyncStatistics: TAfSyncStatistics;
//  SynchronizeException: TObject;
  UniqueIDGenerator: DWORD;
  IsSyncMethod: Boolean;

function GetNewUniqueID: DWORD;
begin
  Inc(UniqueIDGenerator);
  if UniqueIDGenerator = 0 then Inc(UniqueIDGenerator);
  Result := UniqueIDGenerator;
end;

procedure ReleaseSyncHandler;
begin
  if HandlerAllocated then
  begin
    HandlerAllocated := False;
    DestroyWindow(SyncWnd);
    FreeMem(SyncSlots);
  end;
end;

function SafeSyncWndProc(Wnd: HWnd; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  ID: TAfSyncSlotID;
  Method: TAfSafeDirectSyncEvent;
  I: Integer;
begin
  case Msg of
    UM_RELEASEWINDOW:
      begin
        ReleaseSyncHandler;
        Result := 0;
      end;
    UM_DIRECTSYNCMESSAGE:
      begin
        Result := 0;
        TMethod(Method).Code := Pointer(wParam);
        TMethod(Method).Data := Pointer(lParam);
        if not IsBadCodePtr(TMethod(Method).Code) then Method;
      end;
    UM_SYNCMESSAGE:
      begin
        Result := 0;
        WaitForSingleObject(SyncMutex, INFINITE);
        if HandlerAllocated then
        begin
          ID := 0;
          for I := 1 to AfMaxSyncSlots do
            if SyncSlots^[I].UniqueID = TAfSyncSlotID(lParam) then
            begin
              ID := I;
              Break;
            end;
          if ID > 0 then
          with SyncSlots^[ID] do
          begin
            if Enabled and Assigned(Event) then
            begin
              ReleaseMutex(SyncMutex);
              try
//                SynchronizeException := nil;
                IsSyncMethod := True;
                Event(ID);
                IsSyncMethod := False;
              except
                IsSyncMethod := False;
                if GetCurrentThreadId = MainThreadID then
                  Application.HandleException(nil); // It should be MainThread here
{                else
                if RaiseList <> nil then
                begin
                  SynchronizeException := PRaiseFrame(RaiseList)^.ExceptObject;
                  PRaiseFrame(RaiseList)^.ExceptObject := nil;
                end;}
              end;
            end else
              ReleaseMutex(SyncMutex);
          end else
          begin
            Inc(SyncStatistics.DisabledMessages);
            ReleaseMutex(SyncMutex);
          end;
        end else
          ReleaseMutex(SyncMutex);
      end;
  else
    Result := DefWindowProc(Wnd, Msg, wParam, lParam);
  end;
end;

var
  SyncWindowClass: TWndClass = (
    style: 0;
    lpfnWndProc: @SafeSyncWndProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'AfSafeSyncObjWnd');

function AllocateSyncHandler: Boolean;
var
  QueryClass: TWndClass;
  Registred: Boolean;
begin
  Result := True;
  if HandlerAllocated then Exit;
  SyncWindowClass.hInstance := HInstance;
  Registred := GetClassInfo(HInstance, SyncWindowClass.lpszClassName, QueryClass);
  if (not Registred) or (QueryClass.lpfnWndProc <> SyncWindowClass.lpfnWndProc) then
  begin
    if Registred then Windows.UnregisterClass(SyncWindowClass.lpszClassName, HInstance);
    Windows.RegisterClass(SyncWindowClass);
  end;
  SyncWnd := CreateWindowEx(WS_EX_TOOLWINDOW, SyncWindowClass.lpszClassName,
    nil, WS_POPUP, 0, 0, 0, 0, 0, 0, HInstance, nil);
  Result := SyncWnd <> 0;
  New(SyncSlots);
  ZeroMemory(SyncSlots, Sizeof(SyncSlots^));
  ZeroMemory(@SyncStatistics, Sizeof(SyncStatistics));
  HandlerAllocated := True;
end;

function FindFreeSlot: Integer;
var
  I: Integer;
begin
  Result := 0;
  if not HandlerAllocated then Exit;
  for I := 1 to AfMaxSyncSlots do
    if not Assigned(SyncSlots^[I].Event) then
    begin
      Result := I;
      Break;
    end;
end;

function FindSlotFromID(const ID: TAfSyncSlotID): Integer;
var
  I: Integer;
begin
  Result := 0;
  if HandlerAllocated then 
  for I := 1 to AfMaxSyncSlots do
    with SyncSlots^[I] do
      if UniqueID = ID then
      begin
        Result := I;
        Break;
      end;
end;

function AfNewSyncSlot(const AEvent: TAfSafeSyncEvent): TAfSyncSlotID;
var
  Slot: Integer;
begin
  WaitForSingleObject(SyncMutex, INFINITE);
  AllocateSyncHandler;
  Result := 0;
  Slot := FindFreeSlot;
  if Slot > 0 then
    with SyncSlots^[Slot] do
    begin
      Enabled := False;
      Event := AEvent;
      UniqueID := GetNewUniqueID;
      Inc(SyncSlotCount);
      Result := UniqueID;
    end;
  ReleaseMutex(SyncMutex);
end;

function AfReleaseSyncSlot(const ID: TAfSyncSlotID): Boolean;
var
  Slot: Integer;
begin
  WaitForSingleObject(SyncMutex, INFINITE);
  Result := False;
  Slot := FindSlotFromID(ID);
  if Slot > 0 then
    with SyncSlots^[Slot] do
      if UniqueID > 0 then
      begin
        Event := nil;
        UniqueID := 0;
        Dec(SyncSlotCount);
        Result := True;
        ReleaseMutex(SyncMutex);
//        if SyncSlotCount = 0 then PostMessage(SyncWnd, UM_RELEASEWINDOW, 0, 0);
      end;
  ReleaseMutex(SyncMutex);
end;

function AfEnableSyncSlot(const ID: TAfSyncSlotID; Enable: Boolean): Boolean;
var
  Slot: Integer;
begin
  WaitForSingleObject(SyncMutex, INFINITE);
  Result := False;
  Slot := FindSlotFromID(ID);
  if Slot > 0 then
    with SyncSlots^[Slot] do
      if Assigned(Event) then
      begin
        Enabled := Enable;
        Result := True;
      end;
  ReleaseMutex(SyncMutex);
end;

function AfValidateSyncSlot(const ID: TAfSyncSlotID): Boolean;
var
  Slot: Integer;
begin
  WaitForSingleObject(SyncMutex, INFINITE);
  Result := False;
  Slot := FindSlotFromID(ID);
  if Slot > 0 then
    with SyncSlots^[Slot] do
      Result := Assigned(Event) and Enabled;
  ReleaseMutex(SyncMutex);
end;

function AfSyncEvent(const ID: TAfSyncSlotID; Timeout: DWORD): Boolean;
var
  Res: DWORD;
  Slot: Integer;
begin
  WaitForSingleObject(SyncMutex, INFINITE);
//  SynchronizeException := nil;
  Result := False;
  Slot := FindSlotFromID(ID);
  if Slot > 0 then
    with SyncSlots^[Slot] do
      if Assigned(Event) and Enabled then
      begin
        Inc(SyncStatistics.MessagesCount);
        ReleaseMutex(SyncMutex);
        Result := SendMessageTimeout(SyncWnd, UM_SYNCMESSAGE, 0, UniqueID,
          SMTO_ABORTIFHUNG or SMTO_BLOCK, Timeout, Res) <> 0;
        WaitForSingleObject(SyncMutex, INFINITE);
        if not Result then Inc(SyncStatistics.TimeoutMessages);
        Result := HandlerAllocated and Assigned(Event) and Enabled; // checks destroying
      end;
  ReleaseMutex(SyncMutex);
//  if Assigned(SynchronizeException) then raise SynchronizeException;
end;

function AfDirectSyncEvent(Event: TAfSafeDirectSyncEvent; Timeout: DWORD): Boolean;
var
  Res: DWORD;
begin
  WaitForSingleObject(SyncMutex, INFINITE);
  Result := False;
  if HandlerAllocated then
  begin
    Inc(SyncStatistics.MessagesCount);
    ReleaseMutex(SyncMutex);
    Result := SendMessageTimeout(SyncWnd, UM_DIRECTSYNCMESSAGE, Longint(TMethod(Event).Code),
      Longint(TMethod(Event).Data), SMTO_ABORTIFHUNG or SMTO_BLOCK, Timeout, Res) <> 0;
  end else
    ReleaseMutex(SyncMutex);
end;

function AfIsSyncMethod: Boolean;
begin
  Result := IsSyncMethod;
end;  

function AfSyncWnd: HWnd;
begin
  Result := SyncWnd;
end;

function AfSyncStatistics: TAfSyncStatistics;
begin
  Result := SyncStatistics;
end;

procedure AfClearSyncStatistics;
begin
  WaitForSingleObject(SyncMutex, INFINITE);
  ZeroMemory(@SyncStatistics, Sizeof(SyncStatistics));
  ReleaseMutex(SyncMutex);
end;

initialization
  SyncMutex := CreateMutex(nil, False, nil);
  UniqueIDGenerator := 0;
finalization
  ReleaseSyncHandler;
end.


