{ **********************************************************************
  *                         Unit INTERFAC.PAS                          *
  *                            Version 1.1                             *
  *                     (c) J. Debord, April 1997                      *
  **********************************************************************
                        DOS interfacing routines
  ********************************************************************** }

unit InterFac;

interface

uses
  Crt, Dos, Printer, FMath, Matrices, PaString;

{ ****************************** Constants ***************************** }

(*----------------------------------------------------------------------
  The following constant defines the maximum number of lines from a text
  file which may be viewed with the ViewFile procedure. The given value
  of 3000 lines corresponds to a program compiled in real mode, with a
  default stack size of 16K. It may be increased to about 6000 if the
  compiler directive {$M 30000, 0, 550000} is used in the calling program,
  and if the required amount of free conventional memory is present. In
  protected mode it may be increased to 15000, with the compiler directive
  {$M 65000} in the calling program.
  ----------------------------------------------------------------------*)
const
  MAXLINE = 3000;

{ ----------------------------------------------------------------------
  The following constant defines the maximum number of files in a
  directory. May be increased up to the value of MAXLINE.
  ---------------------------------------------------------------------- }
const
  MAXFILE = 1000;

{ ----------------------------------------------------------------------
  Screen color attributes
  ---------------------------------------------------------------------- }
const
  ATT_FD = $02;  { File display }
  ATT_NT = $07;  { Normal text }
  ATT_CD = $13;  { Command description }
  ATT_PM = $17;  { Prompt message }
  ATT_ES = $1A;  { Entry string }
  ATT_HC = $1E;  { Highlighted character }
  ATT_FB = $1F;  { Frame border }
  ATT_EM = $4E;  { Error message }
  ATT_EP = $4F;  { Error prompt }
  ATT_IV = $70;  { Inverse video }

{ ----------------------------------------------------------------------
  Cursor keys (for the 2 character codes, only the 2nd char. is given)
  ---------------------------------------------------------------------- }
const
  _HOME       = 'G';
  _END        = 'O';
  _INS        = 'R';
  _DEL        = 'S';
  ARROW_UP    = 'H';
  ARROW_DOWN  = 'P';
  ARROW_LEFT  = 'K';
  ARROW_RIGHT = 'M';
  PAGE_UP     = 'I';
  PAGE_DOWN   = 'Q';
  CTRL_HOME   = 'w';
  CTRL_END    = 'u';
  BACKSPACE   = #8;
  TAB         = #9;
  ENTER       = #13;
  SHIFT_TAB   = #15;
  ESCAPE      = #27;

{ ----------------------------------------------------------------------
  Other constants
  ---------------------------------------------------------------------- }
const
  NFUNKEY  = 10;   { Number of function keys }
  MAXCHAR  = 10;   { Max number of options in a one-character entry }
  MAXFIELD = 400;  { Max number of entry fields in a mask }
  MAXELEM  = 400;  { Max number of elements in a list or menu }

{ ----------------------------------------------------------------------
  Language-dependent string constants. The default language is English.
  To use French, define the symbol FRENCH in the compiler 'Conditional
  Defines' option.
  ---------------------------------------------------------------------- }
{$IFDEF FRENCH}
  {$I FRENCH.INC}
{$ELSE}
  {$I ENGLISH.INC}
{$ENDIF}

{ ************************** Global variables ************************** }

const
  DefDir : String = '';        { Default directory }
  DefExt : String[3] = 'TXT';  { Default extension }
  IOerr  : Boolean = False;    { Flags an I/O error }

{ ******************************** Types ******************************* }

type
  KeyNumSet = set of 1..NFUNKEY;  { Set of function key numbers }
  TOpt      = String[MAXCHAR];
  String80  = String[80];
  String40  = String[40];

  TEntryCode =
  (S_FIELD,     { String }
   C_FIELD,     { Character }
   N_FIELD,     { Integer }
   F_FIELD);    { Float }

  TEntryField =
    record
      X, Y      : Integer;          { Field coordinates }
      Msg       : String40;         { Prompt message }
      Long      : Integer;          { Field length }
      S         : String80;         { Entered string }
      Upper     : Boolean;          { Force upper case }
      case Code : TEntryCode of
        C_FIELD : (Opt : TOpt;      { Allowed characters }
                   C   : Char);     { Entered character }
        N_FIELD : (NLo : Integer;   { Low bound }
                   NHi : Integer;   { High bound }
                   N   : Integer);  { Entered value }
        F_FIELD : (FLo : Float;     { Low bound }
                   FHi : Float;     { High bound }
                   F   : Float);    { Entered value }
    end;

  TEntryMask = array[1..MAXFIELD] of TEntryField;
  PEntryMask = ^TEntryMask;

  TPickList = array[0..MAXELEM] of String80;
  PPickList = ^TPickList;

  TMenuElem =
    record
      Opt  : String40;
      Help : String80;
    end;

  TMenu = array[0..MAXELEM] of TMenuElem;
  PMenu = ^TMenu;

{ ************************** General routines ************************** }

procedure HideCursor;
{ ----------------------------------------------------------------------
  Hides the cursor
  ---------------------------------------------------------------------- }

procedure FlatCursor;
{ ----------------------------------------------------------------------
  Displays a flat cursor
  ---------------------------------------------------------------------- }

procedure FullCursor;
{ ----------------------------------------------------------------------
  Displays a full box cursor
  ---------------------------------------------------------------------- }

procedure MsgErr(Msg : String);
{ ----------------------------------------------------------------------
  Displays an error message on the last line of the screen
  ---------------------------------------------------------------------- }

procedure IOcheck;
(*----------------------------------------------------------------------
  Checks if an I/O error has occurred. If so, the global variable IOerr
  is set to TRUE and an error message is displayed.
  Ex. {$I-}
      Read(InFile, Data);
      {$I+}
      IOcheck;
      if IOerr then...
  ----------------------------------------------------------------------*)

procedure ShellDOS;
{ ----------------------------------------------------------------------
  Opens a DOS session from within a program
  ---------------------------------------------------------------------- }

procedure Frame(Title : String80; X1, Y1, X2, Y2, N, Attr : Integer;
                Filled : Boolean);
{ ----------------------------------------------------------------------
  Draws a frame on the screen
  ----------------------------------------------------------------------
  Input parameters :
    Title  = Title to be written on top of the frame
    X1, Y1 = Coordinates of the upper left corner of the frame
    X2, Y2 = Coordinates of the lower right corner of the frame
    N      = Number of lines (1 or 2)
    Attr   = color attribute
    Filled = TRUE to fill the frame with the background color
  ---------------------------------------------------------------------- }

procedure DisplayCmdLine(CmdLine : String80; LineIndex : Integer);
{ ----------------------------------------------------------------------
  Displays a list of command characters and their descriptions,
  with the command characters enlighted.
  ----------------------------------------------------------------------
  Input parameters :
    CmdLine   = String containing command characters and descriptions
                Use character '-' between a command and its description
                Use at least 2 spaces between different commands
                Ex. : 'f1-Help  O-open   Esc-quit'
    LineIndex = Index of the line where the string must be displayed
  ---------------------------------------------------------------------- }

{ ********************** File handling routines ************************ }

procedure ChangeDir;
{ ----------------------------------------------------------------------
  Changes default directory and extension
  ---------------------------------------------------------------------- }

