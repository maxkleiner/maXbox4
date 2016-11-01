unit uPSI_UtilsMax4;
{
  coolcode4 toolbox maXbox   V2  V3 with hextobuf  V3 mX4.2.4.25
  more of nixutils integrated      - wininet sec routines   global_
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
  TPSImport_UtilsMax4 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdBaseComponent(CL: TPSPascalCompiler);
procedure SIRegister_UtilsMax4(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_UtilsMax4_Routines(S: TPSExec);
procedure RIRegister_TIdBaseComponent(CL: TPSRuntimeClassImporter);
procedure RIRegister_UtilsMax4(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   StringsW
  ,Windows
  ,Graphics
  ,StringUtils
  ,PsAPI
  ,TlHelp32
  ,Forms, controls
  ,UtilsMax4, nixutils, wininet, winsock, SHDocvw, OleCtrls, ActiveX, comobj, ADODB
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UtilsMax4]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdBaseComponent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TIdBaseComponent') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TIdBaseComponent') do
  begin
    RegisterMethod('Function GetVersion : string');
    RegisterProperty('Version', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
Function KeyboardStateToShiftState1_P( const KeyboardState : TKeyboardState) : TShiftState;
Begin Result := Forms.KeyboardStateToShiftState(KeyboardState); END;


function BufToHex1(const Buf: string; const Size: Cardinal): string;
begin
  result:= BufToHex(Buf, size);
end;

procedure HexToBuf1(HexStr: string; var Buf: string);
begin
  HexToBuf(HexStr, Buf);

end;

function GetCachedFileFromURL(strUL: string; var strLocalFile: string): boolean;
var
  lpEntryInfo: PInternetCacheEntryInfo;
  hCacheDir: LongWord;
  dwEntrySize: LongWord;
  dwLastError: LongWord;
begin
  Result := False;
  dwEntrySize := 0;
  // Begin the enumeration of the Internet cache.
  FindFirstUrlCacheEntry(nil, TInternetCacheEntryInfo(nil^), dwEntrySize);
  GetMem(lpEntryInfo, dwEntrySize);
  hCacheDir := FindFirstUrlCacheEntry(nil, lpEntryInfo^, dwEntrySize);
  if (hCacheDir <> 0) and (strUL = lpEntryInfo^.lpszSourceUrlName) then
  begin
    strLocalFile := lpEntryInfo^.lpszLocalFileName;
    Result := True;
  end;
  FreeMem(lpEntryInfo);
  if Result = False then
    repeat
      dwEntrySize := 0;
      // Retrieves the next cache group in a cache group enumeration
      FindNextUrlCacheEntry(hCacheDir, TInternetCacheEntryInfo(nil^), dwEntrySize);
      dwLastError := GetLastError();
      if (GetLastError = ERROR_INSUFFICIENT_BUFFER) then
      begin
        GetMem(lpEntryInfo, dwEntrySize);
        if (FindNextUrlCacheEntry(hCacheDir, lpEntryInfo^, dwEntrySize)) then
        begin
          if strUL = lpEntryInfo^.lpszSourceUrlName then
          begin
            strLocalFile := lpEntryInfo^.lpszLocalFileName;
            Result := True;
            Break;
          end;
        end;
        FreeMem(lpEntryInfo);
      end;
    until (dwLastError = ERROR_NO_MORE_ITEMS);
end;

function IAddrToHostName(const IP: string): string;
var
  i: Integer;
  p: PHostEnt;
begin
  Result := '';
  i      := inet_addr(PChar(IP));
  if i <> u_long(INADDR_NONE) then
  begin
    p := GetHostByAddr(@i, SizeOf(Integer), PF_INET);
    if p <> nil then Result := p^.h_name;
  end
  else
    Result := 'Invalid IP address';
end;


function GetIEHandle(WebBrowser: TWebbrowser; ClassName: string): HWND;
var
  hwndChild, hwndTmp: HWND;
  oleCtrl: TOleControl;
  szClass: array [0..255] of char;
begin
  oleCtrl :=WebBrowser;
  hwndTmp := oleCtrl.Handle;
  while (true) do
  begin
    hwndChild := GetWindow(hwndTmp, GW_CHILD);
    GetClassName(hwndChild, szClass, SizeOf(szClass));
    if (string(szClass)=ClassName) then
    begin
      Result :=hwndChild;
      Exit;
    end;
    hwndTmp := hwndChild;
  end;
  Result := 0;
end;


function GetTextFromHandle(WinHandle: THandle): string;
var
  P: array[0..256] of Char;
begin
  P[0] := #0;
  GetWindowText(WinHandle, P, 255);
  if P[0] = #0 then Result := ''
  else 
    Result := P;
end;

procedure Duplicate_Webbrowser(WB1, WB2: TWebbrowser);
var
  URL: string;
begin
  // get the URL of WB1
  URL := WB1.LocationURL;
  // navigate to the URL with WB2
  WB2.Navigate(URL);
  // wait until document loaded
  while (WB2.ReadyState <> READYSTATE_COMPLETE) and not (Application.Terminated) do
  begin
    Application.ProcessMessages;
    Sleep(0);
  end;
  // duplicate contents (i.e. user-entered text)
  //(WB2.Document).body.innerHTML :=
    //(WB1.Document as IHTMLDocument2).body.innerHTML;
    //    (WB1.Document).body.innerHTML;

    end;

  function FillWebForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean; 
var 
  i, j: Integer; 
  FormItem: Variant; 
begin 
  Result := False; 
  //no form on document 
  if WebBrowser.OleObject.Document.all.tags('FORM').Length = 0 then 
  begin 
    Exit; 
  end;
  //count forms on document 
  for I := 0 to WebBrowser.OleObject.Document.forms.Length - 1 do 
  begin 
    FormItem := WebBrowser.OleObject.Document.forms.Item(I); 
    for j := 0 to FormItem.Length - 1 do 
    begin 
      try 
        //when the fieldname is found, try to fill out 
        if FormItem.Item(j).Name = FieldName then 
        begin 
          FormItem.Item(j).Value := Value; 
          Result := True; 
        end; 
      except 
        Exit; 
      end; 
    end; 
  end; 
end;

procedure WB_LoadHTML(WebBrowser: TWebBrowser; HTMLCode: string);
var
  sl: TStringList;
  ms: TMemoryStream;
begin
  WebBrowser.Navigate('about:blank');
  while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
   Application.ProcessMessages;

  if Assigned(WebBrowser.Document) then
  begin
    sl := TStringList.Create;
    try
      ms := TMemoryStream.Create;
      try
        sl.Text := HTMLCode;
        sl.SaveToStream(ms);
        ms.Seek(0, 0);
        (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms));
      finally
        ms.Free;
      end;
    finally
      sl.Free;
    end;
  end;
end;


function NetSend(dest, Source, Msg: string): Longint; //overload;
type
  TNetMessageBufferSendFunction = function(servername, msgname, fromname: PWideChar;
    buf: PWideChar; buflen: Cardinal): Longint; 
  stdcall;
var
  NetMessageBufferSend: TNetMessageBufferSendFunction;
  SourceWideChar: PWideChar;
  DestWideChar: PWideChar;
  MessagetextWideChar: PWideChar;
  Handle: THandle;
begin
  Handle := LoadLibrary('NETAPI32.DLL');
  if Handle = 0 then
  begin
    Result := GetLastError;
    Exit;
  end;
    @NetMessageBufferSend := GetProcAddress(Handle, 'NetMessageBufferSend');
  if @NetMessageBufferSend = nil then
  begin
    Result := GetLastError;
    Exit;
  end;

  MessagetextWideChar := nil;
  SourceWideChar      := nil;
  DestWideChar        := nil;

  try
    GetMem(MessagetextWideChar, Length(Msg) * SizeOf(WideChar) + 1);
    GetMem(DestWideChar, 20 * SizeOf(WideChar) + 1);
    StringToWideChar(Msg, MessagetextWideChar, Length(Msg) * SizeOf(WideChar) + 1);
    StringToWideChar(Dest, DestWideChar, 20 * SizeOf(WideChar) + 1);

    if Source = '' then
      Result := NetMessageBufferSend(nil, DestWideChar, nil,
        MessagetextWideChar, Length(Msg) * SizeOf(WideChar) + 1)
    else
    begin
      GetMem(SourceWideChar, 20 * SizeOf(WideChar) + 1);
      StringToWideChar(Source, SourceWideChar, 20 * SizeOf(WideChar) + 1);
      Result := NetMessageBufferSend(nil, DestWideChar, SourceWideChar,
        MessagetextWideChar, Length(Msg) * SizeOf(WideChar) + 1);
      FreeMem(SourceWideChar);
    end;
  finally
    FreeMem(MessagetextWideChar);
    FreeLibrary(Handle);
  end;
end;

  function RecordsetToXML(const Recordset: _recordset): string;
var
  RS: Variant;
  Stream: TStringStream;
begin
  Result := '';
  if Recordset = nil then Exit;
  //if Recordset = null then Exit;
  //if Recordset = unassigned then Exit;
  Stream := TStringStream.Create('');
  try
    RS := CreateOleObject('ADODB.Recordset');
    RS := Recordset;
    RS.Save(TStreamAdapter.Create(stream,soReference) as IUnknown, $00000001);
    Stream.Position := 0;
    Result := Stream.DataString;
  finally
    Stream.Free;
  end;
end;

function RecordsetFromXML(const XML: string): _Recordset;
var
  RS: Variant;
  Stream: TStringStream;
begin
  Result := nil;
  if XML = '' then Exit;
  try
    Stream := TStringStream.Create(XML);
    Stream.Position := 0;
    RS := CreateOleObject('ADODB.Recordset');
    RS.Open(TStreamAdapter.Create(Stream,soReference) as IUnknown);
    Result := IUnknown(RS) as _Recordset;
  finally
    Stream.Free;
  end;
  //GetRecordset
end;

  function RecordsetToXML2(const Recordset: variant): string;
var
  RS: Variant;
  Stream: TStringStream;
begin
  Result := '';
  //if Recordset = nil then Exit;
  //if Recordset = null then Exit;
  //if Recordset = unassigned then Exit;
  Stream := TStringStream.Create('');
  try
    RS := CreateOleObject('ADODB.Recordset');
    RS := Recordset;
    RS.Save(TStreamAdapter.Create(stream,soReference) as IUnknown, $00000001);
    Stream.Position := 0;
    Result := Stream.DataString;
  finally
    Stream.Free;
  end;
end;

function RecordsetFromXML2(const XML: string): variant;
var
  RS: Variant;
  Stream: TStringStream;
begin
  Result := '';
  if XML = '' then Exit;
  try
    Stream := TStringStream.Create(XML);
    Stream.Position := 0;
    RS := CreateOleObject('ADODB.Recordset');
    RS.Open(TStreamAdapter.Create(Stream,soReference) as IUnknown);
    Result := IUnknown(RS) as _Recordset;
  finally
    Stream.Free;
  end;
  //GetRecordset
end;

procedure ActivateHint(Rect: TRect; const AHint: string; acontrol: TWinControl);
var FActivating: Boolean;
begin
 { FActivating := True;
  try
    //acontrol.Caption := AHint;
    //Höhe des Hints setzen setzen
    //Set the "Height" Property of the Hint
    Inc(Rect.Bottom, 14);
    //Breite des Hints setzen
    //Set the "Width" Property of the Hint
    Rect.Right := Rect.Right + 20;
    acontrol.UpdateBoundsRect(Rect);
    if Rect.Top + Height > Screen.DesktopHeight then
      Rect.Top := Screen.DesktopHeight - Height;
    if Rect.Left + Width > Screen.DesktopWidth then
      Rect.Left := Screen.DesktopWidth - Width;
    if Rect.Left < Screen.DesktopLeft then Rect.Left := Screen.DesktopLeft;
    if Rect.Bottom < Screen.DesktopTop then Rect.Bottom := Screen.DesktopTop;
    SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, Width, Height,
      SWP_SHOWWINDOW or SWP_NOACTIVATE);
    Invalidate;
  finally
    FActivating := False;
  end;     }
