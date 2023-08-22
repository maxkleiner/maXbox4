unit Simpat;

{
  This unit is a part of the D7X Library for Delphi 7.
  Simple Patterns by Proger_XP | http://proger.i-forge.net/RPNit
}

interface

uses Windows, SysUtils, Math, Classes, Contnrs, StringsW;

const
  SimpatDefaultEOLN = #10;

type
  // Simpat is aimed at matching binary streams.
  SimpatString = AnsiString;
  TLinearSimpat = class;
  TSimpatPattern = class;

  TSimpatContext = record
    Input: TStream;
    EOLN: SimpatString;
    Pattern: TSimpatPattern;  // for (debug) reference only; not used by Simpat.
    Linear: TLinearSimpat;    // same here.
    Custom: Pointer;          // not used by Simpat.
  end;

  TSimpatRangeBytes = class
  protected
    FBytes: array[0..High(Byte)] of Boolean;
    FIsInverted: Boolean;
    FMatchesEOLN: Boolean;
    FMatchesEOF: Boolean;
    FMatchesAll: Boolean;
  public
    constructor Create; overload;

    procedure FillRange(AStart, AEnd: Byte; State: Boolean = True);
    procedure Add(AByte: Byte; State: Boolean = True);
    procedure MergeWith(Other: TSimpatRangeBytes);
    procedure Invert;
    procedure MatchAll;

    function Contains(AByte: Byte): Boolean;
    // Is only a cache; if True then all FBytes = True but if False then this might also be true.
    property MatchesAllFast: Boolean read FMatchesAll;
    // True if matches anything - any byte, EOF or EOLN.
    function MatchesAny: Boolean;
    // True if matches exactly single byte, not 0 or 2 or more. EOF/EOLN don't affect result.
    function HasSingleValue: Boolean;
    function FirstValue: SmallInt;    // -1 if FBytes is empty (matches no bytes).

    property IsInverted: Boolean read FIsInverted write FIsInverted default False;
    property MatchesEOLN: Boolean read FMatchesEOLN write FMatchesEOLN default False;
    property MatchesEOF: Boolean read FMatchesEOF write FMatchesEOF default False;
  end;

  TSimpatPattern = class
  protected
    FContext: TSimpatContext;                    
    FAsString: SimpatString;
    FPieces: TObjectList;   // of TLinearSimpat

    procedure Parse(Pattern: SimpatString);
  public
    class function Match(const Pattern: SimpatString; Input: TStream; const EOLN: SimpatString = SimpatDefaultEOLN): Boolean; overload;
    class function Match(const Pattern: SimpatString; const Input: SimpatString; const EOLN: SimpatString = SimpatDefaultEOLN): Boolean; overload;

    // Pattern = 'abc|NL*||[^\1]|'
    constructor Create(const Pattern: SimpatString);
    destructor Destroy; override;

    function Debug: SimpatString;
    property AsString: SimpatString read FAsString;
    property Context: TSimpatContext read FContext write FContext;
    function MatchAgainst(Input: TStream): Boolean;
  end;

  TLinearSimpat = class
  protected
    FContext: TSimpatContext;
    FParsed: TObjectList;       // of TSimpatItem
    FCharClasses: TObjectHash;  // of TSimpatRangeBytes

    class function Cached(const Pattern: SimpatString): TObjectList;  // or nil.
    class procedure Cache(const Pattern: SimpatString; Parsed: TObjectList);
    // Normalizing here is only meant for avoiding caching identical patterns
    // differently only because they contained extra leading space or something else.
    class function NormalizeForCache(const Pattern: SimpatString): SimpatString;

    procedure Parse(const Pattern: SimpatString);
    procedure MergeParsedStrings;
  public
    constructor Create(const Context: TSimpatContext; const Pattern: SimpatString);
    destructor Destroy; override;

    // Owned. Name is converted to upper case.
    procedure AddCharClass(Name: SimpatString; Bytes: TSimpatRangeBytes);
    procedure AddDefaultCharClasses;
    function MatchAgainst(Input: TStream; ContextSync: TSimpatPattern = nil): Boolean;
    function Debug: SimpatString;
  end;

  TSimpatItem = class
  protected
    // Input = Context.Input;
    function DoMatch(const Context: TSimpatContext; Input: TStream): Boolean; virtual; abstract;
  public
    function MatchAgainst(const Context: TSimpatContext): Boolean;
    function EndsRepeat(const Context: TSimpatContext; RepeatCount: Integer): Boolean; virtual;
  end;

    TSimpatRepeat = class (TSimpatItem)
    protected
      function DoMatch(const Context: TSimpatContext; Input: TStream): Boolean; override;
    public
      function IsRepeated(RepeatCount: Integer): Boolean; virtual;
      function IsRepeatOptional(RepeatCount: Integer): Boolean; virtual; abstract;
    end;

      TSimpatRepeatAny = class (TSimpatRepeat)
      public
        function IsRepeatOptional(RepeatCount: Integer): Boolean; override;
      end;

      TSimpatRepeatOneOrMore = class (TSimpatRepeat)
      public
        function IsRepeatOptional(RepeatCount: Integer): Boolean; override;
      end;

      TSimpatRepeatOneOrNone = class (TSimpatRepeat)
      public
        function IsRepeated(RepeatCount: Integer): Boolean; override;
        function IsRepeatOptional(RepeatCount: Integer): Boolean; override;
      end;

    TSimpatStr = class (TSimpatItem)
    protected
      function DoMatch(const Context: TSimpatContext; Input: TStream): Boolean; override;
    public
      Str: SimpatString;
      constructor Create(const Str: SimpatString);
    end;

    TSimpatRange = class (TSimpatItem)
    protected
      FBytes: TSimpatRangeBytes;
      function DoMatch(const Context: TSimpatContext; Input: TStream): Boolean; override;
    public
      constructor Create(Bytes: TSimpatRangeBytes);
      destructor Destroy; override;
      function EndsRepeat(const Context: TSimpatContext; RepeatCount: Integer): Boolean; override;
    end;

  TSimpat = TSimpatPattern;

