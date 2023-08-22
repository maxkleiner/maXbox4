unit memorymax2_unit_2;
{ 
  Project  : maXbox Memory Game
  Unit Name: maXGame 185_memorymax2.txt
  Purpose  : Find all the 2 same Picture  
  Date  : 03/02/2011  -  22:54:56 , loc's = 2250
  History  : translate and integrate from delphi to mX3
           : include linking stringGrid and drawGrid 
  ToDo     : timer with statistic of 4 players and stop scrolling
 }          
// *********************************
// array is 5 * 8 = 40  (0..4)*(0..7)
// pictures are 37 files

const TotalPictures = 37;
      CROW = 4;
      CCOL = 7;
      MAXFOUND = 20;
      MAXMEM = 40;
      DECK = 'deck2.bmp';
      EMPTYCARD = 'empty.bmp';
      FILE_NAME = 'memory3.ini';     
      RESPATH ='examples\images\';         //path to memory --> examples
      
type  TMap = array[0..CROW] of integer;     
      TDisplay = array[0..CROW] of integer;     
      TShowCard = array[0..CROW] of integer;     
var  
    Bmp: TBitmap;
    Map: array[0..CCOL] of TMap;
    Display: array[0..CCOL] of TDisplay;
    ShowCard: array[0..CCOL] of TShowCard;
    FirstShot, AllCards, Play: Boolean;
    mForm: TForm;
    shotsLbl: TLabel;
    DrawGrid1: TDrawGrid;  
    StGames, StShots, StSeconds, StScore,
    Seconds, Shots, Score, Founds, FSValue,
    Col1, Row1, Col2, Row2, Turn: integer;
    MIni: TIniFile;
    Imagefile, DeckColor, Wow, Name1, Name2: String;
    TopName, TopScore, TopSeconds, TopShots: Array[1..5] of String;

{procedure Exit1Click(Sender: TObject);
begin
  Close;
end;}

procedure ShowAllCards1Click(Sender: TObject);
var i,j : integer;
begin
  for i:= 0 to CCOL do
   for j:= 0 to CROW do
    ShowCard[i][j]:= 1;
  AllCards:= True;
  Play:= True;
  DrawGrid1.Repaint;
end;

procedure New1Click(Sender: TObject);
var i,j,k,num,maxc,r: Integer;
    CanProceed: Boolean;
    a: array [1..MAXFOUND] of Integer;
    c,d: array [1..MAXMEM] of Integer;
begin
  Seconds:= 0;
  Shots:= 0;
  Founds:= 0;
  Score:= 0;
  {TimeLabel.Caption:= 'Seconds: 0';
   ScoreLabel.Caption:= 'Score: 0';}
  ShotsLbl.Caption:= 'Total Hits: 0';
  FirstShot:= True;
  AllCards:= False;
  Play:= True;
  for i:= 0 to CCOL do
  for j:= 0 to CROW do begin
    Display[i][j]:= 1;
    ShowCard[i][j]:= 0;
  end;
  DrawGrid1.Repaint;
  //creation of array of cards:
  //step 1 - random selection of 25 cards from the total
  for j:= 1 to MAXFOUND do begin
    repeat
      num:= Random(TotalPictures)+1;
      CanProceed:= True;
      for i:= 1 to j do
        if a[i]= num then begin
          CanProceed:= False;
          Break; //exit the loop
        end;
    until CanProceed;
   a[j]:= num;
  end;
  //step 2 - creation of a 40 cards array
  for i:= 1 to MAXFOUND do begin
    c[i]:= a[i];
    c[i+MAXFOUND]:= a[i];
  end;
  // step 3 - random sort of the array
  maxc:= MAXMEM;
  for i:= 1 to MAXMEM do begin
    r:= random(maxc)+1;
    d[i]:= c[r];
    for k:= r to (maxc-1)  // moving back c[] elements
      do c[k]:= c[k+1];
    Dec(maxc);
  end;
  // step 4 - creation of a two-dimension array (Map)
  // d[k] has each number from two same number pair
  k:= 1;
  for i:= 0 to CCOL do
    for j:= 0 to CROW do begin
      Map[i][j]:= d[k];
      write(inttostr(d[k])+' ')
      Inc(k);
    end;
