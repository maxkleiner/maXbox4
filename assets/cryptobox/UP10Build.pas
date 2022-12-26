unit UP10Build;

{.$DEFINE DEBUG}
{$IFNDEF DEBUG}
  {$D-} {$L-} {$Q-} {$R-} {$S-}
{$ENDIF}

{$IFDEF Win32}
  {$LONGSTRINGS ON}
  {$S-}
{$ENDIF}

{$I+} { I/O checking is always on }

interface

uses
  UParser10,
  SysUtils, Classes;


procedure ParseFunction( FunctionString: string; { the unparsed string }
                         Variables: TStringlist; { list of variables }

                         { lists of available functions }
                         FunctionOne,               { functions with ONE argument, e.g. exp() }
                         FunctionTwo: TStringList;  { functions with TWO arguments, e.g. max(,) }

                         UsePascalNumbers: boolean; { true: -> Val; false: StrToFloat }

                         { return pointer to tree, number of performed operations and error state }
                         var FirstOP : POperation;

                         var Error : boolean);
                         { error actually is superfluous as we are now using exceptions }



implementation


{$IFDEF VER100}
resourcestring
{$ELSE}
const
{$ENDIF}
  msgErrBlanks = 'Expression has blanks';
  msgMissingBrackets = 'Missing brackets in expression';
  msgParseError = 'Error parsing expression:';
  msgNestings = 'Expression contains too many nestings';
  msgTooComplex = 'Expression is too complex';
  msgInternalError = 'TExParser internal error';

const
  TokenOperators = [ sum, diff, prod, divis, modulo, IntDiv, 
                     integerpower, realpower];

type
  TermString = {$IFDEF Win32} string {$ELSE} PString {$ENDIF};


