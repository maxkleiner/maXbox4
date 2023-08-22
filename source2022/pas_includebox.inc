(*{****************************************************************
 *
 * Project  : Base Include RunTime Lib for maXbox
 * Name     : pas_includebox.inc  - 3.9.6
 * Purpose  : function module to include in apps
 * Date     : 09/29/2012 -  19:38:56, loc's = 630
 * Example  : {$I ..\maxbox3\pas_includebox.inc}
 * History  : translate and integrate to maXbox June 2009
 *          : binLib with hex&bin, showinterfaces extended 2010
 *          : CheckStringSum, SaveCanvas2, ShowGraphic, Polygon, typecheck, Regression, StrToBytes
 ****************************************************************}*)
// include it with {$I ..\maxbox3\pas_includebox.inc}
// corr. of function BinToInt(Binary: String): Integer; (IntToBin)

//const hValue = '010310260002'; 
//var myCRC: string;

//{$DEFINE LINUX}

const
  CHS = '0123456789abcdefghijklmnopqrstuvwxyz';

type
  Str002 = string;

  TXYVector = array of TPoint; 
  
//lib_cat_signatures:
{procedure drawPolygon(vPoints: TXYVector; cFrm: TForm);
procedure drawPlot(vPoints: TXYVector; cFrm: TForm; vcolor: integer);
procedure SaveCanvas(vCanvas: TCanvas; FileName: string);
procedure SaveCanvas2(vCanvas: TCanvas; FileName: string);
function CheckStringSum(vstring: string): integer;
function HexToInt(HexNum: string): LongInt;
function IntToBin(Int: Integer): String;
function BinToInt(Binary: String): Integer;
function HexToBin(HexNum: string): string; external2
function BinToHex(Binary: String): string;
function IntToFloat(i: Integer): double;
function AddThousandSeparator(S: string; myChr: Char): string;
function Max3(const X,Y,Z: Integer): Integer;
procedure Swap(var X,Y: char); // faster without inline
procedure ReverseString(var S: String);
function CharToHexStr(Value: Char): string;
function CharToUniCode(Value: Char): string;
function Hex2Dec(Value: Str002): Byte;
function HexStrCodeToStr(Value: string): string;
function HexToStr(i: integer; value: string): string;
function UniCodeToStr(Value: string): string;
function CRC16(statement: string): string;
function SearchForSubstrings(aStrList: TStrings;
                  aSearchStr1, aSearchStr2: string): string;
procedure SearchAndReplace(aStrList: TStrings; aSearchStr, aNewStr: string);
procedure ShowInterfaces(myFile: string);
function Fact2(av: integer): extended;
Function BoolToStr(B: Boolean): string;
function GetASCII: string;
function ByteIsOk(const AByte: string; var VB: Byte): boolean;
function WordIsOk(const AWord: string; var VW: Word): boolean;
function TwentyFourBitValueIsOk(const AValue: string; var VI: Integer): boolean;
function LongIsOk(const ALong: string; var VC: Cardinal): boolean;
function SafeStr(const s: string): string;
function ExtractUrlPath(const FileName: string): string;
function ExtractUrlName(const FileName: string): string;
function IsInternet: boolean;
function RotateLeft1Bit_u32( Value: uint32): uint32;
procedure LinearRegression(const KnownY: array of Double; const KnownX: array of Double;
                      NData : Integer; var LF : TStLinEst; ErrorStats : Boolean);
procedure getEnvironmentInfo;
function StrToBytes(const Value: String): TBytes;
function BytesToStr(const Value: TBytes): String;
}

 (*TStLinEst = record
    B0, B1     : Double;   {model coefficients}
    seB0, seB1 : Double;   {standard error of model coefficients}
    R2         : Double;   {coefficient of determination}
    sigma      : Double;   {standard error of regression}
    SSr, SSe   : Double;   {elements for ANOVA table}
    F0         : Double;   {F-statistic to test B1=0}
    df         : Integer;  {denominator degrees of freedom for F-statistic}
  end;*)
  
