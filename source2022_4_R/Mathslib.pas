  unit  MathsLib;

{Copyright 2005,2013 Gary Darby, www.DelphiForFun.org

{Updated to include a 64 bit Random Number Generator  and to compile under
 all Delphi versions 11/19/2013 GDD}


{
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Assortment of math related functions and procedure in various states}


 {Revision Copyright 2006, Charles Doumar,  January 2006
 Added:
   Tprimes.BSPrime ... Binary search function to find index of prime in prime table.
   Tprimes.MaxPrimeInTable ... Returns Max Prime in prime table.
   Tprimes.GetNthPrime ... Returns Nth prime in table (returns -1 if not in table).
 Optimized:
    Tprimes.IsPrime ... Optimized for values greater than MaxPrimeInTable squared.
    Tprimes.NextPrime ... Speed up lookup of values within table range, added large value support
    Tprime.PrevPrime ... Speed up lookup of values within table range, added large value support
    Tprime.GetFactors ... Now returns factors for numbers greater than MaxPrimeInTable Squared
  }

interface

uses Classes, SysUtils, Windows, Dialogs; //, UBigIntsV4;

type
  intset = set of byte;

  TPoint64=record
    x,y:int64;
  end;

function GetNextPandigital(size: integer; var Digits: array of integer): boolean;
function IsPolygonal(T: int64; var rank: array of integer): boolean;
function GeneratePentagon(n: integer): integer;
function IsPentagon(p: integer): boolean;
function isSquare(const N: int64): boolean;
function isCube(const N: int64): boolean;


function isPalindrome(const n: int64): boolean;  overload;
function isPalindrome(const n: int64; var len:integer): boolean;  overload;

function GetEulerPhi(n: int64): int64;
function isprime(f: int64): boolean;


function IntPower(a, b: int64): int64; overload;
function IntPower(a:extended; b: int64): extended; overload;

function gcd2(a, b: int64): int64;
function GCDMany(A: array of integer): integer;
function LCMMany(A: array of integer): integer;
procedure ContinuedFraction(A: array of int64; const wholepart: integer;
  var numerator, denominator: int64);
function Factorial(n: int64): int64;

function digitcount(n:int64):integer;
function nextpermute(var a:array of integer):boolean;

function convertfloattofractionstring( N:extended; maxdenom:integer;multipleof:boolean):string;
function convertStringToDecimal(s:string; var n:extended):Boolean;  {string may include fractions}
function InttoBinaryStr(nn: integer): string;


{Latitude Longitude Routines}
  function StrtoAngle(const s:string; var angle:extended):boolean;
  function AngleToStr(angle:extended):string;
  function deg2rad(deg:extended):extended;
  function rad2deg(rad:extended):extended;
  function GetLongToMercProjection(const long:extended):extended;
  function GetLatToMercProjection(const Lat:Extended):Extended;
  function GetMercProjectionToLong(const ProjLong:extended):extended;
  function GetMercProjectionToLat(const ProjLat:extended):extended;

  Type  TInt64Array = array of int64;
  Type  TInt64PointArray  = array of TPoint64;

type
  {*********** TPrimes Class *******}
  TPrimes = class(TObject)
  protected
    function BSPrime(const n: int64; var index: integer): boolean;
  public
    Prime:    TInt64Array; //array of int64;  {Array of primes - 0th entry is not used}
    nbrprimes, nbrfactors, nbrcanonicalfactors, nbrdivisors: integer;
    Factors:  TInt64Array; //array of int64; {array of factors - 0th entry is not used}
    CanonicalFactors: TInt64PointArray; //array of TPoint64;
    Divisors:  TInt64Array; //array of int64;
    function GetNextPrime(n: int64): int64;
    function GetPrevPrime(n: int64): int64;
    function IsPrime(n: int64): boolean;
    procedure GetFactors(const n: int64);  {get all prime factors}
    function MaxPrimeInTable: int64;
    function GetNthPrime(const n: integer): int64;
    procedure GetCanonicalFactors(const n: int64);  {get ccanonical prime factors}
    procedure GetDivisors(const n: int64);          {get all divisors}
    function Getnbrdivisors(n: int64): integer;
    function radical(n:int64):int64;   {product of unique prime factors}
    constructor Create;
    destructor Destroy; override;
  end;


const deg=chr(176); {'°'}
      minmark=chr(180);


var
  Primes:        TPrimes;
  maxprimes:     integer = 50000; {initial size of primes array}
  maxfactors:    integer = 200;   {initial size of factors array}
  maxval:        int64 = 1000000000000; {10^12}
  {10^12 - 10^6 is  max prime to be tested from tables}
  {primes up to the sqrt of maxval will be tabled}
  angledelims:set of char=[' ',chr(176){degree symbol}, chr(180){minutmark},
                           ',',':','"',''''];

  {User fields for Continued fraction calculation}
  continuants:   array of int64;
  maxcontinuant: integer;


{******** 64 bit Random Routines ********}
//{$IF compilerversion>15}
  //RandSeed64 : UInt64 ;
  RandSeed64:Int64;

 function Random64(const UI64 : UInt64) : UInt64 ; overload ;
{//$ELSE}
  //function Random64(const N:Int64) : Int64 ; overload ;
//{$IFEND}

  procedure Randomize64 ;
  function Random64 : extended ; overload ;



implementation

uses Math;

var
  nbrdiv: int64;


{************* NbrFactors *************}
function nbrfactors(n: integer): integer;
var
  i,NbrLimit: integer;
begin
  Result := 0;
  NbrLimit := trunc(0.0 + sqrt(n));
  for i := 1 to NbrLimit do
    if n mod i = 0 then Inc(Result,2);
  if NbrLimit * NbrLimit = N then
    Dec(Result); {perfect square}
end;

{************ IsPrime **********}
function isprime(f: int64): boolean;
begin
Primes := TPrimes.Create;
  result:=primes.isprime(f);
  Primes.Destroy;
end;

{************* IsSquare *************}
function isSquare(const N: int64): boolean;
var
  ex: extended;
  x:  int64;
begin
  ex     := sqrt(N + 0.0);
  x      := trunc(ex + 1e-10);
  Result := x * x = N;
end;

{************* IsCube *************}
function isCube(const N: int64): boolean;
var
  ex: extended;
  x:  int64;
begin
  ex     := (exp(ln(0.0 + N) / 3));
  x      := trunc(ex + 1e-6);
  Result := x * x * x = N;
end;

{*********** GCD2 ************}
function gcd2(a, b: int64): int64;
  {return gcd of a and b}
  {Euclids method}
var
  g, z: int64;
begin
  g := b;
  if b <> 0 then
    while g <> 0 do
    begin
      z := a mod g;
      a := g;
      g := z;
    end;
  Result := a;
end;

{********** GCDMany *************}
function GCDMany(A: array of integer): integer;
  {Greatest common denominator of an array of integers}

var
  i: integer;
  {m:integer;}
  g: integer;
begin
  g := a[0];
  if length(a) >= 2 then
  begin
    g := gcd2(g, a[1]);
    if length(a) > 2 then
      for i := 2 to length(a) - 1 do
        g := gcd2(g, a[i]);
  end;
  Result := g;
end;

{************* LCMMany ***************}
function LCMMany(A: array of integer): integer;
{Lowest Commom Multiplier of an array of integers}
var
  i, x: integer;
begin
  x := a[0];
  for i := 1 to length(a) - 1 do
    x := (x * a[i]) div gcd2(x, a[i]);
  Result := x;
end;

{*********** IntPower **********}
function intpower(a, b: int64): int64;
{Integer power of an integer}
var
  i: integer;
begin
  Result := 1;
  for i := 1 to b do
    Result := Result * a;
end;

function intpower(a:extended; b:int64):extended;
{Integer power of an extended floating point number}
begin
  result:=math.intpower(a,b);
end;

{*********** GetEulerPhi **********}
function getEulerPhi(n: int64): int64;
{The number of positive integers less than n which are relatively prime
 to n,  i.e. Count of i's, 0<i<n with GCD(i,n)=1}
var
  i: integer;
  p: int64;
  k: int64;
begin
Primes := TPrimes.Create;
  primes.getfactors(n);
  Result := 1;
  p      := primes.factors[1];
  k      := 0;
  for i := 1 to primes.nbrfactors do
  begin
    if p = primes.factors[i] then
      Inc(k)
    else
    begin
      Result := Result * (p - 1) * intpower(p, k - 1);
      k      := 1;
      p      := primes.factors[i];
    end;
  end;
  if p>1 then Result := Result * (p - 1) * intpower(p, k - 1);
  Primes.Destroy;
end;


{**************** GetBigComboCount *************}
(*procedure GetBigCombocount(const r, n: integer; var ccount: TInteger);
{Return number of combinations -- n things taken r at a time
 without replacement}
var
  work: TInteger;
begin
  work := TInteger.Create(0);
  if (r > 0) and (r < n) then
  begin
    ccount.Assign(N);
    ccount.Factorial;
    work.Assign(r);
    work.Factorial;
    ccount.Divide(work);
    work.Assign(n - r);
    work.Factorial;
    ccount.Divide(work);
  end
  else if r = n then
    ccount.Assign(1)
  else
    ccount.Assign(0);
  work.Free;
end; *)



{*************** IsPandigital *******}
function ispandigital(const n, Base: int64;
  const includezero, exactlyOnce: boolean): boolean;
var
  i:      integer;
  Digits: array of integer;
begin
  SetLength(Digits, Base);
  for i := 0 to Base - 1 do
    Digits[i] := 0;
  Result := True;
  i := n;
  while i > 0 do
  begin
    Inc(Digits[i mod Base]);
    i := i div Base;
  end;
  {sure that all digit from 1 to max digit found occured exactly once and no higher digit occurred a all}
  for i := 0 to Base - 1 do
  begin
    if exactlyonce then
    begin
      if ((i = 0) and includezero and (Digits[i] <> 1)) or
        ((i > 0) and (Digits[i] <> 1)) then
      begin
        Result := False;
        break;
      end;
    end
    else
    begin
      if ((i = 0) and includezero and (Digits[i] = 0)) or ((i > 0) and (Digits[i] = 0))
      then
      begin
        Result := False;
        break;
      end;
    end;
  end;
end;


{************** GetNextPandigital}
function GetNextPandigital(size: integer; var Digits: array of integer): boolean;
  {Generates 9 or 10 digit permutations of digits in decreasing sequence,
   Input parameter "size" is the number of digits to generate (2 to 10).
   Output placed in open array "digits",  so index value of k refers
   to (k+1)th entry.
   Result is true until all values have been returned.
   Initialize "digits" array with 9,8,7,6,5,4,3,2,1,0 (10 digit pandigitals) or
   9,8,7,6,5,4,3,2,1 (9 digit "almost" pandigitals) before first call.
  }
  procedure swap(i: integer; j: integer);
  {swap digits[i] and digits[j]}
  var
    temp: integer;
  begin
    temp      := Digits[i];
    Digits[i] := Digits[j];
    Digits[j] := temp;
  end;

var
  k, j, r, s: integer;
begin
  k := size - 2; {start at next-to-last}
  {find the last decreasing-order pair}
  while (k >= 0) and (Digits[k] > Digits[k + 1]) do
    Dec(k);
  if k < 0 then
    Result := False {if none in decreasing order, we're done}
  else
  begin
    j := size - 1; {find the rightmost digit less than digits[k]}
    while Digits[k] > Digits[j] do
      j := j - 1;
    swap(j, k); {and swap them}
    r := size - 1;
    s := k + 1;  {from there to the end, swap end digits toward the center}
    while r > s do
    begin
      swap(r, s);
      r := r - 1;
      s := s + 1;
    end;
    Result := True;  {magic!}
  end;
end;


{************** GetPrevPandigital}
function GetPrevPandigital(size: integer; var Digits: array of integer): boolean;
  {Generates 9 or 10 digit permutations of digits in decreasing sequence,
   Input parameter "size" is the number of digits to generate (2 to 10).
   Output placed in open array "digits",  so index value of k refers
   to (k+1)th entry.
   Result is true until all values have been returned.
   Initialize "digits" array with 9,8,7,6,5,4,3,2,1,0 (10 digit pandigitals) or
   9,8,7,6,5,4,3,2,1 (9 digit "almost" pandigitals) before first call.
  }
  procedure swap(i: integer; j: integer);
  {swap digits[i] and digits[j]}
  var
    temp: integer;
  begin
    temp      := Digits[i];
    Digits[i] := Digits[j];
    Digits[j] := temp;
  end;

var
  k, j, r, s: integer;
begin
  k := size - 2; {start at next-to-last}
  {find the last decreasing-order pair}
  while (k >= 0) and (Digits[k] < Digits[k + 1]) do
    Dec(k);
  if k < 0 then
    Result := False {if none in decreasing order, we're done}
  else
  begin
    j := size - 1; {find the rightmost digit less than digits[k]}
    while Digits[k] < Digits[j] do
      j := j - 1;
    swap(j, k); {and swap them}
    r := size - 1;
    s := k + 1;  {from there to the end, swap end digits toward the center}
    while r > s do
    begin
      swap(r, s);
      r := r - 1;
      s := s + 1;
    end;
    Result := True;  {magic!}
  end;
end;





{*********** IsPalindrome *************}
function isPalindrome(const n: int64): boolean;
{Returns true if "n" is a palindrome}
var
  s: string;
  i,len: integer;
begin
  result:=isPalindrome(n,len);
end;

{*********** IsPalindrome *************}
function isPalindrome(const n: int64; var len:integer): boolean;
{Overloaded version which also returns number of digits contained in "n"}
var
  s: string;
  i: integer;
begin
  s  := IntToStr(n);
  len:=length(s);
  Result := True;
  for i := 1 to len div 2 do
  begin
    if not (s[i] = s[len + 1 - i]) then
    begin
      Result := False;
      break;
    end;
  end;
end;


{**************** NextPermute *************}
function nextpermute(var a: array of integer): boolean;
   {
   SEPA: A Simple, Efficient Permutation Algorithm
   Jeffrey A. Johnson, Brigham Young University-Hawaii Campus
   http://www.cs.byuh.edu/~johnsonj/permute/soda_submit.html
  }
  {My new favorite - short, fast,  understandable  and requires no data
  structures or intialization, each output is generated as the
  next permutation after the permutation passed!}

  {Considerations:
    First call to Nextpermute should pass the array in increasing sequence.
    This initial permutation will not be returned by the routine so must
    be processed independently of NextPermute calls by the calling program.
  }

var
  i, j, key, temp, rightmost: integer;
begin
    {1. Find Key, the leftmost byte of rightmost in-sequence pair
        If none found, we are done}

  {  Characters to the right of key are the "tail"}
    {  Example 1432 -
       Step 1:  check pair 3,2 - not in sequence
               check pair 4,3 - not in sequence
               check pair 1,4 - in sequence ==> key is a[0]=1, tail is 432

    }
  rightmost := high(a);
  i := rightmost - 1; {Start at right end -1}
  while (i >= 0) and (a[i] >= a[i + 1]) do
    Dec(i); {Find in-sequence pair}
  if i >= 0 then  {Found it, so there is another permutation}
  begin
    Result := True;
    key    := a[i];

    {2A. Find rightmost in tail that is > key}
    j := rightmost;
    while (j > i) and (a[j] < a[i]) do
      Dec(j);
    {2B. and swap them} a[i] := a[j];
    a[j] := key;
      {Example - 1432  1=key 432=tail
       Step 2:  check 1 vs 2,  2 > 1 so swap them producing 2431}

    {3. Sort tail characters in ascending order}
      {   By definition, the tail is in descending order now,
          so we can do a swap sort by exchanging first with last,
          second with next-to-last, etc.}
      {Example - 2431  431=tail
        Step 3:
                 compare 4 vs 1 - 4 is greater so swap producing 2134
                 tail sort is done.

                final array = 2134
     }
    Inc(i);
    j := rightmost; {point i to tail start, j to tail end}
    while j > i do
    begin
      if a[i] > a[j] then
      begin {swap}
        temp := a[i];
        a[i] := a[j];
        a[j] := temp;
      end;
      Inc(i);
      Dec(j);
    end;
  end
  else Result := False; {else please don't call me any more!}
end;

(*
procedure permute (k,level:integer; var val:array of integer);
{This is a recursive permutation generator to make all permutations of integers
 1 to K and call "processvalue" procedure for each}
var   i:integer;
begin
  val[k]:=level;
  if level=length(val) then processValue(val)
  else  for i:= 0 to high(val) do  if val[i]=0 then permute(i,level+1,val);
  Val[k] := 0;
end;
*)

function GeneratePentagon(n: integer): integer;
begin
  Result := n * (3 * n - 1) div 2;
end;

(*
function IsPolygonal(T:int64):intset;
{from http://mathworld.wolfram.com/PolygonalNumber.html}
var
  test:byte;
  n:int64;
  s2,s:int64;
begin
 result:=[];
  test:=3;
  while test<=8 do
  begin
    s2:=8*(test-2)*T+(test-4)*(test-4);
    s:=trunc(sqrt(0.0+s2));
    if  s*s=s2 then
    begin {s2 is a perfect square do the number is Test-ogonal};
      result:=result+[test];
    end;
    inc(test);
  end;
end;
*)

function getpolygonal(p, r: int64): int64;
begin
  case p of
    3: Result := (r * (r + 1) div 2);
    4: Result := (r * r);
    5: Result := (r * (3 * r - 1) div 2);
    6: Result := (r * (2 * r - 1));
    7: Result := (r * (5 * r - 3) div 2);
    8: Result := (r * (3 * r - 2));
    else
      Result := 0;
  end;
end;

function IsPolygonal(T: int64; var rank: array of integer): boolean;
  {from http://mathworld.wolfram.com/PolygonalNumber.html}
var
  test:  byte;
  r:     int64;
  s2, s: int64;
begin
  Result := False;
  test   := 3;
  while test <= 8 do
  begin
    s2 := 8 * (test - 2) * T + (test - 4) * (test - 4);
    s  := trunc(sqrt(0.0 + s2));
    if s * s = s2 then  {it could be a polygonal}
    begin
      {s2 is a perfect square do the number could be Test-ogonal};
      r := (s + test - 4) div (2 * (test - 2));
      if getpolygonal(test, r) <> T then
        r := 0;
      Result := True;
    end
    else
      r := 0;
    rank[test] := r;
    Inc(test);
  end;
end;

function MakePolyName(t: integer): string;
  {make polygonal figure name from numbe}
begin
  Result := '';
  case t of
    3: Result := ' triangular';
    4: Result := ' square    ';
    5: Result := ' pentagonal';
    6: Result := ' hexagonal ';
    7: Result := ' heptagonal';
    8: Result := ' octagonal ';
    else
      Result := 'Unknown';
  end;
end;


function IsPentagon(p: integer): boolean;
var
  n: integer;
begin
  n      := Round(sqrt(2 * p / 3));
  Result := p = n * (3 * n - 1) div 2;
end;


{************ IntToBinaryStr ********}
function InttoBinaryStr(nn: integer): string;
var
  n: integer;
begin
  n      := nn;
  Result := '';
  while n > 0 do
  begin
    if n mod 2 = 0 then
      Result := '0' + Result
    else
      Result := '1' + Result;
    n := n div 2;
  end;
end;


{************ Factorial *********8}
function Factorial(n: int64): int64;
var
  i: integer;
begin
  Result := 1;
  for i := 2 to n do
    Result := Result * i;
end;

{*********** NbrPrimes *********}
function nbrprimes(a, b: integer): integer;
{Return the number of primes between a and b }
var
  n:    integer;
  quit: boolean;
  w:    int64;
begin
  Result := 0;
  n      := -1;
  quit   := False;
  repeat
    Inc(n);

    w := n * n + a * n + b;
    if (w >= 0) and isprime(w) then
      Inc(Result)
    else
      quit := True;
  until quit;
end;

{************* CycleLen ************}
function cyclelen(n: integer; var s: string): integer;
{Given N return a string representation of 1/N
 and the Cycle length}
var
  i, r, d: integer;
  remainders: array of integer;
  Count: integer;
  c: char;
begin
  SetLength(remainders, n);
  Result := 0;
  for i := 0 to n - 1 do
    remainders[i] := -1;
  s := '';
  r     := 1;
  Count := 0;
  repeat
    Inc(Count);
    r := r * 10;
    d := r div n;
    r := r mod n;

    if remainders[r] > 0 then
      Result := Count - remainders[r]
    else
    begin
      remainders[r] := Count;
      c := IntToStr(d)[1];
      s := s + c;
    end;
  until (Result > 0) or (r = 0);
  if r = 0 then
  begin
    Result := length(s);
  end;

end;


const
  maxdigits = 1000;

var
  Base: int64 = 10000000000;

type
  tbigint = array[0..maxdigits div 10] of int64;


  {************* AddBig *********}
function addbig(a, b: TBigint): Tbigint;
var
  i: integer;
begin
  Result := a;
  for i := 0 to high(a) do
  begin
    Result[i] := Result[i] + b[i];
    if (i < high(a)) and (Result[i] > Base) then
    begin
      Result[i + 1] := Result[i + 1] + Result[i] div Base;
      Result[i]     := Result[i] mod Base;
    end;
  end;
end;

{********** Setval ******}
procedure setval(var n: TBigint; val: integer);
var
  i: integer;
begin
  n[0] := val;
  for i := 1 to high(n) do
    n[i] := 0;
end;

{*********** DivSum *********}
function divsum(n: integer): integer;
  {Return the sum of the prpoer divisors of N}
var
  i:  integer;
  sq: integer;
begin
  Result := 1; {1 and n are always divisors}
  {add to to divisor count for all divisors up to sqrt(n)}
  sq     := trunc(sqrt(0.0 + n));
  for i := 2 to sq do
    if n mod i = 0 then
      Result := Result + i + n div i;
  {If perfect square - shouldn't have added sqrt twice}
  if sq * sq = n then
    Result := Result - sq; {perfect square - shouldn't have added sqrt twicw}
end;

{********* SumDigits **********}
function SumDigits(n: integer): integer;
  {add up the digits of n}
begin
  Result := 0;
  while n > 0 do
  begin
    Result := Result + n mod 10;
    n      := n div 10;
  end;
end;

{************ ContinuedFraction ***********}
procedure Continuedfraction(A: array of int64; const wholepart: integer;
  var numerator, denominator: int64);
      {evaluate a continued fraction using standard list format
       [t1; t2,t3,t4,t5...]}

  function continuant(A: array of int64): int64;
    {recursive calc of continuants per Knuth, Vol 2, p340}

  var
    n: integer;

  begin
    n := length(a);
    if n <= maxcontinuant then
      Result := continuants[n]
    else
    begin
      if length(A) = 0 then
        Result := 1
      else if length(A) = 1 then
        Result := a[0]
      else
        Result := A[high(A)] * continuant(slice(A, length(A) - 1)) +
          continuant(slice(A, length(A) - 2));
      Inc(maxcontinuant);
      continuants[maxcontinuant] := Result;
    end;
  end;

var
  A2: array of int64;  {reversed version of A so we can use slice function}
  i:  integer;
  x:  int64;
begin
  SetLength(A2, length(A) - 1);
  {reverse the array for passing to continuant}
  if length(a2) > 0 then
  begin
    for i := 1 to high(A) do
      A2[high(A) - i] := A[i];
    x := a[0];
    denominator := continuant(A2);
    SetLength(A2, length(A2) - 1);
    numerator := x * denominator + continuant(A2);
  end
  else
  begin
    numerator   := a[0];
    denominator := 1;
  end;
end;


{Fraction conversions}
{*************** ConvertStringToDecimal ***************}
function convertStringToDecimal(s:string; var n:extended):Boolean;
{convert a string that may be decimal of fraction form to a floating point number}

var errflag:boolean;

  procedure error(msg:string; index:integer);
  begin
    if index>0 then showmessage(msg+' at position '+inttostr(index))
    else showmessage(msg);
    errflag:=true;
  end;

var
  i,x:integer;
  part:integer;
  decpart:extended;
  nbr:array[1..4] of int64;
  decimaldigits:integer;
begin
  for i:=1 to 4 do nbr[i]:=0;
  decimaldigits:=0;
  part:=1;
  s:=trim(s);
  errflag:=false;
  repeat
    //{$IF compilerversion<=15}
    x:=pos(thousandseparator,s);
    //{$ELSE}
    //x:=pos(Formatsettings.ThousandSeparator,s);
    //{$IFEND}
    if x>0 then delete(s,x,1);
  until x=0;
  repeat
    x:=pos('  ',s);
    if x>0 then delete(s,x,1);
  until x=0;
  //{$IF compilerversion<=15}
  if (pos('/',s)>0) and (pos(decimalseparator,s)>0)
  //{$ELSE}
  //if (pos('/',s)>0) and (pos(FormatSettings.decimalseparator,s)>0)
  //{$IFEND}
  then error('Numbers cannot contain decimal and ''/''',0);

  for i:= 1 to length(s) do
  begin
    //{$IF compilerversion<=15}
    if  s[i] = decimalseparator
    //{$ELSE}
    //if  s[i] = FormatSettings.decimalseparator
    //{$IFEND}
    then  if (part=1) then part:=2 else error('misplaced ''.''',i)
    else
    case s[i] of
      ' ': if ((part=1) or (part=2)) then part:=3
           else error('Misplaced space ',i);
      '/': begin
             if part=1 then  {not integer part, but numerator}
             begin
               nbr[3]:=nbr[1];
               nbr[1]:=0;
               part:=3;
             end;
             if (part=3) then part:=4
             else error('Misplaced ''/''',i);
           end;
      '0'..'9':
            begin
              if part=2 then
              begin
                if decimaldigits<17 then
                begin
                  inc(decimaldigits); {for decimalpart, leading zeros are important}
                  nbr[part]:=nbr[part]*10 +strtoint(s[i]);
                end;
              end
              else nbr[part]:=nbr[part]*10 +strtoint(s[i]);
            end;
    end; {case}
    if errflag then break;
  end;
    if ((nbr[3]>0) and (nbr[4]=0))
      or ((nbr[4]>0) and (nbr[3]=0)) then error('Invalid fraction',0);
    result:=not errflag;
    if result then
    begin
      if nbr[3]=0 then nbr[4]:=1; {to avoid divide by zero}
      if nbr[2]>0 then decpart:=nbr[2]/power(10,decimaldigits)
      else decpart:=0;
      n:=nbr[1]+ decpart + nbr[3]/nbr[4];
    end;
end;

{*************** ConvertfloatFractionString *************}
function convertfloattofractionstring( N:extended; maxdenom:integer;multipleof:boolean):string;
{Convert floating point number, Nto a mixed  fraction display  string.

 If not constrained, N could have very large denominator (up to 19 or 20 digits
 for extended type),  "Maxdenom" specifies the largest denominator to be
 considered  If "Multipleof" is false, the best representation of N using
 denominators  in  the range of 2  to maxdenom is returned.  If "multipleof" is
 true, only  mixed fractions with maxdenom as the denominator are returned.
 Returned fraction strings are always in lowest terms, e.g. 4/16 will be
 returned as 1/4
 }
var
  decpart, offset:extended;
  intpart, denom:integer;
  valtable:array of extended;
  i:integer;
  newdenominator, newnumerator,g:integer;
  s:string;
  minerror:extended;
  fract,e:extended;
  num,m:integer;
begin
  decpart:=frac(N);
  intpart:=trunc(N);
  denom:=trunc(decpart*1e8);
  m:=trunc(1e8);
  //maxdecimals:=8;

  if multipleof then  {express fractional part as nearest multiple of 1/Maxdenom}
  begin
    offset:=1/maxdenom/2;
    setlength(valtable,maxdenom+1);
    for i:=0 to maxdenom-1 do valtable[i]:=i/maxdenom+offset;
    i:=0;
    while valtable[i]<=decpart do inc(i);
    g:=gcd2(i,maxdenom);
    if g>1 then
    begin
      newnumerator:=i div g;
      newdenominator:=maxdenom div g;
    end
    else
    begin
      newnumerator:=i;
      newdenominator:=maxdenom;
    end;
    if (intpart=0) then
    begin
       if (i=0) then s:='0'
       else s:=format('%d/%d',[newnumerator,newdenominator]);
    end
    else {intpart>0}
    begin
      if (i=0) then s:=inttostr(intpart)
      else s:=format('%d %d/%d',[intpart,newnumerator,newdenominator]);
    end;
  end
  else {express fractional part as best estimate a/b with b<=maxdenom}
  begin
    g:=gcd2(denom,m);
    newnumerator:=denom div g;
    newdenominator:= m div g;
    if (newdenominator>=maxdenom)  then
    begin
      {find closest approximation}
      minerror:=1;
      fract:=decpart;
      for i:= 2 to maxdenom do
      begin
        num := round(fract*i);
        if num=0 then num:=1;
        e:=fract-num/i;
        if  (abs(e)< abs(minerror)) then
        begin
          minerror:=e;
          newnumerator:=num;
          newdenominator:=i;
        end;
      end;
    end;
    If intpart<>0
      then if newnumerator>0
           then s:=format('%d  %d/%d',[intpart,newnumerator,newdenominator])
           else s:=inttostr(intpart)
      else if newnumerator>0
           then s:=format('%d/%d',[newnumerator,newdenominator])
           else s:='0';
  end;
  result:=s;
end;

{************ DigitCount  *************}
function digitcount(n:int64):integer;
{count nbr of digits in an integer}
begin
  result:=0;
  while n>0 do
  begin
    n:=n div 10;
    inc(result);
  end;
end;



{--------------------------}
{-TPrimes Class definition-}
{--------------------------}

{********************Primes.Create ***********************}
constructor TPrimes.Create;
  {Calculate primes less than maxval using Sieve of Eratosthenes}
var
  workprimes: array of integer;
  i, j: integer;
  nbr, stopval: integer;
begin
  inherited;
  SetLength(workprimes, maxprimes + 1);
  SetLength(Prime, maxprimes + 1);
  {showmessage('Max prime is '+inttostr(high(x)));}
  SetLength(factors, maxfactors + 1);
  {initialize array starting with 2,3,4,5, etc.}
  for i := 1 to maxprimes do
    workprimes[i] := i + 1;

  { now go through the array}
  for i := 1 to maxprimes div 2 do
  begin
    {if # is greater than 0, then it's a prime}
    if workprimes[i] > 0 then
    begin
      {go through the rest of the array zeroing out all multiples of this prime}
      j := i + workprimes[i];
      while j <= maxprimes do
      begin
        workprimes[j] := 0;
        j := j + workprimes[i];
      end;
    end;
  end;
  prime[0]  := -1;
  {now "pack" the primes back to the beginning positions of the array}
  nbrprimes := 0;
  for i := 1 to maxprimes do
  begin
    if workprimes[i] > 0 then
    begin
      Inc(nbrprimes);
      Prime[nbrprimes] := workprimes[i];
    end;
  end;

  {Now calculate the rest of the primes up to maxval}
  { the hard way (trial and error)}
  stopval := trunc(Sqrt(0.0 + maxval)); {largest prime factor we'll need}
  nbr     := Prime[nbrprimes];
  while (nbr <= stopval) do
  begin
    nbr := Getnextprime(nbr);
    Inc(nbrprimes);

    if nbrprimes >= length(Prime) then
      SetLength(Prime, length(Prime) + maxprimes);
    Prime[nbrprimes] := nbr;
  end;
  SetLength(prime, nbrprimes + 1); {release unused memory at end of array}
end;

{*********************** TPrimes.GetNextPrime ********************}
function TPrimes.Getnextprime(n: int64): int64;
var
  I: integer;
begin
  Result := n;
  if Result < Prime[nbrprimes] then  {it's in the table already}
  begin
    if bsprime(Result, i) then
      Result := prime[i + 1]
    else
      Result := Prime[i];
    exit;
  end;
  if (Result and 1) <> 0 then
    Inc(Result, 2)
  else
    Inc(Result);
  if isprime(Result) then
    exit;
  while Result mod 3 <> 0 do
  begin
    Inc(Result, 2);
    if isprime(Result) then
      exit;
  end;
  Dec(Result, 2);
  while True do
  begin
    Inc(Result, 4);
    if isprime(Result) then
      break;
    Inc(Result, 2);
    if isprime(Result) then
      break;
  end;
end;

{**************** TPrimes.GetPrevPrime ****************}
function TPrimes.GetPrevprime(n: int64): int64;
var
  i: integer;
begin
  Result := n;
  if Result <= Prime[nbrprimes] then  {it's in the table already}
  begin
    bsprime(Result, i);
    Result := prime[i - 1];
    exit;
  end;
  if (Result and 1) <> 0 then  {it's odd}
    Dec(Result, 2)
  else  Dec(Result); {make it odd}
  while (not isprime(Result)) do
    Dec(Result, 2);
end;


{************************* TPrimes.IsPrime *************************}
function TPrimes.Isprime(n: int64): boolean;
  {Tests for primeness and returns true or false}
var
  i: integer;
  stopval, testVal: int64;
  EarlyBreak: boolean;
begin
  Result := False;
  if n <= Prime[nbrprimes] then  {if it's prime. it's in the table already}
    Result := bsprime(n, i)
  else
  begin
    i := 1;
    EarlyBreak := False;
    stopval := trunc(sqrt(0.0 + n));
    for i := 1 to nbrprimes do
    begin
      if (n mod prime[i]) = 0 then
      begin
        EarlyBreak := True;
        break;
      end;
      if prime[i] > stopval then
      begin
        Result := True;
        break;
      end;
    end;
    if (not EarlyBreak) and (Stopval > prime[nbrprimes]) then
    begin
      TestVal := prime[nbrprimes] + 2;
      while TestVal mod 15 <> 0 do
        Dec(testval, 2);
      Dec(testval, 2);
      {check for prime mod 2,3,5}  {Increments = 4,2,4,6,2,6,4,2}

      while True do
      begin
        Inc(testval, 4);
        if (n mod testval) = 0 then
          break;
        Inc(testval, 2);
        if (n mod testval) = 0 then
          break;
        Inc(testval, 4);
        if (n mod testval) = 0 then
          break;
        Inc(testval, 6);
        if testval > stopval then
        begin
          Result := True;
          break;
        end;
        if (n mod testval) = 0 then
          break;
        Inc(testval, 2);
        if (n mod testval) = 0 then
          break;
        Inc(testval, 6);
        if (n mod testval) = 0 then
          break;
        Inc(testval, 4);
        if (n mod testval) = 0 then
          break;
        Inc(testval, 2);
        if testval > stopval then
        begin
          Result := True;
          break;
        end;
        if (n mod testval) = 0 then
          break;
      end;
    end;
  end;
end;

{************************* TPrimes.GetFactors ******************}
procedure TPrimes.Getfactors(const n: int64);
{Returns prime factors}
var
  stopval, testval: int64;
  i, LenF:   integer;
  nbr : int64;
  IsPrime:   boolean;
begin
  nbr := n;
  nbrfactors := 0;
  LenF := length(factors);
  stopval := trunc(Sqrt(0.0 + nbr)) + 1;
  i := 1;
  while (i < nbrprimes) and (Prime[i] <= stopval) do
  begin
    if nbr mod Prime[i] = 0 then {'we found a factor}
    begin
      Inc(nbrfactors);
      if nbrfactors >= LenF then
      begin
        SetLength(factors, Lenf + maxfactors);
        Lenf := Lenf + maxfactors;
      end;
      factors[nbrfactors] := Prime[i];
      nbr     := nbr div Prime[i];  {and get the quotient as the new number}
      stopval := trunc(Sqrt(0.0 + nbr));   { new stopvalue is sqrt of nbr}
    end
    else
      Inc(i);
  end;
  if (nbr > stopval) then
  begin
    testval := prime[nbrprimes] + 2;
    while TestVal mod 15 <> 0 do Dec(testval, 2);
    Dec(testval, 2);
    IsPrime := False;
    while True do
    begin
      Inc(testval, 4);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 2);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 4);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 6);
      if testval > stopval then
      begin
        IsPrime := True;
        break;
      end;
      if (n mod testval) = 0 then
        break;
      Inc(testval, 2);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 6);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 4);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 2);
      if testval > stopval then
      begin
        IsPrime := True;
        break;
      end;
      if (n mod testval) = 0 then
        break;
    end;
    if Isprime = False then
    begin
      while (nbr >= testval) and (TestVal <= stopval) do
      begin
        if nbr mod testval = 0 then
        begin
          Inc(nbrfactors);
          if nbrfactors >= LenF then
          begin
            SetLength(factors, Lenf + maxfactors);
            Lenf := Lenf + maxfactors;
          end;
          factors[nbrfactors] := TestVal;
          nbr     := nbr div TestVal;  {and get the quotient as the new number}
          stopval := trunc(Sqrt(0.0 + nbr));   { new stopvalue is sqrt of nbr}
        end
        else
          TestVal := Primes.GetNextPrime(TestVal);
      end;
    end;
  end;
  Inc(nbrfactors);
  factors[nbrfactors] := nbr;
  //  setlength(factors,nbrfactors+1); {should we tidy up???}
end;


{************************* GetCanonicalFactors ******************}
procedure TPrimes.GetCanonicalfactors(const n: int64);
{Returns prime factors}
var
  stopval,testval: int64;
  i:    integer;
  nbr:  int64;
  nbrc: integer;
  isprime:boolean;
begin
  nbr := n;
  nbrc := 0;
  stopval := trunc(Sqrt(0.0 + nbr));
  i := 1;
  while (i < nbrprimes) and (Prime[i] <= stopval) do
  begin
    if nbr mod Prime[i] = 0 then {'we found a factor}
    begin
      if (nbrc > 0) and (canonicalfactors[nbrc].x = prime[i]) then
        Inc(canonicalfactors[nbrc].y)
      else
      begin
        Inc(nbrc);
        if (nbrc >= length(canonicalfactors)) then
          SetLength(canonicalfactors, length(canonicalfactors) + maxfactors);
        with canonicalfactors[nbrc] do
        begin
          x := prime[i];
          y := 1;
        end;
      end;
      nbr     := nbr div Prime[i];  {and get the quotient as the new number}
      stopval := trunc(Sqrt(0.0 + nbr));   { new stopvalue is sqrt of nbr}
    end
    else
      Inc(i);
  end;

  if (nbr > stopval) then
  begin   {an efficient prime search}
    testval := prime[nbrprimes] + 2;
    while TestVal mod 15 <> 0 do Dec(testval, 2);
    Dec(testval, 2);
    IsPrime := False;
    while True do
    begin
      Inc(testval, 4);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 2);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 4);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 6);
      if testval > stopval then
      begin
        IsPrime := True;
        break;
      end;
      if (n mod testval) = 0 then
        break;
      Inc(testval, 2);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 6);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 4);
      if (n mod testval) = 0 then
        break;
      Inc(testval, 2);
      if testval > stopval then
      begin
        IsPrime := True;
        break;
      end;
      if (n mod testval) = 0 then
        break;
    end;
    if Isprime = False then
    begin
      while (nbr >= testval) and (TestVal <= stopval) do
      begin
        if nbr mod testval = 0 then
        begin
           if (nbrc > 0) and (canonicalfactors[nbrc].x = testval)
           then  inc(canonicalfactors[nbrc].y)
          else
          begin
            Inc(nbrc);
            if (nbrc >= length(canonicalfactors))
            then SetLength(canonicalfactors, length(canonicalfactors) + maxfactors);
            with canonicalfactors[nbrc] do
            begin
              x := testval;
              y := 1;
            end;
          end;
          nbr     := nbr div TestVal;  {and get the quotient as the new number}
          stopval := trunc(Sqrt(0.0 + nbr));   { new stopvalue is sqrt of nbr}
        end
        else
          TestVal := Primes.GetNextPrime(TestVal);
      end;
    end;
   end;
  if (nbrc > 0) and (canonicalfactors[nbrc].x = nbr) then
    Inc(canonicalfactors[nbrc].y)
  else
  begin
    Inc(nbrc);
    if (nbrc >= length(canonicalfactors)) then
      SetLength(canonicalfactors, length(canonicalfactors) + maxfactors);
    with canonicalfactors[nbrc] do
    begin
      x := nbr;
      y := 1;
    end;
  end;
  nbrcanonicalfactors := nbrc;
