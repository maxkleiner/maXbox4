(******************************************************************************)
(*                                                                            *)
(*   Beispiel für die Übertragung von Binärdaten mit der Komponente TSerial   *)
(*                                                                            *)
(*   (c) 1998-2004 Rainer Reusch und Toolbox                                  *)
(*   (c) 1998-2004 Rainer Reusch und Computer & Literatur                     *)
(*                                                                            *)
(*   Borland Delphi 3.0, 4.0, 5.0, 6.0  to maXbox in D2007 max                *)
(*   Dynamic Calling of Objects   - exename in code!                                                                       *)
(******************************************************************************)

unit SerialUnit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Serial, SerDlgs, Buttons;

type
  TBuf = array[0..15] of byte;
  TLblArray = array[0..SizeOf(TBuf)-1] of TLabel;

  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    ButtonSetup: TButton;
    ButtonOpenClose: TButton;
    ButtonTransmitt: TButton;
    ButtonReceive: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    LabelTrmBuf: TLabel;
    LabelRecBuf: TLabel;
    GroupBox2: TGroupBox;
    LabelRefT: TLabel;
    GroupBox3: TGroupBox;
    LabelRefR: TLabel;
    //Serial1: TSerial;
    //SerExtDlg1: TSerComboBox;
    Timer1: TTimer;
    ButtonClose: TButton;
    ListBox1: TListBox;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtfreetext: TEdit;
    Label8: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    Button4: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonSetupClick(Sender: TObject);
    procedure ButtonOpenCloseClick(Sender: TObject);
    procedure ButtonTransmittClick(Sender: TObject);
    procedure ButtonReceiveClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure Serial1COMRemoved(Sender: TObject);
    procedure Button1OpenClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtfreetextChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);

  private
    { Private-Deklarationen }
    LabelTrm, LabelRec : TLblArray;
    RecBuf, TrmBuf : TBuf;
    serial1: TSerial;
    //SerExtDlg1: TSerPortComboBox
    SerPortComboBox1: TSerPortComboBox;
    SerBaudComboBox1: TSerBaudComboBox;
    SerDataBitsComboBox1: TSerDataBitsComboBox;
    SerDTRCheckBox1: TSerDTRCheckBox;
    SerHandshakeComboBox1: TSerHandshakeComboBox;
    SerParityBitComboBox1: TSerParityBitComboBox;
    SerRTSCheckBox1: TSerRTSCheckBox;
    SerStopBitsComboBox1: TSerStopBitsComboBox;

    procedure OnAdded(Sender: TObject);
    procedure OnRemoved(Sender: TObject);
    procedure ViewMsg(AMessage : string);
    procedure ViewBuf(var Buf : TBuf; var LblArray : TLblArray);
    procedure NewTrmData;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
  uses gsutils;

procedure TForm1.Serial1COMRemoved(Sender: TObject);
// Ereignis innerhalb TSerial
// die von der Komponente geöffnete Schnittstelle wurde entfernt
begin
  ViewMsg('Opened Interface has been moved');
end;

procedure TForm1.ViewMsg(AMessage : string);
// Meldung in ListBox anzeigen
begin
  ListBox1.Items.Add(AMessage);
  ListBox1.TopIndex:=ListBox1.TopIndex+1;
end;

procedure TForm1.OnAdded(Sender: TObject);
// COMManager-Ereignis
// eine serielle Schnittstelle ist dazu gekommen
begin
  ViewMsg('Added Interface on COMPort! ');
end;

