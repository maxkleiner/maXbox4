{
All functions are thread safe unless explicitely stated
  stressed tested for mX4
}
unit LazFileUtils;

//{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SysConst, fileutil;

  const AllowDirectorySeparators = ['\', '/'];
  const PathSeparator = ':';


  resourceString
  lrsModified = '  modified ';
  lrsInvalidCharSet = 'The char set in mask "%s" is not valid!';
  lrsSize = '  size ';
  lrsFileDoesNotExist = 'file "%s" does not exist';
  lrsFileIsADirectoryAndNotAnExecutable = 'file "%s" is a directory and not an'
    +' executable';
  lrsReadAccessDeniedFor = 'read access denied for %s';
  lrsADirectoryComponentInDoesNotExistOrIsADanglingSyml2 = 'a directory '
    +'component in %s does not exist or is a dangling symlink';
  lrsADirectoryComponentInIsNotADirectory2 = 'a directory component in %s is '
    +'not a directory';
  lrsADirectoryComponentInDoesNotExistOrIsADanglingSyml = 'a directory '
    +'component in %s does not exist or is a dangling symlink';
  lrsADirectoryComponentInIsNotADirectory = 'a directory component in %s is '
    +'not a directory';
  lrsInsufficientMemory = 'insufficient memory';
  lrsHasACircularSymbolicLink = '%s has a circular symbolic link';
  lrsIsNotASymbolicLink = '%s is not a symbolic link';
  lrsIsNotExecutable = '%s is not executable';
  lrsUnableToCreateConfigDirectoryS = 'Unable to create config directory "%s"';
  lrsProgramFileNotFound = 'program file not found %s';
  lrsCanNotExecute = 'can not execute %s';

  // XPath
  lrsNodeSet = 'node set';
  lrsBoolean = 'boolean';
  lrsNumber = 'number';
  lrsString = 'string';
  lrsVarNoConversion = 'Conversion from %s to %s not possible';
  lrsScannerUnclosedString = 'String literal was not closed';
  lrsScannerInvalidChar = 'Invalid character';
  lrsScannerMalformedQName = 'Expected "*" or local part after colon';
  lrsScannerExpectedVarName = 'Expected variable name after "$"';
  lrsParserExpectedLeftBracket = 'Expected "("';
  lrsParserExpectedRightBracket = 'Expected ")"';
  lrsParserBadAxisName = 'Invalid axis name';
  lrsParserBadNodeType = 'Invalid node type';
  lrsParserExpectedRightSquareBracket = 'Expected "]" after predicate';
  lrsParserInvalidPrimExpr = 'Invalid primary expression';
  lrsParserGarbageAfterExpression = 'Unrecognized input after expression';
  lrsParserInvalidNodeTest = 'Invalid node test (syntax error)';
  lrsEvalUnknownFunction = 'Unknown function: "%s"';
  lrsEvalUnknownVariable = 'Unknown variable: "%s"';
  lrsEvalInvalidArgCount = 'Invalid number of function arguments';


{$IFDEF Windows}
  {$define CaseInsensitiveFilenames}
  {$define HasUNCPaths}
{$ENDIF}
{$IFDEF darwin}
  {$define CaseInsensitiveFilenames}
{$ENDIF}

function CompareFilenames(const Filename1, Filename2: string): integer;
function CompareFilenamesIgnoreCase(const Filename1, Filename2: string): integer;
function CompareFileExt(const Filename, Ext: string;
                        CaseSensitive: boolean): integer; //overload;
//function CompareFileExt(const Filename, Ext: string): integer; overload;

function CompareFilenameStarts(const Filename1, Filename2: string): integer;
function CompareFilenames2(Filename1: PChar; Len1: integer;
  Filename2: PChar; Len2: integer): integer;
function CompareFilenamesP(Filename1, Filename2: PChar;
  IgnoreCase: boolean = false // false = use default
  ): integer;

function DirPathExists(DirectoryName: string): boolean;
function DirectoryIsWritable(const DirectoryName: string): boolean;
function ExtractFileNameOnly(const AFilename: string): string;
function FilenameIsAbsolute(const TheFilename: string):boolean;
function FilenameIsWinAbsolute(const TheFilename: string):boolean;
function FilenameIsUnixAbsolute(const TheFilename: string):boolean;
function ForceDirectory(DirectoryName: string): boolean;
//procedure CheckIfFileIsExecutable(const AFilename: string);
//procedure CheckIfFileIsSymlink(const AFilename: string);
//function FileIsExecutable(const AFilename: string): boolean;
//function FileIsSymlink(const AFilename: string): boolean;
//function FileIsHardLink(const AFilename: string): boolean;
//function FileIsReadable(const AFilename: string): boolean;
//function FileIsWritable(const AFilename: string): boolean;
function FileIsText(const AFilename: string): boolean;
function FileIsText2(const AFilename: string; out FileReadable: boolean): boolean;
function FilenameIsTrimmed(const TheFilename: string): boolean;
function FilenameIsTrimmed2(StartPos: PChar; NameLen: integer): boolean;
function TrimFilename(const AFilename: string): string;
function ResolveDots(const AFilename: string): string;
Procedure ForcePathDelims(Var FileName: string);
Function GetForcedPathDelims(Const FileName: string): String;
function CleanAndExpandFilename(const Filename: string): string; // empty string returns current directory
function CleanAndExpandDirectory(const Filename: string): string; // empty string returns current directory
function TrimAndExpandFilename(const Filename: string; const BaseDir: string = ''): string; // empty string returns empty string
function TrimAndExpandDirectory(const Filename: string; const BaseDir: string = ''): string; // empty string returns empty string
function TryCreateRelativePath(const Dest, Source: String; UsePointDirectory: boolean;
                               AlwaysRequireSharedBaseFolder: Boolean; out RelPath: String): Boolean;
function CreateRelativePath(const Filename, BaseDirectory: string;
                            UsePointDirectory: boolean = false; AlwaysRequireSharedBaseFolder: Boolean = True): string;
function FileIsInPath(const Filename, Path: string): boolean;
function AppendPathDelim(const Path: string): string;
function ChompPathDelim(const Path: string): string;

// search paths
function CreateAbsoluteSearchPath(const SearchPath, BaseDirectory: string): string;
function CreateRelativeSearchPath(const SearchPath, BaseDirectory: string): string;
function MinimizeSearchPath(const SearchPath: string): string;
function FindPathInSearchPath(APath: PChar; APathLen: integer;
                              SearchPath: PChar; SearchPathLen: integer): PChar;

// file operations
(*function FileExistsUTF8(const Filename: string): boolean;
function FileAgeUTF8(const FileName: string): Longint;
function DirectoryExistsUTF8(const Directory: string): Boolean;
function ExpandFileNameUTF8(const FileName: string; {const} BaseDir: string = ''): string;
function FindFirstUTF8(const Path: string; Attr: Longint; out Rslt: TSearchRec): Longint;
function FindNextUTF8(var Rslt: TSearchRec): Longint;
procedure FindCloseUTF8(var F: TSearchrec); inline;
function FileSetDateUTF8(const FileName: String; Age: Longint): Longint;
function FileGetAttrUTF8(const FileName: String): Longint;
function FileSetAttrUTF8(const Filename: String; Attr: longint): Longint;
function DeleteFileUTF8(const FileName: String): Boolean;
function RenameFileUTF8(const OldName, NewName: String): Boolean;
function FileSearchUTF8(const Name, DirList : String; ImplicitCurrentDir : Boolean = True): String;
function FileIsReadOnlyUTF8(const FileName: String): Boolean;
function GetCurrentDirUTF8: String;
function SetCurrentDirUTF8(const NewDir: String): Boolean;
function CreateDirUTF8(const NewDir: String): Boolean;
function RemoveDirUTF8(const Dir: String): Boolean;
function ForceDirectoriesUTF8(const Dir: string): Boolean;

function FileOpenUTF8(Const FileName : string; Mode : Integer) : THandle;
function FileCreateUTF8(Const FileName : string) : THandle; overload;
function FileCreateUTF8(Const FileName : string; Rights: Cardinal) : THandle; overload;
Function FileCreateUtf8(Const FileName : String; ShareMode : Integer; Rights : Cardinal) : THandle; overload;

function FileSizeUtf8(const Filename: string): int64;*)
function GetFileDescription(const AFilename: string): string;


function GetAppConfigDirUTF8(Global: Boolean; Create: boolean = false): string;
function GetAppConfigFileUTF8(Global: Boolean; SubDir: boolean = false;
  CreateDir: boolean = false): string;
function GetTempFileNameUTF8(const Dir, Prefix: String): String;

// UNC paths
//function IsUNCPath(const {%H-}Path: String): Boolean;
//function ExtractUNCVolume(const {%H-}Path: String): String;
function ExtractFileRoot(FileName: String): String;

// darwin paths
{$IFDEF darwin}
function GetDarwinSystemFilename(Filename: string): string;
{$ENDIF}

procedure SplitCmdLineParams(const Params: string; ParamList: TStrings;
                             ReadBackslash: boolean = false);
function StrToCmdLineParam(const Param: string): string;
function MergeCmdLineParams(ParamList: TStrings): string;

//intface of lazfileutils.inc

//function ResolveDots(const AFilename: string): String;
//trim double path delims and expand special dirs like .. and .
(*function FilenameIsWinAbsolute(const TheFilename: string): boolean;
function FilenameIsUnixAbsolute(const TheFilename: string): boolean;
function TryCreateRelativePath(const Dest, Source: String; UsePointDirectory: boolean;
                               AlwaysRequireSharedBaseFolder: Boolean; out RelPath: String): Boolean;*)

  //function SplitDirs(Dir: String; out Dirs: TDirArr): Integer;

//function CreateRelativePath(const Filename, BaseDirectory: string;
  //UsePointDirectory: boolean;  AlwaysRequireSharedBaseFolder: Boolean): string;
  procedure FindCloseUTF8(var F: TSearchrec);

//END  lazfileutils.inc


function FindAllDocs(const Root, extmask: string): TStringlist;
procedure Inc1(var X: longint; N: Longint);
procedure Dec1(var X: longint; N: Longint);



type
  TInvalidateFileStateCacheEvent = procedure(const Filename: string);
var
  OnInvalidateFileStateCache: TInvalidateFileStateCacheEvent = nil;
procedure InvalidateFileStateCache(const Filename: string = ''); inline;

 {
  Authors/Credits: FPC RTL, Trustmaster (Vladimir Sibirov), L505 (Lars Olson)
  License: 
   FPC RTL Modified GPL. 
   However, any functions stamped with "Vladimir" are Artistic License. Any 
   functions stamped with "Lars" are NRCOL license (I hate GPL). Any functions 
   by both Lars & Vladimir are Artistic License. Functions are therefore free 
   software,  similar to dual licensed code, if you like.}

//unit pwfileutil;

type TFmode = (fmDefault, fmR, fmRW);
      astr= string;



procedure Xpath(var path: string);
function NewFile(const fname: astr): boolean;
function FileError: astr;
function MakeDir(s: astr): boolean;


function ExtractFilePart(fpath: astr): astr;
function ExtractFname(const fpath: astr; ext: boolean): astr;

function FileThere(const fname: astr; fm: TFmode): boolean;

function ExtractFilePath(const FileName: string): string;
function ExtractFileDir(const FileName: string): string;
function ExtractFileDrive(const FileName: string): string;
function ExtractFileName(const FileName: string): string;
function ExtractFileExt(const FileName: string): string;

function ChangeFileExt(const FileName, Extension: string): string;


function ExtractRelativepath (Const BaseName,DestNAme : String): String;
function IncludeTrailingPathDelimiter(Const Path : String) : String;
function IncludeTrailingBackslash(Const Path : String) : String;
function ExcludeTrailingBackslash(Const Path: string): string;
function ExcludeTrailingPathDelimiter(Const Path: string): string;
function IsPathDelimiter(Const Path: string; Index: Integer): Boolean;
Procedure DoDirSeparators (Var FileName : String);
Function SetDirSeparators (Const FileName : String) : String;
Function GetDirs (Var DirName : String; Var Dirs : Array of pchar) : Longint;


function FindAllFiles(const SearchPath: String; SearchMask: String = '';
  SearchSubDirs: Boolean = True): TStringList;
function FindAllDirectories(const SearchPath: string;
  SearchSubDirs: Boolean = True): TStringList;
function ReadFileToString(const Filename: string): string;


(*type
  TCopyFileFlag = (
    cffOverwriteFile,
    cffCreateDestDirectory,
    cffPreserveTime
    );
  TCopyFileFlags = set of TCopyFileFlag;*) 


function CopyDirTree(const SourceDir, TargetDir: string; Flags: TCopyFileFlags=[]): Boolean;




// tests
procedure RunTest1;


implementation

// to get more detailed error messages consider the os
uses
  Windows, StrUtils;

(*{$I lazfileutils.inc}
{$IFDEF windows}
  {$I winlazfileutils.inc}
{$ELSE}
  {$I unixlazfileutils.inc}
{$ENDIF}*)

Const MaxDirs = 129;
       DirSeparators : set of char = ['/','\'];


function GetFileDescription(const AFilename: string): string;
begin
  Result:= LazFileUtils.GetFileDescription(AFilename);
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


 procedure Inc1(var X: longint; N: Longint);
 begin
   X:= X+N;
 end;

 procedure Dec1(var X: longint; N: Longint);
 begin
   X:= X-N;
 end;



function FindAllDocs(const Root, extmask: string): TStringlist;
var //SearchRec: TSearchRec;  implicit
  Folders: array of string;
  Folder: string;
  I, Last: Integer;
  SearchRec: TSearchRec;

begin
  SetLength(Folders,1);
  Folders[0]:= Root;
  I:= 0;
  Result:= TStringList.Create;
  while (I < Length(Folders)) do begin
    Folder:= IncludeTrailingBackslash(Folders[I]);
    Inc(I);
    { Collect child folders first. }
    if (FindFirst(Folder+'*.*', faDirectory, SearchRec) = 0) then begin
      repeat
        if not ((SearchRec.Name='.') or (SearchRec.Name='..')) then begin
          Last:= Length(Folders);
          SetLength(Folders, Succ(Last));
          Folders[Last]:= Folder + SearchRec.Name;
        end;
      until (FindNext(searchrec) <> 0);
      sysutils.FindClose(searchrec);
    end;
    { Collect files next.}
    if (FindFirst(Folder+extmask,faAnyFile-faDirectory,searchrec)= 0) then begin
      repeat
        if not ((SearchRec.Attr and faDirectory)=faDirectory) then
           result.Add(Folder+SearchRec.Name);
          //WriteLn(Folder+' '+SearchRecName); :debug
      until (FindNext(searchrec) <> 0);
      sysutils.FindClose(searchrec);
    end;
  end;
end;


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






function ExtractRelativepath (Const BaseName,DestName : String): String;
Var Source, Dest : String;
    Sc,Dc,I,J    : Longint;
    SD,DD        : Array[1..MaxDirs] of PChar;

Const OneLevelBack = '..' + PathDelim;

begin
  If Uppercase(ExtractFileDrive(BaseName))<>Uppercase(ExtractFileDrive(DestName)) Then
    begin
    Result:=DestName;
    exit;
    end;
  Source:=ExtractFilePath(BaseName);
  Dest:=ExtractFilePath(DestName);
  SC:=GetDirs (Source,SD);
  DC:=GetDirs (Dest,DD);
  I:=1;
  While (I<DC) and (I<SC) do
    begin
    If StrIcomp(DD[i],SD[i])=0 then
      Inc(i)
    else
      Break;
    end;
  Result:='';
  For J:=I to SC-1 do Result:=Result+OneLevelBack;
  For J:=I to DC-1 do Result:=Result+DD[J]+PathDelim;
  Result:=Result+ExtractFileName(DestNAme);
end;

Procedure DoDirSeparators (Var FileName : String);
var I : longint;
begin
  for I:=1 to Length(FileName) do
    If FileName[I] in DirSeparators then
      FileName[i]:=PathDelim;
end;


function SetDirSeparators (Const FileName : string) : String;
begin
  Result:=FileName;
  DoDirSeparators (Result);
end;

{
  DirName is split in a #0 separated list of directory names,
  Dirs is an array of pchars, pointing to these directory names.
  The function returns the number of directories found, or -1
  if none were found.
  DirName must contain only PathDelim as Directory separator chars.
}

Function GetDirs (Var DirName : String; Var Dirs : Array of pchar) : Longint;
var I : Longint;
begin
  I:=1;
  Result:=-1;
  While I<=Length(DirName) do
    begin
    If DirName[i]=PathDelim then
      begin
      DirName[i]:=#0;
      Inc(Result);
      Dirs[Result]:=@DirName[I+1];
      end;
    Inc(I);
    end;
  If Result>-1 then inc(Result);
end;

function IncludeTrailingPathDelimiter(Const Path : String) : String;
var
  l : Integer;
begin
  Result:=Path;
  l:=Length(Result);
  If (L=0) or (Result[l]<>PathDelim) then
    Result:=Result+PathDelim;
end;

function IncludeTrailingBackslash(Const Path : String) : String;
begin
  Result:=IncludeTrailingPathDelimiter(Path);
end;

function ExcludeTrailingBackslash(Const Path: string): string;
begin
  Result:=ExcludeTrailingPathDelimiter(Path);
end;

function ExcludeTrailingPathDelimiter(Const Path: string): string;
var L: Integer;
begin
  L:=Length(Path);
  If (L>0) and (Path[L]=PathDelim) then
    Dec(L);
  Result:=Copy(Path,1,L);
end;

function IsPathDelimiter(Const Path: string; Index: Integer): Boolean;
begin
  Result:=(Index>0) and (Index<=Length(Path)) and (Path[Index]=PathDelim);
end;

function ChangeFileExt(const FileName, Extension: string): string;
var i: longint;
begin
  I := Length(FileName);
  while (I > 0) and not(FileName[I] in ['/', '.', '\', ':']) do
    Dec(I);
  if (I = 0) or (FileName[I] <> '.') then
    I := Length(FileName)+1;
  Result := Copy(FileName, 1, I - 1) + Extension;
end;


function ExtractFilePath(const FileName: string): string;
var i: longint;
begin
  i := Length(FileName);
  while (i > 0) and not (FileName[i] in ['/', '\', ':']) do Dec(i);
  If I>0 then
    Result := Copy(FileName, 1, i)
  else
    Result:='';
end;

function ExtractFileDir(const FileName: string): string;
var i: longint;
begin
  I := Length(FileName);
  while (I > 0) and not (FileName[I] in ['/', '\', ':']) do Dec(I);
  if (I > 1) and (FileName[I] in ['\', '/']) and
    not (FileName[I - 1] in ['/', '\', ':']) then Dec(I);
  Result := Copy(FileName, 1, I);
end;

function ExtractFileDrive(const FileName: string): string;
var i: longint;
begin
  if (Length(FileName) >= 3) and (FileName[2] = ':') then
    result := Copy(FileName, 1, 2)
  else if (Length(FileName) >= 2) and (FileName[1] in ['/', '\']) and
    (FileName[2] in ['/', '\']) then
  begin
    i := 2;
    While (i < Length(Filename)) do
    begin
           if Filename[i + 1] in ['/', '\'] then break;
      inc(i);
    end ;
    Result := Copy(FileName, 1, i);
  end else Result := '';
end;

function ExtractFileName(const FileName: string): string;
var i: longint;
begin
  I := Length(FileName);
  while (I > 0) and not (FileName[I] in ['/', '\', ':']) do Dec(I);
  Result := Copy(FileName, I + 1, 255);
end;

function ExtractFileExt(const FileName: string): string;
var i: longint;
begin
  I := Length(FileName);
  while (I > 0) and not (FileName[I] in ['.', '/', '\', ':']) do Dec(I);
  if (I > 0) and (FileName[I] = '.') then
    Result := Copy(FileName, I, 255)
  else Result := '';
end;

{ END: FROM FPC SYSUTILS}

{ this grabs "file" from "file.ext" }
function ExtractFilePart(fpath: astr): astr;
var i: integer;
    dotcnt: byte;
begin
  result:= '';
  if fpath = '' then exit;
  fpath:= ExtractFileName(fpath);
  if fpath = '' then exit;
  dotcnt:= 0;
  for i:= length(fpath) downto 1 do begin
    if dotcnt > 0 then result:= fpath[i] + result;
    if fpath[i] = '.' then inc(dotcnt);
  end;
  if dotcnt < 1 then result:= fpath;
end;

{ if ext is set to false, only grab "file" from "file.ext" }
function ExtractFname(const fpath: astr; ext: boolean): astr;
begin
  result:= '';
  if fpath = '' then exit;
  case ext of 
    true:  result:= ExtractFileName(fpath);
    false: result:= ExtractFilePart(fpath);
  end;
end;

procedure RunTest1;
begin
  writeln(ExtractFilePart('c:\tmp\blah.cool\success.txt'));
  writeln(ExtractFilePart('c:\tmp\blah.cool\success'));
  writeln(ExtractFname('c:\tmp\blah.cool\success.txt', false));
  writeln(ExtractFname('c:\tmp\blah.cool\success-with-ext.txt', true));
  writeln(ExtractFname('/path/special.success.txt', false));
  writeln(ExtractFname('/path/success', true));
  writeln(ExtractFname('/path/success', false));
  writeln(ExtractFilePart('/path/success.txt'));
  readln;
end;


//lazfileutils.inc ----------------------------

function ResolveDots(const AFilename: string): String;
//trim double path delims and expand special dirs like .. and .
var SrcPos, DestPos, l, DirStart: integer;
  c: char;
  MacroPos: LongInt;
begin
  Result:=AFilename;

  l:=length(AFilename);
  SrcPos:=1;
  DestPos:=1;


  // trim double path delimiters and special dirs . and ..
  while (SrcPos<=l) do begin
    c:=AFilename[SrcPos];
    // check for double path delims
    if (c=PathDelim) then begin
      inc(SrcPos);
      {$IFDEF Windows}
      if (DestPos>2)
      {$ELSE}
      if (DestPos>1)
      {$ENDIF}
      and (Result[DestPos-1]=PathDelim) then begin
        // skip second PathDelim
        continue;
      end;
      Result[DestPos]:=c;
      inc(DestPos);
      continue;
    end;
    // check for special dirs . and ..
    if (c='.') then begin
      if (SrcPos<l) then begin
        if (AFilename[SrcPos+1]=PathDelim)
        and ((DestPos=1) or (AFilename[SrcPos-1]=PathDelim)) then begin
          // special dir ./
          // -> skip
          inc(SrcPos,2);
          continue;
        end else if (AFilename[SrcPos+1]='.')
        and (SrcPos+1=l) or (AFilename[SrcPos+2]=PathDelim) then begin
          // special dir ..
          //  1. ..      -> copy
          //  2. /..     -> skip .., keep /
          //  3. C:..    -> copy
          //  4. C:\..   -> skip .., keep C:\
          //  5. \\..    -> skip .., keep \\
          //  6. xxx../..   -> copy
          //  7. xxxdir/..  -> trim dir and skip ..
          //  8. xxxdir/..  -> trim dir and skip ..
          if DestPos=1 then begin
            //  1. ..      -> copy
          end else if (DestPos=2) and (Result[1]=PathDelim) then begin
            //  2. /..     -> skip .., keep /
            inc(SrcPos,2);
            continue;
          {$IFDEF Windows}
          end else if (DestPos=3) and (Result[2]=':')
          and (Result[1] in ['a'..'z','A'..'Z']) then begin
            //  3. C:..    -> copy
          end else if (DestPos=4) and (Result[2]=':') and (Result[3]=PathDelim)
          and (Result[1] in ['a'..'z','A'..'Z']) then begin
            //  4. C:\..   -> skip .., keep C:\
            inc(SrcPos,2);
            continue;
          end else if (DestPos=3) and (Result[1]=PathDelim)
          and (Result[2]=PathDelim) then begin
            //  5. \\..    -> skip .., keep \\
            inc(SrcPos,2);
            continue;
          {$ENDIF}
          end else if (DestPos>1) and (Result[DestPos-1]=PathDelim) then begin
            if (DestPos>3)
            and (Result[DestPos-2]='.') and (Result[DestPos-3]='.')
            and ((DestPos=4) or (Result[DestPos-4]=PathDelim)) then begin
              //  6. ../..   -> copy
            end else begin
              //  7. xxxdir/..  -> trim dir and skip ..
              DirStart:=DestPos-2;
              while (DirStart>1) and (Result[DirStart-1]<>PathDelim) do
                dec(DirStart);
              MacroPos:=DirStart;
              while MacroPos<DestPos do begin
                if (Result[MacroPos]='$')
                and (Result[MacroPos+1] in ['(','a'..'z','A'..'Z']) then begin
                  // 8. directory contains a macro -> keep
                  break;
                end;
                inc(MacroPos);
              end;
              if MacroPos=DestPos then begin
                DestPos:=DirStart;
                inc(SrcPos,2);
                continue;
              end;
            end;
          end;
        end;
      end else begin
        // special dir . at end of filename
        if DestPos=1 then begin
          Result:='.';
          exit;
        end else begin
          // skip
          break;
        end;
      end;
    end;
    // copy directory
    repeat
      Result[DestPos]:=c;
      inc(DestPos);
      inc(SrcPos);
      if (SrcPos>l) then break;
      c:=AFilename[SrcPos];
      if c=PathDelim then break;
    until false;
  end;
  // trim result
  if DestPos<=length(AFilename) then
    SetLength(Result,DestPos-1);
end;

function FilenameIsWinAbsolute(const TheFilename: string): boolean;
begin
  Result:=((length(TheFilename)>=3) and
           (TheFilename[1] in ['A'..'Z','a'..'z']) and (TheFilename[2]=':')  and (TheFilename[3]='\'))
   or ((length(TheFilename)>=2) and (TheFilename[1]='\') and (TheFilename[2]='\'));
end;

function FilenameIsUnixAbsolute(const TheFilename: string): boolean;
begin
  Result:=(TheFilename<>'') and (TheFilename[1]='/');
end;


{
  Returns True if it is possible to create a relative path from Source to Dest
  Function must be thread safe, so no expanding of filenames is done, since this
  is not threadsafe (at least on Windows platform)

  - Dest and Source must either be both absolute filenames, or relative
  - Dest and Source cannot contain '..' since no expanding is done by design
  - Dest and Source must be on same drive or UNC path (Windows)
  - if both Dest and Source are relative they must at least share their base directory
  - Double PathDelims are ignored (unless they are part of the UNC convention)

  - if UsePointDirectory is True and Result is True then if RelPath is Empty string, RelPath becomes '.'
  - if AlwaysRequireSharedBaseFolder is False then Absolute filenames need not share a basefolder

  - if the function succeeds RelPath contains the relative path from Source to Dest,
    no PathDelimiter is appended to the end of RelPath

  Examples:
  - Dest = /foo/bar Source = /foo Result = True RelPath = bar
  - Dest = /foo///bar Source = /foo// Result = True RelPath = bar
  - Dest = /foo Source = /foo/bar Result = True RelPath = ../
  - Dest = /foo/bar Source = /bar Result = True RelPath = ../foo/bar
  - Dest = foo/bar Source = foo/foo Result = True RelPath = ../bar
  - Dest = foo/bar Source = bar/foo Result = False (no shared base directory)
  - Dest = /foo Source = bar Result = False (mixed absolute and relative)
  - Dest = c:foo Source = c:bar Result = False (no expanding)
  - Dest = c:\foo Source = d:\bar Result is False (different drives)
  - Dest = \foo Source = foo (Windows) Result is False (too ambiguous to guess what this should mean)
  - Dest = /foo Source = /bar AlwaysRequireSharedBaseFolder = True Result = False
  - Dest = /foo Source = /bar AlwaysRequireSharedBaseFolder = False Result = True RelPath = ../foo
}

function TryCreateRelativePath(const Dest, Source: String; UsePointDirectory: boolean;
                               AlwaysRequireSharedBaseFolder: Boolean; out RelPath: String): Boolean;
Const
  MaxDirs = 129;
Type
  TDirArr =  Array[1..MaxDirs] of String;

  function SplitDirs(Dir: String; out Dirs: TDirArr): Integer;
  var
    Start, Stop, Len: Integer;
    S: String;
  begin
    Result := 0;
    Len := Length(Dir);
    if (Len = 0) then Exit;
    Start := 1;
    Stop := 1;

    While Start <= Len do
    begin
      if (Dir[Start] = PathDelim) then
      begin
        S := Copy(Dir,Stop,Start-Stop);
        //ignore empty strings, they are caused by double PathDelims, which we just ignore
        if (S <> '') then
        begin
          Inc(Result);
          if Result>High(Dirs) then
            raise Exception.Create('too many sub directories');
          Dirs[Result] := S;
        end;
        Stop := Start + 1;
      end;
      Inc(Start);
    end;
    //If (Len > 0) then

    S := Copy(Dir,Stop,Start-Stop);
    if (S <> '') then
    begin
      Inc(Result);
      Dirs[Result] := S;
    end;
  end;


var
  CompareFunc: function(const Item1, Item2: String): Integer;
  SourceRoot, DestRoot, CmpDest, CmpSource: String;
  CmpDestLen, CmpSourceLen, DestCount, SourceCount, i,
  SharedFolders, LevelsBack, LevelsUp: Integer;
  SourceDirs, DestDirs: TDirArr; //Array[1..MaxDirs] of String;
  IsAbs: Boolean;
begin
  Result := False;
  if (Dest = '') or (Source = '') then Exit;
  if (Pos('..',Dest) > 0) or (Pos('..',Source) > 0) then Exit;
  SourceRoot := ExtractFileRoot(Source);
  DestRoot := ExtractFileRoot(Dest);
  //debugln('TryCreaterelativePath: DestRoot = "',DestRoot,'"');
  //debugln('TryCreaterelativePath: SourceRoot = "',SourceRoot,'"');
  //Root must be same: either both absolute filenames or both relative (and on same drive in Windows)
  if (CompareFileNames(SourceRoot, DestRoot) <> 0) then Exit;
  IsAbs := (DestRoot <> '');
  //{$if defined(windows) and not defined(wince)}
  if not IsAbs then  // relative paths
  begin
    //we cannot handle files like c:foo
    if ((Length(Dest) > 1) and (UpCase(Dest[1]) in ['A'..'Z']) and (Dest[2] = ':')) or
       ((Length(Source) > 1) and (UpCase(Source[1]) in ['A'..'Z']) and (Source[2] = ':')) then Exit;
    //we cannot handle combinations like dest=foo source=\bar or the other way around
    if ((Dest[1] = PathDelim) and (Source[1] <> PathDelim)) or
       ((Dest[1] <> PathDelim) and (Source[1] = PathDelim)) then Exit;
  end;
  //{$endif}

  {$IFDEF CaseInsensitiveFilenames}
  CompareFunc := @UTF8CompareText;
  {$else CaseInsensitiveFilenames}
  //CompareFunc := @Utf8CompareStr;
  {$endif CaseInsensitiveFilenames}

  CmpSource := Source;
  CmpDest := Dest;
  {$IFDEF darwin}
  CmpSource := GetDarwinSystemFilename(CmpSource);
  CmpDest := GetDarwinSystemFilename(CmpDest);
  {$ENDIF}


  CmpDest := ChompPathDelim(Dest);
  CmpSource := ChompPathDelim(Source);
  if IsAbs then
  begin
    System.Delete(CmpSource,1,Length(SourceRoot));
    System.Delete(CmpDest,1,Length(DestRoot));
  end;

  //Get rid of excessive trailing PathDelims now after (!) we stripped Root
  while (Length(CmpDest) > 0) and (CmpDest[Length(CmpDest)] = PathDelim) do System.Delete(CmpDest,Length(CmpDest),1);
  while (Length(CmpSource) > 0) and (CmpSource[Length(CmpSource)] = PathDelim) do System.Delete(CmpSource,Length(CmpSource),1);

  //debugln('TryCreaterelativePath: CmpDest   = "',cmpdest,'"');
  //debugln('TryCreaterelativePath: CmpSource = "',cmpsource,'"');
  CmpDestLen := Length(CmpDest);
  CmpSourceLen := Length(CmpSource);

  DestCount := SplitDirs(CmpDest, DestDirs);
  SourceCount :=  SplitDirs(CmpSource, SourceDirs);

  //debugln('TryCreaterelativePath: DestDirs:');
  //for i := 1 to DestCount do debugln(DbgS(i),' "',DestDirs[i],'"'); debugln;
  //debugln('TryCreaterelativePath:');
  //for i := 1 to SourceCount do debugln(DbgS(i),' "',SourceDirs[i],'"'); debugln;


  i := 1;
  SharedFolders := 0;
  while (i <= DestCount) and (i <= SourceCount) do
  begin
    if (CompareFunc(DestDirs[i], SourceDirs[i]) = 0) then
    begin
      Inc(SharedFolders);
      Inc(i);
    end
    else
    begin
      Break;
    end;
  end;

  //debugln('TryCreaterelativePath: SharedFolders = ',DbgS(SharedFolders));
  if (SharedFolders = 0) and ((not IsAbs) or AlwaysRequireSharedBaseFolder) and not ((CmpDestLen = 0) and (CmpSourceLen = 0)) then
  begin
    //debguln('TryCreaterelativePath: FAIL: IsAbs = ',DbgS(IsAs),' AlwaysRequireSharedBaseFolder = ',DbgS(AlwaysRequireSharedBaseFolder),
    //' SharedFolders = 0, CmpDestLen = ',DbgS(cmpdestlen),' CmpSourceLen = ',DbgS(CmpSourceLen));
    Exit;
  end;
  LevelsBack := SourceCount - SharedFolders;
  LevelsUp := DestCount - SharedFolders;
  //debugln('TryCreaterelativePath: LevelsBack = ',DbgS(Levelsback));
  //debugln('TryCreaterelativePath: LevelsUp   = ',DbgS(LevelsUp));
  if (LevelsBack > 0) then
  begin
    RelPath := '';
    for i := 1 to LevelsBack do RelPath := '..' + PathDelim + Relpath;

    for i := LevelsUp downto 1 do
    begin
      if (RelPath <> '') and (RelPath[Length(RelPath)] <> PathDelim) then RelPath := RelPath + PathDelim;
      RelPath := RelPath + DestDirs[DestCount + 1 - i];
    end;
    RelPath := ChompPathDelim(RelPath);
  end
  else
  begin
    RelPath := '';
    for i := LevelsUp downto 1 do
    begin
      if (RelPath <> '') then RelPath := RelPath + PathDelim;
      RelPath := RelPath + DestDirs[DestCount + 1 - i];
    end;
  end;
  if UsePointDirectory and (RelPath = '') then
    RelPath := '.'; // Dest = Source

  Result := True;
end;

function CreateRelativePath(const Filename, BaseDirectory: string;
  UsePointDirectory: boolean;  AlwaysRequireSharedBaseFolder: Boolean): string;
var
  RelPath: String;
begin
  Result:=Filename;
  if TryCreateRelativePath(FileName, Basedirectory, UsePointDirectory, AlwaysRequireSharedBaseFolder, RelPath) then
    Result := RelPath;
end;

procedure FindCloseUTF8(var F: TSearchrec);
begin
  SysUtils.FindClose(F);
end;

///////////////////////////inc end


{ creates a directory (not forced) By Lars (NRCOL) } 
function MakeDir(s: astr): boolean;
begin
  result:= false;
 {$I-} // temporarily shut of io checking
  MkDir(s);
 {$I+}
  if IOResult <> 0 then
    result:= false
  else
    result:= true;
end;


{ cross platform file path slashes normalized
  By Lars (NRCOL) }
procedure Xpath(var path: astr);
begin
 {$IFDEF WINDOWS}path:= substrreplace(path, '/', '\');{$ENDIF}
 {$IFDEF UNIX}path:= substrreplace(path, '\', '/');{$ENDIF}
end;

{ creates new file, returns true if success  
  By Lars (NRCOL)}
function NewFile(const fname: astr): boolean;
var
  fh: file of byte;
  oldfmode: byte;
begin
  result := false;
  oldfmode:= filemode;
  filemode:= fmOpenReadWrite; //  we need write access
 {$I-} // temporarily turn off io checking
  assign(fh, fname);
  rewrite(fh);
 {$I+}
  if ioresult = 0 then
  begin
    result := true;
    close(fh);
  end;
  //    debugln('FileExists_readwrite: ' + fname);
  filemode:= oldfmode;
end;


{ Checks if file exists, returns true if success
  By Vladimir/Lars (Artistic) }
function FileExists_plain(const fname: astr): boolean;
var
  fh: file of byte;
begin
  result := false;
 {$I-} // temporarily turn off io checking
  assign(fh, fname);
  reset(fh);
 {$I+}
  if ioresult = 0 then
  begin
    result := true;
    close(fh);
  end;
end;

{ Checks if file exists read only, returns true if success
  By Vladimir/Lars (Artistic) }
function FileExists_read(const fname: astr): boolean;
var
  fh: file of byte;
  oldfmode: byte;
begin
  result := false;
  oldfmode:= filemode;
  filemode:= fmOpenRead; // all we need is read access
 {$I-} // temporarily turn off io checking
  assign(fh, fname);
  reset(fh);
 {$I+}
  if ioresult = 0 then
  begin
    result := true;
    close(fh);
  end;
  filemode:= oldfmode;
end;

{ Checks if file exists with write access, returns true if success
  By Vladimir/Lars (artistic) }
function FileExists_readwrite(const fname: astr): boolean;
var
  fh: file of byte;
  oldfmode: byte;
begin
  result := false;
  oldfmode:= filemode;
  filemode:= fmOpenReadWrite; //  we need write access
 {$I-} // temporarily turn off io checking
  assign(fh, fname);
  reset(fh);
 {$I+}
  if ioresult = 0 then
  begin
    result := true;
    close(fh);
  end;
  //    debugln('FileExists_readwrite: ' + fname);
  filemode:= oldfmode;
end;


{ Returns last I/O error message
  By Vladimir (artistic) }
function FileError: astr;
begin
  case ioresult of
    2: result := 'File not found';
    3: result := 'Path not found';
    4: result := 'Too many open files';
    5: result := 'Access denied';
    6: result := 'Invalid file handle';
    12: result := 'Invalid file-access mode';
    15: result := 'Invalid disk number';
    16: result := 'Cannot remove current directory';
    17: result := 'Cannot rename across volumes';
    100: result := 'Error when reading from disk';
    101: result := 'Error when writing to disk';
    102: result := 'File not assigned';
    103: result := 'File not open';
    104: result := 'File not opened for input';
    105: result := 'File not opened for output';
    106: result := 'Invalid number';
    150: result := 'Disk is write protected';
    151: result := 'Unknown device';
    152: result := 'Drive not ready';
    153: result := 'Unknown command';
    154: result := 'CRC check failed';
    155: result := 'Invalid drive specified';
    156: result := 'Seek error on disk';
    157: result := 'Invalid media type';
    158: result := 'Sector not found';
    159: result := 'Printer out of paper';
    160: result := 'Error when writing to device';
    161: result := 'Error when reading from device';
    162: result := 'Hardware failure';
  else
    // Emtpy line - OK
    result := '';
  end;
end;

{ Alternative to fileexists, not requiring sysutils and uses Assign() and I/O
  to check if file exists }
function FileThere(const fname: astr; fm: TFmode): boolean;
begin
  if fname = '' then exit;
  case fm of
    fmDefault: result:= fileexists_plain(fname);
    fmR:       result:= fileexists_read(fname);
    fmRW:      result:= fileexists_readwrite(fname);
  end;
end;



function CompareFilenames(const Filename1, Filename2: string): integer;
{$IFDEF darwin}
var
  F1: CFStringRef;
  F2: CFStringRef;
{$ENDIF}
begin
  {$IFDEF darwin}
  if Filename1=Filename2 then exit(0);
  if (Filename1='') or (Filename2='') then
    exit(length(Filename2)-length(Filename1));
  F1:=CFStringCreateWithCString(nil,Pointer(Filename1),kCFStringEncodingUTF8);
  F2:=CFStringCreateWithCString(nil,Pointer(Filename2),kCFStringEncodingUTF8);
  Result:=CFStringCompare(F1,F2,kCFCompareNonliteral
          {$IFDEF CaseInsensitiveFilenames}+kCFCompareCaseInsensitive{$ENDIF});
  CFRelease(F1);
  CFRelease(F2);
  {$ELSE}
    {$IFDEF CaseInsensitiveFilenames}
    Result:=UTF8CompareText(Filename1, Filename2);
    {$ELSE}
    Result:=CompareStr(Filename1, Filename2);
    {$ENDIF}
  {$ENDIF}
end;

function CompareFilenamesIgnoreCase(const Filename1, Filename2: string
  ): integer;
{$IFDEF darwin}
var
  F1: CFStringRef;
  F2: CFStringRef;
{$ENDIF}
begin
  {$IFDEF darwin}
  if Filename1=Filename2 then exit(0);
  F1:=CFStringCreateWithCString(nil,Pointer(Filename1),kCFStringEncodingUTF8);
  F2:=CFStringCreateWithCString(nil,Pointer(Filename2),kCFStringEncodingUTF8);
  Result:=CFStringCompare(F1,F2,kCFCompareNonliteral+kCFCompareCaseInsensitive);
  CFRelease(F1);
  CFRelease(F2);
  {$ELSE}
  Result:= CompareText(Filename1, Filename2);
  {$ENDIF}
end;

function CompareFileExt(const Filename, Ext: string; CaseSensitive: boolean): integer;
// Ext can contain a point or not
var
  n, e : AnsiString;
  FileLen, FilePos, ExtLen, ExtPos: integer;
begin
  FileLen := length(Filename);
  ExtLen := length(Ext);
  FilePos := FileLen;
  while (FilePos>=1) and (Filename[FilePos]<>'.') do dec(FilePos);
  if FilePos < 1 then begin
    // no extension in filename
    Result:=1;
    exit;
  end;
  // skip point
  inc(FilePos);
  ExtPos := 1;
  if (ExtPos <= ExtLen) and (Ext[1] = '.') then inc(ExtPos);

  // compare extensions
  n := Copy(Filename, FilePos, length(FileName));
  e := Copy(Ext, ExtPos, length(Ext));
  if CaseSensitive then
    Result := CompareStr(n, e)
  else
    Result := CompareText(n, e);
  if Result < 0
    then Result := -1
  else
    if Result > 0 then Result := 1;
end;

(*function CompareFileExt2(const Filename, Ext: string): integer;
begin
  Result := CompareFileExt(Filename, Ext, False);
end;*)

function ExtractFileNameOnly(const AFilename: string): string;
var
  StartPos: Integer;
  ExtPos: Integer;
begin
  StartPos:=length(AFilename)+1;
  while (StartPos>1)
  and not (AFilename[StartPos-1] in AllowDirectorySeparators)
  {$IFDEF Windows}and (AFilename[StartPos-1]<>':'){$ENDIF}
  do
    dec(StartPos);
  ExtPos:=length(AFilename);
  while (ExtPos>=StartPos) and (AFilename[ExtPos]<>'.') do
    dec(ExtPos);
  if (ExtPos<StartPos) then ExtPos:=length(AFilename)+1;
  Result:=copy(AFilename,StartPos,ExtPos-StartPos);
end;

{$IFDEF darwin}
function GetDarwinSystemFilename(Filename: string): string;
var
  s: CFStringRef;
  l: CFIndex;
begin
  if Filename='' then exit('');
  s:=CFStringCreateWithCString(nil,Pointer(Filename),kCFStringEncodingUTF8);
  l:=CFStringGetMaximumSizeOfFileSystemRepresentation(s);
  SetLength(Result,l);
  if Result<>'' then begin
    CFStringGetFileSystemRepresentation(s,@Result[1],length(Result));
    SetLength(Result,StrLen(PChar(Result)));
  end;
  CFRelease(s);
end;
{$ENDIF}

function CompareFilenameStarts(const Filename1, Filename2: string): integer;
var
  len1: Integer;
  len2: Integer;
begin
  len1:=length(Filename1);
  len2:=length(Filename2);
  if len1=len2 then begin
    Result:=CompareFilenames(Filename1,Filename2);
    exit;
  end else if len1>len2 then
    Result:=CompareFilenames(copy(Filename1,1,len2),Filename2)
  else
    Result:=CompareFilenames(Filename1,copy(Filename2,1,len1));
  if Result<>0 then exit;
  if len1<len2 then
    Result:=-1
  else
    Result:=1;
end;

function CompareFilenames2(Filename1: PChar; Len1: integer; Filename2: PChar;
  Len2: integer): integer;
var
  {$IFDEF NotLiteralFilenames}
  File1: string;
  File2: string;
  {$ELSE}
  i: Integer;
  {$ENDIF}
begin
  if (Len1=0) or (Len2=0) then begin
    Result:=Len1-Len2;
    exit;
  end;
  {$IFDEF NotLiteralFilenames}
  SetLength(File1,Len1);
  System.Move(Filename1^,File1[1],Len1);
  SetLength(File2,Len2);
  System.Move(Filename2^,File2[1],Len2);
  Result:=CompareFilenames(File1,File2);
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

function CompareFilenamesP(Filename1, Filename2: PChar;
  IgnoreCase: boolean = false): integer;
var
  {$IFDEF darwin}
  F1: CFStringRef;
  F2: CFStringRef;
  Flags: CFStringCompareFlags;
  {$ELSE}
  File1, File2: string;
  Len1: Integer;
  Len2: Integer;
  {$ENDIF}
begin
  if (Filename1=nil) or (Filename1^=#0) then begin
    if (Filename2=nil) or (Filename2^=#0) then begin
      // both empty
      exit;
    end else begin
      // filename1 empty, filename2 not empty
      exit;
    end;
  end else if (Filename2=nil) or (Filename2^=#0) then begin
    // filename1 not empty, filename2 empty
    exit;
  end;

  {$IFDEF CaseInsensitiveFilenames}
  // this platform is by default case insensitive
  IgnoreCase:=true;
  {$ENDIF}
  {$IFDEF darwin}
  F1:=CFStringCreateWithCString(nil,Pointer(Filename1),kCFStringEncodingUTF8);
  F2:=CFStringCreateWithCString(nil,Pointer(Filename2),kCFStringEncodingUTF8);
  Flags:=kCFCompareNonliteral;
  if IgnoreCase then Flags+=kCFCompareCaseInsensitive;
  Result:=CFStringCompare(F1,F2,Flags);
  CFRelease(F1);
  CFRelease(F2);
  {$ELSE}
  if IgnoreCase then begin
    // compare case insensitive
    Len1:=StrLen(Filename1);
    SetLength(File1,Len1);
    System.Move(Filename1^,File1[1],Len1);
    Len2:=StrLen(Filename2);
    SetLength(File2,Len2);
    System.Move(Filename2^,File2[1],Len2);
    Result:= CompareText(File1,File2);
  end else begin
    // compare literally
    while (Filename1^=Filename2^) and (Filename1^<>#0) do begin
      inc(Filename1);
      Inc(Filename2);
    end;
    Result:=ord(Filename1^)-ord(Filename2^);
  end;
  {$ENDIF}
end;

function DirPathExists(DirectoryName: string): boolean;
begin
  Result:= DirectoryExists(ChompPathDelim(DirectoryName));
end;

function DirectoryIsWritable(const DirectoryName: string): boolean;
var
  TempFilename: String;
  s: String;
  fHandle: THANDLE;
begin
  TempFilename:= getTempFilenameUTF8(AppendPathDelim(DirectoryName),'tstperm');
  Result:=false;
  fHandle := FileCreate(TempFileName);   //, fmCreate, 438);
  if (THandle(fHandle) <> -1) then
  begin
    s:='WriteTest';
    if FileWrite(fHandle,S[1],Length(S)) > 0 then Result := True;
    FileClose(fHandle);
    if not Sysutils.DeleteFile(TempFilename) then
      InvalidateFileStateCache(TempFilename);
  end;
end;

function ForceDirectory(DirectoryName: string): boolean;
var i: integer;
  Dir: string;
begin
  DirectoryName:=AppendPathDelim(DirectoryName);
  i:=1;
  while i<=length(DirectoryName) do begin
    if DirectoryName[i] in AllowDirectorySeparators then begin
      Dir:=copy(DirectoryName,1,i-1);
      if not DirPathExists(Dir) then begin
        Result:=CreateDir(Dir);
        if not Result then exit;
      end;
    end;
    inc(i);
  end;
  Result:=true;
end;


function FileIsText(const AFilename: string): boolean;
var
  FileReadable: Boolean;
begin
  Result:=FileIsText2(AFilename,FileReadable);
  if FileReadable then ;
end;

function FileIsText2(const AFilename: string; out FileReadable: boolean): boolean;
var
  Buf: string;
  Len: integer;
  NewLine: boolean;
  p: PChar;
  ZeroAllowed: Boolean;
  fHandle: THandle;
begin
  Result:=false;
  FileReadable:=true;
  fHandle := FileOpen(AFileName, fmOpenRead or fmShareDenyNone);
  if (THandle(fHandle) <> -1) then
  begin
    try
      Len:=1024;
      SetLength(Buf,Len+1);
      Len := FileRead(fHandle,Buf[1],Len);

      if Len>0 then begin
        Buf[Len+1]:=#0;
        p:=PChar(Buf);
        ZeroAllowed:=false;
        if (p[0]=#$EF) and (p[1]=#$BB) and (p[2]=#$BF) then begin
          // UTF-8 BOM (Byte Order Mark)
          inc(p,3);
        end else if (p[0]=#$FF) and (p[1]=#$FE) then begin
          // ucs-2le BOM FF FE
          inc(p,2);
          ZeroAllowed:=true;
        end else if (p[0]=#$FE) and (p[1]=#$FF) then begin
          // ucs-2be BOM FE FF
          inc(p,2);
          ZeroAllowed:=true;
        end;
        NewLine:=false;
        while true do begin
          case p^ of
          #0:
            if p-PChar(Buf)>=Len then
              break
            else if not ZeroAllowed then
              exit;
          // #10,#13: new line
          // #12: form feed
          // #26: end of file
          #1..#8,#11,#14..#25,#27..#31: exit;
          #10,#13: NewLine:=true;
          end;
          inc(p);
        end;
        if NewLine or (Len<1024) then
          Result:=true;
      end else
        Result:=true;
    finally
      FileClose(fHandle);
    end
  end
  else
    FileReadable := False;
end;

function FilenameIsTrimmed(const TheFilename: string): boolean;
begin
  Result:=FilenameIsTrimmed2(PChar(Pointer(TheFilename)),// pointer type cast avoids #0 check
                            length(TheFilename));
end;

function FilenameIsTrimmed2(StartPos: PChar; NameLen: integer): boolean;
var
  i: Integer;
begin
  Result:=false;
  if NameLen<=0 then begin
    Result:=true;
    exit;
  end;
  // check heading spaces
  if StartPos[0]=' ' then exit;
  // check trailing spaces
  if StartPos[NameLen-1]=' ' then exit;
  // check ./ at start
  if (StartPos[0]='.') and (StartPos[1] in AllowDirectorySeparators) then exit;
  i:=0;
  while i<NameLen do begin
    if not (StartPos[i] in AllowDirectorySeparators) then
      inc(i)
    else begin
      inc(i);
      if i=NameLen then break;

      {$IFDEF Windows}
      if StartPos[i]='/' then exit;
      {$ENDIF}

      // check for double path delimiter
      if (StartPos[i] in AllowDirectorySeparators) then exit;

      if (StartPos[i]='.') and (i>0) then begin
        inc(i);
        // check /./ or /. at end
        if (StartPos[i] in AllowDirectorySeparators) or (i=NameLen) then exit;
        if StartPos[i]='.' then begin
          inc(i);
          // check /../ or /.. at end
          if (StartPos[i] in AllowDirectorySeparators) or (i=NameLen) then exit;
        end;
      end;
    end;
  end;
  Result:=true;
end;

function TrimFilename(const AFilename: string): string;
//Trim leading and trailing spaces
//then call ResolveDots to trim double path delims and expand special dirs like .. and .

var
  Len, Start: Integer;
begin
  Result := AFileName;
  Len := Length(AFileName);
  if (Len > 0) and not FilenameIsTrimmed(Result) then
  begin
    Start := 1;
    while (Len > 0) and (AFileName[Len] = #32) do Dec(Len);
    while (Start <= Len) and (AFilename[Start] = #32) do Inc(Start);
    if Start > 1 then System.Delete(Result,1,Start-1);
    SetLength(Result, Len - (Start - 1));
    Result:= ResolveDots(Result);
  end;
end;

procedure ForcePathDelims(var FileName: string);
var
  i: Integer;
begin
  for i:=1 to length(FileName) do
    {$IFDEF Windows}
    if Filename[i]='/' then
      Filename[i]:='\';
    {$ELSE}
    if Filename[i]='\' then
      Filename[i]:='/';
    {$ENDIF}
end;

function GetForcedPathDelims(const FileName: string): String;
begin
  Result:=FileName;
  ForcePathDelims(Result);
end;

{------------------------------------------------------------------------------
function CleanAndExpandFilename(const Filename: string): string;
------------------------------------------------------------------------------}
function CleanAndExpandFilename(const Filename: string): string;
begin
  Result:=ExpandFileName(TrimFileName(Filename));
end;

{------------------------------------------------------------------------------
function CleanAndExpandDirectory(const Filename: string): string;
------------------------------------------------------------------------------}
function CleanAndExpandDirectory(const Filename: string): string;
begin
  Result:=AppendPathDelim(CleanAndExpandFilename(Filename));
end;

function TrimAndExpandFilename(const Filename: string; const BaseDir: string): string;
begin
  Result:=ChompPathDelim(TrimFilename(Filename));
  if Result='' then exit;
  Result:=TrimFilename(ExpandFileName(BaseDir));
end;

function TrimAndExpandDirectory(const Filename: string; const BaseDir: string): string;
begin
  Result:=TrimFilename(Filename);
  if Result='' then exit;
  Result:=TrimFilename(AppendPathDelim(ExpandFileName(BaseDir)));
end;



{------------------------------------------------------------------------------
function FileIsInPath(const Filename, Path: string): boolean;
------------------------------------------------------------------------------}
function FileIsInPath(const Filename, Path: string): boolean;
var
  ExpFile: String;
  ExpPath: String;
  l: integer;
begin
  if Path='' then begin
    Result:=false;
    exit;
  end;
  ExpFile:=TrimFilename(Filename);
  ExpPath:=AppendPathDelim(TrimFilename(Path));
  l:=length(ExpPath);
  Result:=(l>0) and (length(ExpFile)>l) and (ExpFile[l]=PathDelim)
          and (CompareFilenames(ExpPath,LeftStr(ExpFile,l))=0);
end;

function AppendPathDelim(const Path: string): string;
begin
  if (Path<>'') and not (Path[length(Path)] in AllowDirectorySeparators) then
    Result:=Path+PathDelim
  else
    Result:=Path;
end;

function ChompPathDelim(const Path: string): string;
var
  Len, MinLen: Integer;
begin
  if Path = '' then
    exit;

  Result:=Path;
  Len:=length(Result);
  if (Result[1] in AllowDirectorySeparators) then begin
    MinLen := 1;
    {$IFDEF HasUNCPaths}
    if (Len >= 2) and (Result[2] in AllowDirectorySeparators) then
      MinLen := 2; // keep UNC '\\', chomp 'a\' to 'a'
    {$ENDIF}
  end
  else begin
    MinLen := 0;
    {$IFdef MSWindows}
    if (Len >= 3) and (Result[1] in ['a'..'z', 'A'..'Z']) and
       (Result[2] = ':') and (Result[3] in AllowDirectorySeparators)
    then
      MinLen := 3;
    {$ENDIF}
  end;

  while (Len > MinLen) and (Result[Len] in AllowDirectorySeparators) do dec(Len);
  if Len<length(Result) then
    SetLength(Result,Len);
end;

function FilenameIsAbsolute(const TheFilename: string):boolean;
begin
  Result:=FilenameIsUnixAbsolute(TheFilename);
end;

function CreateAbsoluteSearchPath(const SearchPath, BaseDirectory: string): string;
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

function CreateRelativeSearchPath(const SearchPath, BaseDirectory: string): string;
var
  PathLen: Integer;
  EndPos: Integer;
  StartPos: Integer;
  CurDir: String;
  NewCurDir: String;
  DiffLen: Integer;
begin
  Result:=SearchPath;
  if (SearchPath='') or (BaseDirectory='') then exit;

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
    if FilenameIsAbsolute(CurDir) then begin
      NewCurDir:=CreateRelativePath(CurDir,BaseDirectory);
      if (NewCurDir<>CurDir) and (NewCurDir='') then
        NewCurDir:='.';
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

function MinimizeSearchPath(const SearchPath: string): string;
// trim the paths, remove doubles and empty paths
var
  StartPos: Integer;
  EndPos: LongInt;
  NewPath: String;
begin
  Result:=SearchPath;
  StartPos:=1;
  while StartPos<=length(Result) do begin
    EndPos:=StartPos;
    while (EndPos<=length(Result)) and (Result[EndPos]<>';') do
      inc(EndPos);
    if StartPos<EndPos then begin
      // trim path and chomp PathDelim
      if (Result[EndPos-1] in AllowDirectorySeparators)
      or (not FilenameIsTrimmed2(@Result[StartPos],EndPos-StartPos)) then begin
        NewPath:=ChompPathDelim(
                           TrimFilename(copy(Result,StartPos,EndPos-StartPos)));
        Result:=copy(Result,1,StartPos-1)+NewPath+copy(Result,EndPos,length(Result));
        EndPos:=StartPos+length(NewPath);
      end;
      // check if path already exists
      if (Length(Result) > 0) and
         (FindPathInSearchPath(@Result[StartPos],EndPos-StartPos, @Result[1],StartPos-1) <> nil)
      then begin
        // remove path
        System.Delete(Result,StartPos,EndPos-StartPos+1);
      end else begin
        StartPos:=EndPos+1;
      end;
    end else begin
      // remove empty path
      System.Delete(Result,StartPos,1);
    end;
  end;
  if (Result<>'') and (Result[length(Result)]=';') then
    SetLength(Result,length(Result)-1);
end;

function FindPathInSearchPath(APath: PChar; APathLen: integer;
  SearchPath: PChar; SearchPathLen: integer): PChar;
var
  StartPos: Integer;
  EndPos: LongInt;
  NextStartPos: LongInt;
  CmpPos: LongInt;
  UseQuickCompare: Boolean;
  PathStr: String;
  CurFilename: String;
begin
  Result:=nil;
  if SearchPath=nil then exit;
  if (APath=nil) or (APathLen=0) then exit;
  // ignore trailing PathDelim at end
  while (APathLen>1) and (APath[APathLen-1] in AllowDirectorySeparators) do dec(APathLen);

  {$IFDEF CaseInsensitiveFilenames}
  UseQuickCompare:=false;
  {$ELSE}
    {$IFDEF NotLiteralFilenames}
    CmpPos:=0;
    while (CmpPos<APathLen) and (ord(APath[CmpPos]<128)) do inc(CmpPos);
    UseQuickCompare:=CmpPos=APathLen;
    {$ELSE}
    UseQuickCompare:=true;
    {$ENDIF}
  {$ENDIF}
  if not UseQuickCompare then begin
    SetLength(PathStr,APathLen);
    System.Move(APath^,PathStr[1],APathLen);
  end;

  StartPos:=0;
  while StartPos<SearchPathLen do begin
    // find current path bounds
    NextStartPos:=StartPos;
    while (SearchPath[NextStartPos]<>';') and (NextStartPos<SearchPathLen) do
      inc(NextStartPos);
    EndPos:=NextStartPos;
    // ignore trailing PathDelim at end
    while (EndPos>StartPos+1) and (SearchPath[EndPos-1] in AllowDirectorySeparators) do
      dec(EndPos);
    // compare current path
    if UseQuickCompare then begin
      if EndPos-StartPos=APathLen then begin
        CmpPos:=0;
        while CmpPos<APathLen do begin
          if APath[CmpPos]<>SearchPath[StartPos+CmpPos] then
            break;
          inc(CmpPos);
        end;
        if CmpPos=APathLen then begin
          Result:=@SearchPath[StartPos];
          exit;
        end;
      end;
    end else if EndPos>StartPos then begin
      // use CompareFilenames
      CurFilename:='';
      SetLength(CurFilename,EndPos-StartPos);
      System.Move(SearchPath[StartPos],CurFilename[1],EndPos-StartPos);
      if CompareFilenames(PathStr,CurFilename)=0 then begin
        Result:=@SearchPath[StartPos];
        exit;
      end;
    end;
    StartPos:=NextStartPos+1;
  end;
end;

function FileSearchUTF8(const Name, DirList: String; ImplicitCurrentDir : Boolean = True): String;
Var
  I : longint;
  Temp : String;

begin
  Result:=Name;
  temp:= SetDirSeparators(DirList);
  // Start with checking the file in the current directory
  If ImplicitCurrentDir and (Result <> '') and FileExists(Result) Then
    exit;
  while True do begin
    If Temp = '' then
      Break; // No more directories to search - fail
    I:=pos(PathSeparator,Temp);
    If I<>0 then
      begin
        Result:=Copy (Temp,1,i-1);
        system.Delete(Temp,1,I);
      end
    else
      begin
        Result:=Temp;
        Temp:='';
      end;
    If Result<>'' then
      Result:=AppendPathDelim(Result)+Name;
    If (Result <> '') and FileExists(Result) Then
      exit;
  end;
  Result:='';
end;

function FileIsReadOnlyUTF8(const FileName: String): Boolean;
begin
  //Result:=FileGetAttrUTF8(FileName) and faReadOnly > 0;
end;


function GetAppConfigDirUTF8(Global: Boolean; Create: boolean = false): string;
begin
  //Result:=SysToUTF8(SysUtils.GetAppConfigDir(Global));
  if Result='' then exit;
  //if Create and not ForceDirectoriesUTF8(Result) then
    raise EInOutError.Create(Format(lrsUnableToCreateConfigDirectoryS,[Result]));
end;

function GetAppConfigFileUTF8(Global: Boolean; SubDir: boolean;
  CreateDir: boolean): string;
var
  Dir: string;
begin
  //Result:=SysToUTF8(SysUtils.GetAppConfigFile(Global,SubDir));
  if not CreateDir then exit;
  Dir:=ExtractFilePath(Result);
  if Dir='' then exit;
  //if not ForceDirectoriesUTF8(Dir) then
    raise EInOutError.Create(Format(lrsUnableToCreateConfigDirectoryS,[Dir]));
end;

function GetTempDir: string;
var
  Buffer: array [0..MAX_PATH] of Char;
begin
  SetString(Result, Buffer, GetTempPath(SizeOf(Buffer), Buffer));
end;


function GetTempFileNameUTF8(const Dir, Prefix: String): String;
var
  I: Integer;
  Start: String;
begin
  //if Assigned(OnGetTempFile) then
    //Result:=OnGetTempFile(Dir,Prefix)
  //else
  begin
    if (Dir='') then
      Start:= GetTempDir    //gettempdir
    else
      Start:=IncludeTrailingPathDelimiter(Dir);
    if (Prefix='') then
      Start:=Start+'TMP'
    else
      Start:=Start+Prefix;
    I:=0;
    repeat
      Result:=Format('%s%.5d.tmp',[Start,I]);
      Inc(I);
    until not FileExists(Result);
  end;
end;

function ForceDirectoriesUTF8(const Dir: string): Boolean;
var
  E: EInOutError;
  ADrv : String;

  function DoForceDirectories(Const Dir: string): Boolean;
  var
    ADir : String;
    APath: String;
  begin
    Result:=True;
    ADir:=ExcludeTrailingPathDelimiter(Dir);
    if (ADir='') then Exit;
    if Not DirectoryExists(ADir) then
      begin
        APath := ExtractFilePath(ADir);
        //this can happen on Windows if user specifies Dir like \user\name/test/
        //and would, if not checked for, cause an infinite recusrsion and a stack overflow
        if (APath = ADir) then
          Result := False
        else
          Result:=DoForceDirectories(APath);
        if Result then
          Result := CreateDir(ADir);
      end;
  end;

  function IsUncDrive(const Drv: String): Boolean;
  begin
    Result := (Length(Drv) > 2) and (Drv[1] in AllowDirectorySeparators) and (Drv[2] in AllowDirectorySeparators);
  end;

begin
  Result := False;
  ADrv := ExtractFileDrive(Dir);
  if (ADrv<>'') and (not DirectoryExists(ADrv))
  {$IFNDEF FORCEDIR_NO_UNC_SUPPORT} and (not IsUncDrive(ADrv)){$ENDIF} then Exit;
  if Dir='' then
    begin
      E:=EInOutError.Create('SCannotCreateEmptyDir');
      E.ErrorCode:=3;
      Raise E;
    end;
  Result := DoForceDirectories(GetForcedPathDelims(Dir));
end;


procedure InvalidateFileStateCache(const Filename: string);
begin
  if Assigned(OnInvalidateFileStateCache) then
    OnInvalidateFileStateCache(Filename);
end;

procedure SplitCmdLineParams(const Params: string; ParamList: TStrings;
                             ReadBackslash: boolean = false);
// split spaces, quotes are parsed as single parameter
// if ReadBackslash=true then \" is replaced to " and not treated as quote
// #0 is always end
type
  TMode = (mNormal,mApostrophe,mQuote);
var
  p: Integer;
  Mode: TMode;
  Param: String;
begin
  p:=1;
  while p<=length(Params) do
  begin
    // skip whitespace
    while (p<=length(Params)) and (Params[p] in [' ',#9,#10,#13]) do inc(p);
    if (p>length(Params)) or (Params[p]=#0) then
      break;
    //writeln('SplitCmdLineParams After Space p=',p,'=[',Params[p],']');
    // read param
    Param:='';
    Mode:=mNormal;
    while p<=length(Params) do
    begin
      case Params[p] of
      #0:
        break;
      '\':
        begin
          inc(p);
          if ReadBackslash then
            begin
            // treat next character as normal character
            if (p>length(Params)) or (Params[p]=#0) then
              break;
            if ord(Params[p])<128 then
            begin
              Param:= Param + Params[p];
              inc(p);
            end else begin
              // next character is already a normal character
            end;
          end else begin
            // treat backslash as normal character
            Param:= Param +'\';
          end;
        end;
      '''':
        begin
          inc(p);
          case Mode of
          mNormal:
            Mode:=mApostrophe;
          mApostrophe:
            Mode:=mNormal;
          mQuote:
            Param:= Param+ '''';
          end;
        end;
      '"':
        begin
          inc(p);
          case Mode of
          mNormal:
            Mode:=mQuote;
          mApostrophe:
            Param:= Param+'"';
          mQuote:
            Mode:=mNormal;
          end;
        end;
      ' ',#9,#10,#13:
        begin
          if Mode=mNormal then break;
          Param:= Param+Params[p];
          inc(p);
        end;
      else
        Param:= Param+ Params[p];
        inc(p);
      end;
    end;
    //writeln('SplitCmdLineParams Param=#'+Param+'#');
    ParamList.Add(Param);
  end;
end;

function StrToCmdLineParam(const Param: string): string;
{ <empty> -> ''
word -> word
word1 word2 -> 'word1 word2'
word's -> "word's"
a" -> 'a"'
"a" -> '"a"'
'a' -> "'a'"
#0 character -> cut the rest
}
const
  NoQuot = ' ';
  AnyQuot = '*';
var
  Quot: Char;
  p: PChar;
  i: Integer;
begin
  Result:=Param;
  if Result='' then
    Result:=''''''
  else begin
    p:=PChar(Result);
    Quot:=NoQuot;
    repeat
      case p^ of
      #0:
        begin
          i:=p-PChar(Result);
          if i<length(Result) then
            Delete(Result,i+1,length(Result));
          case Quot of
          AnyQuot: Result:=''''+Result+'''';
          '''': Result:= result+'''';
          '"': Result:= result+'"';
          end;
          break;
        end;
      ' ',#9,#10,#13:
        begin
          if Quot=NoQuot then
            Quot:=AnyQuot;
          inc(p);
        end;
      '''':
        begin
          case Quot of
          NoQuot,AnyQuot:
            begin
              // need "
              Quot:='"';
              i:=p-PChar(Result);
              System.Insert('"',Result,1);
              p:=PChar(Result)+i+1;
            end;
          '"':
            inc(p);
          '''':
            begin
              // ' within a '
              // => end ', start "
              i:=p-PChar(Result)+1;
              System.Insert('''"',Result,i);
              p:=PChar(Result)+i+1;
              Quot:='"';
            end;
          end;
        end;
      '"':
        begin
          case Quot of
          NoQuot,AnyQuot:
            begin
              // need '
              Quot:='''';
              i:=p-PChar(Result);
              System.Insert('''',Result,1);
              p:=PChar(Result)+i+1;
            end;
          '''':
            inc(p);
          '"':
            begin
              // " within a "
              // => end ", start '
              i:=p-PChar(Result)+1;
              System.Insert('"''',Result,i);
              p:=PChar(Result)+i+1;
              Quot:='''';
            end;
          end;
        end;
      else
        inc(p);
      end;
    until false;
  end;
end;

function MergeCmdLineParams(ParamList: TStrings): string;
var
  i: Integer;
begin
  Result:='';
  if ParamList=nil then exit;
  for i:=0 to ParamList.Count-1 do
  begin
   if i>0 then Result:= result +' ';
    Result:= result+ StrToCmdLineParam(ParamList[i]);
  end;
end;

{
Returns
- DriveLetter + : + PathDelim on Windows (if present) or
- UNC Share on Windows if present or
- PathDelim if FileName starts with PathDelim on Unix or Wince or
- Empty string of non eof the above applies
}
function ExtractFileRoot(FileName: String): String;
var
  Len: Integer;
begin
  Result := '';
  Len := Length(FileName);
  if (Len > 0) then
  begin
    //if IsUncPath(FileName) then
    begin
      //Result := ExtractUNCVolume(FileName);
      // is it like \\?\C:\Directory? then also include the "C:\" part
      if (Result = '\\?\') and (Length(FileName) > 6) and
         (FileName[5] in ['a'..'z','A'..'Z']) and (FileName[6] = ':') and (FileName[7] in AllowDirectorySeparators)
      then
        Result := Copy(FileName, 1, 7);
    end;
    //else
    //begin
   (*   {$if defined(unix) or defined(wince)}
      if (FileName[1] = PathDelim) then Result := PathDelim;
      {$else} *)
      if (Len > 2) and (FileName[1] in ['a'..'z','A'..'Z']) and (FileName[2] = ':') and (FileName[3] in AllowDirectorySeparators) then
        Result := UpperCase(Copy(FileName,1,3));
    end;
  //end;
end;

//initialization
  //InitLazFileUtils;

end.



//components/lazutils/lazfileutils.pas


----app_template_loaded_code----