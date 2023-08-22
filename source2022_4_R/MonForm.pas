unit MonForm;

{ Interprocess Communication Demo

  This program along with the Client.dpr project, demonstrate a number
  of topics in Win32 programming. Threads, Events, Mutexes, and Shared
  memory are all used to provide communication between this monitor and
  it's clients, see IPCThrd.pas.

  To Run, compile this project and the Client.dpr project.  Run one
  instance of the monitor and then run several instances of the client.
  You can switch between clients by clicking on the Client's window or
  by selecting it from the Client menu in the monitor.

  Topics Covered:
  
    Interprocess Communication
    Threads
    Events
    Mutexes
    Shared Memory
    Single instance EXE.

}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Typinfo, IPCThrd, Buttons, ComCtrls, ExtCtrls, Menus;

const
  WM_SETTRACEDATA = WM_USER + 1;
  WM_UPDATESTATUS = WM_USER + 2;
  WM_UPDATEMENU   = WM_USER + 3;

type
  TWMTraceData = record
    Msg: Cardinal;
    X: Smallint;
    Y: Smallint;
    Flag: TClientFlag;
    Result: Longint;
  end;

  TLabelRec = record
    XLabel: TLabel;
    YLabel: TLabel;
  end;

  TMonitorForm = class(TForm)
    DownX: TLabel;
    DownY: TLabel;
    SizeX: TLabel;
    SizeY: TLabel;
    MoveX: TLabel;
    MoveY: TLabel;
    Bevel1: TBevel;
    Panel1: TPanel;
    PauseButton: TSpeedButton;
    StatusBar: TStatusBar;
    MouseMove: TCheckBox;
    MouseDown: TCheckBox;
    WindowSize: TCheckBox;
    MainMenu: TMainMenu;
    Options1: TMenuItem;
    AutoClientSwitch1: TMenuItem;
    PlaceHolder21: TMenuItem;
    File1: TMenuItem;
    miFileExit: TMenuItem;
    miClients: TMenuItem;
    PlaceHolder1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ShowTraceButton: TSpeedButton;
    ClearButton: TSpeedButton;
    ExitButton: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClientMenuClick(Sender: TObject);
    procedure miClientsClick(Sender: TObject);
    procedure SetTraceFlags(Sender: TObject);
    procedure AutoClientSwitch1Click(Sender: TObject);
    procedure miFileExitClick(Sender: TObject);
    procedure ShowTraceButtonClick(Sender: TObject);
    procedure PauseButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    FTraceMsg: TWMTraceData;
    IPCMonitor: TIPCMonitor;
    TraceLabels: array[TClientFlag] of TLabelRec;
    FClientData: TEventData;
    FStatusText: string;
    procedure ClearLabels;
    procedure OnConnect(Sender: TIPCThread; Connecting: Boolean);
    procedure OnDirectoryUpdate(Sender: TIPCThread);
    procedure OnSignal(Sender: TIPCThread; Data: TEventData);
    procedure SignalClientStatus;
    procedure UpdateTraceData(var Msg: TWMTraceData); message WM_SETTRACEDATA;
    procedure UpdateStatusBar(var Msg: TMessage); message WM_UPDATESTATUS;
    procedure UpdateClientMenu(var Msg: TMessage); message WM_UPDATEMENU;
  end;


var
  MonitorForm: TMonitorForm;

implementation

uses TrcView;

{$R *.dfm}

{ Private Routines }

procedure TMonitorForm.ClearLabels;
var
  Index: TClientFlag;
begin
  for Index := Low(TClientFlag) to High(TClientFlag) do
  begin
    TraceLabels[Index].YLabel.Caption := '0';
    TraceLabels[Index].XLabel.Caption := '0';
  end;
end;

procedure TMonitorForm.OnConnect(Sender: TIPCThread; Connecting: Boolean);
begin
  if Connecting then
  begin
    FStatusText := IPCMonitor.ClientName;
    SignalClientStatus;
  end
  else
    FStatusText := 'No Client';
  PostMessage(Handle, WM_UPDATESTATUS, 0, 0);
end;

{ When a client starts or stops we need to update the client menu.
  We do this by posting a message to the Monitor Form, which in turn causes
  the UpdateClientMenu method to be invoked.  We use this approach, rather than
  calling UpdateClientMenu directly because this code is not being executed
  by the main thread, but rather by the thread used in the TMonitorThread
  class.  We could also have used the TThread.Synchonize method, but since
  there is no need for the IPC thread to wait for the monitor to update
  the menu, this approach is more effecient. }

procedure TMonitorForm.OnDirectoryUpdate(Sender: TIPCThread);
begin
  PostMessage(Handle, WM_UPDATEMENU, 0, 0);
end;

{ This event is triggered when the client has new data for us.  As with
  the OnDirectoryUpdate event above, we use PostMessage to get the main
  thread to update the display. }

