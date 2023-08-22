unit UIntegerpartition;
 {Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

(*
  A class defintion which will calculate "integer partition" information.
  Each partition is kept as a TPartiton record, an array of integers, named P.

  A default instance of TIntpartition, named Defpartition, is created at
  initialization time for user use.

  Procedure PartitionInit is passed an integer to partition and a partition size.
  (Pass 0 to indicate that all sizes are to be created.)  Also pass the name of
  a user defined callback function to be called for each partition created.
  The function should return true to indicate that porcessing is to continue, return
  false to indicate that no more parititions are required.

     add     TIntegerArray

*)

interface

type
  TCallback=function:boolean of Object;
  Tpartition=array of int64;
  NTableArray=array of array of int64;
  type  TIntegerArray = array of integer;

  TIntPartition= class(Tobject)

    private
      X:array of integer;
      Integersize:integer ;
      ReturnAll:Boolean;
      M,H:integer;
      Callback:TCallback;
      procedure DoCoLex;
    public
      P:TIntegerArray;
      Partsize:integer;
      PCount:int64; {the total number of partitionings}
      //stopflag:boolean;  {Flag set to false by PartitionMaxval to allow option for
      //                   caller to set it (via timer exit) and interrupt long
      //                   calculation Maxval calculation}
      function NPart_Table(const N,Npart:integer):int64; overload;
      function NPart_Table(N,Npart:integer; var p:NTableArray):int64; overload;
      function Part_Table(const N:integer):int64;
      procedure PartitionInit(newInteger,NewPartsize:integer;NewCallback:TCallback);
      function PartitionMaxval(FirstN,k:integer;target:int64;newcallback:TCallback):boolean;
      function partitioncount(n,m:integer):int64;
      function Unrank(N, NPart, Rank:Integer):boolean;


  end;

  var
    Defpartition:TIntPartition;

implementation

{------ Min function (if Delphi Math unit is not available -----}
function min(const a,b:integer):integer;
begin
  if a<=b then result:=a else result:=b;
end;


{************** DoCoLex *********}
Procedure TIntPartition.DoColex;
{Generate integer partitions in reverse lexicographical order}
var
  i,j:integer;
  r,t:integer;
  sum:int64;
begin
  X[0]:=integersize;
  Pcount:=0;
  setLength(P,integersize);
  m:=0;
  h:=0;
  if (partsize=0) or (partsize=1) then
  begin {initial 1 element partition}
    partsize:=1;
    setlength(p,1);
    p[0]:=x[0];
    Pcount:=1;
    if assigned(callback) then Callback;
  end;
  while x[0]<>1 do  {repeat until returned partitions starts with 1 ==> all 1's}
  begin
    if x[h]=2 then
    begin
      inc(m);
      x[h]:=1;
      dec(h);
    end
    else
    begin
      r:=x[h]-1;
      t:=m-h+1;
      x[h]:=r;
      while t>=r do
      begin
        inc(h);
        x[h]:=r;
        dec(t,r);
      end;
      if t=0 then m:=h
      else m:=h+1;
      if t>1 then
      begin
        inc(h);
        x[h]:=t;
      end;
    end;
    sum:=0;;
    for i:=0 to integersize-1 do
    begin

      inc(sum,x[i]);
      if sum=integersize then
      if returnall or (partsize=i+1) then
      begin
        setlength(p,i+1);
        Partsize:=i+1;
        for j:= 0 to partsize-1 do p[j]:=x[j];
        inc(pcount);
        if assigned(callback) then if not callback then exit;
        break;
      end else
      else
      if sum>=integersize then break;
    end
  end;
end;


{************ PartitionInit **************}
procedure TIntPartition.PartitionInit(newInteger,NewPartsize:integer;
                                        NewCallback:TCallback);
{Pass NewpartSize=0 to return all partitions, values from 1 to NewInteger will return
 partitions with that number of elements.}
var
  i:integer;
begin
  Integersize:=newInteger;
  setlength(x,integersize);
  PartSize:=Newpartsize;
  if newpartsize=0 then returnall:=true else returnall:=false;
  for i:=0 to high(X) do X[i]:=1;
  Callback:=NewCallBack;
  doColex;
end;



{******************* PartitionMaxVall ***************}
function TIntpartition.PartitionMaxval(firstN,k:integer;target:int64;
                           newcallback:TCallback):boolean;
{initial call to recursive function PNK to generate all partitions of
 n  which have max value k.}
var
  nbr:int64;

      function PNK(n,k,level:integer):boolean;
      var j : integer;
      begin
        if (n=0) or (k=0) {or (stopFlag)} then
        begin
          result:=false;
          exit;
        end;
        result:=true;
        p[level-1]:= k;
        if n=k  then
        begin
          inc(nbr);
          //if (nbr and $3ff >0)  then application.processmessages;
          partsize:=level;
          setlength(p,partsize);
          (*
          if (target=0) {return all} or (nbr=target) {return only this partition}
          then
          if assigned(newcallback) then result:=newcallback
          else result:=false;

          *)
          if assigned(newcallback) then result:=newcallback
          else if (nbr=target) or (p[0]=1) then result:=false;
          if not result then exit;
        end;

        if result then for j := min( k, n-k ) downto 1 do
        begin
          {recursive call}
          result:=Pnk( n-k, {the value of the number remaining to partition,
                 e.g. if n=12 and k=5 then after adding 5 to the partiton,
                 we need to partition 7 in all possible ways to complete it}
                 j, {the new k value is the loop next value to try and must be
                 less than the previous addition to the partition, (n-k),  and
                 the previous j value e.g. for the n=12,k=5 case j=min(5,7)=5
                 when that recursion is complete, we'll try 4,3,2,1 or until
                 result returns false ==> no more to create at this level}
                 level+1); {the position of the next number to be added}
          setlength(p,firstN);
          if not result then break;
        end;
      end;
 begin
   {stopflag:=false; }
   nbr:=0;
   setlength(p,firstN);
   {call recursive routine to generate one or more partitions with a specific maximum value}
   result:= PNK(FirstN,k,1);
  end;


{******************** PartitionCount **************}
function TIntPartition.partitioncount(n,m:integer):int64;
{n=integer  value, m:=size of partition - pass 0 for sum of all partition sizes}
{Uses Fortran conversions of algorithms published by Kreher & Simpsom}
begin
  If m=0 then result:=Part_Table(n)
  else result:=NPart_Table(n,m);
  pcount:=result;
end;

{************* Part_Table ****************}
function TIntPartition.Part_Table(Const N:integer):int64;
 {PART_TABLE tabulates the number of partitions of N.}

 {Converted to Delphi from Fortran version.
 Fortran version written by John Burkardt based on
    Algorithm 3.6,
    Donald Kreher and Douglas Simpson,
    Combinatorial Algorithms,
    CRC Press, 1998, page 74.
}

{Original Fortran version has a subtle error that causes reults to occasionally be
 in error by +-1.  Fix here is to compute result for newn:=N+1 and return p[newn-1]}
var
  newn:integer;
  i,j:integer;
  p:array of int64;
  sign:integer;
  psum,w, wprime:int64;
begin
  newn:=n+1;
  setlength(p,Newn+1);
  p[0] := 1;
  p[1] := 1;
  for i:=2 to Newn do
  begin
    sign := 1;
    psum := 0;
    w := 1;
    j := 1;
    wprime := w + j;

    while ( w < newn ) do
    begin
      if  0<=( i - w )
      then if ( sign = 1 ) then psum := psum + p[i-w]
           else psum := psum - p[i-w];
      if ( wprime <= i )
      then if ( sign = 1 ) then psum := psum + p[i-wprime]
        else psum := psum - p[i-wprime];
      w := w + 3 * j + 1;
      inc(j);
      wprime := w + j;
      sign := - sign;
    end;
    p[i] := psum;
  end;
  result:=p[newn-1];
end;

{************** NPart_Table **************}
function TIntPartition.NPart_Table(N,Npart:integer; var p:NTableArray):int64;
{version which returns the array P as well as count.
 P will contain counts of number of partitions, J,  fron 1 to NPart which is
 also the number of partitionj with max size J }
var
  i,j:integer;

begin
  p[0,0] := 1;
  for i:= 1 to N do p[i,0]:=0;

  for i:= 1 to N do
    for j:=1 to NPart do
      if ( i < j ) then p[i,j] := 0
      else
      if (i < 2*j) then p[i,j] := p[i-1,j-1]
      else p[i,j] := p[i-1,j-1] + p[i-j,j];
  result:=p[n,npart];
end;

function TIntPartition.NPart_Table(Const N,Npart:integer):int64;
{NPART_TABLE tabulates the number of partitions of N having NPART parts.}

 {Converted to Delphi from Fortran version.
 Fortran version written by John Burkardt based on
    Algorithm 3.5,
    Donald Kreher and Douglas Simpson,
    Combinatorial Algorithms,
    CRC Press, 1998, page 72.
}
var
  pp:NTableArray;
begin
  setlength(pp,N+1,NPART+1);
  result:=Npart_table(N,Npart,PP);
end;

{************** UnRank ***************}
Function TIntPartition.Unrank(N, NPart, Rank:Integer):boolean;
{Compute partition nbr "rank" in colex sequence}
var
  i:integer;
  pp:NTableArray;
  rankcopy,Ncopy, NPartCopy:integer;
begin
  result:=true;
  setlength(PP, N+1, Npart+1);
  setLength(P,Npart+1);
  for i:=0 to npart do p[i]:=0;
  npart_table ( n, npart, pp );
  rankcopy := rank;
  ncopy := n;
  npartcopy := npart;
  while ( 0 < ncopy ) do
  begin
    if ( rankcopy < pp[ncopy-1,npartcopy-1] ) then
    begin
      p[npart+1-npartcopy] := p[npart+1-npartcopy] + 1;
      ncopy := ncopy - 1;
      npartcopy := npartcopy - 1;
    end
    else
    begin
      for i := 1 to npartcopy  do
      p[npart+1-i] := p[npart+1-i] + 1;
      rankcopy := rankcopy - pp[ncopy-1,npartcopy-1];
      ncopy := ncopy - npartcopy;
    end;
  end;

end;

(*  //for reference, but not converted for use here
subroutine npart_rsf_lex_unrank ( rank, n, npart, a )

!*******************************************************************************
!
!! NPART_RSF_LEX_UNRANK unranks an RSF NPART partition in the lex ordering.
!
!  Modified:
!
!    03 April 2001
!
!  Author:
!
!    John Burkardt
!
!  Reference:
!
!    Algorithm 3.9,
!    Donald Kreher and Douglas Simpson,
!    Combinatorial Algorithms,
!    CRC Press, 1998, page 78.
!
!  Parameters:
!
!    Input, integer RANK, the rank of the partition.
!
!    Input, integer N, the integer to be partitioned.
!    N must be positive.
!
!    Input, integer NPART, the number of parts of the partition.
!    1 <= NPART <= N.
!
!    Output, integer A(NPART), contains the partition.
!    A(1) through A(NPART) contain the nonzero integers which
!    sum to N.
!
  implicit none

  integer n
  integer npart

  integer a(npart)
  integer i
  integer ncopy
  integer npartcopy
  integer npartitions
  integer p(0:n,0:npart)
  integer rank
  integer rankcopy
!
!  Check.
!
  if ( n <= 0 ) then
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) 'NPART_RSF_LEX_UNRANK - Fatal error!'
    write ( *, '(a)' ) '  The input N is illegal.'
    stop
  end if

  if ( npart < 1 .or. n < npart ) then
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) 'NPART_RSF_LEX_UNRANK - Fatal error!'
    write ( *, '(a)' ) '  The input NPART is illegal.'
    stop
  end if

  call npart_enum ( n, npart, npartitions )

  if ( rank < 0 .or. npartitions < rank ) then
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) 'NPART_RSF_LEX_UNRANK - Fatal error!'
    write ( *, '(a)' ) '  The input rank is illegal.'
    stop
  end if
!
!  Get the table of partitions of N with NPART parts.
!
  call npart_table ( n, npart, n, p )

  a(1:npart) = 0

  rankcopy = rank
  ncopy = n
  npartcopy = npart

  do while ( 0 < ncopy )

    if ( rankcopy < p(ncopy-1,npartcopy-1) ) then
      a(npart+1-npartcopy) = a(npart+1-npartcopy) + 1
      ncopy = ncopy - 1
      npartcopy = npartcopy - 1
    else
      do i = 1, npartcopy
        a(npart+1-i) = a(npart+1-i) + 1
      end do
      rankcopy = rankcopy - p(ncopy-1,npartcopy-1)
      ncopy = ncopy - npartcopy
    end if

  end do

  return
end
*)


initialization {create a default partition class instance}
  DefPartition:=TIntPartition.create;
finalization   {free it when program exits}
  Defpartition.free;

end.
