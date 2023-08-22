unit UtilsMax4;

//implemental for maXbox4 by Max1    plus IDBAse Component

interface

uses StringsW, Windows, SysUtils, Classes, Graphics, StringUtils, PsAPI, TlHelp32,
     Forms, StdCtrls;    // Forms is used for FormFade*.

const
  { for SetNtfsCompression: }
  //FSCTL_SET_COMPRESSION = $9C040;
  //COMPRESSION_FORMAT_NONE = 0;
  //COMPRESSION_FORMAT_DEFAULT = 1;
  SM_MEDIACENTER = 87; // metrics flag not defined in Windows unit
  SM_TABLETPC = 86; 
  
  var
   //Form1: TForm1;
    mCommand: string;
    mOutputs: string;


//type

// ***********************************************************
// TIdBaseComponent is the base class for all Indy components.
// ***********************************************************
type
  TIdBaseComponent = class(TComponent)
  public
    function GetVersion: string;
    property Version: string read GetVersion;
  published
  end;

  TCharSet = set of Char;
  
// NumberOfBytes should be in 0..4.
//function MaskForBytes(const NumberOfBytes: Byte): DWord;

//procedure ShowException(Message: WideString);

// note: using TForm's BorderIcons, etc. is slow (form blinks) and not reliable (for some
//       reson it causes TListView.Items to lose all associated objects and other things happen).

 function AllDigitsDifferent(N: Int64): Boolean;
 procedure DecimalToFraction(Decimal: Extended; out FractionNumerator: Extended;
           out FractionDenominator: Extended; const AccuracyFactor: Extended);
 function ColorToHTML(const Color: TColor): string;
 function DOSCommand(const CommandLine: string; const CmdShow:integer;
            const WaitUntilComplete: Boolean; const WorkingDir: string = ''): Boolean;
 function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;
 procedure CaptureConsoleOutput(DosApp : string;AMemo : TMemo); 
  function ExecuteCommandDOS(CommandLine:string):string;
 function DOSCommandRedirect(const CommandLine: string;
  const OutStream: Classes.TStream): Boolean; overload;     //8

 procedure SendKeysToWindow(const HWnd: Windows.HWND; const Text: string);
  function IsRunningOnBattery: Boolean;
  function IsHexStr(const S: string): Boolean;
  function IsCharInSet(const Ch: Char; const Chars: TCharSet): Boolean;
  function StreamHasWatermark(const Stm: Classes.TStream;
                             const Watermark: array of Byte): Boolean;
  function ReadBigEndianWord(Stm: Classes.TStream): Word;
  function DownloadURLToFile(const URL, FileName: string): Boolean;
  function ExtractURIQueryString(const URI: string): string;
  function GetBiosVendor: string;
  function GetIEVersionStr: string;         //18

  function FloatToFixed(const Value: Extended; const DecimalPlaces: Byte;
                                const SeparateThousands: Boolean): string;
  function IntToFixed(const Value: Integer;
                              const SeparateThousands: Boolean): string;
  function Int64ToFixed(const Value: Int64;
                                const SeparateThousands: Boolean): string;
  function IntToNumberText2(const Value: Integer): string;     //22
  
  function IsLibraryInstalled2(const LibFileName: string): Boolean;
  function RemainingBatteryPercent: Integer;
  procedure SetLockKeyState(KeyCode: Integer; IsOn: Boolean);
  function IsLockKeyOn(const KeyCode: Integer): Boolean;
  procedure PostKeyEx322(const Key: Word; const Shift: Classes.TShiftState;
                                const SpecialKey: Boolean = False);
  function TerminateProcessByID(ProcessID: Cardinal): Boolean;
  function GetWindowProcessName(const Wnd: Windows.HWND): string;
  function GetProcessName(const PID: Windows.DWORD): string;
  function GetWindowProcessID(const Wnd: Windows.HWND): Windows.DWORD;
  function IsAppResponding(const Wnd: Windows.HWND): Boolean;
  function IsTabletOS: Boolean;
  function ProgIDInstalled(const PID: string): Boolean;
  function GetProcessorName: string;
  function GetProcessorIdentifier: string;                   //36
  procedure EmptyKeyQueue;
  procedure TrimAppMemorySize;
  function GetEnvironmentBlockSize: Cardinal;
  function GetDefaultPrinterName: string;                    //40
  procedure ListDrives(const List: Classes.TStrings);
  procedure MultiSzToStrings(const MultiSz: PChar;
            const Strings: Classes.TStrings);
  function BrowseURL(const URL: string): Boolean;
  function IsValidURLProtocol(const URL: string): Boolean;
  function ExecAssociatedApp(const FileName: string): Boolean;   //45
  function CheckInternetConnection(AHost: PAnsiChar): Boolean;
  function MakeSafeHTMLText(TheText: string): string;
  function RemoveURIQueryString(const URI: string): string;
  function GetRegistryString(const RootKey: Windows.HKEY;
                                   const SubKey, Name: string): string;
  procedure RefreshEnvironment2(const Timeout: Cardinal = 5000);  //50
  function IsKeyPressed2(const VirtKeyCode: Integer): Boolean;
  function SizeOfFile64(const FileName: string): Int64;
  function IsHugeFile(const FileName: string): Boolean;



//var
  //UtilsLanguage:      TUtilsLanguage;
  //InputBoxesLanguage: TInputBoxesLanguage;

implementation

uses MMSystem, Math, ShellAPI, ShlObj, UrlMon, WinSock, IdGlobal, messages, registry, Printers, ActiveX;


function TIdBaseComponent.GetVersion: string;
begin
  Result := gsIdVersion;
end;


function SizeOfFile64(const FileName: string): Int64;
var
  FH: THandle;  // file handle
