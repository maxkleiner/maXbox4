unit UtilsMax4;

//implemental for maXbox4 by Max1    plus IDBAse Component  V2  -V3 mX4.2.4.25

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
  
  function SetTransparencyLevel(const HWnd: Windows.HWND;
           const Level: Byte): Boolean;
  function IsEqualResID(const R1, R2: PChar): Boolean;         //55
  function GetGenericFileType(const FileNameOrExt: string): string;
  function GetFileType2(const FilePath: string): string;
  procedure ShowShellPropertiesDlg(const APath: string);
  function EllipsifyText(const AsPath: Boolean; const Text: string;
           const Canvas: Graphics.TCanvas; const MaxWidth: Integer ): string;
  function CloneByteArray(const B: array of Byte): TBytes;       //60
  procedure AppendByteArray(var B1: TBytes; const B2: array of Byte);
  function IsUnicodeStream(const Stm: Classes.TStream): Boolean;
  function FileHasWatermark(const FileName: string;
            const Watermark: array of Byte; const Offset: Integer = 0): Boolean;
  function FileHasWatermarkAnsi(const FileName: string;
             const Watermark: AnsiString; const Offset: Integer = 0): Boolean;
  function IsASCIIStream(const Stm: Classes.TStream; Count: Int64 = 0;
                                 BufSize: Integer = 8*1024): Boolean;
  function IsASCIIFile(const FileName: string; BytesToCheck: Int64 = 0;
                               BufSize: Integer = 8*1024): Boolean;      //66
   function BytesToAnsiString(const Bytes: SysUtils.TBytes; const CodePage: Word):
                                      String;
  function UnicodeStreamToWideString(const Stm: Classes.TStream): WideString;
  procedure WideStringToUnicodeStream(const Str: WideString;
                                            const Stm: Classes.TStream);
  procedure GraphicToBitmap(const Src: Graphics.TGraphic;
              const Dest: Graphics.TBitmap; const TransparentColor: Graphics.TColor);  //70

  function URIDecode(S: string; const IsQueryString: Boolean): string;
  function URIEncode(const S: string; const InQueryString: Boolean): string;
  function URLDecode(const S: string): string;
  function URLEncode(const S: string; const InQueryString: Boolean): string;
  function AllDigitsSame(N: Int64): Boolean;                                       //75
  function FoldWrapText(const Line, BreakStr: string; BreakChars: TSysCharSet; MaxCol: Integer): string;
  function ExeType(const FileName: string): string; //TExeType;
  function TextWrap(const Text: string; const Width, Margin: Integer): string;
  function CompressWhiteSpace(const S: string): string;
  function IsASCIIDigit(const Ch: Char): Boolean;
  function CompareNumberStr(const S1, S2: string): Integer;
  procedure HexToBuf(HexStr: string; var Buf);
  function BufToHex(const Buf; const Size: Cardinal): string;
  function GetCharFromVirtualKey(AKey: Word): string;
  function GetParentProcessID(const PID: Windows.DWORD): Windows.DWORD;
  function FormInstanceCount2(AFormClass: Forms.TFormClass): Integer; //overload;
  function FormInstanceCount(const AFormClassName: string): Integer; //overload;
   function FindAssociatedApp(const Doc: string): string;
   function CreateShellLink(const LinkFileName, AssocFileName, Desc, WorkDir,
  Args, IconFileName: string; const IconIdx: Integer): Boolean;
  function FileFromShellLink(const LinkFileName: string): string;
  function IsShellLink(const LinkFileName: string): Boolean;
  function ResourceIDToStr(const ResID: PChar): string;                   //93
  //function IsEqualResID(const R1, R2: PChar): Boolean;
  function RecycleBinInfo(const Drive: Char; out BinSize, FileCount: Int64): Boolean;
  function SysImageListHandle(const Path: string; const WantLargeIcons: Boolean): Windows.THandle;
  function EmptyRecycleBin: Boolean;
  function ExploreFile(const Filename: string ): Boolean;
  function ExploreFolder(const Folder: string): Boolean;               //98
  procedure ClearRecentDocs;
  procedure AddToRecentDocs(const FileName: string);                   //100
  function StringsToMultiSz(const Strings: Classes.TStrings; const MultiSz: PChar; const BufSize: Integer): Integer;
   procedure DrawTextOutline(const Canvas: Graphics.TCanvas; const X, Y: Integer; const Text: string);
  function CloneGraphicAsBitmap(const Src: Graphics.TGraphic; const PixelFmt: Graphics.TPixelFormat;
  const TransparentColor: Graphics.TColor): Graphics.TBitmap;
   procedure InvertBitmap(const ABitmap: Graphics.TBitmap); //overload;
  procedure InvertBitmap2(const SrcBmp, DestBmp: Graphics.TBitmap); //overload;     //105


//var
  //UtilsLanguage:      TUtilsLanguage;
  //InputBoxesLanguage: TInputBoxesLanguage;

implementation

uses MMSystem, Math, ShellAPI, ShlObj, UrlMon, WinSock, IdGlobal, messages, registry, Printers, ActiveX;


function TIdBaseComponent.GetVersion: string;
begin
  Result := gsIdVersion;
end;

{function CodePageSupportsString(const S: UnicodeString;
  const CodePage: Word): Boolean;
var
  Encoding: SysUtils.TEncoding;  // Encoding for required code page
begin
  Encoding := SysUtils.TMBCSEncoding.Create(CodePage);
  try
    Result := EncodingSupportsString(S, Encoding);
  finally
    Encoding.Free;
  end;
end;}

