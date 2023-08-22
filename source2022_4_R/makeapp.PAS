unit MakeApp;
{this MakeApiForm unit, is an example for a One Size Fits All unit, that
can be used in many other programs, that need an API Main Form creation,
a GetMessage Loop procedure, a Menu and a simple MakeFont function.
there are 4 control creation functions}

interface

uses    // I have NO Units from any Program in the Uses clause
  Windows;

const
Zero = 0; // used so much, I made it a const
DEF = -1; // This is my DEFAULT value for Make functions

type
{the TPanelFunc if the function that will be called by the PanelMessFunc when
that panel's Windows message proc is called, you can use the three message
parameters to provide the methods (like WM_PAINT or button clicks) for that panel}
  PPanelFunc = ^TPanelFunc;
  TPanelFunc = function(iMsg, wParam, lParam: Integer): Integer;

{there are six styles of Panel creation, with a raised Edge, a Border, and a 
 "Tab Stop child control message handling" a psNone has none of these styles.
 a psEdge has only the raised Edge, a psTabEdge has both the Edge and the Tab 
 Stop, the psBorder has the WS_BORDER style, psTabBorder adds the Tab Stop.
 psTab has only the child control Tab Stop with WS_EX_CONTROLPARENT}

  TPanelStyle = (psEdge, psTabEdge, psBorder, psTabBorder, psTab, psNone);

{For Font Creation, there are four font settings in the TFontLook for the way
 a font will look on screen, flBold is for a Bold font, and the other three
 will give the font the look of their name}

  TFontLook = (flBold, flItalic, flUnderLine, flStrikeOut);
  TFontLooks = Set of TFontLook; // Used in th MakeFont( ) function


var
hMainMenu: Integer = Zero;
VarFont: Integer = Zero;
ShowCmdd: Integer = SW_SHOWDEFAULT;
{if you need to alter the show command in ShowWindow( ), you can change
this ShowCmdd before calling the  RunMsgLoop  procedure}



function SetWinClass(const ClassName: String; pMessFunc: Pointer;
                  wcStyle: Integer = CS_PARENTDC or CS_BYTEALIGNCLIENT): Word;
  {the SetWinClass function will get the ClassName and Message Function
   address, so it can register a new Window System Class for the Form here.
   This function MUST be called BEFORE the MakeForm function}

function MakeForm(Left, Top, Width, Height: Integer; const Caption: String;
                  WinStyle: Integer = DEF): Integer;
  {the MakeForm function will create the main window (form) using
   the class in wClassEx, this wClassEx is filled and registered in
   the SetWinClass procedure}

procedure RunMsgLoop(Show: Boolean = True);
  {the RunMsgLoop procedure will start the GetMessage loop
   to keep this program running}

function MakeFont(Height, Width: Integer; const FontName: String;
                 Look: TFontLooks = []; Roman: Boolean = False): Integer;
  {the MakeFont function will simplify Font creation, however you will
   loose the ability for many font create options}

function MakeButton(Left, Top, Width, Height: Integer; pCaption: PChar;
               hParent, ID_Number: Cardinal; hFont: Integer = DEF): Integer;
  {the MakeButton function will simplify Button creation, there are NO 
   style parameters and there is a hFont parameter, to set the font 
   for the button. This only makes a Push Button with a Tab Stop}

function MakeListBox(Left, Top, Width, Height, Parent: Integer;
                     const ListItems: String; WinStyle: Integer = DEF): Integer;
  {the MakeListBox function will create a ListBox control and place the Items
  in the ListItems string in the list box}