end;

procedure DumpDOSHeader(const h: IMAGE_DOS_HEADER; Lines: TStrings);
begin
  Lines.Add('Dump of DOS file header');
  Lines.Add(Format('Magic number: %d', [h.e_magic]));
  Lines.Add(Format('Bytes on last page of file: %d', [h.e_cblp]));
  Lines.Add(Format('Pages in file: %d', [h.e_cp]));
  Lines.Add(Format('Relocations: %d', [h.e_crlc]));
  Lines.Add(Format('Size of header in paragraphs: %d', [h.e_cparhdr]));
  Lines.Add(Format('Minimum extra paragraphs needed: %d', [h.e_minalloc]));
  Lines.Add(Format('Maximum extra paragraphs needed: %d', [h.e_maxalloc]));
  Lines.Add(Format('Initial (relative) SS value: %d', [h.e_ss]));
  Lines.Add(Format('Initial SP value: %d', [h.e_sp]));
  Lines.Add(Format('Checksum: %d', [h.e_csum]));
  Lines.Add(Format('Initial IP value: %d', [h.e_ip]));
  Lines.Add(Format('Initial (relative) CS value: %d', [h.e_cs]));
  Lines.Add(Format('File address of relocation table: %d', [h.e_lfarlc]));
  Lines.Add(Format('Overlay number: %d', [h.e_ovno]));
  Lines.Add(Format('OEM identifier (for e_oeminfo): %d', [h.e_oemid]));
  Lines.Add(Format('OEM information; e_oemid specific: %d', [h.e_oeminfo]));
  Lines.Add(Format('File address of new exe header: %d', [h._lfanew]));
  Lines.Add('');
end;



procedure DumpPEHeader(const h: IMAGE_FILE_HEADER; Lines: TStrings);
var
  dt: TDateTime;
begin
  Lines.Add('Dump of PE file header');
  Lines.Add(Format('Machine: %4x', [h.Machine]));
  case h.Machine of
    IMAGE_FILE_MACHINE_UNKNOWN : Lines.Add(' MACHINE_UNKNOWN ');
    IMAGE_FILE_MACHINE_I386: Lines.Add(' Intel 386. ');
    IMAGE_FILE_MACHINE_R3000: Lines.Add(' MIPS little-endian, 0x160 big-endian ');
    IMAGE_FILE_MACHINE_R4000: Lines.Add(' MIPS little-endian ');
    IMAGE_FILE_MACHINE_R10000: Lines.Add(' MIPS little-endian ');
    IMAGE_FILE_MACHINE_ALPHA: Lines.Add(' Alpha_AXP ');
    IMAGE_FILE_MACHINE_POWERPC: Lines.Add(' IBM PowerPC Little-Endian ');
    // some values no longer defined in winnt.h
    $14D: Lines.Add(' Intel i860');
    $268: Lines.Add(' Motorola 68000');
    $290: Lines.Add(' PA RISC');
    else
      Lines.Add(' unknown machine type');
  end; { Case }
  Lines.Add(Format('NumberOfSections: %d', [h.NumberOfSections]));
  Lines.Add(Format('TimeDateStamp: %d', [h.TimeDateStamp]));
  dt := EncodeDate(1970, 1, 1) + h.Timedatestamp / SecsPerDay;
  Lines.Add(FormatDateTime(' c', dt));

  Lines.Add(Format('PointerToSymbolTable: %d', [h.PointerToSymbolTable]));
  Lines.Add(Format('NumberOfSymbols: %d', [h.NumberOfSymbols]));
  Lines.Add(Format('SizeOfOptionalHeader: %d', [h.SizeOfOptionalHeader]));
  Lines.Add(Format('Characteristics: %d', [h.Characteristics]));
  if (IMAGE_FILE_DLL and h.Characteristics) <> 0 then
    Lines.Add(' file is a DLL')
  else if (IMAGE_FILE_EXECUTABLE_IMAGE and h.Characteristics) <> 0 then
    Lines.Add(' file is a program');
  Lines.Add('');
end;

procedure DumpOptionalHeader(const h: IMAGE_OPTIONAL_HEADER; Lines: TStrings);
begin
  Lines.Add('Dump of PE optional file header');
  Lines.Add(Format('Magic: %d', [h.Magic]));
  case h.Magic of
    $107: Lines.Add(' ROM image');
    $10b: Lines.Add(' executable image');
    else
      Lines.Add(' unknown image type');
  end; { If }
  Lines.Add(Format('MajorLinkerVersion: %d', [h.MajorLinkerVersion]));
  Lines.Add(Format('MinorLinkerVersion: %d', [h.MinorLinkerVersion]));
  Lines.Add(Format('SizeOfCode: %d', [h.SizeOfCode]));
  Lines.Add(Format('SizeOfInitializedData: %d', [h.SizeOfInitializedData]));
  Lines.Add(Format('SizeOfUninitializedData: %d', [h.SizeOfUninitializedData]));
  Lines.Add(Format('AddressOfEntryPoint: %d', [h.AddressOfEntryPoint]));
  Lines.Add(Format('BaseOfCode: %d', [h.BaseOfCode]));
  Lines.Add(Format('BaseOfData: %d', [h.BaseOfData]));
  Lines.Add(Format('ImageBase: %d', [h.ImageBase]));
  Lines.Add(Format('SectionAlignment: %d', [h.SectionAlignment]));
  Lines.Add(Format('FileAlignment: %d', [h.FileAlignment]));
  Lines.Add(Format('MajorOperatingSystemVersion: %d', [h.MajorOperatingSystemVersion]));
  Lines.Add(Format('MinorOperatingSystemVersion: %d', [h.MinorOperatingSystemVersion]));
  Lines.Add(Format('MajorImageVersion: %d', [h.MajorImageVersion]));
  Lines.Add(Format('MinorImageVersion: %d', [h.MinorImageVersion]));
  Lines.Add(Format('MajorSubsystemVersion: %d', [h.MajorSubsystemVersion]));
  Lines.Add(Format('MinorSubsystemVersion: %d', [h.MinorSubsystemVersion]));
  Lines.Add(Format('Win32VersionValue: %d', [h.Win32VersionValue]));
  Lines.Add(Format('SizeOfImage: %d', [h.SizeOfImage]));
  Lines.Add(Format('SizeOfHeaders: %d', [h.SizeOfHeaders]));
  Lines.Add(Format('CheckSum: %d', [h.CheckSum]));
  Lines.Add(Format('Subsystem: %d', [h.Subsystem]));
  case h.Subsystem of
    IMAGE_SUBSYSTEM_NATIVE:
      Lines.Add(' Image doesn''t require a subsystem. ');
    IMAGE_SUBSYSTEM_WINDOWS_GUI:
      Lines.Add(' Image runs in the Windows GUI subsystem. ');
    IMAGE_SUBSYSTEM_WINDOWS_CUI:
      Lines.Add(' Image runs in the Windows character subsystem. ');
    IMAGE_SUBSYSTEM_OS2_CUI:
      Lines.Add(' image runs in the OS/2 character subsystem. ');
    IMAGE_SUBSYSTEM_POSIX_CUI:
      Lines.Add(' image run in the Posix character subsystem. ');
    else
      Lines.Add(' unknown subsystem')
  end; { Case }
  Lines.Add(Format('DllCharacteristics: %d', [h.DllCharacteristics]));
  Lines.Add(Format('SizeOfStackReserve: %d', [h.SizeOfStackReserve]));
  Lines.Add(Format('SizeOfStackCommit: %d', [h.SizeOfStackCommit]));
  Lines.Add(Format('SizeOfHeapReserve: %d', [h.SizeOfHeapReserve]));
  Lines.Add(Format('SizeOfHeapCommit: %d', [h.SizeOfHeapCommit]));
  Lines.Add(Format('LoaderFlags: %d', [h.LoaderFlags]));
  Lines.Add(Format('NumberOfRvaAndSizes: %d', [h.NumberOfRvaAndSizes]));
end;

function FormatHTMLClipboardHeader(HTMLText: string): string;
const
  CrLf = #13#10;
begin
  Result := 'Version:0.9' + CrLf;
  Result := Result + 'StartHTML:-1' + CrLf;
  Result := Result + 'EndHTML:-1' + CrLf;
  Result := Result + 'StartFragment:000081' + CrLf;
  Result := Result + 'EndFragment:°°°°°°' + CrLf;
  Result := Result + HTMLText + CrLf;
  Result := StringReplace(Result, '°°°°°°', Format('%.6d', [Length(Result)]), []);
end;

//The second parameter is optional and is put into the clipboard as CF_HTML.
//Function can be used standalone or in conjunction with the VCL clipboard so long as
//you use the USEVCLCLIPBOARD conditional define
//($define USEVCLCLIPBOARD}
//(and clipboard.open, clipboard.close).
//Code from http://www.lorriman.com
procedure CopyHTMLToClipBoard(const str: string; const htmlStr: string = '');
var
  gMem: HGLOBAL;
  lp: PChar;
  Strings: array[0..1] of string;
  Formats: array[0..1] of UINT;
  i: Integer;
begin
  gMem := 0;
  {$IFNDEF USEVCLCLIPBOARD}
  Win32Check(OpenClipBoard(0));
  {$ENDIF}
  try
    //most descriptive first as per api docs
    Strings[0] := FormatHTMLClipboardHeader(htmlStr);
    Strings[1] := str;
    Formats[0] := RegisterClipboardFormat('HTML Format');
    Formats[1] := CF_TEXT;
    {$IFNDEF USEVCLCLIPBOARD}
    Win32Check(EmptyClipBoard);
    {$ENDIF}
    for i := 0 to High(Strings) do
    begin
      if Strings[i] = '' then Continue;
      //an extra "1" for the null terminator
      gMem := GlobalAlloc(GMEM_DDESHARE + GMEM_MOVEABLE, Length(Strings[i]) + 1);
      {Succeeded, now read the stream contents into the memory the pointer points at}
      try
        Win32Check(gmem <> 0);
        lp := GlobalLock(gMem);
        Win32Check(lp <> nil);
        CopyMemory(lp, PChar(Strings[i]), Length(Strings[i]) + 1);
      finally
        GlobalUnlock(gMem);
      end;
      Win32Check(gmem <> 0);
      SetClipboardData(Formats[i], gMEm);
      Win32Check(gmem <> 0);
      gmem := 0;
    end;
  finally
    {$IFNDEF USEVCLCLIPBOARD}
    Win32Check(CloseClipBoard);
    {$ENDIF}
  end;
end;

function RFC1123ToDateTime(Date: string): TDateTime;
var
  day, month, year: Integer;
  strMonth: string;
  Hour, Minute, Second: Integer;
begin
  try
    day      := StrToInt(Copy(Date, 6, 2));
    strMonth := Copy(Date, 9, 3);
    if strMonth = 'Jan' then month := 1 
    else if strMonth = 'Feb' then month := 2 
    else if strMonth = 'Mar' then month := 3 
    else if strMonth = 'Apr' then month := 4 
    else if strMonth = 'May' then month := 5 
    else if strMonth = 'Jun' then month := 6 
    else if strMonth = 'Jul' then month := 7 
    else if strMonth = 'Aug' then month := 8
    else if strMonth = 'Sep' then month := 9 
    else if strMonth = 'Oct' then month := 10 
    else if strMonth = 'Nov' then month := 11 
    else if strMonth = 'Dec' then month := 12;
    year   := StrToInt(Copy(Date, 13, 4));
    hour   := StrToInt(Copy(Date, 18, 2));
    minute := StrToInt(Copy(Date, 21, 2));
    second := StrToInt(Copy(Date, 24, 2));
    Result := 0;
    Result := EncodeTime(hour, minute, second, 0);
    Result := Result + EncodeDate(year, month, day);
  except
    Result := now;
  end;
