unit MSysUtils;

interface

uses
  Windows, Messages, CommCtrl, ShellApi, ShlObj;

procedure HideTaskBarButton(hWindow : HWND);
function LoadStr(ID : Integer) : String;
function Format(fmt : String; params : array of const) : String;
function FileExists(const FileName : String) : Boolean;
function IntToStr(Int : Int64) : String;
function StrPas(const Str : PChar) : String;
function RenameFile(const OldName, NewName : String) : Boolean;
function CutFileName(s : String) : String;
function GetVersionInfo(var VersionString : String) : DWORD;
function FormatTime(t : Cardinal) : String;
function CreateDir(const Dir : string) : Boolean;
function SetAutoRun(NeedAutoRun : Boolean; AppName : String) : Boolean;
function SetTreeViewStyle(const hTV : HWND; dwNewStyle : dword) : DWORD;
function StrLen(Str : PChar) : Integer;
function DirectoryExists(const Directory : String) : Boolean;
function GetFolder(hWnd : hWnd; RootDir : Integer; Caption : String) : String;
function SetBlendWindow(hWnd : HWND; AlphaBlend : Byte) : LongBool;
function EditWindowProc(hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT; stdcall;
procedure SetEditWndProc(hWnd : HWND; ptr : Pointer);
function GetTextFromFile(Filename : String) : string;
function IsTopMost(hWnd : HWND) : Bool;
function StrToIntDef(const s : String; const i : Integer) : Integer;
function StrToInt(s : String) : Integer;
function GetItemText(hDlg : THandle; ID : DWORD) : String;

type
  TSetLayeredWindowAttributes = function (hWnd : THandle; crKey : COLORREF; bAlpha : Byte; dwFlags : DWORD) : Boolean; stdcall;

const
  LWA_ALPHA = $00000002;

implementation

procedure HideTaskBarButton(hWindow : HWND);
var
  wndTemp : HWND;
begin
  wndTemp := CreateWindow('STATIC', #0, WS_POPUP, 0, 0, 0, 0, 0, 0, 0, nil);
  ShowWindow(hWindow, SW_HIDE);
  SetWindowLong(hWindow, GWL_HWNDPARENT, wndTemp);
  ShowWindow(hWindow, SW_SHOW);
end;

function LoadStr(ID : Integer) : String;
var
  buffer : array[0..255] of Char;
begin
  LoadString(hInstance, ID, buffer, SizeOf(buffer));
  Result := String(buffer);
end;

function Format(fmt : String; params : array of const) : String;
var
  pdw1, pdw2 : PDWORD;
  i : integer;
  pc : PChar;
begin
  pdw1 := nil;
  if length(params) > 0 then GetMem(pdw1, length(params) * sizeof(Pointer));
  pdw2 := pdw1;
  for i := 0 to high(params) do
  begin
    pdw2^ := DWORD(PDWORD(@params[i])^);
    inc(pdw2);
  end;
  GetMem(pc, 1024 - 1);
  try
    SetString(Result, pc, wvsprintf(pc, PCHAR(fmt), PCHAR(pdw1)));
  except
    Result := #0;
  end;
  if (pdw1 <> nil) then FreeMem(pdw1);
  if (pc <> nil) then FreeMem(pc);
end;

function FileExists(const FileName : String) : Boolean;
var
  Attr : Cardinal;
begin
  Attr := GetFileAttributes(Pointer(Filename));
  Result := (Attr <> $FFFFFFFF) and (Attr and FILE_ATTRIBUTE_DIRECTORY = 0);
end;

function IntToStr(Int : Int64) : String;
begin
  Str(Int, result);
end;

function StrPas(const Str : PChar) : String;
begin
  Result := Str;
end;

function RenameFile(const OldName, NewName : String) : Boolean;
begin
  Result := MoveFile(PChar(OldName), PChar(NewName));
end;

function CutFileName(s : String) : String;
var
  i : Integer;
begin
  Result := s;
  for i := Length(s) downto 1 do
    if s[i] = '\' then
      begin
        Result := Copy(s, 1, i);
        Break;
      end;
end;

function GetVersionInfo(var VersionString : String) : DWORD;
type
  PDWORDArr = ^DWORDArr;
  DWORDArr = array [0..0] of DWORD;
var
  VerInfo : Pointer;
  VerInfoSize, VerValueSize, LangID : DWORD;
  VerValue : PVSFixedFileInfo;
begin
  Result := 0;
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), LangID);
  if VerInfoSize <> 0 then
  begin
    VerInfo := Pointer(GlobalAlloc(GPTR, VerInfoSize));
    if Assigned(VerInfo) then
    try
      if GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo) then
      begin
        if VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then
        begin
          with VerValue^ do
          VersionString := Format('%d.%d.%d.%d', [dwFileVersionMS shr 16, dwFileVersionMS and $FFFF,
            dwFileVersionLS shr 16, dwFileVersionLS and $FFFF]);
        end
        else
          VersionString := #0;
      end;
    finally
      GlobalFree(THandle(VerInfo));
    end
    else
      Result := GetLastError;
  end
  else
    Result := GetLastError;
