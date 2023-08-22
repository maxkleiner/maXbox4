unit StringsW;

{ WideString versions of classes from standard Classes unit with some handy features added. }

{
  Alteration methods & their effect:
  * Clear         - lnDeleted on all + Changed
  * Delete        - lnDeleted + Changed
  * Exchange      - Changed
  * Add           - lnAdded + Changed
  * SetKey/Val    - Changed
  * SetObject     - lnDeleted + lnAdded + Changed
  * Extract       - lnExtracted + lnDeleted + Changed
  * Begin/EndUpd  - Changed
  * Sort          - Changed
}

interface

uses FileStreamW, Classes, Windows, SysUtils;

type
  TDuplicatesEx = (dupIgnore, dupAccept, dupReplace, dupError);
  TListAssignOp = Classes.TListAssignOp;
  TListSortCompare = Classes.TListSortCompare;
  TListNotification = Classes.TListNotification;

  TStringListW = class;

  TStringsW = class (TPersistent)
  protected
    FDefined: TStringsDefined;
    FDelimiter: WideChar;
    FQuoteChar: WideChar;
    FNameValueSeparator: WideChar;
    FUpdateCount: Integer;

    FLineBreak: WideString;

    function GetCommaText: WideString;
    function GetDelimitedText: WideString;
    function GetName(Index: Integer): WideString;
    function GetValue(const Name: WideString): WideString;
    procedure ReadData(Reader: TReader);
    procedure SetCommaText(const Value: WideString);
    procedure SetDelimitedText(const Value: WideString);
    procedure SetValue(const Name, Value: WideString);
    procedure WriteData(Writer: TWriter);
    function GetDelimiter: WideChar;
    procedure SetDelimiter(const Value: WideChar);
    function GetQuoteChar: WideChar;
    procedure SetQuoteChar(const Value: WideChar);
    function GetNameValueSeparator: WideChar;
    procedure SetNameValueSeparator(const Value: WideChar);
    function GetValueFromIndex(Index: Integer): WideString;
    procedure SetValueFromIndex(Index: Integer; const Value: WideString);

    procedure DefineProperties(Filer: TFiler); override;
    procedure Error(const Msg: WideString; Data: Integer);
    // todo: escape char support for ExtractName.
    function ExtractName(const S: WideString): WideString; virtual;
    function Get(Index: Integer): WideString; virtual; abstract;
    function GetCapacity: Integer; virtual;
    function GetCount: Integer; virtual; abstract;
    function GetObject(Index: Integer): TObject; virtual;
    function GetTextStr: WideString; virtual;
    procedure Put(Index: Integer; const S: WideString); virtual;
    procedure PutObject(Index: Integer; AObject: TObject); virtual;
    procedure SetCapacity(NewCapacity: Integer); virtual;
    procedure SetTextStr(const Value: WideString; SkipEmptyLines: Boolean = False); virtual;
    procedure SetUpdateState(Updating: Boolean); virtual;
    property UpdateCount: Integer read FUpdateCount;
    function CompareStrings(const S1, S2: WideString): Integer; virtual;
    function GetTag(Index: Integer): DWord;
    procedure PutTag(Index: Integer; Value: DWord);
    procedure SetFromText(const Value: WideString);

    procedure Notify(Index: Integer; Action: TListNotification); virtual;
  public
    constructor Create; virtual;

    function Add(const S: WideString; Tag: DWord = 0): Integer; virtual;
    function AddObject(const S: WideString; AObject: TObject): Integer; virtual;
    procedure Append(const S: WideString);
    procedure AddStrings(Strings: TStringsW); overload; virtual;
    procedure AddStrings(Strings: TStrings); overload;
    procedure Assign(Source: TPersistent); overload; override;
    procedure BeginUpdate;
    procedure Clear; virtual; abstract;
    procedure Delete(Index: Integer); overload; virtual; abstract;
    procedure EndUpdate;
    function Equals(Strings: TStringsW): Boolean;
    procedure Exchange(Index1, Index2: Integer); virtual;
    function GetText: PWideChar; virtual;
    function IndexOf(const S: WideString): Integer; overload; virtual;
    function IndexOf(AObject: TObject): Integer; overload; virtual;
    function IndexOfName(const Name: WideString): Integer; virtual;
    function IndexOfValue(const Value: WideString): Integer; virtual;
    function IndexOfObject(AObject: TObject): Integer; virtual;
    procedure Insert(Index: Integer; const S: WideString; Tag: DWord = 0); virtual; abstract;
    procedure InsertObject(Index: Integer; const S: WideString; AObject: TObject); virtual;
    procedure LoadFromFile(const FileName: WideString); virtual;
    procedure LoadFromStream(Stream: TStream; SkipEmptyLines: Boolean = False); virtual;
    procedure Move(CurIndex, NewIndex: Integer); virtual;
    procedure SaveToFile(const FileName: WideString; WriteUtfSignature: Boolean = True);
    procedure SaveToStream(Stream: TStream); virtual;
    procedure SetText(Text: PWideChar; SkipEmptyLines: Boolean = False); virtual;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property CommaText: WideString read GetCommaText write SetCommaText;
    property Count: Integer read GetCount;
    property Delimiter: WideChar read GetDelimiter write SetDelimiter;
    property DelimitedText: WideString read GetDelimitedText write SetDelimitedText;
    property Names[Index: Integer]: WideString read GetName;
    property Objects[Index: Integer]: TObject read GetObject write PutObject;
    property Tags[Index: Integer]: DWord read GetTag write PutTag;
    property QuoteChar: WideChar read GetQuoteChar write SetQuoteChar;
    property Values[const Name: WideString]: WideString read GetValue write SetValue;
    property ValueFromIndex[Index: Integer]: WideString read GetValueFromIndex write SetValueFromIndex;
    property NameValueSeparator: WideChar read GetNameValueSeparator write SetNameValueSeparator;
    property Strings[Index: Integer]: WideString read Get write Put; default;
    property Text: WideString read GetTextStr write SetFromText;

    // affects Text(), defaults to LF (Linux) or CRLF (Windows):
    property LineBreak: WideString read FLineBreak write FLineBreak;
    procedure AppendTo(const Other: TStrings); overload;
    procedure AppendTo(const Other: TStringsW); overload;
    procedure CopyTo(const Other: TStrings); overload;
    procedure CopyTo(const Other: TStringsW); overload;
    function NameList: TStringListW; virtual;
    property AsString: WideString read GetTextStr;
    function Extract(Index: Integer): TObject; virtual;
    function IndexOfInstanceOf(AClass: TClass; CanInherit: Boolean = True; StartAt: Integer = 0): Integer;
    function IsEmpty: Boolean;
    function Delete(Str: WideString): Boolean; overload;
    function DeleteByName(Name: WideString): Boolean;
    function JoinNames(const Delim: WideString): WideString;
    function JoinValues(const Delim: WideString): WideString;
    function Join(const Delim: WideString): WideString;
  end;

  PStringItemW = ^TStringItemW;
  TStringItemW = record
    FString: WideString;
    FObject: TObject;
  end;

  PStringItemListW = ^TStringItemListW;
  TStringItemListW = array[0..MaxListSize] of TStringItemW;
  TStringListSortCompare = function(List: TStringListW; Index1, Index2: Integer): Integer of object;

  TStringListW = class (TStringsW)
  protected
    FList: PStringItemListW;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FDuplicates: TDuplicatesEx;
    FCaseSensitive: Boolean;
    FOnChange: TNotifyEvent;
    FOnChanging: TNotifyEvent;

    procedure ExchangeItems(Index1, Index2: Integer);
    procedure Grow;
    procedure QuickSort(L, R: Integer; SCompare: TStringListSortCompare);
    function Sorter(List: TStringListW; Index1, Index2: Integer): Integer;
    procedure SetSorted(Value: Boolean);
    procedure SetCaseSensitive(const Value: Boolean);
    procedure Changed; virtual;
    procedure Changing; virtual;
    function Get(Index: Integer): WideString; override;
    function GetCapacity: Integer; override;
    function GetCount: Integer; override;
    function GetObject(Index: Integer): TObject; override;
    procedure Put(Index: Integer; const S: WideString); override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
    procedure SetCapacity(NewCapacity: Integer); override;
    procedure SetUpdateState(Updating: Boolean); override;
    function CompareStrings(const S1, S2: WideString): Integer; override;
    procedure InsertItem(Index: Integer; const S: WideString; AObject: TObject); virtual;
  public
    destructor Destroy; override;
    function Add(const S: WideString; Tag: DWord = 0): Integer; override;
    function AddObject(const S: WideString; AObject: TObject): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Exchange(Index1, Index2: Integer); override;
    function Find(const S: WideString; var Index: Integer): Boolean; virtual;
    function IndexOf(const S: WideString): Integer; override;
    procedure Insert(Index: Integer; const S: WideString; Tag: DWord = 0); override;
    procedure InsertObject(Index: Integer; const S: WideString; AObject: TObject); override;
    procedure Sort; virtual;
    procedure CustomSort(Compare: TStringListSortCompare); virtual;
    property Duplicates: TDuplicatesEx read FDuplicates write FDuplicates;
    property Sorted: Boolean read FSorted write SetSorted;
    property CaseSensitive: Boolean read FCaseSensitive write SetCaseSensitive;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChanging: TNotifyEvent read FOnChanging write FOnChanging;
  end;

