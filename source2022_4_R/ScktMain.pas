
{*******************************************************}
{                                                       }
{       CodeGear Delphi Visual Component Library        }
{       Borland Socket Server source code               }
{                                                       }
{  	    Copyright (c) 1995-2007 CodeGear	        }
{                                                       }
{*******************************************************}

unit ScktMain;

interface

uses
  SvcMgr, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ShellAPI, ExtCtrls, StdCtrls, ComCtrls, ScktComp, Registry,
  ActnList;

const
  WM_MIDASICON    = WM_USER + 1;
  UI_INITIALIZE   = WM_MIDASICON + 1;

type

  TSocketProc = procedure(Item: TListItem; Socket: TCustomWinSocket) of Object;

  TSocketForm = class(TForm)
    PopupMenu: TPopupMenu;
    miClose: TMenuItem;
    N1: TMenuItem;
    miProperties: TMenuItem;
    UpdateTimer: TTimer;
    MainMenu1: TMainMenu;
    miPorts: TMenuItem;
    miAdd: TMenuItem;
    miRemove: TMenuItem;
    Pages: TPageControl;
    PropPage: TTabSheet;
    PortGroup: TGroupBox;
    Label1: TLabel;
    PortDesc: TLabel;
    PortNo: TEdit;
    PortUpDown: TUpDown;
    ThreadGroup: TGroupBox;
    Label4: TLabel;
    ThreadDesc: TLabel;
    ThreadSize: TEdit;
    ThreadUpDown: TUpDown;
    InterceptGroup: TGroupBox;
    Label5: TLabel;
    GUIDDesc: TLabel;
    StatPage: TTabSheet;
    ConnectionList: TListView;
    Connections1: TMenuItem;
    miShowHostName: TMenuItem;
    miDisconnect: TMenuItem;
    N2: TMenuItem;
    TimeoutGroup: TGroupBox;
    Label7: TLabel;
    Timeout: TEdit;
    TimeoutUpDown: TUpDown;
    TimeoutDesc: TLabel;
    InterceptGUID: TEdit;
    ApplyButton: TButton;
    ActionList1: TActionList;
    ApplyAction: TAction;
    DisconnectAction: TAction;
    ShowHostAction: TAction;
    RemovePortAction: TAction;
    N3: TMenuItem;
    miExit: TMenuItem;
    Panel1: TPanel;
    PortList: TListBox;
    HeaderControl1: THeaderControl;
    UserStatus: TStatusBar;
    ExportedObjectOnly1: TMenuItem;
    RegisteredAction: TAction;
    XMLPacket1: TMenuItem;
    AllowXML: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miPropertiesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miDisconnectClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure ApplyActionExecute(Sender: TObject);
    procedure ApplyActionUpdate(Sender: TObject);
    procedure DisconnectActionUpdate(Sender: TObject);
    procedure ShowHostActionExecute(Sender: TObject);
    procedure miAddClick(Sender: TObject);
    procedure RemovePortActionUpdate(Sender: TObject);
    procedure RemovePortActionExecute(Sender: TObject);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure PortListClick(Sender: TObject);
    procedure ConnectionListCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure ConnectionListColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure IntegerExit(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure RegisteredActionExecute(Sender: TObject);
    procedure AllowXMLExecute(Sender: TObject);
  private
    FTaskMessage: DWord;
    FIconData: TNotifyIconData;
    FClosing: Boolean;
    FProgmanOpen: Boolean;
    FFromService: Boolean;
    NT351: Boolean;
    FCurItem: Integer;
    FSortCol: Integer;
    procedure UpdateStatus;
    function GetSelectedSocket: TServerSocket;
    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);
    procedure CheckValues;
  protected
    procedure AddClient(Thread: TServerClientThread);
    procedure RemoveClient(Thread: TServerClientThread);
    procedure ClearModifications;
    procedure UIInitialize(var Message: TMessage); message UI_INITIALIZE;
    procedure WMMIDASIcon(var Message: TMessage); message WM_MIDASICON;
    procedure AddIcon;
    procedure ReadSettings;
    procedure WndProc(var Message: TMessage); override;
    procedure WriteSettings;
  public
    procedure Initialize(FromService: Boolean);
    property SelectedSocket: TServerSocket read GetSelectedSocket;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
  end;

  TSocketService = class(TService)
  protected
    procedure Start(Sender: TService; var Started: Boolean);
    procedure Stop(Sender: TService; var Stopped: Boolean);
  public
    function GetServiceController: TServiceController; override;
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  end;

