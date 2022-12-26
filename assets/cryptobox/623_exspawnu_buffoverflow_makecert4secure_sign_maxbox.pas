(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower SysTools
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1996-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

unit exspawnu;

interface

{uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ShellAPI, ExtCtrls,

  StBase, StSpawn;

  }
  
  //C:\Windows\System32\secur32.dll
  
  function getUserNameExA(nameform: DWord; namebuffer: array of char; 
                                               var nsize: DWord): boolean;
     external 'GetUserNameExA@secur32.dll stdcall';
     

//type
  //TForm1 = class(TForm)
  
  var
    StSpawnApplication1: TStSpawnApplication;
    btnSpawn: TBitBtn;
    RG1: TRadioGroup;
    OpenDialog1: TOpenDialog;
    cbNotify: TCheckBox;
    cbTimeout: TCheckBox;
    RG2: TRadioGroup;
       procedure btnSpawnClick(Sender: TObject);
       procedure StSpawnApplication1Completed(Sender: TObject);
       procedure StSpawnApplication1SpawnError(Sender: TObject; Error: Word);
       procedure StSpawnApplication1TimeOut(Sender: TObject);
     //private
       { Private declarations }
     //public
       { Public declarations }
       procedure EnableControls(B : Boolean);
     //end;

var
  Form1: TForm;

implementation

//{$R *.DFM}

procedure EnableControls(B : Boolean);
begin
  //rg1.Enabled := B;
  //rg2.Enabled := B;
  cbNotify.Enabled := B;
  cbTimeOut.Enabled := B;
  btnSpawn.Enabled := B;
end;

procedure btnSpawnClick(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    StSpawnApplication1.FileName := OpenDialog1.FileName;
    //StSpawnApplication1.SpawnCommand := TStSpawnCommand(rg1.ItemIndex);
    StSpawnApplication1.SpawnCommand:= scopen; //TStSpawnCommand(1);
    StSpawnApplication1.NotifyWhenDone := cbNotify.Checked;
    //if (rg2.ItemIndex = 0) then
      //StSpawnApplication1.ShowState := ssMinimized
    //else
    StSpawnApplication1.ShowState := ssNormal;
    StSpawnApplication1.TimeOut := Ord(cbTimeout.Checked) * 30;
    EnableControls(StSpawnApplication1.TimeOut = 0);
    StSpawnApplication1.Execute;
  end;
end;

procedure StSpawnApplication1Completed(Sender: TObject);
begin
  EnableControls(True);
  ShowMessage('Process Event Done');
end;

procedure StSpawnApplication1SpawnError(Sender: TObject; Error: Word);
begin
  EnableControls(True);
  ShowMessage(IntToStr(Error));
end;

procedure StSpawnApplication1TimeOut(Sender: TObject);
begin
  EnableControls(True);
  ShowMessage('Process TimeOut');
end;

function agetcomputerName: string;
var abuffer: array[0..4096] of char;
    size: cardinal;
    index: integer;
    
 begin
   size:= pred(sizeof(abuffer))
   
    //wgetcomputername(strPas(buffer), size);
   writeln(inttostr(size))
   writeln(inttostr(length(abuffer)-1))
   
   SetLength(result, Length(aBuffer));
   //Out Of Range at 20.464
   //for index:= 1 to Length(aBuffer) do
     // result[index]:=aBuffer[index];
   for index:= 0 to Length(aBuffer)-1 do
      result[index+1]:=aBuffer[index];
  
   //result:= strPas(abuffer);
   //Copy(Abuffer, Low(Abuffer), High(Abuffer) - Low(Abuffer) + 1);
   //result:= chararraytostr(buffer;
 end;  


function getUserNameExAfromDLL: string;
var abuffer: array[0..256] of Char;
    size, index: DWord;
    abuffer2: string;
    
 begin
   size:= pred(sizeof(abuffer))
   //wgetcomputername(strPas(buffer), size);
   writeln('first buffer size: '+inttostr(size))
   
   if getUserNameExA(2, abuffer, size) then
     SetString(result, abuffer2, Length(aBuffer)) else 
     result:= '';
   if result = '' then  
     result:= getuserName; 
    
   for index:= 0 to Length(aBuffer)-1 do
      aBuffer[index]:= ' ';
  
   //Out Of Range at 20.464
   //for index:= 1 to Length(aBuffer) do
     // result[index]:=aBuffer[index];
   //for index:= 0 to Length(aBuffer)-1 do
     // result[index+1]:=aBuffer[index];
     //result:= strPas(abuffer);
   //Copy(Abuffer, Low(Abuffer), High(Abuffer) - Low(Abuffer) + 1);
   //result:= chararraytostr(buffer;
   
   { SetLength(result, Length(aBuffer));
    if getUserNameExA(2, abuffer, size) then begin
         writeln('get the')
        //    SetString(result, abuffer2, Length(aBuffer))  
          for index:= 0 to Length(aBuffer)-1 do begin
             result[index+1]:= aBuffer[index];
             writeln(abuffer[index])
          end;   
     end;     }
          
 end;  
 
 function ArrayToString(const Data: array of string): string;
var
  SL: TStringList;
  S: string;
begin
  SL := TStringList.Create;
  try
    //for S in Data do ?
    for it:= 1 to length(data) do
      SL.Add(S);
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

procedure BufferTest;
var
  target : string;
  source : array[1..5] of Char;
  srcPtr : PChar;
  i      : Integer;
begin
  // Fill out the character array
  for i:= 1 to 5 do
    source[i] := Chr(i+64);

  // Copy these characters to a string
  //srcPtr := pchar(Addr(string(source)));
  //srcPtr := Addr(pchar(source));
    //  for it:= 0 to Length(source)-1 do
      //       srcptr:= source[it];
      
  SetString(target, srcPtr, 5);

  // Show what we have got
  ShowMessage('target now = '+target);
end;


function GetScreenShotXC: TBitmap; 
var Desktop:HDC;

begin
 Result:= TBitmap.Create;
 Desktop:= GetDC(0);
 try
 try
   Result.PixelFormat:=pf32bit;
   Result.Width:=Screen.Width;
   Result.Height:=Screen.Height;
   BitBlt(Result.Canvas.Handle,0,0,Result.Width,Result.Height,Desktop,0,0,SRCCOPY);
   Result.Modified:=True;
 finally
   ReleaseDC(0,Desktop);
 end;
 except
   Result.Free;
   Result:=nil;
 end;

end; 

procedure GradHorizontal(Canvas:TCanvas; Rect:TRect; FromColor, ToColor:TColor);
 var
   X:integer;
   dr,dg,db:Extended;
   C1,C2:TColor;
   r1,r2,g1,g2,b1,b2: byte; //integer; //Byte;
   R,G,B:Byte;
   cnt:integer;
 begin
   C1 := FromColor;
   R1 := GetRValue(ColorToRGB(C1)) ;
   G1 := GetGValue(C1) ;
   B1 := GetBValue(C1) ;
   C2 := ToColor;
   R2 := GetRValue(C2) ;
   G2 := GetGValue(C2) ;
   B2 := GetBValue(C2) ;
   dr := (R2-R1) / Rect.Right-Rect.Left;
   dg := (G2-G1) / Rect.Right-Rect.Left;
   db := (B2-B1) / Rect.Right-Rect.Left;
 
   cnt := 0;
   for X := Rect.Left to Rect.Right-1 do begin
     R := R1+Ceil(dr*cnt) ;
     G := G1+Ceil(dg*cnt) ;
     B := B1+Ceil(db*cnt) ;
 
     Canvas.Pen.Color := RGB(R,G,B) ;
     Canvas.MoveTo(X,Rect.Top) ;
     Canvas.LineTo(X,Rect.Bottom) ;
     inc(cnt) ;
   end;
 end;

procedure FormPaint(Sender: TObject);
var
  R: TRect;
begin
  R := form1.ClientRect;
  InflateRect(R, -40, -40);
  with form1 do begin
   Canvas.Brush.Color := clYellow;
   Canvas.Brush.Style := bsFDiagonal;
   Canvas.Pen.Color := clRed;
   Canvas.Rectangle1(R);
  end; 
end;


procedure networkGroup_Spy;
 var items: TStringlist;
   stn: TStNetGroupItem;
    itemtype: TSTNetItemType;
    netitem: TSTNetItem;
    STNetwork: TSTNetwork;
  
begin
 STNetwork:= TSTNetwork.create;
 stn:= STNetwork.group['','Users']
 items:= stn.items;
 for it:= 0 to items.count-1 do begin
   itemtype:= TStNetItem(items.objects[it]).itemtype;
   if (itemtype=nitlocaluser) or (itemtype=nitglobaluser) then
     writeln(TSTNetuseritem(items.objects[it]).fullname); 
 end;  
 stNetwork.free;
end;
  

procedure InitFirstForm;
var R: TRect;
begin
 form1:= TForm.Create(self);
 with form1 do begin
   FormStyle := fsStayOnTop;
   Position := poScreenCenter;
   caption:='Spawn Process BuffOver Universe BitmaX';
   color:= clwebgold;
   //show;
  { R := ClientRect;
  InflateRect(R, -10, -10);
  Canvas.Brush.Color := clYellow;
  Canvas.Brush.Style := bsFDiagonal;
  Canvas.Pen.Color := clRed;
  Canvas.Rectangle1(R); }
   {Canvas.Brush.Color:= clYellow;
   Canvas.Brush.Style:= bsFDiagonal;
   Canvas.Pen.Color:= clRed;}
   //canvas.brush.style:=
   width:= 650;
   height:= 500;
   Show;
   onpaint:= @formpaint;
  //invalidate;
  
   //onMousedown:= @Image1MouseDown;
   //onClose:= @CloseFormClick;
 end;
 
  //GradHorizontal(form1.Canvas, form1.ClientRect, clRed, clBlue) ;
 
  btnspawn:= TBitBtn.Create(form1) 
  with btnspawn do begin
      parent:= form1;
      SetBounds(350,280,141,35)
      Caption:= 'Process Start'
      glyph.LoadFromResourceName(getHINSTANCE,'CL_MPSTEP'); 
      OnClick:= @btnSpawnClick
    end;
    
    OpenDialog1:= TOpendialog.Create(self);
    //DefaultExtTXTFilter,Text files (*.txt)|*.txt|All files (*.*)|*.*
    
    StSpawnApplication1:= TStSpawnApplication.create(self);
    StSpawnApplication1.oncompleted:= @StSpawnApplication1Completed;
    StSpawnApplication1.onSpawnError:= @StSpawnApplication1SpawnError;
    StSpawnApplication1.onTimeout:= @StSpawnApplication1Timeout;
    
    
  cbnotify:= TCheckbox.Create(form1);
  with cbnotify do begin
    parent:= form1
    setbounds(150,241,120,30);
    checked:= true;
    caption:= ' Notify';
    //onclick:= @chkboxClick;
  end; 
 
  cbtimeout:= TCheckbox.Create(form1);
  with cbtimeout do begin
    parent:= form1
    setbounds(150,281,120,30);
    checked:= true;
    caption:= ' Timeout (30s)';
    //onclick:= @chkboxClick;
  end; 
  
 {Image1:= TImage.create(frmMon);
 with Image1 do begin
   parent:= frmMon;
   setbounds(10,15, 200,180);
   onMousedown:= @Image1MouseDown;
   show;
   //onMouseup:= @Image1MouseUp
 end;
 Image2:= TImage.create(frmMon);
 with Image2 do begin
   parent:= frmMon;
   setbounds(265,465,560,250);
   onMousedown:= @Image1MouseDown;
   show;
 end;}
end;

begin      {main}
 InitFirstForm;
 writeln('stack overflow simu: '+itoa(sizeOf(agetcomputerName)));
 writeln('stack overflow simu: '+itoa(length(agetcomputerName)));
 writeln('getUserNamefromDLL: '+getUserNameExAfromDLL)
 writeln(SHA1(Exepath+'maxbox4.exe'));
 writeln(SHA1('C:\Program Files (x86)\maxbox3\maxbox4.zip'));
   
 // changedir('C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64')
  //opendir('C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64')
  
  //opendir('C:\maXbox\softwareschule\IBZ_2016\IBZ_IT_Security_2016\DVD Inhalt\RSA Berechnung');
  opendir('C:\Program Files (x86)\Windows Kits\8.1\bin\x64');

 //writeln(SHA1('C:\maXbox\maxbox3\work2015\maXbox3digisign_certificates\maxbox4sign.exe'));
  
 //BufferTest;
 //IncludeTrailingBackslash
 //ExcludeTrailingBackslash
 //ForceDirectories

End.

//Doc: makecert

    {maxboxnews.htm
Exception: Timeout (120 seconds): closing control connection.
.    }
{function ArrayToString(const a: array of Char): string;
begin
  if Length(a)>0 then
    SetString(Result, PChar(@a[0]), Length(a))
  else
    Result := '';
end;}


{-n "CN=My Awesome Certificate Authority" 
         -cy authority 
         -a sha1 
         -sv "My Awesome Certificate Authority Private Key.pvk"
         -r
         "My Awesome Certificate Authority.cer"
         
         -n "CN=My Awesome Certificate Authority" 
         -cy authority 
         -a sha1 
         -sv "My Awesome Certificate Authority Private Key.pvk"
         -r
         "My Awesome Certificate Authority.cer"
         
         C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin>
         makecert -n "CN=maXboxCertAuth"
 -cy authority -a sha1 -sv "maXboxPrivateKey3.pvk" -r "maXboxCertAuth3.cer"
Succeeded

C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin>

maXboxPrivateKey3.pvk

maXboxPrivateKey3.pvk

maXboxPrivateKey3.pvk

Most certificates in common use are based on the X.509 v3 certificate standard.

C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin>makecert -n "CN=maXbox3signer"
-ic maxboxcertauth3.cer -iv maXboxprivatekey3.pvk -a sha1 -sky exchange -pe -sv
maxbox3signerprivatekey.pvk maxboxsigner.cer
Succeeded

C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin>

C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin>pvk2pfx -pvk "maXboxPrivateKey3
.pvk" -spc maXboxCertAuth3.cer -pfx maXboxCertAuth3.pfx -pi password

  C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin>signtool sign /f "maXboxCertAut
h3.pfx" /p "password" /tr http://tsa.starfieldtech.com /td SHA256 C:\maXbook\max
box3\mX3999\maxbox3\maxbox33.exe
Done Adding Additional Store
Successfully signed and timestamped: C:\maXbook\maxbox3\mX3999\maxbox3\maXbox33.
exe

//C:\maXbox\maxbox3\work2015\maXbox3digisign_certificates\maxbox44.exe

Real done: with signer ---------------------------------------

C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin>signtool sign /f "maXboxsigner.pfx" /p "password" /tr http://tsa.starfieldtech.com /td SHA256 C:\maXbook\max
box3\mX3999\maxbox3\maxbox44.exe
Done Adding Additional Store
Successfully signed and timestamped: C:\maXbook\maxbox3\mX3999\maxbox3\maXbox33.
exe

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool sign /f "maxboxsign
er.pfx" /p "password" /tr http://tsa.starfieldtech.com /td SHA256 C:\maxbox\ma
xbox3\work2015\maxbox3digisign_certificates\maxbox44.exe
Done Adding Additional Store
Successfully signed: C:\maxbox\maxbox3\work2015\maxbox3digisign_certificates\maX
box44.exe

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

Verify:

C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin>signtool verify /v /pa maxbox4s
ign.exe

Verifying: maXbox3sign.exe
Hash of file (sha1): AF60146981AB23C5F6CD0CB0D75F8D20FC3D7D1A

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 01:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox3signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 01:59:59 2040
        SHA1 hash: 80F45386E921A1DD620D59BE83D495E5352A9358

The signature is timestamped: Thu Jun 11 14:30:25 2015
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 01:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Mar 16 09:00:00 2020
        SHA1 hash: 113B5604A3689AEB636361771C5CA8DEBC97C02C

Successfully verified: maXbox3sign.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

-----------------------------------------------------------

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa C:\ma
Xbox\maxbox3\work2015\maXbox3digisign_certificates\maxbox4sign.exe

Verifying: C:\maXbox\maxbox3\work2015\maXbox3digisign_certificates\maXbox4sign.e
xe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 2E1157EFF8F9EB2F69C7809C1EDCBD1727692B1F

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox3signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 80F45386E921A1DD620D59BE83D495E5352A9358

The signature is timestamped: Wed Feb 03 18:32:56 2016
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Mar 16 08:00:00 2020
        SHA1 hash: 113B5604A3689AEB636361771C5CA8DEBC97C02C


Successfully verified: C:\maXbox\maxbox3\work2015\maXbox3digisign_certificates\m
aXbox4sign.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa C:\ma
xbox\maxbox3\work2015\maxbox3digisign_certificates\maxbox4sign.exe

of last exe:

Verifying: C:\maxbox\maxbox3\work2015\maxbox3digisign_certificates\maXbox4sign.e
xe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 08944839FE16F23DCE098B3B3805C11948AC2302

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox3signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 80F45386E921A1DD620D59BE83D495E5352A9358

The signature is timestamped: Sun Feb 07 14:31:36 2016
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Mar 16 08:00:00 2020
        SHA1 hash: 113B5604A3689AEB636361771C5CA8DEBC97C02C


Successfully verified: C:\maxbox\maxbox3\work2015\maxbox3digisign_certificates\m
aXbox4sign.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

---------------------------------------------------------

C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin>

C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin>     

a code signing version with certificates (digital signature):

http://sourceforge.net/projects/maxbox/files/Examples/maXbox3digisign_certificates.zip/download

http://sourceforge.net/projects/maxbox/files/Examples/12_Security.zip/download

Sign and Share with Scripts  
So during development, we may want to create code for our own purposes and then implicitly share them to test, deploy or reuse. But we don't really want to go to an app- or store authority and get a signed certificate for code signing, because that costs money and makes us dependent.
How can you sign and share code with self signed certificates and digital signatures.


Create a BAT file named SIGNCODE.BAT

I put my SIGNCODE.BAT file in a folder named C:\BAT so that it would be easy to type C:\BAT\SIGNCODE.BAT rather than a long folder path.
Hide   Shrink   Copy Code

@ECHO OFF
REM create an array of timestamp servers...
REM IMPORTANT NOTE - The SET statement and the four servers should be all on one line.
set SERVERLIST=(http://timestamp.comodoca.com/authenticode 
http://timestamp.verisign.com/scripts/timstamp.dll http://timestamp.globalsign.com/scripts/timestamp.dll http://tsa.starfieldtech.com)
REM sign the file...
C:\"Program Files (x86)"\"Windows Kits"\8.0\bin\x86\signtool.exe sign /n "COMPANYNAME Software" %1
set timestampErrors=0
for /L %%a in (1,1,300) do (
    for %%s in %SERVERLIST% do (
        Echo Try %%s
        REM try to timestamp the file. This operation is unreliable and may need to be repeated...
        C:\"Program Files (x86)"\"Windows Kits"\8.0\bin\x86\signtool.exe timestamp /t %%s %1
        REM check the return value of the timestamping operation and retry
        if ERRORLEVEL 0 if not ERRORLEVEL 1 GOTO succeeded
        echo Signing problem - timestamp server %%s
        set /a timestampErrors+=1
        Rem Wait 6 seconds
        choice /N /T:6 /D:Y >NUL
    )
    REM wait 12 seconds...
    choice /N /T:12 /D:Y >NUL
)
REM return an error code...
echo SignCode.bat exit code is 1. %timestampErrors% timestamping errors.
exit /b 1
:succeeded
REM return a successful code...
echo SignCode.bat exit code is 0. %timestampErrors% timestamping errors.
exit /b 0

7. Example of how to sign a program

In a CMD window, navigate to the directory that contains the program to be signed and run the BAT file.
Hide   Copy Code

C:\BAT\SIGNCODE.BAT SETUP.EXE


So how does this authority-issuing-thing work? A certificate authority themselves have a certificate with which they digitally sign all the certificates they issue. My computer (and pretty much everyone's) has a store of the certificates of these different certificate authorities. The computer then knows that if its sees any certificate that has been signed by one of these trusted certificate authorities' certificate, then the computer should trust that certificate. This concept is called "Chain Trust". The "chain" part refers to the "chain" of certificates-signing-certificates.

So during development, we may want to create certificates for our own purposes and then implicitly trust them. We don't really want to go to a certificate authority and get a signed certificate, because that costs money and we're cheap. Instead, what we can do is create our own certificate authority and then issue certificates to ourselves to use. We place this fake certificate authority's certificate in our computer's trusted certificate authorities store thereby causing our computer to implicitly trust all the certificates that we issue from that authority.

Note that this opens up a security hole on your PC, because if anyone was able to get a hold of your certificate authority certificate (and its private key, with which you sign certificates), they could create certificates that your computer would silently trust. Of course, this isn't too big a deal if you just slap a nice big password on your private key, and when you're finished developing, remove the fake certificate authority certificate from your trusted certificate store.


Strange times we live in. The world’s biggest financial players and analysts are buzzing about an invention that became famous partly by promising to destroy them.

In just a few months, blockchain went from the cause célèbre of crypto-anarchists and tech evangelists to the biggest idea in mainstream banking. We’ve seen a steady stream of blockchain news: five more banks joined the massive R3 consortium (its membership reads like a who’s-who of global finance), Nasdaq announced its first share transaction on blockchain and the Australian stock exchange announced it would test blockchain for trade settlement.

The irony is that blockchain gained worldwide prominence because of bitcoin — and many bitcoin supporters think that cryptocurrency spells the downfall of the global banking system. But today, the buzz is about the blockchain — a type of consensus-based computing that underpins bitcoin and other services.

A blockchain is a record of digital events that is cryptographically impossible to fake or manipulate. Financial firms are exploring a number of uses, from transfers to clearing mechanisms to intra-bank settlements. The idea is to create a shared infrastructure, where many of these transactions (that now can take days) can settle instantly and transparently.

But what few insiders seem willing to admit is that, like similar projects, this effort will face some daunting institutional challenges that make near-term success unlikely.

The biggest of these challenges is obvious: Banks today make huge profits on financial transactions. If transfers suddenly became instantaneous and worry-free, who would pay a bank to facilitate them? The former head of Barclays technology thinks the current interest in blockchain is “cynical.” He claims banks want to exert control, rather than drive meaningful reforms.

They trust and don't understand o.k., but at the same they see advantages more than before. For example the money mining or selfsigning of a document. We don't really want to go to an app- or store authority and get a signed certificate for code signing, because that costs money and makes us dependent.
They can sign and share code, transactions or values with self signed certificates and digital signatures and that's the point the technology is decentralized. 

 http://techcrunch.com/2015/12/08/what-can-we-call-blockchain-to-help-people-understand-it/

My Application’s Keys
Consumer Key 	4fq4nLMtfdWnJIHxAOIw8juuFpXymkaa
Consumer Secret 	AyqwePelNpVnF1sN
Key Issued 	Fri, 02/05/2016 - 12:51
Key Expires 	Never


 C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify C:\maXbox\ma
xbox3\work2015\maXbox3digisign_certificates\maxbox4sign.exe
File: C:\maXbox\maxbox3\work2015\maXbox3digisign_certificates\maXbox4sign.exe
Index  Algorithm  Timestamp
========================================
SignTool Error: A certificate chain processed, but terminated in a root
        certificate which is not trusted by the trust provider.

Number of errors: 1

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa C:\ma
Xbox\maxbox3\work2015\maXbox3digisign_certificates\maxbox4sign.exe

Verifying: C:\maXbox\maxbox3\work2015\maXbox3digisign_certificates\maXbox4sign.e
xe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 08944839FE16F23DCE098B3B3805C11948AC2302

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox3signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 80F45386E921A1DD620D59BE83D495E5352A9358

The signature is timestamped: Sun Feb 07 14:31:36 2016
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Mar 16 08:00:00 2020
        SHA1 hash: 113B5604A3689AEB636361771C5CA8DEBC97C02C


Successfully verified: C:\maXbox\maxbox3\work2015\maXbox3digisign_certificates\m
aXbox4sign.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

  C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>makecert -n "CN=maXbox4" -ic
 maxboxsigner.cer -iv maXboxPrivateKey3.pvk -a sha1 -sky exchange -pe -sv maXbox
4privatekey.pvk maXbox4.cer
Error: Can't access the key of the issuer ('maXboxPrivateKey3.pvk')
Failed

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>makecert -n "CN=maXbox4" -ic
 maxboxsigner.cer -iv maXboxPrivateKey3.pvk -a sha1 -sky exchange -pe -sv maXbox
4privatekey.pvk maXbox4.cer
Error: Can't load the issuer certificate ('maxboxsigner.cer')
Failed

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>makecert -n "CN=maXbox4" -ic
 maxboxsigner.cer -iv maXboxPrivateKey3.pvk -a sha1 -sky exchange -pe -sv maXbox
4privatekey.pvk maXbox4.cer
Error: Issuer's public key doesn't correspond to its private key
Failed

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>makecert -n "CN=maXbox4" -ic
 maxboxcertauth3.cer -iv maXboxPrivateKey3.pvk -a sha1 -sky exchange -pe -sv maX
box4privatekey.pvk maXbox4.cer
Error: Can't load the issuer certificate ('maxboxcertauth3.cer')
Failed

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>makecert -n "CN=maXbox4" -ic
 maxboxcertauth3.cer -iv maXboxPrivateKey3.pvk -a sha1 -sky exchange -pe -sv maX
box4privatekey.pvk maXbox4.cer
Succeeded

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>


    Run Cmd.exe as administrator.
    Run this command:


    Certutil -addStore TrustedPeople MyKey.cer

We recommend that you remove the certificates if they are no longer in use. From the same administrator command prompt, run this command:


Certutil -delStore TrustedPeople certID

https://msdn.microsoft.com/en-us/library/windows/desktop/ms537361%28v=vs.85%29.aspx

http://www.jayway.com/2014/09/03/creating-self-signed-certificates-with-makecert-exe-for-development/

 http://stackoverflow.com/questions/2292495/what-is-the-difference-between-a-cer-pvk-and-pfx-file


 19114de169a6cbf61d67d1a32b9513690cceb6bd   zip mx4

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool sign /f "maxboxsign
er.pfx" /p "passith1" /tr http://tsa.starfieldtech.com /td SHA256 C:\maxbox\ma
xbox3\work2015\maxbox3digisign_certificates\maXbox4.exe
Done Adding Additional Store
Successfully signed: C:\maxbox\maxbox3\work2015\maxbox3digisign_certificates\maX
box4.exe


 Volume in drive C is Windows
 Volume Serial Number is 7C7A-AA7F

 Directory of C:\maXbox\maxbox3\maxbox3\maXbox3

12/03/2016  16:11    <DIR>          .
12/03/2016  16:11    <DIR>          ..
19/10/2015  18:09                 0 airmaxloop3.mp3
18/01/2016  10:45           471,742 All_lotto_combinations2.txt
28/10/2015  15:05                 0 arduino_training.pdf
24/08/2015  07:55           116,019 bds_delphi.dci
04/10/2015  22:04         3,155,494 ChessSolution_Res12codes.txt
04/10/2015  22:08            11,123 ChessSolution_Res8codes.txt
17/01/2016  18:27           120,856 ChessSolution_Res9codes.txt
18/01/2016  10:25            10,387 chesssolution_result.txt
03/02/2016  17:34               496 cipherbox_log2.txt
14/03/2016  09:41           599,596 codesearchreport.txt
06/02/2016  13:04            10,834 cologne2map345.html
24/08/2015  07:55    <DIR>          crypt
04/10/2015  18:26             4,719 crypto_readmefirst.txt
18/01/2016  18:16             8,502 dayio_mx.pas
24/08/2015  07:55           254,464 dbxint30.dll
15/09/2015  09:55                54 Default.ini
24/08/2015  07:55           580,096 dmath.dll
12/03/2016  18:07    <DIR>          docs
13/03/2016  19:08    <DIR>          examples
18/01/2016  12:37    <DIR>          examples2
24/08/2015  07:56    <DIR>          exercices
03/02/2016  16:56            25,129 firstdemo.txt
24/08/2015  07:55             7,382 firstdemo3.txt
24/08/2015  07:55             4,396 firstdemo3.uc
13/03/2016  23:02            25,129 firstdemo_copy.txt
24/08/2015  07:55           176,128 FTD2XX.dll
14/03/2016  14:29                63 FUNGAME.INI
18/01/2016  10:49             6,256 golgraph37.png
27/09/2015  13:53             2,687 htmlexport.htm
27/09/2015  14:08             1,944 htmlexport2.htm
18/12/2015  19:08    <DIR>          Import
24/08/2015  07:55           103,424 income.dll
03/02/2016  14:59            50,438 ledList1.dat
24/08/2015  07:55               195 maildef.ini
24/08/2015  07:55            13,973 maxbootscript_.txt
24/08/2015  07:55            59,060 maxbox.mp3
24/08/2015  07:55            71,807 maxbox.png
24/08/2015  07:59        25,152,000 maXbox3.exe
20/11/2015  17:38             1,189 maXbox3.INI
02/11/2015  11:05               171 maXbox3.log
29/01/2016  23:35           144,288 maXbox3.RIP
24/08/2015  07:55         6,490,764 maxbox3clx
13/03/2016  21:07        26,624,000 maXbox4.exe
26/01/2016  09:19             1,356 maXbox4.exe - Shortcut.lnk
06/02/2016  23:39            48,253 maXbox4.RIP
06/02/2016  20:03        26,506,752 maXbox4j.exe
24/01/2016  12:00        26,062,336 maXbox4sws.exe
29/01/2016  23:19               479 maXbox4sws.RIP
29/01/2016  16:30        26,178,560 maxbox4_0.exe
14/03/2016  15:13             1,697 maxboxdef.ini
13/03/2016  23:02             1,698 maxboxdef.ini.BACKUP
06/02/2016  23:39            51,425 maxboxerrorlog.txt
13/03/2016  22:14         1,940,797 maxboxlog.log
24/08/2015  07:55            99,104 maxboxnews.htm
12/01/2016  23:28               224 maxboxunit.ini
24/08/2015  07:55         5,359,271 maxbox_functions_all.pdf
24/08/2015  07:55         3,252,692 maxbox_types.pdf
24/08/2015  07:55            10,291 maxdefine.inc
05/02/2016  22:46                50 maxmapfile.html
18/01/2016  10:20             1,027 memlist.txt
18/01/2016  11:12             1,051 memory3.ini
24/08/2015  07:55           383,488 midas.dll
12/03/2016  21:46                46 Minesweeper.ini
06/02/2016  13:09             5,727 mX3QRCode2map3.png
06/02/2016  23:30             8,246 mX3QRCode2map333.png
17/10/2015  13:42             1,308 mX3QRCode3.png
14/03/2016  10:28             8,246 mX3QRCodeMonitor4.png
03/09/2015  22:17             1,146 mXfileChangeToday_list.txt
02/12/2015  23:22           473,848 mx_screenshot.png
18/01/2016  11:18               825 mycopy.txt
18/01/2016  11:18             1,599 mylog.txt
26/08/2015  07:52           151,851 mytestpdf.pdf
21/10/2015  21:48           713,882 mytestpdf42.pdf
29/10/2015  09:09            50,438 MyWeathermapImageList.dat
03/02/2016  17:34    <DIR>          NewWipeDir
03/02/2016  17:36    <DIR>          NewWipeDir3
19/09/2015  20:30    <DIR>          Nr44_age
19/09/2015  20:09            13,111 Nr44_age.zip
12/12/2015  17:11    <DIR>          parabank
24/08/2015  07:55            22,654 pas_includebox.inc
18/01/2016  10:26            11,161 primetest_thieves.txt
04/10/2015  18:26             4,719 readmefirst_maxbox.txt
24/08/2015  07:55            71,644 readmefirst_maxbox3.txt
26/09/2015  15:46                 0 scholzdata22.txt
19/01/2016  17:20         5,308,470 screenshot15.bmp
02/12/2015  23:18        10,616,886 screenshot5.bmp
03/02/2016  17:03             8,266 SkipList.txt
24/08/2015  07:58    <DIR>          source
05/01/2016  14:58                87 STINITEST.TXT
28/10/2015  21:32             4,067 stlist.htm
01/09/2015  22:57             2,726 synapsemimedemo.txt
19/10/2015  13:43               658 sysinformation_fromMemo.txt
03/02/2016  17:03               930 systemchecklog5.txt
12/01/2016  23:24                65 terminal.ini
06/02/2016  12:59         4,490,023 texturemap77.jpg
24/08/2015  07:55           135,168 TIFFRead.dll
18/01/2016  10:28               110 timerobject2_log.txt
13/09/2015  11:25             5,775 TimeServer7Script.txt
24/08/2015  07:55           244,984 TUTIL32.DLL
15/10/2015  11:24           713,882 tutor42.pdf
21/10/2015  22:00                 0 weather.txt
12/12/2015  20:11           118,223 weatherapp2.txt
29/10/2015  09:10            50,438 weatherimagelist.dat
29/10/2015  12:47            25,322 WeatherImageList1.dat
24/08/2015  07:58    <DIR>          web
03/02/2016  17:36                 0 _decrypt
              94 File(s)    177,471,887 bytes
              14 Dir(s)  694,691,336,192 bytes free

C:\maXbox\maxbox3\maxbox3\maXbox3>cd C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10
\bin\x64

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool sign /f "maxboxsign

SignTool Error: Missing filename.

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>er.pfx" /p "password" /tr ht
tp://tsa.starfieldtech.com /td SHA256 C:\maxbox\ma
The filename, directory name, or volume label syntax is incorrect.

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool sign /f "maxboxsign
er.pfx" /p "th1" /tr http://tsa.starfieldtech.com /td SHA256 C:\maxbox\ma
xbox3\work2015\maxbox3digisign_certificates\maXbox4.exe
Done Adding Additional Store
Successfully signed: C:\maxbox\maxbox3\work2015\maxbox3digisign_certificates\maX
box4.exe

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool sign /f "maxboxsign

SignTool Error: Missing filename.

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>er.pfx" /p "password" /tr ht
tp://tsa.starfieldtech.com /td SHA256 C:\maxbox\ma
The filename, directory name, or volume label syntax is incorrect.

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool sign /f "maxboxsign

SignTool Error: Missing filename.

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify C:\maXbox\ma
xbox3\work2015\maXbox3digisign_certificates\maXbox4sign.exe
File: C:\maXbox\maxbox3\work2015\maXbox3digisign_certificates\maXbox4sign.exe
Index  Algorithm  Timestamp
========================================
SignTool Error: A certificate chain processed, but terminated in a root
        certificate which is not trusted by the trust provider.

Number of errors: 1

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify C:\maXbox\ma
xbox3\work2015\maXbox3digisign_certificates\maXbox4sign.exe
File: C:\maXbox\maxbox3\work2015\maXbox3digisign_certificates\maXbox4sign.exe
Index  Algorithm  Timestamp
========================================
SignTool Error: A certificate chain processed, but terminated in a root
        certificate which is not trusted by the trust provider.

Number of errors: 1

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa C:\ma
Xbox\maxbox3\work2015\maXbox3digisign_certificates\maXbox4sign.exe

Verifying: C:\maXbox\maxbox3\work2015\maXbox3digisign_certificates\maXbox4sign.e
xe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 5782846BC951F610C1F802D399312F20A622E1D4

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox3signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 80F45386E921A1DD620D59BE83D495E5352A9358

The signature is timestamped: Mon Mar 14 15:59:04 2016
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Tue Feb 16 08:00:00 2021
        SHA1 hash: 8D517FC99F3B23CEC36B3B0CB3B7E51ACD344BCE


Successfully verified: C:\maXbox\maxbox3\work2015\maXbox3digisign_certificates\m
aXbox4sign.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

> Abrechnungsnummer: EM6.2015/5 
> Artikel: Wetter
> Gesamtbetrag in Euro: 57,44

https://www.belogin.directories.be.ch/taxme-npo/tmo2015/facelets/edit.jsf


Verifying: maXbox4sign.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): B7C02D5025D176F8BFCF293E18C05A4812200E67

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 01:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox3signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 01:59:59 2040
        SHA1 hash: 80F45386E921A1DD620D59BE83D495E5352A9358

The signature is timestamped: Sun May 15 22:46:23 2016
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 01:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Tue Feb 16 09:00:00 2021
        SHA1 hash: 8D517FC99F3B23CEC36B3B0CB3B7E51ACD344BCE


Successfully verified: maXbox4sign.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>


24/08/2015  08:56             2,384 country.xml
24/08/2015  08:56               343 Cry-RSA-169_hashtester.hex
24/08/2015  08:56           104,136 cryptobox.png
24/08/2015  08:56            45,540 cryptoscripts.zip
24/08/2015  08:56               766 cube.ico
24/08/2015  08:56            14,194 customer.xml
24/08/2015  08:56            31,163 D7Grammar.grm
24/08/2015  08:56           126,976 database3.mdb
22/10/2015  20:41             7,185 Datenbankdiagnose.pas
22/10/2015  20:51             7,244 Datenbankdiagnose_mx.pas
19/05/2016  10:35               595 debug2log.txt
24/08/2015  08:56            66,643 delphilogo7.jpg
12/04/2016  00:28             5,899 demoscript.txt
22/10/2015  14:27           118,622 design.txt
24/08/2015  08:56             4,096 DETAIL.DB
19/05/2016  23:02               128 detail.ldb
24/08/2015  08:56           126,976 detail.mdb
24/08/2015  08:56             4,096 DETAIL.PX
24/08/2015  08:56             4,096 DETAIL.X02
24/08/2015  08:56             4,096 DETAIL.Y02
12/12/2015  21:01             7,172 dice.txt
24/08/2015  08:56    <DIR>          dmath_demos
24/08/2015  08:56    <DIR>          earthplay
24/08/2015  08:56    <DIR>          earthplay2
24/08/2015  08:56             3,750 earthplayer.uc
24/08/2015  08:56               439 ebnftest.txt
24/08/2015  08:56             6,873 ebnftest2.txt
24/08/2015  08:56            33,130 ecg2.csv
24/08/2015  08:56               853 EchoString.SOP
20/11/2015  14:01            73,728 employeetestdb.mdb
20/11/2015  18:38           765,952 employeetestdb2.mdb
20/11/2015  19:22            65,536 employeetestdb2xx.mdb
20/11/2015  19:27            65,536 employeetestdb3xx.mdb
23/05/2016  20:41             2,699 envinfo.txt
24/08/2015  08:56             2,954 examplesindex_draft.htm
24/08/2015  08:56            10,020 faszination_tee.jpg
05/06/2016  19:07               513 Filename_savereport.txt
18/01/2016  11:27             1,029 filesfound2.txt
13/04/2016  22:22             4,857 firstdemo.txt
24/08/2015  08:56             1,759 firstdemo2.txt
24/08/2015  08:56             3,862 firstdemo2.uc
24/08/2015  08:56             3,784 firstdemo3.txt
24/08/2015  08:56             3,866 firstdemo3.uc
24/08/2015  08:56             3,593 firstdemo3_loadmp3.txt
24/08/2015  08:56             3,866 firstdemo3_loadmp3.uc
24/08/2015  08:56             1,402 firstdemo_compress.txt
24/08/2015  08:56             4,882 firstdemo_copy.txt
24/08/2015  08:56           263,349 fotomax_mxcam.png
24/08/2015  08:56           125,164 fractals_main.jpg
24/08/2015  08:56           162,816 FreeUDFLib.dll
24/08/2015  08:56            12,325 freeudfscript.sql
24/08/2015  08:56           330,493 Full.dic
24/08/2015  08:56            64,162 fullmoon.png
24/08/2015  08:56           148,394 fullmoon2.png
24/08/2015  08:56           110,640 General.dic
24/08/2015  08:56             8,161 GEOGPS.TXT
24/08/2015  08:56           120,846 geosatellite.png
24/08/2015  08:56             6,217 golgraph0.png
24/08/2015  08:56             6,626 golgraph116granddesign.png
24/08/2015  08:56             7,541 GPS2.inc
24/08/2015  08:56            15,120 GPS2.pas
24/08/2015  08:56            62,467 gpsdata_mX.pas
24/08/2015  08:56             5,352 GPSkursberechnungmx2.pas
24/08/2015  08:56             5,304 gpxkursberechnungmx.pas
18/05/2016  19:17         1,920,054 graphsimple.bmp
18/05/2016  19:18         1,920,054 graphsimple2.bmp
18/04/2016  16:40            32,320 gravity_processing1mx.png
18/04/2016  16:41            33,556 gravity_processing2mx.png
18/04/2016  17:29            32,228 gravity_processing3mx.png
18/04/2016  16:38            32,732 gravity_processingimage1_old.png
25/01/2016  23:24            39,593 hanoilist.txt
14/03/2016  19:43            39,593 hanoilist4.txt
24/08/2015  08:56            12,156 heartbeat.txt
24/08/2015  08:56             6,580 helper_unit.INC
24/08/2015  08:56             2,742 ibzresult.txt
29/10/2015  09:35    <DIR>          images
24/08/2015  08:56           103,424 income.dll
24/08/2015  08:56             4,418 IVCLScanner.TXT
24/08/2015  08:56             4,140 IVCLScanner.xml
24/08/2015  08:56            27,055 JclUnitConv_mx.pas
13/03/2016  18:10           182,254 kmemo_manual.rtf
15/05/2016  13:45           138,580 kmemo_maxmanual_copy.rtf
24/08/2015  08:56               367 koDaten.txt
24/08/2015  08:56             1,689 logo1689_defect.gif
22/12/2015  11:26            84,460 macaffetrustCapture.PNG
18/04/2016  18:34               132 mailtest.txt
24/08/2015  08:56               243 makeres.bat
24/08/2015  08:56               230 map_1.btl
24/08/2015  08:56               230 map_2.btl
25/04/2016  10:00             2,730 mathmax.gif
15/05/2016  19:53            65,536 max112_90testdb.mdb
24/08/2015  08:56           126,976 maxbase3.mdb
15/05/2016  19:08           126,976 maxbase3Copy.mdb
24/08/2015  08:56            59,060 maxbox.mp3
24/08/2015  08:56            71,807 maxbox.png
24/08/2015  08:56           116,974 maxbox.wav
24/08/2015  08:56            71,807 maxbox3.png
24/08/2015  08:56           103,826 maxbox3_9.xml
24/08/2015  08:56            34,033 maxbox4.JPG
24/08/2015  08:56            57,878 maxboxgui29.png
24/08/2015  08:56            16,694 maxboxlogo.bmp
24/08/2015  08:56            99,104 maxboxnews.htm
24/08/2015  08:56             2,981 maxboxnewsticker.htm
24/08/2015  08:56               225 maxboxunit.ini
21/04/2016  15:16         1,724,463 maxbox_functions2.txt
24/08/2015  08:56            18,336 maxbox_logo2.jpg
24/08/2015  08:56            28,198 maxbox_logo3.jpg
24/08/2015  08:56               359 maXbox_mp3files.txt
18/04/2016  13:44           681,676 maxbox_reactos_Capture.PNG
24/08/2015  08:56            13,824 maxceltest3.xls
27/05/2016  21:03             9,533 maxdefine.inc
24/08/2015  08:56             1,128 maxfonttest.uc
26/04/2016  12:06             5,398 maxpipe.pas
24/08/2015  08:56           481,078 max_locomotion.bmp
15/05/2016  15:26           481,078 max_locomotion_back.bmp
15/05/2016  15:26           962,156 max_locomotion_crypt.txt
24/08/2015  08:56               603 memory3.ini
24/08/2015  08:56               342 MILO3.udl
22/12/2015  12:44            34,589 minestudy2Capture.PNG
22/12/2015  13:00            34,930 minestudy3nextCapture.PNG
22/12/2015  22:30            35,895 minestudy3solut2Capture.PNG
22/12/2015  22:32            34,320 minestudy3solut3Capture.PNG
22/12/2015  19:54            32,700 minestudy3solutCapture.PNG
22/12/2015  12:37            30,622 minestudyCapture.PNG
24/08/2015  08:56            68,056 moon.wav
24/08/2015  08:56            11,149 moon2.psb
24/08/2015  08:56             7,945 moon2.txt
24/08/2015  08:56           158,165 moonbox.png
24/08/2015  10:12           323,497 mspdftest.pdf
12/04/2016  08:19         2,255,986 MT_Bericht_opsmobile_HS15.23_Anhang_A_Lasten
heft.pdf
24/08/2015  08:56             1,311 mX3QRCode3_mx.png
24/08/2015  08:56             9,490 mX4Untitled.rtf
24/08/2015  08:56            25,556 mxEXPERT_radioclock23.pas
24/08/2015  08:56           228,392 mXgames.zip
24/08/2015  08:56            12,342 mxlogoball.bmp
24/08/2015  08:56            18,944 mXMorse.java
24/08/2015  08:56            19,753 mXpacdia.png
29/05/2016  16:53                34 myfilebin.txt
24/08/2015  08:56               204 mymemomemoire.txt
27/08/2015  22:34               214 mymemomemoire_tester.txt
01/12/2015  13:08            30,742 myweather.txt
24/08/2015  08:56             2,801 NavUtils.pas
24/08/2015  08:56             1,024 newfile9.txt
24/08/2015  08:56               403 newtemplate.txt
24/08/2015  08:56             4,318 NMEA.pas
24/08/2015  08:56            92,288 ocx_mediaplayer.png
24/08/2015  08:56            15,750 openmapx.html
24/08/2015  08:56             7,125 oposlogo.gif
24/08/2015  08:56            42,664 orders.xml
24/08/2015  08:56               198 outline.txt
24/08/2015  08:56               276 outline2.txt
24/08/2015  08:56               378 outline3.txt
24/08/2015  08:56             8,172 parts.xml
24/08/2015  08:56            31,362 pascalscript.pdf
24/08/2015  08:56           289,936 PasParse.pas
24/08/2015  08:56            17,202 pas_includebox.inc
24/08/2015  08:56            22,981 pas_includebox_laz.inc
24/08/2015  08:56            10,199 PathFuncTest_mX.pas
21/10/2015  18:11           112,075 patternFrm_mx3.txt
22/10/2015  14:34           118,622 patternFrm_mx3EKON19.txt
23/04/2016  21:44            22,194 picturepuzzle2.txt
24/08/2015  08:56            15,757 picturepuzzle3.txt
06/10/2015  09:43                 0 pinumbers7000.txt
26/04/2016  11:57            36,549 pipe2codeanalyzer.gif
07/04/2016  16:10             8,999 pipenewtemplate.txt
26/04/2016  11:56           133,961 pipetable_overview.gif
06/10/2015  09:57             7,278 pi_numbers7000 - Copy.txt
06/10/2015  09:57             7,278 pi_numbers7000.txt
06/10/2015  14:09             7,240 pi_numbers7000_2.txt
06/10/2015  09:54                 0 pi_numbers8000.txt
05/04/2016  16:42            46,711 pointer_false_correct_Filename_savereport.tx
t
06/04/2016  18:39            51,049 pointer_false_correct_Filename_savereport_mX
4.txt
24/08/2015  08:56             3,908 prectime_unit.pas
27/05/2016  10:04             1,717 primetest7.txt
27/05/2016  10:04             1,717 primetest8.txt
24/08/2015  08:56            15,112 promanager.tif
15/05/2016  19:14             7,295 randomnoise1.txt
18/04/2016  08:46             9,892 rawbaseFilename_savereport.txt
24/08/2015  08:56             4,719 readmefirst_maxbox.txt
24/08/2015  08:56            71,436 readmefirst_maxbox3.txt
24/08/2015  08:56            33,206 readme_maxbox3.txt
24/08/2015  08:56               555 regexlist.txt
24/08/2015  08:56            55,967 registerpubFilename_savereport.txt
30/05/2016  22:14               884 resstring4096
18/12/2015  21:53         1,442,161 reversusCapture.PNG
24/08/2015  08:56             3,036 Rockdisco.m3u
13/01/2016  10:09                 0 scholzdata223.txt
24/08/2015  08:56           277,034 sejour2048.jpg
24/08/2015  08:56            27,922 serialtcp.png
02/02/2016  22:11            18,854 Shadow.BMP
24/08/2015  08:56             5,545 simpleRTF_unit.txt
24/08/2015  08:56             5,954 streamreaderror.png
24/08/2015  08:56             4,318 surprise.txt
02/01/2016  17:29            44,922 sylvestermax2016.jpg
13/01/2016  10:11               658 sysinformation_fromMemo.txt
24/08/2015  08:56            14,183 tartaruga.txt
24/08/2015  08:56               679 TEARTH.png
24/08/2015  08:56               605 TEARTHLAYERDS.png
24/08/2015  08:56            32,697 tee6358_2.jpg
18/01/2016  11:21             1,686 TEE_logo_real.gif
24/08/2015  08:56                64 terminal.ini
28/03/2016  18:59             2,056 test10_win
24/08/2015  08:56             3,181 TestGPX.gpx
15/05/2016  17:51            33,334 testmx3.wav
13/01/2016  10:06         4,490,023 texturemap.jpg
24/08/2015  08:56               854 TGISENGINE.png
24/08/2015  08:56               672 TGSCENARIOENGINE.png
24/08/2015  08:56             7,990 Time.bmp
24/08/2015  08:56                68 treeview_300.txt
24/08/2015  08:56            38,571 turtle2.txt
26/04/2016  12:11             5,431 umaxpipes.pas
24/08/2015  08:56           379,904 UMLBANK12.GDB
24/08/2015  08:56           333,824 UMLBANK4.GDB
27/04/2016  12:43               663 Unit1.dfm
24/08/2015  08:56    <DIR>          units
19/05/2016  20:45    <DIR>          units2
24/08/2015  08:56            13,367 units_explorer_ref.pac
24/08/2015  08:56            13,367 units_explorer_ref2.pac
24/08/2015  08:56           294,478 upsi_allfunctionslist.txt
24/08/2015  08:56            38,417 upsi_allobjectslist.txt
04/09/2015  23:08            13,400 uPSI_ParserU.pas
24/08/2015  08:56             8,029 U_BigFloatTest.dfm
24/08/2015  08:56             5,315 U_BigFloatTest.pas
24/08/2015  08:56             3,868 varioustest.uc
24/08/2015  08:56               623 VCLScannerServer_WSDLADMIN.INI
24/08/2015  08:56             8,422 Verinfo.pas
17/01/2016  19:33           118,776 weatherapp2.txt
06/02/2016  00:02           119,226 weatherapp2onselect.txt
24/08/2015  08:56            15,005 webserver_arduino.png
24/08/2015  08:56            15,837 webserver_file.png
15/05/2016  19:14            42,370 whitenoise2.png
19/05/2016  22:56             1,047 xmlexample2.xml
24/08/2015  08:56             1,202 xmlproparray.xml
24/08/2015  08:56            89,730 yacc2gold.pas
24/08/2015  08:56             5,649 ZipCodes.txt
            1854 File(s)     62,758,146 bytes
              11 Dir(s)  669,302,583,296 bytes free

C:\maXbox\maxbox3\maxbox3\maXbox3\examples>cd C:\maXbox\EKON_BASTA\EKON19\Window
s Kits\10\bin\

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin>cd x64

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool sign /f "maxboxsign
er.pfx" /p "Aerosmith1" /tr http://tsa/starfieldtech.com /td SHA256 maXbox4sign.
exe
Done Adding Additional Store
SignTool Error: The specified timestamp server either could not be reached or
returned an invalid response.
SignTool Error: An error occurred while attempting to sign: maXbox4sign.exe

Number of errors: 1

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool sign /f "maxboxsign
er.pfx" /p "Aerosmith1" /tr http://tsa.starfieldtech.com /td SHA256 maXbox4sign.
exe
Done Adding Additional Store
Successfully signed: maXbox4sign.exe

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa maxbo
x4sign.exe

Verifying: maXbox4sign.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): FDF4444BBE5B13083194E23020FA5D89150A9729

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 01:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox3signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 01:59:59 2040
        SHA1 hash: 80F45386E921A1DD620D59BE83D495E5352A9358

The signature is timestamped: Mon Jun 06 09:42:19 2016
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 01:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Tue Feb 16 09:00:00 2021
        SHA1 hash: 8D517FC99F3B23CEC36B3B0CB3B7E51ACD344BCE


Successfully verified: maXbox4sign.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0


4.2.5.10  III
4.2.6.10  I

4.2.8.10  II
4.2.8.10  III
4.2.8.10  IV
4.2.8.10  V
4.5.8.10
4.5.8.10  IV

4.6.2.10 

4.7.1.10
4.7.1.20
4.7.1.80
4.7.1.82
4.7.2.82
4.7.2.82 II
4.7.3.60
4.7.4.60

Microsoft Windows SDK for Windows 8.1 and .NET Framework 4.5.1 

cd:
C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>


C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool sign /f "maxbox4exe
.pfx" /p "Aerosmith1" /tr http://tsa.starfieldtech.com /td SHA256 maXbox4.exe
Done Adding Additional Store
Successfully signed: maXbox4.exe

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>
signtool sign /f "maxbox4exe.pfx" /p "Aerosmith1" /tr http://tsa.starfieldtech.com /td SHA256 maXbox4.exe
Done Adding Additional Store
Successfully signed: maXbox4.exe


C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>
signtool verify /v /pa maXbox4.exe

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa maXbo
x4.exe

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa maXbo
x4.exe

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 1CCA9F3C44EAE8660238A4EF2D41F156C8C39F97

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 01:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 01:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 01:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Tue Apr 14 23:02:24 2020
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 01:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Secure Certificate Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Sat May 03 09:00:00 2031
        SHA1 hash: 7EDC376DCFD45E6DDF082C160DF6AC21835B95D4

            Issued to: Starfield Timestamp Authority - G2
            Issued by: Starfield Secure Certificate Authority - G2
            Expires:   Tue Sep 17 09:00:00 2024
            SHA1 hash: E8551398FF530A9278FD9818E448CB333F67924D


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 897777AFCC22BD0E0FBB99109D8501339526BC1B

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 01:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 01:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 01:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Thu Apr 09 22:44:05 2020
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 01:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Secure Certificate Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Sat May 03 09:00:00 2031
        SHA1 hash: 7EDC376DCFD45E6DDF082C160DF6AC21835B95D4

            Issued to: Starfield Timestamp Authority - G2
            Issued by: Starfield Secure Certificate Authority - G2
            Expires:   Tue Sep 17 09:00:00 2024
            SHA1 hash: E8551398FF530A9278FD9818E448CB333F67924D


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): D29B705C6977E68C3AA3DF3E23AF37BB8B5E8F9E

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 00:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Sun Feb 05 17:53:45 2017
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 08:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa maXbox4.exe

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 6A33166840926F1F04397036A60669EE8A6F774B

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 00:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Tue Feb 07 17:17:51 2017
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 08:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

  C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa maXbox4.exe

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): B496857A4C47D37B6DDE69E7701A2C47D587747E

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 00:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Fri Feb 10 11:06:28 2017
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 08:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): E09A39AE6EF07D5C3030BD74973BB40119CCD34E

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 01:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 01:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 01:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Tue Aug 22 15:13:45 2017
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 01:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 09:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

 Done Adding Additional Store