procedure TForm1.OnRemoved(Sender: TObject);
// COMManager-Ereignis
// eine serielle Schnittstelle wurde entfernt
begin
  ViewMsg('Closed Interface on COMPort!');
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  i : integer;
begin
  serial1:= TSerial.Create(self);
  COMManager.CheckPorts(16);
  COMManager.OnPortAdded:= OnAdded;           // dazugekommene Schnittstelle
  COMManager.OnPortRemoved:= OnRemoved;       // entfernte Schnittstelle

 // SerPortComboBox1:= TSerPortComboBox.Create(self);
  //SerBaudComboBox1.InitList(1200,115200);    // verfügbare Baudraten festlegen
  SerPortComboBox1:= TSerPortComboBox.Create(self);
 
  with Serial1 do begin
    Baudrate:= 9600;
    DataBits:= db_8;
    BufSizeTrm:= 16384;
    BufSizeRec:= 16384;
    XOnChar:= #17;
    XOffChar:= #19;
    XOffLimit:= 8192;
    XOnLimit:= 512;
    ErrorChar:= '?';
    EofChar:= #26;
    EventChar:= #13;
    SyncEventHandling:= True;
    EnableEvents:= True;
    SyncWait:= True;
    COMPort:= 1;
    ThreadPriority:= tpNormal;
    OnCOMRemoved:= Serial1COMRemoved;
    //left:= 6;
    //top:= 96;
  end;

  SerBaudComboBox1:= TSerBaudComboBox.Create(self);
  //SerPortComboBox1.Serial:= Serial1;
  SerDataBitsComboBox1:= TSerDataBitsComboBox.Create(self);
  SerDTRCheckBox1:= TSerDTRCheckBox.Create(self);
  SerHandshakeComboBox1:= TSerHandshakeComboBox.Create(self);
  SerParityBitComboBox1:= TSerParityBitComboBox.Create(self);
  SerRTSCheckBox1:= TSerRTSCheckBox.Create(self);
  SerStopBitsComboBox1:= TSerStopBitsComboBox.Create(self);

  Randomize;
  for i:=0 to SizeOf(TBuf)-1 do begin
    LabelTrm[i]:=TLabel.Create(Self);
    with LabelTrm[i] do begin
      Parent:=GroupBox2;
      AutoSize:=false;
      Width:=14;
      Height:=13;
      Top:=LabelRefT.Top;
      Left:=LabelRefT.Left+16*i;
      Caption:='00';
    end;
    LabelRec[i]:=TLabel.Create(Self);
    with LabelRec[i] do begin
      Parent:=GroupBox3;
      AutoSize:=false;
      Width:=14;
      Height:=13;
      Top:=LabelRefR.Top;
      Left:=LabelRefR.Left+16*i;
      Caption:='00';
    end;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  //  a second monitor
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
   with SerPortComboBox1 do begin
    Serial:= Serial1;
    TabOrder:= 5;
    Left:= 8;
    Height:= 22;
    Top:= 24+15;
    Width:= 88;
    enabled:= true;
  end;
  SerPortComboBox1.UpdateList;
  with SerBaudComboBox1 do begin
    Serial:= Serial1;
    Text:= ' Baud';
    TabOrder:= 6;
    Left:= 128;
    Height:= 22;
    Top:= 24+15;
    Width:= 88;
    enabled:= true;
  end;
 SerBaudComboBox1.InitList(1200,115200);    // verfügbare Baudraten festlegen

  //SerBaudComboBox1.SetBounds(20,300,150, 30);
  //SerPortComboBox1.SetBounds(20,250, 150, 30);
 with SerDataBitsComboBox1 do begin
    Serial:= Serial1;
    Text:= ' Bit';
    Max:= db_8;
    TabOrder:= 7;
    Left:= 8;
    Height:= 22;
    Top:= 72+10;
    Width:= 88;
    enabled:= true;
    updateList;
  end;
  with SerStopBitsComboBox1 do begin
    Serial:= Serial1;
    Text:= ' Bit';
    TabOrder:= 8;
    Left:= 128;
    Height:= 22;
    Top:= 72+10;
    Width:= 88;
    enabled:= true;
    updateList;
  end;
  with SerParityBitComboBox1 do begin
    Serial:= Serial1;
    TabOrder:= 9;
    Left:= 9;
    Height:= 22;
    Top:= 120+10;
    Width:= 88;
    enabled:= true;
    updateList;
  end;
  with SerHandshakeComboBox1 do begin
    Serial:= Serial1;
    ViewNone:= True;
    ViewSoft:= True;
    ViewRTSCTS:= True;
    ViewDTRDSR:= True;
    TextNone:= 'none';
    TextSoft:= 'XOn/XOff';
    TextRTSCTS:= 'RTS/CTS';
    TextDTRDSR:= 'DTR/DSR';
    TabOrder:= 10;
    Left:= 128;
    Height:= 22;
    Top:= 120+10;
    Width:= 88;
    enabled:= true;
    updateList;
  end;
  with SerRTSCheckBox1 do begin
    Serial:= Serial1;
    Caption:= 'RTS activ';
    TabOrder:= 11;
    Left:= 9;
    Height:= 13;
    Top:= 160+10;
    Width:= 70;
  end;
  with SerDTRCheckBox1 do begin
    Serial:= Serial1;
    Caption:= 'DTR activ';
    TabOrder:= 12;
    Left:= 128;
    Height:= 13;
    Top:= 160+10;
    Width:= 70;
  end;


end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:= false;
  SerPortComboBox1.Free;
  Serial1.CloseComm; 
  Serial1.Active:= false;
  serial1.Free;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  for i:=0 to SizeOf(TBuf)-1 do begin
    LabelTrm[i].Free;
    LabelRec[i].Free;
  end;
end;

procedure TForm1.ViewBuf(var Buf : TBuf; var LblArray : TLblArray);
// Puffer-Inhalt anzeigen
var
  i : integer;
begin
  for i:=0 to SizeOf(TBuf)-1 do
    LblArray[i].Caption:=IntToHex(Buf[i],2);
