//{$IFDEF FPC}{$MODE objFPC}{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}
program munchausennumbers;
//https://rosettacode.org/wiki/Munchausen_numbers#Pascal
//uses
  //sysutils;
type
  tdigit  = byte;
const
  abase = 10;
  amaxDigits = abase-1;// set for 32-compilation otherwise overflow.

var 
  DgtPotDgt : array[0..abase-1] of NativeUint;
  cnt: NativeUint;
  
function CheckSameDigits(n1,n2:NativeUInt):boolean;
var
  dgtCnt : array[0..aBase-1] of NativeInt; 
  i : NativeUInt;  
Begin
  //fillchar(dgtCnt,SizeOf(dgtCnt),#0);
  for it:= 0 to length(dgtcnt)-1 do dgtcnt[it]:= 0;
  repeat   
    //increment digit of n1 
    i := n1;n1 := n1 div abase;i := i-n1*abase;inc(dgtCnt[i]); 
    //decrement digit of n2     
    i := n2;n2 := n2 div abase;i := i-n2*abase;dec(dgtCnt[i]);     
  until (n1=0) AND (n2= 0 );
  result := true;
  For i := 0 to aBase-1 do
    result := result AND (dgtCnt[i]=0);   
end;

procedure Munch(number,DgtPowSum,minDigit:NativeUInt;digits:NativeInt);
var
  i: NativeUint;
begin
  inc(cnt);
  number := number*abase;
  IF digits > 1 then Begin
    For i := minDigit to abase-1 do
      Munch(number+i,DgtPowSum+DgtPotDgt[i],i,digits-1);
  end else
    For i := minDigit to abase-1 do    
      //number is always the arrangement of the digits leading to smallest number 
      IF (number+i)<= (DgtPowSum+DgtPotDgt[i]) then 
        IF CheckSameDigits(number+i,DgtPowSum+DgtPotDgt[i]) then
          iF number+i>0 then
            //writeln(Format('%*d  %.*d',
             //[//amaxDigits,DgtPowSum+DgtPotDgt[i],amaxDigits,number+i]));
           writeln(inttostr(DgtPowSum+DgtPotDgt[i])+'  '+inttostr(number+i));  
end;      

procedure InitDgtPotDgt;
var
  i,k,dgtpow: NativeUint;
Begin
  // digit ^ digit ,special case 0^0 here 0  
  DgtPotDgt[0]:= 0;
  For i := 1 to aBase-1 do Begin
    dgtpow := i;
    For k := 2 to i do 
      dgtpow := dgtpow*i;
    DgtPotDgt[i] := dgtpow;  
  end;  
end;  
           
begin //@main
  cnt:= 0;
  InitDgtPotDgt;
  processmessagesOFF;
    Munch(0,0,0,amaxDigits);   //?????????????  ?????????????
  processmessagesON;   
  writeln('Check Count: '+inttostr(cnt));
  
   with TPythonEngine.Create(Nil) do begin
    pythonhome:= 'C:\Users\breitsch\AppData\Local\Programs\Python\Python38\';
   //  pythonhome:= 'C:\Users\breitsch\AppData\Local\Programs\Python\Python37-32\';
    try
      loadDLL;
      Println('Decimal: '+ 
            EvalStr('__import__("decimal").Decimal(0.1)')); 
            execstr('res=[]');
            execstr('for i in range(50000):'+#10+
                    '  if i == sum(int(x) ** int(x) for x in str(i)):'+#10+
                    '    res.append(i)');
      Println('Munchausen Py: '+EvalStr('res'));  
      execstr('import platform, sys');
      println('platform '+evalstr('platform.architecture()[0]')); 
      println('platform check: '+evalstr('sys.maxsize > 2**62'));  
      //Exception: SystemError: C:\A\31\s\Objects\structseq.c:398: bad argument to internal function at 0.1357
     // execstr('import keras');         
    except
       raiseError;        
    finally  
       unloadDLL;     
       free;
    end;
  end; 
end.

end.

doc: https://rosettacode.org/wiki/Munchausen_numbers

ref: --------------------------------------------------------

        1  000000001
     3435  000003345
438579088  034578889
Check Count: 43758
n= maxdigits = 9,k = 10;CombWithRep = (10+9-1))!/(10!*(9-1)!)=43758
 mX4 executed: 24/08/2023 14:14:19  Runtime: 0:0:4.959  Memload: 46% use
 mX4 byte code executed: 24/08/2023 14:15:47  Runtime: 0:0:2.496  Memload: 46% use

        1  000000001
     3435  000003345
438579088  034578889
Check Count: 43758
 mX4 executed: 24/08/2023 14:12:10  Runtime: 0:0:38.491  Memload: 46% use
 
 
               1  0000000000000001
            3435  0000000000003345
       438579088  0000000034578889
       408321926  0000000262810493
      1972353746  0000001432697375
        67299408  0000000002897496
       421071372  0000000042172137
      1954020147  0000000442519071
      1937164985  0000001154368799
      1162364704  0000001134660247
      1179088593  0000000195178983
      1956350842  0000001380425695
       438629211  0000000236894121
       390811723  0000000237893011
       438719142  0000000347894121
       774861043  0000000604713487
Check Count 3268760
 mX4 executed: 24/08/2023 13:59:00  Runtime: 0:10:15.292  Memload: 47% use



https://learn.microsoft.com/en-us/windows/console/setconsolecursorposition
     https://rosettacode.org/wiki/21_game#Pascal