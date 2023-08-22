{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}

unit StrUtils;

interface

uses
  SysUtils, Types;

{ AnsiResemblesText returns true if the two strings are similar (using a
  Soundex algorithm or something similar) }

function ResemblesText(const AText, AOther: string): Boolean; overload;
function AnsiResemblesText(const AText, AOther: string): Boolean; overload;

{ AnsiContainsText returns true if the subtext is found, without
  case-sensitivity, in the given text }

function ContainsText(const AText, ASubText: string): Boolean; inline; overload;
function AnsiContainsText(const AText, ASubText: string): Boolean; overload;

{ AnsiStartsText & AnsiEndText return true if the leading or trailing part
  of the given text matches, without case-sensitivity, the subtext }

function StartsText(const ASubText, AText: string): Boolean; inline; overload;
function AnsiStartsText(const ASubText, AText: string): Boolean; overload;

function EndsText(const ASubText, AText: string): Boolean; inline; overload;
function AnsiEndsText(const ASubText, AText: string): Boolean; overload;

{ AnsiReplaceText will replace all occurrences of a substring, without
  case-sensitivity, with another substring (recursion substring replacement
  is not supported) }

function ReplaceText(const AText, AFromText, AToText: string): string; inline; overload;
function AnsiReplaceText(const AText, AFromText, AToText: string): string; overload;

{ AnsiMatchText & AnsiIndexText provide case like function for dealing with
  strings }

function MatchText(const AText: string; const AValues: array of string): Boolean; overload;
function AnsiMatchText(const AText: string; const AValues: array of string): Boolean; overload;

function IndexText(const AText: string; const AValues: array of string): Integer; overload;
function AnsiIndexText(const AText: string; const AValues: array of string): Integer; overload;

{ These function are similar to some of the above but are case-sensitive }

function ContainsStr(const AText, ASubText: string): Boolean; inline; overload;
function AnsiContainsStr(const AText, ASubText: string): Boolean; overload;

function StartsStr(const ASubText, AText: string): Boolean; inline; overload;
function AnsiStartsStr(const ASubText, AText: string): Boolean; overload;

function EndsStr(const ASubText, AText: string): Boolean; inline; overload;
function AnsiEndsStr(const ASubText, AText: string): Boolean; overload;

function ReplaceStr(const AText, AFromText, AToText: string): string; inline; overload;
function AnsiReplaceStr(const AText, AFromText, AToText: string): string; overload;

function MatchStr(const AText: string; const AValues: array of string): Boolean; overload;
function AnsiMatchStr(const AText: string; const AValues: array of string): Boolean; overload;

function IndexStr(const AText: string; const AValues: array of string): Integer; overload;
function AnsiIndexStr(const AText: string; const AValues: array of string): Integer; overload;

{ DupeString will return N copies of the given string }

function DupeString(const AText: string; ACount: Integer): string; overload;

{ ReverseString simply reverses the given string }

function ReverseString(const AText: string): string; overload;
function AnsiReverseString(const AText: string): string; overload;

{ StuffString replaces a segment of a string with another one }

function StuffString(const AText: string; AStart, ALength: Cardinal;
  const ASubText: string): string; overload;

{ RandomFrom will randomly return one of the given strings }

function RandomFrom(const AValues: array of string): string; overload; overload;

{ IfThen will return the true string if the value passed in is true, else
  it will return the false string }

function IfThen(AValue: Boolean; const ATrue: string;
  AFalse: string = ''): string; overload;

{ Basic-like functions / Left, Right, Mid }

function LeftStr(const AText: AnsiString; const ACount: Integer): AnsiString; overload;
function LeftStr(const AText: WideString; const ACount: Integer): WideString; overload;

function RightStr(const AText: AnsiString; const ACount: Integer): AnsiString; overload;
function RightStr(const AText: WideString; const ACount: Integer): WideString; overload;

function MidStr(const AText: AnsiString; const AStart, ACount: Integer): AnsiString; overload;
function MidStr(const AText: WideString; const AStart, ACount: Integer): WideString; overload;

{ Basic-like functions / LeftB, RightB, MidB
  these functions don't care locale information.
}

function LeftBStr(const AText: AnsiString; const AByteCount: Integer): AnsiString;
function RightBStr(const AText: AnsiString; const AByteCount: Integer): AnsiString;
function MidBStr(const AText: AnsiString; const AByteStart, AByteCount: Integer): AnsiString;

{ Basic-like functions / Delphi style function name }

