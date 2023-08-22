unit xrtl_util_NameSpace;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils, Classes, Contnrs, Masks,
  xrtl_util_Exception, xrtl_util_Value,
  xrtl_util_COMUtils, xrtl_util_Map, xrtl_util_Container,
  xrtl_util_NameSpacePath;

type
  EXRTLInvalidNameSpacePath = class(EXRTLException);

  TXRTLNameSpaceEnumeratorType = (nsEnumerateBranches, // entries with SubItems.Size > 0
                                  nsEnumerateLeaves,   // entries with SubItems.Size = 0
                                  nsEnumerateRecursive,
                                  nsEnumerateBranchesAndLeaves);

  TXRTLNameSpace = class;

  TXRTLNameSpaceEntry = class
  private
    FSubItems: TXRTLMap;
    FParent: TXRTLNameSpaceEntry;
    FNameSpace: TXRTLNameSpace;
  public
    Value: IXRTLValue;
    constructor Create(const ANameSpace: TXRTLNameSpace; const AParent: TXRTLNameSpaceEntry = nil);
    destructor Destroy; override;
    property   SubItems: TXRTLMap read FSubItems;
    property   Parent: TXRTLNameSpaceEntry read FParent;
  end;

  TXRTLNameSpaceEnumerator = class(TXRTLEnumXXXX)
  private
    FItems: TObjectList;
    procedure  EnumItems(const RootEntry: TXRTLNameSpaceEntry;
                         const RootPath: TXRTLNameSpacePath;
                         EnumType: TXRTLNameSpaceEnumeratorType;
                         const NameFilter: WideString);
  protected
    function   GetItem(const ItemIndex: LongInt): Pointer; override;
    function   GetCount: LongInt; override;
  public
    constructor Create(const RootEntry: TXRTLNameSpaceEntry; EnumType: TXRTLNameSpaceEnumeratorType;
                       const NameFilter: WideString = '');
    destructor Destroy; override;
  end;

  TXRTLNameSpace = class(TXRTLBaseContainer)
  private
    FRoot: TXRTLNameSpaceEntry;
    function   GetNameSpaceEntry(const Path: TXRTLNameSpacePath; AutoCreate: Boolean = False): TXRTLNameSpaceEntry;
    procedure  CheckPath(const Path: TXRTLNameSpacePath);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function   IsEmpty: Boolean; override;
    procedure  Clear; override;
    function   SetValue(const Path: TXRTLNameSpacePath; const IValue: IXRTLValue): IXRTLValue; virtual;
    function   GetValue(const Path: TXRTLNameSpacePath): IXRTLValue; virtual;
    procedure  Remove(const Path: TXRTLNameSpacePath); virtual;
    function   HasKey(const Path: TXRTLNameSpacePath): Boolean; virtual;
    function   CreateEnumerator(const RootPath: TXRTLNameSpacePath;
                                EnumType: TXRTLNameSpaceEnumeratorType;
                                const NameFilter: WideString = '*'): TXRTLNameSpaceEnumerator; virtual;
    function   IsLeaf(const Path: TXRTLNameSpacePath): Boolean; virtual;
    function   IsBranch(const Path: TXRTLNameSpacePath): Boolean; virtual;
  end;

implementation

{ TXRTLNameSpaceEntry }

constructor TXRTLNameSpaceEntry.Create(const ANameSpace: TXRTLNameSpace; const AParent: TXRTLNameSpaceEntry = nil);
begin
  inherited Create;
  FNameSpace:= ANameSpace;
  Value:= nil;
  FSubItems:= TXRTLArrayMap.Create;
  FParent:= AParent;
end;

destructor TXRTLNameSpaceEntry.Destroy;
begin
  FreeAndNil(FSubItems);
  inherited;
end;

type
  TXRTLNameSpaceEnumeratorItem = class
  public
    Path: TXRTLNameSpacePath;
  end;

{ TXRTLNameSpaceEnumerator }

