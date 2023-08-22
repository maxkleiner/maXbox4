unit psULib;

(*=== File Description =======================================================*
   PURPOSE: Miscellaneous PS library functions.
START DATE: 2001.6.1
  CODED BY: Ryan Fischbach & David Emami & Eric Thompson
   UPDATES:
     2003.8.12 by Ryan Fischbach
       Added some Hex/Text, Graphic/Stream, Graphic/Text routines.
     2003.4.27 by Ryan Fischbach
       D5 & D7 compatible.
==============================================================================*)

(*=== Copyright Notice =======================================================*
    This file contains proprietary information of Prometheus Software, Inc.
    Copying or reproduction without prior written approval is prohibited.

    Copyright(c) 2001-2006
    Prometheus Software, Inc.
==============================================================================*)

interface

{$I psversions.inc}

uses
  Windows, Classes, Graphics, Db, Controls, SysUtils, Dialogs, ActnList,
  Printers;

const //standard Windows colors that are not defined by Delphi
  clMoneyGreen = TColor($00C0DCC0);
  clMedGray    = TColor($00A4A0A0);
  clRxCream    = TColor($00A6CAF0);  //as defined by RxLib v2.75a
  clCream      = TColor($00F0FBFF);  //as defined by Microsoft
  clRxSkyBlue  = TColor($00FFFBF0);  //as defined by RxLib v2.75a
  clSkyBlue    = TColor($00F0CAA6);  //as defined by Microsoft
{$IFNDEF WIN32}
  clInfoBk     = TColor($02E1FFFF);
  clNone       = TColor($02FFFFFF);
{$ENDIF}
{$IFNDEF DELPHI7UP}
  clSystemColor = $FF000000;
  clGradientActiveCaption = TColor(clSystemColor or COLOR_GRADIENTACTIVECAPTION);
  clGradientInactiveCaption = TColor(clSystemColor or COLOR_GRADIENTINACTIVECAPTION);
{$ENDIF}

const
  MinutesPerDay    = 24*60;
  DefaultBeepDelay = 500;
  cDoNotBringToTop = '-LaunchInBackground';

type
  TFilenameEvent=procedure(Sender:TObject; var Filename:string) of object;

type
  TWriteDebugProc=procedure(const LogName,RoutineName,Comment:string; DebugData:array of string) of object;

type
  TPathBuffer=array[0..Max_Path-1] of char;

type
  TLongintCharBuffer=array[0..SizeOf(longint)-1] of char;

var
  WriteDebugProc:TWriteDebugProc=nil;

procedure WriteDebug(const LogName,RoutineName,Comment:string; DebugData:array of string);

function Between(Value,BoundA,BoundB:integer; AllowFlip:boolean=true):boolean;
function BooleanMatch(Value1:boolean; Value2:integer):boolean; overload;
function BooleanMatch(Value1:integer; Value2:boolean):boolean; overload;
function BooleanMatch(Value1,Value2:integer):boolean; overload;
function IDMatch(RequiredID,TestID:integer):boolean; overload;
function IDMatch(RequiredID:TField; TestID:integer):boolean; overload;
function IDMatch(RequiredID,TestID:TField):boolean; overload;

function Blend(Color1,Color2:TColor; Weight1:integer=1; Weight2:integer=1):TColor;
function MergeRGB(Red,Green,Blue:integer):TColor;
procedure SplitRGB(Color:TColor; var Red,Green,Blue:integer);
function VisibleContrast(BackgroundColor: TColor): TColor;

function SortedStr(Value:string):string;
function IntSortStr(const Value:integer):string;
function AllAssigned(Values:array of pointer):boolean;
function GetToken(var SourceStr:string; Delim:string):string;

function URLize(SourceStr:string):string;
function UnURLize(const SourceStr:string):string;

