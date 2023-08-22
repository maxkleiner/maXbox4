
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{           version 5.6 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSystemInfo;

interface

uses
  MSI_CPU, MSI_Machine, MSI_Devices, MSI_Display, MSI_Network, MSI_Media,
  MSI_Memory, MSI_Engines, MSI_APM, MSI_Disk, MSI_DirectX, MSI_OS, MSI_Processes,
  MSI_Printers, MSI_Software, MSI_Startup,
  SysUtils, Windows, Classes, DsgnIntf;

const
  cCompName = 'MiTeC System Information Component';
  cVersion = '5.6';
  cCopyright = 'Copyright © 1997,2001 Michal Mutl';

type
  TMSystemInfo = class(TComponent)
  private
    FCPU: TCPU;
    FMemory: TMemory;
    FOS :TOperatingSystem;
    FDisk :TDisk;
    FMachine: TMachine;
    FNetwork: TNetwork;
    FDisplay: TDisplay;
    FEngines: TEngines;
    FDevices: TDevices;
    FAPM :TAPM;
    FAbout: string;
    FDirectX: TDirectX;
    FMedia: TMedia;
    FProcesses: TProcesses;
    FPrinters: TPrinters;
    FSoftware: TSoftware;
    FStartup: TStartup;
    procedure SetAbout(const Value: string);
  public
    constructor Create(AOwner :TComponent); override;
    destructor Destroy; override;
    procedure Refresh;
    procedure Report(var sl :TStringList);
    procedure ShowModalOverview;
    procedure ShowModalOverviewWithAbout;
    procedure ShowOverview;
    procedure ShowOverviewWithAbout;
  published
    property About :string read FAbout write SetAbout;
    property CPU :TCPU read FCPU write FCPU;
    property Memory :TMemory read FMemory write FMemory;
    property OS :TOperatingSystem read FOS write FOS;
    property Disk :TDisk read FDisk write FDisk;
    property Machine :TMachine read FMachine write FMachine;
    property Network :TNetwork read FNetwork write FNetwork;
    property Display :TDisplay read FDisplay write FDisplay;
    property Media :TMedia read FMedia write FMedia;
    property Devices :TDevices read FDevices write FDevices;
    property Engines :TEngines read FEngines write FEngines;
    property APM :TAPM read FAPM write FAPM;
    property DirectX :TDirectX read FDirectX write FDirectX;
    property Processes :TProcesses read FProcesses write FProcesses;
    property Printers :TPrinters read FPrinters write FPrinters;
    property Software :TSoftware read FSoftware write FSoftware;
    property Startup: TStartup read FStartup write FStartup;
  end;

  TMSI_PropertyEditor = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TMSI_ComponentEditor = class(TComponentEditor)
  public
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): String; override;
    procedure ExecuteVerb(Index: Integer); override;
    procedure Edit; override;
  end;

procedure Register;

implementation

uses MSI_Overview, MSI_CPUUsage, Forms;

procedure Register;
begin
  RegisterComponents('MiTeC',[TMCPUUsage]);
  RegisterComponents('MiTeC',[TMSystemInfo]);
  RegisterPropertyEditor(TypeInfo(string),TMSystemInfo,'About',TMSI_PropertyEditor);
  RegisterComponentEditor(TMSystemInfo,TMSI_ComponentEditor);
end;

{ TMSystemInfo }

constructor TMSystemInfo.Create(AOwner: TComponent);
begin
  inherited;
  FAbout:=cCompName+' '+cVersion+' - '+cCopyright;
  FCPU:=TCPU.Create;
  FMemory:=TMemory.Create;
  FOS:=TOperatingSystem.Create;
  FDisk:=TDisk.Create;
  FMachine:=TMachine.Create;
  FNetwork:=TNetwork.Create;
  FDisplay:=TDisplay.Create;
  FMedia:=TMedia.Create;
  FDevices:=TDevices.Create;
  FEngines:=TEngines.Create;
  FAPM:=TAPM.Create;
  FDirectX:=TDirectX.Create;
  FProcesses:=TProcesses.Create;
  FPrinters:=TPrinters.Create;
  FSoftware:=TSoftware.Create;
  FStartup:=TStartup.Create;
  if csDesigning in ComponentState then
    Refresh;
end;