function AnsiLeftStr(const AText: string; const ACount: Integer): string; overload;
function AnsiRightStr(const AText: string; const ACount: Integer): string; overload;
function AnsiMidStr(const AText: string; const AStart, ACount: Integer): string; overload;

const
  { Default word delimiters are any character except the core alphanumerics. }
  WordDelimiters: set of AnsiChar = [#0..#255] - ['a'..'z','A'..'Z','1'..'9','0'];

type
  TStringSeachOption = (soDown, soMatchCase, soWholeWord);
  TStringSearchOptions = set of TStringSeachOption;

{ SearchBuf is a search routine for arbitrary text buffers.  If a match is
  found, the function returns a pointer to the start of the matching
  string in the buffer.  If no match is found, the function returns nil.
  If soDown is specified, a forward search is performed otherwise the function
  searches backwards through the text.  Use SelStart and SelLength to skip
  "selected" text; this will cause the search to start before or after (soDown)
  the specified text. }

function SearchBuf(Buf: PAnsiChar; BufLen: Integer; SelStart, SelLength: Integer;
  SearchString: AnsiString; Options: TStringSearchOptions = [soDown]): PAnsiChar; overload;
{$IFDEF UNICODE}
function SearchBuf(Buf: PWideChar; BufLen: Integer; SelStart, SelLength: Integer;
  SearchString: UnicodeString; Options: TStringSearchOptions = [soDown]): PWideChar; overload;
{$ENDIF}

{ PosEx searches for SubStr in S and returns the index position of
  SubStr if found and 0 otherwise.  If Offset is not given then the result is
  the same as calling Pos.  If Offset is specified and > 1 then the search
  starts at position Offset within S.  If Offset is larger than Length(S)
  then PosEx returns 0.  By default, Offset equals 1.  }

function PosEx(const SubStr, S: string; Offset: Integer = 1): Integer; overload;

{ Soundex function returns the Soundex code for the given string.  Unlike
  the original Soundex routine this function can return codes of varying
  lengths.  This function is loosely based on SoundBts which was written
  by John Midwinter.  For more information about Soundex see:

    http://www.nara.gov/genealogy/coding.html

  The general theory behind this function was originally patented way back in
  1918 (US1261167 & US1435663) but are now in the public domain.

  NOTE: This function does not attempt to deal with 'names with prefixes'
        issue.
  }

type
  TSoundexLength = 1..MaxInt;

function Soundex(const AText: string; ALength: TSoundexLength = 4): string;

{ SoundexInt uses Soundex but returns the resulting Soundex code encoded
  into an integer.  However, due to limits on the size of an integer, this
  function is limited to Soundex codes of eight characters or less.

  DecodeSoundexInt is designed to decode the results of SoundexInt back to
  a normal Soundex code.  Length is not required since it was encoded into
  the results of SoundexInt. }

type
  TSoundexIntLength = 1..8;

function SoundexInt(const AText: string; ALength: TSoundexIntLength = 4): Integer;
function DecodeSoundexInt(AValue: Integer): string;

{ SoundexWord is a special case version of SoundexInt that returns the
  Soundex code encoded into a word.  However, due to limits on the size of a
  word, this function uses a four character Soundex code.

  DecodeSoundexWord is designed to decode the results of SoundexWord back to
  a normal Soundex code. }

function SoundexWord(const AText: string): Word;
function DecodeSoundexWord(AValue: Word): string;

{ SoundexSimilar and SoundexCompare are simple comparison functions that use
  the Soundex encoding function. }

function SoundexSimilar(const AText, AOther: string;
  ALength: TSoundexLength = 4): Boolean;
function SoundexCompare(const AText, AOther: string;
  ALength: TSoundexLength = 4): Integer;

{ Default entry point for AnsiResemblesText }

function SoundexProc(const AText, AOther: string): Boolean;

type
  TCompareTextProc = function(const AText, AOther: string): Boolean;

{ If the default behavior of AnsiResemblesText (using Soundex) is not suitable
  for your situation, you can redirect it to a function of your own choosing }

var
  ResemblesProc: TCompareTextProc = SoundexProc;
  AnsiResemblesProc: TCompareTextProc = SoundexProc;

implementation

{$IFDEF MSWINDOWS}
uses
  Windows, Character;
{$ENDIF}
{$IFDEF LINUX}
uses
  Libc;
{$ENDIF}

function ResemblesText(const AText, AOther: string): Boolean;
begin
  Result := False;
  if Assigned(ResemblesProc) then
    Result := ResemblesProc(AText, AOther);
end;

function AnsiResemblesText(const AText, AOther: string): Boolean;
begin
  Result := False;
  if Assigned(AnsiResemblesProc) then
    Result := AnsiResemblesProc(AText, AOther);
end;

function ContainsText(const AText, ASubText: string): Boolean;
begin
  Result := AnsiContainsText(AText, ASubText);
end;

function AnsiContainsText(const AText, ASubText: string): Boolean;
begin
  Result := AnsiPos(AnsiUppercase(ASubText), AnsiUppercase(AText)) > 0;
end;

function StartsText(const ASubText, AText: string): Boolean;
begin
  Result := AnsiStartsText(ASubText, AText);
end;

function AnsiStartsText(const ASubText, AText: string): Boolean;
var
{$IFDEF MSWINDOWS}
  P: PChar;
{$ENDIF}
  L, L2: Integer;
begin
{$IFDEF MSWINDOWS}
  P := PChar(AText);
{$ENDIF}
  L := Length(ASubText);
  L2 := Length(AText);
  if L > L2 then
    Result := False
  else
{$IFDEF MSWINDOWS}
    Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE,
      P, L, PChar(ASubText), L) = 2;
{$ENDIF}
{$IFDEF LINUX}
    Result := WideSameText(ASubText, Copy(AText, 1, L));
{$ENDIF}
end;

