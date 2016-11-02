UNIT REXX;

  {Copyright (C) 1989-1992, 1995-1997. Earl F. Glynn, Overland Park, KS.
   All Rights Reserved.  This UNIT may be freely distributed only
   for non-commercial use.
   #sign:Max: MAXBOX10: 18/05/2016 10:28:20 

   REXX-like functions.  For information about REXX see the book
   "The REXX Language," by M.F. Cowlishaw, Prentice-Hall, 1985,
   or various IBM CMS or OS/2 manuals.


   Pascal/Delphi functions with similar REXX functions:
     ABS,
     LENGTH,
     MAX,
     MIN,
     POS (similar to FIND or INDEX)
     COPY (similar to SUBSTR)
     TRUNC

   REXX functions with Pascal/Delphi equivalents:
     Format, BitAnd, BitOr, Compare, Random, Insert
     REXX DATE and TIME can be simulated with the FormatDateTime function.
     REXX DelStr is equivalent to Delete in Delphi

   Delphi functions that work similar to existing REXX functions:
     Trim <-> Strip

   REXX functions to be considered for future development:
     Justify, LastPos, Verify

   The Date and Time functions provided by REXX can be replaced with
   a variety of Delphi functions, in particular, EncodeDate, DecodeDate,
   DateToStr, FormatDateTime, etc.

   Instead of REXX functions "Word", "WordIndex" and "WordLength",
   see Tokens Unit.
  }


