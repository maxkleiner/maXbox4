{*******************************************************}
{                                                       }
{       CodeGear Delphi Visual Component Library        }
{                                                       }
{           Copyright (c) 1995-2007 CodeGear            }
{                                                       }
{*******************************************************}

unit CmAdmCtl;

interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL, COMAdmin;

type
  CoCOMAdminCatalog = class
    class function Create: ICOMAdminCatalog;
  end;

  TCOMAdminCatalogCollection = class;

  TCOMAdminCatalog = class(TOleServer)
  private
    FIntf:        ICOMAdminCatalog;
    function      GetDefaultInterface: ICOMAdminCatalog;
  protected
    procedure InitServerData; override;
  public
    { TOleServer }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICOMAdminCatalog);
    procedure Disconnect; override;
    {ICOMAdminCatalog }
    function  GetCollection(const bstrCollName: WideString): 
                            TCOMAdminCatalogCollection;
    function  ICOMAdminCatalog_Connect(const bstrConnectString: WideString): 
                                       TCOMAdminCatalogCollection;
    function  Get_MajorVersion: Integer;
    function  Get_MinorVersion: Integer;
    function  GetCollectionByQuery(const bstrCollName: WideString; 
                                   var aQuery: PSafeArray): 
                                   TCOMAdminCatalogCollection;
    procedure ImportComponent(const bstrApplIdOrName: WideString;
                              const bstrCLSIDOrProgId: WideString);
    procedure InstallComponent(const bstrApplIdOrName: WideString; 
                               const bstrDLL: WideString; 
                               const bstrTLB: WideString; 
                               const bstrPSDLL: WideString);
    procedure ShutdownApplication(const bstrApplIdOrName: WideString);
    procedure ExportApplication(const bstrApplIdOrName: WideString;
                                const bstrApplicationFile: WideString; 
                                lOptions: Integer);
    procedure InstallApplication(const bstrApplicationFile: WideString;
                                 const bstrDestinationDirectory: WideString; 
                                 lOptions: Integer;const bstrUserId: WideString;
                                 const bstrPassword: WideString; 
                                 const bstrRSN: WideString);
    procedure StopRouter;
    procedure RefreshRouter;
    procedure StartRouter;
    procedure InstallMultipleComponents(const bstrApplIdOrName: WideString;
                                        var varFileNames: PSafeArray; 
                                        var varCLSIDS: PSafeArray);
    procedure GetMultipleComponentsInfo(const bstrApplIdOrName: WideString;
                                        var varFileNames: PSafeArray; 
                                        out varCLSIDS: PSafeArray;
                                        out varClassNames: PSafeArray;
                                        out varFileFlags: PSafeArray;
                                        out varComponentFlags: PSafeArray);
    procedure RefreshComponents;
    procedure BackupREGDB(const bstrBackupFilePath: WideString);
    procedure RestoreREGDB(const bstrBackupFilePath: WideString);
    procedure QueryApplicationFile(const bstrApplicationFile: WideString;
                                   out bstrApplicationName: WideString;
                                   out bstrApplicationDescription: WideString;
                                   out bHasUsers: WordBool; 
                                   out bIsProxy: WordBool;
                                   out varFileNames: PSafeArray);
    procedure StartApplication(const bstrApplIdOrName: WideString);
    function  ServiceCheck(lService: Integer): Integer;
    procedure InstallMultipleEventClasses(const bstrApplIdOrName: WideString;
                                          var varFileNames: PSafeArray; 
                                          var varCLSIDS: PSafeArray);
    procedure InstallEventClass(const bstrApplIdOrName: WideString; 
                                const bstrDLL: WideString;
                                const bstrTLB: WideString; 
                                const bstrPSDLL: WideString);
    procedure GetEventClassesForIID(const bstrIID: WideString; 
                                    out varCLSIDS: PSafeArray;
                                    out varProgIDs: PSafeArray; 
                                    out varDescriptions: PSafeArray);
    { properties }
    property  DefaultInterface: ICOMAdminCatalog read GetDefaultInterface;
    property MajorVersion: Integer read Get_MajorVersion;
    property MinorVersion: Integer read Get_MinorVersion;
  end;

  CoCOMAdminCatalogObject = class
    class function Create: ICatalogObject;
  end;

  TCOMAdminCatalogObject = class(TOleServer)
  private
    FIntf:        ICatalogObject;
    function      GetDefaultInterface: ICatalogObject;
  protected
    procedure InitServerData; override;
  public
    { TOleServer }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICatalogObject);
    procedure Disconnect; override;
    { ICatalogObject }
    function  Get_Value(const bstrPropName: WideString): OleVariant;
    procedure Set_Value(const bstrPropName: WideString; retval: OleVariant);
    function  Get_Key: OleVariant;
    function  Get_Name: OleVariant;
    function  IsPropertyReadOnly(const bstrPropName: WideString): WordBool;
    function  Get_Valid: WordBool;
    function  IsPropertyWriteOnly(const bstrPropName: WideString): WordBool;
    property Value[const bstrPropName: WideString]: OleVariant read Get_Value 
                                                               write Set_Value;
    property  DefaultInterface: ICatalogObject read GetDefaultInterface;
    property Key: OleVariant read Get_Key;
    property Name: OleVariant read Get_Name;
    property Valid: WordBool read Get_Valid;
  end;

  CoCOMAdminCatalogCollection = class
    class function Create: ICatalogCollection;
  end;

  TCOMAdminCatalogCollection = class(TOleServer)
  private
    FIntf:        ICatalogCollection;
    function      GetDefaultInterface: ICatalogCollection;
  protected
    procedure InitServerData; override;
  public
    { TOleServer }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICatalogCollection);
    procedure Disconnect; override;
    { ICatalogCollection }
    function  Get_Item(lIndex: Integer): TCOMAdminCatalogObject; 
    function  Get_Count: Integer;
    procedure Remove(lIndex: Integer);
    function  Add: TCOMAdminCatalogObject;
    procedure Populate;
    function  SaveChanges: Integer;
    function  GetCollection(const bstrCollName: WideString;
                            varObjectKey: OleVariant): 
                            TCOMAdminCatalogCollection;
    function  Get_Name: OleVariant;
    function  Get_AddEnabled: WordBool;
    function  Get_RemoveEnabled: WordBool;
    function  GetUtilInterface: IDispatch;
    function  Get_DataStoreMajorVersion: Integer;
    function  Get_DataStoreMinorVersion: Integer;
    procedure PopulateByKey(aKeys: PSafeArray);
    procedure PopulateByQuery(const bstrQueryString: WideString; 
                             lQueryType: Integer);
    { properties }
    property DefaultInterface: ICatalogCollection read GetDefaultInterface;
    property Count: Integer read Get_Count;
    property Name: OleVariant read Get_Name;
    property AddEnabled: WordBool read Get_AddEnabled;
    property RemoveEnabled: WordBool read Get_RemoveEnabled;
    property DataStoreMajorVersion: Integer read Get_DataStoreMajorVersion;
    property DataStoreMinorVersion: Integer read Get_DataStoreMinorVersion;
  end;

