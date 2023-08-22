unit MaxDOMDictionary;

interface

uses
  Classes,
  INIFiles,
  MaxDOM;

var
  TAG_SYMBOLS: String = 'symbols';
  TAG_ITEMS: String = 'items';

  Prop_Name: String   = 'Name';
  Prop_Index: String  = 'HashIndex';
  Prop_Count: String  = 'Count';

type
  TDictionaryIterateProc = procedure(Item: INode;
    var Continue: Boolean);
  TDictionaryIterateProcEx = procedure(Item: INode; var AParam;
    var Continue: Boolean);

  THashFunction = function(const S: String): Cardinal;

  IDictionary = interface(INode)
  ['{4F461808-866A-40E6-95EF-184CE753405E}']
  // protected
    function GetItem(AKey: String): INode;
    function GetCount: Integer;
    function GetDuplicates: TDuplicates;
    function GetHashFunction: THashFunction;
    procedure SetHashFunction(AValue: THashFunction);
    function GetAsNode: INode;
    function GetAsString: String;
    function GetSymbols: INode;
    function GetItems: INode;
  // public
    function Find(const AKey: String): Boolean;
    function Contains(const AKey: String): Boolean;
    function Add(AnItem: INode): Boolean;
    function Delete(const AKey: String): Boolean;
    function Extract(const AKey: String): INode;
    procedure ForEach(AIteratorFn: TDictionaryIterateProc); overload;
    procedure ForEachEx(AIteratorFn: TDictionaryIterateProcEx; var AParam);
    procedure Clear;
  // public
    property Item[AKey: String]: INode read GetItem; default;
    property Count: Integer read GetCount;
    property Duplicates: TDuplicates read GetDuplicates;
    property HashFunction: THashFunction read GetHashFunction write SetHashFunction;
    property Symbols: INode read GetSymbols;
    property Items: INode read GetItems;
    property AsNode: INode read GetAsNode;
    property AsString: String read GetAsString;
  end;


  TDictionary = class(TNode, IDictionary)
  private
    FCount: Integer;
    FDuplicates: TDuplicates;
    FHashFunction: THashFunction;
  protected
    function Hash(const AKey: String): Integer; overload;
    function Hash(ANode: INode): Integer; overload;
    procedure ReallocateHashTable(ANewCapacity: Integer);
    function GetHashFunction: THashFunction;
    procedure SetHashFunction(AValue: THashFunction);
    function GetXML: String; override;
  protected
    function HashTable_GetDuplicates: TDuplicates;
    function HashTable_GetItem(AKey: String): INode;
    function HashTable_GetCount: Integer;
    function HashTable_Find(const AKey: String): Boolean;
    function HashTable_Add(AItem: INode): Boolean;
    function HashTable_Delete(const AKey: String): Boolean;
    function HashTable_Extract(const AKey: String): INode;
    function HashTable_GetSymbols: INode;
    function HashTable_GetItems: INode;
    function HashTable_GetAsNode: INode;
    function HashTable_GetAsString: String;
    procedure HashTable_ForEach(AIteratorProc: TDictionaryIterateProc);
    procedure HashTable_ForEachEx(AIteratorProc: TDictionaryIterateProcEx; var AParam);
  protected // IDictionary
    function IDictionary.GetDuplicates = HashTable_GetDuplicates;
    function IDictionary.GetItem       = HashTable_GetItem;
    function IDictionary.GetCount      = HashTable_GetCount;
    function IDictionary.Find          = HashTable_Find;
    function IDictionary.Contains      = HashTable_Find;
    function IDictionary.Add           = HashTable_Add;
    function IDictionary.Delete        = HashTable_Delete;
    function IDictionary.Extract       = HashTable_Extract;
    function IDictionary.GetSymbols    = HashTable_GetSymbols;
    function IDictionary.GetItems      = HashTable_GetItems;
    function IDictionary.GetAsNode     = HashTable_GetAsNode;
    function IDictionary.GetAsString   = HashTable_GetAsString;
    procedure IDictionary.ForEach      = HashTable_ForEach;
    procedure IDictionary.ForEachEx    = HashTable_ForEachEx;
  public
    constructor Create(const AName: String = 'Dictionary';
      ADuplicates: TDuplicates = dupError); reintroduce;
    destructor Destroy; override;
    procedure Clear; override;
  public
    property AsString: String read HashTable_GetAsString;
  end;



