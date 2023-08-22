{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10201: IdIdent.pas 
{
{   Rev 1.0    2002.11.12 10:41:44 PM  czhower
}
unit IdIdent;

interface
uses Classes, IdAssignedNumbers, IdException, IdTCPClient;
{ 2001 - Feb 12 - J. Peter Mugaas
         started this client

  This is the Ident client which is based on RFC 1413.
}
const
  IdIdentQryTimeout = 60000;
type
  EIdIdentException = class(EIdException);
  EIdIdentReply = class(EIdIdentException);
  EIdIdentInvalidPort = class(EIdIdentReply);
  EIdIdentNoUser = class(EIdIdentReply);
  EIdIdentHiddenUser = class(EIdIdentReply);
  EIdIdentUnknownError = class(EIdIdentReply);
  EIdIdentQueryTimeOut = class(EIdIdentReply);

  TIdIdent = class(TIdTCPClient)
  protected
    FQueryTimeOut : Integer;
    FReplyString : String;
    function GetReplyCharset: String;
    function GetReplyOS: String;
    function GetReplyOther: String;
    function GetReplyUserName: String;
    function FetchUserReply : String;
    function FetchOS : String;
    Procedure ParseError;
  public
    Constructor Create(AOwner : TComponent); override;
    Procedure Query(APortOnServer, APortOnClient : Word);
    Property Reply : String read FReplyString;
    Property ReplyCharset : String read GetReplyCharset;
    Property ReplyOS : String read GetReplyOS;
    Property ReplyOther : String read GetReplyOther;
    Property ReplyUserName : String read GetReplyUserName;

  published
    property QueryTimeOut : Integer read FQueryTimeOut write FQueryTimeOut default IdIdentQryTimeout;
    Property Port default IdPORT_AUTH;
  end;

implementation
uses IdGlobal, IdResourceStrings, SysUtils;

const IdentErrorText : Array[0..3] of string =
  ('INVALID-PORT', 'NO-USER', 'HIDDEN-USER', 'UNKNOWN-ERROR');    {Do not Localize}
{ TIdIdent }

constructor TIdIdent.Create(AOwner: TComponent);
begin
  inherited;
  FQueryTimeOut := IdIdentQryTimeout;
  Port := IdPORT_AUTH;
end;

function TIdIdent.FetchOS: String;
var Buf : String;
begin
  Buf := FetchUserReply;
  Result := Trim(Fetch(Buf,':'));    {Do not Localize}
end;

function TIdIdent.FetchUserReply: String;
var Buf : String;
begin
  Result := '';    {Do not Localize}
  Buf := FReplyString;
  Fetch(Buf,':');    {Do not Localize}
  if UpperCase(Trim(Fetch(Buf,':'))) = 'USERID' then    {Do not Localize}
    Result := TrimLeft(Buf);
end;

function TIdIdent.GetReplyCharset: String;
var Buf : String;
begin
  Buf := FetchOS;
  if (Length(Buf) > 0) and (Pos(',',Buf)>0) then    {Do not Localize}
  begin
    Result := Trim(Fetch(Buf,','));    {Do not Localize}
  end
  else
    Result := 'US-ASCII';    {Do not Localize}
end;

function TIdIdent.GetReplyOS: String;
var Buf : String;
begin
  Buf := FetchOS;
  if Length(Buf) > 0 then
  begin
    Result := Trim(Fetch(Buf,','));    {Do not Localize}
  end
  else
    Result := '';    {Do not Localize}
end;

function TIdIdent.GetReplyOther: String;
var Buf : String;
begin
  if FetchOS = 'OTHER' then    {Do not Localize}
  begin
    Buf := FetchUserReply;
    Fetch(Buf,':');    {Do not Localize}
    Result := TrimLeft(Buf);
  end;
end;

function TIdIdent.GetReplyUserName: String;
var Buf : String;
begin
  if FetchOS <> 'OTHER' then    {Do not Localize}
  begin
    Buf := FetchUserReply;
    {OS ID}
    Fetch(Buf,':');    {Do not Localize}
    Result := TrimLeft(Buf);
  end;
end;

procedure TIdIdent.ParseError;
var Buf : String;
begin
  Buf := FReplyString;
  Fetch(Buf,':');    {Do not Localize}
  if Trim(Fetch(Buf,':')) = 'ERROR' then    {Do not Localize}
  begin
    case PosInStrArray(UpperCase(Trim(Buf)),IdentErrorText) of
          {Invalid Port}
      0 : Raise EIdIdentInvalidPort.Create(RSIdentInvalidPort);
          {No user}
      1 : Raise EIdIdentNoUser.Create(RSIdentNoUser);
          {Hidden User}
      2 : Raise EIdIdentHiddenUser.Create(RSIdentHiddenUser)
    else  {Unknwon or other error}
      Raise EIdIdentUnknownError.Create(RSIdentUnknownError);
    end;
  end;
end;

procedure TIdIdent.Query(APortOnServer, APortOnClient: Word);
var RTO : Boolean;
begin
  FReplyString := '';    {Do not Localize}
  Connect;
  try
    WriteLn(IntToStr(APortOnServer)+', '+IntToStr(APortOnClient));    {Do not Localize}
    FReplyString := ReadLn('',FQueryTimeOut);    {Do not Localize}
    {We check here and not return an exception at the moment so we can close our
    connection before raising our exception if the read timed out}
    RTO := ReadLnTimedOut;
  finally
    Disconnect;
  end;
  if RTO then
    Raise EIdIdentQueryTimeOut.Create(RSIdentReplyTimeout)
  else
    ParseError;
end;

end.