begin
  FH := SysUtils.FileOpen(
    FileName, SysUtils.fmOpenRead or SysUtils.fmShareDenyNone
  );
  try
    SysUtils.Int64Rec(Result).Lo := Windows.GetFileSize(
      FH, @SysUtils.Int64Rec(Result).Hi
    );
    if (SysUtils.Int64Rec(Result).Lo = $FFFFFFFF) and
      (Windows.GetLastError <> Windows.NO_ERROR) then
      Result := -1;
  finally
    SysUtils.FileClose(FH);
  end;
end;

function IsHugeFile(const FileName: string): Boolean;
var
  Size64: Int64; // file size
const
  c2Gb: Int64 = 2147483648; // 2Gb in bytes
begin
  Size64 := SizeOfFile64(FileName);
  if Size64 = -1 then
    Result := False
  else
    Result := Size64 >= c2Gb;
end;

procedure RefreshEnvironment2(const Timeout: Cardinal = 5000);
var
  {$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 23.0} // Delphi XE2
  MessageRes: Windows.DWORD_PTR;
  {$ELSE}
  MessageRes: Windows.DWORD;
  {$IFEND}
  {$ELSE}
  MessageRes: Windows.DWORD;
  {$ENDIF}
begin
  Windows.SendMessageTimeout(
    Windows.HWND_BROADCAST,
    Messages.WM_SETTINGCHANGE,
    0,
    LPARAM(PChar('Environment')),
    Windows.SMTO_ABORTIFHUNG, Timeout,
    {$IFDEF CONDITIONALEXPRESSIONS}
    {$IF CompilerVersion >= 23.0} // Delphi XE2
    @MessageRes
    {$ELSE}
    MessageRes
    {$IFEND}
    {$ELSE}
    MessageRes
    {$ENDIF}
  );
end;

function GetRegistryString(const RootKey: Windows.HKEY;
  const SubKey, Name: string): string;
var
  Reg: TRegistry;          // registry access object
  ValueInfo: Registry.TRegDataInfo; // info about registry value
begin
  Result := '';
  // Open registry at required root key
  Reg := Registry.TRegistry.Create;
  try
    Reg.RootKey := RootKey;
    // Open registry key and check value exists
    if Reg.OpenKeyReadOnly(SubKey)
      and Reg.ValueExists(Name) then
    begin
      // Check if registry value is string or integer
      Reg.GetDataInfo(Name, ValueInfo);
      case ValueInfo.RegData of
        Registry.rdString, Registry.rdExpandString:
          // string value: just return it
          Result := Reg.ReadString(Name);
        Registry.rdInteger:
          // integer value: convert to string
          Result := SysUtils.IntToStr(Reg.ReadInteger(Name));
        else
          // unsupported value: raise exception
          raise SysUtils.Exception.Create(
            'Unsupported registry type'
          );
      end;
    end;
  finally
    // Close registry
    Reg.Free;
  end;
end;

function CheckInternetConnection(AHost: PAnsiChar): Boolean;
var
  PHE: PHostEnt;
  GInitData: TWSAData;
begin
  WinSock.WSAStartup($101, GInitData);
  PHE := WinSock.GetHostByName(AHost);
  WinSock.WSACleanup;
  Result := (PHE <> nil);
end;

function ExecAssociatedApp(const FileName: string): Boolean;
begin
  Result := ShellAPI.ShellExecute(
    0,
    nil,
    PChar(FileName),
    nil,
    nil,
    Windows.SW_SHOW
  ) > 32;
end;


function MakeSafeHTMLText(TheText: string): string;
var
  Idx: Integer; // loops thru characters of TheText
  Ch: Char;     // each charactor in TheText
