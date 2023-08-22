//----code_cleared_checked----
unit ParallelJobs;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

{***************************************************************************
* ParallelJobs Library
*@module ParallelJobs
*@version 2012.0.2.01
*@author Gilberto Saraiva - http://projects.pro.br/
*@copyright Copyright © 2012, Gilberto Saraiva
*@homepage http://code.google.com/p/paralleljobs/
*
* License: MPL 1.1
* http://www.mozilla.org/MPL/MPL-1.1.html
*
***************************************************************************
*
* The contents of this file are subject to the Mozilla Public License
* Version 1.1 (the "License"); you may not use this file except in
* compliance with the License. You may obtain a copy of the License at
* http://www.mozilla.org/MPL/
*
* Software distributed under the License is distributed on an "AS IS"
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
* License for the specific language governing rights and limitations
* under the License.
*
* The Original Code is ParallelJobs.pas, released: 04 july 2008.
*
* The Initial Developer of the Original Code is Gilberto Saraiva.
* Portions created by Gilberto Saraiva are Copyright (C) 2011 -
* Gilberto Saraiva. All Rights Reserved.
*
* Contributor(s): .
*
* Alternatively, the contents of this file may be used under the terms of the
* GNU General Public License Version 2 or later (the "GPL"), in which case
* the provisions of the GPL are applicable instead of those above.
* If you wish to allow use of your version of this file only under the terms
* of the GPL and not to allow others to use your version of this file
* under the MPL, indicate your decision by deleting the provisions above and
* replace them with the notice and other provisions required by the GPL.
* If you do not delete the provisions above, a recipient may use your version
* of this file under either the MPL or the GPL.
*
***************************************************************************
*
* You may retrieve the latest version of this file at the DevPartners Forum,
* located at http://code.google.com/p/paralleljobs/
*
***************************************************************************}

interface

{$A1}

uses Windows;

type
TWaitProcessNotify = procedure of object;

{ Note: Jobs states for group control
}
TJobState = (jgsRunning, jgsStopped);

{ Note: Job Item holder
Holds ParallelJobs as chained list
}
PJobItem = ^TJobItem;
TJobItem = record
Job : Pointer;
prev : PJobItem;
next : PJobItem;
end;

{ Note: JobsGroup
Provide a control for all jobs on the group
}
PJobsGroup = ^TJobsGroup;
TJobsGroup = class
private
FName : string;
FLastGroup : TJobsGroup;
FFirstJob : PJobItem;
FLastJob : PJobItem;
FJobsCount : integer;
FJobsHandles : TWOHandleArray;
FLock : boolean;
procedure AddJob(AJob: Pointer);
procedure DelJob(AJob: Pointer; AInternalEnd: boolean = false);
function GetJobItem(index: integer): PJobItem;
protected
procedure UpdateHandles;
procedure Lock;
procedure Unlock;
public
constructor Create(AName: string);
destructor Destroy; override;
procedure Clear;

procedure InitJobCapture;
procedure EndJobCapture;

function StartJobs: integer;
function StopJobs(AWaitNotify: TWaitProcessNotify = nil; AForce: boolean = false): integer;

function JobsCount: integer;
function JobsIsRunning: Integer;
function WaitForJobs(AWaitAll: boolean; AMilliseconds: DWORD): DWORD;

procedure RemoveJob(AIndex: integer);

property Jobs[index: integer]: PJobItem read GetJobItem;
property Name: string read FName;
end;

TParallelJob = class;

TParallelJobInfo = class
private
FHolder: Pointer;
FJob: TParallelJob;
public
function Id: DWORD;
function Handle: THandle;
function Terminated: boolean;
function Job: TParallelJob;
end;

TParallelJobSemaphore = class
private
FEvent: THandle;
public
constructor Create; overload;
constructor Create(AManualReset: boolean); overload;
constructor Create(AName: string; AManualReset: boolean); overload;
constructor Create(AName: string; AManualReset, AInitialState: boolean;
ASecurityAttributes: PSecurityAttributes); overload;
destructor Destroy; override;

function WaitEvent(ATimeout: DWORD): integer; overload; virtual;
function WaitEvent: integer; overload; virtual;

procedure SetEvent; virtual;
procedure Reset; virtual;
end;

TParallelJobLocker = class
private
FCS: TRTLCriticalSection;
FLock: boolean;
public
constructor Create;
procedure Lock; virtual;
procedure Unlock; virtual;
end;

TParallelJob = class
private
FHolder: Pointer;
FSelf: TObject;
FTarget: Pointer;
FParam: Pointer;
FSafeSection: boolean;
FStarted: boolean;
FEnded: boolean;
FLocker: TParallelJobLocker;

function GetPriority: Integer;
procedure SetPriority(const Value: Integer);
function GetInfo: TParallelJobInfo;
protected
procedure InitJob; virtual;
procedure OnEndJob(AParallelJobHandle: THandle); virtual;

function GetLocker: TParallelJobLocker; virtual;
procedure SetLocker(const Value: TParallelJobLocker); virtual;
public
{ Note: Basic use of ParallelJobs structure
* SelfMode operation
@ASelf = Object that contain the target
@ATarget = The target to be called when job run
@AParam = The pointer that will be pass as param to target
@ASafeSection = Auto safe section control managed by ParallelJobs.
}
constructor Create(ASelf: TObject; ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false); overload;

{ Note: Basic use of ParallelJobs structure
* Direct operation
@ATarget = The target to be called when job run
@AParam = The pointer that will be pass as param to target
@ASafeSection = Auto safe section control managed by ParallelJobs.
}
constructor Create(ATarget: Pointer; AParam: Pointer = nil;
ASafeSection: boolean = false); overload;

destructor Destroy; override;