var
  SocketForm: TSocketForm;
  SocketService: TSocketService;

implementation

uses ScktCnst, SConnect, ActiveX, MidConst;

{$R *.dfm}

{ TSocketDispatcherThread }

type
  TSocketDispatcherThread = class(TServerClientThread, ISendDataBlock)
  private
    FRefCount: Integer;
    FInterpreter: TDataBlockInterpreter;
    FTransport: ITransport;
    FInterceptGUID: string;
    FLastActivity: TDateTime;
    FTimeout: TDateTime;
    FRegisteredOnly: Boolean;
    FAllowXML: Boolean;
  protected
    function CreateServerTransport: ITransport; virtual;
    procedure AddClient;
    procedure RemoveClient;
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { ISendDataBlock }
    function Send(const Data: IDataBlock; WaitForResult: Boolean): IDataBlock; stdcall;
  public
    constructor Create(CreateSuspended: Boolean; ASocket: TServerClientWinSocket;
      const InterceptGUID: string; Timeout: Integer; RegisteredOnly, AllowXML: Boolean);
    procedure ClientExecute; override;
    property LastActivity: TDateTime read FLastActivity;
  end;

constructor TSocketDispatcherThread.Create(CreateSuspended: Boolean;
  ASocket: TServerClientWinSocket; const InterceptGUID: string; Timeout: Integer;
  RegisteredOnly, AllowXML: Boolean);
begin
  FInterceptGUID := InterceptGUID;
  FTimeout := EncodeTime(Timeout div 60, Timeout mod 60, 0, 0);
  FLastActivity := Now;
  FRegisteredOnly := RegisteredOnly;
  FAllowXML := AllowXML;
  inherited Create(CreateSuspended, ASocket);
end;

function TSocketDispatcherThread.CreateServerTransport: ITransport;
var
  SocketTransport: TSocketTransport;
begin
  SocketTransport := TSocketTransport.Create;
  SocketTransport.Socket := ClientSocket;
  SocketTransport.InterceptGUID := FInterceptGUID;
  Result := SocketTransport as ITransport;
end;

procedure TSocketDispatcherThread.AddClient;
begin
  SocketForm.AddClient(Self);
end;

procedure TSocketDispatcherThread.RemoveClient;
begin
  SocketForm.RemoveClient(Self);
end;

{ TSocketDispatcherThread.IUnknown }

function TSocketDispatcherThread.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then Result := 0 else Result := E_NOINTERFACE;
end;

function TSocketDispatcherThread._AddRef: Integer;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TSocketDispatcherThread._Release: Integer;
begin
  Dec(FRefCount);
  Result := FRefCount;
end;

{ TSocketDispatcherThread.ISendDataBlock }

function TSocketDispatcherThread.Send(const Data: IDataBlock; WaitForResult: Boolean): IDataBlock;
begin
  FTransport.Send(Data);
  if WaitForResult then
    while True do
    begin
      Result := FTransport.Receive(True, 0);
      if Result = nil then break;
      if (Result.Signature and ResultSig) = ResultSig then
        break else
        FInterpreter.InterpretData(Result);
    end;
end;

procedure TSocketDispatcherThread.ClientExecute;
var
  Data: IDataBlock;
  msg: TMsg;
  Obj: ISendDataBlock;
  Event: THandle;
  WaitTime: DWord;
begin
  CoInitialize(nil);
  try
    Synchronize(AddClient);
    FTransport := CreateServerTransport;
    try
      Event := FTransport.GetWaitEvent;
      PeekMessage(msg, 0, WM_USER, WM_USER, PM_NOREMOVE);
      GetInterface(ISendDataBlock, Obj);
      if FRegisteredOnly then
        FInterpreter := TDataBlockInterpreter.Create(Obj, SSockets) else 
        FInterpreter := TDataBlockInterpreter.Create(Obj, '');
      try
        Obj := nil;
        if FTimeout = 0 then
          WaitTime := INFINITE else
          WaitTime := 60000;
        while not Terminated and FTransport.Connected do
        try
          case MsgWaitForMultipleObjects(1, Event, False, WaitTime, QS_ALLEVENTS) of
            WAIT_OBJECT_0:
            begin
              WSAResetEvent(Event);
              Data := FTransport.Receive(False, 0);
              if Assigned(Data) then
              begin
                FLastActivity := Now;
                FInterpreter.InterpretData(Data);
                Data := nil;
                FLastActivity := Now;
              end;
            end;
            WAIT_OBJECT_0 + 1:
              while PeekMessage(msg, 0, 0, 0, PM_REMOVE) do
                DispatchMessage(msg);
            WAIT_TIMEOUT:
              if (FTimeout > 0) and ((Now - FLastActivity) > FTimeout) then
                FTransport.Connected := False;
          end;
        except
          FTransport.Connected := False;
        end;
      finally
        FInterpreter.Free;
        FInterpreter := nil;
      end;
    finally
      FTransport := nil;
    end;
  finally
    CoUninitialize;
    Synchronize(RemoveClient);
  end;
