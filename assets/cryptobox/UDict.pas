unit UDict;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A dictionary class  -

 Leading characters of each word that match preceding words are replaced by a
 byte containing the count of characters that match, leading byte also has flags
 indicating abbrevations and foreign words.

 A letterindex pointing to start of each letter in word list is maintained.
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
   Controls, Forms, Dialogs;

const
    dichighletter='z';
type

  TDicForm = class(TForm)
    OpenDialog1: TOpenDialog;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

 TDic=class

    {Initial character of each word is formatted as:
      Bit
       0 - unused - must be 1 in file indicating that this is a compressed dictionary
       1 - word is foreign
       2 - word is abbreviation
       3 - word is captialized (proper noun)
       4-7 count of letters matching previous word in list
    }
    protected
    Words:TStringList;
    ExpandedList:TStringList;  {Used for Getwordbynumber}

    {range fields - set by setrange method}
    startletter,endletter:char;
    startlength,endlength:byte;
    {used by saverange and restorerange methods}
    savestartletter,saveendletter:char;
    savestartlength,saveendlength:byte;

    {current status fields}
    currletter:char;
    currlength:byte;
    currentWordIndex:integer;
    Currword, prevword:string;

        Letterindex:array ['a'..succ(dichighletter)] of integer;
        AbbrevCount,ForeignCount,CapsCount,TotalCount:integer;
        DicDirty:boolean;

    {prechecked ==> no need to check for validword in Lookup or AddWord}
    Prechecked:boolean;
    IndexDirty:boolean;

    public

    IniPathName:string;  {path to dic.inifile}
    Maxwordlength:integer;
    DicLoaded:boolean;
    Dicname:string;
    DefaultDic,SmallDic,MediumDic,LargeDic:String;

    constructor Create(Precheckedflag:boolean); overload;
    constructor Create(Newpath:string; Precheckedflag:boolean); overload;

    procedure LoadDicFromFile(filename:string);
    procedure LoadDefaultDic;
    procedure LoadSmallDic;
    procedure LoadMediumDic;
    procedure LoadLargeDic;

    procedure SaveDicToFile(filename:string);
    procedure SaveDicToTextFile(filename:string); {save uncompressed}

    procedure Setrange(const letter1:char;length1:byte;const letter2:char;length2:byte);
    procedure saverange;
    procedure restorerange;

    function Lookup(s:string; var abbrev,foreign,caps:boolean):boolean;
    function GetnextWord(var word:string;var abbrev,foreign,caps:boolean):boolean; overload;
    Function GetnextWord(var word:string;var wordnbr:integer; var abbrev,foreign,caps:boolean):boolean; overload;
    function GetWordByNumber(n:integer; var word:string):boolean;
    function IsValidword(var s:string):boolean;
    function AddWord(s:String;abbrev,foreign,caps:boolean):boolean;
    function RemoveWord(s:String):boolean;
    procedure Rebuildindex; {after insertions or deletions}
    procedure reSortrange;   {fixup missorted dictionary}
    function  GetwordCount:integer;
    function checksave:integer;
    function getDicSize:integer;

    {procedure Findwords(scrambled:string; NbrToFind:byte; List:Tstrings);}
  End;


var
  DicForm: TDicForm;
  PubDic:TDic;
  PrivDic:TDic;

implementation

{$R *.DFM}

