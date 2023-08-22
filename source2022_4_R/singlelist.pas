(*********************************************************)
(***)                                                 (***)
(***)              UNIT SingleList;                   (***)
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
(* TSingleList (v1.31)                                   *)
(* ----------------------------------------------------- *)
(* Implements a powerful class encapsulating a list      *)
(* of "Single", with additional features compared to     *)
(* conventional TList.                                   *)
(* Study the source code for the complete list           *)
(* of features.                                          *)
(* Compilable with any version of Delphi 32/64-bit,      *)
(* and also with Lazarus / Free Pascal.                  *)
(* ----------------------------------------------------- *)
(* Implémente une puissante classe encapsulant une liste *)
(* d'éléments "Single", avec des fonctionnalités         *) 
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
 MaxSingleListSize = Maxint div SizeOf(Single);

 SSingleListVoidError='Invalid method call (empty list)!';
 SSingleListSortError='Invalid method call (sorted list)!';

type
  PSinglePtrList 
   = ^TSinglePtrList;
  
  TSinglePtrList 
   = array[0..MaxSingleListSize - 1] of Single;
  
  TSingleListSortCompare 
   = function (Item1, Item2: Single): Integer;
  
  TSingleDescriptor 
   = function (Index:Integer;Item : Single) : string;

  TSingleSortOption 
   = (
      SingleSortNone,
      SingleSortUpWithDup,
      SingleSortUpNoDup,
      SingleSortDownWithDup,
      SingleSortDownNoDup      
     );

  TSingleListClass = class(TObject)
  private
    FList       : PSinglePtrList;
    FCount      : Integer;
    FCapacity   : Integer;
    FSortType   : TSingleSortOption;
  protected
    function  Get(Index: Integer): Single;
    procedure Grow; virtual;
    procedure Put(Index: Integer; Item: Single);
    procedure SetCapacity(AValue: Integer);
    procedure SetCount(AValue: Integer);
    procedure SetSortType
                  (NewSortType: TSingleSortOption);
    procedure EliminateDups;
    function  NormalFind(Value: Single): Integer;
    function  FastFindUp(Value:Single;
                  var Position:Integer):Integer;
    function  FastFindDown(Value:Single;
                  var Position:Integer):Integer;
    procedure ForceInsert(Index: Integer; Item: Single);
    function  NormalAdd(Item: Single): Integer;

  public
    constructor Create;
    destructor Destroy; override;
    function  Add(Item: Single): Integer;
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
    function  Expand: TSingleListClass;
    function  First: Single;
    function  IndexOf(Value: Single): Integer;
    procedure Insert(Index: Integer; Item: Single);
    function  Last: Single;
    procedure Move(CurIndex, NewIndex: Integer);
    function  Remove(Item: Single): Integer;
    procedure Pack(NilValue:Single);
    procedure Sort(Compare: TSingleListSortCompare);
    procedure SortUp;
    procedure SortDown;
    procedure ShowList(StringList:TStrings;
                  Descriptor:TSingleDescriptor=nil;
                  ClearIt:Boolean=true);

    function  Minimum:Single;
    function  Maximum:Single;
    function  Range:Single;
    function  Sum:Extended;
    function  SumSqr:Extended;
    function  Average:Extended;
    procedure CopyFrom(List:TSingleListClass;
                  const KeepCurrentSortType:Boolean=false);
    procedure CopyTo(List:TSingleListClass;
                  const KeepDestSortType:Boolean=false);

    procedure Push(Value:Single);
    function  LifoPop(DefValue:Single):Single;
    function  FifoPop(DefValue:Single):Single;

    property  List: PSinglePtrList read FList;
    property  Capacity: Integer 
                  read FCapacity 
                  write SetCapacity;
    property  Count: Integer 
                  read FCount 
                  write SetCount;
    property  Items[Index: Integer]: Single 
                  read Get 
                  write Put; default;
    property  SortType:TSingleSortOption 
                  read FSortType 
                  write SetSortType;
  end;


// Default descriptor - Descripteur par défaut (ShowList)
function DefDesc(Index: Integer;Item: Single) : string;


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

function DefDesc(Index: Integer;Item: Single) : string;
 begin
  Result:=Format('Items[%d] = %g',[Index,Item]);
 end;

{---------------------------------------------------------}

constructor TSingleListClass.Create;
begin
  inherited Create;
  FSortType := SingleSortNone;
end;

{---------------------------------------------------------}

destructor TSingleListClass.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{---------------------------------------------------------}

function  TSingleListClass.NormalAdd
                             (Item: Single): Integer;
begin
  Result := FCount;
  if Result = FCapacity then Grow;
  FList^[Result] := Item;
  Inc(FCount);
end;

{---------------------------------------------------------}

procedure TSingleListClass.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

{---------------------------------------------------------}

procedure TSingleListClass.SaveToStream(const S:TStream);
 var T : Integer;
 begin
  T := Integer(FSortType);
  S.Write(FCount,SizeOf(FCount));
  S.Write(T,SizeOf(T));
  S.Write(FList^,FCount * SizeOf(Single));
 end;

{---------------------------------------------------------}

procedure TSingleListClass.SaveToFile(FileName:string);
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

procedure TSingleListClass.LoadFromStream(const S:TStream;
                  const KeepCurrentSortType:Boolean=false);
 var N, T    : Integer;
     Current : TSingleSortOption;
     Saved   : TSingleSortOption;
 begin
  S.Read(N,SizeOf(N));
  S.Read(T,SizeOf(T));
  Saved   := TSingleSortOption(T);
  Current := FSortType;
  Clear;
  SetSortType(SingleSortNone);
  SetCount(N);
  S.Read(FList^,N * SizeOf(Single));
  if KeepCurrentSortType and (Current <> Saved)
     then SetSortType(Current)
     else FSortType := Saved; 
 end;

{---------------------------------------------------------}

procedure TSingleListClass.LoadFromFile(FileName:string;
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

procedure TSingleListClass.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) 
   then raise EListError.Create(
                   ErrMsg(SListIndexError, Index));
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(Single));
end;

