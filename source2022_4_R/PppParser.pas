{ **************************************************************************** }
{                                                                              }
{    Pascal PreProcessor Parser                                                }
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
{    The Original Code is PppParser.pas                                        }
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
{ $Id: PppParser.pas,v 1.3 2001/09/07 05:32:34 Administrator Exp $ }

unit PppParser;

interface

uses
  SysUtils, Classes, PppState, PppLexer, JclStrHashMap;

type
  EPppParserError = class(Exception);

  TPppParser = class
  private
    FLexer: TPppLexer;
    FState: TPppState;
    FDefineSymbols: Boolean; // Global var - Do we need to handle defines to "FState"
    FStatistics: TStringList;
    FParseFirstLevel: Boolean;
    function ParseConditional(DoFirstNode: Boolean): String;
    function ParseConditionalAll(DoFirstNode: Boolean): String;

    function StripCRLF(S: String; const StripLeft, StripRight: Boolean): String;
    procedure AddStatistics(Stencil, Data: String);
  protected
    function ParseText(aDefineSymbols: Boolean = True): string;
    function ParseIfdef: string;
    function ParseIfndef: string;
    function ParseInclude: string;
    function ParseIfopt: string;

    function ParseDefine: string;
    function ParseUndef: string;

    property Lexer: TPppLexer read FLexer;
    property State: TPppState read FState;
  public
    constructor Create(AStream: TStream; APppState: TPppState);
    destructor Destroy; override;
    function Parse: string;
    property Statistics: TStringList read FStatistics;
  end;

implementation

{ TPppParser }

constructor TPppParser.Create(AStream: TStream; APppState: TPppState);
begin
  Assert(AStream <> nil);
  Assert(APppState <> nil);

  FStatistics:= TStringList.Create;
  FStatistics.Sorted:= True;
  FLexer := TPppLexer.Create(AStream);
  FState := APppState;
  FDefineSymbols:= True;
end;

destructor TPppParser.Destroy;
begin
  FLexer.Free;
  FStatistics.Free;
  inherited;
end;

function TPppParser.Parse: string;
begin
  try
    FLexer.Reset;
    FParseFirstLevel:= True; // mark what we parsing starting from first level
    Result := ParseText(FDefineSymbols); // Use current convention
  except
    on EPppLexerError do
      raise; // already has error line info
    on e: Exception do
      Lexer.Error(e.Message);
  end;
end;

function TPppParser.ParseDefine: string;
begin
  AddStatistics('$Define    %s', Lexer.TokenAsString);

  if FDefineSymbols then
    State.Define(Lexer.TokenAsString);

  if State.IsPassThrough(Lexer.TokenAsString) then
    Result := Lexer.RawComment
  else
    Result := '';

  Lexer.NextTok;
end;

// if Symbol is defined when take first route, else take second one
function TPppParser.ParseConditional(DoFirstNode: Boolean): String;
var
  r1, r2: String;
begin
  // Revert node to take based on is symbol defined
  if not State.IsDefined(Lexer.TokenAsString) then
    DoFirstNode:= not DoFirstNode;

  Lexer.NextTok;
  r1:= ParseText(DoFirstNode);
  if Lexer.CurrTok = ptElse then
  begin
    Lexer.NextTok;
    r2:= ParseText(not DoFirstNode);
  end
  else
    r2:= '';

  if Lexer.CurrTok <> ptEndif then
    Lexer.Error('$ENDIF expected');
  Lexer.NextTok;

  if DoFirstNode then Result:= r1 else Result:= r2;

//  Result:= StripCRLF(Result, False, True);
end;

function TPppParser.ParseConditionalAll(DoFirstNode: Boolean): String;
begin
  AddStatistics('$If[n]def  %s', Lexer.TokenAsString);
  // Revert node to take based on is symbol defined
  if not State.IsDefined(Lexer.TokenAsString) then
    DoFirstNode:= not DoFirstNode;

  { pass everything through, including actual IFDEFs etc. }
  Result := Lexer.RawComment;
  Lexer.NextTok;
  Result := Result + ParseText(DoFirstNode);
  if Lexer.CurrTok = ptElse then
  begin
    Result := Result + Lexer.RawComment;
    Lexer.NextTok;
    Result := Result + ParseText(not DoFirstNode);
  end;
  if Lexer.CurrTok <> ptEndif then
    Lexer.Error('$ENDIF expected');
  Result := Result + Lexer.RawComment;
  Lexer.NextTok;
end;

function TPppParser.ParseIfdef: string;
begin
  if State.IsPassThrough(Lexer.TokenAsString) or (poCountUsage in State.Options)
    then Result:= ParseConditionalAll(True)
    else Result:= ParseConditional(True);
end;

function TPppParser.ParseIfndef: string;
begin
  if State.IsPassThrough(Lexer.TokenAsString) or (poCountUsage in State.Options)
    then Result:= ParseConditionalAll(False)
    else Result:= ParseConditional(False);
