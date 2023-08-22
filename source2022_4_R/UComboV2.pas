Unit UcomboV2;

{Updated to handle larger combo counts by use 64 bit integers and calling the
 Mathslib 64 bit random number generator  11/19/2013  - GDD}


 {Copyright 2002-2013, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

  Revisions:
  Copyright (C) 2004, 2005 Charles Doumar

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Combo unit contains an object which provides an array of combinations
  or permutations of 'r' of 'n' numbers.

  Permutations are all subsets selecting r of n, combinations are the
  unique subsets.

  To use the Comboset object, call Combos.Setup(r,n,Combotype) where

    r is subset size;

    n is the size of the set to select from (current max is 100),

    Ctype is a variable specifying combinations or permutations.
       Combinations ==> return combinations (unique subsets)
       Permutations ==> return all subsets (permutations)

   Other procedures are:

     GetNext - gets next combination or permutation based on Ctype.
        Subsets are in 'Selected' array. GetNext returns false when
        no more subsets are available.

        Note: GetNextCombo and GetNextPermute may be called directly
              for efficiency.  But do not mix calls to these two routines.

     GetCount - return number of subsets that will be returned.

  }

interface

const
  MaxEntries = 600;

type
  TByteArray64  = array[0..MaxEntries + 1] of int64;
  ByteArray = TByteArray64;
  TCombotype = (Combinations,  {Lexicographical order up}
    Permutations,              {Lexicographical order up}
    CombinationsDown,          {Lexicographical order down}
    PermutationsDown,          {Lexicographical order down}
    CombinationsCoLex,         {Co-Lexicographical order up}
    CombinationsCoLexDown,     {Co-Lexicographical order down}
    PermutationsRepeat,        {Lexicographical order up}
    PermutationsWithRep,
    PermutationsRepeatDown,    {Lexicographical order down}
    CombinationsWithrep,
    CombinationsRepeat,        {Lexicographical order up}
    CombinationsRepeatDown);   {Lexicographical order down}

  TComboSet = class(TObject)
  private
    N: word;
    R: word;
    NumberOfSubsets: int64;
    Ctype: TComboType; {Generate Combinations or permutations}
    Loops: bytearray;  {for efficiency, truncate search at loops for
                             each position, e.g. if n=10, then leftmost
                             has 10 of 10, for each of these, next position
                             has 9, next 8, etc. }

    {NEW PRIVATE FUNCTIONS ADDED BY CHARLES DOUMAR}
    procedure ClearArrays;
    {******************** Setup First Procedures ********************}
    {Sets first combinatorial sequence}
    procedure SetupFirstCoLexRCombo;
    procedure SetupFirstLexRCombo;
    procedure SetupFirstLexRepRCombo;
    procedure SetupFirstLexRPermute;
    procedure SetupFirstLexRepRPermute;
    {******************** Setup Last Procedures ********************}
    {Sets last combinatorial sequence}
    procedure SetupLastCoLexRCombo;
    procedure SetupLastLexRCombo;
    procedure SetupLastLexRepRCombo;
    procedure SetupLastLexRPermute;
    procedure SetupLastLexRepRPermute;
    {******************** Setup Next Procedures ********************}
    procedure SetupNextCoLexRCombo;
    procedure SetupNextLexRCombo;
    procedure SetupNextLexRepRCombo;
    procedure SetupNextLexRPermute;
    procedure SetupNextLexRepRPermute;
    {******************** Setup Prev Procedures ********************}
    procedure SetupPrevCoLexRCombo;
    procedure SetupPrevLexRCombo;
    procedure SetupPrevLexRepRCombo;
    procedure SetupPrevLexRPermute;
    procedure SetupPrevLexRepRPermute;
    {******************** Valid Function *********************}
    function IsValidRN(const RPick,Number:integer;const ACtype:TComboType):boolean;
    function IsValidRNRank(const RPick,Number:integer;Rank:int64;const ACtype:TComboType):boolean;
    procedure SetError;

  public
    Selected: ByteArray;
    RandomRank : int64; {Result from various random rank calls}
    {Setup to retrieve R of N objects}

    procedure Setup(newR, newN: word; NewCtype: TComboType); {Replaced by SetupR}

    function Getnext: boolean;  {Replaced by GetNextPrevR, NextR, PrevR}
    function GetNextCombo: boolean; {Replaced by NextLexRCombo}
    function GetNextPermute: boolean; {Replaced by NextLexRPermute}
    Function GetNextComboWithRep:Boolean;
    Function GetNextPermuteWithRep:Boolean;
    function GetCount: int64;
    function GetR: integer;

    {NEW PUBLIC FUNCTIONS ADDED BY CHARLES DOUMAR}
    function GetN: integer;
    function GetCtype: TCombotype;


    {******************** Misc Calculator Functions ********************}
    {Returns number of unique sequences for a particular TComboType}
    function GetNumberSubsets(const RPick, Number : word; const ACtype : TComboType):int64;
    {Returns binomial value}
    function Binomial(const RPick, Number: integer): int64;
    {Returns factorial value}
    function Factorial(const Number: integer): int64;
    {Returns number of r-combinations}
    function GetRCombo(const RPick, Number: integer): int64;
    {Returns number of r-combinations with repetition}
    function GetRepRCombo(const RPick, Number: integer): int64;
    {Returns number of r-permutations}
    function GetRPermute(const RPick, Number: integer): int64;
    {Returns number of r-permutations with repetition}
    function GetRepRPermute(const RPick, Number: integer): int64;

    {******************** Main Setup Procedures ********************}
    {Replaces Setup and set Array to position before first/last position}
    procedure SetupR(NewR, NewN: word; NewCtype: TComboType);
    {Replaces Setup but set Array to first/last valid position}
    procedure SetupRFirstLast(NewR, NewN: word; NewCType: TComboType);

    {****************** Checking Functions ********************}
    {Returns True if combinatorial sequence is valid}
    function IsValidRSequence: boolean;

    {******************** DIRECTIONAL PROCEDURES ********************}
    {Change iterative direction}
    function ChangeRDirection: boolean;
    {Replaces GetNext}
    function GetNextPrevR: boolean;

    {******************** Next Functions ********************}
    {Returns next combinatorial position (if any) and returns boolean result}
    function NextR: boolean;
    function NextLexRPermute: boolean;  {replaces GetNextPermute}
    function NextLexRepRPermute: boolean;
    function NextLexRCombo: boolean;    {replaces GetNextCombo}
    function NextLexRepRCombo: boolean;
    function NextCoLexRCombo: boolean;

    {******************** Prev Functions ********************}
    {Returns previous combinatorial position (if any) and returns boolean result}
    function PrevR: boolean;
    function PrevCoLexRCombo: boolean;
    function PrevLexRepRPermute: boolean;
    function PrevLexRPermute: boolean;
    function PrevLexRCombo: boolean;
    function PrevLexRepRCombo: boolean;

    {******************** Rank Functions ********************}
    {Returns rank of particular combinatorial sequence}
    function RankR: int64;
    function RankCoLexRCombo: int64;
    function RankLexRCombo: int64;
    function RankLexRepRCombo: int64;
    function RankLexRPermute: int64;
    function RankLexRepRPermute: int64;

    {******************** Unrank Functions ********************}
    {Returns combinatorial sequence from a particular rank}
    function UnRankR({const RPick, Number: integer; const NewCtype: TComboType; }
      const Rank: int64):boolean;
    function UnRankCoLexRCombo({const RPick, Number: integer;} const Rank: int64):boolean;
    function UnRankLexRCombo({const RPick, Number: integer;} const Rank: int64):boolean;
    function UnRankLexRepRCombo({const RPick, Number: integer;} const Rank: int64):boolean;
    function UnRankLexRPermute({const RPick, Number: integer;} const Rank: int64):boolean;
    function UnRankLexRepRPermute({const RPick, Number: integer;} const Rank: int64):boolean;

    {******************** Random Functions ********************}
    {Returns combinatorial sequence from a particular rank}
    function RandomR(const RPick, Number: int64; const NewCtype: TComboType):Boolean;
    function RandomCoLexRCombo(const RPick, Number: int64):Boolean;
    function RandomLexRCombo(const RPick, Number: int64):Boolean;
    function RandomLexRepRCombo(const RPick, Number: int64):Boolean;
    function RandomLexRPermute(const RPick, Number: int64):Boolean;
    function RandomLexRepRPermute(const RPick, Number: int64):Boolean;
  end;

