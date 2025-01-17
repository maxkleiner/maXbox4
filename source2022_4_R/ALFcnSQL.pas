{*************************************************************
www:          http://sourceforge.net/projects/alcinoe/
svn:          svn checkout svn://svn.code.sf.net/p/alcinoe/code/ alcinoe-code
Author(s):    St�phane Vander Clock (alcinoe@arkadia.com)
Sponsor(s):   Arkadia SA (http://www.arkadia.com)

product:      SQL Parser Functions
Version:      4.00

Description:  SQL function to create easily sql string without
              take care if it's an update or insert sql Statement.
              just add the value in a tstringList like
              fieldname=value and at the end contruct the sql string

Legal issues: Copyright (C) 1999-2013 by Arkadia Software Engineering

              This software is provided 'as-is', without any express
              or implied warranty.  In no event will the author be
              held liable for any  damages arising from the use of
              this software.

              Permission is granted to anyone to use this software
              for any purpose, including commercial applications,
              and to alter it and redistribute it freely, subject
              to the following restrictions:

              1. The origin of this software must not be
                 misrepresented, you must not claim that you wrote
                 the original software. If you use this software in
                 a product, an acknowledgment in the product
                 documentation would be appreciated but is not
                 required.

              2. Altered source versions must be plainly marked as
                 such, and must not be misrepresented as being the
                 original software.

              3. This notice may not be removed or altered from any
                 source distribution.

              4. You must register this software by sending a picture
                 postcard to the author. Use a nice stamp and mention
                 your name, street address, EMail address and any
                 comment you like to say.

Know bug :

History :     20/04/2006: Add plan property
              26/06/2012: Add xe2 support

Link :

* Please send all your feedback to alcinoe@arkadia.com
* If you have downloaded this source from a website different from
  sourceforge.net, please get the last version on http://sourceforge.net/projects/alcinoe/
* Please, help us to keep the development of these components free by 
  promoting the sponsor on http://static.arkadia.com/html/alcinoe_like.html
**************************************************************}
unit ALFcnSQL;

interface

uses AlStringList,  IBDataBase, IBCustomDataSet,
     ALFbxClient,
     Contnrs;

Type

  {------------------------------------------------------------------------}
  TALSQLClauseUpdateKind = (alDelete, alUpdate, AlInsert, AlUpdateOrInsert);
  TALSQLClauseServerType = (alFirebird, AlSphinx, AlMySql);

  {---------------------------------}
  TAlSelectSQLClause = Class(Tobject)
  public
    ServerType: TALSQLClauseServerType;
    First: integer;
    Skip: Integer;
    Distinct: Boolean;
    Select: TALStrings;
    Where: TALStrings;
    From: TALStrings;
    Join: TALStrings;
    GroupBy: TALStrings;
    Having: TALStrings;
    Plan: ansiString; // dedicated to Firebird
    OrderBy: TALStrings;
    Customs: TALStrings;
    FBXClientSQLParams: TALFBXClientSQLParams; // dedicated to Firebird
    //FBXClientSQLParams: TIBCustomDataSet; // dedicated to Firebird

    Constructor Create; Virtual;
    Destructor Destroy; override;
    Procedure clear; virtual;
    procedure Assign(Source: TAlSelectSQLClause); virtual;
    function SQLText: AnsiString; virtual;
    function FBXClientSelectDataSQL(const ViewTag, RowTag: AnsiString): TALFBXClientSelectDataSQL; overload;
    function FBXClientSelectDataSQL(const RowTag: AnsiString): TALFBXClientSelectDataSQL; overload;
    function FBXClientSelectDataSQL: TALFBXClientSelectDataSQL; overload;
  end;

  {--------------------------------------}
  TAlSelectSQLClauses = class(TObjectList)
  private
  protected
    function GetItems(Index: Integer): TAlSelectSQLClause;
    procedure SetItems(Index: Integer; aSelectSQLClause: TAlSelectSQLClause);
  public
    function Add(aSelectSQLClause: TAlSelectSQLClause): Integer;
    function Extract(Item: TAlSelectSQLClause): TAlSelectSQLClause;
    function Remove(aSelectSQLClause: TAlSelectSQLClause): Integer;
    function IndexOf(aSelectSQLClause: TAlSelectSQLClause): Integer;
    function First: TAlSelectSQLClause;
    function Last: TAlSelectSQLClause;
    procedure Insert(Index: Integer; aSelectSQLClause: TAlSelectSQLClause);
    property Items[Index: Integer]: TAlSelectSQLClause read GetItems write SetItems; default;
    function FBXClientSelectDataSQLs(const ViewTag, RowTag: AnsiString): TALFBXClientSelectDataSQLs; overload;
    function FBXClientSelectDataSQLs(const RowTag: AnsiString): TALFBXClientSelectDataSQLs; overload;
    function FBXClientSelectDataSQLs: TALFBXClientSelectDataSQLs; overload;
  end;

  {---------------------------------}
  TALUpdateSQLClause = Class(Tobject)
    ServerType: TALSQLClauseServerType;
    Kind: TALSQLClauseUpdateKind;
    Table: ansiString;
    Value: TALStrings;
    Where: TALStrings;
    Customs: TALStrings;
    FBXClientSQLParams: TALFBXClientSQLParams; // dedicated to Firebird
    Constructor Create; Virtual;
    Destructor Destroy; override;
    Procedure clear; virtual;
    procedure Assign(Source: TALUpdateSQLClause); virtual;
    function SQLText: AnsiString; virtual;
    function FBXClientUpdateDataSQL(const ViewTag, RowTag: AnsiString): TALFBXClientUpdateDataSQL; overload;
    function FBXClientUpdateDataSQL(const RowTag: AnsiString): TALFBXClientUpdateDataSQL; overload;
    function FBXClientUpdateDataSQL: TALFBXClientUpdateDataSQL; overload;
  end;

  {--------------------------------------}
  TAlUpdateSQLClauses = class(TObjectList)
  private
  protected
    function GetItems(Index: Integer): TAlUpdateSQLClause;
    procedure SetItems(Index: Integer; aUpdateSQLClause: TAlUpdateSQLClause);
  public
    function Add(aUpdateSQLClause: TAlUpdateSQLClause): Integer;
    function Extract(Item: TAlUpdateSQLClause): TAlUpdateSQLClause;
    function Remove(aUpdateSQLClause: TAlUpdateSQLClause): Integer;
    function IndexOf(aUpdateSQLClause: TAlUpdateSQLClause): Integer;
    function First: TAlUpdateSQLClause;
    function Last: TAlUpdateSQLClause;
    procedure Insert(Index: Integer; aUpdateSQLClause: TAlUpdateSQLClause);
    property Items[Index: Integer]: TAlUpdateSQLClause read GetItems write SetItems; default;
    function FBXClientUpdateDataSQLs(const ViewTag, RowTag: AnsiString): TALFBXClientUpdateDataSQLs; overload;
    function FBXClientUpdateDataSQLs(const RowTag: AnsiString): TALFBXClientUpdateDataSQLs; overload;
    function FBXClientUpdateDataSQLs: TALFBXClientUpdateDataSQLs; overload;
  end;

implementation

uses AlFcnMisc; //AlFcnString;

{************************************}
constructor TAlSelectSQLClause.Create;
Begin
  ServerType := alFirebird;
  First := -1;
  Skip := -1;
  Distinct := False;
  Select:= TALStringList.create;
  Where:= TALStringList.create;
  From:= TALStringList.create;
  Join:= TALStringList.create;
  GroupBy:= TALStringList.create;
  Having:= TALStringList.create;
  Plan := '';
  OrderBy := TALStringList.create;
  Customs := TALStringList.create;
  setlength(FBXClientSQLParams, 0);
end;

{************************************}
destructor TAlSelectSQLClause.Destroy;
begin
  Select.free;
  Where.free;
  From.free;
  Join.free;
  GroupBy.free;
  Having.free;
  OrderBy.free;
  Customs.free;
  inherited;
end;

{**************************************************************}
procedure TAlSelectSQLClause.Assign(Source: TAlSelectSQLClause);
begin
  ServerType := Source.ServerType;
  First := Source.First;
  Skip := Source.Skip;
  Distinct := source.Distinct;
  Select.Assign(source.Select);
  Where.Assign(source.Where);
  From.Assign(source.From);
  Join.Assign(source.Join);
  GroupBy.Assign(source.GroupBy);
  Having.Assign(source.Having);
  Plan := source.Plan;
  OrderBy.Assign(source.OrderBy);
  Customs.Assign(source.Customs);
  FBXClientSQLParams := Source.FBXClientSQLParams;
end;

{**********************************************}
function TAlSelectSQLClause.SQLText: AnsiString;
Var Flag: Boolean;
    i: integer;
    S: ansiString;
Begin

  //start
  Result := 'Select ';

  //first + skip (if server type = ALFirebird)
  if ServerType = alFirebird then begin
    if First >= 0 then Result := result + 'first ' + ALIntToStr(First) + ' ';
    if skip >= 0 then Result := result + 'skip ' + ALIntToStr(skip) + ' ';
  end;

  //distinct
  If Distinct then Result := result + 'distinct ';

  //Select
  Flag := False;
  For i := 0 to Select.Count - 1 do begin
    If ALTrim(Select[i]) <> '' then begin
      Flag := True;
      Result := Result + ALTrim(Select[i]) + ', ';
    end;
  end;
  IF not flag then result := result + '*'
  else Delete(Result,length(result)-1,2);

  //From
  Result := Result + ' From ';
  For i := 0 to From.Count - 1 do
    If ALTrim(From[i]) <> '' then Result := Result + ALTrim(From[i]) + ', ';
  Delete(Result,length(result)-1,2);

  //join
  For i := 0 to join.Count - 1 do
    If ALTrim(join[i]) <> '' then Result := Result + ' ' + ALTrim(join[i]);

  //Where
  If where.Count > 0 then begin
    S := '';
    For i := 0 to where.Count - 1 do
      If ALTrim(where[i]) <> '' then begin
        if ServerType <> AlSphinx then S := S + '(' + ALTrim(where[i]) + ') and '
        else S := S + ALTrim(where[i]) + ' and ';
      end;
    If s <> '' then begin
      delete(S,length(S)-4,5);
      Result := Result + ' Where ' + S;
    end;
  end;

  //group by
  If groupby.Count > 0 then begin
    S := '';
    For i := 0 to groupby.Count - 1 do
      If ALTrim(groupby[i]) <> '' then S := S + ALTrim(groupby[i]) + ' and ';
    If s <> '' then begin
      Delete(S,length(S)-4,5);
      Result := Result + ' Group by ' + S;
    end;
  end;

  //Having
  If having.Count > 0 then begin
    S := '';
    For i := 0 to having.Count - 1 do
      If ALTrim(having[i]) <> '' then S := S + ALTrim(having[i]) + ' and ';
    If s <> '' then begin
      Delete(S,length(S)-4,5);
      Result := Result + ' Having ' + S;
    end;
  end;

  //Plan
  if (ServerType = alFirebird) then begin
    If ALTrim(Plan) <> '' then
      Result := Result + ' ' + ALTrim(Plan);
  end;

  //order by
  If orderby.Count > 0 then begin
    S := '';
    For i := 0 to orderby.Count - 1 do
      If ALTrim(orderby[i]) <> '' then  S := S + ALTrim(orderby[i]) + ', ';
    If s <> '' then begin
      Delete(S,length(S)-1,2);
      Result := Result + ' Order by ' + S;
    end;
  end;

  //first + skip (if server type = ALSphinx)
  if (ServerType in [alSphinx, alMySql]) then begin
    if (First >= 0) and
       (skip >= 0) then Result := result + ' Limit ' + ALIntToStr(skip) + ', ' + ALIntToStr(First)
    else if (First >= 0) then Result := result + ' Limit 0, ' + ALIntToStr(First)
  end;

End;

{***************************************************************************************************************}
function TAlSelectSQLClause.FBXClientSelectDataSQL(const ViewTag, RowTag: AnsiString): TALFBXClientSelectDataSQL;
begin
  result.SQL := SQLText;
  result.Params := FBXClientSQLParams;
  result.RowTag := RowTag;
  result.ViewTag := ViewTag;
  result.Skip := -1; // because it's added in the SQL
  result.First := -1; // because it's added in the SQL
  result.CacheThreshold := 0;
end;

{******************************************************************************************************}
function TAlSelectSQLClause.FBXClientSelectDataSQL(const RowTag: AnsiString): TALFBXClientSelectDataSQL;
begin
  result := FBXClientSelectDataSQL('', RowTag);
end;

{****************************************************************************}
function TAlSelectSQLClause.FBXClientSelectDataSQL: TALFBXClientSelectDataSQL;
begin
  result := FBXClientSelectDataSQL('', '');
end;

{*********************************}
procedure TAlSelectSQLClause.Clear;
Begin
  ServerType:= alFirebird;
  First:= -1;
  Skip:= -1;
  Distinct:= False;
  Select.clear;
  Where.clear;
  From.clear;
  Join.clear;
  GroupBy.clear;
  Having.clear;
  Plan := '';
  OrderBy.clear;
  Customs.clear;
  setlength(FBXClientSQLParams,0);
End;

{******************************************************************************}
function TAlSelectSQLClauses.Add(aSelectSQLClause: TAlSelectSQLClause): Integer;
begin
  Result := inherited Add(aSelectSQLClause);
end;

{*********************************************************************************}
function TAlSelectSQLClauses.Extract(Item: TAlSelectSQLClause): TAlSelectSQLClause;
begin
  Result := TAlSelectSQLClause(inherited Extract(Item));
end;

{*****************************************************}
function TAlSelectSQLClauses.First: TAlSelectSQLClause;
begin
  Result := TAlSelectSQLClause(inherited First);
end;

{************************************************************************}
function TAlSelectSQLClauses.GetItems(Index: Integer): TAlSelectSQLClause;
begin
  Result := TAlSelectSQLClause(inherited Items[Index]);
end;

{**********************************************************************************}
function TAlSelectSQLClauses.IndexOf(aSelectSQLClause: TAlSelectSQLClause): Integer;
begin
  Result := inherited IndexOf(aSelectSQLClause);
end;

{*****************************************************************************************}
procedure TAlSelectSQLClauses.Insert(Index: Integer; aSelectSQLClause: TAlSelectSQLClause);
begin
  inherited Insert(Index, aSelectSQLClause);
end;

{****************************************************}
function TAlSelectSQLClauses.Last: TAlSelectSQLClause;
begin
  Result := TAlSelectSQLClause(inherited Last);
end;

{*********************************************************************************}
function TAlSelectSQLClauses.Remove(aSelectSQLClause: TAlSelectSQLClause): Integer;
begin
  Result := inherited Remove(aSelectSQLClause);
end;

{*******************************************************************************************}
procedure TAlSelectSQLClauses.SetItems(Index: Integer; aSelectSQLClause: TAlSelectSQLClause);
begin
  inherited Items[Index] := aSelectSQLClause;
end;

{******************************************************************************************************************}
function TAlSelectSQLClauses.FBXClientSelectDataSQLs(const ViewTag, RowTag: AnsiString): TALFBXClientSelectDataSQLs;
var i: integer;
begin
  setlength(Result, count);
  for I := 0 to count-1 do
    result[i] := GetItems(i).FBXClientSelectDataSQL(ViewTag, RowTag);
end;

{*********************************************************************************************************}
function TAlSelectSQLClauses.FBXClientSelectDataSQLs(const RowTag: AnsiString): TALFBXClientSelectDataSQLs;
begin
  result := FBXClientSelectDataSQLs('', RowTag);
end;

{*******************************************************************************}
function TAlSelectSQLClauses.FBXClientSelectDataSQLs: TALFBXClientSelectDataSQLs;
begin
  result := FBXClientSelectDataSQLs('', '');
end;

{************************************}
constructor TALUpdateSQLClause.Create;
Begin
  ServerType := ALFirebird;
  Kind := AlInsert;
  table:= '';
  Value:= TALStringList.create;
  Where:= TALStringList.create;
  Customs := TALStringList.create;
  setlength(FBXClientSQLParams, 0);
end;

{************************************}
destructor TALUpdateSQLClause.Destroy;
begin
  Value.free;
  Where.free;
  Customs.free;
  inherited;
end;

{**************************************************************}
procedure TALUpdateSQLClause.Assign(Source: TALUpdateSQLClause);
begin
  ServerType := Source.ServerType;
  Kind := Source.Kind;
  table:= source.Table;
  Value.Assign(source.Value);
  Where.Assign(source.Where);
  Customs.Assign(source.Customs);
  FBXClientSQLParams := Source.FBXClientSQLParams;
end;

{**********************************************}
function TALUpdateSQLClause.SQLText: AnsiString;
var i: integer;
    S1, S2: ansiString;
Begin

  //empty result if Value.Count = 0
  if (Kind <> AlDelete) and
     (Value.Count = 0) then begin
    result := '';
    exit;
  end;

  //AlUpdate
  If Kind = AlUpdate then Begin
    Result := '';
    for i := 0 to Value.Count- 1 do
      If ALTrim(Value[i]) <> '' then Result := Result + ALTrim(Value[i]) + ', ';
    delete(Result,length(result)-1,2);

    Result := 'Update ' + Table + ' Set ' + result;

    If where.Count > 0 then begin
      Result := Result + ' Where ';
      For i := 0 to where.Count - 1 do
        If ALTrim(where[i]) <> '' then Result := Result + '(' + ALTrim(where[i]) + ') and ';
      delete(Result,length(result)-4,5);
    end;
  end

  //AlDelete
  else If Kind = AlDelete then Begin
    Result := 'delete from ' + Table;

    If where.Count > 0 then begin
      Result := Result + ' Where ';
      For i := 0 to where.Count - 1 do
        If ALTrim(where[i]) <> '' then Result := Result + '(' + ALTrim(where[i]) + ') and ';
      delete(Result,length(result)-4,5);
    end;
  end

  //AlInsert, AlUpdateOrInsert
  else Begin
    S1 := '';
    S2 :='';

    for i := 0 to Value.Count-1 do
      If ALTrim(Value[i]) <> '' then begin
        S1 := S1 + ALTrim(Value.Names[i]) + ', ';
        S2 := S2 + ALTrim(Value.ValueFromIndex[i]) + ', ';
      end;
    delete(S1,length(S1)-1,2);
    delete(S2,length(S2)-1,2);

    if kind = ALInsert then Result := 'Insert into '
    else Result := 'Update or Insert into ';
    Result := Result + Table + ' (' + S1 + ') Values (' + s2 + ')';
  end;

end;

{***************************************************************************************************************}
function TAlUpdateSQLClause.FBXClientUpdateDataSQL(const ViewTag, RowTag: AnsiString): TALFBXClientUpdateDataSQL;
begin
  result.SQL := SQLText;
  result.Params := FBXClientSQLParams;
end;

{******************************************************************************************************}
function TAlUpdateSQLClause.FBXClientUpdateDataSQL(const RowTag: AnsiString): TALFBXClientUpdateDataSQL;
begin
  result := FBXClientUpdateDataSQL('', RowTag);
end;

{****************************************************************************}
function TAlUpdateSQLClause.FBXClientUpdateDataSQL: TALFBXClientUpdateDataSQL;
begin
  result := FBXClientUpdateDataSQL('', '');
end;

{*********************************}
procedure TALUpdateSQLClause.clear;
begin
  ServerType:= ALFirebird;
  Kind:= AlInsert;
  Table:= '';
  Value.clear;
  Where.clear;
  Customs.clear;
  setlength(FBXClientSQLParams, 0);
end;

{******************************************************************************}
function TAlUpdateSQLClauses.Add(aUpdateSQLClause: TAlUpdateSQLClause): Integer;
begin
  Result := inherited Add(aUpdateSQLClause);
end;

{*********************************************************************************}
function TAlUpdateSQLClauses.Extract(Item: TAlUpdateSQLClause): TAlUpdateSQLClause;
begin
  Result := TAlUpdateSQLClause(inherited Extract(Item));
end;

{*****************************************************}
function TAlUpdateSQLClauses.First: TAlUpdateSQLClause;
begin
  Result := TAlUpdateSQLClause(inherited First);
end;

{************************************************************************}
function TAlUpdateSQLClauses.GetItems(Index: Integer): TAlUpdateSQLClause;
begin
  Result := TAlUpdateSQLClause(inherited Items[Index]);
end;

{**********************************************************************************}
function TAlUpdateSQLClauses.IndexOf(aUpdateSQLClause: TAlUpdateSQLClause): Integer;
begin
  Result := inherited IndexOf(aUpdateSQLClause);
end;

{*****************************************************************************************}
procedure TAlUpdateSQLClauses.Insert(Index: Integer; aUpdateSQLClause: TAlUpdateSQLClause);
begin
  inherited Insert(Index, aUpdateSQLClause);
end;

{****************************************************}
function TAlUpdateSQLClauses.Last: TAlUpdateSQLClause;
begin
  Result := TAlUpdateSQLClause(inherited Last);
end;

{*********************************************************************************}
function TAlUpdateSQLClauses.Remove(aUpdateSQLClause: TAlUpdateSQLClause): Integer;
begin
  Result := inherited Remove(aUpdateSQLClause);
end;

{*******************************************************************************************}
procedure TAlUpdateSQLClauses.SetItems(Index: Integer; aUpdateSQLClause: TAlUpdateSQLClause);
begin
  inherited Items[Index] := aUpdateSQLClause;
end;

{******************************************************************************************************************}
function TAlUpdateSQLClauses.FBXClientUpdateDataSQLs(const ViewTag, RowTag: AnsiString): TALFBXClientUpdateDataSQLs;
var i: integer;
begin
  setlength(Result, count);
  for I := 0 to count-1 do
    result[i] := GetItems(i).FBXClientUpdateDataSQL(ViewTag, RowTag);
end;

{*********************************************************************************************************}
function TAlUpdateSQLClauses.FBXClientUpdateDataSQLs(const RowTag: AnsiString): TALFBXClientUpdateDataSQLs;
begin
  result := FBXClientUpdateDataSQLs('', RowTag);
end;

{*******************************************************************************}
function TAlUpdateSQLClauses.FBXClientUpdateDataSQLs: TALFBXClientUpdateDataSQLs;
begin
  result := FBXClientUpdateDataSQLs('', '');
end;

end.
