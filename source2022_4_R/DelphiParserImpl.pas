unit DelphiParserImpl;

interface

function ParseDelphiDeclaration(const Declaration: string): string;
function ParseDelphiMethodName(const AText: string; out Name: string): Boolean;

implementation
uses
{$IF NOT DEFINED(VBParser)}
  DeclParserIntf,
{$ELSEIF DEFINED(NETParser)}
  RegExWrapper_TLB,
{$IFEND}
  SysUtils, TextUtils, XMLCommentsParserImpl;

function ParseReturnType(const AText: string): string;
var
  Parser: IRegExp2;
  MatchCollection: IMatchCollection2;
  Match: IMatch2;
begin
  Result := '';
  Parser := CoRegExp.Create;
  Parser.Global := True;

  // Look for one of the following
  // 1) : [Namespace.[Namespace. ...]]Type
  
  Parser.Pattern := '((\w+)\.)*\w+';

  MatchCollection := Parser.Execute(AText) as IMatchCollection2;
  if MatchCollection.Count = 0 then
    exit;
  Match := MatchCollection.Item[0] as IMatch2;
  Result := Match.Value;
end;

function ParseDefaultValue(const AText: string): string;
var
  Parser: IRegExp2;
  MatchCollection: IMatchCollection2;
  Match: IMatch2;
  Submatches: ISubMatches;
  Text: string;
begin
  Result := '';
  Parser := CoRegExp.Create;
  Parser.Global := True;

  // Look for one of
  // 1) = 'some string'
  // 2) = Identifier
  // 3) = nnnn (where nnnn is digits) // not supporting real numbers...
  Parser.Pattern := '\s*\=\s*(''.*''|\w+|(\+|\-)?\d+\.\d+)';

  MatchCollection := Parser.Execute(AText) as IMatchCollection2;

  if MatchCollection.Count = 0 then exit;
  Match := MatchCollection.Item[0] as IMatch2;
  Submatches := Match.SubMatches as ISubMatches;
  Text := Submatches[0];
  Result := Text;
end;

function ParseTypeName(const AText: string): string;
var
  Parser: IRegExp2;
  MatchCollection: IMatchCollection2;
  Match: IMatch2;
  Submatches: ISubMatches;
  Text: string;
begin
  Parser := CoRegExp.Create;
  Parser.Global := True;

  // Look for one of the following
  // 1) : Type
  // 2) : [Namespace.[Namespace. ...]]Type

  Parser.Pattern := '(?:\s*\:\s*)&?(((\w+)\.)*(\w+))';

  MatchCollection := Parser.Execute(AText) as IMatchCollection2;
  Assert(MatchCollection.Count = 1);
  Match := MatchCollection.Item[0] as IMatch2;
  Submatches := Match.SubMatches as ISubMatches;
  Text := Submatches[0];
  Result := Text;
end;

procedure ParseParamNames(Routine: TRoutineDeclaration; const AText: string);
var
  Parser: IRegExp2;
  MatchCollection: IMatchCollection2;
  Match: IMatch2;
  Submatches: ISubMatches;
  I: Integer;
  ParamName, Token, TypeName, Default: string;
begin
  TypeName := ParseTypeName(AText);
  Default := ParseDefaultValue(AText);
  Parser := CoRegExp.Create;
  Parser.IgnoreCase := True;

// Look for identifiers, or identifiers: 
  Parser.Pattern := '&?(((\w+)\.)*\w+)(?:\s*,|:)';

  Parser.Global := True;

  MatchCollection := Parser.Execute(AText) as IMatchCollection2;
  for I := 0 to MatchCollection.Count - 1 do
    begin
      Match := MatchCollection.Item[I] as IMatch2;
      Token := Match.Value;
      Submatches := Match.SubMatches as ISubMatches;
      ParamName := Submatches[0];
      Routine.AddParam(pkByVal, ParamName, TypeName, Default);
    end;
end;

function ParseSingleDeclaration(Routine: TRoutineDeclaration; const AText: string): TParamType;
var
  Parser: IRegExp2;
  MatchCollection: IMatchCollection2;
  Match: IMatch2;
  I: Integer;
