{Tokens Library.

 Copyright (C) 1996, Earl F. Glynn.  All Rights Reserved.
 Converted from C++ Tokens unit, December 1996

 [Note:  The diagram below will appear with correct line-drawing characters
         in DOS or on an HP LaserJet printer.]


                Finite State Machine to Recognize Tokens

                                START
                                  �           *
               else               � separators           else
               ���Ŀ              �   ���Ŀ              ���Ŀ
               �         Left       �                 �   
           �����������Ŀ  Mark  �����������Ŀ else   �����������Ŀ
           �  Accept   �������ĳ           ���������  Accept   �
           � MultiWord �        �    Skip   �        �SingleWord �
           �   Token   �        � Separators�        �   Token   �
           �   State   ���������   State   �������ĳ   State   �
           �������������  Right ������������� separa-�������������
        escape�          Mark                 tors
     character�     �
              �     � any
                   � character
           �����������Ŀ
           �   Escape  �
           �   State   �
           �������������


             *
              Multiple separators can be treated as one (e.g., space or tab),
              or treated as multiple null tokens (e.g, comma delimited data).
}

UNIT Tokens;

INTERFACE

  TYPE
    TTokens =
      CLASS(TObject)
        PRIVATE
          CharacterString:  STRING;  {Original string}
          NumberOfTokens :  WORD;
          TokenString    :  STRING;  {Separator-stripped string with tokens}
                                     {separated by NULLs}

        PROTECTED
        PUBLIC
          CONSTRUCTOR Create (CONST OriginalString:  STRING;
                              CONST separators:  STRING;
                              CONST LeftMark :  CHAR;
                              CONST RightMark:  CHAR;
                              CONST Escape   :  CHAR;
                              CONST SingleSeparatorBetweenTokens:  BOOLEAN);
          DESTRUCTOR Destroy;
            OVERRIDE;

          FUNCTION Token(CONST index:  WORD):  STRING;

          FUNCTION TokenCount:  WORD;

      END;


IMPLEMENTATION

  USES
    SysUtils;    {AppendStr}

  CONST
    NULL = #$00;

  TYPE
    TFiniteStates = (fsSkipSeparatorsState,
                     fsAcceptSingleWordTokenState,
                     fsAcceptMultiWordTokenState,
                     fsEscapeState);


  CONSTRUCTOR TTokens.Create (CONST OriginalString:  STRING;
                              CONST separators:  STRING;
                              CONST LeftMark :  CHAR;
                              CONST RightMark:  CHAR;
                              CONST Escape   :  CHAR;
                              CONST SingleSeparatorBetweenTokens:  BOOLEAN);
    VAR
      c                  :  CHAR;
      i                  :  WORD;
      IgnoreNextSeparator:  BOOLEAN;
      state              :  TFiniteStates;
  BEGIN
    INHERITED CREATE;

    CharacterString := OriginalString;

    TokenString := '';
    NumberOfTokens := 0;

    {The following "flag" is somewhat of a kludge to allow a single
     separator to follow the closing RightMark of a Multiword Token
     when SingleSeparatorBetweenTokens is TRUE}
    IgnoreNextSeparator := FALSE;

    {Initial state of finite machine that recognizes tokens}
    state := fsSkipSeparatorsState;

    FOR i := 1 TO LENGTH(CharacterString) DO
    BEGIN
      c := CharacterString[i];

      CASE state OF
        fsSkipSeparatorsState:
          {Do nothing if character is separator}
          IF   POS(c, Separators) > 0
          THEN BEGIN
            {For cases like multiple comma-delimited fields, treat each
             separator as end of a token, e.g, "x,,,y" woud be 4 tokens}
            IF SingleSeparatorBetweenTokens
            THEN BEGIN
              IF   IgnoreNextSeparator
              THEN IgnoreNextSeparator := FALSE
              ELSE BEGIN
                INC(NumberOfTokens);
                AppendStr(TokenString, NULL)
              END
            END
          END
          ELSE BEGIN
            IF  c = LeftMark
            THEN BEGIN
              state := fsAcceptMultiWordTokenState;
              INC(NumberOfTokens)
            END
            ELSE BEGIN
              state := fsAcceptSingleWordTokenState;
              INC(NumberOfTokens);
              AppendStr(TokenString, c)
            END
          END;

        fsAcceptSingleWordTokenState:
          IF   POS(c, Separators) = 0
          THEN AppendStr(TokenString, c)         {not a separator}
          ELSE BEGIN                             {separator}
            AppendStr (TokenString, NULL);
            state := fsSkipSeparatorsState
          END;

        fsAcceptMultiWordTokenState:
          IF  c = RightMark
          THEN BEGIN
            AppendStr(TokenString, NULL);
            state := fsSkipSeparatorsState;
            IgnoreNextSeparator := TRUE
          END
          ELSE BEGIN
            IF   c = Escape
            THEN state := fsEscapeState
            ELSE AppendStr(TokenString, c)
          END;

        fsEscapeState:
          BEGIN
            AppendStr(TokenString, c);
            state := fsAcceptMultiWordTokenState
          END

      END

    END

  END {Constructor};


  DESTRUCTOR TTokens.Destroy;
  BEGIN
    INHERITED Destroy
  END {Destroy};


  FUNCTION TTokens.Token(CONST index:  WORD):  STRING;
    VAR
      c    :  CHAR;
      found:  WORD;
      i    :  INTEGER;
  BEGIN
    RESULT := '';
    found := 1;
    i := 1;

    WHILE (i <= LENGTH(TokenString)) AND (found <= index)
    DO BEGIN
      c := TokenString[i];

      IF   c = NULL
      THEN INC (found)
      ELSE
        IF   (found = index)
        THEN AppendStr(RESULT, c);

      INC (i)
    END;

  END {Token};


  FUNCTION TTokens.TokenCount:  WORD;
  BEGIN
    RESULT := NumberOfTokens
  END {TokenCount};


END.