{---------------------------------------------------------}

function  TSingleListClass.ErrMsg(const Msg:string;
                                   Data:Integer):string;
begin
  Result := Format(Msg,[Data]); 
end;                                   

{---------------------------------------------------------}

procedure TSingleListClass.Exchange
                                 (Index1, Index2: Integer);
var
  Item: Single;
begin
  if FSortType <> SingleSortNone 
     then raise EListError.Create(
                     ErrMsg(SSingleListSortError,0));
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

function  TSingleListClass.Expand: TSingleListClass;
begin
  if FCount = FCapacity then Grow;
  Result := Self;
end;

{---------------------------------------------------------}

function  TSingleListClass.First: Single;
begin
  Result := Get(0);
end;

{---------------------------------------------------------}

function  TSingleListClass.Get
                            (Index: Integer): Single;
begin
  if (Index < 0) or (Index >= FCount) 
     then raise EListError.Create(
                     ErrMsg(SListIndexError, Index));
  Result := FList^[Index];
end;

{---------------------------------------------------------}

procedure TSingleListClass.Grow;
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

procedure TSingleListClass.ForceInsert(Index: Integer;
                                        Item: Single);
begin
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(Single));
  FList^[Index] := Item;
  Inc(FCount);
end;

{---------------------------------------------------------}

procedure TSingleListClass.Insert(Index: Integer;
                                   Item: Single);
begin
  if FSortType <> SingleSortNone 
     then raise EListError.Create(
                     ErrMsg(SSingleListSortError,0));
  if (Index < 0) or (Index > FCount) 
     then raise EListError.Create(
                     ErrMsg(SListIndexError, Index));
  ForceInsert(Index,Item);
end;

{---------------------------------------------------------}

function  TSingleListClass.Last: Single;
begin
  Result := Get(FCount - 1);
end;

{---------------------------------------------------------}

procedure TSingleListClass.Move(CurIndex,
                                 NewIndex: Integer);
var
  Item: Single;
begin
  if FSortType <> SingleSortNone 
     then raise EListError.Create(
                     ErrMsg(SSingleListSortError,0));
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

procedure TSingleListClass.Put(Index: Integer;
                                Item: Single);
begin
  if (Index < 0) or (Index >= FCount) 
     then raise EListError.Create(
                     ErrMsg(SListIndexError, Index));
  FList^[Index] := Item;
end;

{---------------------------------------------------------}

function  TSingleListClass.Remove
                             (Item: Single): Integer;
begin
  Result := IndexOf(Item);
  if Result <> -1 then Delete(Result);
end;

{---------------------------------------------------------}

