unit uPSI_AfUtils;
{
  afcom     char is pchar!
  more of winapi funct with w_   morse code inside , webonform  - 472 functions  locs=3096
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
  TPSImport_AfUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 

{ compile-time registration functions }
procedure SIRegister_AfUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AfUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows, controls, shellapi, TlHelp32,
  AfUtils, wiwin32, REGiSTRY, PsAPI, messages, WinSpool, graphics, forms, comctrls, urlmon, mshtml, SHDocVw, TypInfo;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AfUtils]);
end;

function EnumWindowsProc2(Handle: THandle; LParam: TStrings): Boolean; stdcall;
var
  St: array [0..256] of Char;
  St2: string;
begin
  if Windows.IsWindowVisible(Handle) then
  begin
    GetWindowText(Handle, St, SizeOf(St));
    St2 := St;
    if St2 <> '' then
      with TStrings(LParam) do
        AddObject(St2, TObject(Handle));
  end;
  Result := True;
end;

 function GetMDACVersion2: string;
 var
  reg: TRegistry;
 begin
   reg := TRegistry.Create;
   try
    reg.Rootkey:= HKEY_LOCAL_MACHINE;
    reg.Access:= KEY_READ;            //least privilege !
    if not reg.OpenKeyReadOnly('Software\Microsoft\DataAccess') then
    //if not reg.OpenKey('Software\Microsoft\DataAccess',false) then
      //Exit;
      //writeln('exit of openkey');
    result:= reg.ReadString('FullInstallVer');
  finally
    reg.CloseKey;
    reg.free;
  end;
 end;

 procedure Formanimation(Sender: TObject; adelay: integer);

  procedure delay(msec: Longint);
  var
    start, stop: Longint;
  begin
    start := GetTickCount;
    repeat
      stop := GetTickCount;
      Application.ProcessMessages;
    until (stop - start) >= msec;
  end;
var
  maxx, maxy: Integer;

  MyHand: HWND;
  MyDc: HDC;
  MyCanvas: TCanvas;
  hal, hat, hak, haa: Integer;
begin
  maxx := (Sender as TForm).Width;
  maxy := (Sender as TForm).Height;
  hal  := 2;
  hat  := 2;

  MyHand   := GetDesktopWindow;
  MyDc     := GetWindowDC(MyHand);
  MyCanvas := TCanvas.Create;
  MyCanvas.Handle := MyDC;
  MyCanvas.Brush.Color := (Sender as TForm).Color;

  repeat
    if hat + (maxy div 24) >= maxy then
    begin
      hat := maxy
    end
    else
    begin
      hat := hat + (maxy div 24);
    end;

    if hal + (maxx div 24) >= maxx then
    begin
      hal := maxx
    end
    else
    begin
      hal := hal + (maxx div 24);
    end;
    hak := (Sender as TForm).Left + ((Sender as TForm).Width div 2) - (hal div 2);
    haa := (Sender as TForm).Top + ((Sender as TForm).Height div 2) - (hat div 2);
    MyCanvas.Rectangle(hak, haa, hak + hal, haa + hat);
    delay(adelay); //10
  until (hal = maxx) and (hat = maxy);
  (Sender as TForm).Show;
  //mciGetErrorString(
end;



 // Search for the first available port

function ComPortSelect: Integer;
var
  s: string;
  n: Integer;

  function DeviceAvail(const Dev: string): Boolean;
  var
    hDev: Cardinal;
    IsModem: Boolean;
    ComDevProp: TCommProp;
  begin
    hDev := CreateFile(PChar(Dev), GENERIC_READ, 0, nil, OPEN_EXISTING, 0, 0);
    GetCommProperties(hdev, ComDevProp);
    isModem := ComDevProp.dwProvSubType = PST_MODEM;
    CloseHandle(hDev);
    Result := (hDev <> INVALID_HANDLE_VALUE) and not IsModem;
  end;

begin
  s := ParamStr(1);                        // ie COM9
  if DeviceAvail(s) then                   // User forcing Com selection
    begin
      Delete(s, 1, 3);
      n := StrToInt(s);
    end
  else
    for n := 10 downto 1 do                // Virtual devices are popular
      begin
        s := 'COM' + IntToStr(n);
        if DeviceAvail(s) then Break;
      end;
  Result := n;                             // Zero if no port is detected
end;

function LinesCount(sfilename:string):double;
var
 hFile : TextFile;
 sLine : String;
 iLinescount: Double;
begin
result:=0;
if not FileExists(sfilename) then exit;

AssignFile(hFile, sFileName);
Reset(hFile);

iLinescount:=0;
while NOT EOF(hFile) do
 begin
   ReadLn(hFile, sLine);
   iLinescount:=iLinescount+1;
 end;
 closefile(hfile);

result:=iLinescount;
end;


function TextFileLineCount(const FileName: string): integer;
const
 BuffSize = 4096;
var
 i: integer;
 FileVar: File;
 MoreData: boolean;
 Buffer: array[1..BuffSize] of char;
 BuffCount: integer;
begin
 Result := 0;
 Application.ProcessMessages;
 {$I-}
 AssignFile(FileVar, FileName);
 try
   Reset(FileVar, 1);
   MoreData := True;
 except
   MoreData := False;
 end;
 while MoreData do begin
   try
     BlockRead(FileVar, Buffer, BuffSize, BuffCount);
     for i := 1 to BuffCount do
       if Buffer[i] = #13 then
         Inc(Result);
     MoreData := BuffCount = BuffSize;
   except
     MoreData := False;
   end;
 end;
 CloseFile(FileVar);
end;

function GetLinesCount(sFileName : String): Integer;
var
oSL: TStringlist;
begin
  oSL:= TStringlist.Create;
  oSL.LoadFromFile(sFileName);
  result:= oSL.Count;
  oSL.Free;
end; //[/DELPHI]




function ComposeDateTime(Date,Time : TDateTime) : TDateTime;
begin
  if Date < 0 then Result := trunc(Date) - frac(Time)
  else Result := trunc(Date) + frac(Time);
end;


 function FullTimeToStr(SUMTime: TDateTime): string;
    var
    StrHor,
    StrMin :string;
    TotHor :double;
    begin
         TotHor := SUMTime *24;
         if (TotHor -Trunc(TotHor)) > 0.9999 then
         TotHor := Round(TotHor);
         StrHor := FormatFloat('##0:', Int(TotHor));
         StrMin := FormatDateTime('nn:ss', Frac(TotHor)/24);
         Result := StrHor +StrMin;
    end;


 function GetBaseAddress(PID:DWORD):DWORD;
var
hOpen:  THandle;
hMod:   THandle;
MODINFO:  MODULEINFO;
null:	 DWORD;
begin
  hOpen := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, PID);
  if hOpen <> INVALID_HANDLE_VALUE then begin
	EnumProcessModules(hOpen, @hMod, SizeOf(hMod), null);
	GetModuleInformation(hOpen, hMod, @MODINFO, SizeOf(MODINFO));
	Result := Cardinal(MODINFO.lpBaseOfDll);
	CloseHandle(hOpen);
  end;
end;

procedure GetScreenShot(var ABitmap : TBitmap);
var
  DC : THandle;
begin
  if Assigned(ABitmap) then begin// Check Bitmap<>NIL
    DC := GetDC(0); // Get Desktop DC
    try
      ABitmap.Width := Screen.Width; // Adjust Bitmapsize..
      ABitmap.Height := Screen.Height; // ..to screen size
      BitBlt(ABitmap.Canvas.Handle, // Copy
             0,0,Screen.Width,Screen.Height, // Desktop
             DC, // into
             0,0, // the
             SrcCopy // Bitmap
        );
    finally
      ReleaseDC(0, DC); // Relase DC
    end;
  end;
end;


function LoadFile(const FileName: TFileName): string;
   begin
     with TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite) do begin
       try
         SetLength(Result, Size);
         Read(Pointer(Result)^, Size);
       except
         Result := '';  // Deallocates memory
         Free;
         raise;
       end;
       Free;
     end;
   end;


 function URLEncode(const S: string): string;
var I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    {$IFDEF UNICODE}
    if CharInSet(S[I], ['A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.']) then
    {$ELSE}
    if S[I] in ['A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.'] then
    {$ENDIF}
      Result := Result + S[I]
    else
      Result := Result + '%' + IntToHex(Ord(S[I]), 2);
  end;
end;


function TRestRequest_createStringStreamFromStringList(strings:
    TStringList): TStringStream;
var
  key, value, strParam: string;
  it: integer;
begin
  Result:= TStringStream.Create('');
  for it:= 0 to strings.Count - 1 do begin
    key:= strings.Names[it];
    value:= strings.ValueFromIndex[it];
    strParam:= urlEncode(key) + '=' + urlEncode(value);
    if not (it = strings.Count - 1) then strParam:= strParam + '&';
    Result.WriteString(strParam);
  end;
end;

procedure UpdateExeResource(Const Source,Dest:string);
var
  Stream     : TFileStream;
  hDestRes   : THANDLE;
  lpData     : Pointer;
  cbData     : DWORD;
begin
  Stream := TFileStream.Create(Source,fmOpenRead or fmShareDenyNone);
  try
    Stream.Seek(0, soFromBeginning);
    cbData:=Stream.Size;
    if cbData>0 then
    begin
      GetMem(lpData,cbData);
      try
        Stream.Read(lpData^, cbData);
        hDestRes:= BeginUpdateResource(PChar(Dest), False);
        if hDestRes <> 0 then
          if UpdateResource(hDestRes, RT_RCDATA,'DATA',0,lpData,cbData) then
          begin
            if not EndUpdateResource(hDestRes,FALSE) then RaiseLastOSError
          end
          else
          RaiseLastOSError
        else
        RaiseLastOSError;
      finally
        FreeMem(lpData);
      end;
    end;
  finally
    Stream.Free;
  end;
end;

(*{procedure AddRes(exeName, resName: string);
  var
    exeModule: TNTModule;
    resFile  : TResModule;
  begin
    if ExtractFileExt(exeName) = '' then
      exeName := ChangeFileExt(exeName, '.exe');
    exeModule := TNTModule.Create;
    try
      exeModule.LoadFromFile(exeName);
      resFile := TResModule.Create;
      resFile.LoadFromFile(resName);
      exeModule.AddResource(resFile.ResourceDetails[0]);
      exeModule.SaveToFile(exeName);
    finally FreeAndNil(exeModule); end;
  end; //{ AddRes }
 }*)


 function RunAsAdmin(hWnd: HWND; filename: string; Parameters: string): Boolean;
{
    See Step 3: Redesign for UAC Compatibility (UAC)
    http://msdn.microsoft.com/en-us/library/bb756922.aspx
}
var
    sei: TShellExecuteInfo;
begin
    ZeroMemory(@sei, SizeOf(sei));
    sei.cbSize := SizeOf(TShellExecuteInfo);
    sei.Wnd := hwnd;
    sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
    sei.lpVerb := PChar('runas');
    sei.lpFile := PChar(Filename); // PAnsiChar;
    if parameters <> '' then
        sei.lpParameters := PChar(parameters); // PAnsiChar;
    sei.nShow := SW_SHOWNORMAL; //Integer;
 
    Result := ShellExecuteEx(@sei);
end;




const
Zero = 0;
ID_Static = 200;

var
MsgClass: TWndClass;
aResult: record hWnd, Result: Integer; end;
aryMsgForms: Array of Integer;
  { aryMsgForms has all of the handles of the message windows
    this will allow more than one message window to exist }
aryEnable: Array of Integer;
  // aryEnable has all of the handles for the dis-abled windows
FontBut, aFont: Cardinal;
hFParent: Integer;


function FoundTopLevel(hWnd, LParam: Integer): BOOL; StdCall;
var
i: Integer;
begin
// this is the call back function for EnumThreadWindows  function
Result := True;
// return true to get all windows

{I wanted to be able to show more than one Message-window, the Msg-windows
 are also top-level, and I did not want any Msg-Wnds to be disabled,
 so I add all Msg-Wnds handles to the aryMsgForms array}
for i := Zero to High(aryMsgForms) do
  if hWnd = aryMsgForms[i] then Exit;
  // if a top-level is a Msg-Wnd then exit and do NOT add it to aryEnable

SetLength(aryEnable, Length(aryEnable)+1);
// make aryEnable larger and add window handle
aryEnable[High(aryEnable)] := hWnd;
end;



procedure DisableForms;
var
i: Integer;
begin
{ if there is no aryEnable handles, then use EnumThreadWindows
 to get all top-level windows in the aryEnable array }
if Length(aryEnable) = Zero then begin
  EnumThreadWindows(GetCurrentThreadId, @FoundTopLevel, Zero);

  // after all top-level are in aryEnable, dis-able all with EnableWindow( )
  for i := Zero To High(aryEnable) do
   EnableWindow(aryEnable[i], False);
  end;
end;

procedure DeleteMsgForm(Handle: Integer);
var
i: Integer;
begin
// this procedure removes a handle form the aryMsgForms array
for i := Zero to High(aryMsgForms) do
  if Handle = aryMsgForms[i] then begin
    if i <> High(aryMsgForms) then
      MoveMemory(@aryMsgForms[i],@aryMsgForms[i+1],
                 SizeOf(Integer)*(High(aryMsgForms)-i));
  // the MoveMemory will move all of the array data forward one position
    setLength(aryMsgForms, Length(aryMsgForms)-1);
    Break;
    end;
end;


//procedure ShowMsg(hParent: Integer; const Mess, Title: String);
{ ShowMsg is a simple "Modal" window that does NOT Block code progression.
  It is mostly to show you how block user input to forms on screen}
procedure ShowMsg(hParent: Integer; const Mess, Title: String);
var
hNew, hBut: Integer;
begin
{this ShowMsg procedure creates a modal message box window.
 It does NOT block code progression like the API MessageBox function.
 But it does disable all top-level windows for a modal effect.
 For this lesson, the code here is simple, I do NOT size the message window
 or offer any options except the message and title strings,
 there can only be an OK button}
hNew := CreateWindow(MsgClass.lpszClassName, PChar(Title),
             WS_CAPTION or WS_POPUP or WS_VISIBLE,
             ((GetSystemMetrics(SM_CXSCREEN) div 2)-130)+(High(aryMsgForms)*6),
             (GetSystemMetrics(SM_CYSCREEN) div 2)-75, 260, 124,
              hParent, Zero, hInstance, nil);

if hNew = Zero then Exit;

setLength(aryMsgForms, Length(aryMsgForms)+1);
aryMsgForms[High(aryMsgForms)] := hNew;
{ you must add this window handle to the aryMsgForms array
  to have more than one message window}

SendMessage(CreateWindow('STATIC',PChar(Mess),
 WS_VISIBLE or WS_CHILD,6,6,246,54,hNew,ID_Static,hInstance,nil),
    WM_SETFONT,aFont,Zero);

hBut := CreateWindow('BUTTON', 'O K',
    WS_VISIBLE or WS_CHILD or BS_PUSHBUTTON or WS_BORDER or WS_TABSTOP,
    102,64,58,26,hNew,IDOk,hInstance,nil);
SendMessage(hBut, WM_SETFONT, FontBut, Zero);
SetFocus(hBut);

DisableForms;
// call DisableForms procedure to have a Modal effect

// WaitTilClose(hNew);
// if you want to block code progression then add the WaitTilClose above
end;

function MsgFunc(hWnd,Msg,wParam,lParam:Integer):Integer; stdcall;
var
PaintS: TPaintStruct;
i: Integer;
cRect: TRect;
begin
// this is the Window Proc for all of the message windows
case Msg of
  WM_CLOSE: begin
    // when a message window closes the aResult is set
    if (aResult.hWnd <> hWnd) then // you test to see if aResult.Result is valid
      begin
      aResult.Result := IDCancel;
      aResult.hWnd := hWnd;
      end;
    DeleteMsgForm(hWnd);
    // remove this window from the aryMsgForms array with DeleteMsgForm
    if High(aryMsgForms) < Zero then
      begin
      // if all of the msg forms are closed, then High(aryMsgForms) is -1
      // you need to enable all the top windows
      for i := Zero to High(aryEnable) do
        EnableWindow(aryEnable[i], True);
      SetLength(aryEnable, Zero); // reset aryEnabled array to zero
      end;
    end;

  WM_PAINT: begin
    // to have a visual clue for a message window I paint a white line
    GetClientRect(hWnd, cRect);
    BeginPaint(hWnd, PaintS);
    SelectObject(PaintS.hDC, GetStockObject(NULL_BRUSH));
    SelectObject(PaintS.hDC, GetStockObject(WHITE_PEN));
    Rectangle(Paints.hDC,cRect.Left, cRect.Top, cRect.Right, cRect.Bottom);
    EndPaint(hWnd,PaintS);
    Result := Zero;
    Exit;
    end;

  WM_COMMAND: if HIWORD(WParam) = BN_CLICKED then
    begin
    // aResult is used for the WaitMessage repeat loop, so set it for button click
    aResult.Result := LOWORD(wParam); // button ID
    aResult.hWnd := hWnd; // set aResult.hWnd to handle for valid Result in WM_CLOSE
    PostMessage(hWnd, WM_CLOSE, Zero, Zero); // any button clicked closes window
    end;
  end;

Result := DefWindowProc(hWnd,Msg,wParam,lParam);
end;


function DoUserMsgs: Boolean;
var
aMsg: TMSG;
begin
{ for the WaitTilClose repeat loop , you will need to
 get the message queue messages and dispatch them } 
Result := False; // WaitTilClose loop continues as long as Result is False
while PeekMessage(aMsg, Zero, Zero, Zero, PM_REMOVE) do
  if aMsg.message = WM_QUIT then
     begin
     Result := True;
// IMPORTANT, must get WM_QUIT and repost it, set Result so repeat loop is ended
     PostQuitMessage(Zero);
     Break;
     end else
     if not IsDialogMessage(GetActiveWindow, aMsg) then
       begin
       TranslateMessage(aMsg);
       DispatchMessage(aMsg);
       end;
end;


function WaitTilClose(hWnd: Integer): Integer;
begin
// this function allows you to wait until the hWnd window closes
aResult.Result := IDCancel;
aResult.hWnd := Zero;

repeat
  if DoUserMsgs or (aResult.hWnd = hWnd) then Break;
  WaitMessage;
  { the  WaitMessage  function is what allows this to be a "Modal" window AND
    wait for this MsgResult function to return. The WaitMessage  function will
    yield control to other threads when this thread has no messages }
  until (aResult.hWnd = hWnd) or (not IsWindow(hWnd));
Result := aResult.Result;
end;


type
  //PMorseEntry = ^TMorseEntry;
   TMorseEntry = record
       MorseChar : Char;
       KeyID : Word;
    end;

var  morsTblRec: array[1..36] of TMorseEntry;

procedure AddTableEntry(idx: byte; Symbol : Char; KeyID : Word);
var
   ListData : TMorseEntry;
begin
   //New(ListData);
   ListData.MorseChar:= Symbol;
   ListData.KeyID := KeyID;
   morsTblRec[idx]:= ListData;
end;

