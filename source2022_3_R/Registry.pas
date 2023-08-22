{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit Registry;

{$R-,T-,H+,X+}

interface

uses {$IFDEF LINUX} WinUtils, {$ENDIF} Windows, Classes, SysUtils, IniFiles;

type
  ERegistryException = class(Exception);

  TRegKeyInfo = record
    NumSubKeys: Integer;
    MaxSubKeyLen: Integer;
    NumValues: Integer;
    MaxValueLen: Integer;
    MaxDataLen: Integer;
    FileTime: TFileTime;
  end;

  TRegDataType = (rdUnknown, rdString, rdExpandString, rdInteger, rdBinary);

  TRegDataInfo = record
    RegData: TRegDataType;
    DataSize: Integer;
  end;

  TRegistry = class(TObject)
  private
    FCurrentKey: HKEY;
    FRootKey: HKEY;
    FLazyWrite: Boolean;
    FCurrentPath: string;
    FCloseRootKey: Boolean;
    FAccess: LongWord;
    procedure SetRootKey(Value: HKEY);
  protected
    procedure ChangeKey(Value: HKey; const Path: string);
    function GetBaseKey(Relative: Boolean): HKey;
    function GetData(const Name: string; Buffer: Pointer;
      BufSize: Integer; var RegData: TRegDataType): Integer;
    function GetKey(const Key: string): HKEY;
    procedure PutData(const Name: string; Buffer: Pointer; BufSize: Integer; RegData: TRegDataType);
    procedure SetCurrentKey(Value: HKEY);
  public
    constructor Create; overload;
    constructor Create(AAccess: LongWord); overload;
    destructor Destroy; override;
    procedure CloseKey;
    function CreateKey(const Key: string): Boolean;
    function DeleteKey(const Key: string): Boolean;
    function DeleteValue(const Name: string): Boolean;
    function GetDataAsString(const ValueName: string; PrefixType: Boolean = false): string;
    function GetDataInfo(const ValueName: string; var Value: TRegDataInfo): Boolean;
    function GetDataSize(const ValueName: string): Integer;
    function GetDataType(const ValueName: string): TRegDataType;
    function GetKeyInfo(var Value: TRegKeyInfo): Boolean;
    procedure GetKeyNames(Strings: TStrings);
    procedure GetValueNames(Strings: TStrings);
    function HasSubKeys: Boolean;
    function KeyExists(const Key: string): Boolean;
    function LoadKey(const Key, FileName: string): Boolean;
    procedure MoveKey(const OldName, NewName: string; Delete: Boolean);
    function OpenKey(const Key: string; CanCreate: Boolean): Boolean;
    function OpenKeyReadOnly(const Key: String): Boolean;
    function ReadCurrency(const Name: string): Currency;
    function ReadBinaryData(const Name: string; var Buffer; BufSize: Integer): Integer;
    function ReadBool(const Name: string): Boolean;
    function ReadDate(const Name: string): TDateTime;
    function ReadDateTime(const Name: string): TDateTime;
    function ReadFloat(const Name: string): Double;
    function ReadInteger(const Name: string): Integer;
    function ReadString(const Name: string): string;
    function ReadTime(const Name: string): TDateTime;
    function RegistryConnect(const UNCName: string): Boolean;
    procedure RenameValue(const OldName, NewName: string);
    function ReplaceKey(const Key, FileName, BackUpFileName: string): Boolean;
    function RestoreKey(const Key, FileName: string): Boolean;
    function SaveKey(const Key, FileName: string): Boolean;
    function UnLoadKey(const Key: string): Boolean;
    function ValueExists(const Name: string): Boolean;
    procedure WriteCurrency(const Name: string; Value: Currency);
    procedure WriteBinaryData(const Name: string; var Buffer; BufSize: Integer);
    procedure WriteBool(const Name: string; Value: Boolean);
    procedure WriteDate(const Name: string; Value: TDateTime);
    procedure WriteDateTime(const Name: string; Value: TDateTime);
    procedure WriteFloat(const Name: string; Value: Double);
    procedure WriteInteger(const Name: string; Value: Integer);
    procedure WriteString(const Name, Value: string);
    procedure WriteExpandString(const Name, Value: string);
    procedure WriteTime(const Name: string; Value: TDateTime);
    property CurrentKey: HKEY read FCurrentKey;
    property CurrentPath: string read FCurrentPath;
    property LazyWrite: Boolean read FLazyWrite write FLazyWrite;
    property RootKey: HKEY read FRootKey write SetRootKey;
    property Access: LongWord read FAccess write FAccess;
  end;

  TRegIniFile = class(TRegistry)
  private
    FFileName: string;
  public
    constructor Create(const FileName: string); overload;
    constructor Create(const FileName: string; AAccess: LongWord); overload;
    function ReadString(const Section, Ident, Default: string): string;
    function ReadInteger(const Section, Ident: string;
      Default: Longint): Longint;
    procedure WriteInteger(const Section, Ident: string; Value: Longint);
    procedure WriteString(const Section, Ident, Value: string);
    function ReadBool(const Section, Ident: string; Default: Boolean): Boolean;
    procedure WriteBool(const Section, Ident: string; Value: Boolean);
    procedure ReadSection(const Section: string; Strings: TStrings);
    procedure ReadSections(Strings: TStrings);
    procedure ReadSectionValues(const Section: string; Strings: TStrings);
    procedure EraseSection(const Section: string);
    procedure DeleteKey(const Section, Ident: string);
    property FileName: string read FFileName;
  end;

  TRegistryIniFile = class(TCustomIniFile)
  private
    FRegIniFile: TRegIniFile;
  public
    constructor Create(const FileName: string); overload;
    constructor Create(const FileName: string; AAccess: LongWord); overload;
    destructor Destroy; override;
    function ReadDate(const Section, Name: string; Default: TDateTime): TDateTime; override;
    function ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime; override;
    function ReadInteger(const Section, Ident: string; Default: Longint): Longint; override;
    function ReadFloat(const Section, Name: string; Default: Double): Double; override;
    function ReadString(const Section, Ident, Default: string): string; override;
    function ReadTime(const Section, Name: string; Default: TDateTime): TDateTime; override;
    function ReadBinaryStream(const Section, Name: string; Value: TStream): Integer; override;
//    procedure ReadKeys(const Section: string; Sections: TStrings);
    procedure WriteDate(const Section, Name: string; Value: TDateTime); override;
    procedure WriteDateTime(const Section, Name: string; Value: TDateTime); override;
    procedure WriteFloat(const Section, Name: string; Value: Double); override;
    procedure WriteInteger(const Section, Ident: string; Value: Longint); override;
    procedure WriteString(const Section, Ident, Value: string); override;
    procedure WriteTime(const Section, Name: string; Value: TDateTime); override;
    procedure WriteBinaryStream(const Section, Name: string; Value: TStream); override;
    procedure ReadSection(const Section: string; Strings: TStrings); override;
    procedure ReadSections(Strings: TStrings); overload; override;
    procedure ReadSections(const Section: string; Strings: TStrings); overload; override;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); override;
    procedure EraseSection(const Section: string); override;
    procedure DeleteKey(const Section, Ident: string); override;
    procedure UpdateFile; override;

    property RegIniFile: TRegIniFile read FRegIniFile;
  end;

