unit PrivatePublicKey_RSA;

//Given an RSA key (n,e,d), construct a program to encrypt and decrypt plaintext messages strings. 

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
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
          Selected: Boolean);
    procedure Button6Click(Sender: TObject);


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

procedure FormCreate(Sender: TObject);

begin
   p:=0;
   q:=0;
   main.DoubleBuffered:=true;
   abbruch:=false;
end;


procedure Button1Click(Sender: TObject);

var
  itNewItem : TListItem;

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
  if q = 0 then
    begin
      MessageDlg('Primzahl für "q" eingeben!', mtInformation,[mbOk], 0);
      exit;
    end;

  if p = 0 then
    begin
      MessageDlg('Primzahl für "p" eingeben!', mtInformation,[mbOk], 0);
      exit;
    end;

  progressC:=1;
  abbruch:=false;

  n:=p*q;

  label13.Caption:=inttostr(n);
  label17.Caption:=inttostr(n);
  label6.Caption:=inttostr(n);
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

  if phiN mod e = 0 then
    begin
      MessageDlg('PhiN darf nicht durch e teilbar sein, wählen Sie andere Primzahlen "p/q"oder ein anderes "e"!', mtInformation,[mbOk], 0);
      exit;
    end;
    
  button2.Enabled:=true;
  button5.Enabled:=false;
  progressbar1.Position:=1;
  repeat
    begin
     loes:=e*d mod phiN;
     if loes=1 then
       begin
         inc(gef);
         label10.Caption:=inttostr(gef);
         itNewItem:= ListView1.Items.add;
         itNewItem.Caption := inttostr(d);
       end;
       application.ProcessMessages;
       inc(d);
       progressbar1.Position:=progressC div 1000;
       inc(progressC);
       if progressbar1.Position=100 then
         begin
           progressbar1.Position:=1;
           progressC:=1;
         end;
     end;
  until abbruch;
  application.ProcessMessages;
  button2.Enabled:=false;
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

procedure Button3Click(Sender: TObject);

var
  i1,i2,i3:Tinteger;

begin
  groupbox2.Font.Style:=[];
  groupbox7.Font.Style:=[fsbold];
  groupbox9.Font.Style:=[];
  groupbox12.Font.Style:=[];
  button4.enabled:=true;
  if edit1.Text ='' then
    begin
      MessageDlg('Zahl zum Verschlüsseln eingeben!', mtInformation,[mbOk], 0);
      exit;
    end;

  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  i3:=TInteger.create(0);
  i1.assign2(edit1.Text);
  i1.pow(e);
  i2.assign2(inttostr(n));
  i1.modulo(i2);
  label22.caption:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
  Groupbox8.enabled:=true;
end;

procedure Button4Click(Sender: TObject);

var
  e1:integer;
  i1,i2,i3:Tinteger;

begin
  groupbox2.Font.Style:=[];
  groupbox7.Font.Style:=[];
  groupbox9.Font.Style:=[fsbold];
  groupbox12.Font.Style:=[];

  if edit2.Text ='' then begin
      MessageDlg('Gewähltes "d" eingeben!', mtInformation,[mbOk], 0);
      exit;
    end;

  i1:=TInteger.create(1);
  i2:=TInteger.create(1);
  i3:=TInteger.create(1);
  i1.assign2(label22.caption);
  e1:=strtoint(edit2.Text);
  i1.pow(e1);
  i2.assign2(inttostr(n));
  i1.modulo(i2);
  label29.caption:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
  Groupbox8.enabled:=true;
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
end;

procedure Button6Click(Sender: TObject);

var
  i1,i2,i3:Tinteger;

begin
  groupbox2.Font.Style:=[];
  groupbox12.Font.Style:=[fsbold];
  groupbox7.Font.Style:=[];
  groupbox9.Font.Style:=[];

  if edit3.Text ='' then begin
      MessageDlg('Zahl zum Signieren eingeben!', mtInformation,[mbOk], 0);
      exit;
    end;
  if edit4.Text ='' then begin
      MessageDlg('Gewähltes "d" eingeben!', mtInformation,[mbOk], 0);
      exit;
    end;
  i1:=TInteger.create(1);
  i2:=TInteger.create(1);
  i3:=TInteger.create(1);
  i1.assign2(edit3.Text);
  i1.pow(strtoint(edit4.Text));
  i2.assign2(inttostr(n));
  i1.modulo(i2);
  label35.caption:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
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
    //Assert(CharInSet(c, ['0','1','2']),'must be numbers');
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
    Result := AnsiString('0123456789ABCDEF')[digit + 1] + Result;
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
    hexmess, bigstr2: string;
    var abig: TInteger;
        bigstr: TBytes;

begin  //@main

srlist:= TStringlist.create;
if LoadDFMFile2Strings('C:\maXbox\softwareschule\IBZ_2016\IBZ_IT_Security_2016\DVD Inhalt\RSA Berechnung\PrivateKey.dfm',srlist, abt)= 0 then
    writeln(srlist.text);
    srlist.Free;   // *)
    
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
  
End.

//http://rosettacode.org/wiki/RSA_code#Python

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
message                  Rosetta Code!    }

