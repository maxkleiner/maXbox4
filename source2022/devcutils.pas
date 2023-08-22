unit devcutils;

interface

uses Windows, Forms, SysUtils, Classes, Consts, Graphics, Dialogs;

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
procedure CopyFile(const FileName, DestName: string);
procedure MoveFile(const FileName, DestName: string);
function MakeCommaTextToColor(Text:string; Index:Integer; DefaultColor: TColor): TColor;
procedure DeleteFiles(Sender : TObject; s : string);
function GetTempDir: string;
function GetFileSize(FileName: string): longint;
function GetFileTime(FileName: string): longint;
function GetShortName(FileName: string): string;
function GetFullName(FileName: string): string;
function WinReboot: boolean;
Function WinDir: String;
function RunFile(FileToRun : string; Params : string; Dir : string; Wait : boolean) : cardinal;
function RunFile_(Cmd, WorkDir : string; Wait : boolean) : Boolean;

implementation

uses ShellAPI;

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

function HasAttr(const FileName: string; Attr: Word): Boolean;
begin
  Result := (FileGetAttr(FileName) and Attr) = Attr;
end;

procedure CopyFile(const FileName, DestName: string);
var
  CopyBuffer: Pointer; { buffer for copying }
  BytesCopied: Longint;
  Source, Dest: Integer; { handles }
  Destination: TFileName; { holder for expanded destination name }
const
  ChunkSize: Longint = 8192; { copy in 8K chunks }
begin
  Destination := ExpandFileName(DestName); { expand the destination path }
//  if HasAttr(Destination, faDirectory) then { if destination is a directory... }
//    Destination := Destination + '\' + ExtractFileName(FileName); { ...clone file name }
  GetMem(CopyBuffer, ChunkSize); { allocate the buffer }
  try
    Source := FileOpen(FileName, fmShareDenyWrite); { open source file }
    if Source < 0 then raise EFOpenError.CreateFmt('SFOpenError', [FileName]);
    try
      Dest := FileCreate(Destination); { create output file; overwrite existing }
      if Dest < 0 then raise EFCreateError.CreateFmt('SFCreateError', [Destination]);
      try
        repeat
          BytesCopied := FileRead(Source, CopyBuffer^, ChunkSize); { read chunk }
          if BytesCopied > 0 then { if we read anything... }
            FileWrite(Dest, CopyBuffer^, BytesCopied); { ...write chunk }
        until BytesCopied < ChunkSize; { until we run out of chunks }
      finally
        FileClose(Dest); { close the destination file }
      end;
    finally
      FileClose(Source); { close the source file }
    end;
  finally
    FreeMem(CopyBuffer, ChunkSize); { free the buffer }
  end;
end;

function  GetCommaText(const Text:string; Index:Integer; Comma: Char): string;
var
  I, Pos1, Width, Temp, Temp1: Integer;
  S: string;
begin
   Result:= Text;
   if Text = '' then Exit;
   S:= Text;
   Pos1:= 0;
   Temp1 := 0;
   for I:= 0 to Index do
   begin
       Temp:= Pos(Comma, S);
       if Temp = 0 then Break;
       Temp1:= Pos1;
       Pos1:= Pos1 + Temp;
       S:= Copy(Text, Pos1 + 1, Length(S));
   end;
   Width:= Pos1 - Temp1 -1;
   Result:= Trim(Copy(Text, Temp1 + 1, Width));
end;


function MakeCommaTextToColor(Text:string; Index:Integer; DefaultColor: TColor): TColor;
var
   S: string;
begin
   Result:= DefaultColor;
   if Text = '' then Exit;
   S:= GetCommaText(Text, Index, ',');
   Result:= StrToInt(S);
end;