end;

{ TSocketDispatcher }

type
  TSocketDispatcher = class(TServerSocket)
  private
    FInterceptGUID: string;
    FTimeout: Integer;
    procedure GetThread(Sender: TObject; ClientSocket: TServerClientWinSocket;
      var SocketThread: TServerClientThread);
  public
    constructor Create(AOwner: TComponent); override;
    procedure ReadSettings(PortNo: Integer; Reg: TRegINIFile);
    procedure WriteSettings(Reg: TRegINIFile);
    property InterceptGUID: string read FInterceptGUID write FInterceptGUID;
    property Timeout: Integer read FTimeout write FTimeout;
  end;

constructor TSocketDispatcher.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ServerType := stThreadBlocking;
  OnGetThread := GetThread;
end;

procedure TSocketDispatcher.GetThread(Sender: TObject; ClientSocket: TServerClientWinSocket;
  var SocketThread: TServerClientThread);
begin
  try
    SocketThread := TSocketDispatcherThread.Create(False, ClientSocket,
      InterceptGUID, Timeout, SocketForm.RegisteredAction.Checked, SocketForm.AllowXML.Checked);
  except
    Abort;
  end;
end;

procedure TSocketDispatcher.ReadSettings(PortNo: Integer; Reg: TRegINIFile);
var
  Section: string;
begin
  if PortNo = -1 then
  begin
    Section := csSettings;
    Port := Reg.ReadInteger(Section, ckPort, 211);
  end else
  begin
    Section := IntToStr(PortNo);
    Port := PortNo;
  end;
  ThreadCacheSize := Reg.ReadInteger(Section, ckThreadCacheSize, 10);
  FInterceptGUID := Reg.ReadString(Section, ckInterceptGUID, '');
  FTimeout := Reg.ReadInteger(Section, ckTimeout, 0);
end;

procedure TSocketDispatcher.WriteSettings(Reg: TRegINIFile);
var
  Section: string;
begin
  Section := IntToStr(Port);
  Reg.WriteInteger(Section, ckPort, Port);
  Reg.WriteInteger(Section, ckThreadCacheSize, ThreadCacheSize);
  Reg.WriteString(Section, ckInterceptGUID, InterceptGUID);
  Reg.WriteInteger(Section, ckTimeout, Timeout);
end;

{ TSocketService }

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  SocketService.Controller(CtrlCode);
end;

function TSocketService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

constructor TSocketService.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited CreateNew(AOwner, Dummy);
  AllowPause := False;
  Interactive := True;
  DisplayName := SApplicationName;
  Name := SServiceName;
  OnStart := Start;
  OnStop := Stop;
end;

procedure TSocketService.Start(Sender: TService; var Started: Boolean);
begin
  PostMessage(SocketForm.Handle, UI_INITIALIZE, 1, 0);
  Started := True;
end;

procedure TSocketService.Stop(Sender: TService; var Stopped: Boolean);
begin
  PostMessage(SocketForm.Handle, WM_QUIT, 0, 0);
  Stopped := True;
end;

{ TSocketForm }

procedure TSocketForm.FormCreate(Sender: TObject);
begin
  if not LoadWinSock2 then
    raise Exception.CreateRes(@SNoWinSock2);
  FClosing := False;
  FCurItem := -1;
  FSortCol := -1;
end;

procedure TSocketForm.WndProc(var Message: TMessage);
begin
  if Message.Msg = FTaskMessage then
  begin
    AddIcon;
    Refresh;
  end;
  inherited WndProc(Message);
end;

procedure TSocketForm.UpdateTimerTimer(Sender: TObject);
var
  Found: Boolean;
begin
  Found := FindWindow('Progman', nil) <> 0;
  if Found <> FProgmanOpen then
  begin
    FProgmanOpen := Found;
    if Found then AddIcon;
    Refresh;
  end;
