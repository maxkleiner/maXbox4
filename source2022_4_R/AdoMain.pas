unit AdoMain;

{ Test program for ADO Components in mX4}
//inbuild of mX 3.9.9.18
//add test code of OLE DB  , locs=2533    - caption and closed

interface

uses
  Variants, Windows, Sysutils, Forms, IniFiles, ImgList, Controls, Classes,
  ActnList, Menus, Dialogs, ComCtrls, ComObj, ToolWin, DB, ADOInt,
  Grids, DBGrids, Provider, ADODB, DBClient, DBCtrls, ExtCtrls,
  StdCtrls, Buttons, SqlEdit;

type
  TADODBTest = class(TForm)
    Connection: TADOConnection;
    MasterTable: TADOTable;
    DetailTable: TADOTable;
    MasterQuery: TADOQuery;
    DetailQuery: TADOQuery;
    MasterProc: TADOStoredProc;
    ADODataSet: TADODataSet;
    Provider: TDataSetProvider;
    MasterClientData: TClientDataSet;
    MasterDataSource: TDataSource;
    DetailDataSource: TDataSource;
    DetailGrid: TDBGrid;
    MasterGrid: TDBGrid;
    DBMemo1: TDBMemo;
    DBImage1: TDBImage;

    { Actions }
    ActionList1: TActionList;
    SaveToFile: TAction;
    OpenQuery: TAction;
    OpenTable: TAction;
    BatchUpdate: TAction;
    ExitApplication: TAction;
    CloseActiveDataSet: TAction;
    LoadFromFile: TAction;
    CancelBatch: TAction;
    ExecuteCommand: TAction;
    StreamFormOut: TAction;
    StreamFormIn: TAction;
    ClearField: TAction;
    ViewEvents: TAction;
    PrevQuery: TAction;
    NextQuery: TAction;
    RefreshData: TAction;
    ClearEventLog: TAction;
    DisplayDetails: TAction;
    HelpAbout: TAction;
    UseClientCursor: TAction;
    UseTableDirect: TAction;
    UseShapeProvider: TAction;
    AsyncConnect: TAction;
    AsyncExecute: TAction;
    AsyncFetch: TAction;
    OpenProcedure: TAction;
    MainMenu1: TMainMenu;
    FileReopen: TMenuItem;
    FileMenu: TMenuItem;
    PopupMenu1: TPopupMenu;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    StatusBar: TStatusBar;
    AreaSelector: TPageControl;
    DataPanel: TPanel;
    FilterPage: TTabSheet;
    LocatePage: TTabSheet;
    IndexPage: TTabSheet;
    FieldsPage: TTabSheet;
    SourcePage: TTabSheet;
    IndexList: TListBox;
    NavigatorPanel: TPanel;
    BlobCtrlPanel: TPanel;
    GridPanel: TPanel;
    DBNavigator1: TDBNavigator;
    Filter: TEdit;
    FindFirst: TButton;
    FindNext: TButton;
    Filtered: TCheckBox;
    IndexFields: TEdit;
    PrevQuery1: TSpeedButton;
    Events: TListBox;
    DescFields: TEdit;
    CaseInsFields: TEdit;
    MasterTableName: TComboBox;
    DetailTableName: TComboBox;
    MasterSQL: TMemo;
    DetailSQL: TMemo;
    GridSplitter: TSplitter;
    ClearEventsButton: TToolButton;
    LocateEdit: TEdit;
    LocateField: TComboBox;
    locPartialKey: TCheckBox;
    LocateNull: TCheckBox;
    UseClientCursorItem: TMenuItem;
    UseadCmdTableDirect1: TMenuItem;
    CursorTypeItem: TMenuItem;
    CurTypeKeyset: TMenuItem;
    Dynamic1: TMenuItem;
    CurTypeUnspecified: TMenuItem;
    CurTypeForwardOnly: TMenuItem;
    CurTypeStatic: TMenuItem;
    DBEditScroller: TScrollBox;
    LockTypeItem: TMenuItem;
    LckTypeUnspecified: TMenuItem;
    LckTypeReadOnly: TMenuItem;
    LckTypePessimistic: TMenuItem;
    LckTypeOptimistic: TMenuItem;
    LckTypeBatchOptimistic: TMenuItem;
    ReadOnlyLabel: TLabel;
    ConnectionString: TComboBox;
    EditConnStr: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    ProcedureNames: TGroupBox;
    TableNames: TGroupBox;
    QueryStrings: TGroupBox;
    MasterProcName: TComboBox;
    Splitter1: TSplitter;
    DetailMasterSource: TDataSource;
    DetailQuerySource: TDataSource;
    CloseConnection: TAction;
    Disconnect1: TMenuItem;
    BatchUpdates1: TMenuItem;
    CancelBatch1: TMenuItem;
    BatchUpdateButton: TToolButton;
    CancelBatchButton: TToolButton;
    AsyncConnect1: TMenuItem;
    AsyncExecute1: TMenuItem;
    AsyncFetch1: TMenuItem;
    ADOCommand: TADOCommand;
    ProgressBar: TProgressBar;
    MaxRecords: TAction;
    MaxRecords1: TMenuItem;
    DetailProcName: TComboBox;
    DetailProc: TADOStoredProc;
    ToolButton1: TToolButton;
    OpenProcedure1: TMenuItem;
    DetailProcSource: TDataSource;
    EditCommandText: TSpeedButton;
    ParamPage: TTabSheet;
    ParameterList: TListBox;
    ParameterName: TEdit;
    ParameterValue: TEdit;
    ParameterSize: TEdit;
    ParameterNameLabel: TLabel;
    ParameterScale: TEdit;
    ParameterPrecision: TEdit;
    PTypeLabel: TLabel;
    PValueLabel: TLabel;
    PSizeLabel: TLabel;
    PScaleLabel: TLabel;
    PPrecisionLabel: TLabel;
    ParameterDirectionGroup: TRadioGroup;
    ParamAttributes: TGroupBox;
    PANullableCheckBox: TCheckBox;
    PASignedCheckBox: TCheckBox;
    PALongCheckBox: TCheckBox;
    AddParameterButton: TButton;
    RefreshParametersButton: TButton;
    ParameterType: TComboBox;
    ToolButton3: TToolButton;
    MidasApplyUpdatesButton: TToolButton;
    MidasApplyUpdates: TAction;
    ADOButton: TRadioButton;
    MidasButton: TRadioButton;
    MidasCancelUpdates: TAction;
    MidasCancelButton: TToolButton;
    ApplyUpdatesMidas1: TMenuItem;
    CancelUpdatesMidas1: TMenuItem;
    N6: TMenuItem;
    SQLParams: TRadioButton;
    ProcParams: TRadioButton;
    TestButton: TButton;
    FieldSchemaGrid: TDBGrid;
    FieldSchemaSource: TDataSource;
    FieldSchema: TADODataSet;
    FieldSchemaCOLUMN_NAME: TWideStringField;
    FieldSchemaDATA_TYPE: TWordField;
    FieldSchemaNUMERIC_PRECISION: TWordField;
    FieldSchemaCHARACTER_MAXIMUM_LENGTH: TIntegerField;
    FieldSchemaNUMERIC_SCALE: TSmallintField;
    EnableBCD: TAction;
    EnableBCD1: TMenuItem;
    DisconnectDataSet: TAction;
    DisconnectDataSet1: TMenuItem;
    DetailClientData: TClientDataSet;
    FilterGroupBox: TRadioGroup;
    BlobAsImage: TAction;
    BlobfieldasImage1: TMenuItem;
    LoadBlobFromFile: TAction;
    LoadBlobfromfile1: TMenuItem;
    IndexOptions: TGroupBox;
    idxCaseInsensitive: TCheckBox;
    idxDescending: TCheckBox;
    idxPrimary: TCheckBox;
    idxUnique: TCheckBox;
    Button1: TButton;

    procedure FilterKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MasterSQLKeyPress(Sender: TObject; var Key: Char);
    procedure IndexListClick(Sender: TObject);
    procedure GridTitleClick(Column: TColumn);
    procedure LocateButtonClick(Sender: TObject);
    procedure FindFirstClick(Sender: TObject);
    procedure FilterExit(Sender: TObject);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure DataSetAfterOpen(DataSet: TDataSet);
    procedure LocateFieldDropDown(Sender: TObject);
    procedure FindNextClick(Sender: TObject);
    procedure MasterTableNameClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FieldSelect(Sender: TObject);
    procedure GridColEnter(Sender: TObject);
    procedure StreamFormOutClick(Sender: TObject);
    procedure StreamFormInClick(Sender: TObject);
    procedure LoadFromFileExecute(Sender: TObject);
    procedure SaveToFileExecute(Sender: TObject);
    procedure EditActionsUpdate(Sender: TObject);
    procedure FieldsPageShow(Sender: TObject);
    procedure OpenQueryExecute(Sender: TObject);
    procedure ExecSQLExecute(Sender: TObject);
    procedure OpenTableExecute(Sender: TObject);
    procedure BatchUpdateExecute(Sender: TObject);
    procedure MasterTableNameDropDown(Sender: TObject);
    procedure ConnectionStringClick(Sender: TObject);
    procedure ConnectionStringKeyPress(Sender: TObject; var Key: Char);
    procedure FilteredClick(Sender: TObject);
    procedure FilterPageShow(Sender: TObject);
    procedure IndexPageShow(Sender: TObject);
    procedure ExitApplicationExecute(Sender: TObject);
    procedure CloseActiveDataSetExecute(Sender: TObject);
    procedure FileActionsUpdate(Sender: TObject);
    procedure MasterTableNameKeyPress(Sender: TObject; var Key: Char);
    procedure DetailTableNameClick(Sender: TObject);
    procedure MasterTableAfterOpen(DataSet: TDataSet);
    procedure MasterTableBeforeClose(DataSet: TDataSet);
    procedure GridSetFocus(Sender: TObject);
    procedure LocatePageShow(Sender: TObject);
    procedure LocateNullClick(Sender: TObject);
    procedure DataSetAfterScroll(DataSet: TDataSet);
    procedure DataSetBeforeCancel(DataSet: TDataSet);
    procedure DataSetBeforeClose(DataSet: TDataSet);
    procedure DataSetBeforeDelete(DataSet: TDataSet);
    procedure DataSetBeforeEdit(DataSet: TDataSet);
    procedure DataSetBeforeInsert(DataSet: TDataSet);
    procedure DataSetBeforePost(DataSet: TDataSet);
    procedure DataSetBeforeScroll(DataSet: TDataSet);
    procedure DataSetCalcFields(DataSet: TDataSet);
    procedure DataSetError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure DataSetNewRecord(DataSet: TDataSet);
    procedure DataSetAfterPost(DataSet: TDataSet);
    procedure DataSetAfterInsert(DataSet: TDataSet);
    procedure DataSetAfterEdit(DataSet: TDataSet);
    procedure DataSetAfterDelete(DataSet: TDataSet);
    procedure DataSetAfterCancel(DataSet: TDataSet);
    procedure MasterQueryAfterOpen(DataSet: TDataSet);
    procedure MasterQueryBeforeClose(DataSet: TDataSet);
    procedure CancelBatchExecute(Sender: TObject);
    procedure ClearFieldExecute(Sender: TObject);
    procedure ViewEventsExecute(Sender: TObject);
    procedure DisplayDetailsExecute(Sender: TObject);
    procedure DataSourceStateChange(Sender: TObject);
    procedure DataSourceUpdateData(Sender: TObject);
    procedure RefreshDataExecute(Sender: TObject);
    procedure ClearEventLogExecute(Sender: TObject);
    procedure ClearEventLogUpdate(Sender: TObject);
    procedure HelpAboutExecute(Sender: TObject);
    procedure DataSetAfterClose(DataSet: TDataSet);
    procedure FileMenuClick(Sender: TObject);
    procedure ClosedFileClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PrevQueryExecute(Sender: TObject);
    procedure PrevQueryUpdate(Sender: TObject);
    procedure NextQueryExecute(Sender: TObject);
    procedure MasterTableAfterScroll(DataSet: TDataSet);
    procedure MasterTableBeforeScroll(DataSet: TDataSet);
    procedure RadioItemClick(Sender: TObject);
    procedure DataSetBeforeOpen(DataSet: TDataSet);
    procedure BooleanActionExecute(Sender: TObject);
    procedure EditConnStrClick(Sender: TObject);
    procedure MasterTableBeforeOpen(DataSet: TDataSet);
    procedure DetailTableBeforeOpen(DataSet: TDataSet);
    procedure MasterQueryBeforeOpen(DataSet: TDataSet);
    procedure DetailQueryBeforeOpen(DataSet: TDataSet);
    procedure MasterProcBeforeOpen(DataSet: TDataSet);
    procedure UseShapeProviderExecute(Sender: TObject);
    procedure OnFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure BinaryGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure BinarySetText(Sender: TField; const Text: string);
    procedure ConnectionBeginTransComplete(Connection: TADOConnection;
      TransactionLevel: Integer; const Error: Error;
      var EventStatus: TEventStatus);
    procedure ConnectionCommitTransComplete(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure ConnectionConnectComplete(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure ConnectionDisconnect(Connection: TADOConnection;
      var EventStatus: TEventStatus);
    procedure ConnectionExecuteComplete(Connection: TADOConnection;
      RecordsAffected: Integer; const Error: Error;
      var EventStatus: TEventStatus; const Command: _Command;
      const Recordset: _Recordset);
    procedure ConnectionInfoMessage(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure ConnectionRollbackTransComplete(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure ConnectionWillConnect(Connection: TADOConnection;
      var ConnectionString, UserID, Password: WideString;
      var ConnectOptions: TConnectOption; var EventStatus: TEventStatus);
    procedure ConnectionWillExecute(Connection: TADOConnection;
      var CommandText: WideString; var CursorType: TCursorType;
      var LockType: TADOLockType; var CommandType: TCommandType;
      var ExecuteOptions: TExecuteOptions; var EventStatus: TEventStatus;
      const Command: _Command; const Recordset: _Recordset);
    procedure CloseConnectionExecute(Sender: TObject);
    procedure DataSetFetchComplete(DataSet: TCustomADODataSet;
      const Error: Error; var EventStatus: TEventStatus);
    procedure ExceptionHandler(Sender: TObject; E: Exception);
    procedure ConnectionLogin(Sender: TObject; Username, Password: String);
    procedure MasterGridColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure MaxRecordsExecute(Sender: TObject);
    procedure ProcNameDropDown(Sender: TObject);
    procedure MasterProcNameKeyPress(Sender: TObject; var Key: Char);
    procedure MasterProcNameClick(Sender: TObject);
    procedure DetailProcNameClick(Sender: TObject);
    procedure OpenProcedureExecute(Sender: TObject);
    procedure DetailProcBeforeOpen(DataSet: TDataSet);
    procedure MasterProcAfterOpen(DataSet: TDataSet);
    procedure EditCommandTextClick(Sender: TObject);
    procedure ParamPageShow(Sender: TObject);
    procedure RefreshParametersButtonClick(Sender: TObject);
    procedure ParameterListClick(Sender: TObject);
    procedure AddParameterButtonClick(Sender: TObject);
    procedure ParameterDataChange(Sender: TObject);
    procedure MasterSQLChange(Sender: TObject);
    procedure MidasApplyUpdatesExecute(Sender: TObject);
    procedure ADOButtonClick(Sender: TObject);
    procedure MidasButtonClick(Sender: TObject);
    procedure MasterClientDataReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure MidasCancelUpdatesExecute(Sender: TObject);
    procedure ParameterSourceClick(Sender: TObject);
    procedure FieldSchemaDATA_TYPEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure DisconnectDataSetExecute(Sender: TObject);
    procedure FieldValidate(Sender: TField);
    procedure TestButtonClick2(Sender: TObject);
    procedure DataSetFetchProgress(DataSet: TCustomADODataSet; Progress,
      MaxProgress: Integer; var EventStatus: TEventStatus);
    procedure FilterGroupBoxClick(Sender: TObject);
    procedure BlobAsImageUpdate(Sender: TObject);
    procedure BlobAsImageExecute(Sender: TObject);
    procedure LoadBlobFromFileExecute(Sender: TObject);
    procedure TestButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FConfig: TIniFile;
    FMaxErrors: Integer;
    FPacketRecs: Integer;
    FActiveDataSet: TDataSet;
    FADOSource: TCustomADODataSet;
    FActiveDataSource: TDataSource;
    FStatusMsg: string;
    FClosedTables: TStringList;
    FMasterQueries: TStringList;
    FDetailQueries: TStringList;
    FQueryIndex: Integer;
    FModifiedParameter: Integer;
    FMovingColumn: Boolean;
    FParamSource: TParameters;
    FLastDataFile: String;
    FLastFormFile: String;

    function GetConfigFile: TIniFile;
    procedure RefreshIndexNames;
    procedure SetActiveDataSet(Value: TDataSet);
    procedure SetEventsVisible(Visible: Boolean);
    procedure SetQueryText;
    procedure SetStatusMsg(const Msg: string);
    procedure ShowHeapStatus(Sender: TObject; var Done: Boolean);
    procedure UpdateReOpenMenu;
    procedure OnHint(Sender: TObject);
    procedure ClearProgressBar;
    procedure ShowProgressBar(const Msg: string);
    procedure ProcessQuery(SelectQuery: Boolean);
    procedure WriteParameterData;
    procedure UpdateParameterList;
    procedure ShowIndexParams;
    procedure SetRecordSetEvents(Hook: Boolean; DataSet: TCustomADODataSet);
    function GetActiveDataSet: TDataSet;
  public
    procedure BindControls(DataSet: TDataSet);
    procedure CheckConnection(CloseFirst: Boolean = False);
    procedure OpenDataSet(Source: TCustomADODataSet);
    procedure StreamSettings(Write: Boolean);
    procedure LogEvent(const EventStr: string; Component: TComponent = nil);
    procedure RefreshParameters(Parameters: TParameters);
    property StatusMsg: string read FStatusMsg write SetStatusMsg;
    property ActiveDataSet: TDataSet read GetActiveDataSet write SetActiveDataSet;
    property ActiveDataSource: TDataSource read FActiveDataSource write FActiveDataSource;
    property ADOSource: TCustomADODataSet read FADOSource write FADOSource;
    property ConfigFile: TIniFile read GetConfigFile;
  end;

var
  ADODBTest: TADODBTest;

implementation

uses
  OLEDB, DBLogDlg, AdoConEd, RecError, fmain;

procedure ShowProperties(Props: Properties);
var
  I: Integer;
  F: TForm;
  Button: TButton;
begin
  F := CreateMessageDialog('', mtInformation, [mbCancel]);
  F.Height := Screen.Height div 2;
  F.Width := Screen.Width div 2;
  Button := F.Components[2] as TButton;
  Button.Top := F.ClientHeight - Button.Height - 5;
  Button.Left := (F.ClientWidth - Button.Width) div 2;
  F.Caption := 'Properties';
  with TMemo.Create(F) do
  begin
    SetBounds(5, 5, F.ClientWidth-10, F.ClientHeight - 40);
    Parent := F;
    for I := 0 to Props.Count - 1 do
      with Props[I] do
        Lines.Add(Format('%-30s: %s', [Name, VarToStr(Value)]));
  end;
  F.ShowModal;
end;

{$R *.dfm}

procedure TADODBTest.FormCreate(Sender: TObject);

  procedure SetupControls;
  var
    I: Integer;
  begin
    for I := 0 to StatusBar.Panels.Count - 1 do
      StatusBar.Panels[I].Text := '';
    ProgressBar.Parent := StatusBar;
    ProgressBar.SetBounds(0, 2, StatusBar.Panels[0].Width, StatusBar.Height - 2);
    { Set these dynamically since the form may have been scaled }
    DataPanel.Constraints.MinWidth := DataPanel.Width;
    AreaSelector.Constraints.MinWidth := AreaSelector.Width;
    Constraints.MinHeight := Height - (DataPanel.Height - DataPanel.Constraints.MinHeight);
    SetEventsVisible(ViewEvents.Checked);
  end;

begin
  FMaxErrors := -1;
  FPacketRecs := -1;
  FModifiedParameter := -1;
  ActiveDataSource := MasterDataSource;
  SetCurrentDirectory(PChar(ExtractFilePath(ParamStr(0))));
  Application.OnIdle := ShowHeapStatus;
  Application.OnHint := OnHint;
  FClosedTables := TStringList.Create;
  FMasterQueries := TStringList.Create;
  FDetailQueries := TStringList.Create;
  StreamSettings(False);
  SetupControls;
  ParameterSourceClick(Self);
end;

procedure TADODBTest.FormDestroy(Sender: TObject);
begin
  if Assigned(FConfig) then
    StreamSettings(True);
  FConfig.Free;
  FDetailQueries.Free;
  FMasterQueries.Free;
  FClosedTables.Free;
  //Showmessage('ADO free');
  maxform1.memo2.lines.add('ADO Workbench destroyed: ');

end;

procedure TADODBTest.ExitApplicationExecute(Sender: TObject);
begin
  //Application.Terminate;
  Close;
   maxform1.memo2.lines.add('ADO Workbench exit closed: '+ maxform1.getperftime);

  //Free;
end;

procedure TADODBTest.HelpAboutExecute(Sender: TObject);
begin
  ShowMessage(Caption+#13#10+'mX4 and Borland Inprise Corporation');
end;

procedure TADODBTest.OnHint(Sender: TObject);
begin
  if FindVCLWindow(Mouse.CursorPos) <> ConnectionString then
    ConnectionString.Hint := ConnectionString.Text;
  StatusMsg := Application.Hint;
end;

procedure TADODBTest.ExceptionHandler(Sender: TObject; E: Exception);
begin
  ClearProgressBar;
  SysUtils.ShowException(ExceptObject, ExceptAddr);
end;

{ View Options }

procedure TADODBTest.SetEventsVisible(Visible: Boolean);
var
  EventsWidth: Integer;
begin
  Constraints.MinWidth := 0;
  if Events.Visible <> Visible then
  begin
    DataPanel.Anchors := DataPanel.Anchors - [akRight];
    AreaSelector.Anchors := AreaSelector.Anchors  - [akRight];
    try
      EventsWidth := Events.Width + 5;
      Events.Visible := Visible;
      if not Visible then
        EventsWidth := -EventsWidth;
      ClientWidth := ClientWidth + EventsWidth;
    finally
      DataPanel.Anchors := DataPanel.Anchors + [akRight];
      AreaSelector.Anchors := AreaSelector.Anchors  + [akRight];
    end;
  end;
  if Visible then
    Constraints.MinWidth := DataPanel.Constraints.MinWidth + Events.Width + 22 else
    Constraints.MinWidth := DataPanel.Constraints.MinWidth + 18;
end;

procedure TADODBTest.ViewEventsExecute(Sender: TObject);
begin
  ViewEvents.Checked := not ViewEvents.Checked;
  SetEventsVisible(ViewEvents.Checked);
end;

procedure TADODBTest.DisplayDetailsExecute(Sender: TObject);
begin
  DisplayDetails.Checked := not DisplayDetails.Checked;
end;

{ Settings }

function TADODBTest.GetConfigFile: TIniFile;
begin
  if FConfig = nil then
    FConfig := TIniFile.Create(ChangeFileExt(ParamStr(0), '.INI'));
  Result := FConfig;
end;

procedure TADODBTest.StreamSettings(Write: Boolean);

  procedure WriteStr(const OptName: string; Value: Variant);
  begin
    FConfig.WriteString('Settings', OptName, Value);
  end;

  procedure WriteBool(const OptName: string; Value: Boolean);
  begin
    FConfig.WriteBool('Settings', OptName, Value);
  end;

  procedure WriteStrings(const SectName: string; Values: TStrings);
  var
    I: Integer;
  begin
    FConfig.EraseSection(SectName);
    for I := 0 to Values.Count - 1 do
      FConfig.WriteString(SectName, IntToStr(I), Values[I]);
  end;

  function ReadStr(const OptName: string): Variant;
  begin
    Result := FConfig.ReadString('Settings', OptName, '');
  end;

  function ReadBool(const OptName: string): Boolean;
  begin
    Result := FConfig.ReadBool('Settings', OptName, False);
  end;

  procedure ReadStrings(const SectName: string; Values: TStrings);
  var
    I: Integer;
    S: string;
  begin
    for I := 0 to 99 do
    begin
      S := FConfig.ReadString(SectName, IntToStr(I), '');
      if S = '' then Break;
      Values.Add(S);
    end;
  end;

  function FindPage(const PageName: string): TTabSheet;
  var
    I: Integer;
  begin
    for I := AreaSelector.PageCount - 1 downto 0 do
    begin
      Result := AreaSelector.Pages[I];
      if Result.Caption = PageName then Exit;
    end;
    Result := SourcePage;
  end;

  procedure ProcessComponents(Components: array of TComponent);
  var
    I,J: Integer;
  begin
    if Write then
    begin
      for I := Low(Components) to High(Components) do
        if Components[I] is TCustomEdit then
          with TEdit(Components[I]) do
            WriteStr(Name, Text)
        else if Components[I] is TComboBox then
          with TDBComboBox(Components[I]) do
            WriteStr(Name, Text)
        else if Components[I] is TCheckBox then
          with TCheckBox(Components[I]) do
            WriteBool(Name, Checked)
        else if Components[I] is TRadioButton then
          with TRadioButton(Components[I]) do
            WriteBool(Name, Checked)
        else if Components[I] is TAction then
          with TAction(Components[I]) do
            WriteBool(Name, Checked)
        else if Components[I] is TPageControl then
          with TPageControl(Components[I]) do
            WriteStr(Name, ActivePage.Caption)
        else if Components[I] is TMenuItem then
          with TMenuItem(Components[I]) do
            for J := 0 to Count-1 do
              if Items[J].Checked then
              begin
                WriteStr(Name, J);
                System.Break;
              end;
    end
    else
    begin
      for I := Low(Components) to High(Components) do
        if Components[I] is TCustomEdit then
          with TEdit(Components[I]) do
            Text := ReadStr(Name)
        else if Components[I] is TComboBox then
          with TComboBox(Components[I]) do
            Text := ReadStr(Name)
        else if Components[I] is TCheckBox then
          with TCheckBox(Components[I]) do
            Checked := ReadBool(Name)
        else if Components[I] is TRadioButton then
          with TRadioButton(Components[I]) do
            Checked := ReadBool(Name)
        else if Components[I] is TAction then
          with TAction(Components[I]) do
            Checked := ReadBool(Name)
        else if Components[I] is TPageControl then
          with TPageControl(Components[I]) do
            ActivePage := FindPage(ReadStr(Name))
        else if Components[I] is TMenuItem then
          with TMenuItem(Components[I]) do
            Items[ReadStr(Name)].Checked := True;
    end;
  end;

begin
  GetConfigFile;
  if not Write and (ReadStr('AreaSelector') = '') then
  begin
    ConnectionString.Text := 'FILE NAME=' + DataLinkDir + '\DBDEMOS.UDL';
    Exit;
  end;
  ProcessComponents([AreaSelector, ConnectionString, MasterTableName,
    DetailTableName, MasterProcName, DetailProcName, MasterSQL, DetailSQL, ViewEvents, DisplayDetails,
    UseClientCursor, UseTableDirect, UseShapeProvider, CursorTypeItem,
    LockTypeItem, AsyncConnect, AsyncExecute, AsyncFetch, MidasButton,
    ProcParams, EnableBCD]);
  if Write then
  begin
    WriteStrings('ConnectionStrings', ConnectionString.Items);
    WriteStrings('ClosedTables', FClosedTables);
    WriteStrings('MasterQueries', FMasterQueries);
    WriteStrings('DetailQueries', FDetailQueries);
    FConfig.UpdateFile;
  end else
  begin
    ReadStrings('ConnectionStrings', ConnectionString.Items);
    ReadStrings('ClosedTables', FClosedTables);
    ReadStrings('MasterQueries', FMasterQueries);
    ReadStrings('DetailQueries', FDetailQueries);
  end;
end;

procedure TADODBTest.RadioItemClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;
end;

procedure TADODBTest.BooleanActionExecute(Sender: TObject);
begin
  TAction(Sender).Checked := not TAction(Sender).Checked;
end;

procedure TADODBTest.UseShapeProviderExecute(Sender: TObject);
begin
  BooleanActionExecute(Sender);
  Connection.Close;
end;

procedure TADODBTest.MaxRecordsExecute(Sender: TObject);
var
  MaxRecs: string;
begin
  MaxRecs := IntToStr(MaxRecords.Tag);
  if InputQuery(Application.Title,  MaxRecords.Hint, MaxRecs) then
    MaxRecords.Tag := StrToInt(MaxRecs);
end;

{ Status Information }

procedure TADODBTest.ShowHeapStatus(Sender: TObject; var Done: Boolean);
begin
  Caption := Format('mX4 ADO DB Controls Workbench - (Blocks=%d Bytes=%d)',
    [AllocMemCount, AllocMemSize]);
end;

procedure TADODBTest.SetStatusMsg(const Msg: string);
begin
  StatusBar.Panels[0].Text := Msg;
end;

procedure TADODBTest.ShowProgressBar(const Msg: string);
begin
  ProgressBar.Show;
  StatusBar.Panels[3].Text := Msg+'...';
  while ProgressBar.Visible do
  begin
    ProgressBar.StepIt;
    Application.ProcessMessages;
    Sleep(ProgressBar.Position);
  end;
end;

procedure TADODBTest.ClearProgressBar;
begin
  ProgressBar.Hide;
  ProgressBar.Position := 0;
  StatusBar.Panels[3].Text := '';
end;

procedure TADODBTest.DataSourceDataChange(Sender: TObject;
  Field: TField);
const
  StatusStrs: array[TUpdateStatus] of string = ('Unmodified',
    'Modified', 'Inserted', 'Deleted');
begin
  if (Sender = ActiveDataSource) and Assigned(ActiveDataSource.DataSet) and ActiveDataSource.DataSet.IsSequenced then
  begin
    with ActiveDataSource.DataSet do
    begin
      if IsEmpty then
      begin
        StatusBar.Panels[1].Text := '';
        StatusBar.Panels[3].Text := '(empty)';
      end else
      begin
        StatusBar.Panels[1].Text := StatusStrs[UpdateStatus];
        if (State = dsBrowse) and (Field = nil) then
        begin
          StatusBar.Panels[3].Text := Format('%d of %d', [RecNo, RecordCount]);
          StatusMsg := '';
        end;
      end;
      if ActiveControl is TDBGrid then
        GridColEnter(TDBGrid(ActiveControl));
    end;
  end;
  LogEvent('OnDataChange', Sender as TComponent);
end;

procedure TADODBTest.GridColEnter(Sender: TObject);
const
  NullStr: array[Boolean] of string = ('','[NULL]');
var
  Field: TField;

  procedure TrackBlobs;
  begin
    if Field.DataSet <> MasterDataSource.DataSet then Exit;
    if (Field is TMemoField) and (Field <> DBMemo1.Field) then
      DBMemo1.DataField := Field.FieldName
    else if (Field is TGraphicField) and (Field <> DBImage1.Field) then
      DBImage1.DataField := Field.FieldName;
  end;

  procedure ShowOriginalValues;
  var
    V: Variant;
  begin
    if Field.Dataset.CanModify then
    begin
      V := Field.OldValue;
      if not VarIsNull(V) and (V <> Field.Value) then
        StatusMsg := Format('Orignal Value: %s', [VarToStr(V)]) else
        StatusMsg := '';
    end;
  end;

begin
  Field := (Sender as TDBGrid).SelectedField;
  if Assigned(Field) then
  begin
    (Sender as TDBGrid).Hint := Field.ClassName;
    StatusBar.Panels[0].Text := Field.ClassName;
    StatusBar.Panels[2].Text := NullStr[Field.IsNull];
    TrackBlobs;
    if ActiveDataSet.UpdateStatus = usModified then
      ShowOriginalValues;
  end;
end;

{ Connection Operations }

procedure TADODBTest.CheckConnection(CloseFirst: Boolean);
const
  ConnectOptionValues: array [Boolean] of TConnectOption = (coConnectUnspecified, coAsyncConnect);
var
  ConnStr: string;
  Index: Integer;
begin
  if not CloseFirst and Connection.Connected then Exit;
  Connection.Close;
  MasterClientData.Close;
  ConnStr := ConnectionString.Text;
  Connection.ConnectionString := ConnStr;
  Connection.ConnectOptions := ConnectOptionValues[AsyncConnect.Checked];
  if UseShapeProvider.Checked then
    Connection.Provider := 'MSDataShape';
  Index := ConnectionString.Items.IndexOf(ConnStr);
  if Index > 0 then
    ConnectionString.Items.Delete(Index);
  if Index <> 0 then
  begin
    ConnectionString.Items.Insert(0, ConnStr);
    while ConnectionString.Items.Count > 20 do
      ConnectionString.Items.Delete(20);
  end;
  ConnectionString.ItemIndex := 0;
  Application.ProcessMessages;
  Connection.Open;
  if AsyncConnect.Checked and (stConnecting in Connection.State) then
    ShowProgressBar('Connecting');
//  ShowProperties(Connection.Properties);
end;

procedure TADODBTest.EditConnStrClick(Sender: TObject);
begin
  Connection.Close;
  Connection.ConnectionString := ConnectionString.Text;
  if EditConnectionString(Connection) then
  begin
    ConnectionString.Text := Connection.ConnectionString;
    ConnectionStringClick(Sender);
  end;
end;

procedure TADODBTest.ConnectionStringClick(Sender: TObject);
begin
  if (ConnectionString.Text <> '') and not ConnectionString.DroppedDown then
  begin
    CheckConnection(True);
    MasterTableName.Items.Clear;
    MasterTableName.Text := '';
    DetailTableName.Items.Clear;
    DetailTableName.Text := '';
    MasterProcName.Items.Clear;
    MasterProcName.Text := '';
    DetailProcName.Items.Clear;
    DetailProcName.Text := '';
  end;
end;

procedure TADODBTest.ConnectionStringKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if ConnectionString.DroppedDown then
      ConnectionString.DroppedDown := False;
    ConnectionStringClick(Sender);
    Key := #0;
  end;
end;

procedure TADODBTest.CloseConnectionExecute(Sender: TObject);
begin
  Connection.Close;
end;

{ Common DataSet Operations }

procedure TADODBTest.OpenDataSet(Source: TCustomADODataSet);

  procedure ShowFetchProgress;
  begin
    while stFetching in ADOSource.RecordSetState do
    begin
      with ADOSource do
        StatusBar.Panels[3].Text := Format('%d of %d', [RecNo, RecordCount]);
      Application.ProcessMessages;
    end;
  end;

begin
  ClearEventLog.Execute;
  Screen.Cursor := crHourGlass;
  try
    Source.Close;
    MasterClientData.Close;
    ADOSource := TCustomADODataSet(Source);
    SetRecordSetEvents(UseClientCursor.Checked, ADOSource);
    Provider.DataSet := ADOSource;
    if MidasButton.Checked then ActiveDataSet := MasterClientData else
    begin
      ActiveDataSet := Source;
      ShowFetchProgress;
    end;
    if MasterGrid.Visible then MasterGrid.SetFocus;
  finally
    Screen.Cursor := crDefault;
  end;
  StreamSettings(True);
end;

procedure TADODBTest.DisconnectDataSetExecute(Sender: TObject);
begin
  ADOSource.Connection := nil;
end;

function TADODBTest.GetActiveDataSet: TDataSet;
begin
  if not Assigned(FActiveDataSet) then
    DatabaseError('No active dataset');
  Result := FActiveDataSet;
end;

procedure TADODBTest.SetActiveDataSet(Value: TDataSet);

  function GetDetailDataSet: TDataSet;
  var
    I: Integer;
  begin
    Result := nil;
    if (Value = MasterTable) and DetailTable.Active then
       Result := DetailTable
    else if (Value = MasterQuery) and DetailQuery.Active then
      Result := DetailQuery
    else if (Value = MasterProc) and DetailProc.Active then
      Result := DetailProc
    else for I := 0 to Value.Fields.Count - 1 do
      if Value.Fields[I] is TDataSetField then
      begin
        Result := TDataSetField(Value.Fields[I]).NestedDataSet;
        Break;
      end;
  end;

begin
  StatusBar.Panels[2].Text := '';
  MasterDataSource.Enabled := False;
  DetailDataSource.Enabled := False;
  try
    MasterGrid.DataSource := nil;
    FActiveDataSet := Value;
    DetailDataSource.DataSet := nil;
    MasterDataSource.DataSet := Value;
    if Assigned(Value) then
    begin
      Value.Open;
      if AsyncExecute.Checked and (Value.State = dsOpening) then
        ShowProgressBar('Executing');
      if DisplayDetails.Checked then
        DetailDataSource.DataSet := GetDetailDataSet;
    end;
    BindControls(Value);
  finally
    MasterDataSource.Enabled := True;
    DetailDataSource.Enabled := True;
  end;
  if Assigned(Value) then
  begin
    Update;
    StatusMsg := 'ActiveDataSet is ' + Value.Name;
    if Assigned(AreaSelector.ActivePage.OnShow) then
      AreaSelector.ActivePage.OnShow(nil);
  end;
end;

procedure TADODBTest.DataSetBeforeOpen(DataSet: TDataSet);
var
  I: Integer;
begin
  with DataSet as TCustomADODataSet do
  begin
    if Connection = nil then
      Connection := Self.Connection;
    CheckConnection(False);
    if UseClientCursor.Checked then
      CursorLocation := clUseClient else
      CursorLocation := clUseServer;
    for I := 0 to CursorTypeItem.Count - 1 do
    if CursorTypeItem.Items[I].Checked then
    begin
      CursorType := TCursortype(I);
      Break;
    end;
    for I := 0 to LockTypeItem.Count - 1 do
    if LockTypeItem.Items[I].Checked then
    begin
      LockType := TADOLocktype(I);
      Break;
    end;
    ExecuteOptions := [];
    if AsyncExecute.Checked then
      ExecuteOptions := [eoAsyncExecute];
    if AsyncFetch.Checked then
      ExecuteOptions := ExecuteOptions + [eoAsyncFetchNonBlocking];
    MaxRecords := Self.MaxRecords.Tag;
    EnableBCD := Self.EnableBCD.Checked;
  end;
  LogEvent('BeforeOpen', DataSet);
end;

procedure TADODBTest.DataSetAfterOpen(DataSet: TDataSet);
begin
  ClearProgressBar;
//  ShowProperties(ADOSource.RecordSet.Fields[0].Properties);
  LogEvent('AfterOpen', DataSet);
end;

procedure TADODBTest.DataSetAfterClose(DataSet: TDataSet);
begin
  LogEvent('AfterClose', DataSet);
  if DataSet = FActiveDataSet then
    FActiveDataSet := nil;
  if DataSet = ADOSource then
    FilterGroupBox.ItemIndex := -1;
end;

procedure TADODBTest.DataSetFetchComplete(DataSet: TCustomADODataSet;
  const Error: Error; var EventStatus: TEventStatus);
begin
  LogEvent('FetchComplete', DataSet);
end;

procedure TADODBTest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   //ADODBTest.Release;
   maxform1.memo2.lines.add('ADO Workbench closed: '+ maxform1.getperftime);
end;

procedure TADODBTest.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CloseActiveDataSet.Execute;
end;

{ Table Operations }

procedure TADODBTest.MasterTableNameDropDown(Sender: TObject);
begin
  try
    CheckConnection(False);
    with Sender as TComboBox do
      if Items.Count < 1 then
        Connection.GetTableNames(Items);
  except
    { Eat any exceptions so the combobox doesn't paint funny }
  end;
end;

procedure TADODBTest.MasterTableNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    with Sender as TComboBox do
    if DroppedDown then DroppedDown := False;
    OpenTable.Execute;
    Key := #0;
  end;
end;

procedure TADODBTest.MasterTableNameClick(Sender: TObject);
begin
  with Sender as TComboBox do
  if not DroppedDown then
  begin
    DetailTableName.Text := '';
    OpenTable.Execute;
  end;
end;

procedure TADODBTest.DetailTableNameClick(Sender: TObject);
begin
  with Sender as TComboBox do
    if not DroppedDown and (DetailTable.TableName <> Text) then
      OpenTable.Execute;
end;

procedure TADODBTest.UpdateReOpenMenu;
var
  I: Integer;
begin
  while FileReOpen.Count > 0 do
    FileReOpen.Items[0].Free;
  for I := 0 to FClosedTables.Count - 1 do
    FileReOpen.Add(NewItem(Format('%d) %s', [I, FClosedTables[I]]), 0, False,
      True, ClosedFileClick, 0, ''));
end;

procedure TADODBTest.ClosedFileClick(Sender: TObject);
var
  S: string;
  Index, P, P2: Integer;
begin
  S := Copy(TMenuItem(Sender).Caption, 5, MAXINT);
  P := Pos(':', S);
  P2 := Pos('/', S);
  if P2 > 0 then
    DetailTableName.Text := Copy(S, P2+1, MAXINT) else
  begin
    DetailTableName.Text := '';
    P2 := MAXINT;
  end;
  MasterTableName.Text := Copy(S, P+1, P2-P-1);
  Index := FClosedTables.IndexOf(S);
  if Index > -1 then
    FClosedTables.Delete(Index);
  OpenTable.Execute;
end;

procedure TADODBTest.OpenTableExecute(Sender: TObject);
begin
  if MasterTableName.Text <> '' then
  begin
    MasterTable.Close;
    OpenDataSet(MasterTable);
  end;
end;

procedure TADODBTest.CloseActiveDataSetExecute(Sender: TObject);
begin
  ActiveDataSet.Close;
end;

procedure TADODBTest.MasterTableBeforeOpen(DataSet: TDataSet);
begin
  DataSetBeforeOpen(DataSet);
  MasterTable.TableDirect := UseTableDirect.Checked;
  MasterTable.TableName := MasterTableName.Text;
  DetailTable.MasterSource := nil;
end;

procedure TADODBTest.DetailTableBeforeOpen(DataSet: TDataSet);
begin
  DataSetBeforeOpen(DataSet);
  DetailTable.TableDirect := UseTableDirect.Checked;
  DetailTable.TableName := DetailTableName.Text;
end;

procedure TADODBTest.MasterTableAfterOpen(DataSet: TDataSet);
var
  I: Integer;
  Field: TField;
  MasterFields: string;
begin
  if DetailTableName.Text <> '' then
  begin
    DetailTable.Open;
    if MasterTableName.Text = DetailTableName.Text then
      MasterFields := MasterTable.Fields[0].FieldName+';'
    else
      for I := 0 to DetailTable.Fields.Count - 1 do
      begin
        Field := MasterTable.FindField(DetailTable.Fields[I].FieldName);
        if Field <> nil then
        begin
          if DetailTable.IndexDefs.GetIndexForFields(MasterFields + Field.FieldName, False) <> nil then
            MasterFields := MasterFields + Field.FieldName + ';';
        end;
      end;
    if MasterFields = '' then
      DatabaseError('Cannot determine linking fields for detail');
    SetLength(MasterFields, Length(MasterFields)-1);
    DetailTable.IndexFieldNames := MasterFields;
    DetailTable.MasterFields := MasterFields;
    DetailTable.MasterSource := DetailMasterSource;
  end;
  DataSetAfterOpen(DataSet);
end;

procedure TADODBTest.FileMenuClick(Sender: TObject);
begin
  UpdateReOpenMenu;
  FileReOpen.Enabled := FClosedTables.Count > 0;
end;

procedure TADODBTest.MasterTableBeforeClose(DataSet: TDataSet);

  procedure UpdateClosedTables;
  var
    TableEntry: string;
  begin
    TableEntry := MasterTable.TableName;
    if DetailTable.Active then
    begin
      TableEntry := TableEntry + '/' + DetailTable.TableName;
      DetailTable.Close;
    end;
    if FClosedTables.IndexOf(TableEntry) = -1 then
    begin
      FClosedTables.Insert(0, TableEntry);
      if FClosedTables.Count > 9 then
        FClosedTables.Delete(9);
    end;
  end;

begin
  UpdateClosedTables;
  DetailTable.Close;
  DataSetBeforeClose(Dataset);
end;

{ Query Operations }

procedure TADODBTest.ProcessQuery(SelectQuery: Boolean);

  procedure UpdateQueryHistory;
  var
    DSQL: string;
  begin
    if FMasterQueries.IndexOf(MasterSQL.Text) <> -1 then Exit;
    FMasterQueries.Add(MasterSQL.Text);
    DSQL := DetailSQL.Text;
    if DSQL = '' then DSQL := '(empty)';
    FDetailQueries.Insert(0, DSQL);
    if FMasterQueries.Count > 9 then
    begin
      FMasterQueries.Delete(0);
      FDetailQueries.Delete(0);
    end;
  end;

var
  RecordsAffected: Integer;
begin
  CheckConnection(False);
  if SelectQuery then
  begin
    MasterQuery.Close;
    MasterQuery.SQL.Text := MasterSQL.Text;
    WriteParameterData;
    OpenDataSet(MasterQuery)
  end else
  begin
    if SQLParams.Checked then
    begin
      ADOCommand.CommandType := cmdText;
      ADOCommand.CommandText := MasterSQL.Text;
    end else
    begin
      ADOCommand.CommandType := cmdStoredProc;
      ADOCommand.CommandText := MasterProcName.Text;
    end;
    if ParameterList.Items.Count > 0 then
    begin
      WriteParameterData;
      ADOCommand.Parameters.Assign(FParamSource);
    end;
    ADOCommand.Execute(RecordsAffected, EmptyParam);
    StatusMsg := Format('%d rows were affected', [RecordsAffected]);
    if ProcParams.Checked then
      MasterProc.Parameters.Assign(ADOCommand.Parameters);
  end;
  UpdateQueryHistory;
end;

procedure TADODBTest.ExecSQLExecute(Sender: TObject);
begin
  ProcessQuery(False);
end;

procedure TADODBTest.OpenQueryExecute(Sender: TObject);
begin
  ProcessQuery(True);
end;

procedure TADODBTest.PrevQueryUpdate(Sender: TObject);
begin
  PrevQuery.Enabled := FQueryIndex < (FMasterQueries.Count - 1);
end;

procedure TADODBTest.PrevQueryExecute(Sender: TObject);
begin
  Assert(FQueryIndex < (FMasterQueries.Count - 1));
  Inc(FQueryIndex);
  SetQueryText;
end;

procedure TADODBTest.NextQueryExecute(Sender: TObject);
begin
  if FQueryIndex > -1 then
    Dec(FQueryIndex);
  SetQueryText;
end;

procedure TADODBTest.MasterSQLKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    OpenQuery.Execute;
    Key := #0;
  end;
end;

procedure TADODBTest.SetQueryText;
var
  DSQL: string;
begin
  if FQueryIndex > -1 then
  begin
    MasterSQL.Text := FMasterQueries[FQueryIndex];
    DSQL := FDetailQueries[FQueryIndex];
    if DSQL = '(empty)' then DSQL := '';
    DetailSQL.Text := DSQL;
  end else
  begin
    MasterSQL.Text := '';
    DetailSQL.Text := '';
  end;
end;

procedure TADODBTest.EditCommandTextClick(Sender: TObject);
var
  Command: string;
begin
  CheckConnection(False);
  Command := MasterSQL.Text;
  if EditSQL(Command, Connection.GetTableNames, Connection.GetFieldNames) then
    MasterSQL.Text := Command;
end;

procedure TADODBTest.MasterQueryBeforeOpen(DataSet: TDataSet);
begin
  DataSetBeforeOpen(DataSet);
  MasterQuery.SQL.Text := MasterSQL.Text;
end;

procedure TADODBTest.DetailQueryBeforeOpen(DataSet: TDataSet);
begin
  DataSetBeforeOpen(DataSet);
  DetailQuery.SQL.Text := DetailSQL.Text;
  DetailQuerySource.Dataset := MasterQuery;
  if DetailQuery.Parameters.Count = 0 then
    RefreshParameters(DetailQuery.Parameters);
end;

procedure TADODBTest.MasterQueryAfterOpen(DataSet: TDataSet);
begin
  if Trim(DetailSQL.Text) <> '' then
    DetailQuery.Open else
    DetailQuerySource.Dataset := nil;
  DataSetAfterOpen(DataSet);
end;

procedure TADODBTest.MasterQueryBeforeClose(DataSet: TDataSet);
begin
  DetailQuery.Close;
  DataSetBeforeClose(DataSet);
end;

{ Stored Procedures }

procedure TADODBTest.MasterProcBeforeOpen(DataSet: TDataSet);
begin
  DataSetBeforeOpen(DataSet);
  MasterProc.ProcedureName := MasterProcName.Text;
  WriteParameterData;
end;

procedure TADODBTest.MasterProcAfterOpen(DataSet: TDataSet);
begin
  if DetailProcName.Text <> '' then
    DetailProc.Open;
  DataSetAfterOpen(DataSet);
end;

procedure TADODBTest.DetailProcBeforeOpen(DataSet: TDataSet);
begin
  DataSetBeforeOpen(DataSet);
  DetailProc.ProcedureName := DetailProcName.Text;
  RefreshParameters(DetailProc.Parameters);
end;

procedure TADODBTest.OpenProcedureExecute(Sender: TObject);
begin
  if MasterProcName.Text <> '' then
  begin
    MasterProc.Close;
    OpenDataSet(MasterProc);
  end;
end;

procedure TADODBTest.ProcNameDropDown(Sender: TObject);
begin
  CheckConnection(False);
  with Sender as TComboBox do
    if Items.Count < 1 then
      Connection.GetProcedureNames(Items);
end;

procedure TADODBTest.MasterProcNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    with Sender as TComboBox do
    if DroppedDown then DroppedDown := False;
    Key := #0;
  end;

end;

procedure TADODBTest.MasterProcNameClick(Sender: TObject);
begin
  with Sender as TComboBox do
  if not DroppedDown then
    DetailProcName.Text := '';
end;

procedure TADODBTest.DetailProcNameClick(Sender: TObject);
begin
end;

{ Packet Save/Load }

procedure TADODBTest.LoadFromFileExecute(Sender: TObject);
begin
  OpenDialog.FilterIndex := 1;
  OpenDialog.FileName := FLastDataFile;
  if OpenDialog.Execute then
  begin
    ADODataSet.LoadFromFile(OpenDialog.FileName);
    FLastDataFile := OpenDialog.FileName;
    ActiveDataSet := ADODataSet;
    ADOSource := ADODataSet;
  end;
end;

procedure TADODBTest.SaveToFileExecute(Sender: TObject);
begin
  SaveDialog.FilterIndex := 1;
  SaveDialog.FileName := FLastDataFile;
  if SaveDialog.Execute then
  begin
    ADOSource.SaveToFile(SaveDialog.FileName, pfADTG);
    FLastDataFile := SaveDialog.FileName;
  end;
end;

procedure TADODBTest.FileActionsUpdate(Sender: TObject);
begin
  SaveToFile.Enabled := Assigned(FActiveDataSet) and ActiveDataSet.Active;
  CloseActiveDataSet.Enabled := SaveToFile.Enabled;
  DisconnectDataset.Enabled := SaveToFile.Enabled;
  CloseConnection.Enabled := Connection.Connected;
end;

{ Streaming }

procedure TADODBTest.StreamFormOutClick(Sender: TObject);
begin
  SaveDialog.FilterIndex := 2;
  SaveDialog.FileName := FLastFormFile;
  if SaveDialog.Execute then
  begin
    WriteComponentResFile(SaveDialog.FileName, Self);
    FLastFormFile := SaveDialog.FileName;
  end;
end;

procedure TADODBTest.StreamFormInClick(Sender: TObject);
var
  Form: TADODBTest;
begin
  OpenDialog.FilterIndex := 2;
  OpenDialog.FileName := FLastFormFile;
  if OpenDialog.Execute then
  begin
    Form := TADODBTest.CreateNew(Application, 0);
    ReadComponentResFile(OpenDialog.FileName, Form);
    FLastFormFile := OpenDialog.FileName;
    Form.FormCreate(Form);
  end;
end;

{ DB Control Linking }

procedure TADODBTest.BindControls(DataSet: TDataSet);

  procedure DeleteDBEditControls;
  var
    I: Integer;
  begin
    with DBEditScroller do
      for I := ComponentCount - 1 downto 0 do
        if (Components[I] is TDBEdit) or (Components[I] is TLabel) then
          Components[I].Free;
  end;

  procedure SetDisplayType(ForwardOnly: Boolean);
  begin
    if ForwardOnly then
    begin
      MasterGrid.Visible := False;
      MasterGrid.DataSource := nil;
      DBEditScroller.Height := GridPanel.Height;
      DBEditScroller.HorzScrollBar.Position := 0;
      DBEditScroller.VertScrollBar.Position := 0;
      DBNavigator1.VisibleButtons := [nbNext, nbInsert, nbDelete, nbEdit,
        nbPost, nbCancel, nbRefresh];
    end else
    begin
      MasterGrid.Visible := True;
      MasterGrid.DataSource := MasterDataSource;
      DBEditScroller.Height := 0;
      DBNavigator1.VisibleButtons := [nbFirst, nbPrior, nbNext, nbLast,
        nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh];
    end;
  end;

  procedure CreateDBEdit(F: TField);
  var
    LabelTop: Integer;
  begin
    with TDBEdit.Create(DBEditScroller) do
    begin
      Left := 65;
      Top := (F.FieldNo - 1) * (Height + 5) + 5;
      LabelTop := Top + 3;
      Width := F.DisplayWidth * Canvas.TextWidth('0');
      Parent := DBEditScroller;
      DataSource := MasterDataSource;
      DataField := F.FieldName;
    end;
    with TLabel.Create(DBEditScroller) do
    begin
      AutoSize := False;
      Alignment := taRightJustify;
      Left := 3;
      Top := LabelTop;
      Width := 59;
      Parent := DBEditScroller;
      Caption := F.DisplayLabel+':';
    end;
  end;

var
  I: Integer;
  Field: TField;
begin
  DBMemo1.DataField := '';
  DBImage1.DataField := '';
  DetailGrid.Visible := False;
  GridSplitter.Visible := False;
  BlobCtrlPanel.Visible := False;
  DBImage1.Visible := False;
  DBMemo1.Visible := False;
  ReadOnlyLabel.Visible := False;
  if Assigned(DataSet) and DataSet.Active then
  begin
    SetDisplayType((DataSet is TCustomADODataSet) and not
      TCustomADODataSet(DataSet).Supports([coBookmark, coMovePrevious]));
    for I := 0 to DataSet.FieldCount - 1 do
    begin
      Field := DataSet.Fields[I];
      Field.OnValidate := FieldValidate;
      case Field.DataType of
        ftMemo:
          if DBMemo1.DataField = '' then
          begin
            DBMemo1.DataField := Field.FieldName;
            DBMemo1.Visible := True;
          end;
        ftGraphic:
          if DBImage1.DataField = '' then
          begin
            DBImage1.DataField := DataSet.Fields[I].FieldName;
            DBImage1.Visible := True;
          end;
        ftDataSet, ftReference:
          if DisplayDetails.Checked and (DetailDataSource.DataSet = nil) then
          begin
            DetailDataSource.DataSet := TDataSetField(DataSet.Fields[I]).NestedDataSet;
          end;
        ftBytes, ftVarBytes:
          begin
            Field.OnGetText := BinaryGetText;
            Field.OnSetText := BinarySetText;
            Field.DisplayWidth := (Field.Size + 3);
          end;
        else
          if not MasterGrid.Visible then
            CreateDBEdit(Field);
      end;
    end;
    BlobCtrlPanel.Visible := DBMemo1.Visible or DBImage1.Visible;
    ReadOnlyLabel.Visible := not DataSet.CanModify;
    if Assigned(DetailDataSource.DataSet) then
    begin
      GridSplitter.Visible := True;
      DetailGrid.Visible := True;
    end;
  end else
    DeleteDBEditControls;
end;

procedure TADODBTest.GridSetFocus(Sender: TObject);
begin
  if not Assigned(FActiveDataSet) then Exit;
  ActiveDataSource := (Sender as TDBGrid).DataSource;
  DBNavigator1.DataSource := ActiveDataSource;
  DataSourceDataChange(ActiveDataSource, nil);
end;

procedure TADODBTest.PopupMenu1Popup(Sender: TObject);
var
  I: Integer;
  MI: TMenuItem;
  F, CurField: TField;
begin
  with PopupMenu1, ActiveDataSet do
  begin
    if PopupMenu1.PopupComponent = DBMemo1 then
      CurField := DBMemo1.Field else
      CurField := DBImage1.Field;
    while Items.Count > 0 do Items.Delete(0);
    MI := NewItem('(None)', 0, False, True, FieldSelect, 0, 'None');
    Items.Add(MI);
    for I := 0 to FieldCount - 1 do
      if Fields[I] is TBlobField then
      begin
        F := Fields[I];
        MI := NewItem(F.FieldName, 0, F=CurField, True, FieldSelect, 0, 'mi'+F.FieldName);
        MI.Tag := Integer(F);
        Items.Add(MI);
      end;
  end;
end;

procedure TADODBTest.FieldSelect(Sender: TObject);
var
  MI: TMenuItem;
begin
  MI := TMenuItem(Sender);
  if PopupMenu1.PopupComponent = DBImage1 then
  try
    if MI.Tag = 0 then
      DBImage1.DataField := '' else
      DBImage1.DataField := TField(MI.Tag).FieldName;
  except
    DBImage1.DataField := '';
    raise;
  end
  else if PopupMenu1.PopupComponent = DBMemo1 then
  try
    if MI.Tag = 0 then
      DBMemo1.DataField := '' else
      DBMemo1.DataField := TField(MI.Tag).FieldName;
  except
    DBMemo1.DataField := '';
    raise;
  end;
end;

{ Editing / Updates }

procedure TADODBTest.EditActionsUpdate(Sender: TObject);
var
  Enabled: Boolean;
begin
  Enabled := Assigned(FActiveDataSet);
  BatchUpdate.Enabled := Assigned(ADOSource) and
    (ADOSource.LockType = ltBatchOptimistic);
  CancelBatch.Enabled := BatchUpdate.Enabled;
  ClearField.Enabled := Enabled;
  RefreshData.Enabled := Enabled;
  MidasApplyUpdates.Enabled := MasterClientData.Active and
    ((MasterClientData.ChangeCount > 0) or (MasterClientData.State in dsEditModes));
  MidasCancelUpdates.Enabled := MidasApplyUpdates.Enabled;
  LoadBlobFromFile.Enabled := Enabled and (MasterGrid.SelectedField is TBlobField);
end;

procedure TADODBTest.BatchUpdateExecute(Sender: TObject);
begin
  if ADOSource.Connection = nil then
  begin
    CheckConnection(False);
    ADOSource.Connection := Connection;
  end;
  ADOSource.UpdateBatch;
end;

procedure TADODBTest.CancelBatchExecute(Sender: TObject);
begin
  ADOSource.CancelUpdates;
end;

procedure TADODBTest.ClearFieldExecute(Sender: TObject);
var
  Field: TField;
begin
  Field := MasterGrid.SelectedField;
  if Field = nil then Exit;
  ActiveDataSet.Edit;
  Field.Clear;
end;

procedure TADODBTest.RefreshDataExecute(Sender: TObject);
begin
  ActiveDataSet.Refresh;
end;

procedure TADODBTest.BinaryGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := Sender.AsString;
end;

procedure TADODBTest.BinarySetText(Sender: TField; const Text: string);
begin
  Sender.AsString := Text;
end;

procedure TADODBTest.BlobAsImageUpdate(Sender: TObject);
begin
  BlobAsImage.Enabled := Assigned(ActiveDataSource.DataSet) and ActiveDataSource.DataSet.Active and
    (MasterGrid.SelectedField is TBlobField);
end;

procedure TADODBTest.BlobAsImageExecute(Sender: TObject);
begin
  BlobCtrlPanel.Visible := True;
  DBImage1.Visible := True;
  DBImage1.DataField := MasterGrid.SelectedField.FieldName;
end;

procedure TADODBTest.LoadBlobFromFileExecute(Sender: TObject);
begin
  OpenDialog.FilterIndex := 3;
  if OpenDialog.Execute then
    TBlobField(MasterGrid.SelectedField).LoadFromFile(OpenDialog.FileName);
end;

{ Indexes }

procedure TADODBTest.IndexPageShow(Sender: TObject);
begin
  if not (Assigned(ActiveDataSource) and Assigned(ActiveDataSource.DataSet)) then Exit;
  RefreshIndexNames;
end;

procedure TADODBTest.RefreshIndexNames;
var
  I: Integer;
  IndexDefs: TIndexDefs;
begin
  IndexList.Clear;
  if ActiveDataSet = MasterClientData then
    IndexDefs := MasterClientData.IndexDefs else
  if ADOSource is TADOTable then
    IndexDefs := TADOTable(ADOSource).IndexDefs else
  if ADOSource is TADODataSet then
    IndexDefs := TADODataSet(ADOSource).IndexDefs
  else
    Exit;
  IndexDefs.Update;
  for I := 0 to IndexDefs.Count - 1 do
    if IndexDefs[I].Name = '' then
      IndexList.Items.Add('<primary>') else
      IndexList.Items.Add(IndexDefs[I].Name);
  if IndexList.Items.Count > 0 then
  begin
    if (ADOSource = MasterTable) and (IndexList.Items.IndexOf(MasterTable.IndexName) > 0) then
      IndexList.ItemIndex := IndexList.Items.IndexOf(MasterTable.IndexName) else
      IndexList.ItemIndex := 0;
    ShowIndexParams;
  end;
end;

procedure TADODBTest.ShowIndexParams;
var
  IndexDef: TIndexDef;
begin
  if ActiveDataSource.DataSet is TADOTable then
    IndexDef := TADOTable(ActiveDataSource.DataSet).IndexDefs[IndexList.ItemIndex] else
  if ActiveDataSource.DataSet is TADODataSet then
    IndexDef := TADODataSet(ActiveDataSource.DataSet).IndexDefs[IndexList.ItemIndex]
  else
    Exit;
  idxCaseInsensitive.Checked := ixCaseInsensitive in IndexDef.Options;
  idxDescending.Checked := ixDescending in IndexDef.Options;
  idxUnique.Checked := ixUnique in IndexDef.Options;
  idxPrimary.Checked := ixPrimary in IndexDef.Options;
  IndexFields.Text := IndexDef.Fields;
  DescFields.Text := IndexDef.DescFields;
  CaseInsFields.Text := IndexDef.CaseInsFields;
end;

procedure TADODBTest.IndexListClick(Sender: TObject);
begin
  ShowIndexParams;
  if ActiveDataSet is TADOTable then
    with TADOTable(ActiveDataSet) do
    begin
      try
        { Only Jet 4 supports setting indexname while open }
        MasterTable.IndexName := IndexList.Items[IndexList.ItemIndex];
      except
        Close;
        MasterTable.IndexName := IndexList.Items[IndexList.ItemIndex];
        OpenTableExecute(nil);
      end;
    end;
end;

procedure TADODBTest.GridTitleClick(Column: TColumn);
var
  DataSet: TDataSet;
begin
  if not FMovingColumn then
  begin
    DataSet := Column.Field.DataSet;
    if DataSet is TCustomADODataSet then
    with TCustomADODataSet(DataSet) do
    begin
      if (Pos(Column.Field.FieldName, Sort) = 1) and (Pos(' DESC', Sort) = 0) then
        Sort := Column.Field.FieldName + ' DESC' else
        Sort := Column.Field.FieldName + ' ASC';
      StatusMsg := 'Sorted on '+Sort;
    end;
  end;
  FMovingColumn := False;
end;

procedure TADODBTest.MasterGridColumnMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
  FMovingColumn := True;
end;

{ Filters }

procedure TADODBTest.FilterPageShow(Sender: TObject);
var
  Field: TField;
  LocValue,
  QuoteChar: string;
begin
  if (Filter.Text = '') and Assigned(FActiveDataSet) and ActiveDataSet.Active then
  begin
    Field := MasterGrid.SelectedField;
    if Field = nil then Exit;
    with ActiveDataSet do
    try
      DisableControls;
      MoveBy(3);
      LocValue := VarToStr(Field.Value);
      First;
    finally
      EnableControls;
    end;
    if Field.DataType in [ftString, ftMemo, ftFixedChar] then
      QuoteChar := '''' else
      QuoteChar := '';
    Filter.Text := Format('%s=%s%s%1:s', [Field.FullName, QuoteChar, LocValue]);
  end;
end;

procedure TADODBTest.FilterKeyPress(Sender: TObject; var Key: Char);
begin
  FilterGroupBox.ItemIndex := -1;
  if Key = #13 then FilteredClick(Sender);
end;

procedure TADODBTest.FilterExit(Sender: TObject);
begin
  if Assigned(FActiveDataSet) then
    ActiveDataSet.Filter := Filter.Text;
end;

procedure TADODBTest.FilteredClick(Sender: TObject);
begin
  if Filtered.Checked then
    ActiveDataSet.Filter := Filter.Text;
  ActiveDataSet.Filtered := Filtered.Checked;
end;

procedure TADODBTest.FindFirstClick(Sender: TObject);
begin
  ActiveDataSet.Filter := Filter.Text;
  ActiveDataSet.FindFirst;
end;

procedure TADODBTest.FindNextClick(Sender: TObject);
begin
  if ActiveDataSet.Filter <> Filter.Text then
    ActiveDataSet.Filter := Filter.Text;
  ActiveDataSet.FindNext;
end;

procedure TADODBTest.FilterGroupBoxClick(Sender: TObject);
begin
  if not Assigned(ADOSource) then Exit;
  case FilterGroupBox.ItemIndex of
    0: ADOSource.FilterGroup := fgPendingRecords;
    1: ADOSource.FilterGroup := fgAffectedRecords;
    2: ADOSource.FilterGroup := fgFetchedRecords;
    3: ADOSource.FilterGroup := fgPendingRecords;
  else
    ADOSource.FilterGroup := fgNone;
  end;
end;


{ Locate }

procedure TADODBTest.LocatePageShow(Sender: TObject);
var
  Field: TField;
begin
  if (FActiveDataSet <> nil) and ActiveDataSet.Active then
  begin
    Field := MasterGrid.SelectedField;
    if LocateField.Items.Count = 0 then
      LocateFieldDropDown(LocateField);
    if (LocateField.Text = '') or (LocateField.Items.IndexOf(Field.FieldName) < 1) then
      LocateField.Text := Field.FieldName;
    with ActiveDataSet do
    try
      DisableControls;
      MoveBy(3);
      LocateEdit.Text := VarToStr(Field.Value);
      First;
    finally
      EnableControls;
    end;
  end;
end;

procedure TADODBTest.LocateFieldDropDown(Sender: TObject);
begin
  ActiveDataSet.GetFieldNames(LocateField.Items);
end;

procedure TADODBTest.LocateButtonClick(Sender: TObject);

  function LocateValue: Variant;
  var
    I: Integer;
    Values: TStringList;
  begin
    if LocateNull.Checked then
      Result := Null
    else if Pos(',', LocateEdit.Text) < 1 then
      LocateValue := LocateEdit.Text
    else
    begin
      Values := TStringList.Create;
      try
        Values.CommaText := LocateEdit.Text;
        Result := VarArrayCreate([0,Values.Count-1], varVariant);
        for I := 0 to Values.Count - 1 do
          Result[I] := Values[I];
      finally
        Values.Free;
      end;
    end;
  end;

var
  Options: TLocateOptions;
begin
  Options := [];
  if locPartialKey.Checked then Include(Options, loPartialKey);
  if ActiveDataSet.Locate(LocateField.Text, LocateValue, Options) then
    StatusMsg := 'Record Found' else
    StatusMsg := 'Not found';
end;

procedure TADODBTest.LocateNullClick(Sender: TObject);
begin
  LocateEdit.Enabled := not LocateNull.Checked;
end;

{ Midas Testing }

procedure TADODBTest.ADOButtonClick(Sender: TObject);
begin
  ActiveDataSet := ADOSource;
end;

procedure TADODBTest.MidasButtonClick(Sender: TObject);
begin
  if Assigned(ADOSource) or MasterClientData.Active then
    ActiveDataSet := MasterClientData;
end;

procedure TADODBTest.MidasApplyUpdatesExecute(Sender: TObject);
begin
  StatusMsg := 'ApplyUpdates: '+ IntToStr(MasterClientData.ApplyUpdates(-1));
  Beep;
end;

procedure TADODBTest.MidasCancelUpdatesExecute(Sender: TObject);
begin
  MasterClientData.CancelUpdates;
  StatusMsg := 'Updates canceled';
end;

procedure TADODBTest.MasterClientDataReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  Action := HandleReconcileError(DataSet, UpdateKind, E);
end;

{ FieldSchema }

procedure TADODBTest.FieldsPageShow(Sender: TObject);
begin
  CheckConnection(False);
  Connection.OpenSchema(siColumns, VarArrayOf([Unassigned, Unassigned, MasterTableName.Text, Unassigned]), EmptyParam, FieldSchema);
end;

procedure TADODBTest.FieldSchemaDATA_TYPEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  case FieldSchemaData_TYPE.Value of
    $00000000: Text := 'adEmpty';
    $00000010: Text := 'adTinyInt';
    $00000002: Text := 'adSmallInt';
    $00000003: Text := 'adInteger';
    $00000014: Text := 'adBigInt';
    $00000011: Text := 'adUnsignedTinyInt';
    $00000012: Text := 'adUnsignedSmallInt';
    $00000013: Text := 'adUnsignedInt';
    $00000015: Text := 'adUnsignedBigInt';
    $00000004: Text := 'adSingle';
    $00000005: Text := 'adDouble';
    $00000006: Text := 'adCurrency';
    $0000000E: Text := 'adDecimal';
    $00000083: Text := 'adNumeric';
    $0000000B: Text := 'adBoolean';
    $0000000A: Text := 'adError';
    $00000084: Text := 'adUserDefined';
    $0000000C: Text := 'adVariant';
    $00000009: Text := 'adIDispatch';
    $0000000D: Text := 'adIUnknown';
    $00000048: Text := 'adGUID';
    $00000007: Text := 'adDate';
    $00000085: Text := 'adDBDate';
    $00000086: Text := 'adDBTime';
    $00000087: Text := 'adDBTimeStamp';
    $00000008: Text := 'adBSTR';
    $00000081: Text := 'adChar';
    $000000C8: Text := 'adVarChar';
    $000000C9: Text := 'adLongVarChar';
    $00000082: Text := 'adWChar';
    $000000CA: Text := 'adVarWChar';
    $000000CB: Text := 'adLongVarWChar';
    $00000080: Text := 'adBinary';
    $000000CC: Text := 'adVarBinary';
    $000000CD: Text := 'adLongVarBinary';
    $00000088: Text := 'adChapter';
    $00000040: Text := 'adFileTime';
    $00000089: Text := 'adDBFileTime';
    $0000008A: Text := 'adPropVariant';
    $0000008B: Text := 'adVarNumeric';
  else
    Text := '<Unknown>';
  end;

end;

{ Event Logging }

procedure TADODBTest.LogEvent(const EventStr: string;
  Component: TComponent = nil);
var
  ItemCount: Integer;
begin
  if (csDestroying in ComponentState) or not Events.Visible then Exit;
  if (Component <> nil) and (Component.Name <> '') then
    Events.Items.Add(Format('%s(%s)', [EventStr, Component.Name])) else
    Events.Items.Add(EventStr);
  ItemCount := Events.Items.Count;
  Events.ItemIndex := ItemCount - 1;
  if ItemCount > (Events.ClientHeight div Events.ItemHeight) then
    Events.TopIndex := ItemCount - 1;
end;

procedure TADODBTest.ClearEventLogExecute(Sender: TObject);
begin
  Events.Items.Clear;
end;

procedure TADODBTest.ClearEventLogUpdate(Sender: TObject);
begin
  ClearEventLog.Enabled := Events.Visible and (Events.Items.Count > 0);
end;

procedure TADODBTest.SetRecordSetEvents(Hook: Boolean; DataSet: TCustomADODataSet);
begin
  if Hook then
  begin
    DataSet.OnFetchComplete := DataSetFetchComplete;
    DataSet.OnFetchProgress := DataSetFetchProgress;
  end
  else
  begin
    DataSet.OnFetchComplete := nil;
    DataSet.OnFetchProgress := nil;
  end;
end;

procedure TADODBTest.DataSetBeforeClose(DataSet: TDataSet);
begin
  LogEvent('BeforeClose');
end;

procedure TADODBTest.DataSetAfterScroll(DataSet: TDataSet);
begin
  LogEvent('AfterScroll', DataSet);
end;

procedure TADODBTest.DataSetBeforeCancel(DataSet: TDataSet);
begin
  LogEvent('BeforeCancel');
end;

procedure TADODBTest.DataSetBeforeDelete(DataSet: TDataSet);
begin
  LogEvent('BeforeDelete', DataSet);
end;

procedure TADODBTest.DataSetBeforeEdit(DataSet: TDataSet);
begin
  LogEvent('BeforeEdit', DataSet);
end;

procedure TADODBTest.DataSetBeforeInsert(DataSet: TDataSet);
begin
  LogEvent('BeforeInsert', DataSet);
end;

procedure TADODBTest.DataSetBeforePost(DataSet: TDataSet);
begin
  LogEvent('BeforePost', DataSet);
end;

procedure TADODBTest.DataSetBeforeScroll(DataSet: TDataSet);
begin
  LogEvent('BeforeScroll', DataSet);
end;

procedure TADODBTest.DataSetCalcFields(DataSet: TDataSet);
begin
  LogEvent('OnCalcFields', DataSet);
end;

procedure TADODBTest.DataSetError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  LogEvent('OnDelete/OnEdit/OnPost Errors', DataSet);
end;

procedure TADODBTest.DataSetNewRecord(DataSet: TDataSet);
begin
  LogEvent('OnNewRecord', DataSet);
end;

procedure TADODBTest.DataSetAfterPost(DataSet: TDataSet);
begin
  LogEvent('AfterPost', DataSet);
end;

procedure TADODBTest.DataSetAfterInsert(DataSet: TDataSet);
begin
  LogEvent('AfterInsert', DataSet);
end;

procedure TADODBTest.DataSetAfterEdit(DataSet: TDataSet);
begin
  LogEvent('AfterEdit', DataSet);
end;

procedure TADODBTest.DataSetAfterDelete(DataSet: TDataSet);
begin
  LogEvent('AfterDelete', DataSet);
end;

procedure TADODBTest.DataSetAfterCancel(DataSet: TDataSet);
begin
  LogEvent('AfterCancel', DataSet);
end;

procedure TADODBTest.DataSourceStateChange(Sender: TObject);
begin
  LogEvent('OnStateChange', Sender as TComponent);
end;

procedure TADODBTest.DataSourceUpdateData(Sender: TObject);
begin
  LogEvent('OnUpdateData', Sender as TComponent);
end;

procedure TADODBTest.MasterTableBeforeScroll(DataSet: TDataSet);
begin
  LogEvent('BeforeScroll', DataSet);
end;

procedure TADODBTest.MasterTableAfterScroll(DataSet: TDataSet);
begin
  LogEvent('AfterScroll', DataSet);
end;

procedure TADODBTest.OnFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := (DataSet.Fields[0].AsInteger = 2);
end;

procedure TADODBTest.DataSetFetchProgress(DataSet: TCustomADODataSet;
  Progress, MaxProgress: Integer; var EventStatus: TEventStatus);
begin
  LogEvent(Format('FetchProgress: %d of %d', [Progress, MaxProgress]), DataSet);
end;

procedure TADODBTest.FieldValidate(Sender: TField);
begin
  LogEvent(Format('Val: %s=%s', [Sender.DisplayName, Sender.AsSTring]));
end;

{ Connection Events }

procedure TADODBTest.ConnectionBeginTransComplete(
  Connection: TADOConnection; TransactionLevel: Integer;
  const Error: Error; var EventStatus: TEventStatus);
begin
  LogEvent('BeginTransComplete', Connection);
end;

procedure TADODBTest.ConnectionCommitTransComplete(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
begin
  LogEvent('CommitTransComplete', Connection);
end;

procedure TADODBTest.ConnectionConnectComplete(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
begin
  ClearProgressBar;
  LogEvent('ConnectComplete', Connection);
end;

procedure TADODBTest.ConnectionDisconnect(Connection: TADOConnection;
  var EventStatus: TEventStatus);
begin
  LogEvent('Disconnect', Connection);
end;

procedure TADODBTest.ConnectionExecuteComplete(Connection: TADOConnection;
  RecordsAffected: Integer; const Error: Error;
  var EventStatus: TEventStatus; const Command: _Command;
  const Recordset: _Recordset);
begin
  LogEvent('ExecuteComplete', Connection);
end;

procedure TADODBTest.ConnectionInfoMessage(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
begin
  LogEvent('InfoMessage', Connection);
end;

procedure TADODBTest.ConnectionRollbackTransComplete(
  Connection: TADOConnection; const Error: Error;
  var EventStatus: TEventStatus);
begin
  LogEvent('RollbackTransComplete', Connection);
end;

procedure TADODBTest.ConnectionWillConnect(Connection: TADOConnection;
  var ConnectionString, UserID, Password: WideString;
  var ConnectOptions: TConnectOption; var EventStatus: TEventStatus);
begin
  LogEvent('WillConnect', Connection);
end;

procedure TADODBTest.ConnectionWillExecute(Connection: TADOConnection;
  var CommandText: WideString; var CursorType: TCursorType;
  var LockType: TADOLockType; var CommandType: TCommandType;
  var ExecuteOptions: TExecuteOptions; var EventStatus: TEventStatus;
  const Command: _Command; const Recordset: _Recordset);
begin
  LogEvent('WillExecute', Connection);
end;

procedure TADODBTest.ConnectionLogin(Sender: TObject; Username,
  Password: String);
begin
  LogEvent(Format('OnLogin - UID: %s PWD: %s',[UserName, Password]), Sender as TADOConnection);
end;

{ Parameters }

procedure TADODBTest.ParameterSourceClick(Sender: TObject);
begin
  if SQLParams.Checked then
    FParamSource := MasterQuery.Parameters else
    FParamSource := MasterProc.Parameters;
  if not Showing then Exit;
  UpdateParameterList;
end;

procedure TADODBTest.RefreshParameters(Parameters: TParameters);
var
  I: Integer;
  NewParameter: TParameter;
begin
  try
    Parameters.Refresh;
  except
  end;
  if Parameters.Count = 0 then Exit;
  for I := 0 to Parameters.Count - 1 do
    with Parameters[I] do
      if Name[1] = '@' then
      begin
        NewParameter := Parameters.CreateParameter(Copy(Name, 2, 100), DataType, Direction, Size, Null);
        NewParameter.Index := I;
        Parameters[I].Free;
      end;
end;

procedure TADODBTest.ParamPageShow(Sender: TObject);
var
  FT: TFieldType;
begin
  if ParameterType.Items.Count = 0 then
    with ParameterType.Items do
      for FT := low(TFieldType) to high(TFieldType) do
        Add(FieldTypeNames[FT]);
end;

procedure TADODBTest.UpdateParameterList;
var
  I: Integer;
begin
  with ParameterList.Items do
  try
    BeginUpdate;
    Clear;
    for I := 0 to FParamSource.Count - 1 do
      Add(FParamSource[I].DisplayName);
    if ParameterList.Items.Count > 0 then
    begin
      if FModifiedParameter > -1 then
        ParameterList.ItemIndex := FModifiedParameter else
        ParameterList.ItemIndex := 0;
      ParameterListClick(ParameterList);
    end else
    begin
      ParameterName.Text := '';
      ParameterValue.Text := '';
    end;
  finally
    EndUpdate;
  end;
end;

procedure TADODBTest.RefreshParametersButtonClick(Sender: TObject);
begin
  CheckConnection(False);
  if SQLParams.Checked then
    MasterQuery.SQL.Text := MasterSQL.Text else
    MasterProc.ProcedureName := MasterProcName.Text;
  RefreshParameters(FParamSource);
  UpdateParameterList;
end;

procedure TADODBTest.AddParameterButtonClick(Sender: TObject);
begin
  FParamSource.CreateParameter('Param'+IntToStr(FParamSource.Count+1), ftInteger, pdInput, 0, 0);
  FModifiedParameter := -1;
  UpdateParameterList;
end;

procedure TADODBTest.ParameterListClick(Sender: TObject);
begin
  WriteParameterData;
  if ParameterList.ItemIndex < 0 then Exit;
  with FParamSource[ParameterList.ItemIndex] do
  begin
    ParameterName.Text := Name;
    ParameterValue.Text := VarToStr(Value);
    ParameterType.Text := FieldTypeNames[DataType];
    ParameterSize.Text := IntToStr(Size);
    ParameterScale.Text := IntToStr(NumericScale);
    ParameterPrecision.Text := IntToStr(Precision);
    ParameterDirectionGroup.ItemIndex := Ord(Direction)-1;
    PANullableCheckbox.Checked := paNullable in Attributes;
    PALongCheckbox.Checked := paLong in Attributes;
    PASignedCheckbox.Checked := paSigned in Attributes;
  end;
  FModifiedParameter := -1;
end;

procedure TADODBTest.WriteParameterData;
var
  DataTypeIndex: Integer;
begin
  if FModifiedParameter < 0 then Exit;
  with FParamSource[FModifiedParameter] do
  begin
    if Name <> ParameterName.Text then
    begin
      Name := ParameterName.Text;
      ParameterList.Items[FModifiedParameter] := Name;
    end;
    DataTypeIndex := ParameterType.Items.IndexOf(ParameterType.Text);
    if DataTypeIndex <> -1 then
      DataType := TFieldtype(DataTypeIndex) else
      DataType := ftInteger;
    Size := StrToInt(ParameterSize.Text);
    NumericScale := StrToInt(ParameterScale.Text);
    Precision := StrToInt(ParameterPrecision.Text);
    Direction := TParameterDirection(ParameterDirectionGroup.ItemIndex+1);
    if PANullableCheckbox.Checked then
      Attributes := [paNullable];
    if PALongCheckbox.Checked then
      Attributes := Attributes + [paLong];
    if PASignedCheckbox.Checked then
      Attributes := Attributes + [paSigned];
    if VarToStr(Value) <> ParameterValue.Text then
      Value := ParameterValue.Text;
  end;
  FModifiedParameter := -1;
end;

procedure TADODBTest.ParameterDataChange(Sender: TObject);
begin
  FModifiedParameter := ParameterList.ItemIndex;
end;

procedure TADODBTest.MasterSQLChange(Sender: TObject);
begin
  ParameterList.Items.Clear;
end;

{ Test Code }

Function StringPad(InputStr, FillChar: String; StrLen: Integer;
   StrJustify: Boolean): String;
Var
   TempFill: String;
   Counter : Integer;
Begin
   If Not (Length(InputStr) = StrLen) Then Begin
     If Length(InputStr) > StrLen Then Begin
       InputStr := Copy(InputStr,1,StrLen) ;
     End
     Else Begin
       TempFill := '';
       For Counter := 1 To StrLen-Length(InputStr) Do Begin
         TempFill := TempFill + FillChar;
       End;
       If StrJustify Then Begin
         {Left Justified}
         InputStr := InputStr + TempFill;
       End
       Else Begin
         {Right Justified}
         InputStr := TempFill + InputStr ;
       End;
     End;
   End;
   Result:= InputStr;
End;


procedure TADODBTest.TestButtonClick(Sender: TObject);
var provlist: TStringlist;
    i: integer;
begin
  { Put your test code here... }
  provlist:= TStringlist.create;
  provlist.add('Get Provider Names');
  GetProviderNames(provlist);
  provlist.add('Get Provider Names');
  provlist.add('Get DataLink Files');
  GetDataLinkFiles(provlist, DataLinkDir);
  provlist.add('Provider DataLink Test Success!');

  for i:= 1 to provlist.count - 1 do
    maxform1.memo2.lines.add(StringPad(provlist[i],'-',55,True));
   //memo2.text:= provlist.text;
  //GetDataLinkFiles(provlist, DataLinkDir);
   provlist.Clear;
   provlist.Free;
end;

procedure TADODBTest.TestButtonClick2(Sender: TObject);
var provlist: TStringlist;
    i: integer;
begin
  { Put your test code here... }
  provlist:= TStringlist.create;
  provlist.add('Get Provider Names');
  GetProviderNames(provlist);
  provlist.add('Get Provider Names');
  provlist.add('Get DataLink Files');
  GetDataLinkFiles(provlist, DataLinkDir);
  provlist.add('Provider DataLink Test Success!');

  for i:= 1 to provlist.count - 1 do
    maxform1.memo2.lines.add(StringPad(provlist[i],'-',55,True));
    maxform1.memo2.lines.add('runtime: '+ maxform1.getperftime);

  //memo2.text:= provlist.text;
  //GetDataLinkFiles(provlist, DataLinkDir);
   provlist.Clear;
   provlist.Free;
end;


end.
