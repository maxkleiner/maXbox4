{*********************************************************}
{                                                         }
{                 Zeos Database Objects                   }
{            SQL Statements Analysing classes             }
{                                                         }
{          Originally written by Sergey Seroukhov         }
{                                                         }
{*********************************************************}

{@********************************************************}
{    Copyright (c) 1999-2012 Zeos Development Group       }
{                                                         }
{ License Agreement:                                      }
{                                                         }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the ZEOS Libraries and packages are  }
{ distributed under the Library GNU General Public        }
{ License (see the file COPYING / COPYING.ZEOS)           }
{ with the following  modification:                       }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library. If you modify this       }
{ library, you may extend this exception to your version  }
{ of the library, but you are not obligated to do so.     }
{ If you do not wish to do so, delete this exception      }
{ statement from your version.                            }
{                                                         }
{                                                         }
{ The project web site is located on:                     }
{   http://zeos.firmos.at  (FORUM)                        }
{   http://sourceforge.net/p/zeoslib/tickets/ (BUGTRACKER)}
{   svn://svn.code.sf.net/p/zeoslib/code-0/trunk (SVN)    }
{                                                         }
{   http://www.sourceforge.net/projects/zeoslib.          }
{                                                         }
{                                                         }
{                                 Zeos Development Group. }
{********************************************************@}

unit ZGenericSqlAnalyser;

interface

{$I ZParseSql.inc}

uses Classes, Contnrs, ZClasses, ZTokenizer, ZSelectSchema, ZCompatibility;

type

  {** Implements a section of the parsed SQL statement. }
  TZStatementSection = class (TObject)
  private
    FName: string;
    FTokens: TStrings;
  public
    constructor Create(const Name: string; Tokens: TStrings);
    destructor Destroy; override;

    function Clone: TZStatementSection;

    property Name: string read FName write FName;
    property Tokens: TStrings read FTokens;
  end;

  {** Implements a publicly available interface to statement analyser. }
  IZStatementAnalyser = interface(IZInterface)
    ['{967635B6-411B-4DEF-990C-9C6C01F3DC0A}']

    function TokenizeQuery(Tokenizer: IZTokenizer; const SQL: string;
      Cleanup: Boolean): TStrings;
    function SplitSections(Tokens: TStrings): TObjectList;

    function ComposeTokens(Tokens: TStrings): string;
    function ComposeSections(Sections: TObjectList): string;

    function DefineSelectSchemaFromSections(
      Sections: TObjectList): IZSelectSchema;
    function DefineSelectSchemaFromQuery(Tokenizer: IZTokenizer;
      const SQL: string): IZSelectSchema;
  end;

  {** Implements an SQL statements analyser. }
  TZGenericStatementAnalyser = class (TZAbstractObject, IZStatementAnalyser)
  private
    FSectionNames: TStrings;
    FSelectOptions: TStrings;
    FFromJoins: TStrings;
    FFromClauses: TStrings;
  protected
    function ArrayToStrings(const Value: array of string): TStrings;
    function CheckForKeyword(Tokens: TStrings; TokenIndex: Integer;
      Keywords: TStrings; var Keyword: string; var WordCount: Integer): Boolean;
    function FindSectionTokens(Sections: TObjectList; const Name: string): TStrings;

    procedure FillFieldRefs(SelectSchema: IZSelectSchema; SelectTokens: TStrings);
    procedure FillTableRefs(SelectSchema: IZSelectSchema; FromTokens: TStrings);

    function SkipOptionTokens(Tokens: TStrings; var TokenIndex: Integer;
      Options: TStrings): Boolean;
    function SkipBracketTokens(Tokens: TStrings; var TokenIndex: Integer):
      Boolean;

    property SectionNames: TStrings read FSectionNames write FSectionNames;
    property SelectOptions: TStrings read FSelectOptions write FSelectOptions;
    property FromJoins: TStrings read FFromJoins write FFromJoins;
    property FromClauses: TStrings read FFromClauses write FFromClauses;
  public
    constructor Create;
    destructor Destroy; override;

    function TokenizeQuery(Tokenizer: IZTokenizer; const SQL: string;
      Cleanup: Boolean): TStrings;
    function SplitSections(Tokens: TStrings): TObjectList;

    function ComposeTokens(Tokens: TStrings): string;
    function ComposeSections(Sections: TObjectList): string;

    function DefineSelectSchemaFromSections(
      Sections: TObjectList): IZSelectSchema;
    function DefineSelectSchemaFromQuery(Tokenizer: IZTokenizer; const SQL: string):
      IZSelectSchema;
  end;

implementation

uses SysUtils, ZSysUtils;

{ TZStatementSection }

{**
  Create SQL statement section object.
}
constructor TZStatementSection.Create(const Name: string; Tokens: TStrings);
begin
  FName := Name;
  FTokens := Tokens;
end;

{**
  Destroys this object and cleanups the memory.
}
destructor TZStatementSection.Destroy;
begin
  FTokens.Free;
  inherited Destroy;
end;

{**
  Clones an object instance.
  @return a clonned object instance.
}
function TZStatementSection.Clone: TZStatementSection;
var
  Temp: TStrings;
begin
  Temp := TStringList.Create;
  Temp.AddStrings(FTokens);
  Result := TZStatementSection.Create(FName, Temp);
end;

const
  {** The generic constants.}
  GenericSectionNames: array[0..12] of string = (
    'SELECT', 'UPDATE', 'DELETE', 'INSERT', 'FROM',
    'WHERE', 'INTO', 'GROUP*BY', 'HAVING', 'ORDER*BY',
    'FOR*UPDATE', 'LIMIT', 'OFFSET'
  );
  GenericSelectOptions: array[0..1] of string = (
    'DISTINCT', 'ALL'
  );
  GenericFromJoins: array[0..5] of string = (
    'NATURAL', 'RIGHT', 'LEFT', 'INNER', 'OUTER', 'JOIN'
  );
  GenericFromClauses: array[0..0] of string = (
    'ON'
  );

{ TZGenericStatementAnalyser }

{**
  Creates the object and assignes the main properties.
}
constructor TZGenericStatementAnalyser.Create;
begin
  FSectionNames := ArrayToStrings(GenericSectionNames);
  FSelectOptions := ArrayToStrings(GenericSelectOptions);
  FFromJoins := ArrayToStrings(GenericFromJoins);
  FFromClauses := ArrayToStrings(GenericFromClauses);
end;

{**
  Destroys this object and cleanups the memory.
}
destructor TZGenericStatementAnalyser.Destroy;
begin
  FSectionNames.Free;
  FSelectOptions.Free;
  FFromJoins.Free;
  FFromClauses.Free;
  inherited Destroy;
end;

{**
  Converts an array of strings into TStrings object.
  @param Value an array of strings to be converted.
  @return a TStrings object with specified strings.
}
function TZGenericStatementAnalyser.ArrayToStrings(
  const Value: array of string): TStrings;
var
  I: Integer;
begin
  Result := TStringList.Create;
  for I := Low(Value) to High(Value) do
    Result.Add(Value[I]);
end;

{**
  Checks for keyword with one, two or three consisted words in the list
  @param Tokens a list or tokens
  @param TokenIndex an index of the current token
  @param Keywords a list of keywords (in uppers case delimited with '*')
  @param Keyword an out parameter with found keyword.
  @param WordCount a count of words in the found keyword.
}
function TZGenericStatementAnalyser.CheckForKeyword(Tokens: TStrings;
  TokenIndex: Integer; Keywords: TStrings; var Keyword: string;
  var WordCount: Integer): Boolean;
var
  I: Integer;
begin
  WordCount := 0;
  Keyword := '';
  Result := False;

  for I := 1 to 3 do
  begin
    if (Tokens.Count <= TokenIndex) then
      Break;
    if TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
      Tokens.Objects[TokenIndex]{$IFDEF FPC}){$ENDIF}) <> ttWord then
      Break;
    if Keyword <> '' then
      Keyword := Keyword + '*';
    Keyword := Keyword + AnsiUpperCase(Tokens[TokenIndex]);
    Inc(WordCount);
    if Keywords.IndexOf(Keyword) >= 0 then
    begin
      Result := True;
      Break;
    end;
    Inc(TokenIndex);
    { Skips whitespaces. }
    while Tokens.Count > TokenIndex do
    begin
      if not (TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
        Tokens.Objects[TokenIndex]{$IFDEF FPC}){$ENDIF})
        in [ttWhitespace, ttComment]) then
        Break;
      Inc(TokenIndex);
      Inc(WordCount);
    end;
  end;

  if not Result then
  begin
    WordCount := 0;
    Keyword := '';
  end;
