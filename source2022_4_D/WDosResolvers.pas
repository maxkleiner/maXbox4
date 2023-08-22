
{*******************************************************}
{                                                       }
{       WDosX Delphi Run-time Library                   }
{       WDOSX TCP/IP DNS Resolver Unit                  }
{                                                       }
{       for Delphi 4, 5 WDosX DOS-Extender              }
{       Copyright (c) 2000 by Immo Wache                }
{       e-mail: immo.wache@t-online.de                  }
{                                                       }
{*******************************************************}

{
  Version history:
    IWA 11/20/00 Version 1.1
}
{ TODO : Resolver should communicate with a DNS-Server
         first we need is an UDP Socket component }

unit WDosResolvers;

interface

//{$DEFINE DESIGNPACKAGE}


uses
  SysUtils, Classes, Contnrs, WDosSocketUtils, Forms;

const
  SHostFileName = 'c:\etc\hosts';
  SServicesFileName ='c:\etc\services';
  SHostNameFileName ='c:\etc\hostname';

type
  TSocketEntry = class (TObject)
  private
    FHostName: string;
    FServiceName: string;
    FIpAddr: TIpAddr;
    FPort: Word;
  public
    property HostName: string read FHostName;
    property IpAddr: TIpAddr read FIpAddr;
    property ServiceName: string read FServiceName;
    property Port: Word read FPort;
  end;

  TLookupResult =(clrOk, clrNetDown, clrInval, clrAlready);

  TResolver = class (TObject)
  private
    FHosts: TStringList;
    FServs: TObjectList;
    FLookupHandle: Integer;
    FHostName: string;
    procedure LoadHostsFromFile;
    procedure LoadServicesFromFile;
    procedure LoadHostNameFromFile;
    procedure AddHost(const AHostName: string; AIpAddr: TIpAddr);
    procedure AddPort(const AServName: string; APort: Word;
        const AProtocol: string);
  protected
    function GetLookupHandle: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function GetHostByName(const AName: string): TIpAddr;
    function GetHostByAddr(Addr: TIpAddr): string;
    function GetServByName(const AName, AProtocol: string): Word;
    function GetServByPort(APort: Word; const AProtocol: string): string;

    function AsyncGetHostByName(ADest: TObject; AMsg: Cardinal;
        const AName: string; Entry: TSocketEntry): Integer;
    function AsyncGetHostByAddr(ADest: TObject; AMsg: Cardinal;
        AAddr: TIpAddr; Entry: TSocketEntry): Integer;
    function AsyncGetServByName(ADest: TObject; AMsg: Cardinal;
        const AName, AProtocol: string; Entry: TSocketEntry): Integer;
    function AsyncGetServByPort(ADest: TObject; AMsg: Cardinal;
        APort: Word; const AProtocol: string; Entry: TSocketEntry): Integer;
    function CancelLookupRequest(LookupHandle: Integer): TLookupResult;

    property HostName: string read FHostName;
  end;

var
  Resolver: TResolver;

implementation

{
uses
  WDosScktComp;
}

