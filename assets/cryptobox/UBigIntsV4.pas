Unit UBigIntsV4;
 { Copyright 2001-2015, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org
  This program may be used or modified for any non-commercial purpose
  so long as this original notice remains in place.
  All other rights are reserved
}

{ Arbitarily large integer unit -
  Operations supported:
  Assign, Add, Subtract, Multiply, Divide, Modulo, Compare, Factorial
  (Factorial limited to max integer, run time would probably limit it
  to much less)
  All operations are methods of a TInteger class and replace the value with the
  result.  For binary operations (all except factorial), the second operand is
  passed as a parameter to the procedure.
}
//{$INCLUDE UBigIntsChangeHistory.txt}
interface

uses Forms, Dialogs, SysUtils, Windows;
type
  TDigits = array of int64;
  {$IF compilerversion>15}
  TInteger = record
  {$Else}
  TInteger  = class(TObject)
  {$IfEnd}
  private
    Sign:  integer;
    fDigits: TDigits;
    Base:  integer;
    procedure AbsAdd(const I2: TInteger);
    function  AbsCompare(I2: TInteger): integer; overload;
    function  AbsCompare(I2: int64): integer; overload;
    procedure AbsSubtract(const I2: TInteger);
    function  GetBasePower: integer;
    procedure Trim;
    function  GetLength: integer;
    //procedure ChangeLength(new: integer);
    procedure SetDigitLength(const k: integer);
    procedure assignsmall(I2: int64);
    procedure  divmodsmall(d: int64; var rem: int64);
    procedure  divide2; { fast divide by 2 }
   public

    constructor Create(const initialValue: int64);  overload;
    {$IF compilerversion <= 15}
    constructor Create;  overload;
    {$IFEND}
    procedure Free;
    property Digits: TDigits Read fDigits;
    procedure Assign(const I2: TInteger); overload;
    procedure Assign(const I2: int64); overload;
    procedure Assign(const I2: string); overload;
    procedure AbsoluteValue;
    procedure Add(const I2: TInteger); overload;
    procedure Add(const I2: int64); overload;
    procedure AssignZero;
    procedure AssignOne;
    procedure Subtract(const I2: TInteger); overload;
    procedure Subtract(const I2: int64); overload;
    procedure Mult(const I2: TInteger); overload;
    procedure Mult(const I2: int64); overload;
    procedure FastMult(const I2: TInteger);
    procedure Divide(const I2: TInteger); overload;
    procedure Divide(const I2: int64); overload;
    procedure  Modulo(Const I2: TInteger); overload;
    procedure  Modulo(Const N: int64); overload;
    procedure ModPow(const I2, m: TInteger);
    procedure InvMod(I2: TInteger);
    procedure DivideRem(const I2: TInteger; var remain: TInteger);
    procedure DivideRemTrunc(const I2: TInteger; var remain: TInteger);
    Procedure DivideRemFloor(const I2: TInteger; var remain: TInteger);
    Procedure DivideRemEuclidean(const I2: TInteger; var remain: TInteger);
    function Compare(I2: TInteger): integer; overload;
    function Compare(I2: int64): integer; overload;
    procedure Factorial;
    function ConvertToDecimalString(commas: boolean): string;
    function ConvertToInt64(var N: int64): boolean;
    function DigitCount: integer;
    procedure SetSign(s: integer);
    function GetSign: integer;
    function IsOdd: boolean;
    function IsPositive: boolean;
    function IsNegative: boolean;
    function IsProbablyPrime: boolean;
    function IsZero: boolean;
    //function IsOne: boolean;
    procedure ChangeSign;
    procedure Pow(const exponent: int64); overload;


    procedure Sqroot;
    procedure Square;
    procedure FastSquare;

    procedure Gcd(const I2: TInteger); overload;
    procedure Gcd(const I2: int64); overload;
    procedure NRoot(const Root: int64); overload;
    //procedure NRoot(const Root :Tinteger); overload;
    function GetBase: integer;

    function BitCount: integer;
    function  ConvertToHexString: String;
    function  AssignRandomPrime(BitLength: integer; seed: String; mustMatchBitLength: boolean): boolean;
    function  AssignHex(HexStr: String): boolean;
    procedure  RandomOfSize(size: integer);
    procedure  Random(maxint: TInteger);
    procedure  Getnextprime;

    //property Length: integer read GetLength write Setdigitlength {ChangeLength};
    {$IF compilerversion > 15}
    class operator Implicit(a: Int64): TInteger;
    class operator Implicit(a: TInteger): Int64;
    //class operator Implicit(s: string): TInteger;
    //class operator Implicit(a: TInteger): TInteger;
    class operator Implicit(a: TInteger): string; // write to a string;
    class operator Negative(a: TInteger): TInteger;

    class operator Add(a, b: TInteger): TInteger;
    class operator Subtract(a, b: TInteger): TInteger;
    class operator Inc(var a: TInteger): TInteger;
    class operator Dec(var a: TInteger): TInteger;
    class operator Equal(a, b: TInteger): boolean;
    class operator NotEqual(a: TInteger; b: TInteger): boolean;
    class operator GreaterThan(a: TInteger; b: TInteger): boolean;
    class operator GreaterThanOrEqual(a: TInteger; b: TInteger): boolean;
    class operator LessThan(a: TInteger; b: TInteger): boolean;
    class operator LessThanOrEqual(a: TInteger; b: TInteger): boolean;
    class operator Multiply(a, b: TInteger): TInteger;
    class operator IntDivide(a, b: TInteger): TInteger;
    class operator Modulus(a, b: TInteger): TInteger;

    {$IFEND}
  end;
  {Caution - calculations with mixed basevalues are not allowed,
   changes to Baseval should be made before any other TInteger
   operations}

procedure SetBaseVal(const newbase: integer);
function GetBasePower: integer;
function  GetBase: integer;
procedure  SetThreadSafe(newval: boolean);

implementation

uses Math;


const
  empty: Int64 = 0;


var
   ThreadSafe: boolean = false;
   BaseVal: integer = 1000; { 1,000 changed to 100,000 at initialization time }
  BasePower: integer;
  ScratchPads: array of TInteger;
  LastScratchPad: integer;

   { ************* GetNextScratchPad ************* }
{************* GetNextScratchPad *************}
function GetNextScratchPad(InitVal: TInteger): TInteger; overload;
{retrieve or create a work variable and initialize it with TInteger value}
var
  L: integer;

begin
  //result:=Tinteger.create(0);
  
   if LastScratchPad > High(ScratchPads) then
   begin
    L:= Length(ScratchPads);
    SetLength(ScratchPads, L + 1);
    ScratchPads[L]:= TInteger.Create(Empty);
    ScratchPads[L].Assign(InitVal);
    Result:= ScratchPads[L];
  end
  else Result:= ScratchPads[LastScratchPad];
  Result.Assign(InitVal);
  //result.base:=baseval;
  Inc(LastScratchPad);
end;

{ ************* GetNextScratchPad ************* }
function GetNextScratchPad(InitVal: int64): TInteger; overload;
{ retrieve or create a work variable and initialize it with int64 value }
var
  L: integer;
begin
  if LastScratchPad > High(ScratchPads) then begin
    L:= Length(ScratchPads);
    SetLength(ScratchPads, L + 1);
    ScratchPads[L]:= TInteger.Create(Empty);
    ScratchPads[L].Assign(InitVal);
    Result:= ScratchPads[L];
    Inc(LastScratchPad);
    Exit;
  end;
  Result:= ScratchPads[LastScratchPad];
  Result.Assign(InitVal);
  Inc(LastScratchPad);
end;

{ *********** GetNextScratchPad ********* }
function GetNextScratchPad: TInteger; overload;
{ Overload version without initial value, intiaize to 0 }
begin
  Result:= GetNextScratchPad(0);
end;

{ ************* Release ScratchPad ********* }
procedure ReleaseScratchPad(t: TInteger);
begin
  If ThreadSafe then t.Free
  else begin
    Dec(LastScratchPad);
    //Assert(t = ScratchPads[LastScratchPad], 'Scratchpad synch problem ');
    ScratchPads[LastScratchPad].SetDigitLength(1);
  end;
end;

{ **************** GetScratchPad *************** }
function GetScratchPad(InitVal: TInteger): TInteger; overload;
{ GetScratchPad tests for Threadsafe and, if true,  always creates new since
  scratchpads array could be  shared, if Thredsafe is false ( the default) then
  treat as GetNextScratchPad }
begin
  if ThreadSafe then begin
    Result:= TInteger.Create(empty);
    Result.Assign(InitVal);
  end
  else Result:= GetNextScratchPad(InitVal);
end;

{ **************** GetScratchPad *************** }
function GetScratchPad(InitVal: int64 = 0): TInteger; overload;
{ GetScratchPad tests for Threadsafe and, if true,  always creates new since
  scratchpads array would be  shared, if false treat as GetNextScrattchPad }
begin
  if ThreadSafe then begin
    Result:= TInteger.Create(empty);
    Result.Assign(InitVal);
  end
  else Result:= GetNextScratchPad(InitVal);
end;

{ *************** SetBaseVal ************* }
procedure SetBaseVal(const newbase: integer);

  Procedure Setup(var x: TInteger);
  begin
    //if assigned(x) then x.Free;
    x:= TInteger.Create(empty);
  end;

var
  i, N: integer;
