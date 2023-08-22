unit Mathbox;
{$N+}

{ 
  This unit contains routines that are useful when you need to work 
with numbers. The routines you find here are of one basic type:

  + Conversion programs which translate numbers into strings.

}

interface

function ArcCos(x: Real): Real;
function ArcSin(x: Real): Real;
function Comp2Str(N: Comp): String;
function Int2StrPad0(N: LongInt; Len: Integer): String;
function Int2Str(N: LongInt): String;
function IsEqual(R1, R2: Double): Boolean;
function LogXY(x, y: Real): Real;
function Pennies2Dollars(C: Comp): String;
function Power(X: Integer; Y: Integer): Real;
function Real2Str(N: Real; Width, Places: integer): String;
function Str2Comp(MyString: string): Comp;
function Str2Pennies(S: String): Comp;
function Str2Real(MyString: string): Real;
function XToTheY(x, y: Real): Real;

implementation

uses
  IBUtils;
  //StrBox;

{----------------------------------------------------
       Name: ArcCos function
Declaration: function ArcCos(x: Real): Real;
       Unit: MathBox
       Code: N
       Date: 02/20/94
Description: Find the ArcCos of a Real
-----------------------------------------------------}
function ArcCos(x: Real): Real;
begin
  ArcCos := ArcTan(Sqrt(1 - Sqr(x)) / x);
end;


{----------------------------------------------------
       Name: ArcSin function
Declaration: function ArcSin(x: Real): Real;
       Unit: MathBox
       Code: N
       Date: 02/20/94
Description: Find the ArcSin of a Real
-----------------------------------------------------}
function ArcSin(x: Real): Real;
begin
  ArcSin := ArcTan(x / Sqrt( 1 - Sqr(x)) / x);
end;

{----------------------------------------------------
       Name: Comp2Str function
Declaration: Comp2Str(N: real; Width, Places: integer)
       Unit: MathBox
       Code: N
       Date: 02/17/94
Description: Converts a Comp into a String
-----------------------------------------------------}
function Comp2Str(N: Comp): String;
var
  TempString: String;
begin
  Str(N:0:0, TempString);
  Comp2Str := TempString;
end;

{----------------------------------------------------
       Name: Int2Str function
Declaration: Int2Str(N: LongInt): String;
       Unit: MathBox
       Code: N
       Date: 06/25/94
Description: Converts a number into a string and pads
             the string with zeros if it is less than
             Len characters long.
-----------------------------------------------------}
function Int2Str(N: LongInt): String;
var
  S : String;
begin
  Str(N:0,S);
  Int2Str := S;
end;

{----------------------------------------------------
       Name: Int2StrPad0 function
Declaration: Int2StrPad0(N: LongInt; Len: Integer): String;
       Unit: MathBox
       Code: N
       Date: 03/01/94
Description: Converts a number into a string and pads
             the string with zeros if it is less than
             Len characters long.
-----------------------------------------------------}
function Int2StrPad0(N: LongInt; Len: Integer): String;
var
  S : String;
begin
  Str(N:0,S);
  while Length(S) < Len do
    S := '0' + S;
  Int2StrPad0 := S;
end;

{----------------------------------------------------
       Name: IsEqual function
Declaration: IsEqual(R1, R2: Double): Boolean;
       Unit: MathBox
       Code: N
       Date: 07/04/94
Description: Tests to see if two doubles are effectively
             equal. Floating point numbers are never
             exact, so we need an approximation.
-----------------------------------------------------}
function IsEqual(R1, R2: Double): Boolean;
var
  R : Double;
begin
  R := Abs(R1 - R2);
  if R > 0.0001 then
    IsEqual := False
  else
    IsEqual := True;
end;

{----------------------------------------------------
       Name: LogXY function
Declaration: function LogXY(x: Real): Real;
       Unit: MathBox
       Code: N
       Date: 02/20/94
Description: Log of X Y
-----------------------------------------------------}
function LogXY(x, y: Real): Real;
begin
  LogXY := Ln(x) / Ln(y);
end;