end;


function DateTimeToRFC1123(aDate: TDateTime): string;
const
  StrWeekDay: string = 'MonTueWedThuFriSatSun';
  StrMonth: string = 'JanFebMarAprMayJunJulAugSepOctNovDec';
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  DayOfWeek: Word;
begin
  DecodeDate(aDate, Year, Month, Day);
  DecodeTime(aDate, Hour, Min, Sec, MSec);
  DayOfWeek := ((Trunc(aDate) - 2) mod 7);
  Result    := Copy(StrWeekDay, 1 + DayOfWeek * 3, 3) + ', ' +
    Format('%2.2d %s %4.4d %2.2d:%2.2d:%2.2d',
    [Day, Copy(StrMonth, 1 + 3 * (Month - 1), 3),
    Year, Hour, Min, Sec]);
end;

function checkSystem: string;
begin
  result:= GetDosOutput('Systeminfo ','C:\');
end;



(*----------------------------------------------------------------------------*)
procedure SIRegister_UtilsMax4(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SM_MEDIACENTER','LongInt').SetInt( 87);
 CL.AddConstantN('SM_TABLETPC','LongInt').SetInt( 86);
  SIRegister_TIdBaseComponent(CL);
 // CL.AddTypeS('SHA1Context', 'record Length_Low : uint32_t; Length_High : uint3'
   //+'2_t; Message_Block_Index : int_least16_t; Computed : Integer; Corrupted : '
   //+'Integer; end');
   CL.AddConstantN('DCX_WINDOW','LongInt').SetInt( 1);
 CL.AddConstantN('DCX_CACHE','LongInt').SetInt( 2);
 CL.AddConstantN('DCX_NORESETATTRS','LongInt').SetInt( 4);
 CL.AddConstantN('DCX_CLIPCHILDREN','LongInt').SetInt( 8);
 CL.AddConstantN('DCX_CLIPSIBLINGS','LongWord').SetUInt( $10);
 CL.AddConstantN('DCX_PARENTCLIP','LongWord').SetUInt( $20);
 CL.AddConstantN('DCX_EXCLUDERGN','LongWord').SetUInt( $40);
 CL.AddConstantN('DCX_INTERSECTRGN','LongWord').SetUInt( $80);
 CL.AddConstantN('DCX_EXCLUDEUPDATE','LongWord').SetUInt( $100);
 CL.AddConstantN('DCX_INTERSECTUPDATE','LongWord').SetUInt( $200);
 CL.AddConstantN('DCX_LOCKWINDOWUPDATE','LongWord').SetUInt( $400);
 CL.AddConstantN('DCX_VALIDATE','LongWord').SetUInt( $200000);
  CL.AddConstantN('GMEM_FIXED','LongInt').SetInt( 0);
 CL.AddConstantN('GMEM_MOVEABLE','LongInt').SetInt( 2);
 CL.AddConstantN('GMEM_NOCOMPACT','LongWord').SetUInt( $10);
 CL.AddConstantN('GMEM_NODISCARD','LongWord').SetUInt( $20);
 CL.AddConstantN('GMEM_ZEROINIT','LongWord').SetUInt( $40);
 CL.AddConstantN('GMEM_MODIFY','LongWord').SetUInt( $80);
 CL.AddConstantN('GMEM_DISCARDABLE','LongWord').SetUInt( $100);
 CL.AddConstantN('GMEM_NOT_BANKED','LongWord').SetUInt( $1000);
 CL.AddConstantN('GMEM_SHARE','LongWord').SetUInt( $2000);
 CL.AddConstantN('GMEM_DDESHARE','LongWord').SetUInt( $2000);
 CL.AddConstantN('GMEM_NOTIFY','LongWord').SetUInt( $4000);
 //CL.AddConstantN('GMEM_LOWER','').SetString( GMEM_NOT_BANKED);
 CL.AddConstantN('GMEM_VALID_FLAGS','LongInt').SetInt( 32626);
 CL.AddConstantN('GMEM_INVALID_HANDLE','LongWord').SetUInt( $8000);
  CL.AddTypeS('_IMAGE_FILE_HEADER', 'record Machine : Word; NumberOfSections : '
   +'Word; TimeDateStamp : DWORD; PointerToSymbolTable : DWORD; NumberOfSymbols'
   +' : DWORD; SizeOfOptionalHeader : Word; Characteristics : Word; end');
  CL.AddTypeS('TImageFileHeader', '_IMAGE_FILE_HEADER');
  CL.AddTypeS('IMAGE_FILE_HEADER', '_IMAGE_FILE_HEADER');

  CL.AddTypeS('IMAGE_DOS_HEADER', '_IMAGE_FILE_HEADER');
   CL.AddTypeS('TImageOptionalHeader', '_IMAGE_FILE_HEADER');
  CL.AddTypeS('IMAGE_OPTIONAL_HEADER', '_IMAGE_FILE_HEADER');
   CL.AddTypeS('_IMAGE_DATA_DIRECTORY', 'record VirtualAddress : DWORD; Size : DWORD; end');
  CL.AddTypeS('TImageDataDirectory', '_IMAGE_DATA_DIRECTORY');
  CL.AddTypeS('IMAGE_DATA_DIRECTORY', '_IMAGE_DATA_DIRECTORY');
 CL.AddConstantN('IMAGE_NUMBEROF_DIRECTORY_ENTRIES','LongInt').SetInt( 16);
  CL.AddConstantN('IMAGE_SIZEOF_FILE_HEADER','LongInt').SetInt( 20);
 CL.AddConstantN('IMAGE_FILE_RELOCS_STRIPPED','LongWord').SetUInt( $0001);
 CL.AddConstantN('IMAGE_FILE_EXECUTABLE_IMAGE','LongWord').SetUInt( $0002);
 CL.AddConstantN('IMAGE_FILE_LINE_NUMS_STRIPPED','LongWord').SetUInt( $0004);
 CL.AddConstantN('IMAGE_FILE_LOCAL_SYMS_STRIPPED','LongWord').SetUInt( $0008);
 CL.AddConstantN('IMAGE_FILE_AGGRESIVE_WS_TRIM','LongWord').SetUInt( $0010);
 CL.AddConstantN('IMAGE_FILE_LARGE_ADDRESS_AWARE','LongWord').SetUInt( $0020);
 CL.AddConstantN('IMAGE_FILE_BYTES_REVERSED_LO','LongWord').SetUInt( $0080);
 CL.AddConstantN('IMAGE_FILE_32BIT_MACHINE','LongWord').SetUInt( $0100);
 CL.AddConstantN('IMAGE_FILE_DEBUG_STRIPPED','LongWord').SetUInt( $0200);
 CL.AddConstantN('IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP','LongWord').SetUInt( $0400);
 CL.AddConstantN('IMAGE_FILE_NET_RUN_FROM_SWAP','LongWord').SetUInt( $0800);
 CL.AddConstantN('IMAGE_FILE_SYSTEM','LongWord').SetUInt( $1000);
 CL.AddConstantN('IMAGE_FILE_DLL','LongWord').SetUInt( $2000);
 CL.AddConstantN('IMAGE_FILE_UP_SYSTEM_ONLY','LongWord').SetUInt( $4000);
 CL.AddConstantN('IMAGE_FILE_BYTES_REVERSED_HI','LongWord').SetUInt( $8000);
 CL.AddConstantN('IMAGE_FILE_MACHINE_UNKNOWN','LongInt').SetInt( 0);
 CL.AddConstantN('IMAGE_FILE_MACHINE_I386','LongWord').SetUInt( $14c);
 CL.AddConstantN('IMAGE_FILE_MACHINE_R3000','LongWord').SetUInt( $162);
 CL.AddConstantN('IMAGE_FILE_MACHINE_R4000','LongWord').SetUInt( $166);
 CL.AddConstantN('IMAGE_FILE_MACHINE_R10000','LongWord').SetUInt( $168);
 CL.AddConstantN('IMAGE_FILE_MACHINE_ALPHA','LongWord').SetUInt( $184);
 CL.AddConstantN('IMAGE_FILE_MACHINE_POWERPC','LongWord').SetUInt( $1F0);
 CL.AddTypeS('_IMAGE_COFF_SYMBOLS_HEADER', 'record NumberOfSymbols : DWORD; Lv'
   +'aToFirstSymbol : DWORD; NumberOfLinenumbers : DWORD; LvaToFirstLinenumber '
   +': DWORD; RvaToFirstByteOfCode : DWORD; RvaToLastByteOfCode : DWORD; RvaToF'
   +'irstByteOfData : DWORD; RvaToLastByteOfData : DWORD; end');
  CL.AddTypeS('TImageCOFFSymbolsHeader', '_IMAGE_COFF_SYMBOLS_HEADER');
  CL.AddTypeS('IMAGE_COFF_SYMBOLS_HEADER', '_IMAGE_COFF_SYMBOLS_HEADER');
 CL.AddConstantN('FRAME_FPO','LongInt').SetInt( 0);
 CL.AddConstantN('FRAME_TRAP','LongInt').SetInt( 1);
 CL.AddConstantN('FRAME_TSS','LongInt').SetInt( 2);
 CL.AddConstantN('FRAME_NONFPO','LongInt').SetInt( 3);
   CL.AddConstantN('WIN_CERT_REVISION_1_0','LongWord').SetUInt( $0100);
 CL.AddConstantN('WIN_CERT_TYPE_X509','LongWord').SetUInt( $0001);
 CL.AddConstantN('WIN_CERT_TYPE_PKCS_SIGNED_DATA','LongWord').SetUInt( $0002);
 CL.AddConstantN('WIN_CERT_TYPE_RESERVED_1','LongWord').SetUInt( $0003);
 CL.AddConstantN('WIN_TRUST_SUBJTYPE_RAW_FILE','string').SetString( '{959dc450-8d9e-11cf-8736-00aa00a485eb}');
 CL.AddConstantN('WIN_TRUST_SUBJTYPE_PE_IMAGE','string').SetString( '{43c9a1e0-8da0-11cf-8736-00aa00a485eb}');
 CL.AddConstantN('WIN_TRUST_SUBJTYPE_JAVA_CLASS','string').SetString( '{08ad3990-8da1-11cf-8736-00aa00a485eb}');
 CL.AddConstantN('WIN_TRUST_SUBJTYPE_CABINET','string').SetString( '{d17c5374-a392-11cf-9df5-00aa00c184e0}');
 

 { TPopupWnd = record
    ID: Integer;
    ControlWnd: HWND;
  end;}
 //TPopupWndArray = array of TPopupWnd;
 CL.AddTypeS('TPopupWnd', 'record ID:integer; ControlWnd: HWND; end;');
 CL.AddTypeS('TPopupWndArray', 'array of TPopupWnd;');


 CL.AddDelphiFunction('Function AllDigitsDifferent( N : Int64) : Boolean');
 CL.AddDelphiFunction('Procedure DecimalToFraction( Decimal : Extended; out FractionNumerator : Extended; out FractionDenominator : Extended; const AccuracyFactor : Extended)');
 CL.AddDelphiFunction('Function ColorToHTML( const Color : TColor) : string');
 CL.AddDelphiFunction('Function DOSCommand( const CommandLine : string; const CmdShow : integer; const WaitUntilComplete : Boolean; const WorkingDir : string) : Boolean');
 CL.AddDelphiFunction('Function GetDosOutput( CommandLine : string; Work : string) : string');
 CL.AddDelphiFunction('Function DOSExec( CommandLine : string; Work : string) : string');

 CL.AddDelphiFunction('Procedure CaptureConsoleOutput( DosApp : string; AMemo : TMemo)');
 CL.AddDelphiFunction('Function ExecuteCommandDOS( CommandLine : string) : string');
 CL.AddDelphiFunction('Function DOSCommandRedirect( const CommandLine : string; const OutStream : TStream) : Boolean');
 CL.AddDelphiFunction('Procedure SendKeysToWindow( const HWnd : HWND; const Text : string)');
 CL.AddDelphiFunction('Function IsRunningOnBattery : Boolean');
 CL.AddDelphiFunction('Function IsHexStr( const S : string) : Boolean');
 CL.AddDelphiFunction('Function IsCharInSet( const Ch : Char; const Chars : TCharSet) : Boolean');
 CL.AddDelphiFunction('Function StreamHasWatermark( const Stm : TStream; const Watermark : array of Byte) : Boolean');
 CL.AddDelphiFunction('Function ReadBigEndianWord( Stm : TStream) : Word');
 CL.AddDelphiFunction('Function DownloadURLToFile( const URL, FileName : string) : Boolean');
 CL.AddDelphiFunction('Function ExtractURIQueryString( const URI : string) : string');
 CL.AddDelphiFunction('Function GetBiosVendor : string');
 CL.AddDelphiFunction('Function GetIEVersionStr : string');
 CL.AddDelphiFunction('Function FloatToFixed( const Value : Extended; const DecimalPlaces : Byte; const SeparateThousands : Boolean) : string');
 CL.AddDelphiFunction('Function IntToFixed( const Value : Integer; const SeparateThousands : Boolean) : string');
 CL.AddDelphiFunction('Function Int64ToFixed( const Value : Int64; const SeparateThousands : Boolean) : string');
 CL.AddDelphiFunction('Function IntToNumberText2( const Value : Integer) : string');
 CL.AddDelphiFunction('Function IsLibraryInstalled2( const LibFileName : string) : Boolean');
 CL.AddDelphiFunction('Function RemainingBatteryPercent : Integer');
 CL.AddDelphiFunction('Procedure SetLockKeyState( KeyCode : Integer; IsOn : Boolean)');
 CL.AddDelphiFunction('Function IsLockKeyOn( const KeyCode : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure PostKeyEx322( const Key : Word; const Shift : TShiftState; const SpecialKey : Boolean)');
 CL.AddDelphiFunction('Function TerminateProcessByID( ProcessID : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function GetWindowProcessName( const Wnd : HWND) : string');
 CL.AddDelphiFunction('Function GetProcessName( const PID : DWORD) : string');
 CL.AddDelphiFunction('Function GetWindowProcessID( const Wnd : HWND) : DWORD');
 CL.AddDelphiFunction('Function IsAppResponding( const Wnd : HWND) : Boolean');
 CL.AddDelphiFunction('Function IsTabletOS : Boolean');
 CL.AddDelphiFunction('Function ProgIDInstalled( const PID : string) : Boolean');
 CL.AddDelphiFunction('Function GetProcessorName : string');
 CL.AddDelphiFunction('Function GetProcessorIdentifier : string');
 CL.AddDelphiFunction('Procedure EmptyKeyQueue');
 CL.AddDelphiFunction('Procedure TrimAppMemorySize');
 CL.AddDelphiFunction('Function GetEnvironmentBlockSize : Cardinal');
 CL.AddDelphiFunction('Function GetDefaultPrinterName : string');
 CL.AddDelphiFunction('Procedure ListDrives( const List : TStrings)');
 CL.AddDelphiFunction('Procedure MultiSzToStrings( const MultiSz : PChar; const Strings : TStrings)');
 CL.AddDelphiFunction('Function BrowseURL( const URL : string) : Boolean');
 CL.AddDelphiFunction('Function IsValidURLProtocol( const URL : string) : Boolean');
 CL.AddDelphiFunction('Function ExecAssociatedApp( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function CheckInternetConnection( AHost : PChar) : Boolean');
 CL.AddDelphiFunction('Function MakeSafeHTMLText( TheText : string) : string');
 CL.AddDelphiFunction('Function RemoveURIQueryString( const URI : string) : string');
 CL.AddDelphiFunction('Function GetRegistryString( const RootKey : HKEY; const SubKey, Name : string) : string');
 CL.AddDelphiFunction('Procedure RefreshEnvironment2( const Timeout : Cardinal)');
 //CL.AddDelphiFunction('Procedure RefreshEnvironment2( const Timeout : Cardinal)');
 CL.AddDelphiFunction('function SizeOfFile64(const FileName: string): Int64;');
 CL.AddDelphiFunction('function IsHugeFile(const FileName: string): Boolean;');
 CL.AddDelphiFunction('Function SetTransparencyLevel( const HWnd : HWND; const Level : Byte) : Boolean');
 CL.AddDelphiFunction('Function IsEqualResID( const R1, R2 : PChar) : Boolean');
 CL.AddDelphiFunction('Function GetGenericFileType( const FileNameOrExt : string) : string');
 CL.AddDelphiFunction('Function GetFileType2( const FilePath : string) : string');
 CL.AddDelphiFunction('Procedure ShowShellPropertiesDlg( const APath : string)');
 CL.AddDelphiFunction('Function EllipsifyText( const AsPath : Boolean; const Text : string; const Canvas : TCanvas; const MaxWidth : Integer) : string');
 CL.AddDelphiFunction('Function CloneByteArray( const B : array of Byte) : TBytes');
 CL.AddDelphiFunction('Procedure AppendByteArray( var B1 : TBytes; const B2 : array of Byte)');
 CL.AddDelphiFunction('Function IsUnicodeStream( const Stm : TStream) : Boolean');
 CL.AddDelphiFunction('Function FileHasWatermark( const FileName : string; const Watermark : array of Byte; const Offset : Integer) : Boolean');
 CL.AddDelphiFunction('Function FileHasWatermarkAnsi( const FileName : string; const Watermark : AnsiString; const Offset : Integer) : Boolean');
 CL.AddDelphiFunction('Function IsASCIIStream( const Stm : TStream; Count : Int64; BufSize : Integer) : Boolean');
 CL.AddDelphiFunction('Function IsASCIIFile( const FileName : string; BytesToCheck : Int64; BufSize : Integer) : Boolean');
 CL.AddDelphiFunction('Function BytesToAnsiString( const Bytes : TBytes; const CodePage : Word) : String');
 CL.AddDelphiFunction('Function UnicodeStreamToWideString( const Stm : TStream) : WideString');
 CL.AddDelphiFunction('Procedure WideStringToUnicodeStream( const Str : WideString; const Stm : TStream)');
 CL.AddDelphiFunction('Procedure GraphicToBitmap( const Src : TGraphic; const Dest : TBitmap; const TransparentColor : TColor)');
 CL.AddDelphiFunction('Function URIDecode( S : string; const IsQueryString : Boolean) : string');
 CL.AddDelphiFunction('Function URIEncode( const S : string; const InQueryString : Boolean) : string');
 CL.AddDelphiFunction('Function URLDecode2( const S : string) : string');
 CL.AddDelphiFunction('Function URLEncode2( const S : string; const InQueryString : Boolean) : string');
 CL.AddDelphiFunction('Function AllDigitsSame( N : Int64) : Boolean');                         //75 funcs
 CL.AddDelphiFunction('Function DrawTextEx( DC : HDC; lpchText : PChar; cchText : Integer; var p4 : TRect; dwDTFormat : UINT; DTParams : integer) : Integer');
 CL.AddDelphiFunction('Function CreateDC( lpszDriver, lpszDevice, lpszOutput : PChar; lpdvmInit : integer) : HDC');
 CL.AddDelphiFunction('function FoldWrapText(const Line, BreakStr: string; BreakChars: TSysCharSet; MaxCol: Integer): string;');
 CL.AddDelphiFunction('Function ValidateRect( hWnd : HWND; lpRect : TRect) : BOOL');
 CL.AddDelphiFunction('Function DeleteDC( DC : HDC) : BOOL');
 CL.AddDelphiFunction('Function DeleteMetaFile( p1 : HMETAFILE) : BOOL');
 CL.AddDelphiFunction('Function DeleteObject( p1 : HGDIOBJ) : BOOL');
 //CL.AddDelphiFunction('Function DeviceCapabilities( pDriverName, pDeviceName, pPort : PChar; iIndex : Integer; pOutput : PChar; DevMode : PChar) : Integer');
 CL.AddDelphiFunction('Function DisableTaskWindows( ActiveWindow : HWnd) : integer');
  CL.AddDelphiFunction('Function Subclass3DWnd( Wnd : HWnd) : Boolean');
 CL.AddDelphiFunction('Procedure Subclass3DDlg( Wnd : HWnd; Flags : Word)');
 CL.AddDelphiFunction('Procedure SetAutoSubClass( Enable : Boolean)');
  CL.AddDelphiFunction('Procedure DoneCtl3D');
 CL.AddDelphiFunction('Procedure InitCtl3D');


 CL.AddDelphiFunction('function ExeType(const FileName: string): string;');
 CL.AddDelphiFunction('function getExeType(const FileName: string): string;');
 CL.AddDelphiFunction('function TextWrap(const Text: string; const Width, Margin: Integer): string;');
  CL.AddDelphiFunction('Procedure SetCustomFormGlassFrame( const CustomForm : TCustomForm; const GlassFrame : TGlassFrame)');
 CL.AddDelphiFunction('Function GetCustomFormGlassFrame( const CustomForm : TCustomForm) : TGlassFrame');
 CL.AddDelphiFunction('Procedure SetApplicationMainFormOnTaskBar( const Application : TApplication; Value : Boolean)');
 CL.AddDelphiFunction('Function GetApplicationMainFormOnTaskBar( const Application : TApplication) : Boolean');
  CL.AddDelphiFunction('Function KeyboardStateToShiftState1( const KeyboardState : TKeyboardState) : TShiftState;');
  CL.AddDelphiFunction('function CompressWhiteSpace(const S: string): string;');
  CL.AddDelphiFunction('function IsASCIIDigit(const Ch: Char): Boolean;');
  CL.AddDelphiFunction('function CompareNumberStr(const S1, S2: string): Integer;');
  CL.AddDelphiFunction('procedure HexToBuf(HexStr: string; var Buf: string);');
  CL.AddDelphiFunction('function BufToHex(const Buf: string; const Size: Cardinal): string;');
  CL.AddDelphiFunction('procedure HexToStrBuf(HexStr: string; var Buf: string);');
  CL.AddDelphiFunction('function StrBufToHex(const Buf: string; const Size: Cardinal): string;');
  CL.AddDelphiFunction('function GetCharFromVirtualKey(AKey: Word): string;');
  CL.AddDelphiFunction('function GetParentProcessID(const PID: DWORD): DWORD;');           //88 funcs

  CL.AddClassN(CL.FindClass('Class of TForm'),'TFormClass');
   // TFormClass = class of TForm;

  CL.AddDelphiFunction('function FormInstanceCount2(AFormClass: TFormClass): Integer;');
   CL.AddDelphiFunction('function FormInstanceCount(const AFormClassName: string): Integer;');
   CL.AddDelphiFunction('function FindAssociatedApp(const Doc: string): string;');

   CL.AddDelphiFunction('function CreateShellLink2(const LinkFileName, AssocFileName, Desc, WorkDir, Args, IconFileName: string; const IconIdx: Integer): Boolean;');
 CL.AddDelphiFunction('function FileFromShellLink(const LinkFileName: string): string;');
 CL.AddDelphiFunction('function IsShellLink(const LinkFileName: string): Boolean;');
 CL.AddDelphiFunction('function ResourceIDToStr(const ResID: PChar): string;');
 CL.AddDelphiFunction('function IsEqualResID(const R1, R2: PChar): Boolean;');
 CL.AddDelphiFunction('function RecycleBinInfo(const Drive: Char; out BinSize, FileCount: Int64): Boolean;');
 CL.AddDelphiFunction('function SysImageListHandle(const Path: string; const WantLargeIcons: Boolean): THandle;');
 CL.AddDelphiFunction('function EmptyRecycleBin: Boolean;');
 CL.AddDelphiFunction('function ExploreFile(const Filename: string ): Boolean;');
 CL.AddDelphiFunction('function ExploreFolder(const Folder: string): Boolean;');
 CL.AddDelphiFunction('procedure ClearRecentDocs2;');
 CL.AddDelphiFunction('procedure AddToRecentDocs2(const FileName: string); ');
 CL.AddDelphiFunction('function StringsToMultiSz(const Strings: TStrings; const MultiSz: PChar; const BufSize: Integer): Integer;');
 CL.AddDelphiFunction('procedure DrawTextOutline(const Canvas: TCanvas; const X, Y: Integer; const Text: string);');
 CL.AddDelphiFunction('function CloneGraphicAsBitmap(const Src: TGraphic; const PixelFmt: TPixelFormat;  const TransparentColor: TColor): TBitmap;');
 CL.AddDelphiFunction('procedure InvertBitmap(const ABitmap: TBitmap);');
 CL.AddDelphiFunction('procedure InvertBitmap2(const SrcBmp, DestBmp: TBitmap);');


 CL.AddDelphiFunction('Function SetVolumeLabel( lpRootPathName : PChar; lpVolumeName : PChar) : BOOL');
 CL.AddDelphiFunction('Function StrokeAndFillPath( DC : HDC) : BOOL');
 CL.AddDelphiFunction('Function StrokePath( DC : HDC) : BOOL');
 CL.AddDelphiFunction('Function WidenPath( DC : HDC) : BOOL');
  CL.AddDelphiFunction('Function DPtoLP( DC : HDC; var Points, Count : Integer) : BOOL');
 CL.AddDelphiFunction('Function LPtoDP( DC : HDC; var Points, Count : Integer) : BOOL');

 CL.AddTypeS('_DOCINFOA', 'record cbSize : Integer; lpszDocName : PChar; l'
   +'pszOutput : PChar; lpszDatatype : PChar; fwType : DWORD; end');
  CL.AddTypeS('_DOCINFO', '_DOCINFOA');
  CL.AddTypeS('TDocInfoA', '_DOCINFOA');
  CL.AddTypeS('TDocInfo', 'TDocInfoA');
  CL.AddTypeS('DOCINFOA', '_DOCINFOA');
 CL.AddConstantN('DI_APPBANDING','LongInt').SetInt( 1);
 CL.AddDelphiFunction('Function StartDoc( DC : HDC; const p2 : TDocInfo) : Integer');
 CL.AddDelphiFunction('Function EndDoc( DC : HDC) : Integer');

 CL.AddDelphiFunction('Function MakeFilenameInExePath( aFilename : TFilename) : TFilename');
 CL.AddDelphiFunction('Function YearOfDate2( DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function MonthOfDate2( DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function DayOfDate2( DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function HourOfTime2( DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function MinuteOfTime2( DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function SecondOfTime2( DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function IsLeapYear2( DateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function DaysInMonth2( DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function MakeUTCTime( DateTime : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function MakeLocalTimeFromUTC( DateTime : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function IsStandardTime : Boolean');
 CL.AddDelphiFunction('Function UnixNow : Int64');
 CL.AddDelphiFunction('Function NowString : string');
 CL.AddDelphiFunction('Function MakeClosedTag( aTagName, aTagValue : string) : string');
 CL.AddDelphiFunction('Function MakeOpenTag( aTagName, aTagAttributes : string) : string');
 CL.AddDelphiFunction('Function MakeBold( Str : string) : string');
 CL.AddDelphiFunction('Function MakeItalic( Str : string) : string');
 CL.AddDelphiFunction('Function MakeUnderline( Str : string) : string');
 CL.AddDelphiFunction('Function MakeStrikeout( Str : string) : string');
 CL.AddDelphiFunction('Function MakeCenter( Str : string) : string');
 CL.AddDelphiFunction('Function MakeParagraph( Str : string) : string');
 CL.AddDelphiFunction('Function MakeCode( Str : string) : string');
 CL.AddDelphiFunction('Function MakeOption( aValue, aText : string) : string');
 CL.AddDelphiFunction('Function MakeHTMLFontSize( Str : string; SizeParam : string) : string');
 CL.AddDelphiFunction('Function AddQuotes2( Str : string) : string');
 CL.AddDelphiFunction('Function AddSingleQuotes( Str : string) : string');
 CL.AddDelphiFunction('Function MakeHTMLParam( Str : string) : string');
 CL.AddDelphiFunction('Function MakeLink( URL, name : string) : string');
 CL.AddDelphiFunction('Function MakeLinkTarget( URL, name, Target : string) : string');
 CL.AddDelphiFunction('Function MakeMailTo( Address, name : string) : string');
 CL.AddDelphiFunction('Function HTMLToDelphiColor( S : string) : TColor');
 CL.AddDelphiFunction('Function ColorToHTMLHex( Color : TColor) : string');
 CL.AddDelphiFunction('Function GetStringFromRes( ResName : string) : string');
 CL.AddDelphiFunction('Function EscapeText( sText : string) : string');
 CL.AddDelphiFunction('Function EncodeForXML( const aString : string) : string');
 CL.AddDelphiFunction('Function IsStringAlpha( Str : string) : Boolean');
 CL.AddDelphiFunction('Function IsStringNumber( Str : string) : Boolean');
 CL.AddDelphiFunction('Function EnsurePrefix( aPrefix, aText : string) : string');
 CL.AddDelphiFunction('Function StringToAcceptableChars( S : string; AcceptableChars : TCharSet) : string');
 CL.AddDelphiFunction('Function StringIsAcceptable( S : string; AcceptableChars : TCharSet) : Boolean');
 CL.AddDelphiFunction('Function ValidateEMailAddress( aEmail : string) : Boolean');
 CL.AddDelphiFunction('Function FirstChar( Str : string) : Char');
 CL.AddDelphiFunction('Function LastChar( Str : string) : Char');
 CL.AddDelphiFunction('Function StringIsEmpty( Str : string) : Boolean');
 CL.AddDelphiFunction('Function StringIsNotEmpty( Str : string) : Boolean');
 CL.AddDelphiFunction('Function StringHasSpacesInMiddle( Str : string) : Boolean');
 CL.AddDelphiFunction('Function StringContains( aString : string; aSubStr : string) : Boolean');
 CL.AddDelphiFunction('Function SpacesToUnderscore( S : string) : string');
 CL.AddDelphiFunction('Function SpacesToPluses( Str : string) : string');
 CL.AddDelphiFunction('Function SwapString( Str : string) : string');
 CL.AddDelphiFunction('Function MakeCopyrightNotice( aCopyrightHolder : string) : string');
 CL.AddDelphiFunction('Procedure WriteStringToFile( aStr : string; aFilename : TFilename)');
 //CL.AddDelphiFunction('Function WinExecandWait32( Path : PChar; Visibility : Word) : Integer');
 CL.AddDelphiFunction('Function WinExecAndWait32V2( Filename : string; Visibility : Integer) : DWORD');
 CL.AddDelphiFunction('Function WindowsExit( RebootParam : Longword) : Boolean');
 CL.AddDelphiFunction('Function GetVersionInfo2 : string');
 CL.AddDelphiFunction('Function VersionString( aPrefix : string; aUseColon : Boolean) : string');
 CL.AddDelphiFunction('Function CreateTempFileName( aPrefix : string) : string');
 CL.AddDelphiFunction('Function GetWindowsTempDir : string');
 CL.AddDelphiFunction('Function GetWindowsDir2 : string');
 CL.AddDelphiFunction('Function GetSystemDir2 : string');
 CL.AddDelphiFunction('Function GetSpecialFolderLocation( aFolderType : Integer) : string');
 CL.AddDelphiFunction('Function GetTextFileContents( aFilename : TFilename) : string');
 CL.AddDelphiFunction('Function GetBDSDir( aVersion : Integer) : string');
 CL.AddDelphiFunction('Function CaptionMessageDlg( const aCaption : string; const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint) : Integer');
 CL.AddDelphiFunction('Function StreamFileCopy( const SourceFilename, TargetFilename : string; KeepDate : Boolean) : Integer');
 CL.AddDelphiFunction('Function MakePercentString( f : Double) : string');
 CL.AddDelphiFunction('Procedure DumpKey( var aKey : Char)');
 CL.AddDelphiFunction('Function ValidateKey2( var aKey : Char; AcceptableKeys : TCharSet; KillTheKey : Boolean) : Boolean');
 CL.AddDelphiFunction('Function MakeInterbaseString( aHostName, aFilename : string) : string');
 CL.AddDelphiFunction('Function ParseToken( const S : string; var FromPos : Integer; Delimiter : Char) : string');
 CL.AddDelphiFunction('Procedure MatchBounds( MovedControl, TemplateControl : TControl)');
 CL.AddDelphiFunction('Procedure LockWidth( aControl : TControl)');
 CL.AddDelphiFunction('Procedure LockHeight( aControl : TControl)');
 CL.AddDelphiFunction('Procedure LockBounds( aControl : TControl)');
 CL.AddDelphiFunction('Function TruncateFilename( aCanvas : TCanvas; aRect : TRect; aFilename : string; aMargin : Integer) : string');
 CL.AddDelphiFunction('Function PointInRect2( const R : TRect; const P : TPoint) : Boolean;');
 CL.AddDelphiFunction('Function PointInRect3( const R : TRect; const X, Y : Integer) : Boolean;');
 CL.AddDelphiFunction('Procedure VariantToStream2( const V : OLEVariant; Stream : TStream)');
 CL.AddDelphiFunction('Procedure StreamToVariant2( Stream : TStream; var V : OLEVariant)');
   with CL.AddClassN(CL.FindClass('TOleControl'),'TWebBrowser') do

 CL.AddDelphiFunction('Procedure AssignDocument( Browser : TWebBrowser; Text : string)');
 CL.AddDelphiFunction('Procedure LoadStreamToWebBrowser( WebBrowser : TWebBrowser; Stream : TStream)');
 CL.AddDelphiFunction('Procedure SaveWebBrowserSourceToStream( Document : IDispatch; Stream : TStream)');
 CL.AddDelphiFunction('Procedure GetStylesFromBrowser( aBrowser : TWebBrowser; aStyles : TStrings)');

 CL.AddTypeS('TnxBits', 'Integer');
  CL.AddTypeS('TDayHours', 'Integer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'NixUtilsException');

 CL.AddDelphiFunction('Function REG_CURRENT_VERSION : string');
 CL.AddDelphiFunction('Function RegisteredOwner : string');
 CL.AddDelphiFunction('Function RegisteredCompany : string');
 CL.AddDelphiFunction('Function GetLocalComputerName2 : string');
 CL.AddDelphiFunction('Function GetLocalUserName2 : string');
 CL.AddDelphiFunction('Function DeleteToRecycleBin( WindowHandle : HWND; Filename : string; Confirm : Boolean) : Boolean');
 CL.AddDelphiFunction('Function RemoveBackSlash2( const Dir : string) : string');
 CL.AddDelphiFunction('Function EnsureBackSlash( aPath : string) : string');
 CL.AddDelphiFunction('Function EnsureForwardSlash( aPath : string) : string');
 CL.AddDelphiFunction('Function RemoveLeadingSlash( aPath : string) : string');
 CL.AddDelphiFunction('Function SameDirectories( aDir1, aDir2 : TFilename) : Boolean');
 CL.AddDelphiFunction('Function EnsureExtensionHasLeadingPeriod( aExtension : string) : string');
 CL.AddDelphiFunction('Function RemoveExtension( aFilename : string) : string');
 CL.AddDelphiFunction('Function GetModuleFileNameStr : string');
 CL.AddDelphiFunction('Function ModulePath : string');
 CL.AddDelphiFunction('Function IniFileName : string');
 CL.AddDelphiFunction('Function MakeFilenameInExePath( aFilename : TFilename) : TFilename');
 CL.AddDelphiFunction('Function IsBitSet( Bits : Integer; BitToSet : TnxBits) : Boolean');
 CL.AddDelphiFunction('Function SetBit6( Bits : Integer; BitToSet : TnxBits) : Integer');
 CL.AddDelphiFunction('Function UnSetBit( Bits : Integer; BitToSet : TnxBits) : Integer');
 CL.AddDelphiFunction('Function FlipBit( Bits : Integer; BitToSet : TnxBits) : Integer');
 CL.AddDelphiFunction('function GetCachedFileFromURL(strUL: string; var strLocalFile: string): boolean;');
 CL.AddDelphiFunction('function IAddrToHostName(const IP: string): string;');
 CL.AddDelphiFunction('function GetIEHandle(WebBrowser: TWebbrowser; ClassName: string): HWND;');
 CL.AddDelphiFunction('function GetTextFromHandle(WinHandle: THandle): string;');
 CL.AddDelphiFunction('procedure Duplicate_Webbrowser(WB1, WB2: TWebbrowser);');
 CL.AddDelphiFunction('function FillWebForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;');
 CL.AddDelphiFunction('procedure WB_LoadHTML(WebBrowser: TWebBrowser; HTMLCode: string);');
 CL.AddDelphiFunction('function NetSend(dest, Source, Msg: string): Longint;');

 // with CL.AddInterface(CL.FindInterface('Recordset20'),_Recordset, '_Recordset') do

 //CL.AddDelphiFunction('function RecordsetFromXML(const XML: string): _Recordset');
 //CL.AddDelphiFunction('function RecordsetToXML(const Recordset: _recordset): string;');
 CL.AddDelphiFunction('function RecordsetFromXML2(const XML: string): variant;');
 CL.AddDelphiFunction('function RecordsetToXML2(const Recordset: variant): string;');
 CL.AddDelphiFunction('Function GlobalLock( hMem : HGLOBAL) : PChar');

 CL.AddDelphiFunction('procedure CopyHTMLToClipBoard(const str: string; const htmlStr: string);');
 CL.AddDelphiFunction('procedure DumpDOSHeader(const h: IMAGE_DOS_HEADER; Lines: TStrings);');
 CL.AddDelphiFunction('procedure DumpPEHeader(const h: IMAGE_FILE_HEADER; Lines: TStrings);');
 CL.AddDelphiFunction('procedure DumpOptionalHeader(const h: IMAGE_OPTIONAL_HEADER; Lines: TStrings);');
 CL.AddDelphiFunction('function RFC1123ToDateTime(Date: string): TDateTime;');
 CL.AddDelphiFunction('function DateTimeToRFC1123(aDate: TDateTime): string;');
 CL.AddDelphiFunction('function checkSystem: string;');
 CL.AddDelphiFunction('function getSystemReport: string;');
 CL.AddDelphiFunction('function SystemCheck: string;');


 //procedure CopyHTMLToClipBoard(const str: string; const htmlStr: string = '');


//function RecordsetFromXML(const XML: string): _Recordset;

   // function FormInstanceCount2(AFormClass: Forms.TFormClass): Integer; //overload;
  //function FormInstanceCount(const AFormClassName: string): Integer; //overload;
    //  function GetCharFromVirtualKey(AKey: Word): string;
  //function GetParentProcessID(const PID: Windows.DWORD): Windows.DWORD;
 //function ExeType(const FileName: string): string; //TExeType;


end;



(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdBaseComponentVersion_R(Self: TIdBaseComponent; var T: string);
begin T := Self.Version; end;


//*----------------------------------------------------------------------------*)
Function PointInRect1_P( const R : TRect; const X, Y : Integer) : Boolean;
Begin Result := NixUtils.PointInRect(R, X, Y); END;

(*----------------------------------------------------------------------------*)
Function PointInRect0_P( const R : TRect; const P : TPoint) : Boolean;
Begin Result := NixUtils.PointInRect(R, P); END;


(*----------------------------------------------------------------------------*)
procedure RIRegister_UtilsMax4_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AllDigitsDifferent, 'AllDigitsDifferent', cdRegister);
 S.RegisterDelphiFunction(@DecimalToFraction, 'DecimalToFraction', cdRegister);
 S.RegisterDelphiFunction(@ColorToHTML, 'ColorToHTML', cdRegister);
 S.RegisterDelphiFunction(@DOSCommand, 'DOSCommand', cdRegister);
 S.RegisterDelphiFunction(@GetDosOutput, 'GetDosOutput', cdRegister);
 S.RegisterDelphiFunction(@GetDosOutput, 'DosExec', cdRegister);   //Alias

 S.RegisterDelphiFunction(@CaptureConsoleOutput, 'CaptureConsoleOutput', cdRegister);
 S.RegisterDelphiFunction(@ExecuteCommandDOS, 'ExecuteCommandDOS', cdRegister);
 S.RegisterDelphiFunction(@DOSCommandRedirect, 'DOSCommandRedirect', cdRegister);
 S.RegisterDelphiFunction(@SendKeysToWindow, 'SendKeysToWindow', cdRegister);
 S.RegisterDelphiFunction(@IsRunningOnBattery, 'IsRunningOnBattery', cdRegister);
 S.RegisterDelphiFunction(@IsHexStr, 'IsHexStr', cdRegister);
 S.RegisterDelphiFunction(@IsCharInSet, 'IsCharInSet', cdRegister);
 S.RegisterDelphiFunction(@StreamHasWatermark, 'StreamHasWatermark', cdRegister);
 S.RegisterDelphiFunction(@ReadBigEndianWord, 'ReadBigEndianWord', cdRegister);
 S.RegisterDelphiFunction(@DownloadURLToFile, 'DownloadURLToFile', cdRegister);
 S.RegisterDelphiFunction(@ExtractURIQueryString, 'ExtractURIQueryString', cdRegister);
 S.RegisterDelphiFunction(@GetBiosVendor, 'GetBiosVendor', cdRegister);
 S.RegisterDelphiFunction(@GetIEVersionStr, 'GetIEVersionStr', cdRegister);
 S.RegisterDelphiFunction(@FloatToFixed, 'FloatToFixed', cdRegister);
 S.RegisterDelphiFunction(@IntToFixed, 'IntToFixed', cdRegister);
 S.RegisterDelphiFunction(@Int64ToFixed, 'Int64ToFixed', cdRegister);
 S.RegisterDelphiFunction(@IntToNumberText2, 'IntToNumberText2', cdRegister);
 S.RegisterDelphiFunction(@IsLibraryInstalled2, 'IsLibraryInstalled2', cdRegister);
 S.RegisterDelphiFunction(@RemainingBatteryPercent, 'RemainingBatteryPercent', cdRegister);
 S.RegisterDelphiFunction(@SetLockKeyState, 'SetLockKeyState', cdRegister);
 S.RegisterDelphiFunction(@IsLockKeyOn, 'IsLockKeyOn', cdRegister);
 S.RegisterDelphiFunction(@PostKeyEx322, 'PostKeyEx322', cdRegister);
 S.RegisterDelphiFunction(@TerminateProcessByID, 'TerminateProcessByID', cdRegister);
 S.RegisterDelphiFunction(@GetWindowProcessName, 'GetWindowProcessName', cdRegister);
 S.RegisterDelphiFunction(@GetProcessName, 'GetProcessName', cdRegister);
 S.RegisterDelphiFunction(@GetWindowProcessID, 'GetWindowProcessID', cdRegister);
 S.RegisterDelphiFunction(@IsAppResponding, 'IsAppResponding', cdRegister);
 S.RegisterDelphiFunction(@IsTabletOS, 'IsTabletOS', cdRegister);
 S.RegisterDelphiFunction(@ProgIDInstalled, 'ProgIDInstalled', cdRegister);
 S.RegisterDelphiFunction(@GetProcessorName, 'GetProcessorName', cdRegister);
 S.RegisterDelphiFunction(@GetProcessorIdentifier, 'GetProcessorIdentifier', cdRegister);
 S.RegisterDelphiFunction(@EmptyKeyQueue, 'EmptyKeyQueue', cdRegister);
 S.RegisterDelphiFunction(@TrimAppMemorySize, 'TrimAppMemorySize', cdRegister);
 S.RegisterDelphiFunction(@GetEnvironmentBlockSize, 'GetEnvironmentBlockSize', cdRegister);
 S.RegisterDelphiFunction(@GetDefaultPrinterName, 'GetDefaultPrinterName', cdRegister);
 S.RegisterDelphiFunction(@ListDrives, 'ListDrives', cdRegister);
 S.RegisterDelphiFunction(@MultiSzToStrings, 'MultiSzToStrings', cdRegister);
 S.RegisterDelphiFunction(@BrowseURL, 'BrowseURL', cdRegister);
 S.RegisterDelphiFunction(@IsValidURLProtocol, 'IsValidURLProtocol', cdRegister);
 S.RegisterDelphiFunction(@ExecAssociatedApp, 'ExecAssociatedApp', cdRegister);
 S.RegisterDelphiFunction(@CheckInternetConnection, 'CheckInternetConnection', cdRegister);
 S.RegisterDelphiFunction(@MakeSafeHTMLText, 'MakeSafeHTMLText', cdRegister);
 S.RegisterDelphiFunction(@RemoveURIQueryString, 'RemoveURIQueryString', cdRegister);
 S.RegisterDelphiFunction(@GetRegistryString, 'GetRegistryString', cdRegister);
 S.RegisterDelphiFunction(@RefreshEnvironment2, 'RefreshEnvironment2', cdRegister);
 S.RegisterDelphiFunction(@IsKeyPressed2, 'IsKeyPressed2', cdRegister);
 S.RegisterDelphiFunction(@SizeOfFile64, 'SizeOfFile64', cdRegister);
 S.RegisterDelphiFunction(@IsHugeFile, 'IsHugeFile', cdRegister);
 S.RegisterDelphiFunction(@SetTransparencyLevel, 'SetTransparencyLevel', cdRegister);
 S.RegisterDelphiFunction(@IsEqualResID, 'IsEqualResID', cdRegister);
 S.RegisterDelphiFunction(@GetGenericFileType, 'GetGenericFileType', cdRegister);
 S.RegisterDelphiFunction(@GetFileType2, 'GetFileType2', cdRegister);
 S.RegisterDelphiFunction(@ShowShellPropertiesDlg, 'ShowShellPropertiesDlg', cdRegister);
 S.RegisterDelphiFunction(@EllipsifyText, 'EllipsifyText', cdRegister);
 S.RegisterDelphiFunction(@CloneByteArray, 'CloneByteArray', cdRegister);
 S.RegisterDelphiFunction(@AppendByteArray, 'AppendByteArray', cdRegister);
 S.RegisterDelphiFunction(@IsUnicodeStream, 'IsUnicodeStream', cdRegister);
 S.RegisterDelphiFunction(@FileHasWatermark, 'FileHasWatermark', cdRegister);
 S.RegisterDelphiFunction(@FileHasWatermarkAnsi, 'FileHasWatermarkAnsi', cdRegister);
 S.RegisterDelphiFunction(@IsASCIIStream, 'IsASCIIStream', cdRegister);
 S.RegisterDelphiFunction(@IsASCIIFile, 'IsASCIIFile', cdRegister);
 S.RegisterDelphiFunction(@BytesToAnsiString, 'BytesToAnsiString', cdRegister);
 S.RegisterDelphiFunction(@UnicodeStreamToWideString, 'UnicodeStreamToWideString', cdRegister);
 S.RegisterDelphiFunction(@WideStringToUnicodeStream, 'WideStringToUnicodeStream', cdRegister);
 S.RegisterDelphiFunction(@GraphicToBitmap, 'GraphicToBitmap', cdRegister);
 S.RegisterDelphiFunction(@URIDecode, 'URIDecode', cdRegister);
 S.RegisterDelphiFunction(@URIEncode, 'URIEncode', cdRegister);
 S.RegisterDelphiFunction(@URLDecode, 'URLDecode2', cdRegister);
 S.RegisterDelphiFunction(@URLEncode, 'URLEncode2', cdRegister);
 S.RegisterDelphiFunction(@AllDigitsSame, 'AllDigitsSame', cdRegister);
  S.RegisterDelphiFunction(@DrawTextEx, 'DrawTextEx', CdStdCall);
   S.RegisterDelphiFunction(@CreateDC, 'CreateDC', CdStdCall);
   S.RegisterDelphiFunction(@FoldWrapText, 'FoldWrapText', cdRegister);
  S.RegisterDelphiFunction(@ValidateRect, 'ValidateRect', CdStdCall);
  S.RegisterDelphiFunction(@DeleteDC, 'DeleteDC', CdStdCall);
 S.RegisterDelphiFunction(@DeleteMetaFile, 'DeleteMetaFile', CdStdCall);
 S.RegisterDelphiFunction(@DeleteObject, 'DeleteObject', CdStdCall);
 S.RegisterDelphiFunction(@SetVolumeLabel, 'SetVolumeLabel', CdStdCall);
  S.RegisterDelphiFunction(@StrokeAndFillPath, 'StrokeAndFillPath', CdStdCall);
 S.RegisterDelphiFunction(@StrokePath, 'StrokePath', CdStdCall);
 S.RegisterDelphiFunction(@WidenPath, 'WidenPath', CdStdCall);
 S.RegisterDelphiFunction(@DPtoLP, 'DPtoLP', CdStdCall);
 S.RegisterDelphiFunction(@LPtoDP, 'LPtoDP', CdStdCall);
S.RegisterDelphiFunction(@StartDoc, 'StartDoc', CdStdCall);
 S.RegisterDelphiFunction(@EndDoc, 'EndDoc', CdStdCall);


 //S.RegisterDelphiFunction(@DescribePixelFormat, 'DescribePixelFormat', CdStdCall);
 //S.RegisterDelphiFunction(@DeviceCapabilities, 'DeviceCapabilities', CdStdCall);
 //of Forms  VCL
  S.RegisterDelphiFunction(@DisableTaskWindows, 'DisableTaskWindows', cdRegister);
   S.RegisterDelphiFunction(@Subclass3DWnd, 'Subclass3DWnd', cdRegister);
 S.RegisterDelphiFunction(@Subclass3DDlg, 'Subclass3DDlg', cdRegister);
 S.RegisterDelphiFunction(@SetAutoSubClass, 'SetAutoSubClass', cdRegister);
  S.RegisterDelphiFunction(@DoneCtl3D, 'DoneCtl3D', cdRegister);
 S.RegisterDelphiFunction(@InitCtl3D, 'InitCtl3D', cdRegister);


 S.RegisterDelphiFunction(@ExeType, 'ExeType', cdRegister);
 S.RegisterDelphiFunction(@ExeType, 'getExeType', cdRegister);
 S.RegisterDelphiFunction(@TextWrap, 'TextWrap', cdRegister);
  S.RegisterDelphiFunction(@SetCustomFormGlassFrame, 'SetCustomFormGlassFrame', cdRegister);
 S.RegisterDelphiFunction(@GetCustomFormGlassFrame, 'GetCustomFormGlassFrame', cdRegister);
 S.RegisterDelphiFunction(@SetApplicationMainFormOnTaskBar, 'SetApplicationMainFormOnTaskBar', cdRegister);
 S.RegisterDelphiFunction(@GetApplicationMainFormOnTaskBar, 'GetApplicationMainFormOnTaskBar', cdRegister);
  S.RegisterDelphiFunction(@KeyboardStateToShiftState1_P, 'KeyboardStateToShiftState1', cdRegister);
  S.RegisterDelphiFunction(@CompressWhiteSpace, 'CompressWhiteSpace', cdRegister);
  S.RegisterDelphiFunction(@IsASCIIDigit, 'IsASCIIDigit', cdRegister);
  S.RegisterDelphiFunction(@CompareNumberStr, 'CompareNumberStr', cdRegister);
  S.RegisterDelphiFunction(@HexToBuf1, 'HexToBuf', cdRegister);
  S.RegisterDelphiFunction(@BufToHex1, 'BufToHex', cdRegister);
  S.RegisterDelphiFunction(@HexToBuf1, 'HexToStrBuf', cdRegister);
  S.RegisterDelphiFunction(@BufToHex1, 'StrBufToHex', cdRegister);
  S.RegisterDelphiFunction(@GetCharFromVirtualKey, 'GetCharFromVirtualKey', cdRegister);
  S.RegisterDelphiFunction(@GetParentProcessID, 'GetParentProcessID', cdRegister);
  S.RegisterDelphiFunction(@FormInstanceCount, 'FormInstanceCount', cdRegister);
  S.RegisterDelphiFunction(@FormInstanceCount2, 'FormInstanceCount2', cdRegister);
 S.RegisterDelphiFunction(@FindAssociatedApp, 'FindAssociatedApp', cdRegister);
  S.RegisterDelphiFunction(@CreateShellLink, 'CreateShellLink2', cdRegister);
  S.RegisterDelphiFunction(@FileFromShellLink, 'FileFromShellLink', cdRegister);
  S.RegisterDelphiFunction(@IsShellLink, 'IsShellLink', cdRegister);
  S.RegisterDelphiFunction(@ResourceIDToStr, 'ResourceIDToStr', cdRegister);
  S.RegisterDelphiFunction(@IsEqualResID, 'IsEqualResID', cdRegister);
  S.RegisterDelphiFunction(@RecycleBinInfo, 'RecycleBinInfo', cdRegister);
  S.RegisterDelphiFunction(@SysImageListHandle, 'SysImageListHandle', cdRegister);
  S.RegisterDelphiFunction(@EmptyRecycleBin, 'EmptyRecycleBin', cdRegister);
  S.RegisterDelphiFunction(@ExploreFile, 'ExploreFile', cdRegister);
  S.RegisterDelphiFunction(@ExploreFolder, 'ExploreFolder', cdRegister);
  S.RegisterDelphiFunction(@ClearRecentDocs, 'ClearRecentDocs2', cdRegister);
  S.RegisterDelphiFunction(@AddToRecentDocs, 'AddToRecentDocs2', cdRegister);
 S.RegisterDelphiFunction(@StringsToMultiSz, 'StringsToMultiSz', cdRegister);
 S.RegisterDelphiFunction(@DrawTextOutline, 'DrawTextOutline', cdRegister);
 S.RegisterDelphiFunction(@CloneGraphicAsBitmap, 'CloneGraphicAsBitmap', cdRegister);
 S.RegisterDelphiFunction(@InvertBitmap, 'InvertBitmap', cdRegister);
  S.RegisterDelphiFunction(@InvertBitmap2, 'InvertBitmap2', cdRegister);

   S.RegisterDelphiFunction(@MakeFilenameInExePath, 'MakeFilenameInExePath', cdRegister);
 S.RegisterDelphiFunction(@YearOfDate, 'YearOfDate2', cdRegister);
 S.RegisterDelphiFunction(@MonthOfDate, 'MonthOfDate2', cdRegister);
 S.RegisterDelphiFunction(@DayOfDate, 'DayOfDate2', cdRegister);
 S.RegisterDelphiFunction(@HourOfTime, 'HourOfTime2', cdRegister);
 S.RegisterDelphiFunction(@MinuteOfTime, 'MinuteOfTime2', cdRegister);
 S.RegisterDelphiFunction(@SecondOfTime, 'SecondOfTime2', cdRegister);
 S.RegisterDelphiFunction(@IsLeapYear, 'IsLeapYear2', cdRegister);
 S.RegisterDelphiFunction(@DaysInMonth, 'DaysInMonth2', cdRegister);
 S.RegisterDelphiFunction(@MakeUTCTime, 'MakeUTCTime', cdRegister);
 S.RegisterDelphiFunction(@MakeLocalTimeFromUTC, 'MakeLocalTimeFromUTC', cdRegister);
 S.RegisterDelphiFunction(@IsStandardTime, 'IsStandardTime', cdRegister);
 S.RegisterDelphiFunction(@UnixNow, 'UnixNow', cdRegister);
 S.RegisterDelphiFunction(@NowString, 'NowString', cdRegister);
 S.RegisterDelphiFunction(@MakeClosedTag, 'MakeClosedTag', cdRegister);
 S.RegisterDelphiFunction(@MakeOpenTag, 'MakeOpenTag', cdRegister);
 S.RegisterDelphiFunction(@MakeBold, 'MakeBold', cdRegister);
 S.RegisterDelphiFunction(@MakeItalic, 'MakeItalic', cdRegister);
 S.RegisterDelphiFunction(@MakeUnderline, 'MakeUnderline', cdRegister);
 S.RegisterDelphiFunction(@MakeStrikeout, 'MakeStrikeout', cdRegister);
 S.RegisterDelphiFunction(@MakeCenter, 'MakeCenter', cdRegister);
 S.RegisterDelphiFunction(@MakeParagraph, 'MakeParagraph', cdRegister);
 S.RegisterDelphiFunction(@MakeCode, 'MakeCode', cdRegister);
 S.RegisterDelphiFunction(@MakeOption, 'MakeOption', cdRegister);
 S.RegisterDelphiFunction(@MakeHTMLFontSize, 'MakeHTMLFontSize', cdRegister);
 S.RegisterDelphiFunction(@AddQuotes, 'AddQuotes2', cdRegister);
 S.RegisterDelphiFunction(@AddSingleQuotes, 'AddSingleQuotes', cdRegister);
 S.RegisterDelphiFunction(@MakeHTMLParam, 'MakeHTMLParam', cdRegister);
 S.RegisterDelphiFunction(@MakeLink, 'MakeLink', cdRegister);
 S.RegisterDelphiFunction(@MakeLinkTarget, 'MakeLinkTarget', cdRegister);
 S.RegisterDelphiFunction(@MakeMailTo, 'MakeMailTo', cdRegister);
 S.RegisterDelphiFunction(@HTMLToDelphiColor, 'HTMLToDelphiColor', cdRegister);
 S.RegisterDelphiFunction(@ColorToHTMLHex, 'ColorToHTMLHex', cdRegister);
 S.RegisterDelphiFunction(@GetStringFromRes, 'GetStringFromRes', cdRegister);
 S.RegisterDelphiFunction(@EscapeText, 'EscapeText', cdRegister);
 S.RegisterDelphiFunction(@EncodeForXML, 'EncodeForXML', cdRegister);
 S.RegisterDelphiFunction(@IsStringAlpha, 'IsStringAlpha', cdRegister);
 S.RegisterDelphiFunction(@IsStringNumber, 'IsStringNumber', cdRegister);
 S.RegisterDelphiFunction(@EnsurePrefix, 'EnsurePrefix', cdRegister);
 S.RegisterDelphiFunction(@StringToAcceptableChars, 'StringToAcceptableChars', cdRegister);
 S.RegisterDelphiFunction(@StringIsAcceptable, 'StringIsAcceptable', cdRegister);
 S.RegisterDelphiFunction(@ValidateEMailAddress, 'ValidateEMailAddress', cdRegister);
 S.RegisterDelphiFunction(@FirstChar, 'FirstChar', cdRegister);
 S.RegisterDelphiFunction(@LastChar, 'LastChar', cdRegister);
 S.RegisterDelphiFunction(@StringIsEmpty, 'StringIsEmpty', cdRegister);
 S.RegisterDelphiFunction(@StringIsNotEmpty, 'StringIsNotEmpty', cdRegister);
 S.RegisterDelphiFunction(@StringHasSpacesInMiddle, 'StringHasSpacesInMiddle', cdRegister);
 S.RegisterDelphiFunction(@StringContains, 'StringContains', cdRegister);
 S.RegisterDelphiFunction(@SpacesToUnderscore, 'SpacesToUnderscore', cdRegister);
 S.RegisterDelphiFunction(@SpacesToPluses, 'SpacesToPluses', cdRegister);
 S.RegisterDelphiFunction(@SwapString, 'SwapString', cdRegister);
 S.RegisterDelphiFunction(@MakeCopyrightNotice, 'MakeCopyrightNotice', cdRegister);
 S.RegisterDelphiFunction(@WriteStringToFile, 'WriteStringToFile', cdRegister);
 //S.RegisterDelphiFunction(@WinExecandWait32, 'WinExecandWait32', cdRegister);
 S.RegisterDelphiFunction(@WinExecAndWait32V2, 'WinExecAndWait32V2', cdRegister);
 S.RegisterDelphiFunction(@WindowsExit, 'WindowsExit', cdRegister);
 S.RegisterDelphiFunction(@GetVersionInfo, 'GetVersionInfo2', cdRegister);
 S.RegisterDelphiFunction(@VersionString, 'VersionString', cdRegister);
 S.RegisterDelphiFunction(@CreateTempFileName, 'CreateTempFileName', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsTempDir, 'GetWindowsTempDir', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsDir, 'GetWindowsDir2', cdRegister);
 S.RegisterDelphiFunction(@GetSystemDir, 'GetSystemDir2', cdRegister);
 S.RegisterDelphiFunction(@GetSpecialFolderLocation, 'GetSpecialFolderLocation', cdRegister);
 S.RegisterDelphiFunction(@GetTextFileContents, 'GetTextFileContents', cdRegister);
 S.RegisterDelphiFunction(@GetBDSDir, 'GetBDSDir', cdRegister);
 S.RegisterDelphiFunction(@CaptionMessageDlg, 'CaptionMessageDlg', cdRegister);
 S.RegisterDelphiFunction(@StreamFileCopy, 'StreamFileCopy', cdRegister);
 S.RegisterDelphiFunction(@MakePercentString, 'MakePercentString', cdRegister);
 S.RegisterDelphiFunction(@DumpKey, 'DumpKey', cdRegister);
 S.RegisterDelphiFunction(@ValidateKey, 'ValidateKey2', cdRegister);
 S.RegisterDelphiFunction(@MakeInterbaseString, 'MakeInterbaseString', cdRegister);
 S.RegisterDelphiFunction(@ParseToken, 'ParseToken', cdRegister);
 S.RegisterDelphiFunction(@MatchBounds, 'MatchBounds', cdRegister);
 S.RegisterDelphiFunction(@LockWidth, 'LockWidth', cdRegister);
 S.RegisterDelphiFunction(@LockHeight, 'LockHeight', cdRegister);
 S.RegisterDelphiFunction(@LockBounds, 'LockBounds', cdRegister);
 S.RegisterDelphiFunction(@TruncateFilename, 'TruncateFilename', cdRegister);
 S.RegisterDelphiFunction(@PointInRect0_P, 'PointInRect2', cdRegister);
 S.RegisterDelphiFunction(@PointInRect1_P, 'PointInRect3', cdRegister);
 S.RegisterDelphiFunction(@VariantToStream, 'VariantToStream2', cdRegister);
 S.RegisterDelphiFunction(@StreamToVariant, 'StreamToVariant2', cdRegister);
 S.RegisterDelphiFunction(@AssignDocument, 'AssignDocument', cdRegister);
 S.RegisterDelphiFunction(@LoadStreamToWebBrowser, 'LoadStreamToWebBrowser', cdRegister);
 S.RegisterDelphiFunction(@SaveWebBrowserSourceToStream, 'SaveWebBrowserSourceToStream', cdRegister);
 S.RegisterDelphiFunction(@GetStylesFromBrowser, 'GetStylesFromBrowser', cdRegister);

  S.RegisterDelphiFunction(@REG_CURRENT_VERSION, 'REG_CURRENT_VERSION', cdRegister);
 S.RegisterDelphiFunction(@RegisteredOwner, 'RegisteredOwner', cdRegister);
 S.RegisterDelphiFunction(@RegisteredCompany, 'RegisteredCompany', cdRegister);
 S.RegisterDelphiFunction(@GetLocalComputerName, 'GetLocalComputerName2', cdRegister);
 S.RegisterDelphiFunction(@GetLocalUserName, 'GetLocalUserName2', cdRegister);
 S.RegisterDelphiFunction(@DeleteToRecycleBin, 'DeleteToRecycleBin', cdRegister);
 S.RegisterDelphiFunction(@RemoveBackSlash, 'RemoveBackSlash', cdRegister);
 S.RegisterDelphiFunction(@EnsureBackSlash, 'EnsureBackSlash2', cdRegister);
 S.RegisterDelphiFunction(@EnsureForwardSlash, 'EnsureForwardSlash', cdRegister);
 S.RegisterDelphiFunction(@RemoveLeadingSlash, 'RemoveLeadingSlash', cdRegister);
 S.RegisterDelphiFunction(@SameDirectories, 'SameDirectories', cdRegister);
 S.RegisterDelphiFunction(@EnsureExtensionHasLeadingPeriod, 'EnsureExtensionHasLeadingPeriod', cdRegister);
 S.RegisterDelphiFunction(@RemoveExtension, 'RemoveExtension', cdRegister);
 S.RegisterDelphiFunction(@GetModuleFileNameStr, 'GetModuleFileNameStr', cdRegister);
 S.RegisterDelphiFunction(@ModulePath, 'ModulePath', cdRegister);
 S.RegisterDelphiFunction(@IniFileName, 'IniFileName', cdRegister);
 S.RegisterDelphiFunction(@MakeFilenameInExePath, 'MakeFilenameInExePath', cdRegister);
 S.RegisterDelphiFunction(@IsBitSet, 'IsBitSet', cdRegister);
 S.RegisterDelphiFunction(@SetBit, 'SetBit6', cdRegister);
 S.RegisterDelphiFunction(@UnSetBit, 'UnSetBit', cdRegister);
 S.RegisterDelphiFunction(@FlipBit, 'FlipBit', cdRegister);
 S.RegisterDelphiFunction(@GetCachedFileFromURL, 'GetCachedFileFromURL', cdRegister);
 S.RegisterDelphiFunction(@IAddrToHostName, 'IAddrToHostName', cdRegister);
 S.RegisterDelphiFunction(@GetIEHandle, 'GetIEHandle', cdRegister);
 S.RegisterDelphiFunction(@GetTextfromHandle, 'GetTextFromHandle', cdRegister);
 S.RegisterDelphiFunction(@Duplicate_Webbrowser, 'Duplicate_Webbrowser', cdRegister);
 S.RegisterDelphiFunction(@FillWebForm, 'FillWebForm', cdRegister);
 S.RegisterDelphiFunction(@WB_LoadHTML, 'WB_LoadHTML', cdRegister);
 //S.RegisterDelphiFunction(@RecordsetFromXML, 'RecordsetFromXML', cdRegister);
 S.RegisterDelphiFunction(@NetSend, 'NetSend', cdRegister);
 //S.RegisterDelphiFunction(@RecordsetToXML, 'RecordsetToXML', cdRegister);
 S.RegisterDelphiFunction(@RecordsetFromXML2, 'RecordsetFromXML2', cdRegister);
 S.RegisterDelphiFunction(@RecordsetToXML2, 'RecordsetToXML2', cdRegister);
  S.RegisterDelphiFunction(@GlobalLock, 'GlobalLock', CdStdCall);

 S.RegisterDelphiFunction(@CopyHTMLToClipBoard, 'CopyHTMLToClipBoard', cdRegister);
 S.RegisterDelphiFunction(@DumpDOSHeader, 'DumpDOSHeader', cdRegister);
 S.RegisterDelphiFunction(@DumpPEHeader, 'DumpPEHeader', cdRegister);
 S.RegisterDelphiFunction(@DumpOptionalHeader, 'DumpOptionalHeader', cdRegister);
 S.RegisterDelphiFunction(@RFC1123ToDateTime, 'RFC1123ToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToRFC1123, 'DateTimeToRFC1123', cdRegister);
 S.RegisterDelphiFunction(@checkSystem, 'checkSystem', cdRegister);
 S.RegisterDelphiFunction(@checkSystem, 'getSystemReport', cdRegister);
 S.RegisterDelphiFunction(@checkSystem, 'SystemCheck', cdRegister);



  { function StringsToMultiSz(const Strings: Classes.TStrings; const MultiSz: PChar; const BufSize: Integer): Integer;
   procedure DrawTextOutline(const Canvas: Graphics.TCanvas; const X, Y: Integer; const Text: string);
  function CloneGraphicAsBitmap(const Src: Graphics.TGraphic; const PixelFmt: Graphics.TPixelFormat;
  const TransparentColor: Graphics.TColor): Graphics.TBitmap;
   procedure InvertBitmap(const ABitmap: Graphics.TBitmap); //overload;
  procedure InvertBitmap2(const SrcBmp, DestBmp: Graphics.TBitmap); //overload;
  }

  {function CreateShellLink(const LinkFileName, AssocFileName, Desc, WorkDir,
  Args, IconFileName: string; const IconIdx: Integer): Boolean;
  function FileFromShellLink(const LinkFileName: string): string;
  function IsShellLink(const LinkFileName: string): Boolean;
  function ResourceIDToStr(const ResID: PChar): string;
  function IsEqualResID(const R1, R2: PChar): Boolean;}


  // procedure HexToBuf(HexStr: string; var Buf);
  //function BufToHex(const Buf; const Size: Cardinal): string;

 //   function IsASCIIDigit(const Ch: Char): Boolean;
 // function CompareNumberStr(const S1, S2: string): Integer;


  //function SizeOfFile64(const FileName: string): Int64;
  //function IsHugeFile(const FileName: string): Boolean;

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdBaseComponent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdBaseComponent) do begin
    RegisterMethod(@TIdBaseComponent.GetVersion, 'GetVersion');
    RegisterPropertyHelper(@TIdBaseComponentVersion_R,nil,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UtilsMax4(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdBaseComponent(CL);
end;

 
 
{ TPSImport_UtilsMax4 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UtilsMax4.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UtilsMax4(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UtilsMax4.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UtilsMax4(ri);
  RIRegister_UtilsMax4_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