function StrToBytes(const Value: String): TBytes;
var i: integer;
begin
  SetLength(result, Length(Value));
  for i:= 0 to Length(Value)-1 do
    result[i]:= Ord(Value[i+1])- 48;    //-48
end;


function BytesToStr(const Value: TBytes): String;
var I: integer;
    Letra: char;
begin
  result:= '';
  for I:= Length(Value)-1 Downto 0 do begin
    letra:= Chr(Value[I] + 48);
    result:= letra + result;
  end;
end;
  
 
procedure getEnvironmentInfo;
var
  List: TStringList;
  I: Integer;
begin
  List:= TStringList.Create;
  try
    GetEnvironmentVars(List, False);
    for I:= 0 to List.Count - 1 do
      Writeln(List[I]);
    //Readln;
  finally
    List.Free;
  end;
end;

procedure LinearRegression(const KnownY: array of Double; const KnownX: array of Double;
                      NData : Integer; var LF : TStLinEst; ErrorStats : Boolean);
var
  i : Integer;
  sx, sy, xmean, ymean, sxx, sxy, syy, x, y : Extended;
begin
  if (NData <= 2) then
    writeln('RaiseStatError(stscStatBadCount)');
  {compute basic sums}
  sx := 0.0;
  sy := 0.0;
  sxx := 0.0;
  sxy := 0.0;
  syy := 0.0;
  for i := 0 to NData-1 do begin
    //x := TDoubleArray(KnownX)[i];
    x:= KnownX[i];
    //y := TDoubleArray(KnownY)[i];
    y:= KnownY[i];
    sx := sx+x;
    sy := sy+y;
    sxx := sxx+x*x;
    syy := syy+y*y;
    sxy := sxy+x*y;
  end;
  xmean := sx/NData;
  ymean := sy/NData;
  sxx := sxx-NData*xmean*xmean;
  syy := syy-NData*ymean*ymean;
  sxy := sxy-NData*xmean*ymean;
  {check for zero variance}
  if (sxx <= 0.0) or (syy <= 0.0) then
    writeln('RaiseStatError(stscStatBadData)');
  {initialize returned parameters}
  //fillchar(LF, sizeof(LF), 0);

  {regression coefficients}
  LF.B1 := sxy/sxx;
  LF.B0 := ymean-LF.B1*xmean;
  {error statistics}
  if (ErrorStats) then begin
    LF.ssr := LF.B1*sxy;
    LF.sse := syy-LF.ssr;
    LF.R2 := LF.ssr/syy;
    LF.df := NData-2;
    LF.sigma := sqrt(LF.sse/LF.df);
    if LF.sse = 0.0 then
      {pick an arbitrarily large number for perfect fit}
      LF.F0 := 1.7e+308
    else
      LF.F0 := (LF.ssr*LF.df)/LF.sse;
    LF.seB1 := LF.sigma/sqrt(sxx);
    LF.seB0 := LF.sigma*sqrt((1.0/NData)+(xmean*xmean/sxx));
  end;
end;


 function IsInternet: boolean;
 begin
   if getHostbyName('www.ask.com') > '0' then
     result:= true
     else result:= false;
 end;     
   

 function ExtractUrlPath(const FileName: string): string;
 var
  I: Integer;
 begin
  I:= LastDelimiter('/:', FileName);
  Result:= Copy(FileName, 1, I);
 end;

 function ExtractUrlName(const FileName: string): string;
 var
 I: Integer;
 begin
  I:= LastDelimiter('/:', FileName);
  Result:= Copy(FileName, I + 1, 255);
 end; 

 function SafeStr(const s: string): string;
 var
   i: Longint;
 begin
   Result:= s;
   for i:= 1 to length(s) do begin
     //if s[i] in [#0..#31] then begin
     if ord(s[i]) < 31 then begin
      Result := Copy(s, 1, i-1);
      exit;
     end;
   end;
 end;

  function ByteIsOk(const AByte: string; var VB: Byte): boolean;
  var
    i: Integer;
  begin
    i:= StrToIntDef(AByte, -1);
    Result:= (i > -1) and (i < 256);
    if Result then VB:= Byte(i);
  end;

  function WordIsOk(const AWord: string; var VW: Word): boolean;
  var
    i: Integer;
  begin
    i:= StrToIntDef(AWord, -1);
    Result:= (i > -1) and (i < 65536);
    if Result then VW:= Word(i);
  end;

  function TwentyFourBitValueIsOk(const AValue: string; var VI: Integer): boolean;
  var
    i: Integer;
  begin
    i:= StrToIntDef(AValue, -1);
    Result:= (i > -1) and (i < 16777216);
    if Result then VI:= i;
  end;

  function LongIsOk(const ALong: string; var VC: Cardinal): boolean;
  var
    i: Int64;
  begin
    i:= StrToInt64Def(ALong, -1);
    Result:= (i > -1) and (i < 4294967296);
    if Result then VC:= Cardinal(i);
  end;


