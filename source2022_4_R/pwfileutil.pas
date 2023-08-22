{
  Authors/Credits: FPC RTL, Trustmaster (Vladimir Sibirov), L505 (Lars Olson)
  License: 
   FPC RTL Modified GPL. 
   However, any functions stamped with "Vladimir" are Artistic License. Any 
   functions stamped with "Lars" are NRCOL license (I hate GPL). Any functions 
   by both Lars & Vladimir are Artistic License. Functions are therefore free 
   software,  similar to dual licensed code, if you like.}

unit pwfileutil;

{$IFDEF FPC}{$MODE OBJFPC}{$H+}
  {$IFDEF EXTRA_SECURE}{$R+}{$Q+}{$CHECKPOINTER ON}{$ENDIF}
{$ENDIF}

interface
uses 
  pwtypes;

// default, read, readwrite, 
type TFmode = (fmDefault, fmR, fmRW);

procedure Xpath(var path: astr);
function NewFile(const fname: astr): bln;
function FileError: astr;
function MakeDir(s: astr): bln;


function ExtractFilePart(fpath: astr): astr;
function ExtractFname(const fpath: astr; ext: bln): astr;

function FileThere(const fname: astr; fm: TFmode): bln;

function ExtractFilePath(const FileName: string): string;
function ExtractFileDir(const FileName: string): string;
function ExtractFileDrive(const FileName: string): string;
function ExtractFileName(const FileName: string): string;
function ExtractFileExt(const FileName: string): string;

function ChangeFileExt(const FileName, Extension: string): string;


function ExtractRelativepath (Const BaseName,DestNAme : String): String;
function IncludeTrailingPathDelimiter(Const Path : String) : String;
function IncludeTrailingBackslash(Const Path : String) : String;
function ExcludeTrailingBackslash(Const Path: string): string;
function ExcludeTrailingPathDelimiter(Const Path: string): string;
function IsPathDelimiter(Const Path: string; Index: Integer): Boolean;
Procedure DoDirSeparators (Var FileName : String);
Function SetDirSeparators (Const FileName : String) : String;
Function GetDirs (Var DirName : String; Var Dirs : Array of pchar) : Longint;

// tests
procedure RunTest1;

// backwards compatibility
function FileExists_plain(const fname: astr): bln;
function FileExists_read(const fname: astr): bln;
function FileExists_readwrite(const fname: astr): bln;

