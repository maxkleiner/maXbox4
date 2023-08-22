unit Reversi;
//------------------------------------------------------------------
//                  Othello game (Version 1.0)
// Author: Roman Podobedov
// Email: romka@ut.ee
// http://romka.demonews.com
//
// Delphi translation by vlad@ifrance.com       10.2000
//------------------------------------------------------------------

interface
uses
  Windows, Messages, SysUtils;

type sPosData= record        // Information about current position
	corner: boolean;  	     // Is corner seized?
	square2x2: boolean;     // Is square 2x2 at the corners seized?
	edge: boolean;
	stable: integer;     // Number of stable disks
	internal: integer;   // Number of internal disks
	disks: integer;      // Total disks
	mx, my: integer;     // This move coordinates x and y
        end;
      tBoard= array[0..7,0..7] of byte;
      pBoard= ^tBoard;

function CalculateData(cc: byte; cx, cy: integer): sPosData;
function CheckMove(color:byte; cx, cy: integer): integer;
function DoStep(data: pBoard): word;

function winExecAndWait(const sAppPath: string; wVisible: word): boolean;


implementation

var brd, brd2, brd3: tBoard;

function CalculateData(cc: byte; cx, cy: integer): sPosData;
// Calculate data about current position
// Parameter: cc - Who do move, black or white?
//            if (cc == 1) White makes a move
//	      if (cc == 2) Black makes a move
var	data: sPosData;
	i, j: integer;
	intern: boolean;

begin
data.corner:= FALSE;
data.disks:= 0;
data.internal:= 0;
data.stable:= 0;
data.square2x2:= FALSE;
data.edge:= FALSE;
data.mx:= cx;
data.my:= cy;

// make a copy of the board and calculate the sum of disks
for i:=0 to 7 do
 for j:=0 to 7 do
  begin
  brd3[i,j]:= brd2[i,j];
  if brd2[i,j]= cc then inc(data.disks);
  end;

// Fill the "corner" data
if ((cy=0) and (cx=0)) or ((cy=0) and (cx=7)) or
   ((cy=7) and (cx=0)) or ((cy=7) and (cx=7)) then
 data.corner:= TRUE;

// Fill the "square2x2" data
if ((cy<=1) and (cx<=1)) or ((cy<=1) and (cx>=6)) or
   ((cy>=6) and (cx<=1)) or ((cy>=6) and (cx>=6)) then
 data.square2x2:= TRUE;

// Fill the "edge" data
if (cy=0) or (cx=0) or (cy=7) or (cx=7) then
 data.edge:= TRUE;

// Calculate number of stable discs
for i:=0 to 7 do // Left-Upper corner
 begin
 if brd3[i,0] <> cc then break;
 for j:=0 to 7 do
  begin
  if brd3[i,j] <> cc then break;
  inc(data.stable);
  brd3[i,j]:= 0;
  end;
 end;
for i:=7 downto 0 do // Left-Lower corner
 begin
 if brd3[i,0] <> cc then break;
 for j:=0 to 7 do
  begin
  if brd3[i,j] <> cc then break;
  inc(data.stable);
  brd3[i,j]:= 0;
  end;
 end;
for i:=7 downto 0 do // Right-Bottom corner
 begin
 if brd3[i,7] <> cc then break;
 for j:=7 downto 0 do
  begin
  if brd3[i,j] <> cc then break;
  inc(data.stable);
  brd3[i,j]:= 0;
  end;
 end;
for i:=0 to 7 do // Right-Upper corner
 begin
 if brd3[i,7] <> cc then break;
 for j:=7 downto 0 do
  begin
  if brd3[i,j] <> cc then break;
  inc(data.stable);
  brd3[i,j]:= 0;
  end;
 end;

// Calculate number of internal discs
for i:=0 to 7 do
 for j:=0 to 7 do
  if brd2[i,j] = cc then
   begin
   intern:= TRUE;
   if (i>0) and (j>0) and (brd[i-1, j-1]=0) then intern:= FALSE;
   if (i>0) and (brd[i-1, j]=0) then intern:= FALSE;
   if (i>0) and (j<7) and (brd[i-1, j+1]=0) then intern:= FALSE;
   if (i<7) and (j>0) and (brd[i+1, j-1]=0) then intern:= FALSE;
   if (i<7) and (brd[i+1, j]=0) then intern:= FALSE;
   if (i<7) and (j<7) and (brd[i+1, j+1]=0) then intern:= FALSE;
   if (j>0) and (brd[i, j-1]=0) then intern:= FALSE;
   if (j<7) and (brd[i, j+1]=0) then intern:= FALSE;
   if intern then inc(data.internal);
   end;