end;

procedure TSocketForm.CheckValues;
begin
  StrToInt(PortNo.Text);
  StrToInt(ThreadSize.Text);
  StrToInt(Timeout.Text);
end;

function TSocketForm.GetItemIndex: Integer;
begin
  Result := FCurItem;
end;

procedure TSocketForm.SetItemIndex(Value: Integer);
var
  Selected: Boolean;
begin
  if (FCurItem <> Value) then
  try
    if ApplyAction.Enabled then ApplyAction.Execute;
  except
    PortList.ItemIndex := FCurItem;
    raise;
  end else
    Exit;
  if Value = -1 then Value := 0;
  PortList.ItemIndex := Value;
  FCurItem := PortList.ItemIndex;
  Selected := FCurItem <> -1;
  if Selected then
    with TSocketDispatcher(PortList.Items.Objects[FCurItem]) do
    begin
      PortUpDown.Position := Port;
      ThreadUpDown.Position := ThreadCacheSize;
      Self.InterceptGUID.Text := FInterceptGUID;
      TimeoutUpDown.Position := Timeout;
      ClearModifications;
    end;
  PortNo.Enabled := Selected;
  ThreadSize.Enabled := Selected;
  Timeout.Enabled := Selected;
  InterceptGUID.Enabled := Selected;
end;

function TSocketForm.GetSelectedSocket: TServerSocket;
begin
  Result := TServerSocket(PortList.Items.Objects[ItemIndex]);
end;

procedure TSocketForm.UIInitialize(var Message: TMessage);
begin
  Initialize(Message.WParam <> 0);
end;

procedure TSocketForm.Initialize(FromService: Boolean);

  function IE4Installed: Boolean;
  var
    RegKey: HKEY;
  begin
    Result := False;
    if RegOpenKey(HKEY_LOCAL_MACHINE, KEY_IE, RegKey) = ERROR_SUCCESS then
    try
      Result := RegQueryValueEx(RegKey, 'Version', nil, nil, nil, nil) = ERROR_SUCCESS;
    finally
      RegCloseKey(RegKey);
    end;
  end;

begin
  FFromService := FromService;
  NT351 := (Win32MajorVersion <= 3) and (Win32Platform = VER_PLATFORM_WIN32_NT);
  if NT351 then
  begin
    if not FromService then
      raise Exception.CreateRes(@SServiceOnly);
    BorderIcons := BorderIcons + [biMinimize];
    BorderStyle := bsSingle;
  end;
  ReadSettings;
  if FromService then
  begin
    miClose.Visible := False;
    N1.Visible := False;
  end;
  UpdateStatus;
  AddIcon;
  if IE4Installed then
    FTaskMessage := RegisterWindowMessage('TaskbarCreated') else
    UpdateTimer.Enabled := True;
end;

procedure TSocketForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  TimerEnabled: Boolean;
begin
  TimerEnabled := UpdateTimer.Enabled;
  UpdateTimer.Enabled := False;
  try
    CanClose := False;
    if ApplyAction.Enabled then ApplyAction.Execute;
    if FClosing and (not FFromService) and (ConnectionList.Items.Count > 0) then
    begin
      FClosing := False;
      if MessageDlg(SErrClose, mtConfirmation, [mbYes, mbNo], 0) <> idYes then
        Exit;
    end;
    WriteSettings;
    CanClose := True;
  finally
    if TimerEnabled and (not CanClose) then
      UpdateTimer.Enabled := True;
  end;
end;

procedure TSocketForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  UpdateTimer.Enabled := False;
  if not NT351 then
    Shell_NotifyIcon(NIM_DELETE, @FIconData);
  for i := 0 to PortList.Items.Count - 1 do
    PortList.Items.Objects[i].Free;
end;

procedure TSocketForm.AddIcon;
begin
  if not NT351 then
  begin
    with FIconData do
    begin
      cbSize := SizeOf(FIconData);
      Wnd := Self.Handle;
      uID := $DEDB;
      uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
      hIcon := Forms.Application.Icon.Handle;
      uCallbackMessage := WM_MIDASICON;
      StrCopy(szTip, PChar(Caption));
    end;
    Shell_NotifyIcon(NIM_Add, @FIconData);
  end;
end;

