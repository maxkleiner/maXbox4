{*******************************************************}
{                                                       }
{ This unit based on  StrUtils.pas from RX Library      }
{ and SoWldStr.pas from SOHOLIB                         }
{                                                       }
{*******************************************************}

unit StrUtil;

interface
 uses SysUtils,Classes;

type
 TCharSet= Set of Char;
 
const
     CLRF=#13#10;
 // from RX
function MakeStr(C: Char; N: Integer): string;
function StrAsFloat(S:string):double;

function ReplaceStr(Source:string;const Srch, Replace: string): string;

function ReplaceStrInSubstr(Source :string;const Srch, Replace: string;
            BeginPos,EndPos:integer
): string;
function ReplaceCIStr(Source:string;const Srch, Replace: string): string;
function ReplaceStrCIInSubstr(Source :string;const Srch, Replace:string; 
            BeginPos,EndPos:integer
): string;


function ToClientDateFmt(D:string;caseFmt:byte):string;
function ExtractWord(Num:integer;const Str: string;const  WordDelims:TCharSet):string;
function ExtractLastWord(const Str: string;const  WordDelims:TCharSet):string;
function WordCount(const S: string; const WordDelims: TCharSet): Integer;
//from SOHOLIB
function WildStringCompare( FirstString,SecondString : string ) : boolean;
function WldIndexOf(ts:TStrings;const Value:string;CaseSensitive:boolean):integer;

//from Me 
function iifStr(Condition:boolean;const Str1,Str2:string ):string;
function iifVariant(Condition:boolean;const Var1,Var2:Variant ):Variant;
function StrOnMask(const StrIn, MaskIn, MaskOut: string):string;
function EasyLikeStr(Str1,Str2:string) :boolean; // Only Russian texts

function FormatIdentifierValue(Dialect: Integer; const Value: String): String;
function FormatIdentifier(Dialect: Integer; const Value: String): String;
function NeedQuote(const Name:string):boolean;
function EasyNeedQuote(const Name:string):boolean;
function PosCI(const Substr,Str:string):integer;
function PosExt(const Substr,Str:string;BegSub,EndSub:TCharSet):integer;
function PosExtCI(const Substr,Str:string;BegSub,EndSub:TCharSet):integer;

function PosInSubstr(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer
         ):integer;
function PosInSubstrCI(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer
         ):integer;

function PosInSubstrExt(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer;
             BegSub,EndSub:TCharSet
         ):integer;


function PosInSubstrCIExt(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer;
             BegSub,EndSub:TCharSet
         ):integer;

function LastChar(const Str:string):Char;

implementation


const
   NonQuotedChars=['A'..'Z','0'..'9', '_', '$','%','#'];
   
function FormatIdentifierValue(Dialect: Integer;const Value: String): String;
begin
  if Dialect = 1 then
    Result := AnsiUpperCase(Trim(Value))
  else
    Result := Value;
end;

function FormatIdentifier(Dialect: Integer;const Value: String): String;
begin
  if Dialect = 1 then
    Result := AnsiUpperCase(Trim(Value))
  else
  if NeedQuote(Value) then
    Result := '"'+Value+'"'
  else
    Result := Value
end;

function NeedQuote(const Name:string):boolean;
var i,l:integer;
begin
 Result:=Name<>'';
 if not Result then Exit; 
 Result:=Name[1]='"';
 if Result then Exit;
 Result:=Name='YEAR';
 if Result then Exit; 
 Result:=false;
 l:=Length(Name);
 for i:=1 to l do begin
  Result:=not (Name[i] in NonQuotedChars);
  if Result then Exit;
 end;
end;


function EasyNeedQuote(const Name:string):boolean;
var i,l:integer;
begin
 Result:=Name[1]='"';
 if Result then Exit;
 Result:=false;
 l:=Length(Name);
 for i:=1 to l do begin
  Result:=not (Name[i] in NonQuotedChars+['a'..'z']);
  if Result then Exit;
 end;
