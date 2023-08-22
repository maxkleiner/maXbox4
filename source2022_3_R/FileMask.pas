unit FileMask;

interface

uses Windows, SysUtils, Math, StringUtils;

type
  TFMStack = class
  protected
    FHeight: Integer;
    FItems: array[0..$FFFF] of record
      BasePath: WideString;
      Handle: DWord;
      Rec: TWin32FindDataW;
    end;

    function GetTopRec: TWin32FindDataW;
    procedure SetTopRec(const Value: TWin32FindDataW);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    procedure Push(const BasePath: WideString; Handle: DWord; const Rec: TWin32FindDataW);
    procedure Pop;
    property Height: Integer read FHeight;
    function TopHandle: DWord;
    property TopRec: TWin32FindDataW read GetTopRec write SetTopRec;
    function TopBasePath: WideString;
    function IsEmpty: Boolean;
  end;

  TMaskResolver = class
  protected
    FMaxRecursionDepth: Word;
    FCaseSensitive: Boolean;
    FMask, FNameMask: WideString;
    FSearches: TFMStack;
    FCurrent: WideString;

    procedure AddSearchPath(Path: WideString);
    procedure SearchNextFile;
    function ShouldSkip(const Name: WideString): Boolean;
    function MightHaveMore: Boolean;

    procedure SetMaxRecursionDepth(Value: Word);
    function GetRecursive: Boolean;
    procedure SetRecursive(Value: Boolean);
    procedure SetMask(const Value: WideString);
    function GetCurrent: WideString;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ToStart; 

    property MaxRecursionDepth: Word read FMaxRecursionDepth write SetMaxRecursionDepth default 50;  // inclusive.
    property Recursive: Boolean read GetRecursive write SetRecursive default False;
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive default False;

    property Mask: WideString read FMask write SetMask;
    function Next: WideString; virtual;
    // MightHaveMore isn't always accurate and for use in a loop you must call Next and check
    // if it has returned ''. Or you can use this method as a shortcut:
    //   while NextTo(FileName) do ...
    // instead of
    //   while True do begin FileName := Next; if FileName = '' then Break; ... end;
    function NextTo(out NextFile: WideString): Boolean;
    property Current: WideString read GetCurrent;
  end;

  TMultipleMasksResolver = class (TMaskResolver)
  protected
    FMasks: TWideStringArray;
    FCurrentMask: Integer;
      
    function GetMasks: WideString;
    procedure SetMasks(const Value: WideString);
    procedure SetMaskArray(const Value: TWideStringArray);
    procedure SetCurrentMask(const Value: Integer);
  public
    property Masks: WideString read GetMasks write SetMasks;
    property MaskArray: TWideStringArray read FMasks write SetMaskArray;
    function MaskCount: Integer;
    property CurrentMask: Integer read FCurrentMask write SetCurrentMask;
    procedure SetFromString(const Value: WideString; const Delim: WideString = ',');
    function AsString(const Delim: WideString = ','): WideString;

    procedure ToStart; reintroduce;
    function Next: WideString; override;
  end;

  TFileMask = TMaskResolver;
  TFileMasks = TMultipleMasksResolver;

implementation

uses Classes;

{ TFMStack }

constructor TFMStack.Create;
begin
  FHeight := 0;
end;

destructor TFMStack.Destroy;
begin
  Clear;
  inherited;
end;

procedure TFMStack.Clear;
begin
  while not IsEmpty do
    Pop;
end;

function TFMStack.TopHandle: DWord;
begin
  if IsEmpty then
    Result := INVALID_HANDLE_VALUE
    else
      Result := FItems[FHeight - 1].Handle;
end;

function TFMStack.GetTopRec: TWin32FindDataW;
begin
  if IsEmpty then
    Result.cFileName[0] := #0
    else
      Result := FItems[FHeight - 1].Rec;
end;

procedure TFMStack.SetTopRec(const Value: TWin32FindDataW);
begin
  if not IsEmpty then
    FItems[FHeight - 1].Rec := Value;
end;

function TFMStack.TopBasePath: WideString;
begin
  if IsEmpty then
    Result := ''
    else
      Result := FItems[FHeight - 1].BasePath;
end;

procedure TFMStack.Pop;
begin
  if not IsEmpty then
  begin
    Dec(FHeight);
    Windows.FindClose( FItems[FHeight].Handle );
  end;
end;

procedure TFMStack.Push(const BasePath: WideString; Handle: DWord; const Rec: TWin32FindDataW);
begin
  FItems[FHeight].BasePath := BasePath;
  FItems[FHeight].Handle := Handle;
  FItems[FHeight].Rec := Rec;

  Inc(FHeight);
  if FHeight >= Length(FItems) then
    raise Exception.Create('TFMStack: too high!');
end;

function TFMStack.IsEmpty: Boolean;
begin
  Result := FHeight = 0;
end;

{ TMaskResolver }

constructor TMaskResolver.Create;
begin
  FMaxRecursionDepth := 0;
  Recursive := False;
  FCaseSensitive := False;
  FSearches := TFMStack.Create;

  Mask := '';
end;

destructor TMaskResolver.Destroy;
begin
  FSearches.Free;
  inherited;
end;