{ Exceptions }
type
  ESimpat = class (Exception)
  end;

    ESimpatHasEmptyChoice = class (ESimpat)
      constructor Create(Pattern: SimpatString);
    end;

    ESimpatBadCharClass = class (ESimpat)
      Simpat: TLinearSimpat;
      constructor Create(Simpat: TLinearSimpat; CharClass: SimpatString);
    end;

    ESimpatEmptyCharClass = class (ESimpat)
      Simpat: TLinearSimpat;
      constructor Create(Simpat: TLinearSimpat; CharClass: SimpatString);
    end;

implementation

uses Variants;

var
  LinearCache: TObjectHash;   // of TObjectList of TLinearSimpat

function CompareInput(Input: TStream; const Str: AnsiString): Boolean;
var
  Buf: AnsiString;
  Read: Integer;
begin
  if Input.Position >= Input.Size then
    Result := False
  else
  begin
    SetLength(Buf, Length(Str));
    Read := Input.Read(Buf[1], Length(Buf));
    Result := (Read = Length(Buf)) and (Str = Buf);
    if not Result then
      Input.Seek(-Read, soFromCurrent);
  end;
end;

{ Pattern items }

function TSimpatItem.MatchAgainst(const Context: TSimpatContext): Boolean;
var
  Pos: Int64;
begin
  Pos := Context.Input.Position;
  try
    Result := DoMatch(Context, Context.Input);
    if not Result then
      Context.Input.Position := Pos;
  except
    Context.Input.Position := Pos;
    raise;
  end;
end;

function TSimpatItem.EndsRepeat(const Context: TSimpatContext; RepeatCount: Integer): Boolean;
begin
  Result := False;
end;

function TSimpatRepeat.DoMatch(const Context: TSimpatContext; Input: TStream): Boolean;
begin
  Result := False;
end;

function TSimpatRepeat.IsRepeated(RepeatCount: Integer): Boolean;
begin
  Result := True;
end;

function TSimpatRepeatAny.IsRepeatOptional(RepeatCount: Integer): Boolean;
begin
  Result := True;
end;

function TSimpatRepeatOneOrMore.IsRepeatOptional(RepeatCount: Integer): Boolean;
begin
  Result := RepeatCount >= 1;
end;

