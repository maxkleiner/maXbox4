unit udf_glob;

interface

uses
  Windows, SysUtils, ibase;

(*
 * Define FREE_IT if you want to use the free_it clause with your stuff
 *  - uncomment below "commented" define
 *)

{//$define FREE_IT}
{$define FULDebug}

type
  (*
   * TThreadLocalVariables
   *   This structure is set up to contain all structures for maintaining
   *   thread-local stuff.
   * Use this in conjunction with ThreadLocals....
   * This makes it easy to maintain an virtually unlimited number of thread
   * locals.
   *)
  TThreadLocalVariables = class(TObject)
  protected
    FPChar: PChar;
    FPCharSize: DWord;
    FQuad: PISC_QUAD;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TLibEntryProc = procedure(Reason: Integer);

function MakeResultString(Source, OptionalDest: PChar; Len: DWORD): PChar;
function MakeResultQuad(Source, OptionalDest: PISC_QUAD): PISC_QUAD;

function ThreadLocals: TThreadLocalVariables;
{$ifdef FULDebug}
procedure WriteDebug(sz: String);
{$endif}

var
  hThreadLocalVariables: Integer;         (* Index to thread-local storage *)
  {$ifdef FULDebug}
  bDebug: Boolean;
  csDebugFile: TRTLCriticalSection;
  hDebugFile: THandle;
  szDebugFile: PChar;
  szDebugFileLength: Integer;
  {$endif}

const
  UDF_SUCCESS = 0;
  UDF_FAILURE = 1;
  cSignificantlyLarger = 1024 * 4;  // We don't want strings to be more than
                                    // 4k larger than what we're actually
                                    // passing back.

implementation

uses IFSI_WinForm1puzzle;

function malloc(Size: Integer): Pointer; cdecl; external 'msvcrt.dll';

function MakeResultString(Source, OptionalDest: PChar; Len: DWORD): PChar;
begin
  result := OptionalDest;
  if (result = nil) then begin
    if (Len = 0) then
      Len := StrLen(Source) + 1;
    {$ifdef FREE_IT}
    result := malloc(Len);
    {$else}
    with ThreadLocals do begin
      (*
       * If the current PChar is smaller than than Source, or
       * it is significanly larger than Source, then reallocate it
       * in cSignificantlyLarger chunks.
       *)
      if (FPCharSize < Len) or
         (FPCharSize > Len + cSignificantlyLarger) then begin
        FPCharSize := 0;
        (*
         * Realistically, we'll never return strings longer than about
         * 2k, so I'd rather risk spending time in a loop that *adds* than
         * "compute" FPCharSize by performing division and modulo arithmetic.
         * Addition is very fast, and the while loop will in general, only
         * be at most 1 to 2 steps.
         *)
        while (FPCharSize < Len) do
          Inc(FPCharSize, cSignificantlyLarger);
        ReallocMem(FPChar, FPCharSize);
      end;
      result := FPChar;
    end;
    {$endif}
  end;
  if (Source <> result) then begin
    if (Source = nil) or (Len = 1) then
      result[0] := #0
    else
      Move(Source^, result^, Len);
  end;
end;

function MakeResultQuad(Source, OptionalDest: PISC_QUAD): PISC_QUAD;
begin
  result := OptionalDest;
  if (result = nil) then
    {$ifdef FREE_IT}
    result := malloc(SizeOf(TISC_QUAD));
    {$else}
    result := ThreadLocals.FQuad;
    {$endif}
  if (Source <> nil) then
    Move(Source^, result^, SizeOf(TISC_QUAD));
end;

(* TThreadLocalVariables *)
constructor TThreadLocalVariables.Create;
begin
  {$ifdef FULDebug}
  WriteDebug('TThreadLocalVariables.Create - Enter');
  {$endif}
  ReallocMem(FPChar, cSignificantlyLarger);
  FPCharSize := cSignificantlyLarger;
  ReallocMem(FQuad, SizeOf(TISC_QUAD));
  {$ifdef FULDebug}
  WriteDebug('TThreadLocalVariables.Create - Exit');
  {$endif}
end;

destructor TThreadLocalVariables.Destroy;
begin
  {$ifdef FULDebug}
  WriteDebug('TThreadLocalVariables.Destroy - Enter');
  {$endif}
  inherited;
  {$ifdef FULDebug}
  WriteDebug('TThreadLocalVariables.Destroy - Exit');
  {$endif}
end;

function ThreadLocals: TThreadLocalVariables;
begin
  {$ifdef FULDebug}
  WriteDebug('ThreadLocals - Enter');
  {$endif}
  result := TLSGetValue(hThreadLocalVariables);
  if result = nil then begin
    result := TThreadLocalVariables.Create;
    TLSSetValue(hThreadLocalVariables, result);
  end;
  {$ifdef FULDebug}
  WriteDebug('ThreadLocals - Exit');
  {$endif}
end;

(*
 * LibEntry -
 *  Used for the initialization of all threads but the primary thread.
 *  Used for the finalization of all threads.
 *)
procedure LibEntry(Reason: Integer);
begin
  if Reason = DLL_THREAD_DETACH then begin
    {$ifdef FULDebug}
    WriteDebug('LibEntry(DLL_THREAD_DETACH) - Enter');
    {$endif}
    ThreadLocals.Free;
    TLSSetValue(hThreadLocalVariables, nil);
    {$ifdef FULDebug}
    WriteDebug('LibEntry(DLL_THREAD_DETACH) - Exit');
    {$endif}
  end;
end;

{$ifdef FULDebug}
procedure WriteDebug(sz: String);
var
  BytesWritten: DWord;
begin
  if not bDebug then exit;
  EnterCriticalSection(csDebugFile);
  try
     // hFile := CreateFile(PChar('LPT1:'), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
   { H:= CreateFile(PChar('\\.\D:'), GENERIC_READ,
    FILE_SHARE_WRITE or FILE_SHARE_READ, nil,
    OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if H = INVALID_HANDLE_VALUE then
    raise Exception.Create(Format('Oops - error opening disk: %d', [GetLastError])}
   // HANDLE hfile = CreateFile("c:\\windows\\test.txt", GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    hDebugFile := CreateFile(pchar(Exepath+'\mXszDebugFile.txt'), GENERIC_WRITE, 0, nil,
                             CREATE_ALWAYS,
                             FILE_ATTRIBUTE_NORMAL,
                             0);

    WriteFile(hDebugFile, PChar(sz + #13 + #10)^, Length(sz) + 2, BytesWritten, nil);
  finally
    LeaveCriticalSection(csDebugFile);
    FlushFileBuffers(hDebugFile);
    CloseHandle(hDebugFile);
 end;
end;
{$endif}

(*initialization

  (*
   * IsMultiThread *must* be set to true for the Delphi Memory Manager to
   * work correctly.
   *)
 (*IsMultiThread := True;
  hThreadLocalVariables := TLSAlloc;
  if (hThreadLocalVariables = -1) then
    raise Exception.Create('FREEUDFLIB: Error instantiating TLS');
  DllProc := @LibEntry;

  {$ifdef FULDebug}
  bDebug := False;
  szDebugFileLength := GetEnvironmentVariable('FreeUDFLibDebugFile', nil, 0);
  if szDebugFileLength <> 0 then begin
    GetMem(szDebugFile, szDebugFileLength + 1);
    GetEnvironmentVariable('FreeUDFLibDebugFile', szDebugFile, szDebugFileLength + 1);
    hDebugFile := CreateFile(szDebugFile, GENERIC_WRITE, 0, nil,
                             CREATE_ALWAYS,
                             FILE_ATTRIBUTE_NORMAL,
                             0);
   InitializeCriticalSection(csDebugFile);
   bDebug := True;
  end;
  {$endif}    *)


(*finalization
  // Just make sure that the thread local variables in the main thread
  // are freed.
  ThreadLocals.Free;
  TLSSetValue(hThreadLocalVariables, nil);
  if (hThreadLocalVariables <> -1) then
    TLSFree(hThreadLocalVariables);

  {$ifdef FULDebug}
  FlushFileBuffers(hDebugFile);
  CloseHandle(hDebugFile);
  DeleteCriticalSection(csDebugFile);
  FreeMem(szDebugFile);
  {$endif}  *)

end.