end;

function PosCI(const Substr,Str:string):integer;
begin
 Result:=Pos(AnsiUpperCase(Substr),AnsiUpperCase(Str));
end;

function PosExt(const Substr,Str:string;BegSub,EndSub:TCharSet):integer;
var p,l,l1:integer;
begin
  Result:=0;
  p:=Pos(Substr,Str);
  l:=Length(Str);l1:=Length(Substr);
  while p>0 do begin
   if   ((p=1) or (Str[p-1] in BegSub)  )
    and ((Str[p+l1] in EndSub) or (p+l1=l))
   then
   begin
    Result:=p;    Exit;
   end;
   p:=PosInSubstr(Substr,Str,p+l1,l)
  end;
end;

function PosExtCI(const Substr,Str:string;BegSub,EndSub:TCharSet):integer;
begin
 Result:=PosExt(AnsiUpperCase(Substr),AnsiUpperCase(Str),BegSub,EndSub)
end;

function PosInSubstr(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer
         ):integer;
begin
 if BeginPos<1 then BeginPos:=1;
 Result:=Pos(SearchStr,
  Copy(Str,BeginPos,EndPos)
 );
 if Result>0 then   Inc(Result,BeginPos-1)
end;

function PosInSubstrExt(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer;
             BegSub,EndSub:TCharSet
         ):integer;
var p,l,l1:integer;
begin
  Result:=0;
  p:=PosInSubstr(SearchStr,Str,BeginPos,EndPos);
  l:=Length(Str);l1:=Length(SearchStr);
  while p>0 do begin
   if   ((p=1) or (Str[p-1] in BegSub)  )
    and ((Str[p+l1] in EndSub) or (p+l1=l))
   then
   begin
    Result:=p;    Exit;
   end;
   p:=PosInSubstr(SearchStr,Str,p+l1,EndPos)
  end;
end;

function PosInSubstrCIExt(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer;
             BegSub,EndSub:TCharSet
         ):integer;
begin
 Result:=PosInSubstrExt(AnsiUpperCase(SearchStr),
  AnsiUpperCase(Str),BeginPos,EndPos,BegSub,EndSub
 )
end;

function PosInSubstrCI(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer
         ):integer;
begin
 Result:=PosInSubstr(AnsiUpperCase(SearchStr),
                      AnsiUpperCase(Str),
                      BeginPos,EndPos
                     )
end;

function MakeStr(C: Char; N: Integer): string;
begin
  if N < 1 then Result := ''
  else begin
    SetLength(Result, N);
    FillChar(Result[1], Length(Result), C);
  end;
end;

function StrAsFloat(S:string):double;
begin
 S:=ReplaceStr(S, '.', DecimalSeparator);
 S:=ReplaceStr(S, ',', DecimalSeparator);
 Result:=StrToFloat(S)
end;

function StrDDMMMYYYY(const D:string):string;
begin
 Result:=ReplaceStr(D,'-',DateSeparator);
 if Pos('JAN',Result)<>0 then
   Result:=ReplaceStr(Result,'JAN','01')
 else
 if Pos('FEB',Result)<>0 then
   Result:=ReplaceStr(Result,'FEB','02')
 else
 if Pos('MAR',Result)<>0 then
   Result:=ReplaceStr(Result,'MAR','03')
 else
 if Pos('APR',Result)<>0 then
   Result:=ReplaceStr(Result,'APR','04')
 else
 if Pos('MAY',Result)<>0 then
   Result:=ReplaceStr(Result,'MAY','05')
 else
 if Pos('JUN',Result)<>0 then
   Result:=ReplaceStr(Result,'JUN','06')
 else
 if Pos('JUL',Result)<>0 then
   Result:=ReplaceStr(Result,'JUL','07')
 else
 if Pos('AUG',Result)<>0 then
   Result:=ReplaceStr(Result,'AUG','08')
 else
 if Pos('SEP',Result)<>0 then
   Result:=ReplaceStr(Result,'SEP','09')
 else
 if Pos('OCT',Result)<>0 then
   Result:=ReplaceStr(Result,'OCT','10')
 else
 if Pos('NOV',Result)<>0 then
   Result:=ReplaceStr(Result,'NOV','11')
 else
 if Pos('DEC',Result)<>0 then
   Result:=ReplaceStr(Result,'DEC','12')

