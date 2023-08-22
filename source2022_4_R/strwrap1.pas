{ Authors: Lars (L505), JKP (YetAnotherGeek). See the /notes/ directory.
  Do not copy or distribute any of this file until you read strwrap1.note.txt }

unit StrWrap1;

{$ifdef FPC}
  {$mode objfpc}
  {$H+} //force ansi strings on
{$endif}

{$IFNDEF FPC}
  {$DEFINE windows} // todo: kylix ugly ifdef checks, sigh
{$ENDIF}

interface


{--- Public constants ---------------------------------------------------------}
const
  { File open modes }
  fmOpenRead       = $0000;
  fmOpenWrite      = $0001;
  fmOpenReadWrite  = $0002;
  { Share modes}
  fmShareCompat    = $0000;
  fmShareExclusive = $0010;
  fmShareDenyWrite = $0020;
  fmShareDenyRead  = $0030;
  fmShareDenyNone  = $0040;

 {$ifdef WINDOWS}
  CRLF: string = #13#10; // windows uses CRLF (carriage return and a line feed)
 {$endif}

 {$ifdef UNIX}
  CRLF: string = #10;    // linux uses LF. (line feed)
 {$endif}

 {$ifdef MACOS}
  CRLF: string = #13;    // old mac use CR (carriage return)
 {$endif}
{------------------------------------------------------------------------------}

                               
{--- public type --------------------------------------------------------------}
  type
    // string array
    StrArray = array of string;

    // store line numbers
    LnArray = array of integer;

    // string array with a count variable available
    StrArray_c = record
      Lines: array of string;
      Count: integer;
    end;
{------------------------------------------------------------------------------}


{--- public functions ---------------------------------------------------------}
type
 TFileOfChar = file of char;

  function OpenFileRead(var F:file; const fname: string; recsize: integer): boolean;
  function OpenFileReWrite(var F:file; const fname:string; recsize:integer): boolean;
  function OpenFile(var F: text; const fname: string; mode: char): boolean; overload;
  function OpenFile(var F: file; const fname: string; recsize:integer; mode: byte): boolean; overload;
  function OpenFile(var F: file; const fname: string; mode: char): boolean; overload;
  function OpenFile(var F: TFileOfChar; const fname: string; mode: char): boolean; overload;  

  function MakeDir(s: string): boolean;

  function ReadChunk(const fname: string; ChunkSize: integer; buf: pointer): boolean;
  function SaveChunk(fname: string; buf: pointer; chunksize: integer): boolean;

  function GetLineCount(const fname: string): longint;
  function FindLine(const fname: string; linenum: longword): boolean;  
  function GetFileSize(const fname: string): longint;

  function StrLoadFile(const fname: string): string;
  function StrSaveFile(const fname, InputStr: string): boolean; overload;
  function StrSaveFile(const fname, InputStr, endlnfeed: string): boolean; overload;
  function StrLoadLns(NumOfLines: integer; const fname:string): String;
  function StrLoadRng(FromLine: integer; ToLine:integer; const fname: string):String;

  function GetLn1(const fname: string): string;
  function GetLn2(const fname: string): string;
  function GetLnN(LineNumber: integer; const fname: string): string;

  function ArrayLoadFile(const fname:string): StrArray;
  function ArrayLoadFile_c(const fname: string): StrArray_c;
  function ArrayLoadFile_0(const fname: string): StrArray;
  function ArrayLoadFile_c_0(const fname: string): StrArray_c;
  function ArrayLoadLns(NumOfLines: integer; const fname: string): StrArray;
  function ArrayLoadLns_0(NumOfLines: integer; const fname: string): StrArray;
  function ArrayLoadRng(FromLine: integer; ToLine:integer; const fname: string): StrArray;
  function ArrayLoadRng_0(FromLine: integer; ToLine:integer; const fname: string): StrArray;

  function GetLastLns(const fname: string; NumLines: longint): string;

  function RemoveDupStrings(var InputStrArray: StrArray): integer;
(*  TO DO

  function StrLoadExact(LineNumsArray: LnArray; fname: string): string;
  function ArrayLoadExact(LineNumsArray: LnArray; fname: string): StrArray;
  function ArrayLoadExact_0(LineNumsArray: LnArray; fname: string): StrArray;
  function ArraySaveFile(InputArray: StrArray; fname: string): boolean;
  function StrAddLine: boolean;
  function FileAddLine: boolean;
  function StrAppendToFile: boolean;
  function FileAppendToStr: boolean;
*)

