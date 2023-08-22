unit ubigFloatV3;

//{$Mode Delphi}
 {Copyright  © 2003-2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Defines TBigFloat - a class defining arbitrarily large floating point numbers
 and arithmetic functions}

interface

uses
  Dialogs,
  Forms,
  SysUtils,
  UBigIntsForFloatV4, {Version of UBigInts to use the "class" version regardless
                       of compiler version}
  Windows;

type
  TMaxSig=integer;
  TView     = (normal, Scientific);
  TFloatInt = class(TInteger)
     protected
       procedure ShiftLeftBase10(num: integer);
       procedure ShiftRightBase10(num: integer);
       procedure ShiftLeftNum(num: integer);
       procedure ShiftRightNum(num: integer);
  end;

  TBigFloat = class(TObject)
    {Numbers are converted internally to a decimal number between -1 and +1
    and a power of 10 required to reproduce the original value. (.xxxxxx * 10^exponent).
     xxxxxx is a TFloatInt type, arbitrarily large integer descendant of TInteger. }
  protected
    procedure CheckLogPlaces(const MaxSig: TMaxSig);
    procedure CheckPiPlaces(const MaxSig: TMaxSig);
    procedure LogBasicIteration(const MaxSig: TMaxSig);
    procedure LogSolveCubic(const MaxSig: TMaxSig);
    procedure LogNear1(const MaxSig: TMaxSig);
    procedure calculate_PI_AGM(const MaxSig: TMaxSig);
    procedure expRaw(const MaxSig: TMaxSig);
    procedure R_Function(aa, bb: TBigFloat; const MaxSig: TMaxSig);
    procedure Split(var ldp, rdp: integer);
    function GetDigitatX(const x: word): integer;
    procedure MoveBaseLeft(const n: integer);
    procedure MoveBaseRight(const n: integer);
    function GetBasePower: integer;
    function GetTopPower(const n: int64): integer;
    function GetTopPower2(const n: int64): integer;
    procedure Compact;
    procedure Add1up;
    procedure AssignHalf;
    procedure AssignTwo;
    procedure AssignThree;
    procedure SquareRaw;
    function GetNumber(s: string): boolean;
    function ShowNumber(const View: TView): string;
    procedure AssignFour;

  public
    decpart:   TFloatInt;
    sigdigits: word;   {how many significant digits too show}
    exponent:  integer;   {restrict exponents to integers}
    {create and destroy}
    constructor Create; overload;
    constructor Create(const MaxSig: TMaxSig); overload;
    destructor Destroy; override;
    {}


    {assign}
    procedure Assign(A: TBigFloat); overload;
    procedure Assign(A: TBigFloat; SigDig: word); overload;
    procedure Assign(A: TInteger); overload;
    procedure Assign(N: int64); overload;
    procedure Assign(N: int64; SigDig: integer); overload;
    procedure Assign(d: extended); overload;
    procedure Assign(S: string); overload;
    procedure Assign(S: string; SigDig: word); overload;

    {assign fixed values}
    procedure AssignZero;
    procedure AssignOne;


    {add, subtract, multiply, divide and square}
    procedure Add(B: TBigFloat); overload;
    procedure Add(B: int64); overload;
    procedure AbsAdd(B: TBigFloat);
    procedure Subtract(B: TBigFloat); overload;
    procedure Subtract(B: int64); overload;
    procedure Mult(B: TBigFloat); overload;
    procedure Mult(B: TBigfloat; const MaxSig: TMaxSig); overload;
    procedure Mult(B: TInteger); overload;
    procedure Mult(B: int64); overload;
    procedure MultRaw(B: TBigFloat);
    procedure Reciprocal(const MaxSig: TMaxSig);
    procedure Divide(B: TBigFloat; const MaxSig: TMaxSig); overload;
    procedure Divide(B: TInteger; const MaxSig: TMaxSig); overload;
    procedure Divide(B: int64; const MaxSig: TMaxSig); overload;
    procedure Square(const MaxSig: TMaxSig);


    {Compare, iszero, max and min}
    function Compare(B: TBigFloat): integer;
    function IsZero: boolean;
    procedure MaxBigFloat(B: TBigFloat);
    procedure MinBigFloat(B: TBigFloat);

    {Sqroot, Nroot, Intpower and Power}
    procedure Sqrt; overload;
    procedure Sqrt(const MaxSig: TMaxSig); overload;
    procedure NRoot(N: integer; const MaxSig: TMaxSig);
    procedure IntPower(intpower: integer; const MaxSig: TMaxSig);
    procedure Power(power: TBigfloat; const MaxSig: TMaxSig);

    {Log, Log10 and Exp}
    procedure Log(const MaxSig: TMaxSig);
    procedure Log10(const MaxSig: TMaxSig);
    procedure Exp(const MaxSig: TMaxSig);

    {Constants - Pi and Log2}
    procedure PiConst(const MaxSig: TMaxSig);
    procedure Log2Const(const MaxSig: TMaxSig);

    {RoundToPrec, Trunc, Floor, Ceiling}
    procedure RoundToPrec(const MaxSig: TMaxSig); overload;
    procedure RoundToPrec; overload;

    procedure Trunc(const x: integer = 0);
    procedure Floor(const x: integer = 0);
    procedure Ceiling(const x: integer = 0);
    procedure Round(const x:integer  = 0); overload;


    {Change sign of number}
    procedure AbsoluteValue;
    procedure Negate;

    {Conversions}
    procedure SetSigDigits(const newsigdigits: integer);

    function ConvertToString(const View: TView): string;
    function ConvertToExtended(var num: extended): boolean;
    function ConvertToInt64(var N: int64): boolean;
    function IntPart: int64;
  end;


implementation

uses
  Math;

var
  zlog2, zlog10, zLog10R, zPi: tBigfloat;

{__________TFloatInt procedures _________________}


{************* ShiftRightNum ************}
procedure TFloatInt.ShiftRightNum(num: integer);
{Divide value by base^Num and return the remainder}
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


{************** ShiftLeftNum ***********}
procedure TFloatInt.ShiftLeftNum(num: integer);
{Multiply value by base^num}
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


procedure TFloatInt.ShiftLeftBase10(num: integer);
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

procedure TFloatInt.ShiftRightBase10(num: integer);
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


{************* Create ***********}
constructor TBigFloat.Create;
begin
  inherited;
  sigdigits := 16; {default significant digits}
  decpart   := TFloatInt.Create;  {Tinteger version of digits in the number}
  exponent  := 0;
end;

{************* Create ***********}
constructor TBigFloat.Create(const MaxSig: TMaxSig);
begin
  inherited Create;
  self.sigdigits := MaxSig;
  decpart  := TFloatInt.Create;  {Tinteger version of digits in the number}
  exponent := 0;
end;


{************* Create ***********}
procedure TBigFloat.SetSigdigits(const newSigdigits: integer);
{change the max number of digits to display}
begin
  sigdigits := newsigdigits;
end;

{************* Destroy **************}
destructor TBigFloat.Destroy;
begin
  decpart.Free;
  inherited Destroy;
end;

{***************** GetNumber ***************}
function TBigFloat.GetNumber(s: string): boolean;
  {Convert a string representation of a floating point number into internal format}
var
  i:      integer;
  decimalfound: boolean;
  eFound: boolean;
  nStr, expStr: string;
  error:  string;
  Sign:   integer;
begin
  // fixme
  exponent := 0;
  decimalfound := False;
  efound := False;
  NStr   := '';
  ExpStr := '';
  error  := '';
  Result := True;
  Sign   := +1;
  //s      := Trim(s); {remove leading  & trailing blanks}
  s:=stringreplace(s,' ','',[rfreplaceall]); {remove all blanks}
  for i := 1 to length(s) do
  begin
    case s[i] of
      '0'..'9': if not efound then
        begin
          nstr := nstr+s[i];
          if decimalfound then
            Dec(exponent);
        end
        else
          expstr := expstr+s[i];
      '+', '-': if (i = 1) or ((i>1) and (upcase(s[i-1]) = 'E')) then
        begin
          if (i = 1) and (s[i] = '-') then
            Sign := -1 {nstr:='-'}
          else if (i>1) and (s[i] = '-') and (upcase(s[i-1]) = 'E') then
            expstr := '-';
        end
        else
          error := 'Misplaced + or - sign';
      'e', 'E': eFound := True;
      else
      begin
       (* {$IF compilerversion>15}
        if s[i]=sysutils.formatsettings.decimalseparator then decimalfound:=true
        else if s[i]=formatsettings.thousandseparator then s[i]:=' '
        {$Else}*)
        if s[i]=decimalseparator then decimalfound:=true
        else if s[i]=thousandseparator then s[i]:=' '
        //{$IFEND}
        else error := 'Invalid character in number';
      end;
    end;
    if error<>'' then
    begin
      ShowMessage(error);
      Result := False;
      break;
    end;
  end;
  {convert nStr bigInt and expStr to integer}
  if length(expstr)>0 then
    exponent := exponent+StrToInt(expstr);
  while (length(nstr)>0) and (nstr[1] = '0') do
    Delete(nstr, 1, 1);
  exponent := exponent+length(nstr);
  if Sign<0 then
    nstr := '-'+nstr;
  decpart.Assign(nstr);
end;

{****************** ShowNumber **********}
function TBigFloat.ShowNumber(const view: TView): string;
  {Build a string representation of the number in Normal or Scientific format}
var
  s, ss:   string;
  i, j, n: integer;
  asign:   integer;
