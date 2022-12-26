unit UBigIntsV2;

{Copyright 2005, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Arbitarily large integer unit -
  Operations supported:
    Assign, Add, Subtract, Multiply, Divide, Modulo, Compare, Factorial
   (Factorial limited to max integer, run time would probably limit it
    to much less)
   All operations are methods of a Tinteger class and replace the value with the
    result.  For binary operations (all except factorial), the second operand is
    passed as a parameter to the procedure.
 }
 {additions by Hans Klein 2005(hklein@planet.nl)
        Procedures:
          pow(const exponent:Int64);
          square;
          sqroot;
          gcd(i2:tinteger);
          gcd(i2:Int64);
          shiftleft: fast multiplication by base;
          modpow(const e,m:Tinteger);
          invmod(I2:Tinteger);
        Functions:
          shiftright: fast division by base; result=remainder;
          isodd:boolean;
          IsProbablyPrime:boolean;

 {Changes by Charles Doumar September 2005
  Copyright 2005, Charles Doumar
        Rewrites or Additions:
          ConvertToDecimalString(commas:boolean); (total rewrite)
          mult(i2:tinteger) (total rewrite);
          mult(const I2:int64); (total rewrite);
          square (total rewrite);
          Nroot(const root: integer); : find the Nth root of an integer (New)
          abscompare(I2:Int64):integer; (new function)
          GetBase: integer;
          IsZero:boolean;
          CompareZero:integer;
          AssignOne;
          AssignZero;
          ShiftLeftBase10(num: integer);
          ShiftRightBase10(num: integer);
          ShiftLeftNum(num: integer);
          ShiftRightNum(num: integer);
        Optimizations:
          trim - remove condition from loop, check for sign = 0 when val=0
          Assign(Const i2:Int64);  - remove MOD statements
          Assign(const i2:string); - remove MOD statements
          dividerem(const I2:TInteger; var remain:TInteger); - remove MOD statements
          pow(const exponent:Int64);  - remove MOD, call square, remove div
          isodd - remove MOD statement
          absadd - removed MOD statements
          ConvertToDecimalString - removed Mod Statements
          Sqroot; - call new Nroot function
         Bug fixes
          converttoInt64(n: Int64); - fixed overflow problem, fixed sign problem
          invmod - fixed failure to free memory problem
          dividerem - change remainder to 0 when divisor is 0
          fixed various sign functions....

}

{Changes made by Hans Klein Oct 2005, can be found by searching for hk
added
        divide2: handles efficient division by 2.
        divmodsmall(int 64, var int64)
        assignsmall(int 64)
                these two procedures handle integers less than base more efficient;
modified to use these procedures:
        assign(int64)
        modulo(int64)
        modulo(tinteger)
        divide(int64)
        divide(tinteger)
modified and partially rewritten
        modpow
        gcd
optimized:
        isprobablyprime:
          uses divide2
          first factors out small factors using divmodsmall

changed setbaseval(1000) to SetbaseVal(100000);
 changed in procedure setbaseval:
    if n > 10e6 then
    n := trunc(10e6) into
    {if n > 1e6 then
    n := trunc(1e6) as 10e6 produces incorrect results with then root procedures
          }
{Changes made by Charles Doumar Jan 2005

Added:
    AbsoluteValue: make negative number positive
Bug fixes:
    DigitCount: Now correctly counts digits...
    Assign:  Now works with different bases ...
    ShiftLeftBase10: ensure digits Array is set...
    ShiftRightBase10: correctly count digits...

optimized:
    Square:  faster
    Mult:  Faster

}
interface

uses Forms, Dialogs, SysUtils, Windows;

type
  TDigits = array of int64;

  TInteger = class(TObject)
  protected

    Sign:    integer;
    fDigits: TDigits;
    Base:    integer;
    procedure AbsAdd(const I2: tinteger);
    function AbsCompare(I2: TInteger): integer; overload;
    function AbsCompare(I2: int64): integer; overload;
    procedure AbsSubtract(const i2: Tinteger);
    procedure AssignZero;
    procedure AssignOne;
    function CompareZero: integer;
    function IsZero: boolean;
    function GetBasePower: integer;
    procedure Trim;
    procedure ShiftLeftBase10(num: integer);
    procedure ShiftRightBase10(num: integer);
    procedure ShiftLeftNum(num: integer);
    procedure ShiftRightNum(num: integer);
  public
    property Digits: TDigits Read fDigits;
    constructor Create;
    procedure Assign(const I2: TInteger); overload;
    procedure Assign(const I2: int64); overload;
    procedure Assign(const I2: string); overload;
    procedure AbsoluteValue;
    procedure Add(const I2: TInteger); overload;
    procedure Add(const I2: int64); overload;
    procedure Subtract(const I2: TInteger); overload;
    procedure Subtract(const I2: int64); overload;
    procedure Mult(const I2: TInteger); overload;
    procedure Mult(const I2: int64); overload;
    procedure FastMult(const I2: TInteger);
    procedure Divide(const I2: TInteger); overload;
    procedure Divide(const I2: int64); overload;
    procedure Modulo(const i2: TInteger); overload;
    procedure Modulo(const i2: int64); overload;
    procedure DivideRem(const I2: TInteger; var remain: TInteger);
    function Compare(I2: TInteger): integer; overload;
    function Compare(I2: int64): integer; overload;
    procedure Factorial;
    function ConvertToDecimalString(commas: boolean): string;
    function ConvertToDecimalStringold(commas: boolean): string;
    function ConvertToInt64(var n: int64): boolean;
    function DigitCount: integer;
    procedure SetSign(s: integer);
    function GetSign: integer;
    function IsPositive: boolean;
    procedure ChangeSign;
    procedure Pow(const exponent: int64);
    procedure ModPow(const I2, m: Tinteger);
    procedure Sqroot;
    procedure Square;
    procedure FastSquare;
    function ShiftRight: integer;
    procedure ShiftLeft;
    procedure Gcd(const I2: Tinteger); overload;
    procedure Gcd(const I2: int64); overload;
    function IsOdd: boolean;
    function IsProbablyPrime: boolean;
    procedure InvMod(I2: Tinteger);
    procedure SetDigitLength(const k: integer);
    function GetLength: integer;
    procedure NRoot(const root: integer);
    function GetBase: integer;
    procedure assignsmall(i2: int64);
    procedure divmodsmall(d: int64; var rem: int64);
    procedure divide2;
  end;

  {Caution - calculations with mixed basevalues are not allowed,
   changes to Baseval should be made before any other TInteger
   operations}
procedure SetBaseVal(const newbase: integer);
function GetBasePower: integer;


implementation

uses Math;

var
  BaseVal:   integer = 1000; {1,000}
  BasePower: integer;
  worki2, imult1, imult2, iadd3, isub3: TInteger;
  idiv2, idivd2, idiv3, idivd3, idiv4, d, dq: Tinteger;
  icomp3, imod3: TInteger;
  i3, i4:    TInteger;


procedure SetBaseVal(const newbase: integer);
var
  n: integer;
begin
  BaseVal := 10;
  BasePower := 1;
  n := newbase;
  {if n > 10e6 then
    n := trunc(10e6)}
  if n > 1e6 then
    n := trunc(1e6) {validate new base value}
  else if n < 10 then
    n := 10;
  while n > 10 do
  begin
    Inc(BasePower);
    n := n div 10;
    BaseVal := BaseVal * 10;
  end;

  {create, or re-create, work fields}
  if assigned(worki2) then
    worki2.Free;
  worki2 := Tinteger.Create;
  if assigned(imult1) then
    imult1.Free;
  imult1 := Tinteger.Create;
  if assigned(imult2) then
    imult2.Free;
  imult2 := Tinteger.Create;
  if assigned(isub3) then
    isub3.Free;
  isub3 := Tinteger.Create;
  if assigned(iadd3) then
    iadd3.Free;
  iadd3 := Tinteger.Create;
  if assigned(idiv2) then idiv2.Free;  idiv2 := Tinteger.Create;
  if assigned(idivd2) then idivd2.Free; idivd2 := Tinteger.Create;
  if assigned(idiv3) then
    idiv3.Free;
  idiv3 := Tinteger.Create;
  if assigned(idivd3) then
    idivd3.Free;
  idivd3 := Tinteger.Create;
  if assigned(idiv4) then
    idiv4.Free;
  idiv4 := Tinteger.Create;
  if assigned(icomp3) then
    icomp3.Free;
  icomp3 := Tinteger.Create;
  if assigned(imod3) then
    imod3.Free;
  imod3 := Tinteger.Create;
  if assigned(d) then
    d.Free;
  d := Tinteger.Create;
  if assigned(dq) then
    dq.Free;
  dq := Tinteger.Create;
  if assigned(i3) then
    i3.Free;
  i3 := Tinteger.Create;
  if assigned(i4) then
    i4.Free;
  i4 := Tinteger.Create;
end;

function GetBasePower: integer;
begin
  Result := BasePower;
end;

constructor TInteger.Create;
begin
  inherited;
  Base := BaseVal; {base in Tinteger in case we want to handle other bases later}
  AssignZero;
end;

{************ ShiftRight ***********}
function Tinteger.ShiftRight: integer;
  {Divide value by baseval and return the remainder}
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

procedure Tinteger.ShiftRightNum(num: integer);
{Divide value by baseval and return the remainder}
var
  c, i: integer;
begin
  if num > 0 then
  begin
    c := high(fDigits);
    for i := 0 to c - Num do
      fDigits[i] := fDigits[i + Num];
    // do not setlength to zero...
    if c - num + 1 > 0 then
    begin
      SetLength(fDigits, c - num + 1);
      Trim;
    end
    else
      self.AssignZero;
  end;
end;


{********** ShiftLeft *********}
procedure Tinteger.ShiftLeft;
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

procedure Tinteger.ShiftLeftNum(num: integer);
{Multiply value by base}
var
  c, i: integer;
begin
  if num > 0 then
  begin
    c := high(fDigits);
    SetLength(fDigits, c + num + 1);
    for i := c downto 0 do
      fDigits[i + num] := fDigits[i];
    for i := num - 1 downto 0 do
      fDigits[i] := 0;
    Trim;
  end;
end;


{*************** SetDigitLength **********}
procedure TInteger.SetDigitLength(const k: integer);
{Expand or contract the number of digits}
begin
  SetLength(fDigits, k);
end;

{*********** GetLength **********}
function TInteger.GetLength: integer;
  {Return the number of digits for this base}
begin
  Result := length(fDigits);
end;

{************** Subtract ************}
procedure Tinteger.Subtract(const I2: TInteger);
{Subtract by negating, adding, and negating again}
begin
  i2.ChangeSign;
  Add(i2);
  i2.ChangeSign;
end;

{************* Subtract (64 bit integer)}
procedure Tinteger.Subtract(const I2: int64);
begin
  isub3.Assign(i2);
  isub3.ChangeSign;
  Add(isub3);
end;

{********* DigitCount ************}
function TInteger.DigitCount: integer;
  { Return count of base 10 digits in the number }
var
  n:   int64;
  Top: integer;
begin
  Top    := high(Digits);
  Result := Top * GetBasePower;
  n      := Digits[Top];
  if n > 0 then
    Result := Result + 1 + system.trunc(Math.Log10(n));
{
  while n > 0 do
  begin
    Inc(Result);
    n := n div 10;
  end;
}
end;

{************* SetSign ************}
procedure TInteger.SetSign(s: integer);
{Set the sign of the number to match the passed integer}
begin
  if s > 0 then
    Sign := +1
  else if s < 0 then
    Sign := -1
  else
    Sign := 0;
end;

{************** GetSign *********}
function TInteger.GetSign: integer;
begin
  Result := Sign;
end;

{*********** IsPositive ***********}
function TInteger.IsPositive: boolean;
begin
  Result := Sign > 0;
end;

{************** ChangeSign **********}
procedure Tinteger.ChangeSign;
begin
  Sign := -Sign;
end;


{******** Square *********}
procedure Tinteger.Square;
  {This square save multiplications, assume high(fdigits)=10, there are 100
   multiplications that must be preformed.  Of these 10 are unique diagonals,
   of the remaining 90 (100-10), 45 are repeated.  This procedure save
   (N*(N-1))/2 multiplications, (e.g., 45 of 100 multiplies).}
const
  ConstShift = 48;
var
  Carry, n, product: int64;
  xstart, i, j, k:   integer;
begin
  xstart := high(self.fDigits);
  imult1.AssignZero;
  imult1.Sign := Sign * Sign;
  SetLength(imult1.fDigits, xstart + xstart + 3);
  // Step 1 - calculate diagonal
  for i := 0 to xstart do
  begin
    k     := i * 2;
    product := fDigits[i] * fDigits[i];
    Carry := product shr ConstShift;
    if Carry = 0 then
      imult1.fDigits[k] := product
    else
    begin
      Carry := product div Base;
      imult1.fDigits[k] := product - Carry * Base;
      imult1.fDigits[k + 1] := Carry;
    end;
  end;
  // Step 2 - calculate repeating part
  for i := 0 to xstart do
  begin
    Carry := 0;
    for j := i + 1 to xstart do
    begin
      k     := i + j;
      product := fDigits[j] * fDigits[i] * 2 + imult1.fDigits[k] + Carry;
      Carry := product shr ConstShift;
      if Carry = 0 then
        imult1.fDigits[k] := product
      else
      begin
        Carry := product div Base;
        imult1.fDigits[k] := product - Carry * Base;
      end;
    end;
    k := xstart + i + 1;
    imult1.fDigits[k] := Carry + imult1.fDigits[k];
  end;
  // Step 3 - place in proper base
  xstart := high(imult1.fDigits);
  Carry  := 0;
  for i := 0 to xstart - 1 do
  begin
    n     := imult1.fDigits[i] + Carry;
    Carry := n div Base;
    imult1.fDigits[i] := n - Carry * Base;
  end;
  imult1.fDigits[xstart] := Carry;
  Assign(imult1);
  //  Trim;  {trim in assign}
end;


{********** Trim ***********}
procedure TInteger.Trim;
{eliminate leading zeros}
var
  i, j: integer;
begin
  i := high(fDigits);
  if i >= 0 then
  begin
    // start add by Charles Doumar
    j := i;
    if (fDigits[0] <> 0) then
      while (fDigits[i] = 0) do
        Dec(i)
    else
      while (i > 0) and (fDigits[i] = 0) do
        Dec(i);
    if j <> i then
      SetLength(fDigits, i + 1);
    // make sure sign is zero if value = 0...
    if (i = 0) and (self.Digits[0] = 0) then
      Sign := 0;
  end
  else
  begin
    AssignZero;
    //    showmessage('error in length of fdigits');
  end;
end;

{**************** GetBasePower *******}
function TInteger.GetBasePower: integer;
var
  n: integer;
begin
  if Base = BaseVal then
    Result := BasePower
  else
  begin
    Result := 0;
    n      := Base;
    while n > 1 do
    begin
      Inc(BasePower);
      n := n div 10;
    end;
  end;
end;


 {************* Assign **********}
procedure TInteger.Assign(const I2: TInteger); {Assign - TInteger}
{Loop replaced by Move for speed by Chalres D,  Mar 2006}
var
  i,len: integer;
begin
  if i2.Base = Base then
  begin
    len := length(i2.fDigits);
    SetLength(fDigits, len);
   //  for i := low(i2.fDigits) to high(i2.fDigits) do
   //   fDigits[i] := i2.fDigits[i];
    move(i2.fdigits[0],fdigits[0], len*sizeof(int64));
    Sign := i2.Sign;
    Trim;
  end
  else
    self.Assign(i2.ConvertToDecimalString(False))
  ;
end;

(*
procedure TInteger.Assign(const I2: TInteger;const start,stop : Integer); {Assign - TInteger}
var
  i,len: integer;
begin
  if i2.Base = Base then
  begin
    len := length(i2.fDigits);
    if start >= Len then
    begin
      self.AssignZero;
      exit;
    end;
    if len > stop then
      len := stop+1;
    SetLength(fDigits, len-start);
    move(i2.fdigits[start],fdigits[0],(len-start)*sizeof(int64));

//    for i := low(i2.fDigits) to high(i2.fDigits) do
//      fDigits[i] := i2.fDigits[i];
//    move(i2.fdigits[0],fdigits[0], len*sizeof(int64));
    Sign := i2.Sign;
    Trim;
  end
  else
    self.Assign(i2.ConvertToDecimalString(False))
    //    ShowMessage('Bases conversions not yet supported');
  ;
end;
*)

{************ Assign (int64)***********}
procedure TInteger.Assign(const I2: int64);
{Assign - int64}
var
  i:     integer;
  n, nn: int64;
begin
  // start add by hk.
  if system.abs(i2) < Base then
    assignsmall(i2)
  else
    //endadd
  begin
    SetLength(fDigits, 20);
    n := system.abs(i2);
    i := 0;
    repeat
      // start add by Charles Doumar
      nn := n div Base;
      fDigits[i] := n - nn * Base;
      n  := nn;
      // end
      //      fdigits[i]:=n mod base;
      //      n:=n div base;
      Inc(i);
    until n = 0;
    if i2 < 0 then
      Sign := -1
    else if i2 = 0 then
      Sign := 0
    else if i2 > 0 then
      Sign := +1;
    SetLength(fDigits, i);
    Trim;
  end;
end;

{************* Assign   (String type *********}
procedure TInteger.Assign(const i2: string);
{Convert a  string number}
var
  i, j:    integer;
  zeroval: boolean;
  n, nn:   int64;
  pos:     integer;
begin
  n := length(I2) div GetBasePower + 1;
  SetLength(fDigits, n);
  for i := 0 to n - 1 do
    fDigits[i] := 0;
  Sign := +1;
  j   := 0;
  zeroval := True;
  n   := 0;
  pos := 1;
  for i := length(i2) downto 1 do
  begin
    if i2[i] in ['0'..'9'] then
    begin
      n   := n + pos * (Ord(i2[i]) - Ord('0'));
      pos := pos * 10;
      if pos > Base then
      begin
        // start add by Charles Doumar
        nn  := n div Base;
        fDigits[j] := n - nn * Base;
        n   := nn;
        // end
        //          fdigits[j]:= n mod base;
        //          n:= n div base;
        pos := 10;
        Inc(j);
        zeroval := False;
      end
      else;
    end
    else if i2[i] = '-' then
      Sign := -1;
  end;
  fDigits[j] := n;  {final piece of the number}
  if zeroval and (n = 0) then
    Sign := 0;
  Trim;
end;

{************ Add *********}
procedure TInteger.Add(const I2: TInteger);
{add - TInteger}
var
  ii: TInteger;
begin
  if i2 = self then
  begin
    ii := TInteger.Create;
    ii.Assign(i2);
    if Sign <> ii.Sign then
      AbsSubtract(ii)
    else
      AbsAdd(ii);
    ii.Free;
  end
  else
  begin
    if Sign <> i2.Sign then
      AbsSubtract(i2)
    else
      AbsAdd(i2);
  end;
end;


{**************** AbsAdd ***************}
procedure tinteger.AbsAdd(const i2: tinteger);
{add values ignoring signs}
var
  i: integer;
  n, Carry: int64;
begin
  I3.Assign(self);
  SetLength(fDigits, max(length(fDigits), length(i2.fDigits)) + 1);
  {"add" could grow result by two digit}
  i     := 0;
  Carry := 0;
  while i < min(length(i2.fDigits), length(i3.fDigits)) do
  begin
    n     := i2.fDigits[i] + i3.fDigits[i] + Carry;
    // Start add by Charles Doumar
    Carry := n div Base;
    fDigits[i] := n - Carry * Base;
    // end
    //      fdigits[i]:= n mod base;
    //      if n >= base then carry:=1 else carry:=0;
    Inc(i);
  end;
  if length(i2.fDigits) > length(i3.fDigits) then
    while i <{=}length(i2.fDigits) do
    begin
      n     := i2.fDigits[i] + Carry;
      // Start add by Charles Doumar
      Carry := n div Base;
      fDigits[i] := n - Carry * Base;
      // end
      //      fdigits[i]:= n mod base;
      //      if n >= base then carry:=1 else carry:=0;
      Inc(i);
    end
  else if length(i3.fDigits) > length(i2.fDigits) then
  begin
    while i <{=}length(i3.fDigits) do
    begin
      n     := i3.fDigits[i] + Carry;
      // Start add by Charles Doumar
      Carry := n div Base;
      fDigits[i] := n - Carry * Base;
      // end
      //      fdigits[i]:= n mod base;
      //      if n >= base then carry:=1 else carry:=0;
      Inc(i);
    end;
  end;
  fDigits[i] := Carry;
  Trim;
end;


{************* Add (int64) ********}
procedure TInteger.Add(const I2: int64);
{Add - Int64}
begin
  IAdd3.Assign(I2);
  Add(IAdd3);
end;

{*************** AbsSubtract *************}
procedure TInteger.AbsSubtract(const i2: Tinteger);
{Subtract values ignoring signs}
var
  c:  integer;
  i3: TInteger;
  i, j, k: integer;
begin {request was subtract and signs are same,
         or request was add and signs are different}
  c  := AbsCompare(i2);
  i3 := TInteger.Create;
  if c < 0 then {abs(i2) larger, swap and subtract}
  begin
    i3.Assign(self);
    Assign(i2);
  end
  else if c >= 0 then
    {self is bigger} i3.Assign(i2);
  for i := 0 to high(i3.fDigits) do
  begin
    if fDigits[i] >= i3.fDigits[i] then
      fDigits[i] := fDigits[i] - i3.fDigits[i]
    else
    begin  {have to "borrow"}
      j := i + 1;
      while (j <= high(fDigits)) and (fDigits[j] = 0) do
        Inc(j);
      if j <= high(fDigits) then
      begin
        for k := j downto i + 1 do
        begin
          Dec(fDigits[k]);
          fDigits[k - 1] := fDigits[k - 1] + Base;
        end;
        fDigits[i] := fDigits[i] - i3.fDigits[i];
      end
      else
        ShowMessage('Subtract error');
    end;
  end;
  i3.Free;
  Trim;
end;


{*************** Mult  (Tinteger type) *********}
procedure TInteger.Mult(const I2: TInteger);
{Multiply - by Tinteger}
const
  ConstShift = 48;
var
  Carry, n, product: int64;
  xstart, ystart, i, j, k: integer;
begin
  xstart := high(self.fDigits);
  ystart := high(i2.fDigits);
  imult1.AssignZero;
  imult1.Sign := i2.Sign * Sign;
  SetLength(imult1.fDigits, xstart + ystart + 3);
  // long multiply ignoring base
  for i := 0 to xstart do
  begin
    Carry := 0;
    for j := 0 to ystart do
    begin
      k     := i + j;
      product := i2.fDigits[j] * self.fDigits[i] + imult1.fDigits[k] + Carry;
      Carry := product shr ConstShift;
      if Carry = 0 then
        imult1.fDigits[k] := product
      else
      begin
        Carry := product div Base;
        imult1.fDigits[k] := product - Carry * Base;
      end;
    end;
    imult1.fDigits[ystart + i + 1] := Carry;
  end;
  // place in proper base
  xstart := length(imult1.fDigits) - 1;
  Carry  := 0;
  for i := 0 to xstart - 1 do
  begin
    n     := imult1.fDigits[i] + Carry;
    Carry := n div Base;
    imult1.fDigits[i] := n - Carry * Base;
  end;
  imult1.fDigits[xstart] := Carry;
  Assign(imult1);
  //  Trim; trim in assign
end;

{*************** Mult  (Int64 type) *********}
procedure TInteger.Mult(const I2: int64);
{Multiply - by int64}
var
  Carry, n, d: int64;
  i:     integer;
  ITemp: TInteger;
begin
  d := system.abs(i2);
  if d > $ffffffff then
  begin
    itemp := TInteger.Create;
    itemp.Assign(i2);
    self.Mult(itemp);
    itemp.Free;
    exit;
  end;
  Carry := 0;
  for i := 0 to high(fDigits) do
  begin
    n     := fDigits[i] * d + Carry;
    Carry := n div Base;
    fDigits[i] := n - Carry * Base;
  end;
  if Carry <> 0 then
  begin
    i := high(fDigits) + 1;
    SetLength(fDigits, i + 11 div GetBasePower + 1);
    while Carry > 0 do
    begin
      n     := Carry;
      Carry := n div Base;
      fDigits[i] := n - Carry * Base;
      Inc(i);
    end;
  end;
  Trim;
end;


{************ Divide *************}
procedure TInteger.Divide(const I2: TInteger);
{Divide - by TInteger}
var
  dummy: int64;
begin
  //if i2.CompareZero = 0 then
  //  exit;
  //add by hk
  if high(i2.fDigits) = 0 then
    divmodsmall(i2.Sign * i2.fDigits[0], dummy)
  else
    {IDiv3 holds the remainder (which we don't need)}
    DivideRem(I2, idiv3);
end;

{************* Divide (Int64) **********}
procedure TInteger.Divide(const I2: int64);
{Divide - by Int64}
var
  dummy: int64;
begin
  //add by hk
  if i2 = 0 then
    exit;
  if system.abs(i2) < Base then
    divmodsmall(i2, dummy)
  else
  begin
    idiv2.Assign(i2);
    Divide(idiv2);
  end;
end;

{***************** Modulo *************}
procedure Tinteger.Modulo(const i2: TInteger);
{Modulo (remainder after division) - by Tinteger}
var
  k: int64;
begin
  //add by hk
  if high(i2.fDigits) = 0 then
  begin
    divmodsmall(i2.Sign * i2.fDigits[0], k);
    assignsmall(k);
  end
  else
  begin
    DivideRem(i2, imod3);
    Assign(imod3);
  end;
end;

{************ Modulo (Int64) ************}
procedure TInteger.Modulo(const I2: int64);
{Modulo - by Int64}
var
  i3: Tinteger;
  k:  int64;
begin
  //add by hk
  if i2 = 0 then
    AssignZero
  else if system.abs(i2) < Base then
  begin
    divmodsmall(i2, k);
    assignsmall(k);
  end
  else
  begin
    i3 := TInteger.Create;
    i3.Assign(i2);
    Modulo(i3);
    i3.Free;
  end;
end;


{**************** Dividerem ***************}
procedure TInteger.DivideRem(const I2: TInteger; var remain: TInteger);
    (*
    This version is based on a paper "Multiple-length Division Revisited: a Tour
    of the Minefield", by Per Brinch Hansen, Software - Practice and Experience,
    Vol 24(6), June 1994.

    Efficient implementation of long division
    *)
{Product}
  procedure product(var x: TInteger; y: TInteger; k: integer);
  var
    {carry,} i:     integer;
    Carry, m, temp: int64;
  begin
    // multiple-length division revisited
    m := y.GetLength;
    x.AssignZero;
    Carry := 0;
    if length(x.fDigits) <= m then
      SetLength(x.fDigits, m + 1);
    for i := 0 to m - 1 do
    begin
      temp  := y.fDigits[i] * k + Carry;
      // start add by Charles Doumar
      Carry := temp div BaseVal;
      x.fDigits[i] := temp - Carry * BaseVal;
      // end
      //      x.fdigits[i] := temp mod baseval;
      //      carry := temp div baseval
    end;
    (*if m <= x.getlength{w} then*) x.fDigits[m] := Carry;
    //else if carry <> 0 then showmessage('Product Overflow');
  end;

  procedure Quotient(var x: TInteger; y: TInteger; k: integer);
  var
    i, m: integer;
    temp, Carry: int64;
  begin
    m := y.GetLength;
    x.AssignZero;
    Carry := 0;
    SetLength(x.fDigits, m);
    for i := m - 1 downto 0 do
    begin
      temp  := Carry * BaseVal + y.fDigits[i];
      x.fDigits[i] := temp div k;
      // start add by Charles Doumar
      Carry := temp - x.Digits[i] * k;
      // end
      //carry := temp mod k
    end;
  end;

  procedure Remainder(var x: TInteger; y: TInteger; k: integer);
  var
    Carry, n, temp: int64;
    i, m: integer;
  begin
    m := y.GetLength;
    x.AssignZero;
    Carry := 0;
    SetLength(x.fDigits, M);
    for i := m - 1 downto 0 do
      //      carry := (carry * baseval + y.fdigits[i]) mod k;
      //      Start update by Charles Doumar
    begin
      n     := (Carry * BaseVal + y.fDigits[i]);
      temp  := n div k;
      Carry := n - temp * k;
    end;
    //       end
    x.fDigits[0] := Carry;
  end;

  function Trial(r, d: TInteger; k, m: integer): int64;
  var
    d2, r3: int64;
    km:     integer;
  begin
    {2 <= m <= k+m <= w}
    km := k + m;
    if length(r.fDigits) < km + 1 then
      SetLength(r.fDigits, km + 1);
    r3     := (r.fDigits[km] * BaseVal + r.fDigits[km - 1]) * BaseVal +
      r.fDigits[km - 2];
    d2     := d.fDigits[m - 1] * BaseVal + d.fDigits[m - 2];
    Result := min(r3 div d2, BaseVal - 1);
  end;

  function Smaller(r, dq: TInteger; k, m: integer): boolean;
  var
    i, j: integer;
  begin
    {0 <= k <= k+m <= w}
    i := m;
    j := 0;
    while i <> j do
      if r.fDigits[i + k] <> dq.fDigits[i] then
        j := i
      else
        Dec(i);
    Result := r.fDigits[i + k] < dq.fDigits[i];
  end;

  procedure Difference(var r: TInteger; dq: TInteger; k, m: integer);
  var
    borrow, diff, i: integer;
    acarry: int64;
  begin
    {0 <= k <= k+m <= w}
    if length(r.fDigits) < m + k + 1 then
      SetLength(r.fDigits, m + k + 1);
    if length(dq.fDigits) < m + 1 then
      SetLength(dq.fDigits, m + 1);
    borrow := 0;
    for i := 0 to m do
    begin
      diff   := r.fDigits[i + k] - dq.fDigits[i] - borrow + BaseVal;
      // start add by Charles Doumar
      acarry := diff div BaseVal;
      r.fDigits[i + k] := diff - acarry * BaseVal;
      borrow := 1 - acarry;
      // end
      //      r.fdigits[i + k] := diff mod baseval;
      //      borrow := 1 - diff div baseval
    end;
    if borrow <> 0 then
      ShowMessage('Difference Overflow');
  end;

  procedure LongDivide(x, y: TInteger; var q, r: TInteger; const n, m: integer);
  var
    f, k: integer;
    qt:   int64;
  begin
    {2 <= m <= n <= w}
    f := BaseVal div (y.fDigits[m - 1] + 1);

    product(r, x, f);
    //r.assign(x); r.mult(f);
    product(d, y, f);
    //d.assign(y); d.mult(f);
    q.AssignZero;
    SetLength(q.fDigits, n - m + 1);
    for k := n - m downto 0 do
    begin
      {2 <= m <= k+m <=n <= w}
      qt := trial(r, d, k, m);
      product(dq, d, qt);
      //dq.assign(d); dq.mult(qt);
      if length(dq.fDigits) < M + 1 then
        SetLength(dq.fDigits, M + 1);
      if smaller(r, dq, k, m) then
      begin
        qt := qt - 1;
        product(dq, d, qt);
        //dq.assign(d); dq.mult(qt);
      end;
      if k > high(q.fDigits) then
        SetLength(q.fDigits, k + 1);
      q.fDigits[k] := qt;
      difference(r, dq, k, m);
    end;
    idiv4.Assign(r);
    Quotient(r, idiv4, f);
    r.Trim;
  end;

  procedure Division(x, y: TInteger; var q, r: TInteger);
  var
    m, n, y1: integer;
  begin
    m := y.GetLength;
    if m = 1 then
    begin
      y1 := y.fDigits[m - 1];
      if y1 > 0 then
      begin
        Quotient(q, x, y1);
        Remainder(r, x, y1);
      end
      else
        ShowMessage('Division Overflow');
    end
    else
    begin
      n := x.GetLength;
      if m > n then
      begin
        q.AssignZero;
        r := x;
      end
      else {2 <= m <= n <= w}
        longdivide(x, y, q, r, n, m);
    end;
  end;

var
  signout: integer;

begin
  idivd2.assign(I2);
  if Sign <> idivd2.Sign then
    signout := -1
  else
    signout := +1;
  if not self.IsZero then
    Sign := +1;
  if not idivd2.IsZero then
    idivd2.Sign := +1;
  //  if i2.compare(0) = 0 then
  if idivd2.CompareZero = 0 then
    // start add by Charles Doumar
  begin
    remain.AssignZero;
    exit;
  end;

  if AbsCompare(idivd2) >= 0 then  {dividend>=divisor}
  begin
    idivd3.Assign(self);
    division(idivd3, idivd2, self, remain);
    Sign := signout;
    remain.Sign := signout;
    remain.Trim;
    Trim;
    // only change signs if not zero...
    //      sign := signout;
    //      remain.sign := signout;
  end
  else
  begin
    remain.Assign(self);
    AssignZero;
  end;
end;

{**************** Compare ************}
function TInteger.Compare(i2: TInteger): integer;
  {Compare - to Tinteger}
  {return +1 if self>i2, 0 if self=i2 and -1 if self<i2)}
begin
{
  // check for bad signs
  if ((self.IsZero) and (self.Sign <> 0)) or
     ((self.iszero=false) and (self.sign = 0)) or
     ((i2.IsZero) and (i2.Sign <> 0)) or
     ((i2.iszero=false) and (i2.Sign = 0)) then
       showmessage('bad sign in Compare i2');
}

  //  if (sign < 0) and (i2.sign > 0) then
  if Sign < i2.Sign then
    Result := -1
  //  else if (sign > 0) and (i2.sign < 0) then
  else if Sign > i2.Sign then
    Result := +1
  else if (self.Sign = 0) and (i2.Sign = 0) then
    Result := 0
  else
  begin
    {same sign} Result := AbsCompare(i2);
    if (Sign < 0) then
      Result := -Result; {inputs were negative, largest abs value is smallest}
  end;
end;

{****************** Compare (Int64) *********}
function TInteger.Compare(i2: int64): integer;
  {Compare - to int64}
  {return +1 if self>i2, 0 if self=i2 and -1 if self<i2)}
begin
  icomp3.Assign(i2);
{
  //  check for bad signs...
  if ((self.IsZero) and (self.Sign <> 0)) or
     ((self.iszero=false) and (self.sign = 0)) or
     ((icomp3.IsZero) and (icomp3.Sign <> 0)) or
     ((icomp3.iszero=false) and (icomp3.Sign = 0)) then
       showmessage('bad sign in compare int64');
}

  //  if (sign < 0) and (icomp3.sign > 0) then
  if Sign < icomp3.Sign then
    Result := -1
  //  else if (sign > 0) and (icomp3.sign < 0) then
  else if Sign > icomp3.Sign then
    Result := +1
  else if (self.Sign = 0) and (icomp3.Sign = 0) then
    Result := 0
  else
  begin
    {same sign} Result := AbsCompare(icomp3);
    if Sign < 0 then
      Result := -Result;
  end;
end;

{************* CompareZero *************}
function TInteger.CompareZero: integer;
begin
{
// check for bad signs...
  if ((iszero) and (sign <> 0)) or
     ((iszero=false) and (sign=0)) then
    showmessage('Bad Sign in CompareZero');
}
  Result := Sign;
  //  if iszero then
  //    result := 0
  //  else if sign = 1 then
  //    Result := 1
  //  else if sign = -1 then
  //    Result := -1
  //  else Result := 0;
end;

{************* AbsCompare *************}
function TInteger.AbsCompare(i2: Tinteger): integer;
  {compare absolute values ingoring signs - to Tinteger}
var
  i: integer;
begin

{
  // check for bad signs
  if ((self.IsZero) and (self.Sign <> 0)) or
     ((self.iszero=false) and (self.sign = 0)) or
     ((i2.IsZero) and (i2.Sign <> 0)) or
     ((i2.iszero=false) and (i2.Sign = 0)) then
       showmessage('bad sign in ABSCompare(i2)');
}

  Result := 0;
  //  if self.iszero and i2.iszero then
  if (self.Sign = 0) and (i2.Sign = 0) then
    Result := 0
  else if length(fDigits) > length(i2.fDigits) then
    Result := +1
  else if length(fDigits) < length(i2.fDigits) then
    Result := -1
  else {equal length}
    for i := high(fDigits) downto 0 do
    begin
      if fDigits[i] > i2.fDigits[i] then
      begin
        Result := +1;
        break;
      end
      else if fDigits[i] < i2.fDigits[i] then
      begin
        Result := -1;
        break;
      end;
    end;
end;

{************* AbsCompare *************}
function TInteger.AbsCompare(I2: int64): integer;
  {compare absolute values ingoring signs - to Tinteger}
var
  i3: Tinteger;
begin
  i3 := tinteger.Create;
  i3.Assign(i2);
  Result := AbsCompare(i3);
  i3.Free;
end;


{*********** Factorial *******}
procedure TInteger.Factorial;
{Compute factorial - number must be less than max integer value}
var
  n: int64;
  i: integer;
begin
  n := 0;
  if (Compare(high(integer)) >= 0) or (Sign < 0) then
    exit;
  //  if compare(0) = 0 then
  if CompareZero = 0 then
  begin  {0! =1 by definition}
    AssignOne;
    exit;
  end;
  for i := high(fDigits) downto 0 do
  begin
    n := n * Base + fDigits[i];
  end;
  Dec(n);
  while n > 1 do
  begin
    Mult(n);
    Dec(n);
    {provide a chance to cancel long running ops}
    //   if (n mod 64) =0
    if (n and $4f) = $4f then
      application.ProcessMessages;
  end;
end;

{************** ConvertToDecimalStirng ********}
function TInteger.ConvertToDecimalStringold(commas: boolean): string;
var
  i:     integer;
  n, nn: int64;
  c:     byte;
  Count: int64;
  b:     integer;
begin
  Result := '';
  b      := GetBasePower;
  if length(fDigits) = 0 then
    AssignZero;
  Count := 0;  {digit count used to put commas in proper place}
  for i := 0 to high(fDigits) do
  begin
    n := fDigits[i];
    repeat
      // start update by Charles Doumar
      nn := n div 10;
      c  := n - nn * 10;
      n  := nn;
      // end
      //              c:=n mod 10;
      //              n:=n div 10;
      Inc(Count);
      Result := char(Ord('0') + c) + Result;
      if commas and (Count mod 3 = 0) then
        Result := ThousandSeparator + Result;
    until (Count mod b = 0) or ((i = high(fDigits)) and (n = 0));
  end;

  if Result[1] = ',' then
    Delete(Result, 1, 1); {might have put in one comma too many}
  if Result = '' then
    Result := '0'
  else if Sign < 0 then
    Result := '-' + Result;
  if Result = '-0' then
    Result := '0';
end;


(*
{************** ConvertToDecimalStirng ********}
function TInteger.ConvertToDecimalString(commas: boolean): string;
var
  i, j, NumCommas, CurPos, StopPos, b, DigCount, NewPos, Top: integer;
  n, nn, last: int64;
  c: byte;

begin
  if length(fDigits) = 0 then
    AssignZero;
  Top    := high(self.Digits);
  Last   := fDigits[Top];
  if Last = 0 then
  begin
    Result := '0';
    exit;
  end;
  Result := '';
  b      := GetBasePower;
  DigCount := Top * b + 1 + trunc(Math.log10(Last));
  Dec(Top);
  if Sign > 0 then
  begin
    CurPos := DigCount;
    SetLength(Result, CurPos);
    StopPos := 0;
  end
  else
  begin
    CurPos := DigCount + 1;
    SetLength(Result, CurPos);
    Result[1] := '-';
    StopPos   := 1;
  end;
  for i := 0 to Top do
  begin
    n := fDigits[i];
    for j := 1 to b do
    begin
      nn := n div 10;
      c  := n - nn * 10;
      n  := nn;
      Result[CurPos] := char($30 + c);
      Dec(CurPos);
    end;
  end;
  repeat
    nn   := Last div 10;
    c    := Last - nn * 10;
    Last := nn;
    Result[CurPos] := char($30 + c);
    Dec(CurPos);
  until CurPos <= StopPos;

  if Commas = True then
  begin
    CurPos    := Length(Result);
    NumCommas := (DigCount - 1) div 3;
    if NumCommas > 0 then
    begin
      NewPos := CurPos + NumCommas;
      SetLength(Result, NewPos);
      for i := 1 to NumCommas do
      begin
        Result[NewPos]     := Result[CurPos];
        Result[NewPos - 1] := Result[CurPos - 1];
        Result[NewPos - 2] := Result[CurPos - 2];
        Result[NewPos - 3] := ThousandSeparator;
        Dec(NewPos, 4);
        Dec(CurPos, 3);
      end;
    end;
  end;
end;
*)

{************** ConvertToDecimalStirng ********}
function TInteger.ConvertToDecimalString(commas: boolean): string;
var
  i, j, NumCommas, CurPos, StopPos, b, DigCount, NewPos, Top: integer;
  n, nn, last: int64;
  c: byte;

begin
  if length(fDigits) = 0 then
    AssignZero;
  if IsZero then
  begin
    Result := '0';
    exit;
  end;
  Result := '';
  b      := GetBasePower;
  Top    := high(self.Digits);
  Last   := fDigits[Top];
  DigCount := Top * b + 1 + trunc(Math.log10(Last));
  Dec(Top);
  if Sign > 0 then
  begin
    CurPos := DigCount;
    SetLength(Result, CurPos);
    StopPos := 0;
  end
  else
  begin
    CurPos := DigCount + 1;
    SetLength(Result, CurPos);
    Result[1] := '-';
    StopPos   := 1;
  end;
  for i := 0 to Top do
  begin
    n := fDigits[i];
    for j := 1 to b do
    begin
      nn := n div 10;
      c  := n - nn * 10;
      n  := nn;
      Result[CurPos] := char($30 + c);
      Dec(CurPos);
    end;
  end;
  repeat
    nn   := Last div 10;
    c    := Last - nn * 10;
    Last := nn;
    Result[CurPos] := char($30 + c);
    Dec(CurPos);
  until CurPos <= StopPos;

  if Commas = True then
  begin
    CurPos    := Length(Result);
    NumCommas := (DigCount - 1) div 3;
    if NumCommas > 0 then
    begin
      NewPos := CurPos + NumCommas;
      SetLength(Result, NewPos);
      for i := 1 to NumCommas do
      begin
        Result[NewPos]     := Result[CurPos];
        Result[NewPos - 1] := Result[CurPos - 1];
        Result[NewPos - 2] := Result[CurPos - 2];
        Result[NewPos - 3] := ThousandSeparator;
        Dec(NewPos, 4);
        Dec(CurPos, 3);
      end;
    end;
  end;
end;


{********* ConvertToInt64 **********}
function TInteger.ConvertToInt64(var n: int64): boolean;
var
  i: integer;
  savesign: integer;
begin
  Result   := False;
  savesign := Sign;
  Sign     := +1;
  if (self.Compare(9223372036854775806) < 1) then
  begin
    n := 0;
    for i := high(fDigits) downto 0 do
      n := Base * n + fDigits[i];
    if savesign < 0 then
      n := -n;
    Result := True;
  end;
  Sign := savesign;
end;

{********* Pow **************}
procedure Tinteger.Pow(const exponent: int64);
{raise self to the "exponent" power}
var
  i2: tinteger;
  n:  int64;
  s:  integer;
begin
  n := exponent;
  if (n <= 0) then
  begin
    if n = 0 then
      AssignOne
    else
      AssignZero;
    exit;
  end;
  s := Sign;
  if ((s < 0) and not (odd(n))) then
    s := 1;
  Sign := 1;
  i2 := TInteger.Create;
  i2.AssignOne;
  if (n >= 1) then
    if n = 1 then
      i2.Assign(self)
    else
    begin
      repeat
        //        if (n mod 2)=1 then i2.mult(self);
        if (n and $1) = 1 then
          i2.Mult(self);
        //        n:=n div 2;
        //        mult(self);
        n := N shr 1;
        application .processmessages;
        Square;
      until (n = 1);
      i2.Mult(self);
    end;
  Assign(i2);
  Sign := s;
  i2.Free;
end;

(*
procedure Tinteger.ModPow(const i2, m: Tinteger);
{self^I2 modulo m}
var
  ans, rest, two, e: Tinteger;
  hulp: integer;
begin
  if (length(i2.fDigits) = 0) or (length(m.fDigits) = 0) then
    exit;
  rest := Tinteger.Create;
  ans  := tinteger.Create;
  two  := tinteger.Create;
  e    := tinteger.Create;
  ans.AssignOne;
  two.Assign(2);
  e.Assign(i2);
  hulp := e.Compare(1);
  if hulp >= 0 then
    if hulp = 0 then
    begin
      Modulo(m);
      ans.Assign(self);
    end
    else
    begin
      repeat
        e.DivideRem(two, rest);
        if rest.Compare(1) = 0 then
        begin
          ans.Mult(self);
          //here I went wrong(not altogether, amounts to the same)
          ans.Modulo(m);
        end;
        //mult(self);
        Square;
        Modulo(m);
      until (e.Compare(1) = 0);
      ans.Mult(self);
      //here I went wrong I wrote ans.square and that is somethingdifferent
      ans.Modulo(m);
    end;
  Assign(ans);
  rest.Free;
  ans.Free;
  two.Free;
  e.Free;
end;
 *)


//partially rewritten by hk Oct 2005
procedure Tinteger.ModPow(const i2, m: Tinteger);
{self^I2 modulo m}
var
  ans, e, one: Tinteger;
  hulp: integer;
begin
  {if (length(i2.fdigits) = 0) or (length(m.fdigits) = 0) then
    exit;}
  hulp := i2.CompareZero;
  if hulp <= 0 then
    if hulp = 0 then
    begin
      AssignOne;
      exit;
    end
    else
      exit;
  if m.IsZero then
    exit;
  one := tinteger.Create;
  one.AssignOne;
  ans := tinteger.Create;
  e   := tinteger.Create;
  ans.AssignOne;
  e.Assign(i2);
  hulp := e.Compare(one);
  if hulp >= 0 then
    if hulp = 0 then
    begin
      Modulo(m);
      ans.Assign(self);
    end
    else
    begin
      repeat
        if e.IsOdd then
        begin
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
  ans.Free;
  e.Free;
  one.Free;
end;


{square root}
procedure Tinteger.Sqroot;
begin
  NRoot(2);
end;

{****************** GCD ***************}
procedure Tinteger.Gcd(const I2: tinteger);
 {greatest common divisor}
 {revised by Hans Aug 2005 to handle 0 "I2" value }
 {revised by hk Oct 2005: swapping by hashing}
var
  gcdarr:  array[0..1] of tinteger;
  a, b, h: integer;
begin
  gcdarr[0] := tinteger.Create;
  gcdarr[1] := tinteger.Create;
  if AbsCompare(i2) = 1 then
  begin
    gcdarr[0].Assign(self);
    gcdarr[1].Assign(i2);
  end
  else
  begin
    gcdarr[1].Assign(self);
    gcdarr[0].Assign(i2);
  end;
  if gcdarr[1].CompareZero = 0 then
  begin
    AssignZero;
    gcdarr[0].Free;
    gcdarr[1].Free;
    exit;
  end;
  a := 0;
  b := 1;
  repeat
    gcdarr[a].Modulo(gcdarr[b]);
    if gcdarr[a].CompareZero <> 0 then
    begin
      h := a;
      a := b;
      b := h;
    end;
  until gcdarr[a].CompareZero = 0;
  Assign(gcdarr[b]);
  self.AbsoluteValue;
  gcdarr[a].Free;
  gcdarr[b].Free;
end;


{*************** GCD (Int64) ***********}
procedure Tinteger.Gcd(const I2: int64);
var
  h: tinteger;
begin
  h := tinteger.Create;
  h.Assign(i2);
  Gcd(h);
  h.Free;
end;

{*********** IsOdd *********}
function Tinteger.IsOdd: boolean;
  {Return true if seld is an odd integer}
begin
  //  result:=(fdigits[0] mod 2)=1
  Result := (fDigits[0] and $1) = 1;
end;


 (*rewritten by hk Oct 2005*)
 {************** IsProbablyPrime ***********}
function Tinteger.IsProbablyPrime: boolean;
  //miller rabin probabilistic primetest with 10 random bases;
var
  {i2,i3,i4,}n_1, one: tinteger;
  Base, lastdigit, j, t, under10: integer;
  probableprime: boolean;
  p, work, s, diff, factorlimit: int64;

  function witness(Base: integer; e, n: tinteger): boolean;
  var
    it, h: tinteger;
    i:     integer;
  begin
    it := tinteger.Create;
    h  := tinteger.Create;
    it.Assign(Base);
    it.ModPow(e, n);
    Result := True;
    for i := 1 to t do
    begin
      h.Assign(it);
      h.Square;
      h.Modulo(n);
      if h.Compare(one) = 0 then
        if it.Compare(one) <> 0 then
          if it.Compare(n_1) <> 0 then
            Result := False;
      it.Assign(h);
    end;
    if it.Compare(one) <> 0 then
      Result := False;
    it.Free;
    h.Free;
  end;

  function is_smallprime: boolean;
  var
    j, w, diff: integer;
    prime: boolean;
    i: int64;
  begin
    prime := True;
    ConvertToInt64(i);
    w    := trunc(sqrt(0.0 + i));
    j    := 11;
    diff := 2;
    while prime and (j <= w) do
    begin
      if (i mod j) = 0 then
        prime := False;
      Inc(j, diff);
      if diff = 2 then
        diff := 4
      else
        diff := 2;
    end;
    Result := prime;
  end;

begin
  one := tinteger.Create;
  n_1 := tinteger.Create;
  probableprime := True;
  factorlimit := self.Base;
  if factorlimit > 200 then
    factorlimit := 200;
  if factorlimit = 10 then
    factorlimit := 32;
  {lastdigit := worki2.shiftright mod 10; }
  lastdigit := fDigits[0] mod 10;
  under10 := Compare(10);
  if under10 = -1 then
    if (lastdigit <> 2) and (lastdigit <> 3) and (lastdigit <> 5) and
      (lastdigit <> 7) then
    begin
      probableprime := False;
    end;
  if under10 >= 0 then
  begin
    if (lastdigit <> 1) and (lastdigit <> 3) and (lastdigit <> 7) and
      (lastdigit <> 9) then
      probableprime := False
    else
    begin
      p := 3;
      while probableprime and (p < 8) do
      begin
        worki2.Assign(self);
        worki2.divmodsmall(p, work);
        if work = 0 then
          probableprime := False;
        p := p + 4;
      end;
    end;
  end;
  if probableprime and (under10 > 0) and (Compare(120) = 1) then
    if Compare(1000000) = -1 then
      probableprime := is_smallprime
    else
    begin
      p    := 11;
      diff := 2;
      while probableprime and (p < factorlimit) do
      begin
        worki2.Assign(self);
        worki2.divmodsmall(p, work);
        if work = 0 then
          probableprime := False;
        p := p + diff;
        if diff = 2 then
          diff := 4
        else
          diff := 2;
      end;
      if probableprime then
      begin
        one.AssignOne;
        n_1.Assign(self);
        n_1.Subtract(1);
        t := 0;
        i3.Assign(n_1);
        repeat
          if not (i3.IsOdd) then
          begin
            Inc(t);
            i3.divide2;
          end;
        until i3.IsOdd;
        worki2.Assign(self);
        j := 10;
        if Compare(1000000) > 0 then
          s := 1000000
        else
          worki2.ConvertToInt64(s);
        s := s - 1;
        while (j > 0) and probableprime do
        begin
          repeat
            Base := random(s);
          until Base > 1;
          probableprime := witness(Base, i3, worki2);
          Dec(j);
        end;
        n_1.Free;
        one.Free;
      end;
    end;
  Result := probableprime;
end;


{************ InvMod **********}
procedure Tinteger.InvMod(I2: Tinteger);
{calculates the number n such that n*self=1 mod I2, result in self}
var
  r, q, fn, fv, h, n, m: Tinteger;
begin
  r := tinteger.Create;

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

  q  := tinteger.Create;
  fn := tinteger.Create;
  fv := tinteger.Create;
  h  := tinteger.Create;
  n  := tinteger.Create;
  m  := tinteger.Create;

  n.Assign(self);
  m.Assign(I2);
  r.AssignOne;
  fv.AssignZero;
  fn.AssignOne;
  repeat
    q.Assign(m);
    q.DivideRem(n, r);
    if r.CompareZero <> 0 then
    begin
      m.Assign(n);
      n.Assign(r);
    end;
    h.Assign(fn);
    fn.Mult(q);
    fv.Subtract(fn);
    fn.Assign(fv);
    fv.Assign(h);
  until r.CompareZero = 0;
  h.Add(i2);
  h.Modulo(i2);
  Assign(h);
  r.Free;
  q.Free;
  fn.Free;
  fv.Free;
  h.Free;
  n.Free;
  m.Free;
end;

{************ NRoot **********}
procedure TInteger.NRoot(const root: integer);
var
  Parta, Partb, Partc, Guess: tinteger;
  Limit, Counter, nthroot, a: integer;
  num1, num2: int64;
  str1: string;
begin
  if (root < 2) or (self.Sign <> 1) then
  begin
    AssignZero;
    exit;
  end;
  // if number within range of int64 then compute there
  if self.ConvertToInt64(num1) = True then
  begin
    num2 := trunc(power(num1, 1 / root));
    if power(num2,root)>num1 then num2:=num2-1;
    if power(num2 + 1, root) <= num1 then
      self.Assign(num2 + 1)
    else
      self.Assign(num2);
    exit;
  end;

  Limit   := length(self.fDigits) * GetBasePower * 3 + 700;
  Counter := 0;
  nthroot := root - 1;
  PartA   := tinteger.Create;
  parta.Assign(2);
  parta.Pow(root);
  if Compare(parta) < 0 then
  begin
    AssignOne;
    parta.Free;
    exit;
  end;
  PartB := tinteger.Create;
  PartC := tinteger.Create;
  Guess := Tinteger.Create;
  //initial guess
  a     := high(self.fDigits) * GetBasePower div root - 1;
  if a = 0 then
    str1 := '2'
  else
    str1 := '1';
  str1 := str1 + stringofchar('0', a);
  guess.Assign(str1);
  parta.Assign(guess);
  parta.Pow(root);
  while self.Compare(parta) > 0 do
  begin
    guess.Mult(10);
    parta.Assign(guess);
    parta.Pow(root);
  end;
  parta.Assign(guess);
  PARTA.Divide(10);
  parta.Pow(root);
  while self.Compare(parta) <= 0 do
  begin
    guess.Divide(10);
    parta.Assign(guess);
    PARTA.Divide(10);
    parta.Pow(root);
  end;
  // start of newton
  repeat
    Inc(Counter);
    parta.Assign(guess);
    parta.Mult(nthroot);
    partb.Assign(self);
    Partc.Assign(guess);
    partc.Pow(nthroot);
    partb.Divide(partc);
    parta.Add(partb);
    parta.Divide(root);
    partc.Assign(guess);  //old guess
    partb.Assign(guess);
    partb.Subtract(1);
    guess.Assign(parta); //new guess
  until (Counter > 4) and ((Counter > Limit) or (partc.Compare(guess) = 0) or
      (partb.Compare(guess) = 0));
  if Counter > Limit then
    self.AssignZero
  else
  begin
    if partc.Compare(guess) = 0 then
      self.Assign(guess)
    else
    begin
      // assign smallest value to part c;
      if partc.Compare(guess) > 0 then
        partb.Assign(guess)
      else
        partb.Assign(partc);
      // ensure not too big
      partc.Assign(partb);
      partc.Pow(root);
      while (self.Compare(partc) < 0) and (Counter < (limit + 50)) do
      begin
        partb.Subtract(1);
        partc.Assign(partb);
        partc.Pow(root);
        Inc(Counter);
      end;
      // ensure not too small
      partc.Assign(partb);
      partc.Add(1);
      partc.Pow(root);
      while (self.Compare(partc) >= 0) and (Counter < (limit + 50)) do
      begin
        partb.Add(1);
        partc.Assign(partb);
        partc.Add(1);
        partc.Pow(root);
        Inc(Counter);
      end;
      if Counter < (limit + 50) then
        self.Assign(partb)
      else
        self.AssignZero;
    end;
  end;
  PartA.Free;
  PartB.Free;
  PartC.Free;
  Guess.Free;
end;

function TInteger.GetBase: integer;
begin
  Result := Base;
end;

function TInteger.IsZero: boolean;
begin
  Result := self.Digits[high(self.Digits)] = 0;
end;

procedure TInteger.AssignOne;
begin
  SetLength(fDigits, 1);
  self.Sign := 1;
  self.fDigits[0] := 1;
end;

procedure TInteger.AssignZero;
begin
  SetLength(fDigits, 1);
  self.Sign := 0;
  self.fDigits[0] := 0;
end;

(**** additions by hk Oct 2005***)
procedure TInteger.assignsmall(i2: int64);
begin
  if system.abs(i2) >= Base then
    Assign(i2)
  else if i2 = 0 then
    AssignZero
  else
  begin
    if i2 < 0 then
    begin
      self.Sign := -1;
      i2 := -i2;
    end
    else
      self.Sign := +1;
    SetLength(self.fDigits, 1);
    self.fDigits[0] := i2;
  end;
end;

procedure TInteger.divide2;
var
  i: integer;
begin
  for i := high(fDigits) downto 1 do
  begin
    if (fDigits[i] and 1) = 1 then
      Inc(fDigits[i - 1], Base);
    fDigits[i] := fDigits[i] shr 1;
  end;
  fDigits[0] := fDigits[0] shr 1;
  Trim;
end;

procedure TInteger.divmodsmall(d: int64; var rem: int64);
var
  i, dsign: integer;
  k, n, nn: int64;
  dh, remh: tinteger;
begin
  if (d = 0) or (d = 1) then
  begin
    rem := 0;
    exit;
  end;
  if d = 2 then
  begin
    rem := (fDigits[0] and 1);
    divide2;
    exit;
  end;
  if system.abs(d) >= self.Base then
  begin
    dh   := tinteger.Create;
    remh := tinteger.Create;
    dh.Assign(d);
    remh.Assign(rem);
    DivideRem(dh, remh);
    remh.ConvertToInt64(rem);
    dh.Free;
    remh.Free;
  end
  else
  begin
    if d < 0 then
    begin
      dsign := -1;
      d     := -d;
    end
    else
      dsign := 1;
    for i := high(fDigits) downto 1 do
    begin
      n  := fDigits[i];
      nn := n div d;
      k  := n - nn * d;
      fDigits[i] := nn;
      if k > 0 then
        fDigits[i - 1] := fDigits[i - 1] + k * Base;
    end;
    n   := fDigits[0];
    nn  := n div d;
    rem := n - nn * d;
    fDigits[0] := nn;
    self.Sign := self.Sign * dsign;
    if self.Sign < 0 then
      rem := -rem;
    Trim;
  end;
end;

procedure TInteger.ShiftLeftBase10(num: integer);
var
  b, i, len, len1, bb, Top, digs, add1, Mul: integer;
  Last, Carry, Sum, Mul1: int64;
begin
  bb  := self.Base;
  Top := high(fDigits);
  if Top < 0 then
  begin
    AssignZero;
    exit;
  end;
  last := fDigits[Top];
  if (num > 0) and (Last > 0) then
  begin
    b    := GetBasePower;
    len  := (num - 1) div b;
    len1 := (num) div b;
    shiftleftNum(len1);
    if len = len1 then
    begin
      Digs := 1 + system.trunc(Math.log10(Last));
      Mul  := num - b * len;  //1,2 for b=3
      case Mul of
        0: Mul1 := 1;
        1: Mul1 := 10;
        2: Mul1 := 100;
        3: Mul1 := 1000;
        4: Mul1 := 10000;
        5: Mul1 := 100000;
        6: Mul1 := 1000000;
        7: Mul1 := 10000000;
        8: Mul1 := 100000000;
        else
          Mul1 := system.trunc(Math.intpower(10, Mul));
      end;
      Add1 := (digs + mul - 1) div b;
      if add1 > 0 then
        SetLength(fDigits, Top + Len + 2);
      Carry := 0;
      for i := len1 to high(fDigits) do
      begin
        Sum   := fDigits[i] * Mul1 + Carry;
        Carry := Sum div bb;
        fDigits[i] := sum - bb * Carry;
      end;
    end;
  end;
end;

procedure TInteger.ShiftRightBase10(num: integer);
var
  b, len, len1, Top, digs, Mul: integer;
  Last: int64;
begin
  b   := GetBasePower;
  Top := High(fDigits);
  if Num > ((Top + 1) * b) then
    self.AssignZero
  else
  begin
    Last := fDigits[Top];
    if (num > 0) and (last > 0) then
    begin
      len  := (num - 1) div b;
      len1 := (num) div b;
      if len <> len1 then
        self.ShiftRightNum(len1)
      else
      begin //len1=len2
        digs := num div b;
        mul  := num - digs * b;
        shiftleftbase10(b - mul);
        shiftrightNum(len1 + 1);
      end;
    end;
  end;
end;

procedure TInteger.AbsoluteValue;
begin
  if self.Sign < 0 then
    self.Sign := 1;
end;

{***************** FastMult ***************}
procedure TInteger.FastMult(const I2: TInteger);
(*
    This version is based on "fast Karatsuba multiplication", 21 Jan 1999, Carl Burch, cburch@cmu.edu
    Converted to Delphi by Charles Doumar
*)

const
  MaxArraySize = $7fffffff;
  MaxInt64ArrayElements = MaxArraySize div sizeof(int64); type
  TStaticInt64Array = array[0..MaxInt64ArrayElements - 1] of int64;
  PInt64Array = ^TStaticInt64Array;
  Int64Array = array of int64;
var
  HR: THandle;
  PA, PB, PR: PInt64Array;
  Alen, Blen, imin, imax, i, d: integer;

  procedure DoCarry(PR: PInt64Array; const base, d: integer);
  var
    i: integer;
    Carry: int64;
  begin
    Carry := 0;
    for i := 0 to d - 1 do
    begin
      Pr[i] := PR[i] + Carry;
      if Pr[i] < 0 then
        Carry := (Pr[i] + 1) div base - 1
      else
        Carry := PR[i] div base;
      Pr[i] := Pr[i] - Carry * base;
    end;
    if Carry <> 0 then
    begin
      pr[d - 1] := pr[d - 1] + Carry * base;
      ShowMessage('Error in FastMath DoCarry');
    end;
  end;


  procedure GradeSchoolMult(PA, PB, PR: PInt64Array; d: integer); const
  ConstShift = 48;
  var
    str1 : string;
    i, j, k,imax,ALow,BLow: integer;
    Product, carry, n: int64;
  begin
    fillchar(pr[0],sizeof(int64)*2*d,0);
    Alow := d-1;
    BLow := ALow;
    while (Alow > 0) and (PA[ALow] = 0) do
      dec(ALow);
    while (BLow > 0) and (PB[Blow] = 0) do
      dec(BLow);
    for i := 0 to ALow do
    begin
      Carry := 0;
      for j := 0 to BLow do
      begin
        k := i + j;
        Product := Pr[k] + PA[i] * PB[j] + Carry;
        Carry := Product shr ConstShift;
        if Carry = 0 then
          Pr[k] := product
        else begin
          Carry := product div base;
          Pr[k] := product - carry * Base;
        end;
      end;
     Pr[k + 1] :=  Pr[k + 1] + Carry;
    end;
  end;

  procedure Karatsuba(PA, PB, PR: PInt64Array; d: integer);
  var
    AL, AR, BL, BR, ASum, BSum, X1, X2, X3: PInt64Array;
    i, halfd: integer;
  begin
    if d <= 100 then
    begin
      GradeSchoolMult(Pa, Pb, Pr, d);
      exit;
    end;
    halfd := d shr 1;
    AR := @PA[0];
    AL := @PA[halfd];
    BR := @PB[0];
    BL := @PB[halfd];
    ASum := @PR[d * 5];
    BSum := @PR[d * 5 + halfd];
    X1 := @PR[0];
    X2 := @PR[d];
    X3 := @PR[d * 2];
    for i := 0 to halfd - 1 do
    begin
      asum[i] := al[i] + ar[i];
      bsum[i] := bl[i] + br[i];
    end;
    Karatsuba(AR, Br, X1, halfd);
    Karatsuba(AL, BL, X2, halfd);
    Karatsuba(ASum, BSum, X3, halfd);
    for i := 0 to d - 1 do
      X3[i] := X3[i] - X1[i] - X2[i];
    for i := 0 to d - 1 do
      PR[i + halfd] := PR[i + halfd] + X3[i];
  end;

begin
  Alen := length(self.fDigits);
  BLen := Length(I2.fDigits);
  iMin := ALen;
  iMax := BLen;
  if ALen > BLen then
  begin
    iMin := BLen;
    iMax := ALen;
  end;
  if (iMin < 80) or (imin < Imax shr 4) then
  begin
    self.Mult(i2);
    exit;
  end;
  d := 1;
  while d < iMax do
    d := d * 2;
  setlength(self.fDigits, d);
  setlength(i2.fDigits,d);
  PA := @self.fdigits[0];
  PB := @i2.fdigits[0];
  HR := GlobalAlloc(GMEM_FIXED, d * 6 * Sizeof(int64));
  PR := GlobalLock(HR);
  FillChar(Pr[0], sizeof(int64) * 6 * d, 0);
  Karatsuba(PA, PB, PR, d);
  DoCarry(Pr, self.Base, d * 2);
  d := 2 * d;
  while (d > 0) and (pr[d - 1] = 0) do
    Dec(d);
  setlength(self.fDigits, d);
  setlength(i2.fDigits, BLen);
  move(pr[0], self.fdigits[0], d * sizeof(int64));
  self.Trim;
  self.Sign := self.Sign * i2.Sign;
  GlobalUnlock(HR);
  GlobalFree(HR);
end;

{*************** FastSquare **************}
procedure TInteger.FastSquare;
(*
    This version is based on "fast Karatsuba multiplication", 21 Jan 1999, Carl Burch, cburch@cmu.edu
    Converted to Delphi by Charles Doumar
*)

const
  MaxArraySize = $7fffffff;
  MaxInt64ArrayElements = MaxArraySize div sizeof(int64); type
  TStaticInt64Array = array[0..MaxInt64ArrayElements - 1] of int64;
  PInt64Array = ^TStaticInt64Array;
  Int64Array = array of int64;
var
  HR: THandle;
  PA, PR: PInt64Array;
  Alen, i, d, dmemory: integer;

  procedure DoCarry(PR: PInt64Array; const base, d: integer);
  var
    i: integer;
    c: int64;
  begin
    c := 0;
    for i := 0 to d - 1 do
    begin
      Pr[i] := PR[i] + c;
      if Pr[i] < 0 then
        c := (Pr[i] + 1) div base - 1
      else
        c := PR[i] div base;
      Pr[i] := Pr[i] - c * base;
    end;
    if c <> 0 then
    begin
      pr[d - 1] := pr[d - 1] + c * base;
      ShowMessage('Error in FastSquare DoCarry');
    end;
  end;

  procedure HighSchoolSquare(PA, PR: PInt64Array; d: integer); const
  ConstShift = 48;
  var
    str1 : string;
    i, j, k,imax,ALow: integer;
    Product, carry, n: int64;
  begin
    fillchar(pr[0],sizeof(int64)*2*d,0);
    Alow := d-1;
    while (Alow > 0) and (PA[ALow] = 0) do
      dec(ALow);
    // Step 1. Calculate diagonal
    for i := 0 to ALow do
    begin
      k := i * 2;
      Product := PA[i] * PA[i];
      Carry := Product shr ConstShift;
      if Carry = 0 then
        PR[k] := product
      else begin
        Carry := product div base;
        PR[k] := Product - Carry * base;
        PR[k+1] := Carry;
      end;
    end;
    // Step 2. Calculate repeating part
    For i := 0 to ALow do
    begin
      Carry := 0;
      for j := i+1 to ALow do
      begin
        k := i + j;
        Product := Pr[k] + PA[i] * PA[j] * 2 + Carry;
        Carry := Product shr ConstShift;
        if Carry = 0 then
          Pr[k] := product
        else begin
          Carry := product div base;
          Pr[k] := product - carry * Base;
        end;
      end;
     Pr[k + 1] :=  Pr[k + 1] + Carry;
    end;
  end;

  procedure KaratsubaSquare(PA, PR: PInt64Array; d: integer);
  var
    AL, AR, ASum, X1, X2, X3: PInt64Array;
    i, halfd: integer;
  begin
    if d <= 100 then
    begin
      HighSchoolSquare(Pa, Pr, d);
      exit;
    end;
    halfd := d shr 1;
    AR := @PA[0];
    AL := @PA[halfd];
    ASum := @PR[d * 5];
    X1 := @PR[0];
    X2 := @PR[d];
    X3 := @PR[d * 2];
    for i := 0 to halfd - 1 do
      asum[i] := al[i] + ar[i];
    KaratsubaSquare(AR, X1, halfd);
    KaratsubaSquare(AL, X2, halfd);
    KaratsubaSquare(ASum, X3, halfd);
    for i := 0 to d - 1 do
      X3[i] := X3[i] - X1[i] - X2[i];
    for i := 0 to d - 1 do
      PR[i + halfd] := PR[i + halfd] + X3[i];
  end;

begin
  Alen := length(self.fDigits);
  i := Alen;
  d := 1;
  while d < i do
    d := d * 2;
  setlength(self.fDigits, d);
  PA := @self.fdigits[0];
  dmemory := (d shr 1) * 11 * Sizeof(int64);
  HR := GlobalAlloc(GMEM_FIXED, dmemory);
  PR := GlobalLock(HR);
  FillChar(Pr[0], dmemory, 0);
  KaratsubaSquare(PA, PR, d);
  DoCarry(Pr, self.Base, d * 2);
  d := 2 * d;
  while (d > 0) and (pr[d - 1] = 0) do
    Dec(d);
  setlength(self.fDigits, d);
  move(pr[0], self.fdigits[0], d * sizeof(int64));
  self.Trim;
  self.Sign := self.Sign * self.Sign;
  GlobalUnlock(HR);
  GlobalFree(HR);
end;





initialization
  SetbaseVal(100000);
  randomize;

finalization

  worki2.Free;
  imult1.Free;
  imult2.Free;
  isub3.Free;
  iadd3.Free;
  idiv2.Free;
  idivd2.free;
  idiv3.Free;
  idivd3.Free;
  idiv4.Free;
  icomp3.Free;
  imod3.Free;
  d.Free;
  dq.Free;
  i3.Free;
  i4.Free;
end.
