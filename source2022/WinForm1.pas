unit WinForm1;

// TEST Form for Framework!   and Container for Addons
// delphi.win32 by max@kleiner.com  :2005  loc:299
// test skeleton for maXbox 11.11.07
// extended with an mp3 player in soundbox V3
// extended with a small webserver
// add on as full text finder    3.9.7

interface


uses
  Windows, Classes, Forms, SysUtils, Controls,  Graphics, StdCtrls, FileCtrl, ComCtrls,
  Buttons, IdCustomHTTPServer, IdTCPServer, ExtCtrls;

const
  EXT = 'mp3';
  faDirectory = $00000010;
  faAnyFile   = $0000003F;
  //SONGPATH = 'D:\kleiner2005\soundnvision\';
  //SONGPATH = 'E:\';
  RECURSIVE = true;
  GraphSAVENAME = 'logbox_simgraph.png';
  GraphSAVENAME2 = 'fractalbox.png';


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
    Panel1: TPanel;
    Label2: TLabel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    btnfinder: TButton;
    chkrecursive: TCheckBox;
    chkbxfinder: TCheckBox;
    chkbxcounter: TCheckBox;
    edtsearch: TEdit;
    edtfilename: TEdit;
    edtmask: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    chkboxtoday: TCheckBox;
    //cfFrm: TForm;     //fractalform
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
    procedure SetFractalForm(ah, aw: integer);
    procedure SetLogBoxForm;
    procedure btnfinderClick(Sender: TObject);
    procedure edtfilenameDblClick(Sender: TObject);
    procedure chkboxtodayClick(Sender: TObject);
    procedure edtfilenameChange(Sender: TObject);
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
    finderactive: boolean;
    foundcount: integer;
    wordfoundcount: integer;
    //cfFrm: TForm;     //fractalform
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
    searchtopic: string;
    songpath: string;
    //anotherfractal: boolean;
    fracwidth, fracheight: integer;
    candidate: boolean;
    //cFrm: TForm;
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
    procedure HTTPServerGet(aThr: TIdPeerThread; reqInf: TIdHTTPRequestInfo;
                                                 respInf: TIdHTTPResponseInfo);
    procedure closeFractalForm(Sender: TObject; var Action: TCloseAction);
    //procedure SetLogBoxForm;
    procedure LogBox_btnSaveClick(Sender: TObject);
    procedure closeLogForm(Sender: TObject; var Action: TCloseAction);
    procedure LogBox_CloseClick(Sender: TObject);
    procedure SetAnotherFractalForm(sender: TObject);
    procedure TMatrixFractalClick(sender: TObject);
    procedure TFractalSave(Sender: TObject);
    procedure TBifurcationClick(sender: TObject);
    procedure TOneFractalClick(sender: TObject);
    procedure FractalFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TOneFractal1Click(sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FractalFormKeyPress(Sender: TObject; var Key: Char);
    procedure ClickinListbox(sender: TObject);
    procedure ClickinListboxsimple(sender: TObject);
    //procedure SetFractalForm;

  end;

  procedure Speak(const sText: string);
  procedure Speak2(const sText: string);
  //procedure SetCryptForm;
  procedure HTTPServerStartExecute(Sender: TObject);

  procedure StartFileFinder;     //Full Text Finder

  var codesearchtopic: string;
  procedure StartCodeFinder(atext: string);     //Code Search
  //opentools API
  procedure StartFileFinder3(spath, aext, searchstr: string; arecursiv: boolean;
                               reslist: TStringlist);
  //procedure FindAllFiles3(FilesList, sublist: TStringList; StartDir,FileMask: string);




  var winFormp: TwinFormp;
      mylabel: Tmylabel;
      cfFrm: TForm;     //fractalform
      anotherfractal, matrixfractal, bifurcfractal, onefractal, onefractal1: boolean;
      wscnt: integer;
      //mFrac2: TMenuItem;


implementation

// to hear the voice
//uses comObj;
uses IFSI_WinForm1puzzle, comObj, Dialogs, variants, sdpStopwatch, idGlobal_max,
         Menus, MPlayer, gsUtils, JvFunctions_max, FileUtils, AESPasswordDlg,
         uPSI_uTPLb_AES, fMain, JvSimlogic, JvSimIndicator, LinarBitmap, shellAPI;

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

  HTTPServer: TIdCustomHTTPServer;
  clogFrm: TForm;


  cntr: integer;
//  finderactive: boolean = false;


  //fileToCrypt, cryptFile, decryptFile: string;
  //cfile, cryptin, clearout, cryptlog: string;


/////////////////Full Text Finder

function SearchSubString(aStrList: TStringlist): string;
//function SearchSubString(afilepath: string): string;
var i, TT1: integer;
    s1: string;
    //AStrList: TStringlist;
begin
  result:= '';
  s1:= '';
  //aStrList:= TStringList.Create;
  //aStrList.Clear;
  //aStrlist.loadFromFile(afilepath);
  for i:= 0 to aStrList.Count -1 do begin
    s1:= aStrList[i];
    //repeat
    TT1:= pos(Uppercase(winformp.searchtopic), Uppercase(s1));
    if TT1 > 0 then begin
     inc(winformp.wordfoundcount);
     if i= 0 then begin
        result:= result+intToStr(i)+': '+s1+#13#10;
        result:= result+ aStrList[i+1]+#13#10;  //line after
      end else begin
        result:= result+ aStrList[i-1]+#13#10;  //line before
        result:= result+intToStr(i)+': '+s1+#13#10;
        result:= result+ aStrList[i+1]+#13#10;  //line after
      end;
      if i= astrlist.count-1 then
        result:= result+intToStr(i)+': '+s1+#13#10;
    end;
    //until TT1 = 0;
  end;  //for
  //aStrList.Free;
end;


function SearchCodeSubString(aStrList: TStringlist): string;
//function SearchSubString(afilepath: string): string;
var i, TT1: integer;
    s1: string;
    //AStrList: TStringlist;
begin
  result:= '';
  s1:= '';
  for i:= 0 to aStrList.Count -1 do begin
    s1:= aStrList[i];
    //repeat
    TT1:= pos(Uppercase(codesearchtopic), Uppercase(s1));
    if TT1 > 0 then begin
     if i= 0 then begin
        result:= result+intToStr(i)+': '+s1+#13#10;
        result:= result+ aStrList[i+1]+#13#10;  //line after
      end else begin
        result:= result+ aStrList[i-1]+#13#10;  //line before
        result:= result+intToStr(i)+': '+s1+#13#10;
        result:= result+ aStrList[i+1]+#13#10;  //line after
      end;
      if i= astrlist.count-1 then
        result:= result+intToStr(i)+': '+s1+#13#10;
    end;
    //until TT1 = 0;
  end;  //for
  //aStrList.Free;
end;


var
  year, year1, month, month1, day, day1: word;


procedure FindAllFiles(FilesList, sublist: TStringList; StartDir,FileMask: string);
//procedure FindAllFiles(FilesList: TStringList; StartDir,FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  searchstr: string[255];
  resStr: string;
  i: integer;
  //myDosdate: TDateTime;
begin
  //candidate:= false;
  if StartDir[length(StartDir)] <> '\' then
                       StartDir:= StartDir + '\';
  { Build a list of the files in directory StartDir!}
  IsFound:= FindFirst(StartDir+FileMask, faAnyFile-faDirectory, SR) = 0;
  while IsFound do begin
  resStr:= '';
  inc(winformp.foundcount);
    (*if winformp.chkboxtoday.checked then begin
       myDosdate:= fileDatetoDateTime(sr.Time);
       decodeDate(mydosdate, year, month, day);
       if (day = day1) and (month = month1) and (year = year1) then
       winformp.candidate:= true else winformp.candidate:= false;
    end;
     if winformp.candidate then begin
       sublist.Clear;
     try
       sublist.loadFromFile(StartDir + Sr.Name);
     except
       maxform1.memo2.lines.add('EFileNotLoad Exception:'+StartDir+':'+Sr.Name);
     end;
     end; *)
       sublist.Clear;
     try
       sublist.loadFromFile(StartDir + Sr.Name);
     except
       maxform1.memo2.lines.add('EFileNotLoad Exception:'+StartDir+':'+Sr.Name);
     end;
     //FilesList.Add(StartDir + searchrecName);//+ DateTimetoStr(mydosdate));
     //SearchName !!
    if winformp.chkbxfinder.Checked then
         maxform1.memo2.lines.add('filefinder out test: '+StartDir + Sr.Name);
    try
      resstr:= SearchSubstring(sublist);
      //resstr:= SearchSubstring(StartDir + Sr.Name);
    except
      maxform1.memo2.lines.add('ENot finished Exception:'+StartDir+':'+Sr.Name);
     end;
      if resStr <> '' then begin
        cntr:= cntr+1;
        FilesList.Add(#13#10+'********** File '+intToStr(cntr)+': '+StartDir+ sr.Name+#13#10+resStr);
     end;
    IsFound:= FindNext(SR) = 0;
  end;
  FindClose(SR);
  //Build a list of subdirectories
  if winformp.chkrecursive.Checked then begin
    DirList:= TStringList.Create;
    IsFound:= FindFirst(StartDir+'*.*', faAnyFile, SR) = 0;
    while IsFound do begin
      if ((Sr.Attr and faDirectory) <> 0) and
         (Sr.Name[1] <> '.') then
           DirList.Add(StartDir + sr.Name);
      IsFound:= FindNext(SR) = 0;
    end;
    FindClose(SR);
  //Scan the list of subdirectories recursive!
    for i:= 0 to DirList.Count- 1 do
      FindAllFiles(FilesList, sublist, DirList[i], FileMask);
      //FindAllFiles(FilesList, DirList[i], FileMask);
    DirList.Free;
  end;
end;

procedure FindAllCodeFiles(FilesList, sublist: TStringList; StartDir,FileMask: string);
//procedure FindAllFiles(FilesList: TStringList; StartDir,FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  searchstr: string[255];
  resStr: string;
  i: integer;
  //myDosdate: TDateTime;
begin
  if StartDir[length(StartDir)] <> '\' then
                       StartDir:= StartDir + '\';
  { Build a list of the files in directory StartDir!}
  IsFound:= FindFirst(StartDir+FileMask, faAnyFile-faDirectory, SR) = 0;
  while IsFound do begin
  resStr:= '';
    //myDosdate:= fileDatetoDateTime(searchrectime)
    //decodeDate(mydosdate, year, month, day)
    //if (day = day1) and (month = month1) and (year = year1) then
     sublist.Clear;
     try
     sublist.loadFromFile(StartDir + Sr.Name);
     except
       maxform1.memo2.lines.add('EFileNotLoad Exception:'+StartDir+':'+Sr.Name);
     end;
     //FilesList.Add(StartDir + searchrecName);//+ DateTimetoStr(mydosdate));
     //SearchName !!
      maxform1.memo2.lines.add('filefinder out test: '+StartDir + Sr.Name);
    try
      resstr:= SearchCodeSubstring(sublist);
      //resstr:= SearchSubstring(StartDir + Sr.Name);
    except
      maxform1.memo2.lines.add('ENot finished Exception:'+StartDir+':'+Sr.Name);
     end;
      if resStr <> '' then begin
        cntr:= cntr+1;
        FilesList.Add(#13#10+'*************** File '+intToStr(cntr)+': '+StartDir+ sr.Name+#13#10+resStr);
     end;
    IsFound:= FindNext(SR) = 0;
  end;
  FindClose(SR);
  //Build a list of subdirectories
    DirList:= TStringList.Create;
    IsFound:= FindFirst(StartDir+'*.*', faAnyFile, SR) = 0;
    while IsFound do begin
      if ((Sr.Attr and faDirectory) <> 0) and
         (Sr.Name[1] <> '.') then
           DirList.Add(StartDir + sr.Name);
      IsFound:= FindNext(SR) = 0;
    end;
    FindClose(SR);
  //Scan the list of subdirectories recursive!
    for i:= 0 to DirList.Count- 1 do
      FindAllCodeFiles(FilesList, sublist, DirList[i], FileMask);
      //FindAllFiles(FilesList, DirList[i], FileMask);
    DirList.Free;
end;

var selectedfile: string;
     changedir: boolean;

//Event Handler - Closure  
procedure GetMediaData3(self: TObject);
begin
  changedir:= true;
  if PromptForFileName(selectedFile,
                       'Text files (*.txt)|*.txt',
                       '', 'Save your search report file',
                       ExePath+'examples\filenamesavereport.txt', true)  // Means not a Save dialog !
   then begin
     // Display this full file/path value
     ShowMessage('Selected file to save = '+selectedFile);
     winformp.edtfilename.text:= selectedfile;
     //Stat.simpletext:= selectedFile;
     //mymemo.lines.LoadFromFile(selectedFile);
     // Split this full file/path value into its constituent parts
     //writeln('PromptForFileName_28: Res of processpath '+tmp)
   end;
end;

procedure TwinFormp.edtfilenameChange(Sender: TObject);
begin
   selectedfile:= winformp.edtfilename.text;
end;

procedure TwinFormp.edtfilenameDblClick(Sender: TObject);
begin
  // fly robin fly
   GetMediaData3(self);
end;


procedure StartFileFinder;
var
  FilesList, sublist: TStringList;
  spath: string;
  time1, diff: TDateTime;
begin
  decodeDate(date, year1, month1, day1);
  winformp.foundcount:= 0;
  winformp.wordfoundcount:= 0;
  winformp.finderactive:= true;
  FilesList:= TStringList.Create;
  sublist:= TStringList.Create;
  cntr:= 0;
  winformp.searchtopic:='';
  winformp.StatusBar1.Font.Size:= 9;
  screen.Cursor:= crHourGlass;
  time1:= time;
  winformp.edtfilename.showhint:= true;
  winformp.edtfilename.hint:= selectedfile;

  try
    //FindAllFiles(FilesList, 'C:\', '*.*'); pattern
    spath:= winformp.DirectoryListBox1.Directory;
    if winformp.edtmask.text='' then winformp.edtmask.Text:= '*.txt';
    if winformp.edtfilename.text='' then winformp.edtfilename.text:= 'searchreport.txt';
    if winformp.edtsearch.text <>'' then begin
    if DirectoryExists(ExePath+'Examples') = false then
      CreateDir(ExePath + 'Examples');
    maxform1.memo2.lines.add('New FullTextSearch started at: '+timetostr(time)+' '+SPATH);
    winformp.searchtopic:= winformp.edtsearch.text;
    FindAllFiles(FilesList, sublist, SPATH, winformp.edtmask.text);
    //FindAllFiles(FilesList, SPATH, winformp.edtmask.text);
    fileslist.add(formatdatetime('"Found '+inttoStr(cntr)+' files of:" dd:mm:yyyy',date));
    fileslist.add('"Search and Found for '+winformp.edtsearch.text);
    fileslist.add('"Search Total Count of Files/Words: '+inttoStr(winformp.foundcount));
    fileslist.add('"Found of Words: '+inttoStr(winformp.wordfoundcount));
    fileslist.add('"Found of Files: '+inttoStr(cntr));
    Diff:= time - time1;
    fileslist.add(IntToStr(Trunc(Diff * 24)) +
                   FormatDateTime('" h run time is:" nn:ss:zzz',Diff));
    if changedir then begin
     //selectedfile:= winformp.edtfilename.text;    //default
       winformp.edtfilename.text:= selectedfile;
      fileslist.saveToFile(selectedfile);
      SearchAndOpenDoc(selectedfile);
      winformp.statusBar1.SimpleText:= intToStr(cntr)+ ' Word/Files found save at '+
                selectedFile;
     //changedir:= false;  //free path possible
     //selectedfile:= winformp.edtfilename.text;
     end else begin
       fileslist.saveToFile(ExePath+'Examples\'+winformp.edtfilename.text);
       SearchAndOpenDoc(ExePath+'Examples\'+winformp.edtfilename.text);
       winformp.statusBar1.SimpleText:= intToStr(cntr)+ ' Word/Files found save at '+
                ExePath+'Examples\'+winformp.edtfilename.text;
      end
    end else Showmessage('You must enter a search topic');
  finally
    FilesList.Free;
    sublist.Free;
    screen.Cursor:= crDefault;
    //winformp.finderactive:= false;
  end;
end;

//int API to opentools
procedure StartFileFinder3(spath, aext, searchstr: string; arecursiv: boolean;
                               reslist: TStringlist);
var
  fList, sublist: TStringList;
  time1, diff: TDateTime;
begin
   Application.CreateForm(TwinFormp, winFormp);
   //winformp.Height:= 740;
   winformp.finderactive:= true;

  fList:= TStringList.Create;
  sublist:= TStringList.Create;
  cntr:= 0;
  winformp.foundcount:= 0;
  //recursiv:= arecursiv;
  winformp.chkrecursive.checked:= arecursiv;
  screen.Cursor:= crHourGlass;
  time1:= time;
  try
    //FindAllFiles(fList, 'C:\', '*.*'); pattern
       if aext='' then aext:= '*.txt';
       if searchstr <>'' then begin
    //if DirectoryExists(ExePath+'Examples') = false then
      //CreateDir(ExePath + 'Examples');
    maxform1.memo2.lines.add('FullTextSearch start at: '+timetostr(time)+' '+SPATH);
    winformp.searchtopic:= searchstr;
    FindAllFiles(fList, sublist, SPATH, aext);
    //FindAllFiles(fList, SPATH, edtmask.text);
    fList.add(formatdatetime('"Found '+inttoStr(cntr)+' Files:" dd:mm:yyyy',date));
    fList.add('"Search and Found for: '+searchstr);
    fList.add('"Search Count of Words: '+inttoStr(winformp.foundcount));
    Diff:= time - time1;
    fList.add(IntToStr(Trunc(Diff * 24)) +
                   FormatDateTime('" h run time:" nn:ss:zzz',Diff));
    reslist.assign(fList);
    end else Showmessage('Please enter a search topic');
  finally
    fList.Free;
    sublist.Free;
    winFormp.Free;
    winFormp:= NIL;
    screen.Cursor:= crDefault;
  end;
end;



procedure StartCodeFinder(atext: string);
var
  FilesList, sublist: TStringList;
  spath, sfilename: string;
  time1, diff: TDateTime;
begin
  //winformp.finderactive:= true;
  FilesList:= TStringList.Create;
  sublist:= TStringList.Create;
  cntr:= 0;
  screen.Cursor:= crHourGlass;
  time1:= time;
  try
    //FindAllFiles(FilesList, 'C:\', '*.*'); pattern
    Spath:= ExePath+'Examples';
    //if winformp.edtmask.text='' then winformp.edtmask.Text:= '*.txt';
    sfilename:= 'codesearchreport.txt';
    if atext <>'' then begin
    if DirectoryExists(ExePath+'Examples') = false then
      CreateDir(ExePath + 'Examples');
    maxform1.memo2.lines.add('CodeSearchEngine (*.pas,*.txt) started at: '+timetostr(time)+' '+SPATH);
    codesearchtopic:= atext;
    FindAllCodeFiles(FilesList, sublist, SPATH, '*.txt');
    FindAllCodeFiles(FilesList, sublist, SPATH, '*.pas');

    //FindAllFiles(FilesList, SPATH, winformp.edtmask.text);
    fileslist.add(formatdatetime('"Found '+inttoStr(cntr)+' Finder files of:" dd:mm:yyyy',date));
    fileslist.add('"Search and Found for '+codeSearchTopic);
    Diff:= time - time1;
    fileslist.add(IntToStr(Trunc(Diff * 24)) +
                   FormatDateTime('" h run time is:" nn:ss:zzz',Diff));
    fileslist.saveToFile(ExePath+sfilename);
    SearchAndOpenDoc(ExePath+sfilename);
    maxform1.memo2.lines.add(intToStr(cntr)+ ' Code Patterns found saved at '+
                ExePath+sfilename);
    end else Showmessage('You must enter a search topic');
  finally
    FilesList.Free;
    sublist.Free;
    screen.Cursor:= crDefault;
    //winformp.finderactive:= false;
  end;
end;


procedure TwinFormp.btnfinderClick(Sender: TObject);
begin
  StartFileFinder;
end;


/////////////////web server frame

function GetMIMEType(sFile: TFileName): string;
var aMIMEMap: TIdMIMETable;
begin
  aMIMEMap:= TIdMIMETable.Create(true);
  try
    result:= aMIMEMap.GetFileMIMEType(sFile);
  finally
    //raise;
    aMIMEMap.Free;
  end;
end;

procedure TWinFormP.HTTPServerGet(aThr: TIdPeerThread; reqInf: TIdHTTPRequestInfo;
                                                 respInf: TIdHTTPResponseInfo);
var localDoc: string;
    ByteSent: Cardinal;
begin
  //RespInfo.ContentType:= 'text/HTML';
  //if reqinf.document = '/' then begin
     RespInf.ContentText:=
      '<html><head><title>maXbox Web</title></head><body><h1>Welcome to mX FileServer3</h1>'#13 +
      'Check the script 303_webserver_alldocs2 to discover more:<br><ul><li>Search for '#13 +
      '<b>ResponseInfo</b> in <b>the ../web to download files</b>!</ul></body></html>';
      //RespInf.ResponseText + '</ul></body></html>';
     //writeln('my site');
    // end;
    inc(wscnt);
  maxform1.memo2.lines.add(Format('Command %s %s at %-10s received from %s:%d',[ReqInf.Command, ReqInf.Document,
                       DateTimeToStr(Now),aThr.Connection.socket.binding.PeerIP,
                       aThr.Connection.socket.binding.PeerPort]));
  // Default document (index.htm) for folder
  LocalDoc:= ExpandFilename(Exepath+'/web'+ReqInf.Document);
  if not FileExists(LocalDoc) and DirectoryExists(Exepath+'/web') and
      FileExists(ExpandFileName(Exepath+'/web/index.htm')) then
       LocalDoc:= ExpandFileName(Exepath+'/web/index.htm') else
  localDoc:= ExpandFilename(Exepath+'/web'+ReqInf.Document);
  RespInf.ContentType:= GetMIMEType(LocalDoc);
  if FileExists(localDoc) then begin
    ByteSent:= HTTPServer.ServeFile(AThr, RespInf, LocalDoc);
    maxform1.memo2.lines.add(Format('Serv file %s (%d bytes/ %d bytes sent) to %s:%d at %s of %d',
          [LocalDoc,ByteSent,FileSizeByName(LocalDoc), aThr.Connection.Socket.Binding.PeerIP,
           aThr.Connection.Socket.Binding.PeerPort, dateTimeToStr(now), wscnt]));
  end
  else begin
    RespInf.ResponseNo:= 404; //Not found RFC
    RespInf.ContentText:=
          '<html><head><title>Sorry WebBox not Found Error</title></head><body><h1>' +
    RespInf.ResponseText + '</h1></body></html>';
  end;
//end;
end;


procedure HTTPServerStartExecute(Sender: TObject);
begin
  wscnt:= 0;
  HTTPServer:= TIdCustomHTTPServer.Create(NIL);
  with HTTPServer do begin
    if Active then Free;
    if not Active then begin
      Bindings.Clear;
      bindings.Add;
      bindings.items[0].Port:= mAxform1.IPPORT;
      bindings.items[0].IP:= maxform1.IPHost; //'127.0.0.1';
      Active:= true;
      onCommandGet1:= winformp.HTTPServerGet;
      ShowmessageBig(Format('Listening HTTP on %s:%d. Click OK to - Set IP/Port in ini-file section [WEB]',
                    [Bindings[0].IP,Bindings[0].Port]));
    end;
    //letOpenBrowser;
    ShowmessageBig(Format('Listening HTTP on %s:%d. Time: '+DateTimeToInternetStr(Now, true)+
                          {+#13#10+} '   Click OK to close and shut down HTTPServer!'
                           ,[Bindings[0].IP,Bindings[0].Port]));
    HTTPServer.Free;
    maxform1.memo2.lines.add(Format('HTTP Server closed on: %s.',
                    [DateTimeToInternetStr(Now, true)]));
  end;
end;

//////////////web server frame ende



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

procedure TwinFormp.chkboxtodayClick(Sender: TObject);
begin
  //candidate:= NOT candidate;
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
  finderactive:= false;
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


procedure TwinFormp.FormKeyPress(Sender: TObject; var Key: Char);
begin

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

procedure TWinFormp.ClickinListbox(sender: TObject);
var idx: integer;
    FileName: string;
begin
  idx:= lstbox.itemindex;
  //memo2.lines.add(lbintflist.items[idx]); debug
  lstbox.hint:= lstbox.Items[idx];
  showhint:= true;
 if fileexists(lstbox.Items[idx]) then begin
    FileName:= lstbox.Items[idx];
    ShellAPI.ShellExecute(HInstance, NIL, pchar(FileName), NIL, NIL, sw_ShowNormal);
  end else
    Showmessage('Sorry, filepath to '+filename+' is missing')
  //memo1.SetFocus;
  //listbox1.items[idx]:= temp;
  //listbox1.ItemIndex:= idx;
end;

procedure TWinFormp.ClickinListboxsimple(sender: TObject);
var idx: integer;
begin
  idx:= lstbox.itemindex;
  //memo2.lines.add(lbintflist.items[idx]); debug
  lstbox.hint:= lstbox.Items[idx];
  showhint:= true;
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
    caption:= 'maXbox SoundFileBox';
    width:= 950; height:= 550;
    show;
  end;
  with Lstbox do begin
    parent:= winFormp;
    //autocomplete:= true;
    top:= 20; left:= 50;
    width:= 835; height:= 263;
    font.size:= 12; color:= clsilver;
    //CANVAS.TEXTWIDTH
    SCROLLWIDTH:= width * 2;
    songpath:= DirectoryListBox1.Directory;
    FindAllFiles(mp3list, songpath, '*.mp3');
    statusBar1.SimpleText:= intToStr(mp3list.count)+ ' Songs found';

    onDblClick:= ClickinListbox;
    onClick:= ClickinListboxSimple;

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
    //panel2.Hide;
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
  screen.Cursor:= crHourGlass;
  decodeDate(date, year1, month1, day1);
  if finderactive then begin
     if winformp.chkbxcounter.checked then begin
    mp3List.Clear;
    lstBox.Items.Clear;
    lstbox.Clear;
    songpath:= DirectoryListBox1.Directory;
    FindAllFiles(mp3list, songpath, edtmask.text);
    //lstBox.Clear;
    //lstBox.Items.Clear;
  for i:= 0 to mp3list.count - 1 do
      lstBox.items.add(mp3List[i]);
  statusBar1.SimpleText:= intToStr(mp3list.count)+ ' files found';
  end
    end else begin
     mp3List.Clear;
     lstBox.Items.Clear;
     lstbox.Clear;
     songpath:= DirectoryListBox1.Directory;
     FindAllFiles(mp3list, songpath, '*.mp3');
  //lstBox.Clear;
  //lstBox.Items.Clear;
  for i:= 0 to mp3list.count - 1 do
      lstBox.items.add(mp3List[i]);
       statusBar1.SimpleText:= intToStr(mp3list.count)+ ' mp3 files found';
  end;
    screen.Cursor:= crDefault;
end;


procedure TWinFormp.FindAllFiles(FilesList: TStringList; StartDir, FileMask: string);
var //SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
  myDosdate: TDateTime;
begin
  if StartDir[length(StartDir)] <> '\' then
                       StartDir:= StartDir + '\';
  {Build a list of the files in dir StartDir (not the directories!)}
  IsFound:= FindFirst(StartDir+FileMask, faAnyFile-faDirectory, search) = 0;

  if winformp.chkboxtoday.checked then begin
     while IsFound do begin
    //only file name less StartDir
       myDosdate:= fileDatetoDateTime(search.Time);
       decodeDate(mydosdate, year, month, day);
       if (day = day1) and (month = month1) and (year = year1) then
          FilesList.Add(StartDir + search.Name);
     IsFound:= FindNext(search) = 0;
     end;
  end else begin
     while IsFound do begin
    //only file name less StartDir
     FilesList.Add(StartDir + search.Name);
     IsFound:= FindNext(search) = 0;
     end;
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

procedure Speak2(const sText: String);
const
  SVSFDefault = $00000001;
  SVSFlagsAsync = $00000001;
var
  oVoice: OLEVariant;
begin
     oVoice:= CreateOLEObject('SAPI.SpVoice');
     oVoice.Speak(sText, 0);
     //sleep(1000);
    {Application.NormalizeTopMosts;
    messagebox(0, pchar(sText), 'maXbox voice', MB_OK);
    Application.RestoreTopMosts;}
    // Showmessage(sText);
   //oVoice:= NIL;
   oVoice:= Unassigned;
end;

procedure Bifurcation_process(var X, Y: double; vForm: TForm);
var 
  j,k,i: integer;
  r: double;
begin 
  for i:=0 to 600 do begin
    //i and r depends on overflow
    r:=2.95+1.643192e-03*i;
    X:=0.02;
    for j:=1 to vForm.height do X:=r*X*(1-X);
    //accuracy filter
    for k:=1 to 220 do begin
    {$IFDEF LINUX}
      vForm.Canvas.DrawPoint(i,round(600*(1.0-X)));
    {$ELSE}
      vForm.Canvas.Pixels[i,round(800*(1.0-X))]:= clBlue;
    {$ENDIF}
      X:=r*X*(1-X); 
    end;
  end;
end; 
 
procedure Bifurcationsetup(vForm: TForm);
var X, Y: double;
begin
  X:=1; Y:=1; 
  vForm.Canvas.pen.Color:=clblue;
  bifurcation_process(X,Y, vForm);
  //direct mode without scaling
end;  



procedure Mandelbrot_process(X, Y, au,bu: double;
                                     X2, Y2: integer; vForm: TForm);
var
  c1, c2, z1, z2, tmp: single;
  i, j, count: integer;
begin
  c2:= bu;
for i:= 10 to X2 do begin
  c1:= au;
  for j:= 0 to Y2 do begin
    z1:= 0;
    z2:= 0;
    count:= 0;
    {count is deep of iteration of the mandelbrot set
     if |z| >=2 then z is not a member of a mandelset}
    while (((z1*z1 + z2*z2 <4) AND (count <= 255))) do begin
      tmp:=z1;
      z1:= z1*z1 - z2*z2 + c1;
      z2:= 2*tmp*z2+c2;
      inc(count);
    end;
    //the color-palette depends on TColor(n*count mod t)
    //vForm.Canvas.pen.Color:= (16*count mod 155);
    vForm.Canvas.Pixels[j,i]:= (16*count mod 255);
    c1:=c1 + X;
  end;
  c2:= c2 + Y;
end;
end;

procedure Mandelbrotsetup(vForm: TForm);
var
  X1, X2, Y1, Y2, au, ao: integer;
  dX, dY, bo, bu: double;
begin
  X1:=0; X2:=840;
  Y1:=0; Y2:=850;
  ao:=1; au:=-2; bo:=1.5;
  bu:= -1.5; dX:= (ao-au)/(X2-X1);
  //direct scaling cause of speed
  dY:= (bo-bu)/(Y2-Y1);
  Mandelbrot_process(dX, dY, au,bu, X2, Y2, vForm);
end;

procedure Mandelbrot2setup(vForm: TForm);
var
  X, Y, depth: integer;
  minre, maxre, minim, maxim: double;
  im, re, tr, ti, tmp: single;
begin
  minre:=-2.5; maxre:=1.0;
  minim:=-1.2; maxim:=1.2;
  //ao:=1; au:=-2; bo:=1.5;
  depth:=0;
  anotherfractal:= NOT anotherfractal;
  for y:= 0 to vForm.height-1 do begin
    im:= minim + y * (maxim-minim) / vForm.height;
    for x:= 0 to vForm.width-1 do begin
      re:= minre+x*(maxre-minre)/vForm.Width;
      tr:= re;
      ti:= im;
      {count is deep of iteration of the mandelbrot set
      if |z| >=2 then z is not a member of a mandelset}
      depth:= 0;
      while (depth < 30) do begin
        //tmp:=tr;
        tmp:= tr*tr - ti*ti + re;
        ti:= 2*tr*ti+im;
        tr:= tmp;
        if (tr*tr + ti*ti > 4) then break;
        inc(depth);
      end;
      //the color-palette depends on TColor(n*count mod t)
      if matrixfractal then
          anotherfractal:= NOT anotherfractal;
      if (depth < 16) then
      if anotherfractal then
        vForm.Canvas.Pixels[x,y]:= (16*depth mod 255) else  //clwhite;
        vForm.Canvas.Pixels[y,x]:= (16*depth mod 255);  //clwhite;
    end;
  end;
end;

var
  scaleX1, scaleX2, scaleY1, scaleY2: double;


procedure scaleResults(const X, Y : double; var intX, intY : integer;
                                        width, height: integer);
var scaledX, scaledY: double;
 begin
   scaledX:= (X-scaleX1)/(scaleX2-scaleX1);
   scaledY:= (Y-scaleY2)/(scaleY1-scaleY2);
   intX:= round(scaledX * width);
   intY:= round(scaledY * height);
 end;


procedure Lorenz_process(var X, Y, Z: double; vForm: TForm);
var intX, intY : integer;
  dX, dY, dZ: double;
begin
  dY:= X * (28-Z)-Y;
  dX:= 10 * (Y-X);
  dZ:= X * Y- (8/3) * Z; 
  scaleResults(X,Y,intX,intY, vForm.ClientWidth, vForm.ClientHeight);
  {$IFDEF LINUX}
    vForm.Canvas.DrawPoint(intX,intY);
  {$ELSE}
    vForm.Canvas.Pixels[intX, intY]:= clRed; 
  {$ENDIF}
  X:= X+ 0.01 * dX;
  Y:= Y+ 0.01 * dY; 
  Z:= Z+ 0.01 * Dz;
end;

procedure ModelLorenzsetup(vForm: TForm);
var
  i: integer;
  x, y, z: double;
begin
  scaleX1:=-20; scaleX2:=20;
  scaleY1:=-25; scaleY2:=30;
  X:= 0.1; Y:= 0.1; Z:= 0.1;
  for i:= 1 to 6500 do
    Lorenz_process(X,Y,Z, vForm);
end;


procedure TWinFormp.closeFractalForm(Sender: TObject; var Action: TCloseAction);
begin
  {if mt <> NIL then begin
    mT.enabled:= false;
    mT.Free;
    mT:= NIL;
  end;}
  ///afrm.Free;
  cffrm.Free;
  cffrm:= NIL;
  //action:= caFree;
  //cfrm.Free;
  //afrm:= NIL;
end;


procedure SaveCanvas2(vCanvas: TCanvas; FileName: string);
var
  Bmp: TBitmap;
  bmp1: TLinearBitmap;
  MyRect: TRect;
begin
  Bmp:= TBitmap.Create;
  bmp1:= TLinearBitmap.create;
  try
    MyRect:= vCanvas.ClipRect;
    Bmp.Width:= MyRect.Right - MyRect.Left;
    Bmp.Height:= MyRect.Bottom - MyRect.Top;
    Bmp.Canvas.CopyRect(MyRect, vCanvas, MyRect);
    bmp1.Assign(Bmp);
    Bmp1.SaveToFile(FileName);
  finally
    Bmp.Free;
    bmp1.Free;
  end;
end;



procedure TWinFormp.SetAnotherFractalForm(sender: TObject);
var time1, time2, diff: TDateTime;
begin
  //Mandelbrot2setup(vForm: TForm);
  time1:= time;
  //anotherfractal:= true;
    Application.processMessages;
     if onefractal then
      cfFrm.Canvas.refresh;
      if bifurcfractal then
        Bifurcationsetup(cfFrm);
      if Not onefractal then
         Mandelbrotsetup(cfFrm);
      //Bifurcationsetup(cFrm);
      ModelLorenzsetup(cfFrm);
      if bifurcfractal then
        Bifurcationsetup(cfFrm);
      if Not onefractal1 then
         Mandelbrot2setup(cfFrm);
        //Mandelbrotsetup(cFrm);
   Diff:= time - time1;
   cfFrm.Canvas.Font.Color:= clRed;
   cfFrm.Canvas.Font.Size:= 12;
   cfFrm.Canvas.TextOut(20,800, FormatDateTime('" mX4 run time:" nn:ss:zzz',Diff));
   cfFrm.Caption:= FormatDateTime('  " Run time:" nn:ss:zzz',Diff);
end;

procedure TWinFormp.TMatrixFractalClick(sender: TObject);
begin
  TMenuItem(sender).Checked:= not TMenuItem(sender).Checked;
  matrixfractal:= Not MatrixFractal;
end;

procedure TWinFormp.TBifurcationClick(sender: TObject);
begin
  TMenuItem(sender).Checked:= not TMenuItem(sender).Checked;
   bifurcfractal:= Not bifurcfractal;
end;

procedure TWinFormp.TOneFractalClick(sender: TObject);
begin
  TMenuItem(sender).Checked:= not TMenuItem(sender).Checked;
   onefractal:= Not onefractal;
end;

procedure TWinFormp.TOneFractal1Click(sender: TObject);
begin
  TMenuItem(sender).Checked:= not TMenuItem(sender).Checked;
   onefractal1:= Not onefractal1;
end;


procedure TWinFormp.TFractalSave(Sender: TObject);
 begin
   //writeln('click of paintbox test');
   SaveCanvas2(cfFrm.canvas,Exepath+GraphSAVENAME2);
   cfFrm.caption:= '********** Fractal Box ***********  Saved as '+
                    GraphSAVENAME2;
   //writeln('LogSimBox Graph as '+GraphSAVENAME +' saved');
 end;


procedure TWinFormp.FractalFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  SetAnotherFractalForm(self);
end;

procedure TWinFormp.FractalFormKeyPress(Sender: TObject; var Key: Char);
begin
 if Key =  #13
 then
   SetAnotherFractalForm(self);
 //if Key = #27 then cfFrm.close;
end;



procedure TWinFormp.SetFractalForm(ah, aw: integer);
//var cFrm: TForm;
var time1, time2, diff: TDateTime;
  mm1: TMainMenu;
  mm2, mFrac2, mSave, mBif, mOne, mone1: TMenuItem;

begin
  cfFrm:= TForm.create(self);
  time1:= time;
  anotherfractal:= false;
  matrixfractal:= false;
  bifurcfractal:= false;
  try
    with cfFrm do begin
      caption:= 'Chaos_MAX_PerformanceTest3(((***))) - DblClick/ReturnKey to Repeat';
      height:= ah;
      width:= aw;
      //fracheight:= ah;
      //fracwidth:= aw;
      color:= clblack;
      Position:= poScreenCenter;
      formstyle:= fsStayOnTop;
      bringToFront;
      show;
     onClose:= closeFractalForm;
     ondblClick:= SetAnotherFractalForm;
     onKeyPress:= FractalFormKeyPress;
   end;
    mm1:= TMainMenu.Create(cffrm);
    mFrac2:= TMenuItem.Create(mm1);
    mm2:= TMenuItem.Create(mm1);
    mSave:= TMenuItem.Create(mm1);
    mBif:= TMenuItem.Create(mm1);
    mOne:= TMenuItem.Create(mm1);
    mOne1:= TMenuItem.Create(mm1);

     mm2.Caption:= 'Fractal Options!';
     mm1.items.Add(mm2);
     mm2.Add(mFrac2);
     mm2.Add(mOne);
     mm2.Add(mOne1);
     mm2.Add(mBif);
     mm2.Add(mSave);
     with mFrac2 do begin
        Caption:= 'Matrix Fractal Show';
        Checked:= False;
        OnClick:= TMatrixFractalClick;
      end;
     with mOne do begin
        Caption:= 'One Fractal Show';
        Checked:= False;
        OnClick:= TOneFractalClick;
      end;
     with mOne1 do begin
        Caption:= 'One Fractal One';
        Checked:= False;
        OnClick:= TOneFractal1Click;
      end;
      with mBif do begin
        Caption:= 'Add Bifurcation Graph';
        Checked:= False;
        OnClick:= TBifurcationClick;
      end;
      with mSave do begin
        Caption:= 'Save Fractal as PNG';
        //Checked:= False;
        OnClick:= TFractalSave;
      end;
      Application.processMessages;
      Bifurcationsetup(cfFrm);
      Mandelbrotsetup(cfFrm);
      //Bifurcationsetup(cFrm);
      ModelLorenzsetup(cfFrm);
      Mandelbrot2setup(cfFrm);
      //Mandelbrotsetup(cFrm);
   Diff:= time - time1;
   cfFrm.Canvas.Font.Color:= clRed;
   cfFrm.Canvas.Font.Size:= 12;
   cfFrm.Canvas.TextOut(20,800, FormatDateTime('" mX4 run time is:" nn:ss:zzz',Diff));
   cfFrm.Caption:= cffrm.caption+ FormatDateTime('  " Run time is:" nn:ss:zzz',Diff);
  except
    exit
  end;
  //cfrm.Free;
end;



procedure TWinFormp.closeLogForm(Sender: TObject; var Action: TCloseAction);
begin
  ///afrm.Free;
  action:= caFree;
  //afrm:= NIL;
end;



procedure TWinFormp.LogBox_btnSaveClick(Sender: TObject);
 begin
   //writeln('click of paintbox test');
   SaveCanvas2(clogFrm.canvas,Exepath+GraphSAVENAME);
   clogFrm.caption:= '********** SimLogic Box ***********  Saved as '+
                    GraphSAVENAME;
   //writeln('LogSimBox Graph as '+GraphSAVENAME +' saved');
 end;

procedure TWinFormp.LogBox_CloseClick(Sender: TObject);
 begin
   //writeln('click of paintbox test');
   clogFrm.Close;
 end;


procedure TWinFormp.SetLogBoxForm;
//var cFrm: TForm;
 var   GameMi, Game2: TMenuItem;
begin
  clogFrm:= TForm.create(self);

   with clogFrm do begin
     Caption:= '********** SimLogic Box ***********';
     height:= 710;
     width:= 850;
     Position:= poScreenCenter;
     //Color:= clBlack;
     //onClose:= @TFrm1_closeForm;
     //onPaint:= @TFrm1_FormPaint;
     Canvas.Pen.color:= clBlue;
     Canvas.Pen.Width:= 15;
     onClose:= closeLogForm;
     Show;
     //canvas.brush.bitmap:= getBitmapObject(Exepath+'examples\images\bmp47.bmp');
     //Canvas.FillRect(Rect(600,510,400,300));
  end;

   with TMainMenu.create(clogFrm) do begin;
     GameMi:= TMenuItem.Create(clogfrm);
     gamemi.Caption:= '&Save Graph as PNG ';
     gamemi.OnClick:= LogBox_btnSaveClick;
     Items.Add(gamemi);
     Game2:= TMenuItem.Create(clogfrm);
     game2.Caption:= ' &Close LogBox';
     game2.OnClick:= LogBox_CloseClick;
     Items.Add(game2);
   end;
     with TJvSimLogicBox.create(self) do begin
       parent:= clogfrm;
       setbounds(10,10,200,300);
       Paint;
       //Free;
     end;
    with TJvSimLight.Create(self) do begin
       parent:= clogfrm;
       setbounds(300,10,20,30);
       Paint;
       Lit:= true;
       coloron:= clyellow;
       coloroff:= clblue;
      //RegisterProperty('ColorOn', 'TColor', iptrw);
      //RegisterProperty('ColorOff', 'TColor', iptrw);
      //RegisterMethod('Procedure Free');
  end;
    with TJvSimLight.Create(self) do begin
       parent:= clogfrm;
       setbounds(370,10,20,30);
       Paint;
       Lit:= false;
       coloron:= clyellow;
       coloroff:= clpurple;
    end;
    with TJvSimBin.create(self) do begin
       parent:= clogfrm;
       setbounds(200,10,20,30);
       Paint;
       //Free;
     end;
     with TJvSimIndicator.Create(self) do begin
       setbounds(770,20,30,440);
       parent:= clogfrm;
       value:= 70;
       Paint;
       //Free;
     end;
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
     caption:= '********CryptoBox4 AES256 and SHA256************';
     height:= 610;
     width:= 1160;
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
    SetBounds(LEFTBASE+450, TOPBASE+40, 650, 400);
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
    setbounds(LEFTBASE+ 630, TOPBASE+ 460,150, 40);
    caption:= 'File to &Encrypt';
    font.size:= 12;
    //font.Style:= [fsBold];
    glyph.LoadFromResourceName(getHINSTANCE,'CL_MPNEXT');
    onclick:= EncryptMediaAES;
  end;

  mBtn4:= TBitBtn.Create(inFrm);
  with mBtn4 do begin
    Parent:= inFrm;
    setbounds(LEFTBASE+ 790, TOPBASE+460,150, 40);
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
    setBounds(LEFTBASE+950,TOPBASE+460,150,40);
    caption:= '&Close';
    font.size:= 12;
    glyph.LoadFromResourceName(HINSTANCE,'CL_MPSTOP');
    onclick:= CryptoButtonCloseClick; //CloseCryptClick;
  end;
  mBtn3:= TBitBtn.Create(inFrm);
  with mBtn3 do begin
    Parent:= inFrm;
    setbounds(LEFTBASE+470, TOPBASE+460,150, 40);
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