procedure TSingleListClass.Pack(NilValue:Single);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 
      do if Items[I] = NilValue 
            then Delete(I);
end;

{---------------------------------------------------------}

procedure TSingleListClass.SetCapacity(AValue: Integer);
begin
  if (AValue < FCount) 
  or (AValue > MaxSingleListSize) 
     then raise EListError.Create(
                  ErrMsg(SListCapacityError, AValue));
  if AValue <> FCapacity 
     then begin
           ReallocMem(FList, 
                      AValue * SizeOf(Single));
           FCapacity := AValue;
          end;
end;

{---------------------------------------------------------}

procedure TSingleListClass.SetCount(AValue: Integer);
begin
  if (AValue < 0) 
  or (AValue > MaxSingleListSize) 
     then raise EListError.Create(
                     ErrMsg(SListCountError, AValue));
  if AValue > FCapacity 
     then SetCapacity(AValue);
  if AValue > FCount 
     then FillChar((@FList^[FCount])^, 
            (AValue - FCount) * SizeOf(Single), 0);
  FCount := AValue;
end;

{---------------------------------------------------------}

procedure QuickSort(SortList: PSinglePtrList; 
                    L, R: Integer;
  SCompare: TSingleListSortCompare);
var
  I, J: Integer;
  P, T: Single;
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

procedure TSingleListClass.Sort
                   (Compare: TSingleListSortCompare);
begin
  if (FList <> nil) and (Count > 0) 
     then QuickSort(FList, 0, Count - 1, Compare);
end;

{---------------------------------------------------------}

procedure QuickSortUp(SortList: PSinglePtrList; 
                      L, R: Integer);
var
  I, J: Integer;
  P, T: Single;
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

procedure TSingleListClass.SortUp;
begin
  if (FList <> nil) and (Count > 0) then
   begin
    QuickSortUp(FList, 0, Count - 1);
    FSortType := SingleSortNone
   end;
end;

{---------------------------------------------------------}

procedure QuickSortDown(SortList: PSinglePtrList; 
                        L, R: Integer);
var
  I, J: Integer;
  P, T: Single;
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

procedure TSingleListClass.SortDown;
begin
  if (FList <> nil) and (Count > 0) then
   begin
    QuickSortDown(FList, 0, Count - 1);
    FSortType := SingleSortNone
   end;
end;

{---------------------------------------------------------}

procedure TSingleListClass.ShowList(StringList:TStrings;
                  Descriptor:TSingleDescriptor=nil;
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
           do Add(DefDesc(I,FList^[I]));
   EndUpdate;
  end;
end;

{---------------------------------------------------------}

procedure TSingleListClass.Push(Value:Single);
 begin
  Add(Value);
 end;

{---------------------------------------------------------}

function  TSingleListClass.LifoPop
                      (DefValue:Single):Single;
 begin
  if Count=0 then Result := DefValue
             else begin
                   Result := Last;
                   Delete(Count - 1);
                  end;
 end;

{---------------------------------------------------------}

function  TSingleListClass.FifoPop
                      (DefValue:Single):Single;
 begin
  if Count=0 then Result := DefValue
             else begin
                   Result := First;
                   Delete(0);
                  end;
 end;

{---------------------------------------------------------}

function  TSingleListClass.Minimum:Single;
 var I:Integer;
 begin
  Result := 0;
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SSingleListVoidError,0));
  case FSortType of

       SingleSortNone: 
         begin
           Result := FList^[0];
           for I:=1 to FCount-1 do
               if FList^[I]<Result 
                  then Result := FList^[I];
         end;
         
       SingleSortUpWithDup,
       SingleSortUpNoDup:
         begin 
           Result := FList^[0];
         end;
           
       SinglesortDownWithDup,
       SinglesortDownNoDup: 
         begin
           Result := FList^[FCount - 1];
         end;
           
      end;
 end;

{---------------------------------------------------------}

function  TSingleListClass.Maximum:Single;
 var I:Integer;
 begin
  Result := 0;
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SSingleListVoidError,0));
  case FSortType of

       SingleSortNone: 
         begin
           Result := FList^[0];
           for I:=1 to FCount-1 
               do if FList^[I]>Result 
                  then Result := FList^[I];
         end;

       SingleSortUpWithDup,
       SingleSortUpNoDup: 
         Result := FList^[FCount - 1];

       SinglesortDownWithDup,
       SinglesortDownNoDup: 
         Result := FList^[0];
         
      end;
 end;

