{
 /***************************************************************************
                               fileutil.pas
                               ------------

 ***************************************************************************/

 *****************************************************************************
  This file is part of the LazUtils package.

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}

{ ****************************************************************************
BB: 2013-05-19

Note to developers:

This unit should contain functions and procedures to
maintain compatibility with Delphi's FileUtil unit.

File routines that specifically deal with UTF8 filenames should go into
the LazFileUtils unit.

***************************************************************************** }
unit FileUtil;

//{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazMasks {, LazFileUtils};
  

const
  UTF8FileHeader = #$ef#$bb#$bf;
  FilenamesCaseSensitive = {$IFDEF CaseInsensitiveFilenames}false{$ELSE}true{$ENDIF};// lower and upper letters are treated the same
  FilenamesLiteral = {$IFDEF NotLiteralFilenames}false{$ELSE}true{$ENDIF};// file names can be compared using = string operator
  AllFilesMask = '*';
  //feInvalidHandle: THandle = (-1);



(*TMaskList = class
  private
    FMasks: TObjectList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TMask;
  public
    constructor Create(const AValue: String; ASeparator: Char = ';'; const CaseSensitive: Boolean = False);
    destructor Destroy; override;

    function Matches(const AFileName: String): Boolean;
    function MatchesWindowsMask(const AFileName: String): Boolean;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TMask read GetItem;
  end;*)

// file attributes and states
function CompareFilenames(const Filename1, Filename2: string): integer; inline;
function CompareFilenamesIgnoreCase(const Filename1, Filename2: string): integer; inline;
function CompareFilenames2(const Filename1, Filename2: string;
                          ResolveLinks: boolean): integer;
function CompareFilenamesP(Filename1: PChar; Len1: integer;
  Filename2: PChar; Len2: integer; ResolveLinks: boolean): integer;
function FilenameIsAbsolute(const TheFilename: string):boolean; inline;
function FilenameIsWinAbsolute(const TheFilename: string):boolean; inline;
function FilenameIsUnixAbsolute(const TheFilename: string):boolean; inline;
procedure CheckIfFileIsExecutable(const AFilename: string); inline;
procedure CheckIfFileIsSymlink(const AFilename: string); inline;
function FileIsReadable(const AFilename: string): boolean; inline;
function FileIsWritable(const AFilename: string): boolean; inline;
function FileIsText(const AFilename: string): boolean; inline;
function FileIsText2(const AFilename: string; out FileReadable: boolean): boolean; inline;
function FileIsExecutable(const AFilename: string): boolean; inline;
function FileIsSymlink(const AFilename: string): boolean; inline;
function FileIsHardLink(const AFilename: string): boolean; inline;
function FileSize(const Filename: string): int64; overload; inline;
function GetFileDescription(const AFilename: string): string; inline;
//function ReadAllLinks(const Filename: string;
  //                    ExceptionOnError: boolean): string; // if a link is broken returns ''
function TryReadAllLinks(const Filename: string): string; // if a link is broken returns Filename

// directories
function DirPathExists(const FileName: String): Boolean; inline;
function ForceDirectory(DirectoryName: string): boolean; inline;
function DeleteDirectory(const DirectoryName: string; OnlyChildren: boolean): boolean;
function ProgramDirectory: string;
function DirectoryIsWritable(const DirectoryName: string): boolean; inline;

// filename parts
const
  PascalFileExt: array[1..3] of string = ('.pas','.pp','.p');

function ExtractFileNameOnly(const AFilename: string): string; inline;
function ExtractFileNameWithoutExt(const AFilename: string): string;
function CompareFileExt(const Filename, Ext: string; CaseSensitive: boolean): integer; overload; inline;
//function CompareFileExt(const Filename, Ext: string): integer; overload; inline;
function FilenameIsPascalUnit(const Filename: string): boolean;
function AppendPathDelim(const Path: string): string; inline;
function ChompPathDelim(const Path: string): string; inline;
function TrimFilename(const AFilename: string): string; inline;
function CleanAndExpandFilename(const Filename: string): string; inline;
function CleanAndExpandDirectory(const Filename: string): string; inline;
function CreateAbsoluteSearchPath(const SearchPath, BaseDirectory: string): string;
function CreateRelativePath(const Filename, BaseDirectory: string;
                            UsePointDirectory: boolean = false; AlwaysRequireSharedBaseFolder: Boolean = True): string; inline;
function CreateAbsolutePath(const Filename, BaseDirectory: string): string;
function FileIsInPath(const Filename, Path: string): boolean;
function FileIsInDirectory(const Filename, Directory: string): boolean;

// file search
type
  TSearchFileInPathFlag = (
    sffDontSearchInBasePath,
    sffSearchLoUpCase
    );
  TSearchFileInPathFlags = set of TSearchFileInPathFlag;

const
  AllDirectoryEntriesMask = '*';
  
function GetAllFilesMask: string; inline;
function GetExeExt: string; inline;
function SearchFileInPath(const Filename, BasePath, SearchPath,
  Delimiter: string; Flags: TSearchFileInPathFlags): string;
function SearchAllFilesInPath(const Filename, BasePath, SearchPath,
  Delimiter: string; Flags: TSearchFileInPathFlags): TStrings;
function FindDiskFilename(const Filename: string): string;
function FindDiskFileCaseInsensitive(const Filename: string): string;
function FindDefaultExecutablePath(const Executable: string; const BaseDir: string = ''): string;
{$IFDEF darwin}
function GetDarwinSystemFilename(Filename: string): string; inline;
{$ENDIF}