function UnQuoteStr(const Value:string; QuoteChar:char=''''):string;

procedure SetAndSaveBool(var OldVar:boolean; Value:boolean; var SaveVar:boolean);
procedure SetAndSaveInt(var OldVar:integer; Value:integer; var SaveVar:integer);
procedure SetAndSaveStr(var OldVar:string; const Value:string; var SaveVar:string);

function GetCharFromVKey(VKey:word):string;
function IsControlKeyDown: boolean;

procedure PushScreenCursor(const aCursor:TCursor=crHourGlass);
procedure PopScreenCursor;
{ Procedure Pair to use in Try-Finally cases where setting the cursor is necessary.
  Typically used to set the hourglass and then back to arrow, this pair handles the possibility
  of Screen being unassigned (uncommon, but real, possiblity) safe for use in controls. }
function PeekScreenCursor: TCursor;
{ Returns the top-most cursor value on the stack or crDefault if there isn't anything on it. }

type
  TMaxIntSize = (mbsInt8, mbsWord8, mbsInt16, mbsWord16, mbsInt32, mbsWord32);
function CharIsNumericSymbol(aChar:char): boolean;
function PrecisionMultiplier(DecimalPrecision: byte): cardinal;
function TextToFloatVal(const aText: string; const DecimalPrecision: byte = 2; const DefaultValue: extended = 0): extended;
function TextToWordVal(const aText: string; const DefaultValue: cardinal = 0; const MaxIntSize: TMaxIntSize = mbsInt32 ): cardinal;
function TextToIntVal(const aText: string; const DefaultValue: integer = 0; const MaxIntSize: TMaxIntSize = mbsInt32 ): integer;
function BankersRounding(const Num: currency; const DecimalPrecision: byte = 2): currency;
function RoundDown(const Num:Extended; const DecimalPrecision:byte=2):Extended;
function RoundUp(const Num:Extended; const DecimalPrecision:byte=2):Extended;
function RoundNearest(const Num:Extended; const DecimalPrecision:byte=2):Extended;
function NumDigits(const aNum:integer): integer; //used primarily to format output using List.Count
function ZeroToMax(Value:integer):integer;

procedure CopyIfPrefixMatch(Source,Dest:TStrings; Prefix:string; ClearDest:boolean=true; ValuesOnly:boolean=false);
{ Copies all strings from Source to Dest whose initial characters match Prefix }

function HexToChar(const aValue: byte): AnsiChar;
//Convert the value into a hex char.  '?' is unknown value
function CharToHex(const aValue: AnsiChar): byte;
//Convert the value from a hex char into the equivalent value, $FF is unknown value
function HexToText(const Source: AnsiString): AnsiString;
//Convert the string passed in into double its size where every byte = 2 human readable hex #s
function TextToHex(const Source: AnsiString): AnsiString;
//Convert the string passed in into half its size where every 2 chars = 1 byte value
procedure SaveGraphicToStream(aGraphic: TGraphic; aStream: TStream);
//save the classname, then the data to the stream
function LoadGraphicFromStream(aStream: TStream): TGraphic;
//load the classname, then the data from the stream
function GraphicToText(aGraphic: TGraphic): string;
//convert the graphic to a string representation for easy storage
function TextToGraphic(aGraphicAsText: string): TGraphic;
//convert a saved text representation back to graphic format

function GetCustNameStr(aFirstName,aLastName: string): string;
function GetLongCustNameStr(aTitle,aFirstName,aLastName: string): string;

function GetPriceFromMargin(const aMargin: string; aCost: currency): currency;
function GetMarginFromPrice(aPrice,aCost: currency): string;

function GetDriveSerialNum(Path:string):longint;

function GetCCCardTypeFromName(aCardName: string): integer;

function GetItemMarginPercent(Price,Cost: Currency):double;

function ValidateCreditCard(aCardNum: string): boolean;
function ValidateCreditCardRange(const aCardNum,aLowNum,aHighNum: string): boolean;

function HHMMToTime(Value:string):TTime;
function MMDDToDate(Value:string):TDate;
function TimeToHHMMSS(Value:TTime):string;
function DateToYYYYMMDD(Value:TDate):string;

function FontColorToString(SourceFont: TFont; SourceColor: TColor=clNone): string;
//convert SourceFont and optionally SourceColor into an INI-type string
procedure StringToFont(aStr: string; DestFont: TFont);
//convert an INI-type string back to font form with DestFont
procedure StringToFontColor(aStr: string; DestFont: TFont; var DestColor: TColor);
//convert an INI-type string back to font form with DestFont and DestColor

procedure ShowDebugStrings(DebugStrings:TStrings);
procedure ShowStackDump;

procedure RegisterFileExtension(const Extension,Description,DefaultActionName,
    DefaultActionDescription,DefaultActionCommand:string; IconIndex:integer);
//Registers the supplied Extension with the Windows OS so that opening a file
//  with that extension will launch the DefaultActionCommand
function LaunchCommand(aCommand:string; aParams:string=''; WaitForTerminate:boolean=false): boolean;
//Launches the supplied command even if it's a shortcut file or foldername to explore
//  NOTE: use the constant cDoNotBringToTop in aParams if you do not wish the launched app to get focus
function GetWindowsDirectoryStr:string;
//Returns the windows folder
function IsRemoteSession: boolean;
//check to see if running in a terminal client session
function IsWinXP: boolean;
//return TRUE if we are running on XP or a newer version. XP is Windows NT 5.1

procedure AssignTextFileToStream(var ATextFile:TextFile; AStream:TStream);

function DeleteFileMask(const Mask:string):boolean;
// Deletes files that match Mask
function FileMaskCount(const Mask:string):integer;
// Returns the number of files that match Mask
function FileMaskExists(const Mask:string):boolean;
// Returns True if any files match Mask, False otherwise
function FileMaskList(const Mask:string):string; overload;
// Returns a semicolon-delimited list of files that match Mask. If no matches, Result=''
function FileMaskList(const Mask:string; Dest:TStrings; ClearList:boolean=true):boolean; overload;
// Populates Dest with the filenames that match Mask. If ClearList=true, clears Dest first

function GetSafeNumericVariant(Value:Variant):Variant;

function GetPasswordCharStr(aStr: string): string;

function GetDriversLicenseHeightDisplayText(aStr: string): string;

function IncludePathDelimiter(const aFilePath: string): string;
//same as IncludeTrailingPathDelimiter, avoids compiler version problems
function ExcludePathDelimiter(const aFilePath: string): string;
//same as ExcludeTrailingPathDelimiter, avoids compiler version problems
{$IFNDEF DELPHI6UP}
function GetEnvironmentVariable(const Name: string): string;
//returns the value of the environment variable Name
{$ENDIF}

function ArrayToStr(SourceArray:array of string; Separator:AnsiChar):string;
function psStrReplace(var S: AnsiString; const Search, Replace: AnsiString; Flags: TReplaceFlags = []):boolean;
function StrReplaceInStrings(StrObject:TStrings; const Search, Replace: AnsiString; Flags: TReplaceFlags = []):boolean;

//to combat the "shy dialog" issue, override the "showmsg" calls
//  (shy dialog = dialog pops under mainform instead of on top)
//  Please use MessageBox or StandardUserQuery whenever possible.
procedure ShowMessage(aMsg: string);
procedure ShowErrorMessage(aMsg: string); //same as ShowMessage, but with Error icon
function StandardUserQuery(aMsg: string; DialogType: cardinal=0; DialogCaption: string=''): cardinal;
//NOTE: default dialogtype = MB_ICONQUESTION+MB_YESNO+MB_DEFBUTTON1, return values are IDYes, IDNo, IDOk, etc.

function ParamValue(ParamName:string):string;
function ParamFlagSet(ParamName:string):boolean;

function ConcatenateNonBlanks(Strings: array of string): string;
function ConcatenateWithDelimiter(Strings: array of string; Delimiter: PChar): string;
function GetMaxStringLength(Strings: array of string): integer;

procedure PlayBeep(BeepActionType: TMsgDlgType; NumBeeps: integer=1; MSDelay: integer=DefaultBeepDelay);
function DelTree(const DirectoryName: string): Boolean;
procedure UpdateActionCaption(anAction: TAction; aCaption: string);
procedure GetDirectoryList(const DirectoryName: string; StringList: TStrings);

function DecodePath(const Path:string; PathVars:TStrings):string;
function KillEXE(ExeName: String): Boolean;

function GetWindowsDefaultPrinterName: string;

function GetBackupFilename(const OrigFilename:string):string;
function GetRestoreFilename(const BackupFilename:string):string;
function MakeBackupFile(const OrigFilename:string; OverwriteExisting:boolean):string;
function RestoreBackupFile(const BackupFilename:string; OverwriteExisting:boolean):string;

function CalcDistance(Lat1, Long1, Lat2, Long2: double): double;

function GetDelimiterCount(aString,aDelimiter: string): integer;

implementation

uses
  JCLStrings, JCLDebug, Math, StdCtrls, ExtCtrls, Forms,
{$IFDEF DELPHI6UP}
  Variants,
{$ELSE}
  JclSysInfo,
{$ENDIF}
  Registry, JclShell, ShellAPI, PsAPI;

type
  TStreamData=record
    Stream:TStream;
    Filler:array[1..16] of Char;
  end;

function Between(Value,BoundA,BoundB:integer; AllowFlip:boolean=true):boolean;
begin
  if (BoundA<=BoundB) or (not AllowFlip) then
    Result:=(Value>=BoundA) and (Value<=BoundB)
  else
    Result:=(Value>=BoundB) and (Value<=BoundA);
end;

function Blend(Color1,Color2:TColor; Weight1:integer=1; Weight2:integer=1):TColor;
var
  Red1,Green1,Blue1,Red2,Green2,Blue2,TotalWeight:integer;

begin
  TotalWeight:=Weight1+Weight2;
  if TotalWeight=0 then
    Result:=0
  else
    begin
      SplitRGB(ColorToRGB(Color1),Red1,Green1,Blue1);
      SplitRGB(ColorToRGB(Color2),Red2,Green2,Blue2);
      Result:=MergeRGB((Red1*Weight1+Red2*Weight2) div TotalWeight,(Green1*Weight1+Green2*Weight2) div TotalWeight,(Blue1*Weight1+Blue2*Weight2) div TotalWeight);
    end;
end;

function BooleanMatch(Value1:boolean; Value2:integer):boolean;
begin
  case Value2 of
    0 : Result:=not Value1;
    1 : Result:=Value1;
    2 : Result:=true;
  else
    Result:=false; //should never occur
  end;
end;

function BooleanMatch(Value1:integer; Value2:boolean):boolean;
begin
  case Value1 of
    0 : Result:=not Value2;
    1 : Result:=Value2;
    2 : Result:=true;
  else
    Result:=false; //should never occur
  end;
end;

function BooleanMatch(Value1,Value2:integer):boolean;
begin
  case Value1 of
    0 : Result:=(Value2=0) or (Value2=2);
    1 : Result:=(Value2=1) or (Value2=2);
    2 : Result:=true;
  else
    Result:=false; //should never occur
  end;
end;

function IDMatch(RequiredID,TestID:integer):boolean;
begin
  Result:=(RequiredID=0) or (RequiredID=TestID);
end;

function IDMatch(RequiredID:TField; TestID:integer):boolean; overload;
begin
  Result:=(RequiredID.AsInteger=0) or (RequiredID.AsInteger=TestID);
end;

function IDMatch(RequiredID,TestID:TField):boolean; overload;
begin
  Result:=(RequiredID.AsInteger=0) or (RequiredID.AsInteger=TestID.AsInteger);
end;

function MergeRGB(Red,Green,Blue:integer):TColor;
begin
  Result:=Min(Max(Red,0),$FF)*$10000+Min(Max(Green,0),$FF)*$100+Min(Max(Blue,0),$FF);
end;

procedure SplitRGB(Color:TColor; var Red,Green,Blue:integer);
var
  RGB:TColor;

begin
  RGB:=ColorToRGB(Color);
  Red:=(RGB div ($10000)) mod $100;
  Green:=(RGB div ($100)) mod $100;
  Blue:=RGB mod $100;
end;

(*
From: "Filsinger, Andreas (Softwareentwicklung)" <andreas@filsinger.de>
To: <efg2@efg2.com>
Subject: Suggestion for additional "Color Project"
Date: Monday, October 08, 2001 5:43
Earl,
i had to place text on a coloured backgound. I knew the color of the background,
now i had to calculate automatically the Font-Color viewed best on the specific
background-color.
My first try was "textcolor := BackgroundColor xor $FFFFFF".
That results in well visible (but funny) Font-Colors, but fails if the background is grey.
Next i set Font-Color to "white" on dark backgounds, and "black" on bright ones.
But what is Brigthness? (R + G + B) / 3 seems to be a good value.
It fails because the human eye does not see all the colours in the same density.
Next i read something about "Luminanz" and created my final code:

2003.10.16 by Ryan Fischbach
clInfoBk ($80000024): The value 24 is not a color value but an index to some internal Windows
color table. So you don't extract the color by shifting bytes, but by asking
Windows what color the value is mapped to. So use ColorToRGB(aTColor)!
*)
function VisibleContrast(BackgroundColor: TColor): TColor;
const
  cHalfBrightness = ((0.3 * 255.0) + (0.59 * 255.0) + (0.11 * 255.0)) / 2.0;
var
  Brightness: double;
begin
  BackgroundColor := ColorToRGB(BackgroundColor);
  with TRGBQuad(BackgroundColor) do
    BrightNess := (0.3 * rgbRed) + (0.59 * rgbGreen) + (0.11 * rgbBlue);
  if (Brightness>cHalfBrightNess) then
    Result := clBlack
  else
    Result := clWhite;
end;

function AllAssigned(Values:array of pointer):boolean;
var
  Index:integer;

begin
  Result:=true;
  for Index:=0 to High(Values) do
    if Values[Index]=nil then
      begin
        Result:=false;
        Break;
      end;
end;

function SortedStr(Value:string):string;
var
  CharNum:integer;
  LowestStr:string;

begin
  Result:='';
  while Value<>'' do
    begin
      LowestStr:=copy(Value,1,1);
      for CharNum:=2 to length(Value) do
        if copy(Value,CharNum,1)<LowestStr then
          LowestStr:=copy(Value,CharNum,1);
      Result:=Result+LowestStr;
      Delete(Value,pos(LowestStr,Value),1);
    end;
end;

function IntSortStr(const Value:integer):string;
begin
  Result:=Format('%10.10d',[abs(Value)]);
  if Value<0 then
    Result:='n'+Result
  else
    Result:='p'+Result;
end;

function GetToken(var SourceStr:string; Delim:string):string;
var
  DelimPos:integer;

begin
  DelimPos:=pos(Delim,SourceStr);
  if DelimPos=0 then
    begin
      Result:=SourceStr;
      SourceStr:='';
    end
  else
    begin
      Result:=copy(SourceStr,1,DelimPos-1);
      Delete(SourceStr,1,DelimPos+length(Delim)-1);
    end;
end;

function URLize(SourceStr:string):string;
var
  CharNum:integer;
  TempChar:char;

begin
  Result:='';
  for CharNum:=1 to length(SourceStr) do
    begin
      TempChar:=SourceStr[CharNum];
      if TempChar>=' ' then
        Result:=Result+TempChar
      else
        Result:=Result+'%'+Format('%2.2x',[ord(TempChar)]);
    end;
end;

function UnURLize(const SourceStr:string):string;
var
  CharNum:integer;
  TempChar:char;
  DigitStr:string;

begin
  Result:='';
  CharNum:=1;
  while CharNum<=length(SourceStr) do
    begin
      TempChar:=SourceStr[CharNum];
      if TempChar<>'%' then
        Result:=Result+TempChar
      else
        if (length(SourceStr)=CharNum) or (copy(SourceStr,CharNum+1,1)='%') then
          begin
            Result:=Result+'%';
            inc(CharNum);
          end
        else
          begin
            DigitStr:=copy(SourceStr,CharNum+1,2);
            if length(DigitStr)=1 then
              Result:=Result+char(CharHex(DigitStr[1]))
            else
              Result:=Result+char(CharHex(DigitStr[1])*16+CharHex(DigitStr[2]));
            CharNum:=CharNum+2;
          end;
      inc(CharNum);
    end;
end;

function UnQuoteStr(const Value:string; QuoteChar:char=''''):string;
var
  CharNum:integer;
  PrevChar,CurrentChar:char;

begin
  Result:='';
  PrevChar:=#0;
  for CharNum:=1 to length(Value) do
    begin
      CurrentChar:=Value[CharNum];
      if (CurrentChar<>QuoteChar) or (PrevChar=QuoteChar) then
        Result:=Result+CurrentChar;
      PrevChar:=CurrentChar;
    end;
end;

procedure SetAndSaveBool(var OldVar:boolean; Value:boolean; var SaveVar:boolean);
begin
  SaveVar:=OldVar;
  OldVar:=Value;
end;

procedure SetAndSaveInt(var OldVar:integer; Value:integer; var SaveVar:integer);
begin
  SaveVar:=OldVar;
  OldVar:=Value;
end;

procedure SetAndSaveStr(var OldVar:string; const Value:string; var SaveVar:string);
begin
  SaveVar:=OldVar;
  OldVar:=Value;
end;

procedure WriteDebug(const LogName,RoutineName,Comment:string; DebugData:array of string);
begin
  if Assigned(WriteDebugProc) then
    WriteDebugProc(LogName,RoutineName,Comment,DebugData);
end;

function GetCharFromVKey(VKey:word):string;
var
  KeyState:TKeyboardState;
  RetCode:integer;

begin
  Win32Check(GetKeyboardState(KeyState));
  SetLength(Result,2);
  RetCode:=ToAscii(VKey,MapVirtualKey(VKey,0),KeyState,@Result[1],0);
  case retCode Of
    0: Result:='';
    1: SetLength(Result,1);
    2: ;
  else
    Result:='';
  end;
end;

function IsControlKeyDown: boolean;
begin
  Result := ((Windows.GetKeyState(VK_Control) AND $80)<>0);
end;

var
  ScreenCursorStack: array of TCursor;
  ScreenCursorStackTop: word = 0;

procedure PushScreenCursor(const aCursor:TCursor=crHourGlass);
var
  SaveCursor: TCursor;
begin
  if Assigned(Screen) then
    begin
      SaveCursor := Screen.Cursor;
      Screen.Cursor := aCursor;
    end
  else
    SaveCursor := crDefault;
  if (ScreenCursorStackTop=length(ScreenCursorStack)) then
    SetLength(ScreenCursorStack,ScreenCursorStackTop+4);
  inc(ScreenCursorStackTop);
  ScreenCursorStack[pred(ScreenCursorStackTop)] := SaveCursor;
end;

procedure PopScreenCursor;
begin
  if (ScreenCursorStackTop>0) then
  begin
    if Assigned(Screen) then
      Screen.Cursor := ScreenCursorStack[pred(ScreenCursorStackTop)];
    dec(ScreenCursorStackTop);
  end;
end;

function PeekScreenCursor: TCursor;
begin
  if (ScreenCursorStackTop>0) then
    Result := ScreenCursorStack[pred(ScreenCursorStackTop)]
  else
    Result := crDefault;
end;

function CharIsNumericSymbol(aChar:char): boolean;
//CharIsNumber function in JCL not found in all versions
begin
  Result := CharIsDigit(aChar) or (aChar=DecimalSeparator) or (aChar='-') or (aChar='+');
end;

function PrecisionMultiplier(DecimalPrecision: byte): cardinal;
var
  i: integer;
begin
  DecimalPrecision := Min(DecimalPrecision,9);
  Result := 1;
  for i := 1 to DecimalPrecision do
    Result := 10*Result;
end;

function TextToFloatVal(const aText: string; const DecimalPrecision: byte = 2; const DefaultValue: extended = 0): extended;
var
  pm: cardinal;
  ErrCode,i: integer;
  Text: string;
begin
  Result := 0;
  Text := aText;
  //make sure the text is only numbers
  for i := length(Text) downto 1 do
  begin
    if (not CharIsNumericSymbol(Text[i])) then
      delete(Text,i,1);
  end;//for

  //Val doesn't like internationalized DecimalSeparator
  StrReplace(Text,DecimalSeparator,'.');

  if (Text<>'') then
  begin
    ErrCode := 0;
    repeat
      Val(Text,Result,ErrCode);
      if (ErrCode<>0) then
      begin
        if (ErrCode<=Length(Text)) then
          delete(Text,ErrCode,1)
        else
          delete(Text,Length(Text),1);
      end;//if
    until (ErrCode=0) or (Text='') or (ErrCode>Length(Text));
  end;//if text is not blank

  if (ErrCode=0) and (Text<>'') then
    begin
      //round result to nearest DecimalPrecision
      if (Result<>0) then
      try
        pm := PrecisionMultiplier(DecimalPrecision);
        Result := Round(pm*Result)/pm;
      except
        Result:= DefaultValue;
      end;//try-except
    end
  else
    Result := DefaultValue;
end;

function TextToWordVal(const aText: string; const DefaultValue: cardinal = 0; const MaxIntSize: TMaxIntSize = mbsInt32 ): cardinal;
const
  MaxValues: array[TMaxIntSize] of cardinal =
      (high(shortint),high(byte),high(smallint),high(word),high(integer),high(cardinal));
var
  TempExtended: extended;
begin
  TempExtended := TextToFloatVal(aText,0,DefaultValue);
  if (TempExtended>=0) and (TempExtended<=MaxValues[MaxIntSize]) then
    Result := round(TempExtended)
  else
    Result := DefaultValue;
end;

function TextToIntVal(const aText: string; const DefaultValue: integer = 0; const MaxIntSize: TMaxIntSize = mbsInt32 ): integer;
const
  MinValues: array[TMaxIntSize] of integer =
      (low(shortint),low(byte),low(smallint),low(word),low(integer),low(cardinal));
  MaxValues: array[TMaxIntSize] of integer =
      (high(shortint),high(byte),high(smallint),high(word),high(integer),high(integer));
var
  TempExtended: extended;
begin
  TempExtended := TextToFloatVal(aText,0,DefaultValue);
  if (TempExtended>=MinValues[MaxIntSize]) and (TempExtended<=MaxValues[MaxIntSize]) then
    Result := round(TempExtended)
  else
    Result := DefaultValue;
end;

function BankersRounding(const Num: currency; const DecimalPrecision: byte = 2): currency;
var
  pm: cardinal;
begin
  if (Num<>0) then
    begin
      pm := PrecisionMultiplier(DecimalPrecision);
      Result := Num*pm;
      if (Num>0) then
        Result := Result+0.5
      else
        Result := Result-0.5;
      Result := trunc(Result)/pm;
    end
  else
    Result := 0;
end;

function RoundDown(const Num:Extended; const DecimalPrecision:byte=2):Extended;
var
  Multiplier:Cardinal;

begin
  if Num<>0 then
    begin
      Multiplier:=PrecisionMultiplier(DecimalPrecision);
      Result:=Num*Multiplier;
      Result:=trunc(Result)/Multiplier;
    end
  else
    Result:=0;
end;

function RoundUp(const Num:Extended; const DecimalPrecision:byte=2):Extended;
var
  Multiplier:Cardinal;

begin
  if Num=0 then
    Result:=0
  else
    begin
      Multiplier:=PrecisionMultiplier(DecimalPrecision);
      Result:=Num*Multiplier;
      if Num<0 then
        Result:=Floor(Result)/Multiplier
      else
        Result:=Ceil(Result)/Multiplier;
    end;
end;

function RoundNearest(const Num:Extended; const DecimalPrecision:byte=2):Extended;
var
  Multiplier:Cardinal;

begin
  if Num=0 then
    Result:=0
  else
    begin
      Multiplier:=PrecisionMultiplier(DecimalPrecision);
      Result:=Num*Multiplier;
      Result:=Round(Result)/Multiplier;
    end;
end;

function NumDigits(const aNum:integer): integer;
//used primarily to format output using List.Count
begin
  Result := Length(IntToStr(aNum));
end;

function ZeroToMax(Value:integer):integer;
begin
  if Value=0 then
    Result:=MaxLongint
  else
    Result:=Value;
end;

procedure CopyIfPrefixMatch(Source,Dest:TStrings; Prefix:string; ClearDest:boolean=true; ValuesOnly:boolean=false);
var
  Index,PrefixLen:integer;
  TempStr:string;

begin
  Assert(Assigned(Source));
  Assert(Assigned(Dest));
  if ClearDest then
    Dest.Clear;
  Prefix:=Uppercase(Prefix);
  PrefixLen:=length(Prefix);
  for Index:=0 to Source.Count-1 do
    if Uppercase(copy(Source[Index],1,PrefixLen))=Prefix then
      begin
        TempStr:=Source[Index];
        if ValuesOnly then
          TempStr:=StrAfter('=',TempStr);
        if Dest.IndexOf(TempStr)=-1 then
          Dest.Add(TempStr);
      end;
end;

function HexToChar(const aValue: byte): AnsiChar;
//Convert the value into a hex char.  '?' is unknown value
begin
  case aValue of
    0..9:
      Result := chr(ord('0')+aValue);
    10..15:
      Result := chr(ord('A')+aValue-10);
    else
      Result := '?';
  end;//case
end;

function CharToHex(const aValue: AnsiChar): byte;
//Convert the value from a hex char into the equivalent value, $FF is unknown value
begin
  case aValue of
    '0'..'9':
      Result := ord(aValue)-ord('0');
    'A'..'F':
      Result := ord(aValue)-ord('A')+10;
    else
      Result := $FF;
  end;//case
end;

function HexToText(const Source: AnsiString): AnsiString;
//Convert the string passed in into double its size where every byte = 2 human readable hex #s
var
  i: integer;
  TempByte: byte;
begin
  SetLength(Result,length(Source)*2);
  for i := length(Source) downto 1 do
  begin
    TempByte := ord(Source[i]);
    Result[(i*2)] := HexToChar(TempByte and $0F);
    TempByte := TempByte shr 4;
    Result[(i*2)-1] := HexToChar(TempByte);
  end;//for end to beginning
end;

function TextToHex(const Source: AnsiString): AnsiString;
//Convert the string passed in into half its size where every 2 chars = 1 byte value
var
  P: PChar;
  C, L, N: Integer;
  BL, BH: Byte;
  S: AnsiString;
begin
  Result := '';
  if Source <> '' then
  begin
    S := Source;
    L := Length(S);
    if Odd(L) then
    begin
      S := '0' + S;
      Inc(L);
    end;
    P := PChar(S);
    SetLength(Result, L div 2);
    C := 1;
    N := 0;
    while C <= L do
    begin
      BH := CharHex(P^);
      Inc(P);
      BL := CharHex(P^);
      Inc(P);
      Inc(C, 2);
      if (BH<>$FF) and (BL<>$FF) then
      begin
        Inc(N);
        Byte(Result[N]) := Byte((BH shl 4) + BL);
      end;
    end;
    SetLength(Result,N);
  end;
end;

procedure SaveGraphicToStream(aGraphic: TGraphic; aStream: TStream);
//save the classname, then the data to the stream
var
  ClassName: string;
  ClassNameLen: word;
begin
  if Assigned(aGraphic) and Assigned(aStream) then
  begin
    ClassName := aGraphic.ClassName;
    ClassNameLen := length(ClassName);
    aStream.Write(ClassNameLen,sizeof(ClassNameLen));
    aStream.Write(ClassName[1],ClassNameLen);
    aGraphic.SaveToStream(aStream);
  end;//if assigned
end;

function LoadGraphicFromStream(aStream: TStream): TGraphic;
//load the classname, then the data from the stream
var
  GraphicClass: TGraphicClass;
  ClassName: string;
  ClassNameLen: word;
begin
  Result := nil;
  if Assigned(aStream) then
  begin
    ClassNameLen := 0;
    aStream.Read(ClassNameLen, SizeOf(ClassNameLen));
    SetLength(ClassName,ClassNameLen);
    if (ClassNameLen>0) then
    begin
      aStream.Read(ClassName[1], ClassNameLen);
      try
        GraphicClass := TGraphicClass(FindClass(ClassName));
        Result := GraphicClass.Create;
      except
        Result := TBitmap.Create;
      end;//try-except
      Result.LoadFromStream(aStream);
    end;
  end;
  if (not Assigned(Result)) then
    Result := TBitmap.Create;
end;

function GraphicToText(aGraphic: TGraphic): string;
//convert the graphic to a string representation for easy storage
var
  TempStream: TStringStream;
begin
  Result := '';
  TempStream := TStringStream.Create('');
  try
    SaveGraphicToStream(aGraphic,TempStream);
    Result := HexToText(TempStream.DataString);
  finally
    FreeAndNil(TempStream);
  end;//try-finally
end;

function TextToGraphic(aGraphicAsText: string): TGraphic;
//convert a saved text representation back to graphic format
var
  TempStream: TStringStream;
begin
  TempStream := TStringStream.Create(TextToHex(aGraphicAsText));
  Result := LoadGraphicFromStream(TempStream);
  FreeAndNil(TempStream);
end;

function GetCustNameStr(aFirstName,aLastName: string): string;
begin
  Result:= '';
  if (aLastName <> '') then
    Result:= aLastName;
  if (Result <> '') and (aFirstName <> '') then
    Result:= Format('%s, %s',[Result,aFirstName]);
end;

function GetLongCustNameStr(aTitle,aFirstName,aLastName: string): string;
begin
  Result := Trim(aTitle+' '+aFirstName);
  Result := Trim(Result+' '+aLastName);
end;

function GetPriceFromMargin(const aMargin: string; aCost: currency): currency;
var
  Margin: Extended;
begin
  Result:=0;
  try
    Margin:= StrToFloat(StrRemoveChars(aMargin,['%']));
    if (Margin > 100) then
      Margin:= 100
    else
      if (Margin < -100) then
        Margin:= -100;
    if (Margin <> 100) then
    begin
      //formula works in pennies and then converts back to dollars and cents
      Result:= round(((aCost * 100) / (1 - (Margin / 100))) / 100);
    end;{if}
  except
    Result := 0;
  end;
end;

function GetMarginFromPrice(aPrice,aCost: currency): string;
var
  Margin: single;
begin
  if (aPrice<>0) then
    begin
      Margin:= (((aPrice - aCost) / aPrice) * 100);
      if (Margin > 100) then
        Margin:= 100
      else
        if (Margin < -100) then
          Margin:= -100;
    end{if}
  else
    begin
      Margin:= 0;
    end;{if-else}
  Result:= Format('%-3.2f',[Margin]);
end;

function GetDriveSerialNum(Path:string):longint;
var
  SerialNum:longint;
  SerialNumPtr:PDWord;
  FileSystemFlags,MaxComponentLength:Cardinal;
  DriveName:string;

begin
  SerialNumPtr:=@SerialNum;
  DriveName:=IncludePathDelimiter(ExtractFileDrive(Path));
  GetVolumeInformation(PChar(DriveName),nil,0,SerialNumPtr,
      MaxComponentLength,FileSystemFlags,nil,0);
  Result:=SerialNum;
end;

function GetCCCardTypeFromName(aCardName: string): integer;
var
  TempCardName: string;
begin
  Result:= 0;
  TempCardName:= UpperCase(aCardName);
  if (TempCardName <> '') then
  begin
    if (TempCardName = 'VISA') then
      Result:= 1
//    else if (copy(TempCardName,1,6) = 'MASTERCARD') then
    else if (copy(TempCardName,1,6) = 'MASTER') then
      Result:= 2
    else if (TempCardName = 'AMEX') then
      Result:= 3;
  end;{if}
end;

function GetItemMarginPercent(Price,Cost: Currency):double;
begin
  Result:= 0;
  if (Price <> 0) then
  begin
    Result:= (((Price - Cost) / Price) * 100);
    if (Result > 100) then
      Result:= 100
    else if (Result <- 100) then
      Result:= -100;
  end;{if}
end;

function ValidateCreditCard(aCardNum: string): boolean;
var
  CharPos,Number,Sum: integer;
begin
  Result:= false;
  if (aCardNum <> '') then
  begin
    // first lets remove all the trailing blanks
    aCardNum:= trim(aCardNum);
    // now delete any intervening blanks
    CharPos:= pos(' ',aCardNum);
    while (CharPos > 0) do
    begin
      delete(aCardNum,CharPos,1);
      CharPos:= pos(' ',aCardNum);
    end;{while}
    // make sure that all remaining chars are numbers
    Result:= true;
    for CharPos:= 1 to length(aCardNum) do
    begin
      if (not (aCardNum[CharPos]in ['0'..'9'])) then
      begin
        Result:= false;
        break;
      end;
    end;{for}
    // now add up the digits
    if (Result) then
    begin
      // Step 1: Starting from the second digit from the right and moving towards the
      // left, multiply every digit by 2 summing the resulting digits
      CharPos:= length(aCardNum)-1;
      Sum:= 0;
      while (CharPos > 0) do
      begin
        // get the digit value x 2
        Number:= (ord(aCardNum[CharPos]) - ord('0')) * 2;
        // number mod 10 = units digit, number div 10 = 10's digit
        Sum:= Sum + Number mod 10 + Number div 10;
        // go back 2 digits
        dec(CharPos,2);
      end;{while}
      // Step 2: Add digits not originally mutliplied by 2 to sum
      CharPos:= length(aCardNum);
      while (CharPos > 0) do
      begin
        Number:= (ord(aCardNum[CharPos]) - ord('0'));
        Sum:= Sum + Number;
        dec(CharPos,2);
      end;{while}
      // Step 3: result should  be a multiple of 10 if valid
      Result:= (Sum mod 10 = 0);
    end;{if}
  end;{if}
end;

function ValidateCreditCardRange(const aCardNum,aLowNum,aHighNum: string): boolean;
begin
  Result:= (aCardNum <> '') and
           ((aLowNum = '') or (aCardNum >= aLowNum)) and
           ((aHighNum = '') or (aCardNum <= aHighNum));
end;

function HHMMToTime(Value:string):TTime;
var
  Hour,Minute:integer;

begin
  Result:=0;
  if length(Value)>1 then
    begin
      if length(Value)=2 then
        Value:=Value+'00'
      else
        if length(Value)=3 then
          Value:='0'+Value;
      Hour:=StrToIntDef(copy(Value,1,2),0);
      Minute:=StrToIntDef(copy(Value,3,2),0);
      Result:=EncodeTime(Hour,Minute,0,0);
    end;
end;

function TimeToHHMMSS(Value:TTime):string;
var
  Hour,Minute,Second,Sec100:word;

begin
  DecodeTime(Value,Hour,Minute,Second,Sec100);
  Result:=Format('%2.2d%2.2d%2.2d',[Hour,Minute,Second]);
end;

function MMDDToDate(Value:string):TDate;
begin
  Result:=0;
  // Still needs to be implemented
end;

function DateToYYYYMMDD(Value:TDate):string;
var
  Year,Month,Day:word;

begin
  DecodeDate(Value,Year,Month,Day);
  Result:=Format('%4.4d%2.2d%2.2d',[Year,Month,Day]);
end;

function FontColorToString(SourceFont: TFont; SourceColor: TColor=clNone): string;
begin
  Result := '';
  if Assigned(SourceFont) then
  begin
    Result := Format('%s;%d;%s;%d;%d;%d;%d;%s',
        [SourceFont.Name,
         SourceFont.Size,
         ColorToString(SourceFont.Color),
         ord(fsBold in SourceFont.Style),
         ord(fsItalic in SourceFont.Style),
         ord(fsUnderline in SourceFont.Style),
         ord(fsStrikeout in SourceFont.Style),
         ColorToString(SourceColor)]);
  end;//if
end;

procedure StringToFont(aStr: string; DestFont: TFont);
var
  DummyColor: TColor;
begin
  DummyColor := clNone; //doesn't matter, but it's good to be in a known state
  StringToFontColor(aStr,DestFont,DummyColor);
end;

procedure StringToFontColor(aStr: string; DestFont: TFont; var DestColor: TColor);
var
  ValueList: TStringList;

  procedure SetFontStyle(ListIndex:integer; FontStyle:TFontStyle);
  begin
    if (ValueList[ListIndex]='1') then
      DestFont.Style := DestFont.Style+[FontStyle]
    else
      DestFont.Style := DestFont.Style-[FontStyle];
  end;

begin
  if Assigned(DestFont) then
  begin
    try
      ValueList:=TStringList.Create;
      CharReplace(aStr,';',#13);
      ValueList.Text:=aStr;
      if (ValueList.Count>=8) then
      begin
        DestFont.Name:=ValueList[0];
        DestFont.Size:=StrToIntDef(ValueList[1],DestFont.Size);
        try
          DestFont.Color := StringToColor(ValueList[2]);
        except
          //ignore any error
        end;//try-except
        SetFontStyle(3,fsBold);
        SetFontStyle(4,fsItalic);
        SetFontStyle(5,fsUnderline);
        SetFontStyle(6,fsStrikeout);
        try
          DestColor := StringToColor(ValueList[7]);
        except
          //ignore any error
        end;//try-except
      end;//if
    finally
      FreeAndNil(ValueList);
    end;//try-finally
  end;//if
end;

procedure ShowDebugStrings(DebugStrings:TStrings);
var
  DebugForm:TForm;
  Panel:TPanel;
  CloseButton:TButton;
  Memo:TMemo;

begin
  Application.CreateForm(TForm,DebugForm);
  try
    Panel:=TPanel.Create(DebugForm);
    Panel.Parent:=DebugForm;
    Panel.Align:=alBottom;
    Panel.BevelOuter:=bvNone;
    CloseButton:=TButton.Create(DebugForm);
    CloseButton.Parent:=Panel;
    CloseButton.Caption:='Close';
    CloseButton.Default:=true;
    CloseButton.ModalResult:=mrOK;
    CloseButton.Left:=(DebugForm.ClientWidth-CloseButton.Width) div 2;
    CloseButton.Top:=8;
    Memo:=TMemo.Create(DebugForm);
    Memo.Parent:=DebugForm;
    Memo.Align:=alClient;
    Memo.ScrollBars:=ssBoth;
    Memo.Font.Name:='Courier New';
    Memo.Lines.Assign(DebugStrings);
    DebugForm.ShowModal;
  finally
    FreeAndNil(DebugForm);
  end;
end;

procedure ShowStackDump;
var
  StackList:TJclStackInfoList;
  StackStrings:TStringList;

begin
  StackList:=JclCreateStackList(true,0,nil);
  StackStrings:=TStringList.Create;
  try
    StackList.AddToStrings(StackStrings);
    ShowDebugStrings(StackStrings);
  finally
    FreeAndNil(StackStrings);
  end;
end;

procedure RegisterFileExtension(const Extension,Description,DefaultActionName,DefaultActionDescription,DefaultActionCommand:string; IconIndex:integer);
var
  RegINIFile:TRegINIFile;

  function ReplaceAppName(const Param:string):string;
  var
    TokenPos:integer;

  begin
    Result:=Param;
    TokenPos:=pos('%0',Result);
    while TokenPos>0 do
      begin
        Result:=StrLeft(Result,TokenPos-1)+ParamStr(0)+StrRestOf(Result,TokenPos+2);
        TokenPos:=pos('%0',Result);
      end;
  end;

begin
  RegINIFile:=TRegINIFile.Create('');
  try
    RegINIFile.RootKey:=HKEY_CLASSES_ROOT;
    RegINIFile.WriteString('.'+Extension,'',Extension);
    RegINIFile.WriteString(Extension,'',ReplaceAppName(Description));
    RegINIFile.WriteString(Extension+'\DefaultIcon','',Format('%s,%d',[ParamStr(0),IconIndex]));
    RegINIFile.WriteString(Extension+'\Shell','',ReplaceAppName(DefaultActionName));
    RegINIFile.WriteString(Extension+'\Shell\'+DefaultActionName,'',ReplaceAppName(DefaultActionDescription));
    RegINIFile.WriteString(Extension+'\Shell\'+DefaultActionName+'\command','',ReplaceAppName(DefaultActionCommand));
  finally
    FreeAndNil(RegINIFile);
  end;
end;

function LaunchCommand(aCommand:string; aParams:string=''; WaitForTerminate:boolean=false): boolean;
var
  theLink: TShellLink;
  theWorkingFolder: string;
  hApp: HWND;
  WaitResult:DWORD;
  Info:TShellExecuteInfo;
  bBringToTop: boolean;
begin
  Result := false;
  theWorkingFolder := ExtractFilePath(aCommand);
  if (aCommand<>'') and (ShellLinkResolve(aCommand,theLink)=S_OK) then
  begin
    try//finally
      aCommand := theLink.Target;
      aParams := Trim(aParams+' '+theLink.Arguments);
      theWorkingFolder := theLink.WorkingDirectory;
    finally
      ShellLinkFree(theLink);
    end;//try-finally
  end;
  if (theWorkingFolder<>'') and (not DirectoryExists(theWorkingFolder)) then
    raise Exception.Create(Format('Folder ''%s'' does not exist.',[theWorkingFolder]));
  if (aCommand<>'') then
  begin
    bBringToTop := WaitForTerminate or (pos(cDoNotBringToTop,aParams)<=0);
    StrReplace(aParams,cDoNotBringToTop,'',[]);
    FillChar(Info, SizeOf(Info),#0);
    Info.cbSize:=SizeOf(Info);
    Info.Wnd := Application.Handle;
    Info.fMask:=SEE_MASK_NOCLOSEPROCESS;
    Info.lpVerb:=PChar(EmptyStr);
    Info.lpFile:=PChar(aCommand);
    Info.lpParameters:=PChar(aParams);
    Info.lpDirectory:=PChar(theWorkingFolder);
    Info.nShow:=SW_SHOWNORMAL;
    Result:=ShellExecuteEx(@Info);
    if Result then
    begin
      hApp:=Info.hProcess;
      if bBringToTop then
        BringWindowToTop(hApp);
      if WaitForTerminate then
      begin
        WaitResult:=WaitForSingleObject(hApp,100);
        while WaitResult=WAIT_TIMEOUT do
        begin
          Application.ProcessMessages;
          WaitResult:=WaitForSingleObject(hApp,100);
        end;
      end;
    end;
  end;
end;

function GetWindowsDirectoryStr:string;
var
  PathBuffer:TPathBuffer;

begin
  GetWindowsDirectory(PathBuffer,Max_Path);
  Result:=PathBuffer;
end;

function IsRemoteSession: boolean;
const
  sm_RemoteSession = $1000; //from WinUser.h
begin
  Result := (GetSystemMetrics(sm_RemoteSession)<>0);
end;

function IsWinXP: boolean;
//return TRUE if we are running on XP or a newer version. XP is Windows NT 5.1
begin
  Result := (SysUtils.Win32Platform=VER_PLATFORM_WIN32_NT) and
            ( (SysUtils.Win32MajorVersion > 5) or
              ( (SysUtils.Win32MajorVersion = 5) and
                (SysUtils.Win32MinorVersion > 0)
              )
            );
end;

function TextStreamWrite(var TextRec:TTextRec):integer; far;
begin
  TStreamData(Pointer(@TextRec.UserData)^).Stream.WriteBuffer(TextRec.BufPtr^,TextRec.BufPos);
  TextRec.BufPos:=0;
  Result:=0;
end;

function TextStreamRead(var TextRec:TTextRec):integer; far;
begin
  TextRec.BufEnd:=TStreamData(Pointer(@TextRec.UserData)^).Stream.Read(TextRec.BufPtr^,TextRec.BufSize);
  TextRec.BufPos:=0;
  Result:=0;
end;

function TextStreamOpen(var TextRec:TTextRec):integer; far;
begin
  if (TextRec.Mode=fmInput) then
    begin
      TextRec.InOutFunc:=@TextStreamRead;
      TextRec.FlushFunc:=nil;
      TStreamData(Pointer(@Textrec.UserData)^).Stream.Position:=0;
      Result:=0;
    end
  else
    if (TextRec.Mode=fmOutput) then
      begin
        TextRec.Mode:=fmOutput;
        TextRec.InOutFunc:=@TextStreamWrite;
        TextRec.FlushFunc:=@TextStreamWrite;
        TStreamData(Pointer(@TextRec.UserData)^).Stream.Position:=0;
        Result:=0;
      end
    else
      Result:=1;
end;

function TextStreamClose(var TextRec:TTextRec):integer; far;
begin
  TStreamData(Pointer(@TextRec.UserData)^).Stream.Position:=0;
  TextRec.InOutFunc:=nil;
  TextRec.FlushFunc:=nil;
  Result:=0;
end;

procedure AssignTextFileToStream(var ATextFile:TextFile; AStream:TStream);
var
  ATextRec:TTextRec absolute ATextFile;

begin
  ATextRec.Handle:=0;
  ATextRec.Mode:=fmClosed;
  ATextRec.BufSize:=SizeOf(ATextRec.Buffer);
  ATextRec.BufPos:=0;
  ATextRec.BufEnd:=0;
  ATextRec.BufPtr:=@ATextRec.Buffer;
  ATextRec.OpenFunc:=@TextStreamOpen;
  ATextRec.InOutFunc:=nil;
  ATextRec.FlushFunc:=nil;
  ATextRec.CloseFunc:=@TextStreamClose;
  ATextRec.Name[0]:=#0;
  TStreamData(Pointer(@ATextRec.UserData)^).Stream:=AStream;
end;

function DeleteFileMask(const Mask:string):boolean;
var
  SearchRec:TSearchRec;

begin
  Result:=false;
  if FindFirst(Mask,faAnyFile,SearchRec)=0 then
    begin
      Result:=true;
      repeat
        DeleteFile(IncludePathDelimiter(ExtractFilePath(Mask))+SearchRec.Name);
      until FindNext(SearchRec)<>0;
      FindClose(SearchRec);
    end;
end;

function FileMaskCount(const Mask:string):integer;
var
  SearchRec:TSearchRec;

begin
  Result:=0;
  if FindFirst(Mask,faAnyFile,SearchRec)=0 then
    begin
      repeat
        inc(Result);
      until FindNext(SearchRec)<>0;
      FindClose(SearchRec);
    end;
end;

function FileMaskExists(const Mask:string):boolean;
var
  SearchRec:TSearchRec;

begin
  Result:=false;
  if FindFirst(Mask,faAnyFile,SearchRec)=0 then
    begin
      Result:=true;
      FindClose(SearchRec);
    end;
end;

function FileMaskList(const Mask:string):string;
var
  SearchRec:TSearchRec;

begin
  Result:='';
  if FindFirst(Mask,faAnyFile,SearchRec)=0 then
    begin
      repeat
        if Result='' then
          Result:=SearchRec.Name
        else
          Result:=Result+';'+SearchRec.Name;
      until FindNext(SearchRec)<>0;
      FindClose(SearchRec);
    end;
end;

function FileMaskList(const Mask:string; Dest:TStrings; ClearList:boolean=true):boolean; overload;
var
  FileListStr:string;

begin
  Assert(Assigned(Dest));
  if ClearList then
    Dest.Clear;
  FileListStr:=FileMaskList(Mask);
  if FileListStr='' then
    Result:=false
  else
    begin
      Result:=true;
      StrToStrings(FileListStr,';',Dest);
    end;
end;

function GetSafeNumericVariant(Value:Variant):Variant;
begin
  try
    if VarIsEmpty(Value) or VarIsNull(Value) then
      Result:=0
    else
      Result:=Value;
  except
    on E:Exception do
      Result:=0;
  end;
end;

function GetPasswordCharStr(aStr: string): string;
begin
  //Result := StringOfChar('*',Length(aStr));
  //for more security, don't hint at the length of the password
  if (aStr<>'') then
    Result := StringOfChar('*',12)
  else
    Result := '';
end;

function GetDriversLicenseHeightDisplayText(aStr: string): string;
begin
  Result:= '';
  if (aStr <> '') and (aStr <> '0') then
  begin
    Result:= aStr;
    if (copy(Result,1,3) < '300') then
      Result:= Format('%s cm',[Result])
    else
      Result:= Format('%s'' %s"',[copy(Result,1,1),copy(Result,2,2)]);
  end;{if}
end;

function IncludePathDelimiter(const aFilePath: string): string;
begin
{$IFDEF DELPHI6UP}
  Result := IncludeTrailingPathDelimiter(aFilePath);
{$ELSE}
  Result := IncludeTrailingBackslash(aFilePath);
{$ENDIF}
end;

function ExcludePathDelimiter(const aFilePath: string): string;
begin
{$IFDEF DELPHI6UP}
  Result := ExcludeTrailingPathDelimiter(aFilePath);
{$ELSE}
  Result := ExcludeTrailingBackslash(aFilePath);
{$ENDIF}
end;

{$IFNDEF DELPHI6UP}
function GetEnvironmentVariable(const Name: string): string;
begin
  Result := '';
  if not GetEnvironmentVar(Name,Result,true) then
    Result := '';
end;
{$ENDIF}

function ArrayToStr(SourceArray:array of string; Separator:AnsiChar):string;
var
  Index:integer;

begin
  Result:='';
  for Index:=0 to High(SourceArray) do
    if Index=0 then
      Result:=SourceArray[Index]
    else
      Result:=Result+';'+SourceArray[Index];
end;

function psStrReplace(var S: AnsiString; const Search, Replace: AnsiString; Flags: TReplaceFlags = []):boolean;
var
  OrigStr:string;

begin
  OrigStr:=S;
  StrReplace(S,Search,Replace,Flags);
  Result:=(OrigStr<>S);
end;

function StrReplaceInStrings(StrObject:TStrings; const Search, Replace: AnsiString; Flags: TReplaceFlags = []):boolean;
var
  Index:integer;
  TempStr:string;

begin
  Result:=false;
  Assert(Assigned(StrObject));
  for Index:=0 to StrObject.Count-1 do
    begin
      TempStr:=StrObject[Index];
      if psStrReplace(TempStr,Search,Replace,Flags) then
        begin
          Result:=true;
          StrObject[Index]:=TempStr;
          if not (rfReplaceAll in Flags) then
            Break;
        end;
    end;
end;

procedure ShowMessage(aMsg: string);
begin
  if Assigned(Screen) and Assigned(Screen.ActiveForm) then
    StandardUserQuery(aMsg,MB_IconInformation+MB_Ok)
  else
    Dialogs.ShowMessage(aMsg);
end;

procedure ShowErrorMessage(aMsg: string);
begin
  if Assigned(Screen) and Assigned(Screen.ActiveForm) then
    StandardUserQuery(aMsg,MB_IconError+MB_Ok)
  else
    Dialogs.ShowMessage(aMsg);
end;

function StandardUserQuery(aMsg: string; DialogType: cardinal=0; DialogCaption: string=''): cardinal;
var
  aHandle: THandle;
begin
  if Assigned(Screen) and Assigned(Screen.ActiveForm) then
    aHandle := Screen.ActiveForm.Handle
  else
    aHandle := 0;
  if (DialogType=0) then
    DialogType := MB_ICONQUESTION+MB_YESNO+MB_DEFBUTTON1;
  if (DialogCaption='') then
  begin
    case (MB_ICONMASK and DialogType) of
      MB_ICONINFORMATION: DialogCaption := 'Information';
      MB_ICONERROR      : DialogCaption := 'Error';
      MB_ICONQUESTION   : DialogCaption := 'Confirm';
      MB_ICONWARNING    : DialogCaption := 'Warning';
    else
      DialogCaption := ChangeFileExt(ExtractFileName(ParamStr(0)),'');
    end;//case
  end;//if capiton=''
  Result := MessageBox(aHandle,PChar(aMsg),PChar(DialogCaption),DialogType);
end;

function ParamValue(ParamName:string):string;
var
  Index:integer;
  Param:string;

begin
  Result:='';
  ParamName:=Uppercase(ParamName);
  for Index:=1 to ParamCount do
    begin
      Param:=Uppercase(ParamStr(Index));
      if (copy(Param,1,1)='/') or (copy(Param,1,1)='-') then
        Param:=StrRestOf(Param,2);
      if (pos('=',Param)>0) and (StrBefore('=',Param)=ParamName) then
        begin
          Result:=StrAfter('=',Param);
          Break;
        end
      else
        if (pos(':',Param)>0) and (StrBefore(':',Param)=ParamName) then
          begin
            Result:=StrAfter(':',Param);
            Break;
          end
    end;
end;

function ParamFlagSet(ParamName:string):boolean;
var
  Index:integer;
  Param:string;

begin
  Result:=false;
  ParamName:=Uppercase(ParamName);
  for Index:=1 to ParamCount do
    begin
      Param:=Uppercase(ParamStr(Index));
      if (copy(Param,1,1)='/') or (copy(Param,1,1)='-') then
        Param:=StrRestOf(Param,2);
      if (StrBefore('=',Param)=ParamName) or (StrBefore(':',Param)=ParamName) then
        begin
          Result:=true;
          Break;
        end;
    end;
end;

function ConcatenateNonBlanks(Strings: array of string): string;
var
  StringIndex,LowStringIndex,HighStringIndex: integer;
begin
  LowStringIndex:= Low(Strings);
  HighStringIndex:= High(Strings);
  Result:= Strings[LowStringIndex];
  for StringIndex:=LowStringIndex to HighStringIndex do
  begin
    if (Result <> '') and (StringIndex > 0) then
      Result:= Format('%s %s',[Result,Strings[StringIndex]])
    else
      Result:= Strings[StringIndex];
  end;{for}
end;

function ConcatenateWithDelimiter(Strings: array of string; Delimiter: PChar): string;
var
  StringIndex,LowStringIndex,HighStringIndex: integer;
begin
  Result:= '';
  LowStringIndex:= Low(Strings);
  HighStringIndex:= High(Strings);
  for StringIndex:=LowStringIndex to HighStringIndex do
  begin
    if (Result = '') then
      Result:= Strings[StringIndex]
    else
      Result:= Result+Delimiter+Strings[StringIndex];
  end;{for}
end;

function GetMaxStringLength(Strings: array of string): integer;
var
  StringIndex,LowStringIndex,HighStringIndex: integer;
begin
  LowStringIndex:= Low(Strings);
  HighStringIndex:= High(Strings);
  Result:= length(Strings[LowStringIndex]);
  for StringIndex:=LowStringIndex to HighStringIndex do
    Result:= Max(Result,length(Strings[StringIndex]));
end;

procedure PlayBeep(BeepActionType: TMsgDlgType; NumBeeps: integer=1; MSDelay: integer=DefaultBeepDelay);
var
  mb: dWord;
  i: integer;
begin
  case BeepActionType of
    mtInformation  : mb:= MB_ICONASTERISK;    //SystemAsterisk
    mtWarning      : mb:= MB_ICONEXCLAMATION; //SystemExclamation
    mtError        : mb:= MB_ICONHAND;        //SystemHand
    mtConfirmation : mb:= MB_ICONQUESTION;    //SystemQuestion
    mtCustom       : mb:= $0FFFFFFFF;         //Standard beep using the computer speaker
  else
    mb:= MB_OK;                               //SystemDefault
  end;
  for i:=0 to (max(1,NumBeeps) - 1) do
  begin
    MessageBeep(mb);
    sleep(MSDelay);
  end;{for}
end;

function DelTree(const DirectoryName: string): Boolean;
var
  DrivesPathsBuff: array[0..1024] of char;
  DrivesPaths: string;
  len: longword;

      procedure RecursiveDelTree(const Directory: TFileName);
      // Recursively deletes all files and directories
      // inside the directory passed as parameter.
      var
        SearchRec: TSearchRec;
        Attributes: LongWord;
        ShortName,FullName: TFileName;
        pname: pchar;
      begin
        if FindFirst(Directory + '*.*', faAnyFile and not faVolumeID, SearchRec) = 0 then
        begin
          try
            repeat // Processes all files and directories
              if (SearchRec.FindData.cAlternateFileName[0] = #0) then
                ShortName:= SearchRec.Name
              else
                ShortName:= SearchRec.FindData.cAlternateFileName;
              FullName:= Directory + ShortName;
              if (SearchRec.Attr and faDirectory) <> 0 then // It's a directory
                begin
                  if (ShortName <> '.') and (ShortName <> '..') then
                    RecursiveDelTree(IncludePathDelimiter(FullName));
                end
              else // It's a file
                begin
                  pname:= PChar(FullName);
                  Attributes:= GetFileAttributes(pname);
                  if (Attributes = $FFFFFFFF) then
                    raise EInOutError.Create(SysErrorMessage(GetLastError));
                  if (Attributes and FILE_ATTRIBUTE_READONLY) <> 0 then
                    SetFileAttributes(pname,Attributes and not FILE_ATTRIBUTE_READONLY);
                  if Windows.DeleteFile(pname) = false then
                    raise EInOutError.Create(SysErrorMessage(GetLastError));
                end;{if-else}
            until
              FindNext(SearchRec) <> 0;
          except
            FindClose(SearchRec);
            raise;
          end;{try-except}
          FindClose(SearchRec);
        end;{if}
        if (Pos(#0 + Directory + #0, DrivesPaths) = 0) then
        begin
          // if not a root directory, remove it
          pname:= PChar(Directory);
          Attributes:= GetFileAttributes(pname);
          if (Attributes = $FFFFFFFF) then
            raise EInOutError.Create(SysErrorMessage(GetLastError));
          if ((Attributes and FILE_ATTRIBUTE_READONLY) <> 0) then
            SetFileAttributes(pname,Attributes and not FILE_ATTRIBUTE_READONLY);
          RmDir(ExcludePathDelimiter(pname));
        end;{if}
      end;

begin
  try
    DrivesPathsBuff[0]:= #0;
    len:= GetLogicalDriveStrings(1022, @DrivesPathsBuff[1]);
    if (len = 0) then
      raise EInOutError.Create(SysErrorMessage(GetLastError));
    SetString(DrivesPaths,DrivesPathsBuff,len + 1);
    DrivesPaths:= Uppercase(DrivesPaths);
    RecursiveDelTree(IncludePathDelimiter(DirectoryName));
    Result:= true;
  except
    Result:= false;
  end;{try-except}
end;

procedure UpdateActionCaption(anAction: TAction; aCaption: string);
begin
  if (Assigned(anAction)) then
    anAction.Caption:= aCaption;
end;

procedure GetDirectoryList(const DirectoryName: string; StringList: TStrings);
var
  Directory: string;
  SearchRec: TSearchRec;
  ShortName,FullName: TFileName;
begin
  if (Assigned(StringList)) then
  begin
    Directory:= IncludePathDelimiter(DirectoryName);
    if FindFirst(Directory + '*.*', faAnyFile and not faVolumeID, SearchRec) = 0 then
    begin
      try
        repeat // Processes all files and directories
          if (SearchRec.FindData.cAlternateFileName[0] = #0) then
            ShortName:= SearchRec.Name
          else
            ShortName:= SearchRec.FindData.cAlternateFileName;
          FullName:= Directory + ShortName;
          if (SearchRec.Attr and faDirectory) <> 0 then // It's a directory
          begin
            if (ShortName <> '.') and (ShortName <> '..') then
              StringList.Add(ShortName);
          end;{if}
        until
          FindNext(SearchRec) <> 0;
      except
        FindClose(SearchRec);
        raise;
      end;{try-except}
      FindClose(SearchRec);
    end;{if}
  end;{if}
end;

function DecodePath(const Path:string; PathVars:TStrings):string;
var
  Index:integer;
  VarName,VarValue:string;

begin
  Result:=Path;
  if Assigned(PathVars) then
    for Index:=0 to PathVars.Count-1 do
      begin
        VarName:=PathVars.Names[Index];
        VarValue:=PathVars.ValueFromIndex[Index];
        Result:=StringReplace(Result,VarName,VarValue,[rfReplaceAll,rfIgnoreCase]);
      end;
end;

function GetBackupFilename(const OrigFilename:string):string;
var
  OrigExt,BackupExt:string;

begin
  OrigExt:=ExtractFileExt(OrigFilename);
  if OrigExt='' then
    BackupExt:='.~'
  else
    BackupExt:=StrLeft(OrigExt,1)+'~'+StrRestOf(OrigExt,2);
  Result:=ChangeFileExt(OrigFilename,BackupExt);
end;

function GetRestoreFilename(const BackupFilename:string):string;
var
  BackupExt:string;

begin
  BackupExt:=ExtractFileExt(BackupFilename);
  if (BackupExt='') or (pos('~',BackupExt)=0) then
    Result:=''
  else
    begin
      BackupExt:=StrRemoveChars(BackupExt,['~']);
      Result:=ChangeFileExt(BackupFilename,BackupExt);
    end;
end;

function MakeBackupFile(const OrigFilename:string; OverwriteExisting:boolean):string;
var
  BackupFilename:string;

begin
  Result:='';
  if FileExists(OrigFilename) then
    begin
      BackupFilename:=GetBackupFilename(OrigFilename);
      if BackupFilename<>'' then
        if OverwriteExisting or FileExists(BackupFilename) then
          begin
            Result:=BackupFilename;
            if FileExists(BackupFilename) then
              DeleteFile(BackupFilename);
            CopyFile(PChar(OrigFilename),PChar(BackupFilename),false);
          end;
    end;
end;

function RestoreBackupFile(const BackupFilename:string; OverwriteExisting:boolean):string;
var
  OrigFilename:string;

begin
  Result:='';
  if FileExists(BackupFilename) then
    begin
      OrigFilename:=GetRestoreFilename(BackupFilename);
      if OrigFilename<>'' then
        if OverwriteExisting or (not FileExists(OrigFilename)) then
          begin
            if FileExists(OrigFilename) then
              DeleteFile(OrigFilename);
            CopyFile(PChar(BackupFilename),PChar(OrigFilename),false);
          end;
    end;
end;

function CalcDistance(Lat1, Long1, Lat2, Long2: double): double;
const
  EarthRadiusInMiles = 3956.0;
  EarthRadiusInKms = 6376.5;
var
  Lat1InRad: double;
  Long1InRad: double;
  Lat2InRad: double;
  Long2InRad: double;
  Longitude: double;
  Latitude: double;
  a: double;
  c: double;
begin
  {
      The Haversine formula according to Dr. Math.
      http://mathforum.org/library/drmath/view/51879.html

      dlon = lon2 - lon1
      dlat = lat2 - lat1
      a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
      c = 2 * atan2(sqrt(a), sqrt(1-a))
      d = R * c

      Where
          * dlon is the change in longitude
          * dlat is the change in latitude
          * c is the great circle distance in Radians.
          * R is the radius of a spherical Earth.
          * The locations of the two points in
              spherical coordinates (longitude and
              latitude) are lon1,lat1 and lon2, lat2.
  }

  Lat1InRad := Math.DegToRad(Lat1);
  Long1InRad := Math.DegToRad(Long1);
  Lat2InRad := Math.DegToRad(Lat2);
  Long2InRad := Math.DegToRad(Long2);

  Longitude := Long2InRad - Long1InRad;
  Latitude := Lat2InRad - Lat1InRad;

  //intermediate result a
  a := Math.Power(Sin(Latitude / 2.0), 2.0) +
    Cos(Lat1InRad) * Cos(Lat2InRad) * Math.Power(Sin(Longitude / 2.0), 2.0);

  //intermediate result c (great circle distance in Radians).
  c := 2.0 * Math.ArcTan2(Sqrt(a), Sqrt(1.0 - a));

  Result := EarthRadiusInMiles * c;
end;

function GetDelimiterCount(aString,aDelimiter: string): integer;
begin
  Result:= StrStrCount(aString,aDelimiter)
end;

function KillEXE(ExeName: String): Boolean;
var
  aProcesses: Array[0..1023] of DWORD;
  cbNeeded: DWORD;
  cProcesses: DWORD;
  i: Integer;
  szProcessName: Array[0..MAX_PATH-1] of Char;
  hProcess: THandle;
  hMod: HModule;
begin
  Result:= False;

  if (not EnumProcesses(@aProcesses, sizeof(aProcesses), cbNeeded)) then exit;

  cProcesses:= cbNeeded div sizeof(DWORD);
  for i:= 0 to (cProcesses - 1) do
  begin
    hProcess:= OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ or PROCESS_TERMINATE,False,aProcesses[i]);
    if (hProcess <> 0) then
    begin
      if (EnumProcessModules(hProcess,@hMod,sizeof(hMod),cbNeeded)) then
      begin
        GetModuleBaseName(hProcess,hMod,szProcessName,sizeof(szProcessName));
        if (UpperCase(szProcessName) = UpperCase(ExeName)) then
          Result:= TerminateProcess(hProcess,0);
      end;{if}
    end;{if}
    CloseHandle(hProcess);
  end;{for}
end;

function GetWindowsDefaultPrinterName: string;
var
  aPrinter: TPrinter;
begin
  Result:= '';
  aPrinter:= TPrinter.Create;
  try
    aPrinter.PrinterIndex:= -1;
    Result:= aPrinter.Printers[aPrinter.PrinterIndex];
  finally
    FreeAndNil(aPrinter);
  end;{try-finally}
end;

initialization
  Classes.RegisterClass(TBitmap);
finalization
  SetLength(ScreenCursorStack,0);
  ScreenCursorStackTop := 0;
end.

