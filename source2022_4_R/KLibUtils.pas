{
  KLib Version = 2.0
  The Clear BSD License

  Copyright (c) 2020 by Karol De Nery Ortiz LLave. All rights reserved.
  zitrokarol@gmail.com

  Redistribution and use in source and binary forms, with or without
  modification, are permitted (subject to the limitations in the disclaimer
  below) provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  * Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

  NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY
  THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
  CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.   enhanced to maXbox4
}

unit KLibUtils;

interface

uses
  //KLib.Types, KLib.Constants,
  //Vcl.Imaging.pngimage,
  KLibTypes, SysUtils, Classes;

//https://github.com/karoloortiz/Delphi_Utils_Library/blob/master/KLib.Constants.pas  

const
  DATE_FORMAT = 'yyyy-mm-dd';
  DATE_FORMAT_ITALIAN = 'dd/mm/yyyy';
  DATETIME_FORMAT = 'yyyy-mm-dd hh:nn:ss';
  DATETIME_FORMAT_ITALIAN = 'dd/mm/yyyy hh:nn:ss';
  TIMESTAMP_FORMAT = 'yyyymmddhhnnss';

  SEMICOLON_DELIMITER = ';';

  DECIMAL_SEPARATOR_IT = ',';
  MYSQL_DECIMAL_SEPARATOR = '.';

  WINDOWS_PATH_DELIMITER = '\';
  LINUX_PATH_DELIMITER = '/';

  LOCALHOST_IP_ADDRESS = '127.0.0.1';
  FTP_DEFAULT_PORT = 21;

  _1_MB_IN_BYTES = 1048576;

  CMD_EXE_NAME = 'cmd.exe';

  PNG_TYPE = 'PNG';
  ZIP_TYPE = 'ZIP';
  XSL_TYPE = 'XSL';
  XML_TYPE = 'XML';
  EXE_TYPE = 'EXE';
  JSON_TYPE = 'JSON';
  RTF_TYPE = 'RTF';
  DLL_TYPE = 'DLL';

  EVERYONE_GROUP = 'Everyone';
  USERS_GROUP = 'Users';

  C_DRIVE = 'C';

  RANDOM_STRING = '99~@(To4h7KeFSX|{T2M';
  SPACE_STRING = ' ';
  EMPTY_STRING = '';

  RUN_AS_ADMIN = true;

  NOT_FORCE = false;
  NOT_FORCE_OVERWRITE = NOT_FORCE;
  FORCE = true;
  FORCE_OVERWRITE = FORCE;
  FORCE_DELETE = FORCE;

  RAISE_EXCEPTION = true;
  //Keystroke Message Flag
  //https://docs.microsoft.com/en-us/windows/win32/inputdev/about-keyboard-input
  //https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html
  //Keystroke Message Flag impostato ad 1835009 (DECIMAL VALUE) che in binario corrisponde a 0000000000111000000000000000001
  // l_param
  //i valori dallo 0 al 15 specificano il numero di volte che e' stato premuto il tasto
  //(nel nostro caso 0000000000000001)
  //i valori dal 16-23 specificano lo scan code e questo dipende dal produtttore OEM
  //(nel nostro caso 00011100) tastiera Logitech K120
  //il valore 24 se settato a 1 indica se il tasto premuto e' uno steso, come ad esempio un tasto funzione o numerico
  //(nel nostro caso 0)
  //i valori dal 25-28 sono riservati
  //(nel nostro caso 0000)
  //il valore 24 se settato a 1 indica se il tasto premuto il pulsante ALT
  //(nel nostro caso 0)
  //il valore 30 se settato a 1 indica che lo stato precedente del tasto era key_down
  //(nel nostro caso 0)
  //il valore 31 se settato a 1 indica che lo stato transitorio del tasto e' stato appena rilasciato
  //(nel nostro caso 0)

  KF_CODE_ENTER = 1835009;

  REGEX_VALID_EMAIL =
    '([!#-''*+/-9=?A-Z^-~-]+(\.[!#-''*+/-9=?A-Z^-~-]+)*|"([]!#-[^-~ \t]|(\\[\t -~]))+")@([0'
    + '-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?(\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])'
    + '?)*|\[((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1'
    + '-9]?[0-9])){3}|IPv6:((((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){6}|::((0|[1-9A-Fa-f][0-9A-Fa-'
    + 'f]{0,3}):){5}|[0-9A-Fa-f]{0,4}::((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){4}|(((0|[1-9A-Fa-f]'
    + '[0-9A-Fa-f]{0,3}):)?(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}))?::((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}'
    + '):){3}|(((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){0,2}(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}))?::((0|'
    + '[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){2}|(((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){0,3}(0|[1-9A-Fa-'
    + 'f][0-9A-Fa-f]{0,3}))?::(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):|(((0|[1-9A-Fa-f][0-9A-Fa-f]{0,'
    + '3}):){0,4}(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}))?::)((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):(0|[1-9'
    + 'A-Fa-f][0-9A-Fa-f]{0,3})|(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])(\.(25[0-5]|2[0-4]'
    + '[0-9]|1[0-9]{2}|[1-9]?[0-9])){3})|(((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){0,5}(0|[1-9A-Fa-'
    + 'f][0-9A-Fa-f]{0,3}))?::(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3})|(((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3'
    + '}):){0,6}(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}))?::)|(?!IPv6:)[0-9A-Za-z-]*[0-9A-Za-z]:[!-Z^-'
    + '~]+)])';


type TCredentials = record
    username: string;
    password: string;

    procedure clear;
  end;
  

procedure deleteFilesInDir(pathDir: string; const filesToKeep: array of string);
procedure deleteFilesInDirWithStartingFileName(dirName: string; startingFileName: string; fileType: string = EMPTY_STRING);
function checkIfFileExistsAndEmpty(fileName: string): boolean;
procedure deleteFileIfExists(fileName: string);
function getTextFromFile(fileName: string): string;