{ Note: Start the Current ParallelJob
}
procedure Start; overload; virtual;

{ Note: Overwrite the Param and Start the Current ParallelJob
@AParam = The pointer that will be pass as param to target
}
procedure Start(AParam: Pointer); overload; virtual;

{ Note: Pause the Current ParallelJob at kernel level
}
procedure Pause; virtual;

{ Note: Stop the Current ParallelJob with a possibility of wait to finish
@AWaitFinish = If true, wait until ParallelJob finish.
}
procedure Stop(AWaitFinish: Boolean = true); virtual;

{ Note: Current ParallelJob is finished.
}
function IsDone: boolean; virtual;

{ Note: Wait the Current ParallelJob to finish.
@ATimeout = A value as a timeout to waiting the finish.
}
function WaitForEnd(ATimeout: DWORD): integer; overload; virtual;

{ Note: Wait the Current ParallelJob to finish (INFINITE mode).
}
function WaitForEnd: integer; overload; virtual;

property Priority: Integer read GetPriority write SetPriority;
property Locker: TParallelJobLocker read GetLocker write SetLocker;
property Info: TParallelJobInfo read GetInfo;

class function ParallelJobsCount: integer;
class procedure TerminateAllParallelJobs(AForce: boolean = false);
class procedure WaitAllParallelJobsFinalization(AWaitNotify: TWaitProcessNotify = nil);
end;

{ Note: Basic use of ParallelJobs structure
* SelfMode operation
@ASelf = Object that contain the target
@ATarget = The target to be called when job run
@AParam = The pointer that will be pass as param to target
@ASafeSection = Auto safe section control managed by ParallelJobs.
}
procedure ParallelJob(ASelf: TObject; ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false); overload;

{ Note: Basic use of ParallelJobs structure
* Direct operation
@ATarget = The target to be called when job run
@AParam = The pointer that will be pass as param to target
@ASafeSection = Auto safe section control managed by ParallelJobs.
}
procedure ParallelJob(ATarget: Pointer; AParam: Pointer = nil;
ASafeSection: boolean = false); overload;

{ Note: Basic use of ParallelJobs structure with JobGroup
* SelfMode operation with JobGroup
@AJobGroup = JobGroup reference
@ASelf = Object that contain the target
@ATarget = The target to be called when job run
@AParam = The pointer that will be pass as param to target
@ASafeSection = Auto safe section control managed by ParallelJobs.
}
procedure ParallelJob(AJobGroup: TJobsGroup; ASelf: TObject; ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false); overload;

{ Note: Basic use of ParallelJobs structure with JobGroup
* Direct operation with JobGroup
@AJobGroup = JobGroup reference
@ATarget = The target to be called when job run
@AParam = The pointer that will be pass as param to target
@ASafeSection = Auto safe section control managed by ParallelJobs.
}
procedure ParallelJob(AJobGroup: TJobsGroup; ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false); overload;

{ Note: Basic use of ParallelJobs structure with TParallelJob Object
* SelfMode operation
@ASelf = Object that contain the target
@ATarget = The target to be called when job run
@AParam = The pointer that will be pass as param to target
@ASafeSection = Auto safe section control managed by ParallelJobs.
}
function CreateParallelJob(ASelf: TObject; ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false): TParallelJob; overload;

{ Note: Basic use of ParallelJobs structure with TParallelJob Object
* Direct operation
@ATarget = The target to be called when job run
@AParam = The pointer that will be pass as param to target
@ASafeSection = Auto safe section control managed by ParallelJobs.
}
function CreateParallelJob(ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false): TParallelJob; overload;

{ Note: Return the ParallelJob informations
Can be called anytime inside the Job code, slow then ObtainParallelJobInfo
}
function CurrentParallelJobInfo: TParallelJobInfo;

{ Note: Return the ParallelJob informations
Can be called only after the first begin of the job
}
function ObtainParallelJobInfo: TParallelJobInfo;

implementation

type
{ Note: This thunk provide a link to SelfMode
}
PJobsThunk = ^TJobsThunk;
TJobsThunk = packed record
a : Byte;
aV : Pointer;
b : Byte;
bV : Pointer;
c : Byte;
cV : Integer;
end;

TChainedListNavigator = array [0..2] of Pointer;

TChainedList = class
private
FNav: TChainedListNavigator;
FLock: TParallelJobLocker;

FCount: Integer;
function GetCurrent: PPointer;

procedure InternalFirst;
procedure InternalLast;
procedure InternalPrior;
procedure InternalNext;
procedure InternalAdd;
procedure InternalRemove;
public
constructor Create;
destructor Destroy; override;

function First : TChainedList;
function Last : TChainedList;
function Prior : TChainedList;
function Next : TChainedList;

function Add: TChainedList;
function Remove: TChainedList;

function GetCurrentItem: Pointer;
function SetCurrentItem(const Item: PPointer): TChainedList;

property Current: PPointer read GetCurrent;
property Count: Integer read FCount;
property Locker: TParallelJobLocker read FLock;
end;

PChainedItem = ^TChainedItem;
TChainedItem = record
Prior, Next: PChainedItem;
Data: Pointer;
end;

{$IFDEF FPC}
function SwitchToThread: BOOL; stdcall; external kernel32 name 'SwitchToThread';
{$ENDIF}

{ TChainedList }

constructor TChainedList.Create;
begin
FCount := 0;
FNav[0] := nil;
FNav[1] := nil;
FNav[2] := nil;

FLock := TParallelJobLocker.Create;
end;

destructor TChainedList.Destroy;
begin
First;
while Current <> nil do
Remove;

FLock.Free;

inherited;
end;

function TChainedList.GetCurrentItem: Pointer;
begin
Result := FNav[2];
end;

