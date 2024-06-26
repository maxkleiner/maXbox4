{*********************************************************}
{                                                         }
{                 Zeos Database Objects                   }
{       String tokenizing classes for Generic SQL         }
{                                                         }
{       Originally written by Sergey Seroukhov                  }
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

unit ZGenericSqlToken;

interface

{$I ZParseSql.inc}

uses
  Classes, SysUtils, ZTokenizer, ZCompatibility;

type

  {** Implements a symbol state object. }
  TZGenericSQLSymbolState = class (TZSymbolState)
  public
    constructor Create;
  end;

  {** Implements a word state object. }
  TZGenericSQLWordState = class (TZWordState)
  public
    constructor Create;

    function NextToken(Stream: TStream; FirstChar: Char;
      Tokenizer: TZTokenizer): TZToken; override;
  end;

  {** Implements a quote string state object. }
  TZGenericSQLQuoteState = class (TZQuoteState)
  public
    function NextToken(Stream: TStream; FirstChar: Char;
      Tokenizer: TZTokenizer): TZToken; override;

    function EncodeString(const Value: string; QuoteChar: Char): string; override;
    function DecodeString(const Value: string; QuoteChar: Char): string; override;
  end;

  {** Implements a default tokenizer object. }
  TZGenericSQLTokenizer = class (TZTokenizer)
  public
    constructor Create;
  end;

implementation

{ TZGenericSQLSymbolState }

{**
  Creates this SQL-specific symbol state object.
}
constructor TZGenericSQLSymbolState.Create;
begin
  inherited Create;
  Add('<=');
  Add('>=');
  Add('<>');
  Add('<<');
  Add('>>');
end;

{ TZGenericSQLWordState }