function EndsText(const ASubText, AText: string): Boolean;
begin
  Result := AnsiEndsText(ASubText, AText);
end;

function AnsiEndsText(const ASubText, AText: string): Boolean;
var
  SubTextLocation: Integer;
begin
  SubTextLocation := Length(AText) - Length(ASubText) + 1;
  if (SubTextLocation > 0) and (ASubText <> '') and
     (ByteType(AText, SubTextLocation) <> mbTrailByte) then
    Result := AnsiStrIComp(PChar(ASubText), PChar(@AText[SubTextLocation])) = 0
  else
    Result := False;
end;

function ReplaceStr(const AText, AFromText, AToText: string): string;
begin
  Result := AnsiReplaceStr(AText, AFromText, AToText);
end;

function AnsiReplaceStr(const AText, AFromText, AToText: string): string;
begin
  Result := StringReplace(AText, AFromText, AToText, [rfReplaceAll]);
end;

function ReplaceText(const AText, AFromText, AToText: string): string;
begin
  Result := AnsiReplaceText(AText, AFromText, AToText);
end;

function AnsiReplaceText(const AText, AFromText, AToText: string): string;
begin
  Result := StringReplace(AText, AFromText, AToText, [rfReplaceAll, rfIgnoreCase]);
end;

function MatchText(const AText: string; const AValues: array of string): Boolean;
begin
  Result := AnsiMatchText(AText, AValues);
end;

function AnsiMatchText(const AText: string; const AValues: array of string): Boolean;
begin
  Result := AnsiIndexText(AText, AValues) <> -1;
end;

function IndexText(const AText: string; const AValues: array of string): Integer;
begin
  Result := AnsiIndexText(AText, AValues);
end;