function checkIfThereIsSpaceAvailableOnDrive(drive: char; requiredSpaceInBytes: int64): boolean;
function getFreeSpaceOnDrive(drive: char): int64;
function getIndexOfDrive(drive: char): integer;
function getDriveExe: char;
function getDirSize(path: string): int64;
function getCombinedPathWithCurrentDir(pathToCombine: string): string;
function getDirExe: string;
procedure createDirIfNotExists(dirName: string);

function checkIfIsLinuxSubDir(subDir: string; mainDir: string): boolean;
function getPathInLinuxStyle(path: string): string;

function checkIfIsSubDir(subDir: string; mainDir: string; trailingPathDelimiter: char = SPACE_STRING): boolean;
function getValidFullPath(fileName: string): string;

function checkMD5File(fileName: string; MD5: string): boolean;

procedure unzipResource(nameResource: string; destinationDir: string);
//function getPNGResource(nameResource: string): TPngImage;
procedure getResourceAsEXEFile(nameResource: string; destinationFileName: string);
procedure getResourceAsZIPFile(nameResource: string; destinationFileName: string);
procedure getResourceAsFile(resource: TResource; destinationFileName: string);
function getResourceAsString(resource: TResource): string;
function getResourceAsStream(resource: TResource): TResourceStream;

procedure unzip(zipFileName: string; destinationDir: string; deleteZipAfterUnzip: boolean = false);

function checkRequiredFTPProperties(FTPCredentials: TFTPCredentials): boolean;

function getValidItalianTelephoneNumber(number: string): string;
function getValidTelephoneNumber(number: string): string;

function getRandString(size: integer = 5): string;

function getFirstFileNameInDir(dirName: string; fileType: string = EMPTY_STRING; fullPath: boolean = true): string;
function getFileNamesListInDir(dirName: string; fileType: string = EMPTY_STRING; fullPath: boolean = true): TStringList;

procedure saveToFile(source: string; fileName: string);

function getCombinedPath(path1: string; path2: string): string;

function getCurrentDayOfWeekAsString: string;
function getDayOfWeekAsString(date: TDateTime): string;
function getCurrentDateTimeAsString: string;
function getDateTimeAsString(date: TDateTime): string;
function getCurrentDateAsString: string;
function getDateAsString(date: TDateTime): string; //TODO REVIEW NAME?
function getCurrentTimeStamp: string;
function getCurrentDateTimeAsStringWithFormatting(formatting: string = DATE_FORMAT): string;
function getDateTimeAsStringWithFormatting(value: TDateTime; formatting: string = DATE_FORMAT): string;
function getCurrentDateTime: TDateTime;

function getParsedXMLstring(mainString: string): string; //todo add to myString
function getDoubleQuotedString(mainString: string): string;
function getSingleQuotedString(mainString: string): string;
function getMainStringWithSubStringInserted(mainString: string; insertedString: string; index: integer): string;
function getStringWithoutLineBreaks(mainString: string; substituteString: string = SPACE_STRING): string;

function getCSVFieldFromStringAsDate(mainString: string; index: integer; delimiter: Char = SEMICOLON_DELIMITER): TDatetime; overload;
function getCSVFieldFromStringAsDate(mainString: string; index: integer; formatSettings: TFormatSettings; delimiter: Char = SEMICOLON_DELIMITER): TDatetime; overload;
function getCSVFieldFromStringAsDouble(mainString: string; index: integer; delimiter: Char = SEMICOLON_DELIMITER): Double; overload;
function getCSVFieldFromStringAsDouble(mainString: string; index: integer; formatSettings: TFormatSettings; delimiter: Char = SEMICOLON_DELIMITER): Double; overload;
function getCSVFieldFromStringAsInteger(mainString: string; index: integer; delimiter: Char = SEMICOLON_DELIMITER): integer;
function getCSVFieldFromString(mainString: string; index: integer; delimiter: Char = SEMICOLON_DELIMITER): string;

function getNumberOfLinesInStrFixedWordWrap(source: string): integer;
function stringToStrFixedWordWrap(source: string; fixedLen: Integer): string;
function stringToStringListWithFixedLen(source: string; fixedLen: Integer): TStringList;
function stringToStringListWithDelimiter(value: string; delimiter: Char): TStringList;
function stringToTStringList(source: string): TStringList;

function arrayOfStringToTStringList(arrayOfStrings: array of string): TStringList;

procedure splitStrings(source: string; delimiter: string; var destFirstString: string; var destSecondString: string); overload;
procedure splitStrings(source: string; delimiterPosition: integer; var destFirstString: string; var destSecondString: string); overload;
function getMergedStrings(firstString: string; secondString: string; delimiter: string = EMPTY_STRING): string;

function checkIfEmailIsValid(email: string): boolean;

function checkIfMainStringContainsSubStringNoCaseSensitive(mainString: string; subString: string): boolean;
function checkIfMainStringContainsSubString(mainString: string; subString: string; caseSensitiveSearch: boolean = true): boolean;

function getDoubleAsString(value: Double; decimalSeparator: char = DECIMAL_SEPARATOR_IT): string;
function getFloatToStrDecimalSeparator: char;

procedure tryToExecuteProcedure(myProcedure: TAnonymousMethod; raiseExceptionEnabled: boolean = false); overload;
procedure tryToExecuteProcedure(myProcedure: TCallBack; raiseExceptionEnabled: boolean = false); overload;
procedure tryToExecuteProcedure(myProcedure: TProcedure; raiseExceptionEnabled: boolean = false); overload;
procedure executeProcedure(myProcedure: TAnonymousMethod); overload;
procedure executeProcedure(myProcedure: TCallBack); overload;
function setResourceHInstance(aresource: Longword): longword;
function executeAndWaitExe(fileName: string; params: string = ''; exceptionIfReturnCodeIsNot0: boolean = false): LongInt;
function getLastSysErrorMessage: string;
function getIPFromHostName(hostName: string): string;

implementation

