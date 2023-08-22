unit MaxDOM;

{
Universal "Node" for DOM-like in-memory structures.
By Andrew J. Wozniewicz, Carlos E. Galavis
Copyright (C) 1999, 2007 Andrew J. Wozniewicz   havt to change again XMLIntf

pass tnode to tnode2
}

interface

uses
  Windows,
  SysUtils,
  Classes;


var
  Attr_Name: String = 'Name';
  Attr_ID: String = 'ID';

//// INTERFACES
type
  TNodeType = (ntElement, ntText, ntCDATA, ntComment);

  INode = interface;
  IAttribute = interface;
  IAttributeCollection = interface;
  INodeCollection = interface;

  INode = interface
    ['{70E4F7FB-01D5-41D4-94FF-B96DAB9ADC77}']
    function GetNodeType: TNodeType;
    function GetNodeName: String;
    procedure SetNodeName(const AValue: String);
    function GetName: String;
    procedure SetName(const AValue: String);
    function GetID: String;
    procedure SetID(const AValue: String);
    function GetText: String;
    procedure SetText(const AValue: String);
    function GetAttrValue(AName: String): String;
    procedure SetAttrValue(AName: String; const Value: String);
    function GetAttributes: IAttributeCollection;
    function GetChildren: INodeCollection;
    function GetData: Pointer;
    function GetXML: String;
    procedure SetData(AValue: Pointer);
    //
    property NodeType: TNodeType read GetNodeType;
    property NodeName: String read GetNodeName write SetNodeName;
    property Name: String read GetName write SetName;
    property ID: String read GetID write SetID;
    property Text: String read GetText write SetText;
    property Children: INodeCollection read GetChildren;
    property Attributes: IAttributeCollection read GetAttributes;
    property Data: Pointer read GetData write SetData;
    property AttrValue[Name: String]: String
      read GetAttrValue write SetAttrValue; default;
    property XML: String read GetXML;
    //
    procedure Clear;
    function HasAttribute(const AName: String): Boolean;
    function HasNode(const AName: String): Boolean;
    procedure Assign(ANode: INode; ADeep: Boolean = True);
    function Clone(ADeep: Boolean = True): INode;
    procedure MergeAttrs(ANode: INode; AReplaceExisting: Boolean = True);
    function FindAttribute(AName: String): IAttribute;
    function FindNode(const AName: String): INode;
    function Instance: Pointer;
  end;


  IAttribute = interface
    ['{1CD19B23-D1DF-4BF9-A9D6-6047A96D6068}']
    procedure SetName(const AValue: String);
    function GetName: String;
    procedure SetValue(const AValue: String);
    function GetValue: String;
    procedure SetData(AData: Pointer);
    function GetData: Pointer;
    //
    property Name: String read GetName write SetName;
    property Value: String read GetValue write SetValue;
    property Data: Pointer read GetData write SetData;
  end;


  IAttributeCollection = interface
    ['{38D18047-639C-404B-B365-2D8722267472}']
    function GetValue(AName: String): String;
    function GetCount: Integer;
    procedure SetValue(AName: String; const AValue: String);
    function GetItem(AnIndex: Integer): IAttribute;
    //
    property Item[Index: Integer]: IAttribute read GetItem; default;
    property Value[Name: String]: String read GetValue write SetValue;
    property Count: Integer read GetCount;
    //
    function AddNew(const AName, AValue: String): IAttribute;
    function Add(AnAttr: IAttribute): Integer;
    procedure Insert(AnIndex: Integer; AnAttr: IAttribute);
    function InsertNew(AnIndex: Integer; const AName, AValue: String): IAttribute;
    function AddSafe(AnAttr: IAttribute): Integer;
    procedure Delete(const AName: String);
    procedure Clear;
    function Rename(const OldName, NewName: String): Boolean;
    function Find(const AName: String): IAttribute;
  end;


  TSortCompareFN = function(N1, N2: INode): Integer;

  INodeCollection = interface
    ['{AFC4D9FC-1930-4C33-A0F2-939814AE44ED}']
    //
    function GetItem(AIndex: Integer): INode;
    function GetCount: Integer;
    procedure SetItem(AItend: Integer; AValue: INode);
    function AddNew(const AName: String; AType: TNodeType = ntElement): INode;
    function InsertNew(AIndex: Integer; const AName: String; AType: TNodeType = ntElement): INode;
    function EnsureElement(AName: String; ANodeClass: TClass = nil): INode;
    function Add(ANode: INode): Integer;
    function ReplaceWith(ANode: INode): Integer; //Clear+Add
    function AddSafe(ANode: INode): Integer;
    procedure Insert(AIndex: Integer; ANode: INode);
    procedure AppendChildren(ANode: INode; ACloneChildren: Boolean = False);
    procedure Delete(AIndex: Integer);
    procedure Remove(ANode: INode);
    function Extract(AIndex: Integer): INode;
    procedure Move(AIndex, ANewIndex: Integer);
    procedure Swap(AIndex, ANewIndex: Integer);
    procedure Clear;
    procedure Sort(ACompareFn: TSortCompareFn = nil);
    function IndexOf(const AName: String): Integer;
    function IndexOfByAttr(const AAttrName, AAttrValue: String;
      CaseSensitive: Boolean = False): Integer;
    function FindByAttr(const AAttrName, AAttrValue: String;
      CaseSensitive: Boolean = False): INode;
    function GetFirstChild: INode;
    function GetSecondChild: INode;
    function GetLastChild: INode;
    //
    property Item[Index: Integer]: INode read GetItem write SetItem; default;
    property Count: Integer read GetCount;
    property First: INode read GetFirstChild;
    property Second: INode read GetSecondChild;
    property Last: INode read GetLastChild;
  end;


  TNodeFactoryProc = function(const ANodeName: String = 'new';
    ANodeType: TNodeType = ntElement): INode;

  function NodeCreate(const ANodeName: String = 'new';
    ANodeType: TNodeType = ntElement): INode;


