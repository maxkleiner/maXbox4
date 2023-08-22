//------------------------------------------------------------------------------
// Named Pipes class implementation
// Copyright (c) 2006 Jens Geyer und Toolbox-Verlag.
//------------------------------------------------------------------------------
unit NamedPipes;

interface

uses Classes, Windows, SysUtils, Math, SyncObjs;

const
  DEFAULT_PIPE_BUFFER_SIZE = 4096;
  DEFAULT_PIPE_TIMEOUT     = 5000;  // Millisekunden
  PIPE_NAMING_SCHEME       = '\\%s\pipe\%s';

  // andere häufíg benötigte Konstanten
  WAIT_ERROR = DWORD($FFFFFFFF);
  WAIT_OBJECT_1 = WAIT_OBJECT_0 + 1;

  // aus ntstatus.h
  STATUS_SUCCESS         =  $00000000;
  STATUS_BUFFER_OVERFLOW =  $80000005;

type
  TPipeDirection = ( pdir_Duplex, pdir_ClientToServer, pdir_ServerToClient);
  TPipeType      = ( ptyp_ByteByte,   // write Bytes, read Bytes
                     ptyp_MsgByte,    // write Message, read Bytes
                     ptyp_MsgMsg      // write Message, read Message
                   );

  TOverlappedResult = ( ov_Failed,    // Fehlschlag, Timeout, Benutzerabbruch
                        ov_Pending,   // I/O operation läuft noch
                        ov_MoreData,  // Daten im Buffer, weitere Daten verfügbar
                        ov_Complete   // Daten im Buffer, Übertragung abgeschlossen
                      );

  // Basisklasse für Named Pipes
  TNamedPipe = class( TObject)
  protected
    FHandle       : THandle;
    FName         : string;
    FWriteThrough : Boolean;
    FOverlapped   : Boolean;
    FOverlapData  : OVERLAPPED;
    FEvent        : TEvent;

    procedure SetOverlapped( aValue : Boolean);
    function  GetOverlappedResult( var dwTransmitted : DWORD; evAbort : TEvent) : TOverlappedResult;
    function  OverlappedWait( evAbort : TEvent) : Boolean;
    function  QueryAbort( evAbort : TEvent) : Boolean;

  public
    constructor Create( const aName : string);
    destructor Destroy;  override;

    procedure Close;
    property  Handle : THandle read FHandle;

    // Overlapped
    function  CancelIO : Boolean;
    function  IsIoComplete( var dwBytesDone : DWORD) : Boolean;

    // Parameter
    property  WriteThrough : Boolean   read FWriteThrough write FWriteThrough;
    property  Overlapped   : Boolean   read FOverlapped   write SetOverlapped;
    property  Event        : TEvent    read FEvent;
  end;


  // Server-Ende einer Named Pipe
  TServerPipe = class( TNamedPipe)
  protected
    FDirection     : TPipeDirection;
    // Security-Flags noch nicht implementiert
    FPipeType      : TPipeType;
    FMaxInstances  : DWORD;
    FDefTimeout    : DWORD;

    // der verwendete Security-Descriptor
    FSD : SECURITY_DESCRIPTOR;

    function  GetOpenMode : DWORD;
    function  GetPipeMode : DWORD;

  public
    constructor Create( const aName : string; aDir : TPipeDirection = pdir_Duplex);
    destructor Destroy;  override;

    function  Open : Boolean;
    procedure DisconnectClient;
    function  WaitForClientConnect : Boolean;

    // Clientdaten lesen, Antwortdaten schreiben
    function  ReadInputData( aStream : TStream) : Boolean;
    function  WriteOutputData( aStream : TStream) : Boolean;

    // Parameter
    property  Direction  : TPipeDirection read FDirection    write FDirection;
    property  PipeType   : TPipeType      read FPipeType     write FPipeType;
  end;


  // Client-Ende einer Named Pipe
  TClientPipe = class( TNamedPipe)
  protected
    FServer : string;
    FTimeout : DWORD;
    FReadMessages : Boolean;

    function  GetFileAttribs : DWORD;

  public
    constructor Create( const aName : string; const aServer : string = '');
    function  Open( evAbort : TEvent) : Boolean;

    // die beiden Methoden bauen aufeinander auf
    function  Transact( const aInput : string; var aOutput : string; evAbort : TEvent = nil) : Boolean;  overload;
    function  Transact( aInput, aOutput : TStream; evAbort : TEvent = nil) : Boolean;  overload;

    // Was kommt aus der Pipe: Bytes oder Messages?
    property  ReadMessages : Boolean read FReadMessages write FReadMessages;

    // Basis-Timeout für Pipe.Open()
    property  Timeout : DWORD  read FTimeout write FTimeout;
  end;