end;

function FormatTime(t : Cardinal) : String;
begin
  t := t div 1000;
  Result := IntToStr(t mod 60);
  case t mod 60 < 10 of
    TRUE : Result := '0' + Result;
  end;
  t := t div 60;
  Result := IntToStr(t mod 60) + ':' + Result;
  case t mod 60 < 10 of
    TRUE : Result := '0' + Result;
  end;
  t := t div 60;
  Result := IntToStr(t mod 24) + ':' + Result;
  case t mod 60 < 10 of
    TRUE : Result := '0' + Result;
  end;
end;

function CreateDir(const Dir : String) : Boolean;
begin
  Result := CreateDirectory(PChar(Dir), nil);
end;

function SetAutoRun(NeedAutoRun : Boolean; AppName : String) : Boolean;
var
  Key : HKEY;
  Buff : String;
begin
  Result := False;
  if RegOpenKeyEx(HKEY_CURRENT_USER,
    PChar('Software\Microsoft\Windows\CurrentVersion\Run'),
    0, KEY_WRITE, Key) = ERROR_SUCCESS then
  try
    if NeedAutoRun then
    begin
      Buff := ParamStr(0);
      Result := RegSetValueEx(Key, PChar(AppName), 0,
        REG_SZ, @Buff[1], Length(Buff)) = ERROR_SUCCESS;
    end
    else
      Result := RegDeleteValue(Key, PChar(AppName)) = ERROR_SUCCESS;
  finally
    RegCloseKey(Key);
  end;
end;

function SetTreeViewStyle(const hTV : HWND; dwNewStyle : DWORD) : DWORD;
var
  dwStyle : dword;
begin
  dwStyle := GetWindowLong(hTV, GWL_STYLE);
  if(dwStyle and dwNewStyle = 0) then
    SetWindowLong(hTV, GWL_STYLE, dwStyle or dwNewStyle)
  else
    SetWindowLong(hTV, GWL_STYLE, dwStyle and not dwNewStyle);
  Result := GetWindowLong(hTV, GWL_STYLE);
end;

function StrLen(Str : PChar) : Integer;
begin
  Result := 0;
  while Str[Result] <> #0 do Inc(Result);
end;

function DirectoryExists(const Directory : string) : Boolean;
var
  Code : Integer;
