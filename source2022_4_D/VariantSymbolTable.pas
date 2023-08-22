unit VariantSymbolTable;

interface

uses
  SysUtils;

const
  HASH_SIZE = 256;	        (* Don't change this unless you change *)
				(* HashFunc() while you're at it *)
(*
 * Like SymbolTable, only this implements a more "automatic" symbol table.
 *)
type
  EVariantSymbolTable = class(exception);

  TSymbolType = (stInteger, stFloat, stDate, stString);

  PSymbol = ^TSymbol;
  TSymbol = record
    Name: String;                     (* copy of name *)
    BlockLevel,                       (* nesting depth *)
    HashValue: Integer;               (* Hash bucket # *)
    Next, Prev: PSymbol;              (* next/prev symbol in scope *)
    HNext, HPrev: PSymbol;            (* next/prev symbol in bucket *)
    Value: Variant;                   (* Symbol's value *)
  end;
  TSymbolArray = array[0..HASH_SIZE - 1] of PSymbol;
  PSymbolArray = ^TSymbolArray;

  TVariantSymbolTable = class(TObject)
  protected
    Syms: PSymbol;
    Hash: TSymbolArray;
    Blocklevel: Integer;
    Local: Boolean;
    function GetSymbol(SymbolName: String): PSymbol;
    function GetValue(SymbolName: String): Variant;
    function HashFunc(SymbolName: String): Integer; virtual;
    procedure SetValue(SymbolName: String; Value: Variant);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    function CreateSymbol(SymbolName: String; SymbolValue: Variant): PSymbol;
    procedure EnterBlock;
    function IsEmpty: Boolean;
    procedure LeaveBlock;
    // Properties
    property FirstSymbol: PSymbol read Syms;
    property LocalScope: Boolean read Local write Local;
    property Symbol[SymbolName: String]: PSymbol read GetSymbol;
    property Value[SymbolName: String]: Variant read GetValue
                                                write SetValue;
  end;

implementation

constructor TVariantSymbolTable.Create;
begin
  Syms := nil;
  Clear;
end;

destructor TVariantSymbolTable.Destroy;
begin
  Clear;
  inherited;
end;

procedure TVariantSymbolTable.Clear;
var
  sp, next : PSymbol;
  i: Integer;
begin
  BlockLevel := 0;
  Local := False;
  sp := Syms;
  while sp <> nil do begin
    next := sp^.next;
    FreeMem(sp);
    sp := next;
  end;
  Syms := nil;
  for i := 0 to HASH_SIZE - 1 do if Hash[i] <> nil then
    Hash[i] := nil;
end;

function TVariantSymbolTable.CreateSymbol(SymbolName: String;
  SymbolValue: Variant): PSymbol;
var
  HashValue, i: Integer;
  sp: PSymbol;
begin
  HashValue := HashFunc(SymbolName);
  sp := nil;
  GetMem(sp, SizeOf(TSymbol));
  // Initialize the memory to 0's
  for i := 0 to SizeOf(TSymbol) - 1 do
    PChar(sp)[i] := #0;
  if (sp = nil) then
    raise EVariantSymbolTable.Create('Out of symbol table space.');
  sp^.Name := SymbolName;
  sp^.BlockLevel := BlockLevel;
  sp^.HashValue := HashValue;
  sp^.Value := SymbolValue;
  (* confuse everybody by setting lots of pointers *)
  sp^.next := Syms;
  sp^.hnext := Hash[HashValue];
  sp^.prev := nil;
  sp^.hprev := nil;
  if (Syms <> nil) then
    Syms^.prev := sp;
  if (Hash[HashValue] <> nil) then
    Hash[HashValue]^.hprev := sp;
  Syms := sp;
  Hash[HashValue] := sp;
  result := sp;
end;

procedure TVariantSymbolTable.EnterBlock;
begin
  Inc(BlockLevel);
end;

function TVariantSymbolTable.GetSymbol(SymbolName: String): PSymbol;
var
  HashValue: Integer;
  sp: PSymbol;
  bl: Integer;
begin
  HashValue := HashFunc(SymbolName);
  sp := Hash[HashValue];
  if (Local) then begin
    bl := BlockLevel;
    while ((sp <> nil) and (sp^.BlockLevel >= bl) and
           (sp^.Name <> SymbolName)) do
      sp := sp^.hnext;
  end else begin
    while ((sp <> nil) and (sp^.Name <> SymbolName)) do
      sp := sp^.hnext;
  end;
  result := sp;
end;

function TVariantSymbolTable.GetValue(SymbolName: String): Variant;
var
  sp: PSymbol;
begin
  sp := Symbol[SymbolName];
  result := 'NULL';
  if sp <> nil then
    result := sp^.Value;
end;

function TVariantSymbolTable.HashFunc(SymbolName: String): Integer;
var
  i: Integer;
begin
  result := 0;
  for i := 1 to Length(SymbolName) do
    Inc(result, Integer(SymbolName[i]));
  result := result and (HASH_SIZE - 1);
end;

function TVariantSymbolTable.IsEmpty: Boolean;
begin
  result := (Syms = nil);
end;

procedure TVariantSymbolTable.LeaveBlock;
var
  Sym, next: PSymbol;
  elim: Integer;
begin
  Dec(BlockLevel);
  elim := BlockLevel;
  Sym := Syms;
  while (Sym <> nil) and (Sym^.BlockLevel > elim) do begin
    next := Sym^.next;
    if (Sym^.hprev <> nil) then
      Sym^.hprev^.hnext := Sym^.hnext
    else
      Hash[Sym^.HashValue] := Sym^.hnext;
    if (Sym^.hnext <> nil) then
      Sym^.hnext^.hprev := Sym^.hprev;
    FreeMem(Sym);
    Sym := next;
  end;
  Syms := Sym;
  if (Sym <> nil) then
    Sym^.prev := nil;
end;

procedure TVariantSymbolTable.SetValue(SymbolName: String; Value: Variant);
var
  sp: PSymbol;
begin
  sp := Symbol[SymbolName];
  if sp <> nil then
    sp^.Value := Value;
end;

end.