end;

{**
  Finds a section by it's name.
  @param Sections a list of sections.
  @param Name a name of the section to be found.
  @return a list of section tokens or <code>null</code>
    if section is was not found.
}
function TZGenericStatementAnalyser.FindSectionTokens(
  Sections: TObjectList; const Name: string): TStrings;
var
  I: Integer;
  Current: TZStatementSection;
begin
  Result := nil;
  for I := 0 to Sections.Count - 1 do
  begin
    Current := TZStatementSection(Sections[I]);
    if Current.Name = Name then
    begin
      Result := Current.Tokens;
      Break;
    end;
  end;
end;

{**
  Tokenizes a given SQL query into a list of tokens with tokenizer.
  @param Tokenizer a tokenizer object.
  @param SQL a SQL query to be tokenized.
  @return a list with tokens.
}
function TZGenericStatementAnalyser.TokenizeQuery(
  Tokenizer: IZTokenizer; const SQL: string; Cleanup: Boolean): TStrings;
begin
  if Cleanup then
  begin
    Result := Tokenizer.TokenizeBufferToList(SQL,
      [toSkipEOF, toSkipComments, toUnifyWhitespaces])
  end else
    Result := Tokenizer.TokenizeBufferToList(SQL, [toSkipEOF]);
end;

{**
  Splits a given list of tokens into the list named sections.
  @param Tokens a list of tokens.
  @return a list of section names where object property contains
    a list of tokens in the section. It initial list is not started
    with a section name the first section is unnamed ('').
}
function TZGenericStatementAnalyser.SplitSections(Tokens: TStrings): TObjectList;
var
  I: Integer;
  Keyword: string;
  WordCount: Integer;
  TokenIndex: Integer;
  Elements: TStrings;
  FoundSection: Boolean;
  BracketCount: Integer;