implementation

uses ComObj;

class function CoCOMAdminCatalog.Create: ICOMAdminCatalog;
begin
  Result := CreateComObject(CLASS_COMAdminCatalog) as ICOMAdminCatalog;
end;

procedure TCOMAdminCatalog.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F618C514-DFB8-11D1-A2CF-00805FC79235}';
    IntfIID:   '{DD662187-DFC2-11D1-A2CF-00805FC79235}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCOMAdminCatalog.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICOMAdminCatalog;
  end;
end;

procedure TCOMAdminCatalog.ConnectTo(svrIntf: ICOMAdminCatalog);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCOMAdminCatalog.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCOMAdminCatalog.GetDefaultInterface: ICOMAdminCatalog;
begin
  if FIntf = nil then
    Connect;
  Result := FIntf;
end;

constructor TCOMAdminCatalog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCOMAdminCatalog.Destroy;
begin
  inherited Destroy;
end;

function  TCOMAdminCatalog.Get_MajorVersion: Integer;
begin
  Result := DefaultInterface.Get_MajorVersion;
end;

function  TCOMAdminCatalog.Get_MinorVersion: Integer;
begin
  Result := DefaultInterface.Get_MinorVersion;
end;

function TCOMAdminCatalog.GetCollection(const bstrCollName: WideString): 
                                        TCOMAdminCatalogCollection;