function ReadFileName(var FileName : String) : Boolean;
{ ----------------------------------------------------------------------
  Reads a file name. If FileName contains jokers, the directory list is
  displayed and the file may be selected with the arrow keys.
  ----------------------------------------------------------------------
  Returned value :
    TRUE  if <Enter> is pressed (validates entry)
    FALSE if <Esc> is pressed (escapes entry)
  ---------------------------------------------------------------------- }

{ ----------------------------------------------------------------------
  The following Open... routines open a text file for input or output
  ----------------------------------------------------------------------
  Common input parameter :
    FileName = name of file to open
  ----------------------------------------------------------------------
  Common output parameter :
    F = text file
  ----------------------------------------------------------------------
  Returned value :
    TRUE  if file opened correctly
    FALSE if an error occurred
  ---------------------------------------------------------------------- }

function OpenInput(FileName : String; var F : Text) : Boolean;
{ ----------------------------------------------------------------------
  Opens a text file for input
  ---------------------------------------------------------------------- }

function OpenOutput(FileName : String; Replace : Boolean;
                    var F : Text) : Boolean;
{ ----------------------------------------------------------------------
  Opens a text file for output
  ----------------------------------------------------------------------
  Specific input parameter :
    Replace = TRUE  to replace an existing file
              FALSE to append to an existing file
  ---------------------------------------------------------------------- }

procedure ViewFile(FileName : String);
{ ----------------------------------------------------------------------
  Displays an ASCII file
  ---------------------------------------------------------------------- }

{ *************************** Input routines *************************** }

procedure DimEntryMask(var Mask : PEntryMask; N : Integer);
{ ----------------------------------------------------------------------
  Creates an entry mask with N fields
  ---------------------------------------------------------------------- }

procedure DelEntryMask(var Mask : PEntryMask; N : Integer);
{ ----------------------------------------------------------------------
  Deletes an entry mask
  ---------------------------------------------------------------------- }

{ ----------------------------------------------------------------------
  The following Init... routines initialize the fields of an entry mask
  ----------------------------------------------------------------------
  Common input parameters :
    X, Y = screen coordinates where the prompt message will be written
    Msg  = prompt message
  ----------------------------------------------------------------------
  Common output parameter :
    Field = entry field
  ---------------------------------------------------------------------- }

procedure InitStrField(X, Y : Integer; Msg : String;
                       Upper : Boolean; MaxLen : Integer; S : String;
                       var Field : TEntryField);
{ ----------------------------------------------------------------------
  Initializes a string field
  ----------------------------------------------------------------------
  Specific input parameters :
    Upper  = TRUE to force uppercase characters
    MaxLen = maximum string length
    S      = initial string value
  ---------------------------------------------------------------------- }

procedure InitCharField(X, Y : Integer; Msg : String;
                        Opt : TOpt; Ch : Char;
                        var Field : TEntryField);
{ ----------------------------------------------------------------------
  Initializes a character field
  ----------------------------------------------------------------------
  Specific input parameters :
    Opt = string of allowed characters
    Ch  = initial character value
  ---------------------------------------------------------------------- }

procedure InitIntField(X, Y : Integer; Msg : String;
                       NLo, NHi, N : Integer;
                       var Field : TEntryField);
{ ----------------------------------------------------------------------
  Initializes an integer field
  ----------------------------------------------------------------------
  Specific input parameters :
    NLo, NHi = bounds of integer value
               (set NLo = NHi if no bounds are used)
    N        = initial integer value
  ---------------------------------------------------------------------- }

procedure InitFloatField(X, Y : Integer; Msg : String;
                         FLo, FHi, F : Float;
                         var Field : TEntryField);
{ ----------------------------------------------------------------------
  Initializes a floating point field
  ----------------------------------------------------------------------
  Specific input parameters :
    NLo, NHi = bounds of float value
               (set FLo = FHi if no bounds are used)
    F        = initial float value
  ---------------------------------------------------------------------- }

function ReadMask(Mask : PEntryMask; N : Integer) : Char;
{ ----------------------------------------------------------------------
  Reads data from an entry mask
  ----------------------------------------------------------------------
  Input/output parameter :
    Mask = entry mask
  Input parameter :
    N = number of fields
  ----------------------------------------------------------------------
  Returned value :
    the code of the key pressed to terminate the entry, i.e.
    PAGE_UP, PAGE_DOWN, CTRL_HOME, CTRL_END, ESCAPE or ENTER
  ---------------------------------------------------------------------- }

{ ----------------------------------------------------------------------
  The following Read... routines read a single variable. The parameters
  have the same meanings than in the Init... routines
  ----------------------------------------------------------------------
  Returned value :
    TRUE  if <Enter> is pressed (validates entry)
    FALSE if <Esc> is pressed (escapes entry)
  ---------------------------------------------------------------------- }

function ReadString(X, Y : Integer; Msg : String; Upper : Boolean;
                    MaxLen : Integer; var S : String) : Boolean;
{ ----------------------------------------------------------------------
  Reads a character string
  ---------------------------------------------------------------------- }

function ReadChar(X, Y : Integer; Msg : String; Opt : TOpt;
                  var Ch : Char) : Boolean;
{ ----------------------------------------------------------------------
  Reads a character among those of the string Opt
  ---------------------------------------------------------------------- }

function ReadInteger(X, Y : Integer; Msg : String; NLo, NHi : Integer;
                     var N : Integer) : Boolean;
{ ----------------------------------------------------------------------
  Reads an integer belonging to the interval [NLo..NHi]
  ---------------------------------------------------------------------- }

function ReadFloat(X, Y : Integer; Msg : String; FLo, FHi : Float;
                   var F : Float) : Boolean;
{ ----------------------------------------------------------------------
  Reads a floating point number belonging to the interval [FLo..FHi]
  ---------------------------------------------------------------------- }

function YesNo(X, Y : Integer; Msg : String; var Ans : Boolean) : Boolean;
{ ----------------------------------------------------------------------
  Reads a response of type Yes/No
  Output parameter : Ans = TRUE for Yes, FALSE for no
  ---------------------------------------------------------------------- }

function ReadFunKey(KeyNum : KeyNumSet) : Integer;
{ ----------------------------------------------------------------------
  Returns the index of the function key which has been pressed,
  among those of the set KeyNum
  ---------------------------------------------------------------------- }

{ ************************* Pick list routines ************************* }

procedure DimPickList(var List : PPickList; N : Integer);
{ ----------------------------------------------------------------------
  Creates a pick list with N elements
  ---------------------------------------------------------------------- }

procedure DelPickList(var List : PPickList; N : Integer);
{ ----------------------------------------------------------------------
  Deletes a pick list
  ---------------------------------------------------------------------- }

{ ----------------------------------------------------------------------
  The following two routines allow choosing one or several elements
  from a list
  ----------------------------------------------------------------------
  Common input parameters :
    Nelem           = number of elements
    Ncol            = number of columns to display
    FirstLine       = index of first line to display
    List            = pick list, such that :
                        List^[0]        = list title
                        List^[1..Nelem] = element names
                                          (must have the same length)
  ----------------------------------------------------------------------
  Returned value :
    TRUE  if <Enter> is pressed (validates choice)
    FALSE if <Esc> is pressed (escapes choice)
  ---------------------------------------------------------------------- }

function Pick(Nelem, Ncol, FirstLine : Integer; List : PPickList;
              var Select : Integer) : Boolean;
{ ----------------------------------------------------------------------
  Picks a single element from a list
  ----------------------------------------------------------------------
  Output parameter :
    Select = index of the selected element
  ---------------------------------------------------------------------- }

