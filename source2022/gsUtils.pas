{ --------------------------------------------------------- }
{ MetaBase                                                  }
{ Copyright (c) 1996-2002 by gs-soft ag                     }
{                                                           }
{ All rights reserved. Adapted to maXbox 2011               }
{ --------------------------------------------------------- }
//{$I gs.inc}
unit gsUtils;

interface

uses Wintypes, WinProcs, SysUtils, Dialogs, Classes, graphics;

{ --- Message dialog routines --- }
procedure S_IBox(const AText: string);
procedure S_EBox(const AText: string);
{function  S_DBox(const AText: string): integer;
function  S_DBoxYesNo(const AText: string):integer;
function  S_DBoxYesNoYesToAll(const AText: string):integer;
function  S_DBoxOkCancel(const AText: string):integer;
function  S_DBoxOkAbort(const AText: string):integer;}
function  S_WBox(const AText: string): integer;
//function  S_WDBoxYesNo(const AText: string): integer;


{ --- Message dialog routines with Resource-strings and arguments --- }
function  GetResStringChecked(Ident: string; const Args: array of const): string;

{ --- string manipulation routines --- }
function  S_StrToReal(const cStr: string; var R: Double): Boolean;
function  S_RTrim(const cStr: string): string;
function  S_RTrimCopy(const cStr: string; iPos, iLen: integer): string;
function  S_LTrim(const cStr: string): string;
function  S_AllTrim(const cStr: string): string;
function  S_Empty(const cStr: string): boolean;
function  S_Cut(const cStr: string; const iLen: integer): string;
function  S_AtRepl(const cAT, cStr, cRepl: string): string;
function  S_ReplFirst(const cAT, cStr, cRepl: string): string;
function  S_Space(const iLen: integer): String;
function  S_RepeatChar(const iLen: integer; const AChar: Char): String;
procedure S_ReplaceChar(var cStr: string; cOldChr, cNewChr: char);
procedure S_ReplaceStringInFile(AFileName: string; ASearchString,AReplaceString: string);
function  S_StrBlanks(const cStr: string; const iLen: integer): string;
function  S_StrBlanksCuttooLong(const cStr: string; const iLen: integer): string;
function  S_StrLBlanks(const cStr: string; const iLen: integer): string;
procedure S_TokenInit(cBuffer: PChar; const cDelimiters: string);
function  S_TokenEnd(cBuffer: PChar; lEmptyToken: boolean):  boolean;
function  S_TokenNext(cBuffer: PChar; lEmptyToken: boolean): string;
function  S_AddBackSlash(const ADirName : string) : string;
function  Buf2HexStr(ABuffer: Pointer; ABufLen: integer; AAddSpaces: Boolean): string;
function  LastPos(const ASubstr: string; const AStr: string): Integer;
function  DelSpace(const pStr: string): string;
function  DelChar(const pStr: string; const pChar: Char): string;
function  DelString(const pStr, pDelStr: string): string;
procedure DeleteString(var pStr: String; const pDelStr: string);
function  PadL(pStr: String; pLth: integer): String;
function  PadR(pStr: String; pLth: integer): String;
function  PadLCh(pStr: String; pLth: integer; pChr: char): String;
function  PadRCh(pStr: String; pLth: integer; pChr: char): String;
function  GetReadableName(const AName: string): string;
function  GetNextDelimitedToken(const cDelim: char; var cStr: String): String;
function  GetLastDelimitedToken(const cDelim: char; const cStr: string): string;
function  GetFirstDelimitedToken(const cDelim: char; const cStr: string): string;
function  CompareTextLike(cWildStr, cStr: string; const cWildChar: char;
                          lCaseSensitive: boolean): boolean;
function MaskString(Mask,Value:String):String;
function UnMaskString(Mask,Value:String):String;
function StrToFloatRegionalIndependent(aValue:String; aDecimalSymbol: Char; aDigitGroupSymbol: Char):Extended;
function S_UTF_8ToString(const AString: string): string;
function S_StringtoUTF_8(const AString: string): string;

{ --- Stream routines --- }
function S_ReadNextTextLineFromStream(stream: TStream): string;
function Stream2WideString(oStream:TStream): WideString;
procedure WideString2Stream(aWideString: WideString;oStream:TStream);

{ --- Miscellaneous routines --- }
procedure S_AddMessageToStrings(AMessages: TStrings; AMsg: string);
function BitmapsAreIdentical(ABitmap1, ABitmap2: TBitmap): Boolean;
procedure SimulateKeystroke(Key : byte; Shift : TShiftState);
procedure WaitMiliSeconds(AMSec: word);


{ --- Application routines --- }
procedure GetApplicationsRunning(Strings: TStrings);
function IsApplicationRunning(const AClassName, ApplName: string): Boolean;
function IsDelphiRunning: boolean;
function IsDelphiDesignMode: boolean;

{ --- File name routines --- }
function AddFileExtIfNecessary(AFileName, AExt: string): string;


{ --- Binary routines --- }
function BinaryToDouble(ABinary: string; DefValue: Double): Double;

{ --- Float routines --- }
function S_RoundDecimal(AValue: Extended; APlaces: Integer): Extended;
function S_LimitDigits(AValue: Extended; ANumDigits: Integer): Extended;

{ --- CRC routines --- }
function S_StrCRC32(const Text: string): LongWORD;
function S_EncryptCRC32(const crc: LongWORD; StartKey, MultKey, AddKey: integer): string;
function S_DecryptCRC32(const crc: string; StartKey, MultKey, AddKey: integer): integer;
{ - Make the following routines visible if you want to calculate a CRC by hand
function S_CRCbegin: DWORD;
function S_CRC32(value: Byte; crc: DWORD): DWORD;
function S_CRCend(crc: DWORD): DWORD;
}

{ --- Encryption/Decryption routines --- }
procedure S_GetEncryptionKeys(DateTime1, DateTime2: TDateTime; var StartKey: integer; var MultKey: integer; var AddKey: integer);
function S_StrEncrypt96(const InString: string; StartKey, MultKey, AddKey: Integer): string;
function S_StrDecrypt96(const InString: string; StartKey, MultKey, AddKey: Integer): string;


{ --- system routines ---- }
function GetWindowsUserID: string;
function GetWindowsComputerID: string;
function GetEnvironmentVar(const AVariableName: string): string;
function S_DirExists(const ADir: string): Boolean;
function S_LargeFontsActive:Boolean;

{ --- Shell Execute ---- }
type
  TS_ShellExecuteCmd = (seCmdOpen,seCmdPrint,seCmdExplore);

function S_ShellExecute(aFilename: string; aParameters: string; aCommand: TS_ShellExecuteCmd): string;

{ --- some object routines --- }
type
  TObjectPtr = ^TObject;

procedure S_FreeAndNilObject(oObj: TObjectPtr);


implementation

uses TypInfo, MMSystem, Messages, Controls, ShellApi, forms, math, FileCtrl, fmain;
   //, fmain, IFSI_WinForm1puzzle;

const
  C_TokenInit   = chr(255);
  C_TokenOk     = chr(254);
  C_MB_ErrorServiceNotAllowed =  'is not allowed in a service';

resourceString
  sMb_NoTempDir = 'Environment variable %S or %S does not exist or does not point to a valid directory!'+#13#10+
                  'Please inform your System Administrator to set the environment variable TEMP to a local directory.';

