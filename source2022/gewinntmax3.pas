unit gewinntmax3;

// host for  MP3PLAYER tool too!!
{*****************************************************}
{ 4Gewinnt Game  "the fantastic four"                 }
{ RECHNER.INC: Include-File mit der implementierten   }
{              Strategieroutine für 4GEWINNT.PAS      }
{ --------------------------------------------------- }
{ Autor       : Max Kleiner T-Ask                     }
{ Lang        : Borland Pascal for Win
  loc's= 616  : 1995 - 2012  remake for maXbox addon  }
{*****************************************************}

interface

uses
   SysUtils
  ,Classes
  ,Forms
  //,uPSComponent
  //,uPSRuntime
  //,uPSCompiler
  ,Types
  ,Graphics
  //,Windows
  ,StdCtrls
  ,Controls
  ,Dialogs
  ,Menus
  ,MPlayer , ComCtrls, Buttons, ExtCtrls, JvDualList, FileUtils
  ;



//Task: Set an event-handler for On_Maximize and On_Minimize to reDraw the Game!

Const { maximale Bewertung }
      Unendlich = 32000;
      { Wert einer Reihe wo schon drei Steine einer Farbe sind}
      Wert2 = 8;
      { Wert einer Reihe wo schon zwei Steine einer Farbe sind}
      Wert3 = 30;
      N                    = 6;       //N * M   row * col
      M                    = 7;       //col
      BLAU                 = 1;
      ROT                  = 10;
      BORDER               = 20;
      BSUM                 = 256;

      //MP3
      MILLISECONDS = 50;
      MEDIAPATH = 'examples\';    //change to =  'exercices\';

      BACKBITMAP = 'examples\citymax.bmp';


 Type
      { Rechentiefe für die einzelnen Spielstärken }
      TRechentiefe = Array[0..3] Of Integer;
      TZeilenVektor = array[1..M] of Integer;    //Row inside
      TSpielMatrix = array[1..N] of TZeilenVektor;
  
      { Wert der Stein Position - Stone Position Value SPV }
      {PosWert : SpielMatrix = ((3, 4, 5, 7, 5, 4, 3),
                               ( 4, 6, 8,10, 8, 6, 4),
                               ( 5, 8,11,13,11, 8, 5),
                               ( 5, 8,11,13,11, 8, 5),
                               ( 4, 6, 8,10, 8, 6, 4),
                               ( 3, 4, 5, 7, 5, 4, 3));}
                               

 Twinmemory4 = class(TForm)
 //procedure FormDblClick(Sender: TObject);
  published
  public
  private
  Procedure WM_Paint(Sender: TObject);

  procedure FormCloseClick(Sender: TObject; var Action: TCloseAction);

//Procedure WMMouseMove;

  procedure GewinntMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);

//Procedure T4GwWindow.WMLButtonDown;

  procedure MouseDownLeft(sender: TObject; Button: TMouseButton;
                                           Shift: TShiftState; X, Y: Integer);

  procedure ButtonReset(sender: TObject);
  procedure EChangeColor(sender: TObject);
  procedure EChangeLevel(sender: TObject);

  //procedure FormTCreate;

    //procedure FormCreate(Sender: TObject);
  end;

 TMP3Player = class(Twinmemory4)
 //procedure FormDblClick(Sender: TObject);
  published
  public
  private
  //Procedure WM_Paint(Sender: TObject);

  procedure FormCloseClick(Sender: TObject; var Action: TCloseAction);
    procedure runDuallistForm;
    procedure plaYList;
    procedure checkBoxClick(Sender: TObject);
    procedure GetMediaData(sender: TObject);
    procedure CloseMediaData(sender: TObject);
    procedure StoreSonglist(Sender: TObject);
    procedure LoadSonglist(Sender: TObject);
    procedure ProgresTimerTimer(Sender: TObject);
    procedure LogBox_DiceClick(Sender: TObject);
    procedure ChangeSong(Sender: TObject);
    procedure DeleteItem(Sender: TObject);
   // procedure SetMP3Form;

//Procedure WMMouseMove;
    //procedure GewinntMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
  //Procedure T4GwWindow.WMLButtonDown;
  //procedure ButtonReset(sender: TObject);
  //procedure EChangeColor(sender: TObject);
  //procedure EChangeLevel(sender: TObject);
   //procedure FormTCreate;
     //procedure FormCreate(Sender: TObject);
  end;


 var  deepc: TRechentiefe;
      SM, SpM, p: TSpielMatrix;
      ZA, Count:  TZeilenVektor;
      Drei_Rot, Drei_Blau, Ende, Equal, compute,
                      Sieg_Rot, Sieg_Blau, ChangeColor: Boolean;
      RWert: Array[0..40] of Integer;
      CompStart, Best, Delta, StX, StY, L1, Color: Integer;
      Abbruch: Boolean;
      //pForm: TForm;   // _4Gewinnt: TVierGewinnt;
      Grad: Byte;
      Score: Longint;
      pform: Twinmemory4;
      pform2: TMP3Player;

  //mp3
  selectFile: string;
  loadlist: TStringlist;
  handle: THandle;
  mPlayer: TMediaPlayer;
  lstbox: TListbox;
  stat: TStatusbar;
  S_Listmode, S_LoadList: Boolean; //play mp3 list
  chkbox: TCheckbox;
  mbutton: TBitBtn;
  //inFrm: TForm;
  Progress: TProgressBar;
  ProgTimer: TTimer;


//var
  //winmemory: TWinmemory;

