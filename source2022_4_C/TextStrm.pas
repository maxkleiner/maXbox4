////////////////////////////////////////////////////////////////////////////////
//
// TextStrm.pas - Text stream
// --------------------------
// Changed:   2001-05-31
// Maintain:  Michael Vinther   |   mv@logicnet·dk
//
// Contains:
//   (TBaseStream)
//     (TFilterStream)
//       (TBufferedStream)
//         TTextStream
//          TCleanTextStream
//
// Text stream with read/write buffer and support for both DOS- and UNIX-
// style text files. (Just change OutEndl).
// WriteLn euqals standard System.WriteLn(File,Str)
// WriteStr euqals standard System.Write(File,Str)
// ReadLn euqals standard System.ReadLn(File,Str)
// Standard binary Read and Write is still available
//
// TCleanTextStream is ment for use with text file parsers.
// ReadLn:  Removes all spaces (#32) in the beginning and end of a line.
//          Removes any double space (#32#32) in the line read.
//          Removes chars following a ;
//          Skips empty lines
//
// Last changes:
//   ReadLn corrected
//
unit TextStrm;

interface

uses
  Streams, BufStream, SysUtils;

var
  OutEndl : string[2] = #13#10;  // Default for new text streams
                                 // DOS standard: #13#10

  DefaultNewLineChar : Integer = -1; // -1 = Auto select #10 or #13
  DefaultSkipChar    : Integer = -1;

type
 TTextStream =
  class (TBufferedStream)
    protected
      fLineCount : Integer;
    public
      NewLineChar : Integer;
      SkipChar    : Integer;
      OutEndl : string[2];

      constructor Create(InputBufSize, OutputBufSize: Integer; NextStream: TBaseStream);
      function WriteStr(const Str: string): Integer; virtual; // Write string
      function WriteLn(const Str: string): Integer; virtual; // Write string + OutEndl
      function ReadLn(var Str: string): Integer; virtual; // Read until EOL
      function GetLine: string;
      property LineCount: Integer read fLineCount;
  end;

 TCleanTextStream =
   class (TTextStream)
     public
       function ReadLn(var Str: string): Integer; override; // Read until EOL
   end;

const
  fmRead  = 0;
  fmWrite = 1;
function OpenTextFile(Name: string; Mode: Integer): TTextStream;
function OpenCleanText(Name: string; Mode: Integer): TCleanTextStream;

implementation

uses MemUtils;

  //=======================================================================================================
// TTextStream
//=======================================================================================================

// Create a new text stream.
constructor TTextStream.Create(InputBufSize, OutputBufSize: Integer; NextStream: TBaseStream);
begin
  inherited Create(InputBufSize,OutputBufSize,NextStream);

  NewLineChar:=DefaultNewLineChar;
  SkipChar:=DefaultSkipChar;
  if fCanRead and (InputBufSize=0) then fCanRead:=False;  // Reading text requires buffer
  if fCanWrite then OutEndl:=TextStrm.OutEndl;
  fLineCount:=0;
end;

//------------------------------------------------------------------------------
// Write a string to the stream
function TTextStream.WriteStr(const Str: string): Integer;
begin
  WriteStr:=Write(Pointer(@Str[1])^,Length(Str));
end;

//------------------------------------------------------------------------------
// Write a string and OutEOL to the stream
function TTextStream.WriteLn(const Str: string): Integer;
begin
  Result:=Write(Pointer(@Str[1])^,Length(Str))+Write(OutEndl[1],Length(OutEndl));
  Inc(fLineCount);
end;

//------------------------------------------------------------------------------
// Read until NewLineChar, skip SkipChar
function TTextStream.ReadLn(var Str: string): Integer;
var
  P, P10, PSkip, Get : Integer;
