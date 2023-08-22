{*******************************************************}
{                                                       }
{       CodeGear Delphi Visual Component Library        }
{                                                       }
{  	    Copyright (c) 1995-2007 CodeGear	        }
{                                                       }
{*******************************************************}

unit CtlPanel;

interface

uses
  Windows, SysUtils, Classes, Graphics, Cpl;

type
  EAppletException = class(Exception);

  TInitEvent = procedure (Sender: TObject; var AppInitOK: Boolean) of object;
  TCountEvent = procedure (Sender: TObject; var AppCount: Integer) of object;
  TExitEvent = TNotifyEvent;
  TSetupEvent = TNotifyEvent;

  TActivateEvent     = procedure (Sender: TObject; Data: LongInt) of object;
  TStopEvent         = procedure (Sender: TObject; Data: LongInt) of object;
  TInquireEvent      = procedure (Sender: TObject; var idIcon: Integer; var idName: Integer;
                                  var idInfo: Integer; var lData: Integer) of object;
  TNewInquireEvent   = procedure (Sender: TObject; var lData: Integer; var hIcon: HICON;
                                  var AppletName: string; var AppletInfo: string) of object; 
  TStartWParmsEvent  = procedure (Sender: TObject; Params: string) of object;

  TAppletModule = class(TDataModule)
  private
    FOnActivate: TActivateEvent;
    FOnStop: TStopEvent;
    FOnInquire: TInquireEvent;
    FOnNewInquire: TNewInquireEvent;
    FOnStartWParms: TStartWParmsEvent;
    FData: LongInt;
    FResidIcon: Integer;
    FResidName: Integer;
    FResidInfo: Integer;
    FAppletIcon: TIcon;
    FCaption: string;
    FHelp: string;
    procedure SetData(const Value: LongInt);
    procedure SetResidIcon(const Value: Integer);
    procedure SetResidInfo(const Value: Integer);
    procedure SetResidName(const Value: Integer);
    procedure SetAppletIcon(const Value: TIcon);
    procedure SetCaption(const Value: string);
    procedure SetHelp(const Value: string);
    function GetCaption: string;
  protected
    procedure DoStop(Data: LongInt); dynamic;
    procedure DoActivate(Data: LongInt); dynamic;
    procedure DoInquire(var ACPLInfo: TCPLInfo); dynamic;
    procedure DoNewInquire(var ANewCPLInfo: TNewCPLInfo); dynamic;
    procedure DoStartWParms(Params: string); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Data: LongInt read FData write SetData;
  published
    property OnStop: TStopEvent read FOnStop write FOnStop;
    property OnActivate: TActivateEvent read FOnActivate write FOnActivate;
    property OnInquire: TInquireEvent read FOnInquire write FOnInquire;
    property OnNewInquire: TNewInquireEvent read FOnNewInquire write FOnNewInquire;
    property OnStartWParms: TStartWParmsEvent read FOnStartWParms write FOnStartWParms;
    property Caption: string read GetCaption write SetCaption;
    property AppletIcon: TIcon read FAppletIcon write SetAppletIcon;
    property Help: string read FHelp write SetHelp;
    property ResidIcon: Integer read FResidIcon write SetResidIcon;
    property ResidName: Integer read FResidName write SetResidName;
    property ResidInfo: Integer read FResidInfo write SetResidInfo;
  end;

  TAppletModuleClass = class of TAppletModule;
  TCPLAppletClass = class of TAppletModule;
  TDataModuleClass = class of TDataModule;

  TOnAppletExceptionEvent = procedure (Sender: TObject; E: Exception) of object;

  TAppletApplication = class(TComponent)
  private
    FControlPanelHandle: THandle;
    FModules: TList;
    FOnInit: TInitEvent;
    FOnCount: TCountEvent;
    FOnExit: TExitEvent;
    FOnSetup: TSetupEvent;
    FModuleCount: Integer;
    FOnException: TOnAppletExceptionEvent;
    function GetModules(Index: Integer): TAppletModule;
    procedure SetModules(Index: Integer; const Value: TAppletModule);
    procedure SetModuleCount(const Value: Integer);
    function GetModuleCount: Integer;
  protected
    procedure DoHandleException(Sender: TObject; E: Exception); dynamic;
    procedure DoInit(var AppInitOK: Boolean); dynamic;
    procedure DoCount(var AppCount: Integer); dynamic;
    procedure DoExit; dynamic;
    procedure DoSetup; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateForm(InstanceClass: TComponentClass; var Reference); virtual;
    procedure HandleException(Sender: TObject);
    procedure Initialize; virtual;
    procedure Run; virtual;
    property Modules[Index: Integer]: TAppletModule read GetModules write SetModules;
    property ModuleCount: Integer read GetModuleCount write SetModuleCount;
    property ControlPanelHandle: THandle read FControlPanelHandle;
    property OnInit: TInitEvent read FOnInit write FOnInit;
    property OnCount: TCountEvent read FOnCount write FOnCount;
    property OnException: TOnAppletExceptionEvent read FOnException write FOnException; 
    property OnExit: TExitEvent read FOnExit write FOnExit;
    property OnSetup: TSetupEvent read FOnSetup write FOnSetup;
  end;

