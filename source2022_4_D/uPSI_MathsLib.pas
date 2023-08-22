unit uPSI_MathsLib;
{
   just another big box   - add 4 functions  + unit U_Invertedtext;
   TPrimes CanonicalFactors add array of TPoint64 - 47520    second fix TInt64PointArray
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_MathsLib = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPrimes(CL: TPSPascalCompiler);
procedure SIRegister_MathsLib(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPrimes(CL: TPSRuntimeClassImporter);
procedure RIRegister_MathsLib_Routines(S: TPSExec);
//  RIRegister_TPrimes(CL);


procedure Register;

implementation


uses
   Windows
  ,Dialogs
 // ,UBigIntsV4
  ,MathsLib , uGeometry , Math, StdCtrls, graphics;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MathsLib]);
end;

type TMercScalingRec= record
    BaseDeg:TRealPoint; {base long/lat for Mercator scaling}
    BasePix:TPoint;   {base pixel x/y coordinates for scaling}
    scalex,scaley:extended; {calculated scaling factors for converting between pixel and degree coordinates}
  end;


function MercScaling(Long0,lat0, long1, lat1:extended; x0,y0,x1,y1:integer) :TMercScalingRec;
  {In order to accurately plot lat-long points on a Mercator projection map
   we need two sets of pixel and lat/long coordinates for two known points from
   which scaling factors can be computed.  Data are stroed in a TMercScalingrec record}
begin
  with result do begin
    basedeg.x:=GetLongToMercProjection(long1);
    basedeg.y:=GetLatToMercProjection(lat1);
    BasePix.x:=x1;
    basePix.y:=y1;
    ScaleX:=(BasePix.x-x0)/(Basedeg.x-getLongtoMercProjection(long0));
    ScaleY:=(BasePix.y-y0)/(BaseDeg.y-getLatToMercProjection(lat0));
  end;
end;


{************** LongLatToPlotPt ***********8}
function LonglatToPlotPt(Long,lat:Extended; Scalerec:TMercScalingrec):TPoint;
var
  mlat,mlong:extended;
begin
  with scalerec do begin
    MLong:=GetLongToMercProjection(long);
    Mlat:=GetLatToMercProjection(lat);
    result.x:=Basepix.x+trunc(scalex*(MLong-BaseDeg.x));
    result.y:=Basepix.y+trunc(scaley*(Mlat-BaseDeg.y));
  end;
end;

{**************** PlotPtToLongLat *************}
function PlotPtToLonglat(PlotPt:TPoint; Scalerec:TMercScalingrec):TRealPoint;
var
  mlat,mlong:extended;
begin
  with scalerec do begin
    MLong:=BaseDeg.x-(BasePix.x-plotpt.x)/scalex;
    MLat:=BaseDeg.y-(BasePix.y-plotpt.y)/scaley;
    result.x:=GetMercProjectionToLong(MLong);
    result.y:=GetMercProjectionToLat(Mlat);
  end;
end;

