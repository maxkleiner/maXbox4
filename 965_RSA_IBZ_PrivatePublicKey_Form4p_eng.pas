unit PrivatePublicKey_RSA_Form2_Performance_ENG;

//Given an RSA key (n,e,d), construct a program to encrypt and decrypt plaintext messages strings.
//Purpose: Teaching and Train RSA  , #locs:2050
//#TODO: performance gain with BigPowMod(abig.Tostring(normal),__e, __n) in decrypt

interface

{uses
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Buttons, StdCtrls, ShellApi,UBigIntsV3,
  WinProcs,WinTypes, FileCtrl, MPlayer, Menus, ComCtrls, ActnList, jpeg; }

type
  IntNo = record
    Low32, Hi32: DWORD;
  end;

type
  TMain = TForm;
  var
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
    aMemo1: TMemo;
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


  //private
    { Private-Deklarationen }
 // public
    { Public-Deklarationen }
  //end;

var
  abbruch: boolean;
  Main: TMain;
  q, p, e, n, phiN, d, loes, i, gef, progressC : integer;

implementation

//{$R *.DFM}

Type TAprime = array[1..1000] of boolean;

///Type TAprime = array[1..N] of boolean;

procedure checkEratosthenes(var vprime: TAprime); 
var 
  i,k: LONGINT;
BEGIN
  FOR i:= 2 TO N DO vprime[i]:= TRUE;
  FOR i:= 2 TO trunc(sqrt(N)) DO BEGIN
    k:= i;
    IF vprime[i] = TRUE THEN REPEAT
      k:= k+i;
      if k < N then
      vprime[k]:= FALSE;
    UNTIL k >= N;
  END;
END;

//maXbox:
//050_pas_primetester_thieves.txt

procedure FormCreate(Sender: TObject);
begin
   p:=0;
   q:=0;
   main.DoubleBuffered:=true;
   abbruch:=false;
   writeln('form create call open...')
end;


procedure Button1Click(Sender: TObject);
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
  if q = 0 then  begin
      MessageDlg('Primnumber for "q" insert!', mtInformation,[mbOk], 0);
      exit;
    end;
  if p = 0 then begin
      MessageDlg('Primnumber for "p" insert!', mtInformation,[mbOk], 0);
      exit;
    end;
  progressC:=1; abbruch:=false;
  n:=p*q;

  label13.Caption:=inttostr(n);
  label17.Caption:=inttostr(n);
  label16.Caption:=combobox1.text;
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
    
  button2.Enabled:=true;
  button5.Enabled:=false;
  progressbar1.Position:=1;
  i1:= TInteger.create(1);
  i2:=TInteger.create(1);
  Time1:= Time;
  //i3:= TInteger.create(1);
  //i1.assign2(inttostr(e))
  //writeln('ft '+i1.tostring(normal))
  repeat            //euklid has to be changed to bigint
    begin
    //Multiply
    
    //i1.assign2(inttostr(e))
    i1.assign1(e)
    i1.mult1((d));
    //writeln('mul '+i1.tostring(normal)+' '+itoa(d+1)+' '+itoa(e))
    //i1.assignzero;  //i1.free;
    i2.assign(i1)
    i2.modulo1((phiN));
    //writeln('mod '+i2.tostring(normal)+' '+itoa(phin))
    
    loes:= strtoint(i2.tostring(normal))
    //writeln('loes '+inttostr(loes))
     //loes:=e*d mod phiN;
    // i1.assignzero;
     
     if loes=1 then begin
         inc(gef);
         label10.Caption:=inttostr(gef);
         itNewItem:= ListView1.Items.add;
         itNewItem.Caption := inttostr(d);
       end;
       application.ProcessMessages;
       inc(d);
       if d mod 100 = 0 then 
         label15.caption:= itoa(d)+' of Found "d":';
       progressbar1.Position:=progressC div 1000;
       inc(progressC);
       if progressbar1.Position=100 then begin
           progressbar1.Position:=1;
           progressC:=1;
         end;
     end;
  until abbruch;
  application.ProcessMessages;
  PrintF('%d %s',[Trunc((Time-Time1)*24),FormatDateTime('"h found runtime:" nn:ss:zzz',Time-Time1)])
  button2.Enabled:=false;
  i1.Free; i2.free; //i3.free;
end;

procedure Button7Click(Sender: TObject);
begin
  main.Close;
end;

procedure Button2Click(Sender: TObject);
begin
  button3.enabled:=true;
  button5.enabled:=true;
  button6.enabled:=true;
  Abbruch:=true;
  Groupbox5.enabled:=true;
  Groupbox11.enabled:=true;
end;

procedure Button5Click(Sender: TObject);
begin
  main.close;
end;

procedure Button3ClickEncrypt(Sender: TObject);
var
  i1,i2,i3:Tinteger;
  Time1: TTime;
begin
  groupbox2.Font.Style:=[];
  groupbox7.Font.Style:=[fsbold];
  groupbox9.Font.Style:=[];
  groupbox12.Font.Style:=[];
  button4.enabled:=true;
  if edit1.Text ='' then begin
      MessageDlg('Enter number to encrypt!', mtInformation,[mbOk], 0);
      exit;
    end;
  Time1:= Time;
  i1:=TInteger.create(1);
  i2:=TInteger.create(0);
  i3:=TInteger.create(0);
  i1.assign2(edit1.Text);
  //i1.pow(e);
  i2.assign2(inttostr(n));
  i3.assign2(inttostr(e));  //combobox1.text
  i1.modpow(i3, i2)
  label22.caption:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
  i3.free;
  Groupbox8.enabled:=true;
  PrintF('%d %s',[Trunc((Time-Time1)*24),FormatDateTime('"h runtime:" nn:ss:zzz',Time-Time1)])
end;

procedure Button4ClickDecrypt(Sender: TObject);

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
  i1.assign2(label22.caption);
  e1:=strtoint(edit2.Text);
  i2.assign2(inttostr(n));
  writeln('n mod: '+i2.tostring(normal))
  i3.assign2(edit2.Text)
  writeln('pow: '+i3.tostring(normal))
  //i1.modulo(i2);
  //procedure ModPow(const I2, m: TInteger);
  i1.modpow(i3, i2)
  label29.caption:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
  i3.free;
  Groupbox8.enabled:=true;
  PrintF('%d %s',[Trunc((Time-Time1)*24),FormatDateTime('"h runtime:" nn:ss:zzz',Time-Time1)])
end;

procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Button4.Enabled then begin
      edit2.Text:=item.Caption;
    end;
  if Button3.Enabled then begin
      edit4.Text:=item.Caption;
    end;
  Label16.caption:= item.Caption;  
end;

procedure Button6ClickSign(Sender: TObject);
var
  i1,i2,i3:Tinteger;
begin
  groupbox2.Font.Style:=[];
  groupbox12.Font.Style:=[fsbold];
  groupbox7.Font.Style:=[];
  groupbox9.Font.Style:=[];
  if edit3.Text ='' then begin
      MessageDlg('Enter number to sign!', mtInformation,[mbOk], 0);
      exit;
    end;
  if edit4.Text ='' then begin
      MessageDlg('Enter your "d" private!', mtInformation,[mbOk], 0);
      exit;
    end;
  i1:=TInteger.create(1);
  i2:=TInteger.create(1);
  i3:=TInteger.create(1);
  i1.assign2(edit3.Text);
  i3.assign2(edit4.Text);
  i2.assign2(inttostr(n));
  //i1.modulo(i2);
  i1.modpow(i3, i2)
  label35.caption:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
  i3.free;
end;