begin
  Parser := CoRegExp.Create;
  Parser.IgnoreCase := True;
  Parser.Pattern := '((const|var|out)?(?:\s)*&?(\w+)(\s*,\s*\w+)*(?:\s*\:\s*)&?((\w+)\.)*(\w+)(\s*\=\s*(''.*''|\w+|\d+))?)';
  MatchCollection := Parser.Execute(AText) as IMatchCollection2;
  for I := 0 to MatchCollection.Count - 1 do
    begin
      Match := MatchCollection.Item[I] as IMatch2;
      ParseParamNames(Routine, Match.Value);
    end;
end;

function ParseTypeDeclaration(Routine: TRoutineDeclaration; const AText: string): TParamType;
var
  Parser: IRegExp2;
  MatchCollection: IMatchCollection2;
  Match: IMatch2;
  I: Integer;
  Text: string;
begin
  Parser := CoRegExp.Create;
  Parser.Global := True; Parser.IgnoreCase := True;

// A single type declaration is something that is followed by (optionally) a semicolon
  Parser.Pattern := '([^;]*)(\;)?';

  MatchCollection := Parser.Execute(AText) as IMatchCollection2;
  for I := 0 to MatchCollection.Count - 1 do
    begin
      Match := MatchCollection.Item[I] as IMatch2;
      Text := Match.Value;
      if Text <> '' then
        ParseSingleDeclaration(Routine, Text);
    end;
end;

procedure ParseParams(const AText: string);
var
  Parser: IRegExp2;
begin
  Parser := CoRegExp.Create;
  Parser.Pattern := '';
end;

/// <summary>
/// Parses a valid Delphi routine declaration.
/// NOTE: Free the return class after use.
/// </summary>
/// <param name="AText" type="string">Contains one or more lines of text in the editor</param>
/// <returns>TRoutineDeclaration</returns>
function Parse(const AText: string): TRoutineDeclaration;
var
  Parser: IRegExp2;
  MatchCollection: IMatchCollection2;
  Match: IMatch2;
  Submatches: ISubMatches;
  I: Integer;
  Pattern, ReturnType,
    IsClass, ClassName, RoutineType, RoutineName, Text: string;
  Routine: TRoutineDeclaration;
begin
  Routine := nil;
  Parser := CoRegExp.Create;
  try
    Parser.IgnoreCase := True;
    Parser.Global := False;
    Pattern :=
      '^' +        // beginning of line
      Whitespace +
      '(class)?' + // optional static class
      Whitespace +
//  '((con|de)structor|function|operator|procedure)'+
    '(constructor|destructor|function|operator|procedure)' +
      Whitespace +
      '(\w+\.)*' + // optional class identifier followed by a dot
      '(\w+)' +    // routine name
      Whitespace +
      '((?:\()((?:\;?\s*)(const|var|out)?' +
      Whitespace +
      '&?(\w+)' + //  (optional &) parameter name
      '(,\s*\w+)*' + // additional parameters
      '(?:\s*\:\s*)' + // type separator

// (optional &) (optional scope/namespace) parameter type name
    '&?((\w*)\.)*(\w+)' +

    '(\s*\=\s*(''.*''|\w+|\d+))?' + // default parameters, no set support
      ')*(?:\)))*((?:\:\s*)' + // grr...
      '((\w*)\.)*(\w+))?;';    // optional return type
    Parser.Pattern := Pattern;
    if Parser.Test(AText) then
      begin
        MatchCollection := Parser.Execute(AText) as IMatchCollection2;
        for I := 0 to MatchCollection.Count - 1 do
          begin
            Match := MatchCollection.Item[I] as IMatch2;
            Submatches := Match.SubMatches as ISubMatches;

            IsClass := Submatches[0];
            RoutineType := Submatches[1];
            ClassName := Submatches[2];
            RoutineName := Submatches[3];
            Text := Submatches[14];
            ReturnType := ParseReturnType(Text);

            Routine := TRoutineDeclaration.Create(IsClass, RoutineType,
              ClassName, RoutineName, ReturnType);
            if Submatches.Count > 4 then
              begin
                Text := Submatches.Item[4];
                if Length(Text) > 0 then
                  begin
                    if Text[1] = '(' then Delete(Text, 1, 1);
                    if Text[Length(Text)] = ')' then Delete(Text, Length(Text), 1);
                    ParseTypeDeclaration(Routine, Text);
                  end;
              end;
          end;
      end else
      begin
        Routine := TRoutineDeclaration.Create('', '', '', '', '');
        // raise Exception.CreateFmt('Unable to parse declaration: %s', [AText]);
      end;
  finally
    Result := Routine;
  end;
