unit PrivateKey;

interface

// change bigintsv3 to V4  and i1.modpow(i3, i2)

uses
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Buttons, StdCtrls, ShellApi,UBigIntsV4,
  WinProcs,WinTypes, FileCtrl, MPlayer, Menus, ComCtrls, ActnList, jpeg;

type
  IntNo = record
    Low32, Hi32: DWORD;
  end;

type
  TMain = class(TForm)
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label19: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    GroupBox3: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label11: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    Label15: TLabel;
    ListView1: TListView;
    ProgressBar1: TProgressBar;
    GroupBox4: TGroupBox;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    GroupBox8: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Edit2: TEdit;
    Button4: TButton;
    GroupBox10: TGroupBox;
    Image1: TImage;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    GroupBox11: TGroupBox;
    Label20: TLabel;
    Label35: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Button6: TButton;
    Edit3: TEdit;
    Label43: TLabel;
    Edit4: TEdit;
    GroupBox7: TGroupBox;
    Label1: TLabel;
    GroupBox9: TGroupBox;
    Label36: TLabel;
    GroupBox12: TGroupBox;
    Label42: TLabel;
    Button5: TButton;
    Label2: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3ClickEncrypt(Sender: TObject);
    procedure Button4ClickDecrypt(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
          Selected: Boolean);
    procedure Button6ClickSign(Sender: TObject);


  private
    { Private-Deklarationen }
     myapp: string;
  public
    { Public-Deklarationen }
  end;

var
  abbruch: boolean;
  Main: TMain;
  q, p, e, n, phiN, d, loes, i, gef, progressC : integer;

implementation

uses IdHashSHA;

{$R *.DFM}

var MinIcon: TIcon;

function SHA1FromFile(const filename: string): string;
var
  SHA1: TIdHashSHA1;    fs : TFileStream;
begin
  SHA1 := TIdHashSHA1.Create;
  fs := TFileStream.Create(fileName, fmOpenRead OR fmShareDenyWrite);
  try
    //Result := SHA1.HashStringAsHex(fs);
    Result := SHA1.HashStreamAsHex(fs);
  finally
    SHA1.Free;
    fs.Free;
  end;
end;

procedure TMain.FormCreate(Sender: TObject);

begin
   p:=0;
   q:=0;
   main.DoubleBuffered:=true;
   abbruch:=false;
   MinIcon:=TIcon.Create;
   MinIcon.Handle:= LoadIcon(hInstance,'Icon_1');
   Application.Icon:= MinIcon;
   combobox2.text:= '59';
   label48.caption:= 'hash of exe';

   myapp:= ParamStr(0);
   label50.caption:= myapp;
   label48.caption:= SHA1fromfile(myapp);
end;


procedure TMain.Button1Click(Sender: TObject);

var
  itNewItem : TListItem;
  i1, i2, i3: TInteger;
  Time1: TTime;

begin
  groupbox2.Font.Style:=[fsbold];
  groupbox7.Font.Style:=[];
  groupbox9.Font.Style:=[];
  groupbox12.Font.Style:=[];

  q:=strtoint(combobox2.Text);
  p:=strtoint(combobox3.Text);
  edit1.Text:='';
  edit2.Text:='';
  edit3.Text:='';
  edit4.Text:='';
  label22.Caption:='-';
  label29.Caption:='-';
  label35.Caption:='-';
  button3.Enabled:=false;
  button4.Enabled:=false;
  if q = 0 then begin
      MessageDlg('Primnumber for "q" insert!', mtInformation,[mbOk], 0);
      exit;
    end;

  if p = 0 then begin
      MessageDlg('Primnumber for "p" insert!!', mtInformation,[mbOk], 0);
      exit;
    end;

  progressC:=1;
  abbruch:=false;

  n:=p*q;

  label13.Caption:=inttostr(n);
  label17.Caption:=inttostr(n);
  label6.Caption:=combobox1.text;
  label26.Caption:=inttostr(n);
  label33.Caption:=inttostr(n);
  label14.Caption:=combobox1.text;
  label27.Caption:=combobox1.text;
  label34.Caption:=combobox1.text;

  phiN:=(p-1)*(q-1);

  label18.Caption:=inttostr(phiN);
  e:=strtoint(combobox1.text);
  d:=1;
  progressbar1.Position:=1;
  ListView1.Items.clear;
  gef:=0;
  label10.Caption:=inttostr(gef);

  if phiN mod e = 0 then begin
      MessageDlg('Phi(N) must not be divisible by e, choose another Prime "p/q" or another "e"!', mtInformation,[mbOk], 0);
      exit;
    end;

  Time1:= Time;
  button2.Enabled:=true;
  button5.Enabled:=false;
  progressbar1.Position:=1;
  i1:= TInteger.create(0);
  i2:=TInteger.create(0);
  repeat
    begin
    i1.assign(e);
    i1.mult(d);
    //writeln('mul '+i1.tostring(normal)+' '+itoa(d+1)+' '+itoa(e))
    //i1.assignzero;
    //i1.free;
    //i2.assign(i1.converttoDecimalString(false));
    i2.Assign(i1);
    i2.modulo((phiN));
    //writeln('mod '+i2.tostring(normal)+' '+itoa(phin))

    loes:= strtoint(i2.converttoDecimalString(false));
     //loes:=e*d mod phiN;
     if loes=1 then begin
         inc(gef);
         label10.Caption:=inttostr(gef);
         itNewItem:= ListView1.Items.add;
         itNewItem.Caption := inttostr(d);
       end;
       application.ProcessMessages;
       inc(d);
       progressbar1.Position:=progressC div 1000;
       inc(progressC);
       if progressbar1.Position=100 then begin
           progressbar1.Position:=1;
           progressC:=1;
         end;
     end;
  until abbruch;
  application.ProcessMessages;
  label47.Caption:= Format('%d %s',[Trunc((Time-Time1)*24),FormatDateTime('"h runtime:" nn:ss:zzz',Time-Time1)]);
  button2.Enabled:=false;
  i1.Free; i2.Free;
