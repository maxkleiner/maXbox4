unit SmallUtils;
{version 2}

interface

uses Windows;

type
TdriveSize = record
    FreeS:Int64;
    TotalS:Int64;
end;

TWinVerRec = Record
  WinPlatform: Integer;
  WinMajorVersion: Integer;
  WinMinorVersion: Integer;
  WinBuildNumber: Integer;
  WinCSDVersion: String;
end;

function AllocPadedMem(Size: Cardinal): Pointer;
procedure FreePadedMem(var P: Pointer); overload;
procedure FreePadedMem(var P: PChar); overload;
function CheckPadedMem(P: Pointer): Byte;
function GetPadMemSize(P: Pointer): Cardinal;
{padded memory functions}

function AllocMem(Size: Cardinal): Pointer;
function StrLen(const Str: PChar): Cardinal;
function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar;
function StrECopy(Dest:PChar; const Source: PChar): PChar;
function StrCopy(Dest: PChar; const Source: PChar): PChar;
function StrEnd(const Str: PChar): PChar; assembler;
function StrScan(const Str: PChar; Chr: Char): PChar;
function StrMove(Dest: PChar; const Source: PChar; Count: Cardinal): PChar; assembler;
function PCharLength(const Str: PChar): Cardinal;
function PCharUpper(Str: PChar): PChar; assembler;
function PCharLower(Str: PChar): PChar; assembler;
function StrCat(Dest: PChar; const Source: PChar): PChar;
{the functions above are like the SysUtils functions}

function LastDelimiter(const Delimiters, S: String): Integer;
function CopyTail(const S : String; Len : Integer) : String;
function Int2Thos(I : Int64) : String;
{puts commas into a string for thousands}
function UpperCase(const S: String): String;
function LowerCase(const S: string): String;
function CompareText(const S1, S2: string): Integer;
function SameText(const S1, S2: string): Boolean;
{4 functions above are like the SysUtils}

{Int2Str is like the IntToStr}
function Int2Str(Value : Int64) : String;
function Str2Int(const Value : String) : Int64;
function Str2IntDef(const S: string; Default: Int64): Int64;
  // str2IntDef will return a default value if the string is not an integer
function GetFileExt(const FileName: String): String;
function GetFilePath(const FileName: String): String;
function GetFileName(const FileName: String): String;
{3 functions above are like the ExtractFileExt, ExtractFileName, etc.}
function ChangeExt(const FileName, Extension: String): String;
function AdjustLineBreaks(const S: string): string;
function GetWindowStr(WinHandle: HWND): String;
{function above return the text in the window Handle of WinHandle
as a String}

function DiskSpace(Drive: String): TdriveSize;
{DiskSpace is like the DiskFree and DiskSize in one function}
function FileExists(FileName : String) : Boolean;
function FileSize(FileName:String):Int64;
function DirectoryExists(const Name: string): Boolean;
function SysErrorMessage(ErrorCode: Integer): string;
{for API you get Error codes from GetLastError, this will convert
it to an Error string}
function ShortPathName(const LongName: string): string;
function GetWindowVer: TWinVerRec;
{you can use GetWindowVer to get Version Info
Win32Platform = VER_PLATFORM_WIN32_NT for NT and Win2000
Win32Platform = VER_PLATFORM_WIN32_WINDOWS for Win 95/98/Me}
procedure InitDriveSpacePtr;


var
  GetDiskFreeSpaceEx: function (Directory: PChar; var FreeAvailable,
    TotalSpace: Int64; TotalFree: PLargeInteger): Boolean stdcall = nil;

    {FreePadedMem: procedure(var P: Pointer) = FreePadedMem1; overload;
    FreePadedMem: procedure(var P: PChar) = FreePadedMem1; overload;}


implementation

uses
Messages;

function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;

function AllocPadedMem(Size: Cardinal): Pointer;
begin
if Size = 0 then
  begin
  Result := nil;
  MessageBox(0,'Can not Create a 0 length memory block, Size must be One or more','Size must be larger than Zero',MB_OK);
  Exit;
  end;
Inc(Size,12);
GetMem(Result, Size);
Cardinal(Result^) := Size;
Cardinal(Pointer(Cardinal(Result)+4)^):= $FFFFFFFE;
Cardinal(pointer(Cardinal(Result)+Size-4)^) := $FFFFFFFD;
Result := Pointer(Cardinal(Result)+8);
FillChar(Result^, Size-12, 0);
end;

