{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10253: IdMessageClient.pas 
{
{   Rev 1.13    7/23/04 6:11:26 PM  RLebeau
{ TFileStream access right tweak for ProcessMessage()
}
{
{   Rev 1.12    5/12/04 9:52:06 AM  RLebeau
{ Updated ProcessMessage() to call ReceiveBody() only if ReceiveHeader() does
{ not receive the message terminator first
}
{
{   Rev 1.11    5/2/04 7:58:08 PM  RLebeau
{ Updated TIdIOHandlerStreamMsg.Recv() to not use a local buffer anymore
}
{
{   Rev 1.10    5/1/04 3:04:16 AM  RLebeau
{ Bug fix for TIdIOHandlerStreamMsg, and also updated to keep track of the last
{ character received from the stream so that extra CR LF characters are not
{ added to the end of the message data unnecessarily.
}
{
{   Rev 1.9    4/23/04 1:54:22 PM  RLebeau
{ Added support for TIdIOHandlerStreamMsg class
}
{
{   Rev 1.8    2/3/04 11:59:20 AM  RLebeau
{ Updated SendBody() to output the TIdMessagePart.ContentID property if it is
{ assigned.
}
{
{   Rev 1.7    10/17/03 11:50:46 AM  RLebeau
{ Updated ReceiveBody() to copy all available header values from the message
{ decoder when creating TIdText and TIdAttachment instances rather than just
{ select values.
}
{
{   Rev 1.6    2003.07.03 11:52:08 AM  czhower
{ DeleteTempFiles addition.
{ Fix of old property IsTempFile, changed to DeleteTempFile so as not to change
{ broken but old functionality that could otherwise cause data loss.
}
{
{   Rev 1.5    2003.06.15 3:00:34 PM  czhower
{ -Fixed IdIOHandlerStream to function as originally designed and needed.
{ -Change ReadStream, WriteStream to Input/Output to be consistent with other
{ areas.
}
{
{   Rev 1.4    21/2/2003 1:53:10 PM  SGrobety
{ Fixed a problem when the message contained only a single text part
}
{
{   Rev 1.3    11-30-2002 11:49:50  BGooijen
{ Fixed double if keywork in if-statement, which caused to file not to compile
}
{
{   Rev 1.2    11/23/2002 03:23:08 AM  JPMugaas
{ Reverted back to old way because the fix turned out to be problematic.
}
{
{   Rev 1.1    11/19/2002 05:24:10 PM  JPMugaas
{ Fixed problem with a . starting a line causing a duplicate period where it
{ shouldn't.
}
{
{   Rev 1.0    2002.11.12 10:45:48 PM  czhower
}
unit IdMessageClient;

{
  2001-Oct-29 Don Siders
    Modified TIdMessageClient.SendMsg to use AHeadersOnly argument.

  2001-Dec-1  Don Siders
    Save ContentDisposition in TIdMessageClient.ProcessAttachment
}

interface

uses
  Classes,
  IdGlobal, IdIOHandlerStream, IdMessage, IdTCPClient, IdHeaderList;

type
  TIdIOHandlerStreamMsg = class(TIdIOHandlerStream)
  protected
    FTerminator: String;
    FTerminatorIndex: Integer;
    FLastCharRecv: Char;
  public
    constructor Create(AOwner: TComponent); override;
    function Readable(AMSec: integer = IdTimeoutDefault): boolean; override;
    function Recv(var ABuf; ALen: integer): integer; override;
  end;

  TIdMessageClient = class(TIdTCPClient)
  protected
    // The length of the folded line
    FMsgLineLength: integer;
    // The string to be pre-pended to the next line
    FMsgLineFold: string;
    //
    procedure ReceiveBody(AMsg: TIdMessage; const ADelim: string = '.'); virtual;
    function  ReceiveHeader(AMsg: TIdMessage; const AAltTerm: string = ''): string; virtual;
    procedure SendBody(AMsg: TIdMessage); virtual;
    procedure SendHeader(AMsg: TIdMessage); virtual;
    procedure WriteBodyText(AMsg: TIdMessage); virtual;
    procedure WriteFoldedLine(const ALine : string);
  public
    constructor Create(AOwner : TComponent); override;
    procedure ProcessMessage(AMsg: TIdMessage; AHeaderOnly: Boolean = False); overload;
    procedure ProcessMessage(AMsg: TIdMessage; const AStream: TStream; AHeaderOnly: Boolean = False); overload;
    procedure ProcessMessage(AMsg: TIdMessage; const AFilename: string; AHeaderOnly: Boolean = False); overload;
    procedure SendMsg(AMsg: TIdMessage; const AHeadersOnly: Boolean = False); virtual;
    //
    property MsgLineLength: integer read FMsgLineLength write FMsgLineLength;
    property MsgLineFold: string read FMsgLineFold write FMsgLineFold;
  end;

implementation

uses
  //TODO: Remove these references and make it completely pluggable. Check other spots in Indy as well
  IdCoderQuotedPrintable, IdMessageCoderMIME, IdMessageCoderUUE, IdMessageCoderXXE,
  //
  IdCoder, IdCoder3to4,
  IdCoderHeader, IdMessageCoder, IdComponent, IdException, IdResourceStrings, IdTCPConnection,
  IdTCPStream, IdIOHandler,
  SysUtils;

const
  SMsgTerminator = #13#10'.'#13#10; {do not localize}

function GetLongestLine(var ALine : String; ADelim : String) : String;
var
  i, fnd, lineLen, delimLen : Integer;
begin
  i := 0;
  fnd := -1;
  delimLen := length(ADelim);
  lineLen := length(ALine);

  while i < lineLen do
  begin
    if ALine[i] = ADelim[1] then
    begin
      if Copy(ALine, i, delimLen) = ADelim then
      begin
        fnd := i;
      end;
    end;
    Inc(i);
  end;

  if fnd = -1 then
  begin
    result := '';
  end

  else begin
    result := Copy(ALine, 1, fnd - 1);
    ALine := Copy(ALine, fnd + delimLen, lineLen);
  end;
end;

////////////////////////
// TIdIOHandlerStreamMsg
////////////////////////

constructor TIdIOHandlerStreamMsg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTerminator := SMsgTerminator;
  FTerminatorIndex := 0;
  FLastCharRecv := #0;
end;

function TIdIOHandlerStreamMsg.Readable(AMSec: integer = IdTimeoutDefault): boolean;
begin
  // if the terminator is not started yet, check the source data first...
  if FTerminatorIndex = 0 then begin
    Result := inherited Readable(AMSec);
    if Result then begin
      Exit;
    end;
  end;
  // check the terminator next...
  if InputStream <> nil then begin
    Result := (FTerminatorIndex <= Length(FTerminator));
  end else begin
    Result := False
  end;
end;

function TIdIOHandlerStreamMsg.Recv(var ABuf; ALen: integer): integer;
begin
  // if the terminator is not started yet, check the source data first...
  if FTerminatorIndex = 0 then begin
    Result := inherited Recv(ABuf, ALen);
    if Result > 0 then begin
      // save the last character received for later use, see below
      FLastCharRecv := PChar(@ABuf)[Result-1];
      Exit;
    end;
    if (ALen <= 0) then begin
      // buffer size not specified, just return now without starting the terminator yet...
      Exit;
    end;
    // determine whether the stream ended with a line
    // break, adding an extra CR and/or LF if needed...
    if (FLastCharRecv = LF) then begin
      // don't add an extra line break
      FTerminatorIndex := 3;
    end else if (FLastCharRecv = CR) then begin
      // add extra LF
      FTerminatorIndex := 2;
    end else begin
      // add extra CRLF
      FTerminatorIndex := 1;
    end;
  end;
  // return the appropriate piece of the terminator...
  ALen := Min(ALen, (Length(FTerminator)-FTerminatorIndex)+1);
  if ALen > 0 then begin
    Move(FTerminator[FTerminatorIndex], ABuf, ALen);
    Inc(FTerminatorIndex, ALen);
  end;
  Result := ALen;
end;

///////////////////
// TIdMessageClient
///////////////////

constructor TIdMessageClient.Create;
begin
  inherited;
  FMsgLineLength := 79;
  FMsgLineFold := TAB;
end;

procedure TIdMessageClient.WriteFoldedLine;
var
  ins, s, line, spare : String;
  msgLen, insLen : Word;
begin
  s := ALine;

  // To give an amount of thread-safety
  ins := FMsgLineFold;
  insLen := Length(ins);
  msgLen := FMsgLineLength;

  // Do first line
  if length(s) > FMsgLineLength then
  begin
    spare := Copy(s, 1, msgLen);
    line := GetLongestLine(spare, ' ');
    s := spare + Copy(s, msgLen + 1, length(s));
    WriteLn(line);

    // continue with the folded lines
    while length(s) > (msgLen - insLen) do
    begin
      spare := Copy(s, 1, (msgLen - insLen));
      line := GetLongestLine(spare, ' ');
      s := ins + spare + Copy(s, (msgLen - insLen) + 1, length(s));
      WriteLn(line);
    end;

    // complete the output with what's left
    if Trim(s) <> '' then
    begin
      WriteLn(ins + s);
    end;
  end

  else begin
    WriteLn(s);
  end;
end;

procedure TIdMessageClient.ReceiveBody(AMsg: TIdMessage; const ADelim: string = '.');
var
  LMsgEnd: Boolean;
  LActiveDecoder: TIdMessageDecoder;
  LLine: string;

  function ProcessTextPart(ADecoder: TIdMessageDecoder): TIdMessageDecoder;
  var
    LDestStream: TStringStream;
  begin
    LDestStream := TStringStream.Create('');
    try
      Result := ADecoder.ReadBody(LDestStream, LMsgEnd);
      with TIdText.Create(AMsg.MessageParts) do
      begin
        {
        ContentType := ADecoder.Headers.Values['Content-Type'];
        ContentTransfer := ADecoder.Headers.Values['Content-Transfer-Encoding'];
        }

        // RLebeau 10/17/2003
        Headers.AddStdValues(ADecoder.Headers);

        Body.Text := LDestStream.DataString;
      end;
      ADecoder.Free;
    finally
      FreeAndNil(LDestStream);
    end;
  end;

  function ProcessAttachment(ADecoder: TIdMessageDecoder): TIdMessageDecoder;
  var
    LDestStream: TFileStream;
    LTempPathname: string;
  begin
    LTempPathname := MakeTempFilename;
    LDestStream := TFileStream.Create(LTempPathname, fmCreate);
    try
      Result := ADecoder.ReadBody(LDestStream, LMsgEnd);
      with TIdAttachment.Create(AMsg.MessageParts) do
      begin
        DeleteTempFile := AMsg.DeleteTempFiles;
        {
        ContentType := ADecoder.Headers.Values['Content-Type'];
        ContentTransfer := ADecoder.Headers.Values['Content-Transfer-Encoding'];

        // dsiders 2001.12.01
        ContentDisposition := ADecoder.Headers.Values['Content-Disposition'];
        }

        // RLebeau 10/17/2003
        Headers.AddStdValues(ADecoder.Headers);

        Filename := ADecoder.Filename;
        StoredPathname := LTempPathname;
      end;
      ADecoder.Free;
    finally
      FreeAndNil(LDestStream);
    end;
  end;

const
  wDoublePoint = ord('.') shl 8 + ord('.');

Begin
  LMsgEnd := False;
  if AMsg.NoDecode then
  begin
    Capture(AMsg.Body, ADelim);
  end

  else begin
    BeginWork(wmRead);
    try
      LActiveDecoder := nil;
      repeat
        LLine := ReadLn;
        if LLine = ADelim then
        begin
          Break;
        end;
        if LActiveDecoder = nil then
        begin
          LActiveDecoder := TIdMessageDecoderList.CheckForStart(AMsg, LLine);
        end;
        if LActiveDecoder = nil then begin
          if PWord(PChar(LLine))^= wDoublePoint then begin
            Delete(LLine,1,1);
          end;//if '..'
          AMsg.Body.Add(LLine);
        end else begin
          while LActiveDecoder <> nil do begin
            LActiveDecoder.SourceStream := TIdTCPStream.Create(Self);
            LActiveDecoder.ReadHeader;

            case LActiveDecoder.PartType of
              mcptUnknown:
              begin
                raise EIdException.Create(RSMsgClientUnkownMessagePartType);
              end;

              mcptText:
              begin
                LActiveDecoder := ProcessTextPart(LActiveDecoder);
              end;

              mcptAttachment:
              begin
                LActiveDecoder := ProcessAttachment(LActiveDecoder);
              end;
            end;
          end;
        end;
      until LMsgEnd;
    finally
      EndWork(wmRead);
    end;
  end;
end;


procedure TIdMessageClient.SendHeader(AMsg: TIdMessage);
var
  LHeaders: TIdHeaderList;
begin
  LHeaders := AMsg.GenerateHeader;
  try
    WriteStrings(LHeaders);
  finally
    FreeAndNil(LHeaders);
  end;
end;

procedure TIdMessageClient.SendBody(AMsg: TIdMEssage);
var
  i: Integer;
  LAttachment: TIdAttachment;
  LBoundary: string;
  LDestStream: TIdTCPStream;
  LMIMEAttachments: boolean;
  ISOCharset: string;
  HeaderEncoding: Char;  { B | Q }
  TransferEncoding: TTransfer;

  procedure WriteTextPart(ATextPart: TIdText);
  var
    Data: string;
    i: Integer;
  begin
    if Length(ATextPart.ContentType) = 0 then
      ATextPart.ContentType := 'text/plain'; {do not localize}
    if Length(ATextPart.ContentTransfer) = 0 then
      ATextPart.ContentTransfer := 'quoted-printable'; {do not localize}
    WriteLn('Content-Type: ' + ATextPart.ContentType); {do not localize}
    WriteLn('Content-Transfer-Encoding: ' + ATextPart.ContentTransfer); {do not localize}
    if Length(ATextPart.ContentID) <> 0 then
    begin
      WriteLn('Content-Id: ' + ATextPart.ContentID);
    end;
    WriteStrings(ATextPart.ExtraHeaders);
    WriteLn('');

    // TODO: Provide B64 encoding later
    // if AnsiSameText(ATextPart.ContentTransfer, 'base64') then begin
    //  LEncoder := TIdEncoder3to4.Create(nil);

    if AnsiSameText(ATextPart.ContentTransfer, 'quoted-printable') then
    begin
      for i := 0 to ATextPart.Body.Count - 1 do
      begin
        if Copy(ATextPart.Body[i], 1, 1) = '.' then
        begin
          ATextPart.Body[i] := '.' + ATextPart.Body[i];
        end;
        Data := TIdEncoderQuotedPrintable.EncodeString(ATextPart.Body[i] + EOL);
        if TransferEncoding = iso2022jp then
          Write(Encode2022JP(Data))
        else
          Write(Data);
      end;
    end

    else begin
      WriteStrings(ATextPart.Body);
    end;
    WriteLn('');
  end;

begin
  LMIMEAttachments := AMsg.Encoding = meMIME;
  LBoundary := '';

  InitializeISO(TransferEncoding, HeaderEncoding, ISOCharSet);
  BeginWork(wmWrite);
  try
    if AMsg.MessageParts.AttachmentCount > 0 then
    begin
      if LMIMEAttachments then
      begin
        WriteLn('This is a multi-part message in MIME format'); {do not localize}
        WriteLn('');
        if AMsg.MessageParts.RelatedPartCount > 0 then
        begin
          LBoundary := IndyMultiPartRelatedBoundary;
        end
        else begin
          LBoundary := IndyMIMEBoundary;
        end;
        WriteLn('--' + LBoundary);
      end
      else begin
        // It's UU, write the body
        WriteBodyText(AMsg);
        WriteLn('');
      end;

      if AMsg.MessageParts.TextPartCount > 1 then
      begin
        WriteLn('Content-Type: multipart/alternative; '); {do not localize}
        WriteLn('        boundary="' + IndyMultiPartAlternativeBoundary + '"'); {do not localize}
        WriteLn('');
        for i := 0 to AMsg.MessageParts.Count - 1 do
        begin
          if AMsg.MessageParts.Items[i] is TIdText then
          begin
            WriteLn('--' + IndyMultiPartAlternativeBoundary);
            DoStatus(hsStatusText,  [RSMsgClientEncodingText]);
            WriteTextPart(AMsg.MessageParts.Items[i] as TIdText);
            WriteLn('');
          end;
        end;
        WriteLn('--' + IndyMultiPartAlternativeBoundary + '--');
      end
      else begin
        if LMIMEAttachments then
        begin
          WriteLn('Content-Type: text/plain'); {do not localize}
          WriteLn('Content-Transfer-Encoding: 7bit'); {do not localize}
          WriteLn('');
          WriteBodyText(AMsg);
        end;
      end;

      // Send the attachments
      for i := 0 to AMsg.MessageParts.Count - 1 do
      begin
        if AMsg.MessageParts[i] is TIdAttachment then
        begin
          LAttachment := TIdAttachment(AMsg.MessageParts[i]);
          DoStatus(hsStatusText, [RSMsgClientEncodingAttachment]);
          if LMIMEAttachments then
          begin
            WriteLn('');
            WriteLn('--' + LBoundary);
            if Length(LAttachment.ContentTransfer) = 0 then
            begin
              LAttachment.ContentTransfer := 'base64'; {do not localize}
            end;
            if Length(LAttachment.ContentDisposition) = 0 then
            begin
              LAttachment.ContentDisposition := 'attachment'; {do not localize}
            end;
            if (LAttachment.ContentTransfer = 'base64') {do not localize}
              and (Length(LAttachment.ContentType) = 0) then
            begin
              LAttachment.ContentType := 'application/octet-stream'; {do not localize}
            end;
            WriteLn('Content-Type: ' + LAttachment.ContentType + ';'); {do not localize}
            WriteLn('        name="' + ExtractFileName(LAttachment.FileName) + '"'); {do not localize}
            WriteLn('Content-Transfer-Encoding: ' + LAttachment.ContentTransfer); {do not localize}
            WriteLn('Content-Disposition: ' + LAttachment.ContentDisposition +';'); {do not localize}
            WriteLn('        filename="' + ExtractFileName(LAttachment.FileName) + '"'); {do not localize}
            if Length(LAttachment.ContentID) <> 0 then
            begin
              WriteLn('Content-Id: ' + LAttachment.ContentID);
            end;
            WriteStrings(LAttachment.ExtraHeaders);
            WriteLn('');
          end;
          LDestStream := TIdTCPStream.Create(Self);
          try
            TIdAttachment(AMsg.MessageParts[i]).Encode(LDestStream);
          finally
            FreeAndNil(LDestStream);
          end;
          WriteLn('');
        end;
      end;
      if LMIMEAttachments then
      begin
        WriteLn('--' + LBoundary + '--');
      end;
    end
    // S.G. 21/2/2003: If the user added a single texpart message without filling the body
    // S.G. 21/2/2003: we still need to send that out
    else
    if (AMsg.MessageParts.TextPartCount > 1) or
       ((AMsg.MessageParts.TextPartCount = 1) and (AMsg.Body.Count = 0)) then
    begin
      WriteLn('This is a multi-part message in MIME format'); {do not localize}
      WriteLn('');
      for i := 0 to AMsg.MessageParts.Count - 1 do
      begin
        if AMsg.MessageParts.Items[i] is TIdText then
        begin
          WriteLn('--' + IndyMIMEBoundary);
          DoStatus(hsStatusText, [RSMsgClientEncodingText]);
          WriteTextPart(AMsg.MessageParts.Items[i] as TIdText);
        end;
      end;
      WriteLn('--' + IndyMIMEBoundary + '--');
    end

    else begin
      DoStatus(hsStatusText, [RSMsgClientEncodingText]);
      // Write out Body
      //TODO: Why just iso2022jp? Why not someting generic for all MBCS? Or is iso2022jp special?
      if TransferEncoding = iso2022jp then
      begin
        for i := 0 to AMsg.Body.Count - 1 do
        begin
          if Copy(AMsg.Body[i], 1, 1) = '.' then
          begin
            WriteLn('.' + Encode2022JP(AMsg.Body[i]));
          end

          else begin
            WriteLn(Encode2022JP(AMsg.Body[i]));
          end;
        end;
      end

      else begin
        WriteBodyText(AMsg);
      end;
    end;
  finally
    EndWork(wmWrite);
  end;
end;

{ 2001-Oct-29 Don Siders
 procedure TIdMessageClient.SendMsg(AMsg: TIdMessage);
  begin
    SendHeader(AMsg);
    WriteLn('');
    SendBody(AMsg);
  end;  }

// 2001-Oct-29 Don Siders Added AHeadersOnly parameter
// TODO: Override TIdMessageClient.SendMsg to provide socket, stream, and file
//  versions like TIdMessageClient.ProcessMessage?
procedure TIdMessageClient.SendMsg(AMsg: TIdMessage; const AHeadersOnly: Boolean = False);
begin
  if AMsg.NoEncode then begin
    WriteStringS(AMsg.Headers);
    WriteLn('');
    if not AHeadersOnly then begin
      WriteStrings(AMsg.Body);
    end;
  end else begin
    SendHeader(AMsg);
    WriteLn('');
    if (not AHeadersOnly) then SendBody(AMsg);
  end;
end;

function TIdMessageClient.ReceiveHeader(AMsg: TIdMessage; const AAltTerm: string = ''): string;
begin
  BeginWork(wmRead); try
    repeat
      Result := ReadLn;
      // Exchange Bug: Exchange sometimes returns . when getting a message instead of
      // '' then a . - That is there is no seperation between the header and the message for an
      // empty message.
      if ((Length(AAltTerm) = 0) and (Result = '.')) or
         ({APR: why? (Length(AAltTerm) > 0) and }(Result = AAltTerm)) then begin
        Break;
      end else if Result <> '' then begin
        AMsg.Headers.Append(Result);
      end;
    until False;
    AMsg.ProcessHeaders;
  finally EndWork(wmRead); end;
end;

procedure TIdMessageClient.ProcessMessage(AMsg: TIdMessage; AHeaderOnly: Boolean = False);
begin
  if IOHandler <> nil then
  begin
    if Length(ReceiveHeader(AMsg)) = 0 then begin
      // Only retreive the body if we do not already have a full RFC
      if (not AHeaderOnly) then begin
        ReceiveBody(AMsg);
      end;
    end;
  end;
end;

procedure TIdMessageClient.ProcessMessage(AMsg: TIdMessage; const AStream: TStream; AHeaderOnly: Boolean = False);
var
  LIOHSM: TIdIOHandlerStreamMsg;
begin
  LIOHSM := TIdIOHandlerStreamMsg.Create(nil); try
    LIOHSM.InputStream := AStream;
    LIOHSM.FreeStreams := False;
    IOHandler := LIOHSM; try
      Connect; try
        ProcessMessage(AMsg, AHeaderOnly);
      finally Disconnect; end;
    finally IOHandler := nil; end;
  finally FreeAndNil(LIOHSM); end;
end;

procedure TIdMessageClient.ProcessMessage(AMsg: TIdMessage; const AFilename: string; AHeaderOnly: Boolean = False);
var
  LStream: TFileStream;
begin
  LStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    ProcessMessage(AMsg, LStream, AHeaderOnly);
  finally
    FreeAndNil(LStream);
  end;
end;

procedure TIdMessageClient.WriteBodyText(AMsg: TIdMessage);
var
  i: integer;
begin
  for i := 0 to AMsg.Body.Count - 1 do
  begin
    if Copy(AMsg.Body[i], 1, 1) = '.' then
    begin
      WriteLn('.' + AMsg.Body[i]);
    end

    else begin
      WriteLn(AMsg.Body[i]);
    end;
  end;
end;

end.
