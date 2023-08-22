{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Client                                                       }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

/// <summary> DBX Client </summary>

unit DBXChannel;

{$Z+}


interface

uses DBXCommon, SysUtils;

type

TDBXChannel = class
  strict private
    FDbxProperties: TDBXProperties;
  public
    constructor Create;
    procedure Open; virtual; abstract;
    procedure Close; virtual; abstract;
    function Read(const Buffer: TBytes; Offset: Integer; Count: Integer): Integer; virtual; abstract;
    function Write(const Buffer: TBytes; Offset: Integer; Count: Integer): Integer; virtual; abstract;

    property DbxProperties: TDBXProperties read FDbxProperties write FDbxProperties;
end;
implementation

{ TDBXChannel }

constructor TDBXChannel.Create;
begin
  inherited Create;
end;

end.