const
  Delimiters = [#09, ' ', ',', ';'];

type
  TCharSet = set of Char;

  TService = class (TObject)
    Name: string;
    Port: Word;
    Protocol: string;
  end;

function StripRemarks(const Text:string; RemarkToken: Char): string;
var
  RemarkPos: Integer;
begin
  RemarkPos :=Pos(RemarkToken, Text);
  if RemarkPos =0 then
    Result :=Text
  else
    Result :=Copy(Text, 1, RemarkPos -1);
end;

function Tokenize(Strings: TStrings; const Line: string;
    Delimiters: TCharSet): Integer;
var
  P, Start: PChar;
  S: string;
begin
  Result :=0;
  if not Assigned(Strings) then Exit;
  with Strings do
  begin
    Clear;
    P := Pointer(Line);
    if P <> nil then
      while P^ <> #0 do
      begin
        Start := P;
        while not (P^ in (Delimiters +[#0])) do Inc(P);
        SetString(S, Start, P - Start);
        Add(S);
        while P^ in Delimiters do Inc(P);
      end;
    Result :=Count;
  end;
end;

function SplitToken(const Text: string; SplitChar: Char;
    var First, Last: string): Boolean;
var
  SplitPos: Integer;
begin
  Result :=False;
  SplitPos :=Pos(SplitChar, Text);
  if SplitPos =0 then Exit;
  First :=Trim(Copy(Text, 1, SplitPos -1));
  Last :=Trim(Copy(Text, SplitPos +1, Length(Text) -SplitPos));
  Result :=(First <>'') and (Last <>'');
end;

{ TResolver }

constructor TResolver.Create;
begin
  //inherited Create;
  FLookupHandle :=1;
  FHosts :=TStringList.Create;
  FServs :=TObjectList.Create;
  try
  LoadHostsFromFile;
  LoadServicesFromFile;
  LoadHostNameFromFile;
  except
    //messagebox('io error of loadhostsfromfile');
  end;
end;

destructor TResolver.Destroy;
begin
  FServs.Free;
  FHosts.Free;
  inherited Destroy;
end;

procedure TResolver.AddHost(const AHostName: string; AIpAddr: TIpAddr);
begin
  FHosts.AddObject(AHostName, Pointer(AIpAddr));
end;

procedure TResolver.AddPort(const AServName: string; APort: Word;
  const AProtocol: string);
var
  Service: TService;
begin
  Service :=TService.Create;
  with Service do
  begin
    Name :=AServName;
    Port :=APort;
    Protocol :=AProtocol;
  end;
  FServs.Add(Service);
end;

function TResolver.GetHostByAddr(Addr: TIpAddr): string;
var
  Index: Integer;
begin
  Index :=FHosts.IndexOfObject(TObject(Addr));
  if Index <0 then
    Result :=''
  else
    Result :=FHosts[Index];
end;

function TResolver.GetHostByName(const AName: string): TIpAddr;
var
  Index: Integer;
begin
  Index :=FHosts.IndexOf(AName);
  if Index <0 then
    Result :=IpNone
  else
    Result :=TIpAddr(FHosts.Objects[Index]);
end;

function TResolver.GetServByName(const AName, AProtocol: string): Word;
var
  I: Integer;
begin
  for I :=0 to FServs.Count -1 do
    with TService(FServs[I]) do
    begin
      Result :=Port;
      if (AnsiCompareText(AName, Name) = 0)
          and (AnsiCompareText(AProtocol, Protocol) = 0) then Exit;
    end;
  Result :=0;
end;

function TResolver.GetServByPort(APort: Word; const AProtocol: string): string;
var
  I: Integer;
begin
  for I :=0 to FServs.Count -1 do
    with TService(FServs[I]) do
    begin
      Result :=Name;
      if (APort =Port)
          and (AnsiCompareText(AProtocol, Protocol) = 0) then Exit;
    end;
  Result :='';
end;

procedure TResolver.LoadHostsFromFile;
var
  I, K: Integer;
  S: string;
  Lines, Tokens: TStringList;
  NumTokens: Integer;
  IpAddr: TIpAddr;
begin
  Lines :=TStringList.Create;
  try
    // load hosts file
    try
      Lines.LoadFromFile(SHostFileName);
    except
      on E: Exception do Writeln(E.Message);
    end;
    // remove remarks and rem lines
    for I :=Lines.Count -1 downto 0 do
    begin
      S :=StripRemarks(Lines[I], '#');
      if S ='' then
        Lines.Delete(I)
      else
        Lines[I] :=Trim(S);
    end;
    // tokenize every line and store IP and Host
    Tokens :=TStringList.Create;
    try
      for I :=0 to Lines.Count -1 do
      begin
        // resolve string into tokens
        NumTokens :=Tokenize(Tokens, Lines[I], Delimiters);
        // format tokens
        if NumTokens >1 then
        begin
          IpAddr :=StrToIp(Tokens[0]);
          for K :=1 to NumTokens -1 do
            AddHost(Tokens[K], IpAddr);
        end;
      end;
    finally
      Tokens.Free;
    end;
  finally
    Lines.Free;
  end;
end;

procedure TResolver.LoadServicesFromFile;
var
  I, K: Integer;
  S: string;
  Lines, Tokens: TStringList;
  NumTokens: Integer;
  Name: string;
  Port: Word;
  Protocol: string;
begin
  Lines :=TStringList.Create;
  try
    // load hosts file
    try
      Lines.LoadFromFile(SServicesFileName);
    except
      on E: Exception do Writeln(E.Message);
    end;
    // remove remarks and rem lines
    for I :=Lines.Count -1 downto 0 do
    begin
      S :=StripRemarks(Lines[I], '#');
      if S ='' then
        Lines.Delete(I)
      else
        Lines[I] :=Trim(S);
    end;
    // tokenize every line and store Name, Port and Protocol
    Tokens :=TStringList.Create;
    try
      for I :=0 to Lines.Count -1 do
      begin
        // String in Token auflösen
        NumTokens :=Tokenize(Tokens, Lines[I], Delimiters);
        // Token formatieren
        if NumTokens >1 then
        begin
          Name :=Tokens[0];
          if not SplitToken(Tokens[1], '/', S, Protocol) then
            Continue;
          Port :=HostToNetShort(StrToIntDef(S ,0));
          AddPort(Name, Port, Protocol);
          for K :=2 to NumTokens -1 do
            AddPort(Tokens[K], Port, Protocol);
        end;
      end;
    finally
      Tokens.Free;
    end;
  finally
    Lines.Free;
  end;
end;

function TResolver.AsyncGetHostByAddr(ADest: TObject; AMsg: Cardinal;
  AAddr: TIpAddr; Entry: TSocketEntry): Integer;
var
  HostName: string;
begin
  Result :=0;
  if Assigned(Entry) then
  begin
    HostName :=GetHostByAddr(AAddr);
    if HostName <>'' then
    begin
      Entry.FHostName :=HostName;
      Result :=GetLookupHandle;
      //Application.PostMessage(ADest, AMsg, Result, 0);
    end;
  end;
end;

function TResolver.AsyncGetHostByName(ADest: TObject; AMsg: Cardinal;
  const AName: string; Entry: TSocketEntry): Integer;
var
  IpAddr: TIpAddr;
begin
  Result :=0;
  if Assigned(Entry) then
  begin
    IpAddr :=GetHostByName(AName);
    if IpAddr <>IpNone then
    begin
      Entry.FIpAddr :=IpAddr;
      Result :=GetLookupHandle;
      //Application.PostMessage(ADest, AMsg, Result, 0);
    end;
  end;
end;

function TResolver.AsyncGetServByName(ADest: TObject; AMsg: Cardinal;
  const AName, AProtocol: string; Entry: TSocketEntry): Integer;
var
  Port: Word;
begin
  Result :=0;
  if Assigned(Entry) then
  begin
    Port :=GetServByName(AName, AProtocol);
    if Port <>0 then
    begin
      Entry.FPort :=Port;
      Result :=GetLookupHandle;
      {$IFNDEF DESIGNPACKAGE}
      //Application.PostMessage(ADest, AMsg, Result, 0);
     {$ENDIF}
    end;
  end;
end;

function TResolver.AsyncGetServByPort(ADest: TObject; AMsg: Cardinal;
  APort: Word; const AProtocol: string; Entry: TSocketEntry): Integer;
var
  ServiceName: string;
begin
  Result :=0;
  if Assigned(Entry) then
  begin
    ServiceName :=GetServByPort(APort, AProtocol);
    if ServiceName <>'' then
    begin
      Entry.FServiceName :=ServiceName;
      Result :=GetLookupHandle;
     // {$IFNDEF DESIGNPACKAGE}
      //Application.PostMessage(ADest, AMsg, Result, 0);
     // {$ENDIF}
    end;
  end;
end;

function TResolver.CancelLookupRequest(LookupHandle: Integer):
    TLookupResult;
begin
  Result :=clrAlready;
end;

function TResolver.GetLookupHandle: Integer;
begin
  Result :=FLookupHandle;
  Inc(FLookupHandle);
  if FLookupHandle =0 then
    Inc(FLookupHandle);
end;

procedure TResolver.LoadHostNameFromFile;
var
  I: Integer;
  S: string;
  Lines: TStringList;
begin
  Lines :=TStringList.Create;
  try
    // load hosts file
    try
      Lines.LoadFromFile(SHostNameFileName);
    except
      on E: Exception do Writeln(E.Message);
    end;
    // remove remarks and rem lines
    for I :=Lines.Count -1 downto 0 do
    begin
      S :=StripRemarks(Lines[I], '#');
      if S ='' then
        Lines.Delete(I)
      else
        Lines[I] :=Trim(S);
    end;
    if Lines.Count >0 then FHostName :=Lines[0];
  finally
    Lines.Free;
  end;
end;


end.
