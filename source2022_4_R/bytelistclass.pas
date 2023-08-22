(*********************************************************)
(***)                                                 (***)
(***)              UNIT ByteListClass;                     (***)
(***)                                                 (***)
(*********************************************************)

(*********************************************************)
(* Feel free to use it, but at your own risk!            *)
(* À utiliser librement, mais à vos risques et périls !  *)
(* CapJack.                                              *)
(*********************************************************)


(*********************************************************)
(***)                                                 (***)
(***)                  INTERFACE                      (***)
(***)                                                 (***)
(*********************************************************)


(*********************************************************)
(* TByteList (v1.31)                                     *)
(* ----------------------------------------------------- *)
(* Implements a powerful class encapsulating a list      *)
(* of "Byte", with additional features compared to       *)
(* conventional TList.                                   *)
(* Study the source code for the complete list           *)
(* of features.                                          *)
(* Compilable with any version of Delphi 32/64-bit,      *)
(* and also with Lazarus / Free Pascal.                  *)
(* ----------------------------------------------------- *)
(* Implémente une puissante classe encapsulant une liste *)
(* d'éléments "Byte", avec des fonctionnalités           *) 
(* supplémentaires par rapport au classique TList.       *)
(* Étudiez le code source pour la liste complète         *)
(* des fonctionnalités.                                  *)
(* Compilable avec toute version de Delphi 32/64 bits,   *)
(* ainsi qu'avec Lazarus / Free Pascal.                  *)
(*********************************************************)


{$IFDEF VER80 }{$DEFINE VERYOLDVERSION}{$ENDIF D1    }
{$IFDEF VER90 }{$DEFINE VERYOLDVERSION}{$ENDIF D2    }
{$IFDEF VER93 }{$DEFINE VERYOLDVERSION}{$ENDIF BCB++1}
{$IFDEF VER100}{$DEFINE VERYOLDVERSION}{$ENDIF D3    }
{$IFDEF VER110}{$DEFINE VERYOLDVERSION}{$ENDIF BCB++3}
{$IFDEF VER120}{$DEFINE VERYOLDVERSION}{$ENDIF D4    }
{$IFDEF VER125}{$DEFINE VERYOLDVERSION}{$ENDIF BCB++4}
{$IFDEF VER130}{$DEFINE VERYOLDVERSION}{$ENDIF D5    }
{$IFDEF VER140}{$DEFINE OLDVERSION}{$ENDIF D6,CB++6,Kylix 1&2}
{$IFDEF VER150}{$DEFINE OLDVERSION}{$ENDIF D7, Kylix 3}
{$IFDEF VER160}{$DEFINE OLDVERSION}{$ENDIF D8 for .NET}
{$IFDEF VER170}{$DEFINE OLDVERSION}{$ENDIF D2005}
{$IFDEF VER180}{$DEFINE OLDVERSION}{$ENDIF D2006, D2007 Win32}
{$IFDEF VER180}{$DEFINE OLDVERSION}{$ENDIF D2007 Win32}
{$IFDEF VER185}{$DEFINE OLDVERSION}{$ENDIF D2007 Win32}
{$IFDEF VER190}{$DEFINE OLDVERSION}{$ENDIF D2007 .NET}
{$IFDEF VER200}{$DEFINE OLDVERSION}{$ENDIF D2009, CB++ 2009}
{$IFDEF VER210}{$DEFINE OLDVERSION}{$ENDIF Delphi 2010}
{$IFDEF VER220}{$DEFINE OLDVERSION}{$ENDIF Delphi XE}

{$IFDEF FPC} // Lazarus / Free Pascal
 uses SysUtils, Classes, RTLConsts;
 {$HINTS OFF} // Solve useless "local variable not initialized"
{$ELSE} // Delphi
 {$IFDEF VERYOLDVERSION} // Delphi 1 -> 5
  uses SysUtils, Classes, Consts;
 {$ELSE}
  {$IFDEF OLDVERSION} // Delphi 6 -> XE
   uses SysUtils, Classes, RTLConsts;
  {$ELSE} // Delphi XE2 Win 32/64 + MacOS
   uses System.SysUtils, System.Classes,
        System.RTLConsts;
  {$ENDIF OLDVERSION}
 {$ENDIF VERYOLDVERSION}
{$ENDIF FPC}

const 
 MaxByteListSize = Maxint div SizeOf(Byte);

 SByteListVoidError='Invalid method call (empty list)!';
 SByteListSortError='Invalid method call (sorted list)!';

type
  PBytePtrList 
   = ^TBytePtrList;
  
  TBytePtrList 
   = array[0..MaxByteListSize - 1] of Byte;
  
  TByteListSortCompare 
   = function (Item1, Item2: Byte): Integer;
  
  TByteDescriptor 
   = function (Index:Integer;Item : Byte) : string;

  TByteSortOption 
   = (
      ByteSortNone,
      ByteSortUpWithDup,
      ByteSortUpNoDup,
      ByteSortDownWithDup,
      ByteSortDownNoDup      
     );

  TByteListClass = class(TObject)
  private
    FList       : PBytePtrList;
    FCount      : Integer;
    FCapacity   : Integer;
    FSortType   : TByteSortOption;
  protected
    function  Get(Index: Integer): Byte;
    procedure Grow; virtual;
    procedure Put(Index: Integer; Item: Byte);
    procedure SetCapacity(AValue: Integer);
    procedure SetCount(AValue: Integer);
    procedure SetSortType
                  (NewSortType: TByteSortOption);
    procedure EliminateDups;
    function  NormalFind(Value: Byte): Integer;
    function  FastFindUp(Value:Byte;
                  var Position:Integer):Integer;
    function  FastFindDown(Value:Byte;
                  var Position:Integer):Integer;
    procedure ForceInsert(Index: Integer; Item: Byte);
    function  NormalAdd(Item: Byte): Integer;

  public
    constructor Create;
    destructor Destroy; override;
    function  Add(Item: Byte): Integer;
    procedure Clear;
    procedure SaveToStream(const S:TStream);
    procedure LoadFromStream(const S:TStream;
                  const KeepCurrentSortType:Boolean=false);
    procedure SaveToFile(FileName:string);
    procedure LoadFromFile(FileName:string;
                  const KeepCurrentSortType:Boolean=false);
    procedure Delete(Index: Integer);
    function  ErrMsg(const Msg:string;Data:Integer):string;
    procedure Exchange(Index1, Index2: Integer);
    function  Expand: TByteListClass;
    function  First: Byte;
    function  IndexOf(Value: Byte): Integer;
    procedure Insert(Index: Integer; Item: Byte);
    function  Last: Byte;
    procedure Move(CurIndex, NewIndex: Integer);
    function  Remove(Item: Byte): Integer;
    procedure Pack(NilValue:Byte);
    procedure Sort(Compare: TByteListSortCompare);
    procedure SortUp;
    procedure SortDown;
    procedure ShowList(StringList:TStrings;
                  Descriptor:TByteDescriptor=nil;
                  ClearIt:Boolean=true);

    function  Minimum:Byte;
    function  Maximum:Byte;
    function  Range:Byte;
    function  Sum:Extended;
    function  SumSqr:Extended;
    function  Average:Extended;
    procedure CopyFrom(List:TByteListClass;
                  const KeepCurrentSortType:Boolean=false);
    procedure CopyTo(List:TByteListClass;
                  const KeepDestSortType:Boolean=false);

    procedure Push(Value:Byte);
    function  LifoPop(DefValue:Byte):Byte;
    function  FifoPop(DefValue:Byte):Byte;

    property  List: PBytePtrList read FList;
    property  Capacity: Integer 
                  read FCapacity 
                  write SetCapacity;
    property  Count: Integer 
                  read FCount 
                  write SetCount;
    property  Items[Index: Integer]: Byte 
                  read Get 
                  write Put; default;
    property  SortType:TByteSortOption 
                  read FSortType 
                  write SetSortType;
  end;


// Default descriptor - Descripteur par défaut (ShowList)
function DefDescByte(Index: Integer;Item: Byte) : string;


(*********************************************************)
(***)                                                 (***)
(***)                IMPLEMENTATION                   (***)
(***)                                                 (***)
(*********************************************************)

{$IFNDEF FPC}
 {$IFDEF OLDVERSION}
  uses Consts;
 {$ENDIF}
{$ENDIF}

{---------------------------------------------------------}

function DefDescByte(Index: Integer;Item: Byte) : string;
 begin
  Result:=Format('Items[%d] = %d',[Index,Item]);
 end;

{---------------------------------------------------------}

constructor TByteListClass.Create;
begin
  inherited Create;
  FSortType := ByteSortNone;
end;

{---------------------------------------------------------}

destructor TByteListClass.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{---------------------------------------------------------}

function  TByteListClass.NormalAdd
                             (Item: Byte): Integer;
begin
  Result := FCount;
  if Result = FCapacity then Grow;
  FList^[Result] := Item;
  Inc(FCount);
end;

{---------------------------------------------------------}

procedure TByteListClass.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

{---------------------------------------------------------}

procedure TByteListClass.SaveToStream(const S:TStream);
 var T : Integer;
 begin
  T := Integer(FSortType);
  S.Write(FCount,SizeOf(FCount));
  S.Write(T,SizeOf(T));
  S.Write(FList^,FCount * SizeOf(Byte));
 end;

{---------------------------------------------------------}

procedure TByteListClass.SaveToFile(FileName:string);
 var Stream:TFileStream;
 begin
  Stream:=nil;
  try
   Stream := TFileStream.Create(FileName, fmCreate 
                                or fmShareExclusive);
   SaveToStream(Stream);
  finally
   if assigned(Stream) then Stream.Free;
  end;
 end;

{---------------------------------------------------------}

procedure TByteListClass.LoadFromStream(const S:TStream;
                  const KeepCurrentSortType:Boolean=false);
 var N, T    : Integer;
     Current : TByteSortOption;
     Saved   : TByteSortOption;
 begin
  S.Read(N,SizeOf(N));
  S.Read(T,SizeOf(T));
  Saved   := TByteSortOption(T);
  Current := FSortType;
  Clear;
  SetSortType(ByteSortNone);
  SetCount(N);
  S.Read(FList^,N * SizeOf(Byte));
  if KeepCurrentSortType and (Current <> Saved)
     then SetSortType(Current)
     else FSortType := Saved; 
 end;

{---------------------------------------------------------}

procedure TByteListClass.LoadFromFile(FileName:string;
                const KeepCurrentSortType:Boolean=false);
 var Stream:TFileStream;
 begin
  Stream:=nil;
  try
   Stream := TFileStream.Create(FileName,fmOpenRead 
                                or fmShareDenyWrite);
   LoadFromStream(Stream,KeepCurrentSortType);
  finally
   if assigned(Stream) then Stream.Free;
  end;
 end;

{---------------------------------------------------------}

procedure TByteListClass.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) 
   then raise EListError.Create(
                   ErrMsg(SListIndexError, Index));
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(Byte));
end;

