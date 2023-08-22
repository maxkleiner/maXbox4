(*********************************************************)
(***)                                                 (***)
(***)              UNIT DoubleList4;                   (***)
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
(* TDoubleList (v1.31)                                   *)
(* ----------------------------------------------------- *)
(* Implements a powerful class encapsulating a list      *)
(* of "Double", with additional features compared to     *)
(* conventional TList.                                   *)
(* Study the source code for the complete list           *)
(* of features.                                          *)
(* Compilable with any version of Delphi 32/64-bit,      *)
(* and also with Lazarus / Free Pascal.                  *)
(* ----------------------------------------------------- *)
(* Implémente une puissante classe encapsulant une liste *)
(* d'éléments "Double", avec des fonctionnalités         *) 
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
 MaxDoubleListSize = Maxint div SizeOf(Double);

 SDoubleListVoidError='Invalid method call (empty list)!';
 SDoubleListSortError='Invalid method call (sorted list)!';

type
  PDoublePtrList 
   = ^TDoublePtrList;
  
  TDoublePtrList
   = array[0..MaxDoubleListSize - 1] of Double;

  TDoubleListSortCompare
   = function (Item1, Item2: Double): Integer;

  TDoubleDescriptor
   = function (Index:Integer;Item : Double) : string;

  TDoubleSortOption 
   = (
      DoubleSortNone,
      DoubleSortUpWithDup,
      DoubleSortUpNoDup,
      DoubleSortDownWithDup,
      DoubleSortDownNoDup
     );

  TDoubleList = class(TObject)
  private
    FList       : PDoublePtrList;
    FCount      : Integer;
    FCapacity   : Integer;
    FSortType   : TDoubleSortOption;
  protected
    function  Get(Index: Integer): Double;
    procedure Grow; virtual;
    procedure Put(Index: Integer; Item: Double);
    procedure SetCapacity(AValue: Integer);
    procedure SetCount(AValue: Integer);
    procedure SetSortType
                  (NewSortType: TDoubleSortOption);
    procedure EliminateDups;
    function  NormalFind(Value: Double): Integer;
    function  FastFindUp(Value:Double;
                  var Position:Integer):Integer;
    function  FastFindDown(Value:Double;
                  var Position:Integer):Integer;
    procedure ForceInsert(Index: Integer; Item: Double);
    function  NormalAdd(Item: Double): Integer;

  public
    constructor Create;
    destructor Destroy; override;
    function  Add(Item: Double): Integer;
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
    function  Expand: TDoubleList;
    function  First: Double;
    function  IndexOf(Value: Double): Integer;
    procedure Insert(Index: Integer; Item: Double);
    function  Last: Double;
    procedure Move(CurIndex, NewIndex: Integer);
    function  Remove(Item: Double): Integer;
    procedure Pack(NilValue:Double);
    procedure Sort(Compare: TDoubleListSortCompare);
    procedure SortUp;
    procedure SortDown;
    procedure ShowList(StringList:TStrings;
                  Descriptor:TDoubleDescriptor=nil;
                  ClearIt:Boolean=true);

    function  Minimum:Double;
    function  Maximum:Double;
    function  Range:Double;
    function  Sum:Extended;
    function  SumSqr:Extended;
    function  Average:Extended;
    procedure CopyFrom(List:TDoubleList;
                  const KeepCurrentSortType:Boolean=false);
    procedure CopyTo(List:TDoubleList;
                  const KeepDestSortType:Boolean=false);

    procedure Push(Value:Double);
    function  LifoPop(DefValue:Double):Double;
    function  FifoPop(DefValue:Double):Double;

    property  List: PDoublePtrList read FList;
    property  Capacity: Integer 
                  read FCapacity 
                  write SetCapacity;
    property  Count: Integer 
                  read FCount 
                  write SetCount;
    property  Items[Index: Integer]: Double 
                  read Get 
                  write Put; default;
    property  SortType:TDoubleSortOption 
                  read FSortType 
                  write SetSortType;
  end;


// Default descriptor - Descripteur par défaut (ShowList)
function DefDescDouble(Index: Integer;Item: Double) : string;


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

function DefDescDouble(Index: Integer;Item: Double) : string;
 begin
  Result:=Format('Items[%d] = %g',[Index,Item]);
 end;

{---------------------------------------------------------}

constructor TDoubleList.Create;
begin
  inherited Create;
  FSortType := DoubleSortNone;
end;

{---------------------------------------------------------}

destructor TDoubleList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{---------------------------------------------------------}

function  TDoubleList.NormalAdd
                             (Item: Double): Integer;
begin
  Result := FCount;
  if Result = FCapacity then Grow;
  FList^[Result] := Item;
  Inc(FCount);
end;

{---------------------------------------------------------}

procedure TDoubleList.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

{---------------------------------------------------------}

procedure TDoubleList.SaveToStream(const S:TStream);
 var T : Integer;
 begin
  T := Integer(FSortType);
  S.Write(FCount,SizeOf(FCount));
  S.Write(T,SizeOf(T));
  S.Write(FList^,FCount * SizeOf(Double));
 end;

{---------------------------------------------------------}

procedure TDoubleList.SaveToFile(FileName:string);
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

procedure TDoubleList.LoadFromStream(const S:TStream;
                  const KeepCurrentSortType:Boolean=false);
 var N, T    : Integer;
     Current : TDoubleSortOption;
     Saved   : TDoubleSortOption;
 begin
  S.Read(N,SizeOf(N));
  S.Read(T,SizeOf(T));
  Saved   := TDoubleSortOption(T);
  Current := FSortType;
  Clear;
  SetSortType(DoubleSortNone);
  SetCount(N);
  S.Read(FList^,N * SizeOf(Double));
  if KeepCurrentSortType and (Current <> Saved)
     then SetSortType(Current)
     else FSortType := Saved; 
 end;

{---------------------------------------------------------}

procedure TDoubleList.LoadFromFile(FileName:string;
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

procedure TDoubleList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) 
   then raise EListError.Create(
                   ErrMsg(SListIndexError, Index));
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(Double));
end;