procedure InvertBitmap(const ABitmap: Graphics.TBitmap); //overload;
var
  Y: Integer;                     // loops through bitmap's scanlines
  X: Integer;                     // loops through triples in each scanline
  ByteArray: SysUtils.PByteArray; // pointer to each RGB triple
begin
  ABitmap.PixelFormat := Graphics.pf24Bit;
  for Y := 0 to ABitmap.Height - 1 do
  begin
    ByteArray := ABitmap.ScanLine[Y];
    for X := 0 to ABitmap.Width * 3 - 1 do
      ByteArray[X] := 255 - ByteArray[X];
  end;
end;

procedure InvertBitmap2(const SrcBmp, DestBmp: Graphics.TBitmap); //overload;
begin
  DestBmp.Assign(SrcBmp);
  InvertBitmap(DestBmp);
end;

function StringsToMultiSz(const Strings: Classes.TStrings;
  const MultiSz: PChar; const BufSize: Integer): Integer;
var
  ReqSize: Integer; // required buffer size
  Idx: Integer;     // loops thru Strings
  P: PChar;         // pointer into MultiSz
begin
  Result := 0;
  if not Assigned(Strings) then
    Exit;
  // Get required size of buffer
  ReqSize := 1;
  for Idx := 0 to Pred(Strings.Count) do
    Inc(ReqSize, Length(Strings[Idx]) + 1);
  if (BufSize >= ReqSize) and Assigned(MultiSz) then
  begin
    // BufSize OK and MultiSz not nil: copy string and return zero
    P := MultiSz;
    for Idx := 0 to Pred(Strings.Count) do
    begin
      // copy current string, #0 terminated
      SysUtils.StrPCopy(P, Strings[Idx]);
      // moves to next pos in buffer
      Inc(P, Length(Strings[Idx]) + 1);
    end;
    // add terminating additional #0
    P^ := #0;
  end
  else
    // BufSize too small or MultiSz is nil: return required size
    Result := ReqSize;
end;

procedure DrawTextOutline(const Canvas: Graphics.TCanvas; const X, Y: Integer;
  const Text: string);
var
  OldBkMode: Integer;  // stores previous background mode
begin
  OldBkMode := Windows.SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
  Windows.BeginPath(Canvas.Handle);
  Canvas.TextOut(X, Y, Text);
  Windows.EndPath(Canvas.Handle);
  Windows.StrokeAndFillPath(Canvas.Handle);
  Windows.SetBkMode(Canvas.Handle, OldBkMode);
end;

function CloneGraphicAsBitmap(const Src: Graphics.TGraphic;
  const PixelFmt: Graphics.TPixelFormat;
  const TransparentColor: Graphics.TColor): Graphics.TBitmap;
begin
  // Create bitmap with required pixel format
  Result := Graphics.TBitmap.Create;
  if PixelFmt <> Graphics.pfCustom then
    Result.PixelFormat := PixelFmt
  else if Src is Graphics.TBitmap then
    Result.PixelFormat := (Src as Graphics.TBitmap).PixelFormat;
  // Copy the graphic object
  GraphicToBitmap(Src, Result, TransparentColor);
end;

procedure ClearRecentDocs;
begin
  ShlObj.SHAddToRecentDocs(ShlObj.SHARD_PATH, nil);
end;

procedure AddToRecentDocs(const FileName: string);
begin
  ShlObj.SHAddToRecentDocs(ShlObj.SHARD_PATH, PChar(FileName));
end;


function ExploreFile(const Filename: string ): Boolean;
var
  Params: string; // params passed to explorer
begin
  if SysUtils.FileExists(Filename) then
  begin
    Params := '/n, /e, /select, ' + Filename;
    Result := ShellAPI.ShellExecute (
      0, 'open', 'explorer', PChar(Params), '', Windows.SW_SHOWNORMAL
    ) > 32;
  end
  else
    // Error: filename does not exist
    Result := False;
end;

function ExploreFolder(const Folder: string): Boolean;
begin
  if SysUtils.FileGetAttr(Folder) and faDirectory = faDirectory then
    // Folder is valid directory: try to explore it
    Result := ShellAPI.ShellExecute(
      0, 'explore', PChar(Folder), nil, nil, Windows.SW_SHOWNORMAL
    ) > 32
  else
    // Folder is not a directory: error
    Result := False;
end;

function EmptyRecycleBin: Boolean;
const
  // Flags passed to SHEmptyRecycleBin
  SHERB_NOCONFIRMATION = $00000001;
  SHERB_NOPROGRESSUI = $00000002;
  SHERB_NOSOUND = $00000004;
  // DLL containing function
  cDLLName = 'Shell32.dll';
  // Function name
  {$IFDEF UNICODE}
  cFnName = 'SHEmptyRecycleBinW';
  {$ELSE}
  cFnName = 'SHEmptyRecycleBinA';
  {$ENDIF}
type
  // Prototype of API function
  TSHEmptyRecycleBin = function(
    Wnd: Windows.HWND;
    pszRootPath: PChar;
    dwFlags: Windows.DWORD
  ): HRESULT; stdcall;
var
  SHEmptyRecycleBin: TSHEmptyRecycleBin;  // API function address
  DLLHandle: Windows.THandle;             // Handle of required DLL