begin
  Result := TObjectList.Create;
  TokenIndex := 0;
  FoundSection := True;
  Elements := nil;
  CheckForKeyword(Tokens, TokenIndex, SectionNames, Keyword, WordCount);

  while TokenIndex < Tokens.Count do
  begin
    if FoundSection then
    begin
      Elements := TStringList.Create;
      for I := 0 to WordCount - 1 do
      begin
        Elements.AddObject(Tokens[TokenIndex + I],
          Tokens.Objects[TokenIndex + I]);
      end;
      Inc(TokenIndex, WordCount);
      Result.Add(TZStatementSection.Create(Keyword, Elements));
    end;
    FoundSection := CheckForKeyword(Tokens, TokenIndex, SectionNames,
      Keyword, WordCount);
    if not FoundSection and (TokenIndex < Tokens.Count) then
    begin
      BracketCount := 0;
      repeat
        Elements.AddObject(Tokens[TokenIndex], Tokens.Objects[TokenIndex]);
        if Tokens[TokenIndex] = '(' then
          Inc(BracketCount)
        else if Tokens[TokenIndex] = ')' then
          Dec(BracketCount);
        Inc(TokenIndex);
      until (BracketCount <= 0) or (TokenIndex >= Tokens.Count);
    end;
  end;
end;

{**
  Composes a string from the list of tokens.
  @param Tokens a list of tokens.
  @returns a composes string.
}
function TZGenericStatementAnalyser.ComposeTokens(Tokens: TStrings): string;
begin
  Result := ComposeString(Tokens, '');
end;

{**
  Composes a string from the list of statement sections.
  @param Tokens a list of statement sections.
  @returns a composes string.
}
function TZGenericStatementAnalyser.ComposeSections(Sections: TObjectList): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Sections.Count - 1 do
    Result := Result + ComposeTokens(TZStatementSection(Sections[I]).Tokens);
end;

{**
  Skips tokens inside brackets.
  @param Tokens a list of tokens to scan.
  @param TokenIndex the index of the current token.
  @return <code>true</code> if some tokens were skipped.
}
function TZGenericStatementAnalyser.SkipBracketTokens(Tokens: TStrings;
  var TokenIndex: Integer): Boolean;
