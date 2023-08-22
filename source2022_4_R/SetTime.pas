(******************************************************************************)
(*                                                                            *)
(*   Änderung der Systemzeit                                                  *)
(*                                                                            *)
(*   (c) 2.1.1998 Rainer Reusch                                               *)
(*   (c) 1999 Rainer Reusch & Toolbox                                         *)
(*   (c) 1999 Rainer Reusch & Computer- und Literaturverlag                   *)
(*                                                                            *)
(*   Windows 95, 98, NT                                                       *)
(*                                                                            *)
(*   Borland Delphi 3, 4                                                      *)
(*                                                                            *)
(****V1.1**********************************************************************)

unit SetTime;

interface

uses
  Windows, SysUtils;

function SetSystemTime(DateTime : TDateTime; DOW : word) : boolean;
{ Systemzeit ändern
  DateTime: Zu setzendes Datum und Uhrzeit
  DOW: Wochentag (Montag=1, Sonntag=7)
  Funktionsergebnis: true, wenn Aktion erfogreich }

implementation

const
  { in Delphi nicht deklariertes }
  ANYSIZE_ARRAY    = 1;
  SE_CREATE_TOKEN_NAME        = 'SeCreateTokenPrivilege';
  SE_ASSIGNPRIMARYTOKEN_NAME  = 'SeAssignPrimaryTokenPrivilege';
  SE_LOCK_MEMORY_NAME         = 'SeLockMemoryPrivilege';
  SE_INCREASE_QUOTA_NAME      = 'SeIncreaseQuotaPrivilege';
  SE_UNSOLICITED_INPUT_NAME   = 'SeUnsolicitedInputPrivilege';
  SE_MACHINE_ACCOUNT_NAME     = 'SeMachineAccountPrivilege';
  SE_TCB_NAME                 = 'SeTcbPrivilege';
  SE_SECURITY_NAME            = 'SeSecurityPrivilege';
  SE_TAKE_OWNERSHIP_NAME      = 'SeTakeOwnershipPrivilege';
  SE_LOAD_DRIVER_NAME         = 'SeLoadDriverPrivilege';
  SE_SYSTEM_PROFILE_NAME      = 'SeSystemProfilePrivilege';
  SE_SYSTEMTIME_NAME          = 'SeSystemtimePrivilege';
  SE_PROF_SINGLE_PROCESS_NAME = 'SeProfileSingleProcessPrivilege';
  SE_INC_BASE_PRIORITY_NAME   = 'SeIncreaseBasePriorityPrivilege';
  SE_CREATE_PAGEFILE_NAME     = 'SeCreatePagefilePrivilege';
  SE_CREATE_PERMANENT_NAME    = 'SeCreatePermanentPrivilege';
  SE_BACKUP_NAME              = 'SeBackupPrivilege';
  SE_RESTORE_NAME             = 'SeRestorePrivilege';
  SE_SHUTDOWN_NAME            = 'SeShutdownPrivilege';
  SE_DEBUG_NAME               = 'SeDebugPrivilege';
  SE_AUDIT_NAME               = 'SeAuditPrivilege';
  SE_SYSTEM_ENVIRONMENT_NAME  = 'SeSystemEnvironmentPrivilege';
  SE_CHANGE_NOTIFY_NAME       = 'SeChangeNotifyPrivilege';
  SE_REMOTE_SHUTDOWN_NAME     = 'SeRemoteShutdownPrivilege';

  PrivilegeSet : boolean = false;   // true, wenn SetTimePrivilege erfolgreich aufgerufen
  IsNT : boolean = false;           // true: Plattform Windows NT

function SetTimePrivilege : boolean;
{ Setzt die Erlaubnis, die Systemzeit zu ändern }
var
  hToken : THandle;
  ptkp, ptkpold : PTokenPrivileges;
  r : dword;
begin
  Result:=false;
  // Privileg setzen
  // Token Handle des aktuellen Prozesses ermitteln
  if OpenProcessToken(GetCurrentProcess,
    TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
  begin
    // LUID für shut down ermitteln und Privileg setzen
    GetMem(ptkp,sizeof(TTOKENPRIVILEGES) +
      (1-ANYSIZE_ARRAY) * sizeof(TLUIDANDATTRIBUTES));
    LookupPrivilegeValue(nil, SE_SYSTEMTIME_NAME,
      ptkp^.Privileges[0].Luid);
    ptkp^.PrivilegeCount:=1;  // Anzahl zu setzender Privilegien
    ptkp^.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
    // Privileg für diesen Prozess setzen
    r:=0;
    ptkpold:=nil;
    if AdjustTokenPrivileges(hToken, false, ptkp^, 0, ptkpold^, r) then
    begin
      PrivilegeSet:=true;
      Result:=true;
    end;
  end;
end;

function SetDateTimeNT(var SystemTime : TSystemTime) : boolean;
{ Ändert die Systemzeit (NT) }
var
  t : TSystemTime;
begin
  Result:=false;
  t:=SystemTime;
  if not PrivilegeSet then SetTimePrivilege;
  if PrivilegeSet then Result:=SetLocalTime(t);
end;

function SetDateTime95(var SystemTime : TSystemTime) : boolean;
{ Ändert die Systemzeit (95/98) }
var
  t : TSystemTime;
begin
  t:=SystemTime;
  Result:=SetLocalTime(t);
end;

function SetSystemTime(DateTime : TDateTime; DOW : word) : boolean;
// DOW Delphi-konform. Das heißt: Montag=1, Sonntag=7
var
  t : TSystemTime;
begin
  DecodeDate(DateTime,t.wYear,t.wMonth,t.wDay);
  DecodeTime(DateTime,t.wHour,t.wMinute,t.wSecond,t.wMilliseconds);
  if DOW=7 then DOW:=0;  // DOW Windows-konform
  t.WdayOfWeek:=DOW;
  if IsNT then Result:=SetDateTimeNT(t)
          else Result:=SetDateTime95(t);
end;

begin
  IsNT:=Win32Platform=VER_PLATFORM_WIN32_NT;
end.
