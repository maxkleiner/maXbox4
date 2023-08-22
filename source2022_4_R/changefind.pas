{//changefind
//tshChangefind: TTabSheet, pageindex=5, event= onShow
//******************************************************************************
// Zweck : Schreibkontrolle auf HD
// ChangeFind zeigt alle Dateien mit heutigem ' +
// Systemdatum einem Laufwerk an. Somit' +
// haben Sie jederzeit Kontrolle ueber die taeglichen' +
// Aktivitaeten auf der HD.
//
//******************************************************************************
var drive: string[20];
    mycf: TChangeFinder;
begin
  screen.cursor:=crHourglass;
    drive:= dcbHD.Drive;
    drive:= drive + ':';
    mycf:= TChangeFinder.prepList_and_Date(frmMain.livchangefind);
    mycf.SearchDirectories(drive + '\','*.*');
    mycf.Free;
    screen.cursor:=crDefault;
end; }

unit changefind;

{dieses tool scant festplatten nach dateien mit aktuellem datum}
{autor max kleiner jan.95}
// 23.03.2005 anpassungen fuer securecenter
// rekursion gesichert , decode of date an ntengine angepasst
// drivename we get from dcbHD.drive
// independent from main form
// refactor procedures on only 2 paras to get register code
// V 1.6 30.03.05 Max Kleiner, LOCs = 250
// V 1.7 20.04.05 hidden directories found and class design
// V 1.8 09.10.05 show timestamp on list, reconfig tlistview(columns)
// V 1.9 02.02.2014 publish counter in list , add destructor
// no CLX checks files with last time, LOCs = 188

interface

uses windows, sysutils, StdCtrls;


type

TChangeFinder = class
private
  nYear,
  nMonth,
  nDay,
  fcounter: word;
  dflistView: TListBox;
protected
  //procedure ShowFiles(Showpath: string; sr: TSearchRec);
public
  constructor Create_prepList_and_Date(alistView: TListBox);
  procedure SearchDirectories(path: string; const fname: string);
  procedure ShowFiles(Showpath: string; sr: TSearchRec);
 // destructor Destroy; override;

end;

//var : TChangeFinder

implementation


constructor TChangeFinder.Create_prepList_and_Date(alistView: TListBox);
begin
  //GetDate(Year, Month, Day, DayofWeek);
  //now date is to slow
  //inherited Create;
  dflistView:= alistView;
  //dflistView.scrollbars:= ssBoth;
  decodedate(date, nyear, nmonth, nday);
    dflistView.items.insert(0, format('%-80s %10s -%10s',
       ['---Filename:', '---Size:', '---Time:']));
     fcounter:= 0;
  {with alistView.Items do begin
    BeginUpdate;
    Clear;
    EndUpdate;
  end;}
end;

PROCEDURE TChangeFinder.ShowFiles(Showpath: STRING; sr: TSearchRec);
VAR
  arcdisp: STRING[9];
  DateRec: TDateTime;
  lenStr,
  insertStr,
  fname,
  fext, outPutStr: string;
  len      : BYTE;
  AYear, AMonth, ADay: Word;
  aHour, aMin, aSec, aMsec: word;

BEGIN
  IF sr.Attr IN [$8..$F, $28..$2F] THEN BEGIN
    IF Pos('.', sr.Name) > 0 THEN
      Delete(sr.Name, Pos('.', sr.Name), 1);
  END;
  IF (Pos('.', sr.Name) > 0) AND (Length(sr.Name) > 0) THEN begin
    fname:= Copy(sr.Name, 1, Pos('.', sr.Name) - 1);
    fext:= sr.Name;
    Delete(fext, 1, Pos('.', fext));
  END ELSE BEGIN
    fname:= sr.Name;
    fext:= '  ';
  END;
  arcdisp:= '    ';
{$WARN SYMBOL_PLATFORM OFF}
  IF sr.Attr AND faArchive  = faArchive  THEN arcdisp[1] := 'A';
  IF sr.Attr AND faReadOnly = faReadOnly THEN arcdisp[2] := 'R';
  IF sr.Attr AND faHidden   = faHidden   THEN arcdisp[3] := 'H';
  IF sr.Attr AND faSysFile  = faSysFile  THEN arcdisp[4] := 'S';
{$WARN SYMBOL_PLATFORM ON}
  //8..15, 40..47
  IF NOT (sr.Attr IN [$8..$F, $28..$2F]) THEN BEGIN
    Str(sr.Size, lenStr);
    IF Length(lenStr) > 3 THEN BEGIN
      insertStr:= '.';
      len:= Length(lenStr) - 2;
      Insert(insertStr, lenStr, len);
      IF Length(lenStr) > 7 THEN BEGIN
        len:= Length(lenStr) - 6;
        Insert(insertStr, lenStr, len);
      END;
    END;
  END;
  IF NOT (sr.Attr IN [$8..$F, $28..$2F]) THEN BEGIN
   //check the system now date
    dateRec:= FileDatetoDateTime(sr.Time);
    DecodeDate(dateRec, AYear, AMonth, ADay);
    DecodeTime(dateRec, aHour, aMin, aSec, aMsec); //new 1.8
    //daterec:= now;  //testroutine
    IF (ADay = nDay) AND (AYear = nYear) AND (AMonth = nMonth) THEN BEGIN
        IF Showpath[Length(Showpath)] = '\' THEN
        Delete(Showpath, Length(Showpath), 1);
        outPutStr:= Showpath + '\' + fname + '.' + fext;
        inc(fcounter);
        //dflistview.Columns:= 3;
        //dflistView.TabWith:= 50;
        //dflistView.Items.add(outPutStr +^I+ lenStr);  // ^I is the Tab char
        dflistView.Items.Insert(0, format('%d:  %-80s %10s -%5s',
           [fcounter, outPutStr, lenStr, inttoStr(aHour)+':'+inttoStr(aMin)]));
     END;
  END;
END;


{destructor TChangeFinder.Destroy;
begin
  dflistView.Free;
  inherited;
end; }

PROCEDURE TChangeFinder.SearchDirectories(path: string; const fname: STRING);
VAR
  sRecord : TSearchRec;
  Showpath: STRING;
BEGIN
  (* Suche nach Dateien: *)
  IF Length(path) > 0 THEN
    IF path[Length(path)] <> '\' THEN
      path := path + '\';
  SRecord.Name := '';
  if FindFirst(path + fname, faAnyfile MOD faDirectory, SRecord) = 0 then
  begin
    Showpath:= '        .   ';
    IF SRecord.Name <> '' THEN BEGIN
      IF Length(path)  > 3 THEN
      Showpath:= Copy(path, 1, Length(path) - 1)
     ELSE Showpath:= path;
    END;
   try
    repeat
     //0..14, 32..46
      IF SRecord.Attr IN [$0..$E, $20..$2E] THEN
      ShowFiles(Showpath,SRecord);
    until FindNext(sRecord) <> 0;
   finally
      FindClose(sRecord);
   end;
  end;
  (* Suche nach Verzeichnissen: *)
  // hidden dir available with fahidden
  if FindFirst(path + '*.*', faDirectory or faHidden, SRecord) = 0 then begin
    try
    repeat
        IF (SRecord.Attr AND faDirectory <> 0) AND
       (SRecord.Name[1] <> '.') THEN
      //recursion to get subdirectories
      SearchDirectories(path + SRecord.Name, fname);
    until FindNext(sRecord) <> 0;
    finally
      FindClose(sRecord);
    end;
  end;
end;

END.