var
  Combos: TComboSet;  {created at initialization time}

implementation

uses math, Windows, Dialogs, Mathslib{, UBigIntsV4};

var
  Count: int64;  {count of entries}


procedure TComboSet.SetError;
begin
   showmessage('Values for N, R, and selected type exceed max values');
   N:=0;
   R:=0;
end;

procedure TComboset.Setup(newR, newN: word; NewCtype: TComboType);
begin
  setupr(newR, newN, NewCtype);
  randomize64;
end;


function TComboset.GetNextPermute: boolean;
{Retained for compatibility - replaced by NextLexRPermute}
begin
  result:=nextLexRPermute;
end;

function Tcomboset.getNextcombo: boolean;
{Retained for compatibility - replaced by NextLexRCombo}
begin
  result:=nextlexRCombo;
end;


function Tcomboset.getnext;
{for compatibility - replaced by NextR}
begin
  result:=GetnextPrevR;
end;

function TComboset.Getcount: int64;
begin
  Result := NumberOfSubsets;
end;

function TComboset.GetR: integer;
begin
  Result := r;
end;

{NEW FUNCTIONS ADDED BY CHARLES DOUMAR}
function TComboset.GetN: integer;
begin
  Result := n;
end;

function TComboset.GetCType: TComboType;
begin
  Result := Ctype;
end;

 {******************** PRIVATE FUNCTION ********************}
procedure TComboSet.ClearArrays;
begin
  FillChar(Selected, SizeOf(Selected), 0); {quick clear array}
  FillChar(Loops, SizeOf(Loops), 0);
end;

 {******************** Setup (Private) Procedures ********************}
 {******************** Setup First Procedures ********************}
 {Function to set first value position in Selected and Loops array}
procedure TComboSet.SetupFirstCoLexRCombo;
begin
  SetupFirstLexRCombo;   {no reason to write it twice}
end;

procedure TComboSet.SetupFirstLexRCombo;
var
  i: integer;
begin
  for i := 1 to r do
  begin
    Selected[i] := i
  end;    {set to 1,2,3...}
end;

procedure TComboSet.SetupFirstLexRPermute;
var
  i: integer;
begin
  for i := 1 to r do
  begin
    Selected[i] := i;    {set to 1,2,3 ...}
    Loops[i]    := 1;    {set Loops array to 1,1,1...}
  end;
end;

procedure TComboSet.SetupFirstLexRepRCombo;
begin
  SetupFirstLexRepRPermute;
end;


procedure TComboSet.SetupFirstLexRepRPermute;
var
  i: integer;
begin
  for i := 1 to r do
  begin
    Selected[i] := 1
  end;   {set to 1,1,1 ...}
end;

 {******************** Setup Last Procedures ********************}
 {Functions to set last value position in Selected and Loops array}
procedure TComboSet.SetupLastCoLexRCombo;
begin
  SetupLastLexRCombo;
end;

procedure TComboSet.SetupLastLexRCombo;
var
  i: integer;
begin
  for i := 1 to r do
  begin
    Selected[i] := n - r + i
  end;    {setup in decreasing order}
end;

procedure TComboSet.SetupLastLexRPermute;
var
  i: integer;
begin
  for i := 1 to r do
  begin
    Selected[i]      := n - i + 1;
    Loops[n - i + 1] := 1;
  end;
end;

procedure TComboSet.SetupLastLexRepRCombo;
begin
  SetupLastLexRepRPermute;
end;

procedure TComboSet.SetupLastLexRepRPermute;
var
  i, k: integer;
begin
  k := n;
  for i := 1 to r do
    Selected[i] := k
end;

 {******************** Setup Next Procedures ********************}
 {Setup function to initialize Selected and Loops Array}
procedure TComboSet.SetupNextCoLexRCombo;
var
  i: integer;
begin
  for i := 1 to r do
    Selected[i] := i - 1
end;

procedure TComboSet.SetupNextLexRCombo;
var
  i: integer;
begin
  for i := 1 to r - 1 do
    Selected[i] := i;
  Selected[r] := r - 1;
end;

procedure TComboSet.SetupNextLexRepRCombo;
var
  i: integer;
begin
  for i := 1 to r - 1 do
    Selected[i] := 1;
  Selected[r] := 0;
end;

procedure TComboSet.SetupNextLexRepRPermute;
var
  i: integer;
begin
  for i := 1 to r - 1 do
    Selected[i] := 1;
  Selected[r] := 0;
end;

procedure TComboSet.SetupNextLexRPermute;
var
  i: integer;
begin
  Selected[1] := 0;
  Loops[0]    := 1;
  for i := 2 to r do
  begin
    Selected[i] := n - i + 2;
    Loops[Selected[i]] := 1;
  end;
end;

 {******************** Setup Perv Procedures ********************}
 {Setup function to initialize Selected and Loops Array}

procedure TComboSet.SetupPrevCoLexRCombo;
var
  i: integer;
begin
  for i := 1 to r - 1 do
    Selected[i] := i;
  Selected[r] := n + 1;
end;

procedure TComboSet.SetupPrevLexRCombo;
var
  i: integer;
begin
  for i := 1 to r do
    Selected[i] := i + n - r;
  Inc(Selected[r]);
end;

