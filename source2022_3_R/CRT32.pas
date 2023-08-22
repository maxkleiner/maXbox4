{$R-}
unit crt32;
{# freeware}
{# version 1.0.0127}
{# Date 18.01.1997}
{# Author Frank Zimmer}
{# description
 Copyright © 1997, Frank Zimmer, 100703.1602@compuserve.com
 Fixes Copyrigh © 2001 Juancarlo Añez, juanco@suigeneris.org
 Fixes: Copyright © 2008 Andrew Wozniewicz, andrew@optimax.com

 Version: 1.0.0119
 Date:    18.01.1997

 an Implementation of Turbo Pascal CRT-Unit for Win32 Console Subsystem
 testet with Windows NT 4.0
 At Startup you get the Focus to the Console!!!!

 ( with * are not in the original Crt-Unit):
 Procedure and Function:
   ClrScr
   ClrEol
   WhereX
   WhereY
   GotoXY
   InsLine
   DelLine
   HighVideo
   LowVideo
   NormVideo
   TextBackground
   TextColor
   Delay             // use no processtime
   KeyPressed
   ReadKey           // use no processtime
   Sound             // with Windows NT your could use the Variables SoundFrequenz, SoundDuration
   NoSound
   *TextAttribut     // Set TextBackground and TextColor at the same time, usefull for Lastmode
   *FlushInputBuffer // Flush the Keyboard and all other Events
   *ConsoleEnd       // output of 'Press any key' and wait for key input when not pipe
   *Pipe             // True when the output is redirected to a pipe or a file

 Variables:
   WindMin           // the min. WindowRect
   WindMax           // the max. WindowRect
   *ViewMax          // the max. ConsoleBuffer start at (1,1);
   TextAttr          // Actual Attributes only by changing with this Routines
   LastMode          // Last Attributes only by changing with this Routines
   *SoundFrequenz    // with Windows NT your could use these Variables
   *SoundDuration    // how long bells the speaker  -1 until ??, default = -1
   *HConsoleInput    // the Input-handle;
   *HConsoleOutput   // the Output-handle;
   *HConsoleError    // the Error-handle;


 This Source is freeware, have fun :-)

 History
   18.01.97   the first implementation
   23.01.97   Sound, delay, Codepage inserted and setfocus to the console
   24.01.97   Redirected status
}

interface

uses
  windows,
  messages;


  //These must be called explicitly by the using app now
  procedure InitCRT32;
  procedure DoneCRT32;

  procedure SetCRT32Title(const ATitle: String);
  function GetCRT32Title: String;


{$ifdef win32}
const
  Intense         = FOREGROUND_INTENSITY or BACKGROUND_INTENSITY;
  Black           = 0;
  Blue            = FOREGROUND_BLUE  or BACKGROUND_BLUE;
  Green           = FOREGROUND_GREEN or BACKGROUND_GREEN;
  Cyan            = Blue and Green;
  Red             = FOREGROUND_RED   or BACKGROUND_RED;
  Magenta         = Blue or Red;
  Brown           = Green or Red;
  LightGray       = Blue or Green or Red;
  DarkGray        = LightGray;
  LightBlue       = Blue or Intense;
  LightGreen      = Green or Intense;
  LightCyan       = Cyan or Intense;
  LightRed        = Red or Intense;
  LightMagenta    = Magenta or Intense;
  Yellow          = Brown or Intense;
  White           = LightGray or Intense;

  BackgroundMask = BACKGROUND_BLUE or BACKGROUND_GREEN or BACKGROUND_RED or BACKGROUND_INTENSITY;
  ForegroundMask = FOREGROUND_BLUE or FOREGROUND_GREEN or FOREGROUND_RED or FOREGROUND_INTENSITY;

  Function WhereX: integer;
  Function WhereY: integer;
  procedure ClrEol;
  procedure ClrScr;
  procedure InsLine;
  Procedure DelLine;
  Procedure GotoXY(const x,y:integer);
  procedure HighVideo;
  procedure LowVideo;
  procedure NormVideo;
  procedure TextBackground(const Color:word);
  procedure TextColor(const Color:word);
  procedure TextAttribut(const Color,Background:word);
  procedure Delay(const ms:integer);
  function KeyPressed:boolean;
  function ReadKey:Char;
  Procedure Sound;
  Procedure NoSound;
  procedure ConsoleEnd;
  procedure FlushInputBuffer;
  Function Pipe:boolean;

  procedure Restore;

  procedure SetWindowTo(R :TSmallRect);



var
  HConsoleInput:tHandle;
  HConsoleOutput:thandle;
  HConsoleError:Thandle;
  WindMin:tcoord;
  WindMax:tcoord;
  ViewMax:tcoord;
  TextAttr : Word;
  LastMode : Word;
  SoundFrequenz :Integer;
  SoundDuration : Integer;

type
  PD3InputRecord = ^TD3InputRecord;
  TD3InputRecord = record
    EventType: Word;
    case Integer of
      0: (KeyEvent: TKeyEventRecord);
      1: (MouseEvent: TMouseEventRecord);
      2: (WindowBufferSizeEvent: TWindowBufferSizeRecord);
      3: (MenuEvent: TMenuEventRecord);
      4: (FocusEvent: TFocusEventRecord);
  end;

{$endif win32}

implementation
{$ifdef win32}
uses sysutils;
var
  StartAttr:word;
  OldCP:integer;
  CrtPipe : Boolean;

procedure SetCRT32Title(const ATitle: String);
begin
  Windows.SetConsoleTitle(PChar(ATitle));
end;

function GetCRT32Title: String;
var
  LSize: DWORD;
begin
  SetLength(Result,MAX_PATH);
  LSize := Windows.GetConsoleTitle(PChar(Result),Max_Path);
  SetLength(Result,LSize);
end;


procedure ClrEol;
var tC :tCoord;
  Len,Nw: LongWord;
  Cbi : TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo(HConsoleOutput,cbi);
  len := cbi.dwsize.x-cbi.dwcursorposition.x;
  tc.x := cbi.dwcursorposition.x;
  tc.y := cbi.dwcursorposition.y;
  FillConsoleOutputAttribute(HConsoleOutput,textattr,len,tc,nw);
  FillConsoleOutputCharacter(HConsoleOutput,#32,len,tc,nw);
end;

procedure ClrScr;
var tc :tcoord;
  nw  : LongWord;
  cbi : TConsoleScreenBufferInfo;
begin
  getConsoleScreenBufferInfo(HConsoleOutput,cbi);
  tc.x := 0;
  tc.y := 0;
  FillConsoleOutputAttribute(HConsoleOutput,textattr,cbi.dwsize.x*cbi.dwsize.y,tc,nw);
  FillConsoleOutputCharacter(HConsoleOutput,#32,cbi.dwsize.x*cbi.dwsize.y,tc,nw);
  setConsoleCursorPosition(hconsoleoutput,tc);
end;

Function WhereX: integer;
var cbi : TConsoleScreenBufferInfo;
begin
  getConsoleScreenBufferInfo(HConsoleOutput,cbi);
  result := tcoord(cbi.dwCursorPosition).x+1
end;

Function WhereY: integer;
var cbi : TConsoleScreenBufferInfo;
begin
  getConsoleScreenBufferInfo(HConsoleOutput,cbi);
  result := tcoord(cbi.dwCursorPosition).y+1
end;

Procedure GotoXY(const x,y:integer);
var coord :tcoord;
begin
  coord.x := x-1;
  coord.y := y-1;
  setConsoleCursorPosition(hconsoleoutput,coord);
end;

procedure InsLine;
var
 cbi : TConsoleScreenBufferInfo;
 ssr:tsmallrect;
 coord :tcoord;
 ci :tcharinfo;
 nw :LongWord;
begin
  getConsoleScreenBufferInfo(HConsoleOutput,cbi);
  coord := cbi.dwCursorPosition;
  ssr.left := 0;
  ssr.top := coord.y;
  ssr.right := cbi.srwindow.right;
  ssr.bottom := cbi.srwindow.bottom;
  ci.asciichar := #32;
  ci.attributes := cbi.wattributes;
  coord.x := 0;
  coord.y := coord.y+1;
  ScrollConsoleScreenBuffer(HconsoleOutput,ssr,nil,coord,ci);
  coord.y := coord.y-1;
  FillConsoleOutputAttribute(HConsoleOutput,textattr,cbi.dwsize.x*cbi.dwsize.y,coord,nw);
end;

procedure DelLine;
var
 cbi : TConsoleScreenBufferInfo;
 ssr:tsmallrect;
 coord :tcoord;
 ci :tcharinfo;
 nw:LongWord;
begin
  getConsoleScreenBufferInfo(HConsoleOutput,cbi);
  coord := cbi.dwCursorPosition;
  ssr.left := 0;
  ssr.top := coord.y+1;
  ssr.right := cbi.srwindow.right;
  ssr.bottom := cbi.srwindow.bottom;
  ci.asciichar := #32;
  ci.attributes := cbi.wattributes;
  coord.x := 0;
  coord.y := coord.y;
  ScrollConsoleScreenBuffer(HconsoleOutput,ssr,nil,coord,ci);
  FillConsoleOutputAttribute(HConsoleOutput,textattr,cbi.dwsize.x*cbi.dwsize.y,coord,nw);
end;

procedure TextBackground(const Color:word);
begin
  LastMode := TextAttr;
  textattr := Color and BackgroundMask; 
  SetConsoleTextAttribute(hconsoleoutput,textattr);
end;

procedure TextColor(const Color:word);
begin
  LastMode := TextAttr;
  textattr := color and ForegroundMask;
  SetConsoleTextAttribute(hconsoleoutput,textattr);
end;

procedure TextAttribut(const Color,Background:word);
begin
  LastMode := TextAttr;
  textattr := (color and ForegroundMask) or (Background and BackgroundMask);
  SetConsoleTextAttribute(hconsoleoutput,textattr);
end;

procedure Restore;
begin
  SetConsoleTextAttribute(hconsoleoutput,LastMode);
  textattr := LastMode;
end;

procedure HighVideo;
begin
  LastMode := TextAttr;
  textattr := textattr or $8;
  SetConsoleTextAttribute(hconsoleoutput,textattr);
end;

procedure LowVideo;
begin
  LastMode := TextAttr;
  textattr := textattr and $f7;
  SetConsoleTextAttribute(hconsoleoutput,textattr);
end;

procedure NormVideo;
begin
  LastMode := TextAttr;
  textattr := startAttr;
  SetConsoleTextAttribute(hconsoleoutput,textattr);
end;

procedure FlushInputBuffer;
begin
  FlushConsoleInputBuffer(hconsoleinput)
end;

function keypressed:boolean;
var
  InputRec:array[1..32] of TInputRecord;
  i,
  NumRead  :LongWord;
  NEvents  :DWORD;
begin
  Result := False;
  if GetNumberOfConsoleInputEvents(HConsoleInput, NEvents)
  and (NEvents > 0)
  and PeekConsoleInput(HConsoleInput, InputRec[1], 32, NumRead)
  and (NumRead > 0) then
     for i := 1 to NumRead do
         if  (InputRec[i].EventType = KEY_EVENT)
         and (PD3InputRecord(@InputRec[i]).KeyEvent.bKeyDown) then begin
            Result := True;
            Exit
         end
end;

function ReadKey: Char;
var
  NumRead:       DWORD;
  InputRec:      TInputRecord;
begin
  while not ReadConsoleInput(HConsoleInput, InputRec, 1, NumRead)
  or (InputRec.EventType <> KEY_EVENT)
  or (not PD3InputRecord(@InputRec).KeyEvent.bKeyDown) do begin
  end;
  Result := PD3InputRecord(@InputRec).KeyEvent.AsciiChar
end;

procedure delay(const ms:integer);
begin
  sleep(ms);
end;

Procedure Sound;
begin
  windows.beep(SoundFrequenz,soundduration);
end;

Procedure NoSound;
begin
  windows.beep(soundfrequenz,0);
end;

procedure ConsoleEnd;
begin
  if isconsole and not crtpipe then
  begin
    if wherex > 1 then writeln;
    textcolor(green);
    setfocus(GetCurrentProcess);
    NormVideo;
    FlushInputBuffer;
    ReadKey;
    FlushInputBuffer;
  end;
end;

function Pipe:boolean;
begin
  result := crtpipe;
end;



procedure SetWindowTo(R: TSmallRect);
begin
  SetConsoleWindowInfo(HConsoleOutput, TRUE, R)
end;


procedure InitCRT32;
var
  cbi : TConsoleScreenBufferInfo;
  tc : tcoord;
begin
  if HConsoleOutput <> 0 then
    Exit;
  SetActiveWindow(0);
  AllocConsole;
  HConsoleInput := GetStdHandle(STD_INPUT_HANDLE);
  HConsoleOutput := GetStdHandle(STD_OUTPUT_HANDLE);
  HConsoleError := GetStdHandle(STD_Error_HANDLE);
  if getConsoleScreenBufferInfo(HConsoleOutput,cbi) then begin
    TextAttr := cbi.wAttributes;
    StartAttr := cbi.wAttributes;
    lastmode  := cbi.wAttributes;
    tc.x := cbi.srwindow.left+1;
    tc.y := cbi.srwindow.top+1;
    windmin := tc;
    ViewMax := cbi.dwsize;
    tc.x := cbi.srwindow.right+1;
    tc.y := cbi.srwindow.bottom+1;
    windmax := tc;
    crtpipe := false;
  end else
    crtpipe := true;
  SoundFrequenz := 1000;
  SoundDuration := -1;
  OldCP := GetConsoleoutputCP;
end;


procedure DoneCRT32;
begin
  FreeConsole;
  HConsoleOutput := 0;
  HConsoleInput := 0;
end;


{$endif win32}
end.