procedure TSocketForm.ReadSettings;
var
  Reg: TRegINIFile;

  procedure CreateItem(ID: Integer);
  var
    SH: TSocketDispatcher;
  begin
    SH := TSocketDispatcher.Create(nil);
    SH.ReadSettings(ID, Reg);
    PortList.Items.AddObject(IntToStr(SH.Port), SH);
    try
      SH.Open;
    except
      on E: Exception do
        raise Exception.CreateResFmt(@SOpenError, [SH.Port, E.Message]);
    end;
  end;

var
  Sections: TStringList;
  i: Integer;
begin
  Reg := TRegINIFile.Create('');
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(KEY_SOCKETSERVER, True);
    Sections := TStringList.Create;
    try
      Reg.ReadSections(Sections);
      if Sections.Count > 1 then
      begin
        for i := 0 to Sections.Count - 1 do
          if CompareText(Sections[i], csSettings) <> 0 then
            CreateItem(StrToInt(Sections[i]));
      end else
        CreateItem(-1);
      ItemIndex := 0;
      ShowHostAction.Checked := Reg.ReadBool(csSettings, ckShowHost, False);
      RegisteredAction.Checked := Reg.ReadBool(csSettings, ckRegistered, True);
    finally
      Sections.Free;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TSocketForm.WriteSettings;
var
  Reg: TRegINIFile;
  Sections: TStringList;
  i: Integer;
begin
  Reg := TRegINIFile.Create('');
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(KEY_SOCKETSERVER, True);
    Sections := TStringList.Create;
    try
      Reg.ReadSections(Sections);
      for i := 0 to Sections.Count - 1 do
        TRegistry(Reg).DeleteKey(Sections[i]);
    finally
      Sections.Free;
    end;
    for i := 0 to PortList.Items.Count - 1 do
      TSocketDispatcher(PortList.Items.Objects[i]).WriteSettings(Reg);
    Reg.WriteBool(csSettings, ckShowHost, ShowHostAction.Checked);
    Reg.WriteBool(csSettings, ckRegistered, RegisteredAction.Checked);
  finally
    Reg.Free;
  end;
end;

procedure TSocketForm.miCloseClick(Sender: TObject);
begin
  FClosing := True;
  Close;
end;

procedure TSocketForm.WMMIDASIcon(var Message: TMessage);
var
  pt: TPoint;
begin
  case Message.LParam of
    WM_RBUTTONUP:
    begin
      if not Visible then
      begin
        SetForegroundWindow(Handle);
        GetCursorPos(pt);
        PopupMenu.Popup(pt.x, pt.y);
      end else
        SetForegroundWindow(Handle);
    end;
    WM_LBUTTONDBLCLK:
      if Visible then
        SetForegroundWindow(Handle) else
        miPropertiesClick(nil);
  end;
end;

procedure TSocketForm.miPropertiesClick(Sender: TObject);
begin
  ShowModal;
end;

procedure TSocketForm.FormShow(Sender: TObject);
begin
  Pages.ActivePage := Pages.Pages[0];
end;

procedure TSocketForm.UpdateStatus;
begin
  UserStatus.SimpleText := Format(SStatusLine,[ConnectionList.Items.Count]);
end;

procedure TSocketForm.AddClient(Thread: TServerClientThread);
var
  Item: TListItem;
begin
  Item := ConnectionList.Items.Add;
  Item.Caption := IntToStr(Thread.ClientSocket.LocalPort);
  Item.SubItems.Add(Thread.ClientSocket.RemoteAddress);
  if ShowHostAction.Checked then
  begin
    Item.SubItems.Add(Thread.ClientSocket.RemoteHost);
    if Item.SubItems[1] = '' then Item.SubItems[1] := SHostUnknown;
  end else
    Item.SubItems.Add(SNotShown);
  if Thread is TSocketDispatcherThread then
    Item.SubItems.Add(DateTimeToStr(TSocketDispatcherThread(Thread).LastActivity));
  Item.Data := Pointer(Thread);
  UpdateStatus;
end;

procedure TSocketForm.RemoveClient(Thread: TServerClientThread);
var
  Item: TListItem;
begin
  Item := ConnectionList.FindData(0, Thread, True, False);
  if Assigned(Item) then Item.Free;
  UpdateStatus;
end;

procedure TSocketForm.miDisconnectClick(Sender: TObject);
var
  i: Integer;
