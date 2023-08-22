{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10071: IdAuthentication.pas 
{
{   Rev 1.1    01.2.2003 �. 11:52:14  DBondzhev
}
{
{   Rev 1.0    2002.11.12 10:30:26 PM  czhower
}
{
  Implementation of the Basic authentication as specified in
  RFC 2616

  Copyright: (c) Chad Z. Hower and The Winshoes Working Group.

  Author: Doychin Bondzhev (doychin@dsoft-bg.com)

  Modified:

  2001-Sep-11 : DSiders
    Corrected spelling for EIdAlreadyRegisteredAuthenticationMethod
}

unit IdAuthentication;

interface

Uses
  Classes, IdHeaderList, IdGlobal, IdException;

Type
  TIdAuthenticationSchemes = (asBasic, asDigest, asNTLM, asUnknown);
  TIdAuthSchemeSet = set of TIdAuthenticationSchemes;

  TIdAuthWhatsNext = (wnAskTheProgram, wnDoRequest, wnFail);

  TIdAuthentication = class(TPersistent)
  protected
    FAuthRetries: Integer;
    FCurrentStep: Integer;
    FParams: TIdHeaderList;
    FAuthParams: TIdHeaderList;

    function ReadAuthInfo(AuthName: String): String;
    function DoNext: TIdAuthWhatsNext; virtual; abstract;
    procedure SetAuthParams(AValue: TIdHeaderList);
    function GetPassword: String;
    function GetUserName: String;
    function GetSteps: Integer; virtual;
    procedure SetPassword(const Value: String); virtual;
    procedure SetUserName(const Value: String); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Reset; virtual;

    function Authentication: String; virtual; abstract;
    function KeepAlive: Boolean; virtual; abstract;
    function Next: TIdAuthWhatsNext;

    property AuthRetries: Integer read FAuthRetries;
    property AuthParams: TIdHeaderList read FAuthParams write SetAuthParams;
    property Params: TIdHeaderList read FParams;
    property Username: String read GetUserName write SetUserName;
    property Password: String read GetPassword write SetPassword;
    property Steps: Integer read GetSteps;
    property CurrentStep: Integer read FCurrentStep;
  end;

  TIdAuthenticationClass = class of TIdAuthentication;

  TIdBasicAuthentication = class(TIdAuthentication)
  protected
    FRealm: String;
    function DoNext: TIdAuthWhatsNext; override;
    function GetSteps: Integer; override;  // this function determines the number of steps that this
                                           // Authtentication needs take to suceed;
  public
    constructor Create; override;
    function Authentication: String; override;
    function KeepAlive: Boolean; override;
    procedure Reset; override;

    property Realm: String read FRealm write FRealm;
  end;

  EIdAlreadyRegisteredAuthenticationMethod = class(EIdException);

  { Support functions }
  procedure RegisterAuthenticationMethod(MethodName: String; AuthClass: TIdAuthenticationClass);
  function FindAuthClass(AuthName: String): TIdAuthenticationClass;

implementation

Uses
  IdCoderMIME, IdResourceStrings, SysUtils;

Type
  TAuthListObject = class(TObject)
    Auth: TIdAuthenticationClass;
  end;

Var
  AuthList: TStringList = nil;

procedure RegisterAuthenticationMethod(MethodName: String; AuthClass: TIdAuthenticationClass);
Var
  LAuthItem: TAuthListObject;
begin
  if not Assigned(AuthList) then begin
    AuthList := TStringList.Create;
  end;

  if AuthList.IndexOf(MethodName) < 0 then begin
    LAuthItem := TAuthListObject.Create;
    LAuthItem.Auth := AuthClass;
    AuthList.AddObject(MethodName, LAuthItem);
  end
  else begin
    raise EIdAlreadyRegisteredAuthenticationMethod.Create(Format(RSHTTPAuthAlreadyRegistered,
      [TAuthListObject(AuthList.Objects[AuthList.IndexOf(MethodName)]).Auth.ClassName]));
  end;
end;

function FindAuthClass(AuthName: String): TIdAuthenticationClass;
begin
  if AuthList.IndexOf(AuthName) = -1 then
    result := nil
  else
    result := TAuthListObject(AuthList.Objects[AuthList.IndexOf(AuthName)]).Auth;
end;

{ TIdAuthentication }

constructor TIdAuthentication.Create;
begin
  inherited Create;
  FParams := TIdHeaderList.Create;

  FCurrentStep := 0;
end;

destructor TIdAuthentication.Destroy;
begin
  FreeAndNil(FAuthParams);
  FreeAndNil(FParams);

  inherited Destroy;
end;

procedure TIdAuthentication.SetAuthParams(AValue: TIdHeaderList);
begin
  if not Assigned(FAuthParams) then begin
    FAuthParams := TIdHeaderList.Create;
  end;

  FAuthParams.Assign(AValue);
end;

function TIdAuthentication.ReadAuthInfo(AuthName: String): String;
Var
  i: Integer;
begin
  if Assigned(FAuthParams) then begin
    for i := 0 to FAuthParams.Count - 1 do begin
      if IndyPos(AuthName, FAuthParams[i]) = 1 then begin
        result := FAuthParams[i];
        exit;
      end;
    end;
  end
  else begin
    result := '';  {Do not Localize}
  end;
end;

function TIdAuthentication.Next: TIdAuthWhatsNext;
begin
  result := DoNext;
end;

procedure TIdAuthentication.Reset;
begin
  FAuthRetries := 0;
end;

function TIdAuthentication.GetPassword: String;
begin
  result := Params.Values['password'];    {Do not Localize}
end;

function TIdAuthentication.GetUserName: String;
begin
  result := Params.Values['username'];  {Do not Localize}
end;

procedure TIdAuthentication.SetPassword(const Value: String);
begin
  Params.Values['Password'] := Value;   {Do not Localize}
end;

procedure TIdAuthentication.SetUserName(const Value: String);
begin
  Params.Values['Username'] := Value;     {Do not Localize}
end;

function TIdAuthentication.GetSteps: Integer;
begin
  result := 0;
end;

{ TIdBasicAuthentication }

constructor TIdBasicAuthentication.Create;
begin
  inherited Create;
  FCurrentStep := 0;
end;

function TIdBasicAuthentication.Authentication: String;
begin
  result := 'Basic ' {do not localize}
    + TIdEncoderMIME.EncodeString(Username + ':' + Password);  {do not localize}
end;

function TIdBasicAuthentication.DoNext: TIdAuthWhatsNext;
Var
  S: String;
begin
  result := wnDoRequest;

  S := ReadAuthInfo('Basic');        {Do not Localize}
  Fetch(S);

  while Length(S) > 0 do
    with Params do begin
      // realm have 'realm="SomeRealmValue"' format    {Do not Localize}
      // FRealm never assigned without StringReplace
      Add(StringReplace(Fetch(S, ', '), '=', NameValueSeparator, []));  {do not localize}
  end;

  FRealm := Copy(Params.Values['realm'], 2, Length(Params.Values['realm']) - 2);   {Do not Localize}

  case FCurrentStep of
    0: begin
      if (Length(Username) > 0) {and (Length(Password) > 0)} then begin
        result := wnDoRequest;
      end
      else begin
        result := wnAskTheProgram;
      end;
      Inc(FAuthRetries);
    end;
    1: begin
      result := wnFail;
    end;
  end;
end;

function TIdBasicAuthentication.KeepAlive: Boolean;
begin
  result := false;
end;

procedure TIdBasicAuthentication.Reset;
begin
  inherited Reset;
  FCurrentStep := 0;
end;

function TIdBasicAuthentication.GetSteps: Integer;
begin
  result := 1;
end;

initialization
  RegisterAuthenticationMethod('Basic', TIdBasicAuthentication);  {Do not Localize}
finalization
  if Assigned(AuthList) then begin
    while AuthList.Count > 0 do begin
      AuthList.Objects[0].Free;
      AuthList.Delete(0);
    end;
    AuthList.Free;
  end;
end.