end;

procedure TMain.Button7Click(Sender: TObject);

begin
  Close;
end;

procedure TMain.Button2Click(Sender: TObject);
begin
  button3.enabled:=true;
  button5.enabled:=true;
  button6.enabled:=true;
  Abbruch:=true;
  Groupbox5.enabled:=true;
  Groupbox11.enabled:=true;
end;

procedure TMain.Button5Click(Sender: TObject);
begin
  close;
end;

procedure TMain.Button3ClickEncrypt(Sender: TObject);

var
  i1,i2,i3:Tinteger;
   Time1: TTime;

begin
  groupbox2.Font.Style:=[];
  groupbox7.Font.Style:=[fsbold];
  groupbox9.Font.Style:=[];
  groupbox12.Font.Style:=[];
  button4.enabled:=true;
  if edit1.Text ='' then
    begin
      MessageDlg('Enter number to encrypt!!', mtInformation,[mbOk], 0);
      exit;
    end;

  Time1:= Time;
  i1:=TInteger.create(1);
  i2:=TInteger.create(1);
  i3:=TInteger.create(1);
  i1.assign(edit1.Text);
  //i1.pow(e);
  //i2.assign(inttostr(n));
  //i1.modulo(i2);
  i2.assign(inttostr(n));
  i3.assign(inttostr(e));  //combobox1.text
  i1.modpow(i3, i2);
  label22.caption:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
  i3.Free;
  Groupbox8.enabled:=true;
  label45.Caption:= Format('%d %s',[Trunc((Time-Time1)*24),FormatDateTime('"h runtime:" nn:ss:zzz',Time-Time1)])
end;

procedure TMain.Button4ClickDecrypt(Sender: TObject);

var
  e1:integer;
  i1,i2,i3:Tinteger;
  Time1: TTime;

begin
  groupbox2.Font.Style:=[];
  groupbox7.Font.Style:=[];
  groupbox9.Font.Style:=[fsbold];
  groupbox12.Font.Style:=[];

  if edit2.Text ='' then begin
      MessageDlg('Enter your "d" private!', mtInformation,[mbOk], 0);
      exit;
    end;

  Time1:= Time;
  i1:=TInteger.create(1);
  i2:=TInteger.create(1);
  i3:=TInteger.create(1);
  i1.assign(label22.caption);
  e1:=strtoint(edit2.Text);
  //i1.pow(e1);
  //i2.assign(inttostr(n));
  //i1.modulo(i2);
  i1.assign(label22.caption);
  e1:=strtoint(edit2.Text);
  i2.assign(inttostr(n));
  //writeln('n mod: '+i2.tostring(normal))
  i3.assign(edit2.Text);
  //writeln('pow: '+i3.tostring(normal))
  //i1.modulo(i2);
  //procedure ModPow(const I2, m: TInteger);
  i1.modpow(i3, i2);
  label29.caption:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
  i3.Free;
  Groupbox8.enabled:=true;
  label46.Caption:= Format('%d %s',[Trunc((Time-Time1)*24),FormatDateTime('"h runtime:" nn:ss:zzz',Time-Time1)])

end;

procedure TMain.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Button4.Enabled then
    begin
      edit2.Text:=item.Caption;
    end;
  if Button3.Enabled then
    begin
      edit4.Text:=item.Caption;
    end;
end;

procedure TMain.Button6ClickSign(Sender: TObject);

var
  i1,i2,i3:Tinteger;

begin
  groupbox2.Font.Style:=[];
  groupbox12.Font.Style:=[fsbold];
  groupbox7.Font.Style:=[];
  groupbox9.Font.Style:=[];


  if edit3.Text ='' then
    begin
      MessageDlg('Enter number to sign!', mtInformation,[mbOk], 0);
      exit;
    end;
  if edit4.Text ='' then
    begin
      MessageDlg('Enter your "d" private!', mtInformation,[mbOk], 0);
      exit;
    end;
  i1:=TInteger.create(1);
  i2:=TInteger.create(1);
  i3:=TInteger.create(1);
  i1.assign(edit3.Text);
  i3.assign(edit4.Text);
  i2.assign(inttostr(n));
  //i1.modulo(i2);
  i1.modpow(i3, i2);
  //i1.pow(strtoint(edit4.Text));
  //i2.assign(inttostr(n));
  //i1.modulo(i2);
  label35.caption:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
end;


end.