result:=data; 
end;

function CheckMove(color:byte; cx, cy: integer): integer;
// Function check: is move to (cx, cy) possible?
// Parameter: color - Who makes the move, black or white?
//            if (colour == 0) White do a move
//            if (colour == 1) Black do a move
// return: 0 - if impossible
//         1.. - if possible, and number
//               value is amount of the seized disks

var	test, passed: boolean;
	i, j, total: integer;
	wc1, wc2: byte;       // What to check

begin
total:=0;
// do a copy of board
for i:=0 to 7 do
 for j:=0 to 7 do
  brd2[i, j]:= brd[i, j];

if color=0 then   //white
 begin
 wc1:= 2;
 wc2:= 1;
 end
else
 begin
 wc1:= 1;
 wc2:= 2;
 end;

if brd[cy, cx]<> 0 then begin result:= 0; exit; end;
passed:= FALSE;
test:= FALSE;
for i:=cx-1 downto 0 do // Check left
 begin
 if brd[cy, i] = wc1 then test:= TRUE
 else
  if ((brd[cy, i] = wc2)  and  (test)) then
   begin
   passed:= TRUE;
   for j:=cx-1 downto i+1 do inc(total);
   for j:=cx-1 downto i+1 do brd2[cy, j]:= wc1; ////???????
   break;
   end
  else break;
 end;

test:= FALSE;
for i:=cx+1 to 7 do // Check Right
 begin
 if (brd[cy, i] = wc1) then test:= TRUE
 else
  if ((brd[cy, i] = wc2) and test) then
    begin
    passed:= TRUE;
    for j:=cx+1 to i-1 do inc(total);
    for j:=cx+1 to i-1 do brd2[cy, j]:= wc1;
    break;
    end
  else break;
 end;

test:= FALSE;
for i:=cy-1 downto 0 do // Check Up
 begin
 if (brd[i, cx] = wc1) then test:= TRUE
 else
  if ((brd[i, cx] = wc2) and test) then
   begin
   passed:= TRUE;
   for j:=cy-1 downto i+1 do inc(total);
   for j:=cy-1 downto i+1 do brd2[j, cx]:= wc1;
   break;
   end
  else break;
 end;

test:= FALSE;
for i:=cy+1 to 7 do // Check Down
 begin
 if (brd[i, cx] = wc1) then test:= TRUE
 else
  if ((brd[i, cx] = wc2)  and  (test)) then
   begin
   passed:= TRUE;
   for j:=cy+1 to i-1 do inc(total);
   for j:=cy+1 to i-1 do brd2[j, cx]:= wc1;
   break;
   end
  else break;
 end;

test:= FALSE;
for i:=1 to 7 do // Check Left-Up
 begin
 if (((cy-i) >= 0)  and  ((cx-i) >= 0)) then
  if (brd[cy-i, cx-i] = wc1) then test:= TRUE
  else
   if ((brd[cy-i, cx-i] = wc2)  and  (test)) then
    begin
    passed:= TRUE;
    for j:=1 to i-1 do inc(total);
    for j:=1 to i-1 do brd2[cy-j, cx-j]:= wc1;
    break;
    end
   else break
 else break;
 end;

test:= FALSE;
for i:=1 to 7 do // Check Left-Down
 begin
 if (((cy+i) < 8)  and  ((cx-i) >= 0)) then
  if (brd[cy+i, cx-i] = wc1) then test:= TRUE
  else
   if ((brd[cy+i, cx-i] = wc2)  and  (test)) then
    begin
    passed:= TRUE;
    for j:=1 to i-1 do inc(total);
    for j:=1 to i-1 do brd2[cy+j, cx-j]:= wc1;
    break;
    end
   else break
 else break;
 end;