{---------------------------------------------------------}

function  TByteListClass.ErrMsg(const Msg:string;
                                   Data:Integer):string;
begin
  Result := Format(Msg,[Data]); 
end;                                   

{---------------------------------------------------------}

procedure TByteListClass.Exchange
                                 (Index1, Index2: Integer);
var
  Item: Byte;
begin
  if FSortType <> ByteSortNone 
     then raise EListError.Create(
                     ErrMsg(SByteListSortError,0));
  if (Index1 < 0) or (Index1 >= FCount) 
     then raise EListError.Create(
                     ErrMsg(SListIndexError, Index1));
  if (Index2 < 0) or (Index2 >= FCount) 
     then raise EListError.Create(
                     ErrMsg(SListIndexError, Index2));
  Item := FList^[Index1];
  FList^[Index1] := FList^[Index2];
  FList^[Index2] := Item;
end;

{---------------------------------------------------------}

function  TByteListClass.Expand: TByteListClass;
begin
  if FCount = FCapacity then Grow;
  Result := Self;
end;

{---------------------------------------------------------}

function  TByteListClass.First: Byte;
begin
  Result := Get(0);
end;

{---------------------------------------------------------}

function  TByteListClass.Get
                            (Index: Integer): Byte;
begin
  if (Index < 0) or (Index >= FCount) 
     then raise EListError.Create(
                     ErrMsg(SListIndexError, Index));
  Result := FList^[Index];