{---------------------------------------------------------}

function  TDoubleList.ErrMsg(const Msg:string;
                                   Data:Integer):string;
begin
  Result := Format(Msg,[Data]); 
end;                                   

{---------------------------------------------------------}

procedure TDoubleList.Exchange
                                 (Index1, Index2: Integer);
var
  Item: Double;
begin
  if FSortType <> DoubleSortNone 
     then raise EListError.Create(
                     ErrMsg(SDoubleListSortError,0));
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

function  TDoubleList.Expand: TDoubleList;
begin
  if FCount = FCapacity then Grow;
  Result := Self;
end;

{---------------------------------------------------------}

function  TDoubleList.First: Double;
begin
  Result := Get(0);
end;

{---------------------------------------------------------}

function  TDoubleList.Get
                            (Index: Integer): Double;
begin
  if (Index < 0) or (Index >= FCount) 
     then raise EListError.Create(
                     ErrMsg(SListIndexError, Index));
  Result := FList^[Index];
end;

{---------------------------------------------------------}

procedure TDoubleList.Grow;
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

procedure TDoubleList.ForceInsert(Index: Integer; 
                                        Item: Double);
begin
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(Double));
  FList^[Index] := Item;
  Inc(FCount);
end;

{---------------------------------------------------------}

procedure TDoubleList.Insert(Index: Integer; 
                                   Item: Double);
begin
  if FSortType <> DoubleSortNone 
     then raise EListError.Create(
                     ErrMsg(SDoubleListSortError,0));
  if (Index < 0) or (Index > FCount) 
     then raise EListError.Create(
                     ErrMsg(SListIndexError, Index));
  ForceInsert(Index,Item);
end;

{---------------------------------------------------------}

function  TDoubleList.Last: Double;
begin
  Result := Get(FCount - 1);
end;

{---------------------------------------------------------}

procedure TDoubleList.Move(CurIndex, 
                                 NewIndex: Integer);
var
  Item: Double;
begin
  if FSortType <> DoubleSortNone 
     then raise EListError.Create(
                     ErrMsg(SDoubleListSortError,0));
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

procedure TDoubleList.Put(Index: Integer; 
                                Item: Double);
begin
  if (Index < 0) or (Index >= FCount) 
     then raise EListError.Create(
                     ErrMsg(SListIndexError, Index));
  FList^[Index] := Item;
end;

{---------------------------------------------------------}

function  TDoubleList.Remove
                             (Item: Double): Integer;
begin
  Result := IndexOf(Item);
  if Result <> -1 then Delete(Result);
end;

{---------------------------------------------------------}

