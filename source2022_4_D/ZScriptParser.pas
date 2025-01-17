{*********************************************************}
{                                                         }
{                     Zeos SQL Shell                      }
{                 Script Parsing Classes                  }
{                                                         }
{         Originally written by Sergey Seroukhov          }
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

unit ZScriptParser;

interface

{$I ZParseSql.inc}

uses Classes, SysUtils, ZTokenizer;

type
  {** Defines a SQL delimiter type. }
  TZDelimiterType = (dtDefault, dtDelimiter, dtGo, dtSetTerm, dtEmptyLine);

  {** Implements a SQL script parser. }
  TZSQLScriptParser = class
  private
    FDelimiter: string;
    FDelimiterType: TZDelimiterType;
    FCleanupStatements: Boolean;
    FTokenizer: IZTokenizer;
    FUncompletedStatement: string;
    FStatements: TStrings;

    function GetStatementCount: Integer;
    function GetStatement(Index: Integer): string;

  public
    constructor Create;
    constructor CreateWithTokenizer(Tokenizer: IZTokenizer);
    destructor Destroy; override;

    procedure Clear;
    procedure ClearCompleted;
    procedure ClearUncompleted;

    procedure ParseText(const Text: string);
    procedure ParseLine(const Line: string);

    property Delimiter: string read FDelimiter write FDelimiter;
    property DelimiterType: TZDelimiterType read FDelimiterType
      write FDelimiterType default dtDefault;
    property CleanupStatements: Boolean read FCleanupStatements
      write FCleanupStatements default True;
    property Tokenizer: IZTokenizer read FTokenizer write FTokenizer;
    property UncompletedStatement: string read FUncompletedStatement;
    property StatementCount: Integer read GetStatementCount;
    property Statements[Index: Integer]: string read GetStatement;
  end;

implementation

uses ZMessages, ZSysUtils;

{ TZSQLScriptParser }

{**
  Constructs this script parser class.
}
constructor TZSQLScriptParser.Create;
begin
  FStatements := TStringList.Create;
  FDelimiter := ';';
  FDelimiterType := dtDefault;
  FCleanupStatements := True;
end;

{**
  Creates this object and assignes a tokenizer object.
  @param Tokenizer a tokenizer object.
}
constructor TZSQLScriptParser.CreateWithTokenizer(Tokenizer: IZTokenizer);
begin
  Create;
  FTokenizer := Tokenizer;
end;

{**
  Destroys this class and cleanups the memory.
}
destructor TZSQLScriptParser.Destroy;
begin
  FreeAndNil(FStatements);
  FTokenizer := nil;
  inherited Destroy;
end;

{**
  Gets SQL statements number.
  @returns SQL statements number.
}
function TZSQLScriptParser.GetStatementCount: Integer;
begin
  Result := FStatements.Count;
end;

{**
  Gets a parsed SQL statement by it's index.
  @param Index a statement index.
  @returns a SQL statement string.
}
function TZSQLScriptParser.GetStatement(Index: Integer): string;
begin
  Result := FStatements[Index];
end;

{**
  Clears all completed and uncompleted statements and line delimiter.
}
procedure TZSQLScriptParser.Clear;
begin
  FStatements.Clear;
  FDelimiter := ';';
  FUncompletedStatement := '';
end;

{**
  Clears only completed statements.
}
procedure TZSQLScriptParser.ClearCompleted;
begin
  FStatements.Clear;
end;

{**
  Clears completed and uncompleted statements.
}
procedure TZSQLScriptParser.ClearUncompleted;
begin
  FStatements.Clear;
  FUncompletedStatement := '';
end;

{**
  Parses incrementaly only one single line.
  The line appends with EOL character.
  @param Line a line to be parsed.
}
procedure TZSQLScriptParser.ParseLine(const Line: string);
begin
  ParseText(#10 + Line + #10);
end;

{**
  Parses a complete text with several lines.
  @oaram Text a text of the SQL script to be parsed.
}
procedure TZSQLScriptParser.ParseText(const Text: string);
const SetTerm = String('SET TERM ');
var
  Tokens: TStrings;
  TokenType: TZTokenType;
  TokenValue: string;
  TokenIndex, LastStmtEndingIndex, iPos: Integer;
  SQL, Temp: string;
  EndOfStatement: Boolean;
  Extract: Boolean;
  LastComment: String;

  function CountChars(const Str: string; Chr: Char): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 1 to Length(Str) do
    begin
      if Str[I] = Chr then
        Inc(Result);
    end;
  end;

  procedure SetNextToken;
  begin
    TokenValue := Tokens[TokenIndex];
    TokenType := TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
      Tokens.Objects[TokenIndex]{$IFDEF FPC}){$ENDIF});
    if TokenValue = Delimiter  then
      LastStmtEndingIndex := TokenIndex;
    Inc(TokenIndex);
  end;

