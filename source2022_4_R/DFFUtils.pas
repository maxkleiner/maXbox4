unit DFFUtils;
interface
  uses Windows, Messages, Stdctrls, Sysutils, Classes, Grids;

  procedure reformatMemo(const m:TCustomMemo);
  procedure SetMemoMargins(m:TCustomMemo; const L,T,R,B:integer);  {in pixels}

  {Scroll the first line into view}
  procedure MoveToTop(memo:TMemo);
  procedure ScrollToTop(memo:TMemo);

  {Return the line clicked on by the mouse}

  
  function LineNumberClicked(memo:TMemo):integer;
  {same function with 3 alternate names (for forgetful users)}
  function MemoClickedLine(memo:TMemo):integer;
  function ClickedMemoLine(memo:TMemo):integer;
  function MemoLineClicked(memo:TMemo):integer;


  {Return Line Position clicked}
  function LinePositionClicked(Memo:TMemo):integer;
  function ClickedMemoPosition(memo:TMemo):integer;
  function MemoPositionClicked(memo:TMemo):integer;


  {TStringGrid operations}
  {Adjust size to just fit cell dimensions}
  procedure AdjustGridSize(grid:TDrawGrid);
  {Delete a row}
  procedure DeleteGridRow(Grid: TStringGrid; Const ARow:integer);
  {Insert a row}
  procedure InsertgridRow(Grid: TStringGrid; Const ARow:integer);

  {Sort the grid rows by the specified column, ascending if no direction specified}
  procedure Sortgrid(Grid : TStringGrid; Const SortCol:integer);  overload;
  procedure Sortgrid(Grid : TStringGrid;
                     Const SortCol:integer; sortascending:boolean); overload;

  procedure sortstrDown(var s: string); {sort string characters descending}
  procedure sortstrUp(var s: string);   {sort string characters ascending}
  procedure rotatestrleft(var s: string); {rotate stringleft}
  function  strtofloatdef(s:string; default:extended):extended;
  function  deblank(s:string):string;  {remove all blanks from a string}
  function IntToBinaryString(const n:integer; MinLength:integer):string;

  {Free objects contained in a string list and clear the strings}
  procedure FreeAndClear(C:TListBox); overload;
  procedure FreeAndClear(C:TMemo);   overload;
  procedure FreeAndClear(C:TStringList);   overload;

  {compute file size for files larger than 4GB}
  function getfilesize(f:TSearchrec):int64;

implementation

{************ Reformat **********}
procedure reformatMemo(const m:TCustomMemo);
{reformat the lines after removing existing Carriage returns and Line feeds}
{necessary to reformat input text from design time since text has hard breaks included}
var
  s:string;
  CRLF, CRCR:string;