function MPick(Nelem, Ncol, FirstLine : Integer; List : PPickList;
               Select : PBoolVector) : Boolean;
{ ----------------------------------------------------------------------
  Picks multiple elements from a list
  ----------------------------------------------------------------------
  Output parameter :
    Select = array containing the selection status of each element
             (i.e. Select^[I] = TRUE if element I is selected)
  ---------------------------------------------------------------------- }

{ **************************** Menu routines *************************** }

procedure DimMenu(var Menu : PMenu; N : Integer);
{ ----------------------------------------------------------------------
  Creates a menu with N options
  ---------------------------------------------------------------------- }

procedure DelMenu(var Menu : PMenu; N : Integer);
{ ----------------------------------------------------------------------
  Deletes a menu
  ---------------------------------------------------------------------- }

procedure InitMenuElem(Opt : String40; Help : String80;
                       var Elem : TMenuElem);
{ ----------------------------------------------------------------------
  Initializes a menu element
  ----------------------------------------------------------------------
  Input parameters :
    Opt  = option name, with at least one uppercase character (will be
           used as command character)
    Help = help text
  ----------------------------------------------------------------------
  Output parameter :
    Elem = menu element
  ---------------------------------------------------------------------- }

function ReadMenu(Nopt : Integer; Menu : PMenu;
                  var Select : Integer) : Boolean;
{ ----------------------------------------------------------------------
  Chooses an option in a menu
  ----------------------------------------------------------------------
  Input parameters :
    Nopt = number of options
    Menu = option names & help texts
  ----------------------------------------------------------------------
  Output parameter :
    Select = index of the selected element
  ----------------------------------------------------------------------
  Returned value :
    TRUE  if <Enter> or a command character is pressed (validates choice)
    FALSE if <Esc> is pressed (escapes choice)
  ---------------------------------------------------------------------- }

implementation

