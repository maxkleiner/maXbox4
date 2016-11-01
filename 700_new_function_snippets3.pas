{ $HDR$   on progress...}
{**********************************************************************}
{ #head:Max: MAXBOX10: 05/06/2016 18:30:49 C:\maXbox\maxbox3\maxbox3\maXbox3\examples\700_new_function_snippets3.pas 
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.softwareschule.ch                                         }
{**********************************************************************}
{}
{ $Log:  10063: IdAntiFreeze.pas #sign:Max: MAXBOX10: 05/06/2016 18:30:49 
{
{   Rev 1.0    2002.11.12 10:29:54 PM  czhower
        1.1    2016 tester for maXbox
        1.2    2016 add classes 
        1.3.   2016 code snippets database to check, test & teach
               http://snippets.delphidabbler.com/#
        1.4    add {$I ..\maxbox3\examples\700_function_snippets3.inc} 
//      1.5    buftohex and hextobuf - getExeType
//}
unit CodeSnippetsDB_Freeze4;


//{$I ..\maxbox3\examples\700_function_snippets3.inc} 


{$DEFINE MSWINDOWS}

{
NOTE - This unit must NOT appear in any Indy uses clauses. This is a ONE way relationship
and is linked in IF the user uses this component. This is done to preserve the isolation from the
massive FORMS unit.
}

interface

//{$I ..\maxbox3\examples\700_function_snippets3.inc} 


{uses
  Classes,
  IdAntiFreezeBase,
  IdBaseComponent;    }
{Directive needed for C++Builder HPP and OBJ files for this that will force it
to be statically compiled into the code}

//{$I IdCompilerDefines.inc}

type
  TExeType = (
    etUnknown,  // unknown file kind: not an executable
    etError,    // error file kind: used for files that don't exist
    etDOS,      // DOS executable
    etExe32,    // 32 bit executable
    etExe16,    // 16 bit executable
    etDLL32,    // 32 bit DLL
    etDLL16,    // 16 bit DLL
    etVXD,      // virtual device driver
    etExe64,    // 64 bit executable
    etDLL64,    // 64 bit DLL
    etROM       // ROM image (PE format)
  );

{$IFDEF MSWINDOWS}

//{$HPPEMIT '#pragma link "IdAntiFreeze.obj"'}    {Do not Localize}

{$ENDIF}

{$IFDEF LINUX}

//{$HPPEMIT '#pragma link "IdAntiFreeze.o"'}    {Do not Localize}

{$ENDIF}
//type
  //TIdAntiFreeze = class(TIdAntiFreezeBase)
  //public
    procedure Process; //override;
  //end;

  var ApplicationHasPriority: boolean;
      GAntiFreeze: TIdAntiFreezeBase; // = nil;

implementation

 //&&fileexists

{$I ..\maxbox3\examples\700_function_snippets3.inc} 


(*uses
{$IFDEF LINUX}
  QForms;
{$ENDIF}
{$IFDEF MSWINDOWS}
  Forms,
  Messages,
  Windows;
{$ENDIF}
  *)
{$IFDEF LINUX}
procedure TIdAntiFreeze.Process;
begin
  //TODO: Handle ApplicationHasPriority
  Application.ProcessMessages;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
procedure Process;
var
  Msg: TMsg;
begin
  if ApplicationHasPriority then begin
    Application.ProcessMessages;
  end else begin
    // This guarantees it will not ever call Application.Idle
    if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then begin
      Application.HandleMessage;
    end;
  end;
end;

{class} function TIdAntiFreezeBase_ShouldUse: boolean;
begin
  // InMainThread - Only process if calling client is in the main thread
  Result := (GAntiFreeze <> nil) and InMainThread;
  if Result then begin
    Result := GAntiFreeze.Active;
  end;
end;

    //AppendByteArray
procedure AppendByteArray(var B1: TBytes; const B2: array of Byte);
var
  OldB1Len: Integer;
begin
  if Length(B2) = 0 then
    Exit;
  OldB1Len := Length(B1);
  SetLength(B1, OldB1Len + Length(B2));
  MoveByte(B2[0], B1[OldB1Len], Length(B2));
end;

{procedure ArrayToStringList(const Strings: array of string;
  const SL: TStrings);
var
  Idx: Integer; // loops thru each string in array
begin
  SL.Clear;
  for Idx := 0 to Pred(Length(Strings)) do
    SL.Add(Strings[Idx]);
end;}

function ByteArraysEqual(const B1, B2: array of Byte): Boolean;
var
  I: Integer;
begin
  Result := Length(B1) = Length(B2);
  if Result then begin
    for I := 0 to High(B1) do begin
      if B1[I] <> B2[I] then
      begin
        Result := False;
        Exit;
      end;
    end;
  end;
end;


function ByteArraysSameStart(const B1, B2: array of Byte; const Count: Integer):
  Boolean;
var
  I: Integer;
begin
  Assert(Count > 0, 'Count must be >= 1');
  Result := False;
  if (Length(B1) < Count) or (Length(B2) < Count) then
    Exit;
  for I := 0 to Pred(Count) do
    if B1[I] <> B2[I] then
      Exit;
  Result := True;
end;

function ConcatByteArrays(const B1, B2: array of Byte): TBytes;
begin
  Result := CloneByteArray(B1);  //internal
  AppendByteArray(Result, B2);
end;

function LastIndexOfByte(const B: Byte; const A: array of Byte): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Pred(Length(A)) downto 0 do begin
    if A[I] = B then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function PopByteArray(var A: TBytes): Byte;
begin
  Assert(Length(A) > 0, 'A must be a non-empty array');
  Result := A[Pred(Length(A))];
  SetLength(A, Length(A) - 1);
end;

procedure PushByteArray(const B: Byte; var A: TBytes);
begin
  SetLength(A, Length(A) + 1);
  A[Pred(Length(A))] := B;
end;

(*function StringListToArray(const SL: TStrings): {Types.}TStringDynArray;
var
  Idx: Integer; // loops thru each string in SL
begin
  SetLength(Result, SL.Count);
  for Idx := 0 to Pred(SL.Count) do
    Result[Idx] := SL[Idx];
end;*)

procedure UnShiftByteArray(const B: Byte; var A: TBytes);
begin
  SetLength(A, Length(A) + 1);
  MoveByte(A[0], A[1], Length(A) - 1);
  A[0] := B;
end;

//------------------------------array end---------------------------------------

const
  SHIL_LARGE = $00;       // Image size 32x32px unless user specifies large
                          // icons when size is 48x48 px.
  SHIL_SMALL = $01;       // Image size 16x16px, but can be customized by user.
  SHIL_EXTRALARGE = $02;  // Shell standard extra-large icon size. Typically
                          // 48x48, but can be customized by the user.
  SHIL_SYSSMALL = $03;    // Image size as returned from GetSystemMetrics called
                          // with SM_CXSMICON and SM_CYSMICON.
  SHIL_JUMBO = $04;       // Windows Vista and later. Image size normally
                          // 256x256px.
                          
//-------------------------------------------------------------------------------              

//---------------------------------date & time--------------------------------            
function AddDays(const DateTime: TDateTime; const Days: Integer): TDateTime;
begin
  Result := DateTime + Days;
end;

//Gets the bias of the local time zone relative to UTC (GMT), adjusted for daylight saving or standard time as appropriate.
function AdjustedTimeZoneBias: Integer;
var
  TZI: {Windows.}TTimeZoneInformation;  // info about time zone
begin
  Result := 0;  // keeps compiler quiet
  case {Windows.}GetTimeZoneInformation(TZI) of
    TIME_ZONE_ID_INVALID: RaiseLastOSError;    //sysutils
    TIME_ZONE_ID_STANDARD: Result := TZI.Bias + TZI.StandardBias;
    TIME_ZONE_ID_DAYLIGHT: Result := TZI.Bias + TZI.DaylightBias;
    TIME_ZONE_ID_UNKNOWN: Result := TZI.Bias;
  end;
end;

function DateDay(const ADate: TDateTime): Word;
var
  Year, Month: Word;  // unused dummy values required by DecodeDate
begin
  {SysUtils.}DecodeDate(ADate, Year, Month, Result);
end;

//Returns the last day of the month containing the given date.
 function DateMonthEnd(const DT: TDateTime): TDateTime;
var
  Day, Month, Year: Word;
  LastDay: Byte;
begin
  {SysUtils.}DecodeDate(DT, Year, Month, Day);
  LastDay := DaysInMonth(DT);
  Result := {SysUtils.}EncodeDate(Year, Month, LastDay);
end;

function DateQuarter(const D: TDateTime): Byte;
var
  Year, Month, Day: Word; // year, month and date components of D
begin
  DecodeDate(D, Year, Month, Day);
  Result := 4 - ((12 - Month) div 3);
end;

const
  cUnixStartDate {: TDateTime} = 25569.0; // 1970/01/01
 
 function DateTimeToUnixDate(const ADate: TDateTime): Longint;
//const
  //cUnixStartDate: TDateTime = 25569.0; // 1970/01/01
begin
  Result := Round((ADate - cUnixStartDate) * 86400);
end;

function DateTimeToWinFileTime(DT: TDateTime): TFileTime;
var
  ST: {Windows.}TSystemTime;
begin
  DateTimeToSystemTime(DT, ST);
  {SysUtils.}Win32Check(SystemTimeToFileTime(ST, Result));
end;

function DateYear(const ADate: TDateTime): Word;
var
  Month, Day: Word;  // unused dummy values required by DecodeDate
begin
  DecodeDate(ADate, Result, Month, Day);
end;

function DiffDays(const DT1, DT2: TDateTime): Integer;
begin
  Result := Trunc(DT1 - DT2);
  //DaysPerMonth
end;


const   cMonthFeb = 2;            // month number of February
  cDaysInLeapYearFeb = 29;  // number of days in February in leap year

function DateMonth(const ADate: TDateTime): Word;
var
  Year, Day: Word;  // unused dummy values required by DecodeDate
begin
  DecodeDate(ADate, Year, Result, Day);
end;

function DaysInMonthX(const ADateTime: TDateTime): Byte;
//const
  //cDaysPerMonth: array[1..12] of Byte =  // array of days in months
   // (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var
  Month: Word;  // month component of specified date
begin
  Month := DateMonth(ADateTime);
  Result := DaysinMonth(Month);
  //if (Month = cMonthFeb) and IsLeapYear(ADateTime) then
    //Result := cDaysInLeapYearFeb;
end;

  
  function  SystemTimeToTzSpecificLocalTime(lpTimeZoneInformation : integer {PTimeZoneInformation}; var lpUniversalTime, lpLocalTime : TSystemTime): bool;
     external 'SystemTimeToTzSpecificLocalTime@kernel32.dll stdcall';
  
 // lpTimeZoneInformation : PTimeZoneInformation; var lpUniversalTime, lpLocalTime : TSystemTime) : BOOL');

function GMTToLocalTimeX(GMTTime: TDateTime): TDateTime;
var
  GMTST: TSystemTime;
  LocalST: TSystemTime;
begin
  DateTimeToSystemTime(GMTTime, GMTST);
  Win32Check(
    SystemTimeToTzSpecificLocalTime(
      0, GMTST, LocalST
    )
  );
  Result := SystemTimeToDateTime(LocalST);
end;

const LOCALE_ITIME = 1;

function Is24HourTimeFormat: Boolean;
var
  DefaultLCID: LCID;  // thread's default locale
begin
  DefaultLCID := {Windows.}GetThreadLocale;
  Result := 0 <> {SysUtils.}StrToIntDef(
    GetLocaleStr(DefaultLCID, LOCALE_ITIME, '0'),
    0
  );
end;

function IsValidTime(const TimeString: string): Boolean;
var
  DT: TDateTime; // unused date time value
begin
  Result := {SysUtils.}TryStrToTime(TimeString, DT);
end;

const
//{$ENDIF}
  sFmt = '%d Days %d Hours %d Minutes';
const
  aHoursPerDay = 24;

function MinsToStr(AMinutes: Cardinal): string;
//{$IFNDEF FPC}
//resourcestring
//{$ELSE}
var
  Days, Hours, Minutes: Cardinal;
begin
  Hours := AMinutes div 60;
  Minutes := AMinutes mod 60;
  Days := Hours div HoursPerDay;
  Hours := Hours mod HoursPerDay;
  Result := {SysUtils.}Format(sFmt, [Days, Hours, Minutes]);
end;

 function NowGMT: TDateTime;
var
  ST: TSystemTime;  // current system time
begin
  // This Windows API function gets system time in UTC/GMT
  GetSystemTime(ST);
  Result := {SysUtils.}SystemTimeToDateTime(ST);
end;

const
  RFC1123Pattern = 'ddd, dd mmm yyyy HH'':''nn'':''ss ''GMT''';

function RFC1123DateGMT(const DT: TDateTime): string;
begin
  Result := {SysUtils.}FormatDateTime(RFC1123Pattern, DT);
end;

{Returns the RFC 2822 representation of the date (in local time) specified in the LocalTime parameter. The IsDST parameter indicates whether LocalTime is in daylight saving time or not.}

function RFC2822Date(const LocalDate: TDateTime; const IsDST: Boolean): string;
//const
  // Days of week and months of year: must be in English for RFC882
  //Days: array[1..7] of string = (
    //'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
  //);
  //Months: array[1..12] of string = (
    //'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    //'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  //);
var
  Day, Month, Year: Word;             // parts of LocalDate
  TZ : TIME_ZONE_INFORMATION; // time zone information
  Bias: Integer;                      // bias in seconds
  BiasTime: TDateTime;                // bias in hrs / mins to display
  GMTOffset: string;                  // bias as offset from GMT
begin
  // get year, month and day from date
  DecodeDate(LocalDate, Year, Month, Day);
  // compute GMT Offset bias
  GetTimeZoneInformation(TZ);
  Bias := TZ.Bias;
  if IsDST then
    Bias := Bias + TZ.DaylightBias
  else
    Bias := Bias + TZ.StandardBias;
  BiasTime := EncodeTime(AbsInt(Bias div 60), AbsInt(Bias mod 60), 0, 0);
  if Bias < 0 then
    GMTOffset := '-' + FormatDateTime('hhnn', BiasTime)
  else
    GMTOffset := '+' + FormatDateTime('hhnn', BiasTime);
  // build final string
  Result := getlongdaynames{Days}[DayOfWeek(LocalDate)] + ', '
    + IntToStr(Day) + ' '
    + getshortMonthnames[Month] + ' '
    + IntToStr(Year) + ' '
    + FormatDateTime('hh:nn:ss', LocalDate) + ' '
    + GMTOffset;
end;

function SQLDate2(const Date: TDateTime): string;
begin
  Result := FormatDateTime('yyyy"-"mm"-"dd', Date);
end;

function SQLDateToDateTime(const SQLDate: string): TDateTime;
begin
  Result := {SysUtils.}EncodeDate(
    StrToInt(Copy(SQLDate, 1, 4)),
    StrToInt(Copy(SQLDate, 6, 2)),
    StrToInt(Copy(SQLDate, 9, 2))
  );
end;

function TimeZoneBias: Integer;
var
  TZI: TTimeZoneInformation; // info about time zone
begin
  if GetTimeZoneInformation(TZI) = TIME_ZONE_ID_INVALID then
    {SysUtils.}RaiseLastOSError;
  Result := TZI.Bias
end;

function getstringofArray(ar: array of char): string;
begin
  //writeln(itoa(length(ar)))
  setlength(ar,length(ar))
  //writeln(ar[2])
  result:= '';
  for it:= 0 to length(ar)-1 do
    result:= result+ ar[it]
 end;   
  
  
  {type
 TIME_ZONE_INFORMATION = record
    Bias: Longint;
    StandardName: array[0..31] of WCHAR;
    StandardDate: TSystemTime;
    StandardBias: Longint;
    DaylightName: array[0..31] of WCHAR;
    DaylightDate: TSystemTime;
    DaylightBias: Longint;
  end;}

function TimeZoneName2: string;
var
  TZI: {Windows.}TTimeZoneInformation;  // info about time zone
begin
  case GetTimeZoneInformation(TZI) of
    {}TIME_ZONE_ID_INVALID: {SysUtils.}RaiseLastOSError;
    //TIME_ZONE_ID_STANDARD: Result := getstringofarray(TZI.StandardName);
    //TIME_ZONE_ID_DAYLIGHT: Result := getstringofarray(TZI.DaylightName);
    TIME_ZONE_ID_UNKNOWN: Result := '';
  end;
end;


function UnixDateToDateTime(const USec: Longint): TDateTime;
//const
  //cUnixStartDate: TDateTime = 25569.0; // 1970/01/01
begin
  Result := (Usec / 86400) + cUnixStartDate;
end;

function WesternEaster(const Year: Word): TDateTime;
var
  A, B, C, D, E, F, G, H, I, K, L, M, P : Integer;
  Day, Month: Word;
begin
  Assert(Year >= 1583, 'wrong year');
  A := Year mod 19;
  B := Year div 100;
  C := Year mod 100;
  D := B div 4;
  E := B mod 4;
  F := (B + 8) div 25;
  G := (B - F + 1) div 3;
  H := (19 * A + B - D - G + 15) mod 30;
  I := C div 4;
  K := C mod 4;
  L := (32 + 2 * E + 2 * I - H - K) mod 7;
  M := (A + 11 * H + 22 * L) div 451;
  P := (H + L - 7 * M + 114);
  Month := P div 31;
  Day := (P mod 31) + 1;
  Result := {SysUtils.}EncodeDate(Year, Month, Day);
end;

function WinFileTimeToDateTime(FT: TFileTime): TDateTime;
var
  SysTime: TSystemTime; // stores date/time in system time format
begin
  // Convert file time to system time, raising exception on error
  {SysUtils.}Win32Check({Windows.}FileTimeToSystemTime(FT, SysTime));
  // Convert system time to Delphi date time, raising excpetion on error
  Result := SystemTimeToDateTime(SysTime);
end;

type LongRec = record
        Hi: Word;
        Lo: Word;
       Bytes: array [0..3] of Byte;
end;

 var alongrec: LongRec;

function WinFileTimeToDOSFileTime(FT: TFileTime): Longrec;
var hi, lo: word;
begin
  Win32Check(
    FileTimeToDosDateTime(
    //  FT, {SysUtils.}LongRec(Result).Hi, {SysUtils.}LongRec(Result).Lo
      //FT, {SysUtils.}Hi, Lo )
      FT, {SysUtils.}alongrec.Hi, alongrec.Lo )
 
  );
  result:= alongrec; //hi+lo;
end;

function WinFileTimeToStr(FT: TFileTime): string;
begin
  Result := DateTimeToStr(WinFileTimeToDateTime(FT));
end;

//-----------------------------------date & time--------------------------

//Drive Management;

function CurentDrive: Char;
var
  Dir: string; // current drive as string
begin
  GetDir(0, Dir);
  Result := Dir[1];
end;

  function  mySetVolumeLabel(pathname, volname: pchar): boolean;
     external 'SetVolumeLabelA@kernel32.dll stdcall';
 //If the function succeeds, the return value is nonzero. 

function SetVolumeName(const ADrive, AName: string): Boolean;
begin
  Result := {Windows.}mySetVolumeLabel(PChar(ADrive), PChar(AName));
end;

function DeleteVolumeName(ADrive: string): Boolean;
begin
  Result := {Windows.}mySetVolumeLabel(PChar(ADrive), '');
end;

function DriveDisplayName(const Drive: string): string;
var
  FI: {ShellAPI.}TSHFileInfo; // info about drive
begin
  if SHGetFileInfo(
    PChar(Drive), 0, FI, SizeOf(FI), SHGFI_DISPLAYNAME) = 0 then
    RaiseLastOSError;
  Result :=  getstringofarray(FI.szDisplayName)
  //FI.szDisplayName[1];
end;

procedure DriveDisplayNames(const List: TStrings);
var
  Drives: TStringList;  // list of drives
  Idx: Integer;                 // loops thru drives
begin
  // Get list of drives
  Drives := TStringList.Create;
  try
    ListDrives(Drives);  //internal
    // Loop thru drive list getting drive info
    for Idx := 0 to Pred(Drives.Count) do
      List.Add(DriveDisplayName(Drives[Idx]));
  finally
    Drives.Free;
  end;
end;

function GetDriveNumber(const Drive: string): Integer;
var
  DriveLetter: Char;  // drive letter
begin
  Result := -1;
  if Drive <> '' then
  begin
    DriveLetter := UpCase(Drive[1]);
    if IsCharInSet(DriveLetter, LETTERSET2) then
      Result := Ord(DriveLetter) - Ord('A');
  end;
end;

function DriveTypeFromPath(const Path: string): Integer;
var
  Drive: string;  // the drive name
begin
  Drive := ExtractFileDrive(Path) + '\';
  Result := Integer(GetDriveType(PChar(Drive)));
end;

function IsValidDrive(const Drive: string): Boolean;
begin
  Result := DriveTypeFromPath(Drive) <> 1;
end;

//------------------------------------------------------------------
//----------------Encoding----------------------------------------

{Checks if file the named by FileName is a valid ASCII text file. BytesToCheck determines the number of bytes of the file that are to be checked. Specify 0 (the default) to check the whole file. The file is read in chunks of BufSize bytes. If this parameter is omitted, the buffer size defaults to 8Kb.}

function IsASCIIFile(const FileName: string; BytesToCheck: Int64 {0};
  BufSize: Integer {= 8*1024}): Boolean;
var
  Stm: TStream;
begin
  Stm := TFileStream.Create(
    FileName, fmOpenRead or fmShareDenyNone);
  try
    Result := IsASCIIStream(Stm, BytesToCheck, BufSize);
  finally
    Stm.Free;
  end;
end;

function IsASCIIText(const Text: UnicodeString): Boolean;
begin
  //Result := EncodingSupportsString(Text, SysUtils.TEncoding.ASCII);
end;

function IsUTF7StreamX(const Stm: TStream): Boolean;
begin
  Result := StreamHasWatermark(Stm, [$2B, $2F, $76, $38])
    or StreamHasWatermark(Stm, [$2B, $2F, $76, $39])
    or StreamHasWatermark(Stm, [$2B, $2F, $76, $2B])
    or StreamHasWatermark(Stm, [$2B, $2F, $76, $2F]);
end;

function IsUTF7File(const FileName: string): Boolean;
var
  Stm: TStream;
begin
  Stm := TFileStream.Create(
    FileName, fmOpenRead or fmShareDenyNone);
  try
    Result := IsUTF7StreamX(Stm);
  finally
    Stm.Free;
  end;
end;

function IsUTF8Stream(const Stm: TStream): Boolean;
begin
  Result := StreamHasWatermark(Stm, [$EF, $BB, $BF]);
end;

function IsUTF8File(const FileName: string): Boolean;
var
  Stm: TStream;
begin
  Stm := TFileStream.Create(
    FileName, fmOpenRead or fmShareDenyNone);
  try
    Result := IsUTF8Stream(Stm);
  finally
    Stm.Free;
  end;
end;

function FileHasWatermark(const FileName: string;
  const Watermark: array of Byte; const Offset: Integer { = 0}): Boolean;
  //overload;
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(
    FileName, fmOpenRead or fmShareDenyNone);
  try
    FS.Position := Offset;
    Result := StreamHasWatermark(FS, Watermark);
  finally
    FS.Free;
  end;
end;

function DOSToUnixPath(const PathName: string): string;
begin
  Result := {SysUtils.}StringReplace(PathName, '\', '/', [rfReplaceAll]);
end;

 function HasVerInfo(const FileName: string): Boolean;
var
  Dummy: Cardinal;  // dummy variable required by API function
begin
  // API function returns size of ver info: 0 if none
  //Result := {Windows.}GetFileVersionInfoSize(PChar(FileName), Dummy) > 0;
end;

function IsSystemFile(const FileSpec: string): Boolean;
var
  Attr: Integer;  // file's attributes
begin
  Attr := {SysUtils.}FileGetAttr(FileSpec);
  Result := (Attr <> -1) and IsFlagSet(Attr, faSysFile);
end;

const
  OneKB = 1024;         // 1 KB
  OneMB = OneKB * 1024; // 1 MB


function FileSizeString(const Filename: string): string;
var
  Value: Extended;      // size of file
begin
  Value := SizeOfFile64(Filename);
  if Value < 0 then
    Result := ''
  else if Value < OneKB then
    Result := FormatFloat('#,##0 "bytes"', Value)
  else if Value < OneMB then
    Result := FormatFloat('#,##0.0 "KB"', Value / OneKB)
  else
    Result := FormatFloat('#,##0.0 "MB"', Value / OneMB)
end;

function DirToPath(const Dir: string): string;
begin
  if (Dir <> '') and (Dir[Length(Dir)] <> '\') then
    Result := Dir + '\'
  else
    Result := Dir;
end;

function TouchFile(const FileName: string): Boolean;
var
  FileH: Integer; // handle of file
begin
  // Assume failure
  Result := False;
  // Try to open file: bail out if can't open
  FileH := FileOpen(
    FileName, fmOpenWrite or fmShareDenyWrite);
  if FileH = -1 then
    Exit;
  try
    // Set date to current date and time: return true if succeed
    if FileSetDate2(
      FileH, DateTimeToFileDate(Now())) = 0 then
      Result := True;
  finally
    // Close the file
    FileClose(FileH);
  end;
end;


const
  cWinHeaderOffset = $3C; // offset of "pointer" to windows header in file
  cNEAppTypeOffset = $0D; // offset in NE windows header app type field
  cDOSMagic = $5A4D;      // magic number identifying a DOS executable
  cNEMagic = $454E;       // magic number identifying a NE executable (Win 16)
  cPEMagic = $4550;       // magic nunber identifying a PE executable (Win 32)
  cLEMagic = $454C;       // magic number identifying a Virtual Device Driver
  cNEDLLFlag = $80;       // flag in NE app type field indicating a DLL
  cPEDLLFlag = $2000;     // flag in PE Characteristics field indicating s DLL
  cPE32Magic = $10B;      // magic number identifying 32 bit PE executable
  cPE64Magic = $20B;      // magic number identifying 64 bit executable
  cPEROMMagic = $107;     // magic number identifying ROM image


(*function ExeType(const FileName: string): TExeType;
var
  FS: TFileStream;              // stream onto executable file
  WinMagic: Word;                       // word that contains PE/NE/LE magic #s
  HdrOffset: LongInt;                   // offset of windows header in exec file
  //DOSHeader: IMAGE_DOS_HEADER;  // DOS header record
  DOSHeader: longint;
  PEFileHdr: {Windows.}IMAGE_FILE_HEADER; // PE file header record
  PEOptHdrMagic: Word;                  // PE "optional" header magic #
  AppFlagsNE: Byte;                     // byte defining DLLs in NE format
  DOSFileSize: Integer;                 // size of DOS file
  IsPEDLL: Boolean;                     // whether PE file is DLL
begin
  try
    // Open stream onto file: raises exception if can't be read
    FS := TFileStream.Create(
      FileName, fmOpenRead + fmShareDenyNone
    );
    try
      // Assume unkown file
      Result := etUnknown;
      // Any exec file is at least size of DOS header long
      if FS.Size < SizeOf(DOSHeader) then
        Exit;
      //FS.ReadBuffer(DOSHeader, SizeOf(DOSHeader));
      // DOS files begin with "MZ"
      //if DOSHeader.e_magic <> cDOSMagic then
        //Exit;
      // DOS files have length >= size indicated at offset $02 and $04
      // (offset $02 indicates length of file mod 512 and offset $04 indicates
      // no. of 512 pages in file)
      if (DOSHeader.e_cblp = 0) then
        DOSFileSize := DOSHeader.e_cp * 512
      else
        DOSFileSize := (DOSHeader.e_cp - 1) * 512 + DOSHeader.e_cblp;
      if FS.Size <  DOSFileSize then
        Exit;
      // DOS file relocation offset must be within DOS file size.
      if DOSHeader.e_lfarlc > DOSFileSize then
        Exit;
      // We know we have an executable file: assume its a DOS program
      Result := etDOS;
      // Try to find offset of Windows program header
      if FS.Size <= cWinHeaderOffset + SizeOf(LongInt) then
        // file too small for windows header "pointer": it's a DOS file
        Exit;
      // read it
      FS.Position := cWinHeaderOffset;
      FS.ReadBuffer(HdrOffset, SizeOf(LongInt));
      // Now try to read first word of Windows program header
      if FS.Size <= HdrOffset + SizeOf(Word) then
        // file too small to contain header: it's a DOS file
        Exit;
      FS.Position := HdrOffset;
      // This word should be NE, PE or LE per file type: check which
      FS.ReadBuffer(WinMagic, SizeOf(Word));
      case WinMagic of
        cPEMagic:
        begin
          // 'PE' signature followed by to 0 bytes
          FS.ReadBuffer(WinMagic, SizeOf(Word));
          if WinMagic <> 0 then
            Exit;
          // 32 or 64 bit Windows application: now check whether app or DLL
          // by reading file header record and checking Characteristics field
          if FS.Size < HdrOffset + SizeOf(LongWord) + SizeOf(PEFileHdr)
            + SizeOf(PEOptHdrMagic) then
            Exit;
          FS.Position := HdrOffset + SizeOf(LongWord);
          FS.ReadBuffer(PEFileHdr, SizeOf(PEFileHdr));
          IsPEDLL := (PEFileHdr.Characteristics and cPEDLLFlag)
            = cPEDLLFlag;
          // check if 32 bit, 64 bit (or ROM) by reading Word value following
          // file header (actually this is first field of "optional" PE header)
          // read magic number at start of "optional" PE header that follows
          FS.ReadBuffer(PEOptHdrMagic, SizeOf(PEOptHdrMagic));
          case PEOptHdrMagic of
            cPE32Magic:
              if IsPEDLL then
                Result := etDLL32
              else
                Result := etExe32;
            cPE64Magic:
              if IsPEDLL then
                Result := etDLL64
              else
                Result := etExe64;
            cPEROMMagic:
              Result := etROM;
            else
              Result := etUnknown;  // unknown PE magic number
          end;
        end;
        cNEMagic:
        begin
          // We have 16 bit Windows executable: check whether app or DLL
          if FS.Size <= HdrOffset + cNEAppTypeOffset + SizeOf(AppFlagsNE) then
            // app flags field would be beyond EOF: assume DOS
            Exit;
          // read app flags byte
          FS.Position := HdrOffset + cNEAppTypeOffset;
          FS.ReadBuffer(AppFlagsNE, SizeOf(AppFlagsNE));
          if (AppFlagsNE and cNEDLLFlag) = cNEDLLFlag then
            // app flags indicate DLL
            Result := etDLL16
          else
            // app flags indicate program
            Result := etExe16;
        end;
        cLEMagic:
          // We have a Virtual Device Driver
          Result := etVXD;
        else
          // DOS application
          {Do nothing - DOS result already set};
      end;
    finally
      FS.Free;
    end;
  except
    // Exception raised in function => error result
    Result := etError;
  end;
end;
  *)
  
  Function IsURLShortcut(const ShortcutFile: string): Boolean;
var
  Ini: {IniFiles.}TIniFile; // used to read ini files
begin
  // File must exist
  if FileExists(ShortcutFile) then begin
    // Open ini file and check value exists
    Ini := TIniFile.Create(ShortcutFile);
    try
      Result := Ini.SectionExists('InternetShortcut')
        and Ini.ValueExists('InternetShortcut', 'URL')
        and (Ini.ReadString('InternetShortcut', 'URL', '') <> '');
    finally
      Ini.Free;
    end;
  end
  else
    Result := False;
end;

function URLFromShortcut(const Shortcut: string): string;
var
  Ini: {IniFiles.}TIniFile; // object used to read shortcut file
begin
  // Return URL item from [InternetShortcut] section of shortcut file
  Ini := TIniFile.Create(Shortcut);
  try
    try
      Result := Ini.ReadString('InternetShortcut', 'URL', '');
    except;
      // We return '' on error
      Result := '';
    end;
  finally
    Ini.Free;
  end;
end;



function CreateDisplayDC: HDC;
//var cola: TColorAdjustment;
begin
  Result := {Windows.}CreateDC('DISPLAY', 'nil', 'nil', 0);
  //GetColorAdjustment
  //SetStretchBltMode
end;

function  MyDeleteDC(adc: HDC): Longint;
   external 'DeleteDC@gdi32.dll stdcall';


function MaxWidthOfStrings(const Strings: TStrings;
  const Font: TFont): Integer;
var
  TextW: Integer;           // stores width of each string in list
  Idx: Integer;             // loops thru all string in list
  Canvas: TCanvas; // canvas used to measure text
begin
  Assert(Assigned(Font), 'font');
  Assert(Assigned(Strings), 'strings');
  // Intialise
  Result := 0;
  if Strings.Count = 0 then
    Exit;
  // Create canvas used to measure text
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := CreateDisplayDC;
    try
      Canvas.Font := Font;
      // Measure each string's width and record widest in pixels
      for Idx := 0 to Strings.Count - 1 do begin
        TextW := Canvas.TextWidth(Strings[Idx]);
        if TextW > Result then
          Result := TextW;
      end;
    finally
      // Tidy up
      myDeleteDC(Canvas.Handle);
      Canvas.Handle := 0;
    end;
  finally
    Canvas.Free;
  end;
end;

procedure ParseStr(const StrToParse: string; const Delimiter: Char; 
  const Words: TStringList);
var
  TmpInStr: string;
begin
  TmpInStr := StrToParse;
  Words.Clear;
  if Length(TmpInStr) > 0 then
  begin
    while Pos(Delimiter, TmpInStr) > 0 do begin
      Words.Append(Copy(TmpInStr, 1, Pos(Delimiter, TmpInStr) - 1));
      Delete(TmpInStr, 1, Pos(Delimiter, TmpInStr));
    end;
    Words.Append(TmpInStr);
  end;
end;

procedure BitmapToMetafile(const Bmp: TBitmap;
  const EMF: TMetafile);
var
  MetaCanvas: TMetafileCanvas; // canvas for drawing on metafile
begin
  EMF.Height := Bmp.Height;
  EMF.Width := Bmp.Width;
  MetaCanvas := TMetafileCanvas.Create(EMF, 0);
  try
    MetaCanvas.Draw(0, 0, Bmp);
  finally
    MetaCanvas.Free;
  end;
end;

procedure GraphicToBitmap(const Src: TGraphic;
  const Dest: TBitmap; const TransparentColor: TColor);
begin
  // Do nothing if either source or destination are nil
  if not Assigned(Src) or not Assigned(Dest) then
    Exit;
  // Size the bitmap
  Dest.Width := Src.Width;
  Dest.Height := Src.Height;
  if Src.Transparent then begin
    // Source graphic is transparent, make bitmap behave transparently
    Dest.Transparent := True;
    if (TransparentColor <> {Graphics.}clNone) then begin
      // Set destination as transparent using required colour key
      Dest.TransparentColor := TransparentColor;
      Dest.TransparentMode := {Graphics.}tmFixed;
      // Set background colour of bitmap to transparent colour
      Dest.Canvas.Brush.Color := TransparentColor;
    end
    else
      // No transparent colour: set transparency to automatic
      Dest.TransparentMode := {Graphics.}tmAuto;
  end;
  // Clear bitmap to required background colour and draw bitmap
  Dest.Canvas.FillRect(Rect(0, 0, Dest.Width, Dest.Height));
  Dest.Canvas.Draw(0, 0, Src);
end;


function CloneGraphicAsBitmap(const Src: TGraphic;
  const PixelFmt: TPixelFormat;
  const TransparentColor: TColor): TBitmap;
begin
  // Create bitmap with required pixel format
  Result := TBitmap.Create;
  if PixelFmt <> {Graphics.}pfCustom then
    Result.PixelFormat := PixelFmt
  else if Src is TBitmap then
    Result.PixelFormat := (Src as {Graphics.}TBitmap).PixelFormat;
  // Copy the graphic object
  GraphicToBitmap(Src, Result, TransparentColor);
end;


function GetIconHotspot(const Icon: TIcon): TPoint;
var
  IconInfo: {Windows.}TIconInfo;  // receives info about icon
begin
  if not GetIconInfo(Icon.Handle, IconInfo) then begin
    //raise;
     Exception.Create('Can''t get icon information');
   end;  
  Result.X := IconInfo.xHotspot;
  Result.Y := IconInfo.yHotspot;
end;

function Clamp(const Value, RangeLo, RangeHi: Integer ): Integer;
begin
  Assert(RangeLo <= RangeHi, 'not in range^');
  if Value < RangeLo then
    Result := RangeLo
  else if Value > RangeHi then
    Result := RangeHi
  else
    Result := Value;
end;

function StringExtent(const S: string;
  const Font: TFont): TSize;
var
  Canvas: TCanvas; // canvas used to measure text extent
begin
  Assert(Assigned(Font),'not assigned');
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := CreateDisplayDC;
    try
      Canvas.Font := Font;
      Result := Canvas.TextExtent(S);
    finally
      myDeleteDC(Canvas.Handle);
      Canvas.Handle := 0;
    end;
  finally
    Canvas.Free;
  end;
end;

type
  TGreyScaleMethod = (gsmLightness, gsmAverage, gsmLuminosity);
  
  function ByteToHex(const B: Byte): string;
begin
  Result := IntToHex(B, 2 * SizeOf(B));
end;


function StripHexPrefix(const HexStr: string): string;
begin
  if Pos('$', HexStr) = 1 then
    Result := Copy(HexStr, 2, Length(HexStr) - 1)
  else if Pos('0x', {SysUtils.}LowerCase(HexStr)) = 1 then
    Result := Copy(HexStr, 3, Length(HexStr) - 2)
  else
    Result := HexStr;
end;

const HexDisplayPrefix = '$';

function AddHexPrefix(const HexStr: string): string;
begin
  Result := {SysUtils.}HexDisplayPrefix + StripHexPrefix(HexStr);
end;

function TryHexToInt(const HexStr: string; out Value: Integer): Boolean;
var
  E: Integer; // error code
begin
  Val(AddHexPrefix(HexStr), Value, E);
  Result := E = 0;
end;

function GetTotalPhysMemory: Int64;
var
  MemoryEx: {Windows.}TMemoryStatus;
begin
  begin
    MemoryEx.dwLength := SizeOf(memoryEx);
    GlobalMemoryStatus(MemoryEx);
    Result := MemoryEx.dwTotalPhys;
  end;
end;

function ScreenResolution: {Types.}TSize;
var
  DC: HDC;
  HWND_DESKTOP: HWND;
begin
  DC := GetDC(HWND_DESKTOP);
   //GetDesktopWindow
  try
    Result.cx := GetDeviceCaps(DC, HORZRES);
    Result.cy := GetDeviceCaps(DC, VERTRES);
  finally
    ReleaseDC(0, DC);
  end;
end;

//*******************************3Math******************************33

function AllDigitsSame(N: Int64): Boolean;
var
  D: byte; //0..9;  // sample digit from N
begin
  //D:= numbers;
  N := AbsInt(N);                  
  D := N mod 10;
  Result := False;
  while N > 0 do begin
    if N mod 10 <> D then
      Exit;
    N := N div 10;
  end;
  Result := True;
end;

function DigitCount2(const AValue: Int64): Integer;
begin
  if AValue <> 0 then
    Result := {Math.}Floor({Math.}Log10(Abs(AValue))) + 1
  else
    Result := 1;
end;

function DigitCountR(AValue: Int64): Integer;
begin
  if AValue mod 10 = AValue then
    Result := 1
  else
    Result := 1 + DigitCountR(AValue div 10)
end;

function GCD2(const A, B: Integer): Integer;
begin
  if B = 0 then
    Result := AbsInt(A)
  else
    Result := GCD2(B, A mod B);
end;

function IsPrime(N: Integer): Boolean;
var
  Max: Integer;     // max divisor
  Divisor: Integer; // different divisors to try
begin
  Result := False;
  if N < 2 then
    Exit; // not a prime
  Result := True;
  if N = 2 then
    Exit; // 2 is prime
  if N mod 2 = 0 then
    Result := False; // even numbers > 2 are not prime
  Max := Trunc(Sqrt(N)) + 1;
  Divisor := 3;
  // test odd numbers
  while (Max > Divisor) and Result do begin
    if (N mod Divisor) = 0 then
      Result := False;
    Inc1(Divisor, 2); // next odd number
  end;
end;

function IsPrime2(Val: Integer): Boolean;
var
  X: Integer; // index
begin
  Result := (Val > 1);
  if Result then begin
    for X := (Val div 2) downto 2 do begin
      Result := Result and ((Val mod X) <> 0);
      if not Result then
        Break;
    end;
  end;
end;

function IsRectNormal(const R: TRect): Boolean;
begin
  Result := (R.Left <= R.Right) and (R.Top <= R.Bottom);
end;

function GCD(A, B: Integer): Integer;
var
  Temp: Integer; // used in swapping A & B
begin
  while B <> 0 do begin
    Temp := B;
    B := A mod Temp;
    A := Temp;
  end;
  Result := AbsInt(A);
end;

function LCD(A, B: Integer): Integer;
begin
  Result := AbsInt((A * B)) div GCD(A, B);
end;

function MaxOfArray(const A: array of Double): Double; //overload;
var
  Idx: Integer;
begin
  Assert(Length(A) > 0,'must > 0');
  Result := A[Low(A)];
  for Idx := Succ(Low(A)) to High(A) do
    if A[Idx] > Result then
      Result := A[Idx];
end;

function MinOfArray(const A: array of Double): Double; //overload;
var
  Idx: Integer;
begin
  Assert(Length(A) > 0,'must > 0');
  Result := A[Low(A)];
  for Idx := Succ(Low(A)) to High(A) do
    if A[Idx] < Result then
      Result := A[Idx];
end;

function MoveRectToOrigin(const R: TRect): {Types.}TRect;
begin
  Result := R;
  {Types.}OffsetRect(Result, -R.Left, -R.Top);
end;

function ReverseNumberR(AValue: Int64): Int64;
begin
  Assert(AValue >= 0,'must > 0');
  if AValue mod 10 = AValue then
    Result := AValue
  else
    Result := ((AValue mod 10) * Trunc(IntPower(10, Trunc(Log10(AValue)))))
      + ReverseNumberR(AValue div 10)
end;

function SAR(Value: LongInt; Shift: Byte): LongInt;
begin
  Shift := Shift and 31;
  if Shift = 0 then
  begin
    Result := Value;
    Exit;
  end;
  Result := LongInt(LongWord(Value) shr Shift);
  if Value < 0 then
    Result := LongInt(LongWord(Result) or ($FFFFFFFF shl (32 - Shift)));
end;

{Simplifies the fraction with numerator Num and denominator Denom to its lowest terms. If the fraction is already in its lowest terms then Num and Denom are left unchanged.}

procedure SimplifyFraction(var Num, Denom: Int64);
var
  CommonFactor: Int64;  // greatest common factor of Num and Denom
begin
  Assert(Denom <> 0,'must > 0');
  CommonFactor := AbsInt(GCD(Num, Denom));
  Num := Num div CommonFactor;
  Denom := Denom div CommonFactor;
end;

const
  sErrorMsg = 'StretchRect(): Rectangle bottom or right out of bounds.';

function StretchRect(const R: TRect; const ScalingX, ScalingY: Double):
  TRect; //overload;
{$IFDEF FPC}
//const
{$ELSE}
//resourcestring
{$ENDIF}
var
  NewW, NewH: Double;  // stretched width and height of rectangle
  alongInt: Longint;
begin
  NewW := (R.Right - R.Left) * ScalingX;
  NewH := (R.Bottom - R.Top) * ScalingY;
  if (Abs(NewW + R.Left) > High(aLongInt))
    or (Abs(NewH + R.Top) > High(aLongint)) then
    raise; //{SysUtils.}EOverflow.Create(sErrorMsg);
  Result := Bounds(R.Left, R.Top, Round(NewW), Round(NewH));
end;


function ZoomRatio(const DestWidth, DestHeight, SrcWidth, SrcHeight: Integer):
  Double; //overload;
begin
  Result := MinFloat(DestWidth / SrcWidth, DestHeight / SrcHeight);
end;

function ZoomRatio2(const DestSize, SrcSize: TSize): Double; //overload;
begin
  Result := ZoomRatio(DestSize.cx, DestSize.cy, SrcSize.cx, SrcSize.cy);
end;

function ExtractURIFragment(const URI: string): string;
var
  FragmentStart: Integer;
begin
  FragmentStart := {SysUtils.}AnsiPos('#', URI);
  if FragmentStart > 0 then
    Result := Copy(URI, FragmentStart + 1, Length(URI) - FragmentStart)
  else
    Result := '';
end;

procedure RegValueList(const ARootKey: HKEY; const ASubKey: string;
  const AValueList: TStrings);
begin
  with TRegistry.Create do
    try
      RootKey := ARootKey;
      if OpenKeyReadOnly(ASubKey) then
        GetValueNames(AValueList)
      else
        AValueList.Clear;
    finally
      Free;
    end;
end;

//*******************************3String Mangement************************

function AnsiStringToCharSet(const S: RawByteString): TCharSet;
var
  Idx: Integer;  // indexes characters of S
begin
  Result := [];
  for Idx := 1 to Length(S) do
    //Include(Result, S[Idx]);
    //result:=  result+Tcharset(S[idx])
    result:= StrToCharSet(s[idx])
end;

function ChangeChar(const AString: string; ASearch, AReplace: Char): string;
var
  I: integer; // loops thru all chars of string
begin
  Result := AString;
  if Result = '' then
    Exit;
  for I := 1 to Length(Result) do
    if Result[I] = ASearch then
      Result[I] := AReplace;
end;


function IsASCIIDigit(const Ch: Char): Boolean;
begin
  Result := (Ord(Ch) >= Ord('0')) and (Ord(Ch) <= Ord('9'));
end;

 // Gets a chunk of all numeric or all non-numeric text from Source starting at
  // Pos and stores in Dest. Pos is moved past the end of the chunk.
  procedure GetChunk(Source: string; var Pos: Integer; out Dest: string);
  var
    IsNum: Boolean; // flags if string chunk is numeric
    DP: Integer;    // cursor into Source string
  begin
    if Pos > Length(Source) then
      Dest := ''
    else begin
      IsNum := IsASCIIDigit(Source[Pos]);
      DP := 0;
      while (Pos + DP <= Length(Source))
        and (IsASCIIDigit(Source[Pos + DP]) = IsNum) do
        Inc(DP);
      Dest := Copy(Source, Pos, DP);
      Pos := Pos + DP;
    end;
  end;
 

{Compares two strings, S1 and S2, treating any whole, non-negative, numbers embedded in the strings as numbers rather than text. Text comparisons are case sensitive. Returns a negative value if S1 < S2, a positve value if S1 > S2 or 0 if S1 and S2 are equal.}

function CompareNumberStr(const S1, S2: string): Integer;
 
var
  Chunk1, Chunk2: string; // chunks of text from S1 and S2 respectively
  Pos1, Pos2: Integer;    // current position in S1 and S2 respectively
begin
  if (S1 = '') or (S2 = '')
    or (IsASCIIDigit(S1[1]) xor IsASCIIDigit(S2[1])) then
    // Either S1 or S2 is empty OR one starts with a digit and the other starts
    // with a non-digit. In either case we just need a normal string compare.
    Result := {SysUtils.}CompareStr(S1, S2)
  else begin
    // Either both S1 and S2 start with digits OR both start with non-digits.
    // Therefore the strings may (or do) contain numbers, so we need special
    // processing.
    Pos1 := 1;
    Pos2 := 1;
    Result := 0;
    repeat
      // Get the first digit only or non-digit only chunks of the strings. If
      // both strings are non empty they will either both be digit strings or
      // both be non-digit strings
      GetChunk(S1, Pos1, Chunk1);
      GetChunk(S2, Pos2, Chunk2);
      if Chunk1 = '' then begin
        if Chunk2 <> '' then
          Result := -1;
      end
      else if Chunk2 = '' then
        Result := 1
      else if IsASCIIDigit(Chunk1[1]) then
        // These chunks are both numeric: compare numbers.
        Result := StrToInt(Chunk1) - StrToInt(Chunk2)
      else
        // These chunks are both non-numeric: compare text
        Result := CompareStr(Chunk1, Chunk2);
      // If existing chunks compare same, we move on to compare next chunks,
      // providing we have not run out of text.
    until (Result <> 0) or ((Chunk1 = '') and (Chunk2 = ''));
  end;
end;

function CountDelims(const S, Delims: string): Integer;
var
  Idx: Integer; //loops thru all characters in string
begin
  Result := 0;
  for Idx := 1 to Length(S) do
    if {SysUtils.}IsDelimiter(Delims, S, Idx) then
      Inc(Result);
end;

//{$I ..\maxbox3\examples\700_function_snippets3.inc} 



function VariantIsObject(const V: Variant): Boolean;
begin
  Result := {Variants.}VarIsType(V, varDispatch)
    or {Variants.}VarIsType(V, varUnknown);
    //CutWordByIndex(4,sr,[])
end;

function IsUnicodeStream(const Stm: TStream): Boolean;
var
  StmPos: LongInt;      // current position in stream
  BOM: Word;            // Unicode byte order mark
begin
  // Record current location in stream
  StmPos := Stm.Position;
  // Check if stream large enough to contain BOM (empty text file contains only
  // the BOM)
  if StmPos <= Stm.Size - SizeOf(BOM) then
  begin
    // Read first word and check if it is the unicode marker
    //Stm.ReadBuffer(BOM, SizeOf(BOM));
    Result := (BOM = $FEFF);
    // Restore stream positions
    Stm.Position := StmPos;
  end
  else
    // Stream too small: can't be unicode
    Result := False;
end;

function UnicodeFileToWideString(const FileName: string): WideString;
var
  FS: {Classes.}TFileStream;  // Stream onto file
begin
  FS := TFileStream.Create(
    FileName, fmOpenRead or fmShareDenyNone);
  try
    //Result := UnicodeStreamToWideString(FS);
  finally
    FS.Free;
  end;
end;

function TaskbarHandle: THandle;
begin
  Result := FindWindow('Shell_TrayWnd', 'nil');
end;

function TrayHandle: THandle;
begin
  Result := FindWindowEx(TaskbarHandle, 0, 'TrayNotifyWnd', 'nil');
end;

//const
  //cWdwCurrentVer = '\Software\Microsoft\Windows\CurrentVersion';

function GetCurrentVersionRegStr(const ValName: string): string;
begin
  Result := GetRegistryString(
    HKEY_LOCAL_MACHINE,
    cWdwCurrentVer,
    ValName
  );
end;

function ProgramFilesFolder: string;
begin
  Result := GetCurrentVersionRegStr('ProgramFilesDir');
end;

function GetRegistryString2(const RootKey: HKEY;
  const SubKey, Name: string): string;
var
  Reg: TRegistry;          // registry access object
  ValueInfo: TRegDataInfo; // info about registry value
begin
  Result := '';
  // Open registry at required root key
  Reg := TRegistry.Create;
  try
    Reg.RootKey := RootKey;
    // Open registry key and check value exists
    if Reg.OpenKeyReadOnly(SubKey)
      and Reg.ValueExists(Name) then begin
      // Check if registry value is string or integer
      Reg.GetDataInfo(Name, ValueInfo);
      case ValueInfo.RegData of
        rdString, rdExpandString:
          // string value: just return it
          Result := Reg.ReadString(Name);
        rdInteger:
          // integer value: convert to string
          Result := {SysUtils.}IntToStr(Reg.ReadInteger(Name));
        else
          // unsupported value: raise exception
          raise; //Exception.Create(
            //'Unsupported registry type'
          //);
      end;
    end;
  finally
    // Close registry
    Reg.Free;
  end;
end;


//const
  //WS_EX_LAYERED = $00080000;  // layered window style

function WindowSupportsLayers(const HWnd: HWND): Boolean;
begin
  Result := IsFlagSet(
    {Windows.}GetWindowLong(HWnd, GWL_EXSTYLE), WS_EX_LAYERED
  );
end;

function IsIntResource(const ResID: PChar): Boolean;
begin
  //Result := (HiWord(DWORD(ResID)) = 0);
  Result := (HiWord(strtoint(ResID)) = 0);

end;

function ResourceIDToStr(const ResID: PChar): string;
begin
  if IsIntResource(ResID) then
    Result := '#' + IntToStr(strtoint(ResID))
  else
    Result := string(ResID);
end;

function ResourceExists(const Module: HMODULE;
  const ResName, ResType: PChar): Boolean;
begin
  Result := {Windows.}FindResource(Module, ResName, ResType) <> 0;
end;

function TreeNodeChildCount(ParentNode: TTreeNode): Integer;
var
  ChildNode: {ComCtrls.}TTreeNode;  // references each child node
begin
  Result := 0;
  if ParentNode = nil then
    Exit;
  ChildNode := ParentNode.GetFirstChild;
  while (ChildNode <> nil) do begin
    Inc(Result);
    ChildNode := ChildNode.GetNextSibling;
  end;
end;


const
  // Registry keys for Win 9x/NT
  {cRegKey: array[Boolean] of string = (
    'Software\Microsoft\Windows\CurrentVersion',
    'Software\Microsoft\Windows NT\CurrentVersion'
  );}
  // Registry key name
  cName = 'ProductID';
  //cRegKey = 'Software\Microsoft\Windows\CurrentVersion';
  cRegKey = 'Software\Microsoft\Windows NT\CurrentVersion';

function WindowsProductID: string;
begin
  Result := GetRegistryString(
    HKEY_LOCAL_MACHINE, cRegKey{[IsWinNT]}, cName
  );
end;

function IsIEInstalled: Boolean;
begin
  Result := ProgIDInstalled('InternetExplorer.Application');
end;

function GetFileTypeX(const FilePath: string): string;
var
  aInfo: {ShellAPI.}TSHFileInfo;
begin
  if {ShellAPI.}SHGetFileInfo(
      PChar(FilePath),
      0,
      aInfo,
      SizeOf(aInfo),
      {ShellAPI.}SHGFI_TYPENAME
    ) <> 0 then
    Result := aInfo.szTypeName[1]
  else
    Result := ''; // result if file or folder does not exist
end;

procedure RemoveDuplicateStrings2(const Strings: TStrings);
var
  TempStrings: TStringList;
  Cnt: Integer;
begin
  if Strings.Count <= 1 then
    Exit;
  TempStrings := TStringList.Create;
  try
    TempStrings.Sorted := True;
    TempStrings.Duplicates := dupIgnore;
    for Cnt := 0 to Strings.Count - 1 do
      TempStrings.Add(Strings[Cnt]);
    Strings.Assign(TempStrings);
  finally
    TempStrings.Free;
  end;
end;

function EllipsifyText(const AsPath: Boolean; const Text: string;
  const Canvas: TCanvas; const MaxWidth: Integer ): string;
var
  TempPChar: PChar; // temp buffer to hold text
  TempRect: TRect;  // temp rectangle hold max width of text
  Params: UINT;     // flags passed to DrawTextEx API function
begin
  // Alocate mem for PChar
  //GetMem(TempPChar, (Length(Text) + 1) * SizeOf(Char));
  try
    // Copy Text into PChar
    TempPChar := StrPCopy(TempPChar, Text);
    // Create Rectangle to Store PChar
    TempRect := Rect(0, 0, MaxWidth, High(params));
    // Set Params depending wether it's a path or not
    if AsPath then
      Params := {Windows.}DT_PATH_ELLIPSIS
    else
      Params := {Windows.}DT_END_ELLIPSIS;
    // Tell it to Modify the PChar, and do not draw to the canvas
    Params := Params + DT_MODIFYSTRING + DT_CALCRECT;
    // Ellipsify the string based on availble space to draw in
    DrawTextEx(Canvas.Handle, TempPChar, -1, TempRect, Params, 0);
    // Copy the modified PChar into the result
    Result := StrPas(TempPChar);
  finally
    // Free Memory from PChar
    //FreeMem(TempPChar, (Length(Text) + 1) * SizeOf(Char));
  end;
end;

function CloneByteArrayX(const B: array of Byte): TBytes;
begin
  SetLength(Result, Length(B));
  if Length(B) > 0 then
    //Move(B[0], Result[0], Length(B));
end;

function IndexOfByte(const B: Byte; const A: array of Byte): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(Length(A)) do begin
    if A[I] = B then begin
      Result := I;
      Exit;
    end;
  end;
end;

function IsUTF7Stream(const Stm: TStream): Boolean;
begin
  Result := StreamHasWatermark(Stm, [$2B, $2F, $76, $38])
    or StreamHasWatermark(Stm, [$2B, $2F, $76, $39])
    or StreamHasWatermark(Stm, [$2B, $2F, $76, $2B])
    or StreamHasWatermark(Stm, [$2B, $2F, $76, $2F]);
end;

function IsUTF16Stream(const Stm: TStream): Boolean;
begin
  Result := StreamHasWatermark(Stm, [$FF, $FE])  // UTF-16 LE
    or StreamHasWatermark(Stm, [$FE, $FF])       // UTF-16 BE
end;

const
  aRFC1123Pattern = 'ddd, dd mmm yyyy HH'':''nn'':''ss ''GMT''';

function aRFC1123DateGMT(const DT: TDateTime): string;
//const
  //RFC1123Pattern = 'ddd, dd mmm yyyy HH'':''nn'':''ss ''GMT''';
begin
  Result := {SysUtils.}FormatDateTime(RFC1123Pattern, DT);
end;

function CreateDisplayDC2: HDC;
begin
  //Result := {Windows.}CreateDC('DISPLAY', 0, 0, 0);
end;

procedure GraphicToBitmapX(const Src: TGraphic;
  const Dest: TBitmap; const TransparentColor: TColor);
begin
  // Do nothing if either source or destination are nil
  if not Assigned(Src) or not Assigned(Dest) then
    Exit;
  // Size the bitmap
  Dest.Width := Src.Width;
  Dest.Height := Src.Height;
  if Src.Transparent then
  begin
    // Source graphic is transparent, make bitmap behave transparently
    Dest.Transparent := True;
    if (TransparentColor <> clNone) then
    begin
      // Set destination as transparent using required colour key
      Dest.TransparentColor := TransparentColor;
      Dest.TransparentMode := {Graphics.}tmFixed;
      // Set background colour of bitmap to transparent colour
      Dest.Canvas.Brush.Color := TransparentColor;
    end
    else
      // No transparent colour: set transparency to automatic
      Dest.TransparentMode := {Graphics.}tmAuto;
  end;
  // Clear bitmap to required background colour and draw bitmap
  Dest.Canvas.FillRect(Rect(0, 0, Dest.Width, Dest.Height));
  Dest.Canvas.Draw(0, 0, Src);
end;


(*function SetTransparencyLevel(const HWnd: Windows.HWND;
  const Level: Byte): Boolean;
const
  LWA_ALPHA = $00000002;  // flag for API call
type
  // prototype for Windows SetLayeredWindowAttributes API function
  TSetLayeredWindowAttributes = function(HWnd: Windows.HWND;
    crKey: Windows.COLORREF; bAlpha: Byte; dwFlags: Windows.DWORD
  ): Boolean; stdcall;
var
  SetLayeredWindowAttributes:
    TSetLayeredWindowAttributes;  // reference to function in user32.dll
  User32: Windows.HMODULE;        // handle of user32.dll
begin
  Result := False;
  if (HWnd = 0) or not WindowSupportsLayers(HWnd) then
    Exit;
  User32 := Windows.GetModuleHandle('User32.dll');
  if User32 <> 0 then
  begin
    @SetLayeredWindowAttributes := GetProcAddress(
      User32, 'SetLayeredWindowAttributes'
    );
    if Assigned(SetLayeredWindowAttributes) then
      Result := SetLayeredWindowAttributes(HWnd, 0, Level, LWA_ALPHA);
  end;
end;*)


(*function IsEqualResID(const R1, R2: PChar): Boolean;
begin
  if IsIntResource(R1) then
    // R1 is ordinal: R2 must also be ordinal with same value in lo word
    Result := IsIntResource(R2) and
      (Windows.LoWord(Windows.DWORD(R1)) = Windows.LoWord(Windows.DWORD(R2)))
  else
    // R1 is string pointer: R2 must be same string (ignoring case)
    Result := not IsIntResource(R2) and (SysUtils.StrIComp(R1, R2) = 0);
end;*)

(*function GetGenericFileType(const FileNameOrExt: string): string;
var
  Info: ShellAPI.TSHFileInfo;
begin
  if ShellAPI.SHGetFileInfo(
      PChar(FileNameOrExt),
      Windows.FILE_ATTRIBUTE_NORMAL,
      Info,
      SizeOf(Info),
      ShellAPI.SHGFI_TYPENAME or ShellAPI.SHGFI_USEFILEATTRIBUTES
    ) <> 0 then
    Result := Info.szTypeName
  else
    Result := ''; // should never be reached
end;*)

(*function GetFileType2(const FilePath: string): string;
var
  Info: ShellAPI.TSHFileInfo;
begin
  if ShellAPI.SHGetFileInfo(
      PChar(FilePath),
      0,
      Info,
      SizeOf(Info),
      ShellAPI.SHGFI_TYPENAME
    ) <> 0 then
    Result := Info.szTypeName
  else
    Result := ''; // result if file or folder does not exist
end;*)


(*procedure ShowShellPropertiesDlg(const APath: string);
var
  AExecInfo: ShellAPI.TShellExecuteinfo;  // info passed to ShellExecuteEx
begin
  FillChar(AExecInfo, SizeOf(AExecInfo), 0);
  AExecInfo.cbSize := SizeOf(AExecInfo);
  AExecInfo.lpFile := PChar(APath);
  AExecInfo.lpVerb := 'properties';
  AExecInfo.fMask := ShellAPI.SEE_MASK_INVOKEIDLIST;
  ShellAPI.ShellExecuteEx(@AExecInfo);
end;*)


(*function EllipsifyText(const AsPath: Boolean; const Text: string;
  const Canvas: Graphics.TCanvas; const MaxWidth: Integer ): string;
var
  TempPChar: PChar; // temp buffer to hold text
  TempRect: TRect;  // temp rectangle hold max width of text
  Params: UINT;     // flags passed to DrawTextEx API function
begin
  // Alocate mem for PChar
  GetMem(TempPChar, (Length(Text) + 1) * SizeOf(Char));
  try
    // Copy Text into PChar
    TempPChar := SysUtils.StrPCopy(TempPChar, Text);
    // Create Rectangle to Store PChar
    TempRect := Classes.Rect(0, 0, MaxWidth, High(Integer));
    // Set Params depending wether it's a path or not
    if AsPath then
      Params := Windows.DT_PATH_ELLIPSIS
    else
      Params := Windows.DT_END_ELLIPSIS;
    // Tell it to Modify the PChar, and do not draw to the canvas
    Params := Params + Windows.DT_MODIFYSTRING + Windows.DT_CALCRECT;
    // Ellipsify the string based on availble space to draw in
    Windows.DrawTextEx(Canvas.Handle, TempPChar, -1, TempRect, Params, nil);
    // Copy the modified PChar into the result
    Result := SysUtils.StrPas(TempPChar);
  finally
    // Free Memory from PChar
    FreeMem(TempPChar, (Length(Text) + 1) * SizeOf(Char));
  end;
end;*)

(*function CloneByteArray(const B: array of Byte): TBytes;
begin
  SetLength(Result, Length(B));
  if Length(B) > 0 then
    Move(B[0], Result[0], Length(B));
end;

procedure AppendByteArray(var B1: TBytes; const B2: array of Byte);
var
  OldB1Len: Integer;
begin
  if Length(B2) = 0 then
    Exit;
  OldB1Len := Length(B1);
  SetLength(B1, OldB1Len + Length(B2));
  Move(B2[0], B1[OldB1Len], Length(B2));
end;*)

(*function IsUnicodeStream(const Stm: Classes.TStream): Boolean;
var
  StmPos: LongInt;      // current position in stream
  BOM: Word;            // Unicode byte order mark
begin
  // Record current location in stream
  StmPos := Stm.Position;
  // Check if stream large enough to contain BOM (empty text file contains only
  // the BOM)
  if StmPos <= Stm.Size - SizeOf(BOM) then
  begin
    // Read first word and check if it is the unicode marker
    Stm.ReadBuffer(BOM, SizeOf(BOM));
    Result := (BOM = $FEFF);
    // Restore stream positions
    Stm.Position := StmPos;
  end
  else
    // Stream too small: can't be unicode
    Result := False;
end;

function FileHasWatermark(const FileName: string;
  const Watermark: array of Byte; const Offset: Integer = 0): Boolean;
  overload;
var
  FS: Classes.TFileStream;
begin
  FS := Classes.TFileStream.Create(
    FileName, SysUtils.fmOpenRead or SysUtils.fmShareDenyNone
  );
  try
    FS.Position := Offset;
    Result := StreamHasWatermark(FS, Watermark);
  finally
    FS.Free;
  end;
end;

function FileHasWatermarkAnsi(const FileName: string;
  const Watermark: AnsiString; const Offset: Integer = 0): Boolean;
  overload;
var
  Bytes: array of Byte;
  I: Integer;
begin
  SetLength(Bytes, Length(Watermark));
  for I := 1 to Length(Watermark) do
    Bytes[I - 1] := Ord(Watermark[I]);
  Result := FileHasWatermark(FileName, Bytes, Offset);
end;

function IsASCIIStream(const Stm: Classes.TStream; Count: Int64 = 0;
  BufSize: Integer = 8*1024): Boolean;
var
  StmPos: Int64;        // original stream position
  Buf: array of Byte;   // stream read buffer
  BytesRead: Integer;   // number of bytes read from stream in each chunk
  I: Integer;           // loops thru each byte in read buffer
begin
  Result := False;
  StmPos := Stm.Position;
  try
    if BufSize < 1024 then
      BufSize := 1024;
    SetLength(Buf, BufSize);
    if (Count = 0) or (Count > Stm.Size) then
      Count := Stm.Size;
    while Count > 0 do
    begin
      BytesRead := Stm.Read(Pointer(Buf)^, Math.Min(Count, Length(Buf)));
      if BytesRead = 0 then
        Exit;
      Dec(Count, BytesRead);
      for I := 0 to Pred(BytesRead) do
        if Buf[I] > $7F then
          Exit;
    end;
    Result := True;
  finally
    Stm.Position := StmPos;
  end;
end;

function IsASCIIFile(const FileName: string; BytesToCheck: Int64 = 0;
  BufSize: Integer = 8*1024): Boolean;
var
  Stm: Classes.TStream;
begin
  Stm := Classes.TFileStream.Create(
    FileName, SysUtils.fmOpenRead or SysUtils.fmShareDenyNone
  );
  try
    Result := IsASCIIStream(Stm, BytesToCheck, BufSize);
  finally
    Stm.Free;
  end;
end;

 function BytesToAnsiString(const Bytes: SysUtils.TBytes; const CodePage: Word):
  RawByteString;
begin
  SetLength(Result, Length(Bytes));
  if Length(Bytes) > 0 then
  begin
    Move(Bytes[0], Result[1], Length(Bytes));
    SetCodePage(Result, CodePage, False);
  end;
end;

function UnicodeStreamToWideString(const Stm: Classes.TStream): WideString;
var
  DataSize: LongInt;  // size of Unicode text in stream in bytes
begin
  if IsUnicodeStream(Stm) then
  begin
    // Data on stream is Unicode with BOM
    // Check remaining stream, less BOM, contains whole number of wide chars
    DataSize := Stm.Size - Stm.Position - SizeOf(Word);
    if DataSize mod SizeOf(WideChar) <> 0 then
      Classes.EStreamError.CreateFmt(
        'Remaining data in stream must be a mulitple of %d bytes',
        [SizeOf(WideChar)]
      );
    // Skip over BOM
    Stm.Position := Stm.Position + SizeOf(Word);
    // Read stream into result
    SetLength(Result, DataSize div SizeOf(WideChar));
    Stm.ReadBuffer(Windows.PByte(PWideChar(Result))^, DataSize);
  end
  else
    // Data on stream is assumed to be ANSI
    Result := StreamToString(Stm);  // automatically cast to WideString
end;

procedure WideStringToUnicodeStream(const Str: WideString;
  const Stm: Classes.TStream);
var
  BOM: Word;  // Unicode byte order mark
begin
  BOM := $FEFF;
  Stm.WriteBuffer(BOM, SizeOf(BOM));
  Stm.WriteBuffer(Pointer(Str)^, SizeOf(WideChar) * Length(Str));
end;

procedure GraphicToBitmap(const Src: Graphics.TGraphic;
  const Dest: Graphics.TBitmap; const TransparentColor: Graphics.TColor);
begin
  // Do nothing if either source or destination are nil
  if not Assigned(Src) or not Assigned(Dest) then
    Exit;
  // Size the bitmap
  Dest.Width := Src.Width;
  Dest.Height := Src.Height;
  if Src.Transparent then
  begin
    // Source graphic is transparent, make bitmap behave transparently
    Dest.Transparent := True;
    if (TransparentColor <> Graphics.clNone) then
    begin
      // Set destination as transparent using required colour key
      Dest.TransparentColor := TransparentColor;
      Dest.TransparentMode := Graphics.tmFixed;
      // Set background colour of bitmap to transparent colour
      Dest.Canvas.Brush.Color := TransparentColor;
    end
    else
      // No transparent colour: set transparency to automatic
      Dest.TransparentMode := Graphics.tmAuto;
  end;
  // Clear bitmap to required background colour and draw bitmap
  Dest.Canvas.FillRect(Classes.Rect(0, 0, Dest.Width, Dest.Height));
  Dest.Canvas.Draw(0, 0, Src);
end;

*)


{$ENDIF}

const
  grOnes = 0;        // group < 1,000
  grThousands = 1;   // 1,000 <= group < 1,000,000
  plOnes = 0;        // "ones" place within group
  plTens = 1;        // "tens" place within group
  plHundreds = 2;    // "hnudreds place within group
//{$IFDEF FPC}
//const
//{$ELSE}
//resourcestring
//{$ENDIF}
  // various number items
  sHundred = 'hundred';
  sOneHundred = 'one hundred';
  sOneThousand = 'one thousand';
  sMinus = 'minus';


function IntToNumberText(const Value: Integer): string;
var
  // map of number names
  cNStr: array[ 0..27 ] of string;
  // array of "group" names
  cGroupStrings: array[ 1..4 ] of string;
  astlog: TStGenerallog;
  astrand: TStRandomBase;
  
var
  NumDigits: Integer;     // number of digits in value
  Group: Integer;         // index of group of 1000s
  Place: Integer;         // place of current digit within group
  Digit: Integer;         // current digit
  CurPos: Integer;        // position in ValString of current digit
  SilentGroup: Boolean;   // whether group is rendered
  aValString: string;      // string representation of Value
begin

  cNStr[0]:='zero'; cNStr[1]:='one'; cNStr[2]:= 'two';  cNStr[3]:='three'; cNStr[4]:='four';
  cNStr[5]:='five'; cNStr[6]:='six'; cNStr[7]:='seven'; cNStr[8]:='eight';cNStr[9]:= 'nine';
  cNStr[10]:='ten'; cNStr[11]:='eleven'; cNStr[12]:='twelve'; cNStr[13]:='thirteen';
  cNStr[14]:='fourteen';cNStr[15]:='fifteen'; cNStr[16]:='sixteen'; cNStr[17]:='seventeen';
  cNStr[18]:='eighteen';cNStr[19]:='nineteen'; cNStr[20]:='twenty'; cNStr[21]:='thirty';
  cNStr[22]:='forty';cNStr[23]:='fifty'; cNStr[24]:='sixty'; cNStr[25]:='seventy';
  cNStr[26]:='eighty';cNStr[27]:='ninety';  

  (*
 = (  , 'one', 'two', 'three', 'four',
    'five', 'six', 'seven', 'eight', 'nine',
    'ten', 'eleven', 'twelve', 'thirteen', 'fourteen',
    'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen',
    'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy',
    'eighty', 'ninety'
  );*)
  
  cGroupStrings[1]:= 'thousand';  cGroupStrings[2]:= 'million';
  cGroupStrings[3]:= 'billion';  cGroupStrings[4]:= 'trillion'; 
  //cGroupStrings[0]:= 'thousand';
   (*= (
    , 'million', 'billion', 'trillion'
  ); *)
  
    // Special case for zero
  if Value = 0 then begin
    Result := cNStr[0];
    Exit;
  end;
  aValString := {SysUtils.}IntToStr(Absint(Value));
  NumDigits := Length(aValString);
  if Value > 0 then
    Result := ''
  else
    Result := sMinus;
 
  Group := (NumDigits - 1) div 3;
  Place := (NumDigits + 2) mod 3;
  CurPos := 1;
 
  while Group >= grOnes do begin
    SilentGroup := True;
    while Place >= plOnes do begin
      Digit := Ord(aValString[CurPos]) - Ord('0');
      Inc(CurPos);
      if Digit = 0 then begin
        Dec(Place);
        Continue;
      end;
 
      case Place of
        plHundreds:
        begin
          if Digit > 1 then
            Result := Result + ' ' + cNStr[Digit] + ' ' + sHundred
          else
            Result := Result + ' ' + sOneHundred;
          SilentGroup := False;
        end;
        plTens:
        begin
          if Digit = 1 then begin
            // Special case 10 thru 19
            Place := plOnes;
            Digit := Ord(aValString[CurPos]) - Ord('0');
            Inc(CurPos);
            Result := Result + ' ' + cNStr[10 + Digit];
          end else
            Result := Result + ' ' + cNStr[20 + Digit - 2];
          SilentGroup := False;
        end;
        plOnes:
        begin
          if (Group = grThousands) and (Digit = 1) then
            Result := Result + ' ' + sOneThousand
          else
          begin
            Result := Result + ' ' + cNStr[Digit];
            SilentGroup := False;
          end;
        end;
      end;
     Dec(Place);
    end;
    // handle thousands, millions and billions here
    if (Group > grOnes) and not SilentGroup then
      Result := Result + ' ' + cGroupStrings[Group];
    Place := plHundreds;
    Dec(Group);
  end;
  if Result[1] = ' ' then
    Delete(Result, 1, 1);
end;

procedure HEXtoBUFStr;
begin
 writeln(CompressWhiteSpace('An intro    duction in  coding with maXbox'))
   
   writeln('StrbuftoHEX_1: '+buftohex('An intro    duction in  coding with maXbox',length('An intro    duction in  coding with maXbox')))
   
   sr:= 'An intro    duction in  coding with maXbox';
   writeln('StrbuftoHEX_2: '+buftohex(sr, length(sr)))
   //procedure HexToBuf(HexStr: string; var Buf: string);
   sr:= 'An intro    duction in  coding with maXbox';
   Hextobuf(buftohex(sr, length(sr)),sr);
   writeln(sr)
end;  

  var aday:TStDayType; 
     // akd: TKEditKey;
      akcommand: TKEditCommand;
      acommass: TKEditCommandAssignment;
      idbase: TIdBaseComponent;
      aspstack: TKMemoSparseStack;
      abyte: TBytes;
      aflt: TFileTime;
      srslist: TStrings;

begin  //main
  ApplicationHasPriority:= true;
  Process;
  
  if Not FileExists(exepath+'examples\700_function_snippets3.inc') then
    showmessageBig('{$I ..\maxbox3\examples\700_function_snippets3.inc} not exists!'); 
  //{$I ..\maxbox3\examples\700_function_snippets3.inc} 

  //class procedure DoProcess(const AIdle: boolean = true; const AOverride: boolean = false);
  with TIdAntiFreeze.create(self) do begin
    writeln(botostr(shoulduse));
    //DoProcess(true, false)
    active:= false;
    writeln('id vers: '+version)
    Free;
    //TIdBaseComponent().Free
  end; 
  
  with TIdThreadSafeStringList.create(true) do begin
    Add('coolcode!')
    lock;
    unlock;
    Free
  end;  
  
  //TIdBaseComponent missing
  { with TIdCustomThreadComponent.create(self) do begin
    Add('coolcode!')
    lock;
    unlock;
    Free
  end;    }
  
  with TIdThreadMgr.create(self) do begin
    //getthread
    writeln(version)
    free
  end;  
 
  with TIdBasicAuthentication.create do begin
    //Add('coolcode!§')
    writeln('Authentication: '+Authentication)
    //lock;
    //unlock;
    writeln(version)
    Free
  end;   
 
  
  with TKEditKeyMapping.create do begin
    try
    EmptyMap;
    except
      writeln('Except: out of stack!')
    end  
    //Assign(TStringlist.create)
    //FindCommand  §
    //TKEditCommand(self).AddKey
   //&&key;
   //map;
  free
  end;
  
  with TKMemoDictionary.create do begin
    //EmptyMap;
    //Assign
    //FindCommand
    //TKEditCommand(self).AddKey
   //key;
   //map;
   AddItem(12,1234567{'coolcode!§})
   FindItem(12);
   writeln(itoa(items[0].value))
  free
  end;
  
  aday:= monday;   
  aday:= Wednesday;
  writeln(itoa(ord(aday)))  
  
  writeln(ProgramFilesFolder)
  writeln(itoa(hinstance))
  writeln(itoa(application.handle))
  
  writeln('WindowSupportsLayers: '+botostr(WindowSupportsLayers(hinstance)))
  
  writeln(ResourceIDToStr('3780'))
  writeln(WindowsProductID)
  writeln('IsIEInstalled '+botostr(IsIEInstalled))
  
  writeln(GetFileType2(exepath+'maxbox4.exe'))
  //TypeS('TUnitType', '( utSrc, utHead, utRes, utPrj, utOther )
  writeln(itoa(ord(GetFileTyp(exepath+'maxbox4.exe'))))
  
        //URIDecode
         //URIEncode
       //URLDecode2  
        //URLEncode2 
        
    //SetTransparencyLevel(const HWnd: HWND;
      //     const Level: Byte): Boolean;
   //IsEqualResID(const R1, R2: PChar): Boolean;         //55
   //GetGenericFileType(const FileNameOrExt: string): string;
   //GetFileType2(const FilePath: string): string;
   //ShowShellPropertiesDlg(const APath: string);
   //EllipsifyText(const AsPath: Boolean; const Text: string;
     //      const Canvas: TCanvas; const MaxWidth: Integer ): string;
   //CloneByteArray(const B: array of Byte): TBytes;       //60
   //AppendByteArray(var B1: TBytes; const B2: array of Byte);
   //IsUnicodeStream(const Stm: TStream): Boolean;
   //FileHasWatermark(const FileName: string;
     //       const Watermark: array of Byte; const Offset: Integer): Boolean;
   //FileHasWatermarkAnsi(const FileName: string;
     //        const Watermark: AnsiString; const Offset: Integer): Boolean;
   //IsASCIIStream(const Stm: TStream; Count: Int64 = 0;
     //                            BufSize: Integer = 8*1024): Boolean;
   //IsASCIIFile(const FileName: string; BytesToCheck: Int64 = 0;
     //                          BufSize: Integer = 8*1024): Boolean;      //66
    //BytesToAnsiString(const Bytes: TBytes; const CodePage: Word):
                          //            RawByteString;
   //UnicodeStreamToWideString(const Stm: TStream): WideString;
  //WideStringToUnicodeStream(const Str: WideString;
                                            ///const Stm: TStream);
   //GraphicToBitmap(const Src: TGraphic;
     //         const Dest: TBitmap; const TransparentColor: TColor);  //70

   //URIDecode(S: string; const IsQueryString: Boolean): string;
   //URIEncode(const S: string; const InQueryString: Boolean): string;
 //  URLDecode2(const S: string): string;
   //URLEncode2(const S: string; const InQueryString: Boolean): string;
   writeln('AllDigitsSame '+botostr(AllDigitsSame(777)));                                       //75
   // BytestoString
   
     //ShowShellPropertiesDlg(exepath+'maxbox4.exe') 
     
     abyte:= ConcatByteArrays([1,3,5,7],[4,6,8])
     for it:= 0 to high(abyte) do 
        write(inttostr(abyte[it]));
        
        writeln(inttostr(LastIndexOfByte(5,[1,3,5,7,6,5,9])));
        assert(LastIndexOfByte(5,[1,3,5,7,6,5,9])=5,'must be last 5')
        abyte:= [1,3,5,7,9]
        writeln(itoa(PopByteArray(abyte)))
        write(itoa(PopByteArray(abyte)))
        write(itoa(PopByteArray(abyte)))
        PushByteArray(7,abyte);
        write(itoa(PopByteArray(abyte)))
        //write(itoa(PopByteArray(abyte)))
        
        writeln(itoa(DateTimeToUnixDate(now)))
        writeln(itoa(DateTimeToUnixtime(now)))
        //writeln(itoa(DateTimeToUnixtime(now)))
       writeln(datetimetoStr(UnixDateToDateTime(DateTimeToUnixDate(now))));
        writeln(datetimetoStr(UnixtimetoDateTime(DateTimeToUnixtime(now))));
        Assert(datetimetostr(UnixtimetoDateTime(DateTimeToUnixtime(now)))=
                                        datetimetostr(Now),'must the time')
        //XRTLGetTimeZones
        //writeln('TimeZoneName '+TimeZoneName2)
   
     //   function DateTimeToWinFileTime(DT: TDateTime): TFileTime;
      aflt:= DateTimeToWinFileTime(now)  //-->: TFileTime;
      
      writeln(datetimetoStr(WinFileTimeToDateTime(aflt)))
      writeln(datetimetoStr(WinFileTimeToDateTime(DateTimeToWinFileTime(now))))
      
      //writeln(inttostr(WinFileTimeToDOSFileTime(aflt)));
      writeln(inttostr(WinFileTimeToDOSFileTime(aflt).hi));
      alongrec:= WinFileTimeToDOSFileTime(aflt);
      DosDateTimeTofileTime1(alongrec.hi,alongrec.lo,aflt);
     
      writeln('winfiletimetoStr: '+winfiletimetoStr(aflt));
    
      //DosDateTimeToDateTime(WinFileTimeToDOSFileTime(aflt));
   
   //DateTimeToUnixTime     
   
     writeln('CurentDrive: '+CurentDrive)
     PrintF('your current drive %s:\ ',[CurentDrive])
   
      writeln('DriveDisplayName:  '+DriveDisplayName('D:\'))
      
      srslist:= TStringlist.create;
      DriveDisplayNames(srslist);
      writeln(srslist.text)
      for it:= 0 to srslist.count-1 do 
         write('-'+srslist[it]);
      srslist.Free;
      
      //GetDriveNumber('D')
      
      writeln('IsASCIIFile: '+botoStr(IsASCIIFile(exepath+'maxbox4.exe',0,8*1024)))
      writeln('IsASCIIFile: '+botoStr(IsASCIIFile(exepath+'firstdemo.txt',0,8*1024)))
      
    writeln('IsUTF8File '+botoStr(IsUTF8File(exepath+'firstdemo.txt')))  
    writeln('IsUTF7File '+botoStr(IsUTF7File(exepath+'firstdemo.txt')))  
    //TEncoding
    
    writeln('FileSizeString '+FileSizeString(exepath+'maxbox4.exe'))
    
  // function TryHexToInt(const HexStr: string; out Value: Integer): Boolean;
    //it:= FF
    writeln(botoStr(TryHexToInt('$FFF',it)));
    writeln(itoa(it))
    
    //function GetTotalPhysMemory: Int64;
    writeln('GetTotalPhysMemory: '+inttostr64(GetTotalPhysMemory));
    
    {type TSize = packed record
     cx: LongInt;
     cy: LongInt;
   end;}

    writeln(itoa(ScreenResolution.cx)+'*'+itoa(ScreenResolution.cy))  //: {Types.}TSize;

    writeln('excel hex max except right')
    
    maxCalcF('180/PI')
    maxCalcF('1/PI')
    
    //DelAllStr(const Needle, Haystack: string): string;
    writeln(DelAllStr('Needle','a Needle in a  Haystack: string^'));
    
    writeln('StrTokenCount: '+itoa(StrTokenCount('a Needle^ in a^  Hay^stack: string^','^')))
    
     writeln(botostr(IsWhiteSpace(#10))) 
     
     maxcalcF('70!') 
     //1.19785716699699E100  
    
  //   procedure GetAllEnvVars(const Vars: TStrings);
   { srlist:= TStringlist.create;
    GetAllEnvVars(srlist);
    //writeln(srlist.text)
    for it:= 0 to srlist.count -1 do 
      writeln(srlist.strings[it]);
    srlist.Free;  }
     writeln('GetParentProcessID: '+itoa(GetProcessId))
     writeln('GetParentProcessID: '+itoa(GetParentProcessID(GetProcessId)))  
     writeln('GetProcessorName: '+GetProcessorName)
     writeln(' BytesToMBStr: '+BytesToMBStr(GetTotalPhysMemory,2,true));
     writeln(itoa(TaskbarHandle2)+' '+itoa(TrayHandle2))
     writeln('ProgramFilesFolder: '+ProgramFilesFolder2)
     
     writeln(IntToNumberText2(678934))
     try
       voice2(IntToNumberText(678934))
       writeln(IntToNumberText2(1678934))
       voice2(IntToNumberText(1678934))
     except
       writeln('COM Voice.Sp1 not available')
     end;
      
     
   writeln('getexeType: '+getexeType(exepath+'maxbox4.exe'))
   writeln(exeType(exepath+'maxbox4.exe'))
   AddToRecentDocs(exepath+'firstdemo.txt');
   
   HEXtoBUFStr;
   
   writeln(datetimetoStr(GMTToLocalTimeX(now)))
   
   //IsEqualResID

End.

//http://www.softwareschule.ch/download/maxbox_starter44.pdf

//https://www.metadefender.com/#!/results/file/d18f22811efc40c2825bd49d18783bce/regular

{An introduction in coding with maXbox the script engine. The tool is build on a precompiled object based scripting library.
The tool is also based on an educational program with examples and exercises (from biorhythm, form builder to how encryption and network works). Units are precompiled and objects invokable!}

{1.1 Command with Macros 
1.2 Extend with DLL
1.3 Alias Naming 
1.4 Console Capture DOS 
1.5 Byte Code Performance 
1.6 Exception Handling 
1.7 Config Ini File
1.8 The Log Files 
1.9 Use Case Model
1.10 Open Tool API
                  
All Articles of maXbox Pascal in Blaise Pascal Magazine:
- Art of coding        V 31/32
- DLL for all          V 33
- QR Code              V 34
- GEO Maps             V 35
- 3D Printing Lab      V 36
- RegEx Report REX     V 37/38
- Function Testing     V 40
- Arduino Coding       V 45/46
- Time is on my side   V 48
- Compute Big Numbers  V 52

https://plus.google.com/+MaxKleiner/posts                 
                
                
  CL.AddDelphiFunction('Function SystemTimeToTzSpecificLocalTime( lpTimeZoneInformation : PTimeZoneInformation; var lpUniversalTime, lpLocalTime : TSystemTime) : BOOL');
   CL.AddDelphiFunction('Function SetVolumeLabel( lpRootPathName : PChar; lpVolumeName : PChar) : BOOL');
             
                  
                  }
                  
                  
                  
                  