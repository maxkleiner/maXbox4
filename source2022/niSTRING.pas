{: String Utility Routines }
unit niSTRING;

interface

uses SysUtils, Classes, niTestCase;

type

// =============================================================================================
// Type: TCharset
// ==============

TCharset = set of char;

// ==============================================================================================
// Exception: EniStringError
// =========================

{: Exception class for errors in these string routines }
EniStringError = class( Exception);

// ==============================================================================================
// String Slicing Routines
// =======================

{: Find the position of the first delimiter in a string.
   @param sString String to search
   @param sDelimiters String of character delimiters for which to search
   @returns Position within string of the first delimiter }
function DelimiterPosn( const sString: string; const sDelimiters: string): integer; overload;

{: Find the position of the first delimiter in a string.
   @param sString String to search
   @param sDelimiters String of character delimiters for which to search
   @param cDelimiter Delimiter found (if any)
   @returns Position within string of the first delimiter, if found; zero if not }
function DelimiterPosn( const sString: string; const sDelimiters: string;
                        out cDelimiter: char): integer; overload;

{: Return the portion of a string prior to the first of a number of possible delimiters. If a
   delimiter is found at the start of the string, this will return a nil string. If no delimiters
   of any kind are found, the entire string will be returned.
   @param sString String to slice
   @param sDelmiiters String of character delimiters for which to search
   @returns The portion of sString up to, but not including, the delimiter found }
function StrBefore( const sString: string; const sDelimiters: string): string; overload;

{: Return the portion of a string prior to the first of a number of possible delimiters. If a
   delimiter is found at the start of the string, this will return a nil string. If no delimiters
   of any kind are found, the entire string will be returned and cDelimiter will be undefined.
   @param sString String to slice
   @param sDelimiters String of character delimiters for which to search
   @param cDelimiter Delimiter used (if any)
   @returns The portion of sString up to, but not including, the delimiter found. }
function StrBefore( const sString: string; const sDelimiters: string;
                    out cDelimiter: char): string; overload;

{: Return the portion of a string after the first of a number of possible delimiters. If a
   delimiter is found at the start of the string, this will return the string less that character.
   If no delimiters of any kind are found, an empty string will be returned.
   @param sString String to slice
   @param sDelimiters Delimiter used (if any)
   @returns The portion of the string after, but not including, the delimiter found.}
function StrAfter( const sString: string; const sDelimiters: string): string; overload;

{: Return the portion of a string after the first of a number of possible delimiters. If a
   delimiter is found at the start of the string, this will return the string less that character.
   If no delimiters of any kind are found, an empty string will be returned.
   @param sString String to slice
   @param sDelimiters String of character delimiters for which to search
   @param cDelimiter Delimiter used (if any)
   @returns The portion of the string after, but not including, the delimiter found.}
function StrAfter( const sString: string; const sDelimiters: string;
                   out cDelimiter: char): string; overload;

{: Return the portion of a string before the first of a number of possible delimiters, removing
   that string from the original string. If a delmiter is found at the start of the string, this
   will return a nil string and remove the delimiter. If no delimiters of any kind are found, the
   entire string will be returned, the original string will be empty and cDelimiter will be #0.
   @param sString String to slice
   @param sDelimiters String of character delimiters for which to search
   @param cDelimiter Delimiter used (if any)
   @returns The portion of sString up to, but not including, the delimiter found. }
function StrParse( var sString: string; const sDelimiters: string): string; overload;

{: Return the portion of a string before the first of a number of possible delimiters, removing
   that string from the original string. If a delmiter is found at the start of the string, this
   will return a nil string and remove the delimiter. If no delimiters of any kind are found, the
   entire string will be returned, the original string will be empty and cDelimiter will be #0.
   @param sString String to slice
   @param sDelimiters String of character delimiters for which to search
   @param cDelimiter Delimiter used (if any)
   @returns The portion of sString up to, but not including, the delimiter found. }
function StrParse( var sString: string; const sDelimiters: string;
                   out cDelimiter: char): string; overload;

{: Return a string generated by filtering only valid characters out of an original
   @param sString Original String
   @param xValidChars Set of valid characters to include
   @returns Copy of sString with all invalid characters removed }
