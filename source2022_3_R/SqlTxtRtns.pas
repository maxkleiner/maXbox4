{************************************************************************}
{ FIBPlus - component library  for direct access  to Interbase  databases}
{    FIBPlus is based in part on the product                             }
{    Free IB Components, written by Gregory H. Deatz for                 }
{    Hoagland, Longo, Moran, Dunst & Doukas Company.                     }
{                                         Contact:       gdeatz@hlmdd.com}
{    Copyright (c) 1998-2001 Serge Buzadzhy                              }
{                                         Contact: serge_buzadzhy@mail.ru}
{  Please see the file FIBLicense.txt for full license information.      }
{************************************************************************}

unit SqlTxtRtns;

interface
 uses Windows,SysUtils,Classes,StrUtil, variants;

const
   space='    ';
   ForceNewStr=#13#10+space;
   QuotMarks=#39;

 function  DispositionFrom(const SQLText:string):TPoint;

 procedure AllTables(const SQLText:string;FTables:Tstrings);
 function  TableByAlias(const SQLText,Alias:string):string;
 function  FullFieldName(const SQLText,FieldName:string):string;
 function  AddToWhereClause(const SQLText,NewClause:string):string;
 function  GetWhereClause(SQLText:string;N:integer;var
   StartPos,EndPos:integer
 ):string;
 function  WhereCount(SQLText:string):integer;
 function  GetOrderInfo(SQLText:string):variant;
 function  OrderStringTxt(SQLText:string;
  var StartPos,EndPos:integer
 ):String;

//
 function  PrepareConstraint(Src:Tstrings):string;
 procedure DeleteEmptyStr(Src:Tstrings);
 function  NormalizeSQLText(const SQL: string;MacroChar:Char): string;


 function  CountSelect(const SrcSQL:string):string;
 function  GetModifyTable(const SQLText:string;AlreadyNormal:boolean):string;

implementation
 



const
  BeginWhere =' WHERE ';

function  NormalizeSQLText(const SQL: string;MacroChar:Char): string;
var i,j,cntB :integer;
    InQuote:boolean;
    InRemark:boolean;
    PredChar:Char;
    QuoteChar:Char;
    l:integer;
    InParamName:boolean;
