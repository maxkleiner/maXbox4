//*********************************************************
//Testframe , Snippets Prototypes, Pattern and Definition File for Functions or Units
//program testunit for include functions;  #locs:1368
//TPas is defined outside! in example 36_pas_includetest.txt
// snippets inc for example 700_new_function_snippets3.pas

{Stack := #0#0#0#0 + Stack;
          Pointer((@Stack[1])^) := VarPtr;}

const
  defWSDL = 'D:\Program Files\Apache Group\Apache2\cgi-bin\IVCLScanner.xml';
  defURL  = 'http://apsn21/cgi-bin/VCLScannerServer.exe/soap/IVCLScanner';
  defSvc  = 'IVCLScannerservice';
  defPrt  = 'IVCLScannerPort';


Function BoolToStr2(B: Boolean): string;
var
  cTrueFalseStr: array [0..1] of String;
begin
  cTrueFalseStr[0]:= 'False';
  cTrueFalseStr[1]:= 'True';
 if B then
    Result:= cTrueFalseStr[1]
  else
    Result:= cTrueFalseStr[0];
end;

FUNCTION HASH2 (X: string): INTEGER;
  //VAR I : 1..5;
  //N not defined
VAR I: byte;
    H: INTEGER;
BEGIN
   {TPas:=[a,c];
     if c in TPas then
       showmessage(' this is out from inside include ;)')}
  H:= 0;
  FOR I:= 1 TO 5 DO
      H:= (H * 10 + ORD(X[I]));
  result:= H MOD 20;
END;

