{ **************************************************************************** }
{                                                                              }
{    Pascal PreProcessor Lexer                                                 }
{    Copyright (c) 2001 Barry Kelly.                                           }
{    barry_j_kelly@hotmail.com                                                 }
{                                                                              }
{    The contents of this file are subject to the Mozilla Public License       }
{    Version 1.1 (the "License"); you may not use this file except in          }
{    compliance with the License. You may obtain a copy of the License at      }
{    http://www.mozilla.org/MPL/                                               }
{                                                                              }
{    Software distributed under the License is distributed on an "AS IS"       }
{    basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the   }
{    License for the specific language governing rights and limitations        }
{    under the License.                                                        }
{                                                                              }
{    The Original Code is PppLexer.pas                                         }
{                                                                              }
{    The Initial Developer of the Original Code is Barry Kelly.                }
{    Portions created by Barry Kelly are Copyright (C) 2001                    }
{    Barry Kelly. All Rights Reserved.                                         }
{                                                                              }
{    Alternatively, the contents of this file may be used under the terms      }
{    of the Lesser GNU Public License (the  "LGPL License"), in which case     }
{    the provisions of LGPL License are applicable instead of those            }
{    above.  If you wish to allow use of your version of this file only        }
{    under the terms of the LPGL License and not to allow others to use        }
{    your version of this file under the MPL, indicate your decision by        }
{    deleting  the provisions above and replace  them with the notice and      }
{    other provisions required by the LGPL License.  If you do not delete      }
{    the provisions above, a recipient may use your version of this file       }
{    under either the MPL or the LPGL License.                                 }
{                                                                              }
{ **************************************************************************** }
{ $Id: PppLexer.pas,v 1.4 2001/09/07 05:32:34 Administrator Exp $ }

// {$DEFINE CleanupLineBreak} // this is not needed in this version

unit PppLexer;

interface

uses
  SysUtils, Classes, JclStrHashMap, PCharUtils;

type
  TPppToken = (
    // Text tokens
    ptEof, ptComment, ptText,
    // Tokens with Second Main part
    ptDefine, ptUndef, ptIfdef, ptIfndef, ptIfopt, ptInclude, 
    // Tokens without Second Main part
    ptElse, ptEndif, ptOtherDirective);

const
  TwoPartTokens = [ptDefine..ptInclude];

type
  EPppLexerError = class(Exception);

  TPppLexer = class
  private
    FBuf: string;
    FTokenHash: TStringHashMap;
    FCurrPos: PChar;
    FCurrLine: Integer;
    FCurrTok: TPppToken;
    FTokenAsString: string;
    FRawComment: string;
    FIsFirstToken: Boolean;
    FPrevToken: TPppToken;
  public
    constructor Create(AStream: TStream);
    destructor Destroy; override;

    procedure Error(const AMsg: string);
    procedure NextTok;
    procedure Reset;
    property CurrTok: TPppToken read FCurrTok;
    property IsFirstToken: Boolean read FIsFirstToken;
    property PrevToken: TPppToken read FPrevToken;
    { TokenAsString is the preprocessor symbol for $IFDEF & $IFNDEF,
      and the file name for $I and $INCLUDE, and is the actual text
      for ptComment and ptText. }
    property TokenAsString: string read FTokenAsString;
    { The raw comment for $IFDEF, etc. when TokenAsString becomes the
      file name / preprocessor symbol. }
    property RawComment: string read FRawComment;
  end;

implementation

{ TPppLexer }

constructor TPppLexer.Create(AStream: TStream);
  procedure AddToken(const AIdent: string; AValue: TPppToken);
  var
    x: Integer;
  begin
    x := Ord(AValue);
    FTokenHash.Add(AIdent, x);
  end;
begin
  FTokenHash := TStringHashMap.Create(CaseInsensitiveTraits, 19);

  AddToken('i', ptInclude);
  AddToken('include', ptInclude);
  AddToken('ifdef', ptIfdef);
  AddToken('ifndef', ptIfndef);
  AddToken('else', ptElse);
  AddToken('endif', ptEndif);
  AddToken('define', ptDefine);
  AddToken('undef', ptUndef);
  AddToken('ifopt', ptIfopt);

  SetLength(FBuf, AStream.Size);
  AStream.ReadBuffer(Pointer(FBuf)^, Length(FBuf));
  Reset;
end;

destructor TPppLexer.Destroy;
begin
  FTokenHash.Free;
  inherited;
end;

procedure TPppLexer.Error(const AMsg: string);
begin
  raise EPppLexerError.CreateFmt('(%d): %s', [FCurrLine, AMsg]);
end;

{ Brief: Helps remove needless line breaks after comments.
  Parameters:
    start: Start of comment.
    cp: One-past-end of comment.
  Returns:
    cp past line break if no text between previous line break and start.
  Description:
    The structure of a line with a comment looks like this:
      <eol> [<text>] <comment> [<eol>]
    where 'eol' is end of line. What this function does is skip past
    the eol at the end iff there is no <text> present.
  Note:
    This function <b>MUST NEVER</b> be called on the first line,
    because it tries to scan backwards - and that is invalid on
    the first line. }
function CleanupLineBreak(start, cp: PChar): PChar;
  function SkipWhiteExceptLineBreaks(cp: PChar): PChar;
  begin
    while cp^ in [#1..#9, #11, #12, #14..#32] do
      Inc(cp);
    Result := cp;
  end;
begin
  Result := cp;
  { if there is no immediately following eol then we need do nothing }
  cp := SkipWhiteExceptLineBreaks(cp);
  if not (cp^ in [#10, #13]) then
    Exit;

  { move start backwards until beginning of line }
  repeat
    Dec(start);
    case start^ of
      #0:
        Assert(False, 'literal null in text');
      #1..#32:
        ;
    else
      Exit;
    end;
  until start^ in [#10, #13];

  { since we got past the previous loop, there was no text before the
    comment; we can safely skip cp past the following line end }
  Inc(cp);
  if cp^ in [#10, #13] then
    Inc(cp);

  Result := cp;
end;

procedure TPppLexer.NextTok;

  procedure HandleDirective(APos: PChar);

    { needs to be special, because it checks for not * or }
    function ReadString(cp: PChar; var ident: string): PChar;
    var
      start: PChar;
    begin
      if cp^ = '"' then
      begin
        Inc(cp);
        start := cp;
        while not (cp^ in [#0, #10, #13, '"']) do
          Inc(cp);
        if cp^ in [#0, #10, #13] then
          Error('Unterminated string');
        SetString(ident, start, cp - start);
        Result := cp + 1;
      end
      else
      begin
        start := cp;
        while not (cp^ in [#0..#32, '*', '}']) do
          Inc(cp);
        if cp^ = #0 then
          Error('Unterminated string');
        SetString(ident, start, cp - start);
        Result := cp;
      end;
    end;

  var
    start: PChar;
    ident: string;
    tokInt: Integer;
  begin
    Assert(APos^ = '$');
    Inc(APos);
    start := APos;

    { read identifier }
    while APos^ in ['a'..'z', 'A'..'Z', '_'] do
      Inc(APos);
    SetString(ident, start, APos - start);

    { find identifier in hash map }
    if FTokenHash.Find(ident, tokInt) then
    begin
      FCurrTok := TPppToken(tokInt);

      if FCurrTok in TwoPartTokens then
        ReadString(SkipWhite(APos), FTokenAsString);
    end else
    begin
      { other directives propably must pass through }
      FCurrTok := ptOtherDirective;
      FTokenAsString:= ident;
    end;
  end;

var
  cp, start: PChar;
  cl: Integer;
label
  Label_NormalText;
begin
  FPrevToken:= FCurrTok;
  { register variables optimization }
  cp := FCurrPos;
  cl := FCurrLine;

  { determine token type }
  case cp^ of

    { the buck stops here }
    #0:
    begin
      FCurrTok := ptEof;
      Exit;
    end;

    { possible Standard Pascal comment }
    '(':
    begin
      if (cp + 1)^ <> '*' then
        goto Label_NormalText;
      start := cp;
      Inc(cp, 2);
      while True do
      begin
        case cp^ of
          #0:
            Break;
          #10:
            Inc(cl);
          '*':
            if (cp + 1)^ = ')' then
              Break;
        end;
        Inc(cp);
      end;
      if cp^ = '*' then
      begin
        Inc(cp, 2); // get whole of comment, including trailing '*)'
        { This is a conditional define because the semantic requirements
          of this function means it isn't trivial over a hundred
          thousand calls, say. }
        {$IFDEF CleanupLineBreak}
        if (cl > 1) and (FCurrLine > 1) then
          cp := CleanupLineBreak(start, cp);
        {$ENDIF}
      end;
      SetString(FTokenAsString, start, cp - start);
      FCurrTok := ptComment;
    end;

    { possible line comment }
    '/':
    begin
      if (cp + 1)^ <> '/' then
        goto Label_NormalText;
      start := cp;
      Inc(cp, 2);
      while True do
        case cp^ of
          #0, #10:
            Break;
        else
          Inc(cp);
        end;
      { if cp^ is #10, we leave it in, to avoid formatting cock-ups }
      { if Prev(cp)^ is #13 we also leave it in}
      if PChar(cp-1)^ = #13 then Dec(cp);
      SetString(FTokenAsString, start, cp - start);
      FCurrTok := ptComment;
    end;

    { pascal comment }
    '{':
    begin
      start := cp;
      while True do
      begin
        case cp^ of
          #0, '}':
            Break;
          #10:
            Inc(cl);
        end;
        Inc(cp);
      end;
      if cp^ = '}' then
      begin
        Inc(cp);
        {$IFDEF CleanupLineBreak}
        if (cl > 1) and (FCurrLine > 1) then
          cp := CleanupLineBreak(start, cp);
        {$ENDIF}
      end;
      SetString(FTokenAsString, start, cp - start);
      FCurrTok := ptComment;
    end;
  else
Label_NormalText:
    { process normal text; passes straight through until next comment or eof }
    start := cp;
    while True do
    begin
      case cp^ of
        #0:
          Break;
        #10:
          Inc(cl);
        '{':
          Break;
        '/':
          if (cp + 1)^ = '/' then
            Break;
        '(':
          if (cp + 1)^ = '*' then
            Break;

        { must handle strings separately; there can be no comments in strings }
        '''':
        begin
          Inc(cp);
          while True do
            case cp^ of
              #0, #10:
              begin
                FCurrLine := cl;
                Error('String not terminated');
              end;
              '''':
                Break;
            else
              Inc(cp);
            end; { of '''' case }
        end;
      end;
      Inc(cp);
    end;
    SetString(FTokenAsString, start, cp - start);
    FCurrTok := ptText;
  end;

  { find out if we have a special directive }
  if FCurrTok = ptComment then
  begin
    FRawComment := FTokenAsString;
    case (start + 1)^ of
      '$': // {$
        HandleDirective(start + 1);

      '*': // (*$
        if (start + 2)^ = '$' then
          HandleDirective(start + 2);
      '/': // do nothing
        ;
    end;
  end;

  { restore register variables }
  FCurrPos := cp;
  FCurrLine := cl;
  FIsFirstToken:= False;
end;

procedure TPppLexer.Reset;
begin
  FCurrPos := PChar(FBuf);
  FCurrLine := 1;
  FCurrTok:= ptEof;
  NextTok;
  FIsFirstToken:= True;
end;

end.