begin
  if MessageDlg(SQueryDisconnect, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;
  with SelectedSocket.Socket do
  begin
    Lock;
    try
      for i := 0 to ConnectionList.Items.Count - 1 do
        with ConnectionList.Items[i] do
          if Selected then
            TServerClientThread(Data).ClientSocket.Close;
    finally
      Unlock;
    end;
  end;
end;

procedure TSocketForm.miExitClick(Sender: TObject);
begin
  CheckValues;
  ModalResult := mrOK;
end;

procedure TSocketForm.ApplyActionExecute(Sender: TObject);
begin
  with TSocketDispatcher(SelectedSocket) do
  begin
    if Socket.ActiveConnections > 0 then
      if MessageDlg(SErrChangeSettings, mtConfirmation, [mbYes, mbNo], 0) = idNo then
        Exit;
    Close;
    Port := StrToInt(PortNo.Text);
    PortList.Items[ItemIndex] := PortNo.Text;
    ThreadCacheSize := StrToInt(ThreadSize.Text);
    InterceptGUID := Self.InterceptGUID.Text;
    Timeout := StrToInt(Self.Timeout.Text);
    Open;
  end;
  ClearModifications;
end;

procedure TSocketForm.ApplyActionUpdate(Sender: TObject);
begin
  ApplyAction.Enabled := PortNo.Modified or ThreadSize.Modified or
    Timeout.Modified or InterceptGUID.Modified;
end;

procedure TSocketForm.ClearModifications;
begin
  PortNo.Modified  := False;
  ThreadSize.Modified := False;
  Timeout.Modified := False;
  InterceptGUID.Modified := False;
end;

procedure TSocketForm.DisconnectActionUpdate(Sender: TObject);
begin
  DisconnectAction.Enabled := ConnectionList.SelCount > 0;
end;

procedure TSocketForm.ShowHostActionExecute(Sender: TObject);
var
  i: Integer;
  Item: TListItem;
begin
  ShowHostAction.Checked := not ShowHostAction.Checked;
  ConnectionList.Items.BeginUpdate;
  try
    for i := 0 to ConnectionList.Items.Count - 1 do
    begin
      Item := ConnectionList.Items[i];
      if ShowHostAction.Checked then
      begin
        Item.SubItems[1] := TServerClientThread(Item.Data).ClientSocket.RemoteHost;
        if Item.SubItems[1] = '' then Item.SubItems[1] := SHostUnknown;
      end else
        Item.SubItems[1] := SNotShown;
    end;
  finally
    ConnectionList.Items.EndUpdate;
  end;
end;

procedure TSocketForm.miAddClick(Sender: TObject);
var
  SD: TSocketDispatcher;
  Idx: Integer;
begin
  CheckValues;
  SD := TSocketDispatcher.Create(nil);
  SD.Port := PortUpDown.Position + 1;
  PortUpDown.Position := SD.Port;
  Idx := PortList.Items.AddObject(PortNo.Text,SD);
  PortNo.Modified := True;
  ItemIndex := Idx;
  Pages.ActivePage := Pages.Pages[0];
  PortNo.SetFocus;
end;

procedure TSocketForm.RemovePortActionUpdate(Sender: TObject);
begin
  RemovePortAction.Enabled := (PortList.Items.Count > 1) and (ItemIndex <> -1);
end;

procedure TSocketForm.RemovePortActionExecute(Sender: TObject);
begin
  CheckValues;
  PortList.Items.Objects[ItemIndex].Free;
  PortList.Items.Delete(ItemIndex);
  FCurItem := -1;
  ItemIndex := 0;
end;

procedure TSocketForm.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  ((Sender as TUpDown).Associate as TEdit).Modified := True;
end;

procedure TSocketForm.PortListClick(Sender: TObject);
begin
  ItemIndex := PortList.ItemIndex;
end;

procedure TSocketForm.ConnectionListCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if Data = -1 then
    Compare := AnsiCompareText(Item1.Caption, Item2.Caption) else
    Compare := AnsiCompareText(Item1.SubItems[Data], Item2.SubItems[Data]);
end;

procedure TSocketForm.ConnectionListColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  FSortCol := Column.Index - 1;
  ConnectionList.CustomSort(nil, FSortCol);
end;

procedure TSocketForm.IntegerExit(Sender: TObject);
begin
  try
    StrToInt(PortNo.Text);
  except
    ActiveControl := PortNo;
    raise;
  end;
end;

procedure TSocketForm.RegisteredActionExecute(Sender: TObject);
begin
  RegisteredAction.Checked := not RegisteredAction.Checked;
  ShowMessage(SNotUntilRestart);
end;

procedure TSocketForm.AllowXMLExecute(Sender: TObject);
begin
  AllowXML.Checked := not AllowXML.Checked;
end;

end.
