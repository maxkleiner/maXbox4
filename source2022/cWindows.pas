{$INCLUDE ..\cDefines.inc}
unit cWindows;

{                                                                              }
{                          Windows functions v3.07                             }
{                                                                              }
{             This unit is copyright © 2000-2003 by David J Butler             }
{                                                                              }
{                  This unit is part of Delphi Fundamentals.                   }
{                    Its original file name is cWindows.pas                    }
{       The latest version is available from the Fundamentals home page        }
{                     http://fundementals.sourceforge.net/                     }
{                                                                              }
{                I invite you to use this unit, free of charge.                }
{        I invite you to distibute this unit, but it must be for free.         }
{             I also invite you to contribute to its development,              }
{             but do not distribute a modified copy of this file.              }
{                                                                              }
{          A forum is available on SourceForge for general discussion          }
{             http://sourceforge.net/forum/forum.php?forum_id=2117             }
{                                                                              }
{ Description:                                                                 }
{   MS Windows specific functions.                                             }
{                                                                              }
{ Revision history:                                                            }
{   2000/10/01  1.01  Initial version created from cUtils.                     }
{   2001/12/12  2.02  Added AWindowHandle.                                     }
{   2002/03/15  2.03  Added GetWinOSType.                                      }
{   2002/06/26  3.04  Refactored for Fundamentals 3.                           }
{   2002/09/22  3.05  Moved Registry functions to unit cRegistry.              }
{   2003/01/04  3.06  Added Reboot function.                                   }
{   2003/10/01  3.07  Updated GetWindowsVersion function.                      }
{   2020/12/23  4.7.5  maXbox4 Adaption  + cstrings routines                                                                         }

interface

uses
  { Delphi }
  Windows,
  Messages,
  SysUtils,
  Classes,  utilsmax4,  regutils, ComCtrls,

  { Fundamentals }
  cfundamentUtils;



{                                                                              }
{ Windows Version                                                              }
{                                                                              }
type
  TWindowsVersion = (
      // 16-bit Windows
      Win16_31,
      // 32-bit Windows
      Win32_95, Win32_95R2, Win32_98, Win32_98SE, Win32_ME, Win32_Future,
      // Windows NT 3
      WinNT_31, WinNT_35, WinNT_351,
      // Windows NT 4
      WinNT_40,
      // Windows NT 5
      WinNT5_2000, WinNT5_XP, WinNT5_2003, WinNT5_Future,
      // Windows NT 6+
      WinNT_Future,
      // Windows Post-NT
      Win_Future);
  TWindowsVersions = Set of TWindowsVersion;

   type TStringArray = array of string;

//function  GetWindowsVersion: TWindowsVersion;
function  IsWinPlatform95: Boolean;
function  IsWinPlatformNT: Boolean;
function  GetWindowsProductID: String;
//function  GetRegistryString(const RootKey: HKEY; const Key, Name: String): String; overload; {$IFDEF UseInline}inline;{$ENDIF}
function StrEqualNoCase(const A, B: String; const AsciiCaseSensitive: Boolean): Boolean;
function StrMatchNoAsciiCase(const S, M: String; const Index: Integer = 1): Boolean;
function StrMatchLeft(const S, M: String; const AsciiCaseSensitive: Boolean): Boolean;
function StrMatchRight(const S, M: String; const AsciiCaseSensitive: Boolean): Boolean;
function PosChar(const F: Char; const S: String; const Index: Integer): Integer;
function PosStr(const F, S: String; const Index: Integer;
                                        const AsciiCaseSensitive: Boolean): Integer;
function StrMatch(const S, M: String; const Index: Integer): Boolean;
function StrPMatch(const A, B: PChar; const Len: Integer): Boolean;
function CopyFrom(const S: String; const Index: Integer): String;
function CopyRange(const S: String; const StartIndex, StopIndex: Integer): String;
function CopyLeft(const S: String; const Count: Integer): String;
function CopyRight(const S: String; const Count: Integer): String;
function StrIsNumeric(const S: String): Boolean;
function StrMatchChar(const S: String; const M: TSYsCharSet): Boolean;
function StrSplitAtChar(const S: String; const C: Char;
         var Left, Right: String; const Optional: Boolean): Boolean;
function StrReplaceChar(const Find, Replace: Char; const S: String): String;
function StrInclSuffix(const S: String; const Suffix: String;
                                const AsciiCaseSensitive: Boolean): String;
function StrRemoveCharDelimited(var S: String;
                              const FirstDelim, SecondDelim: Char): String;
function StrSplit(const S, D: String): TStringArray;
procedure TrimInPlace(var S : String; const C: CharSet);
function TrimIn(S : String; const C: CharSet): String;
function StrAfterCharSet(const S: String; const D: CharSet): String;
function StrAfterChar(const S: String; const D: Char): String;
procedure StrSplit4(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
function StrSplit4F(Delimiter: Char; Str: string): TStrings;
function Int32toBytes(const Cint: Integer): TBytes;

function IsIntResource(const ResID: PChar): Boolean;

///  <summary>Checks whether two given resource IDs and equal.</summary>
function IsEqualResID(const R1, R2: PChar): Boolean;

///  <summary>Converts the given resource ID into its string representation.
///  </summary>
///  <remarks>If resource ID is an ordinal the ordinal number preceded by '#' is
///  returned, otherwise the string itself is returned.</remarks>
function ResIDToStr(const ResID: PChar): string;
Function GetRTFtext(Const RichEdit: TRichEdit): String;
function StrRemoveCharSet(const S: String; const C: CharSet): String;
function GetTextBetween(const Start, Stop: String; var S, Between: String): Boolean;


{                                                                              }
{ Windows Paths                                                                }
{                                                                              }
function  GetWindowsTemporaryPath: String;
function  GetWindowsPath: String;
function  GetWindowsSystemPath: String;
function  GetProgramFilesPath: String;
function  GetCommonFilesPath: String;
function  GetApplicationPath: String;

{                                                                              }
{ Identification                                                               }
{                                                                              }
function  GetUserName: String;
function  GetLocalComputerName: String;
function  GetLocalHostName: String;


{                                                                              }
{ Application Version Info                                                     }
{                                                                              }
type
  TVersionInfo = (viFileVersion, viFileDescription, viLegalCopyright,
                  viComments, viCompanyName, viInternalName,
                  viLegalTrademarks, viOriginalFilename, viProductName,
                  viProductVersion);

function  GetAppVersionInfo(const VersionInfo: TVersionInfo): String;



{                                                                              }
{ Windows Processes                                                            }
{                                                                              }
function  WinExecute(const ExeName, Params: String;
          const ShowWin: Word = SW_SHOWNORMAL;
          const Wait: Boolean = True): Boolean;



{                                                                              }
{ Miscelleaneous Windows API                                                   }
{                                                                              }
function  GetEnvironmentStrings: TStringArray;

function  ContentTypeFromExtention (Extention: String): String;

function  IsApplicationAutoRun(const Name: String): Boolean;
procedure SetApplicationAutoRun(const Name: String; const AutoRun: Boolean);

function  GetWinPortNames: TStringArray;

function  GetKeyPressed(const VKeyCode: Integer): Boolean;

function  GetHardDiskSerialNumber(const DriveLetter: Char): String;

function  Reboot: Boolean;



{                                                                              }
{ Windows Fibers                                                               }
{   These functions are redeclared because Delphi 7's Windows.pas declare      }
{   them incorrectly.                                                          }
{                                                                              }
function  ConvertThreadToFiber(lpParameter: Pointer): Pointer; stdcall;
function  CreateFiber(dwStackSize: DWORD; lpStartAddress: TFNFiberStartRoutine;
          lpParameter: Pointer): Pointer; stdcall;



{                                                                              }
{ WinInet API                                                                  }
{                                                                              }
type
  TIEProxy = (iepHTTP, iepHTTPS, iepFTP, iepGOPHER, iepSOCKS);

function  GetIEProxy(const Protocol: TIEProxy): String;

procedure FGPlayASound(const AResName: string);
procedure FGPlayASound2(const AResName: string; atype: string);
function AddQuantumToDateTime(const dt: TDateTime): TDateTime;
procedure FGPlayASound2sync(const AResName: string; atype: string);
procedure FGPlayASound3Stream(const AResName: TMemoryStream; atype: string);  //sync
procedure FGPlayASound4Stream(const AResName: TMemoryStream; atype: string);  //async
procedure FGPlayASound5Stream(const AResName: TMemoryStream; atype: string);  //async & nostop


{                                                                              }
{ Window Handle                                                                }
{   Base class for allocation of a new Window handle that can process its own  }
{   messages.                                                                  }
{                                                                              }
type
  TWindowHandleMessageEvent = function (const Msg: Cardinal; const wParam, lParam: Integer;
      var Handled: Boolean): Integer of object;
  TWindowHandle = class;
  TWindowHandleEvent = procedure (const Sender: TWindowHandle) of object;
  TWindowHandleErrorEvent = procedure (const Sender: TWindowHandle;
      const E: Exception) of object;
  TWindowHandle = class(TComponent)
  protected
    FWindowHandle    : HWND;
    FTerminated      : Boolean;
    FOnMessage       : TWindowHandleMessageEvent;
    FOnException     : TWindowHandleErrorEvent;
    FOnBeforeMessage : TWindowHandleEvent;
    FOnAfterMessage  : TWindowHandleEvent;

    procedure RaiseError(const Msg: String);
    function  AllocateWindowHandle: HWND; virtual;
    function  MessageProc(const Msg: Cardinal; const wParam, lParam: Integer): Integer;
    function  HandleWM(const Msg: Cardinal; const wParam, lParam: Integer): Integer; virtual;

  public
    destructor Destroy; override;

    procedure DestroyWindowHandle; virtual;
    property  WindowHandle: HWND read FWindowHandle;
    function  GetWindowHandle: HWND;

    function  ProcessMessage: Boolean;
    procedure ProcessMessages;
    function  HandleMessage: Boolean;
    procedure MessageLoop;

    property  OnMessage: TWindowHandleMessageEvent read FOnMessage write FOnMessage;
    property  OnException: TWindowHandleErrorEvent read FOnException write FOnException;
    property  OnBeforeMessage: TWindowHandleEvent read FOnBeforeMessage write FOnBeforeMessage;
    property  OnAfterMessage: TWindowHandleEvent read FOnAfterMessage write FOnAfterMessage;

    property  Terminated: Boolean read FTerminated;
    procedure Terminate; virtual;
  end;
  EWindowHandle = class(Exception);

  { TfndWindowHandle                                                           }
  {   Published Window Handle component.                                       }
  TfndWindowHandle = class(TWindowHandle)
  published
    property  OnMessage;
    property  OnException;
  end;



{                                                                              }
{ TTimerHandle                                                                 }
{                                                                              }
type
  TTimerHandle = class;
  TTimerEvent = procedure (const Sender: TTimerHandle) of object;
  TTimerHandle = class(TWindowHandle)
  protected
    FTimerInterval : Integer;
    FTimerActive   : Boolean;
    FOnTimer       : TTimerEvent;

    function  HandleWM(const Msg: Cardinal; const wParam, lParam: Integer): Integer; override;
    function  DoSetTimer: Boolean;
    procedure TriggerTimer; virtual;
    procedure SetTimerActive(const TimerActive: Boolean); virtual;
    procedure Loaded; override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure DestroyWindowHandle; override;

    property  TimerInterval: Integer read FTimerInterval write FTimerInterval default 1000;
    property  TimerActive: Boolean read FTimerActive write SetTimerActive default False;
    property  OnTimer: TTimerEvent read FOnTimer write FOnTimer;
  end;

  { TfndTimerHandle                                                            }
  {   Published Timer Handle component.                                        }
  TfndTimerHandle = class(TTimerHandle)
  published
    property  OnMessage;
    property  OnException;
    property  TimerInterval;
    property  TimerActive;
    property  OnTimer;
  end;



{$IFNDEF DELPHI6_UP}
{                                                                              }
{ RaiseLastOSError                                                             }
{                                                                              }
procedure RaiseLastOSError;
{$ENDIF}



implementation

uses
  { Delphi }
  WinSock,
  WinSpool, mmsystem , {, ComCtrls,} //cfundamentutils,
  WinInet;

  { Fundamentals }
  //cStrings,
  //cRegistry;



{$IFNDEF DELPHI6_UP}
{                                                                              }
{ RaiseLastOSError                                                             }
{                                                                              }
procedure RaiseLastOSError;
begin
  RaiseLastWin32Error;
end;
{$ENDIF}

function AddQuantumToDateTime(const dt: TDateTime): TDateTime;
var
   overlay: Int64 absolute Result;
begin
   Result := dt;
   overlay := overlay+1;
end;

// Helper routines

function IsIntResource(const ResID: PChar): Boolean;
begin
  Result := (HiWord(DWORD(ResID)) = 0);
end;

function ResIDToStr(const ResID: PChar): string;
begin
  if IsIntResource(ResID) then
    Result := '#' + IntToStr(LoWord(DWORD(ResID)))
  else
    Result := ResID;
end;

function IsEqualResID(const R1, R2: PChar): Boolean;
begin
  if IsIntResource(R1) then
    // R1 is ordinal: R2 must also be ordinal with same value in lo word
    Result := IsIntResource(R2) and (LoWord(DWORD(R1)) = LoWord(DWORD(R2)))
  else
    // R1 is string pointer: R2 must be same string (ignoring case)
    Result := not IsIntResource(R2) and (StrIComp(R1, R2) = 0);
end;




procedure FGPlayASound(const AResName: string);
 var
   HResource: TResourceHandle;
   HResData: THandle;
   PWav: Pointer;
 begin
  HResource := FindResource(HInstance, PChar(AResName), 'WAV');
  if HResource <> 0 then begin
    HResData:=LoadResource(HInstance, HResource);
    if HResData <> 0 then begin
      PWav:=LockResource(HResData);
      if Assigned(PWav) then begin
        // uses MMSystem
        sndPlaySound(nil, SND_NODEFAULT); // nil = stop currently playing
        sndPlaySound(PWav, SND_ASYNC or SND_MEMORY);
      end;
//      UnlockResource(HResData); // unnecessary per MSDN
//      FreeResource(HResData);   // unnecessary per MSDN
    end;
  end
  else
    RaiseLastOSError;
end;

procedure FGPlayASound2(const AResName: string; atype: string);
 var
   HResource: TResourceHandle;
   HResData: THandle;
   PWav: Pointer;
 begin
  HResource := FindResource(HInstance, PChar(AResName), pchar(atype));
  if HResource <> 0 then begin
    HResData:=LoadResource(HInstance, HResource);
    if HResData <> 0 then begin
      PWav:=LockResource(HResData);
      if Assigned(PWav) then begin
        // uses MMSystem
        sndPlaySound(nil, SND_NODEFAULT); // nil = stop currently playing
        sndPlaySound(PWav, SND_ASYNC or SND_MEMORY);
      end;
//      UnlockResource(HResData); // unnecessary per MSDN
//      FreeResource(HResData);   // unnecessary per MSDN
    end;
  end
  else
    RaiseLastOSError;
end;

procedure FGPlayASound2sync(const AResName: string; atype: string);
 var
   HResource: TResourceHandle;
   HResData: THandle;
   PWav: Pointer;
 begin
  HResource := FindResource(HInstance, PChar(AResName), pchar(atype));
  if HResource <> 0 then begin
    HResData:=LoadResource(HInstance, HResource);
    if HResData <> 0 then begin
      PWav:=LockResource(HResData);
      if Assigned(PWav) then begin
        // uses MMSystem
        sndPlaySound(nil, SND_NODEFAULT); // nil = stop currently playing
        sndPlaySound(PWav, SND_SYNC or SND_MEMORY);
      end;
//      UnlockResource(HResData); // unnecessary per MSDN
//      FreeResource(HResData);   // unnecessary per MSDN
    end;
  end
  else
    RaiseLastOSError;
end;

procedure FGPlayASound3Stream(const AResName: TMemoryStream; atype: string);
 var
   HResource: TResourceHandle;
   HResData: THandle;
 begin
      // uses MMSystem
        sndPlaySound(nil, SND_NODEFAULT); // nil = stop currently playing
        sndPlaySound(AResName.memory, SND_SYNC or SND_MEMORY);
end;

procedure FGPlayASound4Stream(const AResName: TMemoryStream; atype: string);
 var
   HResource: TResourceHandle;
   HResData: THandle;
 begin
      // uses MMSystem
        sndPlaySound(nil, SND_NODEFAULT); // nil = stop currently playing
        sndPlaySound(AResName.memory, SND_ASYNC or SND_MEMORY);
end;

procedure FGPlayASound5Stream(const AResName: TMemoryStream; atype: string);
 var
   HResource: TResourceHandle;
   HResData: THandle;
 begin
      // uses MMSystem
        //sndPlaySound(nil, SND_NODEFAULT); // nil = stop currently playing
        sndPlaySound(AResName.memory, SND_ASYNC or SND_MEMORY);
end;



  Function GetRTFtext(Const RichEdit: TRichEdit): String;
var
  MemoryStream : TMemoryStream;
  RTFText      : AnsiString;
begin
  MemoryStream := TMemoryStream.Create;
  try
    RichEdit.Lines.SaveToStream(MemoryStream);
    MemoryStream.position := 0;
    if MemoryStream.size > 0 then
      SetString(RTFText, pchar(MemoryStream.Memory), MemoryStream.size);
  finally
    FreeAndNil(MemoryStream);
  end;
  Result := String(RTFText);
end;


function StrRemoveCharSet(const S: String; const C: CharSet): String;
var P, Q    : PChar;
    D       : Char;
    I, L, M : Integer;
    R       : Boolean;
begin
  L := Length(S);
  if L = 0 then begin
      Result := '';
      exit;
    end;
  M := 0;
  P := Pointer(S);
  for I := 1 to L do begin
      D := P^;
      {$IFDEF StringIsUnicode}
      if Ord(D) <= $FF then
      {$ENDIF}
        if Char(Ord(D)) in C then
          Inc(M);
      Inc(P);
    end;
  if M = 0 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L - M);
  Q := Pointer(Result);
  P := Pointer(S);
  for I := 1 to L do begin
      D := P^;
      {$IFDEF StringIsUnicode}
      R := Ord(D) > $FF;
      if not R then
      {$ENDIF}
        R := not (Char(Ord(D)) in C);
      if R then begin
          Q^ := P^;
          Inc(Q);
        end;
      Inc(P);
    end;
end;

function GetTextBetween(const Start, Stop: String; var S, Between: String): Boolean;
  var I, J : Integer;
  begin
    I := PosStr(Start, S, 1, False);
    if I > 0 then
      begin
        J := PosStr(Stop, S, 1, False);
        if J = 0 then
          J := Length(S) + 1;
        Between := CopyRange(S, I + Length(Start), J - 1);
        Delete(S, I, J + Length(Stop) - I);
        Between := StrRemoveCharSet(Between, [#0..#32]);
        Result := True;
      end
    else
      Result := False;
  end;



function PosCharSet(const F: CharSet; const S: String; const Index: Integer): Integer;
var P    : PChar;
    C    : Char;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do begin
      C := P^;
      {$IFDEF StringIsUnicode}
      if Ord(C) <= $FF then
      {$ENDIF}
        if Char(Ord(C)) in F then begin
            Result := I;
            exit;
          end else begin
            Inc(P);
            Inc(I);
          end;
    end;
  Result := 0;
end;


function CharSetMatchChar(const A: CharSet; const B: Char; const AsciiCaseSensitive: Boolean): Boolean;
begin
  {$IFDEF StringIsUnicode}
  if Ord(B) > $FF then
    Result := False
  else
  {$ENDIF}
    if AsciiCaseSensitive then
      Result := Char(Ord(B)) in A
    else
      Result := ((Char(Ord(B))) in A) or
                ((Char(Ord(B))) in A);
end;


procedure StrTrimLeftInPlace(var S: String; const C: CharSet);
var F, L : Integer;
    P    : PChar;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and CharSetMatchChar(C, S[F], True) do
    Inc(F);
  if F > L then
    S := '' else
    if F > 1 then
      begin
        L := L - F + 1;
        if L > 0 then
          begin
            P := Pointer(S);
            Inc(P, F - 1);
            MoveMem(P^, Pointer(S)^, L * SizeOf(Char));
          end;
        SetLength(S, L);
      end;
end;

procedure StrTrimRightInPlace(var S: String; const C: CharSet);
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and CharSetMatchChar(C, S[F], True) do
    Dec(F);
  if F = 0 then
    S := ''
  else
    SetLength(S, F);
end;


procedure TrimInPlace(var S : String; const C: CharSet);
begin
  StrTrimLeftInPlace(S, C);
  StrTrimRightInPlace(S, C);
end;

function TrimIn(S : String; const C: CharSet): String;
begin
  StrTrimLeftInPlace(S, C);
  result:= S;
  StrTrimRightInPlace(S, C);
  result:= S;
end;


function StrSplit(const S, D: String): TStringArray;
var I, J, L, M : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  M := Length(D);
  if M = 0 then
    begin
      SetLength(Result, 1);
      Result[0] := S;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosStr(D, S, I, True);
    if I = 0 then
      break;
    Inc(L);
    Inc(I, M);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosStr(D, S, I, True);
    if J = 0 then
      begin
        Result[L] := CopyFrom(S, I);
        break;
      end;
    Result[L] := CopyRange(S, I, J - 1);
    Inc(L);
    I := J + M;
  until False;
end;


function StrRemoveCharDelimited(var S: String;
    const FirstDelim, SecondDelim: Char): String;
var I, J : Integer;
begin
  Result := '';
  I := PosChar(FirstDelim, S,1);
  if I = 0 then
    exit;
  J := PosChar(SecondDelim, S, I + 1);
  if J = 0 then
    exit;
  Result := CopyRange(S, I + 1, J - 1);
  Delete(S, I, J - I + 1);
end;

function CopyLeft(const S: String; const Count: Integer): String;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, 1, Count);
end;

function CopyRight(const S: String; const Count: Integer): String;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, L - Count + 1, Count);
end;

function StrPMatchLen(const P: PChar; const Len: Integer; const M: TSYsCharSet): Integer;
var Q : PChar;
    C : Char;
    L : Integer;
begin
  Q := P;
  L := Len;
  Result := 0;
  if not Assigned(Q) then
    exit;
  while L > 0 do
    begin
      C := Q^;
      {$IFDEF StringIsUnicode}
      if WideCharInCharSet(C, M) then
      {$ELSE}
      if C in M then
      {$ENDIF}
        begin
          Inc(Q);
          Dec(L);
          Inc(Result);
        end
      else
        exit;
    end;
end;

const csNumeric   = [Byte('0')..Byte('9')];


function StrMatchChar(const S: String; const M: TSYsCharSet): Boolean;
var L: Integer;
begin
  L := Length(S);
  Result := (L > 0) and (StrPMatchLen(Pointer(S), L, M) = L);
end;


function StrIsNumeric(const S: String): Boolean;
begin
  Result := StrMatchChar(S, ['0'..'9']);
end;

function StrSplitAtChar(const S: String; const C: Char;
         var Left, Right: String; const Optional: Boolean): Boolean;
var I : Integer;
    T : String;
begin
  I := PosChar(C, S,1);
  Result := I > 0;
  if Result then
    begin
      T := S; // add reference to S (in case it is also Left or Right)
      Left := Copy(T, 1, I - 1);
      Right := CopyFrom(T, I + 1);
    end
  else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;

function StrReplaceChar(const Find, Replace: Char; const S: String): String;
var I, J : Integer;
begin
  Result := S;
  I := PosChar(Find, S,1);
  if I = 0 then
    exit;
  for J := I to Length(S) do
    if S[J] = Find then
      Result[J] := Replace;
end;

function StrInclSuffix(const S: String; const Suffix: String;
  const AsciiCaseSensitive: Boolean): String;
begin
  if not StrMatchRight(S, Suffix, AsciiCaseSensitive) then
    Result := S + Suffix
  else
    Result := S;
end;



procedure SplitRegNameA(const Name: AnsiString; var Key, ValueName: AnsiString);
var S : AnsiString;
    I : Integer;
begin
  //S := StrExclSuffixA(StrExclPrefixA(Name, '\'), '\');
  //I := PosCharA('\', S);
  if I <= 0 then
    begin
      Key := S;
      ValueName := '';
      exit;
    end;
  //Key := CopyLeftA(S, I - 1);
  //ValueName := CopyFromA(S, I + 1);
end;



function RegGetValueA(const RootKey: HKEY; const Name: AnsiString;
         const ValueType: Cardinal; var RegValueType: Cardinal;
         var ValueBuf: Pointer; var ValueSize: Integer): Boolean;
var K, N : AnsiString;
begin
  SplitRegNameA(Name, K, N);
 // Result := RegGetValueA(RootKey, K, N, ValueType, RegValueType, ValueBuf, ValueSize);
end;


function GetRegistryStringA(const RootKey: HKEY; const Key, Name: AnsiString): AnsiString;
var Buf   : Pointer;
    Size  : Integer;
    VType : Cardinal;
begin
  Result := '';
  //if not RegGetValueA(RootKey, Key, Name, REG_SZ, VType, Buf, Size) then
    //exit;
  if (VType = REG_DWORD) and (Size >= Sizeof(LongWord)) then
   // Result := IntToStringA(PLongWord(Buf)^) else
  if Size > 0 then
    begin
      SetLength(Result, Size - 1);
      //MoveMem(Buf^, PAnsiChar(Result)^, Size - 1);
    end;
  FreeMem(Buf);
end;



{                                                                              }
{ Windows Version Info                                                         }
{
                                                                     }

(*
function GetWindowsVersion: TWindowsVersion;
begin
  Case Win32Platform of
    VER_PLATFORM_WIN32s :
      Result := Win16_31;
    VER_PLATFORM_WIN32_WINDOWS :
      if Win32MajorVersion <= 4 then
        Case Win32MinorVersion of
          0..9   : if Trim(Win32CSDVersion, csWhiteSpace) = 'B' then
                     Result := Win32_95R2 else
                     Result := Win32_95;
          10..89 : if Trim(Win32CSDVersion, csWhiteSpace) = 'A' then
                     Result := Win32_98SE else
                     Result := Win32_98;
          90..99 : Result := Win32_ME;
        else
          Result := Win32_Future;
        end
      else
        Result := Win32_Future;
    VER_PLATFORM_WIN32_NT :
      Case Win32MajorVersion of
        3 : Case Win32MinorVersion of
              1, 10..19 : Result := WinNT_31;
              5, 50     : Result := WinNT_35;
              51..99    : Result := WinNT_351;
            else
              Result := WinNT_31;
            end;
        4 : Result := WinNT_40;
        5 : Case Win32MinorVersion of
               0 : Result := WinNT5_2000;
               1 : Result := WinNT5_XP;
               2 : Result := WinNT5_2003;
            else
              Result := WinNT5_Future;
            end;
      else
        Result := WinNT_Future;
      end;
  else
    Result := Win_Future;
  end;
end;     *)

function IsWinPlatform95: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_WINDOWS;
end;

function IsWinPlatformNT: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_NT;
end;

function GetWindowsProductID: String;
begin
  Result := GetRegistryString(HKEY_LOCAL_MACHINE,
         'Software\Microsoft\Windows\CurrentVersion', 'ProductId');
end;



{                                                                              }
{ Windows Paths                                                                }
{                                                                              }
function GetWindowsTemporaryPath: String;
const MaxTempPathLen = MAX_PATH + 1;
var I : LongWord;
begin
  SetLength(Result, MaxTempPathLen);
  I := GetTempPath(MaxTempPathLen, PChar(Result));
  if I > 0 then
    SetLength(Result, I) else
    Result := '';
end;

function GetWindowsPath: String;
const MaxWinPathLen = MAX_PATH + 1;
var I : LongWord;
begin
  SetLength(Result, MaxWinPathLen);
  I := GetWindowsDirectory(PChar(Result), MaxWinPathLen);
  if I > 0 then
    SetLength(Result, I) else
    Result := '';
end;

function GetWindowsSystemPath: String;
const MaxWinSysPathLen = MAX_PATH + 1;
var I : LongWord;
begin
  SetLength(Result, MaxWinSysPathLen);
  I := GetSystemDirectory(PChar(Result), MaxWinSysPathLen);
  if I > 0 then
    SetLength(Result, I) else
    Result := '';
end;

const
  CurrentVersionRegistryKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion';

function GetProgramFilesPath: String;
begin
  Result := GetRegistryString(HKEY_LOCAL_MACHINE, CurrentVersionRegistryKey,
      'ProgramFilesDir');
end;

function GetCommonFilesPath: String;
begin
  Result := GetRegistryString(HKEY_LOCAL_MACHINE, CurrentVersionRegistryKey,
      'CommonFilesDir');
end;

function StrMatch(const S, M: String; const Index: Integer): Boolean;
var N, T, I : Integer;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  for I := 1 to N do
    if M[I] <> S[I + Index - 1] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function StrPMatch(const A, B: PChar; const Len: Integer): Boolean;
var P, Q : PChar;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      if P^ = Q^ then begin
          Inc(P);
          Inc(Q);
        end else begin
          Result := False;
          exit;
        end;
  Result := True;
end;


function CharMatchNoAsciiCase(const A, B: Char): Boolean;
begin
  if (Ord(A) <= $7F) and (Ord(B) <= $7F) then
    //Result := AsciiLowCaseLookup[Ord(A)] = AsciiLowCaseLookup[Ord(B)]
  else
    Result := Ord(A) = Ord(B);
end;



function StrPMatchNoAsciiCase(const A, B: PChar; const Len: Integer): Boolean;
var P, Q : PChar;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      begin
        if CharMatchNoAsciiCase(P^, Q^) then
          begin
            Inc(P);
            Inc(Q);
          end else
          begin
            Result := False;
            exit;
          end;
      end;
  Result := True;
end;

function StrMatchNoAsciiCase(const S, M: String; const Index: Integer = 1): Boolean;
var N, T : Integer;
    Q    : PChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchNoAsciiCase(Pointer(M), Q, N);
end;

function StrMatchRight(const S, M: String; const AsciiCaseSensitive: Boolean): Boolean;
var I: Integer;
begin
  I := Length(S) - Length(M) + 1;
  if AsciiCaseSensitive then
    Result := StrMatch(S, M, I)
  else
    Result := StrMatchNoAsciiCase(S, M, I);
end;

procedure StrEnsureSuffix(var S: String; const Suffix: String;
  const AsciiCaseSensitive: Boolean);
begin
  if (Suffix <> '') and not StrMatchRight(S, Suffix, AsciiCaseSensitive) then
    S := S + Suffix;
end;

function PosStr(const F, S: String; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q    : PChar;
    L, M, I : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  Dec(L, M - 1);
  if AsciiCaseSensitive then
    while I <= L do
      if StrPMatch(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end
  else
    while I <= L do
      if StrPMatchNoAsciiCase(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
  Result := 0;
end;

function GetApplicationPath: String;
begin
  Result := ExtractFilePath(ParamStr(0));
  StrEnsureSuffix(Result, '\', false);
end;



{                                                                              }
{ Identification                                                               }
{                                                                              }
function GetUserName: String;
const MAX_USERNAME_LENGTH = 256;
var L : LongWord;
begin
  L := MAX_USERNAME_LENGTH + 2;
  SetLength(Result, L);
  if Windows.GetUserName(PChar(Result), L) and (L > 0) then
    SetLength(Result, StrLen(PChar(Result))) else
    Result := '';
end;

function GetLocalComputerName: String;
var L : LongWord;
begin
  L := MAX_COMPUTERNAME_LENGTH + 2;
  SetLength(Result, L);
  if Windows.GetComputerName(PChar(Result), L) and (L > 0) then
    SetLength(Result, StrLen(PChar(Result))) else
    Result := '';
end;


procedure SetLengthAndZeroA(var S: AnsiString; const NewLength: Integer);
var L : Integer;
    P : PAnsiChar;
begin
  L := Length(S);
  if L = NewLength then
    exit;
  SetLength(S, NewLength);
  if L > NewLength then
    exit;
  P := Pointer(S);
  Inc(P, L);
  ZeroMem(P^, NewLength - L);
end;

function GetLocalHostName: String;
const MAX_HOST_LENGTH = MAX_PATH;
var WSAData : TWSAData;
    L       : LongWord;
begin
  if WSAStartup($0101, WSAData) = 0 then
    try
      L := MAX_HOST_LENGTH + 2;
      SetLengthAndZeroA(Result, L);
      if GetHostName(PChar(Result), L) = 0 then
        SetLength(Result, StrLen(PChar(Result))) else
        Result := '';
    finally
      WSACleanup;
    end;
end;



{                                                                              }
{ Application Version Info                                                     }
{                                                                              }
var
  VersionInfoBuf : Pointer = nil;
  VerTransStr    : String;

// Returns True if VersionInfo is available
function LoadAppVersionInfo: Boolean;
type TTransBuffer = Array [1..4] of SmallInt;
     PTransBuffer = ^TTransBuffer;
var InfoSize : Integer;
    Size, H  : LongWord;
    EXEName  : String;
    Trans    : PTransBuffer;
begin
  Result := Assigned(VersionInfoBuf);
  if Result then
    exit;
  EXEName := ParamStr(0);
  InfoSize := GetFileVersionInfoSize(PChar(EXEName), H);
  if InfoSize = 0 then
    exit;
  GetMem(VersionInfoBuf, InfoSize);
  if not GetFileVersionInfo(PChar(EXEName), H, InfoSize, VersionInfoBuf) then
    begin
      FreeMem(VersionInfoBuf);
      VersionInfoBuf := nil;
      exit;
    end;
  VerQueryValue(VersionInfoBuf, PChar('\VarFileInfo\Translation'),
                 Pointer(Trans), Size);
  VerTransStr := IntToHex(Trans^ [1], 4) + IntToHex(Trans^ [2], 4);
  Result := True;
end;

const
  VersionInfoStr: Array [TVersionInfo] of String =
    ('FileVersion', 'FileDescription', 'LegalCopyright', 'Comments',
     'CompanyName', 'InternalName', 'LegalTrademarks',
     'OriginalFilename', 'ProductName', 'ProductVersion');

function GetAppVersionInfo(const VersionInfo: TVersionInfo): String;
var S     : String;
    Size  : LongWord;
    Value : PChar;
begin
  Result := '';
  if not LoadAppVersionInfo then
    exit;
  S := 'StringFileInfo\' + VerTransStr + '\' + VersionInfoStr[VersionInfo];
  if VerQueryvalue(VersionInfoBuf, PChar(S), Pointer(Value), Size) then
    Result := Value;
end;



{                                                                              }
{ Windows Processes                                                            }
{                                                                              }
function WinExecute(const ExeName, Params: String; const ShowWin: Word;
    const Wait: Boolean): Boolean;
var StartUpInfo : TStartupInfo;
    ProcessInfo	: TProcessInformation;
    Cmd         : String;
begin
  if Params = '' then
    Cmd := ExeName else
    Cmd := ExeName + ' ' + Params;
  FillChar(StartUpInfo, SizeOf(StartUpInfo), #0);
  StartUpInfo.cb := SizeOf(StartUpInfo);
  StartUpInfo.dwFlags := STARTF_USESHOWWINDOW; // STARTF_USESTDHANDLES
  StartUpInfo.wShowWindow := ShowWin;
  Result := CreateProcess(
           nil, PChar(Cmd), nil, nil, False,
           CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
           PChar(ExtractFilePath(ExeName)), StartUpInfo, ProcessInfo);
  if Wait then
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
end;


procedure StrSplit4(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

function StrSplit4F(Delimiter: Char; Str: string): TStrings;
begin
   result:= TStringlist.Create;
   result.Clear;
   result.Delimiter       := Delimiter;
   result.StrictDelimiter := True; // Requires D2006 or newer.
   result.DelimitedText   := Str;
end;

function Int32toBytes(const Cint: Integer): TBytes;
begin
  setlength(result,3);
  result[0]:= Cint and $FF;
  result[1]:= (Cint shr 8) and $FF;
  result[2]:= (Cint shr 16) and $FF;
end;

{                                                                              }
{ Windows Fibers                                                               }
{                                                                              }
function ConvertThreadToFiber; external kernel32 name 'ConvertThreadToFiber';
function CreateFiber(dwStackSize: DWORD; lpStartAddress: TFNFiberStartRoutine;
         lpParameter: Pointer): Pointer; external kernel32 name 'CreateFiber';

  //type StringArray = array of string;

{                                                                              }
{ Miscelleaneous Windows API                                                   }
{                                                                              }
function GetEnvironmentStrings: TStringArray;
var P, Q : PChar;
    I : Integer;
    S : String;
begin
  P := PChar(Windows.GetEnvironmentStrings);
  try
    if P^ <> #0 then
      Repeat
        Q := P;
        I := 0;
        While Q^ <> #0 do
          begin
            Inc(Q);
            Inc(I);
          end;
        SetLength(S, I);
        if I > 0 then
          Move(P^, Pointer(S)^, I);
       // Append(Result, S);
        P := Q;
        Inc(P);
      Until P^ = #0;
  finally
    FreeEnvironmentStrings(P);
  end;
end;

function ContentTypeFromExtention(Extention: String): String;
begin
  Result := GetRegistryString(HKEY_CLASSES_ROOT, '\' + Extention, 'Content Type');
end;


{function StrPMatch(const A, B: PChar; const Len: Integer): Boolean;
var P, Q : PChar;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      if P^ = Q^ then
        begin
          Inc(P);
          Inc(Q);
        end else
        begin
          Result := False;
          exit;
        end;
  Result := True;
end;   }


function StrEqualNoCase(const A, B: String; const AsciiCaseSensitive: Boolean): Boolean;
var L1, L2 : Integer;
begin
  L1 := Length(A);
  L2 := Length(B);
  Result := L1 = L2;
  if not Result or (L1 = 0) then
    exit;
  if AsciiCaseSensitive then
    Result := StrPMatch(Pointer(A), Pointer(B), L1)
  else
    Result := StrPMatchNoAsciiCase(Pointer(A), Pointer(B), L1);
end;

const
  AutoRunRegistryKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run';

function IsApplicationAutoRun(const Name: String): Boolean;
var S : String;
begin
  S := ParamStr(0);
  Result := (S <> '') and (Name <> '') and
      StrEqualNoCase(GetRegistryString(HKEY_LOCAL_MACHINE, AutoRunRegistryKey, Name), S, False);
end;

procedure SetApplicationAutoRun(const Name: String; const AutoRun: Boolean);
begin
  if Name = '' then
    exit;
  if AutoRun then
  //WriteToRegistry(HKEY_LOCAL_MACHINE,AutoRunRegistryKey,name, ParamStr(0))else
    //SetRegistryString(HKEY_LOCAL_MACHINE, AutoRunRegistryKey, Name, ParamStr(0)) else
    //DeleteRegistryValue(HKEY_LOCAL_MACHINE, AutoRunRegistryKey, Name);
end;

function GetWinPortNames: TStringArray;
var BytesNeeded, N, I : LongWord;
    Buf : Pointer;
    InfoPtr : PPortInfo1;
    TempStr : String;
begin
  Result := nil;
  if EnumPorts(nil, 1, nil, 0, BytesNeeded, N) then
    exit;
  if GetLastError <> ERROR_INSUFFICIENT_BUFFER then
    RaiseLastOSError;
  GetMem(Buf, BytesNeeded);
  try
    if not EnumPorts(nil, 1, Buf, BytesNeeded, BytesNeeded, N) then
      RaiseLastOSError;
      SetLength(result, N);
    For I := 0 to N - 1 do begin
        InfoPtr := PPortInfo1(LongWord(Buf) + I * SizeOf(TPortInfo1));
        TempStr := InfoPtr^.pName;
        //Append(Result^, (TempStr));
        result[i]:= result[i]+ tempstr;
      end;
  finally
    FreeMem(Buf);
  end;
end;

function GetKeyPressed(const VKeyCode: Integer): Boolean;
begin
  Result := GetKeyState(VKeyCode) and $80 <> 0;
end;

function Reboot: Boolean;
const SE_SHUTDOWN_NAME = 'SeShutDownPrivilege';
var VersionInfo: TOSVersionInfo;
    hToken: Cardinal;
    tkp: TTokenPrivileges;
    retval: Cardinal;
begin
  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);
  if IsWinPlatformNT then
    if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
      begin
        LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME, tkp.Privileges[0].Luid);
        tkp.PrivilegeCount := 1;
        tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        AdjustTokenPrivileges(hToken, false, tkp, 0, tkp, retval);
      end;
  Result := ExitWindowsEx(EWX_FORCE or EWX_REBOOT, 0);
end;



{                                                                              }
{ WinInet API                                                                  }
{                                                                              }
const
  IEProtoPrefix : Array[TIEProxy] of String =
      ('http=', 'https=', 'ftp=', 'gopher=', 'socks=');


function PosChar(const F: Char; const S: String; const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if S[I] = F then begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;


function CopyFrom(const S: String; const Index: Integer): String;
var L : Integer;
begin
  if Index <= 1 then
    Result := S
  else begin
      L := Length(S);
      if (L = 0) or (Index > L) then
        Result := ''
      else
        Result := Copy(S, Index, L - Index + 1);
    end;
end;


function CopyRange(const S: String; const StartIndex, StopIndex: Integer): String;
var L, I : Integer;
begin
  L := Length(S);
  if (StartIndex > StopIndex) or (StopIndex < 1) or (StartIndex > L) or (L = 0) then
    Result := ''
  else begin
      if StartIndex <= 1 then
        if StopIndex >= L then begin
            Result := S;
            exit;
          end
        else
          I := 1
      else
        I := StartIndex;
      Result := Copy(S, I, StopIndex - I + 1);
    end;
end;

 function StrMatchLeft(const S, M: String; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrMatch(S, M, 1)
  else
    Result := StrMatchNoAsciiCase(S, M, 1);
    //Result := StrMatches(S, M, 1);                   //bug not fixed
    //Result := IsMatch(S, M);                   //bug not fixed
    //result:=  AnsiMatchText(M, [S]);
end;

{function StrMatchRight(const S, M: String; const AsciiCaseSensitive: Boolean): Boolean;
var I: Integer;
begin
  I := Length(S) - Length(M) + 1;
  if AsciiCaseSensitive then
    Result := StrMatch(S, M, I)
  else
    Result := StrMatchNoAsciiCase(S, M, I);
end;  }



function StrSplitChar(const S: String; const D: Char): TStringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosChar(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosChar(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFrom(S, I);
        break;
      end;
    Result[L] := CopyRange(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;

function StrAfterCharSet(const S: String; const D: CharSet): String;
var I : Integer;
begin
  I := PosCharSet(D, S,1);
  if I = 0 then
    Result := ''
  else
    Result := CopyFrom(S, I + 1);
end;

function StrAfterChar(const S: String; const D: Char): String;
var I : Integer;
begin
  I := PosChar(D, S,1);
  if I = 0 then
    Result := ''
  else
    Result := CopyFrom(S, I + 1);
end;


function GetIEProxy(const Protocol: TIEProxy): String;
var ProxyInfo : PInternetProxyInfo;
    Len       : LongWord;
    Proxies   : TStringArray;
    I         : Integer;
begin
  Proxies := nil;
  Result := '';
  Len := 4096;
  GetMem(ProxyInfo, Len);
  try
    if InternetQueryOption(nil, INTERNET_OPTION_PROXY, ProxyInfo, Len) then
      if ProxyInfo^.dwAccessType = INTERNET_OPEN_TYPE_PROXY then
        begin
          Result := ProxyInfo^.lpszProxy;
          if PosChar('=', Result,1) = 0 then // same proxy for all protocols
            exit;
          // Find proxy for Protocol
          Proxies := StrSplitChar(Result, ' ');
          For I := 0 to Length(Proxies) - 1 do
            if StrMatchLeft(Proxies[I], IEProtoPrefix[Protocol], False) then begin
                Result := StrAfterChar(Proxies[I], '=');
                exit;
              end;  //}
          // No proxy for Protocol
          Result := '';
        end;
  finally
    FreeMem(ProxyInfo);
  end;
end;

function GetHardDiskSerialNumber(const DriveLetter: Char): String;
var N, F, S : DWORD;
begin
  S := 0;
  GetVolumeInformation(PChar(DriveLetter + ':\'), nil, MAX_PATH + 1, @S,
      N, F, nil, 0);
  Result := LongWordToHex(S, 8);
end;

{                                                                              }
{ TWindowHandle                                                                }
{                                                                              }
function WindowHandleMessageProc(const WindowHandle: HWND; const Msg: Cardinal;
    const wParam, lParam: Integer): Integer; stdcall;
var V : TObject;
begin
  V := TObject(GetWindowLong(WindowHandle, 0)); // Get user data
  if V is TWindowHandle then
    Result := TWindowHandle(V).MessageProc(Msg, wParam, lParam) else
    Result := DefWindowProc(WindowHandle, Msg, wParam, lParam); // Default handler
end;

var
  WindowClass: TWndClass = (
      style         : 0;
      lpfnWndProc   : @WindowHandleMessageProc;
      cbClsExtra    : 0;
      cbWndExtra    : SizeOf(Pointer); // Size of extra user data
      hInstance     : 0;
      hIcon         : 0;
      hCursor       : 0;
      hbrBackground : 0;
      lpszMenuName  : nil;
      lpszClassName : 'FundamentalsWindowClass');

Destructor TWindowHandle.Destroy;
begin
  DestroyWindowHandle;
  inherited Destroy;
end;

procedure TWindowHandle.RaiseError(const Msg: String);
begin
  raise EWindowHandle.Create(Msg);
end;

function TWindowHandle.AllocateWindowHandle: HWND;
var C : TWndClass;
begin
  WindowClass.hInstance := HInstance;
  // Register class
  if not GetClassInfo(HInstance, WindowClass.lpszClassName, C) then
    if Windows.RegisterClass(WindowClass) = 0 then
      RaiseError('Window class registration failed: Windows error #' + IntToStr(GetLastError));

  // Allocate handle
  Result := CreateWindowEx(WS_EX_TOOLWINDOW,
                           WindowClass.lpszClassName,
                           '',        { Window name   }
                           WS_POPUP,  { Window Style  }
                           0, 0,      { X, Y          }
                           0, 0,      { Width, Height }
                           0,         { hWndParent    }
                           0,         { hMenu         }
                           HInstance, { hInstance     }
                           nil);      { CreateParam   }
  if Result = 0 then
    RaiseError('Window handle allocation failed: Windows error #' + IntToStr(GetLastError));

  // Set user data
  SetWindowLong(Result, 0, Integer(self));
end;

function TWindowHandle.HandleWM(const Msg: Cardinal; const wParam, lParam: Integer): Integer;
var Handled : Boolean;
begin
  Result := 0;
  Handled := False;
  if Assigned(FOnMessage) then
    Result := FOnMessage(Msg, wParam, lParam, Handled);
  if not Handled then
    Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam); // Default handler
end;

function TWindowHandle.MessageProc(const Msg: Cardinal; const wParam, lParam: Integer): Integer;
var R : Boolean;
begin
  if Assigned(FOnBeforeMessage) then
    FOnBeforeMessage(self);
  R := Assigned(FOnAfterMessage);
  try
    try
      Result := HandleWM(Msg, wParam, lParam);
    except
      on E : Exception do
        begin
          if Assigned(FOnException) then
            FOnException(self, E);
          Result := 0;
        end;
    end;
  finally
    if R then
      if Assigned(FOnAfterMessage) then
        FOnAfterMessage(self);
  end;
end;

function TWindowHandle.GetWindowHandle: HWND;
begin
  Result := FWindowHandle;
  if Result = 0 then
    begin
      FWindowHandle := AllocateWindowHandle;
      Result := FWindowHandle;
    end;
end;

procedure TWindowHandle.DestroyWindowHandle;
begin
  if FWindowHandle = 0 then
    exit;

  // Clear user data
  SetWindowLong(FWindowHandle, 0, 0);

  DestroyWindow(FWindowHandle);
  FWindowHandle := 0;
end;

function TWindowHandle.ProcessMessage: Boolean;
var Msg : TMsg;
begin
  if FTerminated then
    begin
      Result := False;
      exit;
    end;
  Result := PeekMessage(Msg, 0, 0, 0, PM_REMOVE);
  if Result then
    if Msg.Message = WM_QUIT then
      FTerminated := True else
      if FTerminated then
        Result := False else
        begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        end;
end;

procedure TWindowHandle.ProcessMessages;
begin
  While ProcessMessage do ;
end;

function TWindowHandle.HandleMessage: Boolean;
var Msg : TMsg;
begin
  if FTerminated then
    begin
      Result := False;
      exit;
    end;
  Result := GetMessage(Msg, 0, 0, 0);
  if not Result then
    FTerminated := True else
    if FTerminated then
      Result := False else
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg)
      end;
end;

procedure TWindowHandle.MessageLoop;
begin
  While HandleMessage do ;
end;

procedure TWindowHandle.Terminate;
begin
  FTerminated := True;
end;



{                                                                              }
{ TTimerHandle                                                                 }
{                                                                              }
Constructor TTimerHandle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimerInterval := 1000;
end;

procedure TTimerHandle.DestroyWindowHandle;
begin
  if not (csDesigning in ComponentState) and (FWindowHandle <> 0) and
      FTimerActive then
    KillTimer(FWindowHandle, 1);
  inherited DestroyWindowHandle;
end;

function TTimerHandle.DoSetTimer: Boolean;
begin
  if FTimerInterval <= 0 then
    Result := False
  else
    Result := SetTimer (GetWindowHandle, 1, FTimerInterval, nil) = 0;
end;

procedure TTimerHandle.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) and FTimerActive then
    DoSetTimer;
end;

procedure TTimerHandle.TriggerTimer;
begin
  if Assigned(FOnTimer) then
    FOnTimer(self);
end;

procedure TTimerHandle.SetTimerActive(const TimerActive: Boolean);
begin
  if FTimerActive = TimerActive then
    exit;
  if [csDesigning, csLoading] * ComponentState = [] then
    if TimerActive then
      begin
        if not DoSetTimer then
          exit;
      end else
      KillTimer(FWindowHandle, 1);
  FTimerActive := TimerActive;
end;

function TTimerHandle.HandleWM(const Msg: Cardinal; const wParam, lParam: Integer): Integer;
begin
  if Msg = WM_TIMER then
    try
      Result := 0;
      TriggerTimer;
    except
      on E: Exception do
        begin
          Result := 0;
          if Assigned(FOnException) then
            FOnException(self, E);
          exit;
        end;
    end
  else
    Result := inherited HandleWM(Msg, wParam, lParam);
end;



initialization
finalization
  if Assigned(VersionInfoBuf) then
    FreeMem(VersionInfoBuf);
end.

