// Productivity Experts by Chua Chee Wee, Singapore
//
// Chua Chee Wee,
// Singapore
// Initial work - 21 Apr 2005.
//
// Blog: http://blogs.borland.com/chewy

unit TextUtils;

interface

const
  Whitespace = '(?:\s*)';

/// <summary>
/// Remove spaces in between non identifiers
/// </summary>
/// <param name="AText" type="string"></param>
/// <returns>string</returns>
function StripSpaces(const AText: string): string;

/// <summary>
/// Counts the number of occurances of Ch in AText
/// </summary>
/// <param name="AText" type="string"></param>
/// <param name="Ch" type="Char"></param>
/// <returns>Integer</returns>
function CharCount(const AText: string; Ch: Char): Integer;

/// <summary>
/// Gets text from AText, inclusive of balanced number Ch1 and Ch2 chars...
/// </summary>
/// <param name="AText" type="string"></param>
/// <param name="Ch" type="Char"></param>
/// <param name="Count" type="Integer"></param>
/// <returns>string</returns>
function BalancedText(const AText: string; const Ch1, Ch2: Char; const Count: Integer): string;

function BalancedTextReg(const AText: string; const Ch1, Ch2: Char; const Count: Integer): string;

implementation
  uses SysUtils, DeclParserIntf;

function StripSpaces(const AText: string): string;
var
  Parser: IRegExp2;
  MatchCollection: IMatchCollection2;
  Match: IMatch2;
  Submatches: ISubMatches;
begin
  Parser := CoRegExp.Create;
  Parser.Global := True;
  Result := AText;

  // Strip leading spaces
  Parser.Pattern := '^\s*([^\s]*)';
  if Parser.Test(Result) then
    Result := Parser.Replace(Result, '$1');

  Parser.Pattern := '(\s){2,}'; // Replace 2 or more spaces with 1
  if Parser.Test(Result) then
    Result := Parser.Replace(Result, ' ');

  // Parser.Pattern := '(\!|\.|\?|\;|\,|\:)\s';
  // Result := Parser.Replace(Result, '$1');

  Parser.Pattern := '\s([^\w+])';
  if Parser.Test(Result) then
    Result := Parser.Replace(Result, '$1');

  Parser.Pattern := '(\s+)?([^\s\w]+)(?:\s+)';
  if Parser.Test(Result) then
    Result := Parser.Replace(Result, '$2');

end;

function CharCount(const AText: string; Ch: Char): Integer;
var
  Parser: IRegExp2;
  MatchCollection: IMatchCollection2;
begin
  Result := 0;
  Parser := CoRegExp.Create;
  Parser.Pattern := Format('\%s', [Ch]);
  Parser.Global := True;
  if Parser.Test(AText) then
    begin
      MatchCollection := Parser.Execute(AText) as IMatchCollection2;
      Result := MatchCollection.Count;
    end;
end;

function BalancedText(const AText: string; const Ch1, Ch2: Char; const Count: Integer): string;
var
  Text: string;
  I, Ch1Count, Ch2Count: Integer;
begin
  Text := ''; Ch1Count := 0; Ch2Count := 0;
  for I := 1 to Length(AText) do
    begin
      if AText[I] = Ch1 then Inc(Ch1Count) else
      if AText[I] = Ch2 then Inc(Ch2Count);
      Text := Text + AText[I];
      if (Ch1Count = Count) and (Ch2Count = Count) then Break;
    end;
  Result := Text;
end;

function BalancedTextReg(const AText: string; const Ch1, Ch2: Char; const Count: Integer): string;
var
  Parser: IRegExp2;
  MatchCollection: IMatchCollection2;
begin
  Result := '';
  Parser := CoRegExp.Create;
  Parser.Pattern := Format('\%s', [Ch1]);
  Parser.Global := True;
  if Parser.Test(AText) then
    begin
      MatchCollection := Parser.Execute(AText) as IMatchCollection2;
      // Result := MatchCollection.Count;
    end;
end;

end.