procedure TComboSet.SetupPrevLexRepRCombo;
begin
  SetupPrevLexRepRPermute;
end;

procedure TComboSet.SetupPrevLexRepRPermute;
var
  i: integer;
begin
  for i := 1 to r - 1 do
    Selected[i] := n;
  Selected[r] := n + 1;
end;

procedure TComboSet.SetupPrevLexRPermute;
var
  i: integer;
begin
  for i := 1 to r do
  begin
    Selected[i] := n - i + 1;
    Loops[Selected[i]] := 1;
  end;
  Loops[Selected[r]] := 0;
  Selected[r] := n + 1;
end;

{***********  Valid Functions *********}
function TComboSet.IsValidRN(const RPick,Number:integer;const ACtype:TComboType):boolean;

begin
  Result := false;
  if (RPick < 1) or (Number < 1) or
     ((RPick > Number) and (not(aCtype in [PermutationsRepeat,
     PermutationsWithrep, CombinationsWithRep,
     PermutationsRepeatDown, CombinationsRepeat,CombinationsWithrep,CombinationsRepeatDown]))) then
       exit;
  Result := True;
end;

function TComboSet.IsValidRNRank(const RPick,Number:integer;Rank:int64;const ACtype:TComboType):boolean;

begin
   Result := False;
   if (rank < 1) or not IsValidRN(RPick,Number,ACtype) then exit;
   case ACType of
   Combinations,
   CombinationsDown,
   CombinationsCoLex,
   CombinationsCoLexDown:  if (Rank > Binomial(RPick, Number)) then exit;
   CombinationsRepeat, CombinationsWithRep,
   CombinationsRepeatDown: if (Rank > GetRepRCombo(RPick,Number)) then exit;
   Permutations,
   PermutationsDown: if (Rank > GetRPermute(RPick,Number)) then exit;
   PermutationsRepeat, PermutationsWithRep,
   PermutationsRepeatDown:  if (Rank > GetRepRPermute(RPick,Number)) then exit;
   else
     exit;
   end;
   Result := True;
end;

 {******************** PUBLIC FUNCTIONS ********************}
 {******************** Misc Calculator Functions ********************}
function TComboSet.GetNumberSubsets(const RPick, Number : word; const ACtype : TComboType):int64;

begin
  case ACtype of
    Combinations,
    CombinationsDown,
    CombinationsCoLex,
    CombinationsCoLexDown  : Result := GetRCombo(RPick,Number);
    Permutations,
    PermutationsDown       : Result := GetRPermute(RPick,Number);
    PermutationsRepeat, PermutationsWithrep,
    PermutationsRepeatDown : Result := GetRepRPermute(RPick, Number);
    CombinationsRepeat, CombinationsWithRep,
    CombinationsRepeatDown : Result := GetRepRCombo(RPick, Number);
  else
    Result := 0;
  end;
end;


function TComboSet.Binomial(const RPick, Number: integer): int64;
begin
  Result := 0;
  if (Number > 0) and (Number >= RPick) then
    Result := GetRCombo(RPick, Number)
end;

function TComboSet.Factorial(const Number: integer): int64;
begin
  case Number of  {int64 can only hold 20! so precalculated to save time}
    2: Result := 2;
    3: Result := 6;
    4: Result := 24;
    5: Result := 120;
    6: Result := 720;
    7: Result := 5040;
    8: Result := 40320;
    9: Result := 362880;
    10: Result := 3628800;
    11: Result := 39916800;
    12: Result := 479001600;
    13: Result := 6227020800;
    14: Result := 87178291200;
    15: Result := 1307674368000;
    16: Result := 20922789888000;
    17: Result := 355687428096000;
    18: Result := 6402373705728000;
    19: Result := 121645100408832000;
    20: Result := 2432902008176640000;
    else
    begin
      Result := 1;
    end;
  end;
end;

function TComboSet.GetRCombo(const RPick, Number: integer): int64;
{This function is based on:
 ACM algorithm 160,Communications of the ACM, April, 1963.
}

var
  i:integer;
  f, nn, rr: int64;
  num: extended;
begin
  Result := 1;  {this function defaults to 1 use binomial}
  nn     := Number;
  rr     := RPick;
  num    := 1;
  try
    if (nn <= rr) then
    begin
      exit
    end;
    if (rr * 2 > nn) then
    begin
      rr := nn - rr
    end;
    for i := 1 to rr do
    begin
      f := nn;
      if (nn mod i = 0) then
      begin
        f := f div i
      end
      else
      begin
        num := num / i
      end;
      num := num * f;
      Dec(nn);
    end;
  except
    Seterror;
    num:=0;
    result:=0;
  end;
  Result := trunc(num + 0.5);
end;

function TComboSet.GetRepRCombo(const RPick, Number: integer): int64;
{Example how many different ways can you get a dozen of donuts assuming
30 different varieties ... GetRepRCombo(30,12)}
begin
  Result := GetRCombo(RPick, Number + RPick - 1);
end;

function TComboSet.GetRPermute(const RPick, Number: integer): int64;
begin
  { Permutation(n,r) = n! / (n-r)!
    Combination(n,r) = n! / ( (n-r)! * r! )
    Permutation(n,r) = Combination(n,r) * r!
    Permutation(n,r) = n! / ( (n-r)! * r! ) * r!}
  try
    Result := GetRCombo(RPick, Number) * Factorial(RPick);
  except
    Seterror;
  end;
end;

function TComboSet.GetRepRPermute(const RPick, Number: integer): int64;
var
  Val: extended;
begin
  Val := ln(Number + 0.0) * RPick;
  if (Val > 62.999999999) or (Val < ln(1)) then      {ensure value not too large}
    Result := 1
  else
    Result := trunc(exp(Val) + 0.5);
end;

 {******************** Next Functions ********************}
 {Functions to increment to next position (if any) and return boolean result}
function TComboSet.NextR: boolean;
begin {NextR}
  case Ctype of
    Combinations:
    begin
      Result := NextLexRCombo;    {Lexicographical order up}
      Inc(Count);
    end;
    Permutations:
    begin
      Result := NextLexRPermute;  {Lexicographical order up}
      Inc(Count);
    end;
    CombinationsCoLex:
    begin
      Result := NextCoLexRCombo;  {Co-Lexicographical order up}
      Inc(Count);
    end;
    CombinationsRepeat,CombinationsWithrep:
    begin
      Result := NextLexRepRCombo;
      inc(count);
    end;
    PermutationsRepeat, PermutationsWithRep:
    begin
      Result := NextLexRepRPermute;{Lexicographical order up}
      Inc(Count);
    end;
    else
    begin
      Result := False
    end;                                   {Error}
  end;
end;


function TComboSet.NextCoLexRCombo: boolean;
var
  i: integer;
