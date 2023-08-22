unit xrtl_net_NamedPipe;

{$INCLUDE xrtl.inc}

interface

uses
  Windows, SysUtils,
  xrtl_io_Stream;

type
  TXRTLNamedPipe = class
  private
    FHandle: THandle;
    FInputStream: TXRTLInputStream;
    FOutputStream: TXRTLOutputStream;
    function   GetInputStream: TXRTLInputStream;
    function   GetOutputStream: TXRTLOutputStream;
  protected
    procedure  Disconnect; virtual; abstract;
  public
    constructor Create(AHandle: THandle);
    destructor Destroy; override;
    property   Handle: THandle read FHandle;
    property   InputStream: TXRTLInputStream read GetInputStream;
    property   OutputStream: TXRTLOutputStream read GetOutputStream;
  end;

  TXRTLNamedPipeInstanceCount = 1 .. PIPE_UNLIMITED_INSTANCES;

  TXRTLNamedPipeServer = class(TXRTLNamedPipe)
  public
  end;

  TXRTLNamedPipeClient = class(TXRTLNamedPipe)
  public
  end;

implementation

uses
  xrtl_io_HandleStream;

type
  TXRTLNamedPipeOutputStream = class(TXRTLHandleOutputStream)
  public
    procedure  Flush; override;
  end;

{ TXRTLNamedPipeOutputStream }

procedure TXRTLNamedPipeOutputStream.Flush;
begin
  inherited;
  Win32Check(FlushFileBuffers(Handle));
end;

{ TXRTLNamedPipe }

constructor TXRTLNamedPipe.Create(AHandle: THandle);
begin
  inherited Create;
  FHandle:= AHandle;
  FInputStream:= nil;
  FOutputStream:= nil;
end;

destructor TXRTLNamedPipe.Destroy;
begin
  Disconnect;
  Win32Check(CloseHandle(FHandle));
  FreeAndNil(FOutputStream);
  FreeAndNil(FInputStream);
  inherited;
end;

function TXRTLNamedPipe.GetInputStream: TXRTLInputStream;
begin
  if not Assigned(FInputStream) then
    FInputStream:= TXRTLHandleInputStream.Create(Handle, False);
  Result:= FInputStream;
end;

function TXRTLNamedPipe.GetOutputStream: TXRTLOutputStream;
begin
  if not Assigned(FOutputStream) then
    FOutputStream:= TXRTLNamedPipeOutputStream.Create(Handle, False);
  Result:= FOutputStream;
end;

end.