///// CLASSES
type
  TFindProc = function (ANode: INode; const AValue: AnsiString): Integer;

  TAttribute = class(TInterfacedObject, IAttribute)
  private
    function GetAsString: String;
  protected
    FName:            String;
    FValue:           String;
    FData:            Pointer;
  protected
    function GetName: String;
    function GetValue: String;
    function GetData: Pointer;
    procedure SetValue(const AValue: String);
    procedure SetName(const AValue: String);
    procedure SetData(AData: Pointer);
  public
    property Name: String read fName write SetName;
    property Value: String read fValue write fValue;
    property Data: Pointer read fData write fData;
    property AsString: String read GetAsString;
  end;

  TNodes = array of INode;
  TAttributes = array of IAttribute;

  THashedAttributes = record
    Attributes:   TAttributes;
    AttrCount:    Integer;
    AttrCapacity: Integer;
  end;

  TAttrHashTable = array of THashedAttributes;

  TNode = class(TInterfacedObject, INode, IAttributeCollection, INodeCollection)
  public
    FNodeType:            TNodeType;
    FNodeName:            String;    // Node "name",  as opposed to Name-attribute.
    FText:                String;    // Node's text.
    FAttributes:          TAttributes;  // Array of Attributes found in the element.
    FAttrHashTable:       TAttrHashTable; // Array of Attributes used as a hash table.
    FAttrHashSize:        Cardinal;  // Number of hash table slots
    FAttrCapacity:        Integer;   // Number of Attributes the node may have before a reallocation takes place.
    FAttrCount:           Integer;   // Number of Attributes found in the element.
    FChildren:            TNodes;    // Array of child nodes.
    FChildCapacity:       Integer;   // Number of children the node may have before a reallocation takes place.
    FChildCount:          Integer;   // Number of child nodes.
    FData:                Pointer;   // Arbitrary, user-defined.
  protected
    property Data: Pointer read FData write FData;
  protected
    function CreateChildInstance(const AName: String = 'new'): INode; virtual;
    function GetNodeType: TNodeType; virtual;
    function GetNodeName: String; virtual;
    function GetName: String; virtual;
    function GetID: String; virtual;
    function GetText: String; virtual;
    function GetAttrValue(AName: String): String; virtual;
    function GetAttributesAsText: String; virtual;
    function GetData: Pointer; virtual;
    function GetXML: String; virtual;
    function GetAttributeCol: IAttributeCollection; virtual;
    function GetChildCol: INodeCollection; virtual;

    procedure SetNodeName(const AValue: String); virtual;
    procedure SetName(const AValue: String); virtual;
    procedure SetID(const AValue: String); virtual;
    procedure SetText(const AValue: String); virtual;
    procedure SetAttrValue(AName: String; const AValue: String); virtual;
    procedure SetAttributesAsText(const AValue: String); virtual;
    procedure SetData(AValue: Pointer); virtual;

    function HasAttribute(const AName: String): Boolean; virtual;
    function HasNode(const AName: String): Boolean; virtual;
    function FindAttribute(AName: String): IAttribute; virtual;
    function FindNode(const AName: String): INode; virtual;
    procedure Assign(ANode: INode; ADeep: Boolean = True);
    function Clone(ADeep: Boolean = True): INode; virtual;
    procedure MergeAttrs(ANode: INode; AReplaceExisting: Boolean = True); virtual;
    procedure IntersectAttrs(ANode: INode); virtual;
    procedure Clear; virtual;

    //INode
    function GetAttributes: IAttributeCollection; virtual;
    function GetChildren: INodeCollection; virtual;

    //IAttributeCollection
    procedure Attr_ForceNew(const AName, AValue: String; AData: Pointer); virtual;
    function Attr_New(const AName, AValue: String): TAttribute; virtual;
    function Attr_IndexOf(const AName: String): Integer; virtual;
    procedure Attr_IncrementArray; virtual;
    procedure Attr_InsertArray(AnIndex: Integer); virtual;
    procedure Attr_ShiftArray(AnIndex: Integer); virtual;
    procedure Attr_IncrementHashArray(var AHash: THashedAttributes); virtual;
    function Attr_AddNew(const AName, AValue: String): IAttribute; virtual;
    function Attr_Add(AAttr: IAttribute): Integer; virtual;
    procedure Attr_Insert(AnIndex: Integer; AAttr: IAttribute); virtual;
    function Attr_InsertNew(AnIndex: Integer; const AName, AValue: String): IAttribute; virtual;
    function Attr_AddSafe(AAttr: IAttribute): Integer; virtual;
    procedure Attr_AddToHash(AAttr: IAttribute); virtual;
    procedure Attr_Delete(const AName: String); virtual;
    procedure Attr_DeleteFromHash(const AName: String); virtual;
    procedure Attr_Clear; virtual;
    function Attr_FindInHash(const AName: String): IAttribute; virtual;
    function Attr_FindLinear(const AName: String): IAttribute; virtual;
    function Attr_Find(const AName: String): IAttribute; virtual;
    function Attr_GetItem(AIndex: Integer): IAttribute; virtual;
    function Attr_GetCount: Integer; virtual;
    function Attr_GetValue(AName: String): String; virtual;
    procedure Attr_SetValue(AName: String; const AValue: String); virtual;
    function Attr_Rename(const OldName, NewName: String): Boolean; virtual;
    { -- End of IAttributeCollection }

    { -- INodeCollection }
    function Node_New(const AName: String; AType: TNodeType = ntElement): INode; virtual;
    function Node_InsertNew(AIndex: Integer; const AName: String; AType: TNodeType = ntElement): INode; virtual;
    procedure Node_IncrementArray; virtual;
    function Node_AddNew(const AName: String; AType: TNodeType = ntElement): INode; virtual;
    function Node_EnsureElement(AName: String; ANodeClass: TClass = nil): INode; virtual;
    function Node_Add(ANode: INode): Integer; virtual;
    function Node_ReplaceWith(ANode: INode): Integer; virtual;
    function Node_AddSafe(ANode: INode): Integer; virtual;
    function Node_AddToArray(ANode: INode): Integer; virtual;
    procedure Node_Insert(AIndex: Integer; ANode: INode); virtual;
    procedure Node_InsertInArray(ANode: INode; AIndex: Integer); virtual;
    procedure Node_AppendChildren(ANode: INode; ACloneChildren: Boolean = False); virtual;
    procedure Node_Delete(AIndex: Integer); virtual;
    procedure Node_Remove(ANode: INode); virtual;
    function Node_Extract(AIndex: Integer): INode; virtual;
    procedure Node_Move(AIndex, ANewIndex: Integer); virtual;
    procedure Node_Swap(AIndex, ANewIndex: Integer); virtual;
    procedure Node_Clear; virtual;
    procedure Node_Sort(ACompareFn: TSortCompareFn = nil); virtual;
    function Node_GetItem(AIndex: Integer): INode; virtual;
    function Node_GetCount: Integer; virtual;
    procedure Node_SetItem(AIndex: Integer; AValue: INode); virtual;
    function Node_IndexOf(const AName: AnsiString): Integer; virtual;
    function Find(const AValue: String; AFindProc: TFindProc): INode; virtual;
    function Node_IndexOfByAttr(const AAttrName, AAttrValue: String;
      CaseSensitive: Boolean = True): Integer; virtual;
    function Node_FindByAttr(const AAttrName, AAttrValue: String;
      CaseSensitive: Boolean = True): INode; virtual;
    function Node_GetFirstChild: INode;
    function Node_GetSecondChild: INode;
    function Node_GetLastChild: INode;
  public
    constructor Create(const AName: String = 'new'; aNodeType: TNodeType = ntElement); virtual;
    destructor Destroy; override;
    function Instance: Pointer; virtual;
  public
    property AttrValue[AName: String]: String
      read Attr_GetValue write Attr_SetValue; default;

    property ChildCount: Integer read FChildCount;
    property ChildNodes: TNodes read FChildren;

    property NodeName: String read FNodeName write FNodeName;
    property Name: String read GetName write SetName;
    property ID: String read GetID write SetID;
    property Children: INodeCollection read GetChildren;
    property Attributes: IAttributeCollection read GetAttributes;
    property XML: String read GetXML;

  protected //IAttributeCOllection
    function IAttributeCollection.AddNew     = Attr_AddNew;
    function IAttributeCollection.Add        = Attr_Add;
    procedure IAttributeCollection.Insert    = Attr_Insert;
    function IAttributeCollection.InsertNew  = Attr_InsertNew;
    function IAttributeCollection.AddSafe    = Attr_AddSafe;
    procedure IAttributeCollection.Delete    = Attr_Delete;
    procedure IAttributeCollection.Clear     = Attr_Clear;
    function IAttributeCollection.GetItem    = Attr_GetItem;
    function IAttributeCollection.GetCount   = Attr_GetCount;
    function IAttributeCollection.GetValue   = Attr_GetValue;
    procedure IAttributeCollection.SetValue  = Attr_SetValue;
    function IAttributeCollection.Rename     = Attr_Rename;
    function IAttributeCollection.Find       = Attr_Find;
  protected //INodeCollection
    function INodeCollection.AddNew          = Node_AddNew;
    function INodeCollection.InsertNew       = Node_InsertNew;
    function INodeCollection.EnsureElement   = Node_EnsureElement;
    function INodeCollection.Add             = Node_Add;
    function INodeCollection.ReplaceWith     = Node_ReplaceWith;
    function INodeCollection.AddSafe         = Node_AddSafe;
    procedure INodeCollection.AppendChildren = Node_AppendChildren;
    procedure INodeCollection.Insert         = Node_Insert;
    procedure INodeCollection.Delete         = Node_Delete;
    procedure INodeCollection.Remove         = Node_Remove;
    function INodeCollection.Extract         = Node_Extract;
    procedure INodeCollection.Move           = Node_Move;
    procedure INodeCollection.Swap           = Node_Swap;
    procedure INodeCollection.Clear          = Node_Clear;
    procedure INodeCollection.Sort           = Node_Sort;
    function INodeCollection.GetItem         = Node_GetItem;
    function INodeCollection.GetCount        = Node_GetCount;
    function INodeCollection.GetFirstChild   = Node_GetFirstChild;
    function INodeCollection.GetSecondChild  = Node_GetSecondChild;
    function INodeCollection.GetLastChild    = Node_GetLastChild;
    procedure INodeCollection.SetItem        = Node_SetItem;
    function INodeCollection.IndexOf         = Node_IndexOf;
    function INodeCollection.IndexOfByAttr   = Node_IndexOfByAttr;
    function INodeCollection.FindByAttr      = Node_FindByAttr;
  end;


  TNodeClass = class of TNode;
  TAttributeClass = class of TAttribute;







