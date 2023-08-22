{
 ****************************************************************************
    $Id: fileio.pas,v 1.8 2007/02/03 21:04:34 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Generic portable file I/O routines with debug support.

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}

{** 
    @author(Carl Eric Codere)
    @abstract(File I/O unit)
    
    This a replacement File I/O unit containing routines
    to access files on disk. They are a better replacement
    of the standard system I/O routines since they support
    larger file sizes, as well as debugging features.
    
    If DEBUG is defined, when the application quits, files
    that are still opened will be displayed on the console.
    It is important to note, that only the files opened
    with this API can be checked this way.
    
}
unit fileio;
{$I-}
{$B+}
{.$DEFINE DEBUG}



interface

//uses
  //dpautils,
  //vpautils,
  //fpautils,
  //gpautils,
  //tpautils;

  uses windows;

  TYPE
    { The biggest integer type available to this compiler }
    big_integer_t = int64;

  
{** @abstract(Assign a filename to a file)

    This is uased to assign a filename with a file. This assignment
    will then permit to operate on the file. The assignment is
    completely compatible with the standard @code(AssignFile)
    system unit routine.
}    
procedure FileAssign(var F: file; const Name: string);

{** @abstract(Open a file for reading or writing)

    This opens a file using a specified file mode. The filemonde
    constants are defined in other units (fmXXXX constants). The
    file should have previously been assigned using @code(FileAssign).
}    
procedure FileReset(var F: file; mode: integer);

{** @abstract(Open/Overwrite a file)

    This creates a file or overwrites a file (if it does not exist).
    Currently the mode constant is not used, since the file is 
    always opened in read/write mode.
    
    The file should have previously been assigned using 
    @code(FileAssign).
}    
procedure FileRewrite(var F: file; mode: integer);

{** @abstract(Close a previously opened file)

    This closes a file that was previously opened by a call to
    FileOpen or FileReset. 
}    
procedure FileClose(var F: file);

{** @abstract(Read data from a file)
  
    Reads data bytes from the specified opened file. Returns 
    the number of bytes actually read.
}    
function FileBlockRead(var F: file; var Buf; Count: integer): integer;

{** @abstract(Write data to a file)

    Write data bytes to the specified opened file. Returns 
    the number of bytes actually written.
}    
function FileBlockWrite(var F: file; var Buf; Count: integer): integer;

{** @abstract(Change the file pointer position of an opened file)

    Seeks to a specific file position in a file (starting from zero 
    which is the start of the file). 
}    
procedure FileSeek(var F: file; N: big_integer_t);

{** @abstract(Get the size of a file in bytes)

    Returns the current size of the file in bytes. The file must
    be assigned and opened to access this routine.
}    
function FileGetSize(var F: file): big_integer_t;

{** @abstract(Return the current file pointer position)

    Returns the current file pointer position within the file. The
    start of the file is at position zero.
}    
function FileGetPos(var F: file): big_integer_t;

{** @abstract(Return the result of the last I/O operation)

    Returns the I/O Result of the last operation. If this routine
    is not called and the unit is compiled with the DEBUG define, and
    if there was an error in the last operation, then the next File I/O 
    operation will cause a runtime error with the I/O error code.
}    
function FileIOResult: integer;

{** @abstract(Truncate a file at the current file position)

    Truncates a file at the current file position. File must be
    assigned and opened.
}    
procedure FileTruncate(var F: file);


implementation

uses {dos,collects,} xutils,strings, sysutils;

{$IFDEF DEBUG}
  var OpenedFileCollection: TExtendedSortedStringCollection;
{$ENDIF}

var
 LastIOResult: integer;

function FileIOResult: integer;
begin
  FileIOResult:=LastIOResult;
  LastIOResult:=0;
end;

procedure FileAssign(var F: file; const Name: string);
var
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  Assign(F,name);
  LastIOResult:=IOResult;
end;

type
  FileRec = System.TFileRec;