{************* SphericalEarthDistance ****************}
function SphericalEarthDistance(lat1,lon1,lat2,lon2:extended; Units:integer):extended;
{Distance between to points assuming spherical earth}
{"Units" values: 0 = miles, 1 = kilometers, 2 = nautical miles}
 var
   theta:extended;
 begin
   theta := lon1 - lon2;
   result:= Sin(deg2rad(lat1)) * Sin(deg2rad(lat2))
   + Cos(deg2rad(lat1)) * Cos(deg2rad(lat2)) * Cos(deg2rad(theta));
   result := rad2deg(Arccos(result))*60*1.1515; 
   {miles per degree (24872 mile circumference)}
   if units=1 then result := result * 1.609344 {miles to kilometers}
   else if units=2 then result := result * 0.8684; {miles to nautical miles}
 end;

 {************* MemoTextFixUp **************}
 Procedure MemoTextFixUp(memo:TMemo {var text:string});
  var
  s:string;
  eol:boolean;
  i:integer;
  begin
  {This attempts to fix-up Tmemo text by removing Carriage Return/LineFeed
   (CR/LF)pairs inserted by Delphi at design time.  When you enter text into
   the Lines property at design time,  Delphi (incorrectly, in my opinion)
   inserts CR/LF at the end of each line. If WordWrap property is set to true,
   each displayed lines will break as required even if windows size or font is
   changed. This is not the case with hard breaks inserted by Delphi

   Unfortunately, breaks entered by Delphi cannot be distinguished from those
   you might have entered as paragraph breaks.  This fix recongizes two successive
   line breaks  (CR/LF/CR/LF) as a user defined paragraph.  Thus leaves a blank
   line between paragraphs.  Single CRLF pairs are assumed to have been inserted
   by Delphi and are deleted}

  s:=memo.text;
  i:=length(s);
  while i>=1 do
  begin
    if (i>=4) and (s[i]=#10)  and (not eol) then
    begin
      if (copy(s,i-3,4) = #13#10#13#10)
      then dec(i,4) {double carriage control - keep them}
      else
      begin {delete CR and LF pair because it was probably inserted by Delphi IDE}
        delete(s,i,1);
        dec(i);
        if (s[i]=#13) then
        begin
          delete(s,i,1);
          dec(i);
        end;
        eol:=true;
      end;
    end
    else eol:=false;
    dec(i);
  end;
  memo.text:=s;
end;

var lineheight:integer;

{************* InitInvertedtext ************}
 procedure initInvertedText(canvas:TCanvas; pagewidth,pageheight:integer);

 {Initialize the image canvas font to be rotated by 180 degrees}
 var
   tm:TextMetric;
   LogRec: TLOGFONT;
begin
  with  canvas do
  begin
    gettextmetrics(handle,tm);
    with TM do
    Lineheight := tmheight+tmexternalLeading; {my best guess for line separation pixels}
    brush.style:=bsClear; {required for rotated text}
    GetObject(Font.Handle, SizeOf(LogRec),Addr(LogRec)); {get font info}
    LogRec.lfEscapement := 1800;  {change escapement to 180 degrees}
    Font.Handle := CreateFontIndirect(LogRec ); {And send it back to the font}
  end;
end;

{******************** DrawInvertedText ***************}
  procedure DrawInvertedText(Canvas:TCanvas; pagewidth,pageheight:integer; linenbr:integer; s:string);
  {uses Lineheight value set by InitInvertedText proceudre}
  begin
    with canvas do TextOut(pagewidth-10,pageheight  - (linenbr-1)*Lineheight ,s);
  end;


  procedure SortString(var SortSt : ansistring);
 {sort the potential first letters ansistring in ascending sequence}
   var
     InOrder: Boolean;
     I: Integer;
     C: Char;
   begin
     If length(sortst)>0 then
     {exchange sort - swap out-of-order pairs until no more swaps needed}
     repeat
       Inorder := True;
       for I := 1 to Length(SortSt)-1 do
       if Ord(SortSt[I]) > Ord(SortSt[I+1]) then begin
         {swap letters I and I+1}
         Inorder := False;
         c:=sortst[i];
         sortst[i]:=sortst[i+1];
         sortst[i+1]:=c;
       end;
     until InOrder;
   end; { procedure SortString }





  //Type  TInt64Array = array of int64;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPrimes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPrimes') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPrimes') do begin
    RegisterProperty('Prime', 'TInt64Array', iptrw);
    RegisterProperty('nbrprimes', 'integer', iptrw);
    RegisterProperty('nbrfactors', 'integer', iptrw);
    RegisterProperty('nbrcanonicalfactors', 'integer', iptrw);
    RegisterProperty('nbrdivisors', 'integer', iptrw);
    RegisterProperty('Factors', 'TInt64Array', iptrw);
    RegisterProperty('CanonicalFactors', 'TInt64PointArray', iptrw);
    RegisterProperty('Divisors', 'TInt64Array', iptrw);
    RegisterMethod('Function GetNextPrime( n : int64) : int64');
    RegisterMethod('Function GetPrevPrime( n : int64) : int64');
    RegisterMethod('Function IsPrime( n : int64) : boolean');
    RegisterMethod('Procedure GetFactors( const n : int64)');
    RegisterMethod('Function MaxPrimeInTable : int64');
    RegisterMethod('Function GetNthPrime( const n : integer) : int64');
    RegisterMethod('Procedure GetCanonicalFactors( const n : int64)');
    RegisterMethod('Procedure GetDivisors( const n : int64)');
    RegisterMethod('Function Getnbrdivisors( n : int64) : integer');
    RegisterMethod('Function radical( n : int64) : int64');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
 end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MathsLib(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('intset', 'set of byte');
  CL.AddTypeS('TPoint64', 'record x : int64; y : int64; end');
  CL.AddTypeS('TInt64Array', 'array of int64');
  CL.AddTypeS('TInt64PointArray', 'array of TPoint64');
  CL.AddTypeS('TrealPoint', 'record x : extended; y : extended; end');
  CL.AddTypeS('TMercScalingRec', 'record BaseDeg:TRealPoint; BasePix:TPoint; scalex,scaley:extended; end');

 CL.AddDelphiFunction('Function GetNextPandigital( size : integer; var Digits : array of integer) : boolean');
 CL.AddDelphiFunction('Function IsPolygonal( T : int64; var rank : array of integer) : boolean');
 CL.AddDelphiFunction('Function GeneratePentagon( n : integer) : integer');
 CL.AddDelphiFunction('Function IsPentagon( p : integer) : boolean');
 CL.AddDelphiFunction('Function isSquare( const N : int64) : boolean');
 CL.AddDelphiFunction('Function isCube( const N : int64) : boolean');
 CL.AddDelphiFunction('Function isPalindrome( const n : int64) : boolean;');
 CL.AddDelphiFunction('Function isPalindrome1( const n : int64; var len : integer) : boolean;');
 CL.AddDelphiFunction('Function GetEulerPhi( n : int64) : int64');
 CL.AddDelphiFunction('function isprime(f: int64): boolean;');

 CL.AddDelphiFunction('Function dffIntPower( a, b : int64) : int64;');
 CL.AddDelphiFunction('Function IntPower1( a : extended; b : int64) : extended;');
 CL.AddDelphiFunction('Function gcd2( a, b : int64) : int64');
 CL.AddDelphiFunction('Function GCDMany( A : array of integer) : integer');
 CL.AddDelphiFunction('Function LCMMany( A : array of integer) : integer');
 CL.AddDelphiFunction('Procedure ContinuedFraction( A : array of int64; const wholepart : integer; var numerator, denominator : int64)');
 CL.AddDelphiFunction('Function dffFactorial( n : int64) : int64');
 CL.AddDelphiFunction('Function digitcount( n : int64) : integer');
 CL.AddDelphiFunction('Function nextpermute( var a : array of integer) : boolean');
 CL.AddDelphiFunction('Function convertfloattofractionstring( N : extended; maxdenom : integer; multipleof : boolean) : string');
 CL.AddDelphiFunction('Function convertStringToDecimal( s : string; var n : extended) : Boolean');
 CL.AddDelphiFunction('Function InttoBinaryStr( nn : integer) : string');
 CL.AddDelphiFunction('Function StrtoAngle( const s : string; var angle : extended) : boolean');
 CL.AddDelphiFunction('Function AngleToStr( angle : extended) : string');
 CL.AddDelphiFunction('Function deg2rad( deg : extended) : extended');
 CL.AddDelphiFunction('Function rad2deg( rad : extended) : extended');
 CL.AddDelphiFunction('Function GetLongToMercProjection( const long : extended) : extended');
 CL.AddDelphiFunction('Function GetLatToMercProjection( const Lat : Extended) : Extended');
 CL.AddDelphiFunction('Function GetMercProjectionToLong( const ProjLong : extended) : extended');
 CL.AddDelphiFunction('Function GetMercProjectionToLat( const ProjLat : extended) : extended');
  SIRegister_TPrimes(CL);
  //RIRegister_TPrimes(CL);
  CL.AddDelphiFunction('function MercScaling(Long0,lat0, long1, lat1:extended; x0,y0,x1,y1:integer) :TMercScalingRec');
 CL.AddDelphiFunction('function LonglatToPlotPt(Long,lat:Extended; Scalerec:TMercScalingrec):TPoint');
 CL.AddDelphiFunction('function PlotPtToLonglat(PlotPt:TPoint; Scalerec:TMercScalingrec):TRealPoint');
 CL.AddDelphiFunction('Function SphericalEarthDistance(lat1,lon1,lat2,lon2:extended; Units:integer):extended');

 //CL.AddConstantN('deg','LongInt').SetInt( char( 176));
 CL.AddConstantN('minmark','LongInt').SetInt(( 180));
 CL.AddDelphiFunction('Function Random64( const N : Int64) : Int64;');
 CL.AddDelphiFunction('Procedure Randomize64');
 CL.AddDelphiFunction('Function Random641 : extended;');

 CL.AddDelphiFunction('procedure InitInvertedText(canvas:TCanvas; pagewidth,pageheight:integer);');
 CL.AddDelphiFunction('procedure DrawInvertedText(Canvas:TCanvas; pagewidth,pageheight:integer; linenbr:integer; s:string);');
 CL.AddDelphiFunction('Procedure MemoTextFixUp(memo:TMemo {var text:string});');
 CL.AddDelphiFunction('procedure SortString(var SortSt : ansistring)');

 //  procedure DrawInvertedText(Canvas:TCanvas; pagewidth,pageheight:integer; linenbr:integer; s:string);
  // Procedure MemoTextFixUp(memo:TMemo {var text:string});

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function Random641_P : extended;
Begin Result := MathsLib.Random64; END;

(*----------------------------------------------------------------------------*)
Function Random64_P( const N : Int64) : Int64;
Begin //Result := MathsLib.Random64(N);
END;

(*----------------------------------------------------------------------------*)
procedure TPrimesDivisors_W(Self: TPrimes; const T: TInt64Array{array of int64});
Begin Self.Divisors := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesDivisors_R(Self: TPrimes; var T: TInt64Array{array of int64});
Begin T := Self.Divisors;
end;

//type TInt64PointArray = array of TPoint64;

(*----------------------------------------------------------------------------*)
procedure TPrimesCanonicalFactors_W(Self: TPrimes; const T: TInt64PointArray);
Begin Self.CanonicalFactors := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesCanonicalFactors_R(Self: TPrimes; var T: TInt64PointArray);
Begin T := Self.CanonicalFactors;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesFactors_W(Self: TPrimes; const T: TInt64Array);
Begin Self.Factors := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesFactors_R(Self: TPrimes; var T: TInt64Array);
Begin T := Self.Factors;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrdivisors_W(Self: TPrimes; const T: integer);
Begin Self.nbrdivisors := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrdivisors_R(Self: TPrimes; var T: integer);
Begin T := Self.nbrdivisors; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrcanonicalfactors_W(Self: TPrimes; const T: integer);
Begin Self.nbrcanonicalfactors := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrcanonicalfactors_R(Self: TPrimes; var T: integer);
Begin T := Self.nbrcanonicalfactors; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrfactors_W(Self: TPrimes; const T: integer);
Begin Self.nbrfactors := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrfactors_R(Self: TPrimes; var T: integer);
Begin T := Self.nbrfactors; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrprimes_W(Self: TPrimes; const T: integer);
Begin Self.nbrprimes := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesnbrprimes_R(Self: TPrimes; var T: integer);
Begin T := Self.nbrprimes; end;

(*----------------------------------------------------------------------------*)
procedure TPrimesPrime_W(Self: TPrimes; const T: TInt64Array{array of int64});
Begin Self.Prime := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPrimesPrime_R(Self: TPrimes; var T: TInt64Array{array of int64});
Begin T := Self.Prime;
end;

(*----------------------------------------------------------------------------*)
Function IntPower1_P( a : extended; b : int64) : extended;
Begin Result := MathsLib.IntPower(a, b); END;

(*----------------------------------------------------------------------------*)
Function IntPower_P( a, b : int64) : int64;
Begin Result := MathsLib.IntPower(a, b); END;

(*----------------------------------------------------------------------------*)
Function isPalindrome1_P( const n : int64; var len : integer) : boolean;
Begin Result := MathsLib.isPalindrome(n, len); END;

(*----------------------------------------------------------------------------*)
Function isPalindrome_P( const n : int64) : boolean;
Begin Result := MathsLib.isPalindrome(n); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPrimes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPrimes) do begin
    RegisterPropertyHelper(@TPrimesPrime_R,@TPrimesPrime_W,'Prime');
    RegisterPropertyHelper(@TPrimesnbrprimes_R,@TPrimesnbrprimes_W,'nbrprimes');
    RegisterPropertyHelper(@TPrimesnbrfactors_R,@TPrimesnbrfactors_W,'nbrfactors');
    RegisterPropertyHelper(@TPrimesnbrcanonicalfactors_R,@TPrimesnbrcanonicalfactors_W,'nbrcanonicalfactors');
    RegisterPropertyHelper(@TPrimesnbrdivisors_R,@TPrimesnbrdivisors_W,'nbrdivisors');
    RegisterPropertyHelper(@TPrimesFactors_R,@TPrimesFactors_W,'Factors');
    RegisterPropertyHelper(@TPrimesCanonicalFactors_R,@TPrimesCanonicalFactors_W,'CanonicalFactors');
    RegisterPropertyHelper(@TPrimesDivisors_R,@TPrimesDivisors_W,'Divisors');
    RegisterMethod(@TPrimes.GetNextPrime, 'GetNextPrime');
    RegisterMethod(@TPrimes.GetPrevPrime, 'GetPrevPrime');
    RegisterMethod(@TPrimes.IsPrime, 'IsPrime');
    RegisterMethod(@TPrimes.GetFactors, 'GetFactors');
    RegisterMethod(@TPrimes.MaxPrimeInTable, 'MaxPrimeInTable');
    RegisterMethod(@TPrimes.GetNthPrime, 'GetNthPrime');
    RegisterMethod(@TPrimes.GetCanonicalFactors, 'GetCanonicalFactors');
    RegisterMethod(@TPrimes.GetDivisors, 'GetDivisors');
    RegisterMethod(@TPrimes.Getnbrdivisors, 'Getnbrdivisors');
    RegisterMethod(@TPrimes.radical, 'radical');
    RegisterConstructor(@TPrimes.Create, 'Create');
    RegisterMethod(@TPrimes.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MathsLib_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetNextPandigital, 'GetNextPandigital', cdRegister);
 S.RegisterDelphiFunction(@IsPolygonal, 'IsPolygonal', cdRegister);
 S.RegisterDelphiFunction(@GeneratePentagon, 'GeneratePentagon', cdRegister);
 S.RegisterDelphiFunction(@IsPentagon, 'IsPentagon', cdRegister);
 S.RegisterDelphiFunction(@isSquare, 'isSquare', cdRegister);
 S.RegisterDelphiFunction(@isCube, 'isCube', cdRegister);
 S.RegisterDelphiFunction(@isPrime, 'isPrime', cdRegister);

 S.RegisterDelphiFunction(@isPalindrome, 'isPalindrome', cdRegister);
 S.RegisterDelphiFunction(@isPalindrome1_P, 'isPalindrome1', cdRegister);
 S.RegisterDelphiFunction(@GetEulerPhi, 'GetEulerPhi', cdRegister);
 S.RegisterDelphiFunction(@IntPower, 'dffIntPower', cdRegister);
 S.RegisterDelphiFunction(@IntPower1_P, 'IntPower1', cdRegister);
 S.RegisterDelphiFunction(@gcd2, 'gcd2', cdRegister);
 S.RegisterDelphiFunction(@GCDMany, 'GCDMany', cdRegister);
 S.RegisterDelphiFunction(@LCMMany, 'LCMMany', cdRegister);
 S.RegisterDelphiFunction(@ContinuedFraction, 'ContinuedFraction', cdRegister);
 S.RegisterDelphiFunction(@Factorial, 'dffFactorial', cdRegister);
 S.RegisterDelphiFunction(@digitcount, 'digitcount', cdRegister);
 S.RegisterDelphiFunction(@nextpermute, 'nextpermute', cdRegister);
 S.RegisterDelphiFunction(@convertfloattofractionstring, 'convertfloattofractionstring', cdRegister);
 S.RegisterDelphiFunction(@convertStringToDecimal, 'convertStringToDecimal', cdRegister);
 S.RegisterDelphiFunction(@InttoBinaryStr, 'InttoBinaryStr', cdRegister);
 S.RegisterDelphiFunction(@StrtoAngle, 'StrtoAngle', cdRegister);
 S.RegisterDelphiFunction(@AngleToStr, 'AngleToStr', cdRegister);
 S.RegisterDelphiFunction(@deg2rad, 'deg2rad', cdRegister);
 S.RegisterDelphiFunction(@rad2deg, 'rad2deg', cdRegister);
 S.RegisterDelphiFunction(@GetLongToMercProjection, 'GetLongToMercProjection', cdRegister);
 S.RegisterDelphiFunction(@GetLatToMercProjection, 'GetLatToMercProjection', cdRegister);
 S.RegisterDelphiFunction(@GetMercProjectionToLong, 'GetMercProjectionToLong', cdRegister);
 S.RegisterDelphiFunction(@GetMercProjectionToLat, 'GetMercProjectionToLat', cdRegister);
//  RIRegister_TPrimes(CL);
 S.RegisterDelphiFunction(@Random64, 'Random64', cdRegister);
 S.RegisterDelphiFunction(@Randomize64, 'Randomize64', cdRegister);
 S.RegisterDelphiFunction(@Random641_P, 'Random641', cdRegister);
 S.RegisterDelphiFunction(@MercScaling, 'MercScaling', cdRegister);
 S.RegisterDelphiFunction(@LonglatToPlotPt, 'LonglatToPlotPt', cdRegister);
 S.RegisterDelphiFunction(@PlotPtToLonglat, 'PlotPtToLonglat', cdRegister);
 S.RegisterDelphiFunction(@SphericalEarthDistance, 'SphericalEarthDistance', cdRegister);
 S.RegisterDelphiFunction(@InitInvertedText, 'InitInvertedText', cdRegister);
 S.RegisterDelphiFunction(@DrawInvertedText, 'DrawInvertedText', cdRegister);
 S.RegisterDelphiFunction(@MemoTextFixUp, 'MemoTextFixUp', cdRegister);
 S.RegisterDelphiFunction(@SortString, 'SortString', cdRegister);

 {function MercScaling(Long0,lat0, long1, lat1:extended; x0,y0,x1,y1:integer) :TMercScalingRec');
 function LonglatToPlotPt(Long,lat:Extended; Scalerec:TMercScalingrec):TPoint');
 function PlotPtToLonglat(PlotPt:TPoint; Scalerec:TMercScalingrec):TRealPoint');
 Function SphericalEarthDistance(lat1,lon1,lat2,lon2:extended; Units:integer):extended');  }

end;

 
 
{ TPSImport_MathsLib }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MathsLib.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MathsLib(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MathsLib.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_MathsLib(ri);
  RIRegister_MathsLib_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