end;

/// <summary>
/// Parses a valid routine declaration and then
/// returns a #13#10 delimited string
/// </summary>
/// <param name="Declaration" type="string"></param>
/// <returns>string</returns>
function ParseDelphiDeclaration(const Declaration: string): string;
var
  RoutineDeclaration: TRoutineDeclaration;
begin
  RoutineDeclaration := Parse(Declaration);
  Result := RoutineDeclaration.XML;
  RoutineDeclaration.Free;
end;


function ParseDelphiMethodName(const AText: string; out Name: string): Boolean;
var
  Parser: IRegExp2;
  MatchCollection: IMatchCollection2;
  Match: IMatch2;
  Submatches: ISubMatches;
  ClassName, RoutineName: string;
begin
  Result := False; ClassName := ''; RoutineName := '';
  Parser := CoRegExp.Create;
    Parser.IgnoreCase := True;
    Parser.Global := False;
    Parser.Pattern :=
      '^' +        // beginning of line
      Whitespace +
      '(class)?' + // optional static class
      Whitespace +
//  '((con|de)structor|function|operator|procedure)'+
    '(constructor|destructor|function|operator|procedure)' +
      Whitespace +
      '(\w+\.)*' + // optional class identifier followed by a dot
      '(\w+)';    // routine name

    if Parser.Test(AText) then
      begin
        MatchCollection := Parser.Execute(AText) as IMatchCollection2;
        Match := MatchCollection.Item[0] as IMatch2;
        Submatches := Match.SubMatches as ISubMatches;

        ClassName := Submatches[2];
        RoutineName := Submatches[3];
        Name := ClassName + RoutineName;
        Result := True;
      end;
end;

procedure TestParser;
  procedure TestParse(const AText: string);
  var
    RoutineDecl: TRoutineDeclaration;
  begin
    if IsConsole then
      begin
        WriteLn(AText);
        RoutineDecl := Parse(AText);
        WriteLn(RoutineDecl.XML);
        RoutineDecl.Free;
        ReadLn;
      end;
  end;

begin
  if not IsConsole then exit;
  TestParse('function X: Integer;');
  TestParse('procedure Y;');
  TestParse('function Y(X, Y:Integer; S: string): Boolean;   ');
  TestParse('function Y(X, Y, Z:Integer; S: string): Boolean;        ');
  TestParse('procedure Y(X: Integer=5);                              ');
  TestParse('procedure Y(X: string=''Hello world'');                 ');
  TestParse('procedure Y(X: string=''Hello world''; Y: string);      ');
  TestParse('function Y(X, Y:Integer): Boolean;                      ');
  TestParse('constructor Create(Test: Integer);                      ');
  TestParse('destructor Destroy;                                     ');
  TestParse('destructor Destroy();                                   ');
  TestParse('procedure Y(X: Integer);                                ');
  TestParse('procedure Y(X: Integer=5);                              ');
  TestParse('procedure Y(const X: Integer=5);                        ');
  TestParse('class procedure Y(const X: Integer=5);                  ');
  TestParse('class procedure TForm1.Y(const X: Integer=5);           ');
  TestParse('class function CheeWee.Expert(X, Y:Integer; S: string): Boolean;     ');
  TestParse('class function Y(X, Y, Z:Integer; S: string): Boolean;  ');
  TestParse('procedure AddParam(AParamKind: TParamKind; const AAName, AType, ADefault: string);');
  TestParse('function Y(X, Y:Integer; &S: string): System.Boolean;   ');
  TestParse('function Y(X, Y: System.Integer; &S: &System.string): System.Boolean;   ');
  TestParse('function Y(X, Y: System.Text.Integer; &S: &System.Text.RegularExpression): System.Boolean;   ');
  TestParse('procedure Y(X, Y: System.Text.Integer; &S: &System.Text.RegularExpression);');
  TestParse('procedure Y(var X, Y: System.Text.Integer; const &S: &System.Text.RegularExpression);');
  TestParse('procedure Y(out X, Y: TSomeObject);');
  TestParse('class operator Add(Left, Right: TMyClass): TMyClass;');
end;

initialization
  TestParser;
finalization
end.