procedure drawPolygon(vPoints: TXYVector; cFrm: TForm);
var
  i, hsize: integer;
begin
  with cFrm.canvas do begin
    hsize:= cFrm.Height - 1 div 2;
    Pen.Color:= (clpurple);
    Pen.Width:= 70;
    //setZoomFact(high(chartdata), fileNameChart);
    //moveto(0, hsize -((vPoints[0].y)));
    cFrm.Canvas.MoveTo(vpoints[1].X, vpoints[1].Y);
    for i:= 0 to high(vPoints) do
      LineTo(vPoints[i].x, vPoints[i].y);
  end;
end;  

//In Delphi, False and True are an enumeration of a boolean set.
Function BoolToStr(B: Boolean): string;
var
  cTrueFalseStr: array [0..1] of String;
begin
  cTrueFalseStr[0]:= 'False';
  cTrueFalseStr[1]:= 'True';
 if B then
    Result:= cTrueFalseStr[1]
  else
    Result:= cTrueFalseStr[0];
end;

function GetASCII: string;
var i: integer;
begin
  for i:= 1 to 255 do
  result:= result +#13#10+ Format('This Number: %4d is this ASCII %2s',[i, Chr(i)])
end;  

function fact2(av: integer): extended;
begin
  result:= 1;
  while (av<>0) do begin 
    result:= result * av
    av:= av -1;
  end
end;  

procedure drawPlot(vPoints: TXYVector; cFrm: TForm; vcolor: integer);
var
  i, hsize: integer;
begin
  with cFrm.canvas do begin
    hsize:= cFrm.Height -1 div 2;
    Pen.Color:= vcolor;
    MoveTo(0, hsize -((round(vPoints[0].Y))));
    for i:= 0 to High(vPoints) do
      LineTo(i, round(vPoints[i].Y));
  end;
end;  

{$IFNDEF LINUX}
procedure SaveCanvas2(vCanvas: TCanvas; FileName: string);
var
  Bmp: TBitmap;
  bmp1: TLinearBitmap;
  MyRect: TRect;
begin
  Bmp:= TBitmap.Create;
  bmp1:= TLinearBitmap.create;
  try
    MyRect := vCanvas.ClipRect;
    Bmp.Width := MyRect.Right - MyRect.Left;
    Bmp.Height := MyRect.Bottom - MyRect.Top;
    Bmp.Canvas.CopyRect(MyRect, vCanvas, MyRect);
    bmp1.Assign(Bmp)
    Bmp1.SaveToFile(FileName);
  finally
    Bmp.Free;
    bmp1.Free;
  end;
end; 
{$ENDIF}

procedure SaveCanvas(vCanvas: TCanvas; FileName: string);
var
  Bmp: TBitmap;
  MyRect: TRect;
begin
  Bmp:= TBitmap.Create;
  try
    MyRect:= vCanvas.ClipRect;
    Bmp.Width:= MyRect.Right - MyRect.Left;
    Bmp.Height:= MyRect.Bottom - MyRect.Top;
    Bmp.Canvas.CopyRect(MyRect, vCanvas, MyRect);
    Bmp.SaveToFile(FileName);
  finally
    Bmp.Free;
  end;
end;

function CheckStringSum(vstring: string): integer;
var z, y, i: integer;
begin
 for i:= 1 to length(vstring) do begin 
   z:= strtoint(vstring[i])
   y:= y + z; 
 end;
 result:= y;