begin
  if Tokenizer = nil then
    raise Exception.Create(STokenizerIsNotDefined);

  if CleanupStatements then
    Tokens := Tokenizer.TokenizeBufferToList(Text, [toSkipComments])
  else Tokens := Tokenizer.TokenizeBufferToList(Text, []);

  if ( (DelimiterType = dtDelimiter) or
       (DelimiterType = dtSetTerm) ) and
     ( Delimiter = '' ) then
    Delimiter := ';'; //use default delimiter

  if (DelimiterType = dtDefault) then
    Delimiter := ';'; //use default delimiter

  TokenIndex := 0;
  SQL := FUncompletedStatement;
  if SQL <> '' then
  begin
    if CleanupStatements then
      SQL := SQL + ' '
    else SQL := SQL + #10;
  end;
  FUncompletedStatement := '';
  FStatements.Clear;
  try
    repeat
      SetNextToken;

      case DelimiterType of
        dtGo:
          EndOfStatement := (UpperCase(TokenValue) = 'GO');
        dtEmptyLine:
          begin
            EndOfStatement := False;
            if TokenType = ttWhitespace then
            begin
              Temp := TokenValue;
              while (CountChars(Temp, #10) < 2) and (TokenType = ttWhitespace) do
              begin
                SetNextToken;
                if TokenType = ttWhitespace then
                  Temp := Temp + TokenValue;
              end;
              EndOfStatement := (TokenType = ttWhitespace) or EndsWith(Sql, #10);
              if not EndOfStatement then
              begin
                if SQL <> '' then
                  SQL := Trim(SQL) + ' ';
              end;
            end;
          end;
        dtDelimiter,
        dtDefault,
        dtSetTerm:
          begin
            EndOfStatement := False;
            if not (TokenType in [ttWhitespace, ttEOF]) then
            begin
              if (DelimiterType = dtDelimiter) and (Uppercase(TokenValue) = 'DELIMITER') then
              begin
                Delimiter := '';
                Temp := TokenValue; {process the DELIMITER}
                Temp := Temp + Tokens[TokenIndex]; {process the first ' ' char}
                Inc(TokenIndex);
                while TokenType <> ttWhitespace do
                begin
                  SetNextToken;
                  if not (TokenType in [ttWhitespace, ttEOF]) then
                    Delimiter := Delimiter + TokenValue; //get the new delimiter
                end;
                SQL := SQL + Temp + Delimiter;
                EndOfStatement := True;
              end
              else
              begin
                Temp := TokenValue;
                Extract := True;
                while (Delimiter[1]=Temp[1]) and
                      (Length(Delimiter) > Length(Temp))
                       and not (TokenType in [ttWhitespace, ttEOF]) do
                begin
                  SetNextToken;

                  if not (TokenType in [ttWhitespace, ttEOF]) then
                  begin
                    Temp := Temp + TokenValue;
                    Extract := True;
                  end else
                    Extract := False;
                end;
                EndOfStatement := (Delimiter = Temp);
                if not EndOfStatement then
                begin
                  if Extract then
                    Temp := Copy(Temp, 1, Length(Temp) - Length(TokenValue));
                  SQL := SQL + Temp;
                end;
              end;
            end;
          end;
        else
          EndOfStatement := False;
      end;

      if TokenType = ttEOF then Break;

      { Processes the end of statements. }
      if EndOfStatement then
      begin
        if CleanupStatements then
          SQL := Trim(SQL);
        if SQL <> '' then
        begin
          if not CleanupStatements then
            Temp := Trim(SQL)
          else Temp := SQL;
          if (DelimiterType = dtSetTerm) and StartsWith(UpperCase(Temp), SetTerm) then
              Delimiter := Copy(Temp, 10, Length(Temp) - 9)
            else
              if (DelimiterType = dtSetTerm) and ( Pos(SetTerm, UpperCase(Temp)) > 0) then
              begin
                iPos := Pos(SetTerm, UpperCase(Temp))+8;
                Delimiter := Copy(Temp, iPos+1, Length(Temp) - iPos);
                LastComment := TrimRight(Copy(Temp, 1, iPos-9));
              end
              else
                if (DelimiterType = dtDelimiter)
                  and StartsWith(UpperCase(Temp), 'DELIMITER ') then
                  Delimiter := Copy(Temp, 11, Length(Temp) - 10)
                else
                begin
                  if (DelimiterType = dtEmptyLine) and EndsWith(SQL, ';') then
                    SQL := Copy(SQL, 1, Length(SQL) - 1);
                  if LastComment <> '' then
                    SQL := LastComment+#13#10+SQL;
                  if CleanupStatements then
                    SQL := Trim(SQL);
                  FStatements.Add(SQL);
                  LastComment := '';
                end;
        end;
        SQL := '';
      end
      { Adds a whitespace token. }
      else if CleanupStatements and (TokenType = ttWhitespace) then
      begin
        if SQL <> '' then
          SQL := Trim(SQL) + ' ';
      end
      { Adds a default token. }
      else
      begin
        // --> ms, 20/10/2005
        // TokenValue is not a ttWhitespace (#32)
        if (TokenType = ttWhitespace) and (TokenValue > '') then begin
          // SQL is not emtyp
          if (SQL <> '') then begin
            // is last token:
            if (Tokenindex = Tokens.count-1) then
              TokenValue := '';
            // next(!) token is also ttWhitespace or delimiter
            // (TokenIndex was already incremented!)
            if (Tokenindex < Tokens.count-1) then
              if ((TZTokenType({$IFDEF FPC}Pointer({$ENDIF}
                Tokens.Objects[TokenIndex]{$IFDEF FPC}){$ENDIF}) = ttWhitespace) or
                (Tokens[TokenIndex] = Delimiter))  then
                TokenValue := '';
          end
          // SQL is empty
          else
            TokenValue := '';
        end;
        if ((SQL = '') and (trim(TokenValue) = '')) then
          TokenValue := '';
        // <-- ms
        SQL := SQL + TokenValue;
      end;
    until TokenType = ttEOF;
    if ( LastComment <> '' ) and ( FStatements.Count > 0) then
      if CleanupStatements then
        FStatements[FStatements.Count-1] := FStatements[FStatements.Count-1]+' '+Trim(LastComment)
      else
        FStatements[FStatements.Count-1] := FStatements[FStatements.Count-1]+#13#10+LastComment;
  finally
    Tokens.Free;
  end;

  if CleanupStatements then
    SQL := Trim(SQL);
  if SQL <> '' then
    FUncompletedStatement := SQL;
end;

end.
