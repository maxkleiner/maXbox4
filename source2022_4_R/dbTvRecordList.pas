unit dbTvRecordList;

{ Internal list for the TDBTreeView component.
  Version 0.82  Aug-10-1997  (C) 1997 Christoph R. Kirchner
  !! This unit is currently UNDER CONSTRUCTION !!
}
{ Users of this unit must accept this disclaimer of warranty:
    "This unit is supplied as is. The author disclaims all warranties,
    expressed or implied, including, without limitation, the warranties
    of merchantability and of fitness for any purpose.
    The author assumes no liability for damages, direct or
    consequential, which may result from the use of this unit."

  This unit is donated to the public as public domain.

  This unit can be freely used and distributed in commercial and
  private environments provided this notice is not modified in any way.

  If you do find this unit handy and you feel guilty for using such a
  great product without paying someone - sorry :-)

  Please forward any comments or suggestions to Christoph Kirchner at:
  ckirchner@geocities.com

  Maybe you can find an update of this unit at my
  "Delphi Component Building Site":
  http://www.geocities.com/SiliconValley/Heights/7874/delphi.htm
}

interface

uses SysUtils, Classes;

type

  TTVRecordListDifference = (
    tvrldNone, tvrldText, tvrldCount, tvrldNodeMoved);

  TInternalTVFindTextOption = (itvftCaseInsensitive, itvftPartial);
  TInternalTVFindTextOptions = set of TInternalTVFindTextOption;

  TTvRecordInfo = class
  public
    ID: String;
    Parent: String;
    Text: String;
    WasExpanded: Boolean;
    constructor Create(const AID, AParent, AText: String);
  end;


  TTVTextList = class(TStringList)
  public
    function PartialFind(const S: string; var Index: Integer): Boolean;
  end;


  TTVParentList = class(TList)
  public
    Sorted: Boolean;
    function FindParent(const Parent: String; var Index: Integer): Boolean;
  end;


  TTVRecordList = class(TList)
  private
    FUpperCaseTextList: TTVTextList;
    FTextList: TTVTextList;
    FParentList: TTVParentList;
    FSorted: Boolean;
    procedure SetSorted(Value: Boolean);
    function GetUpperCaseTextList: TTVTextList;
    function GetTextList: TTVTextList;
    function GetParentList: TTVParentList;
    function GetParent(Index: Integer): TTvRecordInfo;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddRecord(const AID, AParent, AText: String);
    function FindID(const ID: String; var Index: Integer): Boolean;
    function FindParent(const Parent: String;
      var ParentIndex: Integer): Boolean;
    function FindTextID(const S: string; var ID: String;
      InternalTVFindTextOptions: TInternalTVFindTextOptions): Boolean;
    function TextIDList(const S: string;
      InternalTVFindTextOptions: TInternalTVFindTextOptions): TStringList;
    function GetDifference(
      TVRecordList: TTVRecordList): TTVRecordListDifference;
    procedure ChangeParent(const AID, NewParent: String);
    procedure ChangeText(const AID, NewText: String);
    property UpperCaseTextList: TTVTextList read GetUpperCaseTextList;
    property TextList: TTVTextList read GetTextList;
    property Sorted: Boolean read FSorted write SetSorted;
    property Parent[Index: Integer]: TTvRecordInfo read GetParent;
  end;



implementation


{ TTvRecordInfo ------------------------------------------------------------- }

constructor TTvRecordInfo.Create(const AID, AParent, AText: String);
begin
  inherited Create;
  ID := AID;
  Parent := AParent;
  Text := AText;
end;



{ TTVTextList -------------------------------------------------------------- }