begin
  Result := TCOMAdminCatalogCollection.Create(Self);
  Result.ConnectTo(DefaultInterface.GetCollection(bstrCollName) as 
                   ICatalogCollection);
end;

function  TCOMAdminCatalog.ICOMAdminCatalog_Connect(
               const bstrConnectString: WideString): TCOMAdminCatalogCollection;
begin
  Result := TCOMAdminCatalogCollection.Create(Self);
  Result.ConnectTo(DefaultInterface.Connect(bstrConnectString) as ICatalogCollection);
end;

function  TCOMAdminCatalog.GetCollectionByQuery(const bstrCollName: WideString; 
                                                var aQuery: PSafeArray): 
                                                TCOMAdminCatalogCollection;
begin
  Result := TCOMAdminCatalogCollection.Create(Self);
  Result.ConnectTo(DefaultInterface.GetCollectionByQuery(bstrCollName, aQuery) as ICatalogCollection);
end;

procedure TCOMAdminCatalog.ImportComponent(const bstrApplIdOrName: WideString; 
                                           const bstrCLSIDOrProgId: WideString);
begin
  DefaultInterface.ImportComponent(bstrApplIdOrName, bstrCLSIDOrProgId);
end;

procedure TCOMAdminCatalog.InstallComponent(const bstrApplIdOrName: WideString; 
                                            const bstrDLL: WideString; const bstrTLB: WideString; 
                                            const bstrPSDLL: WideString);
begin
  DefaultInterface.InstallComponent(bstrApplIdOrName, bstrDLL, bstrTLB, bstrPSDLL);
end;

procedure TCOMAdminCatalog.ShutdownApplication(const bstrApplIdOrName: WideString);
begin
  DefaultInterface.ShutdownApplication(bstrApplIdOrName);
end;

procedure TCOMAdminCatalog.ExportApplication(const bstrApplIdOrName: WideString; 
                                             const bstrApplicationFile: WideString; 
                                             lOptions: Integer);
begin
  DefaultInterface.ExportApplication(bstrApplIdOrName, bstrApplicationFile, lOptions);
end;

procedure TCOMAdminCatalog.InstallApplication(const bstrApplicationFile: WideString; 
                                              const bstrDestinationDirectory: WideString; 
                                              lOptions: Integer; const bstrUserId: WideString; 
                                              const bstrPassword: WideString; 
                                              const bstrRSN: WideString);
begin
  DefaultInterface.InstallApplication(bstrApplicationFile, bstrDestinationDirectory, lOptions, 
                                      bstrUserId, bstrPassword, bstrRSN);
end;

procedure TCOMAdminCatalog.StopRouter;
begin
  DefaultInterface.StopRouter;
end;

procedure TCOMAdminCatalog.RefreshRouter;
begin
  DefaultInterface.RefreshRouter;
end;

procedure TCOMAdminCatalog.StartRouter;
begin
  DefaultInterface.StartRouter;
end;

procedure TCOMAdminCatalog.InstallMultipleComponents(const bstrApplIdOrName: WideString; 
                                                     var varFileNames: PSafeArray; 
                                                     var varCLSIDS: PSafeArray);
begin
  DefaultInterface.InstallMultipleComponents(bstrApplIdOrName, varFileNames, varCLSIDS);
end;

procedure TCOMAdminCatalog.GetMultipleComponentsInfo(const bstrApplIdOrName: WideString; 
                                                     var varFileNames: PSafeArray; 
                                                     out varCLSIDS: PSafeArray; 
                                                     out varClassNames: PSafeArray; 
                                                     out varFileFlags: PSafeArray; 
                                                     out varComponentFlags: PSafeArray);
begin
  DefaultInterface.GetMultipleComponentsInfo(bstrApplIdOrName, varFileNames, varCLSIDS, 
                                             varClassNames, varFileFlags, varComponentFlags);