begin
  if Selected[1] > (n - r) then  {check to see if final sequence}
  begin
    Result := False;
    exit;
  end;
  Result := True;
  i      := 1;          {start with first position}
  while (Selected[i + 1] - Selected[i]) = 1 do  {check if current position at max value}
  begin
    Selected[i] := i;   {reset to lowest value}
    Inc(i);             {increase position}
  end;
  Inc(Selected[i]);     {increase}
end;

function TComboSet.NextLexRCombo: boolean;
var
  k, g: integer;
begin
  Result := True;                {Set Default Value}
  k      := r;                   {assign local variable for speed}
  if Selected[k] < n then        {if not max then increase and exit}
  begin
    Inc(Selected[k]);
    exit;
  end;
  if Selected[1] > n - r then     {check to see if last combination}
  begin
    Result := False;
    exit;
  end;
  while (Selected[k] - Selected[k - 1]) = 1 do  {walk down chain}
    Dec(k);
  Inc(Selected[k - 1]);           {increase item}
  g := Selected[k - 1];           {set temp variable for speed}
  while k <= r do               {set all remaining values to previous value+1}
  begin
    Inc(g);
    Selected[k] := g;
    Inc(k);
  end;
end;

function TComboSet.NextLexRepRCombo: boolean;
var
  k, g: integer;
begin
  Result := True;                {Set Default Value}
  k      := r;                   {assign local variable for speed}
  if Selected[k] < n then        {if not max then increase and exit}
  begin
    Inc(Selected[k]);
    exit;
  end;
  if Selected[1] >= n then     {check to see if last combination}
  begin
    Result := False;
    exit;
  end;
  while (Selected[k] = Selected[k - 1])  do  {walk down chain}
    Dec(k);
  Inc(Selected[k - 1]);           {increase item}
  g := Selected[k - 1];           {set temp variable for speed}
  while k <= r do               {set all remaining values to previous value+1}
  begin
    Selected[k] := g;
    Inc(k);
  end;
end;


function TComboSet.NextLexRepRPermute: boolean;
var
  i, k: integer;
begin
  Result := True;
  k      := r;
  if Selected[k] < n then      {try to increase last item in sequence}
  begin
    Inc(Selected[k]);
    exit;
  end;
  while (Selected[k] = Selected[k - 1]) do {walk down chain}
    Dec(k);
  if k = 1 then              {check for end of sequence}
  begin
    Result := False;
    exit;
  end;
  Inc(Selected[k - 1]);          {increase position by one}
  for i := k to r do             {reset all other itmes}
    Selected[i] := 1
end;

function TComboSet.NextLexRPermute: boolean;
var
  i, j, k, IncPos: integer;
label
  BreakDoLoop;

begin
  Result := True;                       {set default result value}
  IncPos := r;                          {start with right most position}
  while True do
  begin
    i := Selected[IncPos] + 1;
    if i <= n then
    begin                                {find next unselected value if any}
      while Loops[i] = 1 do                {loop unrolled by factor of 5}
      begin
        if Loops[i + 1] = 1 then
        begin
          if Loops[i + 2] = 1 then
          begin
            if Loops[i + 3] = 1 then
            begin
              if Loops[i + 4] = 1 then
              begin
                Inc(i, 5)
              end
              else
              begin
                Inc(i, 4);
                break;
              end
            end
            else
            begin
              Inc(i, 3);
              break;
            end
          end
          else
          begin
            Inc(i, 2);
            break;
          end
        end
        else
        begin
          Inc(i);
          break;
        end
      end;

      if i <= n then                      {if value found is valid}
      begin
        Loops[Selected[IncPos]] := 0;     {mark old value as unused}
        Loops[i] := 1;                    {mark new value as used}
        Selected[IncPos] := i;            {place new value in Selected array}
        goto BreakDoLoop;                 {found solution}
      end;
    end;                                  {end if Selected}

(*  {old code unrolled for speed}
   for i := Selected[incpos]+1 to n do
    if loops[i] <> 1 then              {found smallest greater value not previously used}
    begin
     loops[Selected[incpos]] := 0;     {mark old value as unused}
     loops[i] := 1;                    {mark new value as used}
     Selected[incpos] := i;            {place new value in Selected array}
     goto breakdoloop;                 {found solution}
    end;
*)

    if IncPos > 1 then
      {could not find greater value so backup 1 and look again}
    begin
      Loops[Selected[IncPos]] := 0;     {mark old value as unused}
      Dec(IncPos);                      {backup 1 space}
    end
    else
    begin
      Result := False;                  {reached end of permutation}
      exit;
    end;
  end;
  BreakDoLoop:

    if IncPos < r then
      {need to fill remaining values in lexicographical order}
    begin
      k := 1;
      for j := IncPos + 1 to r do       {for each remaining value}
      begin
        {          while loops[k] = 1 do inc(k);}
        {      unroll loop by a factor of 5 for speed}
        while True do              {find next lexicographical value}
        begin
          if Loops[k] = 1 then
          begin
            if Loops[k + 1] = 1 then
            begin
              if Loops[k + 2] = 1 then
              begin
                if Loops[k + 3] = 1 then
                begin
                  if Loops[k + 4] = 1 then
                  begin
                    Inc(k, 5)
                  end
                  else
                  begin
                    Inc(k, 4);
                    break;
                  end
                end
                else
                begin
                  Inc(k, 3);
                  break;
                end
              end
              else
              begin
                Inc(k, 2);
                break;
              end
            end
            else
            begin
              Inc(k, 1);
              break
            end
          end
          else
          begin
            break
          end;
        end;
        {unroll loop end}
        Selected[j] := k;          { update array for new value}
        Loops[k]    := 1;           {mark value as used}
        Inc(k);
      end;
    end;
end;

Function TComboset.GetNextComboWithRep:Boolean;
begin
  result:=NextLexRepRCombo;
end;

Function TComboset.GetNextPermuteWithRep:Boolean;
begin
  result:=NextLexRepRPermute;
end;

 {******************** Prev Functions ********************}
 {Functions to decrement to previous position (if any) and return boolean result}
function TComboSet.PrevR: boolean;
begin {PrevR}
  case Ctype of
    CombinationsDown:
    begin
      Result := PrevLexRCombo;    {Lexicographical order down}
      Dec(Count);
    end;
    PermutationsDown:
    begin
      Result := PrevLexRPermute;  {Lexicographical order down}
      Dec(Count);
    end;
    CombinationsCoLexDown:
    begin
      Result := PrevCoLexRCombo;  {Co-Lexicographical order down}
      Dec(Count);
    end;
    CombinationsRepeatDown:
    begin
      Result := PrevLexRepRCombo;
      Dec(Count);
    end;
    PermutationsRepeatDown :
    begin
      Result := PrevLexRepRPermute;{Lexicographical order down}
      Dec(Count);
    end;
    else
    begin
      Result := False
    end;            {Error}
  end;
end;