Uses Inifiles;

 procedure createdicform;
 begin
   dicform:=tdicform.create(application.mainform);
 end;

 {**************** Local functions ********************}
 Function min(a,b:integer):integer; Begin If a<b then result:=a else result:=b; End;

  Function CompressWord(prev,word:String; abbrev,foreign,caps:boolean):String;
   {replace initial letters of word that match prev word with a count
    field}
       var
         len,prevlen,i,letterstocopy:integer;
         mask:byte;
       Begin
         len:=length(word);
         prevlen:=length(prev);
         i:=1;
         while (i<=min(len,prevlen)) and (word[i]=prev[i]) and (i<16) do inc(i);
         letterstocopy:=i-1;
         result:=' '+copy(word,i,len-i+1);
         mask:=$80;
         If abbrev then mask:=mask or $40;
         If foreign then mask:=mask or $20;
         If caps then mask:=mask or $10;
         result[1]:=char(letterstocopy or mask);
       End;

    Function ExpandWord(prev,Compressedword:string;Var abbrev,foreign,caps:boolean):String;
    {expand a compressed word  to full length}
    Begin
      result:=copy(prev,1,ord(Compressedword[1]) and $0F)
            + copy(compressedword,2,length(compressedword)-1);
      if (byte(compressedword[1]) and $40)>0 then abbrev:=true else abbrev:=false;
      if (byte(compressedword[1]) and $20)>0 then foreign:=true else foreign:=false;
      if (byte(compressedword[1]) and $10)>0 then caps:=true else caps:=false;
    End;

 {*************** TDic.Create ********************}
 Constructor TDic.Create(precheckedflag:boolean);
  {create dictionary object}
 var
   i:char;
   //path:string;
   ini:TInifile;
 Begin
  inherited create;
  IniPathName:=extractfilepath(application.exename);
  prechecked:=precheckedflag;
  words:=TStringlist.create;
  ExpandedList:=TstringList.create;
  words.sorted:=false;
  words.duplicates:=dupIgnore;
  For i:='a' to high(letterindex){dichighletter}{'z'} do letterindex[i]:=0;
  CurrentWordIndex:=-1;
  IndexDirty:=true;
  DicDirty:=false;
  MaxWordLength:=0;
  Dicloaded:=false;
  {fill in dictionary names that exist}
  //path:=extractfilepath(application.exename);
  ini:=TIniFile.create(IniPathname+'Dic.ini');
  SmallDic:=ini.ReadString('Files','Small Dictionary',InipathName + 'Small.Dic');
  if not fileexists(smalldic) then smalldic:='';
  MediumDic:=ini.ReadString('Files','Medium Dictionary',InipathName + 'General.Dic');
  if not fileexists(Mediumdic) then Mediumdic:='';
  LargeDic:=ini.ReadString('Files','Large Dictionary',IniPathName + 'Full.Dic');
  if not fileexists(Largedic) then Largedic:='';
  ini.free;
 End;

 {*************** TDic.Create ********************}
 Constructor TDic.Create(newpath:string; precheckedflag:boolean); 
 {create dictionary object}
 var
   i:char;
   //path:string;
   ini:TInifile;
 Begin
  inherited create;
  IniPathName:=newpath;
  prechecked:=precheckedflag;
  words:=TStringlist.create;
  ExpandedList:=TstringList.create;
  words.sorted:=false;
  words.duplicates:=dupIgnore;
  For i:='a' to high(letterindex){dichighletter}{'z'} do letterindex[i]:=0;
  CurrentWordIndex:=-1;
  IndexDirty:=true;
  DicDirty:=false;
  MaxWordLength:=0;
  Dicloaded:=false;
  {fill in dictionary names that exist}
  //path:=extractfilepath(application.exename);
  ini:=TIniFile.create(IniPathName+'Dic.ini');
  SmallDic:=ini.ReadString('Files','Small Dictionary',IniPathName+ 'Small.Dic');
  if not fileexists(smalldic) then smalldic:='';
  MediumDic:=ini.ReadString('Files','Medium Dictionary', IniPathName+ 'General.Dic');
  if not fileexists(Mediumdic) then Mediumdic:='';
  LargeDic:=ini.ReadString('Files','Large Dictionary',IniPathName + 'Full.Dic');
  if not fileexists(Largedic) then Largedic:='';
  ini.free;
 End;


 {******************* TDic.LoadDicFromFile *************}
 Procedure TDic.LoadDicFromFile(filename:string);
 {load a dictionary}

 function getword(var w:string):string; overload;
    var
      i:integer;
    Begin
      i:=1;
      result:='';
      If length(w)=0 then exit;
      if w[length(w)]<>',' then w:=w+','; {make sure we have a stopper}
      {get to first letter}
      while (i<=length(w)) and  (not (w[i] in ['a'..dichighletter{'z'}])) do inc(i);
      if w[i] in ['a'..dichighletter{'z'}] then
      begin
        If i>1 then w:=copy(w,i,length(w)-i+1);
        i:=1;
        while (i<=length(w)) and  ((w[i] in ['a'..dichighletter{'z'}])) do inc(i);
        result:=copy(w,1,i-1);
        system.delete(w,1,i);
      End
      else w:='';
    End;

 function getword(const ww:string; var startat:integer):string; overload;
    var
      i:integer;
      w:string;
    Begin
      w:=ww;
      result:='';
      If length(w)=0 then exit;
      if startat=0 then exit;
      i:=startat;
      if w[length(w)]<>',' then w:=w+','; {make sure we have a stopper}
      {get to first letter}
      while (i<=length(w)) and  (not (w[i] in ['a'..dichighletter{'z'}])) do inc(i);
      startat:=i;
      if w[i] in ['a'..dichighletter{'z'}] then
      begin
        while (i<=length(w)) and  ((w[i] in ['a'..dichighletter{'z'}])) do inc(i);
        result:=copy(w,startat,i-startat);
        startat:=i+1;
      End
      else
      begin
        w:='';
        startat:=0;
      end;  
      
    End;

 var
   line,prevword,dicword,w:string;
   f:textfile;
   compressed:boolean;
   mr,i:integer;
   templist:TStringlist;
   startat:integer;
 Begin
   mr:=mrYes;
   If dicloaded and dicdirty then mr:=checksave;
   if not (mr=mrcancel) then
   begin
     if words.count>0 then words.clear;
     if length(filename)=0 then
     Begin
       if dicform=nil then createdicform; 
       dicform.opendialog1.execute;
       filename:=dicform.opendialog1.filename;
     End;
     If fileexists(filename) then
     Begin
       assignfile(f,filename);
       reset(f);
       readln(f,line);
       {high order bit of 1st char ==> dictionary is compressed}
       if (ord(line[1])and $80)>0 then compressed:=true
           else compressed:=false;
       closefile(f);
       screen.cursor:=crHourglass;
       If not compressed then
       Begin
         {load a text file and make a dictionary }
         reset(f);
         {first read the file assuming that it is a normal text file -
          put words into a wordlist, sort it, eliminating duplicates,
          then make dic from templist words}
          templist:=TstringList.create;
          while not eof(f) do
          begin
            readln(f,line);
            line:=lowercase(line);
            startat:=1;
            while (startat>0) and (startat<length(line)) {length(line)>0} do
            begin
              w:=getword(line,startat);
              if length(w)>0 then templist.add(w);
            end;
          end;
          closefile(f);
          templist.duplicates:=dupignore;
          templist.sort;
          prevword:='';
          for i:= 0 to templist.count-1 do
          Begin
           line:=templist[i];
           dicword:=CompressWord(prevword,line,false,false,false);
           If length(dicword)>1 then words.add(dicword);
           prevword:=line;
         End;
         templist.free;
       End
       else Words.loadfromfile(filename); {load normal compreesed dictionary}
      { for i:=7247 downto 5872 do words.delete(i); fixup broken dictionary}
       RebuildIndex;
       dicloaded:=true;
       dicdirty:=false;
       Dicname:=filename;
       screen.cursor:=crDefault;
     End
     else showmessage('Dictionary file '+filename+' not found');
   end;
 end;

 {**************** TDic.LoadDefaultDic ***********************}
  Procedure TDic.LoadDefaultDic;
 {Load a default dictionary}
 Var
   ini:TIniFile;
   //path:string;
 Begin
   //path:=extractfilepath(application.exename);
   ini:=TIniFile.create(IniPathName+'Dic.ini');
   DefaultDic:=ini.ReadString('Files','Default Dictionary',IniPathName + 'Full.Dic');
   If not fileexists(DefaultDic) then
   begin
     if dicform=nil then createdicform;
     with dicForm.opendialog1 do
     Begin
       initialdir:=Inipathname;
       If execute then
       Begin
          DefaultDic:=Dicform.Opendialog1.filename;
          Ini.WriteString('Files','Default Dictionary',DefaultDic);
       End;
     End;
   end;
   LoadDicFromFile(DefaultDic);
   ini.free;
 End;

 {**************** TDic.LoadSmallDic ***********************}
  Procedure TDic.LoadSmallDic;
 {Load a small dictionary}
 Var
   ini:TIniFile;
   //path:string;
 Begin
   //path:=extractfilepath(application.exename);
   ini:=TIniFile.create(IniPathName+'Dic.ini');
   SmallDic:=ini.ReadString('Files','Small Dictionary',IniPathName + 'Small.Dic');
   If not fileexists(SmallDic) then
   begin
     if dicform=nil then createdicform;
     with dicForm.opendialog1 do
     Begin
       title:='Select Small dictionary';
       initialdir:=extractfilepath(application.exename);
       If execute then
       Begin
         SmallDic:=Dicform.Opendialog1.filename;
         Ini.WriteString('Files','Small Dictionary',SmallDic);
       End;
     End;
   end;
   LoadDicFromFile(SmallDic);
   ini.free;
 End;

  {**************** TDic.LoadMediumDic ***********************}
  Procedure TDic.LoadMediumDic;
 {Load a Medium dictionary}
 Var
   ini:TIniFile;
   //path:string;
 Begin
   //path:=extractfilepath(application.exename);
   ini:=TIniFile.create(IniPathName+'Dic.ini');
   MediumDic:=ini.ReadString('Files','Medium Dictionary',IniPathname + 'General.Dic');
   If not fileexists(MediumDic) then
   begin
     if dicform=nil then createdicform;
     with dicForm.opendialog1 do
     Begin
       title:='Select Medium dictionary';
       initialdir:=extractfilepath(application.exename);
       If execute then
       Begin
          MediumDic:=Dicform.Opendialog1.filename;
          Ini.WriteString('Files','Medium Dictionary',MediumDic);
       End;
     End;
   end;
   LoadDicFromFile(MediumDic);
   ini.free;
 End;

  {**************** TDic.LoadLargeDic ***********************}
  Procedure TDic.LoadLargeDic;
 {Load a large dictionary}
 Var
   ini:TIniFile;
   //path:string;
 Begin
   //path:=extractfilepath(application.exename);
   ini:=TIniFile.create(IniPathname+'Dic.ini');
   LargeDic:=ini.ReadString('Files','Large Dictionary',IniPathname + 'Full.Dic');
   If not fileexists(LargeDic) then
   begin
     if dicform=nil then createdicform;
     with dicForm.opendialog1 do
     Begin
       title:='Select Large dictionary';
       initialdir:=extractfilepath(application.exename);
       If execute then
       Begin
          LargeDic:=Dicform.Opendialog1.filename;
          Ini.WriteString('Files','Large Dictionary',LargeDic);
       End;
     End;
   end;  
   LoadDicFromFile(LargeDic);
   ini.free;
 End;

 {******************** TDic.CheckSave *******************}
 function TDic.Checksave:integer;
 {Ask user if changed dictionary is to be saved}
   Begin
     result:=messagedlg('Save '+dicname+'?',mtconfirmation,mbyesnocancel,0);
     if result=mryes then SaveDicTofile(dicname);
   End;