// Berechnet ein variables Timeout, welches um den Wert aBasis streut (± 25%)
function CalculateTimeout( aBasis : DWORD) : DWORD;

// function statt Macro
function HasOverlappedIoCompleted(const ov : OVERLAPPED) : Boolean;
function GetOverlappedPipeResult( aHandle : THandle; const ov : OVERLAPPED; var dwBytes : DWORD; bWait : Boolean) : TOverlappedResult;

// Konvertierung eines Strings in einen Stream und zurück
function  GetStreamAsText( stm : TStream) : string;
procedure SetStreamAsText( const aTxt : string; stm : TStream);


implementation


function CalculateTimeout( aBasis : DWORD) : DWORD;
// Berechnet ein variables Timeout, welches um den Wert aBasis streut (± 25%)
// Ein variables Timeout kann in bestimmten Fällen die Warscheinlichkeit
// von Kollisionen vermindern und sorgt damit für bessere Skalierbarkeit
var i : Integer;
begin
  case aBasis of
    0 :  result := aBasis;
    INFINITE : result := aBasis;
  else
    ASSERT( (1.0*aBasis) < (1.25*MAXINT));  // sonst Algorithmus anpassen
    i := max( aBasis, 0);
    i := round(i * 0.75) + Random(i div 2);  // Timeout = aBasis ± 25%
    result := DWORD(i);
  end;
end;



// function statt Macro
function HasOverlappedIoCompleted( const ov : OVERLAPPED) : Boolean;
// The HasOverlappedIoCompleted macro provides a high performance test operation
// that can be used to poll for the completion of an outstanding I/O operation.
begin
  { Pascal-Äquivalent zu:
    #define HasOverlappedIoCompleted(lpOverlapped)
      ((lpOverlapped)->Internal != STATUS_PENDING)
  }
  result := (ov.Internal <> STATUS_PENDING);
end;


