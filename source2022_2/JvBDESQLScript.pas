{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvSQLS.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Andrei Prygounkov <a dott prygounkov att gmx dott de>
Copyright (c) 1999, 2002 Andrei Prygounkov
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Component   : TJvaSQLScript
Description : db-aware component

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvBDESQLScript.pas 12461 2009-08-14 17:21:33Z obones $

unit JvBDESQLScript;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  Classes, DBTables, jvstrutil, sysutils,
  JvDBUtils, JvComponentBase;

type
  TJvBDESQLScript = class;
  TOnScriptProgress = procedure(Sender: TJvBDESQLScript; var Cancel: Boolean; Line: Integer) of object;
  TJvDBProgressEvent = procedure(UserData: Integer; var Cancel: Boolean; Line: Integer) of object;

  TCommit = (ctNone, ctStep, ctAll);

  EJvScriptError = class(Exception)
  private
    FErrPos: Integer;
  public
    // The dummy parameter is only there for BCB compatibility so that
    // when the hpp file gets generated, this constructor generates
    // a C++ constructor that doesn't already exist
    constructor Create(const AMessage: string; AErrPos: Integer; DummyForBCB: Integer = 0); overload;
    property ErrPos: Integer read FErrPos;
  end;


  TJvBDESQLScript = class(TJvComponent)
  private
    FOnProgress: TOnScriptProgress;
    FScript: TStringList;
    FCommit: TCommit;
    FDatabase: TDatabase;
    function GetScript: TStrings;
    procedure SetScript(AValue: TStrings);
    procedure Progress(UserData: Integer; var Cancel: Boolean; Line: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure Execute;
    property OnProgress: TOnScriptProgress read FOnProgress write FOnProgress;
    property Script: TStrings read GetScript write SetScript;
    property Commit: TCommit read FCommit write FCommit;
    property Database: TDatabase read FDatabase write FDatabase;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_40_PREPARATION/run/JvBDESQLScript.pas $';
    Revision: '$Revision: 12461 $';
    Date: '$Date: 2009-08-14 19:21:33 +0200 (ven., 14 août 2009) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation

uses
  JvBDEUtils, windows, forms;

type TSysCharSet = set of Char;


//function CharInSet(const C: Char; const testSet: TSysCharSet): boolean;
function CharInSet(const C: Char; const testSet: TSysCharSet): boolean;
begin
  Result:= C in testSet;
end;

function AnsiStrLIComp(S1, S2: PChar; MaxLen: Cardinal): Integer;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE,
    S1, MaxLen, S2, MaxLen) - 2;
end;


constructor EJvScriptError.Create(const AMessage: string; AErrPos: Integer; DummyForBCB: Integer);
begin
  inherited Create(AMessage);
  FErrPos := AErrPos;
end;


//procedure ExecuteSQLScript(Base: TDatabase; const Script: string; const Commit: TCommit; OnProgress: TJvDBProgressEvent; const UserData: Integer);
procedure ExecuteSQLScript(Base: TDatabase; const Script: string; const Commit: TCommit; OnProgress: TJvDBProgressEvent; const UserData: Integer);
var
  N: Integer;
  Term: Char;

  function NextQuery: string;
  var
    C: Char;
    Rem: Boolean;
  begin
    Result := '';
    Rem := False;
    while Length(Script) >= N do
    begin
      C := Script[N];
      Inc(N);
      if (C = Term) and not Rem then
        Exit;
      Result := Result + C;
      if (C = '/') and (Length(Script) >= N) and (Script[N] = '*') then
        Rem := True;
      if (C = '*') and (Length(Script) >= N) and (Script[N] = '/') and Rem then
        Rem := False;
    end;
    Result := '';
  end;

  function SetTerm(S: string): Boolean;
  var
    Rem: Boolean;
  begin
    Rem := False;
    while (Length(S) > 0) do
    begin
      if CharInSet(S[1], [' ', #13, #10]) then
        Delete(S, 1, 1)
      else
      if Rem then
        if (S[1] = '*') and (Length(S) > 1) and (S[2] = '/') then
        begin
          Delete(S, 1, 2);
          Rem := False;
        end
        else
          Delete(S, 1, 1)
      else
      if (S[1] = '/') and (Length(S) > 1) and (S[2] = '*') then
      begin
        Delete(S, 1, 2);
        Rem := True;
      end
      else
        Break;
    end;
    Result := AnsiStrLIComp(PChar(S), 'set term', 8) = 0;
    if Result then
    begin
      S := Trim(Copy(S, 9, 1024));
      if Length(S) = 1 then
        Term := S[1]
      else
        //EDatabaseError.Create('Bad term');
        Exception.Create('Bad term');

      Exit;
    end;
    Result := AnsiStrLIComp(PChar(S), 'commit work', 11) = 0;
    if Result then
    begin
      Base.Commit;
      Base.StartTransaction;
      Exit;
    end;
  end;

var
  Q: string;
  ErrPos: Integer;
  NBeg: Integer;
  X, Y, N2: Integer;
  S1: string;
  Query: TQuery;
  Stop: Boolean;
begin
  if Commit in [ctStep, ctAll] then
    Base.StartTransaction;
  Query := TQuery.Create(application);
  try
    Query.DatabaseName := Base.DatabaseName;
    Query.ParamCheck := False;
    N := 1;
    Term := ';';
    Stop := False;
    NBeg := 1;
    try
      Q := NextQuery;
      while Q <> '' do
      begin
        if not SetTerm(Q) then
        begin
          if Assigned(OnProgress) then
          begin
            S1 := Q;
            N2 := 0;
            while (Length(S1) > 0) and CharInSet(S1[1], [' ', #13, #10]) do
            begin
              Delete(S1, 1, 1);
              Inc(N2);
            end;
            GetXYByPos(Script, NBeg + N2, X, Y);
            if Assigned(OnProgress) then
              OnProgress(UserData, Stop, Y)
            else
              // (rom) i do not like this
              Application.ProcessMessages;
            if Stop then
              SysUtils.Abort;
          end;
          Query.SQL.Text := Q;
          Query.ExecSQL;
          if Commit = ctStep then
          begin
            Base.Commit;
            Base.StartTransaction;
          end;
          Query.Close;
        end;
        NBeg := N + 1;
        Q := NextQuery;
      end;
      if Commit in [ctStep, ctAll] then
        Base.Commit;
    except
      on E: Exception do
      begin
        if Commit in [ctStep, ctAll] then
          Base.Rollback;
        if E is EXception then
        begin
          ErrPos := NBeg;
          //..
          raise EJvScriptError.Create(E.Message, ErrPos);

        end
        else
          raise;
      end;
    end;
  finally
    Query.Free;
  end;
end;


constructor TJvBDESQLScript.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScript := TStringList.Create;
end;

destructor TJvBDESQLScript.Destroy;
begin
  FScript.Free;
  inherited Destroy;
end;

function TJvBDESQLScript.GetScript: TStrings;
begin
  Result := FScript;
end;

procedure TJvBDESQLScript.SetScript(AValue: TStrings);
begin
  FScript.Assign(AValue);
end;

procedure TJvBDESQLScript.Execute;
begin
  ExecuteSQLScript(FDatabase, FScript.Text, FCommit, Progress, 0);
end;

procedure TJvBDESQLScript.Progress(UserData: Integer; var Cancel: Boolean; Line: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, Cancel, Line);
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
