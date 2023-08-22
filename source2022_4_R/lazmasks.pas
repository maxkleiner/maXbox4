{
/***************************************************************************
masks.pas
---------

***************************************************************************/

*****************************************************************************
This file is part of the Lazarus Component Library (LCL)

See the file COPYING.modifiedLGPL.txt, included in this distribution,
for details about the license.
*****************************************************************************
}
unit lazMasks;

//{$mode objfpc}{$H+}

interface

uses
  // For Smart Linking: Do not use the LCL!
  Classes, SysUtils, Contnrs, StrUtils; //, LazUtilsStrConsts;

type
  TMaskCharType = (mcChar, mcCharSet, mcAnyChar, mcAnyText);
  
  TCharSet = set of Char;
  PCharSet = ^TCharSet;
  
  TMaskChar = record
    case CharType: TMaskCharType of
      mcChar: (CharValue: Char);
      mcCharSet: (Negative: Boolean; SetValue: PCharSet);
      mcAnyChar, mcAnyText: ();
  end;
  
  TMaskString = record
    MinLength: Integer;
    MaxLength: Integer;
    Chars: Array of TMaskChar;
  end;

  { TMask }

  TMask = class
  private
    FMask: TMaskString;
    fCaseSensitive: Boolean;
    fInitialMask: String;
    procedure InitMaskString(const AValue: String; const CaseSensitive: Boolean);
    procedure ClearMaskString;
  public
    constructor Create(const AValue: String; const CaseSensitive: Boolean = False);
    destructor Destroy; override;
    
    function Matches(const AFileName: String): Boolean;
    function MatchesWindowsMask(const AFileName: String): Boolean;
  end;
  
  { TParseStringList }

  TParseStringList = class(TStringList)
  public
    constructor Create(const AText, ASeparators: String);
  end;
  
  { TMaskList }

  TMaskList = class
  private
    FMasks: TObjectList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TMask;
  public
    constructor Create(const AValue: String; ASeparator: Char = ';'; const CaseSensitive: Boolean = False);
    destructor Destroy; override;
    
    function Matches(const AFileName: String): Boolean;
    function MatchesWindowsMask(const AFileName: String): Boolean;
    
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TMask read GetItem;
  end;

function MatchesMask(const FileName, Mask: String; const CaseSensitive: Boolean = False): Boolean;
function MatchesWindowsMask(const FileName, Mask: String; const CaseSensitive: Boolean = False): Boolean;
function MatchesMaskList(const FileName, Mask: String; Separator: Char = ';'; const CaseSensitive: Boolean = False): Boolean;
function MatchesWindowsMaskList(const FileName, Mask: String; Separator: Char = ';'; const CaseSensitive: Boolean = False): Boolean;

implementation

function MatchesMask(const FileName, Mask: String; const CaseSensitive: Boolean): Boolean;
var
  AMask: TMask;
begin
  AMask := TMask.Create(Mask, CaseSensitive);
  try
    Result := AMask.Matches(FileName);
  finally
    AMask.Free;
  end;
end;

function MatchesWindowsMask(const FileName, Mask: String; const CaseSensitive: Boolean): Boolean;
var
  AMask: TMask;
begin
  AMask := TMask.Create(Mask, CaseSensitive);
  try
    Result := AMask.MatchesWindowsMask(FileName);
  finally
    AMask.Free;
  end;
end;

function MatchesMaskList(const FileName, Mask: String; Separator: Char; const CaseSensitive: Boolean): Boolean;
var
  AMaskList: TMaskList;
begin
  AMaskList := TMaskList.Create(Mask, Separator, CaseSensitive);
  try
    Result := AMaskList.Matches(FileName);
  finally
    AMaskList.Free;
  end;
end;

function MatchesWindowsMaskList(const FileName, Mask: String; Separator: Char; const CaseSensitive: Boolean): Boolean;
var
  AMaskList: TMaskList;
begin
  AMaskList := TMaskList.Create(Mask, Separator, CaseSensitive);
  try
    Result := AMaskList.MatchesWindowsMask(FileName);
  finally
    AMaskList.Free;
  end;
end;

{ TMask }

