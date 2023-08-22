unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Contnrs, XPMan;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    FlowPanel1: TFlowPanel;
    bExit: TButton;
    cboxFlowStyle: TComboBox;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    XPManifest1: TXPManifest;
    procedure FormDestroy(Sender: TObject);
    procedure cboxFlowStyleChange(Sender: TObject);
    procedure bExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FControlList: TObjectList;
    procedure CreateControls;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

const
  MAX_CTRLS = 60; // controls to create

  // String representation of the FlowStyles
  FlowStyles: array [TFlowStyle] of string = (
    'fsLeftRightTopBottom',
    'fsRightLeftTopBottom',
    'fsLeftRightBottomTop',
    'fsRightLeftBottomTop',
    'fsTopBottomLeftRight',
    'fsBottomTopLeftRight',
    'fsTopBottomRightLeft',
    'fsBottomTopRightLeft'
  );

procedure TMainForm.bExitClick(Sender: TObject);
begin
  close;
end;

procedure TMainForm.cboxFlowStyleChange(Sender: TObject);
begin
  FlowPanel1.FlowStyle := TFlowStyle(cboxFlowStyle.ItemIndex);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  s: string;
begin
  // container to hold the created controls
  // make the object list destroy the created controls
  FControlList := TObjectList.Create(True);
  // place all of the flowstyle strings into the combobox
  for s in FlowStyles do
    cboxFlowStyle.Items.Add(s);
  // if the flow style combobox has entries select the first one
  if cboxFlowStyle.Items.Count > 0 then
  begin
    cboxFlowStyle.ItemIndex := 0;
    CreateControls;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  // free the container of controls created
  FControlList.Free;
end;

procedure TMainForm.CreateControls;
var
  i: Integer;
  lEdit: TEdit;
begin
  FlowPanel1.FlowStyle := TFlowStyle(cboxFlowStyle.ItemIndex);
  FControlList.Clear;
  for i := 1 to MAX_CTRLS do
  begin
    lEdit := TEdit.Create(Self);
    lEdit.Parent := FlowPanel1;
    lEdit.Text := Format('Control %d', [i]);
    FControlList.Add(lEdit);
  end;
end;

end.
