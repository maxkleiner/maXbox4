unit SimplePortMain;

// for mX4

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, AfViewers, StdCtrls, AfPortControls, AfDataDispatcher,
  AfComPort;

type
  TPortForm1 = class(TForm)
    Panel1: TPanel;
    //AfTerminal1: TAfTerminal;
    //AfComPort1: TAfComPort;
    Button1: TButton;
    //AfPortRadioGroup1: TAfPortRadioGroup;
    procedure AfTerminal1SendChar(Sender: TObject; var Key: Char);
    procedure AfComPort1DataRecived(Sender: TObject; Count: Integer);
    procedure Button1Click(Sender: TObject);
    procedure AfPortRadioGroup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    AfTerminal1: TAfTerminal;
    AfComPort1: TAfComPort;
    AfPortRadioGroup1: TAfPortRadioGroup;

    { Public declarations }
  end;

var
  PortForm1: TPortForm1;

implementation

{$R *.DFM}

procedure TPortForm1.AfTerminal1SendChar(Sender: TObject; var Key: Char);
begin
  AfComPort1.WriteChar(Key);
end;

procedure TPortForm1.AfComPort1DataRecived(Sender: TObject; Count: Integer);
begin
  AfTerminal1.WriteString(AfComPort1.ReadString);
end;

procedure TPortForm1.Button1Click(Sender: TObject);
begin
  AfComPort1.ExecuteConfigDialog;
end;

procedure TPortForm1.FormCreate(Sender: TObject);
begin

  AfComPort1:= TAfComPort.Create(self);
   with AfComPort1 do begin
    BaudRate:= br4800;
    OnDataRecived:= AfComPort1DataRecived;
  end;

   AfPortRadioGroup1:= TAfPortRadioGroup.Create(self);
   with AfPortRadioGroup1 do begin
      parent:= Panel1;
      Left:= 8;
      Top:= 8;
      Width:= 89;
      Height:= 193;
      ComPort:= AfComPort1;
      MaxComPorts:= 8;
      Options:= [pcCheckExist, pcHighlightOpen];
      Caption:= '&Select Port';
      Show;
      //TabOrder = 1
      OnClick:= AfPortRadioGroup1Click;
    end;

  AfTerminal1:= TAfTerminal.create(self);
  with AfTerminal1 do begin
    parent:= self;
    Left:= 0;
    Top:= 0;
    Width:= 420;
    Height:= 352;
    Align:= alClient;
    CaretBlinkTime:= 500;
    LogName:= 'LOG.TXT';
    Options:= [];
    Show;
    OnSendChar:= AfTerminal1SendChar;

  end;

end;

procedure TPortForm1.FormDestroy(Sender: TObject);
begin
    AfTerminal1.FreeOnRelease;
    AfComPort1.Close;
    AfComPort1.FreeOnRelease;
    AfPortRadioGroup1.FreeOnRelease;
end;

procedure TPortForm1.AfPortRadioGroup1Click(Sender: TObject);
begin
  AfTerminal1.SetFocus;
end;

end.
