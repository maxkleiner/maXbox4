unit MaxStrUtils;

interface

uses
  Classes,
  SysUtils;


type CharSet = TSysCharSet;



procedure ParseFields(Separators, WhiteSpace: TSysCharSet; Content: PChar;
  Strings: TStrings; Decode: Boolean);

function HTTPDecode(const AStr: String): string;
function HTTPEncode(const AStr: String): string;

function FormatDate(const DateString: string): string;
function FormatListMasterDate(const DateStr, FormatDefStr: String; Len: Integer): String;

function InvertCase(const S: String): String;
function CommentLinesWithSlashes(const S: String): String;
function UncommentLinesWithSlashes(const S: String): String;

function StripChars(const S: String; Strip: CharSet): String;
function TrimChars(const S: string; Chars: CharSet): string;
function TrimLeftChars(const S: string; Chars: CharSet): string;
function TrimRightChars(const S: string; Chars: CharSet): string;

function ContainsChars(const S: String; Strip: CharSet): Boolean;
function DequotedStr(const S: String; AQuoteChar: Char): String;

procedure LeftPadStr(var S: String;
  toLength: Integer; withChar: Char );
procedure RightPadStr(var S: String;
  toLength: Integer; withChar: Char );

function RemoveChars(S: string; Chars: CharSet): string;
function FilterChars(S: string; Chars: CharSet): string;
function RemoveNonNumericChars(S: string): string;
function RemoveNonAlphanumChars(S: string): string;
function RemoveNonAlphaChars(S: string): string;
function HasAlphaChars(S: string): boolean;
function ReplaceChars(S: string; Chars: CharSet; ReplaceWith: Char): string;

function DomainOfEMail(const EMailAddress: String): String;
function IPToHexIP(const IP: String): String;

procedure CmdLineToStrings(S: AnsiString; const List: TStrings);

const
  BASE2  = '01';
  BASE10 = '0123456789';
  BASE16 = '0123456789ABCDEF';
  BASE36 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  BASE62 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

function BaseConvert(Number, FromDigits, ToDigits: String): String;


implementation

uses
  DateUtils; // Delphi 7


function HTTPDecode(const AStr: String): String;
var
  Sp, Rp, Cp: PChar;
begin
  SetLength(Result, Length(AStr));
  Sp := PChar(AStr);
  Rp := PChar(Result);
  while Sp^ <> #0 do
  begin
    if not (Sp^ in ['+','%']) then
      Rp^ := Sp^
    else
      if Sp^ = '+' then
        Rp^ := ' '
      else
      begin
        inc(Sp);
        if Sp^ = '%' then
          Rp^ := '%'
        else
        begin
          Cp := Sp;
          Inc(Sp);
          Rp^ := Chr(StrToInt(Format('$%s%s',[Cp^, Sp^])));
        end;
      end;
    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(Result, Rp - PChar(Result));
end;