function CheckPadedMem(P: Pointer): Byte;
var
Size: Cardinal;
begin
if P = nil then
  begin
  Result := 1;
  Exit;
  end;
if Cardinal(pointer(Cardinal(P)-4)^) <> $FFFFFFFE then
  begin
  Result := 2;
  Exit;
  end;

Size := Cardinal(pointer(Cardinal(P)-8)^);
if Cardinal(pointer(Cardinal(P)+Size-12)^) <> $FFFFFFFD then
  begin
  Result := 3;
  Exit;
  end;
Result := 0;
end;

procedure FreePadedMem(var P: Pointer);
begin
if P = nil then Exit;
P := Pointer(Cardinal(P)-8);
ReallocMem(P,0);
end;

procedure FreePadedMem(var P: PChar);
begin
if P = nil then Exit;
P := Pointer(Cardinal(P)-8);
ReallocMem(P,0);
end;

function GetPadMemSize(P: Pointer): Cardinal;
begin
if CheckPadedMem(P) > 0 then
  begin
  Result := 0;
  Exit;
  end;
Result := Cardinal(pointer(Cardinal(P)-8)^);
if Result < 13 then
  begin
  Result := 0;
  Exit;
  end;

Result := Result -12;
end;

function StrLen(const Str: PChar): Cardinal; assembler;
asm
        MOV     EDX,EDI
        MOV     EDI,EAX
        MOV     ECX,0FFFFFFFFH
        XOR     AL,AL
        REPNE   SCASB
        MOV     EAX,0FFFFFFFEH
        SUB     EAX,ECX
        MOV     EDI,EDX
end;

function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EBX,ECX
        XOR     AL,AL
        TEST    ECX,ECX
        JZ      @@1
        REPNE   SCASB
        JNE     @@1
        INC     ECX
@@1:    SUB     EBX,ECX
        MOV     EDI,ESI
        MOV     ESI,EDX
        MOV     EDX,EDI
        MOV     ECX,EBX
        SHR     ECX,2
        REP     MOVSD
        MOV     ECX,EBX
        AND     ECX,3
        REP     MOVSB
        STOSB
        MOV     EAX,EDX
        POP     EBX
        POP     ESI
        POP     EDI
end;

function StrCopy(Dest: PChar; const Source: PChar): PChar; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     ECX,0FFFFFFFFH
        XOR     AL,AL
        REPNE   SCASB
        NOT     ECX
        MOV     EDI,ESI
        MOV     ESI,EDX
        MOV     EDX,ECX
        MOV     EAX,EDI
        SHR     ECX,2
        REP     MOVSD
        MOV     ECX,EDX
        AND     ECX,3
        REP     MOVSB
        POP     ESI
        POP     EDI
end;

function StrECopy(Dest: PChar; const Source: PChar): PChar; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     ECX,0FFFFFFFFH
        XOR     AL,AL
        REPNE   SCASB
        NOT     ECX
        MOV     EDI,ESI
        MOV     ESI,EDX
        MOV     EDX,ECX
        SHR     ECX,2
        REP     MOVSD
        MOV     ECX,EDX
        AND     ECX,3
        REP     MOVSB
        LEA     EAX,[EDI-1]
        POP     ESI
        POP     EDI
end;

function StrEnd(const Str: PChar): PChar; assembler;
asm
        MOV     EDX,EDI
        MOV     EDI,EAX
        MOV     ECX,0FFFFFFFFH
        XOR     AL,AL
        REPNE   SCASB
        LEA     EAX,[EDI-1]
        MOV     EDI,EDX
end;

function StrScan(const Str: PChar; Chr: Char): PChar; assembler;
asm
        PUSH    EDI
        PUSH    EAX
        MOV     EDI,Str
        MOV     ECX,0FFFFFFFFH
        XOR     AL,AL
        REPNE   SCASB
        NOT     ECX
        POP     EDI
        MOV     AL,Chr
        REPNE   SCASB
        MOV     EAX,0
        JNE     @@1
        MOV     EAX,EDI
        DEC     EAX
@@1:    POP     EDI
end;