function TDic.GetDicSize:integer;
begin
  result:=words.count;
end;  


 {******************** TDic.SaveDicToFile *******************}
 Procedure TDic.SaveDicToFile(filename:string);
 var
   f:text;
   w:string;
   a,fr,caps:boolean;
 Begin
   If not fileexists(filename) or ( fileexists(Filename)  and
     (MessageDlg('Overwrite '+filename +'?',mtconfirmation,[mbYes, mbNo],0)=
       mrYes)) then
   begin
     if lowercase(extractfileext(filename))='.txt' then
     begin
       assignfile(f,filename);
       rewrite(f);
       setrange('a',1,dichighletter{'z'},maxwordlength);
       while getnextword(w,a,fr,caps) do writeln(f,w);
       closefile(f);
     end
     else words.Savetofile(filename);
     dicdirty:=false;
   end;
 End;

 {******************* TDic.SaveDicToTextFile *****************}
 Procedure TDic.SaveDicToTextFile(filename:string);
 {save dictionary}
 var
   textname:string;
   f:textfile;
   w:string;
   a,fo,caps,useprops:boolean;
 Begin
   textname:=changefileext(filename,'.txt');
   If not fileexists(textname) or ( fileexists(textname)  and
     (MessageDlg('Overwrite '+textname +'?',mtconfirmation,[mbYes, mbNo],0)=
       mrYes)) then
   Begin
     assignfile(f,textname);
     rewrite(f);
     setrange('a',1,dichighletter{'z'},maxwordlength);
     If messagedlg('Include properties (abbrev,foreign,caps) in output?',
                      mtconfirmation,[mbyes,mbno],0)=mryes
     then useprops:=true
     else useprops:=false;

     while getnextword(w,a,fo,caps) do
     Begin
       if useprops then
       begin
         if a then w:=w+',A';
         if fo then w:=w+',F';
         if caps then
         Begin
          w[1]:=upcase(w[1]);
          w:=w+',C';
         end
       end;
       writeln(f,w);
     End;
     closefile(f);
   End;
 End;

