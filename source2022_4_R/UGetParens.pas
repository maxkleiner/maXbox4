unit UGetParens;
{This unit contains procedure GetParens which generates a list of parenthesized
 expression templates from a set of 1 character constant or variable names.
 GetParens has parameters "Variables" with the constants or variables, "Opchar,
 the character used as a placeholder where binary operators are to be inserted,
 and  "List", the TStringlist to hold the expressions.

 The number of ways to parenthesize a set of n variables is "Catalan number"
 n-1  and will be the number of entries in "List".

 For example:  GetParens('ABCD','&', List) will return a list with 5 entries
 A&(B&(C&D)), A&((B&C)&D), (A&B)&(C&D), (A&(B&C)&D), and ((A&B)&C)&D
 }

interface

   Uses Windows, classes;

  procedure GetParens(Variables:string; OpChar:char; var list:TStringlist);

implementation


{************* BinStringToInt **********}
function binstringtoint(s:string):integer;
{Convert a binary string to an integer}
var i:integer;
    v:integer;
begin
  v:=1;
  result:=0;
  for i:=length(s) downto 1 do
  begin
    if s[i]='1' then result:=result+ v;
    v:=2*v;
  end;
end;

{************* MakeBinary **********}
function makeBinaryStr(n:integer):string;
{Convert an integer to a binary string}
var i:integer;
begin
  result:='';
  i:=n;
  while i>0 do
  begin
    if i mod 2=0 then result:='0'+result
    else result:='1'+result;
    i:=i div 2;
  end;
end;

{************** IsVar ***********}
function isvar(ch:char):boolean;
{return 'true' boolean value if 'ch' is a letter or digit}
begin result:=upcase(ch) in ['A'..'Z','0'..'9']; end;

{******************* IsOK *************}
function isOK(n, nbrones:integer):boolean;
{return true if the binary representation of N has
 has "nbrones" 1's and the number of 0's to the left of
 any '0' is less than of '1's to to the left of that '0'}
var
  s:string;
  ones,zeros:integer;
  i:integer;
begin
  s:=makeBinaryStr(n);
  ones:=0;
  zeros:=0;
  result:=false;
  for i:=1 to length(s) do
  begin
    if s[i]='0' then
    begin
      inc(zeros);
      if zeros>ones then exit;
    end
    else inc(ones);
    if ones>nbrones then exit;
  end;
  if ones=nbrones then result:=true;
end;

{***************** AddRightParens ***********}
function AddRightParens(s:string):string;
{Given an expression with only letters and left parens, figure out where
 the right parens belong and return a string with right parens inserted}
var
  i:integer;
  r:string;
  count, lettercount:integer;
  t:string;
begin
  r:=s;
  count:=0;
  lettercount:=0;
  i:=1;
  t:='';
  while i<=length(r) do {examine the input expression character by character}
  begin
    if r[i]='(' then
    begin {found a left paren}
      inc(count);   {count it}
      t:=t+'(';  {add ( to output expression}
      lettercount:=0;
    end
    else if isvar(r[i]) then
    begin  {it's a letter}
      inc(lettercount); {count it}
      if lettercount=1 then t:=t+r[i]{it's the first letter, add it to output}
      else
      begin  {it's the second letter, just add it to the output and add a right )}
        (*
        if t[length(t)]='('
        then delete(t,length(t),1) {no need to surround a single variable with parens}
        else*) t:=t+r[i]+')';      {otherwise close the parens}
        dec(count);  {either way, move up one paren level}
        dec(lettercount); {and reduce the reduce letter count}
      end;
    end;
    inc(i,1);
  end;
  while count>0 do
  begin  {now close up all open parens}
    t:=t+')';
    dec(count);
  end;
  result:=t;
end;


{**************AddOps ***********}
 function addops(s:string; const opchar:char):string;
 {Add operator codes to an expression}
 {Insert operator between ')('
  or 'x(' where x is any variable,
  or 'xy', where x and y are any two variables}
 var j:integer;
 begin
   j:=length(s);
   while j>1 do
   begin
     if (s[j]='(') and ((s[j-1]=')')or isVar(s[j-1]))
      or (isVar(s[j]))
     then
     begin
       insert(Opchar,s,j);
       dec(j);
     end;
     dec(j);
   end;
   result:=s;
 end;


 {************ GetParens ****************}
procedure GetParens(Variables:string; OpChar:char; var list:TStringlist);
{One way to generate Catalan number N is to find all combinations of
 symbols withing a string containing N x's and N y's with the condition
 that there are never more y's than x's to the left of any y.  }

var i,j, index:integer;
    key:string;
    maxvalstr,minvalstr:string;
    minval, maxval:integer;
    nbrvars,N:integer;
    s:string;
    ch:char;

begin
  list.clear;
  {how many digits?}
  nbrvars:=length(variables);
  n:=nbrvars-1;
  key:='';
  maxvalstr:='1';
  minvalstr:='10';

  for i:=2 to n do
  begin
    maxvalstr:=maxvalstr+'1'; {111...  N times}
    minvalstr:=minvalstr+'10'; {101010... N times, string length 2N}
  end;
  for i:=1 to n do maxvalstr:=maxvalstr+'0'; {111...000... total length 2N}
  maxval:=Binstringtoint(maxvalstr);
  minval:=BinStringToInt(minvalstr);

  for i:= minval to maxval do
  {test if i value meets the Catalan criteria, all initial substrings contain no more 0's than 1's}
  if isok(i, n) then
  begin
    key:=makeBinaryStr(i);
    list.add(key)
  end;

  with list do
  begin
    for i:= 0 to count-1 do
    begin
      Index:=1;
      s:=list[i];
      for j:=1 to length(s) do
      if s[j]='1' then s[j]:='('
      else
      begin
        s[j]:=variables[index];
        inc(index); {get next variable character}
      end;
      s:=s+variables[index];  {add the last variable}
      s:=AddRightParens(s);  {add right parens}
      if (s[1]='(') and (s[length(s)]=')') then
      begin   {remove redundant outer parens}
        system.delete(s,1,1);
        system.delete(s,length(s),1);
      end;
      list[i]:=AddOps(s, opchar); {add operations}
    end;
  end;
end;

end.