procedure TMask.InitMaskString(const AValue: String; const CaseSensitive: Boolean);
var
  I: Integer;
  SkipAnyText: Boolean;

  procedure CharSetError;
  begin
    raise EConvertError.CreateFmt('lrsInvalidCharSet', [AValue]);
  end;

  procedure AddAnyText;
  begin
    if SkipAnyText then
    begin
      Inc(I);
      Exit;
    end;

    SetLength(FMask.Chars, Length(FMask.Chars) + 1);
    FMask.Chars[High(FMask.Chars)].CharType := mcAnyText;

    FMask.MaxLength := MaxInt;
    SkipAnyText := True;
    Inc(I);
  end;

  procedure AddAnyChar;
  begin
    SkipAnyText := False;

    SetLength(FMask.Chars, Length(FMask.Chars) + 1);
    FMask.Chars[High(FMask.Chars)].CharType := mcAnyChar;

    Inc(FMask.MinLength);
    if FMask.MaxLength < MaxInt then Inc(FMask.MaxLength);

    Inc(I);
  end;

  procedure AddCharSet;
  var
    CharSet: TCharSet;
    Valid: Boolean;
    C, Last: Char;
  begin
    SkipAnyText := False;

    SetLength(FMask.Chars, Length(FMask.Chars) + 1);
    FMask.Chars[High(FMask.Chars)].CharType := mcCharSet;

    Inc(I);
    if (I <= Length(AValue)) and (AValue[I] = '!') then
    begin
      FMask.Chars[High(FMask.Chars)].Negative := True;
      Inc(I);
    end
    else FMask.Chars[High(FMask.Chars)].Negative := False;

    Last := '-';
    CharSet := [];
    Valid := False;
    while I <= Length(AValue) do
    begin
      case AValue[I] of
        '-':
          begin
            if Last = '-' then CharSetError;
            Inc(I);

            if (I > Length(AValue)) then CharSetError;
            if fCaseSensitive then
            begin
              //DebugLn('Set: ' + Last + '-' + (AValue[I]));
              for C := Last to (AValue[I]) do Include(CharSet, C);
            end
            else
            begin
              //DebugLn('Set: ' + Last + '-' + UpCase(AValue[I]));
              for C := Last to UpCase(AValue[I]) do Include(CharSet, C);
            end;
            Inc(I);
          end;
        ']':
          begin
            Valid := True;
            Break;
          end;
        else
        begin
          if fCaseSensitive then
            Last := AValue[I]
          else
            Last := UpCase(AValue[I]);
          Include(CharSet, Last);
          Inc(I);
        end;
      end;
    end;

    if (not Valid) or (CharSet = []) then CharSetError;

    New(FMask.Chars[High(FMask.Chars)].SetValue);
    FMask.Chars[High(FMask.Chars)].SetValue^ := CharSet;

    Inc(FMask.MinLength);
    if FMask.MaxLength < MaxInt then Inc(FMask.MaxLength);

    Inc(I);
  end;

  procedure AddChar;
  begin
    SkipAnyText := False;

    SetLength(FMask.Chars, Length(FMask.Chars) + 1);
    with FMask.Chars[High(FMask.Chars)] do
    begin
      CharType := mcChar;
      if fCaseSensitive then
        CharValue := AValue[I]
      else
        CharValue := UpCase(AValue[I]);
    end;

    Inc(FMask.MinLength);
    if FMask.MaxLength < MaxInt then Inc(FMask.MaxLength);

    Inc(I);
  end;

begin
  fCaseSensitive:=CaseSensitive;
  SetLength(FMask.Chars, 0);
  FMask.MinLength := 0;
  FMask.MaxLength := 0;
  SkipAnyText := False;

  I := 1;
  while I <= Length(AValue) do
  begin
    case AValue[I] of
      '*': AddAnyText;
      '?': AddAnyChar;
      '[': AddCharSet;
      else AddChar;
    end;
  end;
end;

procedure TMask.ClearMaskString;
var
  I: Integer;
begin
  for I := 0 to High(FMask.Chars) do
    if FMask.Chars[I].CharType = mcCharSet then
      Dispose(FMask.Chars[I].SetValue);
end;

constructor TMask.Create(const AValue: String; const CaseSensitive: Boolean);

begin
  fInitialMask := AValue;
  fCaseSensitive := CaseSensitive;
  InitMaskString(AValue, CaseSensitive);
end;

destructor TMask.Destroy;
begin
  ClearMaskString;
  inherited Destroy;
end;

function TMask.Matches(const AFileName: String): Boolean;
var
  L: Integer;
  S: String;
  
  function MatchToEnd(MaskIndex, CharIndex: Integer): Boolean;
  var
    I, J: Integer;
  begin
    Result := False;
    
    for I := MaskIndex to High(FMask.Chars) do
    begin
      case FMask.Chars[I].CharType of
        mcChar:
          begin
            if CharIndex > L then Exit;
            //DebugLn('Match ' + S[CharIndex] + '<?>' + FMask.Chars[I].CharValue);
            if S[CharIndex] <> FMask.Chars[I].CharValue then Exit;
            Inc(CharIndex);
          end;
        mcCharSet:
          begin
            if CharIndex > L then Exit;
            if FMask.Chars[I].Negative xor
               (S[CharIndex] in FMask.Chars[I].SetValue^) then Inc(CharIndex)
            else Exit;
          end;
        mcAnyChar:
          begin
            if CharIndex > L then Exit;
            Inc(CharIndex);
          end;
        mcAnyText:
          begin
            if I = High(FMask.Chars) then
            begin
              Result := True;
              Exit;
            end;
            
            for J := CharIndex to L do
              if MatchToEnd(I + 1, J) then
              begin
                Result := True;
                Exit;
              end;
          end;
      end;
    end;
    
    Result := CharIndex > L;
  end;
  
