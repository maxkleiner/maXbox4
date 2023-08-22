(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower SysTools
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1996-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{* SysTools: StSystem.pas 4.03                           *}
{*********************************************************}
{* SysTools: Assorted system level routines              *}
{*********************************************************}

{$I StDefine.inc}

unit StSystem;

interface

uses
  Windows, SysUtils, Classes,
{$IFDEF Version6} {$WARN UNIT_PLATFORM OFF} {$ENDIF}
  FileCtrl,
{$IFDEF Version6} {$WARN UNIT_PLATFORM ON} {$ENDIF}
  StConst, StBase, StUtils, StDate, StStrL;

{$IFNDEF VERSION6}
const
  PathDelim  =  '\';
  DriveDelim =  ':';
  PathSep    =  ';';
{$ENDIF VERSION6}
const
  StPathDelim     = PathDelim; { Delphi/Linux constant }
  StPathSep       = PathSep;   { Delphi/Linux constant }
  StDriveDelim    = DriveDelim;
  StDosPathDelim  = '\';
  StUnixPathDelim = '/';
  StDosPathSep    = ';';
  StUnixPathSep   = ':';
  StDosAnyFile    = '*.*';
  StUnixAnyFile   = '*';
  StAnyFile       = {$IFDEF LINUX} StUnixAnyFile; {$ELSE} StDosAnyFile; {$ENDIF}
  StThisDir       = '.';
  StParentDir     = '..';


type
  DiskClass = ( Floppy360, Floppy720, Floppy12, Floppy144, OtherFloppy,
    HardDisk, RamDisk, UnknownDisk, InvalidDrive, RemoteDrive, CDRomDisk );
    {This enumerated type defines the nine classes of disks that can be
     identified by GetDiskClass, as well as several types used as error
     indications}

  PMediaIDType = ^MediaIDType;
  MediaIDType = packed record
  {This type describes the information that DOS 4.0 or higher writes
   in the boot sector of a disk when it is formatted}
    InfoLevel : Word;                        {Reserved for future use}
    SerialNumber : LongInt;                  {Disk serial number}
    VolumeLabel : array[0..10] of AnsiChar;  {Disk volume label}
    FileSystemID : array[0..7] of AnsiChar;  {String for internal use by the OS}
  end;

  TIncludeItemFunc = function (const SR : TSearchRec;
                               ForInclusion : Boolean; var Abort : Boolean) : Boolean;
    {Function type for the routine passed to EnumerateFiles and
     EnumerateDirectories. It will be called in two ways: to request
     confirmation to include the entity described in SR into the
     string list (ForInclusion = true); or to ask whether to recurse
     into a particular subdirectory (ForInclusion = false).}

{**** Routine Declarations ****}


{CopyFile}
function CopyFile(const SrcPath, DestPath : AnsiString) : Cardinal;
{-Copy a file.}

{CreateTempFile}
function CreateTempFile(const aFolder : AnsiString;
                        const aPrefix : AnsiString) : AnsiString;
{-Creates a temporary file.}

{DeleteVolumeLabel}
function DeleteVolumeLabel(Drive : AnsiChar) : Cardinal;
{-Deletes an existing volume label on Drive. Returns 0 for success,
  or OS error code.}

{EnumerateDirectories}
procedure EnumerateDirectories(const StartDir : AnsiString; FL : TStrings; {!!.02}
                               SubDirs : Boolean;
                               IncludeItem : TIncludeItemFunc);
{-Retrieves the complete path name of directories on requested file
  system path.}

{EnumerateFiles}
procedure EnumerateFiles(const StartDir : AnsiString; FL : TStrings;   {!!.02}
                         SubDirs : Boolean;
                         IncludeItem : TIncludeItemFunc);
{-Retrieves the complete path name of files in a requested file system path.}

{FileHandlesLeft}
function FileHandlesLeft(MaxHandles : Cardinal) : Cardinal;
{-Return the number of available file handles.}

{FileMatchesMask}
function FileMatchesMask(const FileName, FileMask : AnsiString ) : Boolean;
{-see if FileName matches FileMask}

{FileTimeToStDateTime}
function FileTimeToStDateTime(FileTime : LongInt) : TStDateTimeRec;
{-Converts a DOS date-time value to TStDate and TStTime values.}

{FindNthSlash}
function FindNthSlash( const Path : AnsiString; n : Integer ) : Integer;
{ return the position of the character just before the nth slash }

{FlushOsBuffers}
function FlushOsBuffers(Handle : Integer) : Boolean;
{-Flush the OS buffers for the specified file handle.}

{GetCurrentUser}
function GetCurrentUser : AnsiString;
{-Obtains current logged in username}

{GetDiskClass}
function GetDiskClass(Drive : AnsiChar) : DiskClass;
{-Return the disk class for the specified drive.}

{GetDiskInfo}
function GetDiskInfo(Drive : AnsiChar; var ClustersAvailable, TotalClusters,
                     BytesPerSector, SectorsPerCluster : Cardinal) : Boolean;
{-Return technical information about the specified drive.}

{GetDiskSpace}
{$IFDEF CBuilder}
function GetDiskSpace(Drive : AnsiChar;
                  var UserSpaceAvail  : Double;           {space available to user}
                  var TotalSpaceAvail : Double;           {total space available}
                  var DiskSize        : Double) : Boolean;{disk size}
{-Return space information about the drive.}
{$ELSE}
function GetDiskSpace(Drive : AnsiChar;
                  var UserSpaceAvail  : Comp;           {space available to user}
                  var TotalSpaceAvail : Comp;           {total space available}
                  var DiskSize        : Comp) : Boolean;{disk size}
{-Return space information about the drive.}
{$ENDIF}

{GetFileCreateDate}
function GetFileCreateDate(const FileName : AnsiString) :
  TDateTime;
{-Obtains file system time of file creation.}

{GetFileLastAccess}
function GetFileLastAccess(const FileName : AnsiString) :
  TDateTime;
{-Obtains file system time of last file access.}

{GetFileLastModify}
function GetFileLastModify(const FileName : AnsiString) :
  TDateTime;
{-Obtains file system time of last file modification.}

{GetHomeFolder}
function GetHomeFolder(aForceSlash : Boolean) : AnsiString;
{-Obtains the "Home Folder" for the current user}

{$IFNDEF CBuilder}
{GetLongPath}
function GetLongPath(const APath : AnsiString) : AnsiString;
{-Returns the long filename version of a provided path.}
{$ENDIF}

{GetMachineName}
function GetMachineName : AnsiString;
{-Returns the "Machine Name" for the current computer }

{GetMediaID}
function GetMediaID(Drive : AnsiChar; var MediaIDRec : MediaIDType) : Cardinal;
{-Get the media information (Volume Label, Serial Number) for the specified drive}

{GetParentFolder}
function GetParentFolder(const APath : AnsiString; aForceSlash : Boolean) : AnsiString;
{-return the parent directory for the provided directory }

{GetShortPath}
function GetShortPath(const APath : AnsiString) : AnsiString;
{-Returns the short filename version of a provided path.}

{GetSystemFolder}
function GetSystemFolder(aForceSlash : Boolean) : AnsiString;
{-Returns the path to the Windows "System" folder".)

{GetTempFolder}
function GetTempFolder(aForceSlash : boolean) : AnsiString;
{-Returns the path to the system temporary folder.}

{GetWindowsFolder}
function GetWindowsFolder(aForceSlash : boolean) : AnsiString;
{-Returns the path to the main "Windows" folder.}

{GetWorkingFolder}
function GetWorkingFolder(aForceSlash : boolean) : AnsiString;
{-Returns the current working directory.}

{GlobalDateTimeToLocal}
function GlobalDateTimeToLocal(const UTC: TStDateTimeRec; MinOffset: Integer): TStDateTimeRec; {!!.02}
{-adjusts a global date/time (UTC) to the local date/time}

{IsDirectory}
function IsDirectory(const DirName : AnsiString) : Boolean;
{-Return True if DirName is a directory.}

{IsDirectoryEmpty}
function IsDirectoryEmpty(const S : AnsiString) : Integer;
{-checks if there are any entries in the directory}

{IsDriveReady}
function IsDriveReady(Drive : AnsiChar) : Boolean;
{-determine if requested drive is accessible }

{IsFile}
function IsFile(const FileName : AnsiString) : Boolean;
{-Determines if the provided path specifies a file.}

{IsFileArchive}
function IsFileArchive(const S : AnsiString) : Integer;
{-checks if file's archive attribute is set}

{IsFileHidden}
function IsFileHidden(const S : AnsiString) : Integer;
{-checks if file's hidden attribute is set}

{IsFileReadOnly}
function IsFileReadOnly(const S : AnsiString) : Integer;
{-checks if file's readonly attribute is set}

{IsFileSystem}
function IsFileSystem(const S : AnsiString) : Integer;
{-checks if file's system attribute is set}

{LocalDateTimeToGlobal}
function LocalDateTimeToGlobal(const DT1: TStDateTimeRec; MinOffset: Integer): TStDateTimeRec; {!!.02}
{-adjusts a local date/time to the global (UTC) date/time}

{ReadVolumeLabel}
function ReadVolumeLabel(var VolName : AnsiString; Drive : AnsiChar) : Cardinal;
{-Get the volume label for the specified drive.}

{SameFile}
function SameFile(const FilePath1, FilePath2 : AnsiString; var ErrorCode : Integer) : Boolean;
{-Return True if FilePath1 and FilePath2 refer to the same physical file.}

{SetMediaID} {!!!! does not work on NT/2000 !!!!}
function SetMediaID(Drive : AnsiChar; var MediaIDRec : MediaIDType) : Cardinal;
{-Set the media ID record for the specified drive.}

{SplitPath}
procedure SplitPath(const APath : AnsiString; Parts : TStrings);
{-Splits the provided path into its component sub-paths}

{StDateTimeToFileTime}
function StDateTimeToFileTime(const FileTime : TStDateTimeRec) : LongInt;  {!!.02}
{-Converts an TStDate and TStTime to a DOS date-time value.}

{StDateTimeToUnixTime}
function StDateTimeToUnixTime(const DT1 : TStDateTimeRec) : Longint;   {!!.02}
{-converts a TStDateTimeRec to a time in Unix base (1970)}

{UnixTimeToStDateTime}
function UnixTimeToStDateTime(UnixTime : Longint) : TStDateTimeRec;
{-converts a time in Unix base (1970) to a TStDateTimeRec}

{ValidDrive}
function ValidDrive(Drive : AnsiChar) : Boolean;
{-Determine if the drive is a valid drive.}

{WriteVolumeLabel}
function WriteVolumeLabel(const VolName : AnsiString; Drive : AnsiChar) : Cardinal;
{-Sets the volume label for the specified drive.}

(*
{$EXTERNALSYM GetLongPathNameA}
function GetLongPathNameA(lpszShortPath: PAnsiChar; lpszLongPath: PAnsiChar;
  cchBuffer: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetLongPathNameW}
function GetLongPathNameW(lpszShortPath: PWideChar; lpszLongPath: PWideChar;
  cchBuffer: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetLongPathName}
function GetLongPathName(lpszShortPath: PChar; lpszLongPath: PChar;
  cchBuffer: DWORD): DWORD; stdcall;
*)

implementation

const
  FILE_ANY_ACCESS = 0;
  METHOD_BUFFERED = 0;
  IOCTL_DISK_BASE = $00000007;
  VWIN32_DIOC_DOS_IOCTL = 1;
  IOCTL_DISK_GET_MEDIA_TYPES = ((IOCTL_DISK_BASE shl 16) or
    (FILE_ANY_ACCESS shl 14) or ($0300 shl 2) or METHOD_BUFFERED);

procedure StChDir(const S: AnsiString);                                {!!.02}
{ wrapper for Delphi ChDir to handle a bug in D6}
{$IFDEF VER140}
var
  Rslt : Integer;
{$ENDIF}
begin
{$IFNDEF VER140}
  Chdir(S);
{$ELSE}
{$I-}
  Chdir(S);
  if IOResult <> 0 then begin
    Rslt := GetLastError;
    SetInOutRes(Rslt);
  end;
{$I+}
{$ENDIF}
end;

{CopyFile}
function CopyFile(const SrcPath, DestPath : AnsiString) : Cardinal;
  {-Copy the file specified by SrcPath into DestPath. DestPath must specify
    a complete filename, it may not be the name of a directory without the
    file portion.  This a low level routine, and the input pathnames are not
    checked for validity.}
const
  BufferSize = 4 * 1024;

var
  BytesRead, BytesWritten : LongInt;
  FileDate : LongInt;
  Src, Dest, Mode, SaveFAttr : Integer;
  Buffer : Pointer;

begin
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM OFF} {$ENDIF}
  Src := 0;
  Dest := 0;
  Buffer := nil;
  Result := 1;
  try
    GetMem(Buffer, BufferSize);
    Mode := FileMode and $F0;
    SaveFAttr := FileGetAttr(SrcPath);
    if SaveFAttr < 0 then begin
      Result := 1;
      Exit;
    end;
    Src := FileOpen(SrcPath, Mode);
    if Src < 0 then begin
      Result := 1;                     {unable to access SrcPath}
      Exit;
    end;
    Dest := FileCreate(DestPath);
    if Dest < 0 then begin
      Result := 2;                     {unable to open DestPath}
      Exit;
    end;
    repeat
      BytesRead := FileRead(Src, Buffer^, BufferSize);
      if (BytesRead = -1) then begin
        Result := 3;                   {error reading from Src}
        Exit;
      end;
      BytesWritten := FileWrite(Dest, Buffer^, BytesRead);
      if (BytesWritten = -1) or
         (BytesWritten <> BytesRead) then begin
        Result := 4;                   {error writing to Dest}
        Exit;
      end;
    until BytesRead < BufferSize;
    FileDate := FileGetDate(Src);
    if FileDate = -1 then begin
      Result := 5;                     {error getting SrcPath's Date/Time}
      Exit;
    end;
    FileSetDate(Dest, FileDate);
    FileSetAttr(DestPath, SaveFAttr);
    Result := 0;
  finally
    if Assigned(Buffer) then
      FreeMem(Buffer, BufferSize);
    if Src > 0 then FileClose(Src);
    if Dest > 0 then begin
      FileClose(Dest);
      if Result <> 0 then SysUtils.DeleteFile(DestPath);
    end;
  end;
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM ON} {$ENDIF}
end;

{CreateTempFile}
function CreateTempFile(const aFolder : AnsiString;
                        const aPrefix : AnsiString) : AnsiString;
{-Creates a temporary file.}
var
  TempFileNameZ : array [0..MAX_PATH] of AnsiChar;
  TempDir : AnsiString;
begin
  TempDir := aFolder;
  if not DirectoryExists(TempDir) then
    TempDir := GetTempFolder(True);
  if not DirectoryExists(TempDir) then
    TempDir := GetWorkingFolder(True);

  if (GetTempFileName(PAnsiChar(TempDir), PAnsiChar(aPrefix), 0,
    TempFileNameZ) = 0)
  then
{$IFDEF Version6}
    RaiseLastOSError;
{$ELSE}
    RaiseLastWin32Error;
{$ENDIF}
  Result := TempFileNameZ;
end;


{DeleteVolumeLabel}
function DeleteVolumeLabel(Drive : AnsiChar) : Cardinal;
{-Deletes an existing volume label on Drive. Returns 0 for success,
  or OS error code.}
var
  Root : array[0..3] of AnsiChar;
begin
  StrCopy(Root, '%:\');
  Root[0] := Drive;
  if Windows.SetVolumeLabel(Root, '') then
    Result := 0
  else Result := GetLastError;
end;

{EnumerateDirectories}
procedure EnumerateDirectories(const StartDir : AnsiString; FL : TStrings; {!!.02}
                               SubDirs : Boolean;
                               IncludeItem : TIncludeItemFunc);
{-Retrieves the complete path name of directories on requested file
  system path.}
var
  Abort : Boolean;
    procedure SearchBranch;
    var
      SR    : TSearchRec;
      Error : SmallInt;
      Dir   : AnsiString;
    begin
      Error := FindFirst(StDosAnyFile, faDirectory, SR);
      if Error = 0 then begin
        GetDir(0, Dir);
        if Dir[Length(Dir)] <> StDosPathDelim then
          Dir := Dir + StDosPathDelim;
        Abort := False;
        while (Error = 0) and not Abort do begin
          try
            if (@IncludeItem = nil) or (IncludeItem(SR, true, Abort)) then begin
              if (SR.Attr and faDirectory = faDirectory) and
                 (SR.Name <> StThisDir) and (SR.Name <> StParentDir) then
                FL.Add(Dir + SR.Name);
            end;
          except
            on EOutOfMemory do
              raise EOutOfMemory.Create(stscSysStringListFull);
          end;
          Error := FindNext(SR);
        end;
        FindClose(SR);
      end;

      if not Abort and SubDirs then begin
        Error := FindFirst(StDosAnyFile, faDirectory, SR);
        if Error = 0 then begin
          Abort := False;
          while (Error = 0) and not Abort do begin
            if ((SR.Attr and faDirectory = faDirectory) and
                (SR.Name <> StThisDir) and (SR.Name <> StParentDir)) then begin
              if (@IncludeItem = nil) or (IncludeItem(SR, false, Abort)) then begin
                StChDir(SR.Name);
                SearchBranch;
                StChDir(StParentDir);
              end;
            end;
            Error := FindNext(SR);
          end;
          FindClose(SR);

        end;
      end;
    end;

var
  OrgDir : AnsiString;

begin
  if IsDirectory(StartDir) then
  begin
    GetDir(0, OrgDir);
    try
      StChDir(StartDir);
      SearchBranch;
    finally
      StChDir(OrgDir);
    end;
  end else
    raise Exception.Create(stscSysBadStartDir);
end;

{EnumerateFiles}
procedure EnumerateFiles(const StartDir : AnsiString;                  {!!.02}
                         FL : TStrings;
                         SubDirs : Boolean;
                         IncludeItem : TIncludeItemFunc);
{-Retrieves the complete path name of files in a requested file system path.}
var
  Abort : Boolean;

    procedure SearchBranch;
    var
      SR    : TSearchRec;
      Error : SmallInt;
      Dir   : AnsiString;
    begin
      Error := FindFirst(StDosAnyFile, faAnyFile, SR);
      if Error = 0 then begin
        GetDir(0, Dir);
        if Dir[Length(Dir)] <> StDosPathDelim then
          Dir := Dir + StDosPathDelim;

        Abort := False;
        while (Error = 0) and not Abort do begin
          try
            if (@IncludeItem = nil) or (IncludeItem(SR, true, Abort)) then
              FL.Add(Dir + SR.Name);
          except
            on EOutOfMemory do
            begin
              raise EOutOfMemory.Create(stscSysStringListFull);
            end;
          end;
          Error := FindNext(SR);
        end;
        FindClose(SR);
      end;


      if not Abort and SubDirs then begin
        Error := FindFirst(StDosAnyFile, faAnyFile, SR);
        if Error = 0 then begin
          Abort := False;
          while (Error = 0) and not Abort do begin
            if ((SR.Attr and faDirectory = faDirectory) and
                (SR.Name <> StThisDir) and (SR.Name <> StParentDir)) then begin
              if (@IncludeItem = nil) or (IncludeItem(SR, false, Abort)) then begin
                StChDir(SR.Name);
                SearchBranch;
                StChDir(StParentDir);
              end;
            end;
            Error := FindNext(SR);
          end;
          FindClose(SR);
        end;
      end;
    end;

var
  OrgDir : AnsiString;

begin
  if IsDirectory(StartDir) then
  begin
    GetDir(0, OrgDir);
    try
      StChDir(StartDir);
      SearchBranch;
    finally
      StChDir(OrgDir);
    end;
  end else
    raise Exception.Create(stscSysBadStartDir);
end;


{FileHandlesLeft}
{.$HINTS OFF}
function FileHandlesLeft(MaxHandles : Cardinal) : Cardinal;
  {-Returns the number of available file handles. In 32-bit, this can be a
    large number.  Use MaxHandles to limit the number of handles counted.
    The maximum is limited by HandleLimit - you can increase HandleLimit if
    you wish.  A temp file is required because Win95 seems to have some
    limit on the number of times you can open NUL.}
const
  HandleLimit = 1024;
type
  PHandleArray = ^THandleArray;
  THandleArray = array[0..Pred(HandleLimit)] of Integer;
var
  Handles : PHandleArray;
  MaxH, I : Integer;
  TempPath, TempFile : PAnsiChar;
begin
  Result := 0;
  MaxH := MinLong(HandleLimit, MaxHandles);
  TempFile := nil;
  TempPath := nil;
  Handles := nil;
  try
    TempFile := StrAlloc(MAX_PATH+1);                                    {!!.01}
    TempPath := StrAlloc(MAX_PATH+1);                                    {!!.01}
    GetMem(Handles, MaxH * SizeOf(Integer));
    GetTempPath(MAX_PATH, TempPath);                                     {!!.01}
    GetTempFileName(TempPath, 'ST', 0, TempFile);
    for I := 0 to Pred(MaxH) do begin
      Handles^[I] := CreateFile(TempFile, 0, FILE_SHARE_READ, nil,
        OPEN_EXISTING, FILE_FLAG_DELETE_ON_CLOSE, 0);
      if Handles^[I] <> LongInt(INVALID_HANDLE_VALUE) then
        Inc(Result) else Break;
    end;
    for I := 0 to Pred(Result) do
      FileClose(Handles^[I]);
  finally
    if Assigned(Handles) then
      FreeMem(Handles, MaxH * SizeOf(Integer));
    StrDispose(TempFile);
    StrDispose(TempPath);
  end;
end;
{.$HINTS ON}

{ -------------------------------------------------------------------------- }
function StPatternMatch(const Source : string; iSrc : Integer;          {!!.02}
                const Pattern : string; iPat : Integer ) : Boolean;     {!!.02}
{ recursive routine to see if the source string matches
  the pattern.  Both ? and * wildcard characters are allowed.
  Compares Source from iSrc to Length(Source) to
  Pattern from iPat to Length(Pattern)}
var
  Matched : Boolean;
  k : Integer;
begin
{$R-}
  if Length( Source ) = 0 then begin
    Result := Length( Pattern ) = 0;
    Exit;
  end;

  if iPat = 1 then begin
    if ( CompareStr( Pattern, StDosAnyFile) = 0 ) or
       ( CompareStr( Pattern, StUnixAnyFile ) = 0 ) then begin
      Result := True;
      Exit;
    end;
  end;

  if Length( Pattern ) = 0 then begin
    Result := (Length( Source ) - iSrc + 1 = 0);
    Exit;
  end;

  while True do begin
    if ( Length( Source ) < iSrc ) and
       ( Length( Pattern ) < iPat ) then begin
      Result := True;
      Exit;
    end;

    if Length( Pattern ) < iPat then begin
      Result := False;
      Exit;
    end;

    if (iPat <= Length(Pattern)) and (Pattern[iPat] = '*') then begin
      k := iPat;
      if ( Length( Pattern ) < iPat + 1 ) then begin
        Result := True;
        Exit;
      end;

      while True do begin
        Matched := StPatternMatch( Source, k, Pattern, iPat + 1 );
        if Matched or ( Length( Source ) < k ) then begin
          Result := Matched;
          Exit;
        end;
        inc( k );
      end;
    end
    else begin
      if ((Pattern[iPat] = '?') and
           ( Length( Source ) <> iSrc - 1 ) ) or
           ( Pattern[iPat] = Source[iSrc] ) then begin
        inc( iPat );
        inc( iSrc );
      end
      else begin
        Result := False;
        Exit;
      end;
    end;
  end;
{$R+}
end;

{FileMatchesMask}
function FileMatchesMask(const FileName, FileMask : AnsiString ) : Boolean;
{-see if FileName matches FileMask}
var
  DirMatch : Boolean;
  MaskDir : AnsiString;
  LFN, LFM : AnsiString;
begin
  LFN := UpperCase( FileName );
  LFM := UpperCase( FileMask );
  MaskDir := ExtractFilePath( LFN );
  if MaskDir = '' then
    DirMatch := True
  else
    DirMatch := StPatternMatch( ExtractFilePath( LFN ), 1, MaskDir, 1 );

  Result := DirMatch and StPatternMatch( ExtractFileName( LFN ), 1,
                                       ExtractFileName( LFM ), 1 );
end;

{FileTimeToStDateTime}
function FileTimeToStDateTime(FileTime : LongInt) : TStDateTimeRec;
{-Converts a DOS date-time value to TStDate and TStTime values.}

var
  DDT : TDateTime;
begin
  DDT := FileDateToDateTime(FileTime);
  Result.D := DateTimeToStDate(DDT);
  Result.T := DateTimeToStTime(DDT);
end;

{FindNthSlash}
function FindNthSlash(const Path : AnsiString; n : Integer) : Integer;
{ return the position of the character just before the nth slash }
var
  i : Integer;
  Len : Integer;
  iSlash : Integer;
begin
  Len := Length( Path );
  Result := Len;
  iSlash := 0;
  i := 1;
  while i <= Len do begin
    if Path[i] = StPathDelim then begin
      inc( iSlash );
      if iSlash = n then begin
        Result := pred( i );
        break;
      end;
    end;
    inc( i );
  end;
end;

{FlushOsBuffers}
{-Flush the OS buffers for the specified file handle.}
function FlushOsBuffers(Handle : Integer) : Boolean;
  {-Flush the OS's buffers for the specified file}
begin
  Result := FlushFileBuffers(Handle);
  if not Result then
{$IFDEF Version6}
    RaiseLastOSError;
{$ELSE}
    RaiseLastWin32Error;
{$ENDIF}
end;

{GetCurrentUser}
function GetCurrentUser : AnsiString;
{-Obtains current logged in username}
var
  Size : DWORD;
  UserNameZ : array [0..511] of AnsiChar;
begin
  Size := sizeof(UserNameZ);
  if not GetUserName(UserNameZ, Size) then
{$IFDEF Version6}
    RaiseLastOSError;
{$ELSE}
    RaiseLastWin32Error;
{$ENDIF}
//  SetString(Result, UserNameZ, Size);                      {!!.02}
  SetString(Result, UserNameZ, StrLen(UserNameZ));           {!!.02}
end;

{GetDiskClass}
function GetDiskClass(Drive : AnsiChar) : DiskClass;
{-Return the disk class for the specified drive.}
type
  TMediaType =
    ( Unknown,                { Format is unknown }
      F5_1Pt2_512,            { 5.25", 1.2MB,  512 bytes/sector }
      F3_1Pt44_512,           { 3.5",  1.44MB, 512 bytes/sector }
      F3_2Pt88_512,           { 3.5",  2.88MB, 512 bytes/sector }
      F3_20Pt8_512,           { 3.5",  20.8MB, 512 bytes/sector }
      F3_720_512,             { 3.5",  720KB,  512 bytes/sector }
      F5_360_512,             { 5.25", 360KB,  512 bytes/sector }
      F5_320_512,             { 5.25", 320KB,  512 bytes/sector }
      F5_320_1024,            { 5.25", 320KB,  1024 bytes/sector }
      F5_180_512,             { 5.25", 180KB,  512 bytes/sector }
      F5_160_512,             { 5.25", 160KB,  512 bytes/sector }
      RemovableMedia,         { Removable media other than floppy }
      FixedMedia );           { Fixed hard disk media }

  PDiskGeometry = ^TDiskGeometry;
  TDiskGeometry = record
    Cylinders1 : DWORD;
    Cylinders2 : Integer;
    MediaType : TMediaType;
    TracksPerCylinder : DWORD;
    SectorsPerTrack : DWORD;
    BytesPerSector : DWORD;
  end;

var
  Root : array[0..3] of AnsiChar;
  Root2 : array[0..6] of AnsiChar;
  ReturnedByteCount,
  SectorsPerCluster,
  BytesPerSector,
  NumberOfFreeClusters,
  TotalNumberOfClusters : DWORD;
  SupportedGeometry : array[1..20] of TDiskGeometry;
  HDevice : THandle;
  I : Integer;
  VerInfo : TOSVersionInfo;
  Found : Boolean;
begin
  FillChar(VerInfo, SizeOf(TOSVersionInfo), #0);
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  Result := InvalidDrive;
  Found := False;
  StrCopy(Root, '%:\');
  Root[0] := Drive;
  case GetDriveType(Root) of
    0 : Result := UnknownDisk;
    1 : Result := InvalidDrive;
    DRIVE_REMOVABLE :
      begin
        GetVersionEx(VerInfo);
        if VerInfo.dwPlatformID = VER_PLATFORM_WIN32_NT then begin
          StrCopy(Root2, '\\.\%:');
          Root2[4] := Drive;
          HDevice := CreateFile(Root2, 0, FILE_SHARE_READ,
            nil, OPEN_ALWAYS, 0, 0);
          if HDevice = INVALID_HANDLE_VALUE then Exit;
          if not DeviceIoControl(HDevice, IOCTL_DISK_GET_MEDIA_TYPES, nil, 0,
            @SupportedGeometry, SizeOf(SupportedGeometry), ReturnedByteCount, nil)
          then Exit;
          for I := 1 to (ReturnedByteCount div SizeOf(TDiskGeometry)) do begin
            case SupportedGeometry[I].MediaType of
              F5_1Pt2_512 : begin
                Result := Floppy12;
                Exit;
              end;
              F3_1Pt44_512 : begin
                Result := Floppy144;
                Exit;
              end;
              F3_720_512 : begin
                Result := Floppy720;
                Found := True;
              end;
              F5_360_512 : begin
                Result := Floppy360;
                Found := True;
              end;
            end;
          end;
          if Found then Exit;
          Result := OtherFloppy;
        end else begin
          GetDiskFreeSpace(Root, SectorsPerCluster, BytesPerSector,
            NumberOfFreeClusters, TotalNumberOfClusters);
          case TotalNumberOfClusters of
             354 : Result := Floppy360;
             713,
            1422 : Result := Floppy720;
            2371 : Result := Floppy12;
            2847 : Result := Floppy144;
          else Result := OtherFloppy;
          end;
        end;
      end;
    DRIVE_FIXED : Result := HardDisk;
    DRIVE_REMOTE : Result := RemoteDrive;
    DRIVE_CDROM : Result := CDRomDisk;
    DRIVE_RAMDISK : Result := RamDisk;
  end;
end;

{GetDiskInfo}
function GetDiskInfo(Drive : AnsiChar; var ClustersAvailable, TotalClusters,
                     BytesPerSector, SectorsPerCluster : Cardinal) : Boolean;
{-Return technical information about the specified drive.}
var
  Root : AnsiString;
begin
  if Drive <> ' ' then begin
    Root := AnsiChar(Upcase(Drive)) + ':\';
    Result := GetDiskFreeSpace(PAnsiChar(Root), DWORD(SectorsPerCluster),
      DWORD(BytesPerSector), DWORD(ClustersAvailable), DWORD(TotalClusters));
  end else
    Result := GetDiskFreeSpace(nil, DWORD(SectorsPerCluster),
      DWORD(BytesPerSector), DWORD(ClustersAvailable), DWORD(TotalClusters));
end;


{GetDiskSpace}
{$IFDEF CBuilder}
function GetDiskSpace(Drive : AnsiChar;
                  var UserSpaceAvail  : Double;           {space available to user}
                  var TotalSpaceAvail : Double;           {total space available}
                  var DiskSize        : Double) : Boolean;{disk size}
{-Return space information about the drive.}
type
  TGetDiskFreeSpace = function (Drive : PAnsiChar;
                            var UserFreeBytes : Comp;
                            var TotalBytes : Comp;
                            var TotalFreeBytes : Comp) : Bool; stdcall;
  LH = packed record L,H : word; end;
var
  UserFree, Total, Size : Comp;
  VerInfo : TOSVersionInfo;
  LibHandle : THandle;
  GDFS : TGetDiskFreeSpace;
  Root : AnsiString;
begin
  Result := False;
  {get the version info}
  FillChar(VerInfo, SizeOf(TOSVersionInfo), #0);
  VerInfo.dwOSVersionInfoSize := SizeOf(VerInfo);
  if GetVersionEx(VerInfo) then begin
    with VerInfo do begin
      if ((dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) and
          (LH(dwBuildNumber).L <> 1000)) or
         ((dwPlatformId = VER_PLATFORM_WIN32_NT) and
          (dwMajorVersion >= 4)) then begin
        LibHandle := LoadLibrary('KERNEL32.DLL');
        try
          if (LibHandle <> 0) then begin
            @GDFS := GetProcAddress(LibHandle, 'GetDiskFreeSpaceExA');
            if Assigned(GDFS) then begin
              Root := AnsiChar(Upcase(Drive)) + ':\';
              if GDFS(PAnsiChar(Root), UserFree, Size, Total) then begin
                UserSpaceAvail := UserFree;
                DiskSize := Size;
                TotalSpaceAvail := Total;
                Result := true;
              end;
            end;
          end;

        finally
          FreeLibrary(LibHandle);
        end;
      end;
    end;
  end;
end;
{$ELSE}
function GetDiskSpace(Drive : AnsiChar;
                  var UserSpaceAvail  : Comp;           {space available to user}
                  var TotalSpaceAvail : Comp;           {total space available}
                  var DiskSize        : Comp) : Boolean;{disk size}
{-Return space information about the drive.}
type
  TGetDiskFreeSpace = function (Drive : PAnsiChar;
                            var UserFreeBytes : Comp;
                            var TotalBytes : Comp;
                            var TotalFreeBytes : Comp) : Bool; stdcall;
  LH = packed record L,H : word; end;
var
  CA, TC, BPS, SPC : Cardinal;
  VerInfo : TOSVersionInfo;
  LibHandle : THandle;
  GDFS : TGetDiskFreeSpace;
  Root : AnsiString;
begin
  Result := false;
  {get the version info}
  FillChar(VerInfo, SizeOf(TOSVersionInfo), #0);
  VerInfo.dwOSVersionInfoSize := SizeOf(VerInfo);
  if GetVersionEx(VerInfo) then begin
    with VerInfo do begin
      if ((dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) and
          (LH(dwBuildNumber).L <> 1000)) or
         ((dwPlatformId = VER_PLATFORM_WIN32_NT) and
          (dwMajorVersion >= 4)) then begin
        LibHandle := LoadLibrary('KERNEL32.DLL');
        try
          if (LibHandle <> 0) then begin
            @GDFS := GetProcAddress(LibHandle, 'GetDiskFreeSpaceExA');
            if Assigned(GDFS) then begin
              Root := AnsiChar(Upcase(Drive)) + ':\';
              if GDFS(PAnsiChar(Root), UserSpaceAvail, DiskSize, TotalSpaceAvail) then
                Result := true;
            end;
          end;

        finally
          FreeLibrary(LibHandle);
        end;
      end;
    end;
  end;

  if not Result then begin
    if GetDiskInfo(Drive, CA, TC, BPS, SPC) then begin
      Result := true;
      DiskSize := BPS;
      DiskSize := DiskSize * SPC * TC;
      TotalSpaceAvail := BPS;
      TotalSpaceAvail := TotalSpaceAvail * SPC * CA;
      UserSpaceAvail := TotalSpaceAvail;
    end;
  end;
end;
{$ENDIF}

function GetFileCreateDate(const FileName : AnsiString) :
  TDateTime;
{-Obtains file system time of file creation.}
{!!.01 - Rewritten}
var
  Rslt : Integer;
  SR : TSearchRec;
  FTime : Integer;
begin
  Result := 0.0;
  Rslt := FindFirst(FileName, faAnyFile, SR);
  if Rslt = 0 then begin
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM OFF} {$ENDIF}
    FileTimeToDosDateTime(SR.FindData.ftCreationTime,
      LongRec(FTime).Hi, LongRec(FTime).Lo);
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM ON} {$ENDIF}
    Result := FileDateToDateTime(FTime);
    FindClose(SR);
  end;
{!!.01 - End Rewritten}
end;

{GetFileLastAccess}
function GetFileLastAccess(const FileName : AnsiString) :
  TDateTime;
  {-Obtains file system time of last file access.}
{!!.01 - Rewritten}
var
  Rslt : Integer;
  SR : TSearchRec;
  FTime : Integer;
begin
  Result := 0.0;
  Rslt := FindFirst(FileName, faAnyFile, SR);
  if Rslt = 0 then begin
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM OFF} {$ENDIF}
    FileTimeToDosDateTime(SR.FindData.ftLastAccessTime,
      LongRec(FTime).Hi, LongRec(FTime).Lo);
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM ON} {$ENDIF}
    Result := FileDateToDateTime(FTime);
    FindClose(SR);
  end;
{!!.01 - End Rewritten}
end;

{GetFileLastModify}
function GetFileLastModify(const FileName : AnsiString) :
  TDateTime;
  {-Obtains file system time of last file modification.}
{!!.01 - Rewritten}
var
  Rslt : Integer;
  SR : TSearchRec;
  FTime : Integer;
begin
  Result := 0.0;
  Rslt := FindFirst(FileName, faAnyFile, SR);
  if Rslt = 0 then begin
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM OFF} {$ENDIF}
    FileTimeToDosDateTime(SR.FindData.ftLastWriteTime,
      LongRec(FTime).Hi, LongRec(FTime).Lo);
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM ON} {$ENDIF}
    Result := FileDateToDateTime(FTime);
    FindClose(SR);
  end;
{!!.01 - End Rewritten}
end;

{GetHomeFolder}
function GetHomeFolder(aForceSlash : boolean) : AnsiString;
{-Obtains the "Home Folder" for the current user}
var
  Size   : integer;
  Path   : AnsiString;
  Buffer : PAnsiChar;
begin
  Size := GetEnvironmentVariable('HOMEDRIVE', nil, 0);
  GetMem(Buffer, Size);
  try
    SetString(Result, Buffer, GetEnvironmentVariable('HOMEDRIVE',
      Buffer, Size));
  finally
    FreeMem(Buffer);
  end;

  Size := GetEnvironmentVariable('HOMEPATH', nil, 0);
  GetMem(Buffer, Size);
  try
    SetString(Path, Buffer, GetEnvironmentVariable('HOMEPATH',
      Buffer, Size));
  finally
    FreeMem(Buffer);
  end;

  if Path = '' then
    Path := GetWorkingFolder(aForceSlash);

  if aForceSlash and (Result[length(Result)] <> StDosPathDelim) then
    Path := Path + StDosPathDelim;
  if (Path[1] <> StDosPathDelim) then
    Result := Result + StDosPathDelim + Path
  else
    Result := Result + Path;
end;

function GetLongPathName(lpszShortPath: PAnsiChar; lpszLongPath: PAnsiChar;
  cchBuffer: DWORD): DWORD;
var
  PathBuf : PAnsiChar;
  Len, i : Integer;
  FD : TWIN32FindData;
  FH : THandle;
  ResBuf : AnsiString;
begin
  if not Assigned(lpszShortPath) then begin
    SetLastError(ERROR_INVALID_PARAMETER);
    Result := 0;
    Exit;
  end;

  { Check whether the input path is valid. }
  if (GetFileAttributes(lpszShortPath) = $FFFFFFFF) then begin
    Result := 0;
    Exit;
  end;

  Len := StrLen(lpszShortPath);
  GetMem(PathBuf, Len + 1);

  try
    StrCopy(PathBuf, lpszShortPath);
    ResBuf := '';

    i := 0;
    { Check for Drive Letter }
    if (IsCharAlpha(PathBuf[0])) and (PathBuf[1] = DriveDelim) and (Len > 3) then begin
      repeat
        ResBuf := ResBuf + PathBuf[i];
        Inc(i);
      until PathBuf[i] = StPathDelim;
      ResBuf := ResBuf + StPathDelim;
    end;

    { Check for UNC Path }
    if (PathBuf[0] = StPathDelim) and (PathBuf[1] = StPathDelim) then begin
      { extract machine name }
      ResBuf := '\\';
      i := 2;
      repeat
        ResBuf := ResBuf + PathBuf[i];
        Inc(i);
      until PathBuf[i] = StPathDelim;
      ResBuf := ResBuf + StPathDelim;
      Inc(i);

      { extract share name }
      repeat
        ResBuf := ResBuf + PathBuf[i];
        Inc(i);
      until PathBuf[i] = StPathDelim;
      ResBuf := ResBuf + StPathDelim;
      Inc(i);
    end;

    { move past current delimiter }                                 {!!.01}
    Inc(i);                                                         {!!.01}

    { find next occurrence of path delimiter }
    while i < Len do begin
      if (PathBuf[i] = StPathDelim) then begin
        PathBuf[i] := #0;
        FH := FindFirstFile(PathBuf, FD);
        if FH <> INVALID_HANDLE_VALUE then begin
          ResBuf := ResBuf + StrPas(FD.cFileName) + StPathDelim;
          Windows.FindClose(FH);
        end;
        PathBuf[i] := StPathDelim;

      end;
      Inc(i);
    end;

    { one mo' time for the entire string: }
    FH := FindFirstFile(PathBuf, FD);
    if FH <> INVALID_HANDLE_VALUE then begin
      ResBuf := ResBuf + StrPas(FD.cFileName);
      Windows.FindClose(FH);
    end;

    Result := Length(ResBuf);

    if Assigned(lpszLongPath) and (cchBuffer >= DWord(Length(ResBuf))) then begin
      StrPCopy(lpszLongPath, ResBuf);
    end;
  finally
    FreeMem(PathBuf, Len + 1);
  end;
end;

{GetLongPath}
function GetLongPath(const APath : AnsiString) : AnsiString;
{-Returns the long filename version of a provided path.}
var
  Size   : integer;
  Buffer : PAnsiChar;
begin
  Buffer := nil;
  Size := GetLongPathName(PAnsiChar(APath), Buffer, 0);
  GetMem(Buffer, Size + 1);
  try
    SetString(Result, Buffer, GetLongPathName(PAnsiChar(APath), Buffer, Size));
  finally
    if Assigned(Buffer) then
      FreeMem(Buffer, Size + 1);
  end;
end;

{GetMachineName}
function GetMachineName : AnsiString;
{-Returns the "Machine Name" for the current computer }
var
  Size : DWORD;
  MachineNameZ : array [0..MAX_COMPUTERNAME_LENGTH] of AnsiChar;
begin
  Size := sizeof(MachineNameZ);
  if not GetComputerName(MachineNameZ, Size) then
{$IFDEF Version6}
    RaiseLastOSError;
{$ELSE}
    RaiseLastWin32Error;
{$ENDIF}
//  SetString(Result, MachineNameZ, Size);                            {!!.02}
  SetString(Result, MachineNameZ, StrLen(MachineNameZ));              {!!.02}
end;

{GetMediaID}
function GetMediaID(Drive : AnsiChar; var MediaIDRec : MediaIDType) : Cardinal;
{-Get the media information (Volume Label, Serial Number) for the specified drive}
var
  VolBuf, FSNameBuf : PAnsiChar;
  VolSiz, FSNSiz : Integer;
  Root : AnsiString;
  SN, ML, Flags : DWORD;
begin
  VolSiz := SizeOf(MediaIDRec.VolumeLabel) + 1;
  FSNSiz := SizeOf(MediaIDRec.FileSystemID) + 1;

  Root := AnsiChar(Upcase(Drive)) + ':\';

  VolBuf := nil;
  FSNameBuf := nil;

  try
    GetMem(VolBuf,  VolSiz);
    GetMem(FSNameBuf, FSNSiz);
    Result := 0;
    if GetVolumeInformation(PAnsiChar(Root), VolBuf, VolSiz, @SN, ML, Flags, FSNameBuf, FSNSiz) then begin
      StrCopy(MediaIDRec.FileSystemID, FSNameBuf);
      StrCopy(MediaIDRec.VolumeLabel, VolBuf);
      MediaIDRec.SerialNumber := SN;

    end else
      Result := GetLastError;
  finally
    if Assigned(VolBuf) then
      FreeMem(VolBuf, VolSiz);
    if Assigned(FSNameBuf) then
      FreeMem(FSNameBuf, FSNSiz);
  end;
end;

{!!.02 -- Added }
function StAddBackSlash(const DirName : string) : string;
{ Add a default slash to a directory name }
const
  DelimSet : set of Char = [StPathDelim, ':', #0];
begin
  Result := DirName;
  if Length(DirName) = 0 then
    Exit;
  if not (DirName[Length(DirName)] in DelimSet) then
    Result := DirName + StPathDelim;
end;
{!!.02 -- End Added }

{GetParentFolder}
function GetParentFolder(const APath : AnsiString; aForceSlash : Boolean) : AnsiString;
{-return the parent directory for the provided directory }
begin
  Result := ExpandFileName(StAddBackSlash(APath) + StParentDir);   {!!.02}
  if aForceSlash and (Result[length(Result)] <> StDosPathDelim) then
    Result := Result + StDosPathDelim;
end;

{GetShortPath}
function GetShortPath(const APath : AnsiString) : AnsiString;
{-Returns the short filename version of a provided path.}
var
  Size   : integer;
  Buffer : PAnsiChar;
begin
  Buffer := nil;
  Size := GetShortPathName(PAnsiChar(APath), Buffer, 0);
  GetMem(Buffer, Size);
  try
    SetString(Result, Buffer, GetShortPathName(PAnsiChar(APath), Buffer, Size));
  finally
    if Assigned(Buffer) then
      FreeMem(Buffer);
  end;
end;

{GetSystemFolder}
function GetSystemFolder(aForceSlash : boolean) : AnsiString;
{-Returns the path to the Windows "System" folder".}
var
  Size   : integer;
  Buffer : PAnsiChar;
begin
  Size := GetSystemDirectory(nil, 0);
  GetMem(Buffer, Size);
  try
    SetString(Result, Buffer, GetSystemDirectory(Buffer, Size));
  finally
    FreeMem(Buffer);
  end;
  if aForceSlash and (Result[length(Result)] <> StDosPathDelim) then
    Result := Result + StDosPathDelim;
end;

{GetTempFolder}
function GetTempFolder(aForceSlash : boolean) : AnsiString;
{-Returns the path to the system temporary folder.}
var
  Size   : integer;
  Buffer : PAnsiChar;
begin
  Size := GetTempPath(0, nil);
  GetMem(Buffer, Size);
  try
    SetString(Result, Buffer, GetTempPath(Size, Buffer));
  finally
    FreeMem(Buffer);
  end;
  if aForceSlash and (Result[length(Result)] <> StDosPathDelim) then
    Result := Result + StDosPathDelim;
end;

{GetWindowsFolder}
function GetWindowsFolder(aForceSlash : boolean) : AnsiString;
{-Returns the path to the main "Windows" folder.}
var
  Size   : integer;
  Buffer : PAnsiChar;
begin
  Size := GetWindowsDirectory(nil, 0);
  GetMem(Buffer, Size);
  try
    SetString(Result, Buffer, GetWindowsDirectory(Buffer, Size));
  finally
    FreeMem(Buffer);
  end;
  if aForceSlash and (Result[length(Result)] <> StDosPathDelim) then
    Result := Result + StDosPathDelim;
end;

{GetWorkingFolder}
function GetWorkingFolder(aForceSlash : boolean) : AnsiString;
{-Returns the current working directory.}
begin
  Result := ExpandFileName(StThisDir);
  if aForceSlash and (Result[length(Result)] <> StDosPathDelim) then
    Result := Result + StDosPathDelim;
end;

{GlobalDateTimeToLocal}
function GlobalDateTimeToLocal(const UTC: TStDateTimeRec; MinOffset: Integer): TStDateTimeRec; {!!.02}
{-adjusts a global date/time (UTC) to the local date/time}
{$IFNDEF VERSION4}
const
  TIME_ZONE_ID_INVALID  = DWORD($FFFFFFFF);
  TIME_ZONE_ID_UNKNOWN  = 0;
  TIME_ZONE_ID_STANDARD = 1;
  TIME_ZONE_ID_DAYLIGHT = 2;
{$ENDIF}
var
  Minutes : LongInt;
  TZ : TTimeZoneInformation;
begin
  Minutes := (UTC.D * MinutesInDay) + (UTC.T div 60);
  case GetTimeZoneInformation(TZ) of
    TIME_ZONE_ID_UNKNOWN :
      Minutes := Minutes - TZ.Bias;
    TIME_ZONE_ID_INVALID :
      Minutes := Minutes - MinOffset;
    TIME_ZONE_ID_STANDARD:
      Minutes := Minutes - (TZ.Bias + TZ.StandardBias);
    TIME_ZONE_ID_DAYLIGHT:
      Minutes := Minutes - (TZ.Bias + TZ.DaylightBias);
  end;

  Result.D := (Minutes div MinutesInDay);
  Result.T := ((Minutes mod MinutesInDay) * SecondsInMinute) + (UTC.T mod SecondsInMinute);
end;

{IsDirectory}
function IsDirectory(const DirName : AnsiString) : Boolean;
{-Return true if DirName is a directory}
var
  Attrs : DWORD;                                                         {!!.01}
begin
  Result := False;
    Attrs := GetFileAttributes(PAnsiChar(DirName));
  if Attrs <> DWORD(-1) then                                             {!!.01}
    Result := (FILE_ATTRIBUTE_DIRECTORY and Attrs <> 0);
end;

{IsDirectoryEmpty}
function IsDirectoryEmpty(const S : AnsiString) : Integer;
{-checks if there are any entries in the directory}
var
  SR : TSearchRec;
  R  : Integer;
  DS : AnsiString;
begin
  Result := 1;
  if IsDirectory(S) then begin
 {$IFOPT H+}
    DS := AddBackSlashL(S);
 {$ELSE}
    DS := AddBackSlashS(S);
 {$ENDIF}
    R := Abs(FindFirst(DS + StDosAnyFile, faAnyFile, SR));
    if R <> 18 then begin
      if (R = 0) then
      repeat
        if (SR.Attr and faDirectory = faDirectory) then begin
          if (SR.Name <> StThisDir) and (SR.Name <> StParentDir) then begin
            Result := 0;
            break;
          end;
        end else begin
          Result := 0;
          break;
        end;
        R := Abs(FindNext(SR));
      until R = 18;
    end;
    FindClose(SR);
  end else
    Result := -1;
end;

{IsDriveReady}
function IsDriveReady(Drive : AnsiChar) : Boolean;
{-determine if requested drive is accessible }
var
  Root : AnsiString;
  VolName : PAnsiChar;
  Flags, MaxLength : DWORD;
  NameSize : Integer;
begin
  Result := False;
  NameSize := 0;
  Root := Upcase(Drive) + ':\' ;
  GetMem(VolName, MAX_PATH);

  try
    if GetVolumeInformation(PAnsiChar(Root), VolName, MAX_PATH,
      nil, MaxLength, Flags, nil, NameSize) then
        Result := True;
  finally
    if Assigned(VolName) then
      FreeMem(VolName, MAX_PATH);
  end;
end;

{IsFile}
function IsFile(const FileName : AnsiString) : Boolean;
{-Determines if the provided path specifies a file.}
var
  Attrs : DWORD;                                                    {!!.02}
begin
  Result := False;
  Attrs := GetFileAttributes(PAnsiChar(FileName));
  if Attrs <> DWORD(-1) then                                        {!!.02}
    Result := (Attrs and FILE_ATTRIBUTE_DIRECTORY) <> FILE_ATTRIBUTE_DIRECTORY;
end;

{IsFileArchive}
function IsFileArchive(const S : AnsiString) : Integer;
  {-checks if file's archive attribute is set}
begin
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM OFF} {$ENDIF}
  if FileExists(S) then
    Result := Integer((FileGetAttr(S) and faArchive) = faArchive)
  else
    Result := -1;
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM ON} {$ENDIF}
end;

{IsFileHidden}
function IsFileHidden(const S : AnsiString) : Integer;
  {-checks if file's hidden attribute is set}
begin
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM OFF} {$ENDIF}
  if FileExists(S) then
    Result := Integer((FileGetAttr(S) and faHidden) = faHidden)
  else
    Result := -1;
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM ON} {$ENDIF}
end;

{IsFileReadOnly}
function IsFileReadOnly(const S : AnsiString) : Integer;
  {-checks if file's readonly attribute is set}
begin
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM OFF} {$ENDIF}
  if FileExists(S) then
    Result := Integer((FileGetAttr(S) and faReadOnly) = faReadOnly)
  else
    Result := -1;
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM ON} {$ENDIF}
end;

{IsFileSystem}
function IsFileSystem(const S : AnsiString) : Integer;
  {-checks if file's system attribute is set}
begin
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM OFF} {$ENDIF}
  if FileExists(S) then
    Result := Integer((FileGetAttr(S) and faSysFile) = faSysFile)
  else
    Result := -1;
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM ON} {$ENDIF}
end;

{LocalDateTimeToGlobal}
function LocalDateTimeToGlobal(const DT1: TStDateTimeRec; MinOffset: Integer): TStDateTimeRec; {!!.02}
{-adjusts a local date/time to the global (UTC) date/time}
{$IFNDEF VERSION4}
const
  TIME_ZONE_ID_INVALID  = DWORD($FFFFFFFF);
  TIME_ZONE_ID_UNKNOWN  = 0;
  TIME_ZONE_ID_STANDARD = 1;
  TIME_ZONE_ID_DAYLIGHT = 2;
{$ENDIF}
var
  Minutes : LongInt;
  TZ : TTimeZoneInformation;
begin
  Minutes := (DT1.D * MinutesInDay) + (DT1.T div 60);
  case GetTimeZoneInformation(TZ) of
    TIME_ZONE_ID_UNKNOWN : { Time Zone transition dates not used }
      Minutes := Minutes + TZ.Bias;
    TIME_ZONE_ID_INVALID :
      Minutes := Minutes + MinOffset;
    TIME_ZONE_ID_STANDARD:
      Minutes := Minutes + (TZ.Bias + TZ.StandardBias);
    TIME_ZONE_ID_DAYLIGHT:
      Minutes := Minutes + (TZ.Bias + TZ.DaylightBias);
  end;

  Result.D := (Minutes div MinutesInDay);
  Result.T := ((Minutes mod MinutesInDay) * SecondsInMinute) + (DT1.T mod SecondsInMinute);
end;

{ReadVolumeLabel}
function ReadVolumeLabel(var VolName : AnsiString; Drive : AnsiChar) : Cardinal;
{-Get the volume label for the specified drive.}
var
  Root : AnsiString;
  Flags, MaxLength : DWORD;
  NameSize : Integer;
begin
  NameSize := 0;
  Root := Drive + ':\';
  if Length(VolName) < 12 then
    SetLength(VolName, 12);
  if GetVolumeInformation(PAnsiChar(Root), PChar(VolName), Length(VolName),
    nil, MaxLength, Flags, nil, NameSize)
  then begin
    SetLength(VolName, StrLen(PAnsiChar(VolName)));
    Result := 0;
  end
  else begin
    VolName := '';
    Result := GetLastError;
  end;
end;

{SameFile}
function SameFile(const FilePath1, FilePath2 : AnsiString;
                  var ErrorCode : Integer) : Boolean;
  {-Return true if FilePath1 and FilePath2 refer to the same physical file.
    Error codes:
      0 - Success (no error)
      1 - Invalid FilePath1
      2 - Invalid FilePath2
      3 - Error on FileSetAttr/FileGetAttr }
var
  Attr1, Attr2, NewAttr : Integer;


  function DirectoryExists(const Name : AnsiString): Boolean;
  var
    Code : DWORD;                                                      {!!.02}
    Buf  : array[0..MAX_PATH] of AnsiChar;                             {!!.01}
  begin
    StrPLCopy(Buf, Name, SizeOf(Buf)-1);
    Code := GetFileAttributes(Buf);
    Result := (Code <> DWORD(-1)) and                                  {!!.02}
      (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);                        {!!.02}
  end;

begin
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM OFF} {$ENDIF}
  Result := False;
  ErrorCode := 0;
  Attr1 := FileGetAttr(FilePath1);
  if Attr1 < 0 then begin
    ErrorCode := 1;
    Exit;
  end;
  Attr2 := FileGetAttr(FilePath2);
  if Attr2 < 0 then begin
    {leave ErrorCode at 0 if file not found but path is valid}
    if not DirectoryExists(ExtractFilePath(FilePath2)) then
      ErrorCode := 2;
    Exit;
  end;
  if Attr1 <> Attr2 then
    Exit;
  if ((Attr1 and faArchive) = 0) then
    NewAttr := Attr1 or faArchive
  else
    NewAttr := Attr1 and (not faArchive);
  if FileSetAttr(FilePath1, NewAttr) <> 0 then begin
    ErrorCode := 3;
    Exit;
  end;
  Attr2 := FileGetAttr(FilePath2);
  if Attr2 < 0 then
    ErrorCode := 3;

  Result := (Attr2 = NewAttr) or (Attr2 = $80);
  { If the attribute is set to $00, Win32 automatically sets it to $80. }

  if FileSetAttr(FilePath1, Attr1) <> 0 then
    ErrorCode := 3;
{$IFDEF Version6} {$WARN SYMBOL_PLATFORM ON} {$ENDIF}
end;

{SetMediaID} {!!!! Does not work on NT/2000 !!!!}
function SetMediaID(Drive : AnsiChar; var MediaIDRec : MediaIDType) : Cardinal;
{-Set the media ID record for the specified drive.}
type
  DevIOCtlRegisters = record
    reg_EBX : LongInt;
    reg_EDX : LongInt;
    reg_ECX : LongInt;
    reg_EAX : LongInt;
    reg_EDI : LongInt;
    reg_ESI : LongInt;
    reg_Flags : LongInt;
  end;
var
  PMid : PMediaIDType;
  Regs : DevIOCtlRegisters;
  CB   : DWord;
  HDevice : THandle;
  SA   : TSecurityAttributes;
begin
  PMid := @MediaIDRec;
  with SA do begin
    nLength := SizeOf(SA);
    lpSecurityDescriptor := nil;
    bInheritHandle := True;
  end;
  with Regs do begin
    reg_EAX := $440D;
    reg_EBX := Ord(UpCase(Drive)) - (Ord('A') - 1);
    reg_ECX := $0846;
    reg_EDX := LongInt(PMid);
  end;
  HDevice := CreateFile('\\.\vwin32', GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,
    Pointer(@SA), OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if HDevice <> INVALID_HANDLE_VALUE then begin
    if DeviceIOControl(HDevice, VWIN32_DIOC_DOS_IOCTL, Pointer(@Regs), SizeOf(Regs),
      Pointer(@Regs), SizeOf(Regs), CB, nil)
    then
      Result := 0
    else
      Result := GetLastError;
    CloseHandle(HDevice);
  end else
    Result := GetLastError;
end;

{SplitPath}
procedure SplitPath(const APath : AnsiString; Parts : TStrings);
{-Splits the provided path into its component sub-paths}
var
  i : Integer;
  iStart : Integer;
  iStartSlash : Integer;
  Path, SubPath : AnsiString;
begin
  Path := APath;
  if Path = '' then Exit;
  if not Assigned(Parts) then Exit;

  if Path[ Length( Path ) ] = StPathDelim then
    Delete( Path, Length( APath ), 1 );
  iStart := 1;
  iStartSlash := 1;
  repeat
    {find the Slash at iStartSlash}
    i := FindNthSlash( Path, iStartSlash );
    {get the subpath}
    SubPath := Copy( Path, iStart, i - iStart + 1 );
    iStart := i + 2;
    inc( iStartSlash );
    Parts.Add( SubPath );
  until ( i = Length( Path ) );
end;

{StDateTimeToFileTime}
function StDateTimeToFileTime(const FileTime : TStDateTimeRec) : LongInt;  {!!.02}
{-Converts an TStDate and TStTime to a DOS date-time value.}
var
  DDT : TDateTime;
begin
  DDT := Int(StDateToDateTime(FileTime.D)) + Frac(StTimeToDateTime(FileTime.T));
  Result := DateTimeToFileDate(DDT);
end;

{StDateTimeToUnixTime}
function StDateTimeToUnixTime(const DT1 : TStDateTimeRec) : Longint;   {!!.02}
{-converts a TStDateTimeRec to a time in Unix base (1970)}
begin
  Result := ((DT1.D - Date1970) * SecondsInDay) + DT1.T;
end;

{UnixTimeToStDateTime}
function UnixTimeToStDateTime(UnixTime : Longint) : TStDateTimeRec;
{-converts a time in Unix base (1970) to a TStDateTimeRec}
begin
  Result.D := Date1970 + (UnixTime div SecondsInDay);
  Result.T := UnixTime mod SecondsInDay;
end;

{ValidDrive}
function ValidDrive(Drive : AnsiChar) : Boolean;
{-Determine if the drive is a valid drive.}
var
  DriveBits : LongInt;
  DriveLtr : AnsiChar;
begin
  DriveLtr := UpCase(Drive);
  DriveBits := GetLogicalDrives shr (Ord(DriveLtr)-Ord('A'));
  Result := LongFlagIsSet(DriveBits, $00000001);
end;

{WriteVolumeLabel}
function WriteVolumeLabel(const VolName : AnsiString; Drive : AnsiChar) : Cardinal;
{-Sets the volume label for the specified drive.}
var
  Temp : AnsiString;
  Vol : array[0..11] of AnsiChar;
  Root : array[0..3] of AnsiChar;
begin
  Temp := VolName;
  StrCopy(Root, '%:\');
  Root[0] := Drive;
  if Length(Temp) > 11 then
    SetLength(Temp, 11);
  StrPCopy(Vol, Temp);
  if Windows.SetVolumeLabel(Root, Vol) then
    Result := 0
  else Result := GetLastError;
end;


end.