function CPlApplet(hwndCPl: THandle; uMsg: DWORD;
                   lParam1, lParam2: Longint): Longint; stdcall;

var
  Application: TAppletApplication = nil;

implementation

uses
  CtlConsts;

{ TAppletApp }

constructor TAppletApplication.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FModules := TList.Create;
end;

procedure TAppletApplication.CreateForm(InstanceClass: TComponentClass;
  var Reference);
var
  Instance: TComponent;
begin
  try
    if InstanceClass.InheritsFrom(TDataModule) then
    begin
      Instance := TComponent(InstanceClass.NewInstance);
      TComponent(Reference) := Instance;
      Instance.Create(Self);
    end
    else
      raise EAppletException.CreateRes(@sInvalidClassReference);
  except
    TComponent(Reference) := nil;
    HandleException(Self);
  end;
end;

destructor TAppletApplication.Destroy;
begin
  while FModules.Count > 0 do
    TObject(FModules[0]).Free;

  FModules.Free;
  inherited Destroy;
  Classes.ApplicationHandleException := nil;
end;

procedure TAppletApplication.DoCount(var AppCount: Integer);
begin
  if Assigned(FOnCount) then
    FOnCount(Self, AppCount);
end;

procedure TAppletApplication.DoExit;
begin
  if Assigned(FOnExit) then
    FOnExit(Self);
end;

procedure TAppletApplication.DoHandleException(Sender: TObject; E: Exception);
begin
  if not (E is EAbort) then
    if Assigned(FOnException) then
      FOnException(Sender, E)
    else
      ShowException(E, ExceptAddr);
end;

procedure TAppletApplication.DoInit(var AppInitOK: Boolean);
begin
  if Assigned(FOnInit) then
    FOnInit(Self, AppInitOK);
end;

procedure TAppletApplication.DoSetup;
begin
  if Assigned(FOnSetup) then
    FOnSetup(Self);
end;

function TAppletApplication.GetModuleCount: Integer;
begin
  Result := FModules.Count;
end;

function TAppletApplication.GetModules(Index: Integer): TAppletModule;
begin
  Result := FModules[Index];
end;

procedure TAppletApplication.Initialize;
begin
end;

procedure TAppletApplication.HandleException(Sender: TObject);
begin
  if ExceptObject is Exception then
    DoHandleException(Sender, Exception(ExceptObject))
  else
    SysUtils.ShowException(ExceptObject, ExceptAddr);
end;

procedure TAppletApplication.Run;
begin
  if not Assigned(Classes.ApplicationHandleException) then
    Classes.ApplicationHandleException := HandleException;
end;

procedure InitApplication;
begin
  Application := TAppletApplication.Create(nil);
end;

procedure DoneApplication;
begin
  Application.Free;
  Application := nil;
end;

function CPlApplet(hwndCPl: THandle; uMsg: DWORD; lParam1, lParam2: Longint): Longint;
var
  Temp: Boolean;
begin
  Result := 0;
  Temp := True;
  try
    with Application, Application.Modules[lParam1] do
    begin
      FControlPanelHandle := hwndCPl;

      case (umsg) of
        CPL_INIT :
        begin
          DoInit(Temp);
          Result := Integer(Temp);
        end;
        CPL_GETCOUNT:
        begin
          Result := ModuleCount;
          DoCount(Result);
        end;
        CPL_STARTWPARMS :
        begin
          DoStartWParms(PChar(LParam2));
          Result := 1;
        end;
        CPL_INQUIRE     : DoInquire(PCplInfo(lParam2)^);
        CPL_NEWINQUIRE  : DoNewInquire(PNewCPLInfo(lParam2)^);
        CPL_DBLCLK      : DoActivate(LongInt(lParam2));
        CPL_STOP        : DoStop(LongInt(LParam2));
        CPL_EXIT        : DoExit;
        CPL_SETUP       : DoSetup;
      end;
    end;
  except
    Application.HandleException(Application);
    Result := 1;
  end;