procedure buildRSAForm;
begin
 //object Main: TMain
  main:= Tmain.create(self)
  with main do begin
  Left := 395
  Top := 162
  Anchors := []
  //BorderStyle := bsDialog
  formStyle:= fsStayonTop;
  Caption := 'Computer Science Security by maXbox4 Scripting'
  ClientHeight := 707
  ClientWidth := 787
  Color := clMoneyGreen
  Font.Charset := DEFAULT_CHARSET
  Font.Color := clWindowText
  Font.Height := -11
  Font.Name := 'MS Sans Serif'
  Font.Style := []
  OldCreateOrder := True
  Position := poScreenCenter
  OnCreate := @FormCreate;
  PixelsPerInch := 96
  icon.loadfromresourcename(hinstance, 'XCRYPTO');
  Show;
  //TextHeight := 13
   FormCreate(self);
  end;
  Label2:= TLabel.create(main)
  with label2 do begin
  parent:= main;
    Left := 620
    Top := 611
    Width := 157
    Height := 13
    Caption := #169' Max Kleiner, BFH Dec. 2022'
  end;
  GroupBox5:= TGroupBox.create(main)
  with groupbox5 do begin
  parent:= main
    Left := 16; Top := 501
    Width := 377; height := 100
    Font.Style := [fsBold]
    Caption := 'Number to crypt < N';// Zahl verschl'#252'sseln < N'
    Enabled := False
    TabOrder := 0
    Label21:= TLabel.create(main)
    with label21 do begin
    parent:= groupbox5
      Left := 16
      Top := 28
      Width := 91
      Height := 13
      Caption := 'Number plaintext "m"'
    end;
    Label22:= TLabel.create(main)   //result of encrypt
    with label22 do begin
    parent:= groupbox5
      Left := 290
      Top := 65
      Width := 9
      Height := 25
      Caption := '-'
      Font.Charset := DEFAULT_CHARSET
      Font.Color := clWindowText
      Font.Height := -21
      Font.Name := 'MS Sans Serif'
      Font.Style := [fsBold]
      ParentFont := False
    end;
    Label23:= TLabel.create(main)
    with label23 do begin
    parent:= groupbox5
      Left := 176
      Top := 67
      Width := 111
      Height := 13
      Caption := 'Encrypted Num "c"'; //Verschl'#252'sselte Zahl "c"'
    end;
    Label24:= TLabel.create(main)
    with label24 do begin
    parent:= groupbox5
      Left := 16
      Top := 50
      Width := 6
      Height := 13
      Caption := 'n'
    end;
    Label25:= TLabel.create(main)
    with label25 do begin
    parent:= groupbox5
      Left := 16
      Top := 66
      Width := 6
      Height := 13
      Caption := 'e'
    end;
    Label26:= TLabel.create(main)
    with label26 do begin
    parent:= groupbox5
      Left := 77
      Top := 50
      Width := 6
      Height := 13
      Caption := '0'
    end;
    Label27:= TLabel.create(main)
    with label27 do begin
    parent:= groupbox5
      Left := 77
      Top := 66
      Width := 6
      Height := 13
      Caption := '0'
    end;
    Button3:= TButton.create(main)
    with button3 do begin
    parent:= groupbox5
      Left := 248
      Top := 22
      Width := 113
      Height := 25
      Caption := '&Encrypt'
      Enabled := False
      TabOrder := 0
      OnClick := @Button3ClickEncrypt
    end;
    Edit1:= TEdit.create(main)
    with edit1 do begin
    parent:= groupbox5
      text:= '3000';
      Left := 144
      Top := 24
      Width := 89
      Height := 21
      TabOrder := 1
    end;
  end;
  GroupBox6:= TGroupBox.create(main)
  with groupbox6 do begin
  parent:= main
    Left := 16
    Top := 245
    Width := 761
    Height := 252
    Caption := 'Compute RSA Keys...'
    TabOrder := 1
    GroupBox1:= TGroupBox.create(main)
     with groupbox1 do begin
      parent:= groupbox6
      Left := 16
      Top := 17
      Width := 737
      Height := 64
      Caption := 'Entered'
      TabOrder := 0
      Label3:= TLabel.create(main)
      with label3 do begin
       parent:= groupbox1;
        Left := 8
        Top := 24
        Width := 58
        Height := 13
        Caption := 'Prime "p"'
      end;
      Label4:= TLabel.create(main)
      with label4 do begin
       parent:= groupbox1;
        Left := 160
        Top := 24
        Width := 58
        Height := 13
        Caption := 'Prime "q"'
      end ;
      Label5:= TLabel.create(main)
      with label5 do begin
       parent:= groupbox1;
        Left := 329
        Top := 25
        Width := 287
        Height := 13
        Caption:='Exponents "e" 3/17/65537 have binary less zeros, more quality'
      end ;
      Label9:= TLabel.create(main)
      with label9 do begin
       parent:= groupbox1;
        Left := 559
        Top := 46
        Width := 167
        Height := 13
        Caption := 'phi(N) should not be divisible by e'
      end;
      ComboBox1:= TComboBox.create(main)
      with combobox1 do begin
      parent:= groupbox1
        Left := 647
        Top := 20
        Width := 66
        Height := 21
        TabOrder := 0
        Text:= '17'
        Items.add('3')
        items.add('17')
        items.add('65537')
      end;
      ComboBox2:= TComboBox.create(main)
      with combobox2 do begin
      parent:= groupbox1
        Left := 223
        Top := 20
        Width := 80
        Height := 21
        TabOrder := 1
        Text := '53'
        Items.add('2')
        Items.add('3')
          Items.add('5')
          Items.add('7')
          Items.add('11')
          Items.add('13')
          Items.add('17')
         Items.add('19')
         Items.add('23')
         Items.add('29')
         Items.add('31')
         Items.add('37')
         Items.add('41')
         Items.add('43')
         Items.add('47')
         Items.add('53')
         Items.add('59')
         Items.add('61')
         Items.add('67')
         Items.add('71')
         Items.add('73')
         Items.add('79')
         Items.add('83')
         Items.add('89')
         Items.add('97')
         Items.add('101')
         Items.add('103')
         Items.add('107')
         Items.add('109')
         Items.add('113')
         Items.add('127')
         Items.add('131')
         Items.add('137')
         Items.add('139')
         Items.add('149')
         Items.add('151')
         Items.add('157')
         Items.add('163')
         Items.add('167')
         Items.add('173')
         Items.add('179')
         Items.add('181')
         Items.add('191')
         Items.add('193')
         Items.add('197')
         Items.add('199')
         Items.add('211')
         Items.add('223')
         Items.add('227')
         Items.add('229')
         Items.add('233')
         Items.add('239')
         Items.add('241')
         Items.add('251')
         Items.add('257')
         Items.add('263')
         Items.add('269')
         Items.add('271')
         Items.add('277')
         Items.add('281')
         Items.add('283')
         Items.add('293')
         Items.add('307')
         Items.add('311')
         Items.add('313')
         Items.add('317')
         Items.add('331')
         Items.add('337')
         Items.add('347')
         Items.add('349')
         Items.add('353')
         Items.add('359')
         Items.add('367')
         Items.add('373')
         Items.add('379')
         Items.add('383')
         Items.add('389')
         Items.add('397')
         Items.add('401')
         Items.add('409')
         Items.add('419')
         Items.add('421')
         Items.add('431')
         Items.add('433')
         Items.add('439')
         Items.add('443')
         Items.add('449')
         Items.add('457')
         Items.add('461')
         Items.add('463')
         Items.add('467')
         Items.add('479')
         Items.add('487')
         Items.add('491')
         Items.add('499')
         Items.add('503')
         Items.add('509')
         Items.add('521')
         Items.add('523')
         Items.add('541')
         Items.add('547')
         Items.add('557')
         Items.add('563')
         Items.add('569')
         Items.add('571')
         Items.add('577')
         Items.add('587')
         Items.add('593')
         Items.add('599')
         Items.add('601')
         Items.add('607')
         Items.add('613')
         Items.add('617')
         Items.add('619')
         Items.add('631')
         Items.add('641')
         Items.add('643')
         Items.add('647')
         Items.add('653')
         Items.add('659')
         Items.add('661')
         Items.add('673')
         Items.add('677')
         Items.add('683')
         Items.add('691')
         Items.add('701')
         Items.add('709')
         Items.add('719')
         Items.add('727')
         Items.add('733')
         Items.add('739')
         Items.add('743')
         Items.add('751')
         Items.add('757')
         Items.add('761')
         Items.add('769')
         Items.add('773')
         Items.add('787')
         Items.add('797')
         Items.add('809')
         Items.add('811')
         Items.add('821')
         Items.add('823')
         Items.add('827')
         Items.add('829')
         Items.add('839')
         Items.add('853')
         Items.add('857')
         Items.add('859')
         Items.add('863')
         Items.add('877')
         Items.add('881')
         Items.add('883')
         Items.add('887')
         Items.add('907')
         Items.add('911')
         Items.add('919')
         Items.add('929')
         Items.add('937')
         Items.add('941')
         Items.add('947')
         Items.add('953')
         Items.add('967')
         Items.add('971')
         Items.add('977')
         Items.add('983')
         Items.add('991')
         Items.add('997')
      end;
      ComboBox3:= TComboBox.create(main)
      with combobox3 do begin
      parent:= groupbox1
        Left := 72
        Top := 20
        Width := 81
        Height := 21
        TabOrder := 2
        Text := '59';
        Items.add('2')
        Items.add('3')
          Items.add('5')
          Items.add('7')
          Items.add('11')
          Items.add('13')
          Items.add('17')
         Items.add('19')
         Items.add('23')
         Items.add('29')
         Items.add('31')
         Items.add('37')
         Items.add('41')
         Items.add('43')
         Items.add('47')
         Items.add('53')
         Items.add('59')
         Items.add('61')
         Items.add('67')
         Items.add('71')
         Items.add('73')
         Items.add('79')
         Items.add('83')
         Items.add('89')
         Items.add('97')
         Items.add('101')
         Items.add('103')
         Items.add('107')
         Items.add('109')
         Items.add('113')
         Items.add('127')
         Items.add('131')
         Items.add('137')
         Items.add('139')
         Items.add('149')
         Items.add('151')
         Items.add('157')
         Items.add('163')
         Items.add('167')
         Items.add('173')
         Items.add('179')
         Items.add('181')
         Items.add('191')
         Items.add('193')
         Items.add('197')
         Items.add('199')
         Items.add('211')
         Items.add('223')
         Items.add('227')
         Items.add('229')
         Items.add('233')
         Items.add('239')
         Items.add('241')
         Items.add('251')
         Items.add('257')
         Items.add('263')
         Items.add('269')
         Items.add('271')
         Items.add('277')
         Items.add('281')
         Items.add('283')
         Items.add('293')
         Items.add('307')
         Items.add('311')
         Items.add('313')
         Items.add('317')
         Items.add('331')
         Items.add('337')
         Items.add('347')
         Items.add('349')
         Items.add('353')
         Items.add('359')
         Items.add('367')
         Items.add('373')
         Items.add('379')
         Items.add('383')
         Items.add('389')
         Items.add('397')
         Items.add('401')
         Items.add('409')
         Items.add('419')
         Items.add('421')
         Items.add('431')
         Items.add('433')
         Items.add('439')
         Items.add('443')
         Items.add('449')
         Items.add('457')
         Items.add('461')
         Items.add('463')
         Items.add('467')
         Items.add('479')
         Items.add('487')
         Items.add('491')
         Items.add('499')
         Items.add('503')
         Items.add('509')
         Items.add('521')
         Items.add('523')
         Items.add('541')
         Items.add('547')
         Items.add('557')
         Items.add('563')
         Items.add('569')
         Items.add('571')
         Items.add('577')
         Items.add('587')
         Items.add('593')
         Items.add('599')
         Items.add('601')
         Items.add('607')
         Items.add('613')
         Items.add('617')
         Items.add('619')
         Items.add('631')
         Items.add('641')
         Items.add('643')
         Items.add('647')
         Items.add('653')
         Items.add('659')
         Items.add('661')
         Items.add('673')
         Items.add('677')
         Items.add('683')
         Items.add('691')
         Items.add('701')
         Items.add('709')
         Items.add('719')
         Items.add('727')
         Items.add('733')
         Items.add('739')
         Items.add('743')
         Items.add('751')
         Items.add('757')
         Items.add('761')
         Items.add('769')
         Items.add('773')
         Items.add('787')
         Items.add('797')
         Items.add('809')
         Items.add('811')
         Items.add('821')
         Items.add('823')
         Items.add('827')
         Items.add('829')
         Items.add('839')
         Items.add('853')
         Items.add('857')
         Items.add('859')
         Items.add('863')
         Items.add('877')
         Items.add('881')
         Items.add('883')
         Items.add('887')
         Items.add('907')
         Items.add('911')
         Items.add('919')
         Items.add('929')
         Items.add('937')
         Items.add('941')
         Items.add('947')
         Items.add('953')
         Items.add('967')
         Items.add('971')
         Items.add('977')
         Items.add('983')
         Items.add('991')
         Items.add('997')
      end;
    end;
    //object GroupBox3: TGroupBox
    GroupBox3:= TGroupBox.create(main)
    with groupbox3 do begin
      parent:= groupbox6
      Left := 336
      Top := 90
      Width := 417
      Height := 127
      Caption := 'Solutions'; //'L'#246'sungen'
      TabOrder := 1
      Label12:= TLabel.create(main)
      with label12 do begin
      parent:= groupbox3;
        Left := 10
        Top := 20
        Width := 178
        Height := 13
        Caption := 'Public Key consists of n and e:'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -11
        Font.Name := 'MS Sans Serif'
        Font.Style := [fsBold]
        ParentFont := False
      end;
      Label13:= TLabel.create(main)
      with label13 do begin
      parent:= groupbox3;
        Left := 203
        Top := 16
        Width := 9
        Height := 20
        Caption := 'n'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clRed
        Font.Height := -16
        Font.Name := 'MS Sans Serif'
        Font.Style := []
        ParentFont := False
      end;
      Label14:= TLabel.create(main)
      with label14 do begin
      parent:= groupbox3;
        Left := 271
        Top := 16
        Width := 9
        Height := 20
        Caption := 'e'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clRed
        Font.Height := -16
        Font.Name := 'MS Sans Serif'
        Font.Style := []
        ParentFont := False
      end;
      Label11:= TLabel.create(main)
      with label11 do begin
      parent:= groupbox3;
        Left := 10
        Top := 43
        Width := 183
        Height := 13
        Caption := 'Private Key consists of n and d:'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -11
        Font.Name := 'MS Sans Serif'
        Font.Style := [fsBold]
        ParentFont := False
      end;
      Label16:= TLabel.create(main)
      with label16 do begin
      parent:= groupbox3;
        Left := 203
        Top := 40
        Width := 9
        Height := 20
        Caption := 'n'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clRed
        Font.Height := -16
        Font.Name := 'MS Sans Serif'
        Font.Style := []
        ParentFont := False
      end;
      Label10:= TLabel.create(main)
      with label10 do begin
      parent:= groupbox3;
        Left := 160
        Top := 69
        Width := 6
        Height := 13
        Caption := '0'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clRed
        Font.Height := -11
        Font.Name := 'MS Sans Serif'
        Font.Style := []
        ParentFont := False
      end;
      Label15:= TLabel.create(main)
      with label15 do begin
      parent:= groupbox3;
        Left := 10
        Top := 69
        Width := 86
        Height := 13
        Caption := 'Found "d"'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -11
        Font.Name := 'MS Sans Serif'
        Font.Style := [fsBold]
        ParentFont := False
      end;
      ListView1:= TListView.create(main)
      //var nc: TListColumn;
      with listview1 do begin
      parent:= groupbox3;
        Left := 264
        Top := 40
        Width := 121
        Height := 77
        Columns.add
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -11
        Font.Name := 'MS Sans Serif'
        Font.Style := [fsBold]
        FlatScrollBars := True
        HotTrack := True
        HotTrackStyles := [htUnderlineCold]
        ParentFont := False
        TabOrder := 0
        ViewStyle := vsSmallIcon
        OnSelectItem := @ListView1SelectItem
      end;
      ProgressBar1:= TProgressBar.create(main)
      with progressbar1 do begin
       parent:= groupbox3;
        Left := 8
        Top := 88
        Width := 241
        Height := 17
        Smooth := True
        TabOrder := 1
      end;
    end;
    GroupBox4:= TGroupBox.create(main)
    with groupbox4 do begin
      parent:= groupbox6
      Left := 16
      Top := 90
      Width := 313
      Height := 127
      Caption := 'Primenumbers 1- 10'#39'000'
      TabOrder := 2
      aMemo1:= TMemo.create(main)
      with amemo1 do begin
       parent:= groupbox4
        Left := 8
        Top := 16
        Width := 297
        Height := 98;
        Lines.add('2'#9'3'#9'5'#9'7'#9'11'#9'13')
         Lines.add('17'#9'19'#9'23'#9'29'#9'31'#9'37')
         Lines.add('41'#9'43'#9'47'#9'53'#9'59'#9'61')
         Lines.add('67'#9'71'#9'73'#9'79'#9'83'#9'89')
         Lines.add('97'#9'101'#9'103'#9'107'#9'109'#9'113')
         Lines.add('127'#9'131'#9'137'#9'139'#9'149'#9'151')
         Lines.add('157'#9'163'#9'167'#9'173'#9'179'#9'181')
         Lines.add('191'#9'193'#9'197'#9'199'#9'211'#9'223')
         Lines.add('227'#9'229'#9'233'#9'239'#9'241'#9'251')
         Lines.add('257'#9'263'#9'269'#9'271'#9'277'#9'281')
         Lines.add('283'#9'293'#9'307'#9'311'#9'313'#9'317')
         Lines.add('331'#9'337'#9'347'#9'349'#9'353'#9'359')
         Lines.add('367'#9'373'#9'379'#9'383'#9'389'#9'397')
         Lines.add('401'#9'409'#9'419'#9'421'#9'431'#9'433')
         Lines.add('439'#9'443'#9'449'#9'457'#9'461'#9'463')
         Lines.add('467'#9'479'#9'487'#9'491'#9'499'#9'503')
         Lines.add('509'#9'521'#9'523'#9'541'#9'547'#9'557')
         Lines.add('563'#9'569'#9'571'#9'577'#9'587'#9'593')
         Lines.add('599'#9'601'#9'607'#9'613'#9'617'#9'619')
         Lines.add('631'#9'641'#9'643'#9'647'#9'653'#9'659')
         Lines.add('661'#9'673'#9'677'#9'683'#9'691'#9'701')
         Lines.add('709'#9'719'#9'727'#9'733'#9'739'#9'743')
         Lines.add('751'#9'757'#9'761'#9'769'#9'773'#9'787')
         Lines.add('797'#9'809'#9'811'#9'821'#9'823'#9'827')
         Lines.add('829'#9'839'#9'853'#9'857'#9'859'#9'863')
         Lines.add('877'#9'881'#9'883'#9'887'#9'907'#9'911')
         Lines.add('919'#9'929'#9'937'#9'941'#9'947'#9'953')
         Lines.add('967'#9'971'#9'977'#9'983'#9'991'#9'997')
         Lines.add('1009'#9'1013'#9'1019'#9'1021'#9'1031'#9'1033')
         Lines.add('1039'#9'1049'#9'1051'#9'1061'#9'1063'#9'1069')
         Lines.add('1087'#9'1091'#9'1093'#9'1097'#9'1103'#9'1109')
         Lines.add('1117'#9'1123'#9'1129'#9'1151'#9'1153'#9'1163')
         Lines.add('1171'#9'1181'#9'1187'#9'1193'#9'1201'#9'1213')
         Lines.add('1217'#9'1223'#9'1229'#9'1231'#9'1237'#9'1249')
         Lines.add('1259'#9'1277'#9'1279'#9'1283'#9'1289'#9'1291')
         Lines.add('1297'#9'1301'#9'1303'#9'1307'#9'1319'#9'1321')
         Lines.add('1327'#9'1361'#9'1367'#9'1373'#9'1381'#9'1399')
         Lines.add('1409'#9'1423'#9'1427'#9'1429'#9'1433'#9'1439')
         Lines.add('1447'#9'1451'#9'1453'#9'1459'#9'1471'#9'1481')
         Lines.add('1483'#9'1487'#9'1489'#9'1493'#9'1499'#9'1511')
         Lines.add('1523'#9'1531'#9'1543'#9'1549'#9'1553'#9'1559')
         Lines.add('1567'#9'1571'#9'1579'#9'1583'#9'1597'#9'1601')
         Lines.add('1607'#9'1609'#9'1613'#9'1619'#9'1621'#9'1627')
         Lines.add('1637'#9'1657'#9'1663'#9'1667'#9'1669'#9'1693')
         Lines.add('1697'#9'1699'#9'1709'#9'1721'#9'1723'#9'1733')
         Lines.add('1741'#9'1747'#9'1753'#9'1759'#9'1777'#9'1783')
         Lines.add('1787'#9'1789'#9'1801'#9'1811'#9'1823'#9'1831')
         Lines.add('1847'#9'1861'#9'1867'#9'1871'#9'1873'#9'1877')
         Lines.add('1879'#9'1889'#9'1901'#9'1907'#9'1913'#9'1931')
         Lines.add('1933'#9'1949'#9'1951'#9'1973'#9'1979'#9'1987')
         Lines.add('1993'#9'1997'#9'1999'#9'2003'#9'2011'#9'2017')
         Lines.add('2027'#9'2029'#9'2039'#9'2053'#9'2063'#9'2069')
         Lines.add('2081'#9'2083'#9'2087'#9'2089'#9'2099'#9'2111')
         Lines.add('2113'#9'2129'#9'2131'#9'2137'#9'2141'#9'2143')
         Lines.add('2153'#9'2161'#9'2179'#9'2203'#9'2207'#9'2213')
         Lines.add('2221'#9'2237'#9'2239'#9'2243'#9'2251'#9'2267')
         Lines.add('2269'#9'2273'#9'2281'#9'2287'#9'2293'#9'2297')
         Lines.add('2309'#9'2311'#9'2333'#9'2339'#9'2341'#9'2347')
         Lines.add('2351'#9'2357'#9'2371'#9'2377'#9'2381'#9'2383')
         Lines.add('2389'#9'2393'#9'2399'#9'2411'#9'2417'#9'2423')
         Lines.add('2437'#9'2441'#9'2447'#9'2459'#9'2467'#9'2473')
         Lines.add('2477'#9'2503'#9'2521'#9'2531'#9'2539'#9'2543')
         Lines.add('2549'#9'2551'#9'2557'#9'2579'#9'2591'#9'2593')
         Lines.add('2609'#9'2617'#9'2621'#9'2633'#9'2647'#9'2657')
         Lines.add('2659'#9'2663'#9'2671'#9'2677'#9'2683'#9'2687')
         Lines.add('2689'#9'2693'#9'2699'#9'2707'#9'2711'#9'2713')
         Lines.add('2719'#9'2729'#9'2731'#9'2741'#9'2749'#9'2753')
         Lines.add('2767'#9'2777'#9'2789'#9'2791'#9'2797'#9'2801')
         Lines.add('2803'#9'2819'#9'2833'#9'2837'#9'2843'#9'2851')
         Lines.add('2857'#9'2861'#9'2879'#9'2887'#9'2897'#9'2903')
         Lines.add('2909'#9'2917'#9'2927'#9'2939'#9'2953'#9'2957')
         Lines.add('2963'#9'2969'#9'2971'#9'2999'#9'3001'#9'3011')
         Lines.add('3019'#9'3023'#9'3037'#9'3041'#9'3049'#9'3061')
         Lines.add('3067'#9'3079'#9'3083'#9'3089'#9'3109'#9'3119')
         Lines.add('3121'#9'3137'#9'3163'#9'3167'#9'3169'#9'3181')
         Lines.add('3187'#9'3191'#9'3203'#9'3209'#9'3217'#9'3221')
         Lines.add('3229'#9'3251'#9'3253'#9'3257'#9'3259'#9'3271')
         Lines.add('3299'#9'3301'#9'3307'#9'3313'#9'3319'#9'3323')
         Lines.add('3329'#9'3331'#9'3343'#9'3347'#9'3359'#9'3361')
         Lines.add('3371'#9'3373'#9'3389'#9'3391'#9'3407'#9'3413')
         Lines.add('3433'#9'3449'#9'3457'#9'3461'#9'3463'#9'3467')
         Lines.add('3469'#9'3491'#9'3499'#9'3511'#9'3517'#9'3527')
         Lines.add('3529'#9'3533'#9'3539'#9'3541'#9'3547'#9'3557')
         Lines.add('3559'#9'3571'#9'3581'#9'3583'#9'3593'#9'3607')
         Lines.add('3613'#9'3617'#9'3623'#9'3631'#9'3637'#9'3643')
         Lines.add('3659'#9'3671'#9'3673'#9'3677'#9'3691'#9'3697')
         Lines.add('3701'#9'3709'#9'3719'#9'3727'#9'3733'#9'3739')
         Lines.add('3761'#9'3767'#9'3769'#9'3779'#9'3793'#9'3797')
         Lines.add('3803'#9'3821'#9'3823'#9'3833'#9'3847'#9'3851')
         Lines.add('3853'#9'3863'#9'3877'#9'3881'#9'3889'#9'3907')
         Lines.add('3911'#9'3917'#9'3919'#9'3923'#9'3929'#9'3931')
         Lines.add('3943'#9'3947'#9'3967'#9'3989'#9'4001'#9'4003')
         Lines.add('4007'#9'4013'#9'4019'#9'4021'#9'4027'#9'4049')
         Lines.add('4051'#9'4057'#9'4073'#9'4079'#9'4091'#9'4093')
         Lines.add('4099'#9'4111'#9'4127'#9'4129'#9'4133'#9'4139')
         Lines.add('4153'#9'4157'#9'4159'#9'4177'#9'4201'#9'4211')
         Lines.add('4217'#9'4219'#9'4229'#9'4231'#9'4241'#9'4243')
         Lines.add('4253'#9'4259'#9'4261'#9'4271'#9'4273'#9'4283')
         Lines.add('4289'#9'4297'#9'4327'#9'4337'#9'4339'#9'4349')
         Lines.add('4357'#9'4363'#9'4373'#9'4391'#9'4397'#9'4409')
         Lines.add('4421'#9'4423'#9'4441'#9'4447'#9'4451'#9'4457')
         Lines.add('4463'#9'4481'#9'4483'#9'4493'#9'4507'#9'4513')
         Lines.add('4517'#9'4519'#9'4523'#9'4547'#9'4549'#9'4561')
         Lines.add('4567'#9'4583'#9'4591'#9'4597'#9'4603'#9'4621')
         Lines.add('4637'#9'4639'#9'4643'#9'4649'#9'4651'#9'4657')
         Lines.add('4663'#9'4673'#9'4679'#9'4691'#9'4703'#9'4721')
         Lines.add('4723'#9'4729'#9'4733'#9'4751'#9'4759'#9'4783')
         Lines.add('4787'#9'4789'#9'4793'#9'4799'#9'4801'#9'4813')
         Lines.add('4817'#9'4831'#9'4861'#9'4871'#9'4877'#9'4889')
         Lines.add('4903'#9'4909'#9'4919'#9'4931'#9'4933'#9'4937')
         Lines.add('4943'#9'4951'#9'4957'#9'4967'#9'4969'#9'4973')
         Lines.add('4987'#9'4993'#9'4999'#9'5003'#9'5009'#9'5011')
         Lines.add('5021'#9'5023'#9'5039'#9'5051'#9'5059'#9'5077')
         Lines.add('5081'#9'5087'#9'5099'#9'5101'#9'5107'#9'5113')
         Lines.add('5119'#9'5147'#9'5153'#9'5167'#9'5171'#9'5179')
         Lines.add('5189'#9'5197'#9'5209'#9'5227'#9'5231'#9'5233')
         Lines.add('5237'#9'5261'#9'5273'#9'5279'#9'5281'#9'5297')
         Lines.add('5303'#9'5309'#9'5323'#9'5333'#9'5347'#9'5351')
         Lines.add('5381'#9'5387'#9'5393'#9'5399'#9'5407'#9'5413')
         Lines.add('5417'#9'5419'#9'5431'#9'5437'#9'5441'#9'5443')
         Lines.add('5449'#9'5471'#9'5477'#9'5479'#9'5483'#9'5501')
         Lines.add('5503'#9'5507'#9'5519'#9'5521'#9'5527'#9'5531')
         Lines.add('5557'#9'5563'#9'5569'#9'5573'#9'5581'#9'5591')
         Lines.add('5623'#9'5639'#9'5641'#9'5647'#9'5651'#9'5653')
         Lines.add('5657'#9'5659'#9'5669'#9'5683'#9'5689'#9'5693')
         Lines.add('5701'#9'5711'#9'5717'#9'5737'#9'5741'#9'5743')
         Lines.add('5749'#9'5779'#9'5783'#9'5791'#9'5801'#9'5807')
         Lines.add('5813'#9'5821'#9'5827'#9'5839'#9'5843'#9'5849')
         Lines.add('5851'#9'5857'#9'5861'#9'5867'#9'5869'#9'5879')
         Lines.add('5881'#9'5897'#9'5903'#9'5923'#9'5927'#9'5939')
         Lines.add('5953'#9'5981'#9'5987'#9'6007'#9'6011'#9'6029')
         Lines.add('6037'#9'6043'#9'6047'#9'6053'#9'6067'#9'6073')
         Lines.add('6079'#9'6089'#9'6091'#9'6101'#9'6113'#9'6121')
         Lines.add('6131'#9'6133'#9'6143'#9'6151'#9'6163'#9'6173')
         Lines.add('6197'#9'6199'#9'6203'#9'6211'#9'6217'#9'6221')
         Lines.add('6229'#9'6247'#9'6257'#9'6263'#9'6269'#9'6271')
         Lines.add('6277'#9'6287'#9'6299'#9'6301'#9'6311'#9'6317')
         Lines.add('6323'#9'6329'#9'6337'#9'6343'#9'6353'#9'6359')
         Lines.add('6361'#9'6367'#9'6373'#9'6379'#9'6389'#9'6397')
         Lines.add('6421'#9'6427'#9'6449'#9'6451'#9'6469'#9'6473')
         Lines.add('6481'#9'6491'#9'6521'#9'6529'#9'6547'#9'6551')
         Lines.add('6553'#9'6563'#9'6569'#9'6571'#9'6577'#9'6581')
         Lines.add('6599'#9'6607'#9'6619'#9'6637'#9'6653'#9'6659')
         Lines.add('6661'#9'6673'#9'6679'#9'6689'#9'6691'#9'6701')
         Lines.add('6703'#9'6709'#9'6719'#9'6733'#9'6737'#9'6761')
         Lines.add('6763'#9'6779'#9'6781'#9'6791'#9'6793'#9'6803')
         Lines.add('6823'#9'6827'#9'6829'#9'6833'#9'6841'#9'6857')
         Lines.add('6863'#9'6869'#9'6871'#9'6883'#9'6899'#9'6907')
         Lines.add('6911'#9'6917'#9'6947'#9'6949'#9'6959'#9'6961')
         Lines.add('6967'#9'6971'#9'6977'#9'6983'#9'6991'#9'6997')
         Lines.add('7001'#9'7013'#9'7019'#9'7027'#9'7039'#9'7043')
         Lines.add('7057'#9'7069'#9'7079'#9'7103'#9'7109'#9'7121')
         Lines.add('7127'#9'7129'#9'7151'#9'7159'#9'7177'#9'7187')
         Lines.add('7193'#9'7207'#9'7211'#9'7213'#9'7219'#9'7229')
         Lines.add('7237'#9'7243'#9'7247'#9'7253'#9'7283'#9'7297')
         Lines.add('7307'#9'7309'#9'7321'#9'7331'#9'7333'#9'7349')
         Lines.add('7351'#9'7369'#9'7393'#9'7411'#9'7417'#9'7433')
         Lines.add('7451'#9'7457'#9'7459'#9'7477'#9'7481'#9'7487')
         Lines.add('7489'#9'7499'#9'7507'#9'7517'#9'7523'#9'7529')
         Lines.add('7537'#9'7541'#9'7547'#9'7549'#9'7559'#9'7561')
         Lines.add('7573'#9'7577'#9'7583'#9'7589'#9'7591'#9'7603')
         Lines.add('7607'#9'7621'#9'7639'#9'7643'#9'7649'#9'7669')
         Lines.add('7673'#9'7681'#9'7687'#9'7691'#9'7699'#9'7703')
         Lines.add('7717'#9'7723'#9'7727'#9'7741'#9'7753'#9'7757')
         Lines.add('7759'#9'7789'#9'7793'#9'7817'#9'7823'#9'7829')
         Lines.add('7841'#9'7853'#9'7867'#9'7873'#9'7877'#9'7879')
         Lines.add('7883'#9'7901'#9'7907'#9'7919'#9'7927'#9'7933')
         Lines.add('7937'#9'7949'#9'7951'#9'7963'#9'7993'#9'8009')
         Lines.add('8011'#9'8017'#9'8039'#9'8053'#9'8059'#9'8069')
         Lines.add('8081'#9'8087'#9'8089'#9'8093'#9'8101'#9'8111')
         Lines.add('8117'#9'8123'#9'8147'#9'8161'#9'8167'#9'8171')
         Lines.add('8179'#9'8191'#9'8209'#9'8219'#9'8221'#9'8231')
         Lines.add('8233'#9'8237'#9'8243'#9'8263'#9'8269'#9'8273')
         Lines.add('8287'#9'8291'#9'8293'#9'8297'#9'8311'#9'8317')
         Lines.add('8329'#9'8353'#9'8363'#9'8369'#9'8377'#9'8387')
         Lines.add('8389'#9'8419'#9'8423'#9'8429'#9'8431'#9'8443')
         Lines.add('8447'#9'8461'#9'8467'#9'8501'#9'8513'#9'8521')
         Lines.add('8527'#9'8537'#9'8539'#9'8543'#9'8563'#9'8573')
         Lines.add('8581'#9'8597'#9'8599'#9'8609'#9'8623'#9'8627')
         Lines.add('8629'#9'8641'#9'8647'#9'8663'#9'8669'#9'8677')
         Lines.add('8681'#9'8689'#9'8693'#9'8699'#9'8707'#9'8713')
         Lines.add('8719'#9'8731'#9'8737'#9'8741'#9'8747'#9'8753')
         Lines.add('8761'#9'8779'#9'8783'#9'8803'#9'8807'#9'8819')
         Lines.add('8821'#9'8831'#9'8837'#9'8839'#9'8849'#9'8861')
         Lines.add('8863'#9'8867'#9'8887'#9'8893'#9'8923'#9'8929')
         Lines.add('8933'#9'8941'#9'8951'#9'8963'#9'8969'#9'8971')
         Lines.add('8999'#9'9001'#9'9007'#9'9011'#9'9013'#9'9029')
         Lines.add('9041'#9'9043'#9'9049'#9'9059'#9'9067'#9'9091')
         Lines.add('9103'#9'9109'#9'9127'#9'9133'#9'9137'#9'9151')
         Lines.add('9157'#9'9161'#9'9173'#9'9181'#9'9187'#9'9199')
         Lines.add('9203'#9'9209'#9'9221'#9'9227'#9'9239'#9'9241')
         Lines.add('9257'#9'9277'#9'9281'#9'9283'#9'9293'#9'9311')
         Lines.add('9319'#9'9323'#9'9337'#9'9341'#9'9343'#9'9349')
         Lines.add('9371'#9'9377'#9'9391'#9'9397'#9'9403'#9'9413')
         Lines.add('9419'#9'9421'#9'9431'#9'9433'#9'9437'#9'9439')
         Lines.add('9461'#9'9463'#9'9467'#9'9473'#9'9479'#9'9491')
         Lines.add('9497'#9'9511'#9'9521'#9'9533'#9'9539'#9'9547')
         Lines.add('9551'#9'9587'#9'9601'#9'9613'#9'9619'#9'9623')
         Lines.add('9629'#9'9631'#9'9643'#9'9649'#9'9661'#9'9677')
         Lines.add('9679'#9'9689'#9'9697'#9'9719'#9'9721'#9'9733')
         Lines.add('9739'#9'9743'#9'9749'#9'9767'#9'9769'#9'9781')
         Lines.add('9787'#9'9791'#9'9803'#9'9811'#9'9817'#9'9829')
         Lines.add('9833'#9'9839'#9'9851'#9'9857'#9'9859'#9'9871')
         Lines.add('9883'#9'9887'#9'9901'#9'9907'#9'9923'#9'9929')
         Lines.add('9931'#9'9941'#9'9949'#9'9967'#9'9973')
        ScrollBars := ssVertical
        TabOrder := 0
      end;
    end;
    Button1:= TButton.create(main)
    with button1 do begin
    parent:= groupbox6;
      Left := 16; Top := 222
      Width := 180; Height := 25
      Caption := '&Compute Private Key d'
      Font.Charset := DEFAULT_CHARSET
      Font.Color := clWindowText
      Font.Height := -11
      Font.Name := 'MS Sans Serif'
      Font.Style := []
      ParentFont := False
      TabOrder := 3
      OnClick := @Button1Click
    end;
    Button2:= TButton.create(main)
    with button2 do begin
    parent:= groupbox6;
      Left := 208
      Top := 222
      Width := 180
      Height := 25
      Caption:= 'Pause and show &results'
      Enabled := False
      TabOrder := 4
      OnClick := @Button2Click
    end;
  end;
  GroupBox8:= TGroupBox.create(main)
  with groupbox8 do begin
  parent:= main
    Left := 400
    Top := 501
    Width := 377
    Height := 100
    Caption := 'Decrypt Number'; //Zahl entschl'#252'sseln'
    Enabled := False
    TabOrder := 2
    Label28:= TLabel.create(main)
    with label28 do begin
    parent:= groupbox8
      Left := 184
      Top := 67
      Width := 91
      Height := 13
      Caption := 'Number in plaintext "k"'
    end;
    Label29:= TLabel.create(main)
    with label29 do begin
    parent:= groupbox8
      Left := 295
      Top := 65
      Width := 9
      Height := 25
      Caption := '-'
      Font.Charset := DEFAULT_CHARSET
      Font.Color := clWindowText
      Font.Height := -21
      Font.Name := 'MS Sans Serif'
      Font.Style := [fsBold]
      ParentFont := False
    end ;
    Label30:= TLabel.create(main)
    with label30 do begin
    parent:= groupbox8
      Left := 16
      Top := 28
      Width := 69
      Height := 13
      Caption := 'Choosen "d"';//Gew'#228'hltes "d"'
    end;
   Label31:= TLabel.create(main)
    with label31 do begin
    parent:= groupbox8
      Left := 16
      Top := 49
      Width := 6
      Height := 13
      Caption := 'n'
    end;
    Label32:= TLabel.create(main)
    with label32 do begin
    parent:= groupbox8
      Left := 16
      Top := 65
      Width := 6
      Height := 13
      Caption := 'e'
    end;
    Label33:= TLabel.create(main)
    with label33 do begin
    parent:= groupbox8
      Left := 72
      Top := 49
      Width := 6
      Height := 13
      Caption := '0'
    end;
    Label34:= TLabel.create(main)
    with label34 do begin
    parent:= groupbox8
      Left := 72
      Top := 65
      Width := 6
      Height := 13
      Caption := '0'
    end;
    Edit2:= TEdit.create(main)
    with edit2 do begin
    parent:= groupbox8
      Left := 144
      Top := 24
      Width := 89
      Height := 21
      TabOrder := 0
    end;
    Button4:= TButton.create(main)
    with button4 do begin
    parent:= groupbox8
      Left := 248
      Top := 22
      Width := 113
      Height := 25
      Caption := '&Decrypt'
      Enabled := False
      TabOrder := 1
      OnClick := @Button4ClickDecrypt
    end;
  end;
 GroupBox10:= TGroupBox.create(main)
  with groupbox10 do begin
  parent:= main
    Left := 16
    Top := 10
    Width := 761
    Height := 231
    Caption := 'Crypto System RSA 2 Process'
    TabOrder := 3
    font.size:= 11;
    Image1:= TImage.create(main)
    with image1 do begin
    parent:= groupbox10
      Left := 100; Top := 25
      Width := 360
      Height := 200
      //Picture.Data := //{
      Picture.bitmap.LoadFromResourceName(hinstance, 'CITYMAX')
      Stretch := True
    end;
    GroupBox2:= TGroupBox.create(main)
    with groupbox2 do begin
    parent:= groupbox10
      Left := 560
      Top := 9
      Width := 177
      Height := 89
      Caption := 'Formulas RSA Keys:'
      Font.Charset := DEFAULT_CHARSET
      Font.Color := clWindowText
      Font.Height := -11
      Font.Name := 'MS Sans Serif'
      Font.Style := []
      ParentFont := False
      TabOrder := 0
      Label7:= TLabel.create(main)
      with label7 do begin
      parent:= groupbox2;
        Left := 7
        Top := 16
        Width := 28
        Height := 13
        Caption := 'n=[p*q]'
      end;
      Label8:= TLabel.create(main)
      with label8 do begin
      parent:= groupbox2;
        Left := 8
        Top := 36
        Width := 78
        Height := 13
        Caption := 'phi(n) = (p-)*(q-1)'
      end;
      Label9:= TLabel.create(main)
      with label9 do begin
      parent:= groupbox2;
        Left := 8
        Top := 56
        Width := 94
        Height := 13
        Caption := 'd=e^1(mod phi(n))'
      end;
      Label16:= TLabel.create(main)
      with label16 do begin
      parent:= groupbox2;
        Left := 9
        Top := 73
        Width := 80
        Height := 13
        Caption := '1=e*d mod phi(n)'
      end;
      Label17:= TLabel.create(main)
      with label17 do begin
      parent:= groupbox2;
        Left := 51
        Top := 17
        Width := 6
        Height := 13
        Caption := 'n'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clRed
        Font.Height := -11
        Font.Name := 'MS Sans Serif'
        Font.Style := []
        ParentFont := False
      end;
      Label18:= TLabel.create(main)
      with label18 do begin
      parent:= groupbox2;
        Left := 116
        Top := 36
        Width := 55
        Height := 13
        Caption := 'phi(N) Euler'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clRed
        Font.Height := -11
        Font.Name := 'MS Sans Serif'
        Font.Style := []
        ParentFont := False
      end;
      Label44:= TLabel.create(main)
      with label44 do begin
      parent:= groupbox2;
      //object Label44: TLabel
        Left := 116
        Top := 56
        Width := 29
        Height := 13
        Caption := 'Euklid'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clRed
        Font.Height := -11
        Font.Name := 'MS Sans Serif'
        Font.Style := []
        ParentFont := False
      end;
    end;
    GroupBox7:= TGroupBox.create(main)
    with groupbox7 do begin
    parent:= groupbox10
      Left := 560
      Top := 104
      Width := 177
      Height := 41
      Caption := 'Equation to encrypt:'
      TabOrder := 1
      Label1:= TLabel.create(main)
      with label1 do begin
      parent:= groupbox7;
        Left := 7
        Top := 16
        Width := 68
        Height := 13
        Caption := 'c = m ^ e mod n'
      end;
    end;
    GroupBox9:= TGroupBox.create(main)
    with groupbox9 do begin
    parent:= groupbox10
      Left := 560
      Top := 144
      Width := 177
      Height := 41
      Caption := 'Equation to decrypt:'
      TabOrder := 2
      Label36:= TLabel.create(main)
      with label36 do begin
      parent:= groupbox9
        Left := 8
        Top := 20
        Width := 65
        Height := 13
        Caption := 'm = c^ d mod n'
      end;
    end;
    GroupBox12:= TGroupBox.create(main)
    with groupbox12 do begin
    parent:= groupbox10
      Left := 560
      Top := 190
      Width := 177
      Height := 41
      Caption := 'Equation to sign hash:'
      TabOrder := 3
      Label42:= TLabel.create(main)
      with label42 do begin
      parent:= groupbox12;
        Left := 7
        Top := 20
        Width := 64
        Height := 13
        Caption := 's = h^ d mod n'
      end;
    end;
  end;
  GroupBox11:= TGroupBox.create(main)
  with groupbox11 do begin
    parent:= main
    Left := 16
    Top := 605
    Width := 601
    Height := 92
    Caption := 'Hash to sign'
    Enabled := False
    TabOrder := 4
    Label20:= TLabel.create(main)
    with label20 do begin
    parent:= groupbox11;
      Left := 16
      Top := 28
      Width := 91
      Height := 13
      Caption := 'Number in plaintext "h"'
    end;
    Label35:= TLabel.create(main)
    with label35 do begin
    parent:= groupbox11;
      Left := 303
      Top := 65
      Width := 9
      Height := 25
      Caption := '-'
      Font.Charset := DEFAULT_CHARSET
      Font.Color := clWindowText
      Font.Height := -21
      Font.Name := 'MS Sans Serif'
      Font.Style := [fsBold]
      ParentFont := False
    end;
    Label37:= TLabel.create(main)
    with label37 do begin
    parent:= groupbox11;
      Left := 176
      Top := 67
      Width := 83
      Height := 13
      Caption := 'Signed Number "s"'
    end;
    Label38:= TLabel.create(main)
    with label38 do begin
    parent:= groupbox11;
      Left := 16
      Top := 50
      Width := 6
      Height := 13
      Caption := 'n'
    end;
    Label39:= TLabel.create(main)
    with label39 do begin
    parent:= groupbox11;
      Left := 16
      Top := 66
      Width := 6
      Height := 13
      Caption := 'e'
    end;
    Label40:= TLabel.create(main)
    with label40 do begin
    parent:= groupbox11;
      Left := 77
      Top := 50
      Width := 6
      Height := 13
      Caption := '0'
    end;
    Label41:= TLabel.create(main)
    with label41 do begin
    parent:= groupbox11;
      Left := 77
      Top := 66
      Width := 6
      Height := 13
      Caption := '0'
    end;
    Label43:= TLabel.create(main)
    with label43 do begin
    parent:= groupbox11;
      Left := 264
      Top := 28
      Width := 69
      Height := 13
      Caption := 'Choosen "d"'
    end;
    Button6:= TButton.create(main)
    with button6 do begin
    parent:= groupbox11;
      Left := 456
      Top := 22
      Width := 113
      Height := 25
      Caption := '&Sign'
      Enabled := False
      TabOrder := 0
      OnClick := @Button6ClickSign;
    end;
    Edit3:= TEdit.create(main)
    with edit3 do begin
    parent:= groupbox11;
      Left := 144
      Top := 24
      Width := 89
      Height := 21
      TabOrder := 1
    end;
    Edit4:= TEdit.create(main)
    with edit4 do begin
    parent:= groupbox11;
      Left := 352
      Top := 24
      Width := 89
      Height := 21
      TabOrder := 2
    end;
  end;
  Button5:= TButton.create(main)
  with button5 do begin
  parent:= main;
    Left := 656
    Top := 664
    Width := 113
    Height := 25
    Caption := '&Close'
    TabOrder := 5
    OnClick := @Button5Click
  end; //*)
end;


const hx='0123456789ABCDEF';

function IHEX(x:Double): string; //Returns hex number as right-justified string
var i,k,a,mx:Integer;
y,Z,a1:currency;
 s:string;
 hxs: array[0..15] of string;
begin

Y:=abs(X);    //Make sure target decimal is not a negative number
mx:=0;    //Count number of hex digits derived from conversion

repeat
  z:= y / 16;   // Divide the decimal number by base 16
  a:=Trunc(z);  // Get integer part of dividend
  if z>=16 then  begin  //If integer dividend greater than 16
    a1:=16 * Frac(z);//Get the dividend carry-over
    k:=Trunc(a1);    // Base 16 left-to-right placement digit
    If k<=9 then hxs[mx]:=IntToStr(k) //if hex digit greater than 9,
       else
        hxs[mx]:=hx[k+1];        //get hex alpha digit
    mx:=mx+1;           //increment hex digit placement
    y:=a;               //Replace decimal with current dividend result
  end;
  if z<16 then begin          //When dividend less than 16,
   a1:=16 * Frac(z);        //get dividend carry-over
    k:=Trunc(a1);           //Base 16 left-to-right placement digit
    If k<=9 then hxs[mx]:=IntToStr(k) //If hex digit greater than 9,
       else
        hxs[mx]:=hx[k+1];        //get hex alpha digit
    mx:=mx+1;            //increment hex digit placement
    y:=a;                //Replace decimal with current dividend result
  end;
until y<16;             //When loop ends, last hex digit derived from division

If a<=9 then hxs[mx]:=IntToStr(a)  //If last hex digit greater than 9,
       else
        hxs[mx]:=hx[a+1];       //get hex alpha digit
//Pull HEX digits from placement array in reverse order to create HEX number
 s:='';
 i:=mx;
   repeat
     s:=s + hxs[i];
     i:=i-1;
   until i<0;
   s:=s+'H';
 //Format HEX number as seven characters RIGHT-JUSTIFIED
  repeat
   k:=Length(s);
     if k<7 then s:='0'+s;
   until Length(s)>=7;
 Result:=s;
end;

function DecimalToHex4(const Dec: AnsiString): AnsiString;
var
  ResultArray: array of byte;
  n, i: Integer;
  val, digit: Byte;
  c: AnsiChar;
begin
  SetLength(ResultArray, Trunc(Length(Dec) * Ln(10) / Ln(16)) + 1);
  n := 0;
  //for c in Dec do
  for it:= 1 to length(dec) do begin
    c:= dec[it]
    //['0','1','2','3','4','5','6','7','8','9']
   // Assert(CharInSet2(c, strtocharset(numbers)),'must be numbers');
    Assert(CharInSet2(c,['0','1','2','3','4','5','6','7','8','9']),'must be numbers');
    val := ord(c) - ord('0');
    for i := 0 to n  do begin
      digit := ResultArray[i] * 10 + val;
      ResultArray[i] := digit and $0F;
      val := digit shr 4;
    end;
    if val <> 0 then begin
      inc(n);
      ResultArray[n]:= val;
    end;
  end;
  Result := '';
  //for digit in ResultArray  do
  for it:= 0 to length(resultarray)-1 do begin
    digit:= resultarray[it]
    Result := AnsiString('0123456789ABCDEF')[digit+1]+ Result;
  end;  
end;

function ConvertHex(HexString : string; Len : integer) : String;
begin
if trim(HexString) = '' then Result := '0' else
  Result := IntToStr(StrToInt('$' + trim(HexString)));
   while length(Result) < Len do Result := '0' + Result;
end;

const SomeBigNumber=1234567890123456789;
var S:String; SomeBigNumber2, SomeBigNumber3:UInt64;

procedure bignumbertesthex;
begin
  SomeBigNumber3:=  SomeBigNumber;
  WriteLn(inttostr64(SomeBigNumber3));
  S := '$'+IntToHex64(SomeBigNumber3, 40);
  Writeln('As Hex: '+(S));
  Writeln('');
  Writeln('Now let''s convert it back...');
  SomeBigNumber2 := StrToInt64(S);
  Writeln(inttostr64(SomeBigNumber2));
  //ReadLn;
end;

FUNCTION ascii2hex(s: STRING): STRING;
	VAR i,l: CARDINAL;
	BEGIN
		result := '';
			l := Length(s);
			FOR i := 1 TO l DO
				result:=result + Dec2Numb(ord(s[i]),2,16);
	END;
	
FUNCTION hex2ascii(s: STRING): STRING;
	VAR i,l: CARDINAL;
	BEGIN
		result := '';
			l := Length(s);
			FOR i := 1 TO l DO
				//result:=result + chr(Dec2Numb(ord(s[i]),4,16));
	END;	
	
// Converts String To Hexadecimal Maybe usefull for a hex-editor
// For example: Input = 'ABCD' Output = '41 42 43 44'
function StringtoHex(Data: string): string;
var i, i2: Integer; s: string;
begin
  i2 := 1;
  for i := 1 to Length(Data) do begin
    Inc(i2);
    if i2 = 2 then 
      s  := s + ' ';  i2 := 1;
      s := s + IntToHex(Ord(Data[i]), 2);
  end;
  Result := s;
end;	

var abt: boolean;

//http://rosettacode.org/wiki/RSA_code#Python  - message to 18 signs 

const _n = '9516311845790656153499716760847001433441357';    //# p*q = modulus
      _e = '65537';
      _d = '5617843187844953170308463622230283376298685';
      
var message, s_encrypt, s_decrypt: string;
    hexmess, bigstr2, __e, __n, __d, shash: string;
    var abig: TInteger;
        bigstr: TBytes;
        time1: TTime; DT : TDateTime;

begin  //@main

{srlist:= TStringlist.create;
if LoadDFMFile2Strings('C:\maXbox\softwareschule\IBZ_2016\IBZ_IT_Security_2016\DVD Inhalt\RSA Berechnung\PrivateKey.dfm',srlist, abt)= 0 then
    writeln(srlist.text);
    srlist.Free;   // }
    
    //encrypt: m^e mod n = 9^7 mod 143 =48=c;
    //decrypt: c^d mod n = 48^103 mod 143 =9=m;
    
  message:='Rosetta Code!';
  print('message                 '+message)  
  
  writeln('hex data: '+strtoHex1(message))
  writeln(Hextostr(strtoHex1(message)))
  hexmess:= strtoHex1(message)
   
  abig:= TInteger.create(1);
  abig.Assignhex(hexmess);
  writeln('big plain text integer: '+abig.Tostring(normal))
  //writeln(asciitohex(hexmess));

  s_encrypt:= BigPowMod(abig.Tostring(normal),_e, _n)    //bigmulu(ap,aq));
  writeln('encrypted text integer '+s_encrypt)
  s_decrypt:= BigPowMod(s_encrypt,_d,_n)                 //bigmulu(ap,aq))
  writeln('decrypted text integer '+s_decrypt)
  
  abig.Assign2(s_decrypt);
  writeln('decrypt message: '+Hextostr(abig.ConvertToHexString))
  abig.Free;
  
 { bignumbertesthex;
  writeln(DecimalToHex4('526736574746120436646521'))
  writeln(DecimalToHex4('0123456789'))  
  writeln(IntToHex(0123456789,9))  }
  
  writeln(CRLF)
  writeln('second RSA:')
  message:='Rosetta Code! 4box';
  print('message                 '+message)  
   
  abig:=TInteger.create(1);
  abig.Assignhex(ASCIItohex(message));
  writeln('big plain text integer: '+abig.Tostring(normal))
  //writeln(HexToBin2(hexmess));
  //writeln(asciitohex(hexmess));
  //writeln(abig.Tostring(normal))
  s_encrypt:= BigPowMod(abig.Tostring(normal),_e, _n)    //bigmulu(ap,aq));
  writeln('encrypted text integer '+s_encrypt)
  s_decrypt:= BigPowMod(s_encrypt,_d,_n)                 //bigmulu(ap,aq))
  writeln('decrypted text integer '+s_decrypt)
  
  abig.Assign2(s_decrypt);
  writeln('decrypt message: '+HextoASCII(abig.ConvertToHexString))
  abig.Free;
  
  //Function StrToBytes(const Value: String): TBytes;
     //bigstr:= StrToBytes(message)
     message:= 'maXboxcode__!';
     bigstr:= BytesOf(message);
     writeln(itoa(bigstr[12]))
     writeln(chr(bigstr[12]));
     writeln( inttostr((bigstr[12])));
     bigstr2:= inttostr((bigstr[12]));
     writeln(BytestoStr(bigstr))
     writeln('string of: '+StringOf(bigstr));
     for it:= 1 to length(bigstr)-1 do bigstr2:= bigstr2+inttostr((bigstr[it]));
     writeln('sum up: '+bigstr2)
     
     //writeln(AnsiByteArrayToString2(bigstr, length(bigstr)));
     
     abig:=TInteger.create(1);
     abig.Assign2(bigstr2);
     writeln('tostring: '+abig.Tostring(normal))
     s_encrypt:= BigPowMod(abig.Tostring(normal),_e, _n)    //bigmulu(ap,aq));
     writeln('encrypted text integer '+s_encrypt)
     s_decrypt:= BigPowMod(s_encrypt,_d,_n)                 //bigmulu(ap,aq))
     writeln('decrypted text integer '+s_decrypt)
     bigstr:= bytesof(s_decrypt);
      for it:= 1 to length(bigstr)-1 do bigstr[it]:= bigstr[it];
    
     //writeln(AnsiString('0123456789ABCDEF')[13])
     //abig.Assign2(s_decrypt);
     writeln('decrypt strof message: '+stringof(bigstr))
     abig.free;
     
   bignumbertesthex;
  writeln(DecimalToHex4('526736574746120436646521'))
  writeln(DecimalToHex4('0123456789'))  
  writeln(IntToHex(0123456789,9))  //}
  
  buildRSAForm;
  
  //  Bigint Performance Tester 
  //var _e=: string;
  Time1:= Time;
     __e:= '65537'; __n:= '3127'; __d:= '116425';   //133505 - 31977
     //__e:= '17'; __n:= '3127'; __d:= '86577';
     abig:= TInteger.create1;
     abig.Assign2('3000');   // is message
     s_encrypt:= BigPowMod(abig.Tostring(normal),__e, __n)    //bigmulu(p,q));
     writeln('encrypted text integer '+s_encrypt)
     s_decrypt:= BigPowMod(s_encrypt,__d,__n)                 //bigmulu(p,q))
     writeln('decrypted text integer '+s_decrypt)
     abig.Free;
  PrintF('%s',[FormatDateTime('"perf:" nn:ss:zzz',Time-Time1)])
  
  //crypto system ref:
  Time1:= Time;
    writeln(BigPowMod('4816','1024865','6059'))   
    //writeln(BigPow(4816,1024865)) //perf: 42:44:896  
  PrintF('%s',[FormatDateTime('"perf:" nn:ss:zzz',Time-Time1)])
  
  //Pivot from umatrix
  // println(sha1(exepath+'maXbox4.exe'));
   
 //function chain
  shash:= itoa(hash(message))
  writeln('num message: '+message); 
  println('mess hashed: '+shash); 
  println('hash(m) decrypt chaine: '+
    RSADecrypt(RSAEncrypt(itoa(hash(message)),'919313','988027'),'65537','988027')); 
  println('mess hashed to compare: '+shash); 
  
  // timestamp example manipulation
    DT:= StrToDate('12/12/2013'); DT:= DT+10;
    ReplaceTime(DT, EncodeTime(20, 0, 0, 0));        
    writeln(DateTimeToStr( DT ));  
End.

//http://rosettacode.org/wiki/RSA_code#Python
//0 h runtime: 00:16:006

{import binascii
 
n = 9516311845790656153499716760847001433441357    # p*q = modulus
e = 65537
d = 5617843187844953170308463622230283376298685
 
message='Rosetta Code!'
print('message                 ', message)
 
hex_data   = binascii.hexlify(message.encode())
print('hex data                ', hex_data)
 
plain_text = int(hex_data, 16)
print('plain text integer      ', plain_text)
 
if plain_text > n:
  raise Exception('plain text too large for key')
 
encrypted_text = pow(plain_text,     e, n)
print('encrypted text integer  ', encrypted_text)
 
decrypted_text = pow(encrypted_text, d, n)
print('decrypted text integer  ', decrypted_text)
 
print('message                 ', binascii.unhexlify(hex(decrypted_text)[2:]).decode())     # [2:] slicing, to strip the 0x part 



Output:

message                  Rosetta Code!
hex data                 b'526f736574746120436f646521'
plain text integer       6531201667836323769493764728097
encrypted text integer   5307878626309103053766094186556322974789734
decrypted text integer   6531201667836323769493764728097
message                  Rosetta Code!   


 procedure Free;
    property Digits: TDigits Read fDigits;
    procedure Assign(const I2: TInteger); overload;
    procedure Assign(const I2: int64); overload;
    procedure Assign(const I2: string); overload;
    procedure AbsoluteValue;
    procedure Add(const I2: TInteger); overload;
    procedure Add(const I2: int64); overload;
    procedure AssignZero;
    procedure AssignOne;
    procedure Subtract(const I2: TInteger); overload;
    procedure Subtract(const I2: int64); overload;
    procedure Mult(const I2: TInteger); overload;
    procedure Mult(const I2: int64); overload;
    procedure FastMult(const I2: TInteger);
    procedure Divide(const I2: TInteger); overload;
    procedure Divide(const I2: int64); overload;
    procedure  Modulo(Const I2: TInteger); overload;
    procedure  Modulo(Const N: int64); overload;
    procedure ModPow(const I2, m: TInteger);
    procedure InvMod(I2: TInteger);
    procedure DivideRem(const I2: TInteger; var remain: TInteger);
    procedure DivideRemTrunc(const I2: TInteger; var remain: TInteger);
    Procedure DivideRemFloor(const I2: TInteger; var remain: TInteger);
    Procedure DivideRemEuclidean(const I2: TInteger; var remain: TInteger);
    function Compare(I2: TInteger): integer; overload;
    function Compare(I2: int64): integer; overload;
    procedure Factorial;
    function ConvertToDecimalString(commas: boolean): string;
    function ConvertToInt64(var N: int64): boolean;
    function DigitCount: integer;
    procedure SetSign(s: integer);
    function GetSign: integer;
    function IsOdd: boolean;
    function IsPositive: boolean;
    function IsNegative: boolean;
    function IsProbablyPrime: boolean;
    function IsZero: boolean;
    //function IsOne: boolean;
    procedure ChangeSign;
    procedure Pow(const exponent: int64); overload;
    procedure Sqroot;
    procedure Square;
    procedure FastSquare;

    procedure Gcd(const I2: TInteger); overload;
    procedure Gcd(const I2: int64); overload;
    procedure NRoot(const Root: int64); overload;
    //procedure NRoot(const Root :Tinteger); overload;
    function GetBase: integer;

    function BitCount: integer;
    function  ConvertToHexString: String;
    function  AssignRandomPrime(BitLength: integer; seed: String; mustMatchBitLength: boolean): boolean;
    function  AssignHex(HexStr: String): boolean;
    procedure  RandomOfSize(size: integer);
    procedure  Random(maxint: TInteger);
    procedure  Getnextprime;

    //property Length: integer read GetLength write Setdigitlength ChangeLength;
    //$IF compilerversion > 15
    class operator Implicit(a: Int64): TInteger;
    class operator Implicit(a: TInteger): Int64;
    //class operator Implicit(s: string): TInteger;
    //class operator Implicit(a: TInteger): TInteger;
    class operator Implicit(a: TInteger): string; // write to a string;
    class operator Negative(a: TInteger): TInteger;

    class operator Add(a, b: TInteger): TInteger;
    class operator Subtract(a, b: TInteger): TInteger;
    class operator Inc(var a: TInteger): TInteger;
    class operator Dec(var a: TInteger): TInteger;
    class operator Equal(a, b: TInteger): boolean;
    class operator NotEqual(a: TInteger; b: TInteger): boolean;
    class operator GreaterThan(a: TInteger; b: TInteger): boolean;
    class operator GreaterThanOrEqual(a: TInteger; b: TInteger): boolean;
    class operator LessThan(a: TInteger; b: TInteger): boolean;
    class operator LessThanOrEqual(a: TInteger; b: TInteger): boolean;
    class operator Multiply(a, b: TInteger): TInteger;
    class operator IntDivide(a, b: TInteger): TInteger;
    class operator Modulus(a, b: TInteger): TInteger;
    
    
    February 10, 2015:  An astute German user, Frank, recently discovered an error in the key generation process which produced invalid keys about 1 to 20 times.  The program uses a BlockSize field to control encrypting and decrypting multiple characters at a time for efficiency.  The first piece of generated keys is N, and the algorithm calculates encrypted and decrypted values modulo N.   For this to work, N must be larger than the largest value that can be contained in BlockSize bytes.  N is generated as the product of two random prime numbers and must be larger than 2Keysize.  For example, with  Keysize=16, this minimum is 65536.  Without checking, I foolishly  assumed that the product of two 3-digit primes would contain at least 6 digits and therefore be guaranteed larger then 65536.  That turns out not to be true: e.g.101x103 =10402; way too small.  


 }



 {Agenda vom 09.01.2021
 
  - Schliessen von Module 2
  - Fragen aus dem Herdt Skript S. 11 - 15
  - Test 2
  - Module 3 (3 Lernprogramme) Alice und Bob
  - Fragerunde und Vorbereitung SEP   
  
  
  
   for it:= 1 to 500 do 
       if (3 * it mod 64 = 1) then println('key '+itoa(it)+' found');
       
       
   print(strlower(LETTERS))
       asciiset:= getasciiline;
       msg:= 'house';
       msg:= 'how are you?';
       writeln(itoa(pos(msg[1],asciiset)));
       for it:= 1 to length(msg) do 
                  cryp:= cryp + chr(pos(msg[it],asciiset) mod 255 +2);
       writeln(cryp) 
       msg:= ''; 
       for it:= 1 to length(cryp) do 
                  msg:= msg + chr(pos(cryp[it],asciiset) mod 255 -2); 
       writeln(msg)       
       
       def encrypt(msg, n):
    return ''.join(map(lambda x:abc[(abc.index(x)+n)%26] if x in abc else x, msg))
 
 [x**2 for x in range(10) if x%2==0]
 # [0,4,16,36,64]
  
  479114 - @a?E9w3J4R ipso }
  
  
  
  
  