end;

{---------------------------------------------------------}

procedure TByteListClass.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 
     then Delta := FCapacity div 4 
     else if FCapacity > 8 
          then Delta := 16 
          else Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

{---------------------------------------------------------}

procedure TByteListClass.ForceInsert(Index: Integer;
                                        Item: Byte);
begin
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(Byte));
  FList^[Index] := Item;
  Inc(FCount);
end;

{---------------------------------------------------------}

procedure TByteListClass.Insert(Index: Integer;
                                   Item: Byte);
begin
  if FSortType <> ByteSortNone 
     then raise EListError.Create(
                     ErrMsg(SByteListSortError,0));
  if (Index < 0) or (Index > FCount) 
     then raise EListError.Create(
                     ErrMsg(SListIndexError, Index));
  ForceInsert(Index,Item);
end;

{---------------------------------------------------------}

function  TByteListClass.Last: Byte;
begin
  Result := Get(FCount - 1);
end;

{---------------------------------------------------------}

procedure TByteListClass.Move(CurIndex,
                                 NewIndex: Integer);
var
  Item: Byte;
begin
  if FSortType <> ByteSortNone 
     then raise EListError.Create(
                     ErrMsg(SByteListSortError,0));
  if CurIndex <> NewIndex then
  begin
    if (NewIndex < 0) or (NewIndex >= FCount) 
       then raise EListError.Create(
                     ErrMsg(SListIndexError, NewIndex));
    Item := Get(CurIndex);
    Delete(CurIndex);
    Insert(NewIndex, Item);
  end;