Const
  DirSeparators : set of char = ['/','\'];


implementation

uses
  pwsubstr, pwstrutil;



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


{ BEGIN: FROM FPC SYSUTILS }

Const MaxDirs = 129;

function ExtractRelativepath (Const BaseName,DestName : String): String;
Var Source, Dest : String;
    Sc,Dc,I,J    : Longint;
    SD,DD        : Array[1..MaxDirs] of PChar;

Const OneLevelBack = '..' + PathDelim;

begin
  If Uppercase(ExtractFileDrive(BaseName))<>Uppercase(ExtractFileDrive(DestName)) Then
    begin
    Result:=DestName;
    exit;
    end;
  Source:=ExtractFilePath(BaseName);
  Dest:=ExtractFilePath(DestName);
  SC:=GetDirs (Source,SD);
  DC:=GetDirs (Dest,DD);
  I:=1;
  While (I<DC) and (I<SC) do
    begin
    If StrIcomp(DD[i],SD[i])=0 then
      Inc(i)
    else
      Break;
    end;
  Result:='';
  For J:=I to SC-1 do Result:=Result+OneLevelBack;
  For J:=I to DC-1 do Result:=Result+DD[J]+PathDelim;
  Result:=Result+ExtractFileName(DestNAme);
end;

Procedure DoDirSeparators (Var FileName : String);
var I : longint;
begin
  for I:=1 to Length(FileName) do
    If FileName[I] in DirSeparators then
      FileName[i]:=PathDelim;
end;


function SetDirSeparators (Const FileName : string) : String;
begin
  Result:=FileName;
  DoDirSeparators (Result);
end;

{
  DirName is split in a #0 separated list of directory names,
  Dirs is an array of pchars, pointing to these directory names.
  The function returns the number of directories found, or -1
  if none were found.
  DirName must contain only PathDelim as Directory separator chars.
}

Function GetDirs (Var DirName : String; Var Dirs : Array of pchar) : Longint;
var I : Longint;
begin
  I:=1;
  Result:=-1;
  While I<=Length(DirName) do
    begin
    If DirName[i]=PathDelim then
      begin
      DirName[i]:=#0;
      Inc(Result);
      Dirs[Result]:=@DirName[I+1];
      end;
    Inc(I);
    end;
  If Result>-1 then inc(Result);
end;

function IncludeTrailingPathDelimiter(Const Path : String) : String;
var
  l : Integer;
begin
  Result:=Path;
  l:=Length(Result);
  If (L=0) or (Result[l]<>PathDelim) then
    Result:=Result+PathDelim;
end;

function IncludeTrailingBackslash(Const Path : String) : String;
begin
  Result:=IncludeTrailingPathDelimiter(Path);
end;

function ExcludeTrailingBackslash(Const Path: string): string;
begin
  Result:=ExcludeTrailingPathDelimiter(Path);
end;

function ExcludeTrailingPathDelimiter(Const Path: string): string;
var L: Integer;
begin
  L:=Length(Path);
  If (L>0) and (Path[L]=PathDelim) then
    Dec(L);
  Result:=Copy(Path,1,L);
end;

function IsPathDelimiter(Const Path: string; Index: Integer): Boolean;
begin
  Result:=(Index>0) and (Index<=Length(Path)) and (Path[Index]=PathDelim);
end;

function ChangeFileExt(const FileName, Extension: string): string;
var i: longint;
begin
  I := Length(FileName);
  while (I > 0) and not(FileName[I] in ['/', '.', '\', ':']) do
    Dec(I);
  if (I = 0) or (FileName[I] <> '.') then
    I := Length(FileName)+1;
  Result := Copy(FileName, 1, I - 1) + Extension;
end;


function ExtractFilePath(const FileName: string): string;
var i: longint;
begin
  i := Length(FileName);
  while (i > 0) and not (FileName[i] in ['/', '\', ':']) do Dec(i);
  If I>0 then
    Result := Copy(FileName, 1, i)
  else
    Result:='';
end;

function ExtractFileDir(const FileName: string): string;
var i: longint;
begin
  I := Length(FileName);
  while (I > 0) and not (FileName[I] in ['/', '\', ':']) do Dec(I);
  if (I > 1) and (FileName[I] in ['\', '/']) and
    not (FileName[I - 1] in ['/', '\', ':']) then Dec(I);
  Result := Copy(FileName, 1, I);
end;

function ExtractFileDrive(const FileName: string): string;
var i: longint;
begin
  if (Length(FileName) >= 3) and (FileName[2] = ':') then
    result := Copy(FileName, 1, 2)
  else if (Length(FileName) >= 2) and (FileName[1] in ['/', '\']) and
    (FileName[2] in ['/', '\']) then
  begin
    i := 2;
    While (i < Length(Filename)) do
    begin
           if Filename[i + 1] in ['/', '\'] then break;
      inc(i);
    end ;
    Result := Copy(FileName, 1, i);
  end else Result := '';
end;

function ExtractFileName(const FileName: string): string;
var i: longint;
begin
  I := Length(FileName);
  while (I > 0) and not (FileName[I] in ['/', '\', ':']) do Dec(I);
  Result := Copy(FileName, I + 1, 255);
end;

function ExtractFileExt(const FileName: string): string;
var i: longint;
begin
  I := Length(FileName);
  while (I > 0) and not (FileName[I] in ['.', '/', '\', ':']) do Dec(I);
  if (I > 0) and (FileName[I] = '.') then
    Result := Copy(FileName, I, 255)
  else Result := '';
end;

{ END: FROM FPC SYSUTILS}

{ this grabs "file" from "file.ext" }
function ExtractFilePart(fpath: astr): astr;
var i: integer;
    dotcnt: byte;
begin
  result:= '';
  if fpath = '' then exit;
  fpath:= ExtractFileName(fpath);
  if fpath = '' then exit;
  dotcnt:= 0;
  for i:= length(fpath) downto 1 do begin
    if dotcnt > 0 then result:= fpath[i] + result;
    if fpath[i] = '.' then inc(dotcnt);
  end;
  if dotcnt < 1 then result:= fpath;
end;

{ if ext is set to false, only grab "file" from "file.ext" }
function ExtractFname(const fpath: astr; ext: bln): astr;
begin
  result:= '';
  if fpath = '' then exit;
  case ext of 
    true:  result:= ExtractFileName(fpath);
    false: result:= ExtractFilePart(fpath);
  end;
end;

procedure RunTest1;
begin
  writeln(ExtractFilePart('c:\tmp\blah.cool\success.txt'));
  writeln(ExtractFilePart('c:\tmp\blah.cool\success'));
  writeln(ExtractFname('c:\tmp\blah.cool\success.txt', false));
  writeln(ExtractFname('c:\tmp\blah.cool\success-with-ext.txt', true));
  writeln(ExtractFname('/path/special.success.txt', false));
  writeln(ExtractFname('/path/success', true));
  writeln(ExtractFname('/path/success', false));
  writeln(ExtractFilePart('/path/success.txt'));
  readln;
end;


{ creates a directory (not forced) By Lars (NRCOL) } 
function MakeDir(s: astr): bln;
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


{ cross platform file path slashes normalized
  By Lars (NRCOL) }
procedure Xpath(var path: astr);
begin
 {$IFDEF WINDOWS}path:= substrreplace(path, '/', '\');{$ENDIF}
 {$IFDEF UNIX}path:= substrreplace(path, '\', '/');{$ENDIF}
end;

{ creates new file, returns true if success  
  By Lars (NRCOL)}
function NewFile(const fname: astr): bln;
var
  fh: file of byte;
  oldfmode: byte;
begin
  result := false;
  oldfmode:= filemode;
  filemode:= fmOpenReadWrite; //  we need write access
 {$I-} // temporarily turn off io checking
  assign(fh, fname);
  rewrite(fh);
 {$I+}
  if ioresult = 0 then
  begin
    result := true;
    close(fh);
  end;
  //    debugln('FileExists_readwrite: ' + fname);
  filemode:= oldfmode;
end;

{ Alternative to fileexists, not requiring sysutils and uses Assign() and I/O
  to check if file exists }
function FileThere(const fname: astr; fm: TFmode): bln;
begin
  if fname = '' then exit;
  case fm of
    fmDefault: result:= fileexists_plain(fname);
    fmR:       result:= fileexists_read(fname);
    fmRW:      result:= fileexists_readwrite(fname);
  end;
end;

{ Checks if file exists, returns true if success 
  By Vladimir/Lars (Artistic) }
function FileExists_plain(const fname: astr): bln;
var
  fh: file of byte;
begin
  result := false;
 {$I-} // temporarily turn off io checking
  assign(fh, fname);
  reset(fh);
 {$I+}
  if ioresult = 0 then
  begin
    result := true;
    close(fh);
  end;
end;

{ Checks if file exists read only, returns true if success 
  By Vladimir/Lars (Artistic) }
function FileExists_read(const fname: astr): bln;
var
  fh: file of byte;
  oldfmode: byte;
begin
  result := false;
  oldfmode:= filemode;
  filemode:= fmOpenRead; // all we need is read access
 {$I-} // temporarily turn off io checking
  assign(fh, fname);
  reset(fh);
 {$I+}
  if ioresult = 0 then
  begin
    result := true;
    close(fh);
  end;
  filemode:= oldfmode;
end;

{ Checks if file exists with write access, returns true if success
  By Vladimir/Lars (artistic) }
function FileExists_readwrite(const fname: astr): bln;
var
  fh: file of byte;
  oldfmode: byte;
begin
  result := false;
  oldfmode:= filemode;
  filemode:= fmOpenReadWrite; //  we need write access
 {$I-} // temporarily turn off io checking
  assign(fh, fname);
  reset(fh);
 {$I+}
  if ioresult = 0 then
  begin
    result := true;
    close(fh);
  end;
  //    debugln('FileExists_readwrite: ' + fname);
  filemode:= oldfmode;
end;


{ Returns last I/O error message
  By Vladimir (artistic) }
function FileError: astr;
begin
  case ioresult of
    2: result := 'File not found';
    3: result := 'Path not found';
    4: result := 'Too many open files';
    5: result := 'Access denied';
    6: result := 'Invalid file handle';
    12: result := 'Invalid file-access mode';
    15: result := 'Invalid disk number';
    16: result := 'Cannot remove current directory';
    17: result := 'Cannot rename across volumes';
    100: result := 'Error when reading from disk';
    101: result := 'Error when writing to disk';
    102: result := 'File not assigned';
    103: result := 'File not open';
    104: result := 'File not opened for input';
    105: result := 'File not opened for output';
    106: result := 'Invalid number';
    150: result := 'Disk is write protected';
    151: result := 'Unknown device';
    152: result := 'Drive not ready';
    153: result := 'Unknown command';
    154: result := 'CRC check failed';
    155: result := 'Invalid drive specified';
    156: result := 'Seek error on disk';
    157: result := 'Invalid media type';
    158: result := 'Sector not found';
    159: result := 'Printer out of paper';
    160: result := 'Error when writing to device';
    161: result := 'Error when reading from device';
    162: result := 'Hardware failure';
  else
    // Emtpy line - OK
    result := '';
  end;
end;

end.