begin
  // Assume failure
  Result := False;
  // Load required DLL
  DLLHandle := SysUtils.SafeLoadLibrary(cDLLName);
  if DLLHandle <> 0 then
  begin
    try
      // Get reference of API function from DLL
      @SHEmptyRecycleBin := Windows.GetProcAddress(DLLHandle, cFnName);
      if Assigned(@SHEmptyRecycleBin) then
      begin
        // Try to empty recycle bin
        Result := Windows.Succeeded(
          SHEmptyRecycleBin(
            0, nil, SHERB_NOCONFIRMATION or SHERB_NOSOUND or SHERB_NOPROGRESSUI
          )
        );
      end;
    finally
      Windows.FreeLibrary(DLLHandle);
    end;
  end;
end;

function IsIntResource(const ResID: PChar): Boolean;
begin
  Result := (Windows.HiWord(Windows.DWORD(ResID)) = 0);
end;

function ResourceIDToStr(const ResID: PChar): string;
begin
  if IsIntResource(ResID) then
    Result := '#' + SysUtils.IntToStr(Integer(ResID))
  else
    Result := string(ResID);
end;

function SysImageListHandle(const Path: string;
  const WantLargeIcons: Boolean): Windows.THandle;
var
  FI: ShellAPI.TSHFileInfo; // required file info structure
  Flags: Windows.UINT;      // flags used to request image list
begin
  Flags := ShellAPI.SHGFI_SYSICONINDEX or ShellAPI.SHGFI_ICON;
  if WantLargeIcons then
    Flags := Flags or ShellAPI.SHGFI_LARGEICON
  else
    Flags := Flags or ShellAPI.SHGFI_SMALLICON;
  Result := ShellAPI.SHGetFileInfo(PChar(Path), 0, FI, SizeOf(FI), Flags);
end;

function RecycleBinInfo(const Drive: Char; out BinSize, FileCount: Int64):
  Boolean;
type
  // structure passed to SHQueryRecycleBin to get information about recyle bin
  TSHQueryRBInfo = packed record
    cbSize: Integer;    // size of structure
    i64Size: Int64;     // size of recycle bin
    i64NumItems: Int64; // number of items in recycle bin.
  end;
  PSHQueryRBInfo = ^TSHQueryRBInfo;
  // function prototype for SHQueryRecycleBin (prototypes Unicode version when
  // PChar = PWideChar and ANSI version when PChar = PAnsiChar
  TSHQueryRecycleBin = function(RootPath: PChar; Query: PSHQueryRBInfo): 
    Integer; stdcall;
const
  {$IFDEF UNICODE}
  cSHQueryRecycleBin = 'SHQueryRecycleBinW';  // Unicode SHQueryRecycleBin fn
  {$ELSE}
  cSHQueryRecycleBin = 'SHQueryRecycleBinA';  // ANSI SHQueryRecycleBin fn
  {$ENDIF}
  cShell32 = 'shell32.dll';                   // SHQueryRecycleBin's DLL
var
  SHQueryRecycleBin: TSHQueryRecycleBin;  // reference to SHQueryRecycleBin fn
  Shell32: Windows.THandle;               // handle to shel32.dll
  SHQueryRBInfo: TSHQueryRBInfo;          // structure receive recyle bin info
  RootDir: string;                        // directory we are getting info for
  PRootDir: PChar;                        // pointer to root dir or nil
begin
  // Intialise to assume failure
  Result := False;
  BinSize := 0;
  FileCount := 0;
  // Attempt to load required SHQueryRecycleBin function from DLL
  Shell32 := SysUtils.SafeLoadLibrary(cShell32);
  if Shell32 <> 0 then
  begin
    @SHQueryRecycleBin := Windows.GetProcAddress(Shell32, cSHQueryRecycleBin);
    if Assigned(@SHQueryRecycleBin) then
    begin
      // Set structure size before calling SHQueryRecycleBin
      SHQueryRBInfo.cbSize := SizeOf(SHQueryRBInfo);
      // Create pointer to required drive (nul to get all drives)
      {$IFDEF UNICODE}
      if SysUtils.CharInSet(UpCase(Drive), ['A'..'Z']) then
      {$ELSE}
      if UpCase(Drive) in ['A'..'Z'] then
      {$ENDIF}
      begin
        RootDir := UpCase(Drive) + ':\';
        PRootDir := PChar(RootDir);
      end
      else
        PRootDir := nil;
      // Get recycle info
      Result := SHQueryRecycleBin(PRootDir, @SHQueryRBInfo) = 0;
      if Result then
      begin
        // Success: pass info back through params
        BinSize := SHQueryRBInfo.i64Size;
        FileCount := SHQueryRBInfo.i64NumItems;
      end;
    end;
  end;
end;

{function IsEqualResID(const R1, R2: PChar): Boolean;
begin
  if IsIntResource(R1) then
    // R1 is ordinal: R2 must also be ordinal with same value in lo word
    Result := IsIntResource(R2) and
      (Windows.LoWord(Windows.DWORD(R1)) = Windows.LoWord(Windows.DWORD(R2)))
  else
    // R1 is string pointer: R2 must be same string (ignoring case)
    Result := not IsIntResource(R2) and (SysUtils.StrIComp(R1, R2) = 0);
end;}

function FindAssociatedApp(const Doc: string): string;
var
  PExecFile: array[0..Windows.MAX_PATH] of Char; // buffer to hold exe name
begin
  // Win API call in ShellAPI
  if ShellAPI.FindExecutable(PChar(Doc), nil, PExecFile) < 32 then
    // No associated program found
    Result := ''
  else
    // Return program file name
    Result := PExecFile;
end;



function CreateShellLink(const LinkFileName, AssocFileName, Desc, WorkDir,
  Args, IconFileName: string; const IconIdx: Integer): Boolean;
