unit USearchAnagrams;
{Copyright  © 2004,2007 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A class to search the dictionary to find anagrams for a given set of letters.
 "TSearchAnagrams" passes the dictionary words against a set of letters
   retieving by first letter and length.  For each word found, a check is made
   to see if it matches 1-1 with the letters required.
  }
interface

Uses controls, sysutils, classes, forms, UDict;

type

  TTestWords= array ['a'..'z'] of string;
  CharSet=Set of Char;

  TSearchAnagrams=class(tcontrol)
  {a class to search for dictionary entries matching a set of letters}
  private
    LengthFirstLetterSt:Word;
    ValidWordChar  :  CharSet;
    Curword,CapWord,FirstletterSt:string;
    NextsearchPos:word;
    Len,Minlen,MaxLen:word;
    Rest:string;
    function GetNext(Dic:TDic;Var Validword:string):boolean;
  public
    useabbrevs,useforeign,usecaps:boolean;
    tag:integer;
    pubdic, privdic: TDic;
    {find all words between specified lengths contained in letters provided}
    Procedure Init(newletters:string;NewMinLen,NewMaxLen:word;
                    newa,newf,newc:boolean; apubDic:TDic);

    {Given a set of letters representing a word with one letter missing,
     return an array 'a' to 'z' with words filled if that letter plus the
     given letters is a anagram of a valid word.}
     function FindMissingLetter(const s:string):TTestWords;

     {Given a set of letters representing a word with one letter missing,
     return a list of all words which could be formed by adding any letter}
     procedure  Findallwords(const s:string; list:Tstrings);
  end;



  var
    SearchAnagrams2:TSearchAnagrams;



implementation

procedure SortString(var SortSt : String);
 {sort the potential first letters string in ascending sequence}
   var
     InOrder: Boolean;
     I: Integer;
     C: Char;
   begin
     If length(sortst)>0 then
     {exchange sort - swap out-of-order pairs until no more swaps needed}
     repeat
       Inorder := True;
       for I := 1 to Length(SortSt)-1 do
       if Ord(SortSt[I]) > Ord(SortSt[I+1]) then
       begin
         {swap letters I and I+1}
         Inorder := False;
         c:=sortst[i];
         sortst[i]:=sortst[i+1];
         sortst[i+1]:=c;
       end;
     until InOrder;
   end; { procedure SortString }


{********** FindMissingLetter *****************}
{Original version - pass dictionary words against input}
function TSearchAnagrams.FindMissingLetter(const s:string):TTestWords;
var  possibles:TTestwords;


    Procedure getmatchingword(const ss:string; newletter:char);
    {scan for a valid word s within some preset range }
    var
      w:string;
    begin
      self.init(ss,length(ss), length(ss), false,false,false, pubdic);
      possibles[newletter]:='';
      begin
        if pubdic.dicloaded then
        If (Getnext(pubdic,w))  and (self.tag=0)
        then possibles[newletter]:=w;

        (*
        else if privdic.dicloaded then
        if Getnext(privdic,w)  and (SearchAnagrams.tag=0)
        then possibles[newletter]:=w;
        *)
      end;
    end;


var
  ch:char;
  temps, ss:string;
  i:integer;
begin {FindMissingLetter}
  tag:=0;
  temps:=lowercase(s);
  {get rid of any non-letters}
  for i:=length(temps) downto 1 do if not (temps[i]in ['a'..'z'])
  then delete(temps,i,1);

  {get arrays of unscrambled matching words for each possible missing letter}
  for ch:='a' to 'z' do
  begin
    ss:=temps+ch;
    getmatchingword(ss,ch);
  end;
  result:=possibles;
end; {FindMissingLetter }


{********** FindAllWords *****************}
{Original version - pass dictionary words against input}
procedure TSearchAnagrams.FindAllWords(const s:string; list:TStrings);
var  possibles:TTestwords;


    Procedure getmatchingword(const ss:string; newletter:char);
    {scan for a valid word s within some preset range }
    var
      w:string;
    begin
      self.init(ss,length(ss), length(ss), false,false,false, pubdic);
      possibles[newletter]:='';
      begin {Called from Wordstuff}
        if pubdic.dicloaded then
        while (Getnext(pubdic,w))  and (self.tag=0)
        do list.add(w)
        else if privdic.dicloaded then
        while Getnext(privdic,w)  and (self.tag=0)
        do list.add(w);
      end;
    end;


var
  ch:char;
  temps, ss:string;
  i:integer;
begin {FinadallWords}
  tag:=0;
  list.clear;
  temps:=lowercase(s);
  {get rid of any non-letters}
  for i:=length(temps) downto 1 do if not (temps[i]in ['a'..'z'])
  then delete(temps,i,1);

  {add to list of unscrambled matching words for each possible missing letter}
  for ch:='a' to 'z' do
  begin
    ss:=temps+ch;
    getmatchingword(ss,ch);
  end;