test:= FALSE;
for i:=1 to 7 do // Check Right-Up
 begin
 if (((cy-i) >= 0)  and  ((cx+i) < 8)) then
  if (brd[cy-i, cx+i] = wc1) then test:= TRUE
  else
   if ((brd[cy-i, cx+i] = wc2)  and  (test)) then
    begin
    passed:= TRUE;
    for j:=1 to i-1 do inc(total);
    for j:=1 to i-1 do brd2[cy-j, cx+j]:= wc1;
    break;
    end
   else break
  else break;
 end;

test:= FALSE;
for i:=1 to 7 do // Check Right-Down
 begin
 if (((cy+i) < 8)  and  ((cx+i) < 8)) then
  if (brd[cy+i, cx+i] = wc1) then test:= TRUE
  else
   if ((brd[cy+i, cx+i] = wc2)  and  (test)) then
    begin
    passed:= TRUE;
    for j:=1 to i-1 do inc(total);
    for j:=1 to i-1 do brd2[cy+j, cx+j]:= wc1;
    break;
    end
   else break
 else break;
 end;

if passed then result:= total
else result:=0;
end;

function DoStep(data: pBoard): word;
// Function to do a single step
// Parameter data - a pointer to game board
// Return value WORD: low unsigned char contains x coordinate of move
//                    high unsigned char contains y coordinate of move
// if return value contains 0xFFFF then no move

var	i, j, k, l, value, value1, value2, value3: integer;
	pd, pdb, savedData: sPosData;
	fMove, fMoveb: boolean; // First move?

begin
for i:=0 to 7 do  // Copy data from source data to brd
 for j:=0 to 7 do
  brd[j,i]:= data^[j,i];

fMove:= TRUE;
for i:=0 to 7 do
 for j:=0 to 7 do
  begin
  if (CheckMove(0, j, i) > 0) then
   begin
   pd:= CalculateData(1, j, i);

   fMoveb:= TRUE;
   value:= 0;
   for k:=0 to 7 do
    for l:=0 to 7 do
     if (CheckMove(1, l, k) > 0) then
      begin
      pdb:= CalculateData(2, l, k);
      if pdb.corner then value3:=200 else value3:=0;
      value3:=value3+pdb.stable*4;
      value3:=value3+pdb.internal*3;
      //value3:=value3+pdb.disks;
      //if pdb.edge then value3:=value3+ 1;
      if pdb.square2x2 then value3:=value3-50;
      if fMoveb then
       begin
       value:= value3;
       fMoveb:= FALSE;
       end
      else
       if (value3 > value) then value:= value3;
      end;


   if fMove then
    begin
    savedData:= pd;
    fMove:= FALSE;
    end
   else
    begin
    if pd.corner then value1:=200 else value1:=0;
    value1:=value1+ pd.stable*5;
    value1:=value1+ pd.internal*3;
    value1:=value1+ pd.disks;
    if pd.edge then value1:=value1+ 1;
    if pd.square2x2 then value1:=value1- 50;

    value1:=value1- value;

    if savedData.corner then value2:=200 else value2:=0;
    value2:=value2+ savedData.stable*5;
    value2:=value2+ savedData.internal*3;
    value2:=value2+ savedData.disks;
    if savedData.edge then value2:=value2+ 1;
    if savedData.square2x2 then value2:=value2-50;

    if (value1 > value2) then
     move(pd,savedData,sizeof(sposdata));  //savedData:= pd;
    end;
   end;
  end;

  if not fMove then result:=savedData.my * 256 + savedData.mx
  else result:=65535;
end;

function winExecAndWait(const sAppPath: string; wVisible: word): boolean;
var
  si: TStartupInfo;
  pi: TProcessInformation;
  proc: THandle;
begin
  result:= false;
  fillChar(si, sizeOf(TStartupInfo),0);
  with si do begin
    cb:= sizeOf(TStartupInfo);
    dwFlags:= STARTF_USESHOWWINDOW OR STARTF_FORCEONFEEDBACK;
    wShowWindow:= wVisible;
  end;
  if NOT CreateProcess(NIL, pChar(sAppPath), NIL, NIL, false,
                       normal_Priority_class, NIL, NIL, si, pi)
  then begin
     raise Exception.CreateFmt('error during run'+'errcode %d',
                                      [getLastError]);
  end;
  proc:= pi.hProcess;
  closeHandle(pi.hThread);
  if waitForSingleObject(proc, infinite) =  wait_failed then
  result:= true;
  closeHandle(proc);
end;

end.