procedure TMaskResolver.SetMaxRecursionDepth(Value: Word);
begin
  if Value < 1 then
    FMaxRecursionDepth := 1
    else
      FMaxRecursionDepth := Value;
end;

function TMaskResolver.GetRecursive: Boolean;
begin
  Result := FMaxRecursionDepth > 1;
end;

procedure TMaskResolver.SetRecursive(Value: Boolean);
begin
  if not Value then
    FMaxRecursionDepth := 1
    else if not GetRecursive then
      FMaxRecursionDepth := 50;
end;

procedure TMaskResolver.SetMask(const Value: WideString);
begin
  FMask := Value;
  if (FMask <> '') and (ExtractFilePath(FMask) = '') then
    Insert('.' + PathDelim, FMask, 1);

  FNameMask := ExtractFileName(FMask);
  if not FCaseSensitive then
    FNameMask := WideLowerCase(FNameMask);
  if FNameMask = '' then
    FNameMask := '*';

  ToStart;
end;

procedure TMaskResolver.ToStart;
begin                                 
  FCurrent := '';
  FSearches.Clear;
  AddSearchPath( ExtractFilePath(FMask) );
end;

procedure TMaskResolver.AddSearchPath(Path: WideString);
var
  Handle: DWord;
  SR: TWin32FindDataW;
begin
  if Path <> '' then
    if FMaxRecursionDepth > FSearches.Height then
    begin
      Path := IncludeTrailingPathDelimiter( Path );
      Handle := FindFirstFileW(PWideChar(Path + '*'), SR);
      if Handle <> INVALID_HANDLE_VALUE then
        FSearches.Push(Path, Handle, SR);
    end
      else
        SearchNextFile;
end;

procedure TMaskResolver.SearchNextFile;
var
  SR: TWin32FindDataW;
begin
  while not FSearches.IsEmpty do
    if FindNextFileW(FSearches.TopHandle, SR) then
    begin
      FSearches.SetTopRec(SR);
      Break;
    end
      else
        FSearches.Pop;
end;

function TMaskResolver.MightHaveMore: Boolean;
begin
  Result := (FMask <> '') and not FSearches.IsEmpty;
end;

function TMaskResolver.Next: WideString;
var
  BasePath: WideString;
begin
  while MightHaveMore do
  begin
    Result := FSearches.TopRec.cFileName;
    if ShouldSkip(Result) then
      SearchNextFile
      else
      begin
        BasePath := FSearches.TopBasePath;

        if (FSearches.TopRec.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0) then
          AddSearchPath(FSearches.TopBasePath + Result)
          else
            SearchNextFile;

        if (FCaseSensitive and MaskMatch(Result, FNameMask)) or
           (not FCaseSensitive and MaskMatch(WideLowerCase(Result), FNameMask)) then
        begin
          if Copy(BasePath, 1, 2) = '.' + PathDelim then
            Delete(BasePath, 1, 2);
          Insert(BasePath, Result, 1);
          FCurrent := Result;
          Exit;
        end;
      end;
  end;

  Result := '';
  FCurrent := '';
end;

function TMaskResolver.ShouldSkip(const Name: WideString): Boolean;
begin
  Result := (Length(Name) = 0) or (Name = '.') or (Name = '..');
end;

function TMaskResolver.NextTo(out NextFile: WideString): Boolean;
begin
  NextFile := Next;
  Result := Length(NextFile) <> 0;
end;

function TMaskResolver.GetCurrent: WideString;
begin
  if FCurrent = '' then
    FCurrent := Next;
  Result := FCurrent;
end;

{ TMultipleMasksResolver }

function TMultipleMasksResolver.GetMasks: WideString;
begin
  Result := AsString;
end;

procedure TMultipleMasksResolver.SetMasks(const Value: WideString);
begin
  SetFromString(Value);
end;

procedure TMultipleMasksResolver.SetFromString(const Value, Delim: WideString);
begin
  MaskArray := TrimStringArray( Explode(Delim, Value) );
end;

function TMultipleMasksResolver.AsString(const Delim: WideString): WideString;
begin
  Result := Join(FMasks, Delim);
end;
              
procedure TMultipleMasksResolver.SetMaskArray(const Value: TWideStringArray);
var
  I: Integer;
begin
  FMasks := Value;

  for I := Length(FMasks) - 1 downto 0 do
    if FMasks[I] = '' then
      DeleteArrayItem(FMasks, I);

  if Length(FMasks) = 0 then
    Mask := ''
    else
      CurrentMask := 0;
end;

function TMultipleMasksResolver.MaskCount: Integer;
begin
  Result := Length(FMasks);
end;

procedure TMultipleMasksResolver.ToStart;
begin
  inherited;
  CurrentMask := 0;
end;

function TMultipleMasksResolver.Next: WideString;
begin
  Result := inherited Next;

  while (Result = '') and (FCurrentMask < Length(FMasks) - 1) do
  begin
    CurrentMask := CurrentMask + 1;
    Result := Next;
  end;
end;

procedure TMultipleMasksResolver.SetCurrentMask(const Value: Integer);
begin
  if (Value < 0) or (Value >= Length(FMasks)) then
    raise EListError.CreateFmt('File mask index (%d) out of bounds (0..%d).', [Value, Length(FMasks)]);
  FCurrentMask := Value;
  Mask := FMasks[Value];
end;

end.
