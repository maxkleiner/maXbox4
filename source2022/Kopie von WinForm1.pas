unit WinForm1;

// TEST Form for Framework!
// delphi.win32 by max@kleiner.com  :2005  loc:299
// test skeleton for maXbox 11.11.07
// extended with an mp3 player in soundbox V3

interface


uses
  Windows, Classes, Forms, SysUtils, Controls, 
                Graphics, StdCtrls, FileCtrl, ComCtrls, Buttons;

const
  EXT = 'mp3';
  faDirectory = $00000010;
  faAnyFile   = $0000003F;
  //SONGPATH = 'D:\kleiner2005\soundnvision\';
  //SONGPATH = 'E:\';

type
 	TMyLabel = class(TLabel)
  published
    procedure Label1Click(Sender: TObject);
    procedure setLabelEvent(labelclick: TLabel; eventclick: TNotifyEvent);
  public
  	lblx,lbly,okx,oky: integer;
		place: Boolean;
	end;

  TwinFormp = class(TForm)
    StatusBar1: TStatusBar;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    procedure DirectoryListBox1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseCryptClick(Sender: TObject; var action: TCloseAction);
    procedure ChangeKey(Sender: TObject);    //to be done
    procedure GetMediaData(sender: TObject);
    procedure EncryptMediaAES(sender: TObject);
    procedure DecryptMediaAES(sender: TObject);
    procedure GetMediaData2(sender: TObject);
    procedure GetKeyData(sender: TObject);
    procedure BtnloadKey(Sender: TObject);
    procedure OpenCD(sender: TObject);
    procedure SetCryptForm;
    procedure SetCryptFormAES;
  published
    procedure FormCreate(Sender: TObject);
  public
    maxx,
    maxy,
    maxtot: Byte;
   	psize,
		freex,
    freey: integer;
		pattern: string;
    ttest, patternmode, formname: shortstring;
    procedure moveCube(o: TMyLabel);
    //procedure verify;
    //protected
    //procedure defFileread;
   private
    LstBox: TListBox;
    myButton, myButton2, myButton3: TBitBtn;
    mp3List: TStringList;
    actidx: byte;
    search: TSearchRec;
    songpath: string;
    //aespassw: string;
    procedure SetForm;
    procedure constructButtons;
    procedure findAllFiles(FilesList: TStringList; StartDir, FileMask: string);
    procedure BtnplayClick(Sender: TObject);
    procedure BtnstopClick(Sender: TObject);
    //procedure BtnChoice(Sender: TObject);
    procedure LetLogoDraw(mCanvas: TCanvas; x, y, r: integer; vclr: TColor);
    procedure BtnrepeatClick(Sender: TObject);
    //AES CryptoBox
    procedure BtngetPassword(Sender: TObject);
    procedure CryptoButtonCloseClick(sender: TObject);
  end;

  procedure Speak(const sText: string);
  //procedure SetCryptForm;


  var winFormp: TwinFormp;
      mylabel: Tmylabel;

implementation

// to hear the voice
//uses comObj;
uses IFSI_WinForm1puzzle, comObj, Dialogs, variants, extCtrls, sdpStopwatch, idGlobal_max,
         Menus, MPlayer, gsUtils, JvFunctions_max, FileUtils, AESPasswordDlg, uPSI_uTPLb_AES;

{$R *.dfm}

const LEFTBASE = 20;
      TOPBASE = 25;
      MEDIAPATH =  'exercices\';
      KEYPATH = 'crypt\';
      CIPHERLOG = 'cipherbox_log3.txt';

var
  selectFile, cryptlog, aespassw: string;
  mpanel: TPanel;
  mPlayer: TMediaPlayer;
  inFrm: TForm;
  mbtn3: TBitBtn;
  cLstbox: TListbox;
  stat: TStatusbar;
  STATchoice: boolean;
  myTimeStamp, DateTime1, DateTime2: TDateTime;
  StartKey, MultKey, AddKey, idx: integer;

  //fileToCrypt, cryptFile, decryptFile: string;
  //cfile, cryptin, clearout, cryptlog: string;


