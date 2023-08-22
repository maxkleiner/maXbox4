unit PMrand;    {Park / Miller random number generator}
                {see Comm. ACM Oct. 88 Vol. 31 No. 10.}

{*******************************************************}
{                                                       }
{       2-16-95 Added Nrand function, changed real      }
{               type to extended.                       }
{                                                       }
{       3-9-99  Made PMRandom far.                      }
{                                                       }
{       9-11-06 Fixed minor bugs.                       }
{                                                       }
{*******************************************************}

interface

{deterministic for I>0, non-deterministic for I=0:}
procedure PMrandomize(I: word);  {initializes the randomizer}

{for functions PMrandom, Rrand, and Irand,}
{all returned values in the range given are equally probable}

{the basic routine:}
function PMrandom: longint;  {returns 1 <= X <= MaxLongint} far;

{for real values:}
function Rrand: extended;       {returns 0.0 < X < 1.0}

{for subrange integers:}
function Irand(N: word): word;      {returns 0 <= X < N}

{for random booleans:}
function Brand(P: extended): boolean;       {returns true with probability P}

{ approximately normal distribution }
{ with mean = 0 and standard deviation = 1: }
function Nrand: extended;       {actual range is -6 .. 6}

{*******************************************************}

implementation

var
    S: longint;     {seed, random state}
const
    M = 2147483647; {MaxLongint}
    A = 16807;
    Q = 127773;
    R = 2836;

{*******************************************************}

procedure PMrandomize(I: word); {initializes the randomizer}
begin
    if I <> 0 then S:= I
    else begin
        System.Randomize;
        S:= System.RandSeed;
    end;
    S:= S and M;
    if S = 0 then inc(S);
end; {PMrandomize}

{*******************************************************}

function PMrandom: longint; {returns 1 <= X <= MaxLongint}
var
    Lo, Hi, T: longint;
begin
    Hi:= S div Q;
    lo:= S mod Q;
    T:= A*Lo - R*Hi;
    if T > 0
    then S:= T
    else S:= T+M;
    PMrandom:= S;
end; {PMrandom}

{*******************************************************}

function Rrand: extended;       {returns 0.0 < X < 1.0}
begin
    Rrand:= PMrandom / 2147483647.0;
end; {Rrand}

{*******************************************************}
function Irand(N: word): word;      {returns 0 <= X < N}
var L: longint;
begin
    L:= PMrandom mod N;
    Irand:= L;
end; {Irand}

{*******************************************************}

function Brand(P: extended): boolean;   {returns true with probability P}
begin
    Brand:= (PMrandom / 2147483647.0 < P);
end; {Brand}

{*******************************************************}

{-------------------------------------------------------}
{   Here, we use the fact that the sum of N Rrand       }
{   values has a mean value of N/2 and a variance       }
{   of N/12, and is normally distributed for 'large'    }
{   N.  It is convenient to choose N = 12.              }
{-------------------------------------------------------}

{ approximately normal distribution }
{ with mean = 0 and standard deviation = 1: }
function Nrand: extended;
var
    I: integer;
    S: extended;
begin
    S:= -6.0;
    for I:= 1 to 12 do begin
        S:= S + (PMrandom / 2147483647.0);  { + Rrand}
    end;
    Nrand:= S;
end; {Nrand}

{*******************************************************}

begin
    PMrandomize(0);
end.

