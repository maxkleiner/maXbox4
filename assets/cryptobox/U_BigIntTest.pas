unit U_BigIntTest;
{Copyright  © 2001-2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Spin, ShellAPI, ExtCtrls, ComCtrls, UBigIntsV3 ;

type
  Tbigints = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Long1Edt: TEdit;
    Long2Edt: TEdit;
    AddBtn: TButton;
    MultBtn: TButton;
    FactorialBtn: TButton;
    SubtractBtn: TButton;
    DivideBtn: TButton;
    ModBtn: TButton;
    ComboBtn: TButton;
    XtotheYBtn: TButton;
    Long3Edt: TEdit;
    ModPowBtn: TButton;
    SqRootBtn: TButton;
    SquareBtn: TButton;
    CopyBtn: TButton;
    ProbPrimeBtn: TButton;
    GCDBtn: TButton;
    InvModBtn: TButton;
    YthRootBtn: TButton;
    Button10: TButton;
    FloorBtn: TButton;
    Button12: TButton;
    Memo2: TMemo;
    Memo1: TMemo;
    StaticText1: TStaticText;
    DivRemBtn: TButton;
    ToInt64Btn: TButton;
    procedure AddBtnClick(Sender: TObject);
    procedure MultBtnClick(Sender: TObject);
    procedure FactorialBtnClick(Sender: TObject);
    procedure SubtractBtnClick(Sender: TObject);
    procedure DivideBtnClick(Sender: TObject);
    procedure ModBtnClick(Sender: TObject);
    procedure ComboBtnClick(Sender: TObject);
    procedure powerbtnClick(Sender: TObject);
    procedure modpowbtnClick(Sender: TObject);
    procedure rootbtnClick(Sender: TObject);
    procedure squareButtonClick(Sender: TObject);
    procedure copyButtonClick(Sender: TObject);
    procedure primetestclick(Sender: TObject);
    procedure gcdClick(Sender: TObject);
    procedure invbuttonClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure YthRootBtnClick(Sender: TObject);
    procedure FastMultBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure ModTypeGrpClick(Sender: TObject);
    procedure DivRemBtnClick(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure FloorBtnClick(Sender: TObject);
    procedure ToInt64BtnClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    freq:int64;  {performace counter frequncy}
    start,stop:int64;
  end;

var
  bigints: Tbigints;

implementation
{$R *.DFM}
uses  math;

procedure Tbigints.AddBtnClick(Sender: TObject);
{addition}
var
  i1,i2,i3:Tinteger;
  n:int64;
begin
  i1:=TInteger.create;
  i2:=TInteger.create;
  i3:=TInteger.create;
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  i1.add(i2);
  memo1.clear;
  memo1.lines.add(i1.converttoDecimalString(true));
  if i2.ConvertToInt64(n) then
  begin
    i1.assign(long1edt.text);
    i1.Add(n);
    if i1.compare(i3)=0 then memo1.lines.add('Error! Int64 result='+inttostr(n));
  end;
  i1.free;
  i2.free;
  i3.free;
end;

procedure Tbigints.MultBtnClick(Sender: TObject);
{Multiply}
var
  i1,i2:Tinteger;
begin
  i1:=TInteger.create;
  i2:=TInteger.create;
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  QueryPerformanceCounter(start);
  i1.mult(i2);
  QueryPerformanceCounter(stop);
  //timelbl.caption:=format('Execution Time: %6.2F microseconds',[1e6*(stop-start)/freq]);
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
end;

procedure Tbigints.FastMultBtnClick(Sender: TObject);
{Fast Multiply}
var
  i1,i2:Tinteger;

begin
  i1:=TInteger.create;
  i2:=TInteger.create;
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  QueryPerformanceCounter(start);
  i1.Fastmult(i2);
  QueryPerformanceCounter(stop);
  //timelbl.caption:=format('Execution Time: %6.2F microseconds',[1e6*(stop-start)/freq]);
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
end;



procedure Tbigints.FactorialBtnClick(Sender: TObject);
{Factorial}
var
  i1:Tinteger;
begin
  i1:=TInteger.create;
  i1.assign(long1edt.text);
  if i1.compare(3000)>0
  then
  begin
    showmessage('Input truncated to 3000');
    i1.assign(3000);
  end;
  i1.factorial;
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
end;

procedure Tbigints.SubtractBtnClick(Sender: TObject);
{Subtraction}
var
  i1,i2:Tinteger;
begin
  i1:=TInteger.create;
  i2:=TInteger.create;
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  i1.subtract(i2);
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
end;

{************* DivideRemBtnClick **************}
procedure Tbigints.DivRemBtnClick(Sender: TObject);
{Important div and mod paper
     http://www.cs.uu.nl/~daan/download/papers/divmodnote.pdf  }
{Compare 3 different definitions of divide with remainder}     
var
  i1,i2,remT,remF,RemE:Tinteger;
begin
  i1:=TInteger.create;
  i2:=TInteger.create;
  remT:=TInteger.create;
  remF:=TInteger.create;
  remE:=TInteger.create;
  memo1.clear;

  i1.assign(long1edt.text);
  i2.assign(long2edt.text);
  i1.divideremTrunc(i2, remT);
  {#9=Tab, used aliign output}
  memo1.lines.add('DivideRemTrunc:'+#9#9+'Q='+i1.converttoDecimalString(true));
  i1.assign(long1edt.text);
  i1.divideremFloor(i2, remF);
  memo1.lines.add('DivideRemFloor:'+#9#9+'Q='+i1.converttoDecimalString(true));
  i1.assign(long1edt.text);
  i1.divideremEuclidean(i2, remE);
  memo1.lines.add('DivideRemEuclidiean:'+#9+'Q='+i1.converttoDecimalString(true));


  memo1.lines.add('DivideRemTrunc:'+#9#9+'R='+remT.converttoDecimalString(true));
  memo1.lines.add('DivideRemFloor:'+#9#9+'R='+remF.converttoDecimalString(true));
  memo1.lines.add('DivideRemEuclidean'+#9+'R='+remE.converttoDecimalString(true));
  i1.free;
  i2.free;
  remT.free;
  remF.free;
  remE.free;
end;

{************ DivideBtnClick *************}
procedure Tbigints.DivideBtnClick(Sender: TObject);
{divide}
var
  i1,i2:Tinteger;
begin
  i1:=TInteger.create;
  i2:=TInteger.create;
  i1.assign(long1Edt.text);
  i2.assign(long2Edt.text);
  i1.divide(i2);
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
end;


procedure Tbigints.ModBtnClick(Sender: TObject);
var
  i1,i2:Tinteger;
begin
  i1:=TInteger.create;
  i2:=TInteger.create;
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  i1.modulo(i2);
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
end;

procedure Tbigints.ComboBtnClick(Sender: TObject);
var
  i1,i2,i3:Tinteger;
begin
  i1:=TInteger.create;
  i2:=TInteger.create;
  i3:=TInteger.create;
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  if (i1.compare(1000)<=0) and (i2.compare(1000)<=0) then
  begin
    if i1.compare(i2)<0 then i1.assign(0)
    else if i1.compare(i2)=0 then i1.assign(1)
    else
    begin
      i3.assign(i1); i3.subtract(i2);
      i1.factorial;
      i2.factorial;
      i3.factorial;
      i1.divide(i2);
      i1.divide(i3);
    end;
    memo1.text:=i1.converttoDecimalString(true);
  end
  else showmessage('No calculation - numbers for combinations limited to 1000');
  i1.free;
  i2.free;
  i3.free;
end;



procedure Tbigints.powerbtnClick(Sender: TObject);
var i1:tinteger;e:integer;
begin
i1:=TInteger.create;
i1.assign(long1edt.text);
e:=strtoint(long2Edt.text);
i1.pow(e);
memo1.text:=i1.ConvertToDecimalString(true);
i1.free;
end;


procedure Tbigints.modpowbtnClick(Sender: TObject);
var g,e,m :Tinteger;
begin
g:=TInteger.create;
e:=TInteger.create;
m:=TInteger.create;
g.assign(long1edt.text);
e.assign(long2edt.text);
m.assign(long3edt.text);
g.modpow(e,m);
memo1.text:=g.ConvertToDecimalString(true);
g.free;
e.free;
m.free;
end;


procedure Tbigints.rootBtnClick(Sender: TObject);
var i1:tinteger;
begin
i1:=tinteger.create;
i1.assign(long1edt.text);
i1.sqroot;
memo1.text:=i1.ConvertToDecimalString(true);
i1.free;
end;

procedure Tbigints.squareButtonClick(Sender: TObject);
var i1:tinteger;
begin
i1:=tinteger.create;
i1.assign(long1edt.text);
i1.square;
memo1.text:=i1.ConvertToDecimalString(true);
i1.free;
end;

procedure Tbigints.copyButtonClick(Sender: TObject);
var s:string;
    i:integer;
begin
  s:='';
  for i:=0 to memo1.lines.count-1 do s:=s+memo1.lines[i];
  long1edt.text:=s;
end;

procedure Tbigints.primetestClick(Sender: TObject);
var i1:tinteger;r:boolean;
begin
   memo1.text:='testing..';
   application.processmessages;
   i1:=tinteger.create;
   i1.assign(long1edt.text);
   r:=i1.IsProbablyPrime;
   if r then memo1.text:='prime' else memo1.text:='not prime';
   I1.free;
end;

procedure Tbigints.gcdClick(Sender: TObject);
var i1,i2:tinteger;
begin
i1:=tinteger.create;
i2:=tinteger.create;
i1.assign(long1edt.text);
i2.assign(long2edt.text);
i1.gcd(i2);
memo1.text:=i1.ConvertToDecimalString(true);
i1.free;
i2.free;
end;


procedure Tbigints.invbuttonClick(Sender: TObject);
var i1,i2:tinteger;
begin
 i1:=tinteger.create;
 i2:=tinteger.create;
 i1.assign(long1edt.text);
 i2.assign(long2edt.text);
 i1.invmod(i2);
 memo1.text:=i1.ConvertToDecimalString(true);
 i1.free;
 i2.free;
end;

procedure Tbigints.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure Tbigints.YthRootBtnClick(Sender: TObject);
var i1:Tinteger;
begin
  i1:=tinteger.create;
  i1.assign(long1edt.text);
  i1.Nroot(strtoint(long2edt.text));
  memo1.text:=i1.ConvertToDecimalString(true);
  i1.free;
end;      



procedure Tbigints.FormActivate(Sender: TObject);
begin
  queryperformancefrequency(freq);
end;

procedure Tbigints.Button10Click(Sender: TObject);
{fastmult speed test}
{multiply two random large  numbers together with mult and fast mult and
compare results and times}
{x and y contain the number of random digits in each operand}
var
  n1,n2,i:integer; {number of integers}
  s1,s2:string;
  i1,i2:Tinteger;
  if1,if2:TInteger;
  time1,time2:extended;
  units:string; {time units for display, based on time2 value}
  m:integer; {multiplier for units for time display}
begin
  n1:=strtoint(long1edt.text);
  if n1<=0 then n1:=1;
  n2:=strtoint(long2Edt.text);
  if n2<=0 then n2:=1;
  if n1+n2 >500000 then {reduce proportionately }
  begin
    n1:=trunc(n1*(500000/(n1+n2)));
    n2:=trunc(n2*(500000/(n1+n2)));
  end;
  If n2>250000 then n2:=250000;
  i1:=TInteger.create;
  i2:=TInteger.create;
  if1:=TInteger.create;
  if2:=TInteger.create;
  s1:='';
  for i:=1 to n1 do s1:=s1+char(ord('0')+random(10));
  s2:='';
  for i:=1 to n2 do s2:=s2+char(ord('0')+random(10));
  i1.assign(s1);
  i2.assign(s2);
  screen.cursor:=crHourglass;
  QueryPerformanceCounter(start);
  i1.mult(i2);
  //i1.square;
  QueryPerformanceCounter(stop);
  time1:=(stop-start)/freq;
  if1.assign(s1);
  if2.assign(s2);
  QueryPerformanceCounter(start);
  if1.Fastmult(if2);
  //if1.fastsquare;
  QueryPerformanceCounter(stop);
  time2:=(stop-start)/freq;
  screen.cursor:=crDefault;
  with memo1 do
  begin
    clear;
    if time2>1 then begin m:=1; units:='seconds' end
    else if time2>0.001 then begin m:=1000; units:='milliseconds'; end
    else begin m:=1000000; units:='microseconds'; end;
    lines.add(format('Multplying %d digit random  by %d digit random using Mult and FastMult',[n1,n2]));
    if i1.compare(if1)<>0 then lines.Add('Results differ')
    else
    begin
      lines.add('Results agree');
      lines.add(format('%d digits in result',[i1.digitcount]));
    end;
    lines.add(format('Mult Execution Time: %6.2F %s',[m*time1,units]));
    lines.add(format('FastMult Execution Time: %6.2F %s',[m*time2,units]));
  end;
  i1.free;
  i2.free;
  if1.free;
  if2.free;
end;

(*
procedure Tbigints.ModFBtnClick(Sender: TObject);
var
  i1,i2,rem:Tinteger;
begin
  i1:=TInteger.create;
  i2:=TInteger.create;
  rem:=TInteger.create;
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  i1.divideremFloor(i2,rem);
  memo1.text:=rem.converttoDecimalString(true);
  i1.free;
  i2.free;
  rem.free;
end;
*)

(*
procedure Tbigints.ModEBtnClick(Sender: TObject);
var
  i1,i2,rem:Tinteger;
begin
  i1:=TInteger.create;
  i2:=TInteger.create;
  rem:=TInteger.create;
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  i1.divideremEuclidean(i2,rem);
  memo1.text:=rem.converttoDecimalString(true);
  i1.free;
  i2.free;
  rem.free;
end;
*)
procedure Tbigints.ModTypeGrpClick(Sender: TObject);
begin
  //SetModuloType(ModTypeGrp.itemindex);
end;



procedure Tbigints.Button12Click(Sender: TObject);
var i1,i2,i3:tinteger;
begin
 i1:=tinteger.create;
 i2:=tinteger.create;
 i3:=tinteger.create;
 i1.assign(long1edt.text);
 i3.assign(i1);
 i2.assign(long2edt.text);
 i1.invmod(i2);
 i1.mult(i3);
 i1.modulo(i2);
 memo1.text:=i1.ConvertToDecimalString(true);
 i1.free;
 i2.free;
end;

procedure Tbigints.FloorBtnClick(Sender: TObject);
var
  i1,i2,i3:Tinteger;
begin
  i1:=TInteger.create;
  i2:=TInteger.create;
  i3:=TInteger.create;
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  i1.divideremFloor(i2,i3);
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
  i3.free;
end;

procedure Tbigints.ToInt64BtnClick(Sender: TObject);
var
  i1:Tinteger;
  n:int64;
  i,L:integer;
  s:string;
begin
  i1:=TInteger.create;
  i1.assign(long1edt.text);
  if i1.converttoInt64(n) then
  begin
    {we'll punctuate it, just for fun}
    s:=inttostr(n);
    L:=length(s);
    for i:=L-3 downto 1 do
    if (L-i) mod 3 =0 then insert(',',s,i+1);
    memo1.text:=s;
  end
  else memo1.text:='Failed';
  i1.free;
end;
end.