end;

{---------------------------------------------------------}

procedure TByteListClass.Put(Index: Integer;
                                Item: Byte);
begin
  if (Index < 0) or (Index >= FCount) 
     then raise EListError.Create(
                     ErrMsg(SListIndexError, Index));
  FList^[Index] := Item;
end;

{---------------------------------------------------------}

function  TByteListClass.Remove
                             (Item: Byte): Integer;
begin
  Result := IndexOf(Item);
  if Result <> -1 then Delete(Result);
end;

{---------------------------------------------------------}

procedure TByteListClass.Pack(NilValue:Byte);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 
      do if Items[I] = NilValue 
            then Delete(I);
end;

{---------------------------------------------------------}

procedure TByteListClass.SetCapacity(AValue: Integer);
begin
  if (AValue < FCount) 
  // SizeOf(Byte)=1 - no other test needed 
     then raise EListError.Create(
                  ErrMsg(SListCapacityError, AValue));
  if AValue <> FCapacity 
     then begin
           ReallocMem(FList, 
                      AValue * SizeOf(Byte));
           FCapacity := AValue;
          end;
end;

{---------------------------------------------------------}

procedure TByteListClass.SetCount(AValue: Integer);
begin
  if (AValue < 0) 
  // SizeOf(Byte)=1 - no other test needed 
     then raise EListError.Create(
                     ErrMsg(SListCountError, AValue));
  if AValue > FCapacity 
     then SetCapacity(AValue);
  if AValue > FCount 
     then FillChar((@FList^[FCount])^, 
            (AValue - FCount) * SizeOf(Byte), 0);
  FCount := AValue;
end;

{---------------------------------------------------------}

procedure QuickSort(SortList: PBytePtrList; 
                    L, R: Integer;
  SCompare: TByteListSortCompare);
var
  I, J: Integer;
  P, T: Byte;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while SCompare(SortList^[I], P) < 0 do Inc(I);
      while SCompare(SortList^[J], P) > 0 do Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(SortList, L, J, SCompare);
    L := I;
  until I >= R;
end;

{---------------------------------------------------------}

procedure TByteListClass.Sort
                   (Compare: TByteListSortCompare);
begin
  if (FList <> nil) and (Count > 0) 
     then QuickSort(FList, 0, Count - 1, Compare);
end;

{---------------------------------------------------------}

procedure QuickSortUp(SortList: PBytePtrList; 
                      L, R: Integer);
var
  I, J: Integer;
  P, T: Byte;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while SortList^[I] < P do Inc(I);
      while SortList^[J] > P do Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSortUp(SortList, L, J);
    L := I;
  until I >= R;
end;

procedure TByteListClass.SortUp;
begin
  if (FList <> nil) and (Count > 0) then
   begin
    QuickSortUp(FList, 0, Count - 1);
    FSortType := ByteSortNone
   end;
end;

{---------------------------------------------------------}

procedure QuickSortDown(SortList: PBytePtrList; 
                        L, R: Integer);
var
  I, J: Integer;
  P, T: Byte;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while SortList^[I] > P do Inc(I);
      while SortList^[J] < P do Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSortDown(SortList, L, J);
    L := I;
  until I >= R;
end;

procedure TByteListClass.SortDown;
begin
  if (FList <> nil) and (Count > 0) then
   begin
    QuickSortDown(FList, 0, Count - 1);
    FSortType := ByteSortNone
   end;
end;

{---------------------------------------------------------}