end;


procedure DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Col, Row: Integer;
begin
  DrawGrid1.MouseToCell(X, Y, Col, Row);
  // if left button is pressed on an active card
  if (Button = mbLeft) and (Display[Col][Row] = 1) and Play then begin
    ShowCard[Col][Row]:= 1;
    // second shot
    if (not FirstShot) and ((Col<>Col1) or (Row<>Row1))then begin
      Play:= False;
      Row2:= Row;
      Col2:= Col;
      FirstShot:= True;
      // same cards
      if Map[Col][Row] = FSValue then begin
        Inc(Founds);
        // end of game
        if Founds = MAXFOUND then begin
          Inc(Shots);
          ShotsLbl.Caption:= 'Total hits: '+IntToStr(Shots);
          PlaySound(ExePath+RESPATH+'bonus.wav',0,1);
          ShowMessage('End of mgame!'+#13+'Score: '+IntToStr(Shots));
          // statistics
          Inc(StGames);
          Play:= true;
          StScore:= StScore+Score;
          StShots:= StShots+Shots;
          Display[Col1][Row1]:= 0;
          Display[Col2][Row2]:= 0;
        end
        Dec(Turn);
       PlaySound(ExePath+RESPATH+'tick.wav',0,1);
      end;
    end
    // first shot
    else begin
    // fsvalue to check a hit
      FSValue:= Map[Col][Row];
      Col1:= Col;
      Row1:= Row;
      FirstShot:= False;
    end;
  end
  // if right button is pressed after 2nd shot
  else if (Button=mbRight) and FirstShot and (not Play) and not AllCards then begin
    Inc(Shots);
    Play:= true;
    ShotsLbl.Caption:= 'Total hits: '+IntToStr(Shots);
    //test of all cards
    ShowCard[Col1][Row1]:= 0;
    ShowCard[Col2][Row2]:= 0;
    // when hit then dont show the two cards
    if Map[Col1][Row1] = Map[Col2][Row2] then begin
      Display[Col1][Row1]:= 0;
      Display[Col2][Row2]:= 0;
    end;
  end;
  DrawGrid1.Repaint;
end;


procedure DrawGrid1DrawCell(Sender: TObject; Col, Row: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  // drawing the correct card...
  if Display[Col][Row] = 1 then begin
    if ShowCard[Col][Row] = 1 then begin
        Imagefile:= ('bmp' + IntToStr(Map[Col][Row])+'.bmp');
      bmp.loadfromFile(ExePath+RESPATH+Imagefile)
    end else
     Bmp.loadfromFile(ExePath+RESPATH+DECK)
  end
  //...or no card.
  else 
    Bmp.loadfromFile(ExePath+RESPATH+EMPTYCARD)
  DrawGrid1.Canvas.Draw(Rect.Left, Rect.Top, Bmp);
end;


procedure FormClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
begin
  Bmp.Free;
  DrawGrid1.Free;
  with MIni do begin
    WriteString('Stat', 'StGames', IntToStr(StGames));
    WriteString('Stat', 'StShots', IntToStr(StShots));
    WriteString('Stat', 'StSeconds', IntToStr(StSeconds));
    WriteString('Stat', 'StScore', IntToStr(StScore));
    WriteString('Deck','Current', DeckColor);
    for i:= 1 to 5 do begin
      WriteString('Best players','TopName'+IntToStr(i),TopName[i]);
      WriteString('Best players','TopScore'+IntToStr(i),TopScore[i]);
      WriteString('Best players','TopSeconds'+IntToStr(i),TopSeconds[i]);
      WriteString('Best players','TopShots'+IntToStr(i),TopShots[i]);
    end;
    WriteString('Best max players','Wow',Wow);
    Free;
  end;
end;


procedure FormCreate(Sender: TObject);
var i: integer;
    file_path: string;
begin
  // INI file
  //GetMem(WinDir, 144);
  //GetWindowsDirectory(WinDir, 144);
  //StrCat(WinDir, '\Memory.ini');
  if not FileExists(FILE_NAME) then begin
    AssignFileWrite(memo2.text, FILE_NAME);
  end;
  file_path:= extractFilePath(application.ExeName) +FILE_NAME;
  MIni:= TIniFile.Create(file_path);
  with MIni do begin
    // statistics vars
    StGames:= StrToInt(ReadString('Stat','StGames','0'));
    StScore:= StrToInt(ReadString('Stat','StScore','0'));
    StShots:= StrToInt(ReadString('Stat','StShots','0'));
    StSeconds:= StrToInt(ReadString('Stat','StSeconds','0'));
    DeckColor:= ReadString('Deck','Current','Blue');
    for i:= 1 to 5 do begin
      TopName[i]:= ReadString('Best players','TopName'+IntToStr(i),'Noname');
      TopScore[i]:= ReadString('Best players','TopScore'+IntToStr(i),'0');
      TopSeconds[i]:= ReadString('Best players','TopSeconds'+IntToStr(i),'0');
      TopShots[i]:= ReadString('Best players','TopShots'+IntToStr(i),'0');
    end;
    Wow:= ReadString('Best players','Wow','I like Super Memory!');
  end;
  //FreeMem(WinDir, 144);
  //startup initializations
  Randomize;
  Bmp:= TBitmap.Create;
  mForm:= TForm.create(self);
  shotsLbl:= TLabel.create(mForm);
  with mForm do begin
    FormStyle:= fsStayOnTop;
    Position:= poScreenCenter;
    color:= clred;
    Caption:= 'MemoryMax in maXbox3: open left, close right mouse click';
    Width:= 900;
    Height:= 650;
    BorderStyle:= bsDialog;
    onClose:= @FormClose;
    Show
  end;
  with shotsLbl do begin
    parent:= mForm;
    setbounds(30,600,180,20);
    font.size:= 12;
    font.color:= clyellow;
    caption:= 'hits:';
  end  
  drawGrid1:= TDrawGrid.Create(self);
  drawGrid1.parent:= mForm;
  with drawGrid1 do begin
    defaultcolwidth:= 104;
    defaultrowheight:= 104;
    height:= 560;
    width:= 900;       //1094
    colcount:= CCOL+1;  //buggg solved!!!
    rowcount:= CROW+8;
    top:= 20;
    borderStyle:= bsNone;
    GridLineWidth:= 8;
    scrollbars:= ssnone;
    ondrawcell:= @DrawGrid1DrawCell;
    onMouseUp:= @DrawGrid1MouseUp;
  end;
  New1Click(Self);
end;

begin //main
 FormCreate(self)
 //ShowAllCards1Click(self)
End.
----------------------------------------------------

new testbox in 3.1:

    GetWindowsDirectory(WinDir, 144);
    newtemplate.txt  --> ask if file exists !
    and save as...
    type in assignfileread

  function traingifSetup()
{
  createScene("SC01");
  createConsist("CST1", "I_FS_VT_ALn460-448a.gif");
  placeStaticStretch("up_bl.gif", 15, Top, 1);
  createTrack("TRK1", 15, 3);
  createTrain("TRN1", "CST1", Left, 20, 10);

  createScene("SC03");
  createConsist("CST3", "I_FS_VT_TEE442-60-448r.gif");
  placeStaticStretch("up_bl.gif", 15, Top, 1);
  placeStaticRepeat("FS_Cat3F.gif", 1, Bottom, 4);
  createTrack("TRK3", 15, 3);
  createTrain("TRN3", "CST3", Left, 40, 10);

  createScene("SC04");
  createConsist("CST4", "I_FS_VT_TEE442-448b+ETR220.gif");
  placeStaticStretch("up_bl.gif", 15, Top, 1);
  placeStaticRepeat("FS_Cat2N.gif", 1, Bottom, 4);
  createTrack("TRK4", 15, 3);
  createTrain("TRN4", "CST4", Right, 50, 10);

  createScene("SC06");
  createConsist("CST6", "I_FS_VT_TEE442-448+2xALn990.gif");
  placeStaticStretch("up_bl.gif", 15, Top, 1);
  createTrack("TRK6", 15, 3);
  createTrain("TRN6", "CST6", Left, 20, 10);
}