constructor TXRTLNameSpaceEnumerator.Create(const RootEntry: TXRTLNameSpaceEntry;
                                            EnumType: TXRTLNameSpaceEnumeratorType;
                                            const NameFilter: WideString = '');
begin
  inherited Create;
  FItems:= TObjectList.Create(True);
  EnumItems(RootEntry, XRTLNameSpacePathCreate([]), EnumType, NameFilter);
end;

destructor TXRTLNameSpaceEnumerator.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TXRTLNameSpaceEnumerator.EnumItems(const RootEntry: TXRTLNameSpaceEntry;
                                             const RootPath: TXRTLNameSpacePath;
                                             EnumType: TXRTLNameSpaceEnumeratorType;
                                             const NameFilter: WideString);
var
  I: Integer;
  SubPath: TXRTLNameSpacePath;
  Entry: TXRTLNameSpaceEntry;
  Item: TXRTLNameSpaceEnumeratorItem;
  SubName: WideString;
  Keys: TXRTLValueArray;
begin
  SetLength(Keys, 0);
  SubPath:= XRTLNameSpacePathCreate([]);
  if not Assigned(RootEntry) then Exit;
  Keys:= RootEntry.SubItems.GetKeys;
  for I:= 0 to Length(Keys) - 1 do
  begin
    XRTLGetAsObject(RootEntry.SubItems.GetValue(Keys[I]), Entry);
    SubName:= XRTLGetAsWideString(Keys[I]);
    if not MatchesMask(SubName, NameFilter) then
      Continue;
    SubPath:= XRTLNameSpacePathConcat(RootPath, XRTLNameSpacePathCreate([SubName]));
    case EnumType of
      nsEnumerateBranches:
      begin
        if not Entry.SubItems.IsEmpty then
        begin
          Item:= TXRTLNameSpaceEnumeratorItem.Create;
          Item.Path:= Copy(SubPath);
          FItems.Add(Item);
        end;
      end;
      nsEnumerateLeaves:
      begin
        if Entry.SubItems.IsEmpty then
        begin
          Item:= TXRTLNameSpaceEnumeratorItem.Create;
          Item.Path:= Copy(SubPath);
          FItems.Add(Item);
        end;
      end;
      nsEnumerateRecursive:
      begin
        Item:= TXRTLNameSpaceEnumeratorItem.Create;
        Item.Path:= Copy(SubPath);
        FItems.Add(Item);
        if not Entry.SubItems.IsEmpty then
        begin
          EnumItems(Entry, SubPath, EnumType, NameFilter);
        end;
      end;
      nsEnumerateBranchesAndLeaves:
      begin
        Item:= TXRTLNameSpaceEnumeratorItem.Create;
        Item.Path:= Copy(SubPath);
        FItems.Add(Item);
      end;
    else
      raise EXRTLException.Create('Invalid EnumType');
    end;
  end;
  SetLength(Keys, 0);
end;

function TXRTLNameSpaceEnumerator.GetCount: LongInt;
begin
  Result:= FItems.Count;
end;

function TXRTLNameSpaceEnumerator.GetItem(const ItemIndex: Integer): Pointer;
begin
  Result:= @(FItems[ItemIndex] as TXRTLNameSpaceEnumeratorItem).Path;
end;

{ TXRTLNameSpace }

constructor TXRTLNameSpace.Create;
begin
  inherited Create;
  FRoot:= TXRTLNameSpaceEntry.Create(Self);
end;

destructor TXRTLNameSpace.Destroy;
begin
  FreeAndNil(FRoot);
  inherited;
end;

function TXRTLNameSpace.IsEmpty: Boolean;
begin
  Result:= FRoot.SubItems.IsEmpty;
end;

procedure TXRTLNameSpace.Clear;
begin
  FRoot.SubItems.Clear;
end;

function TXRTLNameSpace.SetValue(const Path: TXRTLNameSpacePath; const IValue: IXRTLValue): IXRTLValue;
var
  Entry: TXRTLNameSpaceEntry;
