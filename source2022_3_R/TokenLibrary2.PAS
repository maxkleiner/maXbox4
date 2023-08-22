//  Sample Usage:
//
//  FieldSpec := TTokens.Create(FieldSpecLine, ', ', '"', '"', '\',
//                              ssMultipleSeparatorsBetweenTokens);
//  TRY
//    FieldType := UpperCase(FieldSpec.Token(2));
//  FINALLY
//    FieldSpec.Free
//  END
//
//////////////////////////////////////////////////////////////////////
//
// Tokens Library.
//
// Copyright (C) 1996, 2000, Earl F. Glynn.  All Rights Reserved.
// Converted from C++ Tokens unit, December 1996
// Updated September 2000.
//
// From:  www.efg2.com/Lab/Library/Delphi/Strings/default.htm#Tokens
// See the finite state diagram online there.
//
// There are many ways to optimize the routines here.  These routines
// are meant to be a "good" approach for educational purposes.

UNIT TokenLibrary2;

INTERFACE

  TYPE
    TTokenSeparator = (tsSingleSeparatorBetweenTokens,
                       tsMultipleSeparatorsBetweenTokens);

    TTokens2 =
      CLASS(TObject)
        PRIVATE
          FOriginalString:  STRING;  
          FCount         :  WORD;
          FTokenString   :  STRING;  // Separator-stripped string with tokens
                                     // separated by NULLs
        PROTECTED
          FUNCTION GetToken(index:  INTEGER):  STRING;

        PUBLIC
          CONSTRUCTOR Create (CONST OriginalString:  STRING;
                              CONST separators:  STRING;
                              CONST LeftMark :  CHAR;
                              CONST RightMark:  CHAR;
                              CONST Escape   :  CHAR;
                              CONST SeparatorBetweenTokens:  TTokenSeparator);

          // With "default" Tokens instance can access a token as Tokens[i],
          // which is equivalent to Tokens.Token[i]                    
          PROPERTY Token[index:  INTEGER]:  STRING  READ GetToken;  DEFAULT;

          PROPERTY OriginalString:  STRING  READ FOriginalString;
          PROPERTY Count         :  WORD    READ FCount;


      END;


IMPLEMENTATION

 // USES
//    SysUtils;    {AppendStr}

  CONST
    NULL = #$00;

  TYPE
    TFiniteStates = (fsSkipSeparatorsState,
                     fsAcceptSingleWordTokenState,
                     fsAcceptMultiWordTokenState,
                     fsEscapeState);

  CONSTRUCTOR TTokens2.Create (CONST OriginalString:  STRING;
                              CONST separators:  STRING;
                              CONST LeftMark :  CHAR;
                              CONST RightMark:  CHAR;
                              CONST Escape   :  CHAR;
                              CONST SeparatorBetweenTokens:  TTokenSeparator);
    VAR
      c                  :  CHAR;
      i                  :  WORD;
      IgnoreNextSeparator:  BOOLEAN;
      state              :  TFiniteStates;
  BEGIN
    INHERITED CREATE;

    FOriginalString := OriginalString;

    FTokenString := '';
    FCount := 0;

    {The following "flag" is somewhat of a kludge to allow a single
     separator to follow the closing RightMark of a Multiword Token
     when SingleSeparatorBetweenTokens is TRUE}
    IgnoreNextSeparator := FALSE;

    {Initial state of finite machine that recognizes tokens}
    state := fsSkipSeparatorsState;

    FOR i := 1 TO LENGTH(FOriginalString) DO
    BEGIN
      c := FOriginalString[i];

      CASE state OF
        fsSkipSeparatorsState:
          {Do nothing if character is separator}
          IF   POS(c, Separators) > 0
          THEN BEGIN
            {For cases like multiple comma-delimited fields, treat each
             separator as end of a token, e.g, "x,,,y" woud be 4 tokens}
            IF   SeparatorBetweenTokens = tsSingleSeparatorBetweenTokens
            THEN BEGIN
              IF   IgnoreNextSeparator
              THEN IgnoreNextSeparator := FALSE
              ELSE BEGIN
                INC(FCount);
                FTokenString := FTokenString + NULL
              END
            END
          END
          ELSE BEGIN
            IF  c = LeftMark
            THEN BEGIN
              state := fsAcceptMultiWordTokenState;
              INC(FCount)
            END
            ELSE BEGIN
              state := fsAcceptSingleWordTokenState;
              INC(FCount);
              FTokenString := FTokenString +  c
            END
          END;

        fsAcceptSingleWordTokenState:
          IF   POS(c, Separators) = 0
          THEN FTokenString := FTokenString + c  // not a separator
          ELSE BEGIN                             // separator
            FTokenString := FTokenString + NULL;
            state := fsSkipSeparatorsState
          END;

        fsAcceptMultiWordTokenState:
          IF  c = RightMark
          THEN BEGIN
            FTokenString := FTokenString + NULL;
            state := fsSkipSeparatorsState;
            IgnoreNextSeparator := TRUE
          END
          ELSE BEGIN
            IF   c = Escape
            THEN state := fsEscapeState
            ELSE FTokenString := FTokenString + c
          END;

        fsEscapeState:
          BEGIN
            FTokenString := FTokenString + c;
            state := fsAcceptMultiWordTokenState
          END

      END

    END

  END {Constructor};

  // Index should be 0..FCount-1
  FUNCTION TTokens2.GetToken(index:  INTEGER):  STRING;
    VAR
      c    :  CHAR;
      found:  WORD;
      i    :  INTEGER;
  BEGIN
    RESULT := '';

    IF   (index >= 0) AND (index <= FCount-1)
    THEN BEGIN

      found := 0;
      i := 1;

      WHILE (i <= LENGTH(FTokenString)) AND (found <= index)
      DO BEGIN
        c := FTokenString[i];

        IF   c = NULL
        THEN INC (found)
        ELSE
          IF   found = index
          THEN RESULT := RESULT + c;

        INC (i)
      END

    END
  END {Token};


END.