{procedure Exit1Click(Sender: TObject);
begin
  Close;
end;}

   procedure FormTCreate;
   procedure FormCreateInit4Game(Sender: TObject);

   procedure FormSetMP3FormCreate;


implementation

  {$R *.dfm}

   uses JVDice, JvAnalogClock, JvStarfield;


   //uses //IFSI_WinForm1puzzle,
   //LinarBitmap;

procedure WMRechner; forward;

procedure SearchAndReplace(aStrList: TStrings; aSearchStr, aNewStr: string);
var i, t1: integer;
    s1: string;
begin
  // old string can't be part of new string!, eg.: max --> climax
  if pos(aSearchStr, aNewStr) > 0 then begin
    write('old string cant be part of new string');
    exit;
  end;
  for i:= 0 to aStrList.Count -1 do begin
    s1:= aStrList[i];
    repeat
      t1:= pos(aSearchStr, s1);
      if t1 > 0 then begin
        Delete(s1, t1, Length(aSearchStr));
        Insert(aNewStr, s1, t1);
        aStrList[i]:= s1;
      end;
    until t1 = 0;
  end; 
end;

function MSecToTime(mSec: Int64): string;
var dt: TDateTime;
begin
  dt:= (mSec/1000/86400);  //SecsPerDay;
  Result:= FormatDateTime('" Length:" nn:ss:zzz',dt);
end;

function getBitmap(apath: string): TBitmap;
  begin
    result:= TBitmap.Create;
    with result do try
      LoadFromFile(apath);
    finally
      //Free;
    end;
  end;




//**********************************MP3******************************3
procedure TMP3Player.FormCloseClick(Sender: TObject; var Action: TCloseAction);
begin
  //Form1.Close;  free 308 kByte
  if MessageDlg('Wanna Leave?',mtConfirmation,[mbYes, mbNo],0) = mrYes then begin
    MPlayer.Close;
    MPlayer.Free;
    //bmp.Free;
  if progTimer <> NIL then begin
    progTimer.enabled:= false;
    progTimer.Free;
    progTimer:= NIL;
  end;
  if assigned(loadlist) then
    loadlist.Free;
  action:= caFree;
    //ShowMessage('Now you see the hits of mX3');
    //ExecuteCommand('http://www.softwareschule.ch/maxboxshow.htm','')
 end else
    Action:= caNone;
  //close
end;

procedure TMP3Player.runDuallistForm;
var getList: TStringlist;
    //mpFrm: TJvDualListForm;
    mpFrmdlg: TJvDualListDialog;
    i: integer;
    //s1: string;
begin
  getList:= TStringlist.create;
   //GetDirList(extractfilePath(selectFile),getlist,true)
  GetDirList(extractfilePath(selectFile)+'*.mp3',getlist,true);
  {for i:= 1 to getlist.count-1 do begin
  t1:= pos('*.mp3',getlist[i]);
  s1:= getlist[i]; Delete(s1,5,t1);  end;}
  SearchAndReplace(getlist,'*.mp3','');

  mpFrmDlg:= TJvDualListDialog.create(self);
   with mpFrmDlg do begin
     list1:= getList;
     width:= 1100;
     height:= 550;
     resizable:= true;
     ScrollBars:= ssboth;
     //SetBounds(10,10,450,400)
     listboxheight:= 400;
     listboxscrollwidth:= 500;
     label1caption:= 'Song Selection:';
     label2caption:= 'Song Play List:';
     okBtncaption:= 'Play';
     //TJvDualListDialog(setbounds
     title:= 'MP3 Dual Player';
     HelpBtnCaption:= 'Help Play';
    for i:= 0 to mpFrmDlg.ComponentCount - 1 do
      if mpFrmDlg.Components[i] is TListBox then begin
        with mpFrmDlg.Components[i] {as TListBox} do
        TListbox(mpFrmDlg.Components[i]).color:= clblue;
      end;
    Execute;
    //loadlist.assign(TStringlist(list2));
    for i:= 0 to list2.count- 1 do
      loadlist.add(list2[i]);
    //writeln('debug list count '+inttostr(loadlist.count));
    //showmodal;
    Free;
  end;
  //LetLogoDraw(inFrm.Canvas,55,5,5, clred);
  getlist.Free;
end;

procedure TMP3Player.plaYList;
var i: integer;
begin
  lstbox.font.size:= 14;
  if NOT S_Listmode then begin
      Progress.Max:= 0;
      MPlayer.Close;
      MPlayer.Wait:= true;
      MPlayer.filename:= selectFile;
      MPlayer.Open;
      Progress.Max:= mPlayer.Length;
      lstbox.items.add(Format('%s - %s ',
                 [ExtractFileName(selectFile),MSecToTime(MPlayer.length)]));
      loadlist.add(selectFile);  //tmp
      lstbox.hint:= ExtractFileName(selectFile);
      stat.SimpleText:= Format('%s: %s ',[selectFile,MSecToTime(MPlayer.length)]);
      //Writeln('play time '+MSecToTime(MPlayer.length));
      MPlayer.Play; 
    end;  
  
  if S_Listmode then begin
    lstbox.items.clear;
    //if not S_Loadlist then
    //lstbox.items.add('MP3 BOX List'); 
    for i:= 0 to loadlist.count-1 do begin 
       lstbox.items.add(extractFileName(loadlist[i]))
    end;  
      MPlayer.EnabledButtons:= [btStop];
    for i:= 1 to loadlist.count-1 do begin 
       application.ProcessMessages;
       //VIDEO... MPlayer.filename:= ExePath+'examples\*.mpeg';
      Progress.Max:= 0;
      lstbox.selected[i]:= true;
      MPlayer.Close;
      MPlayer.Wait:= true;
      MPlayer.filename:= loadlist[i];
      MPlayer.Open;
      stat.SimpleText:= Format('%s: %s ',[loadlist[i],MSecToTime(MPlayer.length)]);
      //Writeln('play time of '+inttoStr(i)+MSecToTime(MPlayer.length));
      MPlayer.Play;
      Sleep(MPlayer.length);
    end;
  end;
  //LetLogoDraw(inFrm.Canvas, 55, 5, 5, clred);