end;

{$WARNINGS OFF}
function ToClientDateFmt( D:string;caseFmt:byte):string;
var
   Client_dateseparator,   Client_timeseparator  :Char;
   Client_LongDateFormat,
   Client_shortdateformat,Client_ShortTimeFormat :string;
   vD:TDateTime;
   IsKeyWord:boolean;


begin
  Client_dateseparator   := DateSeparator;
  Client_shortdateformat := ShortDateFormat;
  Client_timeseparator   := TimeSeparator;
  Client_ShortTimeFormat := ShortTimeFormat;
  Client_LongDateFormat  := LongDateFormat;

  IsKeyWord:=false;       Result:='';
  try
   if caseFmt<2 then
    if Pos('.',D)<>0 then begin
      DateSeparator   := '.';
      ShortDateFormat := 'dd.mm.yyyy';
    end
    else
    if Pos('/',D)<>0 then begin
     DateSeparator   := '/';
     ShortDateFormat := 'mm/dd/yyyy';
    end
    else
    if Pos('-',D)<>0 then begin
     D :=StrDDMMMYYYY(D);
     ShortDateFormat := 'dd.mm.yyyy';

    end
    else begin
     IsKeyWord:=true;
     Result:=UpperCase(D);
     Exit;
    end;
    TimeSeparator   := ':';
    ShortTimeFormat := 'h:m:s';
    case caseFmt of
      0: vD              := StrToDateTime(D);
      1: vD              := StrToDate(D);
      2: vD              := StrToTime(D);
    end;
  finally
   LongDateFormat  := Client_LongDateFormat;
   dateseparator   := Client_DateSeparator;
   ShortDateFormat := Client_ShortDateFormat;
   timeseparator   := Client_TimeSeparator;
   ShortTimeFormat := Client_ShortTimeFormat;

   if not IsKeyWord then
   case caseFmt of
     0: Result          := DateTimeToStr(vD);
     1: Result          := DateToStr(vD);
     2: Result          := TimeToStr(vD);
   end
 end;
end;
{$WARNINGS ON}
function ReplaceCIStr(Source:string;const Srch, Replace: string): string;
var
  I,l: Integer;
begin
  Result := ''; l:=Length(Srch);
  repeat
    I := PosCI(Srch, Source);
    if I > 0 then begin
      Result := Result + Copy(Source, 1, I - 1) + Replace;
      Source := Copy(Source, I+L , MaxInt);
    end
    else Result := Result + Source;
  until I <= 0;
end;


function ReplaceStr(Source:string;const Srch, Replace: string): string;
var
  I,l: Integer;
begin
  Result := ''; l:=Length(Srch);
  repeat
    I := Pos(Srch, Source);
    if I > 0 then begin
      Result := Result + Copy(Source, 1, I - 1) + Replace;
      Source := Copy(Source, I + L, MaxInt);
    end
    else Result := Result + Source;
  until I <= 0;
end;




function ReplaceStrCIInSubstr(Source :string;const Srch, Replace:string;
            BeginPos,EndPos:integer
): string;
var
  I: Integer;
begin
  Result := '';
  repeat
    I :=PosInSubstrCI(Srch, Source,BeginPos,EndPos);
    if I > 0 then begin
      Result := Result + Copy(Source, 1, I - 1) + Replace;
      Source := Copy(Source, I + Length(Srch), MaxInt);
    end
    else Result := Result + Source;
  until I <= 0;
end;


