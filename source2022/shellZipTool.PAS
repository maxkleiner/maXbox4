unit ShellZipTool;

interface


type
  TShellZip = class(TObject)
  private
    FFilter: string;
    FZipfile: WideString;
    shellobj: Olevariant;

    procedure CreateEmptyZip;
    function GetNameSpaceObj(x:OleVariant):OleVariant;
    function GetNameSpaceObj_zipfile:OleVariant;

  public
     procedure ZipFolder(const sourcefolder:WideString);
     procedure Unzip(const targetfolder: WideString);

     property Zipfile:WideString read FZipfile write FZipfile;
     property Filter:string read FFilter write FFilter;
  end;

function NumProcessThreads: integer;



implementation

uses Classes, Comobj, Windows, Tlhelp32, SysUtils, Variants;

const
  SHCONTCH_NOPROGRESSBOX = 4;
  SHCONTCH_AUTORENAME = 8;
  SHCONTCH_RESPONDYESTOALL = 16;
  SHCONTF_INCHIDDEN = 128;
  SHCONTF_FOLDERS = 32;
  SHCONTF_NONFOLDERS = 64;


function IsValidDispatch(const v:OleVariant):Boolean;
begin
  result := (VarType(v)=varDispatch) and Assigned(TVarData(v).VDispatch);
end;


function NumProcessThreads: integer;
var
  hsnapshot: THandle;
  Te32: TTHREADENTRY32;
  proch: dword;
begin
  Result := 0;

  proch := GetCurrentProcessID;

  hSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);

  Te32.dwSize := sizeof(TTHREADENTRY32);

  if Thread32First(hSnapShot, Te32) then
  begin
    if te32.th32OwnerProcessID = proch then
      inc(Result);

    while Thread32Next(hSnapShot, Te32) do
    begin
      if te32.th32OwnerProcessID = proch then
        inc(Result);
    end;
  end;
  CloseHandle(hSnapShot);
end;



{ TShellZip }

procedure TShellZip.CreateEmptyZip;
const
  emptyzip: array[0..23] of byte = (80,75,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
var
  ms: TMemoryStream;
begin
  // create a new empty ZIP file
  ms := TMemoryStream.Create;
  try
    ms.WriteBuffer(emptyzip, sizeof(emptyzip));
    ms.SaveToFile(Zipfile);
  finally
    ms.Free;
  end;
end;

function TShellZip.GetNameSpaceObj(x:OleVariant): OleVariant;
begin
  // WARNING:
  // the argument of .NameSpace must be a OleVariant
  // don't change "x" to string or WideString
  Result := shellobj.NameSpace(x);
end;

function TShellZip.GetNameSpaceObj_zipfile: OleVariant;
begin
  Result := GetNameSpaceObj(Zipfile);
  if not IsValidDispatch(Result) then
     raise EInvalidOperation.CreateFmt('<%s> invalid zipfile', [zipfile]);
end;


procedure TShellZip.ZipFolder(const sourcefolder: WideString);
var
  srcfldr, destfldr: OleVariant;
  shellfldritems: Olevariant;
  numt: integer;
begin
  if not FileExists(zipfile) then
  begin
    CreateEmptyZip;
  end;

  numt := NumProcessThreads;

  shellobj := CreateOleObject('Shell.Application');

  srcfldr := GetNameSpaceObj(sourcefolder);
  if not IsValidDispatch(srcfldr) then
     raise EInvalidOperation.CreateFmt('<%s> invalid source', [sourcefolder]);

  destfldr := GetNameSpaceObj_zipfile;

  shellfldritems := srcfldr.Items;

  if (filter <> '') then
    shellfldritems.Filter(SHCONTF_INCHIDDEN or SHCONTF_NONFOLDERS or SHCONTF_FOLDERS,filter);

  destfldr.CopyHere(shellfldritems, 0);

  // wait till all shell threads are terminated
  while NumProcessThreads <> numt do
  begin
    sleep(100);
  end;
end;


procedure TShellZip.Unzip(const targetfolder: WideString);
var
  srcfldr, destfldr: Olevariant;
  shellfldritems: Olevariant;
begin
  shellobj := CreateOleObject('Shell.Application');

  srcfldr := GetNameSpaceObj_zipfile;

  destfldr := GetNameSpaceObj(targetfolder);
  if not IsValidDispatch(destfldr) then
     raise EInvalidOperation.CreateFmt('<%s> invalid target folder', [targetfolder]);

  shellfldritems := srcfldr.Items;
  if (filter <> '') then
    shellfldritems.Filter(SHCONTF_INCHIDDEN or SHCONTF_NONFOLDERS or SHCONTF_FOLDERS,filter);

  destfldr.CopyHere(shellfldritems, SHCONTCH_NOPROGRESSBOX or SHCONTCH_RESPONDYESTOALL);
end;

end.


----code_cleared_checked----