// Hash functions
function HashFast(const AKey: String): Cardinal;
function HashCarlos(const AKey: String): Cardinal;
function BorlandHashOf(const AKey: String): Cardinal;
function HashSumOfChars(const AKey: String): Cardinal;



implementation

uses
  SysUtils;


const
  Default_HashTableCapacity = 16;



function BorlandHashOf(const AKey: string): Cardinal;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(AKey) do
    Result := ((Result shl 2) or (Result shr (SizeOf(Result) * 8 - 2)))
      xor Ord(AKey[I]);
end;


function HashSumOfChars(const AKey: String): Cardinal;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(AKey) do begin
    Result := Result + Ord(AKey[I]);
  end;
end;


function HashCarlos(const AKey: String): Cardinal;
asm
  push  ESI
  push  EBX

  xor   EDX, EDX
  or    EAX, EAX
  jz    @Done
  mov   EBX, EDX
  mov   ECX, [EAX-4]
  jecxz @Done
  mov   ESI, EAX
  cld
@Next:
  xor   EAX, EAX
  lodsb
  shl   EDX, 4
  add   EDX, EAX
  mov   EBX, EDX
  and   EBX, $F000000
  jz    @L1
  shr   EBX, 24
  xor   EDX, EBX
@L1:
  not   EBX
  and   EDX, EBX
  dec   ECX
  jnz   @Next

@Done:
  mov   EAX, EDX

  pop   EBX
  pop   ESI
end;



{$R-,Q-}
function HashFast(const AKey: String): Cardinal;
type
  PCardinalArray = ^TCardinalArray;
  TCardinalArray = Array[0..$0fffffff] of Cardinal;
var
  a: Cardinal;
  b: Cardinal;
  c: Cardinal;
  k: PCardinalArray;
  LLength: Cardinal;
begin
  LLength := Length(AKey);
  a := $deadbeef + LLength;
  b := a;
  c := a;
  k := PCardinalArray(AKey);

  while LLength > 12 do begin
    a := a + k[0];
    b := b + k[1];
    c := c + k[2];

    //mix(a, b, c)
    Dec(a, c); a := a xor ((c shl  4) or (c shr (32 -  4))); Inc(c, b);
    Dec(b, a); b := b xor ((a shl  6) or (a shr (32 -  6))); Inc(a, c);
    Dec(c, b); c := c xor ((b shl  8) or (b shr (32 -  8))); Inc(b, a);
    Dec(a, c); a := a xor ((c shl 16) or (c shr (32 - 16))); Inc(c, b);
    Dec(b, a); b := b xor ((a shl 19) or (a shr (32 - 19))); Inc(a, c);
    Dec(c, b); c := c xor ((b shl  4) or (b shr (32 -  4))); Inc(b, a);

    Dec(LLength, 12);
    Inc(PCardinal(k), 3);
  end;

  case LLength of
    12 : begin c := c + k[2];             b := b + k[1]; a := a + k[0]; end;
    11 : begin c := c + k[2] and $ffffff; b := b + k[1]; a := a + k[0]; end;
    10 : begin c := c + k[2] and $ffff;   b := b + k[1]; a := a + k[0]; end;
     9 : begin c := c + k[2] and $ff;     b := b + k[1]; a := a + k[0]; end;
     8 : begin b := b + k[1];                            a := a + k[0]; end;
     7 : begin b := b + k[1] and $ffffff;                a := a + k[0]; end;
     6 : begin b := b + k[1] and $ffff;                  a := a + k[0]; end;
     5 : begin b := b + k[1] and $ff;                    a := a + k[0]; end;
     4 : begin a := a + k[0];             end;
     3 : begin a := a + k[0] and $ffffff; end;
     2 : begin a := a + k[0] and $ffff;   end;
     1 : begin a := a + k[0] and $ff;     end;
     0 : begin Result := c; Exit;         end;
  end;

  //final(a, b, c)
  c := c xor b; Dec(c, ((b shl 14) or (b shr (32 - 14))));
  a := a xor c; Dec(a, ((c shl 11) or (c shr (32 - 11))));
  b := b xor a; Dec(b, ((a shl 25) or (a shr (32 - 25))));
  c := c xor b; Dec(c, ((b shl 16) or (b shr (32 - 16))));
  a := a xor c; Dec(a, ((c shl  4) or (c shr (32 -  4))));
  b := b xor a; Dec(b, ((a shl 14) or (a shr (32 - 14))));
  c := c xor b; Dec(c, ((b shl 24) or (b shr (32 - 24))));

  Result := c;