end;


procedure TMP3Player.checkBoxClick(Sender: TObject);
begin
    //chkbox.checked:= Not chkbox.checked;
  if chkbox.checked then begin
     S_Listmode:= true;
     mbutton.caption:= 'Open MP3 List';
    if S_LoadList then PlayList;
  end else begin
    S_Listmode:= false;
    mbutton.caption:= 'Open MP3 Song';
    //writeln('listmode set to '+booleantoString(S_Listmode));
  end;
end;

procedure TMP3Player.GetMediaData(sender: TObject);
begin
 if PromptForFileName(selectFile, 'Media files (*.mp3)|*.mp3|*.mpg)|*.mpg', //others
                      '', 'Select your mX3 media file Directory',
                         MEDIAPATH, False) //false: not Save dialog!
   then begin
     // Display this full file/path value
     stat.SimpleText:= 'Selected File Path First: '+ExtractFilePath(selectFile);
     if S_Listmode then
        runDuallistForm;
      //LetLogoDraw(inFrm.Canvas, 110, 5, 5, clred);
      MPlayer.AutoEnable:= false;
      //MPlayer.EnabledButtons := [];
      MPlayer.EnabledButtons:= [btPause, btStop, btPlay, TMPBtnType(btNext), btStep, btBack];//, btNext, btPrev, btBack];
      MPlayer.Refresh;
      plaYList;
   end;
end;

procedure TMP3Player.CloseMediaData(sender: TObject);
begin
   lstbox.items.clear;
   loadlist.Clear;
end;

procedure TMP3Player.StoreSonglist(Sender: TObject);
begin
selectFile:= 'mp3Songlist.txt';
if PromptForFileName(selectFile, 'Save Song list (*.txt)', //others
                      '', 'Select your mX3 media file Directory',
                      '', True) //true: Save!
  then
    loadlist.SaveToFile(selectFile)
end;

procedure TMP3Player.LoadSonglist(Sender: TObject);
var i: integer;
begin
  selectFile:= 'mp3Songlist.txt';
  lstbox.font.size:= 14;
  S_LoadList:= true;
  if PromptForFileName(selectFile, 'Load Song list (*.txt)', //others
                      '', 'Select your mX3 media Directory',
                      MEDIAPATH, false) //false: not Save!
  then begin
    lstbox.items.clear;
    //lstbox.items.add('MP3 BOX');
    loadlist.LoadFromFile(selectFile);
    for i:= 0 to loadlist.count-1 do
       lstbox.items.add(extractFileName(loadlist[i]))
  end;
end;

procedure TMP3Player.ProgresTimerTimer(Sender: TObject);
begin
  if Progress.Max<>0 then
    Progress.Position:= mPlayer.Position;
end;

 procedure TMP3Player.LogBox_DiceClick(Sender: TObject);
 begin
    with TJvDice(sender) do begin
       interval:= 200;
       RandomValue;
       rotate:= true;
       AutoStopInterval:= 2500;
    end;
    //DiceRandom(Self);
 end;

 procedure TMP3Player.ChangeSong(Sender: TObject);
begin
  //lstbox.items[lstbox.itemIndex];
  Progress.Max:= 0;
  lstbox.font.size:= 14;
  with MPlayer do begin
     Close;
     //EnabledButtons:= [btPause, btStop, btPlay, btBack];
     EnabledButtons:= [btPause, btStop, btPlay, TMPBtnType(btPrev), btBack];

     filename:= loadlist[lstbox.itemIndex];
     Open;
     Progress.Max:= mPlayer.Length;
     stat.SimpleText:= Format('Once %s: %s ',[selectFile,MSecToTime(MPlayer.length)]);
     Play;
  end;
  //Writeln('song changed: '+ Mplayer.filename);
  //LogBox_DiceClick(self);
end;

procedure TMP3Player.DeleteItem(Sender: TObject);
begin
  //lstbox.items[lstbox.itemIndex];
   if lstbox.selected[lstbox.itemIndex] then
     lstbox.items.delete(lstbox.itemIndex);
end;


//************************************ Form Builder ***************************
procedure FormSetMP3FormCreate;//TMP3Player.SetMP3Form;
var //inFrm: TForm;
    //lstbox: TListbox;
  mi, mi1, mi2, mipop: TMenuItem;
  mpop: TPopupmenu;
  mt: TMainMenu;