Successfully signed: maXbox4.exe

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa maXbo
x4.exe

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): C4DBA87DDCFA4DD4D0D056467549B21E05E48162

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 01:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 01:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 01:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Wed Aug 23 11:40:46 2017
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 01:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 09:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>


Verifying: maXbox4.exe      4.2.8.10
Signature Index: 0 (Primary Signature)
Hash of file (sha1): A1B08A29D2C0EA8CD0C4526C332F697A4B965483

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 01:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 01:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 01:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Sun Oct 22 20:12:50 2017
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 01:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 09:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): DE9119537F5E36FA78A4D63DDD440E4C13115468

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 01:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 01:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 01:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Thu Oct 26 17:18:59 2017
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 01:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 09:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): DE9119537F5E36FA78A4D63DDD440E4C13115468

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 01:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 01:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 01:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Thu Oct 26 17:18:59 2017
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 01:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 09:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 338BF6DAC6F1092456E239C09CA4DD8C7EC2A4E2

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 00:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Sat Nov 25 22:04:52 2017
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 08:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>


Done Adding Additional Store
Successfully signed: maXbox4.exe

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa maXbo
x4.exe

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 38476C6B07C0042EABF33051DF2858A22625D69E

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 00:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Sun Dec 17 18:04:11 2017
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 08:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>signtool verify /v /pa maXbo
x4.exe

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 4CF18A27D9187CBAC34F5DFDC4DE1C5A18551566

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 00:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Tue Jan 02 20:26:48 2018
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 08:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

 Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 21D70022C88A87521DE2FCDA8C5B4C7E59ABA3F4

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 00:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Sun Jan 07 13:22:49 2018
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Timestamp Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Mon Dec 13 08:00:00 2021
        SHA1 hash: 7144B53F1A5D391DDDAC71B60721908C9B1BF3F6


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0


Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): AC4D270DA01F8F9A65D2989CC33DD4A304FF2EEB

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 01:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 01:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 01:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Fri Sep 27 14:32:43 2019
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 01:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Secure Certificate Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Sat May 03 09:00:00 2031
        SHA1 hash: 7EDC376DCFD45E6DDF082C160DF6AC21835B95D4

            Issued to: Starfield Timestamp Authority - G2
            Issued by: Starfield Secure Certificate Authority - G2
            Expires:   Tue Sep 17 09:00:00 2024
            SHA1 hash: E8551398FF530A9278FD9818E448CB333F67924D


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>