procedure FileReset(var F: file; mode: integer);
var
 OldFileMode: integer;
 FRec: FileRec;
 s: string;
 p: pshortstring;
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
 OldFileMode:=FileMode;
 FileMode:=mode and $ff;
 Reset(F,1);
{$IFDEF DEBUG}
  FRec:=FileRec(F);
  s:=strpas(FRec.name);
  p:=stringdup(s);
  OpenedFileCollection.Insert(p);
{$ENDIF}
 FileMode:=OldFileMode and $ff;
 LastIOResult:=IOResult;
end;

procedure FileRewrite(var F: file; mode: integer);
var
 Frec: FileRec;
 s: string;
 p: pshortstring;
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
 Rewrite(F,1);
{$IFDEF DEBUG}
  FRec:=FileRec(F);
  s:=strpas(FRec.name);
  p:=stringdup(s);
  OpenedFileCollection.Insert(p);
{$ENDIF}
  LastIOResult:=IOResult;
end;

procedure FileClose(var F: file);
var
 Index: integer;
 Frec: FileRec;
 s: string;
 p: pshortstring;
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  FRec:=FileRec(F);
{$IFDEF DEBUG}
  s:=strpas(Frec.name);
  p:=stringdup(s);
  if OpenedFileCollection.Search(p,Index) then
    begin
      OpenedFileCollection.Free(OpenedFileCollection.At(Index));
    end;
  stringdispose(p);  
{$ENDIF}
  Close(F);
  LastIOResult:=IOResult;
end;

function FileBlockRead(var F: file; var Buf; Count: integer): integer;
var
 _result: integer;
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  _result:=0;
  BlockRead(F,Buf,count,_result);
  FileBlockRead:=_result;
  LastIOResult:=IOResult;
end;

function FileBlockWrite(var F: file; var Buf; Count: integer): integer;
var
 _result: integer;
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  {Bugfix under Windows and RTL, the value is never set! } 
  _result:=0;
  BlockWrite(F,Buf,Count,_result);
  FileBlockWrite:=_result;
  LastIOResult:=IOResult;
end;

procedure FileSeek(var F: file; N: big_integer_t);
var
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  Seek(F,longint(N));
  LastIOResult:=IOResult;
end;

function FileGetSize(var F: file): big_integer_t;
var
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  FileGetSize:=FileSize(F);
  LastIOResult:=IOResult;
end;

function FileGetPos(var F: file): big_integer_t;
var
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  FileGetPos:=FilePos(F);
  LastIOResult:=IOResult;
end;

procedure FileTruncate(var F: file);
var
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  Truncate(F);
  LastIOResult:=IOResult;
end;


{$IFDEF DEBUG}
var
  ExitSave: pointer;

procedure CheckFiles;far;
var
 i: integer;
 p: pshortstring;
begin
  ExitProc := ExitSave;
  for i:=0 to OpenedFileCollection.count -1 do
    begin
      p:=OpenedFileCollection.At(i);
      WriteLn('File not closed: ',p^);
    end;
  OpenedFileCollection.done;
end;
{$ENDIF}


Begin
{$IFDEF DEBUG}
  ExitSave:= ExitProc;
  ExitProc := @CheckFiles;
  OpenedFileCollection.init(8,8);
  { Allow duplicates }
  OpenedFileCollection.Duplicates:=true;
{$ENDIF}
end.

{
  $Log: fileio.pas,v $
  Revision 1.8  2007/02/03 21:04:34  carl
   Workaround for Delphi 7 RTL bug

  Revision 1.7  2007/01/06 15:54:24  carl
    -  remove debug option
    * bugfix without debug option, would fail

  Revision 1.6  2006/08/31 03:07:28  carl
  + FileAssign also checks for last IOResult

  Revision 1.5  2004/11/21 19:52:22  carl
    * bugfix with FileReset, record size was 128, which is wrong, set to 1
    + const parameters for filenames

  Revision 1.4  2004/11/19 01:37:27  carl
    + more documentation

  Revision 1.3  2004/11/18 21:22:55  user63
    * bugfix, wrong runtime error was generated

  Revision 1.2  2004/11/17 22:12:36  user63
    * bugfix with memory allocation (big heap leak!)

  Revision 1.1  2004/11/17 04:02:15  carl
    + Portable API for reading and writing to and from files.


}