PROCEDURE showAboutBox;
begin
  showMessage('for more information on maXbox please visit'+#13+#10
               +'http://www.softwareschule.ch/maxbox.htm'+#13+#10)
end;  

{procedure FreeAndNilData(var P);
var
  Ptr : Pointer;
begin
  if Assigned(Pointer(P)) then
  begin
    Ptr:=Pointer(P);
    Pointer(P):=nil;
    FreeMem(Ptr);
  end;
end;} 


function SafeStr2(const s: string): string;
var
 i : Longint;
begin
  Result:= s;
  for i:= 1 to length(s) do begin
    //if s[i] in [#0..#31] then begin
    if ord(s[i]) < 31 then begin
      Result := Copy(s, 1, i-1);
      exit;
    end;
  end;
end;

{procedure Set_Union(Dest, Src: PByteArray; ByteSize: Integer);
var
  i: Longint;
begin
  for i := ByteSize -1 downto 0 do
    Dest^[i] := Dest^[i] or Src^[i];
end;

procedure Set_Diff(Dest, Src: PByteArray; ByteSize: Integer);
var
  i: Longint;
begin
  for i := ByteSize -1 downto 0 do
    Dest^[i] := Dest^[i] and not Src^[i];
end;

procedure Set_Intersect(Dest, Src: PByteArray; ByteSize: Integer);
var
  i: Longint;
begin
  for i := ByteSize -1 downto 0 do
    Dest^[i] := Dest^[i] and Src^[i];
end;}  


{procedure GetResourceHeader(var ResourceHeader: String; const FormName: String; const FileSize: Integer);
var RT_RCDATA: char;
begin
  RT_RCDATA:= 'R';
  ResourceHeader := #$FF + Char(RT_RCDATA) + #$00 + FormName +
                    #$00 + #$30 + #$10 + Char(Low(Low(FileSize))) +
                    Char(High(Low(FileSize))) +
                    Char(Low(High(FileSize))) +
                    Char(High(High(FileSize)));
end;}

{function TfrmMain.OpenResource(const FileName : String) : Boolean;
begin
  Result := False;
  try
    hProcess := LoadLibraryEx(PChar(FileName),0,LOAD_LIBRARY_AS_DATAFILE);
    if GetLastError = ERROR_BAD_FORMAT then
      raise Exception.Create('Error loading executable module. Bad format.');
    if hProcess <> 0 then
      Result := GetResourceNames > 0;
  except
  end;
end;}


function GetIVCLScanner(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IVCLScanner;
{const
  defWSDL = 'D:\Program Files\Apache Group\Apache2\cgi-bin\IVCLScanner.xml';
  defURL  = 'http://apsn21/cgi-bin/VCLScannerServer.exe/soap/IVCLScanner';
  defSvc  = 'IVCLScannerservice';
  defPrt  = 'IVCLScannerPort';}
var
  RIO: THTTPRIO;
begin
  Result:= NIL;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr:= defWSDL
    else
      Addr:= defURL;
  end;
  if HTTPRIO = NIL then
    RIO:= THTTPRIO.Create(NIL)
  else
    RIO:= HTTPRIO;
  try
    Result:= (RIO as IVCLScanner);
    if UseWSDL then
    begin
      RIO.WSDLLocation:= Addr;
      RIO.Service := defSvc;
      RIO.Port:= defPrt;
    end else
      RIO.URL:= Addr;
  finally
    if (Result = NIL) and (HTTPRIO = NIL) then
      RIO.Free;
  end;
end;

function TVCLScannerPostData(const UserData: WideString; const CheckSum: DWORD): Boolean;
var
  SL: TStringList;
  FileName: String;
begin
  {with TWebModule1.Create(NIL) do begin
    getFile_DatabasePath;
    FileName:= filePath+FormatDateTime('yyyymmdd-hhnnsszzz',Now)+'.txt';
    Free
  end;}
  SL:= TStringList.Create;
  SL.Text:= UserData;
  SL.SaveToFile(FileName);
  SL.Free;
  Result:= True;
end;

function ExcludeDir(Dir : String) : Boolean;
var
  i : Integer;
  excludes: TStringlist;
  programfilesdir: string;
begin
  Result := False;
  Dir := UpperCase(Dir);
  for i:= 0 to Excludes.Count-1 do
    if Pos(UpperCase(Excludes[i]),Dir) > 0 then begin
      Result := True;
      Exit;
    end;
  // Try to exclude even unknown Delphi/BCB and beta installations
  if ((Pos(ProgramFilesDir+'\BORLAND\DELPHI',Dir) <> 0) or
      (Pos(ProgramFilesDir+'\BORLAND\POLARIS',Dir) <> 0) or // Delphi 2 beta
      (Pos(ProgramFilesDir+'\BORLAND\IVORY',Dir) <> 0) or // Delphi 3 beta
      (Pos(ProgramFilesDir+'\BORLAND\ALLEGRO',Dir) <> 0) or // Delphi 4 beta
      (Pos(ProgramFilesDir+'\BORLAND\ARGUS',Dir) <> 0) or // Delphi 5 beta
      (Pos(ProgramFilesDir+'\BORLAND\ILIAD',Dir) <> 0)) and // Delphi 6 beta
     ((Pos('BIN',Dir) <> 0) or (Pos('DEMOS',Dir) <> 0) or
      (Pos('HELP',Dir) <> 0) or (Pos('IMPORTS',Dir) <> 0) or
      (Pos('LIB',Dir) <> 0) or (Pos('SOURCE',Dir) <> 0)) then
    Result := True;
  if ((Pos(ProgramFilesDir+'\BORLAND\CBUILDER',Dir) <> 0) or
      (Pos(ProgramFilesDir+'\BORLAND\EBONY',Dir) <> 0) or // BCB 1 beta
      (Pos(ProgramFilesDir+'\BORLAND\PRESTO',Dir) <> 0) or // BCB 3 beta
      (Pos(ProgramFilesDir+'\BORLAND\THUNDER',Dir) <> 0) or // BCB 4 beta
      (Pos(ProgramFilesDir+'\BORLAND\RAMPAGE',Dir) <> 0)) and // BCB 5 beta
     ((Pos('BIN',Dir) <> 0) or (Pos('EXAMPLES',Dir) <> 0) or
      (Pos('HELP',Dir) <> 0) or (Pos('IMPORTS',Dir) <> 0) or
      (Pos('LIB',Dir) <> 0) or (Pos('SOURCE',Dir) <> 0)) then
    Result := True;
  // Exclude Delphi 1
  if (Pos('DELPHI\BIN',Dir) <> 0) or (Pos('DELPHI\DEMOS',Dir) <> 0) or
     (Pos('DELPHI\HELP',Dir) <> 0) or (Pos('DELPHI\LIB',Dir) <> 0) or
     (Pos('DELPHI\SOURCE',Dir) <> 0) then
    Result := True;
  // Exclude other Win/System
  if (Pos('WINDOWS\SYSTEM',Dir) <> 0) or (Pos('WINNT\SYSTEM',Dir) <> 0) then
    Result := True;
  // Exclude all Recycle Bins
  if (Pos('\RECYCLED',Dir) <> 0) then
    Result := True;
end;

function GetResourceFormFile(List: TStrings; const FormName, FileName: String) : Boolean;
var
  InStream,
  OutStream      : TMemoryStream;
  ResourceSize   : Integer;
  ResourceHeader : String;
  Buffer         : PChar;
  hprocess: HWND;
begin
  Result := True;
  if hProcess <> 0 then begin
    InStream := TMemoryStream.Create;
    OutStream := TMemoryStream.Create;
    try
      //Buffer := LockResource(LoadResource(hProcess,FindResource(hProcess,PChar(FormName),RT_RCDATA)));
      if Pos('TPF0', Buffer) <> 0 then begin
        //ResourceSize := SizeOfResource(hProcess,FindResource(hProcess,PChar(FormName),RT_RCDATA));
        //GetResourceHeader(ResourceHeader,FormName,ResourceSize);
        InStream.Size := ResourceSize;
        OutStream.Size := 2*ResourceSize; // Rough estimate
        InStream.Write(ResourceHeader[1],Length(ResourceHeader));
        //InStream.Write(Buffer^,ResourceSize);
        InStream.Seek(0,soFromBeginning);
{
        Worker := TWorker.Create(InStream,OutStream);
        while not Worker.Done do
          Application.ProcessMessages;
        Result := not Worker.SRError;
        Worker.Free;
}

        try
          //ObjectResourceToText(InStream,OutStream);
        except
          {on E: Exception do begin
            ShowMessage('Exception ('+E.ClassName+') caught while processing a resource ('+
                        FormName+') in '+UpperCase(FileName)+'. Scanning will continue, but the end result '+
                        'may be slightly off due to the black box nature of this resource.');
            Result := False;
          end; }
{      on E: EConvertError do begin
            Result := False;
          end;
          on E: EOutOfMemory do begin
            Result := False;
          end; }
        end;

        OutStream.Seek(0,soFromBeginning);
        List.BeginUpdate;
        List.LoadFromStream(OutStream);
        List.EndUpdate;
      end;
    finally
      InStream.Free;
      OutStream.Free;
    end;
  end;
end;

procedure CleanUpLists;
var
  I: Integer;
  //GConvFamilyList: TConvFamilyList;
  GConvTypeList: TConvTypeList;
  GLastConvFamily: TConvFamily;
  GLastConvType: TConvType;
  //GConvFamilySync: TMultiReadExclusiveWriteSynchronizer;
  //GConvTypeSync: TMultiReadExclusiveWriteSynchronizer;

  //LConvFamilyInfo: TConvFamilyInfo;
  LConvTypeInfo: TConvTypeInfo;
begin
  //GConvTypeSync.BeginWrite;
  try
    for I := 0 to Length(GConvTypeList) - 1 do begin
      LConvTypeInfo := GConvTypeList[I];
      if Assigned(LConvTypeInfo) then
      begin
        GConvTypeList[I] := nil;
        LConvTypeInfo.Free;
      end;
    end;
    SetLength(GConvTypeList, 0);
  finally
    //GConvTypeSync.EndWrite;
  end;
end;  

function GetStartAndEndWord(const N: Integer; const Str: string;
  const Delims: TCharSet; out StartIdx, EndIdx: Integer): Boolean;
var
  I, J: Integer;  // loops thru string finding start and end of word
  Count: Integer; // index of found word in string
  SLen: Integer;  // length of string
begin
  Result := False;
  Count := 0;
  I := 1;
  StartIdx := 0;
  EndIdx := 0;
  SLen := Length(Str);
  while I <= SLen do begin
    while (I <= SLen) and (IsCharInSet(Str[I], Delims)) do
      Inc(I);
    if I <= SLen then
      Inc(Count);
    J := I;
    while (J <= SLen) and not (IsCharInSet(Str[J], Delims)) do
      Inc( J );
    if Count = N then begin
      StartIdx := I;
      EndIdx := J - 1;
      Result := StartIdx > 0;
      Exit;
    end;
    I := J;
  end;
end;

function CutWordByIndex(const N: Integer; var Str: string;
  const Delims: TCharSet): string;
var
  St, En: Integer;  // start and end of string to cut
begin
  if GetStartAndEndWord(N, Str, Delims, St, En) then begin
    Result := Copy(Str, St, En - St + 1);
    Delete(Str, St, En - St + 1);
  end;
end;

// ---------------------------------------------------------------------------
  procedure AddItem(AllowEmpty: Boolean {= True}; const aTrim: Boolean;
           item: string; list: TStrings);
  begin
    // Adds optionally trimmed item to list if required
    if (aTrim) then
      Item := Trim(Item);
    if (Item <> '') or AllowEmpty then
      List.Add(Item);
  end;
  // ---------------------------------------------------------------------------
 
 function SplitStr(const S, Delim: string; out S1, S2: string): Boolean;
var
  DelimPos: Integer;  // position of delimiter in source string
begin
  // Find position of first occurence of delimiter in string
  DelimPos := AnsiPos(Delim, S);
  if DelimPos > 0 then begin
    // Delimiter found: split and return True
    S1 := Copy(S, 1, DelimPos - 1);
    S2 := Copy(S, DelimPos + Length(Delim), MaxInt);
    Result := True;
  end
  else begin
    // Delimiter not found: return false and set S1 to whole string
    S1 := S;
    S2 := '';
    Result := False;
  end;
end;

function ExplodeStr(S, Delim: string; const List: TStrings;
  const AllowEmpty: Boolean {= True}; const Trim: Boolean { = False)}): Integer;
var
  Item: string;       // current delimited text
  Remainder: string;  // remaining un-consumed part of string
 
  
begin
  // Clear the list
  List.Clear;
  // Check we have some entries in the string
  if S <> '' then begin
    // Repeatedly split string until we have no more entries
    while SplitStr(S, Delim, Item, Remainder) do
    begin
      AddItem(allowempty, trim, item, list);
      S := Remainder;
    end;
    // Add any remaining item
    AddItem(allowempty, trim, item, list);
  end;
  Result := List.Count;
end;


function ExplodeWords(const S: string; const Words: TStrings): Integer;
begin
  Result := ExplodeStr(CompressWhiteSpace(S), ' ', Words, False, True);
end;

function CountWords(const Str: string): Integer;
var
  Words: TStringList; // list of words in string
begin
  Words := TStringList.Create;
  try
    ExplodeWords(Str, Words);
    Result := Words.Count;
  finally
    Words.Free;
  end;
end;

function CountDelims(const S, Delims: string): Integer;
var
  Idx: Integer; //loops thru all characters in string
begin
  Result := 0;
  for Idx := 1 to Length(S) do
    if {SysUtils.}IsDelimiter(Delims, S, Idx) then
      Inc(Result);
end;

function WordCount(S: string): Integer;
begin
  S := Trim(S);
  if S <> '' then
    Result := CountDelims(CompressWhiteSpace(S), ' ') + 1
  else
    Result := 0;
end;

function DelAllStr(const Needle, Haystack: string): string;
var
  StartIdx: Integer;
begin
  Result := Haystack;
  StartIdx := AnsiPos(Needle, Result);
  while StartIdx > 0 do
  begin
    Delete(Result, StartIdx, Length(Needle));
    StartIdx := AnsiPos(Needle, Result);
  end;
end;

function DelText(const Needle, Haystack: string): string;
var
  StartIdx: Integer;
begin
  Result := Haystack;
  StartIdx := AnsiPos(
    {SysUtils.}AnsiLowerCase(Needle), AnsiLowerCase(Haystack)
  );
  if StartIdx > 0 then
    Delete(Result, StartIdx, Length(Needle));
end;

function WindowScrollbars(const Wnd: HWND): TScrollStyle;
var
  StyleFlags: DWORD;
begin
  StyleFlags:= GetWindowLong(Wnd, GWL_STYLE) and
    (WS_VSCROLL or WS_HSCROLL);
  case StyleFlags of
    0: Result := ssNone;
    WS_VSCROLL: Result := ssVertical;
    WS_HSCROLL: Result := ssHorizontal;
    else Result := ssBoth;
  end;
end;

(*function WinControlScrollbars(const Ctrl: TWinControl):
  TScrollStyle;
begin
  Result := WindowScrollbars(Ctrl.Handle);
end;

function VScrollbarWidth(const Ctrl: TWinControl): Integer;
begin
  if WinControlScrollbars(Ctrl)
    in [ssVertical, ssBoth] then
    Result := GetSystemMetrics(Windows.SM_CYVSCROLL)
  else
    Result := 0;
end; *)

function DOSLineBreaks(const S: string): string;
begin
  // Replace any existing CRLF (DOS) lines ends with LF
  Result := {SysUtils.}StringReplace(
    S, #13#10, #10, [rfReplaceAll]
  );
  // Replace any remaining CR (Mac) line ends with LF
  Result := StringReplace(
    Result, #13, #10, [rfReplaceAll]
  );
  // Replace all LF (Unix) lines ends with CRLF
  Result := StringReplace(
    Result, #10, #13#10, [rfReplaceAll]
  );
end;

function JoinStr(const SL: TStrings; const Delim: string;
  const AllowEmpty: Boolean {= True}): string;
var
  Idx: Integer; // loops thru all items in string list
begin
  Result := '';
  for Idx := 0 to Pred(SL.Count) do
  begin
    if (SL[Idx] <> '') or AllowEmpty then
      if Result = '' then
        Result := SL[Idx]
      else
        Result := Result + Delim + SL[Idx];
  end;
end;

function SplitString(const AText, ADelimiter: string): TStringList;
var
  LTxt, LTmp: string;
begin
  Result := TStringList.Create;
  LTxt := AText;
  while Pos(ADelimiter, LTxt) > 0 do begin
    LTmp := Copy(LTxt, 1, Pos(ADelimiter, LTxt) - 1);
    Result.Add(LTmp);
    LTxt := StringReplace(LTxt, LTmp + ADelimiter, '', []);
  end;
  if (LTxt <> '') then
    Result.Add(LTxt);
end;

function StripAccelChars(const S: string): string;
var emptystr: string;
begin
  Result := {SysUtils.}StringReplace(
    S, '&', {SysUtils.}EmptyStr, [rfReplaceAll]
  );
end;

function ParseDelims(const TextLine: string; var StartPos: Integer;
  const Delims: string): string;
var
  StringEnd: Integer;     // tracks end of current string being parsed out
begin
  // Find next non-delimiter char - this is where token starts
  while (StartPos <= Length(TextLine))
    and {SysUtils.}IsDelimiter(Delims, TextLine, StartPos) do
    Inc(StartPos);
  // Now find next delimiter - this is where token ends
  StringEnd := StartPos;
  while (StringEnd <= Length(TextLine))
    and not IsDelimiter(Delims, TextLine, StringEnd) do
    Inc(StringEnd);
  // Copy result out of string
  Result := Copy(TextLine, StartPos, StringEnd - StartPos);
  StartPos := StringEnd + 1;
end;


procedure RemoveDuplicateStrings(const Strings: TStrings);
var
  TempStrings: TStringList;
  Cnt: Integer;
begin
  if Strings.Count <= 1 then
    Exit;
  TempStrings := TStringList.Create;
  try
    TempStrings.Sorted := True;
    TempStrings.Duplicates := dupIgnore;
    for Cnt := 0 to Strings.Count - 1 do
      TempStrings.Add(Strings[Cnt]);
    Strings.Assign(TempStrings);
  finally
    TempStrings.Free;
  end;
end;

procedure ArrayToStringList(const Strings: array of string;
  const SL: TStrings);
var
  Idx: Integer; // loops thru each string in array
begin
  SL.Clear;
  for Idx := 0 to Pred(Length(Strings)) do
    SL.Add(Strings[Idx]);
end;

function StringListToArray(const SL: TStrings): TStringDynArray;
var
  Idx: Integer; // loops thru each string in SL
begin
  SetLength(Result, SL.Count);
  for Idx := 0 to Pred(SL.Count) do
    Result[Idx] := SL[Idx];
end;

function StripDuplicateStrings(const SA: array of string): TStringDynArray;
var
  SL: TStringList;
begin
  SL:= TStringList.Create;
  try
    ArrayToStringList(SA, SL);
    RemoveDuplicateStrings(SL);
    Result:= StringListToArray(SL);
  finally
    SL.Free;
  end;
end;

function PadRight(const AString: string; const AChar: Char;
  const ALen: Integer): string;
var
  PadLength: Integer; // number of padding characters required
begin
  Result := AString;
  PadLength := ALen - Length(AString);
  if PadLength < 1 then
    Exit;
  Result := StringOfChar(AChar, PadLength) + AString;
end;


function ContainsDelims(const S, Delimiters: string): Boolean;
var
  DelimIdx: Integer;  // loops thru delimiters
begin
  Result := False;
  for DelimIdx := 1 to Length(Delimiters) do
    if AnsiPos(Delimiters[DelimIdx], S) > 0 then begin
      Result := True;
      Break;
    end;
end;

const
  cWhiteSpace = ' '#9#10#11#12#13;  // white space characters

function ContainsWhiteSpace(const S: string): Boolean;
begin
  Result := ContainsDelims(S, cWhiteSpace);
end;

function LastPos(const SubStr, Str: string): Integer;
var
  Idx: Integer; // an index of SubStr in Str
begin
  Result := 0;
  Idx := PosEx(SubStr, Str,1);
  if Idx = 0 then
    Exit;
  while Idx > 0 do begin
    Result := Idx;
    Idx := PosEx(SubStr, Str, Idx + 1);
  end;
end;

function StrToken(var S: string; Separator: Char): string;
var
  Idx: Cardinal;  // index of Separator in S
begin
  Idx := {SysUtils.}AnsiPos(Separator, S);
  if Idx > 0 then begin
    Result := Copy(S, 1, Idx - 1);
    Delete(S, 1, Idx);
  end
  else begin
    Result := S;
    S := '';
  end;
end;

function StrTokenCount(S: string; Seperator: Char): Integer;
begin
  Result := 0;
  while S <> '' do
  begin
    StrToken(S, Seperator);
    Inc(Result);
  end;
end;

 // -------------------------------------------------------------------------
  procedure AddLine(const Line, aresult: string; margin: integer);
  begin
    // Adds line of text to output, offsetting line by width of margin
    if aResult <> '' then    // not first line: insert new line
      aResult := aResult + #13#10;
    aResult := aResult + StringOfChar(' ', Margin) + Line;
  end;
  // -------------------------------------------------------------------------
 

function TextWrap(const Text: string; const Width, Margin: Integer): string;
var
  Word: string;               // next word in input text
  Line: string;               // current output line
  Words: TStringList; // list of words in input text
  I: Integer;                 // loops thru all words in input text
 
 
begin
  // Get all words in text
  Words := TStringList.Create;
  try
    ExplodeStr(Text, ' ', Words, true, false);
    Result := '';
    Line := '';
    // Loop for each word in text
    for I := 0 to Pred(Words.Count) do begin
      Word := Words[I];
      if Length(Line) + Length(Word) + 1 <= Width then
      begin
        // Word fits on current line: add it
        if Line = '' then
          Line := Word  // 1st word on line
        else
          Line := Line + ' ' + Word;
      end
      else
      begin
        // Word doesn't fit on line
        AddLine(Line, result, margin);  // output line
        Line := Word;   // store word as first on next line
      end;
    end;
    if Line <> '' then
      // Residual line after end of loop: add to output
      AddLine(Line, result, margin);
  finally
    Words.Free;
  end;
end;

procedure TrimStringList(const List: TStrings; const Prefix: string);
var
  I: Integer;   // loops thru each line of string list
  Line: string; // contains a line of the string list
begin
  if not Assigned(List) then
    Exit;
  I := 0;
  while I < List.Count do begin
    Line := {SysUtils.}Trim(List[I]);
    if Line = '' then begin
      List.Delete(I);
      Continue;
    end
    else if Prefix <> '' then begin
      if AnsiPos(Prefix, Line) = 1 then begin
        List.Delete(I);
        Continue;
      end;
    end;
    Inc(I);
  end;
end;

function IsWhiteSpace(const Ch: Char): Boolean;
begin
  Result := IsCharInSet(Ch,[' ', #9, #10, #11, #12, #13]);
end;

function TitleCase(const S: string): string;
var
  Idx: Integer;           // loops through each character in string
  WantCapital: Boolean;   // flag indicating whether captial letter required
begin
  Result := LowerCase(S);
  WantCapital := True;
  for Idx := 1 to Length(S) do begin
    //if IsCharInSet(Result[Idx], letterset) then begin
      if WantCapital then
        Result[Idx] := UpCase(Result[Idx]); // capital letter required
      WantCapital := False;                 // following chars lower case
    //end
    //else
      WantCapital := IsWhiteSpace(Result[Idx]); // space: next char is capital
  end;
end;

function UnixLineBreaks(const S: string): string;
begin
  // Replace any CRLF (MSDOS/Windows) line ends with LF
  Result := {SysUtils.}StringReplace(
    S, #13#10, #10, [rfReplaceAll]
  );
  // Replace any remaining CR (Mac) line ends with LF
  Result := StringReplace(
    Result, #13, #10, [rfReplaceAll]
  );
end;

function IsNumeric(Value: string; const AllowFloat: Boolean;
  const TrimWhiteSpace: Boolean {= True}): Boolean;
var
  ValueInt: Int64;      // dummy integer value
  ValueFloat: double; //Extended; // dummy float value
  FormatSettings: TFormatSettings;
begin
  if TrimWhiteSpace then
    Value := Trim(Value);
  // Check for valid integer
  Result := {SysUtils.}TryStrToInt64(Value, ValueInt);
  if not Result and AllowFloat then
    // Wasn't valid as integer, try float
    Result := TryStrToFloat(Value, ValueFloat);
end;

procedure Delay(ADelay: Integer);
var
  StartTC: DWORD;   // tick count when routine called
  CurrentTC: Int64;         // tick count at each loop iteration
begin
  StartTC := GetTickCount;
  repeat
    CurrentTC := GetTickCount;
    if CurrentTC < StartTC then
      // tick count has wrapped around: adjust it
      CurrentTC := CurrentTC + High(StartTC{DWORD});
  until CurrentTC - StartTC >= ADelay;
end;

function DeleteEnvVar(const VarName: string): Integer;
begin
  if {Windows.}SetEnvironmentVariable(PChar(VarName), 'nil') then
    Result := 0
  else
    Result := {Windows.}GetLastError;
end;

function DOSCommand(const CommandLine: string; const CmdShow: Integer;
  const WaitUntilComplete: Boolean; const WorkingDir: string {= ''}): Boolean;
var
 ComSpec: array[0..MAX_PATH-1] of Char;   
 comspecs: string;
 FullCommandLine: string;
 PWorkingDir: PChar;
 SI: TStartupInfo;
 PI: TProcessInformation;
begin
  //FillChar(SI, SizeOf(SI), #0);
  SI.cb := SizeOf(SI);
  SI.dwFlags := {Windows.}STARTF_USESHOWWINDOW; // needed to use wShowWindow
  SI.wShowWindow := CmdShow;
  //wGetEnvironmentVariable('COMSPEC', ComSpec, SizeOf(ComSpec));
  comspecs:= GetEnvironmentVariable('COMSPEC');
  
  FullCommandLine := ComSpecs + ' /C ' + CommandLine;
  if WorkingDir <> '' then
    PWorkingDir := PChar(WorkingDir)
  else
    PWorkingDir := 'nil';
     //Function CreateProcess( lpApplicationName : PKOLChar; lpCommandLine : PKOLChar; lpProcessAttributes, lpThreadAttributes : PSecurityAttributes; bInheritHandles : BOOL; dwCreationFlags : DWORD; lpEnvironment : Pointer;lpCurrentDirectory:PKOLChar;const lpStartupInfo:TStartupInfo;var lpProcessInfo:TProcessInformation):BOOL

 (* Result := {Windows.}CreateProcess(
    'nil',
    PChar(FullCommandLine),
    'nil',
    'nil',
    False,
    {Windows.}NORMAL_PRIORITY_CLASS,
    'nil',
    PWorkingDir,
    SI,
    PI
  );  *)
  if Result then
  begin
    if WaitUntilComplete then
      {Windows.}WaitforSingleObject(PI.hProcess, INFINITE);
    CloseHandle(PI.hProcess);
    CloseHandle(PI.hThread );
  end;
end;

procedure EmptyKeyQueue;
var
  Msg: TMsg;  // dummy value to receive each message from queue
begin
  while PeekMessage(
    Msg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE
  ) do {nothing};
end;

procedure GetAllEnvVars(const Vars: TStrings);
var
  PEnvVars: PChar; //string; //PChar;    // pointer to start of environment block
begin
  Assert(Assigned(Vars),'vars not assigned');
  Vars.Clear;
  // Get reference to environment block for this process
  PEnvVars := {Windows.}GetEnvironmentString;
  if PEnvVars = nil then
    Exit;
  try
    //writeln(PEnvVars)
    writeln('debug get allenvvars in try')
    MultiSzToStrings(PEnvVars, Vars);
  finally
    {Windows.}FreeEnvironmentStrings(PEnvVars);
  end;
end;

function GetErrorMessageWithId(const OSErrorCode: Cardinal): string;
begin
  if OSErrorCode <> 0 then
    //Result := SysUserErrorMessage(OSErrorCode)
  else
    Result := '';
end;

function GetParentProcessID(const PID: DWORD): DWORD;
var
  Snapshot: THandle;    // snapshot of process
  PE: {TlHelp32.}TProcessEntry32; // structure holding info about a process
  EndOfList: Boolean;           // indicates end of process list reached
begin
  // Assume failure
  Result := DWORD(-1);
  // Get snapshot containing process list
  Snapshot := {TlHelp32.}CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
  if Snapshot = THandle(-1) then
    Exit;
  try
    // Look up process in process list
    PE.dwSize := SizeOf(PE);
    EndOfList := not {TlHelp32.}Process32First(Snapshot, PE);
    while not EndOfList do begin
      if PE.th32ProcessID = PID then begin
        // Found process: record parent process ID
        Result := PE.th32ParentProcessID;
        Break;
      end;
      EndOfList := not {TlHelp32.}Process32Next(Snapshot, PE);
    end;
  finally
    // Free the snapshot
    {Windows.}CloseHandle(Snapshot);
  end;
end;

function GetProcessorName: string;
var
  Reg: TRegistry;
begin
  Result := '';
  Reg := {Registry.}TRegistry.Create1(KEY_READ);
  try
    Reg.RootKey:= HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey(
      'HARDWARE\DESCRIPTION\System\CentralProcessor\0\', False
    ) then
      Exit;
    Result := Reg.ReadString('ProcessorNameString');
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function GetWindowThreadID(const Wnd: HWND): DWORD;
var
  GetWindowThreadProcessId: function(Wnd: HWND; // API fn prototype
    lpdwProcessId: DWORD): DWORD; //&&stdcall;
begin
  // We load the API function explicitly to make the routine compatible with as
  // many compilers as possible: the definition of GetWindowThreadProcessId in
  // Delphi and FreePascal Windows units varies across compilers
  //GetWindowThreadProcessId := GetProcAddress(
    //GetModuleHandle('user32.dll'), pchar('GetWindowThreadProcessId')
  //);
  {if Assigned(GetWindowThreadProcessId) and Windows.IsWindow(Wnd) then
    Result := GetWindowThreadProcessId(Wnd, nil)
  else
    Result := Windows.DWORD(-1);    }
end;

function ProgramFileSpec: string;
begin
  Result := ParamStr(0);
end;

const
  acOneMB = 1024 * 1024;  // a megabyte in bytes

function BytesToMB(const Bytes: Int64): Extended;
//const
  //cOneMB = 1024 * 1024;  // a megabyte in bytes
begin
  Result := Bytes / acOneMB;
end;

function BytesToMBStr(const Bytes: Int64; const DecimalPlaces: Byte;
  const SeparateThousands: Boolean): string;
begin
  Result := FloatToFixed(BytesToMB(Bytes), DecimalPlaces, SeparateThousands);
end;

function CompilerVer: Double;
begin
  {$UNDEF HAVE_RESULT}
  {$IFNDEF FPC}         // Delphi
    {$IFDEF VER90}
      {$DEFINE HAVE_RESULT}
      Result := 9.0;    // Delphi 2
    {$ENDIF}
    {$IFDEF VER100}
      {$DEFINE HAVE_RESULT}
      Result := 10.0;   // Delphi 3
    {$ENDIF}
    {$IFDEF VER120}
      {$DEFINE HAVE_RESULT}
      Result := 12.0;   // Delphi 4
    {$ENDIF}
    {$IFDEF VER130}
      {$DEFINE HAVE_RESULT}
      Result := 13.0;   // Delphi 5
    {$ENDIF}
    {$IFDEF CONDITIONALEXPRESSIONS}
      //{$IF Declared(CompilerVersion)}
        {$DEFINE HAVE_RESULT}
        Result := CompilerVersion;  // Delphi 6 and later
      //{$IFEND}
    {$ENDIF}
  {$ELSE}               // Free Pascal
    {$IFDEF VER1}
      {$DEFINE HAVE_RESULT}
      Result := 1.0;   // FPC v1.x
    {$ENDIF}
    {$IFDEF VER2}
      {$DEFINE HAVE_RESULT}
      Result := 2.0;   // FPC v2.x
    {$ENDIF}
  {$ENDIF}
  {$IFNDEF HAVE_RESULT}
    Result := 0.0;
  {$ENDIF}
  {$UNDEF HAVE_RESULT}
end;

function EnglishColorName(AColor: TColor;
  const AConvertSysColors: Boolean {= False}): string;
begin
  if AConvertSysColors then
    AColor := ColorToRGB(AColor);
  Result := {Graphics.}ColorToString(AColor);
  if AnsiStartsText('cl', Result) then
    Delete(Result, 1, 2);
end;

function FractionToStr(Num, Denom: Integer): string;
begin
  Result := {SysUtils.}Format('%d/%d', [Num, Denom]);
end;

procedure FreeStringsObjects(const Strings: TStrings);
var
  Idx: Integer;
  Temp: TObject;
begin
  for Idx := 0 to Pred(Strings.Count) do begin
    Temp := Strings.Objects[Idx];
    Strings.Objects[Idx] := nil;
    Temp.Free;
  end;
end;

procedure NormaliseFractionSign(var Num, Denom: Integer);
begin
  if Denom < 0 then
  begin
    Num := -Num;
    Denom := -Denom;
  end;
end;

function FractionToStrEx(Num, Denom: Integer; Normalise: Boolean {= False}): string;
begin
  if Normalise then
    NormaliseFractionSign(Num, Denom);
  Result := {SysUtils.}Format('%d/%d', [Num, Denom]);
end;

type TLongRec = record
        Hi: integer;
        aLo: word;
       Bytes: array [0..3] of Byte;
end;

function TryStrToWord(const S: string; out W: Word): Boolean;
var
  aValue: integer; // receives integer value of conversion
  along: TLongRec; 
begin
  Result := (TryStrToInt(S, aValue))
    and ({SysUtils.}along.Hi = 0);
  if Result then
    W := along.aLo;
end;

function FocusedControl: TWinControl;
begin
  Result := FindControl({Windows.}GetFocus);
end;

const
  TVS_NOTOOLTIPS = $0080;
          
  procedure DisableTreeViewToolTips(const TV: {ComCtrls.}TTreeView);
begin
  {Windows.}SetWindowLong(
    TV.Handle,
    GWL_STYLE,
    GetWindowLong(TV.Handle, GWL_STYLE)
      or {CommCtrl.}TVS_NOTOOLTIPS
  );
end;

(*function WindowScrollbars(const Wnd: HWND): TScrollStyle;
var
  StyleFlags: DWORD;
begin
  StyleFlags:= GetWindowLong(Wnd, GWL_STYLE) and
    (WS_VSCROLL or WS_HSCROLL);
  case StyleFlags of
    0: Result := {StdCtrls.}ssNone;
    WS_VSCROLL: Result := ssVertical;
    WS_HSCROLL: Result := ssHorizontal;
    else Result := {StdCtrls.}ssBoth;
  end;
end;*)

function WinControlScrollbars(const Ctrl: TWinControl): {StdCtrls.}TScrollStyle;
begin
  Result := WindowScrollbars(Ctrl.Handle);
  //EmptyRecycleBin
  //ExploreFile
end;

Function HScrollbarHeight(const Ctrl: TWinControl): Integer;
begin
  if WinControlScrollbars(Ctrl)
    in [ssHorizontal, ssBoth] then
    Result := GetSystemMetrics(SM_CXHSCROLL)
  else
    Result := 0;
end;

function SubLangID(LangID: Word): Word;
begin
  Result:= LangID shr 10;
end;

procedure ClearRecentDocs;
begin
  //{ShlObj.}SHAddToRecentDocs(ShlObj.SHARD_PATH, nil);
end;

function IsShellLinkX(const LinkFileName: string): Boolean;
//var ishell: IShellLink;
begin
  // Ensure COM is initialized
  {ActiveX.}CoInitialize(nil);
  try
    // Valid shell link if we can load it
    //Result := Assigned(LoadShellLink(LinkFileName));
  finally
    // Finalize COM
    {ActiveX.}CoUninitialize(nil);
  end;
end;

function TaskbarHandle2: THandle;
begin
  Result := FindWindow('Shell_TrayWnd', 'nil');
end;

function TrayHandle2: THandle;
begin
  Result := FindWindowEx(TaskbarHandle2, 0, 'TrayNotifyWnd', 'nil');
end;

function IsRemoteSession: Boolean;
//const
  //SM_REMOTESESSION = $1000; // value to pass to GetSystemMetrics
begin
  Result := GetSystemMetrics(SM_REMOTESESSION) <> 0;
end;

function IsTopLevelWindow(const Wnd: HWND): Boolean;
begin
  //Result := IsWindow(Wnd) and (GetParent(Wnd) = 0);
end;

function GetTopLevelWindow(const Wnd: HWND): HWND;
begin
  if IsWindow(Wnd) then
  begin
    Result := Wnd;
    while not IsTopLevelWindow(Result) and (Result <> 0) do
      Result := GetParent(Result);
  end
  else
    Result := 0;
end;

function MemoCursorPos(const Memo: {StdCtrls.}TCustomMemo): TPoint;
var
  Row, Col: Integer;  // row and column containing cursor
begin
  Row := SendMessage(
    Memo.Handle, EM_LINEFROMCHAR, Memo.SelStart, 0
  );
  Col := Memo.SelStart - SendMessage(
    Memo.Handle, EM_LINEINDEX, Row, 0
  );
  Result.X := Col;
  Result.Y := Row;
end;

const
  cWdwCurrentVer = '\Software\Microsoft\Windows\CurrentVersion';

function GetCurrentVersionRegStr2(const ValName: string): string;
begin
  Result := GetRegistryString(
    HKEY_LOCAL_MACHINE,
    cWdwCurrentVer,
    ValName
  );
end;

function ProgramFilesFolder2: string;
begin
  Result := GetCurrentVersionRegStr2('ProgramFilesDir');
end;

function PadRight2(const AString: string; const AChar: Char;
  const ALen: Integer): string;
var
  PadLength: Integer; // number of padding characters required
begin
  Result:= AString;
  PadLength:= ALen - Length(AString);
  if PadLength < 1 then
    Exit;
  Result:= StringOfChar(AChar, PadLength) + AString;
end;

function IntToOctal(Value: Integer; const Digits: Byte): string;
var
  // Octal digit characters
  cOctalDigits: array[$0..$7] of Char; // = '01234567';
begin
  Result := '';
  for it:= $0 to $7 do cOctalDigits[it]:= inttochar(it); 
  while Value <> 0 do begin
    Result := cOctalDigits[Value and 7] + Result;
    Value := Value shr 3;
  end;
  Result := PadRight(Result, '0', Digits);
  //SHGetPathFromIDList
end;

function ShowFindFilesDlg(const Folder: string): Boolean;
begin
//Function S_ShellExecute( aFilename : string; aParameters : string; aCommand : TS_ShellExecuteCmd) : string
  Result:= {mXCindyShellAPI.}ShellExecuteX(
    'find', PChar(Folder), '', '', {Windows.}SW_SHOW
  ) > 32;
  //Result:= {mXShellAPI.}ShellExecute3(
    //'find', Folder, {Windows.}SW_SHOW) <> '';
end;

(*function PIDLToFolderPath(PIDL: {ShlObj.}PItemIDList): string;
begin
  // Set max length of return string
  SetLength(Result, Windows.MAX_PATH);
  // Get the path
  if ShlObj.SHGetPathFromIDList(PIDL, PChar(Result)) then
    Result := PChar(Result)
  else
    Result := '';
end; *)

function TaskAllocWideString(const S: string): PChar;
var
  StrLen: Integer;  // length of string in bytes
begin
  // Store length of string allowing for terminal #0
  StrLen := Length(S) + 1;
  // Alloc buffer for wide string using task allocator
  //Result := {ActiveX.}CoTaskMemAlloc(StrLen * SizeOf(WideChar));
  if Assigned(Result) then
    // Convert string to wide string and store in buffer
    //StringToWideChar(S, Result, StrLen);
end;

function ExecAssociatedApp(const FileName: string): Boolean;
begin
  Result := {cyShellAPI.}cyShellExecute(
     'open',
    PChar(FileName),
    'nil',
    'nil',
    {Windows.}SW_SHOW
  ) > 32;
end;

function ExploreFile(const Filename: string ): Boolean;
var
  Params: string; // params passed to explorer
begin
  if {SysUtils.}FileExists(Filename) then
  begin
    Params := '/n, /e, /select, ' + Filename;
    Result := cyShellExecute (
      'open', 'explorer', PChar(Params), '', SW_SHOWNORMAL
    ) > 32;
  end
  else
    // Error: filename does not exist
    Result := False;
end;

procedure ClearRecentDocs2;
begin
  //{ShlObj.}SHAddToRecentDocs(ShlObj.SHARD_PATH, nil);
end;

//AddToRecentDocs


begin

  maxcalcF('9!')
// writeln(bigfact(70))
  writeln('GetParentProcessID: '+itoa(GetParentProcessID(GetProcessId)))  
  writeln(bytetooctal(64))
  writeln(IntToOctal(64,4))
  writeln('ShowFindFilesDlg: '+botostr(ShowFindFilesDlg(exepath+'examples')));
  //writeln(botoStr(ExecAssociatedApp(exepath+'maxbox4.exe')))
  //ExploreFolder
  //AddToRecentDocs
  //IsShellLink
end.

//------------------------------------------
//In Delphi, False and True are an enumeration of a boolean set.  As such, they have //implied numeric values that are indexes into their positions in the [False, True] set.

