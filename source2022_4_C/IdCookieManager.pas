{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10113: IdCookieManager.pas 
{
{   Rev 1.2    7/28/04 11:42:56 PM  RLebeau
{ Bug fix for CleanupCookieList()
}
{
{   Rev 1.1    26/05/2004 12:41:08  Felix
{ - CleanUpCookieList Fix
{ - GenerateCookielist improvement for cookies availables for Host + path
}
{
{   Rev 1.0    2002.11.12 10:34:26 PM  czhower
    Rev 1.1    26.05.2004 12:16 AM  F.Guillemot (FLX)
}
unit IdCookieManager;

{
  Implementation of the HTTP State Management Mechanism as specified in RFC 2109, 2965.

  Author: Doychin Bondzhev (doychin@dsoft-bg.com)
  Copyright: (c) Chad Z. Hower and The Indy Team.

Details of implementation
-------------------------

2001-Mar-31 Doychin Bondzhev
 - Added new method AddCookie2 that is called when we have Set-Cookie2 as response
 - The common code in AddCookie and AddCookie2 is now in DoAdd
2001-Mar-24 Doychin Bondzhev
 - Added OnNewCookie event
   This event is called for every new cookie. Can be used to ask the user program do we have to store this
   cookie in the cookie collection
 - Added new method AddCookie
   This calls the OnNewCookie event and if the result is true it adds the new cookie in the collection
}

interface
                                                                         
Uses Classes, SysUtils, IdBaseComponent, IdCookie, IdGlobal, IdURI;

Type
  TOnNewCookieEvent = procedure(ASender: TObject; ACookie: TIdCookieRFC2109; Var VAccept: Boolean) of object;

  TOnManagerEvent = procedure(ASender: TObject; ACookieCollection: TIdCookies) of object;
  TOnCreateEvent = TOnManagerEvent;
  TOnDestroyEvent = TOnManagerEvent;

  TIdCookieManager = class(TIdBaseComponent)
  protected
    FOnCreate: TOnCreateEvent;
    FOnDestroy:  TOnDestroyEvent;
    FOnNewCookie: TOnNewCookieEvent;
    FCookieCollection: TIdCookies;

    procedure DoAdd(ACookie: TIdCookieRFC2109; ACookieText, AHost: String);
    procedure DoOnCreate; virtual;
    procedure DoOnDestroy; virtual;

    procedure CleanupCookieList;

    function DoOnNewCookie(ACookie: TIdCookieRFC2109): Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddCookie(ACookie, AHost: String);
    procedure AddCookie2(ACookie, AHost: String);
    function GenerateCookieList(URL: TIdURI; SecureConnection: Boolean = false): String;
    property CookieCollection: TIdCookies read FCookieCollection;
    procedure DestroyCookieList;{FLX}
  published
    property OnCreate: TOnCreateEvent read FOnCreate write FOnCreate;
    property OnDestroy: TOnDestroyEvent read FOnDestroy write FOnDestroy;

    property OnNewCookie: TOnNewCookieEvent read FOnNewCookie write FOnNewCookie;
  end;

implementation

{ TIdCookieManager }

constructor TIdCookieManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCookieCollection := TIdCookies.Create(self);
  DoOnCreate;
end;

destructor TIdCookieManager.Destroy;
begin
  CleanupCookieList;
  DoOnDestroy;
  FreeAndNil(FCookieCollection);
  inherited Destroy;
end;

function TIdCookieManager.GenerateCookieList(URL: TIdURI; SecureConnection: Boolean = false): String;
Var
  S: String;
  i, j: Integer;
  LCookieList: TIdCookieList;
  LResultList: TIdCookieList;
  LCookiesByDomain: TIdCookieList;
begin


  CleanupCookieList;

  S := '';    {Do not Localize}
  LCookiesByDomain := FCookieCollection.LockCookieListByDomain(caRead);
  try
    if LCookiesByDomain.Count > 0 then
    begin
      LResultList := TIdCookieList.Create;
      LResultList.Duplicates := dupAccept;
      LResultList.Sorted := true;

      try
        // Search for cookies for this domain
        for i := 0 to LCookiesByDomain.Count - 1 do
        begin
          if IndyPos(Uppercase(LCookiesByDomain[i]), Uppercase(URL.Host + URL.path)) > 0 then {FLX}

          begin
            LCookieList := LCookiesByDomain.Objects[i] as TIdCookieList;

            for j := LCookieList.Count - 1 downto 0 do
            begin
              if Pos(LCookieList.Cookies[j].Path, URL.Path) = 1 then
              begin
                with LCookieList.Cookies[j] do
                begin
                  if ((Secure and SecureConnection) or (not Secure)) and (Value <> '') then    {Do not Localize}
                  begin
                    LResultList.AddObject(Path, LCookieList.Cookies[j]);
                  end;
                end;
              end;
            end;
          end;
        end;

        for i := LResultList.Count - 1 downto 0 do
        begin
          if Length(S) > 0  then S := S + '; ';    {Do not Localize}
          S := S + LResultList.Cookies[i].CookieName + '=' + LResultList.Cookies[i].Value;    {Do not Localize}
        end;
      finally
        LResultList.Free;
      end;
    end;
  finally
    FCookieCollection.UnlockCookieListByDomain(caRead);
  end;
  result := S;
end;

procedure TIdCookieManager.DoAdd(ACookie: TIdCookieRFC2109; ACookieText, AHost: String);
Var
  LDomain: String;
begin
  ACookie.CookieText := ACookieText;

  if Length(ACookie.Domain) = 0 then LDomain := AHost
  else LDomain := ACookie.Domain;

  ACookie.Domain := LDomain;
  
  if ACookie.IsValidCookie(AHost) then
  begin
    if DoOnNewCookie(ACookie) then
    begin
      FCookieCollection.AddCookie(ACookie);
    end
    else begin
      ACookie.Collection := nil;
      ACookie.Free;
    end;
  end
  else begin
    ACookie.Free;
  end;
end;

procedure TIdCookieManager.AddCookie(ACookie, AHost: String);
Var
  LCookie: TIdCookieRFC2109;
begin
  LCookie := FCookieCollection.Add;
  DoAdd(LCookie, ACookie, AHost);
end;

procedure TIdCookieManager.AddCookie2(ACookie, AHost: String);
Var
  LCookie: TIdCookieRFC2965;
begin
  LCookie := FCookieCollection.Add2;
  DoAdd(LCookie, ACookie, AHost);
end;

function TIdCookieManager.DoOnNewCookie(ACookie: TIdCookieRFC2109): Boolean;
begin
  result := true;
  if Assigned(FOnNewCookie) then
  begin
    OnNewCookie(self, ACookie, result);
  end;
end;

procedure TIdCookieManager.DoOnCreate;
begin
  if Assigned(FOnCreate) then
  begin
    OnCreate(self, FCookieCollection);
  end;
end;

procedure TIdCookieManager.DoOnDestroy;
begin
  if Assigned(FOnDestroy) then
  begin
    OnDestroy(self, FCookieCollection);
  end;
end;

procedure TIdCookieManager.CleanupCookieList;
Var
  S: String;
  i, j, LLastCount: Integer;
  LCookieList: TIdCookieList;
  LCookiesByDomain: TIdCookieList;
begin
  LCookiesByDomain := FCookieCollection.LockCookieListByDomain(caReadWrite);
  try
    if LCookiesByDomain.Count > 0 then
    begin
      for i := 0 to LCookiesByDomain.Count - 1 do
      begin
        LCookieList := LCookiesByDomain.Objects[i] as TIdCookieList;
        for j := LCookieList.Count - 1 downto 0 do
        begin
          S := LCookieList.Cookies[j].Expires;
          if (Length(S) > 0) and (GMTToLocalDateTime(S) < Now) then
          begin
            // The Cookie has expired. It has to be removed from the collection
            LLastCount := LCookieList.Count; // RLebeau
            LCookieList.Cookies[j].Free;
            // RLebeau - the cookie may already be removed from the list via
            // its destructor.  If that happens then doing so again below can
            // cause an "index out of bounds" error, so don't do it if not needed.
            if LLastCount = LCookieList.Count then begin
              LCookieList.Delete(j);  //FLX
            end;
          end;
        end;
      end;
    end;
  finally
    FCookieCollection.UnlockCookieListByDomain(caReadWrite);
  end;
end;

procedure TIdCookieManager.DestroyCookieList;
Var
  i, j, LLastCount: Integer;
  LCookieList: TIdCookieList;
  LCookiesByDomain: TIdCookieList;
begin
  LCookiesByDomain := FCookieCollection.LockCookieListByDomain(caReadWrite);
  try
    if LCookiesByDomain.Count > 0 then
    begin
      for i := 0 to LCookiesByDomain.Count - 1 do
      begin
        LCookieList := LCookiesByDomain.Objects[i] as TIdCookieList;
        for j := LCookieList.Count - 1 downto 0 do
        begin
          LLastCount := LCookieList.Count;
          LCookieList.Cookies[j].Free;
          if LLastCount = LCookieList.Count then begin
             LCookieList.Delete(j);
          end;
        end;
      end;
    end;
  finally
    FCookieCollection.UnlockCookieListByDomain(caReadWrite);
  end;
end;

end.