function TSimpatRepeatOneOrNone.IsRepeated(RepeatCount: Integer): Boolean;
begin
  Result := RepeatCount = 0;
end;

function TSimpatRepeatOneOrNone.IsRepeatOptional(RepeatCount: Integer): Boolean;
begin
  Result := True;
end;

constructor TSimpatStr.Create(const Str: SimpatString);
begin
  Self.Str := Str;
end;

function TSimpatStr.DoMatch(const Context: TSimpatContext; Input: TStream): Boolean;
begin
  Result := CompareInput(Input, Str);
end;

constructor TSimpatRange.Create(Bytes: TSimpatRangeBytes);
begin
  FBytes := Bytes;
end;

destructor TSimpatRange.Destroy;
begin
  FBytes.Free;
  inherited;
end;

function TSimpatRange.DoMatch(const Context: TSimpatContext; Input: TStream): Boolean;
var
  AtEOF: Boolean;
  Ch: Byte;
begin
  AtEOF := Input.Position >= Input.Size;
  Result := FBytes.MatchesEOF and AtEOF;

  if not Result and not AtEOF then
  begin
    if not Result then
      Result := FBytes.MatchesEOLN and CompareInput(Input, Context.EOLN);

    if not Result then
      if FBytes.MatchesAllFast then
        Result := Input.Seek(1, soFromCurrent) > 0
      else if Input.Read(Ch, 1) = 1 then
        Result := FBytes.Contains(Ch);

    // Not inverting MatchesEOF - it has special meaning so if inverted [^bar]* will run forever.
    Result := FBytes.IsInverted xor Result;
  end;
end;

function TSimpatRange.EndsRepeat(const Context: TSimpatContext; RepeatCount: Integer): Boolean;
begin
  Result := FBytes.MatchesEOF and (Context.Input.Position >= Context.Input.Size);
end;

{ TSimpatPattern }

class function TSimpatPattern.Match(const Pattern, Input, EOLN: SimpatString): Boolean;
var
  S: TStringStream;
begin
  S := TStringStream.Create(Input);
  try
    Result := Match(Pattern, S, EOLN);
  finally
    S.Free;
  end;
end;

class function TSimpatPattern.Match(const Pattern: SimpatString; Input: TStream; const EOLN: SimpatString): Boolean;
var
  Matcher: TSimpatPattern;
  Context: TSimpatContext;
begin
  Matcher := TSimpatPattern.Create(Pattern);
  try
    Context := Matcher.Context;
    Context.EOLN := EOLN;
    Matcher.Context := Context;
    Result := Matcher.MatchAgainst(Input);
  finally
    Matcher.Free;
  end;
end;

constructor TSimpatPattern.Create(const Pattern: SimpatString);
begin
  FillChar(FContext, SizeOf(FContext), 0);
  FContext.EOLN := SimpatDefaultEOLN;
  FContext.Pattern := Self;

  FPieces := TObjectList.Create(True);
  Parse(Pattern);
end;

destructor TSimpatPattern.Destroy;
begin
  FPieces.Free;
  inherited;
end;

procedure TSimpatPattern.Parse(Pattern: SimpatString);
var
  I, PrevPos: Integer;

  function AddPattern(Piece: SimpatString): Boolean;
  begin
    Piece := SysUtils.Trim(Piece);
    Result := Piece <> '';

    if Result then
      FPieces.Add( TLinearSimpat.Create(FContext, Piece) )
    else
      FPieces.Add(nil);
  end;

begin
  I := 1;
  PrevPos := 1;
  FAsString := Pattern;

  while I <= Length(Pattern) do
  begin
    if Pattern[I] = '|' then
      if (I < Length(Pattern)) and (Pattern[I + 1] = '|') then
        Delete(Pattern, I, 1)
      else if not AddPattern( Copy(Pattern, PrevPos, I - PrevPos) ) then
        raise ESimpatHasEmptyChoice.Create(Pattern)
      else
        PrevPos := I + 1;
    Inc(I);
  end;

  if PrevPos <= I then
    AddPattern( Copy(Pattern, PrevPos, I - PrevPos) );
end;

function TSimpatPattern.MatchAgainst(Input: TStream): Boolean;
var
  I: Integer;
  Pos: Int64;