end;


function HexToInt(HexNum: string): LongInt;
begin
  Result:= StrToInt('$' + HexNum);
end;

function IntToBin(Int: Integer): String;
var
  i: integer;
begin
  Result:= '';
  for i:= 15 downto 0 do
  Result:= Result + IntToStr((Int shr i) and 1);
end;

function BinToInt(Binary: String): Integer;
var
  i: integer;
begin
  Result:= 0;
  if Length(Binary) > 0 then
    for i:= 1 to Length(Binary) do begin
    result:= result + result +(ord(Binary[i]) and 1);
  end  
end;

function HexToBin(HexNum: string): string;
begin
  Result:= IntToBin(HexToInt(HexNum));
end;

function BinToHex(Binary: String): string;
begin
  Result:= IntToHex(BinToInt(binary),8)
end;  

{function BinToInt(Binary: String): Integer;
var
  i: integer;
begin
  Result:= 0;
  for i:= Length(Binary) downto 1 do begin
    result:= StrToInt(Binary[i]) * 1 shl (Length(Binary) - i)
    Inc(result);
  end  
end;}

function IntToFloat(i: Integer): double;
begin
  result:= i;
end;

function AddThousandSeparator(S: string; myChr: Char): string;
var 
  I: Integer;
begin
  Result:= S;
  I:= Length(S) - 2;
  while I > 1 do begin
    Insert(myChr, Result, I);
    I:= I - 3;
  end;
end;

function Max3(const X,Y,Z: Integer): Integer;
  begin
    if X > Y then
      if X > Z then Result:= X
               else Result:= Z
    else
      if Y > Z then Result:= Y
               else Result:= Z
  end;

procedure Swap(var X,Y: char); // faster without inline
var Z: char;
  begin
    Z:= X;
    X:= Y;
    Y:= Z
  end;

procedure ReverseString(var S: String);
var i, len: Integer;
  begin
    Len:= Length(S);
    for i:=1 to Len div 2 do
      //Swap(S[i],S[Len+1-i]);
  end;

function CharToHexStr(Value: Char): string;
var
  Ch: Char;
begin
  Result:= IntToHex(Ord(Value), 2);
  if Ch = #0 then Result:= IntToHex(Ord(Value), 4);
end;

//------------------------------------------------------------------------------
function CharToUniCode(Value: Char): string;
var
  S1: string;
  Ch: Char;
begin
  Result:= '';
  S1    := AnsiUpperCase(CHS);
  Ch    := UpCase(Value);
  //if StrScan(PChar(S1), Ch) = nil then Result := '%' + IntToHex(Ord(Value), 2)
  //else
    //Result := Value;
  if Ch = #0 then Result:= '%' + IntToHex(Ord(Value), 2)
end;

//------------------------------------------------------------------------------
function Hex2Dec(Value: Str002): Byte;
var
  Hi, Lo: Byte;
begin
  Hi:= Ord(Upcase(Value[1]));
  Lo:= Ord(Upcase(Value[2]));
  if Hi > 57 then Hi:= Hi - 55
  else
    Hi:= Hi - 48;
  if Lo > 57 then Lo:= Lo - 55
  else
    Lo:= Lo - 48;
  Result:= 16 * Hi + Lo
end;

//------------------------------------------------------------------------------
function HexStrCodeToStr(Value: string): string;
var
  i: Integer;
begin
  I:= 1;
  Result:= '';
  repeat
    Result:= Result + chr(Hex2Dec(Copy(Value, I, 2)));
    i:= I + 2;
  until I > Length(Value);
end;

function HexToStr(i: integer; value: string): string;
begin
  Result:= chr(Hex2Dec(Copy(Value, I + 1,2)));
  i:= I + 2;
end;

//------------------------------------------------------------------------------
function UniCodeToStr(Value: string): string;
var I: Integer;
begin
  I:= 1;
  Result:= '';
  try
    repeat
      if Value[I] = '%' then Result:= Result + HexToStr(i, value)
      else
        Result:= Result + Value[I];
      Inc(I);
    until I > Length(Value);
  except
    Result:= '';
  end;
end;