uses
  //KLib.Validate, KLib.Indy,
  {Vcl.}ExtCtrls,  IdGlobal, IdHash, IdHashMessageDigest, DelticsStrUtils, PathFunc, //IdSSLOpenSSL, IdFTPCommon, IdTCPClient,
  {System.Zip, System.IOUtils,} StrUtils, windows, Winsock,{System.Character,} {System.RegularExpressions,} {System.}Variants;

procedure TCredentials.clear;
const
  EMPTY: TCredentials = ();
begin
  Self := EMPTY;
end;


procedure raiseLastSysErrorMessage;
var
  sysErrMsg: string;
begin
  sysErrMsg := getLastSysErrorMessage;
  raise Exception.Create(sysErrMsg);
end;

function getLastSysErrorMessage: string;
var
  sysErrMsg: string;
  _errorCode: cardinal;
begin
  _errorCode := GetLastError;
  sysErrMsg := SysErrorMessage(_errorCode);

  Result := sysErrMsg;
end;


function executeAndWaitExe(fileName: string; params: string = ''; exceptionIfReturnCodeIsNot0: boolean = false): LongInt;
var
  returnCode: Longint;

  _commad: String;
  _startupInfo: TStartupInfo;
  _processInfo: TProcessInformation;
begin
  returnCode := -1;

  _commad := getDoubleQuotedString(fileName) + ' ' + trim(params);

  FillChar(_startupInfo, sizeOf(_startupInfo), 0);
  with _startupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    wShowWindow := {Winapi.}Windows.SW_HIDE;
  end;
  if not CreateProcess(nil, pchar(_commad), nil, nil, false,
    //   CREATE_NO_WINDOW,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, //TODO check if is ok
    nil, nil, _startupInfo, _processInfo) then
  begin
    raiseLastSysErrorMessage;
  end;

  //TODO CHECK
  //waitForMultiple(_processInfo.hProcess);
  //  waitFor(_processInfo.hProcess);

  if not GetExitCodeProcess(_processInfo.hProcess, dword(returnCode)) then //assign return code
  begin
    raiseLastSysErrorMessage;
  end;

  CloseHandle(_processInfo.hProcess);
  CloseHandle(_processInfo.hThread);

  if (exceptionIfReturnCodeIsNot0) and (returnCode <> 0) then
  begin
    raise Exception.Create(fileName + ' exit code: ' + IntToStr(returnCode));
  end;

  Result := returnCode;
end;

function getIPFromHostName(hostName: string): string;
const
  ERR_WINSOCK_MSG = 'Winsock initialization error.';
  ERR_NO_IP_FOUND_WITH_HOSTBAME_MSG = 'No IP found with hostname: ';
var
  ip: string;

  _varTWSAData: TWSAData;
  _varPHostEnt: PHostEnt;
  _varTInAddr: TInAddr;
begin
  if WSAStartup($101, _varTWSAData) <> 0 then
  begin
    raise Exception.Create(ERR_WINSOCK_MSG);
  end
  else
  begin
    try
      _varPHostEnt := gethostbyname(PAnsiChar(AnsiString(hostName)));
      _varTInAddr := PInAddr(_varPHostEnt^.h_Addr_List^)^;
      ip := String(inet_ntoa(_varTInAddr));
    except
      on E: Exception do
      begin
        WSACleanup;
        raise Exception.Create(ERR_NO_IP_FOUND_WITH_HOSTBAME_MSG + hostName);
      end;
    end;
  end;
  WSACleanup;

  Result := ip;
end;

procedure validateThatDirExists(dirName: string; errMsg: string = 'Directory doesn''t exists.');
var
  _errMsg: string;
begin
  if not DirectoryExists(dirName) then
  begin
    _errMsg := getDoubleQuotedString(dirName) + ' : ' + errMsg;
    raise Exception.Create(_errMsg);
  end;
end;


procedure deleteFilesInDir(pathDir: string; const filesToKeep: array of string);
var
  _fileNamesList: TStringList;
  _fileName: string;
  _nameOfFile: string;
  _keepFile: boolean;
begin
  validateThatDirExists(pathDir);
  _fileNamesList := getFileNamesListInDir(pathDir);
  try
    for _fileName in _fileNamesList do
    begin
      _nameOfFile := ExtractFileName(_fileName);
      _keepFile := MatchText(_nameOfFile, filesToKeep);
      if not _keepFile then
      begin
        deleteFileIfExists(_fileName);
      end;
    end;
  finally
    FreeAndNil(_fileNamesList);
  end;
end;

procedure deleteFilesInDirWithStartingFileName(dirName: string; startingFileName: string; fileType: string = EMPTY_STRING);
const
  IGNORE_CASE = true;
var
  _files: TStringList;
  _file: string;
  _fileName: string;
begin
  _files := getFileNamesListInDir(dirName, fileType);
  for _file in _files do
  begin
    _fileName := ExtractFileName(_file);
   { if _fileName.StartsWith(startingFileName, IGNORE_CASE) then
    begin
      deleteFileIfExists(_file);
    end; }
  end;
  FreeAndNil(_files);
end;

function checkIfFileExistsAndEmpty(fileName: string): boolean;
var
  _file: file of Byte;
  _size: integer;
  _result: boolean;
begin
  _result := false;
  if fileexists(fileName) then
  begin
    AssignFile(_file, fileName);
    Reset(_file);
    _size := FileSize(_file);
    _result := _size = 0;
    CloseFile(_file);
  end;

  Result := _result;
end;

procedure deleteFileIfExists(fileName: string);
const
  ERR_MSG = 'Error deleting file.';
begin
  if FileExists(fileName) then
  begin
    if not DeleteFile(pchar(fileName)) then
    begin
      raise Exception.Create(ERR_MSG);
    end;
  end;
end;

function getTextFromFile(fileName: string): string;
var
  text: string;
  _stringList: TStringList;
begin
  _stringList := TStringList.Create;
  try
    _stringList.LoadFromFile(fileName);
    text := _stringList.Text;
  finally
    _stringList.Free;
  end;
  Result := text;