begin
  Result := True;
  Pos := Input.Position;

  for I := 0 to FPieces.Count - 1 do
    if (FPieces[I] = nil) or (FPieces[I] as TLinearSimpat).MatchAgainst(Input, Self) then
      Exit
    else
      Input.Position := Pos;

  Result := FPieces.Count = 0;
end;

function TSimpatPattern.Debug: SimpatString;
const
  Delim = ' || ';
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FPieces.Count - 1 do
    Result := Delim + (FPieces[I] as TLinearSimpat).Debug;
  Result := Copy(Result, Length(Delim) + 1, MaxInt);
end;

{ TSimpatRangeBytes }

constructor TSimpatRangeBytes.Create;
begin
  FillRange(0, High(Byte), False);
  FIsInverted := False;
  FMatchesEOLN := False;
  FMatchesEOF := False;
  FMatchesAll := False;
end;

procedure TSimpatRangeBytes.FillRange(AStart, AEnd: Byte; State: Boolean);
begin
  if AEnd > AStart then
  begin
    FillChar(FBytes[AStart], AEnd - AStart + 1, State);
    if not State then FMatchesAll := False;
  end;
end;

procedure TSimpatRangeBytes.Add(AByte: Byte; State: Boolean);
begin
  FBytes[AByte] := State;                
  if not State then FMatchesAll := False;
end;

procedure TSimpatRangeBytes.Invert;
begin
  // Not using FBytes inversion since - it won't have the desired effect on EOLN/EOF - suppose
  // we have [^NL] - inverting FBytes will match any byte even if it's CR and has LF following.
  FIsInverted := not FIsInverted;
end;

procedure TSimpatRangeBytes.MatchAll;
begin
  FillRange(0, High(Byte));
  FMatchesAll := True;
end;

procedure TSimpatRangeBytes.MergeWith(Other: TSimpatRangeBytes);
var
  I: Integer;
begin
  FMatchesEOLN := FMatchesEOLN or Other.MatchesEOLN;
  FMatchesEOF := FMatchesEOF or Other.MatchesEOF;
  FMatchesAll := FMatchesAll or Other.FMatchesAll;

  for I := 0 to Length(FBytes) - 1 do
    FBytes[I] := FBytes[I] or Other.FBytes[I];
end;

function TSimpatRangeBytes.Contains(AByte: Byte): Boolean;
begin
  Result := FBytes[AByte];
end;

function TSimpatRangeBytes.MatchesAny: Boolean;
var
  I: Integer;
begin
  Result := True;

  if not MatchesEOF and not MatchesEOLN and not FMatchesAll then
  begin
    for I := 0 to Length(FBytes) - 1 do
      if FBytes[I] then
        Exit;

    Result := False;
  end;
end;

function TSimpatRangeBytes.HasSingleValue: Boolean;
var
  I: Integer;
  OneMet: Boolean;
begin
  Result := False;
  OneMet := False;

  if not MatchesEOF and not MatchesEOLN and not FMatchesAll then
    for I := 0 to Length(FBytes) - 1 do
      if FBytes[I] then
        if OneMet then
          Exit
        else
          OneMet := True;

  Result := OneMet;
end;

function TSimpatRangeBytes.FirstValue: SmallInt;
begin
  for Result := 0 to Length(FBytes) - 1 do
    if FBytes[Result] then
      Exit;
  Result := -1;
end;

{ TLinearSimpat }

class procedure TLinearSimpat.Cache(const Pattern: SimpatString; Parsed: TObjectList);
begin
  if LinearCache = nil then
  begin
    LinearCache := TObjectHash.Create(True);
    LinearCache.CaseSensitive := True;
    LinearCache.Duplicates := dupReplace;
    LinearCache.Sorted := True;
  end;

  LinearCache.AddObject(NormalizeForCache(Pattern), Parsed);
end;

class function TLinearSimpat.Cached(const Pattern: SimpatString): TObjectList;
begin
  if LinearCache = nil then
    Result := nil
  else
    Result := TObjectList( LinearCache[NormalizeForCache(Pattern)] );
end;

class function TLinearSimpat.NormalizeForCache(const Pattern: SimpatString): SimpatString;
begin
  Result := SysUtils.Trim(Pattern);   // ANSI.