begin
  asign := self.decpart.Sign;
  if (self.decpart.Sign = -1) then
  begin
    self.decpart.Sign := 1;
    s := decpart.ConvertToDecimalString(False);
    self.decpart.Sign := -1;
  end
  else
    s := decpart.ConvertToDecimalString(False);
  if view = scientific then
  begin
    if length(s)>sigdigits
    then Delete(s, sigdigits+2, length(s)-sigdigits-1);
    if asign<0 then Result := '-'
    else if asign = 0 then
    begin
      {$IF compilerversion <=15}
            Result := '0'+decimalseparator+'0 E 0';
      {$ELSE}
             Result := '0'+decimalseparator+'0 E 0';
      {$IFEND}
      exit;
    end
    else  Result := '';
    Result := Result+s[1];
    Delete(s, 1, 1);
    if length(s) = 0 then s := '0';
    {$IF compilerversion <=15 }
    Result := Result+decimalseparator+s;
    n := pos(decimalseparator, Result);
    {$ELSE}
    Result := Result+decimalseparator+s;
    n := pos(decimalseparator, Result);
    {$IFEND}
    i := length(Result);
    if (n>0) and (i>n+1) and (Result[i] = '0') then
    begin
      while (Result[i] = '0') and (i>n+1) do Dec(i);
      SetLength(Result, i);
      //      while (length(Result) > N + 1) and (Result[length(Result)] = '0') do
      //      begin
      //        Delete(Result, length(Result), 1)
      //      end
    end;
    Result := Result+' E '+IntToStr(exponent-1);
  end
  else
  begin {normal}
    if length(s)>sigdigits then
      Delete(s, sigdigits+1, length(s));
    if max(length(s), abs(exponent))>sigdigits then
      Result := '****'
    else
    begin
      if asign<0 then
        ss := '-'
      else
        ss := '';
      if exponent>0 then
      begin
        if exponent<length(s) then
        {$IF compilerversion<=15}}
          insert(decimalseparator, s, exponent+1)
        {$ELSE}
         insert(decimalseparator, s, exponent+1)
         {$IFEND}
        else
        begin
          i := length(s);
          if i<exponent then
          begin
            SetLength(s, exponent);
            for j := i+1 to exponent do
              s[j] := '0';
          end;
          //          while length(s) < exponent do
          //          begin
          //            s := s + '0'
          //          end
        end;
      end
      else
      begin

        {$IF compilerversion<=15}
        for i := 1 to -exponent do
          s := '0'+s;
        s := '0'+decimalseparator+s;
      end;
      Result := ss+s;
      n      := pos(decimalseparator, Result);
      {$ELSE}
       for i := 1 to -exponent do
          s := '0'+s;
        s := '0'+decimalseparator+s;
      end;
      Result := ss+s;
      n      := pos(decimalseparator, Result);
      {$IFEND}
      if n>0 then
        while (length(Result)>n+1) and  (Result[length(Result)] = '0') do
          Delete(Result, length(Result), 1);
    end;
  end;
end;


{******************* ConvertToString ****************}
function TBigFloat.ConvertToString(const view: tview): string;
begin
  result:=shownumber(view);
  (*
  asign := self.decpart.Sign;
  if (asign = -1) then
  begin
    self.decpart.Sign := 1;
    s := decpart.ConvertToDecimalString(False);
    self.decpart.Sign := -1;
  end
  else if asign = 1 then
    s := decpart.ConvertToDecimalString(False)
  else
  begin
    Result := '0'+decimalseparator +'0 E 0';
    exit;
  end;
  len1 := length(s);
  if len1>self.sigdigits then
  begin
    Delete(s, self.sigdigits, len1);
    //len1 := self.sigdigits;
  end;
  if asign<0 then
  begin
    Result    := '- '+s+' E '+IntToStr(self.exponent-1);
    Result[2] := Result[3];
    Result[3] := DecimalSeparator;
  end
  else
  begin
    Result    := ' '+s+' E '+IntToStr(self.exponent-1);
    Result[1] := Result[2];
    Result[2] := decimalseparator;
  end;
  *)
end;

{******************* Assign ****************}
procedure TBigFloat.Assign(A: TBigFloat);
{assign "A" to "self"}
begin
  decpart.Assign(a.decpart);
  sigdigits := a.sigdigits;
  exponent  := a.exponent;
end;

procedure TBigFloat.Assign(A: TBigFloat; SigDig: word);
{assign "A" to "self"}
begin
  decpart.Assign(a.decpart);
  exponent  := a.exponent;
  sigdigits := SigDig;
end;


{******************* Assign ****************}
procedure TBigFloat.Assign(A: TInteger);
{assign "A" to "self"}
begin
  decpart.Assign(a);
  sigdigits := a.DigitCount;
  exponent  := self.sigdigits;
end;

{******************* Assign ****************}
procedure TBigFloat.Assign(N: int64);
{assign "A" to "self"}
begin
  self.decpart.Assign(N);
  exponent := self.decpart.DigitCount;
end;

{******************* Assign ****************}
procedure TBigFloat.Assign(N: int64; SigDig: integer);
{assign "A" to "self"}
begin
  self.decpart.Assign(N);
  sigdigits := SigDig;
  exponent  := self.decpart.DigitCount;
end;

{******************* Assign ****************}
procedure TBigFloat.Assign(d: extended);
var
  str: string;
begin
  str := floattostrf(d, ffexponent, 20, 0);
  getnumber(str);
end;

{******************* Assign ****************}
procedure TBigFloat.Assign(s: string);
begin
  getnumber(s);
end;

{******************* Assign ****************}
procedure TBigFloat.Assign(S: string; SigDig: word);
begin
  getnumber(s);
  self.sigdigits := SigDig;
end;


{********************* Split *******************}
procedure TBigfloat.Split(var ldp, rdp: integer);
{count digits to left and right of implied decimal point}

{ Examples:
  .12345 E -2 = .0012345;   Ldp:=0, Rdp=7
  .12345 E 2  = 12.345;     Ldp=2, Rdp=3
  .12345 E 8  = 12345000.   LDp=8, Rdp=0
 }
begin
  if exponent>=0 then
  begin
    ldp := exponent;
    rdp := decpart.DigitCount-ldp;
  end
  else
  begin
    rdp := decpart.DigitCount-exponent;
    ldp := 0;
  end;
end;


{****************** Add **************}
procedure TBigFloat.Add(B: TBigFloat);
{Replacement Add procedure by Charles Doumar, October 2009}
var
  ldp1, rdp1: integer;
  ldp2, rdp2: integer;
  //  Temp1: TInteger;
begin
  if b.exponent<self.exponent-self.sigdigits then
    exit;
  // fix by charles doumar 10/13/2009
  if self.exponent < b.exponent-b.sigdigits then
  begin
    Self.Assign(b,Self.sigdigits);
    Exit;
  end;
   self.split(ldp1, rdp1);  {count digits left and right of decimal point}
  b.split(ldp2, rdp2);
  {align on "virtual" decimal points by adding extra 0's to the one with
   fewest digits to the right of the decimal point (by multiplying by 10)}
  if rdp1>rdp2 then //for i:=1 to rdp1-rdp2 do  b.decpart.mult(10)
    b.decpart.ShiftLeftBase10(rdp1-rdp2)
  else if rdp2>rdp1 then  //for i:=1 to rdp2-rdp1 do decpart.mult(10);
    self.decpart.ShiftLeftBase10(rdp2-rdp1);
  rdp1 := max(rdp1, rdp2); {The new number of digits to the right of the dec. pt
                         after lining up the dec. pts on the two numbers}
  decpart.Add(b.decpart);  {Now add them!}
  {The new exponent is the new number of points top the left of the decimal
   point, which is total digits minus the number of digits to the right of d.p.}

  exponent := decpart.DigitCount-rdp1;
end;

(*
{****************** Add **************}
procedure TBigFloat.Add(B: TBigFloat);
var
  ldp1, rdp1: integer;
  ldp2, rdp2: integer;
  //  Temp1: TInteger;
begin
  if b.exponent<self.exponent-self.sigdigits then
    exit;
  self.split(ldp1, rdp1);  {count digits left and right of decimal point}
  b.split(ldp2, rdp2);
  {align on "virtual" decimal points by adding extra 0's to the one with
   fewest digits to the right of the decimal point (by multiplying by 10)}
  if rdp1>rdp2 then //for i:=1 to rdp1-rdp2 do  b.decpart.mult(10)
    b.decpart.ShiftLeftBase10(rdp1-rdp2)
  else if rdp2>rdp1 then  //for i:=1 to rdp2-rdp1 do decpart.mult(10);
    self.decpart.ShiftLeftBase10(rdp2-rdp1);
  rdp1 := max(rdp1, rdp2); {The new number of digits to the right of the dec. pt
                         after lining up the dec. pts on the two numbers}
  decpart.Add(b.decpart);  {Now add them!}
  {The new exponent is the new number of points top the left of the decimal
   point, which is total digits minus the number of digits to the right of d.p.}

  exponent := decpart.DigitCount-rdp1;
end;
*)

{************************ Add ****************}
procedure TBigFloat.Add(B: int64);
var
  temp: TBigFloat;
begin
  temp := TBigFloat.Create;
  temp.Assign(B);
  Add(temp);
  temp.Free;
end;


{****************** AbsAdd **************}
procedure TBigFloat.AbsAdd(B: TBigFloat);
var
  s1, s2: integer;
begin
  s1 := decpart.Sign;
  decpart.AbsoluteValue;
  s2 := b.decpart.Sign;
  b.decpart.AbsoluteValue;
  Add(b);
  // fix problem when add 0 + 1...
  if s1 = 0 then
  begin
    if s2 = 0 then
      decpart.Sign := s1
    else
    begin
      decpart.Sign := 1;
    end;
  end
  else
    decpart.Sign := s1;
  b.decpart.Sign := s2;
end;

{*************** Subtract ***************}
procedure TBigFloat.Subtract(B: TBigFloat);
{subtract B by changinging its sign and adding}
begin
  b.Negate;
  Add(b);
  b.Negate;
end;

{*************** Subtract ***************}
procedure TBigFloat.Subtract(B: int64);
{subtract B by changinging its sign and adding}
var
  temp: TBigFloat;
begin
  temp := TBigFloat.Create;
  temp.Assign(B);
  Subtract(temp);
  temp.Free;