procedure TByteListClass.ShowList(StringList:TStrings;
                  Descriptor:TByteDescriptor=nil;
                  ClearIt:boolean=true);
var I:integer;
begin
 if not assigned(StringList) then exit;
 with StringList do
  begin
   BeginUpdate;
   if ClearIt then Clear;
   if assigned(Descriptor)
      then for I := 0 to FCount -1
           do Add(Descriptor(I,FList^[I]))
      else for I := 0 to FCount -1
           do Add(DefDescByte(I,FList^[I]));
   EndUpdate;
  end;
end;

{---------------------------------------------------------}

procedure TByteListClass.Push(Value:Byte);
 begin
  Add(Value);
 end;

{---------------------------------------------------------}

function  TByteListClass.LifoPop
                      (DefValue:Byte):Byte;
 begin
  if Count=0 then Result := DefValue
             else begin
                   Result := Last;
                   Delete(Count - 1);
                  end;
 end;

{---------------------------------------------------------}

function  TByteListClass.FifoPop
                      (DefValue:Byte):Byte;
 begin
  if Count=0 then Result := DefValue
             else begin
                   Result := First;
                   Delete(0);
                  end;
 end;

{---------------------------------------------------------}

function  TByteListClass.Minimum:Byte;
 var I:Integer;
 begin
  Result := 0;
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SByteListVoidError,0));
  case FSortType of

       ByteSortNone: 
         begin
           Result := FList^[0];
           for I:=1 to FCount-1 do
               if FList^[I]<Result 
                  then Result := FList^[I];
         end;
         
       ByteSortUpWithDup,
       ByteSortUpNoDup:
         begin 
           Result := FList^[0];
         end;
           
       BytesortDownWithDup,
       BytesortDownNoDup: 
         begin
           Result := FList^[FCount - 1];
         end;
           
      end;
 end;

{---------------------------------------------------------}

function  TByteListClass.Maximum:Byte;
 var I:Integer;
 begin
  Result := 0;
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SByteListVoidError,0));
  case FSortType of

       ByteSortNone: 
         begin
           Result := FList^[0];
           for I:=1 to FCount-1 
               do if FList^[I]>Result 
                  then Result := FList^[I];
         end;

       ByteSortUpWithDup,
       ByteSortUpNoDup: 
         Result := FList^[FCount - 1];

       BytesortDownWithDup,
       BytesortDownNoDup: 
         Result := FList^[0];
         
      end;
 end;

{---------------------------------------------------------}

function  TByteListClass.Range:Byte;
 var I:Integer;Min,Max,Item:Byte;
 begin
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SByteListVoidError,0));
  if FSortType = ByteSortNone 
   then
     begin
      Min := FList^[0];
      Max:=Min;
      for I:=1 to FCount-1 do
          begin
           Item:=FList^[I];
           if Item > Max then Max := Item;
           if Item < Min then Min := Item;
          end;
      Result := Max - Min;
     end
   else Result := Maximum - Minimum;
 end;

{---------------------------------------------------------}

function  TByteListClass.Sum:Extended;
 var I:Integer;
 begin
  Result:=0;
  for I:=0 to FCount-1 
      do Result := Result + FList^[I];
 end;

{---------------------------------------------------------}

function  TByteListClass.SumSqr:Extended;
 var I:Integer;Dummy:Extended;
 begin
  Result:=0;
  for I:=0 to FCount-1 
      do begin
          Dummy := FList^[I];
          Result := Result + ( Dummy * Dummy );
         end;
 end;

{---------------------------------------------------------}

function  TByteListClass.Average:Extended;
 begin
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SByteListVoidError,0));
  Result := (Sum / FCount);
 end;

{---------------------------------------------------------}

procedure TByteListClass.CopyFrom(List:TByteListClass;
                   const KeepCurrentSortType:Boolean=false);
 var Current : TByteSortOption;
 begin
  Current := FSortType;
  Clear;
  SetSortType(ByteSortNone);
  SetCount(List.Count);
  System.Move(List.List^, FList^,
              List.Count*SizeOf(Byte));
  if KeepCurrentSortType and (Current <> List.SortType)
     then SetSortType(Current)
     else FSortType := List.SortType;
 end;

{---------------------------------------------------------}

procedure TByteListClass.CopyTo(List:TByteListClass;
                    const KeepDestSortType:Boolean=false);
 begin
  List.CopyFrom(Self,KeepDestSortType);
 end;

{---------------------------------------------------------}