begin
  {remove EXTRA carriage returns & line feeds}
  s:=m.text; {get memo text lines}
  CRLF:=char(13) + char(10);  {CR=#13=carriage retutn, LF=10=Linefeed}
  CRCR:=char(13)+char(13);
 {temporarily change real paragraphs (blank line), CRLFCRLF to double CR}
  s:=stringreplace(s,CRLF+CRLF,CRCR,[RfReplaceall]);
  {Eliminate input word wrap CRLFs}
  s:=stringreplace(s,CRLF,' ',[RfReplaceall]);
  {now change CRCR back to CRLFCRLF}
  s:=stringreplace(s,CRCR,CRLF+CRLF,[RfReplaceall]);
  m.text:=s;
  if m is TMemo then TMemo(m).wordwrap:=true; {make sure that word wrap is on}
end;

{**************** SetMemoMargins **********}
procedure SetMemoMargins(m:TCustomMemo; const L,T,R,B:integer);
var cr:Trect;
begin
  {Reduce clientrect by L & R margins}
  cr:=m.clientrect;
  if L>=0 then cr.left:=L;
  If T>=0 then cr.top:=T;
  If R>=0 then cr.right:=cr.right-r;
  If B>=0 then cr.bottom:=cr.Bottom-b;
  m.perform(EM_SETRECT,0,longint(@cr));

  reformatmemo(m); {good idea to reformat after changing margins}
end;

procedure MoveToTop(memo:TMemo);
{Scroll "memo" so that the first line is in view}
begin
  with memo do
  begin
    selstart:=0;
    sellength:=0;
  end;
end;

Procedure ScrollToTop(memo:TMemo);
begin
  Movetotop(memo);
end;



function LineNumberClicked(Memo:TMemo):integer;
{For a click on a memo line, return the line number (number is relative to 0)}
begin
  //result:=Memo.Perform(EM_LINEFROMCHAR, -1, 0);  {cause subrange error in XE5}
  result:=Memo.Perform(EM_LINEFROMCHAR, WPARAM(-1), 0);  {GDD 12/12/13}
end;


function ClickedMemoLine(memo:TMemo):integer;
begin  {return index of the clicked line in "memo"}
  result:=LineNumberClicked(memo);
end;
function MemoClickedLine(memo:TMemo):integer;
begin
  result:=LineNumberClicked(memo);
end;
function MemoLineClicked(memo:TMemo):integer;
begin  {return index of the clicked line in "memo"}
  result:=LineNumberClicked(memo);
end;


function LinePositionClicked(Memo:TMemo):integer;
{When a TMemo line is clicked, return the character position
 within the line (position is relative to 1)}
var LineIndex:integer;
begin
  with memo do
  begin
     LineIndex:=Perform(Em_LineIndex,ClickedMemoLine(memo),0);
     Result:=Selstart-Lineindex+1;
  end;
end;

function ClickedMemoPosition(memo:TMemo):integer;
begin
  result:=LinePositionClicked(Memo);
end;
function MemoPositionClicked(memo:TMemo):integer;
begin
  result:=LinePositionClicked(Memo);
end;


procedure memosort(memo:TMemo);
var
  i,j:integer;
  s:string;
  {Quick and dirty sort}
begin
  with memo,lines do
  begin
    beginupdate;
    for i:=0 to count-2 do
    for j:= i+1 to count-1 do
    if AnsiCompareStr(lines[i],lines[j])>0 then
    begin  {swap(lines[i],lines[j])}
      s:=lines[i];
      lines[i]:=lines[j];
      lines[j]:=s;
    end;
    endupdate;
  end;  
end;


{**************** AdjustGridSize *************}
procedure AdjustGridSize(grid:TDrawGrid);
{Adjust borders of grid to just fit cells}
var   w,h,i:integer;
begin
  with grid do
  begin
    w:=0;
    for i:=0 to colcount-1 do w:=w+colwidths[i];
    width:=w;
    repeat width:=width+1 until fixedcols+visiblecolcount=colcount;
    h:=0;
    for i:=0 to rowcount-1 do h:=h+rowheights[i];
    height:=h;
    repeat height:=height+1 until fixedrows+visiblerowcount=rowcount;
    invalidate;
  end;
end;

(*
{alternative version which may be faster and more accurate - needs testing}
{*********** AdjustgridSize *********8}
procedure AdjustGridSize(grid:TDrawGrid);
{Adjust borders of grid to just fit cells}
var   w,h,i:integer;
begin
  with grid do
  begin
    w:=0;
    for i:=0 to colcount-1 do w:=w+colwidths[i];
    width:=w;

    //repeat width:=width+1 until fixedcols+visiblecolcount=colcount;
    width:=width+(colcount+1)*gridlinewidth;
    h:=0;
    for i:=0 to rowcount-1 do h:=h+rowheights[i];
    height:=h;
    //repeat height:=height+1 until fixedrows+visiblerowcount=rowcount;
    height:=height+(rowcount+1)*gridlinewidth;
    invalidate;
  end;
end;
*)


{************* InsertGridRow *************}
procedure InsertgridRow(Grid: TStringGrid; Const ARow:integer);
{Insert blank row after Arow}
var i:integer;
begin
  with Grid do
  if (arow>=0) and (arow<=rowcount-1) then
  begin
    rowcount:=rowcount+1;
    for i:=rowcount-1 downto Arow+2 do rows[i]:=rows[i-1];
    rows[arow+1].clear;
    row:=arow+1;
    {if insert is within fixed rows then increase fixed row count}
    {if insert is at or after the last fixed row, leave fixed row count alone}
    if fixedrows>arow then fixedrows:=fixedrows+1;
  end;
end;

{************* DeleteGridRow *************}
procedure DeleteGridRow(Grid: TStringGrid; Const ARow:integer);
{delete a stringgrid row.  Arow is a row index between 0 and rowcount-1}
var i:integer;
begin
  with Grid do
  if (arow>=0) and (arow<=rowcount-1) then
  begin
    for i:=Arow to rowcount-1 do rows[i]:=rows[i+1];
    rowcount:=rowcount-1;
    if fixedrows>arow then fixedrows:=fixedrows-1;
  end;
end;

{*********** SortGrid ************}
procedure Sortgrid(Grid:TStringGrid; Const SortCol:integer; sortascending:boolean);
var
   i,j : integer;
   temp:tstringlist;
begin
  temp:=tstringlist.create;
  with Grid do
  for i := FixedRows to RowCount - 2 do  {because last row has no next row}
  for j:= i+1 to rowcount-1 do {from next row to end}

  if ((sortascending) and (AnsiCompareText(Cells[SortCol, i], Cells[SortCol,j]) > 0))
  or ((not sortascending) and (AnsiCompareText(Cells[SortCol, i], Cells[SortCol,j]) < 0))
  then
  begin
    temp.assign(rows[j]);
    rows[j].assign(rows[i]);
    rows[i].assign(temp);
  end;
  temp.free;
end;

{*********** SortGrid ************}
procedure Sortgrid(Grid : TStringGrid; Const SortCol:integer);
begin
  Sortgrid(grid,Sortcol, true);  {ascending}
end;


{************** SortStrDown ************}
procedure sortstrDown(var s: string);
{Sort characters of a string in descending sequence}
var
  i, j: integer;
  ch: char;
begin
  for i := 1 to length(s) - 1 do
    for j := i + 1 to length(s) do
      if s[j] > s[i] then
      begin  {swap}
        ch   := s[i];
        s[i] := s[j];
        s[j] := ch;
      end;
end;

{************** SortStrUp ************}
procedure sortstrUp(var s: string);
{Sort characters of a string in ascending sequence}
var
  i, j: integer;
  ch:   char;
begin
  for i := 1 to length(s) - 1 do
    for j := i + 1 to length(s) do
      if s[j] < s[i] then
      begin  {swap}
        ch   := s[i];
        s[i] := s[j];
        s[j] := ch;
      end;
end;
{************ RotateStrLeft **********}
procedure rotatestrleft(var s: string);
{Move all characters of a string left one position,
 1st character moves to end of string}
var
  ch:     char;
  len: integer;
begin
  len := length(s);
  if len > 1 then
  begin
    ch := s[1];
    move(s[2],s[1],len-1);
    s[len] := ch;
  end;
end;

{********** StrToFloatDef **********}
function strtofloatdef(s:string; default:extended):extended;
{Convert input string to extended}
{Return "default" if input string is not a valid real number}
begin
  try
    result:=strtofloat(trim(s));
    except  {on any conversion error}
      result:=default; {use the default}
  end;
end;

{*************** Deblank ************}
function  deblank(s:string):string;
{remove all blanks from a string}
begin
  result:=StringReplace(s,' ','',[rfreplaceall]);
end;


{************* IntToBinaryString **********}
function IntToBinaryString(const n:integer; MinLength:integer):string;
{Convert an integer to a binary string of at least length "MinLength"}
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
  if length(result)<Minlength
  then result:=stringofchar('0',Minlength-length(result))+result;
end;


{*************** FreeAndClear *********}
procedure FreeAndClear(C:TListbox);   overload;
  var i:integer;
  begin
    with c.items do
    for i:=0 to count-1 do
    if assigned(objects[i]) then objects[i].free;
    c.clear;
  end;

  procedure FreeAndClear(C:TMemo);   overload;
  var i:integer;
  begin
    with c.lines do
    for i:=0 to count-1 do
    if assigned(objects[i]) then objects[i].free;
    c.clear;
  end;

  procedure FreeAndClear(C:TStringList);   overload;
  var i:integer;
  begin
    with c do
    for i:=0 to count-1 do
    if assigned(objects[i]) then objects[i].free;
    c.clear;
  end;

{************** GetFileSize **************}
function getfilesize(f:TSearchrec):int64;
{Given a TSearchrec describing file properties, compute file size for files
 larger than 4GB}
    var
      fszhi,fszlo,m:int64;
    begin
      {Here's the way to get file size that works for files larger than 4GB}
      fszhi:=f.FindData.nfilesizehigh;
      fszlo:=f.FindData.nfilesizelow;
      m:=high(longword);
      inc(m,1);
      result:=fszhi*m+fszlo;
    end;

end.

