unit xrtl_util_FileUtils;

{$INCLUDE xrtl.inc}

interface

function XRTLExtractLongPathName(APath: string): string;

implementation

uses
  SysUtils,
  xrtl_util_Type, xrtl_util_Compat;

function GetLongName(const FixedPath: string; var APath: string): string;
var
  SR: TSearchRec;
begin
  APath:= ExcludeTrailingPathDelimiter(APath);
  try
    if FindFirst(FixedPath + APath, faAnyFile, SR) <> 0 then
      raise Exception.CreateFmt('''%s'' not found', [FixedPath + APath]);
    APath:= ExtractFileDir(APath);
    Result:= SR.Name;
  finally
    FindClose(SR);
  end;
end;

function XRTLExtractLongPathName(APath: string): string;
var
  ADriveName, APathName, AFileName: string;
begin
  Result:= '';
  ADriveName:= IncludeTrailingPathDelimiter(ExtractFileDrive(APath));
  APathName:= ExtractFilePath(APath);
  Delete(APathName, 1, Length(ADriveName));
  AFileName:= ExtractFileName(APath);
  while APathName <> '' do
  begin
    Result:= IncludeTrailingPathDelimiter(GetLongName(ADriveName, APathName)) + Result;
  end;
  Result:= IncludeTrailingPathDelimiter(ADriveName + Result);
  Result:= Result + GetLongName(Result, AFileName);
end;

end.