const
  sMb_OutOfMemory            ='The operating system is out of memory or resources.';
  sMb_ERROR_FILE_NOT_FOUND   ='The specified file was not found.';
  sMb_ERROR_PATH_NOT_FOUND   ='The specified path was not found.';
  sMb_ERROR_BAD_FORMAT       ='The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).';
  sMb_SE_ERR_ACCESSDENIED    ='The operating system denied access to the specified file.';
  sMb_SE_ERR_ASSOCINCOMPLETE ='The filename association is incomplete or invalid.';
  sMb_SE_ERR_DDEBUSY         ='The DDE transaction could not be completed because other DDE transactions were being processed.';
  sMb_SE_ERR_DDEFAIL         ='The DDE transaction failed.';
  sMb_SE_ERR_DDETIMEOUT      ='The DDE transaction could not be completed because the request timed out.';
  sMb_SE_ERR_DLLNOTFOUND     ='The specified dynamic-link library was not found.';
  sMb_SE_ERR_FNF             ='The specified file was not found.';
  sMb_SE_ERR_NOASSOC         ='There is no application associated with the given filename extension.';
  sMb_SE_ERR_OOM             ='There was not enough memory to complete the operation.';
  sMb_SE_ERR_PNF             ='The specified path was not found.';
  sMb_SE_ERR_SHARE           ='A sharing violation occurred.';
  sMb_HexBuf2StrWrongHex     ='wrong hex buffer to convert';


{ ---------------------------------------------------------------------------- }
{ --- Message dialog routines with Resource-strings and arguments ------------ }
{ ---------------------------------------------------------------------------- }


{ --- S_IBox ----------------------------------------------------------------- }
procedure S_IBox(const AText:string);
begin
  {if RunAsService then
    RunAsServiceLogMgs(AText)
  else}
    MessageDlg(AText, mtInformation, [mbOk], 0);
end;

{ --- S_EBox ----------------------------------------------------------------- }
procedure S_EBox(const AText:string);
begin
 { if RunAsService then
    RunAsServiceLogMgs(AText)
  else}
    MessageDlg(AText, mtError, [mbOk], 0);
end;

{ --- S_WBox ----------------------------------------------------------------- }
function S_WBox(const AText:string):integer;
begin
  Result:= 0;
  {if RunAsService then
    RunAsServiceLogMgs(AText)
  else}
    Result:= MessageDlg(AText, mtWarning, [mbOk], 0);
end;

