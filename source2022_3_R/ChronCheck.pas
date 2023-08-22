{ Check Chron Specifications
  Copyright (C) 1997, Earl F. Glynn, EFG Software.  All Rights Reserved.

  "Array" in this unit refers to an array of BOOLEAN flags used to determine
  whether a given time is specified.  For example, for a chMinutes object,
  an array of 0..59 flags indicates whether each of the minutes are target
  times
}

UNIT ChronCheck;

INTERFACE

  USES
    StdCtrls,   {TMemo}
    SysUtils;   {Trim}

  CONST
    MinCheckArrayIndex =  0;  { 0 minutes/hour, hours/day}
    MaxCheckArrayIndex = 59;  {59 seconds/minute}

  TYPE
    TCheck            = (chMinutes, chHours, chDays, chMonths, chWeekdays);
    TCheckIndex       = chMinutes..chWeekdays;
    TCheckArrayIndex  = MinCheckArrayIndex..MaxCheckArrayIndex;
    TCheckArraySpec   = ARRAY[TCheckIndex] OF STRING;

    TCheckArray       =
      CLASS(TObject)
        PUBLIC
          CONSTRUCTOR Create (CONST check:  TCheckIndex);
          PROCEDURE ClearArray;
          FUNCTION  CheckName:  STRING;
          FUNCTION  SetFlags (VAR specs:  STRING):  BOOLEAN;
          FUNCTION  IsFlagSet (CONST index:  TCheckArrayIndex):  BOOLEAN;
          PROCEDURE Show (VAR Memo:  TMemo);
        PRIVATE
          Check   :  TCheckIndex;
          minArray:  TCheckArrayIndex;
          maxArray:  TCheckArrayIndex;
          Valid   :  BOOLEAN;

          {Simplify by using only a single-sized array since it's small}
          Flags:  ARRAY[TCheckArrayIndex] OF BOOLEAN;
      END;

    TChron =
      CLASS(TObject)
        PUBLIC
          CONSTRUCTOR Create;
          DESTRUCTOR  Destroy;

          FUNCTION SetSpecs(VAR ArraySpec:  TCheckArraySpec):  BOOLEAN;
          FUNCTION IsMatch(CONST TargetTime:  TDateTime):  BOOLEAN;
        PRIVATE
          Checks:  ARRAY[TCheckIndex] OF TCheckArray;
      END;

IMPLEMENTATION

  USES
    Tokens;  {TToken}

  CONST
    Min :  ARRAY[TCheckIndex] OF BYTE =
           ( 0,  0,  1,  1, 1);

    Max :  ARRAY[TCheckIndex] OF BYTE =
           (59, 23, 31, 12, 7);

    Name:  ARRAY[TCheckIndex] OF STRING =
           ('Minutes', 'Hours', 'Days', 'Months', 'Weekdays');

{ -----------------------------------------------------------------}

  CONSTRUCTOR TCheckArray.Create (CONST Check:  TCheckIndex);
  BEGIN
    inherited Create;
    self.Check := Check;
    minArray := min[Check];
    maxArray := max[Check];
  END {Create};


  PROCEDURE TCheckArray.ClearArray;
    VAR
      i:  INTEGER;
  BEGIN
    FOR i := minArray TO maxArray DO
      Flags[i] := FALSE
  END {ClearArray};


  FUNCTION  TCheckArray.CheckName:  STRING;
  BEGIN
    RESULT := Name[Check]
  END {CheckLabel};


  FUNCTION TCheckArray.SetFlags (VAR specs:  STRING):  BOOLEAN;
    VAR
      i         :  INTEGER;
      position  :  INTEGER;
      number    :  INTEGER;
      numberMin :  INTEGER;
      numberMax :  INTEGER;
      spec      :  STRING;
      TokenIndex:  INTEGER;
      Tokens    :  TTokens;

    FUNCTION OutOfRange(CONST i:  INTEGER):  BOOLEAN;
    BEGIN
      RESULT := (i < minArray) OR (i > maxArray)
    END;

  BEGIN
    Valid := TRUE;
    specs := Trim(specs);

    Tokens := TTokens.Create(specs, ', ', #$00, #$00, #$00, FALSE);

    FOR TokenIndex := 1 TO Tokens.TokenCount DO
    BEGIN
      spec := Tokens.Token(TokenIndex);

      IF   spec[1] = '<'    {Ignore invalid spec}
      THEN Valid := FALSE
      ELSE BEGIN
        {Look for a dash}
        position := POS('-', spec);
        IF   position > 0
        THEN BEGIN
          IF   position = 1
          THEN BEGIN
            {Specification:  -Number}
            Delete(spec, position, 1);  {Get rid of dash}
            TRY
              number := StrToInt(spec);
              IF  OutOfRange(number)
              THEN Valid := FALSE
              ELSE
                FOR i := minArray TO number DO
                  Flags[i] := TRUE
            EXCEPT
              ON EConvertError DO
                Valid := FALSE
            END;
          END
          ELSE BEGIN
            IF   position = LENGTH(spec)
            THEN BEGIN
              {Specification:  Number-}
              Delete(spec, position, 1);  {Get rid of dash}
              TRY
                number := StrToInt(spec);
                IF  OutOfRange(number)
                THEN Valid := FALSE
                ELSE
                  FOR i := number TO maxArray DO
                    Flags[i] := TRUE
              EXCEPT
                ON EConvertError DO
                  Valid := FALSE
              END;
            END
            ELSE BEGIN
              {Specification:  NumberMin-NumberMax}
              TRY
                numberMin := StrToInt(COPY(spec,1,position-1));
                numberMax := StrToInt(COPY(spec,position+1, LENGTH(spec)-position));
                IF   OutOfRange(numberMin) OR OutOfRange(numberMax) OR
                     (numberMin > numberMax)
                THEN Valid := FALSE
                ELSE
                  FOR i := numberMin TO numberMax DO
                    Flags[i] := TRUE
              EXCEPT
                ON EConvertError DO
                  Valid := FALSE
              END
            END
          END
        END
        ELSE BEGIN
          {Look for an asterisk}
          position := POS('*', spec);
          IF   position > 0
          THEN BEGIN
            IF   LENGTH(spec) = 1
            THEN BEGIN
              FOR i := minArray TO maxArray DO
                Flags[i] := TRUE
            END
            ELSE BEGIN
              Delete(spec, position, 1);  {Get rid of asterisk}
              TRY
                number := StrToInt(spec);
                IF   OutOfRange(number)
                THEN Valid := FALSE
                ELSE
                  FOR i := 0 TO maxArray DIV number DO
                    Flags[number*i] := TRUE
              EXCEPT
                ON EConvertError DO
                  Valid := FALSE
              END
            END
          END
          ELSE BEGIN
            {Specification:  number}
            TRY
              number := StrToInt(spec);
              IF   OutOfRange(number)
              THEN Valid := FALSE
              ELSE Flags[number] := TRUE
            EXCEPT
              ON EConvertError DO
                Valid := FALSE
            END;
          END
        END;

        IF   NOT Valid
        THEN specs := '<' + specs + '>';

      END

    END;
    Tokens.Free;

    RESULT := Valid
  END {SetFlags};


  {Application must guarantee that index is never out of range}
  FUNCTION TCheckArray.IsFlagSet(CONST index:  TCheckArrayIndex):  BOOLEAN;
  BEGIN
    IF Valid
    THEN RESULT := Flags[index]
    ELSE RESULT := FALSE
  END {IsFlagSet};


  PROCEDURE TCheckArray.Show (VAR Memo:  TMemo);
    VAR
      i:  INTEGER;
      s:  STRING;
  BEGIN
    Memo.Lines.Add ('  Min:  ' + IntToStr(MinArray) +
                    '  Max:  ' + IntToStr(MaxArray));

    s := '';
    {Expose set flags for test purposes}
    FOR i := minArray TO maxArray DO
      IF   Flags[i]
      THEN AppendStr(s, IntToStr(i) + ' ');
    Memo.Lines.Add (s)
  END {Show};

{ -----------------------------------------------------------------}

  CONSTRUCTOR TChron.Create;
    VAR
      i:  TCheckIndex;
  BEGIN
    inherited Create;
    FOR i := Low(TCheckIndex) TO High(TCheckIndex) DO
      Checks[i] := TCheckArray.Create(i)
  END {Create};


  DESTRUCTOR TChron.Destroy;
    VAR
      i: TCheckIndex;
  BEGIN
    FOR i := High(TCheckIndex) DOWNTO Low(TCheckIndex) DO
      Checks[i].Free;
    inherited Destroy;
  END {Create};


  FUNCTION TChron.SetSpecs(VAR ArraySpec:  TCheckArraySpec):  BOOLEAN;
    VAR
      i :  TCheckIndex;
      OK:  BOOLEAN;
  BEGIN
    RESULT := TRUE;
    {Do not attempt to short-circuit if a SetFlags fails.  This routine
     is expected to check all specs and return to calling program with
     invalid specs as '<spec>'}
    FOR i := Low(TCheckIndex) TO High(TCheckIndex) DO
    BEGIN
      Checks[i].ClearArray;
      OK := Checks[i].SetFlags( ArraySpec[i] );
      RESULT := RESULT AND OK;
    END
  END {CheckSpecs};


  FUNCTION TChron.IsMatch(CONST TargetTime:  TDateTime):  BOOLEAN;
    VAR
      i        :  TCheckIndex;
      Year     :  WORD;   {will be ingored}
      Second   :  WORD;   {will be ignored}
      MilliSec :  WORD;   {will be ignored}
      Values   :  ARRAY[TCheckIndex] OF WORD;
  BEGIN
    DecodeDate(TargetTime, Year, Values[chMonths], Values[chDays]);
    Values[chWeekdays] := DayOfWeek(TargetTime);

    DecodeTime(TargetTime, Values[chHours], Values[chMinutes], Second, MilliSec);

    RESULT := TRUE;
    FOR i := Low(TCheckIndex) TO High(TCheckIndex) DO
    BEGIN
      IF   RESULT
      THEN RESULT := RESULT AND Checks[i].IsFlagSet(Values[i]);
    END

  END {IsMatch};


END.