procedure TDoubleList.Pack(NilValue:Double);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 
      do if Items[I] = NilValue 
            then Delete(I);
end;

{---------------------------------------------------------}

procedure TDoubleList.SetCapacity(AValue: Integer);
begin
  if (AValue < FCount) 
  or (AValue > MaxDoubleListSize) 
     then raise EListError.Create(
                  ErrMsg(SListCapacityError, AValue));
  if AValue <> FCapacity 
     then begin
           ReallocMem(FList, 
                      AValue * SizeOf(Double));
           FCapacity := AValue;
          end;
end;

{---------------------------------------------------------}

procedure TDoubleList.SetCount(AValue: Integer);
begin
  if (AValue < 0) 
  or (AValue > MaxDoubleListSize) 
     then raise EListError.Create(
                     ErrMsg(SListCountError, AValue));
  if AValue > FCapacity 
     then SetCapacity(AValue);
  if AValue > FCount 
     then FillChar((@FList^[FCount])^, 
            (AValue - FCount) * SizeOf(Double), 0);
  FCount := AValue;
end;

{---------------------------------------------------------}

procedure QuickSort(SortList: PDoublePtrList; 
                    L, R: Integer;
  SCompare: TDoubleListSortCompare);
var
  I, J: Integer;
  P, T: Double;
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

procedure TDoubleList.Sort
                   (Compare: TDoubleListSortCompare);
begin
  if (FList <> nil) and (Count > 0) 
     then QuickSort(FList, 0, Count - 1, Compare);
end;

{---------------------------------------------------------}

procedure QuickSortUp(SortList: PDoublePtrList; 
                      L, R: Integer);
var
  I, J: Integer;
  P, T: Double;
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

procedure TDoubleList.SortUp;
begin
  if (FList <> nil) and (Count > 0) then
   begin
    QuickSortUp(FList, 0, Count - 1);
    FSortType := DoubleSortNone
   end;
end;

{---------------------------------------------------------}

procedure QuickSortDown(SortList: PDoublePtrList; 
                        L, R: Integer);
var
  I, J: Integer;
  P, T: Double;
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

procedure TDoubleList.SortDown;
begin
  if (FList <> nil) and (Count > 0) then
   begin
    QuickSortDown(FList, 0, Count - 1);
    FSortType := DoubleSortNone
   end;
end;

{---------------------------------------------------------}

procedure TDoubleList.ShowList(StringList:TStrings;
                  Descriptor:TDoubleDescriptor=nil;
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
           do Add(DefDescDouble(I,FList^[I]));
   EndUpdate;
  end;
end;

{---------------------------------------------------------}

procedure TDoubleList.Push(Value:Double);
 begin
  Add(Value);
 end;

{---------------------------------------------------------}

function  TDoubleList.LifoPop
                      (DefValue:Double):Double;
 begin
  if Count=0 then Result := DefValue
             else begin
                   Result := Last;
                   Delete(Count - 1);
                  end;
 end;

{---------------------------------------------------------}

function  TDoubleList.FifoPop
                      (DefValue:Double):Double;
 begin
  if Count=0 then Result := DefValue
             else begin
                   Result := First;
                   Delete(0);
                  end;
 end;

{---------------------------------------------------------}

function  TDoubleList.Minimum:Double;
 var I:Integer;
 begin
  Result := 0;
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SDoubleListVoidError,0));
  case FSortType of

       DoubleSortNone: 
         begin
           Result := FList^[0];
           for I:=1 to FCount-1 do
               if FList^[I]<Result 
                  then Result := FList^[I];
         end;
         
       DoubleSortUpWithDup,
       DoubleSortUpNoDup:
         begin 
           Result := FList^[0];
         end;
           
       DoublesortDownWithDup,
       DoublesortDownNoDup: 
         begin
           Result := FList^[FCount - 1];
         end;
           
      end;
 end;

{---------------------------------------------------------}

function  TDoubleList.Maximum:Double;
 var I:Integer;
 begin
  Result := 0;
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SDoubleListVoidError,0));
  case FSortType of

       DoubleSortNone: 
         begin
           Result := FList^[0];
           for I:=1 to FCount-1 
               do if FList^[I]>Result 
                  then Result := FList^[I];
         end;

       DoubleSortUpWithDup,
       DoubleSortUpNoDup: 
         Result := FList^[FCount - 1];

       DoublesortDownWithDup,
       DoublesortDownNoDup: 
         Result := FList^[0];
         
      end;
 end;

