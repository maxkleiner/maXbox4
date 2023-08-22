unit MaxUtils;

interface

type
  MaxCharSet = set of Char;

function GetMachineName: String;  
function GetModuleName(HModule: THandle): String;
function TrimChars(const S: string; Chars: MaxCharSet): string;
function TickCountToDateTime(Ticks: Cardinal): TDateTime;

procedure OutputDebugString(const S: String);
procedure OutputDebugFormat(const FmtStr: String; Args: array of const);

function IsAppRunningInDelphi : Boolean;

implementation

uses
  SysUtils,
  DateUtils,
  Windows;


type
  TProcIsDebuggerPresent = function: Boolean; stdcall;


function GetMachineName: String;
var
  LLen: Cardinal;
begin
  LLen := MAX_PATH;
  SetLength(Result,LLen+1);
  if GetComputerName(PChar(Result),LLen) then
    SetLength(Result,LLen)
  else
    SetLength(Result,0);
end;


function GetModuleName(HModule: THandle): String;
var
  lpModulePath: PChar;
  nSize: Cardinal;
begin
  nSize := MAX_PATH + 1;
  GetMem(lpModulePath, nSize);
  GetModuleFileName(HModule, lpModulePath, nSize);
  Result := StrPas(lpModulePath);
  FreeMem(lpModulePath, nSize);
end;


function TrimChars(const S: string; Chars: MaxCharSet): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] in Chars) do
    Inc(I);
  if I > L then
    Result := ''
  else begin
    while S[L] in Chars do
      Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;



function TickCountToDateTime(Ticks: Cardinal): TDateTime;
var
  NewTicks: Cardinal;
  NowDate: TDateTime;
begin
  NewTicks := GetTickCount();
  NowDate := Now;
  Result := IncMillisecond(NowDate,Ticks-NewTicks);
end;


procedure OutputDebugString(const S: String);
begin
  Windows.OutputDebugString(PChar(S));
end;


procedure OutputDebugFormat(const FmtStr: String; Args: array of const);
begin
  OutputDebugString(Format(FmtStr,Args));
end;


function IsAppRunningInDelphi : Boolean;
var
  hKernelDll : Integer;
  proc_IsDebuggerPresent : TProcIsDebuggerPresent;
  useFindWindow : boolean;
  proc : FARPROC;
begin
  Result := False;
  useFindWindow := true;
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    // WinNt
    try
      hKernelDll := GetModuleHandle(kernel32);
      if (hKernelDll = -1) then
        hKernelDll := LoadLibrary(kernel32);
      if (hKernelDll <> -1) then
      begin
        proc := GetProcAddress(hKernelDll, 'IsDebuggerPresent');
        if (proc <> nil) then
        begin
          proc_IsDebuggerPresent := proc;
          result := proc_IsDebuggerPresent;
          useFindWindow := false;
        end;
      end;
    except
    end;
  end;
  if (UseFindWindow) then
  begin
    if FindWindow('TAppBuilder', Nil) <> 0 Then
      result := true
    else
      result := false;
  end;
end;



end.