var
  BracketCount: Integer;
  Current: string;
begin
  { Checks for the start bracket. }
  if (TokenIndex < Tokens.Count) and (Tokens[TokenIndex] <> '(') then
  begin
    Result := False;
    Exit;
  end;

  { Skips the expression in brackets. }
  Result := True;
  BracketCount := 1;
  Inc(TokenIndex);
  while (TokenIndex < Tokens.Count) and (BracketCount > 0) do
  begin
    Current := Tokens[TokenIndex];
    if Current = '(' then
      Inc(BracketCount)
    else if Current = ')' then
      Dec(BracketCount);
    Inc(TokenIndex);
  end;
end;

{**
  Skips option tokens specified in the string list.
  @param Tokens a list of tokens to scan.
  @param TokenIndex the index of the current token.
  @param Options a list of option keyword strings in the upper case.
  @return <code>true</code> if some tokens were skipped.
}
function TZGenericStatementAnalyser.SkipOptionTokens(Tokens: TStrings;
  var TokenIndex: Integer; Options: TStrings): Boolean;
begin
  Result := False;
  while TokenIndex < Tokens.Count do
  begin
    if not (TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
      Tokens.Objects[TokenIndex]{$IFDEF FPC}){$ENDIF})
      in [ttWhitespace, ttComment])
      and (Options.IndexOf(AnsiUpperCase(Tokens[TokenIndex])) < 0) then
    begin
      Break;
    end;
    Inc(TokenIndex);
    Result := True;
  end;
end;

{**
  Fills select schema with field references.
  @param SelectSchema a select schema object.
  @param SelectTokens a list of tokens in select section.
}
procedure TZGenericStatementAnalyser.FillFieldRefs(
  SelectSchema: IZSelectSchema; SelectTokens: TStrings);
var
  TokenIndex: Integer;
  Catalog: string;
  Schema: string;
  Table: string;
  Field: string;
  Alias: string;
  CurrentValue: string;
  CurrentType: TZTokenType;
  CurrentUpper: string;
  ReadField: Boolean;
  HadWhitespace : Boolean;
  LastWasBracketSection: Boolean;

  procedure ClearElements;
  begin
    Catalog := '';
    Schema := '';
    Table := '';
    Field := '';
    Alias := '';
    ReadField := True;
    LastWasBracketSection := False;
  end;

  { improve fail of fieldname detection if whitespaces and non ttWord or ttQuotedIdentifier previously detected
    f.e.: select first 100 skip 10 field1, field2}
  function CheckNextTokenForCommaAndWhiteSpaces: Boolean;
  var
    CurrentValue: string;
    CurrentType: TZTokenType;
    I: Integer;
  begin
    Result := False;
    I := 1;
    //Check to right side to avoid wrong alias detection
    while SelectTokens.Count > TokenIndex +i do
    begin
      CurrentValue := SelectTokens[TokenIndex+i];
      CurrentType := TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
        SelectTokens.Objects[TokenIndex+i]{$IFDEF FPC}){$ENDIF});
      if CurrentType in [ttWhiteSpace, ttSymbol] then
      begin
        if (CurrentValue = ',') then
        begin
          Result := True;
          Break;
        end;
      end
      else
        break;
      Inc(i);
    end;

    if Result then
    begin
      i := 1;
      while Tokenindex - i > 0 do
        if TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
            SelectTokens.Objects[TokenIndex-i]{$IFDEF FPC}){$ENDIF}) = ttWhiteSpace then
          Inc(i)
        else
          Break;
      Result := Result and (TokenIndex - I > 0) and
          not ( TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
        SelectTokens.Objects[TokenIndex-i]{$IFDEF FPC}){$ENDIF}) = ttWord );
    end;
  end;