{---------------------------------------------------------}

function  TDoubleList.Range:Double;
 var I:Integer;Min,Max,Item:Double;
 begin
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SDoubleListVoidError,0));
  if FSortType = DoubleSortNone 
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

function  TDoubleList.Sum:Extended;
 var I:Integer;
 begin
  Result:=0;
  for I:=0 to FCount-1 
      do Result := Result + FList^[I];
 end;

{---------------------------------------------------------}

function  TDoubleList.SumSqr:Extended;
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

function  TDoubleList.Average:Extended;
 begin
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SDoubleListVoidError,0));
  Result := (Sum / FCount);
 end;

{---------------------------------------------------------}

procedure TDoubleList.CopyFrom(List:TDoubleList;
                   const KeepCurrentSortType:Boolean=false);
 var Current : TDoubleSortOption;
 begin
  Current := FSortType;
  Clear;
  SetSortType(DoubleSortNone);
  SetCount(List.Count);
  System.Move(List.List^, FList^,
              List.Count*SizeOf(Double));
  if KeepCurrentSortType and (Current <> List.SortType)
     then SetSortType(Current)
     else FSortType := List.SortType;
 end;

{---------------------------------------------------------}

procedure TDoubleList.CopyTo(List:TDoubleList;
                    const KeepDestSortType:Boolean=false);
 begin
  List.CopyFrom(Self,KeepDestSortType);
 end;

{---------------------------------------------------------}

function  TDoubleList.NormalFind
                           (Value: Double): Integer;
begin
  Result := 0;
  while (Result < FCount) and (FList^[Result] <> Value) 
        do Inc(Result);
  if Result = FCount then Result := -1;
end;

{---------------------------------------------------------}

function  TDoubleList.FastFindUp(Value:Double;
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

function  TDoubleList.FastFindDown(Value:Double;
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

function  TDoubleList.IndexOf
                            (Value: Double): Integer;
 var P:Integer;
 begin
  Result := -1;
  case FSortType of
       DoubleSortNone: 
         Result := NormalFind(Value);

       DoubleSortUpWithDup,
       DoubleSortUpNoDup: 
         Result := FastFindUp(Value,P);

       DoublesortDownWithDup,
       DoublesortDownNoDup: 
         Result := FastFindDown(Value,P);
      end;
 end;

{---------------------------------------------------------}

function  TDoubleList.Add
                             (Item: Double): Integer;
 var P:Integer;
 begin
  Result := -1;
  case FSortType of
       DoubleSortNone: 
                         begin
                          Result := NormalAdd(Item);
                         end;
       DoubleSortUpWithDup: 
                         begin
                          FastFindUp(Item,P);
                          ForceInsert(P,Item);
                          Result := P;
                         end;
       DoubleSortUpNoDup: 
                         begin
                          if FastFindUp(Item,P) = -1 
                             then begin 
                                   ForceInsert(P,Item);
                                   Result:=P 
                                  end;
                         end;
       DoubleSortDownWithDup:
                         begin
                          FastFindDown(Item,P);
                          ForceInsert(P,Item);
                          Result := P;
                         end;
       DoubleSortDownNoDup: 
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

procedure TDoubleList.EliminateDups;
 var I:Integer;
 begin 
  I:=0;
  while I < Count - 1 do
    if FList^[I + 1] = FList^[I]
	 then Delete(I) else Inc(I);
 end;

{---------------------------------------------------------}

procedure TDoubleList.SetSortType
                     (NewSortType:TDoubleSortOption);
 begin 
  if NewSortType = FSortType then exit;
  case NewSortType of

       DoubleSortNone: 
         begin
         end;

       DoubleSortUpWithDup: 
         begin
           if FSortType <> DoubleSortUpNoDup 
              then SortUp;
         end;

       DoubleSortUpNoDup: 
         begin
           if FSortType <> DoubleSortUpWithDup 
              then SortUp;
           EliminateDups;
         end;

       DoubleSortDownWithDup:
         begin
           if FSortType <> DoubleSortDownNoDup 
              then SortDown;
         end;

       DoubleSortDownNoDup: 
         begin
           if FSortType <> DoubleSortDownWithDup 
              then SortDown;
           EliminateDups;
         end;

      end;
  FSortType := NewSortType;
 end;
 
{---------------------------------------------------------}

END.