begin
 cntB:=0;
 InQuote:=false;  InRemark:=false;
 PredChar:=#0;    QuoteChar:='"';
 l:=Length(SQL);
 SetLength(Result,l);j:=1;
 InParamName:=false;
 for i:=1 to l do
 begin
  if not InQuote then
  if not InRemark then begin
   InRemark:=(SQL[i]='/')and (i<l) and (SQL[i+1]='*');
  end
  else
   InRemark:=not ((SQL[i-1]='/')and (i>2) and (SQL[i-2]='*'));

  if not InRemark  then
  if not InQuote then begin
   InQuote:= (SQL[i] in ['''','"']);
   if InQuote then QuoteChar:=SQL[i];
  end
  else
   InQuote:= (SQL[i] <> QuoteChar);

  if InRemark then
   Continue
  else
  if InQuote then begin
    Result[j]:= SQL[i];Inc(j);
  end
  else
  if SQL[i] in [',','('] then begin
   Result[j]:=' ';
   Result[j+1]:=SQL[i];
   Inc(j,2);
  end
  else
  if (SQL[i] in ['?',':','@']) and (PredChar='=')
  then begin
   Result[j]:=' ';
   Result[j+1]:=SQL[i];
   Inc(j,2);
   InParamName:=true;
  end
  else
  if (SQL[i] in [' ',#13,#10]) then begin
   Inc(cntB);
   if cntB=1 then
   begin
    Result[j]:=' ';
    Inc(j);
    InParamName:=false;
   end
  end
  else begin
   InParamName:=(SQL[i] in ['?',':','@']) or (InParamName);
   if not InParamName then
    Result[j]:=UpperCase(SQL[i])[1]
   else
    Result[j]:=SQL[i];
   Inc(j);
   cntB:=0;
  end;
  PredChar:=SQL[i] ;
  if j>=l then SetLength(Result,j+10);
 end;
 SetLength(Result,j-1);
end;


function RemoveSP(const FromStr:string):string;
var pBrIn,pBrOut:integer;
    cBrIn,cBrOut:integer;
    l:integer;
begin
 Result:=FromStr;
 pBrIn:=Pos('(',FromStr);
 if pBrIn=0 then Exit;
 l:=Length(FromStr);
 while pBrIn >0 do begin
  pBrOut:=pBrIn+1;
  cBrIn :=1;     cBrOut:=0;
  while (cBrOut<cBrIn)  do begin
   if Result[pBrOut]=')' then Inc(cBrOut)
   else
   if Result[pBrOut]='(' then Inc(cBrIn);
   Inc(pBrOut);
   if pBrOut>l then Exit;
  end;
  while (pBrIn>1) and not (Result[pBrIn] in [',']) do Dec(pBrIn);
  while (pBrOut<=Length(Result)) and not (Result[pBrOut] in [',']) do Inc(pBrOut);
  Result:=Copy(Result,1,pBrIn-1) +Copy(Result,pBrOut,MaxInt);
  pBrIn:=Pos('(',Result);
 end;
end;

function RemoveJoins(const FromStr:string):string;
var pON,pComa,pJOIN:integer;
    tmpStr:string;
begin
 Result:=FromStr;
 pJOIN:=PosCI(' JOIN ',Result);
 if pJOIN=0 then Exit;
 Result:=Copy(Result,1,pJOIN)+', '+Copy(Result,PJOIN+6,MaxInt);
 Result:=ReplaceCIStr(Result, ' LEFT ' , ' ');
 Result:=ReplaceCIStr(Result, ' RIGHT ', ' ');
 Result:=ReplaceCIStr(Result, ' FULL ' , ' ');
 Result:=ReplaceCIStr(Result, ' INNER ', ' ');
 Result:=ReplaceCIStr(Result, ' OUTER ', ' ');
 Result:=ReplaceCIStr(Result, ' JOIN ', ' , ');
 pON:=PosCI(' ON ',Result);
 tmpStr:='';
 while pOn >0 do begin
  tmpStr:=Copy(Result,pOn+3,MaxInt);
  pComa:=Pos(',',tmpStr);
  if pComa>0 then
   Result:=Copy(Result,1,pOn-1)+Copy(tmpStr,pComa,MaxInt)
  else
   Result:=Copy(Result,1,pOn-1) ;
  pON:=PosCI(' ON ',Result);
 end;
end;

function DispositionFrom(const SQLText:string):TPoint;
var FromText:string;
    p:Integer; 
    bracket:Integer;
    i:Integer;
begin
  FromText:=ReplaceStr(UpperCase(SQLText),#13#10,'  ');
  p:=Pos('SELECT',FromText);
  if p=0 then Exit;
  if not  (FromText[p+6] in [' ','(']) then Exit;
  p:=p+6;
  bracket:=0;
  For i:=p to Length(FromText) do
   begin
    if (bracket=0) and (Copy(FromText,i,5)='FROM ') then Break;
    if FromText[i]='(' then inc(bracket);
    if FromText[i]=')' then dec(bracket);
   end;
  if i=Length(FromText) then Exit;

  Result.X:=i;
  For i:=Result.X+5 to Length(FromText) do
   begin
    if (bracket=0) and (Copy(FromText,i,6)='WHERE ') then Break;
    if (bracket=0) and (Copy(FromText,i,6)='GROUP ') then Break;
    if (bracket=0) and (Copy(FromText,i,6)='ORDER ') then Break;
    if FromText[i]='(' then inc(bracket);
    if FromText[i]=')' then dec(bracket);
   end;
  Result.Y:=i;
  if i<>Length(FromText) then 
   begin
    Result.Y:=i-1;
    while FromText[Result.Y] = ' ' do Dec(Result.Y)
   end
  else
   Result.Y:=i;   

  Inc(Result.Y);
end;

function  CountSelect(const SrcSQL:string):string;
var fr:TPoint;
    StartWhere,EndWhere:integer;
    wh:string;
begin
 Result:='';
 if PosCI('SELECT',SrcSQL)=0 then Exit;
 fr:=DispositionFrom(SrcSQL);
 if fr.x=0 then Exit;
 Result:='Select Count(*) '+Copy(SrcSQL,fr.x,fr.y-fr.x);
 wh:=GetWhereClause(Copy(SrcSQL,fr.x,100000),1,StartWhere,EndWhere);
 if wh<>'' then
  Result:=Result+#13#10+BeginWhere+wh;
end;

function  GetModifyTable(const SQLText:string;AlreadyNormal:boolean):string;
var p:integer;
    c:integer;
begin
 if not AlreadyNormal then
  Result:=' '+NormalizeSQLText(SQLText,'@')
 else
  Result:=' '+SQLText;
 Result:=Result;
 p:=Pos(' INSERT ',Result);
 if p<>0 then
  c:=0
 else
 begin
  p:=Pos(' UPDATE ',Result);
  if p<>0 then
   c:=1
  else
  begin
   p:=Pos(' DELETE ',Result);
   if p=0 then begin
    Result:=''; Exit;
   end;
   c:=2;
  end;
 end;
 case c of
  0: if Result[p+13]<>'"' then
      Result:=ExtractWord(3,Result,[' '])
     else
      Result:=ExtractWord(2,Copy(Result,13,10000),['"']);
  1: if Result[p+8]<>'"' then
      Result:=ExtractWord(2,Result,[' '])
     else
      Result:=ExtractWord(2,Copy(Result,8,10000),['"'])
 else
     if Result[p+13]<>'"' then
      Result:=ExtractWord(3,Result,[' '])
     else
      Result:=ExtractWord(2,Copy(Result,13,10000),['"']);
 end;
end;

procedure AllTables(const SQLText:string;FTables:Tstrings);
var s,FromText:string;
      i,p:integer;
      DFrom       :TPoint;

begin
 FTables.Clear;
 if Trim(SQLText)='' then Exit;
 DFrom:=DispositionFrom(SQLText);
 FromText:=Copy(SQLText,DFrom.X+4,DFrom.Y-DFrom.X-3);
 FromText:=ReplaceStr(Trim(FromText),#13,' ');
 FromText:=ReplaceStr(Trim(FromText),#10,' ');

 if FromText='' then Exit;
 if PosCI(' JOIN ',FromText)>0 then FromText:=RemoveJoins(FromText);
 if PosCI('(',FromText)>0 then FromText:=RemoveSP(FromText);
 p:=WordCount(FromText,[',']);
 for  i:=1  to p do   begin
  s:=ExtractWord(i, FromText,[',']);
  p:=PosCI(' ORDER ',s);
  if p>0 then s:=Copy(s,1,p-1);
  p:=PosCI(' GROUP ',s);
  if p>0 then s:=Copy(s,1,p-1);
  FTables.Add(Trim(s));
 end;
end;

function  TableByAlias(const SQLText,Alias:string):string;
var ts:Tstrings;
    i,p:integer;
begin
 Result:=Alias;
 ts:=TStringList.Create;
 try
  AllTables(SQLText,ts);
  for i:=0 to Pred(ts.Count) do begin
   p:=Pos(' '+Alias,ts[i]);
   if p>0 then begin
     Result:=Trim(Copy(ts[i],1,p-1));
     Exit
   end;
  end;
 finally
  ts.Free
 end;
end;

function FullFieldName(const SQLText,FieldName:string):string;
var p:integer;
begin
 Result:=FieldName;
 p:=Pos('.',FieldName);
 if p=0 then Exit;
 Result:=TableByAlias(SQLText,Copy(FieldName,1,p-1))
  +Copy(FieldName,p,1000);
end;

function AdapteSQLText(const SQLText:string):string;
begin
  Result:=ReplaceStr(SQLText, #13#10,' ');
end;

function WhereCount(SQLText:string):integer;
var p:integer;
begin
  SQLText:=AdapteSQLText(SQLText);
  Result:=0;
  p:=PosCI(BeginWhere,SQLText);
  while p>0 do begin
   Inc(Result);
   SQLText:=Copy(SQLText,p+7,10000);
   p:=Pos(BeginWhere,SQLText);
  end;
end;

function  OrderStringTxt(SQLText:string;
 var StartPos,EndPos:integer):String;
const l=Length('ORDER');
      l1=Length('FOR UPDATE');
var p:integer;
begin
// SQLText:=NormalizeSQLText(SQLText,'@');
 StartPos:=PosExtCI('ORDER',SQLText,[' ',#10,')'],[' ',#13]);
 if StartPos=0 then
 begin
   Result:='';   Exit;
 end;
 Result:=Copy(SQLText,StartPos+l,10000);
 p:=PosExtCI('BY',Result,[' ',#10,')'],[' ',#13]);
 if p=0 then
 begin
   Result:='';  StartPos:=0; Exit;
 end;
 Result:=Copy(Result,p+2,10000);
 EndPos:=PosExtCI('FOR UPDATE',Result,[' ',#10,')'],[' ',#13]);
 if EndPos=0 then EndPos:=Length(SQLText)
 else
  Result:=Copy(Result,1,EndPos-1);
end;

function  GetOrderInfo(SQLText:string):variant;
var p,i:integer;
    wc:integer;
    bufStr,s:string;
begin
 Result:=null;
 SQLText:=AdapteSQLText(SQLText);
 p:=PosCI(' ORDER ',SQLText);
 if p=0 then Exit;
 SQLText:=Copy(SQLText,p+6,Length(SQLText));
 p:=PosCI(' BY ',SQLText);
 if p=0 then Exit;
 SQLText:=Copy(SQLText,p+4,Length(SQLText));
 wc:=WordCount(SQLText,[',']);
 if wc<1 then Exit;
 Result:=VarArrayCreate([0,wc-1,0,1],varVariant);
 for i:=1 to wc do begin
  bufStr:=Trim(ExtractWord(i,SQLText,[',']));
//  bufStr:=ExtractWord(1,bufStr,[' ']);
  if WordCount(bufStr,['.'])>1 then
   s:=ExtractWord(1,bufStr,['.'])+ '.'+
    Trim(ExtractWord(2,bufStr,['.']))
  else
   s:=bufStr;

  s:=ReplaceStr(s,'"','');
  p:=posCI(' COLLATE',s);
  if p>0 then    s:=Copy(s,1,p-1);
  p:=posCI(' DESC',s);
  Result[i-1,1]:=p=0;
  if p>0 then
   s:=Copy(s,1,p-1)
  else begin
   p:=posCI(' ASC',s);
   if p>0 then    s:=Copy(s,1,p-1)
  end;
  Result[i-1,0]:=s;
 end;

end;

function  GetWhereClause(SQLText:string;N:integer;var
 StartPos,EndPos:integer
):string;
var p,p1,p2:integer;
    l:integer;
begin
// Выдает N ную where clause
// Returns N  where clause
  p:=PosExtCI('WHERE',SQLText,[' ',#10,')'],[' ',#13]);
  if p=0 then begin
   StartPos:=0; EndPos:=0; Result:='';  Exit;
  end;
  p1:=1;
  while  (p>0) and (p1<N) do begin
   p:=PosInSubstrCIExt('WHERE',SQLText,
                     p+5,10000,
       [' ',#10,')'],[' ',#13]
      );
   if p>0 then Inc(p1);
  end;
  if (p1<N) then begin
   StartPos:=0; EndPos:=0; Result:='';  Exit;
  end;
  StartPos:=p+5;
  SQLText:=Copy(SQLText,StartPos,10000);
   p:=Pos('(',SQLText);
  if (p>0) then begin
   p1:=0; p2:=0;
   // p1= count of '('; p2= count of ')'
   l:=Length(SQLText);
   while (p<l) and (p2<=p1) do begin
    if SQLText[p]='(' then Inc(p1)
    else
    if SQLText[p]=')' then Inc(p2);
    if (p2<=p1) then Inc(p)
   end;
   if p2>p1 then
    SQLText:=Copy(SQLText,1,p-1);
  end
  else begin
   p:=Pos(')',SQLText);
   if p>0 then
    SQLText:=Copy(SQLText,1,p-1);
  end;
  Result:=SQLText;
  p:=PosExtCI('GROUP',SQLText,[' ',#10,')'],[' ',#13]);
  if p>0 then begin
   Result:=Copy(SQLText,1,p-1);
  end
  else begin
   p:=PosExtCI('PLAN',SQLText,[' ',#10,')'],[' ',#13]);
   if p>0 then begin
    Result:=Copy(SQLText,1,p-1);
   end
   else begin
    p:=PosExtCI('ORDER',SQLText,[' ',#10,')'],[' ',#13]);
    if (p>0) and (SQLText[p-1] in [' ',#10,')']) then
     Result:=Copy(SQLText,1,p-1);
   end
  end;
  EndPos:=StartPos+Length(Result)-1
end;

function  AddToWhereClause(const SQLText,NewClause:string):string;
var p:integer;
begin
  if Trim(NewClause)='' then begin
    Result:=SQLText;  Exit
  end;
  p:=PosCI('WHERE',SQLText);
  if (p>0) 
   and (p+5<=Length(SQLText)) and
  (SQLText[p+5] in [' ',#13,#10]) then begin
   Result:=Copy(SQLText,1,p+5)+ForceNewStr+NewClause;
   if Trim(Copy(SQLText,p+6,MaxInt))<>'' then
   Result:=Result+' and '+ForceNewStr+Copy(SQLText,p+6,MaxInt);
  end
  else begin
   p:=PosCI('GROUP ',SQLText);
   if p=0 then p:=PosCI('ORDER ',SQLText);
   if p>0 then
     Result:=Copy(SQLText,1,p-1)+BeginWhere+ForceNewStr+NewClause+ForceNewStr+
      Copy(SQLText,p,MaxInt)
   else
     Result:=SQLText+BeginWhere+ForceNewStr+NewClause;
  end
end;

function PrepareConstraint(Src:Tstrings):string;
var i,pos_no: integer;
begin
// Приведение текстов констрэнтов к единому виду
// для облегчения последующей обработки
// Временно не используется
    Result := Trim(Src.Text);
    pos_no := Pos('(',Result)+1;
    Result:=Copy(Result,Pos_no,Length(Result));
    pos_no :=-1;
    for i := Length(Result) downto 1 do
     if Result[i]=')' then begin pos_no := i; Break; end;
    Result:=Copy(Result,1,Pos_no-1);
    Result:=
     ReplaceStr(Copy(Result,Pos_no,Length(Result)-Pos_no), '"',QuotMarks)
end;

procedure DeleteEmptyStr(Src:Tstrings);
var I:integer;
begin
 i:=0;
 while i<Src.Count do
  if Src[i]='' then Src.Delete(i)
  else Inc(i)
end;

end.


