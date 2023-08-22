unit umaxPipes;

//to maXbox4

interface

uses
  Classes, Windows;

const
  cShutDownMsg = 'shutdown pipe ';
  cPipeFormat = '\\%s\pipe\%s';

type
  RPIPEMessage = record
    Size: DWORD;
    Kind: Byte;
    Count: DWORD;
    Data: array[0..8095] of Char;
  end;

  TPipeServermax = class(TThread)
  private
    FHandle: THandle;
    FPipeName: String;

  protected
  public
    constructor CreatePipeServer(aServer, aPipe: String; StartServer: Boolean);
    destructor Destroy; override;

    procedure StartUpServer;
    procedure ShutDownServer;
    procedure Execute; override;
  end;

  TPipeClientmax = class
  private
    FPipeName: String;
    function ProcessMsg(aMsg: RPIPEMessage): RPIPEMessage;
  protected
  public
    constructor Create(aServer, aPipe: String);

    function SendString(aStr: String): String;
  end;

implementation

uses
  SysUtils;

procedure CalcMsgSize(var Msg: RPIPEMessage);
begin
  Msg.Size :=
    SizeOf(Msg.Size) +
    SizeOf(Msg.Kind) +
    SizeOf(Msg.Count) +
    Msg.Count +
    3;
end;

{ TPipeServer }

constructor TPipeServermax.CreatePipeServer(
  aServer, aPipe: String; StartServer: Boolean
);
begin
  if aServer = '' then
    FPipeName := Format(cPipeFormat, ['.', aPipe])
  else
    FPipeName := Format(cPipeFormat, [aServer, aPipe]);
  // clear server handle
  FHandle := INVALID_HANDLE_VALUE;
  if StartServer then
    StartUpServer;
  // create the class
  Create(not StartServer);
end;

destructor TPipeServermax.Destroy;
begin
  if FHandle = INVALID_HANDLE_VALUE then
    // must shut down the server first
    ShutDownServer;
  inherited Destroy;
end;

procedure TPipeServermax.Execute;
var
  I, Written: Cardinal;
  InMsg, OutMsg: RPIPEMessage;
begin
  while not Terminated do
  begin
    if FHandle = INVALID_HANDLE_VALUE then
    begin
      // suspend thread for 250 milliseconds and try again
      Sleep(250);
    end else begin
      if ConnectNamedPipe(FHandle, nil) then
      try
        // read data from pipe
        InMsg.Size := SizeOf(InMsg);
        ReadFile(FHandle, InMsg, InMsg.Size, InMsg.Size, nil);
        if
          (InMsg.Kind = 0) and
          (StrPas(InMsg.Data) = cShutDownMsg + FPipeName)
        then
        begin
          // process shut down
          OutMsg.Kind := 0;
          OutMsg.Count := 3;
          OutMsg.Data := 'OK'#0;
          Terminate;
        end else begin
          // data send to pipe should be processed here
          OutMsg := InMsg;
          // we'll just reverse the data sent, byte-by-byte
          for I := 0 to Pred(InMsg.Count) do
            OutMsg.Data[Pred(InMsg.Count) - I] := InMsg.Data[I];
        end;
        CalcMsgSize(OutMsg);
        WriteFile(FHandle, OutMsg, OutMsg.Size, Written, nil);
      finally
        DisconnectNamedPipe(FHandle);
      end;
    end;
  end;
end;

procedure TPipeServermax.ShutDownServer;
var
  BytesRead: Cardinal;
  OutMsg, InMsg: RPIPEMessage;
  ShutDownMsg: String;
begin
  if FHandle = INVALID_HANDLE_VALUE then
  begin
    // server still has pipe opened
    OutMsg.Size := SizeOf(OutMsg);
    // prepare shut down message
    with InMsg do
    begin
      Kind := 0;
      ShutDownMsg := cShutDownMsg + FPipeName;
      Count := Succ(Length(ShutDownMsg));
      StrPCopy(Data, ShutDownMsg);
    end;
    CalcMsgSize(InMsg);
    // send shut down message
    CallNamedPipe(
      PChar(FPipeName), @InMsg, InMsg.Size, @OutMsg, OutMsg.Size, BytesRead, 100);
    // close pipe on server
    CloseHandle(FHandle);
    // clear handle
    FHandle := INVALID_HANDLE_VALUE;
  end;
end;

procedure TPipeServermax.StartUpServer;
begin
  // check whether pipe does exist
  if WaitNamedPipe(PChar(FPipeName), 100 {ms}) then
    raise Exception.Create('Requested PIPE exists already.');
  // create the pipe
  FHandle := CreateNamedPipe(
    PChar(FPipeName), PIPE_ACCESS_DUPLEX,
    PIPE_TYPE_MESSAGE or PIPE_READMODE_MESSAGE or PIPE_WAIT,
    PIPE_UNLIMITED_INSTANCES, SizeOf(RPIPEMessage), SizeOf(RPIPEMessage),
    NMPWAIT_USE_DEFAULT_WAIT, nil
  );
  // check if pipe was created
  if FHandle = INVALID_HANDLE_VALUE then
    raise Exception.Create('Could not create PIPE.');
end;

{ TPipeClient }

constructor TPipeClientmax.Create(aServer, aPipe: String);
begin
  inherited Create;
  if aServer = '' then
    FPipeName := Format(cPipeFormat, ['.', aPipe])
  else
    FPipeName := Format(cPipeFormat, [aServer, aPipe]);
end;

function TPipeClientmax.ProcessMsg(aMsg: RPIPEMessage): RPIPEMessage;
begin
  CalcMsgSize(aMsg);
  Result.Size := SizeOf(Result);
  if WaitNamedPipe(PChar(FPipeName), 10) then
    if not CallNamedPipe(
      PChar(FPipeName), @aMsg, aMsg.Size, @Result, Result.Size, Result.Size, 500
    ) then
      raise Exception.Create('PIPE did not respond.')
    else
  else
    raise Exception.Create('PIPE does not exist.');
end;

function TPipeClientmax.SendString(aStr: String): String;
var
  Msg: RPIPEMessage;
begin
  // prepare outgoing message
  Msg.Kind := 1;
  Msg.Count := Length(aStr);
  StrPCopy(Msg.Data, aStr);
  // send message
  Msg := ProcessMsg(Msg);
  // return data send from server
  Result := Copy(Msg.Data, 1, Msg.Count);
end;


END. 
//----app_template_loaded_code----
//----File newtemplate.txt not exists - now saved!----