var
  GAttributeClass: TAttributeClass = TAttribute;
  //GNodeClass: TNodeClass = TNode;

var
  GNodesCreated: Cardinal = 0;
  GNodesExisting: Cardinal = 0;




function PointerToStr(P: Pointer): String;
function StrToPointer(const S: String): Pointer;
function INodeToStr(ANode: INode): String;
function StrToINode(const S: String): INode;

function CompareByNodeName(N1, N2: INode): Integer;
function CompareByNameAttr(N1, N2: INode): Integer;



var
  NewNode: TNodeFactoryProc = NodeCreate;
  DefaultCompareFn: TSortCompareFn = CompareByNameAttr;


implementation

uses
  MaxXMLUtils;


const
  DefaultAttrHashSize  = 20;



function CompareByNodeName(N1, N2: INode): Integer;
begin
  Result := CompareStr(N1.NodeName, N2.NodeName);
end;


function CompareByNameAttr(N1, N2: INode): Integer;
begin
  Result := CompareStr(N1.Name, N2.Name);
end;


function PointerToStr(P: Pointer): String;
begin
  Result := Format('%.8x',[Integer(P)]);
end;


function StrToPointer(const S: String): Pointer;
begin
  Result := Pointer(StrToIntDef('$'+S,0));
end;


function INodeToStr(ANode: INode): String;
begin
  if ANode <> nil then
    Result := Format('%.8x',[Integer(ANode.Instance)])
  else
    Result := '';