function TComboSet.PrevCoLexRCombo: boolean;
var
  i, k: integer;
begin
  if Selected[r] <= r then        {check to see if final combination}
  begin
    Result := False;
    exit;
  end;
  Result := True;
  i      := 1;
  while (i = Selected[i]) do     {walk down tree}
  begin
    Inc(i)
  end;
  Dec(Selected[i]);              {setup temp variable to speed up calculation}
  k := Selected[i];
  while i > 1 do                 {reset values}
  begin
    Dec(i);                       {loop variable}
    Dec(k);                       {use temporary variable for speed}
    Selected[i] := k;
  end;
end;

function TComboSet.PrevLexRCombo: boolean;
var
  i, k: integer;
begin
  Result := True;                              {set default value}
  k      := r;                                 {assign local variable for speed}
  while (Selected[k] - Selected[k - 1]) = 1 do {walk down chain}
  begin
    Dec(k)
  end;
  if k <= 0 then                               {check for last combination}
  begin
    Result := False;
    exit;
  end;
  Dec(Selected[k]);                            {decrease value}
  i := n - r + k;                              {temp variable to speed up calc}
  while k < r do                               {set remaining values}
  begin
    Inc(k);
    Inc(i);                                    {use temp variable for speed}
    Selected[k] := i;
  end;
end;

function TComboSet.PrevLexRepRCombo: boolean;
var
  i, k: integer;
begin
  Result := True;                              {set default value}
  k      := r;                                 {assign local variable for speed}
  while (Selected[k] = Selected[k - 1]) do {walk down chain}
  begin
    Dec(k)
  end;
  if k <= 1 then                               {check for last combination}
  begin
    K := 1;
    if selected[k] <= 1 then
    begin
      Result := False;
      exit;
    end;
  end;
  Dec(Selected[k]);                            {decrease value}
  i := n;                                      {temp variable to speed up calc}
  while k < r do                               {set remaining values}
  begin
    Inc(k);
    Selected[k] := i;
  end;
end;


function TComboSet.PrevLexRepRPermute: boolean;
var
  i, k: integer;
begin
  Result := True;
  k      := r;
  if Selected[k] > 1 then                     {see if can lower last value}
  begin
    Dec(Selected[r]);
    exit;
  end;
  while (Selected[k] = Selected[k - 1]) do     {walk down tree}
  begin
    Dec(k)
  end;
  if k = 1 then                              {check for last permutation}
  begin
    Result := False;
    exit;
  end;
  Dec(Selected[k - 1]);                       {decrease by 1}
  for i := k to r do
  begin
    Selected[i] := n
  end;                         {reset value to top value}
end;

function TComboSet.PrevLexRPermute: boolean;
var
  j, k, IncPos, il: integer;
label
  BreakDoLoop;
begin
  Result := True;          {Default value}
  IncPos := r;             {start at end and work to front}
  while True do
  begin
    for il := Selected[IncPos] - 1 downto 1 do
    begin
      if Loops[il] <> 1 then           {we found a unused pos}
      begin
        Loops[Selected[IncPos]] := 0;  {mark old pos as unused}
        Loops[il] := 1;                {mark new pos as used}
        Selected[IncPos] := il;        {place new value in Selected}
        goto BreakDoLoop;              {break}
      end
    end;
    if IncPos > 1 then                 {back-up one position and repeat}
    begin
      Loops[Selected[IncPos]] := 0;    {mark old pos as unused}
      Dec(IncPos);                     {look to increase previous place}
    end
    else
    begin
      Result := False;  {reached end of permutation}
      exit;
    end;
  end;
  BreakDoLoop:
    if IncPos < r then        {then we have more sequences to place}
    begin
      k := n;
      for j := IncPos + 1 to r do
      begin
        while Loops[k] = 1 do
        begin
          Dec(k)
        end;
        { unroll this loop for speed ...}
        Selected[j] := k;
        Loops[k]    := 1;   {mark as used}
        Dec(k);
      end;
    end;
end;

 {******************** Rank Functions ********************}
 {Functions to Return Rank position in Selected array}
function TComboSet.RankR: int64;
begin
  Result := 0;
  if IsValidRSequence then
  begin
    case Ctype of
      Combinations, CombinationsDown:
        Result := RankLexRCombo;
      Permutations,PermutationsDown:
        Result := RankLexRPermute;
      CombinationsCoLex,CombinationsCoLexDown:
        Result := RankCoLexRCombo;
      PermutationsRepeat, PermutationsWithrep,PermutationsRepeatDown:
        Result := RankLexRepRPermute;
      CombinationsRepeat,CombinationsWithrep,CombinationsRepeatDown:
        Result := RankLexRepRCombo;
      else
        Result := 0;
    end
  end;
end;

function TComboSet.RankCoLexRCombo: int64;
var
  i, k: integer;
begin
  if not IsValidRSequence then
  begin
    Result := 0;
    exit;
  end;
  Result := 1; {Rank start at 1 not 0}
  for i := 1 to r do
  begin
    k      := r + 1 - i;
    Result := Result + Binomial(k, Selected[k] - 1);
  end;
  If ctype=CombinationsColexdown then result:=getcount+1-result;
end;

function TComboSet.RankLexRCombo: int64;
var
  i, j: integer;
begin
  if not IsValidRSequence then
  begin
    Result := 0;
    exit;
  end;
  Result      := 1;  {Rank start at 1 not 0}
  Selected[0] := 0;  {force to zero}
  for i := 1 to r do
  begin
    for j := Selected[i - 1] + 1 to Selected[i] - 1 do
    begin
      Result := Result + Binomial(r - i, n - j);
    end
  end;
end;

function TComboSet.RankLexRepRCombo: int64;
var
  DistinctNo, i, j : integer;
begin
  if not IsValidRSequence then
  begin
    Result := 0;
    exit;
  end;
  Result := 1;  {Rank start at 1 not 0}
  Selected[0] := 1;
  DistinctNo := n;
  for i := 1 to r - 1 do
  begin
    for j := Selected[i-1]+1 to Selected[i] do
    begin
      Result := Result + GetRepRCombo(r-i,DistinctNo);
      dec(DistinctNo);
    end;
  end;
  Result := Result + Selected[r]-Selected[r-1];
  Selected[0] := 0;
end;

function TComboSet.RankLexRPermute: int64;
var
  i, k, UnusedCount, CurrentNum: integer;
  TempLoops: Bytearray;
  imult:     int64;