function  TByteListClass.NormalFind
                           (Value: Byte): Integer;
begin
  Result := 0;
  while (Result < FCount) and (FList^[Result] <> Value) 
        do Inc(Result);
  if Result = FCount then Result := -1;
end;

{---------------------------------------------------------}

function  TByteListClass.FastFindUp(Value:Byte;
                           var Position:Integer):Integer;
 var A,B:Integer;
 begin
  if Count = 0 
     then begin Position := 0; Result := -1; exit end;
  if Value = FList^[0] 
     then begin Position := 0; Result :=  0; exit end;
  if Value < FList^[0] 
     then begin Position := 0; Result := -1; exit end;
  A := 0;
  B := Count;
  repeat
   Position:=(A + B) div 2;
   if Value = FList^[Position] 
      then begin Result := Position;exit end
      else if Value < FList^[Position] 
           then B := Position 
           else A := Position
  until B - A <= 1;
  Result := -1;
  if Value > FList^[Position] then inc(Position);
 end;

{---------------------------------------------------------}

function  TByteListClass.FastFindDown(Value:Byte;
                             var Position:Integer):Integer;
 var A,B:Integer;
 begin
  if Count = 0 
     then begin Position := 0; Result := -1; exit end;
  if Value = FList^[0] 
     then begin Position := 0; Result :=  0; exit end;
  if Value > FList^[0] 
     then begin Position := 0; Result := -1; exit end;
  A := 0;
  B := Count;
  repeat
   Position:=(A + B) div 2;
   if Value = FList^[Position] 
      then begin Result := Position;exit end
      else if Value > FList^[Position] 
              then B := Position 
              else A := Position
  until B - A <= 1;
  Result := -1;
  if Value < FList^[Position] then inc(Position);
 end;

{---------------------------------------------------------}

function  TByteListClass.IndexOf
                            (Value: Byte): Integer;
 var P:Integer;
 begin
  Result := -1;
  case FSortType of
       ByteSortNone: 
         Result := NormalFind(Value);

       ByteSortUpWithDup,
       ByteSortUpNoDup: 
         Result := FastFindUp(Value,P);

       BytesortDownWithDup,
       BytesortDownNoDup: 
         Result := FastFindDown(Value,P);
      end;
 end;

{---------------------------------------------------------}

function  TByteListClass.Add
                             (Item: Byte): Integer;
 var P:Integer;
 begin
  Result := -1;
  case FSortType of
       ByteSortNone: 
                         begin
                          Result := NormalAdd(Item);
                         end;
       ByteSortUpWithDup: 
                         begin
                          FastFindUp(Item,P);
                          ForceInsert(P,Item);
                          Result := P;
                         end;
       ByteSortUpNoDup: 
                         begin
                          if FastFindUp(Item,P) = -1 
                             then begin 
                                   ForceInsert(P,Item);
                                   Result:=P 
                                  end;
                         end;
       ByteSortDownWithDup:
                         begin
                          FastFindDown(Item,P);
                          ForceInsert(P,Item);
                          Result := P;
                         end;
       ByteSortDownNoDup: 
                         begin
                          if FastFindDown(Item,P) = -1 
                             then begin 
                                   ForceInsert(P,Item);
                                   Result:=P 
                                  end;
                         end;
      end;
 end;

{---------------------------------------------------------}

procedure TByteListClass.EliminateDups;
 var I:Integer;
 begin 
  I:=0;
  while I < Count - 1 do
    if FList^[I + 1] = FList^[I]
	 then Delete(I) else Inc(I);
 end;

{---------------------------------------------------------}

procedure TByteListClass.SetSortType
                     (NewSortType:TByteSortOption);
 begin 
  if NewSortType = FSortType then exit;
  case NewSortType of

       ByteSortNone: 
         begin
         end;

       ByteSortUpWithDup: 
         begin
           if FSortType <> ByteSortUpNoDup 
              then SortUp;
         end;

       ByteSortUpNoDup: 
         begin
           if FSortType <> ByteSortUpWithDup 
              then SortUp;
           EliminateDups;
         end;

       ByteSortDownWithDup:
         begin
           if FSortType <> ByteSortDownNoDup 
              then SortDown;
         end;

       ByteSortDownNoDup: 
         begin
           if FSortType <> ByteSortDownWithDup 
              then SortDown;
           EliminateDups;
         end;

      end;
  FSortType := NewSortType;
 end;
 
{---------------------------------------------------------}

END.