{******************* TDic.Rebuildindex ****************}
Procedure TDic.Rebuildindex;
{Build the index which contains a cumulative count of words beginning with
 each letter - called after each insertion or deletion}

var
  a,prevletter,letter:char;
  letterstocopy, n:byte;
  i,wordlength:integer;
Begin
  for a:='a' to high(letterindex) do Letterindex[a]:=-1;
  prevletter:=pred('a');
  letter:='a';
  maxwordlength:=0;
  abbrevcount:=0;
  foreigncount:=0;
  capscount:=0;
  totalcount:=words.count;
  for i:=0 to words.count-1 do
  Begin
    n:=ord(words[i][1]);
    if n and $40 >0 then inc(abbrevcount);
    if n and $20 >0 then inc(foreigncount);
    if n and $10 >0 then inc(capscount);
    letterstocopy:=n and $0F;
    wordlength:=letterstocopy+length(words.strings[i])-1;
    if wordlength>maxwordlength then maxwordlength:=wordlength;

    if letterstocopy=0 then letter:=words[i][2];  {new letter}
    if letter <> prevletter then
    Begin
      for a := succ(prevletter) to letter do letterindex[a]:=i;
      prevletter:=letter;
    End;
  End;
  if letter<>dichighletter{'z'} {there were no words with last letter}
  then
  begin  {set all starting letter to highest index}
    for a:=letter to high(letterindex) do letterindex[a]:=words.count-1
  end
  else letterindex[high(letterindex)]:=words.count;
  indexdirty:=false;