end;

constructor TAppletModule.Create(AOwner: TComponent);
begin
  FAppletIcon := TIcon.Create;
  inherited Create(AOwner);
  Application.FModules.Add(Self);
end;

destructor TAppletModule.Destroy;
begin
  FAppletIcon.Free;
  Application.FModules.Delete(Application.FModules.IndexOf(Self));
  inherited Destroy;
end;

function TAppletModule.GetCaption: string;
begin
  if FCaption <> '' then
    Result := FCaption
  else
    Result := Name;
end;

procedure TAppletModule.DoActivate(Data: Integer);
begin
  if Assigned(FOnActivate) then
    FOnActivate(Self, Data);
end;

procedure TAppletModule.DoInquire(var ACPLInfo: TCPLInfo);
begin
  with ACPLInfo do
  begin
    idIcon := FResidIcon;
    idName := FResidName;
    idInfo := FResidInfo;
    lData := FData;
  end;

  if Assigned(FOnInquire) then
    with ACPLInfo do
      FOnInquire(Self, idIcon, idName, idInfo, lData);
end;

procedure TAppletModule.DoNewInquire(var ANewCPLInfo: TNewCPLInfo);
begin
  with ANewCPLInfo do
  begin
    dwSize := SizeOf(TNewCPLInfo);
    lData := FData;
    if (FResidIcon = CPL_DYNAMIC_RES) then
      hIcon := FAppletIcon.Handle
    else
      hIcon := LoadIcon(hInstance, MakeIntResource(FResidIcon));
  end;

  if Assigned(fOnNewInquire) then
    with ANewCPLInfo do
      FOnNewInquire(Self, lData, hIcon, FCaption, FHelp);

  if (FResidName = CPL_DYNAMIC_RES) then
    StrLCopy(ANewCPLInfo.szName, PChar(FCaption), SizeOf(ANewCPLInfo.szName)-1)
  else
    StrLCopy(ANewCPLInfo.szName, PChar(LoadStr(FResidName)), SizeOf(ANewCPLInfo.szName)-1);

  if (FResidInfo = CPL_DYNAMIC_RES) then
    StrLCopy(ANewCPLInfo.szInfo, PChar(FHelp), SizeOf(ANewCPLInfo.szInfo)-1)
  else
    StrLCopy(ANewCPLInfo.szInfo, PChar(LoadStr(FResidInfo)), SizeOf(ANewCPLInfo.szInfo)-1);
end;

procedure TAppletModule.DoStartWParms(Params: string);
begin
  if Assigned(FOnStartWParms) then
    FOnStartWParms(Self, Params);
end;

procedure TAppletModule.DoStop(Data: Integer);
begin
  if Assigned(FOnStop) then
    FOnStop(Self, Data);
end;

procedure TAppletModule.SetAppletIcon(const Value: TIcon);
begin
  if FAppletIcon <> Value then
  begin
    FAppletIcon.Assign(Value);
    ResidIcon := CPL_DYNAMIC_RES;
  end;
end;

procedure TAppletModule.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    if Value = '' then
      FCaption := Name
    else
      FCaption := Value;
    FResidName := CPL_DYNAMIC_RES;
  end;
end;

procedure TAppletModule.SetData(const Value: Integer);
begin
  if FData <> Value then
    FData := Value;
end;

procedure TAppletModule.SetHelp(const Value: string);
begin
  if FHelp <> Value then
  begin
    FHelp := Value;
    FResidInfo := CPL_DYNAMIC_RES;
  end;
end;

procedure TAppletModule.SetResidIcon(const Value: Integer);
begin
  if FResidIcon <> Value then
    FResidIcon := Value;
end;

procedure TAppletModule.SetResidInfo(const Value: Integer);
begin
  if FResidInfo <> Value then
  begin
    FResidInfo := Value;
    FHelp := '';
  end;
end;

procedure TAppletModule.SetResidName(const Value: Integer);
begin
  if FResidName <> Value then
  begin
    FResidName := Value;
    FCaption := '';
  end;
end;

procedure TAppletApplication.SetModuleCount(const Value: Integer);
begin
  if FModuleCount <> Value then
    FModuleCount := Value;
end;

procedure TAppletApplication.SetModules(Index: Integer;
  const Value: TAppletModule);
begin
  if FModules[Index] <> Value then
    FModules[Index] := Value;
end;

initialization
  InitApplication;

finalization
  DoneApplication;

end.