function ReplaceStrInSubstr(Source :string;const Srch, Replace: string;
            BeginPos,EndPos:integer
): string;
var
  I: Integer;
begin
  Result := '';
  repeat
    I :=PosInSubstr(Srch, Source,BeginPos,EndPos);
    if I > 0 then begin
      Result := Result + Copy(Source, 1, I - 1) + Replace;
      Source := Copy(Source, I + Length(Srch), MaxInt);
    end
    else Result := Result + Source;
  until I <= 0;
end;

function ExtractWord(Num:integer;const Str: string;const  WordDelims:TCharSet):string;
var
  SLen, I: Cardinal;
  wc: Integer;
begin
  Result := '';
  I := 1; wc:=0;
  SLen := Length(Str);
  while I <= SLen do begin
    while (I <= SLen) and (Str[I] in WordDelims) do Inc(I);
    if I <= SLen then Inc(wc);
    if wc=Num then Break;
    while (I <= SLen) and not(Str[I] in WordDelims) do Inc(I);
  end;
  if (wc=0) and (Num=1) then Result:=Str
  else
  if wc<>0 then begin
     while (I <= SLen) and not (Str[I] in WordDelims) do begin
       Result:=Result+Str[I];
       Inc(I);
     end;
  end;
end;

function ExtractLastWord(const Str: string;const  WordDelims:TCharSet):string;
var
  SLen, I: Cardinal;
begin
  Result := '';
  SLen := Length(Str);
  for i:= SLen downTo 1 do begin
    if not(Str[I] in WordDelims) then
     Result := Str[I]+Result
    else
     Exit
  end;
end;

function WordCount(const S: string; const WordDelims: TCharSet): Integer;
var
  SLen, I: Cardinal;
begin
  Result := 0;
  I := 1;
  SLen := Length(S);
  while I <= SLen do begin
    while (I <= SLen) and (S[I] in WordDelims) do Inc(I);
    if I <= SLen then Inc(Result);
    while (I <= SLen) and not(S[I] in WordDelims) do Inc(I);
  end;
end;

function iifStr(Condition:boolean;const Str1,Str2:string ):string;
begin
 if Condition then Result:=Str1 else Result:=Str2
end;


function iifVariant(Condition:boolean;const Var1,Var2:Variant ):Variant;
begin
 if Condition then Result:=Var1 else Result:=Var2
end;



// WildStringCompare by Sergey Blinov

var Res : boolean;

function Identical (FLine,SLine : string) : boolean;
begin
  if (FLine = '*') or (SLine = '*') or (FLine=SLine) then Identical := true
  else Identical := false;
end;

function Different (FLine,SLine : string ) : boolean;
begin
  Different:=false;
  if (Length(FLine)>0) and (Length(SLine)>0) then begin
      if    (FLine[1]<>'*') and (SLine[1]<>'*')
        and (FLine[1]<>'?') and (SLine[1]<>'?')
        and (FLine[1]<>SLine[1]) then Different := true;
  end
  else begin
    if (Length(FLine)=0) and (SLine<>'*') then Different := true;
    if (Length(SLine)=0) and (FLine<>'*') then Different := true;
  end;
end;

function WildCompare (FLine,SLine : string) : boolean;
var k : integer;
begin
  if Identical(FLine,SLine) then begin
    WildCompare := true;
    exit;
  end;
  if Different(FLine,SLine) then begin
    WildCompare := false;
    exit;
  end;
  if (FLine[1]='*') then
   for k := 1 to Length(SLine) do
     if (SLine[k]='*') or (SLine[k]=FLine[2]) or (SLine[k]='?') then
       Res := Res or WildCompare(Copy(FLine,2,Length(FLine)-1),    Copy(SLine,k,Length(SLine)-k+1));

  if (SLine[1]='*') then
   for k := 1 to Length(FLine) do
    if (FLine[k]='*')or(FLine[k]=SLine[2])or(FLine[k]='?') then
       Res  := Res or WildCompare(Copy(FLine,k,Length(FLine)-k+1), Copy(SLine,2,Length(SLine)-1));

  if (FLine[1]<>'*') and (SLine[1]<>'*') and ((FLine[1] = SLine[1])
      or((FLine[1]='?') or (SLine[1]='?'))) then
       Res  := Res or WildCompare(Copy(FLine,2,Length(Fline)-1),   Copy(SLine,2,Length(SLine)-1));
  WildCompare := Res;