end;

function checkIfThereIsSpaceAvailableOnDrive(drive: char; requiredSpaceInBytes: int64): boolean;
var
  _freeSpaceDrive: int64;
  _result: boolean;
begin
  _freeSpaceDrive := getFreeSpaceOnDrive(drive);
  _result := _freeSpaceDrive > requiredSpaceInBytes;
  Result := _result;
end;

function getFreeSpaceOnDrive(drive: char): int64;
const
  ERR_MSG_INVALID_DRIVE = 'The drive is invalid.';
  ERR_MSG_DRIVE_READ_ONLY = 'The drive is read-only';
var
  _indexOfDrive: integer;
  freeSpaceOnDrive: int64;
begin
  _indexOfDrive := getIndexOfDrive(drive);

  freeSpaceOnDrive := DiskFree(_indexOfDrive);
  case freeSpaceOnDrive of
    - 1:
      raise Exception.Create(ERR_MSG_INVALID_DRIVE);
    0:
      raise Exception.Create(ERR_MSG_DRIVE_READ_ONLY);
  end;
  Result := freeSpaceOnDrive;
end;

function getIndexOfDrive(drive: char): integer;
const
  ASCII_FIRST_ALPHABET_CHARACTER = 65;
  ASCII_LAST_ALPHABET_CHARACTER = 90;

  ERR_MSG = 'Invalid drive character.';
var
  _drive: string;
  _asciiIndex: integer;
begin
  _drive := uppercase(drive);
  _asciiIndex := integer(_drive[1]);
  if not((_asciiIndex >= ASCII_FIRST_ALPHABET_CHARACTER) and (_asciiIndex <= ASCII_LAST_ALPHABET_CHARACTER)) then
  begin
    raise Exception.Create(ERR_MSG);
  end;
  Result := (_asciiIndex - ASCII_FIRST_ALPHABET_CHARACTER) + 1;
end;

function getDriveExe: char;
var
  _dirExe: string;
begin
  _dirExe := getDriveExe;
  Result := _dirExe[1];
end;

function getDirSize(path: string): int64;
var
  _searchRec: TSearchRec;
  totalSize: int64;
  _subDirSize: int64;
begin
  totalSize := 0;
  path := getValidFullPath(path);
  path := IncludeTrailingPathDelimiter(path);
  if FindFirst(path + '*', faAnyFile, _searchRec) = 0 then
  begin
    repeat
      if (_searchRec.attr and faDirectory) > 0 then
      begin
        if (_searchRec.name <> '.') and (_searchRec.name <> '..') then
        begin
          _subDirSize := getDirSize(path + _searchRec.name);
          inc(totalSize, _subDirSize);
        end;
      end
      else
      begin
        inc(totalSize, _searchRec.size);
      end;
    until FindNext(_searchRec) <> 0;
    {System.}SysUtils.FindClose(_searchRec);
  end;
  Result := totalSize;
end;

function getCombinedPathWithCurrentDir(pathToCombine: string): string;
var
  _result: string;
  _currentDir: string;
begin
  _currentDir := getDirExe;
  _result := getCombinedPath(_currentDir, pathToCombine);
  Result := _result;
end;

function getDirExe: string;
begin
  result := ExtractFileDir(ParamStr(0));
end;

procedure createDirIfNotExists(dirName: string);
const
  ERR_MSG = 'Error creating dir.';
begin
  if not DirectoryExists(dirName) then
  begin
    if not CreateDir(dirName) then
    begin
      raise Exception.Create(ERR_MSG);
    end;
  end;
end;

function checkIfIsLinuxSubDir(subDir: string; mainDir: string): boolean;
var
  _subDir: string;
  _mainDir: string;
  _isSubDir: Boolean;
begin
  _subDir := getPathInLinuxStyle(subDir);
  _mainDir := getPathInLinuxStyle(mainDir);
  _isSubDir := checkIfIsSubDir(_subDir, _mainDir, LINUX_PATH_DELIMITER);
  result := _isSubDir
end;

function getPathInLinuxStyle(path: string): string;
var
  _path: string;