{---------------------------------------------------------}

function  TSingleListClass.Range:Single;
 var I:Integer;Min,Max,Item:Single;
 begin
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SSingleListVoidError,0));
  if FSortType = SingleSortNone 
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

function  TSingleListClass.Sum:Extended;
 var I:Integer;
 begin
  Result:=0;
  for I:=0 to FCount-1 
      do Result := Result + FList^[I];
 end;

{---------------------------------------------------------}

function  TSingleListClass.SumSqr:Extended;
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

function  TSingleListClass.Average:Extended;
 begin
  if FCount=0 
     then raise EListError.Create(
                     ErrMsg(SSingleListVoidError,0));
  Result := (Sum / FCount);
 end;

{---------------------------------------------------------}

procedure TSingleListClass.CopyFrom(List:TSingleListClass;
                   const KeepCurrentSortType:Boolean=false);
 var Current : TSingleSortOption;
 begin
  Current := FSortType;
  Clear;
  SetSortType(SingleSortNone);
  SetCount(List.Count);
  System.Move(List.List^, FList^,
              List.Count*SizeOf(Single));
  if KeepCurrentSortType and (Current <> List.SortType)
     then SetSortType(Current)
     else FSortType := List.SortType;
 end;

{---------------------------------------------------------}

procedure TSingleListClass.CopyTo(List:TSingleListClass;
                    const KeepDestSortType:Boolean=false);
 begin
  List.CopyFrom(Self,KeepDestSortType);
 end;

{---------------------------------------------------------}

function  TSingleListClass.NormalFind
                           (Value: Single): Integer;
begin
  Result := 0;
  while (Result < FCount) and (FList^[Result] <> Value) 
        do Inc(Result);
  if Result = FCount then Result := -1;
end;

{---------------------------------------------------------}

function  TSingleListClass.FastFindUp(Value:Single;
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

function  TSingleListClass.FastFindDown(Value:Single;
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

function  TSingleListClass.IndexOf
                            (Value: Single): Integer;
 var P:Integer;
 begin
  Result := -1;
  case FSortType of
       SingleSortNone: 
         Result := NormalFind(Value);

       SingleSortUpWithDup,
       SingleSortUpNoDup: 
         Result := FastFindUp(Value,P);

       SinglesortDownWithDup,
       SinglesortDownNoDup: 
         Result := FastFindDown(Value,P);
      end;
 end;

{---------------------------------------------------------}

function  TSingleListClass.Add
                             (Item: Single): Integer;
 var P:Integer;
 begin
  Result := -1;
  case FSortType of
       SingleSortNone: 
                         begin
                          Result := NormalAdd(Item);
                         end;
       SingleSortUpWithDup: 
                         begin
                          FastFindUp(Item,P);
                          ForceInsert(P,Item);
                          Result := P;
                         end;
       SingleSortUpNoDup: 
                         begin
                          if FastFindUp(Item,P) = -1 
                             then begin 
                                   ForceInsert(P,Item);
                                   Result:=P 
                                  end;
                         end;
       SingleSortDownWithDup:
                         begin
                          FastFindDown(Item,P);
                          ForceInsert(P,Item);
                          Result := P;
                         end;
       SingleSortDownNoDup: 
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

procedure TSingleListClass.EliminateDups;
 var I:Integer;
 begin 
  I:=0;
  while I < Count - 1 do
    if FList^[I + 1] = FList^[I]
	 then Delete(I) else Inc(I);
 end;

{---------------------------------------------------------}

procedure TSingleListClass.SetSortType
                     (NewSortType:TSingleSortOption);
 begin 
  if NewSortType = FSortType then exit;
  case NewSortType of

       SingleSortNone: 
         begin
         end;

       SingleSortUpWithDup: 
         begin
           if FSortType <> SingleSortUpNoDup 
              then SortUp;
         end;

       SingleSortUpNoDup: 
         begin
           if FSortType <> SingleSortUpWithDup 
              then SortUp;
           EliminateDups;
         end;

       SingleSortDownWithDup:
         begin
           if FSortType <> SingleSortDownNoDup 
              then SortDown;
         end;

       SingleSortDownNoDup: 
         begin
           if FSortType <> SingleSortDownWithDup 
              then SortDown;
           EliminateDups;
         end;

      end;
  FSortType := NewSortType;
 end;
 
{---------------------------------------------------------}

END.