function StrMove(Dest: PChar; const Source: PChar; Count: Cardinal): PChar; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EDX
        MOV     EDI,EAX
        MOV     EDX,ECX
        CMP     EDI,ESI
        JA      @@1
        JE      @@2
        SHR     ECX,2
        REP     MOVSD
        MOV     ECX,EDX
        AND     ECX,3
        REP     MOVSB
        JMP     @@2
@@1:    LEA     ESI,[ESI+ECX-1]
        LEA     EDI,[EDI+ECX-1]
        AND     ECX,3
        STD
        REP     MOVSB
        SUB     ESI,3
        SUB     EDI,3
        MOV     ECX,EDX
        SHR     ECX,2
        REP     MOVSD
        CLD
@@2:    POP     EDI
        POP     ESI
end;

function PCharLength(const Str: PChar): Cardinal; assembler;
asm
        MOV     EDX,EDI
        MOV     EDI,EAX
        MOV     ECX,0FFFFFFFFH
        XOR     AL,AL
        REPNE   SCASB
        MOV     EAX,0FFFFFFFEH
        SUB     EAX,ECX
        MOV     EDI,EDX
end;

function PCharUpper(Str: PChar): PChar; assembler;
asm
        PUSH    ESI
        MOV     ESI,Str
        MOV     EDX,Str
@@1:    LODSB
        OR      AL,AL
        JE      @@2
        CMP     AL,'a'
        JB      @@1
        CMP     AL,'z'
        JA      @@1
        SUB     AL,20H
        MOV     [ESI-1],AL
        JMP     @@1
@@2:    XCHG    EAX,EDX
        POP     ESI
end;

function PCharLower(Str: PChar): PChar; assembler;
asm
        PUSH    ESI
        MOV     ESI,Str
        MOV     EDX,Str
@@1:    LODSB
        OR      AL,AL
        JE      @@2
        CMP     AL,'A'
        JB      @@1
        CMP     AL,'Z'
        JA      @@1
        ADD     AL,20H
        MOV     [ESI-1],AL
        JMP     @@1
@@2:    XCHG    EAX,EDX
        POP     ESI
end;

function StrCat(Dest: PChar; const Source: PChar): PChar;
begin
  StrCopy(StrEnd(Dest), Source);
  Result := Dest;
end;

function LastDelimiter(const Delimiters, S: string): Integer;
var
  P: PChar;