end;

{****************** Mult **************}
procedure TBigFloat.Mult(B: TBigfloat);
{multiply two numbers}
var
  n, k: integer;
begin
  {maybe just multiply the two fractional parts and add the exponents?}
  n := decpart.DigitCount+b.decpart.DigitCount;
  decpart.Mult(b.decpart);
  {new exponent is sum of the exponents plus the increase in digit count}
  Inc(exponent, b.exponent+decpart.DigitCount-n);
  {trim the length? keeps the product from growing indefinitely in loops (eq in divide op)  }
  k := decpart.DigitCount-16-GetBasePower;
  if k>(2*self.sigdigits) then
    movebaseRight((k-2*self.sigdigits) div GetBasePower);
end;

{****************** Mult **************}
procedure TBigFloat.Mult(B: TBigfloat; const MaxSig: TMaxSig);
{multiply two numbers}
var
  n: integer;
begin
  {maybe just multiply the two fractional parts and add the exponents?}
  n := decpart.DigitCount+b.decpart.DigitCount;
  if maxsig>sigdigits then sigdigits:=maxsig;
  decpart.Mult(b.decpart);
  {new exponent is sum of the exponents plus the increase in digit count}
  Inc(exponent, b.exponent+decpart.DigitCount-n);
  {trim the length? keeps the product from growing indefinitely in loops (eq in divide op)  }
  self.RoundToPrec(MaxSig);
end;

{************************ Mult ****************}
procedure TBigFloat.Mult(B: TInteger);
var
  FloatB: TBigFloat;
begin
  FloatB := TBigfloat.Create;
  FloatB.Assign(B);
  Mult(FloatB);
  FloatB.Free;
end;

{************************ Mult ****************}
procedure TBigFloat.Mult(B: int64);
var
  FloatB: tbigfloat;
begin
  FloatB := tbigfloat.Create;
  FloatB.Assign(B);
  self.Mult(FloatB);
  FloatB.Free;
end;

{****************** MultRaw **************}
procedure TBigFloat.MultRaw(B: TBigfloat);
{multiply two numbers}
var
  n: integer;
begin
  n := decpart.DigitCount+b.decpart.DigitCount;
  decpart.Mult(b.decpart);
  Inc(exponent, b.exponent+decpart.DigitCount-n);
end;


{****************** Divide **************}
procedure TBigFloat.Divide(B: TInteger; const MaxSig: TMaxSig);
var
  FloatB: TBigFloat;
begin
  floatb := TBigfloat.Create;
  floatb.Assign(b);
  floatb.sigdigits := MaxSig;
  if maxsig>sigdigits then sigdigits:=maxsig;
  Divide(floatb, MaxSig);
  floatb.Free;
end;


{************************ Divide ****************}
procedure TBigFloat.Divide(B: TBigfloat; const MaxSig: TMaxSig);
{divide by b}
var
  MaxBigFloat: TBigFloat;
begin
  if b.decpart.IsZero then
  begin
    ShowMessage('Can''t divide by 0');
    exit;
  end;
  if decpart.IsZero then
    exit;  {0 divided by anything is still 0!}
  self.Sigdigits := MaxSig;
  MaxBigFloat    := TBigFloat.Create;
  maxbigfloat.Assign(b, MaxSig);
  MaxBigFloat.reciprocal(MaxSig);
  self.Mult(maxbigfloat);
  maxbigfloat.Free;
end;

{****************** Divide **************}
procedure TBigFloat.Divide(b: int64; const MaxSig: TMaxSig);
var
  temp1: tbigfloat;
begin
  temp1 := tbigfloat.Create;
  temp1.Assign(b);
  self.Divide(temp1, MaxSig);
  temp1.Free;
end;

{******************* RoundToPrec ****************}
procedure TBigFloat.RoundToPrec(const MaxSig: TMaxSig);
var
  Top, b, TopDigits, left, right, aposL, aposR, amod: integer;
  Last: int64;
  num:  boolean;
begin
  if maxsig>sigdigits then sigdigits:=maxsig;
  Top  := high(self.decpart.fDigits);
  b    := self.decpart.GetBasePower;
  Last := self.decpart.fDigits[Top];
  if Last>9 then
    TopDigits := 1+system.trunc(Math.log10(Last))
  else
    TopDigits := 1;
  Left := Top*b+TopDigits;
  if MaxSig>=Left then
    exit;
  Right := Left-MaxSig;
  aposR := (right-1) div b;
  aposL := (right) div b;
  if aposR = aposL then
  begin
    amod := right-aposR*b;
    case b-amod of
      0: ;
      1: self.decpart.Mult(10);
      2: self.decpart.Mult(100);
      3: self.decpart.Mult(1000);
      4: self.decpart.Mult(10000);
      5: self.decpart.Mult(100000);
      6: self.decpart.Mult(1000000);
      7: self.decpart.Mult(10000000);
      else self.decpart.ShiftLeftBase10(b-amod);
    end;
    Inc(aposL);
  end;
  case b of
    1: num := self.decpart.fDigits[aposL-1]>=5;
    2: num := self.decpart.fDigits[aposL-1]>=50;
    3: num := self.decpart.fDigits[aposL-1]>=500;
    4: num := self.decpart.fDigits[aposL-1]>=5000;
    5: num := self.decpart.fDigits[aposL-1]>=50000;
    6: num := self.decpart.fDigits[aposL-1]>=500000;
    7: num := self.decpart.fDigits[aposL-1]>=5000000;
    8: num := self.decpart.fDigits[aposL-1]>=50000000;
    else num := self.decpart.fDigits[aposL-1]>=(self.decpart.Base shr 1);
  end;
  if num then
  begin
    MoveBaseRight(aposL);
    add1up;
  end
  else
    MoveBaseRight(aposL);
end;


{******************* RoundToPrec ****************}
procedure TBigFloat.RoundToPrec;
{round number to specified nbr of significant digits}
begin
  RoundToPrec(self.sigdigits);
end;


{****************** IntPart **************}
function tbigfloat.IntPart: int64;
var
  s: string;
  n: integer;
begin
  s := shownumber(normal);
  {$IF compilerversion<=15}
  n := pos(decimalseparator, s);
  {$ELSE}
  n := pos(decimalseparator, s);
  {$IFEND}

  if n = 0 then
    n := length(s)+1;
  try
    Result := StrToInt64(copy(s, 1, n-1))
  except
    on E: EconvertError do
      Result := 0;
  end;
end;

{****************** MoveBaseLeft **************}
procedure TBigFloat.MoveBaseLeft(const n: integer);
var
  i, j, len: integer;
begin
  if n>0 then
  begin
    j   := high(self.decpart.Digits);
    len := j+n;
    SetLength(self.decpart.fDigits, len+1);
    for i := j downto 0 do
      self.decpart.Digits[i+n] := self.decpart.Digits[i];
    for i := n-1 downto 0 do
      self.decpart.Digits[i] := 0;
    self.decpart.Trim;
  end
  else if n<0 then
    self.MoveBaseRight(-n);
end;


{****************** MoveBaseRight **************}
procedure TBigFloat.MoveBaseRight(const n: integer);
var
  i, j, Top: integer;
begin
  Top := length(self.decpart.Digits);
  if N>=Top then
  begin
    self.AssignZero;
    exit;
  end
  else if n>0 then
  begin
    j := 0;
    for i := n to high(self.decpart.Digits) do
    begin
      self.decpart.Digits[j] := self.decpart.Digits[i];
      Inc(j);
    end;
    self.decpart.SetDigitLength(j);
  end
  else if n<0 then
    self.MoveBaseLeft(-n);
end;



{****************** Reciprocal **************}
procedure TBigFloat.Reciprocal(const MaxSig: TMaxSig);
{Relacement version b y Charles Doumar October, 2009}
var
  GuessOld, guess, tempN, temp1, temp2: tbigfloat;
  i, {dplaces,} nexp, tolerance: integer;
  d:     extended;
  bflag: boolean;
  //  str:   string;
begin
  if self.decpart.IsZero then
    exit//    showmessage('reciprocal value = 0');
  ;
  GuessOld := tbigfloat.Create(MaxSig);
  guess    := tbigfloat.Create(MaxSig);
  tempN    := tbigfloat.Create(MaxSig);
  temp1    := tbigfloat.Create(MaxSig);
  temp2    := tbigfloat.Create(MaxSig);
  TempN.Assign(self);
  if tempn.sigdigits<MaxSig then
    tempn.SetSigdigits(MaxSig);
  if tempN.decpart.Sign<0 then
    tempN.decpart.Sign := 1;
  nexp := self.exponent;
  tempn.exponent := 0;
  tempN.Trunc(15);
  tempn.ConvertToExtended(d);
  d := 1/d;
  TempN.Assign(self);
  tempn.exponent := 0;
  tempn.SetSigdigits(MaxSig);
  guess.Assign(d);
  guess.setsigdigits(MaxSig);
  tolerance := MaxSig+4;
  bflag     := False;
  GuessOld.AssignOne;
  i := 0;
  //  solve the following iteration X[n+1] = X[n] * ( 2 - N * X[n] )
  while True do
  begin
    temp1.Assign(tempN);
    temp1.Mult(guess);
    temp2.Assigntwo;
    temp2.SetSigdigits(tolerance);
    temp2.Subtract(temp1);
    temp1.Assign(temp2);
    temp1.Mult(guess);
    if bflag = True then
      break;
    guess.Assign(temp1);
    if i<>0 then
    begin
      temp2.Assign(guess);
      temp2.Subtract(GuessOld);
      if (temp2.decpart.IsZero) or (temp2.exponent = 0) then
        bflag := True;
      if ((-4*temp2.exponent)>tolerance) then
        bflag := True;
    end;
    GuessOld.Assign(guess);
    Inc(i);
  end;
  temp1.RoundToPrec;
  temp1.exponent     := temp1.exponent-nexp;
  temp1.decpart.Sign := self.decpart.Sign;
  self.Assign(temp1);
  if maxsig>sigdigits then setsigdigits(maxsig);
  GuessOld.Free;
  guess.Free;
  tempN.Free;
  temp1.Free;
  temp2.Free;