begin
  pform2:= TMP3Player.Create(NIL);   //constructors

  //inFrm:= TForm.Create(pform2);
  loadlist:= TStringlist.create;
  loadlist.Add('maXbox MP3 Boxlist');  //FILE HEADER
  mpop:= TPopupMenu.create(pform2);
  mipop:= TMenuItem.Create(mt);
  with mipop do begin
    Caption:='Delete List Item';
    mpop.Items.Add(mipop) ;
    OnClick:= pform2.DeleteItem;
  end;
  {  object Delete1: TMenuItem
      Action = acDelete
    end}
   with pform2 do begin
      caption:= '********MediaPlayer3************';
      Formstyle:= fsStayontop;
      height:= 650;
      width:= 750;
      //color:= clred;
      Position:= poScreenCenter;
      onClose:= pform2.FormCloseClick;
      popupmenu:= mpop;
      show;
   end;

   with TPanel.Create(pform2) do begin
     caption:= '********maXboxMP3********';
     parent:= pform2;
     SetBounds(40,40,500,420);
     color:= clyellow;
     show;
   end;
  Lstbox:= TListbox.create(pform2);
  with Lstbox do begin
    parent:= pform2;
    setBounds(50,50, 480,400);
    font.size:= 55;
    font.color:= clwhite;
    color:= clPurple;
    items.add('MP3 BOX');
    onDblClick:= pform2.ChangeSong;
    //popupmenu
  end;

  // lstbox.items.clear;


  mButton:= TBitBtn.Create(pform2);
  with mButton do begin
    Parent:= pform2;
    setbounds(400,480,150, 40);
    caption:= 'Open MP3 List';
    font.size:= 12;
    glyph.LoadFromResourceName(HINSTANCE,'OPENFOLDER');
    //mXButton(0,0,width, height,12,12,handle);
    //event handler
    onclick:= pform2.GetMediaData;
  end;

  with TBitBtn.Create(pform2) do begin
    Parent:= pform2;
    setbounds(560,480,150, 40);
    caption:= 'Clear List';
    font.size:= 12;
    glyph.LoadFromResourceName(HINSTANCE,'CLOSEDFOLDER');
    //mXButton(0,0,width, height,12,12,handle);
    //event handler
    onclick:= pform2.CloseMediaData;
  end;

  with TJvAnalogClock.Create(pform2) do begin  //widgets set
    parent:= pform2;
    //bevelwidth:= 0;
    colormin:= clblue;
    //timeoffSet:= -60;
    ColorHr:= clRed;
    //WidthHandHr:= 1;
    ColorHandHr:= clRed;
    ColorHandMin:= clRed;
    setBounds(585,55,100,100);
    //centercol:= clyellow; //cldarkblue32; //clwebgold;
    //centersize:= 8;
  end;
  with TJvStarfield.Create(pform2) do begin
    parent:= pform2;
    stars:= 250;
    maxSpeed:= 12;
    setBounds(585,195,100,100);
    active:= true;
  end;
  with TJvDice.create(pform2) do begin
    setbounds(585,325,100,105);
    parent:= pform2;
    interval:= 500;
    RandomValue;
    rotate:= true;
    //AutoSize:= true;
    AutoStopInterval:= 1500;
    //onmousedown;
    //showfocus:= true;
    onclick:= pform2.LogBox_DiceClick;
  end;

  //pform2.Canvas.Draw(460,10,getBitmap(ExtractFilePath(Application.Exename)+BACKBITMAP));

  stat:= TStatusbar.Create(pform2);
  with Stat do begin
    parent:= pform2;
    Align:= alBottom;
    stat.SimplePanel:= true;
  end;
  Progress:= TProgressBar.Create(pform2);
  with progress do begin
    parent:= pform2;
    Align:= alBottom;
    //step:= 10;
    //Max:= maxSteps+20;
  end;
  chkbox:= TCheckBox.create(pform2);
  with chkbox do begin
    Parent:= pform2;
    checked:= false;
    if checked then S_Listmode:= true else
      S_Listmode:= false;
    setbounds(300,480,80, 40);
    font.size:= 12;
    caption:= 'Play List';
    onClick:= pform2.checkboxClick;
  end;

  mt:= TMainMenu.Create(pform2);
  mi:= TMenuItem.Create(mt);
  mi1:= TMenuItem.Create(mt);
  mi2:= TMenuItem.Create(mt);
  //mi3:= TMenuItem.Create(mi)
  with mi do begin
    //parent:= frmMon;
    Caption:='Load SongList';
    Name:='ITEM';
    mt.Items.Add(mi);
    OnClick:= pform2.LoadSonglist;
  end;
  with mi1 do begin
    Caption:='Store SongList';
    Name:='ITEM2';
    mt.Items.Add(mi1) ;
    OnClick:= pform2.StoreSonglist;
  end;
  with mi2 do begin
    Caption:='Open CDPlayer';
    Name:='ITEM3';
    mt.Items.Add(mi2);
    //OnClick:= @OPenCD;
  end;

  MPlayer:= TMediaPlayer.create(pform2);
  MPlayer.parent:= pform2;
  MPlayer.top:= 481;
  MPlayer.left:= 20;
  MPlayer.height:= 36;
  //Mplayer.Display:= mPanel;   //for video
  MPlayer.AutoEnable:= false;
  //mplayer.next;
  MPlayer.EnabledButtons:= [btPause,btStop];
  progTimer:= TTimer.Create(pform2);
  progTimer.onTimer:= pform2.ProgresTimerTimer;
  progTimer.interval:= MILLISECONDS;
  //LetLogoDraw(pform2.Canvas, 55,5,5, clred);
  S_LoadList:= false;

 //('TMPBtnType','(btPlay,btPause,btStop,btNext,btPrev,btStep,btBack,btRecord,btEject)');
  //CL.AddTypeS('TButtonSet', 'set of TMPBtnType');
