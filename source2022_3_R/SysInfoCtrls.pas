{
 SysInfoCtrls Suite written by Simone Di Cicco - Italy
 This Component/Unit give you some System Information:

  Windows:                           System:                 Other:
   -Windows UserName                   -Computer Name          -Date
   -Windows CompanyName                -CPU Identifier         -Resolution
   -Windows Version                    -CPU Vendor             -DirectX Version
   -Windows Version Number             -Serial Ports
   -Windows ProductName                -Adapter Type
   -Windows Product ID                 -Printer
   -Windows Product Key
   -Windows Config Path
   -Windows Program Directory
   -Windows System Root
   -Windows Plus! Version

   Thank you for choosing my component
   You can contact me at this E-Mail address:

   simone.dicicco@tin.it     or
   whisper@email.it

   http://www.devresource.net
}

unit SysInfoCtrls;

interface

uses
  Messages, SysUtils, Classes, Windows, Registry;

const
 About = 'InfoCtrl component written by Simone Di Cicco';
 DateFormat = 'dd/mm/yyyy';

type

  TOtherInfo = class(TComponent)
   private
      function GetDate:       string;
      function GetResolution: string;
      function GetDirectXVer: string;
      function GetAbout:      string;
   public
      property    Date:       string read GetDate;
      property    Resolution: string read GetResolution;
      property    DirectXVer: string read GetDirectXVer;
      property    About:      string read GetAbout;
      constructor Create(AOwner: TComponent); override;
      destructor  Destroy; override;
  end;

  TWinInfo = class(TComponent)
    private
      function GetUserName:    string;
      function GetCompanyName: string;
      function GetWinVer:      string;
      function GetWinVerNo:    string;
      function GetProductName: string;
      function GetProductID:   string;
      function GetProductKey:  string;
      function GetCfgPath:     string;
      function GetProgramDir:  string;
      function GetSysRoot:     string;
      function GetPlusVer:     string;
    public
      property    UserName:    string read GetUsername;
      property    CompanyName: string read GetCompanyName;
      property    WinVer:      string read GetWinVer;
      property    WinVerNo:    string read GetWinVerNo;
      property    ProductName: string read GetProductName;
      property    ProductID:   string read GetProductID;
      property    ProductKey:  string read GetProductKey;
      property    CfgPath:     string read GetCfgPath;
      property    ProgramDir:  string read GetProgramDir;
      property    SysRoot:     string read GetSysRoot;
      property    PlusVer:     string read GetPlusVer;
      constructor Create(AOwner: TComponent); override;
      destructor  Destroy; override;
  end;

  TSystemInfo2 = class(TComponent)
    private
      function GetComputerName:           string;
      function GetCPUIdentifier:          string;
      function GetCPUVendor:              string;
      function GetSerialPorts:            string;
      function GetAdapterType:            string;
      function GetNetworkPrimaryProvider: string;
      function GetNetworkUsername:        string;
      function GetPrinter:                string;
    public
      property    ComputerName:           string read GetComputerName;
      property    CPUIdentifier:          string read GetCPUIdentifier;
      property    CPUVendor:              string read GetCPUVendor;
      property    SerialPorts:            string read GetSerialPorts;
      property    AdapterType:            string read GetAdapterType;
      property    NetworkPrimaryProvider: string read GetNetworkPrimaryProvider;
      property    NetworkUsername:        string read GetNetworkUsername;
      property    Printer:                string read GetPrinter;
      constructor Create(AOwner: TComponent); override;
      destructor  Destroy; override;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('S.DiCicco', [TOtherInfo]);
  RegisterComponents('S.DiCicco', [TWinInfo]);
  RegisterComponents('S.DiCicco', [TSystemInfo2]);
end;

{ TInfoCtrl }

constructor TOtherInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

destructor TOtherInfo.Destroy;
begin

  inherited Destroy;
end;

function TOtherInfo.GetResolution: string;
begin
  Result := IntToStr(GetSystemMetrics(SM_CXSCREEN))+' x '+IntToStr(GetSystemMetrics(SM_CYSCREEN));
end;

function TOtherInfo.GetAbout: string;
begin
  Result := About;
end;

function TOtherInfo.GetDate: string;
begin
  Result := FormatDateTime(DateFormat, Now);
end;

function TOtherInfo.GetDirectXVer: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\DirectX', True);
  Result := Reg.ReadString('Version');
end;

{ TWinInfo }

constructor TWinInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

destructor TWinInfo.Destroy;
begin

  inherited Destroy;
end;

function TWinInfo.GetCfgPath: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('ConfigPath');
end;

function TWinInfo.GetCompanyName: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('RegisteredOrganization');
end;

function TWinInfo.GetPlusVer: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('Plus! VersionNumber');
end;

function TWinInfo.GetProductID: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('ProductId');
end;

function TWinInfo.GetProductKey: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('ProductKey');
end;

function TWinInfo.GetProductName: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('ProductName');
end;

function TWinInfo.GetProgramDir: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('ProgramFilesPath');
end;

function TWinInfo.GetSysRoot: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('SystemRoot');
end;

function TWinInfo.GetUserName: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('RegisteredOwner');
end;

function TWinInfo.GetWinVer: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('Version');
end;

function TWinInfo.GetWinVerNo: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('VersionNumber');
end;

{ TSystemInfo }

constructor TSystemInfo2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

destructor TSystemInfo2.Destroy;
begin

  inherited Destroy;
end;

function TSystemInfo2.GetAdapterType: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Hardware\Description\System\MultifunctionAdapter\0', True);
  Result := Reg.ReadString('Identifier');

end;

function TSystemInfo2.GetComputerName: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\System\CurrentControlSet\Control\ComputerName\ComputerName', True);
  Result := Reg.ReadString('ComputerName');
end;

function TSystemInfo2.GetCPUIdentifier: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Hardware\Description\System\CentralProcessor\0', True);
  Result := Reg.ReadString('Identifier');
end;

function TSystemInfo2.GetCPUVendor: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Hardware\Description\System\CentralProcessor\0', True);
  Result := Reg.ReadString('VendorIdentifier');
end;

function TSystemInfo2.GetNetworkPrimaryProvider: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Network\Logon', True);
  Result := Reg.ReadString('PrimaryProvider');
end;

function TSystemInfo2.GetNetworkUsername: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Network\Logon', True);
  Result := Reg.ReadString('username');
end;

function TSystemInfo2.GetPrinter: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_CONFIG;
  Reg.OpenKey('\System\CurrentControlSet\Control\Print\Printers', True);
  Result := Reg.ReadString('Default');
end;

function TSystemInfo2.GetSerialPorts: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Hardware\DeviceMap\SerialComm', True);
  Result := Reg.ReadString('COM1')+' and '+Reg.ReadString('COM2');
end;

end.

