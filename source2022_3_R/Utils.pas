unit Utils;

interface

uses StringsW, Windows, SysUtils, Classes, Graphics, StringUtils, PsAPI, TlHelp32,
     Forms;    // Forms is used for FormFade*.

const
  { for SetNtfsCompression: }
  FSCTL_SET_COMPRESSION = $9C040;
  COMPRESSION_FORMAT_NONE = 0;
  COMPRESSION_FORMAT_DEFAULT = 1;

type
  TWideStringArray = StringUtils.TWideStringArray;

  // initially Exists is set to True.
  TEnvVarResolver = function (Name: WideString; var Exists: Boolean): WideString of object;

  PFormFadeSettings = ^TFormFadeSettings;
  TFormFadeSettings = record
    Form: TForm;
    Step: ShortInt;
    DisableBlendOnFinish: Boolean;
    Callback: TNotifyEvent;
    MinAlpha, MaxAlpha: Byte;
  end;

procedure AdjustArray(var DWArray: array of DWord; const Delta: Integer; MinValueToAdjust: DWord = 0);
{ -1: First < Second; 0: First = Second; +1: First > Second }
function ComparePoints(const First, Second: TPoint): ShortInt;

function HashOfString(const Str: WideString): DWord;

procedure CopyToClipboard(Str: WideString);
function GetClipboardText: WideString;
function GetDroppedFileNames(const DropID: Integer): TWideStringArray;

function AreBytesEqual(const First, Second: array of Byte): Boolean; overload;
function AreBytesEqual(const First, Second; Length: DWord): Boolean; overload;
// NumberOfBytes should be in 0..4.
function MaskForBytes(const NumberOfBytes: Byte): DWord;

function CurrentWinUser: WideString;
function GetTempPath: WideString;
function GetTempFileName: WideString;
function GetDesktopFolder: WideString;
function IsWritable(const FileName: WideString): Boolean;

function SysErrorMessage(ErrorCode: Integer): WideString;
function FormatExceptionInfo: WideString;
procedure ShowException(Message: WideString);

// note: using TForm's BorderIcons, etc. is slow (form blinks) and not reliable (for some
//       reson it causes TListView.Items to lose all associated objects and other things happen).
procedure ChangeWindowStyle(const Form: HWND; Style: DWord; AddIt: Boolean);

// From http://delphi.about.com
function IntToBin(Int: Byte): String; overload
function IntToBin(Int: Word): String; overload
function IntToBin(Int: DWord; Digits: Byte = 32; SpaceEach: Byte = 8): String; overload;

// returns number of bytes written.
function WriteWS(const Stream: TStream; const Str: WideString): Word;
procedure WriteArray(const Stream: TStream; const WSArray: array of WideString); overload;
procedure WriteArray(const Stream: TStream; const DWArray: array of DWord); overload;

// returns number of bytes read.
function ReadWS(const Stream: TStream): WideString; overload;
function ReadWS(const Stream: TStream; out Len: Word): WideString; overload;
procedure ReadArray(const Stream: TStream; var WSArray: array of WideString); overload;
procedure ReadArray(const Stream: TStream; var DWArray: array of DWord); overload;

function ParamStrW(Index: Integer): WideString;
function ParamStrFrom(CmdLine: WideString; Index: Integer): WideString;
// Pos points after the last char of Index parameter (or past the end of CmdLine string).
function ParamStrEx(CmdLine: WideString; Index: Integer; out Pos: Integer): WideString;
function ApplicationPath: WideString;  // alias to ExtractFilePath(ParamStrW(0)).

procedure FindMask(Mask: WideString; Result: TStringsW);
procedure FindAll(BasePath, Mask: WideString; Result: TStringsW);
procedure FindAllRelative(BasePath, Mask: WideString; Result: TStringsW);

function IsInvalidPathChar(const Char: WideChar): Boolean;
function MakeValidFileName(const Str: WideString; const SubstitutionChar: WideChar = '-'): WideString;

// including trailing backslash
function ExtractFilePath(FileName: WideString): WideString;
function ExtractFileName(Path: WideString): WideString;

function ExpandFileName(FileName: WideString): WideString; overload;
function ExpandFileName(FileName, BasePath: WideString): WideString; overload;
function CurrentDirectory: WideString;
function ChDir(const ToPath: WideString): Boolean;

function ExtractFileExt(FileName: WideString): WideString;
function ChangeFileExt(FileName, Extension: WideString): WideString;