function TChainedList.SetCurrentItem(const Item: PPointer): TChainedList;
begin
FNav[2] := Item;
Result := Self;
end;

function TChainedList.GetCurrent: PPointer;
begin
if FNav[2] <> nil then
Result := @PChainedItem(FNav[2]).Data
else
Result := nil;
end;

procedure TChainedList.InternalFirst;
begin
FNav[2] := FNav[0];
end;

procedure TChainedList.InternalLast;
begin
FNav[2] := FNav[1];
end;

procedure TChainedList.InternalNext;
begin
if FNav[2] <> nil then
FNav[2] := PChainedItem(FNav[2])^.Next
else
FNav[2] := nil;
end;

procedure TChainedList.InternalPrior;
begin
if FNav[2] <> nil then
FNav[2] := PChainedItem(FNav[2])^.Prior
else
FNav[2] := nil;
end;

function TChainedList.First: TChainedList;
begin
InternalFirst;
Result := Self;
end;

function TChainedList.Last: TChainedList;
begin
InternalLast;
Result := Self;
end;

function TChainedList.Prior: TChainedList;
begin
InternalPrior;
Result := Self;
end;

function TChainedList.Next: TChainedList;
begin
InternalNext;
Result := Self;
end;

procedure TChainedList.InternalAdd;
var
pNew: PChainedItem;
begin
New(pNew);
pNew^.Prior := nil;
pNew^.Next := nil;
pNew^.Data := nil;

if FNav[0] = nil then
begin
FNav[0] := pNew;
FNav[1] := pNew;
end else
begin
pNew^.Prior := PChainedItem(FNav[1]);
PChainedItem(FNav[1])^.Next := pNew;
FNav[1] := pNew;
end;

FNav[2] := FNav[1];

Inc(FCount);
end;

procedure TChainedList.InternalRemove;
var
pCur: PChainedItem;
begin
pCur := FNav[2];
if pCur = nil then
Exit;

if pCur^.Next <> nil then
pCur^.Next^.Prior := pCur^.Prior;

if pCur^.Prior <> nil then
pCur^.Prior^.Next := pCur^.Next;

if pCur = FNav[0] then
begin
FNav[0] := pCur^.Next;
FNav[2] := FNav[0];
end else if pCur = FNav[1] then
begin
FNav[1] := pCur^.Prior;
FNav[2] := FNav[1];
end else
FNav[2] := pCur^.Next;

Dispose(pCur);
Dec(FCount);
end;

function TChainedList.Add: TChainedList;
begin
InternalAdd;
Result := Self;
end;

function TChainedList.Remove: TChainedList;
begin
InternalRemove;
Result := Self;
end;

{ Note: ReprocessLoop
}
procedure ReprocessLoop;
begin
SwitchToThread;
Sleep(0);
end;

type
{ Note: Safe Section holder type
}
TSafeSectionInfo = record
Self : Pointer;
Target : Pointer;
SafeFlag : Boolean;
RefsCount : Integer;
end;

var
{ Note: Safe Section list
}
SafeSectionInfo: array of TSafeSectionInfo;

{ Note: Get the Safe Section Boolean pointer from the list
}
function SafeSectionInfoFlag(ASelf, ATarget: Pointer): PBoolean;
var
i: integer;
begin
Result := nil;
for i := 0 to High(SafeSectionInfo) do
with SafeSectionInfo[i] do
if (ASelf = Self) and (ATarget = Target) then
begin
if RefsCount = 0 then
SafeFlag := false;
RefsCount := RefsCount + 1;
Result := @SafeFlag;
end;

if Result = nil then
begin
SetLength(SafeSectionInfo, Length(SafeSectionInfo) + 1);
with SafeSectionInfo[High(SafeSectionInfo)] do
begin
Self := ASelf;
Target := ATarget;
SafeFlag := false;
RefsCount := 1;
Result := @SafeFlag;
end;
end;
end;

{ Note: Check Ref to free Safe Section
}
procedure SafeSectionInfoFlagFree(ASelf, ATarget: Pointer);
var
i: integer;
arSSI: array of TSafeSectionInfo;
begin
for i := 0 to High(SafeSectionInfo) do
with SafeSectionInfo[i] do
if (ASelf = Self) and (ATarget = Target) then
RefsCount := RefsCount - 1;

for i := 0 to High(SafeSectionInfo) do
if SafeSectionInfo[i].RefsCount > 0 then
begin
SetLength(arSSI, Length(arSSI) + 1);
arSSI[High(arSSI)] := SafeSectionInfo[i];
end;
SetLength(SafeSectionInfo, Length(arSSI));

for i := 0 to High(arSSI) do
SafeSectionInfo[i] := arSSI[i];
end;

{ Note: basic lock system
Lock bool var
}
procedure LockVar(var AVar: Boolean);
asm
push ebx
mov ebx, eax
jmp @@testInit
@@test:
call SwitchToThread
@@testInit:
push $00
call Sleep
mov ecx, ebx
db $B0,$00,$B2,$01
lock cmpxchg [ecx], dl
test al, al
jnz @@test
pop ebx
ret
end;

{ Note: Unlock bool var
}
procedure UnlockVar(var AVar: Boolean);
asm
mov byte ptr [eax], $00
end;

var
CurrentGroup: TJobsGroup = nil;
GroupHolder: TChainedList;
GroupNameHolder: TChainedList = nil;

{ Note: Setup the thunk.
Specific hardcoded for paralleljobs needs
}
procedure SetupThunk(var AJobThunk: TJobsThunk; ASelf, ATarget, AParam: Pointer);
const
DefThunkPath: array [0..1] of Int64 = (204509162766520, 15269888);
begin
Move(DefThunkPath, AJobThunk, 15);
with AJobThunk do
begin
aV := ASelf;
bV := AParam;
cV := Integer(ATarget) - Integer(@c) - 5;
end;
end;