function MakeComboBox(Left, Top, Width, Height, Parent: Integer;
                     const ListItems: String; WinStyle: Integer = DEF): Integer;
  {the MakeComboBox function will create a ComboBox control and place the Items
  in the #0 delimited ListItems string in the list box}

function MakePanel(Left, Top, Width, Height, hParent: Integer; WndFunc: TPanelFunc;
                   ID_Number: Cardinal; Style: TPanelStyle = psTabEdge): Integer;
  {the MakePanel function will create a container window like the Delphi TPanel,
   it can have one of six panel styles, with a raised Edge, a Border or Tab Stop}

function MakeSubMenu(const ItemList: String; ID1, ID2: Cardinal;
                     hMenu: Integer = Zero): Integer;
  {the MakeSubMenu function is used to create a Main Menu for the MakeForm,
   with sub menus and menu Items}

function id4menu(a, b: Byte; c: Byte = Zero; d: Byte = Zero): Cardinal;
  {the id4menu function is used to set a Cardinal value to have 4 separate
   byte values for the two ID numbers in the MakeSubMenu function}

   procedure DoInitMakeApp;



implementation

uses
  Messages, CommCtrl, SmallUtils;


type
  TPanelRec = record
    Handle: Integer;
    WndFunc: TPanelFunc;
    end;

const
One = 1;
Two = 2;
n8 = 8;
n13 = 13;
E_WinClas1: PChar =
    'ERROR - in SetWinClass - Class Name or pMessProc parameter Incorrect';
E_WinClas2: PChar = 'ERROR - in SetWinClass - RegisterClassEx = FAILED';
E_MakeForm1: PChar = 'ERROR - in MakeForm - wClassEx is NOT registered';
E_MakeForm2: PChar = 'ERROR - in MakeForm - CreateWindow = FAILED';
E_MakeBut: PChar = 'ERROR - in MakeEZButton - CreateWindow = FAILED';
E_MakeMenu: PChar = 'ERROR - in MakeSubMenu - ItemList string is Incorrect';

E_TitleWinClas: PChar = 'SetWinClass  function  ERROR';
E_TitleMF: PChar = 'MakeForm  function  ERROR';
E_TitleButton: PChar = 'MakeButton  function  ERROR';
E_TitleMenu: PChar = 'MakeSubMenu  function  ERROR';
E_TitlePanel: PChar = 'MakePanel  function  ERROR';


var
wClassEx, PanelClass: TWndClassEx;
Atom1: Word = Zero;
FirstForm: Integer = Zero;
LBnum: Integer = Zero;
CBnum: Integer = Zero;
aryPanel: Array of TPanelRec;



procedure ErrorMsgBox(pText, pTitle: PChar);
begin
MessageBox(Zero, PChar(pText+#10+SysErrorMessage(GetLastError)),
           pTitle, MB_ICONERROR);
end;


function MakeFont(Height, Width: Integer; const FontName: String;
                 Look: TFontLooks = []; Roman: Boolean = False): Integer;
var
FontLog1: TLogFont;
begin
{this function simplifies Font Creation, you can
create a font with as few as 3 parameters}
ZeroMemory(@FontLog1, SizeOf(FontLog1));
with FontLog1 do
  begin
  lfHeight := Height;
  lfWidth := Width;
  if flBold in Look then
    lfWeight := FW_BOLD;
  if flItalic in Look then
    lfItalic := One;
  if flUnderline in Look then
    lfUnderline := One;
  if flStrikeOut in Look then
    lfStrikeOut := One;
  lfCharSet := DEFAULT_CHARSET;
  lfOutPrecision := OUT_TT_PRECIS;
  if Roman then
    lfPitchAndFamily := VARIABLE_PITCH or FF_ROMAN
    else
    lfPitchAndFamily := VARIABLE_PITCH or FF_SWISS;
  StrLCopy(@lfFaceName[Zero], PChar(FontName), 31);
  end;

Result := CreateFontIndirect(FontLog1);
end;



function MakeButton(Left, Top, Width, Height: Integer; pCaption: PChar;
               hParent, ID_Number: Cardinal; hFont: Integer = DEF): Integer;
begin
{this function simplifies button creation by including a Font
 parameter, which is used to set the button's font}
case hFont of
  DEF: hFont := VarFont;
  -2: hFont := GetStockObject(ANSI_FIXED_FONT);
  { -1 and -2 will get Var and Fixed Stock fonts}
  end;

Result := CreateWindow('Button', pCaption, WS_VISIBLE or WS_CHILD or WS_CLIPSIBLINGS
                         or BS_PUSHBUTTON or BS_TEXT or WS_TABSTOP, Left, Top,
                         Width, Height, hParent, ID_Number, hInstance, nil);
   {there is NO way to adjust the style, so this only makes a BS_PUSHBUTTON}
if Result = Zero then
  begin
  ErrorMsgBox(E_MakeBut, E_TitleButton);
  Exit;
  end;
if hFont <> Zero then
  SendMessage(Result, WM_SETFONT, hFont, Zero);
end;



function MakeListBox(Left, Top, Width, Height, Parent: Integer;
                     const ListItems: String; WinStyle: Integer = DEF): Integer;
var
Lim: Integer;
pGet: PChar;
begin
if WinStyle < Zero then
  WinStyle := WS_VISIBLE or WS_CHILD or LBS_NOTIFY
              or WS_VSCROLL or WS_CLIPSIBLINGS or WS_TABSTOP;

Result := CreateWindowEx(WS_EX_CLIENTEDGE,'LISTBOX',PChar('LB '+Int2Str(LBnum)),
            Cardinal(WinStyle),Left,Top,Width,Height,Parent,Zero,hInstance,nil);
if Result = Zero then Exit;
Inc(LBnum);
SendMessage(Result,WM_SETFONT,VarFont,Zero);

if (ListItems = '') or (ListItems[One] <> #255) or (Length(ListItems) < Two) then
  Exit;

pGet := @ListItems[Two];
Lim := Zero;
while (Lim < 256) do
  begin
  Inc(Lim);
  SendMessage(Result, LB_ADDSTRING, Zero, Integer(pGet));
  pGet := StrEnd(pGet);
  Inc(pGet);
  if pGet^ = #0 then Break;
  end;
end;


function MakeComboBox(Left, Top, Width, Height, Parent: Integer;
                     const ListItems: String; WinStyle: Integer = DEF): Integer;
var                                      {WinStyle defaults to Def, -1 }
Lim: Integer;
pGet: PChar;
    {the 4 variables below are used to get the correct Simple Combo Size}
hChild: Integer;
pnt: TPoint;
eRect, LBRect: TRect;

begin
{a -1 (DEF) in the WinStyle will get the Default style Flags}
if WinStyle < Zero then
  WinStyle := WS_VISIBLE or WS_CHILD or CBS_DROPDOWN or
  WS_CLIPSIBLINGS or WS_TABSTOP or WS_VSCROLL;

Result := CreateWindow('COMBOBOX',PChar('cb'+Int2Str(CBnum)),
        Cardinal(WinStyle),Left,Top,Width,Height,Parent,Zero,hInstance,nil);
{the ID of the Combo Box is set to the ID_Combo0+ ComboNumber}
if Result = Zero then Exit;
Inc(CBnum);
SendMessage(Result,WM_SETFONT,VarFont, Zero);

  {if you create a Simple Combo Box, that is NOT in a Dialog window,
   it WILL NOT size and paint correctly, The following code will 
   correctly "Size" a simple combo box.}

if (WinStyle and CBS_SIMPLE) <> Zero then
  begin
  pnt.x := n8;
  pnt.y := 6;

  hChild := ChildWindowFromPoint(Result, pnt);
  if hChild <> Zero then
    begin
    GetWindowRect(hChild, eRect);
    pnt.x := n8;
    pnt.y := (eRect.Bottom - eRect.Top)+6;
    hChild := ChildWindowFromPoint(Result, pnt);
    if hChild <> Zero then
      begin
      if GetWindowRect(hChild, LBRect) then
      MoveWindow(Result, Left, Top, Width,(LBRect.bottom - eRect.Top) +3, False);
      end;
    end;
  end;


{I have a method to use One string (ListItems), as a #0 delimited string to
add all of the Items to this combo box at once. Just to show you, I have
placed the  #255  charater, at the begining of the string and test for it.
I set a PChar variable pGet to the memory address of the second charcter
in the ListItems string}
if (ListItems <> '') and (ListItems[One] = #255) then
  begin
  pGet := @ListItems[Two];
  Lim := Zero; {LIM is just a "Safety" test in-case you forget to put an extra
  #0 at the end of your ListItems string}
  while Lim < 256 do
    begin
    Inc(Lim);
    SendMessage(Result,CB_ADDSTRING, Zero, Integer(pGet));
{the CB_ADDSTRING message will only read the ListItems string until the next #0}
    pGet := StrEnd(pGet);
{reset the pGet pointer to the next charater after the #0 ,
 with StrEnd and Inc(pGet)}
    Inc(pGet);
    if pGet^ = #0 then Break;
 {you will need to have a #0 at the end of your ListItems string,
  so this while loop will end}
    end;
  SendMessage(Result, CB_SETCURSEL, Zero, Zero);
  end;
end;


function PanelMessFunc(hWnd, Msg, wParam, lParam: Integer): Integer; stdcall;
var
i: Integer;
begin
Result := -2;
for i := Zero to High(aryPanel) do
  if (aryPanel[i].Handle = hWnd) and (@aryPanel[i].WndFunc <> nil) then
    Result := aryPanel[i].WndFunc(Msg, wParam, LParam);
if Result = -2 then
  Result := DefWindowProc(hWnd,Msg,wParam,lParam);
end;

function MakePanel(Left, Top, Width, Height, hParent: Integer; WndFunc: TPanelFunc;
                   ID_Number: Cardinal; Style: TPanelStyle = psTabEdge): Integer;
var
ExStyle, wStyle: Cardinal;
begin
{this function creates a window control container like the delphi VCL TPanel.
In order to get the messages for buttons and other controls on this container
you will need a TPanelFunc and place that function in the WndFunc parameter}
if Length(aryPanel) = Zero then
  if RegisterClassEx(PanelClass) = Zero then
  begin
  Result := Zero;
  ErrorMsgBox('ERROR - in Makepanel - Failure Register Panel Class', E_TitlePanel);
  Exit;
  end;

wStyle := WS_CHILD or WS_CLIPSIBLINGS or WS_CLIPCHILDREN or WS_VISIBLE;
ExStyle := Zero;

case Style of
  psEdge: ExStyle := WS_EX_DLGMODALFRAME;
  psTabEdge: ExStyle := WS_EX_CONTROLPARENT or WS_EX_DLGMODALFRAME;
  psBorder: wStyle := wStyle or WS_BORDER;
  psTabBorder: begin
               ExStyle := WS_EX_CONTROLPARENT;
               wStyle := wStyle or WS_BORDER;
               end;
  psTab: ExStyle := WS_EX_CONTROLPARENT;
  end;

Result := CreateWindowEx(ExStyle,PanelClass.lpszClassName,
                        PChar('panel '+Int2Str(Length(aryPanel))), wStyle, Left,
                        Top, Width, Height, hParent, ID_Number, hInstance, nil);
if Result = Zero then
  begin
  ErrorMsgBox('ERROR - in MakePanel - Panel Window not Created', E_TitlePanel);
  Exit;
  end;
SetLength(aryPanel, Length(aryPanel)+One);
aryPanel[High(aryPanel)].Handle := Result;
aryPanel[High(aryPanel)].WndFunc := WndFunc;
end;


function id4menu(a, b: Byte; c: Byte = Zero; d: Byte = Zero): Cardinal;
begin
{this function will join 4 bytes into a DWord for a MakeSubMenu ID container}
Result := a or (b shl n8) or (c shl 16) or (d shl 24);
end;


function MakeSubMenu(const ItemList: String; ID1, ID2: Cardinal;
                     hMenu: Integer = Zero): Integer;
var
Lim, Flags, Enab, mID: Integer;
pGet, pSub: PChar;
begin
{this MakeSubMenu function is a way to make Menu creation have less lines
of code. But to keep it simple, it has Limited functionality. . .
You can not add more than 8 String type menu Items, And only ONE item
can have a sub-Menu. After the submenu is created, and you need more Items,
then you can use the menu Handle and API functions like  AppendMenu  or
InsertMenu to have more than 8 string items or more items with sub-menus}
Result := Zero;
if (ItemList = '') or (Length(ItemList) < 4) or
  (not ((ItemList[One] = #250) or (ItemList[One] = #251))) then
  begin
  SetLastError(n13);
  MessageBox(Zero, E_MakeMenu, E_TitleMenu, MB_ICONERROR);
  Exit;
  end;

pSub := nil;

{if ItemList[1] is #250 , then This sub-menu is added to the Main Menu
if ItemList[1] is #251 , then a separate, sub-menu is created
and NOT added to the main menu}
Enab := MF_STRING or MF_POPUP;
if ItemList[One] = #250 then
  begin
  pSub := @ItemList[Two];
  if pSub^ = #202 then
    begin
    Enab := Enab or MF_GRAYED;
    Inc(pSub);
    end;

  pGet := StrEnd(pSub);
  Inc(pGet);
  end else
  pGet := @ItemList[Two];

if pGet^ = #0 then
  begin
  SetLastError(n13);
  ErrorMsgBox('ERROR - in MakeSubMenu - No Menu Item Text Charaters', E_TitleMenu);
  Exit;
  end;

Result := CreateMenu;
if Result = Zero then
  begin
  ErrorMsgBox('ERROR - in MakeSubMenu - CreateMenu = FAILED', E_TitleMenu);
  Exit;
  end;

Lim := Zero;
while (Lim < 9) do
  begin
  if Lim = n8 then
    begin
    SetLastError(n13);
    ErrorMsgBox('ERROR - in MakeSubMenu - More Than 8 Menu Items', E_TitleMenu);
    Break;
    end;

  Flags := MF_STRING;
 {test for the menu Item options}
  case pGet^ of
   #200: begin
         Flags := MF_SEPARATOR;
         Inc(pGet);
         end;
   #201: begin
         Flags := Flags or MF_CHECKED;
         Inc(pGet);
         end;
   #202: begin
         Flags := Flags or MF_GRAYED;
         Inc(pGet);
         end;
   #203: begin
         Flags := Flags or MF_POPUP;
         Inc(pGet);
         end;
   end;

  mID := Zero;
  if Flags = MF_STRING or MF_POPUP then
    begin
    if hMenu = Zero then
      mID := DEF else
      mID := hMenu;
    end else
    if Flags = MF_SEPARATOR then mID := $200
    else
    case Lim of
      Zero: mID := ID1 and $FF;
      One: mID := (ID1 and $FF00) shr n8;
      Two: mID := (ID1 and $FF0000) shr 16;
      3: mID := ID1 shr 24;
      4: mID := ID2 and $FF;
      5: mID := (ID2 and $FF00) shr n8;
      6: mID := (ID2 and $FF0000) shr 16;
      7: mID := ID2 shr 24;
      {separate the bytes out of the ID numbers}
      end;

  if mID <> DEF then
    begin
    if not AppendMenu(Result, Flags, mID, pGet) then
      begin
      ErrorMsgBox('ERROR - in MakeSubMenu - AppendMenu = FAILED', E_TitleMenu);
      DestroyMenu(Result);
      Result := Zero;
      Exit;
      end;
    end else
    begin
    SetLastError(n13);
    ErrorMsgBox('ERROR - in MakeSubMenu - SubMenu handle is Zero', E_TitleMenu);
    end;

  pGet := StrEnd(pGet);
  Inc(pGet);
  if pGet^ = #0 then Break;
  if not ((Flags = MF_SEPARATOR) or (Flags = MF_STRING or MF_POPUP)) then
    Inc(Lim);
  end;

if pSub <> nil then
  begin
  if hMainMenu = Zero then
    hMainMenu := CreateMenu;
  AppendMenu(hMainMenu, Enab, Result, pSub);
  end;
end;


function SetWinClass(const ClassName: String; pMessFunc: Pointer;
                  wcStyle: Integer = CS_PARENTDC or CS_BYTEALIGNCLIENT): Word;
begin
{this function will set the wClassEx record and regsiter a new Class.
 You MUST call this function BEFORE you can call the MakeForm function}
Result := Zero;
{test the parameters}
if (Length(ClassName) < Two) or (pMessFunc = nil) then
  begin
  SetLastError(n13); // The data is invalid.
  ErrorMsgBox(E_WinClas1, E_TitleWinClas);
{the ErrorMsgBox procedure takes the string constants
 and shows an Error Message Box}
  Exit;
  end;

{I have 3 wcStyle preSets, , a CS_PARENTDC or CS_BYTEALIGNCLIENT if No
 parameter is set and a -1  and  -2  alternates}
if wcStyle = DEF then
  wcStyle := CS_PARENTDC
  else
  if wcStyle = -2 then
  wcStyle := CS_PARENTDC or CS_HREDRAW or CS_VREDRAW or CS_BYTEALIGNCLIENT
  else
  if wcStyle < -2 then
  wcStyle := Zero;

{the wClassEx was Filled with Zeros in the initialization}
with wClassEx do
  begin
  cbSize := SizeOf(wClassEx);
  Style := wcStyle;
  hInstance := SysInit.hInstance;
  hIcon := LoadIcon(hInstance,'MAINICON');
  lpfnWndProc := pMessFunc;
  hbrBackground := COLOR_BTNFACE+One;
  GetMem(lpszClassName, Length(ClassName)+One);
  StrCopy(lpszClassName, PChar(ClassName));
  hCursor := LoadCursor(Zero, IDC_ARROW);
  end;

Atom1 := RegisterClassEx(wClassEx); // Zero in Atom1 means Failure

if Atom1 = Zero then
  begin
  ErrorMsgBox(E_WinClas2, E_TitleWinClas);
  Exit;
  end;
Result := Atom1;
end;


function MakeForm(Left, Top, Width, Height: Integer; const Caption: String;
                  {hMenu: Integer;} WinStyle: Integer = DEF): Integer;
var
Rect1: TRect;
begin
Result := Zero;
{this function will check the Atom1 to see if the wClassEx was
registered and then Create the main Form Window with the parameters}
if Atom1 = Zero then
  begin
  SetLastError(n13); // The data is invalid.
  ErrorMsgBox(E_MakeForm1, E_TitleMF);
  Exit;
  end;


{I use -1  as the Default Value in this WinStyle parameter}
if WinStyle < Zero then
  WinStyle := WS_CAPTION or WS_MINIMIZEBOX or WS_SYSMENU or WS_CLIPCHILDREN;


if Width < Zero then
  begin
  Width := -Width;
  SetRect(Rect1, Zero, Zero,Width,Height);
  end else
  begin
  SetRect(Rect1, Zero, Zero,Width,Height);
  if not AdjustWindowRect(Rect1, WinStyle,False) then
  SetRect(Rect1, Zero, Zero, Width+6, Height+26);
  end;

{if Top is -1 (Default) then the form is centered in the screen vertical}
if Top < Zero then
  Top :=(GetSystemMetrics(SM_CYSCREEN) shr One)-((Rect1.Bottom-Rect1.Top) shr One);

{if Left is -1 (Default) then the form is centered in the screen horizontal}
if Left < Zero then
  Left :=(GetSystemMetrics(SM_CXSCREEN) shr One)-((Rect1.Right-Rect1.Left) shr One);

Result := CreateWindow(wClassEx.lpszClassName, PChar(Caption), WinStyle,
                Left, Top, Rect1.Right-Rect1.Left,
                Rect1.Bottom-Rect1.Top, Zero, hMainMenu, hInstance, nil);
                
if FirstForm = Zero then
  FirstForm := Result;
if Result = Zero then
  ErrorMsgBox(E_MakeForm2, E_TitleMF);
end;



procedure RunMsgLoop(Show: Boolean = True);
var
MainMsg: TMSG;
begin
if FirstForm = Zero then
  begin
  SetLastError(n13);
  ErrorMsgBox('ERROR - in RunMsgLoop - FirstForm is Zero',
              'ERROR, No Form has been created');
  Exit;
  end;
{this RunMsgLoop procedure will run the GetMessage Loop to keep
this program running, I have included a Show parameter, if False the
Main Window will not be visible}
if Show then
  ShowWindow(FirstForm, ShowCmdd);

while GetMessage(MainMsg,Zero,Zero,Zero) do
  begin
  if not IsDialogMessage(FirstForm, MainMsg) then
    begin
    TranslateMessage(MainMsg);
    DispatchMessage(MainMsg);
    end;
  end;
end;

procedure DoInitMakeApp;
begin
{I will fill the wClassEx and PanelClass with Zeros}
ZeroMemory(@wClassEx, SizeOf(wClassEx));
ZeroMemory(@PanelClass, SizeOf(PanelClass));
VarFont := GetStockObject(ANSI_VAR_FONT);

with PanelClass do
  begin
  cbSize := SizeOf(PanelClass);
  Style := CS_BYTEALIGNWINDOW;
  hInstance := SysInit.hInstance;
  lpfnWndProc := @PanelMessFunc;
  hbrBackground := COLOR_BTNFACE+One;
  lpszClassName := 'hPanel Class';
  hCursor := LoadCursor(Zero, IDC_ARROW);
  end;
InitCommonControls;
// I will get the ComControl library in this process
end;


initialization
//DoInit

finalization
if wClassEx.lpszClassName <> nil then
  FreeMem(wClassEx.lpszClassName);


end.

//----code_cleared_checked_clean----