type
  { Ported WideString-version of THashedStringList from standard IniFiles unit. }

  PPHashItem = ^PHashItem;
  PHashItem = ^THashItem;
  THashItem = record
    Next: PHashItem;
    Key: WideString;
    Value: Integer;
  end;

  TStringHashW = class
  protected
    Buckets: array of PHashItem;

    function Find(const Key: WideString): PPHashItem;
    function HashOf(const Key: WideString): DWord; virtual;
  public
    constructor Create(Size: DWord = 256);
    destructor Destroy; override;
    procedure Add(const Key: WideString; Value: Integer);
    procedure Clear;
    procedure Remove(const Key: WideString);
    function Modify(const Key: WideString; Value: Integer): Boolean;
    function ValueOf(const Key: WideString): Integer;
  end;

  THashedStringListW = class (TStringListW)
  protected
    FValueHash: TStringHashW;
    FNameHash: TStringHashW;
    FValueHashValid: Boolean;
    FNameHashValid: Boolean;

    procedure Changed; override;
    procedure UpdateValueHash;
    procedure UpdateNameHash;
  public
    destructor Destroy; override;
    function IndexOf(const S: WideString): Integer; override;
    function IndexOfName(const Name: WideString): Integer; override;
  end;

  THashW = THashedStringListW;