end;


function StrToINode(const S: String): INode;
var
  LAddr: TNode;
begin
  LAddr := Pointer(StrToIntDef('$'+S,0));
  Result := LAddr as INode;
end;


function NodeCreate(const ANodeName: String; ANodeType: TNodeType): INode;
begin
  Result := TNode.Create(ANodeName,ANodeType);
end;




{ TAttribute }


procedure TAttribute.SetName(const AValue: String);
begin
  if ValidXMLName(AValue) then
    fName := AValue
  else
    raise Exception.CreateFmt('Invalid attribute name', [AValue]);
end;



function TAttribute.GetData: Pointer;
begin
  Result := FData;
end;

function TAttribute.GetName: String;
begin
  Result := FName;
end;


function TAttribute.GetValue: String;
begin
  Result := FValue;
end;

procedure TAttribute.SetData(AData: Pointer);
begin
  FData := AData;
end;

procedure TAttribute.SetValue(const AValue: String);
begin
  FValue := AValue;
end;


function TAttribute.GetAsString: String;
var
  LLen: Integer;
  LOffset: Integer;
begin
  LLen := Length(FName)+Length(FValue)+2;
  SetLength(Result,LLen);
  LOffset := 0;
  AttrFillXMLString(Self,Result,LOffset,LLen);
end;



{ TNode }

constructor TNode.Create(const AName: String = 'new'; aNodeType: TNodeType = ntElement);
begin
  inherited Create;
  FNodeName := AName;
  FAttrHashSize := DefaultAttrHashSize;
  Inc(GNodesCreated);
  Inc(GNodesExisting);
end;


destructor TNode.Destroy;
begin
  Clear;
  inherited;
  Dec(GNodesExisting);
end;



procedure TNode.Clear;
begin
  Attr_Clear;
  Node_Clear;
  FData := nil;
end;


function TNode.CreateChildInstance(const AName: String): INode;
begin
  Result:= NewNode(AName);
end;


function TNode.GetNodeName: String;
begin
  Result := FNodeName;
end;



function TNode.GetAttrValue(AName: String): String;
var
  LAttr: IAttribute;
begin
  LAttr := Attr_Find(AName);
  if Assigned(LAttr) then
    Result := LAttr.Value
  else
    Result := '';
end;


function TNode.GetAttributesAsText: String;
var
  i: Integer;
begin
  Result := '';
  for i:=0 to fAttrCount - 1 do
    Result := Result + fAttributes[i].Name + '=' + fAttributes[i].Value + #13#10;
end;


function TNode.HasAttribute(const AName: String): Boolean;
begin
  Result := (Attr_FindInHash(AName) <> nil);
end;


function TNode.HasNode(const AName: String): Boolean;
var
  i: Integer;
begin
  for i:=0 to fChildCount - 1 do begin
    if fChildren[i].NodeName = AName then begin
      Result := True;
      Exit;
    end;
  end;

  Result := False;
end;


function TNode.FindAttribute(AName: String): IAttribute;
begin
  Result := Attr_FindInHash(AName);
end;


function TNode.FindNode(const AName: String): INode;
var
  LIndex: Integer;
begin
  LIndex := Node_IndexOf(AName);
  if LIndex >= 0 then
    Result := FChildren[LIndex]
  else
    Result := nil;
end;


procedure TNode.Assign(ANode: INode; ADeep: Boolean);
var
  I: Integer;
begin
  Clear;
  FData := ANode.Data;
  FNodeName := ANode.NodeName;

  SetLength(fAttributes, ANode.Attributes.Count);
  for i:=0 to ANode.Attributes.Count - 1 do
    Attr_ForceNew(ANode.Attributes[i].Name, ANode.Attributes[i].Value, ANode.Attributes[i].Data);

  if ADeep then begin
    fChildCount := ANode.Children.Count;
    fChildCapacity := fChildCount;
    SetLength(fChildren, fChildCapacity);
    for i:=0 to ANode.Children.Count - 1 do begin
      FChildren[i] := CreateChildInstance;
      FChildren[I].Assign(ANode.Children[i]);
    end;
  end;

end;


function TNode.Clone(ADeep: Boolean): INode;
begin
  Result := NewNode;
  Result.Assign(Self, ADeep);
end;


procedure TNode.MergeAttrs(ANode: INode; AReplaceExisting: Boolean);
var
  I: Integer;
  LIndex: Integer;
begin
  if ANode = nil then
    Exit;
  if AReplaceExisting then
    for i:=0 to ANode.Attributes.Count - 1  do begin
      lIndex := Attr_IndexOf(ANode.Attributes[i].Name);
      if lIndex >= 0 then
        fAttributes[lIndex].Value := ANode.Attributes[i].Value
      else
        Attr_AddNew(ANode.Attributes[i].Name, ANode.Attributes[i].Value);
    end
  else
    for i:=0 to ANode.Attributes.Count - 1  do begin
      lIndex := Attr_IndexOf(ANode.Attributes[i].Name);
      if lIndex = -1 then
        Attr_AddNew(ANode.Attributes[i].Name, ANode.Attributes[i].Value);
    end;
end;


procedure TNode.IntersectAttrs(ANode: INode);
var
  I: Integer;
  LIndex: Integer;