INTERFACE

  {USES
    SysUtils;  {Exception, AppendStr}
   
 (* TYPE
    TState = (TrimLeader, StartToken, EndToken);   {States of finite state machine}
{$IFDEF WIN32}
    TStrIndex = LongInt;
    TTokIndex = WORD;
{$ELSE}
    TStrIndex = BYTE;
    TTokIndex = BYTE;
{$ENDIF}
    EConversionError = CLASS(Exception);
   *)

  {STRING-related FUNCTIONs}
  FUNCTION  Abbrev(CONST information,info:  STRING; CONST nMatch:  TStrIndex):  BOOLEAN;
  FUNCTION  AllSame(CONST s:  STRING; CONST c:  CHAR):  BOOLEAN;

  FUNCTION  Capitalize (CONST s:  STRING):  STRING;

  FUNCTION  Center(CONST s:  STRING; CONST sLength:  TStrIndex):  STRING;
  FUNCTION  Left(CONST s:  STRING; CONST sLength:  TStrIndex):  STRING;
  FUNCTION  Right(CONST s:  STRING; CONST sLength:  TStrIndex):  STRING;

  FUNCTION  Copies(CONST s:  STRING; CONST n:  TStrIndex):  STRING;
  FUNCTION  CountChar(CONST s:  STRING; CONST c:  CHAR):  TStrIndex;
  FUNCTION  DeleteString(CONST substring:  STRING; CONST s:  STRING):  STRING;
  FUNCTION  Overlay(CONST ovly,target:  STRING; CONST n:  TStrIndex):  STRING;
  FUNCTION  Plural(CONST n:  LongInt; CONST singularform,pluralform:  STRING):  STRING;
  FUNCTION  Reverse(CONST s:  STRING):  STRING;
  FUNCTION  Spacerexx(CONST s:  STRING; CONST n:  TStrIndex):  STRING;
  FUNCTION  Strip(CONST s:  STRING; CONST option:  STRING):  STRING;
  FUNCTION  TestString(CONST sLength:  TStrIndex):  STRING;
  FUNCTION  Translate(CONST s,OutTable,InTable:  STRING):  STRING;
  FUNCTION  XRange (CONST start,stop:  BYTE):  STRING;


  {Conversion FUNCTIONs -- many have new Delphi equivalents}
  FUNCTION  B2X(CONST b:  BYTE):  STRING;          {byte-to-hexadecimal}

  FUNCTION  C2D(CONST s:  STRING):  DOUBLE;        {character-to-double}
  FUNCTION  C2I(CONST s:  STRING):  INTEGER;       {character-to-integer}
  FUNCTION  C2L(CONST s:  STRING):  LONGINT;       {character-to-longint}
  FUNCTION  C2W(CONST s:  STRING):  WORD;          {character-to-word}
  FUNCTION  C2X(CONST s:  STRING):  STRING;        {character-to-hexadecimal}

  FUNCTION  I2C(CONST i:  INTEGER):  STRING;       {integer-to-character}
  FUNCTION  I2X(CONST i:  INTEGER):  STRING;       {integer-to-hexadecimal}

  FUNCTION  L2C(CONST i:  LONGINT):  STRING;       {longint-to-character}
  FUNCTION  L2X(CONST i:  LONGINT):  STRING;       {longint-to-hexadecimal}

  FUNCTION  D2C(CONST x:  DOUBLE; CONST d:  BYTE):  STRING; {double-to-character}

  FUNCTION  W2C(CONST w:  WORD):  STRING;          {word-to-character}
  FUNCTION  W2X(CONST w:  WORD):  STRING;          {word-to-hexadecimal}

  FUNCTION  X2W(CONST s:  STRING):  WORD;          {hexadecimal-to-word}


  {Date/Time FUNCTIONs}
  FUNCTION JulianDate(CONST DateTime:  TDateTime):  LongInt;
  FUNCTION TimeDifference(CONST StartTime, StopTime:  TDateTime):  DOUBLE;


  {Math FUNCTION}
  FUNCTION  Pwr(CONST x,y:  DOUBLE):  DOUBLE;



IMPLEMENTATION


  {**  STRING-related FUNCTIONs  **************************************}

  FUNCTION Abbrev(CONST information,info:  STRING; CONST nMatch:  TStrIndex):  BOOLEAN;
    VAR
      i          :  TStrIndex;
      match      :  BOOLEAN;
      matchlength:  TStrIndex;
  BEGIN
    match := TRUE;
    IF   LENGTH(info) < nMatch
    THEN match := FALSE
    ELSE BEGIN
      i := 1;
      matchlength := nMatch;
      IF   LENGTH(info) > nMatch
      THEN matchlength := LENGTH(info);
      IF   matchlength >  LENGTH(information)
      THEN matchlength := LENGTH(information);
      WHILE (i <= matchlength) AND match
      DO BEGIN
        match :=  (information[i] = info[i]);
        INC (i)
      END
    END;
    RESULT := match
  END {Abbrev};


  FUNCTION AllSame(CONST s:  STRING; CONST c:  CHAR):  BOOLEAN;
    VAR
      i:  INTEGER;
  BEGIN
    RESULT := TRUE;
    i := 1;
    WHILE RESULT AND (i <= LENGTH(s))
    DO BEGIN
      RESULT := RESULT AND (s[i] = c);
      INC (i)
    END
  END {AllSame};


  FUNCTION Capitalize (CONST s:  STRING):  STRING;
    VAR
      flag:  BOOLEAN;
      i   :  TStrIndex;
      t   :  STRING;
  BEGIN
    flag := TRUE;
    t := '';
    FOR i := 1 TO LENGTH(s) DO
    BEGIN
      IF   flag
      THEN AppendStr(t,  UpCase(s[i]))
      ELSE AppendStr(t,  s[i]);
      flag := (s[i] = ' ')
    END;
    RESULT := t
  END {Capitalize};


  FUNCTION Center(CONST s:  STRING; CONST sLength:  TStrIndex):  STRING;
    VAR
      LeftBlanks :  TStrIndex;
      RightBlanks:  TStrIndex;
  BEGIN
    IF   sLength <= 0
    THEN RESULT := ''
    ELSE
      IF   LENGTH(s) >= sLength
      THEN RESULT := Copy(s, LENGTH(s) DIV 2 - (sLength-1) DIV 2, sLength)
      ELSE BEGIN
        LeftBlanks := (sLength - LENGTH(s)) DIV 2;
        RightBlanks := sLength - LeftBlanks - LENGTH(s);
        RESULT := Copies(' ',LeftBlanks) + s + Copies(' ',RightBlanks)
      END
  END {Center};


  FUNCTION Left(CONST s:  STRING; CONST sLength:  TStrIndex):  STRING;
  BEGIN
    IF   sLength <= 0
    THEN RESULT := ''
    ELSE
      IF   LENGTH(s) >= sLength
      THEN RESULT := Copy(s,1,sLength)
      ELSE RESULT := s + Copies(' ',sLength-LENGTH(s))
  END {Left};


  FUNCTION Right(CONST s:  STRING; CONST sLength:  TStrIndex):  STRING;
  BEGIN
    IF   sLength <= 0
    THEN RESULT := ''
    ELSE
      IF   LENGTH(s) >= sLength
      THEN RESULT := Copy(s, LENGTH(s)-sLength+1, sLength)
      ELSE RESULT := Copies(' ', sLength-LENGTH(s)) + s
  END {Right};


  FUNCTION Copies(CONST s:  STRING; CONST n:  TStrIndex):  STRING;
    VAR
      i:  TStrIndex;
      t:  STRING;
  BEGIN
    t := '';
    FOR i := 1 TO n DO
      AppendStr(t,  s);
    RESULT := t
  END {Copies};


  FUNCTION  CountChar(CONST s:  STRING; CONST c:  CHAR):  TStrIndex;
    VAR
      i:  TStrIndex;
  BEGIN
    RESULT := 0;
    FOR i := 1 TO LENGTH(s) DO
      IF  s[i] = c
      THEN INC(RESULT)
  END {CountChar};


  { DeleteString is NOT like the original REXX DelStr function.  DeleteString
    deletes a given string, if present.  To delete a word from a sentence, add
    a blank to the beginning and end of the strings:  e.g.,

         DeleteString(' Bill ', ' Bill Preston Earl ')
  }
  FUNCTION  DeleteString(CONST substring:  STRING; CONST s:  STRING):  STRING;
    VAR
      i:  TStrIndex;
      t:  STRING;
  BEGIN
    t := s;
    i := POS(substring, t);

    IF   i > 0
    THEN Delete(t, i, LENGTH(substring));

    RESULT := t
  END {DeleteString};


  FUNCTION Overlay(CONST ovly,target:  STRING; CONST n:  TStrIndex):  STRING;
    VAR
      i      :  TStrIndex;
      sLength:  TStrIndex;
      t      :  STRING;
  BEGIN
    sLength := LENGTH(Target);
    IF   n+LENGTH(ovly)-1 > sLength
    THEN sLength := n+LENGTH(ovly)-1;
    t := Left(target,sLength);
    FOR i := 1 TO LENGTH(ovly) DO
      t[n+i-1] := ovly[i];
    RESULT := t
  END {Overlay};


  FUNCTION Plural(CONST n:  LongInt; CONST singularform,pluralform:  STRING):  STRING;
  BEGIN  {function similar to one on p. 314, Byte, December 1988}
    IF   n = 1
    THEN RESULT := singularform
    ELSE
      IF   pluralform = ''
      THEN RESULT := singularform + 's'
      ELSE RESULT := pluralform
  END {Plural};


  FUNCTION Reverse(CONST s:  STRING):  STRING;
    VAR
      i:  TStrIndex;
      j:  TStrIndex;
      t:  STRING;
  BEGIN
    t := '';
    j := LENGTH(s)+1;
    FOR i := 1 TO LENGTH(s) DO
      AppendStr(t, s[j-i]);
    RESULT := t
  END {Reverse};


  FUNCTION Spacerexx(CONST s:  STRING; CONST n:  TStrIndex):  STRING;
    VAR
      i    :  TStrIndex;
      state:  byte; //0..2;  {state of finite state machine}
      t    :  STRING;
  BEGIN
    t := '';
    state := 0;
    FOR i := 1 TO LENGTH(s) DO
      CASE state OF
        0:  IF   s[i] <> ' '
            THEN BEGIN
              state := 1;
              AppendStr(t, s[i])
            END;
        1:  IF   s[i] = ' '
            THEN state := 2
            ELSE AppendStr(t, s[i]);
        2:  IF   s[i] <> ' '
            THEN BEGIN
              state := 1;
              AppendStr(t, Copies(' ',n) + s[i])
            END
      END;
    RESULT := t
  END {Space};


  FUNCTION Strip(CONST s:  STRING; CONST option:  STRING):  STRING;
    VAR
      c:  CHAR;
      i:  TStrIndex;
      t:  STRING;
  BEGIN
    t := s;
    IF   LENGTH(option) > 0
    THEN c := UpCase(option[1])
    ELSE c := 'B';
    IF   (c <> 'L') AND (c <> 'T')
    THEN c := 'B';

    IF   ((c = 'L') OR (c = 'B')) AND (LENGTH(t) > 0)  {Leading or Both}
    THEN BEGIN
      i := 1;
      WHILE (t[i] = ' ') AND (i <= LENGTH(t)) DO
        i := i + 1;
      t := COPY(t,i,LENGTH(t)+1-i)
    END;

    IF   ((c = 'T') OR (c = 'B')) AND (LENGTH(t) > 0)  {Trailing or Both}
    THEN BEGIN
      i := LENGTH(t);
      WHILE (t[i] = ' ') AND (i >= 0) DO
        i := i - 1;
      t := COPY(t,1,i)
    END;

    RESULT := t
  END {Strip};


  FUNCTION  TestString(CONST sLength:  TStrIndex):  STRING;
    VAR
      i:  TStrIndex;
  BEGIN
    RESULT := '';
    FOR i := 1 TO sLength DO
      AppendStr(RESULT,  CHR(48+Random(79)))
  END {TestString};


  FUNCTION Translate(CONST s,OutTable,InTable:  STRING):  STRING;
    VAR
      Flag :  ARRAY[0..255] OF BOOLEAN;
      i,j,n:  TStrIndex;
      t    :  STRING;
      Table:  ARRAY[0..255] OF CHAR;
  BEGIN
    FOR i := 0 TO 255 DO BEGIN
      Table[i] := CHR(i);
      Flag[i] := TRUE
    END;
    IF   LENGTH(OutTable) < LENGTH(InTable)
    THEN BEGIN
      FOR i := LENGTH(OutTable) + 1 TO LENGTH(InTable) DO
        Flag[ORD(InTable[i])] := FALSE;
      n := LENGTH(OutTable)
    END
    ELSE n := LENGTH(InTable);
    FOR i := 1 TO n DO
      Table[ORD(InTable[i])] := OutTable[i];
    t := '';
    FOR i := 1 TO LENGTH(s) DO BEGIN
      j := ORD(s[i]);
      IF   Flag[j]
      THEN AppendStr(t, Table[j]);
    END;
    RESULT := t
  END {Translate};


  FUNCTION XRange (CONST start,stop:  BYTE):  STRING;
    VAR
      i:  BYTE;
      t:  STRING;
  BEGIN
    t := '';
    IF   stop >= start
    THEN BEGIN
      FOR i := start TO stop DO
        AppendStr(t,  CHR(i))
    END
    ELSE BEGIN
      FOR i := start TO $FF DO
        t := t + CHR(i);
      FOR i := $00  TO stop DO
        AppendStr(t,  CHR(i))
    END;
    RESULT := t
  END {XRange};

  {**  Conversion FUNCTIONs *******************************************}

    //CONST HexDigit:  ARRAY[0..15] OF CHAR = '0123456789ABCDEF';

  FUNCTION B2X(CONST b:  BYTE):  STRING;  {byte-to-hexadecimal}
  BEGIN
    RESULT :=  HexDigits[b SHR 4] + HexDigits[b AND $0F]
  END {B2X};


  FUNCTION C2D(CONST s:  STRING):  DOUBLE;    {character-to-double}
    VAR
      ConvertError:  INTEGER;
      x           :  DOUBLE;
  BEGIN
    //VAL (Strip(s,'T'), x, ConvertError);

    IF   ConvertError = 0
    THEN RESULT := x
    ELSE BEGIN
      RAISE; //EConversionError.Create('REXX C2D Conversion Error');
      RESULT := 0.0
    END
  END {C2D};


  FUNCTION C2I(CONST s:  STRING):  INTEGER; {character-to-integer}
    VAR
      ConvertError:  INTEGER;
      i           :  LONGINT;
  BEGIN
    VAL (Strip(s,'T'), i, ConvertError);
    IF   (ConvertError = 0) AND (i >= -32768) AND (i <= 32767)
    THEN RESULT := INTEGER(i)
    ELSE BEGIN
      IF   ConvertError  = 0
      THEN RAISE //EConversionError.Create('REXX C2I Range Error')
      ELSE RAISE; //EConversionError.Create('REXX C2I Conversion Error');
      RESULT := 0
    END
  END {C2I};


  FUNCTION C2L(CONST s:  STRING):  LONGINT; {character-to-LONGINT}
    VAR
      ConvertError:  INTEGER;
      i           :  LONGINT;
  BEGIN
    VAL (Strip(s,'T'), i, ConvertError);
    IF   ConvertError = 0
    THEN RESULT := i
    ELSE BEGIN
      RAISE; //EConversionError.Create('REXX C2L Conversion Error');
      RESULT := 0
    END
  END {C2I};


  FUNCTION C2W(CONST s:  STRING):  WORD;    {character-to-word}
    VAR
      ConvertError:  INTEGER;
      i           :  LONGINT;
  BEGIN
    VAL (Strip(s,'T'), i, ConvertError);
    IF   (ConvertError = 0) AND (i >= 0) AND (i <= 65535)
    THEN RESULT := WORD(i)
    ELSE BEGIN
      IF   ConvertError  = 0
      THEN RAISE //EConversionError.Create('REXX C2W Range Error')
      ELSE RAISE; //EConversionError.Create('REXX C2W Conversion Error');
      RESULT := 0
    END
  END {C2W};


  FUNCTION C2X(CONST s:  STRING):  STRING;  {character-to-hexadecimal}
    VAR
      i:  BYTE;
      t:  STRING;
  BEGIN
    t := '';
    FOR i := 1 TO LENGTH(s) DO
    BEGIN
      AppendStr(t, B2X( ord(s[i]) ));
    END;
    RESULT := t
  END {C2X};


  FUNCTION I2C(CONST i:  INTEGER):  STRING;           {integer-to-character}
    {I2C and W2C are replacements for the standard D2C (decimal-to-
     character) function.  However, the standard D2C works like the
     Pascal CHR function.  Here, I2C is written to be the inverse
     of the C2I function.}

    VAR
      t:  STRING;
  BEGIN
    STR (i,t);                           {STR is Turbo Pascal Procedure}
    RESULT := t
  END {I2C};


  FUNCTION I2X(CONST i:  INTEGER):  STRING;           {integer-to-hexadecimal}
  BEGIN
    RESULT := B2X(Hi(i)) + B2X(Lo(i))
  END {I2X};


  FUNCTION L2C(CONST i:  LONGINT):  STRING;  {LONGINT-to-character}
    VAR
      t:  STRING;
  BEGIN
    STR (i,t);                         {STR is Turbo Pascal Procedure}
    RESULT := t
  END {L2C};


  FUNCTION L2X(CONST i:  LONGINT):  STRING;  {LONGINT-to-hexadecimal}
    {VAR
      ovly:
         RECORD
          CASE INTEGER OF
            0:  (j:  LONGINT);
            1:  (w:  ARRAY[1..2] OF WORD)
        END;}
       { RECORD
          CASE INTEGER OF
            0:  (j:  LONGINT);
            1:  (w:  ARRAY[1..2] OF WORD)
        END;}
  BEGIN
    //ovly.j := i;
    //RESULT := W2X(ovly.w[1]) + W2X(ovly.w[2])
  END {L2X};


  FUNCTION D2C(CONST x:  DOUBLE; CONST d:  BYTE):  STRING;
    VAR
      t:  STRING;
  BEGIN
    //STR(x:30:d,t);  {'d' digits after decimal point}
    RESULT := Strip(t,'L')
  END {R2C};


  FUNCTION W2C(CONST w:  WORD):  STRING;              {word-to-character}
    {W2C and I2C are replacements for the standard D2C (decimal-to-
     character) function.  However, the standard D2C works like the
     Pascal CHR function.  Here, W2C is written to be the inverse
     of the C2W function.}

    VAR
      t:  STRING;
  BEGIN
    STR (w,t);                           {STR is Turbo Pascal Procedure}
    RESULT := t
  END {W2C};


  FUNCTION W2X(CONST w:  WORD):  STRING;          {word-to-hexadecimal}
  BEGIN
    RESULT := B2X(Hi(w)) + B2X(Lo(w))
  END {W2X};


  FUNCTION X2W(CONST s:  STRING):  WORD;  {hex string to Pascal WORD}
    //CONST HexDigits:  STRING = '0123456789ABCDEF';
    VAR
      i    :  WORD;
      digit:  WORD;
      sum  :  WORD;
      power:  WORD;
  BEGIN
    power := 1;
    sum := 0;
    FOR i := 1 TO LENGTH(s) DO BEGIN
      digit := POS(s[LENGTH(s)+1-i],HexDigits) - 1;
      sum := sum + digit*power;
      power := 16*power;
    END;
    RESULT := sum
  END {X2W};


  {**  Date/Time FUNCTIONS ********************************************}

  FUNCTION JulianDate(CONST DateTime:  TDateTime):  LongInt;
    VAR
      day     :  WORD;
      month   :  WORD;
      NewYears:  TDateTime;
      Start   :  LongInt;
      Stop    :  LongInt;
      year    :  WORD;
  BEGIN
    DecodeDate (DateTime, year, month, day);
    NewYears := EncodeDate (year, 1, 1);
    Stop   := Trunc(DateTime);
    Start  := Trunc(NewYears);
    RESULT := Stop - Start + 1;
  END {JulianDate};


  FUNCTION  TimeDifference(CONST StartTime, StopTime:  TDateTime):  DOUBLE;
  BEGIN
    RESULT := 86400.0*(StopTime - StartTime);     {Seconds}
  END {TimeDifference};


  {**  Math FUNCTION  *************************************************}

  FUNCTION Pwr(CONST x,y:  DOUBLE):  DOUBLE;  {x^y or x**y -- x raised to power y}
  BEGIN
    IF   (x = 0.0) AND (y = 0.0)
    THEN RESULT := 1
    ELSE RESULT := EXP( y * LN(x) )    {LN(x) is undefined for x <= 0.0}
  END {Pwr};                           {a run-time error will occur}


INITIALIZATION
END.