begin
  BaseVal:= 10;
  BasePower:= 1;
  N:= newbase;
  { validate new base value }
  if N > 1E6 then N:= trunc(1E6)
  else if N < 10 then N:= 10;
  while N > 10 do begin
    Inc(BasePower);
    N:= N div 10;
    BaseVal:= BaseVal * 10;
  end;
  if LastScratchPad > 0 then Showmessage('Warning - Base value changed,' + #13 + 'all scratchpad variables have been released');
  for i:= 0 to high(ScratchPads) do ScratchPads[i].Free;
  SetLength(ScratchPads, 20);
  for i:= 0 to 19 do begin
    ScratchPads[i]:= TInteger.Create(empty);
  end;
  LastScratchPad:= 0;
end;

{ ************** GetBasePower ********** }
function GetBasePower: integer;
begin
  Result:= BasePower;
end;

function GetBase: integer;
begin
  Result:= BaseVal;
end;

procedure SetThreadSafe(newval: boolean);
begin
  ThreadSafe:= newval;
end;

{$IF compilerVersion <=15}
{ ************* Create *********** }
constructor TInteger.Create;
begin
  inherited;
  Base:=baseval;
  assignzero;
end;
{$IFEND}

{ ************* Create *********** }
constructor TInteger.Create(const initialValue: int64);
begin
  {$IF compilerversion <=15}
  inherited create;;
  {$IFEND}
  Base:= BaseVal; {save  base in TInteger in case we want to handle other bases later }
  if Assigned(@initialValue) then begin
    self.Assign(initialValue);
  end
  else begin
    AssignZero;
  end;
end;


{*************** Free *************}
procedure TInteger.Free;
begin
  SetLength(self.fDigits,0);
  Sign:= 0;
  inherited;
end;


(*
  {************ ShiftRight ***********}
  function TInteger.ShiftRight: integer;
  {Divide value by base and return the remainder}
  var
  c, i: integer;
  begin
  Result := fDigits[0];
  c      := high(fDigits);
  for i := 0 to c - 1 do
  fDigits[i] := fDigits[i + 1];
  // do not setlength to zero...
  if c > 0 then
  begin
  SetLength(fDigits, c);
  Trim;
  end
  else
  self.AssignZero;
  end;
*)

(*
  {********** ShiftLeft *********}
  procedure TInteger.ShiftLeft;
  {Multiply value by base}
  var
  c, i: integer;
  begin
  c := high(fDigits);
  SetLength(fDigits, c + 2);
  for i := c downto 0 do
  fDigits[i + 1] := fDigits[i];
  fDigits[0] := 0;
  Trim;
  end;
*)

{ *************** SetDigitLength********** }
procedure TInteger.SetDigitLength(const k: integer);
{ Expand or contract the number of digits }
begin
  SetLength(fDigits, k);
end;

{ *********** GetLength ********** }
function TInteger.GetLength: integer;
{ Return the number of digits for this base }
begin
  Result:= System.Length(fDigits);
end;
(*
procedure TInteger.ChangeLength(new: integer);
begin
  SetLength(fDigits, new);
end;
*)

{ ************** Subtract ************ }
procedure TInteger.Subtract(const I2: TInteger);
{ Subtract by negating, adding, and negating again }
begin
  I2.ChangeSign;
  Add(I2);
  I2.ChangeSign;
end;

{ ************* Subtract (64 bit integer) }
procedure TInteger.Subtract(const I2: int64);
begin
  Add(-I2);
end;



function TInteger.DigitCount: integer;
{ Return count of base 10 digits in the number }
var
  N: int64;
  Top: integer;
begin
  Top:= high(Digits);
  Result:= Top * GetBasePower;
  N:= Digits[Top];
  if N > 0 then Result:= Result + 1 + system.trunc(Math.Log10(N));
end;

{ ************* SetSign ************ }
procedure TInteger.SetSign(s: integer);
{ Set the sign of the number to match the passed integer }
begin
  if s > 0 then Sign:= +1
  else if s < 0 then Sign:= -1
  else Sign:= 0;
end;

{ ************** GetSign ********* }
function TInteger.GetSign: integer;
begin
  Result:= Sign;
end;



{ *********** IsPositive *********** }
function TInteger.IsPositive: boolean;
begin
  Result:= Sign > 0;
end;

{ *********** IsNegative *********** }
function TInteger.IsNegative: boolean;
begin
  Result:= Sign < 0;
end;

{ ************** ChangeSign ********** }
procedure TInteger.ChangeSign;
begin
  Sign:= -Sign;
end;

{ ******** Square ********* }
procedure TInteger.Square;
{ This square save multiplications, assume high(fdigits)=10, there are 100
  multiplications that must be preformed.  Of these 10 are unique diagonals,
  of the remaining 90 (100-10), 45 are repeated.  This procedure save
  (N*(N-1))/2 multiplications, (e.g., 45 of 100 multiplies). }
const
  ConstShift = 48;
var
  Carry, N, product: int64;
  xstart, i, j, k: integer;
  imult1: TInteger;
begin
  xstart:= high(self.fDigits);
  // imult1.AssignZero;
  imult1:= GetNextScratchPad(1); { assign 1 just to force sign to + }
  // imult1.Sign := Sign * Sign;
  SetLength(imult1.fDigits, xstart + xstart + 3);
  // Step 1 - calculate diagonal
  for i:= 0 to xstart do begin
    k:= i * 2;
    product:= fDigits[i] * fDigits[i];
    Carry:= product shr ConstShift;
    if Carry = 0 then imult1.fDigits[k]:= product
    else begin
      Carry:= product div Base;
      imult1.fDigits[k]:= product - Carry * Base;
      imult1.fDigits[k + 1]:= Carry;
    end;
  end;
  // Step 2 - calculate repeating part
  for i:= 0 to xstart do begin
    Carry:= 0;
    for j:= i + 1 to xstart do begin
      k:= i + j;
      product:= fDigits[j] * fDigits[i] * 2 + imult1.fDigits[k] + Carry;
      Carry:= product shr ConstShift;
      if Carry = 0 then imult1.fDigits[k]:= product
      else begin
        Carry:= product div Base;
        imult1.fDigits[k]:= product - Carry * Base;
      end;
    end;
    k:= xstart + i + 1;
    imult1.fDigits[k]:= Carry + imult1.fDigits[k];
  end;
  // Step 3 - place in proper base
  xstart:= high(imult1.fDigits);
  Carry:= 0;
  for i:= 0 to xstart - 1 do begin
    N:= imult1.fDigits[i] + Carry;
    Carry:= N div Base;
    imult1.fDigits[i]:= N - Carry * Base;
  end;
  imult1.fDigits[xstart]:= Carry;
  Assign(imult1);
  ReleaseScratchPad(imult1);
end;



{ ********** Trim *********** }
procedure TInteger.Trim;
{ eliminate leading zeros }
var
  i, j: integer;
begin
  i:= high(fDigits);
  if i >= 0 then begin
    j:= i;
    if (fDigits[0] <> 0) then
      while (fDigits[i] = 0) do Dec(i)
    else
      while (i > 0) and (fDigits[i] = 0) do Dec(i);
    if j <> i then SetLength(fDigits, i + 1);
    // make sure sign is zero if value = 0...
    if (i = 0) and (self.Digits[0] = 0) then Sign:= 0;
  end
  else begin
    AssignZero;
  end;
end;

{ **************** GetBasePower ******* }
function TInteger.GetBasePower: integer;
var
  N: integer;
begin
  if Base = BaseVal then Result:= BasePower
  else begin
    Result:= 0;
    N:= Base;
    while N > 1 do begin
      Inc(BasePower);
      N:= N div 10;
    end;
  end;
end;

{ ************* Assign ********** }
procedure TInteger.Assign(const I2: TInteger); { Assign - TInteger }
{ Loop replaced by Move for speed by Chalres D,  Mar 2006 }
var
  len: integer;
begin
  if base=0 then base:=I2.base;
  if I2.Base = Base then
  begin
    //len:= I2.length;
    len:=length(i2.fdigits);
    //self.length:= len;
    SetDigitLength(len);
    move(I2.fDigits[0], fDigits[0], len * sizeof(int64));
    Sign:= I2.Sign;

    Trim;
  end
  else self.Assign(I2.ConvertToDecimalString(false));
end;

{ ************ Assign (int64)*********** }
procedure TInteger.Assign(const I2: int64);
{ Assign - int64 }
var
  i: integer;
  N, nn: int64;
begin
  base:=baseval;
  if system.abs(I2) < Base then assignsmall(I2)
  else begin
    SetLength(fDigits, 20);
    N:= system.abs(I2);
    i:= 0;
    repeat
      nn:= N div Base;
      fDigits[i]:= N - nn * Base;
      N:= nn;
      Inc(i);
    until N = 0;
    if I2 < 0 then Sign:= -1
    else if I2 = 0 then Sign:= 0
    else if I2 > 0 then Sign:= +1;
    SetLength(fDigits, i);
    Trim;
  end;
end;

{ ************* Assign   (String type ********* }
procedure TInteger.Assign(const I2: string);
{ Convert a  string number }
var
  i, j: integer;
  zeroval: boolean;
  N, nn: int64;
  pos: integer;
begin
  N:= System.Length(I2) div GetBasePower + 1;
  SetLength(fDigits, N);
  for i:= 0 to N - 1 do fDigits[i]:= 0;
  Sign:= +1;
  j:= 0;
  zeroval:= True;
  N:= 0;
  pos:= 1;
  for i:= System.Length(I2) downto 1 do begin
    if I2[i] in ['0' .. '9'] then begin
      N:= N + pos * (Ord(I2[i]) - Ord('0'));
      pos:= pos * 10;
      if pos > Base then begin
        nn:= N div Base;
        fDigits[j]:= N - nn * Base;
        N:= nn;
        pos:= 10;
        Inc(j);
        zeroval:= false;
      end
      else;
    end
    else if I2[i] = '-' then Sign:= -1;
  end;
  fDigits[j]:= N; { final piece of the number }
  if zeroval and (N = 0) then Sign:= 0;
  Trim;
end;

{ ************ Add ********* }
procedure TInteger.Add(const I2: TInteger);
{ add - TInteger }
var
  ii: TInteger;
begin
  ii:= GetNextScratchPad(I2);
  if Sign <> ii.Sign then AbsSubtract(ii)
  else AbsAdd(ii);
  ReleaseScratchPad(ii);
end;

{ **************** AbsAdd *************** }
procedure TInteger.AbsAdd(const I2: TInteger);
{ add values ignoring signs }
var
  i: integer;
  N, Carry: int64;
  i3: TInteger;
begin
  // I3.Assign(self);
  i3:= GetNextScratchPad(self);
  //SetLength(fDigits, max(self.Length, I2.Length) + 1);
  SetLength(fDigits, max(length(fDigits), length(i2.fDigits)) + 1);
  { "add" could grow result by two digit }
  i:= 0;
  Carry:= 0;
  //while i < min(I2.Length, I3.Length) do begin
  while i < min(length(I2.fDigits), length(I3.fdigits)) do
  begin
    N:= I2.fDigits[i] + i3.fDigits[i] + Carry;
    Carry:= N div Base;
    fDigits[i]:= N - Carry * Base;
    Inc(i);
  end;
  if length(i2.fDigits) > length(i3.fDigits) then
  begin
    SetLength(fDigits, max(length(fDigits), length(i2.fDigits)) + 1);
    while i < { = } length(I2.fdigits) do
    begin
      N:= I2.fDigits[i] + Carry;
      Carry:= N div Base;
      fDigits[i]:= N - Carry * Base;
      Inc(i);
    end
  end
  //If Length > i2.Length then begin
  else if length(i3.fdigits)> length(i2.fdigits) then
  begin
    while i < { = } length(i3.fDigits) do
    begin
      N:= i3.fDigits[i] + Carry;
      Carry:= N div Base;
      fDigits[i]:= N - Carry * Base;
      Inc(i);
    end;
  end;
  fDigits[i]:= Carry;
  Trim;
  ReleaseScratchPad(i3);
end;

{ ************* Add (int64) ******** }
procedure TInteger.Add(const I2: int64);
{ Add - Int64 }
var
  IAdd3: TInteger;
begin
  // IAdd3.Assign(I2);
  IAdd3:= GetNextScratchPad(I2);
  Add(IAdd3);
  ReleaseScratchPad(IAdd3);
end;

{ *************** AbsSubtract ************* }
procedure TInteger.AbsSubtract(const I2: TInteger);
{ Subtract values ignoring signs }
var
  c: integer;
  i3: TInteger;
  i, j, k: integer;
begin { request was subtract and signs are same,
    or request was add and signs are different }
  c:= AbsCompare(I2);

  // i3 := TInteger.Create;
  i3:= GetNextScratchPad(self);
  if c < 0 then { abs(i2) larger, swap and subtract }
  begin
    // i3.Assign(self);
    Assign(I2);
  end
  else if c >= 0 then { self is bigger } i3.Assign(I2);
  for i:= 0 to high(i3.fDigits) do begin
    if fDigits[i] >= i3.fDigits[i] then fDigits[i]:= fDigits[i] - i3.fDigits[i]
    else begin { have to "borrow" }
      j:= i + 1;
      while (j <= high(fDigits)) and (fDigits[j] = 0) do Inc(j);
      if j <= high(fDigits) then begin
        for k:= j downto i + 1 do begin
          Dec(fDigits[k]);
          fDigits[k - 1]:= fDigits[k - 1] + Base;
        end;
        fDigits[i]:= fDigits[i] - i3.fDigits[i];
      end
      else Showmessage('Subtract error');
    end;
  end;
  // i3.Free;
  ReleaseScratchPad(i3);
  Trim;
end;

{ *************** Mult  (TInteger type) ********* }
procedure TInteger.Mult(const I2: TInteger);
{ Multiply - by TInteger }
const
  ConstShift = 48;
var
  Carry, N, product: int64;
  xstart, ystart, i, j, k: integer;
  imult1: TInteger;
begin
  xstart:= high(self.fDigits);
  ystart:= high(I2.fDigits);
  // imult1.AssignZero;
  imult1:= GetNextScratchPad;
  imult1.Sign:= I2.Sign * Sign;
  SetLength(imult1.fDigits, xstart + ystart + 3);
  // long multiply ignoring base
  for i:= 0 to xstart do begin
    Carry:= 0;
    for j:= 0 to ystart do begin
      k:= i + j;
      product:= I2.fDigits[j] * self.fDigits[i] + imult1.fDigits[k] + Carry;
      Carry:= product shr ConstShift;
      if Carry = 0 then imult1.fDigits[k]:= product
      else begin
        Carry:= product div Base;
        imult1.fDigits[k]:= product - Carry * Base;
      end;
    end;
    imult1.fDigits[ystart + i + 1]:= Carry;
  end;
  // place in proper base
  xstart:= length(imult1.fdigits) - 1;
  Carry:= 0;
  for i:= 0 to xstart - 1 do begin
    N:= imult1.fDigits[i] + Carry;
    Carry:= N div Base;
    imult1.fDigits[i]:= N - Carry * Base;
  end;
  imult1.fDigits[xstart]:= Carry;
  Assign(imult1);
  ReleaseScratchPad(imult1);
end;

{ *************** Mult  (Int64 type) ********* }
procedure TInteger.Mult(const I2: int64);
{ Multiply - by int64 }
var
  Carry, N, d: int64;
  i: integer;
  ITemp: TInteger;
begin
  d:= system.abs(I2);
  if d > $7FFFFFFF then { larger than 32 bits, use extended multiply }
  begin
    ITemp:= GetNextScratchPad(I2);
    self.Mult(ITemp);
    ReleaseScratchPad(ITemp);
    Exit;
  end;
  Carry:= 0;
  for i:= 0 to high(fDigits) do begin
    N:= fDigits[i] * d + Carry;
    Carry:= N div Base;
    fDigits[i]:= N - Carry * Base;
  end;
  if Carry <> 0 then begin
    i:= high(fDigits) + 1;
    SetLength(fDigits, i + 11 div GetBasePower + 1);
    while Carry > 0 do begin
      N:= Carry;
      Carry:= N div Base;
      fDigits[i]:= N - Carry * Base;
      Inc(i);
    end;
  end;
  Trim;
  SetSign(I2 * Sign);
end;






{ ************ Divide ************* }
procedure TInteger.Divide(const I2: TInteger);
{ Divide - by TInteger }
var
  dummy: int64;
  idiv3: TInteger;
begin
  idiv3:= GetNextScratchPad;
  if high(I2.fDigits) = 0 then divmodsmall(I2.Sign * I2.fDigits[0], dummy)
  else
    { IDiv3 holds the remainder (which we don't need) }
      DivideRem(I2, idiv3);
  ReleaseScratchPad(idiv3);
end;

{ ************* Divide (Int64) ********** }
procedure TInteger.Divide(const I2: int64);
{ Divide - by Int64 }
var
  dummy: int64;
  idiv2: TInteger;
begin
  if I2 = 0 then Exit;

  if system.abs(I2) < Base then divmodsmall(I2, dummy)
  else begin
    // idiv2.Assign(i2);
    idiv2:= GetNextScratchPad(I2);
    Divide(idiv2);
    ReleaseScratchPad(idiv2);
  end;
end;

{ ***************** Modulo ************* }
procedure TInteger.Modulo(const I2: TInteger);
{ Modulo (remainder after division) - by TInteger }
var
  k: int64;
  imod3: TInteger;
begin
  if high(I2.fDigits) = 0 then begin
    divmodsmall(I2.Sign * I2.fDigits[0], k);
    assignsmall(k);
  end
  else

  begin
    imod3:= GetNextScratchPad;
    DivideRem(I2, imod3);
    Assign(imod3);
    ReleaseScratchPad(imod3);
  end;
end;

{ ***************** Modulo ************* }
procedure TInteger.Modulo(const N: int64);
var
  I2: TInteger;
begin
  I2:= GetNextScratchPad(N);
  Modulo(I2);
  ReleaseScratchPad(I2);
end;

{ **************** DivideremTrunc *************** }
procedure TInteger.DivideRemTrunc(const I2: TInteger; var remain: TInteger);
begin
  DivideRem(I2, remain);
end;

{ **************** Dividerem *************** }
procedure TInteger.DivideRem(const I2: TInteger; var remain: TInteger);
(*
  This version is based on a paper "Multiple-length Division Revisited: a Tour
  of the Minefield", by Per Brinch Hansen, Software - Practice and Experience,
  Vol 24(6), June 1994.

  Efficient implementation of long division
*)
{ Product }
  procedure product(var x: TInteger; y: TInteger; k: integer);
  var
    { carry, } i: integer;
    Carry, m, temp: int64;
  begin
    // multiple-length division revisited
    m:= y.GetLength;
    x.AssignZero;
    Carry:= 0;
    if length(x.fdigits) <= m then x.setdigitlength(m + 1);
    for i:= 0 to m - 1 do begin
      temp:= y.fDigits[i] * k + Carry;
      Carry:= temp div BaseVal;
      x.fDigits[i]:= temp - Carry * BaseVal;
    end;
    x.fDigits[m]:= Carry;
  end;

  procedure Quotient(var x: TInteger; y: TInteger; k: integer);
  var
    i, m: integer;
    temp, Carry: int64;
  begin
    m:= y.GetLength;
    x.AssignZero;
    Carry:= 0;
    SetLength(x.fDigits, m);
    for i:= m - 1 downto 0 do begin
      temp:= Carry * BaseVal + y.fDigits[i];
      x.fDigits[i]:= temp div k;
      Carry:= temp - x.Digits[i] * k;
    end;
  end;

  procedure Remainder(var x: TInteger; y: TInteger; k: integer);
  var
    Carry, N, temp: int64;
    i, m: integer;
  begin
    m:= y.GetLength;
    x.AssignZero;
    Carry:= 0;
    SetLength(x.fDigits, m);
    for i:= m - 1 downto 0 do begin
      N:= (Carry * BaseVal + y.fDigits[i]);
      temp:= N div k;
      Carry:= N - temp * k;
    end;
    x.fDigits[0]:= Carry;
  end;

  function Trial(r, d: TInteger; k, m: integer): int64;
  var
    d2, r3: int64;
    km: integer;
  begin
    { 2 <= m <= k+m <= w }
    km:= k + m;
    if length(r.fdigits) < km + 1 then r.setdigitLength(km + 1);
    r3:= (r.fDigits[km] * BaseVal + r.fDigits[km - 1]) * BaseVal + r.fDigits[km - 2];
    d2:= d.fDigits[m - 1] * BaseVal + d.fDigits[m - 2];
    Result:= min(r3 div d2, BaseVal - 1);
  end;

  function Smaller(r, dq: TInteger; k, m: integer): boolean;
  var
    i, j: integer;
  begin
    { 0 <= k <= k+m <= w }
    i:= m;
    j:= 0;
    while i <> j do
      if r.fDigits[i + k] <> dq.fDigits[i] then j:= i
      else Dec(i);
    Result:= r.fDigits[i + k] < dq.fDigits[i];
  end;

  procedure Difference(var r: TInteger; dq: TInteger; k, m: integer);
  var
    borrow, diff, i: integer;
    acarry: int64;
  begin
    { 0 <= k <= k+m <= w }
    if Length(r.fdigits) < m + k + 1 then r.SetdigitLength(m + k + 1);
    if length(dq.fdigits) < m + 1 then dq.SetdigitLength(m + 1);
    borrow:= 0;
    for i:= 0 to m do begin
      diff:= r.fDigits[i + k] - dq.fDigits[i] - borrow + BaseVal;
      acarry:= diff div BaseVal;
      r.fDigits[i + k]:= diff - acarry * BaseVal;
      borrow:= 1 - acarry;
    end;
    if borrow <> 0 then Showmessage('Difference Overflow');
  end;

  procedure LongDivide(x, y: TInteger; var q, r: TInteger; const N, m: integer);
  var
    f, k: integer;
    qt: int64;
    idiv4: TInteger;
    d, dq: TInteger;
  begin
    { 2 <= m <= n <= w }
    f:= BaseVal div (y.fDigits[m - 1] + 1);
    d:= GetNextScratchPad;
    dq:= GetNextScratchPad;
    product(r, x, f);
    product(d, y, f);
    q.AssignZero;
    SetLength(q.fDigits, N - m + 1);

    for k:= N - m downto 0 do begin
      { 2 <= m <= k+m <=n <= w }
      qt:= Trial(r, d, k, m);
      product(dq, d, qt);

      if length(dq.fdigits) < m + 1 then dq.SetDigitLength(m + 1);
      if Smaller(r, dq, k, m) then begin
        qt:= qt - 1;
        product(dq, d, qt);
      end;
      if k > high(q.fDigits) then SetLength(q.fDigits, k + 1);
      q.fDigits[k]:= qt;
      Difference(r, dq, k, m);
    end;
    // idiv4.Assign(r);
    idiv4:= GetNextScratchPad(r);
    Quotient(r, idiv4, f);
    r.Trim;
    ReleaseScratchPad(idiv4);
    ReleaseScratchPad(dq);
    ReleaseScratchPad(d);
  end;

  procedure Division(x, y: TInteger; var q, r: TInteger);
  var
    m, N, y1: integer;
  begin
    m:= y.GetLength;
    if m = 1 then begin
      y1:= y.fDigits[m - 1];
      if y1 > 0 then begin
        Quotient(q, x, y1);
        Remainder(r, x, y1);
      end
      else Showmessage('Division Overflow');
    end
    else begin
      N:= x.GetLength;
      if m > N then begin
        q.AssignZero;
        r:= x;
      end
      else { 2 <= m <= n <= w }
          LongDivide(x, y, q, r, N, m);
    end;
  end;

var
  signout: integer;
  signoutrem: integer; { GDD }
  idivd2, idivd3: TInteger;
begin
  // idivd2.assign(I2);
  idivd2:= GetNextScratchPad(I2);
  if Sign <> idivd2.Sign then signout:= -1
  else signout:= +1;
  signoutrem:= Sign; { Preserve dividend sign GDD }
  if not self.IsZero then Sign:= +1;
  if not idivd2.IsZero then idivd2.Sign:= +1;
  if idivd2.IsZero then begin
    remain.AssignZero;
    ReleaseScratchPad(idivd2);
    Exit;
  end;

  if AbsCompare(idivd2) >= 0 then { dividend>=divisor }
  begin
    // idivd3.Assign(self);
    idivd3:= GetNextScratchPad(self);
    Division(idivd3, idivd2, self, remain);
    remain.Sign:= signoutrem; { remainder sign:= Dividend sign GDD }
    Sign:= signout;
    remain.Trim;
    Trim;
    ReleaseScratchPad(idivd3);
  end
  else begin
    remain.Assign(self);
    AssignZero;
  end;
  ReleaseScratchPad(idivd2);
end;

{ **************** DivideRemFloor ************** }
Procedure TInteger.DivideRemFloor(const I2: TInteger; var remain: TInteger);
{ Floor definition of Divide with remainder }
begin
  DivideRem(I2, remain);
  if (not remain.IsZero) and (remain.Sign <> I2.Sign) then begin
    Subtract(1);
    remain.Add(I2);
  end;
end;

{ *************** DivideRemEuclidean *********** }
Procedure TInteger.DivideRemEuclidean(const I2: TInteger; var remain: TInteger);
{ Euclidean definition of divide with remainder }
begin
  DivideRem(I2, remain);
  if remain.Sign < 0 then begin
    if I2.Sign < 0 then { Changed by KRV }
    begin { ,, }
      Add(1); { ,, }
      remain.Subtract(I2); { ,, }
    end
    else { ,, }
    begin { ,, }
      Subtract(1); { ,, }
      remain.Add(I2); { ,, }
    end; { ,, }
  end;
end;

{ **************** Compare ************ }
function TInteger.Compare(I2: TInteger): integer;
{ Compare - to TInteger }
{ return +1 if self>i2, 0 if self=i2 and -1 if self<i2) }
begin
  if Sign < I2.Sign then Result:= -1
  else if Sign > I2.Sign then Result:= +1
  else if (self.Sign = 0) and (I2.Sign = 0) then Result:= 0
  else begin
    { same sign } Result:= AbsCompare(I2);
    if (Sign < 0) then Result:= -Result; { inputs were negative, largest abs value is smallest }
  end;
end;

{ ****************** Compare (Int64) ********* }
function TInteger.Compare(I2: int64): integer;
{ Compare - to int64 }
{ return +1 if self>i2, 0 if self=i2 and -1 if self<i2) }
var
  icomp3: TInteger;
begin
  // icomp3.Assign(i2);
  icomp3:= GetNextScratchPad(I2);
  if Sign < icomp3.Sign then Result:= -1
  else if Sign > icomp3.Sign then Result:= +1
  else if (self.Sign = 0) and (icomp3.Sign = 0) then Result:= 0
  else begin
    { same sign } Result:= AbsCompare(icomp3);
    if Sign < 0 then Result:= -Result;
  end;
  ReleaseScratchPad(icomp3);
end;

{ ************* IsZero ************* }
function TInteger.IsZero: boolean;
begin
  Result:= Sign = 0;
end;



{ ************* AbsCompare ************* }
function TInteger.AbsCompare(I2: TInteger): integer;
{ compare absolute values ingoring signs - to TInteger }
var
  i: integer;
begin

  Result:= 0;
  if (self.Sign = 0) and (I2.Sign = 0) then Result:= 0
  else if length(fdigits) > length(I2.fdigits) then Result:= +1
  else if Length(fdigits) < length(I2.fdigits) then Result:= -1
  else { equal length }
    for i:= high(fDigits) downto 0 do begin
      if fDigits[i] > I2.fDigits[i] then begin
        Result:= +1;
        break;
      end
      else if fDigits[i] < I2.fDigits[i] then begin
        Result:= -1;
        break;
      end;
    end;
end;

{ ************* AbsCompare ************* }
function TInteger.AbsCompare(I2: int64): integer;
{ compare absolute values ingoring signs - to TInteger }
var
  i3: TInteger;
begin
  // i3 := TInteger.Create;
  // i3.Assign(i2);
  i3:= GetNextScratchPad(I2);
  Result:= AbsCompare(i3);
  ReleaseScratchPad(i3);
  // i3.Free;
end;

{ *********** Factorial ******* }
procedure TInteger.Factorial;
{ Compute factorial - number must be less than max integer value }
var
  N: int64;
  i: integer;
begin
  N:= 0;
  if (Compare(high(integer)) >= 0) or (Sign < 0) then Exit;
  if IsZero then begin { 0! =1 by definition }
    AssignOne;
    Exit;
  end;
  for i:= high(fDigits) downto 0 do begin
    N:= N * Base + fDigits[i];
  end;
  Dec(N);
  while N > 1 do begin
    Mult(N);
    Dec(N);
    { provide a chance to cancel long running ops }
    if (N and $4F) = $4F then application.ProcessMessages;
  end;
end;

{ ************** ConvertToDecimalStirng ******** }
function TInteger.ConvertToDecimalString(commas: boolean): string;
var
  i, j, NumCommas, CurPos, StopPos, b, DigCount, NewPos, Top: integer;
  N, nn, last: int64;
  c: byte;

begin
  Trim;
  if length(fdigits) = 0 then AssignZero;
  if IsZero then begin
    Result:= '0';
    Exit;
  end;
  Result:= '';
  b:= GetBasePower;
  Top:= high(self.Digits);
  last:= fDigits[Top];
  DigCount:= Top * b + 1 + trunc(Math.Log10(last));
  Dec(Top);
  if Sign > 0 then begin
    CurPos:= DigCount;
    SetLength(Result, CurPos);
    StopPos:= 0;
  end
  else begin
    CurPos:= DigCount + 1;
    SetLength(Result, CurPos);
    Result[1]:= '-';
    StopPos:= 1;
  end;
  for i:= 0 to Top do begin
    N:= fDigits[i];
    for j:= 1 to b do begin
      nn:= N div 10;
      c:= N - nn * 10;
      N:= nn;
      Result[CurPos]:= char($30 + c);
      Dec(CurPos);
    end;
  end;
  repeat
    nn:= last div 10;
    c:= last - nn * 10;
    last:= nn;
    Result[CurPos]:= char($30 + c);
    Dec(CurPos);
  until CurPos <= StopPos;

  if commas = True then begin
    CurPos:= System.Length(Result);
    NumCommas:= (DigCount - 1) div 3;
    if NumCommas > 0 then begin
      NewPos:= CurPos + NumCommas;
      SetLength(Result, NewPos);
      for i:= 1 to NumCommas do begin
        Result[NewPos]:= Result[CurPos];
        Result[NewPos - 1]:= Result[CurPos - 1];
        Result[NewPos - 2]:= Result[CurPos - 2];
        {$IF compilerversion >21}
        Result[NewPos - 3]:= FormatSettings.ThousandSeparator;
        {$Else}
         Result[NewPos - 3]:= ThousandSeparator;
         {$IFEND}
        Dec(NewPos, 4);
        Dec(CurPos, 3);
      end;
    end;
  end;
end;

{ ********* ConvertToInt64 ********** }
function TInteger.ConvertToInt64(var N: int64): boolean;
var
  i: integer;
  savesign: integer;
begin
  Result:= false;
  savesign:= Sign;
  Sign:= +1;
  if (self.Compare(high(N) { 9223372036854775806 } ) < 1) then begin
    N:= 0;
    for i:= high(fDigits) downto 0 do N:= Base * N + fDigits[i];
    if savesign < 0 then N:= -N;
    Result:= True;
  end;
  Sign:= savesign;
end;

{ ********* Pow ************** }
procedure TInteger.Pow(const exponent: int64);
{ raise self to the "exponent" power }
var
  I2: TInteger;
  N: int64;
  s: integer;
begin
  N:= exponent;
  if (N <= 0) then begin
    if N = 0 then AssignOne
    else AssignZero;
    Exit;
  end;
  s:= Sign;
  if ((s < 0) and not(odd(N))) then s:= 1;
  Sign:= 1;

  // i2 := TInteger.Create;
  // i2.AssignOne;
  I2:= GetNextScratchPad(1);
  if (N >= 1) then
    if N = 1 then I2.Assign(self)
    else begin
      repeat
        if (N and $1) = 1 then I2.Mult(self);
        N:= N shr 1;
        application.ProcessMessages;
        Square;
      until (N = 1);
      I2.Mult(self);
    end;
  Assign(I2);
  Sign:= s;
  // i2.Free;
  ReleaseScratchPad(I2);
end;

// partially rewritten by hk Oct 2005
procedure TInteger.ModPow(const I2, m: TInteger);
{ self^I2 modulo m }
var
  ans, e, one: TInteger;
  hulp: integer;
begin
  { if (length(i2.fdigits) = 0) or (length(m.fdigits) = 0) then
    exit; }
  hulp:= I2.GetSign;
  if hulp <= 0 then
    if hulp = 0 then begin
      AssignOne;
      Exit;
    end
    else Exit;
  if m.IsZero then Exit;
  // one := TInteger.Create;
  // one.AssignOne;
  one:= GetNextScratchPad(1);
  // ans := TInteger.Create;
  // ans.AssignOne;
  ans:= GetNextScratchPad(1);
  // e   := TInteger.Create;
  // e.Assign(i2);
  e:= GetNextScratchPad(I2);
  hulp:= e.Compare(one);
  if hulp >= 0 then
    if hulp = 0 then begin
      Modulo(m);
      ans.Assign(self);
    end
    else begin
      repeat
        if e.IsOdd then begin
          ans.Mult(self);
          ans.Modulo(m);
        end;
        e.divide2;
        Square;
        Modulo(m);
      until (e.Compare(one) = 0);
      ans.Mult(self);
      ans.Modulo(m);
    end;
  Assign(ans);
  ReleaseScratchPad(e);
  ReleaseScratchPad(ans);
  ReleaseScratchPad(one);

  // ans.Free;
  // e.Free;
  // one.Free;
end;

{ square root }
procedure TInteger.Sqroot;
begin
  NRoot(2);
end;

{ ****************** GCD *************** }
procedure TInteger.Gcd(const I2: TInteger);
{ greatest common divisor }
{ revised by Hans Aug 2005 to handle 0 "I2" value }
{ revised by hk Oct 2005: swapping by hashing }
var
  gcdarr: array [0 .. 1] of TInteger;
  a, b, h: integer;
begin
  gcdarr[0]:= GetNextScratchPad(self); // TInteger.Create;
  gcdarr[1]:= GetNextScratchPad(I2); // TInteger.Create;
  if AbsCompare(I2) = 1 then begin
    // gcdarr[0].Assign(self);  {already assigned above}
    // gcdarr[1].Assign(i2);
  end
  else begin
    gcdarr[1].Assign(self);
    gcdarr[0].Assign(I2);
  end;
  if gcdarr[1].IsZero then begin
    AssignZero;
    // gcdarr[0].Free;
    // gcdarr[1].Free;
    ReleaseScratchPad(gcdarr[1]);
    ReleaseScratchPad(gcdarr[0]);
    Exit;
  end;
  a:= 0;
  b:= 1;
  repeat
    gcdarr[a].Modulo(gcdarr[b]);
    if not gcdarr[a].IsZero then begin
      h:= a;
      a:= b;
      b:= h;
    end;
  until gcdarr[a].IsZero;
  Assign(gcdarr[b]);
  self.AbsoluteValue;
  // gcdarr[a].Free;
  // gcdarr[b].Free;
  ReleaseScratchPad(gcdarr[1]);
  ReleaseScratchPad(gcdarr[0]);
end;

{ *************** GCD (Int64) *********** }
procedure TInteger.Gcd(const I2: int64);
var
  h: TInteger;
begin
  // h := TInteger.Create;
  // h.Assign(i2);
  h:= GetNextScratchPad(I2);
  Gcd(h);
  // h.Free;
  ReleaseScratchPad(h);
end;

{ *********** IsOdd ********* }
function TInteger.IsOdd: boolean;
{ Return true if self is an odd integer }
begin
  Result:= (fDigits[0] and $1) = 1;
end;

(* rewritten by hk Oct 2005 *)
{ ************** IsProbablyPrime *********** }
function TInteger.IsProbablyPrime: boolean;
// miller rabin probabilistic primetest with 10 random bases;
var
  n_1, one, i3, worki2: TInteger;
  Base, lastdigit, j, t, under10: integer;
  probableprime: boolean;
  p, work, s, diff, factorlimit: int64;

  function witness(Base: integer; e, N: TInteger): boolean;
  var
    it, h: TInteger;
    i: integer;
  begin
    it:= GetNextScratchPad(Base); // TInteger.Create;
    h:= GetNextScratchPad; // TInteger.Create;

    it.Assign(Base);
    it.ModPow(e, N);
    Result:= True;
    for i:= 1 to t do begin
      h.Assign(it);
      h.Square;
      h.Modulo(N);
      if h.Compare(one) = 0 then
        if it.Compare(one) <> 0 then
          if it.Compare(n_1) <> 0 then Result:= false;
      it.Assign(h);
    end;
    if it.Compare(one) <> 0 then Result:= false;
    // it.Free;
    // h.Free;
    ReleaseScratchPad(h);
    ReleaseScratchPad(it);
  end;

  function is_smallprime: boolean;
  var
    j, w, diff: integer;
    prime: boolean;
    i: int64;
  begin
    prime:= True;
    ConvertToInt64(i);
    w:= trunc(sqrt(0.0 + i));
    j:= 11;
    diff:= 2;
    while prime and (j <= w) do begin
      if (i mod j) = 0 then prime:= false;
      Inc(j, diff);
      if diff = 2 then diff:= 4
      else diff:= 2;
    end;
    Result:= prime;
  end;

begin
  one:= GetNextScratchPad(1);
  n_1:= GetNextScratchPad;
  i3:= GetNextScratchPad;
  worki2:= GetNextScratchPad;

  probableprime:= True;
  factorlimit:= self.Base;
  if factorlimit > 200 then factorlimit:= 200;
  if factorlimit = 10 then factorlimit:= 32;
  { lastdigit := worki2.shiftright mod 10; }
  lastdigit:= fDigits[0] mod 10;
  under10:= Compare(10);
  if under10 = -1 then
    if (lastdigit <> 2) and (lastdigit <> 3) and (lastdigit <> 5) and (lastdigit <> 7) then begin
      probableprime:= false;
    end;
  if under10 >= 0 then begin
    if (lastdigit <> 1) and (lastdigit <> 3) and (lastdigit <> 7) and (lastdigit <> 9) then probableprime:= false
    else begin
      p:= 3;

      while probableprime and (p < 8) do begin
        worki2.Assign(self);
        worki2.divmodsmall(p, work);
        if work = 0 then probableprime:= false;
        p:= p + 4;
      end;
    end;
  end;
  if probableprime and (under10 > 0) and (Compare(120) = 1) then
    if Compare(1000000) = -1 then probableprime:= is_smallprime
    else begin
      p:= 11;
      diff:= 2;
      while probableprime and (p < factorlimit) do begin
        worki2.Assign(self);
        worki2.divmodsmall(p, work);
        if work = 0 then probableprime:= false;
        p:= p + diff;
        if diff = 2 then diff:= 4
        else diff:= 2;
      end;
      if probableprime then begin
        one.AssignOne;
        n_1.Assign(self);
        n_1.Subtract(1);
        t:= 0;
        i3.Assign(n_1);
        repeat
          if not(i3.IsOdd) then begin
            Inc(t);
            i3.divide2;
          end;
        until i3.IsOdd;
        worki2.Assign(self);
        j:= 10;
        if Compare(1000000) > 0 then s:= 1000000
        else worki2.ConvertToInt64(s);
        s:= s - 1;
        while (j > 0) and probableprime do begin
          repeat Base:= system.Random(s);
          until Base > 1;
          probableprime:= witness(Base, i3, worki2);
          Dec(j);
        end;
      end;
    end;
  ReleaseScratchPad(worki2);
  ReleaseScratchPad(i3);
  ReleaseScratchPad(n_1);
  ReleaseScratchPad(one);
  Result:= probableprime;
end;

{ ************ InvMod ********** }



procedure TInteger.InvMod(I2: TInteger);
{ calculates the number n such that n*self=1 mod I2, result in self }
var
  r, q, fn, fv, h, N, m: TInteger;
  s1, s2, s3: integer;
begin
  // Extended Euclidean Algoritm.
  (* (it's not necessary to calculate the gcd beforehand,
    the extended euclidean algoritm does that itself.)
    r.Assign(self);
    r.Gcd(I2);
    {  1st operand must be non-zero and operands must be relatively prime}
    //  if (compare(0) = 0) or (r.compare(1) <> 0) then
    if (CompareZero = 0) or (r.Compare(1) <> 0) then

    begin
    AssignZero;
    // start add by Charles Doumar
    r.Free;
    // end
    exit;
    end;

  *)
  { both operands must be non-zero }
  if (IsZero) or (I2.IsZero) then begin
    AssignZero;
    Exit
  end;
  r:= GetNextScratchPad(1); // TInteger.Create;
  q:= GetNextScratchPad(0); // TInteger.Create;
  fn:= GetNextScratchPad(1); // TInteger.Create;
  fv:= GetNextScratchPad(0); // TInteger.Create;
  h:= GetNextScratchPad(0); // TInteger.Create;
  N:= GetNextScratchPad(self); // TInteger.Create;
  m:= GetNextScratchPad(I2); // TInteger.Create;
  // n.Assign(self);
  // m.Assign(I2);
  m.Sign:= 1;
  s1:= self.Sign;
  // first make all operands positive;
  if s1 < 0 then { change restclass }
  begin
    N.ChangeSign;
    N.Add(m);
  end;
  N.Modulo(m);
  // start euclidean algorithm
  repeat
    q.Assign(m);
    q.DivideRem(N, r);
    if not r.IsZero then begin
      m.Assign(N);
      N.Assign(r);
    end;
    h.Assign(fn);
    fn.Mult(q);
    fv.Subtract(fn);
    fn.Assign(fv);
    fv.Assign(h);
  until r.IsZero;
  { n contains the gcd, gcd must be 1; h contains invmod }
  if N.Compare(1) <> 0 then Assign(0)
  else begin
    if s1 < 0 then h.ChangeSign; { change restclass again if we did before }
    { Now assure that invmod has the same sign as self so
      that invmod*self will be positive }
    s3:= h.Sign;
    s2:= I2.Sign;
    I2.Sign:= 1;
    if (s3 < 0) and (s1 > 0) then h.Add(I2);
    if (s3 > 0) and (s1 < 0) then h.Subtract(I2);
    Assign(h);
    I2.Sign:= s2;
  end;
  ReleaseScratchPad(m);
  ReleaseScratchPad(N);
  ReleaseScratchPad(h);
  ReleaseScratchPad(fv);
  ReleaseScratchPad(fn);
  ReleaseScratchPad(q);
  ReleaseScratchPad(r);

end;



procedure TInteger.NRoot(const root: int64);
var
  Parta, Partb, Partc, Guess: TInteger;
  Limit, Counter, nthroot, a: integer;
  num1, num2: int64;
  str1: string;
begin
  if (root < 2) or (self.Sign <> 1) then
  begin
    AssignZero;
    Exit;
  end;
  // if number within range of int64 then compute there
  if self.ConvertToInt64(num1) = True then
  begin
    num2:= trunc(power(num1, 1 / root));
    if power(num2, root) > num1 then num2:= num2 - 1;
    if power(num2 + 1, root) <= num1 then self.Assign(num2 + 1)
    else self.Assign(num2);
    Exit;
  end;

  Limit:= Length(fdigits) * GetBasePower * 3 + 700;
  Counter:= 0;
  nthroot:= root - 1;
  // PartA   := TInteger.Create;
  // parta.Assign(2);
  Parta:= GetNextScratchPad(2);
  Parta.Pow(root);
  if Compare(Parta) < 0 then
  begin
    AssignOne;
    // parta.Free;
    ReleaseScratchPad(Parta);
    Exit;
  end;
  Partb:= GetNextScratchPad(0); // TInteger.Create;
  Partc:= GetNextScratchPad(0); // TInteger.Create;
  Guess:= GetNextScratchPad(0); // TInteger.Create;

  // initial guess
  a:= high(self.fDigits) * GetBasePower div root - 1;
  if a = 0 then str1:= '2'
  else str1:= '1';
  str1:= str1 + stringofchar('0', a);
  Guess.Assign(str1);
  Parta.Assign(Guess);
  Parta.Pow(root);
  while self.Compare(Parta) > 0 do
  begin
    Guess.Mult(10);
    Parta.Assign(Guess);
    Parta.Pow(root);
  end;
  Parta.Assign(Guess);
  Parta.Divide(10);
  Parta.Pow(root);
  while self.Compare(Parta) <= 0 do
  begin
    Guess.Divide(10);
    Parta.Assign(Guess);
    Parta.Divide(10);
    Parta.Pow(root);
  end;
  // start of newton
  repeat
    Inc(Counter);
    Parta.Assign(Guess);
    Parta.Mult(nthroot);
    Partb.Assign(self);
    Partc.Assign(Guess);
    Partc.Pow(nthroot);
    Partb.Divide(Partc);
    Parta.Add(Partb);
    Parta.Divide(root);
    Partc.Assign(Guess); // old guess
    Partb.Assign(Guess);
    Partb.Subtract(1);
    Guess.Assign(Parta); // new guess
  until (Counter > 4) and ((Counter > Limit) or (Partc.Compare(Guess) = 0) or (Partb.Compare(Guess) = 0));
  if Counter > Limit then self.AssignZero
  else begin
    if Partc.Compare(Guess) = 0 then self.Assign(Guess)
    else
    begin
      // assign smallest value to part c;
      if Partc.Compare(Guess) > 0 then Partb.Assign(Guess)
      else Partb.Assign(Partc);
      // ensure not too big
      Partc.Assign(Partb);
      Partc.Pow(root);
      while (self.Compare(Partc) < 0) and (Counter < (Limit + 50)) do
      begin
        Partb.Subtract(1);
        Partc.Assign(Partb);
        Partc.Pow(root);
        Inc(Counter);
      end;
      // ensure not too small
      Partc.Assign(Partb);
      Partc.Add(1);
      Partc.Pow(root);
      while (self.Compare(Partc) >= 0) and (Counter < (Limit + 50)) do
      begin
        Partb.Add(1);
        Partc.Assign(Partb);
        Partc.Add(1);
        Partc.Pow(root);
        Inc(Counter);
      end;
      if Counter < (Limit + 50) then self.Assign(Partb)
      else self.AssignZero;
    end;
  end;
  // PartA.Free;
  // PartB.Free;
  // PartC.Free;
  // Guess.Free;
  ReleaseScratchPad(Guess);
  ReleaseScratchPad(Partc);
  ReleaseScratchPad(Partb);
  ReleaseScratchPad(Parta);
end;

function TInteger.GetBase: integer;
begin
  Result:= Base;
end;

(*
  function TInteger.IsZero: boolean;
  begin
  Result := self.Digits[high(self.Digits)] = 0;
  end;
*)

procedure TInteger.AssignOne;
begin
  SetLength(fDigits, 1);
  self.Sign:= 1;
  self.fDigits[0]:= 1;
end;

procedure TInteger.AssignZero;
begin
  SetLength(fDigits, 1);
  self.Sign:= 0;
  self.fDigits[0]:= 0;
end;

(* *** additions by hk Oct 2005** *)
procedure TInteger.assignsmall(I2: int64);
begin
  if system.abs(I2) >= Base then Assign(I2)
  else if I2 = 0 then AssignZero
  else begin
    if I2 < 0 then begin
      self.Sign:= -1;
      I2:= -I2;
    end
    else self.Sign:= +1;
    SetLength(self.fDigits, 1);
    self.fDigits[0]:= I2;
  end;
end;

{ ************** Divide2 ************* }
procedure TInteger.divide2;
{ Fast divide by 2 }
var
  i: integer;
begin
  for i:= high(fDigits) downto 1 do begin
    if (fDigits[i] and 1) = 1 then Inc(fDigits[i - 1], Base);
    fDigits[i]:= fDigits[i] shr 1;
  end;
  fDigits[0]:= fDigits[0] shr 1;
  Trim;
end;

{ *********** DivModSmall ************** }
procedure TInteger.divmodsmall(d: int64; var rem: int64);
{ DivMod for d < base }
var
  i, dsign: integer;
  k, N, nn: int64;
  dh, remh: TInteger;
begin
  if (d = 0) or (d = 1) then begin
    rem:= 0;
    Exit;
  end;
  if d = 2 then begin
    rem:= (fDigits[0] and 1);
    divide2;
    Exit;
  end;
  if system.abs(d) >= self.Base then begin
    // dh   := TInteger.Create;
    // remh := TInteger.Create;
    dh:= GetNextScratchPad(d);
    remh:= GetNextScratchPad(rem);
    // dh.Assign(d);
    // remh.Assign(rem);
    DivideRem(dh, remh);
    remh.ConvertToInt64(rem);
    // dh.Free;
    // remh.Free;
    ReleaseScratchPad(remh);
    ReleaseScratchPad(dh);
  end
  else begin
    if d < 0 then begin
      dsign:= -1;
      d:= -d;
    end
    else dsign:= 1;
    for i:= high(fDigits) downto 1 do begin
      N:= fDigits[i];
      nn:= N div d;
      k:= N - nn * d;
      fDigits[i]:= nn;
      if k > 0 then fDigits[i - 1]:= fDigits[i - 1] + k * Base;
    end;
    N:= fDigits[0];
    nn:= N div d;
    rem:= N - nn * d;
    fDigits[0]:= nn;
    if self.Sign < 0 then rem:= -rem; { Set remainder sign to dividend sign GDD }
    self.Sign:= self.Sign * dsign;
    // if self.Sign < 0 then
    // rem := -rem;
    Trim;
  end;
end;





procedure TInteger.AbsoluteValue;
begin
  if self.Sign < 0 then self.Sign:= 1;
end;



{ ***************** FastMult *************** } procedure TInteger.FastMult(const I2: TInteger);
(*
   This version is based on "fast Karatsuba multiplication", 21 Jan 1999, Carl Burch, cburch@cmu.edu
   Converted to Delphi by Charles Doumar
*)

const
   MaxArraySize = $FFFF;
   MaxInt64ArrayElements = MaxArraySize div sizeof(int64); type
   TStaticInt64Array = array [0 .. MaxInt64ArrayElements - 1] of int64;
   PInt64Array = ^TStaticInt64Array;
   Int64Array = array of int64;
var
   PA, PB, PR: PInt64Array;
   Alen, Blen, imin, imax, d: integer;

   procedure DoCarry(PR: PInt64Array; const Base, d: integer);
   var
     i: integer;
     Carry: int64;
   begin
     Carry:= 0;
     for i:= 0 to d - 1 do begin
       PR^[i]:= PR^[i] + Carry;
       if PR^[i] < 0 then Carry:= (PR^[i] + 1) div Base - 1
       else Carry:= PR^[i] div Base;
       PR^[i]:= PR^[i] - Carry * Base;
     end;
     if Carry <> 0 then begin
       PR^[d - 1]:= PR^[d - 1] + Carry * Base;
       Showmessage('Error in FastMath DoCarry');
     end;
   end;

   procedure GradeSchoolMult(PA, PB, PR: PInt64Array; d: integer);
   const
     ConstShift = 48;
   var
     i, j, k, ALow, BLow: integer;
     product, Carry: int64;
   begin
     fillchar(PR[0], sizeof(int64) * 2 * d, 0);
     ALow:= d - 1;
     BLow:= ALow;
     while (ALow > 0) and (PA^[ALow] = 0) do Dec(ALow);
     while (BLow > 0) and (PB^[BLow] = 0) do Dec(BLow);
     k:= 0;
     for i:= 0 to ALow do begin
       Carry:= 0;
       for j:= 0 to BLow do begin
         k:= i + j;
         product:= PR^[k] + PA^[i] * PB^[j] + Carry;
         Carry:= product shr ConstShift;
         if Carry = 0 then PR^[k]:= product
         else begin
           Carry:= product div Base;
           PR^[k]:= product - Carry * Base;
         end;
       end;
       PR^[k + 1]:= PR^[k + 1] + Carry;
     end;
   end;

   procedure Karatsuba(PA, PB, PR: PInt64Array; d: integer);
   var
     AL, AR, BL, BR, ASum, BSum, X1, X2, X3: PInt64Array;
     i, halfd: integer;
   begin
     if d <= 100 then begin
       GradeSchoolMult(PA, PB, PR, d);
       Exit;
     end;
     halfd:= d shr 1;
     AR:= @PA^[0];
     AL:= @PA^[halfd];
     BR:= @PB^[0];
     BL:= @PB^[halfd];
     ASum:= @PR^[d * 5];
     BSum:= @PR^[d * 5 + halfd];
     X1:= @PR^[0];
     X2:= @PR^[d];
     X3:= @PR^[d * 2];
     for i:= 0 to halfd - 1 do begin
       ASum^[i]:= AL^[i] + AR^[i];
       BSum^ [i]:= BL^[i] + BR^[i];
     end;
     Karatsuba(AR, BR, X1, halfd);
     Karatsuba(AL, BL, X2, halfd);
     Karatsuba(ASum, BSum, X3, halfd);
     for i:= 0 to d - 1 do X3^[i]:= X3^[i] - X1^[i] - X2^[i];
     for i:= 0 to d - 1 do PR^[i + halfd]:= PR^[i + halfd] + X3^[i];
   end;

begin
   Alen:= length(fdigits);
   Blen:= length(I2.fdigits);
   imin:= Alen;
   imax:= Blen;
   if Alen > Blen then begin
     imin:= Blen;
     imax:= Alen;
   end;
   if (imin < 300) or (imin < imax shr 4) then begin
     self.Mult(I2);
     Exit;
   end;
   d:= 1;
   while d < imax do d:= d * 2;
   SetdigitLength(d);
   i2.setdigitlength(d);
   PA:= @self.fDigits[0];
   PB:= @I2.fDigits[0];
   //HR:= GlobalAlloc(GMEM_FIXED, d * 6 * sizeof(int64));
   //PR:= GlobalLock(HR);
   getmem(PR,d*6*sizeof(int64));
   fillchar(PR[0], sizeof(int64) * 6 * d, 0);
   Karatsuba(PA, PB, PR, d);
   application.ProcessMessages;
   DoCarry(PR, self.Base, d * 2);
   d:= 2 * d;
   while (d > 0) and (PR^[d - 1] = 0) do Dec(d);
   Setdigitlength(d);
   I2.SetdigitLength(Blen); // Restore I2 length
   move(PR^[0], self.fDigits[0], d * sizeof(int64));
   self.Trim;
   self.Sign:= self.Sign * I2.Sign;
   freemem(PR);
   //GlobalUnlock(HR);
   //GlobalFree(HR);
end;



(*

{ ***************** FastMult *************** }
procedure TInteger.FastMult(const I2: TInteger);
{
  This version is based on "fast Karatsuba multiplication", 21 Jan 1999, Carl Burch, cburch@cmu.edu
  Converted to Delphi by Charles Doumar
}

const
  MaxArraySize = $7FFFFFFF;
  MaxInt64ArrayElements = MaxArraySize div sizeof(int64);
type
  TStaticInt64Array = array [0 .. MaxInt64ArrayElements - 1] of int64;
  PInt64Array = ^TStaticInt64Array;
  Int64Array = array of int64;
var
  HR: THandle;
  PA, PB, PR: PInt64Array;
  Alen, Blen, imin, imax, d: integer;

  procedure DoCarry(PR: PInt64Array; const Base, d: integer);
  var
    i: integer;
    Carry: int64;
  begin
    Carry:= 0;
    for i:= 0 to d - 1 do begin
      PR[i]:= PR[i] + Carry;
      if PR[i] < 0 then Carry:= (PR[i] + 1) div Base - 1
      else Carry:= PR[i] div Base;
      PR[i]:= PR[i] - Carry * Base;
    end;
    if Carry <> 0 then begin
      PR[d - 1]:= PR[d - 1] + Carry * Base;
      Showmessage('Error in FastMath DoCarry');
    end;
  end;

  procedure GradeSchoolMult(PA, PB, PR: PInt64Array; d: integer);
  const
    ConstShift = 48;
  var
    i, j, k, ALow, BLow: integer;
    product, Carry: int64;
  begin
    fillchar(PR[0], sizeof(int64) * 2 * d, 0);
    ALow:= d - 1;
    BLow:= ALow;
    while (ALow > 0) and (PA[ALow] = 0) do Dec(ALow);
    while (BLow > 0) and (PB[BLow] = 0) do Dec(BLow);
    k:= 0;
    for i:= 0 to ALow do begin
      Carry:= 0;
      for j:= 0 to BLow do begin
        k:= i + j;
        product:= PR[k] + PA[i] * PB[j] + Carry;
        Carry:= product shr ConstShift;
        if Carry = 0 then PR[k]:= product
        else begin
          Carry:= product div Base;
          PR[k]:= product - Carry * Base;
        end;
      end;
      PR[k + 1]:= PR[k + 1] + Carry;
    end;
  end;

  procedure Karatsuba(PA, PB, PR: PInt64Array; d: integer);
  var
    AL, AR, BL, BR, ASum, BSum, X1, X2, X3: PInt64Array;
    i, halfd: integer;
  begin
    if d <= 100 then begin
      GradeSchoolMult(PA, PB, PR, d);
      Exit;
    end;
    halfd:= d shr 1;
    AR:= @PA[0];
    AL:= @PA[halfd];
    BR:= @PB[0];
    BL:= @PB[halfd];
    ASum:= @PR[d * 5];
    BSum:= @PR[d * 5 + halfd];
    X1:= @PR[0];
    X2:= @PR[d];
    X3:= @PR[d * 2];
    for i:= 0 to halfd - 1 do begin
      ASum[i]:= AL[i] + AR[i];
      BSum[i]:= BL[i] + BR[i];
    end;
    Karatsuba(AR, BR, X1, halfd);
    Karatsuba(AL, BL, X2, halfd);
    Karatsuba(ASum, BSum, X3, halfd);
    for i:= 0 to d - 1 do X3[i]:= X3[i] - X1[i] - X2[i];
    for i:= 0 to d - 1 do PR[i + halfd]:= PR[i + halfd] + X3[i];
  end;

begin
  Alen:= Length(fdigits);
  Blen:= length(I2.fdigits);
  imin:= Alen;
  imax:= Blen;
  if Alen > Blen then begin
    imin:= Blen;
    imax:= Alen;
  end;
  if (imin < 80) or (imin < imax shr 4) then begin
    self.Mult(I2);
    Exit;
  end;
  d:= 1;
  while d < imax do d:= d * 2;
  SetdigitLength(d);
  setdigitlength(d);
  PA:= @self.fDigits[0];
  PB:= @I2.fDigits[0];
  HR:= GlobalAlloc(GMEM_FIXED, d * 6 * sizeof(int64));
  PR:= GlobalLock(HR);
  fillchar(PR[0], sizeof(int64) * 6 * d, 0);
  Karatsuba(PA, PB, PR, d);
  DoCarry(PR, self.Base, d * 2);
  d:= 2 * d;
  while (d > 0) and (PR[d - 1] = 0) do Dec(d);
  Setdigitlength(d);
  I2.SetdigitLength(Blen); { Changes input variable ?????????? GDD }
  move(PR[0], self.fDigits[0], d * sizeof(int64));
  self.Trim;
  self.Sign:= self.Sign * I2.Sign;
  GlobalUnlock(HR);
  GlobalFree(HR);
end;

*)



{ *************** FastSquare ************** }
procedure TInteger.FastSquare;
(*
  This version is based on "fast Karatsuba multiplication", 21 Jan 1999, Carl Burch, cburch@cmu.edu
  Converted to Delphi by Charles Doumar
*)

const
  MaxArraySize = $7FFFFFFF;
  MaxInt64ArrayElements = MaxArraySize div sizeof(int64);
type
  TStaticInt64Array = array [0 .. MaxInt64ArrayElements - 1] of int64;
  PInt64Array = ^TStaticInt64Array;
  Int64Array = array of int64;
var
  HR: THandle;
  PA, PR: PInt64Array;
  Alen, i, d, dmemory: integer;

  procedure DoCarry(PR: PInt64Array; const Base, d: integer);
  var
    i: integer;
    c: int64;
  begin
    c:= 0;
    for i:= 0 to d - 1 do begin
      PR[i]:= PR[i] + c;
      if PR[i] < 0 then c:= (PR[i] + 1) div Base - 1
      else c:= PR[i] div Base;
      PR[i]:= PR[i] - c * Base;
    end;
    if c <> 0 then begin
      PR[d - 1]:= PR[d - 1] + c * Base;
      Showmessage('Error in FastSquare DoCarry');
    end;
  end;

  procedure HighSchoolSquare(PA, PR: PInt64Array; d: integer);
  const
    ConstShift = 48;
  var
    i, j, k, ALow: integer;
    product, Carry: int64;
  begin
    fillchar(PR[0], sizeof(int64) * 2 * d, 0);
    ALow:= d - 1;
    while (ALow > 0) and (PA[ALow] = 0) do Dec(ALow);
    // Step 1. Calculate diagonal
    for i:= 0 to ALow do begin
      k:= i * 2;
      product:= PA[i] * PA[i];
      Carry:= product shr ConstShift;
      if Carry = 0 then PR[k]:= product
      else begin
        Carry:= product div Base;
        PR[k]:= product - Carry * Base;
        PR[k + 1]:= Carry;
      end;
    end;
    // Step 2. Calculate repeating part
    k:= 0;
    For i:= 0 to ALow do begin
      Carry:= 0;
      for j:= i + 1 to ALow do begin
        k:= i + j;
        product:= PR[k] + PA[i] * PA[j] * 2 + Carry;
        Carry:= product shr ConstShift;
        if Carry = 0 then PR[k]:= product
        else begin
          Carry:= product div Base;
          PR[k]:= product - Carry * Base;
        end;
      end;
      PR[k + 1]:= PR[k + 1] + Carry;
    end;
  end;

  procedure KaratsubaSquare(PA, PR: PInt64Array; d: integer);
  var
    AL, AR, ASum, X1, X2, X3: PInt64Array;
    i, halfd: integer;
  begin
    if d <= 100 then begin
      HighSchoolSquare(PA, PR, d);
      Exit;
    end;
    halfd:= d shr 1;
    AR:= @PA[0];
    AL:= @PA[halfd];
    ASum:= @PR[d * 5];
    X1:= @PR[0];
    X2:= @PR[d];
    X3:= @PR[d * 2];
    for i:= 0 to halfd - 1 do ASum[i]:= AL[i] + AR[i];
    KaratsubaSquare(AR, X1, halfd);
    KaratsubaSquare(AL, X2, halfd);
    KaratsubaSquare(ASum, X3, halfd);
    for i:= 0 to d - 1 do X3[i]:= X3[i] - X1[i] - X2[i];
    for i:= 0 to d - 1 do PR[i + halfd]:= PR[i + halfd] + X3[i];
  end;

begin
  Alen:= Length(fdigits);
  i:= Alen;
  d:= 1;
  while d < i do d:= d * 2;
  SetLength(self.fDigits, d);
  PA:= @self.fDigits[0];
  dmemory:= (d shr 1) * 11 * sizeof(int64);
  HR:= GlobalAlloc(GMEM_FIXED, dmemory);
  PR:= GlobalLock(HR);
  fillchar(PR[0], dmemory, 0);
  KaratsubaSquare(PA, PR, d);
  DoCarry(PR, self.Base, d * 2);
  d:= 2 * d;
  while (d > 0) and (PR[d - 1] = 0) do Dec(d);
  SetLength(self.fDigits, d);
  move(PR[0], self.fDigits[0], d * sizeof(int64));
  self.Trim;
  self.Sign:= self.Sign * self.Sign;
  GlobalUnlock(HR);
  GlobalFree(HR);
end;

/// /////additions by morf//////////////////////////

{ *************** AssignHex **************** }
function TInteger.AssignHex(HexStr: String): boolean;
var
  s: string;
  i, N: integer;
begin
  Result:= True;
  self.AssignZero;
  s:= uppercase(HexStr);
  n:=0;
  for i:= 1 to system.Length(s) do
  begin
    Mult(16);
    if s[i] in ['0' .. '9'] then N:= Ord(s[i]) - Ord('0')
    else if s[i] in ['A' .. 'F'] then N:= 10 + Ord(s[i]) - Ord('A')
    else
    begin
      Result:= false;
      break;
    end;
    Add(N);
  end;

  (*
    if (Length(HexStr) > 0) then
    begin
    for TempInt2 :=  Length(HexStr) downto 1 do
    begin
    TempInt3 := StrToIntDef('$'+HexStr[TempInt2],-1);
    //convert each element to 4 bits    //b8 b4 b2 b1
    if ((TempInt3 and 1) > 0) then
    begin
    TempExp.Assign(2);
    TempExp.Pow(Exp);
    Self.Add(TempExp);
    end;
    Inc(Exp);
    if ((TempInt3 and 2) > 0) then
    begin
    TempExp.Assign(2);
    TempExp.Pow(Exp);
    Self.Add(TempExp);
    end;
    Inc(Exp);
    if ((TempInt3 and 4) > 0) then
    begin
    TempExp.Assign(2);
    TempExp.Pow(Exp);
    Self.Add(TempExp);
    end;
    Inc(Exp);
    if ((TempInt3 and 8) > 0) then
    begin
    TempExp.Assign(2);
    TempExp.Pow(Exp);
    Self.Add(TempExp);
    end;
    Inc(Exp);
    end;
    Result := True;
    end;
    releasescratchpad(TempExp);
  *)
end;

var
  hexdigits: array [0 .. 15] of char = (
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F'
  );

function TInteger.ConvertToHexString: String;
Var
  temp, rem, sixteen: TInteger;
  N: int64;
begin
  Result:= '';
  temp:= GetNextScratchPad(self);
  sixteen:= GetNextScratchPad(16);
  rem:= GetNextScratchPad(0);
  repeat
    temp.DivideRem(sixteen, rem);
    rem.ConvertToInt64(N);
    Result:= hexdigits[N] + Result;
  until temp.IsZero;
  ReleaseScratchPad(rem);
  ReleaseScratchPad(sixteen);
  ReleaseScratchPad(temp);
end;

(*

  Var
  TempInt1, Tempint2, TempInt4 : TInteger;
  TempInt3 : Integer;
  TempStr1  : String;
  begin
  TempInt1 := getnextscratchpad(self);  //TInteger.Create;
  TempInt2 := getnextscratchpad(0); //TInteger.Create;
  Tempint4 := getnextscratchpad(0); //TInteger.Create;
  //Tempint1.Assign(Self.ConvertToDecimalString(False));
  TempStr1 := '';
  Result := '';
  While TempInt1.IsPositive do
  begin
  TempInt2.Assign(TempInt1);
  TempInt2.Divide(16);
  TempInt4.Assign(TempInt2);
  TempInt4.Mult(16);
  TempInt1.Subtract(TempInt4);
  TempStr1 := TempStr1 +  IntToHex(StrToIntDef(TempInt1.ConvertToDecimalString(False),0),1);
  TempInt1.Assign(TempInt2);
  end;
  for TempInt3 := Length(TempStr1) downto 1 do
  Result := Result + TempStr1[TempInt3];
  if odd(Length(Result)) then Result := '0'+Result;
  if IncludeHeader then
  Result := '0x'+Result;
  releasescratchpad(TempInt4); //TempInt1.Free;
  releasescratchpad(TempInt2); //TempInt4.Free;
  releasescratchpad(TempInt1); //TempInt2.Free;
  end;
*)

function TInteger.BitCount: integer;
var
  TempInt1, TempInt2, TempInt5: TInteger;
begin
  Result:= 0;
  TempInt1:= GetNextScratchPad(self); // TempInt1 := TInteger.Create;
  TempInt2:= GetNextScratchPad(0); // TInteger.Create;
  TempInt5:= GetNextScratchPad(0); // TempInt5 := TInteger.Create;
  // TempInt1.Assign(Self.ConvertToDecimalString(False));
  while TempInt1.IsPositive do begin
    TempInt2.Assign(TempInt1);
    TempInt2.Divide(2);
    TempInt5.Assign(TempInt2);
    TempInt5.Mult(2);
    TempInt1.Assign(TempInt2);
    Inc(Result);
  end;
  ReleaseScratchPad(TempInt1); // TempInt1.Free;
  ReleaseScratchPad(TempInt2);
  ReleaseScratchPad(TempInt5);
end;

// add sanity check for seed str
function TInteger.AssignRandomPrime(BitLength: integer; seed: String; mustMatchBitLength: boolean): boolean;
var
  rp, rq, rz: TInteger;
  Attempts, TempInt1, Offset: integer;
  TempStr1: String;
begin
  Result:= false;
  rp:= GetNextScratchPad(0); { TInteger.Create; }
  rq:= GetNextScratchPad(0); { TInteger.Create; }
  rz:= GetNextScratchPad(0); { TInteger.Create; }
  self.AssignZero;
  Attempts:= 20000;
  Randomize;
  TempStr1:= '9';
  if system.Length(seed) > 7 then SetLength(seed, 7);
  for TempInt1:= 0 to (BitLength div 8) do TempStr1:= TempStr1 + inttostr(system.Random(9));
  rq.Assign(TempStr1);
  Offset:= 0;
  while Attempts > 0 do begin
    // Randomize;
    TempStr1:= '9';
    for TempInt1:= 0 to (BitLength div 4) + Offset do TempStr1:= TempStr1 + inttostr(system.Random(9));
    rz.Assign(TempStr1);
    rp.Assign(system.Random(strToIntDef(seed, 7777777)));
    rp.ModPow(rq, rz);
    if rp.IsOdd = false then rp.Subtract(1);
    if rp.IsProbablyPrime then begin
      TempStr1:= rp.ConvertToDecimalString(false);
      if mustMatchBitLength = false then TempInt1:= BitLength
      else TempInt1:= rp.BitCount;
      if BitLength > TempInt1 then Offset:= ((BitLength - TempInt1) div 3);
      if TempInt1 = BitLength then begin
        self.Assign(TempStr1);
        Result:= True;
        break;
      end;
    end;
    Dec(Attempts);
  end;
  ReleaseScratchPad(rp); // rp.Free;
  ReleaseScratchPad(rq); // rq.Free;
  ReleaseScratchPad(rz); // rz.Free;
end;

{ GDD additions March, 2009 }

procedure TInteger.RandomOfSize(size: integer);
var
  i: integer;
  s: string;
begin
  repeat { make sure the the leading digit is not 0 }
      i:= system.Random(10);
  until i <> 0;
  s:= inttostr(i);
  for i:= 2 to size do s:= s + inttostr(system.Random(10));
  Assign(s);
end;

{ ************** Random ************* }
procedure TInteger.Random(maxint: TInteger);
{ get a random number between 0 and maxint }
var
  i, d: integer;
begin
  if maxint.Compare(1) < 0 then Assign(0)
  else begin
    maxint.Trim;
    d:= length(maxint.fdigits);
    SetDigitLength(d);
    Sign:= 1;
    repeat
      for i:= 0 to d - 1 do fDigits[i]:= system.Random(Base);
    until Compare(maxint) < 0;
  end;
end;

{ **************** GetNextPrime ********** }
procedure TInteger.Getnextprime;
var
  Test: TInteger;
begin
  Test:= TInteger.Create(Empty);
  if not IsOdd then Subtract(1);
  repeat Add(2);
  until IsProbablyPrime;
  Test.Free;
end;
{ End GDD additions March, 2009 }


{ GDD Operator additions Nov 2013}
{$IF compilerVersion>15}
{_________  OPERATOR CLASS IMPLEMENTATIONS ____________}


class operator TInteger.GreaterThan(a, b: TInteger): boolean;
begin
  Result:= (a.Compare(b) > 0);
end;

class operator TInteger.GreaterThanOrEqual(a, b: TInteger): boolean;
begin
  Result:= (a.Compare(b) >= 0)
end;

class operator TInteger.Subtract(a, b: TInteger): TInteger;
begin
  Result.Create(empty);
  Result.Assign(a);
  Result.Subtract(b);
end;

class operator TInteger.Add(a, b: TInteger): TInteger;
begin
  Result.Create(empty);
  Result.Assign(a);
  Result.Add(b);
end;

class OPERATOR TInteger.Multiply(a, b: TInteger): TInteger;
begin
  Result.Create(empty);
  Result.Assign(a);
  Result.Mult(b);
end;
class operator TInteger.LessThan(a, b: TInteger): boolean;
begin
  Result:= (a.Compare(b) < 0);
end;

class operator TInteger.LessThanOrEqual(a, b: TInteger): boolean;
begin
  Result:= (a.Compare(b) <=0)
end;
class operator TInteger.Implicit(a: Int64): TInteger;
begin
  Result.assign{Create}(a);
end;

class operator TInteger.Implicit(a: TInteger): string;
begin
  Result:= a.ConvertToDecimalString(true);
end;

(*
class operator TInteger.Implicit(s: String): TInteger;
begin
  Result:= assign(s);
end;
*)

class operator TInteger.Implicit(a: TInteger): Int64;
begin
  a.ConvertToInt64(Result);
end;

class operator TInteger.Inc(var a: TInteger): TInteger;
begin
  //Result.Create(empty);
  result := a + 1;
 a.assign(result);
end;

 { ********* Dec ************ }
class operator TInteger.Dec(var a: TInteger): TInteger;
begin
  Result.Create(empty);
  Result:= a - 1;
  a.assign(result);
end;

class operator TInteger.IntDivide(a, b: TInteger): TInteger;
begin
  Result.Create(empty);
  Result.Assign(a);
  Result.Divide(b);
end;

class operator TInteger.Modulus(a, b: TInteger): TInteger;
begin
  Result.Create(empty);
  Result.Assign(a);
  Result.Modulo(b);
end;


{ ************ NRoot ********** }
class operator TInteger.Negative(a: TInteger): TInteger;
begin
  Result.Create(empty);
  Result.Assign(a);
  Result.ChangeSign;
end;

{********** Operator <> *******}
class operator TInteger.NotEqual(a, b: TInteger): boolean;
begin
  Result:= (a.Compare(b) <> 0);
end;

{*********** Operator = ***********}
class operator TInteger.Equal(a, b: TInteger): boolean;
begin
  Result:= (a.Compare(b) = 0);
end;

(*
{****** Operqtor Inc *********}
Class Operator TInteger.Inc(a:TInteger):TInteger;
begin
  a:=a+1;
end;


{*********** Operator Dec ******}
Class Operator TInteger.Dec(a:TInteger):TInteger;
begin
  result:=a-1;
  a:=result;
end;
*)

{$IFEND}

var
  i: integer;

initialization

SetBaseVal(100000);
Randomize;

finalization

end.