End;


{******************** TDic.reSortRange **********************}
procedure TDic.reSortRange;
{fixup mis-sorted dictionary by deleting and inserting words that are
 out of sequence}
var
  w1,w2:string;
  a,f,c:boolean;
  insequence:boolean;
begin
    {find insert point}
    saverange;
    repeat
      insequence:=true;
      setrange(startletter,1,endletter,maxwordlength);
      getnextword(w1,a,f,c);
      while getnextword(w2,a,f,c) and insequence do
      begin
        If (w2<>'') and (w2<=w1) then
        begin
        {oh-oh,  w2 <=w1}
         words.delete(currentwordindex);
         addword(w2,a,f,c);
         insequence:=false;
        end;
        w1:=w2;
      end;
    until insequence;
    indexdirty:=true;
    DicDirty:=true;
    restorerange;
  End;

{***************** GetNextWord **********************}
{Warning!  the values for CurrentWordindex Currword, and PrevWord set
 by GetNextWord are used by other routines and shouldn't be changed
}
Function TDic.GetnextWord(var word:string;var abbrev,foreign,caps:boolean):boolean;
{Get the next word from dictionary within range}
Begin
  result:=false;
  repeat
    prevword:=currword;
    currword:='';
    inc(currentWordIndex);
    if (endletter<dichighletter) then
    begin
      {Check for end of this range}
      if (currentwordindex>=Letterindex[succ(endletter)])
      then exit;
    end
    else if (currentwordindex>=words.count) then exit;

    if currentwordindex>words.count-1 then exit;
    currword:=words[CurrentWordIndex];
    currword:=expandword(prevword,currword,abbrev,foreign,caps);
    If currword[1]>endletter then exit;
    If (startlength<=length(currword)) and (length(currword)<=endlength)
    then result:=true;
  until result=true;
  word:=currword;