var
  SL: ShlObj.IShellLink;    // shell link object
  PF: ActiveX.IPersistFile; // persistant file interface to shell link object
begin
  // Assume failure
  Result := False;
  // Ensure COM is initialised
  ActiveX.CoInitialize(nil);
  try
    // Create shell link object
    if ActiveX.Succeeded(
      ActiveX.CoCreateInstance(
        ShlObj.CLSID_ShellLink,
        nil,
        ActiveX.CLSCTX_INPROC_SERVER,
        ShlObj.IShellLink, SL
      )
    ) then
    begin
      // Store required properties of shell link
      SL.SetPath(PChar(AssocFileName));
      SL.SetDescription(PChar(Desc));
      SL.SetWorkingDirectory(PChar(WorkDir));
      SL.SetArguments(PChar(Args));
      if (IconFileName <> '') and (IconIdx >= 0) then
        SL.SetIconLocation(PChar(IconFileName), IconIdx);
      // Create persistant file interface to shell link to save link file
      PF := SL as ActiveX.IPersistFile;
      Result := ActiveX.Succeeded(
        PF.Save(PWideChar(WideString(LinkFileName)), True)
      );
    end;
  finally
    // Finalize COM
    ActiveX.CoUninitialize;
  end;
end;

function LoadShellLink(const LinkFileName: string): ShlObj.IShellLink;
var
  PF: ActiveX.IPersistFile; // persistent file interface to shell link object
begin
  // Create shell link object
  if ActiveX.Succeeded(
    ActiveX.CoCreateInstance(
      ShlObj.CLSID_ShellLink,
      nil,
      ActiveX.CLSCTX_INPROC_SERVER,
      ShlObj.IShellLink,
      Result
    )
  ) then
  begin
    // Try to load the shell link: succeeds only of file is shell link
    PF := Result as ActiveX.IPersistFile;
    if ActiveX.Failed(
      PF.Load(PWideChar(WideString(LinkFileName)), ActiveX.STGM_READ)
    ) then
      Result := nil;  // this frees the shell link object
  end
  else
    Result := nil;
end;


function IsShellLink(const LinkFileName: string): Boolean;
begin
  // Ensure COM is initialized
  ActiveX.CoInitialize(nil);
  try
    // Valid shell link if we can load it
    Result := Assigned(LoadShellLink(LinkFileName));
  finally
    // Finalize COM
    ActiveX.CoUninitialize;
  end;
end;



function FileFromShellLink(const LinkFileName: string): string;
var
  SL: ShlObj.IShellLink;            // shell link object
  ResolvedFileBuf: array[0..Windows.MAX_PATH] of Char;
                                    // buffer to receive linked file name
  FindData: Windows.TWin32FindData; // dummy required for IShellLink.GetPath()
begin
  // Assume can't get name of file
  Result := '';
  // Ensure COM is initialized
  ActiveX.CoInitialize(nil);
  try
    // Try to get interface to shell link: fails if file is not shell link
    SL := LoadShellLink(LinkFileName);
    if not Assigned(SL) then
      Exit;
    // Get file path from link object and exit if this fails
    if ActiveX.Failed(
      SL.GetPath(ResolvedFileBuf, Windows.MAX_PATH, FindData, 0)
    ) then
      Exit;
    // Return file name
    Result := ResolvedFileBuf;
  finally
    // Finalize COM
    ActiveX.CoUninitialize;
  end;
end;

function BufToHex(const Buf; const Size: Cardinal): string;
const
  // maps nibbles to hex digits
  cHexDigits: array[$0..$F] of Char = (
    '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
  );
var
  I: Cardinal;  // loops thru output string
  PB: ^Byte;    // addresses each byte in buffer
begin
  PB := @Buf;
  SetLength(Result, 2 * Size);
  I := 1;
  while I <= 2 * Size do
  begin
    Result[I] := cHexDigits[PB^ shr 4];
    Result[I + 1] := cHexDigits[PB^ and $0F];
    Inc(PB);
    Inc(I, 2);
  end;
end;


function StripHexPrefix(const HexStr: string): string;
begin
  if Pos('$', HexStr) = 1 then
    Result := Copy(HexStr, 2, Length(HexStr) - 1)
  else if Pos('0x', SysUtils.LowerCase(HexStr)) = 1 then
    Result := Copy(HexStr, 3, Length(HexStr) - 2)
  else
    Result := HexStr;
end;

function AddHexPrefix(const HexStr: string): string;
begin
  Result := SysUtils.HexDisplayPrefix + StripHexPrefix(HexStr);
end;

function TryHexToInt(const HexStr: string; out Value: Integer): Boolean;
var
  E: Integer; // error code
begin
  Val(AddHexPrefix(HexStr), Value, E);
  Result := E = 0;
end;

function TryHexToBuf(HexStr: string; var Buf): Boolean;
var
  I: Integer;       // loops through characters of string
  PB: ^Byte;        // references each byte in buffer
  ByteVal: Integer; // a byte value from hex string
begin
  Result := False;
  HexStr := StripHexPrefix(HexStr);
  if HexStr = '' then
    Exit;
  if Odd(Length(HexStr)) then
    HexStr := '0' + HexStr;
  I := 1;
  PB := @Buf;
  while I <= Length(HexStr) do
  begin
    if not TryHexToInt(HexStr[I] + HexStr[I + 1], ByteVal) then
      Exit;
    PB^ := Byte(ByteVal);
    Inc(I, 2);
    Inc(PB);
  end;
  Result := True;
end;