{----------------------------------------------------
       Name: Pennies2Dollars function
Declaration: Pennies2Dollars(C: Comp): String;
       Unit: MathBox
       Code: N
       Date: 02/17/94
Description: Converts a Comp type that represents a
	     certain number of pennies into a string
             with two decimal places. 123 => $1.23
-----------------------------------------------------}
function Pennies2Dollars(C: Comp): String;
var
  S: string;
begin
  S := Comp2Str(C);
  Insert('.', S, Length(S) - 1);

  if S[1] = '-' then begin           { Number negative? }
    //S := StripFrontChars(S, '-');
    S := StripString(S, '-');
    S := '-$' + S;
  end else
    S := '$' + S;

  Pennies2Dollars := S;
end;

{----------------------------------------------------
       Name: Power function
Declaration: Power(X: Integer; Y: Integer): Real;
       Unit: MathBox
       Code: N
       Date: 02/20/94
Description: Raise X to the Y power
-----------------------------------------------------}
function Power(X: Integer; Y: Integer): Real;
var
  Count: Integer;
  OutCome: Real;
begin
  OutCome := 1;
  for Count := 1 to Y do
    OutCome := OutCome * X;
  Power := OutCome;
end;

{----------------------------------------------------
       Name: Real2Str function
Declaration: Real2Str(N: real; Width, Places: integer)
       Unit: MathBox
       Code: N
       Date: 02/17/94
Description: Converts a Real number into a String
-----------------------------------------------------}
function Real2Str(N: Real; Width, Places: integer): String;
var
  TempString: String;
begin
  Str(N:Width:Places, TempString);
  Real2Str := TempString;
end;

{----------------------------------------------------
       Name: Str2Comp function
Declaration: Str2Real(MyString: string)
       Unit: MathBox
       Code: N
       Date: 02/17/94
Description: Converts a String to a Comp
-----------------------------------------------------}
function Str2Comp(MyString: string): Comp;
var
  ErrCode: Integer;
  Temp: Comp;
begin
  If Mystring[1] = #0 then Str2Comp := 0
  else begin
    Val(Mystring, Temp, ErrCode);
    if ErrCode = 0 then
      Str2Comp := temp
    else
      Str2Comp := 0;
  end;
end;

{----------------------------------------------------
       Name: Str2Pennies function
Declaration: Str2Pennies(MyString: string)
       Unit: MathBox
       Code: N
       Date: 02/17/94	
Description: Converts a String to a Comp
-----------------------------------------------------}
function Str2Pennies(S: String): Comp;
var
  C: Comp;
  i: Integer;
  begin
    if S[1] = '$' then Delete(S, 1, 1);
    i := Pos('.', S);
    if i = Length(S) then begin   { Is last character a period? }
      Delete(S, i, 1);
      S := S + '00';
    end else
      if i <> 0 then begin        { Some pennies?               }
        Delete(S, i, 1);
        if i = (Length(S)) then   { Only one char after decimal?}
          S := S + '0'
      end else
        S := S + '00';            { No decimal, no pennies       }
    C := Str2Comp(S);
    Str2Pennies := C;
end;

{----------------------------------------------------
       Name: Str2Real function
Declaration: Str2Real(MyString: string)
       Unit: MathBox
       Code: N
       Date: 02/17/94
Description: Converts a String to Real number
-----------------------------------------------------}
function Str2Real(MyString: string): Real;
var
  ErrCode: Integer;
  Temp: Real;
begin
  If Mystring[1] = #0 then Str2Real := 0
  else begin
    Val(Mystring, Temp, ErrCode);
    if ErrCode = 0 then
      Str2Real := temp
    else
      Str2Real := 0;
  end;
end;

{----------------------------------------------------
       Name: XToTheY function
Declaration: XToTheY(x, y: Real): Real;
       Unit: MathBox
       Code: N
       Date: 02/20/94
Description: Raise X to the Y Power
-----------------------------------------------------}
function XToTheY(x, y: Real): Real;
begin
  XToTheY := Exp(y * Ln(x));
end;

end.