function AnsiIndexText(const AText: string; const AValues: array of string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(AValues) to High(AValues) do
    if AnsiSameText(AText, AValues[I]) then
    begin
      Result := I;
      Break;
    end;
end;

function ContainsStr(const AText, ASubText: string): Boolean;
begin
  Result := AnsiContainsStr(AText, ASubText);
end;

function AnsiContainsStr(const AText, ASubText: string): Boolean;
begin
  Result := AnsiPos(ASubText, AText) > 0;
end;

function StartsStr(const ASubText, AText: string): Boolean;
begin
  Result := AnsiStartsStr(ASubText, AText);
end;

function AnsiStartsStr(const ASubText, AText: string): Boolean;
begin
  Result := AnsiSameStr(ASubText, Copy(AText, 1, Length(ASubText)));
end;

function EndsStr(const ASubText, AText: string): Boolean;
begin
  Result := AnsiEndsStr(ASubText, AText);
end;

function AnsiEndsStr(const ASubText, AText: string): Boolean;
var
  SubTextLocation: Integer;
begin
  SubTextLocation := Length(AText) - Length(ASubText) + 1;
  if (SubTextLocation > 0) and (ASubText <> '') and
     (ByteType(AText, SubTextLocation) <> mbTrailByte) then
    Result := AnsiStrComp(PChar(ASubText), PChar(@AText[SubTextLocation])) = 0
  else
    Result := False;
end;

function MatchStr(const AText: string; const AValues: array of string): Boolean;
begin
  Result := AnsiMatchStr(AText, AValues);
end;

function AnsiMatchStr(const AText: string; const AValues: array of string): Boolean;
begin
  Result := AnsiIndexStr(AText, AValues) <> -1;
end;

function IndexStr(const AText: string; const AValues: array of string): Integer;
begin
  Result := AnsiIndexStr(AText, AValues);
end;

function AnsiIndexStr(const AText: string; const AValues: array of string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(AValues) to High(AValues) do
    if AnsiSameStr(AText, AValues[I]) then
    begin
      Result := I;
      Break;
    end;
end;

function DupeString(const AText: string; ACount: Integer): string;
var
  P: PChar;
  C: Integer;
begin
  C := Length(AText);
  SetLength(Result, C * ACount);
  P := Pointer(Result);
  if P = nil then Exit;
  while ACount > 0 do
  begin
    Move(Pointer(AText)^, P^, C * SizeOf(Char));
    Inc(P, C);
    Dec(ACount);
  end;
end;

function ReverseString(const AText: string): string;
var
  I: Integer;
  P: PChar;
begin
  SetLength(Result, Length(AText));
  P := PChar(Result);
  for I := Length(AText) downto 1 do
  begin
    P^ := AText[I];
    Inc(P);
  end;
end;

function AnsiReverseString(const AText: string): string;
begin
  Result := ReverseString(AText);                                
end;

function StuffString(const AText: string; AStart, ALength: Cardinal;
  const ASubText: string): string;
begin
  Result := Copy(AText, 1, AStart - 1) +
            ASubText +
            Copy(AText, AStart + ALength, MaxInt);
end;

function RandomFrom(const AValues: array of string): string;
begin
  Result := AValues[Random(High(AValues) + 1)];
end;

function IfThen(AValue: Boolean; const ATrue: string;
  AFalse: string = ''): string;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function LeftStr(const AText: AnsiString; const ACount: Integer): AnsiString; overload;
begin
  Result := Copy(AText, 1, ACount);
end;

function LeftStr(const AText: WideString; const ACount: Integer): WideString; overload;
begin
  Result := Copy(AText, 1, ACount);
end;

function RightStr(const AText: AnsiString; const ACount: Integer): AnsiString; overload;
begin
  Result := Copy(AText, Length(AText) + 1 - ACount, ACount);
end;

function RightStr(const AText: WideString; const ACount: Integer): WideString; overload;
begin
  Result := Copy(AText, Length(AText) + 1 - ACount, ACount);
end;

function MidStr(const AText: AnsiString; const AStart, ACount: Integer): AnsiString; overload;
begin
  Result := Copy(AText, AStart, ACount);
end;

function MidStr(const AText: WideString; const AStart, ACount: Integer): WideString; overload;
begin
  Result := Copy(AText, AStart, ACount);
end;

function LeftBStr(const AText: AnsiString; const AByteCount: Integer): AnsiString;
begin
  Result := Copy(AText, 1, AByteCount);
end;

function RightBStr(const AText: AnsiString; const AByteCount: Integer): AnsiString;
begin
  Result := Copy(AText, Length(AText) + 1 - AByteCount, AByteCount);
end;

function MidBStr(const AText: AnsiString; const AByteStart, AByteCount: Integer): AnsiString;
begin
  Result := Copy(AText, AByteStart, AByteCount);
end;

function AnsiLeftStr(const AText: string; const ACount: Integer): string;
begin
  Result := LeftStr(AText, ACount);                                
end;

function AnsiRightStr(const AText: string; const ACount: Integer): string;
begin
  Result := RightStr(AText, ACount);                                
end;

function AnsiMidStr(const AText: string; const AStart, ACount: Integer): string;
begin
  Result := MidStr(AText, AStart, ACount);                                
end;

function SearchBuf(Buf: PAnsiChar; BufLen: Integer; SelStart, SelLength: Integer;
  SearchString: AnsiString; Options: TStringSearchOptions): PAnsiChar;
var
  SearchCount, I: Integer;
  C: AnsiChar;
  Direction: Shortint;
  ShadowMap: array[0..256] of AnsiChar;
  CharMap: array [AnsiChar] of AnsiChar absolute ShadowMap;

  function FindNextWordStart(var BufPtr: PAnsiChar): Boolean;
  begin                   { (True XOR N) is equivalent to (not N) }
                          { (False XOR N) is equivalent to (N)    }
     { When Direction is forward (1), skip non delimiters, then skip delimiters. }
     { When Direction is backward (-1), skip delims, then skip non delims }
    while (SearchCount > 0) and
          ((Direction = 1) xor (BufPtr^ in WordDelimiters)) do
    begin
      Inc(BufPtr, Direction);
      Dec(SearchCount);
    end;
    while (SearchCount > 0) and
          ((Direction = -1) xor (BufPtr^ in WordDelimiters)) do
    begin
      Inc(BufPtr, Direction);
      Dec(SearchCount);
    end;
    Result := SearchCount > 0;
    if Direction = -1 then
    begin   { back up one char, to leave ptr on first non delim }
      Dec(BufPtr, Direction);
      Inc(SearchCount);
    end;
  end;

begin
  Result := nil;
  if BufLen <= 0 then Exit;
  if soDown in Options then
  begin
    Direction := 1;
    Inc(SelStart, SelLength);  { start search past end of selection }
    SearchCount := BufLen - SelStart - Length(SearchString) + 1;
    if SearchCount < 0 then Exit;
    if Longint(SelStart) + SearchCount > BufLen then Exit;
  end
  else
  begin
    Direction := -1;
    Dec(SelStart, Length(SearchString));
    SearchCount := SelStart + 1;
  end;
  if (SelStart < 0) or (SelStart > BufLen) then Exit;
  Result := @Buf[SelStart];

  { Using a Char map array is faster than calling AnsiUpper on every character }
  for C := Low(CharMap) to High(CharMap) do
    CharMap[(C)] := (C);
  { Since CharMap is overlayed onto the ShadowMap and ShadowMap is 1 byte longer,
    we can use that extra byte as a guard NULL }
  ShadowMap[256] := #0;

  if not (soMatchCase in Options) then
  begin
{$IFDEF MSWINDOWS}
    CharUpperBuffA(PAnsiChar(@CharMap), Length(CharMap));
    CharUpperBuffA(@SearchString[1], Length(SearchString));
{$ENDIF}
{$IFDEF LINUX}
    AnsiStrUpper(@CharMap[#1]);
    SearchString := AnsiUpperCase(SearchString);
{$ENDIF}
  end;

  while SearchCount > 0 do
  begin
    if (soWholeWord in Options) and (Result <> @Buf[SelStart]) then
      if not FindNextWordStart(Result) then Break;
    I := 0;
    while (CharMap[(Result[I])] = (SearchString[I+1])) do
    begin
      Inc(I);
      if I >= Length(SearchString) then
      begin
        if (not (soWholeWord in Options)) or
           (SearchCount = 0) or
           ((Result[I]) in WordDelimiters) then
          Exit;
        Break;
      end;
    end;
    Inc(Result, Direction);
    Dec(SearchCount);
  end;
  Result := nil;
end;

{$IFDEF UNICODE}
function SearchBuf(Buf: PWideChar; BufLen: Integer; SelStart, SelLength: Integer;
  SearchString: UnicodeString; Options: TStringSearchOptions): PWideChar;
var
  SearchCount, I: Integer;
  Direction: Shortint;

  function FindNextWordStart(var BufPtr: PWideChar): Boolean;
  begin                   { (True XOR N) is equivalent to (not N) }
                          { (False XOR N) is equivalent to (N)    }
     { When Direction is forward (1), skip non delimiters, then skip delimiters. }
     { When Direction is backward (-1), skip delims, then skip non delims }
    while (SearchCount > 0) and
          ((Direction = 1) xor (not TCharacter.IsLetterOrDigit(BufPtr^))) do
    begin
      Inc(BufPtr, Direction);
      Dec(SearchCount);
    end;
    while (SearchCount > 0) and
          ((Direction = -1) xor (not TCharacter.IsLetterOrDigit(BufPtr^))) do
    begin
      Inc(BufPtr, Direction);
      Dec(SearchCount);
    end;
    Result := SearchCount > 0;
    if Direction = -1 then
    begin   { back up one WideChar, to leave ptr on first non delim }
      Dec(BufPtr, Direction);
      Inc(SearchCount);
    end;
  end;

  function NextChar(S: PWideChar): WideChar;
  begin
    if not (soMatchCase in Options) then
      Result := WideChar(CharUpperW(PWideChar(S[I])))
    else
      Result := S[I];
  end;

begin
  Result := nil;
  if BufLen <= 0 then Exit;
  if soDown in Options then
  begin
    Direction := 1;
    Inc(SelStart, SelLength);  { start search past end of selection }
    SearchCount := BufLen - SelStart - Length(SearchString) + 1;
    if SearchCount < 0 then Exit;
    if Longint(SelStart) + SearchCount > BufLen then Exit;
  end
  else
  begin
    Direction := -1;
    Dec(SelStart, Length(SearchString));
    SearchCount := SelStart + 1;
  end;
  if (SelStart < 0) or (SelStart > BufLen) then Exit;
  Result := @Buf[SelStart];

  if not (soMatchCase in Options) then
    CharUpperBuffW(@SearchString[1], Length(SearchString));

  while SearchCount > 0 do
  begin
    if (soWholeWord in Options) and (Result <> @Buf[SelStart]) then
      if not FindNextWordStart(Result) then Break;
    I := 0;
    while NextChar(Result) = SearchString[I+1] do
    begin
      Inc(I);
      if I >= Length(SearchString) then
      begin
        if (not (soWholeWord in Options)) or
           (SearchCount = 0) or
           (not TCharacter.IsLetterOrDigit(Result[I])) then
          Exit;
        Break;
      end;
    end;
    Inc(Result, Direction);
    Dec(SearchCount);
  end;
  Result := nil;
end;
{$ENDIF}

(* ***** BEGIN LICENSE BLOCK *****
 *
 * The function PosEx is licensed under the CodeGear license terms.
 *
 * The initial developer of the original code is Fastcode
 *
 * Portions created by the initial developer are Copyright (C) 2002-2004
 * the initial developer. All Rights Reserved.
 *
 * Contributor(s): Aleksandr Sharahov
 *
 * ***** END LICENSE BLOCK ***** *)
function PosEx(const SubStr, S: string; Offset: Integer = 1): Integer;
{$IFNDEF UNICODE}
asm
       test  eax, eax
       jz    @Nil
       test  edx, edx
       jz    @Nil
       dec   ecx
       jl    @Nil

       push  esi
       push  ebx
       push  0
       push  0
       mov   esi,ecx
       cmp   word ptr [eax-10],1
       je    @substrisansi

       push  edx
       mov   edx, eax
       lea   eax, [esp+4]
       call  System.@LStrFromUStr
       pop   edx
       mov   eax, [esp]

@substrisansi:
       cmp   word ptr [edx-10],1
       je    @strisansi

       push  eax
       lea   eax,[esp+8]
       call  System.@LStrFromUStr
       pop   eax
       mov   edx, [esp+4]

@strisansi:
       mov   esi, [edx-4]  //Length(Str)
       mov   ebx, [eax-4]  //Length(Substr)
       sub   esi, ecx      //effective length of Str
       add   edx, ecx      //addr of the first char at starting position
       cmp   esi, ebx
       jl    @Past         //jump if EffectiveLength(Str)<Length(Substr)
       test  ebx, ebx
       jle   @Past         //jump if Length(Substr)<=0

       add   esp, -12
       add   ebx, -1       //Length(Substr)-1
       add   esi, edx      //addr of the terminator
       add   edx, ebx      //addr of the last char at starting position
       mov   [esp+8], esi  //save addr of the terminator
       add   eax, ebx      //addr of the last char of Substr
       sub   ecx, edx      //-@Str[Length(Substr)]
       neg   ebx           //-(Length(Substr)-1)
       mov   [esp+4], ecx  //save -@Str[Length(Substr)]
       mov   [esp], ebx    //save -(Length(Substr)-1)
       movzx ecx, byte ptr [eax] //the last char of Substr

@Loop:
       cmp   cl, [edx]
       jz    @Test0
@AfterTest0:
       cmp   cl, [edx+1]
       jz    @TestT
@AfterTestT:
       add   edx, 4
       cmp   edx, [esp+8]
       jb   @Continue
@EndLoop:
       add   edx, -2
       cmp   edx, [esp+8]
       jb    @Loop
@Exit:
       add   esp, 12
@Past:
       mov   eax, [esp]
       or    eax, [esp+4]
       jz    @PastNoClear
       mov   eax, esp
       mov   edx, 2
       call  System.@LStrArrayClr
@PastNoClear:
       add   esp, 8
       pop   ebx
       pop   esi
@Nil:
       xor   eax, eax
       ret
@Continue:
       cmp   cl, [edx-2]
       jz    @Test2
       cmp   cl, [edx-1]
       jnz   @Loop
@Test1:
       add   edx,  1
@Test2:
       add   edx, -2
@Test0:
       add   edx, -1
@TestT:
       mov   esi, [esp]
       test  esi, esi
       jz    @Found
@String:
       movzx ebx, word ptr [esi+eax]
       cmp   bx, word ptr [esi+edx+1]
       jnz   @AfterTestT
       cmp   esi, -2
       jge   @Found
       movzx ebx, word ptr [esi+eax+2]
       cmp   bx, word ptr [esi+edx+3]
       jnz   @AfterTestT
       add   esi, 4
       jl    @String
@Found:
       mov   eax, [esp+4]
       add   edx, 2

       cmp   edx, [esp+8]
       ja    @Exit

       add   esp, 12
       mov   ecx, [esp]
       or    ecx, [esp+4]
       jz    @NoClear

       mov   ebx, eax
       mov   esi, edx
       mov   eax, esp
       mov   edx, 2
       call  System.@LStrArrayClr
       mov   eax, ebx
       mov   edx, esi

@NoClear:
       add   eax, edx
       add   esp, 8
       pop   ebx
       pop   esi
end;
{$ELSE}
asm
       test  eax, eax
       jz    @Nil
       test  edx, edx
       jz    @Nil
       dec   ecx
       jl    @Nil

       push  esi
       push  ebx
       push  0
       push  0
       mov   esi,ecx
       cmp   word ptr [eax-10],2
       je    @substrisunicode

       push  edx
       mov   edx, eax
       lea   eax, [esp+4]
       call  System.@UStrFromLStr
       pop   edx
       mov   eax, [esp]

@substrisunicode:
       cmp   word ptr [edx-10],2
       je    @strisunicode

       push  eax
       lea   eax,[esp+8]
       call  System.@UStrFromLStr
       pop   eax
       mov   edx, [esp+4]

@strisunicode:
       mov   ecx,esi
       mov   esi, [edx-4]  //Length(Str)
       mov   ebx, [eax-4]  //Length(Substr)
       sub   esi, ecx      //effective length of Str
       shl   ecx, 1        //double count of offset due to being wide char
       add   edx, ecx      //addr of the first char at starting position
       cmp   esi, ebx
       jl    @Past         //jump if EffectiveLength(Str)<Length(Substr)
       test  ebx, ebx
       jle   @Past         //jump if Length(Substr)<=0

       add   esp, -12
       add   ebx, -1       //Length(Substr)-1
       shl   esi,1         //double it due to being wide char
       add   esi, edx      //addr of the terminator
       shl   ebx,1         //double it due to being wide char
       add   edx, ebx      //addr of the last char at starting position
       mov   [esp+8], esi  //save addr of the terminator
       add   eax, ebx      //addr of the last char of Substr
       sub   ecx, edx      //-@Str[Length(Substr)]
       neg   ebx           //-(Length(Substr)-1)
       mov   [esp+4], ecx  //save -@Str[Length(Substr)]
       mov   [esp], ebx    //save -(Length(Substr)-1)
       movzx ecx, word ptr [eax] //the last char of Substr

@Loop:
       cmp   cx, [edx]
       jz    @Test0
@AfterTest0:
       cmp   cx, [edx+2]
       jz    @TestT
@AfterTestT:
       add   edx, 8
       cmp   edx, [esp+8]
       jb   @Continue
@EndLoop:
       add   edx, -4
       cmp   edx, [esp+8]
       jb    @Loop
@Exit:
       add   esp, 12
@Past:
       mov   eax, [esp]
       or    eax, [esp+4]
       jz    @PastNoClear
       mov   eax, esp
       mov   edx, 2
       call  System.@UStrArrayClr
@PastNoClear:
       add   esp, 8
       pop   ebx
       pop   esi
@Nil:
       xor   eax, eax
       ret
@Continue:
       cmp   cx, [edx-4]
       jz    @Test2
       cmp   cx, [edx-2]
       jnz   @Loop
@Test1:
       add   edx,  2
@Test2:
       add   edx, -4
@Test0:
       add   edx, -2
@TestT:
       mov   esi, [esp]
       test  esi, esi
       jz    @Found
@String:
       mov   ebx, [esi+eax]
       cmp   ebx, [esi+edx+2]
       jnz   @AfterTestT
       cmp   esi, -4
       jge   @Found
       mov   ebx, [esi+eax+4]
       cmp   ebx, [esi+edx+6]
       jnz   @AfterTestT
       add   esi, 8
       jl    @String
@Found:
       mov   eax, [esp+4]
       add   edx, 4

       cmp   edx, [esp+8]
       ja    @Exit

       add   esp, 12
       mov   ecx, [esp]
       or    ecx, [esp+4]
       jz    @NoClear

       mov   ebx, eax
       mov   esi, edx
       mov   eax, esp
       mov   edx, 2
       call  System.@UStrArrayClr
       mov   eax, ebx
       mov   edx, esi

@NoClear:
       add   eax, edx
       shr   eax, 1  // divide by 2 to make an index 
       add   esp, 8
       pop   ebx
       pop   esi
end;
{$ENDIF}

{ This function is loosely based on SoundBts which was written by John Midwinter }
function Soundex(const AText: string; ALength: TSoundexLength): string;
const

  // This table gives the Soundex score for all characters upper- and lower-
  // case hence no need to convert.  This is faster than doing an UpCase on the
  // whole input string.  The 5 non characters in middle are just given 0.
  CSoundexTable: array[65..122] of Integer =
  // A  B  C  D  E  F  G  H   I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W   X  Y  Z
    (0, 1, 2, 3, 0, 1, 2, -1, 0, 2, 2, 4, 5, 5, 0, 1, 2, 6, 2, 3, 0, 1, -1, 2, 0, 2,
  // [  /  ]  ^  _  '
     0, 0, 0, 0, 0, 0,
  // a  b  c  d  e  f  g  h   i  j  k  l  m  n  o  p  q  r  s  t  u  v  w   x  y  z
     0, 1, 2, 3, 0, 1, 2, -1, 0, 2, 2, 4, 5, 5, 0, 1, 2, 6, 2, 3, 0, 1, -1, 2, 0, 2);

  function Score(AChar: Integer): Integer;
  begin
    Result := 0;
    if (AChar >= Low(CSoundexTable)) and (AChar <= High(CSoundexTable)) then
      Result := CSoundexTable[AChar];
  end;

var
  I, LScore, LPrevScore: Integer;
  Str: PChar;
begin
  Result := '';
  if AText <> '' then
  begin
    Str := PChar(@AText[2]);
    Result := Upcase(AText[1]);
    LPrevScore := Score(Integer(AText[1]));
    for I := 2 to Length(AText) do
    begin
      LScore := Score(Integer(Str^));
      if (LScore > 0) and (LScore <> LPrevScore) then
      begin
        Result := Result + IntToStr(LScore);
        if Length(Result) = ALength then
          Break;
      end;
      if LScore <> -1 then
        LPrevScore := LScore;
      Inc(Str);
    end;
    if Length(Result) < ALength then
      Result := Copy(Result + DupeString('0', ALength), 1, ALength);
  end;
end;

function SoundexInt(const AText: string; ALength: TSoundexIntLength): Integer;
var
  LResult: string;
  I: Integer;
begin
  Result := 0;
  if AText <> '' then
  begin
    LResult := Soundex(AText, ALength);
    Result := Ord(LResult[1]) - Ord('A');
    if ALength > 1 then
    begin
      Result := Result * 26 + StrToInt(LResult[2]);
      for I := 3 to ALength do
        Result := Result * 7 + StrToInt(LResult[I]);
    end;
    Result := Result * 9 + ALength;
  end;
end;

function DecodeSoundexInt(AValue: Integer): string;
var
  I, LLength: Integer;
begin
  Result := '';
  LLength := AValue mod 9;
  AValue := AValue div 9;
  for I := LLength downto 3 do
  begin
    Result := IntToStr(AValue mod 7) + Result;
    AValue := AValue div 7;
  end;
  if LLength > 2 then
    Result := IntToStr(AValue mod 26) + Result;
  AValue := AValue div 26;
  Result := Chr(AValue + Ord('A')) + Result;
end;

function SoundexWord(const AText: string): Word;
var
  LResult: string;
begin
  LResult := Soundex(AText, 4);
  Result := Ord(LResult[1]) - Ord('A');
  Result := Result * 26 + StrToInt(LResult[2]);
  Result := Result * 7 + StrToInt(LResult[3]);
  Result := Result * 7 + StrToInt(LResult[4]);
end;

function DecodeSoundexWord(AValue: Word): string;
begin
  Result := IntToStr(AValue mod 7) + Result;
  AValue := AValue div 7;
  Result := IntToStr(AValue mod 7) + Result;
  AValue := AValue div 7;
  Result := IntToStr(AValue mod 26) + Result;
  AValue := AValue div 26;
  Result := Chr(AValue + Ord('A')) + Result;
end;

function SoundexSimilar(const AText, AOther: string; ALength: TSoundexLength): Boolean;
begin
  Result := Soundex(AText, ALength) = Soundex(AOther, ALength);
end;

function SoundexCompare(const AText, AOther: string; ALength: TSoundexLength): Integer;
begin
  Result := AnsiCompareStr(Soundex(AText, ALength), Soundex(AOther, ALength));
end;

function SoundexProc(const AText, AOther: string): Boolean;
begin
  Result := SoundexSimilar(AText, AOther);
end;

end.