procedure ParseFunction( FunctionString: string;
                         Variables: TStringList;

                         FunctionOne,
                         FunctionTwo: TStringList;

                         UsePascalNumbers: boolean;

                         var FirstOP: POperation;

                         var Error: boolean);


          function CheckNumberBrackets(const s: string): boolean; forward;
          { checks whether number of ( = number of ) }

          function CheckNumber(const s: string; var FloatNumber: ParserFloat): boolean; forward;
          { checks whether s is a number }

          function CheckVariable(const s: string; var VariableID: integer): boolean; forward;
          { checks whether s is a variable string }

          function CheckTerm(var s1: string): boolean; forward;
          { checks whether s is a valid term }

          function CheckBracket(const s: string; var s1: string): boolean; forward;
          { checks whether s =(...(s1)...) and s1 is a valid term }



          function CheckNegate(const s: string; var s1: string): boolean; forward;
          {checks whether s denotes the negative value of a valid operation}



          function CheckAdd(const s: string; var s1, s2: string): boolean; forward;
          {checks whether + is the primary operation in s}

          function CheckSubtract(const s: string; var s1, s2: string): boolean; forward;
          {checks whether - is the primary operation in s}

          function CheckMultiply(const s: string; var s1, s2: string): boolean; forward;
          {checks whether * is the primary operation in s}

          function CheckIntegerDiv(const s: string; var s1, s2: string): boolean; forward;
          {checks whether DIV is the primary TOperation in s}

          function CheckModulo(const s: string; var s1, s2: string): boolean; forward;
          {checks whether MOD is the primary TOperation in s}

          function CheckRealDivision(const s: string; var s1, s2: string): boolean;  forward;
          {checks whether / is the primary operation in s}



          function CheckFuncTwoVar(const s: string; var s1, s2: string): boolean; forward;
          {checks whether s=f(s1,s2); s1,s2 being valid terms}

          function CheckFuncOneVar(const s: string; var s1: string): boolean; forward;
          {checks whether s denotes the evaluation of a function fsort(s1)}


          function CheckPower(const s: string; var s1, s2: string; var AToken: TToken): boolean; forward;


          function CheckNumberBrackets(const s: string):boolean;
          {checks whether # of '(' equ. # of ')'}
          var
            counter,
            bracket : integer;
          begin
            bracket := 0;

            counter := length(s);
            while counter <> 0 do
            begin
              case s[counter] of
                '(': inc(bracket);
                ')': dec(bracket);
              end;
              dec(counter);
            end;

            Result := bracket = 0;
          end;


          function CheckNumber(const s: string; var FloatNumber: ParserFloat):boolean;
          {checks whether s is a number}
          var
            code: integer;
          {$IFDEF Debug} { prevent debugger from showing conversion errors }
            SaveClass : TClass;
          {$ENDIF}
          begin
            if s = 'PI' then
            begin
              FloatNumber := Pi;
              Result := true;
            end
            else
            if s = '-PI' then
            begin
              FloatNumber := -Pi;
              Result := true;
            end
            else
            begin
              if UsePascalNumbers then 
              begin
                val(s, FloatNumber, code);
                Result := code = 0;
              end
              else
              begin
                {$IFDEF Debug}
                  SaveClass := ExceptionClass;
                  ExceptionClass := nil;
                  try
                {$ENDIF}
                  try
                    FloatNumber := StrToFloat(s);
                    Result := true
                  except
                    on E: Exception do
                    begin
                      Result := false;
                    end;
                  end;
                {$IFDEF Debug}
                  finally
                    ExceptionClass := SaveClass;
                  end;
                {$ENDIF}
              end;
            end; 
          end;


          function CheckVariable(const s: string; var VariableID: integer): boolean;
          {checks whether s is a variable string}
          begin
            Result := Variables.Find(s, VariableID);
          end;


          function CheckTerm(var s1: string) :boolean;
          { checks whether s is a valid term }
          var
            s2, s3: TermString;
            FloatNumber: ParserFloat;
            fsort: TToken;
            VariableID: integer;
          begin
            Result := false;

            if length(s1) = 0 then
              exit;

            {$IFNDEF Win32}
              new(s2);
              new(s3);
              try
            {$ENDIF}

            if CheckNumber(s1, FloatNumber) or
               CheckVariable(s1, VariableID) or
               CheckNegate(s1, s2{$IFNDEF Win32}^{$ENDIF}) or
               CheckAdd(s1, s2{$IFNDEF Win32}^{$ENDIF}, s3{$IFNDEF Win32}^{$ENDIF}) or
               CheckSubtract(s1, s2{$IFNDEF Win32}^{$ENDIF}, s3{$IFNDEF Win32}^{$ENDIF}) or
               CheckMultiply(s1, s2{$IFNDEF Win32}^{$ENDIF}, s3{$IFNDEF Win32}^{$ENDIF}) or
               CheckIntegerDiv(s1, s2{$IFNDEF Win32}^{$ENDIF}, s3{$IFNDEF Win32}^{$ENDIF}) or
               CheckModulo(s1, s2{$IFNDEF Win32}^{$ENDIF}, s3{$IFNDEF Win32}^{$ENDIF}) or
               CheckRealDivision(s1, s2{$IFNDEF Win32}^{$ENDIF}, s3{$IFNDEF Win32}^{$ENDIF}) or
               CheckPower(s1, s2{$IFNDEF Win32}^{$ENDIF}, s3{$IFNDEF Win32}^{$ENDIF}, fsort) or
               CheckFuncTwoVar(s1, s2{$IFNDEF Win32}^{$ENDIF}, s3{$IFNDEF Win32}^{$ENDIF}) or
               CheckFuncOneVar(s1, s2{$IFNDEF Win32}^{$ENDIF})
            then
              Result := true
            else
              if CheckBracket(s1, s2{$IFNDEF Win32}^{$ENDIF}) then
              begin
                s1 := s2{$IFNDEF Win32}^{$ENDIF};
                Result := true
              end;

            {$IFNDEF Win32}
              finally
                dispose(s2);
                dispose(s3);
              end;
            {$ENDIF}
          end;

          function CheckBracket(const s: string; var s1: string): boolean;
          {checks whether s =(...(s1)...) and s1 is a valid term}
          var
            SLen : integer;
          begin
            Result := false;

            SLen := Length(s);
            if (SLen > 0) and (s[SLen] = ')') and (s[1] = '(') then
            begin
              s1 := copy(s, 2, SLen-2);
              Result := CheckTerm(s1);
            end;
          end;


          function CheckNegate(const s: string; var s1: string) :boolean;
          {checks whether s denotes the negative value of a valid TOperation}
          var
            s2, s3: TermString;
            fsort: TToken;
            VariableID: integer;
          begin
            Result := false;

            if (length(s) <> 0) and (s[1] = '-') then
            begin
              {$IFNDEF Win32}
                new(s2);
                new(s3);
                try
              {$ENDIF}

              s1 := copy(s, 2, length(s)-1);
              if CheckBracket(s1, s2{$IFNDEF Win32}^{$ENDIF}) then
              begin
                s1 := s2{$IFNDEF Win32}^{$ENDIF};
                Result := true;
              end
              else
                Result :=
                  CheckVariable(s1, VariableID) or
                  CheckPower(s1, s2{$IFNDEF Win32}^{$ENDIF}, s3{$IFNDEF Win32}^{$ENDIF}, fsort) or
                  CheckFuncOneVar(s1, s2{$IFNDEF Win32}^{$ENDIF}) or
                  CheckFuncTwoVar(s1, s2{$IFNDEF Win32}^{$ENDIF}, s3{$IFNDEF Win32}^{$ENDIF});

              {$IFNDEF Win32}
                finally
                  dispose(s2);
                  dispose(s3);
                end;
              {$ENDIF}
            end;
          end;


          function CheckAdd(const s: string; var s1, s2: string): boolean;
          {checks whether '+' is the primary TOperation in s}
          var
            s3, s4: TermString;
            i, j: integer;
            FloatNumber: ParserFloat;
            fsort: TToken;
            VariableID: integer;
          begin
            Result := false;

            i := 0;
            j := length(s);
            repeat

              while i <> j do
              begin
                inc(i);
                if s[i] = '+' then
                  break;
              end;

              if (i > 1) and (i < j) then
              begin
                s1 := copy(s, 1, i-1);
                s2 := copy(s, i+1, j-i);

                Result := CheckNumberBrackets(s1) and CheckNumberBrackets(s2);

                if Result then
                begin
                  Result := CheckVariable(s1, VariableID) or CheckNumber(s1, FloatNumber);

                  {$IFNDEF Win32}
                    new(s3);
                    new(s4);
                    try
                  {$ENDIF}

                  if not Result then
                  begin
                    Result := CheckBracket(s1, s3{$IFNDEF Win32}^{$ENDIF});
                    if Result then
                      s1 := s3{$IFNDEF Win32}^{$ENDIF};
                  end;

                  if not Result then
                    Result := CheckNegate(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                              CheckSubtract(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckMultiply(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckIntegerDiv(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckModulo(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckRealDivision(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckPower(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                              CheckFuncOneVar(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                              CheckFuncTwoVar(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});

                  if Result then
                  begin
                    Result := CheckVariable(s2, VariableID) or CheckNumber(s2, FloatNumber);

                    if not Result then
                    begin
                      Result := CheckBracket(s2, s3{$IFNDEF Win32}^{$ENDIF});
                      if Result then
                        s2 := s3{$IFNDEF Win32}^{$ENDIF}
                      else
                        Result := CheckAdd(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckSubtract(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckMultiply(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckIntegerDiv(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckModulo(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckRealDivision(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckPower(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                                  CheckFuncOneVar(s2, s3{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckFuncTwoVar(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});
                    end;
                  end;

                  {$IFNDEF Win32}
                    finally
                      dispose(s3);
                      dispose(s4);
                    end;
                  {$ENDIF}

                end;
              end
              else
                break;

            until Result;
          end;



          function CheckSubtract(const s: string; var s1, s2: string): boolean;
          {checks whether '-' is the primary TOperation in s}
          var
            s3, s4: TermString;
            i, j: integer;
            FloatNumber: ParserFloat;
            fsort: TToken;
            VariableID: integer;
          begin
            Result := false;

            i := 0;
            j := length(s);

            repeat

              while i <> j do
              begin
                inc(i);
                if s[i] = '-' then
                  break;
              end;

              if (i > 1) and (i < j) then
              begin
                s1 := copy(s, 1, i-1);
                s2 := copy(s, i+1, j-i);

                Result := CheckNumberBrackets(s1) and CheckNumberBrackets(s2);

                if Result then
                begin
                  Result := CheckVariable(s1, VariableID) or CheckNumber(s1, FloatNumber);

                  {$IFNDEF Win32}
                    new(s3);
                    new(s4);
                    try
                  {$ENDIF}

                  if not Result then
                  begin
                    Result := CheckBracket(s1, s3{$IFNDEF Win32}^{$ENDIF});
                    if Result then
                      s1 := s3{$IFNDEF Win32}^{$ENDIF};
                  end;
                  if not Result then
                    Result := CheckNegate(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                              CheckSubtract(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckMultiply(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckIntegerDiv(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckModulo(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckRealDivision(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckPower(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                              CheckFuncOneVar(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                              CheckFuncTwoVar(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});

                  if Result then
                  begin
                    Result := CheckVariable(s2, VariableID) or CheckNumber(s2, FloatNumber);

                    if not Result then
                    begin
                       Result := CheckBracket(s2, s3{$IFNDEF Win32}^{$ENDIF});
                       if Result then
                         s2 := s3{$IFNDEF Win32}^{$ENDIF}
                       else
                         Result := CheckMultiply(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                 CheckIntegerDiv(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                 CheckModulo(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                 CheckRealDivision(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                 CheckPower(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                                 CheckFuncOneVar(s2, s3{$IFNDEF Win32}^{$ENDIF}) or
                                 CheckFuncTwoVar(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});
                    end;
                  end;

                  {$IFNDEF Win32}
                    finally
                      dispose(s3);
                      dispose(s4);
                    end;
                  {$ENDIF}

                end;
              end
              else
                break;

            until Result;

          end;


          function CheckMultiply(const s: string; var s1, s2: string): boolean;
          {checks whether '*' is the primary TOperation in s}
          var
            s3, s4: TermString;
            i, j: integer;
            FloatNumber: ParserFloat;
            fsort: TToken;
            VariableID: integer;
          begin
            Result := false;

            i := 0;
            j := length(s);

            repeat
              while i <> j do
              begin
                inc(i);
                if s[i] = '*' then
                  break;
              end;

              if (i > 1) and (i < j) then
              begin
                s1 := copy(s, 1, i-1);
                s2 := copy(s, i+1, j-i);

                Result := CheckNumberBrackets(s1) and CheckNumberBrackets(s2);

                if Result then
                begin
                  Result := CheckVariable(s1, VariableID) or
                            CheckNumber(s1, FloatNumber);

                  {$IFNDEF Win32}
                    new(s3);
                    new(s4);
                    try
                  {$ENDIF}

                  if not Result then
                  begin
                    Result := CheckBracket(s1, s3{$IFNDEF Win32}^{$ENDIF});
                    if Result then
                      s1 := s3{$IFNDEF Win32}^{$ENDIF};
                  end;

                  if not Result then
                    Result := CheckNegate(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                              CheckIntegerDiv(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckModulo(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckRealDivision(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckPower(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                              CheckFuncOneVar(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                              CheckFuncTwoVar(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});

                  if Result then
                  begin
                    Result := CheckVariable(s2, VariableID) or
                              CheckNumber(s2, FloatNumber);

                    if not Result then
                    begin
                      Result := CheckBracket(s2, s3{$IFNDEF Win32}^{$ENDIF});
                      if Result then
                        s2 := s3{$IFNDEF Win32}^{$ENDIF}
                      else
                        Result := CheckMultiply(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckIntegerDiv(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckModulo(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckRealDivision(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckPower(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                                  CheckFuncOneVar(s2, s3{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckFuncTwoVar(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});
                    end;
                  end;

                  {$IFNDEF Win32}
                    finally
                      dispose(s3);
                      dispose(s4);
                    end;
                  {$ENDIF}

                end;
              end
              else
                break;

            until Result;
          end;


          function CheckIntegerDiv(const s: string; var s1, s2: string): boolean;
          {checks whether 'DIV' is the primary TOperation in s}
          var
            s3, s4: TermString;
            i, j: integer;
            VariableID: integer;
            FloatNumber: ParserFloat;
            fsort: TToken;
          begin
            Result := false;

            i := 0;

            repeat

              j := pos('DIV', copy(s, i+1, length(s)-i));
              if j > 0 then
              begin

                inc(i, j);
                if (i > 1) and (i < length(s)) then
                begin
                  s1 := copy(s, 1, i-1);
                  s2 := copy(s, i+3, length(s)-i-2);

                  Result := CheckNumberBrackets(s1) and CheckNumberBrackets(s2);

                  if Result then
                  begin
                    Result := CheckVariable(s1, VariableID) or
                              CheckNumber(s1, FloatNumber);

                    {$IFNDEF Win32}
                      new(s3);
                      new(s4);
                      try
                    {$ENDIF}

                    if not Result then
                    begin
                      Result := CheckBracket(s1, s3{$IFNDEF Win32}^{$ENDIF});
                      if Result then
                        s1 := s3{$IFNDEF Win32}^{$ENDIF};
                    end;

                    if not Result then
                      Result := CheckNegate(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                                CheckIntegerDiv(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                CheckModulo(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                CheckRealDivision(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                CheckPower(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                                CheckFuncOneVar(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                                CheckFuncTwoVar(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});
                    if Result then
                    begin
                      Result := CheckVariable(s2,VariableID) or
                                CheckNumber(s2,FloatNumber);

                      if not Result then
                      begin
                        Result := CheckBracket(s2, s3{$IFNDEF Win32}^{$ENDIF});
                        if Result then
                          s2 := s3{$IFNDEF Win32}^{$ENDIF}
                        else
                          Result := CheckPower(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                                    CheckFuncOneVar(s2, s3{$IFNDEF Win32}^{$ENDIF}) or
                                    CheckFuncTwoVar(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});
                      end;
                    end;

                    {$IFNDEF Win32}
                      finally
                        dispose(s3);
                        dispose(s4);
                      end;
                    {$ENDIF}

                  end;
                end;
              end;

            until Result or (j = 0) or (i >= length(s));
          end;

          function CheckModulo(const s: string; var s1, s2: string): boolean;
          {checks whether 'MOD' is the primary TOperation in s}
          var
            s3, s4: TermString;
            i, j: integer;
            VariableID: integer;
            FloatNumber: ParserFloat;
            fsort: TToken;
          begin
            Result := false;

            i := 0;
            repeat
              j := pos('MOD', copy(s, i+1, length(s)-i));
              if j > 0 then
              begin

                inc(i, j);
                if (i > 1) and (i < length(s)) then
                begin
                  s1 := copy(s, 1, i-1);
                  s2 := copy(s, i+3, length(s)-i-2);

                  Result := CheckNumberBrackets(s1) and CheckNumberBrackets(s2);

                  if Result then
                  begin
                    Result := CheckVariable(s1, VariableID) or
                              CheckNumber(s1, FloatNumber);

                    {$IFNDEF Win32}
                      new(s3);
                      new(s4);
                      try
                    {$ENDIF}

                    if not Result then
                    begin
                      Result := CheckBracket(s1, s3{$IFNDEF Win32}^{$ENDIF});
                      if Result then
                        s1 := s3{$IFNDEF Win32}^{$ENDIF};
                    end;
                    if not Result then
                      Result := CheckNegate(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                                CheckIntegerDiv(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                CheckModulo(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                CheckRealDivision(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                                CheckPower(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                                CheckFuncOneVar(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                                CheckFuncTwoVar(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});

                    if Result then
                    begin
                      Result := CheckVariable(s2, VariableID) or
                                CheckNumber(s2, FloatNumber);

                      if not Result then
                      begin
                        Result := CheckBracket(s2, s3{$IFNDEF Win32}^{$ENDIF});
                        if Result then
                          s2 := s3{$IFNDEF Win32}^{$ENDIF}
                        else
                          Result := CheckPower(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                                    CheckFuncOneVar(s2, s3{$IFNDEF Win32}^{$ENDIF}) or
                                    CheckFuncTwoVar(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});

                      end
                    end;

                    {$IFNDEF Win32}
                      finally
                        dispose(s3);
                        dispose(s4);
                      end;
                    {$ENDIF}

                  end;
                end;
              end;
            until Result or (j = 0) or (i >= length(s));
          end;

          function CheckRealDivision(const s: string; var s1, s2: string): boolean;
          {checks whether '/' is the primary TOperation in s}
          var
            s3, s4: TermString;
            i, j: integer;
            VariableID: integer;
            FloatNumber: ParserFloat;
            fsort: TToken;
          begin
            Result := false;

            i := 0;
            j := length(s);

            repeat

              while i <> j do
              begin
                inc(i);
                if s[i] = '/' then
                  break;
              end;

              if (i > 1) and (i < j) then
              begin
                s1 := copy(s, 1, i-1);
                s2 := copy(s, i+1, j-i);

                Result := CheckNumberBrackets(s1) and CheckNumberBrackets(s2);

                if Result then
                begin
                  Result := CheckVariable(s1, VariableID) or
                            CheckNumber(s1, FloatNumber);

                  {$IFNDEF Win32}
                    new(s3);
                    new(s4);
                    try
                  {$ENDIF}

                  if not Result then
                  begin
                    Result := CheckBracket(s1, s3{$IFNDEF Win32}^{$ENDIF});
                    if Result then
                      s1 := s3{$IFNDEF Win32}^{$ENDIF};
                  end;

                  if not Result then
                    Result := CheckNegate(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                              CheckIntegerDiv(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckModulo(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckRealDivision(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}) or
                              CheckPower(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                              CheckFuncOneVar(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                              CheckFuncTwoVar(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});

                  if Result then
                  begin
                    Result := CheckVariable(s2, VariableID) or
                              CheckNumber(s2, FloatNumber);

                    if not Result then
                    begin
                      Result := CheckBracket(s2, s3{$IFNDEF Win32}^{$ENDIF});
                      if Result then
                        s2 := s3{$IFNDEF Win32}^{$ENDIF}
                      else
                        Result := CheckPower(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF}, fsort) or
                                  CheckFuncOneVar(s2, s3{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckFuncTwoVar(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});

                    end;
                  end;

                  {$IFNDEF Win32}
                    finally
                      dispose(s3);
                      dispose(s4);
                    end;
                  {$ENDIF}

                end;
              end
              else
                break;

            until Result;
          end;


          function CheckFuncTwoVar(const s: string; var s1, s2: string): boolean;
          {checks whether s=f(s1,s2); s1,s2 being valid terms}

            function CheckComma(const s: string; var s1, s2: string): boolean;
            var
              i, j: integer;
            begin
              Result := false;

              i := 0;
              j := length(s);
              repeat

                while i <> j do
                begin
                  inc(i);
                  if s[i] = ',' then
                    break;
                end;

                if (i > 1) and (i < j) then
                begin
                  s1 := copy(s, 1, i-1);
                  if CheckTerm(s1) then
                  begin
                    s2 := copy(s, i+1, j-i);
                    Result := CheckTerm(s2);
                  end;

                end
                else
                  break;

              until Result;
            end;

          var
            SLen,
            counter : integer;
          begin

            Result := false;

            SLen := Pos('(', s);
            dec(SLen);

            if (SLen > 0) and (s[length(s)] = ')') then
            begin
              if FunctionTwo.Find(copy(s, 1, SLen), counter) then
              begin
                inc(SLen, 2);
                Result := CheckComma( copy(s, SLen, length(s)-SLen), s1, s2);
              end;
            end;
          end;


          function CheckFuncOneVar(const s: string; var s1: string): boolean;
          {checks whether s denotes the evaluation of a function fsort(s1)}
          var
          {$IFNDEF Win32}
            s2: TermString;
          {$ENDIF}
            counter: integer;
            SLen: integer;
          begin
            Result := false;

            SLen := Pos('(', s);
            dec(SLen);

            if (SLen > 0) then
            begin
              if FunctionOne.Find(copy(s, 1, SLen), counter) then
              begin
              {$IFNDEF Win32}
                new(s2);
                try
                  s2^ := copy(s, SLen+1, length(s)-SLen);
                  Result := CheckBracket(s2^, s1);
                finally
                  dispose(s2);
                end;
              {$ELSE}
                Result := CheckBracket(copy(s, SLen+1, length(s)-SLen), s1);
              {$ENDIF}
              end;
            end;
          end;



          function CheckPower(const s: string; var s1, s2: string; var AToken: TToken): boolean;
          var
            s3, s4: TermString;
            i, j: integer;
            FloatNumber: ParserFloat;
            VariableID: integer;
          begin
            Result := false;

            i := 0;
            j := length(s);
            repeat

              while i <> j do
              begin
                inc(i);
                if s[i] = '^' then
                  break;
              end;

              if (i > 1) and (i < j) then
              begin
                s1 := copy(s, 1, i-1);
                s2 := copy(s, i+1, j-i);

                Result := CheckNumberBrackets(s1) and CheckNumberBrackets(s2);

                if Result then
                begin
                  Result := CheckVariable(s1, VariableID) or CheckNumber(s1, FloatNumber);

                  {$IFNDEF Win32}
                    new(s3);
                    new(s4);
                    try
                  {$ENDIF}

                  if not Result then
                  begin
                    Result := CheckBracket(s1, s3{$IFNDEF Win32}^{$ENDIF});
                    if Result then
                      s1 := s3{$IFNDEF Win32}^{$ENDIF};
                  end;

                  if not Result then
                    Result := CheckFuncOneVar(s1, s3{$IFNDEF Win32}^{$ENDIF}) or
                              CheckFuncTwoVar(s1, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});

                  if Result then
                  begin

                    if CheckNumber(s2, FloatNumber) then
                    begin
                      i := trunc(FloatNumber);

                      if (i <> FloatNumber) then
                      begin
                        { this is a real number }
                        AToken := realpower;
                      end
                      else
                      begin
                        case i of
                          2: AToken := square;
                          3: AToken := third;
                          4: AToken := fourth;
                        else
                          AToken := integerpower;
                        end;
                      end;
                    end
                    else
                    begin
                      Result := CheckVariable(s2, VariableID);

                      if not Result then
                      begin
                        Result := CheckBracket(s2, s3{$IFNDEF Win32}^{$ENDIF});
                        if Result then
                          s2 := s3{$IFNDEF Win32}^{$ENDIF};
                      end;

                      if not Result then
                      begin
                        Result := CheckFuncOneVar(s2, s3{$IFNDEF Win32}^{$ENDIF}) or
                                  CheckFuncTwoVar(s2, s3{$IFNDEF Win32}^{$ENDIF}, s4{$IFNDEF Win32}^{$ENDIF});
                      end;

                      if Result then
                        AToken := realPower;
                    end;
                  end;

                  {$IFNDEF Win32}
                    finally
                      dispose(s3);
                      dispose(s4);
                    end;
                  {$ENDIF}

                end;
              end
              else
                break;

            until Result;
          end;

          function CreateOperation(const Term: TToken; const Proc: Pointer): POperation;
          begin
            new(Result);
            with Result^ do
            begin
              Arg1 := nil;
              Arg2 := nil;
              Dest := nil;

              NextOperation := nil;

              Token := Term;

              Operation := TMathProcedure(Proc);
            end;
          end;

const
  BlankString = ' ';

type
  PTermRecord = ^TermRecord;
  TermRecord = record
                 { this usage of string is a bit inefficient,
                   as in 16bit always 256 bytes are consumed.
                   But since we
                   a) are allocating memory dynamically and
                   b) this will be released immediately when
                      finished with parsing
                   this seems to be OK

                   One COULD create a "TermClass" where this is handled }
                 StartString: string;
                 LeftString, RightString: string;

                 Token: TToken;

                 Position: array[1..3] of integer;

                 Next1,
                 Next2,
                 Previous: PTermRecord;
               end;

const
  { side effect: for each bracketing level added
      SizeOf(integer) bytes additional stack usage
      maxLevelWidth*SizeOf(Pointer) additional global memory used }
  maxBracketLevels = 20;

  { side effect: for each additional (complexity) level width
      maxBracketLevels*SizeOf(Pointer) additional global memory used }
  maxLevelWidth = 50;
type
  LevelArray = array[0..maxBracketLevels] of integer;

  OperationPointerArray = array[0..maxBracketLevels, 1..maxLevelWidth] of POperation;
  POperationPointerArray = ^OperationPointerArray;
var
  Matrix: POperationPointerArray;

  { bracket positions }
  CurrentBracket,
  i,
  CurBracketLevels: integer;

  BracketLevel: LevelArray;

  LastOP: POperation;
  FloatNumber: ParserFloat;
  VariableID: integer;


  ANewTerm, { need this particlar pointer to guarantee a good, flawless memory cleanup in except }

  FirstTerm,
  Next1Term,
  Next2Term,
  LastTerm: PTermRecord;

  counter1,
  counter2: integer;
begin
  { initialize local variables for safe checking in try..finally..end}

  { FirstTerm := nil; } { not necessary since not freed in finally }
  LastTerm := nil;
  ANewTerm := nil;
  Next1Term := nil;
  Next2Term := nil;

  Error := false;

  FillChar(BracketLevel, SizeOf(BracketLevel), 0); { initialize bracket array }
  BracketLevel[0] := 1;
  CurBracketLevels := 0;

  new(Matrix);

  try { this block protects the whole of ALL assignments...}
    FillChar(Matrix^, SizeOf(Matrix^), 0);

    new(ANewTerm);
    with ANewTerm^ do
    begin

      StartString := UpperCase(FunctionString);

      { remove leading and trailing spaces }
      counter1 := 1;
      counter2 := length(StartString);
      while counter1 <= counter2 do
        if StartString[counter1] <> ' ' then
          break
        else
          inc(counter1);

      counter2 := length(StartString);
      while counter2 > counter1 do
        if StartString[counter2] <> ' ' then
          break
        else
          dec(counter2);

      StartString := Copy(StartString, counter1, counter2 - counter1 + 1);

      if Pos(' ', StartString) > 0 then
        raise EExpressionHasBlanks.Create(msgErrBlanks);
      {
      Old code:

         StartString := RemoveBlanks(UpperCase(FunctionString));

      ...do not use! Using it would create the following situation:

         Passed string:   "e xp(12)"
         Modified string: "exp(12)"

      This MAY or may not be the desired meaning - there may well exist
      a variable "e" and a function "xp" and just the operator would be missing.

      Conclusion: the above line has the potential of changing the meaning
                  of an expression.
      }

      if not CheckNumberBrackets(StartString) then
        raise EMissMatchingBracket.Create(msgMissingBrackets);

      { remove enclosing brackets, e.g. ((pi)) }
      while CheckBracket(StartString, FunctionString) do
        StartString := FunctionString;

      LeftString := BlankString;
      RightString := BlankString;

      Token := variab;

      Next1 := nil;
      Next2 := nil;
      Previous := nil;
    end;

    Matrix^[0,1] := CreateOperation(variab, nil);

    LastTerm := ANewTerm;
    FirstTerm := ANewTerm;
    ANewTerm := nil;

    with LastTerm^ do
    begin
      Position[1] := 0;
      Position[2] := 1;
      Position[3] := 1;
    end;

    repeat

      repeat

        with LastTerm^ do
        begin

          CurrentBracket := Position[1];
          i := Position[2];

          if Next1 = nil then
          begin
            if CheckVariable(StartString, VariableID) then
            begin
              Token := variab;

              if Position[3] = 1 then
                Matrix^[CurrentBracket, i]^.Arg1 := PParserFloat(Variables.Objects[VariableID])
              else
                Matrix^[CurrentBracket, i]^.Arg2 := PParserFloat(Variables.Objects[VariableID])
            end
            else
            begin
              if CheckNumber(StartString, FloatNumber) then
              begin
                Token := constant;
                if Position[3] = 1 then
                begin
                  new(Matrix^[CurrentBracket, i]^.Arg1);
                  Matrix^[CurrentBracket, i]^.Arg1^ := FloatNumber;
                end
                else
                begin
                  new(Matrix^[CurrentBracket, i]^.Arg2);
                  Matrix^[CurrentBracket, i]^.Arg2^ := FloatNumber;
                end;
              end
              else
              begin
                if CheckNegate(StartString, LeftString) then
                  Token := minus
                else
                begin
                  if CheckAdd(StartString, LeftString, RightString) then
                    Token := sum
                  else
                  begin
                    if CheckSubtract(StartString, LeftString, RightString) then
                      Token := diff
                    else
                    begin
                      if CheckMultiply(StartString, LeftString, RightString) then
                        Token := prod
                      else
                      begin
                        if CheckIntegerDiv(StartString, LeftString, RightString) then
                          Token := IntDiv
                        else
                        begin
                          if CheckModulo(StartString, LeftString, RightString) then
                            Token := modulo
                          else
                          begin
                            if CheckRealDivision(StartString, LeftString, RightString) then
                              Token := divis
                            else
                            begin
                              if not CheckPower(StartString, LeftString, RightString, Token) then
                              begin
                                if CheckFuncOneVar(StartString, LeftString) then
                                  Token := FuncOneVar
                                else
                                begin
                                  if CheckFuncTwoVar(StartString, LeftString, RightString) then
                                    Token := FuncTwoVar
                                  else
                                  begin
                                    Error := true; {with an exception raised this is meaningless...}
                                    if (LeftString = BlankString) and (RightString = BlankString) then
                                      raise ESyntaxError.CreateFmt(
                                         msgParseError+#13'%s', [StartString]
                                                                   )
                                    else
                                      raise ESyntaxError.CreateFmt(
                                         msgParseError+#13'%s'#13'%s', [Leftstring, RightString]
                                                                   )
                                  end;
                                end;
                              end;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end; { with LastTerm^ }


        if LastTerm^.Token in ( [minus, square, third, fourth, FuncOneVar, FuncTwoVar] + TokenOperators) then
        begin
          if LastTerm^.Next1 = nil then
          begin
            try
              Next1Term := nil;
              new(Next1Term);

              inc(CurrentBracket);
              if CurrentBracket > maxBracketLevels then
              begin
                Error := true;
                raise ETooManyNestings.Create(msgNestings);
              end;

              if CurBracketLevels < CurrentBracket then
                CurBracketLevels := CurrentBracket;

              i := BracketLevel[CurrentBracket] + 1;
              if i > maxLevelWidth then
              begin
                Error := true;
                raise EExpressionTooComplex.Create(msgTooComplex);
              end;

              with Next1Term^ do
              begin
                StartString := LastTerm^.LeftString;
                LeftString := BlankString;
                RightString := BlankString;

                Position[1] := CurrentBracket;
                Position[2] := i;
                Position[3] := 1;

                Token := variab;

                Previous := LastTerm;
                Next1 := nil;
                Next2 := nil;
              end;

              with LastTerm^ do
              begin
                case Token of
                  FuncOneVar:
                    with FunctionOne do
                      Matrix^[CurrentBracket, i] := CreateOperation(
                                       Token,
                                       Objects[IndexOf(copy(StartString, 1, pos('(', StartString)-1))]
                                                                   );

                  FuncTwoVar:
                    with FunctionTwo do
                      Matrix^[CurrentBracket, i] := CreateOperation(
                                       Token,
                                       Objects[IndexOf(copy(StartString, 1, pos('(', StartString)-1))]
                                                                  );
                else
                  Matrix^[CurrentBracket, i] := CreateOperation(Token, nil);
                end;

                new(Matrix^[CurrentBracket, i]^.Dest);
                Matrix^[CurrentBracket, i]^.Dest^ := 0;

                if Position[3] = 1 then
                  Matrix^[Position[1], Position[2]]^.Arg1 := Matrix^[CurrentBracket, i]^.Dest
                else
                  Matrix^[Position[1], Position[2]]^.Arg2 := Matrix^[CurrentBracket, i]^.Dest;

                Next1 := Next1Term;
                Next1Term := nil;
              end;

              if LastTerm^.Token in [minus, square, third, fourth, FuncOneVar] then
                inc(BracketLevel[CurrentBracket]);

            except
              on E: Exception do
              begin
                if assigned(Next1Term) then
                begin
                  dispose(Next1Term);
                  Next1Term := nil;
                end;

                raise;
              end;
            end;

          end

          else
          begin
            if LastTerm^.Token in (TokenOperators + [FuncTwoVar]) then
            begin
              try
                Next2Term := nil;
                new(Next2Term);

                inc(CurrentBracket);
                if CurrentBracket > maxBracketLevels then
                begin
                  Error := true;
                  raise ETooManyNestings.Create(msgNestings);
                end;

                if CurBracketLevels < CurrentBracket then
                  CurBracketLevels := CurrentBracket;

                i := BracketLevel[CurrentBracket] + 1;
                if i > maxLevelWidth then
                begin
                  Error := true;
                  raise EExpressionTooComplex.Create(msgTooComplex);
                end;

                with Next2Term^ do
                begin
                  StartString := LastTerm^.RightString;

                  LeftString := BlankString;
                  RightString := BlankString;

                  Token := variab;

                  Position[1] := CurrentBracket;
                  Position[2] := i;
                  Position[3] := 2;

                  Previous := LastTerm;
                  Next1 := nil;
                  Next2 := nil;
                end;

                LastTerm^.Next2 := Next2Term;
                Next2Term := nil;
                inc(BracketLevel[CurrentBracket]);

              except
                on E: Exception do
                begin
                  if assigned(Next2Term) then
                  begin
                    dispose(Next2Term);
                    Next2Term := nil;
                  end;
                end;
              end;
            end
            else
              raise EParserInternalError.Create(msgInternalError);
          end;
        end;


        with LastTerm^ do
          if Next1 = nil then
          begin
          { we are done with THIS loop }
            break;
          end
          else
            if Next2 = nil then
              LastTerm := Next1
            else
              LastTerm := Next2;

      until false; { endless loop, break'ed 7 lines above }

      if LastTerm = FirstTerm then
      begin
        dispose(LastTerm);
        FirstTerm := nil;
        break; { OK - that is it, we did not find any more terms}
      end;

      repeat
        with LastTerm^ do { cannot use "with LastTerm^" OUTSIDE loop }
        begin
          if Next1 <> nil then
          begin
            dispose(Next1);
            Next1 := nil;
          end;

          if Next2 <> nil then
          begin
            dispose(Next2);
            Next2 := nil;
          end;

          LastTerm := Previous;
        end;
      until ((LastTerm^.Token in (TokenOperators + [FuncTwoVar])) and (LastTerm^.Next2 = nil)) or
            (LastTerm = FirstTerm);

      with FirstTerm^ do
      if (LastTerm = FirstTerm) and
            (  (Token in [minus, square, third, fourth, FuncOneVar]) or
               ((Token in (TokenOperators + [FuncTwoVar])) and Assigned(Next2))
            ) then
      begin
        break;
      end;


    until false;


    { after having built the expression matrix, translate it into a tree/list }

    with FirstTerm^ do
      if FirstTerm <> nil then
      begin
        if Next1 <> nil then
        begin
          dispose(Next1);
          Next1 := nil;
        end;

        if Next2 <> nil then
        begin
          dispose(Next2);
          Next2 := nil;
        end;

        dispose(FirstTerm);
      end;

    BracketLevel[0] := 1;

    if CurBracketLevels = 0 then
    begin
      FirstOP := Matrix^[0,1];
      Matrix^[0,1] := nil;
      FirstOP^.Dest := FirstOP^.Arg1;
    end
    else
    begin

      FirstOP := Matrix^[CurBracketLevels, 1];
      LastOP := FirstOP;

      for counter2 := 2 to BracketLevel[CurBracketLevels] do
      begin
        LastOP^.NextOperation := Matrix^[CurBracketLevels, counter2];
        LastOP := LastOP^.NextOperation;
      end;


      for counter1 := CurBracketLevels-1 downto 1 do
        for counter2 := 1 to BracketLevel[counter1] do
        begin
          LastOP^.NextOperation := Matrix^[counter1, counter2];
          LastOP := LastOP^.NextOperation;
        end;


      with Matrix^[0,1]^ do
      begin
        Arg1 := nil;
        Arg2 := nil;
        Dest := nil;
      end;

      dispose(Matrix^[0,1]);
    end;

    dispose(Matrix);

  except

    on E: Exception do
    begin
      if Assigned(Matrix) then
      begin
        if assigned(Matrix^[0,1]) then
          dispose(Matrix^[0,1]);

        for counter1 := CurBracketLevels downto 1 do
          for counter2 := 1 to BracketLevel[counter1] do
            if Assigned(Matrix^[counter1, counter2]) then

              dispose(Matrix^[counter1, counter2]);

        dispose(Matrix);
      end;

      if Assigned(Next1Term) then
        dispose(Next1Term);

      if Assigned(Next2Term) then
        dispose(Next2Term);

  {   do NOT kill this one at it is possibly the same as LastTerm (see below)!
      if Assigned(FirstTerm) then
        dispose(FirstTerm);

      instead, DO kill ANewTerm, which will only be <> nil if it has NOT passed
      its value to some other pointer already so it can safely be freed
  }
      if Assigned(ANewTerm) then
        dispose(ANewTerm);

      if Assigned(LastTerm) and (LastTerm <> Next2Term) and (LastTerm <> Next1Term) then
        dispose(LastTerm);

      FirstOP := nil;

      raise; { re-raise exception }

    end; { on E:Exception do }
  end;
end;



end.
