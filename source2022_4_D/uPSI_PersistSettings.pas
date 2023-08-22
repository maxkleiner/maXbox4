unit uPSI_PersistSettings;
{
   c mutex   guidtester    secureclear   add shlobj    grabline, uptime , locs=2800  splitstring resstream helper
   uses ImageHlp;   getjpge res   - tcursor unit forms    - locs 3067- 29  DownloadArchive
}
interface



uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;


type
(*----------------------------------------------------------------------------*)
  TPSImport_PersistSettings = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_IPersistSettings(CL: TPSPascalCompiler);
procedure SIRegister_PersistSettings(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PersistSettings_Routines(S: TPSExec);
procedure RIRegister_PersistSettings(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IniFiles
  ,PersistSettings, Windows, Registry, winsock, SpectraLibrary, ComObj, Grids, variants, activeX,
         graphics, jpeg, pngloader, ShlObj, KFunctions, strutils, TlHelp32, richedit, ComCtrls, messages,
         ToolIntf, Exptintf, Printers, forms, ImageHlp, extctrls, wininet;


  function SHMultiFileProperties(pDataObj: IDataObject; Flag: DWORD): HRESULT;
  stdcall; external 'shell32.dll';


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PersistSettings]);
end;


procedure FloatToDecimalE(var Result: TFloatRec; const Value: extended; ValueType: TFloatValue; Precision, Decimals: Integer);
begin
   FloatToDecimalE(Result,Value,ValueType,Precision, Decimals);
end;

function FloatToTextE(BufferArg: PChar; const Value: extended; ValueType: TFloatValue; Format: TFloatFormat; Precision, Digits: Integer): Integer;
begin
  FloatToText(BufferArg, Value, ValueType, Format, Precision, Digits);
end;

 function getLastInput: DWord;
var
  LInput: TLastInputInfo;
begin
  LInput.cbSize := SizeOf(TLastInputInfo);
  GetLastInputInfo(LInput);
  Result := GetTickCount - LInput.dwTime;
end;

procedure GetKLList(List: TStrings);
var
  AList : array [0..9] of Hkl;
  AklName: array [0..255] of Char;
  i: Longint;
begin
  List.Clear;
  for i := 0 to GetKeyboardLayoutList(SizeOf(AList), AList) - 1 do
    begin
      GetLocaleInfo(LoWord(AList[i]), LOCALE_SLANGUAGE, AklName, SizeOf(AklName));
      List.AddObject(AklName, Pointer(AList[i]));
    end;
end;


procedure EnableCTRLALTDEL(YesNo : boolean);
const
sRegPolicies = '\Software\Microsoft\Windows\CurrentVersion\Policies';
begin
  with TRegistry.Create do
  try
    RootKey:=HKEY_CURRENT_USER;
    if OpenKey(sRegPolicies+'\System\',True) then
    begin
      case YesNo of
        False:
          begin
            WriteInteger('DisableTaskMgr',1);
          end;
        True:
          begin
            WriteInteger('DisableTaskMgr',0);
          end;
      end;
    end;
    CloseKey;
    if OpenKey(sRegPolicies+'\Explorer\',True) then
    begin
      case YesNo of
        False:
          begin
            WriteInteger('NoChangeStartMenu',1);
            WriteInteger('NoClose',1);
            WriteInteger('NoLogOff',1);
          end;
        True:
          begin
            WriteInteger('NoChangeStartMenu',0);
            WriteInteger('NoClose',0);
            WriteInteger('NoLogOff',0);
          end;
      end;
    end;
    CloseKey;
  finally
    Free;
  end;
end;

function LocalIP: string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array[0..63] of Char;
  I: Integer;
  GInitData: TWSAData;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(buffer);
  if phe = nil then Exit;
  pPtr := PaPInAddr(phe^.h_addr_list);
  I := 0;
  while pPtr^[I] <> nil do
  begin
    Result := inet_ntoa(pptr^[I]^);
    Inc(I);
  end;
  WSACleanup;
end;

function IPAddrToName(IPAddr: string): string;
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  WSAData: TWSAData;
begin
  WSAStartup($101, WSAData);
  SockAddrIn.sin_addr.s_addr := inet_addr(PChar(IPAddr));
  HostEnt := gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);
  if HostEnt <> nil then
    Result := StrPas(Hostent^.h_name)
  else
    Result := '';
end;


// Function to get the IP Address from a Host

function GetIPFromHost(const HostName: string): string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  i: Integer;
  GInitData: TWSAData;
begin
  WSAStartup($101, GInitData);
  Result := '';
  phe := GetHostByName(PChar(HostName));
  if phe = nil then Exit;
  pPtr := PaPInAddr(phe^.h_addr_list);
  i := 0;
  while pPtr^[i] <> nil do
  begin
    Result := inet_ntoa(pptr^[i]^);
    Inc(i);
  end;
  WSACleanup;
end;

const
  MaxEntries = 250;


function FindComputers(Computers : TStringList): DWORD;
var
  EnumWorkGroupHandle, EnumComputerHandle: THandle;
  EnumError: DWORD;
  Network: TNetResource;
  WorkGroupEntries, ComputerEntries: DWORD;
  EnumWorkGroupBuffer, EnumComputerBuffer: array[1..MaxEntries] of TNetResource;
  EnumBufferLength: DWORD;
  I, J: DWORD;
begin
  Computers.Clear;

  FillChar(Network, SizeOf(Network), 0);
  with Network do
  begin
    dwScope := RESOURCE_GLOBALNET;
    dwType  := RESOURCETYPE_ANY;
    dwUsage := RESOURCEUSAGE_CONTAINER;
  end;

  EnumError := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_ANY, 0,
    @Network, EnumWorkGroupHandle);

  if EnumError = NO_ERROR then
  begin
    WorkGroupEntries := MaxEntries;
    EnumBufferLength := SizeOf(EnumWorkGroupBuffer);
    EnumError        := WNetEnumResource(EnumWorkGroupHandle, WorkGroupEntries,
      @EnumWorkGroupBuffer, EnumBufferLength);

    if EnumError = NO_ERROR then
    begin
      for I := 1 to WorkGroupEntries do
      begin
        EnumError := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_ANY, 0,
          @EnumWorkGroupBuffer[I], EnumComputerHandle);
        if EnumError = NO_ERROR then
        begin
          ComputerEntries  := MaxEntries;
          EnumBufferLength := SizeOf(EnumComputerBuffer);
          EnumError        := WNetEnumResource(EnumComputerHandle, ComputerEntries,
            @EnumComputerBuffer, EnumBufferLength);
          if EnumError = NO_ERROR then
            for J := 1 to ComputerEntries do
              Computers.Add(Copy(EnumComputerBuffer[J].lpRemoteName,
                3, Length(EnumComputerBuffer[J].lpRemoteName) - 2));
          WNetCloseEnum(EnumComputerHandle);
        end;
      end;
    end;
    WNetCloseEnum(EnumWorkGroupHandle);
  end;

  if EnumError = ERROR_NO_MORE_ITEMS then
    EnumError := NO_ERROR;
  Result := EnumError;
end;


