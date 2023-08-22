unit DPFile;

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  TFileTimes = record
    CreationTime: TDateTime;
    LastAccessTime: TDateTime;
    LastWriteTime: TDateTime;
  end;

function GetFileSize(FFileHandle: Integer): LongInt;
function GetFileTimes(FFileHandle: Integer): TFileTimes;

function MakeFileOpen(FFileName: string; var FFileHandle: Integer; Mode: LongWord = fmOpenRead or fmShareDenyNone): Boolean;
function MakeFileClose(FFileHandle: Integer): Boolean;

function MakeFileRead(FFileHandle: Integer; var Buffer; Count: Integer): Boolean;
function MakeFileWrite(FFileHandle: Integer; var Buffer; Count: Integer): Boolean;

function MakeFileReadStr(FFileHandle: Integer): string;
procedure MakeFileWriteStr(FFileHandle: Integer; s: string);

implementation

function FileTimeToDateTime(AFileTime: FILETIME): TDateTime;
var LocalFileTime: FILETIME;
    SystemFileTime: SYSTEMTIME;

begin
  FileTimeToLocalFileTime(AFileTime, LocalFileTime);
  FileTimeToSystemTime(LocalFileTime, SystemFileTime);

  with SystemFileTime do
    result:=EncodeDate(wYear, wMonth, wDay)+EncodeTime(wHour, wMinute, wSecond, 0); 
end;

//

function GetFileSize(FFileHandle: Integer): LongInt;
var dwSizeLow, dwSizeHigh: LongWord;

begin
  dwSizeLow:=Windows.GetFileSize(FFileHandle, @dwSizeHigh);
  result:=(dwSizeHigh * MAXDWORD) + dwSizeLow;
end;

function GetFileTimes(FFileHandle: Integer): TFileTimes;
var CreationTime, LastAccessTime, LastWriteTime: FILETIME;
  
begin
  GetFileTime(FFileHandle, @CreationTime, @LastAccessTime, @LastWriteTime);
  result.CreationTime:=FileTimeToDateTime(CreationTime);
  result.LastAccessTime:=FileTimeToDateTime(LastAccessTime);
  result.LastWriteTime:=FileTimeToDateTime(LastWriteTime);
end;

//

function MakeFileOpen(FFileName: string; var FFileHandle: Integer; Mode: LongWord = fmOpenRead or fmShareDenyNone): Boolean;
begin
  if FFileName<>'' then
    if not FileExists(FFileName) and (((Mode and fmOpenWrite)<>0) or ((Mode and fmOpenReadWrite)<>0)) then
      FFileHandle:=FileCreate(FFileName)
    else
      FFileHandle:=FileOpen(FFileName, Mode);

  result:=(FFileHandle>-1);
end;

function MakeFileClose(FFileHandle: Integer): Boolean;
begin
  if FFileHandle>-1 then
  begin
    FileClose(FFileHandle);
    result:=True;
  end
  else
    result:=False;
end;

//

function MakeFileRead(FFileHandle: Integer; var Buffer; Count: Integer): Boolean;
begin
  if FFileHandle>-1 then
    result:=FileRead(FFileHandle, Buffer, Count)<>-1
  else
    result:=False;
end;

function MakeFileWrite(FFileHandle: Integer; var Buffer; Count: Integer): Boolean;
begin
  if FFileHandle>-1 then
    result:=FileWrite(FFileHandle, Buffer, Count)<>-1
  else
    result:=False;
end;

//

function MakeFileReadStr(FFileHandle: Integer): string;
var len: Integer;

begin
  result:='';

  MakeFileRead(FFileHandle, len, sizeof(Integer));

  if len>0 then
  begin
    SetLength(result, len);
    MakeFileRead(FFileHandle, result[1], len);
  end;
end;

procedure MakeFileWriteStr(FFileHandle: Integer; s: string);
var len: Integer;

begin
  len:=Length(s);

  MakeFileWrite(FFileHandle, len, sizeof(Integer));

  if len>0 then
    MakeFileWrite(FFileHandle, s[1], len);
end;

end.
