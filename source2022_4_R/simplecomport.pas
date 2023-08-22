unit simplecomport;

//set to maxform1

interface

uses
  Windows, Classes, SysUtils, AfComPortCore;

type
  TSimpleComPort = class(TObject)
  private
    FComPort: TAfComPortCore;
    procedure PortEvent(Sender: TAfComPortCore; EventKind:TAfCoreEvent;Data: DWORD);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Open(PortNumber: Integer; const Parameters: String);
    procedure WriteString(const S: String);
    procedure ReadString(var S: String);

  end;

{ TSimpleComPort }

implementation

  uses fmain;

constructor TSimpleComPort.Create;
begin
  FComPort := TAfComPortCore.Create;
  FComPort.OnPortEvent := PortEvent;
  FComPort.DirectWrite := True;
end;

destructor TSimpleComPort.Destroy;
begin
  FComPort.Free;
  inherited Destroy;
end;

procedure TSimpleComPort.Open(PortNumber: Integer; const Parameters: String);
var
  DCB: TDCB;
  C: array[0..255] of Char;
begin
  StrPCopy(C, Parameters);
  ZeroMemory(@DCB, Sizeof(DCB));
  Win32Check(BuildCommDCB(C, DCB));
  FComPort.DCB := DCB;
  FComPort.OpenComPort(PortNumber);
  maxForm1.memo2.lines.Add(Format('Port initialized: COM%d: %s', [PortNumber, Parameters]));
  // Writeln(Format('Port initialized: COM%d: %s', [PortNumber, Parameters]));
end;

procedure TSimpleComPort.PortEvent(Sender: TAfComPortCore;
  EventKind: TAfCoreEvent; Data: DWORD);

  procedure DisplayData;
var
  S: String;
  Count: DWORD;
begin
  Count := FComPort.ComStatus.cbInQue;
  SetString(S, nil, Count);
  FComPort.ReadData(Pointer(S)^, Count);
  maxForm1.memo2.lines.Add(S);
  //Write(S);
end;

begin
  case EventKind of
    ceLineEvent:
      begin
        if Data and EV_RXCHAR <> 0 then
          DisplayData;
        if Data and (not EV_RXCHAR) <> 0 then
        //  Write(Format(#13#10'Line error: %.8xh'#13#10, [Data]));
         maxForm1.memo2.lines.Add(Format(#13#10'Line error: %.8xh'#13#10, [Data]));
      end;
    ceNeedReadData:
      DisplayData;
  end;
end;

procedure TSimpleComPort.WriteString(const S: String);
begin
  FComPort.WriteData(Pointer(S)^, Length(S));
end;

procedure TSimpleComPort.ReadString(var S: String);
begin
  FComPort.ReadData(Pointer(S)^, Length(S));
end;

end.

(*var
  StdIn: THandle;
  InputBuffer: TInputRecord;
  InputEvents, ConsoleMode: DWORD;
  SimpleComPort: TSimpleComPort;

begin
  SetConsoleTitle('AsyncFree NonVCL example, press ESC to exit');
  StdIn := GetStdHandle(STD_INPUT_HANDLE);
  if StdIn = INVALID_HANDLE_VALUE then RaiseLastWin32Error;
  Win32Check(GetConsoleMode(StdIn, ConsoleMode));
  Win32Check(SetConsoleMode(StdIn, ConsoleMode and (not ENABLE_ECHO_INPUT)));

  SimpleComPort := TSimpleComPort.Create;
  SimpleComPort.Open(1, 'baud=115200 parity=N data=8 stop=1');

  while True do
    if ReadConsoleInput(StdIn, InputBuffer, 1, InputEvents) then
    case InputBuffer.EventType of
      KEY_EVENT:
        with InputBuffer.Event.KeyEvent do if bKeyDown then
          case AsciiChar of
            #08, #10, #13, #32..#255:
              SimpleComPort.WriteString(AsciiChar);
            #27:
              Break;
          end;
    end;

  SimpleComPort.Free;   *)
//end.