end;

function TPppParser.ParseIfopt: string;
var
  r1: String;
begin
  //todo: We should improve "ParseIfopt" function...

  Lexer.NextTok;
  // currently we just [wrongly] assume what option is not defined
  r1:= ParseText(False);
  if Lexer.CurrTok <> ptEndif then
    Lexer.Error('$ENDIF expected');
  Lexer.NextTok;

  Result:= '';
end;

function TPppParser.ParseInclude: string;
var
  oldLexer, newLexer: TPppLexer;
  fsIn: TStream;
begin
  Assert(Lexer.TokenAsString <> '');
  { we must prevent case of $I- & $I+ becoming file names }
  if Lexer.TokenAsString[1] in ['-', '+'] then
    Result := Lexer.RawComment
  else
  begin
    fsIn := nil;
    newLexer := nil;
    oldLexer := Lexer;
    try
      try
        fsIn := State.FindFile(Lexer.TokenAsString);
      except
        on e: Exception do
          Lexer.Error(e.Message);
      end;
      newLexer := TPppLexer.Create(fsIn);
      FLexer := newLexer;
      Result := Parse;
    finally
      FLexer := oldLexer;
      fsIn.Free;
      newLexer.Free;
    end;

    if State.IsBypassInclude(Lexer.TokenAsString)
      then Result:= Lexer.RawComment
      else AddStatistics('$Include   %s', Lexer.TokenAsString);
  end;
  Lexer.NextTok;
end;