end;


 function TPrimes.radical(n:int64):int64;   {product of unique prime factors}
 var
   i:integer;
begin
  getcanonicalfactors(n);
  result:=canonicalfactors[1].x;
  for i:=2 to nbrcanonicalfactors do result:=result*canonicalfactors[i].x;
end;


{************ GetNbrDivisors ***********}
function TPrimes.Getnbrdivisors(n: int64): integer;
var
  i: integer;
begin
  getcanonicalfactors(n);
  Result := 1;
  for i := 1 to nbrcanonicalfactors do
    Result := Result * (canonicalfactors[i].y + 1);
  nbrdivisors := Result;
end;

{*********** GetDivisors ************}
procedure Tprimes.GetDivisors(const n: int64);
{------- Getit ----------}
  procedure getit(num: integer; d: int64);
  {recursive procedure to iterate through prime factors & powers to get all divisors}
  var
    i:    integer;
    newd: int64;
  begin
    with canonicalfactors[num] do
      for i := 0 to y do
      begin
        if num = 0 then
        begin
          newd := intpower(x, i);
        end
        else
          newd := d * intpower(x, i);
        if num < nbrcanonicalfactors then
          getit(num + 1, newd)
        else
        begin
          Inc(nbrdiv);
          divisors[nbrdiv] := newd;
        end;
      end;
  end;