{------------------------------------------------------------------------------}


implementation


uses
  {$IFDEF UNIX}baseunix{$ENDIF}
  {$IFDEF WINDOWS}windows{$ENDIF};


function MakeDir(s: string): boolean;
begin
  result:= false;
 {$I-} // temporarily shut of io checking
  MkDir(s);
 {$I+}
  if IOResult <> 0 then
    result:= false
  else
    result:= true;
end;

{ Try to open a text file, return true on success.
  The MODE argument must be one of [R]=read, [W]=write, or [A]=append. }
function OpenFile(var F: text; const fname: string; mode: char): boolean;
var
  oldFM: byte;
begin
  if ( mode in ['A', 'R', 'W'] ) then
    inc(mode, 32); // convert "mode" to lowercase
  if ( mode in ['a', 'r', 'w'] ) then
  begin
    oldFM:= filemode;
    if ( mode= 'r') then filemode:= 0 else filemode:= 1;
    {$I-} // I/O checks off for now
     ioresult; // Clears any previous error.
     assign(F, fname);
     case mode of
       'a':append(F);
       'r':reset(F);
       'w':rewrite(F);
     end;
     Result:= (ioresult = 0);
    {$I+} // restore I/O checking
    filemode:= oldFM;
  end else
    Result:= FALSE; // invalid MODE argument
end;

function OpenFileRead(var F: file; const fname: string; recsize: integer): boolean;
var
  oldFM: byte;       
begin
  oldFM:= filemode;
  filemode:= fmOpenRead;
{$I-} // I/O checks off for now
  ioresult; // Clears any previous error.
  assign(F, fname);
  reset(F, recsize);
  Result:= (ioresult = 0);
{$I+} // restore I/O checking
  filemode:= oldFM;
end;


function OpenFile(var F: file; const fname: string; recsize: integer; mode: byte): boolean;
var                                                                                        
  oldFM: byte;
begin
  oldFM:= filemode;
  filemode:= mode; 
{$I-} // I/O checks off for now
  ioresult; // Clears any previous error.
  assign(F, fname);
  reset(F, recsize);
  Result:= (ioresult = 0);
{$I+} // restore I/O checking
  filemode:= oldFM;
end;

// tres to open file, forces file to be created if it does not exist
function OpenFileReWrite(var F: file; const fname: string; recsize: integer): boolean;
var                                                                                        
  oldFM: byte;
begin
  oldFM:= filemode;
  filemode:= fmOpenReadWrite; 
{$I-} // I/O checks off for now
  ioresult; // Clears any previous error.
  assign(F, fname);
  rewrite(F, recsize);
  Result:= (ioresult = 0);
{$I+} // restore I/O checking
  filemode:= oldFM;
end;