function TTVTextList.PartialFind(
  const S: string; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
  CompareLen: Integer;
begin
  CompareLen := Length(S);
  Result := False;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := AnsiCompareText(Copy(Strings[I], 1, CompareLen), S);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
        while (L > 0) and
              (AnsiCompareText(Copy(Strings[L - 1], 1, CompareLen), S) = 0) do
          Dec(L); { find first }
      end;
    end;
  end;
  Index := L;
end;


{ TTVParentList ------------------------------------------------------------- }

function CompareParent(Item1, Item2: Pointer): Integer;
begin
  if (TTvRecordInfo(Item1).Parent > TTvRecordInfo(Item2).Parent) then
    result := 1
  else
    if (TTvRecordInfo(Item1).Parent < TTvRecordInfo(Item2).Parent) then
      result := -1
    else
      result := 0;
end;

function CompareParentText(Item1, Item2: Pointer): Integer;
begin
  result := CompareParent(Item1, Item2);
  if (result = 0) then
    result := AnsiCompareText(TTvRecordInfo(Item1).Text, TTvRecordInfo(Item2).Text);
//test...    result := AnsiCompareText(TTvRecordInfo(Item1).ID, TTvRecordInfo(Item2).ID);
end;

function TTVParentList.FindParent(const Parent: String;
  var Index: Integer): Boolean;
var
  L, H, I: Integer;
  P: String;
begin
  if not Sorted then
  begin
    Sort(CompareParentText);
    Sorted := true;
  end;
  Result := False;
  L := 0;
  H := Count - 1;
  while (L <= H) do
  begin
    I := (L + H) shr 1;
    P := TTvRecordInfo(List^[I]).Parent;
    if (P < Parent) then
      L := I + 1
    else
    begin
      H := I - 1;
      if P = Parent then
      begin
        Result := True;
      end;
    end;
  end;
  Index := L;
end;


{ TTVRecordList ------------------------------------------------------------- }

constructor TTVRecordList.Create;
begin
  inherited;
  FUpperCaseTextList := nil;
  FTextList := nil;
  FParentList := nil;
  FSorted := false;
end;

destructor TTVRecordList.Destroy;
var
  i: Integer;
begin
  try
    for i := 0 to Count - 1 do
      TTvRecordInfo(List^[i]).Free;
  finally
    try
      if Assigned(FUpperCaseTextList) then
        FUpperCaseTextList.Free;
      if Assigned(FTextList) then
        FTextList.Free;
      if Assigned(FParentList) then
        FParentList.Free;
    finally
      inherited;
    end;
  end;
end;

procedure TTVRecordList.AddRecord(const AID, AParent, AText: String);
begin
  Add(TTvRecordInfo.Create(AID, AParent, AText));
  if Assigned(FUpperCaseTextList) then
  begin
    FUpperCaseTextList.Free;
    FUpperCaseTextList := nil;
  end;
  if Assigned(FTextList) then
  begin
    FTextList.Free;
    FTextList := nil;
  end;
  if Assigned(FParentList) then
  begin
    FParentList.Free;
    FParentList := nil;
  end;
  Sorted := false;
end;

function TTVRecordList.GetDifference(
  TVRecordList: TTVRecordList): TTVRecordListDifference;
var
  i: Integer;
begin
  if (TVRecordList = nil) or (Count <> TVRecordList.Count) then
  begin
    result := tvrldCount;
    exit;
  end;
  Sorted := true;
  TVRecordList.Sorted := true;
  result := tvrldNone;
  for i := 0 to Count - 1 do
    with TTvRecordInfo(TVRecordList[i]) do
    begin
      if (TTvRecordInfo(List^[i]).ID <> ID) or
         (TTvRecordInfo(List^[i]).Parent <> Parent) then
      begin
        result := tvrldNodeMoved;
        exit;
      end;
      if (TTvRecordInfo(List^[i]).Text <> Text) then
        result := tvrldText;
    end;
end;

function TTVRecordList.GetUpperCaseTextList: TTVTextList;
var
  i: Integer;
begin
  if (FUpperCaseTextList = nil) then
  begin
    FUpperCaseTextList := TTVTextList.Create;
    try
      for i := 0 to Count -1 do
        with TTvRecordInfo(List^[i]) do
          FUpperCaseTextList.AddObject(AnsiUpperCase(Text), @ID);
      FUpperCaseTextList.Sorted := true;
    except
      FUpperCaseTextList.Free;
      FUpperCaseTextList := nil;
    end;
  end;
  result := FUpperCaseTextList;
end;

function TTVRecordList.GetTextList: TTVTextList;
var
  i: Integer;
begin
  if (FTextList = nil) then
  begin
    FTextList := TTVTextList.Create;
    try
      for i := 0 to Count -1 do
        with TTvRecordInfo(List^[i]) do
          FTextList.AddObject(Text, @ID);
      FTextList.Sorted := true;
    except
      FTextList.Free;
      FTextList := nil;
    end;
  end;
  result := FTextList;
end;

function TTVRecordList.GetParentList: TTVParentList;
var
  i: Integer;
begin
  if (FParentList = nil) then
  begin
    FParentList := TTVParentList.Create;
    try
      FParentList.Sorted := false;
      for i := 0 to Count -1 do
        FParentList.Add(List^[i]);
    except
      FParentList.Free;
      FParentList := nil;
    end;
  end;
  result := FParentList;
end;

function TTVRecordList.FindParent(const Parent: String;
  var ParentIndex: Integer): Boolean;
begin
  if (GetParentList = nil) then
    Result := False
  else
    Result := FParentList.FindParent(Parent, ParentIndex);
end;

function TTVRecordList.GetParent(Index: Integer): TTvRecordInfo;
begin
  if (GetParentList = nil) then
    Result := nil
  else
    Result := TTvRecordInfo(FParentList.List^[Index]);
end;

function CompareID(Item1, Item2: Pointer): Integer;
begin
  if (TTvRecordInfo(Item1).ID > TTvRecordInfo(Item2).ID) then
    result := 1
  else
    if (TTvRecordInfo(Item1).ID < TTvRecordInfo(Item2).ID) then
      result := -1
    else
      result := 0;
end;

procedure TTVRecordList.SetSorted(Value: Boolean);
begin
  if (FSorted <> Value) then
  begin
    FSorted := Value;
    if FSorted then
      Sort(CompareID);
  end;
end;

function TTVRecordList.FindID(const ID: String; var Index: Integer): Boolean;
var
  L, H, I: Integer;
  IDAtI: String;
begin
  Sorted := true;
  Result := False;
  L := 0;
  H := Count - 1;
  while (L <= H) do
  begin
    I := (L + H) shr 1;
    IDAtI := TTvRecordInfo(List^[I]).ID;
    if (IDAtI < ID) then
      L := I + 1
    else
    begin
      H := I - 1;
      if (IDAtI = ID) then
      begin
        Result := True;
      end;
    end;
  end;
  Index := L;
end;

function TTVRecordList.FindTextID(const S: string; var ID: String;
  InternalTVFindTextOptions: TInternalTVFindTextOptions): Boolean;
var
  Index: Integer;
  StringList: TTVTextList;
begin
  result := false;
  if (itvftCaseInsensitive in InternalTVFindTextOptions) then
  begin
    StringList := UpperCaseTextList;
    if (StringList <> nil) then
    begin
      if (itvftPartial in InternalTVFindTextOptions) then
      begin
        if StringList.PartialFind(AnsiUpperCase(S), Index) then
        begin
          ID := String(Pointer(StringList.Objects[Index])^);
          result := true;
        end;
      end
      else
      begin
        if StringList.Find(AnsiUpperCase(S), Index) then
        begin
          ID := String(Pointer(StringList.Objects[Index])^);
          result := true;
        end;
      end;
    end;
  end
  else
  begin
    StringList := TextList;
    if (StringList <> nil) then
    begin
      if (itvftPartial in InternalTVFindTextOptions) then
      begin
        if StringList.PartialFind(S, Index) then
        begin
          ID := String(Pointer(StringList.Objects[Index])^);
          result := true;
        end;
      end
      else
      begin
        if StringList.Find(S, Index) then
        begin
          ID := String(Pointer(StringList.Objects[Index])^);
          result := true;
        end;
      end;
    end;
  end;
end;

function TTVRecordList.TextIDList(const S: string;
  InternalTVFindTextOptions: TInternalTVFindTextOptions): TStringList;
var
  Index: Integer;
  StringList: TTVTextList;
begin
  result := nil;
  if (itvftCaseInsensitive in InternalTVFindTextOptions) then
  begin
    StringList := UpperCaseTextList;
    if (StringList <> nil) then
    begin
      if (itvftPartial in InternalTVFindTextOptions) then
      begin
        if StringList.PartialFind(AnsiUpperCase(S), Index) then
        begin
          result := TStringList.Create;
          repeat
            result.Add(String(Pointer(StringList.Objects[Index])^));
            Inc(Index);
          until (Index = StringList.Count) or
                (AnsiCompareText(Copy(StringList[Index], 1,
                                      Length(S)), S) <> 0);
        end;
      end
      else
      begin
        if StringList.Find(AnsiUpperCase(S), Index) then
        begin
          result := TStringList.Create;
          repeat
            result.Add(String(Pointer(StringList.Objects[Index])^));
            Inc(Index);
          until (Index = StringList.Count) or
                (AnsiCompareText(StringList[Index], S) <> 0);
        end;
      end;
    end;
  end
  else
  begin
    StringList := TextList;
    if (StringList <> nil) then
    begin
      if (itvftPartial in InternalTVFindTextOptions) then
      begin
        if StringList.PartialFind(S, Index) then
        begin
          result := TStringList.Create;
          repeat
            result.Add(String(Pointer(StringList.Objects[Index])^));
            Inc(Index);
          until (Index = StringList.Count) or
                (AnsiCompareStr(Copy(StringList[Index], 1,
                                     Length(S)), S) <> 0);
        end;
      end
      else
      begin
        if StringList.Find(S, Index) then
        begin
          result := TStringList.Create;
          repeat
            result.Add(String(Pointer(StringList.Objects[Index])^));
            Inc(Index);
          until (Index = StringList.Count) or
                (AnsiCompareStr(StringList[Index], S) <> 0);
        end;
      end;
    end;
  end;
end;

procedure TTVRecordList.ChangeParent(const AID, NewParent: String);
var
  i: Integer;
begin
  if FindID(AID, i) then
  begin
    TTvRecordInfo(List^[i]).Parent := NewParent;
    if Assigned(FParentList) then
      FParentList.Sorted := false;
  end;
end;

procedure TTVRecordList.ChangeText(const AID, NewText: String);
var
  i: Integer;
begin
  if Assigned(FUpperCaseTextList) then
  begin
    FUpperCaseTextList.Free;
    FUpperCaseTextList := nil;
  end;
  if Assigned(FTextList) then
  begin
    FTextList.Free;
    FTextList := nil;
  end;
  if FindID(AID, i) then
    TTvRecordInfo(List^[i]).Text := NewText;
end;



end.
