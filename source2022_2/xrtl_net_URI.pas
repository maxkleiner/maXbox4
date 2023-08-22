unit xrtl_net_URI;

{$INCLUDE xrtl.inc}

interface

type
  TXRTLURI = class
  protected
    FDocument: WideString;
    FProtocol: WideString;
    FURI: WideString;
    FPort: WideString;
    Fpath: WideString;
    FHost: WideString;
    FBookmark: WideString;
    FUserName: WideString;
    FPassword: WideString;
    procedure  SetURI(const Value: WideString);
    function   GetURI: WideString;
  public
    constructor Create(const AURI: WideString = ''); virtual;
    property   Bookmark: WideString read FBookmark write FBookMark;
    property   Document: WideString read FDocument write FDocument;
    property   Host: WideString read FHost write FHost;
    property   Password: WideString read FPassword write FPassword;
    property   Path: WideString read Fpath write FPath;
    property   Port: WideString read FPort write FPort;
    property   Protocol: WideString read FProtocol write FProtocol;
    property   URI: WideString read GetURI write SetURI;
    property   Username: WideString read FUserName write FUserName;
  end;

implementation

uses
  xrtl_net_URIUtils;

constructor TXRTLURI.Create(const AURI: WideString = '');
begin
  if Length(AURI) > 0 then
  begin
    URI:= AURI;
  end;
end;

procedure TXRTLURI.SetURI(const Value: WideString);
begin
  FURI:= XRTLURINormalize(Value);
  XRTLURIParse(FURI, FProtocol, FHost, FPath, FDocument, FPort, FBookmark, FUserName, FPassword);
end;

function TXRTLURI.GetURI: WideString;
begin
  Result:= '';
  if FProtocol = '' then Exit;
  FURI:= FProtocol + '://';
  if Length(FUserName) > 0 then
  begin
    FURI:= FURI + FUserName;
    if Length(FPassword) > 0 then
    begin
      FURI:= FURI + ':' + FPassword;
    end;
    FURI:= FURI + '@';
  end;
  FURI:= FURI + FHost;
  if Length(FPort) > 0 then
  begin
    FURI:= FURI + ':' + FPort;
  end;
  FURI:= FURI + FPath + FDocument;
  if Length(FBookmark) > 0 then
  begin
    FURI:= FURI + '#' + FBookmark;
  end;
  Result:= FURI;
end;

end.