begin
  CheckPath(Path);
  Result:= nil;
  Entry:= GetNameSpaceEntry(Path, True);
  if Assigned(Entry) then
  begin
    Result:= Entry.Value;
    Entry.Value:= IValue;
  end;
end;

function TXRTLNameSpace.GetValue(const Path: TXRTLNameSpacePath): IXRTLValue;
var
  Entry: TXRTLNameSpaceEntry;
begin
  CheckPath(Path);
  Result:= nil;
  Entry:= GetNameSpaceEntry(Path, False);
  if Assigned(Entry) then
  begin
    Result:= Entry.Value;
  end;
end;

procedure TXRTLNameSpace.Remove(const Path: TXRTLNameSpacePath);
var
  Entry: TXRTLNameSpaceEntry;
begin
  CheckPath(Path);
  Entry:= GetNameSpaceEntry(Path, False);
  if Assigned(Entry) and Assigned(Entry.Parent) then
  begin
    Entry.Parent.SubItems.Remove(XRTLValue(Path[XRTLNameSpacePathGetLength(Path) - 1]));
  end;
end;

function TXRTLNameSpace.HasKey(const Path: TXRTLNameSpacePath): Boolean;
begin
  CheckPath(Path);
  Result:= Assigned(GetNameSpaceEntry(Path, False));
end;

function TXRTLNameSpace.GetNameSpaceEntry(const Path: TXRTLNameSpacePath; AutoCreate: Boolean = False): TXRTLNameSpaceEntry;
var
  LEntry: TXRTLNameSpaceEntry;
  I: Integer;
  EntryValue: IXRTLValue;
begin
  Result:= FRoot;
  for I:= 0 to XRTLNameSpacePathGetLength(Path) - 1 do
  begin
    EntryValue:= Result.SubItems.GetValue(XRTLValue(Path[I]));
    if Assigned(EntryValue) then
    begin
      XRTLGetAsObject(EntryValue, LEntry);
    end
    else
    begin
      if AutoCreate then
      begin
        LEntry:= TXRTLNameSpaceEntry.Create(Self, Result);
        Result.SubItems.SetValue(XRTLValue(Path[I]), XRTLValue(LEntry, True));
      end
      else
      begin
        Result:= nil;
        Exit;
      end;
    end;
    Result:= LEntry;
  end;
end;

procedure TXRTLNameSpace.CheckPath(const Path: TXRTLNameSpacePath);
begin
  if XRTLNameSpacePathGetLength(Path) = 0 then
    raise EXRTLInvalidNameSpacePath.Create('Invalid namespace path');
end;

function TXRTLNameSpace.CreateEnumerator(const RootPath: TXRTLNameSpacePath;
                                         EnumType: TXRTLNameSpaceEnumeratorType;
                                         const NameFilter: WideString = '*'): TXRTLNameSpaceEnumerator;
begin
  Result:= TXRTLNameSpaceEnumerator.Create(GetNameSpaceEntry(RootPath), EnumType, NameFilter);
end;

function TXRTLNameSpace.IsLeaf(const Path: TXRTLNameSpacePath): Boolean;
var
  LEntry: TXRTLNameSpaceEntry;
begin
  CheckPath(Path);
  Result:= False;
  LEntry:= GetNameSpaceEntry(Path, False);
  if Assigned(LEntry) then
  begin
    Result:= LEntry.FSubItems.IsEmpty;
  end;
end;

function TXRTLNameSpace.IsBranch(const Path: TXRTLNameSpacePath): Boolean;
var
  LEntry: TXRTLNameSpaceEntry;
begin
  CheckPath(Path);
  Result:= False;
  LEntry:= GetNameSpaceEntry(Path, False);
  if Assigned(LEntry) then
  begin
    Result:= not LEntry.FSubItems.IsEmpty;
  end;
end;

end.