function TPppParser.ParseText(aDefineSymbols: Boolean = True): string;
var
  strBuilder: TStrings;

  function BuildResult: string;
  var
    i, total: Integer;
    cp: PChar;
    ////////////
    cpOld, cpSrch,
    cpNew, cpEnd: PChar;
  begin
    // Set Result length to maximal possible length, correct later
    total := 0;
    for i := 0 to strBuilder.Count - 1 do
      total := total + Length(strBuilder[i]);
    SetLength(Result, total);
    FillChar(Result[1], total, #0);

// This is origanal (Barry Kelly) code
{    cp := Pointer(Result);
    for i := 0 to strBuilder.Count - 1 do
    begin
      Move(strBuilder[i][1], cp^, Length(strBuilder[i]));
      cp := cp + Length(strBuilder[i]);
    end; }
// End of original code

    cp:= Pointer(Result);
    i:= 0;
    while (i <= strBuilder.Count - 1) do // like < for i := 0 to strBuilder.Count - 1 do >
    begin
      // Append current TextBlock to Result string
      Move(strBuilder[i][1], cp^, Length(strBuilder[i]));
      cpOld:= cp;
      cp := cp + Length(strBuilder[i]);

      if (i = strBuilder.Count - 1) then Break; // no next Block => just exit;
      Inc(i);

      cpSrch:= cp;
      if Length(strBuilder[i-1]) > 0 then
      begin
        // Find where current line starts in TextBlock
        while (LongWord(cpSrch) >= LongWord(cpOld)) and
              (PChar(cpSrch)^ in [#9, #32, #0])
          do Dec(cpSrch);

        // Check if Start of string before Directive is not EMPTY
        if (LongWord(cpSrch) >= LongWord(cpOld)) and (PChar(cpSrch)^ <> #10)
        then Continue;

{        // Step back if we meet CRLF sequence
        if (LongWord(cpSrch) > LongWord(cpOld)) and (PChar(cpSrch-1)^ = #13)
        then Dec(cpSrch); }
        Inc(cpSrch);
      end;

      // At this point we SURE WHAT: Line before "directive" is empty
      // Also: "cpSrch" now contains pointer to start of current line

      // Now we need to check IS LINE IS EMPTY up to end in next block(s)
      while (i < strBuilder.Count) do // while exists next block(s)
      begin
        cpNew:= PChar(strBuilder[i]);
        cpEnd:= cpNew + Length(strBuilder[i]);

        // Find where current line ends in TextBlock
        while (LongWord(cpNew) < LongWord(cpEnd)) and
              (PChar(cpNew)^ in [#9, #13, #32]) do
        begin
          Inc(cpNew);
        end;
        // Check if End of string after Directive is not EMPTY
        if (LongWord(cpNew) < LongWord(cpEnd)) and (PChar(cpNew)^ <> #10)
        then Break;

        // So by this point we DISCOVERED WHAT either:
        //   1) end of line is empty or
        //   2) encountered new TextBlock

        // [if 1)] Empty end of line => we do:
        //   * Cut end of previous line
        //   * Modify current line in strBuilder
        if (LongWord(cpNew) <> LongWord(cpEnd)) then
        begin
          cp:= cpSrch; // now current position points to end of previous line
          strBuilder[i]:= Copy(strBuilder[i], (cpNew - PChar(strBuilder[i]) + 2), MaxInt);
          Break;
        end else
        // [if 2)] encountered new TextBlock => we do:
        //   * copy current block in <cp> string
        //   * Increment block number
        begin
          Move(strBuilder[i][1], cp^, Length(strBuilder[i]));
          cp := cp + Length(strBuilder[i]);
          Inc(i);
        end;
      end;
    end;

    SetLength(Result, cp - PChar(Result));
  end;

var
  OldDefineSymbols: Boolean;
begin
  // Store "Should we parse with <meaning> or only for syntaxis"
  OldDefineSymbols:= FDefineSymbols; FDefineSymbols:= aDefineSymbols;

  strBuilder := TStringList.Create;
  if Lexer.IsFirstToken and not (Lexer.CurrTok in [ptEof, ptText]) then
    strBuilder.Add('');

  try
    while True do
      case Lexer.CurrTok of
        ptComment:
        begin
          if not (poStripComments in State.Options) then
            strBuilder.Add(Lexer.TokenAsString);
          Lexer.NextTok;
        end;

        ptText:
        begin
          strBuilder.Add(Lexer.TokenAsString);
          Lexer.NextTok;
        end;

        ptOtherDirective:
        begin // Check if user allowed to remove some compiler defines
          if not State.IsSkipSomeDirectives(Lexer.TokenAsString) then
            strBuilder.Add(Lexer.RawComment);
          Lexer.NextTok;
        end;

        ptDefine, ptUndef, ptIfdef, ptIfndef, ptIfopt:
          if poProcessDefines in State.Options then
            case Lexer.CurrTok of
              ptDefine:
                strBuilder.Add(ParseDefine);
              ptUndef:
                strBuilder.Add(ParseUndef);
              ptIfdef:
                strBuilder.Add(ParseIfdef);
              ptIfndef:
                strBuilder.Add(ParseIfndef);
              ptIfopt:
                strBuilder.Add(ParseIfopt);
            end
          else
          begin
            strBuilder.Add(Lexer.RawComment);
            Lexer.NextTok;
          end;

        ptElse, ptEndif:
          if poProcessDefines in State.Options then
            Break
          else
          begin
            strBuilder.Add(Lexer.RawComment);
            Lexer.NextTok;
          end;

        ptInclude:
          if (poProcessIncludes in State.Options) and FDefineSymbols then
            strBuilder.Add(ParseInclude)
          else
          begin
            strBuilder.Add(Lexer.RawComment);
            Lexer.NextTok;
          end;
      else
        Break;
      end;

    Result := BuildResult;
    if (Lexer.CurrTok = ptEOF) and (Lexer.PrevToken = ptEndIf) then
      Result:= StripCRLF(Result, False, True);
  finally
    FDefineSymbols:= OldDefineSymbols;
    strBuilder.Free;
  end;
end;

function TPppParser.ParseUndef: string;
begin
  AddStatistics('$Undef     %s', Lexer.TokenAsString);

  if FDefineSymbols then
    State.Undef(Lexer.TokenAsString);

  if State.IsPassThrough(Lexer.TokenAsString) then
    Result := Lexer.RawComment
  else
    Result := '';

  Lexer.NextTok;
end;

procedure TPppParser.AddStatistics(Stencil, Data: String);
var
  Index, Value: Integer;
begin
  if (poCountUsage in State.Options) then
  begin
    // Prepare
    Data:= Format(Stencil, [Data]);

    // Process
    if FStatistics.Find(Data, Index) then
    begin // increment Counter
      value:= Integer(FStatistics.Objects[Index]);
      Inc(Value);
      FStatistics.Objects[Index]:= Pointer(Value);
    end else // add new item
      FStatistics.AddObject(Data, Pointer(1));
  end;
end;

function TPppParser.StripCRLF(S: String; const StripLeft,
  StripRight: Boolean): String;
var
  i: Integer;
  L, R: Integer;
begin
  if S = '' then
  begin
    Result:= '';
    Exit;
  end;

  L:= 1;
  if StripLeft then
  begin
    i:= 1;
    while (i < Length(S)) do
    begin
      if not (S[i] in [#9, #13, #32]) then Break;
      Inc(i);
    end;
    if (S[i] = #10) then L:= Succ(i); // Start copy from next char after LF
  end;

  R:= Length(S);
  if StripRight then
  begin
    i:= Length(S);
    while (i > 1) do
    begin
      if not (S[i] in [#9, #13, #32]) then Break;
      Dec(i);
    end;
    if (S[i] = #10) then
    begin
      R:= Pred(i); // Stop copy before LF
      if (i > 1) and (S[Pred(i)] = #13) then
        Dec(R); // Stop copy before CR (if exists)
    end;
  end;

  Result:= Copy(S, L, R-L+1);
end;

end.