function IncludeTrailingBackslash(Path: WideString): WideString;
function ExcludeTrailingBackslash(Path: WideString): WideString;
function IncludeTrailingPathDelimiter(Path: WideString): WideString;
function ExcludeTrailingPathDelimiter(Path: WideString): WideString;

function IncludeLeadingPathDelimiter(Path: WideString): WideString;
function ExcludeLeadingPathDelimiter(Path: WideString): WideString;

// if file didn't exist, sets Result.ftLastWriteTime.dwLowDateTime to 0
function FileInfo(Path: WideString): TWin32FindDataW;
function IsDirectory(Path: WideString): Boolean;
function FileAge(const FileName: WideString): Integer;
function FileExists(Path: WideString): Boolean;
function FileSize(Path: WideString): DWord;
function FileSize64(Path: WideString): Int64;
function DeleteFile(Path: WideString): Boolean;
function SetNtfsCompression(const FileName: WideString; Level: Word): Boolean;

{ recursive functions }
function CopyDirectory(Source, Destination: WideString): Boolean;
function RemoveDirectory(Path: WideString): Boolean;

function ForceDirectories(Path: WideString): Boolean;
function MkDir(Path: WideString): Boolean;

function GetEnvironmentVariable(Name: WideString): WideString;
function ResolveEnvVars(Path: WideString; Callback: TEnvVarResolver; Unescape: Boolean = True): WideString; overload;
// if Unescape = True then '%%' = '%'; this style is used in .bat'ches but not in cmd.exe directly.
function ResolveEnvVars(Path: WideString; Unescape: Boolean = True): WideString; overload;

function ReadRegValue(Root: DWord; const Path, Key: WideString): WideString;

procedure FormFadeIn(Form: TForm; Step: ShortInt = 15);
procedure FormFadeOut(Form: TForm; Step: ShortInt = 30);
procedure FormFadeOutAndWait(Form: TForm; Step: ShortInt = 30); overload;
// Callback will be called with Sender = NIL.
function FadeSettings(Form: TForm; Step: ShortInt = 15;
  Callback: TNotifyEvent = NIL): TFormFadeSettings; overload;
function FadeSettings(Form: TForm; MinAlpha, MaxAlpha: Byte;
  Step: ShortInt = 15): TFormFadeSettings; overload;
procedure FormFade(const Settings: TFormFadeSettings);

function BrowseForFolder(const Caption, DefaultPath: WideString; const OwnerWindow: HWND): WideString;

const
  MaxPathLength = 1000;   // should be greater than MAX_PATH.

type
  TUtilsLanguage = record
    ExceptionInfo:      WideString;

    ShowExceptionTitle: WideString;
    ShowException:      WideString;
  end;

  TInputBoxesLanguage = record
    OK:         WideString;
    Cancel:     WideString;
  end;

var
  UtilsLanguage:      TUtilsLanguage;
  InputBoxesLanguage: TInputBoxesLanguage;

implementation

uses MMSystem, Math, ShellAPI, ShlObj;

procedure AdjustArray(var DWArray: array of DWord; const Delta: Integer; MinValueToAdjust: DWord = 0);
var
  I: DWord;
begin
  if Length(DWArray) <> 0 then
    for I := 0 to Length(DWArray) - 1 do
      if DWArray[I] >= MinValueToAdjust then
        Inc(DWArray[I], Delta);
end;

function ComparePoints(const First, Second: TPoint): ShortInt;
begin
  if First.Y = Second.Y then
    if First.X = Second.X then
      Result := 0
      else if First.X > Second.X then
        Result := 1
        else
          Result := -1
    else if First.Y > Second.Y then
      Result := 1
      else
        Result := -1
end;

// Hashing algorithm got from IniFiles.pas: 430.
function HashOfString(const Str: WideString): DWord;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(Str) do
    Result := ((Result shl 2) or (Result shr (SizeOf(Result) * 8 - 2))) xor
      Ord(Str[I]);
end;

procedure CopyToClipboard(Str: WideString);
  procedure CopyToCLipUsing(const Data: THandle);
  var
    DataPtr: Pointer;
  begin
    DataPtr := GlobalLock(Data);
    try
      Move(Str[1], DataPtr^, Length(Str) * 2);
    finally
      GlobalUnlock(Data);
    end;

    OpenClipboard(0);
    try
      EmptyClipboard;
      SetClipboardData(CF_UNICODETEXT, Data);
    finally
      CloseClipboard;
    end;
  end;

var
  Data: THandle;
