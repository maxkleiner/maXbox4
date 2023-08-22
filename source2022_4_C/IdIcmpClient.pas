{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10199: IdIcmpClient.pas 
{
{   Rev 1.1    2004-04-25 11:49:40  Mattias
{ Fixed multithreaded issue
}
{
{   Rev 1.0    2002.11.12 10:41:36 PM  czhower
}
unit IdIcmpClient;

// MF 25/4/04: Fixed multithreaded issue
// SG 25/1/02: Modified the component to support multithreaded PING and traceroute
// SG 25/1/02: NOTE!!!
// SG 25/1/02:   The component no longer use the timing informations contained
// SG 25/1/02:   in the packet to compute the roundtrip time. This is because
// SG 25/1/02:   that information is only correctly set in case of ECHOREPLY
// SG 25/1/02:   In case of TTL, it is incorrect.

interface

uses
  Classes,
  IdGlobal,
  IdRawBase,
  IdRawClient,
  IdStack,
  IdStackConsts,
  SysUtils;

const
  DEF_PACKET_SIZE = 32;
  MAX_PACKET_SIZE = 1024;
  // TODO: move ICMP_MIN to IdRawHeaders
  ICMP_MIN = 8;

const
  iDEFAULTPACKETSIZE = 128;
  iDEFAULTREPLYBUFSIZE = 1024;

const
  Id_TIDICMP_ReceiveTimeout = 5000;
type
  TReplyStatusTypes = (rsEcho, rsError, rsTimeOut, rsErrorUnreachable, rsErrorTTLExceeded);

  TReplyStatus = record
    BytesReceived: integer; // number of bytes in reply from host
    FromIpAddress: string;  // IP address of replying host
    MsgType: byte;
    SequenceId: word;       // sequence id of ping reply
    // TODO: roundtrip time in ping reply should be float, not byte
    MsRoundTripTime: longword; // ping round trip time in milliseconds
    TimeToLive: byte;       // time to live
    ReplyStatusType: TReplyStatusTypes;
  end;

  TCharBuf = array [1..MAX_PACKET_SIZE] of char;
  TICMPDataBuffer = array [1..iDEFAULTPACKETSIZE] of byte;

  TOnReplyEvent = procedure(ASender: TComponent; const AReplyStatus: TReplyStatus) of object;

  TIdIcmpClient = class(TIdRawClient)
  protected
    bufReceive: TCharBuf;
    bufIcmp: TCharBuf;
    wSeqNo: word;
    iDataSize: integer;
    FReplyStatus: TReplyStatus;
    FOnReply: TOnReplyEvent;
    FReplydata: String;
    //
    function CalcCheckSum: word;
    function DecodeResponse(BytesRead: Cardinal; var AReplyStatus: TReplyStatus): boolean;
    procedure DoReply(const AReplyStatus: TReplyStatus);
    procedure GetEchoReply;
    procedure PrepareEchoRequest(Buffer: string = '');    {Do not Localize}
    procedure SendEchoRequest;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Ping(ABuffer: String = ''; SequenceID: word = 0);    {Do not Localize}
    function Receive(ATimeOut: Integer): TReplyStatus;
    //
    property ReplyStatus: TReplyStatus read FReplyStatus;
    property ReplyData: string read FReplydata;
  published
    property ReceiveTimeout default Id_TIDICMP_ReceiveTimeout;
    property Host;
    property Port;
    property Protocol Default Id_IPPROTO_ICMP;
    property OnReply: TOnReplyEvent read FOnReply write FOnReply;
  end;

implementation

uses
  IdException
  , IdResourceStrings, IdRawHeaders;

{ TIdIcmpClient }

constructor TIdIcmpClient.Create(AOwner: TComponent);
begin
  inherited;
  FProtocol := Id_IPPROTO_ICMP;
  wSeqNo := 3489; // SG 25/1/02: Arbitrary Constant <> 0
  FReceiveTimeOut := Id_TIDICMP_ReceiveTimeout;
end;

function TIdIcmpClient.CalcCheckSum: word;
type
  PWordArray = ^TWordArray;
  TWordArray = array [1..512] of word;
var
  pwa: PWordarray;
  dwChecksum: longword;
  i, icWords, iRemainder: integer;
begin
  icWords := iDataSize div 2;
  iRemainder := iDatasize mod 2;
  pwa := PWordArray(@bufIcmp);
  dwChecksum := 0;
  for i := 1 to icWords do begin
    dwChecksum := dwChecksum + pwa^[i];
  end;
  if (iRemainder <> 0) then begin
    dwChecksum := dwChecksum + byte(bufIcmp[iDataSize + 1]);
  end;
  dwCheckSum := (dwCheckSum shr 16) + (dwCheckSum and $FFFF);
  dwCheckSum := dwCheckSum + (dwCheckSum shr 16);
  Result := word(not dwChecksum);
end;

procedure TIdIcmpClient.PrepareEchoRequest(Buffer: string = '');    {Do not Localize}
var
  pih: PIdIcmpHdr;
  i: integer;
  BufferPos: Integer;

begin
  iDataSize := DEF_PACKET_SIZE + sizeof(TIdIcmpHdr);
  FillChar(bufIcmp, iDataSize, 0);
  pih := PIdIcmpHdr(@bufIcmp);
  with pih^ do
  begin
    icmp_type := Id_ICMP_ECHO;
    icmp_code := 0;
    icmp_hun.echo.id := word(CurrentProcessId);
    icmp_hun.echo.seq := wSeqNo;
    icmp_dun.ts.otime := GetTickcount;
    i := Succ(sizeof(TIdIcmpHdr));
    // SG 19/12/01: Changed the fill algoritm
    BufferPos := 1;
    while (i <= iDataSize) do
    begin
      // SG 19/12/01: Build the reply buffer
      if BufferPos <= Length(Buffer) then
      begin
        bufIcmp[i] := Buffer[BufferPos];
        inc(BufferPos);
      end
      else
        bufIcmp[i] := 'E';    {Do not Localize}
      Inc(i);
    end;
    icmp_sum := CalcCheckSum;
  end;
  // SG 25/1/02: Retarded wSeqNo increment to be able to check it against the response
end;

procedure TIdIcmpClient.SendEchoRequest;
begin
  Send(Host, Port, bufIcmp, iDataSize);
end;

function TIdIcmpClient.DecodeResponse(BytesRead: Cardinal; var AReplyStatus: TReplyStatus): Boolean;
var
//  RTTime: longword;
  pip, pOriginalIP: PIdIPHdr;
  picmp, pOriginalICMP: PIdICMPHdr;
  iIpHeaderLen: Cardinal;
  ActualSeqID: word;
begin
  if BytesRead = 0 then begin
    // Timed out
    AReplyStatus.BytesReceived   := 0;
    AReplyStatus.FromIpAddress   := '0.0.0.0';    {Do not Localize}
    AReplyStatus.MsgType         := 0;
    AReplyStatus.SequenceId      := wSeqNo;
    AReplyStatus.TimeToLive      := 0;
    AReplyStatus.ReplyStatusType := rsTimeOut;
    result := true;
  end else begin
    AReplyStatus.ReplyStatusType := rsError;
    pip := PIdIPHdr(@bufReceive);
    iIpHeaderLen := (pip^.ip_verlen and $0F) * 4;
    if (BytesRead < iIpHeaderLen + ICMP_MIN) then begin
      // RSICMPNotEnoughtBytes 'Not enough bytes received'    {Do not Localize}
      raise EIdIcmpException.Create(RSICMPNotEnoughtBytes);
    end;


    picmp := PIdICMPHdr(@bufReceive[iIpHeaderLen + 1]);
    {$IFDEF LINUX}
    // TODO: baffled as to why linux kernel sends back echo from localhost
    {$ENDIF}

    // Check if we are reading the packet we are waiting for. if not, don't use it in treatement and discard it    {Do not Localize}
    case picmp^.icmp_type of
      Id_ICMP_ECHOREPLY, Id_ICMP_ECHO:
      begin
        AReplyStatus.ReplyStatusType := rsEcho;
        FReplydata := Copy(bufReceive, iIpHeaderLen + SizeOf(picmp^) + 1, Length(bufReceive));
        // result is only valid if the seq. number is correct
      end;
      Id_ICMP_UNREACH:
        AReplyStatus.ReplyStatusType := rsErrorUnreachable;
      Id_ICMP_TIMXCEED:
        AReplyStatus.ReplyStatusType := rsErrorTTLExceeded;
      else
        raise EIdICMPException.Create(RSICMPNonEchoResponse);// RSICMPNonEchoResponse = 'Non-echo type response received'    {Do not Localize}
    end;    // case
    // check if we got a reply to the packet that was actually sent
    case AReplyStatus.ReplyStatusType of    //
      rsEcho:
        begin
          result := picmp^.icmp_hun.echo.seq = wSeqNo;
          ActualSeqID := picmp^.icmp_hun.echo.seq;
//          RTTime := GetTickCount - picmp^.icmp_dun.ts.otime;
        end
      else
        begin
          // not an echo reply: the original IP frame is contained withing the DATA section of the packet
          pOriginalIP := PIdIPHdr(@picmp^.icmp_dun.data);
          // move to offset
          pOriginalICMP := Pointer(Cardinal(pOriginalIP) + (iIpHeaderLen));
          // extract information from original ICMP frame
          ActualSeqID := pOriginalICMP^.icmp_hun.echo.seq;
//          RTTime := GetTickCount - pOriginalICMP^.icmp_dun.ts.otime;
          result := pOriginalICMP^.icmp_hun.echo.seq = wSeqNo;
        end;
    end;    // case

    if result then
    begin
      with AReplyStatus do begin
        BytesReceived := BytesRead;
        FromIpAddress := GStack.TInAddrToString(pip^.ip_src);
        MsgType := picmp^.icmp_type;
        SequenceId := ActualSeqID;
//        MsRoundTripTime := RTTime;
        TimeToLive := pip^.ip_ttl;
      end;
    end;
  end;
end;

procedure TIdIcmpClient.GetEchoReply;
begin
  FReplyStatus := Receive(FReceiveTimeout);
end;

procedure TIdIcmpClient.Ping(ABuffer: String = ''; SequenceID: word = 0);    {Do not Localize}
var
  RTTime: Cardinal;
begin
  if SequenceID <> 0 then
    wSeqNo := SequenceID;
  PrepareEchoRequest(ABuffer);
  RTTime := getTickCount;
  SendEchoRequest;
  GetEchoReply;
  RTTime := GetTickDiff(RTTime,GetTickCount);
  Binding.CloseSocket;
  FReplyStatus.MsRoundTripTime := RTTime;
  DoReply(FReplyStatus);
  Inc(wSeqNo); // SG 25/1/02: Only incread sequence number when finished.
end;

function TIdIcmpClient.Receive(ATimeOut: Integer): TReplyStatus;
var
  BytesRead : Integer;
  Size : Integer;
  StartTime: Cardinal;
begin
  FillChar(bufReceive, sizeOf(bufReceive),0);
  Size := sizeof(bufReceive);
  StartTime := GetTickCount;
  repeat
    BytesRead := ReceiveBuffer(bufReceive, Size, ATimeOut);
    GStack.CheckForSocketError(BytesRead);
    if DecodeResponse(BytesRead, Result) then
    begin
      break
    end
    else
    begin
      // The received reply wasn't for this request, so make sure we don't
      // report it as such in case we time out after this
      result.BytesReceived   := 0;
      result.FromIpAddress   := '0.0.0.0';    {Do not Localize}
      result.MsgType         := 0;
      result.SequenceId      := wSeqNo;
      result.TimeToLive      := 0;
      result.ReplyStatusType := rsTimeOut;

      ATimeOut := Cardinal(ATimeOut) - GetTickDiff(StartTime,getTickCount); // compute new timeout value
    end;
  until ATimeOut <= 0;
end;

procedure TIdIcmpClient.DoReply(const AReplyStatus: TReplyStatus);
begin
  if Assigned(FOnReply) then begin
    FOnReply(Self, AReplyStatus);
  end;
end;

end.