end;

(*
{****************** Reciprocal **************}
{Replaced by above October, 2009}
procedure TBigFloat.Reciprocal(const MaxSig: TMaxSig);
var
  GuessOld, guess, tempN, temp1, temp2: tbigfloat;
  i, {dplaces,} nexp, tolerance: integer;
  d:     extended;
  bflag: boolean;
  //  str:   string;
begin
  if self.decpart.IsZero then
    exit//    showmessage('reciprocal value = 0');
  ;
  GuessOld := tbigfloat.Create(MaxSig);
  guess    := tbigfloat.Create(MaxSig);
  tempN    := tbigfloat.Create(MaxSig);
  temp1    := tbigfloat.Create(MaxSig);
  temp2    := tbigfloat.Create(MaxSig);
  TempN.Assign(self);
  if tempn.sigdigits<MaxSig then
    tempn.SetSigdigits(MaxSig);
  if tempN.decpart.Sign<0 then
    tempN.decpart.Sign := 1;
  nexp := self.exponent;
  tempn.exponent := 0;
  tempn.SetSigdigits(21);
  tempn.ConvertToExtended(d);
  d := 1/d;
  tempn.SetSigdigits(MaxSig);
  guess.Assign(d);
  guess.setsigdigits(MaxSig);
  tolerance := MaxSig+4;
 // dplaces   := MaxSig+16;
  bflag     := False;
  GuessOld.AssignOne;
  i := 0;
  //  solve the following iteration X[n+1] = X[n] * ( 2 - N * X[n] )
  while True do
  begin
    temp1.Assign(tempN);
    temp1.Mult(guess);
    temp2.Assigntwo;
    temp2.SetSigdigits(tolerance);
    temp2.Subtract(temp1);
    temp1.Assign(temp2);
    temp1.Mult(guess);
    if bflag = True then
      break;
    guess.Assign(temp1);
    if i<>0 then
    begin
      temp2.Assign(guess);
      temp2.Subtract(GuessOld);
      if (temp2.decpart.IsZero) or (temp2.exponent = 0) then
        bflag := True;
      if ((-4*temp2.exponent)>tolerance) then
        bflag := True;
    end;
    GuessOld.Assign(guess);
    Inc(i);
  end;
  temp1.RoundToPrec;
  temp1.exponent     := temp1.exponent-nexp;
  temp1.decpart.Sign := self.decpart.Sign;
  self.Assign(temp1);
  if maxsig>sigdigits then setsigdigits(maxsig);
  GuessOld.Free;
  guess.Free;
  tempN.Free;
  temp1.Free;
  temp2.Free;
end;

*)

{****************** Negate **************}
procedure TBigFloat.Negate;
begin
  if self.decpart.Sign<>0 then
    self.decpart.Sign := -self.decpart.Sign;
end;

{****************** AbsoluteValue **************}
procedure TBigFloat.AbsoluteValue;
begin
  if self.decpart.Sign<>0 then
    self.decpart.Sign := 1;
end;

{****************** IntPower **************}
procedure TBigFloat.IntPower(intpower: integer; const MaxSig: TMaxSig);
var
  Temp1: Tbigfloat;
  pow1:  integer;
begin
  Temp1 := Tbigfloat.Create(MaxSig);
  Temp1.Assign(self);
  Temp1.Compact;
  Temp1.SetSigdigits(MaxSig);
  Self.AssignOne;
  self.SetSigdigits(MaxSig);
  if intpower>=0 then
    pow1 := intpower
  else
    pow1 := -intpower;
  while pow1>0 do
  begin
    if (pow1 and $1) = 1 then
      self.multRaw(Temp1);
    pow1 := Pow1 shr 1;
    if pow1>0 then
      temp1.Square(MaxSig+8);//raw;
  end;
  if intpower<0 then
    self.reciprocal(MaxSig);
  temp1.Free;
  self.RoundToPrec(MaxSig);
end;

{****************** Sqrt **************}
procedure TBigFloat.Sqrt(const MaxSig: TMaxSig);
var
  GuessOld, GuessNew, Temp1, Temp2: Tbigfloat;
  ii, nexp, tolerance: integer;
  bflag: boolean;
  d:     extended;
begin
  if self.decpart.Sign<=0 then
    exit;
  GuessOld := Tbigfloat.Create(MaxSig+16);
  GuessNew := Tbigfloat.Create(MaxSig+16);
  Temp1    := Tbigfloat.Create(MaxSig+16);
  Temp2    := Tbigfloat.Create(MaxSig+16);
  self.setsigdigits(MaxSig+16);
  Nexp := self.exponent div 2;
  self.exponent := self.exponent-2*nexp;
  self.ConvertToExtended(d);
  d := 1/Math.power(d, 0.5);
  GuessOld.Assign(d);
  GuessOld.setsigdigits(MaxSig+16);
  tolerance := MaxSig+4;
  bflag := False;
  // solve the following iteration to calculation 1/sqrt(N)
  // x[n+1] := 0.5 * x * ( 3 - N * X^2 )
  ii := 0;
  while True do
  begin
    GuessNew.Assign(GuessOld);
    GuessNew.Square(MaxSig+16);
    GuessNew.Mult(self);
    Temp2.AssignThree;
    Temp2.setsigdigits(MaxSig+16);
    Temp2.Subtract(GuessNew);
    GuessNew.AssignHalf;
    GuessNew.setsigdigits(MaxSig+16);
    GuessNew.Mult(temp2);
    GuessNew.Mult(GuessOld);
    if bflag = True then
      break;
    if ii<>0 then
    begin
      temp1.Assign(GuessNew);
      temp1.Subtract(GuessOld);
      if temp1.decpart.IsZero then
        break;
      if ((-4*temp1.exponent)>tolerance) then
        Bflag := True;
    end; // ii loop
    GuessOld.Assign(guessNew);
    Inc(ii);
  end;
  self.Mult(GuessNew);
  self.exponent := self.exponent+nexp;
  self.SetSigdigits(MaxSig);
  GuessOld.Free;
  Temp1.Free;
  Temp2.Free;
  GuessNew.Free;
end;

{****************** Sqrt **************}
procedure TBigFloat.Sqrt;
begin
  self.Sqrt(self.sigdigits);
end;

{****************** Square **************}
procedure TBigFloat.Square(const MaxSig: TMaxSig);
var
  n, k: integer;
begin
  n := 2*decpart.DigitCount;
  decpart.Square;
  Inc(exponent, exponent+decpart.DigitCount-n);
  if maxsig>sigdigits then sigdigits:=maxsig;
  k := decpart.DigitCount-16-GetBasePower;
  if k>(2*MaxSig) then
    movebaseRight((k-2*MaxSig) div GetBasePower);
end;

{****************** SquareRaw **************}
procedure TBigFloat.SquareRaw;
var
  n: integer;
begin
  n := 2*decpart.DigitCount;
  decpart.Square;
  Inc(exponent, exponent+decpart.DigitCount-n);
end;


{****************** NRoot **************}
procedure TBigFloat.NRoot(N: integer; const MaxSig: TMaxSig);
var
  GuessOld, GuessNew, Temp1, Temp2, Temp3: Tbigfloat;
  NN, ii, nexp, tolerance: integer;
  bflag: boolean;
  d:     extended;
begin
  if (self.decpart.Sign<=0) or (N<2) then
    exit;
  nn    := N-1;
  GuessOld := Tbigfloat.Create(MaxSig+16);
  GuessNew := Tbigfloat.Create(MaxSig+16);
  Temp1 := Tbigfloat.Create(MaxSig+16);
  Temp2 := Tbigfloat.Create(MaxSig+16);
  Temp3 := Tbigfloat.Create(MaxSig+16);
  self.setsigdigits(MaxSig+16);
  Nexp := self.exponent div n;
  self.exponent := self.exponent-n*nexp;
  self.ConvertToExtended(d);
  d := Math.power(d, 1/n);
  GuessOld.Assign(d);
  GuessOld.setsigdigits(MaxSig+16);
  tolerance := MaxSig+4;
  bflag := False;
  // solve the following iteration to calculation 1/sqrt(N)
  // x[n+1] := 1/N * ( (N-1) * X   +  num / X^(N-1) )
  ii := 0;
  Temp3.Assign(N);
  Temp3.SetSigdigits(MaxSig+16);
  Temp3.reciprocal(MaxSig+16);
  while True do
  begin
    GuessNew.Assign(GuessOld);
    GuessNew.IntPower(NN, MaxSig+16);
    GuessNew.reciprocal(MaxSig+16);
    guessNew.Mult(self);
    Temp2.Assign(nn);
    temp2.setsigdigits(MaxSig+16);
    Temp2.Mult(GuessOld);
    GuessNew.Add(Temp2);
    GuessNew.Mult(Temp3);
    if bflag = True then
      break;
    if ii<>0 then
    begin
      temp1.Assign(GuessNew);
      temp1.Subtract(GuessOld);
      if temp1.decpart.IsZero then
        break;
      if ((-4*temp1.exponent)>tolerance) then
        Bflag := True;
    end; // ii loop
    GuessOld.Assign(guessNew);
    Inc(ii);
  end;
  self.Assign(GuessNew);
  self.exponent := self.exponent+nexp;
  self.SetSigdigits(MaxSig);
  GuessOld.Free;
  Temp1.Free;
  Temp2.Free;
  Temp3.Free;
  GuessNew.Free;
end;

{****************** Trunc **************}
procedure TBigFloat.Trunc(const x: integer = 0);
var
  RevExponent, left, right, aposL, aposR, amod, abasepower: integer;