begin
  Str := Str + #0;
  Data := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, Length(Str) * 2);
  try
    CopyToCLipUsing(Data);
  except
    GlobalFree(Data);
  end;
end;

function GetClipboardText: WideString;
var
  Handle: THandle;
begin
  if IsClipboardFormatAvailable(CF_UNICODETEXT) then
  begin
    OpenClipboard(0);
    try
      Handle := GetClipboardData(CF_UNICODETEXT);
      Result := WideString( PWideChar(GlobalLock(Handle)) );
      GlobalUnlock(Handle);
    finally
      CloseClipboard;
    end;
  end;
end;

function GetDroppedFileNames(const DropID: Integer): TWideStringArray;
var
  Count, I: DWord;
begin
  Count := DragQueryFileW(DropID, $FFFFFFFF, NIL, 0);
  SetLength(Result, Count);

  if Count <> 0 then
    for I := 0 to Count - 1 do
    begin
      SetLength(Result[I], MaxPathLength);
      SetLength(Result[I], DragQueryFileW(DropID, I, @Result[I][1], MaxPathLength));
    end;
end;

function AreBytesEqual(const First, Second: array of Byte): Boolean;
begin
  Result := (Length(First) = Length(Second)) and
            AreBytesEqual(First[0], Second[0], Length(First));
end;

function AreBytesEqual(const First, Second; Length: DWord): Boolean;
begin
  Result := CompareMem(@First, @Second, Length);
end;

function MaskForBytes(const NumberOfBytes: Byte): DWord;
begin
  if NumberOfBytes < 4 then
    Result := (1 shl (NumberOfBytes * 8)) - 1
    else
      Result := $FFFFFFFF;
end;

function CurrentWinUser: WideString;
var
  Length: DWord;
begin
  Length := 300;

  SetLength(Result, Length);
  GetUserNameW(PWideChar(Result), Length);
  SetLength(Result, Length - 1) { one for null char }
end;

function GetTempPath: WideString;
begin
  SetLength(Result, MaxPathLength);
  SetLength(Result, GetTempPathW(MaxPathLength, @Result[1]));
end;

function GetTempFileName: WideString;
begin
  SetLength(Result, MAX_PATH);
  if GetTempFileNameW(PWideChar(GetTempPath), '', 0, @Result[1]) = 0 then
    Result := ''
    else if DeleteFileW(PWideChar(Result)) then // GetTempFileNameW also creates the file but we don't need it.
      Result := PWideChar(Result)
      else
        Result := '';
end;

function GetDesktopFolder: WideString;
var
  Buf: Array[0..MAX_PATH] of WideChar;
  ID: PItemIDList;
begin
  Result := '';

  if SHGetSpecialFolderLocation(0, CSIDL_DESKTOP, ID) = S_OK then
    if ID <> NIL then
      if SHGetPathFromIDListW(ID, Buf) then
        Result := IncludeTrailingPathDelimiter( Buf );
end;

function IsWritable(const FileName: WideString): Boolean;
var
  Handle: DWord;