end; {FindAllWords}


 {**************** TSearchanagrams.INIT **********************}
 Procedure TSearchAnagrams.Init(newletters:string;NewMinLen,NewMaxLen:Word;
                       newA,newF,newC:boolean; apubdic:TDic);
   {Initialize dictionary with an array of firstletters
    and max and min word lengths}
   var
     ValidFirstChar : Charset;
     I, J           : Integer;
   begin {INIT}
      ValidFirstChar := ['a'..'z'];
      Curword:=Newletters;
      Len := Length(CurWord);
      MinLen:=NewMinLen;
      MaxLen:=NewMaxLen;
      useabbrevs:=newA;
      useforeign:=newf;
      usecaps:=newC;
      pubdic:= apubdic;
      privdic:= apubdic;
      Capword := lowercase(newletters);
      FirstLetterSt := '';
      for I := 1 to Len do
          {If this letter is not already in the first letter string,
           and it is a letter, then add it to first letter string}
         if (Pos(CapWord[I],FirstLetterSt) = 0) and
            (CapWord[I] in ValidFirstChar)
            then FirstLetterSt := FirstLetterSt + CapWord[I];
      LengthFirstLetterSt:=length(FirstLetterSt);
      SortString(FirstLetterSt);  {sort the first letter string}
      ValidWordChar := [];
      {Make a set of characters from the input letter string}
      for J := 1 to len do ValidWordChar := ValidWordChar + [CapWord[J]];
      NextSearchPos:=1;
      {if application.mainform=owner then}  {standalone version of the program}
      begin
        If pubdic.dicloaded then
          pubDic.SetRange(FirstLetterSt[NextSearchPos],MinLen,FirstLetterSt[NextSearchPos],MaxLen);
      end;
      Rest:='';
   end; { procedure Init}



{****************   TSearchAnagrams.GETNEXT ************************}
Function TSearchAnagrams.GetNext(Dic:TDic; Var Validword:string):boolean;
{ Get the next word that contains all of the letters in validword
 If found, Return the resulting word in Validword with result=true
 else return '' and result=false
}
   {********** GETNEXTMATCH (in Getnext) ***********************}
   {Gets a word with all letters in the ValidWordChar set}
   Procedure GetNextMatch(var NextWord : String);
   var
     I              : Integer;
     Match          : Boolean;
     l:word;
     a,f,c:boolean;
   begin
     match:=false;
     repeat
       if not Dic.GetNextWord(NextWord,a,f,c) then nextword:='';
       L:=length(nextword);

       if (( not a) and (not  f) and (not c))
           or (a and useabbrevs)
           or (f and useforeign)
           or (c and usecaps)
       then
       begin
         if L = 0 then Match := False else match:=true;
         I := 1;
         while (I <= L) and Match do
         begin
           if (not ((NextWord[I]) in ValidWordChar))
           then Match:=False;
           inc(I);
         end;
       end;
     until Match or (L = 0);
     if match and c
     then nextword[1]:=upcase(nextword[1]);
   end; { procedure GetNextmatch}

   {**************  VALIDMATCH (in GetNext) *************}
   {Makes sure that all letters in dicword are
    in letters being checked match 1-1 and returns
    leftover letters in rest}
   function ValidMatch(DictWord : String) : Boolean;
   var
     WorkCurWord    : String;
     WorkDictWord   : string;
     Position       : Integer;
     Found:boolean;
   begin
      WorkCurWord  := CapWord;
      WorkDictWord := lowercase(DictWord);
      Found:=true;
      repeat
         Position := Pos(WorkDictWord[1],WorkCurWord);
         if Position > 0 then
         Begin
           Delete(WorkCurWord,Position,1);
           Delete(WorkDictWord,1,1);
         End
         Else found:=false;
      until (WorkDictWord = '') or (found=false);
      ValidMatch := Found;
      Rest:=WorkCurword;
    end; { function ValidMatch }

  Var
    WordWasFound:Boolean;
  Begin  {Getnext}
    WordWasFound := False;
    If NextSearchPos<= LengthFirstLetterSt then
    While (NextSearchPos<=LengthFirstLetterSt) and (Not WordWasFound) do
    begin
      repeat
        GetNextMatch(ValidWord);
        if (length(validword)>0)  and (ValidMatch(ValidWord))
        then WordWasFound := True;
      until (Length(ValidWord) = 0) or (WordWasFound);
      If (Length(ValidWord)=0) Then
      Begin
        NextSearchPos:=Succ(NextSearchPos);
        if NextSearchPos<=LengthFirstLetterSt  then
        Dic.Setrange(FirstLetterSt[NextSearchPos],MinLen,FirstLetterSt[NextSearchPos],MaxLen);
      End;
    End;
    result:=wordwasfound;
  End; {getnext}

Initialization
  //SearchAnagrams:=TSearchAnagrams.create(application.mainform);

Finalization
  //SearchAnagrams.free;

end.
 