var
  Curs1, Curs2 : Integer;  { First and last cursor lines }

  procedure SaveCursor;
  var
    R : Registers;
  begin
    R.AH := 3;
    R.BH := 0;
    Intr($10, R);
    Curs1 := R.CH;
    Curs2 := R.CL;
  end;

  procedure DrawCursor(L1, L2 : Integer);
  { Draws the cursor between lines L1 and L2 }
  var
    R : Registers;
  begin
    R.AH := 1;
    R.CH := L1;
    R.CL := L2;
    Intr($10, R);
  end;

  procedure HideCursor;
  begin
    DrawCursor(Curs2 + 2, 0);
  end;

  procedure FlatCursor;
  begin
    DrawCursor(Pred(Curs2), Curs2);
  end;

  procedure FullCursor;
  begin
    DrawCursor(0, Curs2);
  end;

  procedure MsgErr(Msg : String);
  var
    C : Char;
  begin
    TextAttr := ATT_EM;
    GotoXY(1, 25); ClrEol;
    Write(Msg);
    TextAttr := ATT_EP;
    GotoXY(80 - Length(MSG_KEY), 25);
    Write(MSG_KEY, ^G);
    C := ReadKey;
    if C = #0 then C := ReadKey;
    GotoXY(1, 25);
    TextAttr := ATT_NT;
    ClrEol;
  end;

  procedure IOcheck;
  var
    IOcode : Integer;
  begin
    IOcode := IoResult;
    IOerr := IOcode <> 0;
    if IOerr then
      case IOcode of
        2 : MsgErr(MSG_ERR_2);
        3 : MsgErr(MSG_ERR_3);
        4 : MsgErr(MSG_ERR_4);
        5 : MsgErr(MSG_ERR_5);
        6 : MsgErr(MSG_ERR_6);
        12 : MsgErr(MSG_ERR_12);
        15 : MsgErr(MSG_ERR_15);
        16 : MsgErr(MSG_ERR_16);
        17 : MsgErr(MSG_ERR_17);
        100 : MsgErr(MSG_ERR_100);
        101 : MsgErr(MSG_ERR_101);
        102 : MsgErr(MSG_ERR_102);
        103 : MsgErr(MSG_ERR_103);
        104 : MsgErr(MSG_ERR_104);
        105 : MsgErr(MSG_ERR_105);
        106 : MsgErr(MSG_ERR_106);
      else
        MsgErr(MSG_ERR_UNK);
      end;
  end;

  procedure ShellDOS;
  begin
    Window(1, 1, 80, 25);
    FlatCursor;
    TextAttr := ATT_NT;
    ClrScr;
    WriteLn(MSG_EXIT);
    SwapVectors;
    Exec(GetEnv('COMSPEC'), '');
    if DosError = 8 then
      begin
        ClrScr;
        MsgErr(MSG_MEM);
      end;
    SwapVectors;
    HideCursor;
  end;

  procedure Frame(Title : String80; X1, Y1, X2, Y2, N, Attr : Integer;
                  Filled : Boolean);
  var
    Width, Long, Y : Integer;
    Symbol         : String[6];
  begin
    case N of
      1 : Symbol := '³ÄÚ¿ÀÙ';
      2 : Symbol := 'ºÍÉ»È¼';
    end;
    Width := X2 - X1 - 1;
    if Title <> '' then
      Title := ' ' + Title + ' ';
    Long := Length(Title);
    TextAttr := Attr;
    if Filled then
      begin
        Window(Succ(X1), Succ(Y1), Pred(X2), Pred(Y2));
        ClrScr;
        Window(1, 1, 80, 25);
      end;
    GotoXY(X1, Y1);
    Write(Symbol[3], StrChar((Width - Long) div 2, Symbol[2]), Title);
    Write(StrChar(X2 - WhereX, Symbol[2]), Symbol[4]);
    for Y := Succ(Y1) to Pred(Y2) do
      begin
        GotoXY(X1, Y);
        Write(Symbol[1]);
        GotoXY(X2, Y);
        Write(Symbol[1]);
      end;
    GotoXY(X1, Y2);
    Write(Symbol[5], StrChar(Width, Symbol[2]), Symbol[6]);
    TextAttr := ATT_NT;
  end;

  procedure DisplayCmdLine(CmdLine : String80; LineIndex : Integer);
  var
    I : Integer;
  begin
    GotoXY(1, LineIndex);
    TextAttr := ATT_FB;
    ClrEol;
    for I := 1 to Length(CmdLine) do
      begin
        if CmdLine[I] = '-' then
          TextAttr := ATT_CD
        else if (CmdLine[I] = ' ') and (CmdLine[I + 1] = ' ') then
          TextAttr := ATT_FB;
        Write(CmdLine[I]);
      end;
    TextAttr := ATT_NT;
  end;

  function ReadFunKey(KeyNum : KeyNumSet) : Integer;
  const
    KeyCode = ';<=>?@ABCD';  { 2nd key code, F1 to F10 }
  var
    I : Integer;
    C : Char;
  begin
    I := 0;
    repeat
      C := ReadKey;
      if C = #0 then
        begin
          C := ReadKey;
          I := Pos(C, KeyCode);
        end;
    until (I > 0) and (I in KeyNum);
    ReadFunKey := I;
  end;

  function ExtractDir(FileName : String) : String;
  { Extracts directory name from file name }
  var
    Dir  : DirStr;
    Name : NameStr;
    Ext  : ExtStr;
  begin
    FSplit(FileName, Dir, Name, Ext);
    ExtractDir := Dir;
  end;

  function CompleteFileName(FileName : String) : String;
  { Adds default directory and extension to file name, if necessary }
  var
    Dir  : DirStr;
    Name : NameStr;
    Ext  : ExtStr;
    S    : String;
  begin
    S := FileName;
    FSplit(S, Dir, Name, Ext);
    if Dir = '' then
      S := DefDir + '\' + S;
    if Ext = '' then
      S := S + '.' + DefExt;
    CompleteFileName := S;
  end;

  function ReadFileName(var FileName : String) : Boolean;
  const
    X1 = 19; Y1 = 5;   { Frame coordinates: upper left  }
    X2 = 62; Y2 = 23;  { Frame coordinates: lower right }
  type
    TDirList = array[1..MAXFILE] of ^String40;
  var
    DirInfo   : SearchRec;  { File info }
    DirList   : TDirList;   { Array of pointers to the file names }
    N         : Integer;    { Number of files }
    FirstLine : Integer;    { Index of first line displayed }
    Select    : Integer;    { Index of selected file }
    C         : Char;       { Command character }
    K         : Integer;    { Loop variable }

    function DirString(DirInfo : SearchRec) : String;
    { Creates a string corresponding to a directory entry }
    var
      Day, Hour, Min : String[2];
      Year           : String[4];
      Size           : String[8];
      DT             : DateTime;
    begin
      UnpackTime(DirInfo.Time, DT);
      Str(DirInfo.Size:8, Size);
      Str(DT.Year, Year);

      Str(DT.Day:2, Day);
      if Day[1] = ' ' then Day[1] := '0';

      Str(DT.Hour:2, Hour);
      if Hour[1] = ' ' then Hour[1] := '0';

      Str(DT.Min:2, Min);
      if Min[1] = ' ' then Min[1] := '0';

      DirString := RFill(DirInfo.Name, 12) + Size + '  '
      + Day + '-' + MonthName[DT.Month] + '-' + Year
      + '  ' + Hour + ':' + Min;
    end;

    procedure DirSort;
    { Sorts directory entries in ascending order }
      procedure Sort(L, R : Integer);
      var
        I, J : Integer;
        U, V : String40;
      begin
        I := L;
        J := R;
        U := DirList[(L + R) div 2]^;
        repeat
          while DirList[I]^ < U do I := I + 1;
          while U < DirList[J]^ do J := J - 1;
          if I <= J then
            begin
              V := DirList[I]^;
              DirList[I]^ := DirList[J]^;
              DirList[J]^ := V;
              I := I + 1;
              J := J - 1;
            end;
        until I > J;
        if L < J then Sort(L, J);
        if I < R then Sort(I, R);
      end;
    begin
      Sort(1, N);
    end;

    procedure DisplayPage;
    var
      I, K : Integer;
    begin
      K := FirstLine;
      for I := 1 to (Y2 - Y1 - 1) do
        begin
          GotoXY(1, I);
          if K <= N then
            begin
              if K = Select then
                TextAttr := ATT_IV
              else
                TextAttr := ATT_PM;
              Write(DirList[K]^);
            end;
          Inc(K);
        end;
      TextAttr := ATT_NT;
    end;

    function ReadCmd : Char;
    { Reads a command key and scrolls the screen if necessary }
    var
      C1, C2     : Char;
      NL, NL1, D : Integer;
    begin
      NL := Y2 - Y1 - 1;  { Number of lines displayed }
      NL1 := Succ(NL);
      C1 := Upcase(ReadKey);
      if C1 = #0 then
        begin
          C2 := ReadKey;
          case C2 of
            _HOME : begin
                      FirstLine := 1;
                      Select := 1;
                   end;
            _END : begin
                     if N > NL then
                       FirstLine := N - NL + 1;
                     Select := N;
                   end;
            ARROW_UP : if Select > 1 then
                         begin
                           Dec(Select);
                           if Select < FirstLine then
                             Dec(FirstLine);
                         end;
            ARROW_DOWN : if Select < N then
                           begin
                             Inc(Select);
                             if Select > FirstLine + NL - 1 then
                               Inc(FirstLine);
                           end;
            PAGE_UP : begin
                        D := Select - FirstLine;
                        if FirstLine > NL then
                          Dec(FirstLine, NL)
                        else
                          FirstLine := 1;
                        Select := FirstLine + D;
                      end;
            PAGE_DOWN : begin
                          D := Select - FirstLine;
                          if FirstLine < N - 2 * NL1 + 1 then
                            Inc(FirstLine, NL)
                          else if N > NL then
                            FirstLine := N - NL + 1;
                          Select := FirstLine + D;
                        end;
          end;
        end;
      ReadCmd := C1;
    end;

  begin
    N := 0;
    Frame('', 5, 5, 76, 7, 1, ATT_FB, True);
    FileName := CompleteFileName(FileName);
    if not ReadString(8, 6, MSG_FILE_NAME, True, 63 - Length(MSG_FILE_NAME),
                      FileName) then
      begin
        ReadFileName := False;
        Exit;
      end;

    { Clear entry mask }
    Window(5, 5, 76, 7); ClrScr;
    Window(1, 1, 80, 25);

    if (Pos('*', FileName) > 0) or (Pos('?', FileName) > 0) then
      begin
        FindFirst(FileName, Archive, DirInfo);
        while (DosError = 0) and (N < MAXFILE)
        and (MemAvail > SizeOf(String40)) do
          begin
            Inc(N);
            New(DirList[N]);
            DirList[N]^ := DirString(DirInfo);
            FindNext(DirInfo);
          end;

        if N = 0 then
          begin
            MsgErr(MSG_FILE_MATCH);
            ReadFileName := False;
            Exit;
          end;

        DirSort;

        Frame('', X1, Y1, X2, Y2, 2, ATT_FB, True);
        Window(X1 + 2, Y1 + 1, X2 - 1, Y2 - 1);

        FirstLine := 1;
        Select := 1;
        repeat
          DisplayPage;
          C := ReadCmd;
        until (C = ESCAPE) or (C = ENTER);
        if C = ENTER then
          FileName := CompleteFileName(ExtractDir(FileName) +
                                       RTrim(Copy(DirList[Select]^, 1, 12)));
        ReadFileName := (C = ENTER);
        for K := 1 to N do
          Dispose(DirList[K]);
      end
    else
      ReadFileName := True;
  end;

  function OpenInput(FileName : String; var F : Text) : Boolean;
  begin
    Assign(F, FileName);
    {$I-}
    Reset(F);
    {$I+}
    IOcheck;
    OpenInput := not IOerr;
  end;

  function OpenOutput(FileName : String; Replace : Boolean;
                      var F : Text) : Boolean;
  var
    Exist : Boolean;
  begin
    Assign(F, FileName);
    {$I-}
    Reset(F);
    Exist := (IoResult = 0);
    if Exist and (not Replace) then Append(F) else Rewrite(F);
    {$I+}
    IOcheck;
    OpenOutput := not IOerr;
  end;

  procedure ViewFile(FileName : String);
  type
    TextArr = array[1..MAXLINE] of ^String80;
  var
    InFile    : Text;     { Input file }
    T         : TextArr;  { Array of pointers to the lines }
    N_lines   : Integer;  { Nb of lines to be viewed }
    FirstLine : Integer;  { Index of first line displayed }
    C         : Char;     { Command character }
    K         : Integer;  { Loop variable }

    procedure DisplayTitle;
    begin
      GotoXY(1, 1);
      TextAttr := ATT_CD;
      ClrEol;
      Write(MSG_FILE);
      TextAttr := ATT_FB;
      Write(FileName);
      TextAttr := ATT_NT;
    end;

    procedure ReadFile;
    var
      L : String80;
    begin
      GotoXY(1, 25); TextAttr := ATT_CD;
      ClrEol; Write(CFill(MSG_FILE_READ, 80));
      while not EoF(InFile) do
        begin
          ReadLn(InFile, L);
          if (N_lines < MAXLINE) and (MemAvail > SizeOf(String80)) then
            begin
              Inc(N_lines);
              New(T[N_lines]);
              T[N_lines]^ := L;
            end;
        end;
      Close(InFile);
      TextAttr := ATT_NT;
    end;

    procedure DisplayLineNumbers;
    begin
      GotoXY(70 - Length(MSG_LINES), 1);
      TextAttr := ATT_CD; Write(MSG_LINES);
      TextAttr := ATT_FB; Write(FirstLine:5);
      TextAttr := ATT_CD; Write('-');
      TextAttr := ATT_FB; Write((FirstLine + 22):5);
      TextAttr := ATT_NT;
    end;

    procedure DisplayPage;
    var
      I, K : Integer;
    begin
      TextAttr := ATT_FD;
      K := FirstLine;
      for I := 2 to 24 do
        begin
          GotoXY(1, I);
          if K <= N_lines then Write(T[K]^);
          ClrEol;
          Inc(K);
        end;
      TextAttr := ATT_NT;
    end;

    procedure PrintFile;
    var
      K : Integer;
      C : Char;
    begin
      GotoXY(1, 25); TextAttr := ATT_CD; ClrEol;
      Write(CFill(MSG_FILE_PRINT, 80));
      K := 0; C := ' ';
      repeat
        Inc(K);
        WriteLn(Lst, T[K]^);
        if KeyPressed then C := ReadKey;
      until (K = N_lines) or (C = ESCAPE);
      TextAttr := ATT_NT;
    end;

    function ReadCmd : Char;
    { Reads a command key and scrolls the screen if necessary }
    var
      C1, C2 : Char;
    begin
      C1 := Upcase(ReadKey);
      if C1 = #0 then
        begin
          C2 := ReadKey;
          case C2 of
            _HOME      : FirstLine := 1;
            _END       : if N_lines > 22 then FirstLine := N_lines - 22;
            ARROW_UP   : if FirstLine > 1 then Dec(FirstLine);
            ARROW_DOWN : if FirstLine < N_lines - 22 then Inc(FirstLine);
            PAGE_UP    : if FirstLine > 23 then
                           Dec(FirstLine, 23)
                         else
                           FirstLine := 1;
            PAGE_DOWN  : if FirstLine < N_lines - 45 then
                           Inc(FirstLine, 23)
                         else if N_lines > 23 then
                           FirstLine := N_lines - 22;
          end;
        end;
      ReadCmd := C1;
    end;

  begin
    Window(1, 1, 80, 25);
    TextAttr := ATT_NT;
    N_lines := 0;
    Assign(InFile, FileName);
    {$I-}
    Reset(InFile);
    {$I+}
    if IoResult <> 0 then
      MsgErr(MSG_FILE_UNREAD + FileName)
    else
      begin
        ClrScr;
        DisplayTitle;
        ReadFile;
        FirstLine := 1;
        repeat
          DisplayCmdLine(MSG_CMD_VIEW, 25);
          DisplayLineNumbers;
          DisplayPage;
          C := ReadCmd;
          if C = ARROW_DOWN then PrintFile;
        until C = ESCAPE;
      end;
    for K := 1 to N_lines do
      Dispose(T[K]);
    TextAttr := ATT_NT;
    ClrScr;
  end;

  procedure DimEntryMask(var Mask : PEntryMask; N : Integer);
  var
    MaskSize : Word;
  begin
    if (N < 1) or (N > MAXFIELD) then
      Mask := nil
    else
      begin
        MaskSize := N * SizeOf(TEntryField);
        if MaskSize > MaxAvail then
          Mask := nil
        else
          begin
            GetMem(Mask, MaskSize);
            FillChar(Mask^, MaskSize, 0);
          end;
      end;
  end;

  procedure DelEntryMask(var Mask : PEntryMask; N : Integer);
  begin
    if Mask <> nil then
      begin
        FreeMem(Mask, N * SizeOf(TEntryField));
        Mask := nil;
      end;
  end;

  procedure InitStrField(X, Y : Integer; Msg : String;
                         Upper : Boolean; MaxLen : Integer; S : String;
                         var Field : TEntryField);
  begin
    Field.Code := S_FIELD;
    Field.X := X;
    Field.Y := Y;
    Field.Msg := Msg;
    if Field.Msg <> '' then
      Field.Msg := Field.Msg + ' ';
    Field.Long := MaxLen;
    Field.S := S;
    Field.Upper := Upper;
  end;

  procedure InitCharField(X, Y : Integer; Msg : String;
                          Opt : TOpt; Ch : Char;
                          var Field : TEntryField);
  var
    I : Integer;
  begin
    Field.Code := C_FIELD;
    Field.X := X;
    Field.Y := Y;
    Field.Msg := Msg;
    if Field.Msg <> '' then
      begin
        Field.Msg := Msg + ' (' + Upcase(Opt[1]);
        for I := 2 to Length(Opt) do
          Field.Msg := Field.Msg + '/' + Upcase(Opt[I]);
        Field.Msg := Field.Msg + ') ';
      end;
    Field.Long := 1;
    Field.S := Ch;
    Field.Upper := True;
    Field.Opt := Opt;
    Field.C := Ch;
  end;

  procedure InitIntField(X, Y : Integer; Msg : String;
                         NLo, NHi, N : Integer;
                         var Field : TEntryField);
  var
    LI, LS, NC : Integer;
    SI, SS : String[6];
  begin
    Field.Code := N_FIELD;
    Field.X := X;
    Field.Y := Y;
    Field.Msg := Msg;
    Str(Trunc(NLo), SI); LI := Length(SI);
    Str(Trunc(NHi), SS); LS := Length(SS);
    if LS > LI then NC := LS else NC := LI;
    Field.Msg := Msg;
    if Field.Msg <> '' then
      Field.Msg := Field.Msg + ' (' + SI + ' to ' + SS + ') ';
    Field.Long := NC;
    Field.S := LTrim(IntToStr(N));
    Field.Upper := True;
    Field.NLo := NLo;
    Field.NHi := NHi;
    Field.N := N;
  end;

  procedure InitFloatField(X, Y : Integer; Msg : String;
                           FLo, FHi, F : Float;
                           var Field : TEntryField);
  var
    Z : Boolean;
  begin
    Field.Code := F_FIELD;
    Field.X := X;
    Field.Y := Y;
    Field.Msg := Msg;
    if Field.Msg <> '' then
      Field.Msg := Field.Msg + ' ';
    Field.Long := NumLength;
    Z := NSZero;
    NSZero := False;
    Field.S := Trim(FloatToStr(F));
    NSZero := Z;
    Field.Upper := True;
    Field.FLo := FLo;
    Field.FHi := FHi;
    Field.F := F;
  end;

  procedure DisplayField(var Field : TEntryField; Select : Boolean);
  { Displays an entry field. Select indicates if the field is selected }
  begin
    with Field do
      begin
        GotoXY(X, Y);
        TextAttr := ATT_PM;
        Write(Msg + '[');
        if Select then
          TextAttr := ATT_IV
        else
          TextAttr := ATT_ES;
        Write(RFill(S, Long));
        TextAttr := ATT_PM;
        Write(']');
      end;
    TextAttr := ATT_NT;
  end;

  function ValidEntry(var S : String; var Field : TEntryField) : Boolean;
  { Checks if an entry is valid. If so, stores it in Field }
  var
    ErrCode : Integer;
    Ok, Z   : Boolean;
  begin
    Z := NSZero;
    NSZero := False;
    ErrCode := 0;
    Ok := True;
    S := Trim(S);
    case Field.Code of
      C_FIELD : begin
                  Ok := (S <> '') and (Pos(S, Field.Opt) > 0);
                  if Ok then Field.C := S[1];
                end;
      N_FIELD : begin
                  if S = '' then
                    Field.N := 0
                  else
                    Val(S, Field.N, ErrCode);
                  Ok := (ErrCode = 0);
                  if Field.NLo < Field.NHi then
                    Ok := Ok and (Field.N >= Field.NLo)
                             and (Field.N <= Field.NHi);
                end;
      F_FIELD : begin
                  if S[1] = '.' then S := '0' + S;
                  if S = '' then
                    Field.F := 0
                  else
                    Val(S, Field.F, ErrCode);
                  Ok := (ErrCode = 0);
                  if Field.FLo < Field.FHi then
                    Ok := Ok and (Field.F >= Field.FLo)
                             and (Field.F <= Field.FHi);
                  S := Trim(FloatToStr(Field.F));
                end;
    end;
    if Ok then
      begin
        Field.S := S;
        DisplayField(Field, False);
      end
    else
      begin
        S := '';
        Write(^G);
      end;
    NSZero := Z;
    ValidEntry := Ok;
  end;

  function ReadField(var Field : TEntryField) : Char;
  { ----------------------------------------------------------------------
    Reads the selected field. Returns the code of the key pressed to exit.
    ---------------------------------------------------------------------- }
  var
    X0, Y0, X1, X, K, L : Integer;
    Ext, Ins, First     : Boolean;
    S                   : String;
    C                   : Char;
  begin
    DisplayField(Field, True);
    Y0 := Field.Y;                          { Line of entry field }
    X0 := Field.X + Length(Field.Msg) + 1;  { First column of entry field }
    X1 := X0 + Pred(Field.Long);            { Last column of entry field }
    S := Field.S;
    Ins := False;                           { Replace characters }
    First := True;                          { First character }
    FlatCursor;
    X := X0;                                { Current cursor position }

    repeat
      L := Length(S);
      GotoXY(X0, Y0);
      TextAttr := ATT_IV;
      Write(RFill(S, Field.Long));
      if S = '' then X := X0;
      GotoXY(X, Y0);
      K := X - X0 + 1;                      { Current character position }
      Ext := False;
      C := ReadKey;
      if Field.Upper then
        C := Upcase(C);
      case C of
        #0 : begin                          { Cursor key }
               Ext := True;
               C := ReadKey;
               case C of
                 _HOME       : X := X0;
                 _END        : if X < X1 then
                                 X := X0 + L
                               else if X > X1 then
                                 X := X1;
                 ARROW_LEFT  : if X > X0 then Dec(X);
                 ARROW_RIGHT : if (X < X0 + L) and (X < X1) then Inc(X);
                 _INS        : begin
                                 Ins := not Ins;
                                 if Ins then FullCursor else FlatCursor;
                               end;
                 _DEL        : if K <= L then Delete(S, K, 1);
               end;
             end;

        BACKSPACE : if X > X0 then
                      begin
                        Delete(S, Pred(K), 1);
                        Dec(X);
                      end;

        ESCAPE : begin
                   DisplayField(Field, False);
                   TextAttr := ATT_NT;
                   ReadField := C;
                   HideCursor;
                   Exit;
                 end;

        #32..#255 : begin                   { Character }
                      case First of
                        True  : S := C;     { 1st hit char. replaces string }
                        False : case Ins of
                                  True  : if L < Field.Long then
                                            Insert(C, S, K);
                                  False : if K <= L then
                                            S[K] := C
                                          else
                                            S := S + C;
                                end;
                      end;
                      if X < X1 then Inc(X);
                    end;
      end;
      First := False;
    until ((C in [TAB, ENTER]) or
           (Ext and (C in [ARROW_UP, ARROW_DOWN, PAGE_UP, PAGE_DOWN,
                           CTRL_HOME, CTRL_END, SHIFT_TAB])))
          and ValidEntry(S, Field);

    TextAttr := ATT_NT;
    ReadField := C;
    HideCursor;
  end;

  function ReadMask(Mask : PEntryMask; N : Integer) : Char;
  var
    Done : Boolean;
    I    : Integer;
    C    : Char;
  begin
    DisplayCmdLine(MSG_CMD_MASK, 25);
    for I := 1 to N do
      DisplayField(Mask^[I], False);
    I := 1;
    Done := False;
    repeat
      C := ReadField(Mask^[I]);
      case C of
        ARROW_UP,
        SHIFT_TAB  : if I = 1 then I := N else I := Pred(I);
        ARROW_DOWN,
        TAB        : if I = N then I := 1 else I := Succ(I);
        ENTER      : if I = N then Done := True else I := Succ(I);
        PAGE_UP,
        PAGE_DOWN,
        CTRL_HOME,
        CTRL_END   : Done := True;
      end;
    until Done or (C = ESCAPE);
    ReadMask := C;
  end;

  function ReadString(X, Y : Integer; Msg : String; Upper : Boolean;
                      MaxLen : Integer; var S : String) : Boolean;
  var
    Field : TEntryField;
  begin
    InitStrField(X, Y, Msg, Upper, MaxLen, S, Field);
    if ReadField(Field) = ESCAPE then
      ReadString := False
    else
      begin
        ReadString := True;
        S := Field.S;
      end;
  end;

  function ReadChar(X, Y : Integer; Msg : String; Opt : TOpt;
                    var Ch : Char) : Boolean;
  var
    Field : TEntryField;
  begin
    InitCharField(X, Y, Msg, Opt, Ch, Field);
    if ReadField(Field) = ESCAPE then
      ReadChar := False
    else
      begin
        ReadChar := True;
        Ch := Field.C;
      end;
  end;

  function ReadInteger(X, Y : Integer; Msg : String; NLo, NHi : Integer;
                       var N : Integer) : Boolean;
  var
    Field : TEntryField;
  begin
    InitIntField(X, Y, Msg, NLo, NHi, N, Field);
    if ReadField(Field) = ESCAPE then
      ReadInteger := False
    else
      begin
        ReadInteger := True;
        N := Field.N;
      end;
  end;

  function ReadFloat(X, Y : Integer; Msg : String; FLo, FHi : Float;
                     var F : Float) : Boolean;
  var
    Field : TEntryField;
  begin
    InitFloatField(X, Y, Msg, FLo, FHi, F, Field);
    if ReadField(Field) = ESCAPE then
      ReadFloat := False
    else
      begin
        ReadFloat := True;
        F := Field.F;
      end;
  end;

  function YesNo(X, Y : Integer; Msg : String; var Ans : Boolean) : Boolean;
  var
    Field : TEntryField;
    C     : Char;
  begin
    if Ans then C := 'Y' else C := 'N';
    InitCharField(X, Y, Msg, 'YN', C, Field);
    if ReadField(Field) = ESCAPE then
      YesNo := False
    else
      begin
        YesNo := True;
        Ans := (Field.C = 'Y');
      end;
  end;

  procedure ChangeDir;
  var
    Mask : PEntryMask;
    Ch   : Char;
    L    : Integer;
    S    : SearchRec;
  begin
    DimEntryMask(Mask, 2);
    InitStrField(13, 7, MSG_DEF_DIR, True, 53- Length(MSG_DEF_DIR),
                 DefDir, Mask^[1]);
    InitStrField(13, 9, MSG_DEF_EXT, True, 3, DefExt, Mask^[2]);
    Frame('', 10, 5, 71, 11, 1, ATT_FB, True);
    repeat
      Ch := ReadMask(Mask, 2);
      if Ch <> ESCAPE then
        begin
          DefDir := Mask^[1].S;
          DefExt := Mask^[2].S;
          L := Length(DefDir);
          if DefDir[L] = '\' then
            Delete(DefDir, L, 1);
          {$I-}
          FindFirst(DefDir, Directory, S);
          {$I+}
          IOcheck;
        end;
    until (Ch = ESCAPE) or (not IOerr);
    DelEntryMask(Mask, 2);
  end;

  procedure DimPickList(var List : PPickList; N : Integer);
  var
    ListSize : Word;
  begin
    if (N < 1) or (N > MAXELEM) then
      List := nil
    else
      begin
        ListSize := Succ(N) * SizeOf(String80);
        if ListSize > MaxAvail then
          List := nil
        else
          begin
            GetMem(List, ListSize);
            FillChar(List^, ListSize, 0);
          end;
      end;
  end;

  procedure DelPickList(var List : PPickList; N : Integer);
  begin
    if List <> nil then
      begin
        FreeMem(List, Succ(N) * SizeOf(String80));
        List := nil;
      end;
  end;

  procedure WriteElem(X, Y : Integer; Mark : Char; Elem : String);
  { Writes a non-selected element, preceded by character Mark }
  begin
    GotoXY(X, Y);
    TextAttr := ATT_HC;
    Write(Mark);
    GotoXY(X, Y);
    TextAttr := ATT_HC;
    Write(Mark);
    TextAttr := ATT_CD;
    Write(Elem, ' ');
  end;

  procedure WriteSelectedElem(X, Y : Integer; Mark : Char; Elem : String);
  { Writes a selected element, preceded by character Mark }
  begin
    GotoXY(X, Y);
    TextAttr := ATT_IV;
    Write(Mark, Elem, ' ');
  end;

  procedure InitPick(Nelem, FirstLine, Ncol : Integer;
                     List : PPickList; X, Y : PIntVector;
                     var Init : String);
  { --------------------------------------------------------------------
    Initializes list parameters :
      - vectors X, Y (element coordinates)
      - string Init (initials of element names)
    Draws a frame around the list
    -------------------------------------------------------------------- }
  var
    W, WT, L1, L2, C1, C2, I, L, K, C : Integer;
    Title : String;
  begin
    W := Length(List^[1]) + 2;    { Column width }
    WT := Ncol * W;               { Total width }
    L1 := FirstLine;
    L2 := L1 + (Nelem div Ncol);  { Last line }
    if Nelem mod Ncol = 0 then
      Dec(L2);
    C1 := (80 - WT) div 2 + 1;    { First column }
    C2 := C1 + WT - 1;            { Last column }
    I := 1;
    for L := L1 to L2 do
      begin
        C := C1;
        for K := 1 to Ncol do
          if I <= Nelem then
            begin
              Y^[I] := L;         { Position of element }
              X^[I] := C;
              Inc(I);
              Inc(C, W);
            end;
      end;
    HideCursor;
    Title := List^[0];
    if Length(Title) > WT - 2 then Title := '';
    if (FirstLine > 1) and (C1 > 1) then
      Frame(Title, Pred(C1), Pred(L1), Succ(C2), Succ(L2), 1, ATT_FB, False);
    C := X^[Nelem] + W;           { Complete last line with blanks }
    if C < C2 then
      begin
        GotoXY(C, Y^[Nelem]);
        TextAttr := ATT_CD;
        Write(StrChar(C2 - C + 1, ' '));
      end;
    Init := '';                   { Initials of options }
    for I := 1 to Nelem do
      Init := Init + Upcase(List^[I][1]);
  end;

  procedure MovePointer(Nelem, Ncol, I : Integer; Init : String;
                        var J : Integer; var Ch : Char);
  { --------------------------------------------------------------------
    Moves pointer from element I to element J
    Returns the code of the key used to move the pointer
    -------------------------------------------------------------------- }
  var
    P : Integer;
  begin
    Ch := Upcase(ReadKey);
    case Ch of
      'A'..'Z',              { Initial of option }
      '0'..'9' : begin
                   P := Pos(Ch, Copy(Init, I + 1, Nelem - I));
                   if P > 0 then
                     J := P + I
                   else
                     begin
                       P := Pos(Ch, Init);
                       if P > 0 then J := P;
                     end;
                 end;
      #0 : begin             { Cursor key }
             Ch := ReadKey;
             case Ch of
               ARROW_LEFT  : if I > 1 then J := Pred(I) else J := Nelem;
               ARROW_RIGHT : if I < Nelem then J := Succ(I) else J := 1;
               ARROW_UP    : if I > Ncol then J := I - Ncol;
               ARROW_DOWN  : if I <= Nelem - Ncol then J := I + Ncol;           { Low }
               _HOME       : J := 1;
               _END        : J := Nelem;
             end;
           end;
    end;
  end;

  function Pick(Nelem, Ncol, FirstLine : Integer; List : PPickList;
                var Select : Integer) : Boolean;
  var
    I, J : Integer;
    X, Y : PIntVector;
    Init : String;
    Ch   : Char;
    Esc  : Boolean;
  begin
    DimIntVector(X, Nelem);
    DimIntVector(Y, Nelem);
    DisplayCmdLine(MSG_CMD_PICK, 25);
    InitPick(Nelem, FirstLine, Ncol, List, X, Y, Init);
    J := Select;
    if not(J in [1..Nelem]) then J := 1;
    WriteSelectedElem(X^[J], Y^[J], ' ', List^[J]);
    for I := 1 to Nelem do
      if I <> J then
        WriteElem(X^[I], Y^[I], ' ', List^[I]);
    repeat
      I := J;
      MovePointer(Nelem, Ncol, I, Init, J, Ch);
      WriteElem(X^[I], Y^[I], ' ', List^[I]);
      WriteSelectedElem(X^[J], Y^[J], ' ', List^[J]);
    until Ch in [ENTER, ESCAPE];
    Esc := (Ch = ESCAPE);
    if not Esc then Select := J;
    GotoXY(1, 25);
    TextAttr := ATT_NT;
    ClrEol;
    DelIntVector(X, Nelem);
    DelIntVector(Y, Nelem);
    Pick := not Esc;
  end;

  function MPick(Nelem, Ncol, FirstLine : Integer; List : PPickList;
                 Select : PBoolVector) : Boolean;
  const
    Mark : array[False..True] of Char = (' ', #16);
  var
    I, J, K : Integer;
    Init    : String;
    Ch      : Char;
    Esc     : Boolean;
    X, Y    : PIntVector;
    Temp    : PBoolVector;
  begin
    DimIntVector(X, Nelem);
    DimIntVector(Y, Nelem);
    DimBoolVector(Temp, Nelem);
    DisplayCmdLine(MSG_CMD_MPICK, 25);
    InitPick(Nelem, FirstLine, Ncol, List, X, Y, Init);
    J := 1;
    WriteSelectedElem(X^[J], Y^[J], Mark[Select^[J]], List^[J]);
    for I := 1 to Nelem do
      begin
        if I <> J then
          WriteElem(X^[I], Y^[I], Mark[Select^[I]], List^[I]);
        Temp^[I] := Select^[I];
      end;
    repeat
      I := J;
      MovePointer(Nelem, Ncol, I, Init, J, Ch);
      case Ch of
        ' ' : Temp^[J] := not Temp^[J];    { <SPACE> inverts selection }
        '>' : for K := 1 to Nelem do       { <F4> inverts all elements }
                Temp^[K] := not Temp^[K];
      end;
      for I := 1 to Nelem do
        if I <> J then
          WriteElem(X^[I], Y^[I], Mark[Temp^[I]], List^[I]);
      WriteSelectedElem(X^[J], Y^[J], Mark[Temp^[J]], List^[J]);
    until Ch in [ENTER, ESCAPE];
    Esc := (Ch = ESCAPE);
    if not Esc then
      for I := 1 to Nelem do
        Select^[I] := Temp^[I];
    GotoXY(1, 25); TextAttr := ATT_NT; ClrEol;
    DelIntVector(X, Nelem);
    DelIntVector(Y, Nelem);
    DelBoolVector(Temp, Nelem);
    MPick := not Esc;
  end;

  procedure DimMenu(var Menu : PMenu; N : Integer);
  var
    MenuSize : Word;
  begin
    if (N < 1) or (N > MAXELEM) then
      Menu := nil
    else
      begin
        MenuSize := Succ(N) * SizeOf(TMenuElem);
        if MenuSize > MaxAvail then
          Menu := nil
        else
          begin
            GetMem(Menu, MenuSize);
            FillChar(Menu^, MenuSize, 0);
          end;
      end;
  end;

  procedure DelMenu(var Menu : PMenu; N : Integer);
  begin
    if Menu <> nil then
      begin
        FreeMem(Menu, Succ(N) * SizeOf(TMenuElem));
        Menu := nil;
      end;
  end;

  procedure InitMenuElem(Opt : String40; Help : String80;
                       var Elem : TMenuElem);
  begin
    Elem.Opt := Opt;
    Elem.Help := Help;
  end;

  procedure WriteOption(Col : Integer; Elem : TMenuElem);
  { Writes the name of a non-selected menu option }
  var
    L, M : Integer;
  begin
    GotoXY(Col, 2);
    TextAttr := ATT_CD;
    Write(' ');
    L := Length(Elem.Opt);
    M := 0;
    repeat     { Search uppercase letter in option name }
      Inc(M);
    until (M > L) or (Elem.Opt[M] in ['A'..'Z']);
    if M > 1 then
      Write(Copy(Elem.Opt, 1, Pred(M)));
    TextAttr := ATT_HC;
    Write(Elem.Opt[M]);
    TextAttr := ATT_CD;
    Write(Copy(Elem.Opt, Succ(M), L - M), ' ');
  end;

  procedure WriteSelectedOption(Col : Integer; Elem : TMenuElem);
  { Writes the name and help text of the selected menu option }
  begin
    GotoXY(Col, 2);
    TextAttr := ATT_IV;
    Write(' ', Elem.Opt, ' ');
    GotoXY(1, 25);
    TextAttr := ATT_CD;
    ClrEol;
    Write(Elem.Help);
  end;

  procedure InitMenu(Nopt : Integer; Menu : PMenu;
                     X : PIntVector; var Cmd : String);
  { --------------------------------------------------------------------
    Initializes menu parameters :
      - vectors X (option horizontal coordinates)
      - string Cmd (command characters)
    Draws a frame around the menu
    -------------------------------------------------------------------- }
  var
    I, K, C : Integer;
    Title   : String;
  begin
    HideCursor;
    Title := Menu^[0].Opt;
    if Length(Title) > 78 then Title := '';
    Frame(Title, 1, 1, 80, 3, 1, ATT_FB, False);
    X^[1] := 2;
    for I := 2 to Nopt do
      X^[I] := X^[I - 1] + Length(Menu^[I - 1].Opt) + 2;
        { Complete end of line with blanks }
        C := X^[Nopt] + Length(Menu^[Nopt].Opt) + 1;
        if C < 80 then
          begin
            GotoXY(C, 2);
            TextAttr := ATT_CD;
            Write(StrChar(80 - C, ' '));
          end;
        Cmd := '';             { Command characters }
        for I := 1 to Nopt do
          begin                { Search for upper case letter  }
            K := 0;            { in option name, then add this }
            repeat             { character to the Cmd string   }
              Inc(K);
            until Menu^[I].Opt[K] in ['A'..'Z'];
        Cmd := Cmd + Menu^[I].Opt[K];
      end;
  end;

  procedure MoveOption(Nopt, I : Integer; Cmd : String;
                       var J : Integer; var Ch : Char);
  { --------------------------------------------------------------------
    Moves pointer from option I to option J
    Returns the code of the key used to move the pointer
    -------------------------------------------------------------------- }
  var
    P : Integer;
  begin
    Ch := Upcase(ReadKey);
    case Ch of
      'A'..'Z' : begin               { Command character }
                   P := Pos(Ch, Copy(Cmd, I + 1, Nopt - I));
                   if P > 0 then
                     J := P + I
                   else
                     begin
                       P := Pos(Ch, Cmd);
                       if P > 0 then J := P;
                     end;
                 end;
      #0 : case ReadKey of           { Cursor key }
             ARROW_LEFT  : if I > 1 then J := Pred(I) else J := Nopt;
             ARROW_RIGHT : if I < Nopt then J := Succ(I) else J := 1;
             _HOME       : J := 1;
             _END        : J := Nopt;
           end;
    end;
  end;

  function ReadMenu(Nopt : Integer; Menu : PMenu;
                    var Select : Integer) : Boolean;
  const
    J : Integer = 1;   { Index of selected element }
  var
    I   : Integer;
    X   : PIntVector;  { Columns where option names begin }
    Cmd : String;      { Command character string }
    Ch  : Char;
    Esc : Boolean;
  begin
    Esc := False;
    DimIntVector(X, Nopt);
    InitMenu(Nopt, Menu, X, Cmd);
    WriteSelectedOption(X^[J], Menu^[J]);
    for I := 1 to Nopt do
      if I <> J then WriteOption(X^[I], Menu^[I]);
    repeat
      I := J;
      MoveOption(Nopt, I, Cmd, J, Ch);
      WriteOption(X^[I], Menu^[I]);
      WriteSelectedOption(X^[J], Menu^[J]);
    until (Ch in [ENTER, ESCAPE]) or (Pos(Ch, Cmd) > 0);
    Esc := (Ch = ESCAPE);
    if not Esc then Select := J;
    TextAttr := ATT_NT;
    DelIntVector(X, Nopt);
    ReadMenu := not Esc;
  end;

begin
  GetDir(0, DefDir);  { 0 = Current drive }
  SaveCursor;
  HideCursor;
end.