type

  { TFileIterator }

  TFileIterator = class
  private
    FPath: String;
    FLevel: Integer;
    FFileInfo: TSearchRec;
    FSearching: Boolean;
    function GetFileName: String;
  public
    procedure Stop;

    function IsDirectory: Boolean;
  public
    property FileName: String read GetFileName;
    property FileInfo: TSearchRec read FFileInfo;
    property Level: Integer read FLevel;
    property Path: String read FPath;

    property Searching: Boolean read FSearching;
  end;

  TFileFoundEvent = procedure (FileIterator: TFileIterator) of object;
  TDirectoryFoundEvent = procedure (FileIterator: TFileIterator) of object;
  TDirectoryEnterEvent = procedure (FileIterator: TFileIterator) of object;

  { TFileSearcher }


  TFileSearcher = class(TFileIterator)
  private
    FMaskSeparator: char;
    FFollowSymLink: Boolean;
    FOnFileFound: TFileFoundEvent;
    FOnDirectoryFound: TDirectoryFoundEvent;
    FOnDirectoryEnter: TDirectoryEnterEvent;
    FFileAttribute: Word;
    FDirectoryAttribute: Word;
    procedure RaiseSearchingError;
  protected
    procedure DoDirectoryEnter; virtual;
    procedure DoDirectoryFound; virtual;
    procedure DoFileFound; virtual;
  public
    constructor Create;
    procedure Search(const ASearchPath: String; ASearchMask: String = '';
      ASearchSubDirs: Boolean = True; CaseSensitive: Boolean = False);
  public
    property MaskSeparator: char read FMaskSeparator write FMaskSeparator;
    property FollowSymLink: Boolean read FFollowSymLink write FFollowSymLink;
    property FileAttribute: Word read FFileAttribute write FFileAttribute default faAnyfile;
    property DirectoryAttribute: Word read FDirectoryAttribute write FDirectoryAttribute default faDirectory;
    property OnDirectoryFound: TDirectoryFoundEvent read FOnDirectoryFound write FOnDirectoryFound;
    property OnFileFound: TFileFoundEvent read FOnFileFound write FOnFileFound;
    property OnDirectoryEnter: TDirectoryEnterEvent read FOnDirectoryEnter write FOnDirectoryEnter;
  end;

type

  { TListFileSearcher }

  TListFileSearcher = class(TFileSearcher)
  private
    FList: TStrings;
  protected
    procedure DoFileFound; override;
  public
    constructor Create(AList: TStrings);
  end;

type

  { TListDirectoriesSearcher }

  TListDirectoriesSearcher = class(TFileSearcher)
  private
    FDirectoriesList :TStrings;
  protected
    procedure DoDirectoryFound; override;
  public
    constructor Create(AList: TStrings);
  end;


 // flags for copy
type
  TCopyFileFlag = (
    cffOverwriteFile,
    cffCreateDestDirectory,
    cffPreserveTime
    );
  TCopyFileFlags = set of TCopyFileFlag;


 { TCopyDirTree for CopyDirTree function }
type
  TCopyDirTree = class(TFileSearcher)
  public
    FSourceDir: string;
    FTargetDir: string;
    FFlags: TCopyFileFlags;
    FCopyFailedCount:Integer;
  protected
    procedure DoFileFound; override;
    procedure DoDirectoryFound; override;
  end;

  


function FindAllFiles(const SearchPath: String; SearchMask: String = '';
  SearchSubDirs: Boolean = True): TStringList;
function FindAllDirectories(const SearchPath: string;
  SearchSubDirs: Boolean = True): TStringList;


// Copy a file and a whole directory tree
function CopyFile(const SrcFilename, DestFilename: string;
                  Flags: TCopyFileFlags=[cffOverwriteFile]): boolean;
function CopyFile2(const SrcFilename, DestFilename: string; PreserveTime: boolean): boolean;
function CopyDirTree(const SourceDir, TargetDir: string; Flags: TCopyFileFlags=[]): Boolean;

// file actions
function ReadFileToString(const Filename: string): string;
function GetTempFilename(const Directory, Prefix: string): string; inline;

// basic functions similar to the RTL but working with UTF-8 instead of the
// system encoding