begin
  RevExponent := exponent+x;
  if RevExponent>=0 then
  begin
    Left  := Revexponent;
    Right := decpart.DigitCount-left;
  end
  else
  begin
    Right := decpart.DigitCount-Revexponent;
    Left  := 0;
  end;
  if right<=0 then
    exit;
  if left = 0 then
  begin
    AssignZero;
    exit;
  end;
  abasepower := GetBasePower;
  aposR      := (right-1) div abasepower;
  aposL      := (right) div abasepower;
  if aposR<>aposL then
    MoveBaseRight(aposL)
  else
  begin
    //    amod := (right) mod abasepower;
    amod := right-aposL*abasepower;
    //    self.decpart.ShiftLeftBase10(abasepower-amod);
    case abasepower-amod of
      0: ;
      1: self.decpart.Mult(10);
      2: self.decpart.Mult(100);
      3: self.decpart.Mult(1000);
      4: self.decpart.Mult(10000);
      5: self.decpart.Mult(100000);
      6: self.decpart.Mult(1000000);
      7: self.decpart.Mult(10000000);
      else self.decpart.ShiftLeftBase10(abasepower-amod);
    end;
    MoveBaseRight(aposr+1);
  end;
end;

{****************** Floor **************}
procedure TBigFloat.Floor(const x: integer = 0);
var
  RevExponent, i, iAdd, left, right, aposL, aposR, amod, abasepower: integer;
begin
  RevExponent := exponent+x;
  if RevExponent>=0 then
  begin
    Left  := Revexponent;
    Right := decpart.DigitCount-left;
  end
  else
  begin
    Right := decpart.DigitCount-Revexponent;
    Left  := 0;
  end;
  if right<=0 then
    exit;
  if left = 0 then
  begin
    AssignZero;
    exit;
  end;
  abasepower := GetBasePower;
  aposR      := (right-1) div abasepower;
  aposL      := (right) div abasepower;
  if aposR<>aposL then
  begin
    if self.decpart.Sign>=0 then
      MoveBaseRight(aposL)
    else
    begin
      // need to check to see if any number greater than zero
      iadd := 0;
      for i := aposL-1 downto 0 do
        if self.decpart.fDigits[i]<>0 then
        begin
          iadd := 1;
          break;
        end;
      MoveBaseRight(aposL);
      if iadd = 1 then
        add1up;
    end;
  end
  else
  begin
    amod := (right) mod abasepower;
    case abasepower-amod of
      0: ;
      1: self.decpart.Mult(10);
      2: self.decpart.Mult(100);
      3: self.decpart.Mult(1000);
      4: self.decpart.Mult(10000);
      5: self.decpart.Mult(100000);
      6: self.decpart.Mult(1000000);
      7: self.decpart.Mult(10000000);
      else self.decpart.ShiftLeftBase10(abasepower-amod);
    end;
    // need to check to see if any number greater than zero
    if self.decpart.Sign>=0 then
      MoveBaseRight(aposR+1)
    else
    begin
      iadd := 0;
      for i := aposR downto 0 do
        if self.decpart.fDigits[i]<>0 then
        begin
          iadd := 1;
          break;
        end;
      MoveBaseRight(aposr+1);
      if iadd = 1 then
        add1up;
    end;
  end;
end;

{******************* Ceiling ****************}

procedure TBigfloat.Ceiling(const x :integer = 0);
var
  i, iAdd, RevExponent, left, right, aposL, aposR, amod, abasepower: integer;
  ii: tinteger;
begin
  RevExponent := exponent+x;  {This is the target digit}
  if RevExponent>=0 then
  begin
    Left  := Revexponent;
    Right := decpart.DigitCount-left;
  end
  else
  begin
    Right := decpart.DigitCount-Revexponent;
    Left  := 0;
  end;
  if right<=0 then
    exit;
  if left = 0 then
  begin
    AssignZero;
    exit;
  end;
  abasepower := GetBasePower;
  aposR      := (right-1) div abasepower;
  aposL      := (right) div abasepower;

  if aposR = aposL then
  begin
    amod := right-aposR*abasepower;
    //    self.decpart.ShiftLeftBase10(abasepower-amod);
    case abasepower-amod of
      0: ;
      1: self.decpart.Mult(10);
      2: self.decpart.Mult(100);
      3: self.decpart.Mult(1000);
      4: self.decpart.Mult(10000);
      5: self.decpart.Mult(100000);
      6: self.decpart.Mult(1000000);
      7: self.decpart.Mult(10000000);
      else
      begin
        ii := tinteger.Create;
        ii.Assign(10);
        ii.Pow(abasepower-amod);
        self.decpart.Mult(ii);
        ii.Free;
      end;
    end;
    Inc(aposL);
  end;
  if self.decpart.Sign<=0 then
    MoveBaseRight(aposL)
  else
  begin
    // need to check to see if any number greater than zero
    iadd := 0;
    for i := aposL-1 downto 0 do
      if self.decpart.fDigits[i]<>0 then
      begin
        iadd := 1;
        break;
      end;
    MoveBaseRight(aposL);
    if iadd = 1 then
      add1up;
  end;
end;

(*  {replaced 0/28/12 GDD}
{******************* Round ****************}
procedure TBigFloat.Round(const x: integer);
var
  ToCheck:integer;
  saveSign:integer;
  digitToCheck:char;
  s:string;
  half:TBigFloat;
begin
  if (x>=0) then  roundToPrec(x+exponent)
  else
  begin
    savesign:=decpart.sign;
    if (self.decpart.Sign = -1) then
   begin
     self.decpart.Sign := 1;
     s := decpart.ConvertToDecimalString(False);
     self.decpart.Sign := -1;
   end
   else  s := decpart.ConvertToDecimalString(False);
   ToCheck:=exponent+x+1;
   if tocheck>length(s) then exit; {rounding limit finer than  available digits, no change}
   if tocheck<1 then
    begin   {rounding to too high a multiple power of 10, rounds to 0}
       assignzero;
       exit;
     end;
    digitTocheck:= s[tocheck];
    {Delete the rest of the digits beyond the round off length}
    delete(s,tocheck,length(s)-tocheck+1);
    if length(s)>0 then decpart.assign(s) else decpart.assignzero;

    if digittocheck>='5' then decpart.add(1);
    if not iszero then decpart.sign:=savesign;
  end;

end;
*)

{******************* Round ****************}
procedure TBigFloat.Round(const x: integer);
{rewritten 8/29/12 GDD}

var
  half:TBigFloat;
begin
   {x is places to the right of the decimal point to retain}

  {if number is positive add  (.5* 10^-x)
   otherwise subtract the same value
   then truncate result to x}
  half:=TbigFLoat.create;
  half.assignhalf;
  half.exponent:=half.exponent-x;
  half.decpart.sign:=decpart.sign;
  add(half);
  trunc(x);
  half.free;
end;


{******************* Compare ****************}
function TBigFloat.Compare(B: TBigFloat): integer;
var
  dig1, dig2, top1, top2, imin: integer;
begin
  Result := 0;
  if (self.decpart.Sign>B.decpart.Sign) then
    Result := 1
  else if (self.decpart.Sign<b.decpart.Sign) then
    Result := -1
  //Same Signs
  else if (self.exponent>b.exponent) then
    Result := 1
  else if (self.exponent<b.exponent) then
    Result := -1
  //Same signs and exponents
  else if (self.decpart.Sign = 0) then
    Result := 0
  else // Same Signs check digits need to line up first
  begin
    top1 := high(self.decpart.Digits);
    top2 := high(b.decpart.Digits);
    dig1 := 1+system.trunc(Math.Log10(self.decpart.Digits[top1]));
    dig2 := 1+system.trunc(Math.Log10(b.decpart.Digits[top2]));
    if (dig1>dig2) then  B.decpart.ShiftLeftBase10(dig1-dig2)
    else if (dig2>dig1) then SELF.decpart.ShiftLeftBase10(dig2-dig1);
    // Now there are three possibilities
    if Top1>Top2 then
    begin
      for imin := 0 to Top2 do  //check common parts
        if self.decpart.Digits[top1-imin]<>b.decpart.Digits[top2-imin] then
        begin
          if Self.decpart.Digits[top1-imin]>b.decpart.Digits[top2-imin]
          then  Result := 1
          else Result := -1;
          exit;
        end;
      // any digit in self will mean self > b...
      for imin := Top1-Top2-1 downto 0 do  // check remaining part
        if self.decpart.Digits[imin]<>0 then
        begin
          Result := 1;
          break;
        end;
    end
    else if Top1<Top2 then
    begin
      for imin := 0 to Top1 do
        if self.decpart.Digits[top1-imin]<>b.decpart.Digits[top2-imin] then
        begin
          if Self.decpart.Digits[top1-imin]>b.decpart.Digits[top2-imin]
          then Result := 1
          else Result := -1;
          exit;
        end;
      // any digit in b will mean self < b...
      for imin := Top2-Top1-1 downto 0 do
        if B.decpart.Digits[imin]<>0 then
        begin
          Result := -1;
          break;
        end;
    end
    else //Top1=Top2
      for imin := Top1 downto 0 do
        if self.decpart.Digits[imin]<>b.decpart.Digits[imin] then
        begin
          if Self.decpart.Digits[imin]>b.decpart.Digits[imin]
          then Result := 1
          else Result := -1;
          break;
        end;
  end;
end;


{******************* ConvertToExtended ****************}
function TBigFloat.ConvertToExtended(var num: extended): boolean;
var
  abase:  extended;
  i, Top: integer;
  e, pls: extended;