begin
  Code := GetFileAttributes(PChar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function GetFolder(hWnd : hWnd; RootDir : Integer; Caption : String) : String;
var
  bi : TBrowseInfo;
  lpBuffer : PChar;
  pidlPrograms, pidlBrowse : PItemIDList;
begin
  Result := #0;
  if (not SUCCEEDED(SHGetSpecialFolderLocation(GetActiveWindow, RootDir, pidlPrograms))) then Exit;
  lpBuffer := GetMemory(MAX_PATH);
  if Assigned(lpBuffer) then
  begin
    try
      bi.hwndOwner := hWnd;
      bi.pidlRoot := pidlPrograms;
      bi.pszDisplayName := lpBuffer;
      bi.lpszTitle := PChar(Caption);
      bi.ulFlags := BIF_NEWDIALOGSTYLE or BIF_RETURNONLYFSDIRS or BIF_EDITBOX;
      bi.lpfn := nil;
      bi.lParam := 0;
      pidlBrowse := SHBrowseForFolder(bi);
      if (pidlBrowse <> nil) then
        if SHGetPathFromIDList(pidlBrowse, lpBuffer) then
          Result := lpBuffer;
    finally
      FreeMemory(lpBuffer);
    end;
  end
  else
end;

function SetBlendWindow(hWnd : HWND; AlphaBlend : Byte) : LongBool;
var
  Old : longint;
  User32 : HMODULE;
  SetLayeredWindowAttributes : TSetLayeredWindowAttributes;
begin
  User32 := LoadLibrary('user32.dll');
    if (User32 <> 0) then
      begin
        Old := GetWindowLong(hWnd, GWL_EXSTYLE);
        SetWindowLong(hWnd, GWL_EXSTYLE, Old or $80000);
        SetLayeredWindowAttributes := GetProcAddress(User32, 'SetLayeredWindowAttributes');
        if Assigned(SetLayeredWindowAttributes) then SetLayeredWindowAttributes(hWnd, 0, AlphaBlend, LWA_ALPHA);
        FreeLibrary(User32);
      end;
  Result := False;
end;

function EditWindowProc(hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT; stdcall;
begin
  case Msg of
    WM_CHAR, WM_PASTE, WM_CUT, WM_RBUTTONDOWN : Result := 0;
    WM_KEYDOWN :
      case wParam of
        VK_DELETE, VK_INSERT : Result := 0;
      else
        Result := CallWindowProc(pointer(GetProp(hWnd, 'OrigWndProc')), hWnd, Msg, wParam, lParam);
      end;
  else
    Result := CallWindowProc(pointer(GetProp(hWnd, 'OrigWndProc')), hWnd, Msg, wParam, lParam);
  end;
end;

procedure SetEditWndProc(hWnd : HWND; ptr : Pointer);
begin
  SetProp(hWnd, 'OrigWndProc', DWORD(SetWindowLong(hWnd, GWL_WNDPROC, Integer(ptr))));
end;

function GetTextFromFile(Filename : String) : String;
var
  hFile, hMemory : Cardinal;
  pMemory : Pointer;
  SizeReadWrite : DWORD;
begin
  Result := #0;
  hFile := CreateFile(@Filename[1], GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_ALWAYS,
    FILE_ATTRIBUTE_ARCHIVE, 0);
  if hFile = INVALID_HANDLE_VALUE then exit;
  hMemory := GlobalAlloc(GMEM_MOVEABLE or GMEM_ZEROINIT, 65535);
  if hMemory = 0 then
   begin
    CloseHandle(hFile);
    exit;
   end;
  pMemory := GlobalLock(hMemory);
  ReadFile(hFile, pMemory^, 65535 - 1, SizeReadWrite, nil);
  Result := string(PChar(pMemory));
  CloseHandle(hFile);
  GlobalUnlock(DWORD(pMemory));
  GlobalFree(hMemory);
end;

function IsTopMost(hWnd : HWND) : Bool;
begin
  Result := Bool(GetWindowLong(hWnd, GWL_EXSTYLE) and WS_EX_TOPMOST);
end;

function StrToIntDef(const s : String; const i : Integer) : Integer;
var
  code : Integer;
begin
  Val(s, Result, code);
  if (code <> 0) then Result := i;
end;

function StrToInt(s : String) : Integer;
var
  code : Integer;
begin
  val(s, Result, code);
end;

function GetItemText(hDlg : THandle; ID : DWORD) : String;
var
  buffer : array [0..255] of Char;
begin
  ZeroMemory(@buffer, Length(buffer));
  GetDlgItemText(hDlg, ID, buffer, Length(buffer));
  Result := String(buffer);
end;

end.