function HTTPEncode(const AStr: String): String;
const
  NoConversion = ['A'..'Z','a'..'z','*','@','.','_','-',
                  '0'..'9','$','!','''','(',')'];
var
  Sp, Rp: PChar;
begin
  SetLength(Result, Length(AStr) * 3);
  Sp := PChar(AStr);
  Rp := PChar(Result);
  while Sp^ <> #0 do
  begin
    if Sp^ in NoConversion then
      Rp^ := Sp^
    else
      if Sp^ = ' ' then
        Rp^ := '+'
      else
      begin
        FormatBuf(Rp^, 3, '%%%.2x', 6, [Ord(Sp^)]);
        Inc(Rp,2);
      end;
    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(Result, Rp - PChar(Result));
end;


procedure ParseFields(Separators, WhiteSpace: TSysCharSet; Content: PChar;
  Strings: TStrings; Decode: Boolean);
var
  Head, Tail: PChar;
  EOS, InQuote, LeadQuote: Boolean;
  QuoteChar: Char;
begin
  if (Content = nil) or (Content^ = #0) then Exit;
  Tail := Content;
  InQuote := False;
  QuoteChar := #0;
  repeat
    while Tail^ in WhiteSpace + [#13, #10] do Inc(Tail);
    Head := Tail;
    LeadQuote := False;
    while True do
    begin
      while (InQuote and (Tail^ <> '"')) or
        not (Tail^ in Separators + [#0, #13, #10, '"']) do Inc(Tail);
      if Tail^ = '"' then
      begin
        if (QuoteChar <> #0) and (QuoteChar = Tail^) then
          QuoteChar := #0
        else
        begin
          LeadQuote := Head = Tail;
          QuoteChar := Tail^;
          if LeadQuote then Inc(Head);
        end;
        InQuote := QuoteChar <> #0;
        if InQuote then
          Inc(Tail)
        else Break;
      end else Break;
    end;
    if not LeadQuote and (Tail^ <> #0) and (Tail^ = '"') then
      Inc(Tail);
    EOS := Tail^ = #0;
    Tail^ := #0;
    if Head^ <> #0 then
      if Decode then
        Strings.Add(HTTPDecode(Head))
      else Strings.Add(Head);
    Inc(Tail);
  until EOS;
end;







{The following has been adopted from WealthWizard }

const
  DateDelimiters = [' ','/','-','.'];
  AlphaChars = ['a'..'z','A'..'Z'];
  Digits = ['0'..'9'];
  AlphanumericChars = AlphaChars + Digits;
  MinValidInputYear = 1888;
  MaxValidInputYear = 2999;
var
  DEFAULT_DATE_FORMAT: String = 'yyyy/mm/dd';


function TrimEx(const S: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do begin
    if S[I] in AlphanumericChars then begin
      Result := Copy(S,I,Length(S)-I+1);
      Break;
    end;
  end;
end;



function MonthStrToInt(const S: String): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to 12 do begin
    if CompareText(S,ShortMonthNames[I])=0 then begin
      Result := I;
      Break;
    end;
  end;
  if Result <> 0 then
    Exit;
  for I := 1 to 12 do begin
    if CompareText(S,LongMonthNames[I])=0 then begin
      Result := I;
      Break;
    end;
  end;
end;



function LoCase(Ch: Char ): Char;
begin
  Result := Ch;
  case Result of
    'A'..'Z':  Inc(Result, Ord('a') - Ord('A'));
  end;
end;


function InvertCase(const S: String): String;
var
  I: Integer;
begin
  Result := S;
  for I := 1 to Length(Result) do begin
     if (Result[I] in ['A'..'Z']) then begin
        Result[I] := LoCase(Result[I])
     end else if (Result[I] in ['a'..'z']) then begin
        Result[I] := UpCase(Result[I])
     end;
  end;
end;


function CommentLinesWithSlashes(const S: String): String;
var
  Strings: TStringList;
  I: Integer;
  Line: String;
  Temp: String;
  Indent: Integer;
  EOFisEOL: Boolean;
begin
  Strings := TStringList.Create;
  try
    Strings.Text := S;
    if S[Length(S)] in [#13,#10] then
      EOFIsEOL := True
    else
      EOFIsEOL := False;
    for I := 0 to Strings.Count-1 do begin
      Line := Strings[I];
      Temp := TrimLeft(Line);
      Indent := Length(Line) - Length(Temp);
      if (Length(Temp) > 0) then begin
        Temp := StringOfChar(' ',Indent) + '//' + Temp;
        Strings[I] := Temp;
      end;
    end;
    Result := Strings.Text;
    if not EOFIsEOL then
      Result := Copy(Result,1,Length(Result)-2);
  finally
    Strings.Free;
  end;
end;


function UncommentLinesWithSlashes(const S: String): String;
var
  Strings: TStringList;
  I: Integer;
  Line: String;
  Temp: String;
  Indent: Integer;
  EOFisEOL: Boolean;
begin
  Strings := TStringList.Create;
  try
    Strings.Text := S;
    if S[Length(S)] in [#13,#10] then
      EOFIsEOL := True
    else
      EOFIsEOL := False;
    for I := 0 to Strings.Count-1 do begin
      Line := Strings[I];
      Temp := TrimLeft(Line);
      Indent := Length(Line) - Length(Temp);
      if (Length(Temp) > 1) and (Temp[1] = '/') and (Temp[2]='/') then begin
        Temp := StringOfChar(' ',Indent) + Copy(Temp,3,MaxInt);
        Strings[I] := Temp;
      end;
    end;
    Result := Strings.Text;
    if not EOFIsEOL then
      Result := Copy(Result,1,Length(Result)-2);
  finally
    Strings.Free;
  end;
end;




function StringHasDelimiters(dateStr: string; var cha: string): boolean;
// this function check if dateStr contains one of the characters:
// '/', '-', '.' and ' '
// and returns the delimiter character found.
var
  i: integer;
  flag: boolean;
begin
  flag := false;
  cha := '';
  for i := 1 to Length(dateStr) do begin
    if (dateStr[i] in DateDelimiters) then begin
      cha := dateStr[i];
      flag := true;
      Break;
    end
  end;
  Result := flag;
end;


function RemoveChars(S: string; Chars: CharSet): string;
// The specified chars get removed
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do
    if (Result[i] in Chars) then
      Delete(Result, i, 1);
end;


function ReplaceChars(S: string; Chars: CharSet; ReplaceWith: Char): string;
// The specified chars get replaced with teh ReplaceWith char
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do
    if (Result[i] in Chars) then
      Result[I] := ReplaceWith;
end;


function FilterChars(S: string; Chars: CharSet): string;
// The specified chars stay in
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do
    if not (Result[i] in Chars) then
      Delete(Result, i, 1);
end;


function RemoveNonNumericChars(S: string): string;
begin
  Result := RemoveChars(S,Digits);
end;


function RemoveNonAlphaNumChars(S: string): string;
begin
  Result := RemoveChars(S,['0'..'9','a'..'z','A'..'Z']);
end;


function RemoveNonAlphaChars(S: string): string;
begin
  Result := RemoveChars(S,['a'..'z','A'..'Z']);
end;


function HasAlphaChars(S: string): boolean;
  // This function checks if the string
  // alString has alphabetical characters
var
  I: Integer;
begin
  Result := False;
  for i := 1 to Length(S) do begin
    if (S[i] in ['a'..'z','A'..'Z']) then begin
      Result := true;
      Break;
    end
  end;
end;







function Compute2DigitYear(Year: Integer): Integer;
var
  CurrentYr, Mo, Dy: Word;
  CurrentYr2: Integer;
  CenturyYr: Integer;
  PivotYr: Integer;
begin
  Result := Year;
  if Year >= 100 then
    Exit;
  DecodeDate(Date,CurrentYr,Mo,Dy);
  CurrentYr2 := CurrentYr mod 100;
  PivotYr := TwoDigitYearCenturyWindow;
  if (CurrentYr2 <= PivotYr) and (Year > PivotYr) then begin
    CenturyYr := (CurrentYr div 100 - 1) * 100;
  end else if (CurrentYr2 > PivotYr) and (Year < PivotYr) then begin
    CenturyYr := (CurrentYr div 100 + 1) * 100;
  end else begin
    CenturyYr := (CurrentYr div 100) * 100;
  end;
  Result := CenturyYr + Year;
end;




function FormatDateCase1(dateString: string): string;
// Takes care of the case Dec-16-1998, 16-December-1998,...
// i.e. dates with month names spelled out
var
  S1, S2, S3: String;
  N1, N2, N3: Integer;
  C1, C2, C3: Integer;
  Yr, Mo, Dy: Word;


  function Parse(var S: String): String;
    var
      PPos: Integer;

    procedure ParseAlphas;
    begin
      PPOs := 1;
      while (PPos <= Length(S)) and (S[PPos] in AlphaChars) do
        Inc(PPos);
      Result := Copy(S,1,PPos-1);
    end;

    procedure ParseDigits;
    begin
      PPOs := 1;
      while (PPos <= Length(S)) and (S[PPos] in Digits) do
        Inc(PPos);
      Result := Copy(S,1,PPos-1);
    end;

    begin
      Result := '';
      S := TrimEx(S);
      if S = '' then
        Exit;
      if S[1] in AlphaChars then
        ParseAlphas
      else if S[1] in Digits then
        ParseDigits
      else
        raise EConvertError.Create('Invalid date string.');
      S := Trim(Copy(S,PPos,Length(S)-PPos+1));
    end;

begin
  Result := '';
  // Split into components
  // Then, must determine which component is non-numeric
  // Finally, must find out which is the year

  S1 := Parse(DateString);
  Val(S1,N1,C1);
  S2 := Parse(DateString);
  Val(S2,N2,C2);
  S3 := Parse(DateString);
  Val(S3,N3,C3);

  if (C1 <> 0) and (C2 = 0) and (C3 = 0) then begin
    // MMM-DD-YY i.e. S1 is month, S2 is day, S3 is year
    Mo := MonthStrToInt(S1);
    Dy := N2;
    Yr := N3;
  end else if (C1 = 0) and (C2 <> 0) and (C3 = 0) then begin
    // NN-MMM-NN i.e. S2 is month, don't kow which is year or day
    Mo := MonthStrToInt(S2);
    if N1 > 31 then begin
      // assume year
      Yr := N1;
      Dy := N3;
    end else begin
      Yr := N3;
      Dy := N1;
    end;
  end else if (C1 = 0) and (C2 = 0) and (C3 <> 0) then begin
    // This is bizzarre, but anyway...
    // NN-NN-MMM i.e. S3 is month, S1 is year
    Mo := MonthStrToInt(S3);
    if N1 > 31 then begin
      // assume year
      Yr := N1;
      Dy := N2;
    end else begin
      Yr := N2;
      Dy := N1;
    end;
  end else raise EConvertError.Create('Invalid date string.');
  Result := Format('%.2d%.2d%.2d',[Mo,Dy,Yr]);
end;


function FormatDateCase2(dateString: string): string;
// Takes care of dates without month names spelled out
var
  cPos, iLength: integer;
  cha, dString: string;


  procedure Convert2DigitYear(var DateString: String);
    // mmddyy
    var
      D: TDateTime;
      Yr, Mo, Dy: Word;
      CurrentYr: Word;
    begin
      DecodeDate(Date,CurrentYr,Mo,Dy);
      Mo := StrToInt(Copy(DateString,1,2));
      Dy := StrToInt(Copy(DateSTring,3,2));
      Yr := StrToInt(Copy(DateString,5,2));
      Yr := Compute2DigitYear(Yr);
      D := EncodeDAte(Yr,Mo,Dy);
      ShortDateFormat := DEFAULT_DATE_FORMAT;
      DateSTring := DateToStr(D);
    end;


  procedure Convert4DigitYear(var DateString: String);
    // mmddyyyy
    var
      D: TDateTime;
      Yr, Mo, Dy: Word;
    begin
      Mo := StrToInt(Copy(DateString,1,2));
      Dy := StrToInt(Copy(DateSTring,3,2));
      Yr := StrToInt(Copy(DateString,5,4));
      D := EncodeDAte(Yr,Mo,Dy);
      ShortDateFormat := DEFAULT_DATE_FORMAT;
      DateSTring := DateToStr(D);
    end;


  procedure Normalize4DigitYear(var Year: Integer);
  var
    Yy, Mm, Dd: Word;
  begin
    DecodeDate(Now,Yy,Mm,Dd);
    if Year < MinValidInputYear then
      Year := Yy;
    if Year > MaxValidInputYear then
      Year := Yy;
  end;


  procedure ConvertWithDelimiters(var DateString: String; const Cha: String);
    var
      D: TDateTime;
      S1, S2, S3: String;
      N1, N2, N3: Integer;
    begin
      cPos := Pos(cha, DateString);
      S1 := Copy(DateString,1,cPos-1);
      Delete(DateString,1,cPos);
      cPos := Pos(cha, DateString);
      S2 := Copy(DateString,1,cPos-1);
      Delete(DateString,1,cPos);
      S3 := Copy(DateString,1,4);

      N1 := StrToInt(S1);
      N2 := StrToInt(S2);
      N3 := StrToInt(S3);

      if N3 > 100 then begin
        // mm/dd/yyyy
        Normalize4DigitYear(N3);
        D := EncodeDate(N3,N1,N2);
        DateString := FormatDateTime('mmddyyyy',D);
        Convert4DigitYear(DateString);
      end else if N1 > 100 then begin
        // yyyy/mm/dd
        Normalize4DigitYear(N1);
        D := EncodeDate(N1,N2,N3);
        DateString := FormatDateTime('mmddyyyy',D);
        Convert4DigitYear(DateString);
      end else begin
        // mm/dd/yy
        // Do NOT Normalize4DigitYear(N3);
        N3 := Compute2DigitYear(N3);
        D := EncodeDate(N3,N1,N2);
        DateSTring := FormatDateTime('mmddyy',D);
        Convert2DigitYear(DateString);
      end;
    end;

begin
  if StringHasDelimiters(dateString, cha) then begin
    dString := dateString;
    ConvertWithDelimiters(dString, cha);
    Result := dString;
  end else begin
    dString := RemoveNonNumericChars(dateString);
    iLength := Length(dString);
    case iLength of
      6: Convert2DigitYear(dString); // mmddyy
      8: Convert4DigitYear(dString); // mmddyyyy
    else
      raise EConvertError.Create('Invalid Date string.');
    end;
    Result := dString;
  end;
end;



function FormatDate(const DateString: string): string;
var
  tempDateString, dateStr: string;
begin
  tempDateString := dateString;
  dateStr := dateString;
  dateStr := LowerCase(dateStr);
  tempDateString := LowerCase(tempDateString);
  tempDateString := RemoveNonAlphanumChars(tempDateString);
  try
    if HasAlphaChars(tempDateString) then
      Result := FormatDateCase2(FormatDateCase1(dateStr))
    else
      Result := FormatDateCase2(dateStr);
    StrToDate(Result); // Final date validation
  except
    on e: EConvertError do begin
      ShortDateFormat := DEFAULT_DATE_FORMAT;
      Result := DateToStr(Date);
    end;
  end; // try/except
end;



function FormatListMasterDate(const DateStr, FormatDefStr: String; Len: Integer): String;
  {
  FormatStr = YMD or DMY or MDY
  Len = 8 or 10
  }
var
  Lst: TStrings;

  procedure SplitRawDate(const DateStr: String; const FormatStr: String; Lst: TStrings);
  var
    StrLen: Integer;
  begin
    StrLen := Length(DateStr);
    case StrLen of
      4:
      begin
        Lst.Add( IntToStr(YearOf(Now)));
        Lst.Add( Copy(DateStr,1,2) );
        Lst.Add( Copy(DateStr,3,2) );
      end;
      6:
      begin
        Lst.Add( Copy(DateStr,1,2) );
        Lst.Add( Copy(DateStr,3,2) );
        Lst.Add( Copy(DateStr,5,2) );
      end;
      8:
      begin
        case FormatStr[1] of
          'Y': begin
            Lst.Add( Copy(DateStr,1,4) );
            Lst.Add( Copy(DateStr,5,2) );
            Lst.Add( Copy(DateStr,7,2) );
          end;
          'M': begin
            case FormatStr[2] of
              'Y': begin
                Lst.Add( Copy(DateStr,1,2) );
                Lst.Add( Copy(DateStr,3,4) );
                Lst.Add( Copy(DateStr,7,2) );
              end;
              'D': begin
                Lst.Add( Copy(DateStr,1,2) );
                Lst.Add( Copy(DateStr,3,2) );
                Lst.Add( Copy(DateStr,5,4) );
              end;
            end;
          end;
          'D': begin
            case FormatStr[2] of
              'Y': begin
                Lst.Add( Copy(DateStr,1,2) );
                Lst.Add( Copy(DateStr,3,4) );
                Lst.Add( Copy(DateStr,7,2) );
              end;
              'M': begin
                Lst.Add( Copy(DateStr,1,2) );
                Lst.Add( Copy(DateStr,3,2) );
                Lst.Add( Copy(DateStr,5,4) );
              end;
            end;
          end;
        end;

      end;
    end;
  end;


  procedure SynthesizeDate(var Result: String; const FormatDefStr: String; Lst: TStrings);
  var
    Y,
    M,
    D: Word;
    Date: TDateTime;
  begin
    if Lst.Count = 2 then
      Lst.Insert(0, IntToStr( YearOf(Now) ) );
    case FormatDefStr[1] of
      'Y': begin
        case FormatDefStr[2] of
          'M': begin
            case Len of
              8: begin
                Y := StrToInt(Lst[0]);
                M := StrToInt(Lst[1]);
                D := StrToInt(Lst[2]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('yy/mm/dd',Date);
              end;
              10: begin
                Y := StrToInt(Lst[0]);
                M := StrToInt(Lst[1]);
                D := StrToInt(Lst[2]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('yyyy/mm/dd',Date);
              end;
            end;
          end;
          'D': begin
            case Len of
              8: begin
                Y := StrToInt(Lst[0]);
                M := StrToInt(Lst[2]);
                D := StrToInt(Lst[1]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('yy/dd/mm',Date);
              end;
              10: begin
                Y := StrToInt(Lst[0]);
                M := StrToInt(Lst[2]);
                D := StrToInt(Lst[1]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('yyyy/mm/dd',Date);
              end;
            end;
          end;
        end;
      end;
      'M': begin
        case FormatDefStr[2] of
          'Y': begin
            case Len of
              8: begin
                Y := StrToInt(Lst[1]);
                M := StrToInt(Lst[0]);
                D := StrToInt(Lst[2]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('mm/yy/dd',Date);
              end;
              10: begin
                Y := StrToInt(Lst[1]);
                M := StrToInt(Lst[0]);
                D := StrToInt(Lst[2]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('mmmm/yy/dd',Date);
              end;
            end;
          end;
          'D': begin
            case Len of
              8: begin
                Y := StrToInt(Lst[2]);
                M := StrToInt(Lst[0]);
                D := StrToInt(Lst[1]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('mm/dd/yy',Date);
            end;
              10: begin
                Y := StrToInt(Lst[2]);
                M := StrToInt(Lst[0]);
                D := StrToInt(Lst[1]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('mm/dd/yyyy',Date);
              end;
            end;
          end;
        end;
      end;
      'D': begin
        case FormatDefStr[2] of
          'Y': begin
            case Len of
              8: begin
                Y := StrToInt(Lst[1]);
                M := StrToInt(Lst[2]);
                D := StrToInt(Lst[0]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('dd/yy/mm',Date);
              end;
              10: begin
                Y := StrToInt(Lst[1]);
                M := StrToInt(Lst[2]);
                D := StrToInt(Lst[0]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('dd/yyyy/mm',Date);
              end;
            end;
          end;
          'M': begin
            case Len of
              8: begin
                Y := StrToInt(Lst[2]);
                M := StrToInt(Lst[1]);
                D := StrToInt(Lst[0]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('dd/mm/yy',Date);
              end;
              10: begin
                Y := StrToInt(Lst[2]);
                M := StrToInt(Lst[1]);
                D := StrToInt(Lst[0]);
                Y := Compute2DigitYear(Y);
                Date := EncodeDate(Y,M,D);
                Result := FormatDateTime('dd/mm/yyyy',Date);
              end;
            end;
          end;
        end;
      end;
    end;
  end;

var
  S: STring;
begin
  if Trim(DateStr)='' then Exit;
  Lst := TStringLIst.Create;
  try
  try
    if StringHasDelimiters(DateStr,S) then
      ParseFields(['/','.','-'],[' ',#9],PChar(DateStr),Lst,False)
    else
      SplitRawDate(DateStr,FormatDefStr,Lst);
    SynthesizeDate(Result,FormatDefStr,Lst);
  finally
    Lst.Free;
  end;
  except
    raise Exception.Create('Invalid date');
  end;
end;



function StripChars(const S: String; Strip: CharSet): String;
var
  I,
  TargetIndex,
  L: Integer;
begin
  Result := Copy(S,1,MaxInt); // Forces a new string allocation!
  if S = EmptyStr then
    Exit;
  L := Length(S) - 1;
  I := 0;
  TargetIndex := 0;
  while True do begin
    if not (PChar(Result)[I] in Strip) then begin
      PChar(Result)[TargetIndex] := PChar(Result)[I];
      Inc(TargetIndex);
    end;
    Inc(I);
    if I > L then begin
      Break;
    end;
  end;
  SetLength(Result,TargetIndex);
end;



function ContainsChars(const S: String; Strip: CharSet): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(S) do begin
    if S[I] in Strip then begin
      Result := True;
      Break;
    end;
  end;
end;


function TrimChars(const S: string; Chars: CharSet): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I]  in Chars) do Inc(I);
  if I > L then Result := '' else
  begin
    while S[L] in Chars do Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;


function TrimLeftChars(const S: string; Chars: CharSet): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] in Chars) do Inc(I);
  Result := Copy(S, I, Maxint);
end;


function TrimRightChars(const S: string; Chars: CharSet): string;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] in Chars) do Dec(I);
  Result := Copy(S, 1, I);
end;


procedure LeftPadStr(var S: String;
  toLength: Integer; withChar: Char);
  Begin { PadLeft }
    If Length(S) < toLength Then
      S := StringOfChar( withChar, toLength - Length(S)) + S;
  End; { PadLeft }




procedure RightPadStr(var S: String;
  toLength: Integer; withChar: Char );
  Begin { PadRight }
    If Length(S) < toLength Then
      S := S + StringOfChar( withChar, toLength - Length(S))
  End; { PadRight }



function BaseConvert(Number, FromDigits, ToDigits: String): String;
{
   """ converts a "number" between two bases of arbitrary digits

    The input number is assumed to be a string of digits from the
    fromdigits string (which is in order of smallest to largest
    digit). The return value is a string of elements from todigits
    (ordered in the same way). The input and output bases are
    determined from the lengths of the digit strings. Negative
    signs are passed through.

    decimal to binary
    >>> baseconvert(555,BASE10,BASE2)
    '1000101011'

    binary to decimal
    >>> baseconvert('1000101011',BASE2,BASE10)
    '555'

    integer interpreted as binary and converted to decimal (!)
    >>> baseconvert(1000101011,BASE2,BASE10)
    '555'

    base10 to base4
    >>> baseconvert(99,BASE10,"0123")
    '1203'

    base4 to base5 (with alphabetic digits)
    >>> baseconvert(1203,"0123","abcde")
    'dee'

    base5, alpha digits back to base 10
    >>> baseconvert('dee',"abcde",BASE10)
    '99'

    decimal to a base that uses A-Z0-9a-z for its digits
    >>> baseconvert(257938572394L,BASE10,BASE62)
    'E78Lxik'

    ..convert back
    >>> baseconvert('E78Lxik',BASE62,BASE10)
    '257938572394'

    binary to a base with words for digits (the function cannot convert this back)
    >>> baseconvert('1101',BASE2,('Zero','One'))
    'OneOneZeroOne'

    """
}

  function FloatDiv(const N, D: Extended): Extended;
  begin
    Result := Trunc(N / D);
  end;

  function FloatMod(N, M: Extended): Extended;
  var
    Temp: Extended;
  begin
    Temp := FloatDiv(N,M);
    Result := N - (Temp*M);
  end;

var
  Neg: Boolean;
  X: Extended;
  P,
  I: Integer;
  Digit: Char;
begin
  Result := '';
  if Number='' then
    Exit;
  if Number[1] = '-' then begin
    Number := Copy(Number,2,MaxInt);
    Neg := True;
  end else
    Neg := False;
  //make an integer out of the number
  X := 0;
  for I := 1 to Length(Number) do begin
    Digit := Number[I];
    P := Pos(Digit,FromDigits)-1;
    X := X*Length(FromDigits) + P;
  end;
  //create the result in base 'len(todigits)'
  Result := '';
  while X > 0 do begin
    I := Trunc(FloatMod(X,Length(ToDigits)));
    Result := ToDigits[Succ(I)] + Result;
    X := FloatDiv(X , Length(ToDigits));
  end;
  if Neg then
    Result := '-' + Result;
end;


function DomainOfEMail(const EMailAddress: String): String;
var
  P: Integer;
begin
  Result := '';
  P := Pos('@',EMailAddress);
  if P > 0 then
    Result := Copy(EMailAddress,P+1,Length(EMailAddress)-P);
end;




function IPToHexIP(const IP: String): String;
{
Converts an IP address in decimal dot notation, e.g. 127.0.0.1 to hexadecimal
number, e.g.
}
var
  NIP: Integer;
  L, I, J: Integer;
  S: String;
  Shift: Integer;
begin
  NIP := 0;
  I := 1;
  L := Length(IP);
  Shift := 24;
  while I < Succ(L) do begin
    J := I;
    while IP[J] in ['0'..'9'] do Inc(J);
    S := Copy(IP,I,J-I);
    NIP := NIP + StrToIntDef(S,0) shl Shift;
    I := J + 1;
    Shift := Shift - 8;
  end;
  Result := Format('%.8x',[NIP])
end;



procedure CmdLineToStrings(S: AnsiString; const List: TStrings);
var
  Head, Tail: PChar;
  EOS, InQuote, LeadQuote: Boolean;
  QuoteChar: Char;
  Temp: Char;
begin
  if (S = '') then
    Exit;
  Tail := PChar(S);
  InQuote := False;
  QuoteChar := #0;
  repeat
    while Tail^ in [' '] do
      Inc(Tail);
    Head := Tail;
    LeadQuote := False;
    while True do begin
      while (InQuote and (Tail^ <> '"')) or
        not (Tail^ in [' ', #0, #13, #10, '"']) do Inc(Tail);
      if Tail^ = '"' then  begin
        if (QuoteChar <> #0) and (QuoteChar = Tail^) then
          QuoteChar := #0
        else begin
          LeadQuote := Head = Tail;
          QuoteChar := Tail^;
          if LeadQuote then Inc(Head);
        end;
        InQuote := QuoteChar <> #0;
        if InQuote then
          Inc(Tail)
        else Break;
      end else Break;
    end;
    if not LeadQuote and (Tail^ <> #0) and (Tail^ = '"') then
      Inc(Tail);
    EOS := Tail^ = #0;
    if Head^ <> #0 then begin
      Temp := Tail^;
      Tail^ := #0;
      List.Add(  Head  );
      Tail^ := Temp;
    end;
    Inc(Tail);
  until EOS;
end;


function DequotedStr(const S: String; AQuoteChar: Char): String;
  begin
    if S = '""' then
      Result := ''
    else begin
      Result := StringReplace(S,AQuoteChar+AQuoteChar,#7,[rfReplaceAll]);
      Result := StringReplace(Result,AQuoteChar,'',[rfReplaceAll]);
      Result := StringReplace(Result,#7,AQuoteChar,[rfReplaceAll]);
    end;
  end;



end.