end;
//************************************ MP3 Form Builder End************************




procedure initMatrix;
begin
  deepc[0]:= 4;   deepc[1]:= 4;
  deepc[2]:= 5;   deepc[3]:= 6;

  //ZeilenVektor = (4,3,5,2,6,7,1);
  ZA[1]:= 4; ZA[2]:= 3; ZA[3]:= 5;
  ZA[4]:= 2; ZA[5]:= 6; ZA[6]:= 7; ZA[7]:= 1;

  p[1][1]:=3; p[1][2]:=4; p[1][3]:=5;  p[1][4]:=7;  p[1][5]:=5;  p[1][6]:=4; p[1][7]:=3;
  p[2][1]:=4; p[2][2]:=6; p[2][3]:=8;  p[2][4]:=10; p[2][5]:=8;  p[2][6]:=6; p[2][7]:=4;
  p[3][1]:=5; p[3][2]:=8; p[3][3]:=11; p[3][4]:=13; p[3][5]:=11; p[3][6]:=8; p[3][7]:=5;
  p[4][1]:=5; p[4][2]:=8; p[4][3]:=11; p[4][4]:=13; p[4][5]:=11; p[4][6]:=8; p[4][7]:=5;
  p[5][1]:=4; p[5][2]:=6; p[5][3]:=8;  p[5][4]:=10; p[5][5]:=8;  p[5][6]:=6; p[5][7]:=4;
  p[6][1]:=3; p[6][2]:=4; p[6][3]:=5;  p[6][4]:=7;  p[6][5]:=5;  p[6][6]:=4; p[6][7]:=3;
end;


Procedure Reset;
Var i,j: Integer;
Begin
  compute:= False;
  Sieg_Rot:= False;
  Sieg_Blau:= False;
  Equal:= False;
  For i:= 1 To N Do
    For j:= 1 To M Do SpM[i][j]:= 0;
  For j:= 1 To M Do Count[j]:= 0;
  Delta:= 0;
End;


Procedure InitGame;
Begin
  //TWindow.Init(NIL,AName);
  //Attr.Menu:=LoadMenu(HInstance,'MENU');
  Grad:= 1;         //levels 0 - 3;  3 as Expert
  CompStart:= 1;
  changeColor:= false;
  Reset;
End;


Procedure T4GwWindow_Anfaenger;   //cm prototype 1995!
Begin
  {MyMenu:= GetMenu(HWindow);
  CheckMenuItem(MyMenu,cm_Anfaenger+Grad,
                mf_ByCommand+mf_Unchecked);
  Grad:= 0;}
End;


Function Auswertung(stufe: integer; rs: byte): integer;
var BW: integer;
Begin
  Drei_Rot:= rS=30;
  Drei_Blau:= rS=3;
  If rS>1 Then
    If rS=40 Then Begin
      result:= -30000-Stufe;
      If Stufe=100 Then
        result:= -Unendlich;
      Ende:= True;
    End Else
    If rS=4 Then Begin
      result:= 30000+Stufe;
      If Stufe=100 Then
        result:= Unendlich;
      Ende:= True;
    End Else
      BW:= BW + RWert[rS];
     //Inc(BW,RWert[S]);
End;

{-----------------------------------------------------}
{*****************************************************}
{ T4GwWindow.Rechner: Reaktion auf Meldung wm_rechner }
{                     In dieser Routine wird der Zug  }
{                     für den Computer mit Hilfe      }
{                     Minimaxstrategie und AlphaBeta- }
{                     Abschneidung ermittelt.         }
{*****************************************************}
{*****************************************************}
{ Mit Hilfe dieser Funktion wird die jeweilige Spiel- }
{ stellung bewertet.                                  }
{*****************************************************}

Function Bewertung(Stufe: Integer): Integer;
Var BW, S, i, j, k, Help: Integer;
  {-------------------------------------------------}
  { Hilfsprozedur zur Auswertung der Spielstellung  }
  {-------------------------------------------------}