begin
  TokenIndex := 1;
  SkipOptionTokens(SelectTokens, TokenIndex, Self.SelectOptions);

  ClearElements;
  while TokenIndex < SelectTokens.Count do
  begin
    CurrentValue := SelectTokens[TokenIndex];
    CurrentUpper := AnsiUpperCase(CurrentValue);
    CurrentType := TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
      SelectTokens.Objects[TokenIndex]{$IFDEF FPC}){$ENDIF});

    { Switches to alias part. }
    if (CurrentType = ttWhitespace) or (CurrentUpper = 'AS') then
    begin
      ReadField := ReadField and (Field = '') and (CurrentUpper <> 'AS');
    end
    { Reads field. }
    else if ReadField and ((CurrentType = ttWord) or (CurrentType = ttQuotedIdentifier) or
      (CurrentValue = '*')) then
    begin
      Catalog := Schema;
      Schema := Table;
      Table := Field;
      Field := CurrentValue;
    end
    { Skips a '.' in field part. }
    else if ReadField and (CurrentValue = '.') then
    begin
    end
    { Reads alias. }
    else if not ReadField and (CurrentType = ttWord) then
    begin
      Alias := CurrentValue;
    end
    { Ends field reading. }
    else if CurrentValue = ',' then
    begin
      if Field <> '' then
      begin
        SelectSchema.AddField(TZFieldRef.Create(True, Catalog, Schema, Table,
          Field, Alias, nil));
      end;
      ClearElements;
    end
    { Skips till the next field. }
    else
    begin
      ClearElements;
      HadWhitespace := False;
      while (TokenIndex < SelectTokens.Count) and (CurrentValue <> ',') do
      begin
        CurrentValue := SelectTokens[TokenIndex];
        if CurrentValue = '(' then
        begin
          SkipBracketTokens(SelectTokens, TokenIndex);
          LastWasBracketSection := True;
        end
        else begin
          CurrentType := TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
            SelectTokens.Objects[TokenIndex]{$IFDEF FPC}){$ENDIF});
          if HadWhitespace and (CurrentType in [ttWord, ttQuotedIdentifier]) then
            if not LastWasBracketSection and CheckNextTokenForCommaAndWhiteSpaces then
              Break
            else
              Alias := CurrentValue
          else if not (CurrentType in [ttWhitespace, ttComment])
            and (CurrentValue <> ',') then
              Alias := ''
          else if CurrentType = ttWhitespace then
              HadWhitespace := true;
          Inc(TokenIndex);
        end;
      end;
      if Alias <> '' then
      begin
        SelectSchema.AddField(TZFieldRef.Create(False, '', '', '', '',
          Alias, nil));
        ClearElements;
      end;
      Dec(TokenIndex); // go back 1 token(Because of Inc in next lines)
    end;
    Inc(TokenIndex);
  end;

  { Creates a reference to the last processed field. }
  if Field <> '' then
  begin
    SelectSchema.AddField(TZFieldRef.Create(True, Catalog, Schema, Table,
      Field, Alias, nil));
  end;
end;

{**
  Fills select schema with table references.
  @param SelectSchema a select schema object.
  @param FromTokens a list of tokens in from section.
}
{$HINTS OFF}
procedure TZGenericStatementAnalyser.FillTableRefs(
  SelectSchema: IZSelectSchema; FromTokens: TStrings);
var
  TokenIndex: Integer;
  Catalog: string;
  Schema: string;
  Table: string;
  Alias: string;
  CurrentValue: string;
  CurrentType: TZTokenType;
  CurrentUpper: string;
  ReadTable: Boolean;

  procedure ClearElements;
  begin
    Catalog := '';
    Schema := '';
    Table := '';
    Alias := '';
    ReadTable := True;
  end;