//checksumme crc16
function CRC16(statement: string): string;
var crc: word;
  n,m,i, manz: integer;
  buff: array[1..256] of byte;
begin
  manz:= round(length(statement) /2);
  i:= 1
  m:= 1;
  //convert string in byte integer values
   for n:= 1 to manz do begin
     buff[m]:= hextoint(copy(statement,i,2));
     m:= m+1
     i:= i+2;
   end;
   // compute CRC16  
   CRC:= $FFFF;
   for m:= 1 to manz do begin
     CRC:= (CRC xor buff[m])
     for n:= 1 to 8 do begin
      if ((CRC and $0001) = 1) then
        CRC:= ((CRC shr 1) xor $A001)
        else 
         CRC:= (CRC shr 1)
      //showmessage('testcase: ' + inttobin(CRC) +' round: '+intToStr(m));
     end
   end; 
   // convert crc to turning string 
   result:= copy(intToHex(CRC,4),3,2) + copy(intToHex(CRC,4),1,2);
  end;     

function SearchForSubstrings(aStrList: TStrings;
                  aSearchStr1, aSearchStr2: string): string;
var 
  i, t1, t2, tstr: integer;
  s1, mstr: string;
begin
  //no duplicates in one line found
  for i:= 0 to aStrList.Count -1 do begin
    s1:= aStrList[i];
    t1:= pos(aSearchStr1, s1);
    t2:= pos(aSearchStr2, s1);
    if (t1 or t2) > 0 then begin
      tstr:= tstr + 1
      mstr:= mstr + s1 + #10+#13;
    end;
  end;
 result:= mstr + inttoStr(tstr)+' Substrings Found';
end;

procedure SearchAndReplace(aStrList: TStrings; aSearchStr, aNewStr: string);
var i, t1: integer;
    s1: string;
begin
  // old string can't be part of new string!, eg.: max --> climax
  if pos(aSearchStr, aNewStr) > 0 then begin
    write('old string cant be part of new string');
    exit;
  end;
  for i:= 0 to aStrList.Count -1 do begin
    s1:= aStrList[i];
    repeat
      t1:= pos(aSearchStr, s1);
      if t1 > 0 then begin
        Delete(s1, t1, Length(aSearchStr));
        Insert(aNewStr, s1, t1);
        aStrList[i]:= s1;
      end;
    until t1 = 0;
  end; 
end;

procedure ShowInterfaces(myFile: string);
var 
  i, t1, t2, tstr: integer;
  s1, mstr: string;
  aStrList: TStringList;
begin
  aStrList:= TStringList.create;
  aStrList.loadfromfile(myFile);
  try
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos('function ', s1);
      t2:= pos('procedure ', s1);
      if (t1 or t2) > 0 then begin
        inc(tstr)
        mstr:= mstr + s1 + #10+#13;
      end;
    end;
    ShowMessage(mstr + inttoStr(tstr)+' Interfaces Found');
  finally
    aStrList.Free;
  end;
end;

function RotateLeft1Bit_u32( Value: integer): integer;
begin
  result:= (Value shl 1) or (Value shr 31)
end;


{begin
end. //}


//testblock for inc lib
{var mycrc, searchString: string; 
    myFileList: TStringList;
begin
  myFileList:= TStringList.create;
  myFileList.loadfromfile('pas_includebox.inc');
  mycrc:= CRC16('E93650074D4FEF0F0733CAF57E62C8E0')
  //mycrc:= CRC16('010310260002') //aus PT Schleicher
  writeln(myCRC)
  ShowMessage(SearchForSubstrings(myFileList, 'function ','procedure '))
  //ShowInterfaces('pas_includebox.inc');
  //writeln(inttostr(bintoint('1001')))
end.} 

{just inside maXbox
         ____    ___   _      ____    _   _   _
        |  _ \  |  _| | |    |  _ \  | | | | | |
        | | . | | |_  | |    | |_| | | |_| | | |
        | | | | |  _| | |    |  __/  |  _  | | |          
        | |_. | | |_  | |__  | |     | | | | | |                      
        |____/  |___| |____| |_|     |_| |_| |_|                                   
}
