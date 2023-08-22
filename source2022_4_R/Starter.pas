{
**********************************************************
 * DWS Temp - Starter
 *
 * Versionchecker and launcher
 * implemented as a static class
 *
 * Author: Arik Dasen, Max Kleiner
 * Date: 7.2.2004
 * experimental for version checking and more utilities
 * this unit is for the time not CLX
 * License: GPL
 * 17.11.2005 getfilelist: result correction
 *********************************************************
}

unit Starter;

interface

uses Windows,  sysutils, classes;

type
  TStarter = class(TObject)
  private
    class function GetStdError(const Command: String; var Errors: TStringList): Boolean;
    class function WinExecAndWait32Process(FileName:String; Visibility :
                       integer; process : PProcessInformation):DWORD;
    class function GetVersion(version : string) : integer;
  public
    class function CheckVersion(version, required, nojre : string) : boolean;
    class function WinExecAndWait32(FileName:String; Visibility : integer):DWORD;
    class function getFileList(aList: TStringList; apath: string): integer;
    class function checkNameVersion(aFilename: string; apath: string): boolean;
  end;

implementation

{ TStarter }
  //uses udwsclient;

// execute a command and get stderror as a stringlist
class function TStarter.GetStdError(const Command: String; var Errors: TStringList): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  SecurityAttr: TSecurityAttributes;
  PipeErrorsRead: THandle;
  PipeErrorsWrite: THandle;
  Succeed: Boolean;
  Buffer: array [0..255] of Char;
  NumberOfBytesRead: DWORD;
  Stream: TMemoryStream;
begin
  //Init ProcessInfo
  FillChar(ProcessInfo, SizeOf(TProcessInformation), 0);
  //Init SecurityAttr
  FillChar(SecurityAttr, SizeOf(TSecurityAttributes), 0);
  SecurityAttr.nLength := SizeOf(SecurityAttr);
  SecurityAttr.bInheritHandle := true;
  SecurityAttr.lpSecurityDescriptor := nil;
  //create pipe
  CreatePipe(PipeErrorsRead, PipeErrorsWrite, @SecurityAttr, 0);
  //init StartupInfo
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  StartupInfo.cb:=SizeOf(StartupInfo);
  StartupInfo.hStdInput := 0;
  StartupInfo.hStdOutput := 0;
  StartupInfo.hStdError := PipeErrorsWrite;
  StartupInfo.wShowWindow := sw_Hide;
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
  if CreateProcess(nil, PChar(command), nil, nil, true, CREATE_DEFAULT_ERROR_MODE or
                    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo,
                    ProcessInfo) then
  begin
    result:=true;
    //close write-pipe
    CloseHandle(PipeErrorsWrite);
    // read error-pipe
    Stream := TMemoryStream.Create;
    try
      while true do begin
        succeed:= ReadFile(PipeErrorsRead, Buffer, 255, NumberOfBytesRead, NIL);
        if not succeed then
          break;
        Stream.Write(Buffer, NumberOfBytesRead);
      end;
      Stream.Position := 0;
      Errors.LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
    CloseHandle(PipeErrorsRead);
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    CloseHandle(ProcessInfo.hProcess);
  end
  else begin
    result:= false;
    CloseHandle(PipeErrorsRead);
    CloseHandle(PipeErrorsWrite);
  end;
end;

// simple version-to-integer converter (shame on me)
class function TStarter.GetVersion(version : string) : integer;
var p : integer;
begin
  version := version + '.';
  Result := 0;
  p := Pos('.', version);
  if p > 0 then begin
    Result := StrToIntDef(Copy(version,1,p-1), 0) * 100;
    Delete(version, 1, Pos('.', version));
    p := Pos('.', version);
    if p > 0 then begin
      Result := Result + StrToIntDef(Copy(version,1,p-1), 0) * 10;
      Delete(version, 1, Pos('.', version));
      p := Pos('.', version);
      if p > 0 then
        Result:= Result + StrToIntDef(Copy(version,1,p-1), 0);
    end;
  end;
end;

// check if installed java runtime version is equal or higher than ...
class function TStarter.CheckVersion(version, required, nojre : string) : boolean;
var checkerrorList : TStringList;
    nversion : integer;
    s : string;
begin
  Result:= false;
  nversion:= GetVersion(version);

  checkerrorList:= TStringList.Create;
  GetStdError('java -version', checkerrorList);
  if Pos('java', checkerrorList[0]) = 0 then
    MessageBox(0, PChar(nojre), 'Error', MB_ICONERROR)
  else begin
    s := Copy(checkerrorList[0], 15, 5);
    required := StringReplace(required, '%v', version, [rfReplaceAll]);
    if nversion > GetVersion(s) then
      MessageBox(0, PChar(required), 'Error', MB_ICONERROR)
    else
      Result := true;
  end;
end;

// start a process and wait for its termination
class function TStarter.WinExecAndWait32Process(FileName: String; Visibility: integer; process: PProcessInformation): DWORD;
var cmd : array[0..512] of char;
    StartupInfo:TStartupInfo;
begin
  StrPCopy(cmd, FileName);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;

  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    cmd,                           // pointer to command line string
    nil,                           // pointer to process security attributes
    nil,                           // pointer to thread security attributes
    false,                         // handle inheritance flag
    CREATE_NEW_CONSOLE or          // creation flags
    NORMAL_PRIORITY_CLASS,
    nil,                           // pointer to new environment block
    nil,                           // pointer to current directory name
    StartupInfo,                   // pointer to STARTUPINFO
    process^)                      // pointer to PROCESS_INF
  then Result := DWORD(-1)
  else begin
     WaitforSingleObject(process^.hProcess,INFINITE);
     GetExitCodeProcess(process^.hProcess,Result);
     CloseHandle( process^.hProcess );
     CloseHandle( process^.hThread );
  end;
end;

// wrapper
class function TStarter.WinExecAndWait32(FileName: String; Visibility: integer): DWORD;
var process : TProcessInformation;
begin
  Result := WinExecAndWait32Process(FileName, Visibility, @process);
end;

class function TStarter.getFileList(aList: TStringList; apath: string): integer;
var DOSerr: integer;
    fsrch: TsearchRec;
begin
  // result 0 or 1
  result:= 1;
  // implement uses on form frmDWS!!
  doserr:= FindFirst(aPath+'/*.*',faAnyFile, fsrch);
  if (DOSerr = 0) then begin
    while (DOSerr = 0) do begin
      aList.Add(fsrch.Name);
      if (fsrch.attr and faDirectory) = 0 then inc(result);
      DOSerr:= findnext(fsrch);
    end;
   findClose(fsrch);
  end;
end;

class function TStarter.checkNameVersion(aFilename: string; apath: string): boolean;
var diskfilename: string;
    aList: TStringList;
    filecount, i: integer;
begin
  result:= false;
  aList:= TStringList.Create;
  try
    //WriteLn(CTR_FILE + lbres.Items[lbres.ItemIndex]);
    // just a name checking, we work on a secure timestamp checking
    delete(aFilename,pos(' ',afilename),
              length(afilename)- pos(' ', afilename) + 1);
    afilename:= extractFilename(afilename);
    filecount:= TStarter.getFileList(aList,apath);
    for i:= 0 to filecount do begin
        if afilename = aList.strings[i] then
              result:= true;
    end;
  finally
    aList.Free;
  end;
end;

end.