end;

function DoResultLine (TLine : string ) : string;
var i : integer;
begin
  i := 1;

  {for i := 1 to Length(TLine) do}
  while i<=length(TLine) do
   if (Copy(TLine,i,2)='**') or
      (Copy(TLine,i,2)='*?') or
      (Copy(TLine,i,2)='?*') then begin
         TLine := Copy(TLine,1,i-1)+'*'+Copy(TLine,i+2,Length(TLine)-i-1);
     {i := 0;}
      i := 0;
   end
   else inc(i);
  DoResultLine := TLine;
end;

function WildStringCompare( FirstString,SecondString : string ) : boolean;
begin
  Res               := false;
  FirstString       := DoResultLine(FirstString);
  SecondString      := DoResultLine(SecondString);
  WildStringCompare := WildCompare(FirstString,SecondString);
end;


//
function WldIndexOf(ts:TStrings;const Value:string;CaseSensitive:boolean):integer;
var i:integer;
begin
 Result:=-1;
 for i:=0 to Pred(ts.Count) do
  if WildStringCompare( iifStr(CaseSensitive, ts[i],AnsiUpperCase(ts[i])),
   iifStr(CaseSensitive, Value,AnsiUpperCase(Value))
  ) then begin
   Result:=i; Exit
  end;
end;

//


function StrOnMask(const StrIn, MaskIn, MaskOut: string):string;
var  k,j,len:integer;
begin
  len:=Length(StrIn);
  Result:='';
  for j:=1 to Len do begin
    k:=Pos(StrIn[j],MaskIn);
    if k = 0 then
     Result:=Result+StrIn[j]
    else
     if Length(MaskOut)>k then      Result:=Result+MaskOut[k]
  end;
end;

function EasyLikeStr( Str1,Str2:string) :boolean; // Only Russian texts

procedure DoSpoilString(var str:string);
const
 MaskSymbols=['A'..'Z','0'..'9','À'..'ß'];
 IgnoreSymbols=['Ü','Ú'];
var i:integer;
    bufStr:string;
    LastChar:char;
begin
 bufStr:='';
 lastChar:=#0;
 for i:=1 to Length(Str) do
  if     (Str[i] in MaskSymbols)
     and not (Str[i] in IgnoreSymbols)
     and (Str[i]<>LastChar)
   then   begin
    bufStr:=bufStr+Str[i];
    lastChar:=Str[i]
   end;
  Str:=StrOnMask(bufStr,'ÇÁÈÉÀÝÛÃÞÄÆ×','ÑÏÅÅÎÎEÊÓÒØØ');
 // Øèïèì
end;


begin
 Str1:=AnsiUpperCase(Str1); Str2:=AnsiUpperCase(Str2);
 if (Length(Str1)>8) and (Length(Str2)>8) then begin
 // Äàâèì ãëàñíûå
  Str1:= StrOnMask(Str1,'ÓÅÛÀÎÝßÈÞÉ','          ');
  Str2:= StrOnMask(Str2,'ÓÅÛÀÎÝßÈÞÉ','          ');
 end;
 DoSpoilString(Str1); DoSpoilString(Str2);
 Result:=(Pos(Str2,Str1)>0) or (Pos(Str1,Str2)>0)
end;

function LastChar(const Str:string):Char;
var l:integer;
begin
 Result:=#0;
 l:=Length(Str);
 if l>0 then
  Result:=Str[l];
end;

end.