End;



{***************** GetNextWord **********************}
{Warning!  the values for CurrentWordindex Currword, and PrevWord set
 by GetNextWord are used by other routines and shouldn't be changed
}
Function TDic.GetnextWord(var word:string;var wordnbr:integer; var abbrev,foreign,caps:boolean):boolean;
{Get the next word from dictionary within range - overloaded version returns word number}
Begin
  result:=false;
  repeat
    prevword:=currword;
    currword:='';
    inc(currentWordIndex);

    if (endletter<>dichighletter) and (currentwordindex>=Letterindex[succ(endletter)]) then exit;
    if currentwordindex>words.count-1 then exit;
    currword:=words[CurrentWordIndex];
    currword:=expandword(prevword,currword,abbrev,foreign,caps);
    If currword[1]>endletter then exit;
    If (startlength<=length(currword)) and (length(currword)<=endlength)
    then
    begin
      result:=true;
      wordnbr:=currentwordindex;
      word:=currword;
    end;
  until result=true;
  
End;

{****************** TDic.IsValidword ********************}
Function TDic.Isvalidword(var s:string):boolean;
{return true if the word has valid format - not necessarily in dictionary}
var
  i:integer;
Begin
  s:=ansilowerCase(s);
  result:=false;
  If (length(s)=0) or (length(s)>maxwordlength) then exit;
  for i:=1 to length(s) do if (not (s[i] in ['a'..dichighletter{'z'}])) then exit;
  result:=true;
End;



Function TDic.GetWordByNumber(n:integer; var word:string):boolean;
{retrieve word number N from the expanded word list}
Begin
  If n<ExpandedList.count then
  Begin
    word:=ExpandedList[n];
    result:=true;
  End
  else
  Begin
    word:='';
    result:=false;
  End;
End;

{***************** LookUp *****************}
Function TDic.Lookup(s:string; var abbrev,foreign,caps:boolean):boolean;
{lookup word "s" in the current dictionary}
var
  start:char;
  testword:string;
  belowit:boolean;
  len,origlen:integer;

  Begin
  result:=false;
  s:=lowercase(s);
  if length(s)=0 then exit;
  if prechecked or IsValidword(s) then
  Begin
    start:=s[1];
    len:=length(s);
    saverange;
    setrange(start,len,start,len);
    belowit:=true;
    while  belowit do
    Begin
      if not getnextword(testword,abbrev,foreign,caps)
      then belowit:=false;
      origlen:=length(testword);
      if (testword>=s) then belowit:=false;
    End;
    if (testword=s) and (origlen=len) then result:=true;
    restorerange;
  End;
End;


 procedure TDic.saverange;
   begin
      savestartletter:=startletter;
      saveendletter:=endletter;
      savestartlength:=startlength;
      saveendlength:=endlength;
   end;

 procedure TDic.restorerange;
   begin
      {restore range info}
      startletter:=savestartletter;
      endletter:=saveendletter;
      startlength:=savestartlength;
      endlength:=saveendlength;
    end;

{****************** AddWord *****************}
Function TDic.AddWord(s:String; abbrev,foreign,caps:boolean):boolean;
{Add word s to dictionary}
var
  newword, nextword,w:string;
  a,f,c:boolean;