implementation

uses RTLConsts;

procedure ReadError(const Name: string);
begin
  raise ERegistryException.CreateResFmt(@SInvalidRegType, [Name]);
end;

function IsRelative(const Value: string): Boolean;
begin
  Result := not ((Value <> '') and (Value[1] = '\'));
end;

function RegDataToDataType(Value: TRegDataType): Integer;
begin
  case Value of
    rdString: Result := REG_SZ;
    rdExpandString: Result := REG_EXPAND_SZ;
    rdInteger: Result := REG_DWORD;
    rdBinary: Result := REG_BINARY;
  else
    Result := REG_NONE;
  end;
end;

function DataTypeToRegData(Value: Integer): TRegDataType;
begin
  if Value = REG_SZ then Result := rdString
  else if Value = REG_EXPAND_SZ then Result := rdExpandString
  else if Value = REG_DWORD then Result := rdInteger
  else if Value = REG_BINARY then Result := rdBinary
  else Result := rdUnknown;
end;

function BinaryToHexString(const BinaryData: array of Byte; const PrefixStr: string): string;
var
  DataSize, I, Offset: Integer;
  HexData: string;
  PResult: PChar;
begin
  OffSet := 0;
  if PrefixStr <> '' then
  begin
    Result := PrefixStr;
    Inc(Offset, Length(PrefixStr));
  end;
  DataSize := Length(BinaryData);

  SetLength(Result, Offset + (DataSize*3) - 1); // less one for last ','
  PResult := PChar(Result); // Use a char pointer to reduce string overhead
  for I := 0 to DataSize - 1 do
  begin
    HexData := IntToHex(BinaryData[I], 2);
    PResult[Offset] := HexData[1];
    PResult[Offset+1] := HexData[2];
    if I < DataSize - 1 then
      PResult[Offset+2] := ',';
    Inc(Offset, 3);
  end;
end;

{ TRegistry }

constructor TRegistry.Create;
begin
  RootKey := HKEY_CURRENT_USER;
  FAccess := KEY_ALL_ACCESS;
  LazyWrite := True;
end;

constructor TRegistry.Create(AAccess: LongWord);
begin
  Create;
  FAccess := AAccess;
end;

destructor TRegistry.Destroy;
begin
  CloseKey;
  inherited;
end;

procedure TRegistry.CloseKey;
begin
  if CurrentKey <> 0 then
  begin
    if not LazyWrite then
      RegFlushKey(CurrentKey);
    RegCloseKey(CurrentKey);
    FCurrentKey := 0;
    FCurrentPath := '';
  end;
end;

procedure TRegistry.SetRootKey(Value: HKEY);
begin
  if RootKey <> Value then
  begin
    if FCloseRootKey then
    begin
      RegCloseKey(RootKey);
      FCloseRootKey := False;
    end;
    FRootKey := Value;
    CloseKey;
  end;
end;

procedure TRegistry.ChangeKey(Value: HKey; const Path: string);
begin
  CloseKey;
  FCurrentKey := Value;
  FCurrentPath := Path;
end;

function TRegistry.GetBaseKey(Relative: Boolean): HKey;
begin
  if (CurrentKey = 0) or not Relative then
    Result := RootKey else
    Result := CurrentKey;
end;

procedure TRegistry.SetCurrentKey(Value: HKEY);
begin
  FCurrentKey := Value;
end;

function TRegistry.CreateKey(const Key: string): Boolean;
var
  TempKey: HKey;
  S: string;
  Disposition: Integer;
  Relative: Boolean;
begin
  TempKey := 0;
  S := Key;
  Relative := IsRelative(S);
  if not Relative then Delete(S, 1, 1);
  Result := RegCreateKeyEx(GetBaseKey(Relative), PChar(S), 0, nil,
    REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, TempKey, @Disposition) = ERROR_SUCCESS;
  if Result then RegCloseKey(TempKey)
  else raise ERegistryException.CreateResFmt(@SRegCreateFailed, [Key]);
end;

function TRegistry.OpenKey(const Key: string; Cancreate: boolean): Boolean;
var
  TempKey: HKey;
  S: string;
  Disposition: Integer;
  Relative: Boolean;
begin
  S := Key;
  Relative := IsRelative(S);

  if not Relative then Delete(S, 1, 1);
  TempKey := 0;
  if not CanCreate or (S = '') then
  begin
    Result := RegOpenKeyEx(GetBaseKey(Relative), PChar(S), 0,
      FAccess, TempKey) = ERROR_SUCCESS;
  end else
    Result := RegCreateKeyEx(GetBaseKey(Relative), PChar(S), 0, nil,
      REG_OPTION_NON_VOLATILE, FAccess, nil, TempKey, @Disposition) = ERROR_SUCCESS;
  if Result then
  begin
    if (CurrentKey <> 0) and Relative then S := CurrentPath + '\' + S;
    ChangeKey(TempKey, S);
  end;
end;

function TRegistry.OpenKeyReadOnly(const Key: string): Boolean;
var
  TempKey: HKey;
  S: string;
  Relative: Boolean;
  WOWFlags: Cardinal;
begin
  S := Key;
  Relative := IsRelative(S);

  if not Relative then Delete(S, 1, 1);
  TempKey := 0;
  // Preserve KEY_WOW64_XXX flags for later use
  WOWFlags := FAccess and KEY_WOW64_RES;
  Result := RegOpenKeyEx(GetBaseKey(Relative), PChar(S), 0,
      KEY_READ or WOWFlags, TempKey) = ERROR_SUCCESS;
  if Result then
  begin
    FAccess := KEY_READ or WOWFlags;
    if (CurrentKey <> 0) and Relative then S := CurrentPath + '\' + S;
    ChangeKey(TempKey, S);
  end
  else
  begin
    Result := RegOpenKeyEx(GetBaseKey(Relative), PChar(S), 0,
        STANDARD_RIGHTS_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS or WOWFlags,
        TempKey) = ERROR_SUCCESS;
    if Result then
    begin
      FAccess := STANDARD_RIGHTS_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS or WOWFlags;
      if (CurrentKey <> 0) and Relative then S := CurrentPath + '\' + S;
      ChangeKey(TempKey, S);
    end
    else
    begin
      Result := RegOpenKeyEx(GetBaseKey(Relative), PChar(S), 0,
          KEY_QUERY_VALUE or WOWFlags, TempKey) = ERROR_SUCCESS;
      if Result then
      begin
        FAccess := KEY_QUERY_VALUE or WOWFlags;
        if (CurrentKey <> 0) and Relative then S := CurrentPath + '\' + S;
        ChangeKey(TempKey, S);
      end
    end;
  end;
end;

function TRegistry.DeleteKey(const Key: string): Boolean;
var
  Len: DWORD;
  I: Integer;
  Relative: Boolean;
  S, KeyName: string;
  OldKey, DeleteKey: HKEY;
  Info: TRegKeyInfo;
begin
  S := Key;
  Relative := IsRelative(S);
  if not Relative then Delete(S, 1, 1);
  OldKey := CurrentKey;
  DeleteKey := GetKey(Key);
  if DeleteKey <> 0 then
  try
    SetCurrentKey(DeleteKey);
    if GetKeyInfo(Info) then
    begin
      SetString(KeyName, nil, Info.MaxSubKeyLen + 1);
      for I := Info.NumSubKeys - 1 downto 0 do
      begin
        Len := Info.MaxSubKeyLen + 1;
        if RegEnumKeyEx(DeleteKey, DWORD(I), PChar(KeyName), Len, nil, nil, nil,
          nil) = ERROR_SUCCESS then
          Self.DeleteKey(PChar(KeyName));
      end;
    end;
  finally
    SetCurrentKey(OldKey);
    RegCloseKey(DeleteKey);
  end;
  Result := RegDeleteKey(GetBaseKey(Relative), PChar(S)) = ERROR_SUCCESS;
end;

function TRegistry.DeleteValue(const Name: string): Boolean;
begin
  Result := RegDeleteValue(CurrentKey, PChar(Name)) = ERROR_SUCCESS;
end;

function TRegistry.GetKeyInfo(var Value: TRegKeyInfo): Boolean;
begin
  FillChar(Value, SizeOf(TRegKeyInfo), 0);
  Result := RegQueryInfoKey(CurrentKey, nil, nil, nil, @Value.NumSubKeys,
    @Value.MaxSubKeyLen, nil, @Value.NumValues, @Value.MaxValueLen,
    @Value.MaxDataLen, nil, @Value.FileTime) = ERROR_SUCCESS;
  if SysLocale.FarEast and (Win32Platform = VER_PLATFORM_WIN32_NT) then
    with Value do
    begin
      Inc(MaxSubKeyLen, MaxSubKeyLen);
      Inc(MaxValueLen, MaxValueLen);
    end;
end;

procedure TRegistry.GetKeyNames(Strings: TStrings);
var
  Len: DWORD;
  I: Integer;
  Info: TRegKeyInfo;
  S: string;
begin
  Strings.Clear;
  if GetKeyInfo(Info) then
  begin
    SetString(S, nil, Info.MaxSubKeyLen + 1);
    for I := 0 to Info.NumSubKeys - 1 do
    begin
      Len := Info.MaxSubKeyLen + 1;
      RegEnumKeyEx(CurrentKey, I, PChar(S), Len, nil, nil, nil, nil);
      Strings.Add(PChar(S));
    end;
  end;
end;

procedure TRegistry.GetValueNames(Strings: TStrings);
var
  Len: DWORD;
  I: Integer;
  Info: TRegKeyInfo;
  S: string;
begin
  Strings.Clear;
  if GetKeyInfo(Info) then
  begin
    SetString(S, nil, Info.MaxValueLen + 1);
    for I := 0 to Info.NumValues - 1 do
    begin
      Len := Info.MaxValueLen + 1;
      RegEnumValue(CurrentKey, I, PChar(S), Len, nil, nil, nil, nil);
      Strings.Add(PChar(S));
    end;
  end;
end;

function TRegistry.GetDataInfo(const ValueName: string; var Value: TRegDataInfo): Boolean;
var
  DataType: Integer;
begin
  FillChar(Value, SizeOf(TRegDataInfo), 0);
  Result := RegQueryValueEx(CurrentKey, PChar(ValueName), nil, @DataType, nil,
    @Value.DataSize) = ERROR_SUCCESS;
  Value.RegData := DataTypeToRegData(DataType);
end;

function TRegistry.GetDataSize(const ValueName: string): Integer;
var
  Info: TRegDataInfo;
begin
  if GetDataInfo(ValueName, Info) then
    Result := Info.DataSize else
    Result := -1;
end;

function TRegistry.GetDataType(const ValueName: string): TRegDataType;
var
  Info: TRegDataInfo;
begin
  if GetDataInfo(ValueName, Info) then
    Result := Info.RegData else
    Result := rdUnknown;
end;

procedure TRegistry.WriteString(const Name, Value: string);
begin
  PutData(Name, PChar(Value), (Length(Value)+1) * SizeOf(Char), rdString);
end;

procedure TRegistry.WriteExpandString(const Name, Value: string);
begin
  PutData(Name, PChar(Value), (Length(Value)+1) * SizeOf(Char), rdExpandString);
end;

function TRegistry.ReadString(const Name: string): string;
var
  Len: Integer;
  RegData: TRegDataType;
begin
  Len := GetDataSize(Name);
  if Len > 0 then
  begin
    SetString(Result, nil, Len);
    GetData(Name, PChar(Result), Len, RegData);
    if (RegData = rdString) or (RegData = rdExpandString) then
      SetLength(Result, StrLen(PChar(Result)))
    else ReadError(Name);
  end
  else Result := '';
end;

// Returns rdInteger and rdBinary as strings
function TRegistry.GetDataAsString(const ValueName: string;
  PrefixType: Boolean = false): string;
const
  SDWORD_PREFIX = 'dword:';
  SHEX_PREFIX = 'hex:';
var
  Info: TRegDataInfo;
  BinaryBuffer: array of Byte;
begin
  Result := '';
  if GetDataInfo(ValueName, Info) and (Info.DataSize > 0) then
  begin
    case Info.RegData of
      rdString, rdExpandString:
        begin
          SetString(Result, nil, Info.DataSize);
          GetData(ValueName, PChar(Result), Info.DataSize, Info.RegData);
          SetLength(Result, StrLen(PChar(Result)));
        end;
      rdInteger:
        begin
          if PrefixType then
            Result := SDWORD_PREFIX+IntToHex(ReadInteger(ValueName), 8)
          else
            Result := IntToStr(ReadInteger(ValueName));
        end;
      rdBinary, rdUnknown:
        begin
          SetLength(BinaryBuffer, Info.DataSize);
          ReadBinaryData(ValueName, Pointer(BinaryBuffer)^, Info.DataSize);
          if PrefixType then
            Result := BinaryToHexString(BinaryBuffer, SHEX_PREFIX)
          else
            Result := BinaryToHexString(BinaryBuffer, '');
        end;
    end;
  end;
end;

procedure TRegistry.WriteInteger(const Name: string; Value: Integer);
begin
  PutData(Name, @Value, SizeOf(Integer), rdInteger);
end;

function TRegistry.ReadInteger(const Name: string): Integer;
var
  RegData: TRegDataType;
begin
  GetData(Name, @Result, SizeOf(Integer), RegData);
  if RegData <> rdInteger then ReadError(Name);
end;

procedure TRegistry.WriteBool(const Name: string; Value: Boolean);
begin
  WriteInteger(Name, Ord(Value));
end;

function TRegistry.ReadBool(const Name: string): Boolean;
begin
  Result := ReadInteger(Name) <> 0;
end;

procedure TRegistry.WriteFloat(const Name: string; Value: Double);
begin
  PutData(Name, @Value, SizeOf(Double), rdBinary);
end;

function TRegistry.ReadFloat(const Name: string): Double;
var
  Len: Integer;
  RegData: TRegDataType;
begin
  Len := GetData(Name, @Result, SizeOf(Double), RegData);
  if (RegData <> rdBinary) or (Len <> SizeOf(Double)) then
    ReadError(Name);
end;

procedure TRegistry.WriteCurrency(const Name: string; Value: Currency);
begin
  PutData(Name, @Value, SizeOf(Currency), rdBinary);
end;

function TRegistry.ReadCurrency(const Name: string): Currency;
var
  Len: Integer;
  RegData: TRegDataType;
begin
  Len := GetData(Name, @Result, SizeOf(Currency), RegData);
  if (RegData <> rdBinary) or (Len <> SizeOf(Currency)) then
    ReadError(Name);
end;

procedure TRegistry.WriteDateTime(const Name: string; Value: TDateTime);
begin
  PutData(Name, @Value, SizeOf(TDateTime), rdBinary);
end;

function TRegistry.ReadDateTime(const Name: string): TDateTime;
var
  Len: Integer;
  RegData: TRegDataType;
begin
  Len := GetData(Name, @Result, SizeOf(TDateTime), RegData);
  if (RegData <> rdBinary) or (Len <> SizeOf(TDateTime)) then
    ReadError(Name);
end;

procedure TRegistry.WriteDate(const Name: string; Value: TDateTime);
begin
  WriteDateTime(Name, Value);
end;

function TRegistry.ReadDate(const Name: string): TDateTime;
begin
  Result := ReadDateTime(Name);
end;

procedure TRegistry.WriteTime(const Name: string; Value: TDateTime);
begin
  WriteDateTime(Name, Value);
end;

function TRegistry.ReadTime(const Name: string): TDateTime;
begin
  Result := ReadDateTime(Name);
end;

procedure TRegistry.WriteBinaryData(const Name: string; var Buffer; BufSize: Integer);
begin
  PutData(Name, @Buffer, BufSize, rdBinary);
end;

function TRegistry.ReadBinaryData(const Name: string; var Buffer; BufSize: Integer): Integer;
var
  RegData: TRegDataType;
  Info: TRegDataInfo;
begin
  if GetDataInfo(Name, Info) then
  begin
    Result := Info.DataSize;
    RegData := Info.RegData;
    if ((RegData = rdBinary) or (RegData = rdUnknown)) and (Result <= BufSize) then
      GetData(Name, @Buffer, Result, RegData)
    else ReadError(Name);
  end else
    Result := 0;
end;

procedure TRegistry.PutData(const Name: string; Buffer: Pointer;
  BufSize: Integer; RegData: TRegDataType);
var
  DataType: Integer;
begin
  DataType := RegDataToDataType(RegData);
  if RegSetValueEx(CurrentKey, PChar(Name), 0, DataType, Buffer,
    BufSize) <> ERROR_SUCCESS then
    raise ERegistryException.CreateResFmt(@SRegSetDataFailed, [Name]);
end;

function TRegistry.GetData(const Name: string; Buffer: Pointer;
  BufSize: Integer; var RegData: TRegDataType): Integer;
var
  DataType: Integer;
begin
  DataType := REG_NONE;
  if RegQueryValueEx(CurrentKey, PChar(Name), nil, @DataType, PByte(Buffer),
    @BufSize) <> ERROR_SUCCESS then
    raise ERegistryException.CreateResFmt(@SRegGetDataFailed, [Name]);
  Result := BufSize;
  RegData := DataTypeToRegData(DataType);
end;

function TRegistry.HasSubKeys: Boolean;
var
  Info: TRegKeyInfo;
begin
  Result := GetKeyInfo(Info) and (Info.NumSubKeys > 0);
end;

function TRegistry.ValueExists(const Name: string): Boolean;
var
  Info: TRegDataInfo;
begin
  Result := GetDataInfo(Name, Info);
end;

function TRegistry.GetKey(const Key: string): HKEY;
var
  S: string;
  Relative: Boolean;
begin
  S := Key;
  Relative := IsRelative(S);
  if not Relative then Delete(S, 1, 1);
  Result := 0;
  RegOpenKeyEx(GetBaseKey(Relative), PChar(S), 0, FAccess, Result);
end;

function TRegistry.RegistryConnect(const UNCName: string): Boolean;
var
  TempKey: HKEY;
begin
  Result := RegConnectRegistry(PChar(UNCname), RootKey, TempKey) = ERROR_SUCCESS;
  if Result then
  begin
    RootKey := TempKey;
    FCloseRootKey := True;
  end;
end;

function TRegistry.LoadKey(const Key, FileName: string): Boolean;
var
  S: string;
begin
  S := Key;
  if not IsRelative(S) then Delete(S, 1, 1);
  Result := RegLoadKey(RootKey, PChar(S), PChar(FileName)) = ERROR_SUCCESS;
end;

function TRegistry.UnLoadKey(const Key: string): Boolean;
var
  S: string;
begin
  S := Key;
  if not IsRelative(S) then Delete(S, 1, 1);
  Result := RegUnLoadKey(RootKey, PChar(S)) = ERROR_SUCCESS;
end;

function TRegistry.RestoreKey(const Key, FileName: string): Boolean;
var
  RestoreKey: HKEY;
begin
  Result := False;
  RestoreKey := GetKey(Key);
  if RestoreKey <> 0 then
  try
    Result := RegRestoreKey(RestoreKey, PChar(FileName), 0) = ERROR_SUCCESS;
  finally
    RegCloseKey(RestoreKey);
  end;
end;

function TRegistry.ReplaceKey(const Key, FileName, BackUpFileName: string): Boolean;
var
  S: string;
  Relative: Boolean;
begin
  S := Key;
  Relative := IsRelative(S);
  if not Relative then Delete(S, 1, 1);
  Result := RegReplaceKey(GetBaseKey(Relative), PChar(S),
    PChar(FileName), PChar(BackUpFileName)) = ERROR_SUCCESS;
end;

function TRegistry.SaveKey(const Key, FileName: string): Boolean;
var
  SaveKey: HKEY;
begin
  Result := False;
  SaveKey := GetKey(Key);
  if SaveKey <> 0 then
  try
    Result := RegSaveKey(SaveKey, PChar(FileName), nil) = ERROR_SUCCESS;
  finally
    RegCloseKey(SaveKey);
  end;
end;

function TRegistry.KeyExists(const Key: string): Boolean;
var
  TempKey: HKEY;
  OldAccess: Longword;
begin
  OldAccess := FAccess;
  try
    FAccess := STANDARD_RIGHTS_READ or KEY_QUERY_VALUE or
      KEY_ENUMERATE_SUB_KEYS or (OldAccess and KEY_WOW64_RES);
    TempKey := GetKey(Key);
    if TempKey <> 0 then RegCloseKey(TempKey);
    Result := TempKey <> 0;
  finally
    FAccess := OldAccess;
  end;
end;

procedure TRegistry.RenameValue(const OldName, NewName: string);
var
  Len: Integer;
  RegData: TRegDataType;
  Buffer: PChar;
begin
  if {ValueExists(OldName) and} not ValueExists(NewName) then
  begin
    Len := GetDataSize(OldName); // returns 0 if OldName doesn't exist
    if Len > 0 then
    begin
      Buffer := AllocMem(Len);
      try
        Len := GetData(OldName, Buffer, Len, RegData);
        DeleteValue(OldName);
        PutData(NewName, Buffer, Len, RegData);
      finally
        FreeMem(Buffer);
      end;
    end;
  end;
end;

procedure TRegistry.MoveKey(const OldName, NewName: string; Delete: Boolean);
var
  SrcKey, DestKey: HKEY;

  procedure MoveValue(SrcKey, DestKey: HKEY; const Name: string);
  var
    Len: Integer;
    OldKey, PrevKey: HKEY;
    Buffer: PChar;
    RegData: TRegDataType;
  begin
    OldKey := CurrentKey;
    SetCurrentKey(SrcKey);
    try
      Len := GetDataSize(Name);
      if Len > 0 then
      begin
        Buffer := AllocMem(Len);
        try
          Len := GetData(Name, Buffer, Len, RegData);
          PrevKey := CurrentKey;
          SetCurrentKey(DestKey);
          try
            PutData(Name, Buffer, Len, RegData);
          finally
            SetCurrentKey(PrevKey);
          end;
        finally
          FreeMem(Buffer);
        end;
      end;
    finally
      SetCurrentKey(OldKey);
    end;
  end;

  procedure CopyValues(SrcKey, DestKey: HKEY);
  var
    Len: DWORD;
    I: Integer;
    KeyInfo: TRegKeyInfo;
    S: string;
    OldKey: HKEY;
  begin
    OldKey := CurrentKey;
    SetCurrentKey(SrcKey);
    try
      if GetKeyInfo(KeyInfo) then
      begin
        MoveValue(SrcKey, DestKey, '');
        SetString(S, nil, KeyInfo.MaxValueLen + 1);
        for I := 0 to KeyInfo.NumValues - 1 do
        begin
          Len := KeyInfo.MaxValueLen + 1;
          if RegEnumValue(SrcKey, I, PChar(S), Len, nil, nil, nil, nil) = ERROR_SUCCESS then
            MoveValue(SrcKey, DestKey, PChar(S));
        end;
      end;
    finally
      SetCurrentKey(OldKey);
    end;
  end;

  procedure CopyKeys(SrcKey, DestKey: HKEY);
  var
    Len: DWORD;
    I: Integer;
    Info: TRegKeyInfo;
    S: string;
    OldKey, PrevKey, NewSrc, NewDest: HKEY;
  begin
    OldKey := CurrentKey;
    SetCurrentKey(SrcKey);
    try
      if GetKeyInfo(Info) then
      begin
        SetString(S, nil, Info.MaxSubKeyLen + 1);
        for I := 0 to Info.NumSubKeys - 1 do
        begin
          Len := Info.MaxSubKeyLen + 1;
          if RegEnumKeyEx(SrcKey, I, PChar(S), Len, nil, nil, nil, nil) = ERROR_SUCCESS then
          begin
            NewSrc := GetKey(PChar(S));
            if NewSrc <> 0 then
            try
              PrevKey := CurrentKey;
              SetCurrentKey(DestKey);
              try
                CreateKey(PChar(S));
                NewDest := GetKey(PChar(S));
                try
                  CopyValues(NewSrc, NewDest);
                  CopyKeys(NewSrc, NewDest);
                finally
                  RegCloseKey(NewDest);
                end;
              finally
                SetCurrentKey(PrevKey);
              end;
            finally
              RegCloseKey(NewSrc);
            end;
          end;
        end;
      end;
    finally
      SetCurrentKey(OldKey);
    end;
  end;

begin
  if KeyExists(OldName) and not KeyExists(NewName) then
  begin
    SrcKey := GetKey(OldName);
    if SrcKey <> 0 then
    try
      CreateKey(NewName);
      DestKey := GetKey(NewName);
      if DestKey <> 0 then
      try
        CopyValues(SrcKey, DestKey);
        CopyKeys(SrcKey, DestKey);
        if Delete then DeleteKey(OldName);
      finally
        RegCloseKey(DestKey);
      end;
    finally
      RegCloseKey(SrcKey);
    end;
  end;
end;

{ TRegIniFile }

constructor TRegIniFile.Create(const FileName: string);
begin
  Create(FileName, KEY_ALL_ACCESS);
end;

constructor TRegIniFile.Create(const FileName: string; AAccess: LongWord);
begin
  inherited Create(AAccess);
  FFilename := FileName;
  OpenKey(FileName, True);
end;

function TRegIniFile.ReadString(const Section, Ident, Default: string): string;
var
  Key, OldKey: HKEY;
begin
  Key := GetKey(Section);
  if Key <> 0 then
  try
    OldKey := CurrentKey;
    SetCurrentKey(Key);
    try
      if (Default = '') or ValueExists(Ident) then
        Result := inherited ReadString(Ident) else
        Result := Default;
    finally
      SetCurrentKey(OldKey);
    end;
  finally
    RegCloseKey(Key);
  end
  else Result := Default;
end;

procedure TRegIniFile.WriteString(const Section, Ident, Value: String);
var
  Key, OldKey: HKEY;
begin
  CreateKey(Section);
  Key := GetKey(Section);
  if Key <> 0 then
  try
    OldKey := CurrentKey;
    SetCurrentKey(Key);
    try
      inherited WriteString(Ident, Value);
    finally
      SetCurrentKey(OldKey);
    end;
  finally
    RegCloseKey(Key);
  end;
end;

function TRegIniFile.ReadInteger(const Section, Ident: string; Default: LongInt): LongInt;
var
  Key, OldKey: HKEY;
  S: string;
begin
  Key := GetKey(Section);
  if Key <> 0 then
  try
    OldKey := CurrentKey;
    SetCurrentKey(Key);
    try
      S := inherited ReadString(Ident);
      Result := StrToIntDef(S, Default);
    finally
      SetCurrentKey(OldKey);
    end;
  finally
    RegCloseKey(Key);
  end
  else Result := Default;
end;

procedure TRegIniFile.WriteInteger(const Section, Ident: string; Value: LongInt);
var
  Key, OldKey: HKEY;
begin
  CreateKey(Section);
  Key := GetKey(Section);
  if Key <> 0 then
  try
    OldKey := CurrentKey;
    SetCurrentKey(Key);
    try
      inherited WriteString(Ident, IntToStr(Value));
    finally
      SetCurrentKey(OldKey);
    end;
  finally
    RegCloseKey(Key);
  end;
end;

function TRegIniFile.ReadBool(const Section, Ident: string; Default: Boolean): Boolean;
begin
  Result := ReadInteger(Section, Ident, Ord(Default)) <> 0;
end;

procedure TRegIniFile.WriteBool(const Section, Ident: string; Value: Boolean);
const
  Values: array[Boolean] of string = ('0', '1');
var
  Key, OldKey: HKEY;
begin
  CreateKey(Section);
  Key := GetKey(Section);
  if Key <> 0 then
  try
    OldKey := CurrentKey;
    SetCurrentKey(Key);
    try
      inherited WriteString(Ident, Values[Value]);
    finally
      SetCurrentKey(OldKey);
    end;
  finally
    RegCloseKey(Key);
  end;
end;

procedure TRegIniFile.ReadSection(const Section: string; Strings: TStrings);
var
  Key, OldKey: HKEY;
begin
  Key := GetKey(Section);
  if Key <> 0 then
  try
    OldKey := CurrentKey;
    SetCurrentKey(Key);
    try
      inherited GetValueNames(Strings);
    finally
      SetCurrentKey(OldKey);
    end;
  finally
    RegCloseKey(Key);
  end;
end;

procedure TRegIniFile.ReadSections(Strings: TStrings);
begin
  GetKeyNames(Strings);
end;

procedure TRegIniFile.ReadSectionValues(const Section: string; Strings: TStrings);
var
  Key, OldKey: HKEY;
  ValueName: string;
  ValueNames: TStringList;
  I: Integer;
begin
  Key := GetKey(Section);
  if Key <> 0 then
  try
    OldKey := CurrentKey;
    SetCurrentKey(Key);
  try
      ValueNames := TStringList.Create;
    Strings.BeginUpdate;
    try
        inherited GetValueNames(ValueNames);
        for I := 0 to ValueNames.Count - 1 do
        begin
          ValueName := ValueNames[I];
          Strings.Values[ValueName] := GetDataAsString(ValueName, True);
        end;
    finally
      Strings.EndUpdate;
        ValueNames.Free;
    end;
  finally
      SetCurrentKey(OldKey);
  end;
  finally
    RegCloseKey(Key);
  end

end;

procedure TRegIniFile.EraseSection(const Section: string);
begin
  inherited DeleteKey(Section);
end;

procedure TRegIniFile.DeleteKey(const Section, Ident: String);
var
  Key, OldKey: HKEY;
begin
  Key := GetKey(Section);
  if Key <> 0 then
  try
    OldKey := CurrentKey;
    SetCurrentKey(Key);
    try
      inherited DeleteValue(Ident);
    finally
      SetCurrentKey(OldKey);
    end;
  finally
    RegCloseKey(Key);
  end;
end;

{ TRegistryIniFile }

constructor TRegistryIniFile.Create(const FileName: string);
begin
  Create(FileName, KEY_ALL_ACCESS);
end;

constructor TRegistryIniFile.Create(const FileName: string; AAccess: LongWord);
begin
  inherited Create(FileName);
  FRegIniFile := TRegIniFile.Create(FileName, AAccess);
end;

destructor TRegistryIniFile.Destroy;
begin
  FRegIniFile.Free;
  inherited Destroy;
end;

function TRegistryIniFile.ReadString(const Section, Ident, Default: string): string;
begin
  Result := FRegIniFile.ReadString(Section, Ident, Default);
end;

function TRegistryIniFile.ReadDate(const Section, Name: string; Default: TDateTime): TDateTime;
var
  Key, OldKey: HKEY;
begin
  with FRegIniFile do
  begin
    Key := GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        if ValueExists(Name) then
          Result := ReadDate(Name)
        else Result := Default;
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end else Result := Default;
  end;
end;

function TRegistryIniFile.ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
  Key, OldKey: HKEY;
begin
  with FRegIniFile do
  begin
    Key := GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        if ValueExists(Name) then
          Result := ReadDateTime(Name)
        else Result := Default;
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end else Result := Default;
  end;
end;

function TRegistryIniFile.ReadFloat(const Section, Name: string; Default: Double): Double;
var
  Key, OldKey: HKEY;
begin
  with FRegIniFile do
  begin
    Key := GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        if ValueExists(Name) then
          Result := ReadFloat(Name)
        else Result := Default;
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end else Result := Default;
  end;
end;

function TRegistryIniFile.ReadInteger(const Section, Ident: string; Default: LongInt): LongInt;
var
  Key, OldKey: HKEY;
  Info: TRegDataInfo;
begin
  with TRegistry(FRegIniFile) do
  begin
    Key := GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        Result := Default;
        if GetDataInfo(Ident, Info) then
          if Info.RegData = rdString then
            Result := StrToIntDef(ReadString(Ident), Default)
          else Result := ReadInteger(Ident);
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end
    else Result := Default;
  end;
end;

function TRegistryIniFile.ReadTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
  Key, OldKey: HKEY;
begin
  with FRegIniFile do
  begin
    Key := GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        if ValueExists(Name) then
          Result := ReadTime(Name)
        else Result := Default;
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end else Result := Default;
  end;
end;

function TRegistryIniFile.ReadBinaryStream(const Section, Name: string; Value: TStream): Integer;
var
  RegData: TRegDataType;
  Info: TRegDataInfo;
  Key, OldKey: HKEY;
  Stream: TMemoryStream;
begin
  Result := 0;
  with RegIniFile do
  begin
    Key := TRegistry(FRegIniFile).GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      TRegistry(FRegIniFile).SetCurrentKey(Key);
      try
        if GetDataInfo(Name, Info) then
        begin
          Result := Info.DataSize;
          RegData := Info.RegData;
          if Value is TMemoryStream then
            Stream := TMemoryStream(Value)
          else Stream := TMemoryStream.Create;
          try
            if (RegData = rdBinary) or (RegData = rdUnknown) then
            begin
              Stream.Size := Stream.Position + Info.DataSize;
              Result := ReadBinaryData(Name,
                Pointer(Integer(Stream.Memory) + Stream.Position)^, Stream.Size);
              if Stream <> Value then Value.CopyFrom(Stream, Stream.Size - Stream.Position);
            end;
          finally
            if Stream <> Value then Stream.Free;
	      end;
        end;
      finally
        TRegistry(FRegIniFile).SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end;
  end;
end;

procedure TRegistryIniFile.WriteDate(const Section, Name: string; Value: TDateTime);
var
  Key, OldKey: HKEY;
begin
  with FRegIniFile do
  begin
    CreateKey(Section);
    Key := GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        WriteDate(Name, Value);
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end;
  end;
end;

procedure TRegistryIniFile.WriteDateTime(const Section, Name: string; Value: TDateTime);
var
  Key, OldKey: HKEY;
begin
  with FRegIniFile do
  begin
    CreateKey(Section);
    Key := GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        WriteDateTime(Name, Value);
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end;
  end;
end;

procedure TRegistryIniFile.WriteFloat(const Section, Name: string; Value: Double);
var
  Key, OldKey: HKEY;
begin
  with FRegIniFile do
  begin
    CreateKey(Section);
    Key := GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        WriteFloat(Name, Value);
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end;
  end;
end;

procedure TRegistryIniFile.WriteInteger(const Section, Ident: string; Value: LongInt);
var
  Key, OldKey: HKEY;
  Info: TRegDataInfo;
begin
  with TRegistry(FRegIniFile) do
  begin
    CreateKey(Section);
    Key := GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        if GetDataInfo(Ident, Info) and (Info.RegData = rdString) then
          WriteString(Ident, IntToStr(Value))
        else WriteInteger(Ident, Value);
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end;
  end;
end;

procedure TRegistryIniFile.WriteTime(const Section, Name: string; Value: TDateTime);
var
  Key, OldKey: HKEY;
begin
  with FRegIniFile do
  begin
    CreateKey(Section);
    Key := GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        WriteTime(Name, Value);
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end;
  end;
end;

procedure TRegistryIniFile.WriteBinaryStream(const Section, Name: string;
  Value: TStream);
var
  Key, OldKey: HKEY;
  Stream: TMemoryStream;
begin
  with RegIniFile do
  begin
    CreateKey(Section);
    Key := TRegistry(FRegIniFile).GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      if Value is TMemoryStream then
        Stream := TMemoryStream(Value)
      else Stream := TMemoryStream.Create;
      try
        if Stream <> Value then
        begin
          Stream.CopyFrom(Value, Value.Size - Value.Position);
          Stream.Position := 0;
        end;
        TRegistry(FRegIniFile).SetCurrentKey(Key);
        try
          WriteBinaryData(Name, Pointer(Integer(Stream.Memory) + Stream.Position)^,
            Stream.Size - Stream.Position);
        finally
          TRegistry(FRegIniFile).SetCurrentKey(OldKey);
        end;
      finally
        if Value <> Stream then Stream.Free;
      end;
    finally
      RegCloseKey(Key);
    end;
  end;
end;

procedure TRegistryIniFile.WriteString(const Section, Ident, Value: String);
begin
  FRegIniFile.WriteString(Section, Ident, Value);
end;

procedure TRegistryIniFile.ReadSection(const Section: string; Strings: TStrings);
begin
  FRegIniFile.ReadSection(Section, Strings);
end;

procedure TRegistryIniFile.ReadSections(Strings: TStrings);
begin
  FRegIniFile.ReadSections(Strings);
end;

procedure TRegistryIniFile.ReadSectionValues(const Section: string; Strings: TStrings);
begin
  FRegIniFile.ReadSectionValues(Section, Strings);
end;

procedure TRegistryIniFile.EraseSection(const Section: string);
begin
  FRegIniFile.EraseSection(Section);
end;

procedure TRegistryIniFile.DeleteKey(const Section, Ident: String);
begin
  FRegIniFile.DeleteKey(Section, Ident);
end;

procedure TRegistryIniFile.UpdateFile;
begin
  { Do nothing }
end;

procedure TRegistryIniFile.ReadSections(const Section: string; Strings: TStrings);
var
  Key, OldKey: HKEY;
begin
  with RegIniFile do
  begin
    Key := GetKey(Section);
    if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        GetKeyNames(Strings);
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end;
  end;
end;

end.