function StrFilter( const sString: string; xValidChars: TCharSet): string;

{: Check to see if a string begins with another string
   @param sString Original String
   @param sPrefix Possible Prefix
   @returns True if sString starts with sPrefix }
function StrHasPrefix( const sString: string; const sPrefix: string): boolean;

{: Return a string less a possible prefix
   @param sString Original string
   @param sPrefix Possible Prefix
   @return String without prefix}
function StrLessPrefix( const sString: string; const sPrefix: string): string;

{: Check to see if a string ends with another string
   @param sString Original String
   @param sSuffix Possible Suffix
   @returns True if sString ends with sSuffix }
function StrHasSuffix( const sString: string; const sSuffix: string): boolean;

{: Return a string less a possible suffix
   @param sString Original string
   @param sSuffix Possible suffix
   @returns String without suffix }
function StrLessSuffix( const sString: string; const sSuffix: string): string;

// ==============================================================================================
// Conditional String Routines
// ===========================

{: Return one string if a condition is true, the other string if it is not.
   @param bCondition Condition to check
   @param sTrue String to return for true
   @param sFalse String to return for false
   @returns sTrue if bCondition; sFalse otherwise }
function IfStr( const bCondition: boolean; const sTrue: string; const sFalse: string): string;

{: Check to see if a string is empty.
   @param sString String to test
   @returns True if sString is empty or contains only whitespace, false otherwise }
function StrEmpty( const sString: string): boolean;

{: Add a term to a string, adding a separating string if needed
   @param sString String being built up
   @param sTerm New string to add
   @param sSeparator Separating string to use if needed }
procedure AddStringTerm( var sString: string; const sTerm: string; const sSeparator: string);

{: Return a correctly formatted count
   @param iCount Count to format
   @param sSingular Phrase for one
   @param sPlural Phrase for many }
function FormatCount( iCount: integer; const sSingular: string; const sPlural: string): string;

// ==============================================================================================
// String Formatting Routines
// ==========================

{: Pad a string on the right with another string to make it a particular length. If the string
   is already too long, extra characters are truncated. The string returned will be exactly
   iLength in length.
   @param sString String to pad
   @param sPad String to pad with
   @param iLength Target Length
   @returns sString with as many repetitions of sPad as required to meet iLength. }
function StrPad( const sString: string; const sPad: string; const iLength: integer): string;

type

// ==============================================================================================
// Test Case: TniTestSTRING
// ========================

TniTestSTRING = class( TniTestCase)
protected

  {: Run actual tests for this case.
     Do all of the actions required for the test. }
  procedure RunTest; override;

end;

// ==============================================================================================

const
  csEOLN = #13#10;

implementation

// ==============================================================================================
// String Slicing Routines
// =======================

function DelimiterPosn( const sString: string; const sDelimiters: string): integer;
var
  cDelimiter: char;
begin
  Result := DelimiterPosn( sString, sDelimiters, cDelimiter);
end;

function DelimiterPosn( const sString: string; const sDelimiters: string;
                        out cDelimiter: char): integer; overload;
var
  iScan: integer;
  iPos:  integer;
begin
  Result := 0;
  cDelimiter := #0;
  for iScan := 1 to Length( sDelimiters) do begin
    iPos := Pos( sDelimiters[iScan], sString);
    if (iPos>0) and ( (iPos<Result) or (Result=0) ) then begin
      Result := iPos;
      cDelimiter := sDelimiters[iScan];
    end;
  end;
end;

function StrBefore( const sString: string; const sDelimiters: string): string;
var
  cDelimiter: char;
begin
  Result := StrBefore( sString, sDelimiters, cDelimiter);
end;

function StrBefore( const sString: string; const sDelimiters: string;
                    out cDelimiter: char): string;
var
  iDelimiter: integer;
begin
  iDelimiter := DelimiterPosn( sString, sDelimiters, cDelimiter);
  if iDelimiter = 0 then
    Result := sString
  else Result := Copy( sString, 1, iDelimiter-1);
end;

function StrAfter( const sString: string; const sDelimiters: string): string; overload;
var
  cDelimiter: char;