begin
  Result := False;
  Num    := 0.0;
  if system.abs(self.exponent)>4932 then
  begin
    ShowMessage('ConvertToExtended ERROR: Number too big');
    exit;
  end;
  abase := self.decpart.Base;
  Top   := high(self.decpart.Digits);
  e     := self.decpart.Digits[Top];
  Dec(Top);
  for i := Top downto max(0, Top-20 div GetBasePower-1) do
    e := e*abase+self.decpart.Digits[i];
  if e <> 0
  then pls := Math.Log10(e)
  else pls := 0;

  if pls>=0
  then i := system.trunc(pls)
  else i := system.trunc(pls)-1;
  if self.decpart.Sign>=0
  then  e := e*Math.Power(10, self.exponent-i-1)
  else  e := -e*Math.power(10, self.exponent-i-1);
  num := e;
  Result := True;
end;

(*
{******************* ConvertToExtended ****************}
function TBigFloat.ConvertToExtended(var num: extended): boolean;
var
  abase:  extended;
  i, Top: integer;
  e, pls: extended;
  eArray : array[0..4] of smallint absolute e; begin
  Result := False;
  Num    := 0.0;
  if system.abs(self.exponent)>4932 then
  begin
    ShowMessage('ConvertToExtended ERROR: Number too big');
    exit;
  end;
  abase := self.decpart.Base;
  Top   := high(self.decpart.Digits);
  e     := self.decpart.Digits[Top];
  Dec(Top);
  for i := Top downto max(0, Top-20 div GetBasePower-1) do
    e := e*abase+self.decpart.Digits[i];
//   if (eArray[3] and $7fff - 32767) <> system.trunc(math.log10(e)) then
exit;
  if e <> 0 then
    pls := Math.Log10(e)
  else
    pls := 0;
  if pls>=0 then
    i := system.trunc(pls)
  else
    i := system.trunc(pls)-1;
  if self.decpart.Sign>=0 then
    e := e*Math.Power(10, self.exponent-i-1)
  else
    e := -e*Math.power(10, self.exponent-i-1);
  num := e;
  Result := True;
end;
*)


{******************* ConvertToInt64 ****************}
function TBigFloat.ConvertToInt64(var n: int64): boolean;

var
  e:     extended;
  temp1: TbigFloat;
  Top, abase, i: integer;
begin
  n      := 0;
  Result := False;
  if (self.exponent<0) or (self.exponent>18) or not converttoextended(e) then
    exit;
  if (abs(e)<=9223372036854775806) then
  begin
    Temp1 := Tbigfloat.Create;
    Temp1.Assign(self);
    Temp1.Trunc;
    //    abase := system.trunc(math.intpower(10.0,getbasepower));
    abase := self.decpart.GetBase;
    Top   := high(temp1.decpart.Digits);
    n     := temp1.decpart.Digits[Top];
    Dec(Top);
    for i := Top downto 0 do
      n := n*abase+temp1.decpart.Digits[i];
    if temp1.decpart.Sign = -1 then
      n := -n;
    // fix up int64 if sigdigits < exponent ...
    i := exponent-temp1.decpart.DigitCount;
    if i>0 then
      n := n*system.trunc(Math.intpower(10.0, i));
    Result := True;
    Temp1.free;
  end;
end;

{******************* IsZero ****************}
function TBigFloat.IsZero: boolean;
begin
  Result := (self.decpart.Digits[high(self.decpart.Digits)] = 0);
end;

{******************* MaxBigFloat ****************}
procedure TBigFloat.MaxBigFloat(B: TBigFloat);
begin
  if Compare(b)<0 then
    self.Assign(B);
end;

{******************* MinBigFloat ****************}
procedure TBigFloat.MinBigFloat(B: TBigFloat);
begin
  if Compare(b)>0 then
    self.Assign(B);
end;


{******************* GetBasePower ****************}
function TBigFloat.GetBasePower: integer;
var
  n, nn: int64;
begin
  n      := self.decpart.Base;
  Result := 1;
  nn     := 10;
  while n>nn do
  begin
    Inc(Result);
    nn := nn*10;
  end;
end;

{******************* GetTopPower ****************}
function TBigFloat.GetTopPower(const n: int64): integer;
var
  nn: int64;
begin
  Result := 1;
  nn     := 10;
  while n>=nn do
  begin
    Inc(Result);
    nn := nn*10;
  end;
end;

{******************* MaxBigFloat ****************}
function TBigFloat.GetTopPower2(const n: int64): integer;
begin
  if n>9 then
    Result := 1+system.trunc(Math.Log10(n))
  else
    Result := 1;
end;


{******************* ExpRaw ****************}
procedure TBigFloat.ExpRaw(const MaxSig: TMaxSig);
var
  RTemp, digit, term:      TBigFloat;
  m1, tolerance, LocalSig: integer;
begin
  LocalSig  := MaxSig+8;
  tolerance := -MaxSig-8;
  RTemp     := Tbigfloat.Create(LocalSig);
  Digit     := Tbigfloat.Create(LocalSig);
  Term      := Tbigfloat.Create(LocalSig);
  Term.Assign(self);
  Rtemp.AssignOne;
  Rtemp.Add(self);
  rtemp.SetSigdigits(LocalSig);
  m1 := 2;
  while True do
  begin
    digit.Assign(m1);
    term.Mult(self);
    term.Divide(digit, LocalSig);
    rtemp.Add(term);
    if ((term.exponent<tolerance) or (term.decpart.IsZero)) then
      break;
    Inc(m1);
  end;
  self.Assign(rtemp);
  self.SetSigdigits(MaxSig);
  RTemp.Free;
  digit.Free;
  term.Free;
end;


{******************* R_Function ****************}
procedure TBigFloat.R_Function(aa, bb: TBigFloat; const MaxSig: TMaxSig);
var
  temp1, temp2, temp3, temp4, tempc2, sum, pow_2, tempA0, tempB0, Half, two: TBigfloat;
  tolerance, LocalSig: integer;
begin
  tolerance := MaxSig+8;
  LocalSig := MaxSig+16;
  tempA0 := TBigFloat.Create(LocalSig);
  TempB0 := TBigFloat.Create(LocalSig);
  pow_2 := TBigFloat.Create(LocalSig);
  Temp1 := TBigFloat.Create(LocalSig);
  Temp2 := TBigFloat.Create(LocalSig);
  Temp3 := TBigFloat.Create(LocalSig);
  Temp4 := TBigFloat.Create(LocalSig);
  Tempc2 := TBigFloat.Create(LocalSig);
  sum  := TBigFloat.Create(LocalSig);
  Half := TBigFloat.Create(LocalSig);
  Two  := TBigFloat.Create(LocalSig);
  Two.AssignTwo;
  TempA0.Assign(aa, LocalSig);
  TempB0.Assign(bb, LocalSig);
  Half.AssignHalf;
  Half.SetSigdigits(LocalSig);
  Pow_2.Assignhalf;
  Temp1.Assign(aa, LocalSig);
  temp1.SquareRaw;
  Temp2.Assign(bb, LocalSig);
  Temp2.SquareRaw;
  Temp3.Assign(temp1);
  Temp3.Subtract(temp2);
  Sum.Assign(temp3);
  Sum.MultRaw(half);
  while True do
  begin
    temp1.Assign(tempA0);
    Temp1.Subtract(tempB0);

    Temp4.Assign(temp1);
    temp4.MultRaw(half);

    Tempc2.Assign(temp4);
    tempc2.Square(LocalSig);
    // do the agm
    temp1.Assign(tempa0);
    temp1.Add(tempb0);

    temp3.Assign(temp1);
    temp3.Multraw(half);

    temp2.Assign(tempa0);
    temp2.Multraw(tempb0);

    tempb0.Assign(temp2);
    tempb0.Sqrt(LocalSig);

    tempa0.Assign(temp3);
    tempa0.RoundToPrec;
    // end the agm

    temp2.Assign(pow_2);
    Temp2.Multraw(two);
    pow_2.Assign(temp2);

    Temp1.Assign(tempc2);
    temp1.Mult(pow_2);

    temp3.Assign(sum);
    temp3.Add(temp1);

    if ((temp1.decpart.IsZero) or ((-2*temp1.exponent)>tolerance)) then
      break;
    sum.Assign(temp3);
    sum.RoundToPrec;
  end;
  temp4.AssignOne;
  temp4.Subtract(temp3);
  temp4.Reciprocal(LocalSig);
  self.Assign(temp4, MaxSig);
  // free variables...
  tempA0.Free;
  TempB0.Free;
  pow_2.Free;
  Temp1.Free;
  Temp2.Free;
  Temp3.Free;
  Temp4.Free;
  Tempc2.Free;
  sum.Free;
  Half.Free;
  two.Free;
end;

{******************* AssignHalf ****************}
procedure TBigFloat.AssignHalf;
begin
  SetLength(self.decpart.fDigits, 1);
  self.decpart.Sign := 1;
  self.decpart.fDigits[0] := 5;
  self.exponent     := 0;
end;

{******************* AssignOne ****************}
procedure TBigFloat.AssignOne;
begin
  SetLength(self.decpart.fDigits, 1);
  self.decpart.Sign := 1;
  self.decpart.fDigits[0] := 1;
  self.exponent     := 1;
end;

{******************* AssignTwo ****************}
procedure TBigFloat.AssignTwo;
begin
  SetLength(self.decpart.fDigits, 1);
  self.decpart.Sign := 1;
  self.decpart.fDigits[0] := 2;
  self.exponent     := 1;
end;

{******************* AssignThree ****************}
procedure TBigFloat.AssignThree;
begin
  SetLength(self.decpart.fDigits, 1);
  self.decpart.Sign := 1;
  self.decpart.fDigits[0] := 3;
  self.exponent     := 1;
end;

{******************* AssignFour ****************}
procedure TBigFloat.AssignFour;
begin
  SetLength(self.decpart.fDigits, 1);
  self.decpart.Sign := 1;
  self.decpart.fDigits[0] := 4;
  self.exponent     := 1;
end;


{******************* AssignZero ****************}
procedure TBigFloat.AssignZero;
begin
  SetLength(self.decpart.fDigits, 1);
  self.decpart.Sign := 0;
  self.decpart.fDigits[0] := 0;
  self.exponent     := 1;
end;