end;
{$R+,Q+}





constructor TDictionary.Create;
begin
  inherited Create(AName);
  FDuplicates := ADuplicates;
  FHashFunction := HashFast; //HashCarlos;
  Clear;
end;



destructor TDictionary.Destroy;
begin
  inherited;
end;



function TDictionary.Hash(const AKey: String): Integer;
begin
  Result := Abs(FHashFunction(AKey));
end;


function TDictionary.Hash(ANode: INode): Integer;
begin
  Result := Abs(FHashFunction(ANode[Prop_Name]));
end;


procedure TDictionary.ReallocateHashTable;
var
  I, J: Integer;
  LItems: TInterfaceList;
  LHashSlot: INode;
begin
  LItems := TInterfaceList.Create;
  try
    for I := 0 to ChildCount - 1 do begin
      LHashSlot := ChildNodes[I];
      for J := 0 to LHashSlot.Children.Count - 1 do
        LItems.Add( LHashSlot.Children[J]);
    end;
    Node_Clear;
    for I := 0 to ANewCapacity - 1 do begin
      LHashSlot := NewNode('HashSlot');
      LHashSlot[Prop_Index] := IntToStr(I);
      Node_Add(LHashSlot);
    end;
    for I := 0 to LItems.Count - 1 do
      HashTable_Add(INode(LItems[I]));
  finally
    LItems.Free;
  end;
end;


function TDictionary.HashTable_Add(AItem: INode): Boolean;
var
  LKey: String;
  LSlotIndex: Integer;
  LHashSlot: INode;
  LItemIndex: Integer;
begin
  if AItem = nil then
    raise Exception.Create('Adding a nil item to Dictionary');
  if FCount > (ChildCount * 2) then
    ReallocateHashTable(ChildCount * 2);
  LKey := AItem[Prop_Name];
  LSlotIndex := Hash(AItem) mod ChildCount;
  if LSlotIndex < 0 then
    raise Exception.CreateFmt('Dictionary.Add with an invalid Key="%s"',[LKey]);
  LHashSlot := ChildNodes[LSlotIndex];
  if FDuplicates <> dupAccept then begin
    LItemIndex := LHashSlot.Children.IndexOfByAttr(Prop_Name,LKey);
    //// DEBUG
    if LItemIndex >= 0 then
      asm int 3 end;
    ////
    if LItemIndex >= 0 then begin
      if FDuplicates = dupError then
        raise Exception.CreateFmt('Duplicate key value "%s" in HashTable_Add',[LKey])
      else begin //dupIgnore
        Result := False;
        Exit;
      end;
    end;
  end;
  LHashSlot.Children.Add(AItem);
  Inc(FCount);
  Attr_SetValue(Prop_Count,IntToStr(FCount));
  Result := True;
end;


function TDictionary.HashTable_Delete(const AKey: String): Boolean;
begin
  Result := HashTable_Extract(AKey) <> nil;
end;


function TDictionary.HashTable_Extract(const AKey: String): INode;
var
  LSlotIndex: Integer;
  LSlot: INode;
  LItemIndex: Integer;
begin
  Result := nil;
  LSlotIndex := Hash(AKey) mod ChildCount;
  if (LSlotIndex < 0) then
    Exit;
  LSlot := FChildren[LSlotIndex];
  LItemIndex := LSlot.Children.IndexOfByAttr(Prop_Name,AKey);
  if LItemIndex < 0 then
    Exit;
  Result := LSlot.Children[LItemIndex];
  Dec(FCount);
  Attr_SetValue(Prop_Count,IntToStr(FCount));
  LSlot.Children.Delete(LItemIndex);
end;


procedure TDictionary.HashTable_ForEach(
  AIteratorProc: TDictionaryIterateProc);
var
  H, I: Integer;
  LHashSlot: INode;
  LItem: INode;
  LContinue: Boolean;
begin
  LContinue := True;
  for H := 0 to Children.Count-1 do begin
    LHashSlot := Children[H];
    for I := 0 to LHashSlot.Children.Count-1 do begin
      LItem := LHashSlot.Children[I];
      AIteratorProc(LItem,LContinue);
      if not LContinue then
        Exit;
    end;
  end;