{**
  Constructs this SQL-specific word state object.
}
constructor TZGenericSQLWordState.Create;
begin
  SetWordChars(#0, #191, False);
  SetWordChars(#192, high(char), True);
  SetWordChars('a', 'z', True);
  SetWordChars('A', 'Z', True);
  SetWordChars('0', '9', True);
  SetWordChars('$', '$', True);
  SetWordChars('_', '_', True);
end;

const
  {** List of keywords. }
  Keywords: array [0..8] of string = (
    'AND','OR','NOT','XOR','LIKE','IS','NULL','TRUE','FALSE'
  );

{**
  Gets a word tokens or special operators.
  @return a processed token.
}
function TZGenericSQLWordState.NextToken(Stream: TStream; FirstChar: Char;
  Tokenizer: TZTokenizer): TZToken;
var
  I: Integer;
  Temp: string;
begin
  Result := inherited NextToken(Stream, FirstChar, Tokenizer);
  Temp := UpperCase(Result.Value);

  for I := Low(Keywords) to High(Keywords) do
  begin
    if Temp = Keywords[I] then
    begin
      Result.TokenType := ttKeyword;
      Break;
    end;
  end;
end;


{ TZGenericSQLQuoteState }

{**
  Return a quoted string token from a reader. This method
  will collect characters until it sees a match to the
  character that the tokenizer used to switch to this state.

  @return a quoted string token from a reader
}
{$IFDEF FPC}
  {$HINTS OFF}
{$ENDIF}
function TZGenericSQLQuoteState.NextToken(Stream: TStream;
  FirstChar: Char; Tokenizer: TZTokenizer): TZToken;
var
  ReadChar: Char;
  LastChar: Char;
  ReadCounter, NumericCounter, CountDoublePoint, CountSlash, CountSpace : integer;
begin
  Result.Value := FirstChar;
  LastChar := #0;
  CountDoublePoint := 0;
  CountSlash := 0;
  CountSpace := 0;
  ReadCounter := 0;
  NumericCounter := 0;

  while Stream.Read(ReadChar, SizeOf(Char)) > 0 do
  begin
    if (LastChar = FirstChar) and (ReadChar <> FirstChar) then
    begin
      Stream.Seek(-SizeOf(Char), soFromCurrent);
      Break;
    end;
    if ReadChar = {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}TimeSeparator then
      inc(CountDoublePoint)
    else if ReadChar = {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DateSeparator then
      inc(CountSlash)
    else if ReadChar = ' ' then
      inc(CountSpace)
    else if CharInSet(ReadChar, ['0'..'9']) then
      inc(NumericCounter);
    Inc(ReadCounter);

    Result.Value := Result.Value + ReadChar;
    if (LastChar = FirstChar) and (ReadChar = FirstChar) then
      LastChar := #0
    else LastChar := ReadChar;
  end;

  if FirstChar = '"' then
    Result.TokenType := ttWord
  else Result.TokenType := ttQuoted;

  // Time constant
  if (CountDoublePoint = 2) and (CountSlash = 0) and
    ((NumericCounter + CountDoublePoint) = ReadCounter-1) then
  begin
    try
      if StrToTimeDef(DecodeString(Result.Value, FirstChar), 0) = 0 then
        Exit;
      Result.Value := DecodeString(Result.Value,'"');
      Result.TokenType := ttTime;
    except
    end;
  end;
  // Date constant
  if (CountDoublePoint = 0) and (CountSlash = 2) and
    ((NumericCounter + CountSlash) = ReadCounter-1) then
  begin
    try
      if StrToDateDef(DecodeString(Result.Value, FirstChar), 0) = 0 then
        Exit;
      Result.Value := DecodeString(Result.Value,'"');
      Result.TokenType := ttDate;
    except
    end;
  end;

  // DateTime constant
  if (CountDoublePoint = 2) and (CountSlash = 2) and
    ((NumericCounter + CountDoublePoint + CountSlash + CountSpace) = ReadCounter-1) then
  begin
    try
      if StrToDateTimeDef(DecodeString(Result.Value, FirstChar), 0) = 0 then
        Exit;
      Result.Value := DecodeString(Result.Value,'"');
      Result.TokenType := ttDateTime;
    except
    end;
  end;

  if not ( Result.TokenType in [ttQuoted, ttWord] ) then
    Exit;
  
  //No System-defaults found, Check for SQL format;
  {AStamp := TimestampStrToDateTime(DecodeString(Result.Value, FirstChar)); //minimize the handling
  if AStamp = 0 then
    Exit
  else
    if ( TDate(AStamp) <> EmptyDate ) then
      if ( TTime(AStamp) <> EmptyTime ) then
      begin
        Result.Value := DateTimeToStr(AStamp);
        Result.TokenType := ttDateTime;
      end
      else
      begin
        Result.Value := DateToStr(AStamp);
        Result.TokenType := ttDate;
      end
    else
      if ( TTime(AStamp) <> EmptyTime ) then
      begin
        Result.Value := TimeToStr(AStamp);
        Result.TokenType := ttTime;
      end;}
end;
{$IFDEF FPC}
  {$HINTS ON}
{$ENDIF}

{**
  Encodes a string value.
  @param Value a string value to be encoded.
  @param QuoteChar a string quote character.
  @returns an encoded string.
}
function TZGenericSQLQuoteState.EncodeString(const Value: string;
  QuoteChar: Char): string;
begin
  if CharInSet(QuoteChar, [#39, '"', '`']) then
    Result := AnsiQuotedStr(Value, QuoteChar)
  else Result := Value;
end;

{**
  Decodes a string value.
  @param Value a string value to be decoded.
  @param QuoteChar a string quote character.
  @returns an decoded string.
}
function TZGenericSQLQuoteState.DecodeString(const Value: string;
  QuoteChar: Char): string;
var
  Len: Integer;
begin
  Len := Length(Value);
  if (Len >= 2) and CharInSet(QuoteChar, [#39, '"', '`'])
    and (Value[1] = QuoteChar) and (Value[Len] = QuoteChar) then
  begin
    if Len > 2 then
      Result := AnsiDequotedStr(Value, QuoteChar)
    else Result := '';
  end
  else Result := Value;
end;

{ TZGenericSQLTokenizer }

{**
  Constructs a tokenizer with a default state table (as
  described in the class comment).
}
constructor TZGenericSQLTokenizer.Create;
begin
  NumberState := TZNumberState.Create;
  QuoteState := TZGenericSQLQuoteState.Create;
  WhitespaceState := TZWhitespaceState.Create;
  CommentState := TZCppCommentState.Create;

  SymbolState := TZGenericSQLSymbolState.Create;
  WordState := TZGenericSQLWordState.Create;

  SetCharacterState(#0, #32, WhitespaceState);
  SetCharacterState(#33, #191, SymbolState);
  SetCharacterState(#192, High(Char), WordState);

  SetCharacterState('a', 'z', WordState);
  SetCharacterState('A', 'Z', WordState);
  SetCharacterState('_', '_', WordState);
  SetCharacterState('$', '$', WordState);

  SetCharacterState('0', '9', NumberState);
  SetCharacterState('.', '.', NumberState);

  SetCharacterState('"', '"', QuoteState);
  SetCharacterState(#39, #39, QuoteState);
  SetCharacterState('`', '`', QuoteState);

  SetCharacterState('/', '/', CommentState);
end;

end.

