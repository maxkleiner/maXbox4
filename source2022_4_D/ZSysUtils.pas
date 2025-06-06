{*********************************************************}
{                                                         }
{                 Zeos Database Objects                   }
{           System Utility Classes and Functions          }
{                                                         }
{          Originally written by Sergey Seroukhov         }
{                                                         }
{*********************************************************}

{@********************************************************}
{    Copyright (c) 1999-2012 Zeos Development Group       }
{                                                         }
{ License Agreement:                                      }
{                                                         }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the ZEOS Libraries and packages are  }
{ distributed under the Library GNU General Public        }
{ License (see the file COPYING / COPYING.ZEOS)           }
{ with the following  modification:                       }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library. If you modify this       }
{ library, you may extend this exception to your version  }
{ of the library, but you are not obligated to do so.     }
{ If you do not wish to do so, delete this exception      }
{ statement from your version.                            }
{                                                         }
{                                                         }
{ The project web site is located on:                     }
{   http://zeos.firmos.at  (FORUM)                        }
{   http://sourceforge.net/p/zeoslib/tickets/ (BUGTRACKER)}
{   svn://svn.code.sf.net/p/zeoslib/code-0/trunk (SVN)    }
{                                                         }
{   http://www.sourceforge.net/projects/zeoslib.          }
{                                                         }
{                                                         }
{                                 Zeos Development Group. }
{********************************************************@}

unit ZSysUtils;

interface

{$I ZCore.inc}

uses
  Variants, ZMessages, ZCompatibility, Classes, SysUtils, Types;

type
  {** Modified comaprison function. }
  TZListSortCompare = function (Item1, Item2: Pointer): Integer of object;

  {** Modified list of pointers. }
  TZSortedList = class (TList)
  protected
    procedure QuickSort(SortList: PPointerList; L, R: Integer;
      SCompare: TZListSortCompare);
  public
    procedure Sort(Compare: TZListSortCompare);
  end;

{**
  Determines a position of a first delimiter.
  @param Delimiters a string with possible delimiters.
  @param Str a string to be checked.
  @return a position of the first found delimiter or 0 if no delimiters was found.
}
function FirstDelimiter(const Delimiters, Str: string): Integer;

{**
  Determines a position of a LAST delimiter.
  @param Delimiters a string with possible delimiters.
  @param Str a string to be checked.
  @return a position of the last found delimiter or 0 if no delimiters was found.
}
function LastDelimiter(const Delimiters, Str: string): Integer;

{**
  Compares two PWideChars without stopping at #0 (Unicode Version)
  @param P1 first PWideChars
  @param P2 seconds PWideChars
  @return <code>True</code> if the memory at P1 and P2 are equal
}
function MemLCompUnicode(P1, P2: PWideChar; Len: Integer): Boolean;

{**
  Compares two PAnsiChars without stopping at #0
  @param P1 first PAnsiChar
  @param P2 seconds PAnsiChar
  @return <code>True</code> if the memory at P1 and P2 are equal
}
function MemLCompAnsi(P1, P2: PAnsiChar; Len: Integer): Boolean;

{**
  Checks is the string starts with substring.
  @param Str a string to be checked.
  @param SubStr a string to test at the start of the Str.
  @return <code>True</code> if Str started with SubStr;
}
function StartsWith(const Str, SubStr: ZWideString): Boolean; overload;
function StartsWith(const Str, SubStr: RawByteString): Boolean; overload;
{**
  Checks is the string ends with substring.
  @param Str a string to be checked.
  @param SubStr a string to test at the end of the Str.
  @return <code>True</code> if Str ended with SubStr;
}
function EndsWith(const Str, SubStr: ZWideString): Boolean; overload;
function EndsWith(const Str, SubStr: RawByteString): Boolean; overload;

{**
  Converts SQL string into float value.
  @param Str an SQL string with comma delimiter.
  @param Def a default value if the string can not be converted.
  @return a converted value or Def if conversion was failt.
}
{$IFDEF WITH_RAWBYTESTRING}
function SQLStrToFloatDef(Str: RawByteString; Def: Extended): Extended; overload;
{$ENDIF}
function SQLStrToFloatDef(Str: String; Def: Extended): Extended; overload;

{**
  Converts SQL string into float value.
  @param Str an SQL string with comma delimiter.
  @return a converted value or Def if conversion was failt.
}
function SQLStrToFloat(const Str: AnsiString): Extended;

{**
  Converts a character buffer into pascal string.
  @param Buffer a character buffer pointer.
  @param Length a buffer length.
  @return a string retrived from the buffer.
}
function BufferToStr(Buffer: PWideChar; Length: LongInt): string; overload;
function BufferToStr(Buffer: PAnsiChar; Length: LongInt): string; overload;
function BufferToBytes(Buffer: Pointer; Length: LongInt): TByteDynArray;

{**
  Converts a string into boolean value.
  @param Str a string value.
  @return <code>True</code> is Str = 'Y'/'YES'/'T'/'TRUE'/<>0
}
function StrToBoolEx(Str: string): Boolean;

{**
  Converts a boolean into string value.
  @param Bool a boolean value.
  @return <code>"True"</code> or <code>"False"</code>
}
function BoolToStrEx(Bool: Boolean): String;

{**
  Checks if the specified string can represent an IP address.
  @param Str a string value.
  @return <code>True</code> if the string can represent an IP address
    or <code>False</code> otherwise.
}
function IsIpAddr(const Str: string): Boolean;

{**
  Splits string using the multiple chars.
  @param Str the source string
  @param Delimiters the delimiters string
  @return the result list where plased delimited string
}
function SplitString(const Str, Delimiters: string): TStrings;

{**
  Puts to list a splitted string using the multiple chars which replaces
  the previous list content.
  @param List a list with strings.
  @param Str the source string
  @param Delimiters the delimiters string
}
procedure PutSplitString(List: TStrings; const Str, Delimiters: string);

{**
  Appends to list a splitted string using the multiple chars.
  @param List a list with strings.
  @param Str the source string
  @param Delimiters the delimiters string
}
procedure AppendSplitString(List: TStrings; const Str, Delimiters: string);

{**
  Composes a string from the specified strings list delimited with
  a special character.
  @param List a list of strings.
  @param Delimiter a delimiter string.
  @return a composed string from the list.
}
function ComposeString(List: TStrings; const Delimiter: string): string;

{**
  Converts a float value into SQL string with '.' delimiter.
  @param Value a float value to be converted.
  @return a converted string value.
}
function FloatToSQLStr(Value: Extended): string;

{**
  Puts to list a splitted string using the delimiter string which replaces
  the previous list content.
  @param List a list with strings.
  @param Str the source string
  @param Delimiters the delimiter string
}
procedure PutSplitStringEx(List: TStrings; const Str, Delimiter: string);

{**
  Splits string using the delimiter string.
  @param Str the source string
  @param Delimiters the delimiter string
  @return the result list where plased delimited string
}
function SplitStringEx(const Str, Delimiter: string): TStrings;

{**
  Appends to list a splitted string using the delimeter string.
  @param List a list with strings.
  @param Str the source string
  @param Delimiters the delimiters string
}
procedure AppendSplitStringEx(List: TStrings; const Str, Delimiter: string);

{**
  Converts bytes into a AnsiString representation.
  @param Value an array of bytes to be converted.
  @return a converted AnsiString.
}
function BytesToStr(const Value: TByteDynArray): AnsiString;

{**
  Converts AnsiString into an array of bytes.
  @param Value a AnsiString to be converted.
  @return a converted array of bytes.
}
function StrToBytes(const Value: AnsiString): TByteDynArray; overload;

{$IFDEF WITH_RAWBYTESTRING}
{**
  Converts a UTF8String into an array of bytes.
  @param Value a UTF8String to be converted.
  @return a converted array of bytes.
}
function StrToBytes(const Value: UTF8String): TByteDynArray; overload;
{**
  Converts a UTF8String into an array of bytes.
  @param Value a UTF8String to be converted.
  @return a converted array of bytes.
}
function StrToBytes(const Value: RawByteString): TByteDynArray; overload;
{**
  Converts a RawByteString into an array of bytes.
  @param Value a RawByteString to be converted.
  @return a converted array of bytes.
}
{$ENDIF}
function StrToBytes(const Value: WideString): TByteDynArray; overload;
{**
  Converts a String into an array of bytes.
  @param Value a String to be converted.
  @return a converted array of bytes.
}
{$IFDEF PWIDECHAR_IS_PUNICODECHAR}
function StrToBytes(const Value: UnicodeString): TByteDynArray; overload;
{$ENDIF}
{**
  Converts bytes into a variant representation.
  @param Value an array of bytes to be converted.
  @return a converted variant.
}
function BytesToVar(const Value: TByteDynArray): Variant;

{**
  Converts variant into an array of bytes.
  @param Value a varaint to be converted.
  @return a converted array of bytes.
}
function VarToBytes(const Value: Variant): TByteDynArray;

{**
  Converts Ansi SQL Date/Time to TDateTime
  @param Value a date and time string.
  @return a decoded TDateTime value.
}
function AnsiSQLDateToDateTime(const Value: string): TDateTime;

{**
  Converts Timestamp String to TDateTime
  @param Value a timestamp string.
  @return a decoded TDateTime value.
}
function TimestampStrToDateTime(const Value: string): TDateTime;

{**
  Converts TDateTime to Ansi SQL Date/Time
  @param Value an encoded TDateTime value.
  @return a  date and time string.
}
function DateTimeToAnsiSQLDate(Value: TDateTime; WithMMSec: Boolean = False): string;

{**
  Converts an string into escape PostgreSQL format.
  @param Value a regular string.
  @return a string in PostgreSQL escape format.
}
function EncodeCString(const Value: string): string;

{**
  Converts an string from escape PostgreSQL format.
  @param Value a string in PostgreSQL escape format.
  @return a regular string.
}
function DecodeCString(const Value: string): string;

{**
  Replace chars in the string
  @param Source a char to search.
  @param Target a char to replace.
  @param Str a source string.
  @return a string with replaced chars.
}
function ReplaceChar(const Source, Target: Char; const Str: string): string;

{**
   Copy buffer to the pascal string
   @param Buffer a buffer with data
   @param Length a buffer length
   @return a buffer content
}
function MemPas(Buffer: PChar; Length: LongInt): string;

{**
  Decodes a Full Version Value encoded with the format:
   (major_version * 1,000,000) + (minor_version * 1,000) + sub_version
  into separated major, minor and subversion values
  @param FullVersion an integer containing the Full Version to decode.
  @param MajorVersion an integer containing the Major Version decoded.
  @param MinorVersion an integer containing the Minor Version decoded.
  @param SubVersion an integer contaning the Sub Version (revision) decoded.
}
procedure DecodeSQLVersioning(const FullVersion: Integer;
 out MajorVersion: Integer; out MinorVersion: Integer;
 out SubVersion: Integer);

{**
  Encodes major, minor and subversion (revision) values in this format:
   (major_version * 1,000,000) + (minor_version * 1,000) + sub_version
  For example, 4.1.12 is returned as 4001012.
  @param MajorVersion an integer containing the Major Version.
  @param MinorVersion an integer containing the Minor Version.
  @param SubVersion an integer containing the Sub Version (revision).
  @return an integer containing the full version.
}
function EncodeSQLVersioning(const MajorVersion: Integer;
 const MinorVersion: Integer; const SubVersion: Integer): Integer;

{**
  Formats a Zeos SQL Version format to X.Y.Z where:
   X = major_version
   Y = minor_version
   Z = sub version
  @param SQLVersion an integer
  @return Formated Zeos SQL Version Value.
}
function FormatSQLVersion( const SQLVersion: Integer ): String;

{**
  Arranges thousand and decimal separator to a System-defaults
  @param the value which has to be converted and arranged
  @return a valid floating value
}
function ZStrToFloat(Value: PAnsiChar): Extended; overload;

{**
  Arranges thousand and decimal separator to a System-defaults
  @param the value which has to be converted and arranged
  @return a valid floating value
}
function ZStrToFloat(Value: AnsiString): Extended; overload;

procedure ZSetString(const Src: PAnsiChar; var Dest: AnsiString); overload;
procedure ZSetString(const Src: PAnsiChar; const Len: Cardinal; var Dest: AnsiString); overload;
procedure ZSetString(const Src: PAnsiChar; var Dest: UTF8String); overload;
procedure ZSetString(const Src: PAnsiChar; const Len: Cardinal; var Dest: UTF8String); overload;
procedure ZSetString(const Src: PAnsiChar; const Len: Cardinal; var Dest: ZWideString); overload;
{$IFDEF WITH_RAWBYTESTRING}
procedure ZSetString(const Src: PAnsiChar; var Dest: RawByteString); overload;
procedure ZSetString(const Src: PAnsiChar; const Len: Cardinal; var Dest: RawByteString); overload;
{$ENDIF}

implementation

uses ZMatchPattern, StrUtils {$IFDEF WITH_UNITANSISTRINGS}, AnsiStrings{$ENDIF};

{**
  Determines a position of a first delimiter.
  @param Delimiters a string with possible delimiters.
  @param Str a string to be checked.
  @return a position of the first found delimiter or 0 if no delimiters was found.
}
function FirstDelimiter(const Delimiters, Str: string): Integer;
var
  I, Index: Integer;
begin
  Result := 0;
  for I := 1 to Length(Delimiters) do
  begin
    Index := Pos(Delimiters[I], Str);
    if (Index > 0) and ((Index < Result) or (Result = 0)) then
      Result := Index;
  end;
end;

{**
  Determines a position of a LAST delimiter.
  @param Delimiters a string with possible delimiters.
  @param Str a string to be checked.
  @return a position of the last found delimiter or 0 if no delimiters was found.
}
function LastDelimiter(const Delimiters, Str: string): Integer;
var
  I, Index: Integer;
begin
  Result := 0;
  for I := Length(Str) downto 1 do
  begin
    Index := Pos(Str[I], Delimiters);
    if (Index > 0) then
    begin
      Result := I;
      Break;
    end;
  end;
end;


{**
  Compares two PWideChars without stopping at #0 (Unicode Version)
  @param P1 first PWideChar
  @param P2 seconds PWideChar
  @return <code>True</code> if the memory at P1 and P2 are equal
}
function MemLCompUnicode(P1, P2: PWideChar; Len: Integer): Boolean;
begin
  while (Len > 0) and (P1^ = P2^) do
  begin
    Inc(P1);
    Inc(P2);
    Dec(Len);
  end;
  Result := Len = 0;
end;

{**
  Compares two PAnsiChars without stopping at #0
  @param P1 first PAnsiChar
  @param P2 seconds PAnsiChar
  @return <code>True</code> if the memory at P1 and P2 are equal
}
function MemLCompAnsi(P1, P2: PAnsiChar; Len: Integer): Boolean;
begin
  while (Len > 0) and (P1^ = P2^) do
  begin
    Inc(P1);
    Inc(P2);
    Dec(Len);
  end;
  Result := Len = 0;
end;

{**
  Checks is the string starts with substring.
  @param Str a string to be checked.
  @param SubStr a string to test at the start of the Str.
  @return <code>True</code> if Str started with SubStr;
}
function StartsWith(const Str, SubStr: ZWideString): Boolean;
var
  LenSubStr: Integer;
begin
  LenSubStr := Length(SubStr);
  if SubStr = '' then
    Result := True
  else if LenSubStr <= Length(Str) then
    Result := MemLCompUnicode(PWideChar(Str), PWideChar(SubStr), LenSubStr)
  else
    Result := False;
end;

function StartsWith(const Str, SubStr: RawByteString): Boolean; overload;
var
  LenSubStr: Integer;
begin
  LenSubStr := Length(SubStr);
  if SubStr = '' then
    Result := True
   else
    if LenSubStr <= Length(Str) then
      Result := MemLCompAnsi(PAnsiChar(Str), PAnsiChar(SubStr), LenSubStr)
    else
      Result := False;
end;

{**
  Checks is the string ends with substring.
  @param Str a string to be checked.
  @param SubStr a string to test at the end of the Str.
  @return <code>True</code> if Str ended with SubStr;
}
function EndsWith(const Str, SubStr: ZWideString): Boolean;
var
  LenSubStr: Integer;
  LenStr: Integer;
begin
  if SubStr = '' then
    Result := False // act like Delphi's AnsiEndsStr()
  else
  begin
    LenSubStr := Length(SubStr);
    LenStr := Length(Str);
    if LenSubStr <= LenStr then
      Result := MemLCompUnicode(PWideChar(Pointer(Str)) + LenStr - LenSubStr,
         Pointer(SubStr), LenSubStr)
    else
      Result := False;
  end;
end;

function EndsWith(const Str, SubStr: RawByteString): Boolean;
var
  LenSubStr: Integer;
  LenStr: Integer;
begin
  if SubStr = '' then
    Result := False // act like Delphi's AnsiEndsStr()
  else
  begin
    LenSubStr := Length(SubStr);
    LenStr := Length(Str);
    if LenSubStr <= LenStr then
      Result := MemLCompAnsi(PAnsiChar(Pointer(Str)) + LenStr - LenSubStr,
         Pointer(SubStr), LenSubStr)
    else
      Result := False;
  end;
end;

function ConvertMoneyToFloat(MoneyString: String): String;
var
  I: Integer;
begin
  if MoneyString = '' then
    Result := ''
  else
  begin
    if CharInSet(Char(MoneyString[1]), ['0'..'9', '-']) then
      Result := MoneyString
    else
      for i := 1 to Length(MoneyString) do
        if CharInSet(Char(MoneyString[I]), ['0'..'9', '-']) then
        begin
          if I > 1 then
          begin //Money type
            Result := Copy(MoneyString, I, Length(MoneyString)-i+1);
            if Pos(',', Result) > 0 then
              if Pos('.', Result) > 0  then
              begin
                Result := Copy(Result, 1, Pos(',', Result)-1);
                while Pos('.', Result) > 0  do
                  Result := Copy(Result, 1, Pos('.', Result)-1)+Copy(Result, Pos('.', Result)+1, Length(Result)); //remove ThousandSeparator
                Result := Result + '.'+Copy(MoneyString, Pos(',', MoneyString)+1, Length(MoneyString));
              end
              else
                Result[Pos(',', Result)] := '.';
          end;
          Break;
        end;
  end;
end;
{**
  Converts SQL string into float value.
  @param Str an SQL string with comma delimiter.
  @param Def a default value if the string can not be converted.
  @return a converted value or Def if conversion was failt.
}
{$IFDEF WITH_RAWBYTESTRING}
function SQLStrToFloatDef(Str: RawByteString; Def: Extended): Extended;
var
  OldDecimalSeparator: Char;
  OldThousandSeparator: Char;
  AString: String;
begin
  if Str = '' then
    Result := Def
  else
  begin
    OldDecimalSeparator := {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator;
    OldThousandSeparator := {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}ThousandSeparator;
    {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator := '.';
    {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}ThousandSeparator := ',';
    if not CharInSet(Char(String(Str)[1]), ['0'..'9', '-']) then
      AString := ConvertMoneyToFloat(String(Str))
    else
      AString := String(Str);
    Result := StrToFloatDef(AString, Def);
    {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator := OldDecimalSeparator;
    {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}ThousandSeparator := OldThousandSeparator;
  end;
end;
{$ENDIF}

function SQLStrToFloatDef(Str: String; Def: Extended): Extended;
var
  OldDecimalSeparator: Char;
  OldThousandSeparator: Char;
  AString: String;
begin
  if Str = '' then
    Result := Def
  else
  begin
    OldDecimalSeparator := {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator;
    OldThousandSeparator := {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}ThousandSeparator;
    {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator := '.';
    {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}ThousandSeparator := ',';
    if not CharInSet(Char(Str[1]), ['0'..'9', '-']) then
      AString := ConvertMoneyToFloat(Str)
    else
      AString := Str;
    Result := StrToFloatDef(AString, Def);
    {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator := OldDecimalSeparator;
    {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}ThousandSeparator := OldThousandSeparator;
  end;
end;

{**
  Converts SQL string into float value.
  @param Str an SQL string with comma delimiter.
  @return a converted value or Def if conversion was failt.
}
function SQLStrToFloat(const Str: AnsiString): Extended;
var
  OldDecimalSeparator: Char;
begin
  OldDecimalSeparator := {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator;
  {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator := '.';
  try
    Result := StrToFloat(String(Str));
  finally
    {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator := OldDecimalSeparator;
  end;
end;

{ Convert string buffer into pascal string }

function BufferToStr(Buffer: PWideChar; Length: LongInt): string;
var s : Widestring;
begin
   Result := '';
   if Assigned(Buffer) then
   begin
      SetString(s, Buffer, Length div SizeOf(Char));
      Result := s;
   end;
end;

{ Convert string buffer into pascal string }

function BufferToStr(Buffer: PAnsiChar; Length: LongInt): string;
begin
  Result := '';
  if Assigned(Buffer) then
    SetString(Result, Buffer, Length);
end;

function BufferToBytes(Buffer: Pointer; Length: LongInt): TByteDynArray;
begin
  SetLength(Result, Length);
  System.Move(Buffer^, Pointer(Result)^, Length);
end;

{**
  Converts a string into boolean value.
  @param Str a string value.
  @return <code>True</code> is Str = 'Y'/'YES'/'T'/'TRUE'/<>0
}
function StrToBoolEx(Str: string): Boolean;
begin
  Str := UpperCase(Str);
  Result := (Str = 'Y') or (Str = 'YES') or (Str = 'T') or (Str = 'TRUE')
    or (StrToIntDef(Str, 0) <> 0);
end;

{**
  Converts a boolean into string value.
  @param Bool a boolean value.
  @return <code>"True"</code> or <code>"False"</code>
}
function BoolToStrEx(Bool: Boolean): String;
begin
  if Bool then
    Result := 'True'
  else
    Result := 'False';
end;

{**
  Checks if the specified string can represent an IP address.
  @param Str a string value.
  @return <code>True</code> if the string can represent an IP address
    or <code>False</code> otherwise.
}
function IsIpAddr(const Str: string): Boolean;
var
  I, N, M, Pos: Integer;
begin
  if IsMatch('*.*.*.*', Str) then
  begin
    N := 0;
    M := 0;
    Pos := 1;
    for I := 1 to Length(Str) do
    begin
      if I - Pos > 3 then
        Break;
      if Str[I] = '.' then
      begin
       if StrToInt(Copy(Str, Pos, I - Pos)) > 255 then
         Break;
       Inc(N);
       Pos := I + 1;
      end;
      if CharInSet(Str[I], ['0'..'9']) then
        Inc(M);
    end;
    Result := (M + N = Length(Str)) and (N = 3);
  end
  else
    Result := False;
end;

procedure SplitToStringList(List: TStrings; Str: string; const Delimiters: string);
var
  DelimPos: Integer;
begin
  repeat
    DelimPos := FirstDelimiter(Delimiters, Str);
    if DelimPos > 0 then
    begin
      if DelimPos > 1 then
        List.Add(Copy(Str, 1, DelimPos - 1));
      Str := Copy(Str, DelimPos + 1, Length(Str) - DelimPos);
      end
      else
      Break;
  until DelimPos <= 0;
  if Str <> '' then
    List.Add(Str);
end;

{**
  Splits string using the multiple chars.
  @param Str the source string
  @param Delimiters the delimiters string
  @return the result list where plased delimited string
}
function SplitString(const Str, Delimiters: string): TStrings;
begin
  Result := TStringList.Create;
  try
    SplitToStringList(Result, Str, Delimiters);
  except
    Result.Free;
    raise;
  end;
end;

{**
  Puts to list a splitted string using the multiple chars which replaces
  the previous list content.
  @param List a list with strings.
  @param Str the source string
  @param Delimiters the delimiters string
}
procedure PutSplitString(List: TStrings; const Str, Delimiters: string);
begin
  List.Clear;
  SplitToStringList(List, Str, Delimiters);
end;

{**
  Appends to list a splitted string using the multiple chars.
  @param List a list with strings.
  @param Str the source string
  @param Delimiters the delimiters string
}
procedure AppendSplitString(List: TStrings; const Str, Delimiters: string);
begin
  SplitToStringList(List, Str, Delimiters);
end;

{**
  Composes a string from the specified strings list delimited with
  a special character.
  @param List a list of strings.
  @param Delimiter a delimiter string.
  @return a composed string from the list.
}
function ComposeString(List: TStrings; const Delimiter: string): string;
var
  i, Len, DelimLen: Integer;
  S: string;
  P: PChar;
begin
  DelimLen := Length(Delimiter);
  Len := 0;
  if List.Count > 0 then
  begin
    Inc(Len, Length(List[0]));
    for i := 1 to List.Count - 1 do
      Inc(Len, DelimLen + Length(List[i]));
  end;
  SetLength(Result, Len);
  P := Pointer(Result);
  for i := 0 to List.Count - 1 do
  begin
    if (i > 0) and (DelimLen > 0) then
    begin
      Move(Pointer(Delimiter)^, P^, DelimLen * SizeOf(Char));
      Inc(P, DelimLen);
    end;
    S := List[i];
    Len := Length(S);
    if Len > 0 then
    begin
      Move(Pointer(S)^, P^, Len * SizeOf(Char));
      Inc(P, Len);
    end;
  end;
end;

{**
  Converts a float value into SQL string with '.' delimiter.
  @param Value a float value to be converted.
  @return a converted string value.
}
function FloatToSQLStr(Value: Extended): string;
var
  OldDecimalSeparator: Char;
begin
  OldDecimalSeparator := {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator;
  {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator := '.';
  try
    Result := FloatToStr(Value);
  finally
    {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator := OldDecimalSeparator;
  end;
end;

{**
  Split a single string using the delimiter, appending the resulting strings
  to the List. (gto: New version, now unicode safe and without the bug which
  adds a blank line before the last found string)
  @param List a list to append the result.
  @param Str the source string
  @param Delimiters the delimiter string
}
procedure SplitToStringListEx(List: TStrings; const Str, Delimiter: string);
var
   temp: string;
   i: integer;
begin
   temp := Str + Delimiter;
   repeat
      i := List.Add(Copy(temp, 0, AnsiPos(Delimiter, temp) - 1));
      Delete(temp, 1, Length(List[i] + Delimiter));
   until
      temp = '';
end;

{**
  Puts to list a splitted string using the delimiter string which replaces
  the previous list content.
  @param List a list with strings.
  @param Str the source string
  @param Delimiters the delimiter string
}
procedure PutSplitStringEx(List: TStrings; const Str, Delimiter: string);
begin
  List.Clear;
  SplitToStringListEx(List, Str, Delimiter);
end;

{**
  Splits string using the delimiter string.
  @param Str the source string
  @param Delimiters the delimiter string
  @return the result list where plased delimited string
}
function SplitStringEx(const Str, Delimiter: string): TStrings;
begin
  Result := TStringList.Create;
  try
    SplitToStringListEx(Result, Str, Delimiter);
  except
    Result.Free;
    raise;
  end;
end;

{**
  Appends to list a splitted string using the delimeter string.
  @param List a list with strings.
  @param Str the source string
  @param Delimiters the delimiters string
}
procedure AppendSplitStringEx(List: TStrings; const Str, Delimiter: string);
begin
  SplitToStringListEx(List, Str, Delimiter);
end;

{**
  Converts bytes into a AnsiString representation.
  @param Value an array of bytes to be converted.
  @return a converted AnsiString.
}
function BytesToStr(const Value: TByteDynArray): AnsiString;
begin
  SetString(Result, PAnsiChar(@Value[0]), Length(Value))
end;

{**
  Converts AnsiString into an array of bytes.
  @param Value a AnsiString to be converted.
  @return a converted array of bytes.
}
function StrToBytes(const Value: AnsiString): TByteDynArray;
var L: Integer;
begin
  L := Length(Value);
  SetLength(Result, L);
  if Value <> '' then
    Move(Value[1], Result[0], L)
end;

{$IFDEF WITH_RAWBYTESTRING}
{**
  Converts a UTF8String into an array of bytes.
  @param Value a UTF8String to be converted.
  @return a converted array of bytes.
}
function StrToBytes(const Value: UTF8String): TByteDynArray;
var L: Integer;
begin
  L := Length(Value);
  SetLength(Result, L);
  if Value <> '' then
    Move(Value[1], Result[0], L)
end;
{**
  Converts a RawByteString into an array of bytes.
  @param Value a RawByteString to be converted.
  @return a converted array of bytes.
}
function StrToBytes(const Value: RawByteString): TByteDynArray;
var L: Integer;
begin
  L := Length(Value);
  SetLength(Result, L);
  if Value <> '' then
    Move(Value[1], Result[0], L)
end;
{$ENDIF}
{**
  Converts a WideString into an array of bytes.
  @param Value a String to be converted.
  @return a converted array of bytes.
}
function StrToBytes(const Value: WideString): TByteDynArray;
var L: Integer;
begin
  L := Length(Value)*2;
  SetLength(Result, L);
  if Value <> '' then
    Move(Value[1], Result[0], L)
end;
{**
  Converts a String into an array of bytes.
  @param Value a String to be converted.
  @return a converted array of bytes.
}
{$IFDEF PWIDECHAR_IS_PUNICODECHAR}
function StrToBytes(const Value: UnicodeString): TByteDynArray;
var L: Integer;
begin
  L := Length(Value) * SizeOf(Char);
  SetLength(Result, L);
  if Value <> '' then
    Move(Value[1], Result[0], L)
end;
{$ENDIF}
{**
  Converts bytes into a variant representation.
  @param Value an array of bytes to be converted.
  @return a converted variant.
}
function BytesToVar(const Value: TByteDynArray): Variant;
var
  I: Integer;
begin
  Result := VarArrayCreate([0, Length(Value) - 1], varByte);
  for I := 0 to Length(Value) - 1 do
    Result[I] := Value[I];
end;

{**
  Converts variant into an array of bytes.
  @param Value a varaint to be converted.
  @return a converted array of bytes.
}
function VarToBytes(const Value: Variant): TByteDynArray;
var
  I: Integer;
begin
  if not (VarIsArray(Value) and (VarArrayDimCount(Value) = 1) and
     ((VarType(Value) and VarTypeMask) = varByte)) then
    raise Exception.Create(SInvalidVarByteArray);

  SetLength(Result, VarArrayHighBound(Value, 1) + 1);
  for I := 0 to VarArrayHighBound(Value, 1) do
    Result[I] := Value[I];
end;

{**
  Converts Ansi SQL Date/Time (yyyy-mm-dd hh:nn:ss or yyyy-mm-dd hh:nn:ss.zzz)
  to TDateTime
  @param Value a date and time string.
  @return a decoded TDateTime value.
}
function AnsiSQLDateToDateTime(const Value: string): TDateTime;
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  Temp: string;
  DateFound: Boolean;

  procedure ExtractTime(AString: String);
  var dotPos: Integer;
  begin
    Hour := StrToIntDef(Copy(AString, 1, 2), 0);
    Min := StrToIntDef(Copy(AString, 4, 2), 0);
    Sec := StrToIntDef(Copy(AString, 7, 2), 0);

    //it the time Length is bigger than 8, it can have milliseconds and it ...
    dotPos := 0;
    MSec := 0;
    if Length(AString) > 8 then
      dotPos :=Pos ('.', AString);

    //if the dot are found, milliseconds are present.
    if dotPos > 0 then begin
      MSec := StrToIntDef(LeftStr(RightStr(AString,Length(AString)-dotPos)+'000',3),0);
    end;
  end;
begin
  Temp := Value;
  Result := 0;
  DateFound := False;

  if Length(Temp) >= 10 then
  begin
    Year := StrToIntDef(Copy(Temp, 1, 4), 0);
    Month := StrToIntDef(Copy(Temp, 6, 2), 0);
    Day := StrToIntDef(Copy(Temp, 9, 2), 0);

    if (Year <> 0) and (Month <> 0) and (Day <> 0) then
    begin
      try
        Result := EncodeDate(Year, Month, Day);
        DateFound := True;
      except
      end;
    end;
    Temp := RightStr(Temp, Length(Temp)-11);
  end;

  if (Length(Temp) >= 8) or ( not DateFound ) then
  begin
    if DateFound then
      ExtractTime(Temp)
    else
      ExtractTime(Value);
    try
      if Result >= 0 then
        Result := Result + EncodeTime(Hour, Min, Sec, MSec)
      else
        Result := Result - EncodeTime(Hour, Min, Sec, MSec)
    except
    end;
  end;
end;

{**
  Converts Timestamp String to TDateTime
  @param Value a timestamp string.
  @return a decoded TDateTime value.
}
function TimestampStrToDateTime(const Value: string): TDateTime;
var
  Year, Month, Day, Hour, Min, Sec: Integer;
  StrLength, StrPos, StrPosPrev: Integer;
  //
  function CharMatch( matchchars: string ): boolean;
  // try to match as much characters as possible
  begin
    StrPosPrev:= StrPos;
    Result:= false;
    while StrPos<=StrLength do
       if pos(Value[StrPos], matchchars) > 0 then
         begin
            inc(StrPos);
            Result := true;
         end
       else
         break;
  end;
begin
  Result := 0;
  StrPos:= 1;
  StrLength := Length(Value);

  if not CharMatch('1234567890') then
     exit; // year
  Year := StrToIntDef(Copy(Value, StrPosPrev, StrPos-StrPosPrev), 0);
  if not CharMatch('-/\') then
     exit;
  if not CharMatch('1234567890') then
     exit; // month
  Month:= StrToIntDef(Copy(Value, StrPosPrev, StrPos-StrPosPrev), 0);
  if not CharMatch('-/\') then
     exit;
  if not CharMatch('1234567890') then
     exit; // day
  Day:= StrToIntDef(Copy(Value, StrPosPrev, StrPos-StrPosPrev), 0);
  try
    Result := EncodeDate(Year, Month, Day);
  except
  end;
  //
  if not CharMatch(' ') then
     exit;
  if not CharMatch('1234567890') then
     exit; // hour
  Hour := StrToIntDef(Copy(Value, StrPosPrev, StrPos-StrPosPrev), 0);
  if not CharMatch('-/\') then
     exit;
  if not CharMatch('1234567890') then
     exit; // minute
  Min:= StrToIntDef(Copy(Value, StrPosPrev, StrPos-StrPosPrev), 0);
  if not CharMatch('-/\') then
     exit;
  if not CharMatch('1234567890') then
     exit; // second
  Sec:= StrToIntDef(Copy(Value, StrPosPrev, StrPos-StrPosPrev), 0);
  try
    Result := REsult + EncodeTime(Hour, Min, Sec,0);
  except
  end;

end;


{**
  Converts TDateTime to Ansi SQL Date/Time
  @param Value an encoded TDateTime value.
  @return a  date and time string.
}
function DateTimeToAnsiSQLDate(Value: TDateTime; WithMMSec: Boolean = False): string;
var
  a, MSec:Word;
begin
  if WithMMSec then
  begin
    DecodeTime(Value,a,a,a,MSec);
    if MSec=0 then
      Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Value)
    else
      Result := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Value);
  end
  else
    Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Value)
end;

{ TZSortedList }

{**
  Performs quick sort algorithm for the list.
}
procedure TZSortedList.QuickSort(SortList: PPointerList; L, R: Integer;
  SCompare: TZListSortCompare);
var
  I, J: Integer;
  P, T: Pointer;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while (I < R) And (SCompare(SortList^[I], P) < 0) do //check I against R too since the pointer can be nil
        Inc(I);
      while (J > L) And (SCompare(SortList^[J], P) > 0) do //check j against L too since the pointer can be nil
        Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(SortList, L, J, SCompare);
    L := I;
  until I >= R;
end;

{**
  Performs sorting for this list.
  @param Compare a comparison function.
}
procedure TZSortedList.Sort(Compare: TZListSortCompare);
begin
  if (List <> nil) and (Count > 0) then
    {$IFDEF DELPHI16_UP}
    QuickSort(@List, 0, Count - 1, Compare);
    {$ELSE}
    QuickSort(List, 0, Count - 1, Compare);
    {$ENDIF}
end;

{**
  Converts an string into escape PostgreSQL format.
  @param Value a regular string.
  @return a string in PostgreSQL escape format.
}
function EncodeCString(const Value: string): string;
var
  I: Integer;
  SrcLength, DestLength: Integer;
  SrcBuffer, DestBuffer: PChar;
begin
  SrcLength := Length(Value);
  SrcBuffer := PChar(Value);
  DestLength := 0;
  for I := 1 to SrcLength do
  begin
    if CharInSet(SrcBuffer^, [#0]) then
       Inc(DestLength, 4)
    else if CharInSet(SrcBuffer^, ['"', '''', '\']) then
       Inc(DestLength, 2)
    else
       Inc(DestLength);
    Inc(SrcBuffer);
  end;

  SrcBuffer := PChar(Value);
  SetLength(Result, DestLength);
  DestBuffer := PChar(Result);

  for I := 1 to SrcLength do
  begin
    if CharInSet(SrcBuffer^, [#0]) then
    begin
      DestBuffer[0] := '\';
      DestBuffer[1] := Chr(Ord('0') + (Byte(SrcBuffer^) shr 6));
      DestBuffer[2] := Chr(Ord('0') + ((Byte(SrcBuffer^) shr 3) and $07));
      DestBuffer[3] := Chr(Ord('0') + (Byte(SrcBuffer^) and $07));
      Inc(DestBuffer, 4);
    end
    else if CharInSet(SrcBuffer^, ['"', '''', '\']) then
    begin
      DestBuffer[0] := '\';
      DestBuffer[1] := SrcBuffer^;
      Inc(DestBuffer, 2);
    end
    else
    begin
      DestBuffer^ := SrcBuffer^;
      Inc(DestBuffer);
    end;
    Inc(SrcBuffer);
  end;
end;

{**
  Converts an string from escape PostgreSQL format.
  @param Value a string in PostgreSQL escape format.
  @return a regular string.
}
function DecodeCString(const Value: string): string;
var
  SrcLength, DestLength: Integer;
  SrcBuffer, DestBuffer: PChar;
begin
  SrcLength := Length(Value);
  SrcBuffer := PChar(Value);
  SetLength(Result, SrcLength);
  DestLength := 0;
  DestBuffer := PChar(Result);

  while SrcLength > 0 do
  begin
    if SrcBuffer^ = '\' then
    begin
      Inc(SrcBuffer);
      if CharInSet(SrcBuffer^, ['0'..'9']) then
      begin
        DestBuffer^ := Chr(((Byte(SrcBuffer[0]) - Ord('0')) shl 6)
          or ((Byte(SrcBuffer[1]) - Ord('0')) shl 3)
          or ((Byte(SrcBuffer[2]) - Ord('0'))));
        Inc(SrcBuffer, 3);
        Dec(SrcLength, 4);
      end
      else
      begin
        case SrcBuffer^ of
          'r': DestBuffer^ := #13;
          'n': DestBuffer^ := #10;
          't': DestBuffer^ := #9;
        else
               DestBuffer^ := SrcBuffer^;
        end;
        Inc(SrcBuffer);
        Dec(SrcLength, 2);
      end
    end
    else
    begin
      DestBuffer^ := SrcBuffer^;
      Inc(SrcBuffer);
      Dec(SrcLength);
    end;
    Inc(DestBuffer);
    Inc(DestLength);
  end;
  SetLength(Result, DestLength);
end;


{**
  Replace chars in the string
  @param Source a char to search.
  @param Target a char to replace.
  @param Str a source string.
  @return a string with replaced chars.
}
function ReplaceChar(const Source, Target: Char; const Str: string): string;
var
  P: PChar;
  I:Integer;
begin
  Result := Str;
  UniqueString(Result);
  P := Pointer(Result);
  for i := 0 to Length(Str) - 1 do
  begin
    if P^ = Source then
      P^ := Target;
    Inc(P);
  end;
end;

{**
   Copy buffer to the pascal string
   @param Buffer a buffer with data
   @param Length a buffer length
   @return a buffer content
}
function MemPas(Buffer: PChar; Length: LongInt): string;
begin
  Result := '';
  if Assigned(Buffer) then
    SetString(Result, Buffer, Length);
end;

{**
  Decodes a full version value encoded with Zeos SQL format:
   (major_version * 1,000,000) + (minor_version * 1,000) + sub_version
  into separated major, minor and subversion values
  @param FullVersion an integer containing the Full Version to decode.
  @param MajorVersion an integer containing the Major Version decoded.
  @param MinorVersion an integer containing the Minor Version decoded.
  @param SubVersion an integer contaning the Sub Version (revision) decoded.
}
procedure DecodeSQLVersioning(const FullVersion: Integer;
 out MajorVersion: Integer; out MinorVersion: Integer;
 out SubVersion: Integer);
begin
 MajorVersion := FullVersion div 1000000;
 MinorVersion := (FullVersion - (MajorVersion * 1000000)) div 1000;
 SubVersion   := FullVersion-(MajorVersion*1000000)-(MinorVersion*1000);
end;

{**
  Encodes major, minor and subversion (revision) values in Zeos SQL format:
   (major_version * 1,000,000) + (minor_version * 1,000) + sub_version
  For example, 4.1.12 is returned as 4001012.
  @param MajorVersion an integer containing the Major Version.
  @param MinorVersion an integer containing the Minor Version.
  @param SubVersion an integer containing the Sub Version (revision).
  @return an integer containing the full version.
}
function EncodeSQLVersioning(const MajorVersion: Integer;
 const MinorVersion: Integer; const SubVersion: Integer): Integer;
begin
 Result := (MajorVersion * 1000000) + (MinorVersion * 1000) + SubVersion;
end;

{**
  Formats a Zeos SQL Version format to X.Y.Z where:
   X = major_version
   Y = minor_version
   Z = sub version
  @param SQLVersion an integer
  @return Formated Zeos SQL Version Value.
}

function FormatSQLVersion(const SQLVersion: Integer): string;
var
   MajorVersion, MinorVersion, SubVersion: Integer;
begin
 DecodeSQLVersioning(SQLVersion, MajorVersion, MinorVersion, SubVersion);
 Result := IntToStr(MajorVersion)+'.'+IntToStr(MinorVersion)+'.'+IntToStr(SubVersion);
end;

{**
  Arranges thousand and decimal separator to a System-defaults
  @param the value which has to be converted and arranged
  @return a valid floating value
}
function ZStrToFloat(Value: PAnsiChar): Extended;
var
  OldDecimalSeparator, OldThousandSeparator: Char;
begin
  OldDecimalSeparator := {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator;
  OldThousandSeparator := {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}ThousandSeparator;

  if {$IFDEF WITH_ANSISTRINGPOS_DEPRECATED}AnsiStrings.{$ENDIF}AnsiStrPos(PAnsiChar(Value), PAnsiChar(AnsiString(OldDecimalSeparator))) = nil then
    if {$IFDEF WITH_ANSISTRINGPOS_DEPRECATED}AnsiStrings.{$ENDIF}AnsiStrPos(PAnsiChar(Value), PAnsiChar(AnsiString(OldThousandSeparator))) = nil then
      //No DecimalSeparator and no ThousandSeparator
      Result := StrToFloat(String(Value))
    else
    begin
      //wrong DecimalSepartor
      {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator := OldThousandSeparator;
      {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}ThousandSeparator := OldDecimalSeparator;
      Result := StrToFloat(String(Value));
    end
  else
    if {$IFDEF WITH_ANSISTRINGPOS_DEPRECATED}AnsiStrings.{$ENDIF}AnsiStrPos(PAnsiChar(Value), PAnsiChar(AnsiString(OldThousandSeparator))) = nil then
      //default DecimalSepartor
      Result := StrToFloat(String(Value))
    else
      if {$IFDEF WITH_STRLEN_DEPRECATED}AnsiStrings.{$ENDIF}StrLen({$IFDEF WITH_ANSISTRINGPOS_DEPRECATED}AnsiStrings.{$ENDIF}AnsiStrPos(PAnsiChar(Value), PAnsiChar(AnsiString(OldDecimalSeparator)))) <
          {$IFDEF WITH_STRLEN_DEPRECATED}AnsiStrings.{$ENDIF}StrLen({$IFDEF WITH_ANSISTRINGPOS_DEPRECATED}AnsiStrings.{$ENDIF}AnsiStrPos(PAnsiChar(Value), PAnsiChar(AnsiString(OldThousandSeparator)))) then
          //default DecimalSepartor and ThousandSeparator
        Result := StrToFloat(String(Value))
      else
      begin
        //wrong DecimalSepartor and ThousandSeparator
        {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator := OldThousandSeparator;
        {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}ThousandSeparator := OldDecimalSeparator;
        Result := StrToFloat(String(Value));
      end;

  {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator := OldDecimalSeparator;
  {$IFDEF WITH_FORMATSETTINGS}FormatSettings.{$ENDIF}ThousandSeparator := OldThousandSeparator;
end;

{**
  Arranges thousand and decimal separator to a System-defaults
  @param the value which has to be converted and arranged
  @return a valid floating value
}
function ZStrToFloat(Value: AnsiString): Extended;
begin
  Result := ZStrToFloat(PAnsiChar(Value));
end;

procedure ZSetString(const Src: PAnsiChar; var Dest: AnsiString);
begin
  if Assigned(Src) then
    ZSetString(Src, {$IFDEF WITH_STRLEN_DEPRECATED}AnsiStrings.{$ENDIF}StrLen(Src), Dest)
  else
    Dest := '';
end;

procedure ZSetString(const Src: PAnsiChar; const Len: Cardinal; var Dest: AnsiString);
begin
  if ( Len = 0 ) or ( Src = nil ) then
    Dest := ''
  else
  begin
    SetLength(Dest, Len);
    Move(Src^, PAnsiChar(Dest)^, Len);
  end;
end;

procedure ZSetString(const Src: PAnsiChar; var Dest: UTF8String);
begin
  if Assigned(Src) then
    ZSetString(Src, {$IFDEF WITH_STRLEN_DEPRECATED}AnsiStrings.{$ENDIF}StrLen(Src), Dest)
  else
    Dest := '';
end;

procedure ZSetString(const Src: PAnsiChar; const Len: Cardinal; var Dest: UTF8String);
begin
  if ( Len = 0 ) or ( Src = nil ) then
    Dest := ''
  else
  begin
    SetLength(Dest, Len);
    Move(Src^, PAnsiChar(Dest)^, Len);
  end;
end;

procedure ZSetString(const Src: PAnsiChar; const Len: Cardinal; var Dest: ZWideString); overload;
begin
  if ( Len = 0 ) or ( Src = nil ) then
    Dest := ''
  else
  begin
    SetLength(Dest, Len div 2);
    Move(Src^, PWideChar(Dest)^, Len);
  end;
end;

{$IFDEF WITH_RAWBYTESTRING}
procedure ZSetString(const Src: PAnsiChar; var Dest: RawByteString);
begin
  if Assigned(Src) then
    ZSetString(Src, {$IFDEF WITH_STRLEN_DEPRECATED}AnsiStrings.{$ENDIF}StrLen(Src), Dest)
  else
    Dest := '';
end;

procedure ZSetString(const Src: PAnsiChar; const Len: Cardinal; var Dest: RawByteString);
begin
  if ( Len = 0 ) or ( Src = nil ) then
    Dest := ''
  else
  begin
    SetLength(Dest, Len);
    Move(Src^, PAnsiChar(Dest)^, Len);
  end;
end;
{$ENDIF}

end.