{******************* Log2Const ****************}
procedure TBigFloat.Log2Const(const MaxSig: TMaxSig);
var
  //Temp1, Temp2, Temp3: Tbigfloat;
  LocalSig {, dplaces}:   integer;
begin
  // See http://numbers.computation.free.fr/constants/log2/log2.html
  LocalSig := MaxSig+4;
  checklogplaces(LocalSig);
  Assign(zlog2, MaxSig);
  self.RoundToPrec(MaxSig);
end;

{******************* Exp ****************}
procedure TBigFloat.Exp(const MaxSig: TMaxSig);
{
Formula based on David H. Bailey's MPFUN Fortran Package
exp = (1 + r + r^2/2! + r^3/3! ...)^q*2^n
q := 512 (Bailey used 256); r = (Number MOD (N * log2)) / q;
This makes sure that r is very small > -0.001 <= 0.001

}
var
  {Temp1, Temp2, Temp3, }Temp7, Temp8, TempLog2R, TempHalf, Tempexp512R: Tbigfloat;
  i, LocalSig: integer;
  n: int64;
begin
  if self.decpart.Sign = 0 then
  begin
    self.AssignOne;
    exit;
  end;
  if self.exponent<=-2 then
  begin
    self.expRaw(MaxSig+6);
    self.sigdigits := MaxSig;
    self.RoundToPrec;
    exit;
  end;
  LocalSig := MaxSig+8;
  checklogplaces(LocalSig);
  TempLog2R := TBigFloat.Create(MaxSig);
//  TempLog2R.assign(zlog2);
//  TempLog2R.Reciprocal(localsig);
  {$IF compilerversion<=15}
  TempLog2R.Assign('1'+decimalseparator+'44269504089', MaxSig);
  Tempexp512R := TBigFloat.Create(MaxSig);
  Tempexp512R.Assign('1'+decimalseparator+'953125e-3', MaxSig);
  {$ELSE}
  TempLog2R.Assign('1'+decimalseparator+'44269504089', MaxSig);
  Tempexp512R := TBigFloat.Create(MaxSig);
  Tempexp512R.Assign('1'+decimalseparator+'953125e-3', MaxSig);
  {$IFEND}


  Temp7 := TBigFloat.Create(localSig);
  Temp8 := TBigFloat.Create(localSig);
  // find value of N
  Temp7.Assign(self);
  Temp7.Mult(TempLog2R);
  TempHalf := TBigFloat.Create;
  TempHalf.AssignHalf;
  // round to highest value
  if temp7.decpart.Sign>0 then
  begin
    Temp7.Add(TempHalf);
    Temp7.Floor();
  end
  else
  begin
    Temp7.Subtract(TempHalf);
    Temp7.Ceiling();
  end;
  // check to make sure that we do not overflow
  if not Temp7.ConvertToInt64(n) or (abs(n)>=maxint) then
  begin
    TempLog2R.Free;
    tempExp512R.Free;
    Temp7.Free;
    Temp8.Free;
    TempHalf.Free;
    ShowMessage('EXP ERROR:  Number too big for TBigFloat!');
    exit;
  end;

  Temp8.Assign(Temp7);
  Temp8.Mult(zlog2);

  Temp7.Assign(self,localsig);
  Temp7.Subtract(Temp8);
  while True do
  begin
    if temp7.decpart.Sign<>0 then
      if temp7.exponent = 0 then
        break;
    if temp7.decpart.Sign>=0 then
    begin
      Inc(n);
      temp7.Subtract(zlog2);
    end
    else
    begin
      Dec(n);
      temp7.Add(zlog2);
    end;
  end;

  Temp7.Mult(Tempexp512R);
  Temp7.expRaw(LocalSig);

  for i := 1 to 9 do
  begin
    Temp7.Square(LocalSig);
    Temp7.RoundToPrec(LocalSig);
  end;

  // compute 2 to n
  Self.AssignTwo;
  Self.IntPower(n, LocalSig);
  Self.Mult(temp7);
  Self.RoundToPrec(MaxSig);
  TempLog2R.Free;
  tempExp512R.Free;
  Temp7.Free;
  Temp8.Free;
  TempHalf.Free;
end;

{******************* CheckLogPlaces ****************}
procedure TBigFloat.CheckLogPlaces(const MaxSig: TMaxSig);
var
  Temp1, Temp2, Temp3: Tbigfloat;
  LocalSig, dplaces:   integer;
begin
  // See http://numbers.computation.free.fr/constants/log2/log2.html
  // log(x) = R(1,10^-N / X) - R(1,10^-10)
  LocalSig := MaxSig+4;
  if LocalSig>zlog2.sigdigits then
  begin
    Temp1   := TBigFloat.Create(LocalSig);
    Temp2   := TBigFloat.Create(LocalSig);
    Temp3   := TBigFloat.Create(LocalSig);
    dplaces := LocalSig+6+system.trunc(Math.Log10(MaxSig));
    // assign values
    Temp1.AssignOne;
    Temp2.AssignOne;
    Temp2.exponent := -MaxSig;
    temp3.R_Function(temp1, temp2, dplaces);
    Temp2.AssignHalf;
    Temp2.exponent := -MaxSig-1;
    zlog2.R_Function(temp1, temp2, dplaces);
    zlog2.Subtract(temp3);
    zlog2.sigdigits := LocalSig;
    Temp2.AssignOne;
    Temp2.exponent := -MaxSig-1;
    zlog10.R_Function(temp1, temp2, dplaces);
    zlog10.Subtract(temp3);
    zlog10R.Assign(zlog10);
    zlog10R.Reciprocal(LocalSig);
    zlog10.sigdigits := localSig;
    Temp1.Free;
    Temp2.Free;
    Temp3.Free;
  end;
end;


{******************* Log ****************}
procedure TBigFloat.Log(const MaxSig: TMaxSig);
var
  Temp0, Temp1:   TBigfloat;
  LocalSig, nexp: integer;
begin
  if self.decpart.Sign<0 then
  begin
    self.AssignZero;
    exit;
  end;
  LocalSig := MaxSig+8;
  nexp     := self.exponent;
  Temp0    := TBigfloat.Create(LocalSig);
  if nexp in [0, 1] then
  begin
    Temp0.AssignOne;
    Temp0.Negate;
    Temp0.Add(self);
    // is number = 1
    if temp0.decpart.Sign = 0 then
    begin
      self.AssignZero;
      temp0.Free;
      exit;
    end;
    if temp0.exponent<=-3 then
    begin
      self.assign(temp0);
      self.LogNear1(MaxSig);
      Temp0.Free;
      exit;
    end;

  end;
  self.CheckLogPlaces(LocalSig+25);
  if nexp<=3 then
    self.LogBasicIteration(MaxSig)
  else
  begin
    self.sigdigits := LocalSig;
    nexp := self.exponent-2;
    self.exponent := 2;
    self.LogBasicIteration(LocalSig);

    Temp1 := TBigfloat.Create(LocalSig);
    Temp1.Assign(nexp, LocalSig);
    Temp1.Mult(zlog10);

    self.Add(temp1);
    self.RoundToPrec(MaxSig);
    Temp1.Free;
  end;

  Temp0.Free;
end;

{******************* Log10 ****************}
procedure TBigFloat.Log10(const MaxSig: TMaxSig);
var
  LocalSig: integer;
begin
  LocalSig := MaxSig+4;
  CheckLogPlaces(LocalSig);
  Self.Log(LocalSig);
  Self.Mult(zLog10R);
  Self.sigdigits := MaxSig;
  Self.RoundToPrec;
end;

{******************* LogBasicIteration ****************}
procedure TBigFloat.LogBasicIteration(const MaxSig: TMaxSig);
var
  Temp0, Temp1, Tempx: Tbigfloat;
begin
  if MaxSig<360 then
    self.LogSolveCubic(MaxSig)
  else
  begin
    Temp0 := Tbigfloat.Create(MaxSig);
    temp1 := TBigFloat.Create(MaxSig);
    Tempx := Tbigfloat.Create(MaxSig);
    tempx.Assign(self, MaxSig);
    tempx.LogSolveCubic(110);

    temp0.Assign(tempx, MaxSig+8);
    Temp0.Negate;
    temp0.Exp(MaxSig+8);
    temp0.Mult(self, MaxSig+8);
    temp1.AssignOne;
    temp1.Negate;
    temp0.Add(temp1);
    Temp0.LogNear1(MaxSig-104);

    Self.Assign(tempx, MaxSig);
    Self.Add(temp0);
    self.RoundToPrec(MaxSig);

    Temp0.Free;
    Temp1.Free;
    Tempx.Free;
  end;

end;


{******************* LogNear1 ****************}
procedure TBigFloat.LogNear1(const MaxSig: TMaxSig);
{
y = x / (x + 2)
result = 2 * (y+ y^3/3 + y^5/5 +y^7/7 + ...)
}
var
  Temp0, Temp1, Temp2, TempYSquared, TempS, Term: TBigfloat;
  tolerance, dplaces, LocalSig: integer;
 // m1: int64;
begin
  self.sigdigits := Maxsig;
  tolerance := self.exponent-(MaxSig+6);
  dplaces   := MaxSig+12-self.exponent;
  //LocalSig  := dplaces+6;
  temp0     := TBigfloat.Create(MaxSig);
  Temp1     := TBigFloat.Create(MaxSig);
  Temp2     := TBigFloat.Create(MaxSig);
  TempYSquared     := TBigFloat.Create(MaxSig);
  TempS     := TBigFloat.Create(MaxSig);
  Term      := TBigFloat.Create(MaxSig);
  temp2.AssignTwo;
  // calculate TermS = self/(self+2)
  temp0.Assign(self, MaxSig);
  temp0.Add(temp2);
  TempS.Assign(self, MaxSig);
  TempS.Divide(temp0, MaxSig);
  // calculate y^2
  tempYSquared.Assign(tempS, MaxSig);
  tempYSquared.SquareRaw;
  tempYSquared.RoundToPrec(MaxSig+6);
  temp1.AssignThree;
  while True do
  begin
    Term.MultRaw(tempYSquared);
    if (term.exponent<tolerance) or (term.decpart.Sign = 0) then
      break;
    LocalSig := dplaces+term.exponent;
    if LocalSig<20 then
      LocalSig := 20;
    term.RoundToPrec;
    temp0.Assign(term);
    temp0.Divide(temp1, LocalSig);
    Temps.Add(temp0);
    temp1.Add(temp2);
  end;
  self.Assign(temps);
  self.multraw(temp2);
  self.RoundToPrec(MaxSig);
  Temp0.Free;
  Temp1.Free;
  Temp2.Free;
  TempYSquared.Free;
  TempS.Free;
  Term.Free;