begin
  Result := '';
  for Idx := 1 to Length(TheText) do
  begin
    Ch := TheText[Idx];
    case Ch of
      '<': Result := Result + '&lt;';
      '>': Result := Result + '&gt;';
      '&': Result := Result + '&amp;';
      '"': Result := Result + '&quot;';
      else
      begin
        if (Ch < #32) or (Ch >= #127) then
          Result := Result + '&#' + IntToStr(Ord(Ch)) + ';'
        else
          Result := Result + Ch;
      end;
    end;
  end;
end;

function RemoveURIQueryString(const URI: string): string;
var
  QueryStart: Integer;
  FragStart: Integer;
begin
  QueryStart := SysUtils.AnsiPos('?', URI);
  if QueryStart = 0 then
  begin
    Result := URI;
    Exit;
  end;
  Result := Copy(URI, 1, QueryStart - 1);
  FragStart := SysUtils.AnsiPos('#', URI);
  if FragStart > 0 then
    Result := Result + Copy(URI, FragStart, Length(URI) - FragStart + 1);
end;

function IsValidURLProtocol(const URL: string): Boolean;
const
  Protocols: array[1..10] of string = (
    // Array of valid protocols - per RFC 1738
    'ftp://', 'http://', 'gopher://', 'mailto:', 'news:', 'nntp://',
    'telnet://', 'wais://', 'file://', 'prospero://'
  );
var
  I: Integer;   // loops thru known protocols
begin
  // Scan array of protocols checking for a match with start of given URL
  Result := False;
  for I := Low(Protocols) to High(Protocols) do
    if Pos(Protocols[I], SysUtils.LowerCase(URL)) = 1 then
    begin
      Result := True;
      Exit;
    end;
end;

function BrowseURL(const URL: string): Boolean;
begin
  if not IsValidURLProtocol(URL) then
    raise SysUtils.Exception.CreateFmt('"%s" is not a valid URL', [URL]);
  Result := ExecAssociatedApp(URL);
end;

function GetProcessorName: string;
var
  Reg: Registry.TRegistry;
begin
  Result := '';
  Reg := Registry.TRegistry.Create(Windows.KEY_READ);
  try
    Reg.RootKey := Windows.HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey(
      'HARDWARE\DESCRIPTION\System\CentralProcessor\0\', False
    ) then
      Exit;
    Result := Reg.ReadString('ProcessorNameString');
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function GetProcessorIdentifier: string;
var
  Reg: Registry.TRegistry;
begin
  Result := '';
  Reg := Registry.TRegistry.Create(Windows.KEY_READ);
  try
    Reg.RootKey := Windows.HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey(
      'HARDWARE\DESCRIPTION\System\CentralProcessor\0\', False
    ) then
      Exit;
    Result := Reg.ReadString('Identifier');
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

procedure MultiSzToStrings(const MultiSz: PChar;
  const Strings: Classes.TStrings);
var
  P: PChar;   // pointer to strings in buffer
begin
  // Do nothing in MultiSz is nil
  if not Assigned(MultiSz) then
    Exit;
  // Scan thru #0 delimited strings until #0#0 found
  P := MultiSz;
  while P^ <> #0 do
  begin
    // add string to list
    Strings.Add(P);
    // move pointer to start of next string if any
    Inc(P, SysUtils.StrLen(P) + 1);
  end;
end;

procedure ListDrives(const List: Classes.TStrings);
var
  Drives: PChar;    // buffer for list of drives
  BufSize: Integer; // size of drive buffer
begin
  // Get buffer size and allocate it
  BufSize := Windows.GetLogicalDriveStrings(0, nil);
  GetMem(Drives, BufSize * SizeOf(Char));
  try
    // Get #0 delimited drives list and convert to string list
    if Windows.GetLogicalDriveStrings(BufSize, Drives) = 0 then
      SysUtils.RaiseLastOSError;
    MultiSzToStrings(Drives, List);
  finally
    FreeMem(Drives);
  end;
end;

procedure EmptyKeyQueue;
var
  Msg: Windows.TMsg;  // dummy value to receive each message from queue
begin
  while Windows.PeekMessage(
    Msg, 0, Messages.WM_KEYFIRST, Messages.WM_KEYLAST, Windows.PM_REMOVE
  ) do {nothing};
end;

procedure TrimAppMemorySize;
var
  MainHandle: Windows.THandle;  // handle to current process
begin
  MainHandle := Windows.OpenProcess(
    Windows.PROCESS_ALL_ACCESS, False, Windows.GetCurrentProcessID
  );
  try
    Windows.SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF);
  finally
    Windows.CloseHandle(MainHandle);
  end;
end;

function GetEnvironmentBlockSize: Cardinal;
var
  PEnvVars: PChar;    // pointer to start of environment block
  PEnvEntry: PChar;   // pointer to an environment string in block
begin
  // Get reference to environment block for this process
  PEnvVars := Windows.GetEnvironmentStrings;
  if PEnvVars <> nil then
  begin
    PEnvEntry := PEnvVars;
    try
      while PEnvEntry^ <> #0 do
        Inc(PEnvEntry, SysUtils.StrLen(PEnvEntry) + 1);
      Result := (PEnvEntry - PEnvVars) + 1;
    finally
      Windows.FreeEnvironmentStrings(PEnvVars);
    end;
  end
  else
    Result := 0;
end;

function GetDefaultPrinterName: string;
var
  CurrentPrinter: Integer; // index of current printer
begin
  // store current printer
  CurrentPrinter := Printer.PrinterIndex;
  try
    try
      // setting PrinterIndex to -1 selects default printer
      // this raises exception if there is no default printer
      Printer.PrinterIndex := -1;
      Result := Printer.Printers.Strings[Printer.PrinterIndex];
    except
      on E: EPrinter do
        Result := '';
    end;
  finally
    // restore current printer
    Printer.PrinterIndex := CurrentPrinter;
  end;
end;

function ProgIDInstalled(const PID: string): Boolean;
var
  WPID: WideString;  // PID as wide string
  Dummy: TGUID;      // unused out value from CLSIDFromProgID function
begin
  WPID := PID;
  Result := ActiveX.Succeeded(
    ActiveX.CLSIDFromProgID(PWideChar(WPID), Dummy)
  );
end;

function IsTabletOS: Boolean;
const
  SM_TABLETPC = 86; // metrics flag not defined in Windows unit
begin
  Result := Windows.GetSystemMetrics(SM_TABLETPC) <> 0;
end;

function GetWindowProcessID(const Wnd: Windows.HWND): Windows.DWORD;
var
  GetWindowThreadProcessId: function(Wnd: Windows.HWND; // API fn prototype
    lpdwProcessId: Windows.PDWORD): Windows.DWORD; stdcall;
begin
  // We load the API function explicitly to make the routine compatible with as
  // many compilers as possible: the definition of GetWindowThreadProcessId in
  // Delphi and FreePascal Windows units varies across compilers
  GetWindowThreadProcessId := GetProcAddress(
    GetModuleHandle('user32.dll'), 'GetWindowThreadProcessId'
  );
  if Assigned(GetWindowThreadProcessId) and Windows.IsWindow(Wnd) then
    GetWindowThreadProcessId(Wnd, @Result)
  else
    Result := Windows.DWORD(-1);
end;

function GetProcessName(const PID: Windows.DWORD): string;
var
  Snapshot: Windows.THandle;    // snapshot of process
  PE: TlHelp32.TProcessEntry32; // structure holding info about a process
  EndOfList: Boolean;           // indicates end of process list reached
begin
  // Assume failure
  Result := '';
  // Get snapshot containing process list
  Snapshot := TlHelp32.CreateToolHelp32SnapShot(TlHelp32.TH32CS_SNAPPROCESS, 0);
  if Snapshot = Windows.THandle(-1) then
    Exit;
  try
    // Look up process in process list
    PE.dwSize := SizeOf(PE);
    EndOfList := not TlHelp32.Process32First(Snapshot, PE);
    while not EndOfList do
    begin
      if PE.th32ProcessID = PID then
      begin
        // Found process: record exe name
        Result := PE.szExeFile;
        Break;
      end;
      EndOfList := not TlHelp32.Process32Next(Snapshot, PE);
    end;
  finally
    // Free the snapshot
    Windows.CloseHandle(Snapshot);
  end;
