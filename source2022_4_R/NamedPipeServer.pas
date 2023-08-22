//------------------------------------------------------------------------------
// Pipe Server base class
// Copyright (c) 2006 Jens Geyer und Toolbox-Verlag.
//------------------------------------------------------------------------------
unit NamedPipeServer;

interface

uses Classes, Windows, SysUtils,
     NamedPipes;

type
  TPipeServerStatus = ( pss_Offline,     // der Server ist nicht aktiv
                        pss_Starting,    // Server wird gestartet
                        pss_Running,     // Server läuft
                        pss_Stopping     // Server wird gestoppt
                      );

  // Basisfunktionalität aller PipeServer
  TPipeServer = class( TObject)
  protected
    // Statusflag des Pipe-Servers
    FStatus : TPipeServerStatus;

    // Eintrittspunkt bei Client-Connect
    procedure ProcessData( pipe : TServerPipe);

    // eine dieser Methoden muß überschrieben werden und TRUE liefern
    function ProcessAsStream( var aStm : TStream) : Boolean;  virtual;
    function ProcessAsText(   var aTxt : string)  : Boolean;  virtual;

    // Statusmeldung, kann optional überschrieben werden
    procedure Status( const aStatus : string; aWinError : DWORD = ERROR_SUCCESS);  virtual;

  public
    constructor Create;

  end;

implementation


constructor TPipeServer.Create;
begin
  inherited Create;

  // Status initialisieren
  FStatus := pss_Offline;
end;


procedure TPipeServer.ProcessData( pipe : TServerPipe);
// Ankommende Anfrage bearbeiten
var stm : TStream;
    iIn, iOut : Integer;
begin
  stm := TMemoryStream.Create;
  try
    // Daten aus der Pipe lesen
    if pipe.ReadInputData( stm) then begin
      iIn := stm.Size;
      Status( Format('Request %d Bytes', [iIn]));
    end else begin
      Status( 'Request timeout reached', GetLastError);
      pipe.CancelIo;
      Exit;
    end;

    // Stream an die implementierende Methode durchreichen
    // Antwortdaten zurück in die Pipe schreiben
    iOut := 0;
    if ProcessAsStream( stm) then begin
      iOut := stm.Size;
      Status( Format('Writing Response %d Bytes ...', [iOut]));
      if not pipe.WriteOutputData( stm) then begin
        Status( 'Response timeout reached', GetLastError);
        pipe.CancelIo;
        Exit;
      end;
    end;

    // Fertig
    Status( Format('Success: Request %d Bytes, Response %d Bytes', [iIn,iOut]));
  finally
    stm.Free;
  end;
end;


procedure TPipeServer.Status( const aStatus : string; aWinError : DWORD);
// Statusmeldung der Verarbeitungsroutine
begin
  // opional threadsicher überschreiben
end;


function TPipeServer.ProcessAsStream( var aStm : TStream) : Boolean;
// Ankommende Anfrage, die Daten im Stream werden als Text behandelt
// bei Bedarf threadsicher überschreiben
var sTxt : string;
begin
  // Eingabe aus dem Stream lesen
  sTxt := GetStreamAsText( aStm);

  // Text an die implementierende Methode durchreichen
  result := ProcessAsText( sTxt);
  if not result then Exit;

  // Antwort in den Stream schreiben
  SetStreamAsText( sTxt, aStm);
end;


function TPipeServer.ProcessAsText( var aTxt : string)  : Boolean;
// bei Bedarf threadsicher überschreiben und TRUE zurückgeben
begin
  result := FALSE;   // nicht implementiert
end;



end.
