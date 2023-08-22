unit NixUtils;

interface

uses
  Windows,
  Graphics,
  SysUtils,
  ActiveX,
  Controls,
  Classes,
  shDocVw,
  Forms,
  Dialogs;

type
  TnxBits = 0 .. 31;
  TDayHours = 0 .. 23;

  NixUtilsException = class(Exception);

  TCharSet = set of AnsiChar;

type
  TDatasetAction = (daOpen, daClose);

resourcestring
  strNotAvail = 'Not Available';
  strUnknownTimeZone = 'You have asked for time zone information that is unknown';
  strUTCTimeError = 'Error converting to UTC Time.  Time zone could not be determined.';

const
  SE_CopyError = 1;
  SE_CreateError = 2;

  strRegisteredOwner = 'RegisteredOwner';
  strRegisteredOrganization = 'RegisteredOrganization';
  sWin32Error = 'Win32 Error %d: %s';

const
  Null = #0;
  Backspace = #8;
  Tab = #9;
  LF = #10;
  CR = #13;
  CRLF = #13#10;
  EOF = #26;
  ESC = #27;
  Space = ' ';
  Comma = ',';
  Dash = '-';
  Period = '.';
  At = '@';
  Exclamation = '!';
  Question = '?';
  DoubleQuote = '"';
  SingleQuote = '''';
  SemiColon = ';';
  Colon = ':';

  BackSlash = '\';
  ForwardSlash = '/';

{$IFDEF WINDOWS}

  PathSeparator = BackSlash;
  NewLine = CRLF;

{$ENDIF}

{$IFDEF LINUX}

  PathSeparator = ForwardSlash;
  NewLine = LF;

{$ENDIF}

  EmptyStr = '';
  Ellipse = '...';
  Underscore = '_';

  UpAlphaChars = ['A' .. 'Z'];
  LowAlphaChars = ['a' .. 'z'];
  AlphaChars = UpAlphaChars + LowAlphaChars;
  NumChars = ['0' .. '9'];

  AlphaNumChars = AlphaChars + NumChars;
  EMailChars = AlphaNumChars + [Dash, Period, At, Underscore];
  FloatChars = NumChars + [Period, Dash];
  FieldNameChars = AlphaChars + NumChars + [Underscore];

  EndPunctuation = [Period, Exclamation, Question, DoubleQuote];
  Punctuation = [SingleQuote, Comma, Space, SemiColon, Colon] + EndPunctuation;

  HoursInDay = 24;
  Hour = 1 / HoursInDay;
  Minute = Hour / 60;
  Second = Minute / 60;
  Millisecond = Second / 1000;

  MinutesInDay = HoursInDay * 60;
  SecondsInDay = MinutesInDay * 60;
  MillisecondsInDay = SecondsInDay * 1000;
  MillisecondsInMinute = 60 * 1000;
  MillisecondsInHour = MillisecondsInMinute * 60;

  CurrentVersion = 'CurrentVersion';

const
  TDaysInMonth: array [1 .. 12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

// System Functions
function IsWin95: Boolean;

function IsWinNT: Boolean;

function IsWin98: Boolean;

function IsWindowsXP: Boolean;

function REG_CURRENT_VERSION: string;

function RegisteredOwner: string;

function RegisteredCompany: string;

function GetLocalComputerName: string;

function GetLocalUserName: string;

/// <summary>
/// Deletes a file, but places it in the RecycleBin
/// </summary>
function DeleteToRecycleBin(WindowHandle: HWND; Filename: string; Confirm: Boolean): Boolean;

/// <summary>
/// Removes a backslash character ('\') from a given string, usually a directory name
/// </summary>
function RemoveBackSlash(const Dir: string): string;

/// <summary>
/// Ensures that a given string, usually a directory name, has a backslash ('\') on the end
/// of it.  If a backslash is already at the end, then the string is unaltered.
/// </summary>
function EnsureBackSlash(aPath: string): string;

/// <summary>
/// Ensures that a given string, usually a directory name, has a forward slash ('/') on the end
/// of it.  If a backslash is already at the end, then the string is unaltered.
/// </summary>
function EnsureForwardSlash(aPath: string): string;

function RemoveLeadingSlash(aPath: string): string;

/// <summary>
/// Determines if two directories are the same. Returns True if they are, False otherwise
/// </summary>
function SameDirectories(aDir1, aDir2: TFilename): Boolean;

/// <summary>
/// Ensures that a file extension starts with a period ('.')
/// </summary>
function EnsureExtensionHasLeadingPeriod(aExtension: string): string;

function RemoveExtension(aFilename: string): string;

/// <summary>
/// Returns a string holoding the fully qualified filename for the current binary module being executed.
/// </summary>
function GetModuleFileNameStr: string;

function ModulePath: string;

/// <summary>
/// Creates an ini file name based on the executable name of the code being executed.
/// For instance, if the executable is "MyApp.exe", the string returned will be "MyApp.ini"
/// </summary>
function IniFileName: string;

function MakeFilenameInExePath(aFilename: TFilename): TFilename;

// Bit Manipulation Functions
function IsBitSet(Bits: Integer; BitToSet: TnxBits): Boolean;

function SetBit(Bits: Integer; BitToSet: TnxBits): Integer;

function UnSetBit(Bits: Integer; BitToSet: TnxBits): Integer;

function FlipBit(Bits: Integer; BitToSet: TnxBits): Integer;

// Date & Time Functions
function YearOfDate(DateTime: TDateTime): Integer; // Tested

function MonthOfDate(DateTime: TDateTime): Integer; // Tested

function DayOfDate(DateTime: TDateTime): Integer; // Tested

function HourOfTime(DateTime: TDateTime): Integer; // Tested

function MinuteOfTime(DateTime: TDateTime): Integer; // Tested

function SecondOfTime(DateTime: TDateTime): Integer; // Tested

function IsLeapYear(DateTime: TDateTime): Boolean; // Tested

function DaysInMonth(DateTime: TDateTime): Integer; // Tested

function MakeUTCTime(DateTime: TDateTime): TDateTime;

function MakeLocalTimeFromUTC(DateTime: TDateTime): TDateTime;

function IsStandardTime: Boolean;

function UnixNow: Int64;

function NowString: string;

// HTML Functions
function MakeClosedTag(aTagName, aTagValue: string): string; // Tested

function MakeOpenTag(aTagName, aTagAttributes: string): string; // Tested

function MakeBold(Str: string): string;

function MakeItalic(Str: string): string;

function MakeUnderline(Str: string): string;

function MakeStrikeout(Str: string): string;

function MakeCenter(Str: string): string;

function MakeParagraph(Str: string): string;

function MakeCode(Str: string): string;

function MakeOption(aValue, aText: string): string;

function MakeHTMLFontSize(Str: string; SizeParam: string): string;

function AddQuotes(Str: string): string; // Tested

function AddSingleQuotes(Str: string): string; // Tested

function MakeHTMLParam(Str: string): string;

function MakeLink(URL, name: string): string;

function MakeLinkTarget(URL, name, Target: string): string;

function MakeMailTo(Address, name: string): string;

function HTMLToDelphiColor(S: string): TColor;

function ColorToHTMLHex(Color: TColor): string;

function GetStringFromRes(ResName: string): string;

function EscapeText(sText: string): string;

function EncodeForXML(const aString: string): string;

// String Function
function IsStringAlpha(Str: string): Boolean; // Tested

function IsStringNumber(Str: string): Boolean; // Tested

function EnsurePrefix(aPrefix, aText: string): string;

function StringToAcceptableChars(S: string; AcceptableChars: TCharSet): string;

function StringIsAcceptable(S: string; AcceptableChars: TCharSet): Boolean;

function ValidateEMailAddress(aEmail: string): Boolean;

function FirstChar(Str: string): Char;

function LastChar(Str: string): Char;

function StringIsEmpty(Str: string): Boolean; // Tested

function StringIsNotEmpty(Str: string): Boolean;

function StringHasSpacesInMiddle(Str: string): Boolean;

function StringContains(aString: string; aSubStr: string): Boolean;

function SpacesToUnderscore(S: string): string; // Tested

function SpacesToPluses(Str: string): string; // Tested

function SwapString(Str: string): string; // Tested

/// <summary>
/// Creates a string with a standard copyright statement using the current year.
/// </summary>
function MakeCopyrightNotice(aCopyrightHolder: string): string;

procedure WriteStringToFile(aStr: string; aFilename: TFilename);

// Miscellaneous Functions

function WinExecandWait32(Path: PChar; Visibility: Word): Integer;

function WinExecAndWait32V2(Filename: string; Visibility: Integer): DWORD;

function WindowsExit(RebootParam: Longword): Boolean;

function GetVersionInfo: string;

function VersionString(aPrefix: string; aUseColon: Boolean): string;

function CreateTempFileName(aPrefix: string): string;

function GetWindowsTempDir: string;

function GetWindowsDir: string;

function GetSystemDir: string;

function GetSpecialFolderLocation(aFolderType: Integer): string;

function GetTextFileContents(aFilename: TFilename): string;

function GetBDSDir(aVersion: Integer): string;

function CaptionMessageDlg(const aCaption: string; const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;

function StreamFileCopy(const SourceFilename, TargetFilename: string; KeepDate: Boolean): Integer;

function MakePercentString(f: Double): string;

procedure DumpKey( var aKey: Char);

function ValidateKey( var aKey: Char; AcceptableKeys: TCharSet; KillTheKey: Boolean): Boolean;

function MakeInterbaseString(aHostName, aFilename: string): string;

function ParseToken(const S: string; var FromPos: Integer; Delimiter: Char): string;

procedure MatchBounds(MovedControl, TemplateControl: TControl);

procedure LockWidth(aControl: TControl);

procedure LockHeight(aControl: TControl);

procedure LockBounds(aControl: TControl);

function TruncateFilename(aCanvas: TCanvas; aRect: TRect; aFilename: string; aMargin: Integer): string;

// Graphics Funtions
function PointInRect(const R: TRect; const P: TPoint): Boolean; overload;

function PointInRect(const R: TRect; const X, Y: Integer): Boolean; overload;

procedure VariantToStream(const V: OLEVariant; Stream: TStream);

procedure StreamToVariant(Stream: TStream; var V: OLEVariant);

// WebBrowser
procedure AssignDocument(Browser: TWebBrowser; Text: string);

procedure LoadStreamToWebBrowser(WebBrowser: TWebBrowser; Stream: TStream);

procedure SaveWebBrowserSourceToStream(Document: IDispatch; Stream: TStream);

procedure GetStylesFromBrowser(aBrowser: TWebBrowser; aStyles: TStrings);

implementation

uses
  ShlObj,
  DateUtils,
  Registry,
  ShellAPI,
  ComObj,
  FileCtrl,
  Variants,
  MSHTML,
  Messages;

// System Functions


function CharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;


function IsWin95: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_WINDOWS;
end;

function IsWin98: Boolean;
begin
  Result := Win32Platform > VER_PLATFORM_WIN32_WINDOWS;
end;

function IsWinNT: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_NT;
end;

function IsWindowsXP: Boolean;
var
  OS: TOSVERSIONINFO;
begin
  OS.dwOSVersionInfoSize := SizeOf(TOSVERSIONINFO);
  GetVersionEx(OS);
  Result := (OS.dwPlatformId = VER_PLATFORM_WIN32_NT) and (OS.dwMajorVersion = 5) and (OS.dwMinorVersion = 1);
end;

function REG_CURRENT_VERSION: string;
begin
  if IsWin95 then
    Result := 'Software\Microsoft\Windows\'
  else if IsWinNT then
    Result := 'Software\Microsoft\Windows NT\'
  else
    Result := EmptyStr;
end;

function RegisteredOwner: string;
var
  R: TRegIniFile;
begin
  R := TRegIniFile.Create('');
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    Result := R.ReadString(REG_CURRENT_VERSION + CurrentVersion, strRegisteredOwner, strNotAvail);
  finally
    R.Free;
  end;
end;

function RegisteredCompany: string;
var
  R: TRegIniFile;
begin
  R := TRegIniFile.Create('');
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    Result := R.ReadString(REG_CURRENT_VERSION + CurrentVersion, strRegisteredOrganization, strNotAvail);
  finally
    R.Free;
  end;
end;

function DeleteToRecycleBin(WindowHandle: HWND; Filename: string; Confirm: Boolean): Boolean;
var
  SH: TSHFILEOPSTRUCT;
begin
  FillChar(SH, SizeOf(SH), 0);
  with SH do
  begin
    Wnd := WindowHandle;
    wFunc := FO_DELETE;
    pFrom := PChar(Filename + #0);
    fFlags := FOF_SILENT or FOF_ALLOWUNDO;
    if not Confirm then
    begin
      fFlags := fFlags or FOF_NOCONFIRMATION
    end;
  end;
  Result := SHFileOperation(SH) = 0;
end;

function RemoveBackSlash(const Dir: string): string;
begin
  Result := EmptyStr;
  if Dir <> EmptyStr then
  begin
    if (Dir[Length(Dir)] = BackSlash) and ((Length(Dir) <> 3) or (Copy(Dir, 2, 2) <> ':\')) and ((Length(Dir) <> 2) or (Copy(Dir, 1, 2) <> '\\')) then
      Result := Copy(Dir, 1, Length(Dir) - 1)
    else
      Result := Dir;
  end;
end;

function EnsureBackSlash(aPath: string): string;
begin
  if aPath = '' then
  begin
    //Exit('');
  end;

  if (LastChar(aPath) <> BackSlash) then
  begin
    Result := aPath + BackSlash
  end
  else
  begin
    Result := aPath;
  end;
end;

function EnsureForwardSlash(aPath: string): string;
begin
  if aPath = '' then
  begin
    Result := '';
    Exit;
  end;

  if (LastChar(aPath) <> ForwardSlash) then
  begin
    Result := aPath + ForwardSlash
  end
  else
  begin
    Result := aPath;
  end;
end;

function RemoveLeadingSlash(aPath: string): string;
begin
  Result := aPath;
  if aPath <> EmptyStr then
  begin
    if CharInSet(aPath[1], ['/', '\']) then
    begin
      Result := Copy(aPath, 2, MaxInt);
    end;
  end;
end;

function EnsureExtensionHasLeadingPeriod(aExtension: string): string;
begin
  if aExtension = '' then
  begin
    Result := '';
    Exit;
  end;

  if (LastChar(aExtension) <> Period) then
  begin
    Result := Period + aExtension;
  end
  else
  begin
    Result := aExtension;
  end;
end;

function RemoveExtension(aFilename: string): string;
begin
  Result := ChangeFileExt(aFilename, EmptyStr);
end;

function SameDirectories(aDir1, aDir2: TFilename): Boolean;
begin
  Result := SameText(EnsureBackSlash(aDir1), EnsureBackSlash(aDir2));
end;

function GetModuleFileNameStr: string;
begin
  SetLength(Result, Max_Path);
  SetLength(Result, GetModuleFileName(hInstance, PChar(Result), Length(Result)));
end;

function ModulePath: string;
begin
  Result := ExtractFilePath(GetModuleFileNameStr);
end;

function IniFileName: string;
begin
  Result := ChangeFileExt(GetModuleFileNameStr, '.ini');
end;

function MakeFilenameInExePath(aFilename: TFilename): TFilename;
begin
  Result := EnsureBackSlash(ModulePath) + ExtractFilename(aFilename);
end;

// Bit Manipulation Functions

function IsBitSet(Bits: Integer; BitToSet: TnxBits): Boolean;
begin
  Result := (Bits and (1 shl BitToSet)) <> 0;
end;

function SetBit(Bits: Integer; BitToSet: TnxBits): Integer;
begin
  Result := (Bits or (1 shl BitToSet))
end;

function UnSetBit(Bits: Integer; BitToSet: TnxBits): Integer;
begin
  Result := Bits and (not(1 shl BitToSet));
end;

function FlipBit(Bits: Integer; BitToSet: TnxBits): Integer;
begin
  Result := Bits xor (1 shl BitToSet);
end;

// Date & Time Functions
function YearOfDate(DateTime: TDateTime): Integer;
var
  Y, M, D: Word;
begin
  DecodeDate(DateTime, Y, M, D);
  Result := Y
end;

function MonthOfDate(DateTime: TDateTime): Integer;
var
  Y, M, D: Word;
begin
  DecodeDate(DateTime, Y, M, D);
  Result := M;
end;

function DayOfDate(DateTime: TDateTime): Integer;
var
  Y, M, D: Word;
begin
  DecodeDate(DateTime, Y, M, D);
  Result := D;
end;

function HourOfTime(DateTime: TDateTime): Integer;
var
  H, M, S, MS: Word;
begin
  DecodeTime(DateTime, H, M, S, MS);
  Result := H;
end;

function MinuteOfTime(DateTime: TDateTime): Integer;
var
  H, M, S, MS: Word;
begin
  DecodeTime(DateTime, H, M, S, MS);
  Result := M;
end;

function SecondOfTime(DateTime: TDateTime): Integer;
var
  H, M, S, MS: Word;
begin
  DecodeTime(DateTime, H, M, S, MS);
  Result := S;
end;

function IsLeapYear(DateTime: TDateTime): Boolean;
var
  Year: Integer;
begin
  Year := YearOfDate(DateTime);
  Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0))
end;

function DaysInMonth(DateTime: TDateTime): Integer;
var
  M: Integer;
begin
  M := MonthOfDate(DateTime);
  if (M = 2) and IsLeapYear(DateTime) then
  begin
    Result := 29
  end
  else
  begin
    Result := TDaysInMonth[M];
  end;
end;

function MakeUTCTime(DateTime: TDateTime): TDateTime;
var
  TZI: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(TZI) of
    TIME_ZONE_ID_STANDARD:
      begin
        Result := DateTime + (TZI.Bias / 60 / 24);
      end;
    TIME_ZONE_ID_DAYLIGHT:
      begin
        Result := DateTime + (TZI.Bias / 60 / 24) + TZI.DaylightBias;
      end;
  else
    raise NixUtilsException.Create(strUTCTimeError);
  end;
end;

function MakeLocalTimeFromUTC(DateTime: TDateTime): TDateTime;
var
  TZI: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(TZI) of
    TIME_ZONE_ID_STANDARD:
      begin
        Result := DateTime - (TZI.Bias / 60 / 24);
      end;
    TIME_ZONE_ID_DAYLIGHT:
      begin
        Result := DateTime - (TZI.Bias / 60 / 24) + TZI.DaylightBias;
      end;
  else
    raise NixUtilsException.Create(strUTCTimeError);
  end;
end;

function IsStandardTime: Boolean;
var
  TZI: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(TZI) of
    TIME_ZONE_ID_STANDARD:
      Result := True;
    TIME_ZONE_ID_DAYLIGHT:
      Result := False;
  else
    raise NixUtilsException.Create(strUnknownTimeZone);
  end;
end;

function UnixNow: Int64;
var
  UnixBase: TDateTime;
begin
  UnixBase := EncodeDateTime(1970, 1, 1, 0, 0, 0, 0);
  Result := MilliSecondsBetween(Now, UnixBase);
end;

function NowString: string;
begin
  Result := DateTimeToStr(Now);
end;

// HTML Routines

function MakeClosedTag(aTagName, aTagValue: string): string;
begin
  Result := Format('<%s>%s</%s>', [LowerCase(aTagName), aTagValue, LowerCase(aTagName)]);
end;

function MakeOpenTag(aTagName, aTagAttributes: string): string;
begin
  Result := Format('<%s %s>', [LowerCase(aTagName), LowerCase(aTagAttributes)]);
end;

function MakeBold(Str: string): string;
begin
  Result := MakeClosedTag('b', Str);
end;

function MakeItalic(Str: string): string;
begin
  Result := MakeClosedTag('i', Str);
end;

function MakeUnderline(Str: string): string;
begin
  Result := MakeClosedTag('u', Str);
end;

function MakeStrikeout(Str: string): string;
begin
  Result := MakeClosedTag('s', Str);
end;

function MakeCenter(Str: string): string;
begin
  Result := MakeClosedTag('center', Str);
end;

function MakeParagraph(Str: string): string;
begin
  Result := MakeClosedTag('p', Str);
end;

function MakeCode(Str: string): string;
begin
  Result := MakeClosedTag('pre', Str);
end;

function MakeOption(aValue, aText: string): string;
begin
  Result := Format('<option value="%s">%s</option>', [aValue, aText]);
end;

function AddQuotes(Str: string): string;
begin
  Result := Format('"%s"', [Str]);
end;

function MakeHTMLFontSize(Str: string; SizeParam: string): string;
begin
  Result := Format('<font size="%s">%s</font>', [SizeParam, Str]);
end;

function AddSingleQuotes(Str: string): string;
begin
  Result := Format('''%s''', [Str]);
end;

function SpacesToPluses(Str: string): string;
begin
  Result := StringReplace(Str, Space, '+', [rfReplaceAll]);
end;

function MakeHTMLParam(Str: string): string;
begin
  Result := AddQuotes(SpacesToPluses(Str));
end;

function MakeLink(URL, name: string): string;
begin
  Result := Format('<a href="%s">%s</a>', [URL, name]);
end;

function MakeLinkTarget(URL, name, Target: string): string;
begin
  Result := Format('<a href=%s target="%s">%s</a>', [AddQuotes(URL), AddQuotes(Target), name]);
end;

function MakeMailTo(Address, name: string): string;
begin
  Result := Format('<a href="mailto:%s">%s</a>', [Address, name]);
end;

function HTMLToDelphiColor(S: string): TColor;
var
  Red, Green, Blue: Longint;
begin
  Red := StrToInt('$' + Copy(S, 1, 2));
  Green := StrToInt('$' + Copy(S, 3, 2));
  Blue := StrToInt('$' + Copy(S, 5, 2));
  Result := (Blue shl 16) + (Green shl 8) + Red;
end;

function ColorToHTMLHex(Color: TColor): string;
begin
  Result := IntToHex(ColorToRGB(Color), 6);
  Result := '#' + Copy(Result, 5, 2) + Copy(Result, 3, 2) + Copy(Result, 1, 2);
end;

function GetStringFromRes(ResName: string): string;
var
  RS: TResourceStream;
  SS: TStringStream;
begin
  Result := '';
  RS := TResourceStream.Create(hInstance, ResName, RT_RCDATA);
  try
    SS := TStringStream.Create('');
    try
      RS.Position := 0;
      SS.CopyFrom(RS, RS.Size);
      Result := SS.Datastring;
    finally
      SS.Free;
    end;
  finally
    RS.Free;
  end;
end;

// Stolen of the newsgroups from Tjipke van der Plaats
function EncodeForXML(const aString: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(aString) do
  begin
    case aString[i] of
      '&':
        Result := Result + '&amp;';
      '>':
        Result := Result + '&gt;';
      '<':
        Result := Result + '&lt;';
      '"':
        Result := Result + '&quot;'
      else
        Result := Result + aString[i]
    end;
  end;
end;

function EscapeText(sText: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(sText) do
    case sText[i] of
      '<':
        Result := Result + '&lt;';
      '>':
        Result := Result + '&gt;';
      '&':
        Result := Result + '&amp;';
      '"':
        Result := Result + '&quot;';
    else
      Result := Result + sText[i];
    end;
end;

// String Routines

function IsStringNumber(Str: string): Boolean;
var
  i: Integer;
begin
  for i := 1 to Length(Str) do
  begin
    if (not CharInSet(Str[i], NumChars)) then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

function IsStringAlpha(Str: string): Boolean;
var
  i: Integer;
begin
  for i := 1 to Length(Str) do
  begin
    if (not CharInSet(Str[i], AlphaChars)) then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

function EnsurePrefix(aPrefix, aText: string): string;
var
  PrefixLen: Integer;
begin
  PrefixLen := Length(aPrefix);
  if Copy(aText, 1, PrefixLen) = aPrefix then
  begin
    Result := aText;
  end
  else
  begin
    Result := aPrefix + aText;
  end;
end;

function StringToAcceptableChars(S: string; AcceptableChars: TCharSet): string;
var
  i: Integer;
begin
  i := 1;
  while i <= Length(S) do
  begin
    if not CharInSet(S[i], AcceptableChars) then
    begin
      Delete(S, i, 1);
    end
    else
    begin
      Inc(i);
    end;
  end;
  Result := S;
end;

function StringIsAcceptable(S: string; AcceptableChars: TCharSet): Boolean;
var
  i: Integer;
begin
  if Length(S) <= 0 then
  begin
    Result := False;
    Exit;
  end;
  i := 1;
  repeat
    Result := CharInSet(S[i], AcceptableChars);
    Inc(i);
  until (not Result) or (i > Length(S));
end;

function ValidateEMailAddress(aEmail: string): Boolean;

  function CheckAllowed(const S: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to Length(S) do
  begin
    if not CharInSet(S[i], EMailChars) then
    begin
      Exit;
    end;
  end;
  Result := True;
end;

var
  i: Integer;
  NamePart, ServerPart: string;
begin // of IsValidEmail
  Result := False;
  i := Pos('@', aEmail);
  if i = 0 then
  begin
    Exit;
  end;
  NamePart := Copy(aEmail, 1, i - 1);
  ServerPart := Copy(aEmail, i + 1, Length(aEmail));
  // @ or name missing         name or server missing; server min. "a.com"
  if (Length(NamePart) = 0) or ((Length(ServerPart) < 5)) then
  begin
    Exit;
  end;
  i := Pos('.', ServerPart);
  // must have dot and at least 3 places from end
  if (i = 0) or (i > (Length(ServerPart) - 2)) then
  begin
    Exit;
  end;
  Result := CheckAllowed(NamePart) and CheckAllowed(ServerPart);
end;

function LastChar(Str: string): Char;
begin
  Result := Str[Length(Str)];
end;

function FirstChar(Str: string): Char;
begin
  Result := Str[1];
end;

function StringIsEmpty(Str: string): Boolean;
begin
  Result := Str = '';
  if not Result then
  begin
    Result := Trim(Str) = EmptyStr;
  end;
end;

function StringIsNotEmpty(Str: string): Boolean;
begin
  Result := not StringIsEmpty(Str);
end;

function StringHasSpacesInMiddle(Str: string): Boolean;
begin
  Result := Pos(Space, Trim(Str)) > 0;
end;

function SpacesToUnderscore(S: string): string;
begin
  Result := StringReplace(S, Space, Underscore, [rfReplaceAll, rfIgnoreCase]);
end;

function StringContains(aString: string; aSubStr: string): Boolean;
begin
  Result := Pos(aSubStr, aString) > 0;
end;

function MakeCopyrightNotice(aCopyrightHolder: string): string;
const
  CopyrightMessage = 'Copyright Š %d By %s All Rights Reserved';
begin
  Result := Format(CopyrightMessage, [YearOf(Now), aCopyrightHolder])
end;

procedure WriteStringToFile(aStr: string; aFilename: TFilename);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Text := aStr;
    SL.SaveToFile(aFilename);
  finally
    SL.Free;
  end;
end;

function WinExecandWait32(Path: PChar; Visibility: Word): Integer;
{ returns -1 if the Exec failed, otherwise returns the process' exit
code when the process terminates }
// This is Pat Ritchey's code
var
  zAppName: array [0 .. 512] of Char;
  zCurDir: array [0 .. Max_Path] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  CP: Boolean;
begin
  StrPCopy(zAppName, Path);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);

  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;

  CP := CreateProcess(nil, zAppName, { pointer to command line string } nil, { pointer to process security attributes } nil, { pointer to thread security attributes } False,
  { handle inheritance flag } CREATE_NEW_CONSOLE or { creation flags } NORMAL_PRIORITY_CLASS, nil, { pointer to new environment block } nil, { pointer to current directory name } StartupInfo, { pointer to STARTUPINFO } ProcessInfo); { pointer to PROCESS_INF }
  if not CP then
    Result := -1
  else
  begin
    WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, DWORD(Result));
  end;
end;

function CreateTempFileName(aPrefix: string): string;
var
  Buf: array [0 .. Max_Path] of Char;
  Temp: array [0 .. Max_Path] of Char;
begin
  GetTempPath(Max_Path, Buf);
  if GetTempFilename(Buf, PChar(aPrefix), 0, Temp) = 0 then
  begin
    raise NixUtilsException.CreateFmt(sWin32Error, [GetLastError, SysErrorMessage(GetLastError)]);
  end;
  Result := string(Temp);
end;

function GetWindowsTempDir: string;
begin
  SetLength(Result, Max_Path);
  if GetTempPath(Max_Path, PChar(Result)) = 0 then
  begin
    raise NixUtilsException.CreateFmt(sWin32Error, [GetLastError, SysErrorMessage(GetLastError)]);
  end;
  SetLength(Result, StrLen(PChar(Result)));
end;

function GetWindowsDir: string;
begin
  SetLength(Result, Max_Path);
  if GetWindowsDirectory(PChar(Result), Max_Path) = 0 then
  begin
    raise NixUtilsException.CreateFmt(sWin32Error, [GetLastError, SysErrorMessage(GetLastError)]);
  end;
  SetLength(Result, StrLen(PChar(Result)));
end;

function GetSystemDir: string;
begin
  SetLength(Result, Max_Path);
  if GetSystemDirectory(PChar(Result), Max_Path) = 0 then
  begin
    raise NixUtilsException.CreateFmt(sWin32Error, [GetLastError, SysErrorMessage(GetLastError)]);
  end;
  SetLength(Result, StrLen(PChar(Result)));
end;

function CaptionMessageDlg(const aCaption: string; const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons) do
  begin
    try
      Caption := aCaption;
      HelpContext := HelpCtx;
      Result := ShowModal;
    finally
      Free;
    end;
  end;
end;

function GetLocalComputerName: string; // This code stolen from Steve Schafer
var
  Count: DWORD;
begin
  Count := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(Result, Count);
  if not GetComputerName(PChar(Result), Count) then
  begin
    raise NixUtilsException.CreateFmt(sWin32Error, [GetLastError, SysErrorMessage(GetLastError)]);
  end;
  SetLength(Result, StrLen(PChar(Result)));
end;

function GetLocalUserName: string;
var
  aLength: DWORD;
  aUserName: array [0 .. Max_Path - 1] of Char;
begin
  aLength := Max_Path;
  if not GetUserName(aUserName, aLength) then
  begin
    raise NixUtilsException.CreateFmt(sWin32Error, [GetLastError, SysErrorMessage(GetLastError)]);
  end;
  Result := string(aUserName);
end;

function StreamFileCopy(const SourceFilename, TargetFilename: string; KeepDate: Boolean): Integer;
var
  S, T: TFileStream;
  TargetDirectory: string;
begin
  Result := 0;
  TargetDirectory := ExtractFilePath(TargetFilename);
  if not DirectoryExists(TargetDirectory) then
  begin
    ForceDirectories(TargetDirectory);
  end;

  S := TFileStream.Create(SourceFilename, fmOpenRead);
  try
    try
      T := TFileStream.Create(TargetFilename, fmOpenWrite or fmCreate);
    except
      Result := SE_CreateError;
      Exit;
    end;
    try
      try
        T.CopyFrom(S, S.Size);
        if KeepDate then
        begin
          SysUtils.FileSetDate(T.Handle, FileGetDate(S.Handle));
        end;
      except
        Result := SE_CopyError;
        Exit;
      end;
    finally
      T.Free
    end;
  finally
    S.Free;
  end;
end;

function MakePercentString(f: Double): string;
begin
  Result := Format('%2.2f%%', [f * 100]);
end;

function ValidateKey( var aKey: Char; AcceptableKeys: TCharSet; KillTheKey: Boolean): Boolean;
begin
  Result := True;
  if not CharInSet(aKey, AcceptableKeys) then
  begin
    if KillTheKey then
    begin
      DumpKey(aKey);
    end;
    Result := False;
  end;
end;

procedure DumpKey( var aKey: Char);
begin
  aKey := #0;
  Beep;
end;

function PointInRect(const R: TRect; const P: TPoint): Boolean;
begin
  Result := (P.X >= R.Left) and (P.X <= R.Right) and (P.Y >= R.Top) and (P.Y <= R.Bottom);
end;

function PointInRect(const R: TRect; const X, Y: Integer): Boolean; overload;
begin
  Result := PointInRect(R, Point(X, Y));
end;

function ParseToken(const S: string; var FromPos: Integer; Delimiter: Char): string;
var
  i, FoundPos: Integer;
begin
  FoundPos := Length(S) + 1;
  for i := FromPos to Length(S) do
    if S[i] = Delimiter then
    begin
      FoundPos := i;
      break;
    end;
  Result := Copy(S, FromPos, FoundPos - FromPos);
  FromPos := FoundPos + 1;
end;

function TruncateFilename(aCanvas: TCanvas; aRect: TRect; aFilename: string; aMargin: Integer): string;
var
  TempRect: TRect;
  TempBuffer: array [0 .. Max_Path] of Char;
begin
  StrCopy(TempBuffer, PChar(aFilename));
  TempRect := aRect;
  InflateRect(TempRect, -aMargin, -aMargin);
  DrawTextEx(aCanvas.Handle, TempBuffer, -1, TempRect, DT_PATH_ELLIPSIS or DT_MODIFYSTRING or DT_CALCRECT, nil);
  Result := string(TempBuffer);
end;

procedure MatchBounds(MovedControl, TemplateControl: TControl);
begin
  MovedControl.SetBounds(TemplateControl.Left, TemplateControl.Top, TemplateControl.Width, TemplateControl.Height);
end;

procedure LockWidth(aControl: TControl);
begin
  aControl.Constraints.MinWidth := aControl.Width;
  aControl.Constraints.MaxWidth := aControl.Width;
end;

procedure LockHeight(aControl: TControl);
begin
  aControl.Constraints.MinHeight := aControl.Height;
  aControl.Constraints.MaxHeight := aControl.Height;
end;

procedure LockBounds(aControl: TControl);
begin
  LockHeight(aControl);
  LockWidth(aControl);
end;

procedure VariantToStream(const V: OLEVariant; Stream: TStream);
var
  P: Pointer;
begin
  Stream.Position := 0;
  Stream.Size := VarArrayHighBound(V, 1) - VarArrayLowBound(V, 1) + 1;
  P := VarArrayLock(V);
  Stream.write(P^, Stream.Size);
  VarArrayUnlock(V);
  Stream.Position := 0;
end;

procedure StreamToVariant(Stream: TStream; var V: OLEVariant);
var
  P: Pointer;
begin
  V := VarArrayCreate([0, Stream.Size - 1], varByte);
  P := VarArrayLock(V);
  Stream.Position := 0;
  Stream.read(P^, Stream.Size);
  VarArrayUnlock(V);
end;

function MakeInterbaseString(aHostName, aFilename: string): string;
begin
  Result := Format('%s:%s%s', [aHostName, EnsureBackSlash(ExtractFilePath(GetModuleFileNameStr)), aFilename]);
end;

// Stolen from John Kaster
procedure AssignDocument(Browser: TWebBrowser; Text: string);
// var
// Document: OleVariant;

{$IFDEF PERSIST_STREAM}

var
  InStream: TStream;
  Persist: IPersistStreamInit; // Declared in ActiveX

{$ENDIF}

begin

{$IFDEF WRITE_FILE}

  Document := LocalServerPath('temp.html');
  WriteTextFile(Document, Text); // utility function
  Browser.Navigate2(Document);

{$ENDIF}

{$IFDEF PERSIST_STREAM}

  Document := 'about:blank';
  Browser.Navigate2(Document);
  InStream := TStringStream.Create(Text);
  try
    Persist := (Browser.Document as IPersistStreamInit);
    Persist.Load(TStreamAdapter.Create(InStream));
  finally
    InStream.Free;
  end;

{$ENDIF}

{$IFDEF DISPATCH_DOC}

  Document := 'about:blank';
  Browser.Navigate2(Document);
  Document := Browser.Document as IDispatch;
  Document.Open;
  try
    Document.write(Text);
  finally
    Document.Close;
  end;

{$ENDIF}

end;

procedure SaveWebBrowserSourceToStream(Document: IDispatch; Stream: TStream);
var
  PersistStreamInit: IPersistStreamInit;
  StreamAdapter: IStream;
begin
  // Inhalt des Streams löschen
  Stream.Size := 0;
  Stream.Position := 0;

  // IPersistStreamInit - Interface des Dokuments besorgen
  if Document.QueryInterface(IPersistStreamInit, PersistStreamInit) = S_OK then
  begin
    // Verwende Stream-Adapter, um IStream Interface zu unserem
    // Stream zu bekommen
    StreamAdapter := TStreamAdapter.Create(Stream, soReference);

    // Speichere Daten aus dem Dokument in den Stream
    PersistStreamInit.Save(StreamAdapter, False);

    // Streamadapter explizit zerstören
    // (optional, würde sowieso passieren, wenn
    // Routine verlassen wird)
    StreamAdapter := nil;
  end;
end;

function SwapString(Str: string): string;
var
  i: Integer;
  Chunk: string;
begin
  if StringIsEmpty(Str) then
  begin
    Exit;
  end;

  if Odd(Length(Str)) then
  begin
    Str := Str + ' ';
  end;

  Result := EmptyStr;
  i := 1;
  while i < Length(Str) do
  begin
    Chunk := '';
    Chunk := Chunk + Str[i + 1];
    Chunk := Chunk + Str[i];
    Result := Result + Chunk;
    Inc(i, 2);
  end;
end;

procedure LoadStreamToWebBrowser(WebBrowser: TWebBrowser; Stream: TStream);
var
  PersistStreamInit: IPersistStreamInit;
  StreamAdapter: IStream;
  MemoryStream: TMemoryStream;
begin
  // Load empty HTML document into Webbrowser
  // to make "Document" a valid HTML document
  WebBrowser.Navigate('about:blank');

  // wait until finished loading
  repeat
    Application.ProcessMessages;
    Sleep(0);
  until WebBrowser.ReadyState = READYSTATE_COMPLETE;

  // Get IPersistStreamInit - Interface
  if WebBrowser.Document.QueryInterface(IPersistStreamInit, PersistStreamInit) = S_OK then
  begin
    // Clear document
    if PersistStreamInit.InitNew = S_OK then
    begin
      // Make local copy of the contents of Stream
      // if you want to use Stream directly, you have to
      // consider, that StreamAdapter will destroy it
      // automatically
      MemoryStream := TMemoryStream.Create;
      try
        MemoryStream.CopyFrom(Stream, 0);
        MemoryStream.Position := 0;
      except
        MemoryStream.Free;
        raise ;
      end;

      // Use Stream-Adapter to get IStream Interface to our stream
      StreamAdapter := TStreamAdapter.Create(MemoryStream, soOwned);

      // Load data from Stream into WebBrowser
      PersistStreamInit.Load(StreamAdapter);
    end;
  end;
end;

procedure GetStylesFromBrowser(aBrowser: TWebBrowser; aStyles: TStrings);
var
  A: OLEVariant;
  HTMLDoc: IHTMLDocument2;
  CSSCollection: IHTMLStyleSheetsCollection;
  Rules: IHTMLStyleSheetRulesCollection;
  Rule: IHTMLStyleSheetRule;
  RuleStyle: IHTMLRuleStyle;
  StyleSheet: IHTMLStyleSheet;
  i, J: Integer;

const
  FormatStr = '%s=%s';
begin
  if (aBrowser = nil) or (aStyles = nil) then
  begin
    Exit;
  end;

  HTMLDoc := aBrowser.Document as IHTMLDocument2;
  if HTMLDoc <> nil then
  begin
    CSSCollection := HTMLDoc.styleSheets;
    if Assigned(CSSCollection) then
    begin
      aStyles.Clear;
      for i := 0 to Pred(CSSCollection.Length) do
      begin
        A := i;
        StyleSheet := (IDispatch(CSSCollection.Item(A)) as IHTMLStyleSheet);
        Rules := StyleSheet.Rules;
        for J := 0 to Rules.Length - 1 do
        begin
          Rule := Rules.Item(J) as IHTMLStyleSheetRule;
          RuleStyle := Rule.style;
          aStyles.Add(Format(FormatStr, [Rule.selectorText, LowerCase(RuleStyle.cssText)]));
        end;
      end;
    end;
  end;
end;

{ -- WinExecAndWait32V2 ------------------------------------------------ }
{ : Executes a program and waits for it to terminate
@Param FileName contains executable + any parameters
@Param Visibility is one of the ShowWindow options, e.g. SW_SHOWNORMAL
@Returns -1 in case of error, otherwise the programs exit code
@Desc In case of error SysErrorMessage( GetlastError ) will return an
error message. The routine will process paint messages and messages
send from other threads while it waits.
}{ Created 27.10.2000 by P. Below
----------------------------------------------------------------------- }
function WinExecAndWait32V2(Filename: string; Visibility: Integer): DWORD;
  procedure WaitFor(processHandle: THandle);
var
  Msg: TMsg;
  ret: DWORD;
begin
  repeat
    ret := MsgWaitForMultipleObjects(1, { 1 handle to wait on } processHandle, { the handle } False, { wake on any event } INFINITE, { wait without timeout } QS_PAINT or { wake on paint messages } QS_SENDMESSAGE { or messages from other threads } );
    if ret = WAIT_FAILED then
      Exit; { can do little here }
    if ret = (WAIT_OBJECT_0 + 1) then
    begin
      { Woke on a message, process paint messages only. Calling
      PeekMessage gets messages send from other threads processed.
      }
      while PeekMessage(Msg, 0, WM_PAINT, WM_PAINT, PM_REMOVE) do
        DispatchMessage(Msg);
    end;
  until ret = WAIT_OBJECT_0;
end; { Waitfor }

var { V1 by Pat Ritchey, V2 by P.Below }
  zAppName: array [0 .. 512] of Char;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin { WinExecAndWait32V2 }
  StrPCopy(zAppName, Filename);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil, zAppName, { pointer to command line string } nil, { pointer to process security attributes } nil, { pointer to thread security attributes } False,
  { handle inheritance flag } CREATE_NEW_CONSOLE or { creation flags } NORMAL_PRIORITY_CLASS, nil, { pointer to new environment block } nil, { pointer to current directory name } StartupInfo, { pointer to STARTUPINFO } ProcessInfo) { pointer to PROCESS_INF } then
    Result := DWORD(-1) { failed, GetLastError has error code }
  else
  begin
    WaitFor(ProcessInfo.hProcess);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end; { Else }
end; { WinExecAndWait32V2 }

function GetBDSDir(aVersion: Integer): string;
var
  Reg: TRegistry;
  TempKey: string;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    try
      TempKey := Format('\Software\Borland\BDS\%d.0', [aVersion]);
      Reg.OpenKey(TempKey, False);
      Result := EnsureBackSlash(Reg.ReadString('RootDir'));
    except
      on Ex: ERegistryException do
      begin
        Result := '';
      end;
    end;
  finally
    Reg.Free;
  end;
end;

function GetSpecialFolderLocation(aFolderType: Integer): string;
var
  pidl: PItemIDList;
begin
  SHGetSpecialFolderLocation(0, aFolderType, pidl);
  SetLength(Result, Max_Path);
  SHGetPathFromIDList(pidl, PChar(Result));
  SetLength(Result, StrLen(PChar(Result)));
end;

function GetTextFileContents(aFilename: TFilename): string;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.LoadFromFile(aFilename);
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

function WindowsExit(RebootParam: Longword): Boolean;
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: Boolean;

const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
  // Shutdown
  // WindowsExit(EWX_POWEROFF or EWX_FORCE) ;

// Reboot Windows
// WindowsExit(EWX_REBOOT or EWX_FORCE) ;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    tpResult := OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, TTokenHd);
    if tpResult then
    begin
      tpResult := LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME, TTokenPvg.Privileges[0].Luid);
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := SizeOf(rTTokenPvg);
      pcbtpPreviousRequired := 0;
      if tpResult then
      begin
        Windows.AdjustTokenPrivileges(TTokenHd, False, TTokenPvg, cbtpPrevious, rTTokenPvg, pcbtpPreviousRequired);
      end;
    end;
  end;
  Result := ExitWindowsEx(RebootParam, 0);
end;

function VersionString(aPrefix: string; aUseColon: Boolean): string;
begin
  Result := aPrefix;
  if aUseColon then
  begin
    Result := Result + Colon;
  end;
  Result := Result + Space + GetVersionInfo;
end;

function GetVersionInfo: string;
{ ---------------------------------------------------------
Extracts the FileVersion element of the VERSIONINFO
structure that Delphi maintains as part of a project's
options.

Results are returned as a standard string.  Failure
is reported as "".

Note that this implementation was derived from similar
code used by Delphi to validate ComCtl32.dll.  For
details, see COMCTRLS.PAS, line 3541.
-------------------------------------------------------- }
const
  NOVIDATA = '';

var
  dwInfoSize, // Size of VERSIONINFO structure
  dwVerSize, // Size of Version Info Data
  dwWnd: DWORD; // Handle for the size call.
  FI: PVSFixedFileInfo; // Delphi structure; see WINDOWS.PAS
  ptrVerBuf: Pointer; // pointer to a version buffer
  strFileName, // Name of the file to check
  strVersion: string; // Holds parsed version number
begin

  strFileName := Application.ExeName;
  dwInfoSize := getFileVersionInfoSize(PChar(strFileName), dwWnd);

  if (dwInfoSize = 0) then
    Result := NOVIDATA
  else
  begin

    getMem(ptrVerBuf, dwInfoSize);
    try

      if getFileVersionInfo(PChar(strFileName), dwWnd, dwInfoSize, ptrVerBuf) then

        if verQueryValue(ptrVerBuf, '\', Pointer(FI), dwVerSize) then

          strVersion := Format('%d.%d.%d.%d', [hiWord(FI.dwFileVersionMS), loWord(FI.dwFileVersionMS), hiWord(FI.dwFileVersionLS), loWord(FI.dwFileVersionLS)]);

    finally
      freeMem(ptrVerBuf);
    end;
  end;
  Result := strVersion;
end;

type
  TVersionInfo = record
    CompanyName: string;
    FileDescriptio: string;
    FileVersion: string;
    InternalName: string;
    LegalCopyright: string;
    LegalTrademarks: string;
    OriginalFilename: string;
    Productname: string;
    ProductVersion: string;
    Comments: string;
    Author: string;
  end;






initialization

end.