end;

function GetWindowProcessName(const Wnd: Windows.HWND): string;
begin
  Result := GetProcessName(GetWindowProcessID(Wnd));
end;

function IsLibraryInstalled2(const LibFileName: string): Boolean;
var
  DLLHandle: Windows.THandle; // handle to DLL
begin
  // Try to load DLL
  try
    DLLHandle := SysUtils.SafeLoadLibrary(LibFileName);
  except
    DLLHandle := 0;
  end;
  // Check if DLL has been loaded
  Result := DLLHandle <> 0;
  if Result then
    Windows.FreeLibrary(DLLHandle);
end;

function FloatToFixed(const Value: Extended; const DecimalPlaces: Byte;
  const SeparateThousands: Boolean): string;
const
  // float format specifiers
  cFmtSpec: array[Boolean] of Char = ('f', 'n');
begin
  Result := SysUtils.Format(
    '%.*' + cFmtSpec[SeparateThousands], [DecimalPlaces, Value]
  );
end;

function IntToFixed(const Value: Integer;
  const SeparateThousands: Boolean): string;
begin
  Result := FloatToFixed(Value, 0, SeparateThousands);
end;

function Int64ToFixed(const Value: Int64;
  const SeparateThousands: Boolean): string;
begin
  Result := FloatToFixed(Value, 0, SeparateThousands);
end;

function DownloadURLToFile(const URL, FileName: string): Boolean;
begin
  // URLDownloadFile returns true if URL exists even if file not created
  // hence we also check file has been created.
  Result := {Windows.}Succeeded(
    {UrlMon.}URLDownloadToFile(nil, PChar(URL), PChar(FileName), 0, nil)
  ) and {SysUtils.}FileExists(FileName);
end;

function GetIEVersionStr: string;
var
  Reg: {Registry.}TRegistry; // registry access object
begin
  Result := '';
  Reg := {Registry.}TRegistry.Create;
  try
    Reg.RootKey := {Windows.}HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('Software\Microsoft\Internet Explorer') then begin
      if Reg.ValueExists('Version') then
        Result := Reg.ReadString('Version');
    end;
  finally
    Reg.Free;
  end;
end;