{It's a recursiv one :-}
function RecurseWin32(const R: TRegistry; const ThePath: string;
  const TheKey: string): string;
var
  TheList: TStringList;
  i: Integer;
  LP: string;
  OnceUponATime: string;
begin
  Result  := '-';
  TheList := TStringList.Create;
  try
    R.OpenKey(ThePath, False);
    R.GetKeyNames(TheList);
    R.CloseKey;
    if TheList.Count = 0 then Exit;
    for i := 0 to TheList.Count - 1 do with TheList do 
      begin
        LP := ThePath + '\' + TheList[i];
        if CompareText(Strings[i], TheKey) = 0 then 
        begin
          Result := LP;
          Break;
        end;
        OnceUponATime := RecurseWin32(R, LP, TheKey);
        if OnceUponATime <> '-' then 
        begin
          Result := OnceUponATime;
          Break;
        end;
      end;
  finally
    TheList.Clear;
    TheList.Free;
  end;
end;


 function GetWin32TypeLibList(var Lines: TStringList): Boolean;
var 
  R: TRegistry;
  W32: string;
  i, j, TheIntValue, TheSizeOfTheIntValue: Integer;
  TheSearchedValue, TheSearchedValueString: string;
  TheVersionList, TheKeyList: TStringList;
  TheBasisKey: string;
begin
  Result := True;
  try
    try
      R          := TRegistry.Create;
      TheVersionList := TStringList.Create;
      TheKeyList := TStringList.Create;

      R.RootKey := HKEY_CLASSES_ROOT;
      R.OpenKey('TypeLib', False);
      TheBasisKey := R.CurrentPath;

      (* Basis Informations *)
      case R.GetDataType('') of
        rdUnknown: thekeylist.add('rd unknown - Nothing ???');
        rdExpandString, rdString: TheSearchedValueString := R.ReadString('');
        rdInteger: TheIntValue         := R.ReadInteger('');
        rdBinary: TheSizeOfTheIntValue := R.GetDataSize('');
      end;
      (* Build the List of Keys *)
      R.GetKeyNames(TheKeyList);
      R.CloseKey;
      //ShowMessage(TheKeyList.Strings[1]);
      for i := 0 to TheKeyList.Count - 1 do
         (* Loop around the typelib entries)
         (* Schleife um die TypeLib Einträge *)
        with TheKeyList do
          if Length(Strings[i]) > 0 then 
          begin
            R.OpenKey(TheBasisKey + '\' + Strings[i], False);
            TheVersionList.Clear;
            R.GetKeyNames(TheVersionList);
            R.CloseKey;
            (* Find "Win32" for each version *)
            (* Finde der "win32" für jede VersionVersion:*)
            for j := 0 to TheVersionList.Count - 1 do
              if Length(TheVersionList.Strings[j]) > 0 then 
              begin
                W32 := RecurseWin32(R, TheBasisKey + '\' +
                  Strings[i] + '\' +
                  TheVersionList.Strings[j],
                  'Win32');
                if W32 <> '-' then 
                begin
                  Lines.Add(W32);
                  R.OpenKey(W32, False);
                  case R.GetDataType('') of
                    rdExpandString,
                    rdString: TheSearchedValue := R.ReadString('');
                    else
                      TheSearchedValue := 'Nothing !!!';
                  end;
                  R.CloseKey;
                  Lines.Add('-----> ' + TheSearchedValue);
                end;
              end;
          end;
    finally
      TheVersionList.Free;
      TheKeyList.Free;
    end;
  except
    Result := False;
  end;
end;


function GetCharFromVKey(vkey: Word): string;
var
  keystate: TKeyboardState;
  retcode: Integer;
begin
  Win32Check(GetKeyboardState(keystate));
  SetLength(Result, 2);
  retcode := ToAscii(vkey,
    MapVirtualKey(vkey, 0),
    keystate, @Result[1],
    0);
  case retcode of
    0: Result := ''; // no character
    1: SetLength(Result, 1);
    2:;
    else
      Result := ''; // retcode < 0 indicates a dead key
  end;
end;


function Xls_To_StringGrid(AGrid: TStringGrid; AXLSFile: string): Boolean;
const
  xlCellTypeLastCell = $0000000B;
var
  XLApp, Sheet: OLEVariant;
  RangeMatrix: Variant;
  x, y, k, r: Integer;
begin
  Result := False;
  // Create Excel-OLE Object
  XLApp := CreateOleObject('Excel.Application');
  try
    // Hide Excel
    XLApp.Visible := False;

    // Open the Workbook
    XLApp.Workbooks.Open(AXLSFile);

    // Sheet := XLApp.Workbooks[1].WorkSheets[1];
    Sheet := XLApp.Workbooks[ExtractFileName(AXLSFile)].WorkSheets[1];

    // In order to know the dimension of the WorkSheet, i.e the number of rows
    // and the number of columns, we activate the last non-empty cell of it

    Sheet.Cells.SpecialCells(xlCellTypeLastCell, EmptyParam).Activate;
    // Get the value of the last row
    x := XLApp.ActiveCell.Row;
    // Get the value of the last column
    y := XLApp.ActiveCell.Column;

    // Set Stringgrid's row &col dimensions.

    AGrid.RowCount := x;
    AGrid.ColCount := y;

    // Assign the Variant associated with the WorkSheet to the Delphi Variant

    RangeMatrix := XLApp.Range['A1', XLApp.Cells.Item[X, Y]].Value;
    //  Define the loop for filling in the TStringGrid
    k := 1;
    repeat
      for r := 1 to y do
        AGrid.Cells[(r - 1), (k - 1)] := RangeMatrix[K, R];
      Inc(k, 1);
      AGrid.RowCount := k + 1;
    until k > x;
    // Unassign the Delphi Variant Matrix
    RangeMatrix := Unassigned;

  finally
    // Quit Excel
    if not VarIsEmpty(XLApp) then
    begin
      // XLApp.DisplayAlerts := False;
      XLApp.Quit;
      XLAPP := Unassigned;
      Sheet := Unassigned;
      Result := True;
    end;
  end;
end;

function IsObjectActive(ClassName: string): Boolean;
var
  ClassID: TCLSID;
  Unknown: IUnknown;
begin
  try
    ClassID := ProgIDToClassID(ClassName);
    Result  := GetActiveObject(ClassID, nil, Unknown) = S_OK;
  except
    // raise;
    Result := False;
  end;
end;

type
  TDllRegisterServer = function: HResult; stdcall;

function RegisterOCX(FileName: string): Boolean;
var
  OCXHand: THandle;
  RegFunc: TDllRegisterServer;
begin
  OCXHand := LoadLibrary(PChar(FileName));
  regFunc := GetProcAddress(OCXHand, 'DllRegisterServer');
  if @RegFunc <> nil then
    Result := RegFunc = S_OK
  else
    Result := False;
  FreeLibrary(OCXHand);
end;

function UnRegisterOCX(FileName: string): Boolean;
var
  OCXHand: THandle;
  RegFunc: TDllRegisterServer;
begin
  OCXHand := LoadLibrary(PChar(FileName));
  regFunc := GetProcAddress(OCXHand, 'DllUnregisterServer');
  if @RegFunc <> nil then
    Result := RegFunc = S_OK
  else
    Result := False;
  FreeLibrary(OCXHand);
end;

function RegisterServer2(const aDllFileName: string; aRegister: Boolean): Boolean;
type
  TRegProc = function: HResult;
  stdcall;
const
  cRegFuncNameArr: array [Boolean] of PChar =
    ('DllUnregisterServer', 'DllRegisterServer');
var
  vLibHandle: THandle;
  vRegProc: TRegProc;
begin
  Result := False;
  vLibHandle := LoadLibrary(PChar(aDllFileName));
  if vLibHandle = 0 then Exit;
    @vRegProc := GetProcAddress(vLibHandle, cRegFuncNameArr[aRegister]);
  if @vRegProc <> nil then
    Result := vRegProc = S_OK;
  FreeLibrary(vLibHandle);
end;


{procedure mIRCDDE(Service, Topic, Cmd: string);
var
  DDE: TDDEClientConv;
begin
  try
    DDE := TDDEClientConv.Create(nil);
    DDE.SetLink(Service, Topic);
    DDE.OpenLink;
    DDE.PokeData(Topic, PChar(Cmd));
  finally
    DDE.Free;
  end;
end;

 }

 function OpenIE(aURL: string): boolean;
var
  IE:        Variant;
  WinHanlde: HWnd;
begin
  if (VarIsEmpty(IE)) then begin
    IE         := CreateOleObject('InternetExplorer.Application');
    IE.Visible := True;
    IE.Navigate(aURL);
  end
  else begin
    WinHanlde := FindWindow('IEFrame', nil);
    if (0 <> WinHanlde) then begin
      IE.Navigate(aURL);
      SetForegroundWindow(WinHanlde);
    end
    else
      result:= false; //wMessage('Can''t open IE !');
  end;
end;


 function XRTLIsInMainThread: Boolean;
begin
  Result:= GetCurrentThreadID = MainThreadID;
end;


procedure DetectImage(const InputFileName: string; BM: TBitmap);
var
  FS: TFileStream;
  FirstBytes: AnsiString;
  Graphic: TGraphic;
begin
  Graphic := nil;
  FS := TFileStream.Create(InputFileName, fmOpenRead);
  try
    SetLength(FirstBytes, 8);
    FS.Read(FirstBytes[1], 8);
    if Copy(FirstBytes, 1, 2) = 'BM' then begin
      Graphic := TBitmap.Create;
    end else
    if FirstBytes = #137'PNG'#13#10#26#10 then begin
      Graphic := TGraphic(TPngLoader.Create);
    end else
    if Copy(FirstBytes, 1, 3) =  'GIF' then begin
      //Graphic := TGIFImage.Create;
    end else
    if Copy(FirstBytes, 1, 2) = #$FF#$D8 then
    begin
      Graphic := TJPEGImage.Create;
    end;
    if Assigned(Graphic) then begin
      try
        FS.Seek(0, soBeginning);
        Graphic.LoadFromStream(FS);
        BM.Assign(Graphic);
      except
      end;
      
      Graphic.Free;
    end; 
  finally
    FS.Free;
  end;
end;

const
          BPP = 8; //Note: BYTES per pixel
         
        {---------------------------------------------------------}
        function BitmapToString(Bitmap: TBitmap): String;
        var
          x, y: Integer;
          S: String;
         
        begin
          S := '';
          for y := 0 to Bitmap.Height-1 do
            begin
              for x := 0 to Bitmap.Width-1 do
                begin
                  S := S + IntToHex(Bitmap.Canvas.Pixels[x,y], BPP);
                end;
              S := S + '\';
            end;
          Result := S;
        end;
        {---------------------------------------------------------}
        function StringToBitmap(S: String): TBitmap;
        var
          Bitmap: TBitmap;
          Line: String;
          P: Integer;
          x, y: Integer;
         
        begin
          Bitmap := TBitmap.Create;
          P := pos('\', S);
          Bitmap.Width := P div BPP;
          Bitmap.Height := 1;
         
          Line := Copy(S, 1, P-1);
          Delete(S, 1, P);
          x := 0;
          y := 0;
         
          While P <> 0 do
            begin
              if length(Line) <> 0 then
                begin
                  Bitmap.Canvas.Pixels[x, y] := StrToInt('$' + Copy(Line, 1, BPP));
                  Delete(Line, 1, BPP);
                  inc(x);
                end
              else
                begin
                  P := pos('\', S);
                  Line := Copy(S, 1, P-1);
                  Delete(S, 1, P);
                  inc(y);
                  Bitmap.Height := y+1;
                  x := 0;
                end;
            end;
          Bitmap.Height := Bitmap.Height - 1;
          Result := Bitmap;
        end;

   FUNCTION RemoveChar(CONST s: STRING; CONST c: CHAR): STRING;
  VAR i: INTEGER;
BEGIN
  RESULT := '';
  FOR i := 1 TO LENGTH(s) DO BEGIN
    IF   s[i] <> c
    THEN RESULT := RESULT + s[i]
  END
END {RemoveChar};

{                                                                              }
{ Secure clear helper function                                                 }
{   Securely clears a piece of memory before it is released to help prevent    }
{   sensitive information from being exposed.                                  }
{                                                                              }
procedure SecureClear(var Buffer; const BufferSize: Integer);
begin
  if BufferSize <= 0 then
    exit;
  FillChar(Buffer, BufferSize, $00);
end;

procedure SecureClearStr(var S: AnsiString);
var L : Integer;
begin
  L := Length(S);
  if L = 0 then
    exit;
  SecureClear(S[1], L);
  S := '';
end;

procedure movestring(const Source: string; var Destination: string; CopyCount : Integer );
begin
  move(source, destination, copycount)
end;

procedure moveint(const Source: integer; var destination: integer; CopyCount : Integer );
begin
  move(source, destination, copycount)
end;

procedure movebyte(const Source: byte; var destination: byte; CopyCount : Integer );
begin
  move(source, destination, copycount)
end;

procedure movefloat(const Source: double; var destination: double; CopyCount : Integer );
begin
  move(source, destination, copycount)
end;

procedure moveextended(const Source: extended; var destination: extended; CopyCount : Integer );
begin
  move(source, destination, copycount)
end;


function GetFileListDataObject(Files: TStrings): IDataObject;
type
  PArrayOfPItemIDList = ^TArrayOfPItemIDList;
  TArrayOfPItemIDList = array[0..0] of PItemIDList;
var
  Malloc: IMalloc;
  Root: IShellFolder;
  p: PArrayOfPItemIDList;
  chEaten, dwAttributes: ULONG;
  i, FileCount: Integer;
begin
  Result := nil;
  FileCount := Files.Count;
  if FileCount = 0 then Exit;

  OleCheck(SHGetMalloc(Malloc));
  OleCheck(SHGetDesktopFolder(Root));
  p := AllocMem(SizeOf(PItemIDList) * FileCount);
  try
    for i := 0 to FileCount - 1 do
      try
        if not (DirectoryExists(Files[i]) or FileExists(Files[i])) then Continue;
        OleCheck(Root.ParseDisplayName(GetActiveWindow,
          nil,
          PWideChar(WideString(Files[i])),
          chEaten,
          p^[i],
          dwAttributes));
      except
      end;
    OleCheck(Root.GetUIObjectOf(GetActiveWindow,
      FileCount,
      p^[0],
      IDataObject,
      nil,
      Pointer(Result)));
  finally
    for i := 0 to FileCount - 1 do
    begin
      if p^[i] <> nil then Malloc.Free(p^[i]);
    end;
    FreeMem(p);
  end;
end;

procedure ShowFilePropertiesSH(Files: TStrings; aWnd: HWND);
type
  PArrayOfPItemIDList = ^TArrayOfPItemIDList;
  TArrayOfPItemIDList = array[0..0] of PItemIDList;
var
  Data: IDataObject;
begin
  if Files.Count = 0 then Exit;
  Data := GetFileListDataObject(Files);
  SHMultiFileProperties(Data, 0);
end;

function GrabLine(const s: string; ALine: Integer): string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(s);
    Result := sl[ALine - 1]; // index off by one
  finally
    sl.Free;
  end;
end;

function GrabLineFast(const AFileName: string; ALine: Integer): string;
var
  fs: TFileStream;
  buf: packed array[0..4095] of Char;
  bufRead: Integer;
  bufPos: PChar;
  lineStart: PChar;
  tmp: string;
begin
  fs := TFileStream.Create(AFileName, fmOpenRead);
  try
    Dec(ALine);
    bufRead := 0;
    bufPos := nil;

    { read the first line specially }
    if ALine = 0 then
    begin
      bufRead := fs.Read(buf, SizeOf(buf));
      if bufRead = 0 then
        raise Exception.Create('Line not found');
      bufPos := buf;
    end else
      while ALine > 0 do
      begin
        { read in a buffer }
        bufRead := fs.Read(buf, SizeOf(buf));
        if bufRead = 0 then
          raise Exception.Create('Line not found');
        bufPos := buf;
        while (bufRead > 0) and (ALine > 0) do
        begin
          if bufPos^ = #10 then
            Dec(ALine);
          Inc(bufPos);
          Dec(bufRead);
        end;
      end;
    { Found the beginning of the line at bufPos... scan for end.
      2 cases:
        1) we'll find it before the end of this buffer
        2) it'll go beyond this buffer and into n more buffers }
    lineStart := bufPos;
    while (bufRead > 0) and (bufPos^ <> #10) do
    begin
      Inc(bufPos);
      Dec(bufRead);
    end;
    { if bufRead is positive, we'll have found the end and we can leave. }
    SetString(Result, lineStart, bufPos - lineStart);
    { determine if there are more buffers to process }
    while bufRead = 0 do
    begin
      bufRead := fs.Read(buf, SizeOf(buf));
      lineStart := buf;
      bufPos := buf;
      while (bufRead > 0) and (bufPos^ <> #10) do
      begin
        Inc(bufPos);
        Dec(bufRead);
      end;
      SetString(tmp, lineStart, bufPos - lineStart);
      Result := Result + tmp;
    end;
  finally
    fs.Free;
  end;
end; //*)

function IsTextFile(const sFile: TFileName): boolean;
//orig Created By Marcelo Castro - from Brazil

var
 oIn: TFileStream;
 iRead: Integer;
 iMaxRead: Integer;
 iData: Byte;
 dummy:string;
begin
 result:=true;
 dummy :='';
 oIn := TFileStream.Create(sFile, fmOpenRead or fmShareDenyNone);
 try
   iMaxRead := 1000;  //only text the first 1000 bytes
   if iMaxRead > oIn.Size then
     iMaxRead := oIn.Size;
   for iRead := 1 to iMaxRead do
   begin
     oIn.Read(iData, 1);
     if (idata) > 127 then result:=false;
   end;
 finally
   FreeAndNil(oIn);
 end;
end;

function getODBC: Tstringlist;
var
  n: Integer;
  List: TStringList;
  Reg: TRegistry;
  //ListBox1: TListbox;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey   := HKEY_CURRENT_USER;
    Reg.LazyWrite := False;
    Reg.OpenKey('Software\ODBC\ODBC.INI\ODBC Data Sources', False);
    List := TStringList.Create;
    Reg.GetValueNames(List);
    //ListBox1.Clear;
    //for n := 0 to List.Count - 1 do
      //ListBox1.Items.Add(List.Strings[n]);
      //  writeln(List.Strings[n]);
    result:= list;  
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function getODBCstring: string;
var
  n: Integer;
  List: TStringList;
  Reg: TRegistry;
begin
  Reg:= TRegistry.Create;
  try
    Reg.RootKey   := HKEY_CURRENT_USER;
    Reg.LazyWrite := False;
    Reg.OpenKey('Software\ODBC\ODBC.INI\ODBC Data Sources', False);
    List := TStringList.Create;
    Reg.GetValueNames(List);
    result:= list.text;
    Reg.CloseKey;
  finally
    Reg.Free;
    list.Free;
  end;
end;


 function ReadMWord(f: TFileStream): Word;
type
  TMotorolaWord = record
    case Byte of
      0: (Value: Word);
      1: (Byte1, Byte2: Byte);
  end;
var
  MW: TMotorolaWord;
begin
  { It would probably be better to just read these two bytes in normally }
  { and then do a small ASM routine to swap them.  But we aren't talking }
  { about reading entire files, so I doubt the performance gain would be }
  { worth the trouble. }
  f.read(MW.Byte2, SizeOf(Byte));
  f.read(MW.Byte1, SizeOf(Byte));
  Result := MW.Value;
end;

procedure GetJPGSize(const sFile: string; var wWidth, wHeight: Word);
const
  ValidSig: array[0..1] of Byte = ($FF, $D8);
  Parameterless = [$01, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7];
var
  Sig: array[0..1] of byte;
  f: TFileStream;
  x: integer;
  Seg: byte;
  Dummy: array[0..15] of byte;
  Len: word;
  ReadLen: LongInt;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  f := TFileStream.Create(sFile, fmOpenRead);
  try
    ReadLen := f.read(Sig[0], SizeOf(Sig));

    for x := Low(Sig) to High(Sig) do
      if Sig[x] <> ValidSig[x] then ReadLen := 0;

    if ReadLen > 0 then begin
      ReadLen := f.read(Seg, 1);
      while (Seg = $FF) and (ReadLen > 0) do
      begin
        ReadLen := f.read(Seg, 1);
        if Seg <> $FF then begin
          if (Seg = $C0) or (Seg = $C1) then begin
            ReadLen := f.read(Dummy[0], 3); { don't need these bytes }
            wHeight := ReadMWord(f);
            wWidth  := ReadMWord(f);
          end 
          else begin
            if not (Seg in Parameterless) then
            begin
              Len := ReadMWord(f);
              f.Seek(Len - 2, 1);
              f.read(Seg, 1);
            end 
            else
              Seg := $FF; { Fake it to keep looping. }
          end;
        end;
      end;
    end;
  finally
    f.Free;
  end;
end;

procedure GetPNGSize(const sFile: string; var wWidth, wHeight: Word);
type
  TPNGSig = array[0..7] of Byte;
const
  ValidSig: TPNGSig = (137,80,78,71,13,10,26,10);
var
  Sig: TPNGSig;
  f: tFileStream;
  x: integer;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  f := TFileStream.Create(sFile, fmOpenRead);
  try
    f.read(Sig[0], SizeOf(Sig));
    for x := Low(Sig) to High(Sig) do
      if Sig[x] <> ValidSig[x] then Exit;
    f.Seek(18, 0);
    wWidth := ReadMWord(f);
    f.Seek(22, 0);
    wHeight := ReadMWord(f);
  finally
    f.Free;
  end;
end;


procedure GetGIFSize(const sGIFFile: string; var wWidth, wHeight: Word);
type
  TGIFHeader = record
    Sig: array[0..5] of char;
    ScreenWidth, ScreenHeight: Word;
    Flags, Background, Aspect: Byte;
  end;

  TGIFImageBlock = record
    Left, Top, Width, Height: Word;
    Flags: Byte;
  end;
var
  f: file;
  Header: TGifHeader;
  ImageBlock: TGifImageBlock;
  nResult: integer;
  x: integer;
  c: char;
  DimensionsFound: boolean;
begin
  wWidth  := 0;
  wHeight := 0;

  if sGifFile = '' then
    Exit;

  {$I-}
  FileMode := 0;   { read-only }
  AssignFile(f, sGifFile);
  reset(f, 1);
  if IOResult <> 0 then
    { Could not open file }
    Exit;

  { Read header and ensure valid file. }
  BlockRead(f, Header, SizeOf(TGifHeader), nResult);
  if (nResult <> SizeOf(TGifHeader)) or (IOResult <> 0) or
    (StrLComp('GIF', Header.Sig, 3) <> 0) then
  begin
    { Image file invalid }
    Close(f);
    Exit;
  end;

  { Skip color map, if there is one }
  if (Header.Flags and $80) > 0 then
  begin
    x := 3 * (1 shl ((Header.Flags and 7) + 1));
    Seek(f, x);
    if IOResult <> 0 then
    begin
      { Color map thrashed }
      Close(f);
      Exit;
    end;
  end;

  DimensionsFound := False;
  FillChar(ImageBlock, SizeOf(TGIFImageBlock), #0);
  { Step through blocks. }
  BlockRead(f, c, 1, nResult);
  while (not EOF(f)) and (not DimensionsFound) do
  begin
    case c of
      ',': { Found image }
        begin
          BlockRead(f, ImageBlock, SizeOf(TGIFImageBlock), nResult);
          if nResult <> SizeOf(TGIFImageBlock) then 
          begin
            { Invalid image block encountered }
            Close(f);
            Exit;
          end;
          wWidth := ImageBlock.Width;
          wHeight := ImageBlock.Height;
          DimensionsFound := True;
        end;
      'ÿ': { Skip }
        begin
          { NOP }
        end;
      { nothing else.  just ignore }
    end;
    BlockRead(f, c, 1, nResult);
  end;
  Close(f);
  {$I+}
end;

function CPUSpd: String;
const
 DelayTime = 500; // measure time in ms
var
 TimerHi, TimerLo: DWORD;
 PriorityClass, Priority: Integer;
begin
    PriorityClass :=GetPriorityClass(GetCurrentProcess);
    Priority := GetThreadPriority(GetCurrentThread);
    SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS);
    SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_TIME_CRITICAL);

    Sleep(10);

    asm
       dw 310Fh // rdtsc
       mov TimerLo, eax
       mov TimerHi, edx
    end;

    Sleep(DelayTime);

    asm
       dw 310Fh // rdtsc
       sub eax, TimerLo
       sbb edx, TimerHi
       mov TimerLo, eax
       mov TimerHi, edx
    end;

    SetThreadPriority(GetCurrentThread, Priority);
    SetPriorityClass(GetCurrentProcess, PriorityClass);
    Result := IntToStr(Round(TimerLo / (1000.0 * DelayTime)));
end;


 {function BigFib(n: integer): string;
  var tbig1, tbig2, tbig3: TInteger;
  begin
    result:= '0'
    tbig1:= TInteger.create(1);  //temp
    tbig2:= TInteger.create(0);  //result (a)
    tbig3:= Tinteger.create(1);  //b
    for it:= 1 to n do begin
    	tbig1.assign(tbig2)
	   tbig2.assign(tbig3);
	   tbig1.add(tbig3);
	   tbig3.assign(tbig1);
	 end;
    result:= tbig2.tostring(false)
    tbig3.free;
    tbig2.free;
    tbig1.free;
  end;
  }

  function UpTime: string;
var t: Longword;
  d, h, m, s: Integer;
  ticksperday, ticksperhour: Integer;
  ticksperminute, tickspersecond: Integer;
  B2X: byte;
begin
  ticksperday:= 1000 * 60 * 60 * 24;
  ticksperhour:= 1000 * 60 * 60;
  ticksperminute:= 1000 * 60;
  tickspersecond:= 1000;
  t := GetTickCount;
  d := t div ticksperday;
  t:=t- d * ticksperday;
  h := t div ticksperhour;
  //Dec(t, h * ticksperhour);
  t:= t- h * ticksperhour;
  m := t div ticksperminute;
  //Dec(t, m * ticksperminute);
  t:= t- m * ticksperminute;
  s := t div tickspersecond;
  Result := 'OS Uptime: ' + IntToStr(d) + ' Days ' + IntToStr(h) + ' Hours ' + IntToStr(m) +
    ' Minutes ' + IntToStr(s) + ' Seconds';
end;

CONST WM_SETTINGCHANGE = $001A;

procedure BroadcastChange;
var
    lParam, wParam : Integer;   {Integers that indicate pointers to parameters}
    Buf     : Array[0..10] of Char; {Buffer used to indicate what setting we have changed.}
    aResult : Cardinal;         {Error Number returned from API Call}
begin
    {Now comes the interesting part.}
    {Environment is the section of global settings we want the system to update}
     Buf := 'Environment';
     wParam := 0;
     {This gives us a pointer to the Buffer for Windows to read.}
     lParam := Integer(@Buf[0]);

     {Here we make a call to SendMessageTimeout to Broadcast a message to the
     entire system telling every application (including explorer) to update
     its settings}
     SendMessageTimeout(HWND_BROADCAST ,
                        WM_SETTINGCHANGE ,
                        wParam,
                        lParam,
                        SMTO_NORMAL	,
                        4000,
                        aResult);

     {Display windows lasterror if the result is an error.}
     if aResult <> 0 then
     begin
         SysErrorMessage(aResult);
     end;
end;


procedure RaiseWindowsError;
begin

{$IFDEF DELPHI_6_ABOVE}
 RaiseLastOSError;
{$ELSE}
 RaiseLastWin32Error;
{$ENDIF}

end;

procedure InitializeSecurity(var SA: TSecurityAttributes);
var
  sd: PSecurityDescriptor;
begin

  // Allocate memory for the security descriptor
  sd := AllocMem(SECURITY_DESCRIPTOR_MIN_LENGTH);

  // Initialize the new security descriptor
  if InitializeSecurityDescriptor(sd, SECURITY_DESCRIPTOR_REVISION) then
  begin
    // Add a NULL descriptor ACL to the security descriptor
    if SetSecurityDescriptorDacl(sd, True, nil, False) then
    begin
      // Set up the security attributes structure
      SA.nLength := SizeOf(TSecurityAttributes);
      SA.lpSecurityDescriptor := sd;
      SA.bInheritHandle := True;
    end
    else
      // Failed to init the sec descriptor
      RaiseWindowsError;
      //SysErrorMessage
  end
  else
    // Failed to init the sec descriptor
    RaiseWindowsError;

end;

procedure FinalizeSecurity(var SA: TSecurityAttributes);
begin

  // Release memory that was assigned to security descriptor
  if Assigned(SA.lpSecurityDescriptor) then
  begin
    // Reource protection
    try
      // Free memory
      FreeMem(SA.lpSecurityDescriptor);
    finally
      // Clear pointer
      SA.lpSecurityDescriptor := nil;
    end;
  end;

end;

procedure ClearOverlapped(var Overlapped: TOverlapped; ClearEvent: Boolean =
 False);
begin
 
// Check to see if all fields should be clered
 if ClearEvent then
 // Clear whole structure
 FillChar(Overlapped, SizeOf(Overlapped), 0)
 else
 begin
 // Clear all fields except for the event handle
 Overlapped.Internal := 0;
 Overlapped.InternalHigh := 0;
 Overlapped.Offset := 0;
 Overlapped.OffsetHigh := 0;
 end;
 
end;

function IsHandle(Handle: THandle): Boolean;
begin
// Determine if a valid handle (only by value)
 result := not ((Handle = 0) or (Handle = INVALID_HANDLE_VALUE));
end;

 
procedure CloseHandleClear(var Handle: THandle);
begin
 
// Resource protection
 try
 // Check for invalid handle or zero
 if IsHandle(Handle) then
 CloseHandle(Handle);
 finally
 // Set to invalid handle
 Handle := INVALID_HANDLE_VALUE;
 end;
 
end;

type HPIPE = THandle;

 
procedure DisconnectAndClose(Pipe: HPIPE; IsServer: Boolean = True);
begin
 
// Check handle
 if IsHandle(Pipe) then
 begin
 // Resource protection
 try
 // Cancel overlapped IO on the handle
 CancelIO(Pipe);
 // Flush file buffer
 FlushFileBuffers(Pipe);
 // Disconnect the server end of the named pipe if flag is set
 if IsServer then
 DisconnectNamedPipe(Pipe);
 finally
 // Close the pipe handle
 CloseHandle(Pipe);
 end;
 end;
 
end;
 

procedure FlushMessages;
var
 lpMsg : TMsg;
begin
 
// Flush the message queue for the calling thread
 while PeekMessage(lpMsg, 0, 0, 0, PM_REMOVE) do
 begin
 // Translate the message
 TranslateMessage(lpMsg);
 // Dispatch the message
 DispatchMessage(lpMsg);
 // Allow other threads to run
 Sleep(0);
 end;
 
end;
 

function ComputerName2: string;
var
 dwSize : DWORD;
begin
 
// Set max size
 dwSize := Succ(MAX_PATH);
 
// Resource protection
 try
 // Set string length
 SetLength(result, dwSize);
 // Attempt to get the computer name
 if not (GetComputerName(@result[1], dwSize)) then
 dwSize := 0;
 finally
 // Truncate string
 SetLength(result, dwSize);
 end;
end;

 procedure BitmapToMetafile(const Bmp: Graphics.TBitmap;
  const EMF: Graphics.TMetafile);
var
  MetaCanvas: Graphics.TMetafileCanvas; // canvas for drawing on metafile
begin
  EMF.Height := Bmp.Height;
  EMF.Width := Bmp.Width;
  MetaCanvas := Graphics.TMetafileCanvas.Create(EMF, 0);
  try
    MetaCanvas.Draw(0, 0, Bmp);
  finally
    MetaCanvas.Free;
  end;
end;

procedure SendKeyVar(AppName: string; key: Variant);
var
  lParam: integer;
  scancode: integer;
  H: HWND;
  const
  MAPVK_VK_TO_VSC = 0;  // parameter passed to MapVirtualKey
begin
  H := FindWindow(PChar(AppName), nil);
  if (VarType(key) = varString) then begin
    scancode := MapVirtualKey(Ord(VarToStr(key)[1]), MAPVK_VK_TO_VSC);
    lParam := scancode shl 16;
    PostMessage(H, WM_KEYDOWN, scancode, lParam);
    PostMessage(H, WM_KEYUP, scancode, lParam);
  end else begin
    lParam := MapVirtualKey(key, MAPVK_VK_TO_VSC) shl 16;
    PostMessage(H, WM_KEYDOWN, key, lParam);
    PostMessage(H, WM_KEYUP, key, lParam);
  end;
end;

type
  TPassThroughData = record
      nLen: Word;
      Data: array[0..255] of Byte;
  end;

procedure PrintText2Printer(s: string);
var
  PTBlock: TPassThroughData;
begin
  PTBlock.nLen := Length(s);
  StrPCopy(@PTBlock.Data, s);
  Escape(Printer.Handle, PASSTHROUGH, 0, @PTBlock, nil);
end;


function LinkerTimeStamp(const FileName: string): TDateTime; //overload;
var
  LI: TLoadedImage;
begin
  Win32Check(MapAndLoad(PChar(FileName), nil, @LI, False, True));
  Result := LI.FileHeader.FileHeader.TimeDateStamp / SecsPerDay + UnixDateDelta;
  UnMapAndLoad(@LI);
end;

const
 MAX_NAME = 256;

 resourcestring
 resBadPipeName = 'Invalid pipe name specified!';

 type
 EPipeException = class(Exception);

procedure CheckPipeName(Value: string);
begin
 
// Validate the pipe name
 if (Pos('\', Value) > 0) or (Length(Value) > MAX_NAME) or (Length(Value) =
 0) then
 raise EPipeException.CreateRes(@resBadPipeName);
 
end;

 ///////////////////////////////////////////////////////////////////////////////
// Object instance functions
////////////////////////////////////////////////////////////////////////////////
//function AllocateHWnd(Method: TWndMethod): HWND;
//procedure DeallocateHWnd(Wnd: HWND);

var InstCritSect : TRTLCriticalSection;

ObjWndClass : TWndClass = (
 style: 0;
 lpfnWndProc: @DefWindowProc;
 cbClsExtra: 0;
 cbWndExtra: 0;
 hInstance: 0;
 hIcon: 0;
 hCursor: 0;
 hbrBackground: 0;
 lpszMenuName: nil;
 lpszClassName: 'ObjWndWindow'
 );

function AllocateHWnd(Method: TWndMethod): HWND;
var
 clsTemp : TWndClass;
 bClassReg : Boolean;
begin
 
// Enter critical section
 EnterCriticalSection(InstCritSect);
 
// Resource protection
 try
 // Set instance handle
 ObjWndClass.hInstance := HInstance;
 // Attempt to get class info
 bClassReg := GetClassInfo(HInstance, ObjWndClass.lpszClassName, clsTemp);
 // Ensure the class is registered and the window procedure is the default window proc
 if not (bClassReg) or not (clsTemp.lpfnWndProc = @DefWindowProc) then
 begin
 // Unregister if already registered
 if bClassReg then
 Windows.UnregisterClass(ObjWndClass.lpszClassName,
 HInstance);
 // Register
 Windows.RegisterClass(ObjWndClass);
 end;
 // Create the window
 result := CreateWindowEx(0, ObjWndClass.lpszClassName, '', WS_POPUP, 0,
 0, 0, 0, 0, 0, HInstance, nil);
 // Set method pointer
 if Assigned(Method) then
 SetWindowLong(result, GWL_WNDPROC,
 Longint(MakeObjectInstance(Method)));
 finally
 // Leave critical section
 LeaveCriticalSection(InstCritSect);
 end;
 
end;
 
procedure DeallocateHWnd(Wnd: HWND);
var
 Instance : Pointer;
begin
 
// Enter critical section
 EnterCriticalSection(InstCritSect);
 
// Resource protection
 try
 // Get the window procedure
 Instance := Pointer(GetWindowLong(Wnd, GWL_WNDPROC));
 // Resource protection
 try
 // Destroy the window
 DestroyWindow(Wnd);
 finally
 // If not the default window procedure then free the object instance
 if Assigned(Instance) and not (Instance = @DefWindowProc) then
 FreeObjectInstance(Instance);
 end;
 finally
 // Leave critical section
 LeaveCriticalSection(InstCritSect);
 end;
end;
 
function CharSetToCP(ACharSet: TFontCharSet): Integer;
begin
  case ACharset of
    1: Result := 0; //Default
    2: Result := 42; //Symbol
    77: Result := 10000; //Mac Roman
    78: Result := 10001; //Mac Shift Jis
    79: Result := 10003; //Mac Hangul
    80: Result := 10008; //Mac GB2312
    81: Result := 10002; //Mac Big5
    83: Result := 10005; //Mac Hebrew
    84: Result := 10004; //Mac Arabic
    85: Result := 10006; //Mac Greek
    86: Result := 10081; //Mac Turkish
    87: Result := 10021; //Mac Thai
    88: Result := 10029; //Mac East Europe
    89: Result := 10007; //Mac Russian
    128: Result := 932; //Shift JIS
    129: Result := 949; //Hangul
    130: Result := 1361; //Johab
    134: Result := 936; //GB2312
    136: Result := 950; //Big5
    161: Result := 1253; //Greek
    162: Result := 1254; //Turkish
    163: Result := 1258; //Vietnamese
    177: Result := 1255; //Hebrew
    178: Result := 1256; //Arabic
    186: Result := 1257; //Baltic
    204: Result := 1251; //Russian
    222: Result := 874; //Thai
    238: Result := 1250; //Eastern European
    254: Result := 437; //PC 437
    255: Result := 850; //OEM
  else
    Result := SystemCodePage; //system default
  end;
end;

function CPToCharSet(ACodePage: Integer): TFontCharSet;
begin
  case ACodePage of
    0: Result := 1; //Default
    42: Result := 2; //Symbol
    10000: Result := 77; //Mac Roman
    10001: Result := 78; //Mac Shift Jis
    10003: Result := 79; //Mac Hangul
    10008: Result := 80; //Mac GB2312
    10002: Result := 81; //Mac Big5
    10005: Result := 83; //Mac Hebrew
    10004: Result := 84; //Mac Arabic
    10006: Result := 85; //Mac Greek
    10081: Result := 86; //Mac Turkish
    10021: Result := 87; //Mac Thai
    10029: Result := 88; //Mac East Europe
    10007: Result := 89; //Mac Russian
    932: Result := 128; //Shift JIS
    949: Result := 129; //Hangul
    1361: Result := 130; //Johab
    936: Result := 134; //GB2312
    950: Result := 136; //Big5
    1253: Result := 161; //Greek
    1254: Result := 162; //Turkish
    1258: Result := 163; //Vietnamese
    1255: Result := 177; //Hebrew
    1256: Result := 178; //Arabic
    1257: Result := 186; //Baltic
    1251: Result := 204; //Russian
    874: Result := 222; //Thai
    1250: Result := 238; //Eastern European
    437: Result := 254; //PC 437
    850: Result := 255; //OEM
  else
    Result := 0; //ANSI
  end;
end;


function TwipsToPoints(AValue: Integer): Integer;
begin
  Result := DivUp(AValue, 20);
end;

function PointsToTwips(AValue: Integer): Integer;
begin
  Result := AValue * 20;
end;


procedure LoadGraphicFromResource(Graphic: TGraphic; const ResName: string; ResType: PChar);
{$IFNDEF FPC}
var
  Stream: TResourceStream;
{$ENDIF}
begin
  if Graphic <> nil then
  try
  {$IFDEF FPC}
    Graphic.LoadFromLazarusResource(ResName);
  {$ELSE}
    Stream := TResourceStream.Create(HInstance, ResName, ResType);
    try
      Graphic.LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  {$ENDIF}
  except
    Error('sErrGraphicsLoadFromResource');
  end;
end;

procedure SaveGraphicToStream(Graphic: TGraphic; Stream: TStream);
   var
     L: Word;
     S: String;
   begin
   S := Graphic.ClassName;
   L := Length(S);
   Stream.Write(L, SizeOf(L));
   Stream.Write(S[1], Length(S));
   Graphic.SaveToStream(Stream) end;

 function LoadGraphicFromStream(Stream: TStream): TGraphic;
   var
     GraphicClass: TGraphicClass;
     L: Word;
     S: String;
   begin
   Stream.Read(L, SizeOf(L));
   SetLength(S, L);
   Stream.Read(S[1], Length(S));
  // GraphicClass := FindClass(S) as TGraphicClass;
  GraphicClass := TGraphicClass(GetClass(S));
  // GraphicClass := FindClass(S) as TGraphicClass;

   Result := GraphicClass.Create;
   Result.LoadFromStream(Stream) end;

   procedure CopyStreamToFile(S: TStream; F: THandle);
   var
     BytesWritten: DWord;
     Buf: array[0..8191] of Byte;
     NumBytes: DWord;
   begin
   while S.Position < S.Size do begin
     NumBytes := S.Size - S.Position;
     if NumBytes > SizeOf(Buf) then
       NumBytes := SizeOf(Buf);
     S.Read(Buf, NumBytes);
     WriteFile(F, Buf, NumBytes, BytesWritten, nil)
     end
   end;

   PROCEDURE GetPelsPerMeter(CONST  Bitmap:  TBitmap;
                            VAR xPelsPerMeter, yPelsPerMeter:  INTEGER);
    VAR
      BitmapHeader:  pBitmapInfo;
      BitmapImage :  POINTER;
      HeaderSize  :  DWORD;
      ImageSize   :  DWORD;
  BEGIN
    GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
    GetMem(BitmapHeader, HeaderSize);
    GetMem(BitmapImage,  ImageSize);
    TRY
      GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);

      xPelsPerMeter := BitmapHeader^.bmiHeader.biXPelsPerMeter;
      yPelsPerMeter := BitmapHeader^.bmiHeader.biYPelsPerMeter;
    FINALLY
      FreeMem(BitmapHeader);
      FreeMem(BitmapImage)
    END
  END {GetPelsPerMeter};

  function GetNewGUID: string;
var
  NewGUID: TGUID;
begin
  // create GUID
  CreateGUID(NewGUID);
  Result := GUIDToString(NewGUID);
end;

function FormatGUID(const GUID: string): string;
var
  I: Integer;
  TempStr: string;
const
  RemoveSet = [#123, #125, #45];
begin
  for I := 1 to length(GUID) do
  begin
    if not (AnsiChar(GUID[I]) in RemoveSet) then
      Tempstr := Tempstr + GUID[I];
  end;
  Result := TempStr;
end;

function GetNewFormatedGUID: string;
begin
  Result := FormatGUID(GetNewGUID);
end;


function SubstringCount (Substring : string; Str : string): Integer;
var Offset : Integer;
begin
 Result := 0;
  while Pos(Substring, Str) <> 0 do
  begin
  Result := Result + 1;
  Offset := Pos(Substring, Str);
  Str := RightStr(Str, Length(Str) - Offset);
  end;
end;

type TStringArray = array of string;

function SplitStr(sInput:string; Delimiter:string): TStringArray;
 {By Viotto - Infos on http://viotto-security.net
 Based off Steve10120's Split function}
 var
  DelimPos:     Cardinal;
  LastDelimPos: Cardinal;
  StartIndex:   Cardinal;
  ElemCount:    Cardinal;
  sTemp:        string;
begin
  StartIndex := 1;
  ElemCount := 0;
  repeat
    sTemp := Copy(sInput, StartIndex, Length(sInput));
    DelimPos := Pos(Delimiter, sTemp);
    if DelimPos > 0 then
         LastDelimPos := DelimPos - 1
    else LastDelimPos := Length(sTemp);

    sTemp := Copy(sInput, StartIndex, LastDelimPos);
    SetLength(Result, Length(Result) + 1);
    Result[ElemCount] := sTemp;
    StartIndex := StartIndex + Length(sTemp) + Length(Delimiter);
    ElemCount := ElemCount + 1;
  until DelimPos = 0;

end;

function GetDataFromFile2(sFileName: AnsiString): AnsiString;
 var
DataFile: TFileStream;
ReadBuffer: array of Byte;
sDataToSend: AnsiString;
begin
  try
     DataFile := TFileStream.Create( sFileName , fmOpenRead);
     SetLength(ReadBuffer, DataFile.Size);
     DataFile.Read(ReadBuffer[0], Length(ReadBuffer));
    SetString(sDataToSend,PAnsiChar(@ReadBuffer[0]), DataFile.Size); //Copy byte array to string
     DataFile.Free;
     Result := sDataToSend;
  except
    Result := '';
  end;
end;


function ExtractFileNameWithoutExt(const FileName: string): string;
begin
Result := ChangeFileExt(ExtractFileName(FileName), '');
end;


const   RegContentType = 'MIME\Database\Content Type';   {V7.25}


function ContentTypeGetExtn(Const Content: String; var CLSID: String): string;
begin
    result := '';
    CLSID := '';
    if LowerCase(Content) = 'application/octet-stream' then exit;
    with TRegistry.Create do
    try
        RootKey := HKEY_CLASSES_ROOT;
        if NOT OpenKeyReadOnly(RegContentType + '\' + LowerCase(Content)) then exit;
        result := LowerCase (ReadString('Extension'));
        CLSID := ReadString('CLSID');
    finally
        Free
    end
end;

{ V7.25 Get registered MIME Content Type from file extension }
function ContentTypeFromExtn(Const Extension: String): string;
begin
    result := '';
    if Pos ('.', Extension) <> 1 then exit;
    with TRegistry.Create do
    try
        RootKey := HKEY_CLASSES_ROOT;
        if NOT OpenKeyReadOnly('\' + LowerCase (Extension)) then exit;
        result := LowerCase (ReadString('Content Type'));
        if result = '' then result := 'application/octet-stream';
    finally
        Free
    end
end;

function DateTimeDiff2(Start, Stop : TDateTime) : int64;
var TimeStamp : TTimeStamp;
begin
  TimeStamp := DateTimeToTimeStamp(Stop - Start);
  Dec(TimeStamp.Date, TTimeStamp(DateTimeToTimeStamp(0)).Date);
  Result := (TimeStamp.Date*24*60*60)+(TimeStamp.Time div 1000);
end;

function VarByteArrayOf(const s: string): OleVariant;
var Data: Pointer; //Pointer;
begin
    //Create variant byte array to hold the bytes
    Result := VarArrayCreate([0, Length(s)-1], varByte);
    //Copy from Delphi array to Variant Array
    if Length(s) > 0 then begin
        Data := VarArrayLock(Result);
        try
            System.Move(s[1], Data^, Length(s));
            //s:= data;
        finally
            VarArrayUnlock(Result);
        end;
    end;
end;

function CreateDisplayDC: Windows.HDC;
begin
  Result := Windows.CreateDC('DISPLAY', nil, nil, nil);
end;


function MaxWidthOfStrings(const Strings: Classes.TStrings;
  const Font: Graphics.TFont): Integer;
var
  TextW: Integer;           // stores width of each string in list
  Idx: Integer;             // loops thru all string in list
  Canvas: Graphics.TCanvas; // canvas used to measure text
begin
  Assert(Assigned(Font));
  Assert(Assigned(Strings));
  // Intialise
  Result := 0;
  if Strings.Count = 0 then
    Exit;
  // Create canvas used to measure text
  Canvas := Graphics.TCanvas.Create;
  try
    Canvas.Handle := CreateDisplayDC;
    try
      Canvas.Font := Font;
      // Measure each string's width and record widest in pixels
      for Idx := 0 to Strings.Count - 1 do
      begin
        TextW := Canvas.TextWidth(Strings[Idx]);
        if TextW > Result then
          Result := TextW;
      end;
    finally
      // Tidy up
      Windows.DeleteDC(Canvas.Handle);
      Canvas.Handle := 0;
    end;
  finally
    Canvas.Free;
  end;
end;


procedure ScreenShotMonitor(var Bitmap: TBitmap; const MonitorNum: Integer;
                           const DrawCursor: Boolean; const Quality: TPixelFormat);
var
  DC: HDC;
  C: TCanvas;
  R: TRect;
  CursorInfo: TCursorInfo;
  Icon: TIcon;
  IconInfo: TIconInfo;
  M: TMonitor;
  CP: TPoint;
begin
  M:= Screen.Monitors[MonitorNum];
  DC:= GetDC(GetDesktopWindow);
  try
    C:= TCanvas.Create;
    try
      C.Handle:= DC;
      R:= M.BoundsRect;
      Bitmap.Width:= M.Width;
      Bitmap.Height:= M.Height;
      Bitmap.PixelFormat:= Quality;
      Bitmap.Canvas.CopyRect(Rect(0,0,M.Width,M.Height), C, R);
    finally
      C.Free;
    end;
  finally
    ReleaseDC(GetDesktopWindow, DC);
  end;
  if DrawCursor then begin
    R:= Bitmap.Canvas.ClipRect;
    Icon:= TIcon.Create;
    try
      CursorInfo.cbSize:= SizeOf(CursorInfo);
      if GetCursorInfo(CursorInfo) then
      if CursorInfo.Flags = CURSOR_SHOWING then begin
        Icon.Handle:= CopyIcon(CursorInfo.hCursor);
        if GetIconInfo(Icon.Handle, IconInfo) then begin
          CP:= CursorInfo.ptScreenPos;
          CP.X:= CP.X - M.Left;
          CP.Y:= CP.Y - M.Top;
          Bitmap.Canvas.Draw(
            CP.X - Integer(IconInfo.xHotspot) - R.Left,
            CP.Y - Integer(IconInfo.yHotspot) - R.Top,
            Icon);
        end;
      end;
    finally
      Icon.Free;
    end;
  end;
end;

const
 MSG_BUFF_SIZE = 4096;
 FILE_DEVICE_UNKNOWN   = $00000022;
 {$EXTERNALSYM FILE_DEVICE_UNKNOWN}
 FILE_READ_ACCESS    = $0001;           // file & pipe
  {$EXTERNALSYM FILE_READ_ACCESS}
  FILE_WRITE_ACCESS   = $0002;           // file & pipe
  {$EXTERNALSYM FILE_WRITE_ACCESS}
 // const
  METHOD_BUFFERED   = 0;
  {$EXTERNALSYM METHOD_BUFFERED}

 BASE_IOCTL = (FILE_DEVICE_UNKNOWN shl 16) or (FILE_READ_ACCESS shl 14) or METHOD_BUFFERED;
 IOCTL_GET_MESSAGES          = BASE_IOCTL  or (11 shl 2);
 IOCTL_SET_SWAPCONTEXT_HOOK  = BASE_IOCTL  or (1 shl 2);
 IOCTL_SWAPCONTEXT_UNHOOK    = BASE_IOCTL  or (2 shl 2);
 IOCTL_SET_SYSCALL_HOOK      = BASE_IOCTL  or (3 shl 2);
 IOCTL_SYSCALL_UNHOOK        = BASE_IOCTL  or (4 shl 2);
 THREAD_BASIC_INFO      = $0;
 THREAD_QUERY_INFORMATION = $40;
 ProcessBasicInformation = 0;

 var
 hDriver: dword = 0;

function DrvGetLogString(): string;
var
 Buff: array[0..MSG_BUFF_SIZE] of Char;
 Bytes: dword;
begin
  if DeviceIoControl(hDriver, IOCTL_GET_MESSAGES, nil, 0, @Buff, MSG_BUFF_SIZE, Bytes, nil)
   then Result := Buff else Result := '';
end;

function SetSyscallHook(): boolean;
var
 Bytes: dword;
begin
 Result := DeviceIoControl(hDriver, IOCTL_SET_SYSCALL_HOOK, nil, 0, nil, 0, Bytes, nil);
end;

function SetSwapcontextHook(): boolean;
var
 Bytes: dword;
begin
 Result := DeviceIoControl(hDriver, IOCTL_SET_SWAPCONTEXT_HOOK, nil, 0, nil, 0, Bytes, nil);
end;

 function UnhookAll(): boolean;
var
 Bytes: dword;
begin
 Result := DeviceIoControl(hDriver, IOCTL_SWAPCONTEXT_UNHOOK, nil, 0, nil, 0, Bytes, nil) and
           DeviceIoControl(hDriver, IOCTL_SYSCALL_UNHOOK,     nil, 0, nil, 0, Bytes, nil);

end;

function ColorToWebStr(aColor:TColor): String;
var
  r1,g1,b1: Integer;
begin
  r1 := (aColor shr 16) and $FF;
  g1 := (aColor shr 8) and $FF;
  b1 := (aColor shr 0) and $FF;
  Result := '#' + InttoHex(r1,8) + inttoHex(g1,8) + inttoHex(b1,8);
end;

function RGBToColor(aRed,aGreen,aBlue: Integer):TColor;
begin
  Result := aBlue or (aGreen shl 8) or (aRed shl 16);
end;

procedure RichEditToCanvas(RichEdit: TRichEdit; Canvas: TCanvas; PixelsPerInch: Integer);
var
  ImageCanvas: TCanvas;
  fmt: TFormatRange;
begin
  ImageCanvas := Canvas;
  with fmt do
  begin
    hdc:= ImageCanvas.Handle;
    hdcTarget:= hdc;
    // rect needs to be specified in twips (1/1440 inch) as unit
    rc:=  Rect(0, 0,
                ImageCanvas.ClipRect.Right * 1440 div PixelsPerInch,
                ImageCanvas.ClipRect.Bottom * 1440 div PixelsPerInch
              );
    rcPage:= rc;
    chrg.cpMin := 0;
    chrg.cpMax := RichEdit.GetTextLen;
  end;
  SetBkMode(ImageCanvas.Handle, TRANSPARENT);
  RichEdit.Perform(EM_FORMATRANGE, 1, Integer(@fmt));
  // next call frees some cached data
  RichEdit.Perform(EM_FORMATRANGE, 0, 0);
end;

procedure LoadResourceFile3HTML(aFile:string; ms:TMemoryStream);
var
   HResInfo: HRSRC;
   HGlobal: THandle;
   Buffer, GoodType : pchar;
   I: integer;
   Ext:string;
begin
  ext:=uppercase(extractfileext(aFile));
  ext:=copy(ext,2,length(ext));
  if ext='HTM' then ext:='HTML';
  Goodtype:=pchar(ext);
  aFile:=changefileext(afile,'');
  HResInfo := FindResource(HInstance, pchar(aFile), GoodType);
  HGlobal := LoadResource(HInstance, HResInfo);
  if HGlobal = 0 then
     raise EResNotFound.Create('Can''t load resource: '+aFile);
  Buffer := LockResource(HGlobal);
  ms.clear;
  ms.WriteBuffer(Buffer[0], SizeOfResource(HInstance, HResInfo));
  ms.Seek(0,0);
  UnlockResource(HGlobal);
  FreeResource(HGlobal);
end;

function VarArrayToStr(const vArray: variant): string;

    function _VarToStr(const V: variant): string;
    var
    Vt: integer;
    begin
    Vt := VarType(V);
        case Vt of
          varSmallint,
          varInteger  : Result := IntToStr(integer(V));
          varSingle,
          varDouble,
          varCurrency : Result := FloatToStr(Double(V));
          varDate     : Result := VarToStr(V);
          varOleStr   : Result := WideString(V);
          varBoolean  : Result := VarToStr(V);
          varVariant  : Result := VarToStr(Variant(V));
          varByte     : Result := char(byte(V));
          varString   : Result := String(V);
          varArray    : Result := VarArrayToStr(Variant(V));
        end;
    end;

var
i : integer;
begin
    Result := '[';
     if (VarType(vArray) and VarArray)=0 then
       Result := _VarToStr(vArray)
    else
    for i := VarArrayLowBound(vArray, 1) to VarArrayHighBound(vArray, 1) do
     if i=VarArrayLowBound(vArray, 1)  then
      Result := Result+_VarToStr(vArray[i])
     else
      Result := Result+'|'+_VarToStr(vArray[i]);

    Result:=Result+']';
end;

function VarStrNull(const V:OleVariant):string; //avoid problems with null strings
begin
  Result:='';
  if not VarIsNull(V) then
  begin
    if VarIsArray(V) then
       Result:=VarArrayToStr(V)
    else
    Result:=VarToStr(V);
  end;
end;

function GetWMIObject(const objectName: String): IDispatch; //create the Wmi instance
var
  chEaten: Integer;
  BindCtx: IBindCtx;
  Moniker: IMoniker;
begin
  OleCheck(CreateBindCtx(0, bindCtx));
  OleCheck(MkParseDisplayName(BindCtx, StringToOleStr(objectName), chEaten, Moniker));
  OleCheck(Moniker.BindToObject(BindCtx, nil, IDispatch, Result));
end;

function GetAntiVirusProductInfo: TStringlist;
var
 objWMIService : OLEVariant;
 colItems      : OLEVariant;
 colItem       : OLEVariant;
 oEnum         : IEnumvariant;
 iValue        : LongWord;
begin;
 objWMIService := GetWMIObject('winmgmts:\\localhost\root\SecurityCenter2');

 result:= TStringlist.create;
 colItems      := objWMIService.ExecQuery('SELECT * FROM AntiVirusProduct','WQL',0);
 oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
 while oEnum.Next(1, colItem, iValue) = 0 do
 begin
   result.add(Format('displayName                    %s',[VarStrNull(colItem.displayName)]));// String
   result.add(Format('instanceGuid                   %s',[VarStrNull(colItem.instanceGuid)]));// String
   result.add(Format('pathToSignedProductExe         %s',[VarStrNull(colItem.pathToSignedProductExe)]));// String
   result.add(Format('pathToSignedReportingExe       %s',[VarStrNull(colItem.pathToSignedReportingExe)]));// String
   result.add(Format('productState                   %s',[VarStrNull(colItem.productState)]));// Uint32
   result.add('---');
 end;
end;

//https://stackoverflow.com/questions/23024402/enumresourcenames-returns-windows-error-998-invalid-access-to-memory-location


function IS_INTRESOURCE(lpszType: PChar): BOOL;
begin
  Result := ULONG_PTR(lpszType) shr 16 = 0;
end;

function ResourceNameToString(lpszName: PChar): string;
begin
  if Is_IntResource(lpszName) then
    Result := '#' + IntToStr(NativeUInt(lpszName))
  else
    Result := lpszName;
end;

function ResourceTypeToString(lpszType: PChar): string;
begin
  case NativeUInt(lpszType) of
  NativeUInt(RT_CURSOR):
    Result := 'RT_CURSOR';
  NativeUInt(RT_BITMAP):
    Result := 'RT_BITMAP';
  NativeUInt(RT_RCDATA):
    Result := 'RT_RCDATA';
  // etc.
  else
    Result := ResourceNameToString(lpszType);
  end;
end;

procedure storeRCDATAResourcetofile(aresname, afilename: string);
var
  ResStream: TResourceStream;
begin
  ResStream := TResourceStream.Create(HInstance, aresname, RT_RCDATA);
  try
    ResStream.Position := 0;
    ResStream.SaveToFile(afilename);
  finally
    ResStream.Free;
  end;
end;

 procedure GetComponentNames(lst: TStrings);
var
  i, k: Integer;
  CRef: TClass;
  strName: ShortString;
begin
  lst.Clear;
  for i := 0 to ToolServices.GetModuleCount-1 do begin
    for k := 0 to ToolServices.GetComponentCount(i)-1 do begin
       CRef := TClass(GetClass(ToolServices.GetComponentName(i, k)));
       while CRef <> nil do begin
         strName := CRef.ClassName;
         if lst.IndexOf(strName) = -1 then
           lst.Add(strName);
         if strName <> 'TComponent' then
          CRef := CRef.ClassParent
         else
           CRef := nil;
       end;
      end;
  end;
end;

procedure AngleTextOut(ACanvas: TCanvas; Angle, X, Y: Integer; Str: string);
var
  LogRec: TLogFont;
  OldFontHandle,
  NewFontHandle: hFont;
begin
  GetObject(ACanvas.Font.Handle, SizeOf(LogRec), Addr(LogRec));
  LogRec.lfEscapement := Angle*10;
  NewFontHandle := CreateFontIndirect(LogRec);
  OldFontHandle := SelectObject(ACanvas.Handle, NewFontHandle);
  ACanvas.TextOut(X, Y, Str);
  NewFontHandle := SelectObject(ACanvas.Handle, OldFontHandle);
  DeleteObject(NewFontHandle);
end;

procedure LoadJPEGResource(image1: TImage; aJpgImage: string);
var
  RS: TResourceStream;
  JPGImage: TJPEGImage;
begin
  JPGImage := TJPEGImage.Create;
  try
    RS := TResourceStream.Create(hInstance, aJpgImage, RT_RCDATA);
    try
      JPGImage.LoadFromStream(RS);
      Image1.Picture.Graphic := JPGImage;
    finally
      RS.Free;
    end;
  finally
    JPGImage.Free;
  end;
end;

 {----------------------------CreateDOSProcessRedirected---------------------------
 Description    : executes a (DOS!) app defined in the CommandLine parameter redirected
                  to take input from InputFile and give output to OutputFile
 Result         : True on success
 Parameters     :
                  CommandLine : the command line for the app, including its full path
                  InputFile   : the ascii file where from the app takes input
                  OutputFile  : the ascii file to which the app's output is redirected
                  ErrMsg      : additional error message string. Can be empty
 Error checking : YES
 Target         : Delphi 2, 3, 4
 Author         : Theodoros Bebekis, email bebekis@otenet.gr
 Notes          :
 Example call   : CreateDOSProcessRedirected('C:\MyDOSApp.exe',
                                             'C:\InputPut.txt',
                                             'C:\OutPut.txt',
                                             'Please, record this message')
-----------------------------------------------------------------------------------}

type TCursor = -32768..32767;

   const crHourGlass: TCursor = -11;

function CreateDOSProcessRedirected3(const CommandLine, InputFile, OutputFile, ErrMsg: string): Boolean;
const
  ROUTINE_ID = '[function: CreateDOSProcessRedirected ]';
var
  OldCursor: TCursor;

  pCommandLine: array[0..MAX_PATH] of Char;
  pInputFile, pOutPutFile: array[0..MAX_PATH] of Char;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  SecAtrrs: TSecurityAttributes;
  hAppProcess, hAppThread, hInputFile, hOutputFile: THandle;
begin
  Result := False;

  { check for InputFile existence }
  if not FileExists(InputFile) then
    raise Exception.CreateFmt(ROUTINE_ID + #10 + #10 +
      'Input file * %s *' + #10 +
      'does not exist' + #10 + #10 +
      ErrMsg, [InputFile]);

  { save the cursor }
  OldCursor     := Screen.Cursor;
  Screen.Cursor := crHourglass;

  { copy the parameter Pascal strings to null terminated strings }
  StrPCopy(pCommandLine, CommandLine);
  StrPCopy(pInputFile, InputFile);
  StrPCopy(pOutPutFile, OutputFile);

  try

    { prepare SecAtrrs structure for the CreateFile calls
      This SecAttrs structure is needed in this case because
      we want the returned handle can be inherited by child process
      This is true when running under WinNT.
      As for Win95 the documentation is quite ambiguous }
    FillChar(SecAtrrs, SizeOf(SecAtrrs), #0);
    SecAtrrs.nLength        := SizeOf(SecAtrrs);
    SecAtrrs.lpSecurityDescriptor := nil;
    SecAtrrs.bInheritHandle := True;

    { create the appropriate handle for the input file }
    hInputFile := CreateFile(pInputFile,
      { pointer to name of the file }
      GENERIC_READ or GENERIC_WRITE,
      { access (read-write) mode }
      FILE_SHARE_READ or FILE_SHARE_WRITE,
      { share mode } @SecAtrrs,                             { pointer to security attributes }
      OPEN_ALWAYS,                           { how to create }
      FILE_ATTRIBUTE_TEMPORARY,              { file attributes }
      0);                                   { handle to file with attributes to copy }


    { is hInputFile a valid handle? }
    if hInputFile = INVALID_HANDLE_VALUE then
      raise Exception.CreateFmt(ROUTINE_ID + #10 + #10 +
        'WinApi function CreateFile returned an invalid handle value' +
        #10 +
        'for the input file * %s *' + #10 + #10 +
        ErrMsg, [InputFile]);

    { create the appropriate handle for the output file }
    hOutputFile := CreateFile(pOutPutFile,
      { pointer to name of the file }
      GENERIC_READ or GENERIC_WRITE,
      { access (read-write) mode }
      FILE_SHARE_READ or FILE_SHARE_WRITE,
      { share mode } @SecAtrrs,                             { pointer to security attributes }
      CREATE_ALWAYS,                         { how to create }
      FILE_ATTRIBUTE_TEMPORARY,              { file attributes }
      0);                                   { handle to file with attributes to copy }

    { is hOutputFile a valid handle? }
    if hOutputFile = INVALID_HANDLE_VALUE then
      raise Exception.CreateFmt(ROUTINE_ID + #10 + #10 +
        'WinApi function CreateFile returned an invalid handle value' +
        #10 +
        'for the output file * %s *' + #10 + #10 +
        ErrMsg, [OutputFile]);

    { prepare StartupInfo structure }
    FillChar(StartupInfo, SizeOf(StartupInfo), #0);
    StartupInfo.cb          := SizeOf(StartupInfo);
    StartupInfo.dwFlags     := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
    StartupInfo.wShowWindow := SW_HIDE;
    StartupInfo.hStdOutput  := hOutputFile;
    StartupInfo.hStdInput   := hInputFile;

    { create the app }
    Result := CreateProcess(nil,                           { pointer to name of executable module }
      pCommandLine,
      { pointer to command line string }
      nil,                           { pointer to process security attributes }
      nil,                           { pointer to thread security attributes }
      True,                          { handle inheritance flag }
      CREATE_NEW_CONSOLE or
      REALTIME_PRIORITY_CLASS,       { creation flags }
      nil,                           { pointer to new environment block }
      nil,                           { pointer to current directory name }
      StartupInfo,                   { pointer to STARTUPINFO }
      ProcessInfo);                  { pointer to PROCESS_INF }

    { wait for the app to finish its job and take the handles to free them later }
    if Result then
    begin
      WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      hAppProcess := ProcessInfo.hProcess;
      hAppThread  := ProcessInfo.hThread;
    end
    else
      raise Exception.Create(ROUTINE_ID + #10 + #10 +
        'Function failure' + #10 + #10 +
        ErrMsg);

  finally
    { close the handles
      Kernel objects, like the process and the files we created in this case,
      are maintained by a usage count.
      So, for cleaning up purposes we have to close the handles
      to inform the system that we don't need the objects anymore }
    if hOutputFile <> 0 then CloseHandle(hOutputFile);
    if hInputFile <> 0 then CloseHandle(hInputFile);
    if hAppThread <> 0 then CloseHandle(hAppThread);
    if hAppProcess <> 0 then CloseHandle(hAppProcess);
    { restore the old cursor }
    Screen.Cursor := OldCursor;
  end;
end;

function GetUrlContent(const Url: string): UTF8String;
var
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1023] of byte;
  BytesRead: dWord;
  StrBuffer: UTF8String;
begin
  Result := '';
  NetHandle := InternetOpen('Delphi 2009', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(NetHandle) then
    try
      UrlHandle := InternetOpenUrl(NetHandle, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);
      if Assigned(UrlHandle) then
        try
          repeat
            InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
            SetString(StrBuffer, PAnsiChar(@Buffer[0]), BytesRead);
            Result := Result + StrBuffer;
          until BytesRead = 0;
        finally
          InternetCloseHandle(UrlHandle);
        end
      else
        raise Exception.CreateFmt('Cannot open URL %s', [Url]);
    finally
      InternetCloseHandle(NetHandle);
    end
  else
    raise Exception.Create('Unable to initialize Wininet');
end;

{******************************************************************************}
function DownloadArchive( sURL, sArchivoLocal: String ): boolean;
const BufferSize = 1024;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  LongitudBuffer: DWORD;
  F: File;
  sMiPrograma: String;
begin
  sMiPrograma := ExtractFileName( Application.ExeName );
  hSession := InternetOpen( PChar( sMiPrograma ), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0 );

  try
    hURL := InternetOpenURL( hSession, PChar( sURL ), nil, 0, 0, 0 );

    try
      AssignFile( F, sArchivoLocal );
      Rewrite( F, 1 );

      repeat
        InternetReadFile( hURL, @Buffer, SizeOf( Buffer ), LongitudBuffer );
        BlockWrite( F, Buffer, LongitudBuffer );
      until LongitudBuffer = 0;

      CloseFile( F );
      Result := True;
    finally
      InternetCloseHandle( hURL );
    end
  finally
    InternetCloseHandle( hSession );
  end
end;


(*
type
PPROCESS_BASIC_INFORMATION = ^PROCESS_BASIC_INFORMATION;
PROCESS_BASIC_INFORMATION = packed record
   ExitStatus: BOOL;
   PebBaseAddress: pointer;
   AffinityMask: PULONG;
   BasePriority: dword;
   UniqueProcessId: ULONG;
   InheritedFromUniqueProcessId: ULONG;
  end;

  PUnicodeString = ^TUnicodeString;
  TUnicodeString = packed record
    Length: Word;
    MaximumLength: Word;
    Buffer: PWideChar;
end;

 type
  PNtStatus = ^TNtStatus;
  NTSTATUS = LongInt;
  {$EXTERNALSYM NTSTATUS}
  TNtStatus = NTSTATUS;

  const STATUS_SUCCESS  = NTStatus($00000000);


Function ZwQueryInformationProcess(
                                ProcessHandle:THANDLE;
                                ProcessInformationClass:DWORD;
                                ProcessInformation:pointer;
                                ProcessInformationLength:ULONG;
                                ReturnLength: PULONG):NTStatus;stdcall;
                                external 'ntdll.dll';


function GetNameByPid(Pid: dword): string;
var
 hProcess, Bytes: dword;
 Info: PROCESS_BASIC_INFORMATION;
 ProcessParametres: pointer;
 ImagePath: TUnicodeString;
 ImgPath: array[0..MAX_PATH] of WideChar;
begin
 Result := '';
 ZeroMemory(@ImgPath, MAX_PATH * SizeOf(WideChar));
 hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, false, Pid);
 if ZwQueryInformationProcess(hProcess, ProcessBasicInformation, @Info,
                              SizeOf(PROCESS_BASIC_INFORMATION), nil) = STATUS_SUCCESS then
  begin
   if ReadProcessMemory(hProcess, pointer(dword(Info.PebBaseAddress) + $10),
                        @ProcessParametres, SizeOf(pointer), Bytes) and
      ReadProcessMemory(hProcess, pointer(dword(ProcessParametres) + $38),
                        @ImagePath, SizeOf(TUnicodeString), Bytes)  and
      ReadProcessMemory(hProcess, ImagePath.Buffer, @ImgPath,
                        ImagePath.Length, Bytes) then
        begin
          Result := ExtractFileName(WideCharToString(ImgPath));
        end;
   end;
 CloseHandle(hProcess);
end;     *)


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IPersistSettings(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IPersistSettings') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IPersistSettings, 'IPersistSettings') do
  begin
    RegisterMethod('Procedure Load( Storage : TPersistStorage)', cdRegister);
    RegisterMethod('Procedure Save( Storage : TPersistStorage)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PersistSettings(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStorageHandlerError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPersistStorage');
  SIRegister_IPersistSettings(CL);

  CL.AddConstantN('DI_MASK','LongInt').SetInt( 1);
 CL.AddConstantN('DI_IMAGE','LongInt').SetInt( 2);
 CL.AddConstantN('DI_NORMAL','LongInt').SetInt( 3);
 CL.AddConstantN('DI_COMPAT','LongInt').SetInt( 4);
 CL.AddConstantN('DI_DEFAULTSIZE','LongInt').SetInt( 8);
 CL.AddConstantN('ERROR_ALREADY_EXISTS','LongInt').SetInt(183);
 CL.AddConstantN('ERROR_INVALID_FLAG_NUMBER','LongInt').SetInt(186);
 CL.AddConstantN('RTL_CRITSECT_TYPE','LongInt').SetInt( 0);
 CL.AddConstantN('RTL_RESOURCE_TYPE','LongInt').SetInt( 1);
 CL.AddConstantN('DLL_PROCESS_ATTACH','LongInt').SetInt( 1);
 CL.AddConstantN('DLL_THREAD_ATTACH','LongInt').SetInt( 2);
 CL.AddConstantN('DLL_THREAD_DETACH','LongInt').SetInt( 3);
 CL.AddConstantN('DLL_PROCESS_DETACH','LongInt').SetInt( 0);
 CL.AddConstantN('ERROR_BAD_THREADID_ADDR','LongInt').SetInt( 159);
 CL.AddConstantN('ERROR_INVALID_THREAD_ID','LongInt').SetInt( 1444);
 //mouse.
  //7type
  //TStorageHandlerFunction = function:TPersistStorage;
  CL.AddTypeS('TStorageHandlerFunction', 'Function  : TPersistStorage');
  CL.AddTypeS('HPIPE', 'THandle');
  {CL.AddTypeS('_OVERLAPPED', 'record Internal : DWORD; InternalHigh : DWORD; Of'
   +'fset : DWORD; OffsetHigh : DWORD; hEvent : THandle; end');
  CL.AddTypeS('TOverlapped', '_OVERLAPPED');}
  CL.AddTypeS('TStorageHandlerMethod', 'Function  : TPersistStorage of Object');
 CL.AddDelphiFunction('Procedure SetStorageHandler( AFunction : TStorageHandlerFunction);');
 CL.AddDelphiFunction('Procedure SetStorageHandler1( AMethod : TStorageHandlerMethod);');
 CL.AddDelphiFunction('Function GetStorage : TPersistStorage');
 CL.AddDelphiFunction('Procedure SaveComponents( Root : TComponent; Storage : TPersistStorage)');
 CL.AddDelphiFunction('Procedure LoadComponents( Root : TComponent; Storage : TPersistStorage)');
 CL.AddDelphiFunction('Procedure AutoSave( Root : TComponent)');
 CL.AddDelphiFunction('Procedure AutoLoad( Root : TComponent)');
  CL.AddDelphiFunction('procedure FloatToDecimalE(var Result: TFloatRec; const Value: extended; ValueType: TFloatValue; Precision, Decimals: Integer);');
  CL.AddDelphiFunction('function FloatToTextE(BufferArg: PChar; const Value: extended; ValueType: TFloatValue; Format: TFloatFormat; Precision, Digits: Integer): Integer;');
  CL.AddDelphiFunction('Function GetSystemDefaultLCID : LCID');
 CL.AddDelphiFunction('Function GetUserDefaultLCID : LCID');
 CL.AddDelphiFunction('Function CreateMutex2( lpMutexAttributes : TObject; bInitialOwner : BOOL; lpName : PChar) : THandle');
  CL.AddDelphiFunction('Function CreateSemaphore2( lpSemaphoreAttributes : TObject; lInitialCount, lMaximumCount : Longint; lpName : PChar) : THandle');
 // CL.AddDelphiFunction('Function OpenEvent2( dwDesiredAccess : DWORD; bInheritHandle : BOOL; lpName : PChar) : THandle');

 CL.AddDelphiFunction('function getLastInput: DWord;');
 CL.AddDelphiFunction('procedure GetKLList(List: TStrings);');
 CL.AddDelphiFunction('procedure EnableCTRLALTDEL(YesNo : boolean);');
 CL.AddDelphiFunction('function LocalIP: string;');
 CL.AddDelphiFunction('function IPAddrToName(IPAddr: string): string;');
 CL.AddDelphiFunction('function GetIPFromHost(const HostName: string): string;');
 CL.AddDelphiFunction('function FindComputers(Computers : TStringList): DWORD;');

  CL.AddDelphiFunction('function GetWin32TypeLibList(var Lines: TStringList): Boolean;');
 CL.AddDelphiFunction('function RecurseWin32(const R: TRegistry; const ThePath: string; const TheKey: string): string;');
   CL.AddTypeS('Nanometers', 'Double');
 CL.AddConstantN('WavelengthMinimum','LongInt').SetInt( 380);
 CL.AddConstantN('WavelengthMaximum','LongInt').SetInt( 780);
 CL.AddDelphiFunction('Procedure WavelengthToRGB( const Wavelength : Nanometers; var R, G, B : BYTE)');
 CL.AddDelphiFunction('PROCEDURE RainbowColor(CONST fraction:  Double; VAR R,G,B:  BYTE);');


 CL.AddDelphiFunction('function GetCharFromVKey(vkey: Word): string;');
 CL.AddDelphiFunction('function Xls_To_StringGrid(AGrid: TStringGrid; AXLSFile: string): Boolean;');
 CL.AddDelphiFunction('function IsObjectActive(ClassName: string): Boolean;');
 CL.AddDelphiFunction('function GetActiveObject(ClassID: TGUID; anil: TObject; aUnknown: IUnknown): HRESULT;');

 CL.AddDelphiFunction('function RegisterOCX(FileName: string): Boolean;');
 CL.AddDelphiFunction('function UnRegisterOCX(FileName: string): Boolean;');
 CL.AddDelphiFunction('function RegisterServer2(const aDllFileName: string; aRegister: Boolean): Boolean;');
  CL.AddDelphiFunction('function OpenIE(aURL: string): boolean;');
  CL.AddDelphiFunction('function XRTLIsInMainThread: Boolean;');
  CL.AddDelphiFunction('function IsInMainThread: Boolean;');
  CL.AddDelphiFunction('Function DrawIconEx( hdc : HDC; xLeft, yTop : Integer; hIcon : HICON; cxWidth, cyWidth : Integer; istepIfAniCur : UINT; hbrFlickerFreeDraw : HBRUSH; diFlags : UINT) : BOOL');
 CL.AddDelphiFunction('Function CreateIconIndirect( var piconinfo : TIconInfo) : HICON');
 CL.AddDelphiFunction('Function CopyIcon( hIcon : HICON) : HICON');
 CL.AddDelphiFunction('Function GetIconInfo( hIcon : HICON; var piconinfo : TIconInfo) : BOOL');
CL.AddDelphiFunction('Function DlgDirSelectEx( hDlg : HWND; lpString : PChar; nCount, nIDListBox : Integer) : BOOL');
 CL.AddDelphiFunction('Function DlgDirListComboBox( hDlg : HWND; lpPathSpec : PChar; nIDComboBox, nIDStaticPath : Integer; uFiletype : UINT) : Integer');
 CL.AddDelphiFunction('Function DlgDirSelectComboBoxEx( hDlg : HWND; lpString : PChar; nCount, nIDComboBox : Integer) : BOOL');

  CL.AddDelphiFunction('procedure DetectImage(const InputFileName: string; BM: TBitmap)');
 CL.AddDelphiFunction('function BitmapToString(Bitmap: TBitmap): String;');
 CL.AddDelphiFunction('function StringToBitmap(S: String): TBitmap;');
 CL.AddDelphiFunction('FUNCTION RemoveChar(CONST s: STRING; CONST c: CHAR): STRING;');
 CL.AddDelphiFunction('Function DefFrameProc( hWnd, hWndMDIClient : HWND; uMsg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 CL.AddDelphiFunction('Function DefMDIChildProc( hWnd : HWND; uMsg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 CL.AddDelphiFunction('Function TranslateMDISysAccel( hWndClient : HWND; const lpMsg : TMsg) : BOOL');
 CL.AddDelphiFunction('Function ArrangeIconicWindows( hWnd : HWND) : UINT');
 //CL.AddDelphiFunction('Function CreateMDIWindow( lpClassName, lpWindowName : PChar; dwStyle : DWORD; X, Y, nWidth, nHeight : Integer; hWndParent : HWND; hInstance : HINST; lParam : LPARAM) : HWND');
 CL.AddDelphiFunction('procedure SecureClearStr(var S: AnsiString);');

 CL.AddDelphiFunction('procedure movestring(const Source: string; var Destination: string; CopyCount : Integer );');
 CL.AddDelphiFunction('procedure move(const Source: string; var Destination: string; CopyCount : Integer );');
 CL.AddDelphiFunction('procedure movestr(const Source: string; var Destination: string; CopyCount : Integer );');
  CL.AddDelphiFunction('procedure moveint(const Source: integer; var Destination: integer; CopyCount : Integer );');
  CL.AddDelphiFunction('procedure movefloat(const Source: double; var Destination: double; CopyCount : Integer );');
  CL.AddDelphiFunction('procedure ShowFilePropertiesSH(Files: TStrings; aWnd: HWND);');
  CL.AddDelphiFunction('procedure moveextended(const Source: extended; var Destination: extended; CopyCount : Integer );');
  CL.AddDelphiFunction('procedure movebyte(const Source: byte; var Destination: byte; CopyCount : Integer );');

  CL.AddDelphiFunction('function GrabLine(const s: string; ALine: Integer): string;');
 CL.AddDelphiFunction('function GrabLineFast(const s: string; ALine: Integer): string;');
 CL.AddDelphiFunction('function IsTextFile(const sFile: TFileName): boolean;');
 CL.AddDelphiFunction('function getODBC: Tstringlist;');
 CL.AddDelphiFunction('function getODBCstring: string;');

  CL.AddDelphiFunction('procedure GetJPGSize(const sFile: string; var wWidth, wHeight: Word);');
  CL.AddDelphiFunction('procedure GetPNGSize(const sFile: string; var wWidth, wHeight: Word);');
  CL.AddDelphiFunction('procedure GetGIFSize(const sGIFFile: string; var wWidth, wHeight: Word);');
  CL.AddDelphiFunction('function CPUSpd: String;');
  CL.AddDelphiFunction('function CPUSpeed: String;');
  CL.AddDelphiFunction('function UpTime: string;');
  CL.AddDelphiFunction('procedure BroadcastChange;');
 CL.AddDelphiFunction('procedure InitializeSecurity(var SA: TSecurityAttributes);');
 CL.AddDelphiFunction('procedure FinalizeSecurity(var SA: TSecurityAttributes);');
   CL.AddDelphiFunction('procedure RaiseWindowsError;');

  CL.AddDelphiFunction('procedure ClearOverlapped(var Overlapped: TOverlapped; ClearEvent: Boolean);');
  CL.AddDelphiFunction('procedure CloseHandleClear(var Handle: THandle);');
  CL.AddDelphiFunction('function ComputerName2: string;');
  CL.AddDelphiFunction('procedure DisconnectAndClose(Pipe: HPIPE; IsServer: Boolean);');
  CL.AddDelphiFunction('procedure FlushMessages;');
  CL.AddDelphiFunction('function IsHandle(Handle: THandle): Boolean;');
  CL.AddDelphiFunction('procedure CheckPipeName(Value: string)');
  CL.AddDelphiFunction('function AllocateHWnd(Method: TWndMethod): HWND;');
  CL.AddDelphiFunction('procedure DeallocateHWnd(Wnd: HWND);');
  CL.AddDelphiFunction('function CharSetToCP(ACharSet: TFontCharSet): Integer;');
  CL.AddDelphiFunction('function CPToCharSet(ACodePage: Integer): TFontCharSet;');
  CL.AddDelphiFunction('function TwipsToPoints(AValue: Integer): Integer;');
  CL.AddDelphiFunction('function PointsToTwips(AValue: Integer): Integer;');
  CL.AddDelphiFunction('procedure LoadGraphicFromResource(Graphic: TGraphic; const ResName: string; ResType: PChar);');

  CL.AddDelphiFunction('procedure SaveGraphicToStream(Graphic: TGraphic; Stream: TStream);');
  CL.AddDelphiFunction('function LoadGraphicFromStream(Stream: TStream): TGraphic;');
  CL.AddDelphiFunction('procedure CopyStreamToFile(S: TStream; F: THandle);');
 CL.AddDelphiFunction('PROCEDURE GetPelsPerMeter(CONST  Bitmap:  TBitmap; VAR xPelsPerMeter, yPelsPerMeter:  INTEGER);');
  CL.AddDelphiFunction('function GetNewGUID: string;');
  CL.AddDelphiFunction('function FormatGUID(const GUID: string): string;');
  CL.AddDelphiFunction('function GetNewFormatedGUID: string;');

  CL.AddDelphiFunction('function SplitStr(sInput:string; Delimiter:string): TStringArray;');
 CL.AddDelphiFunction('function GetDataFromFile2(sFileName: AnsiString): AnsiString;');
 CL.AddDelphiFunction('function ExtractFileNameWithoutExt(const FileName: string): string;');
 CL.AddDelphiFunction('function SubstringCount (Substring : string; Str : string): Integer;');

  CL.AddDelphiFunction('function ContentTypeGetExtn(Const Content: String; var CLSID: String): string;');
 CL.AddDelphiFunction('function ContentTypeFromExtn(Const Extension: String): string;');
 CL.AddDelphiFunction('function DateTimeDiff2(Start, Stop : TDateTime) : int64;');
 CL.AddDelphiFunction('Function GetLogicalDriveStrings( nBufferLength : DWORD; lpBuffer : PChar) : DWORD');
   CL.AddDelphiFunction('Function RealizePalette( DC : HDC) : UINT');
 CL.AddDelphiFunction('Function RemoveFontResource( FileName : PChar) : BOOL');
  CL.AddDelphiFunction('Function GetMenuString( hMenu : HMENU; uIDItem : UINT; lpString : PChar; nMaxCount : Integer; uFlag : UINT) : Integer');
 CL.AddDelphiFunction('Function GetMenuState( hMenu : HMENU; uId, uFlags : UINT) : UINT');
 CL.AddDelphiFunction('Function DrawMenuBar( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function GetSystemMenu( hWnd : HWND; bRevert : BOOL) : HMENU');
 CL.AddDelphiFunction('Function CreateMenu : HMENU');
 CL.AddDelphiFunction('Function CreatePopupMenu : HMENU');
 CL.AddDelphiFunction('function VarByteArrayOf(const s: string): OleVariant;');
 CL.AddDelphiFunction('Function SwitchToThread : BOOL');
 CL.AddDelphiFunction('Function SwitchDesktop( hDesktop : HDESK) : BOOL');
 CL.AddDelphiFunction('Function SetThreadDesktop( hDesktop : HDESK) : BOOL');
 CL.AddDelphiFunction('Function CloseDesktop( hDesktop : HDESK) : BOOL');
 CL.AddDelphiFunction('Function GetThreadDesktop( dwThreadId : DWORD) : HDESK');
CL.AddDelphiFunction('function DrvGetLogString(): string;');
 CL.AddDelphiFunction('function SetSyscallHook(): boolean;');
 CL.AddDelphiFunction('function SetSwapcontextHook(): boolean;');
 CL.AddDelphiFunction('function UnhookAll(): boolean;');
// CL.AddDelphiFunction('function GetNameByPid(Pid: dword): string;');

CL.AddDelphiFunction('function ColorToWebStr(aColor:TColor): String;');
CL.AddDelphiFunction('function RGBToColor(aRed,aGreen,aBlue: Integer):TColor;');
CL.AddDelphiFunction('procedure RichEditToCanvas(RichEdit: TRichEdit; Canvas: TCanvas; PixelsPerInch: Integer);');
CL.AddDelphiFunction('procedure BitmapToMetafile(const Bmp: TBitmap);');
CL.AddDelphiFunction('procedure LoadResourceFile3HTML(aFile:string; ms:TMemoryStream);');
CL.AddDelphiFunction('function VarArrayToStr(const vArray: variant): string;');
CL.AddDelphiFunction('function VarStrNull(const V:OleVariant):string;');
CL.AddDelphiFunction('function GetWMIObject(const objectName: String): IDispatch;');
CL.AddDelphiFunction('function GetAntiVirusProductInfo: TStringlist;');
CL.AddDelphiFunction('function IS_INTRESOURCE(lpszType: PChar): BOOL;');
CL.AddDelphiFunction('function ResourceNameToString(lpszName: PChar): string;');
CL.AddDelphiFunction('function ResourceTypeToString(lpszType: PChar): string;');
CL.AddDelphiFunction('procedure storeRCDATAResourcetofile(aresname, afilename: string);');
CL.AddDelphiFunction('procedure SendKeyVar(AppName: string; key: Variant);');
CL.AddDelphiFunction('procedure GetComponentNames(lst: TStrings);');
CL.AddDelphiFunction('procedure AngleTextOut(ACanvas: TCanvas; Angle, X, Y: Integer; Str: string);');
CL.AddDelphiFunction('procedure PrintText2Printer(s: string);');
CL.AddDelphiFunction('function LinkerTimeStamp(const FileName: string): TDateTime;');

CL.AddDelphiFunction('procedure LoadJPEGResource(image1: TImage; aJpgImage: string);');
CL.AddDelphiFunction('function CreateDOSProcessRedirected3(const CommandLine,InputFile,OutputFile,ErrMsg: string):Boolean;');

//function CreateDOSProcessRedirected3(const CommandLine, InputFile, OutputFile, ErrMsg: string): Boolean;
//LoadJPEGResource(image1: TImage; aJpgImage: string);


CL.AddDelphiFunction('function MaxWidthOfStrings(const Strings: TStrings; const Font: TFont): Integer;');
CL.AddDelphiFunction('procedure ScreenShotMonitor(var Bitmap: TBitmap; const MonitorNum: Integer; const DrawCursor: Boolean; const Quality: TPixelFormat);');
CL.AddDelphiFunction('function GetUrlContent(const Url: string): UTF8String;');
CL.AddDelphiFunction('function DownloadArchive( sURL, sArchivoLocal: String ): boolean;');


 // CL.AddDelphiFunction('Function RoundRect( DC : HDC; X1, Y1, X2, Y2, X3, Y3 : Integer) : BOOL');
 //CL.AddDelphiFunction('Function ResizePalette( Palette : HPALETTE; Entries : UINT) : BOOL');

  { Loads a custom mouse cursor. }
//procedure LoadCustomCursor(Cursor: TCursor; const ResName: string);

{ Loads graphic from resource. }
    //function AllocateHWnd(Method: TWndMethod): HWND;
//procedure DeallocateHWnd(Wnd: HWND);

  { procedure DetectImage(const InputFileName: string; BM: TBitmap);
    function BitmapToString(Bitmap: TBitmap): String;
      function StringToBitmap(S: String): TBitmap;
      FUNCTION RemoveChar(CONST s: STRING; CONST c: CHAR): STRING;
  }

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure SetStorageHandler1_P( AMethod : TStorageHandlerMethod);
Begin PersistSettings.SetStorageHandler(AMethod); END;

(*----------------------------------------------------------------------------*)
Procedure SetStorageHandler_P( AFunction : TStorageHandlerFunction);
Begin PersistSettings.SetStorageHandler(AFunction); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PersistSettings_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetStorageHandler, 'SetStorageHandler', cdRegister);
 S.RegisterDelphiFunction(@SetStorageHandler1_P, 'SetStorageHandler1', cdRegister);
 S.RegisterDelphiFunction(@GetStorage, 'GetStorage', cdRegister);
 S.RegisterDelphiFunction(@SaveComponents, 'SaveComponents', cdRegister);
 S.RegisterDelphiFunction(@LoadComponents, 'LoadComponents', cdRegister);
 S.RegisterDelphiFunction(@AutoSave, 'AutoSave', cdRegister);
 S.RegisterDelphiFunction(@AutoLoad, 'AutoLoad', cdRegister);
 S.RegisterDelphiFunction(@FloatToDecimalE, 'FloatToDecimalE', cdRegister);
 S.RegisterDelphiFunction(@FloatToTextE, 'FloatToTextE', cdRegister);
 S.RegisterDelphiFunction(@GetSystemDefaultLCID, 'GetSystemDefaultLCID', CdStdCall);
 S.RegisterDelphiFunction(@GetUserDefaultLCID, 'GetUserDefaultLCID', CdStdCall);
 S.RegisterDelphiFunction(@CreateMutex, 'CreateMutex2', CdStdCall);
 S.RegisterDelphiFunction(@CreateSemaphore, 'CreateSemaphore2', CdStdCall);

 S.RegisterDelphiFunction(@getLastInput, 'getLastInput', cdRegister);
 S.RegisterDelphiFunction(@GetKLList, 'getkeyboardlist2', cdRegister);
 S.RegisterDelphiFunction(@EnableCTRLALTDEL, 'EnableCTRLALTDEL', cdRegister);

 S.RegisterDelphiFunction(@LocalIP, 'LocalIP', cdRegister);
 S.RegisterDelphiFunction(@IPAddrToName, 'IPAddrToName', cdRegister);
 S.RegisterDelphiFunction(@GetIPFromHost, 'GetIPFromHost', cdRegister);
 S.RegisterDelphiFunction(@FindComputers, 'FindComputers', cdRegister);
 S.RegisterDelphiFunction(@GetWin32TypeLibList, 'GetWin32TypeLibList', cdRegister);
S.RegisterDelphiFunction(@RecurseWin32, 'RecurseWin32', cdRegister);
S.RegisterDelphiFunction(@WavelengthToRGB, 'WavelengthToRGB', cdRegister);
S.RegisterDelphiFunction(@GetCharFromVKey, 'GetCharFromVKey', cdRegister);
 S.RegisterDelphiFunction(@Xls_To_StringGrid, 'Xls_To_StringGrid', cdRegister);
 S.RegisterDelphiFunction(@IsObjectActive, 'IsObjectActive', cdRegister);
 S.RegisterDelphiFunction(@GetActiveObject, 'GetActiveObject', cdRegister);
 S.RegisterDelphiFunction(@RegisterOCX, 'RegisterOCX', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterOCX, 'UngisterOCX', cdRegister);
 S.RegisterDelphiFunction(@RegisterServer2, 'RegisterServer2', cdRegister);
 S.RegisterDelphiFunction(@OpenIE, 'OpenIE', cdRegister);
 S.RegisterDelphiFunction(@XRTLIsInMainThread, 'XRTLIsInMainThread', cdRegister);
 S.RegisterDelphiFunction(@XRTLIsInMainThread, 'IsInMainThread', cdRegister);
 S.RegisterDelphiFunction(@DrawIconEx, 'DrawIconEx', CdStdCall);
 S.RegisterDelphiFunction(@CreateIconIndirect, 'CreateIconIndirect', CdStdCall);
 S.RegisterDelphiFunction(@CopyIcon, 'CopyIcon', CdStdCall);
 S.RegisterDelphiFunction(@GetIconInfo, 'GetIconInfo', CdStdCall);
 S.RegisterDelphiFunction(@DlgDirSelectEx, 'DlgDirSelectEx', CdStdCall);
 S.RegisterDelphiFunction(@DlgDirListComboBox, 'DlgDirListComboBox', CdStdCall);
 S.RegisterDelphiFunction(@DlgDirSelectComboBoxEx, 'DlgDirSelectComboBoxEx', CdStdCall);

 S.RegisterDelphiFunction(@DetectImage, 'DetectImage', cdRegister);
 S.RegisterDelphiFunction(@BitmapToString, 'BitmapToString', cdRegister);
 S.RegisterDelphiFunction(@StringToBitmap, 'StringToBitmap', cdRegister);
 S.RegisterDelphiFunction(@RemoveChar, 'RemoveChar', cdRegister);
 S.RegisterDelphiFunction(@SecureClearStr, 'SecureClearStr', cdRegister);
 S.RegisterDelphiFunction(@movestring, 'movestring', cdRegister);
 S.RegisterDelphiFunction(@movestring, 'move', cdRegister);
 S.RegisterDelphiFunction(@movestring, 'movestr', cdRegister);
 S.RegisterDelphiFunction(@movebyte, 'movebyte', cdRegister);
S.RegisterDelphiFunction(@moveint, 'moveint', cdRegister);
S.RegisterDelphiFunction(@movefloat, 'movefloat', cdRegister);
S.RegisterDelphiFunction(@moveextended, 'moveextended', cdRegister);
S.RegisterDelphiFunction(@ShowFilePropertiesSH, 'ShowFilePropertiesSH', cdRegister);
S.RegisterDelphiFunction(@GrabLine, 'GrabLine', cdRegister);
S.RegisterDelphiFunction(@GrabLineFast, 'GrabLineFast', cdRegister);
S.RegisterDelphiFunction(@IsTextFile, 'IsTextFile', cdRegister);
S.RegisterDelphiFunction(@getODBC, 'getODBC', cdRegister);
S.RegisterDelphiFunction(@getODBC, 'getODBCList', cdRegister);
S.RegisterDelphiFunction(@getODBCstring, 'getODBCString', cdRegister);

S.RegisterDelphiFunction(@GetJPGSize, 'GetJPGSize', cdRegister);
S.RegisterDelphiFunction(@GetPNGSize, 'GetPNGSize', cdRegister);
S.RegisterDelphiFunction(@GetGIFSize, 'GetGIFSize', cdRegister);
S.RegisterDelphiFunction(@CPUSpd, 'CPUSpd', cdRegister);
S.RegisterDelphiFunction(@CPUSpd, 'CPUSpeed', cdRegister);
S.RegisterDelphiFunction(@Uptime, 'Uptime', cdRegister);
S.RegisterDelphiFunction(@BroadcastChange, 'BroadcastChange', cdRegister);
S.RegisterDelphiFunction(@RaiseWindowsError, 'RaiseWindowsError', cdRegister);
S.RegisterDelphiFunction(@InitializeSecurity, 'InitializeSecurity', cdRegister);
S.RegisterDelphiFunction(@FinalizeSecurity, 'FinalizeSecurity', cdRegister);
S.RegisterDelphiFunction(@CheckPipeName, 'CheckPipeName', cdRegister);
S.RegisterDelphiFunction(@ClearOverlapped, 'ClearOverlapped', cdRegister);
S.RegisterDelphiFunction(@CloseHandleClear, 'CloseHandleClear', cdRegister);
S.RegisterDelphiFunction(@ComputerName2, 'ComputerName2', cdRegister);
S.RegisterDelphiFunction(@FlushMessages, 'FlushMessages', cdRegister);
S.RegisterDelphiFunction(@DisconnectAndClose, 'DisconnectAndClose', cdRegister);
S.RegisterDelphiFunction(@IsHandle, 'IsHandle', cdRegister);
S.RegisterDelphiFunction(@AllocateHWnd, 'AllocateHWnd', cdRegister);
S.RegisterDelphiFunction(@DeallocateHWnd, 'DeallocateHWnd', cdRegister);
S.RegisterDelphiFunction(@CharSetToCP, 'CharSetToCP', cdRegister);
S.RegisterDelphiFunction(@CPToCharSet, 'CPToCharSet', cdRegister);
S.RegisterDelphiFunction(@TwipsToPoints, 'TwipsToPoints', cdRegister);
S.RegisterDelphiFunction(@PointsToTwips, 'PointsToTwips', cdRegister);
S.RegisterDelphiFunction(@LoadGraphicFromResource, 'LoadGraphicFromResource', cdRegister);

S.RegisterDelphiFunction(@SaveGraphicToStream, 'SaveGraphicToStream', cdRegister);
S.RegisterDelphiFunction(@LoadGraphicFromStream, 'LoadGraphicFromStream', cdRegister);
S.RegisterDelphiFunction(@CopyStreamToFile, 'CopyStreamToFile', cdRegister);
S.RegisterDelphiFunction(@GetPelsPerMeter, 'GetPelsPerMeter', cdRegister);
S.RegisterDelphiFunction(@RainbowColor, 'RainbowColor', cdRegister);
S.RegisterDelphiFunction(@GetNewGUID, 'GetNewGUID', cdRegister);
S.RegisterDelphiFunction(@FormatGUID, 'FormatGUID', cdRegister);
S.RegisterDelphiFunction(@GetNewFormatedGUID, 'GetNewFormatedGUID', cdRegister);
S.RegisterDelphiFunction(@LinkerTimeStamp, 'LinkerTimeStamp', cdRegister);


S.RegisterDelphiFunction(@SplitStr, 'SplitStr', cdRegister);
S.RegisterDelphiFunction(@GetDataFromFile2, 'GetDataFromFile2', cdRegister);
S.RegisterDelphiFunction(@ExtractFileNameWithoutExt, 'ExtractFileNameWithoutExt', cdRegister);
S.RegisterDelphiFunction(@SubstringCount, 'SubstringCount', cdRegister);
S.RegisterDelphiFunction(@ContentTypeGetExtn, 'ContentTypeGetExtn', cdRegister);
S.RegisterDelphiFunction(@ContentTypeFromExtn, 'ContentTypeFromExtn', cdRegister);
S.RegisterDelphiFunction(@DateTimeDiff2, 'DateTimeDiff2', cdRegister);
S.RegisterDelphiFunction(@VarByteArrayOf, 'VarByteArrayOf', cdRegister);
S.RegisterDelphiFunction(@VarByteArrayOf, 'VarByteArrayOf', cdRegister);
S.RegisterDelphiFunction(@ColorToWebStr, 'ColorToWebStr', cdRegister);
S.RegisterDelphiFunction(@RGBToColor, 'RGBToColor', cdRegister);
S.RegisterDelphiFunction(@RichEditToCanvas, 'RichEditToCanvas', cdRegister);
S.RegisterDelphiFunction(@BitmapToMetafile, 'BitmapToMetafile', cdRegister);
S.RegisterDelphiFunction(@LoadResourceFile3HTML, 'LoadResourceFile3HTML', cdRegister);
S.RegisterDelphiFunction(@VarArrayToStr, 'VarArrayToStr', cdRegister);
S.RegisterDelphiFunction(@VarStrNull, 'VarStrNull', cdRegister);
S.RegisterDelphiFunction(@GetWMIObject, 'GetWMIObject', cdRegister);
S.RegisterDelphiFunction(@IS_INTRESOURCE, 'IS_INTRESOURCE', cdRegister);
S.RegisterDelphiFunction(@GetAntiVirusProductInfo, 'GetAntiVirusProductInfo', cdRegister);
S.RegisterDelphiFunction(@ResourceNameToString, 'ResourceNameToString', cdRegister);
S.RegisterDelphiFunction(@ResourceTypeToString, 'ResourceTypeToString', cdRegister);
S.RegisterDelphiFunction(@storeRCDATAResourcetofile, 'storeRCDATAResourcetofile', cdRegister);
S.RegisterDelphiFunction(@SendKeyVar, 'SendKeyVar', cdRegister);
S.RegisterDelphiFunction(@GetComponentNames, 'GetComponentNames', cdRegister);
S.RegisterDelphiFunction(@AngleTextOut, 'AngleTextOut', cdRegister);
S.RegisterDelphiFunction(@PrintText2Printer, 'PrintText2Printer', cdRegister);
S.RegisterDelphiFunction(@PrintText2Printer, 'PrintText', cdRegister);
S.RegisterDelphiFunction(@MaxWidthOfStrings, 'MaxWidthOfStrings', cdRegister);
S.RegisterDelphiFunction(@ScreenShotMonitor, 'ScreenShotMonitor', cdRegister);
S.RegisterDelphiFunction(@LoadJPEGResource, 'LoadJPEGResource', cdRegister);
S.RegisterDelphiFunction(@CreateDOSProcessRedirected3, 'CreateDOSProcessRedirected3', cdRegister);
S.RegisterDelphiFunction(@GetUrlContent, 'GetUrlContent', cdRegister);
S.RegisterDelphiFunction(@DownloadArchive, 'DownloadArchive', cdRegister);

 S.RegisterDelphiFunction(@GetMenuString, 'GetMenuString', CdStdCall);
 S.RegisterDelphiFunction(@GetMenuState, 'GetMenuState', CdStdCall);
 S.RegisterDelphiFunction(@DrawMenuBar, 'DrawMenuBar', CdStdCall);
 S.RegisterDelphiFunction(@GetSystemMenu, 'GetSystemMenu', CdStdCall);
 S.RegisterDelphiFunction(@CreateMenu, 'CreateMenu', CdStdCall);
 S.RegisterDelphiFunction(@CreatePopupMenu, 'CreatePopupMenu', CdStdCall);
  S.RegisterDelphiFunction(@SwitchToThread, 'SwitchToThread', CdStdCall);
   S.RegisterDelphiFunction(@SwitchDesktop, 'SwitchDesktop', CdStdCall);
  S.RegisterDelphiFunction(@SetThreadDesktop, 'SetThreadDesktop', CdStdCall);
 S.RegisterDelphiFunction(@CloseDesktop, 'CloseDesktop', CdStdCall);
 S.RegisterDelphiFunction(@DrvGetLogString, 'DrvGetLogString', CdStdCall);
 S.RegisterDelphiFunction(@SetSyscallHook, 'SetSyscallHook', CdStdCall);
 S.RegisterDelphiFunction(@SetSwapcontextHook, 'SetSwapcontextHook', CdStdCall);
S.RegisterDelphiFunction(@UnhookAll, 'UnhookAll', CdStdCall);
//S.RegisterDelphiFunction(@GetNameByPid, 'GetNameByPid', CdStdCall);

  {function SetSyscallHook(): boolean;
 function SetSwapcontextHook(): boolean;
 function UnhookAll(): boolean;
 function GetNameByPid(Pid: dword): string;  }
   {function CharSetToCP(ACharSet: TFontCharSet): Integer;
function CPToCharSet(ACodePage: Integer): TFontCharSet;
function TwipsToPoints(AValue: Integer): Integer;
function PointsToTwips(AValue: Integer): Integer; }
  {procedure CheckPipeName(Value: string);
  procedure ClearOverlapped(var Overlapped: TOverlapped; ClearEvent: Boolean =
  procedure CloseHandleClear(var Handle: THandle);
 function ComputerName2: string;
procedure DisconnectAndClose(Pipe: HPIPE; IsServer: Boolean);
//procedure DisposePipeWrite(var PipeWrite: PPipeWrite);
///function EnumConsoleWindows(Window: HWND; lParam: Integer): BOOL; stdcall;
procedure FlushMessages;
function IsHandle(Handle: THandle): Boolean;   }
    {procedure RaiseWindowsError;
  procedure InitializeSecurity(var SA: TSecurityAttributes);
  procedure FinalizeSecurity(var SA: TSecurityAttributes);
   }
  { function GrabLine(const s: string; ALine: Integer): string;
function GrabLineFast(const s: string; ALine: Integer): string;
  function IsTextFile(const sFile: TFileName): boolean;
  function getODBC: Tstringlist;}
   //procedure movestring(const Source: string; var Destination: string; CopyCount : Integer );
  { procedure DetectImage(const InputFileName: string; BM: TBitmap);
    function BitmapToString(Bitmap: TBitmap): String;
      function StringToBitmap(S: String): TBitmap;
      FUNCTION RemoveChar(CONST s: STRING; CONST c: CHAR): STRING;
  }
  S.RegisterDelphiFunction(@DefFrameProc, 'DefFrameProc', CdStdCall);
 S.RegisterDelphiFunction(@DefMDIChildProc, 'DefMDIChildProc', CdStdCall);
 S.RegisterDelphiFunction(@TranslateMDISysAccel, 'TranslateMDISysAccel', CdStdCall);
 S.RegisterDelphiFunction(@ArrangeIconicWindows, 'ArrangeIconicWindows', CdStdCall);
 S.RegisterDelphiFunction(@GetLogicalDriveStrings, 'GetLogicalDriveStrings', CdStdCall);
 S.RegisterDelphiFunction(@RealizePalette, 'RealizePalette', CdStdCall);
 S.RegisterDelphiFunction(@RemoveFontResource, 'RemoveFontResource', CdStdCall);

 //function XRTLIsInMainThread: Boolean;
 //function OpenIE(aURL: string): boolean;
  //nction RegisterOCX(FileName: string): Boolean;
  //function IsObjectActive(ClassName: string): Boolean;
    //function Xls_To_StringGrid(AGrid: TStringGrid; AXLSFile: string): Boolean;
 //procedure EnableCTRLALTDEL(YesNo : boolean);
 //procedure GetKLList(List: TStrings);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PersistSettings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EStorageHandlerError) do
  with CL.Add(TPersistStorage) do
end;

{ TPSImport_PersistSettings }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PersistSettings.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PersistSettings(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PersistSettings.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PersistSettings(ri);
  RIRegister_PersistSettings_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)

end.