procedure HexToBuf(HexStr: string; var Buf);
{$IFDEF FPC}
const
{$ELSE}
resourcestring
{$ENDIF}
  sHexConvertError = '''%s'' is not a valid hexadecimal string';
begin
  if not TryHexToBuf(HexStr, Buf) then
    raise SysUtils.EConvertError.CreateFmt(sHexConvertError, [HexStr]);
end;


function GetCharFromVirtualKey(AKey: Word): string;
var
  KeyboardState: Windows.TKeyboardState; // keyboard state codes
const
  MAPVK_VK_TO_VSC = 0;  // parameter passed to MapVirtualKey
begin
  Windows.GetKeyboardState(KeyboardState);
  SetLength(Result, 2); // max number of returned chars
  case Windows.ToAscii(
    AKey,
    Windows.MapVirtualKey(AKey, MAPVK_VK_TO_VSC),
    KeyboardState,
    @Result[1],
    0
  ) of
    0: Result := '';         // no translation available
    1: SetLength(Result, 1); // single char returned
    2: {Do nothing};         // two chars returned: leave Length(Result) = 2
    else Result := '';       // probably dead key
  end;
end;

function GetParentProcessID(const PID: Windows.DWORD): Windows.DWORD;
var
  Snapshot: Windows.THandle;    // snapshot of process
  PE: TlHelp32.TProcessEntry32; // structure holding info about a process
  EndOfList: Boolean;           // indicates end of process list reached
begin
  // Assume failure
  Result := Windows.DWORD(-1);
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
        // Found process: record parent process ID
        Result := PE.th32ParentProcessID;
        Break;
      end;
      EndOfList := not TlHelp32.Process32Next(Snapshot, PE);
    end;
  finally
    // Free the snapshot
    Windows.CloseHandle(Snapshot);
  end;
end;

function FormInstanceCount2(AFormClass: Forms.TFormClass): Integer; //overload;
var
  I: Integer;  // loops through all forms
begin
  Result := 0;
  for I := 0 to Forms.Screen.FormCount - 1 do
    Inc(Result, Ord(Forms.Screen.Forms[I] is AFormClass));
end;

function FormInstanceCount(const AFormClassName: string): Integer; //overload;
var
  I: Integer;  // loops through all forms
begin
  Result := 0;
  for I := 0 to Forms.Screen.FormCount - 1 do
    Inc(Result, Ord(Forms.Screen.Forms[I].ClassNameIs(AFormClassName)));
end;


{This is taken from Borland's SysUtils and modified for our folding}    {Do not Localize}
function FoldWrapText(const Line, BreakStr: string; BreakChars: TSysCharSet;
  MaxCol: Integer): string;
const
  QuoteChars = ['"'];    {Do not Localize}
var
  Col, Pos: Integer;
  LinePos, LineLen: Integer;
  BreakLen, BreakPos: Integer;
  QuoteChar, CurChar: Char;
  ExistingBreak: Boolean;
begin
  Col := 1;
  Pos := 1;
  LinePos := 1;
  BreakPos := 0;
  QuoteChar := ' ';    {Do not Localize}
  ExistingBreak := False;
  LineLen := Length(Line);
  BreakLen := Length(BreakStr);
  Result := '';    {Do not Localize}
  while Pos <= LineLen do
  begin
    CurChar := Line[Pos];
    if CurChar in LeadBytes then
    begin
      Inc(Pos);
      Inc(Col);
    end  //if CurChar in LeadBytes then
    else
      if CurChar = BreakStr[1] then
      begin
        if QuoteChar = ' ' then    {Do not Localize}
        begin
          ExistingBreak := AnsiSameText(BreakStr, Copy(Line, Pos, BreakLen));
          if ExistingBreak then
          begin
            Inc(Pos, BreakLen-1);
            BreakPos := Pos;
          end; //if ExistingBreak then
        end // if QuoteChar = ' ' then    {Do not Localize}
      end // if CurChar = BreakStr[1] then
      else
        if CurChar in BreakChars then
        begin
          if QuoteChar = ' ' then    {Do not Localize}
            BreakPos := Pos
        end  // if CurChar in BreakChars then
        else
        if CurChar in QuoteChars then
          if CurChar = QuoteChar then
            QuoteChar := ' '    {Do not Localize}
          else
            if QuoteChar = ' ' then    {Do not Localize}
              QuoteChar := CurChar;
    Inc(Pos);
    Inc(Col);
    if not (QuoteChar in QuoteChars) and (ExistingBreak or
      ((Col > MaxCol) and (BreakPos > LinePos))) then
    begin
      Col := Pos - BreakPos;
      Result := Result + Copy(Line, LinePos, BreakPos - LinePos + 1);
      if not (CurChar in QuoteChars) then
        while (Pos <= LineLen) and (Line[Pos] in BreakChars + [#13, #10]) do Inc(Pos);
      if not ExistingBreak and (Pos < LineLen) then
        Result := Result + BreakStr;
      Inc(BreakPos);
      LinePos := BreakPos;
      ExistingBreak := False;
    end; //if not
  end; //while Pos <= LineLen do
  Result := Result + Copy(Line, LinePos, MaxInt);
end;

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



function ExeType(const FileName: string): string; //TExeType;
var
  FS: TFileStream;              // stream onto executable file
  WinMagic: Word;                       // word that contains PE/NE/LE magic #s
  HdrOffset: LongInt;                   // offset of windows header in exec file
  DOSHeader: IMAGE_DOS_HEADER;  // DOS header record
  //DOSHeader: longint;
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
      Result := 'etUnknown';
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
      Result := 'etDOS';
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
                Result := 'etDLL32'
              else
                Result := 'etExe32';
            cPE64Magic:
              if IsPEDLL then
                Result := 'etDLL64'
              else
                Result := 'etExe64';
            cPEROMMagic:
              Result := 'etROM';
            else
              Result := 'etUnknown';  // unknown PE magic number
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
            Result := 'etDLL16'
          else
            // app flags indicate program
            Result := 'etExe16';
        end;
        cLEMagic:
          // We have a Virtual Device Driver
          Result := 'etVXD';
        else
          // DOS application
          {Do nothing - DOS result already set};
      end;
    finally
      FS.Free;
    end;
  except
    // Exception raised in function => error result
    Result := 'etError';
  end;
end;

function IsASCIIDigit(const Ch: Char): Boolean;
begin
  Result := Ord(Ch) in [Ord('0')..Ord('9')];
end;


function CompareNumberStr(const S1, S2: string): Integer;
 
  // Gets a chunk of all numeric or all non-numeric text from Source starting at
  // Pos and stores in Dest. Pos is moved past the end of the chunk.
  procedure GetChunk(Source: string; var Pos: Integer; out Dest: string);
  var
    IsNum: Boolean; // flags if string chunk is numeric
    DP: Integer;    // cursor into Source string
  begin
    if Pos > Length(Source) then
      Dest := ''
    else
    begin
      IsNum := IsASCIIDigit(Source[Pos]);
      DP := 0;
      while (Pos + DP <= Length(Source))
        and (IsASCIIDigit(Source[Pos + DP]) = IsNum) do
        Inc(DP);
      Dest := Copy(Source, Pos, DP);
      Pos := Pos + DP;
    end;
  end;
 
var
  Chunk1, Chunk2: string; // chunks of text from S1 and S2 respectively
  Pos1, Pos2: Integer;    // current position in S1 and S2 respectively
begin
  if (S1 = '') or (S2 = '')
    or (IsASCIIDigit(S1[1]) xor IsASCIIDigit(S2[1])) then
    // Either S1 or S2 is empty OR one starts with a digit and the other starts
    // with a non-digit. In either case we just need a normal string compare.
    Result := SysUtils.CompareStr(S1, S2)
  else
  begin
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
      if Chunk1 = '' then
      begin
        if Chunk2 <> '' then
          Result := -1;
      end
      else if Chunk2 = '' then
        Result := 1
      else if IsASCIIDigit(Chunk1[1]) then
        // These chunks are both numeric: compare numbers.
        Result := SysUtils.StrToInt(Chunk1) - SysUtils.StrToInt(Chunk2)
      else
        // These chunks are both non-numeric: compare text
        Result := SysUtils.CompareStr(Chunk1, Chunk2);
      // If existing chunks compare same, we move on to compare next chunks,
      // providing we have not run out of text.
    until (Result <> 0) or ((Chunk1 = '') and (Chunk2 = ''));
  end;
end;

// ---------------------------------------------------------------------------
 (* procedure AddItem(AllowEmpty: Boolean = True; const Trim: Boolean;
                                   item: string; list: TStrings);
  begin
    // Adds optionally trimmed item to list if required
    if (Trim) then
      Item := Trim(Item);
    if (Item <> '') or AllowEmpty then
      List.Add(Item);
  end;*)

  // ---------------------------------------------------------------------------

 function SplitStr(const S, Delim: string; out S1, S2: string): Boolean;
var
  DelimPos: Integer;  // position of delimiter in source string
begin
  // Find position of first occurence of delimiter in string
  DelimPos := AnsiPos(Delim, S);
  if DelimPos > 0 then begin
    // Delimiter found: split and return True
    S1 := Copy(S, 1, DelimPos - 1);
    S2 := Copy(S, DelimPos + Length(Delim), MaxInt);
    Result := True;
  end
  else begin
    // Delimiter not found: return false and set S1 to whole string
    S1 := S;
    S2 := '';
    Result := False;
  end;
end;

function ExplodeStr(S, Delim: string; const List: Classes.TStrings;
  const AllowEmpty: Boolean = True; const Trim: Boolean = False): Integer;
var
  Item: string;       // current delimited text
  Remainder: string;  // remaining un-consumed part of string
 
  // ---------------------------------------------------------------------------
  procedure AddItem;
  begin
    // Adds optionally trimmed item to list if required
    if (Trim) then
      Item := SysUtils.Trim(Item);
    if (Item <> '') or AllowEmpty then
      List.Add(Item);
  end;
  // ---------------------------------------------------------------------------
 
begin
  // Clear the list
  List.Clear;
  // Check we have some entries in the string
  if S <> '' then
  begin
    // Repeatedly split string until we have no more entries
    while SplitStr(S, Delim, Item, Remainder) do
    begin
      AddItem;
      S := Remainder;
    end;
    // Add any remaining item
    AddItem;
  end;
  Result := List.Count;
end;

 (* // -------------------------------------------------------------------------
  procedure AddLine(const Line, aresult: string; margin: integer);
  begin
    // Adds line of text to output, offsetting line by width of margin
    if aResult <> '' then    // not first line: insert new line
      //aResult := aResult + #13#10;
    //aResult := aResult + StringOfChar(' ', Margin) + Line;
  end;
  // -------------------------------------------------------------------------
   *)


function TextWrap(const Text: string; const Width, Margin: Integer): string;
var
  Word: string;               // next word in input text
  Line: string;               // current output line
  Words: Classes.TStringList; // list of words in input text
  I: Integer;                 // loops thru all words in input text
 
  // -------------------------------------------------------------------------
  procedure AddLine(const Line: string);
  begin
    // Adds line of text to output, offsetting line by width of margin
    if Result <> '' then    // not first line: insert new line
      Result := Result + #13#10;
    Result := Result + StringOfChar(' ', Margin) + Line;
  end;
  // -------------------------------------------------------------------------
 
begin
  // Get all words in text
  Words := Classes.TStringList.Create;
  try
    ExplodeStr(Text, ' ', Words);
    Result := '';
    Line := '';
    // Loop for each word in text
    for I := 0 to Pred(Words.Count) do
    begin
      Word := Words[I];
      if Length(Line) + Length(Word) + 1 <= Width then
      begin
        // Word fits on current line: add it
        if Line = '' then
          Line := Word  // 1st word on line
        else
          Line := Line + ' ' + Word;
      end
      else
      begin
        // Word doesn't fit on line
        AddLine(Line);  // output line
        Line := Word;   // store word as first on next line
      end;
    end;
    if Line <> '' then
      // Residual line after end of loop: add to output
      AddLine(Line);
  finally
    Words.Free;
  end;
end;

function IsWhiteSpace(const Ch: Char): Boolean;
begin
  Result := IsCharInSet(Ch, [' ', #9, #10, #11, #12, #13]);
end;

function CompressWhiteSpace(const S: string): string;
var
  Idx: Integer;      // loops thru all characters in string
  ResCount: Integer; // counts number of characters in result string
  PRes: PChar;       // pointer to characters in result string
begin
  // Set length of result to length of source string and set pointer to it
  SetLength(Result, Length(S));
  PRes := PChar(Result);
  // Reset count of characters in result string
  ResCount := 0;
  // Loop thru characters of source string
  Idx := 1;
  while Idx <= Length(S) do
  begin
    if IsWhiteSpace(S[Idx]) then
    begin
      // Current char is white space: replace by space char and count it
      PRes^ := ' ';
      Inc(PRes);
      Inc(ResCount);
      // Skip past any following white space
      Inc(Idx);
      while IsWhiteSpace(S[Idx]) do
        Inc(Idx);
    end
    else
    begin
      // Current char is not white space: copy it literally and count it
      PRes^ := S[Idx];
      Inc(PRes);
      Inc(ResCount);
      Inc(Idx);
    end;
  end;
  // Reduce length of result string if it is shorter than source string
  if ResCount < Length(S) then
    SetLength(Result, ResCount);
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

function IsFlagSet(const Flags, Mask: Integer): Boolean;
begin
  Result := Mask = (Flags and Mask);
end;

function WindowSupportsLayers(const HWnd: Windows.HWND): Boolean;
const
  WS_EX_LAYERED = $00080000;  // layered window style
begin
  Result := IsFlagSet(
    Windows.GetWindowLong(HWnd, Windows.GWL_EXSTYLE), WS_EX_LAYERED
  );
end;

function SetTransparencyLevel(const HWnd: Windows.HWND;
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
end;


{function IsIntResource(const ResID: PChar): Boolean;
begin
  Result := (Windows.HiWord(Windows.DWORD(ResID)) = 0);
end;}

function IsEqualResID(const R1, R2: PChar): Boolean;
begin
  if IsIntResource(R1) then
    // R1 is ordinal: R2 must also be ordinal with same value in lo word
    Result := IsIntResource(R2) and
      (Windows.LoWord(Windows.DWORD(R1)) = Windows.LoWord(Windows.DWORD(R2)))
  else
    // R1 is string pointer: R2 must be same string (ignoring case)
    Result := not IsIntResource(R2) and (SysUtils.StrIComp(R1, R2) = 0);
end;

function GetGenericFileType(const FileNameOrExt: string): string;
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
end;

function GetFileType2(const FilePath: string): string;
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
end;


procedure ShowShellPropertiesDlg(const APath: string);
var
  AExecInfo: ShellAPI.TShellExecuteinfo;  // info passed to ShellExecuteEx
begin
  FillChar(AExecInfo, SizeOf(AExecInfo), 0);
  AExecInfo.cbSize := SizeOf(AExecInfo);
  AExecInfo.lpFile := PChar(APath);
  AExecInfo.lpVerb := 'properties';
  AExecInfo.fMask := ShellAPI.SEE_MASK_INVOKEIDLIST;
  ShellAPI.ShellExecuteEx(@AExecInfo);
end;


function EllipsifyText(const AsPath: Boolean; const Text: string;
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
end;

function CloneByteArray(const B: array of Byte): TBytes;
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
end;

function IsUnicodeStream(const Stm: Classes.TStream): Boolean;
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
                            String;
begin
  SetLength(Result, Length(Bytes));
  if Length(Bytes) > 0 then
  begin
    Move(Bytes[0], Result[1], Length(Bytes));
    //SetCodePage(Result, CodePage, False);
  end;
end;


function StreamToString(const Stm: Classes.TStream): string;
var
  SS: Classes.TStringStream;  // used to copy stream to string
begin
  // This TStreamStream constructor uses default ANSI encoding in Unicode
  // versions of Delphi.
  SS := Classes.TStringStream.Create('');  
  try
    SS.CopyFrom(Stm, 0);
    Result := SS.DataString;
  finally
    SS.Free;
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

function URIDecode(S: string; const IsQueryString: Boolean): string;
const
  cPercent = '%';
 
  // Counts number of '%' characters in a UTF8 string
  function CountPercent(const S: UTF8String): Integer;
  var
    Idx: Integer; // loops thru all octets of S
  begin
    Result := 0;
    for Idx := 1 to Length(S) do
      if S[Idx] = cPercent then
        Inc(Result);
  end;
 
{$IFDEF FPC}
const
{$ELSE}
resourcestring
{$ENDIF}
  // Error messages
  rsEscapeError = 'String to be decoded contains invalid % escape sequence';
var
  SrcUTF8: UTF8String;  // input string as UTF-8
  SrcIdx: Integer;      // index into source UTF-8 and WideString strings
  ResUTF8: UTF8String;  // output string as UTF-8
  ResIdx: Integer;      // index into result UTF-8 string
  Hex: string;          // hex component of % encoding
  ChValue: Integer;     // character ordinal value from a % encoding
begin
  // If data from query string then replace '+' with ' '. We should really
  // replace with %20 since string is still URI encoded and space is not one of
  // the reserved characters and so should be percent encoded. However this
  // routine accepts strings that break the rules and this works here.
  if IsQueryString then
    for SrcIdx := 1 to Length(S) do
      if S[SrcIdx] = '+' then
        S[SrcIdx] := ' ';
  // Convert input string to UTF-8
  SrcUTF8 := UTF8Encode(S);
  // Size the decoded UTF-8 string: each 3 byte sequence starting with '%' is
  // replaced by a single byte. All other bytes are copied unchanged.
  SetLength(ResUTF8, Length(SrcUTF8) - 2 * CountPercent(SrcUTF8));
  SrcIdx := 1;
  ResIdx := 1;
  while SrcIdx <= Length(SrcUTF8) do
  begin
    if SrcUTF8[SrcIdx] = cPercent then
    begin
      // % encoding: decode following two hex chars into required code point
      if Length(SrcUTF8) < SrcIdx + 2 then
        raise EConvertError.Create(rsEscapeError);  // malformed: too short
      Hex := '$' + string(SrcUTF8[SrcIdx + 1] + SrcUTF8[SrcIdx + 2]);
      if not TryStrToInt(Hex, ChValue) then
        raise EConvertError.Create(rsEscapeError);  // malformed: not valid hex
      ResUTF8[ResIdx] := AnsiChar(ChValue);
      Inc(ResIdx);
      Inc(SrcIdx, 3);
    end
    else
    begin
      // plain char or UTF-8 continuation character: copy unchanged
      ResUTF8[ResIdx] := SrcUTF8[SrcIdx];
      Inc(ResIdx);
      Inc(SrcIdx);
    end;
  end;
  // Convert back to wide / Unicode string type for result
  {$IFDEF UNICODE}
  Result := UTF8ToString(ResUTF8);
  {$ELSE}
  Result := UTF8Decode(ResUTF8);
  {$ENDIF}
end;

 function URIEncode(const S: string; const InQueryString: Boolean): string;
var
  Idx: Integer;        // loops thru characters in string
  UTF8Str: UTF8String; // UTF8 encoded version of S
begin
  Result := '';
  UTF8Str := UTF8Encode(S);
  for Idx := 1 to Length(UTF8Str) do
  begin
    case UTF8Str[Idx] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.', '~':
        Result := Result + {$IFDEF UNICODE}string{$ENDIF}(UTF8Str[Idx]);
      ' ':
        if InQueryString then
          Result := Result + '+'
        else
          Result := Result + '%20';
      else
        Result := Result + '%' + SysUtils.IntToHex(Ord(UTF8Str[Idx]), 2);
    end;
  end;
end;

function URLDecode(const S: string): string;
var
  Idx: Integer;   // loops thru chars in string
  Hex: string;    // string of hex characters
  Code: Integer;  // hex character code (-1 on error)
begin
  // Intialise result and string index
  Result := '';
  Idx := 1;
  // Loop thru string decoding each character
  while Idx <= Length(S) do
  begin
    case S[Idx] of
      '%':
      begin
        // % should be followed by two hex digits - exception otherwise
        if Idx <= Length(S) - 2 then
        begin
          // there are sufficient digits - try to decode hex digits
          Hex := S[Idx+1] + S[Idx+2];
          Code := SysUtils.StrToIntDef('$' + Hex, -1);
          Inc(Idx, 2);
        end
        else
          // insufficient digits - error
          Code := -1;
        // check for error and raise exception if found
        if Code = -1 then
          raise SysUtils.EConvertError.Create(
            'Invalid hex digit in URL'
          );
        // decoded OK - add character to result
        Result := Result + Chr(Code);
      end;
      '+':
        // + is decoded as a space
        Result := Result + ' '
      else
        // All other characters pass thru unchanged
        Result := Result + S[Idx];
    end;
    Inc(Idx);
  end;
end;

function URLEncode(const S: string; const InQueryString: Boolean): string;
var
  Idx: Integer; // loops thru characters in string
begin
  Result := '';
  for Idx := 1 to Length(S) do
  begin
    case S[Idx] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        Result := Result + S[Idx];
      ' ':
        if InQueryString then
          Result := Result + '+'
        else
          Result := Result + '%20';
      else
        Result := Result + '%' + SysUtils.IntToHex(Ord(S[Idx]), 2);
    end;
  end;
end;

 function AllDigitsSame(N: Int64): Boolean;
var
  D: 0..9;  // sample digit from N
begin
  N := Abs(N);
  D := N mod 10;
  Result := False;
  while N > 0 do
  begin
    if N mod 10 <> D then
      Exit;
    N := N div 10;
  end;
  Result := True;
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