{ Try to open a file (doesn't have to be text) return false if unsuccessful }
function OpenFile(var F: file; const fname: string; mode: char): boolean;
var
  oldFM: byte;
begin
  if ( mode in ['R', 'W'] ) then
    inc(mode, 32); // convert "mode" to lowercase
  if ( mode in ['r', 'w'] ) then
  begin
    oldFM:= filemode;
    if ( mode= 'r') then filemode:= 0 else filemode:= 1;
    {$I-} // I/O checks off for now
     ioresult; // Clears any previous error.
     assign(F, fname);
     case mode of
       'r':reset(F);
       'w':rewrite(F);
     end;
     Result:= (ioresult = 0);
    {$I+} // restore I/O checking
    filemode:= oldFM;
  end else
    Result:= FALSE; // invalid MODE argument
end;

function OpenFile(var F: TFileOfChar; const fname: string; mode: char): boolean;
begin
  result:= OpenFile(f, fname, mode);
end;

{ Get the size of any file, doesn't matter whether it's a text or binary file.
  JEFF: return -1 if the file can't be found. }
{$IFDEF WINDOWS}
function GetFileSize(const fname: string): longint;
var
  FileInfo:WIN32_FIND_DATA;
  hInfo: THANDLE;
begin
  hInfo:= FindFirstFile(pChar(fname),
          {$ifdef fpc} @FileInfo
          {$else}       FileInfo {$endif});
  if ( hInfo <> INVALID_HANDLE_VALUE )
  then begin
    // Actually should return an Int64 ( for file size > 2GB )
    // Should be:
    //  Result:=( (FileInfo.nFileSizeHigh * (MAXDWORD+1)) + FileInfo.nFileSizeLow );
    Result:= FileInfo.nFileSizeLow;
    Windows.FindClose(hInfo);
  end else Result:= -1
end;
{$ELSE}
// Unix version:
function GetFileSize(const fname: string): longint;
var
  FileInfo:TStat;
begin
  if ( fpStat(fname,FileInfo) = 0 )
  then Result:= FileInfo.st_size
  else Result:= -1;
end;
{$ENDIF}


{ Get Line Count of a file

  NOTE: Using this function separately from other functions may not be optimal.
        If you can, choose a function that has the count already built into it.
        It's not usually a big deal. Line counts are fast anyway.   

 JEFF: return -1 on error}
function GetLineCount(const fname: string): longint;
var
  F: text;
begin
  Result:=-1;
  if not OpenFile(F, fname, 'r') then EXIT;
  Result:=0;
  while not EOF(F) do
  begin
    Readln(F);
    inc(result); //increment line count
  end;
  close(F); //close up file
end;


{ Verify line exists in file (i.e. on large files, does line 150000 exist?) }
function FindLine(const fname: string; linenum: longword): boolean;
var
  F: text;
  cnt: longword;
begin
  Result:= false;
  cnt:= 0;
  if not OpenFile(F, fname, 'r') then EXIT;
  while (result <> true) or (not EOF(F)) do
  begin
    Readln(F);
    inc(cnt); //increment line count
    if cnt = linenum then
      result:= true;
  end;
  close(F); //close file

end;

function StrLoadFile(const fname: string): string;
var
  F: file;
  InputFileSize: Integer;
  Buffer: Pointer;
begin
  result:= ''; // init               
  if OpenFile(F, fname, 1, fmOpenReadWrite) = false then 
  begin 
    result:= '-1NF';  EXIT;
  end;
  InputFileSize:= FileSize(F);
  SetLength(Result, InputFileSize);
  Buffer:= PChar(Result);
  BlockRead(F, Buffer^, InputFileSize);
  CloseFile(F);
end;

{ save a string directly to a file }
function StrSaveFile(const fname, InputStr: string): boolean; overload;
var
  F: file;
  OutputFileSize: integer;
  Buffer: Pointer;
begin
  result:= false;
  if OpenFileRewrite(F, fname, 1) = false then EXIT; // open in write mode
  OutputFileSize:= Length(inputstr);
  Buffer := PChar(inputstr);
  BlockWrite(F, Buffer^, OutputFileSize);
  CloseFile(F);
  result:= true;
end;

{ read a chunk from any file }
function ReadChunk(const fname: string; ChunkSize: integer; buf: pointer): boolean;
var
  f: file;
  readamt: integer;
begin
  result:= false;
  if OpenFileRead(F, fname, 1) = false then EXIT; // open in write mode
  BlockRead(F, Buf^, ChunkSize, readamt);
  if readamt = 0 then result:= false;
  CloseFile(F);
end;

{ save a chunk directly to a file }
function SaveChunk(fname: string; buf: pointer; chunksize: integer): boolean;
var
  F: file;
begin
  result:= false;
  // open in write mode  
  if OpenFileRewrite(F, fname, 1) = false then EXIT; 
  BlockWrite(F, Buf^, chunksize);
  CloseFile(F);
end;

{ same as above but ability to specify final line ending at end of file }
function StrSaveFile(const fname, InputStr, endlnfeed: string): boolean; overload;
var
  F: file;
  OutputFileSize: integer;
  Buffer: Pointer;
  tmpstr: string;
begin
  result:= false;
  if OpenFileRewrite(F, fname, 1) = false then EXIT; // open in write mode
  tmpstr:= inputstr + endlnfeed; // add custom line ending for very end of file
  OutputFileSize:= Length(tmpstr);
  Buffer := PChar(tmpstr);
  BlockWrite(F, Buffer^, OutputFileSize);
  CloseFile(F);
  result:= true;
end;

{ Load the first N lines of a file into a string directly. Without the entire
  file getting loaded into memory!
  Note: an extra carriage return is appended to the end }
function StrLoadLns(NumOfLines: longint; const fname: string): string;
var
  F: text;
  str1: string;
  Line: string;
  iLoc:longint;
begin
  result:= ''; //safety
  if not OpenFile(F, fname, 'r') then
  begin result:= '-1NF'; EXIT;
  end;
  str1:='';
  iLoc:=0;
  while ( iLoc < NumOfLines ) and ( not  EOF(F) ) do
  begin
    inc(iLoc);
    Readln(F,Line);
    str1:= str1 + Line + CRLF; //todo: optimize - concats are dead slow (L505)
  end;
  result:= str1;
  close(F); //close up file

end; { Todo: get rid of extra carriage return that is appended. Will require an
       extra if statement, so may cause some slow down }
     { NOTE: Personally, I think the extra CRLF is a good thing. (Jeff) }


{ Load certain range of lines from a text file into a string.
  Example: lines 10 to 15 only }
function StrLoadRng(FromLine:longint; ToLine:longint; const fname: string): string;
var
  F: text;
  str1: string;
  Line: string;
  iLoc:longint;
  GotLines: boolean; //to signal that we have 'got' all the lines we need
begin
  result:= ''; //safety
  GotLines:= false; //initialize as false
  if not OpenFile(F, fname, 'r') then
  begin result:= '-1NF'; EXIT;
  end;
  str1:='';
  iLoc:=0;
  while ( GotLines <> true )do
  begin
    if EOF(F) then gotlines:= true;
    inc(iLoc);
    if iLoc < FromLine then   //we are still before the specified range
      Readln(F);
    if iLoc >= FromLine then   //we are at the start of the specified range
    begin
      Readln(F,Line);
      str1:= str1+Line+CRLF; //todo: optimize - concats are dead slow (L505)
    end;
    if iLoc = ToLine then      //we've 'gotten' all the lines we need
      GotLines:= true;          //so exit this while loop
  end;
  result:= str1;
  close(F); //close file

end;


{ Get the first line of text into a string, from a specified file
  Tiny bit more efficient than using GetLnN, if you are only accessing Line 1
  Returns string '-1NF' if file NOT FOUND or could not open}
function GetLn1(const fname: string): string;
var
  F: text;
  Line: string;
begin
  result:= ''; //safety
  if not OpenFile(F, fname, 'r') then 
  begin result:= '-1NF'; EXIT;
  end;
  Readln(F, Line); //read only the first line of file
  result:= Line;
  close(F); //close file
end;


{ Get the second line of text into a string, from a specified file
  Tiny bit more efficient than using GetLnN, if you are only accessing Line 2 }
function GetLn2(const fname: string): string;
var
 F: text;
 Line: string;
begin
  result:= ''; //safety
  if not OpenFile(F, fname, 'r') then 
  begin result:= '-1NF'; EXIT;
  end;
  ReadLn(F); //pass the first line of the file
  ReadLn(F,Line); //read only the second line of file
  result:= Line;
  close(F); //close file
end;


{ Get specified Nth line in a text file into a string }
function GetLnN(LineNumber: longint; const fname: string): string;
var
  F: text;
  iLoc:longint; //local incremental longint
  Line: string;
//  GotLine: boolean;
begin
  result:= ''; //safety
  if ( LineNumber < 1 ) then  exit; //nothing to do, file lines start at line 1
  if not OpenFile(F, fname, 'r') then 
  begin result:= '-1NF'; EXIT;
  end;
  if not EOF(f) then //only continue reading the lines of the file until we have GOT our line that we want
  begin
    for iLoc:= 1 to LineNumber-1 do
       Readln(F);                    //get to the beginning of the specified line
     Readln(F, Line);
     result:= Line;
  end; //else past end of file
  close(F); //close file
end;


{ Load an entire text file into an array of strings. Each string in the array
  becomes each line of the text file, i.e. separated by carriage returns.
  Note: the array contents start at array[1], since we deal with line 1, not
  line 0, for clarity.
  note: must do your own error checking? if file does not exist you will get
        a range error if you use a loop out of range bounds}
function ArrayLoadFile(const fname: string): StrArray;
var
  F: text;
  Line: string;
  iLoc:longint;
begin
  setlength(result,1);
  result[0]:= '-1NF';  // error to array[0] if no file found
  if not OpenFile(F, fname, 'r') then EXIT; 
  iLoc:=0;
  while not Eof(F) do
  begin
    inc(iLoc);
    Readln(F,Line);
    setlength(result,iLoc + 1);
    result[iLoc]:= Line;
  end;
  close(F); //close up file
end; { Todo: optimize, maybe less setlengths somehow, since setlength is in a loop.}


{ Same as ArrayLoadFile except we return the count of our file's lines and use
  a record for the function return values. The c suffix stands for "count". 
  Returns -1NF in array[0] contents if file not found }  
function ArrayLoadFile_c(const fname: string): StrArray_c;
var
  F: text;
  Line: string;
  iLoc:longint;
begin
  setlength(result.Lines,1);
  result.Lines[0]:='-1NF'; // error to array[0] if no file found
  result.Count:= -1;   // returns count at -1 if nothing found
  if not OpenFile(F, fname, 'r') then EXIT;
  iLoc:=0;
  while not Eof(F) do
  begin
    inc(iLoc);
    Readln(F,Line);
    setlength(result.lines,iLoc+1);
    result.Lines[iLoc]:= Line;
  end;
  result.Count:= iLoc;
  close(F); //close file

end; { Todo: optimize, maybe less setlengths somehow, since setlength is in a loop.}


{ Same as ArrayLoadFile except array starts at [0] instead of [1]
  Returns -1NF in array[0] contents if file not found }
function ArrayLoadFile_0(const fname: string): StrArray;
var
  F: text;
  Line: string;
  iLoc:longint;
begin
  setlength(result,1);
  if not OpenFile(F, fname, 'r') then 
  begin result[0]:= '-1NF';  EXIT;
  end;
  iLoc:= -1;
  while not Eof(F) do
  begin
    inc(iLoc);
    Readln(F,Line);
    setlength(result,iLoc+1);
    result[iLoc]:= Line;
  end;
  close(F); //close up file

end; { Todo: optimize, maybe less setlengths somehow, since setlength is in a loop.}


{ Same as ArrayLoadFile_c except starts at [0] instead of [1] }
function ArrayLoadFile_c_0(const fname: string): StrArray_c;
var
  F: text;
  Line: string;
  i:longint;
begin
  setlength(result.Lines,1);
  result.Count:= -1;   //...
  if not OpenFile(F, fname, 'r') then
  begin result.Lines[0]:= '-1NF'; EXIT; 
  end;
  i:= -1;
  while not Eof(F) do
  begin
    inc(i);
    Readln(F, Line);
    setlength(result.Lines, i + 1);
    result.Lines[i]:= Line;
  end;
  result.Count:= i + 1 ; //since it's 0 based, we add 1 to get line count
  close(F); //close file
end; { Todo: optimize, preset length instead of in loop }


{ Load the first N lines of a file into an array of strings. Each line becomes
  a string in the array. Example: load the first 15 lines of a certain file.
  Note: the array contents start at array[1], since we deal with line 1, not
  line 0, for clarity. }
function ArrayLoadLns(NumOfLines:longint; const fname: string): StrArray;
var
  F: text;
  Line: string;
  iLoc:longint;
begin
  setlength(result,1);
  result[0]:= '-1NF'; //safety
  iLoc:= 0;
  setlength(result,NumOfLines+1); //we know the exact length that the array will be
  if not OpenFile(F, fname, 'r') then EXIT;
  while not ( Eof(F) ) and ( iLoc < NumOfLines ) do
  begin
    inc(iLoc);
    Readln(F,Line);
    result[iLoc]:= Line;
  end;
  close(F); //close up file
end;


{ Same as ArrayLoadLns, except start at array[0] instead of array[1]  }
function ArrayLoadLns_0(NumOfLines:longint; const fname: string): StrArray;
var
  F: text;
  Line: string;
  iLoc:longint;
begin
  setlength(result,NumOfLines); //we know the exact length that the array will be
  if not OpenFile(F, fname, 'r') then 
  begin result[0]:= '-1NF'; EXIT;
  end;
  iLoc:= -1;
  while( iLoc < NumOfLines-1 )  and ( not Eof(F) ) do
  begin
    inc(iLoc);
    Readln(F,Line);
    result[iLoc]:= Line;
  end;
  close(F); 

end;


{ Load a range of lines into a string array. Example: lines 11 to 16 into
  array[1] to array[6]
  note: array starts at 1 not 0 }
function ArrayLoadRng(FromLine:longint; ToLine:longint; const fname: string): StrArray;
var
  F: text;
  Line: string;
  iLoc:longint;
  RngAmt:longint;
begin
  RngAmt:= ToLine - FromLine + 1; //the range i.e. 4:6 is 4,5,6 so add 1 to subtraction
  setlength(result,(RngAmt)+2); //we know the exact length that the array will be  +2 because range 4 to 6 is three lines, not two. So +1,  and setlength is 0 based, so another +1.
  result[0]:= '-1NF'; 
  if not OpenFile(F, fname, 'r') then EXIT;
  if not ( Eof(F) ) then
  begin
    for iLoc:= 1 to FromLine-1 do
      readln(F); //go to the first line we need
    for iLoc:= 1 to RngAmt do
    begin
      Readln(F,Line);
      result[iLoc]:= Line;
    end;
  end; //else we are out of range, file isn't big enough for specified range
  close(F); //close file

end;


{ Same as ArrayLoadRng but array starts at [0] instead of [1] }
function ArrayLoadRng_0(FromLine:longint; ToLine:longint; const fname: string): StrArray;
var
  F: text;
  Line: string;
  iLoc,
  iLoc2:longint;
begin
  setlength(result,1);
  if not OpenFile(F, fname, 'r') then 
  begin result[0]:='-1NF'; EXIT;
  end;
  iLoc:= -1; iLoc2:= 0;
  setlength(result,(ToLine-FromLine)+1); //we know the exact length that the array will be  +2 because range 4 to 6 is three lines, not two. So +1
  while not ( Eof(F) ) and ( iLoc < ToLine-1 ) do
  begin
    inc(iLoc);      //current line we are at
    Readln(F,Line);
    if iLoc >= FromLine-1 then //we are in the correct range
    begin
      result[iLoc2]:= Line;
      inc(iLoc2);
    end;
  end;
  close(F); //close file

end;


{ get n amount of lines at the end of the text file, returns -1NF if file not found }
function GetLastLns(const fname: string; NumLines: longint): string;
var
  LineCnt: longint;
  StartAt: longint;
  F: text;
  i: integer; //loop
  C: char;
begin
  result:= ''; //safety
  LineCnt:= GetLineCount(fname);
  if not OpenFile(F, fname, 'r') then 
  begin 
    result:= '-1NF'; 
    exit;
  end;
  // the line we will start reading at
  StartAt:= LineCnt - NumLines;
  // pass by all lines until we arrive at the designated line
  for i:= 1 to StartAt do
    Readln(F);
  //now we can grab all the characters
  while not Eof(f) do
  begin
    Read(F, C);
    result:= result + C;
  end;
  close(f);
end;

// remove duplicate strings from an array of strings that is sorted. Returns
// number of duplicates found, 0 if none are found
// note: will not work unles string array is sorted!
function RemoveDupStrings(var InputStrArray: StrArray): integer;
var
  iLoc: integer; //local loop integer
  iLoc2: integer; //local increment integer
  NonDupeStrArray: StrArray;
begin
  result:= -1; //safety
  SetLength(NonDupeStrArray, 0);
  if length(InputStrArray) = 0 then EXIT;
  if length(InputStrArray) = 1 then EXIT; //must be at least length of 2 to have a duplicate
//  setlength(NonDupeStrArray, 1);

  //give ourselves an extra buffer zone (1 additional blank string) at the end of the array, so we can check all the strings in the below loop (otherwise runtime error when adding 1 to iLoc)
  setlength(InputStrArray, length(InputStrArray) + 1);

  iLoc2:= 0;
  for iLoc:= 0 to length(InputStrArray) - 2 do //up until the second last string in the array (last string is checked second last)
  begin
      // only record the string if it is not a duplicate
      if (InputStrArray[iLoc] <> InputStrArray[iLoc + 1]) then
      begin
        setlength(NonDupeStrArray, length(NonDupeStrArray) + 1);
        NonDupeStrArray[iLoc2]:= InputStrArray[iLoc];
        inc(iLoc2);
      end;
  end;

  result:= length(InputStrArray) - length(NonDupeStrArray) - 1;
  setlength( InputStrArray, length(NonDupeStrArray) );
  InputStrArray:= NonDupeStrArray;
  //get rid of extra buffer zone at end of array
//  setlength(InputStrArray, length(InputStrArray) - 1 );
  { todo: optimize length() calls and setlength() where possible }
end;


(* Other functions to work on, or not working yet...





{ NOT WORKING YET

  Load only certain lines into a string var. Example: lines 11,13,21
  Note: appends an extra carriage return to end of string }
function StrLoadExact(LineNumsArray:LnArray; fname:string): string;
begin
//LnArray
end;

*)

(*

{ NOT WORKING YET
  Load only certain lines into a string array. Example: lines 11,13,21,8,6
  into array[1] to array[5]
  note: array starts at 1 not 0
        -lines specified in LineNumsArray can be in any order.. but
         ArrayLoadExactC will be faster, if you specify 6,8,11,13,21 instead.
         This is because ArrayLoadExact has to sort your stuff for you first,
         but this may be convenient at times.}
function ArrayLoadExact(LineNumsArray:LnArray; fname:string): StrArray;
var
  F: text;
  Line: string;
  iLoc,
  iLoc2,
  iLoc3:integer;
  GotLines: boolean; //to signal that we have 'got' all the lines we need
begin
  setlength(result,1);
  if FileExists(fname) = false then
  begin
    result[0]:=''; //returns nothing if file not found
    exit;
  end;
  result[0]:=''; //safety
  GotLines:= false; //initialize as false
  Assign(F, fname);
  Reset(F);
  iLoc:= 0; iLoc2:= 1; iLoc3:= 0;
  setlength(result,length(LineNumsArray)+1); //we know the exact length that the array will be
  while not ( Eof(F) ) and ( GotLines <> true ) do
  begin
    inc(iLoc);      //current line we are at
    Readln(F,Line);
   {if LineNumsArray[iLoc3] = iLoc then
    begin
      inc(iLoc3);
      result[iLoc3+1]:= Line;
    end;  }
    for iLoc3:= 0 to length(LineNumsArray)-1 do //optimize this
    begin
     if LineNumsArray[iLoc3] = iLoc then //we are on a line specified
       result[iLoc3+1]:= Line;
    end;
    if iLoc = LineNumsArray[length(LineNumsArray)-1] then   //we've 'gotten' all the lines we need
      GotLines:= true;         //so exit this while loop
  end;
  close(F); //close up file
end;

*)
(*

{ NOT WORKING YET
  Same as ArrayLoadExact except array starts at [0] instead of [1] }
function Array0LoadExact(LineNumsArray:LnArray; fname:string): StrArray;
var
  F: text;
  Line: string;
  iLoc,
  iLoc2,
  iLoc3:integer;
  GotLines: boolean; //to signal that we have 'got' all the lines we need
begin
  setlength(result,1);
  if FileExists(fname) = false then
  begin
    result[0]:=''; //returns nothing if file not found
    exit;
  end;
  result[0]:=''; //safety
  GotLines:= false; //initialize as false
  Assign(F, fname);
  Reset(F);
  iLoc:= -1; iLoc2:= 0; iLoc3:= 0;
  setlength(result,length(LineNumsArray)); //we know the exact length that the array will be
  while not ( Eof(F) ) and ( GotLines <> true ) do
  begin
    inc(iLoc);      //current line we are at
    Readln(F,Line);
   {if LineNumsArray[iLoc3] = iLoc then
    begin
      inc(iLoc3);
      result[iLoc3]:= Line;
    end;  }
    for iLoc3:= 0 to length(LineNumsArray)-1 do
    begin
     if LineNumsArray[iLoc3] = iLoc then //we are on a line specified
       result[iLoc3]:= Line;
    end;
    if iLoc = LineNumsArray[length(LineNumsArray)-1] then   //we've 'gotten' all the lines we need
      GotLines:= true;         //so exit this while loop
  end;
  close(F); //close up file
end;

*)

{ TODO FUNCTIONS }

// Save a string directly to a file
{ function StrSaveFile(InputString:string; fname: string): boolean; }

// Save an array of strings directly to a file
{ function ArraySaveFile(InputArray: StrArray; fname: string): boolean; }


{ OLD FUNCTIONS }


(* This one was a little bit slower

function StrLoadFile(const fname: string): string;
var
  F: file;
  InputFileSize: Integer;
  Buffer: Pointer;
begin
  result:= ''; // safety
  FileMode:= fmOpenRead;
  // TODO: Binary open file routine like Jeff's for text files, w/error checking
  AssignFile(F, fname);
  Reset(F, GetFileSize(fname));
  InputFileSize:= GetFileSize(fname);
  SetLength(Result, InputFileSize);
  Buffer:= PChar(Result);
  BlockRead(F, Buffer^, 1);
  CloseFile(F);
end;
*)

end.