type
{ Note: Job call mode
SelfMode use a Object with Target
Direct call the Target directly
}
TParallelCallMode = (pcmSelfMode, pcmDirect);

{ Note: Call Terminate state
1 = None
2 = Terminate Requested
3 = Terminated
}
TParallelCallTerminateState = Integer;

TParallelCallNotify = procedure(AParallelHandle: THandle) of object;

PParallelCall = ^TParallelCall;
TParallelCall = packed record
Mode : TParallelCallMode;
Thunk : TJobsThunk;
Call : Pointer;
Param : Pointer;
Hnd : THandle;
ID : DWORD;

Group : TJobsGroup;
GState : TJobState;

SafeSection : Boolean;
SafeFlag : PBoolean;
Terminated : TParallelCallTerminateState;
EndCall : Boolean;
Holder : Pointer;
NotifyEnd : TParallelCallNotify;
Info : TParallelJobInfo;
end;

{ Note: Jobs holder, to provide a base for jobs controls
}
PParallelJobHolder = ^TParallelJobHolder;
TParallelJobHolder = record
prev, next: PParallelJobHolder;
Job: PParallelCall;
end;

TParallelJobHolderList = class(TChainedList)
public
function AddJob(const AJob: PParallelCall): TParallelJobHolderList;
function CurrJob: PParallelCall;
end;

{ TParallelJobHolderList }

function TParallelJobHolderList.AddJob(const AJob: PParallelCall): TParallelJobHolderList;
begin
Add.Current^ := AJob;
Result := Self;
end;

function TParallelJobHolderList.CurrJob: PParallelCall;
begin
if Current <> nil then
Result := PParallelCall(Current^)
else
Result := nil;
end;

var
{ Note:
HolderLock:
for lock manipulation on the list
First and Last:
for control the chained list
Current:
for improve speed on the job and reduce
the search process cost.
}
TerminateNullJob: boolean = false;
ParallelJobHolder: TParallelJobHolderList;

procedure TerminateParallelJob(AParallelJob: PParallelCall;
AForce: boolean = false); forward;

{ Note: Create a Job holder
}
procedure CreateHolder(AParallelJob: PParallelCall);
var
pNew: PParallelJobHolder;
begin
try
ParallelJobHolder.Locker.Lock;
try
AParallelJob^.Holder := ParallelJobHolder.AddJob(AParallelJob).GetCurrentItem;
finally
ParallelJobHolder.Locker.Unlock;
end;
finally
//
end;
end;

{ Note: Destroy the Job holder
}
procedure DestroyHolder(AParallelJob: PParallelCall);
var
pHolder: PParallelJobHolder;
begin
pHolder := AParallelJob^.Holder;
if pHolder <> nil then
begin
TerminateParallelJob(pHolder^.Job);

ParallelJobHolder.Locker.Lock;
try
ParallelJobHolder.SetCurrentItem(Pointer(pHolder)).Remove;
finally
ParallelJobHolder.Locker.Unlock;
end;

AParallelJob^.Holder := nil;
VirtualFree(pHolder^.Job, 0, MEM_RELEASE);
end;
end;

{ Note: Terminate thread
Forced: Suspend the thread, imediatly stop. Can leak memory
Normal: Pass the terminate flag to on and CurrentJobTerminated will
return true.
}
procedure TerminateParallelJob(AParallelJob: PParallelCall;
AForce: boolean = false);
var
hThread: THandle;
begin
hThread := AParallelJob^.Hnd;
if hThread <> 0 then
if AForce then
begin
SuspendThread(hThread);
InterlockedExchange(AParallelJob^.Terminated, 2);
end else
begin
if TerminateNullJob then
AParallelJob^.Hnd := 0;

if AParallelJob^.Terminated = 0 then
begin
InterlockedIncrement(AParallelJob^.Terminated);
if AParallelJob^.GState = jgsStopped then
ResumeThread(hThread);

if TerminateNullJob then
while AParallelJob^.Terminated = 1 do
SwitchToThread;
end;
end;

TerminateNullJob := False;
end;

{ Note: Return the Job holder by ID
}
function GetJobHolderById(AID: DWORD): PParallelJobHolder;
begin
ParallelJobHolder.Locker.Lock;
try
if ParallelJobHolder.CurrJob <> nil then
if ParallelJobHolder.CurrJob^.ID = AID then
begin
Result := Pointer(ParallelJobHolder.GetCurrentItem);
Exit;
end;

ParallelJobHolder.First;
while ParallelJobHolder.CurrJob <> nil do
begin
if ParallelJobHolder.CurrJob^.ID = AID then
begin
Result := Pointer(ParallelJobHolder.GetCurrentItem);
Break;
end;

ParallelJobHolder.Next;
end;
finally
ParallelJobHolder.Locker.Unlock;
end;
end;

{ Note: Forwarding EndParallelJob to ParallelWorker auto free
}
procedure EndParallelJob(AParallelJob: PParallelCall;
AInternalEnd: boolean = false); forward;

procedure InternalEndParallelJob(AParallelJob: PParallelCall);
begin
EndParallelJob(AParallelJob, true);
end;