var
  i, j: integer;
  temp: int64;
begin
  SetLength(divisors, getnbrdivisors(n) + 1);
  nbrdiv := 0;
  temp   := 1;
  getit(0, temp);
  if nbrdivisors <> nbrdiv then
    ShowMessage('Divisors calc error');
  {let's sort the divisors}
  for i := 1 to nbrdivisors - 1 do
    for j := i + 1 to nbrdivisors do
      if divisors[i] > divisors[j] then
      begin
        temp := divisors[i];
        divisors[i] := divisors[j];
        divisors[j] := temp;
      end;
end;




{************* Primes.destroy ************}
destructor TPrimes.Destroy;
begin
  SetLength(prime, 0);   {release memory}
  SetLength(factors, 0); {ditto}
  inherited;
end;


{************ TPrimes.MaxPrimeInTable ***********}
function TPrimes.MaxPrimeInTable: int64;
begin
  Result := prime[high(prime)];
end;

{************** TPrimes.BSPrime *************}
function TPrimes.BSPrime(const n: int64; var index: integer): boolean;
{Binary search to see if given prime, n, is in the table}
var
  nbr, res: int64;
  First, last, pivot: integer;
begin
  Result := False;
  nbr    := n;
  index  := 0;
  First  := 1;
  last   := nbrprimes;
  repeat
    pivot := (First + last) div 2;
    res   := prime[pivot] - nbr;
    if res = 0 then
    begin
      index  := pivot;
      Result := True;
      exit;
    end
    else if res < 0 then
      First := pivot + 1
    else
      last  := pivot - 1;
  until last < First;
  index := First;
end;

{************** GetNthPrime *************}
function TPrimes.GetNthPrime(const n: integer): int64;
begin
  if (n >= 1) and (n <= nbrprimes) then
    Result := Prime[n]
  else
    Result := -1;
end;


{************** Mapping and Geometry Routines ***********************}

 {********* Deg2rad ***********}
function deg2rad(deg:extended):extended;
{Degrees to Radians}
begin result:=deg * PI / 180.0; end;


{*********** Rad2Deg **********}
function rad2deg(rad:extended):extended;
{radians to degrees}
begin result:=rad / PI * 180.0;  end;



{**************** StrToAngle ************}
function StrtoAngle(const s:string; var angle:extended):boolean;
{Convert string representation of an angle to a numeric value}

           function convertfield(xs:string;var v:extended; msg:string):boolean;
           var errcode:integer;
           begin
             val(xs,v,errcode);
             if errcode<>0 then
             begin
               showmessage('Invalid character in '+msg+' field in string '+ s);
               result:=false;
             end
             else result:=true;
           end;
 var
   n,fn, sign:integer;
   w,ds,ms,ss:string;
   dv,mv,sv:extended;
 begin
   ds:='0';
   ms:='0';
   ss:='0.0';
   w:=trim(s);  {add a stopper}
   sign:=+1;  {default sign}
   n:=0;
   if w='' then
   begin
     result:=false;
     exit;
   end;
   if upcase(w[1]) in ['N','S','E','W','-'] then n:=1
   else if upcase(w[length(w)]) in ['N','S','E','W','-'] then n:=length(w);
   if n>0 then
   begin
     if  (upcase(w[n]) in ['W','S','-']) then sign:=-1;
     delete(w,n,1);
     w:=trimLeft(w);
   end;
   n:=0;
   fn:=0;
   w:=w+','; {add a "stopper"}
   while n<length(w) do
   begin
     inc(n);
     if (fn=0) and (w[n] in angledelims)
     then
     begin
       ds:=copy(w,1,n-1);
       delete(w,1,n);
       n:=0;
       while (length(w)>0) and (w[1] in angledelims {[' ',deg,minmark,',',':','"']})
       do delete(w,1,1);
       inc(fn);
     end
     else if  w[n] in angledelims {[' ',minmark,',','''',':']} then
     begin
       if fn=1 then ms:=copy(w,1,n-1)
       else if fn=2 then ss:=copy(w,1,n-1);
       delete(w,1,n);
       n:=0;
       while (length(w)>0) and (w[1] in angledelims {[' ',minmark,',','''',':']})
       do delete(w,1,1);
       inc(fn);
     end;
   end;
   result:=convertfield(ds,dv,'degrees');
   if result then result:=convertfield(ms,mv,'minutes');
   if result then result:=convertfield(ss,sv,'seconds');
   if result
   then angle:=sign*(dv+mv/60+sv/3600)
   else angle:=0;
 end;


{********* AngleToStr ************}
 function AngleToStr(angle:extended):string;
 {make string representation  of an angle}
       var
         D:integer;
         M,S:extended;
       begin
         d:=Trunc(angle);
         m:=abs(frac(angle)*60);
         s:=frac(M)*60;
         m:=int(M);
         if s>=59.99 then
         begin
           s:=0;
           m:=m+1;
         end;
         if (angle<0) and (d=0) then
         result:=format('-%3d° %2d´ %5.2f´´',[d,trunc(m),s])
         else result:=format('%3d° %2d´ %5.2f´´',[d,trunc(m),s]);
       end;


function GetLongToMercProjection(const long:extended):extended;
    begin
      result:=long;
    end;

function GetLatToMercProjection(const Lat:Extended):Extended;
  begin
    result:=rad2deg(ln(abs(tan(deg2rad(lat))+1/cos(deg2rad(Lat)))));
  end;

function GetMercProjectionToLong(const ProjLong:extended):extended;
  begin
    result:=Projlong;
  end;

function GetMercProjectionToLat(const ProjLat:extended):extended;
  begin
    result:=rad2deg(arctan(sinh(deg2rad(ProjLat))));
  end;

procedure Randomize64 ;
begin
  QueryPerformanceCounter(Int64(RandSeed64))
end {Randomize64} ;

//{$IF compilerversion>15}  {After Delphi 7}
{*************** 64-bit Random routines for Delphi after D7 **********}
const
Factor = 6364136223846793005 { Said to be OK by Knuth } ;
HalfTo64 = 1.0 / (65536.0 * 65536.0 * 65536.0 * 65536.0) ;
 {$OVERFLOWCHECKS ON} {$RANGECHECKS ON}

function Random64 : extended ; overload ;
begin
  {$OVERFLOWCHECKS OFF} {$RANGECHECKS OFF}
  RandSeed64 := RandSeed64*Factor + 1 ;
  {$RANGECHECKS ON} {$OVERFLOWCHECKS ON}
  Result := RandSeed64*HalfTo64 ;
  end {Random64} ;

function Random64(const UI64 : UInt64) : UInt64 ; overload ;
begin
  Result := Trunc((Random64)*UI64)
end {Random64} ;

//{$ELSE}
 {64 bit RNG for Delphi 7 or earlier}
{function random64(Const N:int64):int64;   overload;
var r1:TInteger;
begin
  r1:=tinteger.create(N);
  r1.random(r1);
  r1.converttoint64(result);
  r1.free;
end;}


{function random64:extended; overload;
var r1:integer;
begin
  Result:=1/random64(high(Int64));
end;}
//{$IFEND}

{initialization
  Primes := TPrimes.Create;

finalization
  Primes.Destroy; }

end.