begin
  Result := StrAfter( sString, sDelimiters, cDelimiter);
end;

function StrAfter( const sString: string; const sDelimiters: string;
                   out cDelimiter: char): string; overload;
var
  iDelimiter: integer;
begin
  iDelimiter := DelimiterPosn( sString, sDelimiters, cDelimiter);
  if iDelimiter = 0 then
    Result := ''
  else Result := Copy( sString, iDelimiter+1, Length( sString)-iDelimiter );
end;

function StrParse( var sString: string; const sDelimiters: string): string; overload;
var
  cDelimiter: char;
begin
  Result := StrParse( sString, sDelimiters, cDelimiter);
end;

function StrParse( var sString: string; const sDelimiters: string;
                   out cDelimiter: char): string; overload;
var
  iDelimiter: integer;
begin
  iDelimiter := DelimiterPosn( sString, sDelimiters, cDelimiter);
  if iDelimiter = 0 then begin
    Result := sString;
    sString := '';
  end
  else begin
    Result := Copy( sString, 1, iDelimiter-1);
    sString := Copy( sString, iDelimiter+1, Length( sString)-iDelimiter );
  end;
end;

function StrFilter( const sString: string; xValidChars: TCharSet): string;
var
  iScan: integer;
  iPosn: integer;
begin
  Result := '';
  SetLength( Result, Length( sString));
  iPosn := 0;
  for iScan := 1 to Length( sString) do
    if sString[iScan] in xValidChars then begin
      Inc( iPosn);
      Result[iPosn] := sString[iScan];
    end;
  SetLength( Result, iPosn);
end;

function StrHasPrefix( const sString: string; const sPrefix: string): boolean;
begin
  Result := StrLComp( PChar( sString), PChar(sPrefix), Length(sPrefix))=0;
end;

function StrLessPrefix( const sString: string; const sPrefix: string): string;
begin
  if StrHasPrefix( sString, sPrefix) then
    Result := Copy( sString, Length(sPrefix)+1, Length(sString))
  else Result := sString;
end;

function StrHasSuffix( const sString: string; const sSuffix: string): boolean;
var
  iSuffix: integer;
  iStart: integer;
begin
  iSuffix := Length(sSuffix);
  iStart := Length( sString) - iSuffix + 1;
  Result := StrLComp( PChar( sString)+iStart-1, PChar(sSuffix), Length(sSuffix))=0;
end;

function StrLessSuffix( const sString: string; const sSuffix: string): string;
var
  iLength: integer;
begin
  iLength := Length( sSuffix);
  if StrHasSuffix( sString, sSuffix) then
    Result := Copy( sString, 1, Length(sString)-iLength)
  else Result := sString;
end;

// ================================================================================================
// Conditional String Routines
// ===========================

function IfStr( const bCondition: boolean; const sTrue: string; const sFalse: string): string;
begin
  if bCondition then
    Result := sTrue
  else Result := sFalse;
end;

function StrEmpty( const sString: string): boolean;
begin
  Result := Trim(sString)='';
end;

procedure AddStringTerm( var sString: string; const sTerm: string; const sSeparator: string);
begin
  if StrEmpty( sString) then
    sString := sTerm
  else sString := sString + sSeparator + sTerm;
end;

function FormatCount( iCount: integer; const sSingular: string; const sPlural: string): string;
begin
  if iCount=1 then
    Result := '1 '+sSingular
  else Result := IntToStr( iCount)+' '+sPlural;
end;

// ================================================================================================
// String Formatting Routines
// ==========================

function StrPad( const sString: string; const sPad: string; const iLength: integer): string;
var
  iScan: integer;
  iCopy: integer;
begin
  Result := sString;
  iScan := Length( Result)+1;
  SetLength( Result, iLength);

  iCopy := 1;
  while iScan <= iLength do begin
    Result[iScan] := sPad[iCopy];
    iCopy := (iCopy mod Length(sPad))+1;
    Inc( iScan);
  end;
end;

// ==============================================================================================
// Test Case: TniTestSTRING
// ========================

procedure TniTestSTRING.RunTest;
begin
//**

end;


end.