Begin
  BW:= 0;
  {-------------------------------------------------}
  { Bewertungskriterium 1:                          }
  {   Werte der einzelnen Spielsteinpositionen      }
  {-------------------------------------------------}
  For j:= 1 To M Do
    For i:= 1 To Count[j] Do Begin
      If SM[i][j]=1 Then
        BW:= BW+P[i][j];
      If SM[i][j]=10 Then
        BW:= BW-P[i][j];
    End;
  {-------------------------------------------------}
  { Bewertungskriterium 2:                          }
  {   Bewertung der jeweiligen Zweier-, Dreier- und }
  {   Viererreihen der Spielstellung                }
  {-------------------------------------------------}
  Ende:= False;

  {-------- senkrechte Reihen --------}
  For j:= 1 To M Do Begin
    Help:= Count[j];
    If Help>3 Then Help:= 3;
    For i:= 1 To Help Do Begin
      S:= SM[i][j]+SM[i+1][j]+SM[i+2][j]+SM[i+3][j];
      result:= Auswertung(stufe,S);
      If Ende Then Exit;
      If Drei_Rot Then
        For k:= 0 To 3 Do
          If SM[i+k][j]=0 Then
            If i+k And 1=CompStart Then
              BW:= BW-RWert[3];
              //Dec(BW,RWert[3]);
      If Drei_Blau Then
        For k:= 0 To 3 Do
          If SM[i+k][j]=0 Then
            If i+k And 1=1-CompStart Then
              BW:= BW + RWert[3];
              //Inc(BW,RWert[3]);
    End; //for
  End; //for

  {-------- waagrechte Reihen --------}
  For j:= 1 To M-3 Do
    For i:= 1 To N Do Begin
      S:= SM[i][j]+SM[i][j+1]+SM[i][j+2]+SM[i][j+3];
      result:= Auswertung(stufe,S);
      If Ende Then Exit;
      If Drei_Rot And (j>1) Then
        If j And 1=CompStart Then
          BW:= BW-3*RWert[3];
          //Dec(BW,3*RWert[3]);
      If Drei_Blau And (j>1) Then
        If j And 1=1-CompStart Then
          BW:= BW + 3*RWert[3];
          //Inc(BW,3*RWert[3]);
    End;
  {-------- diagonale Reihen --------}
  For i:= 1 To N-3 Do
    For j:= 1 To M-3 Do Begin
      S:= SM[i][j]+SM[i+1][j+1]+SM[i+2][j+2]+SM[i+3][j+3];
      result:= Auswertung(stufe,S);
      If Ende Then Exit;
      If Drei_Rot Then
        For k:=0 To 3 Do
          If SM[i+k][j+k]=0 Then
            If i+k And 1=CompStart Then
              BW:= BW - 2*RWert[3];
              //Dec(BW,2*RWert[3]);
      If Drei_Blau Then
        For k:=0 To 3 Do
          If SM[i+k][j+k]=0 Then
            If i+k And 1=1-CompStart Then
              BW:= BW-2*RWert[3];
              //Inc(BW,2*RWert[3]);
      S:= SM[i+3][j]+SM[i+2][j+1]+SM[i+1][j+2]+SM[i][j+3];
      result:= Auswertung(stufe,S);
      If Ende Then Exit;
      If Drei_Rot Then
        For k:=0 To 3 Do
          If SM[i+3-k][j+k]=0 Then
            If i+3-k And 1=CompStart Then
              BW:= BW-2*RWert[3];
      If Drei_Blau Then
        For k:= 0 To 3 Do
          If SM[i+3-k][j+k]=0 Then
            If i+3-k And 1=1-CompStart Then
              BW:= BW+2*RWert[3];
    End; //for
  result:= BW;
End;

{*****************************************************}
{ Ermittlung des besten Zuges für den Computer mit    }
{ Hilfe der MiniMax-Strategie und dem AlphaBetaCut    }
{ Diese rekursive Funktion liefert schließlich den    }
{ Wert der Spielstellung zurück. Der beste Spielzug   }
{ ist dann in der Variable Bester abgelegt.           }
{*****************************************************}

Function MiniMax(Wert,Tiefe,Alpha: Integer): Integer;
Var i,j, Help, Zug, Beta: Integer;
             AlphaBetaCut: Boolean;