Begin
  s:=lowercase(s);
  if (not prechecked) and (not IsValidword(s)) then
  Begin
    result:=false;
    exit;
  End;
  If not lookup(s,a,f,c) then
  Begin
    {find insert point}
    saverange;
    setrange(s[1],1,s[1],maxwordlength);
    while getnextword(w,a,f,c) and (w<s) do;
    newword:=Compressword(prevword,s, abbrev,foreign,caps);
    nextword:=expandword(s,words[currentwordindex],a,f,c);
    words.Insert(currentwordindex,newword);
    words[Currentwordindex+1]:=Compressword(s,nextword,a,f,c);
    if length(s)>maxwordlength then maxwordlength:=length(s);
    result:=true;
    indexdirty:=true;
    DicDirty:=true;
    restorerange;
  End
  else result:=false;
end;

{****************** RemoveWord *****************}
Function TDic.RemoveWord(s:String):boolean;
{Remove word s from dictionary}
var
  nextword:string;
  a,f,c:boolean;
Begin
  If not IsValidword(s) then
  Begin
    result:=false;
    exit;
  End;
  result:=true;
  If lookup(s,a,f,c) then
  begin
    nextword:=expandWord(s,words[succ(CurrentWordIndex)],a,f,c);
    words.delete(currentwordindex);
    words[currentwordindex]:=CompressWord(prevword,nextword,a,f,c);
    IndexDirty:=true;
    DicDirty:=true;
  End;
end;



{****************** SetRange ********************}
Procedure TDic.Setrange(const letter1:char;length1:byte;
                        const letter2:char;length2:byte);
{set a range of letters and lengths to search}
var
  s1,s2:string;
Begin
  s1:=ansilowercase(letter1);
  s2:=ansilowercase(letter2);
  if (not (s1[1] in ['a'..dichighletter])) or
     (not (s2[1] in ['a'..dichighletter])) then
  begin
     currentwordindex:=words.count;
     exit;
  end;
  startletter:=letter1;
  endletter:=letter2;
  startlength:=length1;
  endlength:=length2;
  currletter:=startletter;
  currlength:=startlength;
  If indexdirty then Rebuildindex;
  currentWordIndex:=LetterIndex[startletter]-1;
  prevword:='';
  currword:='';
End;

(*
 Procedure TDic.Findwords(scrambled:string; NbrToFind:byte; List:Tstrings);
 {given a scrambled word - find up to the specified # of words from
  dictionary and return them in a list}

 var
   c:TComboSet;
   s:string;
   n,i:integer;
   abbrev,foreign:boolean;
 Begin
   n:=length(scrambled);
   s:=scrambled;
   list.clear;
   If n>0 then
   Begin
     c:=TComboSet.create;
     c.init(n,n,false);
     while c.getnext do
     Begin
       for i:=1 to n do s[i]:=scrambled[c.selected[i]];
       if lookup(s,abbrev,foreign)
       then list.add(s);
     end;
     c.free;
   End;
 End;
 *)


 Function TDic.GetwordCount:integer;
 {retrieve and count all words starting with preset letter and length}
 var
   w:string;
   a,f,c:boolean;
   n:integer;
 Begin
   n:=0;
   ExpandedList.clear;
   while Getnextword(w,a,f,c) do
   begin
     ExpandedList.add(w);
     inc(n);
   end;
   result:=n;
 End;



procedure TDicForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  mr:integer;
begin
  canclose:=true;
  If pubdic.dicloaded and pubdic.dicdirty then
  begin
    mr:=pubdic.checksave;
    if mr=mrcancel then canclose:=false;
  end;
  If canclose and privdic.dicloaded and privdic.dicloaded then
  begin
    mr:=privdic.checksave;
    if mr=mrcancel then canclose:=false;
  end;
end;

Initialization
  PubDic:=TDic.Create(false);
  PrivDic:=TDic.Create(false);

end.