// AnsiToUTF8 and UTF8ToAnsi need a widestring manager under Linux, BSD, MacOSX
// but normally these OS use UTF-8 as system encoding so the widestringmanager
// is not needed.
(*function NeedRTLAnsi: boolean; inline;// true if system encoding is not UTF-8
procedure SetNeedRTLAnsi(NewValue: boolean); inline;
function UTF8ToSys(const s: string): string; inline;// as UTF8ToAnsi but more independent of widestringmanager
function SysToUTF8(const s: string): string; inline;// as AnsiToUTF8 but more independent of widestringmanager
function ConsoleToUTF8(const s: string): string; inline;// converts OEM encoded string to UTF8 (used with some Windows specific functions)
function UTF8ToConsole(const s: string): string; inline;// converts UTF8 string to console encoding (used by Write, WriteLn)*)

// file operations
function FileExistsUTF8(const Filename: string): boolean; inline;
function FileAgeUTF8(const FileName: string): Longint; inline;
function DirectoryExistsUTF8(const Directory: string): Boolean; inline;
function ExpandFileNameUTF8(const FileName: string): string; inline;
function ExpandUNCFileNameUTF8(const FileName: string): string;
//function ExtractShortPathNameUTF8(Const FileName : String) : String;
function FindFirstUTF8(const Path: string; Attr: Longint; out Rslt: TSearchRec): Longint; inline;
function FindNextUTF8(var Rslt: TSearchRec): Longint; inline;
procedure FindCloseUTF8(var F: TSearchrec); inline;
function FileSetDateUTF8(const FileName: String; Age: Longint): Longint; inline;
function FileGetAttrUTF8(const FileName: String): Longint; inline;
function FileSetAttrUTF8(const Filename: String; Attr: longint): Longint; inline;
function DeleteFileUTF8(const FileName: String): Boolean; inline;
function RenameFileUTF8(const OldName, NewName: String): Boolean; inline;
function FileSearchUTF8(const Name, DirList : String; ImplicitCurrentDir : Boolean = True): String; inline;
function FileIsReadOnlyUTF8(const FileName: String): Boolean; inline;
function GetCurrentDirUTF8: String; inline;
function SetCurrentDirUTF8(const NewDir: String): Boolean; inline;
function CreateDirUTF8(const NewDir: String): Boolean; inline;
function RemoveDirUTF8(const Dir: String): Boolean; inline;
function ForceDirectoriesUTF8(const Dir: string): Boolean; inline;
function FileOpenUTF8(Const FileName : string; Mode : Integer) : THandle; inline;
function FileCreateUTF8(Const FileName : string) : THandle; overload; inline;
function FileCreateUTF8(Const FileName : string; Rights: Cardinal) : THandle; overload; inline;

// environment
//function ParamStrUTF8(Param: Integer): string; inline;
//function GetEnvironmentStringUTF8(Index: Integer): string; inline;
//function GetEnvironmentVariableUTF8(const EnvVar: string): String; inline;
function GetAppConfigDirUTF8(Global: Boolean; Create: boolean = false): string; inline;
function GetAppConfigFileUTF8(Global: Boolean; SubDir: boolean = false;
  CreateDir: boolean = false): string; inline;

// other
function SysErrorMessageUTF8(ErrorCode: Integer): String; inline;

implementation

uses
  Windows, Strutils, Lazfileutils;


{%MainUnit fileutil.pas}
{******************************************************************************
                                  Fileutil
 ******************************************************************************

 *****************************************************************************
  This file is part of the Lazarus Component Library (LCL)

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}
 

(*function NeedRTLAnsi: boolean;
begin
  Result := LazUtf8.NeedRTLAnsi;
end;

procedure SetNeedRTLAnsi(NewValue: boolean);
begin
  LazUtf8.SetNeedRTLAnsi(NewValue);
end;


function UTF8ToSys(const s: string): string;
begin
  Result := LazUtf8.UTF8ToSys(s);
end;

function SysToUTF8(const s: string): string;
begin
  Result := LazUtf8.SysToUTF8(s);
end;

function ConsoleToUTF8(const s: string): string;// converts OEM encoded string to UTF8 (used with some Windows specific functions)
begin
  Result := LazUtf8.ConsoleToUTF8(s);
end;

function UTF8ToConsole(const s: string): string;// converts UTF8 string to console encoding (used by Write, WriteLn)
begin
  Result := LazUtf8.UTF8ToConsole(s);
end;

function ParamStrUTF8(Param: Integer): string;
begin
  Result := LazUtf8.ParamStrUTF8(Param);
end;

function GetEnvironmentStringUTF8(Index: Integer): string;
begin
  Result := LazUtf8.GetEnvironmentStringUTF8(Index);
end;

function GetEnvironmentVariableUTF8(const EnvVar: string): String;
begin
  Result := LazUtf8.GetEnvironmentVariableUTF8(EnvVar);
end; *)

function FileGetAttrUTF8(const FileName: String): Longint;
begin
  Result:= FileGetAttr(FileName);
end;

function FileSetAttrUTF8(const Filename: String; Attr: longint): Longint;
begin
  //Result := LazFileUtils.FileSetAttrUtf8(Filename, Attr);
  Result:= FileSetAttr(Filename, Attr);
end;

function FileExistsUTF8(const Filename: string): boolean;
begin
  //Result := LazFileUtils.FileExistsUTF8(FileName);
  Result:= FileExists(FileName);

  end;

function DirectoryExistsUTF8(const Directory: string): Boolean; inline;
begin
  //Result := LazFileUtils.DirectoryExistsUTF8(Directory);
    Result:= DirectoryExists(Directory);

  end;

function FileAgeUTF8(const FileName: string): Longint;
begin
  //Result := LazFileUtils.FileAgeUTF8(FileName);
  Result:= FileAge(FileName);

  end;

function FileSetDateUTF8(const FileName: String; Age: Longint): Longint;
begin
  //Result := LazFileUtils.FileSetDateUTF8(FileName, Age);
  Result:= FileSetDate(FileName, Age);

  end;

function FileSize(const Filename: string): int64;
begin
  Result:= FileSize(FileName);
end;

function GetFileDescription(const AFilename: string): string;
begin
  Result:= LazFileUtils.GetFileDescription(AFilename);
end;

{$IFDEF darwin}
function GetDarwinSystemFilename(Filename: string): string;
begin
  Result := LazFileUtils.GetDarwinSystemFilename(Filename);
end;
{$ENDIF}

function ExpandFileNameUTF8(const FileName: string): string;
begin
  //Result := LazFileUtils.ExpandFileNameUtf8(Filename);
end;

// ToDo: For ExpandUNCFileNameUTF8
//
// Don't convert to and from Sys, because this RTL routines
// simply work in simple string operations, without calling native
// APIs which would really require Ansi
//
// The Ansi conversion just ruins Unicode strings
//
// See bug http://bugs.freepascal.org/view.php?id=20229
// It needs fixing like we did for LazFileUtils.ExpandFileNameUtf8(Filename) on Windows

function ExpandUNCFileNameUTF8(const FileName: string): string;
begin
  Result:=SysUtils.ExpandUNCFileName(Filename);
end;


function FileOpenUTF8(Const FileName : string; Mode : Integer) : THandle;
begin
  Result:= FileOpen(FileName, Mode);
end;

function FileCreateUTF8(Const FileName : string) : THandle;
begin
  Result:= FileCreate(FileName);
end;

function FileCreateUTF8(Const FileName : string; Rights: Cardinal) : THandle;
begin
 Result:= FileCreate(FileName, Rights);
end;

function FindFirstUTF8(const Path: string; Attr: Longint; out Rslt: TSearchRec): Longint;
begin
  Result:= FindFirst(Path, Attr, Rslt);
end;

function FindNextUTF8(var Rslt: TSearchRec): Longint;
begin
 Result:= FindNext(Rslt);
                          //Result := LazFileUtils.FindNextUTF8(Rslt);
end;

procedure FindCloseUTF8(var F: TSearchrec);
begin
  //LazFileUtils.FindCloseUtf8(F);
  Sysutils.FindClose(F);

  end;

function DeleteFileUTF8(const FileName: String): Boolean;
begin
  Result:= sysutils.DeleteFile(FileName);
end;

function RenameFileUTF8(const OldName, NewName: String): Boolean;
begin
  //Result := LazFileUtils.RenameFileUtf8(OldName, NewName);
    Result:= RenameFile(OldName, NewName);

  end;

function GetCurrentDirUTF8: String;
begin
  Result:= GetCurrentDir();
end;

function SetCurrentDirUTF8(const NewDir: String): Boolean;
begin
  Result:= SetCurrentDir(NewDir);
end;

function CreateDirUTF8(const NewDir: String): Boolean;
begin
  //Result := LazFileUtils.CreateDirUtf8(NewDir);
    Result:= CreateDir(NewDir);

  end;

function RemoveDirUTF8(const Dir: String): Boolean;
begin
  //Result := LazFileUtils.RemoveDirUtf8(Dir);
    Result:= RemoveDir(Dir);

  end;



function GetAppConfigDirUTF8(Global: Boolean; Create: boolean = false): string;
begin
  Result := LazFileUtils.GetAppConfigDirUTF8(Global, Create);
end;

function GetAppConfigFileUTF8(Global: Boolean; SubDir: boolean;
  CreateDir: boolean): string;
begin
  Result := LazFileUtils.GetAppConfigFileUTF8(Global, SubDir, CreateDir);
end;

function SysErrorMessageUTF8(ErrorCode: Integer): String;
begin
  //Result := LazUtf8.SysErrorMessageUTF8(ErrorCode);
end;

function DirPathExists(const FileName: String): Boolean;
begin
  Result := LazFileUtils.DirPathExists(FileName);
end;

function CompareFilenames(const Filename1, Filename2: string): integer;
begin
  Result := LazFileUtils.CompareFilenames(Filename1, Filename2);
end;

function CompareFilenamesIgnoreCase(const Filename1, Filename2: string): integer;
begin
  Result := LazFileUtils.CompareFilenamesIgnoreCase(Filename1, Filename2);
end;

function CompareFilenames2(const Filename1, Filename2: string;
  ResolveLinks: boolean): integer;
var
  File1: String;
  File2: String;
begin
  File1:=Filename1;
  File2:=Filename2;
  if ResolveLinks then begin
    //File1:=ReadAllLinks(File1,false);
    if (File1='') then File1:=Filename1;
    //File2:=ReadAllLinks(File2,false);
    if (File2='') then File2:=Filename2;
  end;
  Result:=CompareFilenames(File1,File2);
end;

function CompareFilenamesP(Filename1: PChar; Len1: integer;
  Filename2: PChar; Len2: integer; ResolveLinks: boolean): integer;
var
  File1: string;
  File2: string;
  {$IFNDEF NotLiteralFilenames}
  i: Integer;
  {$ENDIF}
begin
  if (Len1=0) or (Len2=0) then begin
    Result:=Len1-Len2;
    exit;
  end;
  if ResolveLinks then begin
    SetLength(File1,Len1);
    System.Move(Filename1^,File1[1],Len1);
    SetLength(File2,Len2);
    System.Move(Filename2^,File2[1],Len2);
    Result:=CompareFilenames2(File1,File2,true);
  end else begin
    {$IFDEF NotLiteralFilenames}
    SetLength(File1,Len1);
    System.Move(Filename1^,File1[1],Len1);
    SetLength(File2,Len2);
    System.Move(Filename2^,File2[1],Len2);
    Result:=CompareFilenamesP(File1,File2);
    {$ELSE}
    Result:=0;
    i:=0;
    while (Result=0) and ((i<Len1) and (i<Len2)) do begin
      Result:=Ord(Filename1[i])
             -Ord(Filename2[i]);
      Inc(i);
    end;
    if Result=0 Then
      Result:=Len1-Len2;
    {$ENDIF}
  end;
end;

function FilenameIsAbsolute(const TheFilename: string):boolean;
begin
  Result := LazFileUtils.FilenameIsAbsolute(TheFileName);
end;

function FilenameIsWinAbsolute(const TheFilename: string): boolean;
begin
  Result:= LazFileUtils.FilenameIsWinAbsolute(TheFileName);
end;

function FilenameIsUnixAbsolute(const TheFilename: string): boolean;
begin
  Result:= LazFileUtils.FilenameIsUnixAbsolute(TheFileName);
end;

function FilenameIsPascalUnit(const Filename: string): boolean;
var
  i: Integer;
begin
  for i:=Low(PascalFileExt) to High(PascalFileExt) do
    //if CompareFile(Filename,PascalFileExt[i],false)=0 then
      //exit(true);
  Result:=false;
end;

function AppendPathDelim(const Path: string): string;
begin
  Result := LazFileUtils.AppendPathDelim(Path);
end;

function TrimFilename(const AFilename: string): string;
begin
  Result := LazFileUtils.TrimFilename(AFileName);
end;

function ExtractFileNameWithoutExt(const AFilename: string): string;
var
  p: Integer;
begin
  Result:=AFilename;
  p:=length(Result);
  while (p>0) do begin
    case Result[p] of
      PathDelim: exit;
      '.': copy(Result,1, p-1);
    end;
    dec(p);
  end;
end;

function CompareFileExt(const Filename, Ext: string; CaseSensitive: boolean): integer;
begin
  Result := LazFileUtils.CompareFileExt(Filename, Ext, CaseSensitive);
end;

(*function CompareFileExt(const Filename, Ext: string): integer;
begin
  Result := LazFileUtils.CompareFileExt(Filename, Ext);
end;*)

function ChompPathDelim(const Path: string): string;
begin
  Result := LazFileUtils.ChompPathDelim(Path);
end;

function FileIsText(const AFilename: string): boolean;
begin
  Result := LazFileUtils.FileIsText(AFilename);
end;

function FileIsText2(const AFilename: string; out FileReadable: boolean): boolean;
begin
  Result := LazFileUtils.FileIsText2(AFileName, FileReadable);
end;

function FileIsExecutable(const AFilename: string): boolean;
begin
  //Result := LazFileUtils.FileIsExecutable(AFileName);
end;

procedure CheckIfFileIsExecutable(const AFilename: string);
begin
  //LazFileUtils.CheckIfFileIsExecutable(AFileName);
end;

function FileIsSymlink(const AFilename: string): boolean;
begin
  //Result := LazFileUtils.FileIsSymlink(AFilename);
end;

procedure CheckIfFileIsSymlink(const AFilename: string);
begin
  //LazFileUtils.CheckIfFileIsSymlink(AFilename);
end;

function FileIsHardLink(const AFilename: string): boolean;
begin
  //Result := LazFileUtils.FileIsHardLink(AFilename);
end;

function FileIsReadable(const AFilename: string): boolean;
begin
  //Result:= LazFileUtils.FileIsReadable(AFilename);
end;

function FileIsWritable(const AFilename: string): boolean;
begin
  //Result := LazFileUtils.FileIsWritable(AFilename);
end;

function TryReadAllLinks(const Filename: string): string;
begin
  //Result:=ReadAllLinks(Filename,false);
  if Result='' then
    Result:=Filename;
end;

{------------------------------------------------------------------------------
  function ExtractFileNameOnly(const AFilename: string): string;
 ------------------------------------------------------------------------------}
function ExtractFileNameOnly(const AFilename: string): string;
begin
  Result := LazFileUtils.ExtractFileNameOnly(AFilename);
end;

{------------------------------------------------------------------------------
  function ForceDirectory(DirectoryName: string): boolean;
 ------------------------------------------------------------------------------}
function ForceDirectory(DirectoryName: string): boolean;
begin
  Result := LazFileUtils.ForceDirectory(DirectoryName);
end;

{------------------------------------------------------------------------------
  function DeleteDirectory(const DirectoryName: string; OnlyChilds: boolean): boolean;
 ------------------------------------------------------------------------------}
function DeleteDirectory(const DirectoryName: string; OnlyChildren: boolean): boolean;
const
  //Don't follow symlinks on *nix, just delete them
  DeleteMask = faAnyFile {$ifdef unix} or faSymLink {$endif unix};
var
  FileInfo: TSearchRec;
  CurSrcDir: String;
  CurFilename: String;
begin
  Result:=false;
  CurSrcDir:=CleanAndExpandDirectory(DirectoryName);
  if FindFirstUTF8(CurSrcDir+GetAllFilesMask,DeleteMask,FileInfo)=0 then begin
    repeat
      // check if special file
      if (FileInfo.Name='.') or (FileInfo.Name='..') or (FileInfo.Name='') then
        continue;
      CurFilename:=CurSrcDir+FileInfo.Name;
      if ((FileInfo.Attr and faDirectory)>0)
         {$ifdef unix} and ((FileInfo.Attr and faSymLink)=0) {$endif unix} then begin
        if not DeleteDirectory(CurFilename,false) then exit;
      end else begin
        if not DeleteFileUTF8(CurFilename) then exit;
      end;
    until FindNextUTF8(FileInfo)<>0;
  end;
  FindCloseUTF8(FileInfo);
  if (not OnlyChildren) and (not RemoveDirUTF8(CurSrcDir)) then exit;
  Result:=true;
end;

{------------------------------------------------------------------------------
  function ProgramDirectory: string;
 ------------------------------------------------------------------------------}
function ProgramDirectory: string;
var
  Flags: TSearchFileInPathFlags;
begin
  Result:=ParamStr(0);
  if ExtractFilePath(Result)='' then begin
    // program was started via PATH
    {$IFDEF WINDOWS}
    Flags:=[];
    {$ELSE}
    Flags:=[sffDontSearchInBasePath];
    {$ENDIF}
    Result:=SearchFileInPath(Result,'',GetEnvironmentVariable('PATH'),':',Flags);
  end;
  // resolve links
  //Result:=ReadAllLinks(Result,false);
  // extract file path and expand to full name
  Result:=ExpandFileName(ExtractFilePath(Result));
end;

function DirectoryIsWritable(const DirectoryName: string): boolean;
begin
  Result := LazFileUtils.DirectoryIsWritable(DirectoryName);
end;

{------------------------------------------------------------------------------
  function CleanAndExpandFilename(const Filename: string): string;
 ------------------------------------------------------------------------------}
function CleanAndExpandFilename(const Filename: string): string;
begin
  Result := LazFileutils.CleanAndExpandFilename(FileName);
end;

{------------------------------------------------------------------------------
  function CleanAndExpandDirectory(const Filename: string): string;
 ------------------------------------------------------------------------------}
function CleanAndExpandDirectory(const Filename: string): string;
begin
  Result := LazFileUtils.CleanAndExpandDirectory(FileName);
end;

function CreateAbsoluteSearchPath(const SearchPath, BaseDirectory: string
  ): string;
var
  PathLen: Integer;
  EndPos: Integer;
  StartPos: Integer;
  CurDir: String;
  NewCurDir: String;
  DiffLen: Integer;
  BaseDir: String;
begin
  Result:=SearchPath;
  if (SearchPath='') or (BaseDirectory='') then exit;
  BaseDir:=AppendPathDelim(BaseDirectory);

  PathLen:=length(Result);
  EndPos:=1;
  while EndPos<=PathLen do begin
    StartPos:=EndPos;
    while (Result[StartPos]=';') do begin
      inc(StartPos);
      if StartPos>PathLen then exit;
    end;
    EndPos:=StartPos;
    while (EndPos<=PathLen) and (Result[EndPos]<>';') do inc(EndPos);
    CurDir:=copy(Result,StartPos,EndPos-StartPos);
    if not FilenameIsAbsolute(CurDir) then begin
      NewCurDir:=BaseDir+CurDir;
      if NewCurDir<>CurDir then begin
        DiffLen:=length(NewCurDir)-length(CurDir);
        Result:=copy(Result,1,StartPos-1)+NewCurDir
                +copy(Result,EndPos,PathLen-EndPos+1);
        inc(EndPos,DiffLen);
        inc(PathLen,DiffLen);
      end;
    end;
    StartPos:=EndPos;
  end;
end;

function CreateRelativePath(const Filename, BaseDirectory: string;
                            UsePointDirectory: boolean; AlwaysRequireSharedBaseFolder: Boolean): string;
begin
  Result := LazFileUtils.CreateRelativePath(FileName, BaseDirectory, UsePointDirectory, AlwaysRequireSharedBaseFolder);
end;

function CreateAbsolutePath(const Filename, BaseDirectory: string): string;
begin
  if (Filename='') or FilenameIsAbsolute(Filename) then
    Result:=Filename
  {$IFDEF Windows}
  else if (Filename[1]='\') then
    // only use drive of BaseDirectory
    Result:=ExtractFileDrive(BaseDirectory)+Filename
  {$ENDIF}
  else
    Result:=AppendPathDelim(BaseDirectory)+Filename;
  Result:=TrimFilename(Result);
end;

function FileIsInPath(const Filename, Path: string): boolean;
var
  ExpFile: String;
  ExpPath: String;
  l: integer;
begin
  ExpFile:=CleanAndExpandFilename(Filename);
  ExpPath:=CleanAndExpandDirectory(Path);
  l:=length(ExpPath);
  Result:=(l>0) and (length(ExpFile)>l) and (ExpFile[l]=PathDelim)
          and (CompareFilenames(ExpPath,LeftStr(ExpFile,l))=0);
end;

function FileIsInDirectory(const Filename, Directory: string): boolean;
var
  ExpFile: String;
  ExpDir: String;
  LenFile: Integer;
  LenDir: Integer;
  p: LongInt;
begin
  ExpFile:=CleanAndExpandFilename(Filename);
  ExpDir:=CleanAndExpandDirectory(Directory);
  LenFile:=length(ExpFile);
  LenDir:=length(ExpDir);
  p:=LenFile;
  while (p>0) and (ExpFile[p]<>PathDelim) do dec(p);
  Result:=(p=LenDir) and (p<LenFile)
          and (CompareFilenames(ExpDir,LeftStr(ExpFile,p))=0);
end;

function CopyFile(const SrcFilename, DestFilename: String;
                  Flags: TCopyFileFlags=[cffOverwriteFile]): Boolean;
var
  SrcHandle: THandle;
  DestHandle: THandle;
  Buffer: array[1..4096] of byte;
  ReadCount, WriteCount, TryCount: LongInt;
begin
  Result := False;
  // check overwrite
  if (not (cffOverwriteFile in Flags)) and FileExistsUTF8(DestFileName) then
    exit;
  // check directory
  if (cffCreateDestDirectory in Flags)
  and (not DirectoryExistsUTF8(ExtractFilePath(DestFileName)))
  and (not ForceDirectoriesUTF8(ExtractFilePath(DestFileName))) then
    exit;
  TryCount := 0;
  While TryCount <> 3 Do Begin
    SrcHandle := FileOpenUTF8(SrcFilename, fmOpenRead or fmShareDenyWrite);
    if (THandle(SrcHandle)= -1) then Begin
      Inc(TryCount);
      Sleep(10);
    End
    Else Begin
      TryCount := 0;
      Break;
    End;
  End;
  If TryCount > 0 Then
    raise EFOpenError.Createfmt({SFOpenError}'Unable to open file "%s"', [SrcFilename]);
  try
    DestHandle := FileCreateUTF8(DestFileName);
    if (THandle(DestHandle)= -1) then
      raise EFCreateError.createfmt({SFCreateError}'Unable to create file "%s"',[DestFileName]);
    try
      repeat
        ReadCount:=FileRead(SrcHandle,Buffer[1],High(Buffer));
        if ReadCount<=0 then break;
        WriteCount:=FileWrite(DestHandle,Buffer[1],ReadCount);
        if WriteCount<ReadCount then
          raise EWriteError.createfmt({SFCreateError}'Unable to write to file "%s"',[DestFileName])
      until false;
    finally
      FileClose(DestHandle);
    end;
    if (cffPreserveTime in Flags) then
      FileSetDateUTF8(DestFilename, FileGetDate(SrcHandle));
    Result := True;
  finally
    FileClose(SrcHandle);
  end;
end;

function CopyFile2(const SrcFilename, DestFilename: string; PreserveTime: Boolean): boolean;
// Flags parameter can be used for the same thing.
var
  Flags: TCopyFileFlags;
begin
  if PreserveTime then
    Flags:=[cffPreserveTime, cffOverwriteFile]
  else
    Flags:=[cffOverwriteFile];
  Result := CopyFile(SrcFilename, DestFilename, Flags);
end;

{ TCopyDirTree for CopyDirTree function }
(*type
  TCopyDirTree = class(TFileSearcher)
  private
    FSourceDir: string;
    FTargetDir: string;
    FFlags: TCopyFileFlags;
    FCopyFailedCount:Integer;
  protected
    procedure DoFileFound; override;
    procedure DoDirectoryFound; override;
  end;*)

procedure TCopyDirTree.DoFileFound;
var
  NewLoc: string;
begin
  // ToDo: make sure StringReplace works in all situations !
  NewLoc:=StringReplace(FileName, FSourceDir, FTargetDir, []);
  if not CopyFile(FileName, NewLoc, FFlags) then
    Inc(FCopyFailedCount);
end;

procedure TCopyDirTree.DoDirectoryFound;
var
  NewPath:String;
begin
  NewPath:=StringReplace(FileName, FSourceDir, FTargetDir, []);
  // ToDo: make directories also respect cffPreserveTime flag.
  if not DirectoryExistsUTF8(NewPath) then
    if not ForceDirectoriesUTF8(NewPath) then
      Inc(FCopyFailedCount);
end;

function CopyDirTree(const SourceDir, TargetDir: string; Flags: TCopyFileFlags=[]): Boolean;
var
  Searcher: TCopyDirTree;
begin
  Result:=False;
  Searcher:=TCopyDirTree.Create;
  try
    // Destination directories are always created. User setting has no effect!
    Flags:=Flags+[cffCreateDestDirectory];
    Searcher.FFlags:=Flags;
    Searcher.FCopyFailedCount:=0;
    Searcher.FSourceDir:=SourceDir;
    Searcher.FTargetDir:=TargetDir;
    Searcher.Search(SourceDir);
    Result:=True;
  finally
    Result:=Searcher.FCopyFailedCount=0;
    Searcher.Free;
  end;
end;

function GetTempFilename(const Directory, Prefix: string): string;
begin
  Result := LazFileUtils.GetTempFileNameUTF8(Directory, Prefix);
end;

function SearchFileInPath(const Filename, BasePath, SearchPath,
  Delimiter: string; Flags: TSearchFileInPathFlags): string;
var
  p, StartPos, l: integer;
  CurPath, Base: string;
begin
//debugln('[SearchFileInPath] Filename="',Filename,'" BasePath="',BasePath,'" SearchPath="',SearchPath,'" Delimiter="',Delimiter,'"');
  if (Filename='') then begin
    Result:='';
    exit;
  end;
  // check if filename absolute
  if FilenameIsAbsolute(Filename) then begin
    if FileExistsUTF8(Filename) then begin
      Result:=CleanAndExpandFilename(Filename);
      exit;
    end else begin
      Result:='';
      exit;
    end;
  end;
  Base:=CleanAndExpandDirectory(BasePath);
  // search in current directory
  if (not (sffDontSearchInBasePath in Flags))
  and FileExistsUTF8(Base+Filename) then begin
    Result:=CleanAndExpandFilename(Base+Filename);
    exit;
  end;
  // search in search path
  StartPos:=1;
  l:=length(SearchPath);
  while StartPos<=l do begin
    p:=StartPos;
    while (p<=l) and (pos(SearchPath[p],Delimiter)<1) do inc(p);
    CurPath:=TrimFilename(copy(SearchPath,StartPos,p-StartPos));
    if CurPath<>'' then begin
      if not FilenameIsAbsolute(CurPath) then
        CurPath:=Base+CurPath;
      Result:=CleanAndExpandFilename(AppendPathDelim(CurPath)+Filename);
      if FileExistsUTF8(Result) then exit;
    end;
    StartPos:=p+1;
  end;
  Result:='';
end;

function SearchAllFilesInPath(const Filename, BasePath, SearchPath,
  Delimiter: string; Flags: TSearchFileInPathFlags): TStrings;
  
  procedure Add(NewFilename: string);
  var
    i: Integer;
  begin
    NewFilename:=TrimFilename(NewFilename);
    if not FileExistsUTF8(NewFilename) then exit;
    if Result=nil then begin
      Result:=TStringList.Create;
    end else begin
      for i:=0 to Result.Count-1 do
        if CompareFilenames(Result[i],NewFilename)=0 then exit;
    end;
    Result.Add(NewFilename);
  end;
  
var
  p, StartPos, l: integer;
  CurPath, Base: string;
begin
  Result:=nil;
  if (Filename='') then exit;
  // check if filename absolute
  if FilenameIsAbsolute(Filename) then begin
    Add(CleanAndExpandFilename(Filename));
    exit;
  end;
  Base:=CleanAndExpandDirectory(BasePath);
  // search in current directory
  if (not (sffDontSearchInBasePath in Flags)) then begin
    Add(CleanAndExpandFilename(Base+Filename));
  end;
  // search in search path
  StartPos:=1;
  l:=length(SearchPath);
  while StartPos<=l do begin
    p:=StartPos;
    while (p<=l) and (pos(SearchPath[p],Delimiter)<1) do inc(p);
    CurPath:=TrimFilename(copy(SearchPath,StartPos,p-StartPos));
    if CurPath<>'' then begin
      if not FilenameIsAbsolute(CurPath) then
        CurPath:=Base+CurPath;
      Add(CleanAndExpandFilename(AppendPathDelim(CurPath)+Filename));
    end;
    StartPos:=p+1;
  end;
end;

function FindDiskFilename(const Filename: string): string;
// Searches for the filename case on disk.
// The file must exist.
// For example:
//   If Filename='file' and there is only a 'File' then 'File' will be returned.
var
  StartPos: Integer;
  EndPos: LongInt;
  FileInfo: TSearchRec;
  CurDir: String;
  CurFile: String;
  AliasFile: String;
  Ambiguous: Boolean;
begin
  Result:=Filename;
  if not FileExistsUTF8(Filename) then exit;
  // check every directory and filename
  StartPos:=1;
  {$IFDEF WINDOWS}
  // uppercase Drive letter and skip it
  if ((length(Result)>=2) and (Result[1] in ['A'..'Z','a'..'z'])
  and (Result[2]=':')) then begin
    StartPos:=3;
    if Result[1] in ['a'..'z'] then
      Result[1]:=upcase(Result[1]);
  end;
  {$ENDIF}
  repeat
    // skip PathDelim
    while (StartPos<=length(Result)) and (Result[StartPos]=PathDelim) do
      inc(StartPos);
    // find end of filename part
    EndPos:=StartPos;
    while (EndPos<=length(Result)) and (Result[EndPos]<>PathDelim) do
      inc(EndPos);
    if EndPos>StartPos then begin
      // search file
      CurDir:=copy(Result,1,StartPos-1);
      CurFile:=copy(Result,StartPos,EndPos-StartPos);
      AliasFile:='';
      Ambiguous:=false;
      if FindFirstUTF8(CurDir+GetAllFilesMask,faAnyFile,FileInfo)=0 then
      begin
        repeat
          // check if special file
          if (FileInfo.Name='.') or (FileInfo.Name='..') or (FileInfo.Name='')
          then
            continue;
          if CompareFilenamesIgnoreCase(FileInfo.Name,CurFile)=0 then begin
            //debugln('FindDiskFilename ',FileInfo.Name,' ',CurFile);
            if FileInfo.Name=CurFile then begin
              // file found, has already the correct name
              AliasFile:='';
              break;
            end else begin
              // alias found, but has not the correct name
              if AliasFile='' then begin
                AliasFile:=FileInfo.Name;
              end else begin
                // there are more than one candidate
                Ambiguous:=true;
              end;
            end;
          end;
        until FindNextUTF8(FileInfo)<>0;
      end;
      FindCloseUTF8(FileInfo);
      if (AliasFile<>'') and (not Ambiguous) then begin
        // better filename found -> replace
        Result:=CurDir+AliasFile+copy(Result,EndPos,length(Result));
      end;
    end;
    StartPos:=EndPos+1;
  until StartPos>length(Result);
end;

function FindDiskFileCaseInsensitive(const Filename: string): string;
var
  FileInfo: TSearchRec;
  ShortFilename: String;
  CurDir: String;
begin
  Result:='';
  CurDir:=ExtractFilePath(Filename);
  if FindFirstUTF8(CurDir+GetAllFilesMask,faAnyFile, FileInfo)=0 then begin
    ShortFilename:=ExtractFilename(Filename);
    repeat
      // check if special file
      if (FileInfo.Name='.') or (FileInfo.Name='..') or (FileInfo.Name='')
      then
        continue;
      if CompareFilenamesIgnoreCase(FileInfo.Name,ShortFilename)=0 then begin
        if FileInfo.Name=ShortFilename then begin
          // fits exactly
          Result:=Filename;
          break;
        end;
        // fits case insensitive
        Result:=CurDir+FileInfo.Name;
        // search further
      end;
    until FindNextUTF8(FileInfo)<>0;
  end;
  FindCloseUTF8(FileInfo);
end;

function FindDefaultExecutablePath(const Executable: string;
  const BaseDir: string): string;
begin
  if FilenameIsAbsolute(Executable) then begin
    Result:=Executable;
    if FileExistsUTF8(Result) then exit;
    {$IFDEF Windows}
    if ExtractFileExt(Result)='' then begin
      Result:=Result+'.exe';
      if FileExistsUTF8(Result) then exit;
    end;
    {$ENDIF}
  end else begin
    Result:=SearchFileInPath(Executable,BaseDir,
                             GetEnvironmentVariable('PATH'), PathSeparator,
                             [sffDontSearchInBasePath]);
    if Result<>'' then exit;
    {$IFDEF Windows}
    if ExtractFileExt(Executable)='' then begin
      Result:=SearchFileInPath(Executable+'.exe',BaseDir,
                               GetEnvironmentVariable('PATH'), PathSeparator,
                               [sffDontSearchInBasePath]);
      if Result<>'' then exit;
    end;
    {$ENDIF}
  end;
  Result:='';
end;

(*type

  { TListFileSearcher }

  TListFileSearcher = class(TFileSearcher)
  private
    FList: TStrings;
  protected
    procedure DoFileFound; override;
  public
    constructor Create(AList: TStrings);
  end; *)

{ TListFileSearcher }

procedure TListFileSearcher.DoFileFound;
begin
  FList.Add(FileName);
end;

constructor TListFileSearcher.Create(AList: TStrings);
begin
  inherited Create;
  FList := AList;
end;

function FindAllFiles(const SearchPath: String; SearchMask: String;
  SearchSubDirs: Boolean): TStringList;
var
  Searcher: TListFileSearcher;
begin
  Result := TStringList.Create;
  Searcher := TListFileSearcher.Create(Result);
  try
    Searcher.Search(SearchPath, SearchMask, SearchSubDirs);
  finally
    Searcher.Free;
  end;
end;

(*type

  { TListDirectoriesSearcher }

  TListDirectoriesSearcher = class(TFileSearcher)
  private
    FDirectoriesList :TStrings;
  protected
    procedure DoDirectoryFound; override;
  public
    constructor Create(AList: TStrings);
  end; *)

constructor TListDirectoriesSearcher.Create(AList: TStrings);
begin
  inherited Create;
  FDirectoriesList := AList;
end;

procedure TListDirectoriesSearcher.DoDirectoryFound;
begin
  FDirectoriesList.Add(FileName);
end;

function FindAllDirectories(const SearchPath : string;
  SearchSubDirs: Boolean = True): TStringList;
var
  Searcher :TFileSearcher;
begin
  Result := TStringList.Create;
  Searcher := TListDirectoriesSearcher.Create(Result);
  try
    Searcher.Search(SearchPath, AllFilesMask, SearchSubDirs);
  finally
    Searcher.Free;
  end;
end;

{ TFileIterator }

function TFileIterator.GetFileName: String;
begin
  Result := FPath + FFileInfo.Name;
end;

procedure TFileIterator.Stop;
begin
  FSearching := False;
end;

function TFileIterator.IsDirectory: Boolean;
begin
  Result := (FFileInfo.Attr and faDirectory) <> 0;
end;

{ TFileSearcher }

procedure TFileSearcher.RaiseSearchingError;
begin
  raise Exception.Create('The file searcher is already searching!');
end;

procedure TFileSearcher.DoDirectoryEnter;
begin
  if Assigned(FonDirectoryEnter) then FOnDirectoryEnter(Self);
end;

procedure TFileSearcher.DoDirectoryFound;
begin
  if Assigned(FOnDirectoryFound) then OnDirectoryFound(Self);
end;

procedure TFileSearcher.DoFileFound;
begin
  if Assigned(FOnFileFound) then OnFileFound(Self);
end;

constructor TFileSearcher.Create;
begin
  inherited Create;
  FMaskSeparator := ';';
  FFollowSymLink := True;
  FFileAttribute := faAnyFile;
  FDirectoryAttribute := faDirectory;
  FSearching := False;
end;

 {  procedure Search(const ASearchPath: String; ASearchMask: String = '';
      ASearchSubDirs: Boolean = True; CaseSensitive: Boolean = False);}


procedure TFileSearcher.Search(const ASearchPath: String; ASearchMask: String = '';
  ASearchSubDirs: Boolean = true; CaseSensitive: Boolean = False);
var
  MaskList: TMaskList;

  procedure DoSearch(const APath: String; const ALevel: Integer);
  var
    P: String;
    PathInfo: TSearchRec;
  begin
    P := APath + AllDirectoryEntriesMask;

    if FindFirstUTF8(P, FileAttribute, PathInfo) = 0 then
    try
      repeat
        // skip special files
        if (PathInfo.Name = '.') or (PathInfo.Name = '..') or
          (PathInfo.Name = '') then Continue;
        // Deal with both files and directories
        if (PathInfo.Attr and faDirectory) = 0 then
        begin             // File
          {$IFDEF Windows}
          if (MaskList = nil) or MaskList.MatchesWindowsMask(PathInfo.Name)
          {$ELSE}
          if (MaskList = nil) or MaskList.Matches(PathInfo.Name)
          {$ENDIF}
          then begin
            FPath := APath;
            FLevel := ALevel;
            FFileInfo := PathInfo;
            DoFileFound;
          end;
        end
        else begin        // Directory
          FPath := APath;
          FLevel := ALevel;
          FFileInfo := PathInfo;
          DoDirectoryFound;
        end;

      until (FindNextUTF8(PathInfo) <> 0) or not FSearching;
    finally
      FindCloseUTF8(PathInfo);
    end;

    if ASearchSubDirs or (ALevel > 0) then
      // search recursively in directories
      if FindFirstUTF8(P, DirectoryAttribute, PathInfo) = 0 then
      try
        repeat
          if (PathInfo.Name = '.') or (PathInfo.Name = '..') or
             (PathInfo.Name = '') or ((PathInfo.Attr and faDirectory) = 0) or
             (not FFollowSymLink and FileIsSymlink(APath + PathInfo.Name))
          then Continue;

          FPath := APath;
          FLevel := ALevel;
          FFileInfo := PathInfo;
          DoDirectoryEnter;
          if not FSearching then Break;

          DoSearch(AppendPathDelim(APath + PathInfo.Name), Succ(ALevel));

        until (FindNextUTF8(PathInfo) <> 0);
      finally
        FindCloseUTF8(PathInfo);
      end;
  end;

begin
  if FSearching then RaiseSearchingError;

  MaskList := TMaskList.Create(ASearchMask, FMaskSeparator, CaseSensitive);
  // empty mask = all files mask
  if MaskList.Count = 0 then
    FreeAndNil(MaskList);

  FSearching := True;
  try
    DoSearch(AppendPathDelim(ASearchPath), 0);
  finally
    FSearching := False;
    if MaskList <> nil then MaskList.Free;
  end;
end;

function GetAllFilesMask: string;
begin
  {$IFDEF WINDOWS}
  Result:='*.*';
  {$ELSE}
  Result:='*';
  {$ENDIF}
end;

function GetExeExt: string;
begin
  {$IFDEF WINDOWS}
  Result:='.exe';
  {$ELSE}
  Result:='';
  {$ENDIF}
end;

{------------------------------------------------------------------------------
  function ReadFileToString(const Filename: string): string;
 ------------------------------------------------------------------------------}
function ReadFileToString(const Filename: String): String;
var
  SrcHandle: THandle;
  ReadCount: LongInt;
  s: String;
begin
  Result := '';
  s:='';
  try
    Setlength(s, FileSize(Filename));
    if s='' then exit;
    SrcHandle := FileOpenUTF8(Filename, fmOpenRead or fmShareDenyWrite);
    if (THandle(SrcHandle)= -1) then
      exit;
    try
      ReadCount:=FileRead(SrcHandle,s[1],length(s));
      if ReadCount<length(s) then
        exit;
    finally
      FileClose(SrcHandle);
    end;
    Result:=s;
  except
    // ignore errors, Result string will be empty
  end;
end;

{------------------------------------------------------------------------------
  function FileSearchUTF8(const Name, DirList: String): String;
 ------------------------------------------------------------------------------}
function FileSearchUTF8(const Name, DirList: String; ImplicitCurrentDir : Boolean = True): String;
begin
  //Result := LazFileUtils.FileSearchUTF8(Name, DirList, ImplicitCurrentDir);
end;

{------------------------------------------------------------------------------
  function ForceDirectoriesUTF8(const Dir: string): Boolean;
 ------------------------------------------------------------------------------}
function ForceDirectoriesUTF8(const Dir: string): Boolean;
begin
  //Result := LazFileUtils.ForceDirectoriesUTF8(Dir);
end;

{------------------------------------------------------------------------------
  function ForceDirectoriesUTF8(const Dir: string): Boolean;
 ------------------------------------------------------------------------------}
function FileIsReadOnlyUTF8(const FileName: String): Boolean;
begin
  //Result := LazFileUtils.FileIsReadOnlyUTF8(FileName);
end;






end.