{ Note: Central operation point of ParallelJobs system.
}
function ParallelWorker(AParam: PParallelCall): Integer; stdcall;
asm
CALL GetCurrentThreadId
MOV [EBX].TParallelCall.ID, EAX
MOV AL, [EBX].TParallelCall.SafeSection
CMP AL, $00
JZ @Init
@CheckSafeSectionInit:
MOV EAX, [EBX].TParallelCall.SafeFlag
CALL LockVar
@Init:
MOV AL, [EBX].TParallelCall.Mode
CMP AL, $00
JZ @SelfMode
JMP @Direct
@SelfMode:
LEA ECX, [EBX].TParallelCall.Thunk
CALL ECX
MOV Result, EAX
JMP @CheckSafeSectionEnd
@Direct:
MOV ECX, [EBX].TParallelCall.Call
MOV EAX, [EBX].TParallelCall.Param
PUSH EAX
CALL ECX
MOV Result, EAX
POP EAX
@CheckSafeSectionEnd:
MOV AL, [EBX].TParallelCall.SafeSection
CMP AL,0
JZ @End
MOV EAX, [EBX].TParallelCall.SafeFlag
CALL UnlockVar
@End:
LOCK ADD [EBX].TParallelCall.Terminated, $01
MOV EAX, AParam
PUSH EAX
CALL InternalEndParallelJob
POP EAX
end;