//AES CryptoBox
procedure TWinFormp.BtngetPassword(Sender: TObject);
//var keysave: string;
begin
  //InitRandomKeys;
  with TPasswordDlg.Create(NIL) do begin
    showmodal;
    if modalresult = mrOK then begin
    aespassw:= password.Text;
        with clstBox.Items do begin
         Add('Password is set! at: '+DateTimeToStr(Now));
       end;
    end else begin
    //if cancelbtn.modalresult = mrCancel then begin
     password.Text:= '';
     aespassw:= '';
     clstBox.Items.Add('Password empty reset at: '+DateTimeToStr(Now));
     //showmessage(aespassw);  debig
    end;
    Free;
  end;
  //showmessage(aespassw);
  //with TPassworddialog.Create(self); in RCDAta
  //cLstbox.Items.Add('S_key: '+inttoStr(StartKey)+
    //    ' M_key: '+inttoStr(MultKey) + ' A_key: '+inttoStr(AddKey));
  {keysave:= ('S_key: '+inttoStr(StartKey)+#13#10+'M_key: '+inttoStr(MultKey)
             +#13#10+'A_key: '+inttoStr(AddKey))}
  //keysave:= ('S_key: '+inttoStr(StartKey)+' M_key: '+inttoStr(MultKey)
                            //+' A_key: '+inttoStr(AddKey));
  //CreateFileFromString(ExePath+KEYPATH+'keyfile.cryptfile.txt', keysave);
end;


procedure TWinFormp.ChangeKey(Sender: TObject);    //to be done
begin
  MPlayer.filename:= clstbox.items[clstbox.itemIndex];
  StatChoice:= true;
  mBtn3.Caption:= 'One Time Pad!';
  cLstbox.Items.Add('One Time Pad just BETA Test!');
end;

procedure TWinFormp.CloseCryptClick(Sender: TObject; var action: TCloseAction);
begin
  //Form1.Close;  free 308 kByte
  if MessageDlg('Wanna Leave Crypt?',mtConfirmation,[mbYes, mbNo],0) = mrYes then begin
     //form1.Free;
    MPlayer.Close;
    MPlayer.Free;
    //bmp.Free;
    action:= caFree;
    aespassw:= '';  //Set password NULL
 end else
    Action:= caNone;
end;


Procedure InitRandomKeys;
begin
  DateTime1:= Now;
  DateTime2:= Now;
  S_GetEncryptionKeys(DateTime1, DateTime2, StartKey, MultKey, AddKey);
  cLstbox.Items.Add('S_key: of Init '+inttoStr(StartKey)+ ' ');
  //Write('M_key: '+inttoStr(MultKey)+ ' ');
  //Write('A_key: '+inttoStr(AddKey)+ ' ');
  //Writeln(' ');
end;

procedure TWinFormp.BtnloadKey(Sender: TObject);
var keysave: string;
begin
  InitRandomKeys;
  cLstbox.Items.Add('S_key: '+inttoStr(StartKey)+
        ' M_key: '+inttoStr(MultKey) + ' A_key: '+inttoStr(AddKey));
  {keysave:= ('S_key: '+inttoStr(StartKey)+#13#10+'M_key: '+inttoStr(MultKey)
             +#13#10+'A_key: '+inttoStr(AddKey))}
  keysave:= ('S_key: '+inttoStr(StartKey)+' M_key: '+inttoStr(MultKey)
                            +' A_key: '+inttoStr(AddKey));
  CreateFileFromString(ExePath+KEYPATH+'keyfile.cryptfile.txt', keysave);
end;

procedure TWinFormp.OpenCD(sender: TObject);
begin
  OpenCDDrive;
end;

procedure TwinFormp.EncryptMediaAES(sender: TObject);
begin
   //cryptFile:= 'C:\SecureCenter\Dec 15 2010mx3\maxboxerrorlog2.txt';
 //cryptFile:= 'C:\SecureCenter\Dec 15 2010mx3\maxboxerrorlog2.txt';
  if aespassw <> '' then begin
  if PromptForFileName(selectFile,'Files(*.*)|*.*',//others
                      '', 'Select your file to crypt', MEDIAPATH, False)
  then begin
     // Display this full file/path value
    mPanel.font.color:= clyellow;
    mPanel.font.size:= 18;
    mPanel.caption:= ExtractFileName(selectFile)+' encrypt...';
    //cfile:= LoadFileAsString(selectFile);
   Application.ProcessMessages;
   screen.Cursor:= crHourglass;
   with clstBox.Items do begin
      Add('SHA256 Hash of: '+ExtractFileName(selectFile));
      Add('is: '+ComputeSHA256(selectFile,'F'));
      idx:= Add('File to Crypt: '+ExtractFileName(selectFile));
      stat.SimpleText:= clstBox.items[idx];
    end;
    with TStopwatch.Create do begin
     Start;
    AESSymetricExecute(selectFile,selectFile+'_encrypt',aespassw);
    mPanel.font.color:= clblue;
    mPanel.font.size:= 30;
    mPanel.caption:= 'File Encrypted!';
    screen.Cursor:= crDefault;
    Stop;
      //clstBox.Items.Add('Time: ' +(floattoStr(GetValueMSec/1000)));
      clstBox.Items.Add('Time consuming: ' +GetValueStr +' of: '+
              inttoStr(getFileSize(selectFile))+' File Size');
     Free;
   end;
    //add hash and cipher to compare later on
    //cfile:= cfile + 'SHA$'+SHA1(selectFile);
    //cryptin:= S_StrEncrypt96(cfile, StartKey, MultKey, AddKey);
    //CreateFileFromString(selectFile+'_crypt', cryptin);
    cLstbox.Items.Add('Crypted file: '+ExtractFileName(selectFile)+'_encrypt');
    WriteLog(cryptLog, clstbox.items.text)
    {clearout:= S_StrDEcrypt96(cryptin, StartKey, MultKey, AddKey);
    CreateFileFromString(selectFile+'_decrypt', clearout);}
  end;
  end else showmessage('Set your password first!');
end;

procedure TwinFormp.DecryptMediaAES(sender: TObject);
var clearout: string;
begin
 //if aespassw= '' then showmessage('Set your password first!');
 if aespassw <> '' then begin
 if PromptForFileName(selectFile,'Files(*_encrypt)|*_encrypt',//others
                      '', 'Select your file to decrypt', MEDIAPATH, False)
   then begin
     // Display this full file/path value
    mPanel.font.color:= clyellow;
    mPanel.font.size:= 18;
    mPanel.caption:= ExtractFileName(selectFile)+' decrypt...';
     idx:= cLstbox.Items.Add('File to Decrypt: '+ExtractFileName(selectFile));
     stat.SimpleText:= cLstbox.Items[idx];
    //Delete(selectFile, length(selectFile)-7, 8); //-7!
    Application.ProcessMessages;
    screen.Cursor:= crHourglass;
    with TStopwatch.Create do begin
     Start;
     AESDecryptFile(selectFile+'_decrypt',selectFile,aespassw);
     clearout:= selectFile+'_decrypt';
     Delete(clearout, length(clearout)-15, 8); //-7!
     RenameFile(selectFile+'_decrypt', clearout);
     screen.Cursor:= crDefault;
     Stop;
      //clstBox.Items.Add('Time: ' +(floattoStr(GetValueMSec/1000)));
      clstBox.Items.Add('Time consuming: ' +GetValueStr +' of: '+
              inttoStr(getFileSize(clearout))+' File Size');
     Free;
    end;
     mPanel.font.color:= clGreen;  //clLime
     mPanel.font.size:= 30;
      mPanel.caption:= 'File Decrypted!';
     //if VerifySignature(clearout) then
       // cLstbox.Items.Add('Signatur Valid and Integrity Check done');
     //CreateFileFromString(selectFile+'_decrypt', clearout);
     with clstBox.Items do begin
       Add('SHA256 Hash of '+ExtractFileName(clearout));
       Add('is: '+ComputeSHA256(clearout,'F'));
       Add('File Decrypted as: '+ExtractFileName(clearout));
     end;
     WriteLog(cryptLog, clstbox.items.text)
   end;
 end else showmessage('Set your password first!');
end;


procedure TwinFormp.GetMediaData(sender: TObject);
var cfile, cryptin: string;
begin
   //cryptFile:= 'C:\SecureCenter\Dec 15 2010mx3\maxboxerrorlog2.txt';
 //cryptFile:= 'C:\SecureCenter\Dec 15 2010mx3\maxboxerrorlog2.txt';
  if PromptForFileName(selectFile,'files(*.*)|*.*',//others
                      '', 'Select your file to crypt', MEDIAPATH, False)
  then begin
     // Display this full file/path value
    mPanel.caption:= 'Select file: '+ExtractFileName(selectFile);
    cfile:= LoadFileAsString(selectFile);
    with clstBox.Items do begin
      Add('SHA1 Hash of: '+ExtractFileName(selectFile));
      Add('is: '+SHA1(selectFile));
      idx:= Add('File to Crypt: '+ExtractFileName(selectFile));
      stat.SimpleText:= clstBox.items[idx];
    end;
    //add hash and cipher to compare later on
    cfile:= cfile + 'SHA$'+SHA1(selectFile);
    cryptin:= S_StrEncrypt96(cfile, StartKey, MultKey, AddKey);
    CreateFileFromString(selectFile+'_crypt', cryptin);
    cLstbox.Items.Add('Crypted file: '+ExtractFileName(selectFile)+'_crypt');
    WriteLog(cryptLog, clstbox.items.text)
    {clearout:= S_StrDEcrypt96(cryptin, StartKey, MultKey, AddKey);
    CreateFileFromString(selectFile+'_decrypt', clearout);}
  end;
end;

function VerifySignature(fstring: string): boolean;
var gethash: string;
begin
  result:= false;
  gethash:= Copy(fstring, Pos('SHA$', fstring)+4,40);
  cLstbox.Items.Add('SHA1 Hash back: '+ExtractFileName(selectFile));
  cLstbox.Items.Add('is: '+gethash);
  //writeln('hash back '+gethash);
  //delete signatur from file to get the origin file
  Delete(fstring, Pos('SHA$', fstring),44);
  //templist.delete(templist.count-1)
  CreateFileFromString(selectFile+'_decrypt', fstring);
  if CompareStr(gethash, SHA1(selectFile+'_decrypt')) = 0 then
    result:= true;
end;

procedure TwinFormp.GetMediaData2(sender: TObject);
var cryptin, clearout: string;
begin
 if PromptForFileName(selectFile,'files(*_crypt)|*_crypt',//others
                      '', 'Select your file to decrypt', MEDIAPATH, False)
   then begin
     // Display this full file/path value
     idx:= cLstbox.Items.Add('File to Decrypt: '+ExtractFileName(selectFile));
     stat.SimpleText:= cLstbox.Items[idx];
     cryptin:= LoadFileAsString(selectFile);
     clearout:= S_StrDEcrypt96(cryptin, StartKey, MultKey, AddKey);
     if VerifySignature(clearout) then
        cLstbox.Items.Add('Signatur Valid and Integrity Check done');
     //CreateFileFromString(selectFile+'_decrypt', clearout);
     with clstBox.Items do begin
       Add('SHA1 Hash of '+ExtractFileName(selectFile+'_decrypt'));
       Add('is: '+SHA1(selectFile+'_decrypt'));
       Add('File Decrypted as: '+ExtractFileName(selectFile)+'_decrypt');
     end;
     WriteLog(cryptLog, clstbox.items.text)
   end;
end;

procedure TwinFormp.getKeyData(sender: TObject);
var kfile: string;
    TT1, TT2, TT3: integer;
begin
  if PromptForFileName(selectFile, 'Key files (*.cryptfile.txt)|*.cryptfile.txt',
            '', 'Select your key file', ExePath, False) //false: not Save dialog!
  then begin
    //Display this full file/path value
    kfile:= LoadFileAsString((selectFile));
    if ExtractFileExt(selectFile) = '.txt' then begin
      TT1:= pos('S_key: ', kfile);
      TT2:= pos('M_key: ', kfile);
      TT3:= pos('A_key: ', kfile);
      if TT1 > 0 then begin
        StartKey:= StrToInt(trim(copy(kfile,7,TT2-7)));
        cLstbox.Items.Add('debug found s_key '+InttoStr(StartKey))
      end;
      if TT2 > 0 then begin
        MultKey:= StrToInt(trim(copy(kfile,TT2+7,TT3-(TT2+7))));
        //writeln('debug found m_key '+ inttostr(multkey))
      end;
      if TT3 > 0 then begin
        AddKey:= StrToInt(trim(copy(kfile,TT3+7,10)));
        //writeln('debug found a_key '+inttostr(addkey));
        cLstbox.Items.Add('Key file loaded: '+ExtractFileName(selectFile))
      end;
    end else
      mPanel.caption:= 'No file: '+ExtractFileName(selectFile);
  end; //File Name
end;



function MSecToTime(mSec: longint): string;
var dt: TDateTime;
begin
  dt:= (mSec/1000/86400);  //SecsPerDay;
  Result:= FormatDateTime('" song length is:" nn:ss:zzz',dt);
end;

procedure TwinFormp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mp3list.free;
end;

procedure TwinFormp.FormCreate(Sender: TObject);
begin
  //TVCLForm_Load;
  StatusBar1.SimplePanel:= true;
  StatusBar1.Font.Size:= 12;
  mylabel:= TMyLabel.Create(winformp);
  mylabel.OnClick:= mylabel.Label1Click;
  //DirectoryListBox1.OpenCurrent;
  setForm;
  constructButtons;
  LetLogoDraw(winFormp.Canvas, 10, 5, 4, clRed);
  closeMP3;
end;


procedure TwinFormp.moveCube(o: TMyLabel);
begin
  if (o.lblx + 1 = freex) and (o.lbly = freey) then begin
    //right
    o.lblx:= o.lblx +1;
    o.Left:= o.Left + psize +1;
    o.Top:= o.Top;
    freex:= freex -1;
  end else
  if (o.lblx - 1 = freex) and (o.lbly = freey) then begin
      //left
      o.lblx:= o.lblx -1;
      o.Left:= o.Left - psize -1;
      o.Top:= o.Top;
      freex:= freex +1;
  end else
  if (o.lblx = freex) and (o.lbly - 1 = freey) then begin
      //top means up
      o.lbly:= o.lbly -1;
      o.Left:= o.Left;
      o.Top:= o.Top - psize -1;
      freey:= freey + 1;
  end else
  if (o.lblx = freex) and (o.lbly + 1 = freey) then begin
      //bottom means down
      o.lbly:= o.lbly +1;
      o.Left:= o.Left;
      o.Top:= o.Top + psize +1;
      freey := freey - 1;
   end;
 end;


procedure TwinFormp.SetForm;
var i: integer;
begin
  //inFrm:= TForm.create(self)
  Lstbox:= TListbox.create(winFormp);
  mp3list:= TStringList.Create;
  //FindAllFiles(mp3list, SONGPATH, '*.mp3');
  //StartFileFinder;
  with winFormp do begin
    position := poScreenCenter;
    FormStyle := fsStayOnTop;
    color:= clblue;
    borderStyle:= bsSingle;
    caption:= 'maXbox SoundBox';
    width:= 750; height:= 550;
    show;
  end;
  with Lstbox do begin
    parent:= winFormp;
    //autocomplete:= true;
    top:= 40; left:= 120;
    width:= 580; height:= 265;
    font.size:= 12; color:= clPurple;
    //CANVAS.TEXTWIDTH
    SCROLLWIDTH:= width * 2;
    songpath:= DirectoryListBox1.Directory;
    FindAllFiles(mp3list, songpath, '*.mp3');
    statusBar1.SimpleText:= intToStr(mp3list.count)+ ' Songs found';
    for i:= 0 to mp3list.count - 1 do
      items.add(mp3List[i])
  end;
  //mp3List.Free;
end;

procedure TWinFormp.LetLogoDraw(mCanvas: TCanvas; x,y,r: integer; vclr: TColor);
var
  rad, a: Single;
  i: Integer;
begin
  mCanvas.Pen.Color:= random(vclr);
  mCanvas.Pen.width:= 4;
  for i:= 0 to 400 do begin
    inc(y); inc(x);
    a:= Random(150) * 0.8 * pi;
    rad:= Random(35) * r;
    mCanvas.MoveTo(X, Y);
    mCanvas.LineTo(x + Round(rad*Cos(a)), y + Round(rad*Sin(a)));
  end;
end;

{procedure TwinFormp.BtnChoice(Sender: TObject);
begin
  with TOpenDialog.Create(self) do begin
    Filter:= 'Songfiles (*.mp3)|*.MP3';
    FileName:= '*.mp3';
    defaultExt:= 'mp3';
    title:= 'maXbox soundBox File Open';
    InitialDir:= ExtractFilePath(application.ExeName)+'*.mp3';
    if execute then begin
      songpath:= InitialDir;
    end;
  end;
  //
end;}

procedure TWinFormp.BtnplayClick(Sender: TObject);
var mp3time, idx, i: integer;
begin
  idx:= lstbox.itemIndex;
  if idx <> -1 then begin     //single
     if idx <> actidx then
       closemp3;
     actidx:= idx;
     mp3time:= lengthmp3(lstbox.items[idx]);
     StatusBar1.SimpleText:=(Format('%s',
          [extractFileName(lstbox.items[idx]) + MSecToTime(mp3time)]));
     LetLogoDraw(winFormp.Canvas, 10, 5, 5, clwhite);
     lstbox.selected[idx]:= true;
     application.ProcessMessages;
     playmp3(lstbox.items[idx])
  end else
  //closemp3;
  for i:= 0 to lstbox.items.count - 1 do begin  //list mode
     application.ProcessMessages;
     mp3time:= lengthmp3(lstbox.items[i]);
     statusBar1.SimpleText:= (Format('%s',
          [extractFileName(lstbox.items[i]) + MSecToTime(mp3time)]));
     LetLogoDraw(winFormp.Canvas, 10, 5, 3, clpurple);
     lstbox.selected[i]:= true;
     playmp3(lstbox.items[i]);
     sleep(mp3time);
     closemp3;
  end;
end;

procedure TWinFormp.BtnstopClick(Sender: TObject);
begin
  stopmp3
end;

procedure TWinFormp.BtnrepeatClick(Sender: TObject);
begin
  LetLogoDraw(winFormp.Canvas, 10, 5, 5, clwebgold);
  //lstbox.selected[idx]:= true;
  closemp3;
  application.ProcessMessages;
  playmp3(lstbox.items[lstbox.itemIndex])
  //BtnplayClick(self);
end;


procedure TwinFormp.constructButtons;
begin
 myButton:= TBitBtn.create(winFormp);
 with myButton do begin
   parent:= winformp;
   setbounds(360,329,160,40);
   caption:= 'Play MP3...';
   font.size:= 12;
   font.Style:= [fsbold];
   //event handler
   glyph.LoadFromResourceName(getHINSTANCE,'CL_MPSTEP');
     //event handler
   onclick:= btnplayClick;
 end;
 myButton2:= TBitBtn.create(winFormp);
 with myButton2 do begin
   parent:= winformp;
   setbounds(540,329,160,40);
   caption:= 'Stop MP3';
   font.size:= 12;
   font.Style:= [fsbold];
   glyph.LoadFromResourceName(getHINSTANCE,'CL_MPPAUSE');
   //event handler
   onclick:= btnstopClick;
 end;
 myButton3:= TBitBtn.create(winFormp);
 with myButton3 do begin
   parent:= winformp;
   setbounds(360,385,160,40);
   caption:= 'Repeat...';
   font.size:= 12;
   font.Style:= [fsbold];
   glyph.LoadFromResourceName(getHINSTANCE,'CL_MPBACK');
   //event handler
   onclick:= btnrepeatClick;
 end;

 {myButton0:= TButton.create(winFormp);
 with myButton do begin
   parent:= winformp;
   setbounds(120,400,160,50);
   caption:= 'Choice...';
   font.size:= 12;
   font.Style:= [fsbold];
   //event handler
   onclick:= btnChoice;
 end;}
end;


procedure TwinFormp.DirectoryListBox1DblClick(Sender: TObject);
var i: integer;
begin
  mp3List.Clear;
  lstBox.Items.Clear;
  lstbox.Clear;
  songpath:= DirectoryListBox1.Directory;
  FindAllFiles(mp3list, songpath, '*.mp3');
  lstBox.Clear;
  lstBox.Items.Clear;
  for i:= 0 to mp3list.count - 1 do
      lstBox.items.add(mp3List[i]);
       statusBar1.SimpleText:= intToStr(mp3list.count)+ ' mp3 files found';
end;

procedure TWinFormp.FindAllFiles(FilesList: TStringList; StartDir, FileMask: string);
var //SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if StartDir[length(StartDir)] <> '\' then
                       StartDir:= StartDir + '\';
  {Build a list of the files in dir StartDir (not the directories!)}
  IsFound:= FindFirst(StartDir+FileMask, faAnyFile-faDirectory, search) = 0;
  while IsFound do begin
    //only file name less StartDir
    FilesList.Add(StartDir + search.Name);
    IsFound:= FindNext(search) = 0;
  end;
  FindClose(search);
  //Build a list of subdirectories
  DirList:= TStringList.Create;
    IsFound:= FindFirst(StartDir+'*.*', faAnyFile, search) = 0;
    while IsFound do begin
      if ((search.Attr and faDirectory) <> 0) and
         (search.Name[1] <> '.') then
           DirList.Add(StartDir + search.Name);
      IsFound:= FindNext(search) = 0;
    end;
    FindClose(search);
  //Scan the list of subdirectories recursive!
  for i:= 0 to DirList.Count - 1 do
    FindAllFiles(FilesList, DirList[i], FileMask);
  DirList.Free;
end;


{ TMyLabel }
// or to call winform eventhandler
procedure TMyLabel.Label1Click(Sender: TObject);
//var
  //o: TMyLabel;
begin
  if (Sender is TMyLabel) then begin
    //o:= TMyLabel(Sender);
    winFormp.moveCube(TMyLabel(Sender));
    //winFormp.verify;
  end;
end;

// ex. of read some text with a voice
procedure Speak(const sText: String);
const
  SVSFDefault = $00000001;
  SVSFlagsAsync = $00000001;
var
  oVoice: OLEVariant;
begin
     oVoice:= CreateOLEObject('SAPI.SpVoice');
     oVoice.Speak(sText, SVSFlagsAsync);
     //sleep(1000);
    {Application.NormalizeTopMosts;
    messagebox(0, pchar(sText), 'maXbox voice', MB_OK);
    Application.RestoreTopMosts;}
     Showmessage(sText);
   //oVoice:= NIL;
   oVoice:= Unassigned;
end;


procedure TMyLabel.setLabelEvent(labelclick: TLabel; eventclick: TNotifyEvent);
begin
   labelclick.OnClick:= eventclick;
end;

procedure TWinFormp.SetCryptForm;
var
  mbtn, mbtn2, mbtn4: TBitBtn;
  mi, mi1, mi2: TMenuItem;
  mt: TMainMenu;
  mlbl, mlbl1: TLabel;
  mp3list: TStringList;
  i: integer;
begin
  STATChoice:= false;
  inFrm:= TForm.Create(self);
  mLbl:= TLabel.create(inFrm);
  mLbl1:= TLabel.create(inFrm);
  mPanel:= TPanel.Create(inFrm);
  stat:= TStatusbar.Create(inFrm);
  cLstbox:= TListbox.create(inFrm);

  with inFrm do begin
     caption:= '********CipherBox3 Crypto Lab************';
     height:= 610;
     width:= 980;
     //color:= clred;
     Position:= poScreenCenter;
     onClose:= CloseCryptClick;
     Show;
   end;
   with mPanel do begin
     caption:= '*****CipherBox_Signature*****';
     parent:= inFrm;
     SetBounds(LEFTBASE+10,TOPBASE+40,410,400);
     color:= clsilver;
     font.color:= clyellow;
     font.size:= 20;
     Show;
   end;
  mp3list:= TStringList.Create;
  //StartFileFinder(mp3list);
  with cLstbox do begin
    parent:= inFrm;
    SetBounds(LEFTBASE+450, TOPBASE+40, 465, 400);
    font.size:= 10;
    color:= clYellow;
    for i:= 0 to mp3list.count - 1 do
      items.add(mp3List[i]);
    onClick:= ChangeKey;
  end;
  //mp3List.Free;
  mBtn:= TBitBtn.Create(inFrm);
  with mBtn do begin
    Parent:= inFrm;
    setbounds(LEFTBASE+ 425, TOPBASE+ 460,150, 40);
    caption:= 'File to Cipher';
    font.size:= 12;
    glyph.LoadFromResourceName(getHINSTANCE,'UNKNOWNFILE');
    onclick:= GetMediaData;
  end;

  mBtn4:= TBitBtn.Create(inFrm);
  with mBtn4 do begin
    Parent:= inFrm;
    setbounds(LEFTBASE+ 580, TOPBASE+460,150, 40);
    caption:= 'File to Decipher';
    font.size:= 12;
    glyph.LoadFromResourceName(getHINSTANCE,'OPENFOLDER');
    onclick:= GetMediaData2;
  end;
  mBtn2:= TBitBtn.Create(inFrm);
  with mBtn2 do begin
    Parent:= inFrm;
    setbounds(LEFTBASE+ 270, TOPBASE+460,150, 40);
    caption:= 'Load Key';
    font.size:= 12;
    glyph.LoadFromResourceName(getHINSTANCE,'FLOPPY');
    //event handler
    onclick:= getKeyData;
  end;
  mBtn3:= TBitBtn.Create(inFrm);
  with mBtn3 do begin
    Parent:= inFrm;
    setbounds(LEFTBASE+ 755, TOPBASE+460,160, 40);
    caption:= 'Generate Key!';
    font.size:= 12;
    glyph.LoadFromResourceName(getHINSTANCE,'EXECUTABLE');
    //event handler
    onclick:= BtnloadKey;
  end;
  with mlbl do begin
    parent:= inFrm;
    setbounds(LEFTBASE+15,TOPBASE-15,180,20);
    font.size:= 32;
    font.color:= clred;
    font.style:= [fsunderline];
    caption:= 'CipherBox';
  end;
  with mlbl1 do begin
    parent:= inFrm;
    setbounds(LEFTBASE+455,TOPBASE-1,180,20);
    font.size:= 20;
    font.color:= clred;
    caption:= 'Log Register:';
  end;
  mt:= TMainMenu.Create(infrm);
  with mt do begin
   //parent:= frmMon;
  end;
  mi:= TMenuItem.Create(mt);
  mi1:= TMenuItem.Create(mt);
  mi2:= TMenuItem.Create(mt);
  with mi do begin
    //parent:= frmMon;
    Caption:='Cipher File';
    Name:='ITEM';
    mt.Items.Add(mi);
    OnClick:= GetMediaData;
  end;
  with mi1 do begin
    //parent:= frmMon;
    Caption:='Decipher File';
    Name:='ITEM2';
    mt.Items.Add(mi1) ;
    OnClick:= GetMediaData2;
  end;
  with mi2 do begin
    //parent:= frmMon;
    Caption:='Open CD Player';
    Name:='ITEM3';
    mt.Items.Add(mi2);
    OnClick:= OPenCD;
  end;
  with Stat do begin
    parent:= inFrm;
    stat.SimplePanel:= true;
  end;
  MPlayer:= TMediaPlayer.create(self);
  with MPlayer do begin
    parent:= inFrm;
    height:= 38;
    top:= TOPBASE + 460;
    left:= LEFTBASE+ 10;
    Display:= mPanel;   //for video show
  end;
  if DirectoryExists(ExePath+KEYPATH) = false then
    CreateDir(ExePath + KEYPATH);
  idx:= cLstbox.Items.Add('Keypath is: '+ExePath+KEYPATH);
  stat.SimpleText:= cLstbox.Items[idx];
  cryptLog:= ExePath+CIPHERLOG;
  cLstbox.Items.Add('CipherBox ready, Generate or Load a Key first');
end;


procedure TWinFormp.CryptoButtonCloseClick(sender: TObject);
begin
  //mbitmap.Free;
  inFrm.Close;
end;

procedure TWinFormp.SetCryptFormAES;
var
  mbtn, mbtn4: TBitBtn;
  mi, mi1, mi2: TMenuItem;
  mt: TMainMenu;
  mlbl, mlbl1: TLabel;
  mp3list: TStringList;
  i: integer;
begin
  STATChoice:= false;
  inFrm:= TForm.Create(self);
  mLbl:= TLabel.create(inFrm);
  mLbl1:= TLabel.create(inFrm);
  mPanel:= TPanel.Create(inFrm);
  stat:= TStatusbar.Create(inFrm);
  cLstbox:= TListbox.create(inFrm);

  with inFrm do begin
     caption:= '********CryptoBox3 AES256 and SHA256************';
     height:= 610;
     width:= 1180;
     //color:= clred;
     Position:= poScreenCenter;
     onClose:= CloseCryptClick;
     Show;
   end;
   with mPanel do begin
     caption:= '****CryptoBox_AES256_SHA256****';
     parent:= inFrm;
     SetBounds(LEFTBASE+10,TOPBASE+40,416,400);
     color:= clsilver;
     font.color:= clyellow;
     font.size:= 20;
     //canvas.Ellipse(5,5,15,15);
     Show;
   end;
  mp3list:= TStringList.Create;
  //StartFileFinder(mp3list);
  with cLstbox do begin
    parent:= inFrm;
    SetBounds(LEFTBASE+450, TOPBASE+40, 670, 400);
    font.size:= 10;
    color:= clYellow;

    for i:= 0 to mp3list.count - 1 do
      items.add(mp3List[i]);
    //onClick:= ChangeKey;
  end;
  //mp3List.Free;
  mBtn:= TBitBtn.Create(inFrm);
  with mBtn do begin
    Parent:= inFrm;
    setbounds(LEFTBASE+ 650, TOPBASE+ 460,150, 40);
    caption:= 'File to &Encrypt';
    font.size:= 12;
    //font.Style:= [fsBold];
    glyph.LoadFromResourceName(getHINSTANCE,'CL_MPNEXT');
    onclick:= EncryptMediaAES;
  end;

  mBtn4:= TBitBtn.Create(inFrm);
  with mBtn4 do begin
    Parent:= inFrm;
    setbounds(LEFTBASE+ 810, TOPBASE+460,150, 40);
    caption:= 'File to &Decrypt';
    font.size:= 12;
    glyph.LoadFromResourceName(getHINSTANCE,'CL_MPPLAY');
    onclick:= DecryptMediaAES;
  end;
  {mBtn2:= TBitBtn.Create(inFrm);
  with mBtn2 do begin
    Parent:= inFrm;
    setbounds(LEFTBASE+ 270, TOPBASE+460,150, 40);
    caption:= 'Enter Password';
    font.size:= 12;
    glyph.LoadFromResourceName(getHINSTANCE,'CLMPPAUSE');
    //event handler
    onclick:= getKeyData;
  end;}
  with TBitBtn.Create(inFrm) do begin
    Parent:= inFrm;
    setBounds(LEFTBASE+490,TOPBASE+460,150,40);
    caption:= '&Close';
    font.size:= 12;
    glyph.LoadFromResourceName(HINSTANCE,'CL_MPSTOP');
    onclick:= CryptoButtonCloseClick; //CloseCryptClick;
  end;
  mBtn3:= TBitBtn.Create(inFrm);
  with mBtn3 do begin
    Parent:= inFrm;
    setbounds(LEFTBASE+ 970, TOPBASE+460,150, 40);
    caption:= 'Enter &Password!';
    font.size:= 12;
    glyph.LoadFromResourceName(getHINSTANCE,'CL_MPPAUSE');
    //event handler
    onclick:= BtngetPassword;
  end;
  with mlbl do begin
    parent:= inFrm;
    setbounds(LEFTBASE+15,TOPBASE-15,180,20);
    font.size:= 32;
    font.color:= clred;
    font.style:= [fsunderline];
    caption:= 'AES CryptoBox';
  end;
  with mlbl1 do begin
    parent:= inFrm;
    setbounds(LEFTBASE+455,TOPBASE-1,180,20);
    font.size:= 20;
    font.color:= clred;
    caption:= 'Log Register:';
  end;
  mt:= TMainMenu.Create(infrm);
  with mt do begin
   //parent:= frmMon;
  end;
  mi:= TMenuItem.Create(mt);
  mi1:= TMenuItem.Create(mt);
  mi2:= TMenuItem.Create(mt);
  with mi do begin
    //parent:= frmMon;
    Caption:='Encrypt File';
    Name:='ITEM';
    mt.Items.Add(mi);
    OnClick:= EncryptMediaAES;
  end;
  with mi1 do begin
    //parent:= frmMon;
    Caption:='Decrypt File';
    Name:='ITEM2';
    mt.Items.Add(mi1) ;
    OnClick:= DecryptMediaAES;
  end;
  with mi2 do begin
    //parent:= frmMon;
    Caption:='Set Password';
    Name:='ITEM3';
    mt.Items.Add(mi2);
    OnClick:= BtngetPassword;
    //OPenCD;
  end;
  with Stat do begin
    parent:= inFrm;
    stat.SimplePanel:= true;
  end;
  MPlayer:= TMediaPlayer.create(self);
  with MPlayer do begin
    parent:= inFrm;
    height:= 38;
    top:= TOPBASE + 460;
    left:= LEFTBASE+ 10;
    Display:= mPanel;   //for video show
  end;
  if DirectoryExists(ExePath+KEYPATH) = false then
    CreateDir(ExePath + KEYPATH);

  cLstbox.Items.Add('Welcome to CryptoBox3 to protect your Data '+datetimetoStr(Now));
  cLstbox.Items.Add('User: '+GetUserNameWin+' on Machine: '+getComputerNameWin+
                 ' with Proc ID: '+intToStr(CurrentProcessid));
                 //+'Internet is: '+boolToStr(isInternet, True));
  idx:= cLstbox.Items.Add('Keypath is: '+ExePath+KEYPATH);
  stat.SimpleText:= cLstbox.Items[idx];
  cryptLog:= ExePath+CIPHERLOG;
  cLstbox.Items.Add('CryptoBox3 ready, Save or load a Password protected Cipher');
end;


end.