end;

procedure TCOMAdminCatalog.RefreshComponents;
begin
  DefaultInterface.RefreshComponents;
end;

procedure TCOMAdminCatalog.BackupREGDB(const bstrBackupFilePath: WideString);
begin
  DefaultInterface.BackupREGDB(bstrBackupFilePath);
end;

procedure TCOMAdminCatalog.RestoreREGDB(const bstrBackupFilePath: WideString);
begin
  DefaultInterface.RestoreREGDB(bstrBackupFilePath);
end;

procedure TCOMAdminCatalog.QueryApplicationFile(const bstrApplicationFile: WideString; 
                                                out bstrApplicationName: WideString; 
                                                out bstrApplicationDescription: WideString; 
                                                out bHasUsers: WordBool; out bIsProxy: WordBool; 
                                                out varFileNames: PSafeArray);
begin
  DefaultInterface.QueryApplicationFile(bstrApplicationFile, bstrApplicationName, 
                                        bstrApplicationDescription, bHasUsers, bIsProxy, 
                                        varFileNames);
end;

procedure TCOMAdminCatalog.StartApplication(const bstrApplIdOrName: WideString);
begin
  DefaultInterface.StartApplication(bstrApplIdOrName);
end;

function  TCOMAdminCatalog.ServiceCheck(lService: Integer): Integer;
begin
  Result := DefaultInterface.ServiceCheck(lService);
end;

procedure TCOMAdminCatalog.InstallMultipleEventClasses(const bstrApplIdOrName: WideString; 
                                                       var varFileNames: PSafeArray; 
                                                       var varCLSIDS: PSafeArray);
begin
  DefaultInterface.InstallMultipleEventClasses(bstrApplIdOrName, varFileNames, varCLSIDS);
end;

procedure TCOMAdminCatalog.InstallEventClass(const bstrApplIdOrName: WideString; 
                                             const bstrDLL: WideString; const bstrTLB: WideString; 
                                             const bstrPSDLL: WideString);
begin
  DefaultInterface.InstallEventClass(bstrApplIdOrName, bstrDLL, bstrTLB, bstrPSDLL);
end;

procedure TCOMAdminCatalog.GetEventClassesForIID(const bstrIID: WideString; 
                                                 out varCLSIDS: PSafeArray; 
                                                 out varProgIDs: PSafeArray; 
                                                 out varDescriptions: PSafeArray);
begin
  DefaultInterface.GetEventClassesForIID(bstrIID, varCLSIDS, varProgIDs, varDescriptions);
end;

class function CoCOMAdminCatalogObject.Create: ICatalogObject;
begin
  Result := CreateComObject(CLASS_COMAdminCatalogObject) as ICatalogObject;
end;

procedure TCOMAdminCatalogObject.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F618C515-DFB8-11D1-A2CF-00805FC79235}';
    IntfIID:   '{6EB22871-8A19-11D0-81B6-00A0C9231C29}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCOMAdminCatalogObject.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICatalogObject;
  end;
end;

procedure TCOMAdminCatalogObject.ConnectTo(svrIntf: ICatalogObject);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCOMAdminCatalogObject.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCOMAdminCatalogObject.GetDefaultInterface: ICatalogObject;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TCOMAdminCatalogObject.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCOMAdminCatalogObject.Destroy;
begin
  inherited Destroy;
end;

function  TCOMAdminCatalogObject.Get_Value(const bstrPropName: WideString): OleVariant;
begin
  Result := DefaultInterface.Get_Value(bstrPropName);
end;

procedure TCOMAdminCatalogObject.Set_Value(const bstrPropName: WideString; retval: OleVariant);
begin
  DefaultInterface.Set_Value(bstrPropName, retval);
end;

function  TCOMAdminCatalogObject.Get_Key: OleVariant;
begin
  Result := DefaultInterface.Get_Key;
end;

function  TCOMAdminCatalogObject.Get_Name: OleVariant;
begin
  Result := DefaultInterface.Get_Name;
end;

function  TCOMAdminCatalogObject.Get_Valid: WordBool;
begin
  Result := DefaultInterface.Get_Valid;
end;