end;

constructor TLinearSimpat.Create(const Context: TSimpatContext; const Pattern: SimpatString);
begin
  FContext := Context;
  FContext.Linear := Self;

  FCharClasses := TObjectHash.Create(True);
  FCharClasses.CaseSensitive := True;
  FCharClasses.Duplicates := dupError;
  FCharClasses.Sorted := True;

  AddDefaultCharClasses;

  FParsed := Cached(Pattern);
  if FParsed = nil then
  begin
    FParsed := TObjectList.Create(True);
    Parse(Pattern);
    Cache(Pattern, FParsed);
  end;
end;

destructor TLinearSimpat.Destroy;
begin
  FCharClasses.Free;
  inherited;
end;

procedure TLinearSimpat.AddDefaultCharClasses;
var
  Bytes: TSimpatRangeBytes;
begin
  Bytes := TSimpatRangeBytes.Create;
  Bytes.MatchAll;
  AddCharClass('ANY', Bytes);

  Bytes := TSimpatRangeBytes.Create;
  Bytes.Add(9);
  Bytes.Add(32);
  AddCharClass('SP', Bytes);

  Bytes := TSimpatRangeBytes.Create;
  Bytes.Add(13);
  AddCharClass('CR', Bytes);

  Bytes := TSimpatRangeBytes.Create;
  Bytes.Add(10);
  AddCharClass('LF', Bytes);

  Bytes := TSimpatRangeBytes.Create;
  Bytes.FillRange(0, 31);
  AddCharClass('CTL', Bytes);

  Bytes := TSimpatRangeBytes.Create;
  Bytes.FillRange(Byte('0'), Byte('9'));
  AddCharClass('DIG', Bytes);

  Bytes := TSimpatRangeBytes.Create;
  Bytes.FillRange(Byte('a'), Byte('z'));
  Bytes.FillRange(Byte('A'), Byte('Z'));
  AddCharClass('LAT', Bytes);

  Bytes := TSimpatRangeBytes.Create;
  Bytes.FillRange(Byte('0'), Byte('9'));
  Bytes.FillRange(Byte('a'), Byte('f'));
  Bytes.FillRange(Byte('A'), Byte('F'));
  AddCharClass('HEX', Bytes);

  Bytes := TSimpatRangeBytes.Create;
  Bytes.Add(Byte('_'));
  Bytes.FillRange(Byte('0'), Byte('9'));
  Bytes.FillRange(Byte('a'), Byte('z'));
  Bytes.FillRange(Byte('A'), Byte('Z'));
  AddCharClass('ID', Bytes);
end;

procedure TLinearSimpat.AddCharClass(Name: SimpatString; Bytes: TSimpatRangeBytes);
var
  I: Integer;
begin
  Name := SysUtils.UpperCase(Name);

  for I := 1 to Length(Name) do
    if not (Name[I] in ['A'..'Z', '0'..'9']) then
      raise ESimpatBadCharClass.Create(Self, Name);

  if not Bytes.MatchesAny then
    raise ESimpatEmptyCharClass.Create(Self, Name);

  FCharClasses.AddObject(Name, Bytes);
end;

