{*************************************************************
www:          http://sourceforge.net/projects/alcinoe/              
svn:          svn checkout svn://svn.code.sf.net/p/alcinoe/code/ alcinoe-code              
Author(s):    Stéphane Vander Clock (alcinoe@arkadia.com)
Sponsor(s):   Arkadia SA (http://www.arkadia.com)
							
product:      Alcinoe Misc functions
Version:      4.00

Description:  Alcinoe Misc Functions

Legal issues: Copyright (C) 1999-2013 by Arkadia Software Engineering

              This software is provided 'as-is', without any express
              or implied warranty.  In no event will the author be
              held liable for any  damages arising from the use of
              this software.

              Permission is granted to anyone to use this software
              for any purpose, including commercial applications,
              and to alter it and redistribute it freely, subject
              to the following restrictions:

              1. The origin of this software must not be
                 misrepresented, you must not claim that you wrote
                 the original software. If you use this software in
                 a product, an acknowledgment in the product
                 documentation would be appreciated but is not
                 required.

              2. Altered source versions must be plainly marked as
                 such, and must not be misrepresented as being the
                 original software.

              3. This notice may not be removed or altered from any
                 source distribution.

              4. You must register this software by sending a picture
                 postcard to the author. Use a nice stamp and mention
                 your name, street address, EMail address and any
                 comment you like to say.

Know bug :

History :     09/01/2005: correct then AlEmptyDirectory function
              25/05/2006: Move some function to AlFcnFile
              25/02/2008: Update AlIsValidEmail
              06/10/3008: Update AlIsValidEmail
              03/03/2010: add ALIsInt64
              26/06/2012: Add xe2 support
              mX   (*str := ALFastTagReplace(str,  not yet!!

              Link :

* Please send all your feedback to alcinoe@arkadia.com
* If you have downloaded this source from a website different from 
  sourceforge.net, please get the last version on http://sourceforge.net/projects/alcinoe/
* Please, help us to keep the development of these components free by
  promoting the sponsor on http://static.arkadia.com/html/alcinoe_like.html
**************************************************************}
unit ALFcnMisc;

interface

uses sysutils, strutils, classes, alStringlist;

Const cAlUTF8Bom = ansiString(#$EF) + ansiString(#$BB) + ansiString(#$BF);

type

 EALException = class(Exception)
  public
    constructor Create(const Msg: AnsiString);
  end;

  TALHandleTagfunct = function(const TagString: AnsiString;
                               TagParams: TAlStrings;
                               ExtData: pointer;
                               Var Handled: Boolean): AnsiString;
  TALHandleTagExtendedfunct = function(const TagString: AnsiString;
                                       TagParams: TAlStrings;
                                       ExtData: pointer;
                                       Var Handled: Boolean;
                                       Const SourceString: AnsiString;
                                       Var TagPosition, TagLength: integer): AnsiString;


Function AlBoolToInt(Value:Boolean):Integer;
Function ALMediumPos(LTotal, LBorder, LObject : integer):Integer;
function AlIsValidEmail(const Value: AnsiString): boolean;
function AlLocalDateTimeToGMTDateTime(Const aLocalDateTime: TDateTime): TdateTime;
Function ALInc(var x: integer; Count: integer): Integer;
function ALCopyStr(const aSourceString: AnsiString; aStart, aLength: Integer): AnsiString;
function  ALTrim(const S: AnsiString): AnsiString;
function ALGetStringFromFile(filename: AnsiString; const ShareMode: Word = fmShareDenyWrite): AnsiString;
procedure ALSaveStringtoFile(Str: AnsiString; filename: AnsiString);
Function ALIsInteger(const S: AnsiString): Boolean;
function ALIsDecimal(const S: AnsiString): boolean;
function  ALPos(const SubStr, Str: AnsiString): Integer;
function  ALPosEx(const SubStr, S: AnsiString; Offset: Integer = 1): Integer;
function  ALPosExIgnoreCase(const SubStr, S: Ansistring; Offset: Integer = 1): Integer;

function  ALIntToHex(Value: Integer; Digits: Integer): AnsiString; overload;
function  ALIntToHex(Value: Int64; Digits: Integer): AnsiString; overload;

procedure ALStrMove(const Source: PAnsiChar; var Dest: PAnsiChar; Count: {$if CompilerVersion >= 23}{Delphi XE2}NativeInt{$ELSE}Integer{$IFEND});
Function  ALStringToWideString(const S: AnsiString; const aCodePage: Word): WideString;
function  AlWideStringToString(const WS: WideString; const aCodePage: Word): AnsiString;
function ALMatchesMask(const Filename, Mask: AnsiString): Boolean;
function  ALGUIDToString(const Guid: TGUID): Ansistring;
Function  ALMakeKeyStrByGUID: AnsiString;
Function ALGetCodePageFromCharSetName(Acharset:AnsiString): Word;
Function  ALUTF8Encode(const S: AnsiString; const aCodePage: Word): AnsiString;
Function  ALUTF8decode(const S: AnsiString; const aCodePage: Word): AnsiString;
function  ALQuotedStr(const S: AnsiString; const Quote: AnsiChar = ''''): AnsiString;
function  ALDequotedStr(const S: AnsiString; AQuote: AnsiChar): AnsiString;
Function  ALIsInt64 (const S: AnsiString): Boolean;
function  AlUTF8removeBOM(const S: AnsiString): AnsiString;
function  AlUTF8DetectBOM(const P: PAnsiChar; const Size: Integer): Boolean;
function  ALIfThen(AValue: Boolean; const ATrue: AnsiString; AFalse: AnsiString = ''): AnsiString; overload; {$IF CompilerVersion >= 17.0}inline;{$IFEND}
function  ALIfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer): Integer; overload; {$IF CompilerVersion >= 17.0}inline;{$IFEND}
function  ALIfThen(AValue: Boolean; const ATrue: Int64; const AFalse: Int64): Int64; overload; {$IF CompilerVersion >= 17.0}inline;{$IFEND}
function  ALIfThen(AValue: Boolean; const ATrue: UInt64; const AFalse: UInt64): UInt64; overload; {$IF CompilerVersion >= 17.0}inline;{$IFEND}
function  ALIfThen(AValue: Boolean; const ATrue: Single; const AFalse: Single): Single; overload; {$IF CompilerVersion >= 17.0}inline;{$IFEND}
function  ALIfThen(AValue: Boolean; const ATrue: Double; const AFalse: Double): Double; overload; {$IF CompilerVersion >= 17.0}inline;{$IFEND}
function  ALIfThen(AValue: Boolean; const ATrue: Extended; const AFalse: Extended): Extended; overload; {$IF CompilerVersion >= 17.0}inline;{$IFEND}
function  ALStrToInt(const S: AnsiString): Integer;
function  ALStrToIntDef(const S: AnsiString; Default: Integer): Integer;
function  ALTryStrToInt64(const S: AnsiString; out Value: Int64): Boolean;
function  ALStrToInt64(const S: AnsiString): Int64;
function  ALStrToInt64Def(const S: AnsiString; const Default: Int64): Int64;
function  ALIntToStr(Value: Integer): AnsiString; overload;
function  ALIntToStr(Value: Int64): AnsiString; overload;
//procedure ALStrMove(const Source: PAnsiChar; var Dest: PAnsiChar; Count: {$if CompilerVersion >= 23}{Delphi XE2}NativeInt{$ELSE}Integer{$IFEND});
procedure ALMove(const Source; var Dest; Count: {$if CompilerVersion >= 23}{Delphi XE2}NativeInt{$ELSE}Integer{$IFEND});

function  ALRandomStr(const aLength: Longint; const aCharset: Array of ansiChar): AnsiString; overload;
function  ALRandomStr(const aLength: Longint): AnsiString; overload;
function  ALRandomStrU(const aLength: Longint; const aCharset: Array of Char): String; overload;
function  ALRandomStrU(const aLength: Longint): String; overload;





(*function  ALFastTagReplace(const SourceString, TagStart, TagEnd: AnsiString;
                           ReplaceProc: TALHandleTagFunct;
                           StripParamQuotes: Boolean;
                           ExtData: Pointer;
                           Const flags: TReplaceFlags=[rfreplaceall];
                           const TagReplaceProcResult: Boolean = False): AnsiString; //overload;

                           *)
(*function  ALFastTagReplace(const SourceString, TagStart, TagEnd: AnsiString;
                           ReplaceExtendedProc: TALHandleTagExtendedfunct;
                           StripParamQuotes: Boolean;
                           ExtData: Pointer;
                           Const flags: TReplaceFlags=[rfreplaceall];
                           const TagReplaceProcResult: Boolean = False): AnsiString; overload;
function  ALFastTagReplace(const SourceString, TagStart, TagEnd: AnsiString;
                           const ReplaceWith: AnsiString;
                           const Flags: TReplaceFlags=[rfreplaceall]): AnsiString; overload;

  *)

var
  ALDefaultFormatSettings: TformatSettings;


implementation

uses Windows, alhttpcommon, masks;
     //sysutils;
     //ALFcnString;




constructor EALException.Create(const Msg: AnsiString);
begin
  inherited create(String(Msg));
end;

(*{**********************************************************************************************************************}
procedure ALMove(const Source; var Dest; Count: {$if CompilerVersion >= 23}{Delphi XE2}NativeInt{$ELSE}Integer{$IFEND});
begin
  System.Move(Source, Dest, Count);
end;*)


{*******************************************************************************************}
function  ALRandomStr(const aLength: Longint; const aCharset: Array of ansiChar): AnsiString;
var X: Longint;
begin
  if aLength <= 0 then exit;
  SetLength(Result, aLength);
  for X:=1 to aLength do Result[X] := aCharset[Random(length(aCharset))];
end;

{*******************************************************}
function ALRandomStr(const aLength: Longint): AnsiString;
begin
  Result := ALRandomStr(aLength,['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']);
end;

{************************************************************************************}
function ALRandomStrU(const aLength: Longint; const aCharset: Array of Char): String;
var X: Longint;
begin
  if aLength <= 0 then exit;
  SetLength(Result, aLength);
  for X:=1 to aLength do Result[X] := aCharset[Random(length(aCharset))];
end;

{****************************************************}
function ALRandomStrU(const aLength: Longint): String;
begin
  Result := ALRandomStrU(aLength,['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']);
end;



{**********************************************}
function ALIntToStr(Value: Integer): AnsiString;
{$IFDEF UNICODE}
begin
  if Value < 0 then
    Result := _ALIntToStr32(-Value, True)
  else
    Result := _ALIntToStr32(Value, False);
end;
{$ELSE}
begin
  result := IntToStr(Value);
end;
{$ENDIF}

{********************************************}
function ALIntToStr(Value: Int64): AnsiString;
{$IFDEF UNICODE}
begin
  if Value < 0 then
    Result := _ALIntToStr64(-Value, True)
  else
    Result := _ALIntToStr64(Value, False);
end;
{$ELSE}
begin
  result := IntToStr(Value);
end;
{$ENDIF}



{************************************************}
function ALStrToInt(const S: AnsiString): Integer;
{$IFDEF UNICODE}
var
  E: Integer;
begin
  Result := _ALValLong(S, E);
  if E <> 0 then raise EConvertError.CreateResFmt(@SysConst.SInvalidInteger, [S]);
end;
{$ELSE}
begin
  result := StrToInt(S);
end;
{$ENDIF}

{*********************************************************************}
function ALStrToIntDef(const S: AnsiString; Default: Integer): Integer;
{$IFDEF UNICODE}
var
  E: Integer;
begin
  Result := _ALValLong(S, E);
  if E <> 0 then Result := Default;
end;
{$ELSE}
begin
  result := StrToIntDef(S, Default);
end;
{$ENDIF}

{***********************************************************************}
function ALTryStrToInt64(const S: AnsiString; out Value: Int64): Boolean;
{$IFDEF UNICODE}
var
  E: Integer;
begin
  Value := _ALValInt64(S, E);
  Result := E = 0;
end;
{$ELSE}
begin
  result := TryStrToInt64(S, Value);
end;
{$ENDIF}


{************************************************}
function ALStrToInt64(const S: AnsiString): Int64;
{$IFDEF UNICODE}
var
  E: Integer;
begin
  Result := _ALValInt64(S, E);
  if E <> 0 then raise EConvertError.CreateResFmt(@SysConst.SInvalidInteger, [S]);
end;
{$ELSE}
begin
  result := StrToInt64(S);
end;
{$ENDIF}

{*************************************************************************}
function ALStrToInt64Def(const S: AnsiString; const Default: Int64): Int64;
{$IFDEF UNICODE}
var
  E: Integer;
begin
  Result := _ALValInt64(S, E);
  if E <> 0 then Result := Default;
end;
{$ELSE}
begin
  result := StrToInt64Def(S, Default);
end;
{$ENDIF}



{***********************************************************************************************}
function ALIfThen(AValue: Boolean; const ATrue: AnsiString; AFalse: AnsiString = ''): AnsiString;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

{***************************************************************************************}
function ALIfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer): Integer;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

{*********************************************************************************}
function ALIfThen(AValue: Boolean; const ATrue: Int64; const AFalse: Int64): Int64;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

{************************************************************************************}
function ALIfThen(AValue: Boolean; const ATrue: UInt64; const AFalse: UInt64): UInt64;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

{************************************************************************************}
function ALIfThen(AValue: Boolean; const ATrue: Single; const AFalse: Single): Single;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

{************************************************************************************}
function ALIfThen(AValue: Boolean; const ATrue: Double; const AFalse: Double): Double;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

{******************************************************************************************}
function ALIfThen(AValue: Boolean; const ATrue: Extended; const AFalse: Extended): Extended;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;



function ALMatchesMask(const Filename, Mask: AnsiString): Boolean;
var
  CMask: TMask;
begin
  CMask := TMask.Create(Mask);
  try
    Result := CMask.Matches(Filename);
  finally
    CMask.Free;
  end;
end;

function  ALQuotedStr(const S: AnsiString; const Quote: AnsiChar = ''''): AnsiString;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do
    if Result[I] = Quote then Insert(Quote, Result, I);
  Result := Quote + Result + Quote;
end;

{*************************************************************************}
function AlUTF8DetectBOM(const P: PansiChar; const Size: Integer): Boolean;
var Q: PansiChar;
begin
  Result := False;
  if Assigned(P) and (Size >= 3) and (P^ = #$EF) then begin
    Q := P;
    Inc(Q);
    if Q^ = #$BB then begin
      Inc(Q);
      if Q^ = #$BF then Result := True;
    end;
  end;
end;

{********************************************************}
function AlUTF8removeBOM(const S: AnsiString): AnsiString;
begin
  if AlUTF8DetectBOM(PAnsiChar(S), length(S)) then result := AlCopyStr(S,length(cAlUTF8BOM) + 1,Maxint)
  else Result := S;
end;


{***************************************************************************}
function ALExtractQuotedStr(var Src: PAnsiChar; Quote: AnsiChar): AnsiString;
var
  P, Dest: PAnsiChar;
  DropCount: Integer;
  EndSuffix: Integer;
begin
  Result := '';
  if (Src = nil) or (Src^ <> Quote) then Exit;
  Inc(Src);
  DropCount := 1;
  P := Src;
  Src := StrScan(Src, Quote);
  while Src <> nil do   // count adjacent pairs of quote chars
  begin
    Inc(Src);
    if Src^ <> Quote then Break;
    Inc(Src);
    Inc(DropCount);
    Src := StrScan(Src, Quote);
  end;
  EndSuffix := Ord(Src = nil); // Has an ending quoatation mark?
  if Src = nil then Src := StrEnd(P);
  if ((Src - P) <= 1 - EndSuffix) or ((Src - P - DropCount) = EndSuffix) then Exit;
  if DropCount = 1 then
    SetString(Result, P, Src - P - 1 + EndSuffix)
  else
  begin
    SetLength(Result, Src - P - DropCount + EndSuffix);
    Dest := PAnsiChar(Result);
    Src := StrScan(P, Quote);
    while Src <> nil do
    begin
      Inc(Src);
      if Src^ <> Quote then Break;
      Move(P^, Dest^, Src - P);
      Inc(Dest, Src - P);
      Inc(Src);
      P := Src;
      Src := StrScan(Src, Quote);
    end;
    if Src = nil then Src := StrEnd(P);
    Move(P^, Dest^, Src - P - 1 + EndSuffix);
  end;
end;

{************************************************************************}
function ALDequotedStr(const S: AnsiString; AQuote: AnsiChar): AnsiString;
var
  LText: PAnsiChar;
begin
  LText := PAnsiChar(S);
  Result := ALExtractQuotedStr(LText, AQuote);
  if ((Result = '') or (LText^ = #0)) and
     (Length(S) > 0) and ((S[1] <> AQuote) or (S[Length(S)] <> AQuote)) then
    Result := S;
end;

function ALGUIDToString(const Guid: TGUID): Ansistring;
begin
  SetLength(Result, 38);
  StrLFmt(PAnsiChar(Result), 38,'{%.8x-%.4x-%.4x-%.2x%.2x-%.2x%.2x%.2x%.2x%.2x%.2x}',   // do not localize
    [Guid.D1, Guid.D2, Guid.D3, Guid.D4[0], Guid.D4[1], Guid.D4[2], Guid.D4[3],
    Guid.D4[4], Guid.D4[5], Guid.D4[6], Guid.D4[7]]);
end;

{***************************************}
Function  ALMakeKeyStrByGUID: AnsiString;
Var aGUID: TGUID;
Begin
  CreateGUID(aGUID);
  Result := ALGUIDToString(aGUID);
  Delete(Result,1,1);
  Delete(Result,Length(result),1);
End;


{****************************************************************************}
Function ALUTF8Encode(const S: AnsiString; const aCodePage: Word): AnsiString;
begin
  Result := UTF8Encode(ALStringToWideString(S, aCodePage));
end;

{****************************************************************************}
Function ALUTF8decode(const S: AnsiString; const aCodePage: Word): AnsiString;
begin
  {$IFDEF UNICODE}
  Result := ALWideStringToString(UTF8ToWideString(S), aCodePage);
  {$ELSE}
  Result := ALWideStringToString(UTF8Decode(S), aCodePage);
  {$ENDIF}
end;

Function ALIsInt64(const S: AnsiString): Boolean;
var i : int64;
Begin
  Result := ALIsDecimal(S) and TryStrToInt64(S, I);
End;




Function ALGetCodePageFromCharSetName(Acharset:AnsiString): Word;
{$IF CompilerVersion >= 23} {Delphi XE2}
Var aEncoding: Tencoding;
begin
  Try
    aEncoding := Tencoding.GetEncoding(String(Acharset));
    Try
      Result := aEncoding.CodePage;
    Finally
      aEncoding.Free;
    end;
  Except
    Result := 0; // Default ansi code page
  end;
end;
{$ELSE}
begin
  Acharset := ALTrim(LowerCase(ACharset));
  if acharset='utf-8' then result := 65001 // unicode (utf-8)
  else if acharset='iso-8859-1' then result := 28591 // western european (iso)
  else if acharset='iso-8859-2' then result := 28592 // central european (iso)
  else if acharset='iso-8859-3' then result := 28593 // latin 3 (iso)
  else if acharset='iso-8859-4' then result := 28594 // baltic (iso)
  else if acharset='iso-8859-5' then result := 28595 // cyrillic (iso)
  else if acharset='iso-8859-6' then result := 28596 // arabic (iso)
  else if acharset='iso-8859-7' then result := 28597 // greek (iso)
  else if acharset='iso-8859-8' then result := 28598 // hebrew (iso-visual)
  else if acharset='iso-8859-9' then result := 28599 // turkish (iso)
  else if acharset='iso-8859-13' then result := 28603 // estonian (iso)
  else if acharset='iso-8859-15' then result := 28605 // latin 9 (iso)
  else if acharset='ibm037' then result := 37 // ibm ebcdic (us-canada)
  else if acharset='ibm437' then result := 437 // oem united states
  else if acharset='ibm500' then result := 500 // ibm ebcdic (international)
  else if acharset='asmo-708' then result := 708 // arabic (asmo 708)
  else if acharset='dos-720' then result := 720 // arabic (dos)
  else if acharset='ibm737' then result := 737 // greek (dos)
  else if acharset='ibm775' then result := 775 // baltic (dos)
  else if acharset='ibm850' then result := 850 // western european (dos)
  else if acharset='ibm852' then result := 852 // central european (dos)
  else if acharset='ibm855' then result := 855 // oem cyrillic
  else if acharset='ibm857' then result := 857 // turkish (dos)
  else if acharset='ibm00858' then result := 858 // oem multilingual latin i
  else if acharset='ibm860' then result := 860 // portuguese (dos)
  else if acharset='ibm861' then result := 861 // icelandic (dos)
  else if acharset='dos-862' then result := 862 // hebrew (dos)
  else if acharset='ibm863' then result := 863 // french canadian (dos)
  else if acharset='ibm864' then result := 864 // arabic (864)
  else if acharset='ibm865' then result := 865 // nordic (dos)
  else if acharset='cp866' then result := 866 // cyrillic (dos)
  else if acharset='ibm869' then result := 869 // greek, modern (dos)
  else if acharset='ibm870' then result := 870 // ibm ebcdic (multilingual latin-2)
  else if acharset='windows-874' then result := 874 // thai (windows)
  else if acharset='cp875' then result := 875 // ibm ebcdic (greek modern)
  else if acharset='shift_jis' then result := 932 // japanese (shift-jis)
  else if acharset='gb2312' then result := 936 // chinese simplified (gb2312)
  else if acharset='ks_c_5601-1987' then result := 949 // korean
  else if acharset='big5' then result := 950 // chinese traditional (big5)
  else if acharset='ibm1026' then result := 1026 // ibm ebcdic (turkish latin-5)
  else if acharset='ibm01047' then result := 1047 // ibm latin-1
  else if acharset='ibm01140' then result := 1140 // ibm ebcdic (us-canada-euro)
  else if acharset='ibm01141' then result := 1141 // ibm ebcdic (germany-euro)
  else if acharset='ibm01142' then result := 1142 // ibm ebcdic (denmark-norway-euro)
  else if acharset='ibm01143' then result := 1143 // ibm ebcdic (finland-sweden-euro)
  else if acharset='ibm01144' then result := 1144 // ibm ebcdic (italy-euro)
  else if acharset='ibm01145' then result := 1145 // ibm ebcdic (spain-euro)
  else if acharset='ibm01146' then result := 1146 // ibm ebcdic (uk-euro)
  else if acharset='ibm01147' then result := 1147 // ibm ebcdic (france-euro)
  else if acharset='ibm01148' then result := 1148 // ibm ebcdic (international-euro)
  else if acharset='ibm01149' then result := 1149 // ibm ebcdic (icelandic-euro)
  else if acharset='utf-16' then result := 1200 // unicode
  else if acharset='unicodefffe' then result := 1201 // unicode (big-endian)
  else if acharset='windows-1250' then result := 1250 // central european (windows)
  else if acharset='windows-1251' then result := 1251 // cyrillic (windows)
  else if acharset='windows-1252' then result := 1252 // western european (windows)
  else if acharset='windows-1253' then result := 1253 // greek (windows)
  else if acharset='windows-1254' then result := 1254 // turkish (windows)
  else if acharset='windows-1255' then result := 1255 // hebrew (windows)
  else if acharset='windows-1256' then result := 1256 // arabic (windows)
  else if acharset='windows-1257' then result := 1257 // baltic (windows)
  else if acharset='windows-1258' then result := 1258 // vietnamese (windows)
  else if acharset='johab' then result := 1361 // korean (johab)
  else if acharset='macintosh' then result := 10000 // western european (mac)
  else if acharset='x-mac-japanese' then result := 10001 // japanese (mac)
  else if acharset='x-mac-chinesetrad' then result := 10002 // chinese traditional (mac)
  else if acharset='x-mac-korean' then result := 10003 // korean (mac)
  else if acharset='x-mac-arabic' then result := 10004 // arabic (mac)
  else if acharset='x-mac-hebrew' then result := 10005 // hebrew (mac)
  else if acharset='x-mac-greek' then result := 10006 // greek (mac)
  else if acharset='x-mac-cyrillic' then result := 10007 // cyrillic (mac)
  else if acharset='x-mac-chinesesimp' then result := 10008 // chinese simplified (mac)
  else if acharset='x-mac-romanian' then result := 10010 // romanian (mac)
  else if acharset='x-mac-ukrainian' then result := 10017 // ukrainian (mac)
  else if acharset='x-mac-thai' then result := 10021 // thai (mac)
  else if acharset='x-mac-ce' then result := 10029 // central european (mac)
  else if acharset='x-mac-icelandic' then result := 10079 // icelandic (mac)
  else if acharset='x-mac-turkish' then result := 10081 // turkish (mac)
  else if acharset='x-mac-croatian' then result := 10082 // croatian (mac)
  else if acharset='x-chinese-cns' then result := 20000 // chinese traditional (cns)
  else if acharset='x-cp20001' then result := 20001 // tca taiwan
  else if acharset='x-chinese-eten' then result := 20002 // chinese traditional (eten)
  else if acharset='x-cp20003' then result := 20003 // ibm5550 taiwan
  else if acharset='x-cp20004' then result := 20004 // teletext taiwan
  else if acharset='x-cp20005' then result := 20005 // wang taiwan
  else if acharset='x-ia5' then result := 20105 // western european (ia5)
  else if acharset='x-ia5-german' then result := 20106 // german (ia5)
  else if acharset='x-ia5-swedish' then result := 20107 // swedish (ia5)
  else if acharset='x-ia5-norwegian' then result := 20108 // norwegian (ia5)
  else if acharset='us-ascii' then result := 20127 // us-ascii
  else if acharset='x-cp20261' then result := 20261 // t.61
  else if acharset='x-cp20269' then result := 20269 // iso-6937
  else if acharset='ibm273' then result := 20273 // ibm ebcdic (germany)
  else if acharset='ibm277' then result := 20277 // ibm ebcdic (denmark-norway)
  else if acharset='ibm278' then result := 20278 // ibm ebcdic (finland-sweden)
  else if acharset='ibm280' then result := 20280 // ibm ebcdic (italy)
  else if acharset='ibm284' then result := 20284 // ibm ebcdic (spain)
  else if acharset='ibm285' then result := 20285 // ibm ebcdic (uk)
  else if acharset='ibm290' then result := 20290 // ibm ebcdic (japanese katakana)
  else if acharset='ibm297' then result := 20297 // ibm ebcdic (france)
  else if acharset='ibm420' then result := 20420 // ibm ebcdic (arabic)
  else if acharset='ibm423' then result := 20423 // ibm ebcdic (greek)
  else if acharset='ibm424' then result := 20424 // ibm ebcdic (hebrew)
  else if acharset='x-ebcdic-koreanextended' then result := 20833 // ibm ebcdic (korean extended)
  else if acharset='ibm-thai' then result := 20838 // ibm ebcdic (thai)
  else if acharset='koi8-r' then result := 20866 // cyrillic (koi8-r)
  else if acharset='ibm871' then result := 20871 // ibm ebcdic (icelandic)
  else if acharset='ibm880' then result := 20880 // ibm ebcdic (cyrillic russian)
  else if acharset='ibm905' then result := 20905 // ibm ebcdic (turkish)
  else if acharset='ibm00924' then result := 20924 // ibm latin-1
  else if acharset='euc-jp' then result := 20932 // japanese (jis 0208-1990 and 0212-1990)
  else if acharset='x-cp20936' then result := 20936 // chinese simplified (gb2312-80)
  else if acharset='x-cp20949' then result := 20949 // korean wansung
  else if acharset='cp1025' then result := 21025 // ibm ebcdic (cyrillic serbian-bulgarian)
  else if acharset='koi8-u' then result := 21866 // cyrillic (koi8-u)
  else if acharset='x-europa' then result := 29001 // europa
  else if acharset='iso-8859-8-i' then result := 38598 // hebrew (iso-logical)
  else if acharset='iso-2022-jp' then result := 50220 // japanese (jis)
  else if acharset='csiso2022jp' then result := 50221 // japanese (jis-allow 1 byte kana)
  else if acharset='iso-2022-jp' then result := 50222 // japanese (jis-allow 1 byte kana - so/si)
  else if acharset='iso-2022-kr' then result := 50225 // korean (iso)
  else if acharset='x-cp50227' then result := 50227 // chinese simplified (iso-2022)
  else if acharset='euc-jp' then result := 51932 // japanese (euc)
  else if acharset='euc-cn' then result := 51936 // chinese simplified (euc)
  else if acharset='euc-kr' then result := 51949 // korean (euc)
  else if acharset='hz-gb-2312' then result := 52936 // chinese simplified (hz)
  else if acharset='gb18030' then result := 54936 // chinese simplified (gb18030)
  else if acharset='x-iscii-de' then result := 57002 // iscii devanagari
  else if acharset='x-iscii-be' then result := 57003 // iscii bengali
  else if acharset='x-iscii-ta' then result := 57004 // iscii tamil
  else if acharset='x-iscii-te' then result := 57005 // iscii telugu
  else if acharset='x-iscii-as' then result := 57006 // iscii assamese
  else if acharset='x-iscii-or' then result := 57007 // iscii oriya
  else if acharset='x-iscii-ka' then result := 57008 // iscii kannada
  else if acharset='x-iscii-ma' then result := 57009 // iscii malayalam
  else if acharset='x-iscii-gu' then result := 57010 // iscii gujarati
  else if acharset='x-iscii-pa' then result := 57011 // iscii punjabi
  else if acharset='utf-7' then result := 65000 // unicode (utf-7)
  else if acharset='utf-32' then result := 65005 // unicode (utf-32)
  else if acharset='utf-32be' then result := 65006 // unicode (utf-32 big-endian)
  else Result := 0; //Default ansi code page
end;
{$IFEND}


{*****************************************************************************************}
{from John O'Harrow (john@elmcrest.demon.co.uk) - original name: StringReplace_JOH_IA32_12}
function ALPosExIgnoreCase(const SubStr, S: Ansistring; Offset: Integer = 1): Integer;
var
  I, LIterCnt, L, J: Integer;
  PSubStr, PS: PAnsiChar;
  C1, C2: AnsiChar;
begin
  { Calculate the number of possible iterations. Not valid if Offset < 1. }
  LIterCnt := Length(S) - Offset - Length(SubStr) + 1;

  { Only continue if the number of iterations is positive or zero (there is space to check) }
  if (Offset > 0) and (LIterCnt >= 0) then begin
    L := Length(SubStr);
    PSubStr := PAnsiChar(SubStr);
    PS := PAnsiChar(S);
    Inc(PS, Offset - 1);

    for I := 0 to LIterCnt do begin
      J := 0;
      while (J >= 0) and (J < L) do begin
        C1 := (PS + I + J)^;
        C2 := (PSubStr + J)^;
        if (C1 = C2) or
           ((C1 in ['a' .. 'z']) and
            (C1 = AnsiChar(Byte(C2) + $20))) or
           ((C1 in ['A' .. 'Z']) and
            (C1 = AnsiChar(Byte(C2) - $20))) then
          Inc(J)
        else
          J := -1;
      end;
      if J >= L then
        Exit; //(I + Offset);
    end;
    //for I := 0 to LIterCnt do
    //  if StrLComp(PS + I, PSubStr, L) = 0 then
    //    Exit(I + Offset);
  end;
  Result := 0;
end;



{**********************************************************************************************************************}
procedure ALMove(const Source; var Dest; Count: {$if CompilerVersion >= 23}{Delphi XE2}NativeInt{$ELSE}Integer{$IFEND});
begin
  System.Move(Source, Dest, Count);
end;

{***********************************************************************************************}
// warning ALStrMove inverse the order of the original StrMove (to keep the same order as ALMove)
procedure ALStrMove(const Source: PAnsiChar; var Dest: PAnsiChar; Count: {$if CompilerVersion >= 23}{Delphi XE2}NativeInt{$ELSE}Integer{$IFEND});
begin
  ALMove(Source^, Dest^, Count);
end;


{************************************************************************************}
Function ALStringToWideString(const S: AnsiString; const aCodePage: Word): WideString;
var InputLength,
    OutputLength: Integer;
begin
  InputLength := Length(S);
  if InputLength = 0 then begin
    result := '';
    exit;
  end;
  OutputLength := MultiByteToWideChar(aCodePage,     // UINT CodePage,
                                      0,             // DWORD dwFlags
                                      PAnsiChar(S),  // LPCSTR lpMultiByteStr
                                      InputLength,   // int cbMultiByte
                                      nil,           // LPWSTR lpWideCharStr
                                      0);            // int cchWideChar
  if OutputLength = 0 then raiseLastOsError;
  SetLength(Result, OutputLength);
  if MultiByteToWideChar(aCodePage,
                         0,
                         PAnsiChar(S),
                         InputLength,
                         PWideChar(Result),
                         OutputLength) = 0 then raiseLastOsError;
end;

{*************************************************************************************}
function AlWideStringToString(const WS: WideString; const aCodePage: Word): AnsiString;
var InputLength,
    OutputLength: Integer;
begin
  InputLength := Length(WS);
  if InputLength = 0 then begin
    result := '';
    exit;
  end;
  OutputLength := WideCharToMultiByte(aCodePage,      // UINT CodePage
                                      0,              // DWORD dwFlags,
                                      PWideChar(WS),  // LPCWSTR lpWideCharStr,
                                      InputLength,    // int cchWideChar
                                      nil,            // LPSTR lpMultiByteStr,
                                      0,              // int cbMultiByte
                                      nil,            // LPCSTR lpDefaultChar (Pointer to the character to use if a character cannot be represented in the specified code page)
                                      nil);           // LPBOOL lpUsedDefaultChar (Pointer to a flag that indicates if the function has used a default character in the conversion)
  if OutputLength = 0 then raiseLastOsError;
  SetLength(Result, OutputLength);
  if WideCharToMultiByte(aCodePage,
                         0,
                         PWideChar(WS),
                         InputLength,
                         PAnsiChar(Result),
                         OutputLength,
                         nil,
                         nil) = 0 then raiseLastOsError;
end;


{*************************************************************************}
(*function ALFastTagReplaceint(Const SourceString, TagStart, TagEnd: AnsiString;
                          ReplaceProc: TALHandleTagFunct;
                          ReplaceExtendedProc: TALHandleTagExtendedfunct;
                          Const ReplaceWith: AnsiString;
                          StripParamQuotes: Boolean;
                          Flags: TReplaceFlags;
                          ExtData: Pointer;
                          const TagReplaceProcResult: Boolean = False): AnsiString; //overload;

var ReplaceString: AnsiString;
    TagEndFirstChar, TagEndFirstCharLower, TagEndFirstCharUpper: AnsiChar;
    TokenStr, ParamStr: AnsiString;
    ParamList: TAlStringList;
    TagStartLength: integer;
    TagEndLength: integer;
    SourceStringLength: Integer;
    InDoubleQuote: Boolean;
    InsingleQuote: Boolean;
    TagHandled: Boolean;
    SourceCurrentPos: integer;
    ResultCurrentPos: integer;
    ResultCurrentLength: integer;
    IgnoreCase: Boolean;
    PosExFunct: Function(const SubStr, S: AnsiString; Offset: Integer = 1): Integer;
    T1,T2: Integer;

Const ResultBuffSize: integer = 16384;

    {------------------------------------}
    Function _ExtractTokenStr: AnsiString;
    var x: Integer;
    Begin
      X := 1;
      while (x <= length(ReplaceString)) and
            (not (ReplaceString[x] in [' ', #9, #13, #10])) do inc(x);
      if x > length(ReplaceString) then Result := ReplaceString
      else Result := AlcopyStr(ReplaceString,1,x-1);
    end;

    {-------------------------------------}
    Function _ExtractParamsStr: AnsiString;
    Begin
      Result := ALTrim(AlcopyStr(ReplaceString,length(TokenStr) + 1, MaxInt));
    end;

    {----------------------------------------}
    Procedure _MoveStr2Result(Src:AnsiString);
    Var l: integer;
    Begin
      If Src <> '' then begin
        L := Length(Src);
        If L+ResultCurrentPos-1>ResultCurrentLength Then begin
          ResultCurrentLength := ResultCurrentLength + L + ResultBuffSize;
          SetLength(Result,ResultCurrentLength);
        end;
        AlMove(Src[1],Result[ResultCurrentPos],L);
        ResultCurrentPos := ResultCurrentPos + L;
      end;
    end;

begin
  if (SourceString = '') or (TagStart = '') or (TagEnd = '') then begin
    Result := SourceString;
    Exit;
  end;

  IgnoreCase := rfIgnoreCase in flags;
  If IgnoreCase then PosExFunct := ALPosExIgnoreCase
  Else PosExFunct := ALPosEx;

  SourceStringLength := length(SourceString);
  ResultCurrentLength := SourceStringLength;
  SetLength(Result,ResultCurrentLength);
  ResultCurrentPos := 1;
  TagStartLength := Length(TagStart);
  TagEndLength := Length(TagEnd);
  TagEndFirstChar := TagEnd[1];
  TagEndFirstCharLower := LowerCase(TagEnd[1])[1];
  TagEndFirstCharUpper := UpperCase(TagEnd[1])[1];
  SourceCurrentPos := 1;

  T1 := PosExFunct(TagStart,SourceString,SourceCurrentPos);
  T2 := T1 + TagStartLength;
  If (T1 > 0) and (T2 <= SourceStringLength) then begin
    InDoubleQuote := False;
    InsingleQuote := False;
    While (T2 <= SourceStringLength) and
          (InDoubleQuote or
           InSingleQuote or
           (IgnoreCase and (not (SourceString[T2] in [TagEndFirstCharLower, TagEndFirstCharUpper]))) or
           ((not IgnoreCase) and (SourceString[T2] <> TagEndFirstChar)) or
           (PosExFunct(TagEnd,AlCopyStr(SourceString,T2,TagEndLength),1) <> 1)) do begin
      If SourceString[T2] = '"' then InDoubleQuote := (not InDoubleQuote) and (not InSingleQuote)
      else If SourceString[T2] = '''' then InSingleQuote := (not InSingleQuote) and (not InDoubleQuote);
      inc(T2);
    end;
    if (T2 > SourceStringLength) then T2 := 0;
  end;


  While (T1 > 0) and (T2 > T1) do begin
    ReplaceString := AlCopyStr(SourceString,T1 + TagStartLength,T2 - T1 - TagStartLength);
    T2 := T2 + TagEndLength;

    TagHandled := True;
    If assigned(ReplaceProc) or (assigned(ReplaceExtendedProc)) then begin
      TokenStr := _ExtractTokenStr;
      ParamStr := _ExtractParamsStr;
      ParamList := TAlStringList.Create;
      try
        ALExtractHeaderFieldsWithQuoteEscaped([' ', #9, #13, #10],
                                              [' ', #9, #13, #10],
                                              ['"', ''''],
                                              PAnsiChar(ParamStr),
                                              ParamList,
                                              False,
                                              StripParamQuotes);
        if assigned(ReplaceExtendedProc) then begin
          T2 := T2 - T1;
          ReplaceString := ReplaceExtendedProc(TokenStr, ParamList, ExtData, TagHandled, SourceString, T1, T2);
          T2 := T2 + T1;
        end
        else ReplaceString := ReplaceProc(TokenStr, ParamList, ExtData, TagHandled);
        if (TagHandled) and
           (TagReplaceProcResult) and
           (rfreplaceAll in flags) then ReplaceString:= ALFastTagReplaceint(ReplaceString,
                                                                          TagStart,
                                                                          TagEnd,
                                                                          ReplaceProc,
                                                                          ReplaceExtendedProc,
                                                                          ReplaceWith,
                                                                          StripParamQuotes,
                                                                          Flags,
                                                                          ExtData,
                                                                          TagReplaceProcResult);
      finally
        ParamList.Free;
      end;
    end
    else ReplaceString := ReplaceWith;

    If tagHandled then _MoveStr2Result(AlcopyStr(SourceString,SourceCurrentPos,T1 - SourceCurrentPos) + ReplaceString)
    else _MoveStr2Result(AlcopyStr(SourceString,SourceCurrentPos,T2 - SourceCurrentPos));
    SourceCurrentPos := T2;

    If TagHandled and (not (rfreplaceAll in flags)) then Break;

    T1 := PosExFunct(TagStart,SourceString,SourceCurrentPos);
    T2 := T1 + TagStartLength;
    If (T1 > 0) and (T2 <= SourceStringLength) then begin
      InDoubleQuote := False;
      InsingleQuote := False;
      While (T2 <= SourceStringLength) and
            (InDoubleQuote or
             InSingleQuote or
             (IgnoreCase and (not (SourceString[T2] in [TagEndFirstCharLower, TagEndFirstCharUpper]))) or
             ((not IgnoreCase) and (SourceString[T2] <> TagEndFirstChar)) or
             (PosExFunct(TagEnd,AlCopyStr(SourceString,T2,TagEndLength),1) <> 1)) do begin
        If SourceString[T2] = '"' then InDoubleQuote := (not InDoubleQuote) and (not InSingleQuote)
        else If SourceString[T2] = '''' then InSingleQuote := (not InSingleQuote) and (not InDoubleQuote);
        inc(T2);
      end;
      if (T2 > SourceStringLength) then T2 := 0;
    end;
  end;

  _MoveStr2Result(AlcopyStr(SourceString,SourceCurrentPos,maxint));
  SetLength(Result,ResultCurrentPos-1);
end;


{*************************************************************************}
function ALFastTagReplace(const SourceString, TagStart, TagEnd: AnsiString;
                          ReplaceProc: TALHandleTagFunct;
                          StripParamQuotes: Boolean;
                          ExtData: Pointer;
                          Const flags: TReplaceFlags=[rfreplaceall];
                          const TagReplaceProcResult: Boolean = False): AnsiString;
Begin
  result := ALFastTagReplaceint(SourceString,
                             TagStart,
                             TagEnd,
                             ReplaceProc,
                             nil,
                             '',
                             StripParamQuotes,
                             flags,
                             extdata,
                             TagReplaceProcResult);
end;  *)

(*
{*************************************************************************}
function ALFastTagReplace(const SourceString, TagStart, TagEnd: AnsiString;
                          ReplaceExtendedProc: TALHandleTagExtendedfunct;
                          StripParamQuotes: Boolean;
                          ExtData: Pointer;
                          Const flags: TReplaceFlags=[rfreplaceall];
                          const TagReplaceProcResult: Boolean = False): AnsiString;
Begin
  result := ALFastTagReplace(SourceString,
                             TagStart,
                             TagEnd,
                             nil,
                             ReplaceExtendedProc,
                             '',
                             StripParamQuotes,
                             flags,
                             extdata,
                             TagReplaceProcResult);
end;

{*************************************************************************}
function ALFastTagReplace(const SourceString, TagStart, TagEnd: AnsiString;
                          const ReplaceWith: AnsiString;
                          const Flags: TReplaceFlags=[rfreplaceall]): AnsiString;
Begin
  Result := ALFastTagReplace(SourceString,
                             TagStart,
                             TagEnd,
                             nil,
                             nil,
                             ReplaceWith,
                             True,
                             flags,
                             nil,
                             false);
end;      *)




{***************************************************************}
function ALIntToHex(Value: Integer; Digits: Integer): AnsiString; overload;
{$IFDEF UNICODE}
begin
  Result := _ALIntToHex(Cardinal(Value), Digits);
end;
{$ELSE}
begin
  result := IntToHex(Value, Digits);
end;
{$ENDIF}

{*************************************************************}
function ALIntToHex(Value: Int64; Digits: Integer): AnsiString;     overload;
{$IFDEF UNICODE}
begin
  Result := _ALIntToHex(Value, digits);
end;
{$ELSE}
begin
  result := IntToHex(Value, Digits);
end;
{$ENDIF}



function ALPos(const SubStr, Str: AnsiString): Integer;
begin
  {$IFDEF UNICODE}
  Result := System.Pos(SubStr, Str);
  {$ELSE}
  Result := Pos(SubStr, Str);
  {$ENDIF}
end;

{**************************************************************************}
function ALPosEx(const SubStr, S: AnsiString; Offset: Integer = 1): Integer;
begin
  {$IFDEF UNICODE}
  Result := System.AnsiStrings.PosEx(SubStr, S, Offset);
  {$ELSE}
  Result := PosEx(SubStr, S, Offset);
  {$ENDIF}
end;

var
  vALPosExIgnoreCaseLookupTable: packed array[AnsiChar] of AnsiChar; {Upcase Lookup Table}

{***********************************************}
procedure ALPosExIgnoreCaseInitialiseLookupTable;
var Ch: AnsiChar;
begin
  //for Ch := #0 to #255 do
    //vALPosExIgnoreCaseLookupTable[Ch] := AlUpperCase(Ch)[1];
end;


{*************************************************}
function ALIsDecimal(const S: AnsiString): boolean;
var i: integer;
begin
  result := true;
  for i := 1 to length(S) do begin
    if not (S[i] in ['0'..'9','-']) then begin
      result := false;
      break;
    end;
  end;
end;

{*************************************************}
Function ALIsInteger(const S: AnsiString): Boolean;
var i: integer;
Begin
  result := ALIsDecimal(S) and TryStrToInt(S, i);
End;


 function ALGetStringFromFile(filename: AnsiString; const ShareMode: Word = fmShareDenyWrite): AnsiString;
Var AFileStream: TfileStream;
begin
  AFileStream := TFileStream.Create(String(filename),fmOpenRead or ShareMode);
  try

    If AFileStream.size > 0 then begin
      SetLength(Result, AFileStream.size);
      AfileStream.Read(Result[1],AfileStream.Size)
    end
    else Result := '';

  finally
    AfileStream.Free;
  end;
end;

{******************************************************************}
procedure ALSaveStringtoFile(Str: AnsiString; filename: AnsiString);
Var AStringStream: TStringStream;
    AMemoryStream: TMemoryStream;
begin
  AMemoryStream := TMemoryStream.Create;
  try

    AStringStream := TStringStream.Create(str);
    try
      AmemoryStream.LoadFromStream(AstringStream);
      AmemoryStream.SaveToFile(String(filename));
    finally
      AStringStream.Free;
    end;

  finally
    AMemoryStream.Free;
  end;
end;




{******************************************}
Function AlBoolToInt(Value:Boolean):Integer;
Begin
  If Value then result := 1
  else result := 0;
end;

{***************************************************************}
Function ALMediumPos(LTotal, LBorder, LObject : integer):Integer;
Begin
  result := (LTotal - (LBorder*2) - LObject) div 2 + LBorder;
End;

{************************************************}
function  ALTrim(const S: AnsiString): AnsiString;
begin
  //{$IFDEF UNICODE}
  //Result := System.AnsiStrings.Trim(S);
  //{$ELSE}
  Result := Trim(S);
  //{$ENDIF}
end;



function ALCopyStr(const aSourceString: AnsiString; aStart, aLength: Integer): AnsiString;
var aSourceStringLength: Integer;
begin
  aSourceStringLength := Length(aSourceString);
  If (aStart < 1) then aStart := 1;

  if (aSourceStringLength=0) or
     (aLength < 1) or
     (aStart > aSourceStringLength) then Begin
    Result := '';
    Exit;
  end;

  if aLength > aSourceStringLength - (aStart - 1) then aLength := aSourceStringLength - (aStart-1);

  SetLength(Result,aLength);
  Move(aSourceString[aStart], Result[1], aLength);
end;


{********************************************************}
function AlIsValidEmail(const Value: AnsiString): boolean;

 {------------------------------------------------------}
 function CheckAllowedName(const s: AnsiString): boolean;
 var i: integer;
 begin
   Result:= false;
   for i:= 1 to Length(s) do begin
     // illegal char in s -> no valid address
     if not (s[i] in ['a'..'z','A'..'Z','0'..'9','_','-','.','+']) then Exit;
   end;
   Result:= true;
 end;

 {----------------------------------------------------------}
 function CheckAllowedHostname(const s: AnsiString): boolean;
 var i: integer;
 begin
   Result:= false;
   for i:= 1 to Length(s) do begin
     // illegal char in s -> no valid address
     if not (s[i] in ['a'..'z','A'..'Z','0'..'9','-','.']) then Exit;
   end;
   Result:= true;
 end;



{**************************************************************************}
function ALPosEx(const SubStr, S: AnsiString; Offset: Integer = 1): Integer;
begin
//  {$IFDEF UNICODE}
  //Result := System.AnsiStrings.PosEx(SubStr, S, Offset);
  //{$ELSE}
  Result := PosEx(SubStr, S, Offset);
  //Result := Pos(SubStr, S);

  //{$ENDIF}
end;



 {-----------------------------------------------------}
 function CheckAllowedExt(const s: AnsiString): boolean;
 var i: integer;
 begin
   Result:= false;
   for i:= 1 to Length(s) do begin
     // illegal char in s -> no valid address
     if not (s[i] in ['a'..'z','A'..'Z']) then Exit;
   end;
   Result:= true;
 end;

var i, j: integer;
    namePart, serverPart, extPart: AnsiString;
begin
  Result := false;

  // Value can not be < 6 char (ex: a@b.fr)
  if length(Value) < 6 then exit;

  // must have the '@' char inside
  i := Pos('@', Value);
  if (i <= 1) or (i > length(Value)-4) then exit;

  //can not have @. or .@
  if (value[i-1] = '.') or (value[i+1] = '.') then exit;

  //can not have 2 ..
  If (pos('..', Value) > 0) then Exit;

  //extract namePart and serverPart
  namePart:= ALCopyStr(Value, 1, i - 1);
  serverPart:= ALCopyStr(Value, i + 1, Length(Value));

  // Extension (.fr, .com, etc..) must be betwen 2 to 6 char
  i:= Pos('.', serverPart);
  j := 0;
  While I > 0 do begin
    j := i;
    I := ALPosEx('.', serverPart, i + 1);
  end;
  if (j <= 1) then Exit; // no dot at all so exit !
  extPart    := AlCopyStr(ServerPart,J+1,Maxint);
  serverPart := ALCopyStr(ServerPart, 1, J - 1);
  If not (Length(ExtPart) in [2..6]) then exit;

  Result:= CheckAllowedname(namePart) and
           CheckAllowedHostname(serverPart) and
           CheckAllowedExt(ExtPart);
end;

{********************************************************************************}
function AlLocalDateTimeToGMTDateTime(Const aLocalDateTime: TDateTime): TdateTime;

  {--------------------------------------------}
  function InternalCalcTimeZoneBias : TDateTime;
  const Time_Zone_ID_DayLight = 2;
  var TZI: TTimeZoneInformation;
      TZIResult: Integer;
      aBias : Integer;
  begin
    TZIResult := GetTimeZoneInformation(TZI);
    if TZIResult = -1 then Result := 0
    else begin
      if TZIResult = Time_Zone_ID_DayLight then aBias := TZI.Bias + TZI.DayLightBias
      else aBias := TZI.Bias + TZI.StandardBias;
      Result := EncodeTime(Abs(aBias) div 60, Abs(aBias) mod 60, 0, 0);
      if aBias < 0 then Result := -Result;
    end;
  end;

begin
  Result := aLocalDateTime + InternalCalcTimeZoneBias;
end;

{******************************************************}
Function ALInc(var x: integer; Count: integer): Integer;
begin
  inc(X, count);
  result := X;
end;

end.