end;

procedure TForm1.NewTrmData;
// Zufallszahlen für Senden
var
  i : integer;
begin
  for i:=0 to SizeOf(TBuf)-1 do TrmBuf[i]:=Random(256);
end;

procedure TForm1.ButtonSetupClick(Sender: TObject);
begin
  //SerExtDlg1.Show;
   with TSerStdDlg.create(self) do begin
     serial:= Serial1;
     Execute;
   end;
end;

procedure TForm1.ButtonOpenCloseClick(Sender: TObject);
begin
  if Serial1.Active then begin  // schließen
    Serial1.CloseComm;
    ButtonSetup.Enabled:=true;
    ButtonOpenClose.Caption:='&Open';
    ButtonTransmitt.Enabled:=false;
    ButtonReceive.Enabled:=false;
    Timer1.Enabled:=false;
    StatusBar1.SimpleText:='Interface has been closed';
  end
  else
  begin  // öffnen
    if Serial1.OpenComm then begin
      ButtonSetup.Enabled:=false;
      ButtonOpenClose.Caption:='Clo&se';
      ButtonTransmitt.Enabled:=true;
      ButtonReceive.Enabled:=true;
      Timer1.Enabled:=true;
      StatusBar1.SimpleText:='Interface is open';
    end
    else begin
      MessageBeep(0);
      StatusBar1.SimpleText:='Error during open Interface!';
    end;
  end;
end;

procedure TForm1.ButtonTransmittClick(Sender: TObject);
var
  n : integer;
begin
  NewTrmData;
  ViewBuf(TrmBuf,LabelTrm);
  n:=Serial1.TransmittData(TrmBuf,SizeOf(TrmBuf));
  LabelTrmBuf.Caption:=IntToStr(Serial1.BufTrm);
  StatusBar1.SimpleText:=IntToStr(n)+' Bytes send';
end;

procedure TForm1.edtfreetextChange(Sender: TObject);
var n: cardinal;
begin
  //for i:= 0 to 1 do Serial1.TransmittText(edtfreetext.Text);
   n:= Serial1.TransmittText(edtfreetext.Text);
   // n:= Serial1.TransmittData(edtfreetext.Text, sizeOff());
   LabelTrmBuf.Caption:=IntToStr(Serial1.BufTrm);
   StatusBar1.SimpleText:=IntToStr(n)+' Bytes send';
    ViewMsg('1 times Transmit of Free Message Data');
    ViewMsg(edtfreetext.Text)
end;

procedure TForm1.ButtonReceiveClick(Sender: TObject);
var
  n : integer;
begin
  n:=Serial1.BufRec;
  if n>SizeOf(RecBuf) then n:=SizeOf(RecBuf);
  n:=Serial1.ReceiveData(RecBuf,n);
  StatusBar1.SimpleText:=IntToStr(n)+' Bytes received';
  ViewBuf(RecBuf,LabelRec);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  LabelTrmBuf.Caption:= IntToStr(Serial1.BufTrm)+' Byte';
  LabelRecBuf.Caption:= IntToStr(Serial1.BufRec)+' Byte';
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
// wait for an own monitor
  if fileexists(ExtractFilePath(ParamStr(0))+'examples\488_AsyncTerminal2.txt') then
    S_ShellExecute(ExtractFilePath(ParamStr(0))+'maxbox4.exe',
        ExtractFilePath(ParamStr(0))+'examples\488_AsyncTerminal2.txt',seCmdOpen) else
   MessageDlg('Could not open monitor script: 488_AsyncTerminal2.txt, please verify script', mtWarning, [mbOK], 0);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  if fileexists(ExtractFilePath(ParamStr(0))+'examples\442_arduino.txt') then
    S_ShellExecute(ExtractFilePath(ParamStr(0))+'maxbox4.exe',
        ExtractFilePath(ParamStr(0))+'examples\442_arduino.txt',seCmdOpen) else
   MessageDlg('Could not open monitor script: 442_arduino.txt, please verify script', mtWarning, [mbOK], 0);
end;

procedure TForm1.Button1OpenClick(Sender: TObject);
begin
  if Serial1.OpenComm then  // Schnittstelle versuchen zu öffnen
    ViewMsg('Interface COM'+IntToStr(Serial1.COMPort)+' opened')
  else
    ViewMsg('Error by opening')
end;

procedure TForm1.Button2Click(Sender: TObject);
const
  s = 'TSerial 4.3 with Lazarus maXCom in maXbox -----   ';
var
  i : integer;
begin
  for i:= 1 to 15 do Serial1.TransmittText(s);
    ViewMsg('Transmit of Data');
    ViewMsg('15 x send: '+s)
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Serial1.CloseComm;
  ViewMsg('Interface COM closed')
end;

procedure TForm1.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

end.