begin
  for i:=0 to ANode.Attributes.Count - 1  do begin
    LIndex := Attr_IndexOf(ANode.Attributes[i].Name);
    if LIndex >= 0 then
      FAttributes[lIndex].Value := ANode.Attributes[I].Value;
  end;
end;


procedure TNode.SetNodeName(const AValue: String);
begin
  if ValidXMLName(AValue) then
    FNodeName := AValue
  else
    raise Exception.CreateFmt('Invalid node name "%s"', [AValue]);
end;



procedure TNode.SetAttrValue(AName: String; const AValue: String);
var
  LAttr: IAttribute;
begin
  LAttr := Attr_Find(AName);
  if LAttr <> nil then begin
    LAttr.Value := AValue;
    //Empty attributes are deliberately allowed
  end else if AValue <> '' then
    GetAttributeCol.AddNew(AName, AValue);
end;


procedure TNode.SetAttributesAsText(const AValue: String);
var
  P, Start: PChar;
  S: String;

  procedure AddAttribute;
  var
    lPos: Integer;
  begin
    lPos := Pos('=', S);
    if lPos > 0 then
      GetAttributeCol.AddNew(Copy(S, 1, lPos - 1), Copy(S, lPos + 1, MaxInt))
    else
      GetAttributeCol.AddNew(S, '');
  end;