function GetBiosVendor: string;
var
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey('HARDWARE\DESCRIPTION\System\Bios\', False) then
      Exit;
    Result := Reg.ReadString('BIOSVendor');
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function ExtractURIQueryString(const URI: string): string;
var
  QueryStart: Integer;
  QueryEnd: Integer;
begin
  Result := '';
  QueryStart := {SysUtils.}AnsiPos('?', URI);
  if QueryStart = 0 then
    Exit;
  Inc(QueryStart);
  QueryEnd := {SysUtils.}AnsiPos('#', URI);
  if QueryEnd < QueryStart then
    QueryEnd := Length(URI)
  else
    Dec(QueryEnd);
  Result := Copy(URI, QueryStart, QueryEnd - QueryStart + 1);
end;




 function AllDigitsDifferent(N: Int64): Boolean;
var
  UsedDigits: array[0..9] of Boolean; // records which digits have been used
  I: 0..9;  // loops through elements of UsedDigits
  M: 0..9;  // modulus after dividing by 10
begin
  N := Abs(N);
  Result := False;
  for I := 0 to 9 do
    UsedDigits[I] := False;
  while N > 0 do
  begin
    M := N mod 10;
    if UsedDigits[M] then
      Exit;
    UsedDigits[M] := True;
    N := N div 10;
  end;
  Result := True; // if we get here all digits are unique
end;


procedure DecimalToFraction(Decimal: Extended; out FractionNumerator: Extended;
  out FractionDenominator: Extended; const AccuracyFactor: Extended);
var
  DecimalSign: Extended;
  Z: Extended;
  PreviousDenominator: Extended;
  ScratchValue: Extended;
{$IFDEF FPC}
const
{$ELSE}
resourcestring
{$ENDIF}
  sTooSmall = 'Decimal too small to convert to fraction';
  sTooLarge = 'Decimal too large to convert to fraction';
const
  LargestDecimal: Extended = 1.0E+19;
  SmallestDecimal: Extended = 1.0E-19;
begin
  if Decimal < 0.0 then
    DecimalSign := -1.0
  else
    DecimalSign := 1.0;
  Decimal := Abs(Decimal);
  if Math.SameValue(Decimal, Int(Decimal)) then
  begin
    FractionNumerator := Decimal * DecimalSign;
    FractionDenominator := 1.0;
    Exit;
  end;
  if (Decimal < SmallestDecimal) then // X = 0 already taken care of
    raise SysUtils.EConvertError.Create(sTooSmall);
  if (Decimal > LargestDecimal) then
    raise SysUtils.EConvertError.Create(sTooLarge);
  Z := Decimal;
  PreviousDenominator := 0.0;
  FractionDenominator := 1.0;
  repeat
    Z := 1.0 / (Z - Int(Z));
    ScratchValue := FractionDenominator;
    FractionDenominator := FractionDenominator * Int(Z) + PreviousDenominator;
    PreviousDenominator := ScratchValue;
    FractionNumerator := Int(Decimal * FractionDenominator + 0.5) // Rounding
  until
    (
      Abs(
        Decimal - (FractionNumerator / FractionDenominator)
      ) < AccuracyFactor
    )
    or (Z = Int(Z));
  FractionNumerator := DecimalSign * FractionNumerator;
end;

function ColorToHTML(const Color: Graphics.TColor): string;
var
  ColorRGB: Integer;
begin
  ColorRGB := Graphics.ColorToRGB(Color);
  Result := SysUtils.Format(
    '#%0.2X%0.2X%0.2X',
    [Windows.GetRValue(ColorRGB),
    Windows.GetGValue(ColorRGB),
    Windows.GetBValue(ColorRGB)]
  );
end;

function DOSCommandRedirect(const CommandLine: string;
  const OutStream: Classes.TStream): Boolean; overload;
var
  SA: Windows.TSecurityAttributes;
  SI: Windows.TStartupInfo;
  PI: Windows.TProcessInformation;
  ComSpec: array[0..Pred(Windows.MAX_PATH)] of Char;
  FullCommandLine: string;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  Buffer: array[0..8*1024-1] of Char;
  BytesRead: Cardinal;
begin
  Windows.GetEnvironmentVariable('COMSPEC', ComSpec, SizeOf(ComSpec));
  FullCommandLine := ComSpec + ' /C ' + CommandLine;
  with SA do
  begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  Windows.CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
  try
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := Windows.STARTF_USESHOWWINDOW or Windows.STARTF_USESTDHANDLES;
      wShowWindow := Windows.SW_HIDE;
      // don't redirect stdin
      hStdInput := Windows.GetStdHandle(Windows.STD_INPUT_HANDLE);
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    Result := Windows.CreateProcess(
      nil, PChar(FullCommandLine), nil, nil, True, 0, nil, nil, SI, PI
    );
    Windows.CloseHandle(StdOutPipeWrite);
    if Result then
    try
      repeat
        WasOK := Windows.ReadFile(
          StdOutPipeRead, Buffer, SizeOf(Buffer), BytesRead, nil
        );
        if BytesRead > 0 then
          OutStream.Write(Buffer[0], BytesRead);
      until not WasOK or (BytesRead = 0);
    finally
      Windows.CloseHandle(PI.hThread);
      Windows.CloseHandle(PI.hProcess);
    end;
  finally
    Windows.CloseHandle(StdOutPipeRead);
  end;
end;


function IsRunningOnBattery: Boolean;
var
  Stat: Windows.TSystemPowerStatus;
begin
  Windows.GetSystemPowerStatus(Stat);
  Result := Stat.ACLineStatus = 0;
end;

function RemainingBatteryPercent: Integer;
var
  Stat: Windows.TSystemPowerStatus;
begin
  Windows.GetSystemPowerStatus(Stat);
  Result := Stat.BatteryLifePercent;
  if (Result < 0) or (Result > 100) then
    Result := -1;
end;


procedure SendKeysToWindow(const HWnd: Windows.HWND; const Text: string);
var
  Idx: Integer;     // current position in input string
  Ch: Char;         // current character in input string
  WParam: LongInt;  // WParam to WM_KEYxxx and WM_CHAR messages
  LParam: LongInt;  // LParam to WM_KEYxxx and WM_CHAR messages
  ScanCode: Byte;   // scan code of virtual key code
  OEMScan: Word;    // OEM scan code equivalent of virtual key code
begin
  for Idx := 1 to Length(Text) do
  begin
    // Record current char and its ordinal value
    Ch := Text[Idx];
    WParam := Ord(Ch);
    // Send WM_KEYDOWN message
    ScanCode := Windows.MapVirtualKey(WParam, 0);
    LParam := 1 or (ScanCode shl 16) or $40000001; // sets bits 1 & 30
    Windows.SendMessage(HWnd, Messages.WM_KEYDOWN, WParam, LParam);
    // Send WM_CHAR message
    OEMScan := Windows.LoByte(Windows.VkKeyScan(Ch));
    ScanCode := Windows.MapVirtualKey(OEMScan, 0);
    LParam := 1 + (ScanCode shl 16) or $00000001;   // sets bit 1
    Windows.SendMessage(HWnd, Messages.WM_CHAR, WParam, LParam);
    // Send WM_KEYUP message
    ScanCode := Windows.MapVirtualKey(WParam, 0);
    LParam := 1 or (ScanCode shl 16) or $C0000001;  // sets bits 1, 30 & 31
    Windows.SendMessage(HWnd, Messages.WM_KEYUP, WParam, LParam);
  end;
end;

 function DOSCommand(const CommandLine: string; const CmdShow: Integer;
  const WaitUntilComplete: Boolean; const WorkingDir: string = ''): Boolean;
var
 ComSpec: array[0..Pred(Windows.MAX_PATH)] of Char;
 FullCommandLine: string;
 PWorkingDir: PChar;
 SI: Windows.TStartupInfo;
 PI: Windows.TProcessInformation;
begin
  FillChar(SI, SizeOf(SI), #0);
  SI.cb := SizeOf(SI);
  SI.dwFlags := Windows.STARTF_USESHOWWINDOW; // needed to use wShowWindow
  SI.wShowWindow := CmdShow;
  Windows.GetEnvironmentVariable('COMSPEC', ComSpec, SizeOf(ComSpec));
  FullCommandLine := ComSpec + ' /C ' + CommandLine;
  if WorkingDir <> '' then
    PWorkingDir := PChar(WorkingDir)
  else
    PWorkingDir := nil;
  Result := Windows.CreateProcess(
    nil,
    PChar(FullCommandLine),
    nil,
    nil,
    False,
    Windows.NORMAL_PRIORITY_CLASS,
    nil,
    PWorkingDir,
    SI,
    PI
  );
  if Result then
  begin
    if WaitUntilComplete then
      Windows.WaitforSingleObject(PI.hProcess, Windows.INFINITE);
    Windows.CloseHandle(PI.hProcess);
    Windows.CloseHandle(PI.hThread );
  end;
end;

function ReadBigEndianWord(Stm: Classes.TStream): Word;
type
  // Record used to hack big endian word
  TBigEndianWord = packed record
    case Byte of
      0: (Value: Word);         // value as word
      1: (Byte1, Byte2: Byte);  // value as bytes
  end;
var
  BEW: TBigEndianWord;  // record read from stream
begin
  FillChar(BEW, SizeOf(BEW), 0);
  Stm.Read(BEW.Byte2, SizeOf(Byte));
  Stm.Read(BEW.Byte1, SizeOf(Byte));
  Result := BEW.Value;
end;

function StreamHasWatermark(const Stm: Classes.TStream;
  const Watermark: array of Byte): Boolean;
var
  StmPos: Int64;
  Buf: array of Byte;
  I: Integer;
begin
  Assert(Length(Watermark) > 0, 'No "watermark" specified');
  Result := False;
  StmPos := Stm.Position;
  try
    if Stm.Size - StmPos < Length(Watermark) then
      Exit;
    SetLength(Buf, Length(Watermark));
    Stm.ReadBuffer(Pointer(Buf)^, Length(Buf));
    for I := Low(Buf) to High(Buf) do
      if Buf[I] <> Watermark[I] then
        Exit;
    Result := True;
  finally
    Stm.Position := StmPos;
  end;
end;


function IsCharInSet(const Ch: Char; const Chars: TCharSet): Boolean;
begin
  {$IFDEF UNICODE}
  Result := SysUtils.CharInSet(Ch, Chars);
  {$ELSE}
  Result := Ch in Chars;
  {$ENDIF}
end;

function IsHexStr(const S: string): Boolean;
  {Returns true if string S contains only valid hex digits, false otherwise}
const
  cHexChars = ['0'..'9', 'A'..'F', 'a'..'f']; // set of valid hex digits
var
  Idx: Integer; // loops thru all characters in string
begin
  Result := True;
  for Idx := 1 to Length(S) do
    if not IsCharInSet(S[Idx], cHexChars) then
    begin
      Result := False;
      Break;
    end;
end;

  function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
  PI: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  Buffer: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SA do begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
  try
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), SI, PI);
    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            Buffer[BytesRead] := #0;
            Result := Result + Buffer;
          end;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(PI.hProcess, INFINITE);
      finally
        CloseHandle(PI.hThread);
        CloseHandle(PI.hProcess);
      end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;