procedure DeleteFiles(Sender : TObject; s : string);
var lpOp: TSHFileOpStruct;
begin
with lpOP do begin
  Wnd := (Sender as TForm).Handle;

  wFunc := FO_DELETE;
  pFrom := PChar(s + #0#0);
  pTo   := PChar(#0#0);
  fFlags := FOF_NOCONFIRMATION;
  lpszProgressTitle := PChar('Deleting files...');

  SHFileOperation(lpOp)
end;
end;

function GetFileSize(FileName: string): longint;
var
  Srec: TSearchRec;
begin
  FindFirst(FileName, $01+$04+$20, Srec);
  try
    GetFileSize := Srec.Size
  except
    GetFileSize := 0;
  end;
end;

function GetFileTime(FileName: string): longint;
var
  Srec: TSearchRec;
begin
  FindFirst(FileName, $01+$04+$20, Srec);
  try
    GetFileTime := Srec.Time
  except
    GetFileTime := 0;
  end;
end;

function GetFullName(FileName: string): string;
var
  pFileName: array [0..2048] of char;
  pFile : LPSTR;
begin
  GetFullPathName(pchar(FileName), 2048, pFileName, pFile);
  Result := strpas(pFileName);
end;

function GetShortName(FileName: string): string;
var
  pFileName: array [0..2048] of char;
begin
  GetShortPathName(pchar(FileName), pFileName, 2048);
  Result := strpas(pFileName);
end;

function SetPrivilege(privilegeName: string; enable: boolean): boolean;
var
  tpPrev,
  tp         : TTokenPrivileges;
  token      : THandle;
  dwRetLen   : DWord;
begin
  result := False;

  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, token);

  tp.PrivilegeCount := 1;
  if LookupPrivilegeValue(nil, pchar(privilegeName), tp.Privileges[0].LUID) then
  begin
    if enable then
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
    else
      tp.Privileges[0].Attributes := 0;

    dwRetLen := 0;
    result := AdjustTokenPrivileges(token, False, tp, SizeOf(tpPrev), tpPrev, dwRetLen);
  end;
  CloseHandle(token);
end;


function WinReboot: boolean;
begin
  Result := True;
  SetPrivilege('SeShutdownPrivilege', True);
  if not ExitWindowsEx(EWX_REBOOT or EWX_FORCE, 0) then
     Result := False;
  SetPrivilege('SeShutdownPrivilege', False);
end;

function RunFile(FileToRun : string; Params : string; Dir : string; Wait : boolean) : cardinal;
const
  BufSize = $4000;
var
  StartupInfo : TStartupInfo;
  ProcessInfo : TProcessInformation;
begin
  FillChar(StartupInfo,SizeOf(StartupInfo), 0);

  with StartupInfo do
  begin

    cb:= SizeOf(StartupInfo);
    dwFlags:= STARTF_USESHOWWINDOW or
               STARTF_USESTDHANDLES;
    wShowWindow:= SW_SHOW;
  end;

  if not CreateProcess(nil, PChar(FileToRun+' '+Params), nil, nil,
     false, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
     nil, pChar(Dir), StartupInfo, ProcessInfo) then begin
      MessageDlg('Unknown error', mtError, [mbOK],0);
      Exit;
     end
  else
  begin
    if Wait then
       WaitForSingleObject(ProcessInfo.hProcess, INFINITE);

    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end;

function RunFile_(Cmd, WorkDir : string; Wait : boolean) : Boolean;
var
  tsi: TStartupInfo;
  tpi: TProcessInformation;
  nRead: DWORD;
  aBuf: Array[0..101] of char;
  sa: TSecurityAttributes;
  hOutputReadTmp, hOutputRead, hOutputWrite, hInputWriteTmp, hInputRead,
  hInputWrite, hErrorWrite: THandle;
  FOutput: String;
begin
  FOutput := '';

  sa.nLength              := SizeOf(TSecurityAttributes);
  sa.lpSecurityDescriptor := nil;
  sa.bInheritHandle       := True;

  CreatePipe(hOutputReadTmp, hOutputWrite, @sa, 0);
  DuplicateHandle(GetCurrentProcess(), hOutputWrite, GetCurrentProcess(),
    @hErrorWrite, 0, true, DUPLICATE_SAME_ACCESS);
  CreatePipe(hInputRead, hInputWriteTmp, @sa, 0);

  // Create new output read handle and the input write handle. Set
  // the inheritance properties to FALSE. Otherwise, the child inherits
  // the these handles; resulting in non-closeable handles to the pipes
  // being created.
  DuplicateHandle(GetCurrentProcess(), hOutputReadTmp,  GetCurrentProcess(),
    @hOutputRead,  0, false, DUPLICATE_SAME_ACCESS);
  DuplicateHandle(GetCurrentProcess(), hInputWriteTmp, GetCurrentProcess(),
    @hInputWrite, 0, false, DUPLICATE_SAME_ACCESS);
  CloseHandle(hOutputReadTmp);
  CloseHandle(hInputWriteTmp);

  FillChar(tsi, SizeOf(TStartupInfo), 0);
  tsi.cb         := SizeOf(TStartupInfo);
  tsi.dwFlags    := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  tsi.hStdInput  := hInputRead;
  tsi.hStdOutput := hOutputWrite;
  tsi.hStdError  := hErrorWrite;
  tsi.wShowWindow := SW_SHOW;

  CreateProcess(nil, PChar(Cmd), @sa, @sa, true, 0, nil, PChar(WorkDir),
    tsi, tpi);
  CloseHandle(hOutputWrite);
  CloseHandle(hInputRead );
  CloseHandle(hErrorWrite);
  Application.ProcessMessages;

  if Wait then
  repeat
     if (not ReadFile(hOutputRead, aBuf, 16, nRead, nil)) or (nRead = 0) then
     begin
        if GetLastError = ERROR_BROKEN_PIPE then Break
        else MessageDlg('Pipe read error, could not execute file', mtError, [mbOK], 0);
     end;
     aBuf[nRead] := #0;
     FOutput := FOutput + PChar(@aBuf[0]);
     Application.ProcessMessages;
  until False;

  Result := GetExitCodeProcess(tpi.hProcess, nRead) = True;
end;

Function WinDir: String;
var
  PWinDir: Array[0..1024] of Char;
begin
  GetWindowsDirectory(PWinDir, 1024);
  Result := String(PWinDir);
  if Result[Length(Result)] = '\' then
     Delete(Result, Length(Result), 1);
end;

function GetTempDir: string;
var
  Temp: Array[0..1024] of Char;
begin
  GetTempPath(1024, Temp);
  Result := String(Temp);
  if Result[Length(Result)] = '\' then
     Delete(Result, Length(Result), 1);
end;

procedure MoveFile(const FileName, DestName: string);
begin
   CopyFile(FileName, DestName);
   DeleteFile(pChar(FileName));
end;

end.