end;

{******************* LogSolveCubic ****************}
procedure TBigFloat.LogSolveCubic(const MaxSig: TMaxSig);
var
  Guess, temp0, temp1, temp2, temp3, temp4: Tbigfloat;
  num: extended;
  ii, LocalSig, totalSig, tolerance: integer;
begin
  LocalSig  := 18;
  Totalsig  := MaxSig+16;
  tolerance := -MaxSig-4;
  Guess     := TBigfloat.Create(LocalSig);
  Temp0     := TBigfloat.Create(LocalSig);
  Temp1     := TBigfloat.Create(LocalSig);
  Temp2     := TBigfloat.Create(LocalSig);
  Temp3     := TBigfloat.Create(LocalSig);
  Temp4     := TBigfloat.Create(LocalSig);
  // get a guess of log
  self.ConvertToExtended(num);
  if num <> 0 then
  Guess.Assign(system.ln(num)*1.00001)
  else
  begin
  guess.assign(0);
  exit;
  end;
  ii := 0;
  while True do
  begin
    temp1.Assign(guess, LocalSig);
    temp1.Exp(LocalSig);
    temp3.Assign(Temp1, LocalSig);
    Temp3.Subtract(self);
    Temp2.Assign(Temp1, LocalSig);
    Temp2.Add(self);
    Temp1.Assign(Temp3, LocalSig);
    Temp1.Divide(Temp2, LocalSig);
    Temp0.AssignTwo;
    temp0.sigdigits := LocalSig;
    Temp0.Mult(temp1);
    temp3.Assign(guess, LocalSig);
    temp3.Subtract(temp0);
    if ii<>0 then
      if ((3*temp0.exponent)<tolerance) or  (temp0.decpart.Sign = 0) then
        break;
    guess.Assign(temp3, LocalSig);
    LocalSig := LocalSig*3;
    if LocalSig>totalsig then
      LocalSig := totalsig;
    ii := 1;
  end;
  self.Assign(temp3, MaxSig);
  Guess.Free;
  Temp0.Free;
  Temp1.Free;
  Temp2.Free;
  Temp3.Free;
  Temp4.Free;

end;

{******************* Power ****************}
procedure TBigFloat.Power(power: TBigfloat; const MaxSig: TMaxSig);

begin
  self.Log(MaxSig+32);
  self.Multraw(power);
  self.Exp(MaxSig+32);
  self.RoundToPrec(MaxSig);
  sigdigits:=Maxsig;
end;



{******************* Compact ****************}
procedure TBigFloat.Compact;
var
  Top, i, j: integer;
  N, NN, K:  int64;
begin
  Top := high(self.decpart.Digits);
  if self.decpart.Digits[Top] = 0 then
    exit;
  i := 0;
  // how many full zero digits ...
  while self.decpart.Digits[i] = 0 do
    Inc(i);
  j  := decpart.GetBasePower*i-1;
  // Add how many partial zero digits...
  NN := self.decpart.Digits[i];
  repeat
    Inc(j);
    N  := NN;
    NN := N div 10;
    K  := N-NN*10;
  until (K<>0) or (NN = 0);
  decpart.ShiftRightBase10(j);
end;

{******************* GetDigitAtX ****************}
function TBigFloat.GetDigitAtX(const x: word): integer;
var
  b, Last, div1, div2, num, divisor, Remainder: int64;
  xspot, Top, topdigits, DigitCount, digitsfromleft, down: integer;
begin
  Result := 0;
  Top    := high(self.decpart.Digits);
  Last   := self.decpart.fDigits[Top];
  b      := GetBasePower;
  if Last>0 then
    TopDigits := 1+system.trunc(Math.Log10(Last))
  else
    TopDigits := 1;
  DigitCount := Top*b+TopDigits;
  if x>DigitCount then
    exit;
  if x<=TopDigits then  // want digit in last bit
  begin
    num   := Last;
    xspot := TopDigits+1-x;
  end
  else    // want digit in number somewhere
  begin
    DigitCount := x-TopDigits;
    down  := (DigitCount-1) div b;
    digitsfromleft := DigitCount-down*b;
    xspot := b-digitsfromleft+1;
    Num   := self.decpart.fDigits[Top-Down-1];
  end;
  div2      := system.trunc(Math.intpower(10, xspot-1));
  div1      := div2*10;
  divisor   := num div div1;
  Remainder := num-divisor*div1;
  Result    := Remainder div div2;
end;


{******************* Add1up ****************}
procedure TBigFloat.Add1up;
var
  i, Top, TopDigits: integer;
begin
  i   := 0;
  Top := high(self.decpart.fDigits);
  while (i<=Top) and (self.decpart.fDigits[i] = (self.decpart.Base-1)) do
  begin
    self.decpart.fDigits[i] := 0;
    Inc(i);
  end;
  if i<Top then
    Inc(self.decpart.fDigits[i])
  else if i>Top then
  begin
    self.decpart.fDigits[Top] := self.decpart.Base div 10;
    Inc(self.exponent);
  end
  else  //if i = Top then
  begin
    if self.decpart.fDigits[i]<>0 then
      TopDigits := 1+system.trunc(Math.Log10(self.decpart.fDigits[i]))
    else
      TopDigits := 1;
    Inc(self.decpart.fDigits[i]);
    if system.Trunc(Math.Log10(self.decpart.fDigits[i])+1)<>TopDigits then
      Inc(self.exponent);
  end;
end;



{******************* CheckPiPlaces ****************}
procedure TBigFloat.CheckPiPlaces(const MaxSig: TMaxSig);
var
  localPrecision: word;
begin
  localPrecision := MaxSig+2;
  if localPrecision>zpi.sigdigits then
    calculate_PI_AGM(localPrecision+5)
  else
  begin
    self.Assign(zpi);
    self.RoundToPrec(MaxSig);
  end;
end;

{******************* Calculate_Pi_AGM ****************}
procedure TBigFloat.Calculate_PI_AGM(const MaxSig: TMaxSig);
var
  temp1, tempC0, tempa1, tempB1, sum, pow_2, tempA0, tempB0, Half, two: TBigfloat;
  LocalSig: integer;
begin
  LocalSig := MaxSig+16;
  tempA0   := TBigFloat.Create(LocalSig);
  TempB0   := TBigFloat.Create(LocalSig);
  pow_2    := TBigFloat.Create(LocalSig);
  Temp1    := TBigFloat.Create(LocalSig);
  TempC0   := TBigFloat.Create(LocalSig);
  TempA1   := TBigFloat.Create(LocalSig);
  TempB1   := TBigFloat.Create(LocalSig);
  sum      := TBigFloat.Create(LocalSig);
  Half     := TBigFloat.Create(LocalSig);
  Two      := TBigFloat.Create(LocalSig);
  Two.AssignTwo;
  TempA0.AssignOne;
  Sum.AssignOne;
  pow_2.AssignFour;
  Half.AssignHalf;
  TempB0.AssignHalf;
  TempB0.Sqrt(LocalSig);
  repeat
    // arithmetic mean
    tempA1.Assign(tempA0);  //TempA1 := (TempA0+TempB0)*0.5
    TempA1.Add(tempB0);
    tempA1.Mult(half, LocalSig);
    // geometric mean
    TempB1.Assign(tempA0);   //TempB1 := (TempA0*TempB0)^(0.5)
    TempB1.Mult(TempB0);
    TempB1.Sqrt(LocalSig);
    TempB1.RoundToPrec(LocalSig+6);

    Tempc0.Assign(tempA0);
    Tempc0.Subtract(tempB0);
    tempc0.Mult(half);

    Temp1.Assign(TempC0);
    Temp1.Square(LocalSig);
    Temp1.Mult(pow_2, LocalSig);
    sum.Subtract(temp1);
    sum.RoundToPrec(LocalSig);

    TempA0.Assign(tempa1);
    tempB0.Assign(tempb1);

    Pow_2.Mult(two, LocalSig);
  until (-4*TempC0.exponent)>LocalSig;

  TempA1.Add(TempB1);
  TempA1.Square(LocalSig);
  TempA1.Divide(sum, LocalSig);
  self.Assign(TempA1);
  zPi.Assign(TempA1);
  self.RoundToPrec(MaxSig);

  // free variables...
  TempA0.Free;
  TempA1.Free;
  TempB0.Free;
  TempB1.Free;
  TempC0.Free;
  pow_2.Free;
  Temp1.Free;
  Sum.Free;
  Half.Free;
  Two.Free;
end;

{******************* PiConst ****************}
procedure TBigFloat.PiConst(const MaxSig: TMaxSig);
begin
  self.CheckPiPlaces(MaxSig);
end;

initialization
  //setbaseval(1000000);
  zlog2   := TBigfloat.Create(100);
  zlog10  := TBigFloat.Create(100);
  zlog10R := TBigFloat.Create(100);
  zPi     := TBigFloat.Create(100);
  zlog2.CheckLogPlaces(100+66);
  zPi.CheckPiPlaces(100+66);

finalization

  zlog2.Free;
  zlog10.Free;
  zlog10R.Free;
  zPi.Free;
end.