begin
  Result := False;
  L := Length(AFileName);
  if L = 0 then
  begin
    if FMask.MinLength = 0 then Result := True;
    Exit;
  end;
  
  if (L < FMask.MinLength) or (L > FMask.MaxLength) then Exit;
  if fCaseSensitive then
    S := AFileName
  else
    S := UpperCase(AFileName);
  Result := MatchToEnd(0, 1);
end;

function TMask.MatchesWindowsMask(const AFileName: String): Boolean;
var
  NewMaskValue, Ext: String;
begin
  // treat initial mask differently for special cases:
  // foo*.* -> foo*
  // foo*. -> match foo*, but muts not have an extension
  // *. -> any file without extension ( .foo is a filename without extension according to Windows)
  // foo. matches only foo but not foo.txt
  // foo.* -> match either foo or foo.*

  if (Length(fInitialMask) > 2) and (RightStr(fInitialMask,3) = '*.*') then
  // foo*.*
  begin
    NewMaskValue := Copy(fInitialMask,1,Length(fInitialMask)-2);
    ClearMaskString;
    InitMaskString(NewMaskValue, fCaseSensitive);
    Result := Matches(AFileName);
    //Restore initial state of FMask
    ClearMaskString;
    InitMaskString(fInitialMask, fCaseSensitive);
  end
  //else if (Length(fInitialMask) > 1) and (RightStr(fInitialMask,2) = '*.') then
  else if (Length(fInitialMask) > 1) and (fInitialMask[Length(fInitialMask)] = '.') then

  //foo*. or *. or foo.
  begin
    //if AFileName has an extension then Result is False, otherwise see if it matches foo*/foo
    //a filename like .foo under Windows is considered to be a file without an extension
    Ext := ExtractFileExt(AFileName);
    if (Ext = '') or (Ext = AFileName) then
    begin
      NewMaskValue := Copy(fInitialMask,1,Length(fInitialMask)-1);
      ClearMaskString;
      InitMaskString(NewMaskValue, fCaseSensitive);
      Result := Matches(AFileName);
      //Restore initial state of FMask
      ClearMaskString;
      InitMaskString(fInitialMask, fCaseSensitive);
    end
    else
    begin
      Result := False;
    end;
  end
  else if (Length(fInitialMask) > 2) and (RightStr(fInitialMask,2) = '.*') then
  //foo.* (but not '.*')
  begin
    //First see if we have 'foo'
    if fCaseSensitive then
      Result := (AFileName = Copy(fInitialMask,1,Length(fInitialMask)-2))
    else
      Result := (CompareText(AFileName,Copy(fInitialMask,1,Length(fInitialMask)-2)) = 0);
    if not Result then Result := Matches(AFileName);
  end
  else
  //all other cases just call Matches()
  begin
    Result := Matches(AFileName);
  end;
end;

{ TParseStringList }

constructor TParseStringList.Create(const AText, ASeparators: String);
var
  I, S: Integer;
begin
  inherited Create;

  S := 1;
  for I := 1 to Length(AText) do
  begin
    if Pos(AText[I], ASeparators) > 0 then
    begin
      if I > S then Add(Copy(AText, S, I - S));
      S := I + 1;
    end;
  end;
  
  if Length(AText) >= S then Add(Copy(AText, S, Length(AText) - S + 1));
end;

{ TMaskList }

function TMaskList.GetItem(Index: Integer): TMask;
begin
  Result := TMask(FMasks.Items[Index]);
end;

function TMaskList.GetCount: Integer;
begin
  Result := FMasks.Count;
end;

constructor TMaskList.Create(const AValue: String; ASeparator: Char; const CaseSensitive: Boolean);
var
  S: TParseStringList;
  I: Integer;
begin
  FMasks := TObjectList.Create(True);
  
  S := TParseStringList.Create(AValue, ASeparator);
  try
    for I := 0 to S.Count - 1 do
      FMasks.Add(TMask.Create(S[I], CaseSensitive));
  finally
    S.Free;
  end;
end;

destructor TMaskList.Destroy;
begin
  FMasks.Free;
  
  inherited Destroy;
end;

function TMaskList.Matches(const AFileName: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  
  for I := 0 to FMasks.Count - 1 do
  begin
    if TMask(FMasks.Items[I]).Matches(AFileName) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TMaskList.MatchesWindowsMask(const AFileName: String): Boolean;
var
  I: Integer;
begin
  Result := False;

  for I := 0 to FMasks.Count - 1 do
  begin
    if TMask(FMasks.Items[I]).MatchesWindowsMask(AFileName) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

end.



----app_template_loaded_code----