begin
  if not fCanRead then raise EInOutError.Create(rs_ReadDenied);
  Result:=0;
  Str:='';
  P:=-1;
  repeat // Read until #13 or EOS
    if InBufPos>=InBufSize then // Fill buffer
    begin
      InBufSize:=Next.Read(InBuffer^,InBufMax);
      InBufPos:=0;
      if InBufSize=0 then
      begin
        if Result=0 then EInOutError.CreateFmt(rs_ReadError,[rs_ReadLessError]);
        Break;
      end;
    end;

    if NewLineChar=-1 then // Auto detech new line char
    begin
      P10:=FastLocateByte(InBuffer^,InBufPos,InBufSize,10); // Search for #10

      if P10=-1 then P:=FastLocateByte(InBuffer^,InBufPos,InBufSize,13) // Search for #13
      else P:=FastLocateByte(InBuffer^,InBufPos,P10,13);

      if (P10>=0) and (Cardinal(P10)<Cardinal(P)) then
      begin
        NewLineChar:=10;
        if SkipChar=-1 then SkipChar:=13;
        P:=P10;
        Get:=P-InBufPos;
      end
      else if P>=0 then
      begin
        NewLineChar:=13;
        if SkipChar=-1 then SkipChar:=10;
        Get:=P-InBufPos;
      end
      else Get:=InBufSize-InBufPos;

      SetLength(Str,Result+Get);
      Move(InBuffer^[InBufPos],Str[Result+1],Get);
      Inc(Result,Get); Inc(InBufPos,Get+1);
    end
    else // New line char known, read line
    begin
      PSkip:=FastLocateByte(InBuffer^,InBufPos,InBufSize,SkipChar);  // Search for SkipChar

      if PSkip=-1 then P:=FastLocateByte(InBuffer^,InBufPos,InBufSize,NewLineChar) // Search for NewLineChar
      else if PSkip>0 then P:=FastLocateByte(InBuffer^,InBufPos,PSkip+1,NewLineChar);

      if (PSkip>=0) and (Cardinal(PSkip)<Cardinal(P)) then // First char is skip char
      begin
        Get:=PSkip-InBufPos;
        P:=-1;
      end
      else
      begin
        if P>=0 then Get:=P-InBufPos // New line found
        else Get:=InBufSize-InBufPos;
      end;

      SetLength(Str,Result+Get);
      Move(InBuffer^[InBufPos],Str[Result+1],Get);
      Inc(Result,Get); Inc(InBufPos,Get+1);
    end;
  until P<>-1;
  Inc(fLineCount);
end;

function TTextStream.GetLine: string;
begin
  ReadLn(Result);
end;

function OpenTextFile(Name: string; Mode: Integer): TTextStream;
begin
  if Mode=fmRead then Result:=TTextStream.Create(-1,0,TFileStream.Create(Name,[fsRead]))
  else Result:=TTextStream.Create(0,-1,TFileStream.Create(Name,fsRewrite));
end;

//=======================================================================================================
// TCleanTextStream
//=======================================================================================================


// Removes all spaces (#32) in the beginning and end of a line and any double
// space (#32#32) in the line read.

function TCleanTextStream.ReadLn;
var P : Integer;
begin
 repeat
  inherited ReadLn(Str);

  // remove ;
  P:=Pos(';',Str);
  if P<>0 then SetLength(Str,P-1);

  // remove #32 at line end
  P:=Length(Str);
  while (P>0) and (Str[P]=' ') do Dec(P);
  SetLength(Str,P);

  // remove #32#32 in line
  P:=Pos('  ',Str);
  while P<>0 do
  begin
   Delete(Str,P,1);
   P:=Pos('  ',Str);
  end;

//  P:=0;
  while (P<Length(Str)) and (Str[P+1]=' ') do Inc(P);
  if P<>0 then Delete(Str,1,P);

 until Str<>'';
 Result:=Length(Str);
end;

function OpenCleanText(Name: string; Mode: Integer): TCleanTextStream;
begin
  if Mode=fmRead then Result:=TCleanTextStream.Create(-1,0,TFileStream.Create(Name,[fsRead]))
  else Result:=TCleanTextStream.Create(0,-1,TFileStream.Create(Name,fsRewrite));
end;

end.

