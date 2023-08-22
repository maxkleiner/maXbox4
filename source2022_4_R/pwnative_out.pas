{%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                          Powtils Native Stdout
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--------------------------------------------------------------------------------
 Native Out Unit
--------------------------------------------------------------------------------
  Contains the main procedures and additions for implementing Operating System 
  stdout functions.   This removes one level of redirection  from using 
  Write/Writeln and allows webcrt to work when calling the pwmain.out function.
  Delphi is not supported and these functions just call system.write

  Authors/Credits: Anthony Henry

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%}

UNIT pwnative_out; {$IFDEF WIN32} {$DEFINE WINDOWS} {$ENDIF}

// Implements OS native string out to STDOUT
// function for windows and unix. 

INTERFACE
uses 
  pwtypes, 
 {$IFDEF UNIX}baseunix;{$ENDIF}
 {$IFDEF WINDOWS}windows;{$ENDIF}


{$IFDEF UNIX}
// Under Unix STDOUT is always 1.
  CONST
     STDIN = 0;
     STDOUT = 1;
     STDERR = 2;
{$ENDIF}

{$IFDEF FPC}{$IFDEF WINDOWS}
  var STDOUT: HANDLE;
{$ENDIF}{$ENDIF}

procedure NativeWrite(s : astr); overload;
procedure NativeWrite(PString : PChar); overload;
procedure NativeWrite(Buffer: PChar;  NumChars: Cardinal); overload;
procedure NativeWriteLn(s: astr); overload;
procedure NativeWriteLn; overload;


// function strlen is defined in system unit.
// function strlen(p:pchar):sizeint;external name 'FPC_PCHAR_LENGTH';

IMPLEMENTATION

{$IFNDEF FPC}  // delphi doesn't work with native out unit
  procedure NativeWrite(s: astr); overload;
  begin
    system.write(s);
  end;

  procedure NativeWrite(Buffer: PChar;  NumChars : Cardinal); overload;
  begin
    Buffer[numchars]:= #0;
    system.write(Buffer);
  end;

  procedure NativeWrite(PString: PChar); overload;
  begin
    system.write(PString);
  end;
{$ENDIF}

{$IFDEF FPC}

{$IFDEF WINDOWS}
var
  NumberOfChars: DWORD;
  NumWritten: LongWord;
  Idx, CharsLeft: Cardinal;
  PO: POVERLAPPED;
  TPc: PChar;
{$ENDIF}

  procedure NativeWrite(S : astr); overload;
  {$IFDEF UNIX}var NumberOfChars: Cardinal;
  {$ENDIF}
  begin
    NumberOfChars := Length(S);

   {$IFDEF UNIX}
    fpwrite(STDOUT, PChar(S), NumberOfChars);
   {$ENDIF}

   {$IFDEF WINDOWS}
    po := nil;

    // If we move NativeWrite into pwumain then this can be IFDEF 'ED WITH STATIC.
    // With STATIC put this call in initialization. It only needs to be in the
    // function if called from DLL (Win STDOUT is not alway the same handle.)
    // But it shouldn't change for one program run.
    STDOUT := GetStdHandle(STD_OUTPUT_HANDLE);

    // Windows WriteFile function is limited to 64k characters across a Named Pipe
    // I'm assuming that is what we are doing with Apache (not sure but this won't)
    // hurt except for a small performance hit otherwise. Unix fpwrite does not
    // have that limitation
    if NumberOfChars <= 32000 then
      WriteFile(STDOUT,PChar(s)^, NumberOfChars, NumWritten, Po)
    else
    begin
      CharsLeft := NumberOfChars;
      Idx := 1;
      NumWritten := 0;
      repeat
        if CharsLeft <= 32000 then NumberofChars := CharsLeft
        else 
          NumberOfChars := 32000;
        TPc := @S[Idx];
        WriteFile(STDOUT, TPc^ , NumberOfChars, NumWritten, Po);
        Dec(CharsLeft, NumWritten);
        Inc(Idx, NumWritten);
      until CharsLeft <= 0;
    end;
   {$ENDIF}
  end;



  procedure NativeWrite(Buffer : PChar;  NumChars : Cardinal); overload;
  begin
   {$IFDEF UNIX}
    fpwrite(STDOUT, Buffer, NumChars);
   {$ENDIF}   // *** Thats all for UNIX :)

   {$IFDEF WINDOWS}
     // Windows is a little more complex
     // because of limitations of the function
     po := nil;   // We can set the pointer to the Overlapped structure to NIL
                   // Its not needed for writing to the console.


     // If we move NativeWrite into pwumain then this can be
     // IFDEF 'ED WITH STATIC.
     // With STATIC put this call in initialization
     // It only needs to be in the function if called from DLL
     // (Win STDOUT is not alway the same handle.)
     // But it shouldn't change for one program run.
     STDOUT := GetStdHandle(STD_OUTPUT_HANDLE);

     // Windows WriteFile function is limited to 64k characters across a Named Pipe
     // (according to docs, didn't work reliably with over 32k)
     // Unix fpwrite does not have that limitation

     if NumChars <= 32000 then
       WriteFile(STDOUT, Buffer^, NumChars, NumWritten, Po)
     else
     begin
       CharsLeft := NumChars;
       Idx := 1;
       NumWritten := 0;
       TPc := Buffer;
       repeat
         If CharsLeft <= 32000 then
           NumberOfChars := CharsLeft
         else
           NumberOfChars := 32000;

         WriteFile(STDOUT, TPc^ , NumberOfChars, NumWritten, Po);
         Dec(CharsLeft, NumWritten);
         Inc(PtrUInt(TpC), NumWritten);
       until CharsLeft <= 0;
     end;
    {$ENDIF}
  end;

  procedure NativeWrite(PString : PChar); overload;
  begin
   {$IFDEF UNIX}
    fpwrite(STDOUT, PString, Strlen(PString));
   {$ENDIF}
    
   {$IFDEF WINDOWS}
     po := nil;

    // If we move NativeWrite into pwumain then this can be
    // IFDEF 'ED WITH STATIC.
    // With STATIC put this call in initialization
    // It only needs to be in the function if called from DLL
    // (Win STDOUT is not alway the same handle.)
    // But it shouldn't change for one program run. 
    STDOUT := GetStdHandle(STD_OUTPUT_HANDLE);
    NumberOfChars := Strlen(PString);
    Tpc := PString;
     // Windows WriteFile function is limited to 64k characters across a Named Pipe
     // I'm assuming that is what we are doing with Apache (not sure but this won't)
     // hurt except for a small performance hit otherwise.
     // Unix fpwrite does not have that limitation
     if NumberOfChars <= 32000 then
       WriteFile(STDOUT,PString^, NumberOfChars, NumWritten, Po)
     else
     begin
       CharsLeft := NumberOfChars;
       NumWritten := 0;
       repeat
         if CharsLeft <= 32000 then NumberofChars := CharsLeft
         else 
           NumberOfChars := 32000;
         WriteFile(STDOUT, TPc^ , NumberOfChars, NumWritten, Po);
         Dec(CharsLeft, NumWritten);
         Inc(PtrUInt(Tpc), NumWritten);
       until CharsLeft <= 0;
     end; 
    {$ENDIF}
  end;

{$ENDIF FPC}


procedure NativeWriteLn(s: astr);
begin
  NativeWrite(s + CGI_CRLF);
end;

procedure NativeWriteLn;
begin
  NativeWrite(CGI_CRLF);
end;


end.