destructor TMSystemInfo.Destroy;
begin
  FCPU.Free;
  FMemory.Free;
  FOS.Free;
  FDisk.Free;
  FMachine.Free;
  FNetwork.Free;
  FDisplay.Free;
  FMedia.Free;
  FDevices.Free;
  FEngines.Free;
  FAPM.Free;
  FDirectX.Free;
  FProcesses.Free;
  FPrinters.Free;
  FSoftware.Free;
  FStartup.Free;
  inherited;
end;

procedure TMSystemInfo.Refresh;
begin
  FDevices.GetInfo;
  CPU.GetInfo;
  Memory.GetInfo;
  OS.GetInfo;
  Disk.GetInfo;
  Disk.Drive:=copy(OS.Folders.Values['Windows'],1,2);
  FMachine.GetInfo;
  FNetwork.GetInfo;
  FDisplay.GetInfo;
  FMedia.GetInfo;
  FEngines.GetInfo;
  FAPM.GetInfo;
  FDirectX.GetInfo;
  FProcesses.GetInfo;
  FPrinters.GetInfo;
  FSoftware.GetInfo;
  FStartup.GetInfo;
end;

procedure TMSystemInfo.Report(var sl: TStringList);
begin
  sl.add('; '+About);
  sl.add('');
  Machine.Report(sl);
  OS.Report(sl);
  CPU.Report(sl);
  Memory.Report(sl);
  Display.Report(sl);
  APM.Report(sl);
  Media.Report(sl);
  Network.Report(sl);
  Devices.Report(sl);
  Engines.Report(sl);
  DirectX.Report(sl);
  Disk.Report(sl);
  Processes.Report(sl);
  Printers.Report(sl);
  Software.Report(sl);
  Startup.Report(sl);
end;

procedure TMSystemInfo.SetAbout(const Value: string);
begin
end;

procedure TMSystemInfo.ShowModalOverview;
begin
  with TfrmMSI_Overview.Create(Application) do begin
    SysInfo:=Self;
    DisplayedPages:=pgAll;
    ShowReportButton:=True;
    cmRefresh(nil);
    ShowModal;
    Free;
  end;
end;

procedure TMSystemInfo.ShowModalOverviewWithAbout;
begin
  with TfrmMSI_Overview.Create(Application) do begin
    SysInfo:=Self;
    DisplayedPages:=pgAll+[pgAbout];
    ShowReportButton:=True;
    cmRefresh(nil);
    ShowModal;
    Free;
  end;
end;

procedure TMSystemInfo.ShowOverview;
begin
  try
    frmMSI_Overview.Show;
  except
    frmMSI_Overview:=TfrmMSI_Overview.Create(Application.MainForm);
    with frmMSI_Overview do begin
      SysInfo:=Self;
      DisplayedPages:=pgAll;
      ShowReportButton:=True;
      cmRefresh(nil);
      Show;
    end;
  end;
end;

procedure TMSystemInfo.ShowOverviewWithAbout;
begin
  try
    frmMSI_Overview.Show;
  except
    frmMSI_Overview:=TfrmMSI_Overview.Create(Application.MainForm);
    with frmMSI_Overview do begin
      SysInfo:=Self;
      DisplayedPages:=pgAll+[pgAbout];
      ShowReportButton:=True;
      cmRefresh(nil);
      Show;
    end;
  end;
end;

{ TMSI_ComponentEditor }

procedure TMSI_ComponentEditor.Edit;
begin
  TMSystemInfo(Self.Component).ShowModalOverviewWithAbout;
end;

procedure TMSI_ComponentEditor.ExecuteVerb(Index: Integer);
begin
  if Index=0 then
    Edit;
end;

function TMSI_ComponentEditor.GetVerb(Index: Integer): String;
begin
  if Index=0 then
    Result:='System Overview...'
  else
    Result:=inherited GetVerb(Index-1);
end;

function TMSI_ComponentEditor.GetVerbCount: Integer;
begin
  Result:=inherited GetVerbCount+1;
end;

{ TMSI_PropertyEditor }

procedure TMSI_PropertyEditor.Edit;
begin
  TMSystemInfo(Self.GetComponent(0)).ShowModalOverviewWithAbout;
end;

function TMSI_PropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result:=[paDialog, paReadOnly];
end;

end.