Begin
  If Not Abbruch Then Begin
    If (Abs(Bewertung(Tiefe+1))>=29000) OR
       (Count[1]+Count[2]+Count[3]+Count[4]+
        Count[5]+Count[6]+Count[7]>= 42) Then
      result:= Bewertung(Tiefe+1)
    Else Begin
      {While PeekMessage(HMsg,HWindow,0,0,pm_Remove) Do
        If (HMsg.Message=wm_SysCommand) And
           (HMsg.WParam=sc_Close) Then Abbruch:=True
        Else while Application.ProcessMesages do
         //Abbruch:= true; }
      If Wert=1 Then
        Beta:= -Unendlich
      Else
        Beta:= Unendlich;
      Zug:= 0;
      AlphaBetaCut:=False;
      If Tiefe>0 Then Begin
        For i:= 1 To M Do Begin
          j:= ZA[i];
          If (Count[j]<N) AND NOT AlphaBetaCut Then Begin
            Inc(Count[j]);
            SM[Count[j]][j]:= Wert;
            If Tiefe>1 Then
              Help:= MiniMax(Blau+Rot-Wert,Tiefe-1,Beta)
            Else
              Help:= Bewertung(Tiefe);
            SM[Count[j]][j]:= 0;
            Dec(Count[j]);
            If Wert=Blau Then Begin
              If Help>Beta Then Begin
                Beta:= Help;
                Zug:= j;
              End;
              If Beta>Alpha Then
                AlphaBetaCut:=True;
            End
            Else Begin
              If Help<Beta Then Begin
                Beta:= Help;
                Zug:= j;
              End;
              If Beta<Alpha Then
                AlphaBetaCut:= True;
            End;
          End; //If
        End; //For
        result:= Beta;
      End //If
      Else result:= Bewertung(Tiefe+1);
      pForm.Canvas.brush.Color:= clblue;
      pform.Canvas.Font.Color:= clyellow;
      pform.Canvas.TextOut(3, BORDER+13, 'CPU Think Level: '+intToStr(Tiefe));
    End;
   Best:= Zug;
  End;
End;

{**************************************************************}
{ Hilfsfunktion zur Bestimmung, ob das Spiel noch weiter geht  }
{**************************************************************}
Function SpielEnde: Boolean;
Begin
  result:= True;
  If Bewertung(100)<=-Unendlich Then
    Sieg_Rot:= True
  Else
    If Bewertung(100)>=Unendlich Then
      Sieg_Blau:= True
  Else
    If Count[1]+Count[2]+Count[3]+Count[4]+
         Count[5]+Count[6]+Count[7]= N*M Then
           Equal:= True
    Else
      result:= False;
End;

/////from main game form
Function FarbWert(W: Word): TColor;  //TColor?
Begin
  Case W Of
    0: result:= clblack; //RGB2TColor($BF,$BF,$BF);
    1: result:= clblue; //RGB2TColor($00,$00,$00);
    2: result:= clred; //RGB2TColor($FF,$FF,$FF);
    3: result:= clsilver; //RGB2TColor($FF,$00,$ff);
    4: result:= clblack; // RGB2TColor($00,$00,$00);
    5: result:= clgreen;//RGB2TColor($00,$00,$FF);      //clred
    6: result:= clpurple; //RGB2TColor($F7,$00,$00);
    7: result:= clwebgold; //RGB2TColor($7F,$7F,$7F);
  End;
End;


Procedure WM_SetzeStein(wparam, lparam: integer);
Var //DC: HDC;
    XPos, YPos, X, Y: Integer;
Begin
  Y:= 7-wParam Mod BSUM;
  X:= wParam Div BSUM;
  XPos:= StX+(X-1)*L1+2;
  YPos:= StY+(Y-1)*L1+2;
  //DC:=GetDC(HWindow);
    if changeColor then
      pForm.Canvas.brush.Color:= FarbWert(lparam+5)
    else
      pForm.Canvas.brush.Color:= FarbWert(lparam+color);
   //SelectObject(DC,Brush);
   pForm.Canvas.Ellipse(XPos,Ypos,Xpos+L1-3,Ypos+L1-3);
   //pform.Canvas.TextOut(xpos,ypos,inttostr(p[y][x])); //debug the values
   //ReleaseDC(HWindow,DC);
End;

//********************** Set the Game Board Form *****************************
Procedure Spielfeld;
Var NRect: TRect;
    Breite, Hoehe, i: Integer;
Begin
  //pForm.canvas.GetClientRect(HWindow,Rect);
  //DC:=GetDC(HWindow);
  with pForm.Canvas do begin
    brush.color:= FarbWert(0+color);
    NRect:= Rect(0,0,pform.width-BORDER,pform.height-(2*BORDER));
    FillRect(NRect);
    Breite:= (NRect.Right-BORDER) Div M;
    Hoehe:= (NRect.Bottom-(2*BORDER)) Div N;
    If Breite>Hoehe Then L1:= Hoehe Else L1:= Breite;
    Brush.color:= FarbWert(3+color);
    StX:= (NRect.Right-L1*M) Div 2;
    StY:= (NRect.Bottom-L1*N) Div 2;
    Rectangle(StX,StY,L1*M+StX+1,L1*N+StY+1);
    For i:= 1 To M-1 Do Begin
      MoveTo(L1*i+StX,StY);
      LineTo(L1*i+StX,StY+L1*N);
    End;
    For i:= 1 To N-1 Do Begin
      MoveTo(StX,L1*i+StY);
      LineTo(L1*M+StX,L1*i+StY);
    End;
  End; //with
  //Sbutton.top:= pForm.height-4*BORDER; debug
  //ReleaseDC(HWindow,DC);
End;

Procedure Gewonnen;
Var mRect: TRect; GMsg: PChar;
Begin
  GMsg:='';
  If Sieg_Rot Then begin
    pForm.Canvas.brush.Color:= clred;
    GMsg:='  Wow Gratulation you win!!';
  end;
  If Sieg_Blau Then GMsg:=' Sorry, You lost!';
  If Equal Then GMsg:=' Same for two ';
  If Sieg_Rot Or Sieg_Blau Or Equal Then Begin
    //GetClientRect(HWindow,Rect);
    mRect.Bottom:= BORDER;
    //Showmessage(GMsg);  //debug
    pform.Canvas.Font.Size:= 14;
    pform.Canvas.TextOut(3, mrect.bottom-BORDER+5, GMsg);
  End;
End;

//**************************** Event Handler ******************************
Procedure Twinmemory4.WM_Paint(Sender: TObject);
Var i, j: Word;
Begin
  Color:= 4;
  Spielfeld;
  For i:= 1 To M Do
    For j:= 1 To Count[i] Do Begin
      If SpM[j][i]=Rot Then
         WM_Setzestein(i*BSUM+j,2);
      If SpM[j][i]=Blau Then
         WM_Setzestein(i*BSUM+j,1);
    End;
  Gewonnen;
End;

procedure Twinmemory4.FormCloseClick(Sender: TObject; var Action: TCloseAction);
begin
  //myImage.Free;
  //Writeln('4Gewinnt Form Closed at: '+ TimeToStr(Time));
  //pFrm.Free;
  Abbruch:= True;
  Screen.Cursor:= crDefault;
  Action:= caFree;
end;

     
//Procedure WMMouseMove;
procedure Twinmemory4.GewinntMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
Var XPos, X1: Integer;
    Help1, Help2: Integer;
begin
  If Not compute Then Help1:= crArrow
    Else Help1:= crHourglass;
  If Not compute Then Help2:= crCross  //idc_cross
    Else Help2:= crHourglass;
  XPos:= X;
  If (XPos>StX) AND (XPos<StX+M*L1) AND NOT
     (Sieg_Rot OR Sieg_Blau Or Equal) Then
     Begin
       X1:=(XPos-StX) Div L1+1;     //shows possible move
       If X1>7 Then X1:= 7;
       If X1<1 Then X1:= 1;
       If Count[X1]<N Then Screen.Cursor:= Help2
         Else Screen.Cursor:= help1   //SetCursor(LoadCursor(0,Help1));
     End
  Else Screen.Cursor:= help1;
End;

//Procedure T4GwWindow.WMLButtonDown;
procedure Twinmemory4.MouseDownLeft(sender: TObject; Button: TMouseButton;
                          Shift: TShiftState; X, Y: Integer);
Var XPos, X1, cntint: Word;
Begin
  XPos:= X;  
  If (XPos>StX) AND (XPos<StX+M*L1) AND NOT
    (Sieg_Rot OR Sieg_Blau OR Equal) Then
  Begin
    X1:= (XPos-StX) Div L1+1;
    If X1> M Then X1:= M;
    If X1< 1 Then X1:= 1;
    If Count[X1] < N Then Begin
      Inc(Count[X1]);
      If Count[X1]= N Then Inc(Delta);
      cntint:= Count[X1];
      SpM[cntint][X1]:= Rot;
      WM_Setzestein(X1*BSUM+Count[X1],2);
      WMRechner; //Bewertung, Auswertung(1);
    End;
  End;
End;
    


procedure Twinmemory4.ButtonReset(sender: TObject);
begin
  InitGame;
  Spielfeld;
end;  

procedure Twinmemory4.EChangeColor(sender: TObject);
begin
  changeColor:= NOT changeColor;
end; 

procedure Twinmemory4.EChangeLevel(sender: TObject);
begin
  Grad:= 3;  //highest level 
end;  


procedure FormTCreate;
//var label1: TLabel; bevel1,bevel2: TBevel;  for future expansion
var mi, mi1, mi2: TMenuItem;
    mt: TMainMenu; 
    sbutton: TButton;
begin
  //SetFigures;
  //RedrawSheet:= True;
  {bevel1:= TBevel.create(pform)
  bevel1.parent:= pForm;
  bevel2:= TBevel.create(pform)
  bevel2.parent:= pForm;
  label1:= TLabel.create(pform)
  label1.parent:= pForm;}

  pform:= TWinMemory4.Create(NIL);   //constructors
  sButton:= TButton.Create(pform);
  with pform do begin
    caption:= '4Gewinnt GameBox 2014';
    //BorderStyle:= bsDialog;
    Cursor:= CRHandpoint;
    Position:= poScreenCenter;
    onMouseDown:= MouseDownLeft;
    onMouseMove:= GewinntMouseMove;
    onPaint:= WM_Paint;
    onClose:= FormCloseClick;
    //KeyPreview:= true;
    ClientWidth:= pForm.Width+150;
    ClientHeight:= pForm.height+150;
    Show;
  end;
  with SButton do begin
    parent:= pForm;
    caption:= 'Reset!';
    top:= pForm.height-4*BORDER-5;
    width:= 4*BORDER;
    onclick:= pform.ButtonReset;
  end;
  mt:= TMainMenu.Create(pForm);
  with mt do begin
   //parent:= frmMon;
  end;
  mi:= TMenuItem.Create(mt);
  mi1:= TMenuItem.Create(mt);
  mi2:= TMenuItem.Create(mt);
  with mi do begin
    //parent:= frmMon;
    Caption:='New Game';
    Name:='ITEM';
    mt.Items.Add(mi);
    OnClick:= pform.ButtonReset;
  end;
  with mi1 do begin
    //parent:= frmMon;
    Caption:='Change Color';
    mt.Items.Add(mi1) ;
    OnClick:= pform.EChangeColor
  end;
  with mi2 do begin
    //parent:= frmMon;
    Caption:='High Level';
    mt.Items.Add(mi2);
    OnClick:= pform.EChangeLevel;
  end;
  Spielfeld;
  //Grad:= 1;
  Score:= 0;
end;

{*****************************************************}
{      Hauptteil der Methode T4GwWindow.Rechner       }
{*****************************************************}
//Procedure T4GwWindow_Rechner;

procedure WMRechner;
var i,j: Integer;   // from Rechner
begin
  For i:=0 To 40 Do RWert[i]:= 0;
  RWert[3]:= Wert3;
  RWert[30]:= -Wert3;
  RWert[2]:= Wert2;
  RWert[20]:= -Wert2;
  SM:= SpM;
    {for I:= 1 to N do
      for j:= 1 to M do SM[i][j]:= SpM[i][j];}
  If Not SpielEnde Then Begin
    Screen.Cursor:= crHourglass;//SetCursor(LoadCursor(0,idc_wait));
    compute:= True;
    Abbruch:= False;
    MiniMax(Blau, deepc[Grad]+Delta,Unendlich);
    If Abbruch Then Showmessage('PostQuitMessage(0) or Game Closed')
    Else
    If (Count[Best]<N) AND (Best>0) Then Begin
      Inc(Count[Best]);
      If (Count[Best]=N) AND (Grad>0) Then
        Inc(Delta);
      SpM[Count[Best]][Best]:= Blau;
      WM_Setzestein(Best*BSUM+Count[Best],Blau);
      SM:= SpM;  //!
    End; //If
  End;
  SpielEnde;
  Gewonnen;  //SendMessage(HWindow,wm_gewonnen,0,0);
  compute:= False;
  //SetCursor(LoadCursor(0,idc_arrow));
  Screen.Cursor:= crArrow;
end;

Procedure InitComputerStart;
Begin
  Reset;
  CompStart:= 1;
  WMRechner;
End;



procedure FormCreateInit4Game(Sender: TObject);
begin
  initMatrix;
  initGame;
  FormTCreate;
  WMRechner;
end;

begin //main
 //FormCreateInit(application)
 //ShowAllCards1Click(self)
End.