procedure FillMorseTable();
begin
//MorseTable.Clear;
AddTableEntry(1,#65, $009); // A .-
AddTableEntry(2,#66, $056); // B -...
AddTableEntry(3,#67, $066); // C -.-.
AddTableEntry(4,#68, $016); // D -..
AddTableEntry(5,#69, $001); // E .
AddTableEntry(6,#70, $065); // F ..-.
AddTableEntry(7,#71, $01A); // G --.
AddTableEntry(8,#72, $055); // H ....
AddTableEntry(9,#73, $005); // I ..
AddTableEntry(10,#74, $0A9); // J .---
AddTableEntry(11,#75, $026); // K -.-
AddTableEntry(12,#76, $059); // L .-..
AddTableEntry(13,#77, $00A); // M --
AddTableEntry(14,#78, $006); // N -.
AddTableEntry(15,#79, $02A); // O ---
AddTableEntry(16,#80, $069); // P .--.
AddTableEntry(17,#81, $09A); // Q --.-
AddTableEntry(18,#82, $019); // R .-.
AddTableEntry(19,#83, $015); // S ...
AddTableEntry(20,#84, $002); // T -
AddTableEntry(21,#85, $025); // U ..-
AddTableEntry(22,#86, $095); // V ...-
AddTableEntry(23,#87, $029); // W .--
AddTableEntry(24,#88, $096); // X -..-
AddTableEntry(25,#89, $0A6); // Y -.--
AddTableEntry(26,#90, $05A); // Z --..
AddTableEntry(27,#49, $2A9); // 1 .----
AddTableEntry(28,#50, $2A5); // 2 ..---
AddTableEntry(29,#51, $295); // 3 ...--
AddTableEntry(30,#52, $255); // 4 ....-
AddTableEntry(31,#53, $155); // 5 .....
AddTableEntry(32,#54, $156); // 6 -....
AddTableEntry(33,#55, $15A); // 7 --...
AddTableEntry(34,#56, $16A); // 8 ---..
AddTableEntry(35,#57, $1AA); // 9 ----.
AddTableEntry(36,#48, $2AA); // 0 -----
end;


function GetMorseID(InChar : Char): Word;
var
ScanPos: Integer;
begin
FillMorseTable;
result:= 0;
 for ScanPos:= 1 to 36 do begin
  if(InChar = morsTblRec[scanpos].MorseChar) then begin
     result:= morsTblRec[ScanPos].KeyID;
    break;
  end;
 end;
end;


function GetMorseString2(InChar : Char): string;
var
MorseData : Word; CodePos, OutCode: Byte;
ScanPos : Integer;
begin
FillMorseTable;
result:= '';
 morsedata:= getmorseid(inchar);
  if(MorseData > 0) then begin
    CodePos := 0;
   repeat
    OutCode:= (MorseData and (3 shl CodePos)) shr CodePos;
     CodePos:= CodePos + 2;
     if(OutCode > 0) then begin
       result:= result + inttostr(outcode)
       //writeln('in loop')   debug
     end;
   until (OutCode = 0);
  end;
end;

function GetMorseLine(dots: boolean): string;
var
MorseData : Word; CodePos, OutCode: Byte;
ScanPos : Integer;
sign: char;
begin
result:= '';
FillMorseTable;
 for ScanPos:= 1 to 36 do begin
     morsedata:= MorsTblrec[ScanPos].KeyID;
   if(MorseData > 0) then begin
    CodePos:= 0;
 //result:= + MorseTblrec[ScanPos].Morsechar
    repeat
    OutCode:= (MorseData and (3 shl CodePos)) shr CodePos;
     CodePos:= CodePos + 2;
     if(OutCode > 0) then begin
     if dots then begin
     if outcode = 1 then sign:= '.' else sign:= '-';
       result:= result + sign
       end else
         result:= result + inttostr(outcode)
       //writeln('in loop')   debug
     end;
   until (OutCode = 0);
   result:= result+#9+MorsTblrec[ScanPos].Morsechar+#13+#10
  end;
 end;
end;

function GetMorseSign(InChar : Char): string;
var
MorseData : Word; CodePos, OutCode: Byte;
ScanPos : Integer;
sign: char;
begin
result:= '';
FillMorseTable;
  morsedata:= getmorseid(inchar);
  if(MorseData > 0) then begin
    CodePos := 0;
   repeat
    OutCode:= (MorseData and (3 shl CodePos)) shr CodePos;
     CodePos:= CodePos + 2;
     if(OutCode > 0) then begin
        if outcode = 1 then sign:= '.' else sign:= '-';
       result:= result + sign
       //writeln('in loop')   debug
     end;
   until (OutCode = 0);
  end;
end;

function ExtComName(ComNr: DWORD): string;
begin
  if ComNr > 9 then
    Result := Format('\\\\.\\COM%d', [ComNr])
  else
    Result := Format('COM%d', [ComNr]);
end;

function CheckCom(AComNumber: Integer): Integer;
var
  FHandle: THandle;
begin
  Result := 0;
  FHandle := CreateFile(PChar(ExtComName(AComNumber)),
    GENERIC_READ or GENERIC_WRITE,
    0, {exclusive access}
    nil, {no security attrs}
    OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL,
    0);
  if FHandle <> INVALID_HANDLE_VALUE then
    CloseHandle(FHandle)
  else
    Result := GetLastError;
end;

type
  TArrayPORT_INFO_1 = array[0..0] of PORT_INFO_1;
  PArrayPORT_INFO_1 = ^TArrayPORT_INFO_1;

function CheckLPT1: string;
var
  apiBuffer: PArrayPORT_INFO_1;
  lwBufferSize: LongWord;
  lwPortCount: LongWord;
  lwIndex: LongWord;
  sMessage: string;
begin
  {Find required size of the buffer}
  EnumPorts(nil, 1, nil, 0, lwBufferSize, lwPortCount);
  {Alloc and fill buffer}
  apiBuffer := AllocMem(lwBufferSize);
  EnumPorts(nil, 1, apiBuffer, lwBufferSize, lwBufferSize, lwPortCount);
  {Search returned buffer}
  {Using word so must check for 0 as 0 - 1 = 4294967295  not -1!}
  if lwPortCount = 0 then
    sMessage := 'No ports installed on this system'
  else
  begin
    sMessage := 'LPT1: not found on this system';
    for lwIndex := 0 to lwPortCount - 1 do
    begin
      if UpperCase(apiBuffer[lwIndex].pName) = 'LPT1:' then
      begin
        sMessage := 'LPT1: exists';
        Break;
      end;
    end;
  end;
  {Free the buffer and show result}
  FreeMem(apiBuffer);
  result:= sMessage;
end;


function ComponentToStringProc(Component: TComponent): string;
var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result:= StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

function StringToComponentProc(Value: string): TComponent;
var
  StrStream:TStringStream;
  BinStream: TMemoryStream;
begin
  StrStream:= TStringStream.Create(Value);
  try
    BinStream:= TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result:= BinStream.ReadComponent(nil);
    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

procedure MyCopyFile(Name1,Name2:string);
var FSS, FST, MS : TStream; // Source, Target and Memory
begin
   // Open Source File
   FSS:=TFileStream.Create(Name1,fmOpenRead or fmShareDenyNone);
   // Create Target File
   FST:=TFileStream.Create(Name2,fmCreate or fmShareExclusive);
   // Create Memory stream
   MS:=TMemoryStream.Create;
   // Load Source file into Memory
   MS.CopyFrom(FSS,FSS.Size);
   // note that both the Source file stream and the
   // memory stream are now at their ends, I don't need
   // the source stream any more though, so I free it...
   FSS.Free;
   // but, I have to reset the memory to it's start
   MS.Seek(0,soFromBeginning);
   // Now I can pump it to the target file:
   FST.CopyFrom(MS,MS.Size);
   // And voila!
   FST.Free;
   MS.Free;
   // Now my stuff is copied.
end;

 procedure VarClear2(var V: variant);
 begin
    varclear(V)
 end;

 function DynamicDllCallName(Dll: String; const Name: String; HasResult: Boolean; var Returned: Cardinal; const Parameters: array of integer): Boolean;
var
  prc: Pointer;
  x, n: Integer;
  p: Pointer;
  dllh: THandle;
begin
  dllh := GetModuleHandle(PChar(Dll));
  if dllh = 0 then begin
    dllh := LoadLibrary(PChar(Dll));
  end;
  if dllh <> 0 then begin
    prc := GetProcAddress(dllh, PChar(Name));
    if Assigned(prc) then begin
      n := High(Parameters);
      if n > -1 then begin
        x := n;
        repeat
          p := Pointer(Parameters[x]);
          asm
            PUSH p
          end;
          Dec(x);
        until x = -1;
      end;
      asm
        CALL prc
      end;
      if HasResult then begin
        asm
          MOV p, EAX
        end;
        Returned := Cardinal(p);
      end else begin
        Returned := 0;
      end;
    end else begin
      Returned := 0;
    end;
    Result := Assigned(prc);
  end else begin
    Result := false;
  end;
end;

 function DynamicDllCallNameS(Dll: String; const Name: String; HasResult: Boolean; var Returned: Cardinal; const Parameters: array of string): Boolean;
var
  prc: Pointer;
  x, n: Integer;
  p: Pointer;
  dllh: THandle;
begin
  dllh := GetModuleHandle(PChar(Dll));
  if dllh = 0 then begin
    dllh := LoadLibrary(PChar(Dll));
  end;
  if dllh <> 0 then begin
    prc := GetProcAddress(dllh, PChar(Name));
    if Assigned(prc) then begin
      n := High(Parameters);
      if n > -1 then begin
        x := n;
        repeat
          p := Pointer(Parameters[x]);
          asm
            PUSH p
          end;
          Dec(x);
        until x = -1;
      end;
      asm
        CALL prc
      end;
      if HasResult then begin
        asm
          MOV p, EAX
        end;
        Returned := Cardinal(p);
      end else begin
        Returned := 0;
      end;
    end else begin
      Returned := 0;
    end;
    Result := Assigned(prc);
  end else begin
    Result := false;
  end;
end;

// Calls a function from a loaded library
function DynamicDllCall(hDll: THandle; const Name: String; HasResult: Boolean; var Returned: Cardinal; const Parameters: array of integer): Boolean;
var
  prc: Pointer;
  x, n: Integer;
  p: Pointer;
begin
  prc := GetProcAddress(hDll, PChar(Name));
  if Assigned(prc) then begin
    n := High(Parameters);
    if n > -1 then begin
      x := n;
      repeat
        p := Pointer(Parameters[x]);
        asm
          PUSH p
        end;
        Dec(x);
      until x = -1;
    end;
    asm
      CALL prc
    end;
    if HasResult then begin
      asm
        MOV p, EAX
      end;
      Returned := Cardinal(p);
    end else begin
      Returned := 0;
    end;
  end else begin
    Returned := 0;
  end;
  Result := Assigned(prc);
end;


procedure LV_InsertFiles(strPath: string; ListView: TListView; ImageList: TImageList);
var
  i: Integer;
  Icon: TIcon;
  SearchRec: TSearchRec;
  ListItem: TListItem;
  FileInfo: SHFILEINFO;
begin
  // Create a temporary TIcon
  Icon := TIcon.Create;
  ListView.Items.BeginUpdate;
  try
    // search for the first file
    i := FindFirst(strPath + '*.*', faAnyFile, SearchRec);
    while i = 0 do begin
      with ListView do begin
        // On directories and volumes
        if ((SearchRec.Attr and FaDirectory <> FaDirectory) and
          (SearchRec.Attr and FaVolumeId <> FaVolumeID)) then begin
          ListItem := ListView.Items.Add;
          //Get The DisplayName
          SHGetFileInfo(PChar(strPath + SearchRec.Name), 0, FileInfo,
            SizeOf(FileInfo), SHGFI_DISPLAYNAME);
          Listitem.Caption := FileInfo.szDisplayName;
          // Get The TypeName
          SHGetFileInfo(PChar(strPath + SearchRec.Name), 0, FileInfo,
            SizeOf(FileInfo), SHGFI_TYPENAME);
          ListItem.SubItems.Add(FileInfo.szTypeName);
          //Get The Icon That Represents The File
          SHGetFileInfo(PChar(strPath + SearchRec.Name), 0, FileInfo,
            SizeOf(FileInfo), SHGFI_ICON or SHGFI_SMALLICON);
          icon.Handle := FileInfo.hIcon;
          ListItem.ImageIndex := ImageList.AddIcon(Icon);
          // Destroy the Icon
          DestroyIcon(FileInfo.hIcon);
        end;
      end;
      i := FindNext(SearchRec);
    end;
  finally
    Icon.Free;
    ListView.Items.EndUpdate;
  end;
end;

procedure CreateBrowserOnForm(aform: TForm; aurl: string);
var
 wb: TWebBrowser;
begin
  wb := TWebBrowser.Create(aform);
  TWinControl(wb).Name := 'mXWebBrowser';
  TWinControl(wb).Parent := aform;
  wb.Align := alClient;
  // TWinControl(wb).Parent := TabSheet1; ( To put it on a TabSheet )
  //wb.Navigate('http://www.swissdelphicenter.ch');
  wb.Navigate(aurl);
end;

procedure SearchAndHighlightWebText(aform: TForm; aurl: string; aText: string);
var
  tr: IHTMLTxtRange; //TextRange Object
 wb: TWebBrowser;
begin
  wb := TWebBrowser.Create(aform);
  TWinControl(wb).Name := 'mXWebBrowser';
  TWinControl(wb).Parent := aform;
  wb.Align := alClient;
  wb.Navigate(aurl);
  if not WB.Busy then begin
    tr := ((WB.Document as IHTMLDocument2).body as IHTMLBodyElement).createTextRange;
    //Get a body with IHTMLDocument2 Interface and then a TextRang obj. with IHTMLBodyElement Intf.

    while tr.findText(aText, 1, 0) do //while we have result
    begin
      tr.pasteHTML('<span style="background-color: Lime; font-weight: bolder;">' +
        tr.htmlText + '</span>');
      //Set the highlight, now background color will be Lime
      tr.scrollIntoView(True);
      //When IE find a match, we ask to scroll the window... you dont need this...
    end;
  end;
end;

function DownloadFile(SourceFile, DestFile: string): Boolean;
begin
  try
    Result := UrlDownloadToFile(nil, PChar(SourceFile), PChar(DestFile), 0,
      nil) = 0;
  except
    Result := False;
  end;
end;

procedure SaveImagesOnWeb(aurl, apath: string);
var
  k, p: Integer;
  Source, dest, ext: string;
   wb: TWebBrowser;
begin
  wb := TWebBrowser.Create(nil);
  wb.Navigate(aurl);
  for k := 0 to WB.OleObject.Document.Images.Length - 1 do begin
    Source := WB.OleObject.Document.Images.Item(k).Src;
    p := LastDelimiter('.', Source);
    ext := UpperCase(Copy(Source, p + 1, Length(Source)));
    if (ext = 'GIF') or (ext = 'JPG') then
    begin
      p  := LastDelimiter('/', Source);
      dest := ExtractFilePath(apath) + Copy(Source, p + 1,
        Length(Source));
      DownloadFile(Source, dest);
    end;
  end;
end;

 const
  RsSystemIdleProcess = 'System Idle Process';
  RsSystemProcess = 'System Process';

function IsWinXP: Boolean;
begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_NT) and
    (Win32MajorVersion = 5) and (Win32MinorVersion = 1);
end;

function IsWin2k: Boolean;
begin
  Result := (Win32MajorVersion >= 5) and
    (Win32Platform = VER_PLATFORM_WIN32_NT);
end;

function IsWinNT4: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_NT;
  Result := Result and (Win32MajorVersion = 4);
end;

function IsWin3X: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_NT;
  Result := Result and (Win32MajorVersion = 3) and
    ((Win32MinorVersion = 1) or (Win32MinorVersion = 5) or
    (Win32MinorVersion = 51));
end;

function RunningProcessesList(const List: TStrings; FullPath: Boolean): Boolean;

  function ProcessFileName(PID: DWORD): string;
  var
    Handle: THandle;
  begin
    Result := '';
    Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
    if Handle <> 0 then
      try
        SetLength(Result, MAX_PATH);
        if FullPath then
        begin
          if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
            SetLength(Result, StrLen(PChar(Result)))
          else
            Result := '';
        end
        else
        begin
          if GetModuleBaseNameA(Handle, 0, PChar(Result), MAX_PATH) > 0 then
            SetLength(Result, StrLen(PChar(Result)))
          else
            Result := '';
        end;
      finally
        CloseHandle(Handle);
      end;
  end;

  function BuildListTH: Boolean;
  var
    SnapProcHandle: THandle;
    ProcEntry: TProcessEntry32;
    NextProc: Boolean;
    FileName: string;
  begin
    SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
    if Result then
      try
        ProcEntry.dwSize := SizeOf(ProcEntry);
        NextProc := Process32First(SnapProcHandle, ProcEntry);
        while NextProc do
        begin
          if ProcEntry.th32ProcessID = 0 then
          begin
            // PID 0 is always the "System Idle Process" but this name cannot be
            // retrieved from the system and has to be fabricated.
            FileName := RsSystemIdleProcess;
          end
          else
          begin
            if IsWin2k or IsWinXP then
            begin
              FileName := ProcessFileName(ProcEntry.th32ProcessID);
              if FileName = '' then
                FileName := ProcEntry.szExeFile;
            end
            else
            begin
              FileName := ProcEntry.szExeFile;
              if not FullPath then
                FileName := ExtractFileName(FileName);
            end;
          end;
          List.AddObject(FileName, Pointer(ProcEntry.th32ProcessID));
          NextProc := Process32Next(SnapProcHandle, ProcEntry);
        end;
      finally
        CloseHandle(SnapProcHandle);
      end;
  end;

  function BuildListPS: Boolean;
  var
    PIDs: array [0..1024] of DWORD;
    Needed: DWORD;
    I: Integer;
    FileName: string;
  begin
    Result := EnumProcesses(@PIDs, SizeOf(PIDs), Needed);
    if Result then
    begin
      for I := 0 to (Needed div SizeOf(DWORD)) - 1 do
      begin
        case PIDs[I] of
          0:
            // PID 0 is always the "System Idle Process" but this name cannot be
            // retrieved from the system and has to be fabricated.
            FileName := RsSystemIdleProcess;
          2:
            // On NT 4 PID 2 is the "System Process" but this name cannot be
            // retrieved from the system and has to be fabricated.
            if IsWinNT4 then
              FileName := RsSystemProcess
            else
              FileName := ProcessFileName(PIDs[I]);
            8:
            // On Win2K PID 8 is the "System Process" but this name cannot be
            // retrieved from the system and has to be fabricated.
            if IsWin2k or IsWinXP then
              FileName := RsSystemProcess
            else
              FileName := ProcessFileName(PIDs[I]);
            else
              FileName := ProcessFileName(PIDs[I]);
        end;
        if FileName <> '' then
          List.AddObject(FileName, Pointer(PIDs[I]));
      end;
    end;
  end;
begin
  if IsWin3X or IsWinNT4 then
    Result := BuildListPS
  else
    Result := BuildListTH;
end;

function GetProcessNameFromWnd(Wnd: HWND): string;
var
  List: TStringList;
  PID: DWORD;
  I: Integer;
begin
  Result := '';
  if IsWindow(Wnd) then
  begin
    PID := INVALID_HANDLE_VALUE;
    GetWindowThreadProcessId(Wnd, @PID);
    List := TStringList.Create;
    try
      if RunningProcessesList(List, True) then
      begin
        I := List.IndexOfObject(Pointer(PID));
        if I > -1 then
          Result := List[I];
      end;
    finally
      List.Free;
    end;
  end;
end;


procedure ModifyFontsFor(ctrl: TWinControl; afontname: string);
  procedure ModifyFont(ctrl: TControl);
  var
    f: TFont;
  begin
    if IsPublishedProp(ctrl, 'Parentfont')
      and (GetOrdProp(ctrl, 'Parentfont') = Ord(false))
      and IsPublishedProp(ctrl, 'font')
      then begin
      f := TFont(GetObjectProp(ctrl, 'font', TFont));
      if afontname = '' then
            f.Name := 'Symbol'
         else f.Name := afontname;
    end;
  end;
var
  i: Integer;
begin
  ModifyFont(ctrl);
  for i := 0 to ctrl.controlcount - 1 do
    if ctrl.controls[i] is Twincontrol then
      ModifyFontsfor(TWincontrol(ctrl.controls[i]),afontname)
    else
      Modifyfont(ctrl.controls[i]);
end;

//https://www.swissdelphicenter.ch/en/showcode.php?id=1235

// ACCESSTIMEOUT structure
type
  TAccessTimeOut = record
    cbSize: UINT;
    dwFlags: DWORD;
    iTimeOutMSec: DWORD;
  end;

procedure GetAccessTimeOut(var bTimeOut: Boolean; var bFeedBack: Boolean;
  var iTimeOutTime: Integer);
  // bTimeOut: the time-out period for accessibility features.
  // bFeedBack: the operating system plays a descending
  //            siren sound when the time-out period elapses and the
  //            Accessibility features are turned off.
  // iTimeOutTime: Timeout in ms
var
  AccessTimeOut: TAccessTimeOut;
begin
  ZeroMemory(@AccessTimeOut, SizeOf(TAccessTimeOut));
  AccessTimeOut.cbSize := SizeOf(TAccessTimeOut);

  SystemParametersInfo(SPI_GETACCESSTIMEOUT, SizeOf(AccessTimeOut), @AccessTimeOut, 0);

  bTimeOut := (AccessTimeOut.dwFlags and ATF_TIMEOUTON) = ATF_TIMEOUTON;
  bFeedBack := (AccessTimeOut.dwFlags and ATF_ONOFFFEEDBACK) = ATF_ONOFFFEEDBACK;
  iTimeOutTime := AccessTimeOut.iTimeOutMSec;
end;

Const
  aBufferSize = 4096;
  
function GetParentProcessName: String;
var
  HandleSnapShot: THandle;
  EntryParentProc: TProcessEntry32;
  CurrentProcessId: THandle;
  HandleParentProc: THandle;
  ParentProcessId: THandle;
  ParentProcessFound: Boolean;
  ParentProcPath: String;
begin
  ParentProcessFound:=False;
  HandleSnapShot:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
  if HandleSnapShot<>INVALID_HANDLE_VALUE then
  begin
    EntryParentProc.dwSize:=SizeOf(EntryParentProc);
    if Process32First(HandleSnapShot,EntryParentProc) then
    begin
      CurrentProcessId:=GetCurrentProcessId();
      repeat
        if EntryParentProc.th32ProcessID=CurrentProcessId then
        begin
          ParentProcessId:=EntryParentProc.th32ParentProcessID;
          HandleParentProc:=OpenProcess(PROCESS_QUERY_INFORMATION or 
                PROCESS_VM_READ,False,ParentProcessId);
          if HandleParentProc<>0 then begin
            ParentProcessFound:=True;
            SetLength(ParentProcPath,aBufferSize);
            GetModuleFileNameEx(HandleParentProc,0,PChar(ParentProcPath),aBufferSize);
            ParentProcPath:=PChar(ParentProcPath);
            CloseHandle(HandleParentProc);
          end;
          Break;
        end;
      until not Process32Next(HandleSnapShot,EntryParentProc);
    end;
    CloseHandle(HandleSnapShot);
  end;
  if ParentProcessFound then Result:= ParentProcPath
  else Result:='';
end;



{function getallEvents(aform: TForm): TStringlist;
var
  x, y, z: Word;
  pl: PPropList;
begin
  y := GetPropList(aform, pl);
  for x := 0 to y - 1 do begin
    if Copy(pl[x].Name, 1, 2) <> 'On' then Continue;
    if GetMethodProp(aform, pl[x].Name).Code <> nil then
      result.Add(aform.Name + ' - ' + pl[x].Name);
  end;
  for z := 0 to aform.ComponentCount - 1 do begin
    y := GetPropList(aform.Components[z], pl);
    for x := 0 to y - 1 do begin
      if Copy(pl[x].Name, 1, 2) <> 'On' then Continue;
      if GetMethodProp(aform.Components[z], pl[x].Name).Code <> nil then
        result.Add(aform.Components[z].Name + ' - ' + pl[x].Name);
    end;
  end;
end;}


     //UrlDownloadToFile

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_AfUtils(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PRaiseFrame', '^TRaiseFrame // will not work');
 // CL.AddTypeS('TRaiseFrame', 'record NextRaise : PRaiseFrame; ExceptAddr : ___Poin'
   //+'ter; ExceptObject : TObject; ExceptionRecord : PExceptionRecord; end');
  CL.AddTypeS('PKOLChar', 'PChar');
  CL.AddTypeS('KOLChar', 'Char');

  //CL.AddTypeS('TThreadFunction','function: Longint; stdcall)');

  CL.AddTypeS('TFNWndEnumProc','function(Handle: THandle; LParam: TStrings): Boolean; stdcall)');

  //    wm_devicechange    WM_DEVICECHANGE = &H219
 CL.AddConstantN('WM_DEVICECHANGE','LongInt').SetInt($219);
 CL.AddConstantN('WM_COPYDATA','LongInt').SetInt($004A);

(* tagCOPYDATASTRUCT = packed record
    dwData: DWORD;
    cbData: DWORD;
    lpData: Pointer;
  end;
  TCopyDataStruct = tagCOPYDATASTRUCT;

 TCopyDataStruct*)
 //WM_COPYDATA     #define WM_COPYDATA                     0x004A

//   CL.AddTypeS('TCopyDataStruct', 'ACCESS_MASK');
 CL.AddTypeS('tagCOPYDATASTRUCT', 'record dwData : DWORD; cbData : DWORD; lpData : TObject; end');

  CL.AddTypeS('TCopyDataStruct', 'tagCOPYDATASTRUCT');
  CL.AddTypeS('COPYDATASTRUCT', 'tagCOPYDATASTRUCT');
  CL.AddTypeS('tagMINMAXINFO', 'record ptReserved : TPoint; ptMaxSize : TPoint;'
   +' ptMaxPosition : TPoint; ptMinTrackSize : TPoint; ptMaxTrackSize : TPoint; end');
  CL.AddTypeS('TMinMaxInfo', 'tagMINMAXINFO');
  CL.AddTypeS('MINMAXINFO', 'tagMINMAXINFO');
   CL.AddTypeS('tagWINDOWPOS', 'record hwnd : HWND; hwndInsertAfter : HWND; x : '
   +'Integer; y : Integer; cx : Integer; cy : Integer; flags : UINT; end');
  CL.AddTypeS('TWindowPos', 'tagWINDOWPOS');
  CL.AddTypeS('WINDOWPOS', 'tagWINDOWPOS');
  CL.AddTypeS('tagNMHDR', 'record hwndFrom : HWND; idFrom : UINT; code : Integer; end');
  CL.AddTypeS('TNMHdr', 'tagNMHDR');
  CL.AddTypeS('NMHDR', 'tagNMHDR');
  CL.AddTypeS('tagWINDOWPLACEMENT', 'record length : UINT; flags : UINT; showCm'
   +'d : UINT; ptMinPosition : TPoint; ptMaxPosition : TPoint; rcNormalPosition: TRect; end');
  CL.AddTypeS('TWindowPlacement', 'tagWINDOWPLACEMENT');
  CL.AddTypeS('WINDOWPLACEMENT', 'tagWINDOWPLACEMENT');

  CL.AddConstantN('UNICODE_NOCHAR','LongWord').SetUInt( $FFFF);

  CL.AddTypeS('ACCESS_MASK', 'DWORD');
  CL.AddTypeS('REGSAM', 'ACCESS_MASK');
  CL.AddConstantN('READ_CONTROL','LongWord').SetUInt( $00020000);
  CL.AddConstantN('KEY_READ','LongWord').SetUInt( $20019);
  //const KEY_READ = $20019;
 CL.AddConstantN('WRITE_DAC','LongWord').SetUInt( $00040000);
 CL.AddConstantN('WRITE_OWNER','LongWord').SetUInt( $00080000);
 CL.AddConstantN('STANDARD_RIGHTS_READ','LongWord').SetUint($00020000);
 CL.AddConstantN('STANDARD_RIGHTS_WRITE','LongWord').SetUint($00020000);
 CL.AddConstantN('STANDARD_RIGHTS_EXECUTE','LongWord').SetUint($00020000);
 CL.AddConstantN('STANDARD_RIGHTS_ALL','LongWord').SetUInt( $001F0000);
 CL.AddConstantN('SPECIFIC_RIGHTS_ALL','LongWord').SetUInt( $0000FFFF);
 CL.AddConstantN('ACCESS_SYSTEM_SECURITY','LongWord').SetUInt( $01000000);
 CL.AddConstantN('MAXIMUM_ALLOWED','LongWord').SetUInt( $02000000);
 CL.AddConstantN('GENERIC_READ','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('GENERIC_WRITE','LongWord').SetUInt( $40000000);
 CL.AddConstantN('GENERIC_EXECUTE','LongWord').SetUInt( $20000000);
 CL.AddConstantN('GENERIC_ALL','LongWord').SetUInt( $10000000);
 //getcurrentmodule

 CL.AddConstantN('WS_EX_DLGMODALFRAME','LongInt').SetInt( 1);
 CL.AddConstantN('WS_EX_NOPARENTNOTIFY','LongInt').SetInt( 4);
 CL.AddConstantN('WS_EX_TOPMOST','LongInt').SetInt( 8);
 CL.AddConstantN('WS_EX_ACCEPTFILES','LongWord').SetUInt( $10);
 CL.AddConstantN('WS_EX_TRANSPARENT','LongWord').SetUInt( $20);
 CL.AddConstantN('WS_EX_MDICHILD','LongWord').SetUInt( $40);
 CL.AddConstantN('WS_EX_TOOLWINDOW','LongWord').SetUInt( $80);
 CL.AddConstantN('WS_EX_WINDOWEDGE','LongWord').SetUInt( $100);
 CL.AddConstantN('WS_EX_CLIENTEDGE','LongWord').SetUInt( $200);
 CL.AddConstantN('WS_EX_CONTEXTHELP','LongWord').SetUInt( $400);
 CL.AddConstantN('WS_EX_RIGHT','LongWord').SetUInt( $1000);
 CL.AddConstantN('WS_EX_LEFT','LongInt').SetInt( 0);
 CL.AddConstantN('WS_EX_RTLREADING','LongWord').SetUInt( $2000);
 CL.AddConstantN('WS_EX_LTRREADING','LongInt').SetInt( 0);
 CL.AddConstantN('WS_EX_LEFTSCROLLBAR','LongWord').SetUInt( $4000);
 CL.AddConstantN('WS_EX_RIGHTSCROLLBAR','LongInt').SetInt( 0);
 CL.AddConstantN('WS_EX_CONTROLPARENT','LongWord').SetUInt( $10000);
 CL.AddConstantN('WS_EX_STATICEDGE','LongWord').SetUInt( $20000);
 CL.AddConstantN('WS_EX_APPWINDOW','LongWord').SetUInt( $40000);
 CL.AddConstantN('WS_EX_LAYERED','LongWord').SetUInt( $00080000);
 CL.AddConstantN('WS_EX_NOINHERITLAYOUT','LongWord').SetUInt( $00100000);
 CL.AddConstantN('WS_EX_LAYOUTRTL','LongWord').SetUInt( $00400000);
 CL.AddConstantN('WS_EX_COMPOSITED','LongWord').SetUInt( $02000000);
 CL.AddConstantN('WS_EX_NOACTIVATE','LongWord').SetUInt( $08000000);
 {CL.AddConstantN('CS_VREDRAW','LongInt').SetInt( DWORD ( 1 ));
 CL.AddConstantN('CS_HREDRAW','LongInt').SetInt( DWORD ( 2 ));
 CL.AddConstantN('CS_KEYCVTWINDOW','LongInt').SetInt( 4);
 CL.AddConstantN('CS_DBLCLKS','LongInt').SetInt( 8);
 CL.AddConstantN('CS_OWNDC','LongWord').SetUInt( $20);
 CL.AddConstantN('CS_CLASSDC','LongWord').SetUInt( $40);
 CL.AddConstantN('CS_PARENTDC','LongWord').SetUInt( $80);
 CL.AddConstantN('CS_NOKEYCVT','LongWord').SetUInt( $100);
 CL.AddConstantN('CS_NOCLOSE','LongWord').SetUInt( $200);
 CL.AddConstantN('CS_SAVEBITS','LongWord').SetUInt( $800);
 CL.AddConstantN('CS_BYTEALIGNCLIENT','LongWord').SetUInt( $1000);
 CL.AddConstantN('CS_BYTEALIGNWINDOW','LongWord').SetUInt( $2000);
 CL.AddConstantN('CS_GLOBALCLASS','LongWord').SetUInt( $4000);
 CL.AddConstantN('CS_IME','LongWord').SetUInt( $10000);
 CL.AddConstantN('CS_DROPSHADOW','LongWord').SetUInt( $20000);}
   CL.AddConstantN('SM_CXSCREEN','LongInt').SetInt( 0);
 CL.AddConstantN('SM_CYSCREEN','LongInt').SetInt( 1);
 CL.AddConstantN('SM_CXVSCROLL','LongInt').SetInt( 2);
 CL.AddConstantN('SM_CYHSCROLL','LongInt').SetInt( 3);
 CL.AddConstantN('SM_CYCAPTION','LongInt').SetInt( 4);
 CL.AddConstantN('SM_CXBORDER','LongInt').SetInt( 5);
 CL.AddConstantN('SM_CYBORDER','LongInt').SetInt( 6);
 CL.AddConstantN('SM_CXDLGFRAME','LongInt').SetInt( 7);
 CL.AddConstantN('SM_CYDLGFRAME','LongInt').SetInt( 8);
 CL.AddConstantN('SM_CYVTHUMB','LongInt').SetInt( 9);
 CL.AddConstantN('SM_CXHTHUMB','LongInt').SetInt( 10);
 CL.AddConstantN('SM_CXICON','LongInt').SetInt( 11);
 CL.AddConstantN('SM_CYICON','LongInt').SetInt( 12);
 CL.AddConstantN('SM_CXCURSOR','LongInt').SetInt( 13);
 CL.AddConstantN('SM_CYCURSOR','LongInt').SetInt( 14);
 CL.AddConstantN('SM_CYMENU','LongInt').SetInt( 15);
 CL.AddConstantN('SM_CXFULLSCREEN','LongWord').SetUInt( $10);
 CL.AddConstantN('SM_CYFULLSCREEN','LongInt').SetInt( 17);
 CL.AddConstantN('SM_CYKANJIWINDOW','LongInt').SetInt( 18);
 CL.AddConstantN('SM_MOUSEPRESENT','LongInt').SetInt( 19);
 CL.AddConstantN('SM_CYVSCROLL','LongInt').SetInt( 20);
 CL.AddConstantN('SM_CXHSCROLL','LongInt').SetInt( 21);
 CL.AddConstantN('SM_DEBUG','LongInt').SetInt( 22);
 CL.AddConstantN('SM_SWAPBUTTON','LongInt').SetInt( 23);
 CL.AddConstantN('SM_RESERVED1','LongInt').SetInt( 24);
 CL.AddConstantN('SM_RESERVED2','LongInt').SetInt( 25);
 CL.AddConstantN('SM_RESERVED3','LongInt').SetInt( 26);
 CL.AddConstantN('SM_RESERVED4','LongInt').SetInt( 27);
 CL.AddConstantN('SM_CXMIN','LongInt').SetInt( 28);
 CL.AddConstantN('SM_CYMIN','LongInt').SetInt( 29);
 CL.AddConstantN('SM_CXSIZE','LongInt').SetInt( 30);
 CL.AddConstantN('SM_CYSIZE','LongInt').SetInt( 31);
 CL.AddConstantN('SM_CXFRAME','LongWord').SetUInt( $20);
 CL.AddConstantN('SM_CYFRAME','LongInt').SetInt( 33);
 CL.AddConstantN('SM_CXMINTRACK','LongInt').SetInt( 34);
 CL.AddConstantN('SM_CYMINTRACK','LongInt').SetInt( 35);
 CL.AddConstantN('SM_CXDOUBLECLK','LongInt').SetInt( 36);
 CL.AddConstantN('SM_CYDOUBLECLK','LongInt').SetInt( 37);
 CL.AddConstantN('SM_CXICONSPACING','LongInt').SetInt( 38);
 CL.AddConstantN('SM_CYICONSPACING','LongInt').SetInt( 39);
 CL.AddConstantN('SM_MENUDROPALIGNMENT','LongInt').SetInt( 40);
 CL.AddConstantN('SM_PENWINDOWS','LongInt').SetInt( 41);
 CL.AddConstantN('SM_DBCSENABLED','LongInt').SetInt( 42);
 CL.AddConstantN('SM_CMOUSEBUTTONS','LongInt').SetInt( 43);
 //CL.AddConstantN('SM_CXFIXEDFRAME','').SetString( SM_CXDLGFRAME);
 //CL.AddConstantN('SM_CYFIXEDFRAME','').SetString( SM_CYDLGFRAME);
 //CL.AddConstantN('SM_CXSIZEFRAME','').SetString( SM_CXFRAME);
 //CL.AddConstantN('SM_CYSIZEFRAME','').SetString( SM_CYFRAME);
 CL.AddConstantN('SM_SECURE','LongInt').SetInt( 44);
 CL.AddConstantN('SM_CXEDGE','LongInt').SetInt( 45);
 CL.AddConstantN('SM_CYEDGE','LongInt').SetInt( 46);
 CL.AddConstantN('SM_CXMINSPACING','LongInt').SetInt( 47);
 CL.AddConstantN('SM_CYMINSPACING','LongInt').SetInt( 48);
 CL.AddConstantN('SM_CXSMICON','LongInt').SetInt( 49);
 CL.AddConstantN('SM_CYSMICON','LongInt').SetInt( 50);
 CL.AddConstantN('SM_CYSMCAPTION','LongInt').SetInt( 51);
 CL.AddConstantN('SM_CXSMSIZE','LongInt').SetInt( 52);
 CL.AddConstantN('SM_CYSMSIZE','LongInt').SetInt( 53);
 CL.AddConstantN('SM_CXMENUSIZE','LongInt').SetInt( 54);
 CL.AddConstantN('SM_CYMENUSIZE','LongInt').SetInt( 55);
 CL.AddConstantN('SM_ARRANGE','LongInt').SetInt( 56);
 CL.AddConstantN('SM_CXMINIMIZED','LongInt').SetInt( 57);
 CL.AddConstantN('SM_CYMINIMIZED','LongInt').SetInt( 58);
 CL.AddConstantN('SM_CXMAXTRACK','LongInt').SetInt( 59);
 CL.AddConstantN('SM_CYMAXTRACK','LongInt').SetInt( 60);
 CL.AddConstantN('SM_CXMAXIMIZED','LongInt').SetInt( 61);
 CL.AddConstantN('SM_CYMAXIMIZED','LongInt').SetInt( 62);
 CL.AddConstantN('SM_NETWORK','LongInt').SetInt( 63);
 CL.AddConstantN('SM_CLEANBOOT','LongInt').SetInt( 67);
 CL.AddConstantN('SM_CXDRAG','LongInt').SetInt( 68);
 CL.AddConstantN('SM_CYDRAG','LongInt').SetInt( 69);
 CL.AddConstantN('SM_SHOWSOUNDS','LongInt').SetInt( 70);
 CL.AddConstantN('SM_CXMENUCHECK','LongInt').SetInt( 71);
 CL.AddConstantN('SM_CYMENUCHECK','LongInt').SetInt( 72);
 CL.AddConstantN('SM_SLOWMACHINE','LongInt').SetInt( 73);
 CL.AddConstantN('SM_MIDEASTENABLED','LongInt').SetInt( 74);
 CL.AddConstantN('SM_MOUSEWHEELPRESENT','LongInt').SetInt( 75);
 CL.AddConstantN('SM_CMETRICS','LongInt').SetInt( 76);
 CL.AddConstantN('SM_REMOTESESSION','LongWord').SetUInt( $1000);
 CL.AddConstantN('SM_XVIRTUALSCREEN','LongInt').SetInt( 76);
 CL.AddConstantN('SM_YVIRTUALSCREEN','LongInt').SetInt( 77);
 CL.AddConstantN('SM_CXVIRTUALSCREEN','LongInt').SetInt( 78);
 CL.AddConstantN('SM_CYVIRTUALSCREEN','LongInt').SetInt( 79);
 CL.AddConstantN('SM_CMONITORS','LongInt').SetInt( 80);
 CL.AddConstantN('SM_SAMEDISPLAYFORMAT','LongInt').SetInt( 81);
 CL.AddConstantN('SM_IMMENABLED','LongInt').SetInt( 82);
 CL.AddConstantN('SM_CXFOCUSBORDER','LongInt').SetInt( 83);
 CL.AddConstantN('SM_CYFOCUSBORDER','LongInt').SetInt( 84);

 CL.AddConstantN('CREATE_SUSPENDED','LongWord').SetUInt( $00000004);
 CL.AddConstantN('DETACHED_PROCESS','LongWord').SetUInt( $00000008);
 CL.AddConstantN('CREATE_NEW_CONSOLE','LongWord').SetUInt( $00000010);
 CL.AddConstantN('NORMAL_PRIORITY_CLASS','LongWord').SetUInt( $00000020);
 CL.AddConstantN('IDLE_PRIORITY_CLASS','LongWord').SetUInt( $00000040);
 CL.AddConstantN('HIGH_PRIORITY_CLASS','LongWord').SetUInt( $00000080);
 CL.AddConstantN('REALTIME_PRIORITY_CLASS','LongWord').SetUInt( $00000100);
  CL.AddDelphiFunction('Function LocalDiscard( h : THandle) : THandle');
 CL.AddDelphiFunction('Function GlobalDiscard( h : THandle) : THandle');
 CL.AddTypeS('tagEVENTMSG', 'record message : UINT; paramL : UINT; paramH : UI'
   +'NT; time : DWORD; hwnd : HWND; end');
  CL.AddTypeS('TEventMsg', 'tagEVENTMSG');
  CL.AddTypeS('EVENTMSG', 'tagEVENTMSG');
  CL.AddDelphiFunction('Function LoadKeyboardLayout( pwszKLID : PChar; Flags : UINT) : HKL');
 CL.AddDelphiFunction('Function ActivateKeyboardLayout( hkl : HKL; Flags : UINT) : HKL');
 CL.AddDelphiFunction('Function UnloadKeyboardLayout( hkl : HKL) : BOOL');
 CL.AddDelphiFunction('Function GetKeyboardLayoutName( pwszKLID : PChar) : BOOL');
 CL.AddDelphiFunction('Function GetKeyboardLayoutList( nBuff : Integer; var List: tstringlist) : UINT');
 CL.AddDelphiFunction('Function GetKeyboardLayout( dwLayout : DWORD) : HKL');
 CL.AddTypeS('tagMOUSEMOVEPOINT', 'record x : Integer; y : Integer; time : DWORD; dwExtraInfo : DWORD; end');
  CL.AddTypeS('TMouseMovePoint', 'tagMOUSEMOVEPOINT');
  CL.AddTypeS('MOUSEMOVEPOINT', 'tagMOUSEMOVEPOINT');
 CL.AddConstantN('GMMP_USE_DISPLAY_POINTS','LongInt').SetInt( 1);
 CL.AddConstantN('GMMP_USE_DRIVER_POINTS','LongInt').SetInt( 2);
 CL.AddDelphiFunction('Function GetMouseMovePoints( cbSize : UINT; var lppt, lpptBuf : TMouseMovePoint; nBufPoints : Integer; resolution : DWORD) : Integer');
  CL.AddDelphiFunction('Function CreateWindowStation( lpwinsta : PChar; dwReserved, dwDesiredAccess : DWORD; lpsa : PSecurityAttributes) : HWINSTA');
CL.AddDelphiFunction('Function OpenWindowStation( lpszWinSta : PChar; fInherit : BOOL; dwDesiredAccess : DWORD) : HWINSTA');
 CL.AddDelphiFunction('Function CloseWindowStation( hWinSta : HWINSTA) : BOOL');
 CL.AddDelphiFunction('Function SetProcessWindowStation( hWinSta : HWINSTA) : BOOL');
 CL.AddDelphiFunction('Function GetProcessWindowStation : HWINSTA');
 CL.AddDelphiFunction('function GetMorseID(InChar : Char): Word;');
 CL.AddDelphiFunction('function GetMorseString2(InChar : Char): string;');
 CL.AddDelphiFunction('function GetMorseLine(dots: boolean): string;');
 CL.AddDelphiFunction('function GetMorseTable(dots: boolean): string;');
 CL.AddDelphiFunction('function GetMorseSign(InChar : Char): string;');

 CL.AddDelphiFunction('function WaitTilClose(hWnd: Integer): Integer;');
 CL.AddDelphiFunction('function DoUserMsgs: Boolean;');
 CL.AddDelphiFunction('function MsgFunc(hWnd,Msg,wParam,lParam:Integer):Integer; stdcall;');
 CL.AddDelphiFunction('procedure ShowMsg(hParent: Integer; const Mess, Title: String);');
 CL.AddDelphiFunction('procedure DeleteMsgForm(Handle: Integer);');
 CL.AddDelphiFunction('procedure DisableForms;');
 CL.AddDelphiFunction('function FoundTopLevel(hWnd, LParam: Integer): BOOL; StdCall;');
 CL.AddDelphiFunction('function CheckCom(AComNumber: Integer): Integer;');
 CL.AddDelphiFunction('function CheckLPT1: string;');
 CL.AddDelphiFunction('procedure GetScreenShot(var ABitmap : TBitmap);');
 CL.AddDelphiFunction('function LoadFile(const FileName: TFileName): string;');
 CL.AddDelphiFunction('function TRestRequest_createStringStreamFromStringList(strings: TStringList): TStringStream;');

 CL.AddDelphiFunction('Function GetRgnBox( RGN : HRGN; var p2 : TRect) : Integer');
 CL.AddDelphiFunction('Function GetStockObject( Index : Integer) : HGDIOBJ');
 CL.AddDelphiFunction('Function GetStretchBltMode( DC : HDC) : Integer');
 CL.AddDelphiFunction('Function GetSystemPaletteUse( DC : HDC) : UINT');
 CL.AddDelphiFunction('Function GetTextCharacterExtra( DC : HDC) : Integer');
 CL.AddDelphiFunction('Function GetTextAlign( DC : HDC) : UINT');
 CL.AddDelphiFunction('Function GetTextColor( DC : HDC) : COLORREF');
 CL.AddDelphiFunction('Function GetObjectType( h : HGDIOBJ) : DWORD');
 CL.AddDelphiFunction('Function GetGraphicsMode( DC : HDC) : Integer');
 CL.AddDelphiFunction('Function GetMapMode( DC : HDC) : Integer');
 CL.AddDelphiFunction('Function GetPixel( DC : HDC; X, Y : Integer) : COLORREF');
 CL.AddDelphiFunction('Function GetPixelFormat( DC : HDC) : Integer');
 CL.AddDelphiFunction('Function GetPolyFillMode( DC : HDC) : Integer');
 CL.AddDelphiFunction('Function GetCurrentObject( DC : HDC; p2 : UINT) : HGDIOBJ');
 CL.AddDelphiFunction('Function GetDeviceCaps( DC : HDC; Index : Integer) : Integer');
 CL.AddDelphiFunction('function ComponentToStringProc(Component: TComponent): string;');
 CL.AddDelphiFunction('function StringToComponentProc(Value: string): TComponent;');
 CL.AddDelphiFunction('procedure MyCopyFile(Name1,Name2:string);');
 CL.AddDelphiFunction('function ComPortSelect: Integer;');
 CL.AddDelphiFunction('function LinesCount(sfilename:string):Double;');
 CL.AddDelphiFunction('function TextFileLineCount(const FileName: string): integer;');
 CL.AddDelphiFunction('function GetLinesCount(sFileName : String): Integer;');
 CL.AddDelphiFunction('procedure Formanimation(Sender: TObject; adelay: integer);');


 CL.AddTypeS('TFNTimerProc', 'TObject');
 CL.AddConstantN('GW_HWNDFIRST','LongInt').SetInt( 0);
 CL.AddConstantN('GW_HWNDLAST','LongInt').SetInt( 1);
 CL.AddConstantN('GW_HWNDNEXT','LongInt').SetInt( 2);
 CL.AddConstantN('GW_HWNDPREV','LongInt').SetInt( 3);
 CL.AddConstantN('GW_OWNER','LongInt').SetInt( 4);
 CL.AddConstantN('GW_CHILD','LongInt').SetInt( 5);
 CL.AddConstantN('GW_MAX','LongInt').SetInt( 5);

   //    ACCESS_MASK = DWORD;
  //    REGSAM = ACCESS_MASK;  { Requested Key access mask type. }

 CL.AddConstantN('EMR_SETWINDOWEXTEX','LongInt').SetInt( 9);
 CL.AddConstantN('EMR_SETWINDOWORGEX','LongInt').SetInt( 10);
 CL.AddConstantN('EMR_SETVIEWPORTEXTEX','LongInt').SetInt( 11);
 CL.AddConstantN('EMR_SETVIEWPORTORGEX','LongInt').SetInt( 12);
 CL.AddConstantN('EMR_SETBRUSHORGEX','LongInt').SetInt( 13);

 CL.AddConstantN('FILE_TYPE_UNKNOWN','LongInt').SetInt( 0);
 CL.AddConstantN('FILE_TYPE_DISK','LongInt').SetInt( 1);
 CL.AddConstantN('FILE_TYPE_CHAR','LongInt').SetInt( 2);
 CL.AddConstantN('FILE_TYPE_PIPE','LongInt').SetInt( 3);
 CL.AddConstantN('FILE_TYPE_REMOTE','LongWord').SetUInt( $8000);
 CL.AddConstantN('STD_INPUT_HANDLE','LongInt').SetInt( DWORD ( - 10 ));
 CL.AddConstantN('STD_OUTPUT_HANDLE','LongInt').SetInt( DWORD ( - 11 ));
 CL.AddConstantN('STD_ERROR_HANDLE','LongInt').SetInt( DWORD ( - 12 ));
CL.AddConstantN('NOPARITY','LongInt').SetInt( 0);
 CL.AddConstantN('ODDPARITY','LongInt').SetInt( 1);
 CL.AddConstantN('EVENPARITY','LongInt').SetInt( 2);
 CL.AddConstantN('MARKPARITY','LongInt').SetInt( 3);
 CL.AddConstantN('SPACEPARITY','LongInt').SetInt( 4);
 CL.AddConstantN('ONESTOPBIT','LongInt').SetInt( 0);
 CL.AddConstantN('ONE5STOPBITS','LongInt').SetInt( 1);
 CL.AddConstantN('TWOSTOPBITS','LongInt').SetInt( 2);
 CL.AddConstantN('IGNORE','LongInt').SetInt( 0);
 //CL.AddConstantN('INFINITE','LongWord').SetUInt( DWORD ( $FFFFFFFF ));

 CL.AddConstantN('HWND_BROADCAST','LongWord').SetUInt( $FFFF);
 CL.AddConstantN('wnd_Broadcast','longword').SetInt(HWND_BROADCAST);
 CL.AddConstantN('HWND_MESSAGE','LongInt').SetInt( HWND ( - 3 ));
 CL.AddConstantN('DEVICE_NOTIFY_WINDOW_HANDLE','LongInt').SetInt( 0);

 CL.AddDelphiFunction('Function SetSystemCursor( hcur : HICON; id : DWORD) : BOOL');
  CL.AddTypeS('_ICONINFO', 'record fIcon : BOOL; xHotspot : DWORD; yHotspot : DWORD; hbmMask : HBITMAP; hbmColor : HBITMAP; end');
  CL.AddTypeS('TIconInfo', '_ICONINFO');
  CL.AddTypeS('ICONINFO', '_ICONINFO');
 CL.AddDelphiFunction('Function LoadIcon( hInstance : HINST; lpIconName : PChar) : HICON');
 CL.AddDelphiFunction('Function DestroyIcon( hIcon : HICON) : BOOL');
  CL.AddTypeS('tagCURSORSHAPE', 'record xHotSpot : Integer; yHotSpot : Integer;'
   +' cx : Integer; cy : Integer; cbWidth : Integer; Planes : Byte; BitsPixel : Byte; end');
  CL.AddTypeS('TCursorShape', 'tagCURSORSHAPE');
  CL.AddTypeS('CURSORSHAPE', 'tagCURSORSHAPE');

 CL.AddDelphiFunction('Function WNetConnectionDialog( hwnd : HWND; dwType : DWORD) : DWORD');
 CL.AddDelphiFunction('Function WNetDisconnectDialog( hwnd : HWND; dwType : DWORD) : DWORD');
 CL.AddDelphiFunction('Function WNetGetProviderName( dwNetType : DWORD; lpProviderName : PChar; var lpBufferSize : DWORD) : DWORD');
  CL.AddDelphiFunction('Function WNetGetUser( lpName : PChar; lpUserName : PChar; var lpnLength : DWORD) : DWORD');

  //CL.AddTypeS('PConnectDlgStruct', '^TConnectDlgStruct // will not work');
  CL.AddTypeS('_CONNECTDLGSTRUCTA', 'record cbStructure : DWORD; hwndOwner : HW'
   +'ND; lpConnRes : TObject; dwFlags : DWORD; dwDevNum : DWORD; end');
  CL.AddTypeS('TConnectDlgStruct', '_CONNECTDLGSTRUCTA');
  CL.AddTypeS('CONNECTDLGSTRUCT', '_CONNECTDLGSTRUCTA');
    CL.AddTypeS('_UNIVERSAL_NAME_INFOA', 'record lpUniversalName : PChar; end');
  CL.AddTypeS('_UNIVERSAL_NAME_INFO', '_UNIVERSAL_NAME_INFOA');
  CL.AddTypeS('TUniversalNameInfoA', '_UNIVERSAL_NAME_INFOA');
  CL.AddTypeS('TUniversalNameInfo', 'TUniversalNameInfoA');
  CL.AddTypeS('UNIVERSAL_NAME_INFOA', '_UNIVERSAL_NAME_INFOA');
  CL.AddTypeS('UNIVERSAL_NAME_INFO', 'UNIVERSAL_NAME_INFOA');
CL.AddTypeS('_REMOTE_NAME_INFOA', 'record lpUniversalName : PChar; lpConn'
   +'ectionName : PChar; lpRemainingPath : PChar; end');
  CL.AddTypeS('_REMOTE_NAME_INFO', '_REMOTE_NAME_INFOA');
  CL.AddTypeS('TRemoteNameInfoA', '_REMOTE_NAME_INFOA');
  CL.AddTypeS('TRemoteNameInfo', 'TRemoteNameInfoA');
  CL.AddTypeS('REMOTE_NAME_INFOA', '_REMOTE_NAME_INFOA');
  CL.AddTypeS('REMOTE_NAME_INFO', 'REMOTE_NAME_INFOA');
    CL.AddTypeS('_NETINFOSTRUCT', 'record cbStructure : DWORD; dwProviderVersion '
   +': DWORD; dwStatus : DWORD; dwCharacteristics : DWORD; dwHandle : DWORD; wN'
   +'etType : Word; dwPrinters : DWORD; dwDrives : DWORD; end');
  CL.AddTypeS('TNetInfoStruct', '_NETINFOSTRUCT');
  CL.AddTypeS('NETINFOSTRUCT', '_NETINFOSTRUCT');
 CL.AddConstantN('NETINFO_DLL16','LongInt').SetInt( 1);
 CL.AddConstantN('NETINFO_DISKRED','LongInt').SetInt( 4);
 CL.AddConstantN('NETINFO_PRINTERRED','LongInt').SetInt( 8);
 CL.AddDelphiFunction('Function WNetGetNetworkInformation( lpProvider : PChar; var lpNetInfoStruct : TNetInfoStruct) : DWORD');
 CL.AddDelphiFunction('Function WNetCancelConnection( lpName : PChar; fForce : BOOL) : DWORD');
 CL.AddDelphiFunction('Function WNetCancelConnection2( lpName : PChar; dwFlags : DWORD; fForce : BOOL) : DWORD');
 CL.AddDelphiFunction('Function WNetGetUniversalName( lpLocalPath : PChar; dwInfoLevel : DWORD; lpBuffer : string; var lpBufferSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function WNetGetLastError( var lpError : DWORD; lpErrorBuf : PChar; nErrorBufSize : DWORD; lpNameBuf : PChar; nNameBufSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function WNetCloseEnum( hEnum : THandle) : DWORD');

   CL.AddTypeS('_DISCDLGSTRUCTA', 'record cbStructure : DWORD; hwndOwner : HWND;'
   +' lpLocalName : PChar; lpRemoteName : PChar; dwFlags : DWORD; end');
  CL.AddTypeS('_DISCDLGSTRUCT', '_DISCDLGSTRUCTA');
   CL.AddTypeS('TDiscDlgStructA', '_DISCDLGSTRUCTA');
   CL.AddTypeS('TDiscDlgStruct', 'TDiscDlgStructA');
    CL.AddTypeS('DISCDLGSTRUCTA', '_DISCDLGSTRUCTA');
   CL.AddTypeS('DISCDLGSTRUCT', 'DISCDLGSTRUCTA');
 CL.AddConstantN('DISC_UPDATE_PROFILE','LongInt').SetInt( 1);
 CL.AddConstantN('DISC_NO_FORCE','LongWord').SetUInt( $40);
  CL.AddTypeS('_COORD', 'record X : SHORT; Y : SHORT; end');
  CL.AddTypeS('TCoord', '_COORD');
  CL.AddTypeS('COORD', '_COORD');
  //CL.AddTypeS('PSmallRect', '^TSmallRect // will not work');
  CL.AddTypeS('_SMALL_RECT', 'record Left : SHORT; Top : SHORT; Right : SHORT; Bottom : SHORT; end');
  CL.AddTypeS('TSmallRect', '_SMALL_RECT');
  CL.AddTypeS('SMALL_RECT', '_SMALL_RECT');
  //CL.AddTypeS('PKeyEventRecord', '^TKeyEventRecord // will not work');
  CL.AddTypeS('_KEY_EVENT_RECORD', 'record bKeyDown : BOOL; wRepeatCount : Word'
   +'; wVirtualKeyCode : Word; wVirtualScanCode : Word; end');
  CL.AddTypeS('TKeyEventRecord', '_KEY_EVENT_RECORD');
  CL.AddTypeS('KEY_EVENT_RECORD', '_KEY_EVENT_RECORD');
 CL.AddConstantN('RIGHT_ALT_PRESSED','LongInt').SetInt( 1);
 CL.AddConstantN('LEFT_ALT_PRESSED','LongInt').SetInt( 2);
 CL.AddConstantN('RIGHT_CTRL_PRESSED','LongInt').SetInt( 4);
 CL.AddConstantN('LEFT_CTRL_PRESSED','LongInt').SetInt( 8);
 CL.AddConstantN('SHIFT_PRESSED','LongWord').SetUInt( $10);
 CL.AddConstantN('NUMLOCK_ON','LongWord').SetUInt( $20);
 CL.AddConstantN('SCROLLLOCK_ON','LongWord').SetUInt( $40);
 CL.AddConstantN('CAPSLOCK_ON','LongWord').SetUInt( $80);
 CL.AddConstantN('ENHANCED_KEY','LongWord').SetUInt( $100);

  CL.AddTypeS('_MOUSE_EVENT_RECORD', 'record dwMousePosition : TCoord; dwButton'
   +'State : DWORD; dwControlKeyState : DWORD; dwEventFlags : DWORD; end');
  CL.AddTypeS('TMouseEventRecord', '_MOUSE_EVENT_RECORD');
  CL.AddTypeS('MOUSE_EVENT_RECORD', '_MOUSE_EVENT_RECORD');
 CL.AddConstantN('FROM_LEFT_1ST_BUTTON_PRESSED','LongInt').SetInt( 1);
 CL.AddConstantN('RIGHTMOST_BUTTON_PRESSED','LongInt').SetInt( 2);
 CL.AddConstantN('FROM_LEFT_2ND_BUTTON_PRESSED','LongInt').SetInt( 4);
 CL.AddConstantN('FROM_LEFT_3RD_BUTTON_PRESSED','LongInt').SetInt( 8);
 CL.AddConstantN('FROM_LEFT_4TH_BUTTON_PRESSED','LongWord').SetUInt( $10);
 CL.AddConstantN('MOUSE_MOVED','LongInt').SetInt( 1);
 CL.AddConstantN('DOUBLE_CLICK','LongInt').SetInt( 2);
   CL.AddTypeS('_INPUT_RECORD', 'record EventType : Word; Reserved : Word; end');
  CL.AddTypeS('TInputRecord', '_INPUT_RECORD');
  CL.AddTypeS('INPUT_RECORD', '_INPUT_RECORD');
  CL.AddConstantN('KEY_EVENT','LongInt').SetInt( 1);
 CL.AddConstantN('_MOUSE_EVENT','LongInt').SetInt( 2);
 CL.AddConstantN('WINDOW_BUFFER_SIZE_EVENT','LongInt').SetInt( 4);
 CL.AddConstantN('MENU_EVENT','LongInt').SetInt( 8);
 CL.AddConstantN('FOCUS_EVENT','LongWord').SetUInt( $10);
  CL.AddTypeS('_WINDOW_BUFFER_SIZE_RECORD', 'record dwSize : TCoord; end');
  CL.AddTypeS('TWindowBufferSizeRecord', '_WINDOW_BUFFER_SIZE_RECORD');
  CL.AddTypeS('WINDOW_BUFFER_SIZE_RECORD', '_WINDOW_BUFFER_SIZE_RECORD');
  //CL.AddTypeS('PMenuEventRecord', '^TMenuEventRecord // will not work');
  CL.AddTypeS('_MENU_EVENT_RECORD', 'record dwCommandId : UINT; end');
  CL.AddTypeS('TMenuEventRecord', '_MENU_EVENT_RECORD');
  CL.AddTypeS('MENU_EVENT_RECORD', '_MENU_EVENT_RECORD');
  //CL.AddTypeS('PFocusEventRecord', '^TFocusEventRecord // will not work');
  CL.AddTypeS('_FOCUS_EVENT_RECORD', 'record bSetFocus : BOOL; end');
  CL.AddTypeS('TFocusEventRecord', '_FOCUS_EVENT_RECORD');
  CL.AddTypeS('FOCUS_EVENT_RECORD', '_FOCUS_EVENT_RECORD');
  CL.AddTypeS('TmrProc', 'procedure TmrProc(hWnd: HWND; uMsg: Integer; idEvent: Integer; dwTime: Integer);');
  //procedure TmrProc(hWnd: HWND; uMsg: Integer; idEvent: Integer; dwTime: Integer); stdcall;
  
  CL.AddTypeS('_CONSOLE_SCREEN_BUFFER_INFO', 'record dwSize : TCoord; dwCursorP'
   +'osition : TCoord; wAttributes : Word; srWindow : TSmallRect; dwMaximumWindowSize : TCoord; end');
  CL.AddTypeS('TConsoleScreenBufferInfo', '_CONSOLE_SCREEN_BUFFER_INFO');
  CL.AddTypeS('CONSOLE_SCREEN_BUFFER_INFO', '_CONSOLE_SCREEN_BUFFER_INFO');
//  CL.AddTypeS('PConsoleCursorInfo', '^TConsoleCursorInfo // will not work');
  CL.AddTypeS('_CONSOLE_CURSOR_INFO', 'record dwSize : DWORD; bVisible : BOOL; end');
  CL.AddTypeS('TConsoleCursorInfo', '_CONSOLE_CURSOR_INFO');
  CL.AddTypeS('CONSOLE_CURSOR_INFO', '_CONSOLE_CURSOR_INFO');
//  CL.AddTypeS('TFNHandlerRoutine', 'TFarProc');
 CL.AddConstantN('CTRL_C_EVENT','LongInt').SetInt( 0);
 CL.AddConstantN('CTRL_BREAK_EVENT','LongInt').SetInt( 1);
 CL.AddConstantN('CTRL_CLOSE_EVENT','LongInt').SetInt( 2);
 CL.AddConstantN('CTRL_LOGOFF_EVENT','LongInt').SetInt( 5);
 CL.AddConstantN('CTRL_SHUTDOWN_EVENT','LongInt').SetInt( 6);
 CL.AddConstantN('ENABLE_PROCESSED_INPUT','LongInt').SetInt( 1);
 CL.AddConstantN('ENABLE_LINE_INPUT','LongInt').SetInt( 2);
 CL.AddConstantN('ENABLE_ECHO_INPUT','LongInt').SetInt( 4);
 CL.AddConstantN('ENABLE_WINDOW_INPUT','LongInt').SetInt( 8);
 CL.AddConstantN('ENABLE_MOUSE_INPUT','LongWord').SetUInt( $10);
 CL.AddConstantN('ENABLE_PROCESSED_OUTPUT','LongInt').SetInt( 1);
 CL.AddConstantN('ENABLE_WRAP_AT_EOL_OUTPUT','LongInt').SetInt( 2);

  CL.AddTypeS('tagCOMBOBOXINFO', 'record cbSize : DWORD; rcItem : TRect; rcButt'
   +'on : TRect; stateButton : DWORD; hwndCombo : HWND; hwndItem : HWND; hwndList : HWND; end');
  CL.AddTypeS('TComboBoxInfo', 'tagCOMBOBOXINFO');
 CL.AddDelphiFunction('Function GetComboBoxInfo( hwndCombo : HWND; var pcbi : TComboBoxInfo) : BOOL');
 CL.AddConstantN('GA_MIC','LongInt').SetInt( 1);
 CL.AddConstantN('GA_PARENT','LongInt').SetInt( 1);
 CL.AddConstantN('GA_ROOT','LongInt').SetInt( 2);
 CL.AddConstantN('GA_ROOTOWNER','LongInt').SetInt( 3);
 CL.AddConstantN('GA_MAC','LongInt').SetInt( 4);
 CL.AddDelphiFunction('Function GetAncestor( hwnd : HWND; gaFlags : UINT) : HWND');
 CL.AddDelphiFunction('Function RealChildWindowFromPoint( hwndParent : HWND; ptParentClientCoords : TPoint) : HWND');
 CL.AddDelphiFunction('Function RealGetWindowClass( hwnd : HWND; pszType : PChar; cchType : UINT) : UINT');

 CL.AddDelphiFunction('Procedure SetLastErrorEx( dwErrCode, dwType : DWORD)');
 CL.AddDelphiFunction('Procedure NotifyWinEvent( event : DWORD; hwnd : HWND; idObject, idChild : Cardinal)');
 CL.AddConstantN('CHILDID_SELF','LongInt').SetInt( 0);
 CL.AddConstantN('INDEXID_OBJECT','LongInt').SetInt( 0);
 CL.AddConstantN('INDEXID_CONTAINER','LongInt').SetInt( 0);
 CL.AddConstantN('OBJID_WINDOW','LongWord').SetUInt( $00000000);
 CL.AddConstantN('OBJID_SYSMENU','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('OBJID_TITLEBAR','LongWord').SetUInt( $FFFFFFFE);
 CL.AddConstantN('OBJID_MENU','LongWord').SetUInt( $FFFFFFFD);
 CL.AddConstantN('OBJID_CLIENT','LongWord').SetUInt( $FFFFFFFC);
 CL.AddConstantN('OBJID_VSCROLL','LongWord').SetUInt( $FFFFFFFB);
 CL.AddConstantN('OBJID_HSCROLL','LongWord').SetUInt( $FFFFFFFA);
 CL.AddConstantN('OBJID_SIZEGRIP','LongWord').SetUInt( $FFFFFFF9);
 CL.AddConstantN('OBJID_CARET','LongWord').SetUInt( $FFFFFFF8);
 CL.AddConstantN('OBJID_CURSOR','LongWord').SetUInt( $FFFFFFF7);
 CL.AddConstantN('OBJID_ALERT','LongWord').SetUInt( $FFFFFFF6);
 CL.AddConstantN('OBJID_SOUND','LongWord').SetUInt( $FFFFFFF5);
 CL.AddConstantN('EVENT_MIN','LongWord').SetUInt( $00000001);
 CL.AddConstantN('EVENT_MAX','LongWord').SetUInt( $7FFFFFFF);
 CL.AddConstantN('EVENT_SYSTEM_SOUND','LongWord').SetUInt( $0001);
 CL.AddConstantN('EVENT_SYSTEM_ALERT','LongWord').SetUInt( $0002);
 CL.AddConstantN('EVENT_SYSTEM_FOREGROUND','LongWord').SetUInt( $0003);
 CL.AddConstantN('EVENT_SYSTEM_MENUSTART','LongWord').SetUInt( $0004);
 CL.AddConstantN('EVENT_SYSTEM_MENUEND','LongWord').SetUInt( $0005);
 CL.AddConstantN('EVENT_SYSTEM_MENUPOPUPSTART','LongWord').SetUInt( $0006);
 CL.AddConstantN('EVENT_SYSTEM_MENUPOPUPEND','LongWord').SetUInt( $0007);
 CL.AddConstantN('EVENT_SYSTEM_CAPTURESTART','LongWord').SetUInt( $0008);
 CL.AddConstantN('EVENT_SYSTEM_CAPTUREEND','LongWord').SetUInt( $0009);
 CL.AddConstantN('EVENT_SYSTEM_MOVESIZESTART','LongWord').SetUInt( $000A);
 CL.AddConstantN('EVENT_SYSTEM_MOVESIZEEND','LongWord').SetUInt( $000B);
 CL.AddConstantN('EVENT_SYSTEM_CONTEXTHELPSTART','LongWord').SetUInt( $000C);
 CL.AddConstantN('EVENT_SYSTEM_CONTEXTHELPEND','LongWord').SetUInt( $000D);
 CL.AddConstantN('EVENT_SYSTEM_DRAGDROPSTART','LongWord').SetUInt( $000E);
 CL.AddConstantN('EVENT_SYSTEM_DRAGDROPEND','LongWord').SetUInt( $000F);
 CL.AddConstantN('EVENT_SYSTEM_DIALOGSTART','LongWord').SetUInt( $0010);
 CL.AddConstantN('EVENT_SYSTEM_DIALOGEND','LongWord').SetUInt( $0011);
 CL.AddConstantN('EVENT_SYSTEM_SCROLLINGSTART','LongWord').SetUInt( $0012);
 CL.AddConstantN('EVENT_SYSTEM_SCROLLINGEND','LongWord').SetUInt( $0013);
 CL.AddConstantN('EVENT_SYSTEM_SWITCHSTART','LongWord').SetUInt( $0014);
 CL.AddConstantN('EVENT_SYSTEM_SWITCHEND','LongWord').SetUInt( $0015);
 CL.AddConstantN('EVENT_SYSTEM_MINIMIZESTART','LongWord').SetUInt( $0016);
 CL.AddConstantN('EVENT_SYSTEM_MINIMIZEEND','LongWord').SetUInt( $0017);
 CL.AddConstantN('EVENT_OBJECT_CREATE','LongWord').SetUInt( $8000);
 CL.AddConstantN('EVENT_OBJECT_DESTROY','LongWord').SetUInt( $8001);
 CL.AddConstantN('EVENT_OBJECT_SHOW','LongWord').SetUInt( $8002);
 CL.AddConstantN('EVENT_OBJECT_HIDE','LongWord').SetUInt( $8003);
 CL.AddConstantN('EVENT_OBJECT_REORDER','LongWord').SetUInt( $8004);
 CL.AddConstantN('EVENT_OBJECT_FOCUS','LongWord').SetUInt( $8005);
 CL.AddConstantN('EVENT_OBJECT_SELECTION','LongWord').SetUInt( $8006);
 CL.AddConstantN('EVENT_OBJECT_SELECTIONADD','LongWord').SetUInt( $8007);
 CL.AddConstantN('EVENT_OBJECT_SELECTIONREMOVE','LongWord').SetUInt( $8008);
 CL.AddConstantN('EVENT_OBJECT_SELECTIONWITHIN','LongWord').SetUInt( $8009);
 CL.AddConstantN('EVENT_OBJECT_STATECHANGE','LongWord').SetUInt( $800A);
 CL.AddConstantN('EVENT_OBJECT_LOCATIONCHANGE','LongWord').SetUInt( $800B);
 CL.AddConstantN('EVENT_OBJECT_NAMECHANGE','LongWord').SetUInt( $800C);
 CL.AddConstantN('EVENT_OBJECT_DESCRIPTIONCHANGE','LongWord').SetUInt( $800D);
 CL.AddConstantN('EVENT_OBJECT_VALUECHANGE','LongWord').SetUInt( $800E);
 CL.AddConstantN('EVENT_OBJECT_PARENTCHANGE','LongWord').SetUInt( $800F);
 CL.AddConstantN('EVENT_OBJECT_HELPCHANGE','LongWord').SetUInt( $8010);
 CL.AddConstantN('EVENT_OBJECT_DEFACTIONCHANGE','LongWord').SetUInt( $8011);
 CL.AddConstantN('EVENT_OBJECT_ACCELERATORCHANGE','LongWord').SetUInt( $8012);
 CL.AddConstantN('SOUND_SYSTEM_STARTUP','LongInt').SetInt( 1);
 CL.AddConstantN('SOUND_SYSTEM_SHUTDOWN','LongInt').SetInt( 2);
 CL.AddConstantN('SOUND_SYSTEM_BEEP','LongInt').SetInt( 3);
 CL.AddConstantN('SOUND_SYSTEM_ERROR','LongInt').SetInt( 4);
 CL.AddConstantN('SOUND_SYSTEM_QUESTION','LongInt').SetInt( 5);
 CL.AddConstantN('SOUND_SYSTEM_WARNING','LongInt').SetInt( 6);
 CL.AddConstantN('SOUND_SYSTEM_INFORMATION','LongInt').SetInt( 7);
 CL.AddConstantN('SOUND_SYSTEM_MAXIMIZE','LongInt').SetInt( 8);
 CL.AddConstantN('SOUND_SYSTEM_MINIMIZE','LongInt').SetInt( 9);
 CL.AddConstantN('SOUND_SYSTEM_RESTOREUP','LongInt').SetInt( 10);
 CL.AddConstantN('SOUND_SYSTEM_RESTOREDOWN','LongInt').SetInt( 11);
 CL.AddConstantN('SOUND_SYSTEM_APPSTART','LongInt').SetInt( 12);
 CL.AddConstantN('SOUND_SYSTEM_FAULT','LongInt').SetInt( 13);
 CL.AddConstantN('SOUND_SYSTEM_APPEND','LongInt').SetInt( 14);
 CL.AddConstantN('SOUND_SYSTEM_MENUCOMMAND','LongInt').SetInt( 15);
 CL.AddConstantN('SOUND_SYSTEM_MENUPOPUP','LongInt').SetInt( 16);
 CL.AddConstantN('CSOUND_SYSTEM','LongInt').SetInt( 16);
 CL.AddConstantN('ALERT_SYSTEM_INFORMATIONAL','LongInt').SetInt( 1);
 CL.AddConstantN('ALERT_SYSTEM_WARNING','LongInt').SetInt( 2);
 CL.AddConstantN('ALERT_SYSTEM_ERROR','LongInt').SetInt( 3);
 CL.AddConstantN('ALERT_SYSTEM_QUERY','LongInt').SetInt( 4);
 CL.AddConstantN('ALERT_SYSTEM_CRITICAL','LongInt').SetInt( 5);
 CL.AddConstantN('CALERT_SYSTEM','LongInt').SetInt( 6);
 //CL.AddDelphiFunction('Function SetWinEventHook( eventMin, eventMax : DWORD; hmodWinEventProc : HMODULE; pfnWinEventProc : TFNWinEventProc; idProcess, idThread, dwFlags : DWORD) : THandle');
 CL.AddDelphiFunction('Function UnhookWinEvent( hWinEventHook : THandle) : BOOL');
 CL.AddConstantN('WINEVENT_OUTOFCONTEXT','LongWord').SetUInt( $0000);
 CL.AddConstantN('WINEVENT_SKIPOWNTHREAD','LongWord').SetUInt( $0001);
 CL.AddConstantN('WINEVENT_SKIPOWNPROCESS','LongWord').SetUInt( $0002);
 CL.AddConstantN('WINEVENT_INCONTEXT','LongWord').SetUInt( $0004);
 // CL.AddTypeS('PGUIThreadInfo', '^TGUIThreadInfo // will not work');
  CL.AddTypeS('tagGUITHREADINFO', 'record cbSize : DWORD; flags : DWORD; hwndAc'
   +'tive : HWND; hwndFocus : HWND; hwndCapture : HWND; hwndMenuOwner : HWND; h'
   +'wndMoveSize : HWND; hwndCaret : HWND; rcCaret : TRect; end');
 CL.AddTypeS('TGUIThreadInfo', 'tagGUITHREADINFO');
 CL.AddConstantN('GUI_CARETBLINKING','LongWord').SetUInt( $00000001);
 CL.AddConstantN('GUI_INMOVESIZE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('GUI_INMENUMODE','LongWord').SetUInt( $00000004);
 CL.AddConstantN('GUI_SYSTEMMENUMODE','LongWord').SetUInt( $00000008);
 CL.AddConstantN('GUI_POPUPMENUMODE','LongWord').SetUInt( $00000010);
 CL.AddDelphiFunction('Function GetGUIThreadInfo( idThread : DWORD; var pgui : TGUIThreadinfo) : BOOL');
 CL.AddDelphiFunction('Function GetWindowModuleFileName( hwnd : HWND; pszFileName : PChar; cchFileNameMax : UINT) : UINT');
 //CL.AddDelphiFunction('Function GetWindowModuleFileNameA( hwnd : HWND; pszFileName : PAnsiChar; cchFileNameMax : UINT) : UINT');
 //CL.AddDelphiFunction('Function GetWindowModuleFileNameW( hwnd : HWND; pszFileName : PWideChar; cchFileNameMax : UINT) : UINT');

 CL.AddDelphiFunction('Procedure SafeCloseHandle( var Handle : THandle)');
 CL.AddDelphiFunction('Procedure ExchangeInteger( X1, X2 : Integer)');
 CL.AddDelphiFunction('Procedure FillInteger( const Buffer: string; Size, Value : Integer)');
 CL.AddDelphiFunction('Function LongMulDiv( Mult1, Mult2, Div1 : Longint) : Longint');
 CL.AddDelphiFunction('Function afCompareMem( P1, P2 : TObject; Length : Integer) : Boolean');
 CL.AddDelphiFunction('Function AbortSystemShutdown( lpMachineName : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function RegisterWindowMessage( lpString : PChar) : UINT');
 //CL.AddDelphiFunction('Function DrawEdge( hdc : HDC; var qrc : TRect; edge : UINT; grfFlags : UINT) : BOOL');
  //CL.AddDelphiFunction('Function DrawFrameControl( DC : HDC; const Rect : TRect; uType, uState : UINT) : BOOL');
 CL.AddDelphiFunction('Function PostThreadMessage( idThread : DWORD; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : BOOL');
  CL.AddDelphiFunction('Function PostAppMessage( idThread : DWORD; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : BOOL');
 CL.AddDelphiFunction('Function AttachThreadInput( idAttach, idAttachTo : DWORD; fAttach : BOOL) : BOOL');
 CL.AddDelphiFunction('Function ReplyMessage( lResult : LRESULT) : BOOL');

 CL.AddDelphiFunction('Function SetTimer( hWnd : HWND; nIDEvent, uElapse : UINT; lpTimerFunc : TFNTimerProc) : UINT');
 CL.AddDelphiFunction('Function SetTimer2( hWnd : HWND; nIDEvent, uElapse : UINT; lpTimerFunc : TmrProc) : UINT');

 CL.AddDelphiFunction('Function KillTimer( hWnd : HWND; uIDEvent : UINT) : BOOL');
 CL.AddDelphiFunction('Function wIsWindowUnicode( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function wEnableWindow( hWnd : HWND; bEnable : BOOL) : BOOL');
 CL.AddDelphiFunction('Function wIsWindowEnabled( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function GetMenu( hWnd : HWND) : HMENU');
 CL.AddDelphiFunction('Function SetMenu( hWnd : HWND; hMenu : HMENU) : BOOL');
 CL.AddDelphiFunction('Function CloseWindowStation( hWinSta : HWINSTA) : BOOL');
 CL.AddDelphiFunction('Function SetProcessWindowStation( hWinSta : HWINSTA) : BOOL');
 CL.AddDelphiFunction('Function GetProcessWindowStation : HWINSTA');
 CL.AddDelphiFunction('Function EnumWindows(lpEnumFunc : TFNWndEnumProc; lParam : LPARAM) : BOOL');
 CL.AddDelphiFunction('function EnumWindowsProc2(Handle: THandle; LParam: TStrings): Boolean; stdcall;');

 //CL.AddDelphiFunction('Function AccessCheckAndAuditAlarm( SubsystemName : PKOLChar; HandleId : ___Pointer; ObjectTypeName, ObjectName : PKOLChar; SecurityDescriptor : PSecurityDescriptor; DesiredAccess : DWORD; const GenericMapping : TGenericMapping; ObjectCreation : BOOL;'
 //+' var GrantedAccess : DWORD; var AccessStatus, pfGenerateOnClose : BOOL) : BOOL');
 CL.AddDelphiFunction('Function BackupEventLog( hEventLog : THandle; lpBackupFileName : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function ClearEventLog( hEventLog : THandle; lpBackupFileName : PKOLChar) : BOOL');
// CL.AddDelphiFunction('Function CreateProcessAsUser(hToken : THandle; lpApplicationName : PKOLChar; lpCommandLine : PKOLChar; lpProcessAttributes : PSecurityAttributes; lpThreadAttributes : PSecurityAttributes;'
  //                       +'bInheritHandles : BOOL; dwCreationFlags : DWORD; lpEnvironment : ___Pointer; lpCurrentDirectory : PKOLChar; const lpStartupInfo : TStartupInfo; var lpProcessInformation : integer): BOOL');
// CL.AddDelphiFunction('Function CreateProcessAsUser2(bInheritHandles : BOOL; dwCreationFlags : DWORD; lpEnvironment : ___Pointer; lpCurrentDirectory : PKOLChar; const lpStartupInfo : TStartupInfo; var lpProcessInformation : integer): BOOL');
 //CL.AddDelphiFunction('Function GetCurrentHwProfile( var lpHwProfileInfo : THWProfileInfo) : BOOL');
 //CL.AddDelphiFunction('Function GetFileSecurity( lpFileName : PKOLChar; RequestedInformation : SECURITY_INFORMATION; pSecurityDescriptor : PSecurityDescriptor; nLength : DWORD; var lpnLengthNeeded : DWORD) : BOOL'); TStartupInfo    TProcessInformation
 CL.AddDelphiFunction('Function avGetUserName( lpBuffer : PKOLChar; var nSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function InitiateSystemShutdown( lpMachineName, lpMessage : PKOLChar; dwTimeout : DWORD; bForceAppsClosed, bRebootAfterShutdown : BOOL) : BOOL');
 CL.AddDelphiFunction('Function LogonUser( lpszUsername, lpszDomain, lpszPassword : PKOLChar; dwLogonType, dwLogonProvider : DWORD; var phToken : THandle) : BOOL');
// CL.AddDelphiFunction('Function LookupAccountName( lpSystemName, lpAccountName : PKOLChar; Sid : PSID; var cbSid : DWORD; ReferencedDomainName : PKOLChar; var cbReferencedDomainName : DWORD; var peUse : SID_NAME_USE) : BOOL');
 //CL.AddDelphiFunction('Function LookupAccountSid( lpSystemName : PKOLChar; Sid : PSID; Name : PKOLChar; var cbName : DWORD; ReferencedDomainName : PKOLChar; var cbReferencedDomainName : DWORD; var peUse : SID_NAME_USE) : BOOL');
 CL.AddDelphiFunction('Function LookupPrivilegeDisplayName( lpSystemName, lpName : PKOLChar; lpDisplayName : PKOLChar; var cbDisplayName, lpLanguageId : DWORD) : BOOL');
 CL.AddDelphiFunction('Function LookupPrivilegeName( lpSystemName : PKOLChar; var lpLuid : TLargeInteger; lpName : PKOLChar; var cbName : DWORD) : BOOL');
 CL.AddDelphiFunction('Function LookupPrivilegeValue( lpSystemName, lpName : PKOLChar; var lpLuid : TLargeInteger) : BOOL');
 //CL.AddDelphiFunction('Function ObjectCloseAuditAlarm( SubsystemName : PKOLChar; HandleId : Pointer; GenerateOnClose : BOOL) : BOOL');
// CL.AddDelphiFunction('Function ObjectDeleteAuditAlarm( SubsystemName : PKOLChar; HandleId : Pointer; GenerateOnClose : BOOL) : BOOL');
// CL.AddDelphiFunction('Function ObjectOpenAuditAlarm( SubsystemName : PKOLChar; HandleId : Pointer; ObjectTypeName : PKOLChar; ObjectName : PKOLChar; pSecurityDescriptor : PSecurityDescriptor; ClientToken : THandle; DesiredAccess, GrantedAccess : DWORD; var Privileges : TPrivilegeSet; ObjectCreation, AccessGranted : BOOL; var GenerateOnClose : BOOL) : BOOL');
 //CL.AddDelphiFunction('Function ObjectPrivilegeAuditAlarm( SubsystemName : PKOLChar; HandleId : Pointer; ClientToken : THandle; DesiredAccess : DWORD; var Privileges : TPrivilegeSet; AccessGranted : BOOL) : BOOL');
 CL.AddDelphiFunction('Function OpenBackupEventLog( lpUNCServerName, lpFileName : PKOLChar) : THandle');
 CL.AddDelphiFunction('Function OpenEventLog( lpUNCServerName, lpSourceName : PKOLChar) : THandle');
// CL.AddDelphiFunction('Function PrivilegedServiceAuditAlarm( SubsystemName, ServiceName : PKOLChar; ClientToken : THandle; var Privileges : TPrivilegeSet; AccessGranted : BOOL) : BOOL');
// CL.AddDelphiFunction('Function ReadEventLog( hEventLog : THandle; dwReadFlags, dwRecordOffset : DWORD; lpBuffer : Pointer; nNumberOfBytesToRead : DWORD; var pnBytesRead, pnMinNumberOfBytesNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function RegConnectRegistry( lpMachineName : PKOLChar; hKey : HKEY; var phkResult : HKEY) : Longint');
 CL.AddDelphiFunction('Function RegCreateKey( hKey : HKEY; lpSubKey : PKOLChar; var phkResult : HKEY) : Longint');
 //CL.AddDelphiFunction('Function RegCreateKeyEx( hKey : HKEY; lpSubKey : PKOLChar; Reserved : DWORD; lpClass : PKOLChar; dwOptions : DWORD; samDesired : REGSAM; lpSecurityAttributes : PSecurityAttributes; var phkResult : HKEY; lpdwDisposition : PDWORD) : Longint');
 CL.AddDelphiFunction('Function RegDeleteKey( hKey : HKEY; lpSubKey : PKOLChar) : Longint');
 CL.AddDelphiFunction('Function RegDeleteValue( hKey : HKEY; lpValueName : PKOLChar) : Longint');
// CL.AddDelphiFunction('Function RegEnumKeyEx( hKey : HKEY; dwIndex : DWORD; lpName : PKOLChar; var lpcbName : DWORD; lpReserved : Pointer; lpClass : PKOLChar; lpcbClass : PDWORD; lpftLastWriteTime : PFileTime) : Longint');
 CL.AddDelphiFunction('Function RegEnumKey( hKey : HKEY; dwIndex : DWORD; lpName : PKOLChar; cbName : DWORD) : Longint');
// CL.AddDelphiFunction('Function RegEnumValue( hKey : HKEY; dwIndex : DWORD; lpValueName : PKOLChar; var lpcbValueName : DWORD; lpReserved : Pointer; lpType : PDWORD; lpData : PByte; lpcbData : PDWORD) : Longint');
 CL.AddDelphiFunction('Function RegLoadKey( hKey : HKEY; lpSubKey, lpFile : PKOLChar) : Longint');
 CL.AddDelphiFunction('Function RegOpenKey( hKey : HKEY; lpSubKey : PKOLChar; var phkResult : HKEY) : Longint');
 CL.AddDelphiFunction('Function RegCloseKey( hKey : HKEY): longint');

 CL.AddDelphiFunction('Function RegOpenKeyEx( hKey : HKEY; lpSubKey : PKOLChar; ulOptions : DWORD; samDesired : REGSAM; var phkResult : HKEY) : Longint');
 //CL.AddDelphiFunction('Function RegQueryInfoKey( hKey : HKEY; lpClass : PKOLChar; lpcbClass : PDWORD; lpReserved : Pointer; lpcSubKeys, lpcbMaxSubKeyLen, lpcbMaxClassLen, lpcValues, lpcbMaxValueNameLen, lpcbMaxValueLen, lpcbSecurityDescriptor : PDWORD; lpftLastWriteTime : PFileTime) : Longint');
 CL.AddDelphiFunction('Function RegQueryMultipleValues( hKey : HKEY; var ValList, NumVals : DWORD; lpValueBuf : PKOLChar; var ldwTotsize : DWORD) : Longint');
 CL.AddDelphiFunction('Function RegQueryValue( hKey : HKEY; lpSubKey : PKOLChar; lpValue : PKOLChar; var lpcbValue : Longint) : Longint');
// CL.AddDelphiFunction('Function RegQueryValueEx( hKey : HKEY; lpValueName : PKOLChar; lpReserved : Pointer; lpType : PDWORD; lpData : PByte; lpcbData : PDWORD) : Longint');
 CL.AddDelphiFunction('Function RegReplaceKey( hKey : HKEY; lpSubKey : PKOLChar; lpNewFile : PKOLChar; lpOldFile : PKOLChar) : Longint');
 CL.AddDelphiFunction('Function RegRestoreKey( hKey : HKEY; lpFile : PKOLChar; dwFlags : DWORD) : Longint');
 CL.AddDelphiFunction('Function RegSaveKey( hKey : HKEY; lpFile : PKOLChar; lpSecurityAttributes : PSecurityAttributes) : Longint');
 CL.AddDelphiFunction('Function RegSetValue( hKey : HKEY; lpSubKey : PKOLChar; dwType : DWORD; lpData : PKOLChar; cbData : DWORD) : Longint');
// CL.AddDelphiFunction('Function RegSetValueEx( hKey : HKEY; lpValueName : PKOLChar; Reserved : DWORD; dwType : DWORD; lpData : Pointer; cbData : DWORD) : Longint');
 CL.AddDelphiFunction('Function RegUnLoadKey( hKey : HKEY; lpSubKey : PKOLChar) : Longint');
 CL.AddDelphiFunction('Function RegisterEventSource( lpUNCServerName, lpSourceName : PKOLChar) : THandle');
// CL.AddDelphiFunction('Function ReportEvent( hEventLog : THandle; wType, wCategory : Word; dwEventID : DWORD; lpUserSid : Pointer; wNumStrings : Word; dwDataSize : DWORD; lpStrings, lpRawData : Pointer) : BOOL');
 //CL.AddDelphiFunction('Function SetFileSecurity( lpFileName : PKOLChar; SecurityInformation : SECURITY_INFORMATION; pSecurityDescriptor : PSecurityDescriptor) : BOOL');

 //from unit uPSI_wiwin32;

 CL.AddConstantN('SID_REVISION','LongInt').SetInt( 1);
 CL.AddConstantN('FILENAME_ADVAPI32','String').SetString( 'ADVAPI32.DLL');
 CL.AddConstantN('PROC_CONVERTSIDTOSTRINGSIDA','String').SetString( 'ConvertSidToStringSidA');
 CL.AddDelphiFunction('Function GetDomainUserSidS( const domainName : String; const userName : String; var foundDomain : String) : String');
 CL.AddDelphiFunction('Function GetLocalUserSidStr( const UserName : string) : string');
 CL.AddDelphiFunction('Function getPid4user( const domain : string; const user : string; var pid : dword) : boolean');
 CL.AddDelphiFunction('Function Impersonate2User( const domain : string; const user : string) : boolean');
 CL.AddDelphiFunction('Function GetProcessUserBypid( pid : DWORD; var UserName, Domain : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function KillProcessbyname( const exename : string; var found : integer) : integer');
 CL.AddDelphiFunction('Function getWinProcessList : TStringList');
 //CL.AddDelphiFunction('Procedure myimpersontest');
 CL.AddDelphiFunction('Function SetViewportExtEx( DC : HDC; XExt, YExt : Integer; Size : PChar) : BOOL');
 CL.AddDelphiFunction('Function SetViewportOrgEx( DC : HDC; X, Y : Integer; Point : PChar) : BOOL');

  CL.AddDelphiFunction('Function wAddAtom( lpString : PKOLChar) : ATOM');
 CL.AddDelphiFunction('Function wBeginUpdateResource( pFileName : PKOLChar; bDeleteExistingResources : BOOL) : THandle');
 //CL.AddDelphiFunction('Function wCallNamedPipe( lpNamedPipeName : PKOLChar; lpInBuffer : Pointer; nInBufferSize : DWORD; lpOutBuffer : Pointer; nOutBufferSize : DWORD; var lpBytesRead : DWORD; nTimeOut : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wCommConfigDialog( lpszName : PKOLChar; hWnd : HWND; var lpCC : TCommConfig) : BOOL');
 CL.AddDelphiFunction('Function wCompareString( Locale : LCID; dwCmpFlags : DWORD; lpString1 : PKOLChar; cchCount1 : Integer; lpString2 : PKOLChar; cchCount2 : Integer) : Integer');
 CL.AddDelphiFunction('Function wCopyFile( lpExistingFileName, lpNewFileName : PKOLChar; bFailIfExists : BOOL) : BOOL');
 //CL.AddDelphiFunction('Function wCopyFileEx( lpExistingFileName, lpNewFileName : PKOLChar; lpProgressRoutine : TFNProgressRoutine; lpData : Pointer; pbCancel : PBool; dwCopyFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wCreateDirectory( lpPathName : PKOLChar; lpSecurityAttributes : PSecurityAttributes) : BOOL');
 CL.AddDelphiFunction('Function wCreateDirectoryEx( lpTemplateDirectory, lpNewDirectory : PKOLChar; lpSecurityAttributes : PSecurityAttributes) : BOOL');
 CL.AddDelphiFunction('Function wCreateEvent( lpEventAttributes : PSecurityAttributes; bManualReset, bInitialState : BOOL; lpName : PKOLChar) : THandle');
 CL.AddDelphiFunction('Function wCreateFile( lpFileName : PKOLChar; dwDesiredAccess, dwShareMode : DWORD; lpSecurityAttributes : PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes : DWORD; hTemplateFile : THandle) : THandle');
 CL.AddDelphiFunction('Function CreateFile( lpFileName : PChar; dwDesiredAccess, dwShareMode : DWORD; lpSecurityAttributes : PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes : DWORD; hTemplateFile : THandle) : THandle');
 CL.AddDelphiFunction('function wFillRect(hDC: HDC; const lprc: TRect; hbr: HBRUSH): Integer;');
 CL.AddDelphiFunction('function wFrameRect(hDC: HDC; const lprc: TRect; hbr: HBRUSH): Integer;');

 CL.AddDelphiFunction('Function GetStdHandle( nStdHandle : DWORD) : THandle');
 CL.AddDelphiFunction('Function SetStdHandle1( nStdHandle : DWORD; hHandle : THandle) : BOOL');
 CL.AddDelphiFunction('Function WriteFile( hFile : THandle; const Buffer, nNumberOfBytesToWrite : DWORD; var lpNumberOfBytesWritten : DWORD; lpOverlapped : DWord) : BOOL');
 CL.AddDelphiFunction('Function ReadFile( hFile : THandle; var Buffer, nNumberOfBytesToRead : DWORD; var lpNumberOfBytesRead : DWORD; lpOverlapped : DWord) : BOOL');
 CL.AddDelphiFunction('Function FlushFileBuffers( hFile : THandle) : BOOL');
 CL.AddDelphiFunction('Function SetEndOfFile( hFile : THandle) : BOOL');

 CL.AddDelphiFunction('Function wCreateFileMapping( hFile : THandle; lpFileMappingAttributes : PSecurityAttributes; flProtect, dwMaximumSizeHigh, dwMaximumSizeLow : DWORD; lpName : PKOLChar) : THandle');
 CL.AddDelphiFunction('Function wCreateHardLink( lpFileName, lpExistingFileName : PKOLChar; lpSecurityAttributes : PSecurityAttributes) : BOOL');
 CL.AddDelphiFunction('Function wCreateMailslot( lpName : PKOLChar; nMaxMessageSize : DWORD; lReadTimeout : DWORD; lpSecurityAttributes : PSecurityAttributes) : THandle');
 CL.AddDelphiFunction('Function wCreateNamedPipe( lpName : PKOLChar; dwOpenMode, dwPipeMode, nMaxInstances, nOutBufferSize, nInBufferSize, nDefaultTimeOut : DWORD; lpSecurityAttributes : PSecurityAttributes) : THandle');
 //CL.AddDelphiFunction('Function CreateProcess( lpApplicationName : PKOLChar; lpCommandLine : PKOLChar; lpProcessAttributes, lpThreadAttributes : PSecurityAttributes; bInheritHandles : BOOL; dwCreationFlags : DWORD; lpEnvironment : Pointer; lpCurrentDirectory : PKOLChar; const lpStartupInfo : TStartupInfo; var lpProcessInformation : TProcessInformation) : BOOL');
 CL.AddDelphiFunction('Function wCreateSemaphore( lpSemaphoreAttributes : PSecurityAttributes; lInitialCount, lMaximumCount : Longint; lpName : PKOLChar) : THandle');
 CL.AddDelphiFunction('Function wCreateWaitableTimer( lpTimerAttributes : PSecurityAttributes; bManualReset : BOOL; lpTimerName : PKOLChar) : THandle');
 CL.AddDelphiFunction('Function wDefineDosDevice( dwFlags : DWORD; lpDeviceName, lpTargetPath : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wDeleteFile( lpFileName : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wEndUpdateResource( hUpdate : THandle; fDiscard : BOOL) : BOOL');
 //CL.AddDelphiFunction('Function wEnumCalendarInfo( lpCalInfoEnumProc : TFNCalInfoEnumProc; Locale : LCID; Calendar : CALID; CalType : CALTYPE) : BOOL');
 //CL.AddDelphiFunction('Function wEnumDateFormats( lpDateFmtEnumProc : TFNDateFmtEnumProc; Locale : LCID; dwFlags : DWORD) : BOOL');
// CL.AddDelphiFunction('Function wEnumResourceLanguages( hModule : HMODULE; lpType, lpName : PKOLChar; lpEnumFunc : ENUMRESLANGPROC; lParam : Longint) : BOOL');
 //CL.AddDelphiFunction('Function wEnumResourceNames( hModule : HMODULE; lpType : PKOLChar; lpEnumFunc : ENUMRESNAMEPROC; lParam : Longint) : BOOL');
 //CL.AddDelphiFunction('Function wEnumResourceTypes( hModule : HMODULE; lpEnumFunc : ENUMRESTYPEPROC; lParam : Longint) : BOOL');
 //CL.AddDelphiFunction('Function wEnumSystemCodePages( lpCodePageEnumProc : TFNCodepageEnumProc; dwFlags : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wEnumSystemLocales( lpLocaleEnumProc : TFNLocaleEnumProc; dwFlags : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wEnumTimeFormats( lpTimeFmtEnumProc : TFNTimeFmtEnumProc; Locale : LCID; dwFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wExpandEnvironmentStrings( lpSrc : PKOLChar; lpDst : PKOLChar; nSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Procedure wFatalAppExit( uAction : UINT; lpMessageText : PKOLChar)');
 //CL.AddDelphiFunction('Function wFillConsoleOutputCharacter( hConsoleOutput : THandle; cCharacter : KOLChar; nLength : DWORD; dwWriteCoord : TCoord; var lpNumberOfCharsWritten : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wFindAtom( lpString : PKOLChar) : ATOM');
 CL.AddDelphiFunction('Function wFindFirstChangeNotification( lpPathName : PKOLChar; bWatchSubtree : BOOL; dwNotifyFilter : DWORD) : THandle');
 CL.AddDelphiFunction('Function wFindFirstFile( lpFileName : PKOLChar; var lpFindFileData : TWIN32FindData) : THandle');
 //CL.AddDelphiFunction('Function wFindFirstFileEx( lpFileName : PKOLChar; fInfoLevelId : TFindexInfoLevels; lpFindFileData : Pointer; fSearchOp : TFindexSearchOps; lpSearchFilter : Pointer; dwAdditionalFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wFindNextFile( hFindFile : THandle; var lpFindFileData : TWIN32FindData) : BOOL');
 CL.AddDelphiFunction('Function wFindResource( hModule : HMODULE; lpName, lpType : PKOLChar) : HRSRC');
 CL.AddDelphiFunction('Function wFindResourceEx( hModule : HMODULE; lpType, lpName : PKOLChar; wLanguage : Word) : HRSRC');
 CL.AddDelphiFunction('Function wFoldString( dwMapFlags : DWORD; lpSrcStr : PKOLChar; cchSrc : Integer; lpDestStr : PKOLChar; cchDest : Integer) : Integer');
 //CL.AddDelphiFunction('Function wFormatMessage( dwFlags : DWORD; lpSource : Pointer; dwMessageId : DWORD; dwLanguageId : DWORD; lpBuffer : PKOLChar; nSize : DWORD; Arguments : Pointer) : DWORD');
 CL.AddDelphiFunction('Function wFreeEnvironmentStrings( EnvBlock : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wGetAtomName( nAtom : ATOM; lpBuffer : PKOLChar; nSize : Integer) : UINT');
 CL.AddDelphiFunction('Function wGetBinaryType( lpApplicationName : PKOLChar; var lpBinaryType : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wGetCommandLine : PKOLChar');
 //CL.AddDelphiFunction('Function wGetCompressedFileSize( lpFileName : PKOLChar; lpFileSizeHigh : PDWORD) : DWORD');
 CL.AddDelphiFunction('Function wGetComputerName( lpBuffer : PKOLChar; var nSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wGetConsoleTitle( lpConsoleTitle : PKOLChar; nSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GetConsoleTitle( lpConsoleTitle : PChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function wGetCurrencyFormat( Locale : LCID; dwFlags : DWORD; lpValue : PKOLChar; lpFormat : PCurrencyFmt; lpCurrencyStr : PKOLChar; cchCurrency : Integer) : Integer');
 CL.AddDelphiFunction('Function wGetCurrentDirectory( nBufferLength : DWORD; lpBuffer : PKOLChar) : DWORD');
 //CL.AddDelphiFunction('Function wGetDateFormat( Locale : LCID; dwFlags : DWORD; lpDate : PSystemTime; lpFormat : PKOLChar; lpDateStr : PKOLChar; cchDate : Integer) : Integer');
 //CL.AddDelphiFunction('Function wGetDefaultCommConfig( lpszName : PKOLChar; var lpCC : TCommConfig; var lpdwSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wGetDiskFreeSpace( lpRootPathName : PKOLChar; var lpSectorsPerCluster, lpBytesPerSector, lpNumberOfFreeClusters, lpTotalNumberOfClusters : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wGetDiskFreeSpaceEx( lpDirectoryName : PKOLChar; var lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes : PLargeInteger) : BOOL');
 CL.AddDelphiFunction('Function wGetDriveType( lpRootPathName : PKOLChar) : UINT');
 CL.AddDelphiFunction('Function wGetEnvironmentStrings : PKOLChar');
 CL.AddDelphiFunction('Function wGetEnvironmentVariable( lpName : PKOLChar; lpBuffer : PKOLChar; nSize : DWORD) : DWORD;');
 CL.AddDelphiFunction('Function wGetFileAttributes( lpFileName : PKOLChar) : DWORD');
 //CL.AddDelphiFunction('Function wGetFileAttributesEx( lpFileName : PKOLChar; fInfoLevelId : TGetFileExInfoLevels; lpFileInformation : Pointer) : BOOL');
 CL.AddDelphiFunction('Function wGetFullPathName( lpFileName : PKOLChar; nBufferLength : DWORD; lpBuffer : PKOLChar; var lpFilePart : PKOLChar) : DWORD');
 //CL.AddDelphiFunction('Function wGetLocaleInfo( Locale : LCID; LCType : LCTYPE; lpLCData : PKOLChar; cchData : Integer) : Integer');
 CL.AddDelphiFunction('Function wGetLogicalDriveStrings( nBufferLength : DWORD; lpBuffer : PKOLChar) : DWORD');
 CL.AddDelphiFunction('Function wGetModuleFileName( hModule : HINST; lpFilename : PKOLChar; nSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wGetModuleHandle( lpModuleName : PKOLChar) : HMODULE');
 //CL.AddDelphiFunction('Function wGetNamedPipeHandleState( hNamedPipe : THandle; lpState, lpCurInstances, lpMaxCollectionCount, lpCollectDataTimeout : PDWORD; lpUserName : PKOLChar; nMaxUserNameSize : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wGetNumberFormat( Locale : LCID; dwFlags : DWORD; lpValue : PKOLChar; lpFormat : PNumberFmt; lpNumberStr : PKOLChar; cchNumber : Integer) : Integer');
 CL.AddDelphiFunction('Function wGetPrivateProfileInt( lpAppName, lpKeyName : PKOLChar; nDefault : Integer; lpFileName : PKOLChar) : UINT');
 CL.AddDelphiFunction('Function wGetPrivateProfileSection( lpAppName : PKOLChar; lpReturnedString : PKOLChar; nSize : DWORD; lpFileName : PKOLChar) : DWORD');
 CL.AddDelphiFunction('Function wGetPrivateProfileSectionNames( lpszReturnBuffer : PKOLChar; nSize : DWORD; lpFileName : PKOLChar) : DWORD');
 CL.AddDelphiFunction('Function wGetPrivateProfileString( lpAppName, lpKeyName, lpDefault : PKOLChar; lpReturnedString : PKOLChar; nSize : DWORD; lpFileName : PKOLChar) : DWORD');
 CL.AddDelphiFunction('Function wGetProfileInt( lpAppName, lpKeyName : PKOLChar; nDefault : Integer) : UINT');
 CL.AddDelphiFunction('Function wGetProfileSection( lpAppName : PKOLChar; lpReturnedString : PKOLChar; nSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wGetProfileString( lpAppName, lpKeyName, lpDefault : PKOLChar; lpReturnedString : PKOLChar; nSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wGetShortPathName( lpszLongPath : PKOLChar; lpszShortPath : PKOLChar; cchBuffer : DWORD) : DWORD');
 //CL.AddDelphiFunction('Procedure wGetStartupInfo( var lpStartupInfo : TStartupInfo)');
// CL.AddDelphiFunction('Function wGetStringTypeEx( Locale : LCID; dwInfoType : DWORD; lpSrcStr : PKOLChar; cchSrc : Integer; var lpCharType) : BOOL');
 CL.AddDelphiFunction('Function wGetSystemDirectory( lpBuffer : PKOLChar; uSize : UINT) : UINT');
 CL.AddDelphiFunction('Function wGetTempFileName( lpPathName, lpPrefixString : PKOLChar; uUnique : UINT; lpTempFileName : PKOLChar) : UINT');
 CL.AddDelphiFunction('Function wGetTempPath( nBufferLength : DWORD; lpBuffer : PKOLChar) : DWORD');
 //CL.AddDelphiFunction('Function wGetTimeFormat( Locale : LCID; dwFlags : DWORD; lpTime : PSystemTime; lpFormat : PKOLChar; lpTimeStr : PKOLChar; cchTime : Integer) : Integer');
 //CL.AddDelphiFunction('Function wGetVersionEx( var lpVersionInformation : TOSVersionInfo) : BOOL');
 //CL.AddDelphiFunction('Function GetVolumeInformation( lpRootPathName : PKOLChar; lpVolumeNameBuffer : PKOLChar; nVolumeNameSize : DWORD; lpVolumeSerialNumber : PDWORD; var lpMaximumComponentLength, lpFileSystemFlags : DWORD; lpFileSystemNameBuffer : PKOLChar; nFileSystemNameSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wGetWindowsDirectory( lpBuffer : PKOLChar; uSize : UINT) : UINT');
 CL.AddDelphiFunction('Function wGlobalAddAtom( lpString : PKOLChar) : ATOM');
 CL.AddDelphiFunction('Function wGlobalFindAtom( lpString : PKOLChar) : ATOM');
 CL.AddDelphiFunction('Function wGlobalGetAtomName( nAtom : ATOM; lpBuffer : PKOLChar; nSize : Integer) : UINT');
 CL.AddDelphiFunction('Function wIsBadStringPtr( lpsz : PKOLChar; ucchMax : UINT) : BOOL');
 CL.AddDelphiFunction('Function wLCMapString( Locale : LCID; dwMapFlags : DWORD; lpSrcStr : PKOLChar; cchSrc : Integer; lpDestStr : PKOLChar; cchDest : Integer) : Integer');
 CL.AddDelphiFunction('Function wLoadLibrary( lpLibFileName : PKOLChar) : HMODULE');
 CL.AddDelphiFunction('Function wLoadLibraryEx( lpLibFileName : PKOLChar; hFile : THandle; dwFlags : DWORD) : HMODULE');
 CL.AddDelphiFunction('Function wMoveFile( lpExistingFileName, lpNewFileName : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wMoveFileEx( lpExistingFileName, lpNewFileName : PKOLChar; dwFlags : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wMoveFileWithProgress( lpExistingFileName, lpNewFileName : PKOLChar; lpProgressRoutine : TFNProgressRoutine; lpData : Pointer; dwFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wOpenEvent( dwDesiredAccess : DWORD; bInheritHandle : BOOL; lpName : PKOLChar) : THandle');
 CL.AddDelphiFunction('Function wOpenFileMapping( dwDesiredAccess : DWORD; bInheritHandle : BOOL; lpName : PKOLChar) : THandle');
 CL.AddDelphiFunction('Function wOpenMutex( dwDesiredAccess : DWORD; bInheritHandle : BOOL; lpName : PKOLChar) : THandle');
 CL.AddDelphiFunction('Function wOpenSemaphore( dwDesiredAccess : DWORD; bInheritHandle : BOOL; lpName : PKOLChar) : THandle');
 CL.AddDelphiFunction('Function wOpenWaitableTimer( dwDesiredAccess : DWORD; bInheritHandle : BOOL; lpTimerName : PKOLChar) : THandle');
 CL.AddDelphiFunction('Procedure wOutputDebugString( lpOutputString : PKOLChar)');
 //CL.AddDelphiFunction('Function wPeekConsoleInput( hConsoleInput : THandle; var lpBuffer : TInputRecord; nLength : DWORD; var lpNumberOfEventsRead : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wQueryDosDevice( lpDeviceName : PKOLChar; lpTargetPath : PKOLChar; ucchMax : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function wQueryRecoveryAgents( p1 : PKOLChar; var p2 : Pointer; var p3 : TRecoveryAgentInformation) : DWORD');
 //CL.AddDelphiFunction('Function wReadConsole( hConsoleInput : THandle; lpBuffer : Pointer; nNumberOfCharsToRead : DWORD; var lpNumberOfCharsRead : DWORD; lpReserved : Pointer) : BOOL');
 //CL.AddDelphiFunction('Function wReadConsoleInput( hConsoleInput : THandle; var lpBuffer : TInputRecord; nLength : DWORD; var lpNumberOfEventsRead : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wReadConsoleOutput( hConsoleOutput : THandle; lpBuffer : Pointer; dwBufferSize, dwBufferCoord : TCoord; var lpReadRegion : TSmallRect) : BOOL');
 //CL.AddDelphiFunction('Function wReadConsoleOutputCharacter( hConsoleOutput : THandle; lpCharacter : PKOLChar; nLength : DWORD; dwReadCoord : TCoord; var lpNumberOfCharsRead : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wRemoveDirectory( lpPathName : PKOLChar) : BOOL');
 //CL.AddDelphiFunction('Function wScrollConsoleScreenBuffer( hConsoleOutput : THandle; const lpScrollRectangle : TSmallRect; lpClipRectangle : PSmallRect; dwDestinationOrigin : TCoord; var lpFill : TCharInfo) : BOOL');
 CL.AddDelphiFunction('Function wSearchPath( lpPath, lpFileName, lpExtension : PKOLChar; nBufferLength : DWORD; lpBuffer : PKOLChar; var lpFilePart : PKOLChar) : DWORD');
 CL.AddDelphiFunction('Function wSetComputerName( lpComputerName : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wSetConsoleTitle( lpConsoleTitle : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function SetConsoleTitle( lpConsoleTitle : PChar) : BOOL');
 //CL.AddDelphiFunction('Function GetConsoleTitle( lpConsoleTitle : PChar) : BOOL');
 CL.AddDelphiFunction('Function GetConsoleMode( stdinConsole: THandle; cmode: Dword) : BOOL');
 CL.AddDelphiFunction('Function SetConsoleMode( stdinConsole: THandle; cmode: Dword) : BOOL');
   // Win32Check(GetConsoleMode(StdIn, ConsoleMode));
 // Win32Check(SetConsoleMode(StdIn, ConsoleMode and (not ENABLE_ECHO_INPUT)));

 CL.AddDelphiFunction('Function wSetCurrentDirectory( lpPathName : PKOLChar) : BOOL');
 //CL.AddDelphiFunction('Function wSetDefaultCommConfig( lpszName : PKOLChar; lpCC : PCommConfig; dwSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wSetEnvironmentVariable( lpName, lpValue : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wSetFileAttributes( lpFileName : PKOLChar; dwFileAttributes : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wSetLocaleInfo( Locale : LCID; LCType : LCTYPE; lpLCData : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wSetVolumeLabel( lpRootPathName : PKOLChar; lpVolumeName : PKOLChar) : BOOL');
 //CL.AddDelphiFunction('Function wUpdateResource( hUpdate : THandle; lpType, lpName : PKOLChar; wLanguage : Word; lpData : Pointer; cbData : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wVerLanguageName( wLang : DWORD; szLang : PKOLChar; nSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wWaitNamedPipe( lpNamedPipeName : PKOLChar; nTimeOut : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wWriteConsole( hConsoleOutput : THandle; const lpBuffer : Pointer; nNumberOfCharsToWrite : DWORD; var lpNumberOfCharsWritten : DWORD; lpReserved : Pointer) : BOOL');
 //CL.AddDelphiFunction('Function wWriteConsoleInput( hConsoleInput : THandle; const lpBuffer : TInputRecord; nLength : DWORD; var lpNumberOfEventsWritten : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wWriteConsoleOutput( hConsoleOutput : THandle; lpBuffer : Pointer; dwBufferSize, dwBufferCoord : TCoord; var lpWriteRegion : TSmallRect) : BOOL');
 //CL.AddDelphiFunction('Function wWriteConsoleOutputCharacter( hConsoleOutput : THandle; lpCharacter : PKOLChar; nLength : DWORD; dwWriteCoord : TCoord; var lpNumberOfCharsWritten : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wWritePrivateProfileSection( lpAppName, lpString, lpFileName : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wWritePrivateProfileString( lpAppName, lpKeyName, lpString, lpFileName : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wWriteProfileSection( lpAppName, lpString : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wWriteProfileString( lpAppName, lpKeyName, lpString : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wlstrcat( lpString1, lpString2 : PKOLChar) : PKOLChar');
 CL.AddDelphiFunction('Function wlstrcmp( lpString1, lpString2 : PKOLChar) : Integer');
 CL.AddDelphiFunction('Function wlstrcmpi( lpString1, lpString2 : PKOLChar) : Integer');
 CL.AddDelphiFunction('Function wlstrcpy( lpString1, lpString2 : PKOLChar) : PKOLChar');
 CL.AddDelphiFunction('Function wlstrcpyn( lpString1, lpString2 : PKOLChar; iMaxLength : Integer) : PKOLChar');
 CL.AddDelphiFunction('Function wlstrlen( lpString : PKOLChar) : Integer');
 //CL.AddDelphiFunction('Function wMultinetGetConnectionPerformance( lpNetResource : PNetResource; lpNetConnectInfoStruc : PNetConnectInfoStruct) : DWORD');
 //CL.AddDelphiFunction('Function wWNetAddConnection2( var lpNetResource : TNetResource; lpPassword, lpUserName : PKOLChar; dwFlags : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function wWNetAddConnection3( hwndOwner : HWND; var lpNetResource : TNetResource; lpPassword, lpUserName : PKOLChar; dwFlags : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wWNetAddConnection( lpRemoteName, lpPassword, lpLocalName : PKOLChar) : DWORD');
 CL.AddDelphiFunction('Function wWNetCancelConnection2( lpName : PKOLChar; dwFlags : DWORD; fForce : BOOL) : DWORD');
 CL.AddDelphiFunction('Function wWNetCancelConnection( lpName : PKOLChar; fForce : BOOL) : DWORD');
 //CL.AddDelphiFunction('Function wWNetConnectionDialog1( var lpConnDlgStruct : TConnectDlgStruct) : DWORD');
 //CL.AddDelphiFunction('Function wWNetDisconnectDialog1( var lpConnDlgStruct : TDiscDlgStruct) : DWORD');
 //CL.AddDelphiFunction('Function wWNetEnumResource( hEnum : THandle; var lpcCount : DWORD; lpBuffer : Pointer; var lpBufferSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wWNetGetConnection( lpLocalName : PKOLChar; lpRemoteName : PKOLChar; var lpnLength : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wWNetGetLastError( var lpError : DWORD; lpErrorBuf : PKOLChar; nErrorBufSize : DWORD; lpNameBuf : PKOLChar; nNameBufSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function wWNetGetNetworkInformation( lpProvider : PKOLChar; var lpNetInfoStruct : TNetInfoStruct) : DWORD');
 CL.AddDelphiFunction('Function wWNetGetProviderName( dwNetType : DWORD; lpProviderName : PKOLChar; var lpBufferSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function wWNetGetResourceParent( lpNetResource : PNetResource; lpBuffer : Pointer; var cbBuffer : DWORD) : DWORD');
// CL.AddDelphiFunction('Function wWNetGetUniversalName( lpLocalPath : PKOLChar; dwInfoLevel : DWORD; lpBuffer : Pointer; var lpBufferSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wWNetGetUser( lpName : PKOLChar; lpUserName : PKOLChar; var lpnLength : DWORD) : DWORD');
// CL.AddDelphiFunction('Function wWNetOpenEnum( dwScope, dwType, dwUsage : DWORD; lpNetResource : PNetResource; var lphEnum : THandle) : DWORD');
// CL.AddDelphiFunction('Function wWNetSetConnection( lpName : PKOLChar; dwProperties : DWORD; pvValues : Pointer) : DWORD');
 //CL.AddDelphiFunction('Function wWNetUseConnection( hwndOwner : HWND; var lpNetResource : TNetResource; lpUserID : PKOLChar; lpPassword : PKOLChar; dwFlags : DWORD; lpAccessName : PKOLChar; var lpBufferSize : DWORD; var lpResult : DWORD) : DWORD');
// CL.AddDelphiFunction('Function wGetFileVersionInfo( lptstrFilename : PKOLChar; dwHandle, dwLen : DWORD; lpData : Pointer) : BOOL');
 CL.AddDelphiFunction('Function wGetFileVersionInfoSize( lptstrFilename : PKOLChar; var lpdwHandle : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wVerFindFile( uFlags : DWORD; szFileName, szWinDir, szAppDir, szCurDir : PKOLChar; var lpuCurDirLen : UINT; szDestDir : PKOLChar; var lpuDestDirLen : UINT) : DWORD');
 CL.AddDelphiFunction('Function wVerInstallFile( uFlags : DWORD; szSrcFileName, szDestFileName, szSrcDir, szDestDir, szCurDir, szTmpFile : PKOLChar; var lpuTmpFileLen : UINT) : DWORD');
// CL.AddDelphiFunction('Function wVerQueryValue( pBlock : Pointer; lpSubBlock : PKOLChar; var lplpBuffer : Pointer; var puLen : UINT) : BOOL');
// CL.AddDelphiFunction('Function wGetPrivateProfileStruct( lpszSection, lpszKey : PKOLChar; lpStruct : Pointer; uSizeStruct : UINT; szFile : PKOLChar) : BOOL');
// CL.AddDelphiFunction('Function wWritePrivateProfileStruct( lpszSection, lpszKey : PKOLChar; lpStruct : Pointer; uSizeStruct : UINT; szFile : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wAddFontResource( FileName : PKOLChar) : Integer');
 //CL.AddDelphiFunction('Function wAddFontResourceEx( p1 : PKOLChar; p2 : DWORD; p3 : PDesignVector) : Integer');
 CL.AddDelphiFunction('Function wCopyEnhMetaFile( p1 : HENHMETAFILE; p2 : PKOLChar) : HENHMETAFILE');
 CL.AddDelphiFunction('Function wCopyMetaFile( p1 : HMETAFILE; p2 : PKOLChar) : HMETAFILE');
 //CL.AddDelphiFunction('Function wCreateColorSpace( var ColorSpace : TLogColorSpace) : HCOLORSPACE');
 //CL.AddDelphiFunction('Function wCreateDC( lpszDriver, lpszDevice, lpszOutput : PKOLChar; lpdvmInit : PDeviceMode) : HDC');
// CL.AddDelphiFunction('Function wCreateEnhMetaFile( DC : HDC; FileName : PKOLChar; Rect : PRect; Desc : PKOLChar) : HDC');
 CL.AddDelphiFunction('Function wCreateFont( nHeight, nWidth, nEscapement, nOrientaion, fnWeight : Integer; fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision, fdwClipPrecision, fdwQuality, fdwPitchAndFamily : DWORD; lpszFace : PKOLChar) : HFONT');
 CL.AddDelphiFunction('Function wCreateFontIndirect( const p1 : TLogFont) : HFONT');
 //CL.AddDelphiFunction('Function wCreateFontIndirectEx( const p1 : PEnumLogFontExDV) : HFONT');
// CL.AddDelphiFunction('Function wCreateIC( lpszDriver, lpszDevice, lpszOutput : PKOLChar; lpdvmInit : PDeviceMode) : HDC');
 CL.AddDelphiFunction('Function wCreateMetaFile( p1 : PKOLChar) : HDC');
 CL.AddDelphiFunction('Function wCreateScalableFontResource( p1 : DWORD; p2, p3, p4 : PKOLChar) : BOOL');
 //CL.AddDelphiFunction('Function wDeviceCapabilities( pDriverName, pDeviceName, pPort : PKOLChar; iIndex : Integer; pOutput : PKOLChar; DevMode : PDeviceMode) : Integer');
// CL.AddDelphiFunction('Function wEnumFontFamilies( DC : HDC; p2 : PKOLChar; p3 : TFNFontEnumProc; p4 : LPARAM) : BOOL');
 //CL.AddDelphiFunction('Function wEnumFontFamiliesEx( DC : HDC; var p2 : TLogFont; p3 : TFNFontEnumProc; p4 : LPARAM; p5 : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wEnumFonts( DC : HDC; lpszFace : PKOLChar; fntenmprc : TFNFontEnumProc; lpszData : PKOLChar) : Integer');
 //CL.AddDelphiFunction('Function wEnumICMProfiles( DC : HDC; ICMProc : TFNICMEnumProc; p3 : LPARAM) : Integer');
 //CL.AddDelphiFunction('Function wExtTextOut( DC : HDC; X, Y : Integer; Options : Longint; Rect : PRect; Str : PKOLChar; Count : Longint; Dx : PInteger) : BOOL');
 //CL.AddDelphiFunction('Function wGetCharABCWidths( DC : HDC; FirstChar, LastChar : UINT; const ABCStructs) : BOOL');
 //CL.AddDelphiFunction('Function wGetCharABCWidthsFloat( DC : HDC; FirstChar, LastChar : UINT; const ABCFloatSturcts) : BOOL');
 //CL.AddDelphiFunction('Function wGetCharWidth32( DC : HDC; FirstChar, LastChar : UINT; const Widths) : BOOL');
 //CL.AddDelphiFunction('Function wGetCharWidth( DC : HDC; FirstChar, LastChar : UINT; const Widths) : BOOL');
// CL.AddDelphiFunction('Function wGetCharWidthFloat( DC : HDC; FirstChar, LastChar : UINT; const Widths) : BOOL');
// CL.AddDelphiFunction('Function wGetCharacterPlacement( DC : HDC; p2 : PKOLChar; p3, p4 : BOOL; var p5 : TGCPResults; p6 : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wGetEnhMetaFile( p1 : PKOLChar) : HENHMETAFILE');
 CL.AddDelphiFunction('Function wGetEnhMetaFileDescription( p1 : HENHMETAFILE; p2 : UINT; p3 : PKOLChar) : UINT');
// CL.AddDelphiFunction('Function wGetGlyphIndices( DC : HDC; p2 : PKOLChar; p3 : Integer; p4 : PWORD; p5 : DWORD) : DWORD');
// CL.AddDelphiFunction('Function wGetGlyphOutline( DC : HDC; uChar, uFormat : UINT; const lpgm : TGlyphMetrics; cbBuffer : DWORD; lpvBuffer : Pointer; const lpmat2 : TMat2) : DWORD');
 CL.AddDelphiFunction('Function wGetICMProfile( DC : HDC; var Size : DWORD; Name : PKOLChar) : BOOL');
// CL.AddDelphiFunction('Function wGetLogColorSpace( p1 : HCOLORSPACE; var ColorSpace : TLogColorSpace; Size : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wGetMetaFile( p1 : PKOLChar) : HMETAFILE');
// CL.AddDelphiFunction('Function wGetObject( p1 : HGDIOBJ; p2 : Integer; p3 : Pointer) : Integer');
 //CL.AddDelphiFunction('Function wGetOutlineTextMetrics( DC : HDC; p2 : UINT; OTMetricStructs : Pointer) : UINT');
 //CL.AddDelphiFunction('Function wGetTextExtentExPoint( DC : HDC; p2 : PKOLChar; p3, p4 : Integer; p5, p6 : PInteger; var p7 : TSize) : BOOL');
 CL.AddDelphiFunction('Function wGetTextExtentPoint32( DC : HDC; Str : PKOLChar; Count : Integer; var Size : TSize) : BOOL');
 CL.AddDelphiFunction('Function wGetTextExtentPoint( DC : HDC; Str : PKOLChar; Count : Integer; var Size : TSize) : BOOL');
 CL.AddDelphiFunction('Function wGetTextFace( DC : HDC; Count : Integer; Buffer : PKOLChar) : Integer');
 //CL.AddDelphiFunction('Function wGetTextMetrics( DC : HDC; var TM : TTextMetric) : BOOL');
 CL.AddDelphiFunction('Function wPolyTextOut( DC : HDC; const PolyTextArray, Strings : Integer) : BOOL');
 CL.AddDelphiFunction('Function wRemoveFontResource( FileName : PKOLChar) : BOOL');
 //CL.AddDelphiFunction('Function wRemoveFontResourceEx( p1 : PKOLChar; p2 : DWORD; p3 : PDesignVector) : BOOL');
 //CL.AddDelphiFunction('Function wResetDC( DC : HDC; const InitData : TDeviceMode) : HDC');
 CL.AddDelphiFunction('Function wSetICMProfile( DC : HDC; Name : PKOLChar) : BOOL');
 //CL.AddDelphiFunction('Function wStartDoc( DC : HDC; const p2 : TDocInfo) : Integer');
 CL.AddDelphiFunction('Function wTextOut( DC : HDC; X, Y : Integer; Str : PKOLChar; Count : Integer) : BOOL');
 CL.AddDelphiFunction('Function wUpdateICMRegKey( p1 : DWORD; p2, p3 : PKOLChar; p4 : UINT) : BOOL');
 CL.AddDelphiFunction('Function wwglUseFontBitmaps( DC : HDC; p2, p3, p4 : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wwglUseFontOutlines( p1 : HDC; p2, p3, p4 : DWORD; p5, p6 : Single; p7 : Integer; p8 : PGlyphMetricsFloat) : BOOL');
 CL.AddDelphiFunction('Function wAppendMenu( hMenu : HMENU; uFlags, uIDNewItem : UINT; lpNewItem : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wCallMsgFilter( var lpMsg : TMsg; nCode : Integer) : BOOL');
 //CL.AddDelphiFunction('Function wCallWindowProc( lpPrevWndFunc : TFNWndProc; hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 //CL.AddDelphiFunction('Function wChangeDisplaySettings( var lpDevMode : TDeviceMode; dwFlags : DWORD) : Longint');
// CL.AddDelphiFunction('Function wChangeDisplaySettingsEx( lpszDeviceName : PKOLChar; var lpDevMode : TDeviceMode; wnd : HWND; dwFlags : DWORD; lParam : Pointer) : Longint');
 CL.AddDelphiFunction('Function wChangeMenu( hMenu : HMENU; cmd : UINT; lpszNewItem : PKOLChar; cmdInsert : UINT; flags : UINT) : BOOL');
 CL.AddDelphiFunction('Function wCharLower( lpsz : PKOLChar) : PKOLChar');
 CL.AddDelphiFunction('Function wCharLowerBuff( lpsz : PKOLChar; cchLength : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wCharNext( lpsz : PKOLChar) : PKOLChar');
 //CL.AddDelphiFunction('Function wCharNextEx( CodePage : Word; lpCurrentChar : LPCSTR; dwFlags : DWORD) : LPSTR');
 CL.AddDelphiFunction('Function wCharPrev( lpszStart : PKOLChar; lpszCurrent : PKOLChar) : PKOLChar');
// CL.AddDelphiFunction('Function wCharPrevEx( CodePage : Word; lpStart, lpCurrentChar : LPCSTR; dwFlags : DWORD) : LPSTR');
 CL.AddDelphiFunction('Function wCharToOem( lpszSrc : PKOLChar; lpszDst : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function CharToOem2( lpszSrc : PKOLChar; lpszDst : PKOLChar) : BOOL');

 CL.AddDelphiFunction('Function wCharToOemBuff( lpszSrc : PKOLChar; lpszDst : PKOLChar; cchDstLength : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wCharUpper( lpsz : PKOLChar) : PKOLChar');
 CL.AddDelphiFunction('Function wCharUpperBuff( lpsz : PKOLChar; cchLength : DWORD) : DWORD');
 CL.AddDelphiFunction('Function wCopyAcceleratorTable( hAccelSrc : HACCEL; var lpAccelDst, cAccelEntries : Integer) : Integer');
 CL.AddDelphiFunction('Function wCreateAcceleratorTable( var Accel, Count : Integer) : HACCEL');
 //CL.AddDelphiFunction('Function wCreateDesktop( lpszDesktop, lpszDevice : PKOLChar; pDevmode : PDeviceMode; dwFlags : DWORD; dwDesiredAccess : DWORD; lpsa : PSecurityAttributes) : HDESK');
 //CL.AddDelphiFunction('Function wCreateDialogIndirectParam( hInstance : HINST; const lpTemplate : TDlgTemplate; hWndParent : HWND; lpDialogFunc : TFNDlgProc; dwInitParam : LPARAM) : HWND');
 //CL.AddDelphiFunction('Function wCreateDialogParam( hInstance : HINST; lpTemplateName : PKOLChar; hWndParent : HWND; lpDialogFunc : TFNDlgProc; dwInitParam : LPARAM) : HWND');
 CL.AddDelphiFunction('Function wCreateMDIWindow( lpClassName, lpWindowName : PKOLChar; dwStyle : DWORD; X, Y, nWidth, nHeight : Integer; hWndParent : HWND; hInstance : HINST; lParam : LPARAM) : HWND');
// CL.AddDelphiFunction('Function wCreateWindowEx( dwExStyle : DWORD; lpClassName : PKOLChar; lpWindowName : PKOLChar; dwStyle : DWORD; X, Y, nWidth, nHeight : Integer; hWndParent : HWND; hMenu : HMENU; hInstance : HINST; lpParam : Pointer) : HWND');
 //CL.AddDelphiFunction('Function wCreateWindowStation( lpwinsta : PKOLChar; dwReserved, dwDesiredAccess : DWORD; lpsa : PSecurityAttributes) : HWINSTA');
 CL.AddDelphiFunction('Function wDefDlgProc( hDlg : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 CL.AddDelphiFunction('Function wDefFrameProc( hWnd, hWndMDIClient : HWND; uMsg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 CL.AddDelphiFunction('Function wDefMDIChildProc( hWnd : HWND; uMsg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 CL.AddDelphiFunction('Function wDefWindowProc( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 //CL.AddDelphiFunction('Function wDialogBoxIndirectParam( hInstance : HINST; const lpDialogTemplate : TDlgTemplate; hWndParent : HWND; lpDialogFunc : TFNDlgProc; dwInitParam : LPARAM) : Integer');
 //CL.AddDelphiFunction('Function wDialogBoxParam( hInstance : HINST; lpTemplateName : PKOLChar; hWndParent : HWND; lpDialogFunc : TFNDlgProc; dwInitParam : LPARAM) : Integer');
 CL.AddDelphiFunction('Function wDispatchMessage( const lpMsg : TMsg) : Longint');
 CL.AddDelphiFunction('Function wDlgDirList( hDlg : HWND; lpPathSpec : PKOLChar; nIDListBox, nIDStaticPath : Integer; uFileType : UINT) : Integer');
 CL.AddDelphiFunction('Function wDlgDirListComboBox( hDlg : HWND; lpPathSpec : PKOLChar; nIDComboBox, nIDStaticPath : Integer; uFiletype : UINT) : Integer');
 CL.AddDelphiFunction('Function wDlgDirSelectComboBoxEx( hDlg : HWND; lpString : PKOLChar; nCount, nIDComboBox : Integer) : BOOL');
 CL.AddDelphiFunction('Function wDlgDirSelectEx( hDlg : HWND; lpString : PKOLChar; nCount, nIDListBox : Integer) : BOOL');
 //CL.AddDelphiFunction('Function wDrawState( DC : HDC; Brush : HBRUSH; CBFunc : TFNDrawStateProc; lData : LPARAM; wData : WPARAM; x, y, cx, cy : Integer; Flags : UINT) : BOOL');
 CL.AddDelphiFunction('Function wDrawText( hDC : HDC; lpString : PKOLChar; nCount : Integer; var lpRect : TRect; uFormat : UINT) : Integer');
 CL.AddDelphiFunction('Function wFindWindow( lpClassName, lpWindowName : PKOLChar) : HWND');
 CL.AddDelphiFunction('Function wFindWindowEx( Parent, Child : HWND; ClassName, WindowName : PKOLChar) : HWND');
 //CL.AddDelphiFunction('Function wGetAltTabInfo( hwnd : HWND; iItem : Integer; var pati : TAltTabInfo; pszItemText : PKOLChar; cchItemText : UINT) : BOOL');
// CL.AddDelphiFunction('Function wGetClassInfo( hInstance : HINST; lpClassName : PKOLChar; var lpWndClass : TWndClass) : BOOL');
 //CL.AddDelphiFunction('Function wGetClassInfoEx( Instance : HINST; Classname : PKOLChar; var WndClass : TWndClassEx) : BOOL');
 CL.AddDelphiFunction('Function wGetClassLong( hWnd : HWND; nIndex : Integer) : DWORD');
 CL.AddDelphiFunction('Function wGetClassName( hWnd : HWND; lpClassName : PKOLChar; nMaxCount : Integer) : Integer');
 CL.AddDelphiFunction('Function wGetClipboardFormatName( format : UINT; lpszFormatName : PKOLChar; cchMaxCount : Integer) : Integer');
 CL.AddDelphiFunction('Function wGetDlgItemText( hDlg : HWND; nIDDlgItem : Integer; lpString : PKOLChar; nMaxCount : Integer) : UINT');
 CL.AddDelphiFunction('Function wGetKeyNameText( lParam : Longint; lpString : PKOLChar; nSize : Integer) : Integer');
 CL.AddDelphiFunction('Function wGetKeyboardLayoutName( pwszKLID : PKOLChar) : BOOL');
 //CL.AddDelphiFunction('Function wGetMenuItemInfo( p1 : HMENU; p2 : UINT; p3 : BOOL; var p4 : TMenuItemInfo) : BOOL');
 CL.AddDelphiFunction('Function wGetMenuString( hMenu : HMENU; uIDItem : UINT; lpString : PKOLChar; nMaxCount : Integer; uFlag : UINT) : Integer');
 CL.AddDelphiFunction('Function wGetMessage( var lpMsg : TMsg; hWnd : HWND; wMsgFilterMin, wMsgFilterMax : UINT) : BOOL');
 CL.AddDelphiFunction('Function wGetProp( hWnd : HWND; lpString : PKOLChar) : THandle');
 //CL.AddDelphiFunction('Function wGetTabbedTextExtent( hDC : HDC; lpString : PKOLChar; nCount, nTabPositions : Integer; var lpnTabStopPositions) : DWORD');
// CL.AddDelphiFunction('Function wGetUserObjectInformation( hObj : THandle; nIndex : Integer; pvInfo : Pointer; nLength : DWORD; var lpnLengthNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wGetWindowLong( hWnd : HWND; nIndex : Integer) : Longint');
 CL.AddDelphiFunction('Function wGetWindowModuleFileName( hwnd : HWND; pszFileName : PKOLChar; cchFileNameMax : UINT) : UINT');
 CL.AddDelphiFunction('Function wGetWindowText( hWnd : HWND; lpString : PKOLChar; nMaxCount : Integer) : Integer');
 CL.AddDelphiFunction('Function wGetWindowTextLength( hWnd : HWND) : Integer');
// CL.AddDelphiFunction('Function wGrayString( hDC : HDC; hBrush : HBRUSH; lpOutputFunc : TFNGrayStringProc; lpData : LPARAM; nCount, X, Y, nWidth, nHeight : Integer) : BOOL');
 CL.AddDelphiFunction('Function wInsertMenu( hMenu : HMENU; uPosition, uFlags, uIDNewItem : UINT; lpNewItem : PKOLChar) : BOOL');
 //CL.AddDelphiFunction('Function wInsertMenuItem( p1 : HMENU; p2 : UINT; p3 : BOOL; const p4 : TMenuItemInfo) : BOOL');
 CL.AddDelphiFunction('Function wIsCharAlpha( ch : KOLChar) : BOOL');
 CL.AddDelphiFunction('Function wIsCharAlphaNumeric( ch : KOLChar) : BOOL');
 CL.AddDelphiFunction('Function wIsCharLower( ch : KOLChar) : BOOL');
 CL.AddDelphiFunction('Function wIsCharUpper( ch : KOLChar) : BOOL');
 CL.AddDelphiFunction('Function wIsDialogMessage( hDlg : HWND; var lpMsg : TMsg) : BOOL');
 CL.AddDelphiFunction('Function wLoadAccelerators( hInstance : HINST; lpTableName : PKOLChar) : HACCEL');
 CL.AddDelphiFunction('Function wLoadBitmap( hInstance : HINST; lpBitmapName : PKOLChar) : HBITMAP');
 CL.AddDelphiFunction('Function wLoadCursor( hInstance : HINST; lpCursorName : PKOLChar) : HCURSOR');
 CL.AddDelphiFunction('Function wLoadCursorFromFile( lpFileName : PKOLChar) : HCURSOR');
 CL.AddDelphiFunction('Function wLoadIcon( hInstance : HINST; lpIconName : PKOLChar) : HICON');
 CL.AddDelphiFunction('Function wLoadImage( hInst : HINST; ImageName : PKOLChar; ImageType : UINT; X, Y : Integer; Flags : UINT) : THandle');
 CL.AddDelphiFunction('Function wLoadKeyboardLayout( pwszKLID : PKOLChar; Flags : UINT) : HKL');
 CL.AddDelphiFunction('Function wLoadMenu( hInstance : HINST; lpMenuName : PKOLChar) : HMENU');
 //CL.AddDelphiFunction('Function wLoadMenuIndirect( lpMenuTemplate : Pointer) : HMENU');
 CL.AddDelphiFunction('Function wLoadString( hInstance : HINST; uID : UINT; lpBuffer : PKOLChar; nBufferMax : Integer) : Integer');
 CL.AddDelphiFunction('Function wMapVirtualKey( uCode, uMapType : UINT) : UINT');
 CL.AddDelphiFunction('Function wMapVirtualKeyEx( uCode, uMapType : UINT; dwhkl : HKL) : UINT');
 CL.AddDelphiFunction('Function wMessageBox( hWnd : HWND; lpText, lpCaption : PKOLChar; uType : UINT) : Integer');
 CL.AddDelphiFunction('Function wMessageBoxEx( hWnd : HWND; lpText, lpCaption : PKOLChar; uType : UINT; wLanguageId : Word) : Integer');
 //CL.AddDelphiFunction('Function wMessageBoxIndirect( const MsgBoxParams : TMsgBoxParams) : BOOL');
 CL.AddDelphiFunction('Function wModifyMenu( hMnu : HMENU; uPosition, uFlags, uIDNewItem : UINT; lpNewItem : PKOLChar) : BOOL');
 //CL.AddDelphiFunction('Function wOemToAnsi( const lpszSrc : LPCSTR; lpszDst : LPSTR) : BOOL');
 //7CL.AddDelphiFunction('Function wOemToAnsiBuff( lpszSrc : LPCSTR; lpszDst : LPSTR; cchDstLength : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function wOemToChar( lpszSrc : PKOLChar; lpszDst : PKOLChar) : BOOL');
 CL.AddDelphiFunction('Function wOemToCharBuff( lpszSrc : PKOLChar; lpszDst : PKOLChar; cchDstLength : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wOpenDesktop( lpszDesktop : PKOLChar; dwFlags : DWORD; fInherit : BOOL; dwDesiredAccess : DWORD) : HDESK');
 CL.AddDelphiFunction('Function wOpenWindowStation( lpszWinSta : PKOLChar; fInherit : BOOL; dwDesiredAccess : DWORD) : HWINSTA');
 CL.AddDelphiFunction('Function wPeekMessage( var lpMsg : TMsg; hWnd : HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg : UINT) : BOOL');
 CL.AddDelphiFunction('Function wPostMessage( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : BOOL');
 CL.AddDelphiFunction('Function wPostThreadMessage( idThread : DWORD; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : BOOL');
 CL.AddDelphiFunction('Function wRealGetWindowClass( hwnd : HWND; pszType : PKOLChar; cchType : UINT) : UINT');
// CL.AddDelphiFunction('Function wRegisterClass( const lpWndClass : TWndClass) : ATOM');
// CL.AddDelphiFunction('Function wRegisterClassEx( const WndClass : TWndClassEx) : ATOM');
 CL.AddDelphiFunction('Function wRegisterClipboardFormat( lpszFormat : PKOLChar) : UINT');
// CL.AddDelphiFunction('Function wRegisterDeviceNotification( hRecipient : THandle; NotificationFilter : Pointer; Flags : DWORD) : HDEVNOTIFY');
 CL.AddDelphiFunction('Function wRegisterWindowMessage( lpString : PKOLChar) : UINT');
 CL.AddDelphiFunction('Function wRemoveProp( hWnd : HWND; lpString : PKOLChar) : THandle');
 CL.AddDelphiFunction('Function wSendDlgItemMessage( hDlg : HWND; nIDDlgItem : Integer; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : Longint');
 CL.AddDelphiFunction('Function wSendMessage( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 //CL.AddDelphiFunction('Function wSendMessageCallback( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM; lpResultCallBack : TFNSendAsyncProc; dwData : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wSendMessageTimeout( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM; fuFlags, uTimeout : UINT; var lpdwResult : DWORD) : LRESULT');
 CL.AddDelphiFunction('Function wSendNotifyMessage( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : BOOL');
 CL.AddDelphiFunction('Function wSetClassLong( hWnd : HWND; nIndex : Integer; dwNewLong : Longint) : DWORD');
 CL.AddDelphiFunction('Function wSetDlgItemText( hDlg : HWND; nIDDlgItem : Integer; lpString : PKOLChar) : BOOL');
 //CL.AddDelphiFunction('Function wSetMenuItemInfo( p1 : HMENU; p2 : UINT; p3 : BOOL; const p4 : TMenuItemInfo) : BOOL');
 CL.AddDelphiFunction('Function wSetProp( hWnd : HWND; lpString : PKOLChar; hData : THandle) : BOOL');
// CL.AddDelphiFunction('Function wSetUserObjectInformation( hObj : THandle; nIndex : Integer; pvInfo : Pointer; nLength : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wSetWindowLong( hWnd : HWND; nIndex : Integer; dwNewLong : Longint) : Longint');
 CL.AddDelphiFunction('Function wSetWindowText( hWnd : HWND; lpString : PKOLChar) : BOOL');
 //CL.AddDelphiFunction('Function wSetWindowsHook( nFilterType : Integer; pfnFilterProc : TFNHookProc) : HHOOK');
 //CL.AddDelphiFunction('Function wSetWindowsHookEx( idHook : Integer; lpfn : TFNHookProc; hmod : HINST; dwThreadId : DWORD) : HHOOK');
// CL.AddDelphiFunction('Function wSystemParametersInfo( uiAction, uiParam : UINT; pvParam : Pointer; fWinIni : UINT) : BOOL');
 CL.AddDelphiFunction('Function wTabbedTextOut( hDC : HDC; X, Y : Integer; lpString : PKOLChar; nCount, nTabPositions : Integer; var lpnTabStopPositions, nTabOrigin : Integer) : Longint');
 CL.AddDelphiFunction('Function wTranslateAccelerator( hWnd : HWND; hAccTable : HACCEL; var lpMsg : TMsg) : Integer');
 CL.AddDelphiFunction('Function wUnregisterClass( lpClassName : PKOLChar; hInstance : HINST) : BOOL');
 CL.AddDelphiFunction('Function wVkKeyScan( ch : KOLChar) : SHORT');
 CL.AddDelphiFunction('Function wVkKeyScanEx( ch : KOLChar; dwhkl : HKL) : SHORT');
 CL.AddDelphiFunction('Function wWinHelp( hWndMain : HWND; lpszHelp : PKOLChar; uCommand : UINT; dwData : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wwsprintf( Output : PKOLChar; Format : PKOLChar) : Integer');
 CL.AddDelphiFunction('Function wwvsprintf( Output : PKOLChar; Format : PKOLChar; arglist : va_list) : Integer');

 CL.AddDelphiFunction('Function GetBinaryType( lpApplicationName : PChar; var lpBinaryType : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function GetBinaryTypeA( lpApplicationName : PAnsiChar; var lpBinaryType : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function GetBinaryTypeW( lpApplicationName : PWideChar; var lpBinaryType : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wGetShortPathName( lpszLongPath : PChar; lpszShortPath : PChar; cchBuffer : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetShortPathNameA( lpszLongPath : PAnsiChar; lpszShortPath : PAnsiChar; cchBuffer : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetShortPathNameW( lpszLongPath : PWideChar; lpszShortPath : PWideChar; cchBuffer : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GetProcessAffinityMask( hProcess : THandle; var lpProcessAffinityMask, lpSystemAffinityMask : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetProcessAffinityMask( hProcess : THandle; dwProcessAffinityMask : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetProcessTimes( hProcess : THandle; var lpCreationTime, lpExitTime, lpKernelTime, lpUserTime : TFileTime) : BOOL');
 CL.AddDelphiFunction('Function GetProcessWorkingSetSize( hProcess : THandle; var lpMinimumWorkingSetSize, lpMaximumWorkingSetSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetProcessWorkingSetSize( hProcess : THandle; dwMinimumWorkingSetSize, dwMaximumWorkingSetSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function OpenProcess( dwDesiredAccess : DWORD; bInheritHandle : BOOL; dwProcessId : DWORD) : THandle');
 CL.AddDelphiFunction('Function GetCurrentProcess : THandle');
 CL.AddDelphiFunction('Function wGetCurrentProcessId : DWORD');
 CL.AddDelphiFunction('Procedure ExitProcess( uExitCode : UINT)');
 CL.AddDelphiFunction('Function TerminateProcess( hProcess : THandle; uExitCode : UINT) : BOOL');
 CL.AddDelphiFunction('Function GetExitCodeProcess( hProcess : THandle; var lpExitCode : DWORD) : BOOL');
 CL.AddDelphiFunction('Procedure FatalExit( ExitCode : Integer)');
 CL.AddDelphiFunction('Function GlobalDeleteAtom( nAtom : ATOM) : ATOM');
 CL.AddDelphiFunction('Function InitAtomTable( nSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function DeleteAtom( nAtom : ATOM) : ATOM');
 CL.AddDelphiFunction('Function SetHandleCount( uNumber : UINT) : UINT');
 CL.AddDelphiFunction('Function GetLogicalDrives : DWORD');
 CL.AddDelphiFunction('Function LockFile( hFile : THandle; dwFileOffsetLow, dwFileOffsetHigh : DWORD; nNumberOfBytesToLockLow, nNumberOfBytesToLockHigh : DWORD) : BOOL');
 CL.AddDelphiFunction('Function UnlockFile( hFile : THandle; dwFileOffsetLow, dwFileOffsetHigh : DWORD; nNumberOfBytesToUnlockLow, nNumberOfBytesToUnlockHigh : DWORD) : BOOL');
 CL.AddDelphiFunction('Function wLoadResource( hModule : HINST; hResInfo : HRSRC) : HGLOBAL');
 CL.AddDelphiFunction('Function wSizeofResource( hModule : HINST; hResInfo : HRSRC) : DWORD');
 CL.AddDelphiFunction('Function GetWindowTask( hWnd : HWND) : THandle');
 CL.AddDelphiFunction('Function GetLastActivePopup( hWnd : HWND) : HWND');
 CL.AddDelphiFunction('function GetMDACVersion2: string;');
 CL.AddDelphiFunction('function ComposeDateTime(Date,Time : TDateTime) : TDateTime;');
 CL.AddDelphiFunction('function FullTimeToStr(SUMTime: TDateTime): string;');
 CL.AddDelphiFunction('function GetBaseAddress(PID:DWORD):DWORD;');
 CL.AddDelphiFunction('Function GetSystemDefaultLangID : LANGID');
 CL.AddDelphiFunction('Function GetUserDefaultLangID : LANGID');
 CL.AddDelphiFunction('procedure UpdateExeResource(Const Source,Dest:string);');
 CL.AddDelphiFunction('procedure VarClear(var V: Variant);');
 CL.AddDelphiFunction('function DynamicDllCallName(Dll: String; const Name: String; HasResult: Boolean; var Returned: Cardinal; const Parameters: array of integer): Boolean;');
 CL.AddDelphiFunction('function DynamicDllCall(hDll: THandle; const Name: String; HasResult: Boolean; var Returned: Cardinal; const Parameters: array of integer): Boolean;');
 CL.AddDelphiFunction('function DynamicDllCallNames(Dll: String; const Name: String; HasResult: Boolean; var Returned: Cardinal; const Parameters: array of string): Boolean;');
 CL.AddDelphiFunction('procedure LV_InsertFiles(strPath: string; ListView: TListView; ImageList: TImageList);');
 CL.AddDelphiFunction('procedure CreateBrowserOnForm(aform: TForm; aurl: string);');
 CL.AddDelphiFunction('procedure WebOnForm(aform: TForm; aurl: string);');
 CL.AddDelphiFunction('procedure WebToForm(aform: TForm; aurl: string);');
 CL.AddDelphiFunction('procedure SearchAndHighlightWebText(aform: TForm; aurl: string; aText: string);');
 CL.AddDelphiFunction('procedure SaveImagesOnWeb(aurl, apath: string);');
 CL.AddDelphiFunction('function GetProcessNameFromWnd(Wnd: HWND): string;');
 //CL.AddDelphiFunction('function getallEvents(aform: TForm): TStringlist;');

  CL.AddDelphiFunction('function RunAsAdmin(hWnd: HWND; filename: string; Parameters: string): Boolean;');
 CL.AddDelphiFunction('procedure ModifyFontsFor(ctrl: TWinControl; afontname: string);');
 CL.AddDelphiFunction('procedure GetAccessTimeOut(var bTimeOut: Boolean; var bFeedBack: Boolean; var iTimeOutTime: Integer);');
 CL.AddDelphiFunction('function GetParentProcessName: String;');


// varclear
  //function GetBaseAddress(PID:DWORD):DWORD;
  //function FullTimeToStr(SUMTime: TDateTime): string;
  //  hinternet

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_AfUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SafeCloseHandle, 'SafeCloseHandle', cdRegister);
 S.RegisterDelphiFunction(@ExchangeInteger, 'ExchangeInteger', cdRegister);
 S.RegisterDelphiFunction(@FillInteger, 'FillInteger', cdRegister);
 S.RegisterDelphiFunction(@LongMulDiv, 'LongMulDiv', CdStdCall);
 S.RegisterDelphiFunction(@CompareMem, 'afCompareMem', cdRegister);
 S.RegisterDelphiFunction(@AbortSystemShutdown, 'AbortSystemShutdown', CdStdCall);
 S.RegisterDelphiFunction(@AccessCheckAndAuditAlarm, 'AccessCheckAndAuditAlarm', CdStdCall);
 S.RegisterDelphiFunction(@AccessCheckByTypeAndAuditAlarm, 'AccessCheckByTypeAndAuditAlarm', CdStdCall);
 S.RegisterDelphiFunction(@AccessCheckByTypeResultListAndAuditAlarm, 'AccessCheckByTypeResultListAndAuditAlarm', CdStdCall);
 S.RegisterDelphiFunction(@BackupEventLog, 'BackupEventLog', CdStdCall);
 S.RegisterDelphiFunction(@ClearEventLog, 'ClearEventLog', CdStdCall);
 S.RegisterDelphiFunction(@CreateProcessAsUser, 'CreateProcessAsUser', CdStdCall);
 //S.RegisterDelphiFunction(@GetCurrentHwProfile, 'GetCurrentHwProfile', CdStdCall);
 //S.RegisterDelphiFunction(@GetFileSecurity, 'GetFileSecurity', CdStdCall);
 S.RegisterDelphiFunction(@GetUserName, 'avGetUserName', CdStdCall);
 S.RegisterDelphiFunction(@InitiateSystemShutdown, 'InitiateSystemShutdown', CdStdCall);
 S.RegisterDelphiFunction(@LogonUser, 'LogonUser', CdStdCall);
 S.RegisterDelphiFunction(@LookupAccountName, 'LookupAccountName', CdStdCall);
 S.RegisterDelphiFunction(@LookupAccountSid, 'LookupAccountSid', CdStdCall);
 S.RegisterDelphiFunction(@LookupPrivilegeDisplayName, 'LookupPrivilegeDisplayName', CdStdCall);
 S.RegisterDelphiFunction(@LookupPrivilegeName, 'LookupPrivilegeName', CdStdCall);
 S.RegisterDelphiFunction(@LookupPrivilegeValue, 'LookupPrivilegeValue', CdStdCall);
 //S.RegisterDelphiFunction(@ObjectCloseAuditAlarm, 'ObjectCloseAuditAlarm', CdStdCall);
 //S.RegisterDelphiFunction(@ObjectDeleteAuditAlarm, 'ObjectDeleteAuditAlarm', CdStdCall);
 //S.RegisterDelphiFunction(@ObjectOpenAuditAlarm, 'ObjectOpenAuditAlarm', CdStdCall);
 //S.RegisterDelphiFunction(@ObjectPrivilegeAuditAlarm, 'ObjectPrivilegeAuditAlarm', CdStdCall);
 S.RegisterDelphiFunction(@OpenBackupEventLog, 'OpenBackupEventLog', CdStdCall);
 S.RegisterDelphiFunction(@OpenEventLog, 'OpenEventLog', CdStdCall);
 S.RegisterDelphiFunction(@PrivilegedServiceAuditAlarm, 'PrivilegedServiceAuditAlarm', CdStdCall);
 S.RegisterDelphiFunction(@ReadEventLog, 'ReadEventLog', CdStdCall);
 S.RegisterDelphiFunction(@RegConnectRegistry, 'RegConnectRegistry', CdStdCall);
 S.RegisterDelphiFunction(@RegCreateKey, 'RegCreateKey', CdStdCall);
 S.RegisterDelphiFunction(@RegCreateKeyEx, 'RegCreateKeyEx', CdStdCall);
 S.RegisterDelphiFunction(@RegDeleteKey, 'RegDeleteKey', CdStdCall);
 S.RegisterDelphiFunction(@RegDeleteValue, 'RegDeleteValue', CdStdCall);
 S.RegisterDelphiFunction(@RegEnumKeyEx, 'RegEnumKeyEx', CdStdCall);
 S.RegisterDelphiFunction(@RegEnumKey, 'RegEnumKey', CdStdCall);
 S.RegisterDelphiFunction(@RegEnumValue, 'RegEnumValue', CdStdCall);
 S.RegisterDelphiFunction(@RegLoadKey, 'RegLoadKey', CdStdCall);
 S.RegisterDelphiFunction(@RegOpenKey, 'RegOpenKey', CdStdCall);
 S.RegisterDelphiFunction(@RegCloseKey, 'RegCloseKey', CdStdCall);
 S.RegisterDelphiFunction(@RegOpenKeyEx, 'RegOpenKeyEx', CdStdCall);
 S.RegisterDelphiFunction(@RegQueryInfoKey, 'RegQueryInfoKey', CdStdCall);
 S.RegisterDelphiFunction(@RegQueryMultipleValues, 'RegQueryMultipleValues', CdStdCall);
 S.RegisterDelphiFunction(@RegQueryValue, 'RegQueryValue', CdStdCall);
 S.RegisterDelphiFunction(@RegQueryValueEx, 'RegQueryValueEx', CdStdCall);
 S.RegisterDelphiFunction(@RegReplaceKey, 'RegReplaceKey', CdStdCall);
 S.RegisterDelphiFunction(@RegRestoreKey, 'RegRestoreKey', CdStdCall);
 S.RegisterDelphiFunction(@RegSaveKey, 'RegSaveKey', CdStdCall);
 S.RegisterDelphiFunction(@RegSetValue, 'RegSetValue', CdStdCall);
 S.RegisterDelphiFunction(@RegSetValueEx, 'RegSetValueEx', CdStdCall);
 S.RegisterDelphiFunction(@RegUnLoadKey, 'RegUnLoadKey', CdStdCall);
 S.RegisterDelphiFunction(@RegisterEventSource, 'RegisterEventSource', CdStdCall);
 //S.RegisterDelphiFunction(@ReportEvent, 'ReportEvent', CdStdCall);
 //S.RegisterDelphiFunction(@SetFileSecurity, 'SetFileSecurity', CdStdCall);
  S.RegisterDelphiFunction(@GetDomainUserSidS, 'GetDomainUserSidS', cdRegister);
 S.RegisterDelphiFunction(@GetLocalUserSidStr, 'GetLocalUserSidStr', cdRegister);
 //S.RegisterDelphiFunction(@getPid4user, 'getPid4user', cdRegister);
 S.RegisterDelphiFunction(@Impersonate2User, 'Impersonate2User', cdRegister);
 S.RegisterDelphiFunction(@GetProcessUserBypid, 'GetProcessUserBypid', cdRegister);
 S.RegisterDelphiFunction(@KillProcessbyname, 'KillProcessbyname', cdRegister);
 S.RegisterDelphiFunction(@getWinProcessList, 'getWinProcessList', cdRegister);
 //S.RegisterDelphiFunction(@myimpersontest, 'myimpersontest', cdRegister);
 S.RegisterDelphiFunction(@SetViewportExtEx, 'SetViewportExtEx', CdStdCall);
 S.RegisterDelphiFunction(@SetViewportOrgEx, 'SetViewportOrgEx', CdStdCall);
 //with w___________
 S.RegisterDelphiFunction(@AddAtom, 'wAddAtom', CdStdCall);
 S.RegisterDelphiFunction(@BeginUpdateResource, 'wBeginUpdateResource', CdStdCall);
 S.RegisterDelphiFunction(@BuildCommDCB, 'wBuildCommDCB', CdStdCall);
 S.RegisterDelphiFunction(@BuildCommDCBAndTimeouts, 'wBuildCommDCBAndTimeouts', CdStdCall);
 S.RegisterDelphiFunction(@CallNamedPipe, 'wCallNamedPipe', CdStdCall);
 S.RegisterDelphiFunction(@CommConfigDialog, 'wCommConfigDialog', CdStdCall);
 S.RegisterDelphiFunction(@CompareString, 'wCompareString', CdStdCall);
 S.RegisterDelphiFunction(@CopyFile, 'wCopyFile', CdStdCall);
 S.RegisterDelphiFunction(@CopyFileEx, 'wCopyFileEx', CdStdCall);
 S.RegisterDelphiFunction(@CreateDirectory, 'wCreateDirectory', CdStdCall);
 S.RegisterDelphiFunction(@CreateDirectoryEx, 'wCreateDirectoryEx', CdStdCall);
 S.RegisterDelphiFunction(@CreateEvent, 'wCreateEvent', CdStdCall);
 S.RegisterDelphiFunction(@CreateFile, 'wCreateFile', CdStdCall);
 S.RegisterDelphiFunction(@CreateFile, 'CreateFile', CdStdCall);
 S.RegisterDelphiFunction(@GetStdHandle, 'GetStdHandle', CdStdCall);
 S.RegisterDelphiFunction(@GetStdHandle, 'SetStdHandle1', CdStdCall);
 S.RegisterDelphiFunction(@WriteFile, 'WriteFile', CdStdCall);
 S.RegisterDelphiFunction(@ReadFile, 'ReadFile', CdStdCall);
 S.RegisterDelphiFunction(@FlushFileBuffers, 'FlushFileBuffers', CdStdCall);
 S.RegisterDelphiFunction(@SetEndOfFile, 'SetEndOfFile', CdStdCall);

 S.RegisterDelphiFunction(@CreateFileMapping, 'wCreateFileMapping', CdStdCall);
 S.RegisterDelphiFunction(@CreateHardLink, 'wCreateHardLink', CdStdCall);
 S.RegisterDelphiFunction(@CreateMailslot, 'wCreateMailslot', CdStdCall);
 S.RegisterDelphiFunction(@CreateNamedPipe, 'wCreateNamedPipe', CdStdCall);
 S.RegisterDelphiFunction(@CreateProcess, 'wCreateProcess', CdStdCall);
 S.RegisterDelphiFunction(@CreateSemaphore, 'wCreateSemaphore', CdStdCall);
 S.RegisterDelphiFunction(@CreateWaitableTimer, 'wCreateWaitableTimer', CdStdCall);
 S.RegisterDelphiFunction(@DefineDosDevice, 'wDefineDosDevice', CdStdCall);
 S.RegisterDelphiFunction(@DeleteFile, 'wDeleteFile', CdStdCall);
 S.RegisterDelphiFunction(@EndUpdateResource, 'wEndUpdateResource', CdStdCall);
 S.RegisterDelphiFunction(@ExpandEnvironmentStrings, 'wExpandEnvironmentStrings', CdStdCall);
 S.RegisterDelphiFunction(@FatalAppExit, 'wFatalAppExit', CdStdCall);
 S.RegisterDelphiFunction(@FillConsoleOutputCharacter, 'wFillConsoleOutputCharacter', CdStdCall);
 S.RegisterDelphiFunction(@FindAtom, 'wFindAtom', CdStdCall);
 S.RegisterDelphiFunction(@FindFirstChangeNotification, 'wFindFirstChangeNotification', CdStdCall);
 S.RegisterDelphiFunction(@FindFirstFile, 'wFindFirstFile', CdStdCall);
 S.RegisterDelphiFunction(@FindFirstFileEx, 'wFindFirstFileEx', CdStdCall);
 S.RegisterDelphiFunction(@FindNextFile, 'wFindNextFile', CdStdCall);
 S.RegisterDelphiFunction(@FindResource, 'wFindResource', CdStdCall);
 S.RegisterDelphiFunction(@FindResourceEx, 'wFindResourceEx', CdStdCall);
 S.RegisterDelphiFunction(@FoldString, 'wFoldString', CdStdCall);
 S.RegisterDelphiFunction(@FormatMessage, 'wFormatMessage', CdStdCall);
 S.RegisterDelphiFunction(@FreeEnvironmentStrings, 'wFreeEnvironmentStrings', CdStdCall);
 S.RegisterDelphiFunction(@GetAtomName, 'wGetAtomName', CdStdCall);
 S.RegisterDelphiFunction(@GetBinaryType, 'wGetBinaryType', CdStdCall);
 S.RegisterDelphiFunction(@GetCommandLine, 'wgetCommandLine', CdStdCall);
 S.RegisterDelphiFunction(@GetCompressedFileSize, 'wGetCompressedFileSize', CdStdCall);
 S.RegisterDelphiFunction(@GetComputerName, 'wGetComputerName', CdStdCall);
 S.RegisterDelphiFunction(@GetConsoleTitle, 'wGetConsoleTitle', CdStdCall);
 S.RegisterDelphiFunction(@GetConsoleTitle, 'GetConsoleTitle', CdStdCall);
 S.RegisterDelphiFunction(@GetConsoleMode, 'GetConsoleMode', CdStdCall);
 S.RegisterDelphiFunction(@SetConsoleMode, 'SetConsoleMode', CdStdCall);

 // Win32Check(GetConsoleMode(StdIn, ConsoleMode));
 // Win32Check(SetConsoleMode(StdIn, ConsoleMode and (not ENABLE_ECHO_INPUT)));

 S.RegisterDelphiFunction(@GetCurrencyFormat, 'wGetCurrencyFormat', CdStdCall);
 S.RegisterDelphiFunction(@GetCurrentDirectory, 'wGetCurrentDirectory', CdStdCall);
 S.RegisterDelphiFunction(@GetDateFormat, 'wGetDateFormat', CdStdCall);
 S.RegisterDelphiFunction(@GetDefaultCommConfig, 'wGetDefaultCommConfig', CdStdCall);
 S.RegisterDelphiFunction(@GetDiskFreeSpace, 'wGetDiskFreeSpace', CdStdCall);
 S.RegisterDelphiFunction(@GetDiskFreeSpaceEx, 'wGetDiskFreeSpaceEx', CdStdCall);
 S.RegisterDelphiFunction(@GetDriveType, 'wGetDriveType', CdStdCall);
 S.RegisterDelphiFunction(@GetEnvironmentStrings, 'wGetEnvironmentStrings', CdStdCall);
 //S.RegisterDelphiFunction(@GetEnvironmentVariable, 'wGetEnvironmentVariable', CdStdCall);!!
 S.RegisterDelphiFunction(@GetFileAttributes, 'wGetFileAttributes', CdStdCall);
 S.RegisterDelphiFunction(@GetFileAttributesEx, 'wGetFileAttributesEx', CdStdCall);
 S.RegisterDelphiFunction(@GetFullPathName, 'wGetFullPathName', CdStdCall);
 S.RegisterDelphiFunction(@GetLocaleInfo, 'wGetLocaleInfo', CdStdCall);
 S.RegisterDelphiFunction(@GetLogicalDriveStrings, 'wGetLogicalDriveStrings', CdStdCall);
 S.RegisterDelphiFunction(@GetModuleFileName, 'wGetModuleFileName', CdStdCall);
 S.RegisterDelphiFunction(@GetModuleHandle, 'wGetModuleHandle', CdStdCall);
 S.RegisterDelphiFunction(@GetNumberFormat, 'wGetNumberFormat', CdStdCall);
 S.RegisterDelphiFunction(@GetPrivateProfileInt, 'wGetPrivateProfileInt', CdStdCall);
 S.RegisterDelphiFunction(@GetPrivateProfileSection, 'wGetPrivateProfileSection', CdStdCall);
 S.RegisterDelphiFunction(@GetPrivateProfileSectionNames, 'wGetPrivateProfileSectionNames', CdStdCall);
 S.RegisterDelphiFunction(@GetPrivateProfileString, 'wGetPrivateProfileString', CdStdCall);
 S.RegisterDelphiFunction(@GetProfileInt, 'wGetProfileInt', CdStdCall);
 S.RegisterDelphiFunction(@GetProfileSection, 'wGetProfileSection', CdStdCall);
 S.RegisterDelphiFunction(@GetProfileString, 'wGetProfileString', CdStdCall);
 S.RegisterDelphiFunction(@GetShortPathName, 'wGetShortPathName', CdStdCall);
 S.RegisterDelphiFunction(@GetStartupInfo, 'wGetStartupInfo', CdStdCall);
 S.RegisterDelphiFunction(@GetStringTypeEx, 'wGetStringTypeEx', CdStdCall);
 S.RegisterDelphiFunction(@GetSystemDirectory, 'wGetSystemDirectory', CdStdCall);
 S.RegisterDelphiFunction(@GetTempFileName, 'wGetTempFileName', CdStdCall);
 S.RegisterDelphiFunction(@GetTempPath, 'wGetTempPath', CdStdCall);
 S.RegisterDelphiFunction(@GetTimeFormat, 'wGetTimeFormat', CdStdCall);
 S.RegisterDelphiFunction(@GetVersionEx, 'wGetVersionEx', CdStdCall);
 S.RegisterDelphiFunction(@GetVolumeInformation, 'wGetVolumeInformation', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowsDirectory, 'wGetWindowsDirectory', CdStdCall);
 S.RegisterDelphiFunction(@GlobalAddAtom, 'wGlobalAddAtom', CdStdCall);
 S.RegisterDelphiFunction(@GlobalFindAtom, 'wGlobalFindAtom', CdStdCall);
 S.RegisterDelphiFunction(@GlobalGetAtomName, 'wGlobalGetAtomName', CdStdCall);
 S.RegisterDelphiFunction(@IsBadStringPtr, 'wIsBadStringPtr', CdStdCall);
 S.RegisterDelphiFunction(@LCMapString, 'wLCMapString', CdStdCall);
 S.RegisterDelphiFunction(@LoadLibrary, 'wLoadLibrary', CdStdCall);
 S.RegisterDelphiFunction(@MoveFile, 'wMoveFile', CdStdCall);
 S.RegisterDelphiFunction(@MoveFileEx, 'wMoveFileEx', CdStdCall);
 S.RegisterDelphiFunction(@MoveFileWithProgress, 'wMoveFileWithProgress', CdStdCall);
 S.RegisterDelphiFunction(@OpenEvent, 'wOpenEvent', CdStdCall);
 S.RegisterDelphiFunction(@OpenFileMapping, 'wOpenFileMapping', CdStdCall);
 S.RegisterDelphiFunction(@OpenMutex, 'wOpenMutex', CdStdCall);
 S.RegisterDelphiFunction(@OpenSemaphore, 'wOpenSemaphore', CdStdCall);
 S.RegisterDelphiFunction(@OpenWaitableTimer, 'wOpenWaitableTimer', CdStdCall);
 S.RegisterDelphiFunction(@OutputDebugString, 'wOutputDebugString', CdStdCall);
 S.RegisterDelphiFunction(@PeekConsoleInput, 'wPeekConsoleInput', CdStdCall);
 S.RegisterDelphiFunction(@QueryDosDevice, 'wQueryDosDevice', CdStdCall);
 //S.RegisterDelphiFunction(@QueryRecoveryAgents, 'wQueryRecoveryAgents', CdStdCall); !!
 S.RegisterDelphiFunction(@RemoveDirectory, 'wRemoveDirectory', CdStdCall);
 S.RegisterDelphiFunction(@ScrollConsoleScreenBuffer, 'wScrollConsoleScreenBuffer', CdStdCall);
 S.RegisterDelphiFunction(@SearchPath, 'wSearchPath', CdStdCall);
 S.RegisterDelphiFunction(@SetComputerName, 'wSetComputerName', CdStdCall);
 S.RegisterDelphiFunction(@SetConsoleTitle, 'wSetConsoleTitle', CdStdCall);
 S.RegisterDelphiFunction(@SetConsoleTitle, 'SetConsoleTitle', CdStdCall);
 S.RegisterDelphiFunction(@SetCurrentDirectory, 'wSetCurrentDirectory', CdStdCall);
 S.RegisterDelphiFunction(@SetDefaultCommConfig, 'wSetDefaultCommConfig', CdStdCall);
 //S.RegisterDelphiFunction(@SetEnvironmentVariable, 'wSetEnvironmentVariable', CdStdCall);
 S.RegisterDelphiFunction(@SetFileAttributes, 'wSetFileAttributes', CdStdCall);
 S.RegisterDelphiFunction(@SetLocaleInfo, 'wSetLocaleInfo', CdStdCall);
 S.RegisterDelphiFunction(@SetVolumeLabel, 'wSetVolumeLabel', CdStdCall);
 S.RegisterDelphiFunction(@UpdateResource, 'wUpdateResource', CdStdCall);
 S.RegisterDelphiFunction(@VerLanguageName, 'wVerLanguageName', CdStdCall);
 S.RegisterDelphiFunction(@WaitNamedPipe, 'wWaitNamedPipe', CdStdCall);
 S.RegisterDelphiFunction(@WriteProfileSection, 'wWriteProfileSection', CdStdCall);
 S.RegisterDelphiFunction(@WriteProfileString, 'wWriteProfileString', CdStdCall);
 S.RegisterDelphiFunction(@lstrcat, 'wlstrcat', CdStdCall);
 S.RegisterDelphiFunction(@lstrcmp, 'wlstrcmp', CdStdCall);
 S.RegisterDelphiFunction(@lstrcmpi, 'wlstrcmpi', CdStdCall);
 S.RegisterDelphiFunction(@lstrcpy, 'wlstrcpy', CdStdCall);
 S.RegisterDelphiFunction(@lstrcpyn, 'wlstrcpyn', CdStdCall);
 S.RegisterDelphiFunction(@lstrlen, 'wlstrlen', CdStdCall);
 S.RegisterDelphiFunction(@MultinetGetConnectionPerformance, 'wMultinetGetConnectionPerformance', CdStdCall);
 S.RegisterDelphiFunction(@WNetGetUniversalName, 'wWNetGetUniversalName', CdStdCall);
 S.RegisterDelphiFunction(@WNetGetUser, 'wWNetGetUser', CdStdCall);
 S.RegisterDelphiFunction(@WNetOpenEnum, 'wWNetOpenEnum', CdStdCall);
 S.RegisterDelphiFunction(@WNetAddConnection, 'wWNAddConnection', CdStdCall);
 S.RegisterDelphiFunction(@WNetUseConnection, 'wWNetUseConnection', CdStdCall);
 S.RegisterDelphiFunction(@GetFileVersionInfo, 'wGetFileVersionInfo', CdStdCall);
 S.RegisterDelphiFunction(@GetFileVersionInfoSize, 'wGetFileVersionInfoSize', CdStdCall);
 S.RegisterDelphiFunction(@VerFindFile, 'wVerFindFile', CdStdCall);
 S.RegisterDelphiFunction(@VerInstallFile, 'wVerInstallFile', CdStdCall);
 S.RegisterDelphiFunction(@VerQueryValue, 'wVerQueryValue', CdStdCall);  
 S.RegisterDelphiFunction(@GetPrivateProfileStruct, 'wGetPrivateProfileStruct', CdStdCall);
 S.RegisterDelphiFunction(@WritePrivateProfileStruct, 'wWritePrivateProfileStruct', CdStdCall);
 S.RegisterDelphiFunction(@AddFontResource, 'wAddFontResource', CdStdCall);
 S.RegisterDelphiFunction(@AddFontResourceEx, 'wAddFontResourceEx', CdStdCall);
 S.RegisterDelphiFunction(@CopyEnhMetaFile, 'wCopyEnhMetaFile', CdStdCall);
 S.RegisterDelphiFunction(@CopyMetaFile, 'wCopyMetaFile', CdStdCall);
 S.RegisterDelphiFunction(@CreateColorSpace, 'wCreateColorSpace', CdStdCall);
 S.RegisterDelphiFunction(@CreateDC, 'wCreateDC', CdStdCall);
 S.RegisterDelphiFunction(@CreateEnhMetaFile, 'wCreateEnhMetaFile', CdStdCall);
 S.RegisterDelphiFunction(@CreateFont, 'wCreateFont', CdStdCall);
 S.RegisterDelphiFunction(@CreateFontIndirect, 'wCreateFontIndirect', CdStdCall);
 S.RegisterDelphiFunction(@CreateFontIndirectEx, 'wCreateFontIndirectEx', CdStdCall);
 S.RegisterDelphiFunction(@CreateIC, 'wCreateIC', CdStdCall);
 S.RegisterDelphiFunction(@CreateMetaFile, 'wCreateMetaFile', CdStdCall);
 S.RegisterDelphiFunction(@CreateScalableFontResource, 'wCreateScalableFontResource', CdStdCall);
 //S.RegisterDelphiFunction(@DeviceCapabilities, 'wDeviceCapabilities', CdStdCall); !!
 S.RegisterDelphiFunction(@ExtTextOut, 'wExtTextOut', CdStdCall);
 S.RegisterDelphiFunction(@GetEnhMetaFile, 'wGetEnhMetaFile', CdStdCall);
 S.RegisterDelphiFunction(@GetEnhMetaFileDescription, 'wGetEnhMetaFileDescription', CdStdCall);
 S.RegisterDelphiFunction(@GetGlyphIndices, 'wGetGlyphIndices', CdStdCall);
 S.RegisterDelphiFunction(@GetGlyphOutline, 'wGetGlyphOutline', CdStdCall);
 S.RegisterDelphiFunction(@GetICMProfile, 'wGetICMProfile', CdStdCall);
 S.RegisterDelphiFunction(@GetLogColorSpace, 'wGetLogColorSpace', CdStdCall);
 S.RegisterDelphiFunction(@GetMetaFile, 'wGetMetaFile', CdStdCall);
 S.RegisterDelphiFunction(@GetObject, 'wGetObject', CdStdCall);
 S.RegisterDelphiFunction(@GetOutlineTextMetrics, 'wGetOutlineTextMetrics', CdStdCall);
 S.RegisterDelphiFunction(@GetTextExtentExPoint, 'wGetTextExtentExPoint', CdStdCall);
 S.RegisterDelphiFunction(@GetTextExtentPoint32, 'wGetTextExtentPoint32', CdStdCall);
 S.RegisterDelphiFunction(@GetTextExtentPoint, 'wGetTextExtentPoint', CdStdCall);
 S.RegisterDelphiFunction(@GetTextFace, 'wGetTextFace', CdStdCall);
 S.RegisterDelphiFunction(@GetTextMetrics, 'wGetTextMetrics', CdStdCall);
 S.RegisterDelphiFunction(@PolyTextOut, 'wPolyTextOut', CdStdCall);
 S.RegisterDelphiFunction(@RemoveFontResource, 'wRemoveFontResource', CdStdCall);
 S.RegisterDelphiFunction(@RemoveFontResourceEx, 'wRemoveFontResourceEx', CdStdCall);
 S.RegisterDelphiFunction(@ResetDC, 'wResetDC', CdStdCall);
 S.RegisterDelphiFunction(@SetICMProfile, 'wSetICMProfile', CdStdCall);
 S.RegisterDelphiFunction(@StartDoc, 'wStartDoc', CdStdCall);
 S.RegisterDelphiFunction(@TextOut, 'wTextOut', CdStdCall);
 S.RegisterDelphiFunction(@UpdateICMRegKey, 'wUpdateICMRegKey', CdStdCall);
 S.RegisterDelphiFunction(@wglUseFontBitmaps, 'wwglUseFontBitmaps', CdStdCall);
 S.RegisterDelphiFunction(@wglUseFontOutlines, 'wwglUseFontOutlines', CdStdCall);
 S.RegisterDelphiFunction(@AnsiNext, 'wAnsiNext', CdStdCall);
 S.RegisterDelphiFunction(@AnsiPrev, 'wAnsiPrev', CdStdCall);
 S.RegisterDelphiFunction(@AppendMenu, 'wAppendMenu', CdStdCall);
 S.RegisterDelphiFunction(@CallMsgFilter, 'wCallMsgFilter', CdStdCall);
 S.RegisterDelphiFunction(@CallWindowProc, 'wCallWindowProc', CdStdCall);
 S.RegisterDelphiFunction(@ChangeDisplaySettings, 'wChangeDisplaySettings', CdStdCall);
 S.RegisterDelphiFunction(@ChangeDisplaySettingsEx, 'wChangeDisplaySettingsEx', CdStdCall);
 S.RegisterDelphiFunction(@ChangeMenu, 'wChangeMenu', CdStdCall);
 S.RegisterDelphiFunction(@ChartoOEM, 'wChartoOEM', CdStdCall);
 S.RegisterDelphiFunction(@ChartoOEMBuff, 'wCharToOemBuff', CdStdCall);
 S.RegisterDelphiFunction(@ChartoOEM, 'ChartoOEM2', CdStdCall);

 //wCharToOemBuff
 S.RegisterDelphiFunction(@CharLower, 'wCharLower', CdStdCall);
 S.RegisterDelphiFunction(@CharLowerBuff, 'wCharLowerBuff', CdStdCall);
 S.RegisterDelphiFunction(@CharNext, 'wCharNext', CdStdCall);
 S.RegisterDelphiFunction(@CharPrev, 'wCharPrev', CdStdCall);
 S.RegisterDelphiFunction(@CharUpper, 'wCharUpper', CdStdCall);
 S.RegisterDelphiFunction(@CharUpperBuff, 'wCharUpperBuff', CdStdCall);
 S.RegisterDelphiFunction(@CopyAcceleratorTable, 'wCopyAcceleratorTable', CdStdCall);
 S.RegisterDelphiFunction(@CreateAcceleratorTable, 'wCreateAcceleratorTable', CdStdCall);
 S.RegisterDelphiFunction(@CreateDesktop, 'wCreateDesktop', CdStdCall);
 S.RegisterDelphiFunction(@CreateDialogIndirectParam, 'wCreateDialogIndirectParam', CdStdCall);
 S.RegisterDelphiFunction(@CreateDialogParam, 'wCreateDialogParam', CdStdCall);
 S.RegisterDelphiFunction(@CreateMDIWindow, 'wCreateMDIWindow', CdStdCall);
 S.RegisterDelphiFunction(@CreateWindowEx, 'wCreateWindowEx', CdStdCall);
 S.RegisterDelphiFunction(@CreateWindowStation, 'wCreateWindowStation', CdStdCall);
 S.RegisterDelphiFunction(@DefDlgProc, 'wDefDlgProc', CdStdCall);
 S.RegisterDelphiFunction(@DefFrameProc, 'wDefFrameProc', CdStdCall);
 S.RegisterDelphiFunction(@DefMDIChildProc, 'wDefMDIChildProc', CdStdCall);
 S.RegisterDelphiFunction(@DefWindowProc, 'wDefWindowProc', CdStdCall);
 S.RegisterDelphiFunction(@DialogBoxIndirectParam, 'wDialogBoxIndirectParam', CdStdCall);
 S.RegisterDelphiFunction(@DialogBoxParam, 'wDialogBoxParam', CdStdCall);
 S.RegisterDelphiFunction(@DispatchMessage, 'wDispatchMessage', CdStdCall);
 S.RegisterDelphiFunction(@DlgDirList, 'wDlgDirList', CdStdCall);
 S.RegisterDelphiFunction(@DlgDirListComboBox, 'wDlgDirListComboBox', CdStdCall);
 S.RegisterDelphiFunction(@DlgDirSelectComboBoxEx, 'wDlgDirSelectComboBoxEx', CdStdCall);
 S.RegisterDelphiFunction(@DlgDirSelectEx, 'wDlgDirSelectEx', CdStdCall);
 S.RegisterDelphiFunction(@DrawState, 'wDrawState', CdStdCall);
 S.RegisterDelphiFunction(@DrawText, 'wDrawText', CdStdCall);
 S.RegisterDelphiFunction(@FindWindow, 'wFindWindow', CdStdCall);
 S.RegisterDelphiFunction(@GetAltTabInfo, 'wGetAltTabInfo', CdStdCall);
 S.RegisterDelphiFunction(@GetClassInfo, 'wGetClassInfo', CdStdCall);
 S.RegisterDelphiFunction(@GetClassLong, 'wGetClassLong', CdStdCall);
 S.RegisterDelphiFunction(@GetClassName, 'wGetClassName', CdStdCall);
 S.RegisterDelphiFunction(@GetClipboardFormatName, 'wGetClipboardFormatName', CdStdCall);
 S.RegisterDelphiFunction(@GetDlgItemText, 'wGetDlgItemText', CdStdCall);
 S.RegisterDelphiFunction(@GetKeyNameText, 'wGetKeyNameText', CdStdCall);
 S.RegisterDelphiFunction(@GetKeyboardLayoutName, 'wGetKeyboardLayoutName', CdStdCall);
 S.RegisterDelphiFunction(@GetMenuItemInfo, 'wGetMenuItemInfo', CdStdCall);
 S.RegisterDelphiFunction(@GetMenuString, 'wGetMenuString', CdStdCall);
 S.RegisterDelphiFunction(@GetMessage, 'wGetMessage', CdStdCall);
 S.RegisterDelphiFunction(@GetProp, 'wGetProp', CdStdCall);
 S.RegisterDelphiFunction(@GetTabbedTextExtent, 'wGetTabbedTextExtent', CdStdCall);
 S.RegisterDelphiFunction(@GetUserObjectInformation, 'wGetUserObjectInformation', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowLong, 'wGetWindowLong', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowModuleFileName, 'wGetWindowModuleFileName', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowText, 'wGetWindowText', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowTextLength, 'wGetWindowTextLength', CdStdCall);
 S.RegisterDelphiFunction(@GrayString, 'wGrayString', CdStdCall);
 S.RegisterDelphiFunction(@InsertMenu, 'wInsertMenu', CdStdCall);
 S.RegisterDelphiFunction(@InsertMenuItem, 'wInsertMenuItem', CdStdCall);
 S.RegisterDelphiFunction(@IsCharAlpha, 'wIsCharAlpha', CdStdCall);
 S.RegisterDelphiFunction(@IsCharAlphaNumeric, 'wIsCharAlphaNumeric', CdStdCall);
 S.RegisterDelphiFunction(@IsCharLower, 'wIsCharLower', CdStdCall);
 S.RegisterDelphiFunction(@IsCharUpper, 'wIsCharUpper', CdStdCall);
 S.RegisterDelphiFunction(@IsDialogMessage, 'wIsDialogMessage', CdStdCall);
 S.RegisterDelphiFunction(@LoadAccelerators, 'wLoadAccelerators', CdStdCall);
 S.RegisterDelphiFunction(@LoadBitmap, 'wLoadBitmap', CdStdCall);
 S.RegisterDelphiFunction(@LoadCursor, 'wLoadCursor', CdStdCall);
 S.RegisterDelphiFunction(@LoadCursorFromFile, 'wLoadCursorFromFile', CdStdCall);
 S.RegisterDelphiFunction(@LoadIcon, 'wLoadIcon', CdStdCall);
 S.RegisterDelphiFunction(@LoadImage, 'wLoadImage', CdStdCall);
 S.RegisterDelphiFunction(@LoadKeyboardLayout, 'wLoadKeyboardLayout', CdStdCall);
 S.RegisterDelphiFunction(@LoadMenu, 'wLoadMenu', CdStdCall);
 S.RegisterDelphiFunction(@LoadMenuIndirect, 'wLoadMenuIndirect', CdStdCall);
 S.RegisterDelphiFunction(@LoadString, 'wLoadString', CdStdCall);
 S.RegisterDelphiFunction(@MapVirtualKey, 'wMapVirtualKey', CdStdCall);
 S.RegisterDelphiFunction(@MapVirtualKeyEx, 'wMapVirtualKeyEx', CdStdCall);
 //S.RegisterDelphiFunction(@MessageBox, 'wMessageBox', CdStdCall);
 S.RegisterDelphiFunction(@CloseWindowStation, 'CloseWindowStation', CdStdCall);
 S.RegisterDelphiFunction(@SetProcessWindowStation, 'SetProcessWindowStation', CdStdCall);
 S.RegisterDelphiFunction(@GetProcessWindowStation, 'GetProcessWindowStation', CdStdCall);
 S.RegisterDelphiFunction(@EnumWindows, 'EnumWindows', CdStdCall);
 S.RegisterDelphiFunction(@EnumWindowsProc2, 'EnumWindowsProc2', CdStdCall);

 S.RegisterDelphiFunction(@ModifyMenu, 'wModifyMenu', CdStdCall);
 S.RegisterDelphiFunction(@OpenDesktop, 'wOpenDesktop', CdStdCall);
 S.RegisterDelphiFunction(@OpenWindowStation, 'wOpenWindowStation', CdStdCall);
 S.RegisterDelphiFunction(@PeekMessage, 'wPeekMessage', CdStdCall);
 S.RegisterDelphiFunction(@PostMessage, 'wPostMessage', CdStdCall);
 S.RegisterDelphiFunction(@PostThreadMessage, 'wPostThreadMessage', CdStdCall);
 S.RegisterDelphiFunction(@RealGetWindowClass, 'wRealGetWindowClass', CdStdCall);
 S.RegisterDelphiFunction(@SendDlgItemMessage, 'wSendDlgItemMessage', CdStdCall);
 S.RegisterDelphiFunction(@SendMessage, 'wSendMessage', CdStdCall);
 S.RegisterDelphiFunction(@SendMessageTimeout, 'wSendMessageTimeout', CdStdCall);
 S.RegisterDelphiFunction(@SendNotifyMessage, 'wSendNotifyMessage', CdStdCall);
 S.RegisterDelphiFunction(@SetClassLong, 'wSetClassLong', CdStdCall);
 S.RegisterDelphiFunction(@SetDlgItemText, 'wSetDlgItemText', CdStdCall);
 S.RegisterDelphiFunction(@SetMenuItemInfo, 'wSetMenuItemInfo', CdStdCall);
 S.RegisterDelphiFunction(@SetProp, 'wSetProp', CdStdCall);
 S.RegisterDelphiFunction(@SetUserObjectInformation, 'wSetUserObjectInformation', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowLong, 'wSetWindowLong', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowText, 'wSetWindowText', CdStdCall);
 S.RegisterDelphiFunction(@SystemParametersInfo, 'wSystemParametersInfo', CdStdCall);
 S.RegisterDelphiFunction(@TabbedTextOut, 'wTabbedTextOut', CdStdCall);
 S.RegisterDelphiFunction(@TranslateAccelerator, 'wTranslateAccelerator', CdStdCall);
 S.RegisterDelphiFunction(@UnregisterClass, 'wUnregisterClass', CdStdCall);
 S.RegisterDelphiFunction(@VkKeyScan, 'wVkKeyScan', CdStdCall);
 S.RegisterDelphiFunction(@VkKeyScanEx, 'wVkKeyScanEx', CdStdCall);
 S.RegisterDelphiFunction(@WinHelp, 'wWinHelp', CdStdCall);
 S.RegisterDelphiFunction(@wsprintf, 'wwsprintf', CdStdCall);
 S.RegisterDelphiFunction(@wvsprintf, 'wwvsprintf', CdStdCall);
 S.RegisterDelphiFunction(@GetBinaryType, 'GetBinaryType', CdStdCall);
 //S.RegisterDelphiFunction(@GetBinaryTypeA, 'GetBinaryTypeA', CdStdCall);
 //S.RegisterDelphiFunction(@GetBinaryTypeW, 'GetBinaryTypeW', CdStdCall);
 S.RegisterDelphiFunction(@GetShortPathName, 'wGetShortPathName', CdStdCall);
 //S.RegisterDelphiFunction(@GetShortPathNameA, 'GetShortPathNameA', CdStdCall);
 //S.RegisterDelphiFunction(@GetShortPathNameW, 'GetShortPathNameW', CdStdCall);
 S.RegisterDelphiFunction(@GetProcessAffinityMask, 'GetProcessAffinityMask', CdStdCall);
 S.RegisterDelphiFunction(@SetProcessAffinityMask, 'SetProcessAffinityMask', CdStdCall);
 S.RegisterDelphiFunction(@GetProcessTimes, 'GetProcessTimes', CdStdCall);
 S.RegisterDelphiFunction(@GetProcessWorkingSetSize, 'GetProcessWorkingSetSize', CdStdCall);
 S.RegisterDelphiFunction(@SetProcessWorkingSetSize, 'SetProcessWorkingSetSize', CdStdCall);
 S.RegisterDelphiFunction(@OpenProcess, 'OpenProcess', CdStdCall);
 S.RegisterDelphiFunction(@GetCurrentProcess, 'GetCurrentProcess', CdStdCall);
 S.RegisterDelphiFunction(@GetCurrentProcessId, 'wGetCurrentProcessId', CdStdCall);
 S.RegisterDelphiFunction(@ExitProcess, 'ExitProcess', CdStdCall);
 S.RegisterDelphiFunction(@TerminateProcess, 'TerminateProcess', CdStdCall);
 S.RegisterDelphiFunction(@GetExitCodeProcess, 'GetExitCodeProcess', CdStdCall);
 S.RegisterDelphiFunction(@FatalExit, 'FatalExit', CdStdCall);
  S.RegisterDelphiFunction(@LoadResource, 'wLoadResource', CdStdCall);
 S.RegisterDelphiFunction(@SizeofResource, 'wSizeofResource', CdStdCall);
 S.RegisterDelphiFunction(@GlobalDeleteAtom, 'GlobalDeleteAtom', CdStdCall);
 S.RegisterDelphiFunction(@InitAtomTable, 'InitAtomTable', CdStdCall);
 S.RegisterDelphiFunction(@DeleteAtom, 'DeleteAtom', CdStdCall);
 S.RegisterDelphiFunction(@SetHandleCount, 'SetHandleCount', CdStdCall);
 S.RegisterDelphiFunction(@GetLogicalDrives, 'GetLogicalDrives', CdStdCall);
 S.RegisterDelphiFunction(@LockFile, 'LockFile', CdStdCall);
 S.RegisterDelphiFunction(@UnlockFile, 'UnlockFile', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowsHook, 'SetWindowsHook', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowsHookA, 'SetWindowsHookA', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowsHookW, 'SetWindowsHookW', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowsHookEx, 'SetWindowsHookEx', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowsHookExA, 'SetWindowsHookExA', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowsHookExW, 'SetWindowsHookExW', CdStdCall);
 S.RegisterDelphiFunction(@UnhookWindowsHook, 'UnhookWindowsHook', CdStdCall);
 S.RegisterDelphiFunction(@UnhookWindowsHookEx, 'UnhookWindowsHookEx', CdStdCall);
 S.RegisterDelphiFunction(@CallNextHookEx, 'CallNextHookEx', CdStdCall);
 S.RegisterDelphiFunction(@DefHookProc, 'DefHookProc', cdRegister);
 S.RegisterDelphiFunction(@SetTimer, 'SetTimer', CdStdCall);
 S.RegisterDelphiFunction(@SetTimer, 'SetTimer2', CdStdCall);
 S.RegisterDelphiFunction(@KillTimer, 'KillTimer', CdStdCall);
 S.RegisterDelphiFunction(@IsWindowUnicode, 'wIsWindowUnicode', CdStdCall);
 S.RegisterDelphiFunction(@EnableWindow, 'wEnableWindow', CdStdCall);
 S.RegisterDelphiFunction(@IsWindowEnabled, 'wIsWindowEnabled', CdStdCall);
 S.RegisterDelphiFunction(@GetMenu, 'GetMenu', CdStdCall);
 S.RegisterDelphiFunction(@SetMenu, 'SetMenu', CdStdCall);
 S.RegisterDelphiFunction(@GetClassName, 'GetClassName', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowTask, 'GetWindowTask', cdRegister);
 S.RegisterDelphiFunction(@GetLastActivePopup, 'GetLastActivePopup', CdStdCall);
 S.RegisterDelphiFunction(@GetMDACVersion2, 'GetMDACVersion2', cdRegister);
  S.RegisterDelphiFunction(@RegisterWindowMessage, 'RegisterWindowMessage', CdStdCall);
  S.RegisterDelphiFunction(@PostThreadMessage, 'PostThreadMessage', CdStdCall);
  S.RegisterDelphiFunction(@PostAppMessage, 'PostAppMessage', CdStdCall);
  S.RegisterDelphiFunction(@AttachThreadInput, 'AttachThreadInput', CdStdCall);
  S.RegisterDelphiFunction(@ReplyMessage, 'ReplyMessage', CdStdCall);
//  S.RegisterDelphiFunction(@GlobalDiscard, 'GlobalDiscard', cdRegister);
// S.RegisterDelphiFunction(@LocalDiscard, 'LocalDiscard', cdRegister);
  S.RegisterDelphiFunction(@LoadKeyboardLayout, 'LoadKeyboardLayout', CdStdCall);
 S.RegisterDelphiFunction(@ActivateKeyboardLayout, 'ActivateKeyboardLayout', CdStdCall);
 S.RegisterDelphiFunction(@UnloadKeyboardLayout, 'UnloadKeyboardLayout', CdStdCall);
 S.RegisterDelphiFunction(@GetKeyboardLayoutName, 'GetKeyboardLayoutName', CdStdCall);
 S.RegisterDelphiFunction(@GetKeyboardLayoutList, 'GetKeyboardLayoutList', CdStdCall);
 S.RegisterDelphiFunction(@GetKeyboardLayout, 'GetKeyboardLayout', CdStdCall);
//S.RegisterDelphiFunction(@GetMouseMovePoints, 'GetMouseMovePoints', CdStdCall); !!!}
 S.RegisterDelphiFunction(@CreateWindowStation, 'CreateWindowStation', CdStdCall);
 S.RegisterDelphiFunction(@OpenWindowStation, 'OpenWindowStation', CdStdCall);
 S.RegisterDelphiFunction(@CloseWindowStation, 'CloseWindowStation', CdStdCall);
 S.RegisterDelphiFunction(@SetProcessWindowStation, 'SetProcessWindowStation', CdStdCall);
 S.RegisterDelphiFunction(@GetProcessWindowStation, 'GetProcessWindowStation', CdStdCall);
 S.RegisterDelphiFunction(@ComposeDateTime, 'ComposeDateTime', cdRegister);
 S.RegisterDelphiFunction(@FullTimeToStr, 'FullTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@GetBaseAddress, 'GetBaseAddress', cdRegister);
 S.RegisterDelphiFunction(@FormAnimation, 'FormAnimation', cdRegister);

 S.RegisterDelphiFunction(@GetMorseID, 'GetMorseID', cdRegister);
 S.RegisterDelphiFunction(@GetMorseString2, 'GetMorseString2', cdRegister);
 S.RegisterDelphiFunction(@GetMorseLine, 'GetMorseLine', cdRegister);
 S.RegisterDelphiFunction(@GetMorseLine, 'GetMorseTable', cdRegister);
 S.RegisterDelphiFunction(@GetMorseSign, 'GetMorseSign', cdRegister);
 S.RegisterDelphiFunction(@WaitTilClose, 'WaitTilClose', cdRegister);
 S.RegisterDelphiFunction(@DoUserMsgs, 'DoUserMsgs', cdRegister);
 S.RegisterDelphiFunction(@MsgFunc, 'MsgFunc', cdRegister);
 S.RegisterDelphiFunction(@ShowMsg, 'ShowMsg', cdRegister);
 S.RegisterDelphiFunction(@DeleteMsgForm, 'DeleteMsgForm', cdRegister);
 S.RegisterDelphiFunction(@DisableForms, 'DisableForms', cdRegister);
 S.RegisterDelphiFunction(@FoundTopLevel, 'FoundTopLevel', cdRegister);
 S.RegisterDelphiFunction(@CheckCom, 'CheckCom', cdRegister);
 S.RegisterDelphiFunction(@CheckLPT1, 'CheckLPT1', cdRegister);
 S.RegisterDelphiFunction(@GetScreenShot, 'GetScreenShot', cdRegister);
 S.RegisterDelphiFunction(@LoadFile, 'LoadFile', cdRegister);
 S.RegisterDelphiFunction(@TRestRequest_createStringStreamFromStringList, 'TRestRequest_createStringStreamFromStringList', cdRegister);
 S.RegisterDelphiFunction(@ComponentToStringProc, 'ComponentToStringProc', cdRegister);
 S.RegisterDelphiFunction(@StringToComponentProc, 'StringToComponentProc', cdRegister);
 S.RegisterDelphiFunction(@MyCopyFile, 'MyCopyFile', cdRegister);
 S.RegisterDelphiFunction(@ComPortSelect, 'ComPortSelect', cdRegister);
 S.RegisterDelphiFunction(@LinesCount, 'LinesCount', cdRegister);
 S.RegisterDelphiFunction(@TextFileLineCount, 'TextFileLineCount', cdRegister);
 S.RegisterDelphiFunction(@GetLinesCount, 'GetLinesCount', cdRegister);

 S.RegisterDelphiFunction(@GetDeviceCaps, 'GetDeviceCaps', CdStdCall);
 //S.RegisterDelphiFunction(@GetGraphicsMode, 'GetGraphicsMode', CdStdCall);
 S.RegisterDelphiFunction(@GetMapMode, 'GetMapMode', CdStdCall);
 //S.RegisterDelphiFunction(@GetMetaFile, 'GetMetaFile', CdStdCall);
 S.RegisterDelphiFunction(@GetNearestColor, 'GetNearestColor', CdStdCall);
 S.RegisterDelphiFunction(@GetNearestPaletteIndex, 'GetNearestPaletteIndex', CdStdCall);
 S.RegisterDelphiFunction(@GetObjectType, 'GetObjectType', CdStdCall);
 S.RegisterDelphiFunction(@GetOutlineTextMetrics, 'GetOutlineTextMetrics', CdStdCall);
 S.RegisterDelphiFunction(@GetPixel, 'GetPixel', CdStdCall);
 S.RegisterDelphiFunction(@GetPixelFormat, 'GetPixelFormat', CdStdCall);
 S.RegisterDelphiFunction(@GetPolyFillMode, 'GetPolyFillMode', CdStdCall);
 S.RegisterDelphiFunction(@GetRasterizerCaps, 'GetRasterizerCaps', CdStdCall);
 S.RegisterDelphiFunction(@GetRegionData, 'GetRegionData', CdStdCall);
 S.RegisterDelphiFunction(@GetRgnBox, 'GetRgnBox', CdStdCall);
 S.RegisterDelphiFunction(@GetStockObject, 'GetStockObject', CdStdCall);
 S.RegisterDelphiFunction(@GetStretchBltMode, 'GetStretchBltMode', CdStdCall);
 S.RegisterDelphiFunction(@GetSystemPaletteUse, 'GetSystemPaletteUse', CdStdCall);
 S.RegisterDelphiFunction(@GetTextCharacterExtra, 'GetTextCharacterExtra', CdStdCall);
 S.RegisterDelphiFunction(@GetTextAlign, 'GetTextAlign', CdStdCall);
 S.RegisterDelphiFunction(@GetTextColor, 'GetTextColor', CdStdCall);
 S.RegisterDelphiFunction(@GetCurrentObject, 'GetCurrentObject', CdStdCall);
 S.RegisterDelphiFunction(@GetSystemDefaultLangID, 'GetSystemDefaultLangID', CdStdCall);
 S.RegisterDelphiFunction(@GetUserDefaultLangID, 'GetUserDefaultLangID', CdStdCall);
 S.RegisterDelphiFunction(@UpdateExeResource, 'UpdateExeResource', cdRegister);
 S.RegisterDelphiFunction(@VarClear2, 'VarClear', cdRegister);
 S.RegisterDelphiFunction(@DynamicDllCallName, 'DynamicDllCallName', cdRegister);
 S.RegisterDelphiFunction(@DynamicDllCall, 'DynamicDllCall', cdRegister);
 S.RegisterDelphiFunction(@DynamicDllCallNameS, 'DynamicDllCallNames', cdRegister);
 S.RegisterDelphiFunction(@LV_InsertFiles, 'LV_InsertFiles', cdRegister);
 S.RegisterDelphiFunction(@CreateBrowserOnForm, 'CreateBrowserOnForm', cdRegister);
 S.RegisterDelphiFunction(@CreateBrowserOnForm, 'WebOnForm', cdRegister);
 S.RegisterDelphiFunction(@CreateBrowserOnForm, 'WebtoForm', cdRegister);

 S.RegisterDelphiFunction(@SearchAndHighlightWebText, 'SearchAndHighlightWebText', cdRegister);
 S.RegisterDelphiFunction(@SaveImagesOnWeb, 'SaveImagesOnWeb', cdRegister);
 S.RegisterDelphiFunction(@GetProcessNameFromWnd, 'GetProcessNameFromWnd', cdRegister);
 //S.RegisterDelphiFunction(@getallEvents, 'getallEvents', cdRegister);

 S.RegisterDelphiFunction(@RunAsAdmin, 'RunAsAdmin', cdRegister);

   S.RegisterDelphiFunction(@WNetConnectionDialog, 'WNetConnectionDialog', CdStdCall);
 S.RegisterDelphiFunction(@WNetDisconnectDialog, 'WNetDisconnectDialog', CdStdCall);
 S.RegisterDelphiFunction(@WNetGetUser, 'WNetGetUser', CdStdCall);
 S.RegisterDelphiFunction(@WNetGetProviderName, 'WNetGetProviderName', CdStdCall);
  S.RegisterDelphiFunction(@WNetGetNetworkInformation, 'WNetGetNetworkInformation', CdStdCall);
 S.RegisterDelphiFunction(@WNetGetLastError, 'WNetGetLastError', CdStdCall);
S.RegisterDelphiFunction(@WNetGetUniversalName, 'WNetGetUniversalName', CdStdCall);
  S.RegisterDelphiFunction(@WNetCancelConnection, 'WNetCancelConnection', CdStdCall);
 S.RegisterDelphiFunction(@WNetCancelConnection2, 'WNetCancelConnection2', CdStdCall);
   S.RegisterDelphiFunction(@SetSystemCursor, 'SetSystemCursor', CdStdCall);
 S.RegisterDelphiFunction(@LoadIcon, 'LoadIcon', CdStdCall);
 S.RegisterDelphiFunction(@DestroyIcon, 'DestroyIcon', CdStdCall);
 S.RegisterDelphiFunction(@WNetCloseEnum, 'WNetCloseEnum', CdStdCall);
 S.RegisterDelphiFunction(@FillRect, 'wFillRect', CdStdCall);
 S.RegisterDelphiFunction(@FrameRect, 'wFrameRect', CdStdCall);

 S.RegisterDelphiFunction(@ModifyFontsFor, 'ModifyFontsFor', cdRegister);
 S.RegisterDelphiFunction(@GetAccessTimeOut, 'GetAccessTimeOut', cdRegister);
 S.RegisterDelphiFunction(@GetParentProcessName, 'GetParentProcessName', cdRegister);

  end;


 { TPSImport_AfUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AfUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_AfUtils(ri);
  RIRegister_AfUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