{ Note: Initialize the Job structure
}
function InitParallelJob(AMode: TParallelCallMode; ASelf, ATarget,
AParam: Pointer; ASafeSection: boolean): PParallelCall;
var
dwNull: DWORD;
begin
IsMultiThread := true;
Result := VirtualAlloc(nil, ((SizeOf(TParallelCall) div 8) + 1) * 8, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
FillChar(Result^, SizeOf(TParallelCall), 0);

if CurrentGroup <> nil then
CurrentGroup.AddJob(Result);
CreateHolder(Result);

Result^.ID := 0;
Result^.Group := CurrentGroup;
Result^.GState := jgsStopped;
Result^.Mode := AMode;
case AMode of
pcmSelfMode : begin
Result^.Call := ATarget;
SetupThunk(Result^.Thunk, ASelf, ATarget, AParam);
end;
pcmDirect : begin
Result^.Call := ATarget;
Result^.Param := AParam;
end;
end;
Result^.SafeSection := ASafeSection;
if ASafeSection then
Result^.SafeFlag := SafeSectionInfoFlag(ASelf, ATarget)
else
Result^.SafeFlag := nil;
Result^.Terminated := 0;
Result^.EndCall := false;

Result^.Info := TParallelJobInfo.Create;
Result^.Info.FHolder := Result^.Holder;

Result^.Hnd := CreateRemoteThread(GetCurrentProcess, nil, 0, @ParallelWorker,
Result, CREATE_SUSPENDED, dwNull);
end;

type
PParallelEnd = ^TParallelEnd;
TParallelEnd = packed record
ParallelCall : PParallelCall;
Hnd : THandle;
FreeEvent : TParallelJobSemaphore;
end;

{ Note: Finalize the job structure and allocations
}
procedure ParallelReleaseParallelJob(AParallelCall : PParallelCall);
begin
if Assigned(AParallelCall^.NotifyEnd) then
AParallelCall^.NotifyEnd(AParallelCall^.Hnd);

if AParallelCall^.Group <> nil then
AParallelCall^.Group.DelJob(AParallelCall, true);

AParallelCall^.Info.Free;

TerminateNullJob := true;
if AParallelCall^.SafeSection then
case AParallelCall^.Mode of
pcmSelfMode : SafeSectionInfoFlagFree(AParallelCall^.Thunk.aV, AParallelCall^.Call);
pcmDirect : SafeSectionInfoFlagFree(nil, AParallelCall^.Call);
end;
DestroyHolder(AParallelCall);
end;

{ Note: Threaded call to ParallelReleaseParallelJob
}
function ParallelEndParallelJob(AParam: PParallelEnd): Integer; stdcall;
begin
ParallelReleaseParallelJob(AParam^.ParallelCall);
AParam^.FreeEvent.SetEvent;
Result := 0;
end;

{ Note: When caller and job has some relation we need to enable a notify to
avoid some deadlocks.
}
var
EndParallelJobWaitNotify: TWaitProcessNotify = nil;

{ Note: Call finalize on a other thread
}
procedure EndParallelJob(AParallelJob: PParallelCall;
AInternalEnd: boolean = false);
var
PEnd: TParallelEnd;
dwNull: DWORD;
begin
if AInternalEnd then
ParallelReleaseParallelJob(AParallelJob)
else
begin
if not AParallelJob^.EndCall then
LockVar(AParallelJob^.EndCall)
else
Exit;

if AParallelJob^.Hnd = 0 then
Exit;

with PEnd do
begin
FreeEvent := TParallelJobSemaphore.Create;
ParallelCall := AParallelJob;
Hnd := CreateThread(nil, 0, @ParallelEndParallelJob,
@PEnd, 0, dwNull);

while FreeEvent.WaitEvent(1) <> WAIT_OBJECT_0 do
if Assigned(EndParallelJobWaitNotify) then
EndParallelJobWaitNotify;

FreeEvent.Free;
end;
end;
end;

{ Note: JobsGroup Unique Name system
}
function CreateJobsGroupHolder(AJobsGroupName: string): boolean;
var
pNew: PChar;
begin
if GroupNameHolder = nil then
GroupNameHolder := TChainedList.Create;

Result := True;

GroupNameHolder.First;
while GroupNameHolder.GetCurrentItem <> nil do
begin
if PChar(GroupNameHolder.GetCurrentItem^) = AJobsGroupName then
begin
Result := False;
Exit;
end;
GroupNameHolder.Next;
end;
end;

procedure DestroyJobsGroupHolder(AJobsGroupName: string);
begin
GroupNameHolder.First;
while GroupNameHolder.Current <> nil do
begin
if PChar(GroupNameHolder.Current^) = AJobsGroupName then
begin
GroupNameHolder.Remove;
Break;
end;
GroupNameHolder.Next;
end;
end;

{ TJobsGroup }

constructor TJobsGroup.Create(AName: string);
begin
inherited Create;

Assert(CreateJobsGroupHolder(AName),
'A JobsGroup named '''+AName+''' already exists.');

FLock := false;
FName := AName;
Clear;
end;

destructor TJobsGroup.Destroy;
begin
Clear;
DestroyJobsGroupHolder(Name);
inherited;
end;

{ Note: Lock work section
}
procedure TJobsGroup.Lock;
begin
LockVar(FLock);
end;

{ Note: Unlock work section
}
procedure TJobsGroup.Unlock;
begin
UnlockVar(FLock);
end;

{ Note: Ends and clean the Job list from Group
}
procedure TJobsGroup.Clear;
begin
while FFirstJob <> nil do
DelJob(FFirstJob^.Job);

FFirstJob := nil;
FLastJob := nil;
end;

{ Note: UpdateHandles is needed for WaitForJobs method
}
procedure TJobsGroup.UpdateHandles;
var
pWalk: PJobItem;
i: integer;
begin
Lock;
try
i := 0;
pWalk := FFirstJob;
while pWalk <> nil do
begin
FJobsHandles[i] := PParallelCall(pWalk^.Job)^.Hnd;
i := i + 1;
if i = MAXIMUM_WAIT_OBJECTS then
Break;
pWalk := pWalk^.next;
end;
finally
Unlock;
end;
end;

{ Note: Initialize the Jobs capture.
Hold the last CurrentGroup and setup CurrentGroup as it self
}
procedure TJobsGroup.InitJobCapture;
begin
FLastGroup := CurrentGroup;
CurrentGroup := Self;
end;

{ Note: Finalize the Jobs capture.
Rollback the CurrentGroup for the saved value on InitJobCapture
}
procedure TJobsGroup.EndJobCapture;
begin
CurrentGroup := FLastGroup;
end;

{ Note: Internal add job to group
}
procedure TJobsGroup.AddJob(AJob: Pointer);
var
pNew: PJobItem;
begin
Lock;
try
New(pNew);
pNew^.prev := nil;
pNew^.next := nil;

pNew^.Job := AJob;
if FFirstJob = nil then
begin
FFirstJob := pNew;
FLastJob := pNew;
end else
begin
FLastJob^.next := pNew;
pNew^.prev := FLastJob;
FLastJob := pNew;
end;
FJobsCount := FJobsCount + 1;
finally
Unlock;
end;
UpdateHandles;
end;

{ Note: Internal remove job from Group
}
procedure TJobsGroup.DelJob(AJob: Pointer; AInternalEnd: boolean = false);
var
pWalk: PJobItem;
begin
Lock;
try
pWalk := FFirstJob;
while pWalk <> nil do
if pWalk^.Job = AJob then
begin
PParallelCall(pWalk^.Job)^.Group := nil;

if not AInternalEnd then
TerminateParallelJob(PParallelCall(pWalk^.Job));

if pWalk^.prev <> nil then
pWalk^.prev^.next := pWalk^.next;

if pWalk^.next <> nil then
pWalk^.next^.prev := pWalk^.prev;

if pWalk = FLastJob then
FLastJob := pWalk^.prev;

if pWalk = FFirstJob then
FFirstJob := pWalk^.next;

Dispose(pWalk);
FJobsCount := FJobsCount - 1;
SwitchToThread;
Break;
end else
pWalk := pWalk^.next;
finally
Unlock;
end;
UpdateHandles;
end;

{ Note: Get job from Group
}
function TJobsGroup.GetJobItem(index: integer): PJobItem;
begin
Lock;
try
Result := FFirstJob;
while index > 0 do
begin
Result := Result^.next;
Dec(index);
end;
finally
Unlock;
end;
end;

{ Note: Start all jobs of the Group
}
function TJobsGroup.StartJobs: integer;
var
pWalk: PJobItem;
i: integer;
arStart: array of PJobItem;
begin
Lock;
try
Result := 0;
SetLength(arStart, JobsCount);

pWalk := FFirstJob;
while pWalk <> nil do
begin
arStart[Result] := pWalk;
Inc(Result);

pWalk := pWalk^.next;
end;
finally
Unlock;
end;

Result := 0;
for i := 0 to High(arStart) do
if PParallelCall(arStart[i]^.Job)^.GState = jgsStopped then
begin
PParallelCall(arStart[i]^.Job)^.GState := jgsRunning;
if ResumeThread(PParallelCall(arStart[i]^.Job)^.Hnd) <> DWORD(-1) then
Inc(Result);
end;

UpdateHandles;
end;

{ Note: Stop all jobs of the Group
}
function TJobsGroup.StopJobs(AWaitNotify: TWaitProcessNotify = nil;
AForce: boolean = false): integer;
var
pWalk: PJobItem;
begin
Result := 0;
EndParallelJobWaitNotify := AWaitNotify;

Lock;
try
pWalk := FFirstJob;
while pWalk <> nil do
begin
if PParallelCall(pWalk^.Job)^.GState = jgsRunning then
begin
Inc(Result);
SuspendThread(PParallelCall(pWalk^.Job)^.Hnd);
PParallelCall(pWalk^.Job)^.GState := jgsStopped;
end;
pWalk := pWalk^.next;
end;
finally
Unlock;
end;

UpdateHandles;
end;

{ Note: Return the count of all jobs of the Group
}
function TJobsGroup.JobsCount: integer;
begin
Result := FJobsCount;
end;

{ Note: Return the count of jobs of the Group still running
}
function TJobsGroup.JobsIsRunning: Integer;
var
pWalk: PJobItem;
begin
Result := 0;
Lock;
try
pWalk := FFirstJob;
while pWalk <> nil do
begin
if PParallelCall(pWalk^.Job)^.GState = jgsRunning then
Result := Result + 1;
pWalk := pWalk^.next;
end;
finally
Unlock;
end;
end;

{ Note: Simplify the events capture from jobs thread
Limit = MAXIMUM_WAIT_OBJECTS: 64 threads
}
function TJobsGroup.WaitForJobs(AWaitAll: boolean; AMilliseconds: DWORD): DWORD;
begin
Result := WaitForMultipleObjects(FJobsCount, @FJobsHandles,
AWaitAll, AMilliseconds);
end;

{ Note: Remove a Job from Group
}
procedure TJobsGroup.RemoveJob(AIndex: integer);
begin
DelJob(Jobs[AIndex]^.Job);
end;

{ TParallelJobInfo }

function TParallelJobInfo.Id: DWORD;
begin
Result := PParallelJobHolder(FHolder)^.Job^.ID;
end;

function TParallelJobInfo.Handle: THandle;
begin
Result := PParallelJobHolder(FHolder)^.Job^.Hnd;
end;

function TParallelJobInfo.Terminated: boolean;
begin
Result := PParallelJobHolder(FHolder)^.Job^.Terminated > 0;
end;

function TParallelJobInfo.Job: TParallelJob;
begin
Result := FJob;
end;

{ TParallelJobSemaphore }

constructor TParallelJobSemaphore.Create;
begin
Create(false);
end;

constructor TParallelJobSemaphore.Create(AManualReset: boolean);
begin
Create('', AManualReset);
end;

constructor TParallelJobSemaphore.Create(AName: string;
AManualReset: boolean);
begin
Create(AName, AManualReset, false, nil);
end;

constructor TParallelJobSemaphore.Create(AName: string; AManualReset,
AInitialState: boolean; ASecurityAttributes: PSecurityAttributes);
begin
FEvent := CreateEvent(ASecurityAttributes, AManualReset, AInitialState, PChar(AName));
end;

destructor TParallelJobSemaphore.Destroy;
begin
CloseHandle(FEvent);
end;

function TParallelJobSemaphore.WaitEvent(ATimeout: DWORD): integer;
begin
Result := WaitForSingleObject(FEvent, ATimeout);
end;

function TParallelJobSemaphore.WaitEvent: integer;
begin
Result := WaitEvent(INFINITE);
end;

procedure TParallelJobSemaphore.SetEvent;
begin
Windows.SetEvent(FEvent);
end;

procedure TParallelJobSemaphore.Reset;
begin
ResetEvent(FEvent);
end;

{ TParallelJobLocker }

constructor TParallelJobLocker.Create;
begin
Unlock;
end;

procedure TParallelJobLocker.Lock;
begin
LockVar(FLock);
end;

procedure TParallelJobLocker.Unlock;
begin
UnlockVar(FLock);
end;

{ TParallelJob }

constructor TParallelJob.Create(ASelf: TObject; ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false);
begin
FSelf := ASelf;
FTarget := ATarget;
FParam := AParam;
FSafeSection := ASafeSection;

InitJob;
end;

constructor TParallelJob.Create(ATarget: Pointer; AParam: Pointer = nil;
ASafeSection: boolean = false);
begin
FSelf := nil;
FTarget := ATarget;
FParam := AParam;
FSafeSection := ASafeSection;

InitJob;
end;

destructor TParallelJob.Destroy;
begin
inherited;

Locker.Unlock;
Locker.Free;
end;

procedure TParallelJob.InitJob;
begin
FStarted := false;
UnlockVar(FEnded);

if FSelf = nil then
FHolder := InitParallelJob(pcmDirect, nil, FTarget, FParam, FSafeSection)
else
FHolder := InitParallelJob(pcmSelfMode, FSelf, FTarget, FParam, FSafeSection);

PParallelCall(FHolder)^.Info.FJob := Self;
PParallelCall(FHolder)^.NotifyEnd := OnEndJob;

FLocker := TParallelJobLocker.Create;
end;

procedure TParallelJob.OnEndJob(AParallelJobHandle: THandle);
begin
FHolder := nil;
LockVar(FEnded);
end;

procedure TParallelJob.Start;
begin
if IsDone then
InitJob;

FStarted := true;
ResumeThread(PParallelCall(FHolder)^.Hnd);
end;

procedure TParallelJob.Start(AParam: Pointer);
begin
if IsDone then
InitJob;

if not FStarted then
begin
FParam := AParam;

if FSelf = nil then
PParallelCall(FHolder)^.Param := FParam
else
SetupThunk(PParallelCall(FHolder)^.Thunk, FSelf, FTarget, FParam);
end;
FStarted := true;
ResumeThread(PParallelCall(FHolder)^.Hnd);
end;

procedure TParallelJob.Pause;
begin
if not FEnded then
SuspendThread(PParallelCall(FHolder)^.Hnd);
end;

function TParallelJob.IsDone: boolean;
begin
Result := FEnded;
end;

function TParallelJob.WaitForEnd(ATimeout: DWORD): integer;
begin
if FEnded or not FStarted then
Result := WAIT_OBJECT_0
else
Result := WaitForSingleObject(PParallelCall(FHolder)^.Hnd, ATimeout);
end;

function TParallelJob.WaitForEnd: integer;
begin
Result := WaitForEnd(INFINITE);
end;

procedure TParallelJob.Stop(AWaitFinish: Boolean = true);
begin
if not FEnded then
begin
if AWaitFinish then
begin
InterlockedIncrement(PParallelCall(FHolder)^.Terminated);
WaitForEnd;
end else
begin
TerminateParallelJob(PParallelCall(FHolder), true);
EndParallelJob(PParallelCall(FHolder), true);
end;
end;
end;

function TParallelJob.GetPriority: Integer;
begin
if not IsDone then
Result := GetThreadPriority(PParallelCall(FHolder)^.Hnd)
else
Result := 0;
end;

procedure TParallelJob.SetPriority(const Value: Integer);
begin
if not IsDone then
SetThreadPriority(PParallelCall(FHolder)^.Hnd, Value);
end;

function TParallelJob.GetLocker: TParallelJobLocker;
begin
Result := FLocker;
end;

procedure TParallelJob.SetLocker(const Value: TParallelJobLocker);
begin
FLocker := Value;
end;

function TParallelJob.GetInfo: TParallelJobInfo;
begin
Result := PParallelCall(FHolder)^.Info;
end;

{ Note: Count the number of All Jobs exists on the memory.
}
class function TParallelJob.ParallelJobsCount: integer;
var
pWalk: PParallelJobHolder;
begin
Result := ParallelJobHolder.Count;
end;

{ Note: Terminate all jobs
}
class procedure TParallelJob.TerminateAllParallelJobs(AForce: boolean = false);
var
pWalk: PParallelJobHolder;
begin
ParallelJobHolder.Locker.Lock;
try
ParallelJobHolder.InternalFirst;
while ParallelJobHolder.Current <> nil do
begin
TerminateParallelJob(ParallelJobHolder.CurrJob, AForce);
ParallelJobHolder.InternalNext;
end;

if AForce then
begin
ParallelJobHolder.InternalFirst;
while ParallelJobHolder.Current <> nil do
ParallelJobHolder.Remove;
end;
finally
ParallelJobHolder.Locker.Unlock;
end;
end;

{ Note: Wait for all jobs finalization
}
class procedure TParallelJob.WaitAllParallelJobsFinalization(
AWaitNotify: TWaitProcessNotify = nil);
begin
if Assigned(AWaitNotify) then
while ParallelJobHolder.Count > 0 do
begin
AWaitNotify;
SwitchToThread;
end
else
while ParallelJobHolder.Count > 0 do
SwitchToThread;
end;

{ Note: Basic use of ParallelJobs structure
* SelfMode operation
Initialize the Job as needed and check for group
if have no group then start the job imediatly
}
procedure ParallelJob(ASelf: TObject; ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false);
var
pJob: PParallelCall;
begin
pJob := InitParallelJob(pcmSelfMode, ASelf, ATarget, AParam, ASafeSection);
if pJob^.Group = nil then
ResumeThread(pJob^.Hnd);
end;

{ Note: Basic use of ParallelJobs structure
* Direct operation
Initialize the Job as needed and check for group
if have no group then start the job imediatly
}
procedure ParallelJob(ATarget: Pointer; AParam: Pointer = nil;
ASafeSection: boolean = false);
var
pJob: PParallelCall;
begin
pJob := InitParallelJob(pcmDirect, nil, ATarget, AParam, ASafeSection);
if pJob^.Group = nil then
ResumeThread(pJob^.Hnd);
end;

{ Note: Basic use of ParallelJobs structure with JobGroup
* SelfMode operation with JobGroupd
Initialize the Job and attach it on the group
}
procedure ParallelJob(AJobGroup: TJobsGroup; ASelf: TObject; ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false);
begin
AJobGroup.InitJobCapture;
try
ParallelJob(ASelf, ATarget, AParam, ASafeSection);
finally
AJobGroup.EndJobCapture;
end;
end;

{ Note: Basic use of ParallelJobs structure with JobGroup
* Direct operation with JobGroupd
Initialize the Job and attach it on the group
}
procedure ParallelJob(AJobGroup: TJobsGroup; ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false);
begin
AJobGroup.InitJobCapture;
try
ParallelJob(ATarget, AParam, ASafeSection);
finally
AJobGroup.EndJobCapture;
end;
end;

{ Note: Basic use of ParallelJobs structure a object control
* SelfMode operation TParallelJob
Initialize the Job and returns a TParallelJob Object
}
function CreateParallelJob(ASelf: TObject; ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false): TParallelJob;
begin
Result := TParallelJob.Create(ASelf, ATarget, AParam, ASafeSection);
end;

{ Note: Basic use of ParallelJobs structure a object control
* Direct operation with TParallelJob
Initialize the Job and returns a TParallelJob Object
}
function CreateParallelJob(ATarget: Pointer;
AParam: Pointer = nil; ASafeSection: boolean = false): TParallelJob;
begin
Result := TParallelJob.Create(ATarget, AParam, ASafeSection);
end;

{ Note: Return the ParallelJob informations
Can be called anytime inside the Job code, slow then ObtainParallelJobInfo
}
function CurrentParallelJobInfo: TParallelJobInfo;
var
pHolder: PParallelJobHolder;
begin
pHolder := GetJobHolderById(GetCurrentThreadId);
if pHolder = nil then
Result := nil
else
Result := pHolder^.Job^.Info;
end;

{ Note: Return the ParallelJob informations
Can be called only after the first begin of the job
}
function ObtainParallelJobInfo: TParallelJobInfo;
var
pHolder: PParallelJobHolder;
begin
asm
mov eax, [ebx].TParallelCall.Holder
mov pHolder, eax
end;

if pHolder = nil then
Result := nil
else
Result := pHolder^.Job^.Info;
end;

initialization
GroupHolder := TChainedList.Create;
ParallelJobHolder := TParallelJobHolderList.Create;

finalization
TParallelJob.TerminateAllParallelJobs;
TParallelJob.WaitAllParallelJobsFinalization;

ParallelJobHolder.Free;
GroupHolder.Free;

end.

