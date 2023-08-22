{ *************************************************************************** }
{                                                                             }
{ Kylix and Delphi Cross-Platform Visual Component Library                    }
{                                                                             }
{ Copyright (c) 2000, 2001 Borland Software Corporation                       }
{                                                                             }
{ *************************************************************************** }


unit DBConnAdmin;

interface

//uses SysUtils, Classes, IniFiles
uses Windows, SysUtils, Variants, Classes, DBCommon, DBCommonTypes,
  DBXCommon, SqlTimSt, IniFiles
{$IF DEFINED(CLR)}
  , Contnrs
{$ELSE}
  , WideStrings
{$IFEND}
;

type
{$IF DEFINED(CLR)}
  TWideStringList = TStringList;
{$IFEND}

{ IConnectionAdmin }

  IConnectionAdmin = interface
    function GetDriverNames(List: TStrings): Integer;
    function GetDriverParams(const DriverName: string; Params: TWideStrings): Integer;
    procedure GetDriverLibNames(const DriverName: string;
      var LibraryName, VendorLibrary: string);
    function GetConnectionNames(List: TStrings;DriverName: string): Integer;
    function GetConnectionParams(const ConnectionName: string; Params: TWideStrings): Integer;
    procedure GetConnectionParamValues(const ParamName: string; Values: TWideStrings);
    procedure AddConnection(const ConnectionName, DriverName: string);
    procedure DeleteConnection(const ConnectionName: string);
    procedure ModifyConnection(const ConnectionName: string; Params: TWideStrings);
    procedure RenameConnection(const OldName, NewName: string);
    procedure ModifyDriverParams(const DriverName: string; Params: TWideStrings);
  end;

{ TConnectionAdmin }

  TConnectionAdmin = class(TInterfacedObject, IConnectionAdmin)
  private
    FDriverConfig: TIniFile;
    FConnectionConfig: TIniFile;
  protected
    { IConnectionAdmin }
    function GetDriverNames(List: TStrings): Integer;
    function GetDriverParams(const DriverName: string; Params: TWideStrings): Integer;
    procedure GetDriverLibNames(const DriverName: string;
      var LibraryName, VendorLibrary: string);
    function GetConnectionNames(List: TStrings; DriverName: string): Integer;
    function GetConnectionParams(const ConnectionName: string; Params: TWideStrings): Integer;
    procedure GetConnectionParamValues(const ParamName: string; Values: TWideStrings);
    procedure AddConnection(const ConnectionName, DriverName: string);
    procedure DeleteConnection(const ConnectionName: string);
    procedure ModifyConnection(const ConnectionName: string; Params: TWideStrings);
    procedure RenameConnection(const OldName, NewName: string);
    procedure ModifyDriverParams(const DriverName: string; Params: TWideStrings);
  public
    constructor Create;
    destructor Destroy; override;
    property ConnectionConfig: TIniFile read FConnectionConfig;
    property DriverConfig: TIniFile read FDriverConfig;
  end;


function GetConnectionAdmin: IConnectionAdmin;

implementation

uses SqlConst, SqlExpr, DB;

{ Global Functions }

function GetConnectionAdmin: IConnectionAdmin;
begin
  Result := IConnectionAdmin(TConnectionAdmin.Create);
end;

function FormatLine(const Key, Value: string): string;
begin
  Result := Format('%s=%s', [Key, Value]);
end;

function GetValue(const Line: string): string;
var
  ValPos: Integer;
begin
  ValPos := Pos('=', Line);
  if ValPos > 0 then
    Result := Copy(Line, ValPos+1, MAXINT) else
    Result := '';
end;

procedure WriteSectionValues(IniFile: TIniFile; const Section: string; Strings: TWideStrings);
var
  I: Integer;
begin
  with IniFile do
  begin
    EraseSection(Section);
    for I := 0 to Strings.Count - 1 do
      WriteString(Section, Strings.Names[I], GetValue(Strings[I]));
{$IFDEF LINUX}
    UpdateFile;
{$ENDIF}
  end;
end;


{ TConnectionAdmin }

constructor TConnectionAdmin.Create;
var
  sConfigFile:String;
begin
  inherited Create;
  sConfigFile := GetDriverRegistryFile(True);
  if not FileExists(sConfigFile) then
    DatabaseErrorFmt(SMissingDriverRegFile,[sConfigFile]);
  FDriverConfig := TIniFile.Create(sConfigFile);
  sConfigFile := GetConnectionRegistryFile(True);
  if not FileExists(sConfigFile) then
    DatabaseErrorFmt(SMissingDriverRegFile,[sConfigFile]);
  FConnectionConfig := TIniFile.Create(sConfigFile);
