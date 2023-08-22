unit xrtl_util_Module;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils,
  xrtl_util_TimeStamp, xrtl_util_Compat;

type
  TXRTLModuleKind = (mkApplication, mkDLL, mkPackage);

  TXRTLModule = class
  private
    FStartTime: TXRTLTimeStamp;
    FModuleFilePath: string;
    FModulePath: string;
    FModuleName: string;
    FKind: TXRTLModuleKind;
    FApplicationFilePath: string;
    FApplicationPath: string;
    FApplicationName: string;
    constructor Create;
  public
    destructor Destroy; override;
    property   ModuleFilePath: string read FModuleFilePath;
    property   ModulePath: string read FModulePath;
    property   ModuleName: string read FModuleName;
    property   ApplicationFilePath: string read FApplicationFilePath;
    property   ApplicationPath: string read FApplicationPath;
    property   ApplicationName: string read FApplicationName;
    property   StartTime: TXRTLTimeStamp read FStartTime;
    property   Kind: TXRTLModuleKind read FKind;
  end;

function XRTLModule: TXRTLModule;

implementation

uses
  xrtl_util_Type,
  xrtl_util_FileUtils;

var
  FXRTLModule: TXRTLModule = nil;

function XRTLModule: TXRTLModule;
begin
  Result:= FXRTLModule;
end;

{ TXRTLModule }

constructor TXRTLModule.Create;
begin
  inherited;
  FStartTime:= TXRTLTimeStamp.Create;
  FModuleFilePath:= XRTLExtractLongPathName(GetModuleName(HInstance));
  FModulePath:= ExtractFilePath(FModuleFilePath);
  FModuleName:= ChangeFileExt(ExtractFileName(FModuleFilePath), '');
  FKind:= mkApplication;
  if ModuleIsLib then
  begin
    if ModuleIsPackage then
      FKind:= mkPackage
    else
      FKind:= mkDLL;
  end;
  case FKind of
    mkDLL:
    begin
      FApplicationFilePath:= XRTLExtractLongPathName(GetModuleName(HInstance));
    end;
    mkPackage, mkApplication:
    begin
      FApplicationFilePath:= XRTLExtractLongPathName(GetModuleName(MainInstance));
    end;
  else
  end;
  FApplicationPath:= ExtractFilePath(FApplicationFilePath);
  FApplicationName:= ChangeFileExt(ExtractFileName(FApplicationFilePath), '');
end;

destructor TXRTLModule.Destroy;
begin
  FreeAndNil(FStartTime);
  inherited;
end;

initialization
begin
  FXRTLModule:= TXRTLModule.Create;
end;

finalization
begin
  FreeAndNil(FXRTLModule);
end;

end.