begin
  if not IsValidRSequence then
  begin
    Result := 0;
    exit;
  end;
  Result := 1;  {Rank start at 1 not 0}
  FillChar(TempLoops, SizeOf(TempLoops), 0); {quick clear}
  imult := GetRPermute(r, n) div n;       {find multiplier for round}
  for i := 1 to r - 1 do
  begin
    {find "round" travel distance in permutation}
    UnusedCount := 0;
    CurrentNum  := Selected[i];    {temp variable for speed}
    for k := 1 to CurrentNum - 1 do
    begin
      if TempLoops[k] <> 1 then
      begin
        Inc(UnusedCount)
      end
    end;          {number of unused values}
    TempLoops[CurrentNum] := 1;    {mark value as used}
    Result := Result + UnusedCount * imult; {rank = distance * multiplier of round}
    imult  := imult div (n - i);   {find multiplier for next round}
  end;
  {find last "round" travel distance in permutation}
  UnusedCount := 0;
  for k := 1 to Selected[r] - 1 do
  begin
    if TempLoops[k] <> 1 then
    begin
      Inc(UnusedCount)
    end
  end; {number of unused values}
  Result := Result + UnusedCount;
  If ctype=permutationsdown then result:=getcount+1-result;
end;

function TComboSet.RankLexRepRPermute: int64;
var
  i: integer;
begin
  if not IsValidRSequence then
  begin
    Result := 0;
    exit;
  end;
  Result := 1;  {Rank start at 1 not 0}
  for i := r downto 1 do
  begin
    Result := Result + GetRepRPermute(r - i, n) * (Selected[i] - 1)
  end;
  If ctype=permutationsRepeatdown then result:=getcount+1-result;
end;

{******************** Directional Function ********************}
function TComboSet.GetNextPrevR: boolean;
begin {GetNextPrevR}
  case Ctype of
    Combinations:
    begin
      Result := NextLexRCombo;    {Lexicographical order up}
      Inc(Count);
    end;
    Permutations:
    begin
      Result := NextLexRPermute;  {Lexicographical order up}
      Inc(Count);
    end;
    CombinationsDown:
    begin
      Result := PrevLexRCombo;    {Lexicographical order down}
      Dec(Count);
    end;
    PermutationsDown:
    begin
      Result := PrevLexRPermute;  {Lexicographical order down}
      Dec(Count);
    end;
    CombinationsCoLex:
    begin
      Result := NextCoLexRCombo;  {Co-Lexicographical order up}
      Inc(Count);
    end;
    CombinationsCoLexDown:
    begin
      Result := PrevCoLexRCombo;  {Co-Lexicographical order down}
      Dec(Count);
    end;
    PermutationsRepeat, PermutationsWithRep:
    begin
      Result := NextLexRepRPermute;{Lexicographical order up}
      Inc(Count);
    end;
    PermutationsRepeatDown:
    begin
      Result := PrevLexRepRPermute;{Lexicographical order down}
      Dec(Count);
    end;
    CombinationsRepeat,CombinationsWithrep:
    begin
      Result := NextLexRepRCombo;{Lexicographical order up}
      Inc(Count);
    end;
    CombinationsRepeatDown:
    begin
      Result := PrevLexRepRCombo;{Lexicographical order down}
      Dec(Count);
    end;
    else
    begin
      Result := False
    end;
  end;
end;

{******************** Setup Procedures ********************}
procedure TComboSet.SetupR(NewR, NewN: word; NewCtype: TComboType);
begin
  n := NewN;
  if n < 1 then
  begin
    n := 1
  end
  else
  begin
    if (n > MaxEntries) and not
      (NewCtype in [Combinations, CombinationsDown, CombinationsCoLex,
      CombinationsCoLexDown]) then
    begin
      n := MaxEntries
    end
  end;
  r := NewR;
  if r < 1 then
  begin
    r := 1
  end
  else
  begin
    if ( not (NewCType in [CombinationsRepeat, CombinationsWithrep,CombinationsRepeatDown,
      PermutationsRepeat, PermutationsWithRep, PermutationsRepeatDown]) and
      (r > n)) then
    begin
      r := n
    end
  end;
  Ctype := newCtype;
  ClearArrays;
  try
    case Ctype of
      Combinations: SetupNextLexRCombo;  {Lexicographical order up}
      Permutations: SetupNextLexRPermute; {Lexicographical order up}
      CombinationsDown: SetupPrevLexRCombo; {Lexicographical order down}
      PermutationsDown: SetupPrevLexRPermute; {Lexicographical order down}
      CombinationsCoLex: SetupNextCoLexRCombo; {Co-Lexicographical order up}
      CombinationsCoLexDown: SetupPrevCoLexRCombo; {Co-Lexicographical order down}
      PermutationsRepeat, PermutationsWithRep: SetupNextLexRepRPermute; {Lexicographical order up}
      PermutationsRepeatDown: SetupPrevLexRepRPermute; {Lexicographical order down}
      CombinationsRepeat,CombinationsWithrep: SetupNextLexRepRCombo; {Lexicographical order up}
      CombinationsRepeatDown: SetupPrevLexRepRCombo; {Lexicographical order down}
      else
      begin
        SetupNextLexRCombo
      end;                  {picked a default value to prevent warning}
    end;
  except
    Seterror;

  //finally

  end;
  NumberOfSubsets := GetNumberSubsets(r,n,Ctype);
  if Ctype in [CombinationsDown, PermutationsDown, CombinationsCoLexDown,
    PermutationsRepeatDown,CombinationsRepeatDown] then
    Count := NumberofSubsets + 1
  else
    Count := 0;
end;

procedure TComboSet.SetupRFirstLast(NewR, NewN: word; NewCtype: TComboType);
begin
  n := NewN;
  if n < 1 then
  begin
    n := 1
  end
  else
  begin
    if n > MaxEntries then
    begin
      n := MaxEntries
    end
  end;
  r := NewR;
  if r < 1 then
  begin
    r := 1
  end
  else
  begin
    if ( not (NewCType in [PermutationsRepeat, PermutationsWithRep,PermutationsRepeatDown,
           CombinationsRepeat,CombinationsWithrep,CombinationsRepeatDown]) and
      (r > n)) then
    begin
      r := n
    end
  end;
  Ctype := newCtype;
  ClearArrays;
  case Ctype of
    Combinations: SetupFirstLexRCombo; {Lexicographical order up}
    Permutations: SetupFirstLexRPermute; {Lexicographical order up}
    CombinationsDown: SetupLastLexRCombo; {Lexicographical order down}
    PermutationsDown: SetupLastLexRPermute; {Lexicographical order down}
    CombinationsCoLex: SetupFirstCoLexRCombo; {Co-Lexicographical order up}
    CombinationsCoLexDown: SetupLastCoLexRCombo; {Co-Lexicographical order down}
    CombinationsRepeat,CombinationsWithrep: SetupFirstLexRepRCombo; {Lexicographical order up}
    CombinationsRepeatDown: SetupLastLexRepRCombo; {Lexicographical order down}
    PermutationsRepeat,PermutationsWithRep: SetupFirstLexRepRPermute; {Lexicographical order up}
    PermutationsRepeatDown: SetupLastLexRepRPermute; {Lexicographical order down}
    else
    begin
      SetupFirstLexRCombo
    end;                  {picked a default value to prevent warning}
  end;
  NumberofSubsets := GetNumberSubsets(r,n,Ctype);
  if Ctype in [CombinationsDown, PermutationsDown, CombinationsCoLexDown,
    CombinationsRepeatDown,PermutationsRepeatDown] then
    Count := NumberofSubsets
  else
    Count := 1;
