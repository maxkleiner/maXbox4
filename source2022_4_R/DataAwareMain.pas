unit DataAwareMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AfDataDispatcher, AfComPort, AfViewers, StdCtrls, ExtCtrls,
  AfPortControls;

type
  TAfMemo = class(TMemo)
  private
    FDataLink: TAfDataDispatcherLink;
    function GetDispatcher: TAfCustomDataDispatcher;
    procedure SetDispatcher(const Value: TAfCustomDataDispatcher);
    procedure OnNotify(Sender: TObject; EventKind: TAfDispEventKind);
  protected
    procedure KeyPress(var Key: Char); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Dispatcher: TAfCustomDataDispatcher read GetDispatcher write SetDispatcher;
  end;

  afTForm1 = class(TForm)
    AfComPort1: TAfComPort;
    AfDataDispatcher1: TAfDataDispatcher;
    Panel1: TPanel;
    AfPortComboBox1: TAfPortComboBox;
    ClearBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure AfPortComboBox1Change(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    AfMemo1, AfMemo2: TAfMemo;
  public
    { Public declarations }
  end;

var
  afForm1: afTForm1;

implementation

{$R *.DFM}

{ TAfMemo }

constructor TAfMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TAfDataDispatcherLink.Create;
  FDataLink.OnNotify := OnNotify;
  Font.Name := 'Courier New';
  Font.Size := 9;
  ScrollBars := ssBoth;
end;

destructor TAfMemo.Destroy;
begin
  FDataLink.Free;
  inherited Destroy;
end;

function TAfMemo.GetDispatcher: TAfCustomDataDispatcher;
begin
  Result := FDataLink.Dispatcher;
end;

procedure TAfMemo.KeyPress(var Key: Char);
begin
  if Assigned(Dispatcher) and (Key in [#08, #13, #32..#255]) then
    Dispatcher.WriteChar(Key);
  Key := #0;
end;

procedure TAfMemo.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and (AComponent = Dispatcher) then
    Dispatcher := nil;
end;

procedure TAfMemo.OnNotify(Sender: TObject; EventKind: TAfDispEventKind);
var
  S: String;
begin
  case EventKind of
    deClear:
      Lines.Clear;
    deData:
      begin
        Lines.BeginUpdate;
        SelLength := 0;
        S := FDataLink.Dispatcher.ReadString;
        while Length(S) + GetTextLen > 32768 do Lines.Delete(0);
        Lines.EndUpdate;
        SelStart := GetTextLen;
        SelText := S;
      end;
  end;
end;

procedure TAfMemo.SetDispatcher(const Value: TAfCustomDataDispatcher);
begin
  FDataLink.Dispatcher := Value;
end;


{ TForm1 }

procedure afTForm1.FormCreate(Sender: TObject);
begin
  AfMemo1 := TAfMemo.Create(Self);
  with AfMemo1 do
  begin
    Parent := Self;
    Align := alLeft;
    Width := Parent.Width div 2;
    Dispatcher := AfDataDispatcher1;
  end;
  AfMemo2 := TAfMemo.Create(Self);
  with AfMemo2 do
  begin
    Parent := Self;
    Align := alClient;
    Dispatcher := AfDataDispatcher1;
  end;
end;

procedure afTForm1.FormResize(Sender: TObject);
begin
  AfMemo1.Width := Width div 2;
end;

procedure afTForm1.AfPortComboBox1Change(Sender: TObject);
begin
  AfMemo1.SetFocus;
end;

procedure afTForm1.ClearBtnClick(Sender: TObject);
begin
  AfDataDispatcher1.Clear;
  AfMemo1.SetFocus;
end;

end.