function GetOverlappedPipeResult( aHandle : THandle; const ov : OVERLAPPED; var dwBytes : DWORD; bWait : Boolean) : TOverlappedResult;
{ Mit der normalen API-Funktion ist das Ermitteln des Pipestatus relativ
  schwierig. Besonders problematisch ist es, das Ende einer Overlapped-I/O-
  Operation bei Pipes korrekt festzustellen.

  Wir greifen deshalb hier direkt auf das OVERLAPPED-Statusfeld zu, um die
  uns interessierenden zusätzliche Informationen zu erhalten. Das Statusfeld
  ist im PSDK dokumentiert, allerdings nur lückenhaft.
}
begin
  // Im Wait-Fall zunächst die API-Funktion aufrufen
  if bWait then Windows.GetOverlappedResult( aHandle, ov, dwBytes, TRUE);

  case ov.Internal of
    STATUS_PENDING : begin
      result  := ov_Pending;
      dwBytes := 0;
    end;

    STATUS_BUFFER_OVERFLOW :  begin
      result  := ov_MoreData;
      dwBytes := ov.InternalHigh;
    end;

    STATUS_SUCCESS : begin
      result  := ov_Complete;
      dwBytes := ov.InternalHigh;
    end;

  else
    OutputDebugString( PChar( 'GetOverlappedPipeResult: Unknown ov.Internal = $'+IntToHex(ov.Internal,8)+#10));
    ASSERT( FALSE);
    result  := ov_Failed;  // unbekannter Statuscode, warsch. Fehler
    dwBytes := 0;
  end;
end;


function GetStreamAsText( stm : TStream) : string;
// Liefert den Inhalt von stm als String
begin
  SetString( result, nil, stm.Size);   // benötigten Speicher allozieren
  stm.Position := 0;
  if stm.Size > 0 then stm.ReadBuffer( result[1], stm.Size);
end;


procedure SetStreamAsText( const aTxt : string; stm : TStream);
// Inhalt von stm mit dem Inhalt des Textes ersetzen
begin
  stm.Position := 0;
  if aTxt <> '' then stm.WriteBuffer( PChar(aTxt)^, Length(aTxt));
  stm.Size := stm.Position;  // falls hinten etwas übersteht
end;


//--- TNamedPipe ---------------------------------------------------------------


constructor TNamedPipe.Create( const aName : string);
begin
  inherited Create;
  FHandle := INVALID_HANDLE_VALUE;
  FName   := aName;
  ASSERT( aName <> '');

  // Setup Parameter mit praktikablen Defaults
  FWriteThrough := FALSE;
  FOverlapped   := FALSE;
  FEvent        := nil;
  FillChar( FOverlapData, SizeOf(FOverlapData), 0);
end;


destructor TNamedPipe.Destroy;
begin
  try
    Close;
    FOverlapData.hEvent := INVALID_HANDLE_VALUE;
    FreeAndNil(FEvent);
  finally
    inherited Destroy;
  end;
end;


procedure TNamedPipe.Close;
begin
  if FHandle <> INVALID_HANDLE_VALUE then begin
    CancelIO;
    CloseHandle( FHandle);
    FHandle := INVALID_HANDLE_VALUE;
  end;
end;


function TNamedPipe.CancelIO;
begin
  result := Windows.CancelIo( FHandle);
end;


procedure TNamedPipe.SetOverlapped( aValue : Boolean);
// eine Veränderung des Modus schließt zwingend die Pipe
begin
  if FOverlapped <> aValue then begin
    Close;
    FOverlapped := aValue;

    // für Overlapped Mode ggf. den Event initialisieren
    // und das Handle in den OVERLAPPED-Daten einsetzen
    if FOverlapped and (FEvent = nil) then begin
      FEvent := TEvent.Create( nil, TRUE, FALSE, '');  // muß ManualReset sein, siehe Dok.
      FOverlapData.hEvent := FEvent.Handle;
    end;
  end;
end;


function TNamedPipe.IsIoComplete( var dwBytesDone : DWORD) : Boolean;
// Ermittelt im asynchronen Betrieb den Status der IO-Operation
// Liefert TRUE, wenn die Operation abgeschlossen ist, sonst FALSE
// Im bei nichtgeöffneter Pipe wird ebenfalls TRUE geliefert.
begin
  dwBytesDone := 0;

  // Pipe nicht offen?
  if (FHandle = INVALID_HANDLE_VALUE) then begin
    result := TRUE;
    Exit;
  end;

  // Teste letzte I/O-Operation
  result := Windows.GetOverlappedResult( FHandle, FOverlapData, dwBytesDone, FALSE);
  ASSERT( result or (GetLastError = ERROR_IO_INCOMPLETE));  // INCOMPLETE, nicht PENDING
end;


function TNamedPipe.GetOverlappedResult( var dwTransmitted : DWORD; evAbort : TEvent) : TOverlappedResult;
{ Wartet auf den Abschluß der aktuellen I/O-Operation.

  Rückgabewert ist TRUE, die Anzahl gelesener bzw. geschriebener Bytes
  wird in dwTransmitted zurückgegeben (kann 0 sein).

  Wird bereits dwTransmitted <> 0 übergeben, kehrt die Funktion sofort zurück.

  Der Rückgabewert ist FALSE, wenn
  - das Timeout abläuft oder
  - ein Fehler auftritt oder
  - evAbort "signaled" wird.
}
begin
  // ACHTUNG: Nicht FOverlapped prüfen, weil Read/WriteFile immer
  // mit FOverlapData aufgerufen wird (siehe MSDN)

  // wenn dwTransmitted bereits <> 0 ist, wird dieser Wert verwendet
  if dwTransmitted > 0 then begin
    result := ov_MoreData;         // default
    Exit;
  end;

  // erster Versuch
  result := GetOverlappedPipeResult( FHandle, FOverlapData, dwTransmitted, FALSE);
  if result <> ov_Pending then Exit;

  // dann eben warten
  if not OverlappedWait( evAbort) then begin
    if QueryAbort(evAbort) then SetLastError( ERROR_OPERATION_ABORTED);
    result := ov_Failed;
    Exit;
  end;

  // erneut prüfen
  result := GetOverlappedPipeResult( FHandle, FOverlapData, dwTransmitted, FALSE);
  if result = ov_Pending then SetLastError( ERROR_TIMEOUT);
end;


function TNamedPipe.OverlappedWait( evAbort : TEvent) : Boolean;
// Liefert FALSE, wenn evAbort.Signaled wird oder das Timeout eintritt
// In allen anderen Fällen wird TRUE geliefert
var arrHandles : array[0..1] of THandle;
    iAnzahl : Integer;
    dwRes, dwDataRes : DWORD;
begin
  iAnzahl    := 0;   // Anzahl Handles
  dwDataRes  := WAIT_FAILED;  // initialisieren

  if FEvent <> nil then begin
    dwDataRes := WAIT_OBJECT_0 + iAnzahl;
    arrHandles[iAnzahl] := FEvent.Handle;
    Inc(iAnzahl);
  end;

  if evAbort <> nil then begin
    arrHandles[iAnzahl] := evAbort.Handle;
    Inc(iAnzahl);
  end;

  // Ist etwas da, um darauf zu warten?
  if iAnzahl = 0 then begin
    result := TRUE;    // Synchrones I/O und kein evAbort
    Exit;
  end;

  // TRUE liefern, wenn FEvent.Handle signaled wurde
  dwRes  := WaitForMultipleObjects( iAnzahl, @arrHandles[0], FALSE, DEFAULT_PIPE_TIMEOUT);
  result := (dwRes = dwDataRes) and (dwRes <> WAIT_FAILED);
end;


function TNamedPipe.QueryAbort( evAbort : TEvent) : Boolean;
// Liefert TRUE, wenn das evAbort gesetzt ist
begin
  result := (evAbort <> nil) and (evAbort.WaitFor(0) <> wrTimeOut);
end;


//--- TServerPipe --------------------------------------------------------------


constructor TServerPipe.Create( const aName : string; aDir : TPipeDirection);
begin
  inherited Create( aName);
  FDirection     := aDir;

  // Setup Parameter mit praktikablen Defaults
  FPipeType      := ptyp_MsgMsg;
  FDefTimeout    := DEFAULT_PIPE_TIMEOUT;   // Timeout 2 Sekunden
  FMaxInstances  := PIPE_UNLIMITED_INSTANCES;  // theoretisch unbegrenzt (Systemresourcen)

  // Setup SecurityDescriptor mit NULL-DACL = Full Access
  InitializeSecurityDescriptor( @FSD, SECURITY_DESCRIPTOR_REVISION);
end;


destructor TServerPipe.Destroy;
begin
  try
    DisconnectClient;
    CancelIo;
    Close;
  finally
    inherited Destroy;
  end;
end;


function TServerPipe.Open : Boolean;
// Öffnet eine Instanz der Pipe, FHandle erhält das Server-Ende
// Eine zuvor geöffnete Pipe wird zunächst geschlossen
var sPipe : string;
begin
  Close;

  sPipe := Format( PIPE_NAMING_SCHEME, ['.',FName]);
  FHandle := CreateNamedPipe( PChar(sPipe),
                              GetOpenMode,
                              GetPipeMode,
                              FMaxInstances,
                              DEFAULT_PIPE_BUFFER_SIZE,
                              DEFAULT_PIPE_BUFFER_SIZE,
                              CalculateTimeout(FDefTimeout),
                              @FSD);
  result := (FHandle <> INVALID_HANDLE_VALUE);
end;


function TServerPipe.GetOpenMode : DWORD;
// liefert den OpenMode für CreateNamedPipe()
begin
  result := 0;

  // Richtung
  case FDirection of
    pdir_Duplex         :  result := result or PIPE_ACCESS_DUPLEX;
    pdir_ClientToServer :  result := result or PIPE_ACCESS_INBOUND;
    pdir_ServerToClient :  result := result or PIPE_ACCESS_OUTBOUND;
  else
    ASSERT( FALSE);
  end;

  // Flags
  if FWriteThrough then  result := result or FILE_FLAG_WRITE_THROUGH;
  if FOverlapped   then  result := result or FILE_FLAG_OVERLAPPED;

  // Security-Flags
  // noch nicht implementiert
end;


function TServerPipe.GetPipeMode : DWORD;
// liefert den PipeMode für CreateNamedPipe()
begin
  result := 0;

  // Pipe-Typ und ReadMode
  // PIPE_READMODE_MESSAGE nur möglich bei PIPE_TYPE_MESSAGE
  case FPipeType of
    ptyp_ByteByte :  result := result or PIPE_TYPE_BYTE    or PIPE_READMODE_BYTE;
    ptyp_MsgByte  :  result := result or PIPE_TYPE_MESSAGE or PIPE_READMODE_BYTE;
    ptyp_MsgMsg   :  result := result or PIPE_TYPE_MESSAGE or PIPE_READMODE_MESSAGE;
  else
    ASSERT(FALSE);
  end;

  // Blocking Mode (nonblocking nur für Kompatibilität mit LAN-Manager 2.0)
  result := result or PIPE_WAIT;
end;


procedure TServerPipe.DisconnectClient;
// gracefully disconnect any previously connected client
begin
  if FHandle <> INVALID_HANDLE_VALUE then begin
    FlushFileBuffers( FHandle);
    DisconnectNamedPipe( FHandle);
  end;
end;


function TServerPipe.WaitForClientConnect : Boolean;
// Wartet auf einen Client-Call
var dwErr : DWORD;
begin
  DisconnectClient;

  // auf eine neue Verbindung warten
  result := ConnectNamedPipe( FHandle, @FOverlapData);  
  if result or not FOverlapped then Exit;

  // Sonderfall OverlappedIO: ConnectNamedPipe() liefert FALSE, obwohl eine
  // Verbindung besteht -> zusätzlich GetLastError() abtesten, siehe MSDN
  dwErr  := GetLastError;
  case dwErr of
    ERROR_PIPE_CONNECTED : begin
      FEvent.SetEvent;  // Event manuell setzen, siehe MSDN
      result := TRUE;
    end;

    ERROR_IO_PENDING :
      result := TRUE;

  else
    result := FALSE;
  end;
end;


function TServerPipe.ReadInputData( aStream : TStream) : Boolean;
// Liest die vom Client übermittelten Eingabedaten
const BUFSIZE = DEFAULT_PIPE_BUFFER_SIZE;
var dwRead : DWORD;
    dwErr  : DWORD;
    buf    : array[0..BUFSIZE-1] of Byte;

begin
  result := FALSE;
  aStream.Position := 0;

  FOverlapData.Offset := 0;
  FOverlapData.OffsetHigh := 0;
  repeat
    dwRead := 0;
    if ReadFile( FHandle, buf, BUFSIZE, dwRead, @FOverlapData)
    then dwErr := ERROR_SUCCESS
    else dwErr := GetLastError;

    // Overlapped I/O?
    while (dwErr = ERROR_IO_PENDING) or (dwRead = 0) do begin
      case GetOverlappedResult( dwRead, nil) of
        ov_Pending  :  Sleep(200);   // wait for completion
        ov_MoreData :  dwErr := ERROR_MORE_DATA;
        ov_Complete :  dwErr := ERROR_SUCCESS;
      else
        result := FALSE;
        Exit;
      end;
    end;


    case dwErr of
      ERROR_SUCCESS,
      ERROR_MORE_DATA : begin
        aStream.WriteBuffer( buf, dwRead);
      end;

      ERROR_HANDLE_EOF:
        Break;

    else
      Exit;
    end;
  until dwErr = ERROR_SUCCESS;

  result := TRUE;
end;


function TServerPipe.WriteOutputData( aStream : TStream) : Boolean;
// Schreibt die an den Client zu übermittelnden Ausgabedaten
const BUFSIZE = DEFAULT_PIPE_BUFFER_SIZE;
var dwWrote : DWORD;
    stm     : TMemoryStream;
begin
  if aStream.Size = 0 then begin
    result := TRUE;
    Exit;
  end;

  { Für PIPE_TYPE_MESSAGE müssen die Daten zwingend mit einer einzigen Write-Operation
    geschrieben werden, weil die Daten sonst in mehrere Messages aufgeteilt werden,
    mithin also der Client maximal die Pipe-Buffergröße empfängt:
     "The system treats the bytes written in each write operation [...] as a message unit."
  }
  stm := nil;
  try
    if aStream is TMemoryStream then stm := TMemoryStream(aStream)
    else begin
      stm := TMemoryStream.Create;
      stm.CopyFrom( aStream, 0{=alles});
    end;

    // Daten schreiben
    FOverlapData.Offset := 0;
    FOverlapData.OffsetHigh := 0;
    dwWrote := 0;
    result := WriteFile( FHandle, stm.Memory^, stm.Size, dwWrote, @FOverlapData);
    if not result then begin
      result := (GetOverlappedResult( dwWrote, nil) = ov_Complete);
    end;

  finally
    if aStream <> stm then stm.Free;
  end;
end;


//--- TClientPipe --------------------------------------------------------------


constructor TClientPipe.Create( const aName, aServer : string);
begin
  inherited Create( aName);
  FServer  := aServer;
  FTimeout := DEFAULT_PIPE_TIMEOUT;

  // Setup Parameter mit praktikablen Defaults
  FReadMessages := TRUE;  // passend zu ptyp_MsgMsg;
end;


function TClientPipe.Open( evAbort : TEvent) : Boolean;
var sPipe  : string;
    dwMode : DWORD;
begin
  Close;

  // Abbruch?
  if QueryAbort(evAbort) then begin
    result := FALSE;
    Exit;
  end;

  // Namen der Pipe bauen
  if FServer = ''
  then sPipe := Format( PIPE_NAMING_SCHEME, ['.',FName])
  else sPipe := Format( PIPE_NAMING_SCHEME, [FServer,FName]);

  // Warten, bis eine Pipe-Instanz verfügbar wird
  // Timeout immer etwas variieren, um Kollisionen zu minimieren
  // Der Wert NMPWAIT_USE_DEFAULT_WAIT skaliert schlecht
  result := WaitNamedPipe( pChar(sPipe), CalculateTimeout(FTimeOut));
  if not result then Exit;

  // Abbruch?
  if QueryAbort(evAbort) then Exit;

  // Handle öffnen
  FHandle := CreateFile( PChar(sPipe),
                         GENERIC_READ or GENERIC_WRITE,  // also Duplex
                         0,
                         nil,
                         OPEN_EXISTING,
                         GetFileAttribs,
                         0);
  result := (FHandle <> INVALID_HANDLE_VALUE);
  if not result then Exit;

  // sicherstellen, daß es sich um den richtigen Message-Pipe-Typ handelt
  if FReadMessages
  then dwMode := PIPE_READMODE_MESSAGE
  else dwMode := PIPE_READMODE_BYTE;
  SetNamedPipeHandleState( FHandle, dwMode, nil, nil);
end;


function TClientPipe.GetFileAttribs : DWORD;
begin
  result := FILE_ATTRIBUTE_NORMAL;

  // Flags
  if FWriteThrough then  result := result or FILE_FLAG_WRITE_THROUGH;
  if FOverlapped   then  result := result or FILE_FLAG_OVERLAPPED;
end;


function TClientPipe.Transact( const aInput : string; var aOutput : string; evAbort : TEvent) : Boolean;
var stmIn, stmOut : TMemoryStream;
    dwErr : DWORD;
begin
  result := FALSE;
  dwErr  := ERROR_SUCCESS;

  stmOut := nil;
  stmIn  := TMemoryStream.Create;
  try
    stmOut := TMemoryStream.Create;

    SetStreamAsText( aInput, stmIn);
    result := Transact( stmIn, stmOut, evAbort);
    dwErr  := GetLastError;
    if result then begin
      stmOut.Position := 0;
      SetString( aOutput, PChar(stmOut.Memory), stmOut.Size);  // bei TMemoryStream geht's direkt
    end;

  finally
    stmOut.Free;
    stmIn.Free;
    if not result then SetLastError(dwErr);
  end;
end;


function TClientPipe.Transact( aInput, aOutput : TStream; evAbort : TEvent) : Boolean;
// Übermittelt aInput an den Server und empfängt die Serverantwort in aOutput
const BUFSIZE = DEFAULT_PIPE_BUFFER_SIZE;
var dwRead   : DWORD;
    dwErr    : DWORD;
    buf      : array[0..BUFSIZE-1] of Byte;
    stmIn    : TMemoryStream;
begin
  // Parametertest
  if (aInput = nil) or (aOutput = nil) then begin
    result := FALSE;
    Exit;
  end;

  stmIn := nil;
  try
    // ggf. muß der Input-Stream zwischengepuffert werden
    // wenn es bereits ein Memory-Stream ist, diesen Schritt einsparen
    if (aInput is TMemoryStream) then begin
      stmIn := TMemoryStream(aInput);
    end else begin
      stmIn := TMemoryStream.Create;
      stmIn.LoadFromStream(aInput);
    end;

    // Ausgabestream initialisieren
    aOutput.Position := 0;
    aOutput.Size     := 0;

    // Server-Call
    // If hNamedPipe was not opened with FILE_FLAG_OVERLAPPED,
    // TransactNamedPipe does not return until the operation is complete.
    dwRead := 0;
    FOverlapData.Offset := 0;
    FOverlapData.OffsetHigh := 0;
    ASSERT( FHandle <> INVALID_HANDLE_VALUE);
    result := TransactNamedPipe( FHandle,
                                 stmIn.Memory, stmIn.Size,   // write to pipe
                                 @buf,  BUFSIZE,             // read from pipe
                                 dwRead,
                                 @FOverlapData);

    // alle Daten sind mit einem Aufruf komplett
    if result then begin
      aOutput.WriteBuffer( buf, dwRead);
      Exit;
    end;

    // Fehlercode prüfen
    dwErr := GetLastError;
    if  (dwErr <> ERROR_MORE_DATA)
    and (dwErr <> ERROR_IO_PENDING)
    and (dwErr <> ERROR_PIPE_BUSY)
    then Exit;

    // etwas Speicher freigeben
    if (stmIn <> aInput) then FreeAndNil(stmIn) else stmIn := nil;

    // restliche Daten abrufen
    while TRUE do begin

      // Overlapped I/O?
      while (dwErr = ERROR_IO_PENDING) or (dwRead = 0) do begin
        case GetOverlappedResult( dwRead, nil) of
          ov_Pending  :  if evAbort <> nil
                         then evAbort.WaitFor(200)
                         else Sleep(200);   // wait for completion
          ov_MoreData :  dwErr := ERROR_MORE_DATA;
          ov_Complete :  dwErr := ERROR_SUCCESS;
        else
          result := FALSE;
          Exit;
        end;

        // Abbruch?
        if QueryAbort(evAbort) then begin
          SetLastError( ERROR_OPERATION_ABORTED);
          result := FALSE;
          Exit;
        end;
      end;


      // Ergebnis auswerten
      case dwErr of
        ERROR_SUCCESS : begin
          aOutput.WriteBuffer( buf, dwRead);
          result := TRUE;
          Break;
        end;

        ERROR_MORE_DATA : begin
          aOutput.WriteBuffer( buf, dwRead);
          if ReadFile( FHandle, buf, BUFSIZE, dwRead, @FOverlapData)
          then dwErr := ERROR_SUCCESS
          else dwErr := GetLastError;
        end;

      else
        Break;
      end;

    end;

  finally
    if (stmIn <> aInput) then stmIn.Free;
  end;
end;



end.
