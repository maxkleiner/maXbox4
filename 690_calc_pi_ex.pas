unit PI_ex_maXbox4;

//#sign:Max: MAXBOX10: 18/05/2016 13:43:30 
//eliminated pointer array to dynamic array - dynamix

interface

// uses ;   #locs:196

var
  Digits: String;

procedure TestUnit(NumDig: Integer);
procedure CalcPIOriginal(NumDig: Integer);
procedure CalcPI(NumDig: Integer);

implementation
{/* +++Date last modified: 05-Jul-1997 */

/*
 This program was based on a Pascal program posted in the FIDO 80XXX
 assembly conference.  That Pascal program had the following comment:

                    ------------------------
 This program, which produces the first 1000 digits of PI, using
 only integer arithmetic, comes from an article in the "American
 Mathematical Monthly", Volume 102, Number 3, March 1995, page
 195, by Stanley Rabinowitz and Stan Wagon.
                    ------------------------

 My C implementation is placed into the public domain, by its author
 Carey Bloodworth, on August 22, 1996.

 I have not seen the original article, only that Pascal implementation,
 but based on a discussion in the 80XXX conference, I believe the
 program should be accurate to at least 32 million digits when using
 long unsigned integers.  Using only 16 bit integers causes the
 variables to overflow after a few hundred digits.
*/
}

//#include <stdio.h>

//long unsigned int i, j, k, nines, predigit;
//long unsigned int q, x, numdig, len;
//long unsigned int *pi;
// int printed = 0, line = 1;

var
  PDig: PChar;
  pos: Integer;

procedure SetupDigits(len: Integer);
begin
  SetLength(Digits, len + 2);
  Digits[1]:= '3';
  Digits[2]:= '.';
  pos:= 3;
  Digits[pos]:= #0;
  PDig:= PChar(Digits);
end;

procedure OutDig(dig: Integer);
begin
  Digits[pos]:= Chr(Ord('0') + dig);
  Inc(pos);
end;

procedure CalcPIOriginal(NumDig: Integer);
var
  i, j, nines, predigit: Cardinal;
  q, x, len: Cardinal;
  pi: array of Cardinal;
begin
  len := (numdig*10) div 3;
  SetLength(pi,len+1);
  for i:=1 to len do
          pi[i]:=2;
  nines := 0;
  predigit := 0;
  SetupDigits(len);
  for j:=0 to numdig do begin
    q:=0;
    for i:=len downto 1 do begin
    x:=10*pi[i]+q*i;
    pi[i]:=x mod (2*i -1);
    q:=x div (2*i-1);
    end;
    pi[1]:=q mod 10;
    q:=q div 10;
    if (q=9) then
    inc(nines)
    else if q=10 then begin
    OutDig(1+predigit);
    while nines>0 do begin
      OutDig(0);
      dec(nines);
    end;
  predigit:=0;
    end
    else begin
      if j>1 then
        OutDig(predigit);
      while nines>0 do begin
        OutDig(9);
        dec(nines);
      end;
      predigit:=q;
    end;
  end;
  OutDig(predigit);
end;

type
  //PCardinalArray = ^TCardinalArray;
 // TCardinalArray = array[0..0] of Cardinal;
  TCardinalArray = array of Cardinal;


// pulled inner loop out of routine
function Inner(api:TCardinalArray; len:cardinal):cardinal;
// converted PI from dynamic array to static array pointer
var
	i,x,k:cardinal;
	j:cardinal;
begin
	j:=10;
	result:=0;
	i:=len;
	while i>0 do  begin// converted for to while
		x:=j*api[i]+result*i;  // converted 10 to a variable 'j' (PII optimization only)
		k:=i+i-1;
		result:=x div k;
		api[i]:=x-result*k; // eliminated mod (which is a division)
		dec(i);
	end;
end;

procedure CalcPI(NumDig: Integer);
var
	i,j,nines,predigit:cardinal;
	len,q,qi:cardinal;
	api: array of cardinal; //TCardinalArray; //array of cardinal;
begin
	len := (numdig*10) div 3;
	SetArrayLength(api,len+1);
	for i:=1 to len do
		api[i]:=2;
	nines := 0;
	predigit := 0;
	SetupDigits(len);
	for j:=0 to numdig do begin
		qi:=Inner((api),len);
		q:=qi div 10;
		api[1]:=qi-q*10;
		if (q=9) then
			inc(nines)
		else if q=10 then begin
			OutDig(1+predigit);
			while nines>0 do begin
				OutDig(0);
				dec(nines);
			end;
			predigit:=0;
		end
		else begin
			if j>1 then
				OutDig(predigit);
			while nines>0 do begin
				OutDig(9);
				dec(nines);
			end;
			predigit:=q;
		end;
	end;
	OutDig(predigit);
end;

procedure TestUnit(NumDig: Integer);
begin
  CalcPI(NumDig);
  CalcPIOriginal(NumDig);
end;

begin
  writeln('Unit Test first: ')
  testunit(30)
  writeln(digits+'   '+#10#13)
  writeln(' ')
  CalcPI(100);
  writeln(digits)
  CalcPIOriginal(100);
  writeln(digits)
  writeln(bigPI)   //Ref!

End.