begin
  GetAttributeCol.Clear;
  P := PChar(AValue);
  if P <> nil then
    while P^ <> #0 do begin
      Start := P;
      while not (P^ in [#0, #10, #13]) do
        Inc(P);
      SetString(S, Start, P - Start);
      AddAttribute;

      if P^ = #13 then
        Inc(P);
      if P^ = #10 then
        Inc(P);
    end;
end;

function TNode.GetAttributeCol: IAttributeCollection;
begin
  Result := Self;
end;

function TNode.GetChildCol: INodeCollection;
begin
  Result := Self;
end;


function TNode.GetData: Pointer;
begin
  Result := fData;
end;


function TNode.GetXML: String;
const
  cDefaultBufferSize  = $100;
var
  lOffset: Integer;
  lLen: Integer;
begin
  SetLength(Result, cDefaultBufferSize);
  lOffset := 1;
  lLen := 0;
  FillXMLString(Self, Result, lOffset, lLen, nil, 0);
  SetLength(Result, lOffset - 1);
end;



procedure TNode.SetData(AValue: Pointer);
begin
  fData := AValue;
end;



{ TAttributeCollection }

procedure TNode.Attr_ForceNew(const AName, AValue: String; AData: Pointer);
var
  lNewAttr: TAttribute;
begin
  lNewAttr        := GAttributeClass.Create;
  lNewAttr.fName  := AName;
  lNewAttr.fValue := AValue;
  lNewAttr.fData  := AData;
  Attr_Add(lNewAttr);
end;


function TNode.Attr_New(const AName, AValue: String): TAttribute;
begin
  if not ValidXMLName(AName) then
    raise Exception.CreateFmt('The attribute name is invalid: "%s"', [AName]);
  Result := GAttributeClass.Create;
  Result.fName := AName;
  Result.fValue := AValue;
end;


function TNode.Attr_AddNew(const AName, AValue: String): IAttribute;
begin
  Result := Attr_New(AName, AValue);
  Attr_Add(Result);
end;



function TNode.Attr_InsertNew(AnIndex: Integer; const AName,
  AValue: String): IAttribute;
begin
  Result := Attr_New(AName, AValue);
  Attr_Insert(AnIndex,Result);
end;



function TNode.Attr_Rename(const OldName, NewName: String): Boolean;
var
  LAttr: IAttribute;
begin
  Result := False;
  LAttr := Attr_FindInHash(OldName);
  if LAttr = nil then
    Exit;
  Attr_Delete(OldName);
  try
    LAttr.Name := NewName;
    Attr_Add(LAttr);
    Result := True;
  except
    LAttr.Name := OldName;
    Attr_Add(LAttr);
  end;
end;




procedure TNode.Attr_IncrementArray;
begin
  Inc(FAttrCount);
  if fAttrCapacity = 0 then begin
    fAttrCapacity := fAttrCount;
    SetLength(fAttributes,fAttrCapacity);
  end
  else if fAttrCount > fAttrCapacity then begin
    fAttrCapacity := fAttrCapacity * 2;
    SetLength(fAttributes,fAttrCapacity);
  end;
end;



procedure TNode.Attr_InsertArray(AnIndex: Integer);
begin
  Attr_IncrementArray;
  Attr_ShiftArray(AnIndex);
end;



procedure TNode.Attr_ShiftArray(AnIndex: Integer);
var
  I: Integer;
begin
  for I := FAttrCount-2 downto AnIndex do
    FAttributes[I+1] := FAttributes[I];
end;




function TNode.Attr_IndexOf(const AName: AnsiString): Integer;
var
  I: Integer;
begin
  Assert(AName <> '');
  for  I := 0 to FAttrCount - 1 do begin
    if FAttributes[I].Name = AName then begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;



procedure TNode.Attr_IncrementHashArray(
  var AHash: THashedAttributes);
begin
  with AHash do begin
    Inc(AttrCount);
    if AttrCapacity = 0 then begin
      AttrCapacity := AttrCount;
      SetLength(Attributes, AttrCapacity);
    end
    else if AttrCount > AttrCapacity then begin
      AttrCapacity := AttrCapacity * 2;
      SetLength(Attributes, AttrCapacity);
    end;
  end;
end;



function TNode.Attr_Add(AAttr: IAttribute): Integer;
begin
  if not Assigned(AAttr) then
    raise Exception.Create('Attempt to add a nil attribute');
  if HasAttribute(AAttr.Name) then
    raise Exception.CreateFmt('Attribute already exists "%s"', [AAttr.Name]);
  Attr_IncrementArray;
  Result := FAttrCount - 1;
  FAttributes[Result] := AAttr;
  Attr_AddToHash(AAttr);
end;



procedure TNode.Attr_Insert(AnIndex: Integer; AAttr: IAttribute);
begin
  if not Assigned(AAttr) then
    raise Exception.Create('Attempt to add a nil attribute');
  if HasAttribute(AAttr.Name) then
    raise Exception.CreateFmt('Attribute already exists "%s"', [AAttr.Name]);
  Attr_InsertArray(AnIndex);
  FAttributes[AnIndex] := AAttr;
  Attr_AddToHash(AAttr);
end;



procedure TNode.Attr_AddToHash(AAttr: IAttribute);
var
  LHashIndex: Cardinal;
  LSlotIndex: Integer;
begin
  if Cardinal(Length(FAttrHashTable)) < FAttrHashSize then begin
    SetLength(FAttrHashTable, FAttrHashSize);
    FillChar(FAttrHashTable[0], FAttrHashSize * SizeOf(THashedAttributes), 0);
  end;
  LHashIndex := Abs(Hash(AAttr.Name) mod FAttrHashSize);
  Attr_IncrementHashArray(FAttrHashTable[lHashIndex]);
  LSlotIndex := FAttrHashTable[LHashIndex].AttrCount - 1;
  FAttrHashTable[LHashIndex].Attributes[LSlotIndex] := AAttr;
end;


procedure TNode.Attr_Clear;
var
  i: Integer;
begin
  if Length(fAttrHashTable) > 0 then begin
    for i:=0 to fAttrHashSize - 1 do begin
      fAttrHashTable[i].AttrCount := 0;
      fAttrHashTable[i].AttrCapacity := 0;
      SetLength(fAttrHashTable[i].Attributes, 0);
    end;
  end;
  for i:=0 to fAttrCount - 1 do
    FAttributes[i] := nil;
  fAttrCount := 0;
  fAttrCapacity := 0;
  SetLength(fAttributes, 0);
end;


function TNode.Attr_FindInHash(const AName: String): IAttribute;
var
  LHashIndex: Integer;
  I: Integer;
begin
  Assert(AName <> '');
  if Length(FAttrHashTable) > 0 then begin
    LHashIndex := Abs(Hash(AName) mod FAttrHashSize);
    for I := 0 to FAttrHashTable[LHashIndex].AttrCount - 1 do
      if FAttrHashTable[LHashIndex].Attributes[i].Name = AName then begin
        Result := FAttrHashTable[LHashIndex].Attributes[i];
        Exit;
      end;
  end;
  Result := nil;
end;


function TNode.Attr_FindLinear(const AName: String): IAttribute;
var
  I: Integer;
begin
  Assert(AName <> '');
  for  I := 0 to FAttrCount - 1 do begin
    if FAttributes[I].Name = AName then begin
      Result := FAttributes[I];
      Exit;
    end;
  end;
  Result := nil;
end;



function TNode.Attr_Find(const AName: String): IAttribute;
begin
  Result := Attr_FindInHash(AName);
  //Result := Attr_FindLinear(AName);
end;


function TNode.Attr_GetItem(AIndex: Integer): IAttribute;
begin
  Result := FAttributes[AIndex];
end;


function TNode.Attr_GetCount: Integer;
begin
  Result := fAttrCount;
end;


function TNode.Attr_GetValue(AName: String): String;
begin
  Result := GetAttrValue(AName);
end;


procedure TNode.Attr_SetValue(AName: String; const AValue: String);
begin
  SetAttrValue(AName, AValue);
end;


procedure TNode.Attr_Delete(const AName: String);
var
  LIndex: Integer;
begin
  LIndex := Attr_IndexOf(AName);
  if LIndex < 0 then
    Exit;
  Attr_DeleteFromHash(AName);
  FAttributes[LIndex] := nil;
  Dec(FAttrCount);
  if LIndex < FAttrCount then begin
    System.Move(
      FAttributes[LIndex + 1],
      FAttributes[LIndex],
      SizeOf(Pointer) * (FAttrCount - LIndex)
    );
  end;
end;


procedure TNode.Attr_DeleteFromHash(const AName: String);
var
  LHashIndex: Integer;
  LItemIndex: Integer;
  I: Integer;
begin
  LHashIndex := Abs(Hash(AName) mod FAttrHashSize);
  with FAttrHashTable[lHashIndex] do begin
    LItemIndex := -1;
    for I := 0 to AttrCount - 1 do
      if Attributes[i].Name = AName then begin
        LItemIndex := I;
        Break;
      end;
    if LItemIndex >= 0 then begin   // Only remove if found
      if LItemIndex < (AttrCount - 1) then
        System.Move(
          PChar(@Attributes[lItemIndex + 1])^,
          PChar(@Attributes[lItemIndex])^,
          SizeOf(Pointer) * (AttrCount - lItemIndex)
        );
      Assert(AttrCount > 0);
      Dec(AttrCount);
    end;
  end;
end;



{ TNodeCollection }

function TNode.Node_New(const AName: String; AType: TNodeType = ntElement): INode;
var
  LNode: INode;
begin
  if not ValidXmlName(AName) then
    raise Exception.CreateFmt('Node name is invalid: "%s"', [AName]);
  LNode := CreateChildInstance(AName);
  try
    TNode(LNode.Instance).FNodeType := AType;
  except
    Result := nil;
    raise;
  end;
  Result := LNode;
end;


procedure TNode.Node_IncrementArray;
begin
  Inc(FChildCount);
  if FChildCapacity = 0 then begin
    FChildCapacity := FChildCount;
    SetLength(FChildren,FChildCapacity);
  end
  else if FChildCount > FChildCapacity then begin
    FChildCapacity := fChildCapacity * 2;
    SetLength(fChildren,fChildCapacity);
  end;
  // Make sure to remove anything that may have been stored in the current position of the array.
  Pointer(fChildren[fChildCount - 1]) := nil
end;


function TNode.Node_AddNew(const AName: String; AType: TNodeType = ntElement): INode;
begin
  Result := Node_New(AName,AType);
  Node_Add(Result);
end;


function TNode.Node_InsertNew(AIndex: Integer; const AName: String; AType: TNodeType = ntElement): INode;
begin
  Result := Node_New(AName,AType);
  Node_Insert(AIndex, Result);
end;


function TNode.Node_EnsureElement(AName: String; ANodeClass: TClass): INode;
begin
  Result := FindNode(AName);
  if not Assigned(Result) then begin
    if ANodeClass = nil then
      Result := Node_New(AName)
    else
      Result := TNodeClass(ANodeClass).Create(AName);
    Node_Add(Result);
  end;  
end;


function TNode.Node_Add(ANode: INode): Integer;
begin
  if not Assigned(ANode) then
    raise Exception.Create('Attempting to add a nil node');
  Result := Node_AddToArray(ANode);
end;


function TNode.Node_AddToArray(ANode: INode): Integer;
begin
  Node_IncrementArray;
  Result := FChildCount - 1;
  FChildren[Result] := ANode;
end;


procedure TNode.Node_Insert(AIndex: Integer; ANode: INode);
begin
  Node_InsertInArray(ANode, AIndex);
end;


procedure TNode.Node_InsertInArray(ANode: INode; AIndex: Integer);
begin
  if (AIndex >= fChildCount) or (AIndex < 0) then begin
    Node_AddToArray(ANode);
    Exit;
  end;

  Node_IncrementArray;  // fChildCount was incremented in this procedure

  System.Move(
    fChildren[AIndex],
    fChildren[AIndex + 1],
    SizeOf(Pointer) * (fChildCount - AIndex - 1)  { substract 1 since count was already incremented }
  );

  Pointer(fChildren[AIndex]) := nil;
  fChildren[AIndex] := ANode;
end;


procedure TNode.Node_AppendChildren(ANode: INode; ACloneChildren: Boolean);
var
  I: Integer;
begin
  if not ACloneChildren then
    for i:=0 to ANode.Children.Count - 1 do
      Node_Add(ANode.Children[i])
  else
    for i:=0 to ANode.Children.Count - 1 do
      Node_Add(ANode.Children[i].Clone)
end;


procedure TNode.Node_Clear;
begin
  fChildCount := 0;
  fChildCapacity := 0;
  SetLength(fChildren, 0);
end;


function TNode.Node_GetItem(AIndex: Integer): INode;
begin
  if (AIndex >= 0) and (AIndex < fChildCount) then
    Result := FChildren[AIndex]
  else
    Result := nil;
end;


procedure TNode.Node_SetItem(AIndex: Integer; AValue: INode);
begin
  fChildren[AIndex] := AValue;
end;


function TNode.Node_GetCount: Integer;
begin
  Result := fChildCount;
end;


procedure TNode.Node_Delete(AIndex: Integer);
begin
  FChildren[AIndex] := nil;
  Dec(FChildCount);

  if AIndex < fChildCount then
    System.Move(
      Pointer(fChildren[AIndex + 1]),
      fChildren[AIndex],
      SizeOf(Pointer) * (fChildCount - AIndex)
    );
  Pointer(fChildren[fChildCount]) := nil;
end;


procedure TNode.Node_Remove(ANode: INode);
var
  i: Integer;
begin
  for i:=0 to fChildCount - 1 do
    if fChildren[i] = ANode then begin
      Node_Delete(i);
      Break;
    end;
end;

function TNode.Node_Extract(AIndex: Integer): INode;
begin
  Result := fChildren[AIndex];
  Node_Delete(AIndex);
end;


procedure TNode.Node_Move(AIndex, ANewIndex: Integer);
begin
  if AIndex <> ANewIndex then begin
    Node_Insert(ANewIndex, Node_Extract(AIndex));
  end;
end;

procedure TNode.Node_Swap(AIndex, ANewIndex: Integer);
var
  lTempNode: INode;
begin
  if AIndex <> ANewIndex then begin
    lTempNode := fChildren[AIndex];
    fChildren[AIndex] := fChildren[ANewIndex];
    fChildren[ANewIndex] := lTempNode;
  end;
end;

function TNode.Node_IndexOf(const AName: String): Integer;
var
  i: Integer;
begin
  for i:=0 to fChildCount - 1 do
    if (fChildren[i].NodeName = AName) then begin
      Result := i;
      Exit;
    end;

  Result := -1;
end;


function TNode.Find(const AValue: String; AFindProc: TFindProc): INode;
var
  LIndex: Integer;
begin
  for lIndex:=0 to fChildCount - 1 do
    if AFindProc(FChildren[lIndex], AValue) = 0 then begin
      Result := FChildren[lIndex];
      Exit;
    end;
  Result := nil;
end;


function TNode.Node_IndexOfByAttr(const AAttrName, AAttrValue: String;
  CaseSensitive: Boolean = True): Integer;
var
  I: Integer;
begin
  if CaseSensitive then begin
    for i:=0 to fChildCount - 1 do
      if fChildren[i][AAttrName] = AAttrValue then begin
        Result := i;
        Exit;
      end;
  end else begin
    for i:=0 to fChildCount - 1 do
      if SameText(fChildren[i][AAttrName],AAttrValue) then begin
        Result := i;
        Exit;
      end;
  end;
  Result := -1;
end;


function TNode.Node_FindByAttr(const AAttrName, AAttrValue: String;
  CaseSensitive: Boolean = True): INode;
var
  lIndex: Integer;
begin
  lIndex := Node_IndexOfByAttr(AAttrName, AAttrValue, CaseSensitive);
  if lIndex >= 0 then
    Result := fChildren[lIndex]
  else
    Result := nil;
end;


function DefaultCompareProc(ANode1, ANode2: INode): Integer;
begin
  Result := CompareStr(ANode1.NodeName, ANode2.NodeName);
end;


function TNode.GetAttributes: IAttributeCollection;
begin
  Result := Self;
end;


function TNode.GetChildren: INodeCollection;
begin
  Result := Self;
end;


function TNode.GetText: String;
begin
  Result := FText;
end;


procedure TNode.SetText(const AValue: String);
begin
  FText := AValue;
end;


function TNode.GetNodeType: TNodeType;
begin
  Result := FNodeType;
end;


function TNode.Instance: Pointer;
begin
  Result := Self;
end;



function TNode.GetName: String;
begin
  Result := Attr_GetValue(Attr_Name);
end;

procedure TNode.SetName(const AValue: String);
begin
  Attr_SetValue(Attr_Name,AValue);
end;



function TNode.GetID: String;
begin
  Result := Attr_GetValue(Attr_ID);
end;

procedure TNode.SetID(const AValue: String);
begin
  Attr_SetValue(Attr_ID,AValue);
end;


function TNode.Node_GetFirstChild: INode;
begin
  if ChildCount > 0 then
    Result := FChildren[0]
  else
    Result := nil;
end;


function TNode.Node_GetSecondChild: INode;
begin
  if ChildCount > 1 then
    Result := FChildren[1]
  else
    Result := nil;
end;


function TNode.Node_GetLastChild: INode;
begin
  if ChildCount > 0 then
    Result := FChildren[ChildCount-1]
  else
    Result := nil;
end;


function TNode.Attr_AddSafe(AAttr: IAttribute): Integer;
begin
  if Assigned(AAttr) then
    Result := Attr_Add(AAttr)
  else
    Result := -1;
end;

function TNode.Node_AddSafe(ANode: INode): Integer;
begin
  if Assigned(ANode) then
    Result := Node_Add(ANode)
  else
    Result := -1;
end;




procedure TNode.Node_Sort(ACompareFn: TSortCompareFn);

  const
    CQSCutOff = 15;

  procedure InsertionSort(AFirst, ALast: Integer);
  var
    I, J: Integer;
    LIndexOfMin: Integer;
    LTemp: INode;
  begin
    { Find smallest element in first CutOff and move it to the first position. }
    lIndexOfMin := AFirst;
    if cQSCutOff > ALast then
      j := ALast
    else
      j := cQSCutOff;

    for i:=Succ(AFirst) to j do
      if (ACompareFn(fChildren[i], fChildren[lIndexOfMin]) < 0) then
        lIndexOfMin := i;

    if (AFirst <> lIndexOfMin) then begin
      lTemp := fChildren[AFirst];
      fChildren[AFirst] := fChildren[lIndexOfMin];
      fChildren[lIndexOfMin] := lTemp;
    end;

    { Sort via fast insertion method }
    for i:=(AFirst + 2) to ALast do begin
      LTemp := FChildren[I];
      J := I;
      while (ACompareFn(LTemp, FChildren[j - 1]) < 0) do begin
        FChildren[J] := FChildren[J - 1];
        Dec(J);
      end;
      fChildren[J] := LTemp;
    end;
  end;

  procedure QuickSort(AFirst, ALast: Integer);
  var
    L, R: Integer;
    LPivot: INode;
    LTemp: INode;
    LStack: array [0..63] of Integer;
      // Allows for 2 billion items
    LSP: Integer;
  begin
    { Initialize Stack }
    lStack[0] := AFirst;
    lStack[1] := ALast;
    lSP := 2;

    while lSP <> 0 do begin
      Dec(lSP, 2);
      AFirst := lStack[lSP];
      ALast := lStack[lSP + 1];

      while ((ALast - AFirst) > cQSCutOff) do begin
        R := (AFirst + ALast) shr 1;
        if (ACompareFn(FChildren[AFirst], FChildren[R]) > 0) then begin
          LTemp := FChildren[AFirst];
          FChildren[AFirst] := FChildren[R];
          FChildren[R] := LTemp;
        end;

        if (ACompareFn(FChildren[AFirst], FChildren[ALast]) > 0) then begin
          LTemp := FChildren[AFirst];
          FChildren[AFirst] := FChildren[ALast];
          FChildren[ALast] := LTemp;
        end;

        if (ACompareFn(FChildren[R], FChildren[ALast]) > 0) then begin
          LTemp := FChildren[R];
          FChildren[R] := FChildren[ALast];
          FChildren[ALast] := LTemp;
        end;
        LPivot := FChildren[R];

        { Set indexes and partition }
        L := AFirst;
        R := ALast;
        while True do begin
          repeat
            Dec(R);
          until ACompareFn(FChildren[R], LPivot) <= 0;
          repeat
            Inc(L);
          until ACompareFn(fChildren[L], LPivot) >= 0;
          if (L >= R) then
            Break;
          lTemp := fChildren[L];
          fChildren[L] := fChildren[R];
          fChildren[R] := lTemp;
        end;
        { Push larger subfile onto the stack. Go arround loop again with smaller subfile. }
        if (R - AFirst) < (ALast - R) then begin
          LStack[lSP] := Succ(R);
          LStack[lSP + 1] := ALast;
          Inc(lSP, 2);
          ALast := R;
        end
        else begin
          LStack[lSP] := AFirst;
          LStack[lSP + 1] := R;
          Inc(lSP, 2);
          AFirst := Succ(R);
        end;
      end;
    end;
  end;

begin
  if not Assigned(ACompareFn) then
    ACompareFn := DefaultCompareFn;
  QuickSort(0, FChildCount - 1);
  InsertionSort(0, FChildCount - 1);
end;



function TNode.Node_ReplaceWith(ANode: INode): Integer;
begin
  Node_Clear;
  Result := Node_AddSafe(ANode);
end;



end.