begin
  _path := stringReplace(path, '\', '/', [rfReplaceAll, rfIgnoreCase]);
  result := _path;
end;

function checkIfIsSubDir(subDir: string; mainDir: string; trailingPathDelimiter: char = SPACE_STRING): boolean;
var
  isSubDir: Boolean;
  _subDir: string;
  _mainDir: string;
  _trailingPathDelimiter: char;
begin
  _subDir := LowerCase(subDir);
  _mainDir := LowerCase(mainDir);
  _trailingPathDelimiter := trailingPathDelimiter;
  if _trailingPathDelimiter = SPACE_STRING then
  begin
    _trailingPathDelimiter := PathDelim;
  end;

  if not(AnsiRightStr(_mainDir, 1) = _trailingPathDelimiter) then
  begin
    _mainDir := _mainDir + _trailingPathDelimiter;
  end;

  isSubDir := AnsiStartsStr(_mainDir, _subDir);

  Result := isSubDir;
end;

function getValidFullPath(fileName: string): string;
var
  path: string;
begin
  path := fileName;
  path := ExpandFileName(path);
  path := ExcludeTrailingPathDelimiter(path);

  Result := path;
end;

procedure validateThatFileExists(fileName: string; errMsg: string = 'File doesn''t exists.');
var
  _errMsg: string;
begin
  if not FileExists(fileName) then
  begin
    _errMsg := getDoubleQuotedString(fileName) + ' : ' + errMsg;
    raise Exception.Create(_errMsg);
  end;
end;


function getMD5ChecksumFile(fileName: string): string;
var
  MD5: string;
  _IdHashMessageDigest: TIdHashMessageDigest5;
  _fileStream: TFileStream;
begin
  validateThatFileExists(fileName);

  _IdHashMessageDigest := TIdHashMessageDigest5.Create;
  _fileStream := TFileStream.Create(fileName, fmOpenRead or fmShareDenyWrite);
  try
    //MD5 := _IdHashMessageDigest.HashStreamAsHex(_fileStream);
    //MD5 := _IdHashMessageDigest.AsHex(_fileStream);
    MD5 := TIdHash128.AsHex(_IdHashMessageDigest.HashValue(_fileStream));
  finally
    begin
      _fileStream.Free;
      _IdHashMessageDigest.Free;
    end;
  end;

  Result := MD5;
end;

function checkMD5File(fileName: string; MD5: string): boolean;
var
  _MD5ChecksumFile: string;
begin
  _MD5ChecksumFile := getMD5ChecksumFile(fileName);

  Result := (UpperCase(_MD5ChecksumFile) = UpperCase(MD5));
end;

procedure unzipResource(nameResource: string; destinationDir: string);
const
  DELETE_ZIP_AFTER_UNZIP = TRUE;
var
  _tempZipFileName: string;
begin
  _tempZipFileName := getRandString + '.' + ZIP_TYPE;
  _tempZipFileName := getCombinedPath(destinationDir, _tempZipFileName);
  getResourceAsZIPFile(nameResource, _tempZipFileName);
  unzip(_tempZipFileName, destinationDir, DELETE_ZIP_AFTER_UNZIP);
end;

{
function getPNGResource(nameResource: string): TPngImage;
var
  resourceAsPNG: TPngImage;
  _resource: TResource;
  resourceStream: TResourceStream;
begin
  with _resource do
  begin
    name := nameResource;
    _type := PNG_TYPE;
  end;
  resourceStream := getResourceAsStream(_resource);
  resourceAsPNG := TPngImage.Create;
  resourceAsPNG.LoadFromStream(resourceStream);
  resourceStream.Free;

  Result := resourceAsPNG;
end;  }

procedure _getResourceAsFile_(nameResource: string; typeResource: string; destinationFileName: string); forward;

procedure getResourceAsEXEFile(nameResource: string; destinationFileName: string);
begin
  _getResourceAsFile_(nameResource, EXE_TYPE, destinationFileName);
end;

procedure getResourceAsZIPFile(nameResource: string; destinationFileName: string);
begin
  _getResourceAsFile_(nameResource, ZIP_TYPE, destinationFileName);
end;

procedure _getResourceAsFile_(nameResource: string; typeResource: string; destinationFileName: string);
var
  _resource: TResource;
  _destinationFileName: string;
begin
  with _resource do
  begin
    name := nameResource;
    _type := typeResource;
  end;
  _destinationFileName := destinationFileName;
  //strendswith
  //if not LowerCase(_destinationFileName).EndsWith('.' + LowerCase(typeResource)) then
  //StrEndsWith( const aString : String; const aEnd : String) : Boolean');
  if not strendswith(LowerCase(_destinationFileName),'.' + LowerCase(typeResource)) then
  begin
    _destinationFileName := _destinationFileName + '.' + LowerCase(typeResource);
  end;
  getResourceAsFile(_resource, _destinationFileName);
end;

procedure getResourceAsFile(resource: TResource; destinationFileName: string);
var
  resourceStream: TResourceStream;
begin
  resourceStream := getResourceAsStream(resource);
  resourceStream.SaveToFile(destinationFileName);
  resourceStream.Free;
end;

function getResourceAsString(resource: TResource): string;
var
  resourceAsString: string;
  resourceStream: TResourceStream;
  _stringList: TStringList;
begin
  resourceAsString := '';
  resourceStream := getResourceAsStream(resource);
  _stringList := TStringList.Create;
  _stringList.LoadFromStream(resourceStream);
  resourceAsString := _stringList.Text;
  resourceStream.Free;

  Result := resourceAsString;
end;

function setResourceHInstance(aresource: longword): longword;
begin
   hinstance:=  aresource;
   result:= hinstance;
end;

function getResourceAsStream(resource: TResource): TResourceStream;
var
  resourceStream: TResourceStream;
  _errMsg: string;
begin
  with resource do
  begin
    if (FindResource(hInstance, PChar(name), PChar(_type)) <> 0) then
    begin
      resourceStream := TResourceStream.Create(HInstance, PChar(name), PChar(_type));
      resourceStream.Position := 0;
    end
    else
    begin
      _errMsg := 'Not found a resource with name : ' + name + ' and type : ' + _type;
      raise Exception.Create(_errMsg);
    end;
  end;

  Result := resourceStream;
end;

procedure unzip(zipFileName: string; destinationDir: string; deleteZipAfterUnzip: boolean = false);
const
  ERR_MSG = 'Invalid zip file.';
begin
 { if TZipFile.isvalid(zipFileName) then
  begin
    TZipFile.extractZipfile(zipFileName, destinationDir);
    if (deleteZipAfterUnzip) then
    begin
      deleteFileIfExists(zipFileName);
    end;
  end
  else
  begin
    raise Exception.Create(ERR_MSG);
  end; }
end;  //}

function checkRequiredFTPProperties(FTPCredentials: TFTPCredentials): boolean;
var
  _result: boolean;
begin
  with FTPCredentials do
  begin
    _result := (server <> EMPTY_STRING) and (credentials.username <> EMPTY_STRING) and (credentials.password <> EMPTY_STRING)
      and (port >= 0);
  end;

  Result := _result;
end;

function getValidItalianTelephoneNumber(number: string): string;
var
  telephoneNumber: string;
  _number: string;
  i: integer;
begin
  telephoneNumber := '';
  _number := trim(number);

  if _number = '' then
  begin
    telephoneNumber := '';
  end
  else
  begin
  {  if _number.StartsWith('0039') then
    begin
      _number := StringReplace(_number, '0039', '+39', []);
    end;

    if not _number.StartsWith('+') then
    begin
      _number := '+39' + _number;
    end;

    if not _number.StartsWith('+39') then
    begin
      _number := StringReplace(_number, '+', '+39', []);
    end;

    telephoneNumber := '+';
    for i := 2 to length(_number) do
    begin
      if _number[i].IsNumber then
      begin
        telephoneNumber := telephoneNumber + _number[i];
      end;
    end; }
  end;

  Result := telephoneNumber;
end;

procedure validateThatStringIsNotEmpty(value: string; errMsg: string = 'Value is empty.');
begin
  if value = '' then
  begin
    raise Exception.Create(errMsg);
  end;
end;

function getValidTelephoneNumber(number: string): string;
const
  ERR_MSG = 'Telephone number is empty.';
var
  telephoneNumber: string;
  _number: string;
  i: integer;
begin
  telephoneNumber := '';
  _number := trim(number);

  validateThatStringIsNotEmpty(_number, ERR_MSG);

  if _number[1] = '+' then
  begin
    telephoneNumber := '+';
  end;
  for i := 2 to length(_number) do
  begin
    //if _number[i].IsNumber then
    begin
      telephoneNumber := telephoneNumber + _number[i];
    end;
  end;

  Result := telephoneNumber;
end;

function getRandString(size: integer = 5): string;
const
  ALPHABET: array [1 .. 62] of char = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
var
  randString: string;
  _randCharacter: char;
  _randIndexOfAlphabet: integer;
  _lengthAlphabet: integer;
  i: integer;
begin
  randString := '';
  _lengthAlphabet := length(ALPHABET);
  for i := 1 to size do
  begin
    _randIndexOfAlphabet := random(_lengthAlphabet) + 1;
    _randCharacter := ALPHABET[_randIndexOfAlphabet];
    randString := randString + _randCharacter;
  end;

  Result := randString;
end;

function getFirstFileNameInDir(dirName: string; fileType: string = EMPTY_STRING; fullPath: boolean = true): string;
const
  ERR_MSG = 'No files found.';
var
  fileName: string;
  _fileNamesList: TStringList;
begin
  _fileNamesList := getFileNamesListInDir(dirName, fileType, fullPath);
  if _fileNamesList.Count > 0 then
  begin
    fileName := _fileNamesList[0];
  end
  else
  begin
    fileName := EMPTY_STRING;
  end;
  FreeAndNil(_fileNamesList);
  if fileName = EMPTY_STRING then
  begin
    raise Exception.Create(ERR_MSG);
  end;

  Result := fileName;
end;

function getFileNamesListInDir(dirName: string; fileType: string = EMPTY_STRING; fullPath: boolean = true): TStringList;
var
  fileNamesList: TStringList;
  _searchRec: TSearchRec;
  _mask: string;
  _fileExists: boolean;
  _fileName: string;
begin
  fileNamesList := TStringList.Create;
  _mask := getCombinedPath(dirName, '*');
  if fileType <> EMPTY_STRING then
  begin
    _mask := _mask + '.' + fileType;
  end;
  _fileExists := FindFirst(_mask, faAnyFile - faDirectory, _searchRec) = 0;
  while _fileExists do
  begin
    _fileName := _searchRec.Name;
    if fullPath then
    begin
      _fileName := getCombinedPath(dirName, _fileName);
    end;
    fileNamesList.Add(_fileName);
    _fileExists := FindNext(_searchRec) = 0;
  end;

  Result := fileNamesList;
end;

procedure saveToFile(source: string; fileName: string);
var
  _stringList: TStringList;
begin
  try
    _stringList := stringToTStringList(source);
    _stringList.SaveToFile(fileName);
  finally
    FreeAndNil(_stringList);
  end;
end;

(*
function PathCombine(const Dir, Filename: String): String;
{ Combines a directory and filename into a path.
  If Dir is empty, it just returns Filename.
  If Filename is empty, it returns an empty string (ignoring Dir).
  If Filename begins with a drive letter or slash, it returns Filename
  (ignoring Dir).
  If Dir specifies only a drive letter and colon ('c:'), it returns
  Dir + Filename.
  Otherwise, it returns the equivalent of AddBackslash(Dir) + Filename. }
var
  I: Integer;
begin
  if (Dir = '') or (Filename = '') or PathIsRooted(Filename) then
    Result := Filename
  else begin
    I := PathCharLength(Dir, 1) + 1;
    if ((I = Length(Dir)) and (Dir[I] = ':')) or
       PathCharIsSlash(PathLastChar(Dir)^) then
      Result := Dir + Filename
    else
      Result := Dir + '\' + Filename;
  end;
end;    *)


function getCombinedPath(path1: string; path2: string): string;
begin
  //Result := TPath.Combine(path1, path2);
  Result := PathCombine(path1, path2);    //PathFunc
end;

function getCurrentDayOfWeekAsString: string;
var
  _nameDay: string;
begin
  _nameDay := getDayOfWeekAsString(Now);
  result := _nameDay;
end;

function getDayOfWeekAsString(date: TDateTime): string;
//const
  //DAYS_OF_WEEK: TArray<string> = [
 { DAYS_OF_WEEK: array of string = (
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
    ); }
var
  _indexDayOfWeek: integer;
  _nameDay: string;
begin
  _indexDayOfWeek := DayOfWeek(date) - 1;
  //_nameDay := DAYS_OF_WEEK[_indexDayOfWeek];

  Result := _nameDay;
end;

function getCurrentDateTimeAsString: string;
begin
  Result := getDateTimeAsString(Now);
end;

function getDateTimeAsString(date: TDateTime): string;
var
  dateTimeAsString: string;
  _date: string;
  _time: string;
begin
  _date := getDateAsString(date);
  _time := TimeToStr(date);
  _time := stringReplace(_time, ':', EMPTY_STRING, [rfReplaceAll, rfIgnoreCase]);
  dateTimeAsString := _date + '_' + _time;

  Result := dateTimeAsString;
end;

function getCurrentDateAsString: string;
begin
  Result := getDateAsString(Now);
end;

function getDateAsString(date: TDateTime): string;
var
  dateAsString: string;
begin
  dateAsString := DateToStr(date);
  dateAsString := stringReplace(dateAsString, '/', '_', [rfReplaceAll, rfIgnoreCase]);

  Result := dateAsString;
end;

function getCurrentTimeStamp: string;
begin
  Result := getCurrentDateTimeAsStringWithFormatting(TIMESTAMP_FORMAT);
end;

function getCurrentDateTimeAsStringWithFormatting(formatting: string = DATE_FORMAT): string;
begin
  Result := getDateTimeAsStringWithFormatting(Now, formatting);
end;

function getDateTimeAsStringWithFormatting(value: TDateTime; formatting: string = DATE_FORMAT): string;
var
  dateTimeAsStringWithFormatting: string;
begin
  dateTimeAsStringWithFormatting := FormatDateTime(formatting, value);

  Result := dateTimeAsStringWithFormatting;
end;

function getCurrentDateTime: TDateTime;
begin
  Result := Now;
end;

function getParsedXMLstring(mainString: string): string; //todo add to myString
var
  parsedXMLstring: string;
begin
  parsedXMLstring := mainString;
  parsedXMLstring := stringreplace(parsedXMLstring, '&', '&amp;', [rfreplaceall]);
  parsedXMLstring := stringreplace(parsedXMLstring, '"', '&quot;', [rfreplaceall]);
  parsedXMLstring := stringreplace(parsedXMLstring, '''', '&#39;', [rfreplaceall]);
  parsedXMLstring := stringreplace(parsedXMLstring, '<', '&lt;', [rfreplaceall]);
  parsedXMLstring := stringreplace(parsedXMLstring, '>', '&gt;', [rfreplaceall]);

  Result := parsedXMLstring;
end;

function getDoubleQuotedString(mainString: string): string;
begin
  Result := AnsiQuotedStr(mainString, '"');
end;

function getSingleQuotedString(mainString: string): string;
begin
  Result := AnsiQuotedStr(mainString, '''');
end;

function getMainStringWithSubStringInserted(mainString: string; insertedString: string; index: integer): string;
const
  ERR_MSG = 'Index out of range.';
var
  _result: string;
  _lenght: integer;
  _firstStringPart: string;
  _lastStringPart: string;
begin
  _lenght := Length(mainString);
  if (index > _lenght) or (index < 0) then
  begin
    raise Exception.Create(ERR_MSG);
  end;
  _firstStringPart := Copy(mainString, 0, index);
  _lastStringPart := Copy(mainString, index + 1, MaxInt);
  _result := _firstStringPart + insertedString + _lastStringPart;

  Result := _result;
end;

function getStringWithoutLineBreaks(mainString: string; substituteString: string = SPACE_STRING): string;
var
  stringWithoutLineBreaks: string;
begin
  stringWithoutLineBreaks := stringReplace(mainString, #13#10, substituteString, [rfReplaceAll]);
  stringWithoutLineBreaks := stringReplace(stringWithoutLineBreaks, #10, substituteString, [rfReplaceAll]);

  Result := stringWithoutLineBreaks;
end;

var
  formatSettings : TFormatSettings;

function getCSVFieldFromStringAsDate(mainString: string; index: integer; delimiter: Char = SEMICOLON_DELIMITER): TDatetime;
var
  _result: TDatetime;
  //var
  //formatSettings : TFormatSettings;
begin
  _result := getCSVFieldFromStringAsDate(mainString, index, FormatSettings, delimiter);
  Result := _result;
end;

function getCSVFieldFromStringAsDate(mainString: string; index: integer; formatSettings: TFormatSettings;
  delimiter: Char = SEMICOLON_DELIMITER): TDatetime;
var
  _fieldAsString: string;
  _result: TDatetime;
begin
  _fieldAsString := getCSVFieldFromString(mainString, index, delimiter);
  _result := StrToDate(_fieldAsString, formatSettings);

  Result := _result;
end;

function getCSVFieldFromStringAsDouble(mainString: string; index: integer; delimiter: Char = SEMICOLON_DELIMITER): Double;
var
  _result: Double;
begin
  _result := getCSVFieldFromStringAsDouble(mainString, index, FormatSettings, delimiter);

  Result := _result;
end;

function getCSVFieldFromStringAsDouble(mainString: string; index: integer; formatSettings: TFormatSettings;
  delimiter: Char = SEMICOLON_DELIMITER): Double;
var
  _fieldAsString: string;
  _result: Double;
begin
  _fieldAsString := getCSVFieldFromString(mainString, index, delimiter);
  _result := StrToFloat(_fieldAsString, formatSettings);

  Result := _result;
end;

function getCSVFieldFromStringAsInteger(mainString: string; index: integer; delimiter: Char = SEMICOLON_DELIMITER): integer;
var
  _fieldAsString: string;
  _result: integer;
begin
  _fieldAsString := getCSVFieldFromString(mainString, index, delimiter);
  _result := StrToInt(_fieldAsString);

  Result := _result;
end;

function getCSVFieldFromString(mainString: string; index: integer; delimiter: Char = SEMICOLON_DELIMITER): string;
const
  ERR_MSG = 'Field index out of range.';
var
  _stringList: TStringList;
  _result: string;
begin
  _stringList := stringToStringListWithDelimiter(mainString, delimiter);
  try
    try
      _result := _stringList[index];
    except
      on E: Exception do
      begin
        raise Exception.Create(ERR_MSG);
      end;
    end;
  finally
    FreeAndNil(_stringList);
  end;

  Result := _result;
end;

function getNumberOfLinesInStrFixedWordWrap(source: string): integer;
var
  _stringList: TStringList;
  _result: integer;
begin
  _stringList := stringToTStringList(source);
  _result := _stringList.Count;
  FreeAndNil(_stringList);

  Result := _result;
end;

function stringToStrFixedWordWrap(source: string; fixedLen: Integer): string;
var
  _stringList: TStringList;
  _text: string;
  _result: string;
begin
  _stringList := stringToStringListWithFixedLen(source, fixedLen);
  _text := _stringList.Text;
  FreeAndNil(_stringList);
  Delete(_text, length(_text), 1);
  _result := _text;

  Result := _result;
end;

function stringToStringListWithFixedLen(source: string; fixedLen: integer): TStringList;
var
  stringList: TStringList;
  i: Integer;
  _sourceLen: Integer;
begin
  stringList := TStringList.Create;
  stringList.LineBreak := #13;
  if fixedLen = 0 then
  begin
    fixedLen := Length(source) - 1;
  end;
  stringList.Capacity := (Length(source) div fixedLen) + 1;

  i := 1;
  _sourceLen := Length(source);

  while i <= _sourceLen do
  begin
    stringList.Add(Copy(source, i, fixedLen));
    Inc(i, fixedLen);
  end;

  result := stringList;
end;

function stringToStringListWithDelimiter(value: string; delimiter: Char): TStringList;
var
  _stringList: TStringList;
begin
  _stringList := TStringList.Create;
  _stringList.Clear;
  _stringList.Delimiter := delimiter;
  _stringList.StrictDelimiter := True;
  _stringList.DelimitedText := value;

  Result := _stringList;
end;

function stringToTStringList(source: string): TStringList;
var
  _stringList: TStringList;
begin
  _stringList := TStringList.Create;
  _stringList.Text := source;
  Result := _stringList;
end;

function arrayOfStringToTStringList(arrayOfStrings: array of string): TStringList;
var
  stringList: TStringList;
  _string: string;
begin
  stringList := TStringList.Create;
  for _string in arrayOfStrings do
  begin
    stringList.Add(_string);
  end;

  Result := stringList;
end;

procedure splitStrings(source: string; delimiter: string; var destFirstString: string; var destSecondString: string);
var
  _startIndexDelimiter: integer;
  _endIndexDelimiter: integer;
  _lengthDestFirstString: integer;
  _lengthDestSecondString: integer;
begin
  _startIndexDelimiter := AnsiPos(delimiter, source);
  if _startIndexDelimiter > 0 then
  begin
    _endIndexDelimiter := _startIndexDelimiter + Length(delimiter);
    _lengthDestFirstString := _startIndexDelimiter - 1;
    _lengthDestSecondString := Length(source) - _endIndexDelimiter + 1;
    destFirstString := Copy(source, 0, _lengthDestFirstString);
    destSecondString := Copy(source, _endIndexDelimiter, _lengthDestSecondString);
  end
  else
  begin
    destFirstString := source;
    destSecondString := '';
  end;
end;

procedure splitStrings(source: string; delimiterPosition: integer; var destFirstString: string; var destSecondString: string);
var
  _lenghtSource: integer;
  _lengthDestSecondString: integer;
begin
  _lenghtSource := Length(source);
  if _lenghtSource > delimiterPosition then
  begin
    _lengthDestSecondString := _lenghtSource - delimiterPosition;
    destFirstString := Copy(source, 0, delimiterPosition);
    destSecondString := Copy(source, delimiterPosition + 1, _lengthDestSecondString);
  end
  else
  begin
    destFirstString := source;
    destSecondString := '';
  end;
end;

function getMergedStrings(firstString: string; secondString: string; delimiter: string = EMPTY_STRING): string;
begin
  Result := firstString + delimiter + secondString;
end;

function checkIfEmailIsValid(email: string): boolean;
var
  _result: boolean;
begin
  //_result := TRegEx.IsMatch(email, REGEX_VALID_EMAIL);

  Result := _result;
end;

function checkIfMainStringContainsSubStringNoCaseSensitive(mainString: string; subString: string): boolean;
const
  NO_CASE_SENSITIVE = false;
begin
  Result := checkIfMainStringContainsSubString(mainString, subString, NO_CASE_SENSITIVE);
end;

function checkIfMainStringContainsSubString(mainString: string; subString: string; caseSensitiveSearch: boolean = true): boolean;
var
  _result: boolean;
begin
  if caseSensitiveSearch then
  begin
    _result := ContainsStr(mainString, subString);
  end
  else
  begin
    _result := ContainsText(mainString, subString);
  end;

  Result := _result;
end;

function getDoubleAsString(value: Double; decimalSeparator: char = DECIMAL_SEPARATOR_IT): string;
var
  _doubleAsString: string;
  _FloatToStrDecimalSeparator: char;
begin
  _doubleAsString := FloatToStr(value);
  _FloatToStrDecimalSeparator := getFloatToStrDecimalSeparator;
  _doubleAsString := StringReplace(_doubleAsString, _FloatToStrDecimalSeparator, decimalSeparator, [rfReplaceAll]);
  Result := _doubleAsString;
end;

function getFloatToStrDecimalSeparator: char;
const
  VALUE_WITH_DECIMAL_SEPARATOR = 0.1;
  DECIMAL_SEPARATOR_INDEX = 2;
var
  _doubleAsString: string;
begin
  _doubleAsString := FloatToStr(VALUE_WITH_DECIMAL_SEPARATOR);
  Result := _doubleAsString[DECIMAL_SEPARATOR_INDEX];
end;

procedure tryToExecuteProcedure(myProcedure: TProcedure; raiseExceptionEnabled: boolean = false);
begin
  try
    executeProcedure(myProcedure);
  except
    on E: Exception do
    begin
      if raiseExceptionEnabled then
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  end;
end;

procedure tryToExecuteProcedure(myProcedure: TAnonymousMethod; raiseExceptionEnabled: boolean = false);
begin
  try
    executeProcedure(myProcedure);
  except
    on E: Exception do
    begin
      if raiseExceptionEnabled then
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  end;
end;

procedure tryToExecuteProcedure(myProcedure: TCallBack; raiseExceptionEnabled: boolean = false);
begin
  try
    executeProcedure(myProcedure);
  except
    on E: Exception do
    begin
      if raiseExceptionEnabled then
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  end;
end;

procedure executeProcedure(myProcedure: TAnonymousMethod);
begin
  myProcedure;
end;

procedure executeProcedure(myProcedure: TCallBack);
begin
  myProcedure('');
end;

end.