begin
  Handle := CreateFileW(PWideChar(FileName), GENERIC_READ or GENERIC_WRITE,
                        FILE_SHARE_READ, NIL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  Result := (Integer(Handle) >= 0) and (GetLastError = 0);

  if Handle <> INVALID_HANDLE_VALUE then
    CloseHandle(Handle)
end;

function SysErrorMessage(ErrorCode: Integer): WideString;
var
  Buffer: array[0..255] of WideChar;
var
  Len: Integer;
begin
  Len := FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_IGNORE_INSERTS or
    FORMAT_MESSAGE_ARGUMENT_ARRAY, nil, ErrorCode, 0, Buffer,
    SizeOf(Buffer), nil);
  while (Len > 0) and ((((Buffer[Len - 1] >= #0) and (Buffer[Len - 1] <= #32))) or
        (Buffer[Len - 1] = '.')) do Dec(Len);
  Result := Trim(Buffer);
end;

function FormatExceptionInfo: WideString;
var
  WinError: DWord;
  E: Exception;
begin
  WinError := GetLastError;

  E := Exception(ExceptObject);
  if E = NIL then
    E := Exception.Create('No exception.');

  Result := WrapText(E.Message, #10'    ', 75);

  Result := WideFormat(UtilsLanguage.ExceptionInfo,
    [E.ClassName, DWord(ExceptAddr), Result, WinError, SysErrorMessage(WinError)]);
end;

procedure ShowException(Message: WideString);
begin
  Message := WideFormat(UtilsLanguage.ShowException, [Message, FormatExceptionInfo]);
  Windows.MessageBoxW(0, PWideChar(Message), PWideChar(UtilsLanguage.ShowExceptionTitle),
                      mb_IconStop or mb_TaskModal);
end;

procedure ChangeWindowStyle(const Form: HWND; Style: DWord; AddIt: Boolean);
var
  Styles: DWord;
begin
  Styles := DWord(GetWindowLong(Form, GWL_STYLE));

  if AddIt then
    Styles := Styles or Style
    else
      Styles := Styles and not Style;

  SetWindowLong(Form, GWL_STYLE, Styles)
end;

function IntToBin(Int: Byte): String;
begin
  Result := IntToBin(Word(Int), 8)
end;

function IntToBin(Int: Word): String;
begin
  Result := IntToBin(Word(Int), 16)
end;

// From http://delphi.about.com
function IntToBin(Int: DWord; Digits: Byte = 32; SpaceEach: Byte = 8): String;
var
  Current: Byte;
begin
  Result := StringOfChar('0', Digits);

  Current := Digits;
  while Int > 0 do
  begin
    if Int and 1 = 1 then
      Result[Current] := '1';
    Dec(Current);
    Int := Int shr 1
  end;

  for Int := 1 to (Digits - 1) div SpaceEach do
    Insert(' ', Result, Digits - Int * SpaceEach + 1)
end;

function WriteWS(const Stream: TStream; const Str: WideString): Word;
begin
  Result := Length(Str);
  Stream.Write(Result, SizeOf(Result));
  Stream.Write(Str[1], Result * 2);

  Result := Result * 2 + SizeOf(Result);
end;

procedure WriteArray(const Stream: TStream; const WSArray: array of WideString);
var
  I: Word;
begin
  if Length(WSArray) <> 0 then
    for I := 0 to Length(WSArray) -  1 do
      WriteWS(Stream, WSArray[I])
end;

procedure WriteArray(const Stream: TStream; const DWArray: array of DWord);
begin
  if Length(DWArray) <> 0 then
    Stream.Write(DWArray[0], SizeOf(DWArray[0]) * Length(DWArray))
end;

function ReadWS(const Stream: TStream): WideString;
var
  Len: Word;
begin
  Result := ReadWS(Stream, Len);
end;

function ReadWS(const Stream: TStream; out Len: Word): WideString;
begin
  Stream.Read(Len, 2);
  SetLength(Result, Len);
  Stream.Read(Result[1], Len * 2);

  Len := Len * 2 + SizeOf(Len);
end;

procedure ReadArray(const Stream: TStream; var WSArray: array of WideString);
var
  I: Word;
begin
  if Length(WSArray) <> 0 then
    for I := 0 to Length(WSArray) - 1 do
      WSArray[I] := ReadWS(Stream)
end;

procedure ReadArray(const Stream: TStream; var DWArray: array of DWord);
begin
  if Length(DWArray) <> 0 then
    Stream.Read(DWArray[0], SizeOf(DWArray[0]) * Length(DWArray))
end;

function ParamStrW(Index: Integer): WideString;
begin
  if Index = 0 then
  begin
    SetLength(Result, MaxPathLength);
    SetLength(Result, GetModuleFileNameW(0, @Result[1], MaxPathLength));
  end
    else
      Result := ParamStrFrom(GetCommandLineW, Index);
end;

function ParamStrFrom(CmdLine: WideString; Index: Integer): WideString;
var
  Pos: Integer;
begin
  Result := ParamStrEx(CmdLine, Index, Pos);
end;

function ParamStrEx(CmdLine: WideString; Index: Integer; out Pos: Integer): WideString;
var
  CurrentIndex: Word;
  Join: Boolean;
begin
  Result := '';
  Join := False;
  CurrentIndex := 0;

  Pos := 1;
  while Pos <= Length(CmdLine) do
  begin
    if CmdLine[Pos] = '"' then
      Join := not Join
      else if (CmdLine[Pos] = ' ') and not Join then
      begin
        if (Pos >= Length(CmdLine)) or (CmdLine[Pos + 1] <> ' ') then
          Inc(CurrentIndex)
      end
        else if CurrentIndex = Index then
          Result := Result + CmdLine[Pos]
          else if CurrentIndex > Index then
            Exit;
    Inc(Pos);
  end;
end;

function ApplicationPath: WideString;
begin
  Result := ExtractFilePath(ParamStrW(0));
end;

// override SysUtils.FindClose
function FindClose(Handle: DWord): Boolean;
begin
  Result := Windows.FindClose(Handle)
end;

procedure FindMask(Mask: WideString; Result: TStringsW);
var
  SR: TWin32FindDataW;
  Handle: DWord;
begin
  Handle := FindFirstFileW(PWideChar(Mask), SR);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    repeat
      if (WideString(SR.cFileName) <> '.') and (WideString(SR.cFileName) <> '..') then
        Result.Add(SR.cFileName, SR.dwFileAttributes)
    until not FindNextFileW(Handle, SR);
    Windows.FindClose(Handle)
  end
end;

procedure FindAll(BasePath, Mask: WideString; Result: TStringsW);
var
  I: DWord;
  S: TStringListW;
begin
  if BasePath <> '' then
    BasePath := IncludeTrailingBackslash(BasePath);

  S := TStringListW.Create;
  FindMask(BasePath + Mask, S);

  if S.Count <> 0 then
    for I := 0 to S.Count - 1 do
      if S.Tags[I] and FILE_ATTRIBUTE_DIRECTORY = 0 then
        Result.Add(BasePath + S[I])
        else
          FindAll(BasePath + S[I], Mask, Result);

  S.Free
end;

procedure FindAllRelative(BasePath, Mask: WideString; Result: TStringsW);
var
  I: DWord;
begin
  BasePath := IncludeTrailingBackslash(BasePath);
  FindAll(BasePath, Mask, Result);

  if Result.Count <> 0 then
    for I := 0 to Result.Count - 1 do
      Result[I] := Copy(Result[I], Length(BasePath) + 1, Length(Result[I]))
end;

function IsInvalidPathChar(const Char: WideChar): Boolean;
begin
  Result := (Char = '\') or (Char = '/') or (Char = '*') or (Char = '?') or
            (Char = '<') or (Char = '>') or (Char = ':') or (Char = '|') or (Char = '"');
end;

function MakeValidFileName(const Str: WideString; const SubstitutionChar: WideChar): WideString;
var
  I: Integer;
begin
  if (Str = '') or (Str = '.') or (Str = '..') then
    Result := StringOfChar(SubstitutionChar, Length(Str) + 1)
    else
    begin
      Result := Str;
      for I := 1 to Length(Result) - 1 do
        if IsInvalidPathChar(Result[I]) then
          Result[I] := SubstitutionChar;
    end;
end;

function ExtractFilePath(FileName: WideString): WideString;
var
  I: Word;
begin
  Result := '';
  I := Length(FileName);
  while (I >= 1) and (FileName[I] <> '\') and (FileName[I] <> ':') do
    Dec(I);
  Result := Copy(FileName, 1, I);
end;

// todo: turn this into IncludeTrailingPathDelimiter.
function IncludeTrailingBackslash(Path: WideString): WideString;
begin
  Result := Path;
  if (Result = '') or (Result[Length(Result)] <> '\') then
    Insert('\', Result, MaxInt);
end;

// todo: turn this into ExcludeTrailingPathDelimiter.
function ExcludeTrailingBackslash(Path: WideString): WideString;
begin
  Result := Path;
  if (Result <> '') and (Result[Length(Result)] = '\') then
    Delete(Result, Length(Result), 1);
end;

function IncludeTrailingPathDelimiter(Path: WideString): WideString;
begin
  Result := Path;
  if (Result = '') or (Result[Length(Result)] <> PathDelim) then
    Insert(PathDelim, Result, MaxInt);
end;

function ExcludeTrailingPathDelimiter(Path: WideString): WideString;
begin
  Result := Path;
  if (Result <> '') and (Result[Length(Result)] = PathDelim) then
    Delete(Result, Length(Result), 1);
end;

function IncludeLeadingPathDelimiter(Path: WideString): WideString;
begin
  Result := Path;
  if (Result <> '') and (Result[1] <> PathDelim) then
    Insert(PathDelim, Result, 1);
end;

function ExcludeLeadingPathDelimiter(Path: WideString): WideString;
begin
  Result := Path;
  if (Result <> '') and (Result[1] = PathDelim) then
    Delete(Result, 1, 1);
end;

function ExtractFileName(Path: WideString): WideString;
var
  I: Word;
begin
  for I := Length(Path) downto 1 do
    if (Path[I] = '\') or (Path[I] = ':') then
    begin
      Result := Copy(Path, I + 1, Length(Path));
      Exit
    end;

  Result := Path
end;

function ExtractFileExt(FileName: WideString): WideString;
var
  I: Word;
begin
  for I := Length(FileName) downto 1 do
    if FileName[I] = '\' then
      Break
      else if FileName[I] = '.' then
      begin
        Result := Copy(FileName, I, Length(FileName));
        Exit
      end;

  Result := ''
end;

function ExpandFileName(FileName: WideString): WideString;
var
  Name: PWideChar;
begin
  SetLength(Result, MaxPathLength);
  SetLength(Result, GetFullPathNameW(PWideChar(FileName), MaxPathLength, PWideChar(Result), Name));
end;

function ExpandFileName(FileName, BasePath: WideString): WideString;
var
  CWD: WideString;
begin
  CWD := CurrentDirectory;
  try
    Result := ExpandFileName(FileName);
  finally
    ChDir(CWD);
  end;
end;

function CurrentDirectory: WideString;
begin
  SetLength(Result, MaxPathLength);
  SetLength(Result, GetCurrentDirectoryW(MaxPathLength, PWideChar(Result)));
  Result := IncludeTrailingBackslash(Result);
end;

function ChDir(const ToPath: WideString): Boolean;
begin
  Result := SetCurrentDirectoryW(PWideChar(ToPath));
end;

function ChangeFileExt(FileName, Extension: WideString): WideString;
var
  I: Word;
begin
  for I := Length(FileName) downto 1 do
    if FileName[I] = '\' then
      Break
      else if FileName[I] = '.' then
      begin
        Result := Copy(FileName, 1, I - 1) + Extension;
        Exit
      end;

  Result := FileName + Extension;
end;

function FileInfo;
var
  Handle: DWord;
begin
  Handle := FindFirstFileW(PWideChar( ExcludeTrailingBackslash(Path) ), Result);
  if Handle <> INVALID_HANDLE_VALUE then
    Windows.FindClose(Handle)
    else
      Result.ftLastWriteTime.dwLowDateTime := 0
end;

function IsDirectory;
begin
  with FileInfo(Path) do
    Result := (ftLastWriteTime.dwLowDateTime <> 0) and (dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0)
end;

function FileAge(const FileName: WideString): Integer;
var
  LocalFileTime: TFileTime;
begin
  with FileInfo(FileName) do
    if (ftLastWriteTime.dwLowDateTime <> 0) and (dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = 0) then
    begin
      FileTimeToLocalFileTime(ftLastWriteTime, LocalFileTime);
      if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi, LongRec(Result).Lo) then
        Exit;
    end;

  Result := -1;
end;

function FileExists;
begin
  with FileInfo(Path) do
    Result := (ftLastWriteTime.dwLowDateTime <> 0) and (dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = 0)
end;

function FileSize(Path: WideString): DWord;
begin
  with FileInfo(Path) do
    if nFileSizeHigh = 0 then
      Result := nFileSizeLow
      else
        Result := MAXDWORD;
end;

function FileSize64(Path: WideString): Int64;
begin
  with FileInfo(Path) do
    Result := nFileSizeHigh shl 32 or nFileSizeLow;
end;

function DeleteFile(Path: WideString): Boolean;
begin
  Result := DeleteFileW(PWideChar(Path));
end;

function SetNtfsCompression(const FileName: WideString; Level: Word): Boolean;
var
  Handle, BytesReturned: DWord;
begin
  Result := False;

  Handle := CreateFileW(PWideChar(FileName), GENERIC_READ or GENERIC_WRITE,
                        FILE_SHARE_READ or FILE_SHARE_WRITE, NIL, OPEN_EXISTING, 0, 0);

  if Handle <> INVALID_HANDLE_VALUE then
    try
      Result := DeviceIoControl(Handle, FSCTL_SET_COMPRESSION, @Level, SizeOf(Level), NIL, 0, BytesReturned, NIL);
    finally
      CloseHandle(Handle);
    end;
end;

function CopyDirectory;
var
  SR: TWin32FindDataW;
  Handle: DWord;
begin
  Result := True;

  Source := IncludeTrailingBackslash(Source);
  Destination := IncludeTrailingBackslash(Destination);
  ForceDirectories(Destination);

  Handle := FindFirstFileW(PWideChar(Source + '*.*'), SR);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    repeat
      if (WideString(SR.cFileName) <> '.') and (WideString(SR.cFileName) <> '..') then
        if (SR.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0) then
          Result := CopyDirectory(Source + SR.cFileName, Destination + SR.cFileName) and Result
          else
            Result := CopyFileW( PWideChar(Source + SR.cFileName), PWideChar(Destination + SR.cFileName), False ) and Result
    until not FindNextFileW(Handle, SR);
    Windows.FindClose(Handle)
  end
end;

function RemoveDirectory;
var
  SR: TWin32FindDataW;
  Handle: DWord;
begin
  Result := True;
  Path := IncludeTrailingBackslash(Path);

  Handle := FindFirstFileW(PWideChar(Path + '*.*'), SR);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    repeat
      if (WideString(SR.cFileName) <> '.') and (WideString(SR.cFileName) <> '..') then
        if (SR.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0) then
          Result := RemoveDirectory(Path + SR.cFileName) and Result
          else
            Result := DeleteFileW(PWideChar(Path + SR.cFileName)) and Result
    until not FindNextFileW(Handle, SR);
    Windows.FindClose(Handle)
  end;

  Result := RemoveDirectoryW(PWideChar(Path)) and Result
end;

function ForceDirectories(Path: WideString): Boolean;
var
  I: Word;
begin
  Result := True;
  Path := IncludeTrailingBackslash(Path);

  for I := 1 to Length(Path) do
    if Path[I] = '\' then
      try
        if not IsDirectory(Copy(Path, 1, I)) then
          MkDir(Copy(Path, 1, I))
      except
        Result := False;
        Break
      end
end;

function MkDir(Path: WideString): Boolean;
begin
  Result := CreateDirectoryW(PWideChar(Path), NIL)
end;

function GetEnvironmentVariable(Name: WideString): WideString;
begin
  SetLength(Result, $FFFF);
  SetLength(Result, GetEnvironmentVariableW(PWideChar(Name), @Result[1], Length(Result)) );
end;

function ResolveEnvVars(Path: WideString; Callback: TEnvVarResolver; Unescape: Boolean = True): WideString;
var
  I, VarPos: Integer;
  Name, Value: WideString;
  VarExists: Boolean;
begin
  VarPos := 0;

  for I := 1 to Length(Path) do
    if Path[I] = '%' then
      if VarPos > 0 then
      begin
        Name := Copy(Path, VarPos + 1, I - VarPos - 1);

        VarExists := True;
        Value := Callback(Name, VarExists);

        if (Name <> '') and VarExists then
        begin
          Result := Result + Value;
          VarPos := 0;
        end
          else
          begin
            if Unescape and (Name = '') then
              Result := Result + '%'
              else
                Result := Result + '%' + Name + '%';

            VarPos := I;
          end;
      end
        else
          VarPos := I
      else if VarPos = 0 then
        Result := Result + Path[I];
end;

type
  TVarResolver = class
  public
    class function Resolve(Name: WideString; var Exists: Boolean): WideString;
  end;

  class function TVarResolver.Resolve(Name: WideString; var Exists: Boolean): WideString;
  begin
    Result := GetEnvironmentVariable(Name);
    Exists := Result <> '';
  end;

function ResolveEnvVars(Path: WideString; Unescape: Boolean = True): WideString;
begin
  Result := ResolveEnvVars(Path, TVarResolver.Resolve, Unescape);
end;

function ReadRegValue(Root: DWord; const Path, Key: WideString): WideString;
var
  Handle: HKEY;
  Len: Integer;
  Buf: WideString;
begin
  Result := '';

  if RegOpenKeyW(Root, PWideChar(Path), Handle) = ERROR_SUCCESS then
  begin
    Len := MAX_PATH;
    SetLength(Buf, Len);
    if RegQueryValueExW(Handle, PWideChar(Key), NIL, NIL, @Buf[1], @Len) = ERROR_SUCCESS then
      Result := PWideChar(Buf);
    RegCloseKey(Handle);
  end;
end;

function FormFader(p1, p2: DWord; Fading: PFormFadeSettings; p4, p5: DWord): DWord; stdcall;
var
  Call: TNotifyEvent;
begin
  Result := 1;

  with Fading^, Form do
    if (AlphaBlendValue + Step >= MaxAlpha) or (AlphaBlendValue + Step <= MinAlpha) then
    begin
      if Step > 0 then
      begin
        AlphaBlend := not DisableBlendOnFinish;
        AlphaBlendValue := MaxAlpha;
      end
        else
          AlphaBlendValue := MinAlpha;

      Call := Callback;
      FreeMem(Fading, SizeOf(Fading^));

      if Assigned(Call) then
        Call(NIL);
    end
      else
      begin
        AlphaBlendValue := AlphaBlendValue + Step;
        timeSetEvent(10, 15, @FormFader, DWord(Fading), TIME_ONESHOT);
      end;
end;

function FadeSettings(Form: TForm; Step: ShortInt = 15;
  Callback: TNotifyEvent = NIL): TFormFadeSettings;
begin
  Result.Form := Form;
  Result.Step := Step;
  Result.DisableBlendOnFinish := True;
  Result.Callback := Callback;
  Result.MinAlpha := 0;
  Result.MaxAlpha := 255;
end;

function FadeSettings(Form: TForm; MinAlpha, MaxAlpha: Byte;
  Step: ShortInt = 15): TFormFadeSettings;
begin
  Result.Form := Form;
  Result.Step := Step;
  Result.DisableBlendOnFinish := MaxAlpha = 255;
  Result.Callback := NIL;
  Result.MinAlpha := MinAlpha;
  Result.MaxAlpha := MaxAlpha;
end;

procedure FormFade(const Settings: TFormFadeSettings);
var
  Mem: PFormFadeSettings;
begin
  GetMem(Mem, SizeOf(Mem^));
  Move(Settings, Mem^, SizeOf(Settings));

  Settings.Form.AlphaBlend := True;
  with Settings do
    if Settings.Step > 0 then
      Form.AlphaBlendValue := MinAlpha
      else
        Form.AlphaBlendValue := MaxAlpha;

  FormFader(0, 0, Mem, 0, 0);
end;

procedure FormFadeIn(Form: TForm; Step: ShortInt = 15);
begin
  FormFade(FadeSettings(Form, Step));
end;

type
  // private class for FormFade*
  TFadeIndicator = class
    HasFaded: Boolean;
    procedure FormFaded(Sender: TObject);
  end;

procedure TFadeIndicator.FormFaded(Sender: TObject);
begin
  HasFaded := True;
end;

procedure FormFadeOutAndWait(Form: TForm; Step: ShortInt = 30);
var
  FakeObject: TFadeIndicator;
begin
  FakeObject := TFadeIndicator.Create;
  try
    FakeObject.HasFaded := False;

    FormFade(FadeSettings(Form, -Step, FakeObject.FormFaded));

    while not FakeObject.HasFaded do
      Application.ProcessMessages;
  finally
    FakeObject.Free;
  end;
end;

procedure FormFadeOut(Form: TForm; Step: ShortInt = 30);
begin
  FormFade(FadeSettings(Form, -Step));
end;

// got a hint from http://cboard.cprogramming.com/windows-programming/53507-mfc-open-directory-dialog-box.html
function BrowseForFolderCallback(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer; stdcall;
begin
  // lpData = initial path.
	if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
  	SendMessage(Wnd, BFFM_SETSELECTIONW, 1, lpData);

	Result := 0;  // should be always 0.
end;

function BrowseForFolder(const Caption, DefaultPath: WideString; const OwnerWindow: HWND): WideString;
Var
  BrowseInfo: TBrowseInfoW;
  ResPIDL: PItemIDList;
begin
  Result := '';

  ZeroMemory(@BrowseInfo, SizeOf(BrowseInfo));
  with BrowseInfo do
  begin
    hWndOwner := OwnerWindow;
    lpszTitle := PWideChar(Caption);
    ulFlags := BIF_RETURNONLYFSDIRS or BIF_USENEWUI or BIF_STATUSTEXT ;
    SHGetSpecialFolderLocation(0, CSIDL_DESKTOP, pidlRoot);
    lpfn := BrowseForFolderCallback;
    lParam := Integer( PWideChar(DefaultPath) );
  end;

  ResPIDL := SHBrowseForFolderW(BrowseInfo);
  if ResPIDL <> NIL then
  begin
    SetLength(Result, MAX_PATH);
    if SHGetPathFromIDListW(ResPIDL, @Result[1]) then
      // PWideChar() - to trim trailing #0s.
      Result := IncludeTrailingPathDelimiter( PWideChar(Result) )
      else
        Result := '';
  end;
end;


initialization
  with UtilsLanguage do
  begin
    ExceptionInfo :=
      'Exception details:'#10 +
      '%s @ %.8x:'#10 +                  // exception class name, address
        #10 +
      '    %s'#10 +                      // exception message
        #10 +
      'GetLastError = %d'#10 +           // code
      '    (%s)';                        // formatted message

    ShowExceptionTitle := 'The erogram encoutered a critical error';
    ShowException :=
      '%s'#10 +                          // message
        #10 +
      '%s'#10 +                          // exception info
      #10 +
      'Sorry.'
  end;

end.