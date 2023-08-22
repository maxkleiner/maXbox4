{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 4.00                                        }
{   File name:        cFileUtils.pas                                           }
{   File version:     4.11                                                     }
{   Description:      File name and file system functions                      }
{                                                                              }
{   Copyright:        Copyright © 2002-2012, David J Butler                    }
{                     All rights reserved.                                     }
{                     Redistribution and use in source and binary forms, with  }
{                     or without modification, are permitted provided that     }
{                     the following conditions are met:                        }
{                     Redistributions of source code must retain the above     }
{                     copyright notice, this list of conditions and the        }
{                     following disclaimer.                                    }
{                     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND   }
{                     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED          }
{                     WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED   }
{                     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A          }
{                     PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL     }
{                     THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,    }
{                     INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR             }
{                     CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,    }
{                     PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF     }
{                     USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)         }
{                     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER   }
{                     IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING        }
{                     NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE   }
{                     USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE             }
{                     POSSIBILITY OF SUCH DAMAGE.                              }
{                                                                              }
{   Home page:        http://fundementals.sourceforge.net                      }
{   Forum:            http://sourceforge.net/forum/forum.php?forum_id=2117     }
{   E-mail:           fundamentalslib at gmail.com                             }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{   2002/06/01  3.01  Created cFileUtils from cSysUtils.                       }
{   2002/12/12  3.02  Revision.                                                }
{   2005/07/22  4.03  Compilable with FreePascal 2 Win32 i386.                 }
{   2005/08/21  4.04  Compilable with FreePascal 2 Linux i386.                 }
{   2005/09/20  4.05  Improved error handling.                                 }
{   2005/09/21  4.06  Revised for Fundamentals 4.                              }
{   2008/12/30  4.07  Revision.                                                }
{   2009/06/05  4.08  File access functions.                                   }
{   2009/07/30  4.09  File access functions.                                   }
{   2010/06/27  4.10  Compilable with FreePascal 2.4.0 OSX x86-64              }
{   2012/03/26  4.11  Unicode update.                                          }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Borland Delphi 5/6/7/2005/2006/2007 Win32 i386                             }
{   FreePascal 2 Win32 i386                                                    }
{   FreePascal 2 Linux i386                                                    }
{                                                                              }
{******************************************************************************}

{$INCLUDE cDefines.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}{$HINTS OFF}
{$ENDIF}
{$IFDEF DELPHI6_UP}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

{$DEFINE DEBUG}
{$DEFINE SELFTEST}


unit cFileUtils;

interface

uses
  { System }
  {$IFDEF MSWIN}
  Windows,
  {$ENDIF}
  SysUtils;



{                                                                              }
{ Path functions                                                               }
{                                                                              }
const
  PathSeparator = {$IFDEF UNIX}  '/' {$ENDIF}
                  {$IFDEF MSWIN} '\' {$ENDIF};
  chBackSlash    = AnsiChar('\');
  chForwardSlash = AnsiChar('/');
  csSlash           = [chBackSlash, chForwardSlash];


function  PathHasDriveLetterA(const Path: AnsiString): Boolean;
function  PathHasDriveLetter(const Path: String): Boolean;

function  PathIsDriveLetterA(const Path: AnsiString): Boolean;
function  PathIsDriveLetter(const Path: String): Boolean;

function  PathIsDriveRootA(const Path: AnsiString): Boolean;
function  PathIsDriveRoot(const Path: String): Boolean;

function  PathIsRootA(const Path: AnsiString): Boolean;
function  PathIsRoot(const Path: String): Boolean;

function  PathIsUNCPathA(const Path: AnsiString): Boolean;
function  PathIsUNCPath(const Path: String): Boolean;

function  PathIsAbsoluteA(const Path: AnsiString): Boolean;
function  PathIsAbsolute(const Path: String): Boolean;

function  PathIsDirectoryA(const Path: AnsiString): Boolean;
function  PathIsDirectory(const Path: String): Boolean;

function  PathInclSuffixA(const Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  PathInclSuffix(const Path: String;
          const PathSep: Char = PathSeparator): String;

function  PathExclSuffixA(const Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  PathExclSuffix(const Path: String;
          const PathSep: Char = PathSeparator): String;

procedure PathEnsureSuffixA(var Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator);
procedure PathEnsureSuffix(var Path: String;
          const PathSep: Char = PathSeparator);

procedure PathEnsureNoSuffixA(var Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator);
procedure PathEnsureNoSuffix(var Path: String;
          const PathSep: Char = PathSeparator);

(*function  PathCanonicalA(const Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator): AnsiString;*)
function  PathCanonical(const Path: String;
          const PathSep: Char = PathSeparator): String;

//function  PathExpandA(const Path: AnsiString; const BasePath: AnsiString = '';
  //        const PathSep: AnsiChar = PathSeparator): AnsiString;
function  PathExpand(const Path: String; const BasePath: String = '';
          const PathSep: Char = PathSeparator): String;

function  PathLeftElementA(const Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  PathLeftElement(const Path: String;
          const PathSep: Char = PathSeparator): String;

procedure PathSplitLeftElementA(const Path: AnsiString;
          var LeftElement, RightPath: AnsiString;
          const PathSep: AnsiChar = PathSeparator);
procedure PathSplitLeftElement(const Path: String;
          var LeftElement, RightPath: String;
          const PathSep: Char = PathSeparator);

procedure DecodeFilePathA(const FilePath: AnsiString;
          var Path, FileName: AnsiString;
          const PathSep: AnsiChar = PathSeparator);
procedure DecodeFilePath(const FilePath: String;
          var Path, FileName: String;
          const PathSep: Char = PathSeparator);

function  FileNameValidA(const FileName: AnsiString): AnsiString;
function  FileNameValid(const FileName: String): String;

//function  FilePathA(const FileName, Path: AnsiString; const BasePath: AnsiString = '';
  //        const PathSep: AnsiChar = PathSeparator): AnsiString;
function  FilePath(const FileName, Path: String; const BasePath: String = '';
          const PathSep: Char = PathSeparator): String;

//function  DirectoryExpandA(const Path: AnsiString; const BasePath: AnsiString = '';
  //        const PathSep: AnsiChar = PathSeparator): AnsiString;
function  DirectoryExpand(const Path: String; const BasePath: String = '';
          const PathSep: Char = PathSeparator): String;

function  UnixPathToWinPath(const Path: AnsiString): AnsiString;
function  WinPathToUnixPath(const Path: AnsiString): AnsiString;



{                                                                              }
{ File errors                                                                  }
{                                                                              }
type
  TFileError = (
    feNone             {$IFDEF SupportEnumValue} = $00 {$ENDIF},
    feInvalidParameter {$IFDEF SupportEnumValue} = $01 {$ENDIF},

    feFileError        {$IFDEF SupportEnumValue} = $10 {$ENDIF},
    feFileOpenError    {$IFDEF SupportEnumValue} = $11 {$ENDIF},
    feFileCreateError  {$IFDEF SupportEnumValue} = $12 {$ENDIF},
    feFileSharingError {$IFDEF SupportEnumValue} = $13 {$ENDIF},
    feFileSeekError    {$IFDEF SupportEnumValue} = $14 {$ENDIF},
    feFileReadError    {$IFDEF SupportEnumValue} = $15 {$ENDIF},
    feFileWriteError   {$IFDEF SupportEnumValue} = $16 {$ENDIF},
    feFileSizeError    {$IFDEF SupportEnumValue} = $17 {$ENDIF},
    feFileExists       {$IFDEF SupportEnumValue} = $18 {$ENDIF},
    feFileDoesNotExist {$IFDEF SupportEnumValue} = $19 {$ENDIF},
    feFileMoveError    {$IFDEF SupportEnumValue} = $1A {$ENDIF},
    feFileDeleteError  {$IFDEF SupportEnumValue} = $1B {$ENDIF},

    feOutOfSpace       {$IFDEF SupportEnumValue} = $20 {$ENDIF},
    feOutOfResources   {$IFDEF SupportEnumValue} = $21 {$ENDIF},
    feInvalidFilePath  {$IFDEF SupportEnumValue} = $22 {$ENDIF},
    feInvalidFileName  {$IFDEF SupportEnumValue} = $23 {$ENDIF},
    feAccessDenied     {$IFDEF SupportEnumValue} = $24 {$ENDIF},
    feDeviceFailure    {$IFDEF SupportEnumValue} = $25 {$ENDIF}
  );

  EFileError = class(Exception)
  private
    FFileError : TFileError;

  public
    constructor Create(const FileError: TFileError; const Msg: string);
    constructor CreateFmt(const FileError: TFileError; const Msg: string; const Args: array of const);

    property FileError: TFileError read FFileError;
  end;

  //StringArray = array of String;



{                                                                              }
{ File operations                                                              }
{                                                                              }
type
  TFileHandle = Integer;

  TFileAccess = (
    faRead,
    faWrite,
    faReadWrite);

  TFileSharing = (
    fsDenyNone,
    fsDenyRead,
    fsDenyWrite,
    fsDenyReadWrite,
    fsExclusive);

  TFileOpenFlags = set of (
    foDeleteOnClose,
    foNoBuffering,
    foWriteThrough,
    foRandomAccessHint,
    foSequentialScanHint,
    foSeekToEndOfFile);

  TFileCreationMode = (
    fcCreateNew,
    fcCreateAlways,
    fcOpenExisting,
    fcOpenAlways,
    fcTruncateExisting);

  TFileSeekPosition = (
    fpOffsetFromStart,
    fpOffsetFromCurrent,
    fpOffsetFromEnd);

  PFileOpenWait = ^TFileOpenWait;
  TFileOpenWaitProcedure = procedure (const FileOpenWait: PFileOpenWait);
  TFileOpenWait = packed record
    Wait           : Boolean;
    UserData       : LongWord;
    Timeout        : Integer;
    RetryInterval  : Integer;
    RetryRandomise : Boolean;
    Callback       : TFileOpenWaitProcedure;
    Aborted        : Boolean;
    {$IFDEF MSWIN}
    Signal         : THandle;
    {$ENDIF}
  end;

//function  StrReplace(const Find: CharSet; const Replace, S: String): String; overload;


function  FileOpenExA(
          const FileName: AnsiString;
          const FileAccess: TFileAccess = faRead;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileOpenFlags: TFileOpenFlags = [];
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): TFileHandle;

function  FileSeekEx(
          const FileHandle: TFileHandle;
          const FileOffset: Int64;
          const FilePosition: TFileSeekPosition = fpOffsetFromStart): Int64;
function  FileReadEx(
          const FileHandle: TFileHandle;
          var Buf; const BufSize: Integer): Integer;
function  FileWriteEx(
          const FileHandle: TFileHandle;
          const Buf; const BufSize: Integer): Integer;
procedure FileCloseEx(
          const FileHandle: TFileHandle);

function  FileExistsA(const FileName: AnsiString): Boolean;
function  FileExists(const FileName: String): Boolean;

function  FileGetSize(const FileName: String): Int64;

function  FileGetDateTime(const FileName: String): TDateTime;
function  FileGetDateTime2(const FileName: String): TDateTime;
function  FileIsReadOnly(const FileName: String): Boolean;

procedure FileDeleteEx(const FileName: String);
procedure FileRenameEx(const OldFileName, NewFileName: String);

function  ReadFileBufA(
          const FileName: AnsiString;
          var Buf; const BufSize: Integer;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): Integer;
function  ReadFileStrA(
          const FileName: AnsiString;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): AnsiString;

procedure AppendFileA(
          const FileName: AnsiString;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
procedure AppendFileStrA(
          const FileName: AnsiString;
          const Buf: AnsiString;
          const FileSharing: TFileSharing = fsDenyWrite;
          const FileCreationMode: TFileCreationMode = fcOpenAlways;
          const FileOpenWait: PFileOpenWait = nil);

function  DirectoryEntryExists(const Name: String): Boolean;
function  DirectoryEntrySize(const Name: String): Int64;

function  DirectoryExists(const DirectoryName: String): Boolean;
function  DirectoryGetDateTime(const DirectoryName: String): TDateTime;
procedure DirectoryCreate(const DirectoryName: String);


{                                                                              }
{ File / Directory operations                                                  }
{   MoveFile first attempts a rename, then a copy and delete.                  }
{                                                                              }
function  GetFirstFileNameMatching(const FileMask: String): String;
function  DirEntryGetAttr(const FileName: AnsiString): Integer;
function  DirEntryIsDirectory(const FileName: AnsiString): Boolean;
function  FileHasAttr(const FileName: String; const Attr: Word): Boolean;

procedure CopyFile(const FileName, DestName: String);
procedure MoveFile(const FileName, DestName: String);
function  DeleteFiles(const FileMask: String): Boolean;



{$IFDEF MSWIN}
{                                                                              }
{ Logical Drive functions                                                      }
{                                                                              }
type
  TLogicalDriveType = (
      DriveRemovable,
      DriveFixed,
      DriveRemote,
      DriveCDRom,
      DriveRamDisk,
      DriveTypeUnknown);

function  DriveIsValid(const Drive: AnsiChar): Boolean;
function  DriveGetType(const Path: AnsiString): TLogicalDriveType;
function  DriveFreeSpace(const Path: AnsiString): Int64;
{$ENDIF}

 type
  StrReplaceMatchArray = Array[0..4095] of Integer;
   AsciiChar = AnsiChar;


{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF DEBUG}{$IFDEF SELFTEST}
procedure SelfTest;
{$ENDIF}{$ENDIF}



implementation

uses
  { Fundamentals }
  cFundamentUtils
  //cDynArrays
  //cStrings
  {$IFDEF UNIX}
  , BaseUnix
  {$IFDEF FREEPASCAL}
  , Unix
  {$ELSE}
  , libc
  {$ENDIF}
  {$ENDIF};



{$IFDEF DELPHI6_UP}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}


const
  AsciiLowCaseLookup: Array[AsciiChar] of AsciiChar = (
    #$00, #$01, #$02, #$03, #$04, #$05, #$06, #$07,
    #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F,
    #$10, #$11, #$12, #$13, #$14, #$15, #$16, #$17,
    #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F,
    #$20, #$21, #$22, #$23, #$24, #$25, #$26, #$27,
    #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F,
    #$30, #$31, #$32, #$33, #$34, #$35, #$36, #$37,
    #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F,
    #$40, #$61, #$62, #$63, #$64, #$65, #$66, #$67,
    #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
    #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77,
    #$78, #$79, #$7A, #$5B, #$5C, #$5D, #$5E, #$5F,
    #$60, #$61, #$62, #$63, #$64, #$65, #$66, #$67,
    #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
    #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77,
    #$78, #$79, #$7A, #$7B, #$7C, #$7D, #$7E, #$7F,
    #$80, #$81, #$82, #$83, #$84, #$85, #$86, #$87,
    #$88, #$89, #$8A, #$8B, #$8C, #$8D, #$8E, #$8F,
    #$90, #$91, #$92, #$93, #$94, #$95, #$96, #$97,
    #$98, #$99, #$9A, #$9B, #$9C, #$9D, #$9E, #$9F,
    #$A0, #$A1, #$A2, #$A3, #$A4, #$A5, #$A6, #$A7,
    #$A8, #$A9, #$AA, #$AB, #$AC, #$AD, #$AE, #$AF,
    #$B0, #$B1, #$B2, #$B3, #$B4, #$B5, #$B6, #$B7,
    #$B8, #$B9, #$BA, #$BB, #$BC, #$BD, #$BE, #$BF,
    #$C0, #$C1, #$C2, #$C3, #$C4, #$C5, #$C6, #$C7,
    #$C8, #$C9, #$CA, #$CB, #$CC, #$CD, #$CE, #$CF,
    #$D0, #$D1, #$D2, #$D3, #$D4, #$D5, #$D6, #$D7,
    #$D8, #$D9, #$DA, #$DB, #$DC, #$DD, #$DE, #$DF,
    #$E0, #$E1, #$E2, #$E3, #$E4, #$E5, #$E6, #$E7,
    #$E8, #$E9, #$EA, #$EB, #$EC, #$ED, #$EE, #$EF,
    #$F0, #$F1, #$F2, #$F3, #$F4, #$F5, #$F6, #$F7,
    #$F8, #$F9, #$FA, #$FB, #$FC, #$FD, #$FE, #$FF);






resourcestring
  SCannotOpenFile          = 'Cannot open file: %s: %s';
  SCannotCreateFile        = 'Cannot create file: %s: %s';
  SCannotMoveFile          = 'Cannot move file: %s: %s';
  SFileSizeError           = 'File size error: %s';
  SFileReadError           = 'File read error: %s';
  SFileWriteError          = 'File write error: %s: %s';
  SInvalidFileCreationMode = 'Invalid file creation mode';
  SFileExists              = 'File exists: %s';
  SFileDoesNotExist        = 'File does not exist: %s';
  SInvalidFileHandle       = 'Invalid file handle';
  SInvalidFilePosition     = 'Invalid file position';
  SFileSeekError           = 'File seek error: %s';
  SInvalidFileName         = 'Invalid file name';
  SInvalidPath             = 'Invalid path';
  SFileDeleteError         = 'File delete error: %s';
  SInvalidFileAccess       = 'Invalid file access';
  SInvalidFileSharing      = 'Invalid file sharing';


function PosCharSet(const F: CharSet; const S: String;
    const Index: Integer): Integer;
var P    : PChar;
    C    : Char;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    begin
      C := P^;
      {$IFDEF StringIsUnicode}
      if Ord(C) <= $FF then
      {$ENDIF}
        if AnsiChar(Ord(C)) in F then
          begin
            Result := I;
            exit;
          end else
          begin
            Inc(P);
            Inc(I);
          end;
    end;
  Result := 0;
end;


function StrPMatch(const A, B: PChar; const Len: Integer): Boolean;
var P, Q : PChar;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      if P^ = Q^ then
        begin
          Inc(P);
          Inc(Q);
        end else
        begin
          Result := False;
          exit;
        end;
  Result := True;
end;


function CharMatchNoAsciiCase(const A, B: Char): Boolean;
begin
  if (Ord(A) <= $7F) and (Ord(B) <= $7F) then
    Result := AsciiLowCaseLookup[AnsiChar(Ord(A))] = AsciiLowCaseLookup[AnsiChar(Ord(B))]
  else
    Result := Ord(A) = Ord(B);
end;


function StrPMatchNoAsciiCase(const A, B: PChar; const Len: Integer): Boolean;
var P, Q : PChar;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      begin
        if CharMatchNoAsciiCase(P^, Q^) then
          begin
            Inc(P);
            Inc(Q);
          end else
          begin
            Result := False;
            exit;
          end;
      end;
  Result := True;
end;

function ToStringA(const A: AnsiString): String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(A);
  {$ELSE}
  Result := A;
  {$ENDIF}
end;


function PosStr(const F, S: String; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q    : PChar;
    L, M, I : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  Dec(L, M - 1);
  if AsciiCaseSensitive then
    while I <= L do
      if StrPMatch(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end
  else
    while I <= L do
      if StrPMatchNoAsciiCase(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
  Result := 0;
end;



function StrReplaceBlock( // used by StrReplace
    const FindLen: Integer; const Replace, S: String;
    const StartIndex, StopIndex: Integer;
    const MatchCount: Integer;
    const Matches: StrReplaceMatchArray): String;
var StrLen     : Integer;
    ReplaceLen : Integer;
    NewLen     : Integer;
    I, J, F, G : Integer;
    P, Q       : PChar;
begin
  ReplaceLen := Length(Replace);
  StrLen := StopIndex - StartIndex + 1;
  NewLen := StrLen + (ReplaceLen - FindLen) * MatchCount;
  if NewLen = 0 then
    begin
      Result := '';
      exit;
    end;
  SetString(Result, nil, NewLen);
  P := Pointer(Result);
  Q := Pointer(S);
  F := StartIndex;
  Inc(Q, F - 1);
  for I := 0 to MatchCount - 1 do
    begin
      G := Matches[I];
      J := G - F;
      if J > 0 then
        begin
          MoveMem(Q^, P^, J * SizeOf(Char));
          Inc(P, J);
          Inc(Q, J);
          Inc(F, J);
        end;
      Inc(Q, FindLen);
      Inc(F, FindLen);
      if ReplaceLen > 0 then
        begin
          MoveMem(Pointer(Replace)^, P^, ReplaceLen * SizeOf(Char));
          Inc(P, ReplaceLen);
        end;
    end;
  if F <= StopIndex then
    MoveMem(Q^, P^, (StopIndex - F + 1) * SizeOf(Char));
end;


function StrReplace(const Find, Replace, S: String; const AsciiCaseSensitive: Boolean): String;
var FindLen    : Integer;
    Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  FindLen := Length(Find);
  if FindLen = 0 then // nothing to find
    begin
      Result := S;
      exit;
    end;
  I := PosStr(Find, S, 1, AsciiCaseSensitive);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I, FindLen);
      I := PosStr(Find, S, I, AsciiCaseSensitive);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlock(FindLen, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;


(*function StrReplace(const Find: CharSet; const Replace, S: String): String;
var Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  I := PosCharSet(Find, S, 1);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I);
      I := PosCharSet(Find, S, I);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlock(1, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end; *)


{                                                                              }
{ Path functions                                                               }
{                                                                              }
function PathHasDriveLetterA(const Path: AnsiString): Boolean;
var P: PAnsiChar;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  P := Pointer(Path);
  if not (P^ in ['A'..'Z', 'a'..'z']) then
    exit;
  Inc(P);
  if P^ <> ':' then
    exit;
  Result := True;
end;

function PathHasDriveLetter(const Path: String): Boolean;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  case Path[1] of
    'A'..'Z', 'a'..'z' : ;
  else
    exit;
  end;
  if Path[2] <> ':' then
    exit;
  Result := True;
end;

function PathIsDriveLetterA(const Path: AnsiString): Boolean;
begin
  Result := (Length(Path) = 2) and PathHasDriveLetterA(Path);
end;

function PathIsDriveLetter(const Path: String): Boolean;
begin
  Result := (Length(Path) = 2) and PathHasDriveLetter(Path);
end;

function PathIsDriveRootA(const Path: AnsiString): Boolean;
begin
  Result := (Length(Path) = 3) and PathHasDriveLetterA(Path) and
            (Path[3] = '\');
end;

function PathIsDriveRoot(const Path: String): Boolean;
begin
  Result := (Length(Path) = 3) and PathHasDriveLetter(Path) and
            (Path[3] = '\');
end;

function PathIsRootA(const Path: AnsiString): Boolean;
begin
  Result := ((Length(Path) = 1) and (Path[1] in csSlash)) or
            PathIsDriveRootA(Path);
end;

function PathIsRoot(const Path: String): Boolean;
begin
  Result := PathIsDriveRoot(Path);
  if Result then
    exit;
  if Length(Path) = 1 then
    case Path[1] of
      '/', '\' : Result := True;
    end;
end;

function PathIsUNCPathA(const Path: AnsiString): Boolean;
var P: PAnsiChar;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  P := Pointer(Path);
  if P^ <> '\' then
    exit;
  Inc(P);
  if P^ <> '\' then
    exit;
  Result := True;
end;

function PathIsUNCPath(const Path: String): Boolean;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  if Path[1] <> '\' then
    exit;
  if Path[2] <> '\' then
    exit;
  Result := True;
end;

function PathIsAbsoluteA(const Path: AnsiString): Boolean;
begin
  if Path = '' then
    Result := False else
  if PathHasDriveLetterA(Path) then
    Result := True else
  if PAnsiChar(Pointer(Path))^ in ['\', '/'] then
    Result := True else
    Result := False;
end;

function PathIsAbsolute(const Path: String): Boolean;
begin
  if Path = '' then
    Result := False else
  if PathHasDriveLetter(Path) then
    Result := True
  else
    case Path[1] of
      '\', '/' : Result := True;
    else
      Result := False;
    end;
end;

function PathIsDirectoryA(const Path: AnsiString): Boolean;
var L: Integer;
    P: PAnsiChar;
begin
  L := Length(Path);
  if L = 0 then
    Result := False else
  if (L = 2) and PathHasDriveLetterA(Path) then
    Result := True else
    begin
      P := Pointer(Path);
      Inc(P, L - 1);
      Result := P^ in csSlash;
    end;
end;

function PathIsDirectory(const Path: String): Boolean;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := False else
  if (L = 2) and PathHasDriveLetter(Path) then
    Result := True
  else
    case Path[L] of
      '/', '\' : Result := True;
    else
      Result := False;
    end;
end;

function PathInclSuffixA(const Path: AnsiString; const PathSep: AnsiChar): AnsiString;
var L: Integer;
    P: PAnsiChar;
begin
  L := Length(Path);
  if L = 0 then
    Result := '' else
    begin
      P := Pointer(Path);
      Inc(P, L - 1);
      if P^ = PathSep then
        Result := Path else
        Result := Path + PathSep;
    end;
end;

function PathInclSuffix(const Path: String; const PathSep: Char): String;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := '' else
    begin
      if Path[L] = PathSep then
        Result := Path else
        Result := Path + PathSep;
    end;
end;

procedure PathEnsureSuffixA(var Path: AnsiString; const PathSep: AnsiChar);
begin
  Path := PathInclSuffixA(Path, PathSep);
end;

procedure PathEnsureSuffix(var Path: String; const PathSep: Char);
begin
  Path := PathInclSuffix(Path, PathSep);
end;

procedure PathEnsureNoSuffixA(var Path: AnsiString; const PathSep: AnsiChar);
begin
  Path := PathExclSuffixA(Path, PathSep);
end;

procedure PathEnsureNoSuffix(var Path: String; const PathSep: Char);
begin
  Path := PathExclSuffix(Path, PathSep);
end;

function PathExclSuffixA(const Path: AnsiString; const PathSep: AnsiChar): AnsiString;
var L: Integer;
    P: PAnsiChar;
begin
  L := Length(Path);
  if L = 0 then
    Result := '' else
    begin
      P := Pointer(Path);
      Inc(P, L - 1);
      if P^ = PathSep then
        Result := Copy(Path, 1, L - 1) else
        Result := Path;
    end;
end;

function PathExclSuffix(const Path: String; const PathSep: Char): String;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := '' else
    begin
      if Path[L] = PathSep then
        Result := Copy(Path, 1, L - 1) else
        Result := Path;
    end;
end;



function StrMatch(const S, M: String; const Index: Integer): Boolean;
var N, T, I : Integer;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  for I := 1 to N do
    if M[I] <> S[I + Index - 1] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;


function StrMatchNoAsciiCase(const S, M: String; const Index: Integer = 1): Boolean;
var N, T : Integer;
    Q    : PChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchNoAsciiCase(Pointer(M), Q, N);
end;



function StrMatchLeft(const S, M: String; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrMatch(S, M, 1)
  else
    Result := StrMatchNoAsciiCase(S, M, 1);
end;

function StrMatchRight(const S, M: String; const AsciiCaseSensitive: Boolean): Boolean;
var I: Integer;
begin
  I := Length(S) - Length(M) + 1;
  if AsciiCaseSensitive then
    Result := StrMatch(S, M, I)
  else
    Result := StrMatchNoAsciiCase(S, M, I);
end;




procedure StrEnsureNoPrefix(var S: String; const Prefix: String;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchLeft(S, Prefix, AsciiCaseSensitive) then
    Delete(S, 1, Length(Prefix));
end;

procedure StrEnsureNoSuffix(var S: String; const Suffix: String;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchRight(S, Suffix, AsciiCaseSensitive) then
    SetLength(S, Length(S) - Length(Suffix));
end;


function PosChar(const F: Char; const S: String; const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if S[I] = F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;

function PosCharRev(const F: Char; const S: String; const Index: Integer): Integer;
var L, I, J : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  J := L;
  while J >= I do
    if S[J] = F then
      begin
        Result := J;
        exit;
      end
    else
      Dec(J);
  Result := 0;
end;




function StrReplaceChar(const Find, Replace: Char; const S: String): String; overload;
var I, J : Integer;
begin
  Result := S;
  I := PosChar(Find, S,1);
  if I = 0 then
    exit;
  for J := I to Length(S) do
    if S[J] = Find then
      Result[J] := Replace;
end;

function PosCharA(const F: AnsiChar; const S: AnsiString; const Index: Integer): Integer;
var P    : PAnsiChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    if P^ = F then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;

function CopyFromA(const S: AnsiString; const Index: Integer): AnsiString;
var L : Integer;
begin
  if Index <= 1 then
    Result := S
  else
    begin
      L := Length(S);
      if (L = 0) or (Index > L) then
        Result := ''
      else
        Result := Copy(S, Index, L - Index + 1);
    end;
end;


function CopyRangeA(const S: AnsiString; const StartIndex, StopIndex: Integer): AnsiString;
var L, I : Integer;
begin
  L := Length(S);
  if (StartIndex > StopIndex) or (StopIndex < 1) or (StartIndex > L) or (L = 0) then
    Result := ''
  else
    begin
      if StartIndex <= 1 then
        if StopIndex >= L then
          begin
            Result := S;
            exit;
          end
        else
          I := 1
      else
        I := StartIndex;
      Result := Copy(S, I, StopIndex - I + 1);
    end;
end;

function CopyFrom(const S: String; const Index: Integer): String;
var L : Integer;
begin
  if Index <= 1 then
    Result := S
  else
    begin
      L := Length(S);
      if (L = 0) or (Index > L) then
        Result := ''
      else
        Result := Copy(S, Index, L - Index + 1);
    end;
end;

function PosCharRevA(const F: AnsiChar; const S: AnsiString;
    const Index: Integer): Integer;
var P       : PAnsiChar;
    L, I, J : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  J := L;
  Inc(P, J - 1);
  while J >= I do
    if P^ = F then
      begin
        Result := J;
        exit;
      end else
      begin
        Dec(P);
        Dec(J);
      end;
  Result := 0;
end;


function CopyRange(const S: String; const StartIndex, StopIndex: Integer): String;
var L, I : Integer;
begin
  L := Length(S);
  if (StartIndex > StopIndex) or (StopIndex < 1) or (StartIndex > L) or (L = 0) then
    Result := ''
  else
    begin
      if StartIndex <= 1 then
        if StopIndex >= L then
          begin
            Result := S;
            exit;
          end
        else
          I := 1
      else
        I := StartIndex;
      Result := Copy(S, I, StopIndex - I + 1);
    end;
end;





function StrSplitChar(const S: String; const D: Char): StringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosChar(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosChar(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFrom(S, I);
        break;
      end;
    Result[L] := CopyRange(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;


function DynArrayRemove(var V: StringArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxI(Idx, 0);
  J := MinI(Count, L - I);
  for K := I to L - J - 1 do
    V[K] := V[K + J];
  SetLength(V, L - J);
  Result := J;
end;


function StringsTotalLength(const S: array of String): Integer;
var I : Integer;
begin
  Result := 0;
  for I := 0 to Length(S) - 1 do
    Inc(Result, Length(S[I]));
end;



function StrJoinChar(const S: array of String; const D: Char): String;
var I, L, C : Integer;
    P : PChar;
    T : String;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, StringsTotalLength(S) + L - 1);
  P := Pointer(Result);
  for I := 0 to L - 1 do
    begin
      if I > 0 then
        begin
          P^ := D;
          Inc(P);
        end;
      T := S[I];
      C := Length(T);
      if C > 0 then
        begin
          MoveMem(Pointer(T)^, P^, C * SizeOf(Char));
          Inc(P, C);
        end;
    end;
end;


(*function PathCanonicalA(const Path: AnsiString; const PathSep: AnsiChar): AnsiString;
var L, M : Integer;
    I, J : Integer;
    P    : AnsiStringArray;
    Q    : PAnsiChar;
begin
  Result := Path;
  // \.\ references
  M := Length(Result);
  repeat
    L := M;
    if L = 0 then
      exit;
    Result := StrReplaceA('\.\', '\', Result);
    Result := StrReplaceA('/./', '/', Result);
    M := Length(Result);
  until L = M;
  // .\ prefix
  StrEnsureNoPrefixA(Result, '.\');
  StrEnsureNoPrefixA(Result, './');
  // \. suffix
  StrEnsureNoSuffixA(Result, '\.');
  StrEnsureNoSuffixA(Result, '/.');
  // ..
  if PosStrA('..', Result) > 0 then
    begin
      P := StrSplitCharA(Result, PathSep);
      repeat
        J := -1;
        For I := Length(P) - 1 downto 0 do
          if P[I] = '..' then
            begin
              J := I;
              break;
            end;
        if J = -1 then
          break;
        M := -1;
        For I := J - 1 downto 0 do
          if (P[I] = '') or ((I = 0) and PathHasDriveLetterA(P[I])) then
            break else
          if P[I] <> '..' then
            begin
              M := I;
              break;
            end;
        if M = -1 then
          break;
        DynArrayRemoveA(P, J, 1);
        DynArrayRemoveA(P, M, 1);
      until False;
      Result := StrJoinCharA(P, PathSep);
    end;
  // \..\ prefix
  While StrMatchLeftA(Result, '\..\') do
    Delete(Result, 1, 3);
  While StrMatchLeftA(Result, '/../') do
    Delete(Result, 1, 3);
  if (Result = '\..') or (Result = '/..') then
    Result := '';
  L := Length(Result);
  if L = 0 then
    exit;
  // X:\..\ prefix
  Q := Pointer(Result);
  if Q^ in ['A'..'Z', 'a'..'z'] then
    begin
      if StrMatchA(Result, ':\..\', 2) then
        Delete(Result, 4, 3) else
      if (L = 5) and StrMatchA(Result, ':\..', 2) then
        begin
          SetLength(Result, 2);
          exit;
        end;
      L := Length(Result);
    end;
  // single dot
  Q := Pointer(Result);
  if L = 1 then
    begin
      if Q^ = '.' then
        Result := '';
      exit;
    end;
  // final dot
  Inc(Q, L - 2);
  if not (Q^ in ['.', '\', '/', ':']) then
    begin
      Inc(Q);
      if Q^ = '.' then
        Delete(Result, L, 1);
    end;
end; *)



function PathCanonical(const Path: String; const PathSep: Char): String;
var L, M : Integer;
    I, J : Integer;
    P    : StringArray;
    Q    : PChar;
    C    : Char;
begin
  Result := Path;
  // \.\ references
  M := Length(Result);
  repeat
    L := M;
    if L = 0 then
      exit;
    Result := StrReplace('\.\', '\', Result,true);
    Result := StrReplace('/./', '/', Result, true);
    M := Length(Result);
  until L = M;
  // .\ prefix
  StrEnsureNoPrefix(Result, '.\',true);
  StrEnsureNoPrefix(Result, './',true);
  // \. suffix
  StrEnsureNoSuffix(Result, '\.',true);
  StrEnsureNoSuffix(Result, '/.',true);
  // ..
  if PosStr('..', Result, 1, true) > 0 then
    begin
      P := StrSplitChar(Result, PathSep);
      repeat
        J := -1;
        For I := Length(P) - 1 downto 0 do
          if P[I] = '..' then
            begin
              J := I;
              break;
            end;
        if J = -1 then
          break;
        M := -1;
        For I := J - 1 downto 0 do
          if (P[I] = '') or ((I = 0) and PathHasDriveLetter(P[I])) then
            break else
          if P[I] <> '..' then
            begin
              M := I;
              break;
            end;
        if M = -1 then
          break;
        DynArrayRemove(P, J, 1);
        DynArrayRemove(P, M, 1);
      until False;
      Result := StrJoinChar(P, PathSep);
    end;
  // \..\ prefix
  While StrMatchLeft(Result, '\..\',true) do
    Delete(Result, 1, 3);
  While StrMatchLeft(Result, '/../',true) do
    Delete(Result, 1, 3);
  if (Result = '\..') or (Result = '/..') then
    Result := '';
  L := Length(Result);
  if L = 0 then
    exit;
  // X:\..\ prefix
  Q := Pointer(Result);
  C := Q^;
  if ((C >= 'A') and (C <= 'Z')) or
     ((C >= 'a') and (C <= 'z')) then
    begin
      if StrMatch(Result, ':\..\', 2) then
        Delete(Result, 4, 3) else
      if (L = 5) and StrMatch(Result, ':\..', 2) then
        begin
          SetLength(Result, 2);
          exit;
        end;
      L := Length(Result);
    end;
  // single dot
  Q := Pointer(Result);
  if L = 1 then
    begin
      if Q^ = '.' then
        Result := '';
      exit;
    end;
  // final dot
  Inc(Q, L - 2);
  C := Q^;
  if not ((C = '.') or (C = '\') or (C = '/') or (C = ':')) then
    begin
      Inc(Q);
      if Q^ = '.' then
        Delete(Result, L, 1);
    end;
end; 

(*function PathExpandA(const Path: AnsiString; const BasePath: AnsiString;
    const PathSep: AnsiChar): AnsiString;
begin
  if Path = '' then
    Result := BasePath else
  if PathIsAbsoluteA(Path) then
    Result := Path else
    Result := PathInclSuffixA(BasePath, PathSep) + Path;
  //Result := PathCanonicalA(Result, PathSep);
end;*)

function PathExpand(const Path: String; const BasePath: String;
    const PathSep: Char): String;
begin
  if Path = '' then
    Result := BasePath else
  if PathIsAbsolute(Path) then
    Result := Path else
    Result := PathInclSuffix(BasePath, PathSep) + Path;
    Result := PathCanonical(Result, PathSep);
end;

function PathLeftElementA(const Path: AnsiString; const PathSep: AnsiChar): AnsiString;
var I: Integer;
begin
  I := PosCharA(PathSep, Path,1);
  if I <= 0 then
    Result := Path else
    Result := Copy(Path, 1, I - 1);
end;

function PathLeftElement(const Path: String; const PathSep: Char): String;
var I: Integer;
begin
  I := PosChar(PathSep, Path,1);
  if I <= 0 then
    Result := Path else
    Result := Copy(Path, 1, I - 1);
end;

procedure PathSplitLeftElementA(const Path: AnsiString;
    var LeftElement, RightPath: AnsiString; const PathSep: AnsiChar);
var I: Integer;
begin
  I := PosCharA(PathSep, Path,1);
  if I <= 0 then
    begin
      LeftElement := Path;
      RightPath := '';
    end else
    begin
      LeftElement := Copy(Path, 1, I - 1);
      RightPath := CopyFromA(Path, I + 1);
    end;
end;

procedure PathSplitLeftElement(const Path: String;
    var LeftElement, RightPath: String; const PathSep: Char);
var I: Integer;
begin
  I := PosChar(PathSep, Path,1);
  if I <= 0 then
    begin
      LeftElement := Path;
      RightPath := '';
    end else
    begin
      LeftElement := Copy(Path, 1, I - 1);
      RightPath := CopyFrom(Path, I + 1);
    end;
end;



procedure DecodeFilePathA(const FilePath: AnsiString; var Path, FileName: AnsiString;
    const PathSep: AnsiChar);
var I: Integer;
begin
  I := PosCharRevA(PathSep, FilePath,1);
  if I <= 0 then
    begin
      Path := '';
      FileName := FilePath;
    end else
    begin
      Path := Copy(FilePath, 1, I);
      FileName := CopyFromA(FilePath, I + 1);
    end;
end;

procedure DecodeFilePath(const FilePath: String; var Path, FileName: String;
    const PathSep: Char);
var I: Integer;
begin
  I := PosCharRev(PathSep, FilePath,1);
  if I <= 0 then
    begin
      Path := '';
      FileName := FilePath;
    end else
    begin
      Path := Copy(FilePath, 1, I);
      FileName := CopyFrom(FilePath, I + 1);
    end;
end;

(*function StrReplaceCharA(const Find, Replace: AnsiChar; const S: AnsiString): AnsiString;
var P, Q : PAnsiChar;
    I, J : Integer;
begin
  Result := S;
  I := PosCharA(Find, S,1);
  if I = 0 then
    exit;
  UniqueString(Result);
  Q := Pointer(Result);
  Inc(Q, I - 1);
  P := Pointer(S);
  Inc(P, I - 1);
  for J := I to Length(S) do
    begin
      if P^ = Find then
        Q^ := Replace;
      Inc(P);
      Inc(Q);
    end;
end; *)

function PosCharSetA(const F: CharSet; const S: AnsiString; const Index: Integer): Integer;
var P    : PAnsiChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    if P^ in F then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;

function StrReplaceCharA(const Find, Replace: AnsiChar;
                const S: AnsiString): AnsiString; overload;
var P, Q : PAnsiChar;
    I, J : Integer;
begin
  Result := S;
  I := PosCharA(Find, S,1);
  if I = 0 then
    exit;
  UniqueString(Result);
  Q := Pointer(Result);
  Inc(Q, I - 1);
  P := Pointer(S);
  Inc(P, I - 1);
  for J := I to Length(S) do
    begin
      if P^ = Find then
        Q^ := Replace;
      Inc(P);
      Inc(Q);
    end;
end;



function StrReplaceCharA(const Find: CharSet; const Replace: AnsiChar;
    const S: AnsiString): AnsiString;  overload;
var P, Q : PAnsiChar;
    I, J : Integer;
begin
  Result := S;
  I := PosCharSetA(Find, S,1);
  if I = 0 then
    exit;
  UniqueString(Result);
  Q := Pointer(Result);
  Inc(Q, I - 1);
  P := Pointer(S);
  Inc(P, I - 1);
  for J := I to Length(S) do
    begin
      if P^ in Find then
        Q^ := Replace;
      Inc(P);
      Inc(Q);
    end;
end;

function StrReplaceChar(const Find: CharSet; const Replace: Char;
                           const S: String): String; overload;
var P, Q : PChar;
    I, J : Integer;
    C    : Char;
begin
  Result := S;
  I := PosCharSet(Find, S,1);
  if I = 0 then
    exit;
  UniqueString(Result);
  Q := Pointer(Result);
  Inc(Q, I - 1);
  P := Pointer(S);
  Inc(P, I - 1);
  for J := I to Length(S) do
    begin
      C := P^;
      {$IFDEF StringIsUnicode}
      if Ord(C) <= $FF then
      {$ENDIF}
        if AnsiChar(Ord(C)) in Find then
          Q^ := Replace;
      Inc(P);
      Inc(Q);
    end;
end;




function FileNameValidA(const FileName: AnsiString): AnsiString;
begin
  Result := StrReplaceCharA(['\', '/', ':', '>', '<', '*', '?'], '_', FileName);
  if Result = '.' then
    Result := '' else
  if Result = '..' then
    Result := '_';
end;

function FileNameValid(const FileName: String): String;
begin
  Result := StrReplaceChar(['\', '/', ':', '>', '<', '*', '?'], '_', FileName);
  if Result = '.' then
    Result := '' else
  if Result = '..' then
    Result := '_';
end;

function FilePathA(const FileName, Path: AnsiString; const BasePath: AnsiString;
    const PathSep: AnsiChar): AnsiString;
var P, F: AnsiString;
begin
  F := FileNameValidA(FileName);
  if F = '' then
    begin
      Result := '';
      exit;
    end;
  //P := PathExpandA(Path, BasePath, PathSep);
  if P = '' then
    Result := F
  else
    Result := PathInclSuffixA(P, PathSep) + F;
end;

function FilePath(const FileName, Path: String; const BasePath: String;
    const PathSep: Char): String;
var P, F: String;
begin
  F := FileNameValid(FileName);
  if F = '' then
    begin
      Result := '';
      exit;
    end;
  P := PathExpand(Path, BasePath, PathSep);
  if P = '' then
    Result := F
  else
    Result := PathInclSuffix(P, PathSep) + F;
end;

function DirectoryExpandA(const Path: AnsiString; const BasePath: AnsiString;
    const PathSep: AnsiChar): AnsiString;
begin
  //Result := PathExpandA(PathInclSuffixA(Path, PathSep),
      //PathInclSuffixA(BasePath, PathSep), PathSep);
end;

function DirectoryExpand(const Path: String; const BasePath: String;
    const PathSep: Char): String;
begin
  Result := PathExpand(PathInclSuffix(Path, PathSep),
      PathInclSuffix(BasePath, PathSep), PathSep);
end;

function UnixPathToWinPath(const Path: AnsiString): AnsiString;
begin
  Result := StrReplaceCharA('/', '\',
            StrReplaceCharA(['\', ':', '<', '>', '|'], '_', Path));
end;


function StrPMatchA(const A, B: PAnsiChar; const Len: Integer): Boolean;
var P, Q : PAnsiChar;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      if P^ = Q^ then
        begin
          Inc(P);
          Inc(Q);
        end else
        begin
          Result := False;
          exit;
        end;
  Result := True;
end;



function StrMatchA(const S, M: AnsiString; const Index: Integer): Boolean;
var N, T : Integer;
    Q    : PAnsiChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchA(Pointer(M), Q, N);
end;



function StrPMatchNoAsciiCaseA(const A, B: PAnsiChar; const Len: Integer): Boolean;
var P, Q : PAnsiChar;
    C, D : Integer;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      begin
        C := Integer(AsciiLowCaseLookup[P^]);
        D := Integer(AsciiLowCaseLookup[Q^]);
        if C = D then
          begin
            Inc(P);
            Inc(Q);
          end else
          begin
            Result := False;
            exit;
          end;
      end;
  Result := True;
end;


function StrMatchNoAsciiCaseA(const S, M: AnsiString; const Index: Integer): Boolean;
var N, T : Integer;
    Q    : PAnsiChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchNoAsciiCaseA(Pointer(M), Q, N);
end;




function StrMatchLeftA(const S, M: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrMatchA(S, M, 1)
  else
    Result := StrMatchNoAsciiCaseA(S, M, 1);
end;


function WinPathToUnixPath(const Path: AnsiString): AnsiString;
begin
  Result := Path;
  if PathHasDriveLetterA(Path) then
    begin
      // X: -> \X
      Result[2] := Result[1];
      Result[1] := '\';
    end else
  if StrMatchLeftA(Path, '\\.\',true) then
    // \\.\ -> \
    Delete(Result, 1, 3) else
  if PathIsUNCPathA(Path) then
    // \\ -> \
    Delete(Result, 1, 1);
  Result := StrReplaceCharA('\', '/',
            StrReplaceCharA(['/', ':', '<', '>', '|'], '_', Result));
end;



{                                                                              }
{ System helper functions                                                      }
{                                                                              }
resourcestring
  SSystemError = 'System error #%s';

{$IFDEF MSWIN}
{$IFDEF StringIsUnicode}
function GetLastOSErrorMessage: String;
const MAX_ERRORMESSAGE_LENGTH = 256;
var Err: LongWord;
    Buf: array[0..MAX_ERRORMESSAGE_LENGTH - 1] of Word;
    Len: LongWord;
begin
  Err := Windows.GetLastError;
  FillChar(Buf, Sizeof(Buf), #0);
  Len := Windows.FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM, nil, Err, 0,
      @Buf, MAX_ERRORMESSAGE_LENGTH, nil);
  if Len = 0 then
    Result := Format(SSystemError, [IntToStr(Err)])
  else
    Result := StrPas(PWideChar(@Buf));
end;
{$ELSE}
function GetLastOSErrorMessage: String;
const MAX_ERRORMESSAGE_LENGTH = 256;
var Err: LongWord;
    Buf: array[0..MAX_ERRORMESSAGE_LENGTH - 1] of Byte;
    Len: LongWord;
begin
  Err := Windows.GetLastError;
  FillChar(Buf, Sizeof(Buf), #0);
  Len := Windows.FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM, nil, Err, 0,
      @Buf, MAX_ERRORMESSAGE_LENGTH, nil);
  if Len = 0 then
    Result := Format(SSystemError, [IntToStr(Err)])
  else
    Result := StrPas(PAnsiChar(@Buf));
end;
{$ENDIF}
{$ELSE}
{$IFDEF UNIX}
{$IFDEF FREEPASCAL}
function GetLastOSErrorMessage: String;
begin
  Result := SysErrorMessage(GetLastOSError);
end;
{$ELSE}
function GetLastOSErrorMessage: String;
var Err: LongWord;
    Buf: Array[0..1023] of AnsiChar;
begin
  Err := BaseUnix.fpgeterrno;
  FillChar(Buf, Sizeof(Buf), #0);
  libc.strerror_r(Err, @Buf, SizeOf(Buf));
  if Buf[0] = #0 then
    Result := Format(SSystemError, [IntToStr(Err)])
  else
    Result := StrPas(@Buf);
end;
{$ENDIF}{$ENDIF}{$ENDIF}

{$IFDEF WindowsPlatform}
function GetTick: LongWord;
begin
  Result := GetTickCount;
end;
{$ELSE}{$IFDEF UNIX}
function GetTick: LongWord;
begin
  Result := LongWord(DateTimeToTimeStamp(Now).Time);
end;
{$ENDIF}{$ENDIF}



{                                                                              }
{ File errors                                                                  }
{                                                                              }
constructor EFileError.Create(const FileError: TFileError; const Msg: string);
begin
  FFileError := FileError;
  inherited Create(Msg);
end;

constructor EFileError.CreateFmt(const FileError: TFileError; const Msg: string; const Args: array of const);
begin
  FFileError := FileError;
  inherited CreateFmt(Msg, Args);
end;

{$IFDEF MSWIN}
function WinErrorCodeToFileError(const ErrorCode: LongWord): TFileError;
begin
  case ErrorCode of
    0                             : Result := feNone;
    ERROR_INVALID_HANDLE          : Result := feInvalidParameter;
    ERROR_FILE_NOT_FOUND,
    ERROR_PATH_NOT_FOUND          : Result := feFileDoesNotExist;
    ERROR_ALREADY_EXISTS,
    ERROR_FILE_EXISTS             : Result := feFileExists;
    ERROR_WRITE_PROTECT,
    ERROR_OPEN_FAILED             : Result := feFileOpenError;
    ERROR_CANNOT_MAKE             : Result := feFileCreateError;
    ERROR_NEGATIVE_SEEK           : Result := feFileSeekError;
    ERROR_ACCESS_DENIED,
    ERROR_NETWORK_ACCESS_DENIED   : Result := feAccessDenied;
    ERROR_SHARING_VIOLATION,
    ERROR_LOCK_VIOLATION,
    ERROR_SHARING_PAUSED,
    ERROR_LOCK_FAILED             : Result := feFileSharingError;
    ERROR_HANDLE_DISK_FULL,
    ERROR_DISK_FULL               : Result := feOutOfSpace;
    ERROR_BAD_NETPATH,
    ERROR_DIRECTORY,
    ERROR_INVALID_DRIVE           : Result := feInvalidFilePath;
    ERROR_INVALID_NAME,
    ERROR_FILENAME_EXCED_RANGE,
    ERROR_BAD_NET_NAME,
    ERROR_BUFFER_OVERFLOW         : Result := feInvalidFileName;
    ERROR_OUTOFMEMORY,
    ERROR_NOT_ENOUGH_MEMORY,
    ERROR_TOO_MANY_OPEN_FILES,
    ERROR_SHARING_BUFFER_EXCEEDED : Result := feOutOfResources;
    ERROR_SEEK,
    ERROR_READ_FAULT,
    ERROR_WRITE_FAULT,
    ERROR_GEN_FAILURE,
    ERROR_CRC,
    ERROR_NETWORK_BUSY,
    ERROR_NET_WRITE_FAULT,
    ERROR_REM_NOT_LIST,
    ERROR_DEV_NOT_EXIST,
    ERROR_NETNAME_DELETED         : Result := feDeviceFailure;
  else
    Result := feFileError;
  end;
end;
{$ENDIF}



{                                                                              }
{ File operations                                                              }
{                                                                              }

{$IFDEF MSWIN}
function FileOpenFlagsToWinFileFlags(const FileOpenFlags: TFileOpenFlags): LongWord;
var
  FileFlags : LongWord;
begin
  FileFlags := 0;
  if foDeleteOnClose in FileOpenFlags then
    FileFlags := FileFlags or FILE_FLAG_DELETE_ON_CLOSE;
  if foNoBuffering in FileOpenFlags then
    FileFlags := FileFlags or FILE_FLAG_NO_BUFFERING;
  if foWriteThrough in FileOpenFlags then
    FileFlags := FileFlags or FILE_FLAG_WRITE_THROUGH;
  if foRandomAccessHint in FileOpenFlags then
    FileFlags := FileFlags or FILE_FLAG_RANDOM_ACCESS;
  if foSequentialScanHint in FileOpenFlags then
    FileFlags := FileFlags or FILE_FLAG_SEQUENTIAL_SCAN;
  Result := FileFlags;
end;

function FileCreationModeToWinFileCreateDisp(const FileCreationMode: TFileCreationMode): LongWord;
var
  FileCreateDisp : LongWord;
begin
  case FileCreationMode of
    fcCreateNew        : FileCreateDisp := CREATE_NEW;
    fcCreateAlways     : FileCreateDisp := CREATE_ALWAYS;
    fcOpenExisting     : FileCreateDisp := OPEN_EXISTING;
    fcOpenAlways       : FileCreateDisp := OPEN_ALWAYS;
    fcTruncateExisting : FileCreateDisp := TRUNCATE_EXISTING;
  else
    raise EFileError.Create(feInvalidParameter, SInvalidFileCreationMode);
  end;
  Result := FileCreateDisp;
end;

function FileSharingToWinFileShareMode(const FileSharing: TFileSharing): LongWord;
var
  FileShareMode : LongWord;
begin
  case FileSharing of
    fsDenyNone      : FileShareMode := FILE_SHARE_READ or FILE_SHARE_WRITE or FILE_SHARE_DELETE;
    fsDenyRead      : FileShareMode := FILE_SHARE_WRITE;
    fsDenyWrite     : FileShareMode := FILE_SHARE_READ;
    fsDenyReadWrite : FileShareMode := 0;
    fsExclusive     : FileShareMode := 0;
  else
    raise EFileError.Create(feInvalidParameter, SInvalidFileSharing);
  end;
  Result := FileShareMode;
end;

function FileAccessToWinFileOpenAccess(const FileAccess: TFileAccess): LongWord;
var
  FileOpenAccess : LongWord;
begin
  case FileAccess of
    faRead      : FileOpenAccess := GENERIC_READ;
    faWrite     : FileOpenAccess := GENERIC_WRITE;
    faReadWrite : FileOpenAccess := GENERIC_READ or GENERIC_WRITE;
  else
    raise EFileError.Create(feInvalidParameter, SInvalidFileAccess);
  end;
  Result := FileOpenAccess;
end;
{$ELSE}
function FileOpenShareMode(
         const FileAccess: TFileAccess;
         const FileSharing: TFileSharing): LongWord;
var FileShareMode : LongWord;
begin
  case FileAccess of
    faRead      : FileShareMode := fmOpenRead;
    faWrite     : FileShareMode := fmOpenWrite;
    faReadWrite : FileShareMode := fmOpenReadWrite;
  else
    raise EFileError.Create(feInvalidParameter, SInvalidFileAccess);
  end;
  case FileSharing of
    fsDenyNone      : FileShareMode := FileShareMode or fmShareDenyNone;
    fsDenyRead      : FileShareMode := FileShareMode or fmShareDenyRead;
    fsDenyWrite     : FileShareMode := FileShareMode or fmShareDenyWrite;
    fsDenyReadWrite : FileShareMode := FileShareMode or fmShareDenyRead or fmShareDenyWrite;
    fsExclusive     : FileShareMode := FileShareMode or fmShareExclusive;
  else
    raise EFileError.Create(feInvalidParameter, SInvalidFileSharing);
  end;
  Result := FileShareMode;
end;

function FileCreateWithShareMode(
         const FileName: AnsiString;
         const FileShareMode: LongWord): Integer;
var FileHandle : Integer;
begin
  FileHandle := FileCreate(FileName);
  if FileHandle < 0 then
    exit;
  FileClose(FileHandle);
  FileHandle := FileOpen(FileName, FileShareMode);
  Result := FileHandle;
end;
{$ENDIF}

{$IFDEF MSWIN}
procedure DoFileOpenWait(const FileOpenWait: PFileOpenWait; const WaitStart: LongWord; var Retry: Boolean);

  function RandomRetryWait: Integer;
  var Seed : Integer;
  begin
    if not FileOpenWait^.RetryRandomise then
      Result := 0
    else
    if FileOpenWait^.RetryInterval < 0 then
      Result := 0
    else
      Result := FileOpenWait^.RetryInterval div 8;
    if Result = 0 then
      exit;
    Seed := Integer(GetTick);
    Inc(Seed, Integer(FileOpenWait));
    Result := Seed mod Result;
  end;

var
  WaitTime : LongWord;
  WaitResult : LongInt;
begin
  Assert(Assigned(FileOpenWait));

  Retry := False;
  if FileOpenWait^.Signal <> 0 then
    begin
      if FileOpenWait^.RetryInterval < 0 then
        WaitTime := INFINITE
      else
        WaitTime := FileOpenWait^.RetryInterval + RandomRetryWait;
      WaitResult := WaitForSingleObject(FileOpenWait^.Signal, WaitTime);
      if WaitResult = WAIT_TIMEOUT then
        Retry := True;
    end
  else
  if Assigned(FileOpenWait^.Callback) then
    begin
      FileOpenWait^.Aborted := False;
      FileOpenWait^.Callback(FileOpenWait);
      if not FileOpenWait^.Aborted then
        Retry := True;
    end
  else
    begin
      Sleep(FileOpenWait^.RetryInterval + RandomRetryWait);
      Retry := True;
    end;
  if Retry then
    if LongInt(Int64(GetTick) - Int64(WaitStart)) >= FileOpenWait^.Timeout then
      Retry := False;
end;
{$ENDIF}

function FileOpenExA(
         const FileName: AnsiString;
         const FileAccess: TFileAccess;
         const FileSharing: TFileSharing;
         const FileOpenFlags: TFileOpenFlags;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): TFileHandle;

var FileHandle     : Integer;
    FileShareMode  : LongWord;
    {$IFDEF MSWIN}
    FileOpenAccess : LongWord;
    FileFlags      : LongWord;
    FileCreateDisp : LongWord;
    ErrorCode      : LongWord;
    ErrorSharing   : Boolean;
    Retry          : Boolean;
    WaitStart      : LongWord;
    WaitOpen       : Boolean;
    {$ENDIF}

begin
  {$IFDEF MSWIN}
  FileFlags := FileOpenFlagsToWinFileFlags(FileOpenFlags);
  FileCreateDisp := FileCreationModeToWinFileCreateDisp(FileCreationMode);
  FileShareMode := FileSharingToWinFileShareMode(FileSharing);
  FileOpenAccess := FileAccessToWinFileOpenAccess(FileAccess);
  WaitOpen := False;
  WaitStart := 0;
  if Assigned(FileOpenWait) then
    if FileOpenWait^.Wait and (FileOpenWait^.Timeout > 0) then
      begin
        WaitOpen := True;
        WaitStart := GetTick;
      end;
  Retry := False;
  repeat
    FileHandle := Integer(Windows.CreateFileA(
        PAnsiChar(FileName),
        FileOpenAccess,
        FileShareMode,
        nil,
        FileCreateDisp,
        FileFlags,
        0));
    if FileHandle < 0 then
      begin
        ErrorCode := GetLastError;
        ErrorSharing :=
            (ErrorCode = ERROR_SHARING_VIOLATION) or
            (ErrorCode = ERROR_LOCK_VIOLATION);
      end
    else
      begin
        ErrorCode := 0;
        ErrorSharing := False;
      end;
    if WaitOpen and ErrorSharing then
      DoFileOpenWait(FileOpenWait, WaitStart, Retry);
  until not Retry;
  if FileHandle < 0 then
    raise EFileError.CreateFmt(WinErrorCodeToFileError(ErrorCode), SCannotOpenFile,
        [GetLastOSErrorMessage, FileName]);
  {$ELSE}
  FileShareMode := FileOpenShareMode(FileAccess, FileSharing);
  case FileCreationMode of
    fcCreateNew :
      if FileExists(FileName) then
        raise EFileError.CreateFmt(feFileExists, SFileExists, [FileName])
      else
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode);
    fcCreateAlways :
      FileHandle := FileCreateWithShareMode(FileName, FileShareMode);
    fcOpenExisting :
      FileHandle := FileOpen(FileName, FileShareMode);
    fcOpenAlways :
      if not FileExists(FileName) then
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode)
      else
        FileHandle := FileOpen(FileName, FileShareMode);
    fcTruncateExisting :
      if not FileExists(FileName) then
        raise EFileError.CreateFmt(feFileDoesNotExist, SFileDoesNotExist, [FileName])
      else
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode)
  else
    raise EFileError.CreateFmt(feInvalidParameter, SInvalidFileCreationMode, []);
  end;
  if FileHandle < 0 then
    raise EFileError.CreateFmt(feFileOpenError, SCannotOpenFile, [GetLastOSErrorMessage, FileName]);
  {$ENDIF}
  if foSeekToEndOfFile in FileOpenFlags then
    FileSeekEx(FileHandle, 0, fpOffsetFromEnd);
  Result := FileHandle;
end;

function FileSeekEx(
         const FileHandle: TFileHandle;
         const FileOffset: Int64;
         const FilePosition: TFileSeekPosition): Int64;
begin
  if FileHandle = 0 then
    raise EFileError.CreateFmt(feInvalidParameter, SInvalidFileHandle, []);
  case FilePosition of
    fpOffsetFromStart   : Result := FileSeek(FileHandle, FileOffset, 0);
    fpOffsetFromCurrent : Result := FileSeek(FileHandle, FileOffset, 1);
    fpOffsetFromEnd     : Result := FileSeek(FileHandle, FileOffset, 2);
  else
    raise EFileError.CreateFmt(feInvalidParameter, SInvalidFilePosition, []);
  end;
  if Result < 0 then
    raise EFileError.CreateFmt(feFileSeekError, SFileSeekError, [GetLastOSErrorMessage]);
end;

function FileReadEx(
         const FileHandle: TFileHandle;
         var Buf; const BufSize: Integer): Integer;
begin
  {$IFDEF MSWIN}
  if not ReadFile(FileHandle, Buf, BufSize, LongWord(Result), nil) then
    raise EFileError.CreateFmt(feFileReadError, SFileReadError, [GetLastOSErrorMessage]);
  {$ELSE}
  Result := FileRead(FileHandle, Buf, BufSize);
  if Result < 0 then
    raise EFileError.Create(feFileReadError, SFileReadError);
  {$ENDIF}
end;

function FileWriteEx(
         const FileHandle: TFileHandle;
         const Buf; const BufSize: Integer): Integer;
begin
  {$IFDEF MSWIN}
  if not WriteFile(FileHandle, Buf, BufSize, LongWord(Result), nil) then
    raise EFileError.CreateFmt(feFileWriteError, SFileWriteError, [GetLastOSErrorMessage]);
  {$ELSE}
  Result := FileWrite(FileHandle, Buf, BufSize);
  if Result < 0 then
    raise EFileError.Create(feFileWriteError, SFileWriteError);
  {$ENDIF}
end;

procedure FileCloseEx(const FileHandle: TFileHandle);
begin
  FileClose(FileHandle);
end;

function FileExistsA(const FileName: AnsiString): Boolean;
{$IFDEF MSWIN}
var Attr : LongWord;
{$ELSE}
var SRec : TSearchRec;
{$ENDIF}
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  {$IFDEF MSWIN}
  Attr := GetFileAttributesA(PAnsiChar(FileName));
  if Attr = $FFFFFFFF then
    Result := False
  else
    Result := Attr and FILE_ATTRIBUTE_DIRECTORY = 0;
  {$ELSE}
  if FindFirst(FileName, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := SRec.Attr and faDirectory = 0;
      FindClose(SRec);
    end;
  {$ENDIF}
end;

function FileExists(const FileName: String): Boolean;
{$IFDEF MSWIN}
var Attr : LongWord;
{$ELSE}
var SRec : TSearchRec;
{$ENDIF}
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  {$IFDEF MSWIN}
  {$IFDEF StringIsUnicode}
  Attr := GetFileAttributesW(PWideChar(FileName));
  {$ELSE}
  Attr := GetFileAttributesA(PAnsiChar(FileName));
  {$ENDIF}
  if Attr = $FFFFFFFF then
    Result := False
  else
    Result := Attr and FILE_ATTRIBUTE_DIRECTORY = 0;
  {$ELSE}
  if FindFirst(FileName, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := SRec.Attr and faDirectory = 0;
      FindClose(SRec);
    end;
  {$ENDIF}
end;

function FileGetSize(const FileName: String): Int64;
var SRec : TSearchRec;
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  if FindFirst(FileName, faAnyFile, SRec) <> 0 then
    Result := -1
  else
  begin
    if SRec.Attr and faDirectory <> 0 then
      Result := -1
    else
      begin
        {$IFDEF MSWIN}
        Int64Rec(Result).Lo := SRec.FindData.nFileSizeLow;
        Int64Rec(Result).Hi := SRec.FindData.nFileSizeHigh;
        {$ELSE}
        Result := SRec.Size;
        {$ENDIF}
      end;
    FindClose(SRec);
  end;
end;

function FileGetDateTime(const FileName: String): TDateTime;
var SRec : TSearchRec;
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  if FindFirst(FileName, faAnyFile, SRec) <> 0 then
    Result := 0.0
  else
    begin
      if SRec.Attr and faDirectory <> 0 then
        Result := 0.0
      else
        Result := FileDateToDateTime(SRec.Time);
      FindClose(SRec);
    end;
end;

function FileGetDateTime2(const FileName: String): TDateTime;
var Age : LongInt;
begin
  Age := FileAge(FileName);
  if Age = -1 then
    Result := 0.0
  else
    Result := FileDateToDateTime(Age);
end;

function FileIsReadOnly(const FileName: String): Boolean;
var SRec : TSearchRec;
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  if FindFirst(FileName, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := SRec.Attr and (faReadOnly or faDirectory) = faReadOnly;
      FindClose(SRec);
    end;
end;

procedure FileDeleteEx(const FileName: String);
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  if not DeleteFile(FileName) then
    raise EFileError.CreateFmt(feFileDeleteError, SFileDeleteError, [GetLastOSErrorMessage]);
end;

procedure FileRenameEx(const OldFileName, NewFileName: String);
begin
  RenameFile(OldFileName, NewFileName);
end;

function ReadFileBufA(
         const FileName: AnsiString;
         var Buf; const BufSize: Integer;
         const FileSharing: TFileSharing;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): Integer;
var FileHandle : Integer;
    FileSize   : Int64;
begin
  Result := 0;
  FileHandle := FileOpenExA(FileName, faRead, FileSharing,
      [foSequentialScanHint], FileCreationMode, FileOpenWait);
  try
    FileSize := FileGetSize(ToStringA(FileName));
    if FileSize = 0 then
      exit;
    if FileSize < 0 then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > MaxInteger then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > BufSize then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    Result := FileReadEx(FileHandle, Buf, FileSize);
  finally
    FileClose(FileHandle);
  end;
end;

function ReadFileStrA(
         const FileName: AnsiString;
         const FileSharing: TFileSharing;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): AnsiString;
var FileHandle : Integer;
    FileSize   : Int64;
    ReadBytes  : Integer;
begin
  FileHandle := FileOpenExA(FileName, faRead, FileSharing,
      [foSequentialScanHint], FileCreationMode, FileOpenWait);
  try
    FileSize := FileGetSize(ToStringA(FileName));
    if FileSize < 0 then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > MaxInteger then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    SetLength(Result, FileSize);
    if FileSize = 0 then
      exit;
    ReadBytes := FileReadEx(FileHandle, Result[1], FileSize);
    if ReadBytes < FileSize then
      SetLength(Result, ReadBytes);
  finally
    FileClose(FileHandle);
  end;
end;

procedure AppendFileA(
          const FileName: AnsiString;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var FileHandle : Integer;
begin
  if BufSize <= 0 then
    exit;
  FileHandle := FileOpenExA(FileName, faWrite, FileSharing, [foSeekToEndOfFile],
      FileCreationMode, FileOpenWait);
  try
    if FileWriteEx(FileHandle, Buf, BufSize) <> BufSize then
      raise EFileError.CreateFmt(feFileWriteError, SFileWriteError, [GetLastOSErrorMessage, FileName]);
  finally
    FileClose(FileHandle);
  end;
end;

procedure AppendFileStrA(
          const FileName: AnsiString;
          const Buf: AnsiString;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var BufSize    : Integer;
begin
  BufSize := Length(Buf);
  if BufSize <= 0 then
    exit;
  AppendFileA(FileName, Buf[1], BufSize, FileSharing, FileCreationMode, FileOpenWait);
end;

function DirectoryEntryExists(const Name: String): Boolean;
var SRec : TSearchRec;
begin
  if FindFirst(Name, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := True;
      FindClose(SRec);
    end;
end;

function DirectoryEntrySize(const Name: String): Int64;
var SRec : TSearchRec;
begin
  if FindFirst(Name, faAnyFile, SRec) <> 0 then
    Result := -1
  else
    begin
      if SRec.Attr and faDirectory <> 0 then
        Result := 0
      else
        begin
          {$IFDEF MSWIN}
          {$WARNINGS OFF}
          Int64Rec(Result).Lo := SRec.FindData.nFileSizeLow;
          Int64Rec(Result).Hi := SRec.FindData.nFileSizeHigh;
          {$IFDEF DEBUG}{$IFNDEF FREEPASCAL}{$WARNINGS ON}{$ENDIF}{$ENDIF}
          {$ELSE}
          Result := SRec.Size;
          {$ENDIF}
        end;
      FindClose(SRec);
    end;
end;

function DirectoryExists(const DirectoryName: String): Boolean;
{$IFDEF MSWIN}
var Attr : LongWord;
{$ELSE}
var SRec : TSearchRec;
{$ENDIF}
begin
  if DirectoryName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidPath);
  {$IFDEF MSWIN}
  {$IFDEF StringIsUnicode}
  Attr := GetFileAttributesW(PWideChar(DirectoryName));
  {$ELSE}
  Attr := GetFileAttributesA(PAnsiChar(DirectoryName));
  {$ENDIF}
  if Attr = $FFFFFFFF then
    Result := False
  else
    Result := Attr and FILE_ATTRIBUTE_DIRECTORY <> 0;
  {$ELSE}
  if FindFirst(DirectoryName, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := SRec.Attr and faDirectory <> 0;
      FindClose(SRec);
    end;
  {$ENDIF}
end;

function DirectoryGetDateTime(const DirectoryName: String): TDateTime;
var SRec : TSearchRec;
begin
  if DirectoryName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidPath);
  if FindFirst(DirectoryName, faAnyFile, SRec) <> 0 then
    Result := 0.0
  else
    begin
      if SRec.Attr and faDirectory = 0 then
        Result := 0.0
      else
        Result := FileDateToDateTime(SRec.Time);
      FindClose(SRec);
    end;
end;

procedure DirectoryCreate(const DirectoryName: String);
begin
  if DirectoryName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidPath);
  if not CreateDir(DirectoryName) then
    raise EFileError.Create(feFileError, SCannotCreateFile);
end;



{                                                                              }
{ File operations                                                              }
{                                                                              }
function GetFirstFileNameMatching(const FileMask: String): String;
var SRec : TSearchRec;
begin
  Result := '';
  if FindFirst(FileMask, faAnyFile, SRec) = 0 then
    try
      repeat
        if SRec.Attr and faDirectory = 0 then
          begin
            Result := ExtractFilePath(FileMask) + SRec.Name;
            exit;
          end;
      until FindNext(SRec) <> 0;
    finally
      FindClose(SRec);
    end;
end;

function DirEntryGetAttr(const FileName: AnsiString): Integer;
var SRec : TSearchRec;
begin
  if (FileName = '') or PathIsDriveLetterA(FileName) then
    Result := -1 else
  if PathIsRootA(FileName) then
    Result := $0800 or faDirectory else
  if FindFirst(ToStringA(PathExclSuffixA(FileName)), faAnyFile, SRec) = 0 then
    begin
      Result := SRec.Attr;
      FindClose(SRec);
    end
  else
    Result := -1;
end;

function DirEntryIsDirectory(const FileName: AnsiString): Boolean;
var SRec : TSearchRec;
begin
  if (FileName = '') or PathIsDriveLetterA(FileName) then
    Result := False else
  if PathIsRootA(FileName) then
    Result := True else
  if FindFirst(ToStringA(PathExclSuffixA(FileName)), faDirectory, SRec) = 0 then
    begin
      Result := SRec.Attr and faDirectory <> 0;
      FindClose(SRec);
    end
  else
    Result := False;
end;

{$IFDEF DELPHI6_UP}{$WARN SYMBOL_PLATFORM OFF}{$ENDIF}
function FileHasAttr(const FileName: String; const Attr: Word): Boolean;
var A : Integer;
begin
  A := FileGetAttr(FileName);
  Result := (A >= 0) and (A and Attr <> 0);
end;

procedure CopyFile(const FileName, DestName: String);
const
  BufferSize = 16384;
var DestFileName : String;
    SourceHandle : Integer;
    DestHandle   : Integer;
    Buffer       : Array[0..BufferSize - 1] of Byte;
    BufferUsed   : Integer;
begin
  DestFileName := ExpandFileName(DestName);
  if FileHasAttr(DestFileName, faDirectory) then // if destination is a directory, append file name
    DestFileName := DestFileName + '\' + ExtractFileName(FileName);
  SourceHandle := FileOpen(FileName, fmShareDenyWrite);
  if SourceHandle < 0 then
    raise EFileError.CreateFmt(feFileOpenError, SCannotOpenFile, [GetLastOSErrorMessage,
        FileName]);
  try
    DestHandle := FileCreate(DestFileName);
    if DestHandle < 0 then
      raise EFileError.CreateFmt(feFileCreateError, SCannotCreateFile, [GetLastOSErrorMessage,
          DestFileName]);
    try
      repeat
        BufferUsed := FileRead(SourceHandle, Buffer[0], BufferSize);
        if BufferUsed > 0 then
          FileWrite(DestHandle, Buffer[0], BufferUsed);
      until BufferUsed < BufferSize;
    finally
      FileClose(DestHandle);
    end;
  finally
    FileClose(SourceHandle);
  end;
end;

procedure MoveFile(const FileName, DestName: String);
var Destination : String;
    Attr        : Integer;
begin
  Destination := ExpandFileName(DestName);
  if not RenameFile(FileName, Destination) then
    begin
      Attr := FileGetAttr(FileName);
      if (Attr < 0) or (Attr and faReadOnly <> 0) then
        raise EFileError.CreateFmt(feFileMoveError, SCannotMoveFile, [GetLastOSErrorMessage,
            FileName]);
      CopyFile(FileName, Destination);
      DeleteFile(FileName);
    end;
end;

function DeleteFiles(const FileMask: String): Boolean;
var SRec : TSearchRec;
    Path : String;
begin
  Result := FindFirst(FileMask, faAnyFile, SRec) = 0;
  if not Result then
    exit;
  try
    Path := ExtractFilePath(FileMask);
    repeat
      if (SRec.Name <> '') and (SRec.Name  <> '.') and (SRec.Name <> '..') and
         (SRec.Attr and (faVolumeID + faDirectory) = 0) then
        begin
          Result := DeleteFile(Path + SRec.Name);
          if not Result then
            break;
        end;
    until FindNext(SRec) <> 0;
  finally
    FindClose(SRec);
  end;
end;
{$IFDEF DELPHI6_UP}{$WARN SYMBOL_PLATFORM ON}{$ENDIF}



{$IFDEF MSWIN}
{                                                                              }
{ Logical Drive functions                                                      }
{                                                                              }
function DriveIsValid(const Drive: AnsiChar): Boolean;
var D : AnsiChar;
begin
  D := UpCase(Drive);
  Result := D in ['A'..'Z'];
  if not Result then
    exit;
  Result := IsBitSet(GetLogicalDrives, Ord(D) - Ord('A'));
end;

function DriveGetType(const Path: AnsiString): TLogicalDriveType;
begin
  Case GetDriveTypeA(PAnsiChar(Path)) of
    DRIVE_REMOVABLE : Result := DriveRemovable;
    DRIVE_FIXED     : Result := DriveFixed;
    DRIVE_REMOTE    : Result := DriveRemote;
    DRIVE_CDROM     : Result := DriveCDRom;
    DRIVE_RAMDISK   : Result := DriveRamDisk;
  else
    Result := DriveTypeUnknown;
  end;
end;

function DriveFreeSpace(const Path: AnsiString): Int64;
var D: Byte;
begin
  if PathHasDriveLetterA(Path) then
    D := Ord(UpCase(PAnsiChar(Path)^)) - Ord('A') + 1 else
  if PathIsUNCPathA(Path) then
    begin
      Result := -1;
      exit;
    end
  else
    D := 0;
  Result := DiskFree(D);
end;
{$ENDIF}



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF DEBUG}{$IFDEF SELFTEST}
{$ASSERTIONS ON}
procedure SelfTest;
begin
  // PathHasDriveLetter
  Assert(PathHasDriveLetterA('A:'), 'PathHasDriveLetter');
  Assert(PathHasDriveLetterA('a:'), 'PathHasDriveLetter');
  Assert(PathHasDriveLetterA('A:\'), 'PathHasDriveLetter');
  Assert(not PathHasDriveLetterA('a\'), 'PathHasDriveLetter');
  Assert(not PathHasDriveLetterA('\a\'), 'PathHasDriveLetter');
  Assert(not PathHasDriveLetterA('::'), 'PathHasDriveLetter');

  Assert(PathHasDriveLetter('A:'), 'PathHasDriveLetter');
  Assert(PathHasDriveLetter('a:'), 'PathHasDriveLetter');
  Assert(PathHasDriveLetter('A:\'), 'PathHasDriveLetter');
  Assert(not PathHasDriveLetter('a\'), 'PathHasDriveLetter');
  Assert(not PathHasDriveLetter('\a\'), 'PathHasDriveLetter');
  Assert(not PathHasDriveLetter('::'), 'PathHasDriveLetter');

  // PathIsDriveLetter
  Assert(PathIsDriveLetterA('B:'), 'PathIsDriveLetter');
  Assert(not PathIsDriveLetterA('B:\'), 'PathIsDriveLetter');

  Assert(PathIsDriveLetter('B:'), 'PathIsDriveLetter');
  Assert(not PathIsDriveLetter('B:\'), 'PathIsDriveLetter');

  // PathIsDriveRoot
  Assert(PathIsDriveRootA('C:\'), 'PathIsDriveRoot');
  Assert(not PathIsDriveRootA('C:'), 'PathIsDriveRoot');
  Assert(not PathIsDriveRootA('C:\A'), 'PathIsDriveRoot');

  Assert(PathIsDriveRoot('C:\'), 'PathIsDriveRoot');
  Assert(not PathIsDriveRoot('C:'), 'PathIsDriveRoot');
  Assert(not PathIsDriveRoot('C:\A'), 'PathIsDriveRoot');

  // PathIsAbsolute
  Assert(PathIsAbsoluteA('\'), 'PathIsAbsolute');
  Assert(PathIsAbsoluteA('\C'), 'PathIsAbsolute');
  Assert(PathIsAbsoluteA('\C\'), 'PathIsAbsolute');
  Assert(PathIsAbsoluteA('C:\'), 'PathIsAbsolute');
  Assert(PathIsAbsoluteA('C:'), 'PathIsAbsolute');
  Assert(PathIsAbsoluteA('\C\..\'), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA(''), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA('C'), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA('C\'), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA('C\D'), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA('C\D\'), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA('..\'), 'PathIsAbsolute');

  Assert(PathIsAbsolute('\'), 'PathIsAbsolute');
  Assert(PathIsAbsolute('\C'), 'PathIsAbsolute');
  Assert(PathIsAbsolute('\C\'), 'PathIsAbsolute');
  Assert(PathIsAbsolute('C:\'), 'PathIsAbsolute');
  Assert(PathIsAbsolute('C:'), 'PathIsAbsolute');
  Assert(PathIsAbsolute('\C\..\'), 'PathIsAbsolute');
  Assert(not PathIsAbsolute(''), 'PathIsAbsolute');
  Assert(not PathIsAbsolute('C'), 'PathIsAbsolute');
  Assert(not PathIsAbsolute('C\'), 'PathIsAbsolute');
  Assert(not PathIsAbsolute('C\D'), 'PathIsAbsolute');
  Assert(not PathIsAbsolute('C\D\'), 'PathIsAbsolute');
  Assert(not PathIsAbsolute('..\'), 'PathIsAbsolute');

  // PathIsDirectory
  Assert(PathIsDirectoryA('\'), 'PathIsDirectory');
  Assert(PathIsDirectoryA('\C\'), 'PathIsDirectory');
  Assert(PathIsDirectoryA('C:'), 'PathIsDirectory');
  Assert(PathIsDirectoryA('C:\'), 'PathIsDirectory');
  Assert(PathIsDirectoryA('C:\D\'), 'PathIsDirectory');
  Assert(not PathIsDirectoryA(''), 'PathIsDirectory');
  Assert(not PathIsDirectoryA('D'), 'PathIsDirectory');
  Assert(not PathIsDirectoryA('C\D'), 'PathIsDirectory');

  Assert(PathIsDirectory('\'), 'PathIsDirectory');
  Assert(PathIsDirectory('\C\'), 'PathIsDirectory');
  Assert(PathIsDirectory('C:'), 'PathIsDirectory');
  Assert(PathIsDirectory('C:\'), 'PathIsDirectory');
  Assert(PathIsDirectory('C:\D\'), 'PathIsDirectory');
  Assert(not PathIsDirectory(''), 'PathIsDirectory');
  Assert(not PathIsDirectory('D'), 'PathIsDirectory');
  Assert(not PathIsDirectory('C\D'), 'PathIsDirectory');

  // PathInclSuffix
  Assert(PathInclSuffixA('', '\') = '', 'PathInclSuffix');
  Assert(PathInclSuffixA('C', '\') = 'C\', 'PathInclSuffix');
  Assert(PathInclSuffixA('C\', '\') = 'C\', 'PathInclSuffix');
  Assert(PathInclSuffixA('C\D', '\') = 'C\D\', 'PathInclSuffix');
  Assert(PathInclSuffixA('C\D\', '\') = 'C\D\', 'PathInclSuffix');
  Assert(PathInclSuffixA('C:', '\') = 'C:\', 'PathInclSuffix');
  Assert(PathInclSuffixA('C:\', '\') = 'C:\', 'PathInclSuffix');

  Assert(PathInclSuffix('', '\') = '', 'PathInclSuffix');
  Assert(PathInclSuffix('C', '\') = 'C\', 'PathInclSuffix');
  Assert(PathInclSuffix('C\', '\') = 'C\', 'PathInclSuffix');
  Assert(PathInclSuffix('C\D', '\') = 'C\D\', 'PathInclSuffix');
  Assert(PathInclSuffix('C\D\', '\') = 'C\D\', 'PathInclSuffix');
  Assert(PathInclSuffix('C:', '\') = 'C:\', 'PathInclSuffix');
  Assert(PathInclSuffix('C:\', '\') = 'C:\', 'PathInclSuffix');

  // PathExclSuffix
  Assert(PathExclSuffixA('', '\') = '', 'PathExclSuffix');
  Assert(PathExclSuffixA('C', '\') = 'C', 'PathExclSuffix');
  Assert(PathExclSuffixA('C\', '\') = 'C', 'PathExclSuffix');
  Assert(PathExclSuffixA('C\D', '\') = 'C\D', 'PathExclSuffix');
  Assert(PathExclSuffixA('C\D\', '\') = 'C\D', 'PathExclSuffix');
  Assert(PathExclSuffixA('C:', '\') = 'C:', 'PathExclSuffix');
  Assert(PathExclSuffixA('C:\', '\') = 'C:', 'PathExclSuffix');

  Assert(PathExclSuffix('', '\') = '', 'PathExclSuffix');
  Assert(PathExclSuffix('C', '\') = 'C', 'PathExclSuffix');
  Assert(PathExclSuffix('C\', '\') = 'C', 'PathExclSuffix');
  Assert(PathExclSuffix('C\D', '\') = 'C\D', 'PathExclSuffix');
  Assert(PathExclSuffix('C\D\', '\') = 'C\D', 'PathExclSuffix');
  Assert(PathExclSuffix('C:', '\') = 'C:', 'PathExclSuffix');
  Assert(PathExclSuffix('C:\', '\') = 'C:', 'PathExclSuffix');

  // PathCanonical
  Assert(PathCanonical('', '\') = '', 'PathCanonical');
  Assert(PathCanonical('.', '\') = '', 'PathCanonical');
  Assert(PathCanonical('.\', '\') = '', 'PathCanonical');
  Assert(PathCanonical('..\', '\') = '..\', 'PathCanonical');
  Assert(PathCanonical('\..\', '\') = '\', 'PathCanonical');
  Assert(PathCanonical('\X\..\..\', '\') = '\', 'PathCanonical');
  Assert(PathCanonical('\..', '\') = '', 'PathCanonical');
  Assert(PathCanonical('X', '\') = 'X', 'PathCanonical');
  Assert(PathCanonical('\X', '\') = '\X', 'PathCanonical');
  Assert(PathCanonical('X.', '\') = 'X', 'PathCanonical');
  Assert(PathCanonical('.', '\') = '', 'PathCanonical');
  Assert(PathCanonical('\X.', '\') = '\X', 'PathCanonical');
  Assert(PathCanonical('\X.Y', '\') = '\X.Y', 'PathCanonical');
  Assert(PathCanonical('\X.Y\', '\') = '\X.Y\', 'PathCanonical');
  Assert(PathCanonical('\A\X..Y\', '\') = '\A\X..Y\', 'PathCanonical');
  Assert(PathCanonical('\A\.Y\', '\') = '\A\.Y\', 'PathCanonical');
  Assert(PathCanonical('\A\..Y\', '\') = '\A\..Y\', 'PathCanonical');
  Assert(PathCanonical('\A\Y..\', '\') = '\A\Y..\', 'PathCanonical');
  Assert(PathCanonical('\A\Y..', '\') = '\A\Y..', 'PathCanonical');
  Assert(PathCanonical('X', '\') = 'X', 'PathCanonical');
  Assert(PathCanonical('X\', '\') = 'X\', 'PathCanonical');
  Assert(PathCanonical('X\Y\..', '\') = 'X', 'PathCanonical');
  Assert(PathCanonical('X\Y\..\', '\') = 'X\', 'PathCanonical');
  Assert(PathCanonical('\X\Y\..', '\') = '\X', 'PathCanonical');
  Assert(PathCanonical('\X\Y\..\', '\') = '\X\', 'PathCanonical');
  Assert(PathCanonical('\X\Y\..\..', '\') = '', 'PathCanonical');
  Assert(PathCanonical('\X\Y\..\..\', '\') = '\', 'PathCanonical');
  Assert(PathCanonical('\A\.\.\X\.\Y\..\.\..\.\', '\') = '\A\', 'PathCanonical');
  Assert(PathCanonical('C:', '\') = 'C:', 'PathCanonical');
  Assert(PathCanonical('C:\', '\') = 'C:\', 'PathCanonical');
  Assert(PathCanonical('C:\A\..', '\') = 'C:', 'PathCanonical');
  Assert(PathCanonical('C:\A\..\', '\') = 'C:\', 'PathCanonical');
  Assert(PathCanonical('C:\..\', '\') = 'C:\', 'PathCanonical');
  Assert(PathCanonical('C:\..', '\') = 'C:', 'PathCanonical');
  Assert(PathCanonical('C:\A\..\..', '\') = 'C:', 'PathCanonical');
  Assert(PathCanonical('C:\A\..\..\', '\') = 'C:\', 'PathCanonical');
  Assert(PathCanonical('\A\B\..\C\D\..\', '\') = '\A\C\', 'PathCanonical');
  Assert(PathCanonical('\A\B\..\C\D\..\..\', '\') = '\A\', 'PathCanonical');
  Assert(PathCanonical('\A\B\..\C\D\..\..\..\', '\') = '\', 'PathCanonical');
  Assert(PathCanonical('\A\B\..\C\D\..\..\..\..\', '\') = '\', 'PathCanonical');

 (* Assert(PathExpandA('', '', '\') = '', 'PathExpand');
  Assert(PathExpandA('', '\', '\') = '\', 'PathExpand');
  Assert(PathExpandA('', '\C', '\') = '\C', 'PathExpand');
  Assert(PathExpandA('', '\C\', '\') = '\C\', 'PathExpand');
  Assert(PathExpandA('..\', '\C\', '\') = '\', 'PathExpand');
  Assert(PathExpandA('..', '\C\', '\') = '', 'PathExpand');
  Assert(PathExpandA('\..', '\C\', '\') = '', 'PathExpand');
  Assert(PathExpandA('\..\', '\C\', '\') = '\', 'PathExpand');
  Assert(PathExpandA('A', '..\', '\') = '..\A', 'PathExpand');
  Assert(PathExpandA('..\', '..\', '\') = '..\..\', 'PathExpand');
  Assert(PathExpandA('\', '', '\') = '\', 'PathExpand');
  Assert(PathExpandA('\', '\C', '\') = '\', 'PathExpand');
  Assert(PathExpandA('\A', '\C\', '\') = '\A', 'PathExpand');
  Assert(PathExpandA('\A\', '\C\', '\') = '\A\', 'PathExpand');
  Assert(PathExpandA('\A\B', '\C', '\') = '\A\B', 'PathExpand');
  Assert(PathExpandA('A\B', '\C', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('A\B', '\C', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('A\B', '\C\', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('A\B', '\C\', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('A\B', 'C\D', '\') = 'C\D\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B', 'C\D', '\') = 'C\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B', '\C\D', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('..\..\A\B', 'C\D', '\') = 'A\B', 'PathExpand');
  Assert(PathExpandA('..\..\A\B', '\C\D', '\') = '\A\B', 'PathExpand');
  Assert(PathExpandA('..\..\..\A\B', '\C\D', '\') = '\A\B', 'PathExpand');
  Assert(PathExpandA('\..\A\B', '\C\D', '\') = '\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B', '\..\C\D', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B', '..\C\D', '\') = '..\C\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B', 'C:\C\D', '\') = 'C:\C\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B\', 'C:\C\D', '\') = 'C:\C\A\B\', 'PathExpand');*)

 (* Assert(FilePathA('C', '..\X\Y', 'A\B', '\') = 'A\X\Y\C', 'FilePath');
  Assert(FilePathA('C', '\X\Y', 'A\B', '\') = '\X\Y\C', 'FilePath');
  Assert(FilePathA('C', '', 'A\B', '\') = 'A\B\C', 'FilePath');
  Assert(FilePathA('', '\X\Y', 'A\B', '\') = '', 'FilePath');
  Assert(FilePathA('C', 'X\Y', 'A\B', '\') = 'A\B\X\Y\C', 'FilePath');
  Assert(FilePathA('C', 'X\Y', '', '\') = 'X\Y\C', 'FilePath');*)

  Assert(FilePath('C', '..\X\Y', 'A\B', '\') = 'A\X\Y\C', 'FilePath');
  Assert(FilePath('C', '\X\Y', 'A\B', '\') = '\X\Y\C', 'FilePath');
  Assert(FilePath('C', '', 'A\B', '\') = 'A\B\C', 'FilePath');
  Assert(FilePath('', '\X\Y', 'A\B', '\') = '', 'FilePath');
  Assert(FilePath('C', 'X\Y', 'A\B', '\') = 'A\B\X\Y\C', 'FilePath');
  Assert(FilePath('C', 'X\Y', '', '\') = 'X\Y\C', 'FilePath');

  Assert(DirectoryExpand('', '', '\') = '', 'DirectoryExpand');
  Assert(DirectoryExpand('', '\X', '\') = '\X\', 'DirectoryExpand');
  Assert(DirectoryExpand('\', '\X', '\') = '\', 'DirectoryExpand');
  Assert(DirectoryExpand('\A', '\X', '\') = '\A\', 'DirectoryExpand');
  Assert(DirectoryExpand('\A\', '\X', '\') = '\A\', 'DirectoryExpand');
  Assert(DirectoryExpand('\A\B', '\X', '\') = '\A\B\', 'DirectoryExpand');
  Assert(DirectoryExpand('A', '\X', '\') = '\X\A\', 'DirectoryExpand');
  Assert(DirectoryExpand('A\', '\X', '\') = '\X\A\', 'DirectoryExpand');
  Assert(DirectoryExpand('C:', '\X', '\') = 'C:\', 'DirectoryExpand');
  Assert(DirectoryExpand('C:\', '\X', '\') = 'C:\', 'DirectoryExpand');

  Assert(UnixPathToWinPath('/c/d.f') = '\c\d.f', 'UnixPathToWinPath');
  Assert(WinPathToUnixPath('\c\d.f') = '/c/d.f', 'WinPathToUnixPath');
end;
{$ENDIF}{$ENDIF}



end.