procedure TLinearSimpat.Parse(const Pattern: SimpatString);
var
  I: Integer;
  ThisIsItem: Boolean;

  procedure AddItem(Item: TSimpatItem);
  begin
    if Item is TSimpatRepeat then
      FParsed.Insert(FParsed.Count - 1, Item)
    else
      FParsed.Add(Item);
    ThisIsItem := True;
  end;

  function HexCharCode(Delta: Integer): Integer;
  var
    Num: SimpatString;
  begin
    Num := Copy(Pattern, I + Delta, 2);

    if (Length(Num) = 2) and (Num[1] in ['0'..'9', 'A'..'F']) and (Num[2] in ['0'..'9', 'A'..'F']) then
    begin
      Result := StrToInt('$' + Num);
      Inc(I, Delta);
    end
    else
      Result := -1;
  end;

  function DecCharCode(Delta: Integer): Integer;
  var
    Len: Integer;
    Num: SimpatString;
  begin
    Num := '';

    for Len := 0 to 2 do
      if (I + Delta + Len > Length(Pattern)) or not (Char(Pattern[I + Delta + Len]) in ['0'..'9']) then
        Break
      else
        Num := Num + Pattern[I + Delta + Len];

    if Num = '' then
      Result := -1
    else
    begin
      Result := StrToInt(Num);
      Inc(I, Delta + Len);
    end;
  end;

  function GetCharClassRange: TSimpatRangeBytes;
  var
    Pos, ClassI: Integer;
    Tail: SimpatString;
  begin
    Result := TSimpatRangeBytes.Create;
    try
      Tail := '';

      for Pos := I to Length(Pattern) + 1 do
        if (Pos > Length(Pattern)) or not (Pattern[Pos] in ['A'..'Z', '0'..'9']) then
        begin
          ClassI := FCharClasses.IndexOf(Tail);

          if ClassI <> -1 then
          begin
            Result.MergeWith( FCharClasses.Objects[ClassI] as TSimpatRangeBytes );
            if (Pos <= Length(Pattern)) and (Pattern[Pos] = '_') then
              Tail := '';
          end
          else if Tail = 'NL' then
          begin
            Result.MatchesEOLN := True;
            Result.MatchesEOF := True;
          end
          else if Tail = 'EOLN' then
            Result.MatchesEOLN := True
          else if Tail = 'EOF' then
            Result.MatchesEOF := True
          else
          begin
            FreeAndNil(Result);
            Exit;
          end;

          if Tail <> '' then
          begin
            I := Pos;
            Break;
          end;
        end
        else
          Tail := Tail + Pattern[Pos];
    except
      Result.Free;
      raise;
    end;
  end;

  function CharClass: Boolean;
  var
    Range: TSimpatRangeBytes;
  begin
    Range := GetCharClassRange;
    Result := Range <> nil;

    if Result then
      if Range.HasSingleValue then
        AddItem(TSimpatStr.Create( Char(Range.FirstValue) ))
      else if Range.MatchesAny then
        AddItem(TSimpatRange.Create(Range))
      else
        raise ESimpatEmptyCharClass.Create(Self, Pattern);
  end;

  function Range: Boolean;
  var
    RangeStart, RangeInnerStart, CharCode, StartChar: Integer;
    IsInverted, IsSubrange: Boolean;
    Range: TSimpatRangeBytes;
  begin
    RangeStart := I;
    Inc(I);

    IsInverted := Pattern[I] = '^';
    if IsInverted then
      Inc(I);

    RangeInnerStart := I;
    Range := GetCharClassRange;
    if Range = nil then
      Range := TSimpatRangeBytes.Create;

    IsSubrange := False;
    StartChar := 0;

    while (I < Length(Pattern)) and (Pattern[I] <> ']') do
    begin
      CharCode := Byte( Pattern[I] );

      if Pattern[I] = '\' then
        if Pattern[I + 1] = ']' then
        begin
          CharCode := Byte(']');
          Inc(I);
        end
        else if Char(Pattern[I + 1]) in ['x', '0'..'9'] then
        begin
          if Pattern[I + 1] = 'x' then
            CharCode := HexCharCode(+2)
          else
            CharCode := DecCharCode(+1);
          if CharCode = -1 then
            CharCode := Byte( Pattern[I] )
          else
            Dec(I);
        end;

      if IsSubrange then
      begin
        Range.FillRange(StartChar, CharCode);
        IsSubrange := False;
      end
      else
      begin
        Range.Add(CharCode);

        if Pattern[I + 1] = '-' then
        begin
          IsSubrange := True;
          StartChar := CharCode;
          Inc(I);
        end;
      end;

      Inc(I);
    end;

    Result := (I > RangeInnerStart) and (Pattern[I] = ']');

    if Result then
    begin
      if IsSubrange then
        Range.Add( Byte('-') );
      if IsInverted then
        Range.Invert;
      AddItem(TSimpatRange.Create(Range));
    end
    else
    begin
      I := RangeStart;
      Range.Free;
    end;
  end;

var
  PrevWasItem: Boolean;
  Next: Char;
  CharCode: Integer;