end;

destructor TConnectionAdmin.Destroy;
begin
  inherited;
  FConnectionConfig.Free;
  FDriverConfig.Free;
end;

procedure TConnectionAdmin.AddConnection(const ConnectionName,
  DriverName: string);
var
  Params: TWideStrings;
  DriverIndex: Integer;
begin
  Params := TWideStringList.Create;
  try
    GetDriverParams(DriverName, Params);
    Params.Insert(0, FormatLine(DRIVERNAME_KEY, DriverName));
    DriverIndex := Params.IndexOfName(GETDRIVERFUNC_KEY);
    if DriverIndex <> -1 then
      Params.Delete(DriverIndex);
    WriteSectionValues(ConnectionConfig, ConnectionName, Params);
  finally
    Params.Free
  end;
end;

procedure TConnectionAdmin.DeleteConnection(const ConnectionName: string);
begin
  ConnectionConfig.EraseSection(ConnectionName);
end;

function TConnectionAdmin.GetConnectionNames(List: TStrings;
  DriverName: string): Integer;
var
  I: Integer;
  A: TStringList;
begin
  A := TStringList.Create;
  try
    { TODO -oTArisawa -cWideSQL : ConnectionConfig is TIniFIle. This class is supported only ANSI data. }
    ConnectionConfig.ReadSections(A);
    List.Assign(A);
  finally
    A.Free;
  end;
  if DriverName <> '' then
  begin
    List.BeginUpdate;
    try
      I := List.Count - 1;
      while I >= 0 do
      begin
        if AnsiCompareText(ConnectionConfig.ReadString(List[i], DRIVERNAME_KEY, ''),
           DriverName) <> 0 then List.Delete(I);
        Dec(I);
      end;
    finally
      List.EndUpdate;
    end;
  end;
  Result := List.Count;
end;

function TConnectionAdmin.GetConnectionParams(const ConnectionName: string;
  Params: TWideStrings): Integer;
var
  A: TStringList;
begin
  A := TStringList.Create;
  try
    ConnectionConfig.ReadSectionValues(ConnectionName, A);
    Params.Assign(A);
  finally
    A.Free;
  end;
  Result := Params.Count;
end;

procedure TConnectionAdmin.GetConnectionParamValues(const ParamName: string;
  Values: TWideStrings);
var
  A: TStringList;
begin
  A := TStringList.Create;
  try
    DriverConfig.ReadSection(ParamName, A);
    Values.Assign(A);
  finally
    A.Free;
  end;
end;

function TConnectionAdmin.GetDriverNames(List: TStrings): Integer;
begin
  DriverConfig.ReadSection(DRIVERS_KEY, List);
  Result := List.Count;
end;

function TConnectionAdmin.GetDriverParams(const DriverName: string; Params: TWideStrings): Integer;

  procedure RemoveEntry(const KeyName: string);
  var
    Index: Integer;
  begin
    Index := Params.IndexOfName(KeyName);
    if Index > -1 then Params.Delete(Index);
  end;
var
  A: TStringList;
begin
  A := TStringList.Create;
  try
    DriverConfig.ReadSectionValues(DriverName, A);
    Params.Assign(A);
  finally
    A.Free;
  end;
  RemoveEntry(DLLLIB_KEY);
  RemoveEntry(VENDORLIB_KEY);
  Result := Params.Count;
end;

procedure TConnectionAdmin.GetDriverLibNames(const DriverName: string;
  var LibraryName, VendorLibrary: string);
begin
  LibraryName := DriverConfig.ReadString(DriverName, DLLLIB_KEY, '');
  VendorLibrary := DriverConfig.ReadString(DriverName, VENDORLIB_KEY, '');
end;

procedure TConnectionAdmin.ModifyConnection(const ConnectionName: string;
  Params: TWideStrings);
begin
  WriteSectionValues(ConnectionConfig, ConnectionName, Params);
end;

procedure TConnectionAdmin.RenameConnection(const OldName, NewName: string);
var
  Params: TWideStrings;
begin
  Params := TWideStringList.Create;
  try
    GetConnectionParams(OldName, Params);
    ConnectionConfig.EraseSection(OldName);
    WriteSectionValues(ConnectionConfig, NewName, Params);
  finally
    Params.Free
  end;
end;

procedure TConnectionAdmin.ModifyDriverParams(const DriverName: string;
  Params: TWideStrings);
begin
  WriteSectionValues(DriverConfig, DriverName, Params);
end;

end.