procedure TMonitorForm.OnSignal(Sender: TIPCThread; Data: TEventData);
begin
  FTraceMsg.X := Data.X;
  FTraceMsg.Y := Data.Y;
  FTraceMsg.Flag := Data.Flag;
  PostMessage(Handle, WM_SETTRACEDATA, TMessage(FTraceMsg).WPARAM,
    TMessage(FTraceMsg).LPARAM);
end;

procedure TMonitorForm.SignalClientStatus;
begin
  if PauseButton.Down then
    IPCMonitor.SignalClient([]) else
    IPCMonitor.SignalClient(FClientData.Flags);
end;

procedure TMonitorForm.UpdateTraceData(var Msg: TWMTraceData);
begin
  with Msg do
    if Flag in FClientData.Flags then
    begin
      TraceLabels[Flag].XLabel.Caption := IntToStr(X);
      TraceLabels[Flag].YLabel.Caption := IntToStr(Y);
    end
end;

procedure TMonitorForm.UpdateStatusBar(var Msg: TMessage);
begin
  StatusBar.SimpleText := FStatusText;
  ClearLabels;
end;

procedure TMonitorForm.UpdateClientMenu(var Msg: TMessage);
var
  I, ID: Integer;
  List: TStringList;
  mi: TMenuItem;
begin
  List := TStringList.Create;
  try
    IPCMonitor.GetClientNames(List);
    while miClients.Count > 0 do miClients.Delete(0);
    if List.Count < 1 then
      miClients.Add(NewItem('(None)', 0, False, False, nil, 0, ''))
    else
      for I := 0 to List.Count - 1 do
      begin
        ID := Integer(List.Objects[I]);
        mi := NewItem(List[I], 0, False, True, ClientMenuClick, 0, '');
        mi.Tag := ID;
        mi.RadioItem := True;
        mi.GroupIndex := 1;
        miClients.Add(MI);
      end;
  finally
    List.Free;
  end;
end;

{ Event Handlers }

procedure TMonitorForm.FormCreate(Sender: TObject);

  procedure SetupLabelArray;
  begin
    TraceLabels[cfMouseMove].XLabel := MoveX;
    TraceLabels[cfMouseMove].YLabel := MoveY;
    TraceLabels[cfMouseDown].XLabel := DownX;
    TraceLabels[cfMouseDown].YLabel := DownY;
    TraceLabels[cfResize].XLabel := SizeX;
    TraceLabels[cfResize].YLabel := SizeY;
  end;

begin
  IPCMonitor := TIPCMonitor.Create(Application.Handle, 'Monitor');
  IPCMonitor.OnSignal := OnSignal;
  IPCMonitor.OnConnect := OnConnect;
  IPCMonitor.OnDirectoryUpdate := OnDirectoryUpdate;
  IPCMonitor.Activate;
  OnDirectoryUpdate(nil);
  OnConnect(nil, False);
  FClientData.Flags := [cfMouseMove, cfMouseDown, cfReSize];
  SetupLabelArray;
end;

procedure TMonitorForm.FormDestroy(Sender: TObject);
begin
  IPCMonitor.Free;
end;

procedure TMonitorForm.ClientMenuClick(Sender: TObject);
var
  NewID: Integer;
begin
  NewID := (Sender as TMenuItem).Tag;
  if NewID <> IPCMonitor.ClientID then
    IPCMonitor.ClientID := NewID;
end;

procedure TMonitorForm.miClientsClick(Sender: TObject);
var
  I: Integer;
begin
  if IPCMonitor.ClientID <> 0 then
    for I := 0 to miClients.Count - 1 do
      with miClients.Items[I] do
        if Tag = IPCMonitor.ClientID then
        begin
          Checked := True;
          System.Break;
        end;
end;

procedure TMonitorForm.SetTraceFlags(Sender: TObject);
var
  F: TClientFlag;
begin
  with (Sender as TCheckBox) do
  begin
    F := TClientFlag(Tag);
    if Checked then
      Include(FClientData.Flags, F) else
      Exclude(FClientData.Flags, F);
  end;
  SignalClientStatus;
end;

procedure TMonitorForm.AutoClientSwitch1Click(Sender: TObject);
begin
  with (Sender as TMenuItem) do
  begin
    Checked := not Checked;
    IPCMonitor.AutoSwitch := Checked;
  end;
end;

procedure TMonitorForm.miFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMonitorForm.ShowTraceButtonClick(Sender: TObject);
begin
  IPCMonitor.GetDebugInfo(TraceForm.TraceData.Items);
  TraceForm.ShowModal;
end;

procedure TMonitorForm.PauseButtonClick(Sender: TObject);
begin
  SignalClientStatus;
end;

procedure TMonitorForm.ClearButtonClick(Sender: TObject);
begin
  IPCMonitor.ClearDebugInfo;
end;

procedure TMonitorForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMonitorForm.About1Click(Sender: TObject);
begin
  //ShowAboutBox;
end;

end.