end;

{******************** UnRank Functions ********************}
function TComboSet.UnRankR(const Rank: int64):boolean;
begin
  case {New}Ctype of
    Combinations, Combinationsdown: result:=UnRankLexRCombo(Rank);
    Permutations,
    PermutationsDown:
      Result := UnRankLexRPermute( Rank);
    CombinationsCoLex,
    CombinationsCoLexDown:
      Result := UnRankCoLexRCombo(Rank);
    PermutationsRepeat, PermutationsWithRep,
    PermutationsRepeatDown:
      Result := UnRankLexRepRPermute( Rank);
    CombinationsRepeat, CombinationsWithrep,
    CombinationsRepeatDown:
      Result := UnRankLexRepRCombo(Rank);
  else
    begin
      Result := False;
    end;
  end;

end;

function TComboSet.UnRankCoLexRCombo(const Rank: int64):boolean;
{
Based upon Algorthim 2:10, Donald Kresher and Douglas Simpson,
Combinatorial Algorthims, and fortran implementation KSUBSET_COLEX_UNRANK
by John Burkardt
}

var
  i, x: integer;
  k,  RankZeroBased:int64;
  wrank: int64;
begin
  x := n;
  result:=false;
  if not (Ctype in [CombinationsCoLex, CombinationsCoLexDown]) then exit;
  Result := IsValidRNRank(R,N,Rank,Ctype);
  If ctype=CombinationscoLexdown then wrank:=getcount+1-rank
  else wrank:=rank;
  RankZeroBased := wRank - 1;
  FillChar(Selected, SizeOf(Selected), 0);
  if not Result then
    exit;
  for i := 1 to R do
  begin
    k := R + 1 - i;
    while Binomial(k, x) > RankZeroBased do
    begin
      Dec(x)
    end;
    Selected[k]   := x + 1;
    RankZeroBased := RankZeroBased - Binomial(k, x);
  end;
end;

function TComboSet.UnRankLexRCombo(const Rank: int64):boolean;
var
  i:    integer;
  k, j: int64;
  wrank:int64;
begin
  k := 0;
  result:=false;
  if not (Ctype in [Combinations, CombinationsDown]) then exit;
  Result := IsValidRNRank(R,N,Rank,Ctype);
  FillChar(Selected, SizeOf(Selected), 0);
  if not Result then
    exit;
  If ctype= Combinations then wrank:=rank else wrank:=getcount-rank;
  for i := 1 to R - 1 do
  begin
    Selected[i] := Selected[i - 1];    {set to previous }
    j := 0;
    repeat
      Inc(k, j);                        {add previous binomial value if any}
      Inc(Selected[i]);                 {increase value}
      j := Binomial(R - i, N - Selected[i]);
    until (wRank <= (k + j));             {check rank with new binomial value}
  end;
  Selected[R] := Selected[R - 1] + wrank - k;   {set remaining value to diff}
end;

function TComboSet.UnRankLexRepRCombo({const RPick, Number: integer;} const Rank: int64):boolean;
var
  i:integer;
  DistinctNo,RankRemaining : int64;
  wrank:int64;
begin
  result:=false;
  if not (Ctype in [CombinationsRepeat,CombinationsWithrep, CombinationsRepeatDown]) then exit;
  Result := IsValidRNRank(R,N,Rank,Ctype);
  FillChar(Selected, SizeOf(Selected), 0);
  if not Result then  exit;
  if ctype=combinationsrepeatdown then wrank:=getcount+1 - rank else wrank:=rank;
  DistinctNo := N;
  Selected[0] := 1;
  RankRemaining := wRank;
  for i := 1 to R - 1 do
  begin
    Selected[i] := Selected[i - 1];    {set to previous }
    While GetRepRCombo(R-i,DistinctNo) < RankRemaining do
    begin
      RankRemaining := RankRemaining - GetRepRCombo(R-i,DistinctNo);
      inc(Selected[i]);
      dec(DistinctNo);
    end;
  end;
  Selected[R] := Selected[R - 1] + RankRemaining - 1;   {set remaining value to diff}
end;

function TComboSet.UnRankLexRPermute(const Rank: int64):boolean;
var
  i, jj, UnusedCount, ZeroBasedNum: integer;
  k, RankZeroBased: int64;
  wrank:int64;
begin
  result:=false;
  if not (Ctype in [Permutations, PermutationsDown]) then exit;
  if ctype=permutationsdown then wrank:=getcount-rank + 1 else wrank:=rank;
  Result := IsValidRNRank(R,N,Rank,Ctype);
  if not Result then
    exit;
  RankZeroBased := wRank - 1;
  ClearArrays;
  k := GetRPermute(R, N) div N;
  for i := 1 to R - 1 do
  begin
    ZeroBasedNum := RankZeroBased div k;              {find quotient}
    RankZeroBased := RankZeroBased - ZeroBasedNum * k;  {calculate new dividend}
    {find ZeroBasedNum in Loops and set selected}
    UnusedCount := -1;
    jj := 0;
    repeat
      Inc(jj);
      while Loops[jj] = 1 do  {if marked as used then skip}
      begin
        Inc(jj)
      end;
      Inc(UnusedCount);
    until (UnusedCount = ZeroBasedNum);
    Loops[jj] := 1;          {mark as used}
    Selected[i] := jj;       {update value}
    k := k div (N - i); {calculate new divisor}
  end; {for loop}
  {RankZeroBased holds final unconverted value}
  UnusedCount := -1;
  jj := 0;
  repeat
    Inc(jj);
    while Loops[jj] = 1 do  {if marked as used then skip}
    begin
      Inc(jj)
    end;
    Inc(UnusedCount);
  until (UnusedCount = RankZeroBased);  {find value in sequence}
  Loops[jj] := 1;        {mark as used}
  Selected[R] := jj;       {update value}
end;

function TComboSet.UnRankLexRepRPermute(const Rank: int64):boolean;
var
  i: integer;
  k, RankZeroBased: int64;
  wrank:int64;
begin
  result:=false;
  if not (Ctype in [PermutationsRepeat,PermutationsWithrep, PermutationsRepeatDown]) then exit;
  Result := IsValidRNRank(R,N,Rank,Ctype);
  if not Result then
    exit;
  if ctype=PermutationsRepeatDown then wrank:=getcount-rank else wrank:=rank;
  RankZeroBased := wRank - 1;
  ClearArrays;
  k := GetRepRPermute(R - 1, N);
  for i := 1 to R - 1 do
  begin
    Selected[i]   := RankZeroBased div k;                   {find quotient}
    RankZeroBased := RankZeroBased - Selected[i] * k;       {calculate new dividend}
    Inc(Selected[i]);
    {convert quotient to position}
    k := k div (N);                                    {calculate new divisor}
  end;
  Selected[R] := RankZeroBased + 1;