{ --- S_DBox ----------------------------------------------------------------- }
function  S_DBox(const AText:string):integer;
begin
  {if RunAsService then
    MetabaseError('S_DBox '+C_MB_ErrorServiceNotAllowed+#13+#10+AText);}
  Result:= MessageDlg(AText, mtConfirmation, mbYesNoCancel, 0);
end;

{ --- S_DBoxYesNo ------------------------------------------------------------ }
function  S_DBoxYesNo(const AText:string):integer;
begin
 { if RunAsService then
    MetabaseError('S_DBoxYesNo '+C_MB_ErrorServiceNotAllowed+#13+#10+AText);}
  Result:= MessageDlg(AText, mtConfirmation, [mbYes,mbNo], 0);
end;

{ ---------------------------------------------------------------------------- }
function  S_DBoxYesNoYesToAll(const AText: string):integer;
begin
 { if RunAsService then
    MetabaseError('S_DBoxYesNoYesToAll '+C_MB_ErrorServiceNotAllowed+#13+#10+AText);}
  Result:= MessageDlg(AText, mtConfirmation, [mbYes,mbNo,mbYesToAll], 0);
end;

{ --- S_DBoxNoYesOkCancel ---------------------------------------------------- }
function  S_DBoxOkCancel(const AText:string):integer;
begin
{  if RunAsService then
    MetabaseError('S_DBoxOkCancel '+C_MB_ErrorServiceNotAllowed+#13+#10+AText);}
  Result:= MessageDlg(AText, mtConfirmation, mbOkCancel, 0);
end;

{ --- S_DBoxNoYesOkAbort ---------------------------------------------------- }
function  S_DBoxOkAbort(const AText:string):integer;
begin
 { if RunAsService then
    MetabaseError('S_DBoxOkAbort '+C_MB_ErrorServiceNotAllowed+#13+#10+AText);}
  Result:= MessageDlg(AText, mtConfirmation, [mbOk,mbAbort], 0);
end;


{ Returns ResourceString ----------------------------------------------------- }
function GetResStringChecked(Ident: string; const Args: array of const): string;
begin
  try
    FmtStr(Result, Ident, Args);
  except
    { silent exception }
  end;
  if Result=EmptyStr then
    Result:=Ident;
end;

                                                                               
{ ---------------------------------------------------------------------------- }
{ --- string manipulation routines ------------------------------------------- }
{ ---------------------------------------------------------------------------- }

{ --- S_StrToReal ------------------------------------------------------------ }
function  S_StrToReal(const cStr: string; var R: Double): Boolean;
var
  Code: integer;
begin
  Val(Trim(cStr), R, Code);
  Result:= Code=0;
  if not Result then R:= Code;
end;

{ --- S_RTrim----------------------------------------------------------------- }
function S_RTrim(const cStr: string): string;
begin
  Result:=TrimRight(cStr);
end;

{ --- S_RTrimCopy ------------------------------------------------------------ }
function S_RTrimCopy(const cStr: string; iPos, iLen: integer): string;
Begin
  Result:=S_RTrim(Copy(cStr,iPos,iLen));
end;

{ --- S_LTrim ---------------------------------------------------------------- }
function S_LTrim(const cStr: string): string;
begin
  Result:=TrimLeft(cStr);
end;

{ --- S_AllTrim -------------------------------------------------------------- }
function S_ALLTRIM(const cStr:string): string;
begin
  Result:=Trim(cStr);
end;

{ --- S_AtRepl --------------------------------------------------------------- }
function  S_AtRepl(const cAT,cStr,cRepl:string): string;
var
  iPos: integer;
begin
  Result:= cStr;
  repeat
    iPos:= Pos(cAT, Result);
    if iPos>0 then
      Result:=copy(Result, 1, iPos-1)+cRepl+copy(Result,iPos+Length(cAT), Length(Result));
  until iPos=0;
end;
{ ---S_ReplFirst-------------------------------------------------------------- }
function  S_ReplFirst(const cAT, cStr, cRepl: string): string;
var
  iPos: integer;
begin
  Result:= cStr;
  iPos:= Pos(cAT, Result); 
  if iPos>0 then
    Result:=copy(Result, 1, iPos-1)+cRepl+copy(Result,iPos+Length(cAT), Length(Result));
end;
{ --- S_Empty ---------------------------------------------------------------- }
function S_Empty(const cStr:string): boolean;
begin
  { for speed }
  if Length(cStr)=0 then
  begin
    Result:= True;
    exit;
  end;
  Result:= Length(S_RTrim(cStr))=0;
end;

{ --- S_Cut ------------------------------------------------------------------ }
function  S_Cut(const cStr:string; const iLen:integer):string;
begin
  Result:= cStr;
  if length(cStr)>iLen then Delete(Result, iLen+1, length(cStr)-iLen);
end;

{ --- S_Space ---------------------------------------------------------------- }
function S_Space(const iLen:integer): String;
Var
  i: integer;
begin
  SetLength(Result, iLen);
  for i:=1 to iLen do Result[i]:=' ';
end;

{ --- S_RepeatChar ----------------------------------------------------------- }
function  S_RepeatChar(const iLen:integer; const AChar:Char):String;
Var
  i: integer;
begin
  SetLength(Result,iLen);
  for i:=1 to iLen do Result[i]:=AChar;
end;

{ --- S_ReplaceChar ---------------------------------------------------------- }
procedure S_ReplaceChar(var cStr: string; cOldChr, cNewChr: char);
var
  i: integer;
begin
  for i:= 1 to Length(cStr) do
    if cStr[i]=cOldChr then cStr[i]:= cNewChr;
end;

{ ---------------------------------------------------------------------------- }
procedure S_ReplaceStringInFile(AFileName: string; ASearchString,AReplaceString: string);
var
  oSrcFileStream: TFileStream;
  oTrgFileStream: TFileStream;
  cSrcName: string;
  cTrgName: string;
  cCheckByte: Char;
  cBuffer: string;
  iCheckCounter: integer;
  iReplaceStringLength: integer;
begin
  cTrgName:= AFileName;
  cSrcName:= AFileName+'_$$$';
  RenameFile(cTrgName,cSrcName);
  iReplaceStringLength:= Length(AReplaceString);
  oSrcFileStream:= TFileStream.Create(cSrcName,fmOpenRead or fmShareDenyWrite);
  try
    oTrgFileStream:=TFileStream.Create(cTrgName,fmCreate or fmShareDenyWrite);
    try
      oTrgFileStream.Position:=0;
      iCheckCounter:= 0;
      cBuffer:='';
      repeat
        oSrcFileStream.Read(cCheckByte,sizeOf(cCheckByte));
        if cCheckByte = ASearchString[iCheckCounter+1] then
        begin
          cBuffer:= cBuffer+cCheckByte;
          inc(iCheckCounter);
          if cBuffer = ASearchString then
          begin
            iCheckCounter:= 0;
            cBuffer:='';
            if iReplaceStringLength > 0 then
              oTrgFileStream.Write(AReplaceString[1],iReplaceStringLength);
          end;
        end else
        begin
          if cBuffer <>'' then
          begin
            oTrgFileStream.Write(cBuffer[1],length(cBuffer));
            cBuffer:='';
          end;
          iCheckCounter:= 0;
          oTrgFileStream.Write(cCheckByte,sizeOf(cCheckByte));
        end;
      until oSrcFileStream.Position>= oSrcFileStream.Size;
      if cBuffer <>'' then
        oTrgFileStream.Write(cBuffer[1],length(cBuffer));
    finally
      oTrgFileStream.Free;
    end;
  finally
    oSrcFileStream.Free;
  end;
end;

{ --- S_StrBlanks ------------------------------------------------------------ }
{ --- füllen auf iLen mit Blanks --------------------------------------------- }
function S_StrBlanks(const cStr: string; const iLen: integer): string;
begin
  if iLen<=Length(cStr) then
    Result:= cStr else
    Result:= cStr+s_Space(iLen-Length(cStr));
end;

{ --- S_StrBlanksCutTooLong -------------------------------------------------- }
{ --- like StrBlanksCuttooLong but cuts string if too long ------------------- }
function  S_StrBlanksCuttooLong(const cStr:string; const iLen:integer): string;
begin
  if iLen <= Length(cStr) then
    Result:= copy(cStr,1,iLen) else
    Result:= cStr+ s_Space(iLen - Length(cStr));
end;

{ --- S_StrLBlanks ----------------------------------------------------------- }
{ --- füllen auf iLen mit Blanks aber left ----------------------------------- }
function  S_StrLBlanks(const cStr:string; const iLen:integer): string;
begin
  if (iLen - Length(cStr)) < 0 then
    Result:= cStr else
    Result:= s_Space(iLen-Length(cStr))+cStr;
end;

{ --- S_TokenInit ------------------------------------------------------------ }
{ --- Token init: all Delimiters are replaced with  chr255 ------------------- }
procedure  S_TokenInit(cBuffer: PChar; const cDelimiters: string);
var
  i: longint;
  j: longint;
begin
  if cBuffer[0]=chr(0) then exit;
  for i:= 0 to StrLen(cBuffer)-1 do
    for j:= 1 to Length(cDelimiters) do
      if cBuffer[i]=cDelimiters[j] then
      begin
        cBuffer[i]:= C_TokenInit;
        Break;
      end;
end;

{ --- Token end or still tokens to retrieve? --------------------------------- }
{ --- S_TokenEnd ------------------------------------------------------------- }
function  S_TokenEnd(cBuffer: PChar; lEmptyToken: boolean):  boolean;
var
  i: longint;
begin
  if cBuffer[0]=chr(0) then
  begin
    Result:=True;
    exit;
  end;

  for i:=StrLen(cBuffer)-1 downto 0 do
  begin
    if cBuffer[i]=C_TokenOk then { str touched to end }
    begin
      Result:= True;
      exit;
    end else begin
      if lEmptyToken then
      begin
        Result:=False;
        exit;
      end else
      begin
        if cBuffer[i]<>C_TokenInit then
        begin
          Result:=False;
          exit;
        end;
      end;
    end;
  end;
  Result:=True;
end;

{ --- S_TokenNext ------------------------------------------------------------ }
function S_TokenNext(cBuffer: PChar; lEmptyToken: boolean): string;
var
  i, iStart, iStop, iBuffLen: integer;
  lFound: boolean;
begin
  if cBuffer[0]=chr(0) then
  begin
    Result:='';
    exit;
  end;
  lFound:= False;
  iBuffLen:= StrLen(cBuffer);
  for i:=0 to iBuffLen-1 do
  begin
    if cBuffer[i]=C_TokenOk then
      system.continue
    else begin
      lFound:=True;
      system.break;
    end;
  end;

  if lFound and (not lEmptyToken) then
  begin
    iStart:= i;
    { skip TokenInits ... if it's the rest of the pass before e.g. 'AAA;;AAA;...' -> ';AAA;...' }
    { means a "double ;;" }
    for i:=iStart to iBuffLen-1 do
    begin
      if cBuffer[i]=C_TokenInit then
        cBuffer[i]:= C_TokenOk
      else begin
        system.break;
      end;
    end;
  end;

  if not lFound then
  begin
    Result:= '';
    system.exit;
  end;

  iStart:= i;
  while (cBuffer[i]<>C_TokenInit) and (i<iBuffLen) do Inc(i);
  iStop:= i-1;
  SetLength(Result,iStop-iStart+1);
  for i:=iStart to iStop do
  begin
    Result[i-iStart+1]:= cBuffer[i];
    cBuffer[i]:= C_TokenOk;
  end;
  if iStop<(iBuffLen-1) then
    cBuffer[iStop+1]:= C_TokenOk;
end;

{ --- S_AddBackSlashL ---------------------------------------------------------- }
function S_AddBackSlash(const ADirName : string) : string;
begin
  if length(ADirName)=0 then exit;
  if ADirName[length(ADirName)] in ['\', #0] then
    Result:= ADirName
  else
    Result:= ADirName + '\';
end;

{ --- Buf2HexStr --------------------------------------------------------------- }
function Buf2HexStr(ABuffer: Pointer; ABufLen: integer; AAddSpaces: Boolean): string;
var
  i: integer;
  idx: integer;
  b, n: Byte;
begin
  if ((ABuffer <> nil) and (ABufLen > 0)) then begin
    { allocate string }
    if (AAddSpaces) then
      SetLength(result,(ABufLen*3)-1)
    else
      SetLength(result,ABufLen*2);
    { loop through buffer and convert all bytes }
    idx := 1;
    for i := 1 to ABufLen do begin
      b := Byte(ABuffer^);
      n := b shr 4;
      if (n > 9) then
        Inc(n,$37)
      else
        Inc(n,$30);
      result[idx] := char(n);
      n := b and $0F;
      if (n > 9) then
        Inc(n,$37)
      else
        Inc(n,$30);
      result[idx+1] := char(n);
      if ((AAddSpaces) and (i < ABufLen)) then begin
        result[idx+2] := ' ';
        Inc(idx,3);
      end else
        Inc(idx,2);
      Inc(integer(ABuffer));
    end;
  end else
    result := '';
end;


{ ---------------------------------------------------------------------------- }
function LastPos(const ASubstr: string; const AStr: string): Integer;
var
  iLastPos: integer;
begin
  Result:=0;
  repeat
    iLastPos:=Pos(ASubstr,Copy(AStr,Result+1,Length(AStr)));
    if iLastPos>0 then Result:=Result+iLastPos;
  until iLastPos=0;
end;

{ --- DelSpace --------------------------------------------------------------- }
function DelSpace(const pStr : string) : string;
var
  st: string;
begin
  st:= pStr;
  while Pos(' ',st)<>0 do Delete(st, Pos(' ',st), 1);
  DelSpace:= st;
end;

{ --- DelChar ---------------------------------------------------------------- }
function DelChar(const pStr: string; const pChar: Char): string;
begin
  Result:= pStr;
  while Pos(string(pChar), Result)<>0 do Delete(Result, Pos(string(pChar), Result), 1);
end;

{ --- DelString -------------------------------------------------------------- }
function  DelString(const pStr, pDelStr: string): string;
begin
  Result:= pStr;
  if pos(pDelStr, pStr)>0 then
    Delete(Result, pos(pDelStr, pStr), length(pDelStr));
end;

{ --- DeleteString ----------------------------------------------------------- }
procedure DeleteString(var pStr: String; const pDelStr: string);
begin
  if pos(pDelStr, pStr)>0 then
    Delete(pStr, pos(pDelStr, pStr), length(pDelStr));
end;

{ --- PadL ----------------------------------------------------------- }
function PadL(pStr: String; pLth: integer): String;
begin
  Result:= PadLCh(pStr, pLth, Chr(32));
end;

{ --- PadR ----------------------------------------------------------- }
function PadR(pStr: String; pLth: integer): String;
begin
  Result:= PadRCh(pStr, pLth, Chr(32));
end;

{ --- PadLCh --------------------------------------------------------- }
function PadLCh(pStr: String; pLth: integer; pChr: char): String;
begin
  Result:=S_RepeatChar(pLth-Length(pStr),pChr)+pStr;
end;

{ --- PadRCh --------------------------------------------------------- }
function PadRCh(pStr: String; pLth: integer; pChr: char): String;
begin
  Result:=pStr+S_RepeatChar(pLth-Length(pStr),pChr);
end;

{ --- GetReadableName -------------------------------------------------------- }
function GetReadableName(const AName : string):string;
var
  i: integer;
begin
  Result:= LowerCase(AName);
  if Length(Result)>0 then Result[1]:= UpperCase(Result[1])[1];
  for i:=1 to length(Result) do
    if not(Result[i] in
      [#65..#90,#97..#122,'ö','ä','ü','Ö','Ä','Ü','È','À','É','à','é','è']) and
      (length(Result)>i) then
      Result[i+1]:= UpperCase(Result[i+1])[1];
end;

{ --- GetNextDelimitedToken -------------------------------------------------- }
function GetNextDelimitedToken(const cDelim: char; var cStr: String): String;
var
  iPos: smallint;
  cRes: String;
begin
  iPos:=Pos(cDelim,cStr);
  if iPos=0 then iPos:=Length(cStr)+1;
  Result:=copy(cStr,1,iPos-1);
  cRes:=copy(cStr,iPos+1,Length(cStr)); { Strange code but gives an error when }
  cStr:=cRes;                           { writing directly into cStr }
end;

{ --- GetFirstDelimitedToken -------------------------------------------------- }
function GetFirstDelimitedToken(const cDelim: char; const cStr: string): string;
var
  iPos: integer;
begin
  Result:= '';
  iPos:=pos(cDelim, cStr);
  if iPos>0 then Result:=Copy(cStr,1,iPos-1) else Result:=cStr;
end;

{ --- GetLastDelimitedToken -------------------------------------------------- }
function GetLastDelimitedToken(const cDelim: char; const cStr: string): string;
var
  iPos: integer;
begin
  Result:= cStr;
  repeat
    iPos:=pos(cDelim, Result);
    if iPos>0 then Result:= copy(Result, pos(cDelim,Result)+1, length(Result));
  until iPos=0;
end;

{ --- CompareTextLike -------------------------------------------------------- }
function CompareTextLike(cWildStr, cStr: string; const cWildChar: char;
                         lCaseSensitive: boolean): boolean;
Var
  lWildAreaFront, lWildAreaBack: boolean;
Begin
  if not lCaseSensitive then
  Begin
    cWildStr:=UpperCase(cWildStr);
    cStr:=UpperCase(cStr);
  end;
  lWildAreaFront:=Pos(cWildChar,cWildStr)=1;
  if lWildAreaFront then
    cWildStr:=Copy(cWildStr,2,length(cWildStr));
  lWildAreaBack:=Pos(cWildChar,cWildStr)=length(cWildStr);
  if lWildAreaBack then
    cWildStr:=Copy(cWildStr,1,length(cWildStr)-1);
  { Real compare }
  if lWildAreaFront and lWildAreaBack then
  Begin
    Result:=Pos(cWildStr,cStr)<>0;
  end else
  Begin
    if lWildAreaBack then
    Begin
      Result:=Pos(cWildStr,cStr)=1;
    end else
    Begin
      if lWildAreaFront then
      Begin
        Result:=Pos(cWildStr,cStr)=Length(cStr)-Length(cWildStr)+1;
      end else
      Begin
        Result:=CompareStr(cWildStr,cStr)=0;
      end;
    end;
  end;
end;

{ ---------------------------------------------------------------------------- }
{ --- Stream routines -------------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
function S_ReadNextTextLineFromStream(stream: TStream): string;
const
  cMaxTextLineLength = 1024;
  cCRChar = char(13);
  cLFChar = char(10);
var
  buf: array[0..cMaxTextLineLength-1] of char;
  i, Count, StreamPos: integer;
  FoundCR, FoundEOL: Boolean;
begin
  StreamPos := stream.Position;
  Count := stream.Read(buf,cMaxTextLineLength);
  { search for EOL (CR or LF) }
  FoundEOL := False;
  FoundCR := False;
  for i := 0 to Count-1 do
    if ((buf[i] = cCRChar) or (buf[i] = cLFChar)) then begin
      FoundEOL := True;
      if (buf[i] = cCRChar) then
        FoundCR := True;
      buf[i] := char(0);
      break;
    end;
  { reposition stream to beginning of next line }
  if (FoundEOL) then begin
    Inc(StreamPos,i+1);
    if (FoundCR) then
      if (i < cMaxTextLineLength) then
        if (buf[i+1] = cLFChar) then
          Inc(StreamPos);
  end else begin
    buf[cMaxTextLineLength-1] := char(0);
    Inc(StreamPos,cMaxTextLineLength-1);
  end;
  stream.Position := StreamPos;
  { return line as string }
  result := string(buf);
end;

{-----------------------------------------------------------------------------}

function Stream2WideString(oStream:TStream): WideString;
var
  i: integer;
  aByte: Byte;
  HexString: String;
  iPos: Integer;
  ResultString: String;
begin
  ResultString :='';
  oStream.Position := 0;
  SetLength(ResultString,2*oStream.Size);
  for i:= 0 to oStream.Size-1 do
  begin
    oStream.Read(aByte,1);
    HexString:= IntToHex(aByte,2);
    iPos := (i*2)+1;
    ResultString[iPos] := HexString[1];
    ResultString[iPos+1] := HexString[2];
  end;
  Result := ResultString;
end;

{-----------------------------------------------------------------------------}

procedure WideString2Stream(aWideString: WideString;oStream:TStream);
var
  i: integer;
  aByte: Byte;
begin
  oStream.Position:= 0;
  i:= 1;
  While i <= length(aWideString) do
  begin
    aByte := Byte(StrToInt('$'+copy(aWideString,i,2)));
    oStream.Write(aByte,1);
    i:=i+2;
  end;
  oStream.Position:= 0;
end;

{ ---------------------------------------------------------------------------- }
{ --- Miscellaneous routinges ------------------------------------------------ }
{ ---------------------------------------------------------------------------- }
procedure S_AddMessageToStrings(AMessages: TStrings; AMsg: string);
begin
  if (AMessages <> nil) then
    AMessages.Add(AMsg);
end;


{ --- BitmapsAreIdentical ---------------------------------------------------- }
function BitmapsAreIdentical(ABitmap1, ABitmap2: TBitmap): Boolean;
var
  ms1, ms2: TMemoryStream;
begin
  result := False;
  ms1 := TMemoryStream.Create;
  try
    ms2 := TMemoryStream.Create;
    try
      ABitmap1.SaveToStream(ms1);
      ABitmap2.SaveToStream(ms2);
      if (ms1.Size = ms2.Size) then
        result := CompareMem(ms1.Memory,ms2.Memory,ms1.Size);
    finally
      ms2.Free;
    end;
  finally
    ms1.Free;
  end;
end;

{------------------------------------------------------------------------------}
procedure SimulateKeystroke(Key : byte; Shift : TShiftState);
begin
  if ssShift in Shift then keybd_event(VK_SHIFT, 0, 0, 0);
  if ssCtrl  in Shift then keybd_event(VK_CONTROL, 0, 0, 0);
  if ssAlt   in Shift then keybd_event(VK_MENU, 0, 0, 0);
  keybd_event(Key, 0, 0, 0);
  if ssShift in Shift then keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
  if ssCtrl  in Shift then keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
  if ssAlt   in Shift then keybd_event(VK_MENU, 0, KEYEVENTF_KEYUP, 0);
  keybd_event(Key, 0, KEYEVENTF_KEYUP, 0);
end;

{ ---------------------------------------------------------------------------- }
{ --- Application routinges -------------------------------------------------- }
{ ---------------------------------------------------------------------------- }

{ --- WaitMiliSeconds -------------------------------------------------------- }
procedure WaitMiliSeconds(AMSec: word);
var
  StartTime: DWORD;
begin
  StartTime:= timeGetTime;
  while (StartTime+AMSec)>=timeGetTime do Application.ProcessMessages;
end;


{ --- GetApplicationsRunning ------------------------------------------------- }
procedure GetApplicationsRunning(Strings: TStrings);
var
  wnd: HWND;
  WndClass, WndText: array[0..255] of char;
begin
  Wnd:= GetWindow(Application.Handle, gw_HWndFirst);
  while wnd<>0 do
  begin
    GetClassName(wnd, WndClass, 255);
    GetWindowText(wnd, WndText, 255);
    Strings.Add(StrPas(WndClass)+#9+StrPas(WndText));
    Wnd:= GetWindow(wnd, gw_HWndNext);
  end;
end;

{ --- IsApplicationRunning --------------------------------------------------- }
function IsApplicationRunning(const AClassName, ApplName: string): Boolean;
var
  wnd: HWND;
  WndClass, WndText: array[0..255] of char;
  s,s1: string;
begin
  Wnd:= GetWindow(Application.Handle, gw_HWndFirst);
  while wnd<>0 do
  begin
    GetClassName(wnd, WndClass, 255);
    GetWindowText(wnd, WndText, 255);
    s:= StrPas(WndClass);
    s1:= StrPas(WndText);
    if AClassNAme='' then s:='';
    if ApplName='' then s1:= '';
    if (CompareText(s, AClassName)=0) and
       (CompareText(s1, ApplName)=0)  then
    begin
      Result:= True;
      exit;
    end;
    Wnd:= GetWindow(wnd, gw_HWndNext);
  end;
  Result:= False;
end;


{ --- IsDelphiRunning -------------------------------------------------------- }
function IsDelphiRunning: boolean;
begin
  Result:= (FindWindow('TAppBuilder',nil) <> 0);
end;

{ --- IsDelphiDesignMode ----------------------------------------------------- }
function IsDelphiDesignMode: boolean;
begin
  Result:= (Pos('.DCL',UpperCase(Application.ExeName))<>0) or
           (Pos('.BPL',UpperCase(Application.ExeName))<>0) or
           (Pos('DELPHI32.EXE',UpperCase(Application.ExeName))<>0);
end;

{ ---------------------------------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
{ --- File name routines ----------------------------------------------------- }
{ ---------------------------------------------------------------------------- }

{ --- AddFileExtIfNecessary -------------------------------------------------- }
function AddFileExtIfNecessary(AFileName, AExt: string): string;
begin
  if (Pos('.',AFileName) = 0) then begin
    if (Pos('.',AExt) = 0) then
      result := AFileName + '.'
    else
      result := AFileName;
    result := result + AExt
  end else
    result := AFileName;
end;


{ ---------------------------------------------------------------------------- }
{ --- Binary routines -------------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
function BinaryToDouble(ABinary: string; DefValue: Double): Double;
var
  i   : integer;
  pos : integer;
begin
  result := DefValue;
  pos := 0;
  for i := Length(ABinary) downto 1 do
  begin
    case ABinary[i] of
      '0':;
      '1': result := result + Power(2, pos);
    else
      begin
        result := DefValue;
        exit;
      end;
    end;
    inc(pos);
  end;
end;

{ ---------------------------------------------------------------------------- }
{ --- Float routines --------------------------------------------------------- }
{------------------------------------------------------------------------------}
function S_RoundDecimal(AValue : Extended; APlaces : Integer) : Extended;
var
  i: integer;
  N: Extended;
  sFmt, sVal: string;
begin
  sFmt:= '0'+DECIMALSEPARATOR;
  if APlaces>=0 then
  begin
    for i:=0 to APlaces-1 do sFmt:= sFmt+'0';
    sVal:= FormatFloat(sFmt, AValue);
    Result:= StrToFloat(sVal);
  end else
  begin
    if abs(APlaces)>=length(FormatFloat(sFmt, AValue)) then
      APlaces:= length(FormatFloat(sFmt, AValue))-1;
    N:= Power(10.0, abs(APlaces));
    sVal:= FormatFloat(sFmt, AValue/N);
    Result:= StrToFloat(sVal)*N;
  end;
end;

{ ---------------------------------------------------------------------------- }
function S_LimitDigits(AValue: Extended; ANumDigits: Integer): Extended;
var
  iLen, iDigits: integer;
begin
  iDigits:= abs(ANumDigits);
  iLen:= length(FormatFloat('#', AValue));
  Result:= S_RoundDecimal(AValue, iDigits-iLen);
end;

{ ---------------------------------------------------------------------------- }
{ --- system routines -------------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
{ --- GetWindowsUserID ------------------------------------------------------- }
function GetWindowsUserID: string;
var
  Usr: array[0..254] of char;
  i : DWORD;
begin
  i:= SizeOf(Usr);
  if GetUserName(Usr, i) then
    Result:= StrPas(Usr) else
    Result:= '';
end;

{ --- GetWindowsComputerID ------------------------------------------------------- }
function GetWindowsComputerID: string;
var
  Usr: array[0..254] of char;
  i : DWORD;
begin
  i:= SizeOf(Usr);
  if GetComputerName(Usr, i) then
    Result:= StrPas(Usr) else
    Result:= '';
end;

{ ---------------------------------------------------------------------------- }
function GetEnvironmentVar(const AVariableName: string): string;
begin
  Result:= GetEnvironmentVariable(AVariableName);
end;

{ ---------------------------------------------------------------------------- }
function S_DirExists(const ADir: string): Boolean;
begin
  Result:= DirectoryExists(ADir);
end;


{ ---------------------------------------------------------------------------- }
function S_LargeFontsActive:Boolean;
begin
  Result :=(Screen.PixelsPerInch = 120);
end;


{ ---------------------------------------------------------------------------- }
{ --- Shell Execute routines ------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
function ShellExecuteCmdToStr(aCommand:TS_ShellExecuteCmd):String;
begin
  Case aCommand of
    seCmdOpen   : Result := 'open';
    seCmdPrint  : Result := 'print';
    seCmdExplore: Result := 'explore'
  end;
end;

{ ---------------------------------------------------------------------------- }
function GetShellExecuteResult(aExitValue:integer):String;
begin
  Result := '';
  if aExitValue = 0                      then Result := sMb_OutOfMemory;
  if aExitValue = ERROR_FILE_NOT_FOUND   then Result := sMb_ERROR_FILE_NOT_FOUND;
  if aExitValue = ERROR_PATH_NOT_FOUND   then Result := sMb_ERROR_PATH_NOT_FOUND;
  if aExitValue = ERROR_BAD_FORMAT       then Result := sMb_ERROR_BAD_FORMAT;
  if aExitValue = SE_ERR_ACCESSDENIED    then Result := sMb_SE_ERR_ACCESSDENIED;
  if aExitValue = SE_ERR_ASSOCINCOMPLETE then Result := sMb_SE_ERR_ASSOCINCOMPLETE;
  if aExitValue = SE_ERR_DDEBUSY	 then Result := sMb_SE_ERR_DDEBUSY;
  if aExitValue = SE_ERR_DDEFAIL	 then Result := sMb_SE_ERR_DDEFAIL;
  if aExitValue = SE_ERR_DDETIMEOUT      then Result := sMb_SE_ERR_DDETIMEOUT;
  if aExitValue = SE_ERR_DLLNOTFOUND     then Result := sMb_SE_ERR_DLLNOTFOUND;
  if aExitValue = SE_ERR_FNF	         then Result := sMb_SE_ERR_FNF;
  if aExitValue = SE_ERR_NOASSOC	 then Result := sMb_SE_ERR_NOASSOC;
  if aExitValue = SE_ERR_OOM	         then Result := sMb_SE_ERR_OOM;
  if aExitValue = SE_ERR_PNF	         then Result := sMb_SE_ERR_PNF;
  if aExitValue = SE_ERR_SHARE	         then Result := sMb_SE_ERR_SHARE;
end;

{ ---------------------------------------------------------------------------- }
function S_ShellExecute(aFilename: string; aParameters:string;
                        aCommand:TS_ShellExecuteCmd):string;
var
  fExitValue:integer;
begin
   // if STATExecuteShell then begin    //global var in winform1puzzle!
  if maxForm1.getSTATExecuteShell then begin
     fExitValue := Shellexecute(0,
                             pChar(ShellExecuteCmdToStr(aCommand)),
                             pChar(aFilename),
                             pChar(aParameters),
                             pChar(ExtractFilePath(aFilename)),
                             SW_SHOWNORMAL);
     Result := GetShellExecuteResult(fExitValue);
   end else begin
     MessageBox(0,pchar('Error Starting Shell'),pchar('mX3 command'),MB_OKCANCEL);
     maxForm1.memo2.Lines.Add('Error Starting Shell protected in ini-File!'+#13#10+
                               'by setting EXECUTESHELL=N');
   end;
   maxForm1.memo2.Lines.Add('ExecuteShell3 Command could be protected in ini-File!'+#13#10+
                               'by setting EXECUTESHELL=N');

end;

{ ---------------------------------------------------------------------------- }
{ --- object routines -------------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
procedure S_FreeAndNilObject(oObj: TObjectPtr);
Begin
  oObj^.Free;
  oObj^:=nil;
end;



{ ---------------------------------------------------------------------------- }
{ --  Mask a String      ----------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
function MaskString(Mask,Value:String):String;
var
  Length_Value: integer;
  Length_Mask: integer;
  aPosition: integer;
  CharValue : integer;
begin
  Length_Value := Length(Value);
  Length_Mask  := Length(Mask);
  Result := '';
  if (Length_Mask-Length_Value <0)   then  exit;
  Value := S_StrBlanks(Value,Length_Mask);
  for aPosition := 1 to Length_Mask do
  begin
    CharValue := ord(value[aPosition])+ord(Mask[aPosition]);
    if CharValue > 255 then CharValue:= CharValue-255;
    Result := Result+chr(CharValue);
  end;
end;

{ ---------------------------------------------------------------------------- }

function UnMaskString(Mask,Value:String):String;
var
  aPosition: Integer;
  Length_Value: integer;
  Length_Mask: integer;
  CharValue : integer;
begin
  Length_Value := Length(Value);
  Length_Mask  := Length(Mask);
  Result := '';
  if Length_Mask <> Length_Value then
  begin
    exit;
  end;
  for aPosition := 1 to Length_Mask do
  begin
    CharValue := ord(value[aPosition])-ord(Mask[aPosition]);
    if CharValue < 0 then CharValue:= 255+CharValue;
    Result := Result+chr(CharValue);
  end;
end;
{ ---------------------------------------------------------------------------- }

function StrToFloatRegionalIndependent(aValue:String; aDecimalSymbol: Char; aDigitGroupSymbol: Char):Extended;
var
  i, ValueLength: Integer;
  ChangeValue,TmpString: String;
begin
  ChangeValue:=aValue;
  if (not (DecimalSeparator = aDecimalSymbol) or (pos(aDigitGroupSymbol,ChangeValue)>0) )then
  begin
    ValueLength := length(ChangeValue);
    i:= 1;
    while i <= ValueLength do
    begin
      if ChangeValue[i]= aDecimalSymbol then
         ChangeValue[i] := DecimalSeparator;
      if ChangeValue[i]= aDigitGroupSymbol then
      begin
        TmpString := ChangeValue;
        ChangeValue := Copy(TmpString,1,i-1);
        ChangeValue := ChangeValue+copy(TmpString,i+1,ValueLength);
        dec(i);
        dec(ValueLength);
      end;
      inc(i);
    end;
  end;
  Result := StrToFloat(ChangeValue);
end;

{ ---------------------------------------------------------------------------- }
function S_UTF_8ToString(const AString: string): string;
const
  IBorders: array[1..5] of integer = (192,224,240,248,252);
var
  i,j,p: integer;                                     // 11000000 192  -> 1
  iBorder: Integer;                                   // 11100000 224  -> 2
  iMask: integer;                                     // 11110000 240  -> 3
  IWideChar: integer;                                 // 11111000 248  -> 4
  ITempWideChar: integer;                             // 11111100 252  -> 5
begin
  Result:= '';
  iBorder:= Length(AString);
  i:= 1;
  while i <= iBorder do
  begin
    if ord(AString[i]) <= 127 then
      Result:= Result + AString[i]
    else
    begin
      for j:= 5 downto 1 do // Anzahl der folgenden Bytes ermitteln -> J
        if ord(AString[i]) >= IBorders[j] then break;
      iMask:=255-IBorders[j];
      IWideChar:= (ord(AString[i]) and iMask);  // mit der Inversen Maskieren
      IWideChar:= IWideChar shl 6*j;            // und an die richtige Stelle schieben.
      for p:= 1 to j do                         // Restliche Bits zusammenbauen
      begin
        inc(i);
        ITempWideChar:= (ord(AString[i]) and 63); //00111111  die ersten 2 bit löschen
        if j-p > 0 then
          ITempWideChar:= ITempWideChar shl 6*(j-p); // an die richtige Stelle schieben
        IWideChar:= IWideChar + ITempWideChar;
      end;
      Result:= Result+ chr(IWideChar);  // Hier ist die Beschränkung auf 8Bit
    end;
    inc(i);
  end;
end;

{ ---------------------------------------------------------------------------- }
function S_StringtoUTF_8(const AString: string): string;
var
  i: integer;
  iBorder: integer;
  iTempCharValue: integer;
begin
  Result:='';
  iBorder:= Length(AString);
  for i:= 1 to iBorder do
  begin
    if ord(AString[i]) <= 127 then
      Result:= Result+ AString[i]
    else
    begin   // String 8Bit => nur 1 Folgebyte die ersten 2 Bit im Header
      iTempCharValue:= 192 + ord(AString[i]) shr 6; // 2 Bit im Header
      Result:= Result+ Chr(iTempCharValue);
      iTempCharValue:= (ord(AString[i]) and 63)+128; // restlichen 6 Bit + FolgeByteHeader
      Result:= Result+ Chr(iTempCharValue);
    end;
  end;
end;

{ ---------------------------------------------------------------------------- }
{ --- CRC32 routines --------------------------------------------------------- }
{ ---------------------------------------------------------------------------- }

Const
  CRCSeed = $ffffffff;
  CRC32tab : array[0..255] of DWORD = (
    $00000000, $77073096, $ee0e612c, $990951ba, $076dc419, $706af48f,
    $e963a535, $9e6495a3, $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988,
    $09b64c2b, $7eb17cbd, $e7b82d07, $90bf1d91, $1db71064, $6ab020f2,
    $f3b97148, $84be41de, $1adad47d, $6ddde4eb, $f4d4b551, $83d385c7,
    $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec, $14015c4f, $63066cd9,
    $fa0f3d63, $8d080df5, $3b6e20c8, $4c69105e, $d56041e4, $a2677172,
    $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b, $35b5a8fa, $42b2986c,
    $dbbbc9d6, $acbcf940, $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59,
    $26d930ac, $51de003a, $c8d75180, $bfd06116, $21b4f4b5, $56b3c423,
    $cfba9599, $b8bda50f, $2802b89e, $5f058808, $c60cd9b2, $b10be924,
    $2f6f7c87, $58684c11, $c1611dab, $b6662d3d, $76dc4190, $01db7106,
    $98d220bc, $efd5102a, $71b18589, $06b6b51f, $9fbfe4a5, $e8b8d433,
    $7807c9a2, $0f00f934, $9609a88e, $e10e9818, $7f6a0dbb, $086d3d2d,
    $91646c97, $e6635c01, $6b6b51f4, $1c6c6162, $856530d8, $f262004e,
    $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457, $65b0d9c6, $12b7e950,
    $8bbeb8ea, $fcb9887c, $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65,
    $4db26158, $3ab551ce, $a3bc0074, $d4bb30e2, $4adfa541, $3dd895d7,
    $a4d1c46d, $d3d6f4fb, $4369e96a, $346ed9fc, $ad678846, $da60b8d0,
    $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9, $5005713c, $270241aa,
    $be0b1010, $c90c2086, $5768b525, $206f85b3, $b966d409, $ce61e49f,
    $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4, $59b33d17, $2eb40d81,
    $b7bd5c3b, $c0ba6cad, $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a,
    $ead54739, $9dd277af, $04db2615, $73dc1683, $e3630b12, $94643b84,
    $0d6d6a3e, $7a6a5aa8, $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1,
    $f00f9344, $8708a3d2, $1e01f268, $6906c2fe, $f762575d, $806567cb,
    $196c3671, $6e6b06e7, $fed41b76, $89d32be0, $10da7a5a, $67dd4acc,
    $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5, $d6d6a3e8, $a1d1937e,
    $38d8c2c4, $4fdff252, $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b,
    $d80d2bda, $af0a1b4c, $36034af6, $41047a60, $df60efc3, $a867df55,
    $316e8eef, $4669be79, $cb61b38c, $bc66831a, $256fd2a0, $5268e236,
    $cc0c7795, $bb0b4703, $220216b9, $5505262f, $c5ba3bbe, $b2bd0b28,
    $2bb45a92, $5cb36a04, $c2d7ffa7, $b5d0cf31, $2cd99e8b, $5bdeae1d,
    $9b64c2b0, $ec63f226, $756aa39c, $026d930a, $9c0906a9, $eb0e363f,
    $72076785, $05005713, $95bf4a82, $e2b87a14, $7bb12bae, $0cb61b38,
    $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21, $86d3d2d4, $f1d4e242,
    $68ddb3f8, $1fda836e, $81be16cd, $f6b9265b, $6fb077e1, $18b74777,
    $88085ae6, $ff0f6a70, $66063bca, $11010b5c, $8f659eff, $f862ae69,
    $616bffd3, $166ccf45, $a00ae278, $d70dd2ee, $4e048354, $3903b3c2,
    $a7672661, $d06016f7, $4969474d, $3e6e77db, $aed16a4a, $d9d65adc,
    $40df0b66, $37d83bf0, $a9bcae53, $debb9ec5, $47b2cf7f, $30b5ffe9,
    $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6, $bad03605, $cdd70693,
    $54de5729, $23d967bf, $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94,
    $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d  );

{ ---------------------------------------------------------------------------- }
function S_CRCBegin: DWORD;
begin
  result := CRCseed;
end;

{ ---------------------------------------------------------------------------- }
function S_CRC32(value: Byte; crc: DWORD): DWORD;
begin
  result := CRC32tab[Byte(crc xor DWORD(value))] xor ((crc shr 8) and $00ffffff);
end;

{ ---------------------------------------------------------------------------- }
function S_CRCend(crc: DWORD): DWORD;
begin
  result := (crc xor CRCSeed);
end;

{ ---------------------------------------------------------------------------- }
function S_StrCRC32(const Text: string): LongWORD;
var
  i: integer;
begin
  result := S_CRCBegin;
  for i := 1 to length(Text) do
    result := S_CRC32(Byte(Text[i]),result);
  result := S_CRCend(result);
end;

{ ---------------------------------------------------------------------------- }
function S_EncryptCRC32(const crc: LongWORD; StartKey, MultKey, AddKey: integer): string;
begin
  result := S_StrEncrypt96(IntToHex(crc,8),StartKey,MultKey,AddKey);
end;

{ ---------------------------------------------------------------------------- }
function S_DecryptCRC32(const crc: string; StartKey, MultKey, AddKey: integer): integer;
begin
  result := StrToInt('$'+S_StrDecrypt96(crc,StartKey,MultKey,AddKey));
end;

{ ---------------------------------------------------------------------------- }
{ --- Encryption/Decryption routines ----------------------------------------- }
{ ---------------------------------------------------------------------------- }
procedure S_GetEncryptionKeys(DateTime1, DateTime2: TDateTime; var StartKey: integer; var MultKey: integer; var AddKey: integer);
begin
  asm
    { save registers used by Delphi }
    PUSH  EBX
    PUSH  ESI
    { clear StartKey, MultKey, AddKey }
    XOR   EBX,EBX
    XOR   EDX,EDX
    XOR   ESI,ESI
    { build keys using bits from date }
    MOV   AL,BYTE PTR DateTime1+6
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime2+7
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime1+4
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime2+3
    SHL   EAX,8
    CALL  @S_GetEncryptionKeys100
    CALL  @S_GetEncryptionKeys300
    CALL  @S_GetEncryptionKeys200
    CALL  @S_GetEncryptionKeys400
    CALL  @S_GetEncryptionKeys200
    CALL  @S_GetEncryptionKeys300
    CALL  @S_GetEncryptionKeys400
    CALL  @S_GetEncryptionKeys100
    MOV   AL,BYTE PTR DateTime1+7
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime2+6
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime1+3
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime2+4
    SHL   EAX,8
    CALL  @S_GetEncryptionKeys300
    CALL  @S_GetEncryptionKeys200
    CALL  @S_GetEncryptionKeys400
    CALL  @S_GetEncryptionKeys100
    CALL  @S_GetEncryptionKeys400
    CALL  @S_GetEncryptionKeys200
    CALL  @S_GetEncryptionKeys100
    CALL  @S_GetEncryptionKeys300
    MOV   AL,BYTE PTR DateTime1+1
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime2+5
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime1+2
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime2
    SHL   EAX,8
    CALL  @S_GetEncryptionKeys400
    CALL  @S_GetEncryptionKeys100
    CALL  @S_GetEncryptionKeys300
    CALL  @S_GetEncryptionKeys200
    CALL  @S_GetEncryptionKeys300
    CALL  @S_GetEncryptionKeys100
    CALL  @S_GetEncryptionKeys200
    CALL  @S_GetEncryptionKeys400
    MOV   AL,BYTE PTR DateTime1+5
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime2+1
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime1
    SHL   EAX,8
    MOV   AL,BYTE PTR DateTime2+2
    SHL   EAX,8
    CALL  @S_GetEncryptionKeys200
    CALL  @S_GetEncryptionKeys400
    CALL  @S_GetEncryptionKeys100
    CALL  @S_GetEncryptionKeys300
    CALL  @S_GetEncryptionKeys100
    CALL  @S_GetEncryptionKeys400
    CALL  @S_GetEncryptionKeys300
    CALL  @S_GetEncryptionKeys200
    JMP   @S_GetEncryptionKeys_Exit
@S_GetEncryptionKeys100:
    SHR   EAX,1
    RCL   EBX,1
    SHR   EAX,1
    RCL   EDX,1
    SHR   EAX,1
    RCL   ESI,1
    SHR   EAX,1
    RET
@S_GetEncryptionKeys200:
    SHR   EAX,1
    RCL   EDX,1
    SHR   EAX,1
    RCL   ESI,1
    SHR   EAX,1
    SHR   EAX,1
    RCL   EBX,1
    RET
@S_GetEncryptionKeys300:
    SHR   EAX,1
    RCL   ESI,1
    SHR   EAX,1
    SHR   EAX,1
    RCL   EBX,1
    SHR   EAX,1
    RCL   EDX,1
    RET
@S_GetEncryptionKeys400:
    SHR   EAX,1
    SHR   EAX,1
    RCL   EBX,1
    SHR   EAX,1
    RCL   EDX,1
    SHR   EAX,1
    RCL   ESI,1
    RET
@S_GetEncryptionKeys_Exit:
    { store keys into their respective locations }
    MOV   EAX,StartKey
    MOV   [EAX],EBX
    MOV   EAX,MultKey
    MOV   [EAX],EDX
    MOV   EAX,AddKey
    MOV   [EAX],ESI
    { restore registers }
    POP   ESI
    POP   EBX
  end;
end;

{----------------------------------------------------------------------}
{$ifopt R+}
  {$define DefineOldTempGS_R} {$R-}
{$endif}
{$ifopt Q+}
  {$define DefineOldTempGS_Q} {$Q-}
{$endif}
{----------------------------------------------------------------------}

function S_StrEncrypt96(const InString: string; StartKey, MultKey, AddKey: Integer): string;
var
  i: integer;
  B: Byte;
  Nibble: Byte;
begin
  Result := '';
  for I := 1 to Length(InString) do begin
    { encode next byte }
    B := Byte(InString[I]) xor (StartKey shr 8);
    { convert to string of binary numbers }
    Nibble := B shr 4;
    if (Nibble > 9) then
      Inc(Nibble,7);
    Result := Result + Char(Nibble+$30);
    Nibble := B and $0F;
    if (Nibble > 9) then
      Inc(Nibble,7);
    Result := Result + Char(Nibble+$30);
    { calculate next XOR pattern }
    StartKey := (B + StartKey) * MultKey + AddKey;
  end;
end;

{ ---------------------------------------------------------------------------- }
function S_StrDecrypt96(const InString: string; StartKey, MultKey, AddKey: Integer): string;
var
  I: integer;
  Idx: integer;
  B: Byte;
  Nibble: Byte;
begin
  Result := '';
  Idx := 1;
  for I := 1 to (Length(InString) div 2) do
  begin
    { get byte from string }
    Nibble := Byte(InString[Idx]) - $30;
    if (Nibble > 9) then
      Dec(Nibble,7);
    B := Nibble shl 4;
    Nibble := Byte(InString[Idx+1]) - $30;
    if (Nibble > 9) then
      Dec(Nibble,7);
    B := B or Nibble;
    { add to string }
    Result := Result + CHAR(B xor (StartKey shr 8));
    Inc(Idx,2);
    { get next XOR pattern }
    StartKey := (B + StartKey) * MultKey + AddKey;
  end;
end;

{----------------------------------------------------------------------}
{$ifdef DefineOldTempGS_R}
  {$undef DefineOldTempGS_R} {$R+}
{$endif}
{$ifdef DefineOldTempGS_Q}
  {$undef DefineOldTempGS_Q} {$Q+}
{$endif}
{----------------------------------------------------------------------}

initialization
begin
end;

end.