function  TCOMAdminCatalogObject.IsPropertyReadOnly(const bstrPropName: WideString): WordBool;
begin
  Result := DefaultInterface.IsPropertyReadOnly(bstrPropName);
end;

function  TCOMAdminCatalogObject.IsPropertyWriteOnly(const bstrPropName: WideString): WordBool;
begin
  Result := DefaultInterface.IsPropertyWriteOnly(bstrPropName);
end;

class function CoCOMAdminCatalogCollection.Create: ICatalogCollection;
begin
  Result := CreateComObject(CLASS_COMAdminCatalogCollection) as ICatalogCollection;
end;

procedure TCOMAdminCatalogCollection.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F618C516-DFB8-11D1-A2CF-00805FC79235}';
    IntfIID:   '{6EB22872-8A19-11D0-81B6-00A0C9231C29}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCOMAdminCatalogCollection.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICatalogCollection;
  end;
end;

procedure TCOMAdminCatalogCollection.ConnectTo(svrIntf: ICatalogCollection);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCOMAdminCatalogCollection.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCOMAdminCatalogCollection.GetDefaultInterface: ICatalogCollection;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TCOMAdminCatalogCollection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCOMAdminCatalogCollection.Destroy;
begin
  inherited Destroy;
end;

function  TCOMAdminCatalogCollection.Get_Item(lIndex: Integer): TCOMAdminCatalogObject;
begin
  Result := TCOMAdminCatalogObject.Create(Self);
  Result.ConnectTo( DefaultInterface.Get_Item(lIndex) as ICatalogObject);
end;

function  TCOMAdminCatalogCollection.Get_Count: Integer;
begin
  Result := DefaultInterface.Get_Count;
end;

function  TCOMAdminCatalogCollection.Get_Name: OleVariant;
begin
  Result := DefaultInterface.Get_Name;
end;

function  TCOMAdminCatalogCollection.Get_AddEnabled: WordBool;
begin
  Result := DefaultInterface.Get_AddEnabled;
end;

function  TCOMAdminCatalogCollection.Get_RemoveEnabled: WordBool;
begin
  Result := DefaultInterface.Get_RemoveEnabled;
end;

function  TCOMAdminCatalogCollection.Get_DataStoreMajorVersion: Integer;
begin
  Result := DefaultInterface.Get_DataStoreMajorVersion;
end;

function  TCOMAdminCatalogCollection.Get_DataStoreMinorVersion: Integer;
begin
  Result := DefaultInterface.Get_DataStoreMinorVersion;
end;

procedure TCOMAdminCatalogCollection.Remove(lIndex: Integer);
begin
  DefaultInterface.Remove(lIndex);
end;

function  TCOMAdminCatalogCollection.Add: TCOMAdminCatalogObject;
begin
  Result := TCOMAdminCatalogObject.Create(Self);
  Result.ConnectTo( DefaultInterface.Add() as ICatalogObject);
end;

procedure TCOMAdminCatalogCollection.Populate;
begin
  DefaultInterface.Populate;
end;

function  TCOMAdminCatalogCollection.SaveChanges: Integer;
begin
  Result := DefaultInterface.SaveChanges;
end;

function  TCOMAdminCatalogCollection.GetCollection(const bstrCollName: WideString; 
                                                   varObjectKey: OleVariant):
                                                   TCOMAdminCatalogCollection;
begin
  Result := TCOMAdminCatalogCollection.Create(Self);
  Result.ConnectTo( DefaultInterface.GetCollection(bstrCollName, varObjectKey)
                    as ICatalogCollection);
end;

function  TCOMAdminCatalogCollection.GetUtilInterface: IDispatch;
begin
  Result := DefaultInterface.GetUtilInterface;
end;

procedure TCOMAdminCatalogCollection.PopulateByKey(aKeys: PSafeArray);
begin
  DefaultInterface.PopulateByKey(aKeys);
end;

procedure TCOMAdminCatalogCollection.PopulateByQuery(const bstrQueryString: WideString; 
                                                     lQueryType: Integer);
begin
  DefaultInterface.PopulateByQuery(bstrQueryString, lQueryType);
end;

end.