end;

{******************** Direction Function ********************}
function TComboSet.ChangeRDirection: boolean;
var
  Ccount: int64;
begin
  Result := True;
  Ccount := Count - 1;
  case Ctype of
    Combinations:
    begin
      Ctype := CombinationsDown;
      Count := GetRCombo(r, n) - ccount;
    end;
    Permutations:
    begin
      Ctype := PermutationsDown;
      Count := GetRPermute(r, n) - ccount;
    end;
    CombinationsDown:
    begin
      Ctype := Combinations;
      Count := GetRCombo(r, n) - ccount;
    end;
    PermutationsDown:
    begin
      Ctype := Permutations;
      Count := GetRPermute(r, n) - ccount;
    end;
    CombinationsCoLex:
    begin
      Ctype := CombinationsCoLexDown;
      Count := GetRCombo(r, n) - ccount;
    end;
    CombinationsCoLexDown:
    begin
      Ctype := CombinationsCoLex;
      Count := GetRCombo(r, n) - ccount;
    end;
    PermutationsRepeat, PermutationsWithRep:
    begin
      Ctype := PermutationsRepeatDown;
      Count := GetRepRPermute(r, n) - ccount;
    end;
    PermutationsRepeatDown:
    begin
      Ctype := PermutationsRepeat;
      Count := GetRepRPermute(r, n) - ccount;
    end;
    CombinationsRepeat,CombinationsWithrep:
    begin
      Ctype := CombinationsRepeatDown;
      Count := GetRepRCombo(r, n) - ccount;
    end;
    CombinationsRepeatDown:
    begin
      Ctype := CombinationsRepeat;
      Count := GetRepRCombo(r, n) - ccount;
    end;
    else
    begin
      Result := False
    end;
  end;
  if not IsValidRSequence then
  begin
    SetupR(r, n, Ctype)
  end;
end;

function TComboSet.IsValidRSequence: boolean;
var
  i, k, temp,Counter: integer;
  UsedAry: ByteArray;
begin
  Result  := False;
  FillChar(UsedAry, SizeOf(UsedAry), 0);
  {Check range of sequence}
  for i := 1 to r do
  begin
    if (Selected[i] < 1) or (Selected[i] > n) then
    begin
      exit
    end
  end;
  {Check for repeated values in sequence e.g., permutations, permutationsdown}
  if not (Ctype in [PermutationsRepeat, PermutationsWithrep,PermutationsRepeatDown,
                    CombinationsRepeat,CombinationsWithrep, CombinationsRepeatDown]) then
  begin
    UsedAry := Selected;
    {sort values in array}
    for i := 1 to r-1 do
      for k := i+1 to r do
        if UsedAry[k] < UsedAry[i] then
        begin
          Temp := UsedAry[k];
          UsedAry[k] := UsedAry[i];
          UsedAry[i] := Temp;
        end;
    for i := 1 to r-1 do
      if UsedAry[i] = UsedAry[i+1] then
        exit
  end;
  if Ctype in [Permutations, PermutationsDown] then
  begin
    {Ensure each selected item is marked in internal loops array}
    Fillchar(loops,sizeof(loops),0);
    for i := 1 to r do
      loops[selected[i]] := 1;
(*  // old check took too long, just replace ...
    {check that each value in Selected is marked in Loops}
    for i := 1 to r do
    begin
      if Loops[Selected[i]] <> 1 then
      begin
        exit
      end
    end;
    {check that nothing else is marked in Loops}
    for i := 1 to n do
    begin
      if Loops[i] = 1 then
      begin
        Inc(Counter)
      end
    end;
    if Counter <> r then
    begin
      exit
    end;
*)
  end
  {check for increasing values in Selected}
  else
  begin
    if Ctype in [Combinations, CombinationsDown, CombinationsCoLex,
      CombinationsCoLexDown] then
    begin
      k := 0;
      for i := 1 to r do
      begin
        if Selected[i] <= k then
        begin
          exit
        end
        else
        begin
          k := Selected[i]
        end
      end
    end
    {check for equal or increasing values in Selected}
    else
    if Ctype in [CombinationsRepeat, CombinationsWithrep,CombinationsRepeatDown] then
    begin
      k := 1;
      for i := 1 to r do
      begin
        if (Selected[i] < k) or((i>1)and(selected[i-1]>selected[i])) then
        begin
          exit
        end
        else
        begin
          k := Selected[i]
        end
      end
    end
  end;
  {passed all tests}
  Result := True;
end;







{******************** Random Functions ********************}
function TComboSet.RandomR(const RPick, Number: int64;
  const NewCtype: TComboType): Boolean;
begin
  case NewCtype of
  Combinations,CombinationsDown:
    Result := RandomLexRCombo(RPick,Number);
  Permutations,PermutationsDown:
    Result := RandomLexRPermute(RPick,Number);
  CombinationsCoLex,CombinationsCoLexDown:
    Result := RandomCoLexRCombo(RPick,Number);
  PermutationsRepeat,  PermutationsWithrep,PermutationsRepeatDown:
    Result := RandomLexRepRPermute(RPick,Number);
  CombinationsRepeat,CombinationsWithrep,CombinationsRepeatDown:
    Result := RandomLexRepRCombo(RPick,Number);
  else
    Result := False;
  end;
end;


function TComboSet.RandomCoLexRCombo(const RPick, Number: int64):boolean;
begin
  RandomRank := random64(GetRCombo(RPick,Number))+1;
  Result := UnRankCoLexRCombo(RandomRank);
end;

function TComboSet.RandomLexRCombo(const RPick, Number: int64):boolean;
begin
  RandomRank := random64(GetRCombo(RPick,Number))+1;
  Result := UnRankLexRCombo(RandomRank);
end;

function TComboSet.RandomLexRepRCombo(const RPick, Number: int64):boolean;
begin
  RandomRank :=random64(GetRepRCombo(RPick,Number))+1;  {GDD}
  Result := UnRankLexRepRCombo(RandomRank);
end;

function TComboSet.RandomLexRepRPermute(const RPick, Number: int64):boolean;
begin
   RandomRank := random64(GetRepRPermute(RPick,Number))+1; {GDD}
  Result := UnRankLexRepRPermute(RandomRank);
end;

function TComboSet.RandomLexRPermute(const RPick, Number: int64):boolean;
begin
  RandomRank := random64(GetRPermute(RPick,Number))+1; {GDD}
  Result := UnRankLexRPermute(RandomRank);
end;

//initialization
  //Combos := TComboset.Create;
  //randomize;
  //randomize64;
end.