begin
  Result := Length(S);
  P := PChar(Delimiters);
  while Result > 0 do
  begin
    if (S[Result] <> #0) and (StrScan(P, S[Result]) <> nil) then
      {if (ByteType(S, Result) = mbTrailByte) then
        Dec(Result)
      else}
        Exit;
    Dec(Result);
  end;
end;

function CopyTail(const S : String; Len : Integer): String;
var L : Integer;
begin
  L := Length( S );
  if L < Len then
     Len := L;
  Result := '';
  if Len = 0 then Exit;
  Result := Copy( S, L - Len + 1, Len );
end;

function CompareText(const S1, S2: string): Integer; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,EDX
        OR      EAX,EAX
        JE      @@0
        MOV     EAX,[EAX-4]
@@0:    OR      EDX,EDX
        JE      @@1
        MOV     EDX,[EDX-4]
@@1:    MOV     ECX,EAX
        CMP     ECX,EDX
        JBE     @@2
        MOV     ECX,EDX
@@2:    CMP     ECX,ECX
@@3:    REPE    CMPSB
        JE      @@6
        MOV     BL,BYTE PTR [ESI-1]
        CMP     BL,'a'
        JB      @@4
        CMP     BL,'z'
        JA      @@4
        SUB     BL,20H
@@4:    MOV     BH,BYTE PTR [EDI-1]
        CMP     BH,'a'
        JB      @@5
        CMP     BH,'z'
        JA      @@5
        SUB     BH,20H
@@5:    CMP     BL,BH
        JE      @@3
        MOVZX   EAX,BL
        MOVZX   EDX,BH
@@6:    SUB     EAX,EDX
        POP     EBX
        POP     EDI
        POP     ESI
end;

function SameText(const S1, S2: string): Boolean; assembler;
asm
        CMP     EAX,EDX
        JZ      @1
        OR      EAX,EAX
        JZ      @2
        OR      EDX,EDX
        JZ      @3
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JNE     @3
        CALL    CompareText
        TEST    EAX,EAX
        JNZ     @3
@1:     MOV     AL,1
@2:     RET
@3:     XOR     EAX,EAX
end;

function Int2Thos(I : Int64): String;
var S : String;
begin
  S := Int2Str( I );
  Result := '';
  while S <> '' do
  begin
    if Result <> '' then
       Result := ',' + Result;
    Result := CopyTail( S, 3 ) + Result;
    S := Copy( S, 1, Length( S ) - 3 );
  end;
end;

function GetFileExt(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('.\:', FileName);
  if (I > 0) and (FileName[I] = '.') then
    Result := Copy(FileName, I, MaxInt) else
    Result := '';
end;

function GetFilePath(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('\:', FileName);
  Result := Copy(FileName, 1, I);
end;

function GetFileName(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('\:', FileName);
  Result := Copy(FileName, I + 1, MaxInt);
end;

function ChangeExt(const FileName, Extension: string): string;
  // Extention needs a period like '.exe'
var
  I: Integer;
begin
  I := LastDelimiter('.\:',Filename);
  if (I = 0) or (FileName[I] <> '.') then I := MaxInt;
  Result := Copy(FileName, 1, I - 1) + Extension;
end;

function UpperCase(const S: string): string;
var I : Integer;
begin
  Result := S;
  for I := 1 to Length( S ) do
    if Result[ I ] in [ 'a'..'z' ] then
       Dec( Result[ I ], 32 );
end;

function LowerCase(const S: string): string;
var
  Ch: Char;
  L: Integer;
  Source, Dest: PChar;
begin
  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);
  while L <> 0 do
  begin
    Ch := Source^;
    if (Ch >= 'A') and (Ch <= 'Z') then Inc(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function AdjustLineBreaks(const S: string): string;
var
  Source, SourceEnd, Dest: PChar;
  Extra: Integer;
begin
  Source := Pointer(S);
  SourceEnd := Source + Length(S);
  Extra := 0;
  while Source < SourceEnd do
  begin
    case Source^ of
      #10:
        Inc(Extra);
      #13:
        if Source[1] = #10 then Inc(Source) else Inc(Extra);
    end;
    Inc(Source);
  end;
  if Extra = 0 then Result := S else
  begin
    Source := Pointer(S);
    SetString(Result, nil, SourceEnd - Source + Extra);
    Dest := Pointer(Result);
    while Source < SourceEnd do
      case Source^ of
        #10:
          begin
            Dest^ := #13;
            Inc(Dest);
            Dest^ := #10;
            Inc(Dest);
            Inc(Source);
          end;
        #13:
          begin
            Dest^ := #13;
            Inc(Dest);
            Dest^ := #10;
            Inc(Dest);
            Inc(Source);
            if Source^ = #10 then Inc(Source);
          end;
      else
        Dest^ := Source^;
        Inc(Dest);
        Inc(Source);
      end;
  end;
end;

function GetWindowStr(WinHandle: HWND): String;
var
ResultStr: String;
begin
SetLength(ResultStr, GetWindowTextLength(WinHandle));
GetWindowText(WinHandle,@ResultStr[1],Length(ResultStr)+1);
Result := ResultStr;
//UniqueString(Result);
ResultStr := '';
end;

function Int2Str( Value : Int64 ) : String;
var Minus : Boolean;
begin
   Result := '';
   if Value = 0 then
      Result := '0';
   Minus := Value < 0;
   if Minus then
      Value := -Value;
   while Value > 0 do
   begin
      Result := Char( (Value mod 10) + Integer( '0' ) ) + Result;
      Value := Value div 10;
   end;
   if Minus then
      Result := '-' + Result;
end;

function Str2Int(const Value : String) : Int64;
var M, I : Integer;
begin
   Result := 0;
   if Value = '' then Exit;
   M := 1;
   I := 1;
   if Value[ 1 ] = '-' then
   begin
      M := -1;
      Inc( I );
   end;
   for I := I to Length( Value ) do
   begin
      if (Value[ I ] < '0') or (Value[ I ] > '9') then
         break;
      Result := Result * 10 + Integer( Value[ I ] ) - Integer( '0' );
   end;
   if M < 0 then
      Result := -Result;
end;

function Str2IntDef(const S: string; Default: Int64): Int64;
var
  E: Integer;
begin
  Val(S, Result, E);
  if E <> 0 then Result := Default;
end;

function BackfillGetDiskFreeSpaceEx(Directory: PChar; var FreeAvailable,
    TotalSpace: Int64; TotalFree: PLargeInteger): Boolean; stdcall;
var
  SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters: LongWord;
  Temp: Int64;
  Dir: PChar;
begin
  if Directory <> nil then
    Dir := Directory
  else
    Dir := nil;
  Result := GetDiskFreeSpaceA(Dir, SectorsPerCluster, BytesPerSector,
    FreeClusters, TotalClusters);
  Temp := SectorsPerCluster * BytesPerSector;
  FreeAvailable := Temp * FreeClusters;
  TotalSpace := Temp * TotalClusters;
end;

procedure InitDriveSpacePtr;
var
  Kernel: HWND;
begin
  Kernel := GetModuleHandle(Windows.Kernel32);
  if Kernel <> 0 then
    @GetDiskFreeSpaceEx := GetProcAddress(Kernel, 'GetDiskFreeSpaceExA');
  if not Assigned(GetDiskFreeSpaceEx) then
    GetDiskFreeSpaceEx := @BackfillGetDiskFreeSpaceEx;
end;

function DiskSpace(Drive: String): TdriveSize;
var
  TSpace,TotalS: Int64;
  Sizes:TdriveSize;
  ErrorMode: Word;
begin
Delete(Drive, 4, 600);
ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
if GetDiskFreeSpaceEx(@Drive[1], TSpace, TotalS, nil) then
begin
Sizes.FreeS :=  TSpace;
Sizes.TotalS := TotalS;
Result := Sizes;
end else
begin
Sizes.FreeS := -1;
Sizes.TotalS := -1;
Result := Sizes;
end;
SetErrorMode(ErrorMode);
end;

function FileExists( FileName : String ) : Boolean;
var
FndData: TWin32FindData;
fndHandle: Integer;
ErrorMode: Word;
begin
  Result := False;
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  fndHandle := FindFirstFile(PChar(FileName), FndData);
  SetErrorMode(ErrorMode);
  if fndHandle <> Integer( INVALID_HANDLE_VALUE ) then
  begin
    Windows.FindClose(fndHandle);
    if (FndData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
       Result := True;
  end;
end;

function DirectoryExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function FileSize(FileName:String):Int64;
var
FindHandle:HWND;
FindData: TWin32FindData;
ErrorMode: Word;
begin
ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
FindHandle := FindFirstFile(PChar(FileName), FindData);
SetErrorMode(ErrorMode);
if FindHandle <> INVALID_HANDLE_VALUE then
  begin
  Result := (FindData.nFileSizeHigh * MAXDWORD) + FindData.nFileSizeLow;
  Windows.FindClose(findHandle);
  end else Result := -1;
end;

function SysErrorMessage(ErrorCode: Integer): string;
var
  Len: Integer;
  Buffer: array[0..255] of Char;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or
    FORMAT_MESSAGE_ARGUMENT_ARRAY, nil, ErrorCode, 0, Buffer,
    SizeOf(Buffer), nil);
  while (Len > 0) and (Buffer[Len - 1] in [#0..#32, '.']) do Dec(Len);
  SetString(Result, Buffer, Len);
end;

function ShortPathName(const LongName: string): string;
var
  Buffer: array[0..MAX_PATH - 1] of Char;
begin
  SetString(Result, Buffer,
    GetShortPathName(PChar(LongName), Buffer, SizeOf(Buffer)));
end;

function GetWindowVer: TWinVerRec;
var
  OSVersionInfo: TOSVersionInfo;
begin
with Result do
      begin
      WinPlatform := 0;
      WinMajorVersion := 0;
      WinMinorVersion := 0;
      WinBuildNumber := 0;
      WinCSDVersion := '';
      end;
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
    with OSVersionInfo do
    begin
    with Result do
      begin
      WinPlatform := dwPlatformId;
      WinMajorVersion := dwMajorVersion;
      WinMinorVersion := dwMinorVersion;
      WinBuildNumber := dwBuildNumber;
      WinCSDVersion := szCSDVersion;
      end;
    end;
end;


initialization
  //InitDriveSpacePtr;

end.