procedure CaptureConsoleOutput(DosApp : string;AMemo : TMemo); 
const 
  ReadBuffer = 1048576;  // 1 MB Buffer 

var 
  Security            : TSecurityAttributes; 
  ReadPipe,WritePipe  : THandle; 
  start               : TStartUpInfo; 
  ProcessInfo         : TProcessInformation; 
  Buffer              : Pchar; 
  TotalBytesRead, 
  BytesRead           : DWORD; 
  Apprunning,n, 
  BytesLeftThisMessage, 
  TotalBytesAvail : integer; 

begin 

  with Security do begin 
    nlength              := SizeOf(TSecurityAttributes); 
    binherithandle       := true; 
    lpsecuritydescriptor := nil; 
  end; 

  if CreatePipe (ReadPipe, WritePipe, @Security, 0) then begin 
    // Redirect In- and Output through STARTUPINFO structure 
    Buffer  := AllocMem(ReadBuffer + 1); 
    FillChar(Start,Sizeof(Start),#0); 

    start.cb          := SizeOf(start); 
    start.hStdOutput  := WritePipe; 
    start.hStdInput   := ReadPipe; 
    start.dwFlags     := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW; 

    start.wShowWindow := SW_HIDE; 
    // Create a Console Child Process with redirected input and output 
    if CreateProcess(nil      ,PChar(DosApp), 
                     @Security,@Security, 
                     true     ,CREATE_NO_WINDOW or NORMAL_PRIORITY_CLASS, 
                     nil      ,nil, 
                     start    ,ProcessInfo) then 
    begin 
      n:=0; 
      TotalBytesRead:=0; 
      repeat 
        // Increase counter to prevent an endless loop if the process is dead 
        Inc(n,1); 
        // wait for end of child process 

        Apprunning := WaitForSingleObject(ProcessInfo.hProcess,100); 
        Application.ProcessMessages; 

        // it is important to read from time to time the output information 
        // so that the pipe is not blocked by an overflow. New information 
        // can be written from the console app to the pipe only if there is 
        // enough buffer space. 

        if not PeekNamedPipe(ReadPipe        ,@Buffer[TotalBytesRead], 
                             ReadBuffer      ,@BytesRead, 
                             @TotalBytesAvail,@BytesLeftThisMessage) then break 

        else if BytesRead > 0 then 
          ReadFile(ReadPipe,Buffer[TotalBytesRead],BytesRead,BytesRead,nil); 
        TotalBytesRead:=TotalBytesRead+BytesRead; 

      until (Apprunning <> WAIT_TIMEOUT) or (n > 150); 
      Buffer[TotalBytesRead]:= #0; 
      OemToChar(Buffer,Buffer); 
      AMemo.Text := AMemo.text + StrPas(Buffer); 

    end; 

    FreeMem(Buffer); 
   CloseHandle(ProcessInfo.hProcess); 
    CloseHandle(ProcessInfo.hThread); 
    CloseHandle(ReadPipe); 
    CloseHandle(WritePipe); 

  end; 

end; 


  function ExecuteCommandDOS(CommandLine:string):string;
var
PROC: TProcessInformation;
Ret: LongBool;
START: TStartupInfo;
SA: TSecurityAttributes;
hReadPipe: THandle;
hWritePipe: THandle;
dBytesRead: DWORD;
sBuff: array[0..255] of Char;
begin
if Length(CommandLine) > 0 then
mCommand := CommandLine;
if Length(mCommand) = 0 then begin
MessageBox(0, PChar('Command Line empty.'), PChar('Error'), MB_ICONEXCLAMATION);
Exit;
end;
SA.nLength := SizeOf(TSecurityAttributes);
SA.bInheritHandle := TRUE;
SA.lpSecurityDescriptor := nil;
Ret := CreatePipe(hReadPipe, hWritePipe, @SA, 0);
if not Ret then begin
MessageBox(0, PChar('CreatePipe() failed.'), PChar('Error'), MB_ICONEXCLAMATION);
Exit;
end;
FillChar(START ,Sizeof(TStartupInfo), #0);
START.cb := SizeOf(TStartupInfo);
START.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
START.hStdOutput := hWritePipe;
START.hStdError := hWritePipe;
Ret := CreateProcess(nil, PChar(mCommand), @SA, @SA, TRUE, NORMAL_PRIORITY_CLASS, nil, nil, START, PROC);
if Ret <> TRUE then begin
MessageBox(0, PChar('File or command not found.'), PChar('Error'), MB_ICONEXCLAMATION);
Exit;
end;
Ret := CloseHandle(hWritePipe);
mOutputs := '';
repeat


Ret := ReadFile(hReadPipe, sBuff, 255, dBytesRead, nil);
mOutputs := mOutputs + Copy(sBuff, 1, dBytesRead);
until Ret = FALSE;
Ret := CloseHandle(PROC.hProcess);
Ret := CloseHandle(PROC.hThread);
Ret := CloseHandle(hReadPipe);
 result:= mOutputs
end;


function IntToNumberText2(const Value: Integer): string;
const
  grOnes = 0;        // group < 1,000
  grThousands = 1;   // 1,000 <= group < 1,000,000
  plOnes = 0;        // "ones" place within group
  plTens = 1;        // "tens" place within group
  plHundreds = 2;    // "hnudreds place within group
{$IFDEF FPC}
const
{$ELSE}
resourcestring
{$ENDIF}
  // various number items
  sHundred = 'hundred';
  sOneHundred = 'one hundred';
  sOneThousand = 'one thousand';
  sMinus = 'minus';
const
  // map of number names
  cNumStrings: array[ 0..27 ] of string = (
    'zero', 'one', 'two', 'three', 'four',
    'five', 'six', 'seven', 'eight', 'nine',
    'ten', 'eleven', 'twelve', 'thirteen', 'fourteen',
    'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen',
    'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy',
    'eighty', 'ninety'
  );
  // array of "group" names
  cGroupStrings: array[ 1..4 ] of string = (
    'thousand', 'million', 'billion', 'trillion'
  );
var
  NumDigits: Integer;     // number of digits in value
  Group: Integer;         // index of group of 1000s
  Place: Integer;         // place of current digit within group
  Digit: Integer;         // current digit
  CurPos: Integer;        // position in ValString of current digit
  SilentGroup: Boolean;   // whether group is rendered
  ValString: string;      // string representation of Value
begin
    // Special case for zero
  if Value = 0 then
  begin
    Result := cNumStrings[0];
    Exit;
  end;
 
  ValString := SysUtils.IntToStr(Abs(Value));
  NumDigits := Length(ValString);
  if Value > 0 then
    Result := ''
  else
    Result := sMinus;
 
  Group := (NumDigits - 1) div 3;
  Place := (NumDigits + 2) mod 3;
  CurPos := 1;
 
  while Group >= grOnes do
  begin
    SilentGroup := True;
 
    while Place >= plOnes do
    begin
      Digit := Ord(ValString[CurPos]) - Ord('0');
      Inc(CurPos);
      if Digit = 0 then
      begin
        Dec(Place);
        Continue;
      end;
 
      case Place of
        plHundreds:
        begin
          if Digit > 1 then
            Result := Result + ' ' + cNumStrings[Digit] + ' ' + sHundred
          else
            Result := Result + ' ' + sOneHundred;
          SilentGroup := False;
        end;
        plTens:
        begin
          if Digit = 1 then
          begin
            // Special case 10 thru 19
            Place := plOnes;
            Digit := Ord(ValString[CurPos]) - Ord('0');
            Inc(CurPos);
            Result := Result + ' ' + cNumStrings[10 + Digit];
          end
          else
            Result := Result + ' ' + cNumStrings[20 + Digit - 2];
          SilentGroup := False;
        end;
        plOnes:
        begin
          if (Group = grThousands) and (Digit = 1) then
            Result := Result + ' ' + sOneThousand
          else
          begin
            Result := Result + ' ' + cNumStrings[Digit];
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


{Checks state of the lock key specified by KeyCode. Returns True if the lock key is on or False if it is off. An exception is raised if KeyCode is not a valid lock key code. Valid lock key codes are VK_CAPITAL, VK_NUMLOCK and VK_SCROLL.
}	

function IsLockKeyOn(const KeyCode: Integer): Boolean;
begin
  if not (
    KeyCode in [Windows.VK_CAPITAL, Windows.VK_NUMLOCK, Windows.VK_SCROLL]
  ) then
    raise SysUtils.Exception.Create('Invalid lock key specified.');
  Result := Odd(Windows.GetKeyState(KeyCode));
end;


 procedure SetLockKeyState(KeyCode: Integer; IsOn: Boolean);
  // ---------------------------------------------------------------------------
  procedure MoveKey(KeyCode: Integer; Up: Boolean);
  var
    Flags: Integer; // flags for MapVirtualKey()
  begin
    // Set up flags
    Flags := Windows.KEYEVENTF_EXTENDEDKEY;
    if Up then
      Flags := Flags or Windows.KEYEVENTF_KEYUP;
    // Simulate key movement
    Windows.keybd_event(
      KeyCode,
      Windows.MapVirtualkey(KeyCode, 0),
      Flags,
      0
    );
  end;
  // ---------------------------------------------------------------------------
begin
  if not (
    KeyCode in [Windows.VK_CAPITAL, Windows.VK_NUMLOCK, Windows.VK_SCROLL]
  ) then
    raise SysUtils.Exception.Create('Invalid lock key specified.');
  if IsLockKeyOn(KeyCode) <> IsOn then
  begin
    // Need to change state: press & release key
    MoveKey(KeyCode, False);
    MoveKey(KeyCode, True);
  end;
end;

procedure PostKeyEx322(const Key: Word; const Shift: Classes.TShiftState;
  const SpecialKey: Boolean = False);
type
  TShiftKeyInfo = record  // information about a shoft key
    Shift: Byte;          // shift key
    VKey: Byte;           // virtual key code
  end;
  ByteSet = set of 0..7;  // byte sized bitset
const
  // map of shift state values to virtual keys
  ShiftKeys: array[ 1..3 ] of TShiftKeyInfo = (
    (Shift: Ord(Classes.ssCtrl);  VKey: Windows.VK_CONTROL),
    (Shift: Ord(Classes.ssShift); VKey: Windows.VK_SHIFT),
    (Shift: Ord(Classes.ssAlt);   VKey: Windows.VK_MENU)
  );
var
  Flag: DWORD;                      // flag passed to keybd_event
  ShiftSet: ByteSet absolute Shift; // shift state as bit set
  I: Integer;                       // loop variable
begin
  // generate any shift key down events
  for I := 1 to 3 do
    if ShiftKeys[I].Shift in ShiftSet then
      Windows.keybd_event(
        ShiftKeys[I].VKey,
        Windows.MapVirtualKey(ShiftKeys[I].VKey, 0),
        0,
        0
      );
  // generate key down then key up event for key
  if SpecialKey then
    Flag := Windows.KEYEVENTF_EXTENDEDKEY
  else
    Flag := 0;
  Windows.keybd_event(Key, Windows.MapVirtualKey(Key, 0), Flag, 0);
  Flag := Flag or Windows.KEYEVENTF_KEYUP;
  Windows.keybd_event(Key, Windows.MapVirtualKey(Key, 0), Flag, 0);
  // generate any shift key up events in reverse order of key down events
  for I := 3 downto 1 do
    if ShiftKeys[I].Shift in ShiftSet then
      Windows.keybd_event(
        ShiftKeys[I].VKey,
        Windows.MapVirtualKey(ShiftKeys[I].VKey, 0),
        Windows.KEYEVENTF_KEYUP,
        0
      );
end;

  function TerminateProcessByID(ProcessID: Cardinal): Boolean;
var
  HProcess : THandle;
begin
  Result := False;
  HProcess := Windows.OpenProcess(Windows.PROCESS_TERMINATE, False, ProcessID);
  if HProcess > 0 then
  try
    Result := SysUtils.Win32Check(Windows.TerminateProcess(HProcess, 0));
  finally
    Windows.CloseHandle(HProcess);
  end;
end;

function IsWinNT: Boolean;
begin
  Result := (SysUtils.Win32Platform = Windows.VER_PLATFORM_WIN32_NT);
end;

function GetWindowThreadID(const Wnd: Windows.HWND): Windows.DWORD;
var
  GetWindowThreadProcessId: function(Wnd: Windows.HWND; // API fn prototype
    lpdwProcessId: Windows.PDWORD): Windows.DWORD; stdcall;
begin
  // We load the API function explicitly to make the routine compatible with as
  // many compilers as possible: the definition of GetWindowThreadProcessId in
  // Delphi and FreePascal Windows units varies across compilers
  GetWindowThreadProcessId := GetProcAddress(
    GetModuleHandle('user32.dll'), 'GetWindowThreadProcessId'
  );
  if Assigned(GetWindowThreadProcessId) and Windows.IsWindow(Wnd) then
    Result := GetWindowThreadProcessId(Wnd, nil)
  else
    Result := Windows.DWORD(-1);
end;

function IsKeyPressed2(const VirtKeyCode: Integer): Boolean;
begin
  // High bit set when key is pressed => GetKeyState returns -ve value
  Result := Windows.GetKeyState(VirtKeyCode) < 0;
end;


function IsAppResponding(const Wnd: Windows.HWND): Boolean;
type
  TIsHungThread = function(ThreadId: Windows.DWORD): Windows.BOOL;
    stdcall;  // prototype of win9x API IsHungThread function
  TIsHungAppWindow = function(Wnd: Windows.HWND): Windows.BOOL;
    stdcall;  // prototype of winNT API IsHungAppWindow function
var
  User32: Windows.THandle;            // handle to User32.dll
  IsHungThread: TIsHungThread;        // win 9x API function reference
  IsHungAppWindow: TIsHungAppWindow;  // win NT API function reference
resourcestring
  // Exception messages
  sNotWindow = 'Invalid window handle';
  sCantLoadUser32 = 'Can''t reference User32.dll';
  sCantLoadFunction = 'Can''t load required API routine';
begin
  if not Windows.IsWindow(Wnd) then
    raise SysUtils.Exception.Create(sNotWindow);
  User32 := Windows.GetModuleHandle('user32.dll');
  if User32 = 0 then
    raise SysUtils.Exception.Create(sCantLoadUser32);
  if IsWinNT then
  begin
    @IsHungAppWindow := Windows.GetProcAddress(User32, 'IsHungAppWindow');
    if not Assigned(IsHungAppWindow) then
      raise SysUtils.Exception.Create(sCantLoadFunction);
    Result := not IsHungAppWindow(Wnd);
  end
  else
  begin
    @IsHungThread := Windows.GetProcAddress(User32, 'IsHungThread');
    if not Assigned(IsHungThread) then
      raise SysUtils.Exception.Create(sCantLoadFunction);
    Result := not IsHungThread(GetWindowThreadID(Wnd));
  end;
end;




(*initialization
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
  end;*)

End.