begin
  TokenIndex := 1;

  ClearElements;
  while TokenIndex < FromTokens.Count do
  begin
    CurrentValue := FromTokens[TokenIndex];
    CurrentUpper := AnsiUpperCase(CurrentValue);
    CurrentType := TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
      FromTokens.Objects[TokenIndex]{$IFDEF FPC}){$ENDIF});

    { Processes from join keywords. }
    if FromJoins.IndexOf(CurrentUpper) >= 0 then
    begin
      if Table <> '' then
        SelectSchema.AddTable(TZTableRef.Create(Catalog, Schema, Table, Alias));
      ClearElements;
      SkipOptionTokens(FromTokens, TokenIndex, FromJoins);
      Continue;
    end
    { Skips from clause keywords. }
    else if FromClauses.IndexOf(CurrentUpper) >= 0 then
    begin
      Inc(TokenIndex);
      CurrentValue := FromTokens[TokenIndex];
      CurrentUpper := AnsiUpperCase(CurrentValue);
      while (TokenIndex < FromTokens.Count)
        and (FromJoins.IndexOf(CurrentUpper) < 0) and (CurrentUpper <> ',') do
      begin
        if CurrentUpper = '(' then
            SkipBracketTokens(FromTokens, TokenIndex)
        else Inc(TokenIndex);
        if TokenIndex < FromTokens.Count then
          begin
            CurrentValue := FromTokens[TokenIndex];
            CurrentUpper := AnsiUpperCase(CurrentValue);
            CurrentType := TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
              FromTokens.Objects[TokenIndex]{$IFDEF FPC}){$ENDIF});
          end;
      end;
      // We must jump 1 tokens back now when we stopped on a Join clause.
      // Otherwise the next table is skipped
      if FromJoins.IndexOf(CurrentUpper) >= 0 then
        begin
          Dec(TokenIndex);
          CurrentValue := FromTokens[TokenIndex];
          CurrentUpper := AnsiUpperCase(CurrentValue);
        end;
    end
    { Switches to alias part. }
    else if (CurrentType = ttWhitespace) or (CurrentUpper = 'AS') then
    begin
      ReadTable := ReadTable and (Table = '') and (CurrentUpper <> 'AS');
    end
    { Reads table. }
    else if ReadTable and ((CurrentType = ttWord) or (CurrentType = ttQuotedIdentifier)) then
    begin
      {Catalog := Schema;
      Schema := Table;}
      Table := CurrentValue;
    end
    { Skips a '.' in table part. }
    else if ReadTable and (CurrentValue = '.') then
    begin
      Catalog := Schema;
      Schema := Table;
      Table := '';
    end
    { Reads alias. }
    else if not ReadTable and (CurrentType = ttWord) then
    begin
      Alias := CurrentValue;
    end;
    { Ends field reading. }
    if CurrentValue = ',' then
    begin
      if Table <> '' then
        SelectSchema.AddTable(TZTableRef.Create(Catalog, Schema, Table, Alias));
      ClearElements;
    end;
    { Skips till the next field. }
    if CurrentValue = '(' then
      SkipBracketTokens(FromTokens, TokenIndex)
    else Inc(TokenIndex);
  end;

  { Creates a reference to the last processed field. }
  if Table <> '' then
    SelectSchema.AddTable(TZTableRef.Create(Catalog, Schema, Table, Alias));
end;
{$HINTS ON}
{**
  Extracts a select schema from the specified parsed select statement.
  @param Sections a list of sections.
  @return a select statement schema.
}
function TZGenericStatementAnalyser.DefineSelectSchemaFromSections(
  Sections: TObjectList): IZSelectSchema;
var
  SelectTokens: TStrings;
  FromTokens: TStrings;
begin
  Result := nil;
  { Checks for the correct select statement. }
  if (Sections.Count < 2)
    or not ((TZStatementSection(Sections[0]).Name = 'SELECT')
    or ((TZStatementSection(Sections[0]).Name = '')
    and (TZStatementSection(Sections[1]).Name = 'SELECT'))) then
    Exit;

  { Defins sections. }
  SelectTokens := FindSectionTokens(Sections, 'SELECT');
  FromTokens := FindSectionTokens(Sections, 'FROM');
  if (SelectTokens = nil) or (FromTokens = nil) then
    Exit;

  { Creates and fills the result object. }
  Result := TZSelectSchema.Create;
  FillFieldRefs(Result, SelectTokens);
  FillTableRefs(Result, FromTokens);
end;

{**
  Defines a select schema from the specified SQL query.
  @param Tokenizer a tokenizer object.
  @param SQL a SQL query.
  @return a select statement schema.
}
function TZGenericStatementAnalyser.DefineSelectSchemaFromQuery(
  Tokenizer: IZTokenizer; const SQL: string): IZSelectSchema;
var
  Tokens: TStrings;
  Sections: TObjectList;
begin
  Tokens := TokenizeQuery(Tokenizer, SQL, True);
  Sections := SplitSections(Tokens);
  try
    Result := DefineSelectSchemaFromSections(Sections);
  finally
    Tokens.Free;
    Sections.Free;
  end;
end;

end.

