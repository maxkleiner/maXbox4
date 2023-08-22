{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10185: IdHeaderList.pas 
{
{   Rev 1.1    2/25/2003 12:47:34 PM  JPMugaas
{ Updated with Hadi's fix.  If complete boolean evaluation was on, the code
{ could sometimes with an index out of range.
}
{
{   Rev 1.0    2002.11.12 10:40:38 PM  czhower
}
unit IdHeaderList;

{
 2002-Jan-27 Don Siders
  - Modified FoldLine to include Comma in break character set.

 2000-May-31 J. Peter Mugaas
  - started this class to facilitate some work on Indy so we don't have to
    convert '=' to ":" and vice-versa just to use the Values property.
  }

{
 NOTE:  This is a modification of Borland's TStrings definition in a
        TStringList descendant.  I had to conceal the original Values to do
        this since most of low level property setting routines aren't virtual   
        and are private.
}

interface

uses
  Classes;

type
  TIdHeaderList = class(TStringList)
  protected
    FNameValueSeparator : String;
    FCaseSensitive : Boolean;
    FUnfoldLines : Boolean;
    FFoldLines : Boolean;
    FFoldLinesLength : Integer;
    //
    {This deletes lines which were folded}
    Procedure DeleteFoldedLines(Index : Integer);
    {This folds one line into several lines}
    function FoldLine(AString : string) : TStringList;
    {Folds lines and inserts them into a position, Index}
    procedure FoldAndInsert(AString : String; Index : Integer);
    {Name property get method}
    function GetName(Index: Integer): string;
    {Value property get method}
    function GetValue(const AName: string): string;
    {Value property set method}
    procedure SetValue(const Name, Value: string);
    {Gets a value from a string}
    function GetValueFromLine(ALine : Integer) : String;
    Function GetNameFromLine(ALine : Integer) : String;
  public
    procedure AddStdValues(ASrc: TStrings);
    procedure ConvertToStdValues(ADest: TStrings);
    constructor Create;
    { This method  given a name specified by AName extracts all of the values for that name - and puts them in a new string
    list (just the values) one per line in the ADest TStrings.}
    procedure Extract(const AName: string; ADest: TStrings);
    { This property works almost exactly as Borland's IndexOfName except it uses
      our deliniator defined in NameValueSeparator }
    function IndexOfName(const AName: string): Integer; reintroduce;
    { This property works almost exactly as Borland's Values except it uses
      our deliniator defined in NameValueSeparator }
    property Names[Index: Integer]: string read GetName;
    { This property works almost exactly as Borland's Values except it uses   
      our deliniator defined in NameValueSeparator }
    property Values[const Name: string]: string read GetValue write SetValue;
    { This is the separator we need to separate the name from the value }
    property NameValueSeparator : String read FNameValueSeparator
      write FNameValueSeparator;
    { Should the names be tested in a case-senstive manner. }
    property CaseSensitive : Boolean read FCaseSensitive write FCaseSensitive;
    { Should we unfold lines so that continuation header data is returned as
    well}
    property UnfoldLines : Boolean read FUnfoldLines write FUnfoldLines;
    { Should we fold lines we the Values(x) property is set with an
    assignment }
    property FoldLines : Boolean read FFoldLines write FFoldLines;
    { The Wrap position for our folded lines }
    property FoldLength : Integer read FFoldLinesLength write FFoldLinesLength;
  end;

implementation

uses
  IdGlobal,
  SysUtils;

{This is taken from Borland's SysUtils and modified for our folding}    {Do not Localize}
function FoldWrapText(const Line, BreakStr: string; BreakChars: TSysCharSet;
  MaxCol: Integer): string;
const
  QuoteChars = ['"'];    {Do not Localize}
var
  Col, Pos: Integer;
  LinePos, LineLen: Integer;
  BreakLen, BreakPos: Integer;
  QuoteChar, CurChar: Char;
  ExistingBreak: Boolean;
begin
  Col := 1;
  Pos := 1;
  LinePos := 1;
  BreakPos := 0;
  QuoteChar := ' ';    {Do not Localize}
  ExistingBreak := False;
  LineLen := Length(Line);
  BreakLen := Length(BreakStr);
  Result := '';    {Do not Localize}
  while Pos <= LineLen do
  begin
    CurChar := Line[Pos];
    if CurChar in LeadBytes then
    begin
      Inc(Pos);
      Inc(Col);
    end  //if CurChar in LeadBytes then
    else
      if CurChar = BreakStr[1] then
      begin
        if QuoteChar = ' ' then    {Do not Localize}
        begin
          ExistingBreak := AnsiSameText(BreakStr, Copy(Line, Pos, BreakLen));
          if ExistingBreak then
          begin
            Inc(Pos, BreakLen-1);
            BreakPos := Pos;
          end; //if ExistingBreak then
        end // if QuoteChar = ' ' then    {Do not Localize}
      end // if CurChar = BreakStr[1] then
      else
        if CurChar in BreakChars then
        begin
          if QuoteChar = ' ' then    {Do not Localize}
            BreakPos := Pos
        end  // if CurChar in BreakChars then
        else
        if CurChar in QuoteChars then
          if CurChar = QuoteChar then
            QuoteChar := ' '    {Do not Localize}
          else
            if QuoteChar = ' ' then    {Do not Localize}
              QuoteChar := CurChar;
    Inc(Pos);
    Inc(Col);
    if not (QuoteChar in QuoteChars) and (ExistingBreak or
      ((Col > MaxCol) and (BreakPos > LinePos))) then
    begin
      Col := Pos - BreakPos;
      Result := Result + Copy(Line, LinePos, BreakPos - LinePos + 1);
      if not (CurChar in QuoteChars) then
        while (Pos <= LineLen) and (Line[Pos] in BreakChars + [#13, #10]) do Inc(Pos);
      if not ExistingBreak and (Pos < LineLen) then
        Result := Result + BreakStr;
      Inc(BreakPos);
      LinePos := BreakPos;
      ExistingBreak := False;
    end; //if not
  end; //while Pos <= LineLen do
  Result := Result + Copy(Line, LinePos, MaxInt);
end;

{ TIdHeaderList }

procedure TIdHeaderList.AddStdValues(ASrc: TStrings);
var
  i: integer;
begin
  for i := 0 to ASrc.Count - 1 do begin
    Add(StringReplace(ASrc[i], '=', NameValueSeparator, []));    {Do not Localize}
  end;
end;

procedure TIdHeaderList.ConvertToStdValues(ADest: TStrings);
var
  i: integer;
begin
  for i := 0 to Count - 1 do begin
    ADest.Add(StringReplace(Strings[i], NameValueSeparator, '=', []));    {Do not Localize}
  end;
end;

constructor TIdHeaderList.Create;
begin
  inherited Create;
  FNameValueSeparator := ': ';    {Do not Localize}
  FCaseSensitive := False;
  FUnfoldLines := True;
  FFoldLines := True;
  { 78 was specified by a message draft available at
    http://www.imc.org/draft-ietf-drums-msg-fmt }
  FFoldLinesLength := 78;
end;

procedure TIdHeaderList.DeleteFoldedLines(Index: Integer);
begin
  Inc(Index);  {skip the current line}
  if Index < Count then begin
    while ( Index < Count ) and ( ( Length( Get( Index ) ) > 0) and
     (  Get( Index ) [ 1 ] = ' ' ) or (  Get( Index ) [ 1 ] = #9 ) ) do    {Do not Localize}
    begin
      Delete( Index );
    end; //while
  end;
end;

procedure TIdHeaderList.Extract(const AName: string; ADest: TStrings);
var idx : Integer;
begin
  if not Assigned(ADest) then
    Exit;
  for idx := 0 to Count - 1 do
  begin
    if AnsiSameText(AName, GetNameFromLine(idx)) then
    begin
      ADest.Add(GetValueFromLine(idx));
    end;
  end;
end;

procedure TIdHeaderList.FoldAndInsert(AString : String; Index: Integer);
var strs : TStringList;
    idx : Integer;
begin
  strs := FoldLine( AString );
  try
    idx :=  strs.Count - 1;
    Put(Index, strs [ idx ] );
    {We decrement by one because we put the last string into the HeaderList}
    Dec( idx );
    while ( idx > -1 ) do
    begin
      Insert(Index, strs [ idx ] );
      Dec( idx );
    end;
  finally
    FreeAndNil( strs );
  end;  //finally
end;

function TIdHeaderList.FoldLine(AString : string): TStringList;
var s : String;
begin
  Result := TStringList.Create;
  try
    {we specify a space so that starts a folded line}
    s := FoldWrapText(AString, EOL+' ', LWS+[','], FFoldLinesLength);    {Do not Localize}
    while s <> '' do    {Do not Localize}
    begin
      Result.Add( TrimRight( Fetch( s, EOL ) ) );
    end; // while s <> '' do    {Do not Localize}
  finally
  end; //try..finally
end;

function TIdHeaderList.GetName(Index: Integer): string;
var
  P: Integer;
begin
  Result := Get( Index );
  P := IndyPos( FNameValueSeparator , Result );
  if P <> 0 then
  begin
    SetLength( Result, P - 1 );
  end  // if P <> 0 then
  else
  begin
    SetLength( Result, 0 );
  end;  // else if P <> 0 then
  Result := Result;
end;

function TIdHeaderList.GetNameFromLine(ALine: Integer): String;
var p : Integer;
begin
  Result := Get( ALine );
  if not FCaseSensitive then
  begin
    Result := UpperCase( Result );
  end; // if not FCaseSensitive then
  {We trim right to remove space to accomodate header errors such as

  Message-ID:<asdf@fdfs
  }
  P := IndyPos( TrimRight( FNameValueSeparator ), Result );
  Result := Copy( Result, 1, P - 1 );
end;

function TIdHeaderList.GetValue(const AName: string): string;
begin
  Result := GetValueFromLine(IndexOfName(AName));
end;

function TIdHeaderList.GetValueFromLine(ALine: Integer): String;
var
  LFoldedLine: string;
  LName: string;
begin
  if (ALine >= 0) and (ALine < Count) then begin
    LName := GetNameFromLine(ALine);
    Result := Copy(Get(ALine), Length(LName) + 2, MaxInt);
    if FUnfoldLines then begin
      while True do begin
        Inc(ALine);
        if ALine = Count then begin
          Break;
        end;
        LFoldedLine := Get(ALine);
        // s[1] is safe since header lines cannot be empty as that causes then end of the header block
        if not (LFoldedLine[1] in LWS) then begin
          Break;
        end;
        Result := Trim(Result) + ' ' + Trim(LFoldedLine); {Do not Localize}
      end;
    end;
  end else begin
    Result := ''; {Do not Localize}
  end;
  // User may be fetching an folded line diretly.
  Result := Trim(Result);
end;

function TIdHeaderList.IndexOfName(const AName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do begin
    if AnsiSameText(GetNameFromLine(i), AName) then begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TIdHeaderList.SetValue(const Name, Value: string);
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if Value <> '' then    {Do not Localize}
  begin
    if I < 0 then
    begin
      I := Add( '' );    {Do not Localize}
    end; //if I < 0 then
    if FFoldLines then
    begin
      DeleteFoldedLines( I );
      FoldAndInsert( Name + FNameValueSeparator + Value, I );
    end
    else
    begin
      Put( I, Name + FNameValueSeparator + Value );
    end;  //else..FFoldLines
  end //if Value <> '' then    {Do not Localize}
  else
  begin
    if I >= 0 then
    begin
      if FFoldLines then
      begin
        DeleteFoldedLines( I );
      end;
      Delete( I );
    end; //if I >= 0 then
  end;  //else .. if Value <> '' then    {Do not Localize}
end;

end.
