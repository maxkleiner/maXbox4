unit U_RSADemo2_mXForms2;
{Copyright © 09, 1Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A demo program applying the RSA public key security algorithm for exchanging
 messages.  - with records instead classes for maXbox, #LOCS=1345    }

                                                                       
interface

{uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, shellAPI, uBigIntsV3, dffutils,
  Menus;}

type

  TActor2=(Alice, Bob); //rdesign to talice & tbob

  TKeyInt=TInteger;

  TKeyObjAB=  record
    ID:string;
    {Keep all four the following four values for debugging}
    {The public key is the pair [n,e]}
    {The private key is the pair [n,d]}
    n:TInteger; {the modulus, product p*q of 2 large random primes}
    {Term: CoPrime ==> relatively prime ==> no common factor >1}
    phi:TInteger; {The Totient phi=(p-1)*(q-1)= count of numbers < n which are coprime to n}
    e:TInteger; {Random number < phi and coprimne to phi}
    d:TInteger; {Multiplicative inverse if e relative to phi,
                 which means that  d*e mod phi = 1}
    blocksize:integer; {Number of characters encrypted as a single block}   
    keysize:Integer; { number of bits in the modulus}
    //constructor create(newid:string; newkeysize:integer);
  end;
 
  (*TKeyObjB=  record
    ID:string;
    {Keep all four the following four values for debugging}
    {The public key is the pair [n,e]}
    {The private key is the pair [n,d]}
    n:TInteger; {the modulus, product p*q of 2 large random primes}
    {Term: CoPrime ==> relatively prime ==> no common factor >1}
    phi:TInteger; {The Totient phi=(p-1)*(q-1)= count of numbers < n which are coprime to n}
    e:TInteger; {Random number < phi and coprimne to phi}
    d:TInteger; {Multiplicative inverse if e relative to phi,
                 which means that  d*e mod phi = 1}
    blocksize:integer; {Number of characters encrypted as a single block}
    keysize:Integer; { number of bits in the modulus}
    //constructor create(newid:string; newkeysize:integer);
  end;   *)
  
  type TForm1 = TForm;
  var
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    AliceSheet: TTabSheet;
    BobSheet: TTabSheet;
    Label2: TLabel;
    AlicemakeKeyBtn: TButton;
    AliceRecodeBtn: TButton;
    AliceEncryptedMemo: TMemo;
    AlicePlainTextMemo: TMemo;
    AliceSendBtn: TButton;
    AliceSizeGrp: TRadioGroup;
    Label1: TLabel;
    BobMakeKeyBtn: TButton;
    BobRecodeBtn: TButton;
    BobEncryptedmemo: TMemo;
    BobPlainTextMemo: TMemo;
    BobSendBtn: TButton;
    BobSizeGrp: TRadioGroup;
    AlicePubKeyMemo: TMemo;
    BobPubKeyMemo: TMemo;
    StaticText1: TStaticText;
    AlicePrivateBtn: TButton;
    BobPrivateBtn: TButton;
    AliceClearBtn: TButton;
    Label3: TLabel;
    Label4: TLabel;
    TabSheet2: TTabSheet;
    aMemo2: TMemo;
    aMemo3: TMemo;
    GoBobLbl: TLabel;
    GoAliceLbl: TLabel;
    AliceSampleBtn: TButton;
    BobSampleBtn: TButton;
    BobClearBtn: TButton;
       procedure AlicemakeKeyBtnClick(Sender: TObject);
       procedure FormActivate(Sender: TObject);
       procedure AliceRecodeBtnClick(Sender: TObject);
       procedure AliceSendBtnClick(Sender: TObject);
       procedure BobMakeKeyBtnClick(Sender: TObject);
       procedure BobRecodeBtnClick(Sender: TObject);
       procedure BobSendBtnClick(Sender: TObject);
       procedure BobPlainTextMemoKeyDown(Sender: TObject; var Key: Word;
         Shift: TShiftState);
       procedure MemoKeyDown(Sender: TObject; var Key: Word;
         Shift: TShiftState);
       procedure Tform1StaticText1Click(Sender: TObject);
       procedure AlicePrivateBtnClick(Sender: TObject);
       procedure PrivateBtnClick(Sender: TObject);
       procedure ClearBtnClick(Sender: TObject);
       procedure SampleBtnClick(Sender: TObject);
  //public
    var
      tAlice:TKeyObjAB;
      tBob:  TKeyObjAB;
      InitialMsgA, InitialMsgB:TStringlist;
       function getkeysize(keysizegrp:TRadiogroup):integer;
       procedure makeRSAKey(var Actor:TKeyObjAB);
       function Encrypt(const s:string; actor:TKeyObjAB {n,e:Tinteger}):string;
       function Decrypt(const s:string; actor:TKeyObjAB {n,d:Tinteger}):string;
       procedure updatepubKeyMemos;
       procedure createalice(newid:string; newkeysize:integer);
       procedure createbob(newid:string; newkeysize:integer);

  //end;

var
  Form1: TForm1;

implementation

//{$R *.dfm}
//uses math;

{************ TKeyObj.create *************8}
procedure createalice(newid:string; newkeysize:integer);
begin
  talice.id:=newid;
  talice.keysize:=newkeysize;
  talice.n:=TInteger.Create(0);
  talice.phi:=TInteger.Create(0);
  talice.e:=TInteger.create(0);
  talice.d:=Tinteger.create(0);
end;

function obj_createAB(newid:string; newkeysize:integer; actor:TKEYObjAB):TKeyObjAB;
begin
  with actor do begin
    id:=newid;
    keysize:=newkeysize;
    n:=TInteger.Create(0);
    phi:=TInteger.Create(0);
    e:=TInteger.create(0);
    d:=Tinteger.create(0);
  end;
  result:= actor;  
end;

procedure createbob(newid:string; newkeysize:integer);
begin
  tbob.id:=newid;
  tbob.keysize:=newkeysize;
  tbob.n:=TInteger.Create(0);
  tbob.phi:=TInteger.Create(0);
  tbob.e:=TInteger.create(0);
  tbob.d:=Tinteger.create(0);
end;

procedure TIntegerTrim(var aint: TInteger);
{ eliminate leading zeros }
var
  i, j: integer; 
  fdigits: TDigits;
begin
  fdigits:= aint.Digits;
  i:= high(fdigits);
  if i >= 0 then begin
    j:= i;
    if (fdigits[0] <> 0) then
      while (fDigits[i] = 0) do Dec(i)
    else
      while (i > 0) and (fDigits[i] = 0) do Dec(i);
    if j <> i then SetLength(fDigits, i + 1);
    // make sure sign is zero if value = 0...
    if (i = 0) and (fDigits[0] = 0) then aint.setSign(0);
  end else begin
    aint.AssignZero;
  end;
end;


{************* MakeRSAKey *************}
procedure MakeRSAKey(var Actor:TKeyObjAB);
var
  p,q:TKeyInt;
  temp:TKeyint;
  primesize:integer;
  Time1: TTime;
begin
  screen.cursor:=crhourglass;
  Time1:= Time;
  with actor do begin
    {target number of decimal digits is about 0.3  times the specified bit length}
    primesize:=trunc(keysize*log10(2)/2)+1;

    p:=TKeyInt.create(0);
    q:=TKeyInt.create(0);
    temp:=TKeyInt.create(0);
    Temp.assign1(2);
    temp.pow(keysize);  {this is smallest valid N value}

    repeat
      {Generate random p}
      p.randomOfSize(primesize);
      p.getnextprime;

      {Generate random q}
      repeat
        q.randomOfSize(primesize);
        q.getnextprime;
      until p.compare(q)<>0;
      {n=p*q}
      n.assign(p);
      n.mult(q);
    until N.Compare(temp)>0;

     {Phi=(p-1)*(q-1)}
    Phi.assign(p);
    phi.subtract1(1);
    temp.assign(q);
    temp.subtract1(1);
    phi.mult(temp);
     {random e < Phi such that GCD(phi,e)=1}
    repeat
      e.random(phi);
      temp.assign(phi);
      temp.GCD(e);
    until temp.compare1(1)=0;
    d.assign(e);
    d.invmod(phi);
    TIntegerTrim(n)
    //n.Trim;
    Blocksize:=trunc(n.digitcount/log10(256));
    writeln('blocksize check '+itoa(blocksize)+' '+actor.id)
    //actor.blocksize:= blocksize;
    temp.free;
    p.free;
    q.free;
  end;
  screen.Cursor:=crdefault;
  //writeln('talice block '+itoa(talice.blocksize))
  PrintF('%s',[FormatDateTime('"runtime:" nn:ss:zzz',Time-Time1)])
end;

(*
{************* MakeRSAKey *************8}
procedure TForm1.MakeRSAKey(Actor:TKeyObj);
var
  p,q:TKeyInt;
  temp:TKeyint;
  primesize:integer;
begin
  screen.cursor:=crhourglass;
  with actor do
  begin
    {target number of decimal digits is about 0.3  times the specified bit length}
    primesize:=trunc(keysize*log10(2)/2)+2{1};

    p:=TKeyInt.create;
    q:=TKeyInt.create;
    temp:=TKeyInt.create;

    {Generate random p}
    p.randomOfSize(primesize);
    p.getnextprime;
    //p.assign(109); {test value}

    {Generate random q}
    repeat
      q.randomOfSize(primesize);
      q.getnextprime;
    until p.compare(q)<>0;
    //q.assign(157); {test value}
    {n=p*q}
    n.assign(p);
    n.mult(q);
    {Phi=(p-1)*(q-1)}
    Phi.assign(p);
    phi.subtract(1);
    temp.assign(q);
    temp.subtract(1);
    phi.mult(temp);
    {random e < Phi such that GCD(phi,e)=1}
    repeat
      e.random(phi);
      temp.assign(phi);
      temp.GCD(e);
    until temp.compare(1)=0;
    //e.assign(17); {test value}
    d.assign(e);
    d.invmod(phi);
    n.Trim;
    blocksize:=1; //trunc(n.digitcount/log10(256));  {Error possible if >1}
    temp.free;
    p.free;
    q.free;
  end;
  screen.cursor:=crdefault;
end;
*)

 procedure UpdateMemo(PubKeyMemo:TMemo);
      begin
        with PubKeyMemo do begin
          clear;
          lines.add(format('Alice Public Key: <%s, %s>',
                    [talice.n.convertTodecimalstring(false),
                     talice.e.convertTodecimalstring(false)]));
          lines.Add('===========================================');           
          lines.add(format('Bob Public Key: <%s, %s>',
                    [tbob.n.convertTodecimalstring(false),
                     tbob.e.convertTodecimalstring(false)]));
        end;
      end;

procedure updatepubKeyMemos;
     

begin  {Update Public Info}
  updatememo(AlicePubKeyMemo);
  updatememo(BobPubKeyMemo);
end;

{************* AliceMakeKeyBtnClick **********}
procedure AlicemakeKeyBtnClick(Sender: TObject);

begin
  talice.keysize:=getkeysize(AliceSizeGrp);
  MakeRSAKey(tAlice);
  UpdatePubKeyMemos;
end;


{************* BobMakeKeyBtnClick *********}
procedure BobMakeKeyBtnClick(Sender: TObject);
begin
   tbob.keysize:=getkeysize(BobSizegrp);
   MakeRSAKey(tBob);
   updatePubKeyMemos;
   (*
   bobpubkeymemo.clear;
   bobpubkeymemo.lines.add(format('Public Key: <%s, %s>',
           [bob.n.convertTodecimalstring(false),
            bob.e.convertTodecimalstring(false)]));
   *)
end;



{************* FormActivate *********}
procedure FormActivate(Sender: TObject);
begin
  createalice('Alice', Getkeysize(AliceSizeGrp));
  createbob('Bob', Getkeysize(BobSizeGrp));
  //talice:= obj_createAB('Alice', Getkeysize(AliceSizeGrp), talice)
  //tbob:= obj_createAB('Bob', Getkeysize(BobSizeGrp), tbob)
  AlicerecodeBtn.tag:=1;
  BobRecodebtn.tag:=1;
  AlicemakeKeyBtnclick(sender);
  BobMakeKeyBtnclick(sender);
  reformatmemo(amemo2);
  reformatmemo(amemo3);
  InitialMsgA:=TStringlist.create;
  InitialMsgB:=TStringList.create;
  InitialMsgA.text:=AlicePlainTextMemo.lines.text;
  InitialMsgB.Text:=BobPlainTextMemo.lines.text;
  writeln('crypto form activated...')
end;

{************** GetKeySize ************}
function getkeysize(keysizegrp:TRadiogroup):integer;
begin
  case keysizegrp.ItemIndex of  {key bitsize}
    0: result:=16;
    1:result:=64;
    2:RESULT:=256;
    3: result:=512;
    4:result:=1024;
  end;
end;

{************* Encrypt *************8}
function Encrypt(const s:string; actor:TKeyObjAB {n,e:Tinteger}):string;
var
  nbrblocks:integer;
  i,j,start:integer;
  p:TKeyInt;
  outblock:integer;
  temps:string;
begin
  {recode the string blocksize bytes at a time}
  with actor do begin
    p:=TKeyInt.create(0);
    writeln('blocksize '+itoa(blocksize))
    nbrblocks:=length(s) div blocksize;
    outblock:=n.digitcount; {size of outputblocks}
    result:='';
    start:=1;
    for i:=0 to nbrblocks do begin
      p.assign1(0);
      for j:=start to start+blocksize-1 do
      if j<=length(s) then begin
        p.mult1(256); {shift the # left by one byte}
        p.add1(ord(s[j]));
      end;
      p.modpow(e,n); {encryption step}
      temps:=p.converttodecimalstring(false);
      {pad out to constant output blocksize}
      while length(temps)<outblock do temps:='0'+temps;
      result:=result + temps;
      inc2(start,blocksize);   {move to mext block}
    end;
  end;
end;

{************ Decrypt *************8}
function Decrypt(const s:string; actor:TKeyObjAB{n,d:Tinteger}):string;
var
  k:integer;
  p:TKeyInt;
  q:TInteger;
  estring,dstring:string;
  ch:int64;
  t256:TInteger;
begin
  {recode the string blocksize bytes at a time}
  result:='';
  p:=TKeyInt.create(0);
  q:=TKeyInt.create(0);
  t256:=TInteger.create(0);
  t256.Assign1(256);
  estring:=s;
  dstring:='';
  with actor do begin
    k:=n.digitcount;
    while length(estring)>0 do begin
      p.assign2(copy(estring,1,k{-1}));
      p.modpow(d,n);
      while p.ispositive do begin
        p.dividerem(T256,q);
        q.converttoInt64(ch);
        dstring:=chr(ch)+dstring;
      end;
      result:=result+dstring;
      dstring:='';
      delete(estring,1,k);
    end;
  end;
end;

{************ AliceRecodeBtnClick *************}
procedure AliceRecodeBtnClick(Sender: TObject);
begin
  screen.Cursor:=crhourglass;
  case Alicerecodebtn.tag of
    1:  {We are encryptong a message to send to Bob}
      aliceencryptedmemo.text:=
        encrypt(AlicePlaintextMemo.text,tbob);
    2:  {We are decrypting a message to us from Bob}
      AliceEncryptedmemo.text:=decrypt(AlicePlainTextMemo.text,talice);
  end;
  screen.Cursor:=crdefault;
end;

{************ BobRecodeBtnClick **********}
procedure BobRecodeBtnClick(Sender: TObject);
begin
  (*
  with alice do
  begin
    n.assign(17113);
    d.assign(4895);
    e.assign(4175);
  end;
  *)
  screen.Cursor:=crhourglass;
  case Bobrecodebtn.tag of
    1:  {We are encrypting a message to send to Alice}
      begin
        bobencryptedmemo.text:=encrypt(BobPlaintextMemo.text,talice);
      end;
    2: {We are decrypting a message to us from Alice}
      BobEncryptedmemo.text:=decrypt(BobplainTextMemo.text, tBob);
  end;
  screen.Cursor:=crdefault;
end;

{************* AliceSendBtnClick **********}
procedure AliceSendBtnClick(Sender: TObject);
begin
  label1.Caption:='Encrypted message from Alice';
   Bobplaintextmemo.text:= Aliceencryptedmemo.text;
  BobRecodeBtn.caption:='Decrypt message from Alice (w/ my private key)';
  Bobrecodebtn.tag:=2;
  Bobsendbtn.Enabled:=false;
  BobEncryptedmemo.clear;
  GoBobLbl.visible:=true;
  goboblbl.update;
  sleep(1000);
  GoBobLbl.visible:=false;
  pagecontrol1.activepage:=BobSheet;
  //Bobsendbtn.Enabled:=true;
end;

{************* BobSendBtnClick **********}
procedure BobSendBtnClick(Sender: TObject);
begin
  label2.Caption:='Encrypted message from Bob';
   Aliceplaintextmemo.text:= Bobencryptedmemo.text;
  AliceRecodeBtn.caption:='Decrypt message from Bob (w/ my private key)';
  Alicerecodebtn.tag:=2;
  Alicesendbtn.Enabled:=false;
  AliceEncryptedMemo.clear;
  GoAliceLbl.visible:=true;
  goalicelbl.Update;
  sleep(1000);
  GoAliceLbl.visible:=false;
  pagecontrol1.activepage:=AliceSheet;
end;


{************* BobPlaintextMemoKeyDown ***************}
procedure BobPlainTextMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   { Reset BobplainTextMemo }
  BobRecodeBtn.tag:=1;
  BobrecodeBtn.caption:='Encrypt message using Alice''s public key';
  BobSendbtn.Enabled:=true;
  label1.caption:='Plain text message for Alice';
end;

{**************** MemoKeyDown ***********8}
procedure MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if sender = AlicePlaintextmemo then begin
    AliceRecodeBtn.tag:=1;
    AlicerecodeBtn.caption:='Encrypt message using Bob''s public key';
    AliceSendbtn.Enabled:=true;
    label2.Caption:='Plain text message for Bob';
    AliceEncryptedmemo.clear;
  end else begin
    BobRecodeBtn.tag:=1;
    BobrecodeBtn.caption:='Encrypt message using Alice''s public key';
    BobSendbtn.Enabled:=true;
    label1.caption:='Plain text message for Alice';
    BobEncryptedmemo.Clear;
  end;
end;

function breakstring(s:string; linelength:integer):string;
   {break long strings by inserting linefeed characters every "linelength" characters}
 var i:integer;
   begin
     result:='';
     for i:=0 to length(s) div linelength do
     result:=result+copy(s,i*linelength+1,linelength)+#13;
     delete(result,length(result),1); {delete the final Linefeed}
   end;

{************* AliceShowBtnClick ***********}
procedure AlicePrivateBtnClick(Sender: TObject);
begin
  showmessage('Alice private key' + #13 + '<'
   + talice.n.converttodecimalstring(false) +', '
   + talice.d.converttodecimalstring(false) +'>');
end;

{*********** BobPrivateBtnClick **********}
procedure PrivateBtnClick(Sender: TObject);
var
  nstr,estr:string;
  actor:TKeyobjAB;
begin
  if sender=AlicePrivateBtn then actor:=tAlice else actor:=tBob;
  with actor do begin
    nstr:= breakstring(n.converttodecimalstring(false),100);
    estr:= breakstring(d.converttodecimalstring(false),100);
    showmessage(ID+' private key' + #13 + '<'    + nstr +', '+ estr +'>');
  end;
end;

{********** ClearBtnClick *************}
procedure ClearBtnClick(Sender: TObject);
var
  key:word;
  memo:TMemo;
begin
  key:=ord('A');
  If Sender = AliceSampleBtn
  then memo:=AlicePlaintextMemo
  else memo:=BobPlainTextmemo;
  memo.clear;  {New message button}
  MemoKeyDown(memo, Key, []);
end;

{*********** SampleBtnClick ********}
procedure SampleBtnClick(Sender: TObject);
  var
  key:word;
  memo:TMemo;
begin
  key:=ord('A');
  If Sender = AliceSampleBtn then begin
    AlicePlaintextMemo.text:=InitialMsgA.Text;
    memo:=AlicePlaintextMemo
  end else begin
    BobPlaintextMemo.text:=InitialMsgB.Text;
    memo:=BobPlainTextmemo;
  end;
  MemoKeyDown(memo, Key, []);
end;

(*
{************ BobClearBtnClick ***********}
procedure TForm1.BobClearBtnClick(Sender: TObject);
var
  key:word;
begin
  key:=ord('A');
  BobPlainTextMemoKeyDown(Sender,key,[]);
  Bobplaintextmemo.clear;
end;
*)
procedure TForm1StaticText1Click(Sender: TObject);
begin
  //ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  //nil, nil, SW_SHOWNORMAL) ;
  openbrowser('http://www.delphiforfun.org/')
end;

procedure loadCryptoForm;
begin
Form1:= TForm1.create(self);
with form1 do begin
  Left := 455
  Top := 201
  AutoScroll := False
  Caption := 'RSA maXbox Encryption Demo,  Version 2.4'
  ClientHeight := 740
  ClientWidth := 1017
  Color := clBtnFace
  Font.Charset := DEFAULT_CHARSET
  Font.Color := clWindowText
  Font.Height := -20
  Font.Name := 'Arial'
  Font.Style := []
  OldCreateOrder := False
  Position := poScreenCenter
  formstyle:= fsstayontop;
  //OnActivate := @FormActivate
  //PixelsPerInch := 120
  //TextHeight := 23
  Icon.LoadFromResourceName(HInstance,'ZHISTOGRAM');
  Show;
  PageControl1:= TPageControl.create(form1)
  with pagecontrol1 do begin
   parent:= form1
    Left := 0
    Top := 0
    Width := 1017
    Height := 730
    ActivePage := IntroSheet
    Align := alClient
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clWindowText
    Font.Height := -20
    Font.Name := 'Arial'
    Font.Style := []
    ParentFont := False
    TabOrder := 0
    IntroSheet:= TTabSheet.create(self)
    with IntroSheet do begin
      parent:= pagecontrol1; //form1
      pagecontrol:= pagecontrol1
      Caption := 'Introduction'
      aMemo3:= TMemo.create(self)
      with amemo3 do begin
       parent:= IntroSheet;
        Left := 0
        Top := 0
        Width := 1009
        Height := 730
        Align := alClient
        Color := 14548991
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := 18
        Font.Name := 'Arial'
        Font.Style := []
        Lines.add(          
            'This is not the place to learn the theory behind  the RSA Public' +
            ' Key Encryption System, but it may help ' +
          'understanding to see a  small  example.  The steps are:'+
          ''             +  CRLF+ CRLF+
          '1. Find two different prime numbers, :  p := 61,  q := 53'+
          '' +CRLF+ CRLF                                                         +
          '2. Calculate the modulus n := p*q: n := 61*53 := 3233' +
          ''   +  CRLF+ CRLF                                   +
            '3. Calculate Euler'#39's totient, phi= (p-1)*(q-1): phi= 60*52= 3' +
            '120' +
          ''     + CRLF+ CRLF+
            '4. Choose public key part, e, less than phi, such that GCD(e,phi' +
            '):=1 (e coprime to phi): e := 17' +
          ''  +  CRLF+ CRLF+
            '5. Calculate private key part, d, multiplicative inverse InvMod ' +
            'function) of e relative to phi: '+CRLF+CRLF+TAB+'d = e InvMod phi'+
          '= 17 Invmod 3120 = 2753  because (17 * 2753) mod 3120 = 1'+
          ''  + CRLF+ CRLF+
            'Public key  = <n, e> = <3233, 17> Private key = <n, d> = <3233, ' +
            '2753>'+
          '' +  CRLF+ CRLF+
            'If P repesents the numerical equivalent of some text, public key' +
            ' (n,e)can be used to calculate C, the encrypted' +
            'version, from P: C:=(P^e mod n), so for example if we use the typ' +
            'ical internal representaion of "A" (decimal 41) '+
            'then the encrypted version becomes C := 41^17 mod 3233 := 3199 and' +
            ' the decrypting function from the private '  +
          'key is P:=(C^d mod n) P:=3199^2753 mod 3233 := 41.  It works!' +
          ''  +  CRLF+ CRLF+
            'Whether you are a programmer or not, if you want to try some of ' +
            'these calculations, the Delphiforfun Big' +
            'Integers test program is available from page http://delphiforfun' +
            '.org/Programs/Library/big_integers.htm.  The'+
            'test program includes the special functions: next-prime to find ' +
            'large primed to create "n", GCD  to find "e" in '  +
            'step 4, InvMod to calculate "d" in step 5, and ModPow to calcula' +
            'te the encrypted and decrypted values.'     +
          ''     +  CRLF+ CRLF+
            'In use, if A wants send a secure message to B, she uses B'#39's p' +
            'ublic key to encrypt her plaintext message '+
            'and sends the cyphertext (numbers) to B who then uses his privat' +
            'e key to convert the message back to plain '  +
          'text.'           +
          ''    +    CRLF+ CRLF+
            'Text is commonly "blocked" with multiple characters encrypted du' +
            'ring each calculation in order to reduce '+
            'computation time and to make it more difficult to determine the ' +
            'plaintext associated with the encrypted values.  '+
            'For example, if we want to be able to encrypt all 256 possible "' +
            'characters", including tab, linefeed, carriage ' +
            'return, etc. then there ecrypted text would have 256 possible en' +
            'crypted values, but if we block the characters '+
            'in groups of 2, there are 256*256 := 65,536 encrypted numbers. Of' +
            ' course, to do this, our modulus ,n, must be ' +
          'larger than 65,536 since the calculations are performed mod n.' +
          ''  +  CRLF+ CRLF+
            'The next page, Signing Messages, contains a brief description of' +
            ' the technique which can verify that the sender ' +
            'is who they say they are, or at least that that they have the pr' +
            'ivate key associated with your corresdpondent'#39's ' +
          'public key.' +
          ''        +  CRLF+ CRLF+
            'The "Alice" and "Bob" pages allow simulated encrypted conversati' +
            'ons between these two. Keys may be up to ' +
            '1024 bits long but be aware that 1024 bit keys may take 30 secon' +
            'ds to calculate.' +
          '' + CRLF+ CRLF+
          '')
        ParentFont := False
        ScrollBars := ssVertical
        TabOrder := 0
      end;
    end;
    TabSheet2:= TTabSheet.create(self)
    with tabsheet2 do begin
      parent:= pagecontrol1; //form1
      pagecontrol:= pagecontrol1
      Caption := 'Signing Messages'
      ImageIndex := 4
      aMemo2:= TMemo.create(self)
      with amemo2 do begin
       parent:= tabsheet2
        Left := 0
        Top := 0
        Width := 1009
        Height := 730
        Align := alClient
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := 30
        Font.Name := 'Arial'
        Font.Style := []
        Lines.add(          
            'While the public key encryption presented so far provides a secu' +
            're method for message '+
          'exchange, it does not ' +
            'guarantee that the person sending the message is who they say th' +
            'ey are.   However there is a way ' +
          'that helps'  +
          'autheticate sender indentity, namely "Message Signing".'+
          ''     +CRLF                +CRLF+
            'If Alice wants to send an authenticated message to Bob, she can ' +
            'encrypt a "signature" using her '   +
          'private key and '   +
          'then encrypt that encrypted signature a second time with Bob'#39's' +
            ' public key and attach it to her '  +
          'message.  When '     +
            'Bob receives the message, he decrypts as usual with his private ' +
            'key and sees that an encrypted '+
          'signature is  '+
            'attached.  He can decrpyt signature using Alice'#39's public key' +
            ', if the decrypted text is readable, ' +
          'he has verified '       +
          'that the sender is really Alice.'  +
          ''       +CRLF                +CRLF+
            'In practice, the signature may be a crypto hash code for the mes' +
            'sage which allows the recipient to ' +
          'verify that the '      +
          'message has not been altered during transmission.'+
          ''       +CRLF                +CRLF+
            'I have not added the signing feature to the demo, but it seems t' +
            'hat it could be done without too '      +
          'much trouble.' +
          ''     +CRLF                +CRLF+
          '')
        ParentFont := False
        TabOrder := 0
      end;
    end;
    aliceSheet:= TTabSheet.create(self)
    with alicesheet do begin
      parent:= pagecontrol1; //form1
      pagecontrol:= pagecontrol1
      Caption := 'Alice'
      Font.Charset := DEFAULT_CHARSET
      Font.Color := clWindowText
      Font.Height := -20
      Font.Name := 'Arial'
      Font.Style := []
      ImageIndex := 1
      ParentFont := False
      Label2:= TLabel.create(form1)
      with label2 do begin
       parent:= alicesheet;
        Left := 17
        Top := 215
        Width := 158
        Height := 23
        Caption := 'Message for Bob '
      end;
       Label3:= TLabel.create(form1)
      with label3 do begin
       parent:= alicesheet;
        Left := 19
        Top := 20
        Width := 166
        Height := 39
        Caption := 'Alice'#39's Page'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -28
        Font.Name := 'Comic Sans MS'
        Font.Style := [fsBold]
        ParentFont := False
      end;
       goboblbl:= TLabel.create(form1)
      with goboblbl do begin
       parent:= alicesheet;
        Left := 583
        Top := 630
        Width := 265
        Height := 39
        Caption := 'Going to Bob'#39's page '
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -28
        Font.Name := 'Comic Sans MS'
        Font.Style := []
        ParentFont := False
        Visible := False
      end ;
      AlicemakeKeyBtn:= TButton.create(form1)
      with  AlicemakeKeyBtn do begin
      parent:= alicesheet;
        Left := 581
        Top := 442
        Width := 188
        Height := 32
        Caption := 'Make a new key'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -20
        Font.Name := 'Arial'
        Font.Style := []
        ParentFont := False
        TabOrder := 0
        OnClick := @AlicemakeKeyBtnClick
      end;
      AlicerecodeBtn:= TButton.create(form1)
      with  AlicerecodeBtn do begin
      parent:= alicesheet;
        Left := 17
        Top := 435
        Width := 523
        Height := 32
        Caption := 'Encrypt using Bob'#39's public key'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -22
        Font.Name := 'Arial'
        Font.Style := [fsBold]
        ParentFont := False
        TabOrder := 1
        OnClick := @AliceRecodeBtnClick
      end;
      AliceEncryptedMemo:= TMemo.create(form1)
      with AliceEncryptedMemo do begin
       parent:= alicesheet;
        Left := 17
        Top := 480
        Width := 523
        Height := 140
        Lines.add (
          'Alice'#39's encrypted text shows here')
        ScrollBars := ssVertical
        TabOrder := 2
      end;
      AlicePlainTextMemo:= TMemo.create(form1)
      with AlicePlainTextMemo do begin
       parent:= alicesheet 
        Left := 17
        Top := 245
        Width := 523
        Height := 175
        Lines.add(
          'Hi Bob,' +
          ''  + CRLF+ CRLF         +
          'Long time no see. Anything exciting happening at your '+
          'end?  '  +
          ''   + CRLF+ CRLF       +
          'Alice') 
        ScrollBars := ssVertical
        TabOrder := 3
        OnKeyDown := @MemoKeyDown
      end;
      AlicesendBtn:= TButton.create(form1)
      with AlicesendBtn do begin
      parent:= alicesheet;
        Left := 17
        Top := 630
        Width := 523
        Height := 32
        Caption := 'Send message to &Bob'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -22
        Font.Name := 'Arial'
        Font.Style := [fsBold]
        ParentFont := False
        TabOrder := 4
        OnClick := @AliceSendBtnClick
      end;
      AliceSizeGrp:= TRadioGroup.create(form1)
      with alicesizegrp do begin
       parent:= alicesheet;
        Left := 584
        Top := 240
        Width := 185
        Height := 191
        Caption := 'Key size'
        ItemIndex := 0
        Items.add('16 bits')
        Items.add('64 bits')
        Items.add('256 bits')
        Items.add('512 bits')
        Items.add('1024 bits')
        ItemIndex := 1
        TabOrder := 5
        OnClick := @AlicemakeKeyBtnClick
      end;
      //object AlicePubKeyMemo: TMemo
       AlicePubKeyMemo:= TMemo.create(form1)
      with AlicePubKeyMemo do begin
       parent:= alicesheet 
        Left := 9
        Top := 82
        Width := 832
        Height := 114
        Lines.add(
          'Alice Public Key');
        ScrollBars := ssVertical
        TabOrder := 6
      end;
      AliceprivateBtn:= TButton.create(form1)
      with  AliceprivateBtn do begin
      parent:= alicesheet;
        Left := 580
        Top := 493
        Width := 190
        Height := 60
        Caption := 'Click to see private key'
        TabOrder := 7
        WordWrap := True
        OnClick := @PrivateBtnClick
      end;
      AliceclearBtn:= TButton.create(form1)
      with  AliceclearBtn do begin
      parent:= alicesheet;
        Left := 815
        Top := 368
        Width := 165
        Height := 101
        Caption := 'Clear and start a new message for Bob'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -22
        Font.Name := 'Arial'
        Font.Style := []
        ParentFont := False
        TabOrder := 8
        WordWrap := True
        OnClick := @ClearBtnClick
      end ;
      AlicesampleBtn:= TButton.create(form1)
      with AlicesampleBtn do begin
      parent:= alicesheet;
        Left := 815
        Top := 248
        Width := 165
        Height := 101
        Caption := 'Reload sample message for Bob'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -22
        Font.Name := 'Arial'
        Font.Style := []
        ParentFont := False
        TabOrder := 9
        WordWrap := True
        OnClick := @SampleBtnClick
      end ;
    end;
    //object BobSheet: TTabSheet
     bobSheet:= TTabSheet.create(self)
    with bobsheet do begin
      parent:= pagecontrol1; //form1
      pagecontrol:= pagecontrol1
      Caption := 'Bob'
      Font.Charset := DEFAULT_CHARSET
      Font.Color := clWindowText
      Font.Height := -22
      Font.Name := 'Arial'
      Font.Style := []
      ImageIndex := 2
      ParentFont := False
      Label1:= TLabel.create(form1)
      with label1 do begin
       parent:= bobsheet;
        Left := 9
        Top := 204
        Width := 180
        Height := 25
        Caption := 'Message for Alice '
      end;
      Label4:= TLabel.create(form1)
      with label4 do begin
       parent:= bobsheet;
        Left := 19
        Top := 20
        Width := 150
        Height := 39
        Caption := 'Bob'#39's Page'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -28
        Font.Name := 'Comic Sans MS'
        Font.Style := [fsBold]
        ParentFont := False
      end;
      //object GoAliceLbl: TLabel
      goalicelbl:= TLabel.create(form1)
      with goalicelbl do begin
       parent:= bobsheet;
        Left := 572
        Top := 630
        Width := 280
        Height := 39
        Caption := 'Going to Alice'#39's page '
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -28
        Font.Name := 'Comic Sans MS'
        Font.Style := []
        ParentFont := False
        Visible := False
      end ;
      BobMakeKeyBtn:= TButton.create(form1)
      with bobmakekeybtn do begin
       parent:= bobsheet;
        Left := 600
        Top := 496
        Width := 185
        Height := 49
        Caption := 'Make a new key'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -22
        Font.Name := 'Arial'
        Font.Style := []
        ParentFont := False
        TabOrder := 0
        OnClick := @BobMakeKeyBtnClick
      end ;
      BobrecodeBtn:= TButton.create(form1)
      with bobrecodebtn do begin
       parent:= bobsheet;
        Left := 9
        Top := 419
        Width := 525
        Height := 32
        Caption := 'Encrypt using Alice'#39's public key'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -22
        Font.Name := 'Arial'
        Font.Style := [fsBold]
        ParentFont := False
        TabOrder := 1
        OnClick := @BobRecodeBtnClick
      end ;
      BobEncryptedmemo:= TMemo.create(form1)
      with bobencryptedmemo do begin
       parent:= bobsheet;
        Left := 9
        Top := 470
        Width := 523
        Height := 150
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -20
        Font.Name := 'Arial'
        Font.Style := []
        Lines.add(
          'Alice'#39's encrypted text shows '+
          'here');
        ParentFont := False
        ScrollBars := ssVertical
        TabOrder := 2
      end;
      Bobplaintextmemo:= TMemo.create(form1)
      with bobplaintextmemo do begin
       parent:= bobsheet;
        Left := 9
        Top := 235
        Width := 523
        Height := 165
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -20
        Font.Name := 'Arial'
        Font.Style := []
        Lines.add(
          'Hey kiddo,'+
          '' + CRLF+ CRLF  +
          'Good to hear from you.  I thought that you '+
          'had been permanently lost in the Snows of '+
          'Kilimenjaro!'+
          '' + CRLF+ CRLF + 
          'Not much happening here.  just waiting for '+
          'spring to arrive.' +
          '' + CRLF+ CRLF  +
          'Bob')
        ParentFont := False
        ScrollBars := ssVertical
        TabOrder := 3
        OnKeyDown := @MemoKeyDown
      end ;
      BobsendBtn:= TButton.create(form1)
      with bobsendbtn do begin
       parent:= bobsheet;
        Left := 9
        Top := 630
        Width := 525
        Height := 32
        Caption := 'Send message to &Alice'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -22
        Font.Name := 'Arial'
        Font.Style := [fsBold]
        ParentFont := False
        TabOrder := 4
        OnClick := @BobSendBtnClick
      end ;
      BobSizeGrp:= TRadioGroup.create(form1)
      with bobsizegrp do begin
       parent:=bobsheet;
        Left := 600
        Top := 296
        Width := 185
        Height := 191
        Caption := 'Key size'
        ItemIndex := 0
        //Items.Strings := (
        Items.add('16 bits')
        Items.add('64 bits')
        Items.add('256 bits')
        Items.add('512 bits')
        Items.add('1024 bits')
        ItemIndex := 1;
        TabOrder := 5
        OnClick := @BobMakeKeyBtnClick
      end ;
      Bobpubkeymemo:= TMemo.create(form1)
      with bobpubkeymemo do begin
       parent:= bobsheet;
        Left := 9
        Top := 82
        Width := 816
        Height := 114
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -20
        Font.Name := 'Arial'
        Font.Style := []
        Lines.add (
          'Bob'#39's Public Key')
        ParentFont := False
        ScrollBars := ssVertical
        TabOrder := 6
      end;
      BobprivateBtn:= TButton.create(form1)
      with bobprivatebtn do begin
       parent:= bobsheet;
        Left := 600
        Top := 565
        Width := 185
        Height := 68
        Caption := 'Click to see private key'
        TabOrder := 7
        WordWrap := True
        OnClick := @PrivateBtnClick
      end;
      BobsampleBtn:= TButton.create(form1)
      with bobsamplebtn do begin
       parent:= bobsheet;
        Left := 815
        Top := 304
        Width := 165
        Height := 101
        Caption := 'Reload sample message for Alice'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -22
        Font.Name := 'Arial'
        Font.Style := []
        ParentFont := False
        TabOrder := 8
        WordWrap := True
        OnClick := @SampleBtnClick
      end ;
      BobclearBtn:= TButton.create(form1)
      with bobclearbtn do begin
       parent:= bobsheet;
        Left := 815
        Top := 416
        Width := 165
        Height := 101
        Caption := 'Clear and start a new message for Alice'
        Font.Charset := DEFAULT_CHARSET
        Font.Color := clWindowText
        Font.Height := -22
        Font.Name := 'Arial'
        Font.Style := []
        ParentFont := False
        TabOrder := 9
        WordWrap := True
        OnClick := @ClearBtnClick
      end;
    end;
  end;
  StaticText1:= TStaticText.create(form1)
  with statictext1 do begin
   parent:= form1;
    Left := 0
    Top := 768
    Width := 1017
    Height := 23
    Cursor := crHandPoint
    Align := alBottom
    Alignment := taCenter
    Caption:='Copyright '#169' 2009-2020, Gary Darby, maXbox4, www.DelphiForFun.org'
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clBlue
    Font.Height := 16 
    Font.Name := 'Arial'
    Font.Style := [fsBold, fsUnderline]
    ParentFont := False
    TabOrder := 1
    OnClick := @TForm1StaticText1Click ;
  end;
 end;
  FormActivate(self);
end;


var _n, _e, _d, s_encrypt, s_decrypt, message: string;


begin //@main

  writeln(datetimetostr(now))
  
  talice:= obj_createAB('Alice', 128, talice)
  writeln('keysize alice: '+itoa(talice.keysize))
  tbob:= obj_createAB('Bob', 256, tbob)
  writeln('keysize bob: '+itoa(tbob.keysize))
  MakeRSAKey(talice);
  MakeRSAKey(tbob);
  writeln('blocksize alice: '+itoa(talice.blocksize))
  writeln('blocksize bob: '+itoa(tbob.blocksize))
  
  writeln(talice.n.convertTodecimalstring(false))
  writeln(talice.e.convertTodecimalstring(false))
  writeln(talice.d.convertTodecimalstring(false))
  
  writeln(tbob.n.convertTodecimalstring(false))
  writeln(tbob.e.convertTodecimalstring(false))
  writeln(tbob.d.convertTodecimalstring(false))
  
  _n:= tbob.n.convertTodecimalstring(false)
  _e:= tbob.e.convertTodecimalstring(false)
  _d:= tbob.d.convertTodecimalstring(false)
  
   writeln('deliver textnumber demo ____________________'+CRLF)
   message:= '3000444555666777888';
   writeln('deliver textnumber to bob: '+message)
   s_encrypt:= BigPowMod(message,_e, _n)                  //bigmulu(p,q));
   writeln('encrypted textnumber bob '+s_encrypt)
   s_decrypt:= BigPowMod(s_encrypt,_d,_n)                 //bigmulu(p,q))
   writeln('decrypted textnumber bob '+s_decrypt)
    //*)
   loadCryptoForm;
   writeln('keysize alice: '+itoa(talice.keysize))
   writeln('keysize bob: '+itoa(tbob.keysize))
   writeln('blocksize alice: '+itoa(talice.blocksize))
   writeln('blocksize bob: '+itoa(tbob.blocksize))

End.

//http://delphiforfun.org/Programs/Math_Topics/RSA_KeyDemo.htm


