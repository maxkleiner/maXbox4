{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Client                                                       }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

/// <summary> DBX Client </summary>

unit DBXIndyChannel;

{$Z+}


interface

uses
  DBXCommon, Classes, SysUtils, DBXChannel, IdTCPClient;
type

TDBXIndyTcpChannel = class(TDBXChannel)
  strict private
    FTcpClient:   TIdTCPClient;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Open; override;
    procedure Close; override;
    function Read(const Buffer: TBytes; Offset: Integer; Count: Integer): Integer; override;
    function Write(const Buffer: TBytes; Offset: Integer; Count: Integer): Integer; override;
end;

implementation

{ TDBXIndyTcpChannel }

procedure TDBXIndyTcpChannel.Close;
begin
  if FTcpClient <> nil then
  begin
    FTcpClient.Disconnect;
    FreeAndNil(FTcpClient);
  end;

end;

constructor TDBXIndyTcpChannel.Create;
begin
  inherited Create;
end;

destructor TDBXIndyTcpChannel.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TDBXIndyTcpChannel.Open;
begin
  if FTcpClient = nil then
    FTcpClient := TIdTCPClient.Create(nil);
  FTcpClient.Host := DbxProperties[TDBXPropertyNames.HostName];
  FTcpClient.Port := DbxProperties.GetInteger(TDBXPropertyNames.Port);
//  FTcpClient.ReadTimeout := -1;
  FTcpClient.Connect();
end;

function TDBXIndyTcpChannel.Read(const Buffer: TBytes; Offset,
  Count: Integer): Integer;
begin
  Assert(Offset = 0);
  Result := FTcpClient.IOHandler.Recv(Buffer[0], Count);
end;

function TDBXIndyTcpChannel.Write(const Buffer: TBytes; Offset,
  Count: Integer): Integer;
begin
  Assert(Offset = 0);
  FTcpClient.WriteBuffer(Buffer[0], Count);
end;

end.