type
  TObjectHash = class (THashW)
  protected
    FOwnsObjects: Boolean;

    procedure Notify(Index: Integer; Action: TListNotification); override;

    function GetObjectByStr(Str: WideString): TObject;
    procedure SetObjectByStr(Str: WideString; Value: TObject);
    function GetObjectByName(Name: WideString): TObject;
    procedure SetObjectByName(Name: WideString; Value: TObject);
  public
    constructor Create; overload; override;
    constructor Create(OwnsObjects: Boolean); reintroduce; overload;
    destructor Destroy; override;

    function Extract(Index: Integer): TObject; override;
    function Delete(Obj: TObject): Boolean; overload;

    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
    property ObjectByStr[Name: WideString]: TObject read GetObjectByStr write SetObjectByStr; default;
    property ObjectByName[Name: WideString]: TObject read GetObjectByName write SetObjectByName;
  end;

  TComponentHash = class (TObjectHash)
  protected
    FNexus: TComponent;  // = TComponentListNexus

    procedure Notify(Index: Integer; Action: TListNotification); override;
    procedure HandleFreeNotify(Sender: TObject; AComponent: TComponent);
  public
    destructor Destroy; override;
  end;

implementation

uses StringUtils, UtilsW;

const
  UTF8Signature: array[0..2] of Char = (#$EF, #$BB, #$BF);

  // From RtlConsts.pas:
  SDuplicateString = 'String list does not allow duplicates';
  SListIndexError = 'List index out of bounds (%d)';
  SSortedListError = 'Operation not allowed on sorted list';

{ TStringsW }

constructor TStringsW.Create;
begin
  FLineBreak := sLineBreak;
end;

function TStringsW.Add(const S: WideString; Tag: DWord = 0): Integer;
begin
  Result := AddObject(S, TObject(Tag));
end;

function TStringsW.AddObject(const S: WideString; AObject: TObject): Integer;
begin
  Result := GetCount;
  InsertObject(Result, S, AObject);
end;

procedure TStringsW.Append(const S: WideString);
begin
  Add(S);
end;

procedure TStringsW.AddStrings(Strings: TStringsW);
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Strings.Count - 1 do
      AddObject(Strings[I], Strings.Objects[I]);
  finally
    EndUpdate;
  end;
end;

procedure TStringsW.AddStrings(Strings: TStrings);
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Strings.Count - 1 do
      AddObject(Strings[I], Strings.Objects[I]);
  finally
    EndUpdate;
  end;
end;

procedure TStringsW.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source is TStringsW then
  begin
    BeginUpdate;
    try
      Clear;
      FDefined := TStringsW(Source).FDefined;
      FNameValueSeparator := TStringsW(Source).FNameValueSeparator;
      FQuoteChar := TStringsW(Source).FQuoteChar;
      FDelimiter := TStringsW(Source).FDelimiter;
      AddStrings(TStringsW(Source));
    finally
      EndUpdate;
    end;
    Exit;
  end
    else if Source is TStrings then
    begin
      NameValueSeparator := WideChar( TStrings(Source).NameValueSeparator );
      QuoteChar := WideChar( TStrings(Source).QuoteChar );
      Delimiter := WideChar( TStrings(Source).Delimiter );

      BeginUpdate;
      try
        Clear;

        with TStrings(Source) do
          for I := 0 to Count - 1 do
            Self.AddObject(Strings[I], Objects[I]);
      finally
        EndUpdate;
      end;
    end
    else
      inherited;
end;

procedure TStringsW.BeginUpdate;
begin
  if FUpdateCount = 0 then SetUpdateState(True);
  Inc(FUpdateCount);
end;

procedure TStringsW.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    if Filer.Ancestor <> NIL then
    begin
      Result := True;
      if Filer.Ancestor is TStringsW then
        Result := not Equals(TStringsW(Filer.Ancestor))
    end
    else Result := Count > 0;
  end;

begin
  Filer.DefineProperty('Strings', ReadData, WriteData, DoWrite);
end;

procedure TStringsW.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then SetUpdateState(False);
end;

function TStringsW.Equals(Strings: TStringsW): Boolean;
var
  I, Count: Integer;
begin
  Result := False;
  Count := GetCount;
  if Count <> Strings.GetCount then Exit;
  for I := 0 to Count - 1 do if Get(I) <> Strings.Get(I) then Exit;
  Result := True;
end;

procedure TStringsW.Error(const Msg: WideString; Data: Integer);

  function ReturnAddr: Pointer;
  asm
          MOV     EAX,[EBP+4]
  end;

begin
  raise EStringListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

procedure TStringsW.Exchange(Index1, Index2: Integer);
var
  TempObject: TObject;
  TempString: WideString;
begin
  BeginUpdate;
  try
    TempString := Strings[Index1];
    TempObject := Objects[Index1];
    Strings[Index1] := Strings[Index2];
    Objects[Index1] := Objects[Index2];
    Strings[Index2] := TempString;
    Objects[Index2] := TempObject;
  finally
    EndUpdate;
  end;
end;

function TStringsW.ExtractName(const S: WideString): WideString;
var
  P: Integer;
begin
  Result := S;
  P := PosW(NameValueSeparator, Result);
  if P <> 0 then
    SetLength(Result, P-1) else
    SetLength(Result, 0);
end;

function TStringsW.GetCapacity: Integer;
begin  // descendents may optionally override/replace this default implementation
  Result := Count;
end;

function TStringsW.GetCommaText: WideString;
var
  LOldDefined: TStringsDefined;
  LOldDelimiter: WideChar;
  LOldQuoteChar: WideChar;
begin
  LOldDefined := FDefined;
  LOldDelimiter := FDelimiter;
  LOldQuoteChar := FQuoteChar;
  Delimiter := ',';
  QuoteChar := '"';
  try
    Result := GetDelimitedText;
  finally
    FDelimiter := LOldDelimiter;
    FQuoteChar := LOldQuoteChar;
    FDefined := LOldDefined;
  end;
end;

function TStringsW.GetDelimitedText: WideString;
var
  S: WideString;
  P: PWideChar;
  I, Count: Integer;
begin
  Count := GetCount;
  if (Count = 1) and (Get(0) = '') then
    Result := WideString(QuoteChar) + QuoteChar
  else
  begin
    Result := '';
    for I := 0 to Count - 1 do
    begin
      S := Get(I);
      P := PWideChar(S);
      while not (String(P^)[1] in [#0..' ']) and (P^ <> QuoteChar) and (P^ <> Delimiter) do
        P := CharNextW(P);
      if (P^ <> #0) then S := QuotedStr(S, QuoteChar);
      Result := Result + S + Delimiter;
    end;
    System.Delete(Result, Length(Result), 1);
  end;
end;

function TStringsW.GetName(Index: Integer): WideString;
begin
  Result := ExtractName(Get(Index));
end;

function TStringsW.GetObject(Index: Integer): TObject;
begin
  Result := NIL;
end;

function TStringsW.GetText: PWideChar;
var
  S: WideString;
begin
  S := GetTextStr;
  Result := PWideChar(S);
end;

function TStringsW.GetTextStr: WideString;
var
  I, L, Size, Count: Integer;
  P: PWideChar;
  S, LB: WideString;
begin
  Count := GetCount;
  Size := 0;
  LB := FLineBreak;
  for I := 0 to Count - 1 do Inc(Size, Length(Get(I)) + Length(LB));
  SetLength(Result, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do
  begin
    S := Get(I);
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, L * 2);
      Inc(P, L);
    end;
    L := Length(LB);
    if L <> 0 then
    begin
      System.Move(Pointer(LB)^, P^, L * 2);
      Inc(P, L);
    end;
  end;
end;

function TStringsW.GetValue(const Name: WideString): WideString;
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if I >= 0 then
    Result := Copy(Get(I), Length(Name) + 2, MaxInt) else
    Result := '';
end;

function TStringsW.IndexOf(const S: WideString): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if CompareStrings(Get(Result), S) = 0 then Exit;
  Result := -1;
end;

function TStringsW.IndexOfName(const Name: WideString): Integer;
var
  P: Integer;
  S: WideString;
begin
  for Result := 0 to GetCount - 1 do
  begin
    S := Get(Result);
    P := PosW(NameValueSeparator, S);
    if (P <> 0) and (CompareStrings(Copy(S, 1, P - 1), Name) = 0) then Exit;
  end;
  Result := -1;
end;

function TStringsW.IndexOfValue(const Value: WideString): Integer;
var
  P: Integer;
  S: WideString;
begin
  for Result := 0 to GetCount - 1 do
  begin
    S := Get(Result);
    P := PosW(NameValueSeparator, S);
    if (P <> 0) and (CompareStrings(Copy(S, P + 1, Length(S)), Value) = 0) then Exit;
  end;
  Result := -1;
end;

function TStringsW.IndexOfObject(AObject: TObject): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if GetObject(Result) = AObject then Exit;
  Result := -1;
end;

procedure TStringsW.InsertObject(Index: Integer; const S: WideString;
  AObject: TObject);
begin
  Insert(Index, S);
  PutObject(Index, AObject);
end;

procedure TStringsW.LoadFromFile(const FileName: WideString);
var
  Stream: TStream;
  Sign: array[0..2] of Char;
begin
  Stream := TFileStreamW.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Stream.Read(Sign[0], 3);
    if Sign <> UTF8Signature then
      Stream.Position := 0;

    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TStringsW.LoadFromStream(Stream: TStream; SkipEmptyLines: Boolean = False);
var
  Size: Integer;
  S: String;
begin
  BeginUpdate;
  try
    Size := Stream.Size - Stream.Position;
    SetString(S, NIL, Size);
    Stream.Read(Pointer(S)^, Size);
    SetTextStr(UTF8Decode(S), SkipEmptyLines);
  finally
    EndUpdate;
  end;
end;

procedure TStringsW.Move(CurIndex, NewIndex: Integer);
var
  TempObject: TObject;
  TempString: WideString;
begin
  if CurIndex <> NewIndex then
  begin
    BeginUpdate;
    try
      TempString := Get(CurIndex);
      TempObject := GetObject(CurIndex);
      Delete(CurIndex);
      InsertObject(NewIndex, TempString, TempObject);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TStringsW.Put(Index: Integer; const S: WideString);
var
  TempObject: TObject;
begin
  TempObject := GetObject(Index);
  Delete(Index);
  InsertObject(Index, S, TempObject);
end;

procedure TStringsW.PutObject(Index: Integer; AObject: TObject);
begin
end;

procedure TStringsW.ReadData(Reader: TReader);
begin
  Reader.ReadListBegin;
  BeginUpdate;
  try
    Clear;
    while not Reader.EndOfList do Add(Reader.ReadString);
  finally
    EndUpdate;
  end;
  Reader.ReadListEnd;
end;

procedure TStringsW.SaveToFile(const FileName: WideString; WriteUtfSignature: Boolean = True);
var
  Stream: TStream;
begin
  Stream := TFileStreamW.Create(FileName, fmCreate);
  try
    if WriteUtfSignature then
      Stream.Write(UTF8Signature[0], Length(UTF8Signature));
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TStringsW.SaveToStream(Stream: TStream);
var
  S: String;
begin
  S := UTF8Encode(GetTextStr);
  Stream.WriteBuffer(Pointer(S)^, Length(S));
end;

procedure TStringsW.SetCapacity(NewCapacity: Integer);
begin
  // do nothing - descendents may optionally implement this method
end;

procedure TStringsW.SetCommaText(const Value: WideString);
begin
  Delimiter := ',';
  QuoteChar := '"';
  SetDelimitedText(Value);
end;

procedure TStringsW.SetText(Text: PWideChar; SkipEmptyLines: Boolean = False);
begin
  SetTextStr(Text, SkipEmptyLines);
end;

procedure TStringsW.SetTextStr(const Value: WideString; SkipEmptyLines: Boolean = False);
var
  Current, Started: Cardinal;

  procedure Flush;
  begin
    if not SkipEmptyLines or (Current > Started) then
      Add(Copy(Value, Started, Current - Started));
    Started := Current + 1
  end;
begin
  BeginUpdate;
  try
    Clear;
    Started := 1;

    for Current := 1 to Length(Value) do
      if (Value[Current] = #10) and (Current > 1) and (Started = Current) and (Value[Current - 1] = #13) then
        // CR+LF line end.
        Inc(Started)
        else if (Value[Current] = #10) or (Value[Current] = #13) then
          Flush;

    Current := Length(Value) + 1;
    if Current > Started then
      Flush;
  finally
    EndUpdate;
  end;
end;

procedure TStringsW.SetUpdateState(Updating: Boolean);
begin
end;

procedure TStringsW.SetValue(const Name, Value: WideString);
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if Value <> '' then
  begin
    if I < 0 then I := Add('');
    Put(I, Name + NameValueSeparator + Value);
  end else
  begin
    if I >= 0 then Delete(I);
  end;
end;

procedure TStringsW.WriteData(Writer: TWriter);
var
  I: Integer;
begin
  Writer.WriteListBegin;
  for I := 0 to Count - 1 do Writer.WriteString(Get(I));
  Writer.WriteListEnd;
end;

procedure TStringsW.SetDelimitedText(const Value: WideString);
var
  P, P1: PWideChar;
  S: WideString;
begin
  BeginUpdate;
  try
    Clear;
    P := PWideChar(Value);
    while String(P^)[1] in [#1..' '] do
      P := CharNextW(P);
    while P^ <> #0 do
    begin
      if P^ = QuoteChar then
        S := ExtractQuotedStr(P, QuoteChar)
      else
      begin
        P1 := P;
        while (P^ > ' ') and (P^ <> Delimiter) do
          P := CharNextW(P);
        S := Copy(P1, 1, P - P1);
      end;
      Add(S);
      while String(P^)[1] in [#1..' '] do
        P := CharNextW(P);
      if P^ = Delimiter then
      begin
        P1 := P;
        if CharNextW(P1)^ = #0 then
          Add('');
        repeat
          P := CharNextW(P);
        until not (String(P^)[1] in [#1..' ']);
      end;
    end;
  finally
    EndUpdate;
  end;
end;

function TStringsW.GetDelimiter: WideChar;
begin
  if not (sdDelimiter in FDefined) then
    Delimiter := ',';
  Result := FDelimiter;
end;

function TStringsW.GetQuoteChar: WideChar;
begin
  if not (sdQuoteChar in FDefined) then
    QuoteChar := '"';
  Result := FQuoteChar;
end;

procedure TStringsW.SetDelimiter(const Value: WideChar);
begin
  if (FDelimiter <> Value) or not (sdDelimiter in FDefined) then
  begin
    Include(FDefined, sdDelimiter);
    FDelimiter := Value;
  end
end;

procedure TStringsW.SetQuoteChar(const Value: WideChar);
begin
  if (FQuoteChar <> Value) or not (sdQuoteChar in FDefined) then
  begin
    Include(FDefined, sdQuoteChar);
    FQuoteChar := Value;
  end
end;

function TStringsW.CompareStrings(const S1, S2: WideString): Integer;
begin
  Result := CompareText(S1, S2);
end;

function TStringsW.GetNameValueSeparator: WideChar;
begin
  if not (sdNameValueSeparator in FDefined) then
    NameValueSeparator := '=';
  Result := FNameValueSeparator;
end;

procedure TStringsW.SetNameValueSeparator(const Value: WideChar);
begin
  if (FNameValueSeparator <> Value) or not (sdNameValueSeparator in FDefined) then
  begin
    Include(FDefined, sdNameValueSeparator);
    FNameValueSeparator := Value;
  end
end;

function TStringsW.GetValueFromIndex(Index: Integer): WideString;
begin
  if Index < 0 then
    Result := ''
    else
    begin
      Result := Get(Index);

      if Result <> '' then
        if Result[1] = NameValueSeparator then
          Result := Copy(Result, 2, MaxInt)
          else
            Result := Copy(Result, Length( ExtractName(Result) ) + 2, MaxInt);
    end;
end;

procedure TStringsW.SetValueFromIndex(Index: Integer; const Value: WideString);
begin
  if Value <> '' then
  begin
    if Index < 0 then Index := Add('');
    Put(Index, Names[Index] + NameValueSeparator + Value);
  end
  else
    if Index >= 0 then Delete(Index);
end;

function TStringsW.GetTag(Index: Integer): DWord;
begin
  Result := DWord( Objects[Index] );
end;

procedure TStringsW.PutTag(Index: Integer; Value: DWord);
begin
  Objects[Index] := TObject(Value);
end;

procedure TStringsW.AppendTo(const Other: TStrings);
var
  I: Integer;
begin
  Other.BeginUpdate;
  try
    for I := 0 to Count - 1 do
      Other.AddObject(Strings[I], Objects[I]);
  finally
    Other.EndUpdate;
  end;
end;

procedure TStringsW.AppendTo(const Other: TStringsW);
var
  I: Integer;
begin
  Other.BeginUpdate;
  try
    for I := 0 to Count - 1 do
      Other.AddObject(Strings[I], Objects[I]);
  finally
    Other.EndUpdate;
  end;
end;

procedure TStringsW.CopyTo(const Other: TStrings);
begin
  Other.Clear;
  AppendTo(Other);
end;

procedure TStringsW.CopyTo(const Other: TStringsW);
begin
  Other.Assign(Self);
end;

procedure TStringsW.SetFromText(const Value: WideString);
begin
  SetTextStr(Value, False);
end;

procedure TStringsW.Notify(Index: Integer; Action: TListNotification);
begin
end;

function TStringsW.Extract(Index: Integer): TObject;
begin           
  Result := Objects[Index];
  Delete(Index);
end;

function TStringsW.IndexOfInstanceOf(AClass: TClass; CanInherit: Boolean = True; StartAt: Integer = 0): Integer;
begin
  for Result := StartAt to Count - 1 do
    if (CanInherit and (Objects[Result].ClassType = AClass)) or
       (not CanInherit and Objects[Result].InheritsFrom(AClass)) then
      Exit;

  Result := -1;
end;

function TStringsW.IndexOf(AObject: TObject): Integer;
begin
  Result := IndexOfObject(AObject);
end;

function TStringsW.IsEmpty: Boolean;
begin
  Result := Count = 0;
end;

function TStringsW.Delete(Str: WideString): Boolean;
var
  I: Integer;
begin
  I := IndexOf(Str);
  Result := I <> -1;
  if Result then
    Delete(I);
end;

function TStringsW.DeleteByName(Name: WideString): Boolean;
var
  I: Integer;
begin
  I := IndexOfName(Name);
  Result := I <> -1;
  if Result then
    Delete(I);
end;

function TStringsW.NameList: TStringListW;
var
  I: Integer;
begin
  Result := TStringListW.Create;
  Result.BeginUpdate;
  try
    for I := 0 to Count - 1 do
      Result.Add(Names[I]);
  finally
    Result.EndUpdate;
  end;
end;

function TStringsW.JoinNames(const Delim: WideString): WideString;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Count - 1 do
    Result := Result + Names[I] + Delim;
  System.Delete(Result, Length(Result) - Length(Delim) + 1, MaxInt);
end;

function TStringsW.JoinValues(const Delim: WideString): WideString;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Count - 1 do
    Result := Result + ValueFromIndex[I] + Delim;
  System.Delete(Result, Length(Result) - Length(Delim) + 1, MaxInt);
end;

function TStringsW.Join(const Delim: WideString): WideString;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Count - 1 do
    Result := Result + Strings[I] + Delim;
  Result := Copy(Result, 1, Length(Result) - Length(Delim));
end;

{ TStringListW }

destructor TStringListW.Destroy;
begin
  FOnChange := NIL;
  FOnChanging := NIL;
  inherited;
  if FCount <> 0 then Finalize(FList^[0], FCount);
  FCount := 0;
  SetCapacity(0);
end;

function TStringListW.Add(const S: WideString; Tag: DWord = 0): Integer;
begin
  Result := AddObject(S, TObject(Tag));
end;

function TStringListW.AddObject(const S: WideString; AObject: TObject): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    if Find(S, Result) then
      case Duplicates of
        dupIgnore: Exit;
        dupError: Error(SDuplicateString, 0);
        dupReplace:
          begin
            PutObject(Result, AObject);
            Exit;
          end;
      end;

  InsertItem(Result, S, AObject);
end;

procedure TStringListW.Changed;
begin
  if (FUpdateCount = 0) and Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TStringListW.Changing;
begin
  if (FUpdateCount = 0) and Assigned(FOnChanging) then
    FOnChanging(Self);
end;

procedure TStringListW.Clear;
var
  I: Integer;
begin
  if FCount <> 0 then
  begin
    Changing;
    for I := 0 to FCount - 1 do
      Notify(I, lnDeleted);

    Finalize(FList^[0], FCount);
    FCount := 0;
    SetCapacity(0);
    Changed;
  end;
end;

procedure TStringListW.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Changing;
  Notify(Index, lnDeleted);

  Finalize(FList^[Index]);
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(TStringItemW));
  Changed;
end;

procedure TStringListW.Exchange(Index1, Index2: Integer);
begin
  if (Index1 < 0) or (Index1 >= FCount) then Error(SListIndexError, Index1);
  if (Index2 < 0) or (Index2 >= FCount) then Error(SListIndexError, Index2);
  Changing;
  ExchangeItems(Index1, Index2);
  Changed;
end;

procedure TStringListW.ExchangeItems(Index1, Index2: Integer);
var
  Temp: Integer;
  Item1, Item2: PStringItem;
begin
  Item1 := @FList^[Index1];
  Item2 := @FList^[Index2];
  Temp := Integer(Item1^.FString);
  Integer(Item1^.FString) := Integer(Item2^.FString);
  Integer(Item2^.FString) := Temp;
  Temp := Integer(Item1^.FObject);
  Integer(Item1^.FObject) := Integer(Item2^.FObject);
  Integer(Item2^.FObject) := Temp;
end;

function TStringListW.Find(const S: WideString; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := CompareStrings(FList^[I].FString, S);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

function TStringListW.Get(Index: Integer): WideString;
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Result := FList^[Index].FString;
end;

function TStringListW.GetCapacity: Integer;
begin
  Result := FCapacity;
end;

function TStringListW.GetCount: Integer;
begin
  Result := FCount;
end;

function TStringListW.GetObject(Index: Integer): TObject;
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Result := FList^[Index].FObject;
end;

procedure TStringListW.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4 else
    if FCapacity > 8 then Delta := 16 else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TStringListW.IndexOf(const S: WideString): Integer;
begin
  if not Sorted then Result := inherited IndexOf(S) else
    if not Find(S, Result) then Result := -1;
end;

procedure TStringListW.Insert(Index: Integer; const S: WideString; Tag: DWord = 0);
begin
  InsertObject(Index, S, TObject(Tag));
end;

procedure TStringListW.InsertObject(Index: Integer; const S: WideString;
  AObject: TObject);
begin
  if Sorted then Error(SSortedListError, 0);
  if (Index < 0) or (Index > FCount) then Error(SListIndexError, Index);
  InsertItem(Index, S, AObject);
end;

procedure TStringListW.InsertItem(Index: Integer; const S: WideString; AObject: TObject);
begin
  Changing;
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TStringItemW));
  with FList^[Index] do
  begin
    Pointer(FString) := NIL;
    FObject := AObject;
    FString := S;
  end;
  Inc(FCount);

  Notify(Index, lnAdded);
  Changed;
end;

procedure TStringListW.Put(Index: Integer; const S: WideString);
begin
  if Sorted then Error(SSortedListError, 0);
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Changing;
  FList^[Index].FString := S;
  Changed;
end;

procedure TStringListW.PutObject(Index: Integer; AObject: TObject);
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Changing;
  if FList^[Index].FObject <> AObject then
  begin
    Notify(Index, lnDeleted);
    FList^[Index].FObject := AObject;
    Notify(Index, lnAdded);
  end;
  Changed;
end;

procedure TStringListW.QuickSort(L, R: Integer; SCompare: TStringListSortCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(Self, I, P) < 0 do Inc(I);
      while SCompare(Self, J, P) > 0 do Dec(J);
      if I <= J then
      begin
        ExchangeItems(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure TStringListW.SetCapacity(NewCapacity: Integer);
begin
  ReallocMem(FList, NewCapacity * SizeOf(TStringItemW));
  FCapacity := NewCapacity;
end;

procedure TStringListW.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then Sort;
    FSorted := Value;
  end;
end;

procedure TStringListW.SetUpdateState(Updating: Boolean);
begin
  if Updating then Changing else Changed;
end;

function TStringListW.Sorter(List: TStringListW; Index1, Index2: Integer): Integer;
begin
  Result := List.CompareStrings(List.FList^[Index1].FString,
                                List.FList^[Index2].FString);
end;

procedure TStringListW.Sort;
begin
  CustomSort(Sorter);
end;

procedure TStringListW.CustomSort(Compare: TStringListSortCompare);
begin
  if not Sorted and (FCount > 1) then
  begin
    Changing;
    QuickSort(0, FCount - 1, Compare);
    Changed;
  end;
end;

function TStringListW.CompareStrings(const S1, S2: WideString): Integer;
begin
  if CaseSensitive then
    Result := CompareStr(S1, S2)
  else
    Result := CompareText(S1, S2);
end;

procedure TStringListW.SetCaseSensitive(const Value: Boolean);
begin
  if Value <> FCaseSensitive then
  begin
    FCaseSensitive := Value;
    if Sorted then Sort;
  end;
end;
      
{ TStringHashW }

procedure TStringHashW.Add(const Key: WideString; Value: Integer);
var
  Hash: Integer;
  Bucket: PHashItem;
begin
  Hash := HashOf(Key) mod DWord(Length(Buckets));
  New(Bucket);
  Bucket^.Key := Key;
  Bucket^.Value := Value;
  Bucket^.Next := Buckets[Hash];
  Buckets[Hash] := Bucket;
end;

procedure TStringHashW.Clear;
var
  I: Integer;
  P, N: PHashItem;
begin
  for I := 0 to Length(Buckets) - 1 do
  begin
    P := Buckets[I];
    while P <> NIL do
    begin
      N := P^.Next;
      Dispose(P);
      P := N;
    end;
    Buckets[I] := NIL;
  end;
end;

constructor TStringHashW.Create(Size: DWord);
begin
  inherited Create;
  SetLength(Buckets, Size);
end;

destructor TStringHashW.Destroy;
begin
  Clear;
  inherited;
end;

function TStringHashW.Find(const Key: WideString): PPHashItem;
var
  Hash: Integer;
begin
  Hash := HashOf(Key) mod DWord(Length(Buckets));
  Result := @Buckets[Hash];
  while Result^ <> NIL do
  begin
    if Result^.Key = Key then
      Exit
    else
      Result := @Result^.Next;
  end;
end;

function TStringHashW.HashOf(const Key: WideString): DWord;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(Key) do
    Result := ((Result shl 2) or (Result shr (SizeOf(Result) * 8 - 2))) xor
      Ord(Key[I]);
end;

function TStringHashW.Modify(const Key: WideString; Value: Integer): Boolean;
var
  P: PHashItem;
begin
  P := Find(Key)^;
  if P <> NIL then
  begin
    Result := True;
    P^.Value := Value;
  end
  else
    Result := False;
end;

procedure TStringHashW.Remove(const Key: WideString);
var
  P: PHashItem;
  Prev: PPHashItem;
begin
  Prev := Find(Key);
  P := Prev^;
  if P <> NIL then
  begin
    Prev^ := P^.Next;
    Dispose(P);
  end;
end;

function TStringHashW.ValueOf(const Key: WideString): Integer;
var
  P: PHashItem;
begin
  P := Find(Key)^;
  if P <> NIL then
    Result := P^.Value
  else
    Result := -1;
end;

{ THashedStringListW }

procedure THashedStringListW.Changed;
begin
  inherited;
  FValueHashValid := False;
  FNameHashValid := False;
end;

destructor THashedStringListW.Destroy;
begin
  FValueHash.Free;
  FNameHash.Free;
  inherited;
end;

function THashedStringListW.IndexOf(const S: WideString): Integer;
begin
  UpdateValueHash;
  if not CaseSensitive then
    Result :=  FValueHash.ValueOf(UpperCase(S))
  else
    Result :=  FValueHash.ValueOf(S);
end;

function THashedStringListW.IndexOfName(const Name: WideString): Integer;
begin
  UpdateNameHash;
  if not CaseSensitive then
    Result := FNameHash.ValueOf(UpperCase(Name))
  else
    Result := FNameHash.ValueOf(Name);
end;

procedure THashedStringListW.UpdateNameHash;
var
  I: Integer;
  P: Integer;
  Key: WideString;
begin
  if FNameHashValid then Exit;

  if FNameHash = NIL then
    FNameHash := TStringHashW.Create
  else
    FNameHash.Clear;
  // Inverted loop (IniFiles' goes from 0...Count) - otherwise buckets of items going
  // last are in front and Find returns last item of the same key instead of first
  // which is expected behaviour according to the docs on IndexOf[Name]:
  {{ If there is more than one string with a name portion matching the Name parameter,
     IndexOfName returns the position of the first such string. }
  for I := Count - 1 downto 0 do
  begin
    Key := Get(I);
    P := PosW(NameValueSeparator, Key);
    if P <> 0 then
    begin
      if not CaseSensitive then
        Key := UpperCase(Copy(Key, 1, P - 1))
      else
        Key := Copy(Key, 1, P - 1);
      FNameHash.Add(Key, I);
    end;
  end;
  FNameHashValid := True;
end;

procedure THashedStringListW.UpdateValueHash;
var
  I: Integer;
begin
  if FValueHashValid then Exit;

  if FValueHash = NIL then
    FValueHash := TStringHashW.Create
  else
    FValueHash.Clear;
  // Inverted loop (IniFiles' goes from 0...Count) - see UpdateNameHash note.
  for I := Count - 1 downto 0 do
    if not CaseSensitive then
      FValueHash.Add(UpperCase(Self[I]), I)
    else
      FValueHash.Add(Self[I], I);
  FValueHashValid := True;
end;

{ TObjectHash }

constructor TObjectHash.Create;
begin
  Create(True);
end;

constructor TObjectHash.Create(OwnsObjects: Boolean);
begin
  inherited Create;
  FOwnsObjects := OwnsObjects;
end;

destructor TObjectHash.Destroy;
begin
  if FOwnsObjects then
    Clear;
  inherited;
end;

procedure TObjectHash.Notify(Index: Integer; Action: TListNotification);
begin
  inherited;
  if FOwnsObjects and (Action = lnDeleted) and Assigned(Objects[Index]) then
    Objects[Index].Free;
end;

function TObjectHash.GetObjectByStr(Str: WideString): TObject;
var
  I: Integer;
begin
  I := IndexOf(Str);
  if I = -1 then
    Result := NIL
    else
      Result := Objects[I];
end;

procedure TObjectHash.SetObjectByStr(Str: WideString; Value: TObject);
var
  I: Integer;
begin
  I := IndexOf(Str);
  if I = -1 then
    AddObject(Str, Value)
    else
      Objects[I] := Value;
end;

function TObjectHash.GetObjectByName(Name: WideString): TObject;
var
  I: Integer;
begin
  I := IndexOfName(name);
  if I = -1 then
    Result := NIL
    else
      Result := Objects[I];
end;

procedure TObjectHash.SetObjectByName(Name: WideString; Value: TObject);
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if I = -1 then
    AddObject(Name + NameValueSeparator, Value)
    else
      Objects[I] := Value;
end;

function TObjectHash.Extract(Index: Integer): TObject;
begin
  Result := Objects[Index];
  Notify(Index, lnExtracted);
  FList^[Index].FObject := nil;
  Delete(Index);
end;

function TObjectHash.Delete(Obj: TObject): Boolean;
var
  I: Integer;
begin
  I := IndexOfObject(Obj);
  Result := I <> -1;
  if Result then
    Delete(I);
end;

{ TComponentHash }

type
  TComponentListNexusEvent = procedure(Sender: TObject; AComponent: TComponent) of object;
  TComponentListNexus = class (TComponent)
  public
    OnFreeNotify: TComponentListNexusEvent;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  end;

procedure TComponentListNexus.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and Assigned(OnFreeNotify) then
    OnFreeNotify(Self, AComponent);
  inherited;
end;

destructor TComponentHash.Destroy;
begin
  inherited;
  FNexus.Free;
end;

procedure TComponentHash.HandleFreeNotify(Sender: TObject; AComponent: TComponent);
begin
  Extract( IndexOfObject(AComponent) );
end;

procedure TComponentHash.Notify(Index: Integer; Action: TListNotification);
var
  Comp: TComponent;
begin
  Comp := TComponent( Objects[Index] );

  if Comp is TComponent then
  begin
    if not Assigned(FNexus) then
    begin
      FNexus := TComponentListNexus.Create(NIL);
      TComponentListNexus(FNexus).OnFreeNotify := HandleFreeNotify;
    end;

    case Action of
    lnAdded:      Comp.FreeNotification(FNexus);
    lnExtracted,
    lnDeleted:    Comp.RemoveFreeNotification(FNexus);
    end;
  end;

  inherited;
end;

end.