begin
  FParsed.Clear;
  PrevWasItem := False;
  I := 1;
             
  while I <= Length(Pattern) do
  begin
    if I < Length(Pattern) then
      Next := Pattern[I + 1]
    else
      Next := #0;

    ThisIsItem := False;
    CharCode := -1;

    case Pattern[I] of
    '\':
      case Next of
      'x':      CharCode := HexCharCode(+2);
      '0'..'9': CharCode := DecCharCode(+1);
      end;
    '*':        if PrevWasItem then AddItem(TSimpatRepeatAny.Create);
    '+':        if PrevWasItem then AddItem(TSimpatRepeatOneOrMore.Create);
    '?':        if PrevWasItem then AddItem(TSimpatRepeatOneOrNone.Create);
    'A'..'Z':   if ((I = 1) or (Pattern[I - 1] <= ' ')) and CharClass then Dec(I);
    '[':        if (Next > ' ') then Range;
    end;

    if CharCode in [0..255] then
      AddItem(TSimpatStr.Create( Char(CharCode) ))
    else
    begin
      if not ThisIsItem and not (Pattern[I] in [#0..' ']) then
        AddItem(TSimpatStr.Create( Char(Pattern[I]) ));
      Inc(I);
    end;

    PrevWasItem := ThisIsItem and not (Pattern[I - 1] in ['*', '+', '?']);
  end;

  MergeParsedStrings;
end;

procedure TLinearSimpat.MergeParsedStrings;
var
  I: Integer;
begin
  I := 1;
  while I < FParsed.Count do
    if (FParsed[I - 1] is TSimpatStr) and (FParsed[I] is TSimpatStr) then
    begin
      with TSimpatStr(FParsed[I - 1]) do
        Str := Str + TSimpatStr(FParsed[I]).Str;
      FParsed.Delete(I);
    end
    else
      Inc(I);
end;

function TLinearSimpat.MatchAgainst(Input: TStream; ContextSync: TSimpatPattern = nil): Boolean;
var
  I, Repeats: Integer;
  Item: TSimpatItem;
begin
  Result := False;
  I := 0;
  FContext.Input := Input;

  if ContextSync <> nil then
    FContext.EOLN := ContextSync.Context.EOLN;

  while I < FParsed.Count do
  begin
    Item := FParsed[I] as TSimpatItem;

    if Item is TSimpatRepeat then
      with TSimpatRepeat(Item) do
      begin
        Repeats := 0;

        while IsRepeated(Repeats) do
          if (FParsed[I + 1] as TSimpatItem).MatchAgainst(FContext) then
            if not (FParsed[I + 1] as TSimpatItem).EndsRepeat(FContext, Repeats) then
              Inc(Repeats)
            else if IsRepeatOptional(Repeats + 1) then
              Break   // match
            else
              Exit    // mismatch
          else if IsRepeatOptional(Repeats) then
            Break     // match
          else
            Exit;     // mismatch

        Inc(I);
      end
    else if not Item.MatchAgainst(FContext) then
      Exit;           // mismatch

    Inc(I);
  end;

  Result := True;
end;

function TLinearSimpat.Debug: SimpatString;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to FParsed.Count - 1 do
    if FParsed[I] is TSimpatStr then
      Result := Result + ' "' + TSimpatStr(FParsed[I]).Str + '"'
    else
      Result := Result + ' ' + Copy(FParsed[I].ClassName, Length('TSimpat') + 1, MaxInt);

  Result := Copy(Result, 2, MaxInt);
end;

{ Exceptions }

constructor ESimpatHasEmptyChoice.Create(Pattern: SimpatString);
begin
  CreateFmt('Simple Pattern "%s" contains empty choice(s) - only allowed when in last position.', [Pattern]);
end;

constructor ESimpatBadCharClass.Create(Simpat: TLinearSimpat; CharClass: SimpatString);
begin
  Self.Simpat := Simpat;
  CreateFmt('Simple Pattern''s character class names must consist of A-Z and 0-9 symbols - ''%s'' name given.', [CharClass]);
end;

constructor ESimpatEmptyCharClass.Create(Simpat: TLinearSimpat; CharClass: SimpatString);
begin
  Self.Simpat := Simpat;
  CreateFmt('Attempted to create character class ''%s'' that matches nothing.', [CharClass]);
end;

initialization

finalization
  LinearCache.Free;
end.