4.7.1.20

Verifying: maXbox4.exe
Signature Index: 0 (Primary Signature)
Hash of file (sha1): 34F315B1503C6552714BB8C68D333DD7B3AC4EA4

Signing Certificate Chain:
    Issued to: maXboxCertAuth
    Issued by: maXboxCertAuth
    Expires:   Sun Jan 01 00:59:59 2040
    SHA1 hash: 6F83207B500DCC0E32A719599CBC6BD7E6B2A04D

        Issued to: maXbox4signer
        Issued by: maXboxCertAuth
        Expires:   Sun Jan 01 00:59:59 2040
        SHA1 hash: 6A89501B76D47C189A60BF1070BAA2FBFD38D7D7

            Issued to: maXbox4exe
            Issued by: maXbox4signer
            Expires:   Sun Jan 01 00:59:59 2040
            SHA1 hash: F0EB0CA218C5707FAC78921F81092CECA12AD0E9

The signature is timestamped: Thu Nov 14 11:24:48 2019
Timestamp Verified by:
    Issued to: Starfield Root Certificate Authority - G2
    Issued by: Starfield Root Certificate Authority - G2
    Expires:   Fri Jan 01 00:59:59 2038
    SHA1 hash: B51C067CEE2B0C3DF855AB2D92F4FE39D4E70F0E

        Issued to: Starfield Secure Certificate Authority - G2
        Issued by: Starfield Root Certificate Authority - G2
        Expires:   Sat May 03 08:00:00 2031
        SHA1 hash: 7EDC376DCFD45E6DDF082C160DF6AC21835B95D4

            Issued to: Starfield Timestamp Authority - G2
            Issued by: Starfield Secure Certificate Authority - G2
            Expires:   Tue Sep 17 08:00:00 2024
            SHA1 hash: E8551398FF530A9278FD9818E448CB333F67924D


Successfully verified: maXbox4.exe

Number of files successfully Verified: 1
Number of warnings: 0
Number of errors: 0

C:\maXbox\EKON_BASTA\EKON19\Windows Kits\10\bin\x64>


}