end;


procedure TDictionary.HashTable_ForEachEx(
  AIteratorProc: TDictionaryIterateProcEx; var AParam);
var
  H, I: Integer;
  LHashSlot: INode;
  LItem: INode;
  LContinue: Boolean;
begin
  LContinue := True;
  for H := 0 to Children.Count-1 do begin
    LHashSlot := Children[H];
    for I := 0 to LHashSlot.Children.Count-1 do begin
      LItem := LHashSlot.Children[I];
      AIteratorProc(LItem,AParam,LContinue);
      if not LContinue then
        Exit;
    end;
  end;
end;


function TDictionary.HashTable_GetCount: Integer;
begin
  Result := FCount;
end;



function TDictionary.HashTable_GetItem(AKey: String): INode;
var
  LSlotIndex: Integer;
  LSlot: INode;
  LItemIndex: Integer;
begin
  Result := nil;
  LSlotIndex := Hash(AKey) mod ChildCount;
  if (LSlotIndex < 0) then
    Exit;
  LSlot := FChildren[LSlotIndex];
  LItemIndex := LSlot.Children.IndexOfByAttr(Prop_Name,AKey);
  if LItemIndex < 0 then
    Exit;
  Result := LSlot.Children[LItemIndex];
end;


function TDictionary.HashTable_Find(const AKey: String): Boolean;
var
  LSlotIndex: Integer;
  LSlot: INode;
  LItemIndex: Integer;
begin
  Result := False;
  LSlotIndex := Hash(AKey) mod ChildCount;
  if LSlotIndex < 0 then
    Exit;
  LSlot := FChildren[LSlotIndex];
  LItemIndex := LSlot.Children.IndexOfByAttr(Prop_Name,AKey);
  Result := LItemIndex >= 0;
end;


procedure TDictionary.Clear;
begin
  inherited;
  ReallocateHashTable(Default_HashTableCapacity);
  FCount := 0;
end;


function TDictionary.HashTable_GetDuplicates: TDuplicates;
begin
  Result := FDuplicates;
end;


function TDictionary.GetHashFunction: THashFunction;
begin
  Result := FHashFunction;
end;


procedure TDictionary.SetHashFunction(AValue: THashFunction);
begin
  FHashFunction := AValue;
end;



function TDictionary.HashTable_GetSymbols: INode;
//TODO: Recode using ForEach
var
  H, I: Integer;
  LHashSlot: INode;
  LItem: INode;
begin
  Result := NewNode(TAG_SYMBOLS);
  Result.MergeAttrs(Self);
  for H := 0 to Children.Count-1 do begin
    LHashSlot := Children[H];
    for I := 0 to LHashSlot.Children.Count-1 do begin
      LItem := LHashSlot.Children[I];
      Result.Children.Add(LItem);
    end;
  end;
  Result.Children.Sort(CompareByNameAttr);
  Result[Prop_Count] := IntToStr(Result.Children.Count);
end;



function TDictionary.HashTable_GetItems: INode;
//TODO: Recode using ForEach
var
  H, I: Integer;
  LHashSlot: INode;
  LItem: INode;
begin
  Result := NewNode(TAG_ITEMS);
  Result.MergeAttrs(Self);
  for H := 0 to Children.Count-1 do begin
    LHashSlot := Children[H];
    for I := 0 to LHashSlot.Children.Count-1 do begin
      LItem := LHashSlot.Children[I];
      Result.Children.Add(LItem.Children.First);
    end;
  end;
  Result[Prop_Count] := IntToStr(Result.Children.Count);
end;



function TDictionary.HashTable_GetAsNode: INode;
begin
  Result := Self as INode;
end;



function TDictionary.GetXML: String;
begin
  Result := HashTable_GetSymbols.XML;
end;


function TDictionary.HashTable_GetAsString: String;
var
  LSymbols: INode;
  I: Integer;
  LKey: INode;
begin
  LSymbols := HashTable_GetSymbols;
  Result := '';
  for I := 0 to LSymbols.Children.Count-1 do begin
    LKey := LSymbols.Children[I];
    if I > 0 then
      Result := Result + #13#10;
    Result := Result + LKey.Name